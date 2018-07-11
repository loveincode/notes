https://blog.csdn.net/AooMiao/article/details/77946776
http://www.jfox.info/springmvcspringmvc%E5%90%AF%E5%8A%A8%E5%88%9D%E5%A7%8B%E5%8C%96%E8%BF%87%E7%A8%8B.html

HttpServlet → HttpServletBean → FrameworkServlet → DispatcherServlet

DispatcherServlet是一个Servlet
init

web应用启动时扫描web.xml文件，扫描到`DispatcherServlet`，对其进行初始化
调用DispatcherServlet父类的父类`HttpServletBean的init()`方法，把配置DispatcherServlet的初始化参数设置到DispatcherServlet中，

调用子类`FrameworkServlet的initServletBean()`方法
initServletBean()创建springMVC容器实例并初始化容器，并且和spring父容器进行关联，使得mvc容器能访问spring容器里面的bean，

`initWebApplicationContext`

`createWebApplicationContext(WebApplicationContext parent)`

之后调用子类DispatcherServlet的`onRefresh(ApplicationContext context)`方法
onRefresh(ApplicationContext context)进行DispatcherServlet的策略组件初始化工作，url映射初始化，文件解析初始化，运行适配器初始化等等。

```java

@Override
protected void onRefresh(ApplicationContext context) {
    initStrategies(context);
}

protected void initStrategies(ApplicationContext context) {
    initMultipartResolver(context);//文件上传解析
    initLocaleResolver(context);//本地解析
    initThemeResolver(context);//主题解析
    initHandlerMappings(context);//url请求映射
    initHandlerAdapters(context);//初始化真正调用controloler方法的类
    initHandlerExceptionResolvers(context);//异常解析
    initRequestToViewNameTranslator(context);
    initViewResolvers(context);//视图解析
    initFlashMapManager(context);
}
```
