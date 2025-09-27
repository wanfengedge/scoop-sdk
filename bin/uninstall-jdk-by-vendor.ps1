<#
.SYNOPSIS
批量卸载指定厂商的JDK版本

.DESCRIPTION
此脚本用于卸载指定厂商的JDK版本，支持所有主要JDK厂商。

.PARAMETER Vendors
要卸载的JDK厂商列表，用逗号分隔。支持的厂商：corretto, liberica, temurin, zulu, zulufx, microsoft, oracle

.EXAMPLE
PS> .\uninstall-jdk-by-vendor.ps1 -Vendors "corretto,temurin"
PS> .\uninstall-jdk-by-vendor.ps1 -Vendors "all"
#>

param(
    [string]$Vendors = "all"
)

Write-Host "开始卸载指定厂商的JDK..." -ForegroundColor Yellow

# 支持的JDK厂商列表
$supportedVendors = @('corretto', 'liberica', 'temurin', 'zulu', 'zulufx', 'microsoft', 'oracle')

# 处理参数
if ($Vendors -eq "all") {
    $vendorsToRemove = $supportedVendors
} else {
    $vendorsToRemove = $Vendors -split ',' | ForEach-Object { $_.Trim() }
    # 验证厂商是否支持
    $invalidVendors = $vendorsToRemove | Where-Object { $_ -notin $supportedVendors }
    if ($invalidVendors.Count -gt 0) {
        Write-Host "错误：不支持的厂商: $($invalidVendors -join ', ')" -ForegroundColor Red
        Write-Host "支持的厂商: $($supportedVendors -join ', ')" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "目标厂商: $($vendorsToRemove -join ', ')" -ForegroundColor Cyan

# 获取所有JDK应用
$jdkApps = scoop list | Where-Object { $_ -like '*jdk*' -and $_ -notlike '*Installed apps:*' }

if ($jdkApps.Count -eq 0) {
    Write-Host "未找到任何JDK安装" -ForegroundColor Yellow
    exit 0
}

$removedCount = 0
$skippedCount = 0

foreach ($app in $jdkApps) {
    # 提取应用名称
    if ($app -match 'Name=([^;]+)') {
        $name = $matches[1]
        
        # 检查是否是目标厂商
        $isTargetVendor = $false
        foreach ($vendor in $vendorsToRemove) {
            if ($name -like "*$vendor*") {
                $isTargetVendor = $true
                break
            }
        }
        
        if ($isTargetVendor) {
            Write-Host "正在卸载: $name" -ForegroundColor Yellow
            scoop uninstall $name
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✓ $name 卸载成功" -ForegroundColor Green
                $removedCount++
            } else {
                Write-Host "✗ $name 卸载失败" -ForegroundColor Red
            }
        } else {
            Write-Host "跳过: $name (不在目标厂商列表中)" -ForegroundColor Gray
            $skippedCount++
        }
    }
}

Write-Host "`n卸载完成统计:" -ForegroundColor Cyan
Write-Host "- 成功卸载: $removedCount" -ForegroundColor Green
Write-Host "- 跳过应用: $skippedCount" -ForegroundColor Gray
Write-Host "指定厂商JDK卸载完成！" -ForegroundColor Green