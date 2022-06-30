---
layout: mypost
title: Ubuntu16.04下多版本python安装记录
categories: [Python, Ubuntu]
---

# 前情提要
> ubuntu16.04自带python2.7和python3.5,但是由于想要使用一些新的python特性,py3.6以后的版本才支持,所以需要安装新版本的py,故记录一下

执行`whereis python`查看当前安装的python

```shell
whereis python
# python: /usr/bin/python2.7 /usr/bin/python /usr/lib/python2.7 /usr/lib64/python2.7 /etc/python /usr/include/python2.7 /usr/share/man/man1/python.1.gz
```

## 1-配置py依赖环境

```shell
sudo apt-get install zlib1g-dev libbz2-dev libssl-dev libncurses5-dev libsqlite3-dev
```

## 2-下载官网源码包Python-3.8.12.tar.xz

```shell
wget https://www.python.org/ftp/python/3.8.12/Python-3.8.12.tar.xz
```

> 如果下载失败

+ > 1.将服务器DNS改成 8.8.8.8
+ > 2.将源改为清华或者豆瓣源

## 3-解压源码包

### 方法一

```shell
tar -xvJf  Python-3.8.12.tar.xz
```

### 方法二

```shell
xz -d Python-3.8.12.tar.xz
tar -xf Python-3.8.12.tar
```

## 4-切到解压后的文件目录

```shell
cd Python-3.8.12/
```

## 5-再次安装依赖(非必要，可跳过此步骤，如在5步出错在执行本步骤)

> 执行下列命令安装依赖过程中,如有提示,一律输入`y`回车

```shell
sudo apt-get install python-dev
sudo apt-get install libffi-dev
sudo apt-get install libssl-dev
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev
```

## 6-指定安装路径并编译安装

```shell
./configure prefix=/usr/local/python3.8
make && make install
```

## 7-更新软连接(配置全局变量)

```shell
# 将原来的链接备份
# mv /usr/bin/python /usr/bin/python.bak(根据实际情况使用)
# 添加python3.8的软链接
ln -s /usr/local/python3.8/bin/python3.8 /usr/bin/python3.8
# 测试是否安装成功了
python3.8 -V
# Python 3.8.12
```

## 8-安装/升级pip(根据自己需求对应选择)

### 方法一

```shell
# 这句是给(python2.7安装pip)
sudo apt-get install python-pip
```

```shell
# 这句是给python3安装pip
sudo apt-get install python3-pip
```

### 方法二

```shell
# 使用官方的get-pip.py文件,并使用对应的python版本安装,再建立软链接即可
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
# 执行安装
python3.8 get_pip.py
# 建立软链接
ln -s /usr/local/python3.8/bin/pip3.8 /usr/bin/pip3.8
# 测试
pip3.8 -V
# pip 21.3.1 from /usr/local/python3.8/lib/python3.8/site-packages/pip (python 3.8)
```

> 执行升级(适用于安装pip方法一)

```shell
pip install --upgrade pip
pip3 install --upgrade pip
pip3.8 install --upgrade pip
```

> 如果升级pip时出现了以下问题：

```shell
Traceback (most recent call last):
  File "/usr/bin/pip", line 9, in <module>
    from pip import main
```

> 使用python命令即可

```shell
python3.8 -m pip3.8 install --upgrade pip
```