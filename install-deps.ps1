<#
.SYNOPSIS
    WeRead Challenge - 依赖安装脚本
.DESCRIPTION
    这个PowerShell脚本用于安装WeRead Challenge项目的依赖
.EXAMPLE
    PS> .\install-deps.ps1
.NOTES
    Author: WeRead Challenge Team
    需要Node.js和npm
#>

try {
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "WeRead Challenge - 依赖安装脚本" -ForegroundColor Cyan
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
        Write-Host "按任意键退出..." -ForegroundColor Gray
        Read-Host
        exit 1
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
        Write-Host "按任意键退出..." -ForegroundColor Gray
        Read-Host
        exit 1
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
        Write-Host "按任意键退出..." -ForegroundColor Gray
        Read-Host
        exit 1
    }

    Write-Host ""
    Write-Host "[信息] 正在安装项目依赖..." -ForegroundColor Green
    Write-Host "[信息] 这可能需要几分钟时间，请耐心等待..." -ForegroundColor Yellow
    Write-Host ""

    # 检查是否需要重新安装
    if (Test-Path "node_modules") {
        Write-Host "[信息] 发现已存在的node_modules目录" -ForegroundColor Yellow
        $choice = Read-Host "是否要重新安装依赖？(y/N)"
        if ($choice -eq "y" -or $choice -eq "Y") {
            Write-Host "[信息] 正在清理旧的依赖..." -ForegroundColor Yellow
            Remove-Item -Recurse -Force "node_modules" -ErrorAction SilentlyContinue
            Remove-Item -Force "package-lock.json" -ErrorAction SilentlyContinue
            Write-Host "[信息] 清理完成" -ForegroundColor Green
        } else {
            Write-Host "[信息] 跳过依赖安装" -ForegroundColor Green
            Write-Host ""
            Write-Host "按任意键退出..." -ForegroundColor Gray
            Read-Host
            exit 0
        }
    }

    # 安装依赖
    Write-Host "[信息] 开始安装依赖..." -ForegroundColor Green
    npm install
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "[成功] 依赖安装完成！" -ForegroundColor Green
        Write-Host "[信息] 已安装的主要依赖：" -ForegroundColor Cyan
        Write-Host "  - selenium-webdriver: 用于浏览器自动化" -ForegroundColor White
        Write-Host "  - nodemailer: 用于发送邮件通知" -ForegroundColor White
        Write-Host ""
        Write-Host "[提示] 现在可以运行 .\run-local.ps1 启动程序" -ForegroundColor Yellow
    } else {
        Write-Host ""
        Write-Host "[错误] 依赖安装失败" -ForegroundColor Red
        Write-Host "[建议] 请检查：" -ForegroundColor Yellow
        Write-Host "  1. 网络连接是否正常" -ForegroundColor White
        Write-Host "  2. npm配置是否正确" -ForegroundColor White
        Write-Host "  3. 是否有权限问题" -ForegroundColor White
        Write-Host ""
        Write-Host "[解决方案] 可以尝试：" -ForegroundColor Yellow
        Write-Host "  1. npm config set registry https://registry.npmmirror.com/" -ForegroundColor White
        Write-Host "  2. 以管理员身份运行此脚本" -ForegroundColor White
    }

} catch {
    Write-Host ""
    Write-Host "⚠️ 错误发生在第 $($_.InvocationInfo.ScriptLineNumber) 行: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "按任意键退出..." -ForegroundColor Gray
Read-Host
