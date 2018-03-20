### 4.1 使用 **ReentrantLock**  类

#### 4.1.1-2 使用ReentrantLock实现同步  

  调用ReentrantLock对象的 **lock()** 方法 获取锁，调用 **unlock()** 方法释放锁。

#### 4.1.3-6 使用 **Condition** 实现等待/通知用法

  类ReentrantLock对象借助Condition对象实现等待/通知模式。

  在 **一个Lock对象** 里面可以创建 **多个Condition**(即对象监视器)实例，线程对象可以注册在指定的Condition中，从而可以有选择性地进行线程通知，在调度线程上更加灵活。

  在使用notify()/notifyAll()方法进行通知时，被通知的线程却是由JVM **随机** 选择的。但使用ReentrantLock结合 Condition类可以实现 **选择性通知**。

  而synchronize就相当于整个Lock对象中只有一个单一的Condition对象，所有的线程都注册在它一个对象的身上。线程开始notifyAll()时，需要通知所有的Waitting线程，没有选择权，会出现相当大的效率问题。

  Condition.**await()**  在lock.lock() 代码获得同步监视器后调用。

  Object wait()             Condition await()
  Object wait(long timeout) Condition **await(long time,TimeOut unit)**
  Object notify()           Condition signal()
  Object notifyAll()        Condition signalAll()

#### 4.1.9 公平锁和非公平锁

  锁Lock分为 **公平锁** 和 **非公平锁**
  公平锁表示线程获取锁的顺序是按照线程加锁的顺序来分配的，即先来先得的FIFO先进先出顺序。
  非公平锁就是一种获取锁的抢占机制，是随机获得锁的，和公平锁不一样的就是先来的不一定先得到锁。

  ReentrantLock lock = new ReentrantLock(isFair)
  ifFair **true** 为 **公平锁** **false** 为 **非公平锁**

#### 4.1.10-15  Lock 和 Condition 的方法

    Lock

    boolean hasQueuedThread(Thread thread)  查询指定的线程是否在等待获取此锁定

    boolean hasWaiters(Conditon condition)  查询是否有线程正在等待此锁定有关的condition条件

    boolean isFair()                        判断是不是公平锁

    boolean isHeldByCurrentThread()         查询当前线程是否保持此锁定

    boolean isLocked()                      查询此锁定是否由任意线程保持

    void    lockInterruptibly()             如果当前线程未被中断，则获取锁定，如果已经被中断则出现异常

    boolean tryLock()                       仅在调用时锁定未被另一个线程保持的情况下，才获取该锁定

    boolean tryLock(long timeout, TimeUnit unit)  如果锁定在给定等待时间内没有被另一个线程保持，且当前线程未被中断，则获取该锁定。

    Condition

    void    awaitUninterruptibly()  

    boolean awaitUntil(Date deadline)  

### 4.2 使用ReentrantReadWriteLock 类

  读写锁

  读 共享锁

  写 排它锁
