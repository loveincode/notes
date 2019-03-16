### 51、说一说Servlet的生命周期?

  Servlet有良好的生存期的定义，包括加载和实例化、初始化、处理请求以及服务结束。这个生存期由`javax.servlet.Servlet`接口的`init(),service()和destroy`方法表达。

  Servlet被服务器实例化后，容器运行其init方法，请求到达时运行其service方法，service方法自动派遣运行与请求对应的doXXX方法（doGet，doPost）等，当服务器决定将实例销毁的时候调用其destroy方法。

  web容器加载servlet，生命周期开始。通过调用servlet的init()方法进行servlet的初始化。通过调用service()方法实现，根据请求的不同调用不同的do***()方法。结束服务，web容器调用servlet的destroy()方法。

### 52、Servlet API中forward()与redirect()的区别？

  1. 从地址栏显示来说
      forward是服务器请求资源,服务器直接访问目标地址的URL,把那个URL的响应内容读取过来,然后把这些内容再发给浏览器.浏览器根本不知道服务器发送的内容从哪里来的,所以它的地址栏还是原来的地址.
      redirect是服务端根据逻辑,发送一个状态码,告诉浏览器重新去请求那个地址.所以地址栏显示的是新的URL.所以redirect等于客户端向服务器端发出两次request，同时也接受两次response。
  2. 从数据共享来说
      forward:转发页面和转发到的页面可以共享request里面的数据.
      redirect:不能共享数据.
      redirect不仅可以重定向到当前应用程序的其他资源,还可以重定向到同一个站点上的其他应用程序中的资源,甚至是使用绝对URL重定向到其他站点的资源.
      forward方法只能在同一个Web应用程序内的资源之间转发请求.forward 是服务器内部的一种操作.
      redirect 是服务器通知客户端,让客户端重新发起请求.
      所以,你可以说 redirect 是一种间接的请求, 但是你不能说"一个请求是属于forward还是redirect "
  3. 从运用地方来说
      forward:一般用于用户登陆的时候,根据角色转发到相应的模块.
      redirect:一般用于用户注销登陆时返回主页面和跳转到其它的网站等.
  4. 从效率来说
      forward:高.
      redirect:低.

### 53、request.getAttribute()和 request.getParameter()有何区别?

  1. request.getParameter()取得是通过容器的实现来取得通过类似post，get等方式传入的数据。
     request.setAttribute()和getAttribute()只是在web容器内部流转，仅仅是请求处理阶段。

  2. getAttribute是返回对象,getParameter返回字符串

  3. getAttribute()一向是和setAttribute()一起使用的，只有先用setAttribute()设置之后，才能够通过getAttribute()来获得值，它们传递的是Object类型的数据。而且必须在同一个request对象中使用才有效。,而getParameter()是接收表单的get或者post提交过来的参数


### 54，jsp静态包含和动态包含的区别

  1. <%@include file="xxx.jsp"%>为jsp中的编译指令，其文件的包含是发生在jsp向servlet转换的时期，而<jsp:include page="xxx.jsp">是jsp中的动作指令，其文件的包含是发生在编译时期，也就是将java文件编译为class文件的时期

  2. 使用静态包含只会产生一个class文件，而使用动态包含会产生多个class文件

  3. 使用静态包含，包含页面和被包含页面的request对象为同一对象，因为静态包含只是将被包含的页面的内容复制到包含的页面中去；而动态包含包含页面和被包含页面不是同一个页面，被包含的页面的request对象可以取到的参数范围要相对大些，不仅可以取到传递到包含页面的参数，同样也能取得在包含页面向下传递的参数


### 55，MVC的各个部分都有那些技术来实现?如何实现?

  MVC是Model－View－Controller的简写。Model代表的是应用的业务逻辑（通过JavaBean，EJB组件实现），View是应用的表示面（由JSP页面产生），Controller是提供应用的处理过程控制（一般是一个Servlet），通过这种设计模型把应用逻辑，处理过程和显示逻辑分成不同的组件实现。这些组件可以进行交互和重用。

