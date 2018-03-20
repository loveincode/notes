1.准备工作～
1）下载jenkins安装包
官网直接下载：https://jenkins.io/


2）安装jdk
 
2.启动jenkins服务
启动非常简单：
java -jar /usr/local/webserver/jenkins.war --httpPort=8080
 
3.在浏览器中输入http://ip:8080,进入jenkins页面


4.在进行新建任务之前，进行一些必要设置
1）点击系统管理—>系统设置ssh server 的配置
2）系统管理－> Configure Global Security，配置安全设置
3）     系统管理－> 管理插件，添加一些必要的插件
4）     新增一些构建用户
 
5.在构建项目之前，先准备好代码库地址，并且添加对应插件～
代码库，可以用svn ,也可以git
 
6.选择新建任务(以构建一个maven项目为例)

7.填入项目在git上的地址，选择对应分支，保存即可

8.即构建，构建成功则如下图所示

9.jenkins maven还有很多细节，比如定时构建、触发构建等等，有兴趣自己玩耍，有问题可找老徐交流～


启动 net start jenkins
停止 net stop jenkins