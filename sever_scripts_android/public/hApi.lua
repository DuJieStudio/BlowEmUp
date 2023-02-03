--xlLG = function(sFileName,sLog,a,...)
--	local s
--	if a then
--		s = tostring(string.format(sLog,a,...))
--	else
--		s = tostring(sLog)
--	end
--	local f = io.open("log/"..hVar.SYSTEM_DATE..sFileName..".log","a")
--	if f then
--		f:write("["..math.floor(os.clock()*1000).."] "..s.."\n")
--		f:close()
--	else
--		xlout("[print]",s,"\n")
--	end
--end

hApi.Log = function(logLevel, log)
	if xlLog_Log then
		xlLog_Log(logLevel, log)
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
	
	--1970年以前会返回nil
	if (dt1 == nil) then
		dt1 = 0
	end
	
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

hApi.GetLvByPower = function(power)
	local lv = 1
	for i = 1,#hVar.PowerLvList do
		if hVar.PowerLvList[i][1] <= power and hVar.PowerLvList[i][2] > power then
			lv = i
			break
		elseif hVar.PowerLvList[i][1] <= power and hVar.PowerLvList[i][2] == -1 then
			lv = 15
			break
		end
	end
	return lv
end

hApi.UserDlcId2Key = function(mode,id)
	if mode=="PVPArmyCard" then
		--兵种卡片
		return "ac:"..id..";"
	end
end

