redis存大整数会丢失精度，解决办法是将值转为String，再取出来转为数字类型

mysql
BIGINT(20)的取值范围为-9223372036854775808~92233 72036 85477 5807   
-2<sup>63</sup> ~ 2<sup>63</sup>-1
 与Java Long匹配
BIGINT(20) UNSIGNED的取值范围是0 ~ 18446744073709551615，
0 ~ 2<sup>64</sup>-1

Double BigDecimal 精度问题
