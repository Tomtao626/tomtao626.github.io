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
         var t1 = Date.UTC(2021,12,05,00,00,00); //北京时间创建网站的时间
         var t2 = Date.UTC(todayYear,todayMonth,todayDate,todayHour,todayMinute,todaySecond);
         var diff = t2-t1;
         var diffYears = Math.floor(diff/years);
         var diffDays = Math.floor((diff/days)-diffYears*365);
         var diffHours = Math.floor((diff-(diffYears*365+diffDays)*days)/hours);
         var diffMinutes = Math.floor((diff-(diffYears*365+diffDays)*days-diffHours*hours)/minutes);
         var diffSeconds = Math.floor((diff-(diffYears*365+diffDays)*days-diffHours*hours-diffMinutes*minutes)/seconds);
         document.getElementById("sitetime").innerHTML="***Chemcat Blog 搭建至今已稳定运行"+diffDays+"天"+diffHours+"时"+diffMinutes+"分钟"+diffSeconds+"秒***"; //+diffYears+"年"
     }
     siteTime();
 </script>
给JavaScript基础笔记里添加html、css和js示例

开始放进去div和script标签后识别不出来，简单查了一下说 Markdown 里的 html 标签要顶行写不能空格，空格删了以后可以渲染了，但是接着放了一个button标签，居然整行都直接被当成文本显示了，开始是这样写的：

 <button type="button" id="buttonx" onclick="buttonx()"> 很好，然后点我(ﾉ)`ω´(ヾ) </button><br>
然后就开始查了，查到 jekyll 把 Markdown 转为 html 用的是 kramdown 驱动，然后在两个项目的 GitHub Issues 里查了一大圈只查到了这个kramdown 官方文档比较靠谱，但是里面明确写着，button、div、form等等都是 Parse as block-level elements 的，也就是说支持按钮，也确实没道理其他都正常只有 button 渲染不了的。然后还查到有人说 gitee 的渲染器比 GitHub 的落后好几年的版本，但是我是本地调试，也还没发到 gitee pages 上，也就不是这个问题。最终查了一大圈，还是没头绪，我突然就想着试着写了一个最简单的button，发现居然能渲染，然后敲上其他内容，这才发现不写 onclick 就能正常渲染，写上就不行了。于是果断把事件注册写到 js 里，把 button 里的onclick="myFunction()"删掉，刷新。诶，能正常显示了，功能也正常。这真是玄学问题了。开始还是想太复杂了，以后遇到类似问题就应该先把问题简化，一步步找原因。

JavaScript基础笔记的《序》里的源代码如下：

 <div class="shicao">
 <form action="">
 	*下面只要是双实线框包住的部分都是可以实际操作的示例，源代码都会附在框下面<br>
       	乖，首先输入你的名字(*ﾟ∀ﾟ*)<br>
     	<input type="text" id="lxz" value="#旅行者"><br>
 <button type="button" id="buttonx"> 很好，然后点我(ﾉ)`ω´(ヾ) </button><br>
 </form>
 </div>
 <script>
     	var btnx = document.getElementById("buttonx");
       var lxz = document.getElementById("lxz").value;
         btnx.onclick = function(){
             alert('             \\\\\\'+lxz+'/// \n 举高高(ノﾟ∀ﾟ)ノ');
         }
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
