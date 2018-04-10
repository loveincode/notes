## 11.1 SpringMVC快速体验

## 11.2 ContextLoaderListener
对于SpringMVC功能实现的分析，
  ContextLoaderListener的作用就是启动Web容器时，自动装配ApplicationContext的配置信息。
  因为它实现了ServletContextListener这个接口，在web.xml配置这个监听器，启动容器时，就会默认执行它实现的方法。

  每一个Web应用都有一个ServletContext与之相关联。ServletContext对象在应用启动被创建，在应用关闭的时候被销毁。

  在ServletContextListener中的核心逻辑便是初始化WebApplicationContext实例并存放至ServletContext

### 11.2.1 ServletContextListener的使用

### 11.2.2 Spring中的ContextLoaderListener

##11.3 Dispatcher Servlet
　　11.3.1 servlet的使用
　　11.3.2 DispatcherServlet的初始化
　　11.3.3 WebApplicationContext的初始化

## 11.4 DispatcherServlet的逻辑处理
　　11.4.1 MultipartContent类型的request处理
　　11.4.2 根据request信息寻找对应的Handler
　　11.4.3 没找到对应的Handler的错误处理
　　11.4.4 根据当前Handler寻找对应的HandlerAdapter
　　11.4.5 缓存处理
　　11.4.6 HandlerInterceptor的处理
　　11.4.7 逻辑处理
　　11.4.8 异常视图的处理
　　11.4.9 根据视图跳转页面
