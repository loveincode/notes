## 1. HashMap

`Hash`散列将一个任意的长度通过某种(hash函数算法)算法换成一个固定值。

移位

`Map`:地图x,y存储

`总结`：通过`Hash`出来的值，然后通过值定位到这个map然后value存储到这个map中。

key value

key可以为null，Null当成一个key来存储

key相同 ，value会覆盖。

Hashmap 什么时候做扩容？ Put的时候，达到3/4的时候，扩容2的倍数

hashMap table： 数组 + 链表 数据结构


## 2. 源码分析

初始化参数介绍

put方法分析

get方法分析

entry 对象介绍

扩容源码分析


初始化容量 	1左移4位 16容量
DEFAULT_INITIAL_CAPACITY = 1 << 4;

最大的容量  1左移30位
MAXIMUM_CAOACITY = 1 << 30;

加载因子系数 1分成四等分 0.25 0.25*3 =0.75 在容量的3/4的时候 扩容。
DEFAULT_LOAD_FACTOR = 0.75f;

扩容变量
threshold

Put 重复返回 不重复 返回Null

Get

## 3. 手写实现

定义接口map

实现类 hashmap

## 4. 不足之处

key是否重复有关 get(0)
伸缩性

时间复杂度
