<#
.SYNOPSIS
JDK管理工具 - 提供诊断和卸载JDK的功能

.DESCRIPTION
此脚本提供统一的JDK管理界面，包括诊断已安装JDK和批量卸载功能。

.PARAMETER Action
要执行的操作：diagnose（诊断）、uninstall-all（卸载所有）、uninstall-vendor（按厂商卸载）

.PARAMETER Vendors
当Action为uninstall-vendor时，指定要卸载的厂商列表，用逗号分隔

.EXAMPLE
PS> .\jdk-manager.ps1 -Action diagnose
PS> .\jdk-manager.ps1 -Action uninstall-all
PS> .\jdk-manager.ps1 -Action uninstall-vendor -Vendors "corretto,temurin"
#>

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("diagnose", "uninstall-all", "uninstall-vendor")]
    [string]$Action,
    
    [string]$Vendors = "all"
)

# 脚本目录
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

switch ($Action) {
    "diagnose" {
        Write-Host "正在诊断已安装的JDK..." -ForegroundColor Cyan
        & "$scriptDir\diagnose-jdk.ps1"
    }
    "uninstall-all" {
        Write-Host "正在卸载所有JDK..." -ForegroundColor Yellow
        & "$scriptDir\uninstall-all-jdk.ps1"
    }
    "uninstall-vendor" {
        Write-Host "正在按厂商卸载JDK..." -ForegroundColor Yellow
        & "$scriptDir\uninstall-jdk-by-vendor.ps1" -Vendors $Vendors
    }
}

Write-Host "`n操作完成！" -ForegroundColor Green