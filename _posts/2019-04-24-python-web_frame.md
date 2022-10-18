---
layout: mypost
title: Python-Web框架
categories: [Python, Web]
---

## flask           [微型网络开发框架]

```python
# http://dormousehole.readthedocs.org/en/latest/
# http://www.pythonhosted.org/Flask-Bootstrap/basic-usage.html#templates
# html放在 ./templates/   js放在 ./static/

#pip install Flask-Login
#pip install Flask-OpenID
#pip install Flask-WTF
#pip install flask-bootstrap
#pip install flask-sqlalchemy
#pip install flask-script
#pip install flask-migrate

request.args.get('page', 1)          # 获取参数 ?page=1
request.json                         # 获取传递的整个json数据
request.form.get("host",'127')       # 获取表单值
request.form.getlist('client')       # 获取表单列表

简单实例 # 接收数据和展示

import MySQLdb as mysql
from flask import Flask, request

app = Flask(__name__)
db.autocommit(True)
c = db.cursor()

"""
CREATE TABLE `statusinfo` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `hostname` varchar(32) NOT NULL,
  `load` float(10) NOT NULL DEFAULT 0.00,
  `time` int(15) NOT NULL,
  `memtotal` int(15) NOT NULL,
  `memusage` int(15) NOT NULL,
  `memfree` int(15) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=utf8;
"""

@app.route("/collect", methods=["GET", "POST"])
def collect():
    sql = ""
    if request.method == "POST":
        data = request.json                      # 获取传递的json
        hostname = data["Host"]
        load = data["LoadAvg"]
        time = data["Time"]
        memtotal = data["MemTotal"]
        memusage = data["MemUsage"]
        memfree = data["MemFree"]

        try:
            sql = "INSERT INTO `statusinfo` (`hostname`,`load`,`time`,`memtotal`,`memusage`,`memfree`) VALUES('%s', %s, %s, %s, %s, %s);" % (hostname, load,time,memtotal,memusage,memfree)
            ret = c.execute(sql)
            return 'ok'
        except mysql.IntegrityError:
            return 'errer'

@app.route("/show", methods=["GET", "POST"])
def show():
    try:
        hostname = request.form.get("hostname")     # 获取表单方式的变量值
        sql = "SELECT `load` FROM `statusinfo` WHERE hostname = '%s';" % (hostname)
        c.execute(sql)
        ones = c.fetchall()
        return render_template("sysstatus.html", data=ones, sql = sql)
    except:
        print('hostname null')

from flask import render_template
@app.route("/xxx/<name>")
def hello_xx(name):
    return render_template("sysstatus.html", name='teach')

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=50000, debug=True)
```

## Flask-SQLAlchemy

```python
http://www.pythondoc.com/flask-sqlalchemy/queries.html#id2
http://docs.jinkan.org/docs/flask-sqlalchemy/models.html#id2
https://www.cnblogs.com/mosson/p/6257147.html

db.create_all()   # 创建表

# 增加
admin = User('admin', 'admin@example.com')
db.session.add(admin)
db.session.add(guest)
db.session.commit()

# 查询
# 返回数组
users = User.query.all()
# 条件过滤 返回一个对象  不存在返回 返回none  像python传参数
peter = User.query.filter_by(username = 'peter').first()
# 条件过滤 像sql 可使用 ><
peter = User.query.filter(username == 'peter').first()
# 获取指定列的值
print peter.username
# 复杂查询 返回列表对象
User.query.filter(User.email.endswith('@example.com')).all()
# 对查询结果按指定列排序
User.query.order_by(User.username)
# 取前面的指定条数
User.query.limit(1).all()
# 通过主键来获取对象
User.query.get(1)
# 通配查询 ilike 忽略大小写
User.query.filter(User.username.ilike('online_%')).all()
User.query.filter(User.username.notilike('online_%')).all()

# 删除
user = User.query.get(id)
db.session.delete(user)
db.session.commit()
User.query.filter_by(id=123).delete()
User.query.filter(User.id == 123).delete()

# 改
db.session.query(Users).filter(Users.id > 2).update({"name" : "099"})
db.session.commit()


q = db.session.query(Toner)
q = q.filter(Toner.toner_id==1)
record = q.one()
record.toner_color = 'Azure Radiance'
db.session.flush()

# 连表
ret = session.query(Users, Favor).filter(Users.id == Favor.nid).all()
ret = session.query(Person).join(Favor).all()
ret = session.query(Person).join(Favor, isouter=True).all()

# 通配符
ret = session.query(Users).filter(Users.name.like('e%')).all()
ret = session.query(Users).filter(~Users.name.like('e%')).all()

# 排序
ret = session.query(Users).order_by(Users.name).all()                          # 正序
ret = session.query(Users).order_by(Users.name.desc()).all()                   # 倒序
ret = session.query(Users).order_by(Users.name.desc(), Users.id.asc()).all()
```

## twisted         [非阻塞异步服务器框架]

```python
# 较老 推荐使用 协程框架 或 微线程框架
# 用来进行网络服务和应用程序的编程。虽然 Twisted Matrix 中有大量松散耦合的模块化组件，但该框架的中心概念还是非阻塞异步服务器这一思想。对于习惯于线程技术或分叉服务器的开发人员来说，这是一种新颖的编程风格，但它却能在繁重负载的情况下带来极高的效率。
pip install twisted

from twisted.internet import protocol, reactor, endpoints

class Echo(protocol.Protocol):
    def dataReceived(self, data):
        self.transport.write(data)
class EchoFactory(protocol.Factory):
    dDescribeInstanceStatusef buildProtocol(self, addr):
        return Echo()

endpoints.serverFromString(reactor, "tcp:1234").listen(EchoFactory())
reactor.run()
```

### 服务端

