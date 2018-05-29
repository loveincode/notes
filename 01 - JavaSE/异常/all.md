都是Throwable的子类：
1.Exception（异常） :是程序本身可以处理的异常。
2.Error（错误）: 是程序无法处理的错误。这些错误表示故障发生于虚拟机自身、或者发生在虚拟机试图执行应用时，一般不需要程序处理。
3.检查异常（编译器要求必须处置的异常） ：  除了Error，RuntimeException及其子类以外，其他的Exception类及其子类都属于可查异常。这种异常的特点是Java编译器会检查它，也就是说，当程序中可能出现这类异常，要么用try-catch语句捕获它，要么用throws子句声明抛出它，否则编译不会通过。

4.非检查异常(编译器不要求处置的异常): 包括运行时异常（RuntimeException与其子类）和错误（Error）。


checked exception：指的是编译时异常，该类异常需要本函数必须处理的，用try和catch处理，或者用throws抛出异常，然后交给调用者去处理异常。
runtime exception：指的是运行时异常，该类异常不必须本函数必须处理，当然也可以处理。

Thread.sleep()抛出的InterruptException属于checked exception；IllegalArgumentException属于Runtime exception;

Throwable 可以用来表示任何可以作为异常抛出的类，分为两种： Error 和 Exception。其中 Error 用来表示 JVM 无法处理的错误，Exception 分为两种：

受检异常 ：需要用 try...catch... 语句捕获并进行处理，并且可以从异常中恢复；
非受检异常 ：是程序运行时错误，例如除 0 会引发 Arithmetic Exception，此时程序奔溃并且无法恢复。

Java 入门之异常处理  https://www.tianmaying.com/tutorial/Java-Exception
Java 异常的面试问题及答案 -Part 1 http://www.importnew.com/7383.html
