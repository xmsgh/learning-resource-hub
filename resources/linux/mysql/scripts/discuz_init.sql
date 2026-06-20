mysql -u root -p    #输入密码进入数据库
create database Discuz_Data;    #创建名为Discuz_Data的数据库
SHOUW VARIABLES LIKE 'character_set_database';    #查看数据库字符集版本，若使老版本，可手动设置成新版本
create database '数据库名称'character set utf8mb4;    #手动设置目标数据库的新版本字符集
SHOW DATABASES;    #查看数据库
create user 'discuzmod'@'%'identified by '密码';    #创建管理员discuzmod，允许该用户使用密码认证从任意地址登录
garan all privileges on Discuz_Data.* to 'Discuzmod'@'%';    #给管理员discuzmod赋予权限，可以管理Discuz_Data这个数据库的所有表项
flush privileges;
quit
