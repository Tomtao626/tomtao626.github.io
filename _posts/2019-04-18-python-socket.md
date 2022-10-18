---
layout: mypost
title: Python-Socket
categories: [Python, Socket]
---

## socket

```python
socket.gethostname()     # 获取主机名
from socket import *     # 避免 socket.socket()
s=socket()
s.bind()                 # 绑定地址到套接字
s.listen()               # 开始TCP监听
s.accept()               # 被动接受TCP客户端连接，等待连接的到来
s.connect()              # 主动初始化TCP服务器连接
s.connect_ex()           # connect()函数的扩展版本，出错时返回出错码，而不是跑出异常
s.recv()                 # 接收TCP数据
s.send()                 # 发送TCP数据
s.sendall()              # 完整发送TCP数据
s.recvfrom()             # 接收UDP数据
s.sendto()               # 发送UDP数据
s.getpeername()          # 连接到当前套接字的远端的地址(TCP连接)
s.getsockname()          # 当前套接字的地址
s.getsockopt()           # 返回指定套接字的参数
s.setsockopt()           # 设置指定套接字的参数
s.close()                # 关闭套接字
s.setblocking()          # 设置套接字的阻塞与非阻塞模式
s.settimeout()           # 设置阻塞套接字操作的超时时间
s.gettimeout()           # 得到阻塞套接字操作的超时时间
s.makefile()             # 创建一个与该套接字关联的文件对象
s.fileno()               # 套接字获取对应的文件描述符fd

socket.AF_UNIX           # 只能够用于单一的Unix系统进程间通信
socket.AF_INET           # 服务器之间网络通信
socket.AF_INET6          # IPv6

socket.SOCK_STREAM       # 流式socket , for TCP
socket.SOCK_DGRAM        # 数据报式socket , for UDP
socket.SOCK_RAW          # 原始套接字，普通的套接字无法处理ICMP、IGMP等网络报文，而SOCK_RAW可以；其次，SOCK_RAW也可以处理特殊的IPv4报文；此外，利用原始套接字，可以通过IP_HDRINCL套接字选项由用户构造IP头。

socket.SOCK_RDM          # 是一种可靠的UDP形式，即保证交付数据报但不保证顺序。SOCK_RAM用来提供对原始协议的低级访问，在需要执行某些特殊操作时使用，如发送ICMP报文。SOCK_RAM通常仅限于高级用户或管理员运行的程序使用。

socket.SOCK_SEQPACKET    # 可靠的连续数据包服务

socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)   # 关闭server后马上释放端口,避免被TIME_WAIT占用

```

## select          [IO多路复用的机制]

```python
# select每次遍历都需要把fd集合从用户态拷贝到内核态,开销较大,受系统限制最大1024
select.select(rlist, wlist, xlist[, timeout])
# poll和select很像 通过一个pollfd数组向内核传递需要关注的事件,没有描述符1024限制
select.poll()
# 创建epoll句柄,注册监听事件,通过回调函数等待事件产生,不做主动扫描,整个过程对fd只做一次拷贝.打开最大文件数后,不受限制,1GB内存大约是10万链接
select.epoll([sizehint=-1])

select.epoll

EPOLLIN                # 监听可读事件
EPOLLET                # 高速边缘触发模式,即触发后不会再次触发直到新接收数据
EPOLLOUT               # 监听写事件

epoll.poll([timeout=-1[, maxevents=-1]]) # 等待事件,未指定超时时间[毫秒]则为一直阻塞等待
epoll.register(fd,EPOLLIN)               # 向epoll句柄中注册,新来socket链接,监听可读事件
epoll.modify(fd, EPOLLET | EPOLLOUT)     # 改变监听事件为边缘触发,监听写事件
epoll.fileno()                           # 通过链接对象得到fd
epoll.unregister(fd)                     # 取消fd监听事件
```

### SocketServer

