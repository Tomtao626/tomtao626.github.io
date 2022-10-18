---
layout: mypost
title: Python-逻辑结构
categories: [Python]
---

## if判断

```python
# 布尔值操作符 and or not 实现多重判断
    if a == b:
        print('==')
    elif a < b:
        print(b)
    else:
        print(a)
```

## while循环

```python
while True:
        if a == b:
            print("==")
            break
        print("!=")
    else:
        print('over')

    count=0
    while(count<9):
        print(count)
        count += 1
```

## for循环

```python
sorted()           # 返回一个序列(列表)
zip()              # 返回一个序列(列表)
enumerate()        # 返回循环列表序列 for i,v in enumerate(['a','b']):
reversed()         # 反序迭代器对象
dict.iterkeys()    # 通过键迭代
dict.itervalues()  # 通过值迭代
dict.iteritems()   # 通过键-值对迭代
readline()         # 文件迭代
iter(obj)          # 得到obj迭代器 检查obj是不是一个序列
iter(a,b)          # 重复调用a,直到迭代器的下一个值等于b
for i in range(1, 5):
    print(i)
else:
    print('over')

list = ['a','b','c','b']
for i in range(len(list)):
    print(list[i])
for x, Lee in enumerate(list):
    print("%d %s Lee" % (x+1,Lee))

# enumerate 使用函数得到索引值和对应值
for i, v in enumerate(['tic', 'tac', 'toe']):
    print(i, v))
```

## 流程结构简写

```python
[ i * 2 for i in [8,-2,5]]
[16,-4,10]
[ i for i in range(8) if i %2 == 0 ]
[0,2,4,6]
```
    