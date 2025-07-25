<#
.SYNOPSIS
    WeRead Challenge - 本地运行脚本
.DESCRIPTION
    这个PowerShell脚本用于在Windows本地环境下运行WeRead Challenge程序
.EXAMPLE
    PS> .\run-local.ps1
.NOTES
    Author: WeRead Challenge Team
    需要Node.js和Chrome浏览器
#>

try {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "WeRead Challenge - 本地运行脚本" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""

    # 检查Node.js是否安装
    Write-Host "[调试] 检查Node.js安装..." -ForegroundColor Yellow
    try {
        $nodeVersion = node --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[信息] Node.js版本: $nodeVersion" -ForegroundColor Green
        } else {
            throw "Node.js未安装"
        }
    } catch {
        Write-Host "[错误] Node.js未安装" -ForegroundColor Red
        Write-Host "请从以下地址安装Node.js: https://nodejs.org/" -ForegroundColor Yellow
        Write-Host "建议安装LTS版本" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "按任意键继续或Ctrl+C退出..." -ForegroundColor Yellow
        Read-Host
    }

    # 检查npm是否可用
    Write-Host "[调试] 检查npm可用性..." -ForegroundColor Yellow
    try {
        $npmVersion = npm --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[信息] npm版本: $npmVersion" -ForegroundColor Green
        } else {
            throw "npm不可用"
        }
    } catch {
        Write-Host "[错误] npm不可用" -ForegroundColor Red
        Write-Host "npm通常随Node.js一起安装，请重新安装Node.js" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "按任意键继续或Ctrl+C退出..." -ForegroundColor Yellow
        Read-Host
    }

    # 检查package.json是否存在
    Write-Host "[调试] 检查package.json..." -ForegroundColor Yellow
    if (Test-Path "package.json") {
        Write-Host "[信息] package.json文件存在" -ForegroundColor Green
    } else {
        Write-Host "[错误] package.json文件不存在" -ForegroundColor Red
        Write-Host "当前目录: $(Get-Location)" -ForegroundColor Yellow
        Write-Host "请确保在项目根目录下运行此脚本" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "按任意键继续或Ctrl+C退出..." -ForegroundColor Yellow
        Read-Host
    }

    # 检查依赖是否安装
    Write-Host "[调试] 检查依赖..." -ForegroundColor Yellow
    if (Test-Path "node_modules") {
        Write-Host "[信息] 依赖已存在" -ForegroundColor Green
    } else {
        Write-Host "[信息] 依赖未安装，正在安装..." -ForegroundColor Yellow
        npm install
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[信息] 依赖安装成功" -ForegroundColor Green
        } else {
            Write-Host "[错误] 依赖安装失败" -ForegroundColor Red
            Write-Host "请检查网络连接或手动运行: npm install" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "按任意键继续或Ctrl+C退出..." -ForegroundColor Yellow
            Read-Host
        }
    }

    # 检查主程序文件是否存在
    Write-Host "[调试] 检查主程序文件..." -ForegroundColor Yellow
    if (Test-Path "src\weread-challenge.js") {
        Write-Host "[信息] 主程序文件存在" -ForegroundColor Green
    } else {
        Write-Host "[错误] 主程序文件 src\weread-challenge.js 不存在" -ForegroundColor Red
        Write-Host "当前目录: $(Get-Location)" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "按任意键继续或Ctrl+C退出..." -ForegroundColor Yellow
        Read-Host
    }

    # 创建data目录
    Write-Host "[调试] 创建data目录..." -ForegroundColor Yellow
    if (-not (Test-Path "data")) {
        New-Item -ItemType Directory -Path "data" | Out-Null
        Write-Host "[信息] data目录已创建" -ForegroundColor Green
    } else {
        Write-Host "[信息] data目录已存在" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "[信息] 正在启动WeRead Challenge..." -ForegroundColor Green
    Write-Host "[信息] 配置参数:" -ForegroundColor Cyan
    Write-Host "  - 阅读时长: 10分钟" -ForegroundColor White
    Write-Host "  - 邮件通知: 已启用" -ForegroundColor White
    Write-Host "  - SMTP服务器: smtp.whut.edu.cn" -ForegroundColor White
    Write-Host "  - 邮箱: 322422@whut.edu.cn" -ForegroundColor White
    Write-Host ""
    Write-Host "[提示] 程序启动后会自动打开浏览器" -ForegroundColor Yellow
    Write-Host "[提示] 请准备好微信扫码登录" -ForegroundColor Yellow
    Write-Host "[提示] 按Ctrl+C可以随时停止程序" -ForegroundColor Yellow
    Write-Host ""

    # 设置环境变量
    Write-Host "[调试] 设置环境变量..." -ForegroundColor Yellow
    $env:WEREAD_DURATION = "10"
    $env:ENABLE_EMAIL = "true"
    $env:EMAIL_SMTP = "smtp.whut.edu.cn"
    $env:EMAIL_PORT = "587"
    $env:EMAIL_USER = "322422@whut.edu.cn"
    $env:EMAIL_PASS = "Vm3Zgz6AtGJj9JFE"
    $env:EMAIL_FROM = "322422@whut.edu.cn"
    $env:EMAIL_TO = "322422@whut.edu.cn"
    Write-Host "[信息] 环境变量设置完成" -ForegroundColor Green

    # 运行主程序
    Write-Host "[调试] 启动主程序..." -ForegroundColor Yellow
    node src\weread-challenge.js

    Write-Host ""
    Write-Host "[信息] 程序已结束" -ForegroundColor Green
    Write-Host "[提示] 查看日志: Get-Content data\output.log" -ForegroundColor Yellow
    Write-Host "[提示] 清理数据: .\clean-data.ps1" -ForegroundColor Yellow
    Write-Host ""

} catch {
    Write-Host ""
    Write-Host "⚠️ 错误发生在第 $($_.InvocationInfo.ScriptLineNumber) 行: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

Write-Host "按任意键退出..." -ForegroundColor Gray
Read-Host
