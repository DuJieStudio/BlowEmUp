hHandler.C2L_GROUP_OPR = {}

local __Handler = hHandler.C2L_GROUP_OPR

--GMDebug
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_DEBUG] = function(udbid, rid, msgId, tCmd)

	print("hVar.GROUP_OPR_TYPE.C2L_REQUIRE_DEBUG:",udbid, rid)

	local sql = string.format("SELECT bTester FROM t_user where uid=%d",udbid)
	local err, bTester = xlDb_Query(sql)
	if err == 0 then
		if bTester == 2 then
			dofile("scripts/test.lua")
		end
	end
	
end

--心跳包
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_HEART] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--uid
	local cRid = tonumber(tCmd[2])					--使用角色rid
	local cPingClock = tonumber(tCmd[3])				--ping发送的时间
	local cLastDelay = tonumber(tCmd[4]) or 0			--上一次延时
	
	--print("hVar.GROUP_OPR_TYPE.C2L_REQUIRE_HEART:",cUDbid, cRid)

	--查找用户对象
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	local matchovertime = 0
	if user then
		--
	end

	--返回ping信息
	local sCmd = ""
	sCmd = sCmd .. tostring(hGlobal.uMgr:GetOnlineCount()) .. ";"
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_NOTICE_PING, sCmd)
end

--客户端请求初始化聊天
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_INIT] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--账号uid
	local cRid = tonumber(tCmd[2])				--角色rid
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			user:InitChat()
			local sCmd = user:ChatBaseInfoToCmd()
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_INIT, sCmd)
		end
	end
end

--客户端请求查询聊天id列表
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_ID_LIST] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--账号uid
	local cRid = tonumber(tCmd[2])				--角色rid
	local chatType = tonumber(tCmd[3]) or 0		--聊天频道
	local friendUid = tonumber(tCmd[4]) or 0	--对方好友uid
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			local sCmd = hGlobal.chatMgr:ChatIDToCmd(user, chatType, friendUid)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ID_LIST, sCmd)
		end
	end
end

--客户端请求指定聊天消息id列表的内容
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_CONTENT_LIST] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--账号uid
	local cRid = tonumber(tCmd[2])				--角色rid
	local chatType = tonumber(tCmd[3]) or 0		--聊天频道
	local friendUid = tonumber(tCmd[4]) or 0	--聊天好友uid
	local index = tonumber(tCmd[5])				--当前索引
	local totalnum = tonumber(tCmd[6])			--总索引
	local msgNum = tonumber(tCmd[7])			--聊天id数量
	local msgIDList = {}
	local rIdx = 8
	for i = 1, msgNum, 1 do
		local msgId = tonumber(tCmd[rIdx]) or 0	--聊天消息id
		msgIDList[#msgIDList+1] = msgId
		rIdx = rIdx + 1
	end
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			local sCmd = hGlobal.chatMgr:QueryChatMessageByIDList(user, chatType, friendUid, msgIDList)
			sCmd = tostring(index) .. ";" ..tostring(totalnum) .. ";" .. sCmd
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_CONTENT_LIST, sCmd)
		end
	end
end