```python
#!/usr/bin/python
#server.py
import SocketServer
import os
class MyTCP(SocketServer.BaseRequestHandler):
    def handle(self):
        # 应该已经封装好了 不需要这层while了 可能会引起大量 close_wait
        while True:
            self.data=self.request.recv(1024).strip()
            if self.data == 'quit' or not self.data:break

            cmd=os.popen(self.data).read()
            if cmd == '':cmd= self.data + ': Command not found'
            self.request.sendall(cmd)
if __name__ == '__main__':
    HOST,PORT = '10.0.0.119',50007
    server = SocketServer.ThreadingTCPServer((HOST,PORT),MyTCP)
    server.serve_forever()
```

### SocketClient

```python
#!/usr/bin/python
#client.py
import socket

HOST='10.0.0.119'
PORT=50007
s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.connect((HOST,PORT))

while True:
    while True:
        cmd=raw_input('CMD:').strip()
        if cmd != '':break
    s.sendall(cmd)
    data=s.recv(1024).split('\n')
    print('cmd:')
    for line in data:print(line)
s.close()
```


## ftp


### ftpserver

```python
#!/usr/bin/python
#ftpserver.py

import SocketServer
import os
import cPickle
import md5
from time import sleep

def filer(file1):
    try:
        f = file(file1,'rb')
        return cPickle.load(f)
    except IOError:
        return {}
    except EOFError:
        return {}
    f.close()

def filew(file1,content):
    f = file(file1,'wb')
    cPickle.dump(content,f)
    f.close()

class MyTCP(SocketServer.BaseRequestHandler):
    def handle(self):
        i = 0
        while i<3:
            user=self.request.recv(1024).strip()
            userinfo=filer('user.pkl')
            if userinfo.has_key(user.split()[0]):
                if md5.new(user.split()[1]).hexdigest() == userinfo[user.split()[0]]:
                    results='login successful'
                    self.request.sendall(results)
                    login='successful'
                    break
                else:
                    i = i + 1
                    results='Error:password not correct'
                    self.request.sendall(results)
                    continue
            else:
                i = i + 1
                results='Error:password not correct'
                self.request.sendall(results)
                continue
            break
        else:
            results = 'Error:Wrong password too many times'
            self.request.sendall(results)
            login='failure'
        home_path = os.popen('pwd').read().strip() + '/' + user.split()[0]
        current_path = '/'
        print(home_path)
        while True:
            if login == 'failure':
                break
            print('home_path:%s=current_path:%s' %(home_path,current_path))
            cmd=self.request.recv(1024).strip()
            print(cmd)
            if cmd == 'quit':
                break
            elif cmd == 'dir':
                list=os.listdir('%s%s' %(home_path,current_path))
                if list:
                    dirlist,filelist = '',''
                    for i in list:
                        if os.path.isdir('%s%s%s' %(home_path,current_path,i)):
                            dirlist = dirlist + '\033[32m' + i + '\033[m\t'
                        else:
                            filelist = filelist + i + '\t'
                    results = dirlist + filelist
                else:
                    results = '\033[31mnot find\033[m'
                self.request.sendall(results)
            elif cmd == 'pdir':
                self.request.sendall(current_path)
            elif cmd.split()[0] == 'mdir':
                if cmd.split()[1].isalnum():
                    tmppath='%s%s%s' %(home_path,current_path,cmd.split()[1])
                    os.makedirs(tmppath)
                    self.request.sendall('\033[32mcreating successful\033[m')
                else:
                    self.request.sendall('\033[31mcreate failure\033[m')
            elif cmd.split()[0] == 'cdir':
                if cmd.split()[1] == '/':
                    tmppath='%s%s' %(home_path,cmd.split()[1])
                    if os.path.isdir(tmppath):
                        current_path = cmd.split()[1]
                        self.request.sendall(current_path)
                    else:
                        self.request.sendall('\033[31mnot_directory\033[m')
                elif cmd.split()[1].startswith('/'):
                    tmppath='%s%s' %(home_path,cmd.split()[1])
                    if os.path.isdir(tmppath):
                        current_path = cmd.split()[1] + '/'
                        self.request.sendall(current_path)
                    else:
                        self.request.sendall('\033[31mnot_directory\033[m')
                else:
                    tmppath='%s%s%s' %(home_path,current_path,cmd.split()[1])
                    if os.path.isdir(tmppath):
                        current_path = current_path + cmd.split()[1] + '/'
                        self.request.sendall(current_path)
                    else:
                        self.request.sendall('\033[31mnot_directory\033[m')
            elif cmd.split()[0] == 'get':
                if os.path.isfile('%s%s%s' %(home_path,current_path,cmd.split()[1])):
                    f = file('%s%s%s' %(home_path,current_path,cmd.split()[1]),'rb')
                    self.request.sendall('ready_file')
                    sleep(0.5)
                    self.request.send(f.read())
                    f.close()
                    sleep(0.5)
                elif os.path.isdir('%s%s%s' %(home_path,current_path,cmd.split()[1])):
                    self.request.sendall('ready_dir')
                    sleep(0.5)
                    for dirpath in os.walk('%s%s%s' %(home_path,current_path,cmd.split()[1])):
                        dir=dirpath[0].replace('%s%s' %(home_path,current_path),'',1)
                        self.request.sendall(dir)
                        sleep(0.5)
                        for filename in dirpath[2]:
                            self.request.sendall(filename)
                            sleep(0.5)
                            f = file('%s/%s' %(dirpath[0],filename),'rb')
                            self.request.send(f.read())
                            f.close()
                            sleep(0.5)
                            self.request.sendall('file_get_done')
                            sleep(0.5)
                        else:
                            self.request.sendall('dir_get_done')
                        sleep(0.5)
                else:
                    self.request.sendall('get_failure')
                    continue
                self.request.sendall('get_done')

            elif cmd.split()[0] == 'send':
                if os.path.exists('%s%s%s' %(home_path,current_path,cmd.split()[1])):
                    self.request.sendall('existing')
                    action=self.request.recv(1024)
                    if action == 'cancel':
                        continue
                self.request.sendall('ready')
                msg=self.request.recv(1024)
                if msg == 'ready_file':
                    f = file('%s%s%s' %(home_path,current_path,cmd.split()[1]),'wb')
                    while True:
                        data=self.request.recv(1024)
                        if data == 'file_send_done':break
                        f.write(data)
                    f.close()

                elif msg == 'ready_dir':
                    os.system('mkdir -p %s%s%s' %(home_path,current_path,cmd.split()[1]))
                    while True:
                        dir=self.request.recv(1024)
                        if dir == 'get_done':break
                        os.system('mkdir -p %s%s%s' %(home_path,current_path,dir))
                        while True:
                            filename=self.request.recv(1024)
                            if filename == 'dir_send_done':break
                            f = file('%s%s%s/%s' %(home_path,current_path,dir,filename),'wb')
                            while True:
                                data=self.request.recv(1024)
                                if data == 'file_send_done':break
                                f.write(data)
                            f.close()
                            self.request.sendall('%s/%s\t\033[32mfile_done\033[m' %(dir,filename))
                        self.request.sendall('%s\t\033[32mdir_done\033[m' %(dir))
                elif msg == 'unknown_file':
                    continue

            else:
                results = cmd.split()[0] + ': Command not found'
                self.request.sendall(results)

if __name__ == '__main__':
    HOST,PORT = '10.152.14.85',50007
    server = SocketServer.ThreadingTCPServer((HOST,PORT),MyTCP)
    server.serve_forever()
```

