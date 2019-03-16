## 1.建立服务文件
**文件路径**
```
vim /usr/lib/systemd/system/nginx.service
```
**文件内容**
```
[Unit]
Description=nginx - high performance web server
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
ExecStart=/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/usr/local/nginx/sbin/nginx -s stop

[Install]
WantedBy=multi-user.target
```
**文件说明**
**[Unit]** 服务说明
Description:描述服务
After:依赖，当依赖的服务启动之后再启动自定义的服务
**[Service]** 服务运行参数的设置
Type=forking是后台运行的形式
ExecStart为服务的具体运行命令
ExecReload为重启命令
ExecStop为停止命令
PrivateTmp=True表示给服务分配独立的临时空间
注意：启动、重启、停止命令全部要求使用绝对路径
**[Install]** 服务安装的相关设置，可设置为多用户

**Type**
Type=simple（默认值）：systemd认为该服务将立即启动。服务进程不会fork。如果该服务要启动其他服务，不要使用此类型启动，除非该服务是socket激活型。
Type=forking：systemd认为当该服务进程fork，且父进程退出后服务启动成功。对于常规的守护进程（daemon），除非你确定此启动方式无法满足需求，使用此类型启动即可。使用此启动类型应同时指定 PIDFile=，以便systemd能够跟踪服务的主进程。
Type=oneshot：这一选项适用于只执行一项任务、随后立即退出的服务。可能需要同时设置 RemainAfterExit=yes使得systemd在服务进程退出之后仍然认为服务处于激活状态
Type=notify：与 Type=simple相同，但约定服务会在就绪后向systemd发送一个信号。这一通知的实现由 libsystemd-daemon.so提供。
Type=dbus：若以此方式启动，当指定的 BusName 出现在DBus系统总线上时，systemd认为服务就绪。
PIDFile ： pid文件路径
ExecStartPre ：启动前要做什么，上文中是测试配置文件 －t

## 3.设置开机自启动
任意目录下执行
systemctl enable nginx.service
## 4.使用命令
启动nginx服务
systemctl start nginx.service
设置开机自动启动
systemctl enable nginx.service
停止开机自动启动
systemctl disable nginx.service
查看状态
systemctl status nginx.service
重启服务
systemctl restart nginx.service
查看所有服务
systemctl list-units --type=service
