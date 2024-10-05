## Scoop 安装与配置

**要求：**

- PowerShell >= 5.0 (如果是 Window10 则默认满足此条件)

可以运行如下命令进行查看 PowerShell 版本：

```powershell
$psversiontable.psversion.major # should be >= 5.0
```

- 请确保已允许PowerShell执行本地脚本，可以使用下面的命令开启：

```powershell
set-executionpolicy remotesigned -scope currentuser

# 或者 （但是它没有上面的命令安全）
set-executionpolicy Unrestricted -scope currentuser
```

安装路径：

- 用户级别安装的程序 和 Scoop 本身默认安装于 `C:\Users\<user>\scoop`
- 全局安装的程序（所有用户可用，使用`--global`或 `-g` 选项）位 于`C\ProgramData\scoop`路径中。

可以通过更改对应的环境变量更改这些路径 。

**将 Scoop 安装到自定义目录** :

打开 PowerShell 先配置环境变量 `SCOOP`，再运行 `iex`

```powershell
$env:SCOOP='D:\Scoop'
# 先添加用户级别的环境变量 SCOOP
[environment]::setEnvironmentVariable('SCOOP',$env:SCOOP,'User')

## 下载安装

# 然后下载安装 Scoop （如果使用默认安装路径则直接运行下面的命令）

iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
# 或者使用下面的命令安装：

iwr -useb get.scoop.sh | iex

```

**配置全局安装路径** （可选，建议不改）

```.sh
$env:SCOOP_GLOBAL='D:\GlobalScoopApps'

[environment]::setEnvironmentVariable('SCOOP_GLOBAL',$env:SCOOP_GLOBAL,'Machine')
```

> 相当于在系统变量中设置： `SCOOP_GLOBAL=D:\GlobalScoopApps`；默认是在 `C:\ProgramData\scoop`。

**为什么需要全局安装？**

对于那些需要管理员权限的程序需要进行全局安装。我当前遇到的是当使用 Scoop 安装字体时需要使用全局安装，因为字体需要给所有用户使用。

初次安装 Scoop 后，建议安装的程序：

```sh
# 但 scoop 进行全局安装时需要使用到 sudo 命令
scoop install sudo

# scoop下载程序时支持使用 aria2 来加速下载
scoop install aria2
```

我们可以发现，下载的过程中自动下载了依赖 7-zip。 在安装方面，它利用了 7zip 去解 压安装包/压缩包，因此它对绿色软件有天生的友好属性 。不仅如此，下载之后的内容会自 动将加入到（Path）环境变量中，十分方便。

> **补充：** 初次安装之后我们可以通过运行 `scoop checkup` 来检测当前潜在问题，然后根据提示进行修正。
>
> ```powershell
> # 检测本人当前环境存在的问题
> $ scoop checkup
> ```

**Scoop 的设计与实现理念** ：

- 分离用户数据：默认将程序的 **用户数据** 存储到 `persist` 目录中，这样当用户日 后升级该程序后之前的用户配置依然可用。（但是对于部分程序支持的不是很完善）
- `shim`软链接： scoop 会自动在 scoop 应用安装路径下的 `shims` 文件夹下为新安装 的程序添加对应的 `.exe` 文件，而 `shims` 文件夹提前就已被添加到 `PATH` 环境变 量中，所以程序一旦安装就可以直接在命令行中运行。
- **对于 GUI 程序** ，scoop 还会自动为其在开始菜单中添加快捷方式 ，路径： `C:\Users\<user>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Scoop Apps`

## Scoop 常用命令

```powershell
scoop help #查看帮助
scoop help <某个命令> # 具体查看某个命令的帮助

scoop install <app>   # 安装 APP
scoop uinstall <app>  # 卸载 APP

scoop list  # 列出已安装的 APP
scoop search # 搜索 APP
scoop status # 检查哪些软件有更新

scoop update # 更新 Scoop 自身
scoop update <app1> <app2> # 更新某些app
scoop update *  # 更新所有 app （前提是需要在apps目录下操作）

scoop bucket known #通过此命令列出已知所有 bucket（软件源）
scoop bucket add bucketName #添加某个 bucket

scoop cache rm <app> # 移除某个app的缓存

```

## 安装卸载软件

