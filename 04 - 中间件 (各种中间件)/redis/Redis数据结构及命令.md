Redis是远程字典服务器，字典的值所支持的数据类型：

1. 字符串类型
2. 散列类型
3. 列表类型
4. 集合类型
5. 有序集合类型

[http://www.redis.net.cn/order/](http://www.redis.net.cn/order/)
### Redis命令

```dbsize```：获取redis中键的总数
redis提供了多个用来存储数据的字典，一个字典相当于传统数据库系统一个数据库实例中可以创建多个数据库类型。redis默认支持16个数据库，也就是说16个字典，这个数值是可以配置的。默认客户端自动选择0号数据库。数据库之间不是完全隔离的，Flushall会清空redis实例中所有数据库。

```select```：用于切换数据库 如：select 1 表示切换到1号数据库。

```keys```：获取符合规则的键名列表，支持通配符，不支持正则表达式。出于性能考虑一般很少在生产环境使用。

	？匹配一个字符
	* 匹配任意字符（包括0）
	[] 区间，比如a[b-d]可以匹配ab,ac,ad
	\x 转义字符，比如匹配？可以使用 ?

### 1. 字符串类型
	
	当存储的字符串类型是整数形式时，可以对其进行递增操作，
	比如：set age 1，incr age，返回递增后的值，递增操作是原子操作。

```set```：设置字符串值，比如：set name liu，表示键为name，值为liu

```get```：获取键值，比如：get name

```exists```：判断是否存在某键，比如：exists name，存在返回1，不存在返回0

```del```：删除键，比如：del name，一次可以删除多个键，比如：del name age ，成功删除返回1，如果删除时该键不存在，那么返回0

```type```：获取键对应值的数据类型，比如：type name ，返回string，如果是：lpush bar 1，type bar 返回list。

```incrby```：增加指定的整数，比如：incrby age 10，表示在当前值上加10，与之对应的递减的两个命令是：

```decr```：递减

```decrby```：减少指定整数

```incrbyfloat```：增加指定浮点数

```append```：向尾部追加值，append name zhijun，返回追加后字符串的长度，这个命令尽作用与字符串类型

```strlen```：获取字符串长度

```mset```：一次设置多个键值，比如：mset name liu age 2

```mget```：一次获取多个键的值，比如：mget name get

以上命令都是针对字符串类型的值进行操作的命令，接下来是hash类型的值的命令。

### 2. hash类型，散列类型，字典类型

	hash类型是以键值对的形式存在的，而且hash类型的的值只能是字符串，不能再嵌套其他类型
	redis所有的数据类型都遵循此规则。

```hset```：赋值，比如：hset person name liu，key是person，value是{name:liu}。

```hget```：获取值，比如：hget person name，必须指定hash类型的键名，比如前面的name

```hmset```：多个字段赋值，比如：hmset person name liu age 10

```hmget```：获取多个字段的值，比如：hmget person name age

```hgetall```：获取hash的键值对，比如：hgetall person，这里就不需要指定hash的键名了。

```hexists```：判断字段是否存在，比如：hexists person name，表示是否有name字段。

```hincrby```：递增字段值，如果是数值类型的字符串的话，比如：hincrby person age 20

```hdel```：删除字段，hdel person name

```hkeys```：只获取字段名 hkeys person

```hvals```：只获取字段值 hvals person

```hlen```：获取有多少个字段，hlen person 以上这些命令的基本规律就是在字符串类型的命令上加个H

### 3. 列表类型 
	
	列表类型是一个双向链表实现的，越接近链表两端的元素获取速度越快，
	因此非常适合做TimeLine的实现。
	还可以做队列使用。 
	但是列表在数据量非常大的时候获取中间元素时效率不高。

```lpush```：向列表的左边添加元素，返回列表的长度，比如：lpush names zhangsan lisi wangwu，一次可以添加多个元素。注意：字典的key对应的键值的类型不能随意变更，比如：set name zhang，不能再使用lpush name zhang li。

```rpush```：向列表右边添加元素

```lpop```：从列表左边取出元素，先移除列表中的元素，在返回该元素

```rpop```：从列表右边取出元素，先移除列表中的元素，在返回该元素

```llen```：获取列表长度

```lrange```：分片操作，获取列表的片段，语法：lrange key start stop，元素包括stop位置的，与python稍有不一样。比如：lrange names 0 2，会获取三个元素，-1表示最后一个元素，获取所有就可以使用lrange names 0 -1。

```lram```：删除列表中指定值，语法：lram key count value，删除列表中前count个值为value的元素，返回删除元素的个数。

```count>0```：从列表左边开始删除前count个值为value的元素。

```count<0```：从列表右边开始往左删除前-count个值为value的元素，比如：lrem names -1 li，表示从右边开始删除1个值为li的元素。

```count=0```：删除所有值为value的元素

```lindex```：获取指定索引位置的元素，语法：lindex key index，也可以使用lrange实现此功能。

```lset```：设置指定索引位置的值，语法：lset key index value。注意这里是替换索引位置的值，如果索引不存在是没法操作的。

```ltrim```：只保留列表指定范围内的元素，语法：ltrim key start end。此操作是对列表进行修改.

### 4. 集合类型 
	
	集合类型在Redis内部是用值为空的散列表实现的。集合之间可以进行交集、并集、差集操作。

```sadd```：向集合中添加一个或多个元素，如果键不存在则自动创建，语法：sadd key member1 member2 ...例如：sadd tags python java c++

```srem```：删除集合中的某些元素，语法：srem key member1 member2...，例如：srem tags python java

```smemebers```：获取集合中所有元素 smembers tags

```sismember```：判断元素是否在集合中 sismembers tags python，时间复杂度为O(1)。

```sdiff```：多个集合的差集运算，语法：sdiff key1 key2

```sinter```：交集运算

```sunion```：并集运算

```scard```：获取元素个数

### 5. 有序集合类型 
	
	有序集合的每个元素都有一个分数，它不仅有插入、删除、是否存在元素的操作外
	还支持获取得分最高或最低的前N个元素、获取指定分数范围内的元素。

```zadd``` 添加，如果值存在添加，将会重新排序。

```zcard``` 查看zset集合的成员个数。zcard

127.0.0.1:6379>zcard myZSet   ---输出zset的成员个数为3

3、查看Zset指定范围的成员，withscores为输出结果带分数。zrange

127.0.0.1:6379>zrange mZySet 0 -1   ----0为开始，-1为结束，输出顺序结果为： zlh tom jim

127.0.0.1:6379>zrange mZySet 0 -1 withscores   ---输出带分数的结果为：zlh 1 tom 2 jim 3

4、获取zset成员的下标位置，如果值不存在返回null。zrank

127.0.0.1:6379>zrank mZySet Jim    ---Jim的在zset集合中的下标为2

5、获取zset集合指定分数之间存在的成员个数。zcount

127.0.0.1:6379>zcount mySet 1 3   ---输出分数>=1 and 分数 <=3的成员个数为3，因为分数是可以重复的，所以这个命令是有道理的。

6、删除指定的一个成员或多个成员。zrem

127.0.0.1:6379>zrem myZSet zlh   --删除值为zlh的zset成员

127.0.0.1:6379>zrem myZSet Tom Jim    ---删除值为Tom和Jim的两个zset成员

7、获取指定值的分数。zscore

127.0.0.1:6379>zadd myZset 1 zlh 1 tom 2 jim 3 xdd 4 pmm   ---由于上面的数据被删除完了，这里添加5条示范数据再。

127.0.0.1:6379>zscore myZset zlh    ---输出值为zlh的分数为1

8、给指定元素的分数进行增减操作，负值为减，正值为加。zincrby

127.0.0.1:6379>zscore myZset tom    ----输出tom的分数为1

127.0.0.1:6379>zincrby myZset 4 tom   ---tom的分数值加4，输入分数值为5

127.0.0.1:6379>zscore myZset tom    ---输出tom的分数值为5

9、根据指定分数的范围获取值。zrangebysocre

127.0.0.1:6379>zrangebyscore myZset  1 5   ---输出分数>=1 and <=5的成员值为：zlh jim xdd pmm  tom

127.0.0.1:6379>zrangebyscore myZset  (1 5    ----输出分数>1 and <=5的成员值为：jim xdd pmm tom

127.0.0.1:6379>zrangebyscore myZset 2 5 limit 1 2    ---检索分数为2到5之间的数据，然后从下标为1的数据开始往后输出2个数据，包含下标为1的数据。结果为：xdd pmm

127.0.0.1:6379>zrangebyscore myZset -inf +inf limit 2 3   ----+inf表示最后一个成员，-inf表示第一个成员，意思是：检索所有数据，然后从下标为2的数据开始再往后输出2个数据。结果为：xdd pmm tom

10、倒序，从高到底排序输出指定范围的数据。zrevrange，zrevrangebyscore

127.0.0.1:6379>zrevrange myZset 2 3   ---先倒序排列数据，输出下标为>=2 and <=3的数据为xdd jim，这里注意的是倒序之后下标也反过来了。

127.0.0.1:6379>zrevrange myZset 2 4 withscores    ---输出结果为：xdd 3 jim 2 zlh 1

127.0.0.1:6379>zrevrangebyscore myZset 5 1 limit  3 2  ----输出结果为：jim zlh 。获取score <=5 and >=1，从下标为为3开始获取2条数据。

127.0.0.1:6379>zrevrangebyscore myZset 4 2   ----分数>=2 and <=4 的数据倒序输出：pmm xdd jim

11、根据坐标，分数范围删除数据。zremrangebyscore，zremrangebyrank

127.0.0.1:6379>zremrangebyscore myZset 1 2   ---删除分数>=1 and <=2的数据

127.0.0.1:6379>zrange myZset 0 -1    ----输出结果为 xdd pmm tom

127.0.0.1:6379>zremrangebyrank myZset 0 2    ---删除下标>=0 and <=2的zset元素

127.0.0.1:6379>zrange myZset 0 -1    --输出结果为：empty list or set 。没数据啦。