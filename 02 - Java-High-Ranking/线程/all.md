### 1. 线程状态
### 2. 每个对象都有同步方法：
synchronized
wait
notify  **wait/notify必须存在于synchronised中**
await
signal/signalAll
### 3. 每个对象都有一个monitor,用来检测并发代码重入
### 4. 同步与通信
### 5. volatile
JVM内存模型
处理数据时，线程会把值从主存load到本地栈，完成之后在save回去。
每次针对该关键字修饰的变量的操作都会引起一次load and save,保存可见性
### 6. 基本实现
1. Thread
  yield()
  sleep()
  join()
  interrupte()
  Thread.interrupted()
  setPriority(int newPriority)
2. Runnable
3. Callback
  带返回值的Runnable,返回值Future
  Future
    判断任务是否完成
    能够中断任务
    能够获取任务执行结果
  两种模式
    非阻塞:isDone获取返回值时,如果线程未执行完返回false，否则返回true
    阻塞:get()获取返回值，阻塞至该线程结束。
### 7. 中断
每个线程都有中断标识位,线程会不断的检测改标志位,线程检测到中断后不会中断正在运行的线程,而是抛出InterruptedException
### 8. 高效使用 java 1.5中的java.util.concurent包提供大量工具
#### 8.1 ThreadLocal
#### 8.2 原子类
AtomicInteger compareAndSet()可实现乐观锁
AtomicBoolean
AtomicLong
#### 8.3 AtomicReference
#### 8.4 Lock
  三种实现
    ReentrantLock
    ReentrantReadWriteLock.ReadLock
    ReentrantReadWriteLock.WriteLock
  加锁方式
    组塞式:lock
    非阻塞:trylock
    可中断:lockinterruptily
  Condition
  解锁unlock  **为了避免错误,该方法一定要放在finally语句块中**
#### 8.5 并发容器
  BlockingQueue **实现生产者消费者模型的神奇**
    ArrayListBlockingQueue
    LinkedListBlockingQueue
    DelayQueue
    PriorityBlockingQueue
  ConcurrentLinkQueue
  ConcurrentHashMap
  CopyOnWriteArrayList
  在迭代并发容器时修改其内容并不会抛出ConcurrentModificationException异常
  在并发容器内部实现中尽量避免了synchronized关键字,从而增强了并发性
#### 8.6 线程池
  ThreadPoolExecutor
  Executors
    newCachedThreadPool()
    newSingleThreadExecutor()
    newFixedThreadPool()
  执行线程
    submit()
    execute()
  线程池关闭
    shutdown()
    shutdownnow()
#### 8.7 同步器
  CyclicBarrier
  CountDownLatch
  Exchanger
  Semphore
  SynchronousQueue
#### 8.8 并发容器与同步容器对比
同步容器对于并发读访问的支持不好
由于内部多采用synchronized关键字实现,所以性能不如并发容器
对于同步容器进行迭代的同时修改它的内容，会报ConcurrentModificationException异常
