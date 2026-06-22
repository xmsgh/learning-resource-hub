<img width="585" height="124" alt="截屏2026-06-22 22 26 20" src="https://github.com/user-attachments/assets/b5ca5bd8-8bc0-4cc3-adf2-4246cf2f3ad3" />zabbix是应用最广泛的IT运维工具之一，主要实现实时监测与告警管理，其核心能力覆盖网络参数、服务器状态、应用程序性能等多个纬度，为企业运维提供全链路保障。
以下为学习zabbix部署配置及基础使用方法的记录。

本次项目案例需要服务器和客户端互相配合操作，我使用Rocky系统作为服务器端，使用ubuntu系统作为客户端。

在开始前，关闭防火墙和selinux,目的是为了排除干扰，能先确认在操作过程中配置本身是否正确。在实际生产过程中，最好不关闭防火墙，而是精准放行端口，避免暴露。

先准备好以下软件：tar,net-tools,wget,php,php-fpm,php-mysqlnd,nginx,mysql.
- dnf install -y zabbix-server-mysql zabbix-web-mysql zabbix-nginx-conf zabbix-sql-scripts zabbix-selinux-policy zabbix-agent

由于系统自带的下载器中没有zabbix的安装包，所以需要下载一个新的下载源。
- rpm -Uvh https://repo.zabbix.com/zabbix/7.0/rhel/9/x86_64/zabbix-release-7.0-4.el9.noarch.rpm

以上准备完毕后，开始搭建zabbix.

（1）数据库配置

启动并登录数据库，创建一个名为zabbix_base的数据库。

创建zabbix_root用户并允许在任何IP通过密码登录，设置允许zabbix_root用户在任何IP访问zabbix_base数据库内的所有表项。

开启允许上传数据权限。
- SET GLOBAL log_bin_trust_function_creators = 1;

退出mysql,回到root用户,查找具体的SQL文件的真实位置，把server.sql.gz的数据导入mysql中的zabbix_base的数据库。
- find /usr/share/zabbix* -name "*.sql*" 2>/dev/null
- zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix_root -p zabbix_base

检查zabbix数据库里有没有表，查看数据是否导入。
- mysql -uroot -p -e "use zabbix_base; show tables;"

再次进入mysql,关闭log_bin_trust_function_creators的权限。
- SET GLOBAL log_bin_trust_function_creators = 0;

（2）nginx配置
Zabbix 安装包默认生成的配置里，监听端口这一行前面有 #，处于禁用状态，nginx根本不会去监听这个端口，首先要激活这个端口监听，让nginx真正开始对外提供Zabbix Web界面的访问服务。

vim编辑器进入/etc/nginx/conf.d/zabbix.conf文件，把监听端口号(第二行)前面的注释#删除。保存退出后，重启nginx并检查确认端口号是否在监听。
<img width="430" height="96" alt="截屏2026-06-22 21 34 44" src="https://github.com/user-attachments/assets/ea6c0f7b-6a41-4926-a6da-cb1c690c581e" />

（3）配置zabbix服务器

vim 进入/etc/zabbix/zabbix_server.conf文件，在DBPassword位置添加密码，把注释去掉。

修改DBName对应的名称为创建的数据库名。修改DBUser对应的用户为创建的用户名。

完成后保存退出，重启zabbix-server,zabbix-agent,nginx,php-fpm等软件。

（4）进行zabbix ui界面配置
浏览器输入 http://ip地址:8080 进入配置界面。若前面的操作无误，现在能正常打开界面。

输入地址登录后点下一步，在登录设置界面要输入设置的数据库名称和账号名称，继续往下，在最后一步如截图所示，设置自己的用户名和密码并记住。
<img width="364" height="361" alt="截屏2026-06-22 21 37 03" src="https://github.com/user-attachments/assets/a70595c1-63f7-47ee-bee8-858065144ded" />

我使用ubuntu系统作为被监测主机（客户端）。把被监测主机添加到zabbix中，配置如下图所示：
<img width="591" height="321" alt="截屏2026-06-22 21 42 04" src="https://github.com/user-attachments/assets/0525d8dd-56e5-4334-bc76-869db76c6f65" />
Agent为被监测主机的IP地址，为方便管理，主机名称也可设置为被监测主机的IP地址。注意模板和主机机群的选择。

