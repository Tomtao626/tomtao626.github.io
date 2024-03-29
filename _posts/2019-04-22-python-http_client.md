---
layout: mypost
title: Python-HTTP
categories: [Python, HTTP]
---

## rllib2        [网络资源访问]

```python
import urllib2
response = urllib2.urlopen('http://baidu.com')
print(response.geturl())       # url
headers = response.info()
print(headers)                 # web页面头部信息
print(headers['date'])         # 头部信息中的时间
date = response.read()        # 返回页面所有信息[字符串]
# date = response.readlines() # 返回页面所有信息[列表]

for i in urllib2.urlopen('http://qq.com'):    # 可直接迭代
    print(i)
```


### 下载文件

```python
#!/usr/bin/env python
#encoding:utf8
import urllib2

url = 'http://www.01happy.com/wp-content/uploads/2012/09/bg.png'
file("./pic/%04d.png" % i, "wb").write(urllib2.urlopen(url).read())
```

### 抓取网页解析指定内容

```python
#!/usr/bin/env python
#encoding:utf8

import urllib2
import urllib
import random
from bs4 import BeautifulSoup

url='http://www.aaammm.com/aaa/'

ua=["Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)",
"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)",
"Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2; .NET4.0C; .NET4.0E)",
"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36",
"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36",
"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36",
"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36",
"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36",
"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36",
"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36",
"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36",
"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Firefox/31.0",
"Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36"]

browser = random.choice(ua)

req_header = {'User-Agent':browser,
'Accept':'text/html;q=0.9,*/*;q=0.8',
'Cookie':'BAIDUID=4C8274B52CFB79DEB4FBA9A7EC76A1BC:FG=1; BDUSS=1dCdU1WNFdxUll0R09XcnBZTkRrVVVNbWVnSkRKSVRPeVljOUswclBoLUNzVEpVQVFBQUFBJCQAAAAAAAAAAAEAAADEuZ8BcXVhbnpob3U3MjIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIIIkC1SCJAtUY; BD_UPN=123143; BD_HOME=1',    # 添真实登陆后的Cookie 谷歌浏览器[F12  Network  Documents  Headers]
'Accept-Charset':'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
'Connection':'close',
}
#data = urllib.urlencode({'name':'xuesong','id':'30' })          # urllib 的处理参数的方法，可以再urllib2中使用
data = urllib2.quote("pgv_ref=im.perinfo.perinfo.icon&rrr=pppp")
req_timeout = 10
try:
    req = urllib2.Request(url,data=data,headers=req_header)      # data为None 则方法为get，有date为post方法
    html = urllib2.urlopen(req,data=None,req_timeout).read()
except urllib2.HTTPError as err:
    print(str(err))
except:
    print("timeout")
print(html)

# 百度带Cookie后查看自己的用户
#for i in html.split('\n'):
#    if 'bds.comm.user=' in i:
#        print(i)

soup = BeautifulSoup(html)
for i in  soup.find_all(target="_blank",attrs={"class": "usr-pic"}):   # 条件看情况选择
    if i.img:
        print(i.get('href'))
```

### 模拟浏览器访问web页面 python3

```python
#! /usr/bin/env python
# -*- coding=utf-8 -*-
import urllib.request

url = "http://www.baidu.com"
# AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11
headers = {'User-Agent':'Mozilla/5.0 (Windows NT 6.1)',
    'Accept':'text/html;q=0.9,*/*;q=0.8',
    'Accept-Charset':'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
    'Connection':'close',
    'Referer':None #注意如果依然不能抓取的话，这里可以设置抓取网站的host
}

opener = urllib.request.build_opener()
opener.addheaders = [headers]
data = opener.open(url).read()

print(data)
```

## requests       [替代urllib2]