### ftpmanage

```python
#!/usr/bin/python
#manage_ftp.py
import cPickle
import sys
import md5
import os
import getpass

def filer(file1):
    try:
        f = file(file1,'rb')
        return cPickle.load(f)
    except IOError:
        return {}
    except EOFError:
        return {}
    f.close()

def filew(file1,content):
    f = file(file1,'wb')
    cPickle.dump(content,f)
    f.close()

while True:
    print(''')
    1.add user
    2.del user
    3.change password
    4.query user
    0.exit
    '''
    i = raw_input(':').strip()
    userinfo=filer('user.pkl')
    if i == '':
        continue
    elif i == '1':
        while True:
            user=raw_input('user name:').strip()
            if user.isalnum():
                i = 0
                while i<3:
                    passwd=getpass.getpass('passwd:').strip()
                    if passwd == '':
                        continue
                    else:
                        passwd1=getpass.getpass('Confirm password:').strip()
                        if passwd == passwd1:
                            mpasswd = md5.new(passwd).hexdigest()
                            userinfo[user] = mpasswd
                            os.system('mkdir -p %s' %user)
                            print('%s creating successful ' %user)
                            break
                        else:
                            print("Passwords don't match ")
                            i = i + 1
                            continue
                else:
                    print('Too many wrong')
                    continue
                break
            else:
                print('user not legal')
                continue
    elif i == '2':
        user=raw_input('user name:').strip()
        if userinfo.has_key(user):
            del userinfo[user]
            print('Delete users successfully')
        else:
            print('user not exist')
            continue
    elif i == '3':
        user=raw_input('user name:').strip()
        if userinfo.has_key(user):
            i = 0
            while i<3:
                passwd=getpass.getpass('passwd:').strip()
                if passwd == '':
                    continue
                else:
                    passwd1=getpass.getpass('Confirm password:').strip()
                    if passwd == passwd1:
                        mpasswd = md5.new(passwd).hexdigest()
                        userinfo[user] = mpasswd
                        print('%s password is changed' %user)
                        break
                    else:
                        print("Passwords don't match ")
                        i = i + 1
                        continue
            else:
                print('Too many wrong')
                continue
        else:
            print('user not exist')
            continue
    elif i == '4':
        print(userinfo.keys())
    elif i == '0':
        sys.exit()
    else:
        print('select error')
        continue
    filew('user.pkl',content=userinfo)
```

