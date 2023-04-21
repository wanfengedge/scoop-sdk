# scoop-sdk

一个用于 Windows 最佳包管理器 [Scoop](https://github.com/lukesampson/scoop)的脚本仓库

# 开始

## 安装 Scoop

### 步骤 1：在 PowerShell 中打开远程权限

```powershell
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
```

### 步骤 2：下载并安装 Scoop

```powershell
irm get.scoop.sh -outfile 'install.ps1'
.\install.ps1 -ScoopDir ['Scoop_Path'] -ScoopGlobalDir ['GlobalScoopApps_Path'] -NoProxy
# 例如
.\install.ps1 -ScoopDir 'C:\Scoop'-ScoopGlobalDir 'C:\Program Files'-NoProxy
```

> 如果跳过该步骤，Scoop 将默认把所有用户安装的 App 和 Scoop 本身置于 `c:/users/user_name/scoop`

### 步骤 3：通过 `scoop help`查看快速上手方法

更多信息，请访问 Scoop 官网 👉 [https://scoop.sh/](https://scoop.sh/) 👈

## 利用扩展库安装 App

### 步骤 1：安装 Aria2 来加速下载

```powershell
scoop install aria2
```

如果使用 VPN，需要通过如下命令关闭 aria2

```powershell
scoop config aria2-enabled false
```

### 步骤 2：安装 Git 来添加新仓库

```powershell
scoop install git
```

### 步骤 3：添加本仓库并更新

```powershell
scoop bucket add scoop-sdk https://github.com/wanfengedge/scoop-sdk
scoop update
```

### 步骤 4：安装 App

- 使用 `scoop search` 命令搜索 App 的具体名称

```powershell
scoop search <app_name>
```

- 利用插件 `scoop-completion`协助安装

```powershell
scoop install scoop-completion
scoop install <app_name>
```

> 使用 `scoop-completion`：键入 App 名称的前几个字母后敲击 `tab`键进行补全

### 步骤 5：查看官方推荐仓库

```powershell
scoop bucket known

main [默认]
extras [墙裂推荐]
versions
nightlies
nirsoft
php
nerd-fonts
nonportable
java
games
jetbrains
```

## 其他

### Aria2 的参数自定义

```powershell
# aria2 在 Scoop 中默认开启
scoop config aria2-enabled true
# 关于以下参数的作用，详见 aria2 的相关资料
scoop config aria2-retry-wait 4
scoop config aria2-split 16
scoop config aria2-max-connection-per-server 16
scoop config aria2-min-split-size 4M
```

## 备注

由于 Win 到权限管理复杂，对于一些常见的不提供 portable 安装包，且需要管理员应用的权限，建议使用 WinGet 进行安装

```powerhsell
scoop install winget
winget install Tencent.QQ
```