```python
# Requests是一个Python的HTTP客户端库
# 官方中文文档 http://cn.python-requests.org/zh_CN/latest/user/quickstart.html#id2
# 安装: sudo pip install requests
import requests

# 使用 logging 库时忽略 requests 库的日志
logging.getLogger("requests").setLevel(logging.WARNING)
logging.getLogger("urllib3").setLevel(logging.WARNING)

# get方法提交表单
url = r'http://dict.youdao.com/search?le=eng&q={0}'.format(word.strip())
r = requests.get(url,timeout=2)

# get方法带参数 http://httpbin.org/get?key=val
payload = {'key1': 'value1', 'key2': 'value2'}
r = requests.get("http://httpbin.org/get", params=payload)

# post方法提交表单
QueryAdd='http://www.anti-spam.org.cn/Rbl/Query/Result'
r = requests.post(url=QueryAdd, data={'IP':'211.211.54.54'})

# 定制请求头post请求
payload = {'some': 'data'}
headers = {'content-type': 'application/json'}
r = requests.post(url, data=json.dumps(payload), headers=headers)

# https 需登录加auth
r = requests.get('https://baidu.com', auth=('user', 'pass'))

if r.ok:    # 判断请求是否正常
    print(r.url)             # u'http://httpbin.org/get?key2=value2&key1=value1'
    print(r.status_code)     # 状态码
    print(r.content)         # 获取到的原始内容  可使用 BeautifulSoup4 解析处理判定结果
    print(r.text)            # 把原始内容转unicode编码
    print(r.headers)         # 响应头
    print(r.headers['content-type'])          # 网页头信息 不存在为None
    print(r.cookies['example_cookie_name'])   # 查看cookie
    print(r.history)         # 追踪重定向 [<Response [301]>]  开启重定向 allow_redirects=True
```

### 获取JSON

```python
import requests
r = requests.get('https://github.com/timeline.json')
r.json()
```
    

### 获取图片

```python
import requests
from PIL import Image
from StringIO import StringIO
i = Image.open(StringIO(r.content))
```

### 发送cookies到服务器

```python
import requests
url = 'http://httpbin.org/cookies'
cookies = dict(cookies_are='working')
r = requests.get(url, cookies=cookies)
print(r.text) 
# '{"cookies": {"cookies_are": "working"}}'
```

### 在同一个Session实例发出的所有请求之间保持cookies

```python
import requests
s = requests.Session()
s.get('http://httpbin.org/cookies/set/sessioncookie/123456789')
r = s.get("http://httpbin.org/cookies")
print(r.text)
```

### 会话对象能够跨请求保持某些参数

```python
import requests
s = requests.Session()
s.auth = ('user', 'pass')
s.headers.update({'x-test': 'true'})
s.get('http://httpbin.org/headers', headers={'x-test2': 'true'})  
# both 'x-test' and 'x-test2' are sent
```

### ssl证书验证

```python
import requests
requests.get('https://github.com', verify=True)
requests.get('https://kennethreitz.com', verify=False)   # 忽略证书验证
requests.get('https://kennethreitz.com', cert=('/path/server.crt', '/path/key'))   # 本地指定一个证书 正确 <Response [200]>  错误 SSLError
```

### 流式上传

```python
import requests
with open('massive-body') as f:
    requests.post('http://some.url/streamed', data=f)
```

### 流式请求

```python
import requests
import json

r = requests.post('https://stream.twitter.com/1/statuses/filter.json',
    data={'track': 'requests'}, auth=('username', 'password'), stream=True)

for line in r.iter_lines():
    if line: # filter out keep-alive new lines
        print(json.loads(line))
```

### 自定义身份验证

```python
from requests.auth import AuthBase
class PizzaAuth(AuthBase):
    """Attaches HTTP Pizza Authentication to the given Request object."""
    def __init__(self, username):
        # setup any auth-related data here
        self.username = username
    def __call__(self, r):
        # modify and return the request
        r.headers['X-Pizza'] = self.username
        return r
requests.get('http://pizzabin.org/admin', auth=PizzaAuth('kenneth'))
```

### 基本身份认证

```python
from requests.auth import HTTPBasicAuth
requests.get('https://api.github.com/user', auth=HTTPBasicAuth('user', 'pass'))
```

### 摘要式身份认证

```python
from requests.auth import HTTPDigestAuth
url = 'http://httpbin.org/digest-auth/auth/user/pass'
requests.get(url, auth=HTTPDigestAuth('user', 'pass'))
```


### 代理

```python
import requests
proxies = {
  "http": "http://10.10.1.135:3128",
  # "http": "http://user:pass@10.10.1.135:3128/",  # 用户名密码
  "https": "http://10.10.1.135:1080",
}
requests.get("http://example.org", proxies=proxies)
#也可以设置环境变量之间访问
export HTTP_PROXY="http://10.10.1.135:3128"
export HTTPS_PROXY="http://10.10.1.135:1080"
```

