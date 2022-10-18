---
layout: mypost
title: Python-常用样例总结
categories: [Python, Algorithm]
---

## 小算法

### 斐波那契

```python
# 将函数结果作为列表可用于循环
def fab(max):
    n, a, b = 0, 0, 1
    while n < max:
        yield b
        a, b = b, a + b
        n = n + 1
for n in fab(5):
    print(n)
```

### 乘法口诀

```python
#!/usr/bin/python
for i in range(1,10):
    for j in range(1,i+1):
        print(j,'*',i,'=',j*i,)
    else:
        print('')
```


### 最小公倍数

```python
# 1-70的最小公倍数
def c(m,n):
    a1=m
    b1=n
    r=n%m
    while r!=0:
        n=m
        m=r
        r=n%m
    return (a1*b1)/m
d=1
for i in range(3,71,2):
    d = c(d,i)
print(d)
```


## 排序算法

### 插入排序

```python
def insertion_sort(sort_list):
    iter_len = len(sort_list)
    if iter_len < 2:
        return sort_list
    for i in range(1, iter_len):
        key = sort_list[i]
        j = i - 1
        while j>=0 and sort_list[j]>key:
            sort_list[j+1] = sort_list[j]
            j -= 1
        sort_list[j+1] = key
    return sort_list
```

### 选择排序

```python
def selection_sort(sort_list):
    iter_len = len(sort_list)
    if iter_len < 2:
        return sort_list
    for i in range(iter_len-1):
        smallest = sort_list[i]
        location = i
        for j in range(i, iter_len):
            if sort_list[j] < smallest:
                smallest = sort_list[j]
                location = j
        if i != location:
            sort_list[i], sort_list[location] = sort_list[location], sort_list[i]
    return sort_list
```

### 冒泡排序

```python
def bubblesort(numbers):
    for j in range(len(numbers)-1,-1,-1):
        for i in range(j):
            if numbers[i]>numbers[i+1]:
                numbers[i],numbers[i+1] = numbers[i+1],numbers[i]
            print(i,j)
            print(numbers)
```

### 快速排序

```python
# 先从数列中取出一个数作为基准数。
# 分区过程，将比这个数大的数全放到它的右边，小于或等于它的数全放到它的左边。
# 再对左右区间重复第二步，直到各区间只有一个数。
#!/usr/bin/python
# -*- coding: utf-8 -*-

def sub_sort(array,low,high):
    key = array[low]
    while low < high:
    while low < high and array[high] >= key:
        high -= 1
    while low < high and array[high] < key:
        array[low] = array[high]
        low += 1
        array[high] = array[low]
    array[low] = key
    return low

def quick_sort(array,low,high):
    if low < high:
        key_index = sub_sort(array,low,high)
        quick_sort(array,low,key_index)
        quick_sort(array,key_index+1,high)

if __name__ == '__main__':
    array = [8,10,9,6,4,16,5,13,26,18,2,45,34,23,1,7,3]
    print(array)
    quick_sort(array,0,len(array)-1)
    print(array)
```

### 二分算法

```python
#python 2f.py 123456789 4
# list('123456789')  =  ['1', '2', '3', '4', '5', '6', '7', '8', '9']
#!/usr/bin/env python
import sys

def search2(a,m):
    low = 0
    high = len(a) - 1
    while(low <= high):
        mid = (low + high)/2
        midval = a[mid]
        if midval < m:
            low = mid + 1
        elif midval > m:
            high = mid - 1
        else:
            print(mid)
            return mid
    print(-1)
    return -1

if __name__ == "__main__":
    a = [int(i) for i in list(sys.argv[1])]
    m = int(sys.argv[2])
    search2(a,m)
```

### 全排序

```python
def Mideng(li):
    if(type(li)!=list):
        return
    if(len(li)==1):
        return [li]
    result=[]
    for i in range(0,len(li[:])):
        bak=li[:]
        head=bak.pop(i)
        for j in Mideng(bak):
            j.insert(0,head)
            result.append(j)
    return result
def MM(n):
    if(type(n)!=int or n<2):
        return
    return Mideng(list(range(1,n)))
    
MM(6)
```

## 嵌套复杂排序

### 字典排序

```python
# 按照键值(value)排序
# a = {'a': 'China', 'c': 'USA', 'b': 'Russia', 'd': 'Canada'}
b = sorted(a.items(), key=lambda x: x[1], reverse=True)
#[('c', 'USA'), ('b', 'Russia'), ('a', 'China'), ('d', 'Canada')]

# 按照键名(key)排序
#a = {'a': 'China', 'c': 'USA', 'b': 'Russia', 'd': 'Canada'}
b = sorted(a.items(), key=lambda x: x[0], reverse=True)
#[('d', 'Canada'), ('c', 'USA'), ('b', 'Russia'), ('a', 'China')]

# 嵌套字典, 按照字典键名(key)排序
#a = {'a': {'b':  'China'}, 'c': {'d': 'USA'}, 'b': {'c': 'Russia'}, 'd': {'a': 'Canada'}}
b = sorted(a.items(), key=lambda x: x[1], reverse=True)
#[('c', {'d': 'USA'}), ('b', {'c': 'Russia'}), ('a', {'b': 'China'}), ('d', {'a': 'Canada'})]

# 嵌套列表, 针对列表第一个元素排序( 其实直接写 x: x[1] 就是按照第一个值排序. )
#a = {'a': [1, 3], 'c': [3, 4], 'b': [0, 2], 'd': [2, 1]}
b = sorted(a.items(), key=lambda x: x[1][0], reverse=True)
#[('c', [3, 4]), ('d', [2, 1]), ('a', [1, 3]), ('b', [0, 2])]

# 嵌套列表, 按照列表其他元素排序  只需要修改列表对应的下标
# a = {'a': [1, 3], 'c': [3, 4], 'b': [0, 2], 'd': [2, 1]}
b = sorted(a.items(), key=lambda x: x[1][1], reverse=True)
# [('c', [3, 4]), ('a', [1, 3]), ('b', [0, 2]), ('d', [2, 1])]

# 总结:  此处使用lambda方法, x: x[1][1] 就可以看做是在访问字典的值, 想要按照哪个数值排序, 用相应的坐标对应即可, 但当字典过于复杂后, 应该选择用元组存储, 简化排序过程.
```

