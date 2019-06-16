
session - cookie
```java
package org.springframework.session.web.http;
DefaultCookieSerializer


private String cookieName = "SESSION";
private boolean useBase64Encoding = true;

```
默认name是 SESSION
并且cookie是session经过`base64`编码后的值

如
sessionId=aa853792-4214-474c-807f-f805fbcf17cf
则
cookie： SESSION=YWE4NTM3OTItNDIxNC00NzRjLTgwN2YtZjgwNWZiY2YxN2Nm


``` session的有效期
maxInactiveIntervalInSeconds = 60 * 60 * 24
```
session 有效期从最后一次访问算起
