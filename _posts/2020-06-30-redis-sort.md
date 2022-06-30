---
layout: mypost
title: Redis实现排行榜功能
categories: [Redis, DataBase]
---

# 前言
> 在之前的开发中，经常会碰到需要对用户的分值等进行排行，此时一般会选择redis的有序集合对用户的分数进行存储，但是不同的场景排行榜的方式也略有不同，以下作一个简单总结。

# 有序集合(sorted set)
> Sorted Set（有序集合）和Set类型极为相似，它们都是字符串的集合，都不允许重复的成员出现在一个Set中。它们之间的主要差别是Sorted Set中的每一个成员都会有一个分数(score)与之关联，Redis正是通过分数来为集合中的成员进行从小到大的排序。然而需要额外指出的是，尽管Sorted Set中的成员必须是唯一的，但是分数(score)却是可以重复的。
> 在Sorted Set中添加、删除或更新一个成员都是非常快速的操作，其时间复杂度为集合中成员数量的对数。由于Sorted Set中的成员在集合中的位置是有序的，因此，即便是访问位于集合中部的成员也仍然是非常高效的。事实上，Redis所具有的这一特征在很多其它类型的数据库中是很难实现的，换句话说，在该点上要想达到和Redis同样的高效，在其它数据库中进行建模是非常困难的。

# 相关命令

> 1 <span id="zadd">`ZADD key [NX|XX] [CH] [INCR] score member [score member ...]`</span>
> + 向有序集合添加一个或多个成员，或者更新已存在成员的分数

> 2 `ZCARD key`
> + 获取有序集合的成员数

> 3	`ZCOUNT key min max`
> + 计算在有序集合中指定区间分数的成员数

> 4	`ZINCRBY key increment member`
> + 有序集合中对指定成员的分数加上增量 increment

> 5	`ZINTERSTORE destination numkeys key [key ...]`
> + 计算给定的一个或多个有序集的交集并将结果集存储在新的有序集合 destination 中

> 6	`ZLEXCOUNT key min max`
> + 在有序集合中计算指定字典区间内成员数量

> 7	`ZRANGE key start stop [WITHSCORES]`
> + 通过索引区间返回有序集合指定区间内的成员

> 8	`ZRANGEBYLEX key min max [LIMIT offset count]`
> + 通过字典区间返回有序集合的成员

> 9	`ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT]`
> + 通过分数返回有序集合指定区间内的成员

> 10 `ZRANK key member`
> + 返回有序集合中指定成员的索引

> 11 `ZREM key member [member ...]`
> + 移除有序集合中的一个或多个成员

> 12 `ZREMRANGEBYLEX key min max`
> + 移除有序集合中给定的字典区间的所有成员

> 13 `ZREMRANGEBYRANK key start stop`
> + 移除有序集合中给定的排名区间的所有成员

> 14 `ZREMRANGEBYSCORE key min max`
> + 移除有序集合中给定的分数区间的所有成员

> 15 `ZREVRANGE key start stop [WITHSCORES]`
> + 返回有序集中指定区间内的成员，通过索引，分数从高到低

> 16 `ZREVRANGEBYSCORE key max min [WITHSCORES]`
> + 返回有序集中指定分数区间内的成员，分数从高到低排序

> 17 <span id="zadd">`ZREVRANK key member`</span>
> + 返回有序集合中指定成员的排名，有序集成员按分数值递减(从大到小)排序

> 18 <span id="score">`ZSCORE key member`<span>
> + 返回有序集中，成员的分数值

> 19 `ZUNIONSTORE destination numkeys key [key ...]`
> + 计算给定的一个或多个有序集的并集，并存储在新的 key 中

> 20 `ZSCAN key cursor [MATCH pattern] [COUNT count]`
> + 迭代有序集合中的元素（包括元素成员和元素分值）

