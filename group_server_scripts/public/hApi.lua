xlLG = function(sFileName,sLog,a,...)
	local s
	if a then
		s = tostring(string.format(sLog,a,...))
	else
		s = tostring(sLog)
	end
	local f = io.open("log/"..hVar.SYSTEM_DATE..sFileName..".log","a")
	if f then
		f:write("["..math.floor(os.clock()*1000).."] "..s.."\n")
		f:close()
	else
		xlout("[print]",s,"\n")
	end
end

hApi.NumBetween = function(v,a,b)
	if a>b then
		a,b = b,a
	end
	if v<a then
		return a
	elseif v<=b then
		return v
	else
		return b
	end
end

local __GetRandPermNum
__GetRandPermNum = function(rTab,aTab,nCur,nIndex)
	local IsEnd = 1
	for i = 1,nIndex,1 do
		if aTab[i]~=1 and nCur>=rTab[i] then
			IsEnd = 0
			aTab[i] = 1
			nCur = nCur + 1
		end
	end
	if IsEnd~=1 then
		return __GetRandPermNum(rTab,aTab,nCur,nIndex)
	else
		return nCur
	end
end

hApi.RandomPerm = function(nRange,nNum)
	local r = {}
	local nLoop = math.min(nRange,nNum or nRange)
	for i = 1,nLoop,1 do
		r[i] = __GetRandPermNum(r,{},math.random(1,nRange-(i-1)),i-1)
	end
	return r
end

hApi.Cmd2Date = function(sCmd)
	if (sCmd and type(sCmd)~="string") then
		return {0,0,0}
	end
	local _,_,y,m,d = string.find(sCmd,"(%d+)-(%d+)-(%d+)")
	if y and m and d then
		y = tonumber(y)
		m = tonumber(m)
		d = tonumber(d)
	else
		y = 0
		m = 0
		d = 0
	end
	return {y,m,d}
end

hApi.Date2Cmd = function(tDate)
	return tDate[1].."-"..tDate[2].."-"..tDate[3]
end

--时间转化为数值
hApi.Date2Num = function(sDate)
	if (sDate and type(sDate)~="string") then
		return 0
	end
	local a,b,yy,mm,dd = string.find(sDate,"(%d+)-(%d+)-(%d+)")
	if yy then
		return tonumber(yy)*10000+tonumber(mm)*100+tonumber(dd)
	else
		return 0
	end
end

