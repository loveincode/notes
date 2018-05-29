### equals()
1. equals() 与 == 的区别
对于基本类型，== 判断两个值是否相等，基本类型没有 equals() 方法。
对于引用类型，== 判断两个实例是否引用同一个对象，而 equals() 判断引用的对象是否等价。
``` java
Integer x = new Integer(1);
Integer y = new Integer(1);
System.out.println(x.equals(y)); // true
System.out.println(x == y);      // false
```
2. 等价关系

（一）自反性
``` java
x.equals(x); // true
```
（二）对称性
``` java
x.equals(y) == y.equals(x); // true
```
（三）传递性
``` java
if (x.equals(y) && y.equals(z))
    x.equals(z); // true;
```
（四）一致性
多次调用 equals() 方法结果不变
``` java
x.equals(y) == x.equals(y); // true
```
（五）与 null 的比较

对任何不是 null 的对象 x 调用 x.equals(null) 结果都为 false
``` java
x.euqals(null); // false;
```
3. 实现

检查是否为同一个对象的引用，如果是直接返回 true；
检查是否是同一个类型，如果不是，直接返回 false；
将 Object 实例进行转型；
判断每个关键域是否相等。
``` java
public class EqualExample {
    private int x;
    private int y;
    private int z;

    public EqualExample(int x, int y, int z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        EqualExample that = (EqualExample) o;

        if (x != that.x) return false;
        if (y != that.y) return false;
        return z == that.z;
    }
}
```
