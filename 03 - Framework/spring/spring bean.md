https://www.jianshu.com/p/3944792a5fff
http://baijiahao.baidu.com/s?id=1596092490213053123&wfr=spider&for=pc

Spring框架中，一旦把一个Bean纳入Spring IOC容器之中，这个Bean的生命周期就会交由容器进行管理，一般担当管理角色的是BeanFactory或者ApplicationContext

下面以BeanFactory为例，说明一个Bean的生命周期活动

包括BeanFactoryPostProcessor、BeanPostProcessor、InstantiationAwareBeanPostProcessor、BeanNameAware、BeanFactoryAware，InitializingBean等

1. Bean的建立， 由BeanFactory读取Bean定义文件，并生成各个实例
2. Setter注入，执行Bean的属性依赖注入
3. `BeanNameAware`的setBeanName(), 如果实现该接口，则执行其setBeanName方法
4. `BeanFactoryAware`的setBeanFactory()，如果实现该接口，则执行其setBeanFactory方法
5. `BeanPostProcessor`的processBeforeInitialization()，如果有关联的processor，则在Bean初始化之前都会执行这个实例的processBeforeInitialization()方法
6. `InitializingBean`的afterPropertiesSet()，如果实现了该接口，则执行其afterPropertiesSet()方法
7. Bean定义文件中定义`init-method`
8. `BeanPostProcessors`的processAfterInitialization()，如果有关联的processor，则在Bean初始化之前都会执行这个实例的processAfterInitialization()方法
9. DisposableBean的destroy()，在容器关闭时，如果Bean类实现了该接口，则执行它的`destroy()`方法
10. Bean定义文件中定义destroy-method，在容器关闭时，可以在Bean定义文件中使用“`destory-method`”定义的方法


如果使用ApplicationContext来维护一个Bean的生命周期，则基本上与上边的流程相同，只不过在执行BeanNameAware的setBeanName()后，若有Bean类实现了org.springframework.context.ApplicationContextAware接口，则执行其setApplicationContext()方法，然后再进行BeanPostProcessors的processBeforeInitialization()
实际上，ApplicationContext除了向BeanFactory那样维护容器外，还提供了更加丰富的框架功能，如Bean的消息，事件处理机制等


scope为singleton
VS
scope为prototype
