http://images.cnblogs.com/cnblogs_com/loveincode/1037824/o_164d94300b13d901.png
引入线程为了 **提高系统的执行效率**，减少处理机的空转时间和调度切换的时间，以及便于系统管理

并行
并发
并发是针对进程的，并发是针对线程的
### 1. 线程状态
  基本状态：执行 、 就绪 、阻塞

### 线程问题
  线程安全问题
  性能问题

  *对象的发布与逸出*
    静态域逸出
    public修饰的get方法
    方法参数传值
    隐式的this
    逸出就是本不应该发布对象的地方，把对象发布了，导致我们的数据泄露出去了，这就造成了一个安全隐患。

  *安全发布对象*
    在静态域中直接初始化，静态初始化由JVM在类的初始化阶段就执行了，JVM内部存在着同步机制，致使这种方式我们可以安全发布对象
    对应的引用保存到volatile或者AtomicReferance引用中，保证该对象的引用的可见性和原子性
    由final修饰，不可变
    由锁来保护

  *解决线程安全性的方法*

    无状态（没有共享变量） 只要我们保证不要在栈（方法）上发布对象（每个变量的作用域仅仅停留在此方法上），那么我们的线程就是安全的
    使用final使该引用变量不可变
    加锁（内置锁，显示lock锁）
      原子性 atomic包下的类 count++这个操作就不是一个原子性操作
      可见性
        volatile 保证该变量对所有线程的可见性，但不保证原子性
        1. 一旦你完成写入，任何访问这个字段的线程将会得到最新的值
        2. 会保证所有之前发生的事已经发生，并且任何更新过的数据值也是可见的，内存屏障会把之前的写入值都刷新到缓存。
        3. volatile可以防止重排序
      JDK提供的 原子性（atomic） 容器（concurrenthashmap等等）

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
1.继承Thread类，重载run方法；
2.实现Runnable接口，实现run方法
1. Thread
  yield() 调用yield方法会 **先让别的线程执行，但不确保真正让出**
  sleep() 调用sleep方法会进入计时等待状态，等 **时间到了，进入的是就绪状态而并非运行状态**
  join()  调用join方法，**会等待该线程执行完毕后才执行别的线程**
  interrupte() 不会真正的停止一个线程，它仅仅是给这个线程发一个信号告诉它，它应该要结束了。interrupte()方法压根是不会对线程的状态造成影响的，它仅仅设置一个标志位罢了。
  静态方法 Thread.interrupted() 会清除中断标志位
  实例方法 isInterrupted() 不会清楚中断标志位
  setPriority(int newPriority)
  线程名 主线程叫做main，其他线程是thread-x
  **守护线程**  守护线程做为一个服务线程，没有服务对象就没有必要执行了。
    在线程启动前设置守护线程，方法是setDaemon(boolean on)
    使用守护线程不要访问共享资源（数据库，文件等），因为它可能会在任何时候就挂掉了。
    守护线程中产生的新线程也是守护线程
2. Runnable
3. Callable Callback
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
#### 8.4 锁
  *synchronized*
  synchronized能够将代码块（方法）锁起来
  **互斥锁**，一次只能进入允许一个线程进入被锁住的代码块
  synchronized是一种 **内置锁/监视器锁**  Java每个对象都有一个内置锁（监视器锁，可以理解为锁标记）
  **底层通过monitor对象，对象有自己的对象头，存储了很多信息，其中一个信息标识是被哪个线程持有。**

  保证线程的原子性
  可见性

  静态方法获取的是类锁（类的字节码文件对象）
  synchronized修饰普通方法或代码块获取的是对象锁
  **获取了类锁的线程和获取了对象锁的线程是不冲突的**

  **可重入锁**  **锁的持有者是线程，而不是调用** (也叫做递归锁,指的是同一线程外层函数获得锁之后,内层递归函数仍然有获取该锁的代码,但不受影响) https://www.jb51.net/article/57338.htm

  锁升级 适应自旋锁、锁消除、锁粗化、轻量级锁、偏向锁

  *Lock*
  支持中断、超时不获取、是非阻塞的
  提高 **语义话**，哪里加锁，哪里解锁都得写出来
  允许多个线程同时访问共享资源（**读写锁**）

  **底层原理 AQS AbstractQueuedSynchronizer**
  AQS是一个实现锁的框架
  内部实现的关键：先进先出的队列、state状态
  定义了内部类ConditionObject
  提供两种线程模式  独占模式 共享模式

  修改state状态值时使用CAS算法来实现
  等待列被称为：CLH队列，是一个双向队列
  定义了框架，具体实现由子类来做（**模板模式**）

  三种实现
    ReentrantLock **比synchronized更有伸缩性，使用时标准用法是在try之前调用lock方法，在finally代码释放锁**
    ReentrantReadWriteLock state的变量高16位是读锁，低16位是写锁 读锁不能升级为写锁，写锁可以降级为读锁
    ReentrantReadWriteLock.ReadLock 读时共享
    ReentrantReadWriteLock.WriteLock 写时互斥

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
  Executors 提供了一种将 **任务提交** **任务执行** 分离开来的机制
  Executors接口 定义了执行任务的行为
  ExecutorServices接口 提供了线程池管理生命周期的方法
    newCachedThreadPool() 非常有弹性的线程池，对于新的任务，如果此时线程池里没有空闲线程，线程池会毫不犹豫的创建一条新的线程去处理这个任务
    newSingleThreadExecutor() 单个worker线程的Executor
    newFixedThreadPool() 返回一个corePoolSize和maximumPoolSize相等的线程池
  执行线程
    submit()
    execute()
  线程池关闭
    shutdown() 线程池状态立刻变为Shutdown 等待任务执行完才中断线程
    shutdownnow() 线程池状态立刻变为Stop 不等任务执行完就中断了线程

  *策略*
  线程数量策略
    如果运行线程的数量少于核心线程数量，则创建新的线程处理请求

  线程空间策略

  排队策略

  拒绝任务策略

#### 8.7 同步器
  CountDownLatch 闭锁 某个线程等待其他线程执行完毕后，它才执行（其他线程等待某个线程执行完毕后，它才执行）
  CyclicBarrier 栅栏 一旦线程互相等待至某个状态，这组线程再同时执行
  Semphore 信号量 控制一组线程同时执行
  Exchanger
  SynchronousQueue
#### 8.8 并发容器与同步容器对比
同步容器对于并发读访问的支持不好
由于内部多采用synchronized关键字实现,所以性能不如并发容器
对于同步容器进行迭代的同时修改它的内容，会报ConcurrentModificationException异常



##### InterruptedException
抛InterruptedException的代表方法有：

java.lang.Object 类的 wait 方法
java.lang.Thread 类的 sleep 方法
java.lang.Thread 类的 join 方法
