1 Linux grep命令用于查找文件里符合条件的字符串。

	grep指令用于查找内容包含指定的范本样式的文件
	如果发现某文件的内容符合所指定的范本样式，预设grep指令会把含有范本样式的那一列显示出来。

	若不指定任何文件名称，或是所给予的文件名为"-"，则grep指令会从标准输入设备读取数据。


2 Linux sed命令是利用script来处理文本文件。

	sed可依照script的指令，来处理、编辑文本文件。

	Sed主要用来自动编辑一个或多个文件；简化对文件的反复操作；编写转换程序等。


3 Linux AWK是一种处理文本文件的语言，是一个强大的文本分析工具。

	之所以叫AWK是因为其取了三位创始人 Alfred Aho，Peter Weinberger, 和 Brian Kernighan 的Family Name的首字符。


4 不同的Linux之间copy文件常用有3种方法：

第一种就是`ftp`，也就是其中一台Linux安装ftp Server，这样可以另外一台使用ftp的client程序来进行文件的copy。

第二种方法就是采用`samba`服务，类似Windows文件copy 的方式来操作，比较简洁方便。

第三种就是利用`scp`命令来进行文件复制。
