proc/uptime
6447032.12 48185264.69


第一个属性 系统启动到现在的时间（以秒为单位） 这里简记为num1；
第二个属性 系统空闲的时间（以秒为单位）这里简记为num2。


### 注意

1. 很多很多人都知道第二个是系统空闲的时间，但是可能你不知道是，
在SMP系统里，系统空闲的时间有时会是系统运行时间的几倍，这是怎么回事呢？
因为系统空闲时间的计算，是把SMP算进去的，就是所你有几个逻辑的CPU（包括超线程）。

2. 系统的空闲率(%) = num2/(num1*N) 其中N是SMP系统中的CPU个数。


从上面我的一台机器上的数据可知，
本机启动到现在的时间长度为：6447032.12 seconds = 74.6 days
空闲率为:48185264.69/(6447032.12*8)=93.4%

1202784.33 9578247.37


系统空闲率越大，说明系统比较闲，可以加重一些负载；而系统空闲率很小，则可能考虑升级本机器硬件或者迁移部分负载到其他机器上。

Some docs from Redhat:
The first number is the total number of seconds the system has been up. The second number is how much of that time the machine has spent idle, in seconds. (Jay’s comments: Please pay attention to SMP system.)
