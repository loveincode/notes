http://www.cnblogs.com/dolphin0520/p/3920407.html

看源码 


例子



总结：

1）实际的通过ThreadLocal创建的副本是存储在每个线程自己的threadLocals中的；

2）为何threadLocals的类型ThreadLocalMap的键值为ThreadLocal对象，因为每个线程中可有多个threadLocal变量，就像上面代码中的longLocal和stringLocal；

3）在进行get之前，必须先set，否则会报空指针异常；


应用场景

 用来解决 数据库连接、Session管理等。
 
private static ThreadLocal<Connection> connectionHolder = new ThreadLocal<Connection>() {
	public Connection initialValue() {
		return DriverManager.getConnection(DB_URL);
	}
};
 
public static Connection getConnection() {
	return connectionHolder.get();
}


private static final ThreadLocal threadSession = new ThreadLocal();
 
public static Session getSession() throws InfrastructureException {
    Session s = (Session) threadSession.get();
    try {
        if (s == null) {
            s = getSessionFactory().openSession();
            threadSession.set(s);
        }
    } catch (HibernateException ex) {
        throw new InfrastructureException(ex);
    }
    return s;
}