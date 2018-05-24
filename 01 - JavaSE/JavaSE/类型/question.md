```java
byte b1=1,b2=2,b3,b6;
final byte b4=4,b5=6;
b6=b4+b5;
b3=(b1+b2);
System.out.println(b3+b6);
```
``` output
语句：b3=b1+b2编译出错
被final修饰的变量是常量，这里的b6=b4+b5可以看成是b6=10；在编译时就已经变为b6=10了
而b1和b2是byte类型，java中进行计算时候将他们提升为int类型，再进行计算，b1+b2计算后已经是int类型，赋值给b3，b3是byte类型，类型不匹配，编译不会通过，需要进行强制转换。
Java中的byte，short，char进行计算时都会提升为int类型。
```


``` java
short a = 128;
byte b = (byte) a;
```
```
byte在内存中占一个字节，范围是 -128到127之间。
将128强制类型转换为byte型，就超出了byte型的范围，
128的二进制存储是 1000 0000 转换为byte型后，最高位是符号位，值是-128
```


```java
class CompareReference{
   public static void main(String [] args){
   float f=42.0f;
   float f1[]=new float[2];
   float f2[]=new float[2];
   float[] f3=f1;
   long x=42;
   f1[0]=42.0f;
  }
}
```
```
f1==f2    false
x==f1[0]  true
f1==f3    true
f2==f1[1] false

两个数值进行二元操作时，会有如下的转换操作：
如果两个操作数其中有一个是double类型，另一个操作就会转换为double类型。
否则，如果其中一个操作数是float类型，另一个将会转换为float类型。
否则，如果其中一个操作数是long类型，另一个会转换为long类型。
否则，两个操作数都转换为int类型。
故，x==f1[0]中，x将会转换为float类型。
基本类型之间的比较，应该会将低精度类型自动转为高精度类型再比较。
```
