### 61，JDBC访问数据库的基本步骤是什么？

  1. 加载驱动
  2. 通过DriverManager对象获取连接对象Connection
  3. 通过连接对象获取会话
  4. 通过会话进行数据的增删改查，封装对象
  5. 关闭资源

### 62，说说preparedStatement和Statement的区别

  1. 效率：预编译会话比普通会话对象，数据库系统不会对相同的sql语句不会再次编译
  2. 安全性：可以有效的避免sql注入攻击！sql注入攻击就是从客户端输入一些非法的特殊字符，而使服务器端在构造sql语句的时候仍然能够正确构造，从而收集程序和服务器的信息和数据。
  比如：“select * from t_user where userName = ‘” + userName + “ ’ and password =’” + password + “’”
  如果用户名和密码输入的是’1’ or ‘1’=’1’ ;  则生产的sql语句是：
  “select * from t_user where userName = ‘1’ or ‘1’ =’1’  and password =’1’  or ‘1’=’1’  这个语句中的where 部分没有起到对数据筛选的作用。

### 63，说说事务的概念，在JDBC编程中处理事务的步骤。

  1.  事务是作为单个逻辑工作单元执行的一系列操作。
  2. 一个逻辑工作单元必须有四个属性，称为`原子性、一致性、隔离性和持久性 (ACID)` 属性，只有这样才能成为一个事务
  事务处理步骤：
  3. conn.setAutoComit(false);设置提交方式为手工提交
  4. conn.commit()提交事务
  5. 出现异常，回滚 conn.rollback();

### 64，数据库连接池的原理。为什么要使用连接池。

  1. 数据库连接是一件费时的操作，连接池可以使多个操作共享一个连接。
  2. 数据库连接池的基本思想就是为数据库连接建立一个“缓冲池”。预先在缓冲池中放入一定数量的连接，当需要建立数据库连接时，只需从“缓冲池”中取出一个，使用完毕之后再放回去。我们可以通过设定连接池最大连接数来防止系统无尽的与数据库连接。更为重要的是我们可以通过连接池的管理机制监视数据库的连接的数量、使用情况，为系统开发，测试及性能调整提供依据。
  3. 使用连接池是为了提高对数据库连接资源的管理

### 65，JDBC的 **脏读** 是什么？哪种数据库隔离级别能防止脏读？

  当我们使用事务时，有可能会出现这样的情况，有一行数据刚更新，与此同时另一个查询读到了这个刚更新的值。
  这样就导致了脏读，因为更新的数据还没有进行持久化，更新这行数据的业务可能会进行回滚，这样这个数据就是无效的。
  数据库的`TRANSACTION_READCOMMITTED，TRANSACTION_REPEATABLEREAD，和TRANSACTION_SERIALIZABLE`隔离级别可以防止脏读。

### 66，什么是 **幻读**，哪种隔离级别可以防止幻读？

  幻读是指一个事务`多次执行一条查询`返回的却是`不同的值`。
  假设一个事务正根据某个条件进行数据查询，然后另一个事务插入了一行满足这个查询条件的数据。
  之后这个事务再次执行了这条查询，返回的结果集中会包含刚插入的那条新数据。
  这行新数据被称为幻行，而这种现象就叫做幻读。
  只有`TRANSACTION_SERIALIZABLE`隔离级别才能防止产生幻读。

### 67，JDBC的`DriverManager`是用来做什么的？

  JDBC的DriverManager是一个工厂类，我们通过它来创建数据库连接。当JDBC的Driver类被加载进来时，它会自己注册到DriverManager类里面
  然后我们会把数据库配置信息传成`DriverManager.getConnection()`方法，DriverManager会使用注册到它里面的驱动来获取数据库连接，并返回给调用的程序。

### 68，execute，executeQuery，executeUpdate的区别是什么？

  1. Statement的execute(String query)方法用来执行任意的SQL查询，如果查询的结果是一个ResultSet，这个方法就返回true。如果结果不是ResultSet，比如insert或者update查询，它就会返回false。我们可以通过它的getResultSet方法来获取ResultSet，或者通过getUpdateCount()方法来获取更新的记录条数。
  2. Statement的executeQuery(String query)接口用来执行select查询，并且返回ResultSet。即使查询不到记录返回的ResultSet也不会为null。我们通常使用executeQuery来执行查询语句，这样的话如果传进来的是insert或者update语句的话，它会抛出错误信息为 “executeQuery method can not be used for update”的java.util.SQLException。 ,
  3. Statement的executeUpdate(String query)方法用来执行insert或者update/delete（DML）语句，或者 什么也不返回，对于DDL语句，返回值是int类型，如果是DML语句的话，它就是更新的条数，如果是DDL的话，就返回0。
  只有当你不确定是什么语句的时候才应该使用execute()方法，否则应该使用executeQuery或者executeUpdate方法。

### 69，SQL查询出来的结果分页展示一般怎么做？

  ``` SQL
  ==Oracle：
  select * from (select *,rownum as tempid from student )  t
      where t.tempid between  + pageSize*(pageNumber-1) +  and  + pageSize*pageNumber

  --MySQL：
  select * from students limit  + pageSize*(pageNumber-1) + , + pageSize;

  --sql server:
  select top  + pageSize +  * from students where id not in +
  (select top  + pageSize * (pageNumber-1) +  id from students order by id) + order by id;

  ```

### 70，JDBC的ResultSet是什么？

  在查询数据库后会返回一个ResultSet，它就像是查询结果集的一张数据表。
  ResultSet对象维护了一个游标，指向当前的数据行。开始的时候这个游标指向的是第一行。
  如果调用了ResultSet的next()方法游标会下移一行，如果没有更多的数据了，next()方法会返回false。
  可以在for循环中用它来遍历数据集。

  默认的ResultSet是不能更新的，游标也只能往下移。也就是说你只能从第一行到最后一行遍历一遍。不过也可以创建可以回滚或者可更新的ResultSet

  当生成ResultSet的Statement对象要关闭或者重新执行或是获取下一个ResultSet的时候，ResultSet对象也会自动关闭。
  可以通过ResultSet的getter方法，传入列名或者从1开始的序号来获取列数据。