### 列表排序

```python
# 1: 按照字母排序
# a = ['USA', 'China', 'Canada', 'Russia']
a.sort(reverse=True)
# ['USA', 'Russia', 'China', 'Canada']

# 2: 嵌套列表的排序, 按照子列表的其他值排序雷系, 修改x[0] 这里的下标即可
# a = [['USA', 'b'], ['China', 'c'], ['Canada', 'd'], ['Russia', 'a']]
a.sort(key=lambda x: x[0], reverse=True)
# [['USA', 'b'], ['Russia', 'a'], ['China', 'c'], ['Canada', 'd']]

# 3: 嵌套字典, 按照字典值(value) 排序
# a = [{'letter': 'b'}, {'letter': 'c'}, {'letter': 'd'}, {'letter': 'a'}]
a.sort(key=lambda x: x['letter'], reverse=True)
# [{'letter': 'd'}, {'letter': 'c'}, {'letter': 'b'}, {'letter': 'a'}]

# 4: 当字典值也是字典时, 这时候会优先按照键名排序, 再按照键值排序. 例子如下
# a = [{'letter': {'a': 'b'}}, {'letter': {'a': 'c'}}, {'letter': {'a': 'd'}}, {'letter': {'a': 'a'}}]
a.sort(key=lambda x: x['letter'], reverse=True)
# [{'letter': {'a': 'd'}}, {'letter': {'a': 'c'}}, {'letter': {'a': 'b'}}, {'letter': {'a': 'a'}}]

# 方法2:
# a = [{'letter': {'a': 'b'}}, {'letter': {'b': 'c'}}, {'letter': {'c': 'd'}}, {'letter': {'d': 'a'}}]
a.sort(key=lambda x: x['letter'], reverse=True)
#[{'letter': {'d': 'a'}}, {'letter': {'c': 'd'}}, {'letter': {'b': 'c'}}, {'letter': {'a': 'b'}}]
```

## 1000以内是3或者是5的倍数的值的和

```python
sum([ num for num in range(1, 1000) if num % 3 == 0 or num % 5 == 0 ])

# 打印如下列表
# 1
# 2 1
# 3 2 1
# 4 3 2 1
# 5 4 3 2 1
# 6 5 4 3 2 1

#!/usr/local/python

i=1
while i < 7:
    a = ""
    n=1
    while n <= i:
        a = "%s %s" %(n, a)
        n = n + 1

    print(a)
    i = i + 1
```

## 将字典中所有time去掉

```python
a={'version01': {'nba': {'timenba': 'valuesasdfasdf', 'nbanbac': 'vtimefasdf', 'userasdf': 'vtimasdf'}}}
eval(str(a).replace("time",""))
```

## 阿里云oss

```python
# https://help.aliyun.com/document_detail/32027.html?spm=5176.doc32026.6.674.AXf7Lw
# pip install oss2

# -*- coding: utf-8 -*-
import oss2

auth = oss2.Auth('AccessKeyId', 'AccessKeySecret')
# 注意内外网域名 不带bucket
service = oss2.Service(auth, 'oss-cn-shanghai-internal.aliyuncs.com')

print([b.name for b in oss2.BucketIterator(service)])        # 查看存在的bucket

bucket = oss2.Bucket(auth, 'http://oss-cn-shanghai-internal.aliyuncs.com', 'ec-share')
# bucket.create_bucket(oss2.models.BUCKET_ACL_PRIVATE)       # 创建bucket
bucket.put_object_from_file('remote.txt','/tmp/local.txt')   # 上传文件
bucket.get_object_to_file('remote.txt', 'local-backup.txt')  # 下载文件
bucket.delete_object('remote.txt')                           # 删除文件
```

## 阿里云ecs

