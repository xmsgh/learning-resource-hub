#!/bin/bash
#FileName:anti_dos.sh
#Version:1.0
#Date:2026-5-28
#Authoe:mg
Server=$(cat /etc/hostname)
More_Nums=$(awk '{print $1}' /var/log/nginx/access.log | sort -n |uniq -c | sort -rn | head -1 | awk '{print $1}')
Attack_ip=$(awk '{print $1}' /var/log/nginx/access.log | sort -n | uniq -c | sort -rn |head -1 | awk '{print $2}')
echo -e "\n$(date +'%m月%d日-%H时%M分')最大链接次数：${More_Nums},访问IP：${Attack_ip}" >> /home/meng/shell/log/anti_dos.log
export LANG=en_US.UTF-8
if [ ${More_Nums} -gt 10000 ]
then
        echo "警告，服务器${Server}遭受攻击，连接次数达${More_Nums}次，攻击地址为${Attack_ip}" | s-nail -s '服务器遭受dos攻击警告' 111@163.com
fi
