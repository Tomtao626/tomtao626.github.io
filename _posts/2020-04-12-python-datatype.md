---
layout: mypost
title:       "Python数据类型"
subtitle:    "Python基础"
description: "数据结构和类型"
date:        2020-04-12
author:      "Tomtao626"
image:       ""
tags:        ["数据结构", "正则", "Tips"]
categories:  ["PYTHON"]
---


# Python 中的可变和不可变数据类型（基于地址而言）
> + 可变类型：当变量的值更改，那么变量对应的内存地址不会更改， 对象的 id 值不变；
> + 不可变类型：当变量的值更改，那么变量对应的内存地址也会更改，对象的 id 值会变化；
> + python中的数据类型主要有 整型 字符串 元祖 集合 列表 字典

```python
#可以通过id()函数查看变量的地址
# 整型
a = 1
print(id(a), type(a)) # 4457200368 <class 'int'>
a = 2
print(id(a), type(a)) # 4457200400 <class 'int'>
# 你会发现整型变量a值发生了更改，地址也发生了变化，所以整型是不可变数据类型

# 字符串
b = "tomato"
print(id(b), type(b)) # 4473099632 <class 'str'>
b = "9527"
print(id(b), type(b)) # 4473101296 <class 'str'>
# 字符串变量b值发生了更改，地址也发生了变化，所以字符串是不可变数据类型

# 元祖 也称作可读列表 值不能被修改 但是我们可以在元组的元素中存放一个列表，通过更改列表的值来查看元组是属于可变还是不可变
c1 = ['1','2']
c = (1,2,c1)
print(c,id(c),type(c))  # (1, 2, ['1', '2']) 4395721024 <class 'tuple'>
c1[1] = 'tom'
print(c,id(c),type(c))  # (1, 2, ['1', 'tom']) 4395721024 <class 'tuple'>
# 虽然元组数据发生改变，但是内存地址没有发生了改变，但是不可以以此来判定元组就是可变数据类型。回头仔细想想元组的定义就是不可变的。
# 修改了元组中列表的值，但是因为列表是可变数据类型，所以虽然在列表中更改了值，但是列表的地址没有改变，列表在元组中的地址的值没有改变，所以也就意味着元组没有发生变化。
# 可以认为元组是不可变数据类型，因为元组是不可变的。

# 集合 常用来进行去重和关系运算，集合是无序的。
d = {1, '9527', 2, 3, 4, 'a', 'b'}
print(d, id(d), type(d)) # {1, 2, 3, 4, 'a', '9527', 'b'} 4377626656 <class 'set'>
d.add('tomato')
print(d, id(d), type(d)) # {1, 2, 3, 4, 'a', '9527', 'b', 'tomato'} 4377626656 <class 'set'>
# 集合d虽然值发生了更改，但地址没有变化，所以集合是可变数据类型

# 列表
e_list = [1,2,'a', 'b', 9527]
print(e_list, id(e_list), type(e_list)) # [1, 2, 'a', 'b', 9527] 4345474112 <class 'list'>
e_list.append('6666')
print(e_list, id(e_list), type(e_list)) # [1, 2, 'a', 'b', 9527, '6666'] 4345474112 <class 'list'>
# 列表e_list虽然值发生了更改，但地址没有变化，所以列表是可变数据类型

# 字典 字典是python中唯一的映射类型，采用键值对（key-value）的形式存储数据。
# python对key进行哈希函数运算，根据计算的结果决定value的存储地址，所以字典是无序存储的。但是在3.6版本后，字典开始是有序的，这是新的版本特征。
# 字典的key值可以是整型，字符串，元组，但是不可以是列表，集合，字典。
f_dict = {'a':'test1', 'b':'test2'}
print(f_dict, id(f_dict), type(f_dict)) # {'a': 'test1', 'b': 'test2'} 4337296256 <class 'dict'>
f_dict.update(dict(test5=(1,2,)))
print(f_dict, id(f_dict), type(f_dict)) # {'a': 'test1', 'b': 'test2', 'test5': (1, 2)} 4337296256 <class 'dict'>
# 字典f_dict虽然值发生了更改，但地址没有变化，所以字典是可变数据类型
"""
    数据类型	可变/不可变
     整型	   不可变
     字符串	   不可变
     元组	   不可变
     列表	   可变
     集合	   可变
     字典	   可变
     可变数据类型即公用一个内存空间地址，不可变数据类型即每产生一个对象就会产生一个内存地址
"""
```

