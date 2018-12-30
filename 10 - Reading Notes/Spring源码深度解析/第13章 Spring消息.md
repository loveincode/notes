Java消息服务（Java Message Service， JMS）应用程序接口是一个Java平台中关于面向消息中间件（MOM）的API。

用于两个应用程序之间或分布式系统中发送消息、进行异步通信。

Java消息服务是一个与具体平台无关的API，绝大多数MOM提供商都对JMS提供支持。

Java消息服务的规范包括两种消息模式，点对点和发布者/订阅者。

Java消息服务支持同步和异步的消息处理

Java消息服务支持面向事件的方法接收消息，事件驱动的程序设计现在被广泛认为是一种富有成效的程序设计范例。

## 13.1 JMS的独立使用
1. 发送端实现
  发送
2. 接收端实现
  接收

## 13.2 Spring整合ActiveMQ
1. Spring配置文件
  Spring整合消息服务的使用从配置文件配置开始。
  类似于数据库操作，Spring也将ActiveMQ中的操作统一封装至jmsTemplate中，以便我们统一使用。
  ActiveMQConnectionFactory用于连接消息服务器，是消息服务的基础，也要注册
  ActiveMQQueue用于指定消息的目的地

```xml
    <!-- 第三方MQ工厂: ConnectionFactory -->
    <bean id="targetConnectionFactory" class="org.apache.activemq.ActiveMQConnectionFactory">
    <!-- ActiveMQ Address -->
        <property name="brokerURL" value="${activemq.brokerURL}" />
        <property name="userName" value="${activemq.userName}"></property>
        <property name="password" value="${activemq.password}"></property>
    </bean>
    <!-- Spring提供的JMS工具类，它可以进行消息发送、接收等 -->
    <!-- 队列模板 -->
    <bean id="jmsTemplate" class="org.springframework.jms.core.JmsTemplate">  
        <!-- 这个connectionFactory对应的是我们定义的Spring提供的那个ConnectionFactory对象 -->  
        <property name="connectionFactory" ref="connectionFactory"/>  
        <property name="defaultDestinationName" value="${activemq.queueName}"></property>
    </bean>
    <!--这个是目的地:destination -->
    <bean id="destination" class="org.apache.activemq.command.ActiveMQQueue">
    <constructor-arg>
    <value>${activemq.queueName}</value>
    </constructor-arg>
    </bean>
```
2. 发送端
  Spring可以根据配置信息简化我们的工作量。
  Spring使用发送消息到消息服务器，省去了冗余的Connection以及Session等的创建与销毁过程，简化了工作量。
  ``` java
  jmsTemplate.send(destination,new MessageCreator(){
      public Message createMessage(Session session) throws JMSException{
        return session.createTextMessage("ceshi");
      }
  });
  ```
3. 接收端
  ``` java
  TextMessage msg = (TextMessage)jmsTemplate.receive(destination);
  System.out.println(msg.getText());
  ```
以上的操作
jmsTemplate.receive(destination)方法只能接收一次消息，如果未接收到消息，则会一直等待，可设置timeout超时，但是一旦接收到消息本次接收任务就会结束。
可通过while(true)来实现循环监听消息服务器的消息。
更好的方法创建消息监听器
**消息监听器使用方式如下：**
1. 创建消息监听器
  一旦有新消息Spring会将消息引导至消息监听器以便用户进行相应的逻辑处理
  MessageListener
  实现OnMessage()方法
  OnMessage(Message arg0)
2. 修改配置文件
  使用消息监听器，需要在配置文件中注册消息容器，并将消息监听器注入到容器中
``` xml
    <!-- 配置自定义监听：MessageListener -->
    <bean id="textMessageListener" class="com.xxx.mq.MessageListener"></bean>
    <!-- 将连接工厂、目标对了、自定义监听注入jms模板 -->
    <bean id="sessionAwareListenerContainer" class="org.springframework.jms.listener.DefaultMessageListenerContainer">
        <property name="connectionFactory" ref="connectionFactory" />
        <property name="destination" ref="destination" />
        <property name="messageListener" ref="textMessageListener" />
    </bean>
```
通过以上的修改便可以进行消息监听的功能了，一旦有消息传入消息服务器，则会被消息监听器坚挺到，并有Spring将消息内容引导至消息监听器的处理函数中等待用户进一步逻辑处理。

## 13.3 源码分析
### 13.3.1 JmsTemplate
  1. 通用代码抽取
  2. 发送消息的实现
  3. 接收消息
### 13.3.2 监听器容器
  
