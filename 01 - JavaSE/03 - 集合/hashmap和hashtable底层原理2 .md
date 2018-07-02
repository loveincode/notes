
和HashMap一样，Hashtable 也是一个散列表，它存储的内容是键值对(key-value)映射。
Hashtable 继承于Dictionary，实现了Map、Cloneable、java.io.Serializable接口。
Hashtable 的函数都是 **同步** 的，这意味着它是 **线程安全** 的。它的 **key、value都不可以为null**。此外，Hashtable中的映射不是有序的。

Hashtable 的实例有两个参数影响其性能：**初始容量** 和 **加载因子**。容量 是哈希表中桶 的数量，初始容量 就是哈希表创建时的容量。注意，哈希表的状态为 open：在发生“哈希冲突”的情况下，单个桶会存储多个条目，这些条目必须按顺序搜索。加载因子 是对哈希表在其容量自动增加之前可以达到多满的一个尺度。初始容量和加载因子这两个参数只是对该实现的提示。关于何时以及是否调用 rehash 方法的具体细节则依赖于该实现。
通常，默认加载因子是 0.75, 这是在时间和空间成本上寻求一种折衷。加载因子过高虽然减少了空间开销，但同时也增加了查找某个条目的时间（在大多数 Hashtable 操作中，包括 get 和 put 操作，都反映了这一点）。

modCount++;

```java
public synchronized V put(K key, V value) {
    // Hashtable中不能插入value为null的元素！！！
    if (value == null) {
        throw new NullPointerException();
    }
    // 若“Hashtable中已存在键为key的键值对”，
    // 则用“新的value”替换“旧的value”
    Entry tab[] = table;
    int hash = key.hashCode();
    int index = (hash & 0x7FFFFFFF) % tab.length;
    for (Entry<K,V> e = tab[index] ; e != null ; e = e.next) {
        if ((e.hash == hash) && e.key.equals(key)) {
            V old = e.value;
            e.value = value;
            return old;
            }
    }

    // 若“Hashtable中不存在键为key的键值对”，
    // (01) 将“修改统计数”+1
    modCount++;
    // (02) 若“Hashtable实际容量” > “阈值”(阈值=总的容量 * 加载因子)
    //  则调整Hashtable的大小
    if (count >= threshold) {
        // Rehash the table if the threshold is exceeded
        rehash();

        tab = table;
        index = (hash & 0x7FFFFFFF) % tab.length;
    }

    // (03) 将“Hashtable中index”位置的Entry(链表)保存到e中
    Entry<K,V> e = tab[index];
    // (04) 创建“新的Entry节点”，并将“新的Entry”插入“Hashtable的index位置”，并设置e为“新的Entry”的下一个元素(即“新Entry”为链表表头)。        
    tab[index] = new Entry<K,V>(hash, key, value, e);
    // (05) 将“Hashtable的实际容量”+1
    count++;
    return null;
}
```
