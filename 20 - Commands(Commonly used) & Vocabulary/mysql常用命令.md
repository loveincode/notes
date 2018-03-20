mysql
	mysql -u root -h 127.0.0.1 -p

	create [database]

	drop [database]

	use [database]

	CREATE TABLE IF NOT EXISTS table_name (
		column_name column_type
	)ENGINE=InnoDB DEFAULT CHARSET=utf8;

	如果你不想字段为 NULL 可以设置字段的属性为 NOT NULL， 在操作数据库时如果输入该字段的数据为NULL ，就会报错。
	AUTO_INCREMENT定义列为自增的属性，一般用于主键，数值会自动加1。
	PRIMARY KEY关键字用于定义列为主键。 您可以使用多列来定义主键，列间以逗号分隔。
	ENGINE 设置存储引擎，CHARSET 设置编码。

	DROP TABLE table_name ;

	describe [tablename] 查看表结构

	SELECT VERSION( )	服务器版本信息
	SELECT DATABASE( )	当前数据库名 (或者返回空)
	SELECT USER( )	当前用户名
	SHOW STATUS	服务器状态
	SHOW VARIABLES	服务器配置变量

	SHOW [tablename] STATUS 查看数据表类型
  SHOW DATABASES
	show tables 查看所有表
	show table status where comment='view';  查看所有视图

	SHOW INDEX FROM table_name; 显示索引信息

	ALTER
	删除，添加表字段
		**ALTER** TABLE testalter_tbl **DROP** i;			```使用了 ALTER 命令及 DROP 子句来删除以上创建表的 i 字段```
		如果数据表中只剩余一个字段则无法使用DROP来删除字段。
		**ALTER** TABLE testalter_tbl **ADD**  i INT; ```使用 ADD 子句来向数据表中添加列，如下实例在表 testalter_tbl 中添加 i 字段，并定义数据类型:```
		自动添加到数据表字段的末尾
		提供的关键字 **FIRST** (设定位第一列)， **AFTER** 字段名（设定位于某个字段之后）。
		**ALTER** TABLE testalter_tbl **ADD** i INT **FIRST**;
		**ALTER** TABLE testalter_tbl **ADD** i INT **AFTER** c;

	修改字段类型及名称
		**ALTER** TABLE testalter_tbl **MODIFY** c CHAR(10); ```字段 c 的类型从 CHAR(1) 改为 CHAR(10)```
		**ALTER** TABLE testalter_tbl **CHANGE** i j BIGINT; ```在 CHANGE 关键字之后，紧跟着的是你要修改的字段名，然后指定新字段名及类型。```

	ALTER TABLE 对 Null 值和默认值的影响
		**ALTER** TABLE testalter_tbl **MODIFY** j BIGINT **NOT NULL** **DEFAULT** 100; ```如果你不设置默认值，MySQL会自动设置该字段默认为 NULL。```

	修改字段默认值
		**ALTER** TABLE testalter_tbl **ALTER** i **SET** DEFAULT 1000; ```修改字段的默认值```
		**ALTER** TABLE testalter_tbl **ALTER** i **DROP** DEFAULT;			```删除字段的默认值```

	修改数据表类型
		**ALTER** TABLE testalter_tbl **ENGINE** = **MYISAM**;

	修改表名
	  **ALTER** TABLE testalter_tbl **RENAME** TO alter_tbl;

	修改表结构(添加索引)
		**ALTER** table tableName **ADD** **INDEX** indexName(columnName)

	INSERT uuid()

	INSERT INTO table_name ( field1, field2,...fieldN )
                       VALUES
                       ( value1, value2,...valueN );

	**INSERT** **INTO** Task (TaskID,TaskName,TaskTypeID,TaskPriority,CreateTime,ModifyTime,StartTime,Period,ExeCount,InstantTotalCount,QualityIndex,TaskDescribe,DetectionChannel)
			values(uuid(),"全局轮询任务",1,4,"1511332788644" ,"1511332788644","1511332788644",4,0,0,"11111111111111000000000000000000","全局巡检任务",3)


	**UPDATE** table_name **SET** field1=new-value1, field2=new-value2
			[WHERE Clause]

	**DELETE** **FROM** table_name [WHERE Clause]

	SELECT column_name,column_name
			FROM table_name
					[WHERE Clause]
							[LIMIT N][ OFFSET M]

	你可以使用 WHERE 语句来包含任何条件。
	你可以使用 LIMIT 属性来设定返回的记录数。
	你可以通过OFFSET指定SELECT语句开始查询的数据偏移量。默认情况下偏移量为0。

	SELECT field1, field2,...fieldN FROM table_name1, table_name2...
			WHERE condition1 [AND [OR]] condition2.....

  **ORDER BY** field1, [field2...] [**ASC** [**DESC**]]

	SELECT column_name, **function**(column_name)
			FROM table_name
					WHERE column_name operator value
							**GROUP BY** column_name;
	**COUNT**, **SUM**, **AVG**,

	**UNION** [ALL | DISTINCT]
	DISTINCT: 可选，删除结果集中重复的数据。默认情况下 UNION 操作符已经删除了重复数据，所以 DISTINCT 修饰符对结果没啥影响。
	ALL: 可选，返回所有结果集，包含重复数据。

	**INNER JOIN**（内连接,或等值连接）：获取两个表中字段匹配关系的记录。
	**LEFT JOIN**（左连接）：获取左表所有记录，即使右表没有对应匹配的记录。
	**RIGHT JOIN**（右连接）： 与 LEFT JOIN 相反，用于获取右表所有记录，即使左表没有对应匹配的记录。

	**IS NULL**: 当列的值是 NULL,此运算符返回 true。
	**IS NOT NULL**: 当列的值不为 NULL, 运算符返回 true。
	**<=>**: 比较操作符（不同于=运算符），当比较的的两个值为 NULL 时返回 true。

	**普通索引** 这是最基本的索引，它没有任何限制。
	创建索引
	CREATE INDEX indexName ON mytable(username(length));
	如果是CHAR，VARCHAR类型，length可以小于字段实际长度；如果是BLOB和TEXT类型，必须指定 length。
	修改表结构(添加索引)
	ALTER table tableName ADD INDEX indexName(columnName)
	删除索引的语法
	DROP INDEX [indexName] ON mytable;

	**唯一索引** 它与前面的普通索引类似，不同的就是：索引列的值必须唯一，但允许有空值。如果是组合索引，则列值的组合必须唯一。
	创建索引
		CREATE UNIQUE INDEX indexName ON mytable(username(length))
	修改表结构
		ALTER table mytable ADD UNIQUE [indexName] (username(length))

	主键只能作用于一个列上，**添加主键索引** 时，你需要确保该主键默认不为空（NOT NULL）。实例如下：
	ALTER TABLE testalter_tbl MODIFY i INT NOT NULL;
  ALTER TABLE testalter_tbl ADD PRIMARY KEY (i);
	使用 ALTER 命令 **删除主键**：
	ALTER TABLE testalter_tbl DROP PRIMARY KEY;
  **添加索引**
	ALTER TABLE testalter_tbl ADD INDEX (c);
 	ALTER 命令中使用 DROP 子句来 **删除索引**
	ALTER TABLE testalter_tbl DROP INDEX c;

	**临时表** **TEMPORARY**

	**复制表**
	结构 SHOW CREATE TABLE
	数据 INSERT INTO... SELECT 语句

	**序列**
	使用AUTO_INCREMENT
	获取AUTO_INCREMENT值
	LAST_INSERT_ID( ) 函数 获取最后的插入表中的自增列的值

	重置序列

	如果你删除了数据表中的多条记录，并希望对剩下数据的AUTO_INCREMENT列进行重新排列，那么你可以通过删除自增的列，然后重新添加来实现。 不过该操作要非常小心，如果在删除的同时又有新记录添加，有可能会出现数据混乱。操作如下所示：

		mysql> ALTER TABLE insect DROP id;
		mysql> ALTER TABLE insect
		    -> ADD id INT UNSIGNED NOT NULL AUTO_INCREMENT FIRST,
		    -> ADD PRIMARY KEY (id);

	设置序列的开始值

	一般情况下序列的开始值为1，但如果你需要指定一个开始值100，那我们可以通过以下语句来实现：

	mysql> CREATE TABLE insect
	    -> (
	    -> id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	    -> PRIMARY KEY (id),
	    -> name VARCHAR(30) NOT NULL,
	    -> date DATE NOT NULL,
	    -> origin VARCHAR(30) NOT NULL
	)engine=innodb auto_increment=100 charset=utf8;
	或者你也可以在表创建成功后，通过以下语句来实现：

	mysql> ALTER TABLE t AUTO_INCREMENT = 100;

	**处理重复数据**

	防止表中出现重复数据

	可以在MySQL数据表中设置指定的字段为 **PRIMARY KEY**（主键） 或者 **UNIQUE**（唯一） 索引来保证数据的唯一性。

	CREATE TABLE person_tbl
	(
	   first_name CHAR(20) NOT NULL,
	   last_name CHAR(20) NOT NULL,
	   sex CHAR(10),
	   **PRIMARY KEY** (last_name, first_name)
	);

	CREATE TABLE person_tbl
	(
	   first_name CHAR(20) NOT NULL,
	   last_name CHAR(20) NOT NULL,
	   sex CHAR(10)
	   **UNIQUE** (last_name, first_name)
	);

	如果我们设置了 **唯一索引** ，那么在插入重复数据时，SQL语句将无法执行成功,并抛出错。

	**INSERT IGNORE INTO** 与INSERT INTO的区别就是INSERT IGNORE会忽略数据库中已经存在的数据，如果数据库没有数据，就插入新的数据，如果有数据的话就跳过这条数据。这样就可以保留数据库中已经存在数据，达到在间隙中插入数据的目的。

	以下实例使用了INSERT IGNORE INTO，执行后不会出错，也不会向数据表中插入重复数据：

	mysql> INSERT IGNORE INTO person_tbl (last_name, first_name)
    -> VALUES( 'Jay', 'Thomas');
	Query OK, 1 row affected (0.00 sec)
	mysql> INSERT IGNORE INTO person_tbl (last_name, first_name)
	    -> VALUES( 'Jay', 'Thomas');
	Query OK, 0 rows affected (0.00 sec)

	INSERT IGNORE INTO当插入数据时，在设置了记录的唯一性后，如果插入重复数据，将不返回错误，只以警告形式返回。 而REPLACE INTO into如果存在primary 或 unique相同的记录，则先删除掉。再插入新记录。

	统计重复数据

	以下我们将统计表中 first_name 和 last_name的重复记录数：

	mysql> SELECT COUNT( * ) as repetitions, last_name, first_name
	    -> FROM person_tbl
	    -> **GROUP BY** last_name, first_name
	    -> **HAVING** repetitions > 1;
	以上查询语句将返回 person_tbl 表中重复的记录数。 一般情况下，查询重复的值，请执行以下操作：

	1. 确定哪一列包含的值可能会重复。
	2. 在列选择列表使用COUNT( * )列出的那些列。
	3. 在GROUP BY子句中列出的列。
	4. HAVING子句设置重复数大于1。

	过滤重复数据
	如果你需要读取不重复的数据可以在 SELECT 语句中使用 **DISTINCT** 关键字来过滤重复数据。

	mysql> SELECT **DISTINCT** last_name, first_name
	    -> FROM person_tbl;
	你也可以使用 GROUP BY 来读取数据表中不重复的数据：
	mysql> SELECT last_name, first_name
	    -> FROM person_tbl
	    -> GROUP BY (last_name, first_name);

	删除重复数据
	如果你想删除数据表中的重复数据，你可以使用以下的SQL语句：

	mysql> CREATE TABLE tmp SELECT last_name, first_name, sex FROM person_tbl  GROUP BY (last_name, first_name, sex);
	mysql> DROP TABLE person_tbl;
	mysql> ALTER TABLE tmp RENAME TO person_tbl;

	当然你也可以在数据表中添加 INDEX（索引） 和 PRIMAY KEY（主键）这种简单的方法来删除表中的重复记录。方法如下：

	mysql> ALTER IGNORE TABLE person_tbl
	    -> ADD PRIMARY KEY (last_name, first_name);

	SQL注入
	SQL注入，就是通过把 **SQL命令** 插入到Web表单递交或输入域名或页面请求的查询字符串，最终达到欺骗服务器执行恶意的SQL命令。

	我们永远不要信任用户的输入，我们必须认定用户输入的数据都是不安全的，我们都需要对用户输入的数据进行过滤处理。

	以下实例中，输入的用户名必须为字母、数字及下划线的组合，且用户名长度为 8 到 20 个字符之间：
	``` mysql
		if (preg_match("/^\w{8,20}$/", $_GET['username'], $matches))
		{
		   $result = mysqli_query($conn, "SELECT * FROM users
		                          WHERE username=$matches[0]");
		}
		 else
		{
		   echo "username 输入异常";
		}
	```
	让我们看下在没有过滤特殊字符时，出现的SQL情况：

	// 设定$name 中插入了我们不需要的SQL语句
	$name = "Qadir'; DELETE FROM users;";
	mysqli_query($conn, "SELECT * FROM users WHERE name='{$name}'");

	Like语句中的注入
	like查询时，如果用户输入的值有"_"和"%"，则会出现这种情况：用户本来只是想查询"abcd_"，查询结果中却有"abcd_"、"abcde"、"abcdf"等等；用户要查询"30%"（注：百分之三十）时也会出现问题。

	**导出数据**

	使用 **SELECT ... INTO 	OUTFILE** 语句导出数据

	SELECT ... INTO OUTFILE 语句有以下属性:
	**LOAD DATA INFILE** 是SELECT ... INTO OUTFILE的逆操作，SELECT句法。为了将一个数据库的数据写入一个文件，使用SELECT ... INTO OUTFILE，为了将文件读回数据库，使用LOAD DATA INFILE。
	SELECT...INTO OUTFILE 'file_name'形式的SELECT可以把被选择的行写入一个文件中。该文件被创建到服务器主机上，因此您必须拥有FILE权限，才能使用此语法。
	输出不能是一个 **已存在** 的文件。防止文件数据被篡改。
	你需要有一个登陆服务器的账号来检索文件。否则 SELECT ... INTO OUTFILE 不会起任何作用。
	在UNIX中，该文件被创建后是可读的，权限由MySQL服务器所拥有。这意味着，虽然你就可以读取该文件，但可能无法将其删除。

	**导出表作为原始数据** **mysqldump**
	mysqldump是mysql用于转存储数据库的实用程序。它主要产生一个SQL脚本，其中包含从头重新创建数据库所必需的命令CREATE TABLE INSERT等。

	使用mysqldump导出数据需要使用 --tab 选项来指定导出文件指定的目录，该目标必须是可写的。
	以下实例将数据表 runoob_tbl 导出到 /tmp 目录中：

		$ mysqldump -u root -p --no-create-info \
		            --tab=/tmp RUNOOB runoob_tbl
		password ******

		**导出SQL格式的数据**
	导出SQL格式的数据到指定文件，如下所示：

	$ mysqldump -u root -p RUNOOB runoob_tbl > dump.txt
	password ******

	如果你需要导出整个数据库的数据，可以使用以下命令：

	$ mysqldump -u root -p RUNOOB > database_dump.txt
	password ******

	如果需要备份所有数据库，可以使用以下命令：

	$ mysqldump -u root -p --all-databases > database_dump.txt
	password ******
	--all-databases 选项在 MySQL 3.23.12 及以后版本加入。 该方法可用于实现数据库的备份策略。

	将数据表及数据库拷贝至其他主机
	如果你需要将数据拷贝至其他的 MySQL 服务器上, 你可以在 mysqldump 命令中指定数据库名及数据表。

	在源主机上执行以下命令，将数据备份至 dump.txt 文件中:

	$ mysqldump -u root -p database_name table_name > dump.txt
	password *****
	如果完整备份数据库，则无需使用特定的表名称。

	如果你需要将备份的数据库导入到MySQL服务器中，可以使用以下命令，使用以下命令你需要确认数据库已经创建：

	$ mysql -u root -p database_name < dump.txt
	password *****
	你也可以使用以下命令将导出的数据直接导入到远程的服务器上，但请确保两台服务器是相通的，是可以相互访问的：</p>
	$ mysqldump -u root -p database_name \
	       | mysql -h other-host.com database_name
				 以上命令中使用了管道来将导出的数据导入到指定的远程主机上。

	**导入数据**

	使用 **LOAD DATA** 导入数据
	MySQL 中提供了LOAD DATA INFILE语句来插入数据。 以下实例中将从当前目录中读取文件 dump.txt ，将该文件中的数据插入到当前数据库的 mytbl 表中。

	mysql> LOAD DATA LOCAL INFILE 'dump.txt' INTO TABLE mytbl;
	　如果指定LOCAL关键词，则表明从客户主机上按路径读取文件。如果没有指定，则文件在服务器上按路径读取文件。

	你能明确地在LOAD DATA语句中指出列值的分隔符和行尾标记，但是默认标记是定位符和换行符。

	两个命令的 FIELDS 和 LINES 子句的语法是一样的。两个子句都是可选的，但是如果两个同时被指定，FIELDS 子句必须出现在 LINES 子句之前。

	如果用户指定一个 FIELDS 子句，它的子句 （TERMINATED BY、[OPTIONALLY] ENCLOSED BY 和 ESCAPED BY) 也是可选的，不过，用户必须至少指定它们中的一个。

	mysql> LOAD DATA LOCAL INFILE 'dump.txt' INTO TABLE mytbl
	  -> FIELDS TERMINATED BY ':'
	  -> LINES TERMINATED BY '\r\n';
	LOAD DATA 默认情况下是按照数据文件中列的顺序插入数据的，如果数据文件中的列与插入表中的列不一致，则需要指定列的顺序。

	如，在数据文件中的列顺序是 a,b,c，但在插入表的列顺序为b,c,a，则数据导入语法如下：

	mysql> LOAD DATA LOCAL INFILE 'dump.txt'
	    -> INTO TABLE mytbl (b, c, a);

	**使用 mysqlimport 导入数据**
	mysqlimport客户端提供了LOAD DATA INFILEQL语句的一个命令行接口。mysqlimport的大多数选项直接对应LOAD DATA INFILE子句。

	从文件 dump.txt 中将数据导入到 mytbl 数据表中, 可以使用以下命令：

	$ mysqlimport -u root -p --local database_name dump.txt
	password *****
	mysqlimport命令可以指定选项来设置指定格式,命令语句格式如下：

	$ mysqlimport -u root -p --local --fields-terminated-by=":" \
	   --lines-terminated-by="\r\n"  database_name dump.txt
	password *****
	mysqlimport 语句中使用 --columns 选项来设置列的顺序：

	$ mysqlimport -u root -p --local --columns=b,c,a \
	    database_name dump.txt
	password *****
