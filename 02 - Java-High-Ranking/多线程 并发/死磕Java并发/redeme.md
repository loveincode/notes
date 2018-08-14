from http://cmsblogs.com/


### 01 - 深入分析synchronized 的实现原理

synchronized 可以保证方法或者代码块在运行时，**同一时刻只有一个方法** 可以进入到临界区，同时它还可以保证共享变量的内存可见性。深入分析 synchronized 的内在实现机制，锁优化、锁升级过程。

### 02 - 深入分析volatile的实现原理

volatile 可以保证线程可见性且提供了一定的 **有序性**，但是 **无法保证原子性**。在 JVM 底层 volatile 是采用 **“内存屏障”** 来实现的。这篇博文将带你分析 volatile 的本质

### 03 - Java内存模型之happens-before

happens-before 原则是判断数据是否存在竞争、线程是否安全的主要依据，保证了多线程环境下的可见性。

定义如下：

如果一个操作happens-before另一个操作，那么第一个操作的执行结果将对第二个操作可见，而且第一个操作的执行顺序排在第二个操作之前。
两个操作之间存在happens-before关系，并不意味着一定要按照happens-before原则制定的顺序来执行。如果重排序之后的执行结果与按照happens-before关系来执行的结果一致，那么这种重排序并不非法。

### 04 - Java内存模型之重排序

在执行程序时，为了提供性能，处理器和编译器常常会对指令进行重排序，但是不能随意重排序，不是你想怎么排序就怎么排序，它需要满足以下两个条件：

在单线程环境下不能改变程序运行的结果；
存在数据依赖关系的不允许重排序
as-if-serial 语义保证在单线程环境下重排序后的执行结果不会改变。

### 05 - Java内存模型之分析volatile

volatile的内存语义是：

当写一个 volatile 变量时，JMM 会把该线程对应的本地内存中的共享变量值立即刷新到主内存中。
当读一个 volatile 变量时，JMM 会把该线程对应的本地内存设置为无效，直接从主内存中读取共享变量
总是说 volatile 保证可见性，happens-before 是 JMM 实现可见性的基础理论，两者会碰撞怎样的火花？这篇博文给你答案。

### 06 - Java内存模型之从JMM角度分析DCL

DCL，即Double Check Lock，双重检查锁定。是实现单例模式比较好的方式，这篇博客告诉你 DCL 中为何要加 volatile 这个关键字。

### 08 - J.U.C之AQS：AQS简介

AQS，`AbstractQueuedSynchronizer`，即队列同步器。它是构建锁或者其他同步组件的基础框架（如ReentrantLock、ReentrantReadWriteLock、Semaphore等），为 JUC 并发包中的核心基础组件。

### 09 - J.U.C之AQS：CLH同步队列

前线程已经等待状态等信息构造成一个节点（Node）并将其加入到CLH同步队列，同时会阻塞当前线程，当同步状态释放时，会把首节点唤醒（公平锁），使其再次尝试获取同步状态。

### 10 - J.U.C之AQS：同步状态的获取与释放

AQS的设计模式采用的`模板方法模式`，子类通过继承的方式，实现它的抽象方法来管理同步状态，对于子类而言它并没有太多的活要做，AQS提供了大量的模板方法来实现同步，主要是分为三类：独占式获取和释放同步状态、共享式获取和释放同步状态、查询同步队列中的等待线程情况。

### 11 - J.U.C之AQS：阻塞和唤醒线程

当需要阻塞或者唤醒一个线程的时候，AQS 都是使用 LockSupport 这个工具类来完成。

LockSupport是用来创建锁和其他同步类的基本线程阻塞原语。

### 12 - J.U.C之重入锁：ReentrantLock

一个可重入的互斥锁定 Lock，它具有与使用 synchronized 方法和语句所访问的隐式监视器锁定相同的一些基本行为和语义，但功能更强大。ReentrantLock 将由最近成功获得锁定，并且还没有释放该锁定的线程所拥有。当锁定没有被另一个线程所拥有时，调用 lock 的线程将成功获取该锁定并返回。如果当前线程已经拥有该锁定，此方法将立即返回。可以使用 isHeldByCurrentThread() 和 getHoldCount() 方法来检查此情况是否发生。

这篇博客带你理解 重入锁：ReentrantLock 内在本质。

### 13 - J.U.C之读写锁：ReentrantReadWriteLock

读写锁维护着一对锁，一个读锁和一个写锁。通过分离读锁和写锁，使得并发性比一般的排他锁有了较大的提升：在同一时间可以允许多个读线程同时访问，但是在写线程访问时，所有读线程和写线程都会被阻塞。

读写锁的主要特性：

公平性：支持公平性和非公平性。
重入性：支持重入。读写锁最多支持65535个递归写入锁和65535个递归读取锁。
锁降级：遵循获取写锁、获取读锁在释放写锁的次序，写锁能够降级成为读锁

