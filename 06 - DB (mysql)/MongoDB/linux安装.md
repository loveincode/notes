curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.0.6.tgz    # 下载
tar -zxvf mongodb-linux-x86_64-3.0.6.tgz                                   # 解压

mv  mongodb-linux-x86_64-3.0.6/ /usr/local/mongodb                         # 将解压包拷贝到指定目录

export PATH=<mongodb-install-directory>/bin:$PATH  <mongodb-install-directory> 为你 MongoDB 的安装路径。如本文的 /usr/local/mongodb 
