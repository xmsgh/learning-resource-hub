这部分学习docker的相关知识，以基于docker部署商城网站为例展开操作。

一、简单了解docker 

- docker是开源Linux引擎项目，把运行环境（操作系统、支持该软件运行的其他软件）等实现快速打包、部署和交换。实现在不同电脑、不同系统上都能够顺利运行。相当于连接不同设备之间的交换机。
- docker本身可以看作是一个仓库，可以通过它下载镜像并创建容器。
- 由于Linux系统中没有docker的下载引擎，所以需要先下载一个可以下载docker的下载源。操作方法如下：

(1)Rocky系统

wget -O /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/rhel/docker-ce.repo    #把下载源镜像下载安装到/etc/yum.repos.d/目录下并命名为docker-ce.repo
 
dnf install -y docker-ce

(2)Ubuntu系统

wget -qO /etc/apt/keyrings/docker.asc https://download.docker.com/linux/ubuntu/gpg

chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list
 
apt update
 
apt install -y docker-ce
- 因现在国内无法直接访问docker官网镜像仓库，所以需要先配置一个镜像加速器(国内的镜像站，把官方仓库的镜像都存储到国内了)，才能顺利完成镜像下载。配置方法如下：

在/etc/docker/目录下创建一个名为daemon.json的文件并写入[daemon.json](scripts/daemon.json)内容。

执行systemctl daemon-reload命令让加速器生效，然后重启docker。

二、常用基本命令记录

1.下载镜像
- docker pull 镜像名
- docker pull 镜像名:版本号

2.查看镜像
- docker images

3.删除镜像
- docker rm 镜像名

4.启动容器
- docker run 镜像名
- docker run -d 镜像名 #后台启动

还可叠加设置其他参数，如： 
- --name 名称               #对运行容器命名
- -it 镜像名 /bin/bash      #进入容器内部
- -p 指定端口号:内部监听端口号 #指定容器的端口
- -P                       #随机指定容器端口

5.查看容器
- docker ps       #列出在运行容器
- docker ps -a    #列出所有容器

6.启动容器
- docker start 容器ID

7.停止容器
- docker stop 容器ID

8.重启容器
- docker restart 容器ID

9.删除容器
- docker rm -f 容器ID

10.创建名为ngconf的卷
- docker volume create ngconf

11.查看所有已创建的卷
- docker volume ls

12.删除名为ngconf的卷
- docker volume rm ngconf

三、网络配置

1.作用：创建一个网络，相当于创建一台虚拟交换机，把新建的容器和网络连接，连接同一个网络的各个容器之间便可以实现互相通信，连接后，使用容器名便能通信。
此外，还能实现前端网页和后段数据库的连接，以此实现动态网页功能。以使用docker部署prestashop（一个开源的电商平台软件）及mysql数据库为例。

2.操作步骤

(1)创建一个名为prestashop-network的网络
- docker network create prestashop0network

(2)下载并启动mysql，设置相关参数
- docker pull mysql:8.0    #注意版本要和自己的服务器版本匹配，否则无法顺利运行
- docker run -d --name prestashop-mysql --network prestashop-network -p 3706:3306 -e MYSQL_ROOT_PASSWORD=123456 -e MYSQL_DATABASE=prestashop 
-e MYSQL_USER=psmod -e MYSQL_PASSWORD=123456 mysql8.0

#-e MYSQL_ROOT_PASSWORD为设置超级管理员的密码，是必填项，不设置启动容器时会报错，安全起见尽量设置的复杂一点，且不要和后面设置的普通用户的密码一样。

#在设置数据库参数时，有的参数是必选项，可以到 https://hub.docker.com/镜像名/ 中，找 Environment Variables 章节，通读一遍，依据项目需要设置具体的参数。

(3)启动并设置prestashop相关参数
- docker run -d --name prestashop --network prestashop-network -p 8008:80 -e DB_SERVER=prestashop-mysql -e DB_NAME=prestashop -e DB_USER=psmod -e DB_PASSWORD=123456 docker.1ms.run/restashop:latest