--客户端请求查询指定军团的聊天id列表（仅管理员可操作）
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_ID_LIST_GROUP_GM] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])		--账号uid
	local cRid = tonumber(tCmd[2])			--角色rid
	local chatType = tonumber(tCmd[3]) or 0		--聊天频道
	local touid = tonumber(tCmd[4]) or 0		--军团id
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			local bTester = user:GetTester()
			if (bTester == 2) then --仅管理员可操作
				local sCmd = hGlobal.chatMgr:ChatIDToCmd(user, chatType, touid)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ID_LIST, sCmd)
			else
				--通知玩家操作结果
				local ret = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY --"您没有权限进行此操作"
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--客户端请求指定军团的聊天消息id列表的内容（仅管理员可操作）
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_CONTENT_LIST_GROUP_GM] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])		--账号uid
	local cRid = tonumber(tCmd[2])			--角色rid
	local chatType = tonumber(tCmd[3]) or 0		--聊天频道
	local touid = tonumber(tCmd[4]) or 0		--军团id
	local index = tonumber(tCmd[5])				--当前索引
	local totalnum = tonumber(tCmd[6])			--总索引
	local msgNum = tonumber(tCmd[7])		--聊天id数量
	local msgIDList = {}
	local rIdx = 8
	for i = 1, msgNum, 1 do
		local msgId = tonumber(tCmd[rIdx]) or 0	--聊天消息id
		msgIDList[#msgIDList+1] = msgId
		rIdx = rIdx + 1
	end
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			local bTester = user:GetTester()
			if (bTester == 2) then --仅管理员可操作
				local sCmd = hGlobal.chatMgr:QueryChatMessageByIDList(user, chatType, touid, msgIDList)
				sCmd = tostring(index) .. ";" ..tostring(totalnum) .. ";" .. sCmd
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_CONTENT_LIST, sCmd)
			else
				--通知玩家操作结果
				local ret = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY --"您没有权限进行此操作"
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--客户端请求发送一条聊天信息
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_SEND_MESSAGE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--账号uid
	local cRid = tonumber(tCmd[2])				--角色rid
	local chatType = tonumber(tCmd[3]) or 0		--聊天频道
	local msgType = tonumber(tCmd[4]) or 0		--聊天类型
	local userName = tostring(tCmd[5])			--玩家名
	local channelId = tonumber(tCmd[6]) or 0	--渠道号
	local vipLv = tonumber(tCmd[7]) or 0		--vip等级
	local borderId = tonumber(tCmd[8]) or 0		--玩家边框id
	local iconId = tonumber(tCmd[9]) or 0		--玩家头像id
	local championId = tonumber(tCmd[10]) or 0	--玩家称号id
	local leaderId = tonumber(tCmd[11]) or 0	--玩家会长id
	local dragonId = tonumber(tCmd[12]) or 0	--玩家聊天龙王id
	local headId = tonumber(tCmd[13]) or 0		--玩家头衔id
	local lineId = tonumber(tCmd[14]) or 0		--玩家线索id
	local message = tostring(tCmd[15])		--聊天内容
	local touid = tonumber(tCmd[16]) or 0		--接收者uid
	local result = tonumber(tCmd[17]) or 0		--可交互类型消息的操作结果
	local resultParam = tonumber(tCmd[18]) or 0	--可交互类型消息的操作参数
	local tolist = hApi.Split(tCmd[19], "|")	--指定发送的uid列表
	
	local tMsg = {}
	tMsg.chatType = chatType
	tMsg.msgType = msgType
	tMsg.uid = cUDbid
	tMsg.name = userName
	tMsg.channelId = channelId
	tMsg.vip = vipLv
	tMsg.borderId = borderId
	tMsg.iconId = iconId
	tMsg.championId = championId
	tMsg.leaderId = leaderId
	tMsg.dragonId = dragonId
	tMsg.headId = headId
	tMsg.lineId = lineId
	tMsg.content = message
	tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
	tMsg.touid = touid
	tMsg.result = result
	tMsg.resultParam = resultParam
	
	--print(chatType, msgType, cUDbid, userName, touid)
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			local ret, chat = hGlobal.chatMgr:AddMessage(user, tMsg)
			if (ret == 1) then --操作成功
				if (chatType == hVar.CHAT_TYPE.WORLD) then --世界聊天频道
					--全服通知消息: 玩家聊天信息
					local alludbid = hGlobal.uMgr:GetAllUserUID()
					local sCmd = chat:ToCmd()
					hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
				elseif (chatType == hVar.CHAT_TYPE.INVITE) then --邀请聊天频道
					--全服通知消息: 玩家聊天信息
					local alludbid = hGlobal.uMgr:GetAllUserUID()
					local sCmd = chat:ToCmd()
					hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
				elseif (chatType == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
					--告知私聊的双方消息
					local sCmd = chat:ToCmd()
					hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
					hApi.xlNet_Send(touid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
				elseif (chatType == hVar.CHAT_TYPE.GROUP) then --军团频道
					--军团通知消息: 玩家聊天信息
					local tUserTable = hGlobal.groupMgr:GetGroupAllUser(touid)
					local sCmd = chat:ToCmd()
					if tUserTable then
						for uid, level in pairs(tUserTable) do
							hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
						end
					end
				elseif (chatType == hVar.CHAT_TYPE.COUPLE) then --组队频道
					local sCmd = chat:ToCmd()
					--解析uid列表
					for i = 1, #tolist, 1 do
						local to_uid = tonumber(tolist[i]) or 0
						if (to_uid > 0) then
							hApi.xlNet_Send(to_uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
						end
					end
				end
			else --操作失败
				--通知玩家操作结果
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--客户端请求发送一条组队副本邀请聊天信息
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_SEND_MESSAGE_BATTLE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--账号uid
	local cRid = tonumber(tCmd[2])				--角色rid
	local chatType = tonumber(tCmd[3]) or 0		--聊天频道
	local msgType = tonumber(tCmd[4]) or 0		--聊天类型
	local userName = tostring(tCmd[5])			--玩家名
	local channelId = tonumber(tCmd[6]) or 0	--渠道号
	local vipLv = tonumber(tCmd[7]) or 0		--vip等级
	local borderId = tonumber(tCmd[8]) or 0		--玩家边框id
	local iconId = tonumber(tCmd[9]) or 0		--玩家头像id
	local championId = tonumber(tCmd[10]) or 0	--玩家称号id
	local leaderId = tonumber(tCmd[11]) or 0	--玩家会长id
	local dragonId = tonumber(tCmd[12]) or 0	--玩家聊天龙王id
	local headId = tonumber(tCmd[13]) or 0		--玩家头衔id
	local lineId = tonumber(tCmd[14]) or 0		--玩家线索id
	local message = tostring(tCmd[15])		--聊天内容
	local touid = tonumber(tCmd[16]) or 0		--接收者uid
	local result = tonumber(tCmd[17]) or 0		--可交互类型消息的操作结果
	local resultParam = tonumber(tCmd[18]) or 0	--可交互类型消息的操作参数
	local tolist = hApi.Split(tCmd[19], "|")	--指定发送的uid列表
	
	local tMsg = {}
	tMsg.chatType = chatType
	tMsg.msgType = msgType
	tMsg.uid = cUDbid
	tMsg.name = userName
	tMsg.channelId = channelId
	tMsg.vip = vipLv
	tMsg.borderId = borderId
	tMsg.iconId = iconId
	tMsg.championId = championId
	tMsg.leaderId = leaderId
	tMsg.dragonId = dragonId
	tMsg.headId = headId
	tMsg.lineId = lineId
	tMsg.content = message
	tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
	tMsg.touid = touid
	tMsg.result = result
	tMsg.resultParam = resultParam
	
	--print(chatType, msgType, cUDbid, userName, touid)
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			local ret, chat = hGlobal.chatMgr:AddMessage(user, tMsg)
			if (ret == 1) then --操作成功
				--全服通知消息: 玩家聊天信息
				local alludbid = hGlobal.uMgr:GetAllUserUID()
				local sCmd = chat:ToCmd()
				hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
				
				--通知发送者，请求发送组队副本消息的操作结果（成功）
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SEND_MESSAGE_BATTLE, tostring(ret) .. ";" .. tostring(chat:GetID()) .. ";")
			else --操作失败
				--通知玩家操作结果
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
				
				--通知发送者，请求发送组队副本消息的操作结果（失败）
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SEND_MESSAGE_BATTLE, tostring(ret) .. ";0;")
			end
		end
	end
end

--客户端请求发送一条军团今日系统聊天信息
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_SEND_GROUP_SYSTEM_MESSAGE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--账号uid
	local cRid = tonumber(tCmd[2])				--角色rid
	local message = tostring(tCmd[3])			--聊天内容
	local nInteractType = tonumber(tCmd[4]) or 0	--可交互式事件的类型
	
	--print(cUDbid, cRid, message)
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			local groupId = hGlobal.groupMgr:GetUserGroupID(udbid) --玩家所在的工会id
			--print(groupId)
			if (groupId > 0) then
				--发送军团消息
				local tMsg = {}
				tMsg.chatType = hVar.CHAT_TYPE.GROUP
				tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_TODAY --军团系统当日提示消息
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
				tMsg.content = message
				tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
				tMsg.touid = groupId
				tMsg.result = nInteractType --可交互式事件的类型
				tMsg.resultParam = cUDbid --可交互事件的参数为发送者uid
				--发送军团消息
				hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
			end
		end
	end
end

--客户端请求发送一条世界关卡通关系统聊天消息
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_SEND_WORLD_BATTLE_SYSTEM_MESSAGE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--账号uid
	local cRid = tonumber(tCmd[2])				--角色rid
	local message = tostring(tCmd[3])			--聊天内容
	
	--print(cUDbid, cRid, message)
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--发送世界消息
			local tMsg = {}
			tMsg.chatType = hVar.CHAT_TYPE.WORLD --世界聊天频道
			tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_USER_BATTLE --系统文本玩家关卡通关消息
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
			tMsg.content = message
			tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
			tMsg.touid = 0
			tMsg.result = 0 --可交互式事件的类型
			tMsg.resultParam = 0 --可交互事件的参数为发送者uid
			
			--发送世界消息
			local ret, chat = hGlobal.chatMgr:AddMessage(nil, tMsg)
			if (ret == 1) then --操作成功
				--全服通知消息: 玩家聊天信息
				local alludbid = hGlobal.uMgr:GetAllUserUID()
				local sCmd = chat:ToCmd()
				hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
			end
		end
	end
end

--客户端请求更新一条聊天信息
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_UPDATE_MESSAGE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--账号uid
	local cRid = tonumber(tCmd[2])				--角色rid
	local chatType = tonumber(tCmd[3]) or 0		--聊天频道
	local msgId = tonumber(tCmd[4]) or 0		--消息id
	local touid = tonumber(tCmd[5]) or 0		--接收者uid
	--print(chatType, msgId, touid)
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--消息对象
			local chat = nil
			
			if (chatType == hVar.CHAT_TYPE.WORLD) then --世界聊天频道
				--获取世界消息
				chat = hGlobal.chatMgr:GetWorldMsg(msgId)
			elseif (chatType == hVar.CHAT_TYPE.INVITE) then --邀请频道
				--获取邀请消息
				chat = hGlobal.chatMgr:GetInviteMsg(msgId)
			elseif (chatType == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
				--
			elseif (chatType == hVar.CHAT_TYPE.GROUP) then --军团频道
				--获取军团消息
				chat = hGlobal.chatMgr:GetGroupMsg(touid, msgId)
				--print("chat=", chat)
			end
			
			if chat then
				--通知玩家此消息最新内容
				local sCmd = chat:ToCmd()
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_UPDATE_MESSAGE, sCmd)
			end
		end
	end
end

--客户端请求删除一条聊天信息（只有管理员才有权限操作）
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_REMOVE_MESSGAE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--账号uid
	local cRid = tonumber(tCmd[2])				--角色rid
	local msgId = tonumber(tCmd[3]) or 0		--消息唯一id
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			local ret = hGlobal.chatMgr:RemoveMessage(user, msgId)
			
			if (ret == 1) then --操作成功
				--全服通知消息: 删除玩家聊天信息
				local alludbid = hGlobal.uMgr:GetAllUserUID()
				local sCmd = tostring(msgId)
				hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
			else --操作失败
				--通知玩家操作结果
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--客户端请求删除一条组队副本邀请聊天信息
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_REMOVE_MESSGAE_BATTLE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--账号uid
	local cRid = tonumber(tCmd[2])				--角色rid
	local msgId = tonumber(tCmd[3]) or 0		--消息唯一id
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			local ret = hGlobal.chatMgr:RemoveBattleCoupleMessage(user, msgId)
			
			if (ret == 1) then --操作成功
				--全服通知消息: 删除玩家聊天信息
				local alludbid = hGlobal.uMgr:GetAllUserUID()
				local sCmd = tostring(msgId)
				hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
			else --操作失败
				--geyachao: 消息不存在也不用提示错误信息
				--[[
				--通知玩家操作结果
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
				]]
			end
		end
	end
end

--客户端请求禁言玩家聊天（只有管理员才有权限操作）
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_FORBIDDEN_USER] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--账号uid
	local cRid = tonumber(tCmd[2])				--角色rid
	local forbiddenUid = tonumber(tCmd[3]) or 0	--禁言的玩家id
	local minute = tonumber(tCmd[4]) or 0		--禁言的时长（单位: 分钟）
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--禁言玩家
			local ret, forbiddenUName = hGlobal.chatMgr:ForbiddenUser(user, forbiddenUid, minute)
			
			if (ret == 1) then --操作成功
				--发送全体玩家一条禁言消息
				local sysMsgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_FORBIDDEN --禁言类系统消息
				local content = string.format(hVar.tab_string["__TEXT_CHAT_FORBIDDEN"], forbiddenUName, minute)
				--如果大于1天，改为显示禁言n天
				local day = math.floor(minute / 1440)
				local minuteMod = minute - day * 1440
				--if (day > 0) and (minuteMod == 0) then
				if (day > 0) then
					content = string.format(hVar.tab_string["__TEXT_CHAT_FORBIDDEN_DAY"], forbiddenUName, day)
				end
				local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
				hGlobal.chatMgr:SendSystemMessage(sysMsgType, content, strDate)
				
				--如果被禁言的玩家在线，给他发送被禁言的通知
				local forbiddenUser = hGlobal.uMgr:FindChatUserByDBID(forbiddenUid)
				if forbiddenUser then
					local sCmd = forbiddenUser:ChatBaseInfoToCmd()
					hApi.xlNet_Send(forbiddenUser:GetUID(), hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_USER_FORBIDDEN, sCmd)
				end
			else --操作失败
				--通知玩家操作结果
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--客户端请求和对方玩家发起私聊
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_PRIVATE_INVITE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--账号uid
	local cRid = tonumber(tCmd[2])					--角色rid
	local userName = tostring(tCmd[3])				--我的玩家名
	local channelId = tonumber(tCmd[4]) or 0		--我的渠道号
	local vipLv = tonumber(tCmd[5]) or 0			--我的vip等级
	local borderId = tonumber(tCmd[6]) or 0			--我的玩家边框id
	local iconId = tonumber(tCmd[7]) or 0			--我的玩家头像id
	local championId = tonumber(tCmd[8]) or 0		--我的玩家称号id
	local leaderId = tonumber(tCmd[9]) or 0			--玩家会长id
	local dragonId = tonumber(tCmd[10]) or 0		--玩家聊天龙王id
	local headId = tonumber(tCmd[11]) or 0			--玩家头衔id
	local lineId = tonumber(tCmd[12]) or 0			--玩家线索id
	local friendUid = tonumber(tCmd[13]) or 0		--对方账号uid
	local friendUserName = tostring(tCmd[14])		--对方玩家名
	local friendChannelId = tonumber(tCmd[15]) or 0		--对方渠道号
	local friendVipLv = tonumber(tCmd[16]) or 0		--对方vip等级
	local friendBorderId = tonumber(tCmd[17]) or 0		--对方玩家边框id
	local friendIconId = tonumber(tCmd[18]) or 0		--对方玩家头像id
	local friendChampionId = tonumber(tCmd[19]) or 0	--对方玩家称号id
	local friendLeaderId = tonumber(tCmd[20]) or 0		--对方玩家会长id
	local friendDragonId = tonumber(tCmd[21]) or 0		--对方玩家聊天龙王id
	local friendHeadId = tonumber(tCmd[22]) or 0		--对方玩家头衔id
	local friendLineId = tonumber(tCmd[23]) or 0		--对方玩家线索id
	
	--print(friendIconId, friendChampionId, friendLeaderId)
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			local tMsgMe = {}
			tMsgMe.uid = udbid
			tMsgMe.name = userName
			tMsgMe.channelId = channelId
			tMsgMe.vip = vipLv
			tMsgMe.borderId = borderId
			tMsgMe.iconId = iconId
			tMsgMe.championId = championId
			tMsgMe.leaderId = leaderId
			tMsgMe.dragonId = dragonId
			tMsgMe.headId = headId
			tMsgMe.lineId = lineId
			
			local tMsgFriend = {}
			tMsgFriend.uid = friendUid
			tMsgFriend.name = friendUserName
			tMsgFriend.channelId = friendChannelId
			tMsgFriend.vip = friendVipLv
			tMsgFriend.borderId = friendBorderId
			tMsgFriend.iconId = friendIconId
			tMsgFriend.championId = friendChampionId
			tMsgFriend.leaderId = friendLeaderId
			tMsgFriend.dragonId = friendDragonId
			tMsgFriend.headId = friendHeadId
			tMsgFriend.lineId = friendLineId
			
			--请求和玩家私聊
			local ret = user:PrivateInviteUser(tMsgMe, tMsgFriend)
			
			if (ret == 1) then --操作成功
				--通知玩家增加单个私聊好友
				local sCmdFriendInfo = user:SingleFriendInfoToCmd(friendUid)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_PRIVATE_USER, sCmdFriendInfo)
				
				--通知对方增加单个私聊好友
				local friendUser = hGlobal.uMgr:FindChatUserByDBID(friendUid)
				--如果对方玩家存在
				if friendUser then
					local sCmdFriendInfo = friendUser:SingleFriendInfoToCmd(udbid)
					hApi.xlNet_Send(friendUid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_PRIVATE_USER, sCmdFriendInfo)
				end
				
				--通知玩家发起私聊结果（成功）
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_PRIVATE_INVITE, sCmd)
			else --操作失败
				--通知玩家操作结果
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
				
				--通知玩家发起私聊结果（失败）
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_PRIVATE_INVITE, sCmd)
			end
		end
	end
