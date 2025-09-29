# Scoop 安装与配置指南

## 概述
Scoop 是一个 Windows 命令行包管理工具，可帮助您轻松安装、更新和管理各种软件。本指南将详细介绍 Scoop 的安装、配置和常用操作。

## 系统要求
- Windows 10 或更高版本（默认已安装 PowerShell 5.0+）
- PowerShell 5.0 或更高版本

### 检查 PowerShell 版本
```powershell
$psversiontable.psversion.major # 结果应 >= 5.0
```

### 启用 PowerShell 脚本执行
```powershell
# 推荐：允许执行本地签名脚本
set-executionpolicy remotesigned -scope currentuser

# 备选：允许执行所有脚本（安全性较低）
set-executionpolicy Unrestricted -scope currentuser
```

## 安装 Scoop

### 默认路径安装
```powershell
# 方法 1
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')

# 方法 2
iwr -useb get.scoop.sh | iex
```

### 自定义安装路径
```powershell
# 设置用户级环境变量
$env:SCOOP='D:\Scoop'
[environment]::setEnvironmentVariable('SCOOP',$env:SCOOP,'User')

# 然后安装
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
```

### 配置全局安装路径（可选）
```powershell
$env:SCOOP_GLOBAL='D:\GlobalScoopApps'
[environment]::setEnvironmentVariable('SCOOP_GLOBAL',$env:SCOOP_GLOBAL,'Machine')
```

> 全局安装路径默认位于 `C:\ProgramData\scoop`，用于安装需要管理员权限的程序（如字体）。

## 初次安装后推荐操作
```powershell
# 安装 sudo 命令（用于全局安装）
scoop install sudo

# 安装 aria2（用于加速下载）
scoop install aria2

# 检测潜在问题
scoop checkup
```

## Scoop 设计理念
- **分离用户数据**：程序的用户数据存储在 `persist` 目录中，升级后配置依然保留
- **Shim 软链接**：自动在 `shims` 文件夹中创建可执行文件链接，并添加到 PATH 环境变量
- **GUI 程序支持**：自动在开始菜单添加快捷方式，路径：`C:\Users\<user>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Scoop Apps`

## 常用命令

### 基础操作
```powershell
# 查看帮助
scoop help
scoop help <命令名称>

# 列出已安装程序
scoop list

# 搜索程序
scoop search <关键词>

# 查看程序信息
scoop info <程序名称>

# 打开程序主页
scoop home <程序名称>
```

### 安装与卸载
```powershell
# 安装程序
scoop install <程序名称>

# 安装特定版本
scoop install <程序名称>@<版本号>
# 示例
scoop install git@2.23.0.windows.1

# 卸载程序
scoop uninstall <程序名称>
```

### 更新操作
```powershell
# 更新 Scoop 自身
scoop update

# 更新特定程序
scoop update <程序名称1> <程序名称2>

# 更新所有程序（需在 apps 目录下）
scoop update *

# 禁止程序更新
scoop hold <程序名称>

# 允许程序更新
scoop unhold <程序名称>
```

### 缓存与旧版本管理
```powershell
# 查看缓存
scoop cache show

# 清除特定程序缓存
scoop cache rm <程序名称>

# 清除所有缓存
scoop cache rm *

# 删除程序旧版本
scoop cleanup <程序名称>

# 删除全局安装的程序旧版本
scoop cleanup <程序名称> -g

# 删除过期缓存
scoop cleanup <程序名称> -k
```

### 版本切换
```powershell
# 切换到特定版本
scoop reset <程序名称>@<版本号>
# 示例
scoop reset idea-ultimate-eap@201.6668.13

# 切换到最新版本
scoop reset <程序名称>
```

> 注意：切换版本前需确保该版本已安装。

## 软件源（Bucket）管理
Scoop 的软件信息存储在称为 Bucket 的软件源中，默认使用 `main` Bucket。

