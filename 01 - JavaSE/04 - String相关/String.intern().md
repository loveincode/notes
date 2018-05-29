使用 String.intern() 可以保证相同内容的字符串实例引用相同的内存对象。

intern()方法会首先从常量池中查找是否存在该常量值,如果常量池中不存在则现在常量池中创建,如果已经存在则直接返回.

intern方法是Native调用，它的作用是在方法区中的常量池里通过equals方法寻找等值的对象，如果没有找到则在常量池中开辟一片空间存放字符串并返回该对应String的引用，否则直接返回常量池中已存在String对象的引用。

下面示例中，s1 和 s2 采用 new String() 的方式新建了两个不同对象，而 s3 是通过 s1.intern() 方法取得一个对象引用，这个方法首先把 s1 引用的对象放到 String Poll（字符串常量池）中，然后返回这个对象引用。因此 s3 和 s1 引用的是同一个字符串常量池的对象。
``` java
String s1 = new String("aaa");
String s2 = new String("aaa");
System.out.println(s1 == s2);           // false
String s3 = s1.intern();
System.out.println(s1.intern() == s3);  // true
```
如果是采用 "bbb" 这种使用双引号的形式创建字符串实例，会自动地将新建的对象放入 String Poll 中。
``` java
String s4 = "bbb";
String s5 = "bbb";
System.out.println(s4 == s5);  // true
```
在 Java 7 之前，字符串常量池被放在运行时常量池中，它属于永久代。而在 Java 7，字符串常量池被放在堆中。这是因为永久代的空间有限，在大量使用字符串的场景下会导致 OutOfMemoryError 错误。

What is String interning? https://stackoverflow.com/questions/10578984/what-is-java-string-interning
深入解析 String#intern https://tech.meituan.com/in_depth_understanding_string_intern.html
