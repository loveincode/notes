cat error.log | grep -C 5 'nick' 显示file文件里匹配nick字串那行以及上下5行
cat error.log | grep -B 5 'nick' 显示nick及前5行
cat error.log | grep -A 5 'nick' 显示nick及后5行
