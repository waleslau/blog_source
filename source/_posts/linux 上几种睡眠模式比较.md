---
title: linux 上几种睡眠模式比较
abbrlink: af1f09e9
date: 2022-12-10 11:46:29
date: 2022-12-10 11:46:29
tags:
  - linux
---

```bash
systemctl suspend                    # Suspend the system
systemctl hibernate                  # Hibernate the system
systemctl hybrid-sleep               # Hibernate and suspend the system
systemctl suspend-then-hibernate     # Suspend the system, wake after a period of time, and hibernate
```

## suspend

普通的挂起（或者说睡眠），机器能以最快的速度被唤醒。不建议在笔记本不插电时使用，容易睡死 (电池耗尽后丢失工作状态)。

## hibernate

普通的休眠，约等于完全关机，但会保留上次的内存状态到硬盘内，唤醒后再恢复。速度稍慢，好处是不用担心睡死（毕竟已经“完全关机”了:joy_cat:）。

## suspend-then-hibernate

先挂起，经过一段时间后系统自动唤醒并执行休眠操作。

但默认的等待时间一般都比较长，（文档里说是 120min，`/etc/systemd/sleep.conf` 里的默认配置写的是 180min），电池不给力的话，仍有睡死的风险，如使用此模式建议根据笔记本情况以及自己的需求设定一个较短的时间。

## hybrid-sleep

混合睡眠，suspend 的同时也把内存状态备份到硬盘，睡眠速度比 suspend 稍慢，唤醒速度大差不差，可以防止睡死。

我起初以为它的效果只是 suspend 的同时也把内存状态备份到硬盘以避免睡死，但在实际使用时发现我的笔记本在 suspend 时仍会发热（而且发热量很可观，几乎比省电模式下空载还热了，耗电估计也小不了），但 hybrid-sleep 时几乎没有发热，我觉得它应该做了更多的处理。不排除 suspend 在我的本子上没有正常工作这个可能

> 我发现我的笔记本在 suspend 时仍会发热（而且发热量很可观，几乎比省电模式下空载还热了，耗电估计也小不了），但 hybrid-sleep 时几乎没有发热（和在 Windows 11 下睡眠的表现差不多）。  
> suspend 是普通的挂起，hybrid-sleep 是混合睡眠，从文档里的的介绍来看混合睡眠只是比普通的挂起多了个保存内存状态到硬盘的操作，按理说它俩的功耗表现应该是一样的啊，是 hybrid-sleep 在控制功耗方面做了更多的处理，还是 suspend 在我的本子上没有正常工作呢？  
> [https://forum.suse.org.cn/t/topic/15224](https://forum.suse.org.cn/t/topic/15224)

## 解决

```bash
# /etc/systemd/sleep.conf
[Sleep]
#AllowSuspend=yes
#AllowHibernation=yes
#AllowSuspendThenHibernate=yes
#AllowHybridSleep=yes
#SuspendMode=
#SuspendState=mem standby freeze
#HibernateMode=platform shutdown
#HibernateState=disk
#HybridSleepMode=suspend platform shutdown
#HybridSleepState=disk
#HibernateDelaySec=180min

# Disable useless items
AllowHibernation=no
AllowSuspendThenHibernate=no
# Configure suspend as hybrid-sleep
SuspendMode=suspend platform shutdown
SuspendState=disk
```
