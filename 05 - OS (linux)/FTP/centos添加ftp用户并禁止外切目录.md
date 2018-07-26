在linux中添加ftp用户，并设置相应的权限，操作步骤如下：
### 1、环境：ftp为vsftp。
  被限制用户名为ftpuser。被限制路径为/home/ftpuser

### 2、建用户，命令行状态下，在root用户下：

  运行命令：“useradd -d /home/ftpuser ftpuser”　　//增加用户ftpuser，并制定ftpuser用户的主目录为/home/ftpuser

  运行命令：“passwd ftpuser”　　//为ftpuser设置密码，运行后输入两次相同密码

### 3、更改用户相应的权限设置：

    运行命令：“usermod -s /sbin/nologin ftpuser”　　//限定用户ftpuser不能telnet，只能ftp

    运行命令：“usermod -s /sbin/bash ftpuser”　　//用户ftpuser恢复正常

    运行命令：“usermod -d /ftpuser ftpuser”　　//更改用户ftpuser的主目录为/ftpuser

### 4、限制用户只能访问/home/ftpuser，不能访问其他路径

    修改/etc/vsftpd/vsftpd.conf如下：
```
  chroot_local_user=NO
  chroot_list_enable=YES
  # (default follows)
  chroot_list_file=/etc/vsftpd/vsftpd.chroot_list
```
 编辑上面的内容
```
    第一行：chroot_local_user=NO

    第二行：chroot_list_enable=YES　　//限制访问自身目录

    第四行：编辑vsftpd.chroot_list。根据第三行说指定的目录，找到chroot_list文件。（因主机不同，文件名也许略有不同）

    编辑vsftpd.chroot_list，将受限制的用户添加进去，每个用户名一行
```
说明：chroot_local_user=NO则所有用户不被限定在主目录内，chroot_list_enable=YES表示要启用chroot_list_file, 因为chroot_local_user=NO，即全体用户都“不被限定在主目录内”,所以总是作为“例外列表”的chroot_list_file这时列出的是那些“会被限制在主目录下”的用户。

### 5、重启服务器

    改完配置文件，不要忘记重启vsFTPd服务器

    运行命令：`service vsftpd restart`

### 6、如果需要允许用户修改密码，但是又没有telnet登录系统的权限：

    运行命令：“usermod -s /usr/bin/passwd ftpuser”　　//用户telnet后将直接进入改密界面
