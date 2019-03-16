toString()
默认返回 ToStringExample@4554617c 这种形式，其中 @ 后面的数值为散列码的无符号十六进制表示。
``` java
public class ToStringExample {
    private int number;

    public ToStringExample(int number) {
        this.number = number;
    }
}

ToStringExample example = new ToStringExample(123);
System.out.println(example.toString());

ToStringExample@4554617c
```
