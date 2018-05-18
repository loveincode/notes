# -*- coding: UTF-8 -*-
import random as r
import uuid
import MySQLdb
import time

first=('张','王','李','赵','金','艾','单','龚','钱','周','吴','郑','孔','曺','严','华','吕','徐','何')
middle=('芳','军','建','明','辉','芬','红','丽','功')
last=('明','芳','','民','敏','丽','辰','楷','龙','雪','凡','锋','芝')
conn = MySQLdb.connect(host='127.0.0.1', port=33060, user='root', passwd='kdc',db='vas')

for i in range(20000):
  name1=r.choice(first)+r.choice(middle)+r.choice(last)
  suuid1 = ''.join(str(uuid.uuid4()).split('-'))
  cur1 = conn.cursor()
  cur1.execute("select GroupID from GroupStdTree where GroupTreeID = 'defaultbcac9c6de8124140990d3ae34'")
  data=cur1.fetchall()
  GroupID=[]
  if data:
    for rec in data:
      GroupID.append(rec[0])
  cur1.close()
  suuid2 = r.choice(GroupID)
  print name1
  print suuid1 +" "+ suuid2
  cur2 = conn.cursor()
  cur2.execute("insert into GroupStdTree (`GroupID`, `ParentGroupID`, `GroupTreeID`, `PlatGroupID`, `PlatParentGroupID`, `GroupName`, `SyncRoundNum`) SELECT %s, %s, 'defaultbcac9c6de8124140990d3ae34', %s, %s, %s, 5 ;",(suuid1,suuid2,suuid1,suuid2,name1))
  conn.commit()
  cur2.callproc('VAS_PROC_GROUP_PLAT_BIN_GROUP_AddNode',(suuid1,suuid2,5,'defaultbcac9c6de8124140990d3ae34','bcac9c6de8124140990d3ae346b69288'))
  cur2.close()

conn.close()
