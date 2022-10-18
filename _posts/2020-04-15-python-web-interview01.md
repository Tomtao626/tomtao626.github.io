---
layout: mypost
title: Python-Web面试01
categories: [面试, Python]
---

# http/http.2协议原理
> 描述一下请求一个网页的步骤（浏览器访问服务器的步骤）
> + 1.解析域名-用户从浏览器输入网址，dns 服务器对其进行解析，浏览器得到 web 服务器的 IP 地址；
> + 2.客户端和服务端进行连接-浏览器会和web服务端的 http 端口(一般是80端口)建立一个 tcp 套接字的连接；
> + 3.发送 http 请求-通过建立的 tcp 套接字连接，浏览器会向服务器发送请求报文，一个请求报文包含请求行，请求头，空行和请求数据(请求体)四部分；
> + 4.服务端解析请求并返回 http 响应- web 服务器收到请求报文，会解析请求，定位资源，返回响应报文；
> + 5.释放 tcp 连接-web浏览器主动关闭 tcp 套接字，关闭 tcp 连接；
> + 6.客户端浏览器解析响应报文，解析成 html 内容，经过浏览器渲染就可以展示了.

> http和https分别是啥，二者有什么区别？
> + http 是超文本传输协议，是目前使用最广泛的一种网络协议，数据是以明文方式传输的，存在安全隐患；
> + https 是 http 的安全升级版本，是为了安全而设计的。传输基于 SSL 协议，SSL 协议可提供数据加密，保证了数据传输时的安全性；
> + http 传输数据是明文的，https 传输数据是加密的
> + http 端口是80，https 端口是443
> + https 需要申请CA证书，http 不需要
> + http 是无状态连接，https 是 SSL+http 的安全连接

> TCP中的三次握手和四次挥手是什么？
> + tcp的三次握手主要是指tcp客户端和服务端建立连接的过程，四次挥手即断开连接的过程；
> + 三次挥手(占用资源)，四次挥手(释放资源)

> 三次挥手：
> + 客户端的 connect 默认是阻塞的，只有三次握手成功，连接建立后才会接触阻塞
> + 第一次：客户端发送数据给服务端，客户端要连接服务器，通知服务器准备好资源；
> + 第二次：服务端发送数据给客户端，通知客户端其已经准备好了资源，让客户端也准备好资源；
> + 第三次：客户端收到通知，确认双方都准备好了，建立连接。

> 四次挥手：
> + 第一次：客户端关闭发送数据，通知服务端，我要关闭发送了；
> + 第二次：服务端发送数据给客户端，我已收到数据，我也要关闭接收数据了；
> + 第三次：服务器发送数据给客户端，我要关闭发送数据了；
> + 第四次：客户端发送数据给服务端，我已接收到数据，我也关闭接收数据了。

> TCP 第四次挥手为什么要等待 2MSL？
> + MSL也叫报文最大生存时间，是任何报文在网络上生存的最长时间，超时报文就会被丢弃
> + 为了保证客户端发送的最后一个 ACK 报文段能够到达服务器。
    因为这个 ACK 有可能丢失，从而导致处在 LAST-ACK 状态的服务器收不到对 FIN-ACK 的确认报文。
    服务器会超时重传这个 FIN-ACK，接着客户端再重传一次确认，重新启动时间等待计时器。
    最后客户端和服务器都能正常的关闭。假设客户端不等待 2MSL，而是在发送完 ACK 之后直接释放关闭，一但这个 ACK 丢失的话，服务器就无法正常的进入关闭连接状态。
> + 它还可以防止已失效的报文段。
    客户端在发送最后一个 ACK 之后，再经过经过 2MSL，就可以使本链接持续时间内所产生的所有报文段都从网络中消失。
    从而保证在关闭连接后不会有还在网络中滞留的报文段去骚扰服务器。
> + 注意：在服务器发送了 FIN-ACK 之后，会立即启动超时重传计时器。客户端在发送最后一个 ACK 之后会立即启动时间等待计时器。

> HTTP 最常见的请求方法有哪些?
> + GET：GET 请求主要用于根据给定的url从给定的服务器中检索信息，即从指定服务器获取资源，请求参数一般带在请求url中；GEt请求也有长度限制，一般是2-8k，对于一些隐私安全信息，使用 GET 请求就会不安全。
> + POST：POST 请求一般用向服务器提交数据，请求的信息放在Formdata中，长度没有限制，传输的数据大小取决于服务器的设置，POST比GET更安全。
> + PUT：PUT 请求主要用来传输数据非服务端，传输的数据用来替代指定的文档内容。PUT 请求的本质是 idempotent 的方法，一般情况下，PUT 和 POST 请求没有特别的区分，根据语义使用即可。
> + DELETE：DELETE 请求主要用于从服务器删除指定的数据，DELETE请求一般会返回三种状态码：
 > + + 200（OK）：删除成功，返回已经删除的资源
 > + + 202（Accepted）：删除请求已经接受，但没有被立即执行
 > + + 204（No Content）：删除请求已经被执行，但是没有返回资源

