---
layout: mypost
title: Python-变量
categories: [Python]
---

## 查看帮助

```shell
python -c "help('modules')"     # 查看python所有模块
```

```python
import os
for i in dir(os):
    print(i)        # 模块的方法
help(os.path)       # 方法的帮助
```

## python中关键字

```python
import keyword
keyword.iskeyword(str)       # 字符串是否为python关键字
keyword.kwlist               # 返回pytho所有关键字
['and', 'as', 'assert', 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except', 'exec', 'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is', 'lambda', 'not', 'or', 'pass', 'print', 'raise', 'return', 'try', 'while', 'with', 'yield']
```

## 调试

```shell
python -m trace -t aaaaaa.py
strace -p pid       # 用系统命令跟踪系统调用
```

## 变量

```python
import os
r=r'\n'          # 输出时原型打印
u=u'中文'        # 定义为unicode编码
global x         # 全局变量
a = 0 or 2 or 1  # 布尔运算赋值,a值为True既不处理后面,a值为2.  None、字符串''、空元组()、空列表[],空字典{}、0、空字符串都是false
name = input("input:").strip()        # 输入字符串变量
num = int(input("input:").strip())    # 输入字符串str转为int型
locals()                                  # 所有局部变量组成的字典
locals().values()                         # 所有局部变量值的列表
os.popen("date -d @{0} +'%Y-%m-%d %H:%M:%S'".format(12)).read()    # 特殊情况引用变量 {0} 代表第一个参数

# 基于字典的字符串格式化
params = {"server":"mpilgrim", "database":"master", "uid":"sa", "pwd":"secret"}
"%(pwd)s" % params                                         # 'secret'
"%(pwd)s is not a good password for %(uid)s" % params      # 'secret is not a good password for sa'
"%(database)s of mind, %(database)s of body" % params      # 'master of mind, master of body'
```

## 打印

```python
# 字符串 %s  整数 %d  浮点 %f  原样打印 %r
print('字符串: %s 整数: %d 浮点: %f 原样打印: %r' % ('aa',2,1.0,'r'))
print('abc',      # 有逗号,代表不换行打印,在次打印会接着本行打印
print('%-10s %s' % ('aaa','bbb'))    # 左对齐 占10个字符
print('%10s %s' % ('aaa','bbb'))     # 右对齐 占10个字符
```
