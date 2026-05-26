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
#!/bin/bash
#FileName:mail.sh
#Version2.0
#Date:2026-5-26
#Author:mg
#Descripition:the scrip for smtp configrationfor smtp configration
read -p "请输入邮箱服务商(163/189/126/qq…):" provider
read -p "请输入邮箱账号:" account
read -p "请输入邮箱授权码:" password
echo "正在配置，请稍等…"
dnf install -y s-nail postfix > /dev/null
cat >> /etc/.mailrc << EOF
set v15-compat=yes
set mta=smtps://${account}%40${provider}.com:${password}@smtp.${provider}.com:465
set from=${account}@${provider}.com
set ssl-verify=ignore
EOF
systemctl start postfix
#一开始编写的1.0版本使用的是v14版本的smtp，适用于Centos7以下的系统，现在的Rocky需要使用v15版本的命令，否则发送邮件的时候会一直弹出警告。多次测试一直无法成功发送邮件，询问AI，建议使用v15版本适配的命令格式，所以改成2.0版本（即当前版本）后运行成功。在40行中的%40是@的URL转义，因为URL中@有特殊含义（用于分隔用户名和主机），必须转义，不然会一直报错。
另外需要再次自省，在敲命令的时候一定要认真再认真，一开始把from写成了form，一直没发现，因为 form 不是有效的配置项，s-nail 没有设置发件人地址，导致发送时使用了系统默认的发件人（如 root@localhost），与认证用户不匹配，SMTP服务器拒绝了请求。
这只是个小的项目演示，只是完成了可以通过一条命令自动发送邮件的功能。思考：在实际网络管理维护中，加入管道符等筛选过滤命令，可以将日志中的警告、错误等信息打包编写成邮件内容定时发送到目标邮箱，是否也可以作为远程实时监测的一种手段。


- 
- 
  
## My Current Linux Focus

- Linux basic commands
- File system structure
- User and permission management
- Process and service management
- Networking basics in Linux
- Shell scripting basics
