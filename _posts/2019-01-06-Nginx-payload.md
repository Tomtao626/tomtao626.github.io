---
layout: mypost
title: Nginx配置实例-负载均衡
categories: [Nginx, Linux]
---

1.实现效果

(1) 浏览器地址输入地址`http://127.0.0.1/edu/a.html`,负载均衡效果,平均8080和8081端口中
2.准备效果
(1)准备两台tomcat服务器,一台8080,一台8081
(2)在两台tomcat里面webapps目录中,创建名称是edu文件夹,在edu文件夹中创建页面,用于测试.

3.在Nginx的配置文件中,进行配置
![img1](/posts/2019/01/06/img.png)
4.Nginx分配服务器策略
(1).轮询
每个请求按时间顺序逐一分配到不同的后端服务器,如果后端服务器down掉,能自动剔除

(2)wegith-权重
weight代表权重,默认为1,权重越高分分配的客户端越多
指定轮询几率,weigth和访问比率成正比,用于后端服务器性能不均的情况下
![img2](/posts/2019/01/06/img_1.png)
(3)ip_hash
每个请求按访问ip的hash结果匹配,这样每个访客固定访问一个后端服务器,可以解决session问题
![img3](/posts/2019/01/06/img_2.png)

(4)fair
按照后端服务器的响应时间来分配,响应时间越短优先分配.
![img4](/posts/2019/01/06/img_3.png)