#docker.1ms.run/restashop:latest 是从 1ms.run 镜像加速站拉取prestashop镜像

#-e 部分命令是在告诉prestashop去哪里找数据库，参数对应的是mysql数据库设置的信息。

(4)网页安装prestashop

以上两步完成后，检查容器是否成功启动,成功后便可到网站输入网址进入安装向导页面：
http://虚拟机IP:8008

进入如下图所示的页面，数据库服务器地址是一开始设置的网络地址prestashop-network，因为创建的两个容器已经连接到prestashop-network网络上，
若输入虚拟机的IP地址，PrestaShop会去宿主机找MySQL，找不到任何数据，所以会报截图中提示的错误。
按照顺序填入数据库名称，数据库账户名称和密码，联通测试成功，便可进入下一步安装。

<img width="583" height="424" alt="截屏2026-07-12 17 17 49" src="https://github.com/user-attachments/assets/15ef05a0-b4ca-442c-a052-1715c55a3585" />

在安装过程中，prestashop容器内 /var/www/html 目录下生成的文件中，有一个名为admin的文件，截图中错误提示意思是，因容器内文件权限不足，无法自动将admin文件名替换为另一个名称，这是prestashop的安全措施，防止黑客猜到后台地址，会把admin文件名替换成一个随机的名字。
解决办法有两种：进入容器找到对应文件修改文件权限，让系统自动修改；或者直接把对应文件名称替换成错误提示的名称。

我直接修改文件名后，安装顺利进行。

<img width="625" height="350" alt="截屏2026-07-12 17 21 29" src="https://github.com/user-attachments/assets/ab89e0ef-9a40-4fec-837b-b58ae30d894a" />

之后还会遇到一个类似的错误，检查目录里没有名为错误提示的文件，只有admin-_命名的文件，把admin-_命名文件复制一份并重命名为系统随机生成的文件名，再次启动安装，就能顺利安装完成。

<img width="551" height="328" alt="截屏2026-07-12 17 29 12" src="https://github.com/user-attachments/assets/a93d0bc1-044d-4808-bb7f-9f830a41a5cd" />

⚠️安装完成后，必须进入prestashop容器内部删除install文件。至此，docker部署电子商城操作结束。

(5)后台查看、修改数据

业务相关的动态数据存放在mysql数据库中；静态文件（如图片、主题、模块、配置文件等）存放在prestashop中。

查看动态数据，首先要进入prestashop-mysql容器，然后进入mysql数据库，再用mysql数据库查看、更新、修改、删除等命令操作。具体方法不详细记录，可查看[SQL_examples.md](mysql/SQL_examples.md)部分的内容。

⚠️在修改和删除数据库的信息前，一定要先备份保存，避免操作失误造成大的损失。

四、错误记录

1.配置daemon.json文件后仍无法下载mysql镜像

已经配置daemon.json文件并重启docker，仍然无法下载镜像，提示如下错误：docker: Error response from daemon: failed to resolve reference "docker.io/library/busybox:latest": failed to do request……

原因：
  
错误提示中的网关地址的主要职责是转发流量，而不是域名解析，而docker daemon是一个独立的后台进程，有自己的命名空间，在一些特殊情况下它读取的DNS配置和系统不同，现有网关地址对docker内部的请求不稳定，导致docker解析镜像仓库域名时失败。

解决方法：把现有的DNS网址永久替换成8.8.8.8和114.114.114.114。
  
8.8.8.8是Google公共DNS，全球使用最广泛的DNS之一；114.114.114.114由国内运营商提供，也较稳定。

- nmcli device status   #检查确认网卡名称
- nmcli con mod ens120 ipv4.dns "8.8.8.8 114.114.114.114"
- nmcli con mod ens120 ipv4.ignore-auto-dns yes   #修改原有网关地址，设置永久DNS
- nmcli con up ens120   #重新激活网络连接
- cat /etc/resolv.conf  #验证内容是否修改成功

修改完成后，再次下载mysql镜像，下载成功。