end

--客户端私聊验证消息的操作
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_PRIVATE_INVITE_OP] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--账号uid
	local cRid = tonumber(tCmd[2])					--角色rid
	local msgId = tonumber(tCmd[3]) or 0			--消息唯一id
	local touid = tonumber(tCmd[4]) or 0			--消息接收者uid
	local inviteFlag = tonumber(tCmd[5]) or 0		--操作结果
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--私聊邀请操作
			local ret = user:PrivateInviteOperation(msgId, touid, inviteFlag)
			
			if (ret == 1) then --操作成功
				--不处理
				--...
			else --操作失败
				--通知玩家操作结果
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--客户端请求删除私聊好友
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_PRIVATE_DELETE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--账号uid
	local cRid = tonumber(tCmd[2])					--角色rid
	local touid = tonumber(tCmd[3]) or 0			--消息接收者uid
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--私聊邀请操作
			local ret = user:PrivateDeleteFriend(touid)
			
			if (ret == 1) then --操作成功
				--通知玩家删除好友
				local sCmd = tostring(touid)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_PRIVATE_USER, sCmd)
			else --操作失败
				--通知玩家操作结果
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--客户端请求兑换战术卡碎片
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_EXCHAGE_TACTIC_DEBRIS] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--账号uid
	local cRid = tonumber(tCmd[2])					--角色rid
	local cardNum = tonumber(tCmd[3]) or 0			--选择的卡片种类总数量
	local tCardList = {}
	local rIdx = 3
	for i = 1, cardNum, 1 do
		local tTacticInfo = hApi.Split(tCmd[rIdx+i], ":")
		local tacticId = tonumber(tTacticInfo[1]) or 0 --战术卡id
		local tacticNum = tonumber(tTacticInfo[2]) or 0 --战术卡数量
		--print(tacticId, tacticNum)
		tCardList[#tCardList+1] = {id = tacticId, num = tacticNum,}
	end
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--请求兑换战术卡碎片
			local sCmd = NoviceCampMgr.ExchangeTacticDebris(udbid, rid, tCardList)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_EXCHAGE_TACTIC_DEBRIS, sCmd)
		end
	end
