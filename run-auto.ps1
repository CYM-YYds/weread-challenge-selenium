<#
.SYNOPSIS
    WeRead Challenge - 自动执行脚本（用于任务计划程序）
.DESCRIPTION
    这个PowerShell脚本专门用于任务计划程序，确保每天只执行一次
.EXAMPLE
    PS> .\run-auto.ps1
.NOTES
    Author: WeRead Challenge Team
    用于Windows任务计划程序的自动执行
#>

# 设置脚本位置为当前目录
Set-Location -Path $PSScriptRoot

# 创建日志函数
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp][$Level] $Message"
    
    # 确保data目录存在
    if (-not (Test-Path "data")) {
        New-Item -ItemType Directory -Path "data" | Out-Null
    }
    
    # 写入日志文件
    Add-Content -Path "data\auto-run.log" -Value $logMessage
    
    # 同时输出到控制台（如果有的话）
    Write-Host $logMessage -ForegroundColor $(
        switch ($Level) {
            "ERROR" { "Red" }
            "WARN" { "Yellow" }
            "SUCCESS" { "Green" }
            default { "White" }
        }
    )
}

try {
    Write-Log "========== WeRead Challenge 自动执行开始 =========="
    
    # 检查今天是否已经执行过
    $today = Get-Date -Format "yyyy-MM-dd"
    $lastRunFile = "data\last-run.txt"
    
    if (Test-Path $lastRunFile) {
        $lastRunDate = Get-Content $lastRunFile -ErrorAction SilentlyContinue
        if ($lastRunDate -eq $today) {
            Write-Log "今天已经执行过了，跳过执行" "WARN"
            Write-Log "上次执行日期: $lastRunDate"
            Write-Log "========== 自动执行结束（已跳过） =========="
            exit 0
        }
    }
    
    Write-Log "今天还未执行，准备开始执行"
    
    # 等待网络连接（最多等待5分钟）
    Write-Log "检查网络连接..."
    $maxWaitTime = 300 # 5分钟
    $waitTime = 0
    $networkReady = $false
    
    while ($waitTime -lt $maxWaitTime) {
        try {
            $ping = Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet -ErrorAction SilentlyContinue
            if ($ping) {
                $networkReady = $true
                Write-Log "网络连接正常"
                break
            }
        } catch {
            # 忽略ping错误
        }
        
        Write-Log "等待网络连接... ($waitTime/$maxWaitTime 秒)"
        Start-Sleep -Seconds 30
        $waitTime += 30
    }
    
    if (-not $networkReady) {
        Write-Log "网络连接超时，但继续尝试执行" "WARN"
    }
    
    # 额外等待2分钟，确保系统完全启动
    Write-Log "等待系统完全启动（2分钟）..."
    Start-Sleep -Seconds 120
    
    # 检查必要文件
    if (-not (Test-Path "src\weread-challenge.js")) {
        Write-Log "主程序文件不存在: src\weread-challenge.js" "ERROR"
        exit 1
    }
    
    if (-not (Test-Path "package.json")) {
        Write-Log "package.json文件不存在" "ERROR"
        exit 1
    }
    
    # 检查Node.js
    try {
        $nodeVersion = node --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Node.js版本: $nodeVersion"
        } else {
            Write-Log "Node.js未安装或不可用" "ERROR"
            exit 1
        }
    } catch {
        Write-Log "Node.js检查失败: $($_.Exception.Message)" "ERROR"
        exit 1
    }
    
    # 检查依赖
    if (-not (Test-Path "node_modules")) {
        Write-Log "依赖未安装，尝试安装..." "WARN"
        npm install
        if ($LASTEXITCODE -ne 0) {
            Write-Log "依赖安装失败" "ERROR"
            exit 1
        }
        Write-Log "依赖安装成功"
    }
    
    # 设置环境变量
    Write-Log "设置环境变量..."
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
    
    # 执行主程序
    Write-Log "开始执行WeRead Challenge..."
    Write-Log "配置: 阅读10分钟，邮件通知已启用"
    
    $startTime = Get-Date
    node src\weread-challenge.js
    $endTime = Get-Date
    $duration = ($endTime - $startTime).TotalMinutes
    
    if ($LASTEXITCODE -eq 0) {
        Write-Log "WeRead Challenge执行成功，耗时: $([math]::Round($duration, 2))分钟" "SUCCESS"
        
        # 记录今天已执行
        $today | Out-File -FilePath $lastRunFile -Encoding UTF8
        Write-Log "已记录执行日期: $today"
        
    } else {
        Write-Log "WeRead Challenge执行失败，退出代码: $LASTEXITCODE" "ERROR"
    }
    
    Write-Log "========== WeRead Challenge 自动执行结束 =========="

} catch {
    Write-Log "自动执行过程中发生错误: $($_.Exception.Message)" "ERROR"
    Write-Log "错误位置: 第 $($_.InvocationInfo.ScriptLineNumber) 行" "ERROR"
    Write-Log "========== 自动执行异常结束 =========="
    exit 1
}
