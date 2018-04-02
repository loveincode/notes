## 1、默认(欢迎)文件的设置

 在tomcat4\conf\web.xml中，<welcome-file-list>与IIS中的默认文件意思相同。

 ```
   <welcome-file-list>
      <welcome-file>index.html</welcome-file>
      <welcome-file>index.htm</welcome-file>
      <welcome-file>index.jsp</welcome-file>
   </welcome-file-list>
 ```

## 2、报错文件的设置
```
  <error-page>
    <error-code>404</error-code>
    <location>/notFileFound.jsp</location>
  </error-page>
  <error-page>
    <exception-type>java.lang.NullPointerException</exception-type>
    <location>/null.jsp</location>
  </error-page>
```
如果某文件资源没有找到，服务器要报404错误，按上述配置则会调用\webapps\ROOT\notFileFound.jsp。
如果执行的某个JSP文件产生NullPointException ，则会调用\webapps\ROOT\null.jsp

## 3、会话超时的设置

设置session 的过期时间，单位是分钟；
```
  <session-config>
    <session-timeout>30</session-timeout>
  </session-config>
```

## 4、过滤器的设置
```
  <filter>
    <filter-name>FilterSource</filter-name>
    <filter-class>project4. FilterSource</filter-class>
  </filter>

  <filter-mapping>
    <filter-name>FilterSource</filter-name>
    <url-pattern>/WwwServlet</url-pattern>
    (<url-pattern>/haha/*</url-pattern>)
  </filter-mapping>
```

过滤：

1. 身份验证的过滤Authentication Filters
2. 日志和审核的过滤Logging and AuditingFilters
3. 图片转化的过滤Image conversionFilters
4. 数据压缩的过滤Data compressionFilters
5. 加密过滤Encryption Filters
6. Tokenizing Filters
7. 资源访问事件触发的过滤Filters that triggerresource access events XSL/T 过滤XSL/T filters
9. 内容类型的过滤Mime-type chain Filter 注意监听器的顺序，如：先安全过滤，然后资源，
然后内容类型等，这个顺序可以自己定。
