[elasticsearch官方Api](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices.html?spm=5176.100239.blogcont46639.5.HE1RSU)

[中文博客整理API](http://www.cnblogs.com/yjf512/p/4862992.html)

PUT 创建Index localhost:9200/indexname
例子：localhost:9200/data


POST 创建Type localhost:9200/indexname/typename
例子：localhost:9200/data/person
会自动创建id
{
	"name":"loveincode",
	"age":20
}

POST 创建type 及ID localhost:9200/indexname/typename
例子：localhost:9200/data/person/1

{
	"name":"loveincode",
	"age":20
}

PUT 修改 localhost:9200/data/person/1
{
	"name":"loveincode_update",
	"age":20
}
POST 更新 localhost:9200/data/person/1/_update?pretty
{
	"name": "Jane Doe"
}

DELETE localhost:9200/data/person/1?pretty

Get localhost:9200/_cat/indices?v
查询所有index

GET localhost:9200/indexname
例子：localhost:9200/data
获得index的属性

GET by ID
localhost:9200/indexname/typename/{id}
取到ID=id的信息

GET 搜索Index localhost:9200/indexname/_search
例子：localhost:9200/data/_search


GET 搜索Index localhost:9200/indexname/typename/_search
例子：localhost:9200/data/person/_search