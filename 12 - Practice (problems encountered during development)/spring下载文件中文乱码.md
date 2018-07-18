https://www.jianshu.com/p/58e605d881e3
```java
        fileName = URLEncoder.encode(fileName, StandardCharsets.UTF_8.toString());
        response.setContentType(MediaType.APPLICATION_OCTET_STREAM.toString());
        // 解决中文文件名乱码关键行
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=utf-8''" + fileName);
```
https://blog.csdn.net/clj198606061111/article/details/20743769
```java
  String fileName=new String("你好.xlsx".getBytes("UTF-8"),"iso-8859-1");//为了解决中文名称乱码问题
  headers.setContentDispositionFormData("attachment", fileName);
  headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
```
