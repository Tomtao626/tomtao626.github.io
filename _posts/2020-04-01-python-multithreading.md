---
title:       "Python多线程与join()使用"
subtitle:    "py基础"
description: "I/O tips"
date:        2020-04-01
author:      "tomtao626"
image:       ""
tags:        ["进程", "线程", "I/O"]
categories:  ["PYTHON"]
---

# 进程
> + 进程：程序的一次执行(可以理解为是一个容器)

# 线程
> + 线程：CPU的基本调度单位(可以理解为是容器中的工作单位)

# 二者关系
> + 一个进程至少有一个线程，一个进程可以运行多个线程，多个线程可共享数据。
> + 与进程不同的是同类的多个线程共享进程的堆和方法区资源，但每个线程有自己的程序计数器、虚拟机栈和本地方法栈，
> + 系统在产生一个线程，或是在各个线程之间作切换工作时，负担要比进程小得多，也正因为如此，线程也被称为轻量级进程

# 多进程
> + 多进程：操作系统中同时运行的多个程序

# 多线程
> + 多线程：在同一个进程中同时运行的多个任务
> + 多线程提高CPU使用率
> + 多线程并不能提高运行速度，但可以提高运行效率，让CPU的使用率更高。但是如果多线程有安全问题或出现频繁的上下文切换时，运算速度可能反而更低。
> + 多线程能提高运行效率的前提”是 线程本身不会一直占用CPU且不占CPU的空闲时间大于线程切换时间，否则在线程时间运行效率变低，在线程需100%占用CPU时，CPU利用率也不会得到提升

