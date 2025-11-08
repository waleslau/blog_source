---
title: 速度更快的「密码恢复工具」：hashcat
tags:
  - kali
  - linux
abbrlink: 8870bccb
date: 2025-11-08 21:21:21
updated: 2025-11-08 21:21:21
---

书接上文 [^1]，最近又发现了一个新的软件：hashcat[^2]，和 Aircrack-ng 里的 WPA 密码破解器相比，它的速度更快，功能更多，且支持 GPU 加速。这个项目的 Github 仓库 [^3] 里写的对它自己的介绍也很自信： _hashcat is the world's fastest and most advanced password recovery utility_ ，哈哈。

## 把 cap 文件转换成 hashcat 支持的格式

```
hcxpcapngtool -o Wi-Fi_capture-01.hc22000 Wi-Fi_capture-01.cap
```

## 使用 hashcat 破解密码

```bash
# 使用单个字典暴力破解
hashcat -m 22000 -a 0 Wi-Fi_capture-01.hc22000 ~/phone_numbers_dict.txt

# 没有字典，使用掩码匹配所有特定结构的密码
hashcat -m 22000 -a 3 Wi-Fi_capture-01.hc22000 ?l?l?l?d?d?d?d?d

# 两个字典，手机号+中国常见姓氏拼音
hashcat -m 22000 -a 1 Wi-Fi_capture-01.hc22000 ~/phone_numbers_dict.txt ~/BaiJjiaXing_pinyin.txt
hashcat -m 22000 -a 1 Wi-Fi_capture-01.hc22000 ~/BaiJjiaXing_pinyin.txt ~/phone_numbers_dict.txt

# 字母+字典
hashcat -m 22000 -a 6 Wi-Fi_capture-01.hc22000 ~/phone_numbers_dict.txt ?l?l
hashcat -m 22000 -a 6 Wi-Fi_capture-01.hc22000 ~/phone_numbers_dict.txt ?u?u
hashcat -m 22000 -a 7 Wi-Fi_capture-01.hc22000 ?l?l ~/phone_numbers_dict.txt
hashcat -m 22000 -a 7 Wi-Fi_capture-01.hc22000 ?u?u ~/phone_numbers_dict.txt
```

常用参数释义：

```bash
-w 2 # 工作负载，默认为2（均衡模式），可设为3（全力以赴模式，会导致图形界面卡顿）或4（疯狂模式，只建议在纯命令行模式下使用）
-a 0 # 使用单个字典暴力破解
-a 1 # 组合两个字典，详见 https://hashcat.net/wiki/doku.php?id=combinator_attack
-a 3 # 使用掩码匹配所有特定结构的密码，详见 https://hashcat.net/wiki/doku.php?id=mask_attack
-a 6 # 字典+掩码，详见 https://hashcat.net/wiki/doku.php?id=hybrid_attack
-a 7 # 掩码+字典，详见 https://hashcat.net/wiki/doku.php?id=hybrid_attack
-D 1 # 指定使用CPU还是GPU等，默认是1（表示使用CPU），可改为2（使用GPU加速）
```

掩码：

```
- ?l = abcdefghijklmnopqrstuvwxyz
- ?u = ABCDEFGHIJKLMNOPQRSTUVWXYZ
- ?d = 0123456789
- ?h = 0123456789abcdef
- ?H = 0123456789ABCDEF
- ?s = «space»!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~
- ?a = ?l?u?d?s
- ?b = 0x00 - 0xff
```

[^1]: <https://blog.oopsky.top/post/6e155fd/>
[^2]: <https://hashcat.net/hashcat>
[^3]: <https://github.com/hashcat/hashcat>
