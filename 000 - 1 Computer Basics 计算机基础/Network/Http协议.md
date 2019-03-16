#Http协议
  超文本传输协议。
  ---
  * 默认端口：80

##Http协议的主要特点
  ---
  1. 支持客户／服务器模式
  2. 简单快速：客户向服务端请求服务时，只需传送请求方式和路径。
  3. 灵活：允许传输任意类型的数据对象。由Content-Type加以标记。
  4. 无连接：每次响应一个请求，响应完成以后就断开连接。
  5. 无状态：服务器不保存浏览器的任何信息。每次提交的请求之间没有关联。

###非持续性和持续性
  ---
  * HTTP1.0默认非持续性；HTTP1.1默认持续性

####持续性

  浏览器和服务器建立TCP连接后，可以请求多个对象

####非持续性
  浏览器和服务器建立TCP连接后，只能请求一个对象

###非流水线和流水线
  ---
  类似于组成里面的流水操作

  * 流水线：不必等到收到服务器的回应就发送下一个报文。
  * 非流水线：发出一个报文，等到响应，再发下一个报文。类似TCP。

####POST和GET的区别

  | Post一般用于更新或者添加资源信息       | Get一般用于查询操作，而且应该是安全和幂等的           |
  | ------------- |:-------------:|
  | Post更加安全      | Get会把请求的信息放到URL的后面 |
  | Post传输量一般无大小限制     | Get不能大于2KB      |
  | Post执行效率低 | Get执行效率略高      |


####为什么POST效率低，Get效率高
  ---
  * Get将参数拼成URL,放到header消息头里传递
  * Post直接以键值对的形式放到消息体中传递。
  * 但两者的效率差距很小很小

### 请求消息头
  作用：向服务器端传递附加信息（暗号指令）

  `Accept`:告知服务器，客户端可以接受的数据类型（MIME类型）
  文件系统：通过文件的扩展名区分不同的文件的。txt jpeg
  MIME类型：大类型/小类型。 txt--->text/plain   html---->text/html js---->text/javascript (具体对应关系：可参考 Tomcat\conf\web.xml)
  `Accept-Charaset`: 客户端接受字符编码
  `Accept-Encoding`：告知服务器，客户端可以接受的压缩编码。比如gzip
  `Accept-Language`：告知服务器，客户端支持的语言。
  `Host`:要找的主机
  `Referer`：告知服务器，从哪个页面过来的。（作用：统计广告的投放效果；防止盗链。）
  `Content-Type`：告知服务器，请求正文的MIME类型
  默认类型：application/x-www-form-urlencoded(表单enctype属性的默认取值)
  具体体现：username=abc&password=123
  其他类型：multipart/form-data(文件上传时用的)
  `If-Modified-Since`：告知服务器，当前访问的资源，缓存中的文件的最后修改时间。
  `User-Agent`:告知服务器，浏览器的类型
  `Content-Length`：请求正文的数据长度
  `Cookie`：（*****重要）会话管理有关

### 响应消息头
  作用：服务器端向客户端传递的附加信息（暗号指令）
  `Location`：告知客户端，你去访问的地址。
  和302/307实现请求重定向
  `Content-Encoding`：告知客户端，响应正文使用的压缩编码（gzip）
  `Content-Length`:告知客户端，响应正文的长度
  `Content-Type`：告知客户端，响应文正的MIME类型。默认text/html
  `Refresh`:告知客户端，定时刷新
  `Content-Disposition`：告知客户端，用下载的方式打开  attachment;filename=23.jpg
  `Set-Cookie`:(*****)会话有关
  -------------
  `Expires`: -1 控制时间的
  `Cache-Control`: no-cache (1.1)
  `Pragma`: no-cache   (1.0)
  三头一块用，用于告知浏览器，不要缓存。

##Https
---
* 端口号是443
* 是由SSL+Http协议构建的可进行加密传输、身份认证的网络协议。
