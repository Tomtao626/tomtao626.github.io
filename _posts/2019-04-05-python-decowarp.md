---
layout: mypost
title: Python-装饰器
categories: [Python]
---

## 装饰器

```python
# 为已存在的功能添加额外的功能,只在初始化脚本的时候执行一次
#!/usr/bin/env python
def deco(func):
def wrapper(*args, **kwargs):
print("Wrap start")
func(*args, **kwargs)
func(*args, **kwargs)
print("Wrap end\n")
return wrapper

@deco
def foo(x):
    print("In foo():")
    print("I have a para: %s" % x)
@deco
def foo_dict(x,z='dict_para'):
    print("In foo_dict:")
    print("I have two para, %s and %s" % (x, z))

if __name__ == "__main__":
    # 装饰器 @deco  等价于 foo = deco(foo)
    foo('x')
    foo_dict('x', z='dict_para')
```

```python
# 结果
# 
# Wrap start
# In foo():
# I have a para: x
# In foo():
# I have a para: x
# Wrap end
# 
# Wrap start
# In foo_dict:
# I have two para, x and dict_para
# In foo_dict:
# I have two para, x and dict_para
# Wrap end
```

