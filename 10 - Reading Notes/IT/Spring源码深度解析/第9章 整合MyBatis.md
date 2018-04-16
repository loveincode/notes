## 9.1 MyBatis独立使用
  1. 建立PO
  2. 建立Mapper
  3. 建立配置文件
  4. 建立映射文件
  5. 建立测试类
## 9.2 Spring整合MyBatis
  1. Spring配置文件
  2. MyBatis配置文件
  3. 映射文件
  4. 测试
## 9.3 源码分析
### 9.3.1 sqlSessionFactory创建
  实现了 FactoryBean 和 InitializingBean
  FactoryBean：一旦某个bean实现此接口，name通过getBean方法获取bean时其实是获取此类的getObject()返回的实例。
  InitializingBean：实现此接口的bean会在初始化时调用 afterPropertiesSet 方法来进行bean的逻辑初始化。
  1 SqlSessionFactoryBean初始化
  2 获取SqlSessionFactoryBean 实例
### 9.3.2 MapperFactoryBean 的创建

  1 MapperFactoryBean 初始化
  2 获取 MapperFactoryBean 实例
### 9.3.3 MapperScannerConfigurer
  使用MapperScannerConfigurer，让它扫描特定的包，自动帮我们成批地创建映射器。
  ``` xml
  <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
      <property name="basePackage" value="com.xxx.xxx.dao" />
      <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory" />
  </bean>
  ```
  1. processPropertyPlaceHolders 属性的处理
  2. 根据配置属性生成过滤器
  3. 扫描Java文件
