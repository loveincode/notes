form 毕来生 weixin:wxid_u901dvezzeq921

## 一、spring基础
### Spring概述
  - 1. Spring的简史
    * xml配置
    * 注解配置
    * java配置
  - 2. Spring概述
  * 2.1 Spring的模块
    - 核心容器CoreContainer
      Spring-Core
      Spring-Beans
      Spring-Context
      Spring-Context-Support
      Spring-Expression
    - AOP
      Spring-AOP
      Spring-Aspects
    - Messaging
      Spring-Messaging
    - WEB
      Spring-Web
      Spring-Webmvc
      Spring-WebSocket
      Spring-Webmvc-Portlet
    - 数据访问/集成(DataAccess/Intefration)
      Spring-JDBC
      Spring-TX
      Spring-ORM
      Spring-OXM
      Spring-JMS
  * 2.2 Spring的生态
      SpringBoot
      SpringXD
      SpringCloud
      SpringData
      SpringIntegration
      SpringBatch
      SpringSecurity
      SpringHATEOAS
      SpringSocial
      SpringAMQP
      SpringMobile
      SpringforAndroid
      SpringWebFlow
      SpringWebServices
      SpringLDAP
      SpringSession
### Spring项目快速搭建
    Maven简介
    Maven安装
    Maven的pom.xml
      dependencies
      dependency
      变量定义
      编译插件
    Spring项目的搭建
      SpringToolSuite
        https://spring.io/tools/sts/all
      IntelliJIDEA
      NetBeans
        https://netbeans.org/downloads/

### Spring基础配置
  1. 使用POJO进行轻量级和最小侵入式开发
  2. 通过依赖注入和基于接口编程实现松耦合
  3. 通过AOP和默认习惯进行声明式编程
  4. 使用AOP和模版(template)减少模式化代码
  Spring所有功能的设计和实现都是基于此四大原则
  – 依赖注入
  • 声明Bean的注解
  @Component 组件,没有明确的角色
  @Service 在业务逻辑层(service层)
  @Repository 在数据访问层(dao层)
  @Controller 在展现层(MVC→SpringMVC)
  • 注入Bean的注解
  @Autowired :Spring提供的注解
  @Inject :JSR-330提供的注解
  @Resource :JSR-250提供的注解
  – Java配置
  @Configuration 声明当前类是一个配置类
  @Bean 注解在方法上,声明当前方法的返回值为一个Bean
  – AOP
  面向切面编程,相对于OOP面向对象编程Spring的AOP的存在目的是为了解耦.AOP可以让一组类共享相同的行为.在OOP中只能通过继承类和实现接口,来使代码的耦合度增强,且类继承智能为单继承,阻碍更多行为添加到一组类上,AOP弥补了OOP的不足.
  • @Aspect 声明是一个切面
  面向切面编程,相对于OOP面向对象编程Spring的AOP的存在目的是为了解耦.AOP可以让一组类共享相同的行为.在OOP中只能通过继承类和实现接口,来使代码的耦合度增强,且类继承智能为单继承,阻碍更多行为添加到一组类上,AOP弥补了OOP的不足.
  • 拦截规则
    @After  //无论方法以何种方式结束，都会执行（类似于finally）
    @AfterReturning // 运行方法后执行
    @AfterThrowing
    @Before //方法前执行,括号内的为切入点
    @Around //在所拦截方法的前后执行一段逻辑
  • PointCut
  • JoinPoint

## 二、 Spring常用配置

• Bean的Scope
  Scope描述的是Spring容器如何新建Bean的实例
  Singleton
  一个Spring容器中只有一个Bean的实例,此为Spring的默认配置,全容器共享一个实例
  Prototype
  每次调用新建一个Bean的实例
  Request
  Web项目中,给每一个httprequest新建一个Bean实例
  Session
  Web项目中,给每一个httpSession新建一个Bean实例
  GlobalSession
  这个只在portal应用中有用,给每一个globalhttpsession新建一个Bean实例.
• SpringEL和资源调用
  commons-io将file转换称字符串
  注入普通字符
  注入操作系统属性
  注入表达式云算结果
  注入其他Bean的属性
  注入文件内容
  注入网址内容
  注入属性文件
• Bean的初始化和销毁
  Java配置方式
  @Bean 的initMethod 和 destroyMethod
  注解方式
  jsr250-api利用JSR-250的@PostConstruct和@PreDestroy
• Profile
  Profile为在不同环境下使用不通的配置提供了支持
  @Profile
  通过设定jvm的spring.profiles.active参数
  web项目设置在Servlet的contextparameter中
• 事件ApplicationEvent
  为Bean与Bean之间的消息通信提供了支持.当一个Bean处理完一个任务之后,希望另一个Bean知道并能做相应的处理,这时我们就需要让另外一个Bean监听当前Bean所发送的事件.
  自定义事件,集成ApplicationEvent
  定义事件监听器,实现ApplicationListener
  使用容器发布事件

