https://blog.csdn.net/qq_25237663/article/details/52262532
https://blog.csdn.net/u014282557/article/details/76193014

## 1、什么是Velocity？
官网：http://velocity.apache.org

Velocity是一个基于Java的模板引擎。它允许任何人使用简单而强大的模板语言来引用Java代码中定义的对象。

当Velocity用于Web开发时，Web设计人员可以与Java程序员并行工作，以根据模型 - 视图 - 控制器（MVC）模型开发Web站点，这意味着网页设计人员可以专注于创建一个看起来很好的站点，程序员可以专注于编写一流的代码。**Velocity将Java代码与网页分开**，使网站在其生命周期内更加可维护，并为Java Server Pages（JSP）或PHP提供了可行的替代方案。

Velocity的功能远远超出了网络的范围; 例如，它可以用于从模板生成SQL，PostScript和XML。它可以用作生成源代码和报告的独立实用程序，也可以用作其他系统的集成组件。例如，Velocity为各种Web框架提供模板服务，使他们能够根据真正的MVC模型，使视图引擎促进Web应用程序的开发。

## 2、Velocity提供的project
Velocity Engine——这是实现所有工作的实际模板引擎。（目前的版本是1.7）

Velocity Tools——项目包含使用Velocity引擎构建Web和非Web应用程序的工具和其他有用的基础设施。在此找到例如Struts集成的代码或独立的VelocityViewServlet。（目前的版本是2.0）


## 3、入门示例
我的项目是用了Spring Boot的，开始想在Spring.io中直接添加Velocity的依赖，但是找不到依赖包，只能后面导入了。

我的porm.xml如下：

然后在resource/templates下新建一个news.vm
``` html
<html>
<body>
<pre>
 Hello Lily Velocity
  </pre>
</body>
</html>
```
然后在src/main/java下新建一个controller包，在该包中新建一个IndexController类，添加Controller注解，写一个news函数：
``` java
@Controller
  public class IndexController {
    @RequestMapping(value= {"/vm"} )
    public String news(){
        return "news";
    }
}
```
然后运行Application，在127.0.0.1:8080中查看：

## 4 用户指南
