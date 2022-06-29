---
layout: mypost
title:       "Redis源码安装过程及问题记录"
subtitle:    "数据库基础"
description: "redis-source code-install"
date:        2020-06-20
author:      "Tomtao626"
image:       ""
tags:        ["Redis", "Tips"]
categories:  ["DATABASE"]
---

# redis包下载地址
[redis下载点击这里](https://download.redis.io/releases/)

# 下载redis压缩包

![](https://p5-tt.byteimg.com/origin/pgc-image/6ffe363c7111404384ce8337316f80a2.png)

> 点击下载所需的版本即可

# redis包上传服务器
`scp redis-6.0.9.tar.gz root@172.16.111.134:/usr/local/`等待上传完成

![](https://p9-tt.byteimg.com/origin/pgc-image/c8e53accbcc14b5cb53b94156526d565.png)

# 解压
`tar -xzvf redis-6.0.9.tar.gz`

![](https://p6-tt.byteimg.com/origin/pgc-image/9e82a5754c0c402e9ffccec3d492c7df.png)

# 重命名
`mv redis-6.0.9.tar.gz redis`

![](https://p6-tt.byteimg.com/origin/pgc-image/7a539e0fbe8f4b018234c73ffeda02bb.png)

# 安装相关依赖
`yum install -y gcc tcl zlib-devel openssl-devel`

![](https://p26-tt.byteimg.com/origin/pgc-image/6591eddee20448a6a4f0350621c01acd.png)

# 进入redis所在目录,并编译安装redis
`cd redis`
`make MALLOC=libc`
> 关于`MALLOC`这个参数，如果有`MALLOC`这个环境变量， 会有用这个环境变量的去建立`Redis`。
而且`libc`并不是默认的分配器， 默认的是`jemalloc`, 因为`jemalloc`被证明,比`libc`有更少的`fragmentation problems`。
但是如果你又没有`jemalloc`,而只有`libc`当`make`编译出错。 所以加这么一个参数。

![](https://p26-tt.byteimg.com/origin/pgc-image/be852ecab6464e47b43fc4077af6dedd.png)

> 耐性等待，会发现编译报错了。

![](https://p6-tt.byteimg.com/origin/pgc-image/2391789f891b496487b04163d1580e59.png)

# 错误分析及解决
> 由于make编译需要用到gcc，而gcc依赖了很多东西，有些包可能系统已经装了（虽然上面已经安装过gcc了，但是可能gcc的一些依赖会缺失），有些没有，防止出意外，最好都走一遍
> + 首先查看gcc版本 `gcc -v`
> + 需要安装/升级SCL(centos软件选集) `yum install -y centos-release-scl`
> + 安装gcc其他依赖`yum -y install devtoolset-9-gcc devtoolset-9-gcc-c++ devtoolset-9-binutils`
> + 临时启用新版本gcc `scl enable devtoolset-9 bash`

# 重新编译执行
> 请注意为了防止出意外，make失败后在make的话，清理一下，执行`make clean`
再执行`make install PREFIX=/usr/local/redis`,redis执行了make install后，redis的可执行文件都会自动复制到 /usr/local/bin 目录

![](https://p26-tt.byteimg.com/origin/pgc-image/66d53b2b5048484b825d0937ac1556f9.png)

再次执行`make test`

![](https://p26-tt.byteimg.com/origin/pgc-image/b688375b8d8146b68c40f777bbe42e34.png)

会提示no error，基本上就安装完成了

![](https://p5-tt.byteimg.com/origin/pgc-image/a8c34aaa3f51473983504591b38274cf.png)

# 命令复制
> 把redis的一些命令脚本拷贝到PATH变量所在的目录
`cp -a src/redis-server src/redis-cli src/redis-sentinel src/redis-trib.rb src/redis-check-aof src/redis-check-rdb src/redis-benchmark /usr/local/bin/`
> 那个/usr/local/bin，就是PATH变量的目录，这样就可以直接执行redis的一些命令了

# redis相关命令
> + `redis-server`        redis服务器
> + `redis-cli`           redis命令行客户端
> + `redis-benchmark`     redis性能测试工具
> + `redis-check-aof`     aof文件修复工具
> + `redis-check-dump`    rdb文件检查工具

# redis启动(后台运行)
`redis-server`

![](https://p5-tt.byteimg.com/origin/pgc-image/3ba93f8111f84ec2b9dbab91200e4bde.png)

> 可以看到redis已经运行起来了，但是当终端关闭，服务就会挂掉，所以需要配置redis后台运行
> 直接修改配置文件redis.conf内的`daemonize`属性为yes,再使用修改修改后的配置文件重启redis就可以了

![](https://p26-tt.byteimg.com/origin/pgc-image/9febbf0d8f6f4e4cba16810ed27695b5.png)

# 进入redis-cli终端

![](https://p9-tt.byteimg.com/origin/pgc-image/f2515e9ad10049a5b397bd3b99402399.png)

> 可以看到,随意使用相关的redis操作命令都是没问题的。