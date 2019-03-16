
centos7 mysql5.7安装

mysql 8.0 安装配置方法教程 http://www.jb51.net/article/98270.htm

mysql https://dev.mysql.com/downloads/repo/yum/  https://www.cnblogs.com/wishwzp/p/7113403.html

mysql http://www.jianshu.com/p/4a41a6df19a6

### 检查已安装的MYSQL
	yum list installed | grep mysql

### 删除
	yum -y remove mysql-libs.x86_64

### 去官网 下载 rpm 的mysql安装
		执行 wget http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
		执行 rpm -ivh mysql-community-release-el7-5.noarch.rpm
		执行 yum install mysql-community-server

### 安装成功后重启mysql 服务
		service mysqld restart  systemctl start mysqld.service  systemctl daemon-reload

### 初次安装mysql，root账户没有密码。
		[root@yl-web yl]# mysql -u root
		mysql> set password for 'root'@'localhost' =password('password');
		不需要重启数据库即可生效。

		grep "password" /var/log/mysqld.log 命令获取MySQL的临时密码

		set global validate_password_policy=0;
		mysql8以后 set global validate_password.policy=0;
		set global validate_password_length=1;

		ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '111111';


### 配置mysql
	编码：
		mysql配置文件为 vi /etc/my.cnf
		最后加上编码配置
			[mysql]
			#default-character-set =utf8
			character-set-server = utf8
		这里的字符编码必须和/usr/share/mysql/charsets/Index.xml中一致。

	远程连接设置：
		把在所有数据库的所有表的所有权限赋值给位于所有IP地址的root用户。
			mysql> grant all privileges on *.* to root@'%'identified by 'password';（填写root 的密码即可）

					flush privileges;
		如果是新用户而不是root，则要先新建用户
						mysql>create user 'username'@'%' identified by 'password';

			查看端口
				netstat -tnlp | grep （过滤）

## 防火墙原因
1、打开防火墙配置文件
vi  /etc/sysconfig/iptables
2、增加下面一行
-A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT
3、重启防火墙
service  iptables restart

1、安装iptable iptable-service

#先检查是否安装了iptables
service iptables status
#安装iptables
yum install -y iptables
#升级iptables（安装的最新版本则不需要）
yum update iptables
#安装iptables-services
yum install iptables-services


mysql 的配置文件 /etc/my.cnf
		可以配置端口，日志文件信息等等


查看 linux 是否在 监听某一个端口：
	ss -tnl | grep 3306

默认配置文件路径：
配置文件：		/etc/my.cnf
日志文件：		/var/log/mysqld.log
服务启动脚本：  /usr/lib/systemd/system/mysqld.service
socket文件：	/var/run/mysqld/mysqld.pid


启动文件 /etc/init.d/mysqld
参数文件 /etc/my.cnf
日志文件 /var/log/mysqld.log
sock文件 /var/lib/mysql/mysql.sock
pid文件/var/run/mysqld/mysqld.pid



四，由于CentOS7.2抽风，重启后/run/mysqld /var/run/mysqld 消失，造成启动失败；

故修改一下三个地方

1 my.cnf 中

pid-file=/var/lib/mysql/mysqld.pid

2 mysqld 中头注释

# pidfile: /var/lib/mysql/mysqld.pid

2 mysqld 中函数调用参数

get_mysql_option mysqld_safe pid-file "/var/lib/mysql/mysqld.pid"

执行文件 /usr/bin/my*

mysql http://www.jianshu.com/p/4a41a6df19a6
