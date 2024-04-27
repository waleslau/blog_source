---
title: 在 Linux 上部署服务之 Kafka
abbrlink: 85d5b333
date: 2023-09-08 02:32:58
updated: 2023-09-08 16:50:16
tags:
  - kafka
  - linux
---

## 1. 下载、解压

```bash
cd /opt
wget http://mirrors.estointernet.in/apache/kafka/3.2.0/kafka_2.13-3.2.0.tgz
mkdir kafka
tar -zxvf kafka_2.13-3.2.0.tgz --strip-component=1 -C kafka
# 创建用来运行kafka的系统用户
useradd -r -s /bin/bash -d /opt/kafka/ kafka
chown -R kafka:kafka /opt/kafka/
# 把 kafka/bin 加入PATH
echo 'export PATH=$PATH:/opt/kafka/bin' >> /etc/profile.d/dev_libs.sh
. /etc/profile.d/dev_libs.sh
```

## 2. 基本配置

下面两种方式二选一，无特别要求就选 Kafka With KRaft，也即是官方推荐的方式[^1]

### 2.1 Kafka With KRaft

> 在 Kafka 2.8.0 之后的版本中，已经不再使用 ZooKeeper 作为默认的协调器，并且在命令行工具中也不再支持--zookeeper 选项，改为使用内置的协调器（称为 KRaft）来管理主题、分区和其他元数据。

```bash
# 切换到 kafka 用户
su - kafka

# 修改配置中的 log.dirs
# vim /opt/kafka/config/kraft/server.properties
# log.dirs=/opt/kafka/config/kraft/kraft-combined-logs

# 生成 UUID
KAFKA_CLUSTER_ID=`/opt/kafka/bin/kafka-storage.sh random-uuid`

# 在启动节点之前需要用格式化一下日志目录
/opt/kafka/bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c /opt/kafka/config/kraft/server.properties

# 启动服务测试一下
/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/kraft/server.properties
```

创建 systemd 服务文件

```ini
# /lib/systemd/system/kafka_no-zk.service
[Unit]
Description=kafka
After=network.target

[Service]
Type=simple
User=kafka
ExecStart=/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/kraft/server.properties
ExecStop=/opt/kafka/bin/kafka-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
```

启动

```bash
systemctl daemon-reload
systemctl enable --now kafka_no-zk.service
systemctl restart kafka_no-zk.service
systemctl status kafka_no-zk.service
```

### 2.2 Kafka With ZooKeeper

```bash
# /opt/kafka/config/zookeeper.properties
dataDir=/opt/kafka/data/zookeeper # 修改存储位置为 /opt/kafka/data/zookeeper

# /opt/kafka/config/server.properties
log.dirs=/opt/kafka/data/kafka # 修改存储位置为 /opt/kafka/data/kafka
delete.topic.enable = true # 添加配置，允许删除主题

# 再次设定权限
chown -R kafka:kafka /opt/kafka/
```

创建 systemd 服务文件

```ini
# /lib/systemd/system/zookeeper.service
[Unit]
Description=zookeeper
After=network.target

[Service]
Type=simple
User=kafka
ExecStart=/opt/kafka/bin/zookeeper-server-start.sh /opt/kafka/config/zookeeper.properties
ExecStop=/opt/kafka/bin/zookeeper-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
```

```ini
# /lib/systemd/system/kafka.service
[Unit]
Requires=zookeeper.service
After=zookeeper.service
Description=kafka
After=network.target

[Service]
Type=simple
User=kafka
ExecStart=/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
ExecStop=/opt/kafka/bin/kafka-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
```

启动

```bash
systemctl daemon-reload

# 先启动zookeeper
systemctl enable --now zookeeper.service
# 查看状态
systemctl status zookeeper.service

# 然后启动 kafka
systemctl enable --now kafka.service
# 查看状态
systemctl status kafka.service
```

## 3. 测试

```bash
# 创建一个主题
kafka-topics.sh --create --bootstrap-server localhost:9092 --topic testTopic
# 显示使用信息
kafka-topics.sh --describe --bootstrap-server localhost:9092 --topic testTopic
# 将一些事件写入主题（生产者）
echo "Hello, World" | kafka-console-producer.sh --broker-list localhost:9092 --topic testTopic
cat /etc/os-release | kafka-console-producer.sh --broker-list localhost:9092 --topic testTopic
# 从主题读取事件（消费者）
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic testTopic --from-beginning
```

[^1]: [https://kafka.apache.org/quickstart](https://kafka.apache.org/quickstart)
