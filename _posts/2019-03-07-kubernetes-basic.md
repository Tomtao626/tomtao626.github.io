---
layout: mypost
title: Kubernetes小试牛刀
categories: [Linux, Docker, Kubernetes]
---

# 1.什么是k8s

> 管理云平台中多个主机的容器化的应用，目的是让容器化部署应用更简单高效，同时k8s也是管理docker容器最主流的编排工具

## 1.1 基本概念

- Pod 
  - Pod是k8s里能够被运行的最小逻辑单元
  - 1个Pod里面可以运行多个容器，共享UTS+NET+IPC命名空间（NameSpace）
  - 可以将Pod理解成豌豆荚，而同一Pod内的每一个容器就是一粒粒豌豆
  - 一个Pod可以运行多个容器，也叫边车（SideCar）模式
- Pod控制器
  - Pod启动的一种模版，用来保证在K8S里启动的Pod始终按照人们的预期运行（副本数、生命周期、健康状态检查...）
  - Pod提供了多种Pod控制器，常用的有以下几种:
    - Deployment
    - DaemonSet
    - ReplicaSet
    - Job
    - Cronjob
- Name
  - k8s内部会使用"资源"来定义每一种逻辑概念（功能），所以每种资源，都有自己的名称
  - "资源"有api版本（apiVersion），类别（kind），元数据（metadata），定义清单（spec），状态（status）等配置信息
  - 名称通常定义在资源的元数据（metadata）信息里
- NameSpace
  - 随着项目增多，人员增加，集群规模扩大，需要一种能够隔离k8s内各种资源的方法，这个就是命名空间
  - 命名空间可以理解为k8s内部的虚拟集群组
  - 不同命名空间内的"资源"名称可以相同，相同名称的命名空间内部的同种"资源"，"名称"不能相同
  - 合理的使用k8s命名空间，使得能够更好分类管理和浏览交付到k8s内部的各类服务
  - k8s有默认存在的命名空间: default，kube-system，kube-public
  - 查询k8s内的特定资源，需要带上对应的命名空间
- Label
  - 标签是k8s特色的管理方式，便于分类管理资源对象
  - 一个标签对应多个资源，一个资源也可以有多个标签，是多对多的关系
  - 一个"资源"也有多个标签，可以实现不同维度的管理
  - 标签形式: key=value
  - 与标签类似的，还有一种"注解"(annotation)
- Label选择器
  - 给资源打标签后，可使用标签选择器过滤指定的标签
  - 两个标签选择器: 基于等值关系（是否等于），基于集合关系（是否属于，存在）
  - matchLabels
  - matchExpressions
- Service
  - 虽然每个Pod都会被分配一个独立的ip地址，但这个ip地址会随着Pod的销毁而消亡，而Service（服务）就是用来解决这个问题的核心概念
  - 一个Service可以看作是一组提供相同服务的Pod的对外访问接口
  - Service作用于哪些Pod是通过标签选择器来定义的
- Ingress
  - k8s集群内部工作在OSI网络参考模型下，第七层的应用，对外暴露的忌口
  - Service只进行L4流量调度，表现形式: ip:port
  - Ingress可以调度不同业务域，不同URL访问路径的业务流量

> 简单理解：Pod可运行的原子，name定义名字，namespace名称空间（放一堆名字），label标签（另外的名字），service提供服务，ingress通信

![20220307-k8s-basic01](/posts/2019/03/03/20220307-k8s-basic01.png)

> **kubectl**: 是操作k8s集群的命令行工具，安装在k8s的master节点，kubectl在$HOME/.kube目录中查找一个名为config的文件, 你可以通过设置Kubeconfig环境变量或设置--kubeconfig来指定其他的kubeconfig文件。kubectl通过与apiserver交互可以实现对k8s集群中各种资源的增删改查
> 
> **API Server**: 对核心对象（例如：Pod，Service，RC）的增删改查操作，同时也是集群内模块之间数据交换的枢纽
> 
> **Etcd**: 包含在APIServer中，用来存储资源信息
> 
> **Controller Manager**: 负责维护集群的状态，比如故障检测，动态扩展，滚动更新等。
> 
> **Scheduler**: 负责资源调度，按照预定的调度策略将Pod调度到对应的机器上
> 
> **kube-proxy**: 为Service提供cluster内部的服务发现和负载均衡
> 
> **kubelet**: 在k8s中，应用容器是彼此隔离的，并且与运行在其中的主机也是隔离的，这是对应用进行独立解耦管理的关键。
> 
> **Node**: 运行容器应用，由Master管理

