--排行榜管理类
local BillboardMgr = class("BillboardMgr")
	
	BillboardMgr.__maxReward = 5
	
	BillboardMgr.RANKBOARD_DELTATIME = 60 --查询排行榜的间隔时间（单位：秒）（用于查询排行榜优化）
	
	--排行榜类型状态
	BillboardMgr.TYPE = 
	{
		DAY = 1,		--日
		WEEK = 2,		--周
		MONTH = 3,		--月
	}
	
	--排行榜定时检测的bid
	--BillboardMgr.UPDATE_BID_LIST = {1, 2, 11, 12, 21, 22, 4,} --排行榜id
	BillboardMgr.UPDATE_BID_LIST = {1, 2,} --排行榜id
	
	--排行榜排名最大值
	BillboardMgr.MAX_RANK = 9999
	
	--构造函数
	function BillboardMgr:ctor()
		self._timestamp = -1
		self._nextchecktime = -1
		self._template = {}
		
		--排行榜数据表
		self._billboardData = {}
		
		--其他
		self._statisticsTime = -1	--统计排行榜计时
		self._statisticsTimestamp = -1	--上次统计排行榜时间
		
		return self
	end
	
	--初始化函数
	function BillboardMgr:Init(timestamp)
		
		--初始化时间戳
		self._timestamp = timestamp
		
		--计算下一次检测发奖时间(每天0点需要检测发奖)
		local datestamp = hApi.Timestamp2Date(hApi.GetNewDate(self._timestamp))
		self._nextchecktime = hApi.GetNewDate(datestamp.." 00:00:00", "DAY", 1) --第二天0点的时间戳
		
		--获取模板
		self:_DBGetBillboardTemplate()
		
		--检测是否要补发奖励
		--这里改为安卓主服务器发奖
		if (hVar.IS_MAIN_SERVER == 1) then
			self:_DBCheckReward(datestamp)
		end
		
		--排行榜数据表
		self._billboardData = {}
		
		--其他
		self._statisticsTime = hApi.GetClock()	--统计排行榜计时
		self._statisticsTimestamp = os.time()	--上次统计排行榜时间
		--print("初始化排行榜", os.date("%Y-%m-%d %H:%M:%S", os.time()))
		
		--取排行榜排名数据
		for i = 1, #BillboardMgr.UPDATE_BID_LIST, 1 do
			--获取指定bId的排行数据
			local bId = BillboardMgr.UPDATE_BID_LIST[i]
			self:_QueryBillbaordByBID(bId)
		end
		
		return self
	end
	
	--更新函数(1分钟/次)
	function BillboardMgr:Update()
		--local localTime = os.time() --客户端时间 12:00
		local dbTime = hApi.GetTime()
		
		--如果当前时间大于检测时间，则需要进行检测(每天0点需要检测发奖)
		if dbTime >= self._nextchecktime then
			local datestamp = hApi.Timestamp2Date(self._nextchecktime)
			
			--检测是否要发奖励
			--这里改为安卓主服务器发奖
			if (hVar.IS_MAIN_SERVER == 1) then
				self:_DBCheckReward(datestamp)
			end
			
			--重新设置下一次检测日期
			self._nextchecktime = hApi.GetNewDate(datestamp.." 00:00:00", "DAY", 1) --第二天0点的时间戳
		end
		
		--更新排行榜
		local timeNow = hApi.GetClock()
		if (self._statisticsTime > -1) and (timeNow - self._statisticsTime > 60000) then
			local lasttimestamp = self._statisticsTimestamp
			local currenttimestamp = os.time()
			
			self._statisticsTime = timeNow
			self._statisticsTimestamp = currenttimestamp
			--print("更新排行榜", os.date("%Y-%m-%d %H:%M:%S", os.time()))
			
			--定时取排行榜排名数据
			for bId = 1, #BillboardMgr.UPDATE_BID_LIST, 1 do
				--获取指定bId的排行数据
				--self:_QueryBillbaordByBID(bId)
			end
		end
		
		return self
	end
	
	--获取指定bId的排行数据
	function BillboardMgr:_QueryBillbaordByBID(bId)
		--print("BillboardMgr:_QueryBillbaordByBID", bId)
		if bId and self._template[bId] then
			local bbTemplate = self._template[bId]
			local tType = bbTemplate.tType
			local condition = bbTemplate.condition
			--local prize = bbTemplate.prize
			
			local sql = ""
			if (tType == BillboardMgr.TYPE.DAY) then --日榜
				sql = string.format("SELECT t1.uid,t1.rid,t2.name,t1.%s, t1.cfg FROM leaderboards AS t1 LEFT JOIN t_cha AS t2 ON t1.rid=t2.id where DATE(t1.check_time)=CURDATE() AND t1.leaderboards_id=%d AND t1.%s >= 0 ORDER BY t1.%s DESC, t1.time ASC LIMIT %d",condition,bId,condition,condition,BillboardMgr.MAX_RANK)
			elseif (tType == BillboardMgr.TYPE.MONTH) then --月榜
				local dbTime = hApi.GetTime()
				local tDbtime = os.date("*t",dbTime)
				local day = tonumber(tDbtime.day) or 1
				if (day < 16) then
					condition = bbTemplate.condition1
				end
				
				sql = string.format("SELECT t1.uid,t1.rid,t2.name,t1.%s FROM leaderboards AS t1 LEFT JOIN t_cha AS t2 ON t1.rid=t2.id where DATE_FORMAT(t1.check_time,'%%Y-%%m')=DATE_FORMAT(NOW(),'%%Y-%%m') AND t1.leaderboards_id=%d AND t1.%s >= 0 ORDER BY t1.%s DESC, t1.time ASC LIMIT %d",condition,bId,condition,condition,BillboardMgr.MAX_RANK)
			end
			
			local err, tTemp = xlDb_QueryEx(sql)
			--print("sql:",err,sql)
			
			--存储排名数据
			self._billboardData[bId] = {}
			self._billboardData[bId].time = os.time() --存储排行榜的查询时间（用于查询排行榜优化）
			
			if (err == 0) then
				for n = 1, #tTemp, 1 do
					local uid = tTemp[n][1]
					local rid = tTemp[n][2]
					local name = tTemp[n][3]
					local rank = tTemp[n][4]
					local cfg = tTemp[n][5] or ""
					
					self._billboardData[bId][n] = {uid = uid, rid = rid, name = name, rank = rank, cfg = cfg,}
				end
			end
		end
		
		return self
	end
	
	--获得排行榜模板配置(cmd格式)
	function BillboardMgr:GetBillboardTemplate2Cmd(bId)
		local sCmd = ""
		local billboardNum = 0
		
		if (bId <= 0) then --bId小于等于0，表示取全部排行榜的静态数据
			for bId, template in pairs(self._template) do
				local tType = template.tType
				local openFlag = 1 --今日是否开放
				
				--如果排行榜有开放条件，检测本周此排行榜是否开放
				local open_condition = template.prize.open_condition --开放条件
				if (type(open_condition) == "table") then
					--当前为第n周，n除以除数，得出余数，余数等于指定的值，本周才开放
					local week_begin = open_condition.week_begin --以此日期作为第1周
					local week_divisor = open_condition.week_divisor --除数
					local week_module = open_condition.week_module --模数
					
					local begintime = hApi.GetNewDate(week_begin) --第1周的时间戳
					local timenow = os.time() --现在的时间戳
					local deltasecond = timenow - begintime
					local deltaweek = math.floor(deltasecond / (3600 * 24 * 7)) + 1 --间隔的周数
					
					local modValue = deltaweek % week_divisor --求余
					if (modValue == week_module) then
						openFlag = 1 --开放
					else
						openFlag = 0 --不开放
					end
				end
				
				sCmd = sCmd .. tostring(template.id) .. ":"				--排行榜id
				sCmd = sCmd .. tostring(template.tType) .. ":"			--排行榜类型
				sCmd = sCmd .. tostring(openFlag) .. ":"				--今日是否开放
				sCmd = sCmd .. tostring(template.prize.max_rank) .. ":"	--最大分数
				
				--local prize = "{".. template.sPrize .. "}"
				local prize = template.sPrize --geyachao: 改为读tab表，已自带括号
				--如果类型是DAY，则按当前日期获取配置
				if (tType == BillboardMgr.TYPE.DAY) then
					--客户端时间 12:00
					local dbTime = hApi.GetTime()
					local weekDay = hApi.Time2Weekdate(dbTime) or 1
					prize = serialize(template.prize[weekDay] or template.prize[1])
				--如果类型是MONTH，则按当前月份获取配置
				elseif (tType == BillboardMgr.TYPE.MONTH) then
					local dbTime = hApi.GetTime()
					local tDbtime = os.date("*t",dbTime)
					local month = tonumber(tDbtime.month) or 1
					prize = serialize(template.prize[month] or template.prize[1])
				end
				
				sCmd = sCmd .. tostring(prize) .. ";"
				
				billboardNum = billboardNum + 1
			end
		else --取指定bId的排行榜的静态数据
			if self._template[bId] then
				local template = self._template[bId]
				
				local tType = template.tType
				local openFlag = 1 --今日是否开放
				
				--如果排行榜有开放条件，检测本周此排行榜是否开放
				local open_condition = template.prize.open_condition --开放条件
				if (type(open_condition) == "table") then
					--当前为第n周，n除以除数，得出余数，余数等于指定的值，本周才开放
					local week_begin = open_condition.week_begin --以此日期作为第1周
					local week_divisor = open_condition.week_divisor --除数
					local week_module = open_condition.week_module --模数
					
					local begintime = hApi.GetNewDate(week_begin) --第1周的时间戳
					local timenow = os.time() --现在的时间戳
					local deltasecond = timenow - begintime
					local deltaweek = math.floor(deltasecond / (3600 * 24 * 7)) + 1 --间隔的周数
					--print("bId=", bId, "deltaweek=", deltaweek)
					local modValue = deltaweek % week_divisor --求余
					--print("modValue=", modValue, "week_module=", week_module)
					if (modValue == week_module) then
						openFlag = 1 --开放
					else
						openFlag = 0 --不开放
					end
				end
				
				sCmd = sCmd .. tostring(template.id) .. ":"				--排行榜id
				sCmd = sCmd .. tostring(template.tType) .. ":"			--排行榜类型
				sCmd = sCmd .. tostring(openFlag) .. ":"				--今日是否开放
				sCmd = sCmd .. tostring(template.prize.max_rank) .. ":"	--最大分数
				
				--local prize = "{".. template.sPrize .. "}"
				local prize = template.sPrize --geyachao: 改为读tab表，已自带括号
				--如果类型是DAY，则按当前日期获取配置
				if (tType == BillboardMgr.TYPE.DAY) then
					local dbTime = hApi.GetTime()
					local weekDay = hApi.Time2Weekdate(dbTime) or 1
					prize = serialize(template.prize[weekDay] or template.prize[1])
				--如果类型是MONTH，则按当前月份获取配置
				elseif (tType == BillboardMgr.TYPE.MONTH) then
					local dbTime = hApi.GetTime()
					local tDbtime = os.date("*t",dbTime)
					local month = tonumber(tDbtime.month) or 1
					prize = serialize(template.prize[month] or template.prize[1])
				end
				
				sCmd = sCmd .. tostring(prize) .. ";"
				
				billboardNum = billboardNum + 1
			end
		end
		
		sCmd = tostring(bId) .. ";" .. tostring(billboardNum) .. ";" .. sCmd
		
		return sCmd
	end
	
	--获得排行榜(cmd格式)
	function BillboardMgr:DBGetBillboard2Cmd(uId, rId, bId)
		--print("DBGetBillboard2Cmd", uId, rId, bId)
		
		--如果上次查询此bId排行榜数据的时间太久，需要重新获取排行榜数据
		local lasttime = self._billboardData[bId].time
		local currenetime = os.time()
		local deltatime = currenetime - lasttime
		--print("bId=", bId)
		--print("deltatime=", deltatime)
		if (deltatime > BillboardMgr.RANKBOARD_DELTATIME) then
			self:_QueryBillbaordByBID(bId)
			--print("self:_QueryBillbaordByBID("..bId..")")
		end
		
		local sCmd = ""
		local sCmdMe = ";"
		local num = 0
		
		if bId and self._template[bId] then
			local bbTemplate = self._template[bId]
			local tType = bbTemplate.tType
			local condition = bbTemplate.condition
			local prize = bbTemplate.prize
			
			local max_rank = prize.max_rank or 20
			
			--我的排名
			local rankingMe = 0
			local nameMe = ""
			local rankMe = 0
			for n = 1, #self._billboardData[bId], 1 do
				local billInfo = self._billboardData[bId][n]
				if (billInfo.rid == rId) then --找到了
					rankingMe = n
					nameMe = billInfo.name
					rankMe = billInfo.rank
				end
			end
			
			--我的排名数据
			sCmdMe = tostring(rankingMe) .. ":" .. tostring(nameMe or "") ..":".. tostring(rankMe or 0) .. sCmdMe
			
			--排行榜的下发条数
			local count = math.min(max_rank, #self._billboardData[bId])
			for n = 1, count, 1 do
				local billInfo = self._billboardData[bId][n]
				local uid = billInfo.uid
				local rid = billInfo.rid
				local name = billInfo.name
				local rank = billInfo.rank
				local cfg = billInfo.cfg
				
				sCmd = sCmd .. tostring(uid)..":" .. tostring(name)..":"..tostring(rank)..";"..tostring(cfg)..";"
				
				num = num + 1
			end
		end
		
		sCmd = tostring(bId).. ";" .. sCmdMe .. tostring(num) .. ";" .. sCmd
		
		return sCmd
	end
	
	--无尽地图生成挑战记录id
	function BillboardMgr:GetBillboardBattleCfgId(uId, rId, bId)
		local battlecfg_id = 0
		
		--新生成一条无尽挑战记录，并返回记录id
		--插入一条新数据
		local difficulty = 0
		local batteleCfg = "bId=" .. bId
		local sInsertM = string.format("insert into `log_qunyingge_battleconfig`(`uid`, `rid`, `difficulty`, `battleconfig`, `game_time`, `time_begin`) values(%d, %d, %d, '%s', '', now())", uId, rId, difficulty, batteleCfg)
		xlDb_Execute(sInsertM)
		--print(sInsertM)
		
		--取挑战记录id
		local err1, oId = xlDb_Query("select last_insert_id()")
		--print("err1,orderId:",err1,orderId)
		if (err1 == 0) then
			battlecfg_id = oId
		else
			
		end
		
		return battlecfg_id
	end
	
	--更新玩家当前的排行榜数据
	function BillboardMgr:DBUpdateUserBillboardData(uId,rId,bId,rank,cfg)
		
		--随机迷宫需要达到最小分数才能上榜
		if (bId == 1) then --随机迷宫
			if (rank >= hVar.RANDOMMAP_RANDBOARD_SCORE_MIN) then
				--更新玩家数据
				self:_DBUpdateUserBillboardData(uId,rId,bId,rank,cfg)
			end
		elseif (bId == 2) then --前哨阵地
			if (rank >= hVar.QIANSHAOZHHENDI_RANDBOARD_SCORE_MIN) then
				--更新玩家数据
				self:_DBUpdateUserBillboardData(uId,rId,bId,rank,cfg)
			end
		else
			--更新玩家数据
			self:_DBUpdateUserBillboardData(uId,rId,bId,rank,cfg)
		end
		
		--刷新指定bId的排行数据
		--self:_QueryBillbaordByBID(bId)
		
		--取最新的排行榜数据
		local sCmd = self:DBGetBillboard2Cmd(uId,rId,bId)
		
		return sCmd
	end
	
	--获得奖励（已废弃）
	function BillboardMgr:DBGetMailAnnex(uid, rid, prizeId)
		
		--local sCmd = ""
		--local rewardN = 0
		--local sql = string.format("SELECT mykey FROM prize where id=%d AND uid=%d AND rid=%d",prizeId,uid,rid)
		--
		--local err, sMykey = xlDb_Query(sql)
		--if err == 0 then
		--	local tMykey = hApi.Split(sMykey,";")
		--	local n = tonumber(tMykey[1])
		--	local bId = tonumber(tMykey[2])
		--
		--	if bId > 0 and self._template[bId] then
		--		local bbTemplate = self._template[bId]
		--		local prize = bbTemplate.prize
		--		
		--		--遍历奖品列表查找当前需要给的奖励
		--		if prize.reward and type(prize.reward) == "table" then
		--			for j = 1, #prize.reward do
		--				local reward = prize.reward[j]
		--				--如果当前名次在区间中，则发奖给玩家
		--				if n >= reward.from and n <= reward.to then
		--					
		--					--服务器处理排行榜奖励（目前只处理游戏币）
		--					hApi.RewardPreprocessing(uid, rid, reward, BillboardMgr.__maxReward)
		--					
		--					sCmd = sCmd .. (self:_Reward2Log(reward))
		--					
		--					rewardN = BillboardMgr.__maxReward or #reward
		--					
		--					--服务器更新邮件表
		--					hApi.UpdatePrize(prizeId, 1)
		--					
		--					break
		--				end
		--			end
		--		end
		--	end
		--end
		--
		--sCmd = tostring(prizeId).. ";" .. tostring(BillboardMgr.__maxReward) .. ";" .. tostring(rewardN) .. ";" .. sCmd
		--
		--return sCmd
		
		return hApi.GetRewardInPrize(uid, rid, prizeId, 4)
	end
	
	--获取排行榜配置信息
	function BillboardMgr:_DBGetBillboardTemplate()
		--local sql = string.format("SELECT id, type, condition, prize FROM leaderboards_template")
		local sql = "SELECT id,`type`,`condition`,`condition1`,prize,DATE(last_check_time) FROM leaderboards_template"
		local err,tQuery = xlDb_QueryEx(sql)
		if err==0 then
			for n = 1,#tQuery do
				local id = tQuery[n][1]
				local tType = tQuery[n][2]
				local condition = tQuery[n][3]
				local condition1 = tQuery[n][4]
				--local prize = tQuery[n][5] --geyachao: 已改为从tab表读取
				local prize = hVar.tab_rankboard_prize[id] --geyachao: 已改为从tab表读取
				local sPrize = serialize(prize) --geyachao: 已改为从tab表读取
				local lastCheckTime = tQuery[n][6]
				self._template[id] = 
				{
					id = id,
					tType = tType,
					condition = condition,
					condition1 = condition1,
					--sPrize = prize, --geyachao: 已改为从tab表读取
					--prize = prize,		--后面赋值
					sPrize = sPrize, --geyachao: 已改为从tab表读取
					prize = prize, --geyachao: 已改为从tab表读取
					lastCheckTime = lastCheckTime,
				}
				--geyachao: 已改为从tab表读取
				--[[
				local tmpPrize = {}
				local sAwards = "local tmpPrize = {"..prize.."} return tmpPrize"
				self._template[id].prize = assert(loadstring(sAwards))()
				]]
			end
		end
		return self
	end
	
	--计算需要插入的检测记录
	function BillboardMgr:_CaculateCheckTable(checkDate)
		local tQueryCheck = {}
		
		--删除作弊玩家的数据
		local sqlDelete = string.format("DELETE FROM `leaderboards` WHERE `uid` IN (SELECT `uid` FROM `t_user` WHERE `isCheat` = %d)", 1)
		xlDb_Execute(sqlDelete)
		
		--检测check表
		for bId,bbTemplate in pairs(self._template) do
			
			local tType = bbTemplate.tType
			
			--存储查询到的信息
			tQueryCheck[bId] = {}
			
			if tType == BillboardMgr.TYPE.DAY then
				
				--上一次检测排行榜奖励时间
				local lastCheckDate = bbTemplate.lastCheckTime
				--需要检测的时间范围（字符串）
				local sFTime = lastCheckDate.." 00:00:00"
				local sTTime = checkDate.." 00:00:00"
				--需要检测的时间范围转化为数值
				local nFTime = hApi.GetNewDate(sFTime)
				local nTTime = hApi.GetNewDate(sTTime)
				--需要检测的时间戳计算
				local sTimeStamp = sFTime
				local nTimeStamp = nFTime
				local tTimeStamp = {}
				--循环遍历计算出时间区间内的所有日期
				while (nTimeStamp < nTTime) do
					local sDate = os.date("%Y-%m-%d", nTimeStamp)
					--添加上一次符合条件的时间戳
					tTimeStamp[sDate] = true
					
					--时间戳+1day
					nTimeStamp = hApi.GetNewDate(sTimeStamp, "DAY", 1)
					sTimeStamp = os.date("%Y-%m-%d %H:%M:%S", nTimeStamp)
				end
				
				--第一遍检测，查找出时间戳中没有记录的条目
				local sql = string.format("SELECT id,leaderboards_id,DATE(check_time),result FROM leaderboards_check where DATE(check_time)>='%s' AND DATE(check_time)<'%s' AND leaderboards_id=%d and `tType` = %d",sFTime,sTTime,bId, tType)
				local err,tTemp = xlDb_QueryEx(sql)
				if err == 0 then
					for n = 1,#tTemp do
						--查询到的记录添加到记录中
						tQueryCheck[bId][#tQueryCheck[bId] + 1] = tTemp[n]
						local date = tTemp[n][3]
						--时间戳中存在记录则清除时间戳
						if tTimeStamp[date] then
							tTimeStamp[date] = nil
						end
					end
				end
				
				--遍历时间戳，插入没有记录的条目
				for date, _ in pairs(tTimeStamp) do
					--插入记录
					local sql1 = string.format("INSERT INTO leaderboards_check (leaderboards_id,check_time, `tType`, result) values (%d,'%s', %d, '%s')",bId, date, tType, "flag=0,")--.." 00:00:00")
					xlDb_Execute(sql1)
					
					--查找刚插入的记录
					local sql2 = string.format("SELECT id,leaderboards_id,DATE(check_time),result FROM leaderboards_check where DATE(check_time)='%s' AND leaderboards_id=%d and `tType` = %d",date,bId, tType)
					local err1,id,leaderboards_id,dateNew,result = xlDb_Query(sql2)
					if err1 == 0 then
						--查询到的记录添加到记录中
						tQueryCheck[bId][#tQueryCheck[bId] + 1] = {id,leaderboards_id,dateNew,result}
					end
				end
			elseif tType == BillboardMgr.TYPE.MONTH then
				--上一次检测排行榜奖励时间
				local lastCheckDate = bbTemplate.lastCheckTime
				--需要检测的时间范围（字符串）
				local sFTime = lastCheckDate.." 00:00:00"
				local sTTime = checkDate.." 00:00:00"
				local nFTime = hApi.GetNewDate(sFTime)
				local nTTime = hApi.GetNewDate(sTTime)
				
				local tFTime = os.date("*t", nFTime)
				local tTTime = os.date("*t", nTTime)
				
				--print("BillboardMgr.TYPE.MONTH:",sFTime,nFTime,tFTime)
				--print("BillboardMgr.TYPE.MONTH:",sTTime,nTTime,tTTime)
				
				local tmpTime = {}
				tmpTime.year = tFTime.year
				tmpTime.month = tFTime.month
				tmpTime.day = tFTime.day
				tmpTime.hour = 0--tFTime.hour
				tmpTime.min = 0--tFTime.min
				tmpTime.sec = 0--tFTime.sec
				
				local tTimeStamp = {}
				
				--查找需要检测的时间点
				while not ((tmpTime.year > tTTime.year) or (tmpTime.year == tTTime.year and tmpTime.month > tTTime.month)) do
					
					--每月1日00:00:00检测上个月的
					tmpTime.day = 1
					local nTmpDate = os.time(tmpTime)
					local sTmpDate = os.date("%Y-%m-%d", nTmpDate)
					if nTmpDate > nFTime and nTmpDate <= nTTime then
						--添加上一次符合条件的时间戳
						tTimeStamp[sTmpDate] = true
					end
					
					--每月16日00:00:00检测本月的
					tmpTime.day = 16
					nTmpDate = os.time(tmpTime)
					sTmpDate = os.date("%Y-%m-%d", nTmpDate)
					if nTmpDate > nFTime and nTmpDate <= nTTime then
						--添加上一次符合条件的时间戳
						tTimeStamp[sTmpDate] = true
					end
					
					--跳到下一个月
					tmpTime.month = tmpTime.month + 1
					if tmpTime.month > 12 then
						tmpTime.month = 1
						tmpTime.year = tmpTime.year + 1
					end
				end
				
				--第一遍检测，查找出时间戳中没有记录的条目
				local sql = string.format("SELECT id,leaderboards_id,DATE(check_time),result FROM leaderboards_check where DATE(check_time)>'%s' AND DATE(check_time)<='%s' AND leaderboards_id=%d and `tType` = %d",sFTime,sTTime,bId, tType)
				local err,tTemp = xlDb_QueryEx(sql)
				if err == 0 then
					for n = 1,#tTemp do
						--查询到的记录添加到记录中
						tQueryCheck[bId][#tQueryCheck[bId] + 1] = tTemp[n]
						local date = tTemp[n][3]
						
						--print("date:",date)
						--时间戳中存在记录则清除时间戳
						if tTimeStamp[date] then
							tTimeStamp[date] = nil
						end
					end
				end
				
				--遍历时间戳，插入没有记录的条目
				for date, _ in pairs(tTimeStamp) do
					--插入记录
					local sql1 = string.format("INSERT INTO leaderboards_check (leaderboards_id,check_time, `tType`, result) values (%d,'%s', %d, '%s')",bId, date, tType, "flag=0,")--.." 00:00:00")
					xlDb_Execute(sql1)
					--print("sql1:",sql1)
					
					--查找刚插入的记录
					local sql2 = string.format("SELECT id,leaderboards_id,DATE(check_time),result FROM leaderboards_check where DATE(check_time)='%s' AND leaderboards_id=%d and `tType` = %d",date,bId, tType)
					local err1,id,leaderboards_id,dateNew,result = xlDb_Query(sql2)
					--print("sql2:",sql2,err1)
					if err1 == 0 then
						--查询到的记录添加到记录中
						tQueryCheck[bId][#tQueryCheck[bId] + 1] = {id,leaderboards_id,dateNew,result}
					end
				end
			end
		end
		
		return tQueryCheck
	end
	
	--检测排行榜是否需要补发奖励
	function BillboardMgr:_DBCheckReward(checkDate)
		
		local tQueryCheck = self:_CaculateCheckTable(checkDate)
		
		--遍历check表中查询到的记录
		for bId, checkList in pairs(tQueryCheck) do
			
			local bbTemplate = self._template[bId]
			local tType = bbTemplate.tType
			local prize = bbTemplate.prize
			
			for i = 1, #checkList do
				local id = checkList[i][1]
				local date = checkList[i][3]
				local sTmp = "local tmp = {"..checkList[i][4].."} return tmp"
				local result = assert(loadstring(sTmp))()
				
				--如果还没有发奖，则需要发奖(目前未处理result.flag = 1的补发流程)
				if not result.flag or result.flag == 0 then
					local sql = ""
					local condition = bbTemplate.condition
					--如果类型是1的排行榜，每日的配置不一样
					if tType == BillboardMgr.TYPE.DAY then
						local weekDay = hApi.Time2Weekdate(date.." 00:00:00") or 1
						prize = bbTemplate.prize[weekDay] or bbTemplate.prize[1]
						--sql = string.format("SELECT uid,rid FROM leaderboards where DATE(check_time)='%s' AND leaderboards_id=%d AND %s>0 ORDER BY %s DESC LIMIT %d",date,bId,condition,condition,(bbTemplate.prize.max_rank or 20))
						--无尽
						--每日排行榜，只要参与的人都有奖励
						sql = string.format("SELECT uid,rid FROM leaderboards where DATE(check_time)='%s' AND leaderboards_id=%d AND %s>=0 ORDER BY %s DESC, time ASC",date,bId,condition,condition)
					elseif tType == BillboardMgr.TYPE.MONTH then
						
						
						
						local nDate = hApi.GetNewDate(date.." 00:00:00")
						local tDate = os.date("*t", nDate)
						local prizeType = "mom"
						
						
						
						--如果是1日，则要取上个月的数据
						if tonumber(tDate.day) == 1 then
							tDate.month = tDate.month - 1
							if tDate.month < 1 then
								tDate.month = 12
								tDate.year = tDate.year - 1
							end
							prizeType = "eom"
						else
							--如果是半月，按半月排序
							condition = bbTemplate.condition1
						end
						
						print("date:",date,tDate.day,condition,bbTemplate.condition1,bbTemplate.condition)
						
						local checkmonth = os.date("%Y-%m", os.time(tDate))
						prize = bbTemplate.prize[tDate.month][prizeType] or bbTemplate.prize[1][prizeType]
						sql = string.format("SELECT uid,rid FROM leaderboards where DATE_FORMAT(check_time,'%%Y-%%m')='%s' AND leaderboards_id=%d AND %s >= 0 ORDER BY %s DESC, time ASC LIMIT %d",checkmonth,bId,condition,condition,(bbTemplate.prize.max_rank or 20))
					end
					
					local err, tTemp = xlDb_QueryEx(sql)
					--print("sql:",sql, err)
					local pListLog = ""
					local broadcastName = nil --前10名的玩家名
					if err == 0 then
						--发奖
						if (tType == BillboardMgr.TYPE.DAY) then --每日榜
							--无尽
							--每日排行榜，只要参与的人，都有奖励
							for n = 1, #tTemp, 1 do
								local uid = tTemp[n][1]
								local rid = tTemp[n][2]
								
								pListLog = pListLog.. "{" .. tostring(uid)..","..tostring(rid).."},"
								
								--遍历奖品列表查找当前需要给的奖励
								if prize.reward and type(prize.reward) == "table" then
									--有排行奖励的最大名次
									local maxRank = bbTemplate.prize.max_rank or 20
									--print("n=", n, "maxRank=", maxRank)
									if (n <= maxRank) then
										--前10名，存入玩家名
										if (n <= 10) then
											--初始化
											if (broadcastName == nil) then
												broadcastName = ""
											end
											
											local sql = string.format("SELECT `name` FROM `t_cha` where `id`= %d", rid)
											local err, name = xlDb_Query(sql)
											--print("err=", err, "name=", name)
											if (err == 0) then
												broadcastName = broadcastName .. name .. ";"
											else
												--查询名字失败，显示uid
												broadcastName = broadcastName .. tostring(uid) .. ";"
											end
										end
										
										--检测要发第几档的奖励
										for j = 1, #prize.reward, 1 do
											local reward = prize.reward[j]
											--如果当前名次在区间中，则发奖给玩家
											if (n >= reward.from) and (n <= reward.to) then
												--服务器处理排行榜奖励（目前只处理游戏币）
												--hApi.RewardPreprocessing(uid, rid, reward, BillboardMgr.__maxReward)
												
												--奖励
												local strReward = ""
												
												--服务器插入prize表（客户端通过邮件领取）
												for p = 1,BillboardMgr.__maxReward do
													local v = reward[p]
													if v then
														--如果是抽n个卡牌，则要插入相应的数据
														if v[1] == 9 then
															--[[
															local num = (v[3] or 1)
															local reward = (v[1] or 0)..":"..(v[2] or 0)..":"..(1)..":"..(v[4] or 0)..";"
															for p = 1, num do
																--local sLog = string.format("%d;%d;%s;%s",n,bId,date,reward)
																--local err, prizeId = hApi.InsertPrize(uid, rid,hVar.REWARD_LOG_TYPE.billboard,sLog,0)--走邮件系统这里最后一个参数state设置为0
																strReward = strReward .. reward
															end
															]]
															--geyachao: 现在抽卡也支持一次抽多个了
															local reward = (v[1] or 0)..":"..(v[2] or 0)..":"..(v[3] or 0)..":"..(v[4] or 0)..";"
															--local sLog = string.format("%d;%d;%s;%s",n,bId,date,reward)
															--local err, prizeId = hApi.InsertPrize(uid, rid,hVar.REWARD_LOG_TYPE.billboard,sLog,0)--走邮件系统这里最后一个参数state设置为0
															strReward = strReward .. reward
														else
															local reward = (v[1] or 0)..":"..(v[2] or 0)..":"..(v[3] or 0)..":"..(v[4] or 0)..";"
															--local sLog = string.format("%d;%d;%s;%s",n,bId,date,reward)
															--local err, prizeId = hApi.InsertPrize(uid, rid,hVar.REWARD_LOG_TYPE.billboard,sLog,0)--走邮件系统这里最后一个参数state设置为0
															strReward = strReward .. reward
														end
													end
												end
												
												--格式: "每日排行地图奖励;2018-10-15;rid;rank;logId;奖励1;奖励2;奖励3;"
												local sLog = string.format("%s;%s;%d;%d;%d;%s",hVar.tab_string["__TEXT_ENDLESS_RANKBOARD"],date,bId,n,id,strReward)
												local err, prizeId = hApi.InsertPrize(uid, rid,hVar.REWARD_LOG_TYPE.billboardEndless,sLog,0)--走邮件系统这里最后一个参数state设置为0
												
												--更新check表状态
												self:_DBUpdateCheck(id,1,pListLog)
												
												break
											end
										end
									else
										--参与了每日排行地图，但是未上榜，发100积分作为小奖励
										
										--服务器插入prize表（客户端通过邮件领取）
										--格式: "每日排行地图奖励;2018-10-15;rid;rank;logId;奖励;"
										local strReward = "7:2:0:0;"
										local sLog = string.format("%s;%s;%d;%d;%d;%s",hVar.tab_string["__TEXT_ENDLESS_RANKBOARD"],date,bId,n,id,strReward)
										local err, prizeId = hApi.InsertPrize(uid, rid,hVar.REWARD_LOG_TYPE.billboardEndless,sLog,0)--走邮件系统这里最后一个参数state设置为0
										
										--更新check表状态
										self:_DBUpdateCheck(id,1,pListLog)
									end
								end
							end
						else --月榜等其它类型的榜
							--发奖
							for n = 1, #tTemp do
								local uid = tTemp[n][1]
								local rid = tTemp[n][2]
								
								pListLog = pListLog.. "{" .. tostring(uid)..","..tostring(rid).."},"
								
								--遍历奖品列表查找当前需要给的奖励
								if prize.reward and type(prize.reward) == "table" then
									for j = 1, #prize.reward do
										local reward = prize.reward[j]
										--如果当前名次在区间中，则发奖给玩家
										if n >= reward.from and n <= reward.to then
											--服务器处理排行榜奖励（目前只处理游戏币）
											--hApi.RewardPreprocessing(uid, rid, reward, BillboardMgr.__maxReward)
											
											--奖励字符串
											local strReward = ""
											
											--服务器插入prize表（客户端通过邮件领取）
											for p = 1,BillboardMgr.__maxReward do
												local v = reward[p] or {}
												--如果是抽n个卡牌，则要插入响应的数据
												if v[1] == 9 then
													--[[
													local num = (v[3] or 1)
													local strRewardTemp = (v[1] or 0)..":"..(v[2] or 0)..":"..(1)..":"..(v[4] or 0)..";"
													for p = 1, num do
														--local sLog = string.format("%d;%d;%s;%s",n,bId,date,strReward)
														--local err, prizeId = hApi.InsertPrize(uid, rid,hVar.REWARD_LOG_TYPE.billboard,sLog,0)--走邮件系统这里最后一个参数state设置为0
														strReward = strReward .. strRewardTemp
													end
													]]
													--geyachao: 现在抽卡也支持一次抽多个了
													local strRewardTemp = (v[1] or 0)..":"..(v[2] or 0)..":"..(v[3] or 0)..":"..(v[4] or 0)..";"
													strReward = strReward .. strRewardTemp
												else
													local strRewardTemp = (v[1] or 0)..":"..(v[2] or 0)..":"..(v[3] or 0)..":"..(v[4] or 0)..";"
													--local sLog = string.format("%d;%d;%s;%s",n,bId,date,strReward)
													--local err, prizeId = hApi.InsertPrize(uid, rid,hVar.REWARD_LOG_TYPE.billboard,sLog,0)--走邮件系统这里最后一个参数state设置为0
													strReward = strReward .. strRewardTemp
												end
											end
											
											--发奖
											local sLog = string.format("%d;%d;%s;%s",n,bId,date,strReward)
											local err, prizeId = hApi.InsertPrize(uid, rid,hVar.REWARD_LOG_TYPE.billboard,sLog,0)--走邮件系统这里最后一个参数state设置为0
											
											--更新check表状态
											self:_DBUpdateCheck(id,1,pListLog)
											
											break
										end
									end
								end
							end
						end
					end
					--print("broadcastName=", broadcastName)
					--更新check表状态
					self:_DBUpdateCheck(id,2,pListLog,broadcastName)
					
					--更新模板表状态
					self:_DBUpdateTemplate(bId,date)
					self._template[bId].lastCheckTime = date
				end
			end
		end
	end
	
	--奖励转化为日志
	function BillboardMgr:_Reward2Log(reward)
		if type(reward)=="table" then
			local tTemp = {}
			for i = 1,BillboardMgr.__maxReward do
				local v = reward[i] or {}
				tTemp[#tTemp+1] = (v[1] or 0)..":"..(v[2] or 0)..":"..(v[3] or 0)..":"..(v[4] or 0)..";"
			end
			if #tTemp>0 then
				return table.concat(tTemp)
			end
		end
		return ""
	end
	
	--更新check表
	function BillboardMgr:_DBUpdateCheck(id,state,pListLog,broadcastName)
		local result = "flag=" .. tostring(state).. "," .. tostring(pListLog)
		local sql = string.format("UPDATE leaderboards_check SET result='%s' WHERE id=%d",result,id)
		
		--存在前10名的名字，也一并存入
		if (type(broadcastName) == "string") then
			sql = string.format("UPDATE leaderboards_check SET result='%s',broadcast_name='%s' WHERE id=%d",result,broadcastName,id)
		end
		
		xlDb_Execute(sql)
	end
	
	--更新模板表最后更新日期
	function BillboardMgr:_DBUpdateTemplate(id,date)
		local sql = string.format("UPDATE leaderboards_template SET last_check_time='%s' WHERE id=%d AND '%s' > DATE(last_check_time)",date,id,date)
		xlDb_Execute(sql)
	end
	
	--更新玩家的排行榜数据
	function BillboardMgr:_DBUpdateUserBillboardData(uId,rId,bId,rank,cfg)
		if bId and self._template[bId] then
			local bbTemplate = self._template[bId]
			local condition = bbTemplate.condition
			
			local sql, id = string.format("SELECT `id` FROM leaderboards where uid=%d AND DATE(check_time)=CURDATE() AND leaderboards_id=%d",uId,bId)
			local err, id = xlDb_Query(sql)
			if err == 0 then --有记录
				sql = string.format("UPDATE leaderboards SET %s=%d,rid=%d, `cfg` = '%s' WHERE `id` = %d AND `%s` < %d",condition,rank,rId,cfg,id,condition,rank)
				xlDb_Execute(sql)
			else
				--插入记录
				sql = string.format("INSERT INTO leaderboards (uid,rid,check_time,%s,leaderboards_id, `cfg`) values (%d,%d,CURDATE(),%d,%d, '%s')",condition,uId,rId,rank,bId, cfg)
				xlDb_Execute(sql)
			end
			
			--[[
			--更新每日任务（新）
			--无尽地图
			if (bId == 1) or (bId == 11) or (bId == 21) then
				local taskType = hVar.TASK_TYPE.TASK_ENDLESS_SCORE --无尽使命
				local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(uId, rId)
				taskMgr:AddTaskFinishCount(taskType, rank)
			end
			]]
		end
	end
	
return BillboardMgr