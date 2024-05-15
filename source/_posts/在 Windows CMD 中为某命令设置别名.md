---
title: 在 Windows CMD 中为某命令设置别名
abbrlink: 59f07d80
date: 2024-05-15 18:47:49
updated: 2024-05-15 20:32:01
tags:
  - windows
---

## 在终端中临时设定

### 方法 1 使用 set

如何设定：

```cmd
set "ls=busybox.exe ls"
```

如何使用：

```cmd
%ls%
```

### 方法 2 使用 doskey

_此方式仅适用于交互式命令行 - 它们不适用于批处理脚本，且不能用在管道的任一侧_  

如何设定：

```cmd
doskey ls=busybox.exe ls
```

如何使用：

```cmd
ls
```

## 持久化设定

将 `%USERPROFILE%\bin` 添加到 `PATH` 环境变量中。然后将脚本保存在那里。

`ls.cmd`:

```cmd
@echo off
busybox.exe ls
```

然后可以在命令行中输入 `ls` 。  
也可以使用 `call` 函数在脚本内调用它

```
call ls
```
