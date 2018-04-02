https://blog.csdn.net/qq_16681169/article/details/75003640

## 一. tomcat支持的请求处理方式
Tomcat支持三种接收请求的处理方式：BIO、NIO、APR

**BIO模式**：阻塞式I/O操作，表示Tomcat使用的是传统Java I/O操作(即Java.io包及其子包)。Tomcat7以下版本默认情况下是以bio模式运行的，由于每个请求都要创建一个线程来处理，线程开销较大，不能处理高并发的场景，在三种模式中性能也最低。启动tomcat看到如下日志，表示使用的是BIO模式：
这里写图片描述

**NIO模式**：是java SE 1.4及后续版本提供的一种新的I/O操作方式(即java.nio包及其子包)。是一个基于缓冲区、并能提供非阻塞I/O操作的Java API，它拥有比传统I/O操作(bio)更好的并发运行性能。在tomcat 8之前要让Tomcat以nio模式来运行比较简单，只需要在Tomcat安装目录/conf/server.xml文件中将如下配置：


```
<Connector port="8080" protocol="HTTP/1.1"connectionTimeout="20000"redirectPort="8443" />
修改成
<Connector port="8080" protocol="org.apache.coyote.http11.Http11NioProtocol"connectionTimeout="20000"redirectPort="8443" />
```
Tomcat8以上版本，默认使用的就是NIO模式，不需要额外修改

**APR模式**：简单理解，就是从操作系统级别解决异步IO问题，大幅度的提高服务器的处理和响应性能， 也是Tomcat运行高并发应用的首选模式。
启用这种模式稍微麻烦一些，需要安装一些依赖库，下面以在CentOS7 mini版环境下Tomcat-8.0.35为例，介绍安装步聚：
```
APR 1.2+ development headers (libapr1-dev package)
OpenSSL 0.9.7+ development headers (libssl-dev package)
JNI headers from Java compatible JDK 1.4+
GNU development environment (gcc, make)
```
## 二. tomcat的 **NioEndpoint**

我们先来简单回顾下目前一般的NIO服务器端的大致实现，借鉴infoq上的一篇文章Netty系列之Netty线程模型中的一张图

一个或多个Acceptor线程，每个线程都有自己的Selector，Acceptor只负责accept新的连接，一旦连接建立之后就将连接注册到其他Worker线程中。
多个Worker线程，有时候也叫IO线程，就是专门负责IO读写的。一种实现方式就是像Netty一样，每个Worker线程都有自己的Selector，可以负责多个连接的IO读写事件，每个连接归属于某个线程。另一种方式实现方式就是有专门的线程负责IO事件监听，这些线程有自己的Selector，一旦监听到有IO读写事件，并不是像第一种实现方式那样（自己去执行IO操作），而是将IO操作封装成一个Runnable交给Worker线程池来执行，这种情况每个连接可能会被多个线程同时操作，相比第一种并发性提高了，但是也可能引来多线程问题，在处理上要更加谨慎些。tomcat的NIO模型就是第二种。

图中Acceptor及Worker分别是以线程池形式存在，Poller是一个单线程。注意，与BIO的实现一样，缺省状态下，在server.xml中没有配置<Executor>，则以Worker线程池运行，如果配置了<Executor>，则以基于java concurrent 系列的java.util.concurrent.ThreadPoolExecutor线程池运行。

**Acceptor**
接收socket线程，这里虽然是基于NIO的connector，但是在接收socket方面还是传统的serverSocket.accept()方式，获得SocketChannel对象，然后封装在一个tomcat的实现类org.apache.tomcat.util.net.NioChannel对象中。然后将NioChannel对象封装在一个PollerEvent对象中，并将PollerEvent对象压入events queue里。这里是个典型的生产者-消费者模式，Acceptor与Poller线程之间通过queue通信，Acceptor是events queue的生产者，Poller是events queue的消费者。

**Poller**
Poller线程中维护了一个Selector对象，NIO就是基于Selector来完成逻辑的。在connector中并不止一个Selector，在socket的读写数据时，为了控制timeout也有一个Selector，在后面的BlockSelector中介绍。可以先把Poller线程中维护的这个Selector标为主Selector。
Poller是NIO实现的主要线程。首先作为events queue的消费者，从queue中取出PollerEvent对象，然后将此对象中的channel以OP_READ事件注册到主Selector中，然后主Selector执行select操作，遍历出可以读数据的socket，并从Worker线程池中拿到可用的Worker线程，然后将socket传递给Worker。整个过程是典型的NIO实现。

**Worker**
Worker线程拿到Poller传过来的socket后，将socket封装在SocketProcessor对象中。然后从Http11ConnectionHandler中取出Http11NioProcessor对象，从Http11NioProcessor中调用CoyoteAdapter的逻辑，跟BIO实现一样。在Worker线程中，会完成从socket中读取http request，解析成HttpServletRequest对象，分派到相应的servlet并完成逻辑，然后将response通过socket发回client。在从socket中读数据和往socket中写数据的过程，并没有像典型的非阻塞的NIO的那样，注册OP_READ或OP_WRITE事件到主Selector，而是直接通过socket完成读写，这时是阻塞完成的，但是在timeout控制上，使用了NIO的Selector机制，但是这个Selector并不是Poller线程维护的主Selector，而是BlockPoller线程中维护的Selector，称之为辅Selector。