end

--客户端请求查询英雄将魂信息
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_HERO_DEBRIS_INFO] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--账号uid
	local cRid = tonumber(tCmd[2])					--角色rid
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--请求兑换战术卡碎片
			local tHeroInfo, sCmd = hGlobal.heroDebrisMgr:DBGetUserHeroDebris(udbid, rid)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_QUERY_HERO_DEBRIS_INFO, sCmd)
		end
	end
end

--客户端请求兑换英雄将魂
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_EXCHAGE_HERO_DEBRIS] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--账号uid
	local cRid = tonumber(tCmd[2])					--角色rid
	local cardNum = tonumber(tCmd[3]) or 0			--选择的卡片种类总数量
	local tCardList = {}
	local rIdx = 3
	for i = 1, cardNum, 1 do
		local tTacticInfo = hApi.Split(tCmd[rIdx+i], ":")
		local heroId = tonumber(tTacticInfo[1]) or 0 --英雄id
		local heroNum = tonumber(tTacticInfo[2]) or 0 --英雄数量
		--print(heroId, heroNum)
		tCardList[#tCardList+1] = {id = heroId, num = heroNum,}
	end
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--请求兑换英雄将魂
			local sCmd = NoviceCampMgr.ExchangeHeroDebris(udbid, rid, tCardList)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_EXCHAGE_HERO_DEBRIS, sCmd)
		end
	end
