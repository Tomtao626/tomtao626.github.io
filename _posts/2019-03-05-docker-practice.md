---
layout: mypost
title: Docker实操
categories: [Linux, Docker]
---

# 1 开发环境准备

> centos 7
>
> + 2h4g * 2
> + install plugins
> + install docker

## 1.2 查看网络，安装必要组件

> 删除本地源，添加新的yum repo

```shell
ping www.baidu.com
rm /etc/yum.repos.d/local.repo
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum install epel-release -y
```

## 1.3 安装docker包

```shell
yum list --show-duplicates
yum install -y yum-utils
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum list docker-ce --show_duplicates
yum install -y docker-ce
```

> **ping**：执行ping指令会使用ICMP传输协议，发出要求回应的信息，若远端主机的网络功能没有问题，就会回应该信息，因而得知该主机运作正常
>
> **rm** ：命令用于删除一个文件或者目录。
>
> **curl**：支持文件的上传和下载，是综合传输工具
>
> **yum**：提供了查找、安装、删除某一个、一组甚至全部软件包的命令，
>
> + **install**：安装
>
> + **-y**：安装过程的提示选择全部为"yes"

## 1.4 设为开机启动，启动并修改相关配置

```shell
systemctl enable docker
systemctl start docker
vim /etc/docker/daemon.json
{
    "graph": "/data/docker",
    "storage-driver": "overlay2",
    "insecure-registries": ["registry.access.redhat.com","quay.io"],
    "registry-mirrors": ["https://q2gr04ke.mirror.aliyuncs.com"],
    "bip": "172.7.5.1/24",
    "exec-opts": ["native.cgroupdriver=systemd"],
    "live-restore": true
    }
```

## 1.5 重启docker，使配置生效

```shell
systemctl reset-failed docker.service
systemctl start docker.service
systemctl restart docker
systemctl status docker
docker info
```

> **daemon.json**文件内容解析：
>
> + graph：docker的工作目录，docker会在下面生成一大堆文件
> + storage-driver： 存储驱动
> + insecure-registries：私有仓库
> + registry-mirrors：国内加速源
> + bip：docker容器地址（ip的中间两位和我现在的外网129.204.217.99的后两位有对照关系，方便出问题了快速定位在哪个宿主机，但是我这里没改）
> + live-restrore：容器引擎死掉的事情，起来的docker是否继续活着
>
> systemctl status：查看服务信息
>
> docker info：查看docker信息

# 2.启动一个docker容器

```shell
docker run hello-world
```

> **docker run**: 创建一个新的容器并运行，现在本地是没有镜像的，但是会自动拉取网路上的
>
> + 语法: docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

## 2.1 DockerHub注册

> 登录你的远程仓库

```shell
docker login docker.io
```

> 你的登录信息在这里

```shell
cat /root/.docker/config.json
```

> 复习：
>
> + cat：用于连接文件并打印内容到页面

## 2.2 Docker镜像管理实战

```shell
docker search alpine
docker pull alpine
docker pull alpine:3.10.3
docker pull alpine:3.10.1
```

> **docker pull**: 从镜像仓库中拉取或更新镜像
>
> + 语法: **docker pull [OPTIONS] NAME[:TAG|@DIGEST]*

```shell
docker images
docker image ls
docker tag 965ea09ff2eb docker.io/tomtaodev/alpine:v3.10.3
```

> **docker images/docker image ls :** 列出本地镜像
>
> **docker tag**：标记本地镜像，将其归入某一仓库
>
> + 语法：docker tag [OPTIONS] IMAGE[:TAG] [REGISTRYHOST/][USERNAME/]NAME[:TAG]

```shell
docker push tomtaodev/alpine:v3.10.3
```

> **docker push**：将本地的镜像上传到镜像仓库,要先登陆到镜像仓库，带版本号
>
> + 语法：docker push [OPTIONS] NAME[:TAG]

```shell
docker rmi 965ea09ff2eb
docker rmi -f 965ea09ff2eb
docker pull tomtao626/alpine 拉取自己远程仓库的镜像
```

> **docker rmi**：删除本地一个或多少镜像
>
> + **-f**：强制删除

### note

> 镜像不管多大，实际线上只会改变变动的部分，并不会全部替换，所以不需要担心速度问题，只有首次比较慢

## 2.3 Docker容器基本操作

> 查看全部有记录的容器进程

```shell 
docker ps -a
```

存活的容器进程

```shell 
docker ps
```

启动容器（运行容器）

```shell
docker run [options] image[command]
```

过滤出全部已退出的容器并删除

```shell 
for i in `docker ps -a|grep -i exit|awk '{print $1}'`;do docker rm -f $i;done
```

查看日志

```shell 
docker log -f <容器ID>
```

