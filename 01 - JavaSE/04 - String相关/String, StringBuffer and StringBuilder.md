1. 是否可变

String 不可变
StringBuffer 和 StringBuilder 可变

2. 是否线程安全

String 不可变，因此是线程安全的
StringBuilder 不是线程安全的
StringBuffer 是线程安全的，内部使用 synchronized 来同步


String 安全
StringBuffer 安全
StringBuilder 不安全

可变性
String类中使用字符数组保存字符串，private　final　char　value[]，所以string对象是不可变的。StringBuilder与StringBuffer都继承自AbstractStringBuilder类，在AbstractStringBuilder中也是使用字符数组保存字符串，char[]value，这两种对象都是可变的。

线程安全性　　
String中的对象是不可变的，也就可以理解为常量，线程安全。AbstractStringBuilder是StringBuilder与StringBuffer的公共父类，定义了一些字符串的基本操作，如expandCapacity、append、insert、indexOf等公共方法。StringBuffer对方法加了同步锁或者对调用的方法加了同步锁，所以是线程安全的。StringBuilder并没有对方法进行加同步锁，所以是非线程安全的。

性能　
每次对String 类型进行改变的时候，都会生成一个新的String对象，然后将指针指向新的String 对象。StringBuffer每次都会对StringBuffer对象本身进行操作，而不是生成新的对象并改变对象引用。相同情况下使用StirngBuilder 相比使用StringBuffer 仅能获得10%~15% 左右的性能提升，但却要冒多线程不安全的风险。
对于三者使用的总结
如果要操作少量的数据用 = String单线程操作字符串缓冲区 下操作大量数据 = StringBuilder多线程操作字符串缓冲区 下操作大量数据 = StringBuffer



  ``` java
  StringBuffer s1=new StringBuffer(10);
  s1.append(“1234”)
  则s1.length()和s1.capacity()分别是多少?

  4　10
  //length返回当前长度
  //如果字符串长度没有初始化长度大，capacity返回初始化的长度
  //如果append后的字符串长度超过初始化长度，capacity返回增长后的长度
  StringBuffer s = new StringBuffer(x);  x为初始化容量长度
  s.append("Y"); "Y"表示长度为y的字符串
  length始终返回当前长度即y；
  对于s.capacity()：
  1.当y<x时，值为x
  以下情况，容器容量需要扩展
  2.当x<y<2*x+2时，值为 2*x+2
  3.当y>2*x+2时，值为y

  StringBuffer和StringBuilder的默认大小为16
  ArrayList和LinkedList的默认大小10
  ```

String, StringBuffer, and StringBuilder https://stackoverflow.com/questions/2971315/string-stringbuffer-and-stringbuilder