### requests.session

```python
import requests
import time
from bs4 import BeautifulSoup

session = requests.session()

login_url = "http://deploy.ixiaochuan.cn/login"
res_start = session.get(url=login_url)
bs = BeautifulSoup(res_start.text, "html.parser")
a = bs.select("#csrf_token")[0]
token = a.attrs.get("value")

login_data = {"username": (None, "weiqiang"), "password": (None, "Onei"), "submit": (None, "Login"),
              "csrf_token": (None, token)}
res = session.post(url=login_url, files=login_data, allow_redirects=False)
print("login success")
```

## BeautifulSoup  [html\xml解析器]

```python
# BeautifulSoup中文官方文档
# http://www.crummy.com/software/BeautifulSoup/bs3/documentation.zh.html
# http://www.crummy.com/software/BeautifulSoup/bs4/doc/index.zh.html
# Beautiful Soup将复杂HTML文档转换成一个复杂的树形结构,每个节点都是Python对象,所有对象可以归纳为4种: Tag , NavigableString , BeautifulSoup , Comment

# 导入模块
"""
from BeautifulSoup import BeautifulSoup          # For processing HTML  版本3.0 已停止更新
from BeautifulSoup import BeautifulStoneSoup     # For processing XML
import BeautifulSoup                             # To get everything
from bs4 import BeautifulSoup                    # 版本4.0 bs4 安装: pip install BeautifulSoup4
"""

from bs4 import BeautifulSoup
soup = BeautifulSoup(html_doc)         # 解析html文本 可以是 requests 提交返回的页面 results.content
print(soup.prettify())                 # 输出解析后的结构
print(soup.title)                      # 指定标签内容
print(soup.title.name)                 # 标签名
print(soup.title.string)               # 标签内容
print(soup.title.parent.name)          # 上层标签名
print(soup.p)                          # <p class="title"><b>The Dormouse's story</b></p>
print(soup.p['class'])                 # u'title'  class属性值
print(soup.a)                          # 找到第一个a标签的标签行
print(soup.find_all('a',limit=2))      # 找到a标签的行,最多为limit个
print(soup.find(id="link3"))           # 标签内id为link3的标签行
print(soup.get_text())                 # 从文档中获取所有文字内容
soup.find_all("a", text="Elsie")       # 从文档中搜索关键字
soup.find(text=re.compile("sisters"))  # 从文档中正则搜索关键字
soup.find_all("a", class_="sister")    # 按CSS搜索
soup.find_all(id='link2',"table",attrs={"class": "status"},href=re.compile("elsie"))   # 搜索方法
for i in  soup.find_all('a',attrs={"class": "usr-pic"}):    # 循环所有a标签的标签行
    if i.a.img:
        print(i.a.img.get("src"))                   # 取出当前a标签中的连接
#Tag
# find_all 后循环的值是 Tag 不是字符串 不能直接截取
tag.text                     # 文本
tag.name
tag.name = "blockquote"      # 查找name为 blockquote 的
tag['class']
tag.attrs                    # 按熟悉查找
tag['class'] = 'verybold'

del tag['class']             # 删除
print(tag.get('class'))      # 打印属性值
print(i.get('href'))         # 打印连接
```

## cookielib      [保留cookie登录页面]

```python
ck = cookielib.CookieJar()   # 通过 这个就可以实现请求带过去的COOKIE与发送回来的COOKIE值了。
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(ck))   # 获取到COOKIE
urllib2.install_opener(opener)   # 此句设置urllib2的全局opener
content = urllib2.urlopen(url).read()
```

### 登录cacti取图片

