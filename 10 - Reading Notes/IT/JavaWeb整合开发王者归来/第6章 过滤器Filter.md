Filter是现在流行的AOP(面向切面编程)编程思想的一种体现，Filter的前后顺序

## 6.1 Filter概述
用于Servlet之外对request或者response进行修改。
Filter提出了滤镜链FilterChain的概念，一个FilterChain包括多个Filter
客户端请求request在抵达Servlet之前会经过FilterChain里的所有Filter.
服务器响应Response在从Servlet抵达客户端浏览器之前也会经过FilterChain里的所有Filter.

### Filter接口
javax.servlert.Filter接口
init()
doFilter()
destory()

doFilter()方法中一定要执行chain.doFilter(request,response) 否则request不会交给后面的Filter或者Servlet。

### Filter配置
``` xml
<filter>
  <filter-name></filter-name>
  <filter-class></filter-class>
  <init-param>
    <param-name></param-name>
    <param-value></param-value>
  </init-param>
</filter>

<filter-mapping>
  <filter-name></filter-name>
  <url-pattern></url-pattern>
  <url-pattern></url-pattern>
  <dispatcher></dispatcher>
  <dispatcher></dispatcher>
</filter-mapping>
```
<url-pattern>配置URL的规则 可使用通配符(" * ")
<dispatcher>配置到达Servlet的方式 （REQUEST、FORWARD、INCLUDE、ERROR） 不配置默认REQUEST

<filter-mapping>配置在前面的Filter执行要早于配置在后面的Filter

## 案例
防盗链
字符编码
日志记录
异常捕捉
权限验证
内容替换
GZIP压缩
图像水印
缓存
