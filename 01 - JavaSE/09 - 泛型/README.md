# notes

K T V E ？ object等的含义

```
E – Element (在集合中使用，因为集合中存放的是元素)
T – Type（Java 类）
K – Key（键）
V – Value（值）
N – Number（数值类型）
？ – 表示不确定的java类型（无限制通配符类型）
S、U、V – 2nd、3rd、4th types
Object – 是所有类的根类，任何类的对象都可以设置给该Object引用变量，使用的时候可能需要类型强制转换，但是用使用了泛型T、E等这些标识符后，在实际用之前类型就已经确定了，不需要再进行类型强制转换。
```

extends和super的理解

Java的类型擦除

Java中泛型的理解

Java泛型用法总结

``` java
public class Box<T> {
    // T stands for "Type"
    private T t;
    public void set(T t) { this.t = t; }
    public T get() { return t; }
}
```
Java 泛型详解 http://www.importnew.com/24029.html
10 道 Java 泛型面试题 https://cloud.tencent.com/developer/article/1033693