### ftpclient

```python
#!/usr/bin/python
#ftpclient.py

import socket
import os
import getpass
from time import sleep

HOST='10.152.14.85'
PORT=50007
s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.connect((HOST,PORT))

while True:
    user = raw_input('user:').strip()
    if user.isalnum():
        while True:
            passwd = getpass.getpass('passwd:').strip()
            s.sendall(user + ' ' + passwd)
            servercmd=s.recv(1024)
            if servercmd == 'login successful':
                print('\033[32m%s\033[m' %servercmd)
                break
            else:
                print(servercmd)

        while True:
            cmd=raw_input('FTP>').strip()
            if cmd == '':
                continue
            if cmd.split()[0] == 'get':
                if cmd == 'get':continue
                for i in cmd.split()[1:]:
                    if os.path.exists(i):
                        confirm = raw_input("\033[31mPlease confirm whether the cover %s(Y/N):\033[m" %(i)).upper().startswith('Y')
                        if not confirm:
                            print('%s cancel' %i)
                            continue
                    s.sendall('get ' + i)
                    servercmd=s.recv(1024)
                    if servercmd == 'inexistence':
                        print('%s \t\033[32minexistence\033[m' %i)
                        continue
                    elif servercmd == 'ready_file':
                        f = file(i,'wb')
                        while True:
                            data=s.recv(1024)
                            if data == 'get_done':break
                            f.write(data)
                        f.close()
                        print('%s \t\033[32mfile_done\033[m' %(i))
                    elif servercmd == 'ready_dir':
                        try:
                            os.makedirs(i)
                        except:
                            pass
                        while True:
                            serverdir=s.recv(1024)
                            if serverdir == 'get_done':break
                            os.system('mkdir -p %s' %serverdir)
                            print('%s \t\033[32mdir_done\033[m' %(serverdir))
                            while True:
                                serverfile=s.recv(1024)
                                if serverfile == 'dir_get_done':break
                                f = file('%s/%s' %(serverdir,serverfile),'wb')
                                while True:
                                    data=s.recv(1024)
                                    if data == 'file_get_done':break
                                    f.write(data)
                                f.close()
                                print('%s/%s \t\033[32mfile_done\033[m' %(serverdir,serverfile))

            elif cmd.split()[0] == 'send':

                if cmd == 'send':continue
                for i in cmd.split()[1:]:
                    if not os.path.exists(i):
                        print('%s\t\033[31minexistence\033[m' %i)
                        continue

                    s.sendall('send ' + i)
                    servercmd=s.recv(1024)
                    if servercmd == 'existing':
                        confirm = raw_input("\033[31mPlease confirm whether the cover %s(Y/N):\033[m" %(i)).upper().startswith('Y')
                        if confirm:
                            s.sendall('cover')
                            servercmd=s.recv(1024)
                        else:
                            s.sendall('cancel')
                            print('%s\tcancel' %i)
                            continue

                    if os.path.isfile(i):
                        s.sendall('ready_file')
                        sleep(0.5)
                        f = file(i,'rb')
                        s.send(f.read())
                        sleep(0.5)
                        s.sendall('file_send_done')
                        print('%s\t\033[32mfile done\033[m' %(cmd.split()[1]))
                        f.close()
                    elif os.path.isdir(i):
                        s.sendall('ready_dir')
                        sleep(0.5)
                        for dirpath in os.walk(i):
                            dir=dirpath[0].replace('%s/' %os.popen('pwd').read().strip(),'',1)
                            s.sendall(dir)
                            sleep(0.5)
                            for filename in dirpath[2]:
                                s.sendall(filename)
                                sleep(0.5)
                                f = file('%s/%s' %(dirpath[0],filename),'rb')
                                s.send(f.read())
                                f.close()
                                sleep(0.5)
                                s.sendall('file_send_done')
                                msg=s.recv(1024)
                                print(msg)

                            else:
                                s.sendall('dir_send_done')
                                msg=s.recv(1024)
                                print(msg)

                    else:
                        s.sendall('unknown_file')
                        print('%s\t\033[31munknown type\033[m' %i)
                        continue
                    sleep(0.5)
                    s.sendall('get_done')

            elif cmd.split()[0] == 'cdir':
                if cmd == 'cdir':continue
                s.sendall(cmd)
                data=s.recv(1024)
                print(data)
                continue
            elif cmd == 'ls':
                list=os.popen(cmd).read().strip().split('\n')
                if list:
                    dirlist,filelist = '',''
                    for i in list:
                        if os.path.isdir(i):
                            dirlist = dirlist + '\033[32m' + i + '\033[m\t'
                        else:
                            filelist = filelist + i + '\t'
                    results = dirlist + filelist
                else:
                    results = '\033[31mnot find\033[m'
                print(results)
                continue
            elif cmd == 'pwd':
                os.system(cmd)
            elif cmd.split()[0] == 'cd':
                try:
                    os.chdir(cmd.split()[1])
                except:
                    print('\033[31mcd failure\033[m')
            elif cmd == 'dir':
                s.sendall(cmd)
                data=s.recv(1024)
                print(data)
                continue
            elif cmd == 'pdir':
                s.sendall(cmd)
                data=s.recv(1024)
                print(data)
                continue
            elif cmd.split()[0] == 'mdir':
                if cmd == 'mdir':continue
                s.sendall(cmd)
                data=s.recv(1024)
                print(data)
                continue
            elif cmd.split()[0] == 'help':
                print(''')
    get [file] [dir]
    send [file] [dir]

    dir
    mdir
    cdir
    pdir

    pwd
    md
    cd
    ls

    help
    quit
    '''
                continue
            elif cmd == 'quit':
                break
            else:
                print('\033[31m%s: Command not found,Please see the "help"\033[m' %cmd)
    else:
        continue
    break
s.close()
```