> + 不可变对象不允许对自身内容进行修改。如果我们对一个不可变对象进行赋值，实际上是生成一个新对象，再让变量指向这个对象。
> + 可变对象则可以对自身内容进行修改, 虽然对象的值发生了变化，但是地址没变，还是原来那个对象。
> + 可变对象于不可变对象本身的不同仅在于一个可以修改变量的值，而另一个不允许
> + 基于这一设定，两者在功能上的最大区别就是：不可变对象可以作为字典 dict 的键 key，而可变对象不行。
> + 另外，明白了可变与不可变的区别，一些方法的效果也就自然理解了：

```python
s = 'abc'
s2 = s.replace('b', 'd')
print('s', s)
print('s2', s2)
m = [1, 2, 3]
m2 = m.reverse()
print('m', m)
print('m2', m2)
# 打印结果
# s abc
# s2 adc
# m [3, 2, 1]
# m2 None
```

> + 因为 str 是不可变对象，所以它的方法如 replace、strip、upper 都不可能修改原对象，只会返回一个新对象，比如重新赋值才可以。
> + 而 list 是可变对象，它的方法如 reverse、sort、append，都是在原有对象上直接修改，无返回值。
> + 不过，有个特殊情况需要注意：

```python
m = [1, 2, 3]
print('m', m, id(m))
m += [4]
print('m', m, id(m))
m = m + [5]
print('m', m, id(m))
# 打印结果
# m [1, 2, 3] 4477456576
# m [1, 2, 3, 4] 4477456576
# m [1, 2, 3, 4, 5] 4477456832
```

> + m = m + 和 m += 虽然是一样的结果，但 m 指向的对象却发生了变化。
> + 原因在于，前者是做了赋值操作，而后者其实是调用的 __iadd__ 方法。
> + 如果我们就是需要产生一个 list 对象的副本，可以通过 [:]：

```python
m = [1, 2, 3]
print('m', m, id(m))
n = m[:]
print('n', n, id(n))
n[1] = 4
print('m', m)
print('n', n)
# 打印结果
# m [1, 2, 3] 4532969728
# n [1, 2, 3] 4532969664
# m [1, 2, 3]
# n [1, 4, 3]
```

> + 这样对 n 的修改便不再会影响到 m，因为它们已不是同一个对象。
> + 请写出下面代码的输出结果
```python
m = [1, 2, [3]]
n = m[:]
n[1] = 4
n[2][0] = 5
print(f"m={m}")
print(f"n={n}")
# 打印结果
# m=[1, 2, [5]]
# n=[1, 4, [5]]
```

> + 不可变类型：改变了存储单元内容的对象不再被认为是原对象。
> + 可变类型：改变了存储单元内容的对象仍然被认为是原对象。

# is 和 == 有什么区别？
    is:是调用id()函数 比较两个id值是否相等，是否指向同一个内存地址，如果id相等，就是同一个实例对象
    ==:是调用eq()函数 比较两个对象的值，值相等就返回True，但是id不一定相等

# python大小写转换和字母统计
```python
# 每个单词首字母大写 title()
a = "tomato abc"
print(a.title())  # Tomato Abc

# 句子第一个字母大写 capitalize()
print(a.capitalize()) # Tomato abc

# 所有字母大写小写：upper()、lower()
# upper() 小写字母转大写
b = "totmTaoHxTYt66"
print(b.upper()) # TOMTAOHXY66
# lower() 大写字母转小写
print(b.lower()) # tomtaohxy66

# 统计某个字母出现的次数：count('t') 注意：区分大小写
print(b.count('t')) # 3
print(b.count('T')) # 2
```

