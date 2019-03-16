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

local CRC32_static = {
    0x00000000, 0x77073096, 0xee0e612c, 0x990951ba,     0x076dc419, 0x706af48f, 0xe963a535, 0x9e6495a3,     0x0edb8832, 0x79dcb8a4, 0xe0d5e91e, 0x97d2d988,     0x09b64c2b, 0x7eb17cbd, 0xe7b82d07, 0x90bf1d91,
    0x1db71064, 0x6ab020f2, 0xf3b97148, 0x84be41de,     0x1adad47d, 0x6ddde4eb, 0xf4d4b551, 0x83d385c7,     0x136c9856, 0x646ba8c0, 0xfd62f97a, 0x8a65c9ec,     0x14015c4f, 0x63066cd9, 0xfa0f3d63, 0x8d080df5,
    0x3b6e20c8, 0x4c69105e, 0xd56041e4, 0xa2677172,     0x3c03e4d1, 0x4b04d447, 0xd20d85fd, 0xa50ab56b,     0x35b5a8fa, 0x42b2986c, 0xdbbbc9d6, 0xacbcf940,     0x32d86ce3, 0x45df5c75, 0xdcd60dcf, 0xabd13d59,
    0x26d930ac, 0x51de003a, 0xc8d75180, 0xbfd06116,     0x21b4f4b5, 0x56b3c423, 0xcfba9599, 0xb8bda50f,     0x2802b89e, 0x5f058808, 0xc60cd9b2, 0xb10be924,     0x2f6f7c87, 0x58684c11, 0xc1611dab, 0xb6662d3d,
    0x76dc4190, 0x01db7106, 0x98d220bc, 0xefd5102a,     0x71b18589, 0x06b6b51f, 0x9fbfe4a5, 0xe8b8d433,     0x7807c9a2, 0x0f00f934, 0x9609a88e, 0xe10e9818,     0x7f6a0dbb, 0x086d3d2d, 0x91646c97, 0xe6635c01,
    0x6b6b51f4, 0x1c6c6162, 0x856530d8, 0xf262004e,     0x6c0695ed, 0x1b01a57b, 0x8208f4c1, 0xf50fc457,     0x65b0d9c6, 0x12b7e950, 0x8bbeb8ea, 0xfcb9887c,     0x62dd1ddf, 0x15da2d49, 0x8cd37cf3, 0xfbd44c65,
    0x4db26158, 0x3ab551ce, 0xa3bc0074, 0xd4bb30e2,     0x4adfa541, 0x3dd895d7, 0xa4d1c46d, 0xd3d6f4fb,     0x4369e96a, 0x346ed9fc, 0xad678846, 0xda60b8d0,     0x44042d73, 0x33031de5, 0xaa0a4c5f, 0xdd0d7cc9,
    0x5005713c, 0x270241aa, 0xbe0b1010, 0xc90c2086,     0x5768b525, 0x206f85b3, 0xb966d409, 0xce61e49f,     0x5edef90e, 0x29d9c998, 0xb0d09822, 0xc7d7a8b4,     0x59b33d17, 0x2eb40d81, 0xb7bd5c3b, 0xc0ba6cad,
    0xedb88320, 0x9abfb3b6, 0x03b6e20c, 0x74b1d29a,     0xead54739, 0x9dd277af, 0x04db2615, 0x73dc1683,     0xe3630b12, 0x94643b84, 0x0d6d6a3e, 0x7a6a5aa8,     0xe40ecf0b, 0x9309ff9d, 0x0a00ae27, 0x7d079eb1,
    0xf00f9344, 0x8708a3d2, 0x1e01f268, 0x6906c2fe,     0xf762575d, 0x806567cb, 0x196c3671, 0x6e6b06e7,     0xfed41b76, 0x89d32be0, 0x10da7a5a, 0x67dd4acc,     0xf9b9df6f, 0x8ebeeff9, 0x17b7be43, 0x60b08ed5,
    0xd6d6a3e8, 0xa1d1937e, 0x38d8c2c4, 0x4fdff252,     0xd1bb67f1, 0xa6bc5767, 0x3fb506dd, 0x48b2364b,     0xd80d2bda, 0xaf0a1b4c, 0x36034af6, 0x41047a60,     0xdf60efc3, 0xa867df55, 0x316e8eef, 0x4669be79,
    0xcb61b38c, 0xbc66831a, 0x256fd2a0, 0x5268e236,     0xcc0c7795, 0xbb0b4703, 0x220216b9, 0x5505262f,     0xc5ba3bbe, 0xb2bd0b28, 0x2bb45a92, 0x5cb36a04,     0xc2d7ffa7, 0xb5d0cf31, 0x2cd99e8b, 0x5bdeae1d,
    0x9b64c2b0, 0xec63f226, 0x756aa39c, 0x026d930a,     0x9c0906a9, 0xeb0e363f, 0x72076785, 0x05005713,     0x95bf4a82, 0xe2b87a14, 0x7bb12bae, 0x0cb61b38,     0x92d28e9b, 0xe5d5be0d, 0x7cdcefb7, 0x0bdbdf21,
    0x86d3d2d4, 0xf1d4e242, 0x68ddb3f8, 0x1fda836e,     0x81be16cd, 0xf6b9265b, 0x6fb077e1, 0x18b74777,     0x88085ae6, 0xff0f6a70, 0x66063bca, 0x11010b5c,     0x8f659eff, 0xf862ae69, 0x616bffd3, 0x166ccf45,
    0xa00ae278, 0xd70dd2ee, 0x4e048354, 0x3903b3c2,     0xa7672661, 0xd06016f7, 0x4969474d, 0x3e6e77db,     0xaed16a4a, 0xd9d65adc, 0x40df0b66, 0x37d83bf0,     0xa9bcae53, 0xdebb9ec5, 0x47b2cf7f, 0x30b5ffe9,
    0xbdbdf21c, 0xcabac28a, 0x53b39330, 0x24b4a3a6,     0xbad03605, 0xcdd70693, 0x54de5729, 0x23d967bf,     0xb3667a2e, 0xc4614ab8, 0x5d681b02, 0x2a6f2b94,     0xb40bbe37, 0xc30c8ea1, 0x5a05df1b, 0x2d02ef8d
}

local function getIntPart(x)
    if x<= 0 then
        return math.ceil(x)
    end
    if math.ceil(x) == x then
        x = math.ceil(x)
    else
        x = math.ceil(x)-1
    end


    return x
end


local function table_crc32(...)

    local xor = bit.bxor
    local lshift = bit.lshift
    local rshift = bit.rshift
    local band = bit.band

    local crc = 2 ^ 32 - 1

    for i = 1,arg.n do
        local t = arg[i]

        for m = 1, #t do
            local str = t[m]

            for x =1 ,string.len(str) do
                local byte = string.byte(str, x)
                crc = xor(rshift(crc, 8), CRC32_static[xor(band(crc, 0xFF), byte) + 1])
            end
        end
    end

    crc = xor(crc, 0xFFFFFFFF)
    -- dirty hack for bitop return number < 0
    if crc < 0 then crc = crc + 2 ^ 32 end

    return string.format("%X", crc)
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


local function zset2set(src,dst,step)
       local step = step or 1000

       local total = redis.call("ZCARD", src)

       for i=0 , total - 1, step do
         local m = redis.call("ZRANGE" ,src, i, i + step -1)
         if #m then
             redis.call("SADD",dst,unpack(m) )
         end
       end
end


