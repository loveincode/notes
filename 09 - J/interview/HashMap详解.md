JDK1.8对HashMap底层的实现进行了优化，例如引入红黑树的数据结构和扩容的优化等。

<img src ="img/640.webp">

### 简介

  Java为数据结构中的映射定义了一个接口java.util.Map

  1、`HashMap`：它根据键的hashCode值存储数据，大多数情况下可以直接定位到它的值，因而具有很快的访问速度。

  HashMap最多只允许一条记录的键为null，允许多条记录的值为null。非线程安全。

  如果需要满足线程安全，可以用 Collections的synchronizedMap方法使HashMap具有线程安全的能力，或者使用ConcurrentHashMap


  2、`Hashtable`：Hashtable是遗留类，很多映射的常用功能与HashMap类似，不同的是它承自Dictionary类。线程安全。并发性不如ConcurrentHashMap，因为ConcurrentHashMap引入了分段锁。



  3、`LinkedHashMap`：LinkedHashMap是HashMap的一个子类，保存了记录的插入顺序，在用Iterator遍历LinkedHashMap时，先得到的记录肯定是先插入的，也可以在构造时带参数，按照访问次序排序。



  4、`TreeMap`：TreeMaßp实现SortedMap接口，能够把它保存的记录根据键排序，默认是按键值的升序排序，也可以指定排序的比较器，当用Iterator遍历TreeMap时，得到的记录是排过序的。


  在使用TreeMap时，key必须实现Comparable接口或者在构造TreeMap传入自定义的Comparator，否则会在运行时抛出java.lang.ClassCastException类型的异常。


  `内部实现`

  （1） 存储结构-字段
  （2） 功能实现-方法

  存储结构-字段

  HashMap是数组+链表+红黑树（JDK1.8增加了红黑树部分）实现的。
  <img src ="img/640 (1).webp">
