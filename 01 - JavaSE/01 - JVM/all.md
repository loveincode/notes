### 类加载
  双亲委派模型
  三种类加载器
  类名相等且由同一个类加载器实例加载

### 内存模型
  多线程下的共享变量
  工作内存与主内存交互协议
    lock
    unlock
    read
    load
    use
    assign
    store
    write

### 虚拟内存结构

### class二进制字节码结构

### GC
  对象存活判断
    引用计数法
    可达性分析
      GCROOTs
      (1). 虚拟机栈（栈帧中的局部变量区，也叫做局部变量表）中引用的对象。
      (2). 方法区中的类静态属性引用的对象。
      (3). 方法区中常量引用的对象。
      (4). 本地方法栈中JNI(Native方法)引用的对象。
  回收策略
    标记-清除
    标记-复制
    标记-整理
    分代收集
      新生代
      老年代
      永久代
  按运行方式分类（参考 /10-readingNote/IT/深入理解Java虚拟机/第3章）
    串行收集器：只有一条GC，会stop the world
    并行收集器：多条GC,会stop the world
    并发收集器：一条或多条GC线程，需要在部分阶段stop the world,部分阶段与程序并发
  Hotspot具体
    串行:serial,serial old
    并行:ParNew,Parallel Scavenge,Parallel Old
    并发:CMS
  两种运行方式
    client
      开发默认
      启动较快
      不适合长时间运行
    server
      -server强制开启server模式
      JVM在运行过程做较多优化，运行时间越长，运行速度越快
      启动较慢

### 四种引用类型
  强引用
  软引用
  弱引用
  虚引用

### 生命周期
  加载
  链接
    验证
    准备
    解析
  初始化