end

--客户端请求购买军团副本次数
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_BUY_BATTLE_COUNT] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--账号uid
	local cRid = tonumber(tCmd[2])					--角色rid
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--请求购买军团副本次数
			local sCmd = NoviceCampMgr.BuyGroupBattleCount(udbid, rid)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_BUY_BATTLE_COUNT, sCmd)
		end
	end
end

--客户端请求发送军团红包
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_SEND_GROUP_REDPACKET] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--账号uid
	local cRid = tonumber(tCmd[2])				--角色rid
	local userName = tostring(tCmd[3])			--玩家名
	local channelId = tonumber(tCmd[4]) or 0	--渠道号
	local vipLv = tonumber(tCmd[5]) or 0		--vip等级
	local borderId = tonumber(tCmd[6]) or 0		--玩家边框id
	local iconId = tonumber(tCmd[7]) or 0		--玩家头像id
	local championId = tonumber(tCmd[8]) or 0	--玩家称号id
	local leaderId = tonumber(tCmd[9]) or 0		--玩家会长id
	local dragonId = tonumber(tCmd[10]) or 0	--玩家聊天龙王id
	local headId = tonumber(tCmd[11]) or 0		--玩家头衔id
	local lineId = tonumber(tCmd[12]) or 0		--玩家线索id
	local groupId = tonumber(tCmd[13])		--军团id
	local sendIndex = tonumber(tCmd[14])		--红包数量
	
	local tMsg = {}
	tMsg.chatType = hVar.CHAT_TYPE.GROUP
	tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND --军团发红包
	tMsg.uid = cUDbid
	tMsg.name = userName
	tMsg.channelId = channelId
	tMsg.vip = vipLv
	tMsg.borderId = borderId
	tMsg.iconId = iconId
	tMsg.championId = championId
	tMsg.leaderId = leaderId
	tMsg.dragonId = dragonId
	tMsg.headId = headId
	tMsg.lineId = lineId
	tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_SEND_REDPACKET"], userName)
	tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
	tMsg.touid = groupId
	tMsg.result = hVar.RED_PACKET_TYPE.GROUP_SEND --可交互事件的交互类型
	tMsg.resultParam = 0
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--请求发送军团红包
			local ret, sRetCmd = hGlobal.redPacketGroupMgr:SendRedPacket(user, rid, groupId, sendIndex, tMsg)
			
			if (ret == 1) then --操作成功
				--通知玩家发红包结果
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_SEND_REDPACKET, sRetCmd)
			else --操作失败
				--通知玩家发红包结果
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_SEND_REDPACKET, sRetCmd)
				
				--通知玩家操作结果
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--客户端请求领取军团红包
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_RECEIVE_GROUP_REDPACKET] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--账号uid
	local cRid = tonumber(tCmd[2])				--角色rid
	local userName = tostring(tCmd[3])			--玩家名
	local channelId = tonumber(tCmd[4]) or 0	--渠道号
	local vipLv = tonumber(tCmd[5]) or 0		--vip等级
	local borderId = tonumber(tCmd[6]) or 0		--玩家边框id
	local iconId = tonumber(tCmd[7]) or 0		--玩家头像id
	local championId = tonumber(tCmd[8]) or 0	--玩家称号id
	local leaderId = tonumber(tCmd[9]) or 0		--玩家会长id
	local dragonId = tonumber(tCmd[10]) or 0	--玩家聊天龙王id
	local headId = tonumber(tCmd[11]) or 0		--玩家头衔id
	local lineId = tonumber(tCmd[12]) or 0		--玩家线索id
	local groupId = tonumber(tCmd[13])		--军团id
	local redPacketId = tonumber(tCmd[14])		--红包id
	
	--红包发送者名字
	--local redPacketSendName = ""
	local redPacketGroup = hGlobal.redPacketGroupMgr:GetRedPacket(redPacketId)
	--if redPacketGroup then
	--	redPacketSendName = redPacketGroup._send_name
	--end
	
	local tMsg = {}
	tMsg.chatType = hVar.CHAT_TYPE.GROUP
	tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_RECEIVE
	tMsg.uid = 0
	tMsg.name = userName
	tMsg.channelId = 0 --channelId
	tMsg.vip = 0 --vipLv
	tMsg.borderId = 1000 --borderId
	tMsg.iconId = 1000 --iconId
	tMsg.championId = 0 --championId
	tMsg.leaderId = 0 --leaderId
	tMsg.dragonId = 0 --dragonId
	tMsg.headId = 0 --headId
	tMsg.lineId = 0 --lineId
	tMsg.content = "" --string.format(hVar.tab_string["__TEXT_CHAT_GROUP_RECEIVE_REDPACKET"], userName, redPacketSendName)
	tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
	tMsg.touid = groupId
	tMsg.result = hVar.RED_PACKET_TYPE.GROUP_RECEIVE --可交互事件的交互类型
	tMsg.resultParam = 0
	
	--红包领取的文字，预检测是否本次领完红包
	--if ((redPacketGroup._send_num - redPacketGroup._receive_num - 1) <= 0) then
	--	tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_RECEIVE_EMPTY_REDPACKET"], userName, redPacketSendName)
	--end
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--请求领取军团红包
			local ret, sRetCmd = hGlobal.redPacketGroupMgr:ReceiveRedPacket(user, rid, groupId, redPacketId, tMsg)
			
			if (ret == 1) then --操作成功
				--通知玩家领红包结果
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_RECEIVE_REDPACKET, sRetCmd)
				
				--军团通知消息: 更新聊天信息
				local msgIdRedPacket = redPacketGroup._msg_id
				--print("msgIdRedPacket=", msgIdRedPacket)
				local chatRedPacket = hGlobal.chatMgr:GetGroupMsg(groupId, msgIdRedPacket)
				--print("chatRedPacket=", chatRedPacket)
				if chatRedPacket then
					local sCmdRedPacket = chatRedPacket:ToCmd()
					--print("sCmdRedPacket=", sCmdRedPacket)
					local tUserTable = hGlobal.groupMgr:GetGroupAllUser(groupId)
					if tUserTable then
						for uid, level in pairs(tUserTable) do
							--print("uid=", uid, "level=", level)
							hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_UPDATE_MESSAGE, sCmdRedPacket)
						end
					end
				end
			else --操作失败
				--通知玩家领红包结果
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_RECEIVE_REDPACKET, sRetCmd)
				
				--通知玩家操作结果
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--客户端请求领取支付（土豪）红包
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_RECEIVE_PAY_REDPACKET] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--账号uid
	local cRid = tonumber(tCmd[2])				--角色rid
	local userName = tostring(tCmd[3])			--玩家名
	local channelId = tonumber(tCmd[4]) or 0	--渠道号
	local vipLv = tonumber(tCmd[5]) or 0		--vip等级
	local borderId = tonumber(tCmd[6]) or 0		--玩家边框id
	local iconId = tonumber(tCmd[7]) or 0		--玩家头像id
	local championId = tonumber(tCmd[8]) or 0	--玩家称号id
	local leaderId = tonumber(tCmd[9]) or 0		--玩家会长id
	local dragonId = tonumber(tCmd[10]) or 0	--玩家聊天龙王id
	local headId = tonumber(tCmd[11]) or 0		--玩家头衔id
	local lineId = tonumber(tCmd[12]) or 0		--玩家线索id
	local redPacketId = tonumber(tCmd[13])		--红包id
	
	--红包发送者名字
	--local redPacketSendName = ""
	local redPacketPay = hGlobal.redPacketPayMgr:GetRedPacket(redPacketId)
	--if redPacketPay then
	--	redPacketSendName = redPacketPay._send_name
	--end
	
	local tMsg = {}
	tMsg.chatType = hVar.CHAT_TYPE.WORLD --世界消息
	tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_RECEIVE
	tMsg.uid = udbid
	tMsg.name = userName
	tMsg.channelId = channelId
	tMsg.vip = vipLv
	tMsg.borderId = borderId
	tMsg.iconId = iconId
	tMsg.championId = championId
	tMsg.leaderId = leaderId
	tMsg.dragonId = dragonId
	tMsg.headId = headId
	tMsg.lineId = lineId
	tMsg.content = "" --string.format(hVar.tab_string["__TEXT_CHAT_GROUP_RECEIVE_REDPACKET"], userName, redPacketSendName)
	tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
	tMsg.touid = 0
	tMsg.result = hVar.RED_PACKET_TYPE.PAY_RECEIVE --可交互事件的交互类型
	tMsg.resultParam = 0
	
	--红包领取的文字，预检测是否本次领完红包
	--if ((redPacketPay._send_num - redPacketPay._receive_num - 1) <= 0) then
	--	tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_RECEIVE_EMPTY_REDPACKET"], userName, redPacketSendName)
	--end
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--请求领取支付（土豪）红包
			local ret, sRetCmd = hGlobal.redPacketPayMgr:ReceiveRedPacket(user, rid, redPacketId, tMsg)
			
			if (ret == 1) then --操作成功
				--通知玩家领红包结果
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_PAY_RECEIVE_REDPACKET, sRetCmd)
				
				--通知全体玩家，更新聊天信息
				local msgIdRedPacket = redPacketPay._msg_id
				--print("msgIdRedPacket=", msgIdRedPacket)
				local chatRedPacket = hGlobal.chatMgr:GetWorldMsg(msgIdRedPacket)
				--print("chatRedPacket=", chatRedPacket)
				if chatRedPacket then
					local sCmdRedPacket = chatRedPacket:ToCmd()
					--print("sCmdRedPacket=", sCmdRedPacket)
					local alludbid = hGlobal.uMgr:GetAllUserUID()
					hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_UPDATE_MESSAGE, sCmdRedPacket)
				end
			else --操作失败
				--通知玩家领红包结果
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_PAY_RECEIVE_REDPACKET, sRetCmd)
				
				--通知玩家操作结果
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--客户端请求查看支付（土豪）红包的领取详情
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_VIEWDETAIL_PAY_REDPACKET] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--账号uid
	local cRid = tonumber(tCmd[2])				--角色rid
	local redPacketId = tonumber(tCmd[3])		--红包id
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--请求查看支付（土豪）红包的的领取详情
			local ret, sRetCmd = hGlobal.redPacketPayMgr:ViewDetailRedPacket(user, rid, redPacketId)
			
			if (ret == 1) then --操作成功
				--通知玩家查看红包的领取详情结果
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_PAY_VIEWDETAIL_REDPACKET, sRetCmd)
			else --操作失败
				--通知玩家查看红包的领取详情结果
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_PAY_VIEWDETAIL_REDPACKET, sRetCmd)
				
				--通知玩家操作结果
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--客户端请求查询军团军饷任务完成情况
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_MILITARY_TASK_INFO] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--账号uid
	local cRid = tonumber(tCmd[2])					--角色rid
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--请求查询军团军饷任务完成情况
			local sCmd = NoviceCampMgr.QueryGroupMilitaryTaskState(udbid, rid)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_MILITARY_TASK_QUERY, sCmd)
		end
	end
