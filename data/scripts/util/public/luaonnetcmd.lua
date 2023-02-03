
hHandler.L2C_DB_OPR = {}	--服务器脚本系统协议接收统一通道（程序3003号协议） by zhenkira 2016.04.11

local __Handler = hHandler.L2C_DB_OPR
local __rh = hVar.DB_RECV_TYPE		--receive head



--网络协议接收处理
--收到消息的总入口
--DBLuaOnNetPack = function(NetPack)
function DBLuaOnNetPack(NetPack)
	--print("DBLuaOnNetPack")
	local protocolId = NetPack[1]
	--程序的约定,服务器脚本协议协议号为66666
	if protocolId and protocolId == 66666 then
		--从第二位开始去协议ID
		local typeID = NetPack[2]
		local param1 = NetPack[3]
		local param2 = NetPack[4]
		local data = NetPack[5]
		--print("PvpLuaOnNetPack typeid:" .. tostring(typeID))
		if typeID and data and type(data) == "string" and type(__Handler[typeID]) == "function" then
			--local netData = {}
			--for i = 3,#NetPack do
			--	netData[#netData+1] = NetPack[i]
			--end
			--脚本协议数据,第三位为字符串.
			--local tCmd = hApi.Split(data, ";")
			__Handler[typeID](data)
		end
	else
		print("PvpLuaOnNetPack unknown potocolId:", protocolId)
	end
end


__Handler[__rh.L2C_SYSTIME] = function(sCmd)
	--[[
	--geyachao: 转化为本地时间
	local str_systime = packet:readString() --存储服务器时间(GMT+8)
	local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
	local delteZone = localTimeZone - 8 --与北京时间的时差
	local hostTime = hApi.GetNewDate(str_systime) + delteZone * 3600 --服务器时间(本地时区)
	g_systime = os.date("%Y-%m-%d %H:%M:%S", hostTime)
	
	local localTime = os.time() --客户端时间
	g_localDeltaTime = localTime - hostTime --存储客户端的时间和服务器的时间误差(Local = Host + deltaTime)
	
	print("__Handler.L2C_SYSTIME g_systime:", g_systime, "deltaSecond=" .. g_localDeltaTime)
	
	hGlobal.event:event("localEvent_refresh_Systime")
	]]
	
	--geyachao: 转化为本地时间
	--local str_systime = packet:readString() --存储服务器时间(GMT+8)
	local str_systime = sCmd
	local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
	local delteZone = localTimeZone - 8 --与北京时间的时差
	local hostTime = hApi.GetNewDate(str_systime) + delteZone * 3600 --服务器时间(本地时区)
	g_systime = os.date("%Y-%m-%d %H:%M:%S", hostTime)
	
	local localTime = os.time() --客户端时间
	g_localDeltaTime = localTime - hostTime --存储客户端的时间和服务器的时间误差(Local = Host + deltaTime)
	
	--print("__Handler.L2C_SYSTIME g_systime:", g_systime, "deltaSecond=" .. g_localDeltaTime)
	
	hGlobal.event:event("localEvent_refresh_Systime")
end

__Handler[__rh.L2C_QUEST_VER_INFO] = function(sCmd)
	--local sCmd = packet:readString() --存储服务器时间
	local tCmd = hApi.Split(sCmd,";")
	
	g_shop_control = tCmd[1]
	g_version_control = tCmd[2]
	
	print("g_shop_control:",g_shop_control)
	print("g_version_control:",g_version_control)
end

--获得邮箱奖励的返回
__Handler[__rh.L2C_QUEST_MAIL_ANNEX] = function(sCmd)
	--local sCmd = packet:readString()
	--print("__Handler.L2C_GET_MAIL_ANNEX", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	local prizeId = tonumber(tCmd[1])
	local maxRewardN = tonumber(tCmd[2]) or 3
	local rewardN = tonumber(tCmd[3]) or 0
	
	--为服务器返回日志
	if (prizeId > 0) then
		--取消挡操作
		hUI.NetDisable(0)
		
		local reward = {}
		local rewardIdx = 4
		
		for i = 1, rewardN do
			local tmp = {}
			local tRInfo = hApi.Split(tCmd[rewardIdx],":")
			tmp[#tmp + 1] = tRInfo[1]				--奖励类型
			tmp[#tmp + 1] = tRInfo[2]				--参数1
			tmp[#tmp + 1] = tRInfo[3]				--参数2
			tmp[#tmp + 1] = tRInfo[4]				--参数3
			--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
			reward[#reward + 1] = tmp
			rewardIdx = rewardIdx + 1
			
			--如果获得的是4孔神器，发起广播
			local rewardType = tonumber(tRInfo[1]) or 0 --获取类型
			if (rewardType == 10) then --10:神器
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemEntity = tRInfo[3] or ""
				local entity = {}
				local tEntity = hApi.Split(itemEntity,"|")
				
				entity.dbid = tonumber(tEntity[1]) or 0
				entity.typeId = tonumber(tEntity[2]) or 0
				entity.slotnum = tonumber(tEntity[3]) or 0
				entity.attr = {}
				local idx = 3
				for i = 1, entity.slotnum do
					entity.attr[#entity.attr + 1] = tEntity[idx + i]
				end
				
				--[[
				--获得道具
				--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
				if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
					--if (LuaCheckPlayerBagCanUse() ~= 0) then
						--4孔
						if (entity.slotnum == 4) then
							--本地获得4孔神器，上传PVP服务器，请求广播此消息
							local itemId = itemId
							local slotNum = entity.slotnum
							local strInfo = hVar.tab_string["MadelGiftGet"] --"领取"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
				]]
			end
			
			--[[
			--如果获得的战术卡碎片是一般战术卡类型，并且品质是4级以上，那么广播全服消息获得战术卡
			if (rewardType == 6) then --6:战术卡碎片
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemNum = tonumber(tRInfo[3]) or 0 --奖励数量
				local tacticId = hVar.tab_item[itemId] and hVar.tab_item[itemId].tacticID
				local tabT = hVar.tab_tactics[tacticId] or {}
				local tacticType = tabT.type
				local tacticQuality = tabT.quality or 1
				if (tacticType == hVar.TACTICS_TYPE.OTHER) and (tacticQuality >= 4) then
					--本地获得战术卡碎片，上传PVP服务器，请求广播此消息
					local strInfo = hVar.tab_string["MadelGiftGet"] --"领取"
					--SendPvpCmdFunc["request_broad_get_tacticcard"](rewardType, tacticId, itemNum, strInfo)
					SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.TACTICCARD_DEBRIS, strInfo, tacticId)
				end
			end
			]]
		end
		
		local tag, rewardResult = hApi.GetReawrdGift(reward, maxRewardN)
		
		--hApi.BubbleGiftAnim(reward, maxRewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		SendCmdFunc["update_reward_log"](prizeId)
		
		--触发事件：领取邮件奖励成功（td邮件领奖）
		hGlobal.event:event("LocalEvent_OnSystemMailTakeRewardSuccess", prizeId)
		--print(tag)
		
		--存档
		--邮箱领奖
		local keyList = {"card", "skill", "bag", "material",}
		LuaSavePlayerData_Android_Upload(keyList, "邮箱领奖")
	end
end

--获得服务器抽卡邮箱奖励的返回
__Handler[__rh.L2C_QUEST_MAIL_ANNEX_DRAWCARD] = function(sCmd)
	--local sCmd = packet:readString()
	--print("__Handler.L2C_QUEST_MAIL_ANNEX_DRAWCARD", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	local prizeId = tonumber(tCmd[1])
	local maxRewardN = tonumber(tCmd[2]) or 3
	local rewardN = tonumber(tCmd[3]) or 0
	
	--为服务器返回日志
	if (prizeId > 0) then
		
		local reward = {}
		local rewardIdx = 4
		
		for i = 1, rewardN do
			local tmp = {}
			local tRInfo = hApi.Split(tCmd[rewardIdx],":")
			tmp[#tmp + 1] = tRInfo[1]				--奖励类型
			tmp[#tmp + 1] = tRInfo[2]				--参数1
			tmp[#tmp + 1] = tRInfo[3]				--参数2
			tmp[#tmp + 1] = tRInfo[4]				--参数3
			--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
			reward[#reward + 1] = tmp
			rewardIdx = rewardIdx + 1
			
			--如果获得的是4孔神器，发起广播
			local rewardType = tonumber(tRInfo[1]) or 0 --获取类型
			if (rewardType == 10) then --10:神器
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemEntity = tRInfo[3] or ""
				local entity = {}
				local tEntity = hApi.Split(itemEntity,"|")
				
				entity.dbid = tonumber(tEntity[1]) or 0
				entity.typeId = tonumber(tEntity[2]) or 0
				entity.slotnum = tonumber(tEntity[3]) or 0
				entity.attr = {}
				local idx = 3
				for i = 1, entity.slotnum do
					entity.attr[#entity.attr + 1] = tEntity[idx + i]
				end
				
				--[[
				--获得道具
				--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
				if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
					--if (LuaCheckPlayerBagCanUse() ~= 0) then
						--4孔
						if (entity.slotnum == 4) then
							--本地获得4孔神器，上传PVP服务器，请求广播此消息
							local itemId = itemId
							local slotNum = entity.slotnum
							local strInfo = hVar.tab_string["__ITEM_PANEL__PAGE_SHENQIGIFTSELECT"] --"从神器礼包中选取了"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
				]]
			end
			
			--[[
			--如果获得的战术卡碎片是一般战术卡类型，并且品质是4级以上，那么广播全服消息获得战术卡
			if (rewardType == 6) then --6:战术卡碎片
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemNum = tonumber(tRInfo[3]) or 0 --奖励数量
				local tacticId = hVar.tab_item[itemId] and hVar.tab_item[itemId].tacticID
				local tabT = hVar.tab_tactics[tacticId] or {}
				local tacticType = tabT.type
				local tacticQuality = tabT.quality or 1
				if (tacticType == hVar.TACTICS_TYPE.OTHER) and (tacticQuality >= 4) then
					--本地获得战术卡碎片，上传PVP服务器，请求广播此消息
					local strInfo = hVar.tab_string["__ITEM_PANEL__PAGE_TACTICCARDGIFTSELECT"] --"从战术礼包中选取了"
					--SendPvpCmdFunc["request_broad_get_tacticcard"](rewardType, tacticId, itemNum, strInfo)
					SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.TACTICCARD_DEBRIS, strInfo, tacticId)
				end
			end
			]]
		end
		
		local tag, rewardResult = hApi.GetReawrdGift(reward, maxRewardN)
		
		--hApi.BubbleGiftAnim(reward, maxRewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		SendCmdFunc["update_reward_log"](prizeId)
		--print(tag)
		
		--存档
		--邮箱领奖
		local keyList = {"card", "skill", "bag", "material",}
		LuaSavePlayerData_Android_Upload(keyList, "邮箱服务器抽奖领奖")
		
		--触发事件：通知服务器抽卡完成
		--print("触发事件：通知服务器抽卡完成")
		hGlobal.event:event("localEvent_SelectDebriesCardFinished", prizeId, reward)
		
		--触发事件：领取邮件奖励成功（服务器抽卡领奖）
		hGlobal.event:event("LocalEvent_OnSystemMailTakeRewardSuccess", prizeId)
	end
end

--获得服务器直接开锦囊邮箱奖励的返回
__Handler[__rh.L2C_QUEST_MAIL_ANNEX_OPENCHEST] = function(sCmd)
	--local sCmd = packet:readString()
	--print("__Handler.L2C_QUEST_MAIL_ANNEX_OPENCHEST", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	local prizeId = tonumber(tCmd[1])
	local maxRewardN = tonumber(tCmd[2]) or 3
	local rewardN = tonumber(tCmd[3])
	
	--为服务器返回日志
	if (prizeId > 0) then
		--取消挡操作
		hUI.NetDisable(0)
		
		local reward = {}
		local rewardIdx = 4
		
		for i = 1, rewardN do
			local tmp = {}
			local tRInfo = hApi.Split(tCmd[rewardIdx],":")
			tmp[#tmp + 1] = tRInfo[1]				--奖励类型
			tmp[#tmp + 1] = tRInfo[2]				--参数1
			tmp[#tmp + 1] = tRInfo[3]				--参数2
			tmp[#tmp + 1] = tRInfo[4]				--参数3
			--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
			reward[#reward + 1] = tmp
			rewardIdx = rewardIdx + 1
			
			--如果获得的是4孔神器，发起广播
			local rewardType = tonumber(tRInfo[1]) or 0 --获取类型
			if (rewardType == 10) then --10:神器
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemEntity = tRInfo[3] or ""
				local entity = {}
				local tEntity = hApi.Split(itemEntity,"|")
				
				entity.dbid = tonumber(tEntity[1]) or 0
				entity.typeId = tonumber(tEntity[2]) or 0
				entity.slotnum = tonumber(tEntity[3]) or 0
				entity.attr = {}
				local idx = 3
				for i = 1, entity.slotnum do
					entity.attr[#entity.attr + 1] = tEntity[idx + i]
				end
				
				--[[
				--获得道具
				--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
				if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
					--if (LuaCheckPlayerBagCanUse() ~= 0) then
						--4孔
						if (entity.slotnum == 4) then
							--本地获得4孔神器，上传PVP服务器，请求广播此消息
							local itemId = itemId
							local slotNum = entity.slotnum
							local strInfo = hVar.tab_string["__ITEM_PANEL__PAGE_DRAWCARD"] --"抽到"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
				]]
			end
		end
		
		local tag, rewardResult = hApi.GetReawrdGift(reward, maxRewardN)
		
		--hApi.BubbleGiftAnim(reward, maxRewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		SendCmdFunc["update_reward_log"](prizeId)
		
		--触发事件：领取邮件奖励成功（服务器直接开锦囊）
		hGlobal.event:event("LocalEvent_OnSystemMailTakeRewardSuccess", prizeId)
		
		--print(tag)
		
		--存档
		--邮箱领奖
		local keyList = {"card", "skill", "bag", "material",}
		LuaSavePlayerData_Android_Upload(keyList, "邮箱服务器直接开锦囊领奖")
	end
end

--获取标题正文的奖邮箱附件
__Handler[__rh.L2C_QUEST_MAIL_ANNEX_TITIEMSG] = function(sCmd)
	--local sCmd = packet:readString()
	--print("__Handler.L2C_QUEST_MAIL_ANNEX_TITIEMSG", sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local tCmd = hApi.Split(sCmd,";")
	local prizeId = tonumber(tCmd[1])
	local maxRewardN = tonumber(tCmd[2]) or 3
	local rewardN = tonumber(tCmd[3]) or 0
	
	--为服务器返回日志
	if (prizeId > 0) then
		local reward = {}
		local rewardIdx = 4
		
		for i = 1, rewardN do
			local tmp = {}
			local tRInfo = hApi.Split(tCmd[rewardIdx],":")
			tmp[#tmp + 1] = tRInfo[1]				--奖励类型
			tmp[#tmp + 1] = tRInfo[2]				--参数1
			tmp[#tmp + 1] = tRInfo[3]				--参数2
			tmp[#tmp + 1] = tRInfo[4]				--参数3
			--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
			reward[#reward + 1] = tmp
			rewardIdx = rewardIdx + 1
			
			--如果获得的是4孔神器，发起广播
			local rewardType = tonumber(tRInfo[1]) or 0 --获取类型
			if (rewardType == 10) then --10:神器
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemEntity = tRInfo[3] or ""
				local entity = {}
				local tEntity = hApi.Split(itemEntity,"|")
				
				entity.dbid = tonumber(tEntity[1]) or 0
				entity.typeId = tonumber(tEntity[2]) or 0
				entity.slotnum = tonumber(tEntity[3]) or 0
				entity.attr = {}
				local idx = 3
				for i = 1, entity.slotnum do
					entity.attr[#entity.attr + 1] = tEntity[idx + i]
				end
				
				--[[
				--获得道具
				--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
				if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
					--if (LuaCheckPlayerBagCanUse() ~= 0) then
						--4孔
						if (entity.slotnum == 4) then
							--本地获得4孔神器，上传PVP服务器，请求广播此消息
							local itemId = itemId
							local slotNum = entity.slotnum
							local strInfo = hVar.tab_string["MadelGiftGet"] --"领取"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
				]]
			end
		end
		
		local tag, rewardResult = hApi.GetReawrdGift(reward, maxRewardN)
		
		--hApi.BubbleGiftAnim(reward, maxRewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		SendCmdFunc["update_reward_log"](prizeId)
		--print(tag)
		
		--存档
		--邮箱领奖
		local keyList = {"card", "skill", "bag", "material",}
		LuaSavePlayerData_Android_Upload(keyList, "带标题正文邮件")
		
		--触发事件：通知带有标题正文的邮件领取完成
		--print("触发事件：通知带有标题正文的邮件领取完成")
		hGlobal.event:event("localEvent_TitleMsgRewardFinished", prizeId, reward)
		
		--触发事件：领取邮件奖励成功（带有标题正文的邮件领奖）
		hGlobal.event:event("LocalEvent_OnSystemMailTakeRewardSuccess", prizeId)
	end
end

--获得聊天龙王奖奖励的返回
__Handler[__rh.L2C_NOTICE_MAIL_ANNEX_CHATDRAGON_RET] = function(sCmd)
	--local sCmd = packet:readString()
	--print("__Handler.L2C_NOTICE_MAIL_ANNEX_CHATDRAGON_RET", sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local tCmd = hApi.Split(sCmd,";")
	local prizeId = tonumber(tCmd[1])
	local maxRewardN = tonumber(tCmd[2]) or 3
	local rewardN = tonumber(tCmd[3]) or 0
	
	--为服务器返回日志
	if (prizeId > 0) then
		local reward = {}
		local rewardIdx = 4
		
		for i = 1, rewardN do
			local tmp = {}
			local tRInfo = hApi.Split(tCmd[rewardIdx],":")
			tmp[#tmp + 1] = tRInfo[1]				--奖励类型
			tmp[#tmp + 1] = tRInfo[2]				--参数1
			tmp[#tmp + 1] = tRInfo[3]				--参数2
			tmp[#tmp + 1] = tRInfo[4]				--参数3
			--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
			reward[#reward + 1] = tmp
			rewardIdx = rewardIdx + 1
			
			--如果获得的是4孔神器，发起广播
			local rewardType = tonumber(tRInfo[1]) or 0 --获取类型
			if (rewardType == 10) then --10:神器
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemEntity = tRInfo[3] or ""
				local entity = {}
				local tEntity = hApi.Split(itemEntity,"|")
				
				entity.dbid = tonumber(tEntity[1]) or 0
				entity.typeId = tonumber(tEntity[2]) or 0
				entity.slotnum = tonumber(tEntity[3]) or 0
				entity.attr = {}
				local idx = 3
				for i = 1, entity.slotnum do
					entity.attr[#entity.attr + 1] = tEntity[idx + i]
				end
				
				--[[
				--获得道具
				--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
				if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
					--if (LuaCheckPlayerBagCanUse() ~= 0) then
						--4孔
						if (entity.slotnum == 4) then
							--本地获得4孔神器，上传PVP服务器，请求广播此消息
							local itemId = itemId
							local slotNum = entity.slotnum
							local strInfo = hVar.tab_string["MadelGiftGet"] --"领取"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
				]]
			end
		end
		
		local tag, rewardResult = hApi.GetReawrdGift(reward, maxRewardN)
		
		--hApi.BubbleGiftAnim(reward, maxRewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		SendCmdFunc["update_reward_log"](prizeId)
		--print(tag)
		
		--存档
		--邮箱领奖
		local keyList = {"card", "skill", "bag", "material",}
		LuaSavePlayerData_Android_Upload(keyList, "聊天龙王奖")
		
		--触发事件：通知聊天龙王奖领取完成
		--print("触发事件：通知聊天龙王奖领取完成")
		hGlobal.event:event("localEvent_ChatDragonRewardFinished", prizeId, reward)
		
		--触发事件：领取邮件奖励成功（聊天龙王奖）
		hGlobal.event:event("LocalEvent_OnSystemMailTakeRewardSuccess", prizeId)
	end
end

--收到玩家的当前称号信息返回结果
__Handler[__rh.L2C_NOTICE_USER_CHAMPION_INFO_RET] = function(sCmd)
	--local sCmd = packet:readString()
	
	local tCmd = hApi.Split(sCmd,";")
	local borderId = tonumber(tCmd[1]) or 0		--玩家边框id
	local iconId = tonumber(tCmd[2]) or 0		--玩家头像id
	local championId = tonumber(tCmd[3]) or 0	--玩家称号id
	local dragonId = tonumber(tCmd[4]) or 0	--玩家聊天龙王id
	local headId = tonumber(tCmd[5]) or 0	--玩家头衔id
	local lineId = tonumber(tCmd[6]) or 0	--玩家线索id
	
	--print("borderId=", borderId)
	--print("iconId=", iconId)
	--print("championId=", championId)
	--print("dragonId=", dragonId)
	--print("headId=", headId)
	--print("lineId=", lineId)
	
	local dontSave = true
	
	LuaSetPlayerBorderID(borderId, dontSave)
	LuaSetPlayerIconID(iconId, dontSave)
	LuaSetPlayerChampionID(championId, dontSave)
	LuaSetPlayerDragonID(dragonId, dontSave)
	LuaSetPlayerHeadID(headId, dontSave)
	LuaSetPlayerLineID(lineId, dontSave)
	
	--统一存档
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
end

__Handler[__rh.L2C_QUEST] = function(packet)
	--服务器刷新竞技场任务
	local sCmd = packet:readString()
	print("__Handler.L2C_QUEST sCmd:", "length=" .. string.len(tostring(sCmd)))
	hApi.ReadDailyQuestByCmd(sCmd)
	hGlobal.event:event("LocalEvent_DailyQuestUpdate")
end

__Handler[__rh.L2C_QUEST_REWARD] = function(packet)
	--服务器下发竞技场奖励
	local sCmd = packet:readString()
	print("__Handler.L2C_QUEST_REWARD sCmd:", "length=" .. string.len(tostring(sCmd)))
	
	hApi.RewardDailyQuestByCmd(sCmd)
end

--排行榜静态数据返回
__Handler[__rh.L2C_BOARD_TEMPLATE] = function(sCmd)
	--服务器返回排行榜模板
	--local sCmd = packet:readString()
	--print("__Handler.L2C_BOARD_TEMPLATE sCmd:", "length=" .. string.len(tostring(sCmd)))
	--print("__Handler.L2C_BOARD_TEMPLATE sCmd:", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	local billboardT = {}
	
	local bId = tonumber(tCmd[1]) --排行榜id
	billboardT.num = tonumber(tCmd[2])
	billboardT.info = {}
	
	local boardIdx = 3
	for i = 1, billboardT.num do
		local tmpbbTInfo = {}
		local bbTInfo = tCmd[boardIdx]
		local tbbTInfo = hApi.Split(bbTInfo,":")
		tmpbbTInfo.bId = tonumber(tbbTInfo[1])				--排行榜id
		tmpbbTInfo.type = tonumber(tbbTInfo[2])				--排行榜类型
		tmpbbTInfo.openFlag = tonumber(tbbTInfo[3])			--排行榜今日是否开放
		local max_rank = tonumber(tbbTInfo[4])
		local tmp = "local prize = "..tbbTInfo[5].." return prize"
		tmpbbTInfo.prize = assert(loadstring(tmp))()
		tmpbbTInfo.prize.max_rank = max_rank
		
		billboardT.info[tmpbbTInfo.bId] = tmpbbTInfo
		boardIdx = boardIdx + 1
	end
	
	--更新排行榜模板信息
	hGlobal.event:event("localEvent_refresh_billboardT", bId, billboardT)
end

__Handler[__rh.L2C_BILLBOARD_INFO] = function(sCmd)
	--服务器返回排行榜信息
	--local sCmd = packet:readString()
	--print("__Handler.L2C_BILLBOARD_INFO sCmd:", "length=" .. string.len(tostring(sCmd)))
	--print("__Handler.L2C_BILLBOARD_INFO sCmd:", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	local billboard = {}
	
	billboard.bId = tonumber(tCmd[1])
	local me = tCmd[2]
	
	local meInfo = hApi.Split(me,":")
	billboard.rankingMe = tonumber(meInfo[1]) --排名
	billboard.nameMe = meInfo[2] --玩家角色名称
	billboard.rankMe = tonumber(meInfo[3] or 0) --积分
	
	if (billboard.nameMe == "") then
		local playerInfo = LuaGetPlayerByName(g_curPlayerName)
		if playerInfo and playerInfo.showName and (playerInfo.showName ~= "") then
			billboard.nameMe = playerInfo.showName
		else
			billboard.nameMe = g_curPlayerName
		end
	end
	
	billboard.num = tonumber(tCmd[3]) or 0
	
	--print("billboard.bId, billboard.num:",billboard.bId, billboard.nameMe, type(me), me, type(billboard.nameMe), billboard.rankMe, billboard.num)
	billboard.info = {}
	
	local boardIdx = 4
	for i = 1, billboard.num do
		local tmpbbInfo = {}
		local bbInfo = tCmd[boardIdx] or ""
		--解析玩家uid、玩家名和得分
		local tbbInfo = hApi.Split(bbInfo,":")
		tmpbbInfo.index = i
		tmpbbInfo.uid = tonumber(tbbInfo[1]) or 0				--玩家uid
		tmpbbInfo.name = hApi.StringDecodeEmoji(tbbInfo[2])			--玩家角色名称 --还原表情
		tmpbbInfo.rank = tonumber(tbbInfo[3]) or 0				--得分
		--继续往后解析
		boardIdx = boardIdx + 1
		
		--配卡信息
		local cfgInfo = tCmd[boardIdx]
		--解析配卡信息
		--print(cfgInfo)
		
		local tInfo = hApi.Split(cfgInfo or "", ":")
		--print(unpack(tInfo))
		--print("\n")
		local pIdx = 1
		local p = {} --配置信息表
		p.vipLv = 0
		p.hero = {}
		p.tower = {}
		p.tactic = {}
		p.treasure = {}
		p.treasure_attr = {}
		
		local hero = p.hero
		local tower = p.tower
		local tactic = p.tactic
		local treasure = p.treasure
		local treasure_attr = p.treasure_attr
		
		--VIP等级
		local vipLv = tonumber(tInfo[pIdx]) or 0
		p.vipLv = vipLv
		--print("VIP等级=", vipLv)
		
		--英雄配置
		local heroIdx = pIdx + 1
		local heroNum = tonumber(tInfo[heroIdx]) or 0
		--print("heroNum=", heroNum, heroIdx)
		for n = 1, heroNum do
			local heroInfo = tInfo[heroIdx + n]
			local tHeroInfo = hApi.Split(heroInfo or "", "|")
			
			hero[#hero + 1] = {}
			
			local hInfo = hero[#hero]
			
			hInfo.id = tonumber(tHeroInfo[1]) or 0
			hInfo.lv = tonumber(tHeroInfo[2]) or 0
			hInfo.star = tonumber(tHeroInfo[3]) or 0
			--print("英雄[" .. n .. "]=", hInfo.id, hInfo.lv, hInfo.star)
			
			local talentIdx = 4
			local talentNum = tonumber(tHeroInfo[talentIdx])
			hInfo.talent = {}
			for m = 1, talentNum do
				local talentInfo = tHeroInfo[talentIdx + m]
				local tTalent = hApi.Split(talentInfo or "", "_")
				
				hInfo.talent[#hInfo.talent + 1] = {}
				hInfo.talent[#hInfo.talent].id = tonumber(tTalent[1]) or 0
				hInfo.talent[#hInfo.talent].lv = tonumber(tTalent[2]) or 0
			end
				
			local equipIdx = 4 + 1 + talentNum
			local equipNum = tonumber(tHeroInfo[equipIdx])
			hInfo.equip = {}
			for m = 1, equipNum, 1 do
				local equipInfo = tHeroInfo[equipIdx + m]
				local tEquip = hApi.Split(equipInfo or "", "_")
				
				hInfo.equip[#hInfo.equip + 1] = {}
				hInfo.equip[#hInfo.equip].id = tonumber(tEquip[1]) or 0
				--print("  装备[" .. m .. "]=", hInfo.equip[#hInfo.equip].id)
				local attrNum = tonumber(tEquip[2]) or 0
				local attrIdx = 2
				hInfo.equip[#hInfo.equip].attr = {}
				local attr = hInfo.equip[#hInfo.equip].attr
				for x = 1, attrNum do
					attr[#attr + 1] = tEquip[attrIdx + x]
				end
			end
			
			
		end
		
		--配塔信息
		local towerIdx = heroIdx + heroNum + 1
		local towerNum = tonumber(tInfo[towerIdx]) or 0
		--print("towerNum=", towerNum, towerIdx)
		for n = 1, towerNum, 1 do
			local towerInfo = tInfo[towerIdx + n]
			
			tower[#tower + 1] = {}
			
			local tTower = hApi.Split(towerInfo or "", "|")
			
			tower[#tower].id = tonumber(tTower[1]) or 0
			tower[#tower].lv = tonumber(tTower[2]) or 0
			tower[#tower].ex = tonumber(tTower[3]) or 0
		end
		
		--配战术卡信息
		local tacticIdx = heroIdx + heroNum + 1 + towerNum + 1
		local tacticNum = tonumber(tInfo[tacticIdx]) or 0
		--print("tacticNum=", tacticNum, tacticIdx)
		for n = 1, tacticNum, 1 do
			local tacticInfo = tInfo[tacticIdx + n]
			
			tactic[#tactic + 1] = {}
			
			local tTactic = hApi.Split(tacticInfo or "", "|")
			
			tactic[#tactic].id = tonumber(tTactic[1]) or 0
			tactic[#tactic].lv = tonumber(tTactic[2]) or 0
			tactic[#tactic].ex = tonumber(tTactic[3]) or 0
		end
		
		--配宝物信息
		local treasureIdx = heroIdx + heroNum + 1 + towerNum + 1 + tacticNum + 1
		local treasureNum = tonumber(tInfo[treasureIdx]) or 0
		--print("treasureNum=", treasureNum, treasureIdx)
		for n = 1, treasureNum, 1 do
			local treasureInfo = tInfo[treasureIdx + n]
			
			treasure[#treasure + 1] = {}
			
			local tTreasure = hApi.Split(treasureInfo or "", "|")
			
			treasure[#treasure][1] = tonumber(tTreasure[1]) or 0
			treasure[#treasure][2] = tonumber(tTreasure[2]) or 0
			treasure[#treasure][3] = tonumber(tTreasure[3]) or 0
			--print(treasure[#treasure][1], treasure[#treasure][2], treasure[#treasure][3])
		end
		
		--配宝物属性位信息
		local treasureAttrIdx = heroIdx + heroNum + 1 + towerNum + 1 + tacticNum + 1 + treasureNum + 1
		local treasureAttrNum = tonumber(tInfo[treasureAttrIdx]) or 0
		--print("treasureAttrNum=", treasureAttrNum, treasureAttrIdx)
		for n = 1, treasureAttrNum, 1 do
			local treasureAttrInfo = tInfo[treasureAttrIdx + n]
			
			--treasure_attr[#treasure_attr + 1] = {}
			treasure_attr[#treasure_attr + 1] = 0
			
			local tTreasureAttr = hApi.Split(treasureAttrInfo or "", "|")
			
			treasure_attr[#treasure_attr] = tonumber(tTreasureAttr[1]) or 0
			--print(treasure_attr[#treasure_attr])
		end
		
		tmpbbInfo.tCfg = p				--配置信息
		
		--继续往后解析
		boardIdx = boardIdx + 1
		
		billboard.info[#(billboard.info) + 1] = tmpbbInfo
	end
	
	--print("更新排行榜信息更新排行榜信息更新排行榜信息更新排行榜信息更新排行榜信息更新排行榜信息更新排行榜信息更新排行榜信息更新排行榜信息")
	--更新排行榜信息
	hGlobal.event:event("localEvent_refresh_billboard", billboard.bId, billboard)

end

--修改姓名返回
__Handler[__rh.L2C_REQUEST_CHANGE_NAME] = function(packet)
	local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd,";")
	
	local result =  tonumber(tCmd[1]) or 0		--更名结果（1成功 0失败）
	local info = tonumber(tCmd[2]) or -3		--更名信息 (成功:prizeid 失败:失败原因 -1钱不够 -2重名 -3未知)
	
	--修改姓名返回
	hGlobal.event:event("localEvent_change_name", result, info)
end


--返回商店信息
__Handler[__rh.L2C_REQUEST_SHOP_INFO] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd,";")
	--print(sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result = tonumber(tCmd[1]) or 0
	local iTag = tonumber(tCmd[2]) or 0
	if result == 1 then
		local shopId = tonumber(tCmd[3]) or 0
		local rmb_refresh_count = tonumber(tCmd[4]) or 0
		local shopitemNum = tonumber(tCmd[5]) or 0
		local infoIdx = 5
		
		local goods = {}
		
		--遍历所有商店道具
		for i = 1, shopitemNum do
			local goodsList = tCmd[infoIdx + i] or ""
			local tGoodsList = hApi.Split(goodsList,":")
			
			--商品数据
			local id = tonumber(tGoodsList[1]) or 0
			local itemId = tonumber(tGoodsList[2]) or 0
			local num = tonumber(tGoodsList[3]) or 1
			local score = tonumber(tGoodsList[4]) or 0
			local rmb = tonumber(tGoodsList[5]) or 0
			local quota = tonumber(tGoodsList[6]) or 1
			local saledCount = tonumber(tGoodsList[7]) or 0
			
			local good = {}
			good.id = id
			good.itemId = itemId
			good.num = num
			good.score = score
			good.rmb = rmb
			good.quota = quota
			good.saledCount = saledCount
			
			goods[#goods + 1] = good
		end
		
		--商城信息返回
		hGlobal.event:event("localEvent_refresh_shopinfo", shopId, rmb_refresh_count, goods)
	else
		--获取失败
		 --冒字
		--local strText = "操作失败！错误码: " .. result
		local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__TEXT_PVP_Operation"], result)
		if (result == -1) then --游戏币不足 -1
			--strText = "游戏币不足！" --language
			strText = hVar.tab_string["ios_not_enough_game_coin"] --language
		elseif (result == -2) then --商品不存在 -2
			strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] --"参数不合法"
		elseif (result == -3) then --刷新次数用完
			--strText = "今日刷新次数已用完！" --language
			strText = hVar.tab_string["__TEXT_TodayRefreshCountUsedUp"] --language
		elseif (result == -4) then --商品信息不存在-4(需要触发服务器生成新的商品列表)
			strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] --"参数不合法"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
end

--返回购买到的商品信息
__Handler[__rh.L2C_REQUEST_BUYITEM] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd,";")
	
	local iTag = tonumber(tCmd[1]) or 0
	local nRedequipCrystal = tonumber(tCmd[2]) or 0	--是否神器晶石兑换
	local result = tonumber(tCmd[3]) or 0		--结果（1成功 ）
	
	print("__rh.L2C_REQUEST_BUYITEM:","iTag="..iTag,"nRedequipCrystal="..nRedequipCrystal,"result="..result,sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	 --冒字
	--local strText = "购买商品失败！错误码: " .. result
	local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__TEXT_GoodsBuy"], result)
	if (result == 1) then --成功 1
		if (nRedequipCrystal == 1) then --神器晶石兑换
			--strText = "兑换成功！" --language
			strText = hVar.tab_string["ios_exchange_success"] --language
		else
			--strText = "购买成功！" --language
			strText = hVar.tab_string["ios_payment_success"] --language
		end
	elseif (result == -1) then --商品不存在 -1
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] --"参数不合法"
	elseif (result == -2) then --游戏币不足 -2
		--strText = "游戏币不足！" --language
		strText = hVar.tab_string["ios_not_enough_game_coin"] --language
	elseif (result == -3) then --购买次数已达上限 -3
		--strText = "该商品今日购买次数已用完！" --language
		strText = hVar.tab_string["__TEXT_TodayBuyItemUsedUp"] --language
	elseif (result == -4) then --商品信息不存在-4(需要触发服务器生成新的商品列表)
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] --"参数不合法"
	elseif (result == -6) then --神器晶石不足 -6
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_SHENI_DEBIRS_NUMERROR"] --"神器晶石不足"
	elseif (result == -7) then --藏宝图不足 -7
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_CANGBAOTU_NUMERROR"] --"藏宝图碎片不足"
	elseif (result == -8) then --高级藏宝图不足 -8
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_CANGBAOTU_HIGH_NUMERROR"] --"高级藏宝图碎片不足"
	end
	
	--冒字
	hUI.floatNumber:new({
		x = hVar.SCREEN.w / 2,
		y = hVar.SCREEN.h / 2,
		align = "MC",
		text = "",
		lifetime = 2000,
		fadeout = -550,
		moveY = 32,
	}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	
	--购买商品成功
	if result == 1 then
		local tGoodsList = hApi.Split(tCmd[4] or "",":")
		--商品数据
		local id = tonumber(tGoodsList[1]) or 0
		local itemId = tonumber(tGoodsList[2]) or 0
		local num = tonumber(tGoodsList[3]) or 1
		local score = tonumber(tGoodsList[4]) or 0
		local rmb = tonumber(tGoodsList[5]) or 0
		local quota = tonumber(tGoodsList[6]) or 1
		local saledCount = tonumber(tGoodsList[7]) or 0
		
		tGoodsList.id = id
		tGoodsList.itemId = itemId
		tGoodsList.num = num
		tGoodsList.score = score
		tGoodsList.rmb = rmb
		tGoodsList.quota = quota
		tGoodsList.saledCount = saledCount
		
		--如果需要消耗积分
		if (score > 0) then
			LuaAddPlayerScore(-score)
		end
		
		--print("__rh.L2C_REQUEST_BUYITEM:id:",id)
		--print("__rh.L2C_REQUEST_BUYITEM:itemId:",itemId)
		--print("__rh.L2C_REQUEST_BUYITEM:num:",num)
		--print("__rh.L2C_REQUEST_BUYITEM:score:",score)
		--print("__rh.L2C_REQUEST_BUYITEM:rmb:",rmb)
		--print("__rh.L2C_REQUEST_BUYITEM:quota:",quota)
		--print("__rh.L2C_REQUEST_BUYITEM:saledCount:",saledCount)
		
		local rewardNum = tonumber(tCmd[5]) or 0
		--print("__rh.L2C_REQUEST_BUYITEM:rewardNum:",rewardNum)
		local rIdx = 5
		local reward = {}
		for i = 1, rewardNum do
			local rewardInfo = tCmd[rIdx + i] or ""
			local tRewardInfo = hApi.Split(rewardInfo,":")
			reward[#reward + 1] = tRewardInfo
			--print("返回购买到的商品信息:", unpack(tRewardInfo))
			
			--如果获得的是4孔神器，发起广播
			local rewardType = tonumber(tRewardInfo[1]) or 0 --获取类型
			if (rewardType == 10) then --10:神器
				local itemId = tonumber(tRewardInfo[2]) or 0 --奖励ID
				local itemEntity = tRewardInfo[3] or ""
				local quality = tRewardInfo[4] or 0 --品质
				local entity = {}
				local tEntity = hApi.Split(itemEntity,"|")
				
				entity.dbid = tonumber(tEntity[1]) or 0
				entity.typeId = tonumber(tEntity[2]) or 0
				entity.slotnum = tonumber(tEntity[3]) or 0
				entity.attr = {}
				local idx = 3
				for i = 1, entity.slotnum do
					entity.attr[#entity.attr + 1] = tEntity[idx + i]
				end
				
				--获得道具
				--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
				if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
					--if (LuaCheckPlayerBagCanUse() ~= 0) then
						--4孔
						if (entity.slotnum == 4) then
							--本地获得4孔神器，上传PVP服务器，请求广播此消息
							local itemId = itemId
							local slotNum = entity.slotnum
							local strInfo = hVar.tab_string["__ITEM_PANEL__PAGE_DRAWCARD"] --"抽到"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
			end
		end
		
		--填充本地存档
		hApi.GetReawrdGift(reward, rewardNum)
		
		--购买到商品
		local keyList = {"card", "skill", "bag", "material",}
		LuaSavePlayerData_Android_Upload(keyList, "购买到商品")
		
		--刷新积分界面
		hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
		
		--仓库界面刷新
		hGlobal.event:event("LocalEvent_RefreshChestNum")
		
		--商城信息返回
		hGlobal.event:event("localEvent_buyitem_return", result, tGoodsList, reward)
		
		--SendCmdFunc["gamecoin"]()
		--获取我的资源（游戏币、兵符、红装晶石、战功积分）
		SendCmdFunc["get_mycoin"]()
		
		--[[
		hApi.BubbleGiftAnim(reward, rewardNum, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		]]
		
		--动画打开宝箱奖励播放（类似葫芦娃的动画效果）
		hApi.PlayChestRewardAnimation(itemId, reward)
		
		--标记pvp基础数据不是最新数据了
		g_myPvP_BaseInfo.updated = 0
		
		--任务：累计击购买N个指定道具
		LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.buyItem, tGoodsList.id, 1)
	else
		--todo
		if result == -1 then
			--商品不存在-1
		elseif result == -2 then
			--游戏币不足-2
		elseif result == -3 then
			--购买次数已达上限-3
		elseif result == -4 then
			--商品信息不存在-4(需要触发服务器生成新的商品列表)
		elseif result == -5 then
			--购买失败-5(物品进包失败，消耗资源回退)
		elseif (result == -6) then
			--购买失败-6(神器晶石不足)
		elseif (result == -7) then
			--购买失败-7(藏宝图不足)
		elseif (result == -8) then
			--购买失败-8(高级藏宝图不足)
		end
		
		hGlobal.event:event("localEvent_buyitem_return", result, nil, nil)
	end
end

--返回商店刷新成功
__Handler[__rh.L2C_REQUEST_REFRESH_SHOP] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--更名结果（1成功 ）
	local iTag = tonumber(tCmd[2]) or 0
	if result == 1 then
		
		local goodsList = tCmd[3] or ""
		local tGoodsList = hApi.Split(goodsList,":")
		
		--商品数据
		local id = tonumber(tGoodsList[1]) or 0
		local itemId = tonumber(tGoodsList[2]) or 0
		local num = tonumber(tGoodsList[3]) or 1
		local score = tonumber(tGoodsList[4]) or 0
		local rmb = tonumber(tGoodsList[5]) or 0
		local quota = tonumber(tGoodsList[6]) or 1
		local saledCount = tonumber(tGoodsList[7]) or 0
		
		--如果是刷新商城道具返回，则扣积分
		if id == 349 and score > 0 then
			LuaAddPlayerScore(-score)
		end
		
		--SendCmdFunc["gamecoin"]()
		SendCmdFunc["get_mycoin"]()
		
		--任务：累计击购买N个指定道具
		LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.buyItem, id, 1)
		
		--触发事件：刷新商店成功
		hGlobal.event:event("localEvent_shop_refresh_result_ret", result, id, itemId)
	end
end


__Handler[__rh.L2C_NOTICE_ERROR] = function(packet)
	local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd,";")

	local errorId = tonumber(tCmd[1])
	local errorStr = nil

	if (errorId == hVar.NETERR.UNKNOW_ERROR) then
		print("Net Logic Error:未知错误")
		errorStr = "未知错误"
	elseif (errorId == UPDATE_BILLBOARD_RANK_FAILED) then
		print("Net Logic Error:更新排行榜数据失败")
		errorStr = "更新排行榜数据失败"
	else
		print("Net Logic Error:未知")
		errorStr = "未知"
	end
	
	--db错误提示信息
	hGlobal.event:event("LocalEvent_Db_NetLogicError", errorStr)
end

--返回玩家各种货币
__Handler[__rh.L2C_REQUEST_MYCOIN] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")

	local gamecoin = tonumber(tCmd[1]) or 0 --游戏币
	local pvpcoin = tonumber(tCmd[2]) or 0 --兵符
	local crystal = tonumber(tCmd[3]) or 0 --红装晶石
	local redscroll = tonumber(tCmd[4]) or 0 --红装兑换券
	local weaponChestNum = tonumber(tCmd[5]) or 0 --武器宝箱数量
	local tacticChestNum = tonumber(tCmd[6]) or 0 --战术宝箱数量
	local petChestNum = tonumber(tCmd[7]) or 0 --宠物宝箱数量
	local equipChestNum = tonumber(tCmd[8]) or 0 --装备宝箱数量
	local scientistNum = tonumber(tCmd[9]) or 0 --科学家数量
	local tankDeadthCount = tonumber(tCmd[10]) or 0 --战车死亡数量
	local dishuCoin = tonumber(tCmd[11]) or 0 --地鼠币数量
	local evaluateE = tonumber(tCmd[12]) or 0 --战功积分
	
	--[[
	print("gamecoin=", gamecoin)
	print("pvpcoin=", pvpcoin)
	print("crystal=", crystal)
	print("redscroll=", redscroll)
	print("weaponChestNum=", weaponChestNum)
	print("tacticChestNum=", tacticChestNum)
	print("petChestNum=", petChestNum)
	print("equipChestNum=", equipChestNum)
	print("scientistNum=", scientistNum)
	print("tankDeadthCount=", tankDeadthCount)
	print("dishuCoin=", dishuCoin)
	print("evaluateE=", evaluateE)
	]]
	
	--todo event
	hVar.ROLE_PLAYER_GOLD = gamecoin --存储本地金币数量
	
	--设置各类宝箱数量
	local notSaveFlag = true
	LuaSetTankWeaponGunChestNum(weaponChestNum, notSaveFlag)
	LuaSetTankTacticChestNum(tacticChestNum, notSaveFlag)
	LuaSetTankPetChestNum(petChestNum, notSaveFlag)
	LuaSetTankEquipChestNum(equipChestNum, notSaveFlag)
	LuaSetTankScientistNum(scientistNum, notSaveFlag)
	LuaSetTankDeadthNum(tankDeadthCount, notSaveFlag)
	LuaSetTankDiShuCoinNum(dishuCoin, notSaveFlag)
	
	--设置神器晶石数量（芯片）
	hVar.ROLE_PLAYER_CHIP = crystal
	
	--存档
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	
	hGlobal.event:event("LocalEvent_Phone_SetCurGameCoin_Game", gamecoin)
	
	hGlobal.event:event("LocalEvent_SetCurGameCoin", gamecoin)
	
	--触发事件：获得游戏资源
	hGlobal.event:event("LocalEvent_GetGameResource", gamecoin, pvpcoin, crystal, evaluateE, redscroll, weaponChestNum, tacticChestNum, petChestNum, equipChestNum, scientistNum, tankDeadthCount, dishuCoin)
end

--红装神器合成结果返回
__Handler[__rh.L2C_REQUEST_MERGE_REDEQUIP] = function(packet)
	local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	
	local result =  tonumber(tCmd[1]) or 0		--结果（1成功 ）
	local mainDBID = tonumber(tCmd[2]) or 0		--主道具dbid
	local materialNum = tonumber(tCmd[3]) or 0
	local materialIdx = 3
	local materialDBIDList = {}
	for i = 1, materialNum do
		materialDBIDList[#materialDBIDList + 1] = tonumber(tCmd[materialIdx + i]) or 0
	end
	if result == 1 then
		local nOkFlag = tonumber(tCmd[materialIdx + materialNum + 1]) or 0
		local equip
		
		if nOkFlag == 1 then
			equip = {}
			local tEquip = hApi.Split(tCmd[materialIdx + materialNum + 2] or "",":")
			equip.dbid = tonumber(tEquip[1]) or 0
			equip.typeId = tonumber(tEquip[2]) or 0
			equip.slotNum = tonumber(tEquip[3]) or 0
			equip.attr = {}
			equip.strattr = tEquip[4] or 0
			local tAttr = hApi.Split(equip.strattr or "","|")
			for i = 1, equip.slotNum do
				equip.attr[#equip.attr +1] = tAttr[i]
			end
		end
		
		--获取我的资源（游戏币、兵符、红装晶石、战功积分）
		SendCmdFunc["get_mycoin"]()
		
		hGlobal.event:event("LocalEvent_order_forge_redequip", result, mainDBID, materialNum, materialDBIDList, nOkFlag, equip)

		--任务：累计击购买N个指定道具
		LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.buyItem, 340, 1)
	else
		if result == 0 then
			--未知0
		elseif result == -1 then
			--主装备和材料装备不存在-1
		elseif result == -2 then
			--主道具类型不存在-2
		elseif result == -3 then
			--游戏币不足-3
		end
		hGlobal.event:event("LocalEvent_order_forge_redequip", result, mainDBID, materialNum, materialDBIDList)
	end
end

--红装洗练结果返回
__Handler[__rh.L2C_REQUEST_XILIAN_REDEQUIP] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	--print("__rh.L2C_REQUEST_XILIAN_REDEQUIP:",sCmd)
	local result =  tonumber(tCmd[1]) or 0		--结果（1成功 ）
	local itemdbid = tonumber(tCmd[2]) or 0
	--print("__rh.L2C_REQUEST_XILIAN_REDEQUIP:",result,sCmd)
	if result == 1 then
		local tGoodsList = hApi.Split(tCmd[3] or "",":")
		--商品数据
		--local id = tonumber(tGoodsList[1]) or 0
		--local itemId = tonumber(tGoodsList[2]) or 0
		--local num = tonumber(tGoodsList[3]) or 1
		local score = tonumber(tGoodsList[4]) or 0
		--local rmb = tonumber(tGoodsList[5]) or 0
		--local quota = tonumber(tGoodsList[6]) or 1
		--local saledCount = tonumber(tGoodsList[7]) or 0
		
		--tGoodsList.id = id
		--tGoodsList.itemId = itemId
		--tGoodsList.num = num
		--tGoodsList.score = score
		--tGoodsList.rmb = rmb
		--tGoodsList.quota = quota
		--tGoodsList.saledCount = saledCount
		
		--print("__rh.L2C_REQUEST_MERGE_REDEQUIP:id:",id)
		--print("__rh.L2C_REQUEST_MERGE_REDEQUIP:itemId:",itemId)
		--print("__rh.L2C_REQUEST_MERGE_REDEQUIP:num:",num)
		--print("__rh.L2C_REQUEST_MERGE_REDEQUIP:score:",score)
		--print("__rh.L2C_REQUEST_MERGE_REDEQUIP:rmb:",rmb)
		--print("__rh.L2C_REQUEST_MERGE_REDEQUIP:quota:",quota)
		--print("__rh.L2C_REQUEST_MERGE_REDEQUIP:saledCount:",saledCount)
		
		local equip = {}
		local tEquip = hApi.Split(tCmd[4] or "",":")
		equip.dbid = tonumber(tEquip[1]) or 0
		equip.typeId = tonumber(tEquip[2]) or 0
		equip.slotNum = tonumber(tEquip[3]) or 0
		equip.attr = {}
		equip.strattr = tEquip[4] or 0
		local tAttr = hApi.Split(equip.strattr or "","|")
		for i = 1, equip.slotNum do
			equip.attr[#equip.attr +1] = tAttr[i]
		end
		
		--获取我的资源（游戏币、兵符、红装晶石、战功积分）
		SendCmdFunc["get_mycoin"]()
		
		hGlobal.event:event("LocalEvent_order_xilian_redequip", result, itemdbid, score, equip)
		
		--任务：累计击购买N个指定道具
		LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.buyItem, 339, 1)
	else
		local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__TEXT_PVP_Operation"], result)
		
		if result == -1 then
			--装备不存在-1
			strText = hVar.tab_string["__TEXT_XiLianInvalidUID"]
		elseif result == -2 then
			--装备类型不存在-2
			strText = hVar.tab_string["__TEXT_XiLianInvalidUID"]
		elseif result == -3 then
			--游戏币不足-3
			strText = hVar.tab_string["ios_not_enough_game_coin"]
		elseif result == -4 then
			--更新装备信息失败-4
		elseif result == -5 then
			--属性洗练失败-5
		elseif result == -6 then
			--芯片不足-6
			strText = hVar.tab_string["__TEXT_ChipNotEnough"]
		end
		
		--弹框
		hGlobal.UI.MsgBox(strText,{
			font = hVar.FONTC,
			ok = function()
			end,
		})
		
		--print("LocalEvent_order_xilian_redequip result:",result)
		hGlobal.event:event("LocalEvent_order_xilian_redequip", result, itemdbid, nil, nil)
	end
	
	--todo xilian event
end

--红装同步结果返回
--同步红装结果返回
__Handler[__rh.L2C_REQUEST_SYNC_REDEQUIP] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	
	print("__rh.L2C_REQUEST_SYNC_REDEQUIP:",sCmd, debug.traceback())
	
	local equipNum =  tonumber(tCmd[1]) or 0		--结果（1成功 ）
	local idx = 1
	local redEquipDic = {}
	for i = 1, equipNum do
		local equip = {}
		local tEquip = hApi.Split(tCmd[idx + i] or "", ":")
		--28920:20107:0::0:1:11:12:21:22:31:32:41:42:51:52:61:62:71:72:81:82;
		equip.dbid = tonumber(tEquip[1]) or 0
		equip.typeId = tonumber(tEquip[2]) or 0
		equip.slotNum = tonumber(tEquip[3]) or 0
		equip.attr = {}
		equip.strattr = tEquip[4] or 0
		equip.CUnique = tonumber(tEquip[5]) or 0
		equip.quality = tonumber(tEquip[6]) or 0
		local tAttr = hApi.Split(equip.strattr or "","|")
		for i = 1, equip.slotNum do
			equip.attr[#equip.attr +1] = tAttr[i]
		end
		equip.randIdx1 = tonumber(tEquip[7]) or 0 --随机属性索引1
		equip.randVal1 = tonumber(tEquip[8]) or 0 --随机属性值1
		equip.randIdx2 = tonumber(tEquip[9]) or 0 --随机属性索引2
		equip.randVal2 = tonumber(tEquip[10]) or 0 --随机属性值2
		equip.randIdx3 = tonumber(tEquip[11]) or 0 --随机属性索引3
		equip.randVal3 = tonumber(tEquip[12]) or 0 --随机属性值3
		equip.randIdx4 = tonumber(tEquip[13]) or 0 --随机属性索引4
		equip.randVal4 = tonumber(tEquip[14]) or 0 --随机属性值4
		equip.randIdx5 = tonumber(tEquip[15]) or 0 --随机属性索引5
		equip.randVal5 = tonumber(tEquip[16]) or 0 --随机属性值5
		equip.randSkillIdx1 = tonumber(tEquip[17]) or 0 --随机技能索引1
		equip.randSkillLv1 = tonumber(tEquip[18]) or 0 --随机技能等级1
		equip.randSkillIdx2 = tonumber(tEquip[19]) or 0 --随机技能索引2
		equip.randSkillLv2 = tonumber(tEquip[20]) or 0 --随机技能等级2
		equip.randSkillIdx3 = tonumber(tEquip[21]) or 0 --随机技能索引3
		equip.randSkillLv3 = tonumber(tEquip[22]) or 0 --随机技能等级3
		
		redEquipDic[equip.dbid] = equip
		
		--print("redEquipDic[equip.dbid]:",equip.dbid,equip)
	end
	
	--同步红装数据
	LuaSyncPlayerDataRedEquip(redEquipDic)
	LuaSaveHeroCard()
	LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
	
end

--分解红装结果返回
__Handler[__rh.L2C_REQUEST_DESCOMPOS_REDEQUIP] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--结果（1成功 ）
	local crystal =  tonumber(tCmd[2]) or 0		--分解获得的神器晶石数量
	local materialNum = tonumber(tCmd[3]) or 0
	local materialIdx = 3
	local materialDBIDList = {}
	for i = 1, materialNum do
		materialDBIDList[#materialDBIDList + 1] = tonumber(tCmd[materialIdx + i]) or 0
	end
	if result == 1 then
		--hGlobal.event:event("LocalEvent_DescomposeRedEquip",materialDBIDList)
		local iteminfo = {}
		for i = 1,#materialDBIDList do
			local dbid = materialDBIDList[i]
			local r, heroId, oItem, pos = LuaGetPlayerDataRedEquip(dbid)
			
			iteminfo[#iteminfo + 1] = {heroId,pos}
			
			--删除该道具并存档
			local uniqueId = oItem[hVar.ITEM_DATA_INDEX.UNIQUE]
			MoveEquipManager.DeleteEquip(uniqueId)
		end
		
		--播放出售音效
		hApi.PlaySound("pay_gold")

		hApi.ShowGetResurceFloatNum("chip",crystal)
		--触发事件，出售装备
		hGlobal.event:event("LocalEvent_DescomposeRedEquip_Result", iteminfo, crystal)
	else
		-- -1 装备不存在
		-- -2 货币不足
		local strRet = hVar.tab_string["ios_err_unknow"]
		--弹框
		hGlobal.UI.MsgBox(strRet,{
			font = hVar.FONTC,
			ok = function()
			end,
		})
	end
end

--请求挑战普通剧情地图结果返回
__Handler[__rh.L2C_REQUIRE_BATTLE_NORMAL_RET] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result = tonumber(tCmd[1]) or 0		--结果（1成功 / 0失败）
	local pvpcoin = tonumber(tCmd[2]) or 0		--剩余兵符数量
	local mapName = tostring(tCmd[3])		--地图名
	local mapDiff = tonumber(tCmd[4]) or 0		--地图难度
	local battlecfg_id = tonumber(tCmd[5]) or 0	--战斗id
	print("请求挑战普通剧情地图结果返回", result, pvpcoin, mapName, mapDiff, battlecfg_id)
	
	--请求挑战普通剧情地图失败冒字提示
	if (result < 0) then
		--冒字
		--local strText = "操作失败！错误码: " .. result
		local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__TEXT_PVP_Operation"], result)
		if (result == -2) then --体力不足
			strText = hVar.tab_string["__TEXT_NotEnoughTili"] --"体力不足"
		elseif (result == -3) then --通关前一个难度才能挑战
			strText = hVar.tab_string["__TEXT_MapNotPassPreevious"] --"通关前一个难度才能挑战"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	if (result == 1) then
		--获取我的资源（游戏币、兵符、红装晶石、战功积分）
		SendCmdFunc["get_mycoin"]()
	end
	
	--触发事件：请求挑战普通剧情地图结果返回
	hGlobal.event:event("LocalEvent_RequireBattleNormalRet", result, pvpcoin, mapName, mapDiff, battlecfg_id)
end

--请求挑战娱乐剧情地图结果返回
__Handler[__rh.L2C_REQUIRE_BATTLE_ENTETAMENT_RET] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result = tonumber(tCmd[1]) or 0		--结果（1成功 / 0失败）
	local pvpcoin = tonumber(tCmd[2]) or 0		--剩余兵符数量
	local mapName = tostring(tCmd[3])		--地图名
	local mapDiff = tonumber(tCmd[4]) or 0		--地图难度
	local battlecfg_id = tonumber(tCmd[5]) or 0	--战斗id
	--print(result, pvpcoin, mapName, mapDiff, battlecfg_id)
	
	--请求挑战娱乐地图失败冒字提示
	if (result < 0) then
		--冒字
		--local strText = "操作失败！错误码: " .. result
		local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__TEXT_PVP_Operation"], result)
		if (result == -2) then --体力不足
			strText = hVar.tab_string["__TEXT_NotEnoughTili"] --"体力不足"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	if (result == 1) then
		--获取我的资源（游戏币、兵符、红装晶石、战功积分）
		SendCmdFunc["get_mycoin"]()
	end
	
	--触发事件：请求挑战娱乐地图结果返回
	hGlobal.event:event("LocalEvent_RequireEntertamentNormalRet", result, pvpcoin, mapName, mapDiff, battlecfg_id)
end

--请求继续娱乐剧情地图结果返回（随机迷宫）
__Handler[__rh.L2C_REQUIRE_RESUME_ENTETAMENT_RET] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result = tonumber(tCmd[1]) or 0		--结果（1成功 / 0失败）
	local mapName = tostring(tCmd[2])		--地图名
	local mapDiff = tonumber(tCmd[3]) or 0		--地图难度
	local battlecfg_id = tonumber(tCmd[4]) or 0	--战斗id
	--print(result, mapName, mapDiff, battlecfg_id)
	
	--请求继续娱乐地图失败冒字提示
	if (result < 0) then
		--冒字
		--local strText = "操作失败！错误码: " .. result
		local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__TEXT_PVP_Operation"], result)
		if (result == -1) then --战斗不存在
			strText = hVar.tab_string["__TEXT_RANDOMMAP_ERROE1"] --"战斗不存在！"
		elseif (result == -2) then --战斗信息不一致
			strText = hVar.tab_string["__TEXT_RANDOMMAP_ERROE2"] --"战斗信息不一致！"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	if (result == 1) then
		--获取我的资源（游戏币、兵符、红装晶石、战功积分）
		--SendCmdFunc["get_mycoin"]()
	end
	
	--触发事件：请求继续娱乐地图结果返回（随机迷宫）
	hGlobal.event:event("LocalEvent_ResumeeEntertamentNormalRet", result, mapName, mapDiff, battlecfg_id)
end

--获取角色vip信息（新）
__Handler[__rh.L2C_REQUEST_VIP_INFO] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	
	local vipLv = tonumber(tCmd[1]) or 0			--viplv
	local topupRmbCount = tonumber(tCmd[2]) or 0		--充值rmb
	local topupCoinCount = tonumber(tCmd[3]) or 0		--充值coin
	local topupAllCoinCount = tonumber(tCmd[4]) or 0	--充值coin+充值赠送coin
	local dailyRewardFlag1 = tonumber(tCmd[5]) or 0		--每日奖励1 0未领取 1已领取
	local dailyRewardFlag2 = tonumber(tCmd[6]) or 0		--每日奖励2 0未领取 1已领取
	local dailyRewardFlag3 = tonumber(tCmd[7]) or 0		--每日奖励3 0未领取 1已领取
	local borderId = tonumber(tCmd[8]) or 0			--玩家边框id
	local iconId = tonumber(tCmd[9]) or 0			--玩家头像id
	local championId = tonumber(tCmd[10]) or 0		--玩家称号id
	local dragonId = tonumber(tCmd[11]) or 0		--玩家聊天龙王id
	local headId = tonumber(tCmd[12]) or 0			--玩家头衔id
	local lineId = tonumber(tCmd[13]) or 0			--玩家线索id
	
	print("vipLv:",vipLv)
	print("topupRmbCount:",topupRmbCount)
	print("topupCoinCount:",topupCoinCount)
	print("topupAllCoinCount:",topupAllCoinCount)
	print("dailyRewardFlag:",dailyRewardFlag)
	
	local dontSave = true
	
	LuaSetPlayerVipLv(vipLv, dontSave)
	LuaSetTopupCount(topupRmbCount, dontSave)
	LuaSetTopupCoinCount(topupCoinCount, dontSave)
	LuaSetDailyReward(dailyRewardFlag1, dontSave)
	LuaSetDailyReward2(dailyRewardFlag2, dontSave)
	LuaSetDailyReward3(dailyRewardFlag3, dontSave)
	LuaSetPlayerBorderID(borderId, dontSave)
	LuaSetPlayerIconID(iconId, dontSave)
	LuaSetPlayerChampionID(championId, dontSave)
	LuaSetPlayerDragonID(dragonId, dontSave)
	LuaSetPlayerHeadID(headId, dontSave)
	LuaSetPlayerLineID(lineId, dontSave)
	
	--统一存档
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	
	if(xlGameCenter_isAuthenticated and xlGameCenter_isAuthenticated() == 1) then
		SendCmdFunc["get_type_sum"](9999)
	end
	
	--触发事件：获得VIP等级和领取状态
	hGlobal.event:event("LocalEvent_GetVipState_New", vipLv, topupRmbCount, topupCoinCount, topupAllCoinCount, dailyRewardFlag1, dailyRewardFlag2, dailyRewardFlag3)
end

--角色vip每日奖励是否领取成功
__Handler[__rh.L2C_REQUEST_VIP_DAILY_REWARD] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local dailyRewardFlag = tonumber(tCmd[1]) or 0		--dailyRewardFlag
	local rewardIndex = tonumber(tCmd[2]) or 0		--奖励索引index
	local prizeId = tonumber(tCmd[3]) or 0			--奖励id
	local prizeType = tonumber(tCmd[4]) or 0		--奖励类型
	
	if (rewardIndex == 1) then
		LuaSetDailyReward(dailyRewardFlag)
	elseif (rewardIndex == 2) then
		LuaSetDailyReward2(dailyRewardFlag)
	elseif (rewardIndex == 3) then
		LuaSetDailyReward3(dailyRewardFlag)
	end
	
	--print(dailyRewardFlag, rewardIndex, prizeId, prizeType)
	
	--直接领奖
	if (prizeId > 0) then
		--挡操作
		hUI.NetDisable(30000)
		SendCmdFunc["get_mail_annex"](prizeId, prizeType)
	end
	
	--触发事件：获得领取状态
	hGlobal.event:event("LocalEvent_GetVipDailyRewardFlag", dailyRewardFlag, rewardIndex)
end

--收到战车排行榜数据的返回
__Handler[__rh.L2C_NOTICE_TANK_BILLBOARD] = function(sCmd)
	--local sCmd = packet:readString()
	--print("__Handler.L2C_NOTICE_TANK_BILLBOARD", sCmd)
	
	--取消挡操作
	--hUI.NetDisable(0)
	
	local tCmd = hApi.Split(sCmd,";")
	local result = tonumber(tCmd[1]) or 0		--结果（1成功 0失败）
	local bId = tonumber(tCmd[2]) or 0		--排行榜类型
	local diff = tonumber(tCmd[3]) or 0		--难度
	local recordNum = tonumber(tCmd[4]) or 0	--纪录数量
	local billboardT = {}
	
	local rIdx = 4
	for i = 1, recordNum, 1 do
		local rank = tonumber(tCmd[rIdx+1])
		local uid = tonumber(tCmd[rIdx+2])
		local rid = tonumber(tCmd[rIdx+3])
		local name = hApi.StringDecodeEmoji(tCmd[rIdx+4]) --玩家名 --解析表情
		local stage = tonumber(tCmd[rIdx+5])
		local tankId = tonumber(tCmd[rIdx+6])
		local weaponId = tonumber(tCmd[rIdx+7])
		local gametime = tonumber(tCmd[rIdx+8])
		local scientistNum = tonumber(tCmd[rIdx+9])
		local goldNum = tonumber(tCmd[rIdx+10])
		local killNum = tonumber(tCmd[rIdx+11])
		local time = tonumber(tCmd[rIdx+12])
		
		billboardT[#billboardT+1] = {rank = rank, uid = uid, rid = rid, name = name, bId = bId, stage = stage, tankId = tankId, weaponId = weaponId, gametime = gametime, scientistNum = scientistNum, goldNum = goldNum, killNum = killNum, time = time,}
		
		rIdx = rIdx + 12
	end
	
	--我的数据
	local nameMe = hApi.StringDecodeEmoji(tCmd[rIdx+1]) --玩家名 --解析表情
	local stageMe = tonumber(tCmd[rIdx+2])
	local tankIdMe = tonumber(tCmd[rIdx+3])
	local weaponIdMe = tonumber(tCmd[rIdx+4])
	local gametimeMe = tonumber(tCmd[rIdx+5])
	local scientistNumMe = tonumber(tCmd[rIdx+6])
	local goldNumMe = tonumber(tCmd[rIdx+7])
	local killNumMe = tonumber(tCmd[rIdx+8])
	local timeMe = tonumber(tCmd[rIdx+9])
	
	billboardT.bIdMe = bId
	billboardT.rankMe = 0
	billboardT.nameMe = nameMe
	billboardT.stageMe = stageMe
	billboardT.tankIdMe = tankIdMe
	billboardT.weaponIdMe = weaponIdMe
	billboardT.gametimeMe = gametimeMe
	billboardT.scientistNumMe = scientistNumMe
	billboardT.goldNumMe = goldNumMe
	billboardT.killNumMe = killNumMe
	billboardT.timeMe = timeMe
	
	--print("billboardT.rankMe=", billboardT.rankMe)
	--print("billboardT.nameMe=", billboardT.nameMe)
	--print("billboardT.stageMe=", billboardT.stageMe)
	--print("billboardT.weaponIdMe=", billboardT.weaponIdMe)
	--print("billboardT.gametimeMe=", billboardT.gametimeMe)
	--print("billboardT.scientistNumMe=", billboardT.scientistNumMe)
	--print("billboardT.goldNumMe=", billboardT.goldNumMe)
	--print("billboardT.killNumMe=", billboardT.killNumMe)
	--print("billboardT.timeMe=", billboardT.timeMe)
	
	--检测我是否在排名里
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()				--我使用角色rid
	for i = 1, recordNum, 1 do
		if (billboardT[i].uid == uId) and (billboardT[i].rid == rId) then
			billboardT.rankMe = i
		end
	end
	
	--成功
	--触发事件：通知战车排行榜数据
	hGlobal.event:event("localEvent_TankBillboardData", result, bId, diff, billboardT)
end

--收到战车玩家改名结果的返回
__Handler[__rh.L2C_NOTICE_TANK_MODIFYNAME] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_NOTICE_TANK_MODIFYNAME", sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local tCmd = hApi.Split(sCmd,";")
	
	local result =  tonumber(tCmd[1]) or 0		--更名结果（1成功 0失败）
	local info = tonumber(tCmd[2]) or -3		--更名信息 (成功:prizeid 失败:失败原因 -1钱不够 -2重名 -3未知)
	local name = hApi.StringDecodeEmoji(tCmd[3]) --玩家名 --还原表情
	local gamecoin = tonumber(tCmd[4]) or 0		--消耗的氪石数量
	
	if (gamecoin > 0) then
		--重新查询我的游戏币等数据
		SendCmdFunc["get_mycoin"]()
	end
	
	--修改姓名返回
	hGlobal.event:event("localEvent_modify_tank_username", result, info, name, gamecoin)
end

--收到战车上传关卡日志结果返回
__Handler[__rh.L2C_NOTICE_TANK_UPLOAD_STAGELOG] = function(sCmd)
	--local sCmd = packet:readString()
	--print("__Handler.L2C_NOTICE_TANK_UPLOAD_STAGELOG", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	local result =  tonumber(tCmd[1]) or 0		--结果（1成功 0失败）
	local uid = tonumber(tCmd[2]) or 0			--uid
	local rid = tonumber(tCmd[3]) or 0			--rid
	local logId = tonumber(tCmd[4]) or 0		--日志id
	
	--print(result, uid, rid, logId)
	
	--战车上传关卡日志结果返回
	hGlobal.event:event("localEvent_upload_tank_stage", result, uid, rid, logId)
end

--收到战车昨日排名结果返回
__Handler[__rh.L2C_NOTICE_TANK_YESTERDAY_RANK] = function(sCmd)
	--local sCmd = packet:readString()
	--print("__Handler.L2C_NOTICE_TANK_YESTERDAY_RANK", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	local uid = tonumber(tCmd[1]) or 0			--uid
	local rid = tonumber(tCmd[2]) or 0			--rid
	local rank = tonumber(tCmd[3]) or 0		--日志id
	
	--print("收到战车昨日排名结果返回", uid, rid, rank)
	
	--设置战车昨日排名名次
	LuaSetTankYesterdayRank(rank)
	
	--战车昨日排名结果返回
	hGlobal.event:event("LocalEvent_OnReceiveTankYesterdayRank", uid, rid, rank)
end

--收到领取战车昨日排名奖励返回
__Handler[__rh.L2C_RECEIVE_TANK_YESTERDAY_RANK] = function(sCmd)
	--local sCmd = packet:readString()
	--print("__Handler.L2C_RECEIVE_TANK_YESTERDAY_RANK", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	local uid = tonumber(tCmd[1]) or 0			--uid
	local rid = tonumber(tCmd[2]) or 0			--rid
	local rank = tonumber(tCmd[3]) or 0		--日志id
	
	--print("收到领取战车昨日排名奖励返回", uid, rid, rank)
	
	--本地添加积分
	local score = 0
	for i = 1, #hVar.TANK_BILLBOARD_REWARD, 1 do
		local tReward = hVar.TANK_BILLBOARD_REWARD[i]
		if (rank >= tReward.from) and (rank <= tReward.to) then
			score = tReward.score
			break
		end
	end
	
	--添加积分
	LuaAddPlayerScoreByWay(score,hVar.GET_SCORE_WAY.DAILYREWARD)
	
	local keyList = {"material",}
	LuaSavePlayerData_Android_Upload(keyList, "每日领奖")
	
	--战车昨日排名结果返回
	--hGlobal.event:event("LocalEvent_OnReceiveTankYesterdayRank", uid, rid, rank)
	--隐藏日常奖励单位
	hGlobal.event:event("LocalEvent_HideDailyRewardUnit",score)
	
	--每日领奖
	Gift_Function["reward_1"]()
end

--收到玩家武器枪信息返回结果
__Handler[__rh.L2C_REQUIRE_TANK_WEAPON_INFO_RET] = function(sCmd)
	--local sCmd = packet:readString()
	--print("__Handler.L2C_REQUIRE_TANK_WEAPON_INFO_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--print("收到战车昨日排名结果返回", uid, rid, rank)
	
	local weaponNum = tonumber(tCmd[1]) or 0		--武器枪数量
	
	--初始化武器枪表
	local notSaveFlag = true
	LuaClearWeapon(hVar.MY_TANK_ID, notSaveFlag)
	
	local rIdx = 1
	for i = 1, weaponNum, 1 do
		local tmp = {}
		local tRInfo = hApi.Split(tCmd[rIdx+i],":")
		local id = tonumber(tRInfo[1]) or 0	--武器id
		local star = tonumber(tRInfo[2]) or 0	--武器star
		local num = tonumber(tRInfo[3]) or 0	--武器num
		local exp = tonumber(tRInfo[4]) or 0	--武器exp
		--print(id, star, num, exp)
		
		--设置宝物表
		local nWeaponIdx = LuaGetHeroWeaponIndexById(hVar.MY_TANK_ID, id)
		if (nWeaponIdx > 0) then
			LuaSetHeroWeaponLv(hVar.MY_TANK_ID, nWeaponIdx, star, notSaveFlag)
			LuaAddHeroWeaponDebrisNum(hVar.MY_TANK_ID, nWeaponIdx, num, notSaveFlag)
			LuaSetHeroWeaponExp(hVar.MY_TANK_ID, nWeaponIdx, exp, notSaveFlag)
		end
		--LuaSetTreasureBook (id, lv, num, notSaveFlag)
	end
	
	--存档
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	
	--战车昨日排名结果返回
	--hGlobal.event:event("LocalEvent_OnReceiveTankYesterdayRank", uid, rid, rank)
end

--收到玩家武器枪升星返回结果
__Handler[__rh.L2C_REQUIRE_TANK_WEAPON_STARUP_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_WEAPON_STARUP_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local weaponId = tonumber(tCmd[2]) or 0		--武器id
	local star = tonumber(tCmd[3]) or 0		--星级
	local num = tonumber(tCmd[4]) or 0		--碎片数量
	local level = tonumber(tCmd[5]) or 0		--等级
	local costScore = tonumber(tCmd[6]) or 0	--消耗的积分
	local costDebris = tonumber(tCmd[7]) or 0	--消耗的碎片数量
	local costRmb = tonumber(tCmd[8]) or 0	--消耗的游戏币数量
	
	--升星失败冒字提示
	if (result ~= 1) then
		local strText = "武器升星！错误码: " .. result
		
		if (result == -1) then
			strText = hVar.tab_string["__UPGRADEBFSTAR_CANT"] --"已升到最大星级"
		elseif (result == -2) then
			strText = hVar.tab_string["__TEXT_DebrisNotEnough"] --"碎片不足"
		elseif (result == -3) then
			strText = hVar.tab_string["__UPGRADEBFSTAR_LESSLEVEL"] --"等级不足"
		elseif (result == -4) then
			strText = hVar.tab_string["ios_not_enough_game_coin"] --"氪石不足"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--操作成功
	if (result == 1) then
		--扣除积分
		--修改添加积分的同时加上来源以便统计
		if (costScore > 0) then
			LuaAddPlayerScoreByWay(-costScore, hVar.GET_SCORE_WAY.UNLOCKWEAPON)
			
			--刷新积分界面
			hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
		end
		
		--更新数据
		local notSaveFlag = true
		local nWeaponIdx = LuaGetHeroWeaponIndexById(hVar.MY_TANK_ID, weaponId)
		LuaSetHeroWeaponLv(hVar.MY_TANK_ID, nWeaponIdx, star, notSaveFlag)
		LuaAddHeroWeaponDebrisNum(hVar.MY_TANK_ID, nWeaponIdx, -costDebris, notSaveFlag)
		LuaSetHeroWeaponExp(hVar.MY_TANK_ID, nWeaponIdx, level, notSaveFlag)
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		local keyList = {"card","material"}
		LuaSavePlayerData_Android_Upload(keyList, "武器升星")
		
		if (costRmb > 0) then
			--更新客户端游戏币界面
			SendCmdFunc["gamecoin"]()
		end
	end
	
	--触发事件：通知玩家武器升星返回结果
	hGlobal.event:event("LocalEvent_WeaponStarUp_Ret", result, weaponId, star, num, level, costScore, costDebris, costRmb)
end

--[[
--收到玩家武器枪加经验值返回结果
__Handler[__rh.L2C_REQUIRE_TANK_WEAPON_ADDEXP_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_WEAPON_ADDEXP_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local weaponId = tonumber(tCmd[2]) or 0		--武器id
	local expNew = tonumber(tCmd[3]) or 0		--新的经验值
	local expAdd = tonumber(tCmd[4]) or 0		--增加的经验值
	
	--升星失败冒字提示
	if (result ~= 1) then
		local strText = "武器加经验值！错误码: " .. result
		
		if (result == -1) then
			strText = "无效的武器枪"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--操作成功
	if (result == 1) then
		--更新数据
		local nWeaponIdx = LuaGetHeroWeaponIndexById(hVar.MY_TANK_ID, weaponId)
		LuaAddHeroWeaponExp(hVar.MY_TANK_ID, nWeaponIdx, expAdd)
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		local keyList = {"card",}
		LuaSavePlayerData_Android_Upload(keyList, "武器加经验值")
	end
	
	--触发事件：通知玩家武器加经验值返回结果
	hGlobal.event:event("LocalEvent_WeaponAddExp_Ret", result, weaponId, expNew, expAdd)
end
]]

--获得服务器月卡和今日月卡发奖的返回
__Handler[__rh.L2C_NOTICE_MONTH_CARD] = function(sCmd)
	--local sCmd = packet:readString()
	--print("__Handler.L2C_NOTICE_MONTH_CARD", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	local iMonthCard = tonumber(tCmd[1]) or 0 --月卡是否有效
	local iDays = tonumber(tCmd[2]) or 0 --月卡剩余有效天数
	local iFreeCount = tonumber(tCmd[3]) or 0 --月卡今日已使用强化免费次数
	
	--存储月卡状态和月卡剩余天数
	--g_monthcard_state = iMonthCard
	g_monthcard_leftdays = iDays
	g_monthcard_freeticetcount = iFreeCount --今日已使用月卡强化免费次数
	
	--本次存储
	LuaSetIsMonthCardState(g_curPlayerName, iMonthCard)
	
	--print("获得服务器月卡和今日月卡发奖的返回", iMonthCard, iDays, iFreeCount)
	
	--触发事件：通知收到月卡信息回调
	hGlobal.event:event("localEvent_MonthCardGiftList", iMonthCard, iDays, iFreeCount)
end

--收到玩家武器枪升级返回结果
__Handler[__rh.L2C_REQUIRE_TANK_WEAPON_LEVELUP_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_WEAPON_LEVELUP_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local weaponId = tonumber(tCmd[2]) or 0		--武器id
	local star = tonumber(tCmd[3]) or 0		--星级
	local num = tonumber(tCmd[4]) or 0		--碎片数量
	local level = tonumber(tCmd[5]) or 0		--等级
	local costScore = tonumber(tCmd[6]) or 0	--消耗的积分
	local costDebris = tonumber(tCmd[7]) or 0	--消耗的碎片数量
	local costRmb = tonumber(tCmd[8]) or 0	--消耗的游戏币数量
	
	--升星失败冒字提示
	if (result ~= 1) then
		local strText = "武器升级！错误码: " .. result
		
		if (result == -1) then
			strText = hVar.tab_string["__UPGRADEBFLEVEL_CANT"] --"已升到最大等级"
		elseif (result == -2) then
			strText = hVar.tab_string["__TEXT_DebrisNotEnough"] --"碎片不足"
		elseif (result == -3) then
			strText = hVar.tab_string["__UPGRADEBFLEVEL_LESSSTAR"] --"星级不足"
		elseif (result == -4) then
			strText = hVar.tab_string["ios_not_enough_game_coin"] --"氪石不足"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--操作成功
	if (result == 1) then
		--扣除积分
		--修改添加积分的同时加上来源以便统计
		if (costScore > 0) then
			LuaAddPlayerScoreByWay(-costScore, hVar.GET_SCORE_WAY.UNLOCKWEAPON)
			
			--刷新积分界面
			hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
		end
		
		--更新数据
		local notSaveFlag = true
		local nWeaponIdx = LuaGetHeroWeaponIndexById(hVar.MY_TANK_ID, weaponId)
		LuaSetHeroWeaponLv(hVar.MY_TANK_ID, nWeaponIdx, star, notSaveFlag)
		LuaAddHeroWeaponDebrisNum(hVar.MY_TANK_ID, nWeaponIdx, -costDebris, notSaveFlag)
		LuaSetHeroWeaponExp(hVar.MY_TANK_ID, nWeaponIdx, level, notSaveFlag)
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		local keyList = {"card","material"}
		LuaSavePlayerData_Android_Upload(keyList, "武器升级")
		
		if (costRmb > 0) then
			--更新客户端游戏币界面
			SendCmdFunc["gamecoin"]()
		end
	end
	
	--触发事件：通知玩家武器升级返回结果
	hGlobal.event:event("LocalEvent_WeaponLevelUp_Ret", result, weaponId, star, num, level, costScore, costDebris, costRmb)
end

--收到玩家战车技能点数信息返回结果
__Handler[__rh.L2C_REQUIRE_TANK_TALENTPOINT_INFO_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_TALENTPOINT_INFO_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--print("收到玩家战车技能点数信息返回结果", uid, rid, rank)
	--2;
	--6109:2:1:120:2:0:2:19:1_0:2_0:3_0:4_0:6_0:7_0:8_0:21_0:22_0:23_0:24_0:25_0:26_0:27_0:41_0:42_0:43_0:44_0:45_0:;
	--6108:2:1:120:2:0:2:19:1_0:2_0:3_0:4_0:6_0:7_0:8_0:21_0:22_0:23_0:24_0:25_0:26_0:27_0:41_0:42_0:43_0:44_0:45_0:;
	
	local tankNum = tonumber(tCmd[1]) or 0		--战车数量
	
	local rIdx = 1
	for i = 1, tankNum, 1 do
		local tmp = {}
		local tRInfo = hApi.Split(tCmd[rIdx+i],":")
		local id = tonumber(tRInfo[1]) or 0		--战车id
		local level = tonumber(tRInfo[2]) or 0		--等级
		local star = tonumber(tRInfo[3]) or 0		--星级
		local exp = tonumber(tRInfo[4]) or 0		--经验值
		local talentPointSum = tonumber(tRInfo[5]) or 0		--总天赋点数
		local talentPointUsed = tonumber(tRInfo[6]) or 0	--已使用的天赋点数
		local talentPoint = tonumber(tRInfo[7]) or 0		--剩余天赋点数
		local talentNum = tonumber(tRInfo[8]) or 0		--天赋加点表数量
		
		--设置等级
		local tHeroCard = hApi.GetHeroCardById(id)
		if tHeroCard then
			tHeroCard.attr.exp = exp
			tHeroCard.attr.level = level
			tHeroCard.attr.star = star
		else
			LuaAddNewHeroCard(id, star, level, notSaveFlag)
			tHeroCard = hApi.GetHeroCardById(id)
			tHeroCard.attr.exp = exp
		end
		
		--设置天赋点数
		local notSaveFlag = true
		LuaSetHeroTalentPoint(id, talentPoint, notSaveFlag)
		
		for j = 1, talentNum, 1 do
			local tTalentInfo = hApi.Split(tRInfo[8+j],"_")
			local talentId = tonumber(tTalentInfo[1]) or 0 --天赋id
			local talentLv = tonumber(tTalentInfo[2]) or 0 --天赋等级
			if (talentId > 0) then
				--local talentIdx = LuaGetHeroTalentIndexById(id, talentId)
				LuaSetHeroTalentSkillLv(id, talentId, talentLv, notSaveFlag)
			end
		end
		
		--rIdx = rIdx + talentNum
	end
	
	--存档
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	
	--收到玩家战车技能点数信息返回结果
	hGlobal.event:event("LocalEvent_OnReceiveTankSkillPoint", tankNum)
end

--收到玩家战车加经验值返回结果
__Handler[__rh.L2C_REQUIRE_TANK_TALENTPOINT_ADDEXP_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_TALENTPOINT_ADDEXP_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local tankId = tonumber(tCmd[2]) or 0		--战车id
	local expNew = tonumber(tCmd[3]) or 0		--新的经验值
	local expAdd = tonumber(tCmd[4]) or 0		--增加的经验值
	local levelNew = tonumber(tCmd[5]) or 0		--新的等级
	local talentPointNew = tonumber(tCmd[6]) or 0		--新的天赋点数
	
	--升星失败冒字提示
	if (result ~= 1) then
		local strText = "战车加经验值失败！错误码: " .. result
		
		if (result == -1) then
			--"无效的武器枪"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--操作成功
	if (result == 1) then
		--设置等级
		local tHeroCard = hApi.GetHeroCardById(tankId)
		if tHeroCard then
			tHeroCard.attr.exp = expNew
			tHeroCard.attr.level = levelNew
		end
		
		--设置天赋点数
		local notSaveFlag = true
		LuaSetHeroTalentPoint(tankId, talentPointNew, notSaveFlag)
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		local keyList = {"card",}
		LuaSavePlayerData_Android_Upload(keyList, "战车加经验值")
	end
	
	--触发事件：通知玩家战车加经验值返回结果
	hGlobal.event:event("LocalEvent_TankAddExp_Ret", result, expNew, expAdd, levelNew, talentPointNew)
end

--收到玩家战车分配点数返回结果
__Handler[__rh.L2C_REQUIRE_TANK_TALENTPOINT_ADDPOINT_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_TALENTPOINT_ADDPOINT_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0			--结果（0失败 1成功 ）
	local tankId = tonumber(tCmd[2]) or 0			--战车id
	local talentId = tonumber(tCmd[3]) or 0			--天赋点id
	local requireAttrPoint = tonumber(tCmd[4]) or 0		--需要的天赋点数
	local costScore = tonumber(tCmd[5]) or 0		--需要的积分
	local talentPointNew = tonumber(tCmd[6]) or 0		--新的天赋点数
	local talentLvNew = tonumber(tCmd[7]) or 0		--新的天赋技能等级
	
	--战车分配点数失败冒字提示
	if (result ~= 1) then
		local strText = "战车分配点数失败！错误码: " .. result
		
		if (result == -1) then
			strText = "无效的天赋id"
		elseif (result == -2) then
			strText = "天赋技能已满级"
		elseif (result == -3) then
			strText = "天赋点数不足"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--操作成功
	if (result == 1) then
		--扣除积分
		--修改添加积分的同时加上来源以便统计
		LuaAddPlayerScoreByWay(-costScore, hVar.GET_SCORE_WAY.UPGRADETACTICS)
		
		--刷新积分界面
		hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
		
		--设置天赋点数
		local notSaveFlag = true
		LuaSetHeroTalentPoint(tankId, talentPointNew, notSaveFlag)
		
		--设置天赋技能等级
		--local talentIdx = LuaGetHeroTalentIndexById(tankId, talentId)
		LuaSetHeroTalentSkillLv(tankId, talentId, talentLvNew, notSaveFlag)
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		local keyList = {"card","material",}
		LuaSavePlayerData_Android_Upload(keyList, "战车分配天赋点数")
	end
	
	--触发事件：通知玩家战车分配点数返回结果
	hGlobal.event:event("LocalEvent_TankAddTalent_Ret", result, tankId, talentId, requireAttrPoint, costScore, talentPointNew, talentLvNew)
end

--收到玩家战车重置天赋点数返回结果
__Handler[__rh.L2C_REQUIRE_TANK_TALENTPOINT_RESTORE_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_TALENTPOINT_RESTORE_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0			--结果（0失败 1成功 ）
	local tankId = tonumber(tCmd[2]) or 0			--战车id
	local talentPointNew = tonumber(tCmd[3]) or 0		--新的天赋点数
	local costScore = tonumber(tCmd[4]) or 0		--需要的积分
	local costRmb = tonumber(tCmd[5]) or 0			--需要的游戏币
	
	--战车重置天赋点数失败冒字提示
	if (result ~= 1) then
		if (result == -1) then
			strText = hVar.tab_string["ios_not_enough_game_coin"] --"游戏币不足"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--操作成功
	if (result == 1) then
		--扣除积分
		--修改添加积分的同时加上来源以便统计
		LuaAddPlayerScoreByWay(-costScore, hVar.GET_SCORE_WAY.UPGRADETACTICS)
		
		--刷新积分界面
		hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
		
		--设置天赋点数
		local notSaveFlag = true
		LuaSetHeroTalentPoint(tankId, talentPointNew, notSaveFlag)
		
		--清除天赋技能等级信息
		LuaClearTalent(tankId, notSaveFlag)
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		local keyList = {"card","material",}
		LuaSavePlayerData_Android_Upload(keyList, "战车重置天赋点数")
		
		if (costRmb > 0) then
			--更新客户端游戏币界面
			SendCmdFunc["gamecoin"]()
		end
	end
	
	--触发事件：通知玩家战车分配点数返回结果
	hGlobal.event:event("LocalEvent_TankRestoreTalent_Ret", result, tankId, costScore, talentPointNew)
end

--收到玩家宠物信息返回结果
__Handler[__rh.L2C_REQUIRE_TANK_PET_INFO_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_PET_INFO_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--print("收到战车昨日排名结果返回", uid, rid, rank)
	
	local petNum = tonumber(tCmd[1]) or 0		--宠物数量
	
	--初始化宠物表
	local notSaveFlag = true
	LuaClearPet(hVar.MY_TANK_ID, notSaveFlag)
	
	local rIdx = 1
	for i = 1, petNum, 1 do
		local tmp = {}
		local tRInfo = hApi.Split(tCmd[rIdx+i],":")
		local id = tonumber(tRInfo[1]) or 0	--宠物id
		local star = tonumber(tRInfo[2]) or 0	--宠物star
		local num = tonumber(tRInfo[3]) or 0	--宠物num
		local exp = tonumber(tRInfo[4]) or 0	--宠物exp
		local wakuang = tonumber(tRInfo[5]) or 0	--宠物是否挖矿
		local watili = tonumber(tRInfo[6]) or 0	--宠物是否挖体力
		local sendtime = tonumber(tRInfo[7]) or 0	--宠物上次派遣时间
		--print(id, star, num, exp, wakuang, watili)
		
		--设置宠物表
		local nPetIdx = LuaGetHeroPetIndexById(hVar.MY_TANK_ID, id)
		if (nPetIdx > 0) then
			LuaSetHeroPetLv(hVar.MY_TANK_ID, nPetIdx, star, notSaveFlag)
			LuaAddHeroPetDebrisNum(hVar.MY_TANK_ID, nPetIdx, num, notSaveFlag)
			LuaSetHeroPetExp(hVar.MY_TANK_ID, nPetIdx, exp, notSaveFlag)
			LuaSetHeroPetInWaKuang(hVar.MY_TANK_ID, nPetIdx, wakuang, notSaveFlag)
			LuaSetHeroPetInWaTiLi(hVar.MY_TANK_ID, nPetIdx, watili, notSaveFlag)
		end
		--LuaSetTreasureBook (id, lv, num, notSaveFlag)
	end
	
	--存档
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	
	--收到玩家宠物信息返回结果事件
	hGlobal.event:event("LocalEvent_OnReceiveTankPetInfoRet", petNum)
end

--收到玩家宠物升星返回结果
__Handler[__rh.L2C_REQUIRE_TANK_PET_STARUP_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_PET_STARUP_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--1;13041;3;5;5000;80;
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local petId = tonumber(tCmd[2]) or 0		--宠物id
	local star = tonumber(tCmd[3]) or 0		--星级
	local num = tonumber(tCmd[4]) or 0		--碎片数量
	local level = tonumber(tCmd[5]) or 0		--宠物等级
	local costScore = tonumber(tCmd[6]) or 0	--消耗的积分
	local costDebris = tonumber(tCmd[7]) or 0	--消耗的碎片数量
	local costRmb = tonumber(tCmd[8]) or 0		--消耗的游戏币
	
	--宠物升星失败冒字提示
	if (result ~= 1) then
		local strText = "宠物升星失败！错误码: " .. result
		
		if (result == -1) then
			strText = hVar.tab_string["__UPGRADEBFSTAR_CANT"] --"已升到最大星级"
		elseif (result == -2) then
			strText = hVar.tab_string["__TEXT_DebrisNotEnough"] --"碎片不足"
		elseif (result == -3) then
			strText = hVar.tab_string["__UPGRADEBFSTAR_LESSLEVEL"] --"等级不足"
		elseif (result == -4) then
			strText = hVar.tab_string["ios_not_enough_game_coin"] --"氪石不足"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--操作成功
	if (result == 1) then
		--扣除积分
		if (costScore > 0) then
			--修改添加积分的同时加上来源以便统计
			LuaAddPlayerScoreByWay(-costScore, hVar.GET_SCORE_WAY.UPGRADEPET)
			
			--刷新积分界面
			hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
		end
		
		--更新数据
		local notSaveFlag = true
		local nPetIdx = LuaGetHeroPetIndexById(hVar.MY_TANK_ID, petId)
		LuaSetHeroPetLv(hVar.MY_TANK_ID, nPetIdx, star, notSaveFlag)
		LuaAddHeroPetDebrisNum(hVar.MY_TANK_ID, nPetIdx, -costDebris, notSaveFlag)
		LuaSetHeroPetExp(hVar.MY_TANK_ID, nPetIdx, level, notSaveFlag)
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		local keyList = {"card","material"}
		LuaSavePlayerData_Android_Upload(keyList, "宠物升星")
		
		if (costRmb > 0) then
			--更新客户端游戏币界面
			SendCmdFunc["gamecoin"]()
		end
	end
	
	--触发事件：通知玩家宠物升星返回结果
	hGlobal.event:event("LocalEvent_PetStarUp_Ret", result, petId, star, num, level, costScore, costDebris, costRmb)
end

--[[
--收到玩家宠物加经验值返回结果
__Handler[__rh.L2C_REQUIRE_TANK_PET_ADDEXP_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_PET_ADDEXP_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local petId = tonumber(tCmd[2]) or 0		--宠物id
	local expNew = tonumber(tCmd[3]) or 0		--新的经验值
	local expAdd = tonumber(tCmd[4]) or 0		--增加的经验值
	
	--宠物加经验值失败冒字提示
	if (result ~= 1) then
		local strText = "宠物加经验值失败！错误码: " .. result
		
		if (result == -1) then
			strText = "无效的宠物"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--操作成功
	if (result == 1) then
		--更新数据
		local nPetIdx = LuaGetHeroPetIndexById(hVar.MY_TANK_ID, petId)
		LuaAddHeroPetExp(hVar.MY_TANK_ID, nPetIdx, expAdd)
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		local keyList = {"card",}
		LuaSavePlayerData_Android_Upload(keyList, "宠物加经验值")
	end
	
	--触发事件：通知玩家武器加经验值返回结果
	hGlobal.event:event("LocalEvent_PetAddExp_Ret", result, petId, expNew, expAdd)
end
]]

--收到玩家宠物升级返回结果
__Handler[__rh.L2C_REQUIRE_TANK_PET_LEVELUP_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_PET_LEVELUP_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--1;13041;3;5;5000;80;
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local petId = tonumber(tCmd[2]) or 0		--宠物id
	local star = tonumber(tCmd[3]) or 0		--星级
	local num = tonumber(tCmd[4]) or 0		--碎片数量
	local level = tonumber(tCmd[5]) or 0		--宠物等级
	local costScore = tonumber(tCmd[6]) or 0	--消耗的积分
	local costDebris = tonumber(tCmd[7]) or 0	--消耗的碎片数量
	local costRmb = tonumber(tCmd[8]) or 0		--消耗的游戏币
	
	--宠物升星失败冒字提示
	if (result ~= 1) then
		local strText = "宠物升星失败！错误码: " .. result
		
		if (result == -1) then
			strText = hVar.tab_string["__UPGRADEBFLEVEL_CANT"] --"已升到最大等级"
		elseif (result == -2) then
			strText = hVar.tab_string["__TEXT_DebrisNotEnough"] --"碎片不足"
		elseif (result == -3) then
			strText = hVar.tab_string["__UPGRADEBFLEVEL_LESSSTAR"] --"星级不足"
		elseif (result == -4) then
			strText = hVar.tab_string["ios_not_enough_game_coin"] --"氪石不足"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--操作成功
	if (result == 1) then
		--扣除积分
		if (costScore > 0) then
			--修改添加积分的同时加上来源以便统计
			LuaAddPlayerScoreByWay(-costScore, hVar.GET_SCORE_WAY.UPGRADEPET)
			
			--刷新积分界面
			hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
		end
		
		--更新数据
		local notSaveFlag = true
		local nPetIdx = LuaGetHeroPetIndexById(hVar.MY_TANK_ID, petId)
		LuaSetHeroPetLv(hVar.MY_TANK_ID, nPetIdx, star, notSaveFlag)
		LuaAddHeroPetDebrisNum(hVar.MY_TANK_ID, nPetIdx, -costDebris, notSaveFlag)
		LuaSetHeroPetExp(hVar.MY_TANK_ID, nPetIdx, level, notSaveFlag)
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		local keyList = {"card","material"}
		LuaSavePlayerData_Android_Upload(keyList, "宠物升级")
		
		if (costRmb > 0) then
			--更新客户端游戏币界面
			SendCmdFunc["gamecoin"]()
		end
	end
	
	--触发事件：通知玩家宠物升星返回结果
	hGlobal.event:event("LocalEvent_PetLevelUp_Ret", result, petId, star, num, level, costScore, costDebris, costRmb)
end

--收到玩家战术卡信息返回结果
__Handler[__rh.L2C_REQUIRE_TANK_TACTIC_INFO_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_TACTIC_INFO_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--print("收到玩家战术卡信息返回结果", uid, rid, rank)
	
	local tacticNum = tonumber(tCmd[1]) or 0		--宠物数量
	
	--初始化战术卡表
	Save_PlayerData.battlefieldskillbook = {}
	
	local rIdx = 1
	for i = 1, tacticNum, 1 do
		local tmp = {}
		local tRInfo = hApi.Split(tCmd[rIdx+i],":")
		local id = tonumber(tRInfo[1]) or 0	--战术卡id
		local num = tonumber(tRInfo[2]) or 0	--碎片数量
		local totalNum = tonumber(tRInfo[3]) or 0	--总碎片数量
		local lv = tonumber(tRInfo[4]) or 0	--等级
		--print(id, num, totalNum, lv)
		
		Save_PlayerData.battlefieldskillbook[#Save_PlayerData.battlefieldskillbook+1] = {id, lv, num,}
		--LuaSetTreasureBook (id, lv, num, notSaveFlag)
	end
	
	--存档
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	
	--战车昨日排名结果返回
	--hGlobal.event:event("LocalEvent_OnReceiveTankYesterdayRank", uid, rid, rank)
end

--收到玩家战术卡升级返回结果
__Handler[__rh.L2C_REQUIRE_TANK_TACTIC_LEVELUP_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_TACTIC_LEVELUP_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--1;13041;3;5;5000;80;
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local tacticId = tonumber(tCmd[2]) or 0		--宠物id
	local level = tonumber(tCmd[3]) or 0		--等级
	local num = tonumber(tCmd[4]) or 0		--碎片数量
	local costScore = tonumber(tCmd[5]) or 0	--消耗的积分
	local costDebris = tonumber(tCmd[6]) or 0	--消耗的碎片数量
	local costRmb = tonumber(tCmd[7]) or 0		--消耗的游戏币
	
	--玩家战术卡升级失败冒字提示
	if (result ~= 1) then
		local strText = "战术卡升级失败！错误码: " .. result
		
		if (result == -1) then
			strText = hVar.tab_string["__TEXT_DebrisNotEnough"] --"碎片不足"
		elseif (result == -2) then
			strText = hVar.tab_string["__UPGRADEBFLEVEL_CANT"] --"已升到最大等级"
		elseif (result == -3) then
			strText = hVar.tab_string["__TEXT_PARAP_INVALID"] --"参数错误"
		elseif (result == -4) then
			strText = hVar.tab_string["ios_not_enough_game_coin"] --"氪石不足"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--操作成功
	if (result == 1) then
		--扣除积分
		if (costScore > 0) then
			--修改添加积分的同时加上来源以便统计
			LuaAddPlayerScoreByWay(-costScore, hVar.GET_SCORE_WAY.UPGRADEPET)
			
			--刷新积分界面
			hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
		end
		
		--更新数据
		local notSaveFlag = true
		local tacticInfo = LuaGetPlayerTacticById(tacticId)
		tacticInfo[2] = level
		tacticInfo[3] = num
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		local keyList = {"card","material"}
		LuaSavePlayerData_Android_Upload(keyList, "战术卡升级")
		
		if (costRmb > 0) then
			--更新客户端游戏币界面
			SendCmdFunc["gamecoin"]()
		end
	end
	
	--触发事件：通知玩家战术卡升级返回结果
	hGlobal.event:event("LocalEvent_TacticLevelUp_Ret", result, tacticId, level, num, costScore, costDebris, costRmb)
end

--收到玩家清除数据结果返回
__Handler[__rh.L2C_REQUIRE_TANK_CLEARDATA_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_CLEARDATA_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	
	--触发事件：通知玩家清除数据结果返回
	hGlobal.event:event("LocalEvent_ClearData_Ret", result)
end

--收到玩家派遣宠物挖矿的结果返回
__Handler[__rh.L2C_REQUIRE_TANK_PET_WAKUANG_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_PET_WAKUANG_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local petId = tonumber(tCmd[2]) or 0		--宠物id
	local wakuang = tonumber(tCmd[3]) or 0		--宠物是否挖矿
	local sendtime = tonumber(tCmd[4]) or 0		--宠物上次派遣时间
	
	--玩家派遣宠物挖矿失败冒字提示
	if (result ~= 1) then
		local strText = "派遣宠物挖矿失败！错误码: " .. result
		
		if (result == -1) then
			strText = hVar.tab_string["__TEXT_PetWaKuangInWork"] --"宠物正在挖矿"
		elseif (result == -2) then
			strText = hVar.tab_string["__TEXT_PetWaTiLiInWork"] --"宠物正在挖体力"
		elseif (result == -3) then
			strText = hVar.tab_string["__TEXT_PetWaKuangUnlock"] --"宠物未解锁挖矿"
		elseif (result == -4) then
			strText = hVar.tab_string["__TEXT_PetWaKuangSendNumMax"] --"派遣宠物数量已达上限"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--操作成功
	if (result == 1) then
		--设置宠物表
		local notSaveFlag = true
		local nPetIdx = LuaGetHeroPetIndexById(hVar.MY_TANK_ID, petId)
		LuaSetHeroPetInWaKuang(hVar.MY_TANK_ID, nPetIdx, wakuang, notSaveFlag)
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		local keyList = {"material"}
		LuaSavePlayerData_Android_Upload(keyList, "宠物挖矿")
	end
	
	--触发事件：通知玩家派遣宠物挖矿结果返回
	hGlobal.event:event("LocalEvent_PetSendWaKuang_Ret", result, petId, wakuang, sendtime)
end

--收到玩家派遣宠物挖体力的结果返回
__Handler[__rh.L2C_REQUIRE_TANK_PET_WATILI_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_PET_WATILI_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local petId = tonumber(tCmd[2]) or 0		--宠物id
	local watili = tonumber(tCmd[3]) or 0		--宠物是否挖体力
	local sendtime = tonumber(tCmd[4]) or 0		--宠物上次派遣时间
	
	--玩家派遣宠物挖矿失败冒字提示
	if (result ~= 1) then
		local strText = "派遣宠物挖体力失败！错误码: " .. result
		
		if (result == -1) then
			strText = hVar.tab_string["__TEXT_PetWaKuangInWork"] --"宠物正在挖矿"
		elseif (result == -2) then
			strText = hVar.tab_string["__TEXT_PetWaTiLiInWork"] --"宠物正在挖体力"
		elseif (result == -3) then
			strText = hVar.tab_string["__TEXT_PetWaKuangUnlock"] --"宠物未解锁挖矿"
		elseif (result == -4) then
			strText = hVar.tab_string["__TEXT_PetWaTiLiInSendNumMax"] --"派遣宠物数量已达上限"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--操作成功
	if (result == 1) then
		--设置宠物表
		local notSaveFlag = true
		local nPetIdx = LuaGetHeroPetIndexById(hVar.MY_TANK_ID, petId)
		LuaSetHeroPetInWaTiLi(hVar.MY_TANK_ID, nPetIdx, watili, notSaveFlag)
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		local keyList = {"material"}
		LuaSavePlayerData_Android_Upload(keyList, "宠物挖体力")
	end
	
	--触发事件：通知玩家派遣宠物挖矿结果返回
	hGlobal.event:event("LocalEvent_PetSendWaTiLi_Ret", result, petId, watili, sendtime)
end

--收到玩家派遣宠物取消挖矿的结果返回
__Handler[__rh.L2C_REQUIRE_TANK_PET_CANCEL_WAKUANG_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_PET_CANCEL_WAKUANG_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local petId = tonumber(tCmd[2]) or 0		--宠物id
	local wakuang = tonumber(tCmd[3]) or 0		--宠物是否挖矿
	
	--玩家派遣宠物挖矿失败冒字提示
	if (result ~= 1) then
		local strText = "取消宠物挖矿失败！错误码: " .. result
		
		if (result == -1) then
			strText = hVar.tab_string["__TEXT_PetWaKuangNotInWork"] --"宠物未在挖矿"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--操作成功
	if (result == 1) then
		--设置宠物表
		local notSaveFlag = true
		local nPetIdx = LuaGetHeroPetIndexById(hVar.MY_TANK_ID, petId)
		LuaSetHeroPetInWaKuang(hVar.MY_TANK_ID, nPetIdx, wakuang, notSaveFlag)
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		local keyList = {"material"}
		LuaSavePlayerData_Android_Upload(keyList, "宠物取消挖矿")
	end
	
	--触发事件：通知玩家取消宠物挖矿结果返回
	hGlobal.event:event("LocalEvent_PetCancelWaKuang_Ret", result, petId, wakuang)
end

--收到玩家派遣宠物取消挖体力的结果返回
__Handler[__rh.L2C_REQUIRE_TANK_PET_CANCEL_WATILI_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_PET_CANCEL_WATILI_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local petId = tonumber(tCmd[2]) or 0		--宠物id
	local watili = tonumber(tCmd[3]) or 0		--宠物是否挖体力
	
	--玩家派遣宠物挖矿失败冒字提示
	if (result ~= 1) then
		local strText = "取消宠物挖体力失败！错误码: " .. result
		
		if (result == -1) then
			strText = hVar.tab_string["__TEXT_PetWaTiLiNotInWork"] --"宠物未在挖体力"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--操作成功
	if (result == 1) then
		--设置宠物表
		local notSaveFlag = true
		local nPetIdx = LuaGetHeroPetIndexById(hVar.MY_TANK_ID, petId)
		LuaSetHeroPetInWaTiLi(hVar.MY_TANK_ID, nPetIdx, watili, notSaveFlag)
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		local keyList = {"material"}
		LuaSavePlayerData_Android_Upload(keyList, "宠物取消挖体力")
	end
	
	--触发事件：通知玩家取消宠物挖体力结果返回
	hGlobal.event:event("LocalEvent_PetCancelWaTiLi_Ret", result, petId, watili)
end

--收到玩家体力产量信息的结果返回
__Handler[__rh.L2C_REQUIRE_TANK_TILI_INFO_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_TILI_INFO_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local tiliDailyMax =  tonumber(tCmd[1]) or 0		--最大体力
	local tiliNow = tonumber(tCmd[2]) or 0			--当前体力
	local tiliDailyBuyCount = tonumber(tCmd[3]) or 0	--今日体力最大可购买次数
	local tiliBuyCount = tonumber(tCmd[4]) or 0		--今日已购买体力次数
	local tiliDailySupply = tonumber(tCmd[5]) or 0		--每日体力补给
	local dailyKeShiExport = tonumber(tCmd[6]) or 0		--氪石每日产出
	local dailyTiLiExport = tonumber(tCmd[7]) or 0		--体力每日产出
	local dailyChestExport = tonumber(tCmd[8]) or 0		--宝箱每日产出
	local keshiExportNow = tonumber(tCmd[9]) or 0		--氪石当前产出
	local tiliExportNow = tonumber(tCmd[10]) or 0		--体力当前产出
	local chestExportNow = tonumber(tCmd[11]) or 0		--宝箱当前产出
	
	--触发事件：通知玩家体力产量信息的结果返回
	hGlobal.event:event("LocalEvent_TiLiInfo_Ret", tiliDailyMax, tiliNow, tiliDailyBuyCount, tiliBuyCount, tiliDailySupply, dailyKeShiExport, dailyTiLiExport, dailyChestExport, keshiExportNow, tiliExportNow, chestExportNow)
end

--收到玩家兑换体力的结果返回
__Handler[__rh.L2C_REQUIRE_TANK_TILI_EXCHANGE_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_TILI_EXCHANGE_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	
	--玩家派遣宠物挖矿失败冒字提示
	if (result ~= 1) then
		local strText = "兑换体力失败！错误码: " .. result
		
		if (result == -1) then
			strText = hVar.tab_string["ios_not_enough_game_coin"] --"氪石不足"
		elseif (result == -2) then
			strText = hVar.tab_string["__TEXT_TodayExchangeCountUsedUp"] --"今日兑换次数已用完！"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	if (result == 1) then
		--发送获取游戏币
		SendCmdFunc["gamecoin"]()
	end
	
	--触发事件：通知玩家兑换体力的结果返回
	hGlobal.event:event("LocalEvent_ExchangeTiLi_Ret", result)
	
end

--收到玩家领取挖矿氪石的结果返回
__Handler[__rh.L2C_REQUIRE_TANK_ADDONES_KESHI_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_ADDONES_KESHI_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local addKeShiNum = tonumber(tCmd[2]) or 0	--增加氪石数量
	
	--玩家领取挖矿氪石失败冒字提示
	if (result ~= 1) then
		local strText = "领取氪石失败！错误码: " .. result
		
		if (result == -1) then
			strText = hVar.tab_string["__TEXT_PetWaKuangNoNum"] --"无可领取氪石"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	if (result == 1) then
		--发送获取游戏币
		SendCmdFunc["gamecoin"]()
	end
	
	--触发事件：通知玩家领取挖矿氪石的结果返回
	hGlobal.event:event("LocalEvent_TakeRewardWaKuang_Ret", result, addKeShiNum)
end

--收到玩家领取挖矿体力的结果返回
__Handler[__rh.L2C_REQUIRE_TANK_ADDONES_TILI_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_ADDONES_TILI_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local addTiLiNum = tonumber(tCmd[2]) or 0	--增加体力数量
	
	--玩家领取挖矿体力失败冒字提示
	if (result ~= 1) then
		local strText = "领取体力失败！错误码: " .. result
		
		if (result == -1) then
			strText = hVar.tab_string["__TEXT_PetWaTiLiNoNum"] --"无可领取体力"
		elseif (result == -2) then
			strText = hVar.tab_string["__TEXT_PetWaTiLiExpierMax"] --"体力已满"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	if (result == 1) then
		--发送获取体力
		SendCmdFunc["get_mycoin"]()
	end
	
	--触发事件：通知玩家领取挖矿氪石的结果返回
	hGlobal.event:event("LocalEvent_TakeRewardWaTiLi_Ret", result, addTiLiNum)
end

--收到玩家领取挖矿宝箱的结果返回
__Handler[__rh.L2C_REQUIRE_TANK_ADDONES_CHEST_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_ADDONES_CHEST_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local addChestNum = tonumber(tCmd[2]) or 0	--增加宝箱数量
	local prizeType = tonumber(tCmd[3]) or 0	--奖励类型
	local prizeId = tonumber(tCmd[4]) or 0		--奖励id
	local maxRewardN = tonumber(tCmd[5]) or 3
	local rewardN = tonumber(tCmd[6])
	local reward = {} --奖励
	
	--玩家领取挖矿体力失败冒字提示
	if (result ~= 1) then
		local strText = "领取宝箱失败！错误码: " .. result
		
		if (result == -1) then
			strText = hVar.tab_string["__TEXT_PetWaTiLiNoNum"] --"无可领取体力"
		elseif (result == -2) then
			strText = hVar.tab_string["__TEXT_PetWaTiLiExpierMax"] --"体力已满"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--领取挖矿宝箱成功，发奖
	if (result == 1) then
		local rewardIdx = 7
		
		for i = 1, rewardN do
			local tmp = {}
			local tRInfo = hApi.Split(tCmd[rewardIdx],":")
			tmp[#tmp + 1] = tRInfo[1]				--奖励类型
			tmp[#tmp + 1] = tRInfo[2]				--参数1
			tmp[#tmp + 1] = tRInfo[3]				--参数2
			tmp[#tmp + 1] = tRInfo[4]				--参数3
			--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
			reward[#reward + 1] = tmp
			rewardIdx = rewardIdx + 1
			
			--如果获得的是4孔神器，发起广播
			local rewardType = tonumber(tRInfo[1]) or 0 --获取类型
			if (rewardType == 10) then --10:神器
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemEntity = tRInfo[3] or ""
				local entity = {}
				local tEntity = hApi.Split(itemEntity,"|")
				
				entity.dbid = tonumber(tEntity[1]) or 0
				entity.typeId = tonumber(tEntity[2]) or 0
				entity.slotnum = tonumber(tEntity[3]) or 0
				entity.attr = {}
				local idx = 3
				for i = 1, entity.slotnum do
					entity.attr[#entity.attr + 1] = tEntity[idx + i]
				end
				
				--[[
				--获得道具
				--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
				if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
					--if (LuaCheckPlayerBagCanUse() ~= 0) then
						--4孔
						if (entity.slotnum == 4) then
							--本地获得4孔神器，上传PVP服务器，请求广播此消息
							local itemId = itemId
							local slotNum = entity.slotnum
							local strInfo = hVar.tab_string["__TEXT_Get1"] --"获得"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
				]]
			end
			
			--[[
			--如果获得的战术卡碎片是一般战术卡类型，并且品质是4级以上，那么广播全服消息获得战术卡
			if (rewardType == 6) then --6:战术卡碎片
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemNum = tonumber(tRInfo[3]) or 0 --奖励数量
				local tacticId = hVar.tab_item[itemId] and hVar.tab_item[itemId].tacticID
				local tabT = hVar.tab_tactics[tacticId] or {}
				local tacticType = tabT.type
				local tacticQuality = tabT.quality or 1
				if (tacticType == hVar.TACTICS_TYPE.OTHER) and (tacticQuality >= 4) then
					--本地获得战术卡碎片，上传PVP服务器，请求广播此消息
					local strInfo = hVar.tab_string["MadelGiftGet"] --"领取"
					---SendPvpCmdFunc["request_broad_get_tacticcard"](rewardType, tacticId, itemNum, strInfo)
					SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.TACTICCARD_DEBRIS, strInfo, tacticId)
				end
			end
			]]
		end
		
		local tag, rewardResult = hApi.GetReawrdGift(reward, rewardN)
		
		--存档
		--领取挖矿宝箱
		local keyList = {"card", "skill", "bag", "material",}
		LuaSavePlayerData_Android_Upload(keyList, "领取挖矿宝箱")
		
		SendCmdFunc["update_reward_log"](prizeId)
		
		--hApi.BubbleGiftAnim(reward, maxRewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		--SendCmdFunc["update_reward_log"](prizeId)
	end
	
	--触发事件：通知玩家领取挖矿宝箱的结果返回
	hGlobal.event:event("LocalEvent_TakeRewardWaChest_Ret", result, addChestNum)
end

-------------------------------------------------------
--!!!! edit by mj 2022.11.21，临时注掉
--收到走马灯冒字结果消息
__Handler[__rh.L2C_REQUIRE_BUBBLE_NOTICE_RET] = function(sCmd)
	-- local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_BUBBLE_NOTICE_RET", sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local tCmd = hApi.Split(sCmd,";")
	local noticeType = tonumber(tCmd[1]) or 0		--冒字类型
	local userName = hApi.StringDecodeEmoji(tCmd[2])	--玩家名
	local noticeInfo = hApi.StringDecodeEmoji(tCmd[3])	--冒字信息
	local itemId = tonumber(tCmd[4]) or 0			--道具id

	--队列冒泡玩家全服广播消息
	if (noticeType > 0) then
		hApi.BubbleQueueArenaMsg(userName, noticeInfo, noticeType, itemId)
	end
end
-------------------------------------------------------

--收到玩家任务（新）的进度返回
__Handler[__rh.L2C_NOTICE_TASK_QUERY_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_NOTICE_TASK_QUERY_RET", sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--21;11:0:0:1;12:0:0:1;14:0:0:1;4:0:0:1;20:0:0:1;21:0:0:10;22:0:0:20;23:0:0:5;19:0:0:10;24:0:0:10;25:0:0:21;26:0:0:31;27:0:0:41;28:0:0:51;29:0:0:61;1001:0:0:20;1002:0:0:20;1003:0:0:20;1004:0:0:20;1005:0:451:1000;1006:0:12:60;
	--1;2;5;11:12:13:14:15:;
	
	local tCmd = hApi.Split(sCmd,";")
	local taskNum = tonumber(tCmd[1]) or 0		--任务数量
	local taskInfo = {}
	local rIdx = 1
	for i = 1, taskNum, 1 do
		local tInfo = hApi.Split(tCmd[rIdx+i], ":")
		local taskId = tonumber(tInfo[1]) or 0 --任务id
		local taskFinishFlag = tonumber(tInfo[2]) or 0 --任务是否完成
		local taskProgress = tonumber(tInfo[3]) or 0 --任务进度
		local taskProgressMax = tonumber(tInfo[4]) or 0 --任务总进度
		
		taskInfo[#taskInfo+1] = {taskId = taskId, taskFinishFlag = taskFinishFlag, taskProgress = taskProgress, taskProgressMax = taskProgressMax,}
	end
	
	--标记是否有已完成的任务
	local flag = 0
	for i = 1, taskNum, 1 do
		local tTask = taskInfo[i]
		local taskProgress = tTask.taskProgress
		local taskProgressMax = tTask.taskProgressMax
		if (taskProgress >= taskProgressMax) then --已完成
			flag = 1
		end
	end
	local notSaveFlag = true
	LuaSetTaskFinishFlag(g_curPlayerName, flag, notSaveFlag)
	
	--夺塔奇兵免费锦囊今日是否有免费次数
	local nFreeChestCount = tonumber(tCmd[taskNum+2]) or 0		--是否有PVP免费锦囊
	--print("nFreeChestCount=", nFreeChestCount)
	
	--活跃度
	local nTaskStone = tonumber(tCmd[taskNum+3]) or 0		--任务之石数量
	
	--周活跃度进度奖励领取情况
	local nWeekRewardNum = tonumber(tCmd[taskNum+4]) or 0		--周奖励已领取数量
	local tWeekRewardInfo = {}
	local tWeekInfo = hApi.Split(tCmd[taskNum+5], ":")
	for i = 1, nWeekRewardNum, 1 do
		local index = tonumber(tWeekInfo[i]) or 0 --任务id
		tWeekRewardInfo[#tWeekRewardInfo+1] = index
	end
	
	--设置玩家夺塔奇兵免费锦囊今日是否可免费
	LuaSetTaskPVPFreeChestFlag(g_curPlayerName, nFreeChestCount)
	
	--触发事件：收到玩家任务（新）列表返回
	hGlobal.event:event("localEvent_OnReceiveTaskNew", taskNum, taskInfo, nTaskStone, nWeekRewardNum, tWeekRewardInfo)
end

--收到玩家完成任务（新）领取奖励返回
__Handler[__rh.L2C_NOTICE_TASK_TAKEREWARD_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_NOTICE_TASK_TAKEREWARD_RET", sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--1;5;16029302;2;1;1:2000:0:0;
	local tCmd = hApi.Split(sCmd,";")
	local result =  tonumber(tCmd[1]) or 0		--结果（1成功 0失败）
	local taskId = tonumber(tCmd[2]) or 0		--任务id
	local prizeId = tonumber(tCmd[3]) or 0		--奖励id
	local maxRewardN = tonumber(tCmd[4]) or 3
	local rewardN = tonumber(tCmd[5])
	local reward = {} --奖励
	
	--print("aid=", aid)
	--print("ptype=", ptype)
	--print("result=", result)
	--print("progress=", progress)
	--print("progressMax=", progressMax)
	--print("info=", info)
	--print("prizeId=", prizeId)
	--print("rewardN=", rewardN)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--领取任务失败冒字提示
	if (result < 0) then
		--冒字
		--local strText = "操作失败！错误码: " .. result
		local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__TEXT_PVP_Operation"], result)
		if (result == -1) then --无效的参数
			strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] --"参数不合法"
		elseif (result == -2) then --任务未完成
			strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_TASK_FINISH"] --"未满足任务完成条件"
		elseif (result == -3) then --无效的任务id
			strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] --"参数不合法"
		elseif (result == -4) then --任务已完成
			strText = hVar.tab_string["_TEXT_TASK_HAVE_FINISHED"] --"该任务已完成！"
		elseif (result == -5) then --未满足领取条件
			strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_TASK_FINISH"] --"未满足任务完成条件"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--领取任务成功，发奖
	if (result == 1) then
		local rewardIdx = 6
		
		for i = 1, rewardN do
			local tmp = {}
			local tRInfo = hApi.Split(tCmd[rewardIdx],":")
			tmp[#tmp + 1] = tRInfo[1]				--奖励类型
			tmp[#tmp + 1] = tRInfo[2]				--参数1
			tmp[#tmp + 1] = tRInfo[3]				--参数2
			tmp[#tmp + 1] = tRInfo[4]				--参数3
			--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
			reward[#reward + 1] = tmp
			rewardIdx = rewardIdx + 1
			
			--如果获得的是4孔神器，发起广播
			local rewardType = tonumber(tRInfo[1]) or 0 --获取类型
			if (rewardType == 10) then --10:神器
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemEntity = tRInfo[3] or ""
				local entity = {}
				local tEntity = hApi.Split(itemEntity,"|")
				
				entity.dbid = tonumber(tEntity[1]) or 0
				entity.typeId = tonumber(tEntity[2]) or 0
				entity.slotnum = tonumber(tEntity[3]) or 0
				entity.attr = {}
				local idx = 3
				for i = 1, entity.slotnum do
					entity.attr[#entity.attr + 1] = tEntity[idx + i]
				end
				
				--获得道具
				--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
				if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
					--if (LuaCheckPlayerBagCanUse() ~= 0) then
						--4孔
						if (entity.slotnum == 4) then
							--本地获得4孔神器，上传PVP服务器，请求广播此消息
							local itemId = itemId
							local slotNum = entity.slotnum
							local strInfo = hVar.tab_string["__TEXT_Task"] .. hVar.tab_string["__TEXT_Get1"] --"任务获得"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
			end
			
			--[[
			--如果获得的战术卡碎片是一般战术卡类型，并且品质是4级以上，那么广播全服消息获得战术卡
			if (rewardType == 6) then --6:战术卡碎片
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemNum = tonumber(tRInfo[3]) or 0 --奖励数量
				local tacticId = hVar.tab_item[itemId] and hVar.tab_item[itemId].tacticID
				local tabT = hVar.tab_tactics[tacticId] or {}
				local tacticType = tabT.type
				local tacticQuality = tabT.quality or 1
				if (tacticType == hVar.TACTICS_TYPE.OTHER) and (tacticQuality >= 4) then
					--本地获得战术卡碎片，上传PVP服务器，请求广播此消息
					local strInfo = hVar.tab_string["__TEXT_Task"] .. hVar.tab_string["__TEXT_Get1"] --"任务获得"
					--SendPvpCmdFunc["request_broad_get_tacticcard"](rewardType, tacticId, itemNum, strInfo)
					SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.TACTICCARD_DEBRIS, strInfo, tacticId)
				end
			end
			]]
		end
		
		local tag, rewardResult = hApi.GetReawrdGift(reward, rewardN)
		
		--hApi.BubbleGiftAnim(reward, maxRewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		SendCmdFunc["update_reward_log"](prizeId)
		
		--存档
		--任务领奖
		local keyList = {"card", "skill", "bag", "material",}
		LuaSavePlayerData_Android_Upload(keyList, "任务领奖")
	end
	
	--触发事件：玩家领取任务（新）档位奖励结果返回
	hGlobal.event:event("localEvent_OnTakeRewardTaskNew", result, taskId, rewardResult)
end

--收到玩家一键领取全部已达成任务（新）的奖励结果返回
__Handler[__rh.L2C_NOTICE_TASK_TAKEREWARD_ALL_RET] = function(sCmd)
	--local sCmd = packet:readString()
	--print("__Handler.L2C_NOTICE_TASK_TAKEREWARD_ALL_RET", sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--1;6;
	--16029310;2;1;1:1000:0:0;
	--16029311;2;1;11:20:0:0;
	--16029312;2;1;7:20:0:0;
	--16029314;2;1;1:2000:0:0;
	--16029315;1;1;3:11026:0:0;
	--16029316;2;1;1:1000:0:0;
	local tCmd = hApi.Split(sCmd,";")
	local result =  tonumber(tCmd[1]) or 0		--结果（1成功 0失败）
	local taskNum = tonumber(tCmd[2]) or 0		--已领奖的任务数量
	local rewardNum = 0
	local reward = {} --奖励
	
	--领取成功，有奖励
	if (result == 1) then
		local rIdx = 3
		for r = 1, taskNum, 1 do
			local prizeId = tonumber(tCmd[rIdx]) or 0		--奖励id
			local maxRewardN = tonumber(tCmd[rIdx+1]) or 3
			local rewardN = tonumber(tCmd[rIdx+2]) or 0 --奖励数量
			
			--为服务器返回日志
			if (prizeId > 0) then
				--local reward = {}
				local rewardIdx = rIdx+3
				
				for i = 1, rewardN do
					local tmp = {}
					local tRInfo = hApi.Split(tCmd[rewardIdx],":")
					tmp[#tmp + 1] = tRInfo[1]				--奖励类型
					tmp[#tmp + 1] = tRInfo[2]				--参数1
					tmp[#tmp + 1] = tRInfo[3]				--参数2
					tmp[#tmp + 1] = tRInfo[4]				--参数3
					--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
					reward[#reward + 1] = tmp
					rewardIdx = rewardIdx + 1
					
					--如果获得的是4孔神器，发起广播
					local rewardType = tonumber(tRInfo[1]) or 0 --获取类型
					if (rewardType == 10) then --10:神器
						local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
						local itemEntity = tRInfo[3] or ""
						local entity = {}
						local tEntity = hApi.Split(itemEntity,"|")
						
						entity.dbid = tonumber(tEntity[1]) or 0
						entity.typeId = tonumber(tEntity[2]) or 0
						entity.slotnum = tonumber(tEntity[3]) or 0
						entity.attr = {}
						local idx = 3
						for i = 1, entity.slotnum do
							entity.attr[#entity.attr + 1] = tEntity[idx + i]
						end
						
						--[[
						--获得道具
						--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
						if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
							--if (LuaCheckPlayerBagCanUse() ~= 0) then
								--4孔
								if (entity.slotnum == 4) then
									--本地获得4孔神器，上传PVP服务器，请求广播此消息
									local itemId = itemId
									local slotNum = entity.slotnum
									local strInfo = hVar.tab_string["__TEXT_Task"] .. hVar.tab_string["__TEXT_Get1"] --"任务获得"
									SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
								end
							--end
						end
						]]
					end
					
					--[[
					--如果获得的战术卡碎片是一般战术卡类型，并且品质是4级以上，那么广播全服消息获得战术卡
					if (rewardType == 6) then --6:战术卡碎片
						local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
						local itemNum = tonumber(tRInfo[3]) or 0 --奖励数量
						local tacticId = hVar.tab_item[itemId] and hVar.tab_item[itemId].tacticID
						local tabT = hVar.tab_tactics[tacticId] or {}
						local tacticType = tabT.type
						local tacticQuality = tabT.quality or 1
						if (tacticType == hVar.TACTICS_TYPE.OTHER) and (tacticQuality >= 4) then
							--本地获得战术卡碎片，上传PVP服务器，请求广播此消息
							local strInfo = hVar.tab_string["__TEXT_Task"] .. hVar.tab_string["__TEXT_Get1"] --"任务获得"
							--SendPvpCmdFunc["request_broad_get_tacticcard"](rewardType, tacticId, itemNum, strInfo)
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.TACTICCARD_DEBRIS, strInfo, tacticId)
						end
					end
					]]
				end
				
				rewardNum = rewardNum + rewardN
				
				--local tag, rewardResult = hApi.GetReawrdGift(reward, maxRewardN)
				
				--hApi.BubbleGiftAnim(reward, maxRewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
				--新的动画表现获得奖励
				--动画在播放完转盘动画后再出，这里先不播放
				--hApi.PlayChestRewardAnimation(0, rewardResult)
				
				SendCmdFunc["update_reward_log"](prizeId)
				--print(tag)
				
				--触发事件：通知使用抽奖结果回调
				--print("触发事件：通知使用抽奖结果回调")
				--hGlobal.event:event("localEvent_TurnChouJiangActivityFinished", aid, ptype, result, iTotalCount, iLeftCount, iFreeCount, iRequireGameCoin, iRequireGameCoinTenth, tProbablity, prizeId, prizeType, prizeIdx, rewardN, rewardResult)
			end
			
			--继续循环
			rIdx = rIdx + 3 + rewardN
		end
		
		--统一发奖
		local tag, rewardResult = hApi.GetReawrdGift(reward, rewardNum)
		
		--hApi.BubbleGiftAnim(reward, maxRewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		--存档
		--任务一键领奖
		local keyList = {"card", "skill", "bag", "material",}
		LuaSavePlayerData_Android_Upload(keyList, "任务一键领奖")
	end
	
	--触发事件：通知一键领取全部已达成任务（新）的奖励结果返回
	--print("触发事件：通知一键领取全部已达成任务（新）的奖励结果返回")
	hGlobal.event:event("localEvent_OnTakeRewardTaskAllNew", result, taskNum, rewardNum, rewardResult)
end

__Handler[__rh.L2C_REQUIRE_PLAYGOPHER_RESULT] = function(sCmd)
	print("L2C_REQUIRE_PLAYGOPHER_RESULT",sCmd)
	--取消挡操作
	hUI.NetDisable(0)

	local tCmd = hApi.Split(sCmd,";")
	local result =  tonumber(tCmd[1]) or 0		--结果（1成功 0失败）

	if result == 1 then
		local diff = tonumber(tCmd[2]) or 0
		hGlobal.event:event("LocalEvent_EnterGopherBoomGame",diff)
	else
		if result == -3 then
			hApi.NotEnoughResource("dishu")
		else
			local strText = hVar.tab_string["request_errcode"] .. tostring(result)
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
		end
	end
end

__Handler[__rh.L2C_REQUIRE_GAMEGOPHER_REWARD] = function(sCmd)
	print("L2C_REQUIRE_GAMEGOPHER_REWARD",sCmd)

	local tCmd = hApi.Split(sCmd,";")
	local result =  tonumber(tCmd[1]) or 0		--结果（1成功 0失败）

	if result == 1 then
		local prizeId = tonumber(tCmd[2]) or 0		--奖励id
		local rewardN = tonumber(tCmd[4])
		
		local reward = {}
		local rewardIdx = 5

		for i = 1, rewardN do
			local tmp = {}
			local tRInfo = hApi.Split(tCmd[rewardIdx],":")
			tmp[#tmp + 1] = tRInfo[1]				--奖励类型
			tmp[#tmp + 1] = tRInfo[2]				--参数1
			tmp[#tmp + 1] = tRInfo[3]				--参数2
			tmp[#tmp + 1] = tRInfo[4]				--参数3
			--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
			reward[#reward + 1] = tmp
			rewardIdx = rewardIdx + 1
		end
		local tag, rewardResult = hApi.GetReawrdGift(reward, rewardN)

		--hApi.PlayChestRewardAnimation(0, rewardResult)
	
		local keyList = {"card", "skill", "bag", "material",}
		LuaSavePlayerData_Android_Upload(keyList, "地鼠游戏奖励")

		SendCmdFunc["get_mycoin"]()
	
		SendCmdFunc["update_reward_log"](prizeId)
		hGlobal.event:event("LocalEvent_GetGameGopherReward",rewardResult)
	else
		if result == -3 then
			hApi.NotEnoughResource("dishu")
		else
			local strText = hVar.tab_string["request_errcode"] .. tostring(result)
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
		end
		hGlobal.event:event("LocalEvent_GetGameGopherReward_fail")
	end
end

--收到玩家领取周任务（新）进度奖励返回结果
__Handler[__rh.L2C_NOTICE_TASK_WEEK_REWARD_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_NOTICE_TASK_WEEK_REWARD_RET", sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--1;5;16029302;2;1;1:2000:0:0;
	local tCmd = hApi.Split(sCmd,";")
	local result =  tonumber(tCmd[1]) or 0		--结果（1成功 0失败）
	local index = tonumber(tCmd[2]) or 0		--周任务奖励索引
	local prizeId = tonumber(tCmd[3]) or 0		--奖励id
	local maxRewardN = tonumber(tCmd[4]) or 3
	local rewardN = tonumber(tCmd[5])
	local reward = {} --奖励
	
	--print("aid=", aid)
	--print("ptype=", ptype)
	--print("result=", result)
	--print("progress=", progress)
	--print("progressMax=", progressMax)
	--print("info=", info)
	--print("prizeId=", prizeId)
	--print("rewardN=", rewardN)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--领取任务失败冒字提示
	if (result < 0) then
		--冒字
		--local strText = "操作失败！错误码: " .. result
		local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__TEXT_PVP_Operation"], result)
		if (result == -1) then --无效的参数
			strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] --"参数不合法"
		elseif (result == -2) then --任务未完成
			strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_TASK_FINISH"] --"未满足任务完成条件"
		elseif (result == -3) then --该奖励已领取
			strText = hVar.tab_string["ios_err_prize_rewarded"] --"奖励已领取"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--领取任务成功，发奖
	if (result == 1) then
		local rewardIdx = 6
		
		for i = 1, rewardN do
			local tmp = {}
			local tRInfo = hApi.Split(tCmd[rewardIdx],":")
			tmp[#tmp + 1] = tRInfo[1]				--奖励类型
			tmp[#tmp + 1] = tRInfo[2]				--参数1
			tmp[#tmp + 1] = tRInfo[3]				--参数2
			tmp[#tmp + 1] = tRInfo[4]				--参数3
			--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
			reward[#reward + 1] = tmp
			rewardIdx = rewardIdx + 1
			
			--如果获得的是4孔神器，发起广播
			local rewardType = tonumber(tRInfo[1]) or 0 --获取类型
			if (rewardType == 10) then --10:神器
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemEntity = tRInfo[3] or ""
				local entity = {}
				local tEntity = hApi.Split(itemEntity,"|")
				
				entity.dbid = tonumber(tEntity[1]) or 0
				entity.typeId = tonumber(tEntity[2]) or 0
				entity.slotnum = tonumber(tEntity[3]) or 0
				entity.attr = {}
				local idx = 3
				for i = 1, entity.slotnum do
					entity.attr[#entity.attr + 1] = tEntity[idx + i]
				end
				
				--获得道具
				--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
				if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
					--if (LuaCheckPlayerBagCanUse() ~= 0) then
						--4孔
						if (entity.slotnum == 4) then
							--本地获得4孔神器，上传PVP服务器，请求广播此消息
							local itemId = itemId
							local slotNum = entity.slotnum
							local strInfo = hVar.tab_string["__TEXT_Task"] .. hVar.tab_string["__TEXT_Get1"] --"任务获得"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
			end
			
			--[[
			--如果获得的战术卡碎片是一般战术卡类型，并且品质是4级以上，那么广播全服消息获得战术卡
			if (rewardType == 6) then --6:战术卡碎片
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemNum = tonumber(tRInfo[3]) or 0 --奖励数量
				local tacticId = hVar.tab_item[itemId] and hVar.tab_item[itemId].tacticID
				local tabT = hVar.tab_tactics[tacticId] or {}
				local tacticType = tabT.type
				local tacticQuality = tabT.quality or 1
				if (tacticType == hVar.TACTICS_TYPE.OTHER) and (tacticQuality >= 4) then
					--本地获得战术卡碎片，上传PVP服务器，请求广播此消息
					local strInfo = hVar.tab_string["__TEXT_Task"] .. hVar.tab_string["__TEXT_Get1"] --"任务获得"
					--SendPvpCmdFunc["request_broad_get_tacticcard"](rewardType, tacticId, itemNum, strInfo)
					SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.TACTICCARD_DEBRIS, strInfo, tacticId)
				end
			end
			]]
		end
		
		local tag, rewardResult = hApi.GetReawrdGift(reward, rewardN)
		
		--hApi.BubbleGiftAnim(reward, maxRewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		SendCmdFunc["update_reward_log"](prizeId)
		
		--存档
		--任务领奖
		local keyList = {"card", "skill", "bag", "material",}
		LuaSavePlayerData_Android_Upload(keyList, "任务领奖")
	end
	
	--触发事件：玩家领取周任务（新）进度奖励结果返回
	hGlobal.event:event("localEvent_OnTakeWeekRewardTaskNew", result, index, rewardResult)
end

--收到玩家领取推荐奖励（新）返回结果
__Handler[__rh.L2C_NOTICE_COMMENT_REWARD_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_NOTICE_COMMENT_REWARD_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	local result =  tonumber(tCmd[1]) or 0		--结果（1成功 0失败）
	
	if (result == 1) then
		--设置评价领取状态
		LuaSetPlayerGiftState(3, 1)
		
		--设置战车点击评价按钮的时间戳
		LuaSetCommentClickTime(os.time())
		
		--刷新主基地评价界面
		hGlobal.event:event("LocalEvent_RefreshDailyRewardUnit")
	end
end

--收到玩家查询特惠装备信息返回结果
__Handler[__rh.L2C_NOTICE_GIFT_EQUIP_INFO_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_NOTICE_GIFT_EQUIP_INFO_RET", sCmd)
	
	--6;10:20211:1:0:1:0:1;10:20204:1:0:5:0:1;10:20214:1:0:10:0:1;10:20216:1:0:20:0:1;10:20307:1:0:50:0:1;10:20319:1:0:50:0:1;
	local tCmd = hApi.Split(sCmd,";")
	local equipNum =  tonumber(tCmd[1]) or 0	--装备数量
	local tEquipInfo = {}
	for i = 1, equipNum do
		local tmp = {}
		local tRInfo = hApi.Split(tCmd[i+1],":")
		local rewardType = tonumber(tRInfo[1]) or 0 --奖励类型
		local rewardId = tonumber(tRInfo[2]) or 0 --奖励id
		local rewardNum = tonumber(tRInfo[3]) or 0 --奖励数量
		local rewardParam4 = tonumber(tRInfo[4]) or 0 --奖励参数4
		local goldCost = tonumber(tRInfo[5]) or 0 --需要的游戏币
		local iCount = tonumber(tRInfo[6]) or 0 --已购买次数
		local maxcount = tonumber(tRInfo[7]) or 1 --最大购买次数
		local reward = {{rewardType, rewardId, rewardNum, rewardParam4,},}
		
		tEquipInfo[#tEquipInfo+1] = {goldCost = goldCost, iCount = iCount, iMaxCount = iMaxCount, reward = reward,}
	end
	
	--触发事件：玩家特惠装备信息返回结果
	hGlobal.event:event("localEvent_OnReceiveGiftEquipInfo_Ret", equipNum, tEquipInfo)
end

--收到玩家购买特惠装备返回结果
__Handler[__rh.L2C_NOTICE_GIFT_EQUIP_BUYITEM_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_NOTICE_GIFT_EQUIP_BUYITEM_RET", sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--1;5;16029302;2;1;1:2000:0:0;
	local tCmd = hApi.Split(sCmd,";")
	local result =  tonumber(tCmd[1]) or 0		--结果（1成功 0失败）
	local shopIdx = tonumber(tCmd[2]) or 0		--购买商品索引
	local prizeId = tonumber(tCmd[3]) or 0		--奖励id
	local maxRewardN = tonumber(tCmd[4]) or 3
	local rewardN = tonumber(tCmd[5])
	local reward = {} --奖励
	
	--print("aid=", aid)
	--print("ptype=", ptype)
	--print("result=", result)
	--print("progress=", progress)
	--print("progressMax=", progressMax)
	--print("info=", info)
	--print("prizeId=", prizeId)
	--print("rewardN=", rewardN)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--购买特惠装备失败冒字提示
	if (result < 0) then
		--冒字
		--local strText = "操作失败！错误码: " .. result
		local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__TEXT_PVP_Operation"], result)
		if (result == -1) then --无效的参数
			strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] --"参数不合法"
		elseif (result == -2) then --商品购买次数已用完
			strText = hVar.tab_string["__TEXT_TodayBuyItemUsedUp"] --"该商品今日购买次数已用完！"
		elseif (result == -3) then --游戏币不足
			strText = hVar.tab_string["ios_not_enough_game_coin"] --"游戏币不足！"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--领取任务成功，发奖
	if (result == 1) then
		local rewardIdx = 6
		
		for i = 1, rewardN do
			local tmp = {}
			local tRInfo = hApi.Split(tCmd[rewardIdx],":")
			tmp[#tmp + 1] = tRInfo[1]				--奖励类型
			tmp[#tmp + 1] = tRInfo[2]				--参数1
			tmp[#tmp + 1] = tRInfo[3]				--参数2
			tmp[#tmp + 1] = tRInfo[4]				--参数3
			--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
			reward[#reward + 1] = tmp
			rewardIdx = rewardIdx + 1
			
			--如果获得的是4孔神器，发起广播
			local rewardType = tonumber(tRInfo[1]) or 0 --获取类型
			if (rewardType == 10) then --10:神器
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemEntity = tRInfo[3] or ""
				local entity = {}
				local tEntity = hApi.Split(itemEntity,"|")
				
				entity.dbid = tonumber(tEntity[1]) or 0
				entity.typeId = tonumber(tEntity[2]) or 0
				entity.slotnum = tonumber(tEntity[3]) or 0
				entity.attr = {}
				local idx = 3
				for i = 1, entity.slotnum do
					entity.attr[#entity.attr + 1] = tEntity[idx + i]
				end
				
				--获得道具
				--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
				if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
					--if (LuaCheckPlayerBagCanUse() ~= 0) then
						--4孔
						if (entity.slotnum == 4) then
							--本地获得4孔神器，上传PVP服务器，请求广播此消息
							local itemId = itemId
							local slotNum = entity.slotnum
							local strInfo = hVar.tab_string["__TEXT_Task"] .. hVar.tab_string["__TEXT_Get1"] --"任务获得"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
			end
			
			--[[
			--如果获得的战术卡碎片是一般战术卡类型，并且品质是4级以上，那么广播全服消息获得战术卡
			if (rewardType == 6) then --6:战术卡碎片
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemNum = tonumber(tRInfo[3]) or 0 --奖励数量
				local tacticId = hVar.tab_item[itemId] and hVar.tab_item[itemId].tacticID
				local tabT = hVar.tab_tactics[tacticId] or {}
				local tacticType = tabT.type
				local tacticQuality = tabT.quality or 1
				if (tacticType == hVar.TACTICS_TYPE.OTHER) and (tacticQuality >= 4) then
					--本地获得战术卡碎片，上传PVP服务器，请求广播此消息
					local strInfo = hVar.tab_string["__TEXT_Task"] .. hVar.tab_string["__TEXT_Get1"] --"任务获得"
					--SendPvpCmdFunc["request_broad_get_tacticcard"](rewardType, tacticId, itemNum, strInfo)
					SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.TACTICCARD_DEBRIS, strInfo, tacticId)
				end
			end
			]]
		end
		
		local tag, rewardResult = hApi.GetReawrdGift(reward, rewardN)
		
		--hApi.BubbleGiftAnim(reward, maxRewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		SendCmdFunc["update_reward_log"](prizeId)
		
		--发送获取游戏币
		SendCmdFunc["gamecoin"]()
		
		--存档
		--购买特惠装备
		local keyList = {"card", "skill", "bag", "material",}
		LuaSavePlayerData_Android_Upload(keyList, "购买特惠装备")
	end
	
	--触发事件：玩家购买特惠装备结果返回
	hGlobal.event:event("localEvent_OnReceiveGiftEquipBuyItem_Ret", result, shopIdx, rewardResult)
end

--收到玩家领取分享奖励返回结果
__Handler[__rh.L2C_NOTICE_SHARE_REWARD_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_NOTICE_SHARE_REWARD_RET", sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local tCmd = hApi.Split(sCmd,";")
	local result =  tonumber(tCmd[1]) or 0		--结果（1成功 0失败）
	local shareCount = tonumber(tCmd[2]) or 0	--已分享的次数
	
	--result: -2:今日领奖次数达到上限
	
	--领取分享奖励成
	if (result == 1) then
		--弹框
		--local strText = 分享成功！" --language
		local strText = hVar.tab_string["__TEXT_Share_Success"] --language
		hGlobal.UI.MsgBox(strText, {
			font = hVar.FONTC,
			ok = function()
			end,
		})
	end
end

--通知新无尽群英阁重抽卡片结果返回
__Handler[__rh.L2C_REQUEST_QUNYINGGE_REDRAWCARD] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	
	--print("__rh.L2C_REQUEST_QUNYINGGE_REDRAWCARD:",sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result = tonumber(tCmd[1]) or 0		--结果
	local orderId = tonumber(tCmd[2]) or 0		--订单号
	local unitId = tonumber(tCmd[3]) or 0		--单位id
	local wave = tonumber(tCmd[4]) or 0		--波次
	
	--领奖失败冒字提示
	if (result ~= 1) then
		--local strText = "重抽一次失败！错误码: " .. result
		local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__RE_EXCHANGE2__"], result)
		
		if (result == -3) then
			--strText = "游戏币不足！" --language
			strText = hVar.tab_string["ios_not_enough_game_coin"] --language
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--触发事件：新无尽群英阁重抽卡片结果返回
	if (result == 1) then --操作成功
		hGlobal.event:event("LocalEvent_QunYingGe_RedrawCard_Ret", result, orderId, unitId, wave)
	end
end

--新玩家14日签到活动，今日是否可以领取奖励
__Handler[__rh.L2C_NOTICE_ACTIVITY_TODAY_STATE] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd,";")
	
	local aid =  tonumber(tCmd[1]) or 0		--活动id
	local ptype =  tonumber(tCmd[2]) or 0		--活动类型
	local result =  tonumber(tCmd[3]) or 0		--结果（1成功 0失败）
	local progress = tonumber(tCmd[4]) or 0		--领取的进度
	local progressMax = tonumber(tCmd[5]) or 0	--领取的进度最大值
	local progressFinidhDay = tonumber(tCmd[6]) or 0--已签到天数
	local buyCount = tonumber(tCmd[7]) or 0		--已领取特惠购买的次数
	local tFlag = hApi.Split(tCmd[8], ":")
	local tBuyFlag = {}
	for i = 1, progressMax, 1 do
		tBuyFlag[i] = 0
	end
	for t = 1, buyCount, 1 do
		local buyday = tonumber(tFlag[t]) or 0
		--print(buyday)
		if (buyday > 0) then
			tBuyFlag[buyday] = 1
		end
	end
	
	--本地标记新玩家14日签到活动的今日可签到的记录
	LuaSetActivitySignInRecord(g_curPlayerName, progress)
	
	--本地存储新玩家14日签到活动的特惠礼包购买记录表
	LuaSetActivitySignInGiftBuy(g_curPlayerName, tBuyFlag)
	
	--新玩家14日签到活动，今日是否可以领取奖励返回
	hGlobal.event:event("localEvent_activity_today_state", aid, ptype, result, progress, progressMax, progressFinidhDay, tBuyFlag)
end

--新玩家14日签到活动，今日签到结果
__Handler[__rh.L2C_NOTICE_ACTIVITY_TODAY_SIGNIN] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd,";")
	
	local aid =  tonumber(tCmd[1]) or 0			--活动id
	local ptype =  tonumber(tCmd[2]) or 0		--活动类型
	local result =  tonumber(tCmd[3]) or 0		--结果（1成功 0失败）
	local progress = tonumber(tCmd[4]) or 0		--领取的进度
	local progressMax = tonumber(tCmd[5]) or 0	--领取的进度最大值
	local info = tostring(tCmd[6])				--结果描述信息
	local prizeType = tonumber(tCmd[7]) or 0	--奖励类型
	local prizeId = tonumber(tCmd[8]) or 0		--奖励id
	local maxRewardN = tonumber(tCmd[9]) or 3
	local rewardN = tonumber(tCmd[10])
	local reward = {} --奖励
	
	--print("aid=", aid)
	--print("ptype=", ptype)
	--print("result=", result)
	--print("progress=", progress)
	--print("progressMax=", progressMax)
	--print("info=", info)
	--print("prizeId=", prizeId)
	--print("rewardN=", rewardN)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--签到失败冒字提示
	if (result < 0) then
		--冒字
		--local strText = "签到失败！错误码: " .. result
		local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__TEXT_SIGNIN"], result)
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--签到成功，发奖
	if (result == 1) then
		local rewardIdx = 11
		
		for i = 1, rewardN do
			local tmp = {}
			local tRInfo = hApi.Split(tCmd[rewardIdx],":")
			tmp[#tmp + 1] = tRInfo[1]				--奖励类型
			tmp[#tmp + 1] = tRInfo[2]				--参数1
			tmp[#tmp + 1] = tRInfo[3]				--参数2
			tmp[#tmp + 1] = tRInfo[4]				--参数3
			--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
			reward[#reward + 1] = tmp
			rewardIdx = rewardIdx + 1
			
			--如果获得的是4孔神器，发起广播
			local rewardType = tonumber(tRInfo[1]) or 0 --获取类型
			if (rewardType == 10) then --10:神器
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemEntity = tRInfo[3] or ""
				local entity = {}
				local tEntity = hApi.Split(itemEntity,"|")
				
				entity.dbid = tonumber(tEntity[1]) or 0
				entity.typeId = tonumber(tEntity[2]) or 0
				entity.slotnum = tonumber(tEntity[3]) or 0
				entity.attr = {}
				local idx = 3
				for i = 1, entity.slotnum do
					entity.attr[#entity.attr + 1] = tEntity[idx + i]
				end
				
				--获得道具
				--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
				if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
					--if (LuaCheckPlayerBagCanUse() ~= 0) then
						--4孔
						if (entity.slotnum == 4) then
							--本地获得4孔神器，上传PVP服务器，请求广播此消息
							local itemId = itemId
							local slotNum = entity.slotnum
							local strInfo = hVar.tab_string["__TEXT_SIGNIN"] .. hVar.tab_string["__TEXT_Get1"] --"签到获得"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
			end
		end
		
		local tag, rewardResult = hApi.GetReawrdGift(reward, rewardN)
		
		--hApi.BubbleGiftAnim(reward, maxRewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		--存档
		--新玩家14日签到
		local keyList = {"card", "skill", "bag", "material",}
		LuaSavePlayerData_Android_Upload(keyList, "新玩家14日签到")
		
		SendCmdFunc["update_reward_log"](prizeId)
		
		--本地标记新玩家14日签到活动的已完成进度
		LuaSetActivitySignInProgress(g_curPlayerName, progress, progressMax)
		
		--本地标记新玩家14日签到活动的今日可签到的记录
		LuaSetActivitySignInRecord(g_curPlayerName, progress)
	end
	
	--新玩家14日签到活动，今日签到结果
	hGlobal.event:event("localEvent_activity_today_signin", aid, ptype, result, progress, progressMax, info, prizeId, prizeType, reward)
end

--新玩家14日签到活动，购买特惠礼包结果
__Handler[__rh.L2C_NOTICE_ACTIVITY_SIGNIN_BUYGIFT] = function(sCmd)
	--local sCmd = packet:readString()
	--print(sCmd)
	--308;10022;1;4;14;3;2;1000;0;5;3:6:9:1:2:;???????;20008;367807;2;1;6:10302:20:0;
	--308;10022;-6;0;14;4;2;0;0;5;3:6:9:1:2:;????????????????;0;
	local tCmd = hApi.Split(sCmd,";")
	
	local aid =  tonumber(tCmd[1]) or 0			--活动id
	local ptype =  tonumber(tCmd[2]) or 0		--活动类型
	local result =  tonumber(tCmd[3]) or 0		--结果（1成功 0失败）
	local progress = tonumber(tCmd[4]) or 0		--领取的进度
	local progressMax = tonumber(tCmd[5]) or 0	--领取的进度最大值
	local progressFinidhDay = tonumber(tCmd[6]) or 0--已签到天数
	local buyGiftDay = tonumber(tCmd[7]) or 0	--购买特惠礼包的天数
	local scoreCost = tonumber(tCmd[8]) or 0	--消耗的积分
	local rmbCost = tonumber(tCmd[9]) or 0		--消耗的游戏币
	local buyCount = tonumber(tCmd[10]) or 0	--已领取特惠购买的次数
	local tFlag = hApi.Split(tCmd[11], ":")
	local tBuyFlag = {}
	for i = 1, progressMax, 1 do
		tBuyFlag[i] = 0
	end
	for t = 1, buyCount, 1 do
		local buyday = tonumber(tFlag[t]) or 0
		--print(buyday)
		if (buyday > 0) then
			tBuyFlag[buyday] = 1
		end
	end
	local info = tostring(tCmd[12])			--结果描述信息
	local prizeType = tonumber(tCmd[13]) or 0	--奖励类型
	local prizeId = tonumber(tCmd[14]) or 0		--奖励id
	local maxRewardN = tonumber(tCmd[15]) or 3
	local rewardN = tonumber(tCmd[16])
	local reward = {} --奖励
	
	--print("aid=", aid)
	--print("ptype=", ptype)
	--print("result=", result)
	--print("progress=", progress)
	--print("progressMax=", progressMax)
	--print("info=", info)
	--print("prizeId=", prizeId)
	--print("rewardN=", rewardN)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--购买礼包失败冒字提示
	if (result < 0) then
		--冒字
		--local strText = "购买失败！错误码: " .. result
		local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__TEXT_GoodsBuy"], result)
		
		--[[
		if (result == -1) then
			strText = "查询失败"
		elseif (result == -2) then
			strText = "无效的活动类型"
		elseif (result == -3) then
			strText = "无效的渠道号"
		elseif (result == -4) then
			strText = "还未解锁特惠礼包"
		elseif (result == -5) then
			strText = "无效的特惠礼包"
		elseif (result == -6) then
			strText = "您已购买过此特惠礼包"
		elseif (result == -7) then
			strText = "游戏币不足"
		elseif (result == -8) then
			strText = "插入奖励失败"
		end
		]]
		if (result == -2) then --"无效的活动类型"
			strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] --"参数不合法"
		elseif (result == -3) then --"无效的渠道号"
			strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] --"参数不合法"
		elseif (result == -4) then --"还未解锁特惠礼包"
			strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_AUTHORITY"] --"您没有权限进行此操作"
		elseif (result == -5) then --"无效的特惠礼包"
			strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] --"参数不合法"
		elseif (result == -6) then --"您已购买过此特惠礼包"
			strText = hVar.tab_string["ios_err_prize_rewarded"] --"奖励已领取"
		elseif (result == -7) then
			strText = hVar.tab_string["ios_not_enough_game_coin"] --"游戏币不足"
		end
		
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--购买礼包成功，发奖
	if (result == 1) then
		local rewardIdx = 17
		
		for i = 1, rewardN do
			local tmp = {}
			local tRInfo = hApi.Split(tCmd[rewardIdx],":")
			tmp[#tmp + 1] = tRInfo[1]				--奖励类型
			tmp[#tmp + 1] = tRInfo[2]				--参数1
			tmp[#tmp + 1] = tRInfo[3]				--参数2
			tmp[#tmp + 1] = tRInfo[4]				--参数3
			--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
			reward[#reward + 1] = tmp
			rewardIdx = rewardIdx + 1
			
			--如果获得的是4孔神器，发起广播
			local rewardType = tonumber(tRInfo[1]) or 0 --获取类型
			if (rewardType == 10) then --10:神器
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemEntity = tRInfo[3] or ""
				local entity = {}
				local tEntity = hApi.Split(itemEntity,"|")
				
				entity.dbid = tonumber(tEntity[1]) or 0
				entity.typeId = tonumber(tEntity[2]) or 0
				entity.slotnum = tonumber(tEntity[3]) or 0
				entity.attr = {}
				local idx = 3
				for i = 1, entity.slotnum do
					entity.attr[#entity.attr + 1] = tEntity[idx + i]
				end
				
				--获得道具
				--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
				if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
					--if (LuaCheckPlayerBagCanUse() ~= 0) then
						--4孔
						if (entity.slotnum == 4) then
							--本地获得4孔神器，上传PVP服务器，请求广播此消息
							local itemId = itemId
							local slotNum = entity.slotnum
							local strInfo = hVar.tab_string["__TEXT_SIGNIN"] .. hVar.tab_string["__TEXT_Get1"] --"签到获得"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
			end
		end
		
		--如果需要消耗积分
		if (scoreCost > 0) then
			LuaAddPlayerScore(-scoreCost)
		end
		
		--如果需要消耗游戏币
		if (rmbCost > 0) then
			--发送获取游戏币
			SendCmdFunc["gamecoin"]()
		end
		
		local tag, rewardResult = hApi.GetReawrdGift(reward, rewardN)
		
		--hApi.BubbleGiftAnim(reward, maxRewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		--存档
		--新玩家签到购买特惠礼包
		local keyList = {"card", "skill", "bag", "material",}
		LuaSavePlayerData_Android_Upload(keyList, "新玩家签到购买特惠礼包")
		
		SendCmdFunc["update_reward_log"](prizeId)
		
		--本地标记新玩家14日签到活动的今日可签到的记录
		LuaSetActivitySignInRecord(g_curPlayerName, progress)
		
		--本地存储新玩家14日签到活动的特惠礼包购买记录表
		LuaSetActivitySignInGiftBuy(g_curPlayerName, tBuyFlag)
	end
	
	--新玩家14日签到活动，购买特惠礼包结果
	hGlobal.event:event("localEvent_activity_signin_buygift", aid, ptype, result, progress, progressMax, progressFinidhDay, buyGiftDay, tBuyFlag, info, prizeId, prizeType, reward)
end

--无尽地图取排行榜前10玩家名返回
__Handler[__rh.L2C_BOARD_ENDLESS_RANK_NAME] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd,";")
	
	local result =  tonumber(tCmd[1]) or 0		--结果（1成功 0失败）
	local rankId =  tonumber(tCmd[2]) or 0		--排行榜类型
	local logId =  tonumber(tCmd[3]) or 0		--leaderboards_check的id
	
	local tNameList = {}		--玩家信息 (成功:玩家名 失败:失败原因 -1查询失败 -2排行榜id不一致 -3未知)
	
	if (result == 1) then --成功
		for i = 4, #tCmd, 1 do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and (tCmd[i] ~= "") then
				tNameList[#tNameList + 1] = hApi.StringDecodeEmoji(tCmd[i]) --玩家名 --还原表情
			end
		end
	end
	
	--print(result, rankId, logId, tNameList)
	
	--无尽地图取排行榜前10玩家名返回
	hGlobal.event:event("localEvent_endless_rank_name", result, rankId, logId, tNameList)
end

--获得无尽地图排行奖励的返回
__Handler[__rh.L2C_QUEST_MAIL_ANNEX_ENDLESS] = function(sCmd)
	--local sCmd = packet:readString()
	--print("__Handler.L2C_QUEST_MAIL_ANNEX_ENDLESS", sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local tCmd = hApi.Split(sCmd,";")
	local prizeId = tonumber(tCmd[1])
	local maxRewardN = tonumber(tCmd[2]) or 3
	local rewardN = tonumber(tCmd[3]) or 0
	
	--为服务器返回日志
	if (prizeId > 0) then
		local reward = {}
		local rewardIdx = 4
		
		for i = 1, rewardN do
			local tmp = {}
			local tRInfo = hApi.Split(tCmd[rewardIdx],":")
			tmp[#tmp + 1] = tRInfo[1]				--奖励类型
			tmp[#tmp + 1] = tRInfo[2]				--参数1
			tmp[#tmp + 1] = tRInfo[3]				--参数2
			tmp[#tmp + 1] = tRInfo[4]				--参数3
			--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
			reward[#reward + 1] = tmp
			rewardIdx = rewardIdx + 1
			
			--如果获得的是4孔神器，发起广播
			local rewardType = tonumber(tRInfo[1]) or 0 --获取类型
			if (rewardType == 10) then --10:神器
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemEntity = tRInfo[3] or ""
				local entity = {}
				local tEntity = hApi.Split(itemEntity,"|")
				
				entity.dbid = tonumber(tEntity[1]) or 0
				entity.typeId = tonumber(tEntity[2]) or 0
				entity.slotnum = tonumber(tEntity[3]) or 0
				entity.attr = {}
				local idx = 3
				for i = 1, entity.slotnum do
					entity.attr[#entity.attr + 1] = tEntity[idx + i]
				end
				
				--获得道具
				--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
				if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
					--if (LuaCheckPlayerBagCanUse() ~= 0) then
						--4孔
						if (entity.slotnum == 4) then
							--本地获得4孔神器，上传PVP服务器，请求广播此消息
							local itemId = itemId
							local slotNum = entity.slotnum
							local strInfo = hVar.tab_string["MadelGiftGet"] --"领取"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
			end
		end
		
		local tag, rewardResult = hApi.GetReawrdGift(reward, maxRewardN)
		
		--hApi.BubbleGiftAnim(reward, maxRewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		SendCmdFunc["update_reward_log"](prizeId)
		--print(tag)
		
		--存档
		--邮箱领奖
		local keyList = {"card", "skill", "bag", "material",}
		LuaSavePlayerData_Android_Upload(keyList, "无尽排行领奖")
		
		--触发事件：通知无尽排行奖励领取完成
		--print("触发事件：通知无尽排行奖励领取完成")
		hGlobal.event:event("localEvent_EndlessRankRewardFinished", prizeId, reward)
		
		--触发事件：领取邮件奖励成功（无尽排名奖励）
		hGlobal.event:event("LocalEvent_OnSystemMailTakeRewardSuccess", prizeId)
	end
end

--通知玩家系统邮件列表（新）
__Handler[__rh.L2C_REQUIRE_SYSTEM_MAIL_LIST_RET] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "","#")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--print("__rh.L2C_REQUIRE_SYSTEM_MAIL_LIST_RET:",sCmd)
	
	local mailNum = tonumber(tCmd[1]) or 0 --邮件数量
	local tMailInfo = {}
	local rIdx = 1
	for i = 1, mailNum, 1 do
		local prizeId = tonumber(tCmd[rIdx+1]) or 0 --邮件id
		local prizeType = tonumber(tCmd[rIdx+2]) or 0 --邮件类型
		local prizeContent = tCmd[rIdx+3] --邮件正文
		local prizeSeconds = tonumber(tCmd[rIdx+4]) or 0 --邮件剩余领取时间（单位：秒）
		--print(prizeId, prizeType, prizeContent, prizeSeconds)
		
		tMailInfo[#tMailInfo+1] = {index = i, prizeId = prizeId, prizeType = prizeType, prizeContent = prizeContent, prizeSeconds = prizeSeconds,}
		
		rIdx = rIdx + 4
	end
	
	--触发事件：收到玩家系统邮件列表（新）返回
	hGlobal.event:event("localEvent_OnReceiveSystemMailList", mailNum, tMailInfo)
	
end

--通知玩家一键领取全部邮件结果返回
__Handler[__rh.L2C_REQUIRE_SYSTEM_MAIL_REWARD_ALL_RET] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	
	--取消挡操作
	hUI.NetDisable(0)
	
	print("__rh.L2C_REQUIRE_SYSTEM_MAIL_REWARD_ALL_RET:",sCmd)
	
	--7;372265;371811;371447;371430;371429;371426;370843;
	--13;13;7:15:0:0;11:50:0:0;1:3500:0:0;5:10202:8:0;23:20:0:0;7:10:0:0;1:200:0:0;3:11209:1:0;7:50:0:0;1:1000:0:0;7:50:0:0;1:500:0:0;1:1200:0:0;
	local mailRewardNum = tonumber(tCmd[1]) or 0 --邮件领取数量
	local tPrizeIdList = {} --已领取邮件的id列表
	local rIdx = 1
	for i = 1, mailRewardNum, 1 do
		local prizeId = tonumber(tCmd[rIdx+1]) or 0 --邮件id
		tPrizeIdList[#tPrizeIdList+1] = prizeId
		SendCmdFunc["update_reward_log"](prizeId)
		
		rIdx = rIdx + 1
	end
	
	local maxRewardN = tonumber(tCmd[mailRewardNum+2]) or 0
	local rewardN = tonumber(tCmd[mailRewardNum+3]) or 0
	
	--为服务器返回日志
	if (maxRewardN > 0) then
		local reward = {}
		local rewardIdx = mailRewardNum+4
		
		for i = 1, rewardN do
			local tmp = {}
			local tRInfo = hApi.Split(tCmd[rewardIdx],":")
			tmp[#tmp + 1] = tRInfo[1]				--奖励类型
			tmp[#tmp + 1] = tRInfo[2]				--参数1
			tmp[#tmp + 1] = tRInfo[3]				--参数2
			tmp[#tmp + 1] = tRInfo[4]				--参数3
			--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
			reward[#reward + 1] = tmp
			rewardIdx = rewardIdx + 1
			
			--如果获得的是4孔神器，发起广播
			local rewardType = tonumber(tRInfo[1]) or 0 --获取类型
			if (rewardType == 10) then --10:神器
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemEntity = tRInfo[3] or ""
				local entity = {}
				local tEntity = hApi.Split(itemEntity,"|")
				
				entity.dbid = tonumber(tEntity[1]) or 0
				entity.typeId = tonumber(tEntity[2]) or 0
				entity.slotnum = tonumber(tEntity[3]) or 0
				entity.attr = {}
				local idx = 3
				for i = 1, entity.slotnum do
					entity.attr[#entity.attr + 1] = tEntity[idx + i]
				end
				
				--[[
				--获得道具
				--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
				if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
					--if (LuaCheckPlayerBagCanUse() ~= 0) then
						--4孔
						if (entity.slotnum == 4) then
							--本地获得4孔神器，上传PVP服务器，请求广播此消息
							local itemId = itemId
							local slotNum = entity.slotnum
							local strInfo = hVar.tab_string["MadelGiftGet"] --"领取"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
				]]
			end
			
			--[[
			--如果获得的战术卡碎片是一般战术卡类型，并且品质是4级以上，那么广播全服消息获得战术卡
			if (rewardType == 6) then --6:战术卡碎片
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemNum = tonumber(tRInfo[3]) or 0 --奖励数量
				local tacticId = hVar.tab_item[itemId] and hVar.tab_item[itemId].tacticID
				local tabT = hVar.tab_tactics[tacticId] or {}
				local tacticType = tabT.type
				local tacticQuality = tabT.quality or 1
				if (tacticType == hVar.TACTICS_TYPE.OTHER) and (tacticQuality >= 4) then
					--本地获得战术卡碎片，上传PVP服务器，请求广播此消息
					local strInfo = hVar.tab_string["MadelGiftGet"] --"领取"
					--SendPvpCmdFunc["request_broad_get_tacticcard"](rewardType, tacticId, itemNum, strInfo)
					SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.TACTICCARD_DEBRIS, strInfo, tacticId)
				end
			end
			]]
		end
		
		local tag, rewardResult = hApi.GetReawrdGift(reward, maxRewardN)
		
		--hApi.BubbleGiftAnim(reward, maxRewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		--SendCmdFunc["update_reward_log"](prizeId)
		--print(tag)
		
		--存档
		--邮箱一键领取
		local keyList = {"card", "skill", "bag", "material",}
		LuaSavePlayerData_Android_Upload(keyList, "邮箱一键领取")
	end
	
	--触发事件：一键领取全部邮件奖励成功（td邮件领奖）
	hGlobal.event:event("LocalEvent_OnSystemMailTakeAllRewardSuccess", mailRewardNum, tPrizeIdList)
end

--通知玩家添加碎片操作结果返回（仅管理员可操作）
__Handler[__rh.L2C_REQUIRE_GM_ADDDEBRIS_RET] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	
	--取消挡操作
	hUI.NetDisable(0)

	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local gamecoinNum = tonumber(tCmd[2]) or 0	--游戏币数量
	local weaponChestNum = tonumber(tCmd[3]) or 0	--武器枪宝箱数量
	local tacticChestNum = tonumber(tCmd[4]) or 0	--战术宝箱数量
	local petChestNum = tonumber(tCmd[5]) or 0	--宠物宝箱数量
	local equipChestNum = tonumber(tCmd[6]) or 0	--装备宝箱数量
	local equipScrollNum = tonumber(tCmd[7]) or 0	--芯片数量
	local tiliNum = tonumber(tCmd[8]) or 0		--体力数量
	local dishucoinNum = tonumber(tCmd[9]) or 0	--地鼠币数量
	
	--获取失败
	if (result <= 0) then
		--冒字
		--local strText = "操作失败！错误码: " .. result
		local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__TEXT_PVP_Operation"], result)
		if (result == -1) then --您没有权限进行此操作
			strText = hVar.tab_string["__TEXT_NoPriority"]
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	if (result == 1) then --成功
		--增加各类宝箱数量
		local notSaveFlag = true
		LuaAddTankWeaponGunChestNum(weaponChestNum, notSaveFlag)
		LuaAddTankTacticChestNum(tacticChestNum, notSaveFlag)
		LuaAddTankPetChestNum(petChestNum, notSaveFlag)
		LuaAddTankEquipChestNum(equipChestNum, notSaveFlag)
		LuaAddTankDiShuCoinNum(dishucoinNum, notSaveFlag)
		
		--设置神器晶石数量（芯片）
		hVar.ROLE_PLAYER_CHIP = equipScrollNum
		
		--动画打开宝箱奖励播放（类似葫芦娃的动画效果）
		local rewardResult =
		{
			{hVar.REWARD_TYPE.ONLINECOIN, weaponChestNum, 0, 0,},
			{hVar.REWARD_TYPE.WEAPONGUN_CHEST, weaponChestNum, 0, 0,},
			{hVar.REWARD_TYPE.TACTIC_CHEST, tacticChestNum, 0, 0,},
			{hVar.REWARD_TYPE.PET_CHEST, petChestNum, 0, 0,},
			{hVar.REWARD_TYPE.EQUIP_CHEST, equipChestNum , 0,},
			{hVar.REWARD_TYPE.CRYSTAL, equipScrollNum , 0,},
			{hVar.REWARD_TYPE.PVPCOIN, tiliNum , 0,},
			{hVar.REWARD_TYPE.DISHU_COIN, dishucoinNum , 0,},
		}
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		--刷新积分界面
		hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
		
		--仓库界面刷新
		hGlobal.event:event("LocalEvent_RefreshChestNum")
		
		--获取我的资源（游戏币、兵符、红装晶石、战功积分）
		SendCmdFunc["get_mycoin"]()
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		--上传存档
		local keyList = {"card", "bag", "skill", "material", }
		LuaSavePlayerData_Android_Upload(keyList, "GM加碎片")
	end
	
	--触发事件：通知玩家宝物属性位值更新结果
	--hGlobal.event:event("LocalEvent_OpenChest_Ret", result, chestId)
end

--收到玩家地图信息返回结果
__Handler[__rh.L2C_REQUIRE_TANK_MAP_INFO_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_MAP_INFO_RET", sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local tCmd = hApi.Split(sCmd,";")
	
	--print("收到玩家地图信息返回结果", uid, rid, rank)
	
	local mapNum = tonumber(tCmd[1]) or 0		--宠物数量
	
	--初始化地图表
	local notSaveFlag = true
	--LuaClearPet(hVar.MY_TANK_ID, notSaveFlag)
	
	local rIdx = 1
	for i = 1, mapNum, 1 do
		local tmp = {}
		local tRInfo = hApi.Split(tCmd[rIdx+i],":")
		local mapName = tostring(tRInfo[1])		--地图名
		local star0 = tonumber(tRInfo[2]) or 0		--普通难度星星
		local star1 = tonumber(tRInfo[3]) or 0		--难度1星星
		local star2 = tonumber(tRInfo[4]) or 0		--难度2星星
		local star3 = tonumber(tRInfo[5]) or 0		--难度3星星
		local passcount = tonumber(tRInfo[6]) or 0	--通关次数
		local battlecount = tonumber(tRInfo[7]) or 0	--挑战次数
		local maxdifficulty = tonumber(tRInfo[8]) or 0	--最大通关难度
		print(mapName, star0, star1, star2, star3, passcount, battlecount, maxdifficulty)
		
		--[[
		if (star > 0) then
			LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.LEVEL, 1, true)
			
			--设置地图表
			if (level == 0) then --普通模式
				LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.MAPSTAR, star, true)
				
				--三星通关
				if (star >= 3) then
					--普通模式记录星星
					LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.Map_Difficult, 1, true)
					LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.IMPERIAL, 0, true)
				else
					LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.Map_Difficult, 0, true)
					LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.IMPERIAL, 0, true)
				end
			elseif (level > 0) then --挑战模式
				LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.MAPSTAR, 3, true)
				LuaSetPlayerMapAchi(mapName,hVar.ACHIEVEMENT_TYPE.Map_Difficult,level,true)
				LuaSetPlayerMapAchi(mapName,hVar.ACHIEVEMENT_TYPE.IMPERIAL,star,true)
				
				--三星通关
				if (star >= 3) then
					if (level < 3) then
						LuaSetPlayerMapAchi(mapName,hVar.ACHIEVEMENT_TYPE.Map_Difficult,level+1,true)
						LuaSetPlayerMapAchi(mapName,hVar.ACHIEVEMENT_TYPE.IMPERIAL,0,true)
					end
				end
			end
		end
		]]
		if (star0 > 0) then
			LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.LEVEL, 1, true)
		else
			LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.LEVEL, 0, true)
		end
		LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.MAPSTAR, star0, true)
		LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.RICHMAN, star1, true)
		LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.BLITZ, star2, true)
		LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.IMPERIAL, star3, true)
		LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.BATTLECOUNT, battlecount, true) --发生过的战斗次数
		LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.Map_Difficult, maxdifficulty, true) --最大通关难度
	end
	
	--存档
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	
	--战车昨日排名结果返回
	--hGlobal.event:event("LocalEvent_OnReceiveTankYesterdayRank", uid, rid, rank)
end

--收到玩家战车复活返回结果
__Handler[__rh.L2C_REQUIRE_TANK_REBIRTH_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_REBIRTH_RET", sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local tCmd = hApi.Split(sCmd,";")
	--print("收到玩家战车复活返回结果", uid, rid, rank)
	
	local result = tonumber(tCmd[1]) or 0		--操作结果（1:成功 0:失败）
	
	--获取失败
	if (result <= 0) then
		--冒字
		--local strText = "操作失败！错误码: " .. result
		local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__TEXT_PVP_Operation"], result)
		if (result == -1) then --体力不足
			strText = hVar.tab_string["__TEXT_NotEnoughTili"] --"体力不足"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	local tiliNow = tonumber(tCmd[2]) or 0		--当前体力
	local battlecfg_id = tonumber(tCmd[3]) or 0	--战斗id
	local scoreCost = tonumber(tCmd[4]) or 0	--消耗的积分
	local tiliCost = tonumber(tCmd[5]) or 0		--消耗的体力
	
	--触发事件：收到玩家战车复活返回结果
	hGlobal.event:event("LocalEvent_OnTankRebirthRet", result, tiliNow, battlecfg_id, scoreCost, tiliCost)
end

--收到查询玩家成就信息的结果返回
__Handler[__rh.L2C_NOTICE_ACHIEVEMENT_QUERY_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_NOTICE_ACHIEVEMENT_QUERY_RET", sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--27;1:1;2:1;3:1;4:0;5:0;6:0;7:0;8:0;9:0;25:0;26:0;27:0;10:0;11:1;12:0;13:0;14:0;15:0;19:0;20:0;21:0;16:0;17:0;18:0;22:1;23:0;24:0;
	local tCmd = hApi.Split(sCmd,";")
	local medalNum = tonumber(tCmd[1]) or 0		--成就数量
	local medelInfo = {}
	local rIdx = 1
	for i = 1, medalNum, 1 do
		local tInfo = hApi.Split(tCmd[rIdx+i], ":")
		local medalId = tonumber(tInfo[1]) or 0 --成就id
		local medalState = tonumber(tInfo[2]) or 0 --服务器成就状态(0:未领取 / 1:已领取)
		if (medalId > 0) then
			local state = LuaGetPlayerMedal(medalId) --客户端成就状态(0:未完成 / 1:已达成 / 2:已领取)
			if (medalState == 0) then --服务器成就未领取
				if (state == 2) then
					local notSaveFlag = true
					LuaSetPlayerMedal(medalId, 0, notSaveFlag)
				end
			elseif (medalState == 1) then --服务器成就已领取
				local notSaveFlag = true
				LuaSetPlayerMedal(medalId, 2, notSaveFlag)
			end
		end
		
		medelInfo[#medelInfo+1] = medalId
	end
	
	--存档
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	
	--触发事件：收到玩家成就列表返回
	hGlobal.event:event("localEvent_OnReceiveAchievementInfo", medalNum, medelInfo)
end

--收到玩家领取成就的结果返回
__Handler[__rh.L2C_NOTICE_ACHIEVEMENT_TAKEREWARD_RET] = function(sCmd)
	--local sCmd = packet:readString()
	--print("__Handler.L2C_NOTICE_ACHIEVEMENT_TAKEREWARD_RET", sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--1;21;16029431;2;2;1:3000:0:0;6:10408:90:0;
	local tCmd = hApi.Split(sCmd,";")
	local result =  tonumber(tCmd[1]) or 0		--结果（1成功 0失败）
	local medalId = tonumber(tCmd[2]) or 0		--成就id
	local prizeId = tonumber(tCmd[3]) or 0		--奖励id
	local maxRewardN = tonumber(tCmd[4]) or 3
	local rewardN = tonumber(tCmd[5])
	local reward = {} --奖励
	
	--print("aid=", aid)
	--print("ptype=", ptype)
	--print("result=", result)
	--print("progress=", progress)
	--print("progressMax=", progressMax)
	--print("info=", info)
	--print("prizeId=", prizeId)
	--print("rewardN=", rewardN)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--领取任务失败冒字提示
	if (result < 0) then
		--冒字
		--local strText = "操作失败！错误码: " .. result
		local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__TEXT_PVP_Operation"], result)
		if (result == -1) then --成就已完成
			strText = hVar.tab_string["_TEXT_ACHIEVEMENT_HAVE_FINISHED"] --"该成就已完成！"
		elseif (result == -2) then --无效的成就id
			strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] --"参数不合法"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--领取成就成功，发奖
	if (result == 1) then
		local rewardIdx = 6
		
		for i = 1, rewardN do
			local tmp = {}
			local tRInfo = hApi.Split(tCmd[rewardIdx],":")
			tmp[#tmp + 1] = tRInfo[1]				--奖励类型
			tmp[#tmp + 1] = tRInfo[2]				--参数1
			tmp[#tmp + 1] = tRInfo[3]				--参数2
			tmp[#tmp + 1] = tRInfo[4]				--参数3
			--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
			reward[#reward + 1] = tmp
			rewardIdx = rewardIdx + 1
			
			--如果获得的是4孔神器，发起广播
			local rewardType = tonumber(tRInfo[1]) or 0 --获取类型
			if (rewardType == 10) then --10:神器
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemEntity = tRInfo[3] or ""
				local entity = {}
				local tEntity = hApi.Split(itemEntity,"|")
				
				entity.dbid = tonumber(tEntity[1]) or 0
				entity.typeId = tonumber(tEntity[2]) or 0
				entity.slotnum = tonumber(tEntity[3]) or 0
				entity.attr = {}
				local idx = 3
				for i = 1, entity.slotnum do
					entity.attr[#entity.attr + 1] = tEntity[idx + i]
				end
				
				--[[
				--获得道具
				--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
				if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
					--if (LuaCheckPlayerBagCanUse() ~= 0) then
						--4孔
						if (entity.slotnum == 4) then
							--本地获得4孔神器，上传PVP服务器，请求广播此消息
							local itemId = itemId
							local slotNum = entity.slotnum
							local strInfo = hVar.tab_string["__ITEM_PANEL__PAGE_ACHIEVEMENT"] --"完成成就获得"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
				]]
			end
			
			--[[
			--如果获得的战术卡碎片是一般战术卡类型，并且品质是4级以上，那么广播全服消息获得战术卡
			if (rewardType == 6) then --6:战术卡碎片
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemNum = tonumber(tRInfo[3]) or 0 --奖励数量
				local tacticId = hVar.tab_item[itemId] and hVar.tab_item[itemId].tacticID
				local tabT = hVar.tab_tactics[tacticId] or {}
				local tacticType = tabT.type
				local tacticQuality = tabT.quality or 1
				if (tacticType == hVar.TACTICS_TYPE.OTHER) and (tacticQuality >= 4) then
					--本地获得战术卡碎片，上传PVP服务器，请求广播此消息
					local strInfo = hVar.tab_string["__ITEM_PANEL__PAGE_ACHIEVEMENT"] --"完成成就获得"
					--SendPvpCmdFunc["request_broad_get_tacticcard"](rewardType, tacticId, itemNum, strInfo)
					SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.TACTICCARD_DEBRIS, strInfo, tacticId)
				end
			end
			]]
		end
		
		local tag, rewardResult = hApi.GetReawrdGift(reward, rewardN)
		
		--hApi.BubbleGiftAnim(reward, maxRewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		SendCmdFunc["update_reward_log"](prizeId)
		
		--设置本成就的状态为已领取
		LuaSetPlayerMedal(medalId, 2) --(0:未完成 / 1:已达成 / 2:已领取)
		
		--获得成就点
		local tabAchievement = hVar.tab_medal[medalId]
		local ap = tabAchievement.ap or 0
		LuaAddPlayerCountVal(hVar.MEDAL_TYPE.apNum, ap)
		
		
		--标记主城引导任务成就界面完成
		LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 3)
		
		--存档
		--成就领奖
		local keyList = {"card", "skill", "bag", "material",}
		LuaSavePlayerData_Android_Upload(keyList, "成就领奖")
	end
	
	--触发事件：玩家领取成就奖励结果返回
	hGlobal.event:event("localEvent_OnTakeRewardAchievement", result, medalId, rewardResult)
end

--收到玩家地图结束奖励返回结果
__Handler[__rh.L2C_REQUIRE_TANK_MAP_FINISH_REWARD_RET] = function(sCmd)
	--local sCmd = packet:readString()
	print("__Handler.L2C_REQUIRE_TANK_MAP_FINISH_REWARD_RET", sCmd)
	
	local tCmd = hApi.Split(sCmd,";")
	
	local mapName = tostring(tCmd[1])		--地图名
	local star0 = tonumber(tCmd[2]) or 0		--普通难度星星
	local star1 = tonumber(tCmd[3]) or 0		--难度1星星
	local star2 = tonumber(tCmd[4]) or 0		--难度2星星
	local star3 = tonumber(tCmd[5]) or 0		--难度3星星
	local passcount = tonumber(tCmd[6]) or 0	--通关次数
	local battlecount = tonumber(tCmd[7]) or 0	--挑战次数
	local maxdifficulty = tonumber(tCmd[8]) or 0	--最大通关难度
	
	if (star0 > 0) then
		LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.LEVEL, 1, true)
	else
		LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.LEVEL, 0, true)
	end
	LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.MAPSTAR, star0, true)
	LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.RICHMAN, star1, true)
	LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.BLITZ, star2, true)
	LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.IMPERIAL, star3, true)
	LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.BATTLECOUNT, battlecount, true) --发生过的战斗次数
	LuaSetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.Map_Difficult, maxdifficulty, true) --最大通关难度
	
	local reward = {}
	local rewardN = tonumber(tCmd[9])	--奖励数量
	
	if (rewardN > 0) then
		local rewardIdx = 10
		
		for i = 1, rewardN do
			local tmp = {}
			local tRInfo = hApi.Split(tCmd[rewardIdx],":")
			tmp[#tmp + 1] = tRInfo[1]				--奖励类型
			tmp[#tmp + 1] = tRInfo[2]				--参数1
			tmp[#tmp + 1] = tRInfo[3]				--参数2
			tmp[#tmp + 1] = tRInfo[4]				--参数3
			--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
			reward[#reward + 1] = tmp
			rewardIdx = rewardIdx + 1
			
			--如果获得的是4孔神器，发起广播
			local rewardType = tonumber(tRInfo[1]) or 0 --获取类型
			if (rewardType == 10) then --10:神器
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemEntity = tRInfo[3] or ""
				local entity = {}
				local tEntity = hApi.Split(itemEntity,"|")
				
				--28922|20205|0||0|2|11|12|21|22|31|32|41|42|51|52|61|62|71|72|81|82:0
				entity.dbid = tonumber(tEntity[1]) or 0
				entity.typeId = tonumber(tEntity[2]) or 0
				entity.slotnum = tonumber(tEntity[3]) or 0
				entity.attr = {}
				local idx = 3
				for i = 1, entity.slotnum do
					entity.attr[#entity.attr + 1] = tEntity[idx + i]
				end
				
				idx = idx + entity.slotnum + 1
				
				entity.CUnique = tonumber(tEntity[idx+1]) or 0
				entity.quality = tonumber(tEntity[idx+2]) or 0
				entity.randIdx1 = tonumber(tEntity[idx+3]) or 0 --随机属性索引1
				entity.randVal1 = tonumber(tEntity[idx+4]) or 0 --随机属性值1
				entity.randIdx2 = tonumber(tEntity[idx+5]) or 0 --随机属性索引2
				entity.randVal2 = tonumber(tEntity[idx+6]) or 0 --随机属性值2
				entity.randIdx3 = tonumber(tEntity[idx+7]) or 0 --随机属性索引3
				entity.randVal3 = tonumber(tEntity[idx+8]) or 0 --随机属性值3
				entity.randIdx4 = tonumber(tEntity[idx+9]) or 0 --随机属性索引4
				entity.randVal4 = tonumber(tEntity[idx+10]) or 0 --随机属性值4
				entity.randIdx5 = tonumber(tEntity[idx+11]) or 0 --随机属性索引5
				entity.randVal5 = tonumber(tEntity[idx+12]) or 0 --随机属性值5
				entity.randSkillIdx1 = tonumber(tEntity[idx+13]) or 0 --随机技能索引1
				entity.randSkillLv1 = tonumber(tEntity[idx+14]) or 0 --随机技能等级1
				entity.randSkillIdx2 = tonumber(tEntity[idx+15]) or 0 --随机技能索引2
				entity.randSkillLv2 = tonumber(tEntity[idx+16]) or 0 --随机技能等级2
				entity.randSkillIdx3 = tonumber(tEntity[idx+17]) or 0 --随机技能索引3
				entity.randSkillLv3 = tonumber(tEntity[idx+18]) or 0 --随机技能等级3
				
				--[[
				--获得道具
				--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
				if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
					--if (LuaCheckPlayerBagCanUse() ~= 0) then
						--4孔
						if (entity.slotnum == 4) then
							--本地获得4孔神器，上传PVP服务器，请求广播此消息
							local itemId = itemId
							local slotNum = entity.slotnum
							local strInfo = hVar.tab_string["MadelGiftGet"] --"领取"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
				]]
			end
			
			--[[
			--如果获得的战术卡碎片是一般战术卡类型，并且品质是4级以上，那么广播全服消息获得战术卡
			if (rewardType == 6) then --6:战术卡碎片
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemNum = tonumber(tRInfo[3]) or 0 --奖励数量
				local tacticId = hVar.tab_item[itemId] and hVar.tab_item[itemId].tacticID
				local tabT = hVar.tab_tactics[tacticId] or {}
				local tacticType = tabT.type
				local tacticQuality = tabT.quality or 1
				if (tacticType == hVar.TACTICS_TYPE.OTHER) and (tacticQuality >= 4) then
					--本地获得战术卡碎片，上传PVP服务器，请求广播此消息
					local strInfo = hVar.tab_string["MadelGiftGet"] --"领取"
					---SendPvpCmdFunc["request_broad_get_tacticcard"](rewardType, tacticId, itemNum, strInfo)
					SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.TACTICCARD_DEBRIS, strInfo, tacticId)
				end
			end
			]]
		end
		
		local tag, rewardResult = hApi.GetReawrdGift(reward, rewardN)
		
		SendCmdFunc["update_reward_log"](prizeId)
		
		--hApi.BubbleGiftAnim(reward, maxRewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		--hApi.PlayChestRewardAnimation(0, rewardResult)
		
		--SendCmdFunc["update_reward_log"](prizeId)
	else
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
	
	--存档
	--地图结束奖励
	local keyList = {"card", "skill", "bag", "map", "material",}
	LuaSavePlayerData_Android_Upload(keyList, "地图结束奖励")
	
	--收到玩家地图结束奖励返回结果
	hGlobal.event:event("LocalEvent_OnReceiveTankMapFinishReward", rewardN, reward)
end

--通知上传战斗结果返回
__Handler[__rh.L2C_REQUIRE_SEND_GAMEEND_INFO_RET] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	print("__Handler.L2C_REQUIRE_SEND_GAMEEND_INFO_RET", sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result = tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local tankId = tonumber(tCmd[2]) or 0		--使用的战车id
	local mapName = tCmd[3]				--地图名
	local nExpAdd =  tonumber(tCmd[4]) or 0		--经验值
	local nScientistNum =  tonumber(tCmd[5]) or 0	--增加的科学家次数
	local nTankDeadthNum =  tonumber(tCmd[6]) or 0	--增加的战车死亡次数
	
	--操作成功
	if (result == 1) then
		--增加经验值
		LuaAddHeroExp(tankId, nExpAdd)
		LuaAddTankScientistNum(nScientistNum)
		LuaAddTankDeadthNum(nTankDeadthNum)
	end
	
	--收到玩家上传战斗结果返回结果
	hGlobal.event:event("LocalEvent_OnSendGameEndInfoRet", result, tankId, mapName, nExpAdd, nScientistNum, nTankDeadthNum)
end

--通知GM指令-加资源返回结果
__Handler[__rh.L2C_REQUIRE_GM_ADD_RESOURCE_RET] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	--print(sCmd)
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local score = tonumber(tCmd[2]) or 0		--积分
	local prizeType = tonumber(tCmd[3]) or 0	--奖励类型
	local prizeId = tonumber(tCmd[4]) or 0		--奖励id
	local maxRewardN = tonumber(tCmd[5]) or 3
	local rewardN = tonumber(tCmd[6])
	local reward = {} --奖励
	
	if (result <= 0) then
		--冒字
		--local strText = "操作失败！错误码: " .. result
		local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__TEXT_PVP_Operation"], result)
		if (result == -1) then
			strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_AUTHORITY"] --"您没有权限进行此操作"
		end
		
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--GM指令成功，发奖
	if (result == 1) then
		local rewardIdx = 7
		
		for i = 1, rewardN do
			local tmp = {}
			local tRInfo = hApi.Split(tCmd[rewardIdx],":")
			tmp[#tmp + 1] = tRInfo[1]				--奖励类型
			tmp[#tmp + 1] = tRInfo[2]				--参数1
			tmp[#tmp + 1] = tRInfo[3]				--参数2
			tmp[#tmp + 1] = tRInfo[4]				--参数3
			--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
			reward[#reward + 1] = tmp
			rewardIdx = rewardIdx + 1
			
			--如果获得的是4孔神器，发起广播
			local rewardType = tonumber(tRInfo[1]) or 0 --获取类型
			if (rewardType == 10) then --10:神器
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemEntity = tRInfo[3] or ""
				local entity = {}
				local tEntity = hApi.Split(itemEntity,"|")
				
				entity.dbid = tonumber(tEntity[1]) or 0
				entity.typeId = tonumber(tEntity[2]) or 0
				entity.slotnum = tonumber(tEntity[3]) or 0
				entity.attr = {}
				local idx = 3
				for i = 1, entity.slotnum do
					entity.attr[#entity.attr + 1] = tEntity[idx + i]
				end
				
				
				--获得道具
				--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
				if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
					--if (LuaCheckPlayerBagCanUse() ~= 0) then
						--4孔
						if (entity.slotnum == 4) then
							--本地获得4孔神器，上传PVP服务器，请求广播此消息
							local itemId = itemId
							local slotNum = entity.slotnum
							local strInfo = hVar.tab_string["__TEXT_Get1"] --"获得"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
				
			end
			
			--[[
			--如果获得的战术卡碎片是一般战术卡类型，并且品质是4级以上，那么广播全服消息获得战术卡
			if (rewardType == 6) then --6:战术卡碎片
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemNum = tonumber(tRInfo[3]) or 0 --奖励数量
				local tacticId = hVar.tab_item[itemId] and hVar.tab_item[itemId].tacticID
				local tabT = hVar.tab_tactics[tacticId] or {}
				local tacticType = tabT.type
				local tacticQuality = tabT.quality or 1
				if (tacticType == hVar.TACTICS_TYPE.OTHER) and (tacticQuality >= 4) then
					--本地获得战术卡碎片，上传PVP服务器，请求广播此消息
					local strInfo = hVar.tab_string["MadelGiftGet"] --"领取"
					---SendPvpCmdFunc["request_broad_get_tacticcard"](rewardType, tacticId, itemNum, strInfo)
					SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.TACTICCARD_DEBRIS, strInfo, tacticId)
				end
			end
			]]
		end
		
		local tag, rewardResult = hApi.GetReawrdGift(reward, rewardN)
		
		--存档
		--GM指令
		local keyList = {"card", "skill", "bag", "material",}
		LuaSavePlayerData_Android_Upload(keyList, "GM指令")
		
		SendCmdFunc["update_reward_log"](prizeId)
		
		--hApi.BubbleGiftAnim(reward, maxRewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		--SendCmdFunc["update_reward_log"](prizeId)
	end
end

--通知GM指令-地图全通返回结果
__Handler[__rh.L2C_REQUIRE_GM_MAP_FINISH_RET] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	--print(sCmd)
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	
	if (result <= 0) then
		--冒字
		--local strText = "操作失败！错误码: " .. result
		local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__TEXT_PVP_Operation"], result)
		if (result == -1) then
			strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_AUTHORITY"] --"您没有权限进行此操作"
		end
		
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--GM指令成功，地图全通
	if (result == 1) then
		--地图全通
		for c = 1, #hVar.tab_chapter, 1 do
			local tabChapter = hVar.tab_chapter[c]
			local firstmap = tabChapter.firstmap --第一关
			local lastmap = tabChapter.lastmap --最后一关
			local currentmap = firstmap
			while true do
				--通关
				local tabM = hVar.MAP_INFO[currentmap]
				--print(currentmap)
				LuaSetPlayerMapAchi(currentmap, hVar.ACHIEVEMENT_TYPE.LEVEL, 1, true)
				
				--更新通关信息及星级信息
				local starV = 3
				local star = (LuaGetPlayerMapAchi(currentmap,hVar.ACHIEVEMENT_TYPE.MAPSTAR) or 0)
				
				--如果存档中的星级小于当前获得的星级，则需要刷新数据
				if star < starV then
					LuaSetPlayerMapAchi(currentmap,hVar.ACHIEVEMENT_TYPE.MAPSTAR, starV,true)
					
					if starV >= 3 then
						LuaSetPlayerMapAchi(currentmap,hVar.ACHIEVEMENT_TYPE.Map_Difficult,1,true)
						LuaSetPlayerMapAchi(currentmap,hVar.ACHIEVEMENT_TYPE.IMPERIAL,0,true)
					end
					
					--统计普通关卡得星
					LuaAddPlayerCountVal(hVar.MEDAL_TYPE.starCount, starV - star)
					LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.starCount, starV - star)
				end
				
				--统计开始
				if starV >= 3 then
					--统计关卡满星通关次数
					LuaAddPlayerCountVal(hVar.MEDAL_TYPE.allStar)
					LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.allStar)
					
					--统计普通关卡满星通关次数
					LuaAddPlayerCountVal(hVar.MEDAL_TYPE.allStarNormal)
					LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.allStarNormal)
				end
				
				--通关统计
				LuaAddPlayerCountVal(hVar.MEDAL_TYPE.gameTimesNormal)
				LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.gameTimesNormal)
				
				local nextmap = tabM.nextmap[1]
				if (nextmap == currentmap) or (nextmap == nil) then
					break
				end
				
				currentmap = nextmap
			end
		end
		
		--音效
		hApi.PlaySound("getcard")
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		--存档
		--GM指令
		local keyList = {"map",}
		LuaSavePlayerData_Android_Upload(keyList, "GM指令")
		
		--弹框
		--local strText = 地图全通关" --language
		local strText = hVar.tab_string["__TEXT_BTN_PASSALL"] --language
		hGlobal.UI.MsgBox(strText, {
			font = hVar.FONTC,
			ok = function()
			end,
		})
	end
end

--通知GM指令-加全部英雄经验返回结果
__Handler[__rh.L2C_REQUIRE_GM_ADD_HEROEXP_ALL] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	--print(sCmd)
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	
	if (result <= 0) then
		--冒字
		--local strText = "操作失败！错误码: " .. result
		local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__TEXT_PVP_Operation"], result)
		if (result == -1) then
			strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_AUTHORITY"] --"您没有权限进行此操作"
		end
		
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--GM指令成功，加全部英雄经验
	if (result == 1) then
		--加全部英雄经验
		if Save_PlayerData and Save_PlayerData.herocard then
			for i = 1, #Save_PlayerData.herocard, 1 do
				local oHero = Save_PlayerData.herocard[i]
				local id = oHero.id
				LuaAddHeroExp(id, 9999999)
				
				--技能等级加满
				local maxStarLv = hVar.HERO_STAR_INFO.maxStarLv --最高星级
				local star = math.min(oHero.attr.star, maxStarLv)
				local soulstone = oHero.attr.soulstone
				local starInfo = hVar.HERO_STAR_INFO[id][star] or {}
				local costSoulStone = starInfo.costSoulStone or 1 --升至下一级需要将魂数量
				local maxLv = starInfo.maxLv or 10 --最大等级
				local unlockSkillNum = starInfo.unlockSkillNum or 1 --解锁技能数量
				
				--战术技能
				local tactic = oHero.tactic
				local unlockTacticNum = 1
				for i = 1, unlockTacticNum, 1 do
					if tactic[i] then
						tactic[i].lv = maxLv
					end
				end
				
				--天赋技能
				local talent = oHero.talent
				for i = 1, unlockSkillNum, 1 do
					if talent[i] then
						talent[i].lv = maxLv
					end
				end
			end
		end
		
		--音效
		hApi.PlaySound("level_up")
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		--存档
		--GM指令
		local keyList = {"card",}
		LuaSavePlayerData_Android_Upload(keyList, "GM指令")
		
		--弹框
		--local strText = 英雄等级全满" --language
		local strText = hVar.tab_string["__TEXT_BTN_HEROEXPALL"] --language
		hGlobal.UI.MsgBox(strText, {
			font = hVar.FONTC,
			ok = function()
			end,
		})
	end
end

--通知新手图加红装返回
__Handler[__rh.L2C_REQUIRE_GUIDE_ADD_REDEQUOP_RET] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	--print(sCmd)
	--取消挡操作
	hUI.NetDisable(0)
	
	local prizeId = tonumber(tCmd[1]) or 0		--奖励id
	local maxRewardN = tonumber(tCmd[2]) or 3
	local rewardN = tonumber(tCmd[3])
	local reward = {} --奖励
	
	--发红装奖励
	local rewardIdx = 4
	
	for i = 1, rewardN do
		local tmp = {}
		local tRInfo = hApi.Split(tCmd[rewardIdx],":")
		tmp[#tmp + 1] = tRInfo[1]				--奖励类型
		tmp[#tmp + 1] = tRInfo[2]				--参数1
		tmp[#tmp + 1] = tRInfo[3]				--参数2
		tmp[#tmp + 1] = tRInfo[4]				--参数3
		--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
		reward[#reward + 1] = tmp
		rewardIdx = rewardIdx + 1
		
		--如果获得的是4孔神器，发起广播
		local rewardType = tonumber(tRInfo[1]) or 0 --获取类型
		if (rewardType == 10) then --10:神器
			local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
			local itemEntity = tRInfo[3] or ""
			local entity = {}
			local tEntity = hApi.Split(itemEntity,"|")
			
			entity.dbid = tonumber(tEntity[1]) or 0
			entity.typeId = tonumber(tEntity[2]) or 0
			entity.slotnum = tonumber(tEntity[3]) or 0
			entity.attr = {}
			local idx = 3
			for i = 1, entity.slotnum do
				entity.attr[#entity.attr + 1] = tEntity[idx + i]
			end
			
			--[[
			--获得道具
			--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
			if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
				--if (LuaCheckPlayerBagCanUse() ~= 0) then
					--4孔
					if (entity.slotnum == 4) then
						--本地获得4孔神器，上传PVP服务器，请求广播此消息
						local itemId = itemId
						local slotNum = entity.slotnum
						local strInfo = hVar.tab_string["__TEXT_Get1"] --"获得"
						SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
					end
				--end
			end
			]]
		end
	end
	
	local tag, rewardResult = hApi.GetReawrdGift(reward, rewardN)
	
	--存档
	--新手图发红装
	--local keyList = {"card", "skill", "bag", "material",}
	--LuaSavePlayerData_Android_Upload(keyList, "新手图发红装")
	
	SendCmdFunc["update_reward_log"](prizeId)
	
	--hApi.BubbleGiftAnim(reward, maxRewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
	--新的动画表现获得奖励
	--hApi.PlayChestRewardAnimation(0, rewardResult)
	
	--SendCmdFunc["update_reward_log"](prizeId)
	
	hApi.addTimerOnce("__GuideAddRedEquuip_Timer", 1000,function()
		for i = 1, rewardN do
			--装备装备到战车身上
			local tPos1 = {"storehouse",i}
			MoveEquipManager.RecordPos1(tPos1)
			local tPos2 = {"hero",hVar.MY_TANK_ID,i}
			MoveEquipManager.RecordPos2(tPos2)
			MoveEquipManager.MoveEquip()
		end
	end)
end


















------------------------------------------------------------------------------------------------------------
--通知玩家宝物信息返回结果
__Handler[__rh.L2C_REQUIRE_TREASURE_INFO] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	
	print("__rh.L2C_REQUIRE_TREASURE_INFO:",sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--解析宝物表
	local cangbaotuNum = tonumber(tCmd[1]) or 0		--藏宝图数量
	local cangbaotuHighNum = tonumber(tCmd[2]) or 0		--高级藏宝图数量
	local treasureNum = tonumber(tCmd[3]) or 0		--宝物数量
	--print("treasureNum=", treasureNum)
	
	--存储
	g_cangbaotu_normal_num = cangbaotuNum
	g_cangbaotu_high_num = cangbaotuHighNum
	
	--初始化宝物表
	local notSaveFlag = true
	LuaClearTreasureBook(notSaveFlag)
	
	local rIdx = 3
	for i = 1, treasureNum, 1 do
		local tmp = {}
		local tRInfo = hApi.Split(tCmd[rIdx+i],":")
		local id = tonumber(tRInfo[1]) or 0	--宝物id
		local lv = tonumber(tRInfo[2]) or 0	--宝物lv
		local num = tonumber(tRInfo[3]) or 0	--宝物num
		--print(id, lv, num)
		
		--设置宝物表
		LuaSetTreasureBook (id, lv, num, notSaveFlag)
	end
	
	--解析宝物属性位值表
	rIdx = treasureNum + 4
	local treasureAttrNum = tonumber(tCmd[rIdx]) or 0	--宝物属性位数量
	--print("treasureAttrNum=", treasureAttrNum)
	--初始化宝物属性位值表
	LuaClearTreasureAttr(notSaveFlag)
	
	for i = 1, treasureAttrNum, 1 do
		local attrValue = tonumber(tCmd[rIdx+i]) or 0	--属性位值
		--print(i, attrValue)
		
		--设置宝物属性位值
		LuaSetTreasureAttr(i, attrValue, notSaveFlag)
	end
	
	--存档
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	
	--触发事件：通知玩家宝物信息返回结果
	hGlobal.event:event("LocalEvent_TreasureInfo_Ret", cangbaotuNum, cangbaotuHighNum)
end

--通知玩家宝物升星返回结果
__Handler[__rh.L2C_UPDATE_TREASURE_STARUP] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	--print("__rh.L2C_UPDATE_TREASURE_STARUP:",sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local treasureId = tonumber(tCmd[2]) or 0	--宝物id
	local star = tonumber(tCmd[3]) or 0		--星级
	local num = tonumber(tCmd[4]) or 0		--碎片数量
	local costScore = tonumber(tCmd[5]) or 0	--消耗的积分
	
	--升星失败冒字提示
	if (result ~= 1) then
		local strText = "宝物升星！错误码: " .. result
		
		if (result == -1) then
			strText = hVar.tab_string["__UPGRADEBFSTAR_CANT"] --"已升到最大星级"
		elseif (result == -2) then
			strText = hVar.tab_string["__TEXT_DebrisNotEnough"] --"碎片不足"
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--操作成功
	if (result == 1) then
		--扣除积分
		LuaAddPlayerScore(-costScore)
		
		--更新数据
		LuaSetTreasureBook(treasureId, star, num)
		
		--本地宝物升星，上传PVP服务器，请求广播此消息
		SendPvpCmdFunc["request_treasure_starup"](treasureId, star)
	end
	
	--触发事件：通知玩家宝物升星返回结果
	hGlobal.event:event("LocalEvent_TreasureStarUp_Ret", result, treasureId, star, num, costScore)
end

--通知玩家上传宝物属性位值信息返回结果
__Handler[__rh.L2C_UPLOAD_TREASURE_ATTR_INFO] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	
	--print("__rh.L2C_UPLOAD_TREASURE_ATTR_INFO:",sCmd)
	
	--解析宝物属性位值表
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local treasureAttrNum = tonumber(tCmd[2]) or 0	--宝物属性位数量
	--print("treasureAttrNum=", treasureAttrNum)
	
	if (result == 1) then --成功
		--初始化宝物属性位值表
		LuaClearTreasureAttr(notSaveFlag)
		
		local tRInfo = hApi.Split(tCmd[3],",")
		for i = 1, treasureAttrNum, 1 do
			local attrValue = tonumber(tRInfo[i]) or 0	--属性位值
			--print(i, attrValue)
			
			--设置宝物属性位值
			LuaSetTreasureAttr(i, attrValue, notSaveFlag)
		end
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
	
	--触发事件：通知玩家宝物属性位值更新结果
	hGlobal.event:event("LocalEvent_TreasureAttrUpdate_Ret", result)
end

--返回安卓，同步日志存档
__Handler[__rh.L2C_REQUEST_ANDROID_SAVE_LOG] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	
	local savedata = tostring(tCmd[1]) --服务器存储数据
	
	--print("savedata:", savedata)
end

--通知玩家战车请求开宝箱返回结果
__Handler[__rh.L2C_REQUIRE_TANK_OPEN_CHEST] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	
	print("__rh.L2C_REQUIRE_TANK_OPEN_CHEST:",sCmd)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--1;4;10;400;400;400;350;400;1;10:20205:28922|20205|0||0|2|11|12|21|22|31|32|41|42|51|52|61|62|71|72|81|82:0;
	--解析开宝箱结果
	local result =  tonumber(tCmd[1]) or 0		--结果（0失败 1成功 ）
	local chestId = tonumber(tCmd[2]) or 0		--宝箱id
	local derbirsNum = tonumber(tCmd[3]) or 0	--需要的碎片数量
	local weaponChestNum = tonumber(tCmd[4]) or 0	--武器枪宝箱数量
	local tacticChestNum = tonumber(tCmd[5]) or 0	--战术宝箱数量
	local petChestNum = tonumber(tCmd[6]) or 0	--宠物宝箱数量
	local equipChestNum = tonumber(tCmd[7]) or 0	--装备宝箱数量
	local gamecoinNum = tonumber(tCmd[8]) or 0	--游戏币数量
	
	--获取失败
	if (result <= 0) then
		--冒字
		--local strText = "操作失败！错误码: " .. result
		local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__TEXT_PVP_Operation"], result)
		if (result == -1) then --武器宝箱数量不足
			strText = hVar.tab_string["__TEXT_WeaponChestNumNotEnough"]
		elseif (result == -2) then --战术宝箱数量不足
			strText = hVar.tab_string["__TEXT_TacticChestNumNotEnough"]
		elseif (result == -3) then --宠物宝箱数量不足
			strText = hVar.tab_string["__TEXT_PetChestNumNotEnough"]
		elseif (result == -4) then --装备宝箱数量不足
			strText = hVar.tab_string["__TEXT_EquipChestNumNotEnough"]
		elseif (result == -5) then --游戏币不足
			strText = hVar.tab_string["ios_not_enough_game_coin"]
		end
		
		--冒字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
	end
	
	--print("result=", result)
	--print("chestId=", chestId)
	--print("derbirsNum=", derbirsNum)
	
	if (result == 1) then --成功
		local rewardN = tonumber(tCmd[9])
		
		local reward = {}
		local rewardIdx = 10
		
		for i = 1, rewardN do
			local tmp = {}
			local tRInfo = hApi.Split(tCmd[rewardIdx],":")
			tmp[#tmp + 1] = tRInfo[1]				--奖励类型
			tmp[#tmp + 1] = tRInfo[2]				--参数1
			tmp[#tmp + 1] = tRInfo[3]				--参数2
			tmp[#tmp + 1] = tRInfo[4]				--参数3
			
			reward[#reward + 1] = tmp
			rewardIdx = rewardIdx + 1
			
			--如果获得的是4孔神器，发起广播
			local rewardType = tonumber(tRInfo[1]) or 0 --获取类型
			if (rewardType == 10) then --10:神器
				local itemId = tonumber(tRInfo[2]) or 0 --奖励ID
				local itemEntity = tRInfo[3] or ""
				local entity = {}
				local tEntity = hApi.Split(itemEntity,"|")
				
				--28922|20205|0||0|2|11|12|21|22|31|32|41|42|51|52|61|62|71|72|81|82:0
				entity.dbid = tonumber(tEntity[1]) or 0
				entity.typeId = tonumber(tEntity[2]) or 0
				entity.slotnum = tonumber(tEntity[3]) or 0
				entity.attr = {}
				local idx = 3
				for i = 1, entity.slotnum do
					entity.attr[#entity.attr + 1] = tEntity[idx + i]
				end
				
				idx = idx + entity.slotnum + 1
				
				entity.CUnique = tonumber(tEntity[idx+1]) or 0
				entity.quality = tonumber(tEntity[idx+2]) or 0
				entity.randIdx1 = tonumber(tEntity[idx+3]) or 0 --随机属性索引1
				entity.randVal1 = tonumber(tEntity[idx+4]) or 0 --随机属性值1
				entity.randIdx2 = tonumber(tEntity[idx+5]) or 0 --随机属性索引2
				entity.randVal2 = tonumber(tEntity[idx+6]) or 0 --随机属性值2
				entity.randIdx3 = tonumber(tEntity[idx+7]) or 0 --随机属性索引3
				entity.randVal3 = tonumber(tEntity[idx+8]) or 0 --随机属性值3
				entity.randIdx4 = tonumber(tEntity[idx+9]) or 0 --随机属性索引4
				entity.randVal4 = tonumber(tEntity[idx+10]) or 0 --随机属性值4
				entity.randIdx5 = tonumber(tEntity[idx+11]) or 0 --随机属性索引5
				entity.randVal5 = tonumber(tEntity[idx+12]) or 0 --随机属性值5
				entity.randSkillIdx1 = tonumber(tEntity[idx+13]) or 0 --随机技能索引1
				entity.randSkillLv1 = tonumber(tEntity[idx+14]) or 0 --随机技能等级1
				entity.randSkillIdx2 = tonumber(tEntity[idx+15]) or 0 --随机技能索引2
				entity.randSkillLv2 = tonumber(tEntity[idx+16]) or 0 --随机技能等级2
				entity.randSkillIdx3 = tonumber(tEntity[idx+17]) or 0 --随机技能索引3
				entity.randSkillLv3 = tonumber(tEntity[idx+18]) or 0 --随机技能等级3
				
				--[[
				--获得道具
				--print("hApi.GetReawrdGift:",itemId,hVar.tab_item[itemId],entity.typeId,entity.dbid,tRInfo[3])
				if (itemId > 0) and hVar.tab_item[itemId] and itemId == entity.typeId and entity.dbid > 0 then
					--if (LuaCheckPlayerBagCanUse() ~= 0) then
						--4孔
						if (entity.slotnum == 4) then
							--本地获得4孔神器，上传PVP服务器，请求广播此消息
							local itemId = itemId
							local slotNum = entity.slotnum
							local strInfo = hVar.tab_string["MadelGiftGet"] --"领取"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
				]]
			end
		end
		
		local tag, rewardResult = hApi.GetReawrdGift(reward, rewardN)
		
		--扣除碎片
		--[[
		local tabChest = hVar.tab_chest[chestId]
		local itemType = tabChest.itemType
		if (itemType == hVar.ITEM_TYPE.CHEST_WEAPON_GUN) then --武器枪宝箱
			LuaAddTankWeaponGunChestNum(-derbirsNum)
		elseif (itemType == hVar.ITEM_TYPE.CHEST_TACTIC) then --战术宝箱
			LuaAddTankTacticChestNum(-derbirsNum)
		elseif (itemType == hVar.ITEM_TYPE.CHEST_PET) then --宠物宝箱
			LuaAddTankPetChestNum(-derbirsNum)
		elseif (itemType == hVar.ITEM_TYPE.CHEST_EQUIP) then --装备宝箱
			LuaAddTankEquipChestNum(-derbirsNum)
		end
		]]
		
		--设置各类宝箱数量
		local notSaveFlag = true
		LuaSetTankWeaponGunChestNum(weaponChestNum, notSaveFlag)
		LuaSetTankTacticChestNum(tacticChestNum, notSaveFlag)
		LuaSetTankPetChestNum(petChestNum, notSaveFlag)
		LuaSetTankEquipChestNum(equipChestNum, notSaveFlag)
		
		--动画打开宝箱奖励播放（类似葫芦娃的动画效果）
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		--刷新积分界面
		hGlobal.event:event("LocalEvent_RefreshScoreAction",1)
		
		--仓库界面刷新
		hGlobal.event:event("LocalEvent_RefreshChestNum")
		
		--更新客户端游戏币界面
		SendCmdFunc["gamecoin"]()
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		--上传存档
		local keyList = {"card", "bag", "skill", "material", }
		LuaSavePlayerData_Android_Upload(keyList, "开宝箱")
	end
	
	--触发事件：通知玩家宝物属性位值更新结果
	hGlobal.event:event("LocalEvent_OpenChest_Ret", result, chestId, gamecoinNum)
end


__Handler[__rh.L2C_REQUIRE_COMMENT_ADD_RET] = function(sCmd)
	--print("L2C_REQUIRE_COMMENT_ADD_RET	" , sCmd)
	local tCmd = hApi.Split(sCmd or "",";")
	hGlobal.event:event("localEvent_Add_Comment_Ret",tCmd[1],tonumber(tCmd[2]),tonumber(tCmd[3]),tonumber(tCmd[4]))
	--[[
	if tCmd[1] == "0" then
		print("add comment success")
	else
		print("add comment failed " , tCmd[1])
	end
	--]]
end

__Handler[__rh.L2C_REQUIRE_COMMENT_EDIT_RET] = function(sCmd)
	--print("L2C_REQUIRE_COMMENT_EDIT_RET	" , sCmd)
	local tCmd = hApi.Split(sCmd or "",";")
	if tCmd[1] == "0" then
		print("edit comment success")
	else
		print("edit comment failed " , tCmd[1])
	end
end

__Handler[__rh.L2C_REQUIRE_COMMENT_DEL_RET] = function(sCmd)
	--print("L2C_REQUIRE_COMMENT_DEL_RET	" , sCmd)
	local tCmd = hApi.Split(sCmd or "",";")
	if tCmd[1] == "0" then
		print("del comment success")
	else
		print("del comment failed " , tCmd[1])
	end
end

__Handler[__rh.L2C_REQUIRE_COMMENT_LOOK_RET] = function(sCmd)
	--print("L2C_REQUIRE_COMMENT_LOOK_RET	" , sCmd)
	local tCmd = hApi.Split(sCmd or "",";")
	if tCmd[1] == "0" then
		--print("look comment success")
		local commentType = tonumber(tCmd[2])
		local typeID = tonumber(tCmd[3])
		local commentCount = tonumber(tCmd[4])
		local pageIndex = tonumber(tCmd[5])
		local orderType = tonumber(tCmd[6])
		local dataCount = tonumber(tCmd[7])
		local lookData = {}

		local lineOffset = 8

		local function PackData(names,source,dest,beginIndex)
			for i,v in ipairs(names)do
				if v.t == "s" then
					dest[v.n] =  source[beginIndex + i - 1]
				elseif v.t == "n" then
					dest[v.n] =  tonumber(source[beginIndex + i - 1])
				else
					dest[v.n] =  source[beginIndex + i - 1]
				end
			end
			return beginIndex + #names
		end
		local dataName = {
			{ n = "commentID",t = "n"},
			{ n = "uid",t = "n"},
			{ n = "rid",t = "n"},
			{ n = "content",t = "s"},
			{ n = "show",t = "n"},
			{ n = "star",t = "n"},
			{ n = "key",t = "s"},
			{ n = "updateDate",t = "s"},
			{ n = "icon",t = "s"},
			{ n = "name",t = "s"},
			{ n = "isLike",t = "s"},
			{ n = "subTotal",t = "n"},
			{ n = "subCount",t = "n"},
		}

		local subDataName = {
			{ n = "commentID",t = "n"},
			{ n = "uid",t = "n"},
			{ n = "rid",t = "n"},
			{ n = "content",t = "s"},
			{ n = "show",t = "n"},
			{ n = "star",t = "n"},
			{ n = "key",t = "s"},
			{ n = "updateDate",t = "s"},
			{ n = "icon",t = "s"},
			{ n = "name",t = "s"},
			{ n = "isLike",t = "s"},
		}

		for i = 1 , dataCount do
			local item = {}
			lineOffset = PackData(dataName,tCmd,item,lineOffset)
			if item.subCount > 0 then
				item.subComment = {}
				for s = 1 , item.subCount do
					local subItem = {}
					lineOffset = PackData(subDataName,tCmd,subItem,lineOffset)
					table.insert(item.subComment,subItem)
				end
			end	
			table.insert(lookData,item)
		end

		--[[
		for i = 1 , dataCount do
			local data = {
				commentID = tonumber(tCmd[lineOffset]),
				uid = tonumber(tCmd[1 + lineOffset]),
				rid = tonumber(tCmd[2 + lineOffset]),
				content = tCmd[3 + lineOffset],
				show = tonumber(tCmd[4 + lineOffset]),
				star = tonumber(tCmd[5 + lineOffset]),
				updateDate = tCmd[6 + lineOffset],
				icon = tCmd[7 + lineOffset],
				name = tCmd[8 + lineOffset],
				isLike = tCmd[9 + lineOffset],
				subTotal = tCmd[10 + lineOffset],
				subCount = tCmd[11 + lineOffset],
			}
			data.subComment = {}
			for subi = 1, data.subCount do
				table.insert(data.subComment,{
				commentID = tonumber(tCmd[1 + lineOffset]),
				uid = tonumber(tCmd[2 + lineOffset]),
				rid = tonumber(tCmd[3 + lineOffset]),
				content = tCmd[4 + lineOffset],
				show = tonumber(tCmd[11 + lineOffset]),
				star = tonumber(tCmd[12 + lineOffset]),
				updateDate = tCmd[13 + lineOffset],
				icon = tCmd[14 + lineOffset],
				name = tCmd[15 + lineOffset],
				isLike = tCmd[16 + lineOffset],
			})
			end

			lineOffset = fixedColCount + data.subCount * fixedSubColCount
				
			table.insert(lookData,data)
		end

		--]]

		--[[
		print("comment data : ")
		for i,v in ipairs(lookData)do
			for k,v in pairs(v) do
				print(k,"	",v)
			end
			print("comment : " , i)
		end
		--]]
		local commentData = {
			commentType = commentType,
			typeID = typeID,
			pageIndex = pageIndex,
			commentCount = commentCount,
			orderType = orderType,
			lookData = lookData,
		}
		--table_print(commentData)
		--print("ccccc")
		hGlobal.event:event("localEvent_Comment_DataChange", commentData)
		if commentType ~= 2 then
			hGlobal.event:event("localEvent_ReceiveCommentData",commentData)
		else
			--print("aaaaaaa")
			hGlobal.event:event("localEvent_ReceiveSubCommentData",commentData)
		end

	else
		print("look comment failed " , tCmd[1])
	end

end

__Handler[__rh.L2C_REQUIRE_COMMENT_LIKES_RET] = function(sCmd)
	--print("L2C_REQUIRE_COMMENT_LIKES_RET	" , sCmd)
	local tCmd = hApi.Split(sCmd or "",";")
	hGlobal.event:event("localEvent_Like_Comment_Ret", tCmd[1],tonumber(tCmd[2]),tonumber(tCmd[3]))
end

__Handler[__rh.L2C_REQUIRE_COMMENT_CANNEL_LIKES_RET] = function(sCmd)
	--print("L2C_REQUIRE_COMMENT_CANNEL_LIKES_RET	" , sCmd)
	local tCmd = hApi.Split(sCmd or "",";")
	hGlobal.event:event("localEvent_Cancel_Like_Comment_Ret", tCmd[1],tonumber(tCmd[2]),tonumber(tCmd[3]))
end

__Handler[__rh.L2C_REQUIRE_COMMENT_LIKES_COUNT_RET] = function(sCmd)
	--print("L2C_REQUIRE_COMMENT_LIKES_COUNT_RET	" , sCmd)
	local tCmd = hApi.Split(sCmd or "",";")
	print("comment like count = ",tCmd[1])
end

__Handler[__rh.L2C_REQUIRE_COMMENT_USER_LIKES_RET] = function(sCmd)
	--print("L2C_REQUIRE_COMMENT_USER_LIKES_RET	" , sCmd)
	local tCmd = hApi.Split(sCmd or "",";")
	print("user like comment is ",tCmd[1])
end

__Handler[__rh.L2C_REQUIRE_COMMENT_QUERY_TITLE] = function(sCmd)
	print("L2C_REQUIRE_COMMENT_QUERY_TITLE	" , sCmd)
	local tCmd = hApi.Split(sCmd or "",";")
	if tCmd[1] == "0" then
		--print("title is ",tCmd[2])
		--table_print(tCmd)
		local flag = tonumber(tCmd[3])
		local ntype = tonumber(tCmd[4])
		local nId = tonumber(tCmd[5])
		hGlobal.event:event("LocalEvent_Comment_Update_Title", tCmd[2],flag)
		hGlobal.event:event("LocalEvent_UpdateCommentTitle", tCmd[2],flag,ntype,nId)
	end
	print("user query title is ",tCmd[1])
end

__Handler[__rh.L2C_REQUIRE_COMMENT_EDIT_TITLE] = function(sCmd)
	--print("L2C_REQUIRE_COMMENT_USER_LIKES_RET	" , sCmd)
	local tCmd = hApi.Split(sCmd or "",";")
	print("user edit title is ",tCmd[1])
end

__Handler[__rh.L2C_REQUIRE_COMMENT_BARRAGE_LOOK_RET] = function(sCmd)
	--print("L2C_REQUIRE_COMMENT_BARRAGE_LOOK_RET	" , sCmd)
	local tCmd = hApi.Split(sCmd or "",";")
	if tCmd[1] == "0" then
		print("look barrage success")
		local commentType = tonumber(tCmd[2])
		local typeID = tonumber(tCmd[3])
		local beginIndex = tonumber(tCmd[4])
		local commentCount = tonumber(tCmd[5])
		local pageIndex = tonumber(tCmd[6])
		local dataCount = tonumber(tCmd[7])
		local lookData = {}
		local lineOffset = 7
		for i = 1 , dataCount do
			table.insert(lookData,{
				commentID = tonumber(tCmd[lineOffset + 1]),
				uid = tonumber(tCmd[lineOffset + 2]),
				rid = tonumber(tCmd[lineOffset + 3]),
				content = tCmd[lineOffset + 4],
				star = tonumber(tCmd[lineOffset + 5]),
				key = tCmd[lineOffset + 6],
				updateDate = tCmd[lineOffset + 7],
			})
			lineOffset = lineOffset + 7
		end

		--table_print(lookData)

		--用户名库 额外流程
		if commentType == hVar.CommentTargetTypeDefine.NAMELIBRARY then
			hGlobal.event:event("LocalEvent_GetNameLibrary",beginIndex,dataCount,lookData)
		elseif commentType == hVar.CommentTargetTypeDefine.PROLOADTEXT then
			hGlobal.event:event("LocalEvent_GetPreloadTxt",beginIndex,commentType,typeID,dataCount,lookData)
		else
			hGlobal.event:event("localEvent_ReceiveBarrageData",commentType,typeID,beginIndex,dataCount,lookData)
			--测试代码
			--for i = #lookData + 1,100 do
				--local rand = math.random(1,#lookData)
				--lookData[i] = lookData[rand]
			--end
			--table_print(lookData)
			for _,v in ipairs(lookData) do
				hGlobal.event:event("localEvent_Barrage_DataChange", {
						content = v.content,
						--speed = 50,
						--color = {0,255,0},
						id = v.commentID,
					})
			end
		end
	
	else
		local commentType = tonumber(tCmd[2])
		local typeID = tonumber(tCmd[3])
		print("look barrage failed " , tCmd[1],tCmd[2],tCmd[3])
		if commentType == hVar.CommentTargetTypeDefine.NAMELIBRARY then
			hGlobal.event:event("LocalEvent_GetNameLibrary",-1)
		elseif commentType == hVar.CommentTargetTypeDefine.PROLOADTEXT then
			hGlobal.event:event("LocalEvent_GetPreloadTxt",-1)
		end
	end
end

-------------------------------------------------------
--add by mj 2022.11.21
--聊天消息id同步结果返回
__Handler[__rh.L2C_REQUIRE_SYNC_CHAT_MSG_ID] = function(sCmd)
	--local sCmd = packet:readString()
	local tCmd = hApi.Split(sCmd or "",";")
	
	--print("__rh.L2C_REQUEST_SYNC_GROUPCARD:",sCmd)
	
	local lastWorldMsgId = tonumber(tCmd[1]) or 0 --最后一条世界消息id
	local lastInviteMsgId = tonumber(tCmd[2]) or 0 --最后一条邀请消息id
	local lastGroupMsgId = tonumber(tCmd[3]) or 0 --最后一条军团消息id
	local groupcardNum = tonumber(tCmd[4]) or 0 --服务器军团卡数量
	
	--设置世界聊天的新收到的消息id
	if (lastWorldMsgId > 0) then
		local receive_msgid = LuaGetChatWorldReceiveMsgId(g_curPlayerName)
		--print("receive_msgid=", receive_msgid)
		--print("lastWorldMsgId=", lastWorldMsgId)
		if (receive_msgid >= 0) then
			LuaSetChatWorldReceiveMsgId(g_curPlayerName, lastWorldMsgId)
		elseif (lastWorldMsgId > math.abs(receive_msgid)) then --负数是聊天忠告
			LuaSetChatWorldReceiveMsgId(g_curPlayerName, lastWorldMsgId)
		end
	end
	
	--设置邀请聊天的新收到的消息id
	if (lastInviteMsgId > 0) then
		local receive_msgid = LuaGetChatInviteReceiveMsgId(g_curPlayerName)
		--print("receive_msgid=", receive_msgid)
		--print("lastInviteMsgId=", lastInviteMsgId)
		LuaSetChatInviteReceiveMsgId(g_curPlayerName, lastInviteMsgId)
	end
	
	--设置私聊提示进度
	--LuaSetChatPrivateFriendList(g_curPlayerName, msg_private_friend_chat_list)
	
	--设置军团聊天的新收到的消息id
	if (lastGroupMsgId > 0) then
		LuaSetChatGroupReceiveMsgId(g_curPlayerName, lastGroupMsgId)
	end
	
	--去掉军团卡的数据处理
	--[[
	--先移除本地存档里的全部军团卡
	if Save_PlayerData then
		for j = 1, #Save_PlayerData.battlefieldskillbook, 1 do
			if (type(Save_PlayerData.battlefieldskillbook[j]) == "table") then
				local id, lv, num = unpack(Save_PlayerData.battlefieldskillbook[j])
				--存在表项
				if hVar.tab_tactics[id] then
					local type = hVar.tab_tactics[id].type --军团卡类型
					if (type == hVar.TACTICS_TYPE.LEGION) then --军团卡
						Save_PlayerData.battlefieldskillbook[j][2] = 0
						--print("军团卡" .. id .. "，等级标记为0")
					end
				end
			end
		end
	end
	
	--再将服务器的军团卡覆盖本地
	if Save_PlayerData then
		local rIdx = 4
		for i = 1, groupcardNum, 1 do
			local groupcardInfo = tCmd[rIdx + i] or ""
			local tGroupCard = hApi.Split(groupcardInfo, "|")
			local groupcardId = tonumber(tGroupCard[1]) or 0
			local groupcardLv = tonumber(tGroupCard[2]) or 0
			--print(i, groupcardId, groupcardLv)
			
			if (groupcardId > 0) and (groupcardLv > 0) then
				local bFind = false --是否存在此军团卡
				for j = 1, #Save_PlayerData.battlefieldskillbook, 1 do
					if (type(Save_PlayerData.battlefieldskillbook[j]) == "table") then
						local id, lv, num = unpack(Save_PlayerData.battlefieldskillbook[j])
						--存在表项
						if hVar.tab_tactics[id] then
							local type = hVar.tab_tactics[id].type --军团卡类型
							if (type == hVar.TACTICS_TYPE.LEGION) then --军团卡
								if (id == groupcardId) then --找到了
									bFind = true
									Save_PlayerData.battlefieldskillbook[j][2] = groupcardLv
									--print("找到军团卡" ..groupcardId .. "，等级标记为" .. groupcardLv)
									break
								end
							end
						end
					end
				end
				
				--不存在的军团卡，新插入一个
				if (not bFind) then
					Save_PlayerData.battlefieldskillbook[#Save_PlayerData.battlefieldskillbook+1] = {groupcardId, groupcardLv, 0,}
					--print("未找到军团卡" ..groupcardId .. "，插入等级为" .. groupcardLv)
				end
			end
		end
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
	]]
end
--add end
-------------------------------------------------------



