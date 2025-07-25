<#
.SYNOPSIS
    WeRead Challenge - 简化运行脚本
.DESCRIPTION
    这是最简化的PowerShell脚本，用于快速启动WeRead Challenge
.EXAMPLE
    PS> .\run-simple.ps1
.NOTES
    Author: WeRead Challenge Team
    简化版本，最少的检查和输出
#>

try {
    Write-Host "正在启动WeRead Challenge..." -ForegroundColor Green

    # 设置环境变量
    $env:WEREAD_DURATION = "10"
    $env:ENABLE_EMAIL = "true"
    $env:EMAIL_SMTP = "smtp.whut.edu.cn"
    $env:EMAIL_PORT = "587"
    $env:EMAIL_USER = "322422@whut.edu.cn"
    $env:EMAIL_PASS = "Vm3Zgz6AtGJj9JFE"
    $env:EMAIL_FROM = "322422@whut.edu.cn"
    $env:EMAIL_TO = "322422@whut.edu.cn"

    # 创建data目录
    if (-not (Test-Path "data")) {
        New-Item -ItemType Directory -Path "data" | Out-Null
    }

    # 运行程序
    node src\weread-challenge.js

    Write-Host ""
    Write-Host "程序已结束。按任意键退出..." -ForegroundColor Gray

} catch {
    Write-Host "错误: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "按任意键退出..." -ForegroundColor Gray
}

Read-Host
