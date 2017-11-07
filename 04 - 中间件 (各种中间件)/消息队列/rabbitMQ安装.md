# RabbitMQ安装

## 1. 下载

erlang rabbitMQ是由erlang语言编写，所以需要安装erlang

下载erlang：http://www.erlang.org/downloads/

rabbitMQ

下载 rabbitMQ ：http://www.rabbitmq.com/download.html

## 2. 安装ERLANG
下载完成ERLANG后，直接打开文件下一步就可以安装完成了，安装完成ERLANG后再来安装RABBITMQ。

      配置环境变量 ERLANG_HOME C:\Program Files (x86)\erl5.9 
      添加到PATH  %ERLANG_HOME%\bin;

## 3. 安装RABBITMQ

rabbitMQ安装，查看安装文档：http://www.rabbitmq.com/install-windows.html

      配置环境变量 RABBITMQ_SERVER C:\Program Files (x86)\RabbitMQ Server\rabbitmq_server-2.8.0
      添加到PATH %RABBITMQ_SERVER%\sbin;


## 4. 启动RABBITMQ

如果是安装版的直接在开始那里找到安装目录点击启动即可


启动的时候有可能碰到这个问题。

```
error:node with name "rabbit" already running on "xxx"
```

碰到这种情况的时候就先执行停止，执行完后再启动即可。

## 5. 安装管理工具

参考官方文档：http://www.rabbitmq.com/management.html

操作起来很简单，只需要在DOS下面，进入安装目录（ cd C：\RabbitMQ Server\rabbitmq_server-3.2.2\sbin）执行如下命令就可以成功安装。
```
rabbitmq-plugins enable rabbitmq_management
```

可以通过访问http://localhost:15672进行测试，默认的登陆账号为：guest，密码为：guest。

如果访问成功了，恭喜，整个rabbitMQ安装完成了。

安装完成之后以管理员身份启动 
rabbitmq-service.bat
rabbitmq-service.bat stop
rabbitmq-service.bat install
rabbitmq-service.bat start
