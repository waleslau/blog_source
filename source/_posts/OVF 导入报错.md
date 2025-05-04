---
title: OVF 导入报错
abbrlink: c9eac9bf
updated: 2022-08-07 11:58:00
date: 2022-08-07 11:58:00
tags:
  - virtualbox
  - vmware
---

在 VirtualBox 内导入由 VMware 生成的 OVF 文件时提示如下错误，无法导入：

```bash
Error reading "D:\Downloads\xxxx\xxxx.ovf": Host resource of type "Other Storage Device (20)" is supported with SATA AHCI controllers only, line 47 (subtype:vmware.nvme.controller).
```

通过该报错我们可以得知，VirtualBox 仅支持 `AHCI` 控制器,无法识别 `vmware.nvme.controller`

那么只需要将 `vmware.nvme.controller` 改为 `AHCI` 就可以导入了，在导入时别忘调整名称、操作系统类型等设置

_另外，所谓的 OVF 其实就是一个虚拟硬盘文件加上一个描述虚拟机配置的 ovf 文件的集合，所以即使无法成功导入也问题不大，我们直接新建虚拟机，在创建虚拟磁盘时不创建新的，直接导入 OVF 的那个虚拟磁盘文件就行了_
