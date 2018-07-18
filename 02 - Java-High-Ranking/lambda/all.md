http://www.importnew.com/15873.html
http://www.runoob.com/java/java8-lambda-expressions.html
Lambda表达式`只能针对函数式接口使用`。(**函数式接口是只包含一个方法的接口。**)

## Java为何需要Lambda
1996年1月，Java 1.0发布了，此后计算机编程领域发生了翻天覆地的变化。商业发展需要更复杂的应用，大多数程序都跑在更强大的装备多核CPU的机器上。带有高效运行期编译器的Java虚拟机（JVM）的出现，使得程序员将精力更多放在编写干净、易于维护的代码上，而不是思考如何将每一个CPU时钟、每一字节内存物尽其用。

多核CPU的出现成了“房间里的大象”，无法忽视却没人愿意正视。算法中引入锁不但容易出错，而且消耗时间。人们开发了java.util.concurrent包和很多第三方类库，试图将并发抽象化，用以帮助程序员写出在多核CPU上运行良好的程序。不幸的是，到目前为止，我们走得还不够远。

那些类库的开发者使用Java时，发现抽象的级别还不够。处理大数据就是个很好的例子，面对大数据，Java还欠缺高效的并行操作。**Java 8允许开发者编写复杂的集合处理算法**，只需要简单修改一个方法，就能让代码在多核CPU上高效运行。**为了编写并行处理这些大数据的类库**，需要在语言层面上修改现有的Java：增加lambda表达式。

java 8引入lambda迫切需求是因为 **lambda 表达式能简化集合上数据的多线程或者多核的处理，提供更快的集合处理速度**

当然，这样做是有代价的，程序员必须学习如何编写和阅读包含lambda表达式的代码，但是，这不是一桩赔本的买卖。与手写一大段复杂的、线程安全的代码相比，学习一点新语法和一些新习惯容易很多。开发企业级应用时，好的类库和框架极大地降低了开发时间和成本，也扫清了开发易用且高效的类库的障碍。

[Java 8新特性探究（一）通往lambda之路_语法篇](https://my.oschina.net/benhaile/blog/175012)

## Lambda语法
包含三个部分

    (parameters) -> expression 或者 (parameters) -> { statements; }

* 一个括号内用逗号分隔的形式参数，参数是函数式接口里面方法的参数

* 一个箭头符号：->

* 方法体，可以是`表达式`和`代码块`，方法体函数式接口里面方法的实现，如果是代码块，则必须用`{}`来包裹起来，且需要一个`return` 返回值，但有个例外，若函数式接口里面方法返回值是`void`，则无需{}

### 方法引用
其实是lambda表达式的一个简化写法，所引用的方法其实是lambda表达式的方法体实现，语法也很简单，左边是容器（可以是类名，实例名），中间是"::"，右边是相应的方法名。
    ObjectReference::methodName

一般方法的引用格式是

如果是静态方法，则是ClassName::methodName。如 Object ::equals

如果是实例方法，则是Instance::methodName。如Object obj=new Object();obj::equals;

构造函数.则是ClassName::new

如果你觉得lambda的方法体会很长，影响代码可读性，方法引用就是个解决办法

### 1.使用() -> {} 替代匿名类
  现在Runnable线程，Swing，JavaFX的事件监听器代码等，在java 8中你可以使用Lambda表达式替代丑陋的匿名类。
```java
//Before Java 8:
new Thread(new Runnable() {
    @Override
    public void run() {
        System.out.println("Before Java8 ");
    }
}).start();

//Java 8 way:
new Thread(() -> System.out.println("In Java8!"));

// Before Java 8:
JButton show =  new JButton("Show");
show.addActionListener(new ActionListener() {
     @Override
     public void actionPerformed(ActionEvent e) {
           System.out.println("without lambda expression is boring");
        }
     });


// Java 8 way:
show.addActionListener((e) -> {
    System.out.println("Action !! Lambda expressions Rocks");
});
```
### 2.使用内循环替代外循环
外循环：描述怎么干，代码里嵌套2个以上的for循环的都比较难读懂；只能顺序处理List中的元素；

内循环：描述要干什么，而不是怎么干；不一定需要顺序处理List中的元素
```java
//Prior Java 8 :
List features = Arrays.asList("Lambdas", "Default Method",
"Stream API", "Date and Time API");
for (String feature : features) {
   System.out.println(feature);
}

//In Java 8:
List features = Arrays.asList("Lambdas", "Default Method", "Stream API",
 "Date and Time API");
features.forEach(n -> System.out.println(n));

// Even better use Method reference feature of Java 8
// method reference is denoted by :: (double colon) operator
// looks similar to score resolution operator of C++
features.forEach(System.out::println);

Output:
Lambdas
Default Method
Stream API
Date and Time API
```
### 3.支持函数编程

为了支持函数编程，Java 8加入了一个新的包`java.util.function`，其中有一个接口`java.util.function.Predicate`是支持Lambda函数编程：

```java
public static void main(args[]){
  List languages = Arrays.asList("Java", "Scala", "C++", "Haskell", "Lisp");

  System.out.println("Languages which starts with J :");
  filter(languages, (str)->str.startsWith("J"));

  System.out.println("Languages which ends with a ");
  filter(languages, (str)->str.endsWith("a"));

  System.out.println("Print all languages :");
  filter(languages, (str)->true);

   System.out.println("Print no language : ");
   filter(languages, (str)->false);

   System.out.println("Print language whose length greater than 4:");
   filter(languages, (str)->str.length() > 4);
}

 public static void filter(List names, Predicate condition) {
    names.stream().filter((name) -> (condition.test(name)))
        .forEach((name) -> {System.out.println(name + " ");
    });
 }

Output:
Languages which starts with J :
Java
Languages which ends with a
Java
Scala
Print all languages :
Java
Scala
C++
Haskell
Lisp
Print no language :
Print language whose length greater than 4:
Scala
Haskell
```

4.处理数据？用管道的方式更加简洁
```java
final BigDecimal totalOfDiscountedPrices = prices.stream()
.filter(price -> price.compareTo(BigDecimal.valueOf(20)) > 0)
.map(price -> price.multiply(BigDecimal.valueOf(0.9)))
.reduce(BigDecimal.ZERO,BigDecimal::add);

System.out.println("Total of discounted prices: " + totalOfDiscountedPrices);
```
