---
layout: mypost
title:       "Python文件操作"
subtitle:    "Python基础"
description: "文件操作"
date:        2020-04-08
author:      "Tomtao626"
image:       ""
tags:        ["OS", "Glob", "Shutil", "Zipfile"]
categories:  ["PYTHON"]
---

# x="abc",y="def",z=["d","e","f"]，分别求出 x.join(y) 和 x.join(z) 返回的结果
```python
#join()括号里面的是可迭代对象，x插入可迭代对象中间，形成字符串，结果一致
x="abc"
y="def"
z=["d","e","f"]
a=x.join(y)
b=x.join(z)
c = a.join("9527")
d = b.join({"test1":1,"k8s":a})
print(a) # dabceabcf
print(b) # dabceabcf
print(c) # 9dabceabcf5dabceabcf2dabceabcf7
print(d) # test1dabceabcfk8s
```

# 输出目录下所有文件及文件夹
## 获取当前python程序的运行路径
```python
import os
print(os.getcwd())  # /bin/python3.8 /Users/macos/Documents/workspaces/pywork/Python_Interview_Note/subject/05操作类题目
```

## 自动拼接文件路径
```python
import os
os.path.join("My Project", "Dream")
print("c:\\" + os.path.join("My Project", "Dream"))  ## c:\My Project/Dream
```

## 输出目录下所有文件及文件夹
```python
import os
# 列出当前程序文件夹下的所有文件和文件夹
print(os.listdir("/Users/macos/Documents/workspaces"))
# 列出当前程序文件夹下的所有文件和文件夹 返回一个迭代器
for i in os.scandir("/Users/macos/Documents/workspaces"):
    print(i)
```

# 遍历、搜索文件及查询文件信息
## 找出文件夹里的文件夹里的“文件”或“文件夹
```python
# os.walk(路径)：传入一个路径，帮助我们将文件夹里的文件夹里的文件夹里的文件都找出来。
import os
for dirpath, dirname, files in os.walk("/Users/macos/Documents/workspaces"):
    print(f"发现文件夹\t{dirpath}")
    print(dirname)
    print(files)
```

## 搜索、匹配文件名称及文件信息查看
```python
# startswith()和endswith()
# 字符串A.startswith（字符串B）：字符串A是否以字符串B开头；
# 字符串A.endswith（字符串B）：字符串A是否以字符串B结尾；
"abc.txt".startswith("abc")
"abc.txt".endswith(".txt")
list1 = ["a.txt","b.py","c.xlsx","d.txt","e.txt"]
for item in list1:
    if item.endswith(".txt"):
        print(item)
```

```python
# glob模块
# 采取类似于“正则”的方式，进行文件匹配
import glob
for i in glob.glob("*.txt"):
    print(i)
for i in glob.glob("a*.txt"):
    print(i)
for i in glob.glob("a?.txt"):
    print(i)
for i in glob.glob("a??.txt"):
    print(i)
# 特别的：glob()方法中还有一个参数recursive = True，能够将所有深层文件夹里面，符合条件的文件给你找出来。
# 注意：一个*和两个*的区别
glob.glob("*/*.txt",recursive=True)
glob.glob("**/*.txt",recursive=True)
```

```python
# os.scandir()返回的文件都可以利用stat()方法，进行查看
import os
for file in os.scandir():
    print(file.name,file.stat(),"\n")

import time
for file in os.scandir():
    print(file.name,file.stat().st_size,time.ctime(file.stat().st_ctime),"\n")
```

# 批量创建、复制、移动、删除、重命名文件及文件夹
## 创建文件夹
```python
import os
os.mkdir("新文件夹名称") #创建单层文件夹；
os.makedirs("第一层/第二层/第三层") #创建多层文件夹；
list1=[f"文件夹{i}" for i in range(5)]
for i in list1:
    os.mkdir(i)
```
问题：当某个文件夹已经存在的时候，运行此代码，会报错。此时可以添加一个判断条件
```python
import os
(os.path.exists("新文件夹名称"))
if not os.path.exists("傻逼"):
    os.mkdir("傻逼")
```

## 复制文件及文件夹(shutil模块儿)
> + shutil.copy("要复制的文件", "要复制到的位置")：复制文件；
> + shutil.copytree("要复制的文件夹", "要复制到的新文件夹的位置")：复制文件夹；
> + shutil.copytree("要复制的文件夹", "要复制到的新文件夹的位置")；
> + 注意：将某个文件夹移动到另外一个文件夹(该文件夹必须是新文件夹)，不能是已经存在了的文件夹；

