<#
.SYNOPSIS
诊断当前安装的JDK版本

.DESCRIPTION
此脚本用于检测当前通过scoop安装的所有JDK版本，支持新版和旧版scoop的输出格式。

.EXAMPLE
PS> .\diagnose-jdk.ps1
#>

Write-Host "=== 当前安装的JDK列表 ===" -ForegroundColor Cyan

# 方法1：直接解析对象格式输出（适用于新版scoop）
$jdkApps = scoop list | Where-Object { $_ -like '*jdk*' -and $_ -notlike '*Installed apps:*' }
if ($jdkApps.Count -eq 0) {
    Write-Host "未找到任何JDK安装" -ForegroundColor Yellow
} else {
    foreach ($app in $jdkApps) {
        # 提取应用名称（从对象格式中提取）
        if ($app -match 'Name=([^;]+)') {
            $name = $matches[1]
            Write-Host "- $name" -ForegroundColor White
        }
    }
}

Write-Host "`n=== 使用scoop list的文本格式输出 ===" -ForegroundColor Cyan
# 方法2：使用文本格式输出（适用于旧版scoop）
scoop list | Out-String -Stream | Select-String 'jdk' | ForEach-Object {
    $line = $_.ToString().Trim()
    if ($line -and $line -notlike '*Installed apps:*' -and $line -notlike '*Name*Version*Source*') {
        $name = ($line -split '\s+')[0]
        if ($name -and $name -like '*jdk*') {
            Write-Host "- $name" -ForegroundColor Green
        }
    }
}