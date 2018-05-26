GBK编码字节流到UTF-8编码字节流的转换：

byte[] src,dst;
dst=new String(src，"GBK").getBytes("UTF-8")