### 14 - J.U.C之Condition

在没有Lock之前，我们使用synchronized来控制同步，配合Object的wait()、notify()系列方法可以实现等待/通知模式。在Java SE5后，Java提供了Lock接口，相对于Synchronized而言，Lock提供了条件Condition，对线程的等待、唤醒操作更加详细和灵活

### 15 - 深入分析CAS

CAS，Compare And Swap，即比较并交换。Doug lea大神在同步组件中大量使用 CAS 技术鬼斧神工地实现了Java 多线程的并发操作。整个 AQS 同步组件、Atomic 原子类操作等等都是以 CAS 实现的。可以说CAS是整个JUC的基石。

### 16 - J.U.C之并发工具类：CyclicBarrier

CyclicBarrier，一个同步辅助类。它允许一组线程互相等待，直到到达某个公共屏障点 (common barrier point)。在涉及一组固定大小的线程的程序中，这些线程必须不时地互相等待，此时 CyclicBarrier 很有用。因为该 barrier 在释放等待线程后可以重用，所以称它为循环 的 barrier。

### 17 - J.U.C之并发工具类：CountDownLatch

CountDownLatch 所描述的是”在完成一组正在其他线程中执行的操作之前，它允许一个或多个线程一直等待“。

用给定的计数 初始化 CountDownLatch。由于调用了 countDown() 方法，所以在当前计数到达零之前，await 方法会一直受阻塞。之后，会释放所有等待的线程，await 的所有后续调用都将立即返回。

### 18 - J.U.C之并发工具类：Semaphore

Semaphore，信号量，是一个控制访问多个共享资源的计数器。从概念上讲，信号量维护了一个许可集。如有必要，在许可可用前会阻塞每一个 acquire()，然后再获取该许可。每个 release() 添加一个许可，从而可能释放一个正在阻塞的获取者。但是，不使用实际的许可对象，Semaphore 只对可用许可的号码进行计数，并采取相应的行动。

### 19 - J.U.C之并发工具类：Exchanger

可以在对中对元素进行配对和交换的线程的同步点。每个线程将条目上的某个方法呈现给 exchange 方法，与伙伴线程进行匹配，并且在返回时接收其伙伴的对象。Exchanger 可能被视为 SynchronousQueue 的双向形式。Exchanger 可能在应用程序（比如遗传算法和管道设计）中很有用。

### 20 - J.U.C之Java并发容器：ConcurrentHashMap

ConcurrentHashMap 作为 Concurrent 一族，其有着高效地并发操作。在1.8 版本以前，ConcurrentHashMap 采用`分段锁`的概念，使`锁更加细化`，但是 1.8 已经改变了这种思路，而是利用 `CAS + Synchronized` 来保证并发更新的安全，当然底层采用`数组+链表+红黑树`的存储结构。这篇博客带你彻底理解 ConcurrentHashMap。

### 21 - J.U.C之ConcurrentHashMap红黑树转换分析

在 1.8 ConcurrentHashMap 的put操作中，如果发现链表结构中的元素超过了TREEIFY_THRESHOLD（默认为8），则会把链表转换为`红黑树`，已便于提高查询效率。那么具体的转换过程是怎么样的？这篇博客给你答案。

### 22 - J.U.C之Java并发容器：ConcurrentLinkedQueue

ConcurrentLinkedQueue是一个基于链接节点的无边界的线程安全队列，它采用FIFO原则对元素进行排序。采用“wait-free”算法（即CAS算法）来实现的。

CoucurrentLinkedQueue规定了如下几个不变性：

在入队的最后一个元素的next为null
队列中所有未删除的节点的item都不能为null且都能从head节点遍历到
对于要删除的节点，不是直接将其设置为null，而是先将其item域设置为null（迭代器会跳过item为null的节点）
允许head和tail更新滞后。这是什么意思呢？意思就说是head、tail不总是指向第一个元素和最后一个元素（后面阐述）。
### 22 - J.U.C之Java并发容器：ConcurrentSkipListMap

我们在Java世界里看到了两种实现key-value的数据结构：Hash、TreeMap，这两种数据结构各自都有着优缺点。

Hash表：插入、查找最快，为O(1)；如使用链表实现则可实现无锁；数据有序化需要显式的排序操作。
红黑树：插入、查找为O(logn)，但常数项较小；无锁实现的复杂性很高，一般需要加锁；数据天然有序。
这里介绍第三种实现 key-value 的数据结构：SkipList。SkipList 有着不低于红黑树的效率，但是其原理和实现的复杂度要比红黑树简单多了。

ConcurrentSkipListMap 其内部采用 SkipLis 数据结构实现。

### 23 - J.U.C之阻塞队列：ArrayBlockingQueue

ArrayBlockingQueue，一个由数组实现的有界阻塞队列。该队列采用FIFO的原则对元素进行排序添加的。

