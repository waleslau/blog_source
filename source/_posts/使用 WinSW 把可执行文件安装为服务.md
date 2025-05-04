---
title: 使用 WinSW 把可执行文件安装为服务
abbrlink: 376ebc48
date: 2023-01-05 08:06:00
updated: 2024-10-13 20:57:30
tags:
  - windows
---

> [https://github.com/winsw/winsw](https://github.com/winsw/winsw)

## 参数列表

| Command                                                                                    | Description                                              |
| ------------------------------------------------------------------------------------------ | -------------------------------------------------------- |
| [install](https://github.com/winsw/winsw/tree/v3/docs/cli-commands.md#install-command)     | Installs the service.                                    |
| [uninstall](https://github.com/winsw/winsw/tree/v3/docs/cli-commands.md#uninstall-command) | Uninstalls the service.                                  |
| [start](https://github.com/winsw/winsw/tree/v3/docs/cli-commands.md#start-command)         | Starts the service.                                      |
| [stop](https://github.com/winsw/winsw/tree/v3/docs/cli-commands.md#stop-command)           | Stops the service.                                       |
| [restart](https://github.com/winsw/winsw/tree/v3/docs/cli-commands.md#restart-command)     | Stops and then starts the service.                       |
| [status](https://github.com/winsw/winsw/tree/v3/docs/cli-commands.md#status-command)       | Checks the status of the service.                        |
| [refresh](https://github.com/winsw/winsw/tree/v3/docs/cli-commands.md#refresh-command)     | Refreshes the service properties without reinstallation. |
| [customize](https://github.com/winsw/winsw/tree/v3/docs/cli-commands.md#customize-command) | Customizes the wrapper executable.                       |
| [dev ps](https://github.com/winsw/winsw/tree/v3/docs/cli-commands.md#dev-ps-command)       | Draws the process tree associated with the service.      |
| [dev kill](https://github.com/winsw/winsw/tree/v3/docs/cli-commands.md#dev-kill-command)   | Terminates the service if it has stopped responding.     |
| [dev list](https://github.com/winsw/winsw/tree/v3/docs/cli-commands.md#dev-list-command)   | Lists services managed by the current executable.        |

## 使用方式

先说结论

- 若 `WinSW.exe` 和 `myapp.xml` 不在同一目录

  - 使用 `WinSW.exe install .\myapp.xml` 操作服务

- 若 `WinSW.exe` 和 `myapp.xml` 在同一目录

  - 可以使用 `WinSW.exe install .\myapp.xml` 操作服务
  - 也可以把 `WinSW.exe` 重命名为 `myapp.exe`，然后使用 `myapp install` 操作服务

服务示例：  
`chfs-service.xml`：

```xml
<service>
  <id>chfs-service</id>
  <name>CUTE HTTP FILE SERVER</name>
  <description> http://iscute.cn/chfs </description>
  <executable> chfs.exe </executable>
  <arguments> --rule="::r|root:123456:rwd" --path="D:\\" </arguments>
  <!-- 把日志文件都放到xml所在位置的子目录 -->
  <logpath>%BASE%\logs</logpath>
  <log mode="roll" />
</service>
```

### 全局方式

1. 从 [发布页面](https://github.com/winsw/winsw/releases) 下载 `WinSW.exe`
2. 创建一个专门用来放 xml 文件的目录，把 `WinSW.exe` 放入其中，创建 `myapp1.xml`、`myapp2.xml` …
3. 然后可以使用形似下面的命令操作每个服务

```bash
WinSW.exe install .\myapp1.xml
WinSW.exe install .\myapp2.xml
```

> 也可以随便找个其他地方，把 `WinSW.exe` 放入其中，并加入 `PATH`，总之能访问到 WinSW.exe 就行

### 捆绑方式

1. 下载 `WinSW.exe`
2. 创建一个文件夹，把 `WinSW.exe` 放入其中并重命名为 `myapp.exe`
3. 在相同文件夹内创建 `myapp.xml`
4. 然后可以使用形似下面的命令操作服务

```bash
myapp install
myapp start
myapp stop
myapp uninstall
```

目录结构：

```yml
├── chfs-service.exe
└── chfs-service.xml
```
