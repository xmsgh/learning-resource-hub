项目：部署nginx动态站点。

部署动态站点除了使用到nginx外，还需要mysql、php-fpm需提前安装。

(1)首先要在数据库中创建一个新的数据库文件和新用户并配置相关权限。具体操作如下：
- mysql -uroot -p 
- create database Trend_page; 
- create user  ‘wordmin’@’%’ identified by ‘mima’;
- #创建一个新的用户wordmin和密码,这个用户允许从任何IP地址登录
- #%:允许所有IP都可登录数据库进行管理
- grant all privileges on Trend_page.* to ‘wordmin’@’%’;
- #给刚才的新用户赋予权限,可以管理Trend_page这个库的所有表项
- flush privileges;
- quit
  
(2)到/etc/nginx/conf.d目录下创建一个新的配置文件并写入[Trend_page.conf](scripts/Trend_page.conf)内容,检查无误后保存退出，重启nginx，检查网络连接状态,若看到2001端口,说明新网站启动成功。
⚠️Trend_page.conf脚本文件不能直接运行，需要把里面的IP地址换成自己的IP。

(3)修改php配置
vim /etc/php-fpm.d/www.conf进入文件.
/输入listen搜索,n键往下,找到 listen = /run/php-fpm/www.sock位置,在开头输入;让这一行注释掉(不运行).

在下一行输入: listen = 127.0.0.1:9000

保存退出，重启php-fpm，检查网络连接状态,若看到9000端口,说明启动成功。

(4)从官网下载wordpress文件

此时在/根目录目录下,创建一个/web目录并进入，在这个目录下下载wordpress文件。

完成后使用tar命令解压并把文件名修改为一个容易识别区分的名字。

给这个文件增加读、写、执行权限。

(5)登录web界面

浏览器输入 http://IP地址:2001

根据页面提示输入创建数据库时的配置信息，设置数据库名、用户名、密码，数据库主机IP，进入后就可以设置自己的站点信息。

若忘记了登录密码，可以在数据库中找回，方法如下：

进入mysql后，use Trend_page;切换到Trend_page数据库

select user_login, user_email from wp_users;
#查看用户表，找到自己的用户名，这一步会显示有户名和邮箱

update wp_users set user_pass=MD5('newpassword') where user_login='你的用户名';
#直接修改密码（把newpassword替换为想要的新密码）

设置好后退出mysql，浏览器刷新再次登录就可以使用修改后的密码了。

