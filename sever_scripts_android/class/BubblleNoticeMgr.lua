--冒字提醒类
local BubblleNoticeMgr = class("BubblleNoticeMgr")
	
	--BubblleNoticeMgr.__maxReward = 5
	
	--构造函数
	function BubblleNoticeMgr:ctor()
		--当前冒字id
		self._bubbleId = 0
		
		--其他
		self._statisticsTime = -1	--统计排行榜计时
		self._statisticsTimestamp = -1	--上次统计排行榜时间
		
		return self
	end
	
	--初始化函数
	function BubblleNoticeMgr:Init()
		--初始化时间戳
		self._statisticsTime = hApi.GetClock()	--统计计时
		self._statisticsTimestamp = os.time()	--上次统计时间
		
		--读取冒字时间大于now()的第一条数据
		local sQueryM = string.format("select IFNULL(MIN(id), 0) from `t_user_bubble_notice` where `time` >= now()")
		local errM, id = xlDb_Query(sQueryM)
		--print("查询玩家的排行榜成绩:", "errM=", errM, "stageM=", stageM, "gametimeM=", gametimeM, "goldNumM=", goldNumM)
		--有符合的id
		if (errM == 0) and (id > 0) then
			self._bubbleId = id
		else
			--读取数据库id
			local err1, pid = xlDb_Query("SELECT IFNULL(MAX(id), 0) FROM `t_user_bubble_notice`")
			--print("max(id)", err1, pid)
			if (err1 == 0) then
				self._bubbleId = pid + 1
			else
				self._bubbleId = 0 + 1
			end
		end
		
		return self
	end
	
	--release
	function BubblleNoticeMgr:Release()
		--其他
		self._statisticsTime = -1	--统计计时
		self._statisticsTimestamp = -1	--上次统计时间
		
		return self
	end
	
	--插入一条冒字信息
	function BubblleNoticeMgr:AddBubbleNotice(uid, rid, noticeType, useName, channelId, noticeInfo, itemId)
		--插入一条新数据
		local sInsertM = string.format("insert into `t_user_bubble_notice`(`uid`, `rid`, `username`, `channel`, `notice_type`, `notice_info`, `itemid`, `time`) values(%d, %d, '%s', %d, %d, '%s', %d, now())", uid, rid, useName, channelId, noticeType, noticeInfo, itemId)
		--print(sInsertM)
		xlDb_Execute(sInsertM)
	end
	
	--冒字更新(1秒)
	function BubblleNoticeMgr:Update()
		local self = hGlobal.bubblleNoticeMgr --self
		
		--输出信息
		local timeNow = hApi.GetClock()
		if (self._statisticsTime > -1) and (timeNow - self._statisticsTime > 1000) then
			local lasttimestamp = self._statisticsTimestamp
			local currenttimestamp = os.time()
			
			self._statisticsTime = timeNow
			self._statisticsTimestamp = currenttimestamp
			
			--尝试读取下一条冒字，并群发给全体玩家
			--print("id=", self._bubbleId)
			local sQueryM = string.format("select `username`, `notice_type`, `notice_info`, `itemid` from `t_user_bubble_notice` where `id` = %d", self._bubbleId)
			local errM, username, notice_type, notice_info, itemid = xlDb_Query(sQueryM)
			--print("errM=", errM)
			if (errM == 0) then
				--全服广播消息: 冒字
				local alludbid = hGlobal.uMgr:GetAllUserDBID()
				local sCmd = tostring(notice_type) .. ";" .. tostring(username) .. ";" .. tostring(notice_info) .. ";" .. tostring(itemid) .. ";"
				print(sCmd)
				hApi.xlNet_Send(alludbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_BUBBLE_NOTICE_RET,sCmd)
				
				--id自增
				self._bubbleId = self._bubbleId + 1
			end
		end
	end
	
return BubblleNoticeMgr