# 字符串，列表，元组如何反转；反转函数 `reverse` 和 `reversed` 的区别
```python
# 列表反转 可迭代对象（实现__iter__即可）
# reverse和reversed都是列表反转的一个方法，前者返回一个反转后的列表，后者返回反转的迭代器对象，只要是可迭代对象，都可以调用reversed()
# 反转后的迭代器可使用for循环或者调用next方法取出元素
x = [1,2,3,4,5]
x.reverse()
print(x) # [5, 4, 3, 2, 1]

# reversed: reversed()的作用之后，返回的是一个把序列值经过反转之后的迭代器，
ls2 = [4, 5, 6]
print(reversed(ls2)) # 迭代器对象的内存地址 <list_reverseiterator object at 0x0003545427A5454682E8>
print(list(reversed(ls2))) # [6, 5, 4]

# 字符串反转方法1
str1 = 'abced12345'
str2 = ''.join(reversed(str1)) # 使用join拼接反转后的字符
print(str2) # 'abced12345'

# 字符串反转方法2
str3 = str1[::-1]
print(str3) # 54321decba
```

# 含有多种符号的字符串分割方法？
```python
# 1 使用 []+，中括号里面写上所有的符号，后面的 + 表示可以出现多次，类似于正则表达式
import re
a = "ab;cd%e\tfg,,jklioha;hp,vrww\tyz"
_a = re.split(r'[;%\t,]+', a)
print(_a) # ['ab', 'cd', 'e', 'fg', 'jklioha', 'hp', 'vrww', 'yz']

b = "info：tomato 33 test;666"
_b = re.split(r'：|;| ', b)
print(_b) # ['info', 'tomato', '33', 'test', '666']
# 2 使用|表示或
```

# 嵌套列表转换为列表，字符串转换为列表
```python
# 嵌套列表转换为列表
ls = [[1,2,3], [4,5,6],[7,8,9]]
ls2 = [j for i in ls for j in i]
print(ls2) # [1, 2, 3, 4, 5, 6, 7, 8, 9]

# 字符串转换为列表
a = 'a,b,c,1,2,3,4,x,y,z'
ls3 = a.split(',')
print(ls3) # ['a', 'b', 'c', '1', '2', '3', '4', 'x', 'y', 'z']
```

# 列表合并的常用方法
```python
# extend扩展合并
a = [1,2,3]
b = ['a', 'b', 'c']
a.extend(b)
print(a) # [1, 2, 3, 'a', 'b', 'c']
# 列表相加
print(a+b) # [1, 2, 3, 'a', 'b', 'c']
# for循环遍历 append
for i in a:
    b.append(i)
print(b) # [1, 2, 3, 'a', 'b', 'c']
```

# 列表如何去除重复的元素

```python
# 不改变原有顺序
# set集合和sorted
ls_one = [1, 2, 5, 3, 8, 5, 2, 10, 9]
def sort_list_index(ls_one: list) -> list:
    ls_one_new = sorted(set(ls_one), key=ls_one.index)
    return ls_one_new
print(sort_list_index(ls_one))  # [1, 2, 5, 3, 8, 10, 9]

# for循环+新列表
ls_new = list()
# for i in ls_one:
#     if i not in ls_new:
#         ls_new.append(i)
ls_one = [i for i in ls_one if i not in ls_new]
print(sort_list_index(ls_one))  # [1, 2, 5, 3, 8, 10, 9]

# keys()方法
form_list = list({}.fromkeys(ls_one).keys())
print(form_list) # [1, 2, 5, 3, 8, 10, 9]

# 改变原有顺序
# set集合
print(list(set(ls_one))) # [1, 2, 3, 5, 8, 9, 10]

# itertools.grouby
import itertools
ls_one.sort()
ls_two = list()
ls_it = itertools.groupby(ls_one)
print([k for k,_ in ls_it]) # # [1, 2, 3, 5, 8, 9, 10]
```

