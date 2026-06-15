带条件判断自动化监测nginx等应用是否有异常，若有异常，则自动重启服务。
nginx运行在服务器上，负责接收和处理来自互联网用户的请求,反向代理，保护后段安全。在日常生产活动中有很重要的作用，所以监测nginx运行状况非常有必要。具体代码如[nginx_error.sh](scripts/nginx_error.sh)所示。

编写完成后保存退出，先关闭nginx，然后执行脚本文件进行测试，结果如图所示：
<img width="461" height="122" alt="截屏2026-05-28 18 08 40" src="https://github.com/user-attachments/assets/b8fd4dd6-1bfc-430a-8e54-83d531d00597" />

脚本运行成功。思考：在实际生产环境中，如何实现脚本实时运行监测同时还能完成其他操作？
