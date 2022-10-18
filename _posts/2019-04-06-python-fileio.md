---
layout: mypost
title: Python-文件IO
categories: [Python, I/O]
---

## 文件处理

## 写文件

```python
# 模式: 读'r'  写[清空整个文件]'w' 追加[文件需要存在]'a' 读写'r+' 二进制文件'b'  'rb','
i={'ddd':'ccc'}
f = file('poem.txt', 'a')
f.write("string")
f.write(str(i))
f.flush()
f.close()
```

## 读文件

```python
f = file('/etc/passwd','r')
c = f.read().strip()        # 读取为一个大字符串，并去掉最后一个换行符
for i in c.split('\n'):     # 用换行符切割字符串得到列表循环每行
    print(i)
f.close()
```

## 读文件1

```python
f = file('/etc/passwd','r')
while True:
    line = f.readline()    # 返回一行
    if len(line) == 0:
        break
    x = line.split(":")                  # 冒号分割定义序列
    #x = [ x for x in line.split(":") ]  # 冒号分割定义序列
    #x = [ x.split("/") for x in line.split(":") ]  # 先冒号分
    print(x[6],"\n")
f.close()
```

## 读文件2

```python
f = file('/etc/passwd')
c = f.readlines()       # 读入所有文件内容,可反复读取,大文件时占用内存较大
for line in c:
    print(line.rstrip())
f.close()
```

## 读文件3

```python
for i in open('b.txt'):   # 直接读取也可迭代,并有利于大文件读取,但不可反复读取
    print(i)
```

## 追加日志

```python
log = open('/home/peterli/xuesong','a')
print(>> log,'faaa')
log.close()
```

## with读文件
```python
# 自动关闭文件、线程锁的自动获取和释放等
with open('a.txt') as f:
for i in f:
    print(i)
    print(f.read())        # 打印所有内容为字符串
    print(f.readlines())   # 打印所有内容按行分割的列表
```

## 文件随机读写

```python
# 文件本没有换行,一切都是字符,文件也没有插入功能
f.tell()       # 当前读写位置
f.read(5)      # 读取5个字符并改变指针
f.seek(5)      # 改变用户态读写指针偏移位置,可做随机写
f.seek(p,0)    # 移动当文件第p个字节处，绝对位置
f.seek(p,1)    # 移动到相对于当前位置之后的p个字节
f.seek(p,2)    # 移动到相对文件尾之后的p个字节
f.seek(0,2)    # 指针指到尾部
# 改变指针超出文件尾部,会造成文件洞,ll看占用较大，但du -sh却非常小
f.read(65535)  # 读取64K字节
f.write("str") # 写会覆盖当前指针后的响应字符,无插入功能
```
