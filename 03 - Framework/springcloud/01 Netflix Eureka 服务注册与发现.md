Spring Cloud是一个基于Spring Boot实现的云应用开发工具，它为基于JVM的云应用开发中的配置管理、服务发现、断路器、智能路由、微代理、控制总线、全局锁、决策竞选、分布式会话和集群状态管理等操作提供了一种简单的开发方式。


Spring Cloud包含了多个子项目（针对分布式系统中涉及的多个不同开源产品），
比如：
Spring Cloud Config、
Spring Cloud Netflix、
Spring Cloud CloudFoundry、
Spring Cloud AWS、
Spring Cloud Security、
Spring Cloud Commons、
Spring Cloud Zookeeper、
Spring Cloud CLI
等项目。

## 微服务架构
“微服务架构”在这几年非常的火热，以至于关于微服务架构相关的产品社区也变得越来越活跃（比如：netflix、dubbo），Spring Cloud也因Spring社区的强大知名度和影响力也被广大架构师与开发者备受关注。

那么什么是“微服务架构”呢？简单的说，微服务架构就是将一个完整的应用从数据存储开始垂直拆分成多个不同的服务，每个服务都能独立部署、独立维护、独立扩展，服务与服务间通过诸如RESTful API的方式互相调用。

对于“微服务架构”，大家在互联网可以搜索到很多相关的介绍和研究文章来进行学习和了解。也可以阅读始祖Martin Fowler的《Microservices》，本文不做更多的介绍和描述。


Spring Cloud Netflix : 它主要提供的模块包括：**服务发现（Eureka）**，**断路器（Hystrix）**，**智能路由（Zuul）**，**客户端负载均衡（Ribbon）** 等。

服务注册中心 Eureka

Ribbon Ribbon是一个基于HTTP和TCP客户端的负载均衡器。 Feign中也使用Ribbon，
