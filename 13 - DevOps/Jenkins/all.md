https://www.jianshu.com/p/ba09cdc53343


https://blog.csdn.net/w105021/article/details/78657382

nohup java -Xms256m -Xmx1024m -XX:MaxPermSize=512m -jar jenkins.war --ajp13Port=-1 --httpPort=7076 > jenkins.out 2>&1 &

其中 --httpPort=7076指定jenkins启动监听的端口，这里更改为7076（默认是8080）。-Xms256m -Xmx1024m -XX:MaxPermSize=512m设置了JVM参数(需要因环境而异)。
