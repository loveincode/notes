https://blog.csdn.net/chwshuang/article/details/68489968
/lib/systemd/system目录下创建一个脚本文件redis.service
```
[Unit]
Description=Redis
After=network.target

[Service]
ExecStart=/usr/local/bin/redis-server /usr/local/redis/redis.conf  --daemonize no
ExecStop=/usr/local/bin/redis-cli -h 127.0.0.1 -p 6379 shutdown

[Install]
WantedBy=multi-user.target
```
[Unit] 表示这是基础信息
Description 是描述
After 是在那个服务后面启动，一般是网络服务启动后启动
[Service] 表示这里是服务信息
ExecStart 是启动服务的命令
ExecStop 是停止服务的指令
[Install] 表示这是是安装相关信息
WantedBy 是以哪种方式启动：multi-user.target表明当系统以多用户方式（默认的运行级别）启动时，这个服务需要被自动运行。

创建软链接
创建软链接是为了下一步 **系统初始化时自动启动服务**

```
ln -s /lib/systemd/system/redis.service /etc/systemd/system/multi-user.target.wants/redis.service
```

刷新配置
systemctl daemon-reload

启动redis

$ systemctl start redis
1
重启redis

$ systemctl restart redis
1
停止redis

$ systemctl stop redis

开机自启动
redis服务加入开机启动

$ systemctl enable redis
1
禁止开机启动

$ systemctl disable redis

查看状态
查看状态

$ systemctl status redis