end

--客户端请求领取军团军饷任务
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_MILITARY_TASK_TAKEREWARD] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--账号uid
	local cRid = tonumber(tCmd[2])					--角色rid
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--请求领取军团军饷任务
			local sCmd = NoviceCampMgr.TakeRewardGroupMilitaryTask(udbid, rid)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_MILITARY_TASK_TAKEREWARD, sCmd)
		end
	end
end

--客户端请求踢出长期不在线的其他军团的玩家（仅管理员可操作）
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_KICK_OFFLINE_PLAYER] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--账号uid
	local cRid = tonumber(tCmd[2])					--角色rid
	local groupId = tonumber(tCmd[3])				--军团id
	local kickUid = tonumber(tCmd[4])				--踢出的玩家id
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--请求踢出长期不在线的其他军团的玩家（仅管理员可操作）
			local sCmd = NoviceCampMgr.KickGroupOfflinePlayer(udbid, rid, groupId, kickUid)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_KICK_OFFLINE_PLAYER, sCmd)
		end
	end
end

--客户端请求任命玩家为会长（仅管理员可操作）
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_ASSET_ADMIN_PLAYER] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--账号uid
	local cRid = tonumber(tCmd[2])					--角色rid
	local groupId = tonumber(tCmd[3])				--军团id
	local kickUid = tonumber(tCmd[4])				--任命的玩家id
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--请求任命玩家为会长（仅管理员可操作）
			local sCmd = NoviceCampMgr.AssetAdminPlayer(udbid, rid, groupId, kickUid)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_ASSET_ADMIN_PLAYER, sCmd)
		end
	end