hApi.DBGetUserDlc = function(nUserId,mode)
	local sQuery = string.format("SELECT dlc FROM t_user WHERE uid = %d",nUserId)
	local err,sMyDlc = xlDb_Query(sQuery)
	if err==0 then
		if mode=="PVPArmyCard" then
			--兵种卡片
			local tMyDlcCard = {}
			local tCardGet = {}
			if type(sMyDlc)=="string" then
				for id in string.gfind(sMyDlc,"ac:([%d]+);")do
					id = tonumber(id)
					tMyDlcCard[#tMyDlcCard+1] = id
					tCardGet[id] = 1
				end
			end
			for i = 1,#hVar.DUEL_FREE_ARMY_CARD do
				local id = hVar.DUEL_FREE_ARMY_CARD[i]
				if tCardGet[id]~=1 and hVar.tab_army[id] then
					tMyDlcCard[#tMyDlcCard+1] = id
				end
			end
			return tMyDlcCard
		end
	end
end

hApi.GetClockByCmd = function(sCmd)
	if type(sCmd)=="string" then
		for h,m,s in string.gfind(sCmd,"([%d]+):([%d]+):([%d]+)")do
			return tonumber(h)*3600+tonumber(m)*60+tonumber(s)
		end
	end
	return -1
end

hApi.IsPVPEnable = function()
	local nOneDaySec = 24*3600
	local nClock = hVar.PVP_LOBBY_START_TICK + math.floor(os.clock())
	for i = 1,#hVar.PVP_ENABLE_TICK do
		local v = hVar.PVP_ENABLE_TICK[i]
		if not(v[3] and v[4]) then
			v[3] = hApi.GetClockByCmd(v[1])
			v[4] = hApi.GetClockByCmd(v[2])
			if v[4]<v[3] then
				v[4] = v[4] + nOneDaySec
			end
		end
		local nStartTick = v[3]
		local nEndTick = v[4]
		local nCurClock = math.mod(nClock,nOneDaySec)
		if nCurClock>=nStartTick and nCurClock<=nEndTick then
			return hVar.RESULT_SUCESS
		elseif nEndTick>=nOneDaySec and nCurClock+nOneDaySec<=nEndTick then
			return hVar.RESULT_SUCESS
		end
	end
	return hVar.RESULT_FAIL
end

hApi.L2CMSG = function(connid,sCmd)
	if type(sCmd)=="string" then
		return xlSendScript2Client(connid,hVar.PVP_DB_RECV_TYPE.L2C_MSG,sCmd)
	end
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
	--print("hApi.xlNet_Send", xlNet_Send, uList, msgId, sCmd)
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

--local __CODE__AddCountForLog = function(tMyLog,tIndex,tTab,nPos)
--	if tTab then
--		for id,v in pairs(tTab)do
--			local n = tIndex[id]
--			if n==nil then
--				n = #tMyLog + 1
--				tIndex[id] = n
--				tMyLog[n] = {id,0,0}
--			end
--			tMyLog[n][nPos] = tMyLog[n][nPos] + v
--		end
--	end
--end

--hApi.AddPlayerQuestLog = function(roleid,tAccept,tComplete)
--	local tMyLog = {}
--	local tIndex = {}
--	local sQuery = string.format("SELECT pvp_quest_log FROM t_pvp WHERE id = %d",roleid)
--	local err,sLog = xlDb_Query(sQuery)
--	if err==0 and type(sLog)=="string" then
--		for id,ac,cp in string.gfind(sLog,"qst:(%d+):(%d+):(%d+);") do
--			local t = {tonumber(id),tonumber(ac),tonumber(cp)}
--			local n = #tMyLog+1
--			tMyLog[n] = t
--			tIndex[t[1]] = n
--		end
--	end
--	__CODE__AddCountForLog(tMyLog,tIndex,tAccept,2)
--	__CODE__AddCountForLog(tMyLog,tIndex,tComplete,3)
--	if #tMyLog>0 then
--		local tTemp = {}
--		for i = 1,#tMyLog do
--			tTemp[#tTemp+1] = "qst:"..tMyLog[i][1]..":"..tMyLog[i][2]..":"..tMyLog[i][3]..";"
--		end
--		local sUpdate = string.format("UPDATE t_pvp set pvp_quest_log = '%s' WHERE id = %d",table.concat(tTemp),roleid)
--		xlDb_Execute(sUpdate)
--	end
--end

--hApi.SavePlayerQuest = function(roleid,tQuest,tAccept,tComplete)
--	local sQuestMy
--	local tTemp = {}
--	for i = 1,#tQuest do
--		local v = tQuest[i]
--		if v~=0 then
--			tTemp[#tTemp+1] = string.format("qst:%d:%d:%d:%d;",v[1],v[2],v[3],v[4])
--		end
--	end
--	--如果有添加或完成任务的列表,将其记录入log中
--	if tAccept or tComplete then
--		hApi.AddPlayerQuestLog(roleid,tAccept,tComplete)
--	end
--	if #tTemp>0 then
--		sQuestMy = table.concat(tTemp)
--		local sUpdate = string.format("UPDATE t_pvp set pvp_quest = '%s' WHERE id = %d",sQuestMy,roleid)
--		xlDb_Execute(sUpdate)
--	else
--		sQuestMy = ""
--		local sUpdate = string.format("UPDATE t_pvp set pvp_quest = NULL WHERE id = %d",roleid)
--		xlDb_Execute(sUpdate)
--	end
--	return sQuestMy
--end


--[[
local __CODE__GetL2CQuestCmd = function(tQuest)
	if #tQuest>0 then
		local tTemp = {}
		for i = 1,#tQuest do
			local id,state,val,param = unpack(tQuest[i])
			local tabQ = hVar.tab_quest[id]
			if tabQ then
				local sIntro = (tabQ.intro or "none")
				local nRewardMode = 0
				if tabQ.intro_type==1 then
					sIntro = string.gsub(sIntro,"#VALUE#",tostring(param))
				end
				tTemp[#tTemp+1] = string.format("qst:%d:%d:%d:{$%s}:{$%d/%d}:{$%s}%s;",id,(tabQ.type or 1),state,(tabQ.name or "none"),val,(tabQ.value or 1),sIntro,hApi.PVPQuestReward2Cmd(tabQ,nRewardMode))
			else
				tTemp[#tTemp+1] = "qst:"..id..":1:0:{$none}:{$0/1}:{$none};"
			end
		end
		return table.concat(tTemp)
	else
		return ""
	end
end

hApi.GetPlayerQuestCmd = function(sQuest)
	if hVar.PVP_REWARD_ENABLE~=1 then
		return ""
	end
	if type(sQuest)=="string" and sQuest~="" then
		local tQuest = __CODE__GetQuestByCmd(sQuest)
		return __CODE__GetL2CQuestCmd(tQuest)
	else
		return ""
	end
end

local __CODE__TryCompleteQuest = function(roleid,tQuest,nIndex,nState)
	local tQuestMy
	local nQuestID
	local tReward
	local tComplete
	if nState==2 then
		if tQuest[nIndex][2]==1 then
			tQuest[nIndex][2] = 2
			tQuestMy = tQuest[nIndex]
			tComplete = tComplete or {}
			local id = tQuest[nIndex][1]
			tComplete[id] = (tComplete[id] or 0)+1
		end
	elseif nState==3 then
		if tQuest[nIndex][2]==2 then
			tQuest[nIndex][2] = 3
			tQuestMy = tQuest[nIndex]
		end
	end
	if tQuestMy~=nil then
		nQuestID = tQuestMy[1]
		hApi.SavePlayerQuest(roleid,tQuest,nil,tComplete)
		local tabQ = hVar.tab_quest[nQuestID]
		if tabQ then
			tReward = tabQ.reward
		end
	end
	return nQuestID,tReward
end

hApi.UpdatePlayerQuest = function(roleid,nIndex,nState)
	local sQuery = string.format("SELECT uid,pvp_quest,pvp_quest_reload,pvp_win,pve_win FROM t_pvp where id = %d",roleid)
	local err,uid,sQuest,nReloadMode,nPVPWin,nPVEWin = xlDb_Query(sQuery)
	if err==0 then
		if type(sQuest)=="string" then
			local tQuest = __CODE__GetQuestByCmd(sQuest)
			if type(nIndex)=="number" then
				if tQuest[nIndex]~=nil then
					if nState==3 then
						local nQuestID,tReward = __CODE__TryCompleteQuest(roleid,tQuest,nIndex,nState)
						return "",nQuestID,tReward
					else
						local nQuestID,tReward = __CODE__TryCompleteQuest(roleid,tQuest,nIndex,nState)
						local sCmd = __CODE__GetL2CQuestCmd(tQuest)
						return sCmd,nQuestID,tReward
					end
				end
			elseif nReloadMode~=0 then
				sQuest = hApi.ReloadPlayerDailyQuest(uid,roleid,nReloadMode)		--尝试请求任务时刷新日常
				tQuest = __CODE__GetQuestByCmd(sQuest)
			end
			local sCmd = __CODE__GetL2CQuestCmd(tQuest)
			return sCmd
		end
	end
	return ""
end

hApi.UpdatePlayerQuestByEvent = function(connid,roleid,tEventName,sMyQuest)
	if type(sMyQuest)~="string" then
		local sQuery = string.format("SELECT pvp_quest,pvp_win,pve_win FROM t_pvp where id = %d",roleid)
		local err,sQuest,nPVPWin,nPVEWin = xlDb_Query(sQuery)
		if err==0 then
			sMyQuest = sQuest
		end
	end
	if type(sMyQuest)=="string" and sMyQuest~="" then
		local tQuest = __CODE__GetQuestByCmd(sMyQuest)
		if #tQuest>0 then
			local tFriendCount
			for i = 1,#tQuest do
				local v = tQuest[i]
				local id = v[1]
				local tabQ = hVar.tab_quest[id]
				if tabQ and tEventName[tabQ.event or 0]==1 and v[2]==0 then
					v[3] = v[3] + 1
					if v[3]>=(tabQ.value or 0) then
						v[2] = 1
						--关联任务计数+1
						if (tabQ.friend or 0)~=0 then
							if tFriendCount==nil then
								tFriendCount = {}
							end
							for n = 1,#tabQ.friend do
								local idf = tabQ.friend[n]
								tFriendCount[idf] = (tFriendCount[idf] or 0) + 1
							end
						end
					end
				end
			end
			--关联任务完成
			if tFriendCount~=nil then
				for i = 1,#tQuest do
					local v = tQuest[i]
					local id = v[1]
					local tabQ = hVar.tab_quest[id]
					if tabQ and (tFriendCount[id] or 0)~=0 and v[2]==0 then
						v[3] = v[3] + tFriendCount[id]
						if v[3]>=(tabQ.value or 0) then
							v[2] = 1
						end
					end
				end
			end
			local sQuestNew = hApi.SavePlayerQuest(roleid,tQuest,nil,nil)
			if connid~=0 then
				local sL2CQuest = hApi.GetPlayerQuestCmd(sQuestNew)
				if sL2CQuest and sL2CQuest~="" then
					xlSendScript2Client(connid,hVar.PVP_DB_RECV_TYPE.L2C_QUEST,sL2CQuest)
				end
			end
		end
	end
end
--]]
------------------------------------------
-- 刷新玩家日常
--hApi.GetDailyQuestIndex = function(tQuestId)
--	local tIndex = {}
--	for i = 1,#tQuestId do
--		local v = tQuestId[i]
--		if type(v)=="table" then
--			for n = 1,#v do
--				tIndex[v[n]] = 1
--			end
--		else
--			tIndex[v] = 1
--		end
--	end
--	return tIndex
--end

--do
--	--刷新赛季任务
--	local _TEMP_SeasonQuest = {}
--	local _TEMP_SeasonQuestDate = 0			--刷新时间
--	local _TEMP_SeasonQuestPermanent = {}		--任务是否不会自动删除的标记
--	--功能函数，将日期转化为数字
--	local _CODE_Date2Num = function(sDate)
--		if type(sDate)~="string" then
--			return 0
--		end
--		local _,_,yy,mm,dd = string.find(sDate,"(%d+)-(%d+)-(%d+)")
--		if yy then
--			return tonumber(yy)*10000+tonumber(mm)*100+tonumber(dd)
--		else
--			return 0
--		end
--	end
--	--标记单个任务
--	local _CODE_MarkQuestOne = function(mode,vQuestItem,IsAddQuest,IsPermanent)
--		local tQuestAdd = _TEMP_SeasonQuest[mode]
--		if type(vQuestItem)=="table" then
--			if IsAddQuest==1 then
--				tQuestAdd[#tQuestAdd+1] = vQuestItem
--			end
--			for n = 1,#vQuestItem do
--				local id = vQuestItem[n]
--				if IsAddQuest==1 then
--					tQuestAdd.idx[id] = 1
--				end
--				if IsPermanent==1 then
--					_TEMP_SeasonQuestPermanent[id] = 1
--				end
--			end
--		else
--			local id = vQuestItem
--			if IsAddQuest==1 then
--				tQuestAdd[#tQuestAdd+1] = vQuestItem
--				tQuestAdd.idx[id] = 1
--			end
--			if IsPermanent==1 then
--				_TEMP_SeasonQuestPermanent[id] = 1
--			end
--		end
--	end
--	--标记列表任务
--	local _CODE_MarkQuestByList = function(mode,tQuest,IsPermanent)
--		for i = 1,#tQuest do
--			_CODE_MarkQuestOne(mode,tQuest[i],1,IsPermanent)
--		end
--	end
--	local _CODE_FormatQuestExtra = function()
--		for i = 1,#hVar.PVP_QUEST_EXTRA do
--			local v = hVar.PVP_QUEST_EXTRA[i]
--			if type(v[3])=="string" then
--				v[3] = _CODE_Date2Num(v[3])
--			end
--			if type(v[4])=="string" then
--				v[4] = _CODE_Date2Num(v[4])
--			end
--			if type(v[5])=="string" then
--				v[5] = _CODE_Date2Num(v[5])
--			end
--		end
--	end
--	hApi.UpdateSeasonQuest = function(IsMustUpdate)
--		if IsMustUpdate~=1 and _TEMP_SeasonQuestDate==hVar.SYSTEM_DATE then
--			return
--		end
--		_TEMP_SeasonQuestDate = hVar.SYSTEM_DATE
--		_TEMP_SeasonQuestPermanent = {}
--		_TEMP_SeasonQuest[1] = {idx={}}		--新赛季任务
--		_TEMP_SeasonQuest[2] = {idx={}}		--每日任务(包含可以接多次的限时任务)
--		_TEMP_SeasonQuest[3] = {idx={}}		--限时任务(仅限1次的限时任务，实际只是用来设置永久性)
--
--		--为不同的刷新模式添加任务
--		_CODE_MarkQuestByList(1,hVar.PVP_QUEST_SEASON,1)
--
--		_CODE_MarkQuestByList(1,hVar.PVP_QUEST_DAILY,0)
--		_CODE_MarkQuestByList(2,hVar.PVP_QUEST_DAILY,0)
--
--		--限时任务(限时任务在持续期间必须设置为永久，不被删除)
--		if #hVar.PVP_QUEST_EXTRA>0 then
--			_CODE_FormatQuestExtra()	--必须格式化限时任务表
--			local nCurDate = _CODE_Date2Num(hVar.SYSTEM_DATE)
--			for i = 1,#hVar.PVP_QUEST_EXTRA do
--				local v = hVar.PVP_QUEST_EXTRA[i]
--				local id,mode,s,e,c = v[1],v[2],v[3],v[4],(v[5] or 0)
--				if nCurDate>=s and nCurDate<=e then
--					if mode==1 then
--						--每天都能接的任务
--						_CODE_MarkQuestOne(1,id,1,1)
--						_CODE_MarkQuestOne(2,id,1,1)
--					else
--						--只能接1次的任务
--						_CODE_MarkQuestOne(3,id,1,1)
--					end
--				elseif c>0 then
--					--如果延迟一段时间后才删除，那么只设置永久性
--					if nCurDate>e and nCurDate<=c then
--						_CODE_MarkQuestOne(3,id,0,1)
--					end
--				end
--			end
--		end
--	end
--
--	--获得当天的赛季任务
--	local _TEMP_TokenSeasonQuest = {idx={}}
--	hApi.GetSeasonQuest = function(mode)
--		if _TEMP_SeasonQuestDate~=hVar.SYSTEM_DATE then
--			hApi.UpdateSeasonQuest()
--		end
--		return _TEMP_SeasonQuest[mode] or _TEMP_TokenSeasonQuest
--	end
--
--
--	local _CODE_AddQuestForPlayer = function(tQuestMy,tAcceptMy,tQuestAdd)
--		for i = 1,#tQuestAdd do
--			local v = tQuestAdd[i]
--			local id
--			if type(v)=="table" then
--				if (v.num or 1)<=1 then
--					local id = v[math.random(1,#v)]
--					tQuestMy[#tQuestMy+1] = _CODE_CreateQuestItem(id)
--					tAcceptMy[id] = (tAcceptMy[id] or 0) + 1
--				else
--					local t = hApi.RandomPerm(#v,v.num)
--					for n = 1,#t do
--						local id = v[t[n]]
--						tQuestMy[#tQuestMy+1] = _CODE_CreateQuestItem(id)
--						tAcceptMy[id] = (tAcceptMy[id] or 0) + 1
--					end
--				end
--			else
--				local id = v
--				tQuestMy[#tQuestMy+1] = _CODE_CreateQuestItem(id)
--				tAcceptMy[id] = (tAcceptMy[id] or 0) + 1
--			end
--		end
--	end
--
--	hApi.ReloadPlayerDailyQuest = function(uid,roleid,nReloadMode)
--		local err,sQuestMy,nQuestDate = xlDb_Query("SELECT pvp_quest,pvp_quest_date FROM t_pvp where id = "..roleid)
--		local nCurDate = _CODE_Date2Num(hVar.SYSTEM_DATE)
--		if err~=0 then
--			sQuestMy = ""
--			nQuestDate = 0
--		end
--		--设置日常任务刷新记录
--		xlDb_Execute("UPDATE t_pvp SET pvp_quest_reload = 0,pvp_quest_date = "..nCurDate.." WHERE id = "..roleid)
--		--计算出需要添加的任务
--		local tQuestAdd = hApi.GetSeasonQuest(nReloadMode)
--		local tQuestExtra = {}
--		local tAcceptMy = {}
--		local tQuestMy = hApi.GetMyQuestByCmd(sQuestMy)
--		--限时任务
--		if #hVar.PVP_QUEST_EXTRA>0 then
--			_CODE_FormatQuestExtra()	--必须格式化限时任务表
--			for i = 1,#hVar.PVP_QUEST_EXTRA do
--				local v = hVar.PVP_QUEST_EXTRA[i]
--				local id,mode,s,e = v[1],v[2],v[3],v[4]
--				if mode~=1 then
--					--只能接一次的任务在这里判断添加
--					--上次刷新任务时间小于限时起始时间，视为没有接过此日常，可以刷新
--					if nQuestDate<s and nCurDate>=s and nCurDate<=e then
--						tQuestExtra[#tQuestExtra+1] = id
--					end
--				else
--					--每天都刷新的任务
--					--已经被整合到tQuestAdd表中，无需特别添加
--				end
--			end
--		end
--		--测试员任务
--		if #hVar.PVP_QUEST_TEST>0 and uid~=0 then
--			local err,state = xlDb_Query("SELECT bTester FROM t_user WHERE uid = "..uid)
--			if err==0 and state==1 then
--				for i = 1,#hVar.PVP_QUEST_TEST do
--					local id = hVar.PVP_QUEST_TEST[i]
--					tQuestExtra[#tQuestExtra+1] = id
--				end
--			end
--		end
--		--移除过期的日常任务
--		if #tQuestMy>0 then
--			for i = 1,#tQuestMy do
--				local id = tQuestMy[i][1]
--				local state = tQuestMy[i][2]
--				local tabQ = hVar.tab_quest[id]
--				local IsPermanent = 0
--				if tabQ==nil then
--					--未知任务不可取消，备查(仅限月底删除)
--				elseif tabQ.permanent==1 then
--					--不会被自动取消的任务(仅限月底删除)
--					IsPermanent = 1
--				elseif tabQ.permanent==2 and state~=3 then
--					--只要未从客户端确认完成就不会自动取消的任务(仅限月底删除)
--					IsPermanent = 1
--				else
--					if state==3 then
--						--移除已经完成,并且得到了客户端确认的任务
--						tQuestMy[i] = 0
--					elseif _TEMP_SeasonQuestPermanent[id]==1 then
--						--标记为永久的任务
--						IsPermanent = 1
--					else
--						--移除其他任务
--						tQuestMy[i] = 0
--					end
--				end
--				if IsPermanent==1 and tQuestAdd.idx[id]==1 then
--					--如果永久任务即将被添加，那么必须删除保证唯一性
--					tQuestMy[i] = 0
--				end
--			end
--		end
--		--添加日常任务
--		if #tQuestAdd>0 then
--			_CODE_AddQuestForPlayer(tQuestMy,tAcceptMy,tQuestAdd)
--		end
--		--添加额外任务
--		if #tQuestExtra>0 then
--			_CODE_AddQuestForPlayer(tQuestMy,tAcceptMy,tQuestExtra)
--		end
--		if #tQuestMy==0 and sQuestMy=="" then
--			--如果没有需要更新的任务
--			return ""
--		else
--			return hApi.SavePlayerQuest(roleid,tQuestMy,tAcceptMy,nil)
--		end
--	end
--
--	local __TEMP__tPlayer = {}
--	local __TEMP__tQuest = {}
--	hApi.AddQuestForPlayer = function(tPlayerId,tQuestAdd)
--		if type(tPlayerId)=="number" then
--			__TEMP__tPlayer[1] = tPlayerId
--			tPlayerId = __TEMP__tPlayer
--		end
--		if type(tQuestAdd)=="number" then
--			__TEMP__tQuest[1] = tQuestAdd
--			tQuestAdd = __TEMP__tQuest
--		end
--		for n = 1,#tPlayerId do
--			local roleid = tPlayerId[n]
--			local sQuery = string.format("SELECT pvp_quest FROM t_pvp where id = %d",roleid)
--			local err,sQuestMy = xlDb_Query(sQuery)
--			if err==0 then
--				local tQuestMy
--				if type(sQuestMy)=="string" and sQuestMy~="" then
--					tQuestMy = __CODE__GetQuestByCmd(sQuestMy)
--				end
--				--为玩家添加任务(注意必须是tabQ.permanent==2的任务，否则过一天会消失的)
--				if tQuestMy==nil then
--					tQuestMy = {}
--				end
--				for i = 1,#tQuestAdd do
--					local v = tQuestAdd[i]
--					local id = v
--					if type(v)=="table" then
--						id = v[math.random(1,#v)]
--					end
--					local t = _CODE_CreateQuestItem(id)
--					tQuestMy[#tQuestMy+1] = t
--					tAccept = tAccept or {}
--					tAccept[id] = (tAccept[id] or 0)+1
--				end
--				hApi.SavePlayerQuest(roleid,tQuestMy,tAccept,nil)
--			end
--		end
--	end
--end
--
--hApi.PVPUpdateRewardTip = function()
--	hVar.PVP_REWARD_LIST = {""}
--	local tTemp = {}
--	for n = 1,#hVar.SEASON_RANK_REWARD_TIP do
--		local sKey,nDayCount = unpack(hVar.SEASON_RANK_REWARD_TIP[n])
--		local tReward = hVar.SEASON_RANK_REWARD[nDayCount]
--		if tReward then
--			for i = 1,#tReward do
--				tTemp[#tTemp+1] = sKey
--				local v = tReward[i]
--				if #v>1 and tReward[i+1]~=nil then
--					if v[1]==1 then
--						tTemp[#tTemp+1] = ":{1st}"
--					elseif v[1]==2 then
--						tTemp[#tTemp+1] = ":{2nd}"
--					elseif v[1]==3 then
--						tTemp[#tTemp+1] = ":{3rd}"
--					else
--						tTemp[#tTemp+1] = ":{"..v[1].."~"..(tReward[i+1][1]-1).."}"
--					end
--					for j = 2,#v do
--						local tabQ = hVar.tab_quest[v[j]]
--						if tabQ and tabQ.reward then
--							for k = 1,#tabQ.reward do
--								tTemp[#tTemp+1] = ":{"..hApi.Key2QueryCmd(tabQ.reward[k]).."}"
--							end
--						end
--					end
--				end
--				tTemp[#tTemp+1] = ";"
--			end
--		end
--	end
--	if #tTemp>0 then
--		hVar.PVP_REWARD_LIST[1] = table.concat(tTemp)
--	end
--end
--
--hVar.PVP_NAME_BY_ID = {}
--hApi.GetPlayerNameByRoleId = function(roleid)
--	if hVar.PVP_NAME_BY_ID[roleid]==nil then
--		local err,pvp_name = xlDb_Query("SELECT nickname FROM t_cha WHERE id = "..roleid)
--		if err==0 then
--			hVar.PVP_NAME_BY_ID[roleid] = pvp_name
--		else
--			hVar.PVP_NAME_BY_ID[roleid] = tostring(roleid)
--		end
--	end
--	return hVar.PVP_NAME_BY_ID[roleid]
--	--return tostring(roleid)
--end
--
--hApi.PVPCountLog = function(tDate)
--	local tQuery = {}
--	for i = 1,#tDate do
--		local sDateF,sDateTo = unpack(tDate[i])
--		local err,tTemp = xlDb_QueryEx("SELECT id,roomid,uid1,uid2,winner FROM pvp_log WHERE log_time>='"..sDateF.." 00:00:00' AND log_time<='"..sDateTo.." 23:59:59' LIMIT 0,999999")
--		if err==0 then
--			for n = 1,#tTemp do
--				if tTemp[n][2]==1 then
--					tQuery[#tQuery+1] = tTemp[n]
--				end
--			end
--		end
--	end
--	local tList = {}
--	local tCount = {}
--	local tWin = {}
--	if #tQuery>0 then
--		local _code_InsertMyLog = function(uid,IsWinner)
--			if uid==0 then
--				return
--			end
--			if tCount[uid]==nil then
--				tList[#tList+1] = uid
--			end
--			tCount[uid] = (tCount[uid] or 0) + 1
--			if IsWinner then
--				tWin[uid] = (tWin[uid] or 0) + 1
--			end
--		end
--		local tTemp = {"---list-------------------------\n"}
--		for i = 1,#tQuery do
--			local id,roomid,uid1,uid2,winner = tQuery[i][1],tQuery[i][2],tQuery[i][3],tQuery[i][4],tQuery[i][5]
--			_code_InsertMyLog(uid1,winner==1)
--			_code_InsertMyLog(uid2,winner==2)
--		end
--		for i = 1,#tList do
--			local uid = tList[i]
--			tTemp[#tTemp+1] = uid..","..(tCount[uid] or 0)..","..(tWin[uid] or 0)..",\n"
--		end
--		xlLG("PVPCountLog",table.concat(tTemp))
--	end
--end
--
--hApi.PVECountLog = function(tDate)
--	local tQuery = {}
--	for i = 1,#tDate do
--		local sDateF,sDateTo = unpack(tDate[i])
--		local err,tTemp = xlDb_QueryEx("SELECT id,roomid,uid1,round FROM pvp_log WHERE log_time>='"..sDateF.." 00:00:00' AND log_time<='"..sDateTo.." 23:59:59' LIMIT 0,999999")
--		if err==0 then
--			for n = 1,#tTemp do
--				if tTemp[n][2]==4 then
--					tQuery[#tQuery+1] = tTemp[n]
--				end
--			end
--		end
--	end
--	local tList = {}
--	local tCount = {}
--	local tRound = {}
--	if #tQuery>0 then
--		local tTemp = {"---err-------------------------\n"}
--		for i = 1,#tQuery do
--			local id,roomid,uid,round = tQuery[i][1],tQuery[i][2],tQuery[i][3],tQuery[i][4]
--			if uid==0 then
--				tTemp[#tTemp+1] = id.."\n"
--			end
--			if tCount[uid]==nil then
--				tList[#tList+1] = uid
--			end
--			tCount[uid] = (tCount[uid] or 0) + 1
--			tRound[uid] = math.max(tRound[uid] or 0,round)
--		end
--		tTemp[#tTemp+1] = "---player r0-------------------------\n"
--		for i = 1,#tList do
--			local uid = tList[i]
--			if tRound[uid]<3 then
--				tTemp[#tTemp+1] = uid.."\n"
--			end
--		end
--		tTemp[#tTemp+1] = "\n\n"
--		tTemp[#tTemp+1] = "---player r3-------------------------\n"
--		for i = 1,#tList do
--			local uid = tList[i]
--			if tRound[uid]>=3 then
--				tTemp[#tTemp+1] = uid.."\n"
--			end
--		end
--		xlLG("PVECountLog",table.concat(tTemp))
--	end
--end


--zhenkira quest new
do
	----------------------
	--local function
	----------------------

	--生成任务对象
	local _CODE_CreateQuestItem = function(id)
		local tQuestItem = {id,0,0,0}
		local tabS = hVar.tab_quest[id]

		return tQuestItem
	end
	
	--任务cmd转化为表
	local __CODE__GetQuestByCmd = function(sQuest)
		local tQuest = {}
		for id,state,val,ex in string.gfind(sQuest,"qst:(%d+):(%d+):(%d+):(.-);")do	--id,state,num,ex
			tQuest[#tQuest+1] = {tonumber(id),tonumber(state),tonumber(val),ex}
		end
		return tQuest
	end
	
	----------------------
	--public function
	----------------------
	
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

	--获取我的日常任务，如果还未领取任务或者任务过期，会自动生成新任务
	hApi.GetMyDailyQuest = function(uid, roleId, stageSchedule)
		--查询成功标记
		local queryFlag = false
		
		--任务查询语句
		local sQuery = string.format("SELECT uid,dq,dq_time FROM t_quest where id = %d",roleId)
		local err,nUid,sQuest,sQuestTime = xlDb_Query(sQuery)
		--查找成功
		if err == 0 then
			queryFlag = true
		--查找失败，无记录
		elseif err == 4 then
			local sInsert = string.format("INSERT INTO t_quest (id,uid) VALUES (%d, %d)", roleId, uid)
			--数据插入成功
			if xlDb_Execute(sInsert)==0 then
				queryFlag = true
				nUid = uid
				sQuest = ""
				sQuestTime = ""
			end
		else
			return queryFlag
		end
		
		--如果数据查询成功
		local sTimeStamp
		local tQuestMy
		if queryFlag then
			--获取当前时间
			sQuery = "SELECT NOW()"
			local _,sCurTime = xlDb_Query(sQuery)
			local nCurTime = hApi.Date2Num(sCurTime)
			local nQuestTime = hApi.Date2Num(sQuestTime)
			tQuestMy = {}
			--当前时间大于接收任务的时间，需要刷新任务
			if nCurTime > 0 and (nCurTime - nQuestTime >= 1) then
				--生成新的日常任务
				tQuestMy =hApi.GenerateDailyQuest(roleId,stageSchedule)
				--保存当前任务状态
				hApi.SavePlayerQuest(roleId,tQuestMy,sCurTime)
				local _,_,yy,mm,dd = string.find(sCurTime,"(%d+)-(%d+)-(%d+)")
				if yy then
					sTimeStamp = yy.."-"..mm.."-"..dd
				else
					sTimeStamp = sCurTime
				end
			elseif nCurTime == 0 then
				queryFlag = false
				local info = "[require_quest] curTime is invalid"
				xlLG(3, info)
				return queryFlag
			else
				tQuestMy = hApi.GetMyQuestByCmd(sQuest)
				sTimeStamp = sQuestTime
			end
		end

		return queryFlag, sTimeStamp, tQuestMy
	end

	--获取我的日常任务，如果还未领取任务或者任务过期，会自动生成新任务
	hApi.GetMyDailyQuest_Test = function(uid, roleId, stageSchedule)
		--查询成功标记
		local queryFlag = false
		
		--任务查询语句
		local sQuery = string.format("SELECT uid,dq,dq_time FROM t_quest where id = %d",roleId)
		local err,nUid,sQuest,sQuestTime = xlDb_Query(sQuery)
		--查找成功
		if err == 0 then
			queryFlag = true
		--查找失败，无记录
		elseif err == 4 then
			local sInsert = string.format("INSERT INTO t_quest (id,uid) VALUES (%d, %d)", roleId, uid)
			--数据插入成功
			if xlDb_Execute(sInsert)==0 then
				queryFlag = true
				nUid = uid
				sQuest = ""
				sQuestTime = ""
			end
		else
			return queryFlag
		end
		
		--如果数据查询成功
		local sTimeStamp
		local tQuestMy
		if queryFlag then
			--获取当前时间
			sQuery = "SELECT NOW()"
			local _,sCurTime = xlDb_Query(sQuery)
			local nCurTime = hApi.Date2Num(sCurTime)
			local nQuestTime = hApi.Date2Num(sQuestTime)
			tQuestMy = {}
			--当前时间大于接收任务的时间，需要刷新任务
			--if nCurTime > 0 and (nCurTime - nQuestTime >= 1) then
				--生成新的日常任务
				tQuestMy =hApi.GenerateDailyQuest(roleId,stageSchedule)
				--保存当前任务状态
				hApi.SavePlayerQuest(roleId,tQuestMy,sCurTime)
				local _,_,yy,mm,dd = string.find(sCurTime,"(%d+)-(%d+)-(%d+)")
				if yy then
					sTimeStamp = yy.."-"..mm.."-"..dd
				else
					sTimeStamp = sCurTime
				end
			--elseif nCurTime == 0 then
			--	queryFlag = false
			--	local info = "[require_quest] curTime is invalid"
			--	xlLG(Type_Def_Log.ELL_ERROR, info)
			--	return queryFlag
			--else
			--	tQuestMy = hApi.GetMyQuestByCmd(sQuest)
			--	sTimeStamp = sQuestTime
			--end
		end

		return queryFlag, sTimeStamp, tQuestMy
	end
	
	--随机生成每日任务
	hApi.GenerateDailyQuest = function(roleId,stageSchedule)
		--old ver
		--local pool = {}
		--local tQuestMy = {}
		--for i = 1, #hVar.QUEST_DAILY_POOL do
		--	pool[i] = hVar.QUEST_DAILY_POOL[i]
		--end
		--for n = 1, hVar.QUEST_DAILY_NUM do
		--	if #pool > 0 then
		--		local rIdx = math.random(1, #pool)
		--		local id = pool[rIdx]
		--		tQuestMy[#tQuestMy+1] = _CODE_CreateQuestItem(id)
		--		table.remove(pool, rIdx)
		--	end
		--end
		--return tQuestMy

		--new ver
		local questPool = hVar.QUEST_DAILY_POOL
		if hVar.QUEST_DAILY_POOL_EX and hVar.DELT_TIME and hVar.DELT_TIME ~= -1 then
			local localTime = os.time() --客户端时间 12:00
			local dbTime = localTime - hVar.DELT_TIME
			local exPool = hVar.QUEST_DAILY_POOL_EX

			if exPool.beginTime and exPool.endTime and exPool.beginTime < exPool.endTime then
				local beginTime = hApi.GetNewDate(exPool.beginTime)
				local endTime = hApi.GetNewDate(exPool.endTime)

				--如果当前时间大于检测时间，则需要进行检测
				if dbTime >= beginTime and dbTime <= endTime then
					questPool = exPool
				end
			end
		end
		
		--排除异己
		local tmpQuestPool = {}
		for i = 1, #questPool do
			tmpQuestPool[i] = {}
			for j = 1, #questPool[i] do
				local questId = questPool[i][j] or 0
				if hVar.tab_quest[questId] then
					local start_level = hVar.tab_quest[questId].start_level or -1
					if (start_level == -1) or ((stageSchedule or 0) >= start_level) then
						tmpQuestPool[i][#tmpQuestPool[i] + 1] = questPool[i][j]
					end
				end
			end
		end

		local tQuestMy = {}
		for i = 1, hVar.QUEST_DAILY_NUM do
			local pool = tmpQuestPool[i]
			if #pool > 0 then
				--自制随机算法
				--local rIdx = math.mod(os.time(),(#pool)) + 1
				local rIdx = math.random(1, (#pool))
				local id = pool[rIdx]
				tQuestMy[#tQuestMy+1] = _CODE_CreateQuestItem(id)
			end
		end
		return tQuestMy
	end
	
	--保存任务数据
	hApi.SavePlayerQuest = function(roleId,tQuest,sCurTime)
		local sQuestMy
		local tTemp = {}
		for i = 1,#tQuest do
			local v = tQuest[i]
			if v~=0 then
				tTemp[#tTemp+1] = string.format("qst:%d:%d:%d:%d;",v[1],v[2],v[3],v[4])
			end
		end
		if #tTemp>0 then
			sQuestMy = table.concat(tTemp)
			if sCurTime and type(sCurTime) == "string" then
				local sUpdate = string.format("UPDATE t_quest set dq = '%s', dq_time = '%s' WHERE id = %d",sQuestMy,sCurTime,roleId)
				xlDb_Execute(sUpdate)
			else
				local sUpdate = string.format("UPDATE t_quest set dq = '%s' WHERE id = %d",sQuestMy,roleId)
				xlDb_Execute(sUpdate)
			end
		else
			sQuestMy = ""
			local sUpdate = string.format("UPDATE t_quest set dq = NULL, dq_time = NULL WHERE id = %d",roleId)
			xlDb_Execute(sUpdate)
		end
		return sQuestMy
	end

	--获得我的任务表格
	hApi.GetMyQuestByCmd = function(sQuestMy)
		local tQuestMy
		if type(sQuestMy)=="string" and sQuestMy~="" then
			tQuestMy = __CODE__GetQuestByCmd(sQuestMy)
		end
		if tQuestMy==nil then
			tQuestMy = {}
		end
		return tQuestMy
	end

	--获得更新客户端的Cmd协议
	hApi.GetL2CQuestCmd = function(tQuest)
		--print("hApi.GetL2CQuestCmd1",tQuest)
		if tQuest and #tQuest>0 then
			--print("hApi.GetL2CQuestCmd2")
			local tTemp = {}
			for i = 1,#tQuest do
				local id,state,val,param = tQuest[i][1], tQuest[i][2], tQuest[i][3], tQuest[i][4]
				local tabQ = hVar.tab_quest[id]
				--print("hApi.GetL2CQuestCmd3",id,state,val,param)
				if tabQ then
					--print("hApi.GetL2CQuestCmd4")
					local sName = (hVar.tab_stringQ[id][1] or ("quest:".. tostring(id)))
					local sIntro = (hVar.tab_stringQ[id][2] or "none")
					local conditions = tabQ.conditions
					local condition = "none"
					local val1 = 1
					local val2 = 1
					
					--print("hApi.GetL2CQuestCmd5_xxxxxxx")
					if conditions then
						--print("hApi.GetL2CQuestCmd51")
						--目前只支持一个条件，所以遍历一次直接break
						for k, v in pairs(conditions) do
							--print("hApi.GetL2CQuestCmd52")
							if k == hVar.MEDAL_TYPE.map or k == hVar.MEDAL_TYPE.mapCondition or k == hVar.MEDAL_TYPE.chapterCondition then
								--print("hApi.GetL2CQuestCmd53")
								condition = k or "none"
								val1 = v or 0          
								val2 = 0
								--print("hApi.GetL2CQuestCmd54")
							elseif k == hVar.MEDAL_TYPE.killUT or k == hVar.MEDAL_TYPE.killUS or k == hVar.MEDAL_TYPE.buyItem then
								--print("hApi.GetL2CQuestCmd55")
								condition = k or "none"
								val1 = v[1] or 0          
								val2 = v[2] or 0
								--print("hApi.GetL2CQuestCmd56")
							elseif k == hVar.MEDAL_TYPE.buildTT then
								condition = k or "none"
								val1 = v[1] or "none"          
								val2 = v[2] or 0
							else
								--print("hApi.GetL2CQuestCmd57")
								condition = k or "none"
								val1 = v or 1          
								val2 = 0
								--print("hApi.GetL2CQuestCmd58")
							end
							break
						end 
					end
					--print("hApi.GetL2CQuestCmd6")
					
					--print("hApi.GetL2CQuestCmd:id:",id)
					--print("hApi.GetL2CQuestCmd:state:",state)
					--print("hApi.GetL2CQuestCmd:val:",val)
					--print("hApi.GetL2CQuestCmd:param:",param)
					--print("hApi.GetL2CQuestCmd:sName:",sName)
					--print("hApi.GetL2CQuestCmd:sIntro:",sIntro)
					--print("hApi.GetL2CQuestCmd:condition:",condition)
					--print("hApi.GetL2CQuestCmd:val1:",val1)
					--print("hApi.GetL2CQuestCmd:val2:",val2)
					
					if condition == hVar.MEDAL_TYPE.map or condition == hVar.MEDAL_TYPE.mapCondition or condition == hVar.MEDAL_TYPE.chapterCondition then
						tTemp[#tTemp+1] = string.format("qst:%d:%d:%d:%d:{$%s}:{$%s}:{$%s}:{$%s}:%d%s;",id,state,val,param,(sName),(sIntro),condition,val1,val2,hApi.DailyQuestReward2Cmd(tabQ))
					elseif condition == hVar.MEDAL_TYPE.buildTT then
						tTemp[#tTemp+1] = string.format("qst:%d:%d:%d:%d:{$%s}:{$%s}:{$%s}:{$%s}:%d%s;",id,state,val,param,(sName),(sIntro),condition,val1,val2,hApi.DailyQuestReward2Cmd(tabQ))
					else
						tTemp[#tTemp+1] = string.format("qst:%d:%d:%d:%d:{$%s}:{$%s}:{$%s}:%d:%d%s;",id,state,val,param,(sName),(sIntro),condition,val1,val2,hApi.DailyQuestReward2Cmd(tabQ))
					end
					--print("hApi.GetL2CQuestCmd5")
				else
					tTemp[#tTemp+1] = "qst:"..id..":1:0:0{$none}:{$none}:{$none/1/1};"
					--print("hApi.GetL2CQuestCmd6")
				end
			end
			--print("hApi.GetL2CQuestCmd7")
			return table.concat(tTemp)
		else
			--print("hApi.GetL2CQuestCmd3")
			return ""
		end
	end
	
	--[[
	--初始化战术技能卡信息
	function hApi.InitTacticInfo(tacticInfo)
		local tTacticInfo = hApi.Split(tacticInfo, ";")
		local tacticNum = tonumber(tTacticInfo[1]) or 0
		local infoIdx = 1
		
		local tacticDic = {}
		
		--遍历所有战术卡
		for i = 1, tacticNum do
			local tacticList = tTacticInfo[infoIdx + i] or ""
			local tTacticList = hApi.Split(tacticList,":")
			local id = tonumber(tTacticList[1]) or 0
			local num = tonumber(tTacticList[2]) or 0
			local totalNum = tonumber(tTacticList[3]) or 0
			local lv = tonumber(tTacticList[4]) or 0
			local addonsNum = tonumber(tTacticList[5]) or 0
			local addons = {}
			local addonsIdx = 5
			for n = 1, addonsNum do
				addons[n] = tTacticList[addonsIdx + n]
			end
			
			if id > 0 then
				tacticDic[id] = hClass.Tactic:create():Init(id, lv, num, totalNum,addonsNum, addons)
			end
		end

		local default_tactics = {1301,1302,1303}	--新玩家默认兵种卡

		--检测玩家有没默认卡组，没有的话要送
		for i = 1, #default_tactics do
			local id = default_tactics[i]
			local tactic = tacticDic[id]
			if not tactic then
				tacticDic[id] = hClass.Tactic:create():Init(id, 1, 0, 0)
			else
				local lv = tactic:GetLv()
				local debris = tactic:GetDebris()
				if lv == 0 and debris > 0 then
					tacticDic[id] = nil
					tacticDic[id] = hClass.Tactic:create():Init(id, 1, 0, 0)
				end
			end
		end

		return tacticDic
	end
	]]
	
	--[[
	--添加战术卡碎片
	function hApi.AddTactic(tacticDic,id,num)
		local ret = false
		if id > 0 and num > 0 then
			local tactic = tacticDic[id]
			if tactic then
				tactic:AddDebris(num)
				ret = true
			else
				tacticDic[id] = hClass.Tactic:create():Init(id, 0, num, num)
				ret = true
			end
		end
		
		return ret
	end
	]]
	
	--[[
	--战术技能卡信息 toCmd
	function hApi.TacticInfoToCmd(tacticDic)
		local cmd = ""
		local tacticNum = 0
		
		--for id, num in pairs(self._tacticDic) do
		--	cmd = cmd .. id .. ":" .. num .. ";"
		--	tacticNum = tacticNum + 1
		--end
		for id, tactic in pairs(tacticDic) do
			cmd = cmd .. (tactic:InfoToCmd())
			tacticNum = tacticNum + 1
		end
		
		cmd = (tacticNum) .. ";" .. cmd
		return cmd
	end
	]]
	
	--初始化英雄信息
	function hApi.InitHeroInfo(heroInfo)
		local tHeroInfo = hApi.Split(heroInfo, ";")
		local heroNum = tonumber(tHeroInfo[1]) or 0
		local infoIdx = 1
		local heroDic = {}
		
		--遍历所有英雄
		for i = 1, heroNum do
			local heroList = tHeroInfo[infoIdx + i] or ""
			local tHeroList = hApi.Split(heroList,":")
			local id = tonumber(tHeroList[1]) or 0
			local star = tonumber(tHeroList[2]) or 1
			local num = tonumber(tHeroList[3]) or 0
			local totalNum = tonumber(tHeroList[4]) or 0
			
			if id > 0 and totalNum > 0 then
				heroDic[id] = hClass.Hero:create():Init(id, star, num, totalNum)
			end
		end

		return heroDic
	end

	--增加英雄
	function hApi.AddNewHero(heroDic,id,star)
		local ret = false
		if id > 0 then
			local hero = heroDic[id]
			if hero then
				hero:SetStar(star)
			else
				local totalSoulStone = 1
				if hVar.tab_hero[id] and hVar.tab_hero[id].starInfo and hVar.tab_hero[id].starInfo[star] then
					totalSoulStone = hVar.tab_hero[id].starInfo[star].toSoulStone
				end
				heroDic[id] = hClass.Hero:create():Init(id, (star or 1), 0, totalSoulStone)
				ret = true
			end
		end
		return ret
	end

	--增加英雄将魂碎片
	function hApi.AddHeroSoulstone(heroDic,id,num)
		--print("_AddHeroSoulstone:",heroDic,id,num)
		local ret = false
		if id > 0 and num > 0 then
			local hero = heroDic[id]
			--print("看看哪里出的问题:",hero)
			if hero then
				hero:AddSoulstone(num)
				ret = true
			else
				local star = 1
				local tabH = hVar.tab_hero[id]
				if tabH and tabH.unlock and tabH.unlock.arenaUnlock then
					star = 0
				end
				heroDic[id] = hClass.Hero:create():Init(id, star, num, num)
				ret = true
			end
		end
		return ret
	end

	--英雄将魂信息 toCmd
	function hApi.HeroInfoToCmd(heroDic)
		local cmd = ""
		local heroNum = 0
		
		for id, hero in pairs(heroDic) do
			cmd = cmd .. (hero:InfoToCmd())
			heroNum = heroNum + 1
		end

		cmd = (heroNum) .. ";" .. cmd
		return cmd
	end
	
	--服务器奖励预处理
	hApi.RewardPreprocessing = function(uid, rid, reward, rewardLength, create_id)
		--print("服务器奖励预处理 RewardPreprocessing", uid, rid, reward, rewardLength, create_id)
		local rewardNew = nil --是否替换为新的奖励表
		
		--服务器处理宝箱数据
		local tReward = reward:GetInfo()
		local rewardLength = rewardLength or reward:GetNum()
		
		local heroDic = {}
		local tacticDic = {}
		
		--先预处理下，看看需不需要操作数据库
		local dbQuery = false
		for i = 1, rewardLength, 1 do
			local rewardT = tReward[i]
			if rewardT then
				local rewardType = tonumber(rewardT[1] or 0) --获取类型
				if (rewardType == 5) or (rewardType == 6) or (rewardType == 4) then --5:英雄将魂
					dbQuery = true
					break
				end
			end
		end
		
		--先取出需要操作的数据
		if dbQuery then
			local sql = string.format("SELECT pu.uid,pu.tacticInfo,pu.heroInfo FROM t_pvp_user as pu where pu.id=%d",rid)
			local err,uuid,tacticInfo,heroInfo = xlDb_Query(sql)
			if err == 0 then
				
				--战术技能卡初始化
				--tacticDic = hApi.InitTacticInfo(tacticInfo)
				tacticDic = hClass.TacticMgr:create():Init(tacticInfo)
				
				--英雄将魂初始化
				heroDic = hApi.InitHeroInfo(heroInfo)
				
			elseif err == 4 then
				local sql1= string.format("SELECT c.name FROM t_cha AS c WHERE c.id=%d",rid)
				local err1, name= xlDb_Query(sql1)
				if err1 then
					local sql2 = string.format("INSERT INTO t_pvp_user (id,uid,`name`) values (%d,%d,'%s')",rid,uid,tostring(name))
					local err2 = xlDb_Execute(sql2)
					if err2 == 0 then
					end
				end
				
			end
		end
		
		--只奖励前n个东西
		for i = 1, rewardLength, 1 do
			local rewardT = tReward[i]
			if rewardT then
				local rewardType = tonumber(rewardT[1] or 0) --获取类型
				
				--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片)
				if (rewardType == 1) then --1:积分
					
				elseif (rewardType == 2) then --2:战术技能卡
					
				elseif (rewardType == 3) then --3:道具
					
				elseif (rewardType == 4) then --4:英雄
					local heroId = tonumber(rewardT[2]) or 0
					local star = tonumber(rewardT[3]) or 1
					local lv = tonumber(rewardT[4]) or 1
					
					hApi.AddNewHero(heroDic,heroId,star)
					
				elseif (rewardType == 5) then --5:英雄将魂
					local itemId = tonumber(rewardT[2]) or 0
					local itemNum = tonumber(rewardT[3]) or 1
					
					if itemId > 0 and hVar.tab_item[itemId] and itemNum > 0 then
						local heroId = hVar.tab_item[itemId].heroID or 0
						if heroId > 0 then
							--添加英雄将魂
							hApi.AddHeroSoulstone(heroDic, heroId, itemNum)
						end
					end
					
				elseif (rewardType == 6) then --6:战术技能卡碎片
					local itemId = tonumber(rewardT[2]) or 0
					local itemNum = tonumber(rewardT[3]) or 1
					if itemId > 0 and hVar.tab_item[itemId] and itemNum > 0 then
						local tacticId = hVar.tab_item[itemId].tacticID or 0
						if tacticId > 0 then
							--hApi.AddTactic(tacticDic, tacticId, itemNum)
							tacticDic:AddTacticDebris(tacticId, itemNum)
						end
					end
				elseif (rewardType == 7) then --7:游戏币
					local rmb = tonumber(rewardT[2]) or 0
					if rmb > 0 then
						hGlobal.userCoinMgr:DBAddGamecoin(uid, rmb)
					end
				elseif (rewardType == 8) then --8:网络宝箱
					local itemId = tonumber(rewardT[2]) or 0
					local itemNum = tonumber(rewardT[3]) or 1
					if itemId and itemId >= 9004 and itemId <= 9006 and itemNum > 0 then
						--铜9004,银9005,金9006
						hGlobal.userCoinMgr:DBAddChest(uid,rid,itemId,itemNum)
					end
				elseif (rewardType == 9) then --9:抽奖类战术技能卡
					--
				elseif (rewardType == 10) then --10:神装
					--暂不支持
					local itemId = tonumber(rewardT[2]) or 0
					local slotNum = tonumber(rewardT[3]) or -1
					local quality = tonumber(rewardT[4]) or 0 --品质
					--local redequipMgr = hClass.RedEquipMgr:create():Init(uid, rid)
					local redequipMgr = hGlobal.redEquipUserCacheMgr:GetRedEquipMgr(uid, rid)
					if redequipMgr then
						local equip = redequipMgr:DBAddEquip(itemId,slotNum,quality)
						reward:SetEntity(i, equip)
						--print("reward:",tostring(reward))
					end
				elseif (rewardType == 11) then --11:神装晶石
					local crystal = tonumber(rewardT[2]) or 0
					if crystal > 0 then
						hGlobal.userCoinMgr:DBAddCrystal(uid, crystal)
					end
				elseif (rewardType == 12) then --12:红装卷轴
					local redScroll = tonumber(rewardT[2]) or 0
					if redScroll > 0 then
						hGlobal.userCoinMgr:DBAddRedScroll(uid, redScroll)
					end
				elseif (rewardType == 13) then --13: 服务器将魂抽卡类型的奖励
					--此类型的奖励在 hApi.GetRewardInPrize_DrawCard 接口里处理，这里不做处理
				elseif (rewardType == 14) then --14:英雄经验
					--
				elseif (rewardType == 15) then --15:幸运神器锦囊
					--生成本次神器锦囊的结果
					local itemId = tonumber(rewardT[2]) or 0
					local chest = hClass.Chest:create():Init(itemId,0)	--红装锦囊
					--print("chest reault itemId=", itemId,chest)
					if chest and (type(chest) == "table") and (chest:getCName() == "Chest") then
						local mustRed = true
						local reward = chest:Open(mustRed)
						--print("reward=", reward)
						if reward then
							reward:TakeReward(uid, rid)
							rewardNew = reward
						end
					end
				elseif (rewardType == 16) then --16:铁 --geyachao: 新加房间的配置项 军团
					--军团发奖
					local itemNum = tonumber(rewardT[2]) or 0
					local groupReward = hClass.GroupReward:create("GroupReward"):Init(uid, rid)
					groupReward:TakeReward(rewardType, itemNum, create_id)
				elseif (rewardType == 17) then --17:木材 --geyachao: 新加房间的配置项 军团
					--军团发奖
					local itemNum = tonumber(rewardT[2]) or 0
					local groupReward = hClass.GroupReward:create("GroupReward"):Init(uid, rid)
					groupReward:TakeReward(rewardType, itemNum, create_id)
				elseif (rewardType == 18) then --18:粮食 --geyachao: 新加房间的配置项 军团
					--军团发奖
					local itemNum = tonumber(rewardT[2]) or 0
					local groupReward = hClass.GroupReward:create("GroupReward"):Init(uid, rid)
					groupReward:TakeReward(rewardType, itemNum, create_id)
				elseif (rewardType == 20) then --20:军团币 --geyachao: 新加房间的配置项 军团
					--军团发奖
					local itemNum = tonumber(rewardT[2]) or 0
					local groupReward = hClass.GroupReward:create("GroupReward"):Init(uid, rid)
					groupReward:TakeReward(rewardType, itemNum, create_id)
				elseif (rewardType == 21) then --21:强化免费券
					--
				elseif (rewardType == 22) then --22:宝物碎片
					local itemId = tonumber(rewardT[2]) or 0
					local itemNum = tonumber(rewardT[3]) or 1
					local treasureReward = hClass.TreasureReward:create("TreasureReward"):Init(uid, rid)
					treasureReward:TakeReward(rewardType, itemId, itemNum)
				elseif (rewardType == 23) then --23:藏宝图
					local cangbaotu = tonumber(rewardT[2]) or 0
					if cangbaotu > 0 then
						hGlobal.userCoinMgr:DBAddCangBaoTu(uid, cangbaotu)
					end
				elseif (rewardType == 24) then --24:高级藏宝图
					local cangbaotu_high = tonumber(rewardT[2]) or 0
					if cangbaotu_high > 0 then
						hGlobal.userCoinMgr:DBAddCangBaoTuHigh(uid, cangbaotu_high)
					end
				elseif (rewardType == 25) then --25:兵符
					local pvpcoin = tonumber(rewardT[2]) or 0
					if pvpcoin > 0 then
						hGlobal.userCoinMgr:DBAddPvpCoin(uid, pvpcoin)
					end
				elseif (rewardType == 26) then --26:抽奖免费券
					local activityId = tonumber(rewardT[2]) or 0
					local ticketNum = tonumber(rewardT[3]) or 0
					hGlobal.userCoinMgr:DBAddChouJiangFreeTicket(uid, rid, activityId, ticketNum)
				elseif (rewardType == 27) then --27:战功积分
					local zhangong_score = tonumber(rewardT[2]) or 0
					if zhangong_score > 0 then
						hGlobal.userCoinMgr:DBAddZhanGongScore(uid, rid, zhangong_score)
					end
				elseif (rewardType == 28) then --28:成就点
					--
				elseif (rewardType == 29) then --29:爱鲲积分
					--
				elseif (rewardType == 100) then --100:任务之石
					local stone = tonumber(rewardT[2]) or 0
					if (stone > 0) then
						hGlobal.userCoinMgr:DBAddTaskStone(uid, stone)
					end
				elseif (rewardType == 101) then --101:武器枪碎片
					local itemId = tonumber(rewardT[2]) or 0
					local debrisNum = tonumber(rewardT[3]) or 0
					local tabI = hVar.tab_item[itemId] or {}
					local weaponId = tabI.weaponId or 0
					local tankWeapon = hClass.TankWeapon:create():Init(uid,rid)
					tankWeapon:AddDebris(weaponId, debrisNum)
				elseif (rewardType == 103) then --103:宠物碎片
					local itemId = tonumber(rewardT[2]) or 0
					local debrisNum = tonumber(rewardT[3]) or 0
					local tabI = hVar.tab_item[itemId] or {}
					local petId = tabI.petId or 0
					local tankPet = hClass.TankPet:create():Init(uid,rid)
					tankPet:AddDebris(petId, debrisNum)
				elseif (rewardType == 105) then --105:武器枪宝箱
					local debrsNum = tonumber(rewardT[2]) or 0
					if (debrsNum > 0) then
						hGlobal.userCoinMgr:DBAddWeaponChest(uid, debrsNum)
					end
				elseif (rewardType == 106) then --106:战术卡宝箱
					local debrsNum = tonumber(rewardT[2]) or 0
					if (debrsNum > 0) then
						hGlobal.userCoinMgr:DBAddTacticChest(uid, debrsNum)
					end
				elseif (rewardType == 107) then --107:宠物宝箱
					local debrsNum = tonumber(rewardT[2]) or 0
					if (debrsNum > 0) then
						hGlobal.userCoinMgr:DBAddPetChest(uid, debrsNum)
					end
				elseif (rewardType == 108) then --108:装备宝箱
					local debrsNum = tonumber(rewardT[2]) or 0
					if (debrsNum > 0) then
						hGlobal.userCoinMgr:DBAddEquipChest(uid, debrsNum)
					end
				elseif (rewardType == 109) then --109:科学家宝箱
					--
				elseif (rewardType == 110) then --110:科学家成就1
					--
				elseif (rewardType == 111) then --111:科学家成就2
					--
				elseif (rewardType == 112) then --112:科学家成就3
					--
				elseif (rewardType == 113) then --113:科学家成就4
					--
				elseif (rewardType == 114) then --114:地鼠币
					--增加地鼠币
					local coin = tonumber(rewardT[2]) or 0
					hGlobal.userCoinMgr:DBAddDiShuCoin(uid, coin)
				elseif (rewardType == 115) then --115:垃圾堆成就1
					--
				elseif (rewardType == 116) then --116:垃圾堆成就2
					--
				elseif (rewardType == 117) then --117:垃圾堆成就3
					--
				elseif (rewardType == 118) then --118:垃圾堆成就4
					--
				elseif (rewardType == 119) then --119:垃圾堆成就5
					--
				elseif (rewardType == 120) then --120:天赋点
					--增加战车天赋点数
					local talent = tonumber(rewardT[2]) or 0
					hGlobal.userCoinMgr:DBAddTankTalentPoint(uid, rid, talent)
				end
			end
		end
		
		--存储操作后的数据
		if dbQuery then
			local saveInfo = ""
			--saveInfo = string.format("tacticInfo='%s',heroInfo='%s'",hApi.TacticInfoToCmd(tacticDic),hApi.HeroInfoToCmd(heroDic))
			saveInfo = string.format("tacticInfo='%s',heroInfo='%s'",tacticDic:InfoToCmd(),hApi.HeroInfoToCmd(heroDic))
			local sql = string.format("UPDATE t_pvp_user SET " .. saveInfo .. " WHERE id=%d",rid)
			local err = xlDb_Execute(sql)
			--print("sql:",sql, err)
		end
		
		return rewardNew
	end
	
	--任务奖励转化为Cmd
	hApi.DailyQuestReward2Cmd = function(tQuest)
		if type(tQuest.reward)=="table" then
			local tTemp = {}
			for i = 1,hVar.QUEST_DAILY_REWARD_NUM do
				local v = tQuest.reward[i] or {}
				tTemp[#tTemp+1] = ":{"..(v[1] or 0)..","..(v[2] or 0)..","..(v[3] or 0)..","..(v[4] or 0).."}"
			end
			if #tTemp>0 then
				return table.concat(tTemp)
			end
		end
		return ""
	end
	
	--任务奖励转化为Log
	hApi.DailyQuestReward2Log = function(tQuest)
		if type(tQuest.reward)=="table" then
			local tTemp = {}
			for i = 1,hVar.QUEST_DAILY_REWARD_NUM do
				local v = tQuest.reward[i] or {}
				tTemp[#tTemp+1] = (v[1] or 0)..":"..(v[2] or 0)..":"..(v[3] or 0)..":"..(v[4] or 0)..";"
			end
			if #tTemp>0 then
				return table.concat(tTemp)
			end
		end
		return ""
	end
end



function xlPrize_AddVii(uid,rid,itemId,num)
	if uid <= 0 or rid <= 0 or itemId <= 0 or num <= 0 then return end

	local prizeKey = "nil"
	if 9004 == itemId then prizeKey = "chest_cuprum"
	elseif 9005 == itemId then prizeKey = "chest_silver"
	elseif 9006 == itemId then prizeKey = "chest_gold"
	elseif 9300 <= itemId and itemId <= 9320 then prizeKey = string.format("ext_op%4d",itemId)
	elseif 9999 == itemId then prizeKey = "prize_code"
	else return end

	--add vii
	local sql = string.format("update t_cha set %s = %s + %d where id = %d",prizeKey,prizeKey,num,rid)
	xlDb_Execute(sql)

	--add log
	sql = string.format("insert into log_vii (uid,rid,type,num,string_id) values (%d,%d,%d,%d,\'%s\')",uid,rid,itemId,num,"server_script")
	xlDb_Execute(sql)
end

--更新奖励日志
function xlPrize_Update(prizeId, state)
	local sql = string.format("update prize set used= %d where id = %d",state,prizeId)
	xlDb_Execute(sql)
end

--插入一条新的奖励日志
function xlPrize_Insert(uid,rid,infoType,info,state)
	local sql = string.format("insert into prize (uid,rid,type, mykey, used) values (%d,%d,%d,\'%s\',%d)",uid,rid,infoType,info,state)
	local err = xlDb_Execute(sql)
	local prizeId = 0
	if 0 == err then
		sql = "select last_insert_id()"
		err,prizeId = xlDb_Query(sql)
	end
	return err,prizeId
end

--更新奖励日志
hApi.UpdatePrize = function(prizeId, state)
	if xlPrize_Update then
		xlPrize_Update(prizeId,state)
	end
end

--插入一条新的奖励日志
hApi.InsertPrize = function(uid,rid,infoType,info,state)
	if xlPrize_Insert then
		local err, prizeId = xlPrize_Insert(uid,rid,infoType,info,state)
		return err, prizeId
	end
end

--领取奖励
hApi.GetRewardInPrize = function(uid, rid, prizeId, fromIdx, toIdx)
	local sCmd = ""
	local maxReward = 3
	local sql = string.format("SELECT `mykey`, `used`, `create_id` FROM `prize` where `id` = %d AND `uid`= %d", prizeId, uid)
	local reward = hClass.Reward:create():Init()
	
	local err, sMykey, nUsed, create_id = xlDb_Query(sql)
	local rewardNum = 0
	local rewardExInfo = nil
	if err == 0 then
		--local reward = hClass.Reward:create():Init()
		
		if (nUsed == 0) then --未使领取过的才能领
			local tMykey = hApi.Split(sMykey,";")
			
			local fIdx = fromIdx or 1
			local tIdx = toIdx or #tMykey
			local sNewMykey = ""
			
			for i = fIdx, tIdx do
				sNewMykey = sNewMykey .. tostring(tMykey[i]).. ";"
				local tmp = hApi.Split(tMykey[i],":")
				--print(tMykey[i], tmp)
				reward:Add(tmp)
				rewardNum = rewardNum + 1
			end
			--print("reward begin:",tostring(reward))
			--服务器处理奖励（目前只处理游戏币）
			rewardExInfo = hApi.RewardPreprocessing(uid, rid, reward, rewardNum or maxReward, create_id)
			if rewardExInfo then
				--替换新的奖励表
				reward = rewardExInfo
			end
			
			--服务器更新邮件表
			hApi.UpdatePrize(prizeId, 1)
		end
		
		sCmd = sCmd .. reward:ToCmd()
	end
	
	sCmd = tostring(prizeId).. ";" .. tostring(rewardNum or maxReward) .. ";" .. sCmd
	
	--print("sCmd:", prizeId, maxReward, rewardN, sCmd)
	
	return sCmd, reward
end

--[[
--领取奖励2
hApi.GetRewardInPrize2 = function(user, prizeId,fromIdx,toIdx)
	local sCmd = ""
	local maxReward = 3
	local sql = string.format("SELECT mykey FROM prize where id=%d AND uid=%d",prizeId,user:GetDBID())
	
	local err, sMykey = xlDb_Query(sql)
	local rewardNum = 0
	if err == 0 then
		local tMykey = hApi.Split(sMykey,";")
		local reward = hClass.Reward:create():Init()
		local fIdx = fromIdx or 1
		local tIdx = toIdx or #tMykey
		local sNewMykey = ""
		
		for i = fIdx, tIdx do
			sNewMykey = sNewMykey .. tostring(tMykey[i]).. ";"
			local tmp = hApi.Split(tMykey[i],":")
			reward:Add(tmp)
			rewardNum = rewardNum + 1
		end
		--print("reward begin:",tostring(reward))
		--服务器处理奖励（目前只处理游戏币）
		--todo
		--user:takereward(reward)
		
		sCmd = sCmd .. reward:ToCmd()
		
		--服务器更新邮件表
		hApi.UpdatePrize(prizeId, 1)
	end
	
	sCmd = tostring(prizeId).. ";" .. tostring(rewardNum or maxReward) .. ";" .. sCmd
	
	--print("sCmd:", prizeId, maxReward, rewardN, sCmd)
	
	return sCmd
end
]]

--领取服务器抽卡的奖励
hApi.GetRewardInPrize_DrawCard = function(uid, rid, prizeId, fromIdx, toIdx, prizeParam)
	local sCmd = ""
	local maxReward = 3
	local sql = string.format("SELECT `mykey`, `used`, `create_id` FROM `prize` where `id` = %d AND `uid`= %d", prizeId, uid)
	
	local err, sMykey, nUsed, create_id = xlDb_Query(sql)
	--print("nUsed=", nUsed, type(nUsed))
	--sMykey = 消耗2500游戏币奖励;13:1:35:5_10201_35|5_10202_35|5_10203_35|5_10206_35|5_10205_35;
	local rewardNum = 0
	if err == 0 then
		local reward = hClass.Reward:create():Init()
		
		if (nUsed == 0) then --未使领取过的才能领
			local tIndexs = hApi.Split(prizeParam, "|") --选择领取了哪些索引
			local tMykey = hApi.Split(sMykey, ";")
			--print("sMykey=", sMykey, "\n")
			--print("prizeParam=", prizeParam, "\n")
			
			local fIdx = fromIdx or 1
			local tIdx = toIdx or #tMykey
			local sNewMykey = ""
			
			--print("fIdx=", fIdx, "tIdx=", tIdx)
			for i = fIdx, tIdx do
				sNewMykey = sNewMykey .. tostring(tMykey[i]).. ";"
				--print("sNewMykey=", sNewMykey)
				if tMykey and (#tMykey > 0) then --防止是空表
					local rewardT = hApi.Split(tMykey[i],":")
					local rtype = tonumber(rewardT[1]) or 0 --13:服务器将魂抽卡
					local rid = tonumber(rewardT[2]) or 0 --此参数作为发奖数量
					local rnum = tonumber(rewardT[3]) or 0 --此参数作为界面显示奖励碎片数量
					local param4 = rewardT[4]
					--print("    rewardT=", rtype, rid, rnum, param4, "\n")
					
					if (rtype == 13) then --只处理13(服务器将魂抽卡)类型的奖励
						local cardList = hApi.Split(param4, "|")
						for i = #cardList, 1, -1 do
							if (#cardList[i] == 0) then --防止最后一项是空表
								cardList[i] = nil
							else
								cardList[i] = hApi.Split(cardList[i], "_")
								cardList[i][1] = tonumber(cardList[i][1]) or 0
								cardList[i][2] = tonumber(cardList[i][2]) or 0
								cardList[i][3] = tonumber(cardList[i][3]) or 0
								--print("        cardList[" .. i .. "] = ", cardList[i][1], cardList[i][2], cardList[i][3], "\n")
							end
						end
						
						--只发前n项
						for n = 1, rid, 1 do
							local idx = tonumber(tIndexs[n]) or 0 --选择了哪一项
							--print("    idx=" .. idx .. "\n")
							if idx then
								local card = cardList[idx]
								--print("    card=", card, "\n")
								if card then
									--print(tMykey[i], tmp)
									--local tmp = tostring(card[1]) .. ";" .. tostring(card[2] or 0) .. ";" .. tostring(card[3] or 0) .. ";" .. tostring(card[4] or 0) .. ";"
									reward:Add(card)
									rewardNum = rewardNum + 1
									--print("uid=" .. uid, "card=", tmp)
									--print("\n")
									
									--更新选择的索引信息
									local sql = string.format("update prize set `from` = %d where id = %d", idx, prizeId)
									xlDb_Execute(sql)
								end
							end
						end
					end
				end
			end
			
			--print("reward begin:",tostring(reward))
			--服务器处理奖励（目前只处理游戏币）
			hApi.RewardPreprocessing(uid, rid, reward, rewardNum or maxReward, create_id)
			
			--服务器更新邮件表
			hApi.UpdatePrize(prizeId, 1)
		end
		
		sCmd = sCmd .. reward:ToCmd()
	end
	
	sCmd = tostring(prizeId).. ";" .. tostring(rewardNum or maxReward) .. ";" .. sCmd
	
	--print("sCmd:", prizeId, maxReward, rewardN, sCmd)
	
	return sCmd
end

--领取服务器直接开锦囊的奖励
hApi.GetRewardInPrize_OpenChest = function(uid, rid, prizeId, fromIdx, toIdx)
	local sCmd = ""
	local maxReward = 3
	local sql = string.format("SELECT mykey, used FROM prize where id=%d AND uid=%d",prizeId,uid)
	
	local err, sMykey, nUsed = xlDb_Query(sql)
	--print("nUsed=", nUsed, type(nUsed))
	--sMykey = 消耗2500游戏币奖励;13:1:35:5_10201_35|5_10202_35|5_10203_35|5_10206_35|5_10205_35;
	local rewardNum = 0
	if err == 0 then
		local reward = hClass.Reward:create():Init()
		
		if (nUsed == 0) then --未使领取过的才能领
			local tMykey = hApi.Split(sMykey,";")
			
			local fIdx = fromIdx or 1
			local tIdx = toIdx or #tMykey
			local sNewMykey = ""
			
			for i = fIdx, tIdx do
				sNewMykey = sNewMykey .. tostring(tMykey[i]).. ";"
				
				if tMykey and (#tMykey > 0) then --防止是空表
					local rewardT = hApi.Split(tMykey[i],":")
					local rtype = tonumber(rewardT[1]) or 0 --15:直接开锦囊奖励
					local itemId = tonumber(rewardT[2]) or 0 --此参数作为发奖锦囊id
					local chestNum = tonumber(rewardT[3]) or 0 --此参数作为锦囊数量
					local param4 = rewardT[4]
					--print("    rewardT=", rtype, rid, rnum, param4, "\n")
					
					if (rtype == 15) then --只处理15(直接开锦囊)类型的奖励
						for cnum = 1, chestNum, 1 do
							local chest = hClass.Chest:create():Init(itemId,0)	--红装锦囊
							if chest and (type(chest) == "table") and (chest:getCName() == "Chest") then
								local mustRed = false
								local rewardTemp = chest:Open(mustRed)
								--print("rewardTemp=", rewardTemp)
								if rewardTemp then
									rewardTemp:TakeReward(uid, rid)
									reward:Merge(rewardTemp)
									rewardNum = rewardNum + rewardTemp:GetNum()
								end
							end
						end
					end
				end
			end
			
			--服务器更新邮件表
			hApi.UpdatePrize(prizeId, 1)
		end
		
		sCmd = sCmd .. reward:ToCmd()
	end
	
	sCmd = tostring(prizeId).. ";" .. tostring(rewardNum or maxReward) .. ";" .. sCmd
	
	--print("sCmd:", prizeId, maxReward, rewardN, sCmd)
	
	return sCmd
end


--领取奖励（策马首充旧版格式）
hApi.GetRewardInPrize_InAppOld = function(uid, rid, prizeId)
	local sCmd = ""
	local reward = nil
	local maxReward = 3
	local sql = string.format("SELECT `uid`, `mykey`, `used`, `create_id`, `group_id` FROM `prize` where `id` = %d", prizeId)
	
	local err, uidPrize, sMykey, nUsed, create_id, group_id = xlDb_Query(sql)
	local rewardNum = 0
	local rewardExInfo = nil
	if err == 0 and (uid == uidPrize) then
		reward = hClass.Reward:create():Init()
		
		if (nUsed == 0) then --未使领取过的才能领
			local tMykey = hApi.Split(sMykey,";")
			
			--转成td新格式
			--i:n10001;c:300;
			for ti = 1, #tMykey, 1 do
				local prizecode = tMykey[ti]
				if string.find(prizecode,"i:") ~= nil then --道具
					--i:11209n:1
					local itemID = tonumber(string.sub(prizecode,string.find(prizecode,"i:")+2,string.find(prizecode,"n:")-1))
					local itemNum = tonumber(string.sub(prizecode,string.find(prizecode,"n:")+2,string.len(prizecode)))
					tMykey[ti] = "3:" .. tostring(itemID) .. ":" .. tostring(itemNum) .. ":0"
				elseif string.find(prizecode,"c:") ~= nil then --游戏币
					local coin = tonumber(string.sub(prizecode,string.find(prizecode,"c:")+2,string.len(prizecode)))
					tMykey[ti] = "7:" .. tostring(coin) .. ":" .. tostring(0) .. ":0"
				elseif string.find(prizecode,"s:") ~= nil then --积分
					local score = tonumber(string.sub(prizecode,string.find(prizecode,"s:")+2,string.len(prizecode)))
					tMykey[ti] = "1:" .. tostring(score) .. ":" .. tostring(0) .. ":0"
				elseif string.find(prizecode,"H:") ~= nil then --英雄
					local heroID = tonumber(string.sub(prizecode,string.find(prizecode,"H:")+2,string.len(prizecode)))
					local itemNum = 1
					tMykey[ti] = "4:" .. tostring(heroID) .. ":" .. tostring(itemNum) .. ":1"
				end
				--print(ti, tMykey[ti])
			end
			
			local fromIdx = 1
			local fIdx = fromIdx or 1
			local tIdx = toIdx or #tMykey
			local sNewMykey = ""
			
			for i = fIdx, tIdx do
				sNewMykey = sNewMykey .. tostring(tMykey[i]).. ";"
				local tmp = hApi.Split(tMykey[i],":")
				--print(tMykey[i], tmp)
				reward:Add(tmp)
				rewardNum = rewardNum + 1
			end
			--print("reward begin:",tostring(reward))
			--服务器处理奖励（目前只处理游戏币）
			rewardExInfo = hApi.RewardPreprocessing(uid, rid, reward, rewardNum or maxReward, create_id, group_id, strHint, nHintType)
			if rewardExInfo then
				--替换新的奖励表
				reward = rewardExInfo
				
				--替换新的奖励数量
				rewardNum = rewardExInfo:GetNum()
			end
			
			--服务器更新邮件表
			hApi.UpdatePrize(prizeId, 1)
		end
		
		sCmd = sCmd .. reward:ToCmd()
	end
	
	sCmd = tostring(prizeId).. ";" .. tostring(rewardNum or maxReward) .. ";" .. sCmd
	
	--print("sCmd:", prizeId, maxReward, rewardN, sCmd)
	
	return sCmd, reward
end

--领取奖励（策马旧版发积分格式）
hApi.GetRewardInPrize_ScoreOld = function(uid, rid, prizeId)
	local sCmd = ""
	local reward = nil
	local maxReward = 3
	local sql = string.format("SELECT `uid`, `mykey`, `used`, `create_id`, `group_id` FROM `prize` where `id` = %d", prizeId)
	
	local err, uidPrize, sMykey, nUsed, create_id, group_id = xlDb_Query(sql)
	local rewardNum = 0
	local rewardExInfo = nil
	if err == 0 and (uid == uidPrize) then
		reward = hClass.Reward:create():Init()
		
		if (nUsed == 0) then --未使领取过的才能领
			local tMykey = hApi.Split(sMykey,";")
			
			--转成td新格式
			--8000
			for ti = 1, #tMykey, 1 do
				--积分
				local prizecode = tMykey[ti]
				tMykey[ti] = "1:" .. tostring(prizecode) .. ":0:0"
				--print(ti, tMykey[ti])
			end
			
			local fromIdx = 1
			local fIdx = fromIdx or 1
			local tIdx = toIdx or #tMykey
			local sNewMykey = ""
			
			for i = fIdx, tIdx do
				sNewMykey = sNewMykey .. tostring(tMykey[i]).. ";"
				local tmp = hApi.Split(tMykey[i],":")
				--print(tMykey[i], tmp)
				reward:Add(tmp)
				rewardNum = rewardNum + 1
			end
			--print("reward begin:",tostring(reward))
			--服务器处理奖励（目前只处理游戏币）
			rewardExInfo = hApi.RewardPreprocessing(uid, rid, reward, rewardNum or maxReward, create_id, group_id, strHint, nHintType)
			if rewardExInfo then
				--替换新的奖励表
				reward = rewardExInfo
				
				--替换新的奖励数量
				rewardNum = rewardExInfo:GetNum()
			end
			
			--服务器更新邮件表
			hApi.UpdatePrize(prizeId, 1)
		end
		
		sCmd = sCmd .. reward:ToCmd()
	end
	
	sCmd = tostring(prizeId).. ";" .. tostring(rewardNum or maxReward) .. ";" .. sCmd
	
	--print("sCmd:", prizeId, maxReward, rewardN, sCmd)
	
	return sCmd, reward
end

--领取多项邮件奖励
hApi.GetRewardInPrize_Multy = function(uid, rid, prizeIdList)
	--分离出有效的邮件id
	local tList = {}
	for i = 1, #prizeIdList, 1 do
		local prizeId = prizeIdList[i]
		if (prizeId > 0) then
			--检测是否重复
			local bSamed = false
			for j = 1, #tList, 1 do
				if (prizeId == tList[j]) then --找到了
					bSamed = true
					break
				end
			end
			
			--不重复才加入
			if (not bSamed) then
				tList[#tList+1] = prizeId
			end
		end
	end
	
	--依次检测，是否是能够一键领取的奖励类型，进行发奖
	local tReward = hClass.Reward:create():Init()
	local tListFinish = {}
	for i = 1, #tList, 1 do
		local prizeId = tList[i]
		local sql = string.format("SELECT `uid`, `type`, `used` FROM `prize` where `id` = %d", prizeId)
		local err, uidPrize, prizeType, nUsed = xlDb_Query(sql)
		if (err == 0) and (uid == uidPrize) and (nUsed == 0) then --邮件存在，uid一致，邮件未领取
			--fromIdx:从第几个:(冒号)开始算奖励
			if (prizeType >= hVar.REWARD_LOG_TYPE.customRewardBegin and prizeType <= hVar.REWARD_LOG_TYPE.customRewardEnd) then --1900~1999
				local fromIdx = 1
				local sL2CCmd, reward = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif prizeType == hVar.REWARD_LOG_TYPE.billboard then --20001 排行榜发奖
				local fromIdx = 4
				local sL2CCmd, reward = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif (prizeType >= hVar.REWARD_LOG_TYPE.rewardMail and prizeType <= hVar.REWARD_LOG_TYPE.recommend5) then --20002~20007 推荐奖励
				local fromIdx = 1
				local sL2CCmd, reward = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif (prizeType == hVar.REWARD_LOG_TYPE.tier30) then --1035 首充198元档
				local fromIdx = 1
				local sL2CCmd, reward = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_PURCHASE198"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_PURCHASE198)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif (prizeType == hVar.REWARD_LOG_TYPE.tier40) then --1036 首充388元档
				local fromIdx = 1
				local sL2CCmd, reward = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_PURCHASE388"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_PURCHASE388)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif (prizeType == 1030) or (prizeType == 1031) or (prizeType == 1032) or (prizeType == 1033) or (prizeType == 1034) then --1030~1034 首充6,18,68,98元档
				local sL2CCmd, reward = hApi.GetRewardInPrize_InAppOld(uid,rid,prizeId)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif (prizeType == 4) or (prizeType == 9) or (prizeType == 18) or (prizeType == 100) then --4,9,19,100 网页发奖道具,每日奖励,评价奖励,新人礼包
				local sL2CCmd, reward = hApi.GetRewardInPrize_InAppOld(uid,rid,prizeId)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif (prizeType == 1039) or (prizeType == 1060) then --1039,1060 网页发奖积分
				local sL2CCmd, reward = hApi.GetRewardInPrize_ScoreOld(uid,rid,prizeId)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif prizeType == hVar.REWARD_LOG_TYPE.activity or prizeType == hVar.REWARD_LOG_TYPE.activityEx or (prizeType >= hVar.REWARD_LOG_TYPE.vip5 and prizeType <= hVar.REWARD_LOG_TYPE.vip7Above) then
				local fromIdx = 2
				local sL2CCmd, reward = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif (prizeType == hVar.REWARD_LOG_TYPE.activityDrawCard) then --20028: 服务器抽卡类奖励
				--此奖励类型不能一键领取
				--...
			elseif (prizeType == hVar.REWARD_LOG_TYPE.activitOpenChest) then --20032: 直接开锦囊奖励
				local fromIdx = 2
				local sL2CCmd, reward = hApi.GetRewardInPrize_OpenChest(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAILCHEST"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAILCHEST)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif (prizeType == hVar.REWARD_LOG_TYPE.billboardEndless) then --20029: 无尽地图排行奖励
				local fromIdx = 6
				local sL2CCmd, reward = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_ENDLESSRANKBOARD"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_ENDLESSRANKBOARD)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif (prizeType == hVar.REWARD_LOG_TYPE.pveMultyHardwork) then --20030: 魔龙宝库每日勤劳奖
				local fromIdx = 4
				local sL2CCmd, reward = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_PVEMULTYWORK"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_PVEMULTYWORK)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif (prizeType == hVar.REWARD_LOG_TYPE.mailTitleMsgReward) then --20031: 标题正文奖励
				local fromIdx = 3
				local sL2CCmd, reward = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAILREAD"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAILREAD)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif (prizeType == hVar.REWARD_LOG_TYPE.mailTitleMsgNotice) then --20033: 只有标题和正文，没有奖励
				--此奖励类型不能一键领取
				--...
			elseif (prizeType == hVar.REWARD_LOG_TYPE.pvpRankTitleMsgReward) then --20034: 夺塔奇兵带有段位、标题和正文的奖励
				local fromIdx = 4
				local sL2CCmd, reward = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAILREAD"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAILREAD)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif (prizeType == hVar.REWARD_LOG_TYPE.chatDragonReward) then --20035: 聊天龙王奖励
				local fromIdx = 4
				local sL2CCmd, reward = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_CHATDRAGON"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_CHATDRAGON)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif (prizeType == hVar.REWARD_LOG_TYPE.groupMultyHardwork) then --20036: 军团秘境试炼勤劳奖
				local fromIdx = 4
				local sL2CCmd, reward = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_GROUPMULTYWORK"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_GROUPMULTYWORK)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif (prizeType == hVar.REWARD_LOG_TYPE.groupWeekDonateRank) then --20037: 军团本周声望排名奖励
				local fromIdx = 3
				local sL2CCmd, reward = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAILREAD"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAILREAD)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif (prizeType == hVar.REWARD_LOG_TYPE.groupWeekDonateMax) then --20038: 军团本周声望第一名奖励
				local fromIdx = 3
				local sL2CCmd, reward = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAILREAD"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAILREAD)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif (prizeType == hVar.REWARD_LOG_TYPE.updateTitleMsgReward) then --20039: 更新维护带有标题正文和奖励
				local fromIdx = 3
				local sL2CCmd, reward = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAILREAD"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAILREAD)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif (prizeType == hVar.REWARD_LOG_TYPE.tiliTitleMsgReward) then --20040: 体力带有标题和正文的奖励
				local fromIdx = 3
				local sL2CCmd, reward = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAILREAD"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAILREAD)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif (prizeType == hVar.REWARD_LOG_TYPE.thankTitleMsgReward) then --20041: 感谢信带有标题和正文的奖励
				local fromIdx = 3
				local sL2CCmd, reward = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAILREAD"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAILREAD)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
			elseif (prizeType == hVar.REWARD_LOG_TYPE.shareTitleMsgReward) then --20042: 分享信带有标题和正文的奖励
				local fromIdx = 3
				local sL2CCmd, reward = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAILREAD"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAILREAD)
				if reward then
					tReward:Merge(reward)
					tListFinish[#tListFinish+1] = prizeId --奖励已领取
				end
				
				--分享类型的奖励，增加任务进度
				--更新每日任务（新）
				--分享次数
				local taskType = hVar.TASK_TYPE.TASK_SHARE_COUINT --分享任务
				local addCount = 1
				local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(uid, rid)
				taskMgr:AddTaskFinishCount(taskType, addCount)
			end
		end
	end
	
	--返回值
	local sCmd = tostring(#tListFinish) .. ";"
	for i = 1, #tListFinish, 1 do
		sCmd = sCmd .. tostring(tListFinish[i]) .. ";"
	end
	sCmd = sCmd .. tostring(tReward:GetNum()) .. ";" .. tReward:ToCmd()
	
	return sCmd
end