# 列表数据如何筛选，筛选出符合要求的数据
```python
# 生成一个人随机数组成的列表
import random
data = [random.randint(-10, 100) for _ in range(10)]
print(data) # [-1, 10, -2, 3, 4, 1, 9, -5, -10, 2]
# for 循环，筛选出符合条件的数据，添加到一个空列表中
new_data = list()
for i in data:
    if i > 0:
        new_data.append(i)
print(new_data) # [10, 3, 4, 1, 9, 2]
# 过滤函数 filter 配合匿名函数 lambda 表达式
result = list(filter(lambda x: x > 0, data))
print(result) # [10, 3, 4, 1, 9, 2]
# 列表解析（推荐使用，效率最高）
data = [i for i in data if i > 0]
print(data) # [10, 3, 4, 1, 9, 2]
```

# 字典中元素的如何排序
```python
# sorted()排序 
# 字典根据键从小到大排序
info = {'name': 'Gage', 'age': 25, 'sex': 'man'}
print(sorted(info.items(), key=lambda x:x[0])) # [('age', 25), ('name', 'Gage'), ('sex', 'man')]
```

# 字典如何合并;字典解包是啥
```python
# 字典如何合并:a.update(b)
a = {"name":"test", "age":9527}
b = {"sex":True, "weight":"188kg"}
a.update(b)
print(a) # {'name': 'test', 'age': 9527, 'sex': True, 'weight': '188kg'}

# 字典解包:{**a,**b} 也就是合并
print({**a}) # {'name': 'test', 'age': 9527}
print({**a, **b}) # {'name': 'test', 'age': 9527, 'sex': True, 'weight': '188kg'}

# 合并下面两个字典 c = {"A":1,"B":2}, d = {"C":3,"D":4}
c = {"A":1,"B":2},
d = {"C":3,"D":4}
print({**c, **d})
```

# 字典推导式使用方法;字典推导式如何格式化cookie值
```python
# 字典推导式使用方法 和列表生成式使用方法一致 
# 字典键值交换
a = {"name":"test", "age":9527}
print(a.items()) # dict_items([('name', 'test'), ('age', 9527)])
print(a.values()) # dict_values(['test', 9527])
# 方法1 字典推导式
print({v:k for k,v in a.items()})  # {'test': 'name', 9527: 'age'}
# 方法2 zip()+dict()
print(dict(zip(a.values(),a.keys()))) # {'test': 'name', 9527: 'age'}

# 字典推导式如何格式化cookie值
cookie = "show_id=100126;username=\u968f\u52a9\u6d4b\u8bd5-Tom2222;email=751825253@qq.com;role_code=admin;job=\u7ba1\u7406\u5458;department=test;parent_id=1;app_ver=1.2.0;status=true;mobile=18372620761;phone=+86-13073670883;gender=1;qq=1;wechat=1;remark=111;add_time=1596203920;upd_time=1619862585"
#将cookie格式化成一个字典 先根据;将其分割成一个list，再根据=分隔出key和vale
cookie = {i.split("=")[0]:i.split("=")[1] for i in cookie.split(";")}
print(cookie)  # {'show_id': '100126', 'username': 'Tom2222', 'email': '751825253@qq.com', 'role_code': 'admin', 'job': '666', 'department': 'test', 'parent_id': '1', 'app_ver': '1.2.0', 'status': 'true', 'mobile': '18372620761', 'phone': '86-13073670883', 'gender': '1', 'qq': '1', 'wechat': '1', 'remark': '111', 'add_time': '1596203920', 'upd_time': '1619862585'}
```