> GET请求和POST请求有什么区别？
> + GET请求参数一般放在url中；而POST请求是放在Formdata中
> + GET请求的安全性低于POST请求
> + GET请求在浏览器上执行后退操作没有影响；但POST执行后端操作会重新发送请求
> + GET请求的url可以被缓存，可以被标记；而POST的请求地址一般是固定的，不会被缓存，无法被标记
> + GET请求可以从浏览器历史记录中找到；而POST不会保留
> + GET请求用的URL编码；而POST请求可以采用多种编码方式

> TCP和UDP的区别。
> + TCP是面向连接的，提供可靠的通信传输。可靠主要体现在传输数据之前，会有三次握手建立连接，然后在数据传递时，有确认，窗口，重传，拥塞等机制，在数据传输完毕，又通过四次挥手断开连接，节约资源。
> + + 类似于打电话，需要等待另一方的接听，才能进行真正的通讯；
> + 而UDP是面向无连接的，是一个无状态的传输协议，不是可靠的。
> + + 类似发短信，只将信息发出，至于对方有没收到，这个就不关心了

# socket请求如何上升为http请求
```python
import socket
se = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
host=" /jobrecord/login/index.do"
se.connect(("192.168.1.41",91))
try:
    se.send("GET /jobrecord/login/index.do HTTP/1.1\r\n")
    se.send("Host: 192.168.1.41:91\r\n")
    se.send("Connection: keep-alive\r\n")
    se.send("Cache-Control: max-age=0\r\n")
    se.send("Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\n")
    se.send("Upgrade-Insecure-Requests: 1\r\n")
    se.send("User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.110 Safari/537.36\r\n")
    se.send("Accept-Encoding: gzip, deflate, sdch\r\n")
    se.send("Accept-Language: zh-CN,zh;q=0.8\r\n")
    se.send("Cookie: JSESSIONID=8E827CDF1932CAC60C4D4AA4DD39C171; sid=a1m649tme0i2bu00b03rbnc806\r\n\r\n")
except socket.error as e:
    print("Error sending data:%s" % e)
buffer = []
while True:
    d = se.recv(1024)
    if d:
      buffer.append(d)
    else:
      break
data = ''.join(buffer)
se.close()
header,html = data.split('\r\n\r\n',1)
print(header)
with open('D:\\sina.html','wb') as f:
    f.write(html)
```
# cookie和session的区别
> 由于http协议是无状态的，即每次服务端收到客户端的请求都是一个全新的请求，服务端并不知道客户端的历史请求记录，而cookie和session的主要目的就是为了弥补http的无状态性
> + cookie:http中的cookie一般是指web cookie和浏览器cookie，是web服务器发送带客户端的一块数据，服务器发送到浏览器的cookie，浏览器会进行存储，并与下一个请求一起发送到服务器。
> + session：客户端请求服务端，服务端会为其开辟一块session空间，同时生成一个sessionID，并通过响应头的set-cookie：sessionID=xxxxx命令，向客户端发送要设置cookie的响应；客户端收到响应，会在本机客户端设置一个sessionID=xxxxx的cooki信息，该cookie过期时间是浏览器会话结束。

# restful形式及优缺点
> restful是面向资源的，每个资源对应一种特定的url，url就是访问每一个资源独一无二的标识符
> + GET /users 获取用户列表
> + GET /users/id 获取一个用户的数据
> + POST /users 新增一个用户
> + PUT /users/id 更新一个用户的信息
> + DELETE /users/id 删除一个用户
> + 优点：由于对url进行了限制，只能用于定义资源，会比较容易理解，尤其是针对于简单的增删改查
> + 缺点：由于对url进行了限制，会导致设计url会更加复杂，尤其是复杂的关系，资源，操作集合等，直接套用rest设计原则会非常困难

