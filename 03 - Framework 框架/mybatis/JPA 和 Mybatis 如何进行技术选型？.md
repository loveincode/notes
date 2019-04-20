from https://mp.weixin.qq.com/s/yHQJff9cMXYKy_wK68qfCA

在我们平时的项目中，大家都知道可以使用 JPA 或者 Mybatis 作为 ORM 层。对 JPA 和 Mybatis 如何进行技术选型？

下面看看大精华总结如下：

### 最佳回答
首先表达个人观点，JPA必然是首选的。
个人认为仅仅讨论两者使用起来有何区别，何者更加方便，不足以真正的比较这两个框架。要评判出更加优秀的方案，我觉得可以从软件设计的角度来评判。
个人对 mybatis 并不熟悉，但 JPA 规范和 springdata 的实现，设计理念绝对是超前的。
软件开发复杂性的一个解决手段是遵循 DDD（DDD 只是一种手段，但不是唯一手段），而我着重几点来聊聊 JPA 的设计中是如何体现领域驱动设计思想的，抛砖引玉。

### 聚合根和值对象
领域驱动设计中有两个广为大家熟知的概念，entity（实体）和 value object（值对象）。
entity 的特点是具有生命周期的，有标识的，而值对象是起到一个修饰的作用，其具有不可变性，无标识。
在 JPA中 ，需要为数据库的实体类添加 @Entity 注解，相信大家也注意到了，这并不是巧合。
```java
public class Order {

    @Id
    private String oid;

    @Embedded
    private CustomerVo customer;

    @OneToMany(cascade = {CascadeType.ALL},orphanRemoval = true, fetch = FetchType.LAZY, mappedBy = "order")
    private List < OrderItem > orderItems;
}
```
如上述的代码，Order 便是 DDD 中的实体，而 CustomerVo，OrderItem 则是值对象。
程序设计者无需关心数据库如何映射这些字段，因为在 DDD 中，需要做的工作是领域建模，而不是数据建模。
实体和值对象的意义不在此展开讨论，但通过此可以初见端倪，JPA 的内涵绝不仅仅是一个 ORM 框架。

### 仓储
Repository 模式是领域驱动设计中另一个经典的模式。在早期，我们常常将数据访问层命名为：DAO，而在 SpringData JPA 中，其称之为 Repository（仓储），这也不是巧合，而是设计者有意为之。
熟悉 SpringData JPA 的朋友都知道当一个接口继承 JpaRepository 接口之后便自动具备了 一系列常用的数据操作方法，findAll， findOne ，save等。
...
那么仓储和DAO到底有什么区别呢？这就要提到一些遗留问题，以及一些软件设计方面的因素。在这次SpringForAll 的议题中我能够预想到有很多会强调 SpringData JPA 具有方便可扩展的 API，像下面这样：
...
但我要强调的是，这是 SpringData JPA 的妥协，其支持这一特性，并不代表其建议使用。因为这并不符合领域驱动设计的理念。注意对比，SpringData JPA 的设计理念是将 Repository 作为数据仓库，而不是一系列数据库脚本的集合，findByOrderNoAndXxxx 方法可以由下面一节要提到的JpaSpecificationExecutor代替，而 updateOrderStatusById 方法则可以由 findOne + save 代替，不要觉得这变得复杂了，试想一下真正的业务场景，修改操作一般不会只涉及一个字段的修改， findOne + save 可以帮助你完成更加复杂业务操作，而不必关心我们该如何编写 SQL 语句，真正做到了面向领域开发，而不是面向数据库 SQL 开发，面向对象的拥趸者也必然会觉得，这更加的 OO。

### Specification
上面提到 SpringData JPA 可以借助 Specification 模式代替复杂的 findByOrderNoAndXxxx 一类 SQL 脚本的查询。试想一下，业务不停在变，你怎么知道将来的查询会不会多一个条件 变成 findByOrderNoAndXxxxAndXxxxAndXxxx.... 。SpringData JPA 为了实现领域驱动设计中的 Specification 模式，提供了一些列的 Specification 接口，其中最常用的便是 ：JpaSpecificationExecutor
...
使用 SpringData JPA 构建复杂查询（join操作，聚集操作等等）都是依赖于 JpaSpecificationExecutor 构建的 Specification 。例子就不介绍，有点长。

请注意，上述代码并不是一个例子，在真正遵循 DDD 设计规范的系统中，OrderRepository 接口中就应该是干干净净的，没有任何代码，只需要继承 JpaRepository （负责基础CRUD）以及 JpaSpecificationExecutor （负责Specification 查询）即可。当然， SpringData JPA 也提供了其他一系列的接口，根据特定业务场景继承即可。

### 乐观锁
为了解决数据并发问题，JPA 中提供了 @Version ，一般在 Entity 中 添加一个 Long version 字段，配合 @Version 注解，SpringData JPA 也考虑到了这一点。这一点侧面体现出，JPA 设计的理念和 SpringData 作为一个工程解决方案的双剑合璧，造就出了一个伟大的设计方案。

### 复杂的多表查询
很多人青睐 Mybatis ，原因是其提供了便利的 SQL 操作，自由度高，封装性好……SpringData JPA对复杂 SQL 的支持不好，没有实体关联的两个表要做 join ，的确要花不少功夫。但 SpringData JPA 并不把这个当做一个问题。为什么？因为现代微服务的架构，各个服务之间的数据库是隔离的，跨越很多张表的 join 操作本就不应该交给单一的业务数据库去完成。解决方案是：使用 elasticSearch做视图查询 或者 mongodb 一类的Nosql 去完成。问题本不是问题。

### 总结
真正走进 JPA，真正走进 SpringData 会发现，我们并不是在解决一个数据库查询问题，并不是在使用一个 ORM 框架，而是真正地在实践领域驱动设计。

（再次补充：DDD 只是一种手段，但不是唯一手段）