# 应用场景
## 场景1 用户得分越高 排行越靠前
> 使用[ZADD](#zadd)添加、更新成员分数
> + 如果某个 member 已经是有序集的成员，那么更新这个 member 的 score 值，并通过重新插入这个 member 元素，来保证该 member 在正确的位置上。
> + score 值可以是整数值或双精度浮点数。
> + 如果 key 不存在，则创建一个空的有序集并执行 ZADD 操作。
> + 当 key 存在但不是有序集类型时，返回一个错误。

```shell
#新增一条用户名为user1，分数为66的数据
ZADD user_rank 66 user1
#添加用户B（user2）当前游戏的分数为60、用户C（user3）当前游戏的分数为70，则可批量操作
ZADD user_rank 60 user2 71 user3
```

> 使用[ZREVRANK](#zrevrank)获取成员当前排名
> + 返回有序集合key中成员member的排名，其中有序集合成员按score值递减排序，下标默认从0开始

```shell
ZREVRANK user_rank user1 # 当前排名是第三 输出2 因为从0开始
```

> 使用[ZSCORE](#zscore)获取用户排名
> + 返回有序集 key 中，成员 member 的 score 值。
> + 如果 member 元素不是有序集 key 的成员，或 key 不存在，返回 nil 。

```shell
ZSCORE user_rank user1 # 当前分数为66 则输出66 返回值是字符串
```

## 场景2 用户游戏中花费的时间最短，排行越前面
> + 使用的命令和基本操作和场景一差不多，除了获取排名的命令不一样之外
> 使用[ZRANK](#zrank)获取成员当前排名
> + 命令参数：ZRANK key member
> + 返回有序集 key 中成员 member 的排名。其中有序集成员按 score 值递增(从小到大)顺序排列。
> + 排名以 0 为底，也就是说， score 值最小的成员排名为 0 。

```shell
ZRANK user_rank user1 # 当前排名是第三 输出0 因为从0开始 按score值递增排序 从大到小
```

# 如何处理以上两个场景中用户分数相同的情况
## 如果两个用户score相同，redis如何排序呢
> + 在score相同的情况下，redis使用字典排序
> + 而所谓的字典排序其实就是“ABCDEFG”、"123456..."这样的排序，在首字母相同的情况下，redis会再比较后面的字母，还是按照字典排序

## 场景一：用户得分越高，排行越前面，如果分数相同情况下，先达成该分数的用户排前面
> 此场景下，我们需要更改用户的分数构成，具体思路如下：
> + 分数相同，用户完成游戏的时间戳也加入到score值的构成中
> + 先达成该分数的用户排前面，即游戏所得分数相同的情况下，时间戳越小，越排前
> + 如果我们简单地把score结构由：分数+''+时间戳 拼凑，因为分数越大越靠前，而时间戳越小则越靠前，这样两部分的判断规则是相反的，无法简单把两者合成一起成为用户的score
> + 但是我们可以逆向思维，可以用同一个足够大的数MAX(如：5000000000000)减去时间戳，时间戳越小，则得到的差值越大，这样我们就可以把score的结构改为：分数+''+(MAX-时间戳)，这样就能满足我们的需求了
> + 如果使用整数作为score，有一点需要注意的是，js中最大的整数为： `Math.pow(2, 53) - 1 // 9007199254740991 ,16位数`
> + 时间戳已经占用了13位数了，因此留给我们保存用户的真正分数的只剩下3位数了
> + 所以最好使用双精度浮点数类型作为score
> + 因此，最好的score结构为：分数+'.'+时间戳，变为浮点数

## 场景二：用户完成游戏时间最短，排行越前面，如果完成游戏时间相同情况下，先达到该记录的用户排前面
> 此场景下，我们也需要更改用户的score构成，具体思路如下：
> + 完成游戏时间相同，用户完成游戏的时间戳也加入到score值的构成中
> + 游戏时间相同，先达到该记录用户排前面，即游戏所得分数相同的情况下，时间戳越小，越排前
> + 游戏时间越小越靠前，而时间戳越小也越靠前，这样两部分的判断规则是一致的，我们可以把两者合一起拼凑成score：分数+'.'+时间戳 即可
> + 则用户score越小，用户排名越前