## 1.2 k8s集群架构

> Master-Worker架构模式
> + Master相当于是大脑和心脏，负责接收外部请求/管理和调度Worker节点。
> + Worker相当于四肢，每一台worker都干着相同的工作，随时可以被剔除或加入，以实现横向伸缩。

### 1.2.1 Master组件

- kube-apiserver:对外暴露可以操作整个kubernetes集群的REST API
- kube-scheduler:负责调度worker上的pods
- kube-controller-manager:管理各种kubernetes定义的controller
- etcd:key-value存储组件，采用Raft协议，存储集群的各种状态数据，包括配置/节点/pod等
  - 持久化能力： 有些 KV 缓存并不具备该能力，比如 memcache。 
  - 数据一致性 
  - 高可用 
  - 高性能 
  - 安全性： 支持基于 TLS 与 SSL 的鉴权。 也可以看看 etcd 官网自己是怎么说的。最后可能还有一点，etcd 是使用 golang 开发的，是 Clouad Native 阵营里的“自己人”。

### 1.2.2 Worker/Node组件

- kubelet:
- kube-proxy:操纵机器上的iptables网络规则，执行转发是一个Agent，监控node上的container是否正常运行
- container runtime:容器运行的基础环境，负责下载镜像和运行容器

# 2.k8s集群搭建

## 2.1 环境配置

```shell
# 每个节点分别设置对应主机名
hostnamectl set-hostname master
hostnamectl set-hostname node1
hostnamectl set-hostname node2
```

```shell
# 所有节点都修改 hosts
vim /etc/hosts

192.168.160.128 master
192.168.160.129 node1
192.168.160.130 node2
```

```shell
# 所有节点关闭 SELinux
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
```

```shell
所有节点确保防火墙关闭
systemctl stop firewalld
systemctl disable firewalld
```
> 添加源（master/node）

```shell
# 添加 k8s 安装源
cat <<EOF > kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
mv kubernetes.repo /etc/yum.repos.d/

# 添加 Docker 安装源
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

## 2.2 安装

> 安装组件（master/node）

```shell
yum install -y kubelet-1.22.4 kubectl-1.22.4 kubeadm-1.22.4 docker-ce
```

> 启动kubelet，docker，并设置开机启动

```shell
systemctl enable kubelet
systemctl start kubelet
systemctl enable docker
systemctl start docker
```

> 修改docker配置（master/node）

```shell
# kubernetes 官方推荐 docker 等使用 systemd 作为 cgroupdriver，否则 kubelet 启动不了
cat <<EOF > daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "registry-mirrors": ["https://ud6340vz.mirror.aliyuncs.com"]
}
EOF
mv daemon.json /etc/docker/

# 重启生效
systemctl daemon-reload
systemctl restart docker
```

> 用 kubeadm 初始化集群（仅在主节点跑）

```shell
# 初始化集群控制台 Control plane
# 失败了可以用 kubeadm reset 重置
kubeadm init --image-repository=registry.aliyuncs.com/google_containers

# 记得把 kubeadm join xxx 保存起来
# 忘记了重新获取：kubeadm token create --print-join-command

