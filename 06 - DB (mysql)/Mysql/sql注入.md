拼接sql

Statement
PrepareStatement

hibernate
:name setstring(name,value)
?  setstring(0,value)

Mybatis

#
$
（1）变量的传递，必须使用#，使用#{}就等于使用了PrepareStatement这种占位符的形式,提高效率。可以防止sql注入等等问题。#方式一般用于传入添加，修改的值或查询，删除的where条件 id值

select * from t_user where name = #{param}

(2)$只是只是简单的字符串拼接，要特别小心sql注入问题，对应非变量部分，只能用$。$方式一般用于传入数据库对象，比如这种group by 字段 ,order by 字段，表名，字段名等没法使用占位符的就需要使用${}

select count(* ), from t_user group by ${param}

（3）能同时使用#和$的时候，最好用#。
