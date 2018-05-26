
Iterator  支持从源集合中安全地删除对象，只需在 Iterator 上调用 remove() 即可。
这样做的好处是可以避免 ConcurrentModifiedException ，当打开 Iterator 迭代集合时，同时又在对集合进行修改。
有些集合不允许在迭代时删除或添加元素，但是调用 Iterator 的remove() 方法是个安全的做法。

如果在循环的过程中调用集合的remove()方法，就会导致循环出错，例如：
for(int i=0;i<list.size();i++){
    list.remove(...);
}
循环过程中list.size()的大小变化了，就导致了错误。
所以，如果你想在循环语句中删除集合中的某个元素，就要用迭代器iterator的remove()方法，因为它的remove()方法不仅会删除元素，还会维护一个标志，用来记录目前是不是可删除状态，例如，你不能连续两次调用它的remove()方法，调用之前至少有一次next()方法的调用。


源码是这么描述的：ArrayList 继承了 AbstractList， 其中AbstractList 中有个modCount 代表了集合修改的次数。在ArrayList的iterator方法中会判断 expectedModCount与 modCount是否相等，如果相等继续执行，不相等报错，只有iterator的remove方法会在调用自身的remove之后让 expectedModCount与modCount再相等，所以是安全的。
