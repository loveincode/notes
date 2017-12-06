zookeeper是dubbo推荐的注册中心。
![](https://github.com/loveincode/notes/blob/master/image/04/dubbo/1.jpg)
 1. 服务提供者启动时向/dubbo/com.foo.BarService/providers目录下写入URL
 2. 服务消费者启动时订阅/dubbo/com.foo.BarService/providers目录下的URL向/dubbo/com.foo.BarService/consumers目录下写入自己的URL
 3. 监控中心启动时订阅/dubbo/com.foo.BarService目录下的所有提供者和消费者URL

支持以下功能：

 1. 当提供者出现断电等异常停机时，注册中心能自动删除提供者信息。
 2. 当注册中心重启时，能自动恢复注册数据，以及订阅请求。
 3. 当会话过期时，能自动恢复注册数据，以及订阅请求。
 4. 当设置<dubbo:registry check="false" />时，记录失败注册和订阅请求，后台定时重试。
 5. 可通过<dubbo:registry username="admin" password="1234" />设置zookeeper登录信息。
 6. 可通过<dubbo:registry group="dubbo" />设置zookeeper的根节点，不设置将使用无根树。
 7. 支持*号通配符<dubbo:reference group="*" version="*" />，可订阅服务的所有分组和所有版本的提供者。

注意的是阿里内部并没有采用Zookeeper做为注册中心，而是使用自己实现的基于数据库的注册中心，即：Zookeeper注册中心并没有在阿里内部长时间运行的可靠性保障，此Zookeeper桥接实现只为开源版本提供，其可靠性依赖于Zookeeper本身的可靠性。

dubbo是**动物**..zookeeper是**动物园的管理员**！

按我的理解，您可以把dubbo服务想象成学校里的一个学生，并且对应有一个学号，zookeeper则是想象成一个教务网管理系统。我们可以通过教务网管理系统，查找到对应的学生。我们首先通过注册入学，将学生和学号对应绑定。          

比方说项目是一个分布式的项目，web层与 service层被拆分了开来， 部署在不同的tomcat中， 我在web层 需要调用 service层的接口，但是两个运行在不同tomcat下的服务无法直接互调接口，那么就可以通过zookeeper和dubbo实现。 我们通过dubbo 建立ItemService这个服务，并且到zookeeper上面注册，填写对应的zookeeper服务所在 的IP及端口号。【按照我上面的比喻就是，学生注册入学（接口是学号，学生本人是impl实现），填写学校教务网网址（就是zookeeper）】
![](https://github.com/loveincode/notes/blob/master/image/04/dubbo/2.jpg)
下面我们的 web层需要来调用 service接口了，由于在不同的工程中，它是无法直接找到service接口的，我们使用dubbo再来引用注册进入的dubbo服务。我们先填写zookeeper服务所在 的IP及端口号，再填写我们需要调用的接口名字。【按照我上面的比喻，就是填写学校的教务网网址，我们在教务网中，通过学号（接口名），查询到对应的学生】
![](https://github.com/loveincode/notes/blob/master/image/04/dubbo/3.jpg)
