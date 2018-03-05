# 一、关键性指标
在数据库性能评测中，有几项指标很重要，用它来评估数据库的能力，不是他们能起着多么关键的作用，而是他们能够较为明确的代表数据库在某些方面的能力。

## 1.IOPS
IOPS：Input/Output operation Per Second, 每秒处理的IO请求次数。
我们知道I/O就是磁盘的读写能力，比如每秒读 300M，写 200M，这个即数据的吞吐量（I/O能力的另一个关键指标），但是 IOPS 指的可不是读写的数据吞吐量，IOPS 指的是每秒能够处理的 I/O 请求次数。

如果想I/O 系统响应够快，那么 IOPS 越高越好，因为IOPS 和硬件有关，所以，要提高IOPS，就目前来看基本只能拼硬件，传统方案是使用多块磁盘通过 RAID 条带后，使 I/O 读写能力获得提升，我们也可以使用固态硬盘SSD来提升IOPS，不过固态硬盘成本可能比较大。

## 2.QPS
QPS：Query Per Second，每秒请求（查询）次数。
这个参数非常重要，可以直观的反映系统的性能，这就像IOPS衡量磁盘每秒钟能接收多少次请求。

我们可以在MySQL命令行模式下执行 status 命令，返回的最后一行输出信息中就包含 QPS 指标。

## 3.TPS
TPS：Transaction Per Second，每秒事务数。
TPS参数MySQL原生没有提供，如果需要我们自己算，可以利用计算的公式：

TPS = (Com_commit + Com_rollback) / Seconds
这个公式有两个状态变量，分别代表提交次数和回滚次数，Seconds 就是我们定义的时间间隔。

# 二、TPCC测试关键性指标
TPCC-MySQL 由Percona基于TPCC规范开发的一套MySQL基准测试程序，我们使用这套工具来测试前面的三个重要指标。

## 1.TPCC工具安装及使用
具体的安装，可以看这这两篇博文 mysql压力测试工具tpcc-mysql安装测试使用，mysql性能测试-tpcc，TPCC更能模拟线上业务。

# 三、数据库参数配置优化
如果数据库参数配置合理，则可以大大的提高运行效率，即最大化利用系统资源。

可以使用该命令查看MySQL的默认配置：
``` mysql
show global variables
show global variables like '%max_connections%'
```

## 1.连接相关参数
### 1.1 max_connections

```max_connections```：指定 MySQL 服务端最大并发连接数，值得范围从 1~10 万，默认值为151.
这个参数非常重要，因为它决定了同时最多能有多少个会话连接到 MySQL 服务。设定该参数时，根据数据库服务器的配置和性能，一般将参数值设置在 500~2000 都没太大的问题。

## 1.2 max_connect_errors

```max_connect_errors```：指定允许连接不成功的最大尝试次数，值得范围从 1~2^64 之间，在 5.6.6 版本默认值是 100。

一定不要忽视这个参数，如果尝试连接的错误数量超过该参数指定值，则服务器就不再允许新的连接，没错，就是拒绝连接，尽管 MySQL 仍在提供服务，但无法创建新的连接了。可以使用 FLUSH HOSTS，使状态清零或重新启动数据库服务，不过这个代价太高了，一般不会这么干，所以，这个参数的默认值太小，这里建议将之设置为 10 万以上的量级。

## 1.3 interactive_timeout 和 wait_timeout

这两个参数都与连接会话的自动超时断开有关，前者用于指定关闭交互连接前等待的时间，后者用于指定关闭非交互连接前的等待时间，单位均是秒，默认值均为 28800，即 8 个小时。

## 1.4 skip-name-resolve

```skip-name-resolve```：可以将其简单的理解为禁用 DNS 解析，注意啊，这个是服务端的行为，连接时不检查客户端主机名，而只使用IP。如果制定了该参数，那么在创建用户及授予权限时，HOST 列必须是IP而不能是主机名。建议启用该参数，对于加快网络连接有一定的帮助，等于是跳过了主机名的解析。

1.5 back_log

```back_log```：指定 MySQL 连接请求队列中存放的最大连接请求数量，在 5.6.6 版本之前，默认是 50 个，最大值不超过 65535。在 5.6.6 版本之后，默认值为 -1，表示由MySQL自动调节，所谓自行调节其实也有规则，即 50+（max_connections/5）。

该参数主要应对短时间内有大量的连接请求，MySQL 主线程无法及时为每一个连接请求分配（或创建）连接的线程，怎么办呢，它也不能直接拒绝，于是就将一部分请求放到等待队列中待处理，这个等待队列的长度就是 back_log 的参数值，若等待队列也被放满了，那么后续的连接请求才会被拒绝。

