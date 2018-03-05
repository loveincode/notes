http://blog.csdn.net/wangyonglin1123/article/details/50996300


1. 首先需要将$Tomcat_HOME/bin目录下的Catalina.sh脚本复制到目录/etc/init.d中，重命名为tomcat，文件名即为以后的服务名
2. 修改刚才复制的tomcat脚本：
 　　a. 在脚本的第三行后面插入下面两行

  　　# chkconfig: 2345 90 10
  　　# description:Tomcat service

　　第一行是服务的配置：第一个数字是服务的运行级，2345表明这个服务的运行级是2、3、4和5级（Linux的运行级为0到6）；第二个数字是启动优先级，数值从0到99；第三个数是停止优先级，数值也是从0到99。
 　 第二行是对服务的描述

    b. 在脚本中设置　CATALINA_HOME　和　JAVA_HOME　这两个脚本必需的环境变量，如：

　　　　CATALINA_HOME=/usr/share/tomcat
　　　　JAVA_HOME=/usr/share/java/jdk

    经过实验发现，即使在系统中设置了这两个环境变量也没有用，只好在这里再设置一遍
   c. 添加tomcat 脚本为可执行权限
      [root@localhost bin]# chmod 755 /etc/init.d/tomcat
   d. 最后用chkconfig设置服务运行
     #chkconfig --add tomcat
     服务就添加成功了。
     然后你就可以用 chkconfig --list 查看，在服务列表里就会出现自定义的服务了。
    注意：
   在tomcat文件的头两行的注释语句中，需要包含chkconfig和description两部分内容(确认不要拼写错误，)，否则在执行“chkconfig --add tomcat”时，会出现“tomcat服务不支持chkconfig”的错误提示
  (注：如果不添加为系统服务，仅是使用service 命令来管理tomcat 的话，a,c ,d 步骤可以省略)
3. OK！现在就可以用service tomcat start|stop|run来管理tomcat服务了

4. 设置tomcat 在操作系统重启后自动重启
   直接在/etc/rc.local 后添加下面的语句
   /usr/local/tomcat/bin/startup.sh