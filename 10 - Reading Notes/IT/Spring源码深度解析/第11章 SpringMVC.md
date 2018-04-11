## 11.1 SpringMVC快速体验

## 11.2 ContextLoaderListener
对于SpringMVC功能实现的分析，
  ContextLoaderListener的作用就是启动Web容器时，自动装配ApplicationContext的配置信息。
  因为它实现了ServletContextListener这个接口，在web.xml配置这个监听器，启动容器时，就会默认执行它实现的方法。

  每一个Web应用都有一个ServletContext与之相关联。ServletContext对象在应用启动被创建，在应用关闭的时候被销毁。

  在ServletContextListener中的核心逻辑便是初始化WebApplicationContext实例并存放至ServletContext

### 11.2.1 ServletContextListener的使用
  目标是在系统启动时添加自定义的属性

``` java
  实现 ServletContextListener
  // 容器启动执行方法
	public void contextInitialized(final ServletContextEvent event) {}
  // 容器关闭执行方法
	public void contextDestroyed(final ServletContextEvent event) {}
```
注册监听器
在Web.xml文件中需要注册自定义的容器
<listener>
com.XXX.xxxListener
</listener>

### 11.2.2 Spring中的ContextLoaderListener
  ContextLoaderListener只是辅助功能，用于创建WebApplicationContext类型实例。
  **initWebApplicationContext** 函数主要体现了创建WebApplicationContext实例的一个功能架构，从函数中我们看到了初始化的大致步骤
1. WebApplicationContext存在性的验证
2. 创建WebApplicationContext实例
  委托给 **createWebApplicationContext** 函数
3. 将实例记录在servletContext中
4. 映射当前的类加载器与创建的实例到全局变量currentContextPerThread中

## 11.3 DispatcherServlet
  DispatcherServlet是实现Servlet接口的实现类。
  Servlet的生命周期 初始化 运行 销毁
  1. **初始化** 阶段
  a Servlet容器加载servlet类，把它的.Class文件中的数据读到内存中。
  b Servlet容器创建servletConfig对象。servletConfig对象包含了servlet的初始化配置信息。此外 servlet容器还会使得servletConfig对象与当前的web应用的servletContext对象关联。
  c Servlet容器创建servlet对象。
  d Servlet容器调用servlet对象的 **init(ServletConfig config)** 方法。
  2. **运行** 阶段
  当servlet容器接到访问特定的servlet请求时，servlet容器会针对与这个请求创建servletRequest和servletResponse对象，然后调用service()方法。
  并把这两个对象当做参数传递给service()方法。Service()方法通过servletRequest对象获得请求信息，并处理该请求，再通过servletResponse对象生成响应结果。
  然后销毁servletRequest和sevletResponse对象。
  不管是post还是get方法提交，都会在service中处理，然后，由service来交由相应的doPost或doGet方法处理，如果你重写了service方法，就不会再处理doPost或doGet了，如果重写sevice()方法，可以自己转向doPost()或doGet（）方法
  3. **销毁** 阶段
  当Web应用被终止时，servlet容器会先调用web应用中所有的servlet对象的 **destroy（）** 方法，然后在销毁servlet对象。
  此外容器还会销毁与servlet对象关联的servletConfig对象。
  在destroy（）方法的实现中，可以释放servlet所占用的资源。如关闭文件输入输出流，关闭与数据库的连接。
  注：sevlet的生命周期中，servlet的初始化和销毁只会发生一次，因此init()和destroy（）方法只能被servlet容器调用一次，而service()方法取决与servlet被客户端访问的次数。

  HTTP的请求方式包括delete,get,options,post,put,trace 在HttpServlet类中分别提供了相应的服务方法，是
  doDelete(),doGet(),doOption(),doPost(),doPut(),doTrace()

### 11.3.1 servlet的使用
  实现HttpServlet
``` java
init()
doGet()
doPost()
```
web.xml添加<servlet>配置
``` xml
<servlet>
    <servlet-name></servlet-name>
    <servlet-class></servlet-class>
    <load-in-startup></load-in-startup>
</servlet>
<servlet-mapping>
    <servlet-name></servlet-name>
    <url-pattern></url-pattern>
</servlet-mapping>
```

### 11.3.2 DispatcherServlet的初始化
  init()
  主要是通过将当前的Servlet类型实例转换为BeanWrapper类型实例，以便使用Spring中提供的注入功能进行对应属性的注入。
  这些属性如contextAttribute、 contextClass、nameSpace、contextConfigLocation等，都可以在web.xml文件以初始化参数的方式配置在Servlet的声明中。
  DispatcherServlet继承自FrameworkServlet，FrameworkServlet类上包含对应的同名属性，Spring会保证这些参数被注入到对应的值中。
  属性注入主要包含以下步骤：
  1. 封装及验证初始化参数
  2. 将当前Servlet实例转化成BeanWrapper实例
  3. 注册相对于Resource的属性编辑器
  4. 属性注入
  5. ServletBean的初始化

### 11.3.3 WebApplicationContext的初始化
  initWebApplicationContext函数的主要工作就是创建或刷新WebApplicationContext实例并对Servlet功能所使用的变量进行初始化。
  包含几个部分：
  1. 寻找或创建对应的WebApplicationContext实例
    1. 通过构造函数的注入进行初始化
    2. 通过contextAttribute进行初始化
    3. 重新创建WebApplicationContext实例
  2. configureAndRefreshWebApplicationContext
    configureAndRefreshWebApplicationContext方法来对已经创建的 WebApplicationContext 实例进行配置及刷新

  3. 刷新
    doRefresh是FrameworkServlet类中提供的模板方法，在其子类DispatcherServlet中进行了重写，主要用于刷新Spring在Web功能实现中所必须使用的全局变量。
    主要介绍初始化过程以及使用场景。
    1. 初始化MultipartResolver
    2. 初始化LocaleResolver
    3. 初始化ThemeResolver
    4. 初始化HandlerMappings
    5. 初始化HandlerAdapters
    6. 初始化HandlerExceptionResolvers
    7. 初始化RequestToViewNameTranslator
    8. 初始化ViewResolvers
    9. 初始化FlashMapManager

## 11.4 DispatcherServlet的逻辑处理
  processRequest(request,response)
　　11.4.1 MultipartContent类型的request处理
　　11.4.2 根据request信息寻找对应的Handler
　　11.4.3 没找到对应的Handler的错误处理
　　11.4.4 根据当前Handler寻找对应的HandlerAdapter
　　11.4.5 缓存处理
　　11.4.6 HandlerInterceptor的处理
　　11.4.7 逻辑处理
　　11.4.8 异常视图的处理
　　11.4.9 根据视图跳转页面
