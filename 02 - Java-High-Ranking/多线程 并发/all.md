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


##### InterruptedException
抛InterruptedException的代表方法有：

java.lang.Object 类的 wait 方法
java.lang.Thread 类的 sleep 方法
java.lang.Thread 类的 join 方法
