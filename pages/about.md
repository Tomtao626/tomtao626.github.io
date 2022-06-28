---
layout: mypost
title: 关于我
---

> Hello 陌生人，欢迎访问 Tomtao626 Blog

[comment]: <> (该博客托管于 GitHub Page，国内默认解析到腾讯云，以保证国内外的访问速度。留言页面使用腾讯的“吐个槽”，另外使用的腾讯的 MTA 分析工具统计访问量)

[comment]: <> (主题是Tmaize写的，见[tmaize-blog]&#40;https://github.com/TMaize/tmaize-blog&#41;，喜欢的话可以给个小星星。另外欢迎添加友链，在[留言板]&#40;chat.html&#41;留言即可)

<span id="sitetime"  style="color: #6b6b6b; text-align: center; padding: 15px 0; font-size: 14px;" ></span>
 <script>
     function siteTime(){
         window.setTimeout("siteTime()", 1000);
         var seconds = 1000;
         var minutes = seconds * 60;
         var hours = minutes * 60;
         var days = hours * 24;
         var years = days * 365;
         var today = new Date();
         var todayYear = today.getFullYear();
         var todayMonth = today.getMonth()+1;
         var todayDate = today.getDate();
         var todayHour = today.getHours();
         var todayMinute = today.getMinutes();
         var todaySecond = today.getSeconds();
         /* Date.UTC() -- 返回date对象距世界标准时间(UTC)1970年1月1日午夜之间的毫秒数(时间戳)
         year - 作为date对象的年份，为4位年份值
         month - 0-11之间的整数，做为date对象的月份
         day - 1-31之间的整数，做为date对象的天数
         hours - 0(午夜24点)-23之间的整数，做为date对象的小时数
         minutes - 0-59之间的整数，做为date对象的分钟数
         seconds - 0-59之间的整数，做为date对象的秒数
         microseconds - 0-999之间的整数，做为date对象的毫秒数 */
         var t1 = Date.UTC(2019,02,26,00,00,00); //北京时间创建网站的时间
         var t2 = Date.UTC(todayYear,todayMonth,todayDate,todayHour,todayMinute,todaySecond);
         var diff = t2-t1;
         var diffYears = Math.floor(diff/years);
         var diffDays = Math.floor((diff/days)-diffYears*365);
         var diffHours = Math.floor((diff-(diffYears*365+diffDays)*days)/hours);
         var diffMinutes = Math.floor((diff-(diffYears*365+diffDays)*days-diffHours*hours)/minutes);
         var diffSeconds = Math.floor((diff-(diffYears*365+diffDays)*days-diffHours*hours-diffMinutes*minutes)/seconds);
         document.getElementById("sitetime").innerHTML="***TomTao626 Blog 搭建至今已稳定运行"+diffDays+"天"+diffHours+"时"+diffMinutes+"分钟"+diffSeconds+"秒***"; //+diffYears+"年"
     }
     siteTime();
 </script>

## 相关技能

- 熟悉 Java/Python/Go 等后端语言

- 后端框架 Spring/Mybatis/Iris/Gin/Sanic/DRF 略有了解，微服务也懂一点点

- 数据库方面能熟练使用 MySQL/Redis/MongoDB/ETCD

- Linux 的简单使用，各种服务的搭建，Docker容器化技术也略知一二

- 能够使用 GIT/SVN 对代码版本进行控制

## 联系我

- QQ&nbsp;&nbsp;&nbsp;&nbsp;: NzUxODI1MjUz

- Email&nbsp;: [tom_tao626@qq.com](http://mail.qq.com/cgi-bin/qm_share?t=qm_mailme&email=8YWenK6FkJ7Hw8exgIDfkp6c)

- GitHub: [https://github.com/Tomtao626](https://github.com/Tomtao626)
