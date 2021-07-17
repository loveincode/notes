https://segmentfault.com/a/1190000021217176

https://my.oschina.net/tridays/blog/805111

当在出现循环依赖的 Spring Bean 中使用 @Async 时，会报以下错误：

Caused by: org.springframework.beans.factory.BeanCurrentlyInCreationException: Error creating bean with name 'a': Bean with name 'a' has been injected into other beans [b] in its raw version as part of a circular reference, but has eventually been wrapped. This means that said other beans do not use the final version of the bean. This is often the result of over-eager type matching - consider using 'getBeanNamesOfType' with the 'allowEagerInit' flag turned off, for example.

该问题出现的原因是：在正常加载完循环依赖后，因为 @Async 注解的出现，又需将该 Bean 代理一次，然后 Spring 发现该 Bean 已经被其他对象注入，且注入的是没被代理过的版本，于是报错。这个问题也会出现在使用 AOP 等需要代理原类的场景下。
