循环依赖
  * 构造器循环依赖
    Caused by: org.springframework.beans.factory.BeanCurrentlyInCreationException
  * setter循环依赖 默认单例
  * setter循环依赖 prototype  
    Caused by: org.springframework.beans.factory.BeanCurrentlyInCreationException

一级缓存 singletonObjects       单例bean缓存
二级缓存 singletonFactories     工厂对象缓存
三级缓存 earlySingletonObjects  早期单例bean缓存
```java
/** Cache of singleton objects: bean name --> bean instance */
private final Map<String, Object> singletonObjects = new ConcurrentHashMap<String, Object>(256);

/** Cache of singleton factories: bean name --> ObjectFactory */
private final Map<String, ObjectFactory<?>> singletonFactories = new HashMap<String, ObjectFactory<?>>(16);

/** Cache of early singleton objects: bean name --> bean instance */
private final Map<String, Object> earlySingletonObjects = new HashMap<String, Object>(16);
```

创建Bean的过程
