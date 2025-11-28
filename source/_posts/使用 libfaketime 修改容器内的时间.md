---
title: 使用 libfaketime 修改容器内的时间
abbrlink: 5bbfeefd
date: 2025-11-28 12:15:03
updated: 2025-11-28 17:12:56
tags:
  - linux
  - docker
  - faketime
---

今天在传一些十几年前的相片录像啥的到飞牛里时发现有些文件的元数据里的创建时间有问题，导致它们在我相册里的先后顺序没被识别对，为了能在飞牛相册里生成正确的时间线，需要修改这些文件的创建时间为大致正确的时间，同时又希望尽量缩小影响范围，不想通过修改整个系统的时间来做这个事。

先是找到了 libfaketime[^3] 这个工具，但这个库只对当时运行的二进制有关，影响不到正在运行的文件系统，或许有某种办法可以在挂载文件系统时或更早的阶段让 libfaketime 介入，但我感觉有点风险，为了数据安全就先放下了这个想法。

后来在查资料的过程中发现还可以在容器里面利用 libfaketime  修改容器内部时间 [^1]，妥了，容器里边就可以随便造了哈哈，只需要把文件所在目录挂载到容器内，然后在容器内把要处理的文件 copy 到挂载目录之外的其他位置 [^2] 再覆盖回来,就可以把创建时间变成过去的时间了，下面是步骤：

1. 创建 Dockerfile 文件：`mkdir faketime && cd faketime && vim Dockerfile`

```Dockerfile
FROM m.daocloud.io/docker.io/alpine:latest
RUN sed -i 's#https\?://dl-cdn.alpinelinux.org/alpine#https://mirror.nju.edu.cn/alpine#g' /etc/apk/repositories
RUN apk update && apk add make gcc g++ git fd bash
RUN git clone https://hk.gh-proxy.org/https://github.com/wolfcw/libfaketime && \
    cd libfaketime/src && make install

# 设定固定日期
#ENV LD_PRELOAD=/usr/local/lib/faketime/libfaketime.so FAKETIME="2012-01-22 8:22:22"
# 设定“起始于”日期，容器启动后容器内时间将会在设定日期基础上实时变化
ENV LD_PRELOAD=/usr/local/lib/faketime/libfaketime.so FAKETIME="@2012-01-22 8:22:22"
```

2. 构建容器：

```bash
docker build -t faketime:v1 ./
```

2. 启动容器：

```bash
# 直接启动容器
docker run -it --rm --volume /data/Camera:/data time:v1 bash
# 可以在启动容器时重新设定 FAKETIME 变量
docker run -it --rm --volume /data/Camera:/data -e FAKETIME="2015-01-22 8:22:22" time:v1 bash
```

3. 处理文件：

```bash
cp /data/*.VDI ~/
mkdir -p /data/vdi-bak && mv /data/*.VDI /data/vdi-bak
mv ~/*.VDI /data/
```

4. 验证：

```bash
[idea@MiniPC /data/Camera]# stat SUNP0117.AVI
# File: SUNP0117.AVI
#  Size: 4919296         Blocks: 9608       IO Block: 4096   regular file
# Device: 8,17    Inode: 25305122    Links: 1
# Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
# Access: 2012-01-22 16:20:40.000000000 +0800
# Modify: 2012-01-22 16:20:40.000000000 +0800
# Change: 2025-11-27 21:45:46.431720916 +0800
#  Birth: 2025-11-27 21:45:46.418387463 +0800
```

可以看到，修改生效了。

[^3]: <https://github.com/wolfcw/libfaketime>
[^1]: 在此之前我还尝试了直接 exec 进容器修改时间，但提示缺少相关权限导致改不了，搜到的资料里说切到特权模式硬改的话会把宿主机的时间也改了，遂放弃。
[^2]: 如果只是在挂载目录内操作，其实还是等同于直接在外面的文件系统操作，但外面的文件系统是已经运行在真实的时间下的，libfaketime 无法对它施加影响。
