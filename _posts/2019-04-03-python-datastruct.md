---
layout: mypost
title: Python-数据类型
categories: [Python]
---

## 列表

```python
# 列表元素的个数最多 536870912
shoplist = ['apple', 'mango', 'carrot', 'banana']
shoplist[2] = 'aa'
del shoplist[0]
shoplist.insert(4,'www')
shoplist.append('aaa')
shoplist[::-1]    # 倒着打印 对字符翻转串有效
shoplist[2::3]    # 从第二个开始每隔三个打印
shoplist[:-1]     # 排除最后一个
'\t'.join(li)     # 将列表转字符串 用字表符分割
sys.path[1:1]=[5] # 在位置1前面插入列表中一个值
list(set(['qwe', 'as', '123', '123']))   # 将列表通过集合去重复
eval("['1','a']")                        # 将字符串当表达式求值,得到列表

# enumerate 可得到每个值的对应位置
for i, n in enumerate(['a','b','c']):
print(i,n)
```

## 元组

```python
# 不可变
zoo = ('wolf', 'elephant', 'penguin')
```

字典

```python
ab = {       'Swaroop'   : 'swaroopch@byteofpython.info',
'Larry'     : 'larry@wall.org',
}
ab['c'] = 80      # 添加字典元素
del ab['Larry']   # 删除字典元素
ab.keys()         # 查看所有键值
ab.values()       # 打印所有值
ab.has_key('a')   # 查看键值是否存在
ab.items()        # 返回整个字典列表

# 复制字典
a = {1: {1: 2, 3: 4}}
b = a
b[1][1] = 8888                # a和b都为 {1: {1: 8888, 3: 4}}
import copy
c = copy.deepcopy(a)          # 再次赋值 b[1][1] = 9999 拷贝字典为新的字典,互不干扰

a[2] = copy.deepcopy(a[1])    # 复制出第二个key，互不影响  {1: {1: 2, 3: 4},2: {1: 2, 3: 4}}
```

## 迭代器

```python
# 创建迭代接口，而不是原来的对象 支持字符串、列表和字典等序列对象
i = iter('abcd')
print(i.next())

s = {'one':1,'two':2,'three':3}
m = iter(s)
print(m.next())                     # 迭代key
```
