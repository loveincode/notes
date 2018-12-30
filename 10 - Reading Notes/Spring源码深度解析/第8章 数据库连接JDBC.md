JDBC(Java Data Base Connectivity，Java数据库连接)是一种执行Sql语句的JavaAPI，可以为多种关系数据库提供统一访问，它由一组用Java语言编写的类和接口组成。
JDBC连接数据库的流程及其原理如下：
1 在开发环境中加载指定数据库的驱动程序
2 在Java程序中加载驱动程序
3 创建数据连接对象
4 创建Statement对象
5 调用Statement对象的相关方法执行相对应的SQL语句
6 关闭数据库连接

## 8.1 Spring连接数据库程序实现（JDBC）
  1 创建数据表结构
  2 创建对应数据表的PO
  3 创建表与实体间的映射
  4 创建数据操作接口
  5 创建数据操作接口实现类
    **JDBCTemplate**
  6 创建Spring配置文件
    配置数据源
    ``` xml
    <beans id="dataSource" class="">
    </beans>
    ```
  7 测试
## 8.2 save/update功能的实现
    DataSource是整个数据库操作的基础，里面封装了整个数据库的连接信息。
    execute方法是最基础的操作，而其他操作如update、query等方法则是传入不用的PreparedStatementCallback参数来执行不同的逻辑。
### 8.2.1 基础方法execute
  **execute** 作为数据库操作的核心入口，将大多数数据库操作相同的步骤统一封装，而将个性化的操作使用参数 **PreparedStatementCallback** 进行回调
  1. 获取数据库连接
  2. 应用用户设定的输入参数
  3. 调用回调函数
  4. 警告处理
  5. 资源释放
### 8.2.2 Update中的回调函数
  PreparedStatementCallback 作为一个接口，其中只有一个函数doInPreparedStatement,这个函数是用于调用通用方法execute的时候无法处理的一些个性化处理方法
  pss.setValues(ps)

## 8.3 query功能的实现
  回调类PreparedStatementCallback的实现中使用ps.executeQuery()执行查询操作，
  rse.extractData(rsToUse)方法负责将结果进行封装并转换至POJO
## 8.4 queryForObject
  
