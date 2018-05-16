## final
final定义的常量，一旦初始化，不能被修改，对基本类型来说是其值不可变，对引用来说是其引用不可变。
其初始化智能在两个地方 1 其定义处 2 构造函数中 二者只能选其一，不能再定义时给了值，又在构造函数中赋值。
一个类不能既被声明为abstract，也被声明为final
## finally
不管有无异常发生，finally总会执行，若catch中有return语句，也执行，在return语句之前执行。
Finally除了try块调用了System.exit(0),finally都会执行，有return，也会先执行finally中的内容，再执行return。
## finalize
finalize方法定义在object中
## 多态
父类引用指向子类对象，对于static，编译运行都看左边
## 泛型
及参数化类型，泛型擦除：java编译器生成的字节码文件不包含有泛型信息，泛型信息将在编译时被擦除，这个过程称为泛型擦除
主要过程为 1 将所有泛型参数用其左边界（最顶级的父类型）类型替换 2 移除all的类型参数
## String
常量池中只会维护一个值相同的String对象
当调用String类的 **intern()** 方法时，若常量池中已经包含一个等于此String对象的字符串（用Object的equals方法确定），则返回池中的字符串，否则将此String对象添加到池中，并返回此String对象在 **常量池中的引用**。
new String 是 **堆中的引用**
= ""  **常量池中的引用**。 he
``` java
String s1 = new String("asd");
s1 = s1.intern();
String s2 = "asd";
s1 == s2; 是 true

String s1 = new String("777");
String s2 = "aaa777";
String s4 = "aaa"+s1;
S2==s4 ;是 false

String s1 = "abcd";
Char[] ch = {'a','b','c','d'};
s1.equals(ch);  false  //因为他们是不同的类型

Char[] c = {'a','b','c','d'};
String s = "abcd";
Char[] cc = s.toCharArray();
Cc == c; false
Cc.equals(c);false
```

## 静态代码块
一个类可以有一个or多个静态代码块，静态代码块在类被加载时执行，优于构造函数的执行，并且按照各静态模块放在类中的顺序执行。
## -127 - 128 会在jvm启动时载入内存，除非用new Integer()显示 的创建对象，否则都是同一个对象
Interget的value方法返回一个对象，先判断传入的参数是否在-128-127之间，若已经存在，则直接返回引用 ，否则返回new Integer()
Integer i1=59
Int i2=59;
Integer i3=Integer.valueOf(59);
Integer i4=new Integer(59);
i1==i2 true
i1==i3 true
i3==i4 false  
i4==i2 true   i2 是int类型，和i4比较，i4会自动拆箱
