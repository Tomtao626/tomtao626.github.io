---
layout: mypost
title: Python-模块
categories: [Python]
---

## 模块

```python
# Filename: mymodule.py
def sayhi():
    print('mymodule')
version = '0.1'

# 使用模块中方法
import mymodule
from mymodule import sayhi, version
mymodule.sayhi()   # 使用模块中函数方法
```

## 模块包

```python
# 文件 ops/fileserver/__init__.py
import readers
import writers
# 每个模块的包中，都有一个 __init__.py 文件，有了这个文件，才能导入这个目录下的module，在导入一个包时 import ops.fileserver ，实际上是导入了它的 __init__.py 文件，可以再 __init__.py 文件中再导入其他的包，或者模块。就不需要将所有的import语句写在一个文件里了，也可以减少代码量，不需要一个个去导入module了。
# __init__.py 有一个重要的变量 __all__ 。有时会需要全部导入，from PackageName import *   ，这时 import 就会把注册在包 __init__.py 文件中 __all__ 列表中的子模块和子包导入到当前作用域中来。如：
__all__ = ["Module1", "Module2", "subPackage1", "subPackage2"]
```

## 执行模块类中的所有方法

```python
# moniItems.py
import sys, time
import inspect
class mon:
    def __init__(self):
        self.data = dict()
    def run(self):
        return self.runAllGet()
    def getDisk(self):
        return 222
    def getCpu(self):
        return 111
    def runAllGet(self):
        for fun in inspect.getmembers(self, predicate=inspect.ismethod):
            print(fun[0], fun[1])
            if fun[0][:3] == 'get':
                self.data[fun[0][3:]] = fun[1]()
        print(self.data)
        return self.data
# 模块导入使用
from moniItems import mon
m = mon()
m.runAllGet()
```