## 扫描主机开放端口
#!/usr/bin/env python

import socket

def check_server(address,port):
    s=socket.socket()
    try:
        s.connect((address,port))
        return True
    except socket.error,e:
        return False

if __name__=='__main__':
    from optparse import OptionParser
    parser=OptionParser()
    parser.add_option("-a","--address",dest="address",default='localhost',help="Address for server",metavar="ADDRESS")
    parser.add_option("-s","--start",dest="start_port",type="int",default=1,help="start port",metavar="SPORT")
    parser.add_option("-e","--end",dest="end_port",type="int",default=1,help="end port",metavar="EPORT")
    (options,args)=parser.parse_args()
    print('options: %s, args: %s' % (options, args))
    port=options.start_port
    while(port<=options.end_port):
        check = check_server(options.address, port)
        if (check):
            print('Port  %s is on' % port)
        port=port+1

## zmq [网络通讯库]

```python
# https://github.com/zeromq/pyzmq
# pip install pyzmq
# ZMQ是一个开源的、跨语言的、非常简洁的、非常高性能、非常灵活的网络通讯库
```

### server

```python
import zmq
context = zmq.Context()
socket = context.socket(zmq.REP)
socket.bind("tcp://127.0.0.1:1234")   # 提供传输协议  INPROC  IPC  MULTICAST  TCP

while True :
    msg = socket.recv()
    socket.send(msg)
```

