---
layout: mypost
title: Python-函数式编程
categories: [Python]
---

## 函数式编程的内建函数

```python
apply(func[,nkw][,kw])          # 用可选的参数来调用func,nkw为非关键字参数,kw为关键字参数;返回值是函数调用的返回值
filter(func,seq)                # 调用一个布尔函数func来迭代遍历每个seq中的元素;返回一个使func返回值为true的元素的序列
map(func,seq1[,seq2])           # 将函数func作用于给定序列(s)的每个元素,并用一个列表来提供返回值;如果func为None,func表现为一个身份函数,返回一个含有每个序列中元素集合的n个元组的列表
reduce(func,seq[,init])         # 将二元函数作用于seq序列的元素,每次携带一堆(先前的结果以及下一个序列元素),连续地将现有的结果和下一个值作用在获得的随后的结果上,最后减少我们的序列为一个单一的返回值;如果初始值init给定,第一个比较会是init和第一个序列元素而不是序列的头两个元素
lambda x,y:x+y                  # 创建一个匿名函数 可用于上面几种方法中直接创建匿名函数式
# filter 即通过函数方法只保留结果为真的值组成列表
def f(x): return x % 2 != 0 and x % 3 != 0
f(3)     # 函数结果是False  3被filter抛弃
f(5)     # 函数结果是True   5被加入filter最后的列表结果
filter(f, range(2, 25))
[5, 7, 11, 13, 17, 19, 23]
# map 通过函数对列表进行处理得到新的列表
def cube(x): return x*x*x
map(cube, range(1, 11))
[1, 8, 27, 64, 125, 216, 343, 512, 729, 1000]
# reduce 通过函数会先接收初始值和序列的第一个元素，然后是返回值和下一个元素，依此类推
def add(x,y): return x+y
reduce(add, range(1, 11))              # 结果55  是1到10的和  x的值是上一次函数返回的结果，y是列表中循环的值
reduce(lambda x,y:x+y, range(1,11))    # 等同上面两条  lambda来创建匿名函数[ lambda x,y:x+y ] ,后面跟可迭代的对象
```

## 编码转换

```python
a='中文'                    # 编码未定义按输入终端utf8或gbk
u=u'中文'                   # 定义为unicode编码  u值为 u'\u4e2d\u6587'
u.encode('utf8')            # 转为utf8格式 u值为 '\xe4\xb8\xad\xe6\x96\x87'
print(u)                    # 结果显示 中文
print(u.encode('utf8'))     # 转为utf8格式,当显示终端编码为utf8  结果显示 中文  编码不一致则乱码
print(u.encode('gbk'))      # 当前终端为utf8 故乱码
ord('4')                    # 字符转ASCII码
chr(52)                     # ASCII码转字符

# 设置读取编码为utf8 避免转换出错

#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')
```

## 遍历递归

```python
[os.path.join(x[0],y) for x in os.walk('/root/python/5') for y in x[2]]
for i in os.walk('/root/python/5/work/server'):
    print(i)
```
