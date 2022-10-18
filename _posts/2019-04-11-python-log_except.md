---
layout: mypost
title: Python-异常/日志处理
categories: [Python]
---

## 异常处理

```python
# try 中使用 sys.exit(2) 会被捕获,无法退出脚本,可使用 os._exit(2) 退出脚本
class ShortInputException(Exception):  # 继承Exception异常的类,定义自己的异常
    def __init__(self, length, atleast):
        Exception.__init__(self)
        self.length = length
        self.atleast = atleast
    try:
        s = raw_input('Enter something --> ')
        if len(s) < 3:
            raise ShortInputException(len(s), 3)    # 触发异常
    except EOFError:
        print('\nWhy did you do an EOF on me?')
    except ShortInputException, x:      # 捕捉指定错误信息
        print('ShortInputException:  %d | %d' % (x.length, x.atleast))
    except Exception as err:            # 捕捉所有其它错误信息内容
        print(str(err))
    #except urllib2.HTTPError as err:   # 捕捉外部导入模块的错误
    #except:                            # 捕捉所有其它错误 不会看到错误内容
    #        print('except')
    finally:                            # 无论什么情况都会执行 关闭文件或断开连接等
        print('finally')
    else:                               # 无任何异常 无法和finally同用
        print('No exception was raised.')
```

## 不可捕获的异常

```python
NameError:              # 尝试访问一个未申明的变量
ZeroDivisionError:      # 除数为零
SyntaxErrot:            # 解释器语法错误
IndexError:             # 请求的索引元素超出序列范围
KeyError:               # 请求一个不存在的字典关键字
IOError:                # 输入/输出错误
AttributeError:         # 尝试访问未知的对象属性
ImportError             # 没有模块
IndentationError        # 语法缩进错误
KeyboardInterrupt       # ctrl+C
SyntaxError             # 代码语法错误
ValueError              # 值错误
TypeError               # 传入对象类型与要求不符合
```

## 内建异常

```python
BaseException                # 所有异常的基类
SystemExit                   # python解释器请求退出
KeyboardInterrupt            # 用户中断执行
Exception                    # 常规错误的基类
StopIteration                # 迭代器没有更多的值
GeneratorExit                # 生成器发生异常来通知退出
StandardError                # 所有的内建标准异常的基类
ArithmeticError              # 所有数值计算错误的基类
FloatingPointError           # 浮点计算错误
OverflowError                # 数值运算超出最大限制
AssertionError               # 断言语句失败
AttributeError               # 对象没有这个属性
EOFError                     # 没有内建输入,到达EOF标记
EnvironmentError             # 操作系统错误的基类
IOError                      # 输入/输出操作失败
OSError                      # 操作系统错误
WindowsError                 # windows系统调用失败
ImportError                  # 导入模块/对象失败
KeyboardInterrupt            # 用户中断执行(通常是ctrl+c)
LookupError                  # 无效数据查询的基类
IndexError                   # 序列中没有此索引(index)
KeyError                     # 映射中没有这个键
MemoryError                  # 内存溢出错误(对于python解释器不是致命的)
NameError                    # 未声明/初始化对象(没有属性)
UnboundLocalError            # 访问未初始化的本地变量
ReferenceError               # 若引用试图访问已经垃圾回收了的对象
RuntimeError                 # 一般的运行时错误
NotImplementedError          # 尚未实现的方法
SyntaxError                  # python语法错误
IndentationError             # 缩进错误
TabError                     # tab和空格混用
SystemError                  # 一般的解释器系统错误
TypeError                    # 对类型无效的操作
ValueError                   # 传入无效的参数
UnicodeError                 # Unicode相关的错误
UnicodeDecodeError           # Unicode解码时的错误
UnicodeEncodeError           # Unicode编码时的错误
UnicodeTranslateError        # Unicode转换时错误
Warning                      # 警告的基类
DeprecationWarning           # 关于被弃用的特征的警告
FutureWarning                # 关于构造将来语义会有改变的警告
OverflowWarning              # 旧的关于自动提升为长整形的警告
PendingDeprecationWarning    # 关于特性将会被废弃的警告
RuntimeWarning               # 可疑的运行时行为的警告
SyntaxWarning                # 可疑的语法的警告
UserWarning                  # 用户代码生成的警告
```

## 触发异常

```python
raise exclass            # 触发异常,从exclass生成一个实例(不含任何异常参数)
raise exclass()          # 触发异常,但现在不是类;通过函数调用操作符(function calloperator:"()")作用于类名生成一个新的exclass实例,同样也没有异常参数
raise exclass, args      # 触发异常,但同时提供的异常参数args,可以是一个参数也可以是元组
raise exclass(args)      # 触发异常,同上
raise exclass, args, tb  # 触发异常,但提供一个跟踪记录(traceback)对象tb供使用
raise exclass,instance   # 通过实例触发异常(通常是exclass的实例)
raise instance           # 通过实例触发异常;异常类型是实例的类型:等价于raise instance.__class__, instance
raise string             # 触发字符串异常
raise string, srgs       # 触发字符串异常,但触发伴随着args
raise string,args,tb     # 触发字符串异常,但提供一个跟踪记录(traceback)对象tb供使用
raise                    # 重新触发前一个异常,如果之前没有异常,触发TypeError
```

## 跟踪异常栈

```python
# traceback 获取异常相关数据都是通过sys.exc_info()函数得到的
import traceback
import sys
try:
    s = raw_input()
    print(int(s))
except ValueError:
    # sys.exc_info() 返回值是元组，第一个exc_type是异常的对象类型，exc_value是异常的值，exc_tb是一个traceback对象，对象中包含出错的行数、位置等数据
    exc_type, exc_value, exc_tb = sys.exc_info()
    print("\n%s \n %s \n %s\n" %(exc_type, exc_value, exc_tb ))
    traceback.print_exc()        # 打印栈跟踪信息
```

## 抓取全部错误信息存如字典

```python
import sys, traceback

try:
    s = raw_input()
    int(s)
except:
    exc_type, exc_value, exc_traceback = sys.exc_info()
    traceback_details = {
                         'filename': exc_traceback.tb_frame.f_code.co_filename,
                         'lineno'  : exc_traceback.tb_lineno,
                         'name'    : exc_traceback.tb_frame.f_code.co_name,
                         'type'    : exc_type.__name__,
                         'message' : exc_value.message,
                        }

    del(exc_type, exc_value, exc_traceback)
    print(traceback_details)
    f = file('test1.txt', 'a')
    f.write("%s %s %s %s %s\n" %(traceback_details['filename'],traceback_details['lineno'],traceback_details['name'],traceback_details['type'],traceback_details['message'], ))
    f.flush()
    f.close()
```

## 调试log

```python
# cgitb覆盖了默认sys.excepthook全局异常拦截器
def func(a, b):
    return a / b
if __name__ == '__main__':
    import cgitb
    cgitb.enable(format='text')
    func(1, 0)
```
