---
title:       "MongoDB系列-安装"
subtitle:    "数据库基础"
description: "MongoDB"
date:        2020-06-01
author:      "tomtao626"
image:       ""
tags:        ["Linux", "MongoDB"]
categories:  ["DATABASE"]
---

# 安装
## MacOS安装
Homebrew安装
```shell
brew install mongodb
```

-----------------------------------分割线---------------------------------

手动安装
> + 从`MongoDB`[官网](https://www.mongodb.com/try/download/community) 下载合适的稳定版安装包，格式一般为tgz格式，解压

-----------------------------------分割线---------------------------------

安装修正

### 进入 /usr/local

```shell
cd /usr/local
```


### 下载

```shell
sudo wget https://fastdl.mongodb.org/osx/mongodb-osx-ssl-x86_64-4.0.9.tgz
```

### 解压
```shell
$ sudo tar -zxvf mongodb-osx-ssl-x86_64-4.0.9.tgz
```

### 重命名为 mongodb 目录

```shell
$ sudo mv mongodb-osx-x86_64-4.0.9/ mongodb
```

### 将MongoDB 的二进制命令文件目录（安装目录/bin）添加到 PATH 路径中

```shell
$ export PATH=/usr/local/mongodb/bin:$PATH
```

### 创建data/db 和 logs

```shell
$ sudo mkdir -p /usr/local/mongodb/data/db
$ sudo mkdir -p /usr/local/mongodb/logs
$ sudo touch /usr/local/mongodb/logs/mongodb.log
```

上面的具体文件名根据实际下载的文件来确定。解压完成后，文件夹下会有一个`bin`的子目录，里面包含了运行 `MongoDB` 所需要的可执行文件 `mongod` 和 `mongo`。
> + 默认服务端保存数据到目录`/data/db`。因此需要创建该文件夹。如果不想保存到默认目录，则在运行 `mongod` 的时候需要指定 `dbpath` 参数，即`mongod --dbpath {数据保持路径}`。

### 后台启动

```shell
$ sudo mongod --dbpath /usr/local/mongodb/data/db/ --logpath /usr/local/mongodb/logs/mongodb.log --logappend --port 27017 --bind_ip 0.0.0.0 --fork
```

-----------------------------------分割线---------------------------------

```shell
$ sudo bash
$ mkdir -p /data/db
$ chmod 777 /data
$ chmod 777 /data/db
$ exit
```

> + 运行服务端时，可以在`MongoDB` 的 `bin` 目录下运行`./mongod` 即可，默认端口为`27017`。为了方便，也可以编辑源路径。以`zsh`为例：

```shell
$ vim ~/.zshrc
# 导出 mongod 环境变量
export PATH="{mongo解压目录}/bin"
$ source ~/.zshrc
```

> + 运行客户端时，可以在相同的目录运行`./mongo` 即可。默认会连接到 `test` 数据库。可以运行 `db.test.find()`查找数据（默认是空的）。

## window安装
> + 从`MongoDB`[官网](https://www.mongodb.com/try/download/community) 下载最新稳定版`MongoDB` 社区版,直接安装即可。
> + 默认安装路径为 C:/Program FIles/MongoDB/Server/{版本号}/bin。
> + bin 目录包含了多个可执行文件，包括了 mongod和 mongo。为了在其他目录下运行，需要在path内增加环境变量。

## linux安装(这里以ubuntu为例)
### ubuntu官方源安装
#### 安装MongoDB
首先更新源
```shell
$ sudo apt-get update && sudo apt-get upgrade -y
```
等待完成，继续安装`MongoDB`
```shell
$ sudo apt-get install mongodb
```
安装完成后，服务会自动注册到`systemd`服务管理内，检查服务状态：
```shell
$ sudo systemctl status mongodb
```
![](https://p9-tt.byteimg.com/origin/pgc-image/be8b5abe2efd417e96bfd93ce4544bcb.png)
看到`active(running)`就说明服务已启动成功了。

#### 运行MongoDB
`MongoDB` 目前是一个 `systemd` 服务，因此我们使用 `systemctl` 来检查和修改它的状态，使用以下命令:
```shell
$ sudo systemctl status mongodb
$ sudo systemctl stop mongodb
$ sudo systemctl start mongodb
$ sudo systemctl restart mongodb
```
设置`MongoDB`随系统启动(默认enable:启用)
```shell
# 启用
$ sudo systemctl enable mongodb
# 禁用
$ sudo systemctl disable mongodb
```
使用`MongoDB`，输入：
```shell
$ mongo
```
将启动 `mongo shell`。有关查询和选项的详细信息，请查看[文档](https://docs.mongodb.com/manual/tutorial/getting-started/)

#### 卸载MongoDB
如果你从 `Ubuntu` 官方源安装 `MongoDB` 并想要卸载它（可能要使用官方支持的方式安装），请输入：
```shell
$ sudo systemctl stop mongodb
$ sudo apt purge mongodb
$ sudo apt autoremove
```
以上命令会完全卸载 `MongoDB`。请确保备份你可能想要保留的任何集合或文档。

### 安装 MongoDB 社区版
#### 安装MongoDB
导入公钥
```shell
$ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
```
在源列表中添加一个新的仓库，以便你可以安装 MongoDB 社区版并获得自动更新
```shell
$ echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/4.1 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.1.list
```
更新源
```shell
$ sudo apt-get update
```
安装
```shell
$ sudo apt-get install mongodb-org
```
等待MongoDB安装完成。
默认情况下，使用包管理器（apt-get）更新时，MongoDB 将更新为最新的版本。要阻止这种情况发生（并冻结为已安装的版本），请使用：
```shell
$ echo "mongodb-org hold" | sudo dpkg --set-selections
$ echo "mongodb-org-server hold" | sudo dpkg --set-selections
$ echo "mongodb-org-shell hold" | sudo dpkg --set-selections
$ echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
$ echo "mongodb-org-tools hold" | sudo dpkg --set-selections
```

#### 配置MongoDB
> + 默认情况下，包管理器将创建 `/var/lib/mongodb` 和 `/var/log/mongodb`，`MongoDB` 将使用 `mongodb` 用户帐户运行。
> + 一般不会去更改这些默认设置，因为这超出了本指南的范围。有关详细信息，请查看[文档](https://docs.mongodb.com/manual/tutorial/getting-started/)
> + `/etc/mongod.conf` 中的设置在启动/重新启动 `mongodb` 服务实例时生效。

#### 运行MongoDB
启动 `mongodb` 的守护进程 `mongod`
```shell
$ sudo service mongod start
```
需要验证 mongod 进程是否已成功启动。此信息（默认情况下）保存在 `/var/log/mongodb/mongod.log` 中
```shell
$ sudo cat /var/log/mongodb/mongod.log
```
只要在文件内容看到：`[initandlisten] waiting for connections on port 27017`，就说明进程正常运行。
注意：`27017` 是 `mongod` 的默认端口。
要停止/重启 `mongod`，请输入：
```shell
$ sudo service mongod stop
$ sudo service mongod restart
```
可以通过打开 `mongo shell` 来使用 `MongoDB`:
```shell
$ mongo
```

#### 卸载MongoDB
```shell
$ sudo service mongod stop
$ sudo apt purge mongodb-org*
# 删除数据库和日志文件
$ sudo rm -r /var/log/mongodb
$ sudo rm -r /var/lib/mongodb
```

## 配置开机自启(这里以mac为例)

### 1-了解

> 首先了解一下OSX系统环境下launchd， 其是`Mac OS`下用于初始化系统环境的关键进程，它是内核装载成功之后在OS环境下启动的第一个进程。其实它的作用就是我们平时说的守护进程，简单来说，用户守护进程是作为系统的一部分运行在后台的非图形化程序。采用这种方式来配置自启动项很简单，只需要一个plist文件，该plist文件存在的目录有:

+ `LaunchDaemons ~/Library/LaunchDaemons` 用户登录前运行 `plist`（程序）
+ `LaunchAgents ~/Library/LaunchAgents`   用户登录后运行相应的 `plist`（程序）

### 2-新建.plist

> 所以需要创建一个.plist文件来指定需要开机启动的程序

```shell
sudo vim /Library/LaunchDaemons/org.mongodb.mongod.plist
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN""http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>Label</key>
        <string>org.mongodb.mongod</string>
        <key>ProgramArguments</key>
        <array>
            <string>/usr/local/mongodb/bin/mongod</string>
            <string>run</string>
            <string>--config</string>
            <string>/usr/local/mongodb/bin/mongod.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>/usr/local/mongodb</string>
        <key>StandardErrorPath</key>
        <string>/usr/local/mongodb/logs/error.log</string>
        <key>StandardOutPath</key>
        <string>/usr/local/mongodb/logs/mongo.log</string>
    </dict>
</plist>
```

### 3-新建mongod.conf

> 上面的`.plist`文件中的`mongod.conf`可以在`/usr/local/mongodb/bin/`目录下，新建一个就好，文件格式如下:

```shell
port=27017                                    # 监听端口号
dbpath=/usr/local/mongodb/data/db             # 数据存放位置
logpath=/usr/local/mongodb/logs/mongodb.log   # 日志文件存放位置
fork=true                                     # 是否后台运行
```

### 4-将mongo服务加载到开机启动进程

> 将`org.mongodb.mongod.plist`加载到开机启动进程中:

```shell
launchctl load /Library/LaunchDaemons/org.mongodb.mongod.plist
```
