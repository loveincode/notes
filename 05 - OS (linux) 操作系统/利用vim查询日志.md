vim 操作到 [readme.md](https://github.com/loveincode/notes/blob/master/05%20-%20OS%20(linux)%20%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F/vi-vim/readme.md)

/查询内容 回车

n 下一个搜到的值

# cat
cat xxx.log |grep '查询值' -A 1

-A 后边
-B 前边
-C 前后

# tail
tail 命令


# less
less -N catalina.out

/keyword　　向下查找
n    向下匹配下一处匹配文本
N    向上匹配下一处匹配文本

?keyword　　向上查找
n    向上匹配下一处匹配文本
N    向下匹配下一处匹配文本

F    　　　　实时滚动文档
Ctrl + c　　退出实时滚动模式

类似效果：
tail -f catalina.out
