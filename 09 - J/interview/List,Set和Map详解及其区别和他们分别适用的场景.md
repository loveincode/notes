Java中的集合包括三大类，它们是Set（集）、List（列表）和Map（映射），它们都处于java.util包中，Set、List和Map都是接口，它们有各自的实现类。Set的实现类主要有HashSet和TreeSet，List的实现类主要有ArrayList，Map的实现类主要有HashMap和TreeMap。

  Collection是最基本的集合接口，声明了适用于JAVA集合的通用方法，list和set都继承自collection接口。



Collection接口的方法

boolean add(Object o)：向集合中加入一个对象的引用
void clear()：删除集合中所有的对象，即不再持有这些对象的引用
boolean isEmpty() ：判断集合是否为空
boolean contains(Object o)：判断集合中是否持有特定对象的引用
Iterartor iterator() ：返回一个Iterator对象，可以用来遍历集合中的元素
boolean remove(Object o) ：从集合中删除一个对象的引用
int size()：返回集合中元素的数目
Object[] toArray()：返回一个数组，该数组中包括集合中的所有元素
  Iterator() 和toArray() 方法都用于集合的所有的元素，前者返回一个Iterator对象，后者返回一个包含集合中所有元素的数组。
  Collection没有get()方法来取得某个元素。只能通过iterator()遍历元素。


Iterator接口声明了如下方法
hasNext()：判断集合中元素是否遍历完毕，如果没有，就返回true
next() ：返回下一个元素
remove()：从集合中删除上一个有next()方法返回的元素。
Set： Set是最简单的一种集合。集合中的对象不按特定的方式排序，并且没有重复对象。

Set接口主要实现了两个实现类：
HashSet： HashSet类按照哈希算法来存取集合中的对象，存取速度比较快
TreeSet ：TreeSet类实现了SortedSet接口，能够对集合中的对象进行排序。



List的功能方法

实际上有两种List：

  一种是基本的ArrayList,其优点在于随机访问元素；

  另一种是更强大的LinkedList,它并不是为快速随机访问设计的，而是具有一套更通用的方法。
  List：次序是List最重要的特点：它保证维护元素特定的顺序。List为Collection添加了许多方法，使得能够向List中间插入与移除元素(这只推 荐LinkedList使用。)一个List可以生成ListIterator,使用它可以从两个方向遍历List,也可以从List中间插入和移除元素。
  ArrayList：由数组实现的List。允许对元素进行快速随机访问，但是向List中间插入与移除元素的速度很慢。ListIterator只应该用来由后向前遍历 ArrayList,而不是用来插入和移除元素。因为那比LinkedList开销要大很多。
  LinkedList ：对顺序访问进行了优化，向List中间插入与删除的开销并不大。随机访问则相对较慢。(使用ArrayList代替。)还具有下列方 法：addFirst(), addLast(), getFirst(), getLast(), removeFirst() 和 removeLast(), 这些方法 (没有在任何接口或基类中定义过)使得LinkedList可以当作堆栈、队列和双向队列使用。



Set的功能方法
  Set具有与Collection完全一样的接口，因此没有任何额外的功能。实际上Set就是Collection,只 是行为不同。

  这是继承与多态思想的典型应用：表现不同的行为。Set不保存重复的元素(至于如何判断元素相同则较为复杂)
  Set : 存入Set的每个元素都必须是唯一的，因为Set不保存重复元素。加入Set的元素必须定义equals()方法以确保对象的唯一性。Set与Collection有完全一样的接口。Set接口不保证维护元素的次序。
  HashSet：为快速查找设计的Set。存入HashSet的对象必须定义hashCode()。
  TreeSet： 保存次序的Set, 底层为树结构。使用它可以从Set中提取有序的序列。
  LinkedHashSet：具有HashSet的查询速度，且内部使用链表维护元素的顺序(插入的次序)。于是在使用迭代器遍历Set时，结果会按元素插入的次序显示。



Map的功能方法
  方法put(Object key, Object value)添加一个“值”(想要得东西)和与“值”相关联的“键”(key)(使用它来查找)。

  方法get(Object key)返回与给定“键”相关联的“值”。可以用containsKey()和containsValue()测试Map中是否包含某个“键”或“值”。

   标准的Java类库中包含了几种不同的Map：HashMap, TreeMap, LinkedHashMap, WeakHashMap, IdentityHashMap。它们都有同样的基本接口Map，但是行为、效率、排序策略、保存对象的生命周期和判定“键”等价的策略等各不相同。
  执行效率是Map的一个大问题。看看get()要做哪些事，就会明白为什么在ArrayList中搜索“键”是相当慢的。而这正是HashMap提高速 度的地方。HashMap使用了特殊的值，称为“散列码”(hash code)，来取代对键的缓慢搜索。“散列码”是“相对唯一”用以代表对象的int值，它是通过将该对象的某些信息进行转换而生成的。所有Java对象都 能产生散列码，因为hashCode()是定义在基类Object中的方法。
  HashMap就是使用对象的hashCode()进行快速查询的。此方法能够显着提高性能。
  Map : 维护“键值对”的关联性，使你可以通过“键”查找“值”
  HashMap：Map基于散列表的实现。插入和查询“键值对”的开销是固定的。可以通过构造器设置容量capacity和负载因子load factor，以调整容器的性能。
  LinkedHashMap： 类似于HashMap，但是迭代遍历它时，取得“键值对”的顺序是其插入次序，或者是最近最少使用(LRU)的次序。只比HashMap慢一点。而在迭代访问时发而更快，因为它使用链表维护内部次序。
  TreeMap ： 基于红黑树数据结构的实现。查看“键”或“键值对”时，它们会被排序(次序由Comparabel或Comparator决定)。TreeMap的特点在 于，你得到的结果是经过排序的。TreeMap是唯一的带有subMap()方法的Map，它可以返回一个子树。
  WeakHashMap ：弱键(weak key)Map，Map中使用的对象也被允许释放: 这是为解决特殊问题设计的。如果没有map之外的引用指向某个“键”，则此“键”可以被垃圾收集器回收。
  IdentifyHashMap： : 使用==代替equals()对“键”作比较的hash map。专为解决特殊问题而设计。



