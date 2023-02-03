--战车排行榜管理类
local TankBillboardMgr = class("TankBillboardMgr")
	
	TankBillboardMgr.MAX_RANK = 100
	
	--玩家状态
	TankBillboardMgr.TYPE = 
	{
		DAY = 1,		--日
		WEEK = 2,		--周
		MONTH = 3,		--月
	}
	
	--构造函数
	function TankBillboardMgr:ctor()
		self._timestamp = -1
		self._nextchecktime = -1
		self._bollboardData = -1
		
		--其他
		return self
	end
	
	--初始化函数
	function TankBillboardMgr:Init()
		--初始化时间戳
		local timestamp = os.time()
		self._timestamp = timestamp
		
		--计算下一次检测发奖时间(每天0点需要检测发奖)
		local datestamp = hApi.Timestamp2Date(self._timestamp)
		--print("datestamp=", datestamp)
		self._nextchecktime = hApi.GetNewDate(datestamp .." 00:00:00", "DAY", 1) --第二天0点的时间戳
		
		--检测是否要补发奖励
		self:_DBCheckReward(datestamp)
		
		return self
	end
	
	--检测排行榜是否需要补发奖励
	function TankBillboardMgr:_DBCheckReward(checkDate)
		--初始化
		self._bollboardData = {}
		
		--查询此日期是否有记录
		local bId = hVar.TANK_BILLBOARD_RANK_TYPE.RANK_STAGE --过图排行榜
		local sql = string.format("SELECT `billboard` FROM `tank_billboard_check` where `bid` = %d and DATE(`time`)='%s'", bId, checkDate)
		local err, billboardInfo = xlDb_Query(sql)
		--print(sql)
		--print(err)
		if (err == 0) then
			--有数据
			local tMykey = hApi.Split(billboardInfo, ";")
			--print(billboardInfo)
			local COUNT = tonumber(tMykey[1]) or 0
			local rIdx = 1
			for i = 1 + rIdx, COUNT + rIdx, 1 do
				local tUserInfo = hApi.Split(tMykey[i], ":")
				local rank = tonumber(tUserInfo[1]) or 0 --rank
				local uid = tonumber(tUserInfo[2]) or 0 --uid
				local rid = tonumber(tUserInfo[3]) or 0 --rid
				local name = tostring(tUserInfo[4]) --name
				--print(i, rank, uid, rid, name)
				
				--存储昨日排行榜数据
				self._bollboardData[#self._bollboardData+1] = {rank = rank, uid = uid, rid = rid, name = name,}
			end
		else
			--无数据
			--读取此日期的排行榜数据
			local sCmdTemp = ""
			local diff = 0
			local sQueryM = string.format("select `uid`, `rid`, `name`, `stage`, `tank`, `weapon`, `gametime`, `scientist`, `gold`, `kill`, `time` from `tank_billboard` where `bid` = %d and `diff` = %d order by `stage` desc, `gametime` asc, `time` asc limit %d", bId, diff, TankBillboardMgr.MAX_RANK)
			local errM, tTemp = xlDb_QueryEx(sQueryM)
			--print(sQueryM)
			--print("查询排行榜:", "errM=", errM, "tTemp=", tTemp)
			if (errM == 0) then
				for n = 1, #tTemp, 1 do
					local rank = n
					local uid = tTemp[n][1]
					local rid = tTemp[n][2]
					local name = tTemp[n][3]
					local stage = tTemp[n][4]
					local tankId = tTemp[n][5]
					local weaponId = tTemp[n][6]
					local gametime = tTemp[n][7]
					local scientistNum = tTemp[n][8]
					local goldNum = tTemp[n][9]
					local killNum = tTemp[n][10]
					local time = tTemp[n][11]
					
					sCmdTemp = sCmdTemp .. tostring(rank) .. ":" .. tostring(uid) .. ":" .. tostring(rid) .. ":" .. tostring(name) .. ";"
					--print(tostring(rank) .. ":" .. tostring(uid) .. ":" .. tostring(rid) .. ":" .. tostring(name) .. ";")
					
					--存储昨日排行榜数据
					self._bollboardData[#self._bollboardData+1] = {rank = rank, uid = uid, rid = rid, name = name,}
				end
				
				sCmdTemp = tostring(#tTemp) .. ";" .. sCmdTemp
				
				--插入记录
				local sql1 = string.format("INSERT INTO `tank_billboard_check` (`bid`, `billboard`, `time`) values (%d, '%s', '%s')", bId, sCmdTemp, checkDate)
				xlDb_Execute(sql1)
			end
		end
	end
	
	--查询玩家的排名
	function TankBillboardMgr:QueryRank(uid, rid)
		local rank = 0
		
		for i = 1, #self._bollboardData, 1 do
			if (self._bollboardData[i].uid == uid) and (self._bollboardData[i].rid == rid) then
				rank = self._bollboardData[i].rank
				break
			end
		end
		
		return rank
	end
	
	--更新函数
	function TankBillboardMgr:Update()
		--local localTime = os.time() --客户端时间 12:00
		local dbTime = hApi.GetTime()
		
		--如果当前时间大于检测时间，则需要进行检测(每天0点需要检测发奖)
		if (dbTime >= self._nextchecktime) then
			local datestamp = hApi.Timestamp2Date(self._nextchecktime)
			
			--检测是否要发奖励
			self:_DBCheckReward(datestamp)
			
			--重新设置下一次检测日期
			self._nextchecktime = hApi.GetNewDate(datestamp.." 00:00:00", "DAY", 1) --第二天0点的时间戳
		end
		
		return self
	end
	
return TankBillboardMgr