在讨论具体方式的时候，我们先看看使用activemq需要启动服务的主要过程。
按照JMS的规范，我们首先需要获得一个JMS connection factory.，通过这个connection factory来创建connection.在这个基础之上我们再创建session, destination, producer和consumer。因此主要的几个步骤如下：
1. 获得JMS connection factory. 通过我们提供特定环境的连接信息来构造factory。
2. 利用factory构造JMS connection
3. 启动connection
4. 通过connection创建JMS session.
5. 指定JMS destination.
6. 创建JMS producer或者创建JMS message并提供destination.
7. 创建JMS consumer或注册JMS message listener.
8. 发送和接收JMS message.
9. 关闭所有JMS资源，包括connection, session, producer, consumer等。
Java Message Service：是Java平台上有关面向消息中间件的技术规范。

执行流程：
通过生产者配置文件配置Spring Caching连接工厂和JmsTemplate的类型（Queue，Topic），发布消息时通过调用jmsTemplate的send(“bos_sms”, new MessageCreator())方
法(第一个参数与消费者配置文件中的 监听器 一致，new MessageCreator()是一个接口，通过
mapMessage.setString(“randomCode”, randomCode)添加信息)，当消息发布成功之后，消费者会通过消费者配置文件中对应的的监听器（Queue，Topic）监听到消息队列中
有新的消息，则对应的()消费者方法（smsConsumer）执行，该方法需要实现MessageListener 接口

配置信息：
生产者配置：ConnectionFactory生产ConnectionFactory—》定义JmsTemplate的Queue类型
生产发布消息：jmsTemplate.send(“bos_sms”, new MessageCreator() {}) bos_sms:消费者（在消费者配置文件中），new MessageCreator() {}：中的Message存储相关消息具体内容
消费配置：ConnectionFactory生产ConnectionFactory—》定义Queue监听器（监听到有mq，则执行消费者代码）
消费者消费消息：消费者实现MessageListener 接口。
