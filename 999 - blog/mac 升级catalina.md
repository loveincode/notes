1、重启mac，按住`Command+R`，等到系统进入安全模式。
2、选择一个账户，然后点击屏幕上方的工具栏找到命令行工具。
3、执行，命令`csrutil disable`
4、重启电脑后，不要进入安全模式，执行命令`sudo mount -uw /`
5、执行命令 `sudo mkdir /data`
6、执行命令 `sudo chmod 777 /data`
7、重启电脑，进入安全模式，执行命令 `csrutil enable` （开启SIP）
