---
title: 在 Linux 系统睡眠/从睡眠唤醒时自动运行脚本
abbrlink: c406a86d
date: 2022-04-16 15:19:00
updated: 2022-04-16 15:19:00
tags:
  - linux
  - suspend
  - systemd
---

我笔记本上装的 openSUSE Tumbleweed 在从睡眠状态恢复后，总是出现时间显示不正常的情况，初步推测可能与硬件时钟有关。

本子上目前是 Linux/Windows 双系统，当初装系统时我为了不对 Windows 系统产生影响就没有设置硬件时钟为 UTC ~~其实是懒得去 windows 改~~，以前也曾用过 Manjaro、Deepin 等其他发行版，也时常会出现这种情况。

本来我很少用睡眠这个选项，就没太在意这个问题，但现在时间总乱就不能忍了，有没有办法可以不改其他任何配置还能解决这个问题呢？

研究了一下发现可以使用 sudo chronyc makestep 手动校准，要想在在从睡眠恢复后自动执行它[^1]，则可以在 `/usr/lib/systemd/system-sleep` 下创建一个文件 `chronyc.sleep`，内容如下：

```bash
#!/bin/sh
if [ "${1}" == "pre" ]; then
    # Do the thing you want before suspend here, e.g.:
    echo "we are suspending at $(date)..." > /tmp/systemd_sleep_log
elif [ "${1}" == "post" ]; then
    # Do the thing you want after resume here, e.g.:
    echo "...and we are back from $(date)" >> /tmp/systemd_sleep_log
    sleep 6 && chronyc makestep &>> /tmp/systemd_sleep_log
fi
```

睡眠并唤醒后查看 `/tmp/systemd_sleep_log`

```bash
idea@wei-laptop:~> cat /tmp/systemd_suspend_test
we are suspending at 2022年 04月 16日 星期六 23:03:53 CST...
...and we are back from 2022年 04月 16日 星期六 23:03:58 CST
200 OK
```

It Works!

[^1]: [Running scripts before and after suspend with systemd](https://blog.christophersmart.com/2016/05/11/running-scripts-before-and-after-suspend-with-systemd/)
