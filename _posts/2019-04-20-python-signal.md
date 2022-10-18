---
layout: mypost
title: Python-信号Signal
categories: [Python, Linux]
---

## signal

### 信号的概念

> 信号(signal): 进程之间通讯的方式，是一种软件中断。一个进程一旦接收到信号就会打断原来的程序执行流程来处理信号。

> 发送信号一般有两种原因:
> + 1(被动式)  内核检测到一个系统事件.例如子进程退出会像父进程发送SIGCHLD信号.键盘按下control+c会发送SIGINT信号
> + 2(主动式)  通过系统调用kill来向指定进程发送信号

> 操作系统规定了进程收到信号以后的默认行为，可以通过绑定信号处理函数来修改进程收到信号以后的行为，有两个信号是不可更改的 SIGTOP 和 SIGKILL
如果一个进程收到一个SIGUSR1信号，然后执行信号绑定函数，第二个SIGUSR2信号又来了，第一个信号没有被处理完毕的话，第二个信号就会丢弃。
进程结束信号 SIGTERM 和 SIGKILL 的区别:  SIGTERM 比较友好，进程能捕捉这个信号，根据您的需要来关闭程序。在关闭程序之前，您可以结束打开的记录文件和完成正在做的任务。在某些情况下，假如进程正在进行作业而且不能中断，那么进程可以忽略这个SIGTERM信号。

### 常见信号

```shell
kill -l      # 查看linux提供的信号

SIGHUP  1          A     # 终端挂起或者控制进程终止
SIGINT  2          A     # 键盘终端进程(如control+c)
SIGQUIT 3          C     # 键盘的退出键被按下
SIGILL  4          C     # 非法指令
SIGABRT 6          C     # 由abort(3)发出的退出指令
SIGFPE  8          C     # 浮点异常
SIGKILL 9          AEF   # Kill信号  立刻停止
SIGSEGV 11         C     # 无效的内存引用
SIGPIPE 13         A     # 管道破裂: 写一个没有读端口的管道
SIGALRM 14         A     # 闹钟信号 由alarm(2)发出的信号
SIGTERM 15         A     # 终止信号,可让程序安全退出 kill -15
SIGUSR1 30,10,16   A     # 用户自定义信号1
SIGUSR2 31,12,17   A     # 用户自定义信号2
SIGCHLD 20,17,18   B     # 子进程结束自动向父进程发送SIGCHLD信号
SIGCONT 19,18,25         # 进程继续（曾被停止的进程）
SIGSTOP 17,19,23   DEF   # 终止进程
SIGTSTP 18,20,24   D     # 控制终端（tty）上按下停止键
SIGTTIN 21,21,26   D     # 后台进程企图从控制终端读
SIGTTOU 22,22,27   D     # 后台进程企图从控制终端写
```

> 缺省处理动作一项中的字母含义如下:
> + A  缺省的动作是终止进程
> + B  缺省的动作是忽略此信号，将该信号丢弃，不做处理
> + C  缺省的动作是终止进程并进行内核映像转储(dump core),内核映像转储是指将进程数据在内存的映像和进程在内核结构中的部分内容以一定格式转储到文件系统，并且进程退出执行，这样做的好处是为程序员提供了方便，使得他们可以得到进程当时执行时的数据值，允许他们确定转储的原因，并且可以调试他们的程序。
> + D  缺省的动作是停止进程，进入停止状况以后还能重新进行下去，一般是在调试的过程中（例如ptrace系统调用）
> + E  信号不能被捕获
> + F  信号不能被忽略


## Python提供的信号

```shell
import signal
dir(signal)
['NSIG', 'SIGABRT', 'SIGALRM', 'SIGBUS', 'SIGCHLD', 'SIGCLD', 'SIGCONT', 'SIGFPE', 'SIGHUP', 'SIGILL', 'SIGINT', 'SIGIO', 'SIGIOT', 'SIGKILL', 'SIGPIPE', 'SIGPOLL', 'SIGPROF', 'SIGPWR', 'SIGQUIT', 'SIGRTMAX', 'SIGRTMIN', 'SIGSEGV', 'SIGSTOP', 'SIGSYS', 'SIGTERM', 'SIGTRAP', 'SIGTSTP', 'SIGTTIN', 'SIGTTOU', 'SIGURG', 'SIGUSR1', 'SIGUSR2', 'SIGVTALRM', 'SIGWINCH', 'SIGXCPU', 'SIGXFSZ', 'SIG_DFL', 'SIG_IGN', '__doc__', '__name__', 'alarm', 'default_int_handler', 'getsignal', 'pause', 'signal']
```

### 绑定信号处理函数

```python
#encoding:utf8
import os,signal
from time import sleep
def onsignal_term(a,b):
    print('SIGTERM')     # kill -15
signal.signal(signal.SIGTERM,onsignal_term)     # 接收信号,执行相应函数

def onsignal_usr1(a,b):
    print('SIGUSR1')      # kill -10
signal.signal(signal.SIGUSR1,onsignal_usr1)

while 1:
    print('ID',os.getpid())
    sleep(10)
```

### 通过另外一个进程发送信号

```python
import os,signal
os.kill(16175,signal.SIGTERM)    # 发送信号，16175是绑定信号处理函数的进程pid，需要自行修改
os.kill(16175,signal.SIGUSR1)
```

### 父进程接收子进程结束发送的SIGCHLD信号

```python
#encoding:utf8
import os,signal
from time import sleep

def onsigchld(a,b):
    print('收到子进程结束信号')
signal.signal(signal.SIGCHLD,onsigchld)

pid = os.fork()                # 创建一个子进程,复制父进程所有资源操作
if pid == 0:                   # 通过判断子进程os.fork()是否等于0,分别同时执行父进程与子进程操作
   print('我是子进程,pid是',os.getpid())
   sleep(2)
else:
    print('我是父进程,pid是',os.getpid())
    os.wait()      # 等待子进程结束
```

### 接收信号的程序，另外一端使用多线程向这个进程发送信号，会遗漏一些信号

```python
#encoding:utf8
import os
import signal
from time import sleep
import Queue
QCOUNT = Queue.Queue()  # 初始化队列
def onsigchld(a,b):
    '''收到信号后向队列中插入一个数字1'''
    print('收到SIGUSR1信号')
    sleep(1)
    QCOUNT.put(1)       # 向队列中写入
signal.signal(signal.SIGUSR1,onsigchld)   # 绑定信号处理函数
while 1:
    print('现在队列中元素的个数是',QCOUNT.qsize())
    print('我的pid是',os.getpid())
    sleep(2)
```


### 多线程发信号端的程序
```python
#encoding:utf8
import threading
import os
import signal
def sendusr1():
    print('发送信号')
    os.kill(17788, signal.SIGUSR1)     # 这里的进程id需要写前一个程序实际运行的pid
WORKER = []
for i in range(1, 7):                  # 开启6个线程
    threadinstance = threading.Thread(target = sendusr1)
    WORKER.append(threadinstance)
for i in WORKER:
    i.start()
for i in WORKER:
    i.join()
print('主线程完成')
```