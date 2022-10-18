---
layout: mypost
title: Python-面向对象
categories: [Python]
---

## 类对象的方法

```python
__xxx__               # 系统定义名字
__init__              # 实例化初始化类的方法
__all__ = ['xs']      # __all__ 用于模块import导入时限制,定义了只有all内指定的属性、方法、类可被导入,没定义则模块内的所有将被导入
_xxx                  # _开头的为私有类,只有类对象和子类对象自己能访问到这些变量  不能用 from module import * 导入  class _status:
__xxx                 # __开头的为类中的私有变量名,只有类对象自己能访问,连子类对象也不能访问到这个数据

class Person:
    # 实例化初始化的方法
    def __init__(self, name ,age):
        self.name = name
        self.age = age
        print(self.name)
    # 有self此函数为方法
    def sayHi(self):
        print('Hello, my name is', self.name
    # 对象消逝的时候被调用
    def __del__(self):
        print('over')
        # 实例化对象
        p = Person('Swaroop',23)
        # 使用对象方法
        p.sayHi()
```

## 继承

```python
class Teacher(Person):
    def __init__(self, name, age, salary):
        Person.__init__(self, name, age)
        self.salary = salary
        print('(Initialized Teacher: %s)' % self.name)
    def tell(self):
        Person.tell(self)
        print('Salary: "%d"' % self.salary)
t = Teacher('Mrs. Shrividya', 40, 30000)

getattr(object,name,default)

# 返回object的名称为name的属性的属性值,如果属性name存在,则直接返回其属性值.如果属性name不存在,则触发AttribetError异常或当可选参数default定义时返回default值

class A:
    def __init__(self):
        self.name = 'zhangjing'
    def method(self):
        print("method print")

Instance = A()
print(getattr(Instance, 'name',   'not find'))          # 如果Instance 对象中有属性name则打印self.name的值，否则打印'not find'
print(getattr(Instance, 'age',    'not find'))         # 如果Instance 对象中有属性age则打印self.age的值，否则打印'not find'
print(getattr(Instance, 'method', 'default'))          # 如果有方法method，否则打印其地址，否则打印default
print(getattr(Instance, 'method', 'default')())         # 如果有方法method，运行函数并打印None否则打印default

setattr(object,name,value)

# 设置object的名称为name(type：string)的属性的属性值为value，属性name可以是已存在属性也可以是新属性。

#等同多次 self.name = name 赋值 在外部可以直接把变量和值对应关系传进去
#class Person:
#    def __init__(self, name ,age):
#        self.name = name
#        self.age = age

config = {'name':'name','age','age'}
class Configure(object):
    def __init__(self, config):
        self.register(config)

    def register(self, config):
        for key, value in config.items():
            if key.upper() == key:
                setattr(self, key, value)
```

## 元类

```python
# 实现动态curd类的或者实例中的方法属性

#!/usr/bin/env python

"""首先检查__metaclass__属性, 如果设置了此属性, 如果设置了此属性则调用对应Metaclass,
Metaclass本身也是Class 当调用时先调用自身的__new__方法新建一个Instance然后Instance调
用__init__返回一个新对象(MyClss), 然后正常执行原Class
"""

ext_attr = {
    'wzp': 'wzp',
    'test': 'test',
}

class CustomMeta(type):
    build_in_attr = ['name', ]

    def __new__(cls, class_name, bases, attributes):
        # 获取`Meta` Instance
        attr_meta = attributes.pop('Meta', None)
        if attr_meta:
            for attr in cls.build_in_attr:      # 遍历内置属性
                # 自省, 获取Meta Attributes 不是build_in_attr的属性不处理
                print("Meta:", getattr(attr_meta, attr, False))
        # 扩展属性
        attributes.update(ext_attr)
        return type.__new__(cls, class_name, bases, attributes)

    def __init__(cls, class_name, bases, attributes):
        super(CustomMeta, cls).__init__(class_name, bases, attributes)

class MyClass(object):
    __metaclass__ = CustomMeta  # metaclass
    class Meta:
        name = 'Meta attr'

if __name__ == '__main__':

    # TODO 此处返回一个类｀Instance｀对象
    print(MyClass())

    # TODO 此处返回一个类对象, 并不是｀Instance｀
    print(type("MyClass", (), {}))
```