> **Ctrl+c:** 强制中断程序的执行
>
> **Ctrl+z:** 将任务中断,但是此任务并没有结束,他仍然在进程中他只是维持挂起的状态

## 2.4 Docker容器高级操作

- 映射端口

```shell
docker run -p 容器外(宿主机)端口:容器内端口
```

- 挂载数据卷

```shell
docker run -v 容器外(宿主机)目录:容器内目录
```

- 传递环境变量

```shell
docker run -e 环境变量key:环境变量value
```

- 查看内容

```shell
docker inspect <容器ID>
```

- 容器内安装工具

```shell
yum/apt-get/apt install ...
```

### 2.3.1 映射端口

```shell
docker pull nginx:1.12.2
docker images
docker tag 4037a5562b03 tomtaodev/nginx:v1.12.2
docker push tomtaodev/nginx:v1.12.2
docker images
docker run --rm --name mynginx -d -p81:80 tomtaodev/nginx:v1.12.2
docker ps -a
netstat -luntp|grep 81
curl 127.0.0.1:81
docker
```

> **docker run**
> 
> + **--rm**: 用完即删
> + **--name**: 指定名称
> + **-d**: 后台运行 非交互式
> + **-p81:80: 映射端口，宿主机跑在81端口，容器（nginx）跑在80端口
> 
> **docker push**: 推送到个人的dockerhub远程仓库（公网）
> 
> **netstat -luntp**: 用于显示tcp/udp的端口和进程等等情况
> 
> **｜grep**: 过滤管道

### 2.3.2 挂载数据卷

```shell
mkdir html
cd html/
wget www.baidu.com -O index.html
docker run -d --rm --name nginx_with_baidu -d -p82:80 -v/root/html:/usr/share.nginx/html tomtaodev/nginx:v1.12.2
docker exec -ti nginx_with_baidu /bin/bash
cd /usr/share/nginx/html/
ls
tee /etc/apt/sources.list << EOF deb http://mirrors.163.com/debian/ jessie main non-free contrib deb http://mirrors.163.com/debian/ jessie-updates main non-free contrib EOF
apt-get update && apt-get install curl -y
curl -k https://www.baidu.com
exit
docker ps -ad
docker commit c7822b04c807 tomtaodev/nginx:curl
docker push tomtaodev/nginx:curl
```

> **-v**: 挂载数据卷，/root/html是宿主机的数据卷，/usr/share/nginx/html是容器的数据卷

## 2.5 Dockerfile

> **WHAT**: 通过指令编排镜像，实现自动化构建镜像

## 核心的Dockerfile指令（4组）

- USER/WORKDIR
- ADD/EXPOSE
- RUN/ENV
- CMD/ENTRYPONINT

### Dockerfile实战

```shell
mkdir /data/dockerfile
vim /data/dockerfile/Dockerfile
```

```dockerfile
FROM tomtaodev/nginx:v1.12.2
USER root
ENV WWW /usr/share/nginx/html
ENV CONF /etc/nginx/conf.d
RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\ 
    echo 'Asia/Shanghai' >/etc/timezone
WORKDIR $WWW
ADD index.html $WWW/index.html
ADD demo.od.com.conf $CONF/demo.od.com.conf
EXPOSE 80
CMD ["nginx","-g","daemon off;"]
```

> 运行一个docker容器，在浏览器中打开demo.od.com，可以访问百度首页

> **vi**: 编辑文本
>
> **FROM**：从哪里导入
>
> **USER**：用什么用户起
>
> **ENV**：设置环境变量
>
> **RUN**： 修改时区成中国时区'Asia/Shanghai'
>
> **WORKDIR**：指定工作目录，这里指定的是之前ENV指定的WWW 目录，即是/usr/share/nginx/html
>
> **ADD**：添加指定的东西进去
>
> **EXPOSE**：暴露端口
>
> **CMD**：指令的首要目的在于为启动的容器指定默认要运行的程序，程序运行结束，容器也就结束

```shell
vim demo.od.com.conf
```

```relax-ng
server {
   listen 80;
   server_name demo.od.com;
   root /usr/share/nginx/html;
}
```

```shell
wget www.baidu.com -O index.html
docker build . -t tomtaodev/nginx:baidu
docker run --rm -p80:80 tomtaodev/nginx:baidu
```

> **ll**：显示当前目录的文件
>
> **wget**：下载文件工具
>
> + **-O**：并将文档写入后面指定的文件（这里是index.html）

### dockerfile四种网络类型

- Bridge contauner（NAT）   桥接式网络模式(默认)
- None(Close) container   封闭式网络模式，不为容器配置网络
- Host(open) container   开放式网络模式，和宿主机共享网络
- Container(join) container   联合挂载式网络模式，和其他容器共享网络

> 用什么类型的网络要根据我们的业务去决定