## 三、 Spring高级话题

### SpringAware
  BeanNameAware
    获得到容器中Bean的名称
  BeanFactoryAware
    获得当前beanfactory,这样可以调用容器的服务
  ApplicationContextAware
    当前的Applicationcontext,这样可以调用容器的服务
  MessageSourceAware
    获得Messagesource,这样可以获得文本信息
  ApplicationEventPublisherAware
    应用时间发布器,可以发布时间,
  ResourceLoaderAware
    获得资源加载器,可以获得外部资源文件
### 多线程
  Sprinng通过任务执行器(TaskExecutor)来实现多线程和并发编程.
  使用ThreadPoolTaskExecutor可实现一个基于线程池的TaskExecutor.
  而实际开发中任务一般是非阻碍的,即异步的,所以我们要在配置类中通过 @EnableAsync 开启对异步任务的支持,并通过在实际执行的Bean的方法中使用 @Async 注解来声明其是一个异步任务.

### 计划任务
  计划任务在Spring中的实现变得异常的简单.首先通过在配置类注解 @EnableScheduling 来开启对计划任务的支持,然后在要执行计划任务的方法上注解 @Scheduled,声明这是一个计划任务
  cron
  fixDelay
  fixRate
### 条件注解 @Conditional
  @Conditional 根据满足某一个特定条件创建一个特定的Bean当某一个jar包在一个类路径下的时候,自动配置一个或多个Bean:或者只有某个Bean被创建才会创建另外一个Bean.总的来说,就是根据特定条件来控制Bean的创建行为,这样我们可以利用这个特性进行一些自动的配置.
### 组合注解与元注解
### @Enable * 注解的工作原理
  直接导入配置类
  依据条件选择配置类
  动态注册Bean
### 测试
  测试是开发工作中不可缺少的部分.单元测试只针对当前开发的类和方法进行测试,可以简单通过模拟依赖来实现,对运行环境没有依赖;但是仅仅进行单元测试是不够的,它智能验证当前类或方法能否正常工作,而我们降妖知道系统的各个部分组合在一起是否能正常工作,这就是集成测试才能在的意义.集成测试一般需要来自不同层的不通对象交互,如数据库,网络连接,Ioc容器等.
  SpringTestContextFramework集成测试

## 四、 SpringMVC基础

### SpringMVC概述
### SpringMVC项目快速搭建
  构建Maven项目
  日志配置
  演示页面
  SpringMVC配置
  Web配置
  简单控制器
  运行
### SpringMVC的常用注解
  @Controller
  @RequestMapping
  @ResponseBody
  @RequestBody
  @PathVariable
  @RestController

### SpringMVC的基本配置
静态资源映射
  拦截器配置
  @ControllerAdivce
  @ExceptionHandler
  用于全局处理控制器里的异常
  @InitBinder
    用来设置WebDataBinder,WebDataBinder用来自动绑定前台请求参数到Model中
  @ModelAttribute
  @ModelAttribute本来的作用是绑定键值对到Model里,此处是让全局的@RequestMapping都能获得在此处设置的键值对
  其他配置
    ViewController
  路径匹配参数配置
    WebMvcConfigurerAdapter
    WebMvcConfigurer

### SpringMVC的高级配置

  – 文件上传配置
    commons-fileupload文件上传是一个项目里经常要用的功能,SpringMVC通过配置一个MultipartResolver来上传文件在Spring的控制器中,通过MultipartFile来接收文件,通过MultupartFile[]files接收多个文件上传.
  – 自定义HttpMessageConverter
    HttpMessageConverter是用来处理request和response里的数据的.
    MappingJackson2HttpMessageConverter
    StringHttpMessageConverter
  – 服务器端推送技术
    当客户端向服务端发送请求,服务端会抓住这个请求不放,等有数据更新的时候才返回给客户端,当客户端接收到消息后,再向服务端发送请求,周而复始.
    SSE
      SSE(ServerSendEvent服务端发送事件)的服务器端推送和基于Servlet3.0+的异步方法特性,其中第一种方式需要新式浏览器的支持,第二种方式是跨浏览器的.
    Servlet3.0+异步方法处理
### SpringMVC的测试
  测试驱动开发(TestDrivenDevelopment,TDD),我们(设计人员)按照需求先写一个自己预期结果的测试用例,这个测试用例刚开始肯定是失败的测试,随着不断的编码和重构,最终让测试用例通过测试,这样才能保证软件的质量和可控性.
  MockMVC
  MockHttpServlerRequest

  MockHttpServletResponse
  MockHttpSession

## 五、 SpringBoot基础

### SpringBoot概述
– 什么是SpringBoot
  随着动态语言的流行,Java的开发显得格外的笨重:繁多的配置,低下的开发效率,复杂的部署流程以及第三方技术集成难度大.
  SpringBoot应运而生.它使用"习惯优于配置"(项目中存在大量的配置,此外还内置一个习惯性配置,让你无需手动进行配置)的理念让你的项目快速运行起来.
  使用SpringBoot很容易创建一个独立运行(运行Jar内嵌Servlet容器)准生产级别的基于Spring框架的项目,使用SpringBoot你可以不用或者只需要很少的Spring配置.
