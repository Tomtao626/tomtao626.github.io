---
layout: mypost
title:       "Ubuntu Wireshark permission问题"
subtitle:    "Linux使用"
description: "ubuntu-wireshark"
date:        2020-06-16
author:      "Tomtao626"
image:       ""
tags:        ["Wireshark", "Tips"]
categories:  ["LINUX"]
---

# 问题描述

> 由于工作原因，转到Ubuntu下开发，需要使用wireshark进行抓包，打开软件却出现如下提示信息
> + ```The capture session could not be initiated on interface ‘eno1’ (You don’t have permission to capture on that device).Please check to make sure you have sufficient permissions, and that you have the proper interface or pipe specified```
> + 说白了就是权限问题，给当前用户给予对应权限，重启wireshark即可。

# 解决办法
> 所有命令需在root用户下执行
> + 新建用户组
> + ```sudo groupadd wireshark```
> + 更改用户组
> + ```sudo chgrp wireshark /usr/bin/dumpcap```
> + 更新权限
> + ```sudo chmod 4755 /usr/bin/dumpcap```
> + 添加某个用户到用户组
> + ```sudo gpasswd -a username wireshark```

# 命令解释

## chgrp
> + Linux chgrp（英文全拼：change group）命令用于变更文件或目录的所属群组。
> + 与 chown 命令不同，chgrp 允许普通用户改变文件所属的组，只要该用户是该组的一员。
> + 在 UNIX 系统家族里，文件或目录权限的掌控以拥有者及所属群组来管理。您可以使用 chgrp 指令去变更文件与目录的所属群组，设置方式采用群组名称或群组识别码皆可。

### 语法
> + ```chgrp [-cfhRv][--help][--version][所属群组][文件或目录...] 或 chgrp [-cfhRv][--help][--reference=<参考文件或目录>][--version][文件或目录...]```

### 参数说明
> + -c或--changes 效果类似"-v"参数，但仅回报更改的部分。
> + -f或--quiet或--silent 　不显示错误信息。
> + -h或--no-dereference 　只对符号连接的文件作修改，而不更动其他任何相关文件。
> + -R或--recursive 　递归处理，将指定目录下的所有文件及子目录一并处理。
> + -v或--verbose 　显示指令执行过程。
> + --help 　在线帮助。
> + --reference=<参考文件或目录> 　把指定文件或目录的所属群组全部设成和参考文件或目录的所属群组相同。
> + --version 　显示版本信息。

## gpasswd
> + Linux gpasswd 是 Linux 下工作组文件 /etc/group 和 /etc/gshadow 管理工具，用于将一个用户添加到组或者从组中删除。

### 语法
> + ```gpasswd [可选项] 组名```

### 参数说明
> + -a：添加用户到组；
> + -d：从组删除用户；
> + -A：指定管理员；
> + -M：指定组成员和-A的用途差不多；
> + -r：删除密码；
> + -R：限制用户登入组，只有组中的成员才可以用newgrp加入该组







