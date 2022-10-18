---
layout: mypost
title: Python-MySQL
categories: [Python, DataBase]
---

## mysql

```python
# yum install mysql-devel python-tools gcc openssl-devel
# pip install MySQL-python
# yum install python-MySQLdb MySQL-python

help(MySQLdb.connections.Connection)      # 查看链接参数

conn=MySQLdb.connect(host='localhost',user='root',passwd='123456',db='fortress',port=3306)    # 定义连接
#conn=MySQLdb.connect(unix_socket='/var/run/mysqld/mysqld.sock',user='root',passwd='123456')   # 使用socket文件链接
conn.autocommit(True)                                        # 自动提交
cur=conn.cursor()                                            # 定义游标
conn.select_db('fortress')                                   # 选择数据库
sqlcmd = 'insert into user(name,age) value(%s,%s)'           # 定义sql命令
cur.executemany(sqlcmd,[('aa',1),('bb',2),('cc',3)])         # 插入多条值
cur.execute('delete from user where id=20')                  # 删除一条记录
cur.execute("update user set name='a' where id=20")          # 更细数据
sqlresult = cur.fetchall()                                   # 接收全部返回结果
conn.commit()                                                # 提交
cur.close()                                                  # 关闭游标
conn.close()                                                 # 关闭连接

import MySQLdb
def mydb(dbcmdlist):
    try:
        conn=MySQLdb.connect(host='localhost',user='root',passwd='123456',db='fortress',port=3306)
        conn.autocommit(True)
        cur=conn.cursor()

        cur.execute('create database if not exists fortress;')  # 创建数据库
        conn.select_db('fortress')                              # 选择数据库
        cur.execute('drop table if exists log;')                # 删除表
        cur.execute('CREATE TABLE log ( id BIGINT(20) NOT NULL AUTO_INCREMENT, loginuser VARCHAR(50) DEFAULT NULL, remoteip VARCHAR(50) DEFAULT NULL, PRIMARY KEY (id) );')  # 创建表

        result=[]
        for dbcmd in dbcmdlist:
            cur.execute(dbcmd)           # 执行sql
            sqlresult = cur.fetchall()   # 接收全部返回结果
            result.append(sqlresult)
        conn.commit()                    # 提交
        cur.close()
        conn.close()
        return result
    except MySQLdb.Error,e:
        print('mysql error msg: ',e)
sqlcmd=[]
sqlcmd.append("insert into log (loginuser,remoteip)values('%s','%s');" %(loginuser,remoteip))
mydb(sqlcmd)

sqlcmd=[]
sqlcmd.append("select * from log;")
result = mydb(sqlcmd)
for i in result[0]:
    print(i)
```
    
## mysql链接失败重试

```python
import MySQLdb as mysql
import time

class my():
    def executeSQL(self, sql="select * from `serverinfo` limit 1;"):
        while True:
            try:
                self.conn.ping()
                break
            except Exception,e:
                print('warning: mysql test ping fail')
                print(str(e))
            try:
                self.conn = mysql.connect(user="opsdeploy", passwd="123456", host='172.222.50.50', port=3306, db="ops_deploy", connect_timeout=10, compress=True, charset="utf8")
                self.cursor = self.conn.cursor()
                break
            except Exception,e:
                print("mysql reconnect fail ...")
                print(str(e))
                time.sleep(2)
        try:
            self.cursor.execute(sql)
            self.conn.commit()
            print(self.cursor.fetchall())
        except Exception,e:
            print(str(e))
m=my()
m.executeSQL()
```
