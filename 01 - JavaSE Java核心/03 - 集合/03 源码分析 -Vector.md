## Vector

[Vector.java](https://github.com/CyC2018/JDK-Source-Code/tree/master/src/Vector.java)

### 1. 同步

它的实现与 ArrayList 类似，但是使用了 synchronized 进行同步。

```java
public synchronized boolean add(E e) {
    modCount++;
    ensureCapacityHelper(elementCount + 1);
    elementData[elementCount++] = e;
    return true;
}

public synchronized E get(int index) {
    if (index >= elementCount)
        throw new ArrayIndexOutOfBoundsException(index);

    return elementData(index);
}
```

### 2. ArrayList 与 Vector

- Vector 和 ArrayList 几乎是完全相同的，唯一的区别在于 Vector 是同步的，因此开销就比 ArrayList 要大，访问速度更慢。最好使用 ArrayList 而不是 Vector，因为同步操作完全可以由程序员自己来控制；
- Vector 每次扩容请求其大小的 2 倍空间，而 ArrayList 是 1.5 倍。

### 3. Vector 替代方案

为了获得线程安全的 ArrayList，可以使用 Collections.synchronizedList(); 得到一个线程安全的 ArrayList，也可以使用 concurrent 并发包下的 CopyOnWriteArrayList 类；

```java
List<String> list = new ArrayList<>();
List<String> synList = Collections.synchronizedList(list);
```

```java
List list = new CopyOnWriteArrayList();
```
