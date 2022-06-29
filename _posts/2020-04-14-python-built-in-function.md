---
layout: mypost
title:       "Python内置函数"
subtitle:    "Python基础"
description: "内置用法"
date:        2020-04-14
author:      "Tomtao626"
image:       ""
tags:        ["Collection", "函数式编程", "生成器"]
categories:  ["PYTHON"]
---

# 如何统计一篇文章中出现频率最高的 5 个单词？ Counter 

```python
#统计单词出现的个数，使用 collections 中的 Counter 统计类
import re
from collections import Counter
f = open("../05操作类题目/filetest.txt").read()
res = re.split(r'\W+', f)
print(res)
c = Counter(res)
print(c.most_common(5)) # [('sgdg', 3), ('dsgdsgdshellogsdgdsg', 3), ('wdewfwefds', 1), ('dsghellosdgs', 1), ('sdgsgrewhellogrwgrhjfnsdg', 1)]
```

# 列表[1,2,3,4,5]，编写代码提取出大于 10 的数，最终输出 [16,25]

```python
# 使用 map() 函数输出[1,4,9,16,25]，使用列表推导式提取出大于 10 的数，最终输出 [16,25]
print([x for x in list(map(lambda x: x*x, range(1, 6))) if x > 10])
"""
    map 映射函数按规律生成列表或集合
    map 函数接收两个参数，一个函数名，一个可迭代对象，一般传入的一个列表对象，列表中的每个元素都按照传入函数的规则生成一个新的列表。
    最后的返回值是一个 map 对象。map 对象是一个可迭代对象，可以使用 for 循环取出元素
"""
# 不用map 纯列表推导式
print([x*x for x in range(1,6) if x*x > 10])

# 一个列表[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]，以该列表为基础每个数字乘以10
# 用map函数实现
print([x for x in list(map(lambda x:x*10, range(10)))]) # [0, 10, 20, 30, 40, 50, 60, 70, 80, 90]

# 不用map 纯列表推导式
print([x*10 for x in range(10)]) # [0, 10, 20, 30, 40, 50, 60, 70, 80, 90]
```

# filter 过滤函数如何使用？如何过滤奇数偶数平方根数？
> filter() 函数按照函数的规则过滤掉符合的元素，返回过滤后的新对象。
> + 函数接收两个参数，第一个为函数，第二个为序列。
> + 序列的每个元素作为参数传递给函数进行判断，然后返回 True 或 False，最后将返回 True 的元素放到新列表中。

```python
# 实例1：过滤出列表中的所有奇数
# 定义得到奇数的方法，满足条件的就返回会布尔值True
# filter中满足判断条件为True的就加入到新列表中
# 函数
def is_odd(n):
    return n%2 == 1
print(list(filter(is_odd, range(10)))) # [1, 3, 5, 7, 9]
# lambda
print(list(filter(lambda x: x%2==1, range(10)))) # [1, 3, 5, 7, 9]

# 实例2：过滤出列表中的所有偶数
# 函数
def is_even(n):
    return n%2 == 0
print(list(filter(is_even, range(10)))) # [0, 2, 4, 6, 8]
# lambda
print(list(filter(lambda x: x%2==0, range(10)))) # [0, 2, 4, 6, 8]

# 实例3：过滤出1~100中平方根是整数的数:1,4,9......81,100
import math
# 函数
def is_sqr(n):
    return math.sqrt(n) % 1 == 0
print(list(filter(is_sqr, range(1, 101)))) # [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
# lambda
print(list(filter(lambda x:(math.sqrt(x) % 1) == 0, range(1, 101)))) # [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```

```python
# sorted()排序函数 
"""
    sorted(__iterable, key, reverse)
    第一个参数__iterable代表是一个可迭代对象
    第二个参数keyda代表传入排序的规则，一般使用lambda表达式
    第三个参数reverse，默认是False，可以传入 True 代表倒序排列
"""
a = [
    {'username':'x', 'age':18},
    {'username':'y', 'age':20},
    {'username':'z', 'age':10},
]
# 按照年龄排序 reverse=True代表倒序排列
print(sorted(a, key=lambda x:x['age'], reverse=True)) # [{'username': 'y', 'age': 20}, {'username': 'x', 'age': 18}, {'username': 'z', 'age': 10}]

# 传入索引值，用于排序
students = [('john', 'A', 15), ('jane', 'B', 12), ('dave','B', 10)]
b = sorted(students,key=lambda x: x[2])
print(b) # [('dave', 'B', 10), ('jane', 'B', 12), ('john', 'A', 25)]

# bool型排序
print(sorted([True, False])) # [False, True]

# 多规则复杂排序  lambda 表达式传入的规则可以传入一个元组包含多个规则，规则中进行判断，不满足的就是 False，排在最后
s = "abC234568XYZdsf23"
# 排序规则: 小写<大写<奇数<偶数
print("".join(sorted(s, key=lambda x:(x.isdigit(), x.isupper(), x.isdigit() and int(x) % 2==0, x)))) # abdfsCXYZ33522468
"""
    原理：先比较元组的第一个值，FALSE<TRUE，如果相等就比较元组的下一个值，以此类推。
    False排在后面
    1.x.isdigit()的作用是把字母放在前边,数字放在后边.
    2.x.isdigit() and int(x) % 2 == 0的作用是保证奇数在前，偶数在后。
    3.x.isupper()的作用是在前面基础上,保证字母小写在前大写在后.
    4.最后的x表示在前面基础上,对所有类别数字或字母排序。
    同时满足上面的规则
"""

list1=[7, -8, 5, 4, 0, -2, -5]
# 要求1.正数在前负数在后 2.整数从小到大 3.负数从大到小
# 先按照正负排先后，再按照大小排先后
print(sorted(list1, key=lambda x:(x<0, abs(x))))
"""
    x<0，表示负数在后面，正数在前面
    abs(x)表示按绝对值，小的前面，大的在后面
"""

# 字典根据键从小到大排序
info = {'name': 'Gage', 'age': 25, 'sex': 'man'}
print(sorted(info.items(), key=lambda x:x[0])) # [('age', 25), ('name', 'Gage'), ('sex', 'man')]
```

