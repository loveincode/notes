定义class文件格式。它是一种与硬件和操作系统无关的二进制格式，用来表示编译后的类和接口；
### 4.1 classFile格式
每个class文件对应一个如下所示的ClassFile结构
```
ClassFile{
  u4                magic 魔数
  u2                minor_version 副版本号
  u2                major_version 主版本号
  u2                constant_pool_count 常量池计数器
  cp_info           constant_pool[constant_pool_count-1]  常量池
  u2                access_flags  访问标志
  u2                this_class    类索引
  u2                super_class   父类索引
  u2                interfaces_count  接口计数器
  u2                interfaces[interfaces_count] 接口表
  u2                fields_count  字段计数器
  field_info        fields[fields_count] 字段表
  u2                methods_count 方法计数器
  method_info       methods[methods_count] 方法表
  u2                attributes_count 属性计数器
  attribute_info    attributes[attributes_count] 属性表
}
```
各项含义如下

### 4.2 各种内部表示名称

#### 4.2.1 类和接口的二进制名称

#### 4.2.2 非全限定名

### 4.3 描述符和签名

#### 4.3.1 语法符号
#### 4.3.2 字段描述符
#### 4.3.3 方法描述符
#### 4.3.4 签名

### 4.4 常量池
#### 4.4.1 CONSTANT_Class_info结构

### 4.5 字段

### 4.6 方法

### 4.7 属性

### 4.8 格式检查

### 4.9 Java虚拟机代码约束

### 4.10 **class文件校验**

### 4.11 Java虚拟机限制
