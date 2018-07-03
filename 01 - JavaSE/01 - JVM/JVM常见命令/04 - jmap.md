Jmap

  jmap是JDK自带的工具软件，主要用于打印指定Java进程(或核心文件、远程调试服务器)的共享对象内存映射或堆内存细节。可以使用jmap生成Heap  这篇文章主要介绍Java的堆Dump以及jamp命令

### 什么是堆Dump
  堆Dump是反应Java堆使用情况的内存镜像，其中主要包括系统信息、虚拟机属性、完整的线程Dump、所有类和对象的状态等。 一般，在内存不足、GC异常等情况下，我们就会怀疑有内存泄露。这个时候我们就可以制作堆Dump来查看具体情况。分析原因。

### 基础知识

  常见内存错误：
  outOfMemoryError 年老代内存不足。
  outOfMemoryError:PermGen Space 永久代内存不足。
  outOfMemoryError:GC overhead limit exceed 垃圾回收时间占用系统运行时间的98%或以上。

### jmap

  用法摘要
  ``` yml
  Usage:
      jmap [option] <pid>
          (to connect to running process)
      jmap [option] <executable <core>
          (to connect to a core file)
      jmap [option] [server_id@]<remote server IP or hostname>
          (to connect to remote debug server)

  where <option> is one of:
      <none>               to print same info as Solaris pmap
      -heap                to print java heap summary
      -histo[:live]        to print histogram of java object heap; if the "live"
                           suboption is specified, only count live objects
      -permstat            to print permanent generation statistics
      -finalizerinfo       to print information on objects awaiting finalization
      -dump:<dump-options> to dump java heap in hprof binary format
                           dump-options:
                             live         dump only live objects; if not specified,
                                          all objects in the heap are dumped.
                             format=b     binary format
                             file=<file>  dump heap to <file>
                           Example: jmap -dump:live,format=b,file=heap.bin <pid>
      -F                   force. Use with -dump:<dump-options> <pid> or -histo
                           to force a heap dump or histogram when <pid> does not
                           respond. The "live" suboption is not supported
                           in this mode.
      -h | -help           to print this help message
      -J<flag>             to pass <flag> directly to the runtime system
  ```
  指定进程号(pid)的进程 jmap [ option ] 指定核心文件 jmap [ option ] 指定远程调试服务器 jmap [ option ] [server-id@]

### 参数：

  `option` 选项参数是互斥的(不可同时使用)。想要使用选项参数，直接跟在命令名称后即可。
  `pid` 需要打印配置信息的进程ID。该进程必须是一个Java进程。想要获取运行的Java进程列表，你可以使用jps。
  `executable` 产生核心dump的Java可执行文件。
  `core` 需要打印配置信息的核心文件。
  `remote-hostname-or-IP` 远程调试服务器的(请查看jsadebugd)主机名或IP地址。
  `server-id` 可选的唯一id，如果相同的远程主机上运行了多台调试服务器，用此选项参数标识服务器。

