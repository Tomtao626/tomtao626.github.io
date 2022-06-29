---
layout: mypost
title:       "Python Numpy使用"
subtitle:    "数据分析"
description: "Numpy使用"
date:        2020-05-26
author:      "Tomtao626"
image:       ""
tags:        ["数据分析", "Numpy"]
categories:  ["PYTHON"]
---

# 数据分析介绍

> 数据分析是目前人工智能的基础，而数据分析主要就是掌握几个常见的包：numpy，pandas，matploblib，seaborn，pyechart，前两个是主要的包，必须要掌握，后三个则是进行数据可视化的包，掌握其一即可，我后面讲可视化的话主要是围绕matploblib这个包讲解，有兴趣从零基础开始学习的可以跟着笔记一起学习

# Numpy

> NumPy库是Python中用于科学计算的核心库。它提供了一个高性能的多维数组对象，以及用于处理这些数组的工具。

# 安装numpy

# 在装有python运行环境的命令行下输入
```shell
pip install numpy
```

> 当然你也可以使用Anaconda集成环境
> + anaconda [下载链接](https://www.anaconda.com/products/individual)

# 导入numpy
```python
import numpy as np
```

# 创建array
```python
# 创建一维数组
import numpy as np
a = np.array([1,2,3])
# out
"""[1,2,3]"""

# 创建二维数组
a = np.array([[1,2,3],[4,5,6]])
# out
"""
    [[1,2,3],
    [4,5,6]]
"""
```

# array属性 shape/dtype
> shape 用来表示数组的维度 (2,3)表示为2行3列的二维数组 
> dtype 用来表示数组内元素的类型

```python
import numpy as np
a = np.array([[1,2,3],[4,5,6]])
print(a.dtype)
# out
"""int32"""
print(a.shape)
# out
"""(2,5)"""
```

# 等差数列
```python
import numpy as np
np.array([1,2,3])
np.linspace(2,10,8) # 起始、终止（包含）、样本个数
# 生成指定范围内的数据 起始、终止（不包含）、步长
np.arange(1,7,3)
data2 = [[1,2,3,4,5],[0,9,8,7,6]]
print(data2)  # [[1, 2, 3, 4, 5], [0, 9, 8, 7, 6]]
np.array(data2)
data2=[[7,8,9],[4,5,6],[1,2,3]]
np.array(data2).dtype
data = [[1,2,3,4,5],[6,7,8,9,0]]
np.array(data)
a = np.array(data);print(a.shape)
np.array(data, dtype=float)
np.array(data).shape
np.array([1,2,3]).shape
np.zeros(4) # 生成元素全为0的一维数组
np.zeros((7,7)) # 生成元素全为0的7x7的二维数组 传入元素表示各维度大小
np.zeros((4), dtype=int) # 也可使用dtype参数指定数据类型
np.ones(2) # 创建元素全为1的一维数组
np.ones((3,4),dtype=bool)
np.empty(3) # 创建随机的垃圾数值的数组
np.empty((3,4), dtype=int) # 创建随机垃圾数值的3x4的二维数组
np.arange(4,99,3)
```

# 正方形单位矩阵
> + 不存在长方形的单位矩阵
> + 单位矩阵就是斜对角线都为1的矩阵
> + 在矩阵的乘法中，有一种矩阵起着特殊的作用，如同数的乘法中的1，这种矩阵被称为单位矩阵。 它是个方阵，从左上角到右下角的对角线（称为主对角线）上的元素均为1。除此以外全都为0。
根据单位矩阵的特点，任何矩阵与单位矩阵相乘都等于本身
```python
import numpy as np
np.eye(3) # 创建3x3的单位矩阵
np.identity(3)
np.full((3,4),9527)
# 元组传入大小 9527表示填充数值
np.eye(4,5)  # 而np.eye(4,5)是在4x4的单位矩阵的基础上，再新增元素全为0的一列
np.eye(4,2)  # np.eye(4,2)并不是生成4x2的长方形单位矩阵，而是将4x4的单位数组的前两列截取
```

# like
```python
import numpy as np
# like后缀的函数 zeros_lise/ones_like/empty_like
arrs = np.array([[1,2,3],[4,5,6],[7,8,9]])
np.zeros_like(arrs)
# zeros_like是创建和数组arrs维度相同的元素全为0的数组
np.ones_like(arrs)
# ones_like是创建和数组arrs维度相同的元素全为1的数组
np.empty_like(arrs)
# empty_like是创建和数组arrs维度相同的元素为垃圾数值的数组
np.eye(3, k=1) # 偏移主对角线一个单位的伪单位矩阵
np.full((2,3), 10) # c元组传入大小 10表示填充数值
# 也可以传入列表
np.full((2,3), [1,2,3])
```

# ndim属性
```python
# ndim属性 就是数组的维度 简单识别方法 看两侧中括号的个数
import numpy as np
arrs2 = np.array([[[1,2,3],[4,5,6]]])
print(arrs2.ndim)
```

# astype属性
```python
# astype属性 转换数组的数据类型
"""
    int32—>float64 ok
    float64->int32  会将小数部分截断
    string->float64 如果字符串全部是数字，也可以使用astype转化为数值类型
"""
import numpy as np
one_arr = np.ones(3)
one_arr.astype('int32')
# 请注意使用astype强制更改数据类型，是生成一个新的数组；
# 而在np.array()中使用dtype强制更改数据类型，则是在原数组中修改，没有生成新数组
```

# size属性
> size属性 数组元素的个数

# itemsize属性
> itemsize属性  创建的数组里面单个元素所占用的字节个数 

# 数据精度问题
> + 当前one_arr这个数组的数据类型为float64 我们将其更改为int32
`one_arr32 = one_arr.astype('int32')`
> + 请注意如果原数组中有浮点型的数据，转换成整形数据之后，会将小数点后数截断，并不会四舍五入。
`one_arr32.dtype`
`one_arr32.itemsize`
> + 这里为什么itemsize输出是4，原因是 one_arr32的dtype是int32，而int32占用的是4个字节 int16是两个字节，int64就是8个字节
> + 当然dtype参数在创建数组时，是可以定义的，其对应的itemsize值也会发合适呢个变化。
```python
import numpy as np
arr_int64 = np.array([[1,2,3],[4,5,6]], dtype='int64')
print(arr_int64.dtype)
print(arr_int64.itemsize)  # int64就是8个字节
```

# ndim参数
> + ndmin参数 用来指定数组的维度的最小个数 即左右两侧中括号的个数
> + 如果ndmin的值是1或者2的话，它的值就不会增加，因为后面的数代表最小的质，
> + 如果你定义的质小于这个，它才会自己增加维度，
> + 如果你定义的数字大于或者等于你原有的，原来的质就不会改变

```python
import numpy as np
data = [[1,2,3],[4,5,6]]
arr_ndmin = np.array(data, dtype='int64', ndmin=5)
print(arr_ndmin)
```

# 数组变换
```python
import numpy as np
# 数组重塑reshape、ravel、flatten
data = [[1,2,3], [4,5,6]]
arr = np.array(data)
print(arr)
print(arr.shape)
# (2,3)就是两行三列的二维数组 现在将其重塑
arr.reshape(3,2) # 传入元组 表示数组维度 
# 注意 重塑前后的数组行列数的乘积必须相同 2x3=3x2
arr.ravel() # 降维打击 N维数组转换为一维数组
arr.flatten() # 和ravel作用一致 降维打击 N维数组转换为一维数组
```

# 数组合并
```python
import numpy as np
arr1 = np.array([[1,2,3,4],[5,6,7,8]])
arr2 = np.array([[2,3,4,5],[6,7,8,9]])
arr3 = np.concatenate([arr1,arr2], axis=0)
arr4 = np.concatenate([arr1,arr2], axis=1)
# concatenate有两个参数，第一个参数是将要合并的数组放在一个列表内，
# 第二个参数axis是轴，0表示纵向合并，1表示横向合并
# 使用vstack和hstack也可以实现类似功能
# vstack相当于axis=0
# hstack相当于axis=1
np.vstack((arr1,arr2))
np.hstack((arr1,arr2))
```

# 数组拆分
```python
import numpy as np
arr_data = np.arange(12).reshape((6,2)) # 使用range创建0-11的数组 再使用reshape重塑成六行两列的数组
print(arr_data)
# 使用split进行数组拆分
np.split(arr_data, 3, axis=0)
np.split(arr_data, 2, axis=1)
# split的参数：切分的数组，要切分几块(必须能被整除才能切分)，切分方式（0-水平切，1-垂直切）
```

# 数组转置
```python
# n*m ----> m*n
import numpy as np
# 数组的变形和合并
z_arr = np.arange(16).reshape((2,8))
print(z_arr.shape)

# 如果是二维数组的话 可直接使用数组名.T
z_arr2 = z_arr.T
print(z_arr2.shape)

# 二维及以上的数组转置
# transponse 参数是一个元组，元组内放维度的次序
z_arr.transpose(0,1) # 8*2

z_arr.transpose(1,0) # 2*8

# 三维起步转置
z_arr = np.arange(12).reshape((2,2,3))
print(z_arr)

z_arr.swapaxes(2,1) 
#2轴放在0轴的位置上，1轴不变，0轴就自动放在了最后面2轴的位置
#注意：awapaxes里面直接放数字，不需要放元组
```

# 随机数函数
```python
import numpy as np
np.random.rand(2,3)  # 均匀分布rand 在相同长度的间隔的分布概率是相同的
np.random.randint(1,5, (2,6))  
# 创建1-10范围之间的两行六列的整数
# 给定范围随机整数 传第三个参数  第一个给定范围的最小值 第二个是给定范围的最大值  第三个是形状

# 正态分布 randn 正态曲线呈钟形 两头低 中间高 左右对称因其曲线呈钟形 也称钟形曲线
np.random.randn(2,3) # 高斯分布

# 随机数种子 seed 
"""
seed( ) 用于指定随机数生成时所用算法开始的整数值。 
1.如果使用相同的seed( )值，则每次生成的随即数都相同； 
2.如果不设置这个值，则系统根据时间来自己选择这个值，生成自己的种子，此时每次生成的随机数因时间差异而不同。 
3.设置的seed()值仅一次有效
"""
for i in range(5):
    np.random.seed(28)
    print(np.random.random())

# 乱序排列 permutation（乱序 不改变原数组）
arr = np.arange(1,20)
print(arr)

arr2 = np.random.permutation(arr)
print(arr2)

# 乱序shuffle 改变原数组
import numpy as np
arr1 = np.arange(1,20)
np.random.shuffle(arr1)
print(arr1)

# 给定参数的随机数 
# 给定参数均匀分布uniform
np.random.uniform(1,10,(2,3))

# 给定参数正态分布 normal
np.random.normal(0,1,(2,3))  # 0是均值（加起来和是0） 1是标准差 最大和最小值相差

# 给定参数 泊松分布 poisson
# 第一个参数是发生概率 0代表未发生 非0代表发生 第二个参数两行三列
np.random.poisson(0, (2,3))
np.random.poisson(1,(2,3))

# 从给定的列表中 一定概率和方式抽取结果 当不指定概率时为均匀采样 默认抽取方式为有放回抽取
import numpy as np
my_list = ['a','b','c','d']
print(np.random.choice(my_list, 2, replace=False, p=[0.1,0.7,0.1,0.1]))
print(np.random.choice(my_list, (3,3)))
# 当抽取的结果与原列表相同时，不放回抽样等价于使用permutation函数，即打散原列表
print(np.random.permutation(my_list))
# 随机数种子 可以固定随机数的输出结果
np.random.seed(0)
print(np.random.rand())
np.random.seed(0)
print(np.random.rand())
```



# 数组索引和切片
```python
# 一维数组和列表差不多
import numpy as np
arr = np.arange(12)
print(arr)
print(arr[1:5])

# 多维数组取出质的值 二维数组有两个质 先取单个元素 再取出质的元素
arr = np.arange(12).reshape(3,4)
print(arr)
print(arr[2][1]) # 取第三行第2个元素
# 多维数组的索引都是从内向外的

# 索引和切片都是作用在原数组上 原数组被改变
arr[1][1] = 9527
print(arr)

# copy函数可以复制一个新的数组 如果不想全复制 可以按照切片的方式取一部分复制
arr2 = arr.copy()
print(arr2)
arr3 = arr[1].copy()
print(arr3)
```


# 花式索引
```python
import numpy as np
x_index = np.array(['apple', 'banana', 'apple', 'pear'])
print(x_index)

arr = np.random.randint(-1,1,(4,4))
print(arr)
print(arr[x_index=='apple'])
print(arr[[0,2]])
```


# 元素级运算
```python
# 先将python中列表和numpy数组对比下
# 实现对数组中的每一个元素进行乘10的操作
# python列表(list)实现
a = [1,2,3]
a = [i*10 for i in a]
print(a)

# numpy数组实现
import numpy as np
arr = np.array([1,2,3])
print(arr*10)

"""
二者区别
    numpy数组会直接放到c语言层面执行 大大加快了执行速度
    numpy还可以直接乘/加/减 直接作用在每个元素上
"""
print(arr*arr)
print(arr-arr)
print(arr+arr)
print(arr/arr)
```




# 通用函数
```python
import numpy as np
arr = np.random.randn(3,3)  # 正态分布取随机数
arr2 = np.random.randn(3,3)
print(arr)
print(arr2)

# abs 绝对值函数
print(np.abs(arr))
# square 平方函数
print(np.square(arr))
# floor 向下取整
print(np.floor(arr))
# ceil 向上取整
print(np.ceil(arr))
# add 加操作
print(np.add(arr, arr2))
# mod 减操作
print(np.mod(arr, arr2))
# modf 整数与小数分离
print(np.modf(arr))
# minimum 矩阵比较 取较小的
print(np.minimum(arr, arr2))
# maximum 矩阵比较 取较大的
print(np.maximum(arr, arr2))
# min 取出数组中最小的数
print(np.min(arr))
# max 取出数组中最大的数
print(np.max(arr))
# 矩阵转置 T
array = np.zeros((2,3))
print(array)
print(array.T)
```

# 条件逻辑运算
```python
import numpy as np
arr1 = np.array([1,2,3,4,5,7])
arr2 = np.array([6,7,8,9,4,3])
arr3 = np.array([True, False, True, False, True, False])
# 当arr3的值为True时，取出arr1中的数字
print(arr1[arr3==True])
# 当arr3的值为False时，取出arr2中的数字
print(arr2[arr3==False])
# 将结果合并
print(np.concatenate([arr1[arr3==True], arr2[arr3==False]]))

# where 类似python中的 if-else
# where实现上面的操作
print(np.where(arr3, arr1, arr2))
# where 内有三个参数 第一个参数是条件 第二个参数是满足第一个参数要如何改变 第三个参数是不满足第一个参数要如何改变
# 创建一个三行三列的正态分布数组 把数组中大于0的数改为1 小于0的改为0
arr4 = np.random.randn(3,3)
print(arr4)
print(np.where(arr4>0, 1, 0))

# where嵌套
# 嵌套where实现大于0改为，小于但不小于-1改为0，小于-1改为-1
print(np.where(arr4>0, 1, np.where(arr4<-1, -1, 0)))

# 创建一个三行三列的数组，大于0改为True，小于0改为False
arr5 = np.random.randn(3,3)
print(np.where(arr5>0, True, False))
```

# 统计学运算
```python
import numpy as np
arr1 = np.random.randint(1,4,(3,3))
print(arr1)

# mean 平均值
print(np.mean(arr1))
print(arr1.mean())

# sum 求和
print(np.sum(arr1))
print(arr1.sum())

# std 标准差
print(np.std(arr1))
print(arr1.std())

# var 方差
print(np.var(arr1))
print(arr1.var())

# argmin 最小元素索引
print(np.argmin(arr1))
print(arr1.argmin())
# argmax 最大元素索引
print(np.argmax(arr1))
print(arr1.argmax())
# cumsum 元素累计和
print(np.cumsum(arr1))
print(arr1.cumsum())
# cumprod 元素累计积
print(np.cumprod(arr1))
print(arr1.cumprod())
# 上面这些函数都可以加入每个数组的质 0-横向 1-纵向
print(np.mean(arr1, axis=0))
print(arr1.mean(axis=0))
# 按行累加
print(np.cumsum(arr1, axis=0))
print(arr1.cumsum(axis=0))
# 按列累加
print(np.cumsum(arr1, axis=1))
print(arr1.cumsum(axis=1))
```

# 矩阵运算
```python
import numpy as np
arr1 = np.random.randint(1,4,(2,2))
arr2 = np.random.randint(1,4,(2,2))
print(f"arr1:{arr1}")
print(f"arr2:{arr2}")
print("-"*20)
# * 乘
print(arr1*arr2)
# / 除
print(arr1/arr2)
# + 加
print(arr1+arr2)
# - 减
print(arr1-arr2)
# dot . 点乘 就是行乘列相加
print(arr1.dot(arr2))
print("--*--"*20)
"""
    例如有A,B两个矩阵
    A = [[1 2]
         [3 7]]
    
    B = [[2 4]
         [5 6]]
    
    A·B = [[7 20]
           [25 30]]
    即：
    第一个数12的算法是: 1*2+2*5=12
    第二个数16的算法是: 1*4+2*6=16
    第三个数41的算法是: 3*2+7*5=41
    第四个数54的算法是: 3*4+7*6=54
    
    B·A = [[14 32]
           [23 52]]
    即：
    第一个数14的算法是: 2*1+4*3=14
    第二个数32的算法是: 2*2+4*7=32
    第三个数23的算法是: 5*1+6*3=23
    第四个数52的算法是: 5*2+6*7=52
"""

A = np.array([[1,2],[3,7]])
B = np.array([[2,4],[5,6]])
print(f"A:{A}")
print(f"B:{B}")
print(A.dot(B))
print(np.dot(A,B))
print("--*--"*20)
print(B.dot(A))
print(np.dot(B,A))
```

# 图片处理
```python
# 负片处理
from PIL import Image
import numpy as np

# img = Image.open('img.png')
# print(img)

img1 = np.array(Image.open('img.png'))
print(img1)
print(img1.shape, img1.dtype)
# img2 = np.ones(shape=(669, 1048, 3))*255 - img
img2 = np.ones_like(img1)*255-img1
Image.fromarray(img2.astype('uint8')).save('img_one.png')
print("图片转换完成")
```
