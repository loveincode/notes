

1、cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql   将服务文件拷贝到init.d下，并重命名为mysql

2、chmod +x /etc/init.d/mysql    赋予可执行权限

3、chkconfig --add mysql        添加服务

4、chkconfig --list             显示服务列表



如果看到mysql的服务，并且3,4,5都是on的话则成功，如果是off，则键入



chkconfig --level 345 mysql on
5、reboot重启电脑
6、netstat -na | grep 3306，如果看到有监听说明服务启动了


systemctl start mysqld
systemctl status mysqld
看原因 pid文件重复 删除 权限 chown -R mysql
