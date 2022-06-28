---
title:       "Python Pandas使用"
subtitle:    "数据分析"
description: "Pandas使用"
date:        2020-05-27
author:      "tomtao626"
image:       ""
tags:        ["数据分析", "Pandas"]
categories:  ["PYTHON"]
---

# 数据分析介绍

> 数据分析是目前人工智能的基础，而数据分析主要就是掌握几个常见的包：numpy，pandas，matploblib，seaborn，pyechart，前两个是主要的包，必须要掌握，后三个则是进行数据可视化的包，掌握其一即可，我后面讲可视化的话主要是围绕matploblib这个包讲解，有兴趣从零基础开始学习的可以跟着笔记一起学习

# pandas

> Pandas 是 Python (opens new window)的核心数据分析支持库，提供了快速、灵活、明确的数据结构，旨在简单、直观地处理关系型、标记型数据。

# 安装numpy

# 在装有python运行环境的命令行下输入
```shell
pip install pandas
```

> 当然你也可以使用Anaconda集成环境
> + anaconda [下载链接](https://www.anaconda.com/products/individual)

# 导入numpy
```python
import pandas as pd
```

# 创建Series/DataFrame
```python
from pandas import Series
from pandas import DataFrame

# Series是一种一维的数组型对象 其中包含一个值序列(类似于numpy) 并且包含了索引
obj = Series([1,2,3,4,5])
print(obj) # 数据分为两列 第一列是索引 第二列才是值
# out
"""
    0    1
    1    2
    2    3
    3    4
    4    5
    dtype: int64
"""

# 数据类型dtype和索引index也可以自己定义
obj_float = Series([1,2,3,4,5], dtype='float')
print(obj_float)
# out
"""
    0    1.0
    1    2.0
    2    3.0
    3    4.0
    4    5.0
    dtype: float64
"""

obj2 = Series([1,2,3,4,5], index=['a','b','c','d','e'])
print(obj2)
# out
"""
    a    1
    b    2
    c    3
    d    4
    e    5
    dtype: int64
"""
# 给index更改名称
obj2.index.name = 'test666'
print(obj2)
# out
"""
    test666
    a    1
    b    2
    c    3
    d    4
    e    5
    dtype: int64
"""

# 查看索引及数值
print(obj2.index, obj.values)
# out
"""
    Index(['a', 'b', 'c', 'd', 'e'], dtype='object', name='test666') [1 2 3 4 5]
"""
# 注意：使用values取到的值数据类型是numpy数组，也就是说可以直接对取到的值进行numpy操作

# 通过索引查找数据
print(obj2['c'])
# out
"""
    3
"""

# 如果要同时通过索引查找两个及以上的数据的话，需要使用列表的方式
print(obj2[['a','c','b']])
# out 
"""
    test666
    a    1
    c    3
    b    2
    dtype: int64
"""

# 向量化运算 和numpy结合使用
print(obj2*10)
# out
"""
    test666
    a    10
    b    20
    c    30
    d    40
    e    50
    dtype: int64
"""

import numpy as np
print(np.abs(obj2.values))
# out
"""
    [1 2 3 4 5]
"""

print(np.sum(obj2.values))
# out
"""
   25 
"""
```

# 随机排列
> shape 用来表示数组的维度 (2,3)表示为2行3列的二维数组 
> dtype 用来表示数组内元素的类型

```python
import numpy as np
import pandas as pd
from pandas import Series, DataFrame
df = DataFrame({'name':['apple', 'pear', 'pig'],
                'price':[7,8,9],
                'count':[66,77,88]})
print(df)
# out
"""
        name  price  count
    0  apple      7     66
    1   pear      8     77
    2    pig      9     88
"""

# permutation 产生n-1之间的所有整数的随即排列
sampler = np.random.permutation(3)
print(sampler)
# out
"""
    [1 2 0]
"""

# 行随机排列
print(df.take(sampler))
# out
"""
        name  price  count
    1   pear      8     77
    2    pig      9     88
    0  apple      7     66
"""

# 列随机排列
print(df.take(sampler, axis=1))
# out
"""
    price  count   name
    0      7     66  apple
    1      8     77   pear
    2      9     88    pig
"""
```

# 随机采样
```python
import numpy as np
import pandas as pd
from pandas import DataFrame
df = DataFrame({'name':['apple', 'pear', 'pig'],
                'price':[7,8,9],
                'count':[66,77,88]})
# 方法一 sampler和take
sampler2 = np.random.randint(0,3,size=10)
print(sampler2)  # [2 1 1 2 1 0 1 1 0 2]

print(df.take(sampler2))
# out
"""
        name  price  count
    2    pig      9     88
    1   pear      8     77
    1   pear      8     77
    2    pig      9     88
    1   pear      8     77
    0  apple      7     66
    1   pear      8     77
    1   pear      8     77
    0  apple      7     66
    2    pig      9     88
"""

# 方法二 sample
df2 = pd.DataFrame(np.random.randn(50,4), columns=list('ABCD'))
print(df2.sample(n=3))  # n是采样的个数
# out
"""
               A         B         C         D
    1   2.344295 -1.359016  0.077512 -0.018965
    35  0.215416  0.732439  0.306199 -0.057596
    45  2.528761 -0.142958 -0.181053 -0.246390
"""
print(df2.sample(frac=0.1, replace=True))  # frac指定采样占原始数据的比例 replace=True表示有放回采样
# out
"""
               A         B         C         D
    47  0.514793 -0.550905 -0.915464  1.323008
    10  1.571969 -0.989439 -0.443757  0.215525
    33 -1.162304  0.045583  0.263035  0.027746
    35  0.215416  0.732439  0.306199 -0.057596
    40  0.609119  0.289625 -0.352280 -1.775462
"""
```

# DataFrame数据结构
> + DataFrame表示的是矩阵的数据表，DataFrame既有行索引，也有列索引。
> + DataFrame数据结构一定是字典嵌套列表
> + 键值对 键是列名 后面的列表是每一列的元素

```python
from pandas import DataFrame
data = {
    'name':['a', 'b', 'c'],
    'age':[19,20,17]
}
df = DataFrame(data)
print(df)
# out
"""
       name  age
    0    a   19
    1    b   20
    2    c   17
"""
# 列名就是键值对的键名，行索引是0，1，2
# 修改行索引 修改列索引
df = DataFrame(data, index=['x', 'y', 'z'], columns=['age', 'name'])
print(df)  # 注意 列名也可以变 但是不是真的改变 而是调换位置（顺序）
# out 
"""
        age name
    x   19    a
    y   20    b
    z   17    c
"""
# 给行列索引增加名字
df.index.name = 'ID'
df.columns.name = 'Name'
print(df)
# out
"""
    Name  age name
    ID            
    x      19    a
    y      20    b
    z      17    c
"""
# DataFrame转numpy数组
print(df.values)
# out
"""
    [[19 'a']
     [20 'b']
     [17 'c']]
"""
```

# pandas增删改查
> + Series
> + DataFrame

## 增
```python
# Series增加数据 append
from pandas import Series, DataFrame
obj = Series([1,2,3,4], index=['a', 'b', 'c', 'd'])
append_data = Series([5,6], index=['e', 'f'])
obj2 = obj.append(append_data)
print(obj2)
# out 
"""
    a    1
    b    2
    c    3
    d    4
    e    5
    f    6
    dtype: int64
"""
# DataFrame增加数据 append
data = dict(name=['tom', 'john', 'alice'], age=[30,40,10])
obj = DataFrame(data)
print(obj)
# out 
"""
        name  age
    0    tom   30
    1   john   40
    2  alice   10
"""
new_data = dict(name='k8s', age=66)
obj2 = obj.append(new_data, ignore_index=True)
print(obj2)
# out 
"""
        name  age
    0    tom   30
    1   john   40
    2  alice   10
    3    k8s   66
"""
```

## 删
```python
# Series删除数据 drop
from pandas import Series, DataFrame
obj = Series([1,2,3,4], index=['a','b','c','d'])
obj2 = obj.drop('a')
print(obj2)
# out
"""
    b    2
    c    3
    d    4
    dtype: int64
"""

# DataFrame删除数据
# 删除行
data = dict(name=['tom', 'john', 'alice'], age=[30,40,10])
obj = DataFrame(data)
print(obj)
# out
"""
        name  age
    0    tom   30
    1   john   40
    2  alice   10
"""
new_data = dict(name='k8s', age=66)
obj2 = obj.append(new_data, ignore_index=True)
print(obj2)
# out
"""
        name  age
    0    tom   30
    1   john   40
    2  alice   10
    3    k8s   66
"""
obj3 = obj2.drop(3)
print(obj3)
# out
"""
        name  age
    0    tom   30
    1   john   40
    2  alice   10
"""
# 删除列
obj3 = obj2.drop('name', axis=1)
print(obj3)
# out
"""
        age
    0   30
    1   40
    2   10
    3   66
"""
```

## 改
```python
# Series修改
from pandas import Series, DataFrame
obj = Series([1,2,3,4], index=['a','b','c','d'])
obj['a'] = 10
print(obj)
# out 
"""
    a    10
    b     2
    c     3
    d     4
    dtype: int64
"""
# DataFrame修改
data = {
    'name':['tom', 'apple', 'pear'],
    'age':[19,18,17]
}
obj = DataFrame(data)
obj2 = obj.rename(columns={'name':'Name'}, index={0:9,1:3})
print(obj2)
# out
"""
        Name  age
    9    tom   19
    3  apple   18
    2   pear   17
"""
# 修改，没办法修改表格的数据，只是修改行名列名
# 修改列的话，就直接用index索引就可以，行的0改为9，1改为3
```

## 查
```python
# 查询数据
# Series查询数据
from pandas import Series, DataFrame
obj = Series([1,2,3,4], index=['a', 'b', 'c', 'd'])
print(obj)
# out
"""
    a    1
    b    2
    c    3
    d    4
    dtype: int64
"""
print(obj['a':'c']) # 和列表切片不同 顾头顾尾
# out
"""
    a    1
    b    2
    c    3
    dtype: int64
"""
# DataFrame查询数据
data = {
    'name':['tom', 'apple', 'pear'],
    'age':[19,18,17]
}
obj = DataFrame(data)
# 查询列
print(obj['name'])
# out
"""
    0      tom
    1    apple
    2     pear
    Name: name, dtype: object
"""
print(obj[['name', 'age']])
# out
"""
        name  age
    0    tom   19
    1  apple   18
    2   pear   17
"""
# 查询行
print(obj.loc[1])
# out
"""
    name    apple
    age        18
    Name: 1, dtype: object
"""
print(obj.loc[[0,1]])
# out 
"""
        name  age
    0    tom   19
    1  apple   18
"""
```

# 线形图
> + Series
> + DataFrame

```python
# Series线型图
import numpy as np
from pandas import Series, DataFrame
import matplotlib as mlp
import matplotlib.pyplot as plt
s = Series(np.random.normal(size=10))
print(s)
s.plot() # 建立画板
plt.show() # 展示画板
```

```python
# DataFrame线型图
import numpy as np
from pandas import DataFrame
import matplotlib as mlp
import matplotlib.pyplot as plt
df = DataFrame(dict(
    normal=np.random.normal(size=100),
    possion=np.random.poisson(size=100),
    int=np.random.randint(0, 10, size=100)
))
df.plot()
plt.show()
df2 = df.cumsum()
df2.plot()
plt.show()
```







