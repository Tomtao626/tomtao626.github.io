---
layout: mypost
title: Python-内置模块
categories: [Python]
---

## sys             [系统操作模块]

```python
sys.argv              # 取参数列表
sys.exit(2)           # 退出脚本返回状态 会被try截取
sys.exc_info()        # 获取当前正在处理的异常类
sys.version           # 获取Python解释程序的版本信息
sys.maxint            # 最大的Int值  9223372036854775807
sys.maxunicode        # 最大的Unicode值
sys.modules           # 返回系统导入的模块字段，key是模块名，value是模块
sys.path              # 返回模块的搜索路径，初始化时使用PYTHONPATH环境变量的值
sys.platform          # 返回操作系统平台名称
sys.stdout            # 标准输出
sys.stdin             # 标准输入
sys.stderr            # 错误输出
sys.exec_prefix       # 返回平台独立的python文件安装的位置
sys.stdin.readline()  # 从标准输入读一行
sys.stdout.write("a") # 屏幕输出a
sys.path.insert(1, os.path.join(sys.path[0], '/opt/script/'))     # 将/opt/script/目录加入环境变量，可导入相应模块
```

## commands        [执行系统操作]

```python
(status, output) = commands.getstatusoutput('cat /proc/cpuinfo')
print(status, output)
```

## os              [系统模块]

```python
import os
# 相对sys模块 os模块更为底层 os._exit() try无法抓取
os.popen('id').read()      # 执行系统命令得到返回结果
os.system()                # 得到返回状态 返回无法截取
os.name                    # 返回系统平台 Linux/Unix用户是'posix'
os.getenv()                # 读取环境变量
os.environ['A']='1'        # 设置环境变量
os.getcwd()                # 当前工作路径
os.chdir()                 # 改变当前工作目录
os.walk('/root/')          # 递归路径
os.environ['HOME']         # 查看系统环境变量
os.statvfs("/")            # 获取磁盘信息
```

### 文件处理

```python
os.mkfifo()/mknod()       # 创建命名管道/创建文件系统节点
os.remove()/unlink()      # 删除文件
os.rename()/renames()     # 重命名文件
os.stat()                 # 返回文件信息
os.symlink()              # 创建符号链接
os.utime()                # 更新时间戳
os.tmpfile()              # 创建并打开('w+b')一个新的临时文件
os.walk()                 # 遍历目录树下的所有文件名

oct(os.stat('th1.py').st_mode)[-3:]      # 查看目录权限
```

### 目录/文件夹

```python
os.chdir()/fchdir()       # 改变当前工作目录/通过一个文件描述符改变当前工作目录
os.chroot()               # 改变当前进程的根目录
os.listdir()              # 列出指定目录的文件
os.getcwd()/getcwdu()     # 返回当前工作目录/功能相同,但返回一个unicode对象
os.mkdir()/makedirs()     # 创建目录/创建多层目录
os.rmdir()/removedirs()   # 删除目录/删除多层目录
```

### 访问/权限

```python
os.saccess()                    # 检验权限模式
os.chmod('txt',eval("0777"))    # 改变权限模式
os.chown()/lchown()             # 改变owner和groupID功能相同,但不会跟踪链接
os.umask()                      # 设置默认权限模式
```

### 文件描述符操作

```python
os.open()                 # 底层的操作系统open(对于稳健,使用标准的内建open()函数)
os.read()/write()         # 根据文件描述符读取/写入数据 按大小读取文件部分内容
os.dup()/dup2()           # 复制文件描述符号/功能相同,但是复制到另一个文件描述符
```

### 设备号

```python
os.makedev()              # 从major和minor设备号创建一个原始设备号
os.major()/minor()        # 从原始设备号获得major/minor设备号
```

### os.path模块

```python
os.path.expanduser('~/.ssh/key')   # 家目录下文件的全路径
```

### 分隔

```python
os.path.basename()         # 去掉目录路径,返回文件名
os.path.dirname()          # 去掉文件名,返回目录路径
os.path.join()             # 将分离的各部分组合成一个路径名
os.path.spllt()            # 返回(dirname(),basename())元组
os.path.splitdrive()       # 返回(drivename,pathname)元组
os.path.splitext()         # 返回(filename,extension)元组
```

### 信息

```python
os.path.getatime()         # 返回最近访问时间
os.path.getctime()         # 返回文件创建时间
os.path.getmtime()         # 返回最近文件修改时间
os.path.getsize()          # 返回文件大小(字节)
```

### 查询

```python
os.path.exists()           # 指定路径(文件或目录)是否存在
os.path.isabs()            # 指定路径是否为绝对路径
os.path.isdir()            # 指定路径是否存在且为一个目录
os.path.isfile()           # 指定路径是否存在且为一个文件
os.path.islink()           # 指定路径是否存在且为一个符号链接
os.path.ismount()          # 指定路径是否存在且为一个挂载点
os.path.samefile()         # 两个路径名是否指向同一个文件
```

### 子进程

```python
os.fork()    # 创建子进程,并复制父进程所有操作  通过判断pid = os.fork() 的pid值,分别执行父进程与子进程操作，0为子进程
os.wait()    # 等待子进程结束
```

### 跨平台os模块属性

```python
linesep         # 用于在文件中分隔行的字符串
sep             # 用来分隔文件路径名字的字符串
pathsep         # 用于分割文件路径的字符串
curdir          # 当前工作目录的字符串名称
pardir          # 父目录字符串名称
```

#### 磁盘空间

```python
import os
disk = os.statvfs("/")
# disk.f_bsize       块大小
# disk.f_blocks      块总数
# disk.f_bfree       剩余块总数
# disk.f_bavail      非root用户的剩余块数  由于权限小会比root的剩余块总数小 用这个做报警会更准确
# disk.f_files       总节点数
# disk.f_ffree       剩余节点数
# disk.f_favail      非root用户的剩余节点数

disk.f_bsize * disk.f_bavail / 1024 / 1024 / 1024   # 非root用户剩余空间大小G
disk.f_bsize * disk.f_blocks / 1024 / 1024 / 1024   # 分区空间总大小
```

## commands        [执行系统命令]

```python
(status, output) = commands.getstatusoutput('cat /proc/cpuinfo')
print(status, output)
commands.getstatusoutput('id')       # 返回元组(状态,标准输出)
commands.getoutput('id')             # 只返回执行的结果, 忽略返回值
commands.getstatus('file')           # 返回ls -ld file执行的结果
```

## re              [perl风格正则]

```python
compile(pattern,flags=0)          # 对正则表达式模式pattern进行编译,flags是可选标识符,并返回一个regex对象
match(pattern,string,flags=0)     # 尝试用正则表达式模式pattern匹配字符串string,flags是可选标识符,如果匹配成功,则返回一个匹配对象;否则返回None
search(pattern,string,flags=0)    # 在字符串string中搜索正则表达式模式pattern的第一次出现,flags是可选标识符,如果匹配成功,则返回一个匹配对象;否则返回None
findall(pattern,string[,flags])   # 在字符串string中搜索正则表达式模式pattern的所有(非重复)出现:返回一个匹配对象的列表  # pattern=u'\u4e2d\u6587' 代表UNICODE
finditer(pattern,string[,flags])  # 和findall()相同,但返回的不是列表而是迭代器;对于每个匹配,该迭代器返回一个匹配对象
split(pattern,string,max=0)       # 根据正则表达式pattern中的分隔符把字符string分割为一个列表,返回成功匹配的列表,最多分割max次(默认所有)
sub(pattern,repl,string,max=0)    # 把字符串string中所有匹配正则表达式pattern的地方替换成字符串repl,如果max的值没有给出,则对所有匹配的地方进行替换(subn()会返回一个表示替换次数的数值)
group(num=0)                      # 返回全部匹配对象(或指定编号是num的子组)
groups()                          # 返回一个包含全部匹配的子组的元组(如果没匹配成功,返回一个空元组)
```