```python
#encoding:utf8
import urllib2
import urllib
import cookielib
def renrenBrower(url,user,password):
    #查找form标签中的action提交地址
    login_page = "http://10.10.10.19/cacti/index.php"
    try:
        #获得一个cookieJar实例
        cj = cookielib.CookieJar()
        #cookieJar作为参数，获得一个opener的实例
        opener=urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
        #伪装成一个正常的浏览器，避免有些web服务器拒绝访问
        opener.addheaders = [('User-agent','Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)')]
        #生成Post数据,含有登陆用户名密码,所有表单内的input中name值
        data = urllib.urlencode({"action":"login","login_username":user,"login_password":password})
        #以post的方法访问登陆页面，访问之后cookieJar会自定保存cookie
        opener.open(login_page,data)
        #以带cookie的方式访问页面
        op=opener.open(url)
        #读取页面源码
        data=op.read()
        #将图片写到本地
        #file("1d.png" , "wb").write(data)
        return data
    except Exception,e:
        print(str(e))
print(renrenBrower("http://10.10.1.135/cacti/graph_image.php?local_graph_id=1630&rra_id=0&view_type=tree&graph_start=1397525517&graph_end=1397611917","admin","admin"))
```

### 登录例子

```python
import urllib, urllib2, cookielib
import os, time

headers = []

def login():
    cj = cookielib.CookieJar()
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
    login_url = r'http://zhixing.bjtu.edu.cn/member.php?mod=logging&action=login&loginsubmit=yes&infloat=yes&lssubmit=yes&inajax=1'
    login_data = urllib.urlencode({'cookietime': '2592000', 'handlekey': 'ls', 'password': 'xxx',
            'quickforward': 'yes', 'username': 'GuoYuan'})
    opener.addheaders = [('Host', 'zhixing.bjtu.edu.cn'),
                       ('User-Agent', 'Mozilla/5.0 (Ubuntu; X11; Linux i686; rv:8.0) Gecko/20100101 Firefox/8.0'),
                       ('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'),
                       ('Accept-Language', 'en-us,en;q=0.5'),
                       ('Accept-Encoding', 'gzip, deflate'),
                       ('Accept-Charset', 'ISO-8859-1,utf-8;q=0.7,*;q=0.7'),
                       ('Connection', 'keep-alive'),
                       ('Referer', 'http://zhixing.bjtu.edu.cn/forum.php'),]
    opener.open(login_url, login_data)
    return opener

if __name__ == '__main__':
    opener = login()

    url = r'http://zhixing.bjtu.edu.cn/forum.php?mod=topicadmin&action=moderate&optgroup=2&modsubmit=yes&infloat=yes&inajax=1'
    data = {'fid': '601', 'formhash': '0cdd1596', 'frommodcp': '', 'handlekey': 'mods',
             'listextra': 'page%3D62', 'moderate[]': '496146', 'operations[]': 'type', 'reason': '...',
             'redirect': r'http://zhixing.bjtu.edu.cn/thread-496146-1-1.html', 'typeid': '779'}
    data2 = [(k, v) for k,v in data.iteritems()]

    cnt = 0
    for tid in range(493022, 496146 + 1):
        cnt += 1
        if cnt % 20 == 0: print
        print(tid)

        data2.append(('moderate[]', str(tid)))
        if cnt % 40 == 0 or cnt == 496146:
            request = urllib2.Request(url=url, data=urllib.urlencode(data2))
            print(opener.open(request).read())
            data2 = [(k, v) for k,v in data.iteritems()]
```

## httplib        [http协议的客户端]

```python
import httplib
conn3 = httplib.HTTPConnection('www.baidu.com',80,True,10)
```

## aiohttp        [检索网页的客户端]

```python
# 需要python3.3+
# http://aiohttp.readthedocs.org/en/v0.12.0/

import aiohttp

def get_body(url):
    response = yield from aiohttp.request('GET', url)
    return (yield from response.read())

response = yield from aiohttp.request('GET', 'http://python.org')
body = yield from response.read()
print(body)
```

### 用 asyncio 配合协程抓取页面

```python
yield from asyncio.wait_for(request('GET', url), 10)

http_server

import asyncio
from aiohttp import web

@asyncio.coroutine
def handle(request):
    name = request.match_info.get('name', "Anonymous")
    text = "Hello, " + name
    return web.Response(body=text.encode('utf-8'))

@asyncio.coroutine
def init(loop):
    app = web.Application(loop=loop)
    app.router.add_route('GET', '/{name}', handle)

    srv = yield from loop.create_server(app.make_handler(),
                                        '127.0.0.1', 8080)
    print("Server started at http://127.0.0.1:8080")
    return srv

loop = asyncio.get_event_loop()
loop.run_until_complete(init(loop))
loop.run_forever()
```

### 查看网页图片尺寸类型

