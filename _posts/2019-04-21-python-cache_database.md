layout: mypost
title: Python-缓存数据库
categories: [Python, DataBase]
---
## memcache

```python
#easy_install python-memcached   # 安装(python2.7+)
import memcache
mc = memcache.Client(['10.152.14.85:12000'],debug=True)    # 也可以使用socket直接连接IP端口
mc.set('name','luo',60)
mc.get('name')
mc.delete('name1')

# 豆瓣的python-memcache模块，大于1M自动切割 性能是纯python的3倍+
# https://code.google.com/p/python-libmemcached/

# 保存数据

mc.set(key,value,timeout)      # 把key映射到value，timeout指的是什么时候这个映射失效
mc.add(key,value,timeout)      # 仅当存储空间中不存在键相同的数据时才保存
mc.replace(key,value,timeout)  # 仅当存储空间中存在键相同的数据时才保存

# 获取数据

mc.get(key)                    # 返回key所指向的value
mc.get_multi(key1,key2,key3)   # 可以非同步地同时取得多个键值， 比循环调用get快数十倍
```


## mongodb

```python
# 新版本
# http://api.mongodb.org/python/2.7.2/tutorial.html
# http://api.mongodb.org/python/current/examples/custom_type.html

# easy_install pymongo      # 安装

import pymongo

cl = pymongo.MongoClient("127.0.0.1", 27017)
db = cl.ops             # 选择库
db.name                 # 查看库名
db.collection_names()   # 查看所有文档
db.project              # 选择文档
db.project.insert({'name':'live','group':'a'})
db.project.insert({'name':'news','group':'b'})
db.project.find_one({'group':'a'})
for post in db.project.find():
   print(post['name'])
db.project.remove()

# 执行mongo命令
# https://api.mongodb.com/python/current/api/pymongo/database.html
db.command("filemd5", object_id, root=file_root)
db.command("dropUser", "user")
db.command("createUser", "admin", pwd="password", roles=["root"])
for x,y in db.command("currentOp").items():
    print(x,y)

# currentOp在mongo3.9废弃,建议使用 aggregate()
with client.admin.aggregate([{"$currentOp": {}}]) as cursor:
    for operation in cursor:
        print(operation)
```

## redis

```python
# https://pypi.python.org/pypi/redis                  # redis的python官网
# pip install redis  OR easy_install redis            # 安装
# http://redis.readthedocs.org/en/latest/index.html   # redis命令详解
# http://redis.readthedocs.org/en/2.4/index.html

import redis
rds = redis.Redis(host=host, port=port, password=passwd, socket_timeout=10,db=0)
rds.info()                           # redis信息
rds.set(key, value)                  # 将值value关联到key
rds.get(key)                         # 取key值
rds.delete(key1,key2)                # 删除key
rds.rename(key,new_key2)             # 将key改名 存在覆盖
rds.seten(key,value)                 # 将值value关联到key,如果key存在不做任何动作
rds.setex(key, value, 10800)         # 将值value关联到key,并设置key的过期时间
rds.mset()                           # 同时设置一个或多个key-value对  如果key存在则覆盖
rds.msetnx()                         # 同时设置一个或多个key-value对  如果有key存在则失败
rds.mget(key1, key2, key3)           # 取多个key值   不存在返回nil
rds.expire(key seconds)              # 设置key的过期时间
rds.persist(key)                     # 移除key的过期时间
rds.ttl(key)                         # 查看超时时间 -1为不过期
rds.sadd(key,value1)                 # 将value1加入集合中  集合不重复
rds.smembers(key)                    # 返回key中所有成员
rds.scard(key)                       # 集合中元素的数量
rds.srandmember(key)                 # 对集合随机返回一个元素 而不对集合改动  当key不存在或key是空集时，返回nil
rds.sinter(key1,key2)                # 两个集合的交集
rds.sdiff(key1,key2)                 # 两个集合的差集
rds.sismember(key,value)             # 判断value元素是否是集合key的成员 1存在 0不存在
rds.lpush(key,value1)                # 将value1加入列表中  从左到右
rds.lpop(key,value1)                 # 移除并返回列表key的头元素
rds.llen(key)                        # 返回列表长度
rds.sort(key)                        # 对列表、集合、有序集合排序[大列表排序非常影响性能，甚至把redis拖死]
rds.append(key,value)                # 字符串拼接为新的value
rds.ltrim(key, 0, -10)               # 保留指定区间内的元素，不在都被删除 0第一个 -1最后一个
rds.incr(key , amount=1)             # 计数加1 默认1或请先设置key的数值
rds.decr(key)                        # 计数减1 请先设置key的数值
rds.save()                           # 保存数据
```

## kestrel队列

### pykestrel

