## 1 Java多线程技能
### 1.1 进程和多线程的概念及线程的优点
### 1.2 使用多线程
#### 1.2.1 继承Thread类
``` java
public class MyThread extends Thread{
	@Override
	public void run() {
		super.run();
		System.out.println("MyThread");
	}
}
public class Run {
	public static void main(String[] args) {
		MyThread myThread = new MyThread();
		myThread.start();
		System.out.println("运行结束！");
	}
}
```
    随机性

    执行start()方法的顺序不代表线程执行的顺序

#### 1.2.2 实现Runnable接口
``` Java
public class MyRunnable implements Runnable{
	@Override
	public void run() {
		System.out.println("н╦ллол!");
	}
}
public class Run {
	public static void main(String[] args) {
		Runnable runnable=new MyRunnable();
		Thread thread=new Thread(runnable);
		thread.start();
		System.out.println("运行结束!");
	}
}
```
#### 1.2.3 实例变量与线程安全
  synchronized

#### 1.2.4 留意i--与System.out.println()的异常
  println(i--)
  println()方法内部是同步的 但i--操作却是在进入println()之前发生的
  防止发生非线程安全问题，还是继续使用同步方法(synchronized)

### 1.3 currentThread()方法
  currentThread() 方法可返回代码段正在被那个线程调用的信息
  currentThread().getName()

### 1.4 isAlive()方法
  isAlive()方法判断当前的线程是否处于活动状态

### 1.5 sleep()方法
  sleep()方法

### 1.6 getId()方法
  getId()方法 作用是取得线程的唯一标识

### 1.7 停止线程
  停止不了的线程
  判断线程是否是停止状态
  能停止的线程——异常法
  在沉睡中停止
  能停止的线程——暴力法
  方法stop()与java.lang.ThreadDeath异常
  释放锁的不良后果
  使用return停止线程

### 1.8 暂停线程
  suspend与resume方法的使用
  suspend与resume方法的缺点——独占
  suspend与resume方法的缺点——不同步

### 1.9 yield方法

### 1.10 线程的优先级
  线程优先级的继承特性
  优先级具有规则性
  优先级具有随机性
  看谁运行得快

### 1.11 守护线程

	守护线程是一种特殊的线程，它的特性是由陪伴的含义，当进程中不存在非守护线程了，则守护线程自动销毁。

	典型的守护线程就是垃圾回收线程，当进程中没有非守护线程了，则垃圾回收线程也就没有存在的必要了，自动销毁。

	守护即线程的作用是为其他线程的运行提供便利服务，最典型的应用就是GC（垃圾回收器），他就是一个很称职的守护者。
