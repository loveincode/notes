1 Linux ps命令用于显示当前进程 (process) 的状态。

	ps [options] [--help]
	
	ps 的参数非常多, 在此仅列出几个常用的参数并大略介绍含义
	-A 列出所有的行程
	-w 显示加宽可以显示较多的资讯
	-au 显示较详细的资讯
	-aux 显示所有包含其他使用者的行程
	au(x) 输出格式 :
	
	USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND
	
	USER: 行程拥有者
	PID: pid
	%CPU: 占用的 CPU 使用率
	%MEM: 占用的记忆体使用率
	VSZ: 占用的虚拟记忆体大小
	RSS: 占用的记忆体大小
	TTY: 终端的次要装置号码 (minor device number of tty)
	STAT: 该行程的状态:
		D: 不可中断的静止 (通悸□□缜b进行 I/O 动作)
		R: 正在执行中
		S: 静止状态
		T: 暂停执行
		Z: 不存在但暂时无法消除
		W: 没有足够的记忆体分页可分配
		<: 高优先序的行程
		N: 低优先序的行程
		L: 有记忆体分页分配并锁在记忆体内 (实时系统或捱A I/O)
	START: 行程开始时间
	TIME: 执行的时间
	COMMAND:所执行的指令
	
2 Linux top命令用于实时显示 process 的动态。
	使用权限：所有使用者。
	
	top [-] [d delay] [q] [c] [S] [s] [i] [n] [b]


	d : 改变显示的更新速度，或是在交谈式指令列( interactive command)按 s
	q : 没有任何延迟的显示速度，如果使用者是有 superuser 的权限，则 top 将会以最高的优先序执行
	c : 切换显示模式，共有两种模式，一是只显示执行档的名称，另一种是显示完整的路径与名称S : 累积模式，会将己完成或消失的子行程 ( dead child process ) 的 CPU time 累积起来
	: 安全模式，将交谈式指令取消, 避免潜在的危机
	i : 不显示任何闲置 (idle) 或无用 (zombie) 的行程
	n : 更新的次数，完成后将会退出 top
	b : 批次档模式，搭配 "n" 参数一起使用，可以用来将 top 的结果输出到档案内
	