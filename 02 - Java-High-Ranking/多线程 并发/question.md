``` java
public static void main(String[]args)throws Exception {
    final Object obj = new Object();

    Thread t1 = new Thread() {
        public void run() {
            synchronized (obj) {
                try {
                    obj.wait();
                    System.out.println("Thread 1 wake up.");
                } catch (InterruptedException e) {
                }
            }
        }
    };
    t1.start();
    Thread.sleep(1000);//We assume thread 1 must start up within 1 sec.

    Thread t2 = new Thread() {
        public void run() {
            synchronized (obj) {
                obj.notifyAll();
                System.out.println("Thread 2 sent notify.");
            }
        }
    };
    t2.start();
}
```
``` output
Thread 2 sent notify.
Thread 1 wake up

执行obj.wait();时已释放了锁，所以t2可以再次获得锁，然后发消息通知t1执行，但这时t2还没有释放锁，所以肯定是执行t2，然后释放锁，之后t1才有机会执行。
```
### Thread run方法和start方法的区别
1.start方法
     用 start方法来启动线程，是真正实现了多线程， 通过调用Thread类的start()方法来启动一个线程，这时此线程处于就绪（可运行）状态，并没有运行，一旦得到cpu时间片，就开始执行run()方法。但要注意的是，此时无需等待run()方法执行完毕，即可继续执行下面的代码。所以run()方法并没有实现多线程。
2.run方法
     run()方法只是类的一个普通方法而已，如果直接调用Run方法，程序中依然只有主线程这一个线程，其程序执行路径还是只有一条，还是要顺序执行，还是要等待run方法体执行完毕后才可继续执行下面的代码。

     run()方法就是一个普通的方法，真正启动一个新线程的话是start()

     run方法是线程内重写的一个方法，start一个线程后使得线程处于就绪状态，当jvm调用的时候，线程启动会运行run。run函数是线程里面的一个函数不是多线程的。