```python
# https://help.aliyun.com/document_detail/67117.html?spm=a2c4g.11186623.6.543.390360e41Cfpqm
# pip install aliyun-python-sdk-core     # 安装阿里云SDK核心库
# pip install aliyun-python-sdk-ecs      # 安装管理ECS的库

from aliyunsdkcore.client import AcsClient
from aliyunsdkcore.acs_exception.exceptions import ClientException
from aliyunsdkcore.acs_exception.exceptions import ServerException
from aliyunsdkecs.request.v20140526 import DescribeInstancesRequest
from aliyunsdkecs.request.v20140526 import StopInstanceRequest
client = AcsClient(
   "your-access-key-id", 
   "your-access-key-secret",
   "your-region-id"
);
request = DescribeInstancesRequest.DescribeInstancesRequest()
request.set_PageSize(10)
try:
    response = client.do_action_with_exception(request)
    print(response)
except ServerException as e:
    print(e)
except ClientException as e:
    print(e)

# 使用CommonRequest的方式调用ECS的 DescribeInstanceStatus 接口

from aliyunsdkcore.client import AcsClient
from aliyunsdkcore.request import CommonRequest
client = AcsClient('your_access_key_id', 'your_access_key_secret', 'your_region_id')
request = CommonRequest()
request.set_domain('ecs.aliyuncs.com')
request.set_version('2014-05-26')
request.set_action_name('DescribeInstanceStatus')
request.add_query_param('PageNumber', '1')
request.add_query_param('PageSize', '30')
request.add_query_param('ZoneId', 'cn-shanghai-d')
response = client.do_action_with_exception(request)

# 接口列表
https://help.aliyun.com/document_detail/25506.html?spm=a2c4g.11186623.6.1084.2f672eafMskx7S
# 调用DescribeInstances查询一台或多台实例的详细信息
DescribeInstances
# 调用CreateInstance创建一台ECS实例
CreateInstance
# 调用StartInstance启动一台实例
StartInstance
# 调用StopInstance停止运行一台实例
StopInstance
# 调用DescribeInstanceStatus获取一台或多台ECS实例的状态信息
DescribeInstanceStatus

# 创建ecs, CreateInstance, stop状态
# 参数列表
# https://help.aliyun.com/document_detail/25499.html?spm=a2c4g.11186623.6.1095.4347431djUtw2v

from aliyunsdkcore.client import AcsClient
from aliyunsdkcore.request import CommonRequest
client = AcsClient('LTAIzeBZre', 'fLJOBweE8qHKxrEOnc2FIF', 'cn-shanghai')
request = CommonRequest()
request.set_domain('ecs.aliyuncs.com')
request.set_version('2014-05-26')
request.set_action_name('CreateInstance')

request.add_query_param('ImageId', 'm-uf67jei1pul0xpfsfpfv')
request.add_query_param('InstanceType', 'ecs.c5.large')
request.add_query_param('RegionId', 'cn-shanghai')
request.add_query_param('ZoneId', 'cn-shanghai-f')
request.add_query_param('SecurityGroupId', 'sg-uf6i53pjsi11yuyrwyqs')
request.add_query_param('VSwitchId', 'vsw-uf630eqh0edoe9n3ig7lz')
request.add_query_param('Period', '1')
request.add_query_param('InstanceChargeType', 'PrePaid')
request.add_query_param('AutoRenew', 'true')
request.add_query_param('AutoRenewPeriod', '1')
request.add_query_param('InstanceName', 'xuesong-test1')
request.add_query_param('HostName', 'xuesong-test1')
request.add_query_param('Password', 'azuDa9nee6aiHaey')
request.add_query_param('SystemDisk.Size', '200')
request.add_query_param('SystemDisk.Category', 'cloud_efficiency')
request.add_query_param('SystemDisk.DiskName', 'xuesong-test1')

response = client.do_action_with_exception(request)
# InstanceId               # 实例ID，是访问实例的唯一标识
# RequestId                # 无论调用接口成功与否，都会返回请求ID

# 启动ecs   StartInstance
from aliyunsdkcore.client import AcsClient
from aliyunsdkcore.request import CommonRequest
client = AcsClient('LTAIzeBZre', 'fLJOBweE8qHKxrEOnc2FIF', 'cn-shanghai')
request = CommonRequest()
request.set_domain('ecs.aliyuncs.com')
request.set_version('2014-05-26')
request.set_action_name('StartInstance')

request.add_query_param('InstanceId', 'i-uf69e821lkybxke6yyno')
response = client.do_action_with_exception(request)

# 查询ecs信息 DescribeInstances
from aliyunsdkcore.client import AcsClient
from aliyunsdkcore.request import CommonRequest
import json

client = AcsClient('LTAIzeBZre', 'fLJOBweE8qHKxrEOnc2FIF', 'cn-shanghai')
request = CommonRequest()
request.set_domain('ecs.aliyuncs.com')
request.set_version('2014-05-26')
request.set_action_name('DescribeInstances')

request.add_query_param('InstanceIds', ['i-uf69e821lkybxke6yyno'])
response = client.do_action_with_exception(request)
jresponse = json.loads(response)
ip = jresponse['Instances']['Instance'][0]['NetworkInterfaces']['NetworkInterface'][0]['PrimaryIpAddress']
status = jresponse['Instances']['Instance'][0]['Status']
# Stopped  Stopping  Starting  Running 

# 停止ecs StopInstance
from aliyunsdkcore.client import AcsClient
from aliyunsdkcore.request import CommonRequest

client = AcsClient('LTAIzeBZre', 'fLJOBweE8qHKxrEOnc2FIF', 'cn-shanghai')
request = CommonRequest()
request.set_domain('ecs.aliyuncs.com')
request.set_version('2014-05-26')
request.set_action_name('StopInstance')

request.add_query_param('InstanceId', 'i-uf69e821lkybxke6yyno')
response = client.do_action_with_exception(request)

# 删除ecs DeleteInstance  释放一台按量付费实例或者到期的预付费（包年包月）实例
from aliyunsdkcore.client import AcsClient
from aliyunsdkcore.request import CommonRequest

client = AcsClient('LTAIzeBZre', 'fLJOBweE8qHKxrEOnc2FIF', 'cn-shanghai')
request = CommonRequest()
request.set_domain('ecs.aliyuncs.com')
request.set_version('2014-05-26')
request.set_action_name('DeleteInstance')

request.add_query_param('InstanceId', 'i-uf69e821lkybxke6yyno')
request.add_query_param('Force', 'true')

response = client.do_action_with_exception(request)
```

## PIL图像处理

```python
import Image
im = Image.open("j.jpg")            # 打开图片
print(im.format, im.size, im.mode)   # 打印图像格式、像素宽和高、模式
# JPEG (440, 330) RGB
im.show()                           # 显示最新加载图像
box = (100, 100, 200, 200)
region = im.crop(box)               # 从图像中提取出某个矩形大小的图像

# 图片等比缩小

# -*- coding: cp936 -*-
import Image
import glob, os

# 图片批处理
def timage():
    for files in glob.glob('~/:/1/*.JPG'):
        filepath,filename = os.path.split(files)
        filterame,exts = os.path.splitext(filename)
        #输出路径
        opfile = r'D:\\22\\'
        #判断opfile是否存在，不存在则创建
        if (os.path.isdir(opfile)==False):
            os.mkdir(opfile)
        im = Image.open(files)
        w,h = im.size
        #im_ss = im.resize((400,400))
        #im_ss = im.convert('P')
        im_ss = im.resize((int(w*0.12), int(h*0.12)))
        im_ss.save(opfile+filterame+'.jpg')

if __name__=='__main__':
    timage() 
```

