## 第一部分　核心实现
### 第1章　Spring整体架构和环境搭建　2
1.1　Spring的整体架构　2
1.2　环境搭建　4
1.2.1　安装GitHub　4
1.2.2　安装Gradle　5
1.2.3　下载Spring　6
### 第2章　容器的基本实现　10
2.1　容器基本用法　10
2.2　功能分析　11
2.3　工程搭建　12
2.4　Spring的结构组成　13
2.4.1　beans包的层级结构　13
2.4.2　核心类介绍　13
2.5　容器的基础XmlBeanFactory　17
2.5.1　配置文件封装　18
2.5.2　加载Bean　21
2.6　获取XML的验证模式　24
2.6.1　DTD与XSD区别　24
2.6.2　验证模式的读取　26
2.7　获取Document　28
2.7.1　EntityResolver用法　29
2.8　解析及注册BeanDefinitions　31
2.8.1　profile属性的使用　32
2.8.2　解析并注册BeanDefinition　33
### 第3章　默认标签的解析　35
3.1　bean标签的解析及注册　35
3.1.1　解析BeanDefinition　37
3.1.2　AbstractBeanDefinition属性　55
3.1.3　解析默认标签中的自定义标签元素　58
3.1.4　注册解析的BeanDefinition　60
3.1.5　通知监听器解析及注册完成　63
3.2　alias标签的解析　63
3.3　import标签的解析　65
3.4　嵌入式beans标签的解析　67
### 第4章　自定义标签的解析　68
4.1　自定义标签使用　69
4.2　自定义标签解析　71
4.2.1　获取标签的命名空间　72
4.2.2　提取自定义标签处理器　72
4.2.3　标签解析　74
### 第5章　bean的加载　78
5.1　FactoryBean的使用　83
5.2　缓存中获取单例bean　85
5.3　从bean的实例中获取对象　86
5.4　获取单例　90
5.5　准备创建bean　92
5.5.1　处理ovverride属性　93
5.5.2　实例化的前置处理　94
5.6　循环依赖　96
5.6.1　什么是循环依赖　96
5.6.2　Spring如何解决循环依赖　96
5.7　创建bean　100
5.7.1　创建bean的实例　103
5.7.2　记录创建bean的ObjectFactory　112
5.7.3　属性注入　115
5.7.4　初始化bean　124
5.7.5　注册DisposableBean　128
### 第6章　容器的功能扩展　129
6.1　设置配置路径　130
6.2　扩展功能　130
6.3　环境准备　132
6.4　加载BeanFactory　133
6.4.1　定制BeanFactory　135
6.4.2　加载BeanDefinition　136
6.5　功能扩展　137
6.5.1　增加SPEL语言的支持　138
6.5.2　增加属性注册编辑器　139
6.5.3　添加ApplicationContext AwareProcessor处理器　144
6.5.4　设置忽略依赖　146
6.5.5　注册依赖　146
6.6　BeanFactory的后处理　146
6.6.1　激活注册的BeanFactory PostProcessor　147
6.6.2　注册BeanPostProcessor　153
6.6.3　初始化消息资源　156
6.6.4　初始化ApplicationEvent Multicaster　159
6.6.5　注册监听器　161
6.7　初始化非延迟加载单例　162
6.8　finishRefresh　165
### 第7章　AOP　167
7.1　动态AOP使用示例　167
7.2　动态AOP自定义标签　169
7.2.1　注册AnnotationAwareAspectJ AutoProxyCreator　170
7.3　创建AOP代理　173
7.3.1　获取增强器　176
7.3.2　寻找匹配的增强器　186
7.3.3　创建代理　187
7.4　静态AOP使用示例　201
7.5　创建AOP静态代理　203
7.5.1　Instrumentation使用　203
7.5.2　自定义标签　207
7.5.3　织入　209
## 第二部分　企业应用
### 第8章　数据库连接JDBC　214
8.1　Spring连接数据库程序实现(JDBC)　215
8.2　save/update功能的实现　217
8.2.1　基础方法execute　219
8.2.2　Update中的回调函数　223
8.3　query功能的实现　225
8.4　queryForObject　229
### 第9章　整合MyBatis　231
9.1　MyBatis独立使用　231
9.2　Spring整合MyBatis　235
9.3　源码分析　237
9.3.1　sqlSessionFactory创建　237
9.3.2　MapperFactoryBean的创建　241
9.3.3　MapperScannerConfigurer　244
### 第10章　事务　254
10.1　JDBC方式下的事务使用 示例　254
10.2　事务自定义标签　257
10.2.1　注册InfrastructureAdvisor AutoProxyCreator　257
10.2.2　获取对应class/method的增强器　261
10.3　事务增强器　269
10.3.1　创建事务　271
10.3.2　回滚处理　281
10.3.3　事务提交　287
### 第11章　SpringMVC　291
11.1　SpringMVC快速体验　291
11.2　ContextLoaderListener　295
11.2.1　ServletContextListener的使用　295
11.2.2　Spring中的ContextLoader Listener　296
11.3　DispatcherServlet　300
11.3.1　servlet的使用　301
11.3.2　DispatcherServlet的初始化　302
11.3.3　WebApplicationContext的初始化　304
11.4　DispatcherServlet的逻辑处理　320
11.4.1　MultipartContent类型的request处理　326
11.4.2　根据request信息寻找对应的Handler　327
11.4.3　没找到对应的Handler的错误处理　331
11.4.4　根据当前Handler寻找对应的HandlerAdapter　331
11.4.5　缓存处理　332
11.4.6　HandlerInterceptor的处理　333
11.4.7　逻辑处理　334
11.4.8　异常视图的处理　334
11.4.9　根据视图跳转页面　335
### 第12章　远程服务　340
12.1　RMI　340
12.1.1　使用示例　340
12.1.2　服务端实现　342
12.1.3　客户端实现　350
12.2　HttpInvoker　355
12.2.1　使用示例　356
12.2.2　服务端实现　357
12.2.3　客户端实现　361
### 第13章　Spring消息　367
13.1　JMS的独立使用　367
13.2　Spring整合ActiveMQ　369
13.3　源码分析　371
13.3.1　JmsTemplate　372
13.3.2　监听器容器　376