– SpringBoot核心功能
  独立运行的Spring项目
    SpringBoot可以以Jar包的形式独立运行,运行一个SpringBoot项目只需通过java-jarxx.jar来运行
  内嵌Servlet容器
    SpringBoot可选择内嵌Tomcat、Jetty或者Undertow,这样我们无须以war包形式部署项目
  提供Starter简化Maven配置
  自动配置Spring
  准生产的应用监控
  无代码声称和xml配置
注解
– SpringBoot的优缺点
优点
  快速构建项目
  对主流开发框架的无配置集成
  项目可独立运行,无需外部依赖Servlet容器
  提供运行时的应用监控
  极大地提高了开发,部署效率
  与云计算的天然集成
缺点
  书籍文档较少,且不够深入
SpringBoot版本
### SpringBoot快速搭建
  http://start.spring.io
  SpringToolSuite
  InterlliJIDEA
  SpringBootCLI
  Maven手工构建
  简单演示


## 六、 SpringBoot核心

### 基本配置
– 入口类和@SpringBootApplication
  @Configuration
  @EnableAutoConfiguration
  @ComponentScan
– 关闭特定的自动配置
  关闭特定的自动配置应该使用 @SpringBootApplication
  注解的exclude参数例如: `@SpringBootApplication(exclude={DataSourceAutoConfiguration.class})`
– 定制Banner
  修改Banner
    src/main/resources新建一个banner.txt通过http://patorjk.com/software/taag
  关闭Banner
    main里修改
    fluentAPI
– SpringBoot的配置文件
  application.properties
  application.yml
  src/main/resources
– starterpom
  官方starterpom
    spring-boot-starter
      SpringBoot核心starter,包含自动配置,日志,yaml配置文件的支持
    spring-boot-starter-actuator
      准生产特性,用来监控和管理应用
    spring-boot-starter-remote-shell
      提供基于ssh协议的监控和管理
    spring-boot-starter-amqp
      使用spring-rabbit来支持AMQP
    spring-boot-starter-aop
      使用spring-aop和AspectJ支持面向切面编程
    spring-boot-starter-batch
      对SpringBatch的支持
    spring-boot-starter-cache
      对SpringCache抽象的支持
    spring-boot-starter-cloud-connectors
      对云平台(CloudFoundryHeroku)提供的服务提供简化的连接方式
    spring-boot-starter-data-elasticsearch
      通过spring-data-elasticsearch对Elasticsearch支持
    spring-boot-starter-data-gemfire
      通过对spring-data-gemfire对分布式存储GemFire的支持
    spring-boot-starter-data-jpa
      对JPA的支持,包含spring-data-jpaspring-orm和Hibernate
    spring-boot-starter-data-mongodb
      通过spring-data-mongdb,对MongoDB进行支持
    spring-boot-starter-data-rest
      通过spring-data-rest-webmvc将SpringDatarepository暴露为REST形式的服务
    spring-boot-starter-data-solr
      通过spring-data-solrd对ApacheSolr数据检索平台的支持
    spring-boot-starter-freemarker
      对FreeMarker模板引擎的支持
    spring-boot-starter-groovy-templates
      对Groovy模板引擎的支持
    spring-boot-starter-hateoas
      通过spring-hateoas对基于HATEOAS的REST形式的网络服务的支持
    spring-boot-starter-hornetq
      通过HornetQ对JMS的支持
    spring-boot-starter-integration
      对系统集成框架spring-integration的支持
    spring-boot-starter-jdbc
      对JDBC数据库的支持
    spring-boot-starter-jerscy
      对JerseryREST形式的网络服务的支持
    spring-boot-starter-jta-atomikos
      通过Atomikos对分布式事务的支持
    spring-boot-starter-jta-bitronix
      通过Bitronix对分布式事务的支持
    spring-boot-starter-mail
      对javax.mai的支持
    spring-boot-starter-mobile
      对spring-mobile的支持
    spring-boot-starter-mustache
      对Mustache模板引擎的支持
    spring-boot-starter-redis
      对键值对内存数据库Redis的支持,包含spring-redis
    spring-boot-starter-security
      对spring-security的支持
    spring-boot-starter-social-facebook
      通过spring-social-facebook对Facebook的支持
    spring-boot-starter-social-linkedin
      通过spring-social-linkedin对Linkedin的支持
    spring-boot-starter-social-twitter
      通过spring-social-twitter对Twitter的支持
    spring-boot-starter-test
      对常用的测试框架JUnitHamcrest和Mockito的支持,包含spring-test模块
    spring-boot-starter-thymeleaf
      对Thymeleaf模版引擎的支持,包含于Spring整合的配置
    spring-boot-starter-velocity
      对Velocity模版引擎的支持
    spring-boot-starter-web
      对Web项目开发的支持,包含Tomcat和spring-webmvc
    spring-boot-starter-Tomcat
      SpringBoot默认的Servlet容器Tomcat
    spring-boot-starter-Jetty
      使用Jetty作为Servlet容器替换Tomcat
    spring-boot-starter-undertow
      使用Undertow作为Servlet容器替换Tomcat
    spring-boot-starter-logging
      SpringBoot默认的日志框架Logback
    spring-boot-starter-log4j
      支持使用Log4J日志框架
    spring-boot-starter-websocket
      对WebSocket开发的支持
    spring-boot-starter-ws
      对SpringWebServices的支持
  第三方starterpom
    Handlebars
    Vaadin
    ApacheCamel
    WRO4J
    SpringBatch
    HDIV
    JadeTemplates(jade4J)
    Actitivi
