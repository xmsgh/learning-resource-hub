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
具体SQL见[discuz_init.sql](scripts/discuz_init.sql)

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

  进入插入模式，写入[discuz.conf](scripts/discuz.conf)文件内的配置内容，然后保存退出。或者可以直接把discuz.conf文件下载到/etc/nginx/conf.d/目录下。文件内server_name *.*.*.*; 位置需改成自己IP地址。

 ⚠️因为80端口已经被我在其他网站文件占用，为了不打架，使用了新的8090端口。这个端口此前没有使用过，初次使用会被防火墙拦截，所以需要放行8090端口。
  
   方法如下：
- firewall-cmd--permanent--add-port=80/tcp
- firewall-cmd--reload
- firewall-cmd--list-ports
- systemctl restart nginx

 （5）浏览器访问进入discuz网页安装导向并完成信息导入

  以上配置完成后，浏览器输入http://ip地址:8090 访问，会进入discuz安装向导页面，填入mysql中创建的数据库的连接信息，discuz就会自动往这个空数据库写入它需要的表结构和初始数据。
  根据安装向导提示往下设置discuz管理员的账号密码，初步设置就完成了。

  (6)后台管理
  
  为方便操作观察区别，可以在diacuz中先创建几个账号并写入不同的信息。
  
  登录mysql数据库，进入存放discuz数据的数据库并查看数据
 - use Discuz_Data;
 - SHOW TABLES;

   1️⃣查看用户信息
 - select realname,birthday from pre_common_member_profile;
   
  select命令可在数据库中查看用户信息，如realname,birthday等，个人信息存放在pre_common_member_profile文件中。把realname,birthday位置改成*便可查看所有用户的所有信息。

   2️⃣定向搜索信息
 - select realname from pre_common_member_profile where birthday='2000';

   where命令用于筛选特定条件，还可多条件筛选，加上 and,or等条件实现。

   3️⃣修改用户信息
 - update pre_common_memeber_profile set affectivestatus = ‘已婚’ where realname= ‘李华’; #把真实姓名为李华的用户信息情感状态设置为已婚
 - update pre_common_member_profile set resideprovince = ‘北京’; #把表中所有用户的所在地信息改为北京
 - update pre_common_member_profile set company = ‘ ‘ where realname = ‘李华’; #删除某位用户的部分信息，把要删除的信息位置改成空就行
 - delete from pre_common_member_profile;  #删除整张表。这样做会删除所有用户的所有信息，删除前一定要反复确认是否执行这个动作。

   4️⃣数据库备份和还原
   在root用户根目录下备份:
 - mysqldump -uroot -p密码 数据库名称 > 备份文件名.sql #-p密码中间不能有空格

   登录到mysql	中，进入数据库：
 - delete from pre_common_member_profile where realname=’李华’; #从pre数据表中删除真实姓名为李华的所有信息

   在root用户根目录下还原:
 - mysql -uroot -p密码 数据库名称 < 备份文件名.sql

   5️⃣mysql登录密码恢复
   root 用户下，
 - vim /etc/my.cnf.d/mysql-server	.cnf
   
   #编辑mysql的配置文件，在[mysql]位置下一行添加：
 - skip-grant-tables  #设置可以跳过密码登录

   然后保存退出，再次进入数据库，不用输入密码回车便可直接登录。

   进入mysql后，USE 命令进入mysql本身的数据库，然后执行如下命令把密码字段彻底清除：
   
 - UPDATE mysql.user SET authentication_string = ‘’ WHERE user = ‘root’;

   刷新并退出mysql.
   

   再次进入/etc/my.cnf.d/mysql-server.cnf文件，把跳过密码的设置删掉或注释掉,然后保存退出。

   重启mysql后，再次进入，此时密码为空，直接回车就能进入，然后执行如下命令设置新密码：

 - ALTER USER ‘root’@’localhost’ IDENTIFIED BY ‘新密码’;
 - FLUSH PRIVILEGES;
 - quit
 - systemctl restart mysql

   再次进入mysql时，需要输入新密码。

   以上就是在学习使用mysql时结合实际案例操作的学习记录，学习只是开始，还要不断重复，老几加油！
