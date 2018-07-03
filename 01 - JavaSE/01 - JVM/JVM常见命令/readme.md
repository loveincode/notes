### 一、常用命令：
  在JDK的bin目彔下,包含了java命令及其他实用工具。
  `jps`:查看 **本机的Java中进程信息**。
  `jstack`:打印 **线程的栈信息**,制作线程Dump。
  `jmap`:打印 **内存映射,制作堆Dump**。
  `jstat`:**性能监控工具**。
  `jhat`:**内存分析工具**。

  `jconsole`:简易的可视化控制台。
  `jvisualvm`:功能强大的控制台。

### 二、认识Java Dump：
  **什么是Java Dump？**
  Java虚拟机的运行时快照。将Java虚拟机运行时的状态和信息保存到文件。
  线程Dump,包含所有线程的运行状态。纯文本格式。
  堆Dump,包含线程Dump,幵包含所有堆对象的状态。二进制格式。
  **Java Dump有什么用？**
  补足传统Bug分析手段的不足: 可在任何Java环境使用;信息量充足。 针对非功能正确性的Bug,主要为:多线程幵发、内存泄漏。
  制作Java Dump
  使用Java虚拟机制作Dump
  指示虚拟机在发生内存不足错误时,自动生成堆Dump
  -XX:+HeapDumpOnOutOfMemoryError
  使用图形化工具制作Dump
  使用JDK(1.6)自带的工具:Java VisualVM。
  使用命令行制作Dump
  `jstack`:打印线程的栈信息,制作线程Dump。
  `jmap`:打印内存映射,制作堆Dump。

  步骤：
  1. 检查虚拟机版本（java -version）
  2. 找出目标Java应用的进程ID（jps）
  3. 使用jstack命令制作线程Dump • Linux环境下使用kill命令制作线程Dump
  4. 使用jmap命令制作堆Dump
