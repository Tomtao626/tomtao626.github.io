---
layout: mypost
title: MongoDB系列-操作
categories: [DataBase, MongoDB]
---

## 数据库相关概念

| SQL概念 | MongoDB概念 | 解释/说明 |
| :-----: | :---------: | :-------:|
| `database` | `database` | 数据库 |
| `table` | `collection` | 数据库表/集合 |
| `row` | `document` | 数据记录行/文档 |
| `column` |`field` | 数据字段/域 |
| `index` | `index` | 索引 |
| `primary key` | `primary key` | 主键,MongoDB自动将_id字段设置为主键 |

## 进入mongo命令行
```shell
$ mongo
```

## 选择(切换)数据库
```shell
> use admin
```

## 创建用户并验证
```shell
> db.createUser({user:'tomtao626', pwd:'pwd1234', roles:[{role:'root',db:'admin'}]})
```
![](https://p6-tt.byteimg.com/origin/pgc-image/71149d80c5104feaa587013b72d5aa1f.png)

## 创建数据库
使用`use [数据库名称]` 命令并插入数据就会创建一个数据库
```shell
# 创建数据库test
> use test
# 插入数据
> db.article.insert({title:'MongoDB 教程',desc:'MongoDB是一个nosql数据库',by:'andy',url:'https://www.mongodb.com',tags:['mongodb','nosql','database'],likes:9527})
# 插入成功会返回 WriteResult({ "nInserted" : 1 })
# 查看所有的数据库
> show dbs
# admin   0.000GB
# config  0.000GB
# local   0.000GB
# test    0.000GB
```
![](https://p6-tt.byteimg.com/origin/pgc-image/403b24f2d1754f05935b953dcf10dc02.png)

## 删除数据库
使用`db`对象中的`dropDatabase()`方法来删除

```shell
> use test
> db.dropDatabase()
# 删除成功会返回 { "dropped" : "test", "ok" : 1 }
```
![](https://p9-tt.byteimg.com/origin/pgc-image/1345772c48d34328a3454eb3166e07fe.png)

查看所有的数据库
```shell
> show dbs
# admin   0.000GB
# config  0.000GB
# local   0.000GB
```
![](https://p9-tt.byteimg.com/origin/pgc-image/b2ee281e26bb43099ce75e38e0844df4.png)

## 集合操作
> + 创建集合，使用`db`对象中的`createCollection()`方法来创建集合，例如创建一个article集合

```shell
> use test;
# switched to db test
> db.createCollection("article");
# { "ok" : 1 }
> show collections;
# article
```

> + 删除集合，使用collection对象的drop()方法来删除集合，例如删除一个article集合

```shell
> db.article.drop()
# 删除成功会返回 true
```

![](https://p6-tt.byteimg.com/origin/pgc-image/7cd784b8b3d24ae495c109542a93dc6f.png)

## 文档操作
### 插入
> + 使用collection对象的insert()方法来插入文档，语法如下

```shell
db.collection.insert(document)
```
 
> + 例如插入一个article文档

```shell
> db.article.insert({title:'MongoDB 教程',desc:'MongoDB是一个nosql数据库',by:'andy',url:'https://www.mongodb.com',tags:['mongodb','nosql','database'],likes:9527})
# 插入成功会返回 WriteResult({ "nInserted" : 1 })
```

### 更新
> + 通过collection对象的`update()`来更新集合中的文档，语法如下:

```shell
db.collection.update(
   <query>,
   <update>,
   {
     multi: <boolean>
   }
)
# query：修改的查询条件，类似于SQL中的WHERE部分
# update：更新属性的操作符，类似与SQL中的SET部分
# multi：设置为true时会更新所有符合条件的文档，默认为false只更新找到的第一条
```
> + 将title为`MongoDB 教程`的所有文档的title修改为`MongoDB`

```shell
> db.article.update({'title':'MongoDB教程'}, {$set:{'title':'MongoDB'}}, {multi:true})
```
![](https://p5-tt.byteimg.com/origin/pgc-image/7e42e4361776453fb720bf9a2e71bc9f.png)

> + 除了`update()`方法以外，`save()`方法可以用来替换已有文档，语法如下

```shell
db.collection.save()
```
> + 将`ObjectId`为`60e2a42cc76338ee56d30e4a`的文档的`title`改为`MongoDB 教程`
```shell
> db.article.save({"_id":ObjectId("60e2a42cc76338ee56d30e4a"),
  "title":"MongoDB 教程",
  "desc":"MongoDB是一个nosql数据库",
  "by":"tomtao626",
  "url":"https://www.mongodb.com",
  "tags":[
      "mongodb",
      "nosql",
      "database"
     ],
  "likes":9527})
# 修改成功会返回 WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
```
![](https://p6-tt.byteimg.com/origin/pgc-image/34b940912e3f41528f59c1c16b0f8ca2.png)

### 删除
> + 通过`collection`对象的`remove()`方法来删除集合中的文档，语法如下

```shell
db.collection.remove(
   <query>,
   {
     justOne: <boolean>
   }
)
# query：删除的查询条件，类似于SQL中的WHERE部分
# justOne：设置为true只删除一条记录，默认为false删除所有记录
```

> + 删除`title`为`MongoDB 教程`的所有文档

```shell
> db.article.remove({'title':'MongoDB 教程'})
# 删除成功会返回 WriteResult({ "nRemoved" : 0 })
```
![](https://p3-tt.byteimg.com/origin/pgc-image/1a30cd52628140bca24e5a8902b6b751.png)

### 查询
> + 使用collection对象的find()方法可以获取文档，语法如下

```shell
db.collection.find(query, projection)
# query：查询条件，类似于SQL中的WHERE部分
# projection：可选，使用投影操作符指定返回的键
```

> + 获取所有的article文档，可以加一个pretty参数，将返回结果格式化一下

```shell
> db.article.find({}).pretty()
# {
	"_id" : ObjectId("60e2a42cc76338ee56d30e4a"),
	"title" : "MongoDB 教程",
	"desc" : "MongoDB是一个nosql数据库",
	"by" : "andy",
	"url" : "https://www.mongodb.com",
	"tags" : [
		"mongodb",
		"nosql",
		"database"
	],
	"likes" : 9527
}
```

> + 为了方便演示，我又插入了几条数据，插入操作同上
```shell
> db.article.find().pretty()
# {
	"_id" : ObjectId("60e2a42cc76338ee56d30e4a"),
	"title" : "MongoDB 教程",
	"desc" : "MongoDB是一个nosql数据库",
	"by" : "zhangsan",
	"url" : "https://www.mongodb.com",
	"tags" : [
		"mongodb",
		"nosql",
		"database"
	],
	"likes" : NumberDecimal("102")
}
{
	"_id" : ObjectId("60e2badcc76338ee56d30e4b"),
	"title" : "MongoDB 测试",
	"desc" : "MongoDB是一个nosql数据库",
	"by" : "andy",
	"url" : "https://www.mongodb.com",
	"tags" : [
		"mongodb",
		"nosql",
		"database"
	],
	"likes" : 9527
}
{
	"_id" : ObjectId("60e2bae8c76338ee56d30e4c"),
	"title" : "Python 测试",
	"desc" : "MongoDB是一个nosql数据库",
	"by" : "andy",
	"url" : "https://www.mongodb.com",
	"tags" : [
		"mongodb",
		"nosql",
		"database"
	],
	"likes" : NumberDecimal("9526")
}
{
	"_id" : ObjectId("60e2a42cc76338ee56d30e4b"),
	"title" : "MongoDB 测试",
	"desc" : "MongoDB是一个nosql数据库",
	"by" : "tomtao626",
	"url" : "https://www.mongodb.com",
	"tags" : [
		"mongodb",
		"nosql",
		"database"
	],
	"likes" : 500
}
{
	"_id" : ObjectId("60e2a42cc76338ee56d30e4f"),
	"title" : "MongoDB 测试",
	"desc" : "MongoDB是一个nosql数据库",
	"by" : "zhangsan",
	"url" : "https://www.mongodb.com",
	"tags" : [
		"mongodb",
		"nosql",
		"database"
	],
	"likes" : 95
}
```
![](https://p9-tt.byteimg.com/origin/pgc-image/0a0b6a3f3c964ee6a8da64dc67afb0d8.png)

> + MongoDB中的条件操作符，可以对比下关系型数据库的SQL语句

| 操作 | 格式 | SQL中的类似语句 |
|:---:|:-----:|:------------:|
| 等于 | `{<key>:<value>}` | `where title = 'MongoDB 教程'` |
| 小于 | `{<key>:{$lt:<value>}}` | `where likes < 50` |
| 小于或等于 | `{<key>:{$lte:<value>}}` | `where likes <= 50` |
| 大于 | `{<key>:{$gt:<value>}}` | `where likes > 50` |
| 大于或等于 | `{<key>:{$gte:<value>}}` | `where likes >= 50` |
| 不等于 | `{<key>:{$ne:<value>}}` | `where likes != 50` |

> + 条件查询，查询`title`为`MongoDB 教程`的所有文档

```shell
> db.article.find({'title':'MongoDB 测试'})
```
![](https://p26-tt.byteimg.com/origin/pgc-image/c27d4bda84ca49ca856ba968fd7f2d0b.png)

> + 条件查询，查询`likes`大于500的所有文档

```shell
> db.article.find({'likes':{$gt:50}})
```
![](https://p6-tt.byteimg.com/origin/pgc-image/c1434a34a0e24b87bf9bcbc2f7045be8.png)

> + `AND`条件可以通过在`find()`方法传入多个键，以逗号隔开来实现，例如查询`title`为`MongoDB 测试`并且`by`为`zhangsan`的所有文档；

```shell
> db.article.find({'title':'MongoDB 测试','by':'zhangsan'})
```
![](https://p26-tt.byteimg.com/origin/pgc-image/e4420e16948944a3ba89766ad0e2ed8b.png)

> + `OR`条件可以通过使用`$or`操作符实现，例如查询`title`为Python 测试或MongoDB 测试的所有文档；

```shell
db.article.find({$or:[{"title":"MongoDB 测试"},{"title": "Python 测试"}]})
```
![](https://p6-tt.byteimg.com/origin/pgc-image/eac1407c843242519ff456f1da23736a.png)

> + AND 和 OR条件的联合使用，例如查询likes大于500，并且title为Python 测试或者"MongoDB 测试的所有文档。

```shell
> db.article.find({'likes':{$gt:500}, $or:[{'title':'Python 测试'},{'title':'MongoDB 测试'}]})
```
![](https://p3-tt.byteimg.com/origin/pgc-image/73fdd5ddc4354879be8b21ec7e8d0af3.png)

## Limit与Skip操作
> + 读取指定数量的文档，可以使用limit()方法，语法如下

```shell
db.collection.find().limit(NUMBER)
```

> + 只查询article集合中的2条数据；

```shell
> db.article.find().limit(2)
```
![](https://p6-tt.byteimg.com/origin/pgc-image/3aa54185d2bd4bf5b8ee14befe952bba.png)

> + 跳过指定数量的文档来读取，可以使用skip()方法，语法如下

```shell
db.collection.find().limit(NUMBER).skip(NUMBER)
```

> + 从第二条开始，查询article集合中的2条数据；

```shell
> db.article.find().limit(2).skip(1)
```
![](https://p9-tt.byteimg.com/origin/pgc-image/7a164e5e3e014b2887deb01b9ead586c.png)

## 排序
> + 使用`sort()`方法对数据进行排序，`sort()`方法通过参数来指定排序的字段，并使用1和-1来指定排序方式，1为升序，-1为降序，语法如下

```shell
db.collection.find().sort({KEY:1})
```

> + 按article集合中文档的likes字段降序排列

```shell
> db.article.find().sort({likes:-1})
```
![](https://p6-tt.byteimg.com/origin/pgc-image/7165b69e653740b4b38e2ac4c1ab4f1c.png)

## 索引
> + 使用`createIndex()`方法来创建索引，语法如下

```shell
db.collection.createIndex(keys, options)
# background：建索引过程会阻塞其它数据库操作，设置为true表示后台创建，默认为false
# unique：设置为true表示创建唯一索引
# name：指定索引名称，如果没有指定会自动生成
```

> + 给title和desc字段创建索引，1表示升序索引，-1表示降序索引，指定以后台方式创建

```shell
> db.article.createIndex({"title":1, "desc":-1},{background:true})
```
![](https://p9-tt.byteimg.com/origin/pgc-image/40ddc7e811054c4f884fa5794128c632.png)

> + 查看article集合中已经创建的索引

```shell
> db.article.getIndexes()
```
![](https://p6-tt.byteimg.com/origin/pgc-image/6433662c14154cff9a63c751fa72c834.png)


## 聚合
使用`aggregate()`方法，类似于SQL中的`group by`语句，语法如下；

```shell
> db.collection.aggregate(AGGREGATE_OPERATION)
```

聚合中常用操作符如下；

| 操作符 | 描述 |
|:---:|:---:|
| `$sum` | 计算总和 |
| `$avg` | 计算平均值 |
| `$min` | 计算最小值 |
| `$max` | 计算最大值 |

> + 根据likes数值分组，计算对应组所含文档的数量

```shell
> db.article.aggregate([{$group:{_id:"$likes", sum_count:{$sum:1}}}])
# { "_id" : 500, "sub_count" : 1 }
{ "_id" : 9527, "sub_count" : 2 }
{ "_id" : 95, "sub_count" : 2 }
```
![](https://p9-tt.byteimg.com/origin/pgc-image/847da7e885ad415294ed5451fea24b0d.png)

> + 根据title分组，计算每组数据的likes平均值

```shell
> db.article.addredate([{$group:{_id:"$title", avg_likes:{$avg:"$likes"}}}])
```
![](https://p6-tt.byteimg.com/origin/pgc-image/beab0dfa1a4b418bb527f2309200f1cc.png)

## 正则
MongoDB使用$regex操作符来设置匹配字符串的正则表达式，可以用来模糊查询，类似于SQL中的like操作；
> + 例如查询title中包含教程的文档；

```shell
> db.article.find({title:{$regex:"教程"}})
```

> + 不区分大小写的模糊查询，使用$options操作符；

```shell
> db.article.find({title:{$regex:"elasticsearch",$options:"$i"}})
```
