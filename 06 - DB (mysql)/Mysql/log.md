set global general_log=on;
show global variables like "%genera%";


查看MySQL慢日志参数
show variables like '%slow_query%';
+---------------------------+----------------------------------------+
| Variable_name             | Value                                  |
+---------------------------+----------------------------------------+
| slow_query_log            | OFF                                    |
| slow_query_log_file       | /usr/local/mysql/data/cloudlu-slow.log |
+---------------------------+----------------------------------------+
这里告诉我们慢日志的日志存放位置，慢日志是否有开启。
在MySQL中，没有index的查询以及超过指定时间同时超过指定扫描行数的查询需要记录在慢日志查询里面。

show global variables like '%indexes%';
+----------------------------------------+-------+
| Variable_name                          | Value |
+----------------------------------------+-------+
| log_queries_not_using_indexes          | OFF   |
| log_throttle_queries_not_using_indexes | 0     |
+----------------------------------------+-------+
第一个参数表示是否开启记录没有index的查询，
第二个参数用来做日志记录的流量控制，一分钟可以记录多少条，默认0是表示不限制。

超过指定时长的查询开关
show global variables like '%long_query%';
+-----------------+-----------+
| Variable_name   | Value     |
+-----------------+-----------+
| long_query_time | 10.000000 |
+-----------------+-----------+
就一个参数指定超过多少时长的查询需要被记录

超过指定行数的扫描查询开关
show variables like  '%min_examined_row_limit%';
+------------------------+-------+
| Variable_name          | Value |
+------------------------+-------+
| min_examined_row_limit | 0     |
+------------------------+-------+
默认是0，代表不限制扫描行数

设置开启MySQL慢日志参数
set global long_query_time=0.1;
set global log_queries_not_using_indexes=on;
set global slow_query_log = on;

第一是超过什么时长的日志是有问题的，这个由系统需求来决定。
第二是没有使用indexes的日志每分钟要记录多少条，要防止日志太多对性能产生影响。