# 请求状态码
> 2xx 请求成功处理后的状态码
> + 200 (成功)  服务器已成功处理了请求。 通常，这表示服务器提供了请求的网页
> + 201 (已创建) 请求成功并且服务器创建了新的资源
> + 203 (非授权信息) 服务器已成功处理了请求，但返回的信息可能来自另一来源
> + 204 (无内容) 服务器成功处理了请求，但没有返回任何内容。
> 
> 3xx 请求被重定向，表示要完成请求，需要进行下一步操作
> + 301 永久重定向
> + 302 临时重定向
> 
> 4xx 请求错误）这些状态代码表示请求可能出错，妨碍了服务器的处理
> + 400 (错误请求) 服务器不理解请求的语法。 
> + 401 (未授权) 请求要求身份验证。 对于需要登录的网页，服务器可能返回此响应。 
> + 404 (未找到) 服务器找不到请求的网页。
> 
> 5xx (服务器错误) 这些状态代码表示服务器在尝试处理请求时发生内部错误。 这些错误可能是服务器本身的错误，而不是请求出错 
> + 500 (服务器内部错误) 服务器遇到错误，无法完成请求。 
> + 502 (错误网关) 服务器作为网关或代理，从上游服务器收到无效响应。

# hash表底层实现
> 哈希表底层基于数组来存储的。
> + 当插入键值对时，不是直接存储在数组中，而是先对键进行hash运算得到hash值，然后再与数组容量取模，得到在数组中的位置后再插入。
> + 当取值时，先对指定的键求hash值，再和数组容量取模得到在底层数组中存储的位置，如果指定的键值和存储的键值相同，就返回该键值对；否则就表示哈希表中没有对应的键值对。
> + 查找/删除/插入 时间复杂度都是O(1)，最坏的情况是O(N)

# 如何解决hash冲突(碰撞)
> 为什么会出现hash冲突(碰撞)？
> + 注意hash碰撞无法避免。一个hash函数本身本身问题，其次就是底层数组容量问题，如果数组容量是1(极端情况)，hash碰撞必然发生，当然如果一个数组容量无限大，碰撞的概率就会非常低。
> + hash碰撞还与负载因子有关，负载因子就是存储的键值对数目和底层数组容量的比值，比如数组容量100，当前存贮了90个键值对，负载因子为0.9。负载因子决定了哈希表什么时候扩容，如果负载因子的值太大，说明存储的键值对接近容量，增加碰撞的风险，如果值太小，则浪费空间。
> 
> 如何解决?
> + 同义词：两个元素通过Hash函数得到了相同的索引地址，这两个元素就叫做同义词。
> + 外部拉链法：基于数组和链表的组合来解决冲突，即把所有hash地址为x的元素放在一个名为同义词链（也就是hash冲突的元素）的线性链表中，并将线性链表的头指针放在hash表的第x个单元中，缺点是链表指针需要额外的空间，遇到碰撞拒绝服务时会退化为单链表。
> + 开放定址法：发生冲突时，直接去寻找下一个空的地址，只要底层的数组容量足够大，总能找到空的地址。这种寻找下一个地址的行为叫探测，探测方法主要有，线性探测/伪随机探测
> + 再hash法：发生冲突时，使用下一个hash函数计算地址，知道无hash冲突，缺点是耗费时间
> + 建立公共溢出区：将所有hash冲突的键值放在其中，

# python实现单例模式
> 使用函数装饰器实现单例

```python
def singleton(cls):
    _instance = {}
    def inner():
        if cls not in _instance:
            _instance[cls] = cls()
            return _instance[cls]
    return inner

@singleton
class Cls(singleton):
    def __init__(self):
        pass

cls1 = Cls()
cls2 = Cls()
print(id(cls1), type(cls1))  # 4549747952 <class '__main__.Cls'>
print(id(cls2), type(cls2))  # 4549747952 <class '__main__.Cls'>
"""
    在 Python 中，id 关键字可用来查看对象在内存中的存放位置，这里 cls1 和 cls2 的 id 值相同，说明他们指向了同一个对象。
    代码中比较巧妙的一点是:
    _instance = {}
    使用不可变的类地址作为键，其实例作为值，每次创造实例时，首先查看该类是否存在实例，存在的话直接返回该实例即可，否则新建一个实例并存放在字典中。
"""
```

> + 使用类装饰器实现单例

```python
class Singleton(object):
    def __init__(self, cls):
        self._cls = cls
        self._instance = {}
    def __call__(self):
        if self._cls not in self._instance:
            self._instance[self._cls] = self._cls()
        return self._instance[self._cls]

@Singleton
class Cls(object):
    def __init__(self):
        pass
    
cls1 = Cls()
cls2 = Cls()
print(id(cls1), type(cls1))  # 4537706528 <class '__main__.Cls'>
print(id(cls2), type(cls2))  # 4537706528 <class '__main__.Cls'>
"""
    同时，由于是面对对象的，这里还可以这么用
    class Cls3():
        pass
    
    Cls3 = Singleton(Cls3)
    cls3 = Cls3()
    cls4 = Cls3()
    print(id(cls3) == id(cls4))
使用 类装饰器实现单例的原理和 函数装饰器 实现的原理相似，理解了上文，再理解这里应该不难。
"""
```
> + 使用 metaclass 关键字实现单例

