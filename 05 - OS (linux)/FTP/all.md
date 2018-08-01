
写权利
/etc/vsftpd/vsftpd.conf

```
# Uncomment this to enable any form of FTP write command.
write_enable=YES
```

windows访问vsftp服务器出现200,227错误 https://blog.csdn.net/w3045872817/article/details/78006480

service vsftpd restart
## **安装** https://www.linuxidc.com/Linux/2017-11/148518.htm
### 1、安装并启动 FTP 服务

yum install -y vsftpd
1.2 启动 VSFTPD

service vsftpd start
启动后，可以看到系统已经监听了 21 端口：

netstat -nltp | grep 21
此时，访问 ftp://192.168.1.170 可浏览机器上的 /var/ftp目录了。

### 2、配置 FTP 权限

*2.1 了解 VSFTP 配置*
vsftpd 的配置目录为 /etc/vsftpd，包含下列的配置文件：

vsftpd.conf 为主要配置文件
ftpusers 配置禁止访问 FTP 服务器的用户列表
user_list 配置用户访问控制

*2.2 阻止匿名访问和切换根目录*
匿名访问和切换根目录都会给服务器带来安全风险，我们把这两个功能关闭。

编辑 /etc/vsftpd/vsftpd.conf，找到下面两处配置并修改：

```
# 禁用匿名用户  12 YES 改为NO
anonymous_enable=NO

# 禁止切换根目录 101 行 删除#
chroot_local_user=YES
```
编辑完成后保存配置，重新启动 FTP 服务

service vsftpd restart

*2.3 创建 FTP 用户*
创建一个用户 ftpuser

useradd ftpuser
为用户 ftpuser 设置密码

echo "javen205" | passwd ftpuser --stdin
*2.4 限制该用户仅能通过 FTP 访问*
限制用户 ftpuser只能通过 FTP 访问服务器，而不能直接登录服务器：

usermod -s /sbin/nologin ftpuser
*2.5 为用户分配主目录*
为用户 ftpuser创建主目录并约定：

/data/ftp 为主目录, 该目录不可上传文件
/data/ftp/pub 文件只能上传到该目录下

在/data中创建相关的目录

mkdir -p /data/ftp/pub
*2.5.1 创建登录欢迎文件*

echo "Welcome to use FTP service." > /data/ftp/welcome.txt
设置访问权限

chmod a-w /data/ftp && chmod 777 -R /data/ftp/pub
设置为用户的主目录：

usermod -d /data/ftp ftpuser

### 3、访问FTP
根据您个人的工作环境，选择一种方式来访问已经搭建的 FTP 服务

注意：记得关闭防火墙或者开放FTP默认端口(21)

# 关闭SELinux服务
setenforce 0
# 关闭防火墙
iptables -F
通过 Windows 资源管理器访问
Windows 用户可以复制下面的链接
到资源管理器的地址栏访问：

ftp://ftpuser:javen205@192.168.1.170
其中ftpuser为登录FTP的用户名，javen205为登录FTP的密码

通过 FTP 客户端工具访问

## **用户 操作** https://blog.csdn.net/piaocoder/article/details/50719149 https://blog.csdn.net/firewolf1758/article/details/73822082
### 1.环境：ftp为vsftp。被设置用户名为test。被限制路径为/home/test

### 2.创建建用户：在root用户下：
useradd -d /home/test test	#增加用户test，并制定test用户的主目录为/home/test
passwd test	#为test用户设置密码

### 3.更改用户相应的权限设置：
usermod -s /sbin/nologin test	#限定用户test不能telnet，只能ftp
usermod -s /bin/bash test	#用户test恢复正常
usermod -d /home/test test      #更改用户test的主目录为/test

### 4.限制用户只能访问/home/test，不能访问其他路径

修改/etc/vsftpd/vsftpd.conf如下：
chroot_list_enable=YES	#限制访问自身目录

# (default follows)

chroot_list_file=/etc/vsftpd/vsftpd.chroot_list

编辑 vsftpd.chroot_list文件，将受限制的用户添加进去，每个用户名一行

改完配置文件，不要忘记重启vsftpd服务器

[root@localhost]# /etc/init.d/vsftpd restart

### 5.如果需要允许用户修改密码，但是又没有telnet登录系统的权限：
```
usermod -s /usr/bin/passwd test      #用户telnet后将直接进入改密界面
```
### 6.如果要删除用户，用下面代码：
```
#在root用户下：
userdel -r newuser
#在普通用户下：
sudo userdel -r newuser
```