### 选项:

  `<no option> `如果使用不带选项参数的jmap打印共享对象映射，将会打印目标虚拟机中加载的每个共享对象的起始地址、映射大小以及共享对象文件的路径全称。这与Solaris的pmap工具比较相似。
  `-dump:[live,]format=b,file=<filename>` 以hprof二进制格式转储Java堆到指定filename的文件中。live子选项是可选的。如果指定了live子选项，堆中只有活动的对象会被转储。想要浏览heap dump，你可以使用jhat(Java堆分析工具)读取生成的文件。
  `-finalizerinfo` 打印等待终结的对象信息。
  `-heap` 打印一个堆的摘要信息，包括使用的GC算法、堆配置信息和generation wise heap usage。
  `-histo[:live]` 打印堆的柱状图。其中包括每个Java类、对象数量、内存大小(单位：字节)、完全限定的类名。打印的虚拟机内部的类名称将会带有一个’ * ’前缀。如果指定了live子选项，则只计算活动的对象。
  `-permstat` 打印Java堆内存的永久保存区域的类加载器的智能统计信息。对于每个类加载器而言，它的名称、活跃度、地址、父类加载器、它所加载的类的数量和大小都会被打印。此外，包含的字符串数量和大小也会被打印。
  `-F` 强制模式。如果指定的pid没有响应，请使用jmap -dump或jmap -histo选项。此模式下，不支持live子选项。
  `-h` 打印帮助信息。
  `-help` 打印帮助信息。
  `-J<flag> `指定传递给运行jmap的JVM的参数。

  举例
  查看java 堆（heap）使用情况,执行命令：
  ```yml
  hollis@hos:~/workspace/design_apaas/apaasweb/control/bin$ jmap -heap 31846

  Attaching to process ID 31846, please wait...
  Debugger attached successfully.
  Server compiler detected.
  JVM version is 24.71-b01

  using thread-local object allocation.
  Parallel GC with 4 thread(s)//GC 方式

  Heap Configuration: //堆内存初始化配置
     MinHeapFreeRatio = 0 //对应jvm启动参数-XX:MinHeapFreeRatio设置JVM堆最小空闲比率(default 40)
     MaxHeapFreeRatio = 100 //对应jvm启动参数 -XX:MaxHeapFreeRatio设置JVM堆最大空闲比率(default 70)
     MaxHeapSize      = 2082471936 (1986.0MB) //对应jvm启动参数-XX:MaxHeapSize=设置JVM堆的最大大小
     NewSize          = 1310720 (1.25MB)//对应jvm启动参数-XX:NewSize=设置JVM堆的‘新生代’的默认大小
     MaxNewSize       = 17592186044415 MB//对应jvm启动参数-XX:MaxNewSize=设置JVM堆的‘新生代’的最大大小
     OldSize          = 5439488 (5.1875MB)//对应jvm启动参数-XX:OldSize=<value>:设置JVM堆的‘老生代’的大小
     NewRatio         = 2 //对应jvm启动参数-XX:NewRatio=:‘新生代’和‘老生代’的大小比率
     SurvivorRatio    = 8 //对应jvm启动参数-XX:SurvivorRatio=设置年轻代中Eden区与Survivor区的大小比值
     PermSize         = 21757952 (20.75MB)  //对应jvm启动参数-XX:PermSize=<value>:设置JVM堆的‘永生代’的初始大小
     MaxPermSize      = 85983232 (82.0MB)//对应jvm启动参数-XX:MaxPermSize=<value>:设置JVM堆的‘永生代’的最大大小
     G1HeapRegionSize = 0 (0.0MB)

  Heap Usage://堆内存使用情况
  PS Young Generation
  Eden Space://Eden区内存分布
     capacity = 33030144 (31.5MB)//Eden区总容量
     used     = 1524040 (1.4534378051757812MB)  //Eden区已使用
     free     = 31506104 (30.04656219482422MB)  //Eden区剩余容量
     4.614088270399305% used //Eden区使用比率
  From Space:  //其中一个Survivor区的内存分布
     capacity = 5242880 (5.0MB)
     used     = 0 (0.0MB)
     free     = 5242880 (5.0MB)
     0.0% used
  To Space:  //另一个Survivor区的内存分布
     capacity = 5242880 (5.0MB)
     used     = 0 (0.0MB)
     free     = 5242880 (5.0MB)
     0.0% used
  PS Old Generation //当前的Old区内存分布
     capacity = 86507520 (82.5MB)
     used     = 0 (0.0MB)
     free     = 86507520 (82.5MB)
     0.0% used
  PS Perm Generation//当前的 “永生代” 内存分布
     capacity = 22020096 (21.0MB)
     used     = 2496528 (2.3808746337890625MB)
     free     = 19523568 (18.619125366210938MB)
     11.337498256138392% used

  670 interned Strings occupying 43720 bytes.
  ```


  查看堆内存(histogram)中的对象数量及大小。执行命令：
  ```
  hollis@hos:~/workspace/design_apaas/apaasweb/control/bin$ jmap -histo 3331

  num     #instances         #bytes  class name
  编号     个数                字节     类名
  ----------------------------------------------
     1:             7        1322080  [I
     2:          5603         722368  <methodKlass>
     3:          5603         641944  <constMethodKlass>
     4:         34022         544352  java.lang.Integer
     5:           371         437208  <constantPoolKlass>
     6:           336         270624  <constantPoolCacheKlass>
     7:           371         253816  <instanceKlassKlass>
  ```

  ```
  jmap -histo:live 这个命令执行，JVM会先触发gc，然后再统计信息。
  ```

  将内存使用的详细情况输出到文件，执行命令：
  ```
  hollis@hos:~/workspace/design_apaas/apaasweb/control/bin$ jmap -dump:format=b,file=heapDump 6900
  ```

  然后用jhat命令可以参看 jhat -port 5000 heapDump 在浏览器中访问：http://localhost:5000/ 查看详细信息

  这个命令执行，JVM会将整个heap的信息dump写入到一个文件，heap如果比较大的话，就会导致这个过程比较耗时，并且执行的过程中为了保证dump的信息是可靠的，所以会暂停应用。

  总结
  1. 如果程序内存不足或者频繁GC，很有可能存在内存泄露情况，这时候就要借助Java堆Dump查看对象的情况。
  2. 要制作堆Dump可以直接使用jvm自带的jmap命令
  3. 可以先使用jmap -heap命令查看堆的使用情况，看一下各个堆空间的占用情况。
  4. 使用jmap -histo:[live]查看堆内存中的对象的情况。如果有大量对象在持续被引用，并没有被释放掉，那就产生了内存泄露，就要结合代码，把不用的对象释放掉。
  5. 也可以使用 jmap -dump:format=b,file=<fileName>命令将堆信息保存到一个文件中，再借助jhat命令查看详细内容
  6. 在内存出现泄露、溢出或者其它前提条件下，建议多dump几次内存，把内存文件进行编号归档，便于后续内存整理分析。

  Error attaching to process: sun.jvm.hotspot.debugger.DebuggerException: Can’t attach to the process
  在ubuntu中第一次使用jmap会报错：Error attaching to process: sun.jvm.hotspot.debugger.DebuggerException: Can't attach to the process，
  这是oracla文档中提到的一个bug:http://bugs.java.com/bugdatabase/view_bug.do?bug_id=7050524,解决方式如下：

  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope 该方法在下次重启前有效。

  永久有效方法 sudo vi /etc/sysctl.d/10-ptrace.conf 编辑下面这行: kernel.yama.ptrace_scope = 1 修改为: kernel.yama.ptrace_scope = 0 重启系统，使修改生效。