list与Set、Map区别及适用场景
1、List,Set都是继承自Collection接口，Map则不是
2、List特点：元素有放入顺序，元素可重复 ，Set特点：元素无放入顺序，元素不可重复，重复元素会覆盖掉，（注意：元素虽然无放入顺序，但是元素在set中的位置是有该元素的HashCode决定的，其位置其实是固定的，加入Set 的Object必须定义equals()方法 ，另外list支持for循环，也就是通过下标来遍历，也可以用迭代器，但是set只能用迭代，因为他无序，无法用下标来取得想要的值。）
3.Set和List对比：
Set：检索元素效率低下，删除和插入效率高，插入和删除不会引起元素位置改变。
List：和数组类似，List可以动态增长，查找元素效率高，插入删除元素效率低，因为会引起其他元素位置改变。
4.Map适合储存键值对的数据

5.线程安全集合类与非线程安全集合类 ：
LinkedList、ArrayList、HashSet是非线程安全的，Vector是线程安全的;
HashMap是非线程安全的，HashTable是线程安全的;
StringBuilder是非线程安全的，StringBuffer是线程安全的。

ArrayList与LinkedList的区别和适用场景
Arraylist：
  优点：ArrayList是实现了基于动态数组的数据结构,因为地址连续，一旦数据存储好了，查询操作效率会比较高（在内存里是连着放的）。
  缺点：因为地址连续， ArrayList要移动数据,所以插入和删除操作效率比较低。  
LinkedList：
  优点：LinkedList基于链表的数据结构,地址是任意的，所以在开辟内存空间的时候不需要等一个连续的地址，对于新增和删除操作add和remove，LinedList比较占优势。LinkedList 适用于要头尾操作或插入指定位置的场景
  缺点：因为LinkedList要移动指针,所以查询操作性能比较低。
适用场景分析：
  当需要对数据进行对此访问的情况下选用ArrayList，当需要对数据进行多次增加删除修改时采用LinkedList。

ArrayList与Vector的区别和适用场景
ArrayList和Vector都是用数组实现的，主要区别：

  1.Vector是多线程安全的，线程安全就是说多线程访问同一代码，不会产生不确定的结果。而ArrayList不是，这个可以从源码中看出，Vector类中的方法很多有synchronized进行修饰，这样就导致了Vector在效率上无法与ArrayList相比;

  2.两个都是采用的线性连续空间存储元素，但是当空间不足的时候，两个类的增加方式是不同。
  3.Vector可以设置增长因子，而ArrayList不可以。
  4.Vector是一种老的动态数组，是线程同步的，效率很低，一般不赞成使用。
适用场景分析：
  1.Vector是线程同步的，所以它也是线程安全的，而ArrayList是线程异步的，是不安全的。如果不考虑到线程的安全因素，一般用ArrayList效率比较高。
  2.如果集合中的元素的数目大于目前集合数组的长度时，在集合中使用数据量比较大的数据，用Vector有一定的优势。

HashSet与Treeset的适用场景
  1.TreeSet 是二差树（红黑树的树据结构）实现的,Treeset中的数据是自动排好序的，不允许放入null值
  2.HashSet 是哈希表实现的,HashSet中的数据是无序的，可以放入null，但只能放入一个null，两者中的值都不能重复，就如数据库中唯一约束
  3.HashSet要求放入的对象必须实现HashCode()方法，放入的对象，是以hashcode码作为标识的，而具有相同内容的String对象，hashcode是一样，所以放入的内容不能重复。但是同一个类的对象可以放入不同的实例。
适用场景分析：

  HashSet是基于Hash算法实现的，其性能通常都优于TreeSet。为快速查找而设计的Set，我们通常都应该使用HashSet，在我们需要排序的功能时，我们才使用TreeSet。

HashMap与TreeMap、HashTable的区别及适用场景
  HashMap 非线程安全  
  HashMap：基于哈希表实现。使用HashMap要求添加的键类明确定义了hashCode()和equals()[可以重写hashCode()和equals()]，为了优化HashMap空间的使用，您可以调优初始容量和负载因子。
  TreeMap：非线程安全基于红黑树实现。TreeMap没有调优选项，因为该树总处于平衡状态。
适用场景分析：
  HashMap和HashTable:HashMap去掉了HashTable的contains方法，但是加上了containsValue()和containsKey()方法。

  HashTable同步的，而HashMap是非同步的，效率上比HashTable要高。                    HashMap允许空键值，而HashTable不允许。
  HashMap：适用于Map中插入、删除和定位元素。
  Treemap：适用于按自然顺序或自定义顺序遍历键(key)。
