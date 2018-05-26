# -*- coding: UTF-8 -*-
import random as r
import uuid
import MySQLdb
import time

first=('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S')
middle=('a','b','c','d','e','f','g','h','i')
last=('1','2','3','4','5','6','7','8','9','10','11','12')
conn = MySQLdb.connect(host='127.0.0.1', port=33060, user='root', passwd='kdc',db='vas')

for i in range(10000):
  name1=r.choice(first)+r.choice(middle)+r.choice(last)
  suuid1 = ''.join(str(uuid.uuid4()).split('-'))
  cur1 = conn.cursor()
  cur1.execute("select GroupID from GroupStdTree where GroupTreeID = 'defaultcbaa5c3d2394438db3c3480fc'")
  data=cur1.fetchall()
  GroupID=[]
  if data:
    for rec in data:
      GroupID.append(rec[0])
  cur1.close()
  suuid2 = r.choice(GroupID)
  print i
  print name1
  print suuid1 +" "+ suuid2
  cur2 = conn.cursor()
  cur2.execute("insert into GroupStdTree (`GroupID`, `ParentGroupID`, `GroupTreeID`, `PlatGroupID`, `PlatParentGroupID`, `GroupName`, `SyncRoundNum`) SELECT %s, %s, 'defaultcbaa5c3d2394438db3c3480fc', %s, %s, %s,3 ;",(suuid1,suuid2,suuid1,suuid2,name1))
  conn.commit()
  cur2.callproc('VAS_PROC_GROUP_PLAT_BIN_GROUP_AddNode',(suuid1,suuid2,3,'defaultcbaa5c3d2394438db3c3480fc','cbaa5c3d2394438db3c3480fc2da3d2c'))
  cur2.close()

conn.close()
