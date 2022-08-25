---
layout: mypost
title: Nginx安装和配置
categories: [Nginx, Linux]
---

1.使用远程工具ssh连接linux
2.需要准备的文件
![img_3.png](/posts/2019/01/02/img_3.png)
wget http://nginx.org/download/nginx-1.12.2.tar.gz
3.安装nginx
3.1 pcre安装依赖
(1)安装pcre依赖
wget http://downloads.sourceforge.net/project/pcre/pcre/8.37/pcre-8.37.tar.gz
解压缩文件
tar -xvf pcre-8.37.tar.gz
编译安装
./configure
make && make install
pcre-config --version
(2)安装openssl,zlib,gcc依赖
yun -y install make zlib zlib-devel gcc-c++ libtool openssl openssl-devel
(3)安装nginx
# 解压 进入解压后的文件目录
tar -xvf nginx-1.12.2.tar.gz && cd nginx-1.12.2.tar.gz
# 安装配置
./configure
# 编译安装
make && make install
4.启动nginx
进入目录 `进入目录 /usr/local/nginx/sbin/nginx 启动服务` 启动服务
5.防火墙firewall
(1) 查看开放的防火墙端口
# 查看开放的防火墙端口
firewall-cmd --list-all
![img.png](/posts/2019/01/02/img.png)
(2)设置开放的端口
firewall-cmd --add-port=8001/tcp --permanent
![img_2.png](/posts/2019/01/02/img_2.png)
(3)重启防火墙
firewall-cmd --reload
# 查看开放的防火墙端口

6.nginx常用命令
(1)查看版本号
nginx -v
![img_1.png](/posts/2019/01/02/img_1.png)
(2)启动
service nginx start
systemctl start nginx
(3)停止
nginx -s stop
(4)重新加载
nginx -s reload
