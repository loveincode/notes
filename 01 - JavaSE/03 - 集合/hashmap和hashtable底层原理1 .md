hashmap http://zhangshixi.iteye.com/blog/672697
hashmap http://www.admin10000.com/document/3322.html
hashtable http://www.cnblogs.com/skywang12345/p/3310887.html
http://blog.csdn.net/chdjj/article/details/38581035

# HashMap
## 1. HashMap的存取实现：
``` java
public V put(K key, V value) {  
    // HashMap允许存放null键和null值。  
    // 当key为null时，调用putForNullKey方法，将value放置在数组第一个位置。  
    if (key == null)  
        return putForNullKey(value);  
    // 根据key的keyCode重新计算hash值。  
    int hash = hash(key.hashCode());  
    // 搜索指定hash值在对应table中的索引。  
    int i = indexFor(hash, table.length);  
    // 如果 i 索引处的 Entry 不为 null，通过循环不断遍历 e 元素的下一个元素。  
    for (Entry<K,V> e = table[i]; e != null; e = e.next) {  
        Object k;  
        if (e.hash == hash && ((k = e.key) == key || key.equals(k))) {  
            V oldValue = e.value;  
            e.value = value;  
            e.recordAccess(this);  
            return oldValue;  
        }  
    }  
    // 如果i索引处的Entry为null，表明此处还没有Entry。  
    modCount++;  
    // 将key、value添加到i索引处。  
    addEntry(hash, key, value, i);  
    return null;  
}  
```
``` java
void addEntry(int hash, K key, V value, int bucketIndex) {  
    // 获取指定 bucketIndex 索引处的 Entry   
    Entry<K,V> e = table[bucketIndex];  
    // 将新创建的 Entry 放入 bucketIndex 索引处，并让新的 Entry 指向原来的 Entry  
    table[bucketIndex] = new Entry<K,V>(hash, key, value, e);  
    // 如果 Map 中的 key-value 对的数量超过了极限  
    if (size++ >= threshold)  
    // 把 table 对象的长度扩充到原来的2倍。  
        resize(2 * table.length);  
}
```

## 2. 读取：
``` java
public V get(Object key) {  
    if (key == null)  
        return getForNullKey();  
    int hash = hash(key.hashCode());  
    for (Entry<K,V> e = table[indexFor(hash, table.length)];  
        e != null;  
        e = e.next) {  
        Object k;  
        if (e.hash == hash && ((k = e.key) == key || key.equals(k)))  
            return e.value;  
    }  
    return null;  
}  
```

## 3. 归纳起来简单地说
  HashMap 在底层将 key-value 当成一个整体进行处理，这个整体就是一个 Entry 对象。HashMap 底层采用一个 Entry[] 数组来保存所有的 key-value 对，当需要存储一个 Entry 对象时，会根据hash算法来决定其在数组中的存储位置，在根据equals方法决定其在该数组位置上的链表中的存储位置；当需要取出一个Entry时，也会根据hash算法找到其在数组中的存储位置，再根据equals方法从该位置上的链表中取出该Entry。

## 4. HashMap的resize（rehash）：
  当HashMap中的元素个数超过数组大小*loadFactor时，就会进行数组扩容，loadFactor的默认值为0.75，这是一个折中的取值。也就是说，默认情况下，数组大小为16，那么当HashMap中元素个数超过16*0.75=12的时候，就把数组的大小扩展为 2*16=32，即扩大一倍，然后重新计算每个元素在数组中的位置，而这是一个非常消耗性能的操作，所以如果我们已经预知HashMap中元素的个数，那么预设元素的个数能够有效的提高HashMap的性能。

## 5. HashMap的性能参数：

   HashMap 包含如下几个构造器：
   **HashMap()**：构建一个初始容量为 16，负载因子为 0.75 的 HashMap。
   **HashMap(int initialCapacity)**：构建一个初始容量为 initialCapacity，负载因子为 0.75 的 HashMap。
   **HashMap(int initialCapacity, float loadFactor)**：以指定初始容量、指定的负载因子创建一个 HashMap。
   HashMap的基础构造器HashMap(int initialCapacity, float loadFactor)带有两个参数，它们是初始容量initialCapacity和加载因子loadFactor。
   initialCapacity：HashMap的最大容量，即为底层数组的长度。
   loadFactor：负载因子loadFactor定义为：散列表的实际元素数目(n)/ 散列表的容量(m)。
   负载因子衡量的是一个散列表的空间的使用程度，负载因子越大表示散列表的装填程度越高，反之愈小。对于使用链表法的散列表来说，查找一个元素的平均时间是O(1+a)，因此如果负载因子越大，对空间的利用更充分，然而后果是查找效率的降低；如果负载因子太小，那么散列表的数据将过于稀疏，对空间造成严重浪费。
   HashMap的实现中，通过threshold字段来判断HashMap的最大容量：
   ``` java
      threshold = (int)(capacity * loadFactor);  
   ```
   结合负载因子的定义公式可知，threshold就是在此loadFactor和capacity对应下允许的最大元素数目，超过这个数目就重新resize，以降低实际的负载因子。默认的的负载因子0.75是对空间和时间效率的一个平衡选择。当容量超出此最大容量时， resize后的HashMap容量是容量的两倍：
   ``` java
    if (size++ >= threshold)     
        resize(2 * table.length);
   ```
## 6. Fail-Fast机制：
  我们知道java.util.HashMap不是线程安全的，因此如果在使用迭代器的过程中有其他线程修改了map，那么将抛出ConcurrentModificationException，这就是所谓fail-fast策略。
  这一策略在源码中的实现是通过modCount域，modCount顾名思义就是修改次数，对HashMap内容的修改都将增加这个值，那么在迭代器初始化过程中会将这个值赋给迭代器的expectedModCount。
  ``` java
  HashIterator() {  
      expectedModCount = modCount;  
      if (size > 0) { // advance to first entry  
      Entry[] t = table;  
      while (index < t.length && (next = t[index++]) == null)  
          ;  
      }  
  }  
  ```
  在迭代过程中，判断modCount跟expectedModCount是否相等，如果不相等就表示已经有其他线程修改了Map：

  注意到modCount声明为volatile，保证线程之间修改的可见性。
  ```java
  final Entry<K,V> nextEntry() {     
    if (modCount != expectedModCount)     
        throw new ConcurrentModificationException();  
  ```
  在HashMap的API中指出：

  由所有HashMap类的“collection 视图方法”所返回的迭代器都是快速失败的：在迭代器创建之后，如果从结构上对映射进行修改，除非通过迭代器本身的 remove 方法，其他任何时间任何方式的修改，迭代器都将抛出 ConcurrentModificationException。因此，面对并发的修改，迭代器很快就会完全失败，而不冒在将来不确定的时间发生任意不确定行为的风险。

  注意，迭代器的快速失败行为不能得到保证，一般来说，存在非同步的并发修改时，不可能作出任何坚决的保证。快速失败迭代器尽最大努力抛出 ConcurrentModificationException。因此，编写依赖于此异常的程序的做法是错误的，正确做法是：迭代器的快速失败行为应该仅用于检测程序错误。