### 56，jsp有哪些内置对象?作用分别是什么?

  JSP共有以下9个内置的对象：

  1. request 用户端请求，此请求会包含来自GET/POST请求的参数

  2. response 网页传回用户端的回应

  3. pageContext 网页的属性是在这里管理

  4. session 与请求有关的会话期

  5. application servlet 正在执行的内容

  6. out 用来传送回应的输出

  7. config  servlet的构架部件

  8. page JSP网页本身

  9. exception 针对错误网页，未捕捉的例外

### 57，Http中，get和post方法的区别

  1. Get是向服务器发索取数据的一种请求，而Post是向服务器提交数据的一种请求

  2. Get是获取信息，而不是修改信息，类似数据库查询功能一样，数据不会被修改

  3. Get请求的参数会跟在url后进行传递，请求的数据会附在URL之后，以?分割URL和传输数据，参数之间以&相连,％XX中的XX为该符号以16进制表示的ASCII，如果数据是英文字母/数字，原样发送，如果是空格，转换为+，如果是中文/其他字符，则直接把字符串用BASE64加密。
  4. Get传输的数据有大小限制，因为GET是通过URL提交数据，那么GET可提交的数据量就跟URL的长度有直接关系了，不同的浏览器对URL的长度的限制是不同的。

  5. GET请求的数据会被浏览器缓存起来，用户名和密码将明文出现在URL上，其他人可以查到历史浏览记录，数据不太安全。
    在服务器端，用Request.QueryString来获取Get方式提交来的数据
    Post请求则作为http消息的实际内容发送给web服务器，数据放置在HTML Header内提交，Post没有限制提交的数据。Post比Get安全，当数据是中文或者不敏感的数据，则用get，因为使用get，参数会显示在地址，对于敏感数据和不是中文字符的数据，则用post。
  6. POST表示可能修改变服务器上的资源的请求，在服务器端，用Post方式提交的数据只能用Request.Form来获取。

### 58，什么是cookie？Session和cookie有什么区别？

  Cookie是会话技术,将用户的信息保存到浏览器的对象.

  区别：
      (1)cookie数据存放在客户的浏览器上，session数据放在服务器上
      (2)cookie不是很安全，别人可以分析存放在本地的COOKIE并进行COOKIE欺骗,如果主要考虑到安全应当使用session
      (3)session会在一定时间内保存在服务器上。当访问增多，会比较占用你服务器的性能，如果主要考虑到减轻服务器性能方面，应当使用COOKIE
      (4)单个cookie在客户端的限制是3K，就是说一个站点在客户端存放的COOKIE不能3K。

  结论：
      将登陆信息等重要信息存放为SESSION;其他信息如果需要保留，可以放在COOKIE中。

### 59，jsp和servlet的区别、共同点、各自应用的范围？

  JSP是Servlet技术的扩展，本质上就是Servlet的简易方式。JSP编译后是“类servlet”。

  Servlet和JSP最主要的不同点在于：Servlet的应用逻辑是在Java文件中，并且完全从表示层中的HTML里分离开来。而JSP的情况是Java和HTML可以组合成一个扩展名为.jsp的文件。

  JSP侧重于视图，Servlet主要用于控制逻辑。在struts框架中,JSP位于MVC设计模式的视图层,而Servlet位于控制层.

### 60，tomcat容器是如何创建servlet类实例？用到了什么原理？

  当容器启动时，会读取在webapps目录下所有的web应用中的web.xml文件，然后对xml文件进行解析，并读取servlet注册信息。
  然后，将每个应用中注册的servlet类都进行加载，并通过反射的方式实例化。（有时候也是在第一次请求时实例化）
  在servlet注册时加上`<load-on-startup>1</load-on-startup>`如果为正数，则在一开始就实例化，如果不写或为负数，则第一次请求实例化。
