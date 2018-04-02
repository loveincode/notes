《How Tomcat works》


Tomcat整体架构浅析 https://blog.csdn.net/cx520forever/article/details/52743166


Tomcat原理总结

1. Tomcat需要main方法启动。
2. Tomcat需要监听本机上的某个端口。
3. Tomcat需要抓取此端口上来自客户端的链接并获得请求调用的方法与参数。
4. Tomcat需要根据请求调用的方法，动态地加载方法所在的类，完成累的实例化并通过该实例获得需要的方法最终将请求传入方法执行。
5. 将结果返回给客户端（jsp/html页面、json/xml字符串）。

Tomcat的体系结构
Tomcat服务器的启动是基于一个server.xml文件的，Tomcat启动的时候首先会启动一个Server，
Server里面就会启动Service，
Service里面就会启动多个"Connector(连接器)"，每一个连接器都在等待客户机的连接，当有用户使用浏览器去访问服务器上面的web资源时，首先是连接到Connector(连接器)，
Connector(连接器)是不处理用户的请求的，而是将用户的请求交给一个Engine(引擎)去处理，
Engine(引擎)接收到请求后就会解析用户想要访问的Host，然后将请求交给相应的Host，
Host收到请求后就会解析出用户想要访问这个Host下面的哪一个Web应用,
一个web应用对应一个Context。