```python
#将图片读入内存
#!/usr/bin/env python
#encoding=utf-8
import cStringIO, urllib2, Image
url = 'http://www.01happy.com/wp-content/uploads/2012/09/bg.png'
file = urllib2.urlopen(url)
tmpIm = cStringIO.StringIO(file.read())
im = Image.open(tmpIm)
print(im.format, im.size, im.mode)
```

### 新浪文章抓取

```python
#!/usr/bin/env python
#encoding:utf-8
#sudo pip install BeautifulSoup

import requests
from BeautifulSoup import BeautifulSoup
import re

baseurl = 'http://blog.sina.com.cn/s/articlelist_1191258123_0_1.html'

r = requests.get(baseurl)

for url in re.findall('<a.*?</a>', r.content, re.S):
    if url.startswith('<a title='):
        with open(r'd:/final.txt', 'ab') as f:
            f.write(url + '\n')

linkfile = open(r'd:/final.txt', 'rb')
soup = BeautifulSoup(linkfile)
for link in soup.findAll('a'):
    #print(link.get('title') + ':    ' + link.get('href'))
    ss = requests.get(link.get('href'))
    for content in re.findall('<div id="sina_keyword_ad_area2" class="articalContent  ">.*?</div>', ss.content, re.S):
        with open(r'd:/myftp/%s.txt'%link.get('title').strip('<>'), 'wb') as f:
            f.write(content)
            print('%s   has been copied.' % link.get('title'))
```


### 反垃圾邮件提交申诉

```python
#!/usr/bin/env python
#encoding:utf-8
import requests
import re

IpList=['113.212.91.25','113.212.91.23']
QueryAdd='http://www.anti-spam.org.cn/Rbl/Query/Result'
ComplaintAdd='http://www.anti-spam.org.cn/Rbl/Getout/Submit'
data = {
'CONTENT':'''我们是一家正规的XXX。xxxxxxx。恳请将我们的发送服务器IP移出黑名单。谢谢！
处理措施：
1.XXXX。
2.XXXX。''',
'CORP':'abc.com',
'WWW':'www.abc.cm',
'NAME':'def',
'MAIL':'def@163.com.cn',
'TEL':'010-50000000',
'LEVEL':'0',
}

for Ip in IpList:
    query = requests.post(url=QueryAdd, data={'IP':Ip})                   # 黑名单查询
    if query.ok:
        if re.findall(u'\u7533\u8bc9\u8131\u79bb', query.text, re.S):     # 查找关键字 申诉脱离 既表明在黑名单中
            data['IP']=Ip
            complaint = requests.post(url=ComplaintAdd, data=data)        # 提交申诉
            if complaint.ok:
                if re.findall(u'\u60a8\u7684\u9ed1\u540d\u5355\u8131\u79bb\u7533\u8bf7\u5df2\u63d0\u4ea4', complaint.text, re.S):
                    status='申请提交'
                elif re.findall(u'\u8131\u79bb\u7533\u8bf7\u5df2\u88ab\u4ed6\u4eba\u63d0\u4ea4', complaint.text, re.S):
                    status='重复提交'
                elif re.findall(u'\u7533\u8bf7\u7531\u4e8e\u8fd1\u671f\u5185\u6709\u88ab\u62d2\u7edd\u7684\u8bb0\u5f55', complaint.text, re.S):
                    status='近期拒绝'
                else:
                    status='异常'
        else:
            status='正常'
        print '%s  %s' %(Ip,status)
```

### 有道词典

```python
#!/usr/bin/env python
import requests
from bs4 import BeautifulSoup
# bs4安装: pip install BeautifulSoup4

def youdao(word):
    url = r'http://dict.youdao.com/search?le=eng&q={0}'.format(word.strip())
    r = requests.get(url)
    if r.ok:
        soup = BeautifulSoup(r.content)
        div = soup.find_all('div', class_='trans-container')[:1]    # find_all是bs4的方法
        ul = BeautifulSoup(str(div[0]))
        li = ul.find_all('li')
        for mean in li:
            print(mean.text)

def query():
    print('Created by @littlepy, QQ:185635687')
    while True:
        word = raw_input('>>>')
        youdao(word)

if __name__ == '__main__':
    query()
```

### python启动http服务提供访问或下载

```shell
python -m SimpleHTTPServer  9900
```