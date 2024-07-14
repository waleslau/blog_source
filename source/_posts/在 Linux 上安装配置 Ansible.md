---
title: 在 Linux 上安装配置 Ansible
abbrlink: 7574f282
date: 2024-07-11 21:21:21
updated: 2024-07-11 21:21:21
tags:
  - linux
  - ansible
---
## 安装 Ansible

首先创建我们接下来学习 Ansible 过程中使用的工作目录

```bash
mkdir -p ~/ansible_playground
```

使用各家包管理器安装或使用 pip 安装均可，以 pip 为例

```bash
cd ~/ansible_playground
python3 -m venv venv
source venv/bin/activate
pip install ansible
```

使用这种方式安装的 ansible 在每次使用前都需要执行 `source venv/bin/activate` 切换一下环境。

## 创建 ansible 配置

在工作目录下创建 ansible 配置文件 `ansible.cfg`：

```yml
# ~/ansible_playground/ansible.cfg
[defaults]
inventory=hosts
```

这里的 `hosts` 是受控设备清单，下面会提到。

## 修改 ssh 配置

只需要在安装了 ansible 的设备上修改，不改也行，我是因为每次重新使用 docker 建立容器后 key 都会变化，以至于每次都要求我重新确认，实在让人恼火才改的 hhh。

```bash
# /etc/ssh/ssh_config
StrictHostKeyChecking no
# 当设置为 `yes` 时，SSH 客户端会严格检查主机密钥，如果主机密钥发生变化或未知，则连接会被拒绝并提示密钥不匹配的错误信息。
# 如果设置为 `no`，则 SSH 客户端会自动接受新的主机密钥，而不会提示错误信息。
```

## 建立试验场

我原本打算开一个虚拟机作为受控设备，突然想到可以用 docker 实现这个需求，好处是随用随开，且开销极低。虽然现在的 Ansible 能够直接连接到 docker 容器了，但只是练习的话这么搞~~应该是没啥问题的。~~**涉及到部署服务还是得虚拟机，在容器里折腾 systemd 有点蛋疼且不够清真。**

下面是 Dockerfile：

```dockerfile
FROM ubuntu:latest

RUN apt-get update && apt-get install openssh-server sudo rsync -y

RUN echo 'root:root' | chpasswd

RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

RUN echo 'UseDNS no' >> /etc/ssh/sshd_config

RUN userdel ubuntu && rm -rf /home/ubuntu

RUN useradd -m -s /bin/bash -g root -G sudo -u 1000 idea

RUN echo 'idea:idea' | chpasswd

RUN echo 'idea ALL=(ALL) NOPASSWD: ALL' | tee -a /etc/sudoers

RUN service ssh start

EXPOSE 22 80

CMD ["/usr/sbin/sshd","-D"]
```

然后可以构建镜像，并测试是否可用：

```bash
# 构建镜像
docker build -t ubuntu:ssh .

# 批量创建容器
for i in 1 2; do docker run -d --name ubuntu_ssh_$i -p 300$i:22 -p 808$i:80 ubuntu:ssh; done;

# 测试是否可用
ssh ssh://idea@127.0.0.1:3001
```
## 编辑受控设备清单

根据上面创建的容器的端口等信息编写 `hosts` 文件：

```ini
# ~/ansible_playground/hosts
[ubuntu_idea]
vm1 ansible_ssh_host=127.0.0.1 ansible_ssh_user='idea' ansible_ssh_port=3001 ansible_ssh_pass='idea'
[ubuntu_root]
vm2 ansible_ssh_host=127.0.0.1 ansible_ssh_user='root' ansible_ssh_port=3002 ansible_ssh_pass='root'
```

## 测试
```bash
[idea@archlinux ansible_playground]$ ansible all -m ping
vm2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
vm1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

[idea@archlinux ansible_playground]$ ansible ubuntu_idea -m shell -a 'cat /etc/hostname'
vm2 | CHANGED | rc=0 >>
1b6f5bc4d9a2
vm1 | CHANGED | rc=0 >>
4c74b855f4a1
```

成功了🎉
