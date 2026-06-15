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
