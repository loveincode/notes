http://www.voidcn.com/article/p-pdoembzi-bh.html

1. 容器启动(此处不介绍)

2. 读取listener,根据自定`org.springframework.web.context.ContextLoaderListener`。
    <listener>
    <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>
3. servlet-api里面有javax.servlet.ServletContextListener。用于监听servletContext对象的生命周期。里面有两个方法:
  public void contextInitialized ( ServletContextEvent sce );
  public void contextDestroyed ( ServletContextEvent sce );
  分别用于servlet初始化和销毁时的动作。
  ContextLoaderListener实现了这个接口。它定义的初始化：

      public void contextInitialized(ServletContextEvent event) {
          this.contextLoader = createContextLoader();
          if (this.contextLoader == null) {
              this.contextLoader = this;
          }
         this.contextLoader.initWebApplicationContext(event.getServletContext());
      }

  通过父类的initWebApplicationContext(ServletContext servletContext);方法来初始化并启动整个spring。
4. `initWebApplicationContext`(ServletContext servletContext);

  ①关于ServletContext：
          a.WEB容器在启动时，它会为每个WEB应用程序都创建一个对应的ServletContext对象，它代表当前web应用。
          b.一个WEB应用中的所有Servlet共享同一个ServletContext对象,Servlet对象之间可以通过ServletContext对象来实现通讯
  ②ServletContext会储存 ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE 标志在WebApplicationContext启动时绑定Context attribute。并且限制只能启动一个( 为什么只允许一个)
  ③通过ServletContext 来 createWebApplicationContext();
  A)determineContextClass(ServletContext servletContext)；
    1）获取web.xml中<param-name>contextClass</param-name>对应的<param-value>org.springframework.web.context.support.XmlWebApplicationContext</param-value>(这是从网上查看的资料，但是在自己测试的时候却总没有取到这个值null,它就采用了默认的值来寻找class。当然，XmlWebApplicationContext正是我们常用的用于跑spring的一个类)。
    2）从上面的配置中找到一个叫"contextClass"的<param-name>。通过spring的ClassUtils.forName(String name, ClassLoader classLoader)方法找寻需要的class类。找寻的位置是一个Map<String, Class<?>> 。Map里面理论上应该是boolean,char,boolean[],char[]，void等。根据它(基本类型)在‘boolean’等中找各自的类,找不到的话就在他们各自的封装类‘java.lang.Boolean’等里面去找。ClassUtil.forName(String name, ClassLoader classLoader)方法的目的就是通过name去找到对应的类。自然，不是基本类型或者其封装类的话就需要用制定的类加载器ClassLoader去加载指定名字的类。
    3）传参servletContext仅仅是为了找到这个web应用程序中定义的哪个param-value而已。
    4）determineContextClass得到的返回值应该是ConfigurableWebApplicationContext.class的实例，比如:org.springframework.web.context.support.XmlWebApplicationContext

  B)返回给上层一个已经初始化了的WebApplicationContext实例

  ④protected void configureAndRefreshWebApplicationContext(ConfigurableWebApplicationContext wac, ServletContext sc)：
  A)各类配置，不知道是我没有找到具体的配置位置,还是我没有配好。每次都不能取到值(null)。因此我就忽略掉这部分代码，全使用default(getInitParameter());
  B)这个时候就到了很牛逼的一步了：
      <context-param>
          <param-name>contextConfigLocation</param-name>
          <param-value>
              classpath:spring/dao.xml,
              classpath:spring/service.xml,
              classpath:spring/service-ref.xml,
              classpath:spring/registry.xml
          </param-value>
      </context-param>
  完全一样的写法,前面的就是获取不到值，这儿这个就是能获取得到值。这个让人觉得很不解。自然，这儿就是专门载入spring的各类配置文档。其处理过程也是最重要的咯。这部分内容留到下节来讲解。
  C)上面那个就变形为[classpath:spring/dao.xml, classpath:spring/service.xml, classpath:spring/service-ref.xml, classpath:spring/registry.xml],
  D)①determineContextInitializerClasses(servletContext)还给上层一个空的Arraylist。于是不再处理：相当于customizeContext(ServletContext servletContext, ConfigurableWebApplicationContext applicationContext)什么都没有处理。
    ②返回
  E）大事件:configureAndRefreshWebApplicationContext(cwac, servletContext);