```python
import kestrel

q = kestrel.Client(servers=['127.0.0.1:22133'],queue='test_queue')
q.add('some test job')
job = q.get()    # 从队列读取工作
job = q.peek()   # 读取下一份工作
# 读取一组工作
while True:
    job = q.next(timeout=10) # 完成工作并获取下一个工作，如果没有工作，则等待10秒
    if job is not None:
        try:
            # 流程工作
        except:
            q.abort() # 标记失败工作

q.finish()  # 完成最后工作
q.close()   # 关闭连接
```
### kestrel状态检查

```python
# kestrel支持memcache协议客户端
#!/usr/local/bin/python
# 10.13.81.125 22133  10000

import memcache
import sys
import traceback

ip="%s:%s" % (sys.argv[1],sys.argv[2])
try:
    mc = memcache.Client([ip,])
    st=mc.get_stats()
except:
    print("kestrel connection exception")
    sys.exit(2)

if st:
    for s in st[0][1].keys():
        if s.startswith('queue_') and s.endswith('_mem_items'):
            num = int(st[0][1][s])
            if num > int(sys.argv[3]):
                print("%s block to %s" %(s[6:-6],num))
                sys.exit(2)
    print("kestrel ok!")
    sys.exit(0)
else:
    print("kestrel down")
    sys.exit(2)
```

## tarantool

```python
# pip install tarantool-queue

from tarantool_queue import Queue
queue = Queue("localhost", 33013, 0)     # 连接读写端口 空间0
tube = queue.tube("name_of_tube")        #
tube.put([1, 2, 3])

task = tube.take()
task.data     # take task and read data from it
task.ack()    # move this task into state DONE
```

## etcd

```python

# http://python-etcd.readthedocs.io/en/latest/

# pip install python-etcd
import etcd
client = etcd.Client(host='etcd-01', port=2379)
client = etcd.Client( (('etcd-01', 2379), ('etcd-02', 2379), ('etcd-03', 2379)) ,allow_reconnect=True)   # 集群多IP  allow_reconnect 允许重连

# 增加 目录必须存在 # 目录: /v1/xuesong/
client.write('/v1/xuesong/10.10.10.10:8080', 'test')
# 获取指定路径的值
r = client.read('/v1/xuesong/10.10.10.10:8080' , recursive=True, sorted=True)
r.value
# 删除指定路径
client.delete('/v1/xuesong/10.10.10.10:8080')

# with ttl
client.write('/nodes/n2', 2, ttl=4)  # sets the ttl to 4 seconds
# create only
client.write('/nodes/n3', 'test', prevExist=False)
# Compare and swap values atomically
client.write('/nodes/n3', 'test2', prevValue='test1')    #this fails to write
client.write('/nodes/n3', 'test2', prevIndex=10)         #this fails to write
# mkdir
client.write('/nodes/queue', None, dir=True)
# Append a value to a queue dir
client.write('/nodes/queue', 'test', append=True)        #will write i.e. /nodes/queue/11
client.write('/nodes/queue', 'test2', append=True)       #will write i.e. /nodes/queue/12

client.read('/nodes/n2').value                           # 获取单个键值
r = client.read('/nodes', recursive=True, sorted=True)   # 递归查询目录
for i in r.children:
    if not i.dir:
        print("%s: %s" % (child.key,child.value))

client.read('/nodes/n2', wait=True) #Waits for a change in value in the key before returning.
client.read('/nodes/n2', wait=True, waitIndex=10)

try:
    client.read('/invalid/path')
except etcd.EtcdKeyNotFound:
    print("error")

client.delete('/nodes/n1')
client.delete('/nodes', dir=True)             #spits an error if dir is not empty
client.delete('/nodes', recursive=True)       #this works recursively

client.watch('/nodes/n1', recursive=True,timeout=0)        # 递归获取改变值 阻塞直到有改变

# watch只会阻塞监视之后的一次改动，所以必须先递归read下所有路径，然后根据每次的watch进行更改
# 第一次read的时候，需要记录 etcd_index+1作为下一次watch的索引
index = client.read('/nodes/n1', recursive=True).etcd_index
while 1:
    # watch后的索引是 modifiedIndex+1传给下一次的watch
    index = client.watch('/nodes/n1', recursive=True, timeout=0, index=index+1).modifiedIndex
```

## zookeeper

```python
# https://kazoo.readthedocs.io/en/latest/basic_usage.html

# pip install kazoo
from kazoo.client import KazooClient

zk = KazooClient(hosts='127.0.0.1:2181', read_only=True)
zk.start()
zk.get_children('/')
zk.stop()
```

## elasticsearch

```python
# http://elasticsearch-py.readthedocs.io/en/master/

from datetime import datetime
from elasticsearch import Elasticsearch

es = Elasticsearch(["host1", "host2"])

doc = {
    'author': 'kimchy',
    'text': 'Elasticsearch: cool. bonsai cool.',
    'timestamp': datetime.now(),
}

res = es.index(index="live-", doc_type='tweet', id=1, body=doc)
print(res['created'])

res = es.get(index="live-", doc_type='tweet', id=1)
print(res['_source'])

es.indices.refresh(index="live-")

res = es.search(index="live-", body={"query": {"match_all": {}}})
```
