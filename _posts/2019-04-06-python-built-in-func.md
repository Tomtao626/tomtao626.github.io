---
layout: mypost
title: Python-内建函数
categories: [Python]
---

## 内建函数

```python
dir(sys)            # 显示对象的属性
help(sys)           # 交互式帮助
int(obj)            # 转型为整形
str(obj)            # 转为字符串
len(obj)            # 返回对象或序列长度
open(file,mode)     # 打开文件 #mode (r 读,w 写, a追加)
range(0,3)          # 返回一个整形列表
raw_input("str:")   # 等待用户输入
type(obj)           # 返回对象类型
abs(-22)            # 绝对值
random              # 随机数
choice()            # 随机返回给定序列的一个元素
divmod(x,y)         # 函数完成除法运算，返回商和余数。
round(x[,n])        # 函数返回浮点数x的四舍五入值，如给出n值，则代表舍入到小数点后的位数
strip()             # 是去掉字符串两端多于空格,该句是去除序列中的所有字串两端多余的空格
del                 # 删除列表里面的数据
cmp(x,y)            # 比较两个对象    #根据比较结果返回一个整数，如果x<y，则返回-1；如果x>y，则返回1,如果x==y则返回0
max()               # 字符串中最大的字符
min()               # 字符串中最小的字符
sorted()            # 对序列排序
reversed()          # 对序列倒序
enumerate()         # 返回索引位置和对应的值
sum()               # 总和
list()              # 变成列表可用于迭代
eval('3+4')         # 将字符串当表达式求值 得到7
exec 'a=100'        # 将字符串按python语句执行
exec(a+'=new')      # 将变量a的值作为新的变量
tuple()             # 变成元组可用于迭代   #一旦初始化便不能更改的数据结构,速度比list快
zip(s,t)            # 返回一个合并后的列表  s = ['11','22']  t = ['aa','bb']  [('11', 'aa'), ('22', 'bb')]
isinstance(object,int)    # 测试对象类型 int
xrange([lower,]stop[,step])            # 函数与range()类似，但xrnage()并不创建列表，而是返回一个xrange对象
```

## 列表类型内建函数

```python
list.append(obj)                 # 向列表中添加一个对象obj
list.count(obj)                  # 返回一个对象obj在列表中出现的次数
list.extend(seq)                 # 把序列seq的内容添加到列表中
list.index(obj,i=0,j=len(list))  # 返回list[k] == obj 的k值,并且k的范围在i<=k<j;否则异常
list.insert(index.obj)           # 在索引量为index的位置插入对象obj
list.pop(index=-1)               # 删除并返回指定位置的对象,默认是最后一个对象
list.remove(obj)                 # 从列表中删除对象obj
list.reverse()                   # 原地翻转列表
list.sort(func=None,key=None,reverse=False)  # 以指定的方式排序列表中成员,如果func和key参数指定,则按照指定的方式比较各个元素,如果reverse标志被置为True,则列表以反序排列
```

## 序列类型操作符

```python
seq[ind]              # 获取下标为ind的元素
seq[ind1:ind2]        # 获得下标从ind1到ind2的元素集合
seq * expr            # 序列重复expr次
seq1 + seq2           # 连接seq1和seq2
obj in seq            # 判断obj元素是否包含在seq中
obj not in seq        # 判断obj元素是否不包含在seq中
```

## 字符串类型内建方法

```python
string.expandtabs(tabsize=8)                  # tab符号转为空格 #默认8个空格
string.endswith(obj,beg=0,end=len(staring))   # 检测字符串是否已obj结束,如果是返回True #如果beg或end指定检测范围是否已obj结束
string.count(str,beg=0,end=len(string))       # 检测str在string里出现次数  f.count('\n',0,len(f)) 判断文件行数
string.find(str,beg=0,end=len(string))        # 检测str是否包含在string中
string.index(str,beg=0,end=len(string))       # 检测str不在string中,会报异常
string.isalnum()                              # 如果string至少有一个字符并且所有字符都是字母或数字则返回True
string.isalpha()                              # 如果string至少有一个字符并且所有字符都是字母则返回True
string.isnumeric()                            # 如果string只包含数字字符,则返回True
string.isspace()                              # 如果string包含空格则返回True
string.isupper()                              # 字符串都是大写返回True
string.islower()                              # 字符串都是小写返回True
string.lower()                                # 转换字符串中所有大写为小写
string.upper()                                # 转换字符串中所有小写为大写
string.lstrip()                               # 去掉string左边的空格
string.rstrip()                               # 去掉string字符末尾的空格
string.replace(str1,str2)                     # 把string中的str1替换成str2,如果num指定,则替换不超过num次
string.startswith(obj,beg=0,end=len(string))  # 检测字符串是否以obj开头
string.zfill(width)                           # 返回字符长度为width的字符,原字符串右对齐,前面填充0
string.isdigit()                              # 只包含数字返回True
string.split("/")                             # 把string切片成一个列表
":".join(string.split())                      # 以:作为分隔符,将所有元素合并为一个新的字符串
```

## 字典内建方法

