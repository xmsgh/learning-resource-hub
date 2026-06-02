# Linux Learning Resources

This page collects Linux-related learning resources, notes, and useful repositories.
本页面收集与 Linux 相关的学习资源、笔记和有用的代码库。
---
## Current Progress

- Status: Started
- Current Focus: Linux basic commands and file system structure
- Next Step: Learn permissions and process management

## Resource List

| Resource Name | Link | Type | Why I Saved It | Status |
|---|---|---|---|---|
| Example | [GitHub Repo](#) | Notes / Tutorial | Good for Linux basics | To Study |

---

## What I Have Learned 我学到了什么
2026.4.15记录：此前我已经在工作中使用过相关应用，特别是在做检修的时候，几乎每天都会在系统中使用几种常用命令来查看问题。但是此前在我的运用中，我只是单纯的记着那些命令，什么情况下应该用什么命令操作，已经完全忘记了在上学时学过的从0开始的知识，所以这次，我有从0开始复习，再次去了解系统怎么搭建、为什么要这么操作。我花了一个小时的时间才搭建起来系统，并且用finalshell远程连通。在过程中遇到一个虽然是很初级但还是稍为难住我的问题：我在用shell远程连接linux的过程中，开始一直显示<img width="394" height="36" alt="截屏2026-04-15 17 14 51" src="https://github.com/user-attachments/assets/c7be47fd-4793-4f45-90f8-0ad0e5d24e7d" />这个错误。由于之前我在工作中只参与了使用部分——一套已经搭建完成可以稳定使用的系统。所以我还是想把这个错误记录下来。出问题的点是：linux系统默认开启防火墙，阻止了端口访问，导致连接失败。我在虚拟机中允许端口通过后，就成功解决了这个问题。今天正式进入内容操作学习，将开始重新把关于linux的常用功能过一遍。加油！<img width="1138" height="697" alt="截屏2026-04-15 17 34 57" src="https://github.com/user-attachments/assets/fa291e05-70af-4364-baa0-f52cb35fe583" />

2026.4.27记录：在使用 su - root 命令进入root用户时，一直显示下图错误，确定密码没有输错。<img width="239" height="48" alt="image" src="https://github.com/user-attachments/assets/b40e4d01-467e-419a-b5b1-179fb465c5d4" />
尝试使用 sudo passwd -S root命令检查，发现：账号状态被锁定。<img width="247" height="46" alt="image" src="https://github.com/user-attachments/assets/f0a5592f-3586-4e7c-af8b-7cda12c5b1fd" />执行 sudo passwd root 重新设置密码解锁后，就能正常切换到root用户。

2026.5.21记录：此前使用的是ubuntu系统，在使用过程中没有出现过普通用户无法使用sudo命令的情况，最近安装了Rocky系统的简易版本，一些命令是没有自带的，需要自行安装，且第一次遇到普通用户无法执行sudo命令，没有这个权限，提示：mg(用户) is not in the sudoersfile.This incident will be reported.进入root用户层级，执行sermod -aG wheel mg 操作，成功后退回普通用户，重新登录meng用户就可以正常使用sudo了。

2026.5.21记录：记录一个在使用tar压缩命令时的误操作。我使用tar -zcvf test.gz /home/mg/test 命令压缩文件，由于写了绝对路径，导致整个路径的文件都被压缩到了test.gz压缩包中，在解压是时我才发现这个问题。以后一定要随时记住，压缩文件时先cd进入目标路径，然后在此路径下执行tar操作，要使用相对路径。避免误操作。
2026.5.26项目案例一：编写发送邮件自动化执行脚本，在需要重复操作编写邮件发送任务中提高效率。经过不断试验，最终成功运行并发送邮件到目标邮箱。具体代码如下：
- #!/bin/bash
- #FileName:mail.sh
- #Version2.0
- #Date:2026-5-26
- #Author:mg
- #Descripition:the scrip for smtp configrationfor smtp configration
- read -p "请输入邮箱服务商(163/189/126/qq…):" provider
- read -p "请输入邮箱账号:" account
- read -p "请输入邮箱授权码:" password
- echo "正在配置，请稍等…"
- dnf install -y s-nail postfix > /dev/null
- cat >> /etc/.mailrc << EOF
- set v15-compat=yes
- set mta=smtps://${account}%40${provider}.com:${password}@smtp.${provider}.com:465
- set from=${account}@${provider}.com
- set ssl-verify=ignore
- EOF
- systemctl start postfix
一开始编写的1.0版本使用的是v14版本的smtp，适用于Centos7以下的系统，现在的Rocky需要使用v15版本的命令，否则发送邮件的时候会一直弹出警告。多次测试一直无法成功发送邮件，询问AI，建议使用v15版本适配的命令格式，所以改成2.0版本（即当前版本）后运行成功。在40行中的%40是@的URL转义，因为URL中@有特殊含义（用于分隔用户名和主机），必须转义，不然会一直报错。
另外需要再次自省，在敲命令的时候一定要认真再认真，一开始把from写成了form，一直没发现，因为 form 不是有效的配置项，s-nail 没有设置发件人地址，导致发送时使用了系统默认的发件人（如 root@localhost），与认证用户不匹配，SMTP服务器拒绝了请求。
这只是个小的项目演示，只是完成了可以通过一条命令自动发送邮件的功能。思考：在实际网络管理维护中，加入管道符等筛选过滤命令，可以将日志中的警告、错误等信息打包编写成邮件内容定时发送到目标邮箱，是否也可以作为远程实时监测的一种手段。

2026.5.27实战项目二：自动备份数据库，下载日志。实现在特定时间自动备份数据库，将数据库的备份文件进行压缩。并且压缩包用当前日期命名，再把压缩包拷贝到nfs文件共享服务器一份，然后删除本地备份的30天前的所有老文件，nfs共享存储里不删。执行完后，记录下日志。具体代码如下：
#!/bin/bash
#FileName:sql_backup.sh
#Version:1.0
#Date:2026-5-26
#Author:mg
#Description:the script for backup mysql of opencart
time=$(date +"%y-%m-%d %H:%M")
mysqldump -uroot -p ******* oc202605 > backup/opencart.sql 2>/dev/null
tar -zcf backup/yasuo-$time.tar.gz backup/opencart.sql --remove-files 2>/dev/null
rsync backup/* /mnt/nfs_share
find backup/* -mtime +30 | xargs rm -rf
echo "well done!备份时间为$time" >> backup.log
这个案例需要使用到mysql数据库。下载安装办法不赘述，使用到的命令工具也很简单。*******是登录mysql的密码。oc202605是在mysql创建的数据路名称。
创建文件并写入如上代码，保存后退出，执行./sql_backup.sh脚本便可。
随后可用cat命令查看backup.log的内容，会有压缩成功的提示。backup目录下会多了以yasuo-具体时间命名的压缩包。

2026.5.28实战项目三：带条件判断自动化监测nginx等应用是否有异常，若有异常，则自动重启服务。
nginx运行在服务器上，负责接收和处理来自互联网用户的请求,反向代理，保护后段安全。在日常生产活动中有很重要的作用，所以监测nginx运行状况非常有必要。具体代码如下：
#!/bin/bash
#FileName:nginx_error.sh
#Version:1.2
#Date:2026-5-27
#Author:mg
while true
do
        if ! netstat -nltp | grep 80 > /dev/null
        then
                echo "$(date +%Y年%m月%d日%H时%M分%S秒) - Nginx 停止运行，正在重启……" | tee -a /shell/log/nginx_error.log
                systemctl start nginx
        else
                echo "$(date +%Y年%m月%d日%H时%M分%S秒) -Nginx 正常运行" | tee -a /shell/log/nginx_normal.log
        fi
        sleep 3
done
编写完成后保存退出，先关nginx，然后执行脚本文件，结果如图所示：
<img width="461" height="122" alt="截屏2026-05-28 18 08 40" src="https://github.com/user-attachments/assets/b8fd4dd6-1bfc-430a-8e54-83d531d00597" />
脚本运行成功。思考：在实际生产环境中，如何实现脚本实时运行监测同时还能完成其他操作？

2026.5.30实战项目四:自动监测web，每小时检查访问日志，如果出现恶意访问IP（设定为每小时访问次数超过一万），则自动提取出恶意IP及访问次数，通过邮件通知管理员。具体代码如下:
Server=$(cat /etc/hostname)
More_Nums=$(awk '{print $1}' /var/log/nginx/access.log | sort -n | uniq -c | sort -rn | head -1 | awk '{print $1}')
#获取最大访问次数.
Attack_ip=$(awk '{print $1}' /var/log/nginx/access.log | sort -n | uniq -c | sort -rn |head -1 | awk '{print $2}')
#获取最大访问次数对应的IP.
echo -e "\n$(date +'%m月%d日-%H时%M分')最大链接次数：${More_Nums},访问IP：${Attack_ip}" >> /home/meng/shell/log/anti_dos.log
export LANG=en_US.UTF-8
为了解决 s-nail 发送中文邮件时的编码报错问题，在发送邮件前设置好编码环境。
if [ ${More_Nums} -gt 10000 ]
#-gt是数学中的大于号 >,判断左边是否大于右边.
then
        echo "警告，服务器${Server}遭受攻击，连接次数达${More_Nums}次，攻击地址为${Attack_ip}" | s-nail -s '服务器遭受dos攻击警告' 490152939@qq.com
fi
- 这个脚本要能正常运行,得先跑通实战一的自动发送邮件脚本,还有一个很重要的点,得分清楚存放邮件信息的文件夹位置,若自动发送邮件的脚本设置的存储位置在当前用户,再使用root用户执行这个脚本时也会出错,因为root用户会自动查询当前用户下的存放位置,没有找到内容,便无法响应成功,解决办法是,可以把普通用户存放邮箱信息的文件复制一份到root用户下,再次执行便能执行成功了.
## My Current Linux Focus

- Linux basic commands
- File system structure
- User and permission management
- Process and service management
- Networking basics in Linux
- Shell scripting basics