```python
# 同样，我们在类的创建时进行干预，从而达到实现单例的目的。

# 在实现单例之前，需要了解使用 type 创造类的方法，代码如下：

def func(self):
    print("do sth")

Klass = type("Klass", (), {"func": func})

c = Klass()
c.func()
# 以上，我们使用 type 创造了一个类出来。这里的知识是 mataclass 实现单例的基础。

class Singleton(type):
    _instances = {}
    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]

class Cls(metaclass=Singleton):
    pass

cls1 = Cls()
cls2 = Cls()
print(id(cls1))  # 4376868896 <class '__main__.Cls'>
print(id(cls2))  # 4376868896 <class '__main__.Cls'>
# 这里，我们将 metaclass 指向 Singleton 类，让 Singleton 中的 type 来创造新的 Cls4 实例。
```
> + 使用 __new__ 实现单例
> + 单例 —— 让类创建的对象,在系统中,只有唯一的一个实例,每一次执行 类名() 返回的对象，内存地址是相同的
> + __new__方法：使用类名创建对象时，python解释器会先调用__new__方法为对象分配内存空间
> + __new__方法作用：1.在内存中为对象分配空间，2.返回对象的引用
> + Python 的解释器获得对象的 引用 后，将引用作为 第一个参数，传递给 __init__ 方法
> + 重写new方法固定写法：重写 __new__ 方法 一定要 return super().__new__(cls)
> + 否则 Python 的解释器 得不到 分配了空间的 对象引用，就不会调用对象的初始化方法
> + 注意：__new__ 是一个静态方法（可以参考源码发现），在调用时需要 主动传递 cls 参数

```python
"""
    1-定义一个类属性，初始值是 None，用于记录单例对象的引用
    2-重写 __new__ 方法
    3-如果类属性 is None，调用父类方法分配空间，并在类属性中记录结果
    4-返回类属性中记录的对象引用
"""
class Cls(object):
    # 定义类属性单例对象的引用
    instance = None
    # 重写new方法
    def __new__(cls, *args, **kwargs):
        # 如果 类属性 is None，调用父类方法分配空间，并在类属性中记录结果
        if cls.instance is None:
            cls.instance = super().__new__(cls)
        # 返回类属性中记录的对象引用
        return cls.instance
# 在每次使用类名创建对象后，python解释器会自动调用new方法分配空间和init方法初始化对象，但是这样每次初始化方法都会被调用，我们希望初始化动作只被执行一次
# 解决办法 定义一个类属性标识变量flag 标记是否执行过初始化方法 初始值为False
class Cls2(object):
    # 定义类属性单例对象引用
    instance = None
    # 标记是否执行过初始化方法
    flag = False
    def __new__(cls, *args, **kwargs):
        # 判断类属性是否是空对象
        if cls.instance is None:
            # 调用父类方法 为其分配内存空间
            cls.instance = super().__new__(cls)
        # 返回类属性保存的对象引用
        return cls.instance
    
    def __init__(self):
        if not Cls2.flag:
            print("xxxxx")
            self.flag = True

# 创建多个对象
cls1 = Cls2()
cls2 = Cls2()
print(cls1)
print(cls2)
# xxxxx
# xxxxx
# <__main__.Cls2 object at 0x104c88610>
# <__main__.Cls2 object at 0x104c88610>
```

# python dict/set底层原理
> 同hash原理

# 协程 asyncio/await 原理

# python装饰器原理
> [装饰器原理](https://mp.weixin.qq.com/s?__biz=MjM5MDEyMDk4Mw==&mid=2650166480&idx=2&sn=be7349921b91730a8c717f6ab28dad97&chksm=be4b59a8893cd0bee407e3d8a1b7bec44d7571623c355a37f352d5cf9e104d986af6f5b5e1fe&scene=21#wechat_redirect)

# python垃圾回收原理
> python的垃圾回收机制主要是引用计数为主，标记清除和分代回收为辅。
> + 引用计数：循环引用问题
> + 标记清除：
> + 分代回收：

# redis五种数据结构应用场景及底层如何实现
> + string
> + set
> + hash
> + sorted set
> + list

# 布隆过滤器原理

# redis分布式锁解决问题及原理，优缺点

# mysql隔离级别及悲观锁和乐观锁原理

# mysql优化

# sanic框架源码以及优缺点

# api用户认证如何处理

# 后端服务如何排错调优

# 后端如何主动发送请求给前端