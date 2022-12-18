---
title: 使用 fsarchiver 备份、恢复 Linux 分区
date: 2022-07-17 17:56:43
updated: 2022-07-17 17:56:43
mermaid: false
math: false
tags:
  - fsarchiver
---

## 介绍

该项目的目的是提供一个安全灵活的文件系统备份/部署工具，可以将文件系统(分区)的内容保存到一个归档文件中，并且支持恢复归档到一个比原始分区小的新分区(只要有足够的空间来存储数据)。它还可以恢复数据到与原先文件系统不同格式的分区。

要安装它，请访问 [FSArchiver - Installation](https://www.fsarchiver.org/installation/) 查看帮助

## 如何使用

说在前面：
虽然 fsarchiver 支持在使用文件系统时备份,但为了避免意外，最好把要备份的分区卸载或者挂载为只读，亦或者引导到一个[包含 fsarchiver 的救援系统](https://www.system-rescue.org/Download/)再进行操作

```bash
# 备份文件系统
sudo fsarchiver -v -j7 -Z10 savefs /data/partition_backup/sdb1.xfs.fsa /dev/sdb1

# 从备份恢复文件系统
sudo fsarchiver restfs /data/partition_backup/sdb1.xfs.fsa /dev/sdb2

# 默认情况下会保持原来的uuid，若想要重置uuid，只需在目标分区后加一个参数
sudo fsarchiver restfs /data/partition_backup/sdb1.xfs.fsa /dev/sdb2,uuid=`uuidgen`
```

部分参数解释：

- `savefs` : 保存设备上的文件系统到归档。
- `restfs` : 从归档恢复文件系统到设备。
- `-Z level` : Zstd 压缩级别, 取值范围 1-22 之间
- `-j threads` : 多线程压缩
- `-v` : 详细模式（可以多次使用以增加详细程度，例如 `-vv`）。这些细节将被打印到控制台。
- `uuid=$(uuidgen)` : 随机生成一个 uuid

## 其他类似项目

- [Clonezilla](https://clonezilla.org/)
- [Partclone](https://partclone.org/)