## 取系统返回值赋给序列

```python
cmd = os.popen("df -Ph|awk 'NR!=1{print($5)}'").readlines();
cmd = os.popen('df -h').read().split('\n')
cmd = os.popen('lo 2>&1').read()
```

## 取磁盘使用空间

```python
import commands
df = commands.getoutput("df -hP")
[ x.split()[4] for x in df.split("\n") ]
[ (x.split()[0],x.split()[4]) for x in df.split("\n") if x.split()[4].endswith("%") ]
```

## 切片获取星星

```python
def getRating(rating):
return '★★★★★☆☆☆☆☆'.decode('utf8')[5-rating:10-rating]
print(getRating(1))
print(getRating(3))
```

## 打印表格

```python
map = [["a","b","c"],
   ["d","e","f"],
   ["g","h","i"]]
def print_board():
    for i in range(0,3):
        for j in range(0,3):
            print("|",map[i][j])
            #if j != 2:
        print('|')
```

## 井字游戏

```python
#!/usr/bin/python
# http://www.admin10000.com/document/2506.html
def print_board():
for i in range(0,3):
    for j in range(0,3):
        print(map[2-i][j])
        if j != 2:
            print("|")
    print("")

def check_done():
for i in range(0,3):
    if map[i][0] == map[i][1] == map[i][2] != " " \
    or map[0][i] == map[1][i] == map[2][i] != " ":
        print(turn, "won!!!")
        return True

if map[0][0] == map[1][1] == map[2][2] != " " \
or map[0][2] == map[1][1] == map[2][0] != " ":
    print(turn, "won!!!")
    return True

if " " not in map[0] and " " not in map[1] and " " not in map[2]:
    print("Draw")
    return True

return False

turn = "X"
map = [[" "," "," "],
   [" "," "," "],
   [" "," "," "]]
done = False

while done != True:
print_board()

print(turn, "'s turn")

moved = False
while moved != True:
    print("Please select position by typing in a number between 1 and 9, see below for which number that is which position...")
    print("7|8|9")
    print("4|5|6")
    print("1|2|3")
    try:
        pos = input("Select: ")
        if pos <=9 and pos >=1:
            Y = pos/3
            X = pos%3
            if X != 0:
                X -=1
            else:
                 X = 2
                 Y -=1

            if map[Y][X] == " ":
                map[Y][X] = turn
                moved = True
                done = check_done()

                if done == False:
                    if turn == "X":
                        turn = "O"
                    else:
                        turn = "X"

    except:
        print("You need to add a numeric value")
```

## 网段划分

```python
"""
    题目
    192.168.1
    192.168.3
    192.168.2
    172.16.3
    192.16.1
    192.16.2
    192.16.3
    10.0.4
    
    输出结果：
    192.16.1-192.16.3
    192.168.1-192.168.3
    172.16.3
    10.0.4
"""

# 答案
#!/usr/bin/python

f = file('a.txt')
c = f.readlines()
dic={}

for i in c:
    a=i.strip().split('.')
    if a[0]+'.'+a[1] in dic.keys():
        key=dic["%s.%s" %(a[0],a[1])]
    else:
        key=[]
    key.append(a[2])
    dic[a[0]+'.'+a[1]]=sorted(key)

for x,y in dic.items():
    if y[0] == y[-1]:
        print('%s.%s' %(x,y[0]))
    else:
        print('%s.%s-%s.%s' %(x,y[0],x,y[-1]))
```

## 统计日志IP

```python
# 打印出独立IP，并统计独立IP数
# 219.140.190.130 - - [23/May/2006:08:57:59 +0800] "GET /fg172.exe HTTP/1.1" 200 2350253
# 221.228.143.52 - - [23/May/2006:08:58:08 +0800] "GET /fg172.exe HTTP/1.1" 206 719996
# 221.228.143.52 - - [23/May/2006:08:58:08 +0800] "GET /fg172.exe HTTP/1.1" 206 713242

#!/usr/bin/python
dic={}
a=open("a").readlines()
for i in a:
ip=i.strip().split()[0]
if ip in dic.keys():
    dic[ip] = dic[ip] + 1
else:
    dic[ip] = 1
for x,y in dic.items():
    print(x," ",y)
```

## 多线程下载http

```python
# 先从文件头中或取content-length的值,即文件大小,在用header中指定Range范围来下载文件中一段字符串
# 'Range':'bytes=0-499'           # 表示头500个字节
# 'Range':'bytes=-500'            # 表示最后500个字节
# 'Range':'bytes=500-'            # 表示500字节以后的范围
# 'Range':'bytes=0-0,-1'          # 第一个和最后一个字节
# 'Range':'bytes=50-60,61-99'     # 同时指定几个范围

#!/usr/bin/env python
#encoding:utf8
import urllib2
import threading

class myThread(threading.Thread):

    def __init__(self, url_file, scope, url):
        threading.Thread.__init__(self)
        self.url_file = url_file
        self.scope = scope
        self.url = url
    
    def run(self):
    
        req_header = {'User-Agent':"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)",
        'Accept':'text/html;q=0.9,*/*;q=0.8',
        'Range':'bytes=%s' % self.scope,
        'Accept-Charset':'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
        'Connection':'close',
        }
    
        req = urllib2.Request(self.url, headers=req_header)
        data = urllib2.urlopen(req, data=None).read()
        start_value = int(self.scope.split('-')[0])
    
        threadLock.acquire()
    
        self.url_file.seek(start_value)
        self.url_file.write(data)
        self.url_file.flush()
        threadLock.release()

if __name__ == '__main__':

    url = 'http://dldir1.qq.com/qqfile/qq/QQ7.1/14522/QQ7.1.exe'
    size=int(urllib2.urlopen(url).info()['content-length'])
    print(size)
    threadnum = 4
    len = size / threadnum
    current = 0
    
    url_file = file(url.split('/')[-1],'wb+')
    threadLock = threading.Lock()
    threads = []
    for tName in range(1, threadnum + 1):
    
        if tName < threadnum:
            scope = "%d-%d" %(current,len * tName - 1)
            current = len * tName
        elif tName == threadnum:
                scope = "%d-" %(current)
        print(scope)
        thread = myThread(url_file, scope, url)
        thread.start()
        threads.append(thread)
    
    for t in threads:
        t.join()
    
    url_file.flush()
    url_file.close()
```

