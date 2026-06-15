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
