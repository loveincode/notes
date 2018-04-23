

### 启动Spring Boot应用
1. 作为一个Java应用程序，可以直接通过运行拥有main函数的类来启动。
2. 在Maven配置中，使用SpringBoot插件启动。如：执行 ```mvn spring-boot:run```命令。
3. 在服务器上部署运行时，通常先使用mvn install将应用打包成jar包，再通过java -jar xxx.jar( --server.port=8888 )来启动应用。

### 多环境配置

### 加载顺序
  1. 在命令行中传入的参数
  2. Spring_Application_Json中的属性。Spring_Application_Json是以Json格式p配置在系统环境变量中的内容。
  3. Java:comp/env中的JNDI属性
  4. Java的系统属性，可以通过System.getProperties()获得的内容
  5. 操作系统的环境变量
  6. 通过random.* 配置的随机属性
  7. 位于当前应用jar包之外，针对不同{profile}环境的配置文件内容，例如application-{profile}.properties或是YAML定义的配置文件
  8. 位于当前应用jar包之内，针对不同{profile}环境的配置文件内容，例如application-{profile}.properties或是YAML定义的配置文件
  9. 位于当前应用jar包之外的application.properties和YAML配置文件
  10. 位于当前应用jar包之内的application.properties和YAML配置文件
  11. 在@Configuration注解修改的类，通过@PropertySource注解定义的类
  12. 应用默认属性，使用SpringApplication.setDefaultProperties定义的内容
  优先级按上面的顺序由高到低，数字越小优先级越高。
可以看到，其中第7项和第9项是从应用jar之外读取配置文件，所以，实现外部化配置的原理就是从此切入，为其指定外部配置文件的加载位置来取代jar包之内的配置内容。通过这样的实现，我们的工程在配置中变得非常干净，只需在本地放置开发需要的配置即可，而不用关心其他环境的配置，由其对应环境的负责人去维护即可。

、
### 初识actuator
  spring-boot-starter-actuator模块根据应用依赖和配置自动创建出来的监控和管理端点。
