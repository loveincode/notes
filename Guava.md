# Guava快速入门

Java诞生于1995年，在这20年的时间里Java已经成为世界上最流行的编程语言之一。虽然Java语言时常经历各种各样的吐槽，但它仍然是一门在不断发展、变化的语言——除了语言本身与JDK在不断的进化，第三方库、框架也同样是日新月异。Guava正是这样一个现代的库，它简单易用，对Java语言是一个非常好的补充，可以说只要你在使用Java语言开发任何项目都应该使用Guava。

## Guava简介

Java类库中有不少难用的典型，Collection一定是其中之一。Google最早提出Guava库，是对Java Collection进行扩展以提高开发效率。随着时间推移，它已经覆盖到了Java开发的方方面面，在Java 8中，已经可以看到不少API就是从Guava中原封不动的借鉴而来。接下来的几个例子比较了使用Guava和原生JDK的开发：

## 初始化集合

```java
//JDK
List<String> list = new ArrayList<String>(); 
list.add("a");
list.add("b");
list.add("c");
list.add("d");

//Guava
List<String> list = Lists.newArrayList("a", "b", "c", "d");
```

## 读取文件内容

```java
//JDK写法冗长，可以自行搜索

//Guava
List<String> lines = Files.readLines(file, Charsets.UTF_8);
```

## 集合新类型

Guava针对开发中的常见场景，提供了一些新的集合类型简化代码。

### Multiset

我们经常碰到一类统计需求——统计某个对象（常见的如字符串）在一个集合中的出现次数，那么会有如下代码：

```java
Map<String, Integer> counts = new HashMap<String, Integer>();
for (String word : words) {
    Integer count = counts.get(word);
    if (count == null) {
        counts.put(word, 1);
    } else {
        counts.put(word, count + 1);
    }
}
```
这段代码看起来有一点丑陋，并且容易出错。Guava提供了一种新的集合类型——Multiset。顾名思义，也就是Set中能够同时存在相同的元素:

```java
Multiset<String> multiset = HashMultiset.create();

multiset.add("a");
multiset.add("a");
multiset.add("b", 5);//add "b" 5 times

System.out.println(multiset.elementSet());//[a, b]
System.out.println(multiset.count("a"));//2
System.out.println(multiset.count("b"));//5
System.out.println(multiset.count("c"));//0
```
Multiset很像一个ArrayList，因为它允许重复元素，只不过它的元素之间没有顺序；同时它又具备Map<String, Integer>的某一些特性。但本质上它还是一个真正的集合类型——用来表达数学上“多重集合”的概念，这个例子只是恰好和Map对应上罢了。

## MultiMap

想必在开发的过程中你一定遇到过实现一个这样的集合：Map<K, List<V>> Map<K, Set<V>>用来表达某一个Key对应的元素是一个集合，可以用两种视角来看待这类集合：

```
a -> 1 a -> 2 a -> 4 b -> 3 c -> 5
```
另一种是：
```
a -> [1, 2, 4] b -> 3 c -> 5
```

如果使用JDK提供的Collection来实现类似功能，那么一定会有类似上一节中统计数量的代码：添加一个元素时，先在Map中查找该元素对应的List，如果不存在则新建一个List对象。
```java
Multimap<String, Integer> multimap = ArrayListMultimap.create();
multimap.put("a", 1);
multimap.put("a", 2);
multimap.put("a", 4);
multimap.put("b", 3);
multimap.put("c", 5);

System.out.println(multimap.keys());//[a x 3, b, c]
System.out.println(multimap.get("a"));//[1 ,2, 4]
System.out.println(multimap.get("b"));//[3]
System.out.println(multimap.get("c"));//[5]
System.out.println(multimap.get("d"));//[]

System.out.println(multimap.asMap());//{a=[1, 2, 4], b=[3], c=[5]}
```
## 集合工具类

静态创建方法

JDK 7以前，创建泛型集合会比较啰嗦：
```java
List<TypeThatsTooLongForItsOwnGood> list = new ArrayList<TypeThatsTooLongForItsOwnGood>();
```
Guava提供了静态方法来推断泛型的类型：
```java
List<TypeThatsTooLongForItsOwnGood> list = Lists.newArrayList();
Map<KeyType, LongishValueType> map = Maps.newLinkedHashMap();
```
当然在JDK 7里泛型的类型推断已经支持：
```java
List<TypeThatsTooLongForItsOwnGood> list = new ArrayList<>();
```
Guava除了提供静态构造方法，还提供了一系列工厂类方法来支持集合的创建：
```java
Set<Type> copySet = Sets.newHashSet(elements);
List<String> theseElements = Lists.newArrayList("alpha", "beta", "gamma");
```
## Sets
我们经常需要操作集合（Set），并对集合进行交并补差等运算，Sets类提供了这些方法：
```java
union(Set, Set)
intersection(Set, Set)
difference(Set, Set)
symmetricDifference(Set, Set)
Set<String> wordsWithPrimeLength = ImmutableSet.of("one", "two", "three", "six", "seven", "eight");
Set<String> primes = ImmutableSet.of("two", "three", "five", "seven");

SetView<String> intersection = Sets.intersection(primes, wordsWithPrimeLength); // contains "two", "three", "seven"
// I can use intersection as a Set directly, but copying it can be more efficient if I use it a lot.
return intersection.immutableCopy();
```
## Primitives

Java中的基本类型(Primitive)包括：byte, short, int, long, float, double, char, boolean。

在Guava中与之对应的一些工具类包括Bytes, Shorts, Ints, Longs, Floats, Doubles, Chars, Booleans。现在以Ints为例示范一些常用方法：
```java
System.out.println(Ints.asList(1,2,3,4));
System.out.println(Ints.compare(1, 2));
System.out.println(Ints.join(" ", 1, 2, 3, 4));
System.out.println(Ints.max(1, 3, 5 ,4, 6));
System.out.println(Ints.tryParse("1234"));
```
## Hashing

编写一个Hash散列算法在Java中比较繁复，但是在Guava里却非常简单：
```java
public static String md5(String str) {
    return Hashing.md5().newHasher()
            .putString(str, Charsets.UTF_8)
            .hash()
            .toString();
}
```
更多Hash算法以及其中的一些概念对象请参考HashingExplained

## 总结

Guava是一个非常有用的现代程序库，在Java项目中强烈推荐使用它来取代Apache Commons的一些子项目（例如Lang, Collection, IO等等），除了这里介绍的一些最常用的特性，它还包括缓存、网络、IO、函数式编程等等内容（其中函数式编程在Java 8中可以使用Stream和Lambda表达式等特性来实现）。它的参考文档应该是Java程序员手头必备之物。
