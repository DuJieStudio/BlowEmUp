--工会管理类
local GroupMgr = class("GroupMgr")
	
	--工会系统检测聊天龙王奖时刻表
	GroupMgr.SYSTEM_CHECK_CHAT_DRAGON_TIME =
	{
		{time = "23:59:40", },
	}
	
	--工会系统检测军团排名奖励时刻表（每周一）
	GroupMgr.SYSTEM_CHECK_RANK_TIME =
	{
		{time = "00:00:05", weekId = 1,},
	}
	
	--工会系统检测军团生成助理、踢掉助理时刻表
	GroupMgr.SYSTEM_CHECK_TIME =
	{
		{time = "00:01:00", },
	}
	
	--工会系统检测军团自动解除申请人时刻表
	GroupMgr.SYSTEM_CHECK_GROUP_AUTOFIRE_TIME =
	{
		{time = "00:02:00", },
	}
	
	--工会系统检测军团踢掉军团玩家（系统军团、普通军团）时刻表
	GroupMgr.SYSTEM_CHECK_GROUP_KICK_SYSTEM_PLAYER_TIME =
	{
		{time = "00:03:00", },
	}
	
	--工会系统检测军团转让、军团解散时刻表
	GroupMgr.SYSTEM_CHECK_GROUP_TRANSFER_TIME =
	{
		{time = "00:04:00", },
	}
	
	--工会系统检测军团活跃活动时刻表
	GroupMgr.SYSTEM_CHECK_GROUP_ACTIVITY_TIME =
	{
		{time = "00:05:00", },
	}
	
	--军团活跃活动id
	GroupMgr.ACTIVITY_ID = 10027
	
	--军团排行榜类型
	GroupMgr.RANKBOARD_ID = 100
	GroupMgr.RANKBOARD_TYPE = 2
	
	--军团排名奖励
	GroupMgr.RANKBOARD_PRIZE_TYPE = hVar.REWARD_LOG_TYPE.groupWeekDonateRank --20037: 军团本周声望排名奖励
	GroupMgr.RANKBOARD_PRIZE_LIST =
	{
		{from = 1, to = 1, reward = {
				prize_admin = "1:75000:0:0;20:1500:0:0;10:12406:0:0;10:12406:0:0;10:12406:0:0;", --军团会长的奖励
				prize_assistant = "1:50000:0:0;20:1000:0:0;10:12406:0:0;10:12406:0:0;", --军团助理的奖励
				prize_member = "1:50000:0:0;20:1000:0:0;10:12406:0:0;10:12406:0:0;", --军团成员的奖励
			},
		},
		{from = 2, to = 3, reward = {
				prize_admin = "1:60000:0:0;20:1200:0:0;", --军团会长的奖励
				prize_assistant = "1:40000:0:0;20:800:0:0;", --军团助理的奖励
				prize_member = "1:40000:0:0;20:800:0:0;", --军团成员的奖励
			},
		},
		{from = 4, to = 10, reward = {
				prize_admin = "1:45000:0:0;20:900:0:0;", --军团会长的奖励
				prize_assistant = "1:30000:0:0;20:600:0:0;", --军团助理的奖励
				prize_member = "1:30000:0:0;20:600:0:0;", --军团成员的奖励
			},
		},
		{from = 11, to = 20, reward = {
				prize_admin = "1:30000:0:0;20:600:0:0;", --军团会长的奖励
				prize_assistant = "1:20000:0:0;20:400:0:0;", --军团助理的奖励
				prize_member = "1:20000:0:0;20:400:0:0;", --军团成员的奖励
			},
		},
		{from = 21, to = 50, reward = {
				prize_admin = "1:15000:0:0;20:300:0:0;", --军团会长的奖励
				prize_assistant = "1:10000:0:0;20:200:0:0;", --军团助理的奖励
				prize_member = "1:10000:0:0;20:200:0:0;", --军团成员的奖励
			},
		},
		{from = 51, to = 100, reward = {
				prize_admin = "1:7500:0:0;20:150:0:0;", --军团会长的奖励
				prize_assistant = "1:5000:0:0;20:100:0:0;", --军团助理的奖励
				prize_member = "1:5000:0:0;20:100:0:0;", --军团成员的奖励
			},
		},
	}
	
	--军团个人本周捐献奖励
	GroupMgr.RANKBOARD_PRIZE_TYPE_SINGLE = hVar.REWARD_LOG_TYPE.groupWeekDonateMax --20038: 军团本周声望第一名奖励
	GroupMgr.RANKBOARD_SHENGWANGWEEK_MIN_SINGLE = 500 --需要的最小本周声望
	
	--构造函数
	function GroupMgr:ctor()
		self._groupList = -1 --工会表
		self._groupUserList = -1 --工会玩家表
		self._groupSystemList = -1 --系统工会表
		
		--其他
		self._statisticsTime = -1	--统计计时
		self._statisticsTimestamp = -1	--上次统计时间
		
		return self
	end
	
	--初始化
	function GroupMgr:Init()
		--初始表
		self._groupList = {}
		self._groupUserList = {}
		self._groupSystemList = {} --系统工会表
		
		--从数据库读取全部工会信息
		local sQueryM = string.format("SELECT `id`, `is_system` FROM `novicecamp_list` WHERE `dissolution` = %d", 0)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print("从数据库读取全部工会信息:", "errM=", errM, "tTemp=", #tTemp)
		if (errM == 0) then
			--逆向初始化
			for n = #tTemp, 1, -1 do
				local id = tTemp[n][1] --工会id
				local is_system = tTemp[n][2] --是否为系统军团
				--print(id)
				
				self._groupList[id] = {}
				
				--系统军团
				if (is_system == 1) then
					self._groupSystemList[id] = 1
				else
					self._groupSystemList[id] = 0
				end
			end
		end
		
		--从数据库读取全部工会玩家信息
		local sQueryM = string.format("SELECT `uid`, `ncid`, `level` FROM `novicecamp_member` WHERE `level` >  %d", 0)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print("从数据库读取全部工会玩家信息:", "errM=", errM, "tTemp=", #tTemp)
		if (errM == 0) then
			--逆向初始化
			for n = #tTemp, 1, -1 do
				local uid = tTemp[n][1] --玩家uid
				local ncid = tTemp[n][2] --工会id
				local level = tTemp[n][3] --权限
				--print(uid, ncid, level)
				
				if self._groupList[ncid] then
					self._groupList[ncid][uid] = level
					self._groupUserList[uid] = ncid
				end
			end
		end
		
		--其他
		self._statisticsTime = hApi.GetClock()	--统计计时
		self._statisticsTimestamp = os.time()	--上次统计时间
		
		return self
	end
	
	--release
	function GroupMgr:Release()
		self._groupList = -1 --工会表
		self._groupUserList = -1 --工会玩家表
		self._groupSystemList = -1 --系统工会表
		
		--其他
		self._statisticsTime = -1	--统计计时
		self._statisticsTimestamp = -1	--上次统计时间
		
		return self
	end
	
	--获取全部工会列表
	function GroupMgr:GetGroupList()
		return self._groupList
	end
	
	--[[
	--获取全部工会玩家列表
	function GroupMgr:GetGroupUserList()
		return self._groupUserList
	end
	]]
	
	--获取玩家所在的工会id
	function GroupMgr:GetUserGroupID(uid)
		local groupId = 0
		
		if self._groupUserList[uid] then
			groupId = self._groupUserList[uid]
		end
		
		return groupId
	end
	
	--获取玩家所在的工会等级
	function GroupMgr:GetUserGroupLevel(uid)
		local groupLevel = 0
		
		if self._groupUserList[uid] then
			local groupId = self._groupUserList[uid]
			if (groupId > 0) then
				groupLevel = self._groupList[groupId][uid]
			end
		end
		
		return groupLevel
	end
	
	--获得指定工会的玩家列表
	function GroupMgr:GetGroupAllUser(groupId)
		if self._groupList[groupId] then
			return self._groupList[groupId]
		end
	end
	
	--新增工会
	function GroupMgr:_CreateGroup(groupId, is_system)
		if (self._groupList[groupId] == nil) then
			self._groupList[groupId] = {}
			
			--系统军团
			if (is_system == 1) then
				self._groupSystemList[groupId] = 1
			else
				self._groupSystemList[groupId] = 0
			end
		end
	end
	
	--解散工会
	function GroupMgr:_RemoveGroup(groupId)
		if self._groupList[groupId] then
			--清除工会玩家信息
			for uid, level in pairs(self._groupList[groupId]) do
				self._groupUserList[uid] = nil
			end
			
			self._groupList[groupId] = nil
			self._groupSystemList[groupId] = nil
		end
	end
	
	--新增工会成员
	function GroupMgr:_AddGroupUser(groupId, uid, level)
		if self._groupList[groupId] then
			self._groupList[groupId][uid] = level
			self._groupUserList[uid] = groupId
		end
	end
	
	--踢掉工会成员
	function GroupMgr:RemoveGroupUser(groupId, uid)
		if self._groupList[groupId] then
			self._groupList[groupId][uid] = nil
			self._groupUserList[uid] = nil
		end
	end
	
	--更新工会成员
	function GroupMgr:UpdateGroupUser(groupId, uid, level)
		if self._groupList[groupId] then
			self._groupList[groupId][uid] = level
			self._groupUserList[uid] = groupId
		end
	end
	
	--发送工会消息
	function GroupMgr:SendGroupMessage(groupId, masterUId)
	end
	
	--获得玩家名
	function GroupMgr:_GetUserName(uid)
		local name = ""
		local sQueryM = string.format("SELECT `customS1` FROM `t_user` WHERE `uid` = %d", uid)
		local errM, customS1 = xlDb_Query(sQueryM)
		if (errM == 0) then
			name = customS1
		end
		
		return name
	end
	
	--标记玩家最近加入军团的时间
	function GroupMgr:_SetUserEnterGroupTime(iNcId, uid)
		local sSql = string.format("UPDATE `t_chat_user` SET `last_group_enter_time` = NOW() WHERE `uid` = %d", uid)
		xlDb_Execute(sSql)
	end
	
	--标记玩家最近离开军团的时间
	function GroupMgr:_SetUserLeaveGroupTime(iNcId, uid)
		--如果是系统军团，离开军团不修改时间
		local is_system = self._groupSystemList[iNcId]
		if (is_system == 1) then --系统军团
			--
		else
			local sSql = string.format("UPDATE `t_chat_user` SET `last_group_leave_time` = NOW() WHERE `uid` = %d", uid)
			xlDb_Execute(sSql)
		end
	end
	
	--标记任命助理的时间
	function GroupMgr:_SetAssistantTime(iNcId)
		local sSql = string.format("UPDATE `novicecamp_list` SET `last_assistant_time` = NOW() WHERE `id` = %d", iNcId)
		xlDb_Execute(sSql)
	end
	
	--标记取消助理任命的时间
	function GroupMgr:_SetAssistantCancelTime(iNcId)
		local sSql = string.format("UPDATE `novicecamp_list` SET `last_cancel_assistant_time` = NOW() WHERE `id` = %d", iNcId)
		xlDb_Execute(sSql)
	end
	
	--增加助理今日操作加人的次数
	function GroupMgr:AddAssistantOpNum(iNcId, uid)
		local opNum = 0
		
		local sQueryCU = string.format("SELECT `last_op_num`, `last_op_time` FROM `novicecamp_member` WHERE `uid` = %d and `ncid` = %d", uid, iNcId)
		local errCU, last_op_num, last_op_time = xlDb_Query(sQueryCU)
		if (errCU == 0) then --查询成功
			opNum = last_op_num
			
			--转化为服务器上次操作时间的0点天的时间戳
			local nTimestamp = hApi.GetNewDate(last_op_time)
			local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --转字符串(年月日)
			local strNewdate = strDatestampYMD .. " 00:00:00"
			local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1) -- +1天
			--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
			
			--print("strNewdate=", strNewdate)
			--print("nTimestampTodayZero=", nTimestampTodayZero)
			--print("nTimestampTomorrowZero=", nTimestampTomorrowZero)
			
			--今日时间戳
			local nTimestampNow = os.time()
			--print("nTimestampNow=", nTimestampNow)
			
			--到了第二天
			--if (nTimestampNow >= nTimestampTodayZero) and (nTimestampNow < nTimestampTomorrowZero) then
			if (nTimestampNow >= nTimestampTodayZero) then
				--print("到了第二天")
				opNum = 0
			end
		end
		
		local newOpNum = opNum + 1
		
		local sSql = string.format("UPDATE `novicecamp_member` SET `last_op_num` = %d, `last_op_time` = NOW() WHERE `uid` = %d and `ncid` = %d", newOpNum, uid, iNcId)
		xlDb_Execute(sSql)
	end
	
	--增加助理今日操作踢人的次数
	function GroupMgr:AddAssistantKickNum(iNcId, uid)
		local kickNum = 0
		
		local sQueryCU = string.format("SELECT `last_kick_num`, `last_kick_time` FROM `novicecamp_member` WHERE `uid` = %d and `ncid` = %d", uid, iNcId)
		local errCU, last_kick_num, last_kick_time = xlDb_Query(sQueryCU)
		if (errCU == 0) then --查询成功
			kickNum = last_kick_num
			
			--转化为服务器上次操作时间的0点天的时间戳
			local nTimestamp = hApi.GetNewDate(last_kick_time)
			local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --转字符串(年月日)
			local strNewdate = strDatestampYMD .. " 00:00:00"
			local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1) -- +1天
			--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
			
			--print("strNewdate=", strNewdate)
			--print("nTimestampTodayZero=", nTimestampTodayZero)
			--print("nTimestampTomorrowZero=", nTimestampTomorrowZero)
			
			--今日时间戳
			local nTimestampNow = os.time()
			--print("nTimestampNow=", nTimestampNow)
			
			--到了第二天
			--if (nTimestampNow >= nTimestampTodayZero) and (nTimestampNow < nTimestampTomorrowZero) then
			if (nTimestampNow >= nTimestampTodayZero) then
				--print("到了第二天")
				kickNum = 0
			end
		end
		
		local newKickNum = kickNum + 1
		
		local sSql = string.format("UPDATE `novicecamp_member` SET `last_kick_num` = %d, `last_kick_time` = NOW() WHERE `uid` = %d and `ncid` = %d", newKickNum, uid, iNcId)
		xlDb_Execute(sSql)
	end
	
	--获取玩家加入军团的时间（单位: 秒）
	function GroupMgr:GetUserEnterTime(iNcId, uid)
		local enterLastTime = 0
		
		local sQueryCU = string.format("SELECT `last_group_enter_time` FROM `t_chat_user` WHERE `uid` = %d", uid)
		local errCU, last_group_enter_time = xlDb_Query(sQueryCU)
		if (errCU == 0) then --查询成功
			local entertime = hApi.GetNewDate(last_group_enter_time)
			local currenttimestamp = os.time()
			enterLastTime = currenttimestamp - entertime
		end
		
		return enterLastTime
	end
	
	--获取玩家离开军团的时间（单位: 秒）
	function GroupMgr:GetUserLeaveTime(iNcId, uid)
		local leaveLastTime = 0
		
		local sQueryCU = string.format("SELECT `last_group_leave_time` FROM `t_chat_user` WHERE `uid` = %d", uid)
		--print(sQueryCU)
		local errCU, last_group_leave_time = xlDb_Query(sQueryCU)
		if (errCU == 0) then --查询成功
			local leavetime = hApi.GetNewDate(last_group_leave_time)
			local currenttimestamp = os.time()
			leaveLastTime = currenttimestamp - leavetime
		end
		
		return leaveLastTime
	end
	
	--获得军团任命助理取消的时间（单位: 秒）
	function GroupMgr:GetAssistantCancelTime(iNcId)
		local assistantLastTime = 0
		
		local sQueryCU = string.format("SELECT `last_cancel_assistant_time` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", iNcId)
		local errCU, last_cancel_assistant_time = xlDb_Query(sQueryCU)
		if (errCU == 0) then --查询成功
			local assisttime = hApi.GetNewDate(last_cancel_assistant_time)
			local currenttimestamp = os.time()
			assistantLastTime = currenttimestamp - assisttime
		end
		
		return assistantLastTime
	end
	
	--获取助理今日操作加人的次数
	function GroupMgr:GetAssistantOpNum(iNcId, uid)
		local opNum = 0
		
		local sQueryCU = string.format("SELECT `last_op_num`, `last_op_time` FROM `novicecamp_member` WHERE `uid` = %d and `ncid` = %d", uid, iNcId)
		local errCU, last_op_num, last_op_time = xlDb_Query(sQueryCU)
		if (errCU == 0) then --查询成功
			opNum = last_op_num
			
			--转化为服务器上次操作时间的0点天的时间戳
			local nTimestamp = hApi.GetNewDate(last_op_time)
			local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --转字符串(年月日)
			local strNewdate = strDatestampYMD .. " 00:00:00"
			local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1) -- +1天
			--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
			
			--print("strNewdate=", strNewdate)
			--print("nTimestampTodayZero=", nTimestampTodayZero)
			--print("nTimestampTomorrowZero=", nTimestampTomorrowZero)
			
			--今日时间戳
			local nTimestampNow = os.time()
			--print("nTimestampNow=", nTimestampNow)
			
			--到了第二天
			--if (nTimestampNow >= nTimestampTodayZero) and (nTimestampNow < nTimestampTomorrowZero) then
			if (nTimestampNow >= nTimestampTodayZero) then
				opNum = 0
			end
		end
		
		return opNum
	end
	
	--获取助理今日操作替人的次数
	function GroupMgr:GetAssistantKickNum(iNcId, uid)
		local kickNum = 0
		
		local sQueryCU = string.format("SELECT `last_kick_num`, `last_kick_time` FROM `novicecamp_member` WHERE `uid` = %d and `ncid` = %d", uid, iNcId)
		local errCU, last_kick_num, last_kick_time = xlDb_Query(sQueryCU)
		if (errCU == 0) then --查询成功
			kickNum = last_kick_num
			
			--转化为服务器上次操作时间的0点天的时间戳
			local nTimestamp = hApi.GetNewDate(last_kick_time)
			local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --转字符串(年月日)
			local strNewdate = strDatestampYMD .. " 00:00:00"
			local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1) -- +1天
			--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
			
			--print("strNewdate=", strNewdate)
			--print("nTimestampTodayZero=", nTimestampTodayZero)
			--print("nTimestampTomorrowZero=", nTimestampTomorrowZero)
			
			--今日时间戳
			local nTimestampNow = os.time()
			--print("nTimestampNow=", nTimestampNow)
			
			--到了第二天
			--if (nTimestampNow >= nTimestampTodayZero) and (nTimestampNow < nTimestampTomorrowZero) then
			if (nTimestampNow >= nTimestampTodayZero) then
				kickNum = 0
			end
		end
		
		return kickNum
	end
	
	--事件: 创建工会
	function GroupMgr:OnCreateGroup(groupId, masterUId, level)
		--添加工会和成员信息
		self:_CreateGroup(groupId)
		self:_AddGroupUser(groupId, masterUId, level)
		
		--标记玩家最近加入军团的时间
		self:_SetUserEnterGroupTime(groupId, masterUId)
		
		--发送军团消息
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --军团系统提示消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_CREATE"], self:_GetUserName(masterUId))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--发送世界消息
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE --提示类系统消息
		local content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_CREATE_WORLD"], self:_GetUserName(masterUId), groupName)
		local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
		hGlobal.chatMgr:SendSystemMessage(sysMsgtype, content, strDate)
	end
	
	--事件: 解散工会
	function GroupMgr:OnRemoveGroup(groupId, masterUId)
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		--标记原工会全部成员的离开时间
		for uid, level in pairs(self._groupList[groupId]) do
			--标记玩家最近离开军团的时间
			self:_SetUserLeaveGroupTime(groupId, uid)
			
			--发送邮件通知
			if (masterUId ~= uid) then --会长主动操作的解散工会，除会长外通知其他人
				local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_DISOLUTE"], groupName)
				NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
			end
		end
		
		--移除工会和成员信息
		self:_RemoveGroup(groupId)
		
		--发送军团消息
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_WARNING --军团系统警告消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_REMOVE"], self:_GetUserName(masterUId))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--发送世界消息
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_WARNING --警告类系统消息
		local content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_REMOVE_WORLD"], groupName, self:_GetUserName(masterUId))
		local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
		hGlobal.chatMgr:SendSystemMessage(sysMsgtype, content, strDate)
	end
	
	--事件: 解散工会（管理员）
	function GroupMgr:OnRemoveGroup_Admin(groupId, masterUId)
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		--标记原工会全部成员的离开时间
		for uid, level in pairs(self._groupList[groupId]) do
			--标记玩家最近离开军团的时间
			self:_SetUserLeaveGroupTime(groupId, uid)
			
			--发送邮件通知（只剩会长1人）
			local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_DISOLUTE_OFFLINE"], groupName)
			NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
		end
		
		--移除工会和成员信息
		self:_RemoveGroup(groupId)
		
		--发送军团消息
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_WARNING --军团系统警告消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = hVar.tab_string["__TEXT_CHAT_GROUP_REMOVE_ADMIN"]
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--发送世界消息
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_WARNING --警告类系统消息
		local content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_REMOVE_ADMIN_WORLD"], groupName, self:_GetUserName(masterUId))
		local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
		hGlobal.chatMgr:SendSystemMessage(sysMsgtype, content, strDate)
	end
	
	--事件: 添加工会成员
	function GroupMgr:OnAddGroupMember(groupId, masterUId, uid, level, iLevelOp)
		--添加工会和成员信息
		self:_AddGroupUser(groupId, uid, level)
		
		--标记玩家最近加入军团的时间
		self:_SetUserEnterGroupTime(groupId, uid)
		
		--发送军团消息
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --军团系统提示消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ADD_MEMBER"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--发送邮件通知
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		local strAythen = ""
		if(iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --会长
			strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_ADMIN"]
		elseif(iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) then --助理
			strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_ASSIST"]
		elseif(iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --助理（系统）
			strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_ASSIST"]
		else --成员
			--
		end
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_APPLY_ACCEPT"], groupName, strAythen)
		local is_system = self._groupSystemList[groupId]
		if (is_system == 1) then --系统军团
			sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_APPLY_ACCEPT_SYSTEM"], groupName)
		end
		NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
	end
	
	--事件: 通过军团邀请函加人工会成员
	function GroupMgr:OnAddGroupInviteMember(groupId, masterUId, uid, level)
		--添加工会和成员信息
		self:_AddGroupUser(groupId, uid, level)
		
		--标记玩家最近加入军团的时间
		self:_SetUserEnterGroupTime(groupId, uid)
		
		--发送军团消息
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --军团系统提示消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_INBITE_ADD_MEMBER"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--发送邮件通知
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_APPLY_INVITE_ACCEPT"], groupName)
		NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
	end
	
	--事件: 踢掉工会成员
	function GroupMgr:OnRemoveGroupMember(groupId, masterUId, uid, iLevelOp)
		--移除工会和成员信息
		self:RemoveGroupUser(groupId, uid)
		
		--标记玩家最近离开军团的时间
		self:_SetUserLeaveGroupTime(groupId, uid)
		
		--print("OnRemoveGroupMember", groupId, masterUId, uid)
		--发送军团消息
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_WARNING --军团系统警告消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_REMOVE_MEMBER_ADMIN"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		
		--助理操作提示
		if (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --助理
			tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_REMOVE_MEMBER_ASSIST"], self:_GetUserName(uid))
		end
		
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--发送邮件通知
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		local strAythen = ""
		if(iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --会长
			strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_ADMIN"]
		elseif(iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) then --助理
			strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_ASSIST"]
		elseif(iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --助理（系统）
			strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_ASSIST"]
		else --成员
			--
		end
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_KICK"], strAythen, groupName)
		NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
	end
	
	--事件: 成员退出工会
	function GroupMgr:OnLeaveGroupMember(groupId, uid)
		--移除工会和成员信息
		self:RemoveGroupUser(groupId, uid)
		
		--标记玩家最近离开军团的时间
		self:_SetUserLeaveGroupTime(groupId, uid)
		
		--发送军团消息
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_WARNING --军团系统警告消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_LEAVE_MEMBER"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
	end
	
	--事件: 踢出长期未登录的工会成员（仅管理员可操作）
	function GroupMgr:OnKickOfflineGroupMember(groupId, adminUid, uid)
		--移除工会和成员信息
		self:RemoveGroupUser(groupId, uid)
		
		--标记玩家最近离开军团的时间
		self:_SetUserLeaveGroupTime(groupId, uid)
		
		--print("OnKickOfflineGroupMember", groupId, masterUId, uid)
		--发送军团消息
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_WARNING --军团系统警告消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_REMOVE_MEMBER_OFFLINE"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--发送邮件通知
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_KICK_OFFLINE"], groupName)
		NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
	end
	
	--事件: 任命玩家为会长（仅管理员可操作）
	function GroupMgr:OnAssetAdminGroupMember(groupId, adminUid, assistUid)
		--更新成员信息
		self:UpdateGroupUser(groupId, adminUid, hVar.GROUP_MEMBER_AUTORITY.NORMAL)
		
		--更新成员信息
		self:UpdateGroupUser(groupId, assistUid, hVar.GROUP_MEMBER_AUTORITY.ADMIN)
		
		--print("OnAssetAdminGroupMember", groupId, masterUId, uid)
		--发送军团消息
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --军团系统提示消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ASSET_ADMIN"], self:_GetUserName(assistUid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--发送世界消息
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE --提示类系统消息
		local content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ASSET_ADMIN_WORLD"], self:_GetUserName(assistUid), groupName)
		local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
		hGlobal.chatMgr:SendSystemMessage(sysMsgtype, content, strDate)
		
		--发送邮件通知
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_ASSISTANT_TRANSFER_SYSTEM"], groupName)
		NoviceCampMgr.private.Data_InsertMyNcPrize(assistUid, 20033, sKey, groupId)
	end
	
	--事件: 军团会长转让给助理
	function GroupMgr:OnTranfserGroupMember(groupId, adminUid, assistUid)
		--更新成员信息
		self:UpdateGroupUser(groupId, adminUid, hVar.GROUP_MEMBER_AUTORITY.NORMAL)
		
		--更新成员信息
		self:UpdateGroupUser(groupId, assistUid, hVar.GROUP_MEMBER_AUTORITY.ADMIN)
		
		--print("OnTranfserGroupMember", groupId, masterUId, uid)
		--发送军团消息
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --军团系统提示消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_TRANSFER"], self:_GetUserName(assistUid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--发送世界消息
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE --提示类系统消息
		local content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_TRANSFER_WORLD"], groupName, self:_GetUserName(assistUid))
		local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
		hGlobal.chatMgr:SendSystemMessage(sysMsgtype, content, strDate)
		
		--发送邮件通知
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_ASSISTANT_TRANSFER"], groupName)
		NoviceCampMgr.private.Data_InsertMyNcPrize(assistUid, 20033, sKey, groupId)
	end
	
	--事件: 会长任命助理
	function GroupMgr:OnAssistantGroupMember(groupId, masterUId, uid, iLevel)
		--print("OnAssistantGroupMember", groupId, masterUId, uid)
		--更新成员信息
		self:UpdateGroupUser(groupId, uid, iLevel)
		
		--标记军团任命助理的时间
		self:_SetAssistantTime(groupId)
		
		--发送军团消息
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --军团系统提示消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ASSISTANT_MEMBER"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--发送邮件通知
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_ASSISTANT"], groupName)
		NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
	end
	
	--事件: 系统任命助理（系统）
	function GroupMgr:OnSystemAssistantGroupMember(groupId, masterUId, uid, iLevel)
		--print("OnSystemAssistantGroupMember", groupId, masterUId, uid)
		--更新成员信息
		self:UpdateGroupUser(groupId, uid, iLevel)
		
		--标记军团任命助理（系统）的时间
		self:_SetAssistantTime(groupId)
		
		--发送军团消息
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --军团系统提示消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ASSISTANT_SYSTEN_MEMBER"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--[[
		--发送世界消息
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE --提示类系统消息
		local content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ASSISTANT_SYSTEN_MEMBER_WORLD"], self:_GetUserName(uid), groupName)
		local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
		hGlobal.chatMgr:SendSystemMessage(sysMsgtype, content, strDate)
		]]
		
		--发送邮件通知
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_ASSISTANT_SYSTEM"], groupName)
		NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
	end
	
	--事件: 会长取消任命助理
	function GroupMgr:OnAssistantCancelGroupMember(groupId, masterUId, uid, iLevel)
		--print("OnAssistantGroupMember", groupId, masterUId, uid)
		
		--更新成员信息
		self:UpdateGroupUser(groupId, uid, iLevel)
		
		--标记取消军团任命助理的时间
		self:_SetAssistantCancelTime(groupId)
		
		--发送军团消息
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_WARNING --军团系统警告消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ASSISTANT_CANCEL_MEMBER"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--发送邮件通知
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_ASSISTANT_CANCEL"], groupName)
		NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
	end
	
	--事件: 退出军团取消任命助理
	function GroupMgr:OnAssistantLeaveGroupMember(groupId, uid, iLevel)
		--print("OnAssistantLeaveGroupMember", groupId, uid)
		
		--更新成员信息
		self:UpdateGroupUser(groupId, uid, iLevel)
		
		--标记取消军团任命助理的时间
		self:_SetAssistantCancelTime(groupId)
		
		--发送军团消息
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_WARNING --军团系统警告消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ASSISTANT_LEAVE_MEMBER"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
	end
	
	--事件: 系统取消任命助理
	function GroupMgr:OnAssistantSystenCancelGroupMember(groupId, masterUId, uid, iLevel)
		--print("OnAssistantGroupMember", groupId, masterUId, uid)
		
		--更新成员信息
		self:UpdateGroupUser(groupId, uid, iLevel)
		
		--标记取消军团任命助理（系统）的时间
		self:_SetAssistantCancelTime(groupId)
		
		--发送军团消息
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_WARNING --军团系统警告消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ASSISTANT_SYSTEM_CANCEL_MEMBER"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--[[
		--发送世界消息
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_WARNING --警告类系统消息
		local content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ASSISTANT_SYSTEN_CANCEL_MEMBER_WORLD"], self:_GetUserName(uid), groupName)
		local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
		hGlobal.chatMgr:SendSystemMessage(sysMsgtype, content, strDate)
		]]
		
		--发送邮件通知
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_ASSISTANT_SYSTEM_CANCEL"], groupName)
		NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
	end
	
	--事件: 修改工会名
	function GroupMgr:OnModifyGroupName(groupId, masterUId, newName)
		--发送军团消息
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --军团系统提示消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_MODIFY_NAME"], newName)
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
	end
	
	--事件: 修改工会简介
	function GroupMgr:OnModifyGroupIntroduce(groupId, masterUId, userAuthen, newIntroduce)
		--print("OnModifyGroupIntroduce",groupId, masterUId, newIntroduce)
		--发送军团消息
		local strText = ""
		if (userAuthen == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --会长
			strText = hVar.tab_string["__TEXT_CHAT_GROUP_MODIFY_INTRODUCE_ADMIN"]
		elseif (userAuthen == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (userAuthen == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --助理
			strText = hVar.tab_string["__TEXT_CHAT_GROUP_MODIFY_INTRODUCE_ASSIST"]
		end
		
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --军团系统提示消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = strText
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
	end
	
	--事件: 工会建筑升级
	function GroupMgr:OnGroupBuildingLevelUp(groupId, buildId, newLevel)
		--发送军团消息
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --军团系统提示消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_BUILDING_LEVELUP"], hVar.tab_stringU[buildId] or hVar.tab_stringU[0], newLevel)
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
	end
	
	--事件: 会长购买副本次数
	function GroupMgr:OnGroupBuyBattleCount(groupId, masterUId, userAuthen, count)
		--发送军团消息
		local strText = ""
		if (userAuthen == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --会长
			strText = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_BUY_BATTLE_COUNT_ADMIN"], count)
		elseif (userAuthen == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (userAuthen == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --助理
			strText = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_BUY_BATTLE_COUNT_ASSIST"], count)
		end
		
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_TODAY --军团系统今日消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = strText
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--geyachao: 不再发世界消息了
		--[[
		--发送世界消息
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE --提示类系统消息
		local content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_BUY_BATTLE_COUNT_WORLD"], groupName)
		local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
		hGlobal.chatMgr:SendSystemMessage(sysMsgtype, content, strDate)
		]]
	end
	
	--事件：发放军团每周排名奖励
	function GroupMgr:OnGroupWeekDonateSend(groupId, groupName, shengwangWeekSum, rank)
		--发送军团消息
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --军团系统提示消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_SHENGWANG_WEEK_DONATE"], shengwangWeekSum, rank)
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
	end
	
	--事件：发放军团个人本周声望最高荣誉奖
	function GroupMgr:OnGroupWeekDonateSumSingle(groupId, uid, maxShengwangWeek)
		--发送军团消息
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --军团系统提示消息
		tMsg.uid = 0
		tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
		tMsg.channelId = 0
		tMsg.vip = 0
		tMsg.borderId = 1000
		tMsg.iconId = 1000
		tMsg.championId = 0
		tMsg.leaderId = 0
		tMsg.dragonId = 0
		tMsg.headId = 0
		tMsg.lineId = 0
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_SHENGWANGWEEK_DOTAME_MAX"], self:_GetUserName(uid), maxShengwangWeek)
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
	end
	
	--事件: 军团发红包
	function GroupMgr:OnGroupSendRedPacket(groupId, uid, tMsg)
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
	end
	
	--事件: 军团收红包
	function GroupMgr:OnGroupReceiveRedPacket(groupId, uid, tMsg)
		--发送军团消息
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
	end
	
	--工会更新(10秒)
	function GroupMgr:Update()
		local self = hGlobal.groupMgr --self
		
		--输出信息
		local timeNow = hApi.GetClock()
		if (self._statisticsTime > -1) and (timeNow - self._statisticsTime > 10000) then --10秒
			local lasttimestamp = self._statisticsTimestamp
			local currenttimestamp = os.time()
			
			self._statisticsTime = timeNow
			self._statisticsTimestamp = currenttimestamp
			
			--检测是否自动生成助理、自动踢掉助理
			local sDate = os.date("%Y-%m-%d", currenttimestamp)
			for i = 1, #GroupMgr.SYSTEM_CHECK_TIME, 1 do
				local sRefreshTime = GroupMgr.SYSTEM_CHECK_TIME[i].time
				local refresh_time = sDate .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					
					print("检测是否自动生成协助管理: " .. sDate)
					hGlobal.fileWriter:Write("检测是否自动生成协助管理: " .. sDate)
					
					--检测是否自动生成助理
					for groupId, tv in pairs(self._groupList) do
						--不是系统军团
						local is_system = self._groupSystemList[groupId]
						if (is_system ~= 1) then
							local adminUID = 0 --会长uid
							local assistantUID = 0 --助理uid
							
							for uid, level in pairs(tv) do
								if(level == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --会长
									adminUID = uid
								elseif(level == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) then --助理
									assistantUID = uid
								elseif(level == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --助理（系统）
									assistantUID = uid
								end
							end
							
							--不存在助理，才需要检测
							--print("groupId=" .. groupId, "adminUID=" .. adminUID, "assistantUID=" .. assistantUID)
							if (assistantUID == 0) then
								--print("    不存在助理")
								--会长不在线才需要检测
								local userAdmin = hGlobal.uMgr:FindChatUserByDBID(adminUID)
								if (not userAdmin) then
									--查询会长上次登录时间
									--local strLastLoginTime = ""
									local sQueryM = string.format("SELECT `last_login_time` FROM `t_user` WHERE `uid` = %d", adminUID)
									local errM, strLastLoginTime = xlDb_Query(sQueryM)
									--print("查询会长上次登录时间:", "errM=", errM, "strLastLoginTime=", strLastLoginTime)
									if (errM == 0) then
										local lastlogintime = hApi.GetNewDate(strLastLoginTime)
										--local currenttimestamp = os.time()
										local loginLastTime = currenttimestamp - lastlogintime
										if (loginLastTime > 604800) then --会长7天未登录
											--print("    会长7天未登录")
											--查询此军团创建的时间
											local sQueryM = string.format("SELECT `time_create`, `buildinfo` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
											local errM, strLastCreateTime, buildinfo = xlDb_Query(sQueryM)
											if (errM == 0) then
												local lastcreatetime = hApi.GetNewDate(strLastCreateTime)
												--local currenttimestamp = os.time()
												local createLastTime = currenttimestamp - lastcreatetime
												if (createLastTime > 2592000) then --创建军团达到30天
													--print("    创建军团大于30天")
													local townId = 80068 --主城id
													local townLv = 0 --主城等级
													local tmp = "local strCfg = ".. tostring(buildinfo) .. " return strCfg"
													local tBuildInfo = assert(loadstring(tmp))()
													if (type(tBuildInfo) == "table") then
														local buildlist = tBuildInfo.buildlist
														if buildlist then
															for i = 1, #buildlist, 1 do
																if (buildlist[i].id == townId) then --找到了
																	townLv = buildlist[i].lv
																	break
																end
															end
														end
													end
													if (townLv >= 3) then --主城达到3级
														--print("    主城达到3级")
														
														--统计每个成员的贡献值
														local tDonation = {}
														for uid, level in pairs(tv) do
															if(level == hVar.GROUP_MEMBER_AUTORITY.NORMAL) then --普通成员
																--初始化
																local donationSum = 0
																
																local sQueryM = string.format("SELECT `mat_iron_donate_sum`, `mat_wood_donate_sum`, `mat_food_donate_sum` FROM `novicecamp_member` WHERE `ncid`= %d AND `level` = %d AND `uid` = %d", groupId, level, uid)
																--print(sQueryM)
																local errM, mat_iron_donate_sum, mat_wood_donate_sum, mat_food_donate_sum = xlDb_Query(sQueryM)
																--print(errM)
																if (errM == 0) then
																	donationSum = mat_iron_donate_sum * 2 + mat_wood_donate_sum + mat_food_donate_sum
																end
																
																--print("        玩家贡献 [" .. uid .. "]=" .. donationSum)
																
																--贡献值达到3000
																if (donationSum >= 3000) then
																	tDonation[uid] = donationSum
																end
															end
														end
														
														--找出近7日贡献值最高的玩家
														local nDonationSevenDayValue = 0
														local nDonationSevenDayUID = 0
														for uid, donationSum in pairs(tDonation) do
															local donationSumSevenDay = 0
															
															--转化为服务器上次操作时间的0点天的时间戳
															local strDatestampYMD = hApi.Timestamp2Date(currenttimestamp) --转字符串(年月日)
															local strNewdate = strDatestampYMD .. " 00:00:00"
															local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", -7) -- -7天
															local strTimestampTodayZero = os.date("%Y-%m-%d %H:%M:%S", nTimestampTodayZero)
															--print(strTimestampTodayZero)
															local sQueryM = string.format("SELECT `mat_iron_donate`, `mat_wood_donate`, `mat_food_donate` FROM `novicecamp_member_donate_log` WHERE `ncid`= %d AND `uid` = %d and `time` >= '%s'", groupId, uid, strTimestampTodayZero)
															local errM, tTemp = xlDb_QueryEx(sQueryM)
															--print("从数据库读取捐献列表:", "errM=", errM, "tTemp=", #tTemp)
															if (errM == 0) then
																for n = 1, #tTemp, 1 do
																	local mat_iron_donate = tTemp[n][1] --铁
																	local mat_wood_donate = tTemp[n][2] --木材
																	local mat_food_donate = tTemp[n][3] --粮食
																	--print(id)
																	
																	local donation = mat_iron_donate * 2 + mat_wood_donate + mat_food_donate
																	donationSumSevenDay = donationSumSevenDay + donation
																end
															end
															
															--print("        玩家七日贡献 [" .. uid .. "]=" .. donationSumSevenDay)
															
															--找到更高7日贡献的玩家
															if (donationSumSevenDay > nDonationSevenDayValue) then
																nDonationSevenDayValue = donationSumSevenDay
																nDonationSevenDayUID = uid
															end
														end
														
														--print("    近7日贡献值最高的玩家="..nDonationSevenDayUID .. ", 近7日贡献值=" .. nDonationSevenDayValue)
														
														--找出了近7日贡献值最高的玩家
														if (nDonationSevenDayUID > 0) then
															local sQueryM = string.format("SELECT `last_login_time` FROM `t_user` WHERE `uid` = %d", nDonationSevenDayUID)
															local errM, strLastLoginTime = xlDb_Query(sQueryM)
															--print("    查询成员上次登录时间:", "errM=", errM, "strLastLoginTime=", strLastLoginTime)
															if (errM == 0) then
																local lastlogintime = hApi.GetNewDate(strLastLoginTime)
																--local currenttimestamp = os.time()
																local loginLastTime = currenttimestamp - lastlogintime
																if (loginLastTime <= 172800) then --成员48小时内登录过
																	--print("    成48小时内登录过")
																	
																	--恭喜成员，成为助理（系统）
																	--标记为助理（系统）
																	local sSql = string.format("UPDATE `novicecamp_member` SET `level` = %d WHERE `uid` = %d", hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM, nDonationSevenDayUID)
																	xlDb_Query(sSql)
																	
																	--通知事件
																	hGlobal.groupMgr:OnSystemAssistantGroupMember(groupId, 0, nDonationSevenDayUID, hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM)
																end
															end
														end
													end
												end
											end
										end
									end
								end
							end
							
							--存在助理，检测是否被剥夺资格
							if (assistantUID > 0) then
								--助理不在线才需要检测
								local userAssistant = hGlobal.uMgr:FindChatUserByDBID(assistantUID)
								if (not userAssistant) then
									--查询助理上次登录时间
									--local strLastLoginTime = ""
									local sQueryM = string.format("SELECT `last_login_time` FROM `t_user` WHERE `uid` = %d", assistantUID)
									local errM, strLastLoginTime = xlDb_Query(sQueryM)
									--print("查询助理上次登录时间:", "errM=", errM, "strLastLoginTime=", strLastLoginTime)
									if (errM == 0) then
										local lastlogintime = hApi.GetNewDate(strLastLoginTime)
										--local currenttimestamp = os.time()
										local loginLastTime = currenttimestamp - lastlogintime
										--print(assistantUID, loginLastTime)
										if (loginLastTime > 604800) then --助理7天未登录
											--print("    助理7天未登录")
											
											--悲剧成员，取消助理（系统）
											--取消标记为助理（系统）
											local sSql = string.format("UPDATE `novicecamp_member` SET `level` = %d WHERE `uid` = %d", hVar.GROUP_MEMBER_AUTORITY.NORMAL, assistantUID)
											xlDb_Query(sSql)
											
											--通知事件
											hGlobal.groupMgr:OnAssistantSystenCancelGroupMember(groupId, 0, assistantUID, hVar.GROUP_MEMBER_AUTORITY.NORMAL)
										end
									end
								end
							end
						end
					end
				end
			end
			
			--检测是否解除申请人
			--local sDate = os.date("%Y-%m-%d", currenttimestamp)
			for i = 1, #GroupMgr.SYSTEM_CHECK_GROUP_AUTOFIRE_TIME, 1 do
				local sRefreshTime = GroupMgr.SYSTEM_CHECK_GROUP_AUTOFIRE_TIME[i].time
				local refresh_time = sDate .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					
					print("检测是否自动解除申请人: " .. sDate)
					hGlobal.fileWriter:Write("检测是否自动解除申请人: " .. sDate)
					
					--从数据库读取全部申请人信息
					local sQueryM = string.format("SELECT `uid`, `ncid`, `time_jion` FROM `novicecamp_member` WHERE `level` = %d", 0)
					local errM, tTemp = xlDb_QueryEx(sQueryM)
					--print("从数据库读取全部申请人信息:", "errM=", errM, "tTemp=", #tTemp)
					if (errM == 0) then
						--逆向初始化
						for n = #tTemp, 1, -1 do
							local uid = tTemp[n][1] --玩家uid
							local ncid = tTemp[n][2] --工会id
							local time_jion = tTemp[n][3] --申请时间
							--print(uid, ncid, time_jion)
							
							local nTimeJoin = hApi.GetNewDate(time_jion)
							local deltatime = currenttimestamp - nTimeJoin
							if (deltatime > hVar.GROUP_APPY_AUTOFIRE_TIME) then
								print("  删除申请人[" .. uid .. "]: " .. " time_jion=" .. time_jion)
								hGlobal.fileWriter:Write("  删除申请人[" .. uid .. "]: " .. " time_jion=" .. time_jion)
								
								local sDelete = string.format("DELETE FROM `novicecamp_member` WHERE `uid` = %d", uid)
								xlDb_Execute(sDelete)
							end
						end
					end
				end
			end
			
			--检测是否踢掉军团的玩家（系统军团、普通军团）
			--local sDate = os.date("%Y-%m-%d", currenttimestamp)
			for i = 1, #GroupMgr.SYSTEM_CHECK_GROUP_KICK_SYSTEM_PLAYER_TIME, 1 do
				local sRefreshTime = GroupMgr.SYSTEM_CHECK_GROUP_KICK_SYSTEM_PLAYER_TIME[i].time
				local refresh_time = sDate .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					
					print("检测是否踢掉军团的玩家: " .. sDate)
					hGlobal.fileWriter:Write("检测是否踢掉军团的玩家: " .. sDate)
					
					--检测是否踢掉军团的玩家（系统军团、普通军团）
					for groupId, tv in pairs(self._groupList) do
						--是系统军团
						local is_system = self._groupSystemList[groupId]
						if (is_system == 1) then
							--提炼出待踢出的成员列表（系统军团）
							local tKickUIDList = {}
							local adminUID = 0
							for uid, level in pairs(tv) do
								if(level == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --会长
									adminUID = uid
								elseif(level == hVar.GROUP_MEMBER_AUTORITY.NORMAL) then --成员
									--成员不在线才需要检测
									local userMember = hGlobal.uMgr:FindChatUserByDBID(uid)
									if (not userMember) then
										--查询成员上次登录时间
										--local strLastLoginTime = ""
										local sQueryM = string.format("SELECT `last_login_time` FROM `t_user` WHERE `uid` = %d", uid)
										local errM, strLastLoginTime = xlDb_Query(sQueryM)
										--print("查询成员上次登录时间:", "errM=", errM, "strLastLoginTime=", strLastLoginTime)
										if (errM == 0) then
											local lastlogintime = hApi.GetNewDate(strLastLoginTime)
											--local currenttimestamp = os.time()
											local loginLastTime = currenttimestamp - lastlogintime
											if (loginLastTime > 604800) then --系统军团成员7天未登录
												--需要踢掉
												tKickUIDList[#tKickUIDList+1] = uid
											end
										end
									end
								end
							end
							
							--依次踢出7天未登录的玩家（系统军团）
							for k, uid in ipairs(tKickUIDList) do
								--会长踢人
								local tCmd = {ncid=groupId, uid=adminUID, uid_member=uid,}
								NoviceCampMgr.PowerFire(tCmd)
								
								print("  踢掉玩家（系统军团）: " .. uid)
								hGlobal.fileWriter:Write("  踢掉玩家（系统军团）: " .. uid)
							end
						else --是普通军团
							--提炼出待踢出的成员列表（普通军团）
							local tKickUIDList = {}
							local adminUID = 0
							for uid, level in pairs(tv) do
								if(level == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --会长
									adminUID = uid
								elseif(level == hVar.GROUP_MEMBER_AUTORITY.NORMAL) then --成员
									--成员不在线才需要检测
									local userMember = hGlobal.uMgr:FindChatUserByDBID(uid)
									if (not userMember) then
										--查询成员上次登录时间
										--local strLastLoginTime = ""
										local sQueryM = string.format("SELECT `last_login_time` FROM `t_user` WHERE `uid` = %d", uid)
										local errM, strLastLoginTime = xlDb_Query(sQueryM)
										--print("查询成员上次登录时间:", "errM=", errM, "strLastLoginTime=", strLastLoginTime)
										if (errM == 0) then
											local lastlogintime = hApi.GetNewDate(strLastLoginTime)
											--local currenttimestamp = os.time()
											local loginLastTime = currenttimestamp - lastlogintime
											if (loginLastTime > 2592000) then --普通军团成员30天未登录
												--需要踢掉
												tKickUIDList[#tKickUIDList+1] = uid
											end
										end
									end
								end
							end
							
							--依次踢出30天未登录的玩家（普通军团）
							for k, uid in ipairs(tKickUIDList) do
								--会长踢人
								NoviceCampMgr.KickGroupOfflinePlayer(1000, 0, groupId, uid)
								
								print("  踢掉玩家（普通军团）: " .. uid)
								hGlobal.fileWriter:Write("  踢掉玩家（普通军团）: " .. uid)
							end
						end
					end
				end
			end
			
			--检测是否自动转让军团，是否自动解散军团
			--local sDate = os.date("%Y-%m-%d", currenttimestamp)
			for i = 1, #GroupMgr.SYSTEM_CHECK_GROUP_TRANSFER_TIME, 1 do
				local sRefreshTime = GroupMgr.SYSTEM_CHECK_GROUP_TRANSFER_TIME[i].time
				local refresh_time = sDate .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					
					print("检测是否转让军团，是否自动解散军团: " .. sDate)
					hGlobal.fileWriter:Write("检测是否转让军团，是否自动解散军团: " .. sDate)
					
					--检测是否自动转让军团，是否自动解散军团
					for groupId, tv in pairs(self._groupList) do
						--不是系统军团
						local is_system = self._groupSystemList[groupId]
						if (is_system ~= 1) then
							local adminUID = 0 --会长uid
							local assistantUID = 0 --助理uid
							local totalNum = 0 --总成员数量
							
							for uid, level in pairs(tv) do
								--总成员数量加1
								totalNum = totalNum + 1
								
								if(level == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --会长
									adminUID = uid
								elseif(level == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) then --助理
									assistantUID = uid
								elseif(level == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --助理（系统）
									assistantUID = uid
								end
							end
							
							--会长不在线才需要检测
							local userAdmin = hGlobal.uMgr:FindChatUserByDBID(adminUID)
							if (not userAdmin) then
								--检测是否自动解散军团
								if (totalNum == 1) then --只剩会长1人
									--查询会长上次登录时间
									--local strLastLoginTime = ""
									local sQueryM = string.format("SELECT `last_login_time` FROM `t_user` WHERE `uid` = %d", adminUID)
									local errM, strLastLoginTime = xlDb_Query(sQueryM)
									--print("查询会长上次登录时间:", "errM=", errM, "strLastLoginTime=", strLastLoginTime)
									if (errM == 0) then
										local lastlogintime = hApi.GetNewDate(strLastLoginTime)
										--local currenttimestamp = os.time()
										local loginLastTime = currenttimestamp - lastlogintime
										if (loginLastTime > 2592000) then --会长30天未登录
											--解散军团（仅管理员可操作）
											NoviceCampMgr.AssetGroupDisolute(1000, 0, groupId)
											
											print("  解散军团: groupId=" .. groupId)
											hGlobal.fileWriter:Write("  解散军团: groupId=" .. groupId)
										end
									end
								end
								
								--检测是自动否转让军团
								--print("groupId=" .. groupId, "adminUID=" .. adminUID, "assistantUID=" .. assistantUID)
								if (assistantUID > 0) then --存在助理
									--print("    存在助理")
									--查询会长上次登录时间
									--local strLastLoginTime = ""
									local sQueryM = string.format("SELECT `last_login_time` FROM `t_user` WHERE `uid` = %d", adminUID)
									local errM, strLastLoginTime = xlDb_Query(sQueryM)
									--print("查询会长上次登录时间:", "errM=", errM, "strLastLoginTime=", strLastLoginTime)
									if (errM == 0) then
										local lastlogintime = hApi.GetNewDate(strLastLoginTime)
										--local currenttimestamp = os.time()
										local loginLastTime = currenttimestamp - lastlogintime
										if (loginLastTime > 2592000) then --会长30天未登录
											--print("    会长30天未登录")
											--查询此军团创建的时间
											local sQueryM = string.format("SELECT `time_create`, `buildinfo`, `last_transfer_time` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
											local errM, strLastCreateTime, buildinfo, sLastTransfertTime = xlDb_Query(sQueryM)
											if (errM == 0) then
												local lastcreatetime = hApi.GetNewDate(strLastCreateTime)
												--local currenttimestamp = os.time()
												local createLastTime = currenttimestamp - lastcreatetime
												if (createLastTime > 2592000) then --创建军团达到30天
													--print("    创建军团大于30天")
													local townId = 80068 --主城id
													local townLv = 0 --主城等级
													local tmp = "local strCfg = ".. tostring(buildinfo) .. " return strCfg"
													local tBuildInfo = assert(loadstring(tmp))()
													if (type(tBuildInfo) == "table") then
														local buildlist = tBuildInfo.buildlist
														if buildlist then
															for i = 1, #buildlist, 1 do
																if (buildlist[i].id == townId) then --找到了
																	townLv = buildlist[i].lv
																	break
																end
															end
														end
													end
													if (townLv >= 3) then --主城达到3级
														--print("    主城达到3级")
														
														--检测军团上次转让时间是否达到30天
														local lasttransferttime = hApi.GetNewDate(sLastTransfertTime)
														--local currenttimestamp = os.time()
														local transferLastTime = currenttimestamp - lasttransferttime
														if (transferLastTime > 2592000) then --上次转让军团达到30天
															--检测助理vip等级是否有权限创建军团
															local vipLv = hGlobal.vipMgr:DBGetUserVip(assistantUID) --玩家vip等级
															local bCreateGroup = hVar.Vip_Conifg.createGroup[vipLv] --是否可创建军团权限
															if bCreateGroup then
																--可以转让
																--请求任命助理为会长（仅管理员可操作）
																NoviceCampMgr.AssetAdminPlayer(1000, 0, groupId, assistantUID)
																
																print("  转让会长: groupId=" .. groupId .. ",assistantUID=" .. assistantUID)
																hGlobal.fileWriter:Write("  转让会长: groupId=" .. groupId .. ",assistantUID=" .. assistantUID)
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
			
			--检测是否发放军团活跃奖励
			--local sDate = os.date("%Y-%m-%d", currenttimestamp)
			for i = 1, #GroupMgr.SYSTEM_CHECK_GROUP_ACTIVITY_TIME, 1 do
				local sRefreshTime = GroupMgr.SYSTEM_CHECK_GROUP_ACTIVITY_TIME[i].time
				local refresh_time = sDate .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					
					print("check group activity prize: " .. sDate)
					hGlobal.fileWriter:Write("check group activity prize: ", sDate)
					
					--遍历全部活动，找出全部的军团活跃活动
					--查询活动信息
					local sQuery = string.format("select `aid`, `channel`, `prize`, `time_begin`, `time_end` from `activity_template` where `type`= %d", GroupMgr.ACTIVITY_ID)
					local iErrorCode, tTemp = xlDb_QueryEx(sQuery)
					--print("查询活动信息", iErrorCode, tTemp)
					
					if (iErrorCode == 0) then
						for n = 1, #tTemp, 1 do
							local aid = tTemp[n][1] --活动id
							local strChannel = tTemp[n][2] --有效的渠道号
							local szPrize = tTemp[n][3] --奖励字符串表
							local strBeginTime = tTemp[n][4] --活动开始时间
							local strEndTime = tTemp[n][5] --活动结束时间
							print("  找到活动[" .. n .. "]:")
							print("    aid=" .. aid)
							print("    channel=" .. tostring(strChannel))
							print("    time_begin=" .. strBeginTime)
							print("    time_end=" .. strEndTime)
							hGlobal.fileWriter:Write("  找到活动[" .. n .. "]:")
							hGlobal.fileWriter:Write("    aid=" .. aid)
							hGlobal.fileWriter:Write("    channel=" .. tostring(strChannel))
							hGlobal.fileWriter:Write("    time_begin=" .. strBeginTime)
							hGlobal.fileWriter:Write("    time_end=" .. strEndTime)
							
							--活动已结束才进行检测
							print("    检测活动是已否结束")
							hGlobal.fileWriter:Write("    检测活动是已否结束")
							local nEndTimestamp = hApi.GetNewDate(strEndTime)
							if (currenttimestamp > nEndTimestamp) then
								--检测活动是否已发过奖
								local sQueryC = string.format("select `level` from `activity_check` where `aid`= %d", aid)
								local nGetRewardFlag = 0 --是否领过奖
								local iErrorCodeC, level = xlDb_Query(sQueryC)
								print("    查询活动否是已领奖: iErrorCodeC=" .. tostring(iErrorCodeC) .. ",level=" .. tostring(level))
								hGlobal.fileWriter:Write("    查询活动否是已领奖: iErrorCodeC=" .. tostring(iErrorCodeC) .. ",level=" .. tostring(level))
								if (iErrorCodeC == 0) then --有记录
									nGetRewardFlag = level
								elseif (iErrorCodeC == 4) then --没记录
									nGetRewardFlag = 0
								end
								
								--未领奖才会处理
								if (nGetRewardFlag == 0) then
									print("    未领奖才会处理")
									hGlobal.fileWriter:Write("    未领奖才会处理")
									
									--活动奖励表
									local prize = {}
									if (type(szPrize) == "string") then
										szPrize = "{" .. szPrize .. "}"
										local tmp = "local prize = " .. szPrize .. " return prize"
										prize = assert(loadstring(tmp))()
									end
									
									--活动总天数、活动需要完成的天数
									local tPrize = prize[1]
									local nMaxDay = tPrize.totalday --活动总天数
									local nRequiereDay = tPrize.rate --活动需要完成的天数
									local nRequiereActiveNum = tPrize.activenum --活动需要完成的每日活跃人数
									local prize_admin = tPrize.prize_admin --军团会长的奖励
									local prize_assistant = tPrize.prize_assistant --军团助理的奖励
									local prize_member = tPrize.prize_member --军团成员的奖励
									
									--将活动的起始时间转化为当天的0点
									local nBeginTimestamp = hApi.GetNewDate(strBeginTime)
									local strDateBeginTimestampYMD = hApi.Timestamp2Date(nBeginTimestamp) --转字符串(年月日)
									local strNewBeginTimeZeroDate = strDateBeginTimestampYMD .. " 00:00:00"
									local nTimestampBeginTimeZero = hApi.GetNewDate(strNewBeginTimeZeroDate)
									
									--统计数据
									local nTotalGroupNum = 0 --达成活动的总军团数量
									local nTotalPlayerNum = 0 --发奖的总玩家数量
									
									--依次遍历每个军团，检测是否完成了活动
									for groupId, tv in pairs(self._groupList) do
										--查询活动时间段内，本军团的全部捐献记录
										if (groupId > 0) then
											--初始化军团每日活跃玩家数量表
											local tActiveNumList = {} --军团每日活跃玩家数量表
											local tActiveUIDDictionary = {} --军团每日活跃玩家列表
											for i = 1, nMaxDay, 1 do
												tActiveNumList[i] = 0
												tActiveUIDDictionary[i] = {}
											end
											
											--print("    处理军团: " .. groupId)
											hGlobal.fileWriter:Write("    处理军团: " .. groupId)
											
											local sQueryM = string.format("SELECT `uid`, `channelId`, `mat_iron_donate`, `mat_wood_donate`, `mat_food_donate`, `group_coin`, `time` FROM `novicecamp_member_donate_log` WHERE `ncid`= %d AND `time` >= '%s' AND `time` <= '%s'", groupId, strBeginTime, strEndTime)
											local errM, tTemp = xlDb_QueryEx(sQueryM)
											--print("从数据库读取捐献列表:", "errM=", errM, "tTemp=", #tTemp)
											if (errM == 0) then
												for n = 1, #tTemp, 1 do
													local mat_uid = tTemp[n][1] --军团玩家id
													local mat_channelId = tTemp[n][2] --军团玩家渠道号
													local mat_iron_donate = tTemp[n][3] --铁
													local mat_wood_donate = tTemp[n][4] --木材
													local mat_food_donate = tTemp[n][5] --粮食
													local mat_group_coin = tTemp[n][6] --军团币
													local mat_time = tTemp[n][7] --日期
													--print(mat_uid, mat_channelId, mat_iron_donate, mat_wood_donate, mat_food_donate, mat_group_coin, mat_time)
													--print("            [捐献]: uid=" .. tostring(mat_uid) .. ",channelId=" .. tostring(mat_channelId) .. ",iron=" .. tostring(mat_iron_donate) .. ",mat_wood_donate=" .. tostring(mat_wood_donate) .. ",food=" .. tostring(mat_food_donate) .. ",group_coin=" .. tostring(mat_group_coin) .. ",time=" .. tostring(mat_time))
													hGlobal.fileWriter:Write("                [捐献]: uid=" .. tostring(mat_uid) .. ",channelId=" .. tostring(mat_channelId) .. ",iron=" .. tostring(mat_iron_donate) .. ",mat_wood_donate=" .. tostring(mat_wood_donate) .. ",food=" .. tostring(mat_food_donate) .. ",group_coin=" .. tostring(mat_group_coin) .. ",time=" .. tostring(mat_time))
													
													--有效的捐献
													if (mat_iron_donate > 0) or (mat_wood_donate > 0) or(mat_food_donate > 0) or(mat_group_coin > 0) then
														--计算捐献的0点
														local nTimestampDonate = hApi.GetNewDate(mat_time)
														local strDateDonatestampYMD = hApi.Timestamp2Date(nTimestampDonate) --转字符串(年月日)
														local strNewDonateZeroDate = strDateDonatestampYMD .. " 00:00:00"
														local nTimestampDonateZero = hApi.GetNewDate(strNewDonateZeroDate)
														
														--计算捐献属于第几天
														local donatedeltatime = nTimestampDonateZero - nTimestampBeginTimeZero
														local donateDay = donatedeltatime / 86400
														local donateDayIdx = donateDay + 1
														--print("donateDayIdx=", donateDayIdx)
														
														--活动最大天数之内的捐献
														if (donateDayIdx <= nMaxDay) then
															--如果该玩家当日未被统计，那么当日活跃玩家数量加1
															if (tActiveUIDDictionary[donateDayIdx][mat_uid] == nil) then
																--检测捐献玩家的渠道号是否有效
																local bChannelValid_i = false
																if (strChannel == nil) or (strChannel == "") then --活动未填写渠道号，所有渠道都有效
																	bChannelValid_i = true
																else --检测是否包含此渠道号
																	local pos = string.find(strChannel, ";" .. mat_channelId .. ";")
																	if (pos ~= nil) then
																		bChannelValid_i = true --找到了
																	end
																end
																
																--有效的渠道号的玩家
																if bChannelValid_i then
																	tActiveUIDDictionary[donateDayIdx][mat_uid] = true
																	tActiveNumList[donateDayIdx] = tActiveNumList[donateDayIdx] + 1
																	
																	
																	--print("            玩家[" .. mat_uid .. "]在第" .. donateDayIdx .. "天活跃")
																	hGlobal.fileWriter:Write("            玩家[" .. mat_uid .. "]在第" .. donateDayIdx .. "天活跃")
																end
															end
														end
													end
												end
											end
											
											--统计本军团的累计活跃天数
											local groupActiveDay = 0
											for i = 1, nMaxDay, 1 do
												--每日有20人活跃，活跃天数加1
												if (tActiveNumList[i] >= nRequiereActiveNum) then
													groupActiveDay = groupActiveDay + 1
												end
												
												--print("        第" .. i .. "天活跃人数: " .. tActiveNumList[i])
												hGlobal.fileWriter:Write("        第" .. i .. "天活跃人数: " .. tActiveNumList[i])
											end
											--print("        总活跃天数: " .. groupActiveDay)
											hGlobal.fileWriter:Write("        总活跃天数: " .. groupActiveDay)
											
											--本军团活跃天数达到7天，认为达成活动条件
											if (groupActiveDay >= nRequiereDay) then
												print("        达成活动条件，本军团发奖 " .. groupId)
												hGlobal.fileWriter:Write("        达成活动条件，本军团发奖 " .. groupId)
												
												--统计达成活动的总军团数量
												nTotalGroupNum = nTotalGroupNum + 1
												
												--依次遍历本军团的所有成员
												for uid, level in pairs(tv) do
													local prize_list = nil
													if(level == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --会长
														prize_list = prize_admin
													elseif(level == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) then --助理
														prize_list = prize_assistant
													elseif(level == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --助理（系统）
														prize_list = prize_assistant
													else --成员
														prize_list = prize_member
													end
													
													--统计发奖的总玩家数量
													nTotalPlayerNum = nTotalPlayerNum + 1
													
													--发奖
													for p = 1, #prize_list, 1 do
														--插入奖励表
														local id = prize_list[p].id
														local detail = prize_list[p].detail
														--print(rewardIdx, id, detail)
														
														--发奖
														local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",uid,id,detail,0,aid)
														xlDb_Execute(sInsert)
													end
												end
												
												--发送军团消息
												--军团名
												local groupName = ""
												local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
												local errM, strName = xlDb_Query(sQueryM)
												if (errM == 0) then
													groupName = strName
												end
												local tMsg = {}
												tMsg.chatType = hVar.CHAT_TYPE.GROUP
												tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --军团系统提示消息
												tMsg.uid = 0
												tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
												tMsg.channelId = 0
												tMsg.vip = 0
												tMsg.borderId = 1000
												tMsg.iconId = 1000
												tMsg.championId = 0
												tMsg.leaderId = 0
												tMsg.dragonId = 0
												tMsg.headId = 0
												tMsg.lineId = 0
												tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ACTIVITY_TAKE_REWARD"], groupName)
												tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
												tMsg.touid = groupId
												tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
												tMsg.resultParam = 0
												--发送军团消息
												hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
												
												--[[
												--发送世界消息
												local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE --提示类系统消息
												local content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ACTIVITY_TAKE_REWARD_WORLD"], groupName)
												local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
												hGlobal.chatMgr:SendSystemMessage(sysMsgtype, content, strDate)
												]]
											end
										end
									end
									
									print("    达成任务总军团数: " .. nTotalGroupNum)
									hGlobal.fileWriter:Write("    达成任务总军团数: " .. nTotalGroupNum)
									print("    达成任务发奖总玩家数: " .. nTotalPlayerNum)
									hGlobal.fileWriter:Write("    达成任务发奖总玩家数: " .. nTotalPlayerNum)
									
									--标记活动已领奖
									if (iErrorCodeC == 0) then --有记录
										--修改活动进度
										local sSql = string.format("UPDATE `activity_check` SET `level` = %d, `lv01` = %d, `lv02` = %d WHERE `aid` = %d", 1, nTotalGroupNum, nTotalPlayerNum, aid)
										xlDb_Query(sSql)
										print("    更新领奖记录, aid=" .. aid)
										hGlobal.fileWriter:Write("    更新领奖记录, aid=" .. aid)
									elseif (iErrorCodeC == 4) then --没记录
										--插入新活动进度
										local sInsert = string.format("insert into `activity_check`(`aid`, `uid`, `rid`, `level`, `lv01`, `lv02`) values (%d, %d, %d, %d, %d, %d)", aid, 0, 0, 1, nTotalGroupNum, nTotalPlayerNum)
										xlDb_Execute(sInsert)
										print("    插入领奖记录, aid=" .. aid)
										hGlobal.fileWriter:Write("    插入领奖记录, aid=" .. aid)
									end
								end
							end
						end
					end
				end
			end
			
			--检测是否发放军团排名奖励（每周一）
			--local sDate = os.date("%Y-%m-%d", currenttimestamp)
			for i = 1, #GroupMgr.SYSTEM_CHECK_RANK_TIME, 1 do
				local sRefreshTime = GroupMgr.SYSTEM_CHECK_RANK_TIME[i].time
				local weekId = GroupMgr.SYSTEM_CHECK_RANK_TIME[i].weekId --周几检测
				local refresh_time = sDate .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					
					print("检测是否发放军团排名奖励: " .. sDate)
					hGlobal.fileWriter:Write("检测是否发放军团排名奖励: ", sDate)
					
					--今日是周几
					local weekNum = os.date("*t", nRefreshTime).wday - 1
					if (weekNum == 0) then
						weekNum = 7
					end
					print("  weekNum=" .. weekNum)
					hGlobal.fileWriter:Write("  weekNum=" .. weekNum)
					
					--获取上一次发放军团排名奖励的时间
					local last_check_time = ""
					local sQuery = string.format("select IFNULL(MAX(`check_time`), '') from `leaderboards_check` where `leaderboards_id`= %d and `tType` = %d", GroupMgr.RANKBOARD_ID, GroupMgr.RANKBOARD_TYPE)
					local iErrorCode, check_time = xlDb_Query(sQuery)
					--print("查询上一次发放军团排名奖励的时间", iErrorCode, check_time)
					if (iErrorCode == 0) then
						last_check_time = check_time
					end
					print("  last_check_time=" .. last_check_time)
					hGlobal.fileWriter:Write("  last_check_time=" .. last_check_time)
					
					--是否需要进行结算
					local bNeedCheck = false
					
					--数据库无数据需要结算
					if (last_check_time == "") then
						print("  数据库无数据需要结算")
						hGlobal.fileWriter:Write("  数据库无数据需要结算")
						bNeedCheck = true
					end
					
					--距离上次发奖超过7天需要结算
					local nTimestamp7Day = hApi.GetNewDate(last_check_time, "DAY", 7)
					if (currenttimestamp >= nTimestamp7Day) then
						print("  距离上次发奖超过7天需要结算")
						hGlobal.fileWriter:Write("  距离上次发奖超过7天需要结算")
						bNeedCheck = true
					end
					
					--周一需要结算
					if (weekNum == weekId) then
						print("  周一需要结算")
						hGlobal.fileWriter:Write("  周一需要结算")
						bNeedCheck = true
					end
					
					print("  bNeedCheck=" .. tostring(bNeedCheck))
					hGlobal.fileWriter:Write("  bNeedCheck=" .. tostring(bNeedCheck))
					
					--需要结算
					if bNeedCheck then
						--获取军团排名数据
						local sCmd = ""
						local nTotalPlayerNum = 0 --统计共发奖的玩家数量
						local private = NoviceCampMgr.private
						local tList = private.Data_GetNcList(1)
						if (type(tList) == "table") then
							--发放军团个人本周捐献第一名奖励
							local maxUID = 0
							local maxNcid = 0
							local maxShengwangWeek = 0
							local sQuery = string.format("SELECT `uid`, `ncid`, `shengwang_week` FROM `novicecamp_member` WHERE `shengwang_week` >= %d ORDER BY `shengwang_week` DESC, `ncid` DESC, `uid` DESC LIMIT 1", GroupMgr.RANKBOARD_SHENGWANGWEEK_MIN_SINGLE)
							local err, uid, ncid, shengwang_week = xlDb_Query(sQuery)
							if (err == 0) then
								maxUID = uid
								maxNcid = ncid
								maxShengwangWeek = shengwang_week
							end
							print("  maxUID=" .. maxUID)
							print("  maxNcid=" .. maxNcid)
							print("  maxShengwangWeek=" .. maxShengwangWeek)
							hGlobal.fileWriter:Write("  maxUID=" .. maxUID)
							hGlobal.fileWriter:Write("  maxNcid=" .. maxNcid)
							hGlobal.fileWriter:Write("  maxShengwangWeek=" .. maxShengwangWeek)
							--插入奖励
							local mkey = string.format(hVar.tab_string["__TEXT_GROUP_SHENGWANGWEEK_SINGLE_CONTENT"], maxShengwangWeek)
							local insertSql = string.format("INSERT INTO `prize`(`uid`, `rid`, `type`, `used`, `mykey`) values(%d, 0, %d, '0', '%s')", maxUID, GroupMgr.RANKBOARD_PRIZE_TYPE_SINGLE, mkey)
							local err = xlDb_Execute(insertSql)
							--通知事件：发放军团个人本周声望最高荣誉奖
							if (maxNcid > 0) then
								hGlobal.groupMgr:OnGroupWeekDonateSumSingle(maxNcid, maxUID, maxShengwangWeek)
							end
							
							--只发前100名军团排名奖励
							for i = 1, 100, 1 do
								local groupId = 0
								local groupName = ""
								local shengwang_week_sum = 0
								local uids = ""
								local tListInfo = tList[i]
								if tListInfo then
									--全体军团成员发放第i名奖励
									groupId = tListInfo[1]
									groupName = tListInfo[2]
									shengwang_week_sum = tListInfo[16]
									
									if (groupId > 0) then
										--找到对应名次的奖励表
										local reward = nil
										for r = 1, #GroupMgr.RANKBOARD_PRIZE_LIST, 1 do
											local tPrizeList = GroupMgr.RANKBOARD_PRIZE_LIST[r]
											local from = tPrizeList.from
											local to = tPrizeList.to
											if (from <= i) and (i <= to) then --找到了
												reward = tPrizeList.reward
												break
											end
										end
										if reward then
											if self._groupList[groupId] then
												for uid, level in pairs(self._groupList[groupId]) do
													--只给军团成员发奖
													if (level > 0) then
														--print("    ", i, uid, level)
														--发奖
														local prize_list = ""
														local strAythen = ""
														if(level == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --会长
															prize_list = reward.prize_admin
															strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_ADMIN"]
														elseif(level == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) then --助理
															prize_list = reward.prize_assistant
															strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_ASSIST"]
														elseif(level == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --助理（系统）
															prize_list = reward.prize_assistant
															strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_ASSIST"]
														else --成员
															prize_list = reward.prize_member
															strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_MEMBER"]
														end
														
														--插入奖励表
														local id = GroupMgr.RANKBOARD_PRIZE_TYPE
														local detail = string.format(hVar.tab_string["__TEXT_GROUP_RANKBOARD_CONTENT"], strAythen, groupName, shengwang_week_sum, i, prize_list)
														--print(rewardIdx, id, detail)
														
														--发奖
														local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",uid,id,detail,0,groupId)
														xlDb_Execute(sInsert)
														
														--记录玩家本周军团捐献总和（每周发奖后清空）
														--清除玩家的上周声望
														local sUpdate = string.format("update `novicecamp_member` set `shengwang_week` = %d where `uid` = %d", 0, uid)
														xlDb_Execute(sUpdate)
														
														--日志
														uids = uids .. tostring(uid) .. "|" .. tostring(level) .. ","
														
														--统计发奖的玩家数量
														nTotalPlayerNum = nTotalPlayerNum + 1
													end
												end
												
												--清除军团的上周声望
												local sSql = string.format("UPDATE `novicecamp_list` SET `shengwang_week_sum` = %d WHERE `id`= %d", 0, groupId)
												xlDb_Execute(sSql)
											end
										end
										
										--通知事件：发放军团每周排名奖励
										hGlobal.groupMgr:OnGroupWeekDonateSend(groupId, groupName, shengwang_week_sum, i)
									end
								end
								
								sCmd = sCmd .. "rank=" .. tostring(i) .. ",groupId=" .. tostring(groupId) .. ",groupName=" .. tostring(groupName) .. ",shengwang_week_sum=" .. tostring(shengwang_week_sum) .. ",uids=\n" .. uids .. "\n"
							end
						end
						print("  nTotalPlayerNum=" .. nTotalPlayerNum)
						hGlobal.fileWriter:Write("  nTotalPlayerNum=" .. nTotalPlayerNum)
						
						sCmd = "totalnum=" .. tostring(nTotalPlayerNum) .. "\n" .. sCmd
						
						hGlobal.fileWriter:Write(sCmd)
						
						--更新发奖时间
						local sInsert = string.format("insert into `leaderboards_check`(`leaderboards_id`, `tType`, `result`, `check_time`) values (%d, %d, '%s', '%s')", GroupMgr.RANKBOARD_ID, GroupMgr.RANKBOARD_TYPE, sCmd, refresh_time)
						--print(sInsert)
						xlDb_Execute(sInsert)
					end
				end
			end
			
			--检测是否发放军团聊天龙王奖励
			--local sDate = os.date("%Y-%m-%d", currenttimestamp)
			for i = 1, #GroupMgr.SYSTEM_CHECK_CHAT_DRAGON_TIME, 1 do
				local sRefreshTime = GroupMgr.SYSTEM_CHECK_CHAT_DRAGON_TIME[i].time
				local refresh_time = sDate .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					
					print("检测是否发放军团聊天龙王奖励: " .. sDate)
					hGlobal.fileWriter:Write("检测是否发放军团聊天龙王奖励: " .. sDate)
					
					--检测今日是否已发奖
					local sql = string.format("SELECT * FROM `prize` WHERE `type`= %d and `create_time` >= '%s' AND `create_time` <= '%s'", hVar.REWARD_LOG_TYPE.chatDragonReward, sDate .." 00:00:00", sDate .." 23:59:59")
					local err, roomid,tactic_cfg = xlDb_Query(sql)
					--print("_CheckPvePlayerPrize:",err,sql)
					if (err == 0) then
						--不需要再发奖
						print("    不需要再发奖")
						hGlobal.fileWriter:Write("    不需要再发奖")
					elseif (err == 4) then
						--检测发奖
						print("    检测发奖")
						hGlobal.fileWriter:Write("    检测发奖")
						
						local maxUID = 0
						local maxCount = 0
						local sql = string.format("SELECT `uid`, `msg_total_num` FROM `t_chat_user` WHERE `msg_total_num` >= 30 AND `last_msg_total_time` >= '%s' ORDER BY `msg_total_num` DESC LIMIT 1", sDate .." 00:00:00")
						local err, uid, count = xlDb_Query(sql)
						--print(sql)
						--print(err)
						if (err == 0) then
							maxUID = uid
							maxCount = count
						end
						
						--插入奖励
						local mkey = hVar.tab_string["__TEXT_CHATDRAGON_REWARD_TITLE"] .. ";" .. sDate .. ";" .. tostring(maxCount) .. ";" .. hVar.tab_string["__TEXT_CHATDRAGON_REWARD"]
						local insertSql = string.format("INSERT INTO `prize`(`uid`, `rid`, `type`, `used`, `mykey`) values(%d, 0, %d, '0', '%s')", maxUID, hVar.REWARD_LOG_TYPE.chatDragonReward, mkey)
						local err = xlDb_Execute(insertSql)
						--print("insertSql=", insertSql, err)
						print("    maxUID="..maxUID)
						print("    maxCount="..maxCount)
						hGlobal.fileWriter:Write("    maxUID="..maxUID)
						hGlobal.fileWriter:Write("    maxCount="..maxCount)
						
						--更新玩家的聊天龙王头衔
						if (maxUID > 0) then
							local nExpireTime = hApi.GetNewDate(refresh_time, "DAY", 1) -- +1天
							local sExpireTime = os.date("%Y-%m-%d %H:%M:%S", nExpireTime)
							local sUpdate = string.format("UPDATE `t_user` SET `dragon` = %d, `dragon_expire_time` = '%s' WHERE `uid` = %d", 1, sExpireTime, maxUID)
							xlDb_Execute(sUpdate)
						end
					end
				end
			end
		end
	end
	
return GroupMgr