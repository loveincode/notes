  Spring事务 的本质其实就是数据库对事务的支持，没有数据库的事务支持，spring是无法提供事务功能的。
  真正的数据库层的事务提交和回滚是通过binlog或者redo log实现的。
  https://blog.csdn.net/trigl/article/details/50968079  
  https://juejin.im/post/5b00c52ef265da0b95276091

  事务属性的种类：   **传播行为**、**隔离级别**、只读和事务超时

### 传播行为
  传播行为定义了被调用方法的事务边界。

7种传播行为|描述
-----|-----
**支持当前事务** |
`PROPAGATION_REQUIRED`(默认）| 如果当前存在事务，则加入该事务；如果当前没有事务，则创建一个新的事务。
`PROPAGATION_SUPPORTS`      | 如果当前存在事务，则加入该事务；如果当前没有事务，则以非事务的方式继续运行。
`PROPAGATION_MANDATORY`     | 如果当前存在事务，则加入该事务；如果当前没有事务，则抛出异常。
**不支持当前事务** |
`PROPAGATION_REQUIRES_NEW`  | 创建一个新的事务，如果当前存在事务，则把当前事务挂起。
`PROPAGATION_NOT_SUPPORTED` | 以非事务方式运行，如果当前存在事务，则把当前事务挂起。
`PROPAGATION_NEVER`         | 以非事务方式运行，如果当前存在事务，则抛出异常。
**其他情况** |
`PROPAGATION_NESTED`        | 如果当前存在事务，则创建一个事务作为当前事务的嵌套事务来运行；如果当前没有事务，则该取值等价于TransactionDefinition.PROPAGATION_REQUIRED。

###   隔离级别
  在操作数据时可能带来 3 个副作用，分别是脏读、不可重复读、幻读。为了避免这 3 中副作用的发生，在标准的 SQL 语句中定义了 4 种隔离级别，分别是未提交读、已提交读、可重复读、可序列化。而在 spring 事务中提供了 5 种隔离级别来对应在 SQL 中定义的 4 种隔离级别，如下：

5种隔离级别|描述
-|-
ISOLATION_ **DEFAULT**           |    使用后端数据库默认的隔离级别
ISOLATION_ **READ_UNCOMMITTED**  |    最低的隔离级别,允许读取未提交的数据（对应`未提交读`），可能 **导致脏读、不可重复读、幻读**
ISOLATION_ **READ_COMMITTED**    |    允许读取并发事务已经提交的数据（对应`已提交读`）。可以 **避免脏读，但是无法避免不可重复读和幻读**
ISOLATION_ **REPEATABLE_READ**   |    对同一字段的多次读取结果都是一致的，除非数据是被本身事务自己所修改（对应`可重复读`）。**可以避免脏读和不可重复读，但无法避免幻读**
ISOLATION_ **SERIALIZABLE**      |    最高的隔离级别，完全服从ACID的隔离级别。所有的事务依次逐个执行，这样事务之间就完全不可能产生干扰（对应`可序列化`）。**可以避免脏读、不可重复读、幻读。但是这种隔离级别效率很低，因此，除非必须，否则不建议使用。**

`脏读（Dirty read） 未提交读`：一事务对数据进行了增删改，但未提交，另一事务可以读取到未提交的数据。如果第一个事务这时候回滚了，那么第二个事务就读到了脏数据。

`丢失修改（Lost to modify）`: 指在一个事务读取一个数据时，另外一个事务也访问了该数据，那么在第一个事务中修改了这个数据后，第二个事务也修改了这个数据。这样第一个事务内的修改结果就被丢失，因此称为丢失修改。
例如：事务1读取某表中的数据A=20，事务2也读取A=20，事务1修改A=A-1，事务2也修改A=A-1，最终结果A=19，事务1的修改被丢失。

`不可重复读（Unrepeatableread）`：一个事务中发生了两次读操作，第一次读操作和第二次操作之间，另外一个事务对数据进行了修改，这时候两次读取的数据是不一致的。

`幻读（Phantom read）`：第一个事务对一定范围的数据进行批量修改，第二个事务在这个范围增加一条数据，这时候第一个事务就会丢失对新增数据的修改。

`不可重复度和幻读区别：`
不可重复读的重点是修改，幻读的重点在于新增或者删除。
例1（同样的条件, 你读取过的数据, 再次读取出来发现值不一样了 ）：事务1中的A先生读取自己的工资为     1000的操作还没完成，事务2中的B先生就修改了A的工资为2000，导        致A再读自己的工资时工资变为  2000；这就是不可重复读。
例2（同样的条件, 第1次和第2次读出来的记录数不一样 ）：假某工资单表中工资大于3000的有4人，事务1读取了所有工资大于3000的人，共查到4条记录，这时事务2 又插入了一条工资大于3000的记录，事务1再次读取时查到的记录就变为了5条，这样就导致了幻读。

`总结：`
隔离级别越高，越能保证数据的完整性和一致性，但是对并发性能的影响也越大。
大多数的数据库默认隔离级别为 Read Commited，比如 SqlServer、Oracle
少数数据库默认隔离级别为：Repeatable Read 比如： MySQL InnoDB

### 注解

  ```java
  // 指定回滚
  @Transactional(rollbackFor=Exception.class)

  //指定不回滚
  @Transactional(noRollbackFor=Exception.class)

  // 如果有事务,那么加入事务,没有的话新建一个(不写的情况下)
  @Transactional(propagation=Propagation.REQUIRED)

  // 不管是否存在事务,都创建一个新的事务,原来的挂起,新的执行完毕,继续执行老的事务
  @Transactional(propagation=Propagation.REQUIRES_NEW)

  // 必须在一个已有的事务中执行,否则抛出异常
  @Transactional(propagation=Propagation.MANDATORY)

  // 必须在一个没有的事务中执行,否则抛出异常(与Propagation.MANDATORY相反)
  @Transactional(propagation=Propagation.NEVER)

  // 如果其他bean调用这个方法,在其他bean中声明事务,那就用事务.如果其他bean没有声明事务,那就不用事务.
  @Transactional(propagation=Propagation.SUPPORTS)

  // 容器不为这个方法开启事务
  @Transactional(propagation=Propagation.NOT_SUPPORTED)

  // readOnly=true只读,不能更新,删除
  @Transactional(propagation = Propagation.REQUIRED,readOnly=true)

  // 设置超时时间
  @Transactional(propagation = Propagation.REQUIRED,timeout=30)

  // 设置数据库隔离级别
  @Transactional(propagation = Propagation.REQUIRED,isolation=Isolation.DEFAULT)
  ```

### 事务的嵌套
  通过上面的理论知识的铺垫，我们大致知道了数据库事务和spring事务的一些属性和特点，接下来我们通过分析一些嵌套事务的场景，来深入理解spring事务传播的机制。

  假设外层事务 Service A 的 Method A() 调用 内层Service B 的 Method B()

  `PROPAGATION_REQUIRED(spring 默认)`

  如果ServiceB.methodB() 的事务级别定义为 PROPAGATION_REQUIRED，那么执行 ServiceA.methodA() 的时候spring已经起了事务，这时调用 ServiceB.methodB()，ServiceB.methodB() 看到自己已经运行在 ServiceA.methodA() 的事务内部，就不再起新的事务。

  假如 ServiceB.methodB() 运行的时候发现自己没有在事务中，他就会为自己分配一个事务。

  这样，在 ServiceA.methodA() 或者在 ServiceB.methodB() 内的任何地方出现异常，事务都会被回滚。

  `PROPAGATION_REQUIRES_NEW`

  比如我们设计 ServiceA.methodA() 的事务级别为 PROPAGATION_REQUIRED，ServiceB.methodB() 的事务级别为 PROPAGATION_REQUIRES_NEW。

  那么当执行到 ServiceB.methodB() 的时候，ServiceA.methodA() 所在的事务就会挂起，ServiceB.methodB() 会起一个新的事务，等待 ServiceB.methodB() 的事务完成以后，它才继续执行。

  他与 PROPAGATION_REQUIRED 的事务区别在于事务的回滚程度了。因为 ServiceB.methodB() 是新起一个事务，那么就是存在两个不同的事务。如果 ServiceB.methodB() 已经提交，那么 ServiceA.methodA() 失败回滚，ServiceB.methodB() 是不会回滚的。如果 ServiceB.methodB() 失败回滚，如果他抛出的异常被 ServiceA.methodA() 捕获，ServiceA.methodA() 事务仍然可能提交(主要看B抛出的异常是不是A会回滚的异常)。

  `PROPAGATION_SUPPORTS`

  假设ServiceB.methodB() 的事务级别为 PROPAGATION_SUPPORTS，那么当执行到ServiceB.methodB()时，如果发现ServiceA.methodA()已经开启了一个事务，则加入当前的事务，如果发现ServiceA.methodA()没有开启事务，则自己也不开启事务。这种时候，内部方法的事务性完全依赖于最外层的事务。

  `PROPAGATION_NESTED`

  现在的情况就变得比较复杂了, ServiceB.methodB() 的事务属性被配置为 PROPAGATION_NESTED, 此时两者之间又将如何协作呢? ServiceB#methodB 如果 rollback, 那么内部事务(即 ServiceB#methodB) 将回滚到它执行前的 SavePoint 而外部事务(即 ServiceA#methodA) 可以有以下两种处理方式:
  a、捕获异常，执行异常分支逻辑
  ```java
  void methodA() {

          try {

              ServiceB.methodB();

          } catch (SomeException) {

              // 执行其他业务, 如 ServiceC.methodC();

          }

      }
  ```
  这种方式也是嵌套事务最有价值的地方, 它起到了分支执行的效果, 如果 ServiceB.methodB 失败, 那么执行 ServiceC.methodC(), 而 ServiceB.methodB 已经回滚到它执行之前的 SavePoint, 所以不会产生脏数据(相当于此方法从未执行过), 这种特性可以用在某些特殊的业务中, 而 PROPAGATION_REQUIRED 和 PROPAGATION_REQUIRES_NEW 都没有办法做到这一点。

  b、 外部事务回滚/提交 代码不做任何修改, 那么如果内部事务(ServiceB#methodB) rollback, 那么首先 ServiceB.methodB 回滚到它执行之前的 SavePoint(在任何情况下都会如此), 外部事务(即 ServiceA#methodA) 将根据具体的配置决定自己是 commit 还是 rollback

### 实现

  事务是由AOP实现

  定义order的大小 ，值越小，说明越先被执行


### 只读
  事务的只读属性是指，对事务性资源进行只读操作或者是读写操作。所谓事务性资源就是指那些被事务管理的资源，比如数据源、 JMS 资源，以及自定义的事务性资源等等。如果确定只对事务性资源进行只读操作，那么我们可以将事务标志为只读的，以提高事务处理的性能。在 TransactionDefinition 中以 boolean 类型来表示该事务是否只读。


  如果在一个事务中所有关于数据库的操作都是只读的，也就是说，这些操作只读取数据库中的数据，而并不更新数据，那么应将事务设为只读模式（ READ_ONLY_MARKER ） , 这样更有利于数据库进行优化 。

  因为只读的优化措施是事务启动后由数据库实施的，因此，只有将那些具有可能启动新事务的传播行为 (PROPAGATION_NESTED 、 PROPAGATION_REQUIRED 、 PROPAGATION_REQUIRED_NEW) 的方法的事务标记成只读才有意义。

  如果使用 Hibernate 作为持久化机制，那么将事务标记为只读后，会将 Hibernate 的 flush 模式设置为 FULSH_NEVER, 以告诉 Hibernate 避免和数据库之间进行不必要的同步，并将所有更新延迟到事务结束。

### 事务超时
  如果一个事务长时间运行，这时为了尽量避免浪费系统资源，应为这个事务设置一个有效时间，使其等待数秒后自动回滚。
  与设置“只读”属性一样，事务有效属性也需要给那些具有可能启动新事物的传播行为的方法的事务标记成只读才有意义。
  所谓事务超时，就是指一个事务所允许执行的最长时间，如果超过该时间限制但事务还没有完成，则自动回滚事务。在 TransactionDefinition 中以 int 的值来表示超时时间，其单位是秒。