使用XML配置
  @ImportResource
### 外部配置
  命令行参数配置
  常规属性配置
  类型安全的配置(基于properties)
### 日志配置
### Profile配置
### SpringBoot运行原理
  java-jarxx.jar--debugapplication.propertiesdebug=true
运作原理
– 核心注解
  @ConditionalOnBean
    当容器里有指定的Bean的条件下
  @ConditionalOnClass
    当类路径下有指定的类的条件下
  @ConditionalOnExpression
    基于SpEL表达式作为判断条件
  @ConditionalOnJava
    基于JVM版本作为判断条件
  @ConditionalOnJndi
    在JNDI存在的条件下查找指定的位置
  @ConditionalOnMissingBean
    当容器里没有指定Bean的情况下
  @ConditionalOnMissingClass
    当类路径下没有指定的类的条件下
  @ConditionalOnNotWebApplication
    当前项目不是Web项目的条件下
  @ConditionalOnProperty
    指定的属性是否有指定的值
  @ConditionalOnResource
    类路径是否有指定的值
  @ConditionalOnSingleCandidate
    当指定Bean在容器中只有一个,或者虽然有多个但是指定首选的Bean
  @ConditionalOnWebApplication
    当前项目是Web项目的条件下
实例分析
  配置参数
  配置Bean
实战

## 七、Springboot的Web开发
### SpringBoot的Web开发支持
  – ServerPropertiesAutoConfiguration和ServerProperties
    自动配置内嵌Servlet容器
  – HttpEncodingAutoConfiguration和HttpEncodingProperties
    用来自动配置http的编码
  – MultipartAutoConfiguration和MultipartProperties
    用来自动配置上传文件的属性
  – JacksonHttpMessageConvertersConfiguration
    用来自动配置mappingJackson2HttpMessageConverter和mappingJackson2XmlHttpMessageConverter
  – WebMvcAutoConfiguration和WebMvcProperties
    配置SpringMVC
### Thymeleaf模板引擎
  – Thymeleaf基础知识
    Thymeleaf是一个Java类库,它是一个xml/xhtml/html5的模版引擎,可以作为MVC的Web应用的View层.Thymeleaf还提供了额外的模块与SpingMVC集成,所以我们可以使用Thymeleaf完全替代JSP
    引入Thymeleaf
    访问model中的数据
    model中的数据迭代
    数据判断
    在javaScript中访问model
    其他知识
      http://www.thymeleaf.org
  – 与SpringMVC集成
  – SpringBoot的Thymeleaf支持
  – 实战
    新建SpringBoot项目
    示例JavaBean
    脚本样式静态文件
    演示页面
    数据准备
    运行
### Web相关配置
SpringBoot提供的自动配置

自动配置的ViewResolver
  ContentNegotiatingViewResolver
  BeanNameViewResolver
  InternalResourceViewResolver
自动配置的静态资源
类路径文件
webjar
自动配置的Formatter和Conventer
自动配置的HttpMessageConverters
静态首页的支持
接管SpringBoot的Web配置
注册Servlet,Filter,Listener
### Tomcat配置
配置Tomcat
配置Servlet容器server.port配置Tomcatserver.tomcat.uri-encoding
代码配置Tomcat
  通用配置
  新建类的配置
  当前配置文件内配置
  特定配置
  替换Tomcat
  替换为Jetty
  替换为Undertow
