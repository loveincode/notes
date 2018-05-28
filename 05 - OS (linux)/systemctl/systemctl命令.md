https://blog.csdn.net/u012486840/article/details/53161574


## 1、原来的 service 命令与 systemctl 命令对比

daemon命令	systemctl命令	说明
service [服务] start	  systemctl start [unit type]	         启动服务
service [服务] stop	    systemctl stop [unit type]	         停止服务
service [服务] restart	systemctl restart [unit type]	       重启服务


## 2、原来的chkconfig 命令与 systemctl 命令对比

### 2.1、设置开机启动/不启动

daemon命令	systemctl命令	说明
chkconfig [服务] on	  systemctl enable [unit type]	设置服务开机启动
chkconfig [服务] off	systemctl disable [unit type]	设备服务禁止开机启动

### 2.2、查看系统上上所有的服务

命令格式：

systemctl [command] [–type=TYPE] [–all]
参数详解：
command - list-units：依据unit列出所有启动的unit。加上 –all 才会列出没启动的unit; - list-unit-files:依据/usr/lib/systemd/system/ 内的启动文件，列出启动文件列表
–type=TYPE - 为unit type, 主要有service, socket, target
应用举例：
systemctl命令	说明
systemctl	列出所有的系统服务
systemctl list-units	列出所有启动unit
systemctl list-unit-files	列出所有启动文件
systemctl list-units –type=service –all	列出所有service类型的unit
systemctl list-units –type=service –all grep cpu	列出 cpu电源管理机制的服务
systemctl list-units –type=target –all	列出所有target

## 3、systemctl特殊的用法
systemctl命令	说明
systemctl is-active [unit type]	查看服务是否运行
systemctl is-enable [unit type]	查看服务是否设置为开机启动
systemctl mask [unit type]	注销指定服务
systemctl unmask [unit type]	取消注销指定服务

## 4、init 命令与systemctl命令对比
