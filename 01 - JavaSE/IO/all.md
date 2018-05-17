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
