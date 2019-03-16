### BigDecimal 的加减乘除
``` java
BigDecimal bignum1 = new BigDecimal("10");
BigDecimal bignum2 = new BigDecimal("5");
BigDecimal bignum3 = null;

//加法
bignum3 = bignum1.add(bignum2);
System.out.println("和 是：" + bignum3);

//减法
bignum3 = bignum1.subtract(bignum2);
System.out.println("差 是：" + bignum3);

//乘法
bignum3 = bignum1.multiply(bignum2);
System.out.println("积 是：" + bignum3);

//除法
bignum3 = bignum1.divide(bignum2);
System.out.println("商 是：" + bignum3);
```

### BigDecimal 的比较大小。
``` java
BigDecimal num1 = new BigDecimal("0");
BigDecimal num2 = new BigDecimal("1");
BigDecimal num3 = new BigDecimal("2");

BigDecimal num = new BigDecimal("1"); //用做比较的值

System.out.println(num1.compareTo(num)); //小于 时，返回 -1
System.out.println(num2.compareTo(num)); //等于 时，返回 0
System.out.println(num3.compareTo(num)); //大于 时，返回 1
```
