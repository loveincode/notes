#coding=utf-8
import time
import datetime
import os

# 删除目录下的 一小时以前的文件夹及内容
def delete_dir():

    # /var/nms/devversion/cf/
    t = time.time()
    print (t)                       #原始时间数据
    print (int(t))                  #秒级时间戳
    print (int(round(t * 1000)))    #毫秒级时间戳

    # 1 小时 3600000 
    before1hour = int(round(t * 1000)) - 3600000
    print (before1hour) #一小时前的时间戳
    
    print (datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))   #日期格式化

    fs = os.listdir("/var/nms/devversion/cf/")
    for f1 in fs:
        tmp_path = os.path.join("/var/nms/devversion/cf/",f1)
        if not os.path.isdir(tmp_path):
            print('文件: %s'%tmp_path)
        else:
            print(f1)
            print(int(f1)<before1hour)
            if(int(f1)<before1hour):
                print('文件夹：%s 在一小时前创建的，执行删除'%tmp_path)
                del_file(tmp_path)
                os.rmdir(tmp_path)


#递归删除文件夹下的所有文件
def del_file(path):
    ls = os.listdir(path)
    for i in ls:
        c_path = os.path.join(path, i)
        if os.path.isdir(c_path):
            del_file(c_path)
            #如果是空目录
            if not os.listdir(c_path):
                os.rmdir(c_path)
        else:
            os.remove(c_path)

delete_dir()