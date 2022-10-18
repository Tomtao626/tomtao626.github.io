---
layout: mypost
title: Python-开发环境搭建
categories: [Linux, Python]
---

# install

## 安装python2.7

```shell
wget https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz

tar xvf Python-2.7.9.tgz
cd Python-2.7.9
./configure --prefix=/usr/local/python27
make
make install
mv /usr/bin/python /usr/bin/python_old
ln -s /usr/local/python27/bin/python /usr/bin/python
python          # 查看版本

#解决YUM无法使用的问题

vim /usr/bin/yum
vim /usr/bin/repoquery
#两文件首行#!/usr/bin/python 替换为老版本python  #!/usr/bin/python2.6  注意可能为2.4
```

## pip模块安装

```shell
yum install python-pip            # centos安装pip
sudo apt-get install python-pip   # ubuntu安装pip

#pip官方安装脚本
wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
python get-pip.py

#pip编译安装
# https://pypi.python.org/pypi/setuptools
wget http://pypi.python.org/packages/source/s/setuptools/setuptools.tar.gz
tar zxvf setuptools.tar.gz
cd setuptools/
python setup.py build
python setup.py install
# https://pypi.python.org/pypi/ez_setup
tar zxvf ez_setup.tar.gz
cd ez_setup/
python setup.py build
python setup.py install
# https://pypi.python.org/pypi/pip
tar zxvf pip.tar.gz
cd pip/
python setup.py build
python setup.py install

#加载环境变量
vim /etc/profile
export PATH=/usr/local/python27/bin:$PATH
. /etc/profile
pip freeze                      # 查看包版本
pip install -r file             # 安装包文件列表
pip install Package             # 安装包 pip install requests
pip show --files Package        # 查看安装包时安装了哪些文件
pip show --files Package        # 查看哪些包有更新
pip install --upgrade Package   # 更新一个软件包
pip uninstall Package           # 卸载软件包
pip list                        # 查看pip安装的包及版本
pip install django==1.5         # 指定版本安装
pip install  kafka-python -i http://pypi.douban.com/simple --trusted-host pypi.douban.com

#python3安装
yum install python36.x86_64 python36-pip
```