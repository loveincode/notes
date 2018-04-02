https://www.cnblogs.com/zhouyuqin/p/5143121.html
```
<Server>                                                //顶层类元素，可以包括多个Service   
    <Service>                                           //顶层类元素，可包含一个Engine，多个Connecter
        <Connector>                                     //连接器类元素，代表通信接口
                <Engine>                                //容器类元素，为特定的Service组件处理客户请求，要包含多个Host
                        <Host>                          //容器类元素，为特定的虚拟主机组件处理客户请求，可包含多个Context
                                <Context>               //容器类元素，为特定的Web应用处理所有的客户请求
                                </Context>
                        </Host>
                </Engine>
        </Connector>
    </Service>
</Server>
```
### server      
    1. port 指定一个端口，这个端口负责监听关闭tomcat的请求
    2. shutdown 指定向端口发送的命令字符串

### service        
    1. name 指定service的名字

### Connector (表示客户端和service之间的连接)：
    1. **port** 指定服务器端要创建的端口号，并在这个断口监听来自客户端的请求
    2. minProcessors 服务器启动时创建的处理请求的线程数
    3. maxProcessors 最大可以创建的处理请求的线程数
    4. enableLookups 如果为true，则可以通过调用request.getRemoteHost()进行DNS查询来得到远程客户端的实际主机名，若为false则不进行DNS查询，而是返回其ip地址
    5. **redirectPort** 指定服务器正在处理http请求时收到了一个SSL传输请求后重定向的端口号
    6. acceptCount 指定当所有可以使用的处理请求的线程数都被使用时，可以放到处理队列中的请求数，超过这个数的请求将不予处理
    7. **connectionTimeout** 指定超时的时间数(以毫秒为单位)

### Engine (表示指定service中的请求处理机，接收和处理来自Connector的请求)：
    1. defaultHost 指定缺省的处理请求的主机名，它至少与其中的一个host元素的name属性值是一样的
### Context (表示一个web应用程序)：
    1. docBase 应用程序的路径或者是WAR文件存放的路径
    2. path 表示此web应用程序的url的前缀，这样请求的url为http://localhost:8080/path/****
    3. reloadable 这个属性非常重要，如果为true，则tomcat会自动检测应用程序的/WEB-INF/lib 和/WEB-INF/classes目录的变化，自动装载新的应用程序，我们可以在不重起tomcat的情况下改变应用程序
### host (表示一个虚拟主机)：
    1. name 指定主机名
    2. appBase 应用程序基本目录，即存放应用程序的目录
    3. unpackWARs 如果为true，则tomcat会自动将WAR文件解压，否则不解压，直接从WAR文件中运行应用程序
### Logger (表示日志，调试和错误信息)：
    1. className 指定logger使用的类名，此类必须实现org.apache.catalina.Logger 接口
    2. prefix 指定log文件的前缀
    3. suffix 指定log文件的后缀
    4. timestamp 如果为true，则log文件名中要加入时间，如下例:localhost_log.2001-10-04.txt
### Realm (表示存放用户名，密码及role的数据库)：
    1. className 指定Realm使用的类名，此类必须实现org.apache.catalina.Realm接口
### Valve (功能与Logger差不多，其prefix和suffix属性解释和Logger 中的一样)：
    1. className 指定Valve使用的类名，如用org.apache.catalina.valves.AccessLogValve类可以记录应用程序的访问信息
### directory（指定log文件存放的位置）：
    1. pattern 有两个值，common方式记录远程主机名或ip地址，用户名，日期，第一行请求的字符串，HTTP响应代码，发送的字节数。combined方式比common方式记录的值更多