ArrayBlockingQueue 为有界且固定，其大小在构造时由构造函数来决定，确认之后就不能再改变了。ArrayBlockingQueue 支持对等待的生产者线程和使用者线程进行排序的可选公平策略，但是在默认情况下不保证线程公平的访问，在构造时可以选择公平策略（fair = true）。公平性通常会降低吞吐量，但是减少了可变性和避免了“不平衡性”。

### 24 - J.U.C之阻塞队列：PriorityBlockingQueue

PriorityBlockingQueue是一个支持优先级的无界阻塞队列。默认情况下元素采用自然顺序升序排序，当然我们也可以通过构造函数来指定Comparator来对元素进行排序。需要注意的是PriorityBlockingQueue不能保证同优先级元素的顺序。

### 25 - J.U.C之阻塞队列：DelayQueue

DelayQueue是一个支持延时获取元素的无界阻塞队列。里面的元素全部都是“可延期”的元素，列头的元素是最先“到期”的元素，如果队列里面没有元素到期，是不能从列头获取元素的，哪怕有元素也不行。也就是说只有在延迟期到时才能够从队列中取元素。

DelayQueue主要用于两个方面：

缓存：清掉缓存中超时的缓存数据
任务超时处理
### 26 - J.U.C之阻塞队列：SynchronousQueue

SynchronousQueue与其他BlockingQueue有着不同特性：

SynchronousQueue没有容量。与其他BlockingQueue不同，SynchronousQueue是一个不存储元素的BlockingQueue。每一个put操作必须要等待一个take操作，否则不能继续添加元素，反之亦然。
因为没有容量，所以对应 peek, contains, clear, isEmpty ... 等方法其实是无效的。例如clear是不执行任何操作的，contains始终返回false,peek始终返回null。
SynchronousQueue分为公平和非公平，默认情况下采用非公平性访问策略，当然也可以通过构造函数来设置为公平性访问策略（为true即可）。
若使用 TransferQueue, 则队列中永远会存在一个 dummy node（这点后面详细阐述）。
SynchronousQueue非常适合做交换工作，生产者的线程和消费者的线程同步以传递某些信息、事件或者任务。

### 27 - J.U.C之阻塞队列：LinkedTransferQueue

LinkedTransferQueue 是基于链表的 FIFO 无界阻塞队列，它出现在 JDK7 中。Doug Lea 大神说 LinkedTransferQueue 是一个聪明的队列。它是 ConcurrentLinkedQueue、SynchronousQueue (公平模式下)、无界的LinkedBlockingQueues 等的超集。

### 28 - J.U.C之阻塞队列：LinkedBlockingDeque

LinkedBlockingDeque 是一个由链表组成的双向阻塞队列，双向队列就意味着可以从对头、对尾两端插入和移除元素，同样意味着 LinkedBlockingDeque 支持 FIFO、FILO 两种操作方式。

LinkedBlockingDeque 是可选容量的，在初始化时可以设置容量防止其过度膨胀，如果不设置，默认容量大小为 Integer.MAX_VALUE。

### 30 - 深入分析ThreadLocal

ThreadLocal 提供了线程局部 (thread-local) 变量。这些变量不同于它们的普通对应物，因为访问某个变量（通过其get 或 set 方法）的每个线程都有自己的局部变量，它独立于变量的初始化副本。ThreadLocal实例通常是类中的 private static 字段，它们希望将状态与某一个线程（例如，用户 ID 或事务 ID）相关联。

所以ThreadLocal与线程同步机制不同，线程同步机制是多个线程共享同一个变量，而ThreadLocal是为每一个线程创建一个单独的变量副本，故而每个线程都可以独立地改变自己所拥有的变量副本，而不会影响其他线程所对应的副本。可以说ThreadLocal为多线程环境下变量问题提供了另外一种解决思路。

### 31 - J.U.C之线程池：ThreadPoolExecutor

鼎鼎大名的线程池。不需要多说!!!!!

这篇博客深入分析 Java 中线程池的实现。

### 32 - J.U.C之线程池：ScheduledThreadPoolExecutor

ScheduledThreadPoolExecutor 是实现线程的周期、延迟调度的。

ScheduledThreadPoolExecutor，继承 ThreadPoolExecutor 且实现了 ScheduledExecutorService 接口，它就相当于提供了“延迟”和“周期执行”功能的 ThreadPoolExecutor。在JDK API中是这样定义它的：ThreadPoolExecutor，它可另行安排在给定的延迟后运行命令，或者定期执行命令。需要多个辅助线程时，或者要求 ThreadPoolExecutor 具有额外的灵活性或功能时，此类要优于 Timer。 一旦启用已延迟的任务就执行它，但是有关何时启用，启用后何时执行则没有任何实时保证。按照提交的先进先出 (FIFO) 顺序来启用那些被安排在同一执行时间的任务。
