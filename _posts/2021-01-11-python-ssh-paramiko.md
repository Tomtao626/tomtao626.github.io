---
layout: mypost
title: Python之SSH-paramiko模块的使用
categories: [Python, Linux]
---

# 1-基本介绍

> 用于帮助开发者通过代码远程连接服务器，并对服务器进行操作。

```bash 
python -m pip3 install paramiko
```

# 2-通过用户名密码方式远程执行命令

```python
import paramiko

# 创建SSH对象
ssh = paramiko.SSHClient()

# 允许连接不在know_hosts文件中的主机
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

# 连接服务器
ssh.connect(hostname='192.168.10.8', port=22, username='root', password='123456')

# 执行命令
stdin, stdout, stderr = ssh.exec_command('df')
# 获取命令结果
result = stdout.read()
# 关闭连接
ssh.close()

print(result.decode('utf-8'))
```

# 3-通过用户名密码方式上传下载文件

```python
import paramiko

transport = paramiko.Transport(('192.168.10.8', 22))
transport.connect(username='root', password='123456')
sftp = paramiko.SFTPClient.from_transport(transport)

# 将location.py 上传至服务器 /tmp/test.py
# sftp.put('123.txt', '/data/123.txt')
sftp.get('/data/123.txt', '123.txt')

transport.close()
```

# 4-通过公钥私钥远程执行命令

```python
import paramiko

private_key = paramiko.RSAKey.from_private_key_file(r'~/.ssh/id_rsa')

# 创建SSH对象
ssh = paramiko.SSHClient()
# 允许连接不在know_hosts文件中的主机
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
# 连接服务器
ssh.connect(hostname='192.168.10.8', port=22, username='root', pkey=private_key)

# 执行命令
stdin, stdout, stderr = ssh.exec_command('df')
# 获取命令结果
result = stdout.read()

# 关闭连接
ssh.close()

print(result)
```

# 5-通过公钥私钥远程上传下载文件

```python
import paramiko

private_key = paramiko.RSAKey.from_private_key_file(r'~/.ssh/id_rsa')

transport = paramiko.Transport(('192.168.10.8', 22))
transport.connect(username='root', pkey=private_key)

sftp = paramiko.SFTPClient.from_transport(transport)
# 将location.py 上传至服务器 /tmp/test.py
# sftp.put('/tmp/123.py', '/tmp/123.py')

# 将remove_path 下载到本地 local_path
# sftp.get('123.py', '123.py')

transport.close()
```

# 6-通过私钥字符串远程连接服务器

```python
# 也可以是存在于数据库中
key = """-----BEGIN RSA PRIVATE KEY-----
......
-----END RSA PRIVATE KEY-----"""

import paramiko
from io import StringIO

private_key = paramiko.RSAKey(file_obj=StringIO(key))

# 创建SSH对象
ssh = paramiko.SSHClient()
# 允许连接不在know_hosts文件中的主机
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
# 连接服务器
ssh.connect(hostname='192.168.10.8', port=22, username='root', pkey=private_key)

# 执行命令
stdin, stdout, stderr = ssh.exec_command('df')
# 获取命令结果
result = stdout.read()

# 关闭连接
ssh.close()

print(result)
```

# 7-生成公钥私钥并上传

```bash
# 1 生成公钥和私钥s
sh-keygen.exe -m pem

# 2 在当前用户家目录会生成： 
.ssh/id_rsa.pub    .ssh/id_rsa

# 3 把公钥放到服务器
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.10.8

# 4 以后再连接服务器时，不需要在输入密码
ssh root@192.168.10.8
```
