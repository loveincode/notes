#!/usr/bin/env python
#encoding=utf-8
# -*- coding: UTF-8 -*-
#
import warnings
warnings.filterwarnings(action="ignore", message='the sets module is deprecated')
import sets
import json
import sys

# 需要更新为 C:\Python26\Lib\MySQLHelper.py 版本
from MySQLHelper import *
import traceback
import MySQLdb
import redis
import chardet
import time

if len(sys.argv) == 1:
    print ("need more argvs")
    exit(1)

argv1 = sys.argv[1]

###################################################################################################

db0pool = redis.ConnectionPool(host='10.10.40.168',password='kedacom#123', port=63790, db=0)
#db0pool = redis.ConnectionPool(host='127.0.0.1',password='123456', port=6379, db=0)
db0Red = redis.StrictRedis(connection_pool=db0pool)

mysql = MySQLHelper("10.10.40.168","root","kdc",charset="utf8")
#mysql = MySQLHelper("127.0.0.1","root","kdc",charset="utf8")
mysql.selectDb("vas")

mysql.query("SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED")

quitCode={}
quitCode['noSuchMethod']     =100
quitCode['loadTask']         =101
quitCode['deleteTask']       =102
quitCode['loadIau']          =103
quitCode['deleteIau']        =104


#增加Task
def loadTask(*IDArr):
    IDArr = IDArr[0] 
    
    #查询出所有
    sql = "SELECT TaskID taskID, TaskName taskName,a.TaskTypeID taskTypeID,TaskTypeName taskTypeName,TaskPriority taskPriority,CreateTime createTime,StartTime startTime,Period period,ExeCount extCount,QualityIndex qualityIndex FROM Task a,TaskType b where a.TaskTypeID = b.TaskTypeID"
    if len(IDArr) > 0:
        sql = sql + " and TaskID " + "in ( " + ",".join(["'%s'" % x for x in IDArr]) + ")"
    print (sql)
    
    #排序
    sqlOrder = "SELECT TaskID taskID FROM Task ORDER BY CONVERT( TaskName USING GBK ) ASC"
    print (sqlOrder)
    
    try:
        results = mysql.queryAll(sql)

        for row in results:
            for k in row.keys():
                if "None" == row[k]:
                    del row[k]
        
        #sqlOrder
        orderResults = mysql.queryAll(sqlOrder)

        rank=0
        for row in orderResults:
            rank=rank+1
            row["rank"] = rank
              
        lua =   """
                    local itemList = cjson.decode(ARGV[1])
                    for i,row in ipairs(itemList) do
                        
                        local param = {}
                        for k,v in pairs(row) do
                            param[#param+1] = k
                            param[#param+1] = v
                        end
                        redis.call("HMSET","task:" .. row.taskID,unpack(param))
                        
                    end
                    
                    local orderList = cjson.decode(ARGV[2])
                    for i,row in ipairs(orderList) do
                        if redis.call("EXISTS","task:" .. row.taskID) > 0 then
                            redis.call("ZADD","Ztask", row.rank , row.taskID )
                        end
                    end
    
                """
    
        script = db0Red.register_script(lua)
        script(keys=[],args=[json.dumps(results), json.dumps(orderResults)])
        
        
    except Exception as e:
        traceback.print_exc()
        quit(quitCode['loadTask'])
        
        
#删除task
def deleteTask(IDArr):
    try:
                      
        lua =   """
                    local taskIDs = {}
                    for i=1,#ARGV do
                        taskIDs[#taskIDs+1] = "task:" .. ARGV[i]
                    end
                    
                    redis.call("DEL", unpack(taskIDs))
                    redis.call("ZREM", "Ztask", unpack(ARGV))
                """
	
        script = db0Red.register_script(lua)
        script(keys=[],args=IDArr)
        
    except Exception as e:
        traceback.print_exc()
        quit(quitCode['deleteTask'])
        
#增加iau
def loadIau(*IDArr):
    IDArr = IDArr[0] 
    
    sql = "SELECT IauID iauID, IauName iauName, IauIP iauIP, IauPort iauPort, IauCap iauCap,IauVersion iauVersion, IauPriority iauPriority FROM Iau "
    if len(IDArr) > 0:
        sql = sql + " WHERE IauId " + "in ( " + ",".join(["'%s'" % x for x in IDArr]) + ")"
    print sql
    
    sqlOrder = "SELECT IauID iauID FROM Iau ORDER BY CONVERT( IauName USING GBK ) ASC"
    print sqlOrder
    
    try:
        results = mysql.queryAll(sql)

        for row in results:
            for k in row.keys():
                if "None" == row[k]:
                    del row[k]
        
        #sqlOrder
        orderResults = mysql.queryAll(sqlOrder)

        rank=0
        for row in orderResults:
            rank=rank+1
            row["rank"] = rank
              
        lua =   """
                    local itemList = cjson.decode(ARGV[1])
                    for i,row in ipairs(itemList) do
                        
                        local param = {}
                        for k,v in pairs(row) do
                            param[#param+1] = k
                            param[#param+1] = v
                        end
                        redis.call("HMSET","iau:" .. row.iauID,unpack(param))
                        
                    end
                    
                    local orderList = cjson.decode(ARGV[2])
                    for i,row in ipairs(orderList) do
                        if redis.call("EXISTS","iau:" .. row.iauID) > 0 then
                            redis.call("ZADD","Ziau", row.rank , row.iauID )
                        end
                    end
    
                """
    
        script = db0Red.register_script(lua)
        script(keys=[],args=[json.dumps(results), json.dumps(orderResults)])
        
        
    except Exception,e:
        traceback.print_exc()
        quit(quitCode['loadIau'])
        
        
#删除iau
def deleteIau(IDArr):
    try:
                      
        lua =   """
                    local iauIDs = {}
                    for i=1,#ARGV do
                        iauIDs[#iauIDs+1] = "iau:" .. ARGV[i]
                    end
                    
                    redis.call("DEL", unpack(iauIDs))
                    redis.call("ZREM", "Ziau", unpack(ARGV))
                """
    
        script = db0Red.register_script(lua)
        script(keys=[],args=IDArr)
        
        
    except Exception,e:
        traceback.print_exc()
        quit(quitCode['deleteIau'])     
        
##############################################################

if argv1 == "loadTask":
    print ('begin loadTask')
    print (time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())))
    loadTask(sys.argv[2:])
    print (time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())) )
    print ("loadTask end")
    
elif argv1 == "deleteTask":
    print ('begin deleteTask')
    print (time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())) )
    deleteTask(sys.argv[2:])
    print (time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())) )
    print ("deleteTask end")

elif argv1 == "loadIau":
    print ('begin loadIau')
    print (time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())) )
    loadIau(sys.argv[2:])
    print (time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())) )
    print ("loadIau end")

elif argv1 == "deleteIau":
    print ('begin deleteIau')
    print (time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())) )
    deleteIau(sys.argv[2:])
    print (time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())) )
    print ("deleteIau end")
    
else:
    quit(quitCode['noSuchMethod'])

mysql.close()
db0pool.disconnect()

