<#
.SYNOPSIS
    WeRead Challenge - 数据清理脚本
.DESCRIPTION
    这个PowerShell脚本用于清理WeRead Challenge程序产生的数据
.EXAMPLE
    PS> .\clean-data.ps1
.NOTES
    Author: WeRead Challenge Team
    清理登录状态、截图和日志文件
#>

try {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "WeRead Challenge - 数据清理脚本" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "[警告] 此操作将删除以下数据：" -ForegroundColor Red
    Write-Host "  - 登录状态 (cookies.json)" -ForegroundColor White
    Write-Host "  - 截图文件 (*.png)" -ForegroundColor White
    Write-Host "  - 日志文件 (output.log)" -ForegroundColor White
    Write-Host "  - 二维码文件 (login.png)" -ForegroundColor White
    Write-Host ""

    $choice = Read-Host "确定要清理所有数据吗？(y/N)"
    if ($choice -ne "y" -and $choice -ne "Y") {
        Write-Host "[信息] 操作已取消" -ForegroundColor Green
        Write-Host ""
        Write-Host "按任意键退出..." -ForegroundColor Gray
        Read-Host
        exit 0
    }

    Write-Host ""
    Write-Host "[信息] 正在清理数据..." -ForegroundColor Yellow

    # 检查data目录是否存在
    if (-not (Test-Path "data")) {
        Write-Host "[信息] data目录不存在，无需清理" -ForegroundColor Green
        Write-Host ""
        Write-Host "按任意键退出..." -ForegroundColor Gray
        Read-Host
        exit 0
    }

    $filesDeleted = 0

    # 删除cookies文件
    if (Test-Path "data\cookies.json") {
        Remove-Item "data\cookies.json" -Force
        Write-Host "[信息] 已删除登录状态文件" -ForegroundColor Green
        $filesDeleted++
    }

    # 删除截图文件
    $screenshots = Get-ChildItem "data\*.png" -ErrorAction SilentlyContinue
    if ($screenshots) {
        $screenshots | Remove-Item -Force
        Write-Host "[信息] 已删除 $($screenshots.Count) 个截图文件" -ForegroundColor Green
        $filesDeleted += $screenshots.Count
    }

    # 删除日志文件
    if (Test-Path "data\output.log") {
        Remove-Item "data\output.log" -Force
        Write-Host "[信息] 已删除日志文件" -ForegroundColor Green
        $filesDeleted++
    }

    # 检查data目录是否为空，如果为空则删除
    $remainingFiles = Get-ChildItem "data" -ErrorAction SilentlyContinue
    if (-not $remainingFiles) {
        Remove-Item "data" -Force
        Write-Host "[信息] 已删除空的data目录" -ForegroundColor Green
    }

    Write-Host ""
    if ($filesDeleted -gt 0) {
        Write-Host "[成功] 数据清理完成！共删除 $filesDeleted 个文件" -ForegroundColor Green
        Write-Host "[提示] 下次运行程序时需要重新登录" -ForegroundColor Yellow
    } else {
        Write-Host "[信息] 没有找到需要清理的文件" -ForegroundColor Green
    }

} catch {
    Write-Host ""
    Write-Host "⚠️ 错误发生在第 $($_.InvocationInfo.ScriptLineNumber) 行: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "按任意键退出..." -ForegroundColor Gray
Read-Host
