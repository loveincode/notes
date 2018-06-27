使用Eclipse 进行项目开发，在实现类中的方法前面如果添加@Override就提示“Multiple markers at this line”的错误，问题描述如下

Multiple markers at this line
	- The method getSecurityByKey(String) of type SecurityServiceImpl must override a superclass
	 method
	- implements com.dearbinge.data.api.SecurityService.getSecurityByKey


出现上述问题的原因：JDK1.5不支持这种写法。实现接口方法需要重写抽象方法。
解决上述问题的方法如下：
方法1.选择Eclipse的Window→Preferences→Java→Compiler，把Compiler compliance level从1.5改成1.6。

方法2.右击project选择最后一个properties选择左侧的java compiler,勾选里面的框框，把java编辑器版本都改成1.6。

方法3.右击project下的 JRE System Library[JavaSE-1.5]→Properties,Execution environment 选择“JavaSE-1.6(JDK1.6.0_10)”,点击确定即可。
