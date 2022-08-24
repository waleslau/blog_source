---
title: Windows/Linux 双系统的时间问题
date: 2022-04-17 10:40:16
updated: 2022-04-17 10:40:16
mermaid: false
math: false
categories:
  - linux
tags: [linux, windows]
---

上一篇文章里我提到了一种自动在唤醒后同步时间的方法[^1]（不修改硬件时钟）

But，如果仅仅是这样的话，当我在命令行中敲下`timedatectl`时，它会给我一个警告：

> Warning:
> The system is configured to read the RTC time in the local time zone.This mode cannot be fully supported. It will create various problems with time zone changes and daylight saving time adjustments. The RTC time is never updated, it relies on external facilities to maintain it. If at all possible, use RTC in UTC by calling 'timedatectl set-local-rtc 0'.
>
> 意思是使用 RTC 时钟会导致一些程序错误

我投降，我决定把这个笔记本的硬件时钟设为 UTC。

安全起见，修改前在网上搜索了一下，没看到到 Windows 对 UTC 有啥不良反应。~~Windows：我都可以.JPG~~

> 下面内容都是我从这里[^2] copy 来的，有所删减，感兴趣的可以去看看原文

### UTC、RTC 的区别

- UTC：Universal Time Coordinated，即协调世界时。UTC 是以原子时秒长为基础，在时刻上尽量接近于 GMT 的一种时间计量系统。为确保 UTC 与 GMT 相差不会超过 0.9 秒，在有需要的情况下会在 UTC 内加上正或负闰秒。UTC 现在作为世界标准时间使用。

- RTC：Real-Time Clock，即实时时钟，在计算机领域作为硬件时钟的简称。

世界上不同地区所在的时区是不同的，这些时区决定了当地的本地时间。比如北京处于东八区，即北京时间为 UTC + 8，如果 UTC 时间现在是上午 6 点整，那么北京时间为 14 点整。

Windows 与 Linux 看待硬件时间的默认方式不同。Windows 把电脑的硬件时钟（RTC）看成是本地时间，即 RTC = Local Time，Windows 会直接显示硬件时间；而 Linux 则是把电脑的硬件时钟看成 UTC 时间，即 RTC = UTC，那么 Linux 显示的时间就是硬件时间加上时区。

既然知道了问题原因，我们就知道如何去解决，大概思路分为两种，一是让 Windows 认为硬件时钟是 UTC 时间，二是让 Linux 认为硬件时钟是本地时间。建议修改 Windows 的，原因在本文开头说了。

### 修改 Windows 硬件时钟为 UTC 时间

以管理员身份打开 「PowerShell」，输入以下命令：

```powershell
Reg add HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation /v RealTimeIsUniversal /t REG_DWORD /d 1
```

或者打开「注册表编辑器」，定位到`计算机\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation`目录，在该目录下新建一个`DWORD`类型，名称为`RealTimeIsUniversal`的键，并修改键值为`1`即可。

[^1]: [在 Linux 系统睡眠/从睡眠唤醒时自动运行脚本](https://blog.oopsky.top/2022/04/running-scripts-before-and-after-suspend-with-systemd/)
[^2]: [Linux Windows 双系统时间不一致](https://sspai.com/post/55983)
