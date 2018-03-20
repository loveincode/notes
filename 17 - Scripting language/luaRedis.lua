local rdebug =     redis.LOG_DEBUG
local rverb =     redis.LOG_VERBOSE
local rntf =    redis.LOG_NOTICE
local rwarn =     redis.LOG_WARNING

local rlog = function(m)
  redis.log(rntf,m)
end
-- 待完成， admin的处理，  搜索，分页查询
local function printTab(tab)
  for i,v in pairs(tab) do
    if type(v) == "table" then
      rlog("table " .. i .. "{")
      printTab(v)
      rlog("}")
    else
      rlog(i .. " -- " .. tostring(v))
    end
  end
end


-- rlog("KEYS:".. #KEYS );
for i=1,#KEYS
do
-- rlog(KEYS[i])
end

-- rlog("ARGV:" .. #ARGV)
local argvsg = ''
for i=1,#ARGV
do
-- rlog(type(ARGV[i]))
-- rlog(ARGV[i])
end

--  function
local debug_flag = true
local function debug(msg,t,ZorS)
  if debug_flag then
    ZorS = ZorS or "Z"
    -- rlog("DEBUG]] " ..msg)
    if type(t) == "table" then
      t = t or {}
      printTab(t)
    elseif  type(t) == "string" then
      if ZorS == "Z" then
        t = redis.call("ZRANGE",t,0,-1)
      elseif ZorS == "S" then
        t = redis.call("SMEMBERS",t)
      end
      printTab(t)
    end
    -- rlog("\n")
  end
end

local function unionRedisSet(ta,dst,step)
  redis.call("DEL",dst )

  local step = step or 1000

  for i=1,#ta,step do
    local packTail = math.min(i+step-1,#ta)
    local packSzie = packTail - i + 1
    redis.call("SUNIONSTORE",dst, dst,unpack(ta,i,packTail) )
  end
end

local function unionRedisZSet(ta,dst,step)
  local step = step or 1000

  redis.call("DEL",dst)

  for i=1,#ta,step do
    local packTail = math.min(i+step-1,#ta)
    local packSzie = packTail - i + 1
    redis.call("ZUNIONSTORE",dst,packSzie+1,dst,unpack(ta,i,packTail) )
  end
end


local function deleteMegaFromSet(ta,dst,step)
  local step = step or 1000

  local tp = redis.call("TYPE",dst)

  -- 不强制删除
  -- redis.call("DEL",dst)

  for i=1,#ta,step do
    local packTail = math.min(i+step-1,#ta)
    local packSzie = packTail - i + 1
    if tp.ok == "zset" then
      redis.call("ZREM",dst,unpack(ta,i,packTail) )
    elseif tp.ok == "set" then
      redis.call("SREM",dst,unpack(ta,i,packTail) )
    end
  end
end


local function saddTable(ta,dst,step)
  local step = step or 1000

  for i=1,#ta,step do
    local packTail = math.min(i+step-1,#ta)
    local packSzie = packTail - i + 1
    redis.call("SADD",dst,unpack(ta,i,packTail) )
  end
end

-- saddTable({1,"a",2,"b"},"ta")

local function convertToTable(t)
  local tmp = {}

  for c = 1, #t, 2 do
    tmp[t[c]] = t[c + 1]
  end
  return tmp
end

local function tableIntersection(...)
  local t = {}

  for i = 1,arg.n do
    for i,v in pairs(arg[i]) do
      t[v] = (t[v] or 0) + 1
    end
  end

  local r = {}
  for i,v in pairs(t) do
    if arg.n == v then
      r[#r+1] = i
    end
  end

  return r
end


local function getIauByIDArray(...)
  local IDs = {}
  for i = 1,arg.n do
    IDs[#IDs+1] = arg[i]
  end

  local result = {}

  for i,id  in pairs(IDs) do
    local obj = redis.call("HGETALL","iau:" .. id)
    if next(obj) ~= nil then
      obj = convertToTable(obj)

      obj.status = ("1" == obj.onlineStatus and {"1"} or {"0"})[1]

      result[#result+1] = obj
    else
      result[#result+1] = false
    end
  end

  return  {cjson.encode(result)}
end





local function iauLogin(heartbeat,iauID, iauIP)

  local iauKey = "iau:" .. iauID
  if redis.call("EXISTS", iauKey) > 0 then
    local mdata = redis.call("HMGET", iauKey, "iauIP", "onlineStatus" )
    if not (mdata[1] and iauIP == mdata[1] ) then
      return {false,"IPNotMatch"}
    elseif mdata[2] and "1" == mdata[2] then
      return {false,"AlreadyOnline"}
    else
      redis.call("HMSET", iauKey, "heartbeat", heartbeat, "onlineStatus", 1 )

      local obj = redis.call("HGETALL", iauKey)

      if next(obj) ~= nil then
        obj = convertToTable(obj)
        obj.status = ("1" == obj.onlineStatus and {"1"} or {"0"})[1]
        return {true,cjson.encode(obj)}
      else
        return {false, "Unknown"}
      end
    end
  else
    return {false,"IauNotExists"}
  end

end


local function iauLogout(iauID, iauIP)
  local iauKey = "iau:" .. iauID
  redis.call("HDEL", iauKey, "onlineStatus", "heartbeat" )
  return {true,"OK"}

end

local function iauHeartBeat(heartbeat, iauID, iauIP)
  local iauKey = "iau:" .. iauID
  if redis.call("EXISTS", iauKey) > 0 then
    local mdata = redis.call("HMGET", iauKey, "iauIP", "onlineStatus" )
    if not (mdata[1] and iauIP == mdata[1] ) then
      return {false,"IPNotMatch"}
    elseif not (mdata[2] and "1" == mdata[2] ) then
      return {false,"NotOnline"}
    else
      redis.call("HSET", iauKey, "heartbeat", heartbeat )
      return {true,"IauLogin OK"}
    end
  else
    return {false,"IauNotExists"}
  end

end

local function searchIau(pageNum, pageSize, orderBy, orderScend, c_name , c_netAddress , c_OnlineStatus, c_version, c_cap )

  local total = redis.call("ZCARD", "Ziau")
  pageNum = tonumber(pageNum)
  pageSize = tonumber(pageSize)
  if pageNum < 0 then
    pageNum = 1
  end

  if pageSize < 0 then
    pageSize = 1
  end

  -- get all matched
  if 0 == pageNum*pageSize then
    pageNum = 1
    pageSize = total
  end

  local resultIDs = {}

  local q_fields = {}

  local flag_name = 0
  if (c_name and string.len(c_name) > 0) then
    flag_name = 1
    c_name = string.lower(c_name)
    q_fields.Name = #q_fields+1
    q_fields[#q_fields+1] = "iauName"
  end

  local flag_netAddress = 0
  if (c_netAddress and string.len(c_netAddress) > 0) then
    flag_netAddress = 1
    q_fields.NetAddress = #q_fields+1
    q_fields[#q_fields+1] = "iauID"
  end

  local flag_OnlineStatus = 0
  if (c_OnlineStatus and string.len(c_OnlineStatus) > 0) then
    flag_OnlineStatus = 1
    q_fields.onlineStatus = #q_fields+1
    q_fields[#q_fields+1] = "onlineStatus"
  end

  local flag_version = 0
  if (c_version and string.len(c_version) > 0) then
    flag_version = 1
    c_version = string.lower(c_version)
    q_fields.Version = #q_fields+1
    q_fields[#q_fields+1] = "iauVersion"
  end

  local flag_cap = 0
  if (c_cap and string.len(c_cap) > 0) then
    flag_cap = 1
    c_cap = string.lower(c_cap)
    q_fields.Capability = #q_fields+1
    q_fields[#q_fields+1] = "iauCap"
  end

  local flag_condtion_total = flag_name  + flag_netAddress  + flag_OnlineStatus  + flag_version + flag_cap

  local zrangeScent = "ZRANGE"

  -- orderBy if not iauName then use "Ziau-orderBy"

  if (orderScend and "DESC" == string.upper(orderScend)) then
    zrangeScent = "ZREVRANGE"
  end

  if flag_condtion_total > 0 then -- 需要过滤
    local IDs = redis.call(zrangeScent, "Ziau", 0 , -1)

    total = 0

    local flag_math = 0

    for i,v  in pairs(IDs) do

      local m_dev = redis.call("HMGET","iau:" .. v, unpack(q_fields))

      flag_math = 0

      local sf =  string.find

      if flag_name > 0 and sf(string.lower(m_dev[q_fields.Name]), c_name,1,true) then
        flag_math = flag_math + 1
      end

      if flag_netAddress > 0 and m_dev[q_fields.NetAddress] and sf(m_dev[q_fields.NetAddress], c_netAddress,1,true) then
        flag_math = flag_math + 1
      end

      if flag_OnlineStatus > 0 and ((not m_dev[q_fields.onlineStatus] and c_OnlineStatus == "0") or (m_dev[q_fields.onlineStatus] == c_OnlineStatus)) then
        flag_math = flag_math + 1
      end

      if flag_version > 0 and m_dev[q_fields.Version] and sf(string.lower(m_dev[q_fields.Version]), c_version,1,true) then
        flag_math = flag_math + 1
      end


      if flag_cap then
        repeat
          if not m_dev[q_fields.Capability] then
            break
          end

          local temp_cap = string.lower(m_dev[q_fields.Capability])

          local it = string.gmatch(c_cap,"%(%w+%)")

          if not it() then
            break
          else
            it = string.gmatch(c_cap,"%(%w+%)")
          end

          local missed_cap = false
          for w in it do
            if  not sf(temp_cap,  string.lower(w) ,1,true)  then
              missed_cap = true
              break
            end
          end

          if missed_cap then
            break
          end

          flag_math = flag_math + 1
        until true

      end

      if flag_math == flag_condtion_total then
        total = total + 1
        if total > (pageNum-1)*pageSize and total <= pageNum*pageSize then
          resultIDs[#resultIDs+1] = v
        end
      end
    end
  else
    resultIDs = redis.call(zrangeScent, "Ziau", (pageNum-1)*pageSize , pageNum*pageSize -1 )
  end

  local result = {}

  for i,v in pairs(resultIDs) do
    local obj = redis.call("HGETALL","iau:" .. resultIDs[i])
    obj = convertToTable(obj)
    obj.status = ("1" == obj.onlineStatus and {"1"} or {"0"})[1]
    result[#result+1] = obj
  end

  local result_json = "[]"
  if #result > 0 then
    result_json = cjson.encode(result)
  end

  local rsp = {
    total = total,
    pageNum = pageNum,
    pageSize = pageSize,
    rspSize = #result,
    orderBy = orderBy,
    orderScend = string.upper(orderScend),
    iauList = result
  }

  -- local rspp = {total,#result,result_json}
  return  {cjson.encode(rsp)}

end


local function getTaskByIDArray(...)
  local IDs = {}
  for i = 1,arg.n do
    IDs[#IDs+1] = arg[i]
  end

  local result = {}

  for i,id  in pairs(IDs) do
    local obj = redis.call("HGETALL","task:" .. id)
    if next(obj) ~= nil then
      obj = convertToTable(obj)

      obj.status = ("1" == obj.onlineStatus and {"1"} or {"0"})[1]

      result[#result+1] = obj
    else
      result[#result+1] = false
    end
  end

  return  {cjson.encode(result)}
end

local function searchTask(pageNum, pageSize, orderBy, orderScend, c_taskName ,c_startTime ,c_endTime , c_taskState )

  local total = redis.call("ZCARD", "Ztask")
  pageNum = tonumber(pageNum)
  pageSize = tonumber(pageSize)

  if pageNum < 0 then
    pageNum = 1
  end

  if pageSize < 0 then
    pageSize = 1
  end

  -- get all matched
  if 0 == pageNum*pageSize then
    pageNum = 1
    pageSize = total
  end

  local resultIDs = {}

  local q_fields = {}

  local flag_taskName = 0
  if (c_taskName and string.len(c_taskName) > 0) then
    flag_taskName = 1
    c_taskName = string.lower(c_taskName)
    q_fields.taskName = #q_fields+1
    q_fields[#q_fields+1] = "taskName"
  end

  local flag_startTime = 0
  if (c_startTime and string.len(c_startTime) > 0) then
    flag_startTime = 1
    c_startTime = tonumber(c_startTime)
    -- 与表中的startTime对比
    q_fields.startTime = #q_fields+1
    q_fields[#q_fields+1] = "startTime"
  end

  local flag_endTime = 0
  if (c_endTime and string.len(c_endTime) > 0) then
    flag_endTime = 1
    c_endTime = tonumber(c_endTime)
    -- 与表中的startTime对比
    q_fields.startTime = #q_fields+1
    q_fields[#q_fields+1] = "startTime"
  end

  local flag_taskState = 0
  if (c_taskState and string.len(c_taskState) > 0) then
    flag_taskState = 1
    q_fields.taskStatus = #q_fields+1
    q_fields[#q_fields+1] = "taskStatus"
  end

  local flag_condtion_total = flag_taskName + flag_startTime + flag_endTime + flag_taskState

  local zrangeScent = "ZRANGE"

  -- orderBy if not iauName then use "Ziau-orderBy"

  if (orderScend and "DESC" == string.upper(orderScend)) then
    zrangeScent = "ZREVRANGE"
  end

  if flag_condtion_total > 0 then -- 需要过滤
    local IDs = redis.call(zrangeScent, "Ztask", 0 , -1)

    total = 0

    local flag_math = 0

    for i,v  in pairs(IDs) do

      local m_dev = redis.call("HMGET","task:" .. v, unpack(q_fields))

      flag_math = 0

      local sf =  string.find

      if flag_taskName > 0 and sf(string.lower(m_dev[q_fields.taskName]), c_taskName,1,true) then
        flag_math = flag_math + 1
      end
      
      
      if flag_startTime > 0 and (tonumber(m_dev[q_fields.startTime]) >= c_startTime)  then
        flag_math = flag_math + 1
      end
      
      if flag_endTime > 0 and (tonumber(m_dev[q_fields.startTime]) <= c_endTime) then
        flag_math = flag_math + 1
      end
      

      if flag_taskState > 0 and ((not m_dev[q_fields.taskStatus] and c_taskState == "0") or (m_dev[q_fields.taskStatus] == c_taskState)) then
        flag_math = flag_math + 1
      end


      if flag_math == flag_condtion_total then
        total = total + 1
        if total > (pageNum-1)*pageSize and total <= pageNum*pageSize then
          resultIDs[#resultIDs+1] = v
        end
      end
    end
  else
    resultIDs = redis.call(zrangeScent, "Ztask", (pageNum-1)*pageSize , pageNum*pageSize -1 )
  end

  local result = {}

  for i,v in pairs(resultIDs) do
    local obj = redis.call("HGETALL","task:" .. resultIDs[i])
    obj = convertToTable(obj)
    obj.status = ("1" == obj.onlineStatus and {"1"} or {"0"})[1]
    result[#result+1] = obj
  end

  local result_json = "[]"
  if #result > 0 then
    result_json = cjson.encode(result)
  end

  local rsp = {
    total = total,
    pageNum = pageNum,
    pageSize = pageSize,
    rspSize = #result,
    orderBy = orderBy,
    orderScend = string.upper(orderScend),
    taskList = result
  }

  -- local rspp = {total,#result,result_json}
  return  {cjson.encode(rsp)}

end

-- 函数负责 拿到当前在线的 iau ID list
local function getOnlineIauIDs()
  
  -- 从 Ziau 和 iau:iauID 中拿到在线的IAUIDs
  
  local total = redis.call("ZCARD", "Ziau")

  local onlineIauIDs = {}

  local q_fields = {}

  local flag_OnlineStatus = 1
  q_fields.onlineStatus = #q_fields+1
  q_fields[#q_fields+1] = "onlineStatus"

  local flag_condtion_total = flag_OnlineStatus

  local zrangeScent = "ZRANGE"

  --过滤
  if flag_condtion_total > 0 then 
    local IDs = redis.call(zrangeScent, "Ziau", 0 , -1)
    total = 0
    local flag_math = 0

    for i,v  in pairs(IDs) do

      local m_dev = redis.call("HMGET","iau:" .. v, unpack(q_fields))

      flag_math = 0

      local sf =  string.find

      if flag_OnlineStatus > 0 and (not not m_dev[q_fields.onlineStatus]) and (m_dev[q_fields.onlineStatus] == "1") then
        flag_math = flag_math + 1
      end

      if flag_math == flag_condtion_total then
          onlineIauIDs[#onlineIauIDs+1] = v
      end
    end
  end
  
  return onlineIauIDs
end

-- 函数负责 根据TaskID计算task的负载度
local function getTaskloadByTaskID(taskID)
  
  -- 从任务设备关系中 取到 Task的 负载度
  -- 需要换 设备 数 通道数 最终以通道为负载度
  local m_dev = redis.call("HMGET","task:" .. taskID, "load")
  
  return tonumber(m_dev[1])
  
end

-- 函数负责 根据IauId 计算 Iau 下所有Task 复杂度
local function getIauloadByIauID(iauId)
  
  -- taskID 去 taskDevice中获取复杂度
  local Taskload = 0
  
  local taskIDs = redis.call("ZRANGE", "Ziautask:" .. iauId, 0 , -1)
  
  for i,v  in pairs(taskIDs) do
    Taskload = Taskload + getTaskloadByTaskID(v)
  end
  return Taskload
  
end

-- 函数负责 得到负载度Min的IauID
local function getLoadMinIauID()
  
  local onlineIauIDs = {}
  onlineIauIDs = getOnlineIauIDs();
  
  if(not not onlineIauIDs) then
      -- 在线IAU  > 1
      if(#onlineIauIDs > 1) then
      
          local iauload = {}
          for i,v  in pairs(onlineIauIDs) do
            iauload[onlineIauIDs[i]] = getIauloadByIauID(onlineIauIDs[i])
            iauload[#iauload+1] = v
          end
          
          local loadMin = tonumber(iauload[iauload[1]])
          local loadMinIauID = iauload[1]
          
          for i=2,#onlineIauIDs,1 do
            
            if(tonumber(iauload[iauload[i]]) < tonumber(loadMin)) then
              loadMin = tonumber(iauload[iauload[i]])
              loadMinIauID = iauload[i]
            end 
            
           end
          
          return loadMinIauID
      
      elseif(#onlineIauIDs == 1) then
          return onlineIauIDs[1]
      else 
          return nil
      end
  end
end

-- 函数负责 得到负载度Max的IauID
local function getLoadMaxIauID()
  
  local onlineIauIDs = {}
  onlineIauIDs = getOnlineIauIDs();
  
  if(not not onlineIauIDs) then
      -- 在线IAU  > 1
      if(#onlineIauIDs > 1) then
      
          local iauload = {}
          for i,v  in pairs(onlineIauIDs) do
            iauload[onlineIauIDs[i]] = getIauloadByIauID(onlineIauIDs[i])
            iauload[#iauload+1] = v
          end
          
          local loadMax = tonumber(iauload[iauload[1]])
          local loadMaxIauID = iauload[1]
          
          for i=2,#onlineIauIDs,1 do
            
            if(tonumber(iauload[iauload[i]]) > tonumber(loadMax)) then
              loadMax = tonumber(iauload[iauload[i]])
              loadMaxIauID = iauload[i]
            end 
            
           end
          
          return loadMaxIauID
      
      elseif(#onlineIauIDs == 1) then
          return onlineIauIDs[1]
      else 
          return nil
      end
  end
end

-- 计算 未分配的 Task到内存
local function getTaskNotAllot()
  
  local alltaskIDs = redis.call("ZRANGE", "Ztask", 0 , -1)
  
  for i,v  in pairs(alltaskIDs) do
      redis.call("ZADD", "Ztasknotallot", 1 , v)
  end
  
  --
  local onlineIauIDs = getOnlineIauIDs();
  if(not not onlineIauIDs) then
      local iauload = {}
      for i,v  in pairs(onlineIauIDs) do
        
        local taskIDs = redis.call("ZRANGE", "Ziautask:" .. onlineIauIDs[i], 0 , -1)
        
        for i,v  in pairs(taskIDs) do
            --删除 未分配的表
            redis.call("ZREM", "Ztasknotallot", v)
        end
      end
  end
  
end

-- 任务调度
local function TaskDispatch(loadThreshold)
  --负载阈值
  loadThreshold = tonumber(loadThreshold)
  
  local onlineIauIDs = getOnlineIauIDs();
  
  if(not not onlineIauIDs) then
      -- 如果有多个Iau
      if(#onlineIauIDs > 1 ) then 
      
          local loadMinIauID = getLoadMinIauID()
          local loadMaxIauID = getLoadMaxIauID()
          
          local loadMin = tonumber(getIauloadByIauID(loadMinIauID))
          local loadMax = tonumber(getIauloadByIauID(loadMaxIauID))
          
          if(loadMax ~= loadMin) then
              if((loadMax - loadMin) >  loadThreshold) then
                  --  负载度最大的 IAU 上断一个 TASK（不在执行的任务） 给负载度最小的 IAU
                  local taskIDs = redis.call("ZRANGE", "Ziautask:" .. loadMaxIauID, 0 , -1)
                  -- 循环 Ziautask:iauID
                  for i,v  in pairs(taskIDs) do
                      -- local m_dev = redis.call("HMGET","task:" .. v, "taskState")
                      -- 判断是否正在执行 如果没在执行
                      redis.call("ZREM", "Ziautask:" .. loadMaxIauID, v)
                      redis.call("ZADD","Ziautask:" .. loadMinIauID, 1 , v )
                      
                      local rsp = {
                        result = "OK",
                        taskID = v,
                        dispatchedIauID = loadMaxIauID,
                        acceptDispatchIauID = loadMinIauID,
                      }
                      return  {cjson.encode(rsp)}
                  end
              
              else 
                  local rsp = {
                    result = "NO",
                    message = "not exceed threshold",
                  }
                  return  {cjson.encode(rsp)}
              end
              
          else
              local rsp = {
                 result = "NO",
                 message = "Avg",
              }
              return  {cjson.encode(rsp)}
          end
          
      end  
      
      local rsp = {
          result = "NO",
          message = "Just One IAU",
      }  
      return  {cjson.encode(rsp)}
  end
  
  local rsp = {
    result = "NO",
    message = "No IAU",
  }  
  return  {cjson.encode(rsp)}
  
end

-- 函数负责 新增任务分配给 负载度Min 的IAU
local function NewTaskAllot(taskID)
  
  local loadMinIauID = getLoadMinIauID()
  
  if(not not loadMinIauID) then 
    -- 将 task分配 给 这个Min的 Iau
    redis.call("ZADD","Ziautask:" .. loadMinIauID, 1 , taskID )
    
    local rsp = {
      taskID = taskID,
      loadMinIauID = loadMinIauID,
    }
    
    return  {cjson.encode(rsp)}
  -- 不存在在线的 IAU
  else   
    return {false,"not"}
  end
   
end

-- 函数负责 新注册上来的 Iau 将去把所有未分配的Task任务接下
local function NewIauAllot(IauID)
  
  getTaskNotAllot()
  
  local allnotallottaskIDs = redis.call("ZRANGE", "Ztasknotallot", 0 , -1)
  
  local rsp={}
  
  if(not not allnotallottaskIDs) then
      for i,v  in pairs(allnotallottaskIDs) do
          redis.call("ZADD","Ziautask:" .. IauID, 1 , v )
          redis.call("ZREM","Ztasknotallot", v )
          rsp[#rsp+1] = v
      end
  else 
     return {false,"not"}
  end
  
  return  {cjson.encode(rsp)}
   
end

-- 函数负责 将Iau下的Task依次分配给 当前 负载度Min 的IAu
local function IauTaskAllot(iauID)
  
  -- 将该iau的 状态删除    和  心跳 ？
  local iauKey = "iau:" .. iauID
  redis.call("HDEL", iauKey, "onlineStatus")
  
  local taskIDs = redis.call("ZRANGE", "Ziautask:" .. iauID, 0 , -1)
  
  local rsp = {}
  
  -- 循环 Ziautask:iauID 
  for i,v  in pairs(taskIDs) do
    --先从 iau下删除
    redis.call("ZREM", "Ziautask:" .. iauID, v)
    -- 找到最小的 IauID
    local loadMinIauID = getLoadMinIauID()
    
    if(not not loadMinIauID) then 
      redis.call("ZADD","Ziautask:" .. loadMinIauID, 1 , v )
      rsp[#rsp+1] = tostring(v)
      rsp[#rsp+1] = tostring(loadMinIauID)
    else
      return {false,"not"}
    end
    
  end
  
  return  {cjson.encode(rsp)}
  
end

local function addIauData()
  
  redis.call("HMSET", "iau:iauID1", "iauID" ,"iauID1","onlineStatus","1")
  redis.call("HMSET", "iau:iauID2", "iauID" ,"iauID2","onlineStatus","1")
  redis.call("HMSET", "iau:iauID3", "iauID" ,"iauID3")
  redis.call("HMSET", "iau:iauID4", "iauID" ,"iauID4")
  redis.call("HMSET", "iau:iauID5", "iauID" ,"iauID5","onlineStatus","1")
  
  redis.call("ZADD", "Ziau", 1 ,"iauID1")
  redis.call("ZADD", "Ziau", 1 ,"iauID2")
  redis.call("ZADD", "Ziau", 1 ,"iauID3")
  redis.call("ZADD", "Ziau", 1 ,"iauID4")
  redis.call("ZADD", "Ziau", 1 ,"iauID5")
  
end

local function addTaskData()
  
  redis.call("HMSET", "task:taskID1", "taskID" ,"taskID1","load",1000)
  redis.call("HMSET", "task:taskID2", "taskID" ,"taskID2","load",1000)
  redis.call("HMSET", "task:taskID3", "taskID" ,"taskID3","load",1000)
  redis.call("HMSET", "task:taskID4", "taskID" ,"taskID4","load",1000)  
  redis.call("HMSET", "task:taskID5", "taskID" ,"taskID5","load",1000)
  redis.call("HMSET", "task:taskID6", "taskID" ,"taskID6","load",1000) 
  redis.call("HMSET", "task:taskID7", "taskID" ,"taskID7","load",1000) 
  redis.call("HMSET", "task:taskID8", "taskID" ,"taskID8","load",1000) 
  redis.call("HMSET", "task:taskID9", "taskID" ,"taskID9","load",1000) 
  redis.call("HMSET", "task:taskID10", "taskID" ,"taskID10","load",1000) 
  
  redis.call("ZADD", "Ztask", 1 ,"taskID1")
  redis.call("ZADD", "Ztask", 1 ,"taskID2")
  redis.call("ZADD", "Ztask", 1 ,"taskID3")
  redis.call("ZADD", "Ztask", 1 ,"taskID4")
  redis.call("ZADD", "Ztask", 1 ,"taskID5")
  redis.call("ZADD", "Ztask", 1 ,"taskID6")
  redis.call("ZADD", "Ztask", 1 ,"taskID7")
  redis.call("ZADD", "Ztask", 1 ,"taskID8")
  redis.call("ZADD", "Ztask", 1 ,"taskID9")
  redis.call("ZADD", "Ztask", 1 ,"taskID10")
  
end

local function addIauTaskData()
  
  redis.call("ZADD", "Ziautask:iauID1", 1 ,"taskID1")

  redis.call("ZADD", "Ziautask:iauID2", 1 ,"taskID2")
  redis.call("ZADD", "Ziautask:iauID2", 1 ,"taskID3")
  redis.call("ZADD", "Ziautask:iauID2", 1 ,"taskID4")
  
  redis.call("ZADD", "Ziautask:iauID5", 1 ,"taskID5")
  redis.call("ZADD", "Ziautask:iauID5", 1 ,"taskID6")
  redis.call("ZADD", "Ziautask:iauID5", 1 ,"taskID7")
  redis.call("ZADD", "Ziautask:iauID5", 1 ,"taskID8")
  redis.call("ZADD", "Ziautask:iauID5", 1 ,"taskID9")
  redis.call("ZADD", "Ziautask:iauID5", 1 ,"taskID10")
  
end

local switch = {

    getIauByIDArray = getIauByIDArray,
    searchIau = searchIau,
    iauLogin = iauLogin,
    iauLogout = iauLogout,
    iauHeartBeat = iauHeartBeat,

    getTaskByIDArray = getTaskByIDArray,
    searchTask = searchTask,
    
    TaskDispatch = TaskDispatch,
    NewTaskAllot = NewTaskAllot,
    NewIauAllot = NewIauAllot,
    IauTaskAllot = IauTaskAllot,
    
    -- debug
    getOnlineIauIDs = getOnlineIauIDs,
    getTaskloadByTaskID = getTaskloadByTaskID,
    getIauloadByIauID = getIauloadByIauID,
    getLoadMinIauID = getLoadMinIauID,
    getLoadMaxIauID = getLoadMaxIauID,
    
    getTaskNotAllot = getTaskNotAllot,
    
    -- 模拟数据
    addIauData = addIauData,
    addTaskData = addTaskData,
    addIauTaskData = addIauTaskData,

    niltail = nil
}


local cmd = switch[KEYS[1]]
if(cmd) then
  return cmd(unpack(KEYS,2))
else
  return "no such method"
end