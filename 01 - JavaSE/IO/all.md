### 1. 文件对象
File
RandomAccessFile
  特点：智能操作文件,实例化时如果不存在,则会自动创建
  场景：构建多线程下载器
### 2. 输入流
### 3. 输出流
### 4. 序列化
  对象转为字节序列的过程
  ObjectOutputStream代表对象输出流
  默认序列化Serialzable
  自定义序列化Externalizable
    writeObject
    readObject

  serialVersionUID
### 5. 反序列化
  字节序列转为对象的过程
  ObjectInputStream代表对象输入流

### NIO
  **NIO简介:**
  Java NIO 是 java 1.4, 之后新出的一套IO接口NIO中的N可以理解为Non-blocking，不单纯是New。

  **NIO的特性/NIO与IO区别:**
  1)IO是面向流的，NIO是面向缓冲区的；
  2)IO流是阻塞的，NIO流是不阻塞的;
  3)NIO有选择器，而IO没有。

  **读数据和写数据方式:**

  从通道进行数据读取 ：创建一个缓冲区，然后请求通道读取数据。
  从通道进行数据写入 ：创建一个缓冲区，填充数据，并要求通道写入数据。

  **NIO核心组件简单介绍**
  Channels
  Buffers
  Selectors