## 2.文件相关参数
### 2.1 sync_binlog
```sync_binlog```：指定同步二进制日志文件的平率，默认为0.
如果要性能，则指定该参数为0，为了安全起见则指定该参数值为 1.
### 2.2 expire_logs_day
```expire_logs_day```：指定设置二进制日志文件的生命周期，超出则将自动被删除，参数值以天为单位，值得范围从0~99，默认值是0，建议将该参数设置为 7~14 之间，保存一到两周就足够了。
### 2.2 max_binlog_size

```max_binlog_size```： 指定二进制日志的大小，值得范围从 4KB~1GB，默认为 1GB。

## 3.缓存控制参数
### 3.1 thread_cache_size

```thread_cache_size```:指定MySQL为快速重用而缓存的线程数量。值得范围从 0~16384，默认值为0.
一般当客户端中断连接后，为了后续再有连接创建时，能够快速创建成功，MySQL 会将客户端中断的连接放入缓存区，而不是马上中断释放资源。这样当有新的客户端请求连接时，就可以快速创建成功。因此，本参数最好保持一定的数量，建议设置在 300~500 之间均可.另外，线程缓存的命中率也是一项比较重要的监控指标，计算规则为（1-Threads_created/Connections）* 100%,我们可以通过该指标来优化和调整thread_cache_size参数。

### 3.2 query_cache_type

```sql_cache```意思是说，将查询结果放入查询缓存中。
```sql_no_cache```意思是查询的时候不缓存查询结果。
```sql_buffer_result```意思是说，在查询语句中，将查询结果缓存到临时表中。

这三者正好配套使用。```sql_buffer_result```将尽快释放表锁，这样其他sql就能够尽快执行。

使用 ```FLUSH QUERY CACHE``` 命令，你可以整理查询缓存，以更好的利用它的内存。这个命令不会从缓存中移除任何查询。```FLUSH TABLES``` 会转储清除查询缓存。
```RESET QUERY CACHE``` 使命从查询缓存中移除所有的查询结果。

那么mysql到底是怎么决定到底要不要把查询结果放到查询缓存中呢？

是根据```query_cache_type```这个变量来决定的。

这个变量有三个取值：0,1,2，分别代表了off、on、demand。
mysql默认为开启 on

意思是说，如果是0，那么query cache 是关闭的。
如果是1，那么查询总是先到查询缓存中查找，即使使用了sql_no_cache仍然查询缓存，因为sql_no_cache只是不缓存查询结果，而不是不使用查询结果。
```
select count(*) from innodb;
1 row in set (1.91 sec)
```
```
select sql_no_cache count(*) from innodb;
1 row in set (0.25 sec)
```
如果是2，DEMAND。
在my.ini中增加一行
query_cache_type=2
重启mysql服务

select count(*) from innodb;
1 row in set (1.56 sec)

select count(*) from innodb;
1 row in set (0.28 sec)
没有使用sql_cache,好像仍然使用了查询缓存

select sql_cache count(*) from innodb;
1 row in set (0.28 sec)
使用sql_cache查询时间也一样，因为sql_cache只是将查询结果放入缓存，没有使用sql_cache查询也会先到查询缓存中查找数据

结论：只要query_cache_type没有关闭，sql查询总是会使用查询缓存，如果缓存没有命中则开始查询的执行计划到表中查询数据。

query cache优缺点
优点很明显，对于一些频繁select query，mysql直接从cache中返回相应的结果集，而不用再从表table中取出，减少了IO开销。
即使query cache的收益很明显，但是也不能忽略它所带来的一些缺点：

query语句的hash计算和hash查找带来的资源消耗。mysql会对每条接收到的select类型的query进行hash计算然后查找该query的cache是否存在，虽然hash计算和查找的效率已经足够高了，一条query所带来的消耗可以忽略，但一旦涉及到高并发，有成千上万条query时，hash计算和查找所带来的开销就的重视了；
query cache的失效问题。如果表变更比较频繁，则会造成query cache的失效率非常高。表变更不仅仅指表中的数据发生变化，还包括结构或者索引的任何变化；
对于不同sql但同一结果集的query都会被缓存，这样便会造成内存资源的过渡消耗。sql的字符大小写、空格或者注释的不同，缓存都是认为是不同的sql（因为他们的hash值会不同）；
相关参数设置不合理会造成大量内存碎片，相关的参数设置会稍后介绍。
合理利用query cache
query cache有利有弊，合理的使用query cache可以使其发挥优势，并且有效的避开其劣势。

