## What I Have Learned 我学到了什么

2026.4.15记录：此前我已经在工作中使用过相关应用，特别是在做检修的时候，几乎每天都会在系统中使用几种常用命令来查看问题。但是此前在我的运用中，我只是单纯的记着那些命令，什么情况下应该用什么命令操作，已经完全忘记了在上学时学过的从0开始的知识，所以这次，我有从0开始复习，再次去了解系统怎么搭建、为什么要这么操作。我花了一个小时的时间才搭建起来系统，并且用finalshell远程连通。在过程中遇到一个虽然是很初级但还是稍为难住我的问题：我在用shell远程连接linux的过程中，开始一直显示<img width="394" height="36" alt="截屏2026-04-15 17 14 51" src="https://github.com/user-attachments/assets/c7be47fd-4793-4f45-90f8-0ad0e5d24e7d" />这个错误。由于之前我在工作中只参与了使用部分——一套已经搭建完成可以稳定使用的系统。所以我还是想把这个错误记录下来。出问题的点是：linux系统默认开启防火墙，阻止了端口访问，导致连接失败。我在虚拟机中允许端口通过后，就成功解决了这个问题。今天正式进入内容操作学习，将开始重新把关于linux的常用功能过一遍。加油！<img width="1138" height="697" alt="截屏2026-04-15 17 34 57" src="https://github.com/user-attachments/assets/fa291e05-70af-4364-baa0-f52cb35fe583" />

2026.4.27记录：在使用 su - root 命令进入root用户时，一直显示下图错误，确定密码没有输错。<img width="239" height="48" alt="image" src="https://github.com/user-attachments/assets/b40e4d01-467e-419a-b5b1-179fb465c5d4" />
尝试使用 sudo passwd -S root命令检查，发现：账号状态被锁定。<img width="247" height="46" alt="image" src="https://github.com/user-attachments/assets/f0a5592f-3586-4e7c-af8b-7cda12c5b1fd" />执行 sudo passwd root 重新设置密码解锁后，就能正常切换到root用户。

2026.5.21记录：此前使用的是ubuntu系统，在使用过程中没有出现过普通用户无法使用sudo命令的情况，最近安装了Rocky系统的简易版本，一些命令是没有自带的，需要自行安装，且第一次遇到普通用户无法执行sudo命令，没有这个权限，提示：mg(用户) is not in the sudoersfile.This incident will be reported.进入root用户层级，执行sermod -aG wheel mg 操作，成功后退回普通用户，重新登录meng用户就可以正常使用sudo了。