```python
#!/usr/bin/env python

from twisted.application import service, internet
from txjsonrpc.netstring import jsonrpc

class Example(jsonrpc.JSONRPC):
    """An example object to be published."""
    def jsonrpc_echo(self,  x):
        """Return all passed args."""
        return x
    def jsonrpc_add(self, a, b):
        """Return sum of arguments."""
        print("add", a, b)
        return(a + b)

factory = jsonrpc.RPCFactory(Example())
application = service.Application("Example JSON-RPC Server")
jsonrpcServer = internet.TCPServer(7080, factory)
jsonrpcServer.setServiceParent(application)
```

### 客户端

```python
#!/usr/bin/env python

import os
import sys
sys.path.insert(0, os.getcwd())
from twisted.internet import reactor
from txjsonrpc.netstring.jsonrpc import Proxy

def printValue(value):
    print("Result: %s" % str(value))
    reactor.stop()

def printError(error):
    print('error', error)
    reactor.stop()

proxy = Proxy('127.0.0.1', 7080)
proxy.callRemote('add', 3, 5).addCallbacks(printValue, printError)
reactor.run()
```


## Celery          [分布式任务队列]

```python
# http://docs.jinkan.org/docs/celery/getting-started/introduction.html
pip install -U Celery
```

## tornado         [极轻量级Web服务器框架]

```python
# 高可伸缩性和epoll非阻塞IO,响应快速,可处理数千并发连接,特别适用用于实时的Web服务 底层是gevent协程
# http://www.tornadoweb.cn/documentation
# http://old.sebug.net/paper/books/tornado/#_2
# http://demo.pythoner.com/itt2zh/ch5.html
# 非阻塞方式生成子进程
# https://github.com/vukasin/tornado-subprocess

# pip install tornado

self.get_argument()           # 方法来获取查询字符串参数，以及解析 POST 的内容
self.request.arguments        # 所有的 GET 或 POST 的参数
self.request.files            # 所有通过 multipart/form-data POST 请求上传的文件
self.request.path             # 请求的路径（ ? 之前的所有内容）
self.request.headers          # 请求的开头信息
callback                      # 执行完成后执行回调函数

@tornado.web.asynchronous     # 非阻塞异步装饰器
self.finish()                 # 使用非阻塞异步 必须调用 self.finish() 已完成 HTTTP 请求
# 异步 HTTP 客户端 两种模式 默认 SimpleAsyncHTTPClient  如果要修改为 CurlAsyncHTTPClient
AsyncHTTPClient.configure('tornado.curl_httpclient.CurlAsyncHTTPClient')


import tornado.ioloop
import tornado.web
import tornado.httpclient
import json


class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("Hello, world")

    def post(self):
        self.set_header("Content-Type", "text/plain")
        self.write("You wrote " + self.get_argument("message"))

class Template(tornado.web.RequestHandler):
    def get(self):
        items = ["Item 1", "Item 2", "Item 3"]
        self.render("template.html", title="My title", items=items)

class urlhttp(tornado.web.RequestHandler):
    @tornado.web.asynchronous
    def get(self):
        http = tornado.httpclient.AsyncHTTPClient()
        http.fetch("http://friendfeed-api.com/v2/feed/bret", callback=self.on_response)

    def on_response(self, response):
        if response.error: raise tornado.web.HTTPError(500)
        jsondata = tornado.escape.json_decode(response.body)
        print(type(jsondata))
        self.write(json.dumps(jsondata))
        self.finish()

class StoryHandler(tornado.web.RequestHandler):
    def get(self, story_id):
        self.write("You requested the story " + story_id)

def make_app():
    return tornado.web.Application([
        (r"/", MainHandler),
        (r"/template", Template),
        (r"/story/([0-9]+)", StoryHandler),
        (r"/tapi", urlhttp),
    ])

if __name__ == "__main__":
    app = make_app()
    app.listen(8888)
    tornado.ioloop.IOLoop.current().start()
```

## Scrapy          [web抓取框架]

```python
# Python开发的一个快速,高层次的屏幕抓取和web抓取框架，用于抓取web站点并从页面中提取结构化的数据。Scrapy用途广泛，可以用于数据挖掘、监测和自动化测试。
pip install scrapy

from scrapy import Spider, Item, Field

class Post(Item):
    title = Field()

class BlogSpider(Spider):
    name, start_urls = 'blogspider', ['http://blog.scrapinghub.com']

    def parse(self, response):
        return [Post(title=e.extract()) for e in response.css("h2 a::text")]

# scrapy runspider myspider.py
```
## Sanic           [高性能的异步web框架]

## fastapi         [高性能的异步web框架]

## django          [重量级web框架]

## bottle          [轻量级的Web框架]

## stackless       [增强版python]

```python
# 微线程扩展，是一种低开销、轻量级的便利工具  避免传统线程所带来的性能与复杂度问题
```

## greenlet        [微线程/协程框架]

```python
# 更加原始的微线程的概念,没有调度,或者叫做协程。这在你需要控制你的代码时很有用。你可以自己构造微线程的 调度器；也可以使用"greenlet"实现高级的控制流。例如可以重新创建构造器；不同于Python的构造器，我们的构造器可以嵌套的调用函数，而被嵌套的函数也可以 yield 一个值。
# pip install greenlet
```

## asyncio         [异步I/O协同]

```python
# https://docs.python.org/3/library/asyncio.html
# 需要python3.4+
# asyncio: 协同程序和事件循环。协同程序像是方法，但是它们可以在代码中的特定点暂停和继续。当在等待一个IO（比如一个HTTP请求），同时执行另一个请求的时候，可以用来暂停一个协同程序。我们使用关键字yield from来设定一个状态，表明我们需要一个协同程序的返回值。而事件循环则被用来安排协同程序的执行。
```
    