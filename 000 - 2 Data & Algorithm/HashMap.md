HashMap默认初始长度16
每次增长 长度必须是2的幂

之所以选16 为了服务于从Key映射到index的Hash算法 位运算

```
index = Hash（“apple”）
```

我们通过利用Key的HashCode值来做某种运算。

进行位运算呢？有如下的公式（Length是HashMap的长度）：

```
index = HashCode（Key） & （Length - 1）
```

下面我们以值为“book”的Key来演示整个过程：

1. 计算book的hashcode，结果为十进制的3029737，二进制的101110001110101110 1001。
2. 假定HashMap长度是默认的16，计算Length-1的结果为十进制的15，二进制的1111。
3. 把以上两个结果做与运算，101110001110101110 1001 & 1111 = 1001，十进制是9，所以 index=9。
4. 可以说，Hash算法最终得到的index结果，完全取决于Key的Hashcode值的最后几位。
