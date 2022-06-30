---
layout: mypost
title: Golang中使用MongoDB详解
categories:  [Golang, MongoDB]
---

> 支持库用的mgo，当然更推荐mongo-go-driver/qmgo

# 1-初始化

```go
package main

import (
    "fmt"
    "gopkg.in/mgo.v2"
    "gopkg.in/mgo.v2/bson"
)

type Student struct {
    Name   string `bson:"name"`
    Age    int `bson:"age"`
    Score  int `bson:"score"`
    Status int `bson:"status"`
}

type Per struct {
	Per []Student
}

func main() {
	mongo, err := mgo.Dial("127.0.0.1")
	defer mongo.Close()
	if err != nil {
		return
	}
	client := mongo.DB("local").C("student")
}
```

# 2-创建/插入数据

```go
package main

import (
    "fmt"
    "gopkg.in/mgo.v2"
    "gopkg.in/mgo.v2/bson"
)

type Student struct {
    Name   string `bson:"name"`
    Age    int `bson:"age"`
    Score  int `bson:"score"`
    Status int `bson:"status"`
}

type Per struct {
	Per []Student
}

func main() {
    mongo, err := mgo.Dial("127.0.0.1")
    defer mongo.Close()
    if err != nil{
    return
}
client := mongo.DB("local").C("student")
data := Student{
    Name: "tomtao",
    Age: 22,
    Score: 99,
    Status: 0,
}
insertErr := client.Insert(&data)
    if insertErr != nil{
    return
}
return
```

# 3-查询findOne

```go
package main

import (
    "fmt"
    "gopkg.in/mgo.v2"
    "gopkg.in/mgo.v2/bson"
)

type Student struct {
    Name   string `bson:"name"`
    Age    int `bson:"age"`
    Score  int `bson:"score"`
    Status int `bson:"status"`
}

type Per struct {
	Per []Student
}

func main() {
    mongo, err := mgo.Dial("127.0.0.1")
    defer mongo.Close()
    if err != nil{
    return
}
client := mongo.DB("local").C("student")
user := Student{}
queryOneErr := client.Find(bson.M{"name":"test111"}).One(&user)
if queryOneErr != nil{
    return
}
fmt.Println(user)
return
```

# 4-查询findAll

```go
package main

import (
    "fmt"
    "gopkg.in/mgo.v2"
    "gopkg.in/mgo.v2/bson"
)

type Student struct {
    Name   string `bson:"name"`
    Age    int `bson:"age"`
    Score  int `bson:"score"`
    Status int `bson:"status"`
}

type Per struct {
	Per []Student
}

func main() {
    mongo, err := mgo.Dial("127.0.0.1")
    defer mongo.Close()
    if err != nil{
    return
}
client := mongo.DB("local").C("student")
iter := client.Find(bson.M{"status":0}).Sort("_id").Skip(1).Limit(10).Iter()
var stu Student
var users Per
for iter.Next(&stu) {
    users.Per = append(users.Per, stu)
}
if QueryAllErr := iter.Close(); QueryAllErr != nil {
    return
}
fmt.Println(users)
return
```

# 5-更新数据update/all

```go
package main

import (
    "fmt"
    "gopkg.in/mgo.v2"
    "gopkg.in/mgo.v2/bson"
)

type Student struct {
    Name   string `bson:"name"`
    Age    int `bson:"age"`
    Score  int `bson:"score"`
    Status int `bson:"status"`
}

type Per struct {
	Per []Student
}

func main() {
    mongo, err := mgo.Dial("127.0.0.1")
    defer mongo.Close()
    if err != nil{
    return
}
client := mongo.DB("local").C("student")
updateErr, _ := client.UpdateAll(bson.M{"status": 0}, bson.M{"$set": bson.M{"age": 99}})
if updateErr != nil{
    return
}
```

# 6-删除数据
	
```go
package main

import (
    "fmt"
    "gopkg.in/mgo.v2"
    "gopkg.in/mgo.v2/bson"
)

type Student struct {
    Name   string `bson:"name"`
    Age    int `bson:"age"`
    Score  int `bson:"score"`
    Status int `bson:"status"`
}

type Per struct {
	Per []Student
}

func main() {
    mongo, err := mgo.Dial("127.0.0.1")
    defer mongo.Close()
    if err != nil{
    return
}
client := mongo.DB("local").C("student")
deleteErr := client.Remove(bson.M{"_id":bson.ObjectId("619de3845cff5e229f2ddc66")})
if deleteErr != nil{
    return
    }
}
```
