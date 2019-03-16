Timer的缺陷 用ScheduledExecutorService替代 http://blog.csdn.net/ni357103403/article/details/51889841

1、Timer管理延时任务的缺陷
以前在项目中也经常使用定时器，比如每隔一段时间清理项目中的一些垃圾文件，每个一段时间进行数据清洗；
然而Timer是存在一些缺陷的，因为Timer在执行定时任务时只会创建一个线程，所以如果存在多个任务，且任务时间过长，超过了两个任务的间隔时间，会发生一些缺陷

2、Timer当任务抛出异常时的缺陷

3、Timer执行周期任务时依赖系统时间

ScheduledExecutorService(JDK1.5以后)替代Timer。