# 如何对生成器类型的对象实现类似于列表切片的功能

```python
l = [1,2,3,4,5,6,7,8,9]
# 对列表l进行切片
print(l[1:3]) # [2, 3] 左闭右开

# 其实主要是考察Python标准库的itertools模快，该模块提供了操作生成器的一些方法。 对于生成器类型我们使用islice方法来实现切片的功能
from itertools import islice
# 先使用item()函数来生成迭代器
d = iter(range(1, 10))
for i in islice(d,1,3): # islice()方法第一个参数是迭代器，第二个参数是起始位置索引，第三个参数是结束位置索引 注意：不支持负数索引
    print(i)
    # 2
    # 3
# 也可以下面这样写
print([i for i in islice(d,1,3)]) # [2, 3]
```

# 生成器（Generator）
> + 生成器就是可以生成值的函数
> + 当一个函数有了yield关键字就成了生成器
> + 可以挂起执行并保存当前执行的状态

```python
def testa():
    yield 'hello'
    yield 'world'

print(type(testa()))
print(next(testa()))
print(next(testa()))
# <class 'generator'>
# hello
# hello

"""
    通过列表生成式，我们可以直接创建一个列表。但是，受到内存限制，列表容量肯定是有限的。
    而且，创建一个包含100万个元素的列表，不仅占用很大的存储空间，如果我们仅仅需要访问前面几个元素，那后面绝大多数元素占用的空间都白白浪费了。
    在Python中，这种一边循环一边计算的机制，称为生成器（Generator）
"""
# 将列表推导式[for i in range(10)]改成生成器
# 把列表生产式的中括号，改为小括号我们就实现了生产器的功能
print((for i in range(10))) # <generator object <genexpr> at 0x10d9e5890>
print([i for i in range(10)]) # [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
```

# 基于生成器实现协程
> 使用send()发送 throw抛出异常

```python
def coro():
    hello = yield 'hello'  # yield关键字在=右边作为表达式 可以被send值
    yield hello

c = coro()
print(type(c))  # generator
print(next(c))  # 'hello'
print(c.send('world'))  # 'world'
c.send(None) # next(c) 会抛出异常
```

> 协程注意点
> + 协程需要使用send(None)或者next(coroutine)来预激活(prime)才能启动
> + 在yield处协程会暂停执行
> + 单独的yield value会产出值给调方
> + 可以通过coroutine.send(value)来给协程发送值，发送的值会赋值给yield表达式左边的变量value = yield
> + 协程执行完后(没有遇到下一个yield)语句会抛出StopIteration异常

# 协程装饰器
> 避免每次都要使用send预激活它

```python
from functools import wraps
def coroutine(func): # 这样就不用每次用send(None)启动了
    """向前执行到第一个yield表达式 预激活func"""
    @wraps(func)
    def primer(*args, **kwargs): # 1
        gen = func(*args, **kwargs): # 2
        next(gen) # 3
        return gen # 4
    return primer
```

# lambda 匿名函数如何使用
> lambda表达式用于定义一个匿名函数，一般用于定义一个小型函数
> + lambda 是一个单一的参数表达式，内部没有类似 def 函数的语句

```python
# # lambda 函数实现两个数相加
add = lambda x,y:x+y
print(add(1,2)) # 3

func = lambda x: x * x - x
res = func(5)
print(res)
```

# type 和 help 函数有什么作用
> type() 函数实际上是一个类，而不是一个函数。
> + 在较早的 Python 中，type 用于创建一个动态类。
> + 但是如今 type 函数使用最多的功能，用来查看一个变量属于什么类型。

> help() 函数就是名称一样，它是是一个帮助函数，
> + 使用该函数可以查看一个函数有什么功能，该函数有的属性，以及该函数的各种信息。

# reduce()方法
> reduce() 函数会对参数序列中元素进行累积。函数将一个数据集合（链表，元组等）中的所有数据进行下列操作： 
> + 用传给 reduce 中的函数 function（有两个参数）先对集合中的第 1、2 个元素进行操作，
> + 得到的结果再与第三个数据用 function 函数运算，最后得到一个结果。

```python
"""
    在 Python3 中，reduce() 函数已经被从全局名字空间里移除了，它现在被放置在 fucntools 模块里，
    如果想要使用它，则需要通过引入 functools 模块来调用 reduce() 函数：
"""
from functools import reduce
# 求和[0,1,2,3,4]
# 函数
def add(x,y): 
    return x+y
print(reduce(add, range(5))) # 10
# lambda
print(reduce(lambda x,y:x+y, range(5))) # 10
```

# enumerate 为元素添加下标索引

```python
"""
    索引和内容构成一个元祖tuple，然后所有tuple元素组成一个元祖列表
    索引位于元祖元素第一个位置，对应索引的值位于元祖元素第二个位置
"""
numbers = ['a', 'b', 'c', 'd', 'e']
print(enumerate(numbers)) # <enumerate object at 0x10e690880>
print(list(enumerate(numbers))) # [(0, 'a'), (1, 'b'), (2, 'c'), (3, 'd'), (4, 'e')]
# 添加起始索引位置
new_numbers = list(enumerate(numbers, start=999))
print(new_numbers)  # [(999, 'a'), (1000, 'b'), (1001, 'c'), (1002, 'd'), (1003, 'e')]
```
