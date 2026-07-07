---
title: 在已存在Windows的系统盘上从零开始安装Arch Linux第二系统
abbrlink: c2d2f0f
date: 2026-07-05 19:43:33
updated: 2026-07-07 12:27:12
tags:
  - linux
  - btrfs
  - archlinux
---
在进行下面操作前先在硬盘上准备好一个足够大的空闲分区，这里以 `/dev/sda4` 为例。

### 1. 创建文件系统

```bash
# 强制格式化为btrfs，并设置卷标
mkfs.btrfs -L archlinux-root /dev/sda4 -f
```

### 2. 挂载文件系统，创建子卷

```bash
#在挂载时启用压缩，SSD建议使用 zstd:1，HDD建议 zstd:3
mount /dev/sda4 /mnt -o compress=zstd:1,subvol=/
```

顺便提一下：  
使用 btrfs subvolume set-default 更改默认子卷后，还想挂载顶层子卷就需要使用 subvol=/ 或 subvolid=5 挂载选项挂载，否则会挂载成我们设置的默认子卷

```bash
# Btrfs 中子卷名可以是任何有效的目录名，以 @ 符号开头只是 timeshift 包的命名约定。
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@log    # /var/log
btrfs subvolume create /mnt/@pkg    # /var/cache/pacman/pkg
btrfs subvolume create /mnt/@home   # /home
btrfs subvolume list -t /mnt # 列出已创建的子卷
btrfs subvolume set-default 256 /mnt  # 设置@为默认子卷
```

### 3. 重新按照目录结构挂载

```bash
umount -R /mnt
mount /dev/sda4 /mnt -o compress=zstd:1,subvol=@
mount /dev/sda4 /mnt/var/log -o compress=zstd:1,subvol=@log --mkdir
mount /dev/sda4 /mnt/home -o compress=zstd:1,subvol=@home --mkdir
mount /dev/sda4 /mnt/var/cache/pacman/pkg -o compress=zstd:1,subvol=@pkg --mkdir
mount /dev/sda1 /mnt/boot/efi --mkdir # 挂载原有ESP分区
```

大多数挂载选项适用于整个文件系统，因而只有第一个挂载的子卷的选项才会生效。但为了应对未来的可能的变化，这并不影响我们给每个子卷都设置上一摸一样的挂载参数。

### 4. 选择镜像站

```bash
# 编辑mirrorlist文件，往下找到 自己喜欢的镜像站的链接，拷贝到到这个文件的第一行
vim /etc/pacman.d/mirrorlist
```

### 5. 安装必需的软件包

```bash
pacstrap -K /mnt base linux linux-firmware amd-ucode sof-firmware btrfs-progs man-db man-pages texinfo grub os-prober efibootmgr vim networkmanager eza bash-completion sudo openssh gdisk git sddm plasma-meta noto-fonts-cjk
```

### 6. 生成 fstab 文件

```bash
genfstab -U /mnt > /mnt/etc/fstab
```

### 7. chroot 到新安装的系统

```bash
arch-chroot /mnt
```

### 8. 设置时间和时区

```bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc # 同步到硬件时钟
```

为了防止时钟漂移并确保时间准确，后续启动到系统后需使用 NTP（网络时间协议，Network Time Protocol）客户端（例如 systemd-timesyncd）设置时间同步。

### 9.区域和本地化设置

```bash
vim /etc/locale.gen  # 取消掉 en_GB.UTF-8 UTF-8 和其他需要的区域设置前的注释
```

```text
en_GB.UTF-8 UTF-8
zh_CN.GB18030 GB18030
zh_CN.GBK GBK
zh_CN.UTF-8 UTF-8
zh_CN GB2312
```

```bash
locale-gen  # 生成 locale 信息
echo 'LANG=en_GB.UTF-8' > /etc/locale.conf   # 然后创建 locale.conf 文件，编辑设定 LANG 变量
```

### 10. 网络配置

```bash
echo 'amd-yes' > /etc/hostname
```

### 11. initramfs

通常不需要自己创建新的 initramfs，因为在执行 pacstrap 时已经安装 linux 包，这时已经运行过 mkinitcpio 了。

```bash
mkinitcpio -P
```

### 12. 设置 root 密码

```bash
passwd root
```

### 13. 安装引导程序

```bash
vim /etc/default/grub # 取消 GRUB_DISABLE_OS_PROBER=false 的注释

grub-install --removable
grub-mkconfig -o /boot/grub/grub.cfg
grep -P "^menuentry" /boot/grub/grub.cfg | cut -d "'" -f2   #检查自动识别的引导项
```

### 14. 完成安装，重新启动

```bash
exit # 退出 chroot 环境
umount -R /mnt # 手动卸载被挂载的分区
reboot # 重启系统
```

### 15. 其他

[安装指南 - 安装后的工作](https://wiki.archlinuxcn.org/wiki/%E5%AE%89%E8%A3%85%E6%8C%87%E5%8D%97#%E5%AE%89%E8%A3%85%E5%90%8E%E7%9A%84%E5%B7%A5%E4%BD%9C)