--将字符串转化为时间戳，并可以叠加特定的时间
--参数: "2015-01-01 00:00:00"
--返回值: 时间戳（整数值）
hApi.GetNewDate = function(srcDateTime, dateUnit, interval)
	--无效的格式
	if (type(srcDateTime) ~= "string") then
		return 0
	end
	
	--无效的日期格式
	if (#srcDateTime ~= 19) then
		return 0
	end
	
	--防止数据库读到0值
	if (srcDateTime == "0000-00-00 00:00:00") then
		return 0
	end
	
	--从日期字符串中截取出年月日时分秒
	local Y = string.sub(srcDateTime, 1, 4)
	local M = string.sub(srcDateTime, 6, 7)
	local D = string.sub(srcDateTime, 9, 10)
	local H = string.sub(srcDateTime, 12, 13)
	local MM = string.sub(srcDateTime,15, 16)
	local SS = string.sub(srcDateTime, 18, 19)
	
	--把日期时间字符串转换成对应的日期时间
	local dt1 = os.time{year = Y, month = M, day = D, hour = H, min = MM, sec = SS}
	--print(Y, M, D, H, MM, SS)
	
	--根据时间单位和偏移量得到具体的偏移数据
	local ofset = 0
	if (dateUnit =='DAY') then
		ofset = 60 *60 * 24 * interval
	elseif (dateUnit == 'HOUR') then
		ofset = 60 *60 * interval
	elseif (dateUnit == 'MINUTE') then
		ofset = 60 * interval
	elseif (dateUnit == 'SECOND') then
		ofset = interval
	end
	
	--指定的时间+时间偏移量
	local newTime = os.date("*t", dt1 + tonumber(ofset))
	local iIime = os.time(newTime)
	return iIime
end

--时间戳转换成标准date
hApi.Timestamp2Date = function(timestamp)
	local tab = os.date("*t", timestamp)
	local year = tab.year
	local month = tab.month
	local szMonth = tostring(month)
	if (#szMonth < 2) then
		szMonth = "0" .. szMonth
	end
	local day = tab.day
	local szDay = tostring(day)
	if (#szDay < 2) then
		szDay = "0" .. szDay
	end
	local szTime = year .. "-" .. szMonth .. "-" .. szDay
	return szTime
end

--时间戳转化为字符串完整时间
hApi.Timestamp2Time = function(timestamp)
	return os.date("%Y-%m-%d %H:%M:%S", timestamp)
end

--时间转化为星期(参数支持时间戳和时间字符串)
hApi.Time2Weekdate = function(timestamp)
	local t = timestamp
	if type(t) == "string" then
		t = hApi.GetNewDate(timestamp)
	elseif type(t) == "number" then
		--t = timestamp
	else
		return 1
	end
	local weekDay = os.date("%w",t) or 0
	--如果是礼拜天，则返回7
	if (weekDay == "0") then
		weekDay = 7
	end
	return tonumber(weekDay)
end

--获取程序启动到当前为止的时间，精度毫秒
hApi.GetClock = function()
	return os.clock()*1000
end

--获取服务器当前时间戳
hApi.GetTime = function()
	return os.time() - hVar.DELT_TIME
end

--时间格式化（秒 变成 时：分：秒）
hApi.FormatS2HMS = function(time)
	local hour = math.floor(time/3600)
	local minute = math.fmod(math.floor(time/60), 60)
	local second = math.fmod(time, 60)
	
	local strHour = tostring(hour)
	if (#strHour < 2) then
		strHour = "0" .. strHour
	end
	local strMinute = tostring(minute)
	if (#strMinute < 2) then
		strMinute = "0" .. strMinute
	end
	local strSecond = tostring(second)
	if (#strSecond < 2) then
		strSecond = "0" .. strSecond
	end
	local rtTime = string.format("%s:%s:%s", strHour, strMinute, strSecond)
	
	return rtTime
end

hApi.Key2QueryCmd = function(t)
	if #t>0 then
		local r = {}
		for i = 1,#t do
			if i>1 then
				r[#r+1] = ","
			end
			r[#r+1] = t[i]
		end
		return table.concat(r)
	else
		return " "
	end
end

hApi.IsDateEqual = function(t1,t2)
	for i = 1,3 do
		if t1[i]~=t2[i] then
			return hVar.RESULT_FAIL
		end
	end
	return hVar.RESULT_SUCESS
end

hApi.ConcatEx = function(t,v)
	local r = {}
	for i = 1,#t do
		r[#r+1] = t[i]
		if i~=#t then
			r[#r+1] = v
		end
	end
	return table.concat(r)
end

hApi.GetValFromCmd = function(tTemp,sCmd)
	local r = {}
	--tTemp[i] = {"key","key=(%mathch)",default}
	for i = 1,#tTemp do
		local v = tTemp[i]
		local _,_,val = string.find(sCmd,v[2])
		if val~=nil then
			if type(v[3])=="number" then
				r[v[1]] = tonumber(val)
			else
				r[v[1]] = val
			end
		else
			r[v[1]] = v[3]
		end
	end
	return r
end

--------------------------------------------------
-- a:(%d+);
hApi.GetNumByPatten = function(sCmd,sPatten)
	local _,_,v = string.find(sCmd,sPatten)
	if v then
		local n = tonumber(v)
		if type(n)=="number" then
			return n
		end
	end
	return 0
end

--------------------------------------------------
-- {"a:(%d+);","b:(%d+);"}
hApi.GetNumByPattenT = function(sCmd,tPatten)
	local tResult = {}
	for i = 1,#tPatten do
		local sPatten = tPatten[i]
		local _,_,v = string.find(sCmd,sPatten)
		if v then
			tResult[i] = tonumber(v)
		else
			tResult[i] = 0
		end
	end
	return unpack(tResult)
end

hApi.SortTableI = function(tab,IsClearZero)
	local lastI
	local iMax = tab.i or #tab
	for i = 1,iMax do
		if tab[i]==0 then
			lastI = lastI or i
		elseif lastI then
			tab[lastI] = tab[i]
			tab[i] = 0
			lastI = lastI + 1
		end
	end
	if lastI then
		for i = iMax,lastI,-1 do
			tab[i] = nil
		end
		if tab.i then
			tab.i = lastI - 1
		end
	end
	if IsClearZero==1 then
		for i = iMax,1,-1 do
			if tab[i]~=0 then
				break
			else
				tab[i] = nil
			end
		end
	end
	return tab
end

hApi.GetClockByCmd = function(sCmd)
	if type(sCmd)=="string" then
		for h,m,s in string.gfind(sCmd,"([%d]+):([%d]+):([%d]+)")do
			return tonumber(h)*3600+tonumber(m)*60+tonumber(s)
		end
	end
	return -1
end

--从cmd获取参数（需要符合协议规则"abc:%d:%d;"）
hApi.GetParamByCmd = function(sHead,sCmd,rTab)
	rTab = rTab or {}
	for a in string.gfind(sCmd,(sHead or "").."([^;]-);")do
		local v = {}
		local sus = nil
		local nCur = 0
		local nLen = string.len(a)
		while(nCur and nCur<=nLen)do
			local nCurOld = nCur
			local s = string.find(a,":",nCur+1)
			if string.sub(a,nCur+1,nCur+1)=="{" then
				local e = string.find(a,"}",nCur+2)
				if e then
					v[#v+1] = string.sub(a,nCur+2,e-1)
					nCur = e+1
				else
					--非法的字符串！
					break
				end
			else
				if s~=nil then
					v[#v+1] = string.sub(a,nCur+1,s-1)
					nCur = s
				else
					v[#v+1] = string.sub(a,nCur+1,nLen)
					nCur = nLen + 1
				end
			end
			if nCurOld==nCur then
				nCur = nLen + 1
			end
		end
		rTab[#rTab+1] = v
	end
	return rTab
end

--分割字符串
--[[
hApi.Split = function(str, delim, maxNb)   
    -- Eliminate bad cases...   
    if string.find(str, delim) == nil then  
        return { str }  
    end  
    if maxNb == nil or maxNb < 1 then  
        maxNb = 0    -- No limit   
    end  
    local result = {}  
    local pat = "(.-)" .. delim .. "()"   
    local nb = 0  
    local lastPos   
    for part, pos in string.gmatch(str, pat) do  
        nb = nb + 1  
        result[nb] = part   
        lastPos = pos   
        if nb == maxNb then break end  
    end  
    -- Handle the last field   
    if nb ~= maxNb then  
        result[nb + 1] = string.sub(str, lastPos)   
    end  
    return result
end
--]]

--字符串转化为一维表
-- 参数:
-- 	strings: 字符串
-- 	separateType: 分隔符号
-- 	bInteger: 一维表的每个元素是否为整数值(默认值: false)
local String2Type = function(strings, separateType, bInteger)
	local ret = {} --返回值
	
	if (#strings > 0) then
		--如果第一个字符是分隔符, 那么删掉该分隔符
		if (strings[1] == separateType) then
			strings = string.sub(strings, 2, #strings)
		end
		
		--如果最后一个字符不是分隔符, 那么添加该分隔符
		if (strings[#strings] ~= separateType) then
			strings = ("%s%s"):format(strings, separateType)
		end
		
		--开始循环处理
		local buff = strings
		while true do
			local pos = string.find(buff, separateType)
			if pos and (pos > 0) then
				--找到分隔符
				local szValue = string.sub(buff, 1, pos - 1) --元素
				local value = szValue
				if bInteger then
					value = tonumber(szValue) or 0
				end
				
				table.insert(ret, value)
				buff = string.sub(buff, pos + 1, #buff)
			else
				--找不到分隔符了
				break
			end
		end
	end
	
	return ret
end

--将字符串转化为一维数组表
hApi.Split = function(strings,separateType)
	return String2Type(strings, separateType, false)
end


hApi.xlNet_Send = function(uList, msgId, sCmd)
	if xlNet_Send then
		xlNet_Send(uList, msgId, 0, 0, sCmd)
		--local uOut = uList
		--if type(uList) == "table" then
		--	uOut = ""
		--	for i = 1, #uList do
		--		uOut = uOut..(tostring(uList[i]))..";"
		--	end
		--end
		--print("xlNet_Send", uOut, msgId, sCmd)
	end
end

----踢出玩家
----流程：
----1. 调用xlcallback_kickoutevent清理脚本内存及玩家相关的信息
----2. 调用xlNet_KickOut清理程序内存，并发送99号协议，msgid为2，iReason，0
----3. 客户端需要发送close断开链接(由客户端断开链接是因为服务器断开的话，客户端有可能收不到最终的99号协议。客户端close后也不会再走进xlcallback_logevent)
--hApi.xlNet_KickOut = function(udbid)
--	if xlNet_KickOut then
--		if xlcallback_kickoutevent then
--			xlcallback_kickoutevent(udbid, 0)
--		end
--
--		return xlNet_KickOut(udbid, 0)
--	end
--end

--以下接口pvp服务器暂时未提供2016.6.14
----更新奖励日志
--hApi.UpdatePrize = function(prizeId, state)
--	if xlPrize_Update then
--		xlPrize_Update(prizeId,state)
--	end
--end

----插入一条新的奖励日志
--hApi.InsertPrize = function(uid,rid,infoType,info,state)
--	if xlPrize_Insert then
--		local err, prizeId = xlPrize_Insert(uid,rid,infoType,info,state)
--		return err, prizeId
--	end
--end

----增加游戏币(最大20)
--hApi.AddRmb = function(uid, coin)
--	local cost = coin
--	if cost > 20 then
--		cost = 20
--	end
--	if xlPrize_AddCoin then
--		xlPrize_AddCoin(uid,coin)
--	end
--end

----增加宝箱（一次加1个）
--hApi.AddChest = function(uid, rid, itemId, itemNum)
--	-- itemId, 9004-9006宝箱 9300-9320碎片 9999红妆卷轴
--	local num = itemNum or 1
--	if itemId >= 9004 and itemId <= 9006 then
--		--银宝箱一次最多3个（防止x3乱搞）
--		if itemId == 9005 then
--			num = math.min(3, num)
--		--金宝箱一次最多1个（防止x3乱搞）
--		elseif itemId == 9006 then
--			num = math.min(1, num)
--		end
--		if xlPrize_AddVii then
--			xlPrize_AddVii(uid,rid,itemId,num)
--		end
--	end
--end

hApi.Log = function(logLevel, log)
	if xlLog_Log then
		xlLog_Log(logLevel, log)
	end
end

hApi.SetLogLevel = function(logLevel)
	--ELL_DEBUG = 0
	--ELL_INFO = 1
	--ELL_WARNING = 2
	--ELL_ERROR = 3
	--ELL_FATAL = 4
	if xlLog_SetLevel then
		xlLog_SetLevel(logLevel)
	end
end

function hApi.RollDrop(pool)
	local ret 
	if not pool then
		return ret
	end

	local value = math.random(1, pool.totalValue)
	local initialValue = 0
	--遍历，看权重落在哪个区段
	for i = 1, #pool do
		if value > initialValue and value <= initialValue + pool[i].value then
			ret = pool[i].reward
			break
		end
		initialValue = initialValue + pool[i].value
	end
	return ret
end

--函数：获得奖励的字符串描述信息
--返回值: strItemRewardInfo
hApi.GetRewardInfo = function(rewardT)
	local rewardType = tonumber(rewardT[1]) --奖励类型
	local rewardID = tonumber(rewardT[2]) --奖励ID
	local rewardNum = tonumber(rewardT[3]) --奖励数量
	local param4 = rewardT[4] --参数4
	--print(rewardType, rewardID, rewardNum)
	
	local strItemRewardInfo = ""
	
	if (rewardType == 1) then --1:积分
		--XX积分
		--strItemRewardInfo = tostring(rewardID) .. hVar.tab_string["__TEXT_POINT"] .. hVar.tab_string["__TEXT_SCORE"]
		strItemRewardInfo = tostring(rewardID) .. hVar.tab_string["__TEXT_SCORE"]
	elseif (rewardType == 2) then --2:战术技能卡
		--
	elseif (rewardType == 3) then --3:道具
		--1个XX
		strItemRewardInfo = tostring(1) .. hVar.tab_string["__TEXT_COUNT"] .. (hVar.tab_stringI[rewardID] or "item_"..rewardID)
	elseif (rewardType == 4) then --4:英雄
		--
	elseif (rewardType == 5) then --5:英雄将魂
		--XX个XX
		strItemRewardInfo = tostring(rewardNum) .. hVar.tab_string["__TEXT_COUNT"] .. (hVar.tab_stringI[rewardID] or "item_"..rewardID)
	elseif (rewardType == 6) then --6:战术技能卡碎片
		--XX个XX
		strItemRewardInfo = tostring(rewardNum) .. hVar.tab_string["__TEXT_COUNT"] .. (hVar.tab_stringI[rewardID] or "item_"..rewardID)
	elseif (rewardType == 7) then --7:游戏币
		--XX个游戏币
		strItemRewardInfo = tostring(rewardID) .. hVar.tab_string["__TEXT_COUNT"] .. hVar.tab_string["__TEXT_GAMESCORE"]
	elseif (rewardType == 8) then --8:网络宝箱
		--
	elseif (rewardType == 9) then --9:抽奖类战术技能卡
		--
	elseif (rewardType == 10) then --10:神器
		--1个XX
		strItemRewardInfo = tostring(1) .. hVar.tab_string["__TEXT_COUNT"] .. (hVar.tab_stringI[rewardID] or "item_"..rewardID)
	elseif (rewardType == 11) then --11:神器晶石
		--XX个神器晶石
		strItemRewardInfo = tostring(rewardID) .. hVar.tab_string["__TEXT_COUNT"] .. hVar.tab_string["__TEXT_REDEQUIPDEBIRS"]
	elseif (rewardType == 12) then --12:红装兑换券
		--
	elseif (rewardType == 13) then --13:服务器将魂抽卡类
		--
	elseif (rewardType == 14) then --14:英雄经验卡
		--
	elseif (rewardType == 15) then --15:直接开锦囊
		--
	elseif (rewardType == 16) then --16:铁
		--XX个铁
		strItemRewardInfo = tostring(rewardID) .. hVar.tab_string["__TEXT_COUNT"] .. hVar.tab_string["__TEXT_MAT_IRON"]
	elseif (rewardType == 17) then --17:木材
		--XX个木材
		strItemRewardInfo = tostring(rewardID) .. hVar.tab_string["__TEXT_COUNT"] .. hVar.tab_string["__TEXT_MAT_WOOD"]
	elseif (rewardType == 18) then --18:粮食
		--XX个粮食
		strItemRewardInfo = tostring(rewardID) .. hVar.tab_string["__TEXT_COUNT"] .. hVar.tab_string["__TEXT_MAT_FOOD"]
	elseif (rewardType == 20) then --20:军团币
		--XX个军团币
		strItemRewardInfo = tostring(rewardID) .. hVar.tab_string["__TEXT_COUNT"] .. hVar.tab_string["__TEXT_MAT_GROUPCOIN"]
	end
	
	return strItemRewardInfo
end
