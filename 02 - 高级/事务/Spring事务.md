Required 如果当前存在事务，则使用该事务，否则将新建一个事务

Required_new 如果当前存在事务，则挂起当前事务并且开启一个新事务继续执行，新事务执行完毕之后，然后再唤醒之前挂起的事务；如果当前不存在事务，开启一个新事务。

Try

catch 

Spring 事务

自生调用事务会失效

Spring事务实现：
	jdk的动态代理，CGLIB
	
基于AOP代理 真是对象调用

JDK动态代理导致Spring事务不能回滚

基于AOP代理与真是对象调用

解决：必须要获取当前AopProxy 使用Aop代理调用方法 才会生效。

暴露aop代理 在Spring配置文件中修改
<aop:aspecth-autoproxy expose-proxy="true"/>

通过上下文获取
((UserService)AopContext.currentProxy()).方法

//通过applicationContext也可以解决



对象调用事务


Proxy代理
jdk动态代理是基于接口实现的

被代理的接口 UserService

被代理的对象 UserServiceImpl

使用反射来 代理对象 代理方法

父 子