## 获取网卡流量

```python
#!/usr/bin/env python

net = []
f = open("/proc/net/dev")
lines = f.readlines()
f.close()
for line in lines[3:]:
    con = line.split()
    intf = dict(
        zip(
            ( 'interface', 'ReceiveBytes', 'ReceivePackets', 'TransmitBytes', 'TransmitPackets',),
            ( con[0].split(":")[0], con[0].split(":")[1], int(con[1]), int(con[8]), int(con[9]),)
        )
    )
    net.append(intf)
print(net)
```

## 阿里云sdk接口

```python
# 阿里云接口列表
# https://develop.aliyun.com/tools/sdk?#/python

# python sdk模块
# https://help.aliyun.com/document_detail/30003.html?spm=5176.doc29995.2.1.htCtSa

# 接口参数详解
# https://help.aliyun.com/document_detail/25500.html?spm=5176.doc25499.6.691.lWwhc0

# pip install aliyun-python-sdk-core aliyun-python-sdk-ecs

dir(aliyunsdkecs.request)
# v20140526
# aliyunsdkecs.request.v20140526

#!/usr/bin/env python
from aliyunsdkcore import client
from aliyunsdkecs.request.v20140526 import DescribeRegionsRequest

clt = client.AcsClient('SFAW************','Nc2nZ6dQoiqck0*************','cn-hangzhou')

request=DescribeRegionsRequest.DescribeRegionsRequest()

print(dir(request))

request.set_accept_format('json')
request.set_action_name("CreateInstance")

print(clt.do_action(request))
```



## 获取系统监控信息

```python
#!/usr/bin/env python
import inspect
import os,time,socket

class mon:
    def __init__(self):
        self.data = {}
    def getLoadAvg(self):
        with open('/proc/loadavg') as load_open:
            a = load_open.read().split()[:3]
            #return "%s %s %s" % (a[0],a[1],a[2])
            return   float(a[0])
    def getMemTotal(self):
        with open('/proc/meminfo') as mem_open:
            a = int(mem_open.readline().split()[1])
            return a / 1024
    def getMemUsage(self, noBufferCache=True):
        if noBufferCache:
            with open('/proc/meminfo') as mem_open:
                T = int(mem_open.readline().split()[1]) #Total
                F = int(mem_open.readline().split()[1]) #Free
                B = int(mem_open.readline().split()[1]) #Buffer
                C = int(mem_open.readline().split()[1]) #Cache
                return (T-F-B-C)/1024
        else:
            with open('/proc/meminfo') as mem_open:
                a = int(mem_open.readline().split()[1]) - int(mem_open.readline().split()[1])
                return a / 1024
    def getMemFree(self, noBufferCache=True):
        if noBufferCache:
            with open('/proc/meminfo') as mem_open:
                T = int(mem_open.readline().split()[1])
                F = int(mem_open.readline().split()[1])
                B = int(mem_open.readline().split()[1])
                C = int(mem_open.readline().split()[1])
                return (F+B+C)/1024
        else:
            with open('/proc/meminfo') as mem_open:
                mem_open.readline()
                a = int(mem_open.readline().split()[1])
                return a / 1024
    def getDiskTotal(self):
        disk = os.statvfs("/")
        Total = disk.f_bsize * disk.f_blocks / 1024 / 1024
        return Total
    def getDiskFree(self):
        disk = os.statvfs("/")
        Free = disk.f_bsize * disk.f_bavail / 1024 / 1024
        return Free
    def getTraffic(self):
        traffic = {}
        f = open("/proc/net/dev")
        lines = f.readlines()
        f.close()
        for line in lines[3:]:
            con = line.split()
            intf = dict(
                zip(
                    ('ReceiveBytes', 'TransmitBytes',),
                    (con[0].split(":")[1], int(con[8]),)
                )
            )
            traffic[con[0].split(":")[0]] = intf
        return traffic
    def getHost(self):
        #return ['host1', 'host2', 'host3', 'host4', 'host5'][int(time.time() * 1000.0) % 5]
        return socket.gethostname()
    def getTime(self):
        return int(time.time())
    def runAllGet(self):
        for fun in inspect.getmembers(self, predicate=inspect.ismethod):
            if fun[0][:3] == 'get':
                self.data[fun[0][3:]] = fun[1]()
        return self.data

if __name__ == "__main__":
    print(mon().runAllGet())
```

## nginx_5xx钉钉报警

```python
import os
import sys
import datetime
import time
import requests
import json

mtime = (datetime.datetime.now()-datetime.timedelta(minutes=1)).strftime("%Y-%m-%dT%H:%M")

num = int(os.popen('''tail -n 100000 /app/nginx/logs/*_access.log | grep %s |grep 'status": 5'  |wc -l  ''' % mtime ).read().strip())
print(num)

if num > 20:
    print('baojing')
    Robot = 'https://oapi.dingtalk.com/robot/send?access_token=e80aa431d237d97217827524'
    headers = {'content-type': 'application/json'}
    content = "lite nginx dmz01 5XX: %s" % num
    
    dingdata = {
        "msgtype": "text",
        "text": {
            "content": content
        }
    }

try:
    r = requests.post(url=Robot, data=json.dumps(dingdata), headers=headers, timeout=2).json()
except Exception as err:
    print('ERROR: notice dingding api error')
    print(str(err))
```

## 获取主机名

