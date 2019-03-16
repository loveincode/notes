## LinkedList

[LinkedList.java](https://github.com/CyC2018/JDK-Source-Code/tree/master/src/LinkedList.java)

### 1. 概览

基于双向链表实现，内部使用 Node 来存储链表节点信息。

```java
private static class Node<E> {
    E item;
    Node<E> next;
    Node<E> prev;
}
```

每个链表存储了 Head 和 Tail 指针：

```java
transient Node<E> first;
transient Node<E> last;
```

<div align="center"> <img src="/image/01/Iterator/HowLinkedListWorks.png"/> </div><br>

### 2. ArrayList 与 LinkedList

- ArrayList 基于动态数组实现，LinkedList 基于双向链表实现；
- ArrayList 支持随机访问，LinkedList 不支持；
- LinkedList 在任意位置添加删除元素更快。
