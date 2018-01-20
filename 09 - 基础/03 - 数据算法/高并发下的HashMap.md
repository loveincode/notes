HashMap的容量是有限的。当经过多次元素插入，使得HashMap达到一定饱和度时，Key映射位置发生冲突的几率会逐渐提高。



这时候，HashMap需要扩展它的长度，也就是进行Resize。

影响发生Resize的因素有两个：

1. Capacity
	
HashMap的当前长度。上一期曾经说过，HashMap的长度是2的幂。

2. LoadFactor
	
HashMap负载因子，默认值为0.75f。

衡量HashMap是否进行Resize的条件如下：

```HashMap.Size   >=  Capacity * LoadFactor```

Resize:

1. 扩容

创建一个新的Entry空数组，长度是原数组的2倍。

2. ReHash

遍历原Entry数组，把所有的Entry重新Hash到新数组。为什么要重新Hash呢？因为长度扩大以后，Hash的规则也随之改变。

让我们回顾一下Hash公式：
```index =  HashCode（Key） &  （Length - 1） ```

当原数组长度为8时，Hash运算是和111B做与运算；新数组长度为16，Hash运算是和1111B做与运算。Hash结果显然不同。

ReHash的Java代码如下：

``` java

/**
 * Transfers all entries from current table to newTable.
 */
void transfer(Entry[] newTable, boolean rehash) {
    int newCapacity = newTable.length;
    for (Entry<K,V> e : table) {
        while(null != e) {
            Entry<K,V> next = e.next;
            if (rehash) {
                e.hash = null == e.key ? 0 : hash(e.key);
            }
            int i = indexFor(e.hash, newCapacity);
            e.next = newTable[i];
            newTable[i] = e;
            e = next;
        }
    }
}

```

HashMap是非线程安全的

问题栗子：
假设一个HashMap已经到了Resize的临界点。此时有两个线程A和B，在同一时刻对HashMap进行Put操作：

环形链表，所以程序将会进入死循环

避免线程安全问题：
使用集合类 ： ConcurrentHashMap


