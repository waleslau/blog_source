---
title: 使用命令重启到BIOS
tags:
  - command
  - windows
  - linux
abbrlink: c93c285c
date: 2023-10-11 10:18:02
updated: 2023-10-11 13:52:16
---

直接用命令，比百度上搜各品牌的快捷键然后开机时狂按带劲多了😂

## Windows

```powershell
# 需使用管理员权限打开终端
shutdown /r /fw /f /t 0
```

## Linux

```bash
# 先切到 root 用户
systemctl reboot --firmware-setup
```