```python
# 复制文件
import shutil
#将aba.txt复制一份到project文件夹中。
shutil.copy("aba.txt","./project")
#将aba.txt复制一份到project文件夹中，并重新命名为“新名字.txt”。
shutil.copy("aba.txt","./project/新名字.txt")
# 复制文件夹
import shutil
shutil.copytree("project","./qq")

```

## 移动文件或文件夹
> + shutil.move("要移动的文件或文件夹","要移动到的位置")：移动文件/文件夹；
> + 文件夹或者文件被移动后，原始文件就没有了；
> + shutil.move("要移动的文件夹","要移动到的位置")

```python
# 复制文件
import shutil
#将aba.txt移动到“傻逼”文件夹下
shutil.move("aba.txt","./傻逼/")
##将test.txt移动到“傻逼”文件夹下，并重新命名为test1.txt
shutil.move("test.txt","./傻逼/test1.txt")
# 复制文件夹
import shutil
#将“第一层”文件夹移动到“傻逼”文件夹下
shutil.move("第一层","./傻逼/")
#将“qq”文件夹移动到“傻逼”文件夹下，并重新命名为“哈哈”文件夹
shutil.move("qq","./傻逼/哈哈")
```

# 重命名文件或文件夹
> + os.rename("文件/文件夹","新文件名/新文件夹名")

```python
import os
#将test1.xlsx重命名为“my.xlsx”
os.rename("test1.xlsx","my.xlsx")
#将“傻逼”文件夹重命名为“傻子”文件夹
os.rename("傻逼","傻子")

```

# 删除文件或文件夹
## 删除文件
> + os.remove("要删除的文件")
> + 注意：这里说的只是删除文件，而不能是文件夹；

```python
import os
#删除“my.xlsx”文件
os.remove("my.xlsx")
```

## 删除文件夹
> + shutil.rmtree("要删除的文件夹")

```python
import shutil
#删除“文件夹0”这个文件夹
shutil.rmtree("文件夹0")
```

# 创建和解压压缩包
## 读取压缩包里的文件

```python
import zipfile

with zipfile.ZipFile("python办公自动化.zip","r") as zipobj:
    print(zipobj.namelist())
#注意：有时候需要写成filename.encode("cp437").decode("gbk")
with zipfile.ZipFile("python办公自动化.zip","r") as zipobj:
    for filename in zipobj.namelist():
        print(filename.encode("gbk").decode("gbk"))

```

## 读取压缩包里面的文件信息

```python
import zipfile

with zipfile.ZipFile(r"G:\tableau书籍\Tableau文件.zip","r") as zipobj:
    for filename in zipobj.namelist():
    info=zipobj.getinfo(filename)
    new_filename=filename.encode("cp437").decode("gbk")
    print(new_filename,info.file_size/1024/1024,info.compress_size/1024/1024)

```

## 解压压缩包
> + extract("压缩包内要解压的文件名","解压到哪个位置")：将压缩包内单个文件解压出来；
> + extractall("解压到哪个位置")：将压缩包内所有文件解压出来；

```python
# 解压单个文件
import zipfile
#将该压缩包中的“a.txt”文件，单独解压到“傻子”文件夹下
with zipfile.ZipFile(r"G:\6Tipdm\7python办公自动化\python办公自动化.zip","r") as zipobj:
    zipobj.extract("a.txt","./傻子/")

# 解压整个文件
import zipfile
#将该压缩包整个解压到“文件夹1”文件夹下
with zipfile.ZipFile(r"G:\6Tipdm\7python办公自动化\python办公自动化.zip","r") as zipobj:
    zipobj.extractall("./文件夹1/")
# 注意：如果你的压缩包中“有密码”，则可以指定pwd参数进行解压。
# 如
zipobj.extractall(path="./文件夹1/", pwd=b'nmslnmsl')
```

## 创建压缩包

```python
# 对某些文件，创建压缩包
import zipfile
file_list=["a.txt","aa.txt","文件夹1"]
#将上述三个文件，进行打包，使用“w”
with zipfile.ZipFile(r"我创建的压缩包.zip","w") as zipobj:
    for file in file_list:
        zipobj.write(file)

# 压缩包已经存在，往其中添加文件
#往上述压缩包中，再次添加一个新文件“傻子”文件夹，使用“a”
with zip file.ZipFile(r"我创建的压缩包.zip","a") as zipobj:
    for file in file_list:
        zipobj.write("傻子")
```