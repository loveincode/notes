### 第一，谈谈final, finally, finalize的区别。
  final?修饰符（关键字）如果一个类被声明为final，意味着它不能再派生出新的子类，不能作为父类被继承。因此一个类不能既被声明为 abstract的，又被声明为final的。将变量或方法声明为final，可以保证它们在使用中不被改变。被声明为final的变量必须在声明时给定初值，而在以后的引用中只能读取，不可修改。被声明为final的方法也同样只能使用，不能重载 。


  finally?再异常处理时提供 finally 块来执行任何清除操作。如果抛出一个异常，那么相匹配的 catch 子句就会执行，然后控制就会进入 finally 块（如果有的话）。


  finalize?方法名。Java 技术允许使用 finalize() 方法在垃圾收集器将对象从内存中清除出去之前做必要的清理工作。这个方法是由垃圾收集器在确定这个对象没有被引用时对这个对象调用的。它是在 Object类中定义的，因此所有的类都继承了它。子类覆盖 finalize() 方法以整理系统资源或者执行其他清理工作。finalize() 方法是在垃圾收集器删除对象之前对这个对象调用的。

### 第二，HashMap和Hashtable的区别。
  都属于Map接口的类，实现了将惟一键映射到特定的值上。
  HashMap 类没有分类或者排序。它允许一个 null 键和多个 null 值。
  Hashtable 类似于 HashMap，但是不允许 null 键和 null 值。它也比 HashMap 慢，因为它是同步的。

### 第三，String s = new String("xyz");创建了几个String Object?
  两个对象，一个是“xyx”,一个是指向“xyx”的引用对象s。

## 第四，sleep() 和 wait() 有什么区别? 搞线程的最爱
  sleep()方法是使线程停止一段时间的方法。在sleep 时间间隔期满后，线程不一定立即恢复执行。这是因为在那个时刻，其它线程可能正在运行而且没有被调度为放弃执行，除非(a)“醒来”的线程具有更高的优先级 。
  (b)正在运行的线程因为其它原因而阻塞。
  wait()是线程交互时，如果线程对一个同步对象x 发出一个wait()调用，该线程会暂停执行，被调对象进入等待状态，直到被唤醒或等待时间到。

### 第五，short s1 = 1; s1 = s1 + 1;有什么错? short s1 = 1; s1 += 1;有什么错?
  short s1 = 1; s1 = s1 + 1;有错，s1是short型，s1+1是int型,不能显式转化为short型。可修改为s1 =(short)(s1 + 1) 。short s1 = 1; s1 += 1正确。

### 第六，Overload和Override的区别。Overloaded的方法是否可以改变返回值的类型?
  方法的重写Overriding和重载Overloading是Java多态性的不同表现。重写Overriding是父类与子类之间多态性的一种表现，重载Overloading是一个类中多态性的一种表现。如果在子类中定义某方法与其父类有相同的名称和参数，我们说该方法被重写 (Overriding)。子类的对象使用这个方法时，将调用子类中的定义，对它而言，父类中的定义如同被“屏蔽”了。如果在一个类中定义了多个同名的方法，它们或有不同的参数个数或有不同的参数类型，则称为方法的重载(Overloading)。Overloaded的方法是可以改变返回值的类型。

### 第七，Set里的元素是不能重复的，那么用什么方法来区分重复与否呢? 是用==还是equals()? 它们有何区别?
  Set里的元素是不能重复的，那么用iterator()方法来区分重复与否。equals()是判读两个Set是否相等。
  equals()和==方法决定引用值是否指向同一对象equals()在类中被覆盖，为的是当两个分离的对象的内容和类型相配的话，返回真值。

### 第八，error和exception有什么区别?
  error 表示恢复不是不可能但很困难的情况下的一种严重问题。比如说内存溢出。不可能指望程序能处理这样的情况。
  exception 表示一种设计或实现问题。也就是说，它表示如果程序运行正常，从不会发生的情况。

### 第九，给我一个你最常见到的runtime exception。

  ArithmeticException, ArrayStoreException,
  BufferOverflowException, BufferUnderflowException,
  CannotRedoException, CannotUndoException,
  ClassCastException, CMMException,
  ConcurrentModificationException, DOMException,
  EmptyStackException, IllegalArgumentException,
  IllegalMonitorStateException, IllegalPathStateException,
  IllegalStateException, ImagingOpException,
  IndexOutOfBoundsException, MissingResourceException,
  NegativeArraySizeException, NoSuchElementException,
  NullPointerException, ProfileDataException,
  ProviderException, RasterFormatException, SecurityException,
  SystemException, UndeclaredThrowableException,
  UnmodifiableSetException, UnsupportedOperationException


### 第十，Set里的元素是不能重复的，那么用什么方法来区分重复与否呢? 是用==还是equals()? 它们有何区别?
  Set里的元素是不能重复的，那么用iterator()方法来区分重复与否。equals()是判读两个Set是否相等。
  equals()和==方法决定引用值是否指向同一对象equals()在类中被覆盖，为的是当两个分离的对象的内容和类型相配的话，返回真值。  