SSL配置
生成证书
keytoolkeytool-genkey-aliastomcat
SpringBoot配置SSL
http转向https
### Favicon配置
默认的Favicon
关闭Favicon
spring.mvc.favicon.enabled=false
设置自己的Favicon
favicon.ico放置在src/main/resources/static
### WebSocket
什么是WebSocket
WebSocket为浏览器和服务端提供了双工异步通信的功能,即浏览器可以向服务端发送消息,服务端也可以向浏览器发送消息.
SpringBoot提供的自动配置
SpringBoot为WebSocket提供的staterpom是spring-boot-starter-websocket
实战
准备
选择Thymeleaf和WebSocket依赖
广播式
广播式即服务端有消息时,会将消息发送给所有连接了当前endpoint的浏览器
配置WebSocket
需要在配置类上使用@EnableWebSocketMessageBroket开启WebSoccket支持,并通过继承AbstractWebSocketMessageBrokerConfigurer类,重写其方法来配置WebSocket
浏览器向服务端发送的消息用此类接受
服务端向浏览器发送的此类的消息
控制器
添加脚本
演示页面
配置viewController
点对点式
添加SpringSecurity的starterpom
SpringSecurity的简单配置
配置WebSocket
控制器
登录页面
聊天页面
增加页面的viewController
### 基于Bootstrap和AnglarJS的现代Web应用
单页面应用(single-pageapplication,简称SPA)指的是一种类似于原生客户端软件的更流畅的用户体验的页面.响应式设计(Responseivewebdesign,简称RWD)指的是不通的设备(电脑,平板,手机)访问相同的页面的时候,得到不同的页面视图,而得到视图是适应当前屏幕的.数据导向是对于页面导向而言的,页面上的数据获得是通过消费后台的REST服务来实现的,而不是通过服务器渲染的动态页面来实现的,一般数据交换使用的格式是JSON
Bootstrap
什么是Bootstrap
下载并引入Bootstrap
CSS支持
页面组件支持
Javascript支持
AngularJS
什么是AngularJS
下载并引入AngularJS
模块,控制器和数据绑定
Scope和Event
Scope
Event
冒泡事件
广播事件
多视图和路由
依赖注入
Service和Factory
自定义指令
实战

## 八、 SpringBoot的数据访问

### 引入Docker
Docker的安装
Linux下安装
Windows下安装
Docker常用命令及参数
Docker镜像命令
Docker镜像检索
dockersearch镜像名dockersearchredis
镜像下载
dockerpull镜像名dockerpullredis
镜像列表
dockerimages
删除镜像
删除指定镜像dockerrmiimage-id删除所有镜像dockerrmi$(dockerimages-q)
Docker容器命令
容器基本操作
最简单的运行镜像容器dockerrun--namecontainer-name-dimage-name


容器列表
dockerps
查看运行和停止状态
dockerps-a
停止和启动容器
停止容器
停止容器dockerstopcontainer-name/container-iddockerstoptest-redis
启动容器
停止容器dockerstartcontainer-name/container-iddockerstarttest-redis
端口映射
Docker容器中运行的软件所使用的端口,在本机和本机的局域网是不能访问的,所以我们需要将Docker容器中的端口映射到当前主机的端口上,这样我们在本机和本机所在的局域网就能够访问该软件了dockerrun-d-p6378:6379--nameport-redisredis
删除容器
删除单个容器dockerrmcontainer-id删除所有容器dockerrm$(dockerps-a-q)
容器日志
查看当前容器日志dockerlogscontainer-name/container-iddockerlogsport-redis
登录容器
dockerexec-itcontainer-id/container-namebash