```python
#!/usr/bin/env python
# -*- coding: utf8 -*-
#python network.py --host

import os
import socket

"""
copy from:
http://stackoverflow.com/questions/11735821/python-get-localhost-ip
"""

if os.name != "nt":
import fcntl
import struct

def get_interface_ip(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(s.fileno(), 0x8915, struct.pack('256s', ifname[:15]))[20:24])

def lan_ip():
    ip = socket.gethostbyname(socket.gethostname())
    if ip.startswith("127.") and os.name != "nt":
        interfaces = [
            "eth0",
            "eth1",
            "eth2",
            "wlan0",
            "wlan1",
            "wifi0",
            "ath0",
            "ath1",
            "ppp0",
        ]
        for ifname in interfaces:
            try:
                ip = get_interface_ip(ifname)
                break
            except IOError:
                pass
    return ip

if __name__ == '__main__':
    import sys
    if len(sys.argv) > 1:
        print(socket.gethostname())
        sys.exit(0)
    print(lan_ip())
```


## LazyManage并发批量操作(判断非root交互到root操作)

```python
#!/usr/bin/python
#encoding:utf8
# LzayManage.py
# config file: serverlist.conf

import paramiko
import multiprocessing
import sys,os,time,socket,re

def Ssh_Cmd(host_ip,Cmd,user_name,user_pwd,port=22):
    s = paramiko.SSHClient()
    s.load_system_host_keys()
    s.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    s.connect(hostname=host_ip,port=port,username=user_name,password=user_pwd)
    stdin,stdout,stderr = s.exec_command(Cmd)
    Result = '%s%s' %(stdout.read(),stderr.read())
    q.put('successful')
    s.close()
    return Result.strip()

def Ssh_Su_Cmd(host_ip,Cmd,user_name,user_pwd,root_name,root_pwd,port=22):
    s = paramiko.SSHClient()
    s.load_system_host_keys()
    s.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    s.connect(hostname=host_ip,port=port,username=user_name,password=user_pwd)
    ssh = s.invoke_shell()
    time.sleep(0.1)
    ssh.send('su - %s\n' %(root_name))
    buff = ''
    while not buff.endswith('Password: '):
        resp = ssh.recv(9999)
        buff +=resp
    ssh.send('%s\n' %(root_pwd))
    buff = ''
    while True:
        resp = ssh.recv(9999)
        buff +=resp
        if ': incorrect password' in buff:
            su_correct='passwd_error'
            break
        elif buff.endswith('# '):
            su_correct='passwd_correct'
            break
    if su_correct == 'passwd_correct':
        ssh.send('%s\n' %(Cmd))
        buff = ''
        while True:
            resp = ssh.recv(9999)
            if resp.endswith('# '):
                buff +=re.sub('\[.*@.*\]# $','',resp)
                break
            buff +=resp
        Result = buff.lstrip('%s' %(Cmd))
        q.put('successful')
    elif su_correct == 'passwd_error':
        Result = "\033[31mroot密码错误\033[m"
    s.close()
    return Result.strip()

def Send_File(host_ip,PathList,user_name,user_pwd,Remote='/tmp',port=22):
    s=paramiko.Transport((host_ip,port))
    s.connect(username=user_name,password=user_pwd)
    sftp=paramiko.SFTPClient.from_transport(s)
    for InputPath in PathList:
        LocalPath = re.sub('^\./','',InputPath.rstrip('/'))
        RemotePath = '%s/%s' %( Remote , os.path.basename( LocalPath ))
        try:
            sftp.rmdir(RemotePath)
        except:
            pass
        try:
            sftp.remove(RemotePath)
        except:
            pass
        if os.path.isdir(LocalPath):
            sftp.mkdir(RemotePath)
            for path,dirs,files in os.walk(LocalPath):
                for dir in dirs:
                    dir_path = os.path.join(path,dir)
                    sftp.mkdir('%s/%s' %(RemotePath,re.sub('^%s/' %LocalPath,'',dir_path)))
                for file in files:
                    file_path = os.path.join(path,file)
                    sftp.put( file_path,'%s/%s' %(RemotePath,re.sub('^%s/' %LocalPath,'',file_path)))
        else:
            sftp.put(LocalPath,RemotePath)
    q.put('successful')
    sftp.close()
    s.close()
    Result = '%s  \033[32m传送完成\033[m' % PathList
    return Result

def Ssh(host_ip,Operation,user_name,user_pwd,root_name,root_pwd,Cmd=None,PathList=None,port=22):
    msg = "\033[32m-----------Result:%s----------\033[m" % host_ip
    try:
        if Operation == 'Ssh_Cmd':
            Result = Ssh_Cmd(host_ip=host_ip,Cmd=Cmd,user_name=user_name,user_pwd=user_pwd,port=port)
        elif Operation == 'Ssh_Su_Cmd':
            Result = Ssh_Su_Cmd(host_ip=host_ip,Cmd=Cmd,user_name=user_name,user_pwd=user_pwd,root_name=root_name,root_pwd=root_pwd,port=port)
        elif Operation == 'Ssh_Script':
            Send_File(host_ip=host_ip,PathList=PathList,user_name=user_name,user_pwd=user_pwd,port=port)
            Script_Head = open(PathList[0]).readline().strip()
            LocalPath = re.sub('^\./','',PathList[0].rstrip('/'))
            Cmd = '%s /tmp/%s' %( re.sub('^#!','',Script_Head), os.path.basename( LocalPath ))
            Result = Ssh_Cmd(host_ip=host_ip,Cmd=Cmd,user_name=user_name,user_pwd=user_pwd,port=port)
        elif Operation == 'Ssh_Su_Script':
            Send_File(host_ip=host_ip,PathList=PathList,user_name=user_name,user_pwd=user_pwd,port=port)
            Script_Head = open(PathList[0]).readline().strip()
            LocalPath = re.sub('^\./','',PathList[0].rstrip('/'))
            Cmd = '%s /tmp/%s' %( re.sub('^#!','',Script_Head), os.path.basename( LocalPath ))
            Result = Ssh_Su_Cmd(host_ip=host_ip,Cmd=Cmd,user_name=user_name,user_pwd=user_pwd,root_name=root_name,root_pwd=root_pwd,port=port)
        elif Operation == 'Send_File':
            Result = Send_File(host_ip=host_ip,PathList=PathList,user_name=user_name,user_pwd=user_pwd,port=port)
        else:
            Result = '操作不存在'
    
    except socket.error:
        Result = '\033[31m主机或端口错误\033[m'
    except paramiko.AuthenticationException:
        Result = '\033[31m用户名或密码错误\033[m'
    except paramiko.BadHostKeyException:
        Result = '\033[31mBad host key\033[m['
    except IOError:
        Result = '\033[31m远程主机已存在非空目录或没有写权限\033[m'
    except:
        Result = '\033[31m未知错误\033[m'
    r.put('%s\n%s\n' %(msg,Result))

def Concurrent(Conf,Operation,user_name,user_pwd,root_name,root_pwd,Cmd=None,PathList=None,port=22):
    # 读取配置文件
    f=open(Conf)
    list = f.readlines()
    f.close()
    # 执行总计
    total = 0
    # 并发执行
    for host_info in list:
        # 判断配置文件中注释行跳过
        if host_info.startswith('#'):
            continue
        # 取变量,其中任意变量未取到就跳过执行
        try:
            host_ip=host_info.split()[0]
            #user_name=host_info.split()[1]
            #user_pwd=host_info.split()[2]
        except:
            print('Profile error: %s' %(host_info) )
            continue
        try:
            port=int(host_info.split()[3])
        except:
            port=22
        total +=1
        p = multiprocessing.Process(target=Ssh,args=(host_ip,Operation,user_name,user_pwd,root_name,root_pwd,Cmd,PathList,port))
        p.start()
    # 打印执行结果
    for j in range(total):
        print(r.get() )
    if Operation == 'Ssh_Script' or Operation == 'Ssh_Su_Script':
        successful = q.qsize() / 2
    else:
        successful = q.qsize()
    print('\033[32m执行完毕[总执行:%s 成功:%s 失败:%s]\033[m' %(total,successful,total - successful) )
    q.close()
    r.close()

def Help():
    print('''    1.执行命令
    2.执行脚本      \033[32m[位置1脚本(必须带脚本头),后可带执行脚本所需要的包\文件\文件夹路径,空格分隔]\033[m
    3.发送文件      \033[32m[传送的包\文件\文件夹路径,空格分隔]\033[m
    退出: 0\exit\quit
    帮助: help\h\?
    注意: 发送文件默认为/tmp下,如已存在同名文件会被强制覆盖,非空目录则中断操作.执行脚本先将本地脚本及包发送远程主机上,发送规则同发送文件
    ''')

if __name__=='__main__':
    # 定义root账号信息
    root_name = 'root'
    root_pwd = 'peterli'
    user_name='peterli'
    user_pwd='<++(3Ie'
    # 配置文件
    Conf='serverlist.conf'
    if not os.path.isfile(Conf):
        print('\033[33m配置文件 %s 不存在\033[m' %(Conf) )
        sys.exit()
    Help()
    while True:
        i = raw_input("\033[35m[请选择操作]: \033[m").strip()
        q = multiprocessing.Queue()
        r = multiprocessing.Queue()
        if i == '1':
            if user_name == root_name:
                Operation = 'Ssh_Cmd'
            else:
                Operation = 'Ssh_Su_Cmd'
            Cmd = raw_input('CMD: ').strip()
            if len(Cmd) == 0:
                print('\033[33m命令为空\033[m')
                continue
            Concurrent(Conf=Conf,Operation=Operation,user_name=user_name,user_pwd=user_pwd,root_name=root_name,root_pwd=root_pwd,Cmd=Cmd)
        elif i == '2':
            if user_name == root_name:
                Operation = 'Ssh_Script'
            else:
                Operation = 'Ssh_Su_Script'
            PathList = raw_input('\033[36m本地脚本路径: \033[m').strip().split()
            if len(PathList) == 0:
                print('\033[33m路径为空\033[m')
                continue
            if not os.path.isfile(PathList[0]):
                print('\033[33m本地路径 %s 不存在或不是文件\033[m' %(PathList[0]) )
                continue
            for LocalPath in PathList[1:]:
                if not os.path.exists(LocalPath):
                    print('\033[33m本地路径 %s 不存在\033[m' %(LocalPath) )
                    break
            else:
                Concurrent(Conf=Conf,Operation=Operation,user_name=user_name,user_pwd=user_pwd,root_name=root_name,root_pwd=root_pwd,PathList=PathList)
        elif i == '3':
            Operation = 'Send_File'
            PathList = raw_input('\033[36m本地路径: \033[m').strip().split()
            if len(PathList) == 0:
                print('\033[33m路径为空\033[m')
                continue
            for LocalPath in PathList:
                if not os.path.exists(LocalPath):
                    print('\033[33m本地路径 %s 不存在\033[m' %(LocalPath) )
                    break
            else:
                Concurrent(Conf=Conf,Operation=Operation,user_name=user_name,user_pwd=user_pwd,root_name=root_name,root_pwd=root_pwd,PathList=PathList)
        elif i == '0' or i == 'exit' or i == 'quit':
            print("\033[34m退出LazyManage脚本\033[m")
            sys.exit()
        elif i == 'help' or i == 'h' or i == '?':
            Help()
```