# 复制授权文件，以便 kubectl 可以有权限访问集群
# 如果你其他节点需要访问集群，需要从主节点复制这个文件过去其他节点
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# 在其他机器上创建 ~/.kube/config 文件也能通过 kubectl 访问到集群
```

> 将其他子节点加入到集群中（node执行）

```shell
kubeadm join 192.168.160.128:6443 --token 6ser2k.w0eerc5hixlp463z --discovery-token-ca-cert-hash sha256:687b0baf5ed1c67ab5686fdd412ae9efceabf5a9ed82
```

> 这个token大概是5分过期，如果提示token过期，使用下面命令重新生成即可（master执行）

```shell
kubeadm token create --print-join-command
# 使用新的token再次join即可
```

> 报错处理

- 报错[ERROR FileContent--proc-sys-net-bridge-bridge-nf-call-iptables]: /proc/sys/net/bridge/bridge-nf-call-iptables contents are not set to 1

```shell
echo 1 >/proc/sys/net/bridge/bridge-nf-call-iptables
```

- 报错[ERROR FileContent--proc-sys-net-ipv4-ip_forward]: /proc/sys/net/ipv4/ip_forward contents are not set to 1

```shell
echo 1 >/proc/sys/net/ipv4/ip_forward
```

- 报错[ERROR Swap]: running with swap on is not supported. Please disable swap

```shell
swapoff -a
```

## 2.3 基本操作

- 查看关键pod运行状态
  - `kubectl get pod -n kube-system`

- 查看所有的pod
  - `kubectl get pods --all-namespace`

- 查看集群节点信息
  - `kubectl get nodes`

- 查看已安装插件信息
  - `kubectl get configmap -n kube-system`

- 查看pod日志信息
  - `kubectl describe pods -n kube-system xxxxxx`

- 删除无用的pod
  - `kubectl delete pod xxxxxx -n kube-system`

- 安装服务
  - `kubectl apply -f xxx.yml`

- 查询健康状态
  - `kubectl get cs`

- 查询clusterIP信息
  - `kubectl get svc -n xxxxx`

- 查看节点的taint
  - `kubectl describe node-name`

- 删除节点的taint
  - `kubectl taint nodes --all node-role.kubernetes.io/master-`

- 给节点添加taint
  - `kubectl taint node node-name node-role.kubernetes.io/master:NoSchedule`

- taint的其他说明
  - `kubectl taint -h`

- 查看全属性pod 状态信息
  - `kubectl get pods --all-namespaces -o wide`

- 查看所有kind资源类型
  - `kubectl api-resources -o wide --namespaced=true 或者kubectl api-resources -o wide --namespaced=false`

- 创建nginxpod
  - `kubectl create deployment web --image=nginx`

- 暴露对外接口
  - `kubectl expose deployment web --port=80 --target-port=80 --type=NodePort`
  
- 定义一个service并导出yaml文件类型（Type如果没做设置,默认ClusterIP）
  - `kubectl expose deployment web --port=80 --target-port=80 --dry-run -o yaml >service1.yaml`
  
- 基于这个service1.yaml可通过以下命令，创建service
  - `kubectl apply -f service1.yaml`
  
- 查看service 
  - `kubectl get svc`
  
- 删除service 
  - `kubectl delete service nginx-web`
  
- 显示完成的docker描述信息，不显示省略号：
  - `docker search kube-webhook-certgen:v1.1.1 --no-trunc`

## 2.4 安装部署kubernetes-dashboard

- 安装 
  - `kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.1/aio/deploy/recommended.yaml`

- 也可以使用NodePort模式
  - 在recommended.yaml文件中，depolyment区块下，添加type:NodePort
  - 再执行 `kubectl apply -f recommended.yaml` 更新

- 如果使用NodePort模式，则查看NodePort服务端口为31568
  - `kubectl get service --all-namespaces |grep dash`
  - 通过地址 `https://192.168.160.128:31568/#/login` 访问

- 若不使用NodePort模式，则使用`kubectl proxy`来启动dashboard，查看clusterIP，服务端口为8001
  - `kubectl proxy`
  - `kubectl get svc -n kubernetes-dashboard`
  - 通过`http://192.168.160.128:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login`

- 访问成功，需要填入admin-token，通过以下命令生成即可
  - `kubectl create serviceaccount dashboard-admin -n kube-system`
  - `kubectl create clusterrolebinding dashboard-admin --clusterrole=cluster-admin --serviceaccount=kube-system:dashboard-admin`
  - 查看令牌 `kubectl describe secrets -n kube-system $(kubectl -n kube-system get secret | awk '/dashboard-admin/{print $1}')`