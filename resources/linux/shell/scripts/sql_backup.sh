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
