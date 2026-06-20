PHP+MySQL类网站系统在实际生产环境中应用非常广泛，如社区论坛、博客、企业官网、在线商城、企业内部Wiki等网站。

本次学习使用Rocky系统，以discuz为例，结合迁移网站到新服务器、数据库被攻击或损坏需要直接修复、批量修改数据、性能优化和故障排查等真实场景预设进行实战项目操作演练。

网站完整搭建共有这几个步骤：
- 搭建LNMP环境
- 在mysql手动创建数据库和数据库用户
- 下载discuz安装包并解压
- 写nginx配置文件
- 浏览器访问进入discuz网页安装导向并完成信息导入
- 安装完成后就可以用设定的管理员账户登录后台管理内容

 以下是完整搭建过程记录：

 （1）搭建LNMP环境：安装nginx,mysql,php-fpm，很简单，不赘述。
 
 （2）在mysql手动创建数据库和数据库用户
- mysql -u root -p    #输入密码进入数据库
- create database Discuz_Data;    #创建名为Discuz_Data的数据库
- SHOUW VARIABLES LIKE 'character_set_database';    #查看数据库字符集版本，若使老版本，可手动设置成新版本
- create database '数据库名称'character set utf8mb4;    #手动设置目标数据库的新版本字符集
- SHOW DATABASES;    #查看数据库
- create user 'discuzmod'@'%'identified by '密码';    #创建管理员discuzmod，允许该用户使用密码认证从任意地址登录
- garan all privileges on Discuz_Data.* to 'Discuzmod'@'%';    #给管理员discuzmod赋予权限，可以管理Discuz_Data这个数据库的所有表项
- flush privileges;
- quit

 （3）下载discuz安装包并解压到特定目录
  我记录了两种下载安装到方法，一种是wget命令直接下载，另一种是先下载到本机，再上传到虚拟机系统中。

  法一：直接wget命令下载。cd 到/web目录下，执行如下命令：
- wget https://gitee.com/Discuz/DiscuzX/attach_files/1634532/download/Discuz_X3.5_SC_UTF8.zip

  法二：下载到本机再上传。https://gitee.com/Discuz/DiscuzX/releases 网站下载匹配版本的zip文件，然后上传到Linux中。为了方便管理，先创建一个自己固定存放应用安装包的目录。
  上传需要使用rz命令，若之前没有使用过上传下载命令，需要先安装lrzsz.

  压缩包下载完成后，解压文件。若没有安装过解压工具，需要先安装，因为下载的是zip压缩文件，所以安装unzip解压。
- unzip Discuz_X3.5_SC_UTF8.zip -d discuz_temp    #解压Discuz_X3.5_SC_UTF8.zip文件并创建一个discuz_temp目录来存放解压后的文件

  解压完成后ls查看一下文件夹内容，确保upload/文件存在，这个文件是真正的网站文件，很重要。然后使用mv命令把这个文件移动到/web/discuz目录下。
  给/web/discuz目录设置为最高权限（777）。

 （4）写nginx配置文件
- vim /etc/nginx/conf.d/discuz.conf

  进入插入模式，写入discuz.conf[discuz.conf](/scripts/discuz.conf)文件内的配置内容，然后保存退出。或者可以直接把discuz.conf文件下载到/etc/nginx/conf.d/目录下。文件内server_name *.*.*.*; 位置需改成自己IP地址。

 ⚠️因为80端口已经被我在其他网站文件占用，为了不打架，使用了新的8090端口。这个端口此前没有使用过，初次使用会被防火墙拦截，所以需要放行8090端口。
  
   方法如下：
- firewall-cmd--permanent--add-port=80/tcp
- firewall-cmd--reload
- firewall-cmd--list-ports
- systemctl restart nginx

 （5）浏览器访问进入discuz网页安装导向并完成信息导入

  以上配置完成后，浏览器输入http://ip地址:8090 访问，会进入discuz安装向导页面，填入mysql中创建的数据库的连接信息，discuz就会自动往这个空数据库写入它需要的表结构和初始数据。
  根据安装向导提示往下设置discuz管理员的账号密码，初步设置就完成了。