local function unionRedisSet(ta,dst,step)
  redis.call("UNLINK",dst )

  local step = step or 5000

  for i=1,#ta,step do
    local packTail = math.min(i+step-1,#ta)
    local packSzie = packTail - i + 1
    redis.call("SUNIONSTORE",dst, dst,unpack(ta,i,packTail) )
  end
end

local function unionRedisZSet(clear, dst, ta,step)
  local step = step or 5000
    if clear then
      redis.call("UNLINK",dst)
    end

  for i=1,#ta,step do
    local packTail = math.min(i+step-1,#ta)
    local packSzie = packTail - i + 1
    redis.call("ZUNIONSTORE",dst,packSzie+1,dst,unpack(ta,i,packTail) )
  end
end


local function deleteMegaKeys(ta, limit, step)
  local step = step or 10
  limit = tonumber(limit) or #ta

  for i=1,limit,step do
    local packTail = math.min(i+step-1, limit)
      redis.call("UNLINK", unpack(ta,i,packTail) )
  end
end


local function deleteMegaFromSet(ta,dst,step)
  local step = step or 1000

  local tp = redis.call("TYPE",dst)

  -- 不强制删除
  -- redis.call("UNLINK",dst)

  for i=1,#ta,step do
    local packTail = math.min(i+step-1,#ta)

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

local function convertToTable(t, numberical)
  local tmp = {}
  local keys = {}

  for c = 1, #t, 2 do
    keys[#keys+1] = t[c]
    -- tmp[t[c]] = tonumber(t[c + 1]) or t[c + 1]
    if(numberical and numberical[t[c]]) then
        tmp[t[c]] = tonumber(t[c + 1])
    else
        tmp[t[c]] = t[c + 1]
    end
  end
  return tmp, keys
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



local NumbericalMark = {

    iau = {"iauPort",
           "iauPriority",
           "iauRegTime",
           "isInner",
           },

    pau = {"pauPort",
           "pauPriority",
           "pauRegTime",
           "isInner",
           },

    plat = {"isTopPlat",
           "platPort",
           "platDBPort",
           "platTypeID",
           "pauOnlineStatus",
           "platRedisPort",
           "onlineCount",
           },

    chn = {"sequnceNum",
           "ptzType",
           "positionType",
           "roomType",
           "useType",
           "supplyLightType",
           "directionType",
           "videoSrcNum",
           "encodeNum",
           "callType",
           "channelTypeID",
           "capbility",
           "deviceType",
           "isChannel",
           "isGuobiao",
           "isMajor",
           "syncRoundNum",
           "useFlag",
           "vasUseFlag",
           },

    group = {
           "groupTypeID",
           "syncRoundNum",
           "leftScore",
           "rightScore",
           "depthScore",

    },

    task = {
           "period",
           "taskPriority",
           "finishedCount",
           "modifyTime",
           "createTime",
           "progress",
           "startTime",
           "detectionChannel",
           "exeCount",
           "instantTotalCount",
           "taskStatus",
    },

    tree = {
        "rank",
        "syncRoundNum",
    },

    slaveVas = {
        "slaveVasPort",
    },

}

local NumbericalMark_All = {onlineStatus =true}
for i,v in pairs(NumbericalMark) do
    for _i,_v in pairs(v) do
        NumbericalMark_All[_v] = true
    end
end

local function getPlatSrcKeyPrefix()
    local p = redis.call("LRANGE", "LPlatSrcKeyPrefix", 0 ,0)
  return p[1]
end

local function countChannel()
    local devicePrefix = getPlatSrcKeyPrefix()
    local groupDevicePrefix = getPlatSrcKeyPrefix()
    local targetDeviceKey = devicePrefix .. ":Zchannel"
    local total = redis.call("ZCARD", targetDeviceKey)
    return {total}
end

local function searchChannel(pageJson, cretiriaJson, targetRedisKey)
--local function searchChannel(pageNum, pageSize, orderBy, orderScend, c_tree, c_group ,c_name , c_netAddress , c_OnlineStatus )

    local cacheTTL = 60

    local t_page = cjson.decode(pageJson)
    local t_cretiria = cjson.decode(cretiriaJson)

    local orderBy = t_page.orderBy or "pauName"
    local orderScend = t_page.orderScend or "ASC"

    local pageNum = math.abs(tonumber(t_page.pageNum) or 0)
    local pageSize = math.abs(tonumber(t_page.pageSize) or 0)

    local rangeStart = (pageNum-1)*pageSize
    local rangeEnd = pageNum*pageSize -1

    if 0 == pageNum*pageSize then   -- get all matched
        rangeStart = 0
        rangeEnd = -1
    end

    local zrangeScent = "ZRANGE"

    if (orderScend and "DESC" == string.upper(orderScend)) then
        zrangeScent = "ZREVRANGE"
    end



    --search cretira
    local c_tree = t_cretiria.treeID
    local c_group = t_cretiria.groupID
    local c_name = t_cretiria.channelAlias
    local c_kdmNO = t_cretiria.kdmNO
    local c_manufacturer = t_cretiria.manufacturer
    local c_netAddress = t_cretiria.deviceIP
    local c_OnlineStatus = tonumber(t_cretiria.onlineStatus)
    if c_OnlineStatus then
        c_OnlineStatus = tostring(c_OnlineStatus)
    end

    local c_version = t_cretiria.platVersion
    local c_cap = t_cretiria.platCap
    local c_IsTopStatus = tonumber(t_cretiria.isTopPlat)
    if c_IsTopStatus then
        c_IsTopStatus = tostring(c_IsTopStatus)
    end

    local q_fields = {}

    local flag_group = 0
    if (c_group and string.len(c_group) > 0) then
      flag_group = 1
      c_group = string.lower(c_group)
    end

    local flag_tree = 0
    if (c_tree and string.len(c_tree) > 0) then
      flag_tree = 1
      c_tree = string.lower(c_tree)
    end


    local flag_name = 0
    if (c_name and string.len(c_name) > 0) then
      flag_name = 1
      c_name = string.lower(c_name)
      q_fields.Name = #q_fields+1
      q_fields[#q_fields+1] = "channelAlias"
    end

    local flag_kdmNO = 0
    if (c_kdmNO and string.len(c_kdmNO) > 0) then
      flag_kdmNO = 1
      c_kdmNO = string.lower(c_kdmNO)
      q_fields.KDMNO = #q_fields+1
      q_fields[#q_fields+1] = "kdmNO"
    end

    local flag_manufacturer = 0
    if (c_manufacturer and string.len(c_manufacturer) > 0) then
      flag_manufacturer = 1
      c_manufacturer = string.lower(c_manufacturer)
      q_fields.manufacturer = #q_fields+1
      q_fields[#q_fields+1] = "manufacturer"
    end


    local flag_netAddress = 0
    if (c_netAddress and string.len(c_netAddress) > 0) then
      flag_netAddress = 1
      q_fields.NetAddress = #q_fields+1
      q_fields[#q_fields+1] = "deviceIP"
    end

    local flag_OnlineStatus = 0
    if (c_OnlineStatus and string.len(c_OnlineStatus) > 0) then
      flag_OnlineStatus = 1
      q_fields.onlineStatus = #q_fields+1
      q_fields[#q_fields+1] = "onlineStatus"
    end

    local flag_condtion_total = flag_name + flag_kdmNO + flag_manufacturer + flag_netAddress  + flag_OnlineStatus


    local devicePrefix = getPlatSrcKeyPrefix()
    local groupDevicePrefix = getPlatSrcKeyPrefix()
    local targetDeviceKey = devicePrefix .. ":Zchannel"

    local tempKeyPostfix = redis.call("CONFIG","GET","PORT")[2]

    local queryDNA = ""
    if flag_tree > 0  then
       queryDNA = queryDNA .. "T:" .. c_tree
    end

    if flag_name > 0  then
       queryDNA = queryDNA .. "N:" .. c_name
    end

    if flag_kdmNO > 0  then
        queryDNA = queryDNA .. "K:" .. c_kdmNO
    end

    if flag_manufacturer > 0  then
        queryDNA = queryDNA .. "M:" .. c_manufacturer
    end

    -- 不同的树有不同的设备来源key
    if flag_tree > 0 then
        if  flag_group > 0 then

            local tempKey = "T-searchChannel" .. tempKeyPostfix

            local groupdevicekey = groupDevicePrefix .. ":" .. c_tree .. ":" .. "Sgroupchannel:" .. c_group

            redis.call("ZINTERSTORE", tempKey, 2, groupdevicekey, targetDeviceKey)

            targetDeviceKey = tempKey
        else
            targetDeviceKey = devicePrefix .. ":Ztreechannel:" .. c_tree
        end

    end

    if targetRedisKey then -- 如果指定了key使用指定的key, 优先级最高
        targetDeviceKey = targetRedisKey
    end


    if flag_condtion_total > 0 then -- 需要生成cache

        local CacheSearchChannel_key = devicePrefix .. "CacheSearchChannel" .. tempKeyPostfix .. queryDNA
        redis.call("EXPIRE", CacheSearchChannel_key, cacheTTL) --缓存保持30s

        local hasCache = ( 1 == redis.call("EXISTS", CacheSearchChannel_key) )
        if hasCache then -- 有缓存
            targetDeviceKey = CacheSearchChannel_key
        else
            local IDs = redis.call(zrangeScent, targetDeviceKey, 0 , -1)

            local flag_math = 0

            local resultIDs = {}

            for i,v  in pairs(IDs) do

                local m_dev = redis.call("HMGET",devicePrefix .. ":channel:" .. v, unpack(q_fields))

                flag_math = 0

                local sf =  string.find

                -- 模糊搜索名称和通道id
                --if flag_name > 0 and (sf(string.lower(m_dev[q_fields.Name]), c_name,1,true) or sf(string.lower(m_dev[q_fields.KDMNO]), c_name,1,true) )then
                --flag_math = flag_math + 1
                --end

                -- 模糊搜索名称
                if flag_name > 0 and (sf(string.lower(m_dev[q_fields.Name]), c_name,1,true) )then
                    flag_math = flag_math + 1
                end

                -- 通道id
                if flag_kdmNO > 0 and (sf(string.lower(m_dev[q_fields.KDMNO]), c_kdmNO,1,true) )then
                    flag_math = flag_math + 1
                end

                -- 厂商
                if flag_manufacturer > 0 and (sf(string.lower(m_dev[q_fields.manufacturer]), c_manufacturer,1,true) )then
                    flag_math = flag_math + 1
                end

                if flag_netAddress > 0 and m_dev[q_fields.NetAddress] and sf(m_dev[q_fields.NetAddress], c_netAddress,1,true) then
                flag_math = flag_math + 1
                end

                if flag_OnlineStatus > 0 and ((not m_dev[q_fields.onlineStatus] and c_OnlineStatus == "0") or (m_dev[q_fields.onlineStatus] == c_OnlineStatus)) then
                flag_math = flag_math + 1
                end

                if flag_math == flag_condtion_total then
                        resultIDs[#resultIDs+1] = v
                end
            end

            saddTable(resultIDs, CacheSearchChannel_key)
            redis.call("ZUNIONSTORE", CacheSearchChannel_key, 1, CacheSearchChannel_key)
            redis.call("EXPIRE", CacheSearchChannel_key, cacheTTL) --缓存保持30s

            targetDeviceKey = CacheSearchChannel_key

        end

    end

    local rangeResultIDs = redis.call(zrangeScent, targetDeviceKey, rangeStart , rangeEnd )

    local result = {}

    for i,v in pairs(rangeResultIDs) do
        local obj = redis.call("HGETALL", devicePrefix .. ":channel:" .. v)
        obj = convertToTable(obj, NumbericalMark_All)

        result[#result+1] = obj
    end

    local total = redis.call("ZCARD", targetDeviceKey)

    local rsp = {
        total = total,
        pageNum = pageNum,
        pageSize = pageSize,
        netSize = #result,
        orderBy = orderBy,
        orderScend = string.upper(orderScend),
        channelList = result
    }

    return  {cjson.encode(rsp)}

end


local function searchBlacklist(pageJson, cretiriaJson)
    local devicePrefix = getPlatSrcKeyPrefix()

    return searchChannel(pageJson, cretiriaJson, tostring(devicePrefix) .. ":blackList")
end

local function getChildGroup(groupPrefix, parentGroupID, lv)

      --     db0pipe.zadd(platGroupKeyPrefix + "ZgroupSort", Yindex, row["groupID"]) #排序
      --
      --     db0pipe.zadd(platGroupKeyPrefix + "ZgroupLeft", row["leftScore"], row["groupID"])
      --     db0pipe.zadd(platGroupKeyPrefix + "ZgroupRight", row["rightScore"], row["groupID"])
      --     db0pipe.zadd(platGroupKeyPrefix + "ZgroupDepth", row["depthScore"], row["groupID"])
      --
  groupPrefix = groupPrefix or ""

  local childGroupID = {}

  local parentGroup = redis.call("HGETALL",groupPrefix .. "group:" .. parentGroupID)
  if next(parentGroup) ~= nil then

    parentGroup = convertToTable(parentGroup, NumbericalMark_All)

    local leftSet = {}
    local rightSet = {}
    local depthSet = {}

  leftSet = redis.call("ZRANGEBYSCORE", groupPrefix .. "ZgroupLeft", parentGroup["leftScore"] ,'+inf')

  rightSet = redis.call("ZRANGEBYSCORE", groupPrefix .. "ZgroupRight",'-inf', parentGroup["rightScore"])

    if(-1 == lv + 0) then
        depthSet = redis.call("ZRANGEBYSCORE", groupPrefix .. "ZgroupDepth",parentGroup["depthScore"] + 1,'+inf')
    else
        depthSet = redis.call("ZRANGEBYSCORE", groupPrefix .. "ZgroupDepth",parentGroup["depthScore"] + 1,parentGroup["depthScore"] + lv)
    end

  local innerSet = tableIntersection(leftSet, rightSet, depthSet)


  local tempKeyPostfix = redis.call("CONFIG","GET","PORT")[2]
    local tempKeySort = "T-getchildgroup-sort" .. tempKeyPostfix
  redis.call("UNLINK", tempKeySort)
    saddTable(innerSet,tempKeySort)

    redis.call("ZINTERSTORE",tempKeySort, 2 ,tempKeySort,groupPrefix .. "ZgroupSort",'WEIGHTS',0,1,'AGGREGATE', 'MAX')

    childGroupID = redis.call("ZRANGE",tempKeySort,0,-1)

  end

  return childGroupID
end


local function getGroupTree()
    local prefix = getPlatSrcKeyPrefix()
    local treeIDs = redis.call("ZRANGE", prefix .. ":Zgrouptree", 0 , -1 )
    local trees = {}


    if treeIDs then
        for i,id in ipairs(treeIDs) do
            local t = redis.call("HGETALL", prefix .. ":grouptree:" .. id)
            t = convertToTable(t, NumbericalMark_All)

            t.groupNum = redis.call("ZCARD", prefix .. ":" .. id .. ":ZgroupRight" )

            trees[#trees+1] = t
        end
    end

    local json = "[]"
    if #trees > 0 then
        json = cjson.encode(trees)
    end

    return {json}
end


local function getTreeChildGroup(treeID, parentGroupID, lv)
    lv = lv or 1
    local pgkp  = getPlatSrcKeyPrefix()
    if not pgkp then
        return {false,{}}
    end

    pgkp = pgkp .. ":" .. treeID .. ":"

    local q_fields = {}
    q_fields.groupID = #q_fields+1
    q_fields[#q_fields+1] = "groupID"

    q_fields.groupName = #q_fields+1
    q_fields[#q_fields+1] = "groupName"

    q_fields.rightScore = #q_fields+1
    q_fields[#q_fields+1] = "rightScore"

    q_fields.leftScore = #q_fields+1
    q_fields[#q_fields+1] = "leftScore"

	local result = {}

    -- lv == -2表示 取本身+子节点 用于树形结构全部加载使用
	if lv == "-2" then
		q_fields.parentGroupID = #q_fields+1
		q_fields[#q_fields+1] = "parentGroupID"
        -- -1 获取所有子节点
        local ids = getChildGroup(pgkp, parentGroupID, -1)
        -- 加上自己的ID
        ids[#ids+1]=parentGroupID
		for i,v in pairs(ids) do

			local obj = redis.call("HMGET",pgkp .. "group:" .. v, unpack(q_fields))

            local chnCount = redis.call("SCARD", pgkp .. "Sgroupchannel:" .. v)

			if next(obj) ~= nil then
				local node = {chnCount = chnCount}
                node.id = obj[q_fields.groupID]
                if v == parentGroupID then
                    --父节点的parent 规定为#
                    node.parent = "#"
                else
                    node.parent = obj[q_fields.parentGroupID]
                end
				node.text = obj[q_fields.groupName]
				result[#result+1] = node
			else
				result[#result+1] = {}
			end
		end
		return {#ids, cjson.encode(result), ids}
	else
		local ids = getChildGroup(pgkp, parentGroupID, lv)
		for i,v in pairs(ids) do
			local obj = redis.call("HMGET",pgkp .. "group:" .. v, unpack(q_fields))

            local chnCount = redis.call("SCARD", pgkp .. "Sgroupchannel:" .. v)

			if next(obj) ~= nil then
				-- obj = convertToTable(obj, NumbericalMark_All)
				-- result[#result+1] = obj
				local node = {chnCount = chnCount}
				node.id = obj[q_fields.groupID]
				node.text = obj[q_fields.groupName]
				if tonumber(obj[q_fields.rightScore]) - tonumber(obj[q_fields.leftScore]) == 1 then
					node.children = false
				else
					node.children = true
				end
				result[#result+1] = node
			else
				result[#result+1] = {}
			end
		end
		return {#ids, cjson.encode(result), ids}
	end

end



local function getPauByIDArray(...)
    local IDs = {}
    for i = 1,arg.n do
       IDs[#IDs+1] = arg[i]
    end

    local result = {}

    local cnt = 0
    for i,id  in pairs(IDs) do
        local obj = redis.call("HGETALL","pau:" .. id)
        if next(obj) ~= nil then
            obj = convertToTable(obj, NumbericalMark_All)
            local platCount = redis.call("SCARD", "pau-platform:" .. id)
            obj.platCount = tonumber(platCount)
            result[#result+1] = obj
            cnt = cnt + 1
        else
            result[#result+1] = {}
        end
    end

    return  {cnt == #IDs, cjson.encode(result)}
end


local function getPauStatusByIDArray(...)
    local IDs = {}
    for i = 1,arg.n do
       IDs[#IDs+1] = arg[i]
    end

    local result = {}

    local cnt = 0
    for i,id  in pairs(IDs) do
        local missingFlag = (0 == redis.call("EXISTS", "pau:" .. id))
        local obj = redis.call("HMGET","pau:" .. id, "onlineStatus", "pauIP", "pauVersion", "pauRegTimeStr")
        local platCount = redis.call("SCARD", "pau-platform:" .. id)
        result[#result+1] = {pauID = id , onlineStatus = (tonumber(obj[1]) or 0), missing = missingFlag, pauIP = obj[2], pauVersion = obj[3], pauRegTimeStr= obj[4], platCount=tonumber(platCount)}
        cnt = cnt + 1
    end

    return  {cnt == #IDs, cjson.encode(result)}
end


local function getPlatStatusByIDArray(...)
    local IDs = {}
    for i = 1,arg.n do
       IDs[#IDs+1] = arg[i]
    end

    local result = {}

    local cnt = 0
    for i,id  in pairs(IDs) do
        local missingFlag = (0 == redis.call("EXISTS", "platform:" .. id))
        local obj = redis.call("HMGET","platform:" .. id, "pauID", "platIP", "platTypeID")
        obj = {platID = id , pauID = obj[1], missing = missingFlag, platIP = obj[2],
          platTypeID = tonumber(obj[3]) }

        if(obj.pauID) then
                local pauObj = redis.call("HGETALL", "pau:" .. obj.pauID)
                if next(pauObj) ~= nil then
                    pauObj = convertToTable(pauObj, NumbericalMark_All)
                    obj.pauID = pauObj.pauID
                    obj.pauIP = pauObj.pauIP
                    obj.pauPort = pauObj.pauPort
                    obj.pauName = pauObj.pauName
                    obj.pauOnlineStatus = tonumber(("1" == tostring(pauObj.onlineStatus) and {"1"} or {"0"})[1]  )
                    --从绑定的pau取在线状态
                    local tField = redis.call("HMGET","platform:" .. id, "onlineStatus@" .. obj.pauID, "platRegTimeStr@" .. obj.pauID, "registerErrorCode@" .. obj.pauID)

                    obj.onlineStatus = tonumber(tField[1]) or 0
                    obj.platRegTimeStr = tField[2] or ""
                    obj.registerErrorCode = tField[3] or ""
                else
                    obj.onlineStatus = 0
                    obj.platRegTimeStr = ""
                    obj.registerErrorCode = ""
                end
        end

        result[#result+1] = obj
        cnt = cnt + 1
    end

    return  {cnt == #IDs, cjson.encode(result)}
end


local function searchPau(pageJson, cretiriaJson, targetRedisKey)
    local t_page = cjson.decode(pageJson)
    local t_cretiria = cjson.decode(cretiriaJson)

    local orderBy = t_page.orderBy or "pauName"
    local orderScend = t_page.orderScend or "ASC"

    local pageNum = math.abs(tonumber(t_page.pageNum) or 0)
    local pageSize = math.abs(tonumber(t_page.pageSize) or 0)

    targetRedisKey = targetRedisKey or "Zpau"
    local tp = redis.call("TYPE", targetRedisKey)
    if tp.ok == "set" then
        redis.call("ZUNIONSTORE", "T-searchPau", 1, targetRedisKey)
        targetRedisKey = "T-searchPlatform"
    end

    local total = redis.call("ZCARD", targetRedisKey)

 -- get all matched
    if 0 == pageNum*pageSize then
        pageNum = 1
        pageSize = total
    end


    --search cretira
    local c_name = t_cretiria.pauName
    local c_netAddress = t_cretiria.pauIP
    local c_OnlineStatus = tonumber(t_cretiria.onlineStatus)
    if c_OnlineStatus then
        c_OnlineStatus = tostring(c_OnlineStatus)
    end
    local c_version = t_cretiria.pauVersion
    local c_cap = t_cretiria.pauCap


    local resultIDs = {}

    local q_fields = {}

    local flag_name = 0
    if (c_name and string.len(c_name) > 0) then
      flag_name = 1
      c_name = string.lower(c_name)
      q_fields.Name = #q_fields+1
      q_fields[#q_fields+1] = "pauName"
    end

    local flag_netAddress = 0
    if (c_netAddress and string.len(c_netAddress) > 0) then
      flag_netAddress = 1
      q_fields.NetAddress = #q_fields+1
      q_fields[#q_fields+1] = "pauIP"
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
      q_fields[#q_fields+1] = "pauVersion"
    end

    local flag_cap = 0
    if (c_cap and string.len(c_cap) > 0) then
      flag_cap = 1
      c_cap = string.lower(c_cap)
      q_fields.Capability = #q_fields+1
      q_fields[#q_fields+1] = "pauCap"
    end

    local flag_condtion_total = flag_name  + flag_netAddress  + flag_OnlineStatus  + flag_version + flag_cap

    local zrangeScent = "ZRANGE"

    -- orderBy if not pauName then use "Zpau-orderBy"

    if (orderScend and "DESC" == string.upper(orderScend)) then
        zrangeScent = "ZREVRANGE"
    end

    if flag_condtion_total > 0 then -- 需要过滤
        local IDs = redis.call(zrangeScent, targetRedisKey, 0 , -1)

        total = 0

        local flag_math = 0

        for i,v  in pairs(IDs) do

            local m_dev = redis.call("HMGET","pau:" .. v, unpack(q_fields))

            flag_math = 0

            local sf =  string.find

            if flag_name > 0 and m_dev[q_fields.Name] and sf(string.lower(m_dev[q_fields.Name]), c_name,1,true) then
            flag_math = flag_math + 1
            end

            if flag_netAddress > 0 and m_dev[q_fields.NetAddress] and sf(m_dev[q_fields.NetAddress], c_netAddress,1,true) then
            flag_math = flag_math + 1
            end

            if flag_OnlineStatus > 0 and (("1" == c_OnlineStatus and "1" == m_dev[q_fields.onlineStatus]) or ("0" == c_OnlineStatus and "1" ~= m_dev[q_fields.onlineStatus])) then
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
        resultIDs = redis.call(zrangeScent, targetRedisKey, (pageNum-1)*pageSize , pageNum*pageSize -1 )
    end

    local result = {}

    for i,id in pairs(resultIDs) do
        local obj = redis.call("HGETALL","pau:" .. id)
        obj = convertToTable(obj, NumbericalMark_All)
        local platCount = redis.call("SCARD", "pau-platform:" .. id)
        obj.platCount = tonumber(platCount)
        result[#result+1] = obj
    end


    local rsp = {
        total = total,
        pageNum = pageNum,
        pageSize = pageSize,
        netSize = #result,
        orderBy = orderBy,
        orderScend = string.upper(orderScend),
        rows = result,
        pauName = c_name,
    }

    return  {cjson.encode(rsp)}

end



local function pauLogin(heartbeat, regTime, regTimeStr, pauStatbleRange, pauJson)
    local pauObj = cjson.decode(pauJson)
    local pauID = pauObj.pauID
    local pauIP = pauObj.pauIP
    local pauVersion =  tostring(pauObj.pauVersion)

    pauVersion = string.match(pauVersion,"(.*)@")

    pauStatbleRange = pauStatbleRange or 3600*2

    local pauKey = "pau:" .. pauID
    local obj = redis.call("HGETALL", pauKey)

    if next(obj) ~= nil then
        obj = convertToTable(obj, NumbericalMark_All)
        local stopPauLogging = tostring(redis.call("HGET", "license", "stopPauLogging"))
        if "1" == stopPauLogging then
            return {false,"StopLoggingByLic"}
        elseif redis.call("HEXISTS", "system", "vasMode-slave") > 0 then
            return {false,"vasModeSlave"}
        elseif obj.pauIP ~= pauIP then
            return {false,"IPNotMatch"}
        elseif 1 == obj.onlineStatus then
            return {false,"AlreadyOnline"}
        else
            local oldPlat = (redis.call("HMGET", pauKey, "onlineStatus"))
            local oldStatus = tonumber(oldPlat[1]) or 0
            -- pau 在线，状态描述默认就是 进入服务态
            redis.call("HMSET", pauKey, "heartbeat", heartbeat, "onlineStatus", 1, "statusDesc", "pau.onService", "pauRegTime", regTime, "pauRegTimeStr", regTimeStr , "pauVersion", pauVersion )
            -- 记录登录时间，做稳定性校验
            local regHistoryKey = "pauRegHistory:" .. pauID
            redis.call("ZADD", regHistoryKey, regTime, regTime)
            redis.call("EXPIRE",regHistoryKey , pauStatbleRange)

            local newPlat = (redis.call("HMGET", pauKey, "onlineStatus"))
            local newStatus = tonumber(newPlat[1]) or 0

            if(oldStatus ~= newStatus) then
                obj.statusChanged = true
            end

            return {true,cjson.encode(obj)}

        end
    else
        return {false,"NotExists"}
    end

end



local function pauLogout(pauID, pauIP)
    local pauKey = "pau:" .. pauID
    local obj = redis.call("HGETALL", pauKey)

    if next(obj) ~= nil then
        obj = convertToTable(obj, NumbericalMark_All)

        if obj.pauIP ~= pauIP then
            return {false,"pau.logout.IPNotMatch"}
        elseif 1 ~= obj.onlineStatus then
            return {true,"pau.logout.NotOnline"}
        else
            redis.call("HDEL", pauKey, "onlineStatus", "heartbeat", "statusDesc" )

            -- 删除平台中的pauID
            local platIDs = redis.call("SMEMBERS", "pau-platform:" .. pauID)
            for _,_id in pairs(platIDs) do
                redis.call("HDEL", "platform:" .. _id, "pauID", "onlineStatus@" .. pauID, "platRegTimeStr@" .. pauID, "registerErrorCode@" .. pauID )
            end
            redis.call("UNLINK", "pau-platform:" .. pauID)

            return {true,cjson.encode(obj)}
        end
    else
        return {false,"pau.logout.NotExists"}
    end

end

local function pauHeartBeat(heartbeat, pauID, pauIP)
    local pauKey = "pau:" .. pauID
    local obj = redis.call("HGETALL", pauKey)

    if next(obj) ~= nil then
        obj = convertToTable(obj, NumbericalMark_All)

        if obj.pauIP ~= pauIP then
            return {false,"IPNotMatch"}
        elseif 1 ~= obj.onlineStatus then
            return {false,"NotOnline"}
        else
            redis.call("HSET", pauKey, "heartbeat", heartbeat )
            return {true,cjson.encode(obj)}
        end
    else
        return {false,"NotExists"}
    end

end





local function checkPauHeartbeat(currUptime, maxPauPluseGapSecond, p_start, p_end)
    p_start = tonumber(p_start) or 0
    p_end = tonumber(p_end) or -1
    maxPauPluseGapSecond = tonumber(maxPauPluseGapSecond) or 60
    maxPauPluseGapSecond = maxPauPluseGapSecond*1000
    currUptime = tonumber(currUptime)

    local total = redis.call("ZCARD","Zpau")

    local IDs = redis.call("ZRANGE","Zpau", p_start , p_end)

    local expArr = {}
    for _, _id in pairs(IDs) do

       local obj = redis.call("HGETALL","pau:" .. _id)
       if next(obj) ~= nil then
           obj = convertToTable(obj, NumbericalMark_All)

           if obj.heartbeat and math.abs(currUptime - obj.heartbeat) >= maxPauPluseGapSecond then
               pauLogout(obj.pauID, obj.pauIP)
               expArr[#expArr+1] = obj
           end
       end

    end

    return {total, (#expArr > 0 and {cjson.encode(expArr)} or {"[]"})[1]}

end



-- pau在线
local function getIdlestPau(currTime, pauStatbleRange, pauStatbleCount) -- currTime missec  | pauStatbleRange sec
    local paulist = redis.call("ZRANGE", "Zpau", 0 ,-1)
    local n = nil
    local r = nil


    for _,_id in pairs(paulist) do
        local isOnline = "1" == redis.call("HGET","pau:".._id,"onlineStatus")

        if isOnline then
            local banFlag = false
            if currTime and pauStatbleRange and pauStatbleCount then
                local regHistoryKey = "pauRegHistory:" .. _id
                local c = redis.call("ZCOUNT", regHistoryKey, tonumber(currTime) - tonumber(pauStatbleRange*1000), tonumber(currTime) )
                if tonumber(c) > tonumber(pauStatbleCount) then
                    banFlag = true
                end
            end

            if not banFlag then
                local card = redis.call("SCARD", "pau-platform:" .. _id)
                n = n or card
                r = r or _id

                if card < n then
                    n = card
                    r = _id
                end

            end
        end

    end

    return r,n

end

-- pau在线
local function getBusiestPau()
    local paulist = redis.call("ZRANGE", "Zpau", 0 ,-1)
    local n = nil
    local r = nil


    for _,_id in pairs(paulist) do
        local isOnline = "1" == redis.call("HGET","pau:".._id,"onlineStatus")

        if isOnline then

            local card = redis.call("SCARD", "pau-platform:" .. _id)
            n = n or card
            r = r or _id

            if card > n then
                n = card
                r = _id
            end
        end

    end

    return r,n

end

local function getPlatGroupByIDArray(treeID, ...)

    local pgkp  = getPlatSrcKeyPrefix()
    if not pgkp then
        return  {"[]"}
    end

    local groupTreeName = redis.call("HGET", pgkp .. ":grouptree:" .. treeID, "groupTreeName")
    if not groupTreeName then
        groupTreeName = ""
    end

    pgkp = pgkp .. ":" .. treeID .. ":"



    local IDs = {}
    for i = 1,arg.n do
       IDs[#IDs+1] = arg[i]
    end

    local result = {}

    local cnt = 0
    for i,id  in pairs(IDs) do
        local obj = redis.call("HGETALL",pgkp .. "group:" .. id)
        if next(obj) ~= nil then
            obj = convertToTable(obj, NumbericalMark_All)
            obj.groupTreeName = groupTreeName
            result[#result+1] = obj
            cnt = cnt + 1
        else
            result[#result+1] = {}
        end
    end

    return  {cnt == #IDs, cjson.encode(result)}
end


local function getTreeRootGroup(treeID)

    local prefix = getPlatSrcKeyPrefix()

    local treeKey = prefix .. ":grouptree:" .. treeID

    local missingFlag = ( 0 == redis.call("EXISTS", treeKey) )

    local groupNum = redis.call("ZCARD", prefix .. ":" .. treeID .. ":ZgroupRight" )

    local rootGroup = nil
    local fingerprint = nil
    if not missingFlag and groupNum > 0 then
        local treeInfo = redis.call("HMGET", treeKey, "fingerprint", "rootGroupID")

        fingerprint = treeInfo[1]

        local rootGroupID = treeInfo[2]
        local ret =  getPlatGroupByIDArray(treeID, rootGroupID)
        if ret[1] then
            rootGroup = cjson.decode(ret[2])[1]
        end
    end

    local rsp = {
        treeID = treeID,
        missing = missingFlag,
        groupNum = groupNum,
        root = rootGroup,
        fingerprint = fingerprint,
    }

    return  {cjson.encode(rsp)}


end

local function getPlat2PauInfo()
    -- 获取pau和platform对应信息
    local plat2pau = {}

    local paulist = redis.call("ZRANGE", "Zpau", 0 ,-1)

    for _,_id in pairs(paulist) do

        local mdata = redis.call("HMGET", "pau:" .. _id, "onlineStatus", "pauIP", "pauName", "pauPort")
        local isOnline = tonumber(("1" == mdata[1] and {"1"} or {"0"})[1])


        local plats = redis.call("SMEMBERS", "pau-platform:" .. _id)
        for _p,_pid in pairs(plats) do
            plat2pau[_pid ] = _id
        end
    end

    return {cjson.encode(plat2pau)},plat2pau
end


local function getPlatDetail(resultIDs)
    local result = {}

    local cnt = 0
    for i,id  in pairs(resultIDs) do
        local obj = redis.call("HGETALL","platform:" .. id)
        if next(obj) ~= nil then
            obj = convertToTable(obj, NumbericalMark_All)

            if(obj.pauID) then
                local pauObj = redis.call("HGETALL", "pau:" .. obj.pauID)
                if next(pauObj) ~= nil then
                    pauObj = convertToTable(pauObj, NumbericalMark_All)
                    obj.pauID = pauObj.pauID
                    obj.pauIP = pauObj.pauIP
                    obj.pauPort = pauObj.pauPort
                    obj.pauName = pauObj.pauName
                    obj.pauOnlineStatus = tonumber(("1" == tostring(pauObj.onlineStatus) and {"1"} or {"0"})[1])
                    --从绑定的pau取在线状态
                    obj.onlineStatus = tonumber(obj["onlineStatus@" .. obj.pauID]) or 0
                    obj.platRegTimeStr = obj["platRegTimeStr@" .. obj.pauID] or ""
                    obj.registerErrorCode = obj["registerErrorCode@" .. obj.pauID] or ""
                end
            else
                obj.onlineStatus = 0
                obj.platRegTimeStr = ""
                obj.registerErrorCode = ""
            end

            cnt = cnt + 1
            result[#result+1] = obj
        else
            result[#result+1] = {}
        end
    end

    return cnt, result
end


local function getPlatformByIDArray(...)
    local IDs = {}
    for i = 1,arg.n do
       IDs[#IDs+1] = arg[i]
    end

    local cnt, result = getPlatDetail(IDs)




    return  {cnt == #IDs, cjson.encode(result)},result
end





local function searchPlatform(pageJson, cretiriaJson, targetRedisKey, includeIDs, excludeIDs)
    local t_page = cjson.decode(pageJson)
    local t_cretiria = cjson.decode(cretiriaJson)

    local orderBy = t_page.orderBy or "pauName"
    local orderScend = t_page.orderScend or "ASC"

    local pageNum = math.abs(tonumber(t_page.pageNum) or 0)
    local pageSize = math.abs(tonumber(t_page.pageSize) or 0)

    targetRedisKey = targetRedisKey or "Zplatform"
    local tp = redis.call("TYPE", targetRedisKey)
    if tp.ok == "set" then
        redis.call("ZUNIONSTORE", "T-searchPlatform", 1, targetRedisKey)
        targetRedisKey = "T-searchPlatform"
    end

    local total = redis.call("ZCARD", targetRedisKey)

 -- get all matched
    if 0 == pageNum*pageSize then
        pageNum = 1
        pageSize = total
    end


    --search cretira
    local c_name = t_cretiria.platName
    local c_netAddress = t_cretiria.platIP
    local c_OnlineStatus = tonumber(t_cretiria.onlineStatus)
    if c_OnlineStatus then
        c_OnlineStatus = tostring(c_OnlineStatus)
    end

    local c_version = t_cretiria.platVersion
    local c_cap = t_cretiria.platCap
    local c_IsTopStatus = tonumber(t_cretiria.isTopPlat)
    if c_IsTopStatus then
        c_IsTopStatus = tostring(c_IsTopStatus)
    end


    local resultIDs = {}

    local q_fields = {}

    local flag_name = 0
    if (c_name and string.len(c_name) > 0) then
      flag_name = 1
      c_name = string.lower(c_name)
      q_fields.Name = #q_fields+1
      q_fields[#q_fields+1] = "platName"
    end

    local flag_netAddress = 0
    if (c_netAddress and string.len(c_netAddress) > 0) then
      flag_netAddress = 1
      q_fields.NetAddress = #q_fields+1
      q_fields[#q_fields+1] = "platIP"
    end

    local flag_OnlineStatus = 0
    if (c_OnlineStatus and string.len(c_OnlineStatus) > 0) then
      flag_OnlineStatus = 1
      q_fields.onlineStatus = #q_fields+1
      q_fields[#q_fields+1] = "onlineStatus"
    end

    local flag_IsTopStatus = 0
    if (c_IsTopStatus and string.len(c_IsTopStatus) > 0) then
      flag_IsTopStatus = 1
      q_fields.isTopPlat = #q_fields+1
      q_fields[#q_fields+1] = "isTopPlat"
    end


    local flag_version = 0
    if (c_version and string.len(c_version) > 0) then
      flag_version = 1
      c_version = string.lower(c_version)
      q_fields.Version = #q_fields+1
      q_fields[#q_fields+1] = "platVersion"
    end

    local flag_cap = 0
    if (c_cap and string.len(c_cap) > 0) then
      flag_cap = 1
      c_cap = string.lower(c_cap)
      q_fields.Capability = #q_fields+1
      q_fields[#q_fields+1] = "platCap"
    end

    local flag_condtion_total = flag_name  + flag_netAddress  + flag_OnlineStatus  + flag_version + flag_cap + flag_IsTopStatus

    local zrangeScent = "ZRANGE"

    -- orderBy if not platName then use "Zplatform-orderBy"

    if (orderScend and "DESC" == string.upper(orderScend)) then
        zrangeScent = "ZREVRANGE"
    end

    if flag_condtion_total > 0 then -- 需要过滤
        local IDs = redis.call(zrangeScent, targetRedisKey, 0 , -1)

        total = 0

        local flag_math = 0

        for i,v  in pairs(IDs) do

            local m_dev = redis.call("HMGET","platform:" .. v, unpack(q_fields))

            flag_math = 0

            local sf =  string.find

            if flag_name > 0 and sf(string.lower(m_dev[q_fields.Name]), c_name,1,true) then
            flag_math = flag_math + 1
            end

            if flag_netAddress > 0 and m_dev[q_fields.NetAddress] and sf(m_dev[q_fields.NetAddress], c_netAddress,1,true) then
            flag_math = flag_math + 1
            end

            if flag_OnlineStatus > 0 and (("1" == c_OnlineStatus and "1" == m_dev[q_fields.onlineStatus]) or ("0" == c_OnlineStatus and "1" ~= m_dev[q_fields.onlineStatus])) then
            flag_math = flag_math + 1
            end

            if flag_IsTopStatus > 0 and (("1" == c_IsTopStatus and "1" == m_dev[q_fields.isTopPlat]) or ("0" == c_IsTopStatus and "1" ~= m_dev[q_fields.isTopPlat])) then
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
        resultIDs = redis.call(zrangeScent, targetRedisKey, (pageNum-1)*pageSize , pageNum*pageSize-1)
    end

    if includeIDs then
        if type(includeIDs) == "string" then
            includeIDs = {includeIDs}
        end
        local sp_t1 = {}
        for i,v in pairs(resultIDs) do
            sp_t1[v] = true
        end

        for i,v in pairs(includeIDs) do
            if not sp_t1[v] then
                resultIDs[#resultIDs+1] = v
            end
        end


    end

    local cnt, result = getPlatDetail(resultIDs)

    local rsp = {
        total = total,
        pageNum = pageNum,
        pageSize = pageSize,
        netSize = #result,
        orderBy = orderBy,
        orderScend = string.upper(orderScend),
        rows = result,
        platName = c_name,
    }


    return  {cjson.encode(rsp)}, rsp
end

local getTopPlatID = function()

    local IDs = redis.call("ZRANGE", "Zplatform", 0 , -1)

    for i,v  in pairs(IDs) do
        if 1 == tonumber(redis.call("HGET", "platform:" .. v, "isTopPlat")) then
            return v
        end
    end
    return nil
end

local function pauGetPlatforms(pageJson, cretiriaJson)
    local t_cretiria = cjson.decode(cretiriaJson)
    local pauID = t_cretiria.pauID
    local pauIP = t_cretiria.pauIP

    local pauKey = "pau:" .. pauID
    if redis.call("EXISTS", pauKey) > 0 then
        local mdata = redis.call("HMGET", pauKey, "pauIP", "onlineStatus" )
        if not (mdata[1] and pauIP == mdata[1] ) then
            return {false,"vmu.pau.getPlat.IPNotMatch"}
        elseif not (mdata[2] and "1" == mdata[2] ) then
            return {false,"vmu.pau.getPlat.NotOnline"}
        else
            local topID = getTopPlatID()

            local _, r = searchPlatform(pageJson, "{}",  "pau-platform:" .. pauID ,topID)

            r.plats = r.rows
            r.rows = nil

           return {true, cjson.encode(r)}
        end
    else
        return {false,"vmu.pau.getPlat.NotExists"}
    end

end

local function updatePlatformStatus(pauJson, platsJson)
    local t_pau = cjson.decode(pauJson)
    local pauID = t_pau.pauID
    local pauIP = t_pau.pauIP

    local pauKey = "pau:" .. pauID
    if redis.call("EXISTS", pauKey) > 0 then
        local mdata = redis.call("HMGET", pauKey, "pauIP", "onlineStatus" )
        if not (mdata[1] and pauIP == mdata[1] ) then
            return {false,"vmu.pau.updatePlat.IPNotMatch"}
        elseif not (mdata[2] and "1" == mdata[2] ) then
            return {false,"vmu.pau.updatePlat.NotOnline"}
        else
            local event = false
         --   local curr_plats = redis.call("SMEMBERS", "pau-platform:" .. pauID)
        --    for _p,_pid in pairs(curr_plats) do
        --        _temp[#_temp+1] = _id
        --    end


            local result = {}
            local t_plats = cjson.decode(platsJson)

            for i,v in pairs(t_plats) do
                local platID = tostring(v.platID)
				local platName = tostring(v.platName)
                local key = "platform:" .. platID
                if (redis.call("EXISTS", key ) > 0)  then -- 这里要放开任意pau对顶级平台的上报 , 不做校验 redis.call("SISMEMBER", "pau-platform:" .. pauID, platID)
                    local oldPlat = (redis.call("HMGET", key, "onlineStatus@" .. pauID))
                    local oldStatus = tonumber(oldPlat[1]) or 0


                    -- 删除pau时要删除下 @pauID 的 field
                    -- 涉及这些方法 getPlatformByIDArray  getPlatStatusByIDArray  searchPlatform  updatePlatformStatus
                    redis.call("HMSET" , key , "onlineStatus@" .. pauID, (v.onlineStatus or 0), "platRegTimeStr@" .. pauID, (v.platRegTimeStr or ""))

                    if v.registerErrorCode and string.len(v.registerErrorCode) > 0 then
                        redis.call("HSET" , key , "registerErrorCode@" .. pauID , v.registerErrorCode)
                    end


                    local newPlat = (redis.call("HMGET", key, "onlineStatus@" .. pauID))

                    local tp = {platID = platID, statusChanged = false, platName = platName}

                    if (redis.call("SISMEMBER", "pau-platform:" .. pauID, platID) > 0) then

                        if "1" == tostring(v.onlineStatus)  then
                            redis.call("HINCRBY", key, "onlineCount", 1)

                            --上次同步到信息
                            local platSyncResult = redis.call("HGET", "system", "platSyncResult" )
                            if platSyncResult then
                                platSyncResult = cjson.decode(platSyncResult)
                            end

                            -- 顶级第一次上上线
                            if(
                             "1" == tostring(redis.call("HGET", key, "isTopPlat"))
                            and "1" == tostring(redis.call("HGET", key, "onlineCount"))
                            and (not platSyncResult or not platSyncResult.plat or platID ~= platSyncResult.plat.platID)
                            ) then
                                event = "top1stOnline"
                            end

                        end



                        local newStatus = tonumber(newPlat[1]) or 0

                        if(oldStatus ~= newStatus) then
                            tp.statusChanged = true
                        end

                        tp.onlineStatus = newStatus
                    end

                    tp.onlineCount = tonumber(redis.call("HGET", key, "onlineCount")) or 0

                    result[#result+1] = tp





                end
            end

           return {true, event, cjson.encode(result), }
        end
    else
        return {false,"vmu.pau.updatePlat.NotExists"}
    end

end


local function reDispatch(platID, oldPauID, pauID)
            if oldPauID then
                redis.call("SREM", "pau-platform:" .. oldPauID, platID)
            end

            redis.call("SADD", "pau-platform:" .. pauID, platID)

            redis.call("HDEL", "platform:" .. platID, "onlineStatus")
            redis.call("HSET", "platform:" .. platID, "pauID", pauID )

end


local getPau2platInfo = function()
    local t = {}
    local allPauList = redis.call("ZRANGE", "Zpau", 0 ,-1)
        for i,_id in pairs(allPauList) do
        local pauInfo = redis.call("HMGET","pau:".._id,"pauName", "pauIP", "onlineStatus")
        t[#t+1] = {pauID = _id, pauName = pauInfo[1], pauIP = pauInfo[2], onlineStatus = (tonumber(pauInfo[3]) or 0), plats = redis.call("SMEMBERS", "pau-platform:" .. _id)}
    end
    return {cjson.encode(t)}, t
end

local function dispatchPlatform( threshold, currTime , pauStatbleRange, pauStatbleCount)  -- 后续增加绑定参数，被绑定了的平台不被均衡到其它pau上
    redis.replicate_commands()
    redis.call("UNLINK", "CALL-START-dispatchPlatform")

    threshold = tonumber(threshold)
    local allPauList = redis.call("ZRANGE", "Zpau", 0 ,-1)

    local pauList_online = {}
    local pauList_OFFLINE = {}


    local pauPlatformKey_online = {}

    -- 均衡前
    local _k1, debug_before_dispath = getPau2platInfo()



    redis.call("UNLINK", "T-Splatform")
    zset2set("Zplatform", "T-Splatform")



    for i,_id in pairs(allPauList) do
        local pauInfo = redis.call("HMGET","pau:".._id,"pauName", "pauIP")

        local isOnline = "1" == redis.call("HGET","pau:".._id,"onlineStatus")
        if isOnline then
            pauList_online[#pauList_online+1] = _id

            -- 将已经退网的平台ID清理一遍

            local pauPlatformKey = "pau-platform:" .. _id

            local goneIDs = redis.call("SDIFF", pauPlatformKey  ,"T-Splatform")
            if #goneIDs > 0 then
              deleteMegaFromSet(goneIDs, pauPlatformKey)
            end

             pauPlatformKey_online[#pauPlatformKey_online+1] = pauPlatformKey
        else
            pauList_OFFLINE[#pauList_OFFLINE+1] = _id
        end


    end

    -- 将下线pau-platform对应的旧key删除
    local OFF_lineKey = {}
    for i, _id in pairs(pauList_OFFLINE) do
        OFF_lineKey[#OFF_lineKey+1] = "pau-platform:" .. _id
    end
    redis.call("UNLINK", "make_sure_atleast_one_param_will_be_sended_to_del_command", unpack(OFF_lineKey))


    -- 从所有的设备中减去仍然在线的剩下的就是需要重新分配的，
    local unDevidedPlatformKey = "unDevidedPlatformKey"
    redis.call("SDIFFSTORE", unDevidedPlatformKey, "T-Splatform", unpack(pauPlatformKey_online))

    local unDevidedCount = redis.call("SCARD", "unDevidedPlatformKey")


    -- 先把要分配的平台里面原来pau的信息删除,在线状态也清除
    local all_unDevidedIDs = redis.call("SMEMBERS", unDevidedPlatformKey)
    for _,_id in pairs (all_unDevidedIDs) do
        redis.call("HDEL", "platform:".._id , "pauID", "onlineStatus")
    end

    if unDevidedCount > 0 and #pauList_online > 0 then
        -- set 2 zset for range
        redis.call("ZUNIONSTORE",unDevidedPlatformKey, 1 , unDevidedPlatformKey )
        local packSize = math.ceil(threshold/2)
        for i=0, unDevidedCount, packSize do
            local packIDs =  redis.call("ZRANGE", unDevidedPlatformKey, i, i + packSize - 1)
            if #packIDs > 0 then
                local lowestPauID =  getIdlestPau(currTime, pauStatbleRange, pauStatbleCount)
                if lowestPauID then
                    saddTable(packIDs, "pau-platform:" .. lowestPauID)
                    -- 在平台对象里面添加pau的id
                    for _,_id in pairs (packIDs) do
                        redis.call("HSET", "platform:".._id , "pauID", lowestPauID)
                    end

                end
            end
        end

    end


    -- 再处理一次调度

    local busiestID, b_cnt = getBusiestPau()

    local idlestID, i_cnt = getIdlestPau(currTime, pauStatbleRange, pauStatbleCount)


    if busiestID and idlestID and (busiestID ~= idlestID) and (b_cnt - i_cnt) > threshold then
        local busyKey = "pau-platform:" .. busiestID

        local shiftSize = math.ceil((b_cnt - i_cnt)/2) -- 每次均衡的个数,取c差值平均值

        local finalIDs = redis.call("SRANDMEMBER", busyKey, shiftSize)
        for _,fnID in pairs(finalIDs) do -- 逐个获取确保正确
            local oldPau =  redis.call("HMGET", "platform:" .. fnID, "pauID", "isTopPlat")
            if "1" ~= tostring(oldPau[2]) then  -- 非顶级平台才允许被均衡
                reDispatch(fnID, oldPau[1], idlestID)
            end
        end

    end

    local _k2, debug_after_dispath = getPau2platInfo()
    local debugLog = {pauDispatch = {before = debug_before_dispath, after = debug_after_dispath}}

    return {cjson.encode(debugLog)}

end







local getTopPlatInfo = function() --

    local ID = getTopPlatID()

    if ID then
        local rsp,arr = getPlatformByIDArray(ID)
        if rsp[1] then
            local plat = arr[1]
            local onPauList = {}

            for k, v in pairs(plat) do
                local pauID = string.match(tostring(k), "onlineStatus@(.*)")
                if pauID and (1 == redis.call("EXISTS", "pau:" .. pauID)) then
                    local obj = redis.call("HMGET", "pau:" .. pauID, "onlineStatus", "pauIP",  "pauPort" , "pauName")

                    onPauList[#onPauList + 1] = {pauID = pauID , onlineStatus = (tonumber(obj[1]) or 0), pauIP = obj[2], pauPort = tonumber(obj[3]), pauName= obj[4]}
                end
            end

            plat.onPauList = onPauList

            return {true, cjson.encode(plat)}
        else
            return {false, "NotFound"}
        end
    else
        return {false, "NotFoundTopID"}
    end

end



local getChannelByIDArray = function(syncID, treeID, ...)
    local desingtedSyncID = tonumber(syncID)

    if not desingtedSyncID or 0 == desingtedSyncID then
        desingtedSyncID  = getPlatSrcKeyPrefix()
        if not desingtedSyncID then
            return {false,{}}
        end
    end

    local IDs = {}
    for i = 1,arg.n do
       IDs[#IDs+1] = arg[i]
    end

    local result = {}
    local cnt = 0
    for i,id  in pairs(IDs) do
        local obj = redis.call("HGETALL",tostring(desingtedSyncID) .. ":channel:" .. id)
        if next(obj) ~= nil then
            obj = convertToTable(obj, NumbericalMark_All)
            obj.groupID = obj["groupID@" .. treeID]

            if redis.call("ZSCORE", tostring(desingtedSyncID) .. ":blackList", tostring(obj.channelID)) then
                obj.vasUseFlag = 0
            else
                obj.vasUseFlag = 1
            end

            result[#result+1] = obj
            cnt=cnt+1
        else
            result[#result+1] = {}
        end

    end

    return {cnt == #IDs, cjson.encode(result)}
end


local getChannelByID = function(syncID, treeID, id)
    local r  = getChannelByIDArray(syncID, treeID, id)

    if r[1] then
        return {true, cjson.encode(cjson.decode(r[2])[1])}
    else
        return {false, "{}"}
    end
end

local wipeOldSrc = function(prefix, stepLimit, totalLimit)
    redis.replicate_commands()
    stepLimit = tonumber(stepLimit) or 1000
    totalLimit = tonumber(totalLimit) or -1

  local all_keys = {};

  local cursor = "0"
  repeat
      local result = redis.call("SCAN", cursor, "match", tostring(prefix) .. "*", "count", stepLimit)
      cursor = result[1];
      for i, key in ipairs(result[2]) do
         all_keys[#all_keys+1] = key;
      end
  until "0" == cursor or (totalLimit > 0 and #all_keys >= totalLimit)

--  for i, key in ipairs(all_keys) do
--      if(totalLimit < 0 or i < totalLimit) then
--            redis.call("UNLINK")
--        elseif(totalLimit > 0 and i >= totalLimit) then
--            break
--        end
--  end

    deleteMegaKeys(all_keys)

    return {true}
end



local updatePlatSyncRound = function(n, platSyncResult)

    redis.replicate_commands() -- wipeOldSrc 需要

    redis.call("LPUSH", "LPlatSrcKeyPrefix", n )
    if platSyncResult and string.len(platSyncResult) > 0 then
        redis.call("HSET", "system", "platSyncResult", platSyncResult )
    else
        redis.call("HDEL", "system", "platSyncResult" )
    end
    -- 正式版本不在此处处理，使用单独脚本后台处理
    -- 这里取-2是因为要保留-1给iau掉task用，可能正在跑任务的时候，task和通道关系有变化
    wipeOldSrc(tonumber(n) -2)

    return {true}
end



local function getPlatSyncResult()
    --上次同步到信息
    local platSyncResultJson = redis.call("HGET", "system", "platSyncResult" )
    if platSyncResultJson then
        return {true, platSyncResultJson}
    else
        return {false, platSyncResultJson}
    end
end


-- tsu start

local covertQualityIndex = function(qiStr)
    qiStr = qiStr or ""

    local t = {}

    for i = 1, string.len(qiStr) do
      local item =  string.sub(qiStr, i, i)
      if 1 == tonumber(item) then
        local p = {}
        local k = i - 1

        local qiObj = cjson.decode(redis.call("LINDEX","qualityIndex", k))
        p.qualityIndexID = qiObj.qualityIndexID
        p.qualityIndexName = qiObj.qualityIndexName
        p.qualityIndexBaseType = qiObj.qualityIndexBaseType
        t[#t+1] = p
      end
    end
    return t
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
      obj = convertToTable(obj, NumbericalMark_All)

      obj.status = tonumber(("1" == tostring(obj.onlineStatus) and {"1"} or {"0"})[1])

      result[#result+1] = obj
    else
      result[#result+1] = false
    end
  end

  return  {cjson.encode(result)}
end


local function iauLogin(timelimit, heartbeat,iauJson)

  local iauObj = cjson.decode(iauJson)
  local iauID = iauObj.iauID
  local iauIP = iauObj.iauIP
  local iauRegTime = iauObj.iauRegTime
  local iauRegTimeStr = iauObj.iauRegTimeStr
  local iauVersion =  tostring(iauObj.iauVersion)
  iauVersion = string.match(iauVersion,"(.*)@")
  --默认key存活60s
  timelimit = tonumber(timelimit)

  local iauKey = "iau:" .. iauID
  if redis.call("EXISTS", iauKey) > 0 then
    local mdata = redis.call("HMGET", iauKey, "iauIP", "onlineStatus" )

    local stopIauLogging = tostring(redis.call("HGET", "license", "stopIauLogging"))
    if "1" == stopIauLogging then
        return {false,"StopLoggingByLic"}
    elseif redis.call("HEXISTS", "system", "vasMode-slave") > 0 then
            return {false,"vasModeSlave"}
    elseif not (mdata[1] and iauIP == mdata[1] ) then
      return {false,"IPNotMatch"}
    elseif mdata[2] and "1" == mdata[2] then
      --记录注册时间 设置生命周期 timelimit
      redis.call("ZADD","logintime:" ..iauID,"1",iauRegTime)
      redis.call("expire","logintime:" ..iauID,timelimit)
      return {false,"AlreadyOnline"}
    else
      local oldPlat = (redis.call("HMGET", iauKey, "onlineStatus"))
      local oldStatus = tonumber(oldPlat[1]) or 0

      redis.call("HMSET", iauKey, "heartbeat", heartbeat,"onlineStatus", 1 ,"iauRegTime", iauRegTime, "iauRegTimeStr", iauRegTimeStr,"iauVersion", iauVersion)
      --记录注册时间 设置生命周期 timelimit
      redis.call("ZADD","logintime:" ..iauID,"1",iauRegTime)
      redis.call("expire","logintime:" ..iauID,timelimit)

      local obj = redis.call("HGETALL", iauKey)

      if next(obj) ~= nil then
        obj = convertToTable(obj, NumbericalMark_All)
        obj.status = tonumber(("1" == tostring(obj.onlineStatus) and {"1"} or {"0"})[1])

        local newPlat = (redis.call("HMGET", iauKey, "onlineStatus"))
        local newStatus = tonumber(newPlat[1]) or 0

        if(oldStatus ~= newStatus) then
            obj.statusChanged = true
        end

        return {true,cjson.encode(obj)}
      else
        return {false, "Unknown"}
      end
    end
  else
    return {false,"IauNotExists"}
  end

end

-- 任务状态处理
local function TaskStatusJudge(taskID)
  --状态切换 Iau上的任务 执行中都改为 等待中  或 完成   其他状态不变
    local taskinfo = redis.call("HMGET","task:" .. taskID, "taskStatus","taskTypeID","finishedCount","exeCount","instantTotalCount")
    --执行中
    if(taskinfo[1] == "2") then
      --切为等待中
      redis.call("HMSET","task:" .. taskID,"taskStatus","1")
      --如果是一次任务和即时任务 判断是否完成
      if(taskinfo[2] == "2") then
          if(taskinfo[3] == taskinfo[5]) then
            redis.call("HMSET","task:" .. taskID,"taskStatus","4")
          end
      end
      if(taskinfo[2] == "3") then
          if(taskinfo[3] == taskinfo[4]) then
            redis.call("HMSET","task:" .. taskID,"taskStatus","4")
          end
      end
    end
end

local function iauLogout(iauID, iauIP)
  local iauKey = "iau:" .. iauID
  redis.call("HDEL", iauKey, "onlineStatus", "heartbeat","statusDesc")
  local iauIP = redis.call("HMGET",iauKey, "iauIP")
  local ZiautaskKey = "Ziautask:" .. iauID .."&" ..iauIP[1]
  --按照 Ziautask 置 Task的iauID = “”   lua iauLogout
  local taskID = redis.call("Zrange", ZiautaskKey, 0,-1)
  for i,v  in pairs(taskID) do
    redis.call("HDEL", "task:" .. v, "iauID")
	--状态切换
	TaskStatusJudge(v)
  end
  --删除Ziautask
  redis.call("ZREMRANGEBYRANK", ZiautaskKey, 0,-1)
  --删除Zbaniau
  redis.call("ZREM", "Zbaniau", iauID)

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
      return {true,"IauHeartBeatOK"}
    end
  else
    return {false,"IauNotExists"}
  end

end

-- 函数负责 根据IauID设置状态描述
local function setIauStatus(IauID,StatusDesc)

  local iauKey = "iau:" .. IauID
  if redis.call("EXISTS", iauKey) > 0 then
      redis.call("HSET", iauKey, "statusDesc", StatusDesc )
      return{true,"success"}
  else
    return{false,"IauNotExists"}
  end
end

local function checkIauStatusByIDArray(...)
    local IDs = {}
    for i = 1,arg.n do
       IDs[#IDs+1] = arg[i]
    end
    local rsp = {}
    rsp.hasTask = "No"
    local cnt = 0
    for i,id  in pairs(IDs) do
        --查看iau的任务关联
        local IauIP = redis.call("HMGET","iau:" ..id, "iauIP")
        local tasknumber = redis.call("ZCARD", "Ziautask:"..id .."&" ..IauIP[1])
        if tasknumber > 0 then
          rsp.hasTask = "Yes"
        end
    end
    return {cjson.encode(rsp)}
end

local function getIauStatusByIDArray(...)
    local IDs = {}
    for i = 1,arg.n do
       IDs[#IDs+1] = arg[i]
    end

    local result = {}

    local cnt = 0
    for i,id  in pairs(IDs) do
        local missingFlag = (0 == redis.call("EXISTS", "iau:" .. id))
        local obj = redis.call("HMGET","iau:" .. id, "onlineStatus", "iauIP", "iauVersion", "iauRegTimeStr","statusDesc")
        result[#result+1] = {iauID = id , onlineStatus = (tonumber(obj[1]) or 0), missing = missingFlag, iauIP = obj[2], iauVersion = obj[3], iauRegTimeStr= obj[4],statusDesc=obj[5]}
        cnt = cnt + 1
    end

    return  {cnt == #IDs, cjson.encode(result)}
end

local function test()
    return {false,"iauHeartBeatOK"}
    --return {true,"HeartBeatOK"}
end

-- 检查IAU 注册异常
local function checkIauLoginexception(times,frequency,timelimit)
  frequency = tonumber(frequency)
  timelimit = tonumber(timelimit)

  local IDs = redis.call("Zrange", "Ziau", 0 , -1)

  local Result = {}
  local allIauIDsList = {}
  local HasLoginTimes = {}
  local banIauIDsList = {}
  Result.error = "no"
  for i,v  in pairs(IDs) do
  --zcout
    local logintimes = redis.call("Zrange", "logintime:" ..v, 0 , -1)
    allIauIDsList[#allIauIDsList+1] = v
    local temp = redis.call("Zcount", "logintime:" ..v, times-timelimit, times+timelimit)
    HasLoginTimes[#HasLoginTimes+1] = temp
    if(temp >= frequency) then
      --当前时间 相差 timelimit60内 有frequency3个或以上 则为不稳定 加入不稳定列表
      redis.call("ZADD", "Zbaniau", 1 ,v)
      Result.error = "yes"
      banIauIDsList[#banIauIDsList+1] = v
    else
      --否则删除Zbaniau
      redis.call("ZREM", "Zbaniau", v)
    end
  end
  Result.allIauIDsList = allIauIDsList
  Result.HasLoginTimes = HasLoginTimes
  Result.banIauIDsList = banIauIDsList
  return {cjson.encode(Result)}
end

-- 检查Iau 心跳异常
local function checkIauHeartBeat(times,Hearbeattimelimit)

  --判断 每个IAU的心跳时间 如果与当前时间相差60s 则为异常
  local IDs = redis.call("Zrange", "Ziau", 0 , -1)
  local Result = {}
  local iauheartBeatErrorList = {}
  local iauhearrBeatTimeList={}
  local timeDifferenceList={}
  local allIauIdList={}
  local removeTaskList = {}
  local iauNameAndIP = {}
  Result.error = "no"
  Result.taskerror = "no"
  Result.CurrentTime = tonumber(times)
  for i,v  in pairs(IDs) do

    local m_dev = redis.call("HMGET","iau:" .. v, "heartbeat")
	local m_iauName = redis.call("HMGET","iau:" .. v, "iauName")
	local m_iauIP = redis.call("HMGET","iau:" .. v, "iauIP")
    allIauIdList[#allIauIdList+1] = v
    if (not not m_dev[1])  then
      iauhearrBeatTimeList[#iauhearrBeatTimeList+1] = tonumber(m_dev[1])
      timeDifferenceList[#timeDifferenceList+1] = tonumber(times) - tonumber(m_dev[1])
    else
      iauhearrBeatTimeList[#iauhearrBeatTimeList+1] = 0
      timeDifferenceList[#timeDifferenceList+1] = 0
    end
    --超过  Hearbeattimelimit 90s 则为心跳异常
    if (not not m_dev[1]) and ( (tonumber(times) - tonumber(m_dev[1])) >= tonumber(Hearbeattimelimit)) then
        Result.error = "yes"
		iauNameAndIP[#iauNameAndIP+1]=m_iauName[1]
		iauNameAndIP[#iauNameAndIP+1]=m_iauIP[1]
        iauheartBeatErrorList[#iauheartBeatErrorList+1] = v
        -- 将在线和 心跳改为空
        redis.call("HDEL", "iau:" .. v, "onlineStatus", "heartbeat" ,"statusDesc")
        -- 删除iau已分配的任务
         local IauIP = redis.call("HMGET","iau:" ..v, "iauIP")
         local ZiautaskKey = "Ziautask:" .. v .."&" ..IauIP[1]
         local taskID = redis.call("Zrange", ZiautaskKey, 0,-1)
         for i,v  in pairs(taskID) do
              Result.taskerror = "yes"
              removeTaskList[#removeTaskList+1]=v
              redis.call("HDEL", "task:" .. v, "iauID")
			  --状态切换
              TaskStatusJudge(v)
         end
         redis.call("ZREMRANGEBYRANK", ZiautaskKey, 0,-1)
         redis.call("ZREM", "Zbaniau", v)

    end

  end
  Result.allIauIdList = allIauIdList
  Result.iauName=iauNameAndIP
  Result.iauhearrBeatTimeList = iauhearrBeatTimeList
  Result.timeDifferenceList = timeDifferenceList
  Result.iauheartBeatErrorList = iauheartBeatErrorList
  Result.removeTaskList = removeTaskList
  -- 通知到界面 进行异常处理
  return {cjson.encode(Result)}
end

local function searchIau(pageJson, cretiriaJson, targetRedisKey)

  local t_page = cjson.decode(pageJson)
  local t_cretiria = cjson.decode(cretiriaJson)

  local orderBy = t_page.orderBy or "pauName"
  local orderScend = t_page.orderScend or "ASC"

  local pageNum = math.abs(tonumber(t_page.pageNum) or 0)
  local pageSize = math.abs(tonumber(t_page.pageSize) or 0)

    targetRedisKey = targetRedisKey or "Ziau"
    local tp = redis.call("TYPE", targetRedisKey)
    if tp.ok == "set" then
        redis.call("ZUNIONSTORE", "T-searchIau", 1, targetRedisKey)
        targetRedisKey = "T-searchPlatform"
    end

  local total = redis.call("ZCARD", targetRedisKey)

  if 0 == pageNum*pageSize then
        pageNum = 1
        pageSize = total
  end


  --search cretira
    local c_name = t_cretiria.iauName
    local c_netAddress = t_cretiria.iauIP
    local c_OnlineStatus = tonumber(t_cretiria.onlineStatus)
    if c_OnlineStatus then
        c_OnlineStatus = tostring(c_OnlineStatus)
    end
    local c_version = t_cretiria.iauVersion
    local c_cap = t_cretiria.iauCap

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
    local IDs = redis.call(zrangeScent,targetRedisKey, 0 , -1)

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
    resultIDs = redis.call(zrangeScent, targetRedisKey, (pageNum-1)*pageSize , pageNum*pageSize -1 )
  end

  local result = {}

  for i,v in pairs(resultIDs) do
    local obj = redis.call("HGETALL","iau:" .. resultIDs[i])
    obj = convertToTable(obj, NumbericalMark_All)
    obj.status = tonumber(("1" == tostring(obj.onlineStatus) and {"1"} or {"0"})[1])
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

local function searchOnlinedIau()


  local orderBy = "iauName"
  local orderScend = "ASC"
  local pageNum = 1
  local pageSize = 1000

  local targetRedisKey = "Ziau"
  local total = redis.call("ZCARD", targetRedisKey)

  local resultIDs = {}

  local q_fields = {}
  q_fields.onlineStatus = #q_fields+1
  q_fields[#q_fields+1] = "onlineStatus"

  local flag_OnlineStatus = 1
  local flag_condtion_total = flag_OnlineStatus

  local zrangeScent = "ZRANGE"

  if flag_condtion_total > 0 then -- 需要过滤
    local IDs = redis.call(zrangeScent,targetRedisKey, 0 , -1)
    total = 0

    local flag_math = 0
    for i,v  in pairs(IDs) do

      local m_dev = redis.call("HMGET","iau:" .. v, unpack(q_fields))

      flag_math = 0

      if flag_OnlineStatus > 0 and (m_dev[q_fields.onlineStatus] == "1") then
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
    resultIDs = redis.call(zrangeScent, targetRedisKey, (pageNum-1)*pageSize , pageNum*pageSize -1 )
  end

  local result = {}

  for i,v in pairs(resultIDs) do
    local obj = redis.call("HGETALL","iau:" .. resultIDs[i])
    obj = convertToTable(obj, NumbericalMark_All)
    obj.status = tonumber(("1" == tostring(obj.onlineStatus) and {"1"} or {"0"})[1])
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



local function taskInit(taskID)
    redis.call("HMSET","task:" .. taskID,"taskStatus","1")
    redis.call("HMSET","task:" .. taskID,"nextExeTime","")
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
      obj = convertToTable(obj, NumbericalMark_All)
      obj.qualityIndexArr = covertQualityIndex(obj.qualityIndex)
      result[#result+1] = obj
    else
      result[#result+1] = false
    end
  end

  return  {cjson.encode(result)}
end


local function searchTask(pageJson, cretiriaJson)
  local t_page = cjson.decode(pageJson)
  local t_cretiria = cjson.decode(cretiriaJson)

  local orderBy = t_page.orderBy or "taskName"
  local orderScend = t_page.orderScend or "ASC"

  local pageNum = math.abs(tonumber(t_page.pageNum) or 0)
  local pageSize = math.abs(tonumber(t_page.pageSize) or 0)

  local total = redis.call("ZCARD", "Ztask")

  if 0 == pageNum*pageSize then
        pageNum = 1
        pageSize = total
  end
  --search cretira
  local c_taskName = t_cretiria.taskName
  local c_startTime = t_cretiria.startTime
  local c_endTime = t_cretiria.endTime
  local c_taskState = t_cretiria.taskState
  local c_taskTypeID = t_cretiria.taskTypeID
  local c_taskMainTypeID = t_cretiria.taskMainTypeID

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
  if (c_taskState and string.len(c_taskState) > 0 and c_taskState ~= "-1" ) then
    flag_taskState = 1
    q_fields.taskStatus = #q_fields+1
    q_fields[#q_fields+1] = "taskStatus"
  end

  local flag_taskTypeID = 0
  if (c_taskTypeID and string.len(c_taskTypeID) > 0 and c_taskTypeID ~= "-1") then
	flag_taskTypeID = 1
	q_fields.taskTypeID = #q_fields+1
	q_fields[#q_fields+1] = "taskTypeID"
  end

  local flag_taskMainTypeID = 0
  if (c_taskMainTypeID and string.len(c_taskMainTypeID) > 0 and c_taskMainTypeID ~= "-1") then
	flag_taskMainTypeID = 1
	q_fields.taskMainTypeID = #q_fields+1
	q_fields[#q_fields+1] = "taskMainTypeID"
  end

  local flag_condtion_total = flag_taskName + flag_startTime + flag_endTime + flag_taskState + flag_taskTypeID + flag_taskMainTypeID

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


	  if flag_taskTypeID > 0 and (m_dev[q_fields.taskMainTypeID] == c_taskTypeID) then
		flag_math = flag_math + 1
	  end


	  if flag_taskMainTypeID > 0 and (m_dev[q_fields.taskMainTypeID] == c_taskMainTypeID) then
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
    obj = convertToTable(obj, NumbericalMark_All)
    obj.qualityIndexArr = covertQualityIndex(obj.qualityIndex)
    obj.iauName=""
    if(obj.iauID) then
                local iauObj = redis.call("HGETALL", "iau:" .. obj.iauID)
                if next(iauObj) ~= nil then
                    iauObj = convertToTable(iauObj, NumbericalMark_All)
                    obj.iauID = iauObj.pauID
                    obj.iauIP = iauObj.pauIP
                    obj.iauName = iauObj.pauName
                    obj.iauOnlineStatus = tonumber(("1" == tostring(iauObj.onlineStatus) and {"1"} or {"0"})[1]  )
                end
        end
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




local function searchTaskByIau(pageNum, pageSize, orderBy, orderScend, c_iauID )
  local c_iauIP = redis.call("HMGET","iau:" .. c_iauID, "iauIP")
  local iautaskkey = "Ziautask:" .. c_iauID .."&" ..c_iauIP[1]
  local total = redis.call("ZCARD",iautaskkey)
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
  local zrangeScent = "ZRANGE"

  -- orderBy if not iauName then use "Ziau-orderBy"

  if (orderScend and "DESC" == string.upper(orderScend)) then
    zrangeScent = "ZREVRANGE"
  end

  resultIDs = redis.call(zrangeScent, iautaskkey, (pageNum-1)*pageSize , pageNum*pageSize -1 )

  local result = {}

  for i,v in pairs(resultIDs) do
    local obj = redis.call("HGETALL","task:" .. resultIDs[i])
    obj = convertToTable(obj, NumbericalMark_All)
    obj.qualityIndexArr = covertQualityIndex(obj.qualityIndex)
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
-- 状态为正常才能获取 statusDesc = iauStatus.4
local function getOnlineIauIDs()

  -- 从 Ziau 和 iau:iauID 中拿到在线的IAUIDs

  local onlineIauIDs = {}

  local q_fields = {}

  local flag_OnlineStatus = 1
  q_fields.onlineStatus = #q_fields+1
  q_fields[#q_fields+1] = "onlineStatus"

  local flag_Status4 = 1
  q_fields.statusDesc = #q_fields+1
  q_fields[#q_fields+1] = "statusDesc"

  local flag_condtion_total = flag_OnlineStatus + flag_Status4

  local zrangeScent = "ZRANGE"

  --过滤
  if flag_condtion_total > 0 then
    local IDs = redis.call(zrangeScent, "Ziau", 0 , -1)
    local flag_math = 0

    for i,v  in pairs(IDs) do

      local m_dev = redis.call("HMGET","iau:" .. v, unpack(q_fields))

      flag_math = 0

      local sf =  string.find

      if flag_OnlineStatus > 0 and (not not m_dev[q_fields.onlineStatus]) and (m_dev[q_fields.onlineStatus] == "1") then
        flag_math = flag_math + 1
      end

      if flag_Status4 > 0 and (not not m_dev[q_fields.statusDesc]) and (m_dev[q_fields.statusDesc] == "iauStatus.4") then
        flag_math = flag_math + 1
      end

      if flag_math == flag_condtion_total then
          onlineIauIDs[#onlineIauIDs+1] = v
      end
    end
  end

  return onlineIauIDs
end

-- 函数负责 拿到非冻结的Task ID list
local function getFrozenTaskIDs()
  local frozenTaskIDs = {}

  local q_fields = {}

  local flag_taskState = 1
  q_fields.taskStatus = #q_fields+1
  q_fields[#q_fields+1] = "taskStatus"

  local flag_condtion_total = flag_taskState

  local zrangeScent = "ZRANGE"

  --过滤
  if flag_condtion_total > 0 then
    local IDs = redis.call(zrangeScent, "Ztask", 0 , -1)

    local flag_math = 0

    for i,v  in pairs(IDs) do

      local m_dev = redis.call("HMGET","task:" .. v, unpack(q_fields))

      flag_math = 0

      local sf =  string.find

      if flag_taskState > 0 and ((not not m_dev[q_fields.taskStatus]) and (m_dev[q_fields.taskStatus] == "3")) then
        flag_math = flag_math + 1
      end

      if flag_math == flag_condtion_total then
          frozenTaskIDs[#frozenTaskIDs+1] = v
      end
    end
  end

  return frozenTaskIDs
end

-- 需要已完成 和冻结 的任务 ID
local function getFinishedandFrozenTaskIDs()

  local FinishedandFrozenTaskIDs = {}

  local q_fields = {}

  local flag_taskState = 1
  q_fields.taskStatus = #q_fields+1
  q_fields[#q_fields+1] = "taskStatus"

  local flag_condtion_total = flag_taskState

  local zrangeScent = "ZRANGE"

  --过滤
  if flag_condtion_total > 0 then
    local IDs = redis.call(zrangeScent, "Ztask", 0 , -1)

    local flag_math = 0

    for i,v  in pairs(IDs) do

      local m_dev = redis.call("HMGET","task:" .. v, unpack(q_fields))

      flag_math = 0

      local sf =  string.find

      if flag_taskState > 0 and ((not not m_dev[q_fields.taskStatus]) and (m_dev[q_fields.taskStatus] == "3" or m_dev[q_fields.taskStatus] == "4")) then
        flag_math = flag_math + 1
      end

      if flag_math == flag_condtion_total then
          FinishedandFrozenTaskIDs[#FinishedandFrozenTaskIDs+1] = v
      end
    end
  end

  return FinishedandFrozenTaskIDs
end

-- 函数负责 根据TaskID计算task的负载度
local function getTaskloadByTaskID(taskID)

    -- 获取任务的修改时间
  local modifyTime = redis.call("HMGET","task:" .. taskID, "modifyTime")
  local taskchannelPrefix = getPlatSrcKeyPrefix()
  local taskchannelKey = taskchannelPrefix .. ":Ztaskchannel-"
  --  任务通道表  Ztaskchannel-modifyTime:taskid
  local total = redis.call("ZCARD", taskchannelKey .. modifyTime[1] ..":" ..taskID)
  return tonumber(total)

end

-- 获取任务的小时数 ，用于分配使用
local function getTimeHours(time,type)

    if type == "1" then
        -- 视质 startTime/1000%86400/3600+8 1-24
        return getIntPart(((tonumber(time)/1000%86400/3600+8)%24)%5)
    elseif  type == "2" then
        -- 录像 doTime/3600 +1 1-24
        return getIntPart((tonumber(time)/3600 +1)%5)
    -- 考虑到循环任务周期分为 4 12 时间按 5段 分为5组 这样每组内不会出现循环的重叠（重叠1与5（4小时重叠）1与14（12小时重叠））
    -- 除5余数为1  1 6 11 16 21
    -- 除5余数为2  2 7 12 17 22
    -- 除5余数为3  3 8 13 18 23
    -- 除5余数为4  4 9 14 19 24
    -- 除5余数为0  5 10 15 20
    end
end

-- 函数负责 根据IauId 计算 Iau 下所有Task 复杂度
local function getIauloadByIauID(iauId,hours)

  -- taskID 去 taskDevice中获取复杂度
  local Taskload = 0
  local taskhour = 0
  local IauIP = redis.call("HMGET","iau:" .. iauId, "iauIP")
  local taskIDs = redis.call("ZRANGE", "Ziautask:" .. iauId .."&" ..IauIP[1], 0 , -1)
  for i,v  in pairs(taskIDs) do
    if hours then
        local taskinfo = redis.call("HMGET", "task:" .. v, "taskMainTypeID","startTime","doTime")
        if taskinfo[1] == "1" then
            taskhour = getTimeHours(taskinfo[2],"1")
        elseif taskinfo[1] == "2" then
            taskhour = getTimeHours(taskinfo[3],"2")
        end
        if (taskhour == tonumber(hours)) then
            Taskload = Taskload + getTaskloadByTaskID(v)
        end
    else
        Taskload = Taskload + getTaskloadByTaskID(v)
    end
  end

  return Taskload

end

local function getNotBanonlineIauIDs()

  local onlineIauIDs = {}
  onlineIauIDs = getOnlineIauIDs();

  -- 去掉不稳定的IauID
  local banIauIDs = redis.call("ZRANGE", "Zbaniau", 0 , -1)
    for i,v  in pairs(onlineIauIDs) do
      local IauIDtempi = i
      local IauIDtempv = v
      for i,v  in pairs(banIauIDs) do
        if(tostring(IauIDtempv) == tostring(v)) then
          table.remove(onlineIauIDs, IauIDtempi)
        end
        break
      end
   end

   return onlineIauIDs

end


-- 函数负责 得到负载度Min的IauID
local function getLoadMinIauID(hours)

  local onlineIauIDs = {}
  --去掉了不稳定的IAU
  onlineIauIDs = getNotBanonlineIauIDs();

  if(not not onlineIauIDs) then

      -- 在线IAU  > 1
      if(#onlineIauIDs > 1) then

          local iauload = {}
          for i,v  in pairs(onlineIauIDs) do
            if(hours) then
                iauload[v] = getIauloadByIauID(v,hours)
                iauload[#iauload+1] = v
            else
                iauload[v] = getIauloadByIauID(v)
                iauload[#iauload+1] = v
            end
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
local function getLoadMaxIauID(hours)

  local onlineIauIDs = {}
  onlineIauIDs = getOnlineIauIDs();

  if(not not onlineIauIDs) then
      -- 在线IAU  > 1
      if(#onlineIauIDs > 1) then

          local iauload = {}
          for i,v  in pairs(onlineIauIDs) do
            if(hours) then
                iauload[v] = getIauloadByIauID(v,hours)
                iauload[#iauload+1] = v
            else
                iauload[v] = getIauloadByIauID(v)
                iauload[#iauload+1] = v
            end
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

-- 函数负责 根据TaskIDs查找Task状态和IauID
local function getTaskStatusandIauIDByIDArray(...)
    local IDs = {}
      for i = 1,arg.n do
         IDs[#IDs+1] = arg[i]
      end

    local result = {}
    local cnt = 0

    for i,id  in pairs(IDs) do
        local missingFlag = (0 == redis.call("EXISTS", "task:" .. id))
        local obj = redis.call("HMGET", "task:" .. id, "taskStatus","iauID","progress","finishedCount","exeCount","instantTotalCount","taskTypeID","taskErrMsg","deviceTotalNum")
        obj = {taskID = id , taskStatus = (tonumber(obj[1]) or 0), iauID = obj[2], progress=(tonumber(obj[3]) or 0),finishedCount=(tonumber(obj[4]) or 0),exeCount=(tonumber(obj[5]) or 0),instantTotalCount=(tonumber(obj[6]) or 0),taskTypeID=(tonumber(obj[7]) or 0),taskErrMsg=((obj[8]) or 0),deviceTotalNum=((obj[9]) or 0), missing = missingFlag}
        if(obj.iauID) then
            local iauObj = redis.call("HGETALL", "iau:" .. obj.iauID)
            if next(iauObj) ~= nil then
                iauObj = convertToTable(iauObj, NumbericalMark_All)
                obj.iauID = iauObj.iauID
                obj.iauIP = iauObj.iauIP
                obj.iauName = iauObj.iauName
                obj.iauOnlineStatus = tonumber(("1" == tostring(iauObj.onlineStatus) and {"1"} or {"0"})[1]  )
            end
        end
        result[#result+1] = obj
        cnt = cnt + 1
    end

    return  {cnt == #IDs, cjson.encode(result)}
end

local function setTaskOPerateByID(taskID)
  local rsp = {}
  if redis.call("EXISTS", "task:" ..taskID) > 0 then
      redis.call("set","taskOPerate:" ..taskID,"1")
      redis.call("expire","taskOPerate:" ..taskID,5)
      rsp.result = "yes"
      rsp.message = "success"
  else
    rsp.result = "no"
    rsp.message = "TaskNotExists"
  end
  return {cjson.encode(rsp)}
end

-- 函数负责 根据TaskID查找Task状态和IauID
local function getTaskStatusandIauID(taskID)

  local taskKey = "task:" .. taskID
  local rsp = {}
  local task = {}
  if redis.call("EXISTS", taskKey) > 0 then
      rsp.result = "yes"
      task.taskStatus =   redis.call("HGET", taskKey, "taskStatus" )
      task.iauID = redis.call("HGET", taskKey, "iauID" )
      rsp.task = task
  else
     rsp.result = "no"
  end
  return {cjson.encode(rsp)}
end

-- 函数负责 根据TaskID设置Task状态
local function setTaskStatus(taskID,taskStatus)

  local taskKey = "task:" .. taskID
  local rsp = {}
  if redis.call("EXISTS", taskKey) > 0 then
      if  taskStatus == "reload" then
        --即时任务进来 将iau的关系取消掉
        -- 清除 task iauID 删除iaulist
        redis.call("HDEL", taskKey, "iauID")
        local iauList = redis.call("Zrange", "Ziau", 0,-1)
        for i,v in ipairs(iauList) do
            local IauIP = redis.call("HMGET","iau:" .. v, "iauIP")
            redis.call("ZREM","Ziautask:".. v .."&" ..IauIP[1], taskID)
        end

        redis.call("HSET", taskKey, "taskStatus", "1" )
        rsp.result = "yes"
        rsp.message = "success"
      else
        redis.call("HSET", taskKey, "taskStatus", taskStatus )
        rsp.result = "yes"
        rsp.message = "success"
      end
  else
    rsp.result = "no"
    rsp.message = "TaskNotExists"
  end

  return {cjson.encode(rsp)}

end

-- 计算 未分配的 Task到内存
local function getTaskNotAllot()

  redis.call("ZREMRANGEBYRANK", "Ztasknotallot", 0,-1)
  local alltaskIDs = redis.call("ZRANGE", "Ztask", 0 , -1)

  -- 将所有的任务添加到未分配
  for i,v  in pairs(alltaskIDs) do
      redis.call("ZADD", "Ztasknotallot", 1 , v)
  end

  -- 将在线IAU下的任务排除
  local onlineIauIDs = getOnlineIauIDs();
  if(not not onlineIauIDs) then
      local iauload = {}
      for i,v  in pairs(onlineIauIDs) do
        local IauIP = redis.call("HMGET","iau:" .. onlineIauIDs[i], "iauIP")
        local taskIDs = redis.call("ZRANGE", "Ziautask:" .. onlineIauIDs[i] .."&" ..IauIP[1], 0 , -1)

        for i,v  in pairs(taskIDs) do
            --删除 未分配的表
            redis.call("ZREM", "Ztasknotallot", v)
        end
      end
  end

  -- 将冻结的任务排除
  -- 排除和已完成的任务？
  local FinishedandFrozenTaskIDs = getFinishedandFrozenTaskIDs()
  for i,v  in pairs(FinishedandFrozenTaskIDs) do
      --删除 未分配的表
      redis.call("ZREM", "Ztasknotallot", v)
  end
  -- 将在操作中和 负载度为0的任务排除
  local notallottaskIDs = redis.call("ZRANGE", "Ztasknotallot", 0 , -1)
  for i,v  in pairs(notallottaskIDs) do
    -- 排除操作任务
    if redis.call("EXISTS", "taskOPerate:" .. v) > 0 then
        redis.call("ZREM", "Ztasknotallot", v)
    end

  end
end

-- 处理已完成的task和冻结的任务 和 iau之间关联取消 , ziautask iauID

-- 任务调度
local function TaskDispatch(loadThreshold)

  --负载阈值
  loadThreshold = tonumber(loadThreshold)
  local rsp={}
  local deleteTaskIauIDs = {}
  local Taskload0IDs ={}
  local onlineIauIDs = getOnlineIauIDs();
  rsp.deleteTaskFromIau = "no"
  rsp.noTopPlat = "no"

  -- 顶级平台不存在时，清除所有Iau与任务关系。
  local TopPlatTemp = getTopPlatID();
  if (not TopPlatTemp) then
      rsp.noTopPlat = "yes"
      local alltaskIDs = redis.call("ZRANGE", "Ztask", 0 , -1)
      for i,v  in pairs(alltaskIDs) do
        --xxx 所有的状态切换为冻结状态
        --xxx redis.call("HMSET","task:" .. v,"taskStatus","3")
		-- 设置异常信息
	    redis.call("HMSET","task:" .. v,"taskErrMsg","此为空任务！")
		Taskload0IDs[#Taskload0IDs+1] = tostring(v)
      end

      for i,v  in pairs(onlineIauIDs) do
          local IauIP = redis.call("HMGET","iau:" .. v, "iauIP")
          local taskIDs = redis.call("ZRANGE", "Ziautask:" .. v .."&" ..IauIP[1], 0 , -1)
          local iauTempv = v
          -- 已完成和冻结的任务 和iau 取消关联
          for i,v  in pairs(taskIDs) do
                -- 是否不存在
                local taskKey = "task:" .. v
                if redis.call("hlen", taskKey) > 1 then
                    -- 清除 Ziautask
                    local iauTempvIauIP = redis.call("HMGET","iau:" .. iauTempv, "iauIP")
                    redis.call("ZREM", "Ziautask:" .. iauTempv .."&" ..iauTempvIauIP[1], v)
                    -- 清除 task iauID
                    redis.call("HDEL", taskKey, "iauID")
                    rsp.deleteTaskFromIau = "yes"
                    -- 加到删除iau的task任务 iau的id 后续做通知
                    deleteTaskIauIDs[#deleteTaskIauIDs+1] = tostring(v)
                    deleteTaskIauIDs[#deleteTaskIauIDs+1] = tostring(iauTempv)
                else
                    redis.call("UNLINK", taskKey)
                    redis.call("ZREM", "Ztask:" , v)
                    local iauTempvIauIP = redis.call("HMGET","iau:" .. iauTempv, "iauIP")
                    redis.call("ZREM", "Ziautask:" .. iauTempv .."&" ..iauTempvIauIP[1], v)
                end
          end
      end
  end

  -- 遍历所有任务 判断是否为0
  local alltaskIDs = redis.call("ZRANGE", "Ztask" , 0 , -1)
  for i,v  in pairs(alltaskIDs) do
  	local alltaskload = getTaskloadByTaskID(v)
  	if (alltaskload==0) then
  		-- 设置异常信息
  		redis.call("HMSET","task:" .. v,"taskErrMsg","此为空任务！")
  	else
  		-- 消除异常信息
  		redis.call("HMSET","task:" .. v,"taskErrMsg","0")
	end
  end

  -- 清理 已完成和冻结的任务  and  任务关联的通道为0的任务
  for i,v  in pairs(onlineIauIDs) do
      local iauIP = redis.call("HMGET","iau:" .. v, "iauIP")
      local taskIDs = redis.call("ZRANGE", "Ziautask:" .. v .."&" ..iauIP[1], 0 , -1)
      local iauTempv = v
      -- 已完成和冻结的任务 和iau 取消关联
      for i,v  in pairs(taskIDs) do
            -- 是否不存在
            local taskKey = "task:" .. v
            if redis.call("hlen", taskKey) > 1 then
                -- 通过taskid 看 状态 是 已完成 4 和 冻结 3
                local taskStatus = redis.call("HMGET",taskKey, "taskStatus")
                if ((not not taskStatus[1]) and (taskStatus[1] == "3" or taskStatus[1] == "4")) then
                    -- 清除 Ziautask
                    local iauIPTempv = redis.call("HMGET","iau:" .. iauTempv, "iauIP")
                    redis.call("ZREM", "Ziautask:" .. iauTempv .."&" ..iauIPTempv[1], v)
                    -- 清除 task iauID
                    redis.call("HDEL", taskKey, "iauID")
                    rsp.deleteTaskFromIau = "yes"
                    deleteTaskIauIDs[#deleteTaskIauIDs+1] = tostring(v)
                    deleteTaskIauIDs[#deleteTaskIauIDs+1] = tostring(iauTempv)
                end
				-- 判断关联为0的任务
        		local thistaskload = getTaskloadByTaskID(v)
        		if (thistaskload==0) then
					-- 非执行中的任务要和iaud断掉
					if ((not not taskStatus[1]) and (taskStatus[1] ~= "2")) then
                        -- 清除 Ziautask
                        local iauIPTempv = redis.call("HMGET","iau:" .. iauTempv, "iauIP")
                        redis.call("ZREM", "Ziautask:" .. iauTempv .."&" ..iauIPTempv[1], v)
						-- 清除 task iauID
						redis.call("HDEL", taskKey, "iauID")
						rsp.deleteTaskFromIau = "yes"
						deleteTaskIauIDs[#deleteTaskIauIDs+1] = tostring(v)
						deleteTaskIauIDs[#deleteTaskIauIDs+1] = tostring(iauTempv)
						-- 设置状态信息
						TaskStatusJudge(v)
						redis.call("HMSET","task:" .. v,"taskErrMsg","此为空任务！")
					end
					-- 设置异常信息
					Taskload0IDs[#Taskload0IDs+1] = tostring(v)
				end
            else
                redis.call("UNLINK", taskKey)
                redis.call("ZREM", "Ztask:" , v)
                local iauIPTempv = redis.call("HMGET","iau:" .. iauTempv, "iauIP")
                redis.call("ZREM", "Ziautask:" .. iauTempv .."&" ..iauIPTempv[1], v)
            end
      end
  end
  rsp.deleteTaskIauIDs = deleteTaskIauIDs
  rsp.Taskload0IDs = Taskload0IDs

  local allotTask={}
  rsp.notallottask = "no"
  rsp.notallotRunningtask = "no"
  local notallotRunningtaskIDs = {}

  getTaskNotAllot()
  local allnotallottaskIDs = redis.call("ZRANGE", "Ztasknotallot", 0 , -1)
  -- 循环 allnotallottaskIDs
  for i,v  in pairs(allnotallottaskIDs) do
    -- 执行中的任务 又没有iau拿到
	-- 状态判断 set状态 and 后台数据库修改 状态
	local taskStatus = redis.call("HMGET","task:".. v, "taskStatus")
    if ((not not taskStatus[1]) and (taskStatus[1] == "2")) then
      -- 清除 task iauID
      redis.call("HDEL", "task:".. v, "iauID")
      rsp.notallotRunningtask = "yes"
      notallotRunningtaskIDs[#notallotRunningtaskIDs+1] = tostring(v)
    else
      local alltaskload = getTaskloadByTaskID(v)
      -- 排除空任务
      if (alltaskload==0) then
        -- 设置异常信息
        redis.call("HMSET","task:" .. v,"taskErrMsg","此为空任务！")
      else
        -- 消除异常信息
        redis.call("HMSET","task:" .. v,"taskErrMsg","0")

        local taskinfo = redis.call("HMGET", "task:" .. v, "taskMainTypeID","startTime","doTime")
        local taskhours = 0
        if taskinfo[1] == "1" then
            taskhours=getTimeHours(taskinfo[2],"1")
        elseif taskinfo[1] == "2" then
            taskhours=getTimeHours(taskinfo[3],"2")
        end
        -- 找到时间段中最小的 IauID
        local loadMinIauID = getLoadMinIauID(taskhours)
        local loadMinIauIP = redis.call("HMGET","iau:" .. loadMinIauID, "iauIP")
        if(not not loadMinIauID) then
            rsp.notallottask = "yes"
            redis.call("ZADD","Ziautask:" .. loadMinIauID .."&" ..loadMinIauIP[1], 1 , v )
            redis.call("HMSET", "task:".. v, "iauID" ,loadMinIauID)
            allotTask[#allotTask+1] = tostring(v)
            allotTask[#allotTask+1] = tostring(loadMinIauID)
        end
      end
    end
  end

  rsp.notallotRunningtaskIDs=notallotRunningtaskIDs
  rsp.allottasklist = allotTask

  rsp.schedule = "no"
  local allotedMaxIauIDs = {}
  local allotedMaxIauLoads = {}
  local allotedTaskIDs = {}
  local allotedTaskIDloads = {}
  local receivedMinIauIDs = {}
  local receivedMinIauLoads = {}

  local onlineIauIDs = getOnlineIauIDs();

  if(not not onlineIauIDs) then
      -- 如果有多个Iau
      if(#onlineIauIDs > 1 ) then

          -- 五个时间段循环 1 2 3 4 0
          for houri=0,4,1 do

            local loadMinIauID = getLoadMinIauID(houri)
            local loadMaxIauID = getLoadMaxIauID(houri)

            local loadMinIauIP = redis.call("HMGET","iau:" .. loadMinIauID, "iauIP")
            local loadMaxIauIP = redis.call("HMGET","iau:" .. loadMaxIauID, "iauIP")


            local loadMin = tonumber(getIauloadByIauID(loadMinIauID,houri))
            local loadMax = tonumber(getIauloadByIauID(loadMaxIauID,houri))

            if(loadMax ~= loadMin) then
                if((loadMax - loadMin) >  loadThreshold) then
                    --  负载度最大的 IAU 上断一个 TASK（不在执行的任务） 给负载度最小的 IAU

                    local taskIDs = redis.call("ZRANGE", "Ziautask:" .. loadMaxIauID .."&" ..loadMaxIauIP[1], 0 , -1)
                    --  循环 Ziautask:iauID&iauIauIP
                    for i,v  in pairs(taskIDs) do

                        local m_dev = redis.call("HMGET","task:" .. v, "taskStatus")

                        -- 判断是否是等待中
                        if ((not not m_dev[1]) and (m_dev[1] == "1")) then

                            -- 寻找该时间段的任务
                            local taskinfo = redis.call("HMGET", "task:" .. v, "taskMainTypeID","startTime","doTime")
                            local taskhour = 0
                            if taskinfo[1] == "1" then
                                taskhour = getTimeHours(taskinfo[2],"1")
                            elseif taskinfo[1] == "2" then
                                taskhour = getTimeHours(taskinfo[3],"2")
                            end
                            -- 符合时间段
                            if (taskhour == tonumber(houri)) then
                                --如果不是在操作中
                                if redis.call("EXISTS", "taskOPerate:" .. v) == 0 then
                                    local taskload = getTaskloadByTaskID(v)
                                    -- 判断分配后的情况
                                    if((loadMin + taskload - (loadMax-taskload)) > loadThreshold) then
                                    else
                                        redis.call("ZREM", "Ziautask:" .. loadMaxIauID .."&" ..loadMaxIauIP[1], v)
                                        redis.call("ZADD","Ziautask:" .. loadMinIauID .."&" ..loadMinIauIP[1], 1 , v )
                                        redis.call("HMSET", "task:".. v, "iauID" ,loadMinIauID)
                                        rsp.schedule = "yes"
                                        allotedMaxIauIDs[#allotedMaxIauIDs+1] = tostring(loadMaxIauID)
                                        allotedMaxIauLoads[#allotedMaxIauLoads+1] = loadMax
                                        allotedTaskIDs[#allotedTaskIDs+1] = tostring(v)
                                        allotedTaskIDloads[#allotedTaskIDloads+1] = taskload
                                        receivedMinIauIDs[#receivedMinIauIDs+1] = tostring(loadMinIauID)
                                        receivedMinIauLoads[#receivedMinIauLoads+1] = loadMin
                                        break
                                    end

                                end

                            end


                        end

                    end

                    --rsp.schedulmessage  = "task not allot"
                    --return  {cjson.encode(rsp)}

                else
                    --rsp.schedulmessage = "not exceed threshold"
                    --return  {cjson.encode(rsp)}
                end

            else
                --rsp.schedulmessage = "Avg"
                --return  {cjson.encode(rsp)}
            end


         end

         rsp.allotedMaxIauIDs=allotedMaxIauIDs
         rsp.allotedMaxIauLoads=allotedMaxIauLoads
         rsp.allotedTaskIDs=allotedTaskIDs
         rsp.allotedTaskIDloads=allotedTaskIDloads
         rsp.receivedMinIauIDs=receivedMinIauIDs
         rsp.receivedMinIauLoads=receivedMinIauLoads

         return  {cjson.encode(rsp)}

      elseif(#onlineIauIDs == 1 ) then
          getIauloadByIauID(onlineIauIDs[1])
          rsp.schedulmessage = "Just One IAU"
          return  {cjson.encode(rsp)}
      else
          rsp.schedulmessage = "No IAU"
          return  {cjson.encode(rsp)}
      end
  end

  rsp.schedulmessage = "No IAU"
  return  {cjson.encode(rsp)}
  --return rsp

end

local function putEvent(event)

    local lastEventID = tonumber(redis.call("GET","vas-LastEventID"))
    lastEventID = lastEventID or 0

    lastEventID = lastEventID + 1
    local e = cjson.decode(event)
    if e.targetSessionId and 0 == #e.targetSessionId then
        e.targetSessionId = nil
    end
    e.eventId = lastEventID;
    event = cjson.encode(e)

    redis.call("SET","vas-LastEventID",lastEventID)
    redis.call("SET","vas-Event-"..lastEventID,event,"EX",300)
    redis.call("PUBLISH","vasNewEvent"..lastEventID,"vasNewEvent")

    return {lastEventID,event}

end

local function getEvent(startID,endID)

    local lastEventID = tonumber(redis.call("GET","vas-LastEventID"))
    lastEventID = lastEventID or 0
    endID = endID or lastEventID

    local events = {}

    for i=startID,endID
    do
        local e = redis.call("GET","vas-Event-"..i)
        if e then
          e = cjson.decode(e)
          events[#events+1] = e
        end
    end

   local eventJson = "[]"
  if #events > 0 then
    eventJson = cjson.encode(events)
    end

    return {lastEventID,eventJson}

end


local setLicense = function(...)
     local kv = convertToTable(arg)
     local chkV = {}
    for key,value in pairs(kv) do
        key = tostring(key)
        value = tostring(value)
        redis.call("HSET", "license", key, value)
         local v = tostring(redis.call("HGET", "license", key))
         chkV[key] = v
    end

    return {"OK", cjson.encode(kv), cjson.encode(chkV)}
end


local function logoutAllPau()
    local paulist = redis.call("ZRANGE", "Zpau", 0 ,-1)

    for _,_id in pairs(paulist) do
        local pauKey = "pau:".._id
        redis.call("HSET", pauKey, "onlineStatus", 0)
    end

    return {"OK"}
end


local function setFlagByName(flagName,exTime, val)
  val = val or "1"
  redis.call("SET", "Flag-" .. flagName , val, "EX", exTime);
  return {"OK"}
end

local function delFlagByName(flagName)
  redis.call("UNLINK", "Flag-" .. flagName);
  return {"OK"}
end

local function chkFlagByName(flagName)
    local flagKey = "Flag-" .. flagName
    if redis.call("EXISTS", flagKey) > 0 then
          local val = tostring(redis.call("GET", flagKey))
          return {"EXISTS", flagKey,  val }
    end
    return {"NOTEXISTS", flagKey}
end


local function getInnerVasModule()


    local mdl = {}

    local moduleIDs = redis.call("HMGET", "system" , "innerPauID", "innerIauID")

    local pauID = tostring(moduleIDs[1])
    local iauID = tostring(moduleIDs[2])

    if redis.call("EXISTS", "pau:" .. pauID) > 0 then
        local pau = getPauByIDArray(pauID)
        mdl.pau = cjson.decode(pau[2])[1]
    end

    if redis.call("EXISTS", "iau:" .. iauID) > 0 then
        local iau = getIauByIDArray(iauID)
        mdl.iau = cjson.decode(iau[1])[1]
    end

    if mdl.iau and mdl.pau then
        return {true , cjson.encode(mdl)}
    else
        return {false}
    end
end

local function searchSlaveVas(pageJson, cretiriaJson, targetRedisKey)
    local t_page = cjson.decode(pageJson)
    local t_cretiria = cjson.decode(cretiriaJson)

    local orderBy = t_page.orderBy or "slaveVasName"
    local orderScend = t_page.orderScend or "ASC"

    local pageNum = math.abs(tonumber(t_page.pageNum) or 0)
    local pageSize = math.abs(tonumber(t_page.pageSize) or 0)

    targetRedisKey = targetRedisKey or "ZslaveVas"
    local tp = redis.call("TYPE", targetRedisKey)
    if tp.ok == "set" then
        redis.call("ZUNIONSTORE", "T-searchSlaveVas", 1, targetRedisKey)
        targetRedisKey = "T-searchPlatform"
    end

    local total = redis.call("ZCARD", targetRedisKey)

 -- get all matched
    if 0 == pageNum*pageSize then
        pageNum = 1
        pageSize = total
    end


    --search cretira
    local c_name = t_cretiria.slaveVasName
    local c_netAddress = t_cretiria.slaveVasIP
    local c_OnlineStatus = tonumber(t_cretiria.onlineStatus)
    if c_OnlineStatus then
        c_OnlineStatus = tostring(c_OnlineStatus)
    end
    local c_version = t_cretiria.slaveVasVersion
    local c_cap = t_cretiria.slaveVasCap


    local resultIDs = {}

    local q_fields = {}

    local flag_name = 0
    if (c_name and string.len(c_name) > 0) then
      flag_name = 1
      c_name = string.lower(c_name)
      q_fields.Name = #q_fields+1
      q_fields[#q_fields+1] = "slaveVasName"
    end

    local flag_netAddress = 0
    if (c_netAddress and string.len(c_netAddress) > 0) then
      flag_netAddress = 1
      q_fields.NetAddress = #q_fields+1
      q_fields[#q_fields+1] = "slaveVasIP"
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
      q_fields[#q_fields+1] = "slaveVasVersion"
    end

    local flag_cap = 0
    if (c_cap and string.len(c_cap) > 0) then
      flag_cap = 1
      c_cap = string.lower(c_cap)
      q_fields.Capability = #q_fields+1
      q_fields[#q_fields+1] = "slaveVasCap"
    end

    local flag_condtion_total = flag_name  + flag_netAddress  + flag_OnlineStatus  + flag_version + flag_cap

    local zrangeScent = "ZRANGE"

    -- orderBy if not slaveVasName then use "ZslaveVas-orderBy"

    if (orderScend and "DESC" == string.upper(orderScend)) then
        zrangeScent = "ZREVRANGE"
    end

    if flag_condtion_total > 0 then -- 需要过滤
        local IDs = redis.call(zrangeScent, targetRedisKey, 0 , -1)

        total = 0

        local flag_math = 0

        for i,v  in pairs(IDs) do

            local m_dev = redis.call("HMGET","slaveVas:" .. v, unpack(q_fields))

            flag_math = 0

            local sf =  string.find

            if flag_name > 0 and m_dev[q_fields.Name] and sf(string.lower(m_dev[q_fields.Name]), c_name,1,true) then
            flag_math = flag_math + 1
            end

            if flag_netAddress > 0 and m_dev[q_fields.NetAddress] and sf(m_dev[q_fields.NetAddress], c_netAddress,1,true) then
            flag_math = flag_math + 1
            end

            if flag_OnlineStatus > 0 and (("1" == c_OnlineStatus and "1" == m_dev[q_fields.onlineStatus]) or ("0" == c_OnlineStatus and "1" ~= m_dev[q_fields.onlineStatus])) then
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
        resultIDs = redis.call(zrangeScent, targetRedisKey, (pageNum-1)*pageSize , pageNum*pageSize -1 )
    end

    local result = {}

    for i,id in pairs(resultIDs) do
        local obj = redis.call("HGETALL","slaveVas:" .. id)
        obj = convertToTable(obj, NumbericalMark_All)
        local slaveHB_Key = "slaveVas-hb:" .. obj.slaveVasID
        if redis.call("EXISTS", slaveHB_Key) > 0 then
            obj.onlineStatus = 1
        else
            obj.onlineStatus = 0
        end

        if obj.iauID then
            obj.iauStatusDesc = redis.call("HGET", "iau:" .. obj.iauID, "statusDesc") or ""
        end

        if obj.pauID then
            obj.pauStatusDesc = redis.call("HGET", "pau:" .. obj.pauID, "statusDesc") or ""
        end


        result[#result+1] = obj
    end


    local rsp = {
        total = total,
        pageNum = pageNum,
        pageSize = pageSize,
        netSize = #result,
        orderBy = orderBy,
        orderScend = string.upper(orderScend),
        rows = result,
        slaveVasName = c_name,
    }

    return  {cjson.encode(rsp)}

end



local function slaveVasHeartbeat(upt,hbTimeOut, slaveVasJson)

    local slaveVas = cjson.decode(slaveVasJson)

    local ret = false
    local err = ""

    if not slaveVas.vasID then
        err = "vmu.SlaveVas.Heartbeat.vasID"
    elseif not slaveVas.vmuIP then
        err = "vmu.SlaveVas.Heartbeat.vmuIP"
    elseif not slaveVas.modules then
        err = "vmu.SlaveVas.Heartbeat.modules"
    else
        local slaveKey = "slaveVas:" .. slaveVas.vasID
        if redis.call("EXISTS", slaveKey) > 0 then
            local fields = redis.call("HMGET", slaveKey, "slaveVasIP")
            if tostring(fields[1]) == slaveVas.vmuIP then
                ret = true
                -- 将对应的 iau pau ID更新进slavevas
                --if slaveVas.modules.iau and slaveVas.modules.iau.iauID then
                --    redis.call("HMSET", slaveKey, "iauID", slaveVas.modules.iau.iauID)

                --end

                --if slaveVas.modules.pau and slaveVas.modules.pau.pauID then
                --    redis.call("HMSET", slaveKey, "pauID", slaveVas.modules.pau.pauID)
                --end

            else
                err = "vmu.SlaveVas.Heartbeat.IPNotMatch"
            end
        else
            err = "vmu.SlaveVas.Heartbeat.NotExists"
        end
    end

    local slaveHB_Key = "slaveVas-hb:" .. slaveVas.vasID
    if ret then

        redis.call("SET",slaveHB_Key , upt)
        redis.call("EXPIRE",slaveHB_Key , hbTimeOut)
    else
        redis.call("UNLINK",slaveHB_Key)
    end

    return {ret, err}
end

local function getSlaveVasByIDArray(...)

    local IDs = {}
    for i = 1,arg.n do
       IDs[#IDs+1] = arg[i]
    end

    local result = {}

    local cnt = 0
    for i,id  in pairs(IDs) do
        local obj = redis.call("HGETALL","slaveVas:" .. id)
        if next(obj) ~= nil then
            obj = convertToTable(obj, NumbericalMark_All)
            local slaveHB_Key = "slaveVas-hb:" .. obj.slaveVasID
            if redis.call("EXISTS", slaveHB_Key) > 0 then
                obj.onlineStatus = 1
            else
                obj.onlineStatus = 0
            end

            result[#result+1] = obj
            cnt = cnt + 1
        else
            result[#result+1] = {}
        end
    end

    return  {cnt == #IDs, cjson.encode(result)}
end

local function getSlaveVasStatusByIDArray(...)
    local IDs = {}
    for i = 1,arg.n do
       IDs[#IDs+1] = arg[i]
    end

    local result = {}

    local cnt = 0
    for i,id  in pairs(IDs) do
        local missingFlag = (0 == redis.call("EXISTS", "slaveVas:" .. id))
        local obj = redis.call("HMGET","slaveVas:" .. id, "slaveVasIP", "statusDesc", "iauID", "pauID")


        local item = {slaveVasID = id , missing = missingFlag, slaveVasIP = obj[1], statusDesc = obj[2] or ""}

        local slaveHB_Key = "slaveVas-hb:" .. item.slaveVasID
        if redis.call("EXISTS", slaveHB_Key) > 0 then
            item.onlineStatus = 1
        else
            item.onlineStatus = 0
        end

        local iauID = obj[3]
        local pauID = obj[4]

        if iauID then
            item.iauStatusDesc = redis.call("HGET", "iau:" .. iauID, "statusDesc") or ""
        end

        if pauID then
            item.pauStatusDesc = redis.call("HGET", "pau:" .. pauID, "statusDesc") or ""
        end

        result[#result+1] = item
        cnt = cnt + 1
    end

    return  {cnt == #IDs, cjson.encode(result)}
end




local function getZsetMinus(keya, keyb)


    local b = redis.call("zrange", keya, 0 ,-1)

    local a = redis.call("zrange", keyb, 0 ,-1)

    local t = {}
    for i,v in pairs(a) do
        t[v] = true
    end

    local r = {}
    for i,v in pairs(b) do
    if not t[v] then
        r[#r+1] = v
    end
    end

    return r

end

local function getVasMode()

    if redis.call("HEXISTS", "system", "vasMode-master") > 0 then
        return {"master"}
    else
        return {"slave"}
    end

end

local function getChnDomDist(taskChnKey)
    local taskChnKey = tostring(taskChnKey)
    local maxScoreItem = redis.call("ZRANGE", taskChnKey, -1, -1, "WITHSCORES")
    local maxScore=tonumber(maxScoreItem[2])

    local r = {byScore={}, byName={}}

    local p = string.match(taskChnKey,"(.*):Ztaskchannel")

    if maxScore then

        local domainInfo = redis.call("ZRANGE", p .. ":ZdomainByName", 0 ,-1, "WITHSCORES")
        local domainInfo_2 = {}
        if next(domainInfo) ~= nil then
            domainInfo = convertToTable(domainInfo)
            for k,v in pairs(domainInfo) do
                domainInfo_2[v] = k
            end
        else
            domainInfo = {}
        end

        --if true then
        --    return {cjson.encode(domainInfo_2)}
        -- end


        for i=0, maxScore do
            local cnt = redis.call("ZCOUNT", taskChnKey, i, i)
            if cnt > 0 then

                    r.byScore[i] = cnt

                    local domID = domainInfo_2[tostring(i)]
                    if domID then
                        local domName = redis.call("HGET",p .. ":domain:" .. domID, "domainName")
                        r.byName[domName] = cnt

                    end


            end
        end
    end

    return {cjson.encode(r)}
end



local function getTreeFingerprint(treeID, p)
    if not p then
        p  = getPlatSrcKeyPrefix()
        if not p then
            return {false,{}}
        end
    end

    local leftKey =  p .. ":" .. treeID .. ":" .. "ZgroupLeft"

    local rightKey = p .. ":" .. treeID .. ":".. "ZgroupRight"

    if 2 ~= redis.call("EXISTS", leftKey, rightKey) then
        return {false,{}}
    end

    local gLeft = redis.call("ZRANGE", leftKey, 0, -1 , "WITHSCORES")
    local gRight = redis.call("ZRANGE", rightKey, 0, -1 , "WITHSCORES")

    local crc32 = table_crc32(gLeft, gRight)

    return {true, crc32}

end




local switch = {

    getTimeHours = getTimeHours,

    getTreeFingerprint = getTreeFingerprint,

    getZsetMinus = getZsetMinus,
    getTreeChildGroup = getTreeChildGroup,
    getPlatSrcKeyPrefix = getPlatSrcKeyPrefix,
    getPlatGroupByIDArray = getPlatGroupByIDArray,
    updatePlatformStatus = updatePlatformStatus,

    getPauByIDArray = getPauByIDArray,
    searchPau = searchPau,
    pauLogin = pauLogin,
    pauLogout = pauLogout,
    pauHeartBeat = pauHeartBeat,
    checkPauHeartbeat = checkPauHeartbeat,
    pauGetPlatforms = pauGetPlatforms,
    getIdlestPau = getIdlestPau,
    getBusiestPau = getBusiestPau,
    dispatchPlatform = dispatchPlatform,
    logoutAllPau = logoutAllPau,

    searchPlatform = searchPlatform,
    getPlatformByIDArray = getPlatformByIDArray,
    getPlatStatusByIDArray = getPlatStatusByIDArray,

    searchChannel = searchChannel,

    getTopPlatID = getTopPlatID,

    getTopPlatInfo = getTopPlatInfo,

    getChannelByIDArray = getChannelByIDArray,

    getChannelByID = getChannelByID,

    getPauStatusByIDArray = getPauStatusByIDArray,

    updatePlatSyncRound = updatePlatSyncRound,

    wipeOldSrc = wipeOldSrc,

    getPau2platInfo = getPau2platInfo,
    getPlat2PauInfo = getPlat2PauInfo,


    -- tsu
    TaskStatusJudge =TaskStatusJudge,
    getIauByIDArray = getIauByIDArray,
    searchIau = searchIau,
    searchOnlinedIau = searchOnlinedIau,
    iauLogin = iauLogin,
    iauLogout = iauLogout,
    iauHeartBeat = iauHeartBeat,
    setIauStatus = setIauStatus,

    getIauStatusByIDArray = getIauStatusByIDArray,
    checkIauStatusByIDArray =checkIauStatusByIDArray,

    checkIauLoginexception = checkIauLoginexception,
    checkIauHeartBeat = checkIauHeartBeat,

    taskInit = taskInit,
    getTaskByIDArray = getTaskByIDArray,
    searchTask = searchTask,
    searchTaskByIau = searchTaskByIau,

	getTaskNotAllot = getTaskNotAllot,
    TaskDispatch = TaskDispatch,

    getTaskStatusandIauID = getTaskStatusandIauID,
    setTaskStatus = setTaskStatus,
    getTaskStatusandIauIDByIDArray = getTaskStatusandIauIDByIDArray,

    setTaskOPerateByID = setTaskOPerateByID,

    -- tsu  debug
    getOnlineIauIDs = getOnlineIauIDs,
    getTaskloadByTaskID = getTaskloadByTaskID,

    getIauloadByIauID = getIauloadByIauID,
    getNotBanonlineIauIDs = getNotBanonlineIauIDs,
    --getLoadMinIauID 加一个参数 用于时间段
    getLoadMinIauID = getLoadMinIauID,
    getLoadMaxIauID = getLoadMaxIauID,

    getFrozenTaskIDs = getFrozenTaskIDs,

    countChannel = countChannel,
    putEvent = putEvent,
    getEvent = getEvent,

    setLicense = setLicense,

    getPlatSyncResult = getPlatSyncResult,

    setFlagByName = setFlagByName,
    delFlagByName = delFlagByName,
    chkFlagByName = chkFlagByName,

    getGroupTree = getGroupTree,
    getTreeRootGroup = getTreeRootGroup,
    getInnerVasModule = getInnerVasModule,

    searchSlaveVas = searchSlaveVas,
    getSlaveVasByIDArray = getSlaveVasByIDArray,
    slaveVasHeartbeat = slaveVasHeartbeat,
    getSlaveVasStatusByIDArray = getSlaveVasStatusByIDArray,

    searchBlacklist = searchBlacklist,

    getVasMode = getVasMode,

    getChnDomDist = getChnDomDist,

}


local cmd = switch[KEYS[1]]
if(cmd) then
  return cmd(unpack(KEYS,2))
else
  return "no such method"
end
