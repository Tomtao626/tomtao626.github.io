---
title:       "MySQL优化"
subtitle:    "数据库优化"
description: "mysql"
date:        2020-06-10
author:      "tomtao626"
image:       ""
tags:        ["MySQL", "Tips"]
categories:  ["DATABASE"]
---

## explain返回列简介

### type常用关键字
system > const > eq_ref > ref > range > index > all

+ > system 表基本只有一行，基本上狗都不用
+ > const 表最多一行数据配合，主键查询时触发较多(说白了就是按主键或是唯一键读取数据)
+ > eq_ref 读取本表中和关联表表中的每行组合成的一行，多用于联表查询，按联表的主键或唯一键读取数据，除了system和const类型外，这是最好的联接类型
+ > ref 联表查询时，返回所有的关联的数据行组合，所有有匹配索引值的行将从这张表中读取；
+ > range 只检索给定范围内的行，使用一个索引来选择行 当使用=、<>、>、>=、<、<=、IS NULL、<=>、BETWEEN或者IN操作符，用常量比较关键字列时，可以使用range；
+ > index 该联接类型同all，除了只有索引树被扫描 比all检索快 因为索引文件通常比数据文件小
+ > all 对于每个来自于先前的表的行组合,进行全表扫描
> > 实际在sql优化中，最后会达到ref/range级别

### Extra常用关键字

+ > Using index:只从索引树中获取信息，不需要回表查询(即索引覆盖，查询的数据可直接在索引中拿到)
+ > Using where:WHERE子句用于限制哪一个行匹配下一个表或发送到客户
+ > Using temporary:发生这种情况一般都是需要进行优化的。mysql需要创建一张临时表用来处理此类查询

## 触发索引实例

### 建表+创建索引

```mysql
CREATE TABLE `student`(
    `id` int(10) NOT NULL ,
    `name` varchar(20) NOT NULL,
    `age` int(10) NOT NULL ,
    `sex` int(11) DEFAULT NULL ,
    `address` varchar(25) DEFAULT NULL ,
    `phone` varchar(25) DEFAULT NULL ,
    `create_time` timestamp NULL DEFAULT NULL ,
    `update_time` timestamp NULL DEFAULT NULL,
    `deleted` int(10) DEFAULT NULL ,
    PRIMARY KEY (`id`),
    KEY `student_union_index` ('name', `age`, `sex`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

### 使用主键查询