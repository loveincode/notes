1）.HashTable的方法前面都有synchronized来同步，是线程安全的；HashMap未经同步，是非线程安全的。
2）.HashTable不允许null值(key和value都不可以) ；HashMap允许null值(key和value都可以)。
3）.HashTable有一个contains(Objectvalue)功能和containsValue(Objectvalue)功能一样。
4）.HashTable使用Enumeration进行遍历；HashMap使用Iterator进行遍历。
5）.HashTable中hash数组默认大小是11，增加的方式是old*2+1；HashMap中hash数组的默认大小是16，而且一定是2的指数。
6）.哈希值的使用不同，HashTable直接使用对象的hashCode； HashMap重新计算hash值，而且用与代替求模。
