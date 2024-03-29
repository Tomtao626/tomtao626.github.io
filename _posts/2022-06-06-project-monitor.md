---
layout: mypost
title: 浅谈下项目监控
categories: [Cloud, Monitor, Linux]
---

> 总结下做监控的一些经验，以备查用。

# 1-为什么做监控？

> 监控是为了查看项目的运行情况，及早发现问题。

# 2-监控什么？
   
> 项目的执行是为了产生业务的结果，那么什么样的结果会让用户不满意呢？ 一是得到了错误的结果，比如在网上买东西提交了订单结果看不到生成的订单。二是项目运行太慢，一个商品详情页面半天打不开。就此，我认为可以做如下监控：
> + 性能监控：关注程序的响应速度。
> + 业务监控：关注程序的执行输出结果。
> + 基础设施监控：关注程序运行的环境是否正常。

# 3-如何做监控？

> + 监控要有指标。
>   + 要对监控的事务进行指标化，可以是成功、失败的判断，可以是是否超过阈值的判断，可以是根据大量数据判断其波动、趋势。
>   + 要对监控的事务进行多维度的分析，宏观上关注运行结果，微观上关注内部细节。
> + 每个监控要有具体的负责人。
>   + 谁对监控关注，谁来负责跟进解决。
>   + 只有明确的负责人才能推荐问题的解决，避免有了监控却没人管。
> + 监控要有优先级。
>   + 可以根据问题的影响范围，指标的的大小确定优先级。
> + 监控要有报警。
>   + 监控发现问题后要及时、准确的报警，通过短信、im、邮件等手段通知，并根据优先级选择报警手段和频度。

# 4-监控的措施

> 根据监控的选择维度有不同的监控目标和措施，只有多种措施相结合才能完成更好的监控。

## 4.1 性能监控

> 关注程序的响应速度。

### 4.1.1 宏观监控

> + HTTP服务：可以使用`Nginx`或者框架输出的每个请求处理时间监控。
> + 定时任务：关注任务的执行时长或者时长的波动情况，通常任务管理工具都会提供相关数据，如若没有需要自己抓取，并对数据进行分析。
> + 消息队列处理速度：可在消息开始和结束时输出日志，对日志进行分析。

### 4.1.2 微观监控

> 微观上关注每一步的性能，分析每一步的耗时，以及究竟有多少步骤。

> + 过程埋点监控：一个任务可以拆解成多个执行过程，在每个片段输出日志，分析日志。缺点这需要具体任务具体分析，根据任务优先级逐个添加。有点是可以定制化、有更明确的关注点。
> + 框架级监控：Web服务是I/O密级型服务，通常耗时在数据库读写请求、外部API请求等网络请求。需要改造调用外部的包，统一打出日志。优缺点和人工埋点正好相反，一次改造处处受益，但是需要研发人员对大量的日志分析找到问题所在。同时，可以打通跨服务的调用链，以分析业务的整体性能。另外，可以接入第三方APM，如`Elastic APM`。
> + 基础设施监控：监控各种基础设施中有用的性能指标，如`MySQL`中的慢查询日志、网关服务记录的请求处理时长等，发现问题。

## 4.2 业务监控

### 4.2.1 宏观监控

> 宏观上关注业务的执行结果，这需要和产品、运营等同学沟通确定业务指标，并根据业务情况不断调整，同一个业务也可能有不同维度的监控指标。这些可能是一组服务共同执行的结果，并且原因可能是产品功能逻辑上的，可能是程序bug。常见方式：

> + 报表型结果：通过是业务专家根据整体业务分析给出的指标，需要编写业务逻辑分析数据。比如新注册用户一定时间的购买成功率。
> + 执行任务结果：对每项任务落日志或落数据库的方式记录结果，监控结果。比如拨打营销电话，可能产生接通、拒接、失败等情况，可能是线路问题，也可能是程序bug，也可能是用户选取问题等。
> + 数值类结果：对关键指标进行数值监控，可能需要结合同比、环比波动情况。比如发送营销短信，昨天发了10000条，今天就发了200条，可能是因为某项运营设置有问题或者程序bug。

### 4.2.2 微观监控

> 微观上关注每个服务、每个脚本的、每个接口的成功情况和内部执行情况。

> + 从单个任务的执行情况讲：
>   + HTTP服务：可以监控响应码，主要是监控5XX响应码表示的服务器错误。同时注意4XX响应码，如果4XX过多可能也有情况，这个需要具体服务具体情况设置阈值。
>   + 定时任务：既要整体上关注任务是否执行了、是否执行了。
>   + 消息队列处理进程：可以在框架层面记录每条日志程序的处理结果。

> + 从任务内部代码讲，要多打日志，记录业务数据，业务结果，方便监控与分析问题。
>   + 同时框架上也可以做很多事情：
>   + 如在中间件记录未捕获的异常，结合[Sentry](https://sentry.io)这样的工具进行异常收集、显示、报警。
>   + 对外部调用记录结果，类似性能监控降到的框架级监控，在这关注调用的响应结果是否出错。

> + 基础设施监控
>   + 对项目使用的各种基础设施进行监控，关心程序是岁月安好还是在水深火热中。大致分为以下：
>   + 服务器监控：监控服务器的cpu占用率、内存占用率等等。同时如果是容器化的话，要关注编排工具如k8s给出的各种指标。
>   + 基础组件监控：监控数据库、配置中心等的相应情况，同时针对性的关注其内部指标，如MySQL错误日志、队列积压数量、Redis内存使用率等。
>   + 任务进程监控：关注进程是否存活，如使用supervisor托管关注运行状态，在openshift里关注pod是否存活。

# 5-监控大盘

> 最好要有一个或多个监控大盘，显示关键指标和概况数据。方便整体上关注项目运行情况，以及快速定位大致问题。可以使用[Grafana](https://grafana.com/)这样的展示工具或自定义开发