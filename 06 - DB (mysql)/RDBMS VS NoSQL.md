## RDBMS
RDBMS (Relational Database Management System) 关系型数据库管理系统。主要代表：SQL Server，Oracle，MySQL(开源)，PostgreSQL(开源)。
  RDBMS 是 SQL  (Structured Query Language)的基础，同样也是所有现代数据库系统的基础，比如 MS SQL Server、IBM DB2、Oracle、MySQL 以及 Microsoft Access。
  RDBMS 中的数据存储在被称为表的数据库对象中。
  表是相关的数据项的集合，它由列和行组成。
## NoSQL
NoSQL（Not Only SQL）泛指非关系型数据库。主要代表：MongoDB，Redis，CouchDB。
  用于超大规模数据的存储
  这些类型的数据存储不需要固定的模式，无需多余操作就可以横向扩展。

### RDBMS
- 高度组织化结构化数据
- 结构化查询语言（SQL） (SQL)
- 数据和关系都存储在单独的表中。
- 数据操纵语言，数据定义语言
- 严格的一致性
- 基础事务

### NoSQL
- 代表着不仅仅是SQL
- 没有声明性查询语言
- 没有预定义的模式
- 键 - 值对存储，列存储，文档存储，图形数据库
- 最终一致性，而非ACID属性
- 非结构化和不可预知的数据
- CAP定理
- 高性能，高可用性和可伸缩性

### NoSQL的优点/缺点
优点:

- 高可扩展性
- 分布式计算
- 低成本
- 架构的灵活性，半结构化数据
- 没有复杂的关系
缺点:

- 没有标准化
- 有限的查询功能（到目前为止）
- 最终一致是不直观的程序

### CAP定理（CAP theorem）
在计算机科学中, CAP定理（CAP theorem）, 又被称作 布鲁尔定理（Brewer's theorem）, 它指出对于一个分布式计算系统来说，`不可能同时满足以下三点`:

`一致性(Consistency)` (所有节点在同一时间具有相同的数据)
`可用性(Availability)` (保证每个请求不管成功或者失败都有响应)
`分隔容忍(Partition tolerance)` (系统中任意信息的丢失或失败不会影响系统的继续运作)
CAP理论的核心是：一个分布式系统不可能同时很好的满足一致性，可用性和分区容错性这三个需求，`最多只能同时较好的满足两个`。

因此，根据 CAP 原理将 `NoSQL` 数据库分成了满足 `CA` 原则、满足 `CP` 原则和满足 `AP` 原则三 大类：

`CA` - 单点集群，满足一致性，可用性的系统，通常在可扩展性上不太强大。
`CP` - 满足一致性，分区容忍性的系统，通常性能不是特别高。
`AP` - 满足可用性，分区容忍性的系统，通常可能对一致性要求低一些。

### BASE
BASE：Basically Available, Soft-state, Eventually Consistent。 由 Eric Brewer 定义。
CAP理论的核心是：一个分布式系统不可能同时很好的满足`一致性，可用性和分区容错性`这三个需求，最多只能同时较好的满足两个。
BASE是NoSQL数据库通常对可用性及一致性的弱要求原则:

`Basically Availble` --基本可用
`Soft-state --软状态/柔性事务。` "Soft state" 可以理解为"无连接"的, 而 "Hard state" 是"面向连接"的
`Eventual Consistency` -- 最终一致性， 也是是 ACID 的最终目的。

### ACID vs BASE
ACID	                 BASE
原子性(Atomicity)	   基本可用(Basically Available)
一致性(Consistency)	 软状态/柔性事务(Soft state)
隔离性(Isolation)     最终一致性 (Eventual consistency)
持久性 (Durable)	 

## NoSQL 数据库分类
类型	                           部分代表                   特点
`列存储`               `Hbase` `Cassandra` `Hypertable`      顾名思义，是按列存储数据的。最大的特点是方便`存储结构化`和`半结构化`数据，方便做数据`压缩`，对针对`某一列`或者某`几列`的查询有非常大的`IO`优势。

`文档存储`          `MongoDB` `CouchDB`                      文档存储一般用类似`json`的格式存储，存储的内容是文档型的。这样也就有有机会对某些字段建立索引，实现关系数据库的某些功能。

`key-value存储`     `Tokyo Cabinet` / `Tyrant`  `Berkeley DB` `MemcacheDB`  `Redis` 可以通过key快速查询到其value。一般来说，存储不管value的格式，照单全收。（Redis包含了其他功能）

`图存储`           `Neo4J`   `FlockDB`                       图形关系的最佳存储。使用传统关系数据库来解决的话性能低下，而且设计使用不方便。

`对象存储`          `db4o`  `Versant`                        通过类似`面向对象语言`的语法操作数据库，通过对象的方式存取数据。

`xml数据库`         `Berkeley DB XML`  `BaseX`               高效的存储XML数据，并支持XML的内部查询语法，比如XQuery,Xpath。