```python
dict.clear()                            # 删除字典中所有元素
dict copy()                             # 返回字典(浅复制)的一个副本
dict.fromkeys(seq,val=None)             # 创建并返回一个新字典,以seq中的元素做该字典的键,val做该字典中所有键对的初始值
dict.get(key,default=None)              # 对字典dict中的键key,返回它对应的值value,如果字典中不存在此键,则返回default值
dict.has_key(key)                       # 如果键在字典中存在,则返回True 用in和not in代替
dict.items()                            # 返回一个包含字典中键、值对元组的列表
dict.keys()                             # 返回一个包含字典中键的列表
dict.iter()                             # 方法iteritems()、iterkeys()、itervalues()与它们对应的非迭代方法一样,不同的是它们返回一个迭代子,而不是一个列表
dict.pop(key[,default])                 # 和方法get()相似.如果字典中key键存在,删除并返回dict[key]
dict.setdefault(key,default=None)       # 和set()相似,但如果字典中不存在key键,由dict[key]=default为它赋值
dict.update(dict2)                      # 将字典dict2的键值对添加到字典dict
dict.values()                           # 返回一个包含字典中所有值得列表

dict([container])     # 创建字典的工厂函数。提供容器类(container),就用其中的条目填充字典
len(mapping)          # 返回映射的长度(键-值对的个数)
hash(obj)             # 返回obj哈希值,判断某个对象是否可做一个字典的键值
```

## 集合方法

```python
s.update(t)                         # 用t中的元素修改s,s现在包含s或t的成员   s |= t
s.intersection_update(t)            # s中的成员是共用属于s和t的元素          s &= t
s.difference_update(t)              # s中的成员是属于s但不包含在t中的元素    s -= t
s.symmetric_difference_update(t)    # s中的成员更新为那些包含在s或t中,但不是s和t共有的元素  s ^= t
s.add(obj)                          # 在集合s中添加对象obj
s.remove(obj)                       # 从集合s中删除对象obj;如果obj不是集合s中的元素(obj not in s),将引发KeyError错误
s.discard(obj)                      # 如果obj是集合s中的元素,从集合s中删除对象obj
s.pop()                             # 删除集合s中的任意一个对象,并返回它
s.clear()                           # 删除集合s中的所有元素
s.issubset(t)                       # 如果s是t的子集,则返回True   s <= t
s.issuperset(t)                     # 如果t是s的超集,则返回True   s >= t
s.union(t)                          # 合并操作;返回一个新集合,该集合是s和t的并集   s | t
s.intersection(t)                   # 交集操作;返回一个新集合,该集合是s和t的交集   s & t
s.difference(t)                     # 返回一个新集合,改集合是s的成员,但不是t的成员  s - t
s.symmetric_difference(t)           # 返回一个新集合,该集合是s或t的成员,但不是s和t共有的成员   s ^ t
s.copy()                            # 返回一个新集合,它是集合s的浅复制
obj in s                            # 成员测试;obj是s中的元素 返回True
obj not in s                        # 非成员测试:obj不是s中元素 返回True
s == t                              # 等价测试 是否具有相同元素
s != t                              # 不等价测试
s < t                               # 子集测试;s!=t且s中所有元素都是t的成员
s > t                               # 超集测试;s!=t且t中所有元素都是s的成员
```

## 序列化

```python
#!/usr/bin/python
import cPickle
obj = {'1':['4124','1241','124'],'2':['12412','142','1241']}

pkl_file = open('account.pkl','wb')
cPickle.dump(obj,pkl_file)
pkl_file.close()

pkl_file = open('account.pkl','rb')
account_list = cPickle.load(pkl_file)
pkl_file.close()
```

## 文件对象方法

```python
file.close()                     # 关闭文件
file.fileno()                    # 返回文件的描述符
file.flush()                     # 刷新文件的内部缓冲区
file.isatty()                    # 判断file是否是一个类tty设备
file.next()                      # 返回文件的下一行,或在没有其他行时引发StopIteration异常
file.read(size=-1)               # 从文件读取size个字节,当未给定size或给定负值的时候,读取剩余的所有字节,然后作为字符串返回
file.readline(size=-1)           # 从文件中读取并返回一行(包括行结束符),或返回最大size个字符
file.readlines(sizhint=0)        # 读取文件的所有行作为一个列表返回
file.xreadlines()                # 用于迭代,可替换readlines()的一个更高效的方法
file.seek(off, whence=0)         # 在文件中移动文件指针,从whence(0代表文件起始,1代表当前位置,2代表文件末尾)偏移off字节
file.tell()                      # 返回当前在文件中的位置
file.truncate(size=file.tell())  # 截取文件到最大size字节,默认为当前文件位置
file.write(str)                  # 向文件写入字符串
file.writelines(seq)             # 向文件写入字符串序列seq;seq应该是一个返回字符串的可迭代对象
```

## 文件对象的属性

```python
file.closed          # 表示文件已被关闭,否则为False
file.encoding        # 文件所使用的编码  当unicode字符串被写入数据时,它将自动使用file.encoding转换为字节字符串;若file.encoding为None时使用系统默认编码
file.mode            # Access文件打开时使用的访问模式
file.name            # 文件名
file.newlines        # 未读取到行分隔符时为None,只有一种行分隔符时为一个字符串,当文件有多种类型的行结束符时,则为一个包含所有当前所遇到的行结束符的列表
file.softspace       # 为0表示在输出一数据后,要加上一个空格符,1表示不加
```