# `zip` 打包函数的使用？元组或者列表中元素生成字典？
```python
# zip打包函数的使用 zip()函数传入一个可迭代对象，然后元素一一对应组成一个元祖，然后将所有元祖打包成一个列表
# zip 方法在 Python 2 和 Python 3 中的不同：在 Python 3 中为了减少内存，zip() 返回的是一个对象。如需展示列表，需手动 list() 转换。
a = [1,2,3]
b = ['a', 'b', 'c']
ls = zip(a, b)
print(ls) # <zip object at 0x101d780c0>
print(list(ls)) # 在 Python 3 中为了减少内存，zip() 返回的是一个对象。如需展示列表，需手动 list() 转换。

# 元组或者列表中元素生成字典
print(dict(list(ls)))  # {1: 'a', 2: 'b', 3: 'c'}
# 示例
l = ['a', 'b', 'c', 'd', 'e','f']
l1 = list(zip(l[:-1],l[1:]))
print(l1) # [('a', 'b'), ('b', 'c'), ('c', 'd'), ('d', 'e'), ('e', 'f')]
print(dict(l1)) # {'a': 'b', 'b': 'c', 'c': 'd', 'd': 'e', 'e': 'f'}

# 把元组 ("a","b") 和元组 (1,2)，变为字典 {"a"：1,"b"：2}
tuple_c = ("a","b",)
tuple_d = (1,2,)
print(dict(zip(tuple_c, tuple_d))) # {'a': 1, 'b': 2}
```

# 字典的键可以是哪些类型的数据？
    字典的键是可以被hash的，可以被hash的对象就是不可变数据，不可变数据可以作为字典的键，比如数字、字符串、元组都可以
    列表、集合、字典是可变类型不是可hash对象，所以不能用列表做为字典的键

# 变量的作用域
    在 Python 中，定义一个变量，该变量的作用域是该变量被赋值时候所处的位置决定的
    当一个变量在函数内部被定义和赋值，该变量就是一个局部变量，在函数外部使用就会出现错误
    函数变量作用域的搜索顺序：
        1.本地作用域（Local）、
        2.当前作用域被嵌入的本地作用域（Enclosing locals）、
        3.全局/模块作用域（Global）、
        4.内置作用域（Built-in）

# 获取字符串”123456“最后的两个字符。
```python
s = "98755tomtao42"
# 获取最后三位
print(s[-3::]) # o42
```

# 一个编码为 GBK 的字符串 S，要将其转成 UTF-8 编码的字符串，应如何操作？
```python
s = "shenmeguiya"
gbk_s = s.encode("gbk") # b'shenmeguiya'
gbk_s.decode("utf-8", 'ignore') # 'shenmeguiya'
```

# 给定两个 list，A 和 B，找出相同元素和不同元素
```python
A = [1,2,3,'a','x']
B = ['a',2,'b','zz']
print(f"A和B相同元素(交集)是{set(A)&set(B)}") # A和B相同元素(交集)是{2, 'a'}
print(f"A和B不同元素(差集)是{set(A)^set(B)}") # A和B不同元素(差集)是{'zz', 1, 3, 'x', 'b'}
```

# 打乱列表的元素
```python
import random
l = [1,2,3,'a','x',9527,'z','中国']
random.shuffle(l)
print(l) # [2, 9527, '中国', 'a', 3, 'x', 'z', 1]
```

# 字典操作中del和pop的区别
```python
"""
    del是根据字典内元素索引位置删除，没有返回值
    pop是根据索引弹出一个值，然后接受其返回值
"""
a = {'name':'tom', 'age':18, 'sex':'male', 'grade':9527}
print(a.pop('name')) # tom # 弹出字典a中key为name的元素 并返回其弹出值
del a['age'] # 删除字典a中key为age的元素
print(a) # {'name': 'tom', 'sex': 'male', 'grade': 9527}
```

# a="hello" 和 b="你好" 编码成 bytes 类型
```python
a = "hello"
b = "你好"
print(b"hello")  # b'hello'
print(bytes(b, 'utf-8'))  # b'\xe4\xbd\xa0\xe5\xa5\xbd'
print(b.encode("utf-8"))
```

# 元祖不支持修改,但是元祖内的元素本身是可变数据类型,那么就支持修改
```python
a = (1,2,3,[4,5,6,7],8)
# a[2] = 2 # 会出现异常 TypeError: 'tuple' object does not support item assignment 因为元祖不支持修改
print(list(a)) # [1, 2, 3, [4, 5, 6, 7], 8] 元祖转数组
print(tuple(list(a)))  # (1, 2, 3, [4, 5, 6, 7], 8) 数组转元祖

# 下面的代码输出的结果是什么?
a = (1,2,3,[4,5,6,7],8)
a[3][0] = 2
print(a) # (1, 2, 3, [2, 5, 6, 7], 8)
# 如果元组里面元素本身就是可变数据类型，比如列表，那么在操作这个元素里的对象时，其内存地址也是不变的。
# a[3] 对应的元素是列表，然后对列表第一个元素赋值，所以最后的结果是： (1,2,3,[2,5,6,7],8)
```

