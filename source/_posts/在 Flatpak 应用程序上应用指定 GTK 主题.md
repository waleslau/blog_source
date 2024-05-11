---
title: 在 Flatpak 应用程序上应用指定 GTK 主题
abbrlink: f8720f38
date: 2024-05-11 21:48:05
updated: 2024-05-11 21:48:05
tags:
  - linux
  - flatpak
source: https://itsfoss.com/flatpak-app-apply-theme/
---

如果在 Linux 桌面环境设置了暗黑主题，且使用的桌面环境不是 Gnome， Flatpak 内的 GTK 程序的主题都将是亮色的，简直亮瞎眼。可参照下面操作设定 Flatpak 程序的 GTK 主题。

## 1. 使用 flatpak 安装主题
```bash
flatpak install flathub org.gtk.Gtk3theme.Adapta
```

## 2. 设定环境变量
```bash
sudo flatpak override --env=GTK_THEME=Adwaita:dark
```

然后再启动程序，主题就是暗黑的了。