```shell
# 安装之前，通过 search 搜索 APP, 确定软件名称
scoop search  xxx

# 安装 APP
scoop install <app>

# 安装特定版本的 APP；语法 AppName@[version]，示例
scoop install git@2.23.0.windows.1

# 卸载 APP
scoop uninstall <app> #卸载 APP
```

## 更新软件

包含：如何禁用更新

```powershell
scoop update # 更新 Scoop 自身

scoop update appName1 appName2 # 更新某些app

# 更新所有 app （可能需要在apps目录下操作）
scoop update *

# 禁止某程序更新
scoop hold <app>
# 允许某程序更新
scoop unhold <app>
```

## 清除缓存与旧版本

```powershell
# 查看所有以下载的缓存信息
scoop cache show

# 清除指定程序的下载缓存
scoop cache rm <app>

# 清除所有缓存
scoop cache rm *

# 删除某软件的旧版本
scoop cleanup <app>

# 删除全局安装的某软件的旧版本
scoop cleanup <app> -g

# 删除过期的下载缓存
scoop cleanup <app> -k
```

## 在同一程序的不同版本之间切换

使用命令：

```powershell
scoop reset [app]@[version]
scoop reset idea-ultimate-eap@201.6668.13

scoop reset idea-ultimate-eap@201.6073.9

# 切换到最新版本
scoop reset idea-ultimate-eap
```

对应版本的程序需要已经安装于本地系统中；所以在你清除某个软件的旧版本时考虑一下自己是否还会再次使用到此旧版本。

另外 idea-ultimate-eap 切换过程可能需要更长时间。

## 其它命令

```bas
# 显示某个app的信息
scoop info <app>

# 在浏览器中打开某app的主页
scoop home <app>

# 比如
scoop home git
```

## 添加软件源 Bucket

Scoop 可安装的软件信息存储在 Bucket（翻译为：桶）中，也可以称其为软件源。Scoop 默认的 Bucket 为 `main` ；官方维护的另一个 Bucket 为 `extras`，我们需要手动添加。

```powershell
# bucket的用法
scoop bucket add|list|known|rm [<args>]
```

添加 extras :

```powershell
scoop bucket add extras
```

我们也可以添加第三方 bucket ，示例：

```powershell
scoop bucket add dorado https://github.com/h404bi/dorado
```

并且明确指定安装此 bucket （软件源）中的的程序：

```powershell
scoop install dorado/<app_name>
# 下面是dorado中特有的软件，测试其是否添加成功
scoop search trash
```

官方仓库地址

```powershell
https://github.com/ScoopInstaller/Main
https://github.com/ScoopInstaller/Extras
https://github.com/ScoopInstaller/Versions
https://github.com/ScoopInstaller/Java
```

推荐的 Bucket（软件源）：

- `extras`：Scoop 官方维护的一个仓库，涵盖了大部分因为种种原因不能被收录进主仓库 的常用软件（在我看来是必须要添加的）。地址 ：[lukesampson/scoop-extras](https://github.com/lukesampson/scoop-extras/tree/master/bucket)
- nirsoft：是一个 NirSoft 开发的小工具的安装合集。NirSoft 制作了大量的小工具，包括系统工具、网络工具、密码恢复等等，孜孜不倦、持续更新。
- Bucket 地址 ：[kodybrown/scoop-nirsoft](https://github.com/kodybrown/scoop-nirsoft)
- NirSoft 官网地址：[NirSoft](https://www.nirsoft.net/)
- dorado（添加了一些国内的app，比如 qqplayer 👍🏻️ ）[h404bi/dorado](https://github.com/h404bi/dorado)
- ash258：[Ash258/scoop-Ash258](https://github.com/Ash258/scoop-Ash258)
- java：添加后可以通过它安装各种 jdk 、 jre
- nerd-fonts ：包含各种字体

```powershell
# 先添加bucket
scoop bucket add extras
scoop bucket add nirsoft
scoop bucket add dorado https://github.com/h404bi/dorado
scoop bucket add Ash258 'https://github.com/Ash258/Scoop-Ash258.git'
scoop bucket add nerd-fonts
# 对于开发人员，可添加下面的两个
scoop bucket add java
scoop bucket add versions
```

## 添加本仓库

```powershell
scoop bucket add scoop-sdk https://github.com/wanfengedge/scoop-sdk
scoop update
```