# 如何生成一个 16 位的随机字符串

```python
import random
import string
print(''.join(random.choice(string.printable) for i in range(16))) # a0TN_)QA6PFVeiHK
```

# python 中生成随机整数、随机小数、0--1 之间小数方法
```python
import random
# 随机整数
print(random.randint(1,10)) # 7
# 随机小数
print(random.random()) # 0.021827474121851265
# 0--1 之间小数方法
print(random.uniform(0,1)) # 0.12594292005935803
```

# <div class="nam">Python</div>，用正则匹配出标签里面的内容（“Python”），其中 class 的类名是不确定的。
```python
import re
s = '<div class="nam">中国</div>'
print(re.findall(r'<div class=".*">(.*?)</div>', s)) # ['中国']
```

# `dict` 中 `fromkeys` 的用法
```python
key = ('info',)
print(dict.fromkeys(key, ['a',1,'9527'])) # {'info': ['a', 1, '9527']}
```

# 正则表达式输出汉字
```python
import re
s = '"not 404 found 中>国 2018 hwhdjs=-+? 我爱你"'
r = '[a-zA-Z0-9’!"#$%&\'()*+,-./:;<=>?@，。?★、…【】《》？“”‘’！[\\]^_`{|}~]+\s?'
print(re.sub(r, '', s)) # 中国 我爱你
```

# s = "ajldjlajfdljfddd"，去重并从小到大排序输出"adfjl"？
```python
s = "ajldjlajfdljfddd"
print(set(s)) # {'j', 'f', 'l', 'd', 'a'}
print(sorted(s)) # ['a', 'a', 'd', 'd', 'd', 'd', 'd', 'f', 'f', 'j', 'j', 'j', 'j', 'l', 'l', 'l']
print(sorted(set(s))) # ['a', 'd', 'f', 'j', 'l']
print(''.join(sorted(set(s))))
```

# Python 获取当前日期
```python
import time
import datetime
print(datetime.datetime.now()) # 2021-12-02 14:48:09.273591
print(time.strftime("%Y-%m-%d %H:%M:%s")) # 2021-12-02 14:48:09
```

# 获取请求头的参数
```python
from urllib.parse import urlparse, parse_qs
s = "/get_feed_list?version_name=5.0.9.0&device_id=12242&channel_name=google"
def splitvalue(value):
    url = {'site':urlparse(value).path}
    url.update(parse_qs(urlparse(value).query))
    return url

print(splitvalue(s))  # {'site': '/get_feed_list', 'version_name': ['5.0.9.0'], 'device_id': ['12242'], 'channel_name': ['google']}
```

# `json` 序列化时，可以处理的数据类型有哪些？如何定制支持 `datetime` 类型？
    可以处理的数据类型是 str、int、list、tuple、dict、bool、None, 因为 datetime 类不支持 json 序列化，所以我们对它进行拓展。
```python
# 自定义时间序列化
# JSONEncoder 不知道怎么去把这个数据转换成 json 字符串的时候，它就会去调 default()函数,
# 所以都是重写这个函数来处理它本身不支持的数据类型，default()函数默#认是直接抛异常的。
import json
import datetime
class DateToJson(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, datetime.datetime): 
            return obj.strftime('%Y-%m-%d %H：%M：%S')
        elif isinstance(obj, datetime.date): 
            return obj.strftime('%Y-%m-%d')
        else: 
            return json.JSONEncoder.default(self, obj)
d = {'name':'cxa', 'data':datetime.datetime.now()}
print(json.dumps(d, cls=DateToJson)) # {"name": "cxa", "data": "2021-12-02 25\uff1a23\uff1a20"}
```