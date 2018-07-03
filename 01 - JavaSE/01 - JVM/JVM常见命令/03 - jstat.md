jstat(JVM Statistics Monitoring Tool)是 **用于监控虚拟机各种运行状态信息的命令行工具**。
他可以 **显示本地或远程虚拟机进程中的类装载、内存、垃圾收集、JIT编译等运行数据**，在没有GUI图形的服务器上，它是运行期定位虚拟机性能问题的首选工具。
jstat位于java的bin目录下，主要利用JVM内建的指令对Java应用程序的资源和性能进行实时的命令行的监控，包括了对Heap size和垃圾回收状况的监控。
可见，Jstat是轻量级的、专门针对JVM的工具，非常适用。
jstat 命令格式
 **jstat -<option> [-t] [-h<lines>] <vmid> [<interval> [<count>]]**
参数解释：
`Option` — 选项，我们一般使用 -gcutil 查看gc情况
`vmid` — VM的进程号，即当前运行的java进程号
`interval`- 间隔时间，单位为秒或者毫秒
`count` — 打印次数，如果缺省则打印无数次
参数interval和count代表查询间隔和次数，如果省略这两个参数，说明只查询一次。假设需要每250毫秒查询一次进程5828垃圾收集状况，一共查询5次，那命令行如下：
`jstat -gc 5828 250 5`
对于命令格式中的VMID与LVMID需要特别说明下：如果是本地虚拟机进程，
VMID(Virtual Machine IDentifier,虚机标识符)和LVMID(Local Virtual Machine IDentifier,虚机标识符)是一致的，
如果是远程虚拟机进程，那VMID的格式应当是：[protocol:][//] lvmid [@hostname[:port]/servername]

**option**
选项option代表这用户希望查询的虚拟机信息，主要分为3类：类装载、垃圾收集和运行期编译状况，具体选项及作用如下：
 * `–class` 监视类装载、卸载数量、总空间及类装载所耗费的时间
 * `–gc` 监视Java堆状况，包括Eden区、2个Survivor区、老年代、永久代等的容量
 * `–gccapacity` 监视内容与-gc基本相同，但输出主要关注Java堆各个区域使用到的最大和最小空间
 * `–gcutil` 监视内容与-gc基本相同，但输出主要关注已使用空间占总空间的百分比
 * `–gccause` 与-gcutil功能一样，但是会额外输出导致上一次GC产生的原因
 * `–gcnew` 监视新生代GC的状况
 * `–gcnewcapacity` 监视内容与-gcnew基本相同，输出主要关注使用到的最大和最小空间
 * `–gcold` 监视老年代GC的状况
 * `–gcoldcapacity` 监视内容与——gcold基本相同，输出主要关注使用到的最大和最小空间
 * `–gcpermcapacity` 输出永久代使用到的最大和最小空间
 * `–compiler` 输出JIT编译器编译过的方法、耗时等信息
 * `–printcompilation` 输出已经被JIT编译的方法

常见术语
1. `jstat –class<pid>` : 显示加载class的数量，及所占空间等信息。
Loaded 装载的类的数量 Bytes 装载类所占用的字节数 Unloaded 卸载类的数量 Bytes 卸载类的字节数 Time 装载和卸载类所花费的时间
2. `jstat -compiler <pid>`显示VM实时编译的数量等信息。
Compiled 编译任务执行数量 Failed 编译任务执行失败数量 Invalid 编译任务执行失效数量 Time 编译任务消耗时间 FailedType 最后一个编译失败任务的类型 FailedMethod 最后一个编译失败任务所在的类及方法
3. `jstat -gc <pid>`: 可以显示gc的信息，查看gc的次数，及时间。
S0C 年轻代中第一个survivor（幸存区）的容量 (字节) S1C 年轻代中第二个survivor（幸存区）的容量 (字节) S0U 年轻代中第一个survivor（幸存区）目前已使用空间 (字节) S1U 年轻代中第二个survivor（幸存区）目前已使用空间 (字节) EC 年轻代中Eden（伊甸园）的容量 (字节) EU 年轻代中Eden（伊甸园）目前已使用空间 (字节) OC Old代的容量 (字节) OU Old代目前已使用空间 (字节) PC Perm(持久代)的容量 (字节) PU Perm(持久代)目前已使用空间 (字节)YGC 从应用程序启动到采样时年轻代中gc次数 YGCT 从应用程序启动到采样时年轻代中gc所用时间(s) FGC 从应用程序启动到采样时old代(全gc)gc次数 FGCT 从应用程序启动到采样时old代(全gc)gc所用时间(s) GCT 从应用程序启动到采样时gc用的总时间(s)
4. `jstat -gccapacity <pid>`:可以显示，VM内存中三代（young,old,perm）对象的使用和占用大小
NGCMN 年轻代(young)中初始化(最小)的大小(字节) NGCMX 年轻代(young)的最大容量 (字节)NGC 年轻代(young)中当前的容量 (字节) S0C 年轻代中第一个survivor（幸存区）的容量 (字节) S1C 年轻代中第二个survivor（幸存区）的容量 (字节) EC 年轻代中Eden（伊甸园）的容量 (字节) OGCMN old代中初始化(最小)的大小 (字节) OGCMX old代的最大容量(字节) OGC old代当前新生成的容量 (字节) OC Old代的容量 (字节) PGCMN perm代中初始化(最小)的大小 (字节) PGCMX perm代的最大容量 (字节)
PGC perm代当前新生成的容量 (字节) PC Perm(持久代)的容量 (字节) YGC 从应用程序启动到采样时年轻代中gc次数 FGC 从应用程序启动到采样时old代(全gc)gc次数
5. `jstat -gcutil <pid>`:统计gc信息
S0 年轻代中第一个survivor（幸存区）已使用的占当前容量百分比 S1 年轻代中第二个survivor（幸存区）已使用的占当前容量百分比 E 年轻代中Eden（伊甸园）已使用的占当前容量百分比 O old代已使用的占当前容量百分比 P perm代已使用的占当前容量百分比 YGC 从应用程序启动到采样时年轻代中gc次数 YGCT 从应用程序启动到采样时年轻代中gc所用时间(s)FGC 从应用程序启动到采样时old代(全gc)gc次数 FGCT 从应用程序启动到采样时old代(全gc)gc所用时间(s) GCT 从应用程序启动到采样时gc用的总时间(s)
6. `jstat -gcnew <pid>`:年轻代对象的信息。
S0C 年轻代中第一个survivor（幸存区）的容量 (字节) S1C 年轻代中第二个survivor（幸存区）的容量 (字节) S0U 年轻代中第一个survivor（幸存区）目前已使用空间 (字节) S1U 年轻代中第二个survivor（幸存区）目前已使用空间 (字节) TT 持有次数限制 MTT 最大持有次数限制EC 年轻代中Eden（伊甸园）的容量 (字节) EU 年轻代中Eden（伊甸园）目前已使用空间 (字节) YGC 从应用程序启动到采样时年轻代中gc次数 YGCT 从应用程序启动到采样时年轻代中gc所用时间(s)
7. `jstat -gcnewcapacity<pid>`: 年轻代对象的信息及其占用量。
NGCMN 年轻代(young)中初始化(最小)的大小(字节) NGCMX 年轻代(young)的最大容量 (字节)NGC 年轻代(young)中当前的容量 (字节) S0CMX 年轻代中第一个survivor（幸存区）的最大容量 (字节) S0C 年轻代中第一个survivor（幸存区）的容量 (字节) S1CMX 年轻代中第二个survivor（幸存区）的最大容量 (字节) S1C 年轻代中第二个survivor（幸存区）的容量 (字节)ECMX 年轻代中Eden（伊甸园）的最大容量 (字节) EC 年轻代中Eden（伊甸园）的容量 (字节)YGC 从应用程序启动到采样时年轻代中gc次数 FGC 从应用程序启动到采样时old代(全gc)gc次数
8. `jstat -gcold <pid>`：old代对象的信息。
PC Perm(持久代)的容量 (字节) PU Perm(持久代)目前已使用空间 (字节) OC Old代的容量 (字节) OU Old代目前已使用空间 (字节) YGC 从应用程序启动到采样时年轻代中gc次数 FGC 从应用程序启动到采样时old代(全gc)gc次数 FGCT 从应用程序启动到采样时old代(全gc)gc所用时间(s) GCT 从应用程序启动到采样时gc用的总时间(s)
9. `stat -gcoldcapacity <pid>`: old代对象的信息及其占用量。
OGCMN old代中初始化(最小)的大小 (字节) OGCMX old代的最大容量(字节) OGC old代当前新生成的容量 (字节) OC Old代的容量 (字节) YGC 从应用程序启动到采样时年轻代中gc次数 FGC从应用程序启动到采样时old代(全gc)gc次数 FGCT 从应用程序启动到采样时old代(全gc)gc所用时间(s) GCT 从应用程序启动到采样时gc用的总时间(s)
10. `jstat -gcpermcapacity<pid>`: perm对象的信息及其占用量。
PGCMN perm代中初始化(最小)的大小 (字节) PGCMX perm代的最大容量 (字节)
PGC perm代当前新生成的容量 (字节) PC Perm(持久代)的容量 (字节) YGC 从应用程序启动到采样时年轻代中gc次数 FGC 从应用程序启动到采样时old代(全gc)gc次数 FGCT 从应用程序启动到采样时old代(全gc)gc所用时间(s) GCT 从应用程序启动到采样时gc用的总时间(s)
11. `jstat -printcompilation <pid>`：当前VM执行的信息。
Compiled 编译任务的数目 Size 方法生成的字节码的大小 Type 编译类型 Method 类名和方法名用来标识编译的方法。类名使用/做为一个命名空间分隔符。方法名是给定类中的方法。上述格式是由-XX:+PrintComplation选项进行设置的