## 说明
> 举个例子，多线程下载软件，可以同时运行多个线程，但是通过程序运行的结果发现，每一次结果都不一致。 因为多线程存在一个特性：随机性。造成的原因：CPU在瞬间不断切换去处理各个线程而导致的，可以理解成多个线程在抢CPU资源。
> ![](https://p6-tt.byteimg.com/origin/pgc-image/0ff9b04731df481f90faaafbfcecbae5.png)

# Python进(线)程相关的库
`multiprocessing`,`threading`,`psutil`,`subprocess`,`_thread`(兼容python2)

# join()
> + 用于将序列中的元素以指定的字符连接生成一个新的字符串， 
> + 在Python多线程与多进程中join()方法的效果是相同的，join所完成的工作就是线程同步，即主线程任务在设置join函数的地方，进入阻塞状态，一直等待其他的子线程执行结束之后，主线程再开始执行直到终止终止。
> + 当有设置守护线程时，含义是主线程对于子线程等待timeout的时间将会杀死该子线程，最后退出程序。所以说，如果有10个子线程，全部的等待时间就是每个timeout的累加和。简单的来说，就是给每个子线程一个timeout的时间，让他去执行，时间一到，不管任务有没有完成，直接杀死。
> + 没有设置守护线程时，主线程将会等待timeout的累加和这样的一段时间，时间一到，主线程结束，但是并没有杀死子线程，子线程依然可以继续执行，直到子线程全部结束，程序退出。
> + 主线程A中，创建了子线程B，并且在主线程A中调用了B.join()， 那么，主线程A会在调用的地方阻塞，直到子线程B完成操作后，才可以接着往下执行。

# setDaemon()
> + 主线程A中，创建了子线程B，并且在主线程A中调用了B.setDaemon(),
> + 即：把主线程A设置为守护线程，这时候，要是主线程A执行结束了，就不管子线程B是否完成,一并和主线程A退出。
> + 注意：必须在start() 方法调用之前设置，如果不设置为守护线程，程序会被无限挂起。

## Note
> join和setDaemon两者基本是相反的(join主线程等子线程结束，setDaemon主线程管好自己就可以了，不等子线程结束)

# 多线程的几情况

## 默认情况
> 当一个进程启动之后，会默认产生一个主线程，因为线程是程序执行流的最小单元，当设置多线程时，主线程会创建多个子线程，在python中，默认情况下（其实就是setDaemon(False)），主线程执行完自己的任务以后，就退出了，此时子线程会继续执行自己的任务，直到自己的任务结束

```python
import threading
import time

def run():
    time.sleep(2)
    print('当前线程的名字是:', threading.current_thread().name)
    time.sleep(2)


if __name__ == '__main__':

    start_time = time.time()

    print('这是主线程:', threading.current_thread().name)
    thread_list = []
    for i in range(5):
        t = threading.Thread(target=run)
        thread_list.append(t)

    for t in thread_list:
        t.start()

    print('主线程结束!' , threading.current_thread().name)
    print('一共用时:', time.time()-start_time)

# 输出结果
"""
    这是主线程:MainThread
    主线程结束!MainThread
    一共用时:0.0004153251647949219
    当前线程的名字是:Thread-1
    当前线程的名字是:Thread-2
    当前线程的名字是:当前线程的名字是:Thread-3
    Thread-4
    当前线程的名字是:Thread-5
"""
```
### Note
> + 计时是对主线程计时，主线程结束，计时随之结束，打印出主线程的用时。
> + 主线程的任务完成之后，主线程随之结束，子线程继续执行自己的任务，直到全部的子线程的任务全部结束，程序结束。

## 守护进程
> 当我们使用setDaemon(True)方法，设置子线程为守护线程时，主线程一旦执行结束，则全部线程全部被终止执行，可能出现的情况就是，子线程的任务还没有完全执行结束，就被迫停止

```python
import threading
import time

def run():

    time.sleep(2)
    print('当前线程的名字是:', threading.current_thread().name)
    time.sleep(2)


if __name__ == '__main__':

    start_time = time.time()

    print('这是主线程:', threading.current_thread().name)
    thread_list = []
    for i in range(5):
        t = threading.Thread(target=run)
        thread_list.append(t)

    for t in thread_list:
        t.setDaemon(True)
        t.start()

    print('主线程结束了!', threading.current_thread().name)
    print('一共用时:', time.time()-start_time)

# 输出结果
"""
    这是主线程:MainThread
    主线程结束了!MainThread
    一共用时:0.0006198883056640625
"""
```
### Note
> + 请确保setDaemon()在start()之前;
> + 非常明显的看到，主线程结束以后，子线程还没有来得及执行，整个程序就退出了。

## join()线程同步
> 使用join实现线程同步，即主线程任务在设置join函数的地方，进入阻塞状态，一直等待其他的子线程执行结束之后，主线程再开始执行直到终止终止

```python
import threading
import time

def run():

    time.sleep(2)
    print('当前线程的名字是:', threading.current_thread().name)
    time.sleep(2)


if __name__ == '__main__':

    start_time = time.time()

    print('这是主线程:', threading.current_thread().name)
    thread_list = []
    for i in range(5):
        t = threading.Thread(target=run)
        thread_list.append(t)

    for t in thread_list:
        t.setDaemon(True)
        t.start()

    for t in thread_list:
        t.join()

    print('主线程结束了!' , threading.current_thread().name)
    print('一共用时:', time.time()-start_time)

# 输出结果
"""
    这是主线程:MainThread
    当前线程的名字是:当前线程的名字是:Thread-5
    当前线程的名字是:Thread-2
    Thread-3
    当前线程的名字是:Thread-4当前线程的名字是:  
    Thread-1
    主线程结束了!MainThread
    一共用时:4.005531549453735
"""
```
### Note
> + 主线程一直等待全部的子线程结束之后，主线程自身才结束，程序退出

## 主线程异常中止
> 在线程A中使用B.join()表示线程A在调用join()处被阻塞，且要等待线程B的完成才能继续执行

```python
import threading
import time


def child_thread1():
    for i in range(10):
        time.sleep(1)
        print('child_thread1_running...')


def child_thread2():
    for i in range(5):
        time.sleep(1)
        print('child_thread2_running...')


def parent_thread():
    print('parent_thread_running...')
    thread1 = threading.Thread(target=child_thread1)
    thread2 = threading.Thread(target=child_thread2)
    thread1.setDaemon(True)
    thread2.setDaemon(True)
    thread1.start()
    thread2.start()
    thread2.join()
    1/0
    thread1.join()
    print('parent_thread_exit...')


if __name__ == "__main__":
    parent_thread()
# 输出结果
"""
    parent_thread_running...
    child_thread2_running...
    child_thread1_running...
    child_thread2_running...
    child_thread1_running...
    child_thread1_running...child_thread2_running...
    
    child_thread1_running...
    child_thread2_running...
    child_thread1_running...
    child_thread2_running...
    Traceback (most recent call last):
      File "/xxx/thread_test.py", line 32, in <module>
        parent_thread()
      File "/xxx/thread_test.py", line 26, in parent_thread
        1 / 0
    ZeroDivisionError: division by zero
"""
```
### Note
> + 主线程在执行到thread2.join()时被阻塞，等待thread2结束后才会执行下一句
> + 1/0会使主线程报错退出，且thread1设置了daemon=True，因此主线程意外退出时thread1也会立即结束。thread1.join()没有被主线程执行
