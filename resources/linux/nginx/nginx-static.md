项目：部署nginx静态站点。
- nginx有搭建部署网站，反向代理服务器、负载均衡，分散大量访问压力等作用，在实际生产中，特别是中大型企业运用很广泛。学习nginx的简单操纵，练习把一个自己制作的文本转变成网页格式，然后搭建到网络上，让任何人都能浏览。在Linux中，一切皆文件，网站部署其实就是用代码文件准确读取并传输内容文件。要修改代码配置，就是修改nginx.conf文件的server{}部分内容。要修改实际内容，就是在/usr/share/nginx/html 中传入一个新的目标内容文件。在/usr/share/nginx/html 中原有的index.html文件的内容就是nginx默认欢迎页。我一共记录了四种修改方式：

（1）直接把/usr/share/nginx/html中原有的index.html文件删除，替换成想要制作的目标文件，并把这个问价改名为index.html。这是测试初期最方便的一个方法，只需需要一个文件就能实现目标内容静态部署。

- 若不想删除默认文件，有三种方法可以实现静态部署：
  
（2）在/usr/share/nginx/html目录下创建新的html文件，如test.html，然后把想要发布的内容粘贴并保存。访问时直接输入：http://服务器IP/test.html就可以实现访问。

（3）在/usr/share/nginx/html目录下创一个test/目录，然后在test/目录中创建index.html并写入目标内容。访问时直接输入：http://服务器IP/test/就可以实现访问。

（4）修改/etc/nginx/nginx.conf文件的server{}部分内容，增加新的server{}块，用不同端口区分网站。在文件中加入如下内容：

- #网站二：8080端口
- server {
-     listen 8080;
-     root /usr/share/nginx/site2;
- }

这种方法需要在/usr/share/nginx/目录下创建一个新的目录site2/来存放index.html,注意⚠️这个目录和html在同一个层级。这个方法因为修改了nginx的配置，需要重启nginx才能生效。重启后，从浏览器访问时需要加上具体的端口号,输入http://服务器IP:8080可进入网站页面。
要特别注意，在修改或加入任何内容时，都要仔细检查路径是否一致。