### 零宽断言

```python
str = 'aaa111aaa , bbb222&, 333ccc'
re.compile('\d+(?=[a-z]+)').findall(str)          # 前向界定 (?=exp) 找出连续的数字并且最后一个数字跟着至少一个a-z ['111', '333']
re.compile(r"\d+(?![a-z]+)").findall(str)         # 前向否定界定 (?!exp)  找出连续数字，且最后一个数字后不能跟a-z  ['11', '222', '33']
re.compile(r"(?<=[a-z])\d+").findall(str)         # 反向界定 (?<=exp) 逆序环视 找出连续的数字，且第一个数字前面是a-z  ['111', '222']
re.compile(r"(?<![a-z])\d+").findall(str)         # 反向否定界定 (?<!exp) 否定逆序环视  找出连续的数字，且第一个数字前不能是a-z  ['11', '22', '333']
re.compile(r"(?:\d+)").findall(str)               # 无捕获的匹配 (?:exp)
s= 'Tom:9527 , Sharry:0003 '
re.match( r'(?P<name>\w+):(?P<num>\d+)' , s).group(0)   # 捕获组 <num>第二个标签变量[9527] 获取 group("num") 等同 group(2)[9527], group(0)全部[Tom:9527]
```

### 例子

```python
re.findall(r'a[be]c','123abc456eaec789')         # 返回匹配对象列表 ['abc', 'aec']
re.findall("(.)12[34](..)",a)                    # 取出匹配括号中内容   a='qedqwe123dsf'
re.search("(.)123",a ).group(1)                  # 搜索匹配的取第1个标签
re.match("^(1|2) *(.*) *abc$", str).group(2)     # 取第二个标签
re.match("^(1|2) *(.*) *abc$", str).groups()     # 取所有标签
re.sub('[abc]','A','alex')                       # 替换
for i in re.finditer(r'\d+',s):                  # 迭代
    print(i.group(),i.span())                     #
```

### 搜索网页中UNICODE格式的中文

```python
QueryAdd='http://www.anti-spam.org.cn/Rbl/Query/Result'
Ip='222.129.184.52'
s = requests.post(url=QueryAdd, data={'IP':Ip})
re.findall(u'\u4e2d\u56fd', s.text, re.S)
```

## csv             [访问csv逗号分隔的文件]

### csv读配置文件

```python
# 192.168.1.5,web # 配置文件按逗号分割
list = csv.reader(file('a.csv'))
for line in list:
    print(line)              #  ['192.168.1.5', 'web']
```

### csv配合with读文件

```python
import csv
with open('some.csv', 'rb') as f:
    reader = csv.reader(f)
    for row in reader:
        print(row)
```

### csv配合with写文件

```python
import csv
with open('some.csv', 'wb') as f:
    writer = csv.writer(f)
    writer.writerow(['Column1', 'Column2', 'Column3'])    # 写单行 列表
    writer.writerows([range(3) for i in range(5)])        # 写多行 列表套列表
```

## shutil          [提供高级文件访问功能]

```python
import shutil
shutil.copyfile('data.db', 'archive.db')             # 拷贝文件
shutil.move('/build/executables', 'installdir')      # 移动文件或目录
```

## dircache        [目录文件列表缓存]

```python
import dircache
a = dircache.listdir('/data/xuesong')        # 列出目录下所有的文件和目录
dircache.annotate('/data/xuesong', a)        # 判断指定目录下的是文件还是目录,目录则后面加/ 文件或不存在则不改变
```

## glob            [文件通配符]

```python
import glob
glob.glob('*.py')    # 查找当前目录下py结尾的文件
```

## random          [随机模块]

```python
import random
random.choice(['apple', 'pear', 'banana'])   # 随机取列表一个参数
random.sample(xrange(100), 10)  # 不重复抽取10个
random.random()                 # 随机浮点数
random.randrange(6)             # 随机整数范围
```

## tempfile        [创建临时文件]

```python
import os
import tempfile

temp = tempfile.TemporaryFile()                # 定义一个临时文件对象
try:
temp.write('Some data')                    # 写入数据
    temp.writelines(['first\n', 'second\n'])   # 写入多行
temp.seek(0)                               # 写入

print(temp.read()                          # 读取
for line in temp:                          # 循环读取每一行
    print(line.rstrip())
finally:
    temp.close()                               # 关闭后删除临时文件
```

# 创建临时目录
import os
import tempfile