并不是所有表都适合使用query cache。造成query cache失效的原因主要是相应的table发生了变更，那么就应该避免在变化频繁的table上使用query cache。mysql中针对query cache有两个专用的sql hint：SQL_NO_CACHE和SQL_CACHE，分别表示强制不使用和强制使用query cache，通过强制不使用query cache，可以让mysql在频繁变化的表上不使用query cache，这样减少了内存开销，也减少了hash计算和查找的开销；
更多有关query cache详情文章，请看这里的原文：mysql query cache优化

### 3.3 query_cache_size

query_cache_size：指定用于缓存查询结果集的内存区大小，该参数值应为 1024 的整数倍。

这个参数不能太大，也不能太小，查询缓存至少会需要 40KB 的空间分配给其自身结构，太小时缓存结果集就没有意义，热点数据保存不了多少，而且总是很快就被刷新出去；但也不能太大，否则可能过多占用内存资源，影响整机性能，再说太大也没有意义，因为即便数据不被刷新，但只要源数据发生变更，缓存中的数据也就自动失效了，这种情况下分配多大都没有意义。个人建议设置不要超过 256MB。

### 3.4 query_cache_limit

query_cache_limit：用来控制查询缓存，能够缓存的单条 SQL 语句生成的最大结果集，默认是 1MB，超出的就不要进入查询缓存。这个大小对于很多场景都够了，缩小可以考虑，加大就不用了。

### 3.5 sort_buffer_size

sort_buffer_size：指定单个会话能够使用的排序区的大小，默认值为 256KB，建议设置为 1~4MB 之间。

### 3.6 read_buffer_size

read_buffer_size:指定随机读取时的数据缓存区大小，默认是 256KB，最大能够支持4GB，适当加大本参数，对于提升全表扫描的效率会有帮助。

## 4.InnoDB专用参数
### 4.1 innodb_buffer_pool_size

innodb_buffer_pool_size：指定InnoDB引擎专用的缓存区大小，用来缓存表对象的数据及索引信息，默认值为 128MB，最大能够支持（2^64 -1）B.

如果你有很多事务的更新，插入或删除很操作，通过修改innodb_buffer_pool 大小这个参数会大量的节省了磁盘I / O。

innodb_buffer_pool_size 是个全局参数，其所分配的缓存区将供所有被访问到的InnoDb表对象使用，若MySQL数据库中的表对象以 InnoDb 为主，那么本参数的值就越大越好，官方文档中建议，可以将该参数设置为服务器物理内存的70%~80%。

### 4.2 innodb_buffer_instances

innodb_buffer_instances：指定 InnoDB 缓存池分为多少个区域来使用，值得范围从 1~64，默认值为-1，表示由 InnoDB 自行调整。

只有当innodb_buffer_pool_size参数值大于1GB时，本参数才有效，那么本参数怎么设置呢？个人感觉可以参照 InnoDB 缓存池的大小，以 GB 为单位，每GB指定一个instances。例如当innodb_buffer_pool_size设置为16GB时，则指定 innodb_buffer_instances 设置为 16 即可。

## 5.参数优化案例
测试服务器有 16GB的物理内存，假定其峰值最大的连接数为 500 个，表对象使用InnoDB 存储引擎，我们的内存参数如何配置呢？

具体配置如下：
（1）、首先，为操作系统预留 20% 的内存，约为 3GB。
（2）、与线程相关的几个关键参数设置如下：

  sort_buffer_size=2m
  read_buffer_size=2m
  read_rnd_buffer_size=2m
  join_buffer_size=2m
预计连接数达到峰值时，线程预计最大将有可能占用 500 *（2+2+2+2）= 4GB内存（理论最大值）。

（3）、剩下的空间 16-3-4=9GB，就可以全部都分配给InnoDB 的缓存池，设定相关的参数如下：

innodb_buffer_pool_size=9g
innodb_thread_concurrency=8
innodb_flush_method=O_DIRECT
innodb_log_buffer_size=16m
innodb_flush_log_at_trx_commit=2
# 四、MySQL系统状态
想要了解MySQL服务当前在做什么，有个非常重要并且极为常用的命令：

SHOW [FULL] PROCESSLIST
SHOW PROCESSLIST 命令将每一个连接的线程，作为一条独立的记录输出。

还有相似的语句，
SHOW PROFILES 和 SHOW PROFILE可以获取会话执行语句过程中，资源的使用情况。