### 基础操作
```powershell
# 列出已知 Bucket
scoop bucket known

# 查看已添加 Bucket
scoop bucket list

# 添加 Bucket
scoop bucket add <Bucket名称> [URL]

# 删除 Bucket
scoop bucket rm <Bucket名称>
```

### 推荐 Bucket

官方主 Bucket: https://github.com/ScoopInstaller/Main
版本管理 Bucket: https://github.com/ScoopInstaller/Versions
额外软件源 Bucket: https://github.com/ScoopInstaller/Extras 

```powershell
# 官方额外软件源
scoop bucket add extras

# NirSoft 工具集
scoop bucket add nirsoft

# 国内软件源
scoop bucket add dorado https://github.com/h404bi/dorado

# 开发工具软件源
scoop bucket add Ash258 'https://github.com/Ash258/Scoop-Ash258.git'

# 字体软件源
scoop bucket add nerd-fonts

# Java 开发软件源
scoop bucket add java

# 版本管理软件源
scoop bucket add versions
```

### 从指定 Bucket 安装程序
```powershell
scoop install <Bucket名称>/<程序名称>
```

## 添加本仓库
```powershell
scoop bucket add scoop-sdk https://github.com/wanfengedge/scoop-sdk
scoop update
```

## 批量删除 JDK

### 诊断当前安装的JDK（推荐使用）
```powershell
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
```

### 批量删除所有JDK（推荐使用）
```powershell
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
```

### 批量删除指定厂商的JDK
```powershell
Write-Host "开始卸载指定厂商的JDK..." -ForegroundColor Yellow

# 支持的JDK厂商列表
$supportedVendors = @('corretto', 'liberica', 'temurin', 'zulu', 'zulufx', 'microsoft', 'oracle')

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
        
        # 检查是否是支持的厂商
        $isSupportedVendor = $false
        foreach ($vendor in $supportedVendors) {
            if ($name -like "*$vendor*") {
                $isSupportedVendor = $true
                break
            }
        }
        
        if ($isSupportedVendor) {
            Write-Host "正在卸载: $name" -ForegroundColor Yellow
            scoop uninstall $name
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✓ $name 卸载成功" -ForegroundColor Green
            } else {
                Write-Host "✗ $name 卸载失败" -ForegroundColor Red
            }
        } else {
            Write-Host "跳过: $name (不支持的厂商)" -ForegroundColor Gray
        }
    }
}

Write-Host "指定厂商JDK卸载完成！" -ForegroundColor Green
```

## 使用独立的PowerShell脚本文件

为了方便使用，我们提供了独立的PowerShell脚本文件，位于 `bin` 目录下：

### 1. 诊断JDK脚本
```powershell
# 运行诊断脚本
.\bin\diagnose-jdk.ps1
```

### 2. 卸载所有JDK脚本
```powershell
# 运行卸载所有JDK脚本
.\bin\uninstall-all-jdk.ps1
```

### 3. 按厂商卸载JDK脚本
```powershell
# 卸载指定厂商的JDK
.\bin\uninstall-jdk-by-vendor.ps1 -Vendors "corretto,temurin"

# 卸载所有厂商的JDK
.\bin\uninstall-jdk-by-vendor.ps1 -Vendors "all"
```

### 4. JDK管理主脚本（推荐）
```powershell
# 诊断已安装的JDK
.\bin\jdk-manager.ps1 -Action diagnose

# 卸载所有JDK
.\bin\jdk-manager.ps1 -Action uninstall-all

# 按厂商卸载JDK
.\bin\jdk-manager.ps1 -Action uninstall-vendor -Vendors "corretto,temurin"
```

### 脚本文件说明
- `diagnose-jdk.ps1` - 诊断当前安装的JDK版本
- `uninstall-all-jdk.ps1` - 批量卸载所有JDK版本
- `uninstall-jdk-by-vendor.ps1` - 按厂商卸载JDK版本
- `jdk-manager.ps1` - JDK管理主脚本，统一管理所有功能

所有脚本都支持新版scoop的对象格式输出，并提供了详细的执行反馈。