directory_name = tempfile.mkdtemp()
print(directory_name                            # 打印临时目录地址 /var/folders...
# Clean up the directory yourself
os.removedirs(directory_name)                   # 创建临时目录需要手动删除


# 控制临时文件名
import tempfile
temp = tempfile.NamedTemporaryFile(suffix='_suffix',  prefix='prefix_',  dir='/tmp')
try:
    print('temp:', temp)
    print('temp.name:', temp.name)
finally:
    temp.close()

## email           [发送邮件]

### 发送邮件内容

```python
#!/usr/bin/python
#encoding:utf8
# 导入 smtplib 和 MIMEText
import smtplib
from email.mime.text import MIMEText

# 定义发送列表
mailto_list=["272121935@qq.com","272121935@163.com"]

# 设置服务器名称、用户名、密码以及邮件后缀
mail_host = "smtp.163.com"
mail_user = "mailuser"
mail_pass = "password"
mail_postfix="163.com"

# 发送邮件函数
def send_mail(to_list, sub):
    me = mail_user + "<"+mail_user+"@"+mail_postfix+">"
    fp = open('context.txt')
    msg = MIMEText(fp.read(),_charset="utf-8")
    fp.close()
    msg['Subject'] = sub
    msg['From'] = me
    msg['To'] = ";".join(to_list)
    try:
        send_smtp = smtplib.SMTP()
        send_smtp.connect(mail_host)
        send_smtp.login(mail_user+"@"+mail_postfix, mail_pass)
        send_smtp.sendmail(me, to_list, msg.as_string())
        send_smtp.close()
        return True
    except Exception, e:
        print(str(e))
        return False

if send_mail(mailto_list,"标题"):
    print("测试成功")
else:
    print("测试失败")
```

### 发送附件

```python
#!/usr/bin/python
#encoding:utf8
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders

def send_mail(to_list, sub, filename):
    me = mail_user + "<"+mail_user+"@"+mail_postfix+">"
    msg = MIMEMultipart()
    msg['Subject'] = sub
    msg['From'] = me
    msg['To'] = ";".join(to_list)
    submsg = MIMEBase('application', 'x-xz')
    submsg.set_payload(open(filename,'rb').read())
    encoders.encode_base64(submsg)
    submsg.add_header('Content-Disposition', 'attachment', filename=filename)
    msg.attach(submsg)
    try:
        send_smtp = smtplib.SMTP()
        send_smtp.connect(mail_host)
        send_smtp.login(mail_user, mail_pass)
        send_smtp.sendmail(me, to_list, msg.as_string())
        send_smtp.close()
        return True
    except Exception, e:
        print(str(e)[1])
        return False
```

### 设置服务器名称、用户名、密码以及邮件后缀

```python
mail_host = "smtp.163.com"
mail_user = "xuesong"
mail_pass = "mailpasswd"
mail_postfix = "163.com"
mailto_list = ["272121935@qq.com","quanzhou722@163.com"]
title = 'check'
filename = 'file_check.html'
if send_mail(mailto_list,title,filename):
    print("发送成功")
else:
    print("发送失败")
```

## gzip            [解压缩gzip 删除原文件]

```python
#压缩gzip
import gzip
f_in = open('file.log', 'rb')
f_out = gzip.open('file.log.gz', 'wb')
f_out.writelines(f_in)
f_out.close()
f_in.close()

#压缩gzip
File = 'xuesong_18.log'
g = gzip.GzipFile(filename="", mode='wb', compresslevel=9, fileobj=open((r'%s.gz' %File),'wb'))
g.write(open(r'%s' %File).read())
g.close()

#解压gzip
g = gzip.GzipFile(mode='rb', fileobj=open((r'log_01.log.gz'),'rb'))
open((r'xuesong_18.log'),'wb').write(g.read())
```

## tarfile         [归档压缩tar.gz 保留原文件]

```python
# 压缩tar.gz
import os
import tarfile
tar = tarfile.open("/tmp/tartest.tar.gz","w:gz")   # 创建压缩包名
for path,dir,files in os.walk("/tmp/tartest"):     # 递归文件目录
    for file in files:
        fullpath = os.path.join(path,file)
        tar.add(fullpath)                          # 创建压缩包
tar.close()

# 解压tar.gz
import tarfile
tar = tarfile.open("/tmp/tartest.tar.gz")
#tar.extract("/tmp")                               # 全部解压到指定路径
names = tar.getnames()                             # 包内文件名
for name in names:
    tar.extract(name,path="./")                    # 解压指定文件
tar.close()
```

## zipfile         [解压缩zip 最大2G]

```python
import zipfile,os
f = zipfile.ZipFile('filename.zip', 'w' ,zipfile.ZIP_DEFLATED)    # ZIP_STORE 为默认表不压缩. ZIP_DEFLATED 表压缩
#f.write('file1.txt')                              # 将文件写入压缩包
for path,dir,files in os.walk("tartest"):          # 递归压缩目录
    for file in files:
        f.write(os.path.join(path,file))           # 将文件逐个写入压缩包
f.close()

# 解压zip
if zipfile.is_zipfile('filename.zip'):             # 判断一个文件是不是zip文件
    f = zipfile.ZipFile('filename.zip')
    for file in f.namelist():                      # 返回文件列表
        f.extract(file, r'/tmp/')                  # 解压指定文件
    #f.extractall()                                # 解压全部
    f.close()
```
# 压缩zip


## time/datetime   [时间]

```python
import time
time.strftime('%Y%m%d_%H%M')         # 格式化时间
time.time()                          # 时间戳[浮点]
int(time.time())                     # 时间戳[整s]
time.localtime()[1] - 1              # 上个月
time.strftime('%Y-%m-%d_%X',time.localtime( time.time() ) )              # 时间戳转日期
time.mktime(time.strptime('2012-03-28 06:53:40', '%Y-%m-%d %H:%M:%S'))   # 日期转时间戳
```

### 最近的周五

```python
from datetime import datetime
from dateutil.relativedelta import relativedelta, FR
(datetime.now() + relativedelta(weekday=FR(-1))).strftime('%Y%m%d')
```

### 获取本周一

```python
import  datetime
datetime.date.today() - datetime.timedelta(days=datetime.date.today().weekday())
```

### 判断输入时间格式是否正确

```python
#encoding:utf8
import time
while 1:
    atime=raw_input('输入格式如[14.05.13 13:00]:')
    try:
        btime=time.mktime(time.strptime('%s:00' %atime, '%y.%m.%d %H:%M:%S'))
        break
    except:
        print('时间输入错误,请重新输入，格式如[14.05.13 13:00]')
```


### 上一个月最后一天

```python
import datetime
lastMonth=datetime.date(datetime.date.today().year,datetime.date.today().month,1)-datetime.timedelta(1)
lastMonth.strftime("%Y/%m")
```

### 前一天

```python
import datetime
(datetime.datetime.now() + datetime.timedelta(days=-1) ).strftime('%Y%m%d')
```

### 两日期相差天数

```python
import datetime
d1 = datetime.datetime(2005, 2, 16)
d2 = datetime.datetime(2004, 12, 31)
(d1 - d2).days
```

### 向后加10个小时

```python
import datetime
d1 = datetime.datetime.now()
d3 = d1 + datetime.timedelta(hours=10)
d3.ctime()
```

## optparse        [解析参数及标准提示]

```python
import os, sys
import time
import optparse
# python aaa.py -t file -p /etc/opt -o aaaaa

def do_fiotest( type, path, output,):
    print(type, path, output)

def main():
    parser = optparse.OptionParser()
    parser.add_option('-t', '--type', dest = 'type', default = None, help = 'test type[file, device]')
    parser.add_option('-p', '--path', dest = 'path', default = None, help = 'test file path or device path')
    parser.add_option('-o', '--output', dest = 'output', default = None, help = 'result dir path')

    (o, a) = parser.parse_args()

    if None == o.type or None == o.path or None == o.output:
        print("No device or file or output dir")
        return -1

    if 'file' != o.type and 'device' != o.type:
        print("You need specify test type ['file' or 'device']")
        return -1

    do_fiotest(o.type, o.path, o.output)
    print("Test done!")


if __name__ == '__main__':
    main()
```

## getopt          [解析参数]

```shell
import sys,os
import getopt

try:
    options,argsErr = getopt.getopt(sys.argv[1:],"hu:c:",["help","user=","cmd="])    # 中间短参数，后面长参数对应. 不带:或=代表不带参数
except getopt.GetoptError:
    print("Unknown parameters,More info with: %s -h" %(sys.argv[0]))
    sys.exit(2)
if argsErr != []:
    print("Unknown parameters,More info with: %s -h" %(sys.argv[0]))
    sys.exit(2)

for o,a in  options:
    if o in ("-h","--help"):
       print('''Usage: python te.py -u user -c "cmd -options" ''')
       sys.exit(2)
    if o in ("-u","--user"):
       user = a
    if o in ("-c","--cmd"):
       cmd = a
print(user,cmd)

```

## argparse        [命令行选项和参数解析库]

```python
import argparse
parser = argparse.ArgumentParser( prog='usage_name', description='开头打印', epilog="结束打印")
parser.add_argument('-f', '--foo', help='foo help', action='append')      # 可选参数,如使用此参数必须传值 action='store_true' 不加参数为True  action='append' 多个参数可叠加为列表
parser.add_argument('--aa', type=int, default=42, help='aa!')             # type规定参数类型,default设置默认值
parser.add_argument('bar', nargs='*', default=[1, 2, 3], help='BAR!')     # 位置参数 必须传递  nargs=2 需要传递2个参数
parser.add_argument('args', nargs=argparse.REMAINDER)                     # 剩余参数收集到列表
parser.print_help()                                                       # 打印使用帮助
#parser.parse_args('BAR --foo FOO'.split())                               # 设置位置参数
args = parser.parse_args()                                                # 全部的值
parser.get_default('foo')                                                 # 获取
```

```shell
python a.py --foo ww  --aa 40 xuesong 27                                  # 执行此脚本
```

## subprocess      [子进程管理]

```python
import subprocess
s=subprocess.Popen('sleep 20', shell=True, \
        stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.PIPE)
print(s.wait())         # 阻塞等待子进程完成并返回状态码 shell 0为正确  但管道内容过多会造成死锁可以用 communicate()
print(s.stdout.read())
print(s.stderr.read())
print(s.communicate())     # 返回元组 (stdout, stderr)  会阻塞等待进程完成 推荐使用
print(s.returncode)        # 返回执行状态码
```

## base64          [编码]

```python
# 简单但容易被直接破解
import base64
s1 = base64.encodestring('hello world')
s2 = base64.decodestring(s1)
```

## uu              [对文件uu编码]

```python
import uu
uu.encode('in_file','out_file')       # 编码
uu.decode('in_file','out_file')       # 解码
```

## binascii        [ascii和二进制编码转换]

## md5             [单向MD5加密]

```python
import md5
m = md5.new('123456').hexdigest()
```

## hashlib         [hash算法库]

```python
import hashlib
m = hashlib.md5()
m.update("Nobody inspects")    # 使用update方法对字符串md5加密
m.digest()                     # 加密后二进制结果
m.hexdigest()                  # 加密后十进制结果
hashlib.new("md5", "string").hexdigest()               # 对字符串加密
hashlib.new("md5", open("file").read()).hexdigest()    # 查看文件MD5值

hashlib.sha224("Nobody inspects the spammish repetition").hexdigest()       # 几种hash算法 sha1  sha224  sha256  sha384  ha512
```

## crypt           [单向加密]

```python
import crypt
import random,string

def getsalt(chars = string.letters+string.digits):
    return random.choice(chars)+random.choice(chars)
salt = getsalt()
print(salt)
print(crypt.crypt('bananas',salt))
```


## pycrypto        [加密]

```python
# https://github.com/dlitz/pycrypto
# SHA256 不可逆散列算法加密
from Crypto.Hash import SHA256
hash = SHA256.new()
hash.update('message')
hash.digest()
```

## AES     # 可逆加密,需要密钥

```python
from Crypto.Cipher import AES
obj = AES.new('This is a key123', AES.MODE_CBC, 'This is an IV456')
message = "The answer is no"
ciphertext = obj.encrypt(message)
print(ciphertext)
# '\xd6\x83\x8dd!VT\x92\xaa`A\x05\xe0\x9b\x8b\xf1'
obj2 = AES.new('This is a key123', AES.MODE_CBC, 'This is an IV456')
obj2.decrypt(ciphertext)
# 'The answer is no'
```
    

## rsa             [公钥加密算法]

```python
# http://www.heikkitoivonen.net/m2crypto/api/M2Crypto.RSA.RSA-class.html

# pip install M2Crypto

from M2Crypto import RSA,BIO                         # help(RSA)
rsa = RSA.gen_key(2048, 'sha1')                      # 设置生成密钥为2048位,1024较不安全,默认算法sha1
rsa.save_key('rsa.priv.pem', None )                  # 生成私钥pem文件
rsa.save_pub_key('rsa.pub.pem')                      # 生成公钥pem文件
rsa.save_key_bio()                                   # 私钥保存到pem格式的M2Crypto.BIO.BIO对象
rsa.save_pub_key_bio()                               # 公钥保存到pem格式的M2Crypto.BIO.BIO对象
priv=RSA.load_key('rsa.priv.pem')                    # 加载私钥文件
pub=RSA.load_pub_key('rsa.pub.pem')                  # 加载公钥文件
rsa.check_key()                                      # 检查key是否初始化
pub_key.public_encrypt('data',RSA.pkcs1_padding)     # 公钥加密
priv_key.private_decrypt('密文',RSA.pkcs1_padding)   # 私钥解密

from M2Crypto import RSA,BIO

rsa = RSA.gen_key(2048, 3, lambda *agr:None)
pub_bio = BIO.MemoryBuffer()
priv_bio = BIO.MemoryBuffer()

rsa.save_pub_key_bio(pub_bio)
rsa.save_key_bio(priv_bio, None)

# print(pub_bio.read_all())
pub_key = RSA.load_pub_key_bio(pub_bio)
priv_key = RSA.load_key_bio(priv_bio)

message = 'i am luchanghong'

encrypted = pub_key.public_encrypt(message, RSA.pkcs1_padding)        # 加密
decrypted = priv_key.private_decrypt(encrypted, RSA.pkcs1_padding)    # 解密

print(decrypted)
```

## getpass         [隐藏输入密码]

```python
import getpass
passwd=getpass.getpass()
```

## string          [字符串类]

```python
import string
string.ascii_letters   # a-zA-Z  ascii的不受语言系统环境变化
string.ascii_lowercase # a-z
string.letters         # a-zA-Z  受系统语言环境变化影响
string.lowercase       # a-z
string.uppercase       # A-Z大小
string.digits          # 0-9
string.printable       # 所有字符
string.whitespace      # 空白字符
```

## Gittle          [python的git库]

```python
# pip install gittle
from gittle import Gittle
repo_path = '/tmp/gittle_bare'
repo_url = 'git://github.com/FriendCode/gittle.git'
repo = Gittle.clone(repo_url, repo_path)
auth = GittleAuth(pkey=key)                           # 认证
Gittle.clone(repo_url, repo_path, auth=auth)
repo = Gittle.clone(repo_url, repo_path, bare=True)   # 克隆仓库没有目录的
repo = Gittle.init(path)                     # 初始化
repo.commits                                 # 获取提交列表
repo.branches                                # 获取分支列表
repo.modified_files                          # 被修改的文件列表
repo.diff('HEAD', 'HEAD~1')                  # 获取最新提交差异
repo.stage('file.txt')                       # 提交文件
repo.stage(['other1.txt', 'other2.txt'])     # 提交文件列表
repo.commit(name="Samy Pesse", email="samy@friendco.de", message="This is a commit")  # 更新信息

repo = Gittle(repo_path, origin_uri=repo_url)
key_file = open('/Users/Me/keys/rsa/private_rsa')
repo.auth(pkey=key_file)
repo.push()                                   # 远端push提交操作

repo = Gittle(repo_path, origin_uri=repo_url)
key_file = open('/Users/Me/keys/rsa/private_rsa')
repo.auth(pkey=key_file)
repo.pull()                                   # 拉取最新分支

repo.create_branch('dev', 'master')           # 创建分支
repo.switch_branch('dev')                     # 切换到分支
repo.create_orphan_branch('NewBranchName')    # 创建一个空的分支
repo.remove_branch('dev')                     # 删除分支

```

## paramiko        [ssh客户端]

### 安装

```shell
sudo apt-get install python-setuptools
easy_install
sudo apt-get install python-all-dev
sudo apt-get install build-essential
```

### paramiko实例(账号密码登录执行命令)

```python
#!/usr/bin/python
#ssh
import paramiko
import sys,os

host = '10.152.15.200'
user = 'peterli'
password = '123456'

s = paramiko.SSHClient()                                 # 绑定实例
s.load_system_host_keys()                                # 加载本地HOST主机文件
s.set_missing_host_key_policy(paramiko.AutoAddPolicy())  # 允许连接不在know_hosts文件中的主机
s.connect(host,22,user,password,timeout=5)               # 连接远程主机
while True:
    cmd=raw_input('cmd:')
    stdin,stdout,stderr = s.exec_command(cmd)        # 执行命令
    cmd_result = stdout.read(),stderr.read()         # 读取命令结果
    for line in cmd_result:
            print(line)
s.close()
```

### paramiko实例(传送文件)

```python
#!/usr/bin/evn python
import os
import paramiko
host='127.0.0.1'
port=22
username = 'peterli'
password = '123456'
ssh=paramiko.Transport((host,port))
privatekeyfile = os.path.expanduser('~/.ssh/id_rsa')
mykey = paramiko.RSAKey.from_private_key_file( os.path.expanduser('~/.ssh/id_rsa'))   # 加载key 不使用key可不加
ssh.connect(username=username,password=password)           # 连接远程主机
# 使用key把 password=password 换成 pkey=mykey
sftp=paramiko.SFTPClient.from_transport(ssh)               # SFTP使用Transport通道
sftp.get('/etc/passwd','pwd1')                             # 下载 两端都要指定文件名
sftp.put('pwd','/tmp/pwd')                                 # 上传
sftp.close()
ssh.close()
```

### paramiko实例(密钥执行命令)

```python
#!/usr/bin/python
#ssh
import paramiko
import sys,os
host = '10.10.15.123'
user = 'peterli'
s = paramiko.SSHClient()
s.load_system_host_keys()
s.set_missing_host_key_policy(paramiko.AutoAddPolicy())
privatekeyfile = os.path.expanduser('~/.ssh/id_rsa')             # 定义key路径
mykey = paramiko.RSAKey.from_private_key_file(privatekeyfile)
# mykey=paramiko.DSSKey.from_private_key_file(privatekeyfile,password='061128')   # DSSKey方式 password是key的密码
s.connect(host,22,user,pkey=mykey,timeout=5)
cmd=raw_input('cmd:')
stdin,stdout,stderr = s.exec_command(cmd)
cmd_result = stdout.read(),stderr.read()
for line in cmd_result:
    print(line)
s.close()
```

### ssh并发(Pool控制最大并发)

```python
#!/usr/bin/env python
#encoding:utf8
#ssh_concurrent.py

import multiprocessing
import sys,os,time
import paramiko

def ssh_cmd(host,port,user,passwd,cmd):
    msg = "-----------Result:%s----------" % host

    s = paramiko.SSHClient()
    s.load_system_host_keys()
    s.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    try:
        s.connect(host,22,user,passwd,timeout=5)
        stdin,stdout,stderr = s.exec_command(cmd)

        cmd_result = stdout.read(),stderr.read()
        print(msg)
        for line in cmd_result:
                print(line)

        s.close()
    except paramiko.AuthenticationException:
        print(msg)
        print('AuthenticationException Failed')
    except paramiko.BadHostKeyException:
        print(msg)
        print("Bad host key")

result = []
p = multiprocessing.Pool(processes=20)
cmd=raw_input('CMD:')
f=open('serverlist.conf')
list = f.readlines()
f.close()
for IP in list:
    print(IP)
    host=IP.split()[0]
    port=int(IP.split()[1])
    user=IP.split()[2]
    passwd=IP.split()[3]
    result.append(p.apply_async(ssh_cmd,(host,port,user,passwd,cmd)))

p.close()

for res in result:
    res.get(timeout=35)
```

### ssh并发(取文件状态并发送邮件)

```python
#!/usr/bin/python
#encoding:utf8
#config file: ip.list

import paramiko
import multiprocessing
import smtplib
import sys,os,time,datetime,socket,re
from email.mime.text import MIMEText

# 配置文件(IP列表)
Conf = 'ip.list'
user_name = 'peterli'
user_pwd = 'passwd'
port = 22
PATH = '/home/peterli/'

# 设置服务器名称、用户名、密码以及邮件后缀
mail_host = "smtp.163.com"
mail_user = "xuesong"
mail_pass = "mailpasswd"
mail_postfix = "163.com"
mailto_list = ["272121935@qq.com","quanzhou722@163.com"]
title = 'file check'

DATE1=(datetime.datetime.now() + datetime.timedelta(days=-1) ).strftime('%Y%m%d')
file_path = '%s%s' %(PATH,DATE1)

def Ssh_Cmd(file_path,host_ip,user_name,user_pwd,port=22):

    s = paramiko.SSHClient()
    s.load_system_host_keys()
    s.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    try:
        s.connect(hostname=host_ip,port=port,username=user_name,password=user_pwd)
        stdin,stdout,stderr = s.exec_command('stat %s' %file_path)
        stat_result = '%s%s' %(stdout.read(),stderr.read())
        if stat_result.find('No such file or directory') == -1:
            file_status = 'OK\t'
            stdin,stdout,stderr = s.exec_command('du -sh %s' %file_path)
            cmd1_result = '%s_%s' %(stat_result.split()[32],stat_result.split()[33].split('.')[0])
            cmd2_result = ('%s%s' %(stdout.read(),stderr.read())).split()[0]
        else:
            file_status = '未生成\t'
            cmd1_result = 'null'
            cmd2_result = 'null'
        q.put(['Login successful'])
        s.close()
    except socket.error:
        file_status = '主机或端口错误'
        cmd1_result = '-'
        cmd2_result = '-'
    except paramiko.AuthenticationException:
        file_status = '用户或密码错误'
        cmd1_result = '-'
        cmd2_result = '-'
    except paramiko.BadHostKeyException:
        file_status = 'Bad host key'
        cmd1_result = '-'
        cmd2_result = '-'
    except:
        file_status = 'ssh异常'
        cmd1_result = '-'
        cmd2_result = '-'
    r.put('%s\t-\t%s\t%s\t%s\t%s\n' %(time.strftime('%Y-%m-%d_%H:%M'),host_ip,file_status,cmd2_result,cmd1_result))

def Concurrent(Conf,file_path,user_name,user_pwd,port):
    # 执行总计
    total = 0
    # 读取配置文件
    f=open(Conf)
    list = f.readlines()
    f.close()
    # 并发执行
    process_list = []
    log_file = file('file_check.log', 'w')
    log_file.write('检查时间\t\t业务\tIP\t\t文件状态\t大小\t生成时间\n')
    for host_info in list:
        # 判断配置文件中注释行跳过
        if host_info.startswith('#'):
            continue
        # 取变量,其中任意变量未取到就跳过执行
        try:
            host_ip=host_info.split()[0].strip()
            #user_name=host_info.split()[1]
            #user_pwd=host_info.split()[2]
        except:
            log_file.write('Profile error: %s\n' %(host_info))
            continue
        #try:
        #    port=int(host_info.split()[3])
        #except:
        #    port=22
        total +=1
        p = multiprocessing.Process(target=Ssh_Cmd,args=(file_path,host_ip,user_name,user_pwd,port))
        p.start()
        process_list.append(p)
    for j in process_list:
        j.join()
    for j in process_list:
        log_file.write(r.get())

    successful = q.qsize()
    log_file.write('执行完毕。 总执行:%s 登录成功:%s 登录失败:%s\n' %(total,successful,total - successful))
    log_file.flush()
    log_file.close()

def send_mail(to_list, sub):
    me = mail_user + "<"+mail_user+"@"+mail_postfix+">"
    fp = open('file_check.log')
    msg = MIMEText(fp.read(),_charset="utf-8")
    fp.close()
    msg['Subject'] = sub
    msg['From'] = me
    msg['To'] = ";".join(to_list)
    try:
        send_smtp = smtplib.SMTP()
        send_smtp.connect(mail_host)
        send_smtp.login(mail_user, mail_pass)
        send_smtp.sendmail(me, to_list, msg.as_string())
        send_smtp.close()
        return True
    except Exception, e:
        print(str(e)[1])
        return False

if __name__ == '__main__':
    q = multiprocessing.Queue()
    r = multiprocessing.Queue()
    Concurrent(Conf,file_path,user_name,user_pwd,port)
    if send_mail(mailto_list,title):
        print("发送成功")
    else:
        print("发送失败")
```

## pysnmp          [snmp客户端]

```python
#!/usr/bin/python
from pysnmp.entity.rfc3413.oneliner import cmdgen

cg = cmdgen.CommandGenerator()

# 注意IP 端口 组默认public  oid值
varBinds = cg.getCmd( cmdgen.CommunityData('any-agent', 'public',0 ), cmdgen.UdpTransportTarget(('10.10.76.42', 161)),    (1,3,6,1,4,1,2021,10,1,3,1), )

print(varBinds[3][0][1])
```


## PDB             [单步调试]

```bash
# 很多程序因为被try了,看不到具体报错的地方, 用这个模块就很清晰可以看到错误的位置
# http://docs.python.org/2/library/pdb.html

(Pdb) h              # 帮助
# 断点设置
(Pdb)b 10            # 断点设置在本py的第10行
(Pdb)b ots.py:20     # 断点设置到 ots.py第20行
(Pdb)b               # 查看断点编号
(Pdb)cl 2            # 删除第2个断点

# 运行
(Pdb)n               # 单步运行
(Pdb)s               # 细点运行 也就是会下到，方法
(Pdb)c               # 跳到下个断点
# 查看
(Pdb)p param         # 查看当前 变量值
(Pdb)l               # 查看运行到某处代码
(Pdb)a               # 查看全部栈内变量
!a = 100             # 直接赋值
```

```bash
python -m pdb myscript.py   # 直接对脚本单步调试
```

### 在程序里面加单步调试

```python
import pdb
def tt():
    pdb.set_trace()
    for i in range(1, 5):
        print(i)
```

```bash
>>> tt()
> <stdin>(3)tt()
(Pdb) n              #这里支持 n p c 而已
```

```

## pstats          [源码性能分析测试]

```python
import profile
import pstats

profile.run("run()", "prof.txt")
p = pstats.Stats("prof.txt")
p.sort_stats("time").print_stats()
```

## apscheduler     [任务调度]

```python
# 安装   pip install apscheduler
# 例子   https://bitbucket.org/agronholm/apscheduler/src/e6298f953a68/tests/?at=master

scheduler.start()                                                   # 启动任务
job = scheduler.add_job(myfunc, 'interval', minutes=2)              # 添加任务
job.remove()                                                        # 删除任务
scheduler.add_job(myfunc, 'interval', minutes=2, id='my_job_id')    # 添加任务
scheduler.remove_job('my_job_id')                                   # 删除任务
job.modify(max_instances=6, name='Alternate name')                  # 修改工作
scheduler.shutdown()                                                # 关闭调度
scheduler.shutdown(wait=False)                                      # 关闭调度  不等待
# 暂停
apscheduler.job.Job.pause()
apscheduler.schedulers.base.BaseScheduler.pause_job()
# 恢复
apscheduler.job.Job.resume()
apscheduler.schedulers.base.BaseScheduler.resume_job()
```

### 定时任务

```python
from pytz import utc
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.executors.pool import ThreadPoolExecutor, ProcessPoolExecutor
import time

executors = {
    'default': ThreadPoolExecutor(20),
    'processpool': ProcessPoolExecutor(5)
}
job_defaults = {
    'coalesce': False,
    'max_instances': 3
}
scheduler = BackgroundScheduler( executors=executors, job_defaults=job_defaults, timezone=utc)

def myfunc():
    print('test')

scheduler.add_job(myfunc, 'interval', minutes=1, id='myworkid')
scheduler.start()

try:
    while True:
        time.sleep(2)
        # add_job
except (KeyboardInterrupt, SystemExit):
    scheduler.shutdown()
```

## logging         [日志记录]

```python
# 日志级别大小关系为: critical > error > warning > info > debug > notset  也可自定义日志级别
import logging
logging.debug('debug')                 # 默认日志级别为 warning ,故debug日志不做打印
logging.warning('warning')             # 达到默认日志级别为WARNING,打印到屏幕 warning
logging.basicConfig                    # 通过logging.basicConfig函数对日志的输出格式及方式做相关配置
    # basicConfig 相关参数帮助
    filename               # 指定日志文件名
    filemode               # 和file函数意义相同，指定日志文件的打开模式，'w'或'a'
    datefmt                # 指定时间格式，同time.strftime()
    level                  # 设置日志级别，默认为logging.WARNING
    stream                 # 指定将日志的输出流，可以指定输出到sys.stderr,sys.stdout或者文件，默认输出到sys.stderr，当stream和filename同时指定时，stream被忽略
    format                 # 指定输出的格式和内容，format可以输出很多有用信息，如上例所示:
        %(levelno)s        # 打印日志级别的数值
        %(levelname)s      # 打印日志级别名称
        %(pathname)s       # 打印当前执行程序的路径，其实就是sys.argv[0]
        %(filename)s       # 打印当前执行程序名
        %(funcName)s       # 打印日志的当前函数
        %(lineno)d         # 打印日志的当前行号
        %(asctime)s        # 打印日志的时间
        %(thread)d         # 打印线程ID
        %(threadName)s     # 打印线程名称
        %(process)d        # 打印进程ID
        %(message)s        # 打印日志信息


logging.config.fileConfig("logger.conf")        # 加载配置文件
logger = logging.getLogger("example02")         # 使用已定义的日志记录器
logger.conf                                     # 配置文件
    ###############################################
    [loggers]
    keys=root,example01,example02    # 设置三种日志记录器
    [logger_root]                    # 针对单一种设置
    level=DEBUG
    handlers=hand01,hand02
    [logger_example01]
    handlers=hand01,hand02           # 使用2中处理方式 应该是根据不同级别区分的
    qualname=example01
    propagate=0
    [logger_example02]
    handlers=hand01,hand03
    qualname=example02
    propagate=0
    ###############################################
    [handlers]                      # 不同的处理方式
    keys=hand01,hand02,hand03       # 三种方式的名字
    [handler_hand01]                # 第一种方式配置
    class=StreamHandler             # 发送错误信息到流
    level=INFO                      # 日志级别
    formatter=form02                # 日志的格式方式
    args=(sys.stderr,)
    [handler_hand02]
    class=FileHandler               # FileHandler写入磁盘文件
    level=DEBUG
    formatter=form01
    args=('myapp.log', 'a')         # 追加到日志文件
    [handler_hand03]
    class=handlers.RotatingFileHandler
    level=INFO
    formatter=form02
    args=('myapp.log', 'a', 10*1024*1024, 5)    # 追加日志并切割日志
    ###############################################
    [formatters]                                # 针对不同处理日志方式设置具体的日志格式
    keys=form01,form02
    [formatter_form01]
    format=%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s    # 日志列
    datefmt=%a, %d %b %Y %H:%M:%S               # 时间格式
    [formatter_form02]
    format=%(name)-12s: %(levelname)-8s %(message)s
    datefmt=
```

### 通用日志记录

```python
import logging

    logging.basicConfig(level=logging.DEBUG,
                    format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
                    datefmt='%Y-%m-%d %H:%M:%S',
                    filename='/var/log/myapp.log',
                    filemode='a')
    # 日志级别DEBUG或高于DEBUG的会写入文件 myapp.log 中
    logging.debug('debug message')
    logging.info('info message')
    logging.warning('warning message')
```

## ConfigParser    [配置解析]

### 写入配置文件

```python
import ConfigParser
config = ConfigParser.RawConfigParser()
config.add_section('Section1')                          # 添加配置文件的块 [name]
config.set('Section1', 'an_int', '15')                  # 针对块设置配置参数和值
config.set('Section1', 'a_bool', 'true')
config.set('Section1', 'a_float', '3.1415')
config.set('Section1', 'baz', 'fun')
config.set('Section1', 'bar', 'Python')
config.set('Section1', 'foo', '%(bar)s is %(baz)s!')
with open('example.cfg', 'wb') as configfile:           # 指定配置文件路径
    config.write(configfile)                            # 写入配置文件
```

### 读取配置文件

```python
import ConfigParser
config = ConfigParser.RawConfigParser()
config.read('example.cfg')                              # 读取配置文件
a_float = config.getfloat('Section1', 'a_float')        # 获取配置文件参数对应的浮点值,如参数值类型不对则报ValueError
an_int = config.getint('Section1', 'an_int')            # 获取配置文件参数对应的整数值,可直接进行计算
print(a_float + an_int)
if config.getboolean('Section1', 'a_bool'):             # 根据配置文件参数值是否为真
    print(config.get('Section1', 'foo'))                 # 再获取依赖的配置参数 get获取后值为字符串
print(config.get('Section1', 'foo', 0))                  # 获取配置文件参数的同时加载变量[配置文件中的参数]
print(config.get('Section1', 'foo', 1))                  # 获取配置文件参数 原始值不做任何改动 不使用变量
config.remove_option('Section1', 'bar')                 # 删除读取配置文件获取bar的值
config.remove_option('Section1', 'baz')
print(config.get('Section1', 'foo', 0, {'bar': 'str1', 'baz': 'str1'}))    # 读取配置参数的同时设置变量的值
```

```python
import ConfigParser
import io

sample_config = """
[mysqld]
user = mysql
pid-file = /var/run/mysqld/mysqld.pid
skip-external-locking
old_passwords = 1
skip-bdb
skip-innodb
"""
config = ConfigParser.RawConfigParser(allow_no_value=True)
config.readfp(io.BytesIO(sample_config))
config.get("mysqld", "user")
```


## ftplib          [ftp客户端]

```python
from ftplib import FTP
ftp = FTP('ftp.debian.org')     # 连接ftp地址   FTP(host,port,timeout)
ftp.login()                     # 使用默认anonymous登录  login(user,passwd)
ftp.cwd('debian')               # 切换到目录debian
ftp.retrlines('LIST')           # 打印目录列表
ftp.retrbinary('RETR README', open('README', 'wb').write)       # 下载文件写到本地
ftp.delete('filename')          # 删除ftp中文件
ftp.mkd('dirname')              # 在ftp上创建目录
ftp.size('filename')            # 查看文件大小
ftp.quit()
```


## difflib         [对象比较]

```python
import difflib
s1 = ['bacon\n', 'eggs\n', 'ham\n', 'guido\n']
s2 = ['python\n', 'eggy\n', 'hamster\n', 'guido\n']
for line in difflib.context_diff(s1, s2, fromfile='txt-s1', tofile='txt-s2'):    # 两字列表比较差异
    sys.stdout.write(line)

difflib.get_close_matches('appel', ['ape', 'apple', 'peach', 'puppy'])           # 模糊匹配 匹配列表与字符串相似的值，越相似越靠前
```


## heapq           [优先队列算法]

```python
from heapq import *
h = []
heappush(h, (5, 'write code'))          # 放入队列
heappush(h, (7, 'release product'))
heappush(h, (1, 'write spec'))
heappush(h, (3, 'create tests'))
heappop(h)                              # 从队列取出 第一次是1

from heapq import *
def heapsort(iterable):
    h = []
    for value in iterable:
        heappush(h, value)
    return [heappop(h) for i in range(len(h))]

heapsort([1, 3, 5, 7, 9, 2, 4, 6, 8, 0])
```

## linecache       [随机读取指定行]

```python
import linecache
linecache.getline('/etc/passwd', 4)
```


## json            [数据交换格式]

```python
#!/usr/bin/python
import json

#json file temp.json
#{ "name":"00_sample_case1", "description":"an example."}

f = file("temp.json");
s = json.load(f)        # 直接读取json文件
print(s)
f.close

d = {"a":1}
j=json.dumps(d)  # 字典转json
json.loads(j)    # json转字典

s = json.loads('{"name":"test", "type":{"name":"seq", "parameter":["1", "2"]}}')
print(type(s))    # dic
print(s)
print(s.keys())
print(s["type"]["parameter"][1])

json.dumps({'ret':'cmd_ret0', 'out':'cmd_ret1'}, separators=(',', ':'))    # 紧凑的json格式,去掉空格
```


## filecmp         [文件目录比较]

```python
filecmp.cmp('/etc/passwd', '/etc/passwd')     # 比较两文件是否一致

# 比较两目录下文件是否一致
from filecmp import dircmp
def print_diff_files(dcmp):
    for name in dcmp.diff_files:
        print("diff_file %s found in %s and %s" % (name, dcmp.left, dcmp.right))
    for sub_dcmp in dcmp.subdirs.values():
        print_diff_files(sub_dcmp)

dcmp = dircmp('dir1', 'dir2')
print_diff_files(dcmp)
```


## errno           [符号错误码]

```python
# https://docs.python.org/2/library/errno.html#module-errno

import errno

try:
    fp = open("no.such.file")
except IOError, (error, message):
    if error == errno.ENOENT:
        print("no such file")
    elif error == errno.EPERM:
        print("permission denied")
    else:
        print(message)
```


## Exceptions      [标准异常类]

```python
# 详见官网 不需要导入
# https://docs.python.org/2/library/exceptions.html#module-exceptions
```

## ctypes          [调用C的动态库]

```python
# 提供和C语言兼容的数据类型,也可调用C的动态库

# http://blog.csdn.net/linda1000/article/details/12623527
# http://www.cnblogs.com/wuchang/archive/2010/04/04/1704456.html
# http://www.ibm.com/developerworks/cn/linux/l-cn-pythonandc/
```


## daemon          [守护进程]

### daemon.py

```python
# 创建守护进程的模块
#!/usr/bin/env python

import sys, os, time, atexit
from signal import SIGTERM

class Daemon:
    """
    A generic daemon class.

    Usage: subclass the Daemon class and override the run() method
    """
    def __init__(self, pidfile='nbMon.pid', stdin='/dev/null', stdout='nbMon.log', stderr='nbMon.log'):
        self.stdin = stdin
        self.stdout = stdout
        self.stderr = stderr
        self.pidfile = pidfile

    def daemonize(self):
        """
        do the UNIX double-fork magic, see Stevens' "Advanced
        Programming in the UNIX Environment" for details (ISBN 0201563177)
        http://www.erlenstar.demon.co.uk/unix/faq_2.html#SEC16
        """
        try:
            pid = os.fork()
            if pid > 0:
                # exit first parent
                sys.exit(0)
        except OSError, e:
            sys.stderr.write("fork #1 failed: %d (%s)\n" % (e.errno, e.strerror))
            sys.exit(1)

        # decouple from parent environment
        #os.chdir("/")
        os.setsid()
        os.umask(0)

        # do second fork
        try:
            pid = os.fork()
            if pid > 0:
                # exit from second parent
                sys.exit(0)
        except OSError, e:
            sys.stderr.write("fork #2 failed: %d (%s)\n" % (e.errno, e.strerror))
            sys.exit(1)

        # redirect standard file descriptors
        sys.stdout.flush()
        sys.stderr.flush()
        si = file(self.stdin, 'r')
        so = file(self.stdout, 'a+')
        se = file(self.stderr, 'a+', 0)
        os.dup2(si.fileno(), sys.stdin.fileno())
        os.dup2(so.fileno(), sys.stdout.fileno())
        os.dup2(se.fileno(), sys.stderr.fileno())

        # write pidfile
        atexit.register(self.delpid)
        pid = str(os.getpid())
        file(self.pidfile,'w+').write("%s\n" % pid)

    def delpid(self):
        os.remove(self.pidfile)

    def start(self):
        """
        Start the daemon
        """
        # Check for a pidfile to see if the daemon already runs
        try:
            pf = file(self.pidfile,'r')
            pid = int(pf.read().strip())
            pf.close()
        except IOError:
            pid = None

        if pid:
            message = "pidfile %s already exist. Daemon already running?\n"
            sys.stderr.write(message % self.pidfile)
            sys.exit(1)

        # Start the daemon
        self.daemonize()
        self.run()

    def stop(self):
        """
        Stop the daemon
        """
        # Get the pid from the pidfile
        try:
            pf = file(self.pidfile,'r')
            pid = int(pf.read().strip())
            pf.close()
        except IOError:
            pid = None

        if not pid:
            message = "pidfile %s does not exist. Daemon not running?\n"
            sys.stderr.write(message % self.pidfile)
            return # not an error in a restart

        # Try killing the daemon process
        try:
            while 1:
                os.kill(pid, SIGTERM)
                time.sleep(0.1)
        except OSError, err:
            err = str(err)
            if err.find("No such process") > 0:
                if os.path.exists(self.pidfile):
                    os.remove(self.pidfile)
            else:
                print(str(err))
                sys.exit(1)

    def restart(self):
        """
        Restart the daemon
        """
        self.stop()
        self.start()

    def run(self):
        """
        You should override this method when you subclass Daemon. It will be called after the process has been
        daemonized by start() or restart().
        """
```

### run_daemon.py

```python
# 启动脚本,倒入需要后台启动的模块,继承Daemon类,覆盖run函数
# 启动方式  python run_daemon.py start

#!/usr/bin/env python
import Queue
import threading
import sys, time
import urllib2
import json
import framework
from moniItems import mon
from daemon import Daemon

class MyDaemon(Daemon):
    def run(self):
        print('start')
        framework.startTh()
        print('stop2')

if __name__ == "__main__":
    daemon = MyDaemon()
    if len(sys.argv) == 2:
        if 'start' == sys.argv[1]:
            daemon.start()
        elif 'stop' == sys.argv[1]:
            daemon.stop()
        elif 'restart' == sys.argv[1]:
            daemon.restart()
        else:
            print("Unknown command")
            sys.exit(2)
        sys.exit(0)
    else:
        print("usage: %s start|stop|restart" % sys.argv[0])
        sys.exit(2)

```
    
## psutil          [获取系统信息]

```python
# pip install psutil                     # 安装

import psutil
dir(psutil)
psutil.boot_time()                     # 开机时间
psutil.virtual_memory()                # 内存详细信息
psutil.virtual_memory().total          # 内存总大小
psutil.disk_partitions()               # 获取磁盘信息
psutil.disk_io_counters()              # 磁盘IO信息
psutil.net_io_counters()               # 获取网络IO信息

psutil.pids()                          # 返回所有进程PID
psutil.Process(PID)                    # 获取进程信息
psutil.Process(PID).name()             # 指定进程的进程名
psutil.Process(PID).exe()              # 进程的路径
psutil.Process(PID).cwd()              # 进程工作路径
psutil.Process(PID).status()           # 进程状态
psutil.Process(PID).create_time()      # 进程创建时间
psutil.Process(PID).memory_percent()   # 进程内存使用率
psutil.Process(PID).io_counters()      # 进程IO信息
psutil.Process(PID).num_threads()      # 进程线程数
```

## ldap            [统一认证]

```python
# yum install openldap  openldap-clients openldap-devel openssl-devel setuptools==30.1.0
# sudo pip uninstall ldap ldap3
# pip install python-ldap
import ldap
con = ldap.initialize("ldap://10.10.10.156:389")
con.simple_bind_s("cn=admin,ou=People,dc=gt,dc=com", "pwd")
res = con.search_s("dc=gt,dc=com", ldap.SCOPE_SUBTREE, '(uid=*)', ['*', '+'], 0)
```

## watchdog        [监视文件实时写入]

```python
# https://pypi.python.org/pypi/watchdog
# pip install watchdog

import sys
import time
import logging
from watchdog.observers import Observer
from watchdog.events import LoggingEventHandler

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(message)s',
                        datefmt='%Y-%m-%d %H:%M:%S')
    path = sys.argv[1] if len(sys.argv) > 1 else '.'
    event_handler = LoggingEventHandler()
    observer = Observer()
    observer.schedule(event_handler, path, recursive=True)
    observer.start()
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
```

## yaml            [标记语言]

```python
# pip  install  pyyaml

import yaml

a = yaml.load("""
name: Vorlin Laruknuzum
sex: Male
class: Priest
title: Acolyte
hp: [32, 71]
sp: [1, 13]
gold: 423
inventory:
- a Holy Book of Prayers (Words of Wisdom)
- an Azure Potion of Cure Light Wounds
- a Silver Wand of Wonder
""")

print(a['inventory'][1])     # 字典
print(yaml.dump(a))          # 把字典生成yaml文件
yaml.load_all               # 生成迭代器

print(yaml.dump({'name': "The Cloak 'Colluin'", 'depth': 5, 'rarity': 45,'weight': 10, 'cost': 50000, 'flags': ['INT', 'WIS', 'SPEED', 'STEALTH']}))
```


## itertools       [迭代功能函数]

```python
import itertools
# 全排序
print(list(itertools.permutations(['a', 'b', 'c', 'd'],4)))

# 无限迭代
ns = itertools.count(1)
for n in ns:
    print(n)

# 指定次数循环
ns = itertools.repeat('A', 10)
for n in ns:
    print(n)
```
