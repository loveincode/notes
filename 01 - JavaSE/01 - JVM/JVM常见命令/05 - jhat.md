jhat(Java Heap Analysis Tool),是一个用来分析java的堆情况的命令。之前的文章讲到过，使用jmap可以生成Java堆的Dump文件。生成dump文件之后就可以用jhat命令，将dump文件转成html的形式，然后通过http访问可以查看堆情况。
jhat命令解析会Java堆dump并启动一个web服务器，然后就可以在浏览器中查看堆的dump文件了。
实例

### 一、导出dump文件
关于dump文件的生成可以看jmap命令的详细介绍.
1、运行java程序
```
/**
 * Created by hollis on 16/1/21.
 */
public class JhatTest {

    public static void main(String[] args) {
        while(true) {
            String string = new String("hollis");
            System.out.println(string);
        }
    }
}
```
2、查看该进程的ID
```
HollisMacBook-Air:apaas hollis$ jps -l
68680 org.jetbrains.jps.cmdline.Launcher
62247 com.intellij.rt.execution.application.AppMain
69038 sun.tools.jps.Jps
```
使用jps命令查看发现有三个java进程在运行，一个是我的IDEA使用的进程68680，一个是JPS命令使用的进程69038，另外一个就是上面那段代码运行的进程62247。
3、生成dump文件
```
HollisMacBook-Air:test hollis$ jmap -dump:format=b,file=heapDump 62247
Dumping heap to /Users/hollis/workspace/test/heapDump ...
Heap dump file created
```
以上命令可以将进程6900的堆dump文件导出到heapDump文件中。
查看当前目录就能看到heapDump文件。
除了使用jmap命令，还可以通过以下方式：
1、使用 jconsole 选项通过 HotSpotDiagnosticMXBean 从运行时获得堆转储（生成dump文件）、
2、虚拟机启动时如果指定了 -XX:+HeapDumpOnOutOfMemoryError 选项, 则在抛出 OutOfMemoryError 时, 会自动执行堆转储。
3、使用 hprof 命令

### 二、解析Java堆转储文件,并启动一个 web server
```
HollisMacBook-Air:apaas hollis$ jhat heapDump
Reading from heapDump...
Dump file created Thu Jan 21 18:59:51 CST 2016
Snapshot read, resolving...
Resolving 341297 objects...
Chasing references, expect 68 dots....................................................................
Eliminating duplicate references....................................................................
Snapshot resolved.
Started HTTP server on port 7000
Server is ready.
```
使用jhat命令，就启动了一个http服务，端口是7000
然后在访问http://localhost:7000/
页面如下：

### 三、分析
在浏览器里面看到dump文件之后就可以进行分析了。这个页面会列出当前进程中的所有对像情况。
该页面提供了几个查询功能可供使用：
All classes including platform//
Show all members of the rootset
Show instance counts for all classes (including platform)
Show instance counts for all classes (excluding platform)
Show heap histogram
Show finalizer summary
Execute Object Query Language (OQL) query
一般查看堆异常情况主要看这个两个部分：
Show instance counts for all classes (excluding platform)，平台外的所有对象信息。如下图：

Show heap histogram 以树状图形式展示堆情况。如下图：

具体排查时需要结合代码，观察是否大量应该被回收的对象在一直被引用或者是否有占用内存特别大的对象无法被回收。

### 用法摘要
这一部分放在后面介绍的原因是一般不太使用。
```
HollisMacBook-Air:~ hollis$ jhat -help
Usage:  jhat [-stack <bool>] [-refs <bool>] [-port <port>] [-baseline <file>] [-debug <int>] [-version] [-h|-help] <file>

    -J<flag>          Pass <flag> directly to the runtime system. For
              example, -J-mx512m to use a maximum heap size of 512MB
    -stack false:     Turn off tracking object allocation call stack.
    -refs false:      Turn off tracking of references to objects
    -port <port>:     Set the port for the HTTP server.  Defaults to 7000
    -exclude <file>:  Specify a file that lists data members that should
              be excluded from the reachableFrom query.
    -baseline <file>: Specify a baseline object dump.  Objects in
              both heap dumps with the same ID and same class will
              be marked as not being "new".
    -debug <int>:     Set debug level.
                0:  No debug output
                1:  Debug hprof file parsing
                2:  Debug hprof file parsing, no server
    -version          Report version number
    -h|-help          Print this help and exit
    <file>            The file to read
```
-stack false|true
关闭对象分配调用栈跟踪(tracking object allocation call stack)。 如果分配位置信息在堆转储中不可用. 则必须将此标志设置为 false. 默认值为 true.
-refs false|true
关闭对象引用跟踪(tracking of references to objects)。 默认值为 true. 默认情况下, 返回的指针是指向其他特定对象的对象,如反向链接或输入引用(referrers or incoming references), 会统计/计算堆中的所有对象。
-port port-number
设置 jhat HTTP server 的端口号. 默认值 7000.
-exclude exclude-file
指定对象查询时需要排除的数据成员列表文件(a file that lists data members that should be excluded from the reachable objects query)。 例如, 如果文件列列出了 java.lang.String.value , 那么当从某个特定对象 Object o 计算可达的对象列表时, 引用路径涉及 java.lang.String.value 的都会被排除。
-baseline exclude-file
指定一个基准堆转储(baseline heap dump)。 在两个 heap dumps 中有相同 object ID 的对象会被标记为不是新的(marked as not being new). 其他对象被标记为新的(new). 在比较两个不同的堆转储时很有用.
-debug int
设置 debug 级别. 0 表示不输出调试信息。 值越大则表示输出更详细的 debug 信息.
-version
启动后只显示版本信息就退出
-J< flag >
因为 jhat 命令实际上会启动一个JVM来执行, 通过 -J 可以在启动JVM时传入一些启动参数. 例如, -J-Xmx512m 则指定运行 jhat 的Java虚拟机使用的最大堆内存为 512 MB. 如果需要使用多个JVM启动参数,则传入多个 -Jxxxxxx.

### OQL
jhat还提供了一种对象查询语言(Object Query Language)，OQL有点类似SQL,可以用来查询。
OQL语句的执行页面: http://localhost:7000/oql/
OQL帮助信息页面为: http://localhost:7000/oqlhelp/
OQL的预发可以在帮助页面查看，这里就不详细讲解了。
参考资料
jhat