end

--会长请求转让军团给助理
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_TRANSFER] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--账号uid
	local cRid = tonumber(tCmd[2])					--角色rid
	local groupId = tonumber(tCmd[3])				--军团id
	local kickUid = tonumber(tCmd[4])				--转让的玩家id
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--会长请求转让军团给助理
			local sCmd = NoviceCampMgr.AssetGroupTransfer(udbid, rid, groupId, kickUid)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_TRANSFER, sCmd)
		end
	end
end

--客户端请求解散军团（仅管理员可操作）
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_DISOLUTE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--账号uid
	local cRid = tonumber(tCmd[2])					--角色rid
	local groupId = tonumber(tCmd[3])				--军团id
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--请求解散军团（仅管理员可操作）
			local sCmd = NoviceCampMgr.AssetGroupDisolute(udbid, rid, groupId)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_DISOLUTE, sCmd)
		end
	end
end

--客户端请求创建军团邀请函
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_INVITE_CREATE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--账号uid
	local cRid = tonumber(tCmd[2])				--角色rid
	local userName = tostring(tCmd[3])			--玩家名
	local channelId = tonumber(tCmd[4]) or 0	--渠道号
	local vipLv = tonumber(tCmd[5]) or 0		--vip等级
	local borderId = tonumber(tCmd[6]) or 0		--玩家边框id
	local iconId = tonumber(tCmd[7]) or 0		--玩家头像id
	local championId = tonumber(tCmd[8]) or 0	--玩家称号id
	local leaderId = tonumber(tCmd[9]) or 0		--玩家会长id
	local dragonId = tonumber(tCmd[10]) or 0	--玩家聊天龙王id
	local headId = tonumber(tCmd[11]) or 0		--玩家头衔id
	local lineId = tonumber(tCmd[12]) or 0		--玩家线索id
	local groupId = tonumber(tCmd[13])		--军团id
	local dayMin = tonumber(tCmd[14])		--需要的最小注册天数
	local vipMin = tonumber(tCmd[15])		--需要的最小vip等级
	
	local tMsg = {}
	tMsg.chatType = hVar.CHAT_TYPE.INVITE
	tMsg.msgType = hVar.MESSAGE_TYPE.INVITE_GROUP --军团邀请函
	tMsg.uid = cUDbid
	tMsg.name = userName
	tMsg.channelId = channelId
	tMsg.vip = vipLv
	tMsg.borderId = borderId
	tMsg.iconId = iconId
	tMsg.championId = championId
	tMsg.leaderId = leaderId
	tMsg.dragonId = dragonId
	tMsg.headId = headId
	tMsg.lineId = lineId
	tMsg.content = hVar.tab_string["__TEXT_CHAT_GROUP_INVITE_SEND"]
	tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
	tMsg.touid = groupId
	tMsg.result = hVar.GROUP_INVITE_TYPE.GROUP_INVITE_SEND --可交互事件的交互类型
	tMsg.resultParam = 0
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--创建军团邀请函
			local ret, sCmd = hGlobal.inviteGroupMgr:AddGroupInvite(user, rid, groupId, dayMin, vipMin, tMsg)
			if (ret == 1) then
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_INVITE_CREATE, sCmd)
			else --操作失败
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_INVITE_CREATE, sCmd)
				
				--通知玩家操作结果
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--客户端请求加入军团邀请函
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_INVITE_JOIN] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--账号uid
	local cRid = tonumber(tCmd[2])					--角色rid
	local groupInviteId = tonumber(tCmd[3])				--军团邀请函id
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--请求加入军团邀请函
			local ret, sCmd = hGlobal.inviteGroupMgr:GroupInviteJoin(user, rid, groupInviteId)
			if (ret == 1) then
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_INVITE_JOIN, sCmd)
			else --操作失败
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_INVITE_JOIN, sCmd)
				
				--通知玩家操作结果
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

































