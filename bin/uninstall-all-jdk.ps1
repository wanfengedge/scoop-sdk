<#
.SYNOPSIS
批量卸载所有通过scoop安装的JDK版本

.DESCRIPTION
此脚本用于卸载所有通过scoop安装的JDK版本，支持新版scoop的对象格式输出。

.EXAMPLE
PS> .\uninstall-all-jdk.ps1
#>

Write-Host "开始卸载JDK..." -ForegroundColor Yellow

# 获取所有JDK应用
$jdkApps = scoop list | Where-Object { $_ -like '*jdk*' -and $_ -notlike '*Installed apps:*' }

if ($jdkApps.Count -eq 0) {
    Write-Host "未找到任何JDK安装" -ForegroundColor Yellow
    exit 0
}

foreach ($app in $jdkApps) {
    # 提取应用名称
    if ($app -match 'Name=([^;]+)') {
        $name = $matches[1]
        Write-Host "正在卸载: $name" -ForegroundColor Yellow
        
        # 卸载应用
        scoop uninstall $name
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ $name 卸载成功" -ForegroundColor Green
        } else {
            Write-Host "✗ $name 卸载失败" -ForegroundColor Red
        }
    }
}

Write-Host "JDK卸载完成！" -ForegroundColor Green