（5）配置被监控主机
回到被监测主机终端，关闭防火墙和selinux.安装zabbix下载源并下载安装zabbix。
注意⚠️在每次安装时需要选择匹配的安装源，否则无法正确下载需要的应用。
我在操作时使用的是ubuntu系统24.04版本。
- wget https://repo.zabbix.com/zabbix/7.2/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.2+ubuntu24.04_all.deb
- dpkg -i zabbix-release_latest_7.2+ubuntu24.04_all.deb  #dpkg -i — 安装这个本地的deb包，把Zabbix官方源地址写入到 /etc/apt/sources.list.d/zabbix.list 文件里。
- apt install -y zabbix-agent
  
下载完成后，进入zabbix客户端配置文件（/etc/zabbix/zabbix_agentd.conf），找到并修改如下内容：
<img width="305" height="192" alt="截屏2026-06-22 21 55 28" src="https://github.com/user-attachments/assets/0a7e354b-a7c9-4ec1-8a96-542e0f57c47e" />
Hostname 是客户端IP；Server是服务器端IP。⚠️一定不要改错，否则无法正常访问。修改完成后重启zabbix-agent。

至此，若以上操作无误，可以实现zabbix网站实时监测。
可以做一个压力测试，在客户机中执行从根目录开始所有文件进行压缩，在网站监测CPU占用率是否飙升，来验证是否监测成功。

（6）邮件告警配置

在服务器端配置自动部署邮件发送，过程不再赘述，可以参考[mail-auto-config.md](shell/mail-auto-config.md)部分的学习记录。

自动化部署完成后，到监测网站修改如下内容：
<img width="592" height="360" alt="截屏2026-06-22 22 04 49" src="https://github.com/user-attachments/assets/3ebcdd84-d092-49ef-8e58-2422d9baa97d" />

告警媒介设置好后需要测试，输入收件人点击测试，出现成功提示则设置成功，如下图所示：
<img width="547" height="274" alt="截屏2026-06-22 22 06 04" src="https://github.com/user-attachments/assets/b3d6e7b0-7a53-496e-ba8e-6b6377c4b483" />

在告警-动作中找到刚才设置的媒介，点击添加标签，选择主机。
<img width="586" height="416" alt="截屏2026-06-22 22 06 51" src="https://github.com/user-attachments/assets/359b3d8f-30a0-4659-8e2f-1fe21b828897" />

设置完动作后，设置操作行为，点击蓝色的添加按钮，分别加入需要提示的信息，如下所示：
<img width="592" height="517" alt="截屏2026-06-22 22 08 00" src="https://github.com/user-attachments/assets/5efdbc90-635c-4c2c-9cf6-d660dbc45e32" />

在用户-用户中选择自己的账号Admin点击进入，设置报警媒介，在这里设置收件人邮箱以及选择什么程度的警告发送邮件，设置启用时间。
<img width="590" height="346" alt="截屏2026-06-22 22 08 43" src="https://github.com/user-attachments/assets/8ec70ccb-7b7b-4541-9b50-61202d7ded54" />

设置好后点击更新退出，⚠️一定要记得再次点击下方的更新按钮，否则没有正式启动。
<img width="624" height="138" alt="截屏2026-06-22 22 09 15" src="https://github.com/user-attachments/assets/d4f368d9-2fde-438d-ad3d-7faaf0b2b199" />

至此，邮件告警配置完成。

（7）错误记录

1️⃣在安装zabbix中，安装好dnf下载源后，安装zabbix相关应用，结果提示：
cannot install both zabbix-web-7.0.27 from zabbix 
and zabbix-web-1:6.0.46 from epel

这是因为EPEL 源里有一个旧版的 zabbix-web 6.0，和 Zabbix 官方源的 7.0 版本冲突了，dnf 不知道该装哪个，导致安装失败。
解决办法：

第一步：排除 EPEL 源中的 zabbix 相关包:
- dnf config-manager --save --setopt=epel.excludepkgs=zabbix*    #编辑EPEL源配置，让它不提供zabbix相关包

第二步：清理缓存
- dnf clean all 
- dnf makecache

然后再重新安装，就成功了。

2️⃣监测网站显示zabbix服务没有运行问题，如下图所示：
<img width="575" height="39" alt="截屏2026-06-22 22 25 15" src="https://github.com/user-attachments/assets/bff4f656-0d13-48d6-ab1d-41d23f528a39" />

第一次配置完成，结果网站显示服务没有启动。解决办法：

在监测主机上检查zabbix-server的状态，确认已经启动。

查看zabbix日志：
- tail -50 /var/log/zabbix/zabbix_server.log    #查看日志文件内的最新50行内容
<img width="585" height="124" alt="截屏2026-06-22 22 26 36" src="https://github.com/user-attachments/assets/2e47bbdd-89a6-49fc-bb00-b037b023a164" />

日志显示Access denied for user 'zabbix'@'localhost' (using password: YES)，这是常见的密码错误。

查看 zabbix_server.conf 里配置的密码：
- grep "DBPassword" /etc/zabbix/zabbix_server.conf
- 
结果和我输入的一致，没有错误。
再次仔细查看日志报告，发现'zabbix'@'localhost' 这个信息，我在mysql创建数据库时，账号名称为zabbix_root，初步判断错误位置就在这儿。

返回查看 /etc/zabbix/zabbix_server.conf内的信息，发现我一开始只在文件里增加了密码，没有修改账号名称和数据库名称，修改后重启zabbix-server，发现本机监测IP启动成功。

3️⃣目标监测IP启动失败问题。第一次修改完成后，监控网站只有本机监测启动成功，目标监测IP没有启动成功。
说明服务器端运行正常了，问题应该出在客户端。问题提示如下图示：
<img width="590" height="127" alt="截屏2026-06-22 22 28 49" src="https://github.com/user-attachments/assets/514a1680-6fdd-497a-9d64-e227abb06187" />
提示客户端拒绝的服务器端的连接，判断应该是权限配置出了问题。客户端的配置文件里没有允许这台server来访。

检查agent配置文件：
- vim /etc/zabbix/zabbix_agent.conf
  
直接/搜索Server=的相关信息，发现除了Server外，还有一个ServerActive。
Server是允许哪个server来主动获取数据（被动模式）；
ServerActive是允许哪个server发送主动监控任务；
都需要设置正确的IP地址。把ServerActive位置的IP修改为服务器IP后，网站监控启动成功。

4️⃣配置邮件告警时无法收到邮件提醒。

在配置完被监控主机后，修改CPU告警阈值第一次压力测试，仪表盘成功按预期显示告警信息。
但是在第二次测试时，监控网站没有任何的错误提示，客户端的监控也成功连接开启，但是无法收到客户端的任何信息。
查看最新数据，最近记录、最新数据、更改均为空，明 Zabbix server 根本没有从测试服务器采集到任何数据。
<img width="593" height="347" alt="截屏2026-06-22 22 31 06" src="https://github.com/user-attachments/assets/5d465010-dadd-47ab-b6dd-40a197f08ce2" />

确认配置文件正确且没有更改过。
确认服务器和客户端zabbix均已启动。
确认10050端口在运行且被监听。

使用zabbix_get命令测试从 zabbix server 手动测试获取客户端数据，成功获得数字，没有报错，确认agent 通信正常。
- zabbix_get -s 172.16.234.128 -p 10050 -k "system.cpu.util"

再次查看日志，注意到告警信息里有一条：Linux: System time is out of sync (diff with Zabbix server > 60s)系统时间不同步告警提醒，怀疑问题出在这里。
检查客户端zabbix-agentd.log日志，发现连接10051失败后，主动检查失败，
然后系统时间被回拨，导致agent 调度混乱，server 判断数据时间戳异常，从而触发了一系列连锁故障。
- tail -50 /var/log/zabbix/zabbix_agentd.log

连接10051失败应该是一开始没有关闭防火墙，导致从客户机到服务器方向的通信被阻断，后来在检查时关闭了防火墙，但是记录还在。

解决办法：在服务器和客户端安装并启动时间同步。
- apt install -y chrony
- systemctl start chronyd
- systemctl enable chronyd
- chronyc makestep    #强制立即同步
- chronyc tracking    #确认同步正常

然后均重启zabbix，再次回到监控网站，最新数据开始更新。压力测试告警成功显示，邮件发送成功。

