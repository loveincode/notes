## 7.1 Listener概述
Listener主要用于对Session、request、context等进行监控。
7.1.1 Listener的概述
7.1.2 Listener的使用
实现接口 javax.servlet.http.HttpSessionlistener
sessionCreated() 创建Session时被调用
sessionDestroyed() 销毁Session前被调用
配置
```xml
<listener>
  <listener-class>
    com.xxx.xxx
  </listener-class>
</listener>
```

## 7.2 Listener的分类
8种Listener，分别用于监听Session、context、request、等的创建于销毁、属性变化等。
6种Event
### 7.2.1 监听对象的创建与销毁
1. HttpSessionListener
创建Session时执行sessionCreated()方法 超时或者执行session.invalidate()时执行sessionDestroyed()方法，可用于收集在线者信息
2. ServletContextListener
context代表当前的web应用程序。
服务器启动或者热部署war包时执行contextInitialized()方法。服务器关闭时或者只关闭该Web时会执行contextDestroyed()方法。可用于启动时获取web.xml里配置的初始化参数。
3. ServletRequestListener
用户每次请求request都会执行requestInitialized()方法，request处理完毕自动销毁前执行requestDestoryed()方法。
### 7.2.2 实例：监听Session、request与servletContext
  同时实现多个接口
### 7.2.3 监听对象的属性变化
另一类Listener用于监听Session、context、request等的属性变化，接口名称格式为XXXAttributeListener
包括HttpSessionAttributeListener,ServletCOntextAttributeListener,ServletquestAttributeListener.
当向被监听对象中添加、更新、移除属性时，会分别执行
xxxAdded() xxxReplaced() xxxRemoved() xxx分别代表Session,context,request
### 7.2.4 监听Session内的对象
除了上面6种Listenser，还有两种Listener用于监控Session内的对象。
分别是 HttpSessionBingingListener 和 HttpSessionActivationListener.
HttpSessionBingingListener:当对象被放到Session里时执行valueBound()方法，当对象从Session里移除时执行valyeUnbound()方法
HttpSessionActivationListenr：服务器关闭，会将session里的内容保存到硬盘上，这个过程叫做迟钝化。服务器重新启动时，会将Session内容从硬盘上重新加载。
当Session对象被钝化时执行sessionWillPassivate()方法，当对象被重新加载执行sessionDidActivate()方法。
## 7.3 Listener使用案例
统计在线人数，实现单态登录
7.3.1 单态登录
  单一登录，一个账户只能在一台机器上登录。如果在其他机器上登录了，原来的登录自动失效。
7.3.2 显示在线用户
