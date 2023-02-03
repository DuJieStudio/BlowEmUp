--聊天管理类
local ChatMgr = class("ChatMgr")
	--聊天系统消息提醒时刻表（每日）
	ChatMgr.SYSTEM_NOTICE =
	{
		--[[
		{time = "12:00:00", text = hVar.tab_string["__TEXT_CHAT_SYSTEM_NOTICE1"], msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE,}, --"夺塔奇兵竞技房已开启，快和好友一决高下吧！"
		{time = "19:00:00", text = hVar.tab_string["__TEXT_CHAT_SYSTEM_NOTICE1"], msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE,}, --"夺塔奇兵竞技房已开启，快和好友一决高下吧！"
		{time = "05:00:00", text = hVar.tab_string["__TEXT_CHAT_SYSTEM_NOTICE2"], msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE,}, --"魔龙宝库已开启，快和好友组队挑战吧！"
		--{time = "20:00:00", text = hVar.tab_string["__TEXT_CHAT_SYSTEM_NOTICE2"], msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE,}, --"魔龙宝库已开启，快和好友组队挑战吧！"
		{time = "05:00:00", text = hVar.tab_string["__TEXT_CHAT_SYSTEM_NOTICE4"], msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE, dayOfWeek = {5, 6, 7,},}, --"军团秘境试炼已开启，快和好友组队挑战吧！"
		--{time = "20:00:00", text = hVar.tab_string["__TEXT_CHAT_SYSTEM_NOTICE4"], msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE, dayOfWeek = {5, 6, 7,},}, --"军团秘境试炼已开启，快和好友组队挑战吧！"
		--TEXT_SYSTEM_USER_BATTLE
		]]
	}
	
	--聊天清理昨日军团系统消息
	ChatMgr.SYSTEM_GROUP_CLEARE =
	{
		{time = "00:00:00",}, --清理昨日军团系统消息
	}
	
	--聊天走马灯类消息（每日）
	ChatMgr.SYSTEM_BUBBLE_NOTICE =
	{
		{time = "04:50:00", text = hVar.tab_string["__TEXT_CHAT_SYSTEM_NOTICE3"], bubbleType = hVar.BUBBLE_NOTICE_TYPE.SERVER_RESTART,}, --"游戏服务器将于5点进行维护！"
		{time = "04:51:00", text = hVar.tab_string["__TEXT_CHAT_SYSTEM_NOTICE3"], bubbleType = hVar.BUBBLE_NOTICE_TYPE.SERVER_RESTART,}, --"游戏服务器将于5点进行维护！"
		{time = "04:52:00", text = hVar.tab_string["__TEXT_CHAT_SYSTEM_NOTICE3"], bubbleType = hVar.BUBBLE_NOTICE_TYPE.SERVER_RESTART,}, --"游戏服务器将于5点进行维护！"
		{time = "04:53:00", text = hVar.tab_string["__TEXT_CHAT_SYSTEM_NOTICE3"], bubbleType = hVar.BUBBLE_NOTICE_TYPE.SERVER_RESTART,}, --"游戏服务器将于5点进行维护！"
		{time = "04:54:00", text = hVar.tab_string["__TEXT_CHAT_SYSTEM_NOTICE3"], bubbleType = hVar.BUBBLE_NOTICE_TYPE.SERVER_RESTART,}, --"游戏服务器将于5点进行维护！"
		{time = "04:55:00", text = hVar.tab_string["__TEXT_CHAT_SYSTEM_NOTICE3"], bubbleType = hVar.BUBBLE_NOTICE_TYPE.SERVER_RESTART,}, --"游戏服务器将于5点进行维护！"
		{time = "04:56:00", text = hVar.tab_string["__TEXT_CHAT_SYSTEM_NOTICE3"], bubbleType = hVar.BUBBLE_NOTICE_TYPE.SERVER_RESTART,}, --"游戏服务器将于5点进行维护！"
		{time = "04:57:00", text = hVar.tab_string["__TEXT_CHAT_SYSTEM_NOTICE3"], bubbleType = hVar.BUBBLE_NOTICE_TYPE.SERVER_RESTART,}, --"游戏服务器将于5点进行维护！"
		{time = "04:58:00", text = hVar.tab_string["__TEXT_CHAT_SYSTEM_NOTICE3"], bubbleType = hVar.BUBBLE_NOTICE_TYPE.SERVER_RESTART,}, --"游戏服务器将于5点进行维护！"
		{time = "04:59:00", text = hVar.tab_string["__TEXT_CHAT_SYSTEM_NOTICE3"], bubbleType = hVar.BUBBLE_NOTICE_TYPE.SERVER_RESTART,}, --"游戏服务器将于5点进行维护！"
		{time = "05:00:00", text = hVar.tab_string["__TEXT_CHAT_SYSTEM_NOTICE3"], bubbleType = hVar.BUBBLE_NOTICE_TYPE.SERVER_RESTART,}, --"游戏服务器将于5点进行维护！"
		--
		--{time = "15:35:00", text = "走马灯消息仅供测试，系统以维护后", bubbleType = hVar.BUBBLE_NOTICE_TYPE.SERVER_WARNING_MSG,}, --"游戏服务器将于5点进行维护！"
	}
	
	--聊天系统组队消息有效时间（小时）
	ChatMgr.SYSTEM_COUPLE_VALID_HOUR = 1
	
	--构造函数
	function ChatMgr:ctor()
		self._chatDBID = -1 --数据库id
		
		self._chatList = -1 --世界聊天信息表
		self._inviteChatList = -1 --邀请函聊天信息表
		self._inviteBattleChatList = -1 --组队副本邀请聊天信息表（临时消息，重启后数据丢失）
		self._groupChatList = -1 --工会聊天信息表
		self._coupleChatList = -1 --组队聊天信息表
		
		self._version = -1 --版本号
		self._version_debug = -1 --测试员版本号
		
		--其他
		self._statisticsTime = -1	--统计计时
		self._statisticsTimestamp = -1	--上次统计时间
		
		--世界聊天频道开关刷新检测
		self._worldFlag = -1		--世界聊天开关
		self._worldflagTime = -1	--统计计时
		self._worldflagTimestamp = -1	--上次统计时间
		
		--组队聊天频道检测已失效消息
		self._coupleTime = -1	--统计计时
		self._coupleTimestamp = -1	--上次统计时间
		
		return self
	end
	
	--初始化
	function ChatMgr:Init()
		--初始化聊天信息表
		self._chatList = {} --世界聊天信息表
		self._inviteChatList = {} --邀请函聊天信息表
		self._inviteBattleChatList = {} --组队副本邀请聊天信息表（临时消息，重启后数据丢失）
		self._groupChatList = {} --工会聊天信息表
		self._coupleChatList = {} --组队聊天信息表
		
		---------------------------------------------------------------------------------------------------------------------------------------------------------
		--世界聊天
		--从数据库读取最近100条世界频道聊天记录
		--从数据库读取未过期支付（土豪）红包记录
		--从数据库读取未过期支付（土豪）红包领取记录
		local chatType = hVar.CHAT_TYPE.WORLD
		local msgType1 = hVar.MESSAGE_TYPE.TEXT --文本消息
		local msgType2 = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE --系统文本提示消息（世界）
		local msgType3 = hVar.MESSAGE_TYPE.TEXT_SYSTEM_FORBIDDEN --系统文本禁言消息（世界）
		local msgType4 = hVar.MESSAGE_TYPE.TEXT_SYSTEM_FORBIDDEN_ALL --系统文本全员禁言消息（世界）
		local msgType5 = hVar.MESSAGE_TYPE.TEXT_SYSTEM_CANCEL_FORBIDDEN_ALL --系统文本取消全员禁言消息（世界）
		local msgType6 = hVar.MESSAGE_TYPE.TEXT_SYSTEM_WARNING --系统文本警告消息（世界）
		local msgType7 = hVar.MESSAGE_TYPE.TEXT_SYSTEM_USER_BATTLE --系统文本玩家关卡通关消息（世界）
		local sQueryM = string.format("SELECT `id`, `type`, `msg_type`, `uid`, `name`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `content`, `time`, `touid`, `result`, `result_param` FROM `chat` WHERE `type` = %d and `msg_type` in (%d, %d, %d, %d, %d, %d, %d) and `deleteflag` = 0 order by `id` desc limit %d", chatType, msgType1, msgType2, msgType3, msgType4, msgType5, msgType6, msgType7, hVar.CHAT_MAX_LENGTH_WORLD)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("从数据库读取最近100条聊天记录:", "errM=", errM, "tTemp=", #tTemp)
		if (errM == 0) then
			--逆向初始化
			for n = #tTemp, 1, -1 do
				local id = tTemp[n][1]
				local chatType = tTemp[n][2]
				local msgType = tTemp[n][3]
				local uid = tTemp[n][4]
				local name = tTemp[n][5]
				local channelId = tTemp[n][6]
				local vip = tTemp[n][7]
				local borderId = tTemp[n][8]
				local iconId = tTemp[n][9]
				local championId = tTemp[n][10]
				local leaderId = tTemp[n][11]
				local dragonId = tTemp[n][12]
				local headId = tTemp[n][13]
				local lineId = tTemp[n][14]
				local content = tTemp[n][15]
				local date = tTemp[n][16]
				local touid = tTemp[n][17]
				local result = tTemp[n][18]
				local resultParam = tTemp[n][19]
				
				--print(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
				
				local chat = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
				self._chatList[#self._chatList+1] = chat
			end
		end
		--再读取未过期的支付（土豪）红包记录
		local redPacketPayDictionary = hGlobal.redPacketPayMgr:GetRedPacketList()
		for _, redPacketPay in pairs(redPacketPayDictionary) do
			--local redPacketPay = redPacketList[i]
			local redpacket_id = redPacketPay:GetID()
			local msg_id = redPacketPay._msg_id
			--print("redpacket_id", msg_id)
			if (msg_id > 0) then
				local sQueryM = string.format("SELECT `id`, `type`, `msg_type`, `uid`, `name`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `content`, `time`, `touid`, `result`, `result_param` FROM `chat` WHERE `id` = %d and `deleteflag` = 0", msg_id)
				local errM, id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam = xlDb_Query(sQueryM)
				if (errM == 0) then
					local chat = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
					self._chatList[#self._chatList+1] = chat
				end
			end
			
		end
		
		--再读取未过期的支付（土豪）收红包消息记录
		local redPacketReceivePayDictionary = hGlobal.redPacketPayMgr:GetRedPacketReceiveList()
		for _, tUserReward in pairs(redPacketReceivePayDictionary) do
			for _, redPacketReceive in pairs(tUserReward) do
				local redpacket_receive_id = redPacketReceive.id
				local msg_id = redPacketReceive.msg_id
				--print("redpacket_receive_id", msg_id)
				if (msg_id > 0) then
					local sQueryM = string.format("SELECT `id`, `type`, `msg_type`, `uid`, `name`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `content`, `time`, `touid`, `result`, `result_param` FROM `chat` WHERE `id` = %d and `deleteflag` = 0", msg_id)
					local errM, id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam = xlDb_Query(sQueryM)
					--print(sQueryM)
					--print(errM, id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
					if (errM == 0) then
						local chat = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
						self._chatList[#self._chatList+1] = chat
					end
				end
			end
		end
		--按消息id从小到大排序
		table.sort(self._chatList, function(ta, tb)
			return (ta:GetID() < tb:GetID())
		end)
		
		---------------------------------------------------------------------------------------------------------------------------------------------------------
		--邀请频道
		--从数据库读取未过期的军团邀请函（数组表）
		local inviteGroupList = hGlobal.inviteGroupMgr:GetInviteGroupList()
		for _, inviteGroup in ipairs(inviteGroupList) do
			local msg_id = inviteGroup._msg_id
			if (msg_id > 0) then
				local sQueryM = string.format("SELECT `id`, `type`, `msg_type`, `uid`, `name`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `content`, `time`, `touid`, `result`, `result_param` FROM `chat` WHERE `id` = %d and `deleteflag` = 0", msg_id)
				local errM, id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam = xlDb_Query(sQueryM)
				if (errM == 0) then
					local chat = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
					self._inviteChatList[#self._inviteChatList+1] = chat
					--print("军团邀请函", msg_id)
				end
			end
		end
		
		--组队副本邀请消息
		--无
		
		---------------------------------------------------------------------------------------------------------------------------------------------------------
		--军团聊天
		--从数据库读取每个工会的60条玩家聊天记录
		--从数据库读取全部工会今日系统消息记录
		--从数据库读取军团未过期红包记录
		--从数据库读取军团未过期红包领取记录
		local groupList = hGlobal.groupMgr:GetGroupList()
		for groupId, v in pairs(groupList) do
			--初始化此工会的聊天表
			self._groupChatList[groupId] = {}
			
			--print("groupId=", groupId)
			
			--先取玩家聊天记录，工会提示消息，工会警告消息
			local chatType = hVar.CHAT_TYPE.GROUP
			local msgType1 = hVar.MESSAGE_TYPE.TEXT --文本消息
			local msgType2 = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --工会系统提示消息
			local msgType3 = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_WARNING --工会系统警告消息
			local sQueryM = string.format("SELECT `id`, `type`, `msg_type`, `uid`, `name`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `content`, `time`, `touid`, `result`, `result_param` FROM `chat` WHERE `type` = %d and `touid` = %d and `msg_type` in(%d, %d, %d) and `deleteflag` = 0 order by `id` desc limit %d", chatType, groupId, msgType1, msgType2, msgType3, hVar.CHAT_MAX_LENGTH_GROUP)
			local errM, tTemp = xlDb_QueryEx(sQueryM)
			--print(sQueryM)
			--print("从数据库读取每个工会的60条玩家聊天记录:", "errM=", errM, "tTemp=", tTemp and #tTemp)
			if (errM == 0) then
				--逆向初始化
				for n = #tTemp, 1, -1 do
					local id = tTemp[n][1]
					local chatType = tTemp[n][2]
					local msgType = tTemp[n][3]
					local uid = tTemp[n][4]
					local name = tTemp[n][5]
					local channelId = tTemp[n][6]
					local vip = tTemp[n][7]
					local borderId = tTemp[n][8]
					local iconId = tTemp[n][9]
					local championId = tTemp[n][10]
					local leaderId = tTemp[n][11]
					local dragonId = tTemp[n][12]
					local headId = tTemp[n][13]
					local lineId = tTemp[n][14]
					local content = tTemp[n][15]
					local date = tTemp[n][16]
					local touid = tTemp[n][17]
					local result = tTemp[n][18]
					local resultParam = tTemp[n][19]
					
					--print(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
					
					local chat = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
					self._groupChatList[groupId][#self._groupChatList[groupId]+1] = chat
				end
			end
			
			--再取今日工会系统消息记录
			local chatType = hVar.CHAT_TYPE.GROUP
			local msgType1 = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_TODAY --工会系统今日消息
			local sQueryM = string.format("SELECT `id`, `type`, `msg_type`, `uid`, `name`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `content`, `time`, `touid`, `result`, `result_param` FROM `chat` WHERE `type` = %d and `touid` = %d and `msg_type` in (%d) and `deleteflag` = 0 and DATEDIFF(CURDATE(), DATE(`time`)) = 0 order by `id` desc", chatType, groupId, msgType1)
			local errM, tTemp = xlDb_QueryEx(sQueryM)
			--print(sQueryM)
			--print("从数据库读取每个工会的今日系统提示消息记录:", "errM=", errM, "tTemp=", tTemp and #tTemp)
			if (errM == 0) then
				--逆向初始化
				for n = #tTemp, 1, -1 do
					local id = tTemp[n][1]
					local chatType = tTemp[n][2]
					local msgType = tTemp[n][3]
					local uid = tTemp[n][4]
					local name = tTemp[n][5]
					local channelId = tTemp[n][6]
					local vip = tTemp[n][7]
					local borderId = tTemp[n][8]
					local iconId = tTemp[n][9]
					local championId = tTemp[n][10]
					local leaderId = tTemp[n][11]
					local dragonId = tTemp[n][12]
					local headId = tTemp[n][13]
					local lineId = tTemp[n][14]
					local content = tTemp[n][15]
					local date = tTemp[n][16]
					local touid = tTemp[n][17]
					local result = tTemp[n][18]
					local resultParam = tTemp[n][19]
					
					--print(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
					
					local chat = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
					self._groupChatList[groupId][#self._groupChatList[groupId]+1] = chat
				end
			end
			
			--再读取军团未过期的发红包消息记录
			local redPacketGroupDictionary = hGlobal.redPacketGroupMgr:GetRedPacketList()
			for _, redPacketGroup in pairs(redPacketGroupDictionary) do
				--local redPacketGroup = redPacketList[i]
				local redpacket_id = redPacketGroup:GetID()
				local groupId_redpacket = redPacketGroup._group_id
				local msg_id = redPacketGroup._msg_id
				if (msg_id > 0) then
					if (groupId_redpacket == groupId) then
						local sQueryM = string.format("SELECT `id`, `type`, `msg_type`, `uid`, `name`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `content`, `time`, `touid`, `result`, `result_param` FROM `chat` WHERE `id` = %d and `deleteflag` = 0", msg_id)
						local errM, id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam = xlDb_Query(sQueryM)
						if (errM == 0) then
							local chat = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
							self._groupChatList[groupId][#self._groupChatList[groupId]+1] = chat
						end
					end
				end
			end
			
			--再读取军团未过期的收红包消息记录
			local redPacketReceiveGroupDictionary = hGlobal.redPacketGroupMgr:GetRedPacketReceiveList()
			for _, tUserReward in pairs(redPacketReceiveGroupDictionary) do
				for _, redPacketReceive in pairs(tUserReward) do
					local redpacket_receive_id = redPacketReceive.id
					local groupId_redpacket_receive = redPacketReceive.receive_group_id
					local msg_id = redPacketReceive.msg_id
					if (msg_id > 0) then
						if (groupId_redpacket_receive == groupId) then
							local sQueryM = string.format("SELECT `id`, `type`, `msg_type`, `uid`, `name`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `content`, `time`, `touid`, `result`, `result_param` FROM `chat` WHERE `id` = %d and `deleteflag` = 0", msg_id)
							local errM, id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam = xlDb_Query(sQueryM)
							--print(sQueryM)
							--print(errM, id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
							if (errM == 0) then
								local chat = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
								self._groupChatList[groupId][#self._groupChatList[groupId]+1] = chat
							end
						end
					end
				end
			end
			
			--按消息id从小到大排序
			table.sort(self._groupChatList[groupId], function(ta, tb)
				return (ta:GetID() < tb:GetID())
			end)
		end
		
		---------------------------------------------------------------------------------------------------------------------------------------------------------
		--组队聊天
		--从数据库读取最近1小时内的全部组队聊天记录
		local chatType = hVar.CHAT_TYPE.COUPLE
		local sDateNow = os.date("%Y-%m-%d %H:%M:%S", os.time())
		local hour1time = hApi.GetNewDate(sDateNow, "HOUR", -ChatMgr.SYSTEM_COUPLE_VALID_HOUR) --1小时前
		local sDate1Hour = os.date("%Y-%m-%d %H:%M:%S", hour1time)
		local sQueryM = string.format("SELECT `id`, `type`, `msg_type`, `uid`, `name`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `content`, `time`, `touid`, `result`, `result_param` FROM `chat` WHERE `type` = %d and `time` > '%s' and `deleteflag` = 0 order by `id` desc", chatType, sDate1Hour)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("从数据库读取最近1小时内的全部组队聊天记录:", "errM=", errM, "tTemp=", #tTemp)
		if (errM == 0) then
			--逆向初始化
			for n = #tTemp, 1, -1 do
				local id = tTemp[n][1]
				local chatType = tTemp[n][2]
				local msgType = tTemp[n][3]
				local uid = tTemp[n][4]
				local name = tTemp[n][5]
				local channelId = tTemp[n][6]
				local vip = tTemp[n][7]
				local borderId = tTemp[n][8]
				local iconId = tTemp[n][9]
				local championId = tTemp[n][10]
				local leaderId = tTemp[n][11]
				local dragonId = tTemp[n][12]
				local headId = tTemp[n][13]
				local lineId = tTemp[n][14]
				local content = tTemp[n][15]
				local date = tTemp[n][16]
				local touid = tTemp[n][17]
				local result = tTemp[n][18]
				local resultParam = tTemp[n][19]
				
				--print(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
				
				--按游戏局id分表
				local chat = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
				if (self._coupleChatList[touid] == nil) then
					self._coupleChatList[touid] = {}
				end
				self._coupleChatList[touid][#self._coupleChatList[touid]+1] = chat
			end
		end
		
		--读取数据库id
		local err1, pid = xlDb_Query("SELECT IFNULL(MAX(id), 0) FROM `chat`;")
		--print("max(id)", err1, pid)
		if (err1 == 0) then
			self._chatDBID = pid
		else
			self._chatDBID = 0
		end
		
		--读取版本号
		self._version = "" --版本号
		self._version_debug = "" --测试员版本号
		local errCfg, tTemp = xlDb_QueryEx("SELECT `key`, `content` FROM `tconfig`;")
		--print("errCfg=", errCfg, tTemp)
		if (errCfg == 0) then
			for n = 1, #tTemp, 1 do
				local key = tTemp[n][1]
				local content = tTemp[n][2]
				if (key == "group_control") then
					self._version = content --版本号
				elseif (key == "debug_group_control") then
					self._version_debug = content --测试员版本号
				end
			end
		end
		--print("self._version=", self._version)
		--print("self._version_debug=", self._version_debug)
		
		--其他
		self._statisticsTime = hApi.GetClock()	--统计计时
		self._statisticsTimestamp = os.time()	--上次统计时间
		
		--世界聊天频道开关刷新检测
		self._worldflagTime = hApi.GetClock()	--统计计时
		self._worldflagTimestamp = os.time()	--上次统计时间
		
		--组队聊天频道检测已失效消息
		self._coupleTime = hApi.GetClock()	--统计计时
		self._coupleTimestamp = os.time()	--上次统计时间
		
		--查询世界聊天开关
		local worldFlag = 1
		local sql = string.format("select `content` from `tactions` WHERE `type` = %d", 2020)
		local err, strContent = xlDb_Query(sql)
		if (err == 0) then
			worldFlag = tonumber(strContent) or 1
		else
			worldFlag = 1
		end
		self._worldFlag = worldFlag		--世界聊天开关
		
		return self
	end
	
	--release
	function ChatMgr:Release()
		self._chatDBID = -1 --数据库id
		
		self._chatList = -1 --世界聊天信息表
		self._inviteChatList = -1 --邀请函聊天信息表
		self._inviteBattleChatList = -1 --组队副本邀请聊天信息表（临时消息，重启后数据丢失）
		self._groupChatList = -1 --工会聊天信息表
		
		self._version = -1 --版本号
		self._version_debug = -1 --测试员版本号
		
		--其他
		self._statisticsTime = -1	--统计计时
		self._statisticsTimestamp = -1	--上次统计时间
		
		--世界聊天频道开关刷新检测
		self._worldFlag = -1		--世界聊天开关
		self._worldflagTime = -1	--统计计时
		self._worldflagTimestamp = -1	--上次统计时间
		
		--组队聊天频道检测已失效消息
		self._coupleTime = -1	--统计计时
		self._coupleTimestamp = -1	--上次统计时间
		
		return self
	end
	
	--获得正式版本号
	function ChatMgr:GetVersion()
		--版本号
		return self._version
	end
	
	--获得测试员版本号
	function ChatMgr:GetDebugVersion()
		--测试员版本号
		return self._version_debug
	end
	
	--获得世界聊天开关状态
	function ChatMgr:GetWorldFlag()
		--世界聊天开关
		return self._worldFlag
	end
	
	--获得自增id
	function ChatMgr:GetMsgDBID()
		return self._chatDBID
	end
	
	--获得最近一条世界消息id
	function ChatMgr:GetLastWorldMsgId()
		local msgId = 0
		if (#self._chatList > 0) then
			msgId = self._chatList[#self._chatList]:GetID() --最后一条
		end
		
		return msgId
	end
	
	--获得指定id的世界消息
	function ChatMgr:GetWorldMsg(msgId)
		for i = 1, #self._chatList, 1 do
			local chat = self._chatList[i]
			if (chat:GetID() == msgId) then --找到了
				return chat
			end
		end
	end
	
	--获得最近一条邀请消息id
	function ChatMgr:GetLastInviteMsgId()
		local msgId = 0
		if (#self._inviteChatList > 0) then
			msgId = self._inviteChatList[#self._inviteChatList]:GetID() --最后一条
		end
		
		return msgId
	end
	
	--获得指定id的邀请消息
	function ChatMgr:GetInviteMsg(msgId)
		for i = 1, #self._inviteChatList, 1 do
			local chat = self._inviteChatList[i]
			if (chat:GetID() == msgId) then --找到了
				return chat
			end
		end
	end
	
	--获得指定id的军团消息
	function ChatMgr:GetGroupMsg(groupId, msgId)
		local tGroup = self._groupChatList[groupId]
		if tGroup then
			for i = 1, #tGroup, 1 do
				local chat = tGroup[i]
				if (chat:GetID() == msgId) then --找到了
					return chat
				end
			end
		end
	end
	
	--获得最近一条军团消息id
	function ChatMgr:GetLastGroupMsgId(uid)
		local msgId = 0
		local groupId = hGlobal.groupMgr:GetUserGroupID(uid) --玩家所在的工会id
		if (groupId > 0) then
			if (#self._groupChatList[groupId] > 0) then
				msgId = self._groupChatList[groupId][#self._groupChatList[groupId]]:GetID() --最后一条
			end
		end
		
		return msgId
	end
	
	--插入一条私聊邀请日志
	function ChatMgr:InsertInveteLog(uid, name, touid, toname, inviteflag)
		local sDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
		local sInsert = string.format("insert into `chat_invite_log`(`uid`, `name`, `touid`, `toname`, `time`, `inviteflag`) values (%d, '%s', %d, '%s', '%s', %d)", uid, name, touid, toname, sDate, inviteflag)
		xlDb_Execute(sInsert)
		--print(sInsert)
	end
	
	--查询玩家和私聊好友今日私聊邀请日志数量
	function ChatMgr:QueryInveteLogCount(uid, touid)
		--返回值
		local inviteCount = 0
		
		local currenttime = os.time()
		local sDateBegin = os.date("%Y-%m-%d 00:00:00", currenttime)
		local sDateEnd = os.date("%Y-%m-%d 23:59:59", currenttime)
		local sQuery = string.format("SELECT count(*) from `chat_invite_log` WHERE `uid` = %d and `touid` = %d and `time` >= '%s' and `time` <= '%s'", uid, touid, sDateBegin, sDateEnd)
		local err, count = xlDb_Query(sQuery)
		--print(sQuery)
		--print("查询玩家和私聊好友今日私聊邀请日志数量:", "err=" .. err, "count=", count)
		if (err == 0) then
			inviteCount = count
		end
		
		return inviteCount
	end
	
	--添加一条 世界/军团邀请函/组队副本邀请/私聊/军团/组队 聊天消息
	--返回值: 操作结果, chat对象
	function ChatMgr:AddMessage(user, tMsg)
		--返回值
		local ret = 0
		local chat = nil
		
		--检测玩家是否为禁言状态
		local forbidden = 0
		if user then
			forbidden = user:GetForbidden()
		end
		
		if (forbidden == 0) then --未被禁言
			--创建消息对象
			chat = hClass.Chat:create("Chat"):Init(self._chatDBID + 1, tMsg.chatType, tMsg.msgType, tMsg.uid, tMsg.name, tMsg.channelId, tMsg.vip, tMsg.borderId, tMsg.iconId, tMsg.championId, tMsg.leaderId, tMsg.dragonId, tMsg.headId, tMsg.lineId, tMsg.content, tMsg.date, tMsg.touid, tMsg.result, tMsg.resultParam)
			
			if (tMsg.chatType == hVar.CHAT_TYPE.WORLD) then --世界频道
				--检测是否为全员禁言模式
				local worldFlag = 1
				if user then
					worldFlag = self._worldFlag
				end
				if (worldFlag == 0) then
					local bTester = user:GetTester()
					if (bTester == 2) then --仅管理员可发言
						worldFlag = 1
					end
				end
				
				if (worldFlag == 1) then
					--添加一条世界消息
					self._chatList[#self._chatList+1] = chat
					
					--检验世界聊天数量是否超过上限，删除第一条消息
					--只处理玩家文本消息，系统提示消息，系统禁言消息，系统全员禁言消息，系统取消全员禁言消息，系统警告消息，系统玩家关卡通关消息
					local msgType1 = hVar.MESSAGE_TYPE.TEXT --文本消息
					local msgType2 = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE --系统文本提示消息（世界）
					local msgType3 = hVar.MESSAGE_TYPE.TEXT_SYSTEM_FORBIDDEN --系统文本禁言消息（世界）
					local msgType4 = hVar.MESSAGE_TYPE.TEXT_SYSTEM_FORBIDDEN_ALL --系统文本全员禁言消息（世界）
					local msgType5 = hVar.MESSAGE_TYPE.TEXT_SYSTEM_CANCEL_FORBIDDEN_ALL --系统文本取消全员禁言消息（世界）
					local msgType6 = hVar.MESSAGE_TYPE.TEXT_SYSTEM_WARNING --系统文本警告消息（世界）
					local msgType7 = hVar.MESSAGE_TYPE.TEXT_SYSTEM_USER_BATTLE --系统文本玩家关卡通关消息（世界）
					if (tMsg.msgType == msgType1) or (tMsg.msgType == msgType2) or (tMsg.msgType == msgType3) or (tMsg.msgType == msgType4) or (tMsg.msgType == msgType5) or (tMsg.msgType == msgType6) or (tMsg.msgType == msgType7) then
						if (#self._chatList > hVar.CHAT_MAX_LENGTH_WORLD) then
							--计算玩家消息总条数
							local userMsgCount = 0
							local deleteIdx = 0 --第一个玩家消息的索引
							for idx = 1, #self._chatList, 1 do
								local chat_i = self._chatList[idx]
								local msgType_i = chat_i._msgType
								--local strDate = chat_i._date
								if (msgType_i == msgType1) or (msgType_i == msgType2) or (msgType_i == msgType3) or (msgType_i == msgType4) or (msgType_i == msgType5) or (msgType_i == msgType6) or (msgType_i == msgType7) then
									userMsgCount = userMsgCount + 1
									
									if (deleteIdx == 0) then
										deleteIdx = idx
									end
								end
							end
							
							--玩家消息超过上限
							if (userMsgCount > hVar.CHAT_MAX_LENGTH_WORLD) then
								--[[
								--移除世界消息
								local msgId = self._chatList[1]:GetID()
								table.remove(self._chatList, 1)
								]]
								
								--移除世界消息
								local msgId = self._chatList[deleteIdx]:GetID()
								table.remove(self._chatList, deleteIdx)
								--print(deleteIdx)
								
								--全服通知消息: 删除玩家聊天信息
								local alludbid = hGlobal.uMgr:GetAllUserUID()
								local sCmd = tostring(msgId)
								hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
							end
						end
					end
					
					--更新世界聊天玩家的聊天次数等信息
					if user then
						user:AddWorldMessageCount(tMsg.name, 1)
					end
					
					--更新玩家今日聊天次数（世界频道）
					if user then
						user:AddTotalMessageCount(1)
					end
					
					--操作成功
					ret = 1
				else
					 --全员禁言中，只允许管理员发言
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_FOBIDDEN_ALL
				end
			elseif (tMsg.chatType == hVar.CHAT_TYPE.INVITE) then --邀请频道
				--检测此消息是邀请函类型的消息，还是组队副本的邀请消息
				if (tMsg.msgType == hVar.MESSAGE_TYPE.INVITE_GROUP) then --军团邀请函
					self._inviteChatList[#self._inviteChatList+1] = chat
					
					--[[
					--检验世界聊天数量是否超过上限，删除第一条消息
					if (#self._chatList > hVar.CHAT_MAX_LENGTH_WORLD) then
						--移除消息
						local msgId = self._chatList[1]:GetID()
						table.remove(self._chatList, 1)
						
						--全服通知消息: 删除玩家聊天信息
						local alludbid = hGlobal.uMgr:GetAllUserUID()
						local sCmd = tostring(msgId)
						hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
					end
					
					--更新世界聊天玩家的聊天次数等信息
					if user then
						user:AddWorldMessageCount(tMsg.name, 1)
					end
					]]
					
					--更新玩家今日聊天次数（邀请频道）
					if user then
						user:AddTotalMessageCount(1)
					end
					
					--操作成功
					ret = 1
				elseif (tMsg.msgType == hVar.MESSAGE_TYPE.INVITE_BATTLE) then --组队副本邀请
					
					--检测当前组队副本邀请数量是否太多
					if (#self._inviteBattleChatList < hVar.CHAT_MAX_LENGTH_INVITE_BATTLE) then
						self._inviteBattleChatList[#self._inviteBattleChatList+1] = chat
						
						--组队副本邀请消息不需要增加今日聊天次数
						--...
						
						--检测是否已存在此玩家的组队副本邀请消息，如果存在多个，删掉之前的消息
						for i = #self._inviteBattleChatList - 1, 1, -1 do
							local chat_i = self._inviteBattleChatList[i]
							local uid_i = chat_i._uid
							if (uid_i == chat._uid) then --找到了
								--移除组队副本邀请消息
								local msgId = chat_i:GetID()
								table.remove(self._inviteBattleChatList, i)
								
								--全服通知消息: 删除玩家聊天信息
								local alludbid = hGlobal.uMgr:GetAllUserUID()
								local sCmd = tostring(msgId)
								hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
							end
						end
						
						--操作成功
						ret = 1
					else
						--当前组队邀请数量已达上限
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_NOCOUPLE_MAXNUM
					end
				end
			elseif (tMsg.chatType == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
				--玩家添加一条私聊消息
				ret = user:SendPrivateMessage(chat)
				--print("ret=", ret)
			elseif (tMsg.chatType == hVar.CHAT_TYPE.GROUP) then --军团频道
				local groupId = tMsg.touid --工会id
				if user then
					groupId = hGlobal.groupMgr:GetUserGroupID(user:GetUID()) --玩家所在的工会id
				end
				
				--print("groupId=", groupId)
				if (groupId > 0) then
					if (groupId == tMsg.touid) then
						--添加一条军团消息
						if (self._groupChatList[groupId] == nil) then --新创建的军团
							self._groupChatList[groupId] = {}
						end
						self._groupChatList[groupId][#self._groupChatList[groupId]+1] = chat
						
						--检验军团聊天数量是否超过上限，删除第一条消息
						--只处理玩家文本消息，军团提示消息，军团警告消息
						local msgType1 = hVar.MESSAGE_TYPE.TEXT --文本消息
						local msgType2 = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --工会系统提示消息
						local msgType3 = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_WARNING --工会系统警告消息
						if (tMsg.msgType == msgType1) or (tMsg.msgType == msgType2) or (tMsg.msgType == msgType3) then
							if (#self._groupChatList[groupId] > hVar.CHAT_MAX_LENGTH_GROUP) then
								--计算玩家消息总条数
								local userMsgCount = 0
								local deleteIdx = 0 --第一个玩家消息的索引
								for idx = 1, #self._groupChatList[groupId], 1 do
									local chat_i = self._groupChatList[groupId][idx]
									local msgType_i = chat_i._msgType
									--local strDate = chat_i._date
									if (msgType_i == msgType1) or (msgType_i == msgType2) or (msgType_i == msgType3) then --文本消息，军团提示消息，军团警告消息
										userMsgCount = userMsgCount + 1
										
										if (deleteIdx == 0) then
											deleteIdx = idx
										end
									end
								end
								
								--玩家消息超过上限
								if (userMsgCount > hVar.CHAT_MAX_LENGTH_GROUP) then
									--[[
									--移除军团消息
									local msgId = self._groupChatList[groupId][1]:GetID()
									table.remove(self._groupChatList[groupId], 1)
									]]
									
									--移除军团消息
									local msgId = self._groupChatList[groupId][deleteIdx]:GetID()
									table.remove(self._groupChatList[groupId], deleteIdx)
									--print(deleteIdx)
									
									--军团通知消息: 删除玩家聊天信息
									local tUserTable = hGlobal.groupMgr:GetGroupAllUser(groupId)
									local sCmd = tostring(msgId)
									if tUserTable then
										for uid, level in pairs(tUserTable) do
											hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
										end
									end
								end
							end
						end
						
						--更新玩家今日聊天次数（军团频道）
						if user then
							user:AddTotalMessageCount(1)
						end
						
						--操作成功
						ret = 1
					else
						--您不在此军团里
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_INVALID_GROUP
					end
				else
					--您还未加入军团
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_NOT_IN_GROUP
				end
			elseif (tMsg.chatType == hVar.CHAT_TYPE.COUPLE) then --组队频道
				local sessionId = tMsg.touid --游戏局id
				
				--添加一条组队消息
				if (self._coupleChatList[sessionId] == nil) then
					self._coupleChatList[sessionId] = {}
				end
				self._coupleChatList[sessionId][#self._coupleChatList[sessionId]+1] = chat
				
				--[[
				--检验世界聊天数量是否超过上限，删除第一条消息
				if (#self._chatList > hVar.CHAT_MAX_LENGTH_WORLD) then
					--移除消息
					local msgId = self._chatList[1]:GetID()
					table.remove(self._chatList, 1)
					
					--全服通知消息: 删除玩家聊天信息
					local alludbid = hGlobal.uMgr:GetAllUserUID()
					local sCmd = tostring(msgId)
					hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
				end
				
				--更新世界聊天玩家的聊天次数等信息
				if user then
					user:AddWorldMessageCount(tMsg.name, 1)
				end
				]]
				
				--更新玩家今日聊天次数（组队频道）
				if user then
					user:AddTotalMessageCount(1)
				end
				
				--操作成功
				ret = 1
			end
			
			--插入数据库聊天消息
			if (ret == 1) then
				self._chatDBID = self._chatDBID + 1
				local sInsert = string.format("insert into `chat`(`id`, `type`, `msg_type`, `uid`, `name`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `content`, `time`, `touid`, `result`, `result_param`) values (%d, %d, %d, %d, '%s', %d, %d, %d, %d, %d, %d, %d, %d, %d, '%s', '%s', %d, %d, %d)", self._chatDBID, tMsg.chatType, tMsg.msgType, tMsg.uid, tMsg.name, tMsg.channelId, tMsg.vip, tMsg.borderId, tMsg.iconId, tMsg.championId, tMsg.leaderId, tMsg.dragonId, tMsg.headId, tMsg.lineId, tMsg.content, tMsg.date, tMsg.touid, tMsg.result, tMsg.resultParam)
				xlDb_Execute(sInsert)
				--print(sInsert)
			end
		else
			 --您被禁言无法发送消息
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_FOBIDDEN
		end
		
		return ret, chat
	end
	
	--玩家请求删除一条 世界/组队副本邀请/私聊/军团 聊天消息
	function ChatMgr:RemoveMessage(user, msgId)
		--操作结果
		local ret = 0
		
		--只有管理员才能删除消息
		local bTester = user:GetTester()
		if (bTester == 2) then
			--遍历世界聊天消息
			local bFind = false
			for i = 1, #self._chatList, 1 do
				local chat = self._chatList[i]
				if (chat:GetID() == msgId) then --找到了
					bFind = true
					
					if (chat._msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --发支付（土豪）红包
						--此类型消息不能删除
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_DELETE_MSGTYPE
					elseif (chat._msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_RECEIVE) then --收支付（土豪）红包
						--此类型消息不能删除
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_DELETE_MSGTYPE
					else
						--删除此条消息
						table.remove(self._chatList, i)
						
						--从数据库移除聊天消息
						--local sDelete = string.format("delete from `chat` where `id` = %d", msgId)
						local sDelete = string.format("update `chat` set `deleteflag` = 1, `delete_op_uid` = %d where `id` = %d", user:GetUID(), msgId)
						xlDb_Execute(sDelete)
						
						--操作成功
						ret = 1
					end
					
					break
				end
			end
			
			--遍历组队副本邀请消息（临时消息，重启后数据丢失）
			for i = 1, #self._inviteBattleChatList, 1 do
				local chat = self._inviteBattleChatList[i]
				if (chat:GetID() == msgId) then --找到了
					bFind = true
					
					--删除此条消息
					table.remove(self._inviteBattleChatList, i)
					
					--从数据库移除聊天消息
					--local sDelete = string.format("delete from `chat` where `id` = %d", msgId)
					local sDelete = string.format("update `chat` set `deleteflag` = 1, `delete_op_uid` = %d where `id` = %d", user:GetUID(), msgId)
					xlDb_Execute(sDelete)
					
					--操作成功
					ret = 1
					
					break
				end
			end
			
			--遍历军团聊天消息
			if (not bFind) then
				local groupId = hGlobal.groupMgr:GetUserGroupID(user:GetUID()) --玩家所在的工会id
				if (groupId > 0) then
					--依次查找id
					for i = 1, #self._groupChatList[groupId], 1 do
						local chat = self._groupChatList[groupId][i]
						if (chat:GetID() == msgId) then --找到了
							bFind = true
							
							if (chat._msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) then --军团发红包
								--此类型消息不能删除
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_DELETE_MSGTYPE
							elseif (chat._msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_RECEIVE) then --军团收红包
								--此类型消息不能删除
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_DELETE_MSGTYPE
							else
								--删除此条消息
								table.remove(self._groupChatList[groupId], i)
								
								--从数据库移除聊天消息
								--local sDelete = string.format("delete from `chat` where `id` = %d", msgId)
								local sDelete = string.format("update `chat` set `deleteflag` = 1, `delete_op_uid` = %d where `id` = %d", user:GetUID(), msgId)
								xlDb_Execute(sDelete)
								
								--操作成功
								ret = 1
							end
							
							break
						end
					end
				end
			end
			
			--遍历私聊消息
			if (not bFind) then
				local result = user:PrivateDeleteMsg(msgId)
				if (result == 1) then --操作成功(私聊)
					ret = 1
					bFind = true
				end
			end
			
			if (not bFind) then
				--无效的消息
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_MSGID
			end
		else
			--您没有权限进行此操作
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY
		end
		
		return ret
	end
	
	--内部删除一条消息
	function ChatMgr:InnerRemoveMessage(msgId, touid)
		--遍历世界聊天消息
		local bFind = false
		for i = 1, #self._chatList, 1 do
			local chat = self._chatList[i]
			if (chat:GetID() == msgId) then --找到了
				bFind = true
				
				--删除此条消息
				table.remove(self._chatList, i)
				
				--从数据库移除聊天消息
				--local sDelete = string.format("delete from `chat` where `id` = %d", msgId)
				local sDelete = string.format("update `chat` set `deleteflag` = 1, `delete_op_uid` = %d where `id` = %d", 0, msgId)
				xlDb_Execute(sDelete)
				
				--操作成功
				ret = 1
				
				break
			end
		end
		
		--遍历军团聊天消息
		if (not bFind) then
			local groupId = touid --工会id
			if (groupId > 0) then
				--依次查找id
				for i = 1, #self._groupChatList[groupId], 1 do
					local chat = self._groupChatList[groupId][i]
					if (chat:GetID() == msgId) then --找到了
						bFind = true
						
						--删除此条消息
						table.remove(self._groupChatList[groupId], i)
						
						--从数据库移除聊天消息
						--local sDelete = string.format("delete from `chat` where `id` = %d", msgId)
						local sDelete = string.format("update `chat` set `deleteflag` = 1, `delete_op_uid` = %d where `id` = %d", 0, msgId)
						xlDb_Execute(sDelete)
						
						--操作成功
						ret = 1
						
						break
					end
				end
			end
		end
		
		return ret
	end
	
	--玩家请求删除一条组队副本邀请聊天消息
	function ChatMgr:RemoveBattleCoupleMessage(user, msgId)
		--操作结果
		local ret = 0
		
		--遍历组队副本邀请消息（临时消息，重启后数据丢失）
		local bFind = false
		for i = 1, #self._inviteBattleChatList, 1 do
			local chat = self._inviteBattleChatList[i]
			if (chat:GetID() == msgId) then --找到了
				bFind = true
				
				--删除此条消息
				table.remove(self._inviteBattleChatList, i)
				
				--从数据库移除聊天消息
				--local sDelete = string.format("delete from `chat` where `id` = %d", msgId)
				local sDelete = string.format("update `chat` set `deleteflag` = 1, `delete_op_uid` = %d where `id` = %d", user:GetUID(), msgId)
				xlDb_Execute(sDelete)
				
				--操作成功
				ret = 1
				
				break
			end
		end
		
		if (not bFind) then
			--无效的消息
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_MSGID
		end
		
		return ret
	end
	
	--系统添加一条私聊消息
	--返回值: 操作结果, chat对象
	function ChatMgr:AddPrivateMessage(tMsg)
		--操作结果
		local ret = 0
		
		--创建消息对象
		local chat = hClass.Chat:create("Chat"):Init(self._chatDBID + 1, tMsg.chatType, tMsg.msgType, tMsg.uid, tMsg.name, tMsg.channelId, tMsg.vip, tMsg.borderId, tMsg.iconId, tMsg.championId, tMsg.leaderId, tMsg.dragonId, tMsg.headId, tMsg.lineId, tMsg.content, tMsg.date, tMsg.touid, tMsg.result, tMsg.resultParam)
		
		if chat then
			ret = 1
		end
		
		--插入数据库聊天消息
		if (ret == 1) then
			self._chatDBID = self._chatDBID + 1
			local sInsert = string.format("insert into `chat`(`id`, `type`, `msg_type`, `uid`, `name`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `content`, `time`, `touid`, `result`, `result_param`) values (%d, %d, %d, %d, '%s', %d, %d, %d, %d, %d, %d, %d, %d, %d, '%s', '%s', %d, %d, %d)", self._chatDBID, tMsg.chatType, tMsg.msgType, tMsg.uid, tMsg.name, tMsg.channelId, tMsg.vip, tMsg.borderId, tMsg.iconId, tMsg.championId, tMsg.leaderId, tMsg.dragonId, tMsg.headId, tMsg.lineId, tMsg.content, tMsg.date, tMsg.touid, tMsg.result, tMsg.resultParam)
			xlDb_Execute(sInsert)
			--print(sInsert)
		end
		
		return chat
	end
	
	--系统删除一条私聊消息
	function ChatMgr:RemovePrivateMessage(msgId, op_uid)
		--从数据库移除聊天消息
		--local sDelete = string.format("delete from `chat` where `id` = %d", msgId)
		local sDelete = string.format("update `chat` set `deleteflag` = 1, `delete_op_uid` = %d where `id` = %d", op_uid, msgId)
		xlDb_Execute(sDelete)
	end
	
	--禁言玩家聊天
	function ChatMgr:ForbiddenUser(user, forbiddenUid, minute)
		--操作结果
		local ret = 0
		local forbiddenUName = nil
		
		--只有管理员才能禁言玩家
		local bTester = user:GetTester()
		if (bTester == 2) then
			ret, forbiddenUName = user:ForbiddenUser(forbiddenUid, minute)
		else
			--您没有权限进行此操作
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY
		end
		
		return ret, forbiddenUName
	end
	
	--查询指定聊天id列表的聊天内容
	function ChatMgr:QueryChatMessageByIDList(user, chatType, friendUid, msgIDList)
		local msgIdNum = #msgIDList
		local sCmd = ""
		local snum = 0
		
		if (chatType == hVar.CHAT_TYPE.WORLD) then --世界聊天频道
			--查询的世界消息数量不超过最大值
			if (#msgIDList <= hVar.CHAT_MAX_LENGTH_WORLD) then
				--依次查找id
				for c = 1, msgIdNum, 1 do
					local msgId = msgIDList[c]
					local NUM = #self._chatList
					for i = 1, NUM, 1 do
						local chat = self._chatList[i]
						if (chat._id == msgId) then
							if (chatType == chat._chatType) then
								local tempStr = chat:ToCmd()
								sCmd = sCmd .. tempStr
								snum = snum + 1
							end
						end
					end
					
					--特殊消息id，表示是系统聊天忠告
					if (msgId == -1) then
						local id = msgId
						local chatType = hVar.CHAT_TYPE.WORLD
						local msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_ADVISE --系统聊天忠告文本消息（世界）
						local uid = 0
						local name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
						local channelId = 0
						local vip = 0
						local borderId = 1000
						local iconId = 1000
						local championId = 0
						local leaderId = 0
						local dragonId = 0
						local headId = 0
						local lineId = 0
						local content = ""
						local date = os.date("%Y-%m-%d %H:%M:%S", os.time())
						local touid = 0
						local result = 0
						local resultParam = 0
						local chat = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
						
						local tempStr = chat:ToCmd()
						sCmd = sCmd .. tempStr
						snum = snum + 1
					end
					
					--特殊消息id，表示是系统聊天忠告2
					if (msgId == -2) then
						local id = msgId
						local chatType = hVar.CHAT_TYPE.WORLD
						local msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_ADVISE2 --系统聊天忠告2文本消息（世界）
						local uid = 0
						local name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
						local channelId = 0
						local vip = 0
						local borderId = 1000
						local iconId = 1000
						local championId = 0
						local leaderId = 0
						local dragonId = 0
						local headId = 0
						local lineId = 0
						local content = ""
						local date = os.date("%Y-%m-%d %H:%M:%S", os.time())
						local touid = 0
						local result = 0
						local resultParam = 0
						local chat = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
						
						local tempStr = chat:ToCmd()
						sCmd = sCmd .. tempStr
						snum = snum + 1
					end
				end
			end
			
			sCmd = tostring(snum) .. ";" .. sCmd
		elseif (chatType == hVar.CHAT_TYPE.INVITE) then --邀请频道
			--查询的邀请消息数量不超过最大值
			if (#msgIDList <= hVar.CHAT_MAX_LENGTH_INVITE) then
				--依次查找id
				for c = 1, msgIdNum, 1 do
					local msgId = msgIDList[c]
					
					--依次遍历军团邀请函消息
					local NUM = #self._inviteChatList
					for i = 1, NUM, 1 do
						local chat = self._inviteChatList[i]
						if (chat._id == msgId) then
							if (chatType == chat._chatType) then
								local tempStr = chat:ToCmd()
								sCmd = sCmd .. tempStr
								snum = snum + 1
							end
						end
					end
					
					--依次遍历组队副本邀请消息（临时消息，重启后数据丢失）
					local NUM = #self._inviteBattleChatList
					for i = 1, NUM, 1 do
						local chat = self._inviteBattleChatList[i]
						if (chat._id == msgId) then
							if (chatType == chat._chatType) then
								local tempStr = chat:ToCmd()
								sCmd = sCmd .. tempStr
								snum = snum + 1
							end
						end
					end
				end
			end
			
			sCmd = tostring(snum) .. ";" .. sCmd
		elseif (chatType == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			--查询私聊消息的消息内容
			sCmd = user:ChatFriendMsgByIDList(chatType, friendUid, msgIDList)
		elseif (chatType == hVar.CHAT_TYPE.GROUP) then --军团聊天频道
			--查询的军团消息数量不超过最大值
			--if (#msgIDList <= hVar.CHAT_MAX_LENGTH_GROUP) then
				--自己在指定军团里，或者是管理员
				local bTester = 0
				if user then
					bTester = user:GetTester()
				end
				local groupId = hGlobal.groupMgr:GetUserGroupID(user:GetUID()) --玩家所在的工会id
				if (groupId == friendUid) or (bTester == 2) then
					--依次查找id
					for c = 1, msgIdNum, 1 do
						local msgId = msgIDList[c]
						local NUM = #self._groupChatList[friendUid]
						for i = 1, NUM, 1 do
							local chat = self._groupChatList[friendUid][i]
							if (chat._id == msgId) then
								if (chatType == chat._chatType) then
									local tempStr = chat:ToCmd()
									sCmd = sCmd .. tempStr
									snum = snum + 1
								end
							end
						end
					end
				end
			--end
			
			sCmd = tostring(snum) .. ";" .. sCmd
		elseif (chatType == hVar.CHAT_TYPE.COUPLE) then --组队聊天频道
			--查询的组队消息数量不超过最大值
			if (#msgIDList <= hVar.CHAT_MAX_LENGTH_WORLD) then
				local sessionId = friendUid --游戏局id
				if (sessionId > 0) then
					--依次查找id
					for c = 1, msgIdNum, 1 do
						local msgId = msgIDList[c]
						local NUM = #self._coupleChatList[sessionId]
						for i = 1, NUM, 1 do
							local chat = self._coupleChatList[sessionId][i]
							if (chat._id == msgId) then
								if (chatType == chat._chatType) then
									local tempStr = chat:ToCmd()
									sCmd = sCmd .. tempStr
									snum = snum + 1
								end
							end
						end
					end
				end
			end
			
			sCmd = tostring(snum) .. ";" .. sCmd
		end
		
		--总长度
		sCmd = tostring(chatType).. ";" .. tostring(friendUid) .. ";" .. sCmd
		
		return sCmd
	end
	
	--发送一条世界系统消息
	function ChatMgr:SendSystemMessage(sysMsgType, content, strDate)
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.WORLD
		tMsg.msgType = sysMsgType
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
		tMsg.content = content
		tMsg.date = strDate
		tMsg.touid = 0
		tMsg.result = 0
		tMsg.resultParam = 0
		
		--添加一条系统消息
		local ret, chat = self:AddMessage(nil, tMsg)
		
		--全服通知消息: 玩家聊天信息
		local alludbid = hGlobal.uMgr:GetAllUserUID()
		local sCmd = chat:ToCmd()
		hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
		--print("全服通知消息: 系统聊天信息")
	end
	
	--发送一条军团系统消息
	function ChatMgr:SendGroupSystemMessage(tMsg)
		local groupId = tMsg.touid
		local sysMsgType = tMsg.msgType
		local nInteractType = tMsg.result
		local nInteractParam = tMsg.resultParam
		
		--如果是军团今日消息，那么删除此交互类型的同个用户今日其它消息
		if (sysMsgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_TODAY) then --工会系统今日消息
			if (nInteractType > 0) then --有交互类型
				--此工会的消息
				local groupChatList = self._groupChatList[groupId]
				
				--待移除的今日系统消息索引值列表
				local tRemoveMsgIdxList = {}
				
				for idx = 1, #groupChatList, 1 do
					local chat_i = groupChatList[idx]
					local msgType_i = chat_i._msgType
					local result_i = chat_i._result
					local resultParam_i = chat_i._resultParam
					local strDate = chat_i._date
					if (msgType_i == hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_TODAY) then --工会系统今日消息
						if (result_i == nInteractType) then --可交互类型一致
							if (resultParam_i == nInteractParam) then --可交互类型参数一致
								--待移除
								tRemoveMsgIdxList[#tRemoveMsgIdxList+1] = idx
							end
						end
					end
				end
				
				--依次移除军团消息
				for p = #tRemoveMsgIdxList, 1, -1 do
					local deleteIdx = tRemoveMsgIdxList[p]
					local msgId = groupChatList[deleteIdx]:GetID()
					table.remove(groupChatList, deleteIdx)
					--print(deleteIdx)
					
					--从数据库移除聊天消息
					local sDelete = string.format("update `chat` set `deleteflag` = 1, `delete_op_uid` = %d where `id` = %d", 0, msgId)
					xlDb_Execute(sDelete)
					
					--军团通知消息: 删除玩家聊天信息
					local tUserTable = hGlobal.groupMgr:GetGroupAllUser(groupId)
					local sCmd = tostring(msgId)
					if tUserTable then
						for uid, level in pairs(tUserTable) do
							hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
						end
					end
				end
			end
		end
		
		--添加一条军团系统消息
		local ret, chat = self:AddMessage(nil, tMsg)
		
		--军团通知消息: 玩家聊天信息
		local tUserTable = hGlobal.groupMgr:GetGroupAllUser(groupId)
		local sCmd = chat:ToCmd()
		if tUserTable then
			for uid, level in pairs(tUserTable) do
				hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
			end
		end
		--print("军团通知消息: 系统聊天信息")
		
		return chat
	end
	
	--聊天id转cmd
	function ChatMgr:ChatIDToCmd(user, chatType, friendUid)
		local sCmd = ""
		local snum = 0 --有效的消息数量
		
		if (chatType == hVar.CHAT_TYPE.WORLD) then --世界聊天频道
			--依次拼接id
			local NUM = #self._chatList
			for i = 1, NUM, 1 do
				local chat = self._chatList[i]
				if (chatType == chat._chatType) then
					local tempStr = tostring(chat._id) .. ";"
					sCmd = sCmd .. tempStr
					snum = snum + 1
				end
			end
			
			--总长度
			sCmd = tostring(chatType) .. ";" .. tostring(friendUid) .. ";" .. tostring(snum) .. ";" .. sCmd
			
			--
			--...
		elseif (chatType == hVar.CHAT_TYPE.INVITE) then --邀请频道
			--依次拼接id
			--依次遍历军团邀请函消息
			local NUM = #self._inviteChatList
			for i = 1, NUM, 1 do
				local chat = self._inviteChatList[i]
				if (chatType == chat._chatType) then
					local tempStr = tostring(chat._id) .. ";"
					sCmd = sCmd .. tempStr
					snum = snum + 1
				end
			end
			
			--依次遍历组队副本邀请消息（临时消息，重启后数据丢失）
			local NUM = #self._inviteBattleChatList
			for i = 1, NUM, 1 do
				local chat = self._inviteBattleChatList[i]
				if (chatType == chat._chatType) then
					local tempStr = tostring(chat._id) .. ";"
					sCmd = sCmd .. tempStr
					snum = snum + 1
				end
			end
			
			--总长度
			sCmd = tostring(chatType) .. ";" .. tostring(friendUid) .. ";" .. tostring(snum) .. ";" .. sCmd
			
			--
			--...
		elseif (chatType == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			--设置最近聊天的好友uid
			user:SetFriendLastUid(friendUid)
			
			--玩家与私聊好友的聊天id转cmd
			sCmd = tostring(chatType) .. ";" .. tostring(friendUid) .. ";" .. user:ChatFriendMsgIdToCmd(friendUid)
			
			--
			--...
		elseif (chatType == hVar.CHAT_TYPE.GROUP) then --军团频道
			local groupId = hGlobal.groupMgr:GetUserGroupID(user:GetUID()) --玩家所在的工会id
			if (groupId > 0) then
				--自己在指定军团里，或者是管理员
				local bTester = 0
				if user then
					bTester = user:GetTester()
				end
				if (groupId == friendUid) or (bTester == 2) then
					--依次拼接id
					local NUM = #self._groupChatList[friendUid]
					for i = 1, NUM, 1 do
						local chat = self._groupChatList[friendUid][i]
						if (chatType == chat._chatType) then
							local tempStr = tostring(chat._id) .. ";"
							sCmd = sCmd .. tempStr
							snum = snum + 1
						end
					end
				end
			end
			
			--总长度
			sCmd = tostring(chatType) .. ";" .. tostring(friendUid) .. ";" .. tostring(snum) .. ";" .. sCmd
			
			--
			--...
		elseif (chatType == hVar.CHAT_TYPE.COUPLE) then --组队频道
			local sessionId = friendUid --游戏局id
			if (sessionId > 0) then
				--依次拼接id
				local NUM = 0
				if self._coupleChatList[sessionId] then
					NUM = #self._coupleChatList[sessionId]
				end
				for i = 1, NUM, 1 do
					local chat = self._coupleChatList[sessionId][i]
					if (chatType == chat._chatType) then
						local tempStr = tostring(chat._id) .. ";"
						sCmd = sCmd .. tempStr
						snum = snum + 1
					end
				end
			end
			
			--总长度
			sCmd = tostring(chatType) .. ";" .. tostring(friendUid) .. ";" .. tostring(snum) .. ";" .. sCmd
			
			--
			--...
		end
		
		return sCmd
	end
	
	--[[
	--全部世界聊天信息转cmd
	function ChatMgr:ChatInfoToCmd()
		local NUM = #self._chatList
		local sCmd = ""
		local snum = 0
		
		--依次拼接
		for i = 1, NUM, 1 do
			local chat = self._chatList[i]
			local tempStr = chat:ToCmd()
			sCmd = sCmd .. tempStr
			snum = snum + 1
		end
		
		--总长度
		sCmd = tostring(snum) .. ";" .. sCmd
		
		return sCmd
	end
	]]
	
	--聊天更新(1秒)
	function ChatMgr:Update()
		local self = hGlobal.chatMgr --self
		
		--输出信息
		local timeNow = hApi.GetClock()
		if (self._statisticsTime > -1) and (timeNow - self._statisticsTime > 1000) then
			local lasttimestamp = self._statisticsTimestamp
			local currenttimestamp = os.time()
			
			self._statisticsTime = timeNow
			self._statisticsTimestamp = currenttimestamp
			
			--检测是否发送系统消息（每日）
			local sDate = os.date("%Y-%m-%d", currenttimestamp)
			for i = 1, #ChatMgr.SYSTEM_NOTICE, 1 do
				local sRefreshTime = ChatMgr.SYSTEM_NOTICE[i].time
				local refresh_time = sDate .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					--print("ok")
					local sysMsgtype = ChatMgr.SYSTEM_NOTICE[i].msgType --提示类系统消息
					local content = ChatMgr.SYSTEM_NOTICE[i].text
					local dayOfWeek = ChatMgr.SYSTEM_NOTICE[i].dayOfWeek
					local strDate = refresh_time
					
					--检测是否有一周指定的天数才能发
					local bDayOK = false
					--local hostTime_pvp = os.time()
					local weekNum = os.date("*t", currenttimestamp).wday - 1
					if (weekNum == 0) then
						weekNum = 7
					end
					if (type(dayOfWeek) == "table") then
						for w = 1, #dayOfWeek, 1 do
							if (dayOfWeek[w] == weekNum) then --找到了
								bDayOK = true
								break
							end
						end
					else
						bDayOK = true
					end
					if bDayOK then
						self:SendSystemMessage(sysMsgtype, content, strDate)
					end
				end
			end
			
			--检测是否处理工会系统消息
			for i = 1, #ChatMgr.SYSTEM_GROUP_CLEARE, 1 do
				local sRefreshTime = ChatMgr.SYSTEM_GROUP_CLEARE[i].time
				local refresh_time = sDate .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					--print("ok")
					
					--计算今日的0点
					--local nTimestampNow = os.time()
					local strDateTodaystampYMD = hApi.Timestamp2Date(nRefreshTime) --转字符串(年月日)
					local strNewTodayZeroDate = strDateTodaystampYMD .. " 00:00:00"
					local nTimestampTodayZero = hApi.GetNewDate(strNewTodayZeroDate)
					--print("strNewTodayZeroDate=", strNewTodayZeroDate)
					--遍历全部工会消息
					for groupId, groupChatList in pairs(self._groupChatList) do
						--待移除的今日系统消息索引值列表
						local tRemoveMsgIdxList = {}
						
						for idx = 1, #groupChatList, 1 do
							local chat_i = groupChatList[idx]
							local msgType_i = chat_i._msgType
							local strDate = chat_i._date
							if (msgType_i == hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_TODAY) then --工会系统今日消息
								--检测日期是否小于今日
								local nMsgDate = hApi.GetNewDate(strDate)
								--print("strDate=", strDate)
								if (nMsgDate < nTimestampTodayZero) then
									--待移除
									tRemoveMsgIdxList[#tRemoveMsgIdxList+1] = idx
								end
							end
						end
						
						--依次移除军团消息
						for p = #tRemoveMsgIdxList, 1, -1 do
							local deleteIdx = tRemoveMsgIdxList[p]
							local msgId = groupChatList[deleteIdx]:GetID()
							table.remove(groupChatList, deleteIdx)
							--print(deleteIdx)
							
							--军团通知消息: 删除玩家聊天信息
							local tUserTable = hGlobal.groupMgr:GetGroupAllUser(groupId)
							local sCmd = tostring(msgId)
							if tUserTable then
								for uid, level in pairs(tUserTable) do
									hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
								end
							end
						end
					end
				end
			end
			
			--检测走马灯消息（每日）
			for i = 1, #ChatMgr.SYSTEM_BUBBLE_NOTICE, 1 do
				local sRefreshTime = ChatMgr.SYSTEM_BUBBLE_NOTICE[i].time
				local refresh_time = sDate .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					local content = ChatMgr.SYSTEM_BUBBLE_NOTICE[i].text
					local bubbleType = ChatMgr.SYSTEM_BUBBLE_NOTICE[i].bubbleType --走马灯类型
					hGlobal.bubblleNoticeMgr:AddBubbleNotice(0, 0, bubbleType, "", 0, content, 0)
				end
			end
		end
		
		--检测世界聊天频道开关
		--3分钟刷新一次
		if (self._worldflagTime > -1) and (timeNow - self._worldflagTime > 180000) then
			local lasttimestamp = self._worldflagTimestamp
			local currenttimestamp = os.time()
			
			self._worldflagTime = timeNow
			self._worldflagTimestamp = currenttimestamp
			
			--查询世界聊天开关
			local worldFlag = 1
			local sql = string.format("select `content` from `tactions` WHERE `type` = %d", 2020)
			local err, strContent = xlDb_Query(sql)
			if (err == 0) then
				worldFlag = tonumber(strContent) or 1
			else
				worldFlag = 1
			end
			--如果开关不一致，通知世界频道聊天开关状态改变
			if (self._worldFlag ~= worldFlag) then
				if (worldFlag == 0) then --关闭
					local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_FORBIDDEN_ALL --全员禁言类系统消息
					local content = hVar.tab_string["__TEXT_CHAT_SYSTEM_FORBIDDEN"]
					local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
					self:SendSystemMessage(sysMsgtype, content, strDate)
				elseif (worldFlag == 1) then --开启
					local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_CANCEL_FORBIDDEN_ALL --取消全员禁言类系统消息
					local content = hVar.tab_string["__TEXT_CHAT_SYSTEM_CANCELFORBIDDEN"]
					local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
					self:SendSystemMessage(sysMsgtype, content, strDate)
				end
				
				self._worldFlag = worldFlag
			end
		end
		
		--检测组队聊天频道已失效消息
		if (self._coupleTime > -1) and (timeNow - self._coupleTime > 60000) then
			local lasttimestamp = self._worldflagTimestamp
			local currenttimestamp = os.time()
			
			self._coupleTime = timeNow
			self._coupleTimestamp = currenttimestamp
			
			--依次遍历全部组队消息，检测时间
			local sDateNow = os.date("%Y-%m-%d %H:%M:%S", currenttimestamp)
			local hour1time = hApi.GetNewDate(sDateNow, "HOUR", -ChatMgr.SYSTEM_COUPLE_VALID_HOUR) --1小时前
			
			for sessionId, chatList in pairs(self._coupleChatList) do
				print("  [couple sessionId] = " .. sessionId)
				for i = #chatList, 1, -1 do
					local chat = chatList[i]
					local date = chat._date
					local nDate = hApi.GetNewDate(date) --消息的时间
					if (nDate < hour1time) then --已失效
						table.remove(chatList, i)
						print("    expired! date = " .. date)
					end
				end
				
				--清空空表
				if (#chatList == 0) then
					self._coupleChatList[sessionId] = nil
				end
			end
		end
	end
	
return ChatMgr