------------------------------------------------------------------------------------------------------------
--军团第一个指令
--请求新手营列表
__Handler[hVar.GROUP_OPR_TYPE.C2L_NOVICECAMP_LIST] = function(udbid, rid, msgId, sCmd)
	--查找用户对象
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print(udbid, user)
	--如果玩家存在
	if user then
		--玩家初始化
		user:InitChat()
		local sInitCmd = user:ChatBaseInfoToCmd()
		hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_INIT, sInitCmd)
		
		--请求返回
		local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
		local resCmd = NoviceCampMgr.GetNcList(tCmd)
		hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_LIST,resCmd)
	end
end

--新手申请军团请求军团列表
__Handler[hVar.GROUP_OPR_TYPE.C2L_NOVICECAMP_LIST_JOIN] = function(udbid, rid, msgId, sCmd)
	--查找用户对象
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print(udbid, user)
	--如果玩家存在
	if user then
		local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
		local resCmd = NoviceCampMgr.Data_GetNcList_Join(tCmd)
		hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_LIST_JOIN,resCmd)
	end
end

--创建新手营
__Handler[hVar.GROUP_OPR_TYPE.C2L_NOVICECAMP_CREATE] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.CreateNc(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_CREATE,resCmd)
end

--解散新手营
__Handler[hVar.GROUP_OPR_TYPE.C2L_NOVICECAMP_REMOVE] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.RemoveNc(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_REMOVE,resCmd)
end

--查看成员列表
__Handler[hVar.GROUP_OPR_TYPE.C2L_MEMBER_LIST] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.GetMemberList(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_MEMBER_LIST,resCmd)
end

--营长通过新手申请
__Handler[hVar.GROUP_OPR_TYPE.C2L_POWER_JION_ACCEPT] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.PowerJionAccept(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_POWER_JION_ACCEPT,resCmd)
end

--营长驳回新手申请
__Handler[hVar.GROUP_OPR_TYPE.C2L_POWER_JION_REJECT] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.PowerJionReject(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_POWER_JION_REJECT,resCmd)
end

--新手申请加营
__Handler[hVar.GROUP_OPR_TYPE.C2L_POWER_JION_REQUEST] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.PowerJionRequest(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_POWER_JION_REQUEST,resCmd)
end

--新手取消申请
__Handler[hVar.GROUP_OPR_TYPE.C2L_POWER_JION_CANCEL] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.PowerJionCancel(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_POWER_JION_CANCEL,resCmd)
end

--更新新手营信息
__Handler[hVar.GROUP_OPR_TYPE.C2L_NOVICECAMP_UPDATE] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.UpdateNc(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_UPDATE,resCmd)
end

--新手营改名
__Handler[hVar.GROUP_OPR_TYPE.C2L_NOVICECAMP_RENAME] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.ReNameNc(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_RENAME,resCmd)
end

--踢人
__Handler[hVar.GROUP_OPR_TYPE.C2L_POWER_FIRE] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.PowerFire(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_POWER_FIRE,resCmd)
end

--会长任命助理
__Handler[hVar.GROUP_OPR_TYPE.C2L_POWER_ASSISTANT_APPOINT] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.AssistantAppoint(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_POWER_ASSISTANT_APPOINT,resCmd)
end

--会长取消任命助理
__Handler[hVar.GROUP_OPR_TYPE.C2L_POWER_ASSISTANT_DISAPPOINT] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.AssistantAppointCancel(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_POWER_ASSISTANT_DISAPPOINT,resCmd)
end

--请求奖励信息
__Handler[hVar.GROUP_OPR_TYPE.C2L_CONFIG_PRIZE] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.PrizeInfo(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_CONFIG_PRIZE,resCmd)
end

--升级建筑
__Handler[hVar.GROUP_OPR_TYPE.C2L_BUILDING_UPGRADE] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.BuildUpgrade(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_BUILDING_UPGRADE,resCmd)
end

--获取建筑奖励
__Handler[hVar.GROUP_OPR_TYPE.C2L_BUILDING_PRIZE] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.BuildPrize(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_BUILDING_PRIZE,resCmd)
end

--退出
__Handler[hVar.GROUP_OPR_TYPE.C2L_POWER_QUIT] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.PowerQuit(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_POWER_QUIT,resCmd)
end

--战术卡升级
__Handler[hVar.GROUP_OPR_TYPE.C2L_CARD_UPGRADE] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.CardUpgrade(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_CARD_UPGRADE,resCmd)
end

--客户端请求查找军团
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_SEARCH] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local cUDbid = tCmd.uid					--账号uid
	local cRid = tCmd.rid					--角色rid
	local searchName = tCmd.searchName			--搜索的名字
	
	--检验消息来源的有效性
	if (cUDbid == udbid) and (cRid == rid) then
		--查找用户对象
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--如果玩家存在
		if user then
			--请求查找军团
			local sCmd = NoviceCampMgr.Data_GetNcList_Join_Seach(tCmd)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_SEARCH_RET, sCmd)
		end
	end
end