### client

```python
import zmq
context = zmq.Context()
socket = context.socket(zmq.REQ)
socket.connect("tcp://127.0.0.1:1234")
# socket.connect("tcp://127.0.0.1:6000")    # 设置2个可以均衡负载请求到2个监听的server
msg_send = "xxx"socket.send(msg_send)
print("Send:", msg_send)
msg_recv = socket.recv()
print("Receive:", msg_recv)
```

## epoll

[//]: # (https://docs.python.org/2/library/select.html    # python官网)

epoll短链接server
# 原文  http://my.oschina.net/moooofly/blog/147297
# 此代码还有改进地方，在接收数据和发送数据都是阻塞死循环处理，必须等待全部接收完毕才会继续操作

### server：

```python
#!/usr/bin/python
#-*- coding:utf-8 -*-

import socket, logging
import select, errno

logger = logging.getLogger("network-server")

def InitLog():
    logger.setLevel(logging.DEBUG)

    fh = logging.FileHandler("network-server.log")
    fh.setLevel(logging.DEBUG)
    ch = logging.StreamHandler()
    ch.setLevel(logging.ERROR)

    formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
    ch.setFormatter(formatter)
    fh.setFormatter(formatter)

    logger.addHandler(fh)
    logger.addHandler(ch)

if __name__ == "__main__":
    InitLog()

    try:
        # 创建 TCP socket 作为监听 socket
        listen_fd = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)
    except socket.error, msg:
        logger.error("create socket failed")

    try:
        # 设置 SO_REUSEADDR 选项
        listen_fd.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    except socket.error, msg:
        logger.error("setsocketopt SO_REUSEADDR failed")

    try:
        # 进行 bind -- 此处未指定 ip 地址，即 bind 了全部网卡 ip 上
        listen_fd.bind(('', 2003))
    except socket.error, msg:
        logger.error("bind failed")

    try:
        # 设置 listen 的 backlog 数
        listen_fd.listen(10)
    except socket.error, msg:
        logger.error(msg)

    try:
        # 创建 epoll 句柄
        epoll_fd = select.epoll()
        # 向 epoll 句柄中注册 监听 socket 的 可读 事件
        epoll_fd.register(listen_fd.fileno(), select.EPOLLIN)
    except select.error, msg:
        logger.error(msg)

    connections = {}
    addresses = {}
    datalist = {}
    while True:
        # epoll 进行 fd 扫描的地方 -- 未指定超时时间则为阻塞等待
        epoll_list = epoll_fd.poll()

        for fd, events in epoll_list:
            # 若为监听 fd 被激活
            if fd == listen_fd.fileno():
                # 进行 accept -- 获得连接上来 client 的 ip 和 port，以及 socket 句柄
                conn, addr = listen_fd.accept()
                logger.debug("accept connection from %s, %d, fd = %d" % (addr[0], addr[1], conn.fileno()))
                # 将连接 socket 设置为 非阻塞
                conn.setblocking(0)
                # 向 epoll 句柄中注册 连接 socket 的 可读 事件
                epoll_fd.register(conn.fileno(), select.EPOLLIN | select.EPOLLET)
                # 将 conn 和 addr 信息分别保存起来
                connections[conn.fileno()] = conn
                addresses[conn.fileno()] = addr
            elif select.EPOLLIN & events:
                # 有 可读 事件激活
                datas = ''
                while True:
                    try:
                        # 从激活 fd 上 recv 10 字节数据
                        data = connections[fd].recv(10)
                        # 若当前没有接收到数据，并且之前的累计数据也没有
                        if not data and not datas:
                            # 从 epoll 句柄中移除该 连接 fd
                            epoll_fd.unregister(fd)
                            # server 侧主动关闭该 连接 fd
                            connections[fd].close()
                            logger.debug("%s, %d closed" % (addresses[fd][0], addresses[fd][1]))
                            break
                        else:
                            # 将接收到的数据拼接保存在 datas 中
                            datas += data
                    except socket.error, msg:
                        # 在 非阻塞 socket 上进行 recv 需要处理 读穿 的情况
                        # 这里实际上是利用 读穿 出 异常 的方式跳到这里进行后续处理
                        if msg.errno == errno.EAGAIN:
                            logger.debug("%s receive %s" % (fd, datas))
                            # 将已接收数据保存起来
                            datalist[fd] = datas
                            # 更新 epoll 句柄中连接d 注册事件为 可写
                            epoll_fd.modify(fd, select.EPOLLET | select.EPOLLOUT)
                            break
                        else:
                            # 出错处理
                            epoll_fd.unregister(fd)
                            connections[fd].close()
                            logger.error(msg)
                            break
            elif select.EPOLLHUP & events:
                # 有 HUP 事件激活
                epoll_fd.unregister(fd)
                connections[fd].close()
                logger.debug("%s, %d closed" % (addresses[fd][0], addresses[fd][1]))
            elif select.EPOLLOUT & events:
                # 有 可写 事件激活
                sendLen = 0
                # 通过 while 循环确保将 buf 中的数据全部发送出去
                while True:
                    # 将之前收到的数据发回 client -- 通过 sendLen 来控制发送位置
                    sendLen += connections[fd].send(datalist[fd][sendLen:])
                    # 在全部发送完毕后退出 while 循环
                    if sendLen == len(datalist[fd]):
                        break
                # 更新 epoll 句柄中连接 fd 注册事件为 可读
                epoll_fd.modify(fd, select.EPOLLIN | select.EPOLLET)
            else:
                # 其他 epoll 事件不进行处理
                continue
```

### client

```python
import socket
import time
import logging

logger = logging.getLogger("network-client")
logger.setLevel(logging.DEBUG)

fh = logging.FileHandler("network-client.log")
fh.setLevel(logging.DEBUG)
ch = logging.StreamHandler()
ch.setLevel(logging.ERROR)

formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
ch.setFormatter(formatter)
fh.setFormatter(formatter)

logger.addHandler(fh)
logger.addHandler(ch)

if __name__ == "__main__":
    try:
        connFd = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)
    except socket.error, msg:
        logger.error(msg)

    try:
        connFd.connect(("127.0.0.1", 2003))
        logger.debug("connect to network server success")
    except socket.error,msg:
        logger.error(msg)

    for i in range(1, 11):
        data = "The Number is %d" % i
        if connFd.send(data) != len(data):
            logger.error("send data to network server failed")
            break
        readData = connFd.recv(1024)
        print(readData)
        time.sleep(1)

    connFd.close()
```