下载所需的Docker镜像
dockerpullwnameless/oracle-xe-11gdockerpullmongodockerpullredis:2.8.21dockerpullcloudesire/activemqdockerpullrabbitmqdockerpullrabbitmq:3-management
异常处理
boot2dockerssh
### SpringDataJPA
SpringDataJPA
什么是SpringDataJPA
定义数据访问层
继承JpaRepositorypublicinterfacePersonRepositoryextendsJpaRepository{//定义数据访问操作方法}
配置使用SpringDataJPA
@EnableJpaRepositories
定义查询方法
根据属性名查询
常规查询
selectpfrompersonpweherep.name=?1ListfindByName(stringname);selectpfrompersonpweherep.namelike?1ListfindByNameLike(stringname);selectpfrompersonpweherep.name=?1andp.address=?2ListfindByNameAndAddress(stringname,Stringaddress);


限制结果数量
ListfindFirst10ByName(Stringname);
使用JPA的NamedQuery
使用@Query查询
使用参数索引
使用命名参数
更新查询
Specification
排序与分页
定义
使用排序
使用分页
自定义Repository的实现
定义自定义Repository接口
定义接口实现
自定义ReposityFactoryBean


开启自定义支持使用@EnableJpaRepositories的repositoryFactoryBeanClass来指定FactoryBean即可
SpringBoot的支持
JDBC的自动配置
对JPA的自动配置
对SpringDataJPA的自动配置
SpringBoot下的SpringDataJPA
实例
安装OracleXE
非Docker安装
Docker安装
运行一个oracle容器dockerrun-d-p9090:8080-p1521:1521我那么less/oracle-xe-11g
端口映射
管理
新建SpringBoot项目
配置基本属性
spring:profiles:devdatasource:url:jdbc:postgresql://192.168.3.219:5432/intp-fxl?useUnicode=true=utf-8username:postgrespassword:postgresfilters:log4j,wall,mergeStat


定义映射实体类
定义数据访问接口
运行
### SpringDataREST
SpringDataREST
什么是SpringDataREST
SpringMVC中配置使用SpringDataREST
继承方式
RepositoryRestMvcConfiguration
导入方式
@Configuration@Import(RepositoryRestMvcConfiguration.class)
SpringBoot的支持
实例
新建SpringBoot项目
实体类
实体类的Repository


Postman
REST服务测试
jQuery
AngularJS
列表
获取单一对象
查询
分页
排序
保存
更新
删除
定制
定制根路径
spring.data.rest.base-path=/api
定制节点路径
@RepositoryRestResource(path="people")

### 声明式事务
Spring的事务机制
提供一个PlatformTransactionManager接口,不同的数据访问技术的事务使用不通的接口实现
JDBC
DataSourceTransactionManager
JPA
JpaTransactionManger
Hibernate
HibernateTransactionManger
JDO
JdoTransactionManger
分布式事务
JtaTransactionManager
声明式事务
@Transactional
注解事务行为
类级别使用@Transactional
SpringDataJPA的事务支持
SpringBoot的事务支持
自动配置的事务管理器
自动开启注解事务的支持
实例
### 数据缓存Cache
内存速度大于硬盘速度.当我们需要重复地获取相同的数据的时候,我们一次又一次的请求数据库或者远程服务,导致大量的时间耗费在数据库查询或者远程方法调用上,导致程序性能的恶化,这便是数据缓存要解决的问题.
Spring缓存支持
Spring支持的CacheManager
SimpleCacheManager
使用简单的Collection来存储缓存,主要用来测试用途
ConcurrentMapCacheManager
使用ConcurrentMap来存储缓存
NoOpCacheManager
仅测试用途,不会实际存储缓存
EhCacheCacheManager
使用EhCache作为缓存技术
GuavaCacheManager
使用GoogleGuava的GuavaCache作为缓存技术
HazelcastCacheManager
使用Hazelcast作为缓存技术
JCacheCacheManager
支持Jcache(JSR-107)标准的实现作为缓存技术,如ApacheCommonsJCS
RedisCacheManager
使用Redis作为缓存技术
声明式缓存注解
@Cacheable
在方法执行前Spring先查看缓存中是否有数据,如果有数据,则直接返回缓存数据;若没有数据,调用方法并将方法返回值放进缓存
@CachePut
无论怎样,都会将方法的返回值放到缓存中.@CachePut的属性与@Cacheable保持一致
@CacheEvict
将一条或多条数据从缓存中删除
@Caching
可以通过@Caching注解组合多个注解策略在一个方法上
开启声明式缓存支持
@EnableCaching
SpringBoot的事务支持
实例
切换缓存技术
EhCache
Guava
Redis
### 非关系型数据库NoSQL
noSQL是对于不使用惯性作为数据管理的数据库系统的统称.NoSQL的主要特点是不使用SQL语言作为查询语言,数据存储也不是固定那个的表,字段主要有文档存储型(MongoDB)图形关系存储型(Neo4j)键值对存储型(Redis)
MongoDB
MongoDB是一个基于文档(Document)的存储型的数据库,使用面向对象的思想,每一条数据记录都是文档的对象.
Spring的支持
Spring对MongoDB的支持主要是通过SpringDataMongoDB来实现.
Object/Document映射注解支持
JPA提供了一套Object/Relation映射的注解(@Entity@Id),
@Document
映射领域对象与MongoDB的一个文档
@Id
映射当前属性是ID
DbRef
ID档前属性将参考其他的文档
@Field
为文档的属性定义名称
@Version
将当前属性作为版本
MongoTemplate
Repository的支持
SpringBoot的支持
安装MongoDB
非Docker
Docker安装
dockerrun-d-p27017:27017mongo
Redis
Spring的支持
配置
使用
opsForValue()
操作只有简单属性的数据
opsForList()
操作含有list的数据
opsForSet()
操作含有set的数据
opsForZSet()
操作含有ZSet(有序的set)的数据
opsForHash()
操作含有hash的数据
定义Serializer
SpringBoot的支持
安装Redis
非Docker安装
Docker安装
dockerrun-d-p6379:6379redis:2.8.21

## 九、 SpringBoot企业级开发

### 安全控制SpringSecurity
SpringSecurity快速入门
什么是SpringSecurity
SpringSecurity是专门针对基于Spring的项目的安全框架,充分利用了依赖注入和AOP来实现安全的功能.安全框架有两个重要的概念,即认证(Authentication)和授权(Authorization)认证即确认用户可以访问当前系统;授权即确定用户在当前系统下所拥有的功能权限
SpringSecurity的配置
DelegatingFilterProxy
配置
用户认证
内存中的用户
JDBC中的用户
通用的用户
请求授权
定制登录行为
SpringBoot的支持
自动配置了一个内存中的用户
忽略/css/**/js/**/images/**/**/favicon.ico等静态文件的拦截
自动配置的securityFilterChainRegistration的Bean
实例
### 批处理SpringBatch
SpringBatch快速入门
什么是SpringBatch
SpringBatch是用来处理大量数据操作的一个框架,主要用来读取大量数据,然后进行一定处理后输出称指定的形式.
SpringBatch主要组成
JobRepository
用来注册Job的容器
JobLauncher
用来启动Job的接口
Job
我们要实际执行的任务,包含一个或多个Step
Step
Step步骤包含ItemReader,ItemProcessor,ItemWriter
ItemReader
用来读取数据的接口
ItemProcessor
用来处理数据的接口
ItemWriter
用来输出数据的接口
Job监听
implementsJobExecutionListener
数据读取
数据处理及校验
数据处理
数据校验
数据输出
计划任务
参数后置绑定
SpringBoot的支持
实例
### 异步消息
异步消息主要目的是为了系统与系统之间的通信.所谓异步消息即消息发送者无须等待消息接收者的处理及返回,甚至无须关心消息是否发送成功.在异步消息中有两个很重要的概念,即消息代理(messagebroker)和目的地(destination).当消息发送者发送消息后,消息将由消息代理接管,消息代理保证消息传递到指定的目的地.异步消息主要有两种形式的目的地:队列(queue)和主题(topic).队列用于点对点式(point-to-point)的消息通信;主题用于发布/订阅式(publish/subscribe)的消息通信.
企业级消息代理
JMS(javaMessageService)即Java消息服务,是基于JVM消息代理的规范.而ActiveMQ,HornetQ是一个JMS消息代理的实现.AMQP(AdvancedMessageQueuingProtocol)也是一个消息代理的规范,但它不仅兼容JMS,还支持跨语言和平台.AMQP的主要实现有RabbitMQ
Spring的支持
SpringBoot的支持
JMS实战
AMQP实战
### 系统集成SpringIntegration
SpringIntegration快速入门
Message
Channel
顶级接口
MessageChannel
PollableChannel
轮询
SubscribaleChannel
订阅
常用消息通道
PublishSubscribeChannel
QueueChannel
PriorityChannel
RendezvousChannel
DirectChannel
ExecutorChannel
通道拦截器
MessageEndPoint
ChannelAdapter
通道适配器(ChannelAdapter)是一种连接外部系统或者传输协议的端点(EndPoint),可以分为入站(inbound)和出站(outbound).通道适配器是单向的,入站通道适配器只支持接收消息,出站通道适配器只支持输出消息.
Gateway
消息网关(Gateway)类似与Adapter,但是提供了双向请求/返回集成方式,也分为入站(inbound)和出站(outbound).
ServiceActiveator
ServiceActivator可调用Spring的Bean来处理消息,并将处理后的结果输出到指定的消息通道.
Router
路由(Router)可根据消息体类型(PayloadTypeRouter)消息头的值(HeaderValueRouter)以及定义好的接收表(RecipientListRouter)作为条件,来决定消息传递到的通道.
Filter
过滤器(Filter)类似于路由(Router),不通的是过滤器不决定消息路由到哪里,而是决定消息是否可以传递给消息通道.
Splitter
拆分起(Splitter)将消息拆分为几个部分单独处理,拆分器处理的返回值是一个集合或者数组.
Aggregator
据和气(Aggregator)与拆分器相反,它接收一个java.util.List作为参数,将多个消息合并为一个消息.
Enricher
当我们从外部获得消息后,需要增加额外的消息到已有的消息中,这时就需要使用消息增强器(Enricher).消息增强器主要有消息体增强器(PayloadEnricher)和消息头增强器(HeaderEnricher)两种
Transformer
转换器(Transformer)是对获得的消息进行一定的逻辑转换处理(如数据格式转换).
Bridge
使用连接桥(Bridge)可以简单地将两个消息通道连接起来
SpringIntegrationJavaDSL
实例

## 十、 SpringBoot开发部署与测试

### 开发的热部署
模板热部署
在SpringBoot里,模板引擎的页面默认是开启缓存的,如果修改了页面的内容,则刷新页面是得不到修改后的页面的,因此我们可以在application.properties中关闭模板引擎的缓存.
Thymeleaf
spring.thyeleaf.cache=false
FreeMarker
spring.freemarker.cache=false
Groovy
spring.groovy.cache=false
Velocity
spring.velocity.cache=false
SpringLoaded
Springloaded可实现修改类文件的热部署
JRebel
spring-boot-devtools
### 常规部署
jar形式
打包
mvnpackage
运行
java-jarxx.jar
注册为Linux的服务
war形式
打包方式为war时
mvnpackage
打包方式为jar时
jar修改为warorg.springframework.bootspring-boot-starter-tomcatprovided增加ServletInitializer
### 云部署--基于Docker的部署
Dockerfile
FROM指令
FROM指令指明了当前镜像继承的基镜像.编译当前镜像时会自动下载基镜像FROMubuntu
MAINTAINER指令
MAINTAINER指令指明了当前镜像的作者MAINTAINERname
RUN指令
RUN指令可以在当前镜像上执行Linux命令并形成一个新的层.RUN是编译时(build)的动作RUN/bin/bash-c"echohelloworld"或RUN["/bin/bash","-c","echohello"]
CMD指令
CMD指令指明了启动那个镜像容器时的默认行为.一个Dockerfile里只能有一个CMD指令.CMD指令里设定的命令可以在运行镜像时使用参数覆盖.CMDecho"thisisatest"可被dockerrun-dimage_nameecho"thisisnotatest"覆盖
EXPOSE指令
EXPOSE指明了镜像运行时的容器必须监听指定的端口.EXPOSE8080
ENV指令
ENV指令可用来设置环境变量ENVmyName=name或ENVmynamename
ADD指令
ADD指令是从当前工作目录复制文件到镜像目录中去ADDtest.txt/mydir/
ENTRYPOINT指令
ENTRYPOINT指令可让容器像一个可执行程序一样运行,这样镜像运行时可以像软件一样接口参数执行.ENTRYPOINT["/bin/echo"]我们可以向镜像传递参数运行dockerrun-dimage_name"thisisnotatest"
安装Docker
安装Dockeryuminstalldocker启动Docker并保持开机启动systemctlstartdockersystemctlenabledocker
项目目录及文件
编译镜像
dockerbuild-twisely/ch10docker.wisely/ch10docker为镜像名称,我们设置wisely作为前缀,这也是Docker镜像的一种命名习惯.注意,最后还有一个".",这是用来指明Dockerfile路径的,"."表示Dockerfile在当前路径下
运行
dockerrun-d--namech10-p8080:8080wisely/ch10docker
### SpringBoot的测试
SpringBoot为我们提供了一个@SpringApplicationConfiguration来替代@ContextConfiguration,用来配置ApplicationContext.
新建SpringBoot项目
业务代码
测试用例
执行测试

## 十一、 应用监控

### http
新建SpringBoot项目
依赖webactuatorHATEOAS
测试端点
actuator
autoconfig
beans
dump
configprops
health
info
metrics
mappings
shutdown
shutdown端点默认是关闭的,我们可以在application.properties中开启:endpoints.shutdown.enabled=trueshutdown端点不支持GET提交,不可以直接在浏览器上访问地址,所以我们使用PostMan来测试
trace
定制端点
修改端点id
endpoints.beans.id=mybeans
开启端点
endpoints.shutdown.enabled=true
关闭端点
endpoints.beans.enabled=false
只开启所需端点
若只开启所需端点的话,我们可以通过关闭所有的端点,然后再开启所需端点来实现.endpoints.enabled=falseendpoints.beans.enabled=true
定制端点访问路径
默认的端点访问路径是在根目录下的http://localhost:8080/beansmanagement.context-path=/managehttp://localhost:8080/manage/beans
定制端点访问端口
当我们基于安全的考虑,不暴露端点的端口到外部时,就需要应用本身的业务端口和端点锁用的端口使用不通的端口.我们可以通过如下配置改变端点访问的端口management.port=8081
关闭http端点
management.port=-1
自定义端点
状态服务
自定义端点
注册端点并定义演示控制器
自定义HealthIndicatior
### JMX
### SSH
新建SpringBoot项目
运行
常用命令
定制登录用户
扩展命令

## 十一、 分布式系统开发

### 微服务/原生云应用
微服务(Microservice)是近两年来非常火的概念,它的含义是:使用定义好边界的小的独立组建来做好一件事情.微服务是相对于传统单块式架构而言的.单块架构是一份代码,部署和伸缩都是基于单个单元进行的.优点:易于部署缺点:可用性低,可伸缩性差,集中发布的声明周期,违反单一功能原则
### SpringCloud快速入门
配置服务
服务发现
路由网关
负载均衡
断路由
### 实战
项目构建
服务发现Discovery(EurekaServer)
配置Config(ConfigServer)
服务模块Person服务
服务模块Some服务
界面模块UI(Ribbon,Feign)


断路器监控Monitor(DashBoard)
运行
### 基于Docker部署
Dockerfile编写
runboot.sh脚本的编写
位于src/main/dockersleep10java-Djava.security.egd=file:/dev/./urandom-jar/app/app.jar
Dockerfile编写
位于src/main/dockerFROMjava:8VOLUME/tmpRUNmkdir/appADDconfig-1.0.0-SNAPSHOT.jar/app/app.jarADDrunboot.sh/app/RUNbash-c'touch/app/app.jar'WORKDIR/appRUNchmoda+xrunboot.shEXPOSE8888CMD/app/runboot.sh为不同的微服务我们只需要修改ADDconfig-1.0.0-SNAPSHOT.jar/app/app.jar以及端口EXPOSE8888
Docker的Mean插件
编译镜像
DockerCompose
Docker-compose.yml编写
运行

## 附录

基于JHipster的代码生成
常用应用属性配置列表