## epoll非阻塞长链接

### server

```python
#!/usr/bin/python
#-*- coding:utf-8 -*-

import socket, select, logging, errno1  ``
import os, sys, json

def cmdRunner(input):
    import commands
    cmd_ret = commands.getstatusoutput(input)
    return json.dumps({'ret':cmd_ret[0], 'out':cmd_ret[1]}, separators=(',', ':'))

class _State:
    def __init__(self):
        self.state = "read"
        self.have_read = 0
        self.need_read = 10
        self.have_write = 0
        self.need_write = 0
        self.data = ""

__all__ = ['nbNet']

class nbNet:

    def __init__(self, host, port, logic):
        self.host = host
        self.port = port
        self.logic = logic
        self.sm = {
            "read":self.aread,
            "write":self.awrite,
            "process":self.aprocess,
            "closing":self.aclose,
        }

    def run(self):

        try:
            self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)
        except socket.error, msg:
            print("create socket failed")

        try:
            self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        except socket.error, msg:
            print("setsocketopt SO_REUSEADDR failed")

        try:
            self.sock.bind((self.host, self.port))
        except socket.error, msg:
            print("bind failed")

        try:
            self.sock.listen(10)
        except socket.error, msg:
            print(msg)

        try:
            self.epoll_fd = select.epoll()
            # 向 epoll 句柄中注册 新来socket链接，监听可读事件
            self.epoll_fd.register(self.sock.fileno(), select.EPOLLIN )
        except select.error, msg:
            print(msg)

        self.STATE = {}

        while True:
            print(self.STATE)
            # epoll 等待事件回调收发数据
            epoll_list = self.epoll_fd.poll()
            for fd, events in epoll_list:
                if select.EPOLLHUP & events:
                    print('EPOLLHUP')
                    self.STATE[fd][2].state = "closing"
                elif select.EPOLLERR & events:
                    print('EPOLLERR')
                    self.STATE[fd][2].state = "closing"
                self.state_machine(fd)
    def state_machine(self, fd):
        if fd == self.sock.fileno():
            print("state_machine fd %s accept" % fd)
            # fd与初始监听的fd一致,新创建一个连接
            conn, addr = self.sock.accept()
            # 设置为非阻塞
            conn.setblocking(0)
            self.STATE[conn.fileno()] = [conn, addr, _State()]
            # 将新建立的链接注册在epoll句柄中,监听可读事件,并设置为EPOLLET高速边缘触发,即触发后不会再次触发直到新接收数据
            self.epoll_fd.register(conn.fileno(), select.EPOLLET | select.EPOLLIN )
        else:
            # 否则为历史已存在的fd，调用对应的状态方法
            print("state_machine fd %s %s" % (fd,self.STATE[fd][2].state))
            stat = self.STATE[fd][2].state
            self.sm[stat](fd)
    def aread(self, fd):
        try:
            # 接收当前fd的可读事件中的数据
            one_read = self.STATE[fd][0].recv(self.STATE[fd][2].need_read)
            if len(one_read) == 0:
                # 接收错误改变状态为关闭
                self.STATE[fd][2].state = "closing"
                self.state_machine(fd)
                return
            # 将历史接收的数据叠加
            self.STATE[fd][2].data += one_read
            self.STATE[fd][2].have_read += len(one_read)
            self.STATE[fd][2].need_read -= len(one_read)
            # 接收协议的10个字符
            if self.STATE[fd][2].have_read == 10:
                # 通过10个字符得知下次应该具体接收多少字节,存入状态字典中
                self.STATE[fd][2].need_read += int(self.STATE[fd][2].data)
                self.STATE[fd][2].data = ''
                # 调用状态机重新处理
                self.state_machine(fd)
            elif self.STATE[fd][2].need_read == 0:
                # 当接全部收完毕,改变状态,去执行具体服务
                self.STATE[fd][2].state = 'process'
                self.state_machine(fd)
        except socket.error, msg:
            self.STATE[fd][2].state = "closing"
            print(msg)
            self.state_machine(fd)
            return

    def aprocess(self, fd):
        # 执行具体执行方法 cmdRunner 得到符合传输协议的返回结果
        response = self.logic(self.STATE[fd][2].data)
        self.STATE[fd][2].data = "%010d%s"%(len(response), response)
        self.STATE[fd][2].need_write = len(self.STATE[fd][2].data)
        # 改变为写的状态
        self.STATE[fd][2].state = 'write'
        # 改变监听事件为写
        self.epoll_fd.modify(fd, select.EPOLLET | select.EPOLLOUT)
        self.state_machine(fd)

    def awrite(self, fd):
        try:
            last_have_send = self.STATE[fd][2].have_write
            # 发送返回给客户端的数据
            have_send = self.STATE[fd][0].send(self.STATE[fd][2].data[last_have_send:])
            self.STATE[fd][2].have_write += have_send
            self.STATE[fd][2].need_write -= have_send
            if self.STATE[fd][2].need_write == 0 and self.STATE[fd][2].have_write != 0:
                # 发送完成,重新初始化状态,并将监听写事件改回读事件
                self.STATE[fd][2] = _State()
                self.epoll_fd.modify(fd, select.EPOLLET | select.EPOLLIN)
        except socket.error, msg:
            self.STATE[fd][2].state = "closing"
            self.state_machine(fd)
            print(msg)
            return

    def aclose(self, fd):
        try:
            print('Error: %s:%d' %(self.STATE[fd][1][0] ,self.STATE[fd][1][1]))
            # 取消fd的事件监听
            self.epoll_fd.unregister(fd)
            # 关闭异常链接
            self.STATE[fd][0].close()
            # 删除fd的状态信息
            self.STATE.pop(fd)
        except:
            print('Close the abnormal')

if __name__ == "__main__":
    HOST = '0.0.0.0'
    PORT = 50005
    nb = nbNet(HOST, PORT, cmdRunner)
    nb.run()
```

### client

```python
#!/usr/bin/env python

import socket, sys, os

HOST = '0.0.0.0'
PORT = 50005

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))

cmd = sys.argv[1]
while True:
    s.sendall("%010d%s"%(len(cmd), cmd))
    print(cmd)
    count = s.recv(10)
    if not count:
        print('-----------')
        print(count)
        sys.exit()
    count = int(count)
    buf = s.recv(count)
    print(buf)
```
