
-----------------------
--网络消息相关的脚本接口
-----------------------
hVar.NoLocalDataID = {
	30401,		--执行服务器下发的触发器
	30322,		--申请玩家存档
	34008,		--设置玩家作弊用户
	32033,		--查询DB是否有可用角色ID
	32024,		--返回可用存档结果
	32022,		--返回恢复存档订单
	32026,		--返回恢复存档数据以及结果
	30312,		--系统邮件
	30332,		--设置玩家测试员标记
	35020,		--获取转移设备状态
	35024,		--新的获取存档流程
	4103,		--新的心跳包
}
hVar.DEVICE_TYPE = {
	[0] = "Windows",
	[1] = "Linux",
	[2] = "MacOS",
	[3] = "Android",
	[4] = "Iphone",
	[5] = "Ipad",
	[6] = "BlackBerry",
}
hApi.GetCurDevType = function()
	local dev_typ = ""
	local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()

	if hVar.DEVICE_TYPE[TargetPlatform] == nil then return "erro" end
	dev_typ = dev_typ..hVar.DEVICE_TYPE[TargetPlatform]

	local m_fContentScaleFactor = CCDirector:sharedDirector():getContentScaleFactor()
	
	if m_fContentScaleFactor == 0.2 then
		dev_typ = dev_typ.."HD"
	else

	end

	return dev_typ
end

hApi.GetCurDevTypeEx = function()
	local size = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
	if size.width ==  1024 and size.height == 768 then
		return "ipad"
	elseif size.width == 2048 and size.height == 1536 then
		return "ipad retina"
	elseif size.width == 960 and size.height == 640 then
		return "ip4"
	elseif size.width == 1136 and size.height == 640 then
		return "ip5"
	end
	
	return "other-w:"..tostring(size.width).."h:"..tostring(size.height)
end

g_cur_net_state = -1 --连接状态
g_cur_login_state = -1 --登陆状态
g_isReconnection = 0 --是否断线重连
g_isLoginException = 0 --是否重连异常

SendCmdFunc = {}
local _ncf = SendCmdFunc
local _Lua_SendPacket = function(opid,sCmd)	--发送 3002协议的抽象脚本函数
	--print("_Lua_SendPacket:", opid)
	local packet = CCWritePacket:create()
	packet:writeUInt(hVar.DB_OPR_TYPE.C2L_REQUIRE)	-- 协议id 返回 3003
	packet:writeInt(opid)				-- opid
	packet:writeUInt(0) --安卓
	packet:writeUInt(0) --安卓
	packet:writeString(sCmd)			-- 字符串 cmd 
	xlNet_SendPacket(packet)
end

function getnetcmdcount()
	if nil == g_sendnetcmdcount then
		g_sendnetcmdcount = 0
	else
		g_sendnetcmdcount = g_sendnetcmdcount + 1
	end
	return g_sendnetcmdcount
end

--刷新系统时间
_ncf["refresh_systime"] = function()
	--[[
	local packet = CCWritePacket:create()

	packet:writeUInt(hVar.DB_OPR_TYPE.C2L_REQUIRE)	-- 协议id
	packet:writeInt(hVar.DB_OPR_TYPE.C2L_REQUIRE_SYSTIME)	-- opid

	local info = "0"
	packet:writeString(info)

	xlNet_SendPacket(packet)
	]]
	
	local info = "0"
	_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_SYSTIME,info)
end

--获取服务器版本控制信息
_ncf["get_version_control"] = function()
	
	local info = "0"
	
	_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_GET_VER_INFO,info)
end

--获取邮箱附件
_ncf["get_mail_annex"] = function(prizeId, prizeType)

	local roleId = luaGetplayerDataID()
	if roleId and roleId > 0 and prizeId and prizeId > 0 then
		
		local info = roleId .. ";" .. prizeId.. ";" .. prizeType ..";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_GET_MAIL_ANNEX,info)
		
	else
		print("_ncf[\"get_mail_annex\"] send faild! roleId = ", roleId)
	end
end

--获取带有标题正文的邮件的奖励
_ncf["get_mail_annex_titlemsg"] = function(prizeId, prizeType)
	
	local roleId = luaGetplayerDataID()
	if roleId and roleId > 0 and prizeId and prizeId > 0 then
		
		local info = roleId .. ";" .. prizeId.. ";" .. prizeType ..";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_GETTITIEMSG_REWARD,info)
		
	else
		print("_ncf[\"get_mail_annex_titlemsg\"] send faild! roleId = ", roleId)
	end
end

--获得直接开锦囊邮件附件
_ncf["get_mail_annex_openchest"] = function(prizeId, prizeType)
	
	local roleId = luaGetplayerDataID()
	if roleId and roleId > 0 and prizeId and prizeId > 0 then
		
		local info = roleId .. ";" .. prizeId.. ";" .. prizeType ..";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_GET_MAIL_ANNEX_OPENCHEST,info)
		
	else
		print("_ncf[\"get_mail_annex_openchest\"] send faild! roleId = ", roleId)
	end
end

--获取无尽地图排行榜奖励
_ncf["get_mail_annex_endless"] = function(prizeId, prizeType)
	
	local roleId = luaGetplayerDataID()
	if roleId and roleId > 0 and prizeId and prizeId > 0 then
		
		local info = roleId .. ";" .. prizeId.. ";" .. prizeType ..";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_GET_ENDLESS_REWARD,info)
		
	else
		print("_ncf[\"get_mail_annex_endless\"] send faild! roleId = ", roleId)
	end
end

--获取无尽地图的前10名玩家名
_ncf["get_endless_rank_name"] = function(rankId, logId)
	
	local roleId = luaGetplayerDataID()
	if roleId and roleId > 0 and rankId and rankId > 0 and logId and logId > 0 then
		
		local info = roleId .. ";" .. rankId.. ";" .. logId ..";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_GET_ENDLESS_RANK_NAME,info)
		
	else
		print("_ncf[\"get_endless_rank_name\"] send faild! roleId = ", roleId)
	end
end

--获取聊天龙王奖奖励
_ncf["get_mail_annex_chatdragon"] = function(prizeId, prizeType)
	
	local roleId = luaGetplayerDataID()
	if roleId and roleId > 0 and prizeId and prizeId > 0 then
		
		local info = roleId .. ";" .. prizeId.. ";" .. prizeType ..";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_CHATDRAGON_REWARD,info)
		
	else
		print("_ncf[\"get_mail_annex_chatdragon\"] send faild! roleId = ", roleId)
	end
end

--任务相关 zhenkira
--请求任务数据
_ncf["require_quest"] = function()
	

	local roleId = luaGetplayerDataID()
	if roleId and roleId > 0 then
		local packet = CCWritePacket:create()

		packet:writeUInt(hVar.DB_OPR_TYPE.C2L_REQUIRE)	-- 协议id
		packet:writeInt(hVar.DB_OPR_TYPE.C2L_REQUIRE_QUEST)	-- opid

		local info = roleId..",".. hApi.GetStageSchedule()
		packet:writeString(info)

		xlNet_SendPacket(packet)
	else
		print("_ncf[\"require_quest\"] send faild! roleId = ", roleId)
	end
end

--请求任务数据
_ncf["require_quest_test"] = function()
	

	local roleId = luaGetplayerDataID()
	if roleId and roleId > 0 then
		local packet = CCWritePacket:create()

		packet:writeUInt(hVar.DB_OPR_TYPE.C2L_REQUIRE)	-- 协议id
		packet:writeInt(hVar.DB_OPR_TYPE.C2L_REQUIRE_QUEST_TEST)	-- opid

		local info = roleId..",".. hApi.GetStageSchedule()
		packet:writeString(info)

		xlNet_SendPacket(packet)
	else
		print("_ncf[\"require_quest\"] send faild! roleId = ", roleId)
	end
end

--更新任务状态（本地任务完成时发送）
--参数
--t = {
--	{idx, id, num, param},
--	……
--}
_ncf["update_quest"] = function(tQuest)
	local roleId = luaGetplayerDataID()
	if roleId and roleId > 0 and tQuest and #tQuest > 0 then
		local packet = CCWritePacket:create()
		
		packet:writeUInt(hVar.DB_OPR_TYPE.C2L_REQUIRE)	-- 协议id
		packet:writeInt(hVar.DB_OPR_TYPE.C2L_UPDATE_QUEST)	-- opid
		
		local dailyQuestTime = LuaGetDailyQuestTimeStamp()
		local info = "rid:"..roleId..";qt:"..dailyQuestTime.. ";ss:" .. hApi.GetStageSchedule() .. ";"
		
		for i = 1, #tQuest do
			local q = tQuest[i]
			info = info .. string.format("qst:%d:%d:%d:%d;",(q[1] or 0),(q[2] or 0),(q[3] or 0),(q[4] or 0))
		end
		
		packet:writeString(info)
		
		xlNet_SendPacket(packet)
		
	else
		print("_ncf[\"update_quest\"] send faild! roleId = ", roleId)
	end
end

--完成任务（玩家点完成任务领取奖励时发送）
--t = {idx, id, },
_ncf["confirm_quest"] = function(tQuest)
	local roleId = luaGetplayerDataID()
	if roleId and roleId > 0 and tQuest and #tQuest > 0 then
		local packet = CCWritePacket:create()
		
		packet:writeUInt(hVar.DB_OPR_TYPE.C2L_REQUIRE)	-- 协议id
		packet:writeInt(hVar.DB_OPR_TYPE.C2L_CONFIRM_QUEST)	-- opid
		
		local info = "rid:"..roleId..";qt:"..LuaGetDailyQuestTimeStamp() .. ";ss:" .. hApi.GetStageSchedule() .. ";"
		
		info = info .. string.format("qst:%d:%d;",(tQuest[1] or 0),(tQuest[2] or 0))
		
		packet:writeString(info)
		
		xlNet_SendPacket(packet)
		
	else
		print("_ncf[\"update_quest\"] send faild! roleId = ", roleId)
	end
end

--更新领取任务日志
_ncf["update_reward_log"] = function(prizeId)
	if prizeId and prizeId > 0 then

		local info = "pid:"..prizeId..";"--..";rwd:"..tag..";"

		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_UPDATE_REWARD_LOG,info)
	end
end

--获取排行榜模板
_ncf["get_billboardT"] = function(bId)
	
	local info = ""
	info = info .. tostring(bId or 0) .. ";"	--如果bId没传,则取全部
	
	_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_BOARD_TEMPLATE,info)
end

--获取排行榜信息
_ncf["get_billboard"] = function(bId)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()				--我使用角色rid
	if uId and rId and bId and uId > 0 and rId > 0 and bId > 0 then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(bId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_BILLBOARD, info)
		--print("get_billboardget_billboardget_billboardget_billboardget_billboardget_billboardget_billboard", bId)
	end
end

--更新玩家排行榜信息(模板id, 积分, 时间戳)
_ncf["update_billboard_rank"] = function(bId, rank)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()				--我使用角色rid
	if uId and rId and bId and uId > 0 and rId > 0 and bId > 0 then
		local info = ""
		local timeStamp = os.date("%Y-%m-%d %H:%M:%S", os.time())
		
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(bId) .. ";"
		info = info .. tostring(rank or 0) .. ";"
		info = info .. tostring(timeStamp) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_UPDATE_BILLBOARD_RANK, info)
	end
end

-------------------------------------------------------
--!!!! add by mj 2022.11.21，临时注掉
--发起请求请求走马灯冒字
_ncf["request_bubble_notice"] = function(noticeType, noticeInfo, itemId)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and (uId > 0) and (rId > 0) then
		local iChannelId = getChannelInfo() --渠道号
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(iChannelId) .. ";"
		info = info .. tostring(noticeType) .. ";"
		info = info .. tostring(hApi.StringEncodeEmoji(g_curPlayerName)) .. ";" --处理表情
		info = info .. tostring(hApi.StringEncodeEmoji(noticeInfo)) .. ";" --处理表情
		info = info .. tostring(itemId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_BUBBLE_NOTICE, info)
	end
end
--add end
-------------------------------------------------------

--修改姓名
_ncf["change_name"] = function(name)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	if uId and rId and uId > 0 and rId > 0 then
		local packet = CCWritePacket:create()
		packet:writeUInt(hVar.DB_OPR_TYPE.C2L_REQUIRE) -- 协议id
		packet:writeInt(hVar.DB_OPR_TYPE.C2L_REQUIRE_CHANGE_NAME) -- opid
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(name) .. ";"
		
		--print("uId", uId)
		--print("rId", rId)
		--print("name", name)
		
		packet:writeString(info)
		
		xlNet_SendPacket(packet)
	end
end


--更新地图首次通关记录
_ncf["upload_map_record"] = function(mapId, mapName)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	if uId and rId and uId > 0 and rId > 0 then
		local packet = CCWritePacket:create()
		packet:writeUInt(hVar.DB_OPR_TYPE.C2L_REQUIRE) -- 协议id
		packet:writeInt(hVar.DB_OPR_TYPE.C2L_UPLOAD_MAP_RECORD) -- opid
		
		local info = ""
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(mapId) .. ";"
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(mapName) .. ";"
		
		--print("upload_map_record()")
		--print("uId", uId)
		--print("rId", rId)
		--print("mapId", mapId)
		--print("mapName", mapName)
		
		packet:writeString(info)
		
		xlNet_SendPacket(packet)
	end
end

--商城
--打开商城
_ncf["open_shop"] = function(shopId, iTag)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(shopId) .. ";"
		info = info .. (iTag or 0) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_OPEN_SHOP,info)
	end
end

--刷新商城(使用rmb刷新)
_ncf["refresh_shop"] = function(shopId, iTag)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(shopId) .. ";"
		info = info .. (iTag or 0) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_REFRESH_SHOP,info)
	end
end

--购买商品(商店id,商品id,是否使用红装晶石兑换)
_ncf["buyitem"] = function(shopId, itemIdx, crystalFlag, iTag)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(shopId) .. ";"
		info = info .. tostring(itemIdx) .. ";"
		
		if crystalFlag then
			info = info .. "1" .. ";"
		else
			info = info .. "0" .. ";"
		end
		
		info = info .. (iTag or 0) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_BUYITEM,info)
	end
end

--获取我的所有资源
_ncf["get_mycoin"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid

	if uId and rId and uId > 0 and rId > 0 then

		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"

		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_MYCOIN,info)
	end
end

--红装合成(主道具dbid,素材数量,素材dbid列表)
_ncf["merge_redequip"] = function(mainDbid,materialNum,materialDbidList)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid

	if uId and rId and uId > 0 and rId > 0 then
		local packet = CCWritePacket:create()
		packet:writeUInt(hVar.DB_OPR_TYPE.C2L_REQUIRE) -- 协议id
		packet:writeInt(hVar.DB_OPR_TYPE.C2L_REQUIRE_MERGE_REDEQUIP) -- opid

		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(mainDbid).. ";"
		info = info .. tostring(materialNum or 0)..";"

		local l = materialDbidList or {}
		for i = 1, (materialNum or 0) do
			info = info .. (materialDbidList[i] or "") .. ";"
		end
		
		packet:writeString(info)
		xlNet_SendPacket(packet)
	end
end

--红装洗练(需要洗练的装备dbid,锁孔的数量,锁孔的位置列表（位置索引从1开始）)
_ncf["xilian_redequip"] = function(itemDbid,lockNum,lockIdxList)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid

	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(itemDbid).. ";"
		info = info .. tostring(lockNum or 0)..";"
		
		local l = lockIdxList or {}
		for i = 1, (lockNum or 0) do
			info = info .. (lockIdxList[i] or "") .. ";"
		end
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_XILIAN_REDEQUIP,info)
	end
end

--红装同步
_ncf["sync_redequip"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. LuaPlayerDataOldRedEquipInfo()
		--print("sync_redequip:",info)
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_SYNC_REDEQUIP, info)
	end
end

--出售红装
--分解红装(道具dbid列表)
_ncf["descompos_redequip"] = function(materialNum,materialDbidList)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(materialNum or 0)..";"
		
		for i = 1,materialNum do
			info = info .. (materialDbidList[i] or "") .. ";"
		end
		
		--print(info)
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_DESCOMPOS_REDEQUIP,info)
		--hGlobal.event:event("LocalEvent_DescomposeRedEquip",materialDbidList)
	end
end

-------------------------------------------------------
--add bby mj
--聊天最新消息id同步
_ncf["sync_chat_msg_id"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		--print("sync_redequip:",info)
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_SYNC_CHAT_MSG_ID, info)
	end
end
--add end
-------------------------------------------------------

--请求挑战普通剧情地图
_ncf["require_battle_normal"] = function(mapName, mapDiff)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(mapName) .. ";"
		info = info .. tostring(mapDiff) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_BATTLE_NORMAL,info)
	end
end

--请求挑战娱乐地图
_ncf["require_battle_entertament"] = function(mapName, mapDiff)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(mapName) .. ";"
		info = info .. tostring(mapDiff) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_BATTLE_ENTERTAMENT,info)
	end
end

--请求继续娱乐地图的挑战（随机迷宫）
_ncf["require_resume_entertament"] = function(mapName, mapDiff, battleId)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(mapName) .. ";"
		info = info .. tostring(mapDiff) .. ";"
		info = info .. tostring(battleId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_RESUME_ENTERTAMENT,info)
	end
end

--查询VIP等级和领取状态（新）
_ncf["get_VIP_Lv_New"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_VIP_INFO,info)
	end
end

--领取VIP每日奖励1（新）
_ncf["get_VIP_dailyReward"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_VIP_DAILY_REWARD,info)
	end
end

--领取VIP每日奖励2（新）
_ncf["get_VIP_dailyReward2"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_VIP_DAILY_REWARD2,info)
	end
end

--领取VIP每日奖励3（新）
_ncf["get_VIP_dailyReward3"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_VIP_DAILY_REWARD3,info)
	end
end

--请求查询玩家宝物和宝物属性位值信息
_ncf["query_treasure_info"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TRESTURE_INFO, info)
	end
end

--玩家请求宝物升星
_ncf["update_treasure_starup"] = function(id)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(id) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_UPDATE_TRESTURE_STARUP, info)
	end
end

--玩家请求上传宝物属性位值
_ncf["upload_treasure_attr"] = function(sessionId, orderId, battleId, mapName, tTreasureAttr)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(sessionId) .. ";"
		info = info .. tostring(orderId) .. ";"
		info = info .. tostring(battleId) .. ";"
		info = info .. tostring(mapName) .. ";"
		info = info .. hApi.Array2String(tTreasureAttr, ",") .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_UPLOAD_TRESTURE_ATTR_INFO, info)
	end
end

--玩家请求请求开宝箱
_ncf["tank_open_chest"] = function(shopItemId)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(shopItemId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_OPEN_CHEST, info)
	end
end

--上传客户端错误日志
_ncf["send_errer_log"] = function(strInfo)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(strInfo) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_ERROR_LOG,info)
	end
end

--GM指令-加资源
_ncf["gm_operation_add_resource"] = function(rewardType, param2, param3, param4)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		local iChannelId = getChannelInfo() --渠道号
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(iChannelId) .. ";"
		info = info .. tostring(rewardType) .. ";"
		info = info .. tostring(param2) .. ";"
		info = info .. tostring(param3) .. ";"
		info = info .. tostring(param4) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_GM_ADD_RESOURCE,info)
	end
end

--GM指令-地图全通
_ncf["gm_operation_map_finish"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		local iChannelId = getChannelInfo() --渠道号
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(iChannelId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_GM_MAP_FINISH,info)
	end
end

--GM指令-加全部英雄经验
_ncf["gm_operation_add_heroexp_all"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		local iChannelId = getChannelInfo() --渠道号
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(iChannelId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_GM_ADD_HEROEXP_ALL,info)
	end
end

--新手引导图-添加红装
_ncf["guide_add_redequip"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		local iChannelId = getChannelInfo() --渠道号
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(iChannelId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_GUIDE_ADD_REDEQUOP,info)
	end
end

----------------------------------------------------------------------------------------------------
--把网络消息中的积分字段解析成数字积分
_ncf["Tool_string2socre"] = function(text)
	local score = 0
	if string.find(text,"s:") ~= nil then
		local tempJFs = string.sub(text,string.find(text,"s:")+2,string.len(text))
		if tonumber(tempJFs) then
			score = tonumber(tempJFs)
			return score
		else
			for tempJFs in string.gfind(tempJFs,"([^%;]+);+") do
				score = tonumber(tempJFs)
				return score
			end
		end
	end
	return score
end

_ncf["get_photo_state"] = function(itag,uid_table)
	local packet = CCWritePacket:create()
	packet:writeUInt(40200)             -- 协议id
	packet:writeInt(0)
	packet:writeInt(itag) -- uid
	packet:writeUInt(#uid_table)
	for i = 1,#uid_table do
		packet:writeInt(uid_table[i])
	end
	xlNet_SendPacket(packet)
end

--local uid = 85926371
--local index = 2
--local sProject = "cow"

_ncf["HTTP_get_photo"] = function(uid,index)

	

	local sGetUrl = string.format("http://weixin.xingames.com/weiphp/index.php?s=/addon/Member/Member/get_headimg/uid/%d/type/%d/game/td",uid,index)
	local ret = xlHttpClient_Get(sGetUrl,"get_head")

	--hGlobal.UI.MsgBox(string.format("HTTP_get_photo:%s,%d",sGetUrl,ret),{
	--				font = hVar.FONTC,
	--				ok = function()
	--				end,
	--			})
end

_ncf["HTTP_post_photo"] = function(uid,index,path)
	local f = io.open(path,"r")
	if f then
		--hGlobal.UI.MsgBox(string.format("HTTP_post_photo:"),{
		--			font = hVar.FONTC,
		--			ok = function()
		--			end,
		--		})
		local pstr = f:read("*a")
		f:close()
		local pstrlen = string.len(pstr)
		local sPostUrl = string.format("http://weixin.xingames.com/weiphp/index.php?s=/addon/Member/Member/do_upload_remote/uid/%d/type/%d/game/td",uid,index)
		xlHttpClient_Post(sPostUrl,"post_head",pstr,pstrlen)
	end
end

--发送查询礼包状态
_ncf["gift_state"] = function(state)
	--约定好的协议ID 30301 是查询ID
	local packet = CCWritePacket:create()
	packet:writeUInt(30301)             -- 协议id
	packet:writeUInt(xlPlayer_GetUID()) -- uid
	packet:writeString(state)
	packet:writeUInt(0)
	xlNet_SendPacket(packet)
end

--输别人id用于推荐
_ncf["recommend_me"] = function(id)
	local packet = CCWritePacket:create()
	packet:writeUInt(30361)             -- 协议id
	packet:writeInt(0)
	packet:writeUInt(xlPlayer_GetUID()) -- uid
	packet:writeUInt(id)
	packet:writeInt(0)
	xlNet_SendPacket(packet)
end

--推荐玩家数据
_ncf["recommend_state"] = function()
	local packet = CCWritePacket:create()
	packet:writeUInt(30363)             -- 协议id
	packet:writeInt(0)
	packet:writeUInt(xlPlayer_GetUID()) -- uid
	packet:writeInt(0)
	xlNet_SendPacket(packet)
end

_ncf["recommend_social_new"] = function(type)
	local packet = CCWritePacket:create()
	packet:writeUInt(30368)
	packet:writeUInt(0)  -- 协议id
	packet:writeUInt(xlPlayer_GetUID()) -- uid
	packet:writeUInt(type)
	packet:writeUInt(0)  
	xlNet_SendPacket(packet)
end

--发送获得某礼包奖励
_ncf["receive_gift"] = function(type_id)
	local packet = CCWritePacket:create()
	packet:writeUInt(30351)             -- 协议id
	packet:writeUInt(xlPlayer_GetUID()) -- uid
	packet:writeUInt(type_id)
	xlNet_SendPacket(packet)
end

--发送申请符石数量
_ncf["Fstone"] = function()
	local playerDataID = luaGetplayerDataID()
	local packet = CCWritePacket:create()
	packet:writeUInt(33001)             -- 协议id
	packet:writeUInt(xlPlayer_GetUID()) -- uid
	packet:writeUInt(playerDataID)
	xlNet_SendPacket(packet)
end
--发送使用符石的数量
_ncf["useFstoneNum"] = function(shopitem_ID,shopitem_rmb,shopitem_name,shopitem_score,tagStr)
	local ticketNum = LuaSetPlayerTicketNum(shopitem_ID)
	if ticketNum == -1 then return end
	local playerDataID = luaGetplayerDataID()
	local packet = CCWritePacket:create()
	packet:writeUInt(33003)             -- 协议id
	packet:writeUInt(xlPlayer_GetUID()) -- uid
	packet:writeUInt(playerDataID)
	packet:writeUInt(shopitem_ID)
	packet:writeUInt(shopitem_rmb)
	packet:writeString(shopitem_name)
	packet:writeUInt(shopitem_score)
	packet:writeString(tagStr)
	packet:writeUInt(ticketNum)
	xlNet_SendPacket(packet)
end


--发送游戏币数量
_ncf["gamecoin"] = function()
	local packet = CCWritePacket:create()
	packet:writeUInt(30001)             -- 协议id
	packet:writeUInt(xlPlayer_GetUID()) -- uid
	xlNet_SendPacket(packet)
end

--申请VIP等级
_ncf["get_VIP_Lv"] = function()
	local packet = CCWritePacket:create()
	packet:writeUInt(30010)             -- 协议id
	xlNet_SendPacket(packet)
end

--特定type东西的领取情况
_ncf["get_type_sum"] = function(type)
	local packet = CCWritePacket:create()
	packet:writeUInt(34017)             -- 协议id
	packet:writeInt(0)
	packet:writeUInt(luaGetplayerDataID())
	packet:writeInt(type)
	xlNet_SendPacket(packet)
end

--获得VIP领取状态
_ncf["get_VIP_REC_State"] = function()
	local packet = CCWritePacket:create()
	packet:writeInt(30801)             -- 协议id
	xlNet_SendPacket(packet)
end

_ncf["send_VIP_REC_State"] = function(mode,num,pTag)
	local packet = CCWritePacket:create()
	packet:writeInt(30803)
	packet:writeShort(mode)
	packet:writeShort(num)
	packet:writeInt(pTag)
	xlNet_SendPacket(packet)
end

--发送购买商品信令
_ncf["buy_shopitem"] = function(shopitem_ID,shopitem_rmb,shopitem_name,shopitem_score,tagStr)
	local ticketNum = LuaSetPlayerTicketNum(shopitem_ID)
	if ticketNum == -1 then return end
	local packet = CCWritePacket:create()
	packet:writeUInt(30006)			-- 协议id
	packet:writeUInt(xlPlayer_GetUID())	-- uid
	packet:writeUInt(shopitem_ID)
	packet:writeUInt(shopitem_rmb)
	packet:writeString(shopitem_name)
	packet:writeUInt(shopitem_score)
	packet:writeString(tagStr)
	packet:writeUInt(ticketNum)
	packet:writeInt(tonumber(os.date("%m%d%H%M%S")))
	packet:writeUInt(4)
	packet:writeUInt(luaGetplayerDataID())
	packet:writeString(tostring(hVar.CURRENT_ITEM_VERSION))		-- 版本号
	
	if shopitem_ID > 10000 or shopitem_ID < 0 or shopitem_rmb > 1000 or shopitem_rmb < 0 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_LOG_BUYITEMERRO"],{
			font = hVar.FONTC,
			ok = function()
			end,
		})
		xlAppAnalysis("log_buyerro",0,1,"info","I:"..tostring(xlPlayer_GetUID()).."N:"..g_curPlayerName.."-1:"..tostring(shopitem_ID).."-2:"..tostring(shopitem_rmb).."-3:"..tostring(shopitem_name).."-4:"..tostring(shopitem_score).."-5:"..tostring(tagStr).."-T:"..tostring(os.date("%m%d%H%M%S")))
	end

	xlNet_SendPacket(packet)
end

--购买成功的确认信令
_ncf["buy_succeed"] = function(confirm)
	local packet = CCWritePacket:create()
	packet:writeUInt(30005)             -- 协议id
	packet:writeUInt(xlPlayer_GetUID()) -- uid
	packet:writeUInt(confirm)
	xlNet_SendPacket(packet)
end

--迁出第一步
_ncf["check_out_1"] = function(pass,coin,itag)
	local packet = CCWritePacket:create()
	packet:writeUInt(35030)			-- 协议id
	packet:writeUInt(0)	
	packet:writeUInt(xlPlayer_GetUID())	-- uid
	packet:writeString(pass)
	packet:writeInt(itag or 0)
	packet:writeInt(coin)
	xlNet_SendPacket(packet)
end

--迁入第一步
_ncf["check_in_1"] = function(id,pass,coin,itag)
	local packet = CCWritePacket:create()
	packet:writeUInt(35036)			-- 协议id
	packet:writeUInt(0)
	packet:writeInt(itag or 0)
	packet:writeUInt(id)	-- uid
	packet:writeString(pass)
	packet:writeInt(coin)
	xlNet_SendPacket(packet)
end

--发送玩家存档
_ncf["send_playdata"] = function(palyName,playerdata,playerlog,rold_id,modeInt)
	local packet = CCWritePacket:create()
	packet:writeUInt(30323)			-- 协议id
	packet:writeUInt(xlPlayer_GetUID())	-- uid
	packet:writeString(palyName)
	packet:writeByte(1)
	packet:writeUInt(modeInt or 2)		-- 标记发送的数据类型
	packet:writeUInt(rold_id)		-- 当前玩家的角色ID
	packet:writeString(playerdata)
	packet:writeString(playerlog)
	xlNet_SendPacket(packet)
end

--新的发送玩家存档 p1(s32 proctol) p2(s32 uid) p3(s32 rid) p4(s32 itype)(1data 2log) p5(itag)(保留) p6(string name) p7(string dic)
_ncf["send_playdata_new"] = function(playerName,rid,itype,itag,dic_data)
	--print("send_playdata_new:",playerName,rid,itype,itag)
	local packet = CCWritePacket:create()
	packet:writeInt(35021)			-- 协议id
	packet:writeInt(0)			-- p1(s32 proctol)
	packet:writeInt(xlPlayer_GetUID())	-- p2(s32 uid)
	packet:writeInt(rid)			-- p3(s32 rid)
	packet:writeInt(itype or 1)		-- p4(s32 itype) (1data 2log)
	packet:writeInt(itag or 0)		-- p5(itag)(保留)
	packet:writeString(playerName)		-- p6(string name)
	packet:writeString(dic_data)		-- p7(string dic)
	xlNet_SendPacket(packet)
	--print("send_playdata_new !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",playerName,rid,itype,itag)
	--hApi.SyncLog(dic_data)
end

--申请读取玩家存档
_ncf["load_playdata"] = function(palyName)
	local packet = CCWritePacket:create()
	packet:writeUInt(30321)             -- 协议id
	packet:writeUInt(xlPlayer_GetUID()) -- uid
	packet:writeString(palyName)
	packet:writeByte(1)
	packet:writeUInt(0)
	xlNet_SendPacket(packet)
end

--发送通关记录信息
_ncf["send_checkpoint_record"] = function(sendData)
	local packet = CCWritePacket:create()
	packet:writeUInt(30337)             -- 协议id
	packet:writeUInt(xlPlayer_GetUID()) -- uid
	packet:writeUInt(0)
	packet:writeString("checkpoint_record")
	packet:writeString(sendData)
	xlNet_SendPacket(packet)
end

--发送当前客户端版本号
_ncf["send_cur_version"] = function(ver)
	local packet = CCWritePacket:create()
	packet:writeUInt(30342)             -- 协议id, 专用于更新t_user table
	packet:writeUInt(0)                 -- tag
	packet:writeString("version:"..ver) -- key:value;key:value;
	xlNet_SendPacket(packet)
end

--发送当前客户端版本号
_ncf["send_cur_device_type"] = function(dev_type)
	local packet = CCWritePacket:create()
	packet:writeUInt(30342)             -- 协议id, 专用于更新t_user table
	packet:writeUInt(0)                 -- tag
	packet:writeString("dev_type:"..dev_type) -- key:value;key:value;
	xlNet_SendPacket(packet)
end

--更新数据库中的积分
_ncf["update_cur_score"] = function(playerName,score)
	local t_user = CCWritePacket:create()
	t_user:writeUInt(30342)             -- 协议id, 专用于更新t_user table
	t_user:writeUInt(0)                 -- tag
	t_user:writeString("gamescore:"..score..";customs1:"..playerName) -- key:value;key:value;
	xlNet_SendPacket(t_user)
end

--发送快用标记
_ncf["send_KYmark"] = function(state)
	local packet = CCWritePacket:create()
	packet:writeUInt(30333)             -- 协议id
	packet:writeUInt(xlPlayer_GetUID()) -- uid
	packet:writeString("isKuaiYong")
	packet:writeString(state)
	xlNet_SendPacket(packet)
end

--获取玩家存档
_ncf["get_savefile"] = function(uID,dataName,mode,roldID)
	local packet = CCWritePacket:create()
	packet:writeUInt(30321)	-- 协议id
	packet:writeUInt(uID)	-- uid
	packet:writeInt(1)	-- type 1 : 存档
	packet:writeString(dataName)	--存档名 如果没有则返回 最近一次的存档
	packet:writeByte(1)	-- dateType: 0:字符串 1：blob（大数据， 譬如存档）
	packet:writeUInt(mode or 1)
	packet:writeUInt(roldID or 0)
	xlNet_SendPacket(packet)
end

--新的获取存档 p1(s32 proctol)(0rid) p2(s32 uid) p3(s32 rid) p4(s32 itype)(1data 2log) p5(itag)(保留) p6 描述：根据rid或者uid 查询cha_dictionary记录
_ncf["get_savefile_new"] = function(uID,dataName,itype,rid,itag)
	local packet = CCWritePacket:create()
	packet:writeInt(35023)			-- 协议id
	packet:writeInt(0)			-- p1(s32 proctol) 默认0 是按照rid 获取存档
	packet:writeInt(uID or 0)		-- p2(s32 uid) uid
	packet:writeInt(rid or 0)		-- p3(s32 rid) rid
	packet:writeInt(itype or 1)		-- p4(s32 itype)(1data 2log)
	packet:writeInt(itag or 0)			-- p5(itag)(保留)
	packet:writeString(dataName or "")	-- p6(string name)
	xlNet_SendPacket(packet)
end

--更新nickname
_ncf["update_nickname"] = function(nickname)
	local unique_id = luaGetplayerUniqueID()
	local packet = CCWritePacket:create()
	packet:writeUInt(30339)
	packet:writeUInt(unique_id)

	packet:writeString("t_cha")
	packet:writeUInt(xlPlayer_GetUID())
	
	packet:writeByte(1)

	packet:writeString("nickname")
	packet:writeString(nickname)

	xlNet_SendPacket(packet)
end

_ncf["send_RoleData"] = function(playerName,score)
	local unique_id = luaGetplayerUniqueID()
	local packet = CCWritePacket:create()
	packet:writeUInt(30339)
	
	packet:writeUInt(unique_id)
	packet:writeString("t_cha")
	packet:writeUInt(xlPlayer_GetUID())
	
	local playerDataID = luaGetplayerDataID()
	if playerDataID == 0 then --插入新数据
		packet:writeByte(3)
	else
		packet:writeByte(4)
		packet:writeString("id")
		packet:writeString(tostring(playerDataID))
	end
	packet:writeString("name")
	packet:writeString(playerName)
	
	
	packet:writeString("unique_id")
	packet:writeString(tostring(unique_id))
	
	packet:writeString("gamescore")
	packet:writeString(tostring(score))
	
	xlNet_SendPacket(packet)
	
	_ncf["update_cur_score"](playerName,score)
end

_ncf["send_HeroCardData"] = function(bshare,heroID,level,data,md5)
	
	local playerDataID = luaGetplayerDataID()
	if playerDataID == 0 then --插入新数据
		return
	end
	
	local packet = CCWritePacket:create()
	packet:writeUInt(30339)
	packet:writeUInt(0)
	packet:writeString("t_hero")
	
	packet:writeUInt(playerDataID)
	packet:writeByte(5)
	
	packet:writeString("bshare")
	packet:writeString(tostring(bshare))
	
	packet:writeString("data")
	packet:writeString(data)
	
	packet:writeString("md5")
	packet:writeString(md5)
	
	packet:writeString("hero_id")
	packet:writeString(tostring(heroID))
	
	packet:writeString("iLevel")
	packet:writeString(tostring(level))
	
	xlNet_SendPacket(packet)
end

_ncf["send_PlayerBagData"] = function(BagData,md5)
	local playerDataID = luaGetplayerDataID()
	if playerDataID == 0 then --插入新数据
		return 
	end
	
	local unique_id = luaGetplayerUniqueID()
	local packet = CCWritePacket:create()
	packet:writeUInt(30339)
	packet:writeUInt(unique_id)
	packet:writeString("t_cha")
	packet:writeUInt(xlPlayer_GetUID())
	
	packet:writeByte(2)
	packet:writeString("id")
	packet:writeString(tostring(playerDataID))
	
	packet:writeString("bag")
	packet:writeString(BagData)
	
	
	xlNet_SendPacket(packet)
end

local get_dbs_data_type = {
	["bag"] = 1,
	["hero_ex_defence"] = 2,
	["unit_using"] = 3,		--返回 t_pvp 表中的英雄存取数据
}

--获取玩家表中某个字段的数据
_ncf["get_DBS_DATA"] = function(tab_name,tab_key)
	local p = CCWritePacket:create()
	p:writeUInt(30335)
	p:writeString(tab_name)
	p:writeString(tab_key)
	if tab_name == "t_cha" then
		local playerDataID = luaGetplayerDataID()
		p:writeString("id:"..playerDataID)
	elseif tab_name == "t_pvp" then
		local playerDataID = luaGetplayerDataID()
		p:writeString("id:"..playerDataID)
	end
	p:writeInt(get_dbs_data_type[tab_key] or 0) --tag
	xlNet_SendPacket(p)
end


--发送 消耗类道具的 获得 和使用次数信息
--_ncf["send_DepletionItemInfo"] = function(playerName,itemID)
	--local getCount = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..playerName.."GetDepletionItem"..itemID)
	--local useCount = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..playerName.."UseDepletionItem"..itemID)

	--local p = CCWritePacket:create()
	--p:writeUInt(30337)
	--p:writeUInt(xlPlayer_GetUID())
	--p:writeInt(0) --tag
	--p:writeString("t_baoxiang_log")
	--p:writeString("param1:"..tostring(getCount)..";param2:"..tostring(useCount))

	--xlNet_SendPacket(p)
--end

--发送 获取英雄数据的 网络信令
_ncf["send_GetHeroCardData"] = function(DataBaseID,iTag)
	local p = CCWritePacket:create()
	p:writeUInt(30343)
	p:writeUInt(DataBaseID)
	p:writeInt(iTag or 0) --tag
	xlNet_SendPacket(p)
end

_ncf["send_GetHeroCardData_RSDYZ"] = function(DataBaseID,iTag,hero1,hero2,hero3)
	Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetHeroData,luaGetplayerDataID(),DataBaseID,iTag,hero1,hero2,hero3})
end

--获取是否为测试用户的标记
_ncf["get_Account_Test"] = function()
	--[[
	local p = CCWritePacket:create()
	p:writeUInt(30331)
	p:writeString("bTester")
	p:writeUInt(1)		-- tag 标记为 获取测试用户
	xlNet_SendPacket(p)
	]]
	
	--安卓的新用法
	local packet = CCWritePacket:create()
	packet:writeInt(30022)
	packet:writeInt(0)						--protocol
	packet:writeInt(xlPlayer_GetUID())		--uid
	xlNet_SendPacket(packet)
end

--发送收到 执行function 的 tag 
_ncf["send_doLuaStrFun"] = function(iTag,errCode)
	local p = CCWritePacket:create()
	p:writeUInt(30402)
	p:writeUInt(iTag)
	p:writeString(errCode)
	xlNet_SendPacket(p)
end

--玩家行为统计 命令
_ncf["send_UserBehavior"] = function(BehaviorID)
	local p = CCWritePacket:create()
	p:writeUInt(31001)
	p:writeInt(BehaviorID)
	xlNet_SendPacket(p)
end

--p1 (protocol int) p2 (uid int) p3 (rid int) p4 (cheat_type int) p5 (info string)
--发送玩家作弊日志
_ncf["send_CheatLog"] = function(protocol,cheat_type,info)
	print("send_CheatLog")
	local p = CCWritePacket:create()
	p:writeInt(34202)
	p:writeInt(protocol)			--保留参数
	p:writeInt(xlPlayer_GetUID())		--UID
	p:writeInt(luaGetplayerDataID())	--RID
	p:writeInt(cheat_type)			--作弊类型
	p:writeString(info)			--log
	xlNet_SendPacket(p)
end

--申请设置密码
_ncf["send_UidPassWord"] = function(password)
	local packet = CCWritePacket:create()
	packet:writeInt(30333)
	packet:writeInt(xlPlayer_GetUID()) 
	packet:writeString("password") 
	packet:writeString(password)  --todo, 玩家设置的密码
	packet:writeInt(1) -- tag
	xlNet_SendPacket(packet)
end

--发送常用roldID 信息
_ncf["send_useingRoldID"] = function()
	local useingRoldIDList = LuaGetUseingRoldIDList()
	if type(useingRoldIDList) ~= "table" then return end
	local data_str = ""
	for i = 1,#useingRoldIDList do
		if i ~= 1 then
			data_str = data_str..","
		end
		data_str = data_str..useingRoldIDList[i]
	end
	
	local packet = CCWritePacket:create()
	packet:writeInt(30333)
	packet:writeInt(xlPlayer_GetUID()) 
	packet:writeString("cha_id_list") 
	packet:writeString(data_str)  --todo, 玩家设置的密码
	packet:writeInt(2) -- tag
	xlNet_SendPacket(packet)
end

_ncf["send_YM_EnterMap"] = function()
	local packet = CCWritePacket:create()
	packet:writeInt(32001)
	packet:writeInt(xlPlayer_GetUID()) 
	packet:writeInt(1) -- tag
	xlNet_SendPacket(packet)
end

_ncf["ask_7_days"] = function()
	local packet = CCWritePacket:create()
	packet:writeInt(32004)
	packet:writeInt(0)
	packet:writeInt(xlPlayer_GetUID()) 
	packet:writeInt(0) -- tag
	xlNet_SendPacket(packet)
end

--申请当前设备的支付类型
g_cur_pay_type = 0
_ncf["get_PayType"] = function()
	local p = CCWritePacket:create()
	p:writeUInt(30331)
	p:writeString("iap_type")
	p:writeUInt(2)		-- tag 标记为 获取支付类型
	xlNet_SendPacket(p)
end

--安卓，1元档
_ncf["iap_sale_gift"] = function()
	print("iap_sale_gift")
	local uid = xlPlayer_GetUID()
	local rid = luaGetplayerDataID()
	local iChannelId = getChannelInfo() or 0 --渠道号
	local iaptype = 2 --支付方式(默认:支付宝)
	
	if (iChannelId == 1) or (iChannelId == 11) then --苹果
		iaptype = 1
	elseif (iChannelId == 106) or (iChannelId == 1002) then --安卓官网、taptap
		iaptype = 2
	elseif (iChannelId >= 1003) then --安卓，从小米开始
		iaptype = iChannelId - 900
	end
	
	print("iaptype",iaptype)
	
	local packet = CCWritePacket:create()
	packet:writeInt(40108)
	packet:writeInt(2)
	packet:writeInt(iaptype)
	packet:writeInt(uid)
	packet:writeInt(rid)
	packet:writeInt(iChannelId)
	xlNet_SendPacket(packet)
end

--安卓，1元档充值
_ncf["iap_sale_gift_order"] = function(iaptype, giftid)
	local packet = CCWritePacket:create()
	packet:writeInt(40110)
	packet:writeInt(0)
	packet:writeInt(iaptype)
	packet:writeInt(giftid)
	xlNet_SendPacket(packet)
end

--ios，礼包充值确认
_ncf["iap_sale_gift_order_ios"] = function(iaptype, giftid)
	local packet = CCWritePacket:create()
	packet:writeInt(40112)
	packet:writeInt(0)
	packet:writeInt(iaptype)
	packet:writeInt(giftid)
	xlNet_SendPacket(packet)
end

--燃烧的远征 设置防守英雄
_ncf["send_DefHero_RSDYZ"] = function(heroStr)
	local playerDataID = luaGetplayerDataID()
	if playerDataID == 0 then --插入新数据
		return 
	end

	local unique_id = luaGetplayerUniqueID()
	local packet = CCWritePacket:create()
	packet:writeUInt(30339)
	packet:writeUInt(unique_id)
	packet:writeString("t_cha")
	packet:writeUInt(xlPlayer_GetUID())

	packet:writeByte(2)
	packet:writeString("id")
	packet:writeString(tostring(playerDataID))

	packet:writeString("hero_ex_defence")
	packet:writeString(heroStr)

	xlNet_SendPacket(packet)
end

--打开网络商店
_ncf["openNetShop"] = function()
	local p = CCWritePacket:create()
	p:writeUInt(33006)
	xlNet_SendPacket(p)
end

--向服务器发送执行某段脚本
_ncf["send_doLuaFunc"] = function(funcName)
	local p = CCWritePacket:create()
	p:writeUInt(30403)
	p:writeInt(xlPlayer_GetUID())
	packet:writeString(tostring(funcName))
	xlNet_SendPacket(p)
end

--发送 Checkpoint_Record 数据
_ncf["send_checkpoint"] = function(playerDataID,save_playerLog)
	if playerDataID == 0 then return end
	local checkpoint = ""
	if save_playerLog and type(save_playerLog.checkpoint_record) == "table" and type(save_playerLog.checkpoint_record[2]) == "number" and save_playerLog.checkpoint_record[2] == 0 then
		checkpoint = save_playerLog.checkpoint_record[1]
	else
		return
	end
	local packet = CCWritePacket:create()
	packet:writeUInt(31003)
	packet:writeUInt(playerDataID)
	packet:writeString(checkpoint)
	xlNet_SendPacket(packet)
end

--获取转档状态
_ncf["getWormHoleState"] = function()
	local packet = CCWritePacket:create()
	packet:writeUInt(32008)
	packet:writeInt(xlPlayer_GetUID())
	packet:writeInt(0)		--Tag
	xlNet_SendPacket(packet)
end

--设置转档状态
_ncf["check_out_state"] = function(status,itag)
	local packet = CCWritePacket:create()
	packet:writeUInt(35034)
	packet:writeInt(0)
	packet:writeInt(xlPlayer_GetUID())
	print("check_out_state",xlPlayer_GetUID())
	packet:writeInt(status)
	packet:writeInt(itag or 0)
	xlNet_SendPacket(packet)
end

--设置转档状态
_ncf["setWormHoleState"] = function(orderid,status)
	local packet = CCWritePacket:create()
	packet:writeUInt(32010)
	packet:writeInt(xlPlayer_GetUID())
	packet:writeInt(0)
	packet:writeUInt(orderid)
	packet:writeInt(status)

	xlNet_SendPacket(packet)
end

--发送获取当前版本号的接口 
_ncf["get_NweVer"] = function()
	--print("\n ======> 发送获取当前版本号的接口 get_NweVer")
	
	local bTest =  CCUserDefault:sharedUserDefault():getIntegerForKey("xl_account_test")
	local packet = CCWritePacket:create()
	packet:writeUInt(33008)
	
	if (LANGUAG_SITTING == 4) then
		packet:writeString("update_en")
	else
		--测试员、管理员标记
		if (bTest == 1) or (bTest == 2) then
			packet:writeString("update_debug")
		elseif (bTest == 0) then
			--正式标记
			packet:writeString("update_release")
		end
	end
	
	xlNet_SendPacket(packet)
end

--发送获取新通告的接口
_ncf["get_NewWebView"] = function()
	local bTest =  CCUserDefault:sharedUserDefault():getIntegerForKey("xl_account_test")
	local packet = CCWritePacket:create()
	packet:writeUInt(33008)
	
	if (LANGUAG_SITTING == 4) then
		packet:writeString("update_en")
	else
		--测试员、管理员公告
		if (bTest == 1) or (bTest == 2) then
			packet:writeString("notice_debug")
			
		else
			--正式公告
			packet:writeString("notice_release")
		end
	end
	xlNet_SendPacket(packet)
end

--发送从宝箱获得道具时的 道具ID 方便查问题
_ncf["send_getItemFromChest"] = function(itemID,count,describeinfo)
	local packet = CCWritePacket:create()
	packet:writeUInt(33010)
	packet:writeInt(xlPlayer_GetUID())
	packet:writeInt(0)
	packet:writeInt(itemID)
	packet:writeInt(count)
	packet:writeString(checkpoint)
	packet:writeInt(tonumber(os.date("%m%d%H%M%S")))
	xlNet_SendPacket(packet)
end

--cheat_fc
--cheat_fcstatus
--cheat_lv 
--cheat_mat01
--cheat_mat02
--cheat_mat03

--锻造作弊相关的查询接口 设置接口 参数分别是 角色ID，保留字，key 值， 模式 0 直接覆盖 1 增加
--_ncf["set_cheat_count"] = function(tradeid,roleid,tag,key,val,mode)
--	local packet = CCWritePacket:create()
--	packet:writeUInt(34001)
--	packet:writeInt(tradeid)
--	packet:writeInt(roleid)
--	packet:writeInt(tag)
--	packet:writeInt(1)
--	packet:writeString(key)
--	packet:writeInt(mode)
--	packet:writeInt(val)
--
--	xlNet_SendPacket(packet)
--end

--请求数据接口
_ncf["get_cheat_val"] = function(roleid,tag,key,local_data)
	if roleid == 0 then return end
	local packet = CCWritePacket:create()
	packet:writeUInt(34002)
	packet:writeInt(1)
	packet:writeInt(roleid)
	packet:writeInt(tag)
	packet:writeInt(1)		--只能查询1组 因为服务器加入了 fix 流程，所以不再支持多组数据查询
	packet:writeString(key)
	packet:writeInt(local_data or 0)
	xlNet_SendPacket(packet)
end

--发送一个锻造申请log
--_ncf["send_net_keyC_log"] = function(roleid,tag,itemID,itemName,key,val)
--	local packet = CCWritePacket:create()
--	packet:writeUInt(34004)
--	packet:writeInt(xlPlayer_GetUID())
--	packet:writeInt(roleid)
--	packet:writeInt(tag)
--	packet:writeInt(itemID)
--	packet:writeString(itemName)
--	packet:writeInt(tonumber(os.date("%m%d%H%M%S")))
--	packet:writeInt(getnetcmdcount())
--	packet:writeInt(1)	--protocol_ext
--	packet:writeString(key or "")
--	packet:writeInt(val or 0)
--	xlNet_SendPacket(packet)
--end

_ncf["send_forged_finish"] = function(roleid,tag,tradeid,exstring,flag,cheat_trace)
	local packet = CCWritePacket:create()
	packet:writeUInt(34006)
	packet:writeInt(xlPlayer_GetUID())
	packet:writeInt(roleid)
	packet:writeInt(tag)
	packet:writeInt(tradeid)
	packet:writeString(exstring or "")
	packet:writeInt(flag)
	packet:writeString(cheat_trace or "")
	xlNet_SendPacket(packet)
end

--设置玩家表中 锻造材料消耗数量
_ncf["Add_forged_mat_val"] = function(roleid,tag,mat1,mat2,mat3)
	local packet = CCWritePacket:create()
	packet:writeUInt(34001)
	packet:writeInt(0)			--int型tag,用来传输订单号，不需要订单号的用0区分 
	packet:writeInt(roleid)
	packet:writeInt(tag)
	packet:writeInt(3)

	packet:writeString("cheat_mat01")
	packet:writeInt(1)
	packet:writeInt(mat1)
	packet:writeString("cheat_mat02")
	packet:writeInt(1)
	packet:writeInt(mat2)
	packet:writeString("cheat_mat03")
	packet:writeInt(1)
	packet:writeInt(mat3)

	xlNet_SendPacket(packet)
end

--查询是否为作弊用户
_ncf["get_cheatflag"] = function()
	local packet = CCWritePacket:create()
	packet:writeUInt(34007)
	packet:writeUInt(xlPlayer_GetUID())
	packet:writeUInt(0)
	xlNet_SendPacket(packet)
end

--查询地图包是否购买过
_ncf["check_DLC"] = function(tag1,tag2,mapBagID)
	local packet = CCWritePacket:create()
	packet:writeUInt(33011)
	packet:writeUInt(xlPlayer_GetUID())
	packet:writeUInt(tag1)
	packet:writeUInt(tag2)
	packet:writeUInt(mapBagID)
	xlNet_SendPacket(packet)
end

--vip领取战术技能卡的协议 mode == 0 获取 mode == 1 换
_ncf["get_VIP_FBC"] = function(tag1,gameScore,itemID,mode)
	local ticketNum = LuaSetPlayerTicketNum(itemID)
	if ticketNum == -1 then return end

	local packet = CCWritePacket:create()
	packet:writeUInt(33013)
	packet:writeUInt(xlPlayer_GetUID())
	packet:writeUInt(tag1)
	packet:writeUInt(gameScore)
	packet:writeUInt(itemID)
	packet:writeUInt(mode)
	packet:writeInt(tonumber(os.date("%m%d%H%M%S")))
	xlNet_SendPacket(packet)
end

--获取网络宝箱数据
_ncf["get_chest_net_num"] = function(tagN,roleid,tagM)
	local packet = CCWritePacket:create()
	packet:writeUInt(34009)
	packet:writeUInt(tagN)
	packet:writeUInt(roleid)
	packet:writeInt(tagM)
	xlNet_SendPacket(packet)
end

--发起查询 描述：根据uid 查询prize表中该uid used为0的所有记录
_ncf["get_prize_list"] = function()
	--local packet = CCWritePacket:create()
	--packet:writeInt(30311)
	--packet:writeInt(0)
	--packet:writeUInt(xlPlayer_GetUID())
	--packet:writeInt(0)
	--xlNet_SendPacket(packet)

	local iChannelId = getChannelInfo()
	local packet = CCWritePacket:create()
	packet:writeInt(30311)
	packet:writeInt(2)
	packet:writeUInt(xlPlayer_GetUID())
	packet:writeInt(iChannelId)
	packet:writeInt(g_Cur_Language-1)		--ilanguage -- 0简中 1繁中 2英文
	xlNet_SendPacket(packet)
end

-- 描述：根据uid 和 prizeid 查找prize表 设置领取标志为1 如果是金币则直接添加 其他由客户端来派送
_ncf["set_prize_list"] = function(prizeid,roleid)
	local packet = CCWritePacket:create()
	packet:writeInt(30313)
	packet:writeInt(0)
	packet:writeUInt(xlPlayer_GetUID())
	packet:writeUInt(prizeid)
	packet:writeInt(0)
	packet:writeInt(roleid)
	xlNet_SendPacket(packet)
end

-- 描述：根据uid 和 prizeid 查找prize表 设置领取标志为2 表示客户端已经完成派送物品流程
_ncf["confirm_prize_list"] = function(prizeid)
	local packet = CCWritePacket:create()
	packet:writeInt(30315)
	packet:writeInt(0)
	packet:writeUInt(xlPlayer_GetUID())
	packet:writeUInt(prizeid)
	packet:writeInt(0)
	xlNet_SendPacket(packet)
end

--查询t_user表中对应的开关
_ncf["get_autoSave_status"] = function()
	local packet = CCWritePacket:create()
	packet:writeInt(32027)
	packet:writeInt(0)
	packet:writeUInt(xlPlayer_GetUID())
	packet:writeInt(tagN or 0)
	xlNet_SendPacket(packet)
end

-- 发起 log_chadic_autoget表中是否有记录
_ncf["make_autoSave_log"] = function(roleid,tagN)
	local packet = CCWritePacket:create()
	packet:writeInt(32021)
	packet:writeInt(1)
	packet:writeUInt(xlPlayer_GetUID())
	packet:writeUInt(roleid or 0)
	packet:writeInt(tagN or 0)
	xlNet_SendPacket(packet)
end

--设置 自动恢复存档表的状态 2 是 确定 3 是 取消 
_ncf["set_autoSave_status"] = function(logid,status,tagN)
	local packet = CCWritePacket:create()
	packet:writeInt(32029)
	packet:writeInt(0)
	packet:writeUInt(xlPlayer_GetUID())
	packet:writeUInt(logid)
	packet:writeInt(status)
	packet:writeInt(tagN or 0)
	xlNet_SendPacket(packet)
end

-- 发起 查询最近的一份存档列表
--_ncf["get_DBSaveFileList"] = function(roleid,tagN)
	--if roleid == 0 then return end
	--local packet = CCWritePacket:create()
	--packet:writeInt(32023)
	--packet:writeInt(0)
	--packet:writeUInt(xlPlayer_GetUID())
	--packet:writeUInt(roleid)
	--packet:writeInt(tagN or 0)
	--xlNet_SendPacket(packet)
--end

-- 发起恢复流程
_ncf["get_DBSaveFileByRid"] = function(roleid,tagN,log_id,dic_id)
	local packet = CCWritePacket:create()
	packet:writeInt(32025)
	packet:writeInt(0)
	packet:writeUInt(xlPlayer_GetUID())
	packet:writeUInt(roleid)
	packet:writeInt(tagN or 0)
	packet:writeInt(log_id)
	packet:writeInt(dic_id)
	xlNet_SendPacket(packet)
end

--登陆
_ncf["Login_RoldID"] = function(roleid)
	if roleid == 0 then return end
	local packet = CCWritePacket:create()
	packet:writeInt(1002)
	packet:writeInt(0)
	packet:writeUInt(roleid)
	packet:writeInt(0)
	xlNet_SendPacket(packet)

end

--渠道信息
_ncf["channel_info"] = function(channelid,flag,itag)
	local packet = CCWritePacket:create()
	packet:writeInt(32031)
	packet:writeInt(0)
	packet:writeUInt(xlPlayer_GetUID())
	packet:writeInt(channelid)
	packet:writeInt(flag)
	packet:writeInt(itag or 0)
	xlNet_SendPacket(packet)
end

--红装领取
_ncf["log_heroequip"] = function(roleid,type,num,strTag)
	local packet = CCWritePacket:create()
	packet:writeInt(34013)
	packet:writeInt(0)
	packet:writeUInt(roleid)
	packet:writeInt(type)
	packet:writeInt(num or 1)
	packet:writeString(strTag or "")
	packet:writeInt(tonumber(os.date("%m%d%H%M%S")))
	packet:writeInt(itag or 0)
	xlNet_SendPacket(packet)
end

--红装领取的结果确认
_ncf["log_heroequip_finish"] = function(logid,flag,itag,strTag)
	local packet = CCWritePacket:create()
	packet:writeInt(34015)
	packet:writeInt(0)
	packet:writeUInt(logid)
	packet:writeInt(flag)
	packet:writeInt(itag or 0)
	packet:writeString(strTag or "")
	xlNet_SendPacket(packet)
end

--t_cha removed 删除存档协议
_ncf["delete_cha_rid"] = function(roleid,itag)
	local packet = CCWritePacket:create()
	packet:writeInt(32034)
	packet:writeInt(0)
	packet:writeUInt(xlPlayer_GetUID())
	packet:writeUInt(roleid)
	--packet:writeInt(tonumber(os.date("%m%d%H%M%S")))
	packet:writeInt(0)
	packet:writeInt(itag or 0)
	xlNet_SendPacket(packet)
end

--查询该uid下的最后更新存档的rid
_ncf["check_cha_rid"] = function(itag)
	local packet = CCWritePacket:create()
	packet:writeInt(32032)
	packet:writeInt(0)
	packet:writeUInt(xlPlayer_GetUID())
	packet:writeInt(itag or 0)
	xlNet_SendPacket(packet)
end

--自动恢复存档流程中的 26回执信息
_ncf["auto_saveFile_finishi"] = function(logid,roleid)
	local packet = CCWritePacket:create()
	packet:writeInt(32030)
	packet:writeInt(0)
	packet:writeUInt(xlPlayer_GetUID())
	packet:writeUInt(logid)
	packet:writeInt(roleid)
	xlNet_SendPacket(packet)
end

--邮件领取协议
_ncf["sysMailOpen"] = function(itag,aid,mail_type)
	local packet = CCWritePacket:create()
	packet:writeInt(30316)
	packet:writeInt(0)
	packet:writeUInt(xlPlayer_GetUID())
	packet:writeInt(itag or 0)
	packet:writeUInt(aid)
	packet:writeInt(mail_type)
	
	xlNet_SendPacket(packet)
end

--获取商品购买状态
_ncf["getShopState"] = function(itag)
	local packet = CCWritePacket:create()
	packet:writeInt(34020)
	packet:writeInt(0)
	packet:writeUInt(xlPlayer_GetUID())
	packet:writeUInt(luaGetplayerDataID())
	packet:writeInt(itag or 0)
	xlNet_SendPacket(packet)
end

--设置商品购买状态
_ncf["setShopState"] = function(state,itag)
	local packet = CCWritePacket:create()
	packet:writeInt(34022)
	packet:writeInt(0)
	packet:writeUInt(xlPlayer_GetUID())
	packet:writeUInt(luaGetplayerDataID())
	packet:writeInt(itag or 0)
	packet:writeString(state or "")
	xlNet_SendPacket(packet)
end

--新的订单系统 40000
_ncf["order_begin"] = function(order_type,shopitem_ID,shopitem_coin,shopitem_num,shopitem_name,shopitem_score,LC,strTag)
	local packet = CCWritePacket:create()
	packet:writeInt(40000)						-- 协议ID
	packet:writeInt(0)						-- protocol
	packet:writeInt(order_type)					-- type
	packet:writeInt(xlPlayer_GetUID())				-- uid
	packet:writeInt(luaGetplayerDataID())				-- rid
	packet:writeInt(shopitem_ID)					-- item_ID
	packet:writeInt(shopitem_num or 1)				-- item_num
	packet:writeString(shopitem_name or "")				-- item_name
	packet:writeInt(shopitem_coin or 0)				-- coin
	packet:writeInt(shopitem_score or 0)				-- score
	packet:writeInt(tonumber(os.date("%m%d%H%M%S")))		-- check_time
	packet:writeInt(getnetcmdcount())				-- check_cmd
	packet:writeInt(LC or 0)					-- check_client		相匹配的客户端校验值
	packet:writeInt(0)						-- check_server		服务器校验值 暂时填0
	packet:writeString(tostring(hVar.CURRENT_ITEM_VERSION))		-- check_version	版本号
	packet:writeString(strTag or "")				-- ext_1		字符串参数
	xlNet_SendPacket(packet)
end

--订单系统的状态更新函数
_ncf["order_update"] = function(order_id,flag,strTag)
	local packet = CCWritePacket:create()
	packet:writeInt(40002)						-- 协议ID
	packet:writeUInt(0)						-- protocol
	packet:writeInt(order_id)					-- order_id
	packet:writeInt(flag)					-- flag
	packet:writeString(strTag or "")				-- ext_1		字符串参数
	xlNet_SendPacket(packet)
end

--设置t_cha表的装备属性 项目 有 一下内容 可供查询，但是目前不需要
--[[1 ENMSG_SCRIPT_ID_EXT_STATISTIC_GET_REQ 34024
	参数：p1(s32 proctol) p2(u32 uid) p3(u32 rid) p4(s32 itag)
	描述：根据uid及rid 查询t_cha表中该ext_statistic字段信息
2 ENMSG_SCRIPT_ID_EXT_STATISTIC_GET_RES 34025
	参数：p1(s32 proctol) p2(u32 uid) p3(u32 rid) p4(s32 itag) p5(s32 errcode)[0成功] [p6 string info]
	描述：34024的回应包 返回以上数据
3 ENMSG_SCRIPT_ID_EXT_STATISTIC_SET_REQ 34026
	参数：p1(s32 proctol) p2(u32 uid) p3(u32 rid) p4(s32 itag) p5(string info)
	描述：根据uid及rid 设置t_cha表中该ext_statistic字段信息
4 ENMSG_SCRIPT_ID_EXT_STATISTIC_SET_RES 34027
	参数：p1(s32 proctol) p2(u32 uid) p3(u32 rid) p4(s32 itag) p5(s32 errcode)
	描述：34026的回应包 返回以上数据--]]
_ncf["UpdateEquipInfo"] = function(ext_statistic,itag)
	local packet = CCWritePacket:create()
	packet:writeInt(34026)
	packet:writeInt(0)
	packet:writeUInt(xlPlayer_GetUID())
	packet:writeUInt(luaGetplayerDataID())
	packet:writeInt(itag or 0)
	packet:writeString(ext_statistic or "")
	xlNet_SendPacket(packet)
end

--t_cha 表中的 能量值查询接口 ENMSG_SCRIPT_ID_CHA_GET
_ncf["ENMSG_SCRIPT_ID_CHA_GET"] = function(key,ptype)
	local packet = CCWritePacket:create()
	packet:writeInt(50000)
	packet:writeInt(0)
	packet:writeInt(xlPlayer_GetUID())
	packet:writeInt(luaGetplayerDataID())
	packet:writeString(key or "")
	packet:writeInt(ptype or 0)			-- 标记取的字段是 int 还是 string 0 代表 int 1 代表 string
	xlNet_SendPacket(packet)
end

--t_cha 表中的 能量值设置接口
_ncf["ENMSG_SCRIPT_ID_CHA_SET"] = function(key,ptype,val)
	local packet = CCWritePacket:create()
	packet:writeInt(50002)
	packet:writeInt(0)
	packet:writeInt(xlPlayer_GetUID())
	packet:writeInt(luaGetplayerDataID())
	packet:writeString(key or "")
	packet:writeInt(ptype or 0)			-- 标记设置的字段是 int 还是 string 0 代表 int 1 代表 string
	
	if ptype == 0 then
		packet:writeInt(val or 0)
	elseif ptype == 1 then
		packet:writeString(val or "")
	end
	
	xlNet_SendPacket(packet)
end



--更新礼包领取的状态
--_ncf["gift_code_confirm"] = function(key)
--	local packet = CCWritePacket:create()
--	packet:writeInt(30202)
--	packet:writeInt(0)
--	packet:writeString(key)
--	xlNet_SendPacket(packet)
--
--end
--
--获取活动列表
_ncf["get_ActivityList"] = function(ilanguage)
	local packet = CCWritePacket:create()
	packet:writeInt(35011)
	packet:writeInt(0)			--protocol
	packet:writeInt(xlPlayer_GetUID())	--uid
	packet:writeInt(luaGetplayerDataID())	--rid
	packet:writeInt(0)			--itag
	packet:writeInt(ilanguage or 0)		--ilanguage -- 0简中 1繁中 2英文
	xlNet_SendPacket(packet)
end

--获取活动进度
_ncf["get_ActivityRate"] = function(aid, ptype)
	local packet = CCWritePacket:create()
	packet:writeInt(35013)
	packet:writeInt(0)			--protocol
	packet:writeInt(xlPlayer_GetUID())	--uid
	packet:writeInt(luaGetplayerDataID())	--rid
	packet:writeInt(aid)
	packet:writeInt(ptype or 0)		--itag
	xlNet_SendPacket(packet)
end

--发起迁移流程
_ncf["SyncData_Begin"] = function(uid_to,password_to)
	local packet = CCWritePacket:create()
	packet:writeInt(32006)
	packet:writeInt(0)			--protocol
	packet:writeInt(itag or 0)		--itag
	packet:writeInt(xlPlayer_GetUID())	--uid_from
	packet:writeInt(uid_to)			--uid_to
	packet:writeString(password_to)		--password_to
	
	xlNet_SendPacket(packet)
end

--开启地图包是否打折的查询
_ncf["GetMapBagOff"] = function(itemID)
	hUI.NetDisable(9999)
	local packet = CCWritePacket:create()
	packet:writeInt(33015)
	packet:writeInt(0)			--protocol
	packet:writeInt(xlPlayer_GetUID())	--uid
	packet:writeInt(itemID)			--itemID
	packet:writeInt(itag or 0)		--itag
	
	xlNet_SendPacket(packet)
end

--领取策马守天关体验奖励
_ncf["GetCMSTGPlayReward"] = function(toUid,toPass,itag)
	local packet = CCWritePacket:create()
	packet:writeInt(37000)
	packet:writeInt(0)			--protocol
	packet:writeInt(xlPlayer_GetUID())	--uid
	packet:writeInt(toUid)			--toUid
	packet:writeString(toPass)			--toPass
	packet:writeInt(itag or 0)		--itag	
	xlNet_SendPacket(packet)
end

--获取观看广告时间
_ncf["GetAdsTime"] = function()
	local packet = CCWritePacket:create()
	packet:writeInt(36050)
	packet:writeInt(0)			--protocol
	packet:writeInt(xlPlayer_GetUID())	--uid
	xlNet_SendPacket(packet)
end

--重置广告时间
_ncf["ResetAdsTime"] = function()
	local packet = CCWritePacket:create()
	packet:writeInt(36052)
	packet:writeInt(0)			--protocol
	packet:writeInt(xlPlayer_GetUID())	--uid
	xlNet_SendPacket(packet)
end

--log协议
_ncf["C2S_LOG"] = function(errStr)
	local packet = CCWritePacket:create()
	packet:writeInt(4444)
	packet:writeInt(xlPlayer_GetUID())
	packet:writeString(errStr)
	xlNet_SendPacket(packet)
	
end

--更新战车得分
_ncf["send_tank_socre"] = function(bId, diff, stage, tankId, weaponId, gametime, scientistNum, goldNum, killNum)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		if (goldNum > 0) then --有得分才上传
			--显示名
			local curMyName = ""
			local playerInfo = LuaGetPlayerByName(g_curPlayerName)
			if playerInfo and (playerInfo.showName) then
				curMyName = playerInfo.showName
			end
			if (curMyName == "") then --没有名字
				curMyName = hVar.tab_string["guest"] .. tostring(uId)
			end
			if (curMyName == hVar.tab_string["guest"]) then --"User"
				curMyName = hVar.tab_string["guest"] .. tostring(uId)
			end
			
			local info = ""
			info = info .. tostring(uId) .. ";"
			info = info .. tostring(rId) .. ";"
			info = info .. tostring(bId) .. ";"
			info = info .. tostring(diff) .. ";"
			info = info .. tostring(hApi.StringEncodeEmoji(curMyName)) .. ";" --处理表情
			info = info .. tostring(stage) .. ";"
			info = info .. tostring(tankId) .. ";"
			info = info .. tostring(weaponId) .. ";"
			info = info .. tostring(gametime) .. ";"
			info = info .. tostring(scientistNum) .. ";"
			info = info .. tostring(goldNum) .. ";"
			info = info .. tostring(killNum) .. ";"
			
			_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_UPDATE_TANK_SCORE, info)
		end
	end
end

--查询战车排行榜
_ncf["query_tank_billboard"] = function(bId, diff)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(bId) .. ";"
		info = info .. tostring(diff) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_BILLBOARD, info)
	end
end

--战车改名
_ncf["modify_tank_username"] = function(name, gamecoin)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		--显示名
		local curMyName = ""
		local playerInfo = LuaGetPlayerByName(g_curPlayerName)
		if playerInfo and (playerInfo.showName) then
			curMyName = playerInfo.showName
		end
		if (curMyName == "") then --没有名字
			curMyName = hVar.tab_string["guest"] .. tostring(uId)
		end
		if (curMyName == hVar.tab_string["guest"]) then --"User"
			curMyName = hVar.tab_string["guest"] .. tostring(uId)
		end
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(hApi.StringEncodeEmoji(name)) .. ";" --处理表情
		info = info .. tostring(hApi.StringEncodeEmoji(curMyName)) .. ";" --处理表情
		info = info .. tostring(gamecoin or 0) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_MODIFY_TANK_USERNAME, info)
	end
end

--订单状态更新（新）
_ncf["order_update_new"] = function(order_id, flag, strTag)
	if (order_id > 0) then
		local uId = xlPlayer_GetUID()				--我的uid
		local rId = luaGetplayerDataID()			--我使用角色rid
		
		if uId and rId and (uId > 0) and (rId > 0) then
			local info = ""
			info = info .. tostring(uId) .. ";"
			info = info .. tostring(rId) .. ";"
			info = info .. tostring(order_id) .. ";"
			info = info .. tostring(flag) .. ";"
			info = info .. tostring(strTag)
			
			_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_ORDER_UPDATE, info)
		end
	end
end

--上传战车关卡日志
_ncf["upload_stage_log"] = function(logId, versionId, strLog)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		--显示名
		local curMyName = ""
		local playerInfo = LuaGetPlayerByName(g_curPlayerName)
		if playerInfo and (playerInfo.showName) then
			curMyName = playerInfo.showName
		end
		if (curMyName == "") then --没有名字
			curMyName = hVar.tab_string["guest"] .. tostring(uId)
		end
		if (curMyName == hVar.tab_string["guest"]) then --"User"
			curMyName = hVar.tab_string["guest"] .. tostring(uId)
		end
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(hApi.StringEncodeEmoji(curMyName)) .. ";" --处理表情
		info = info .. tostring(logId) .. ";"
		info = info .. tostring(versionId) .. ";"
		info = info .. tostring(strLog) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_UPLOAD_TANK_STAGELOG, info)
	end
end

--上传战车积分信息
_ncf["upload_score_info"] = function(strScoreInfo)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		--显示名
		local curMyName = ""
		local playerInfo = LuaGetPlayerByName(g_curPlayerName)
		if playerInfo and (playerInfo.showName) then
			curMyName = playerInfo.showName
		end
		if (curMyName == "") then --没有名字
			curMyName = hVar.tab_string["guest"] .. tostring(uId)
		end
		if (curMyName == hVar.tab_string["guest"]) then --"User"
			curMyName = hVar.tab_string["guest"] .. tostring(uId)
		end
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(hApi.StringEncodeEmoji(curMyName)) .. ";" --处理表情
		info = info .. tostring(strScoreInfo) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_UPLOAD_TANK_SCOREINFO, info)
	end
end

--查询战车昨日排行榜排名
_ncf["query_yesterday_rank"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_QUERY_TANK_YESTERDAY_RANK, info)
	end
end

--领取战车昨日排行榜排名奖励
_ncf["reward_yesterday_rank"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REWARD_TANK_YESTERDAY_RANK, info)
	end
end

--战车获取武器枪服务器数据同步
_ncf["tank_sync_weapon_info"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_QUERY_TANK_WEAPON_INFO, info)
	end
end

--请求战车武器枪升星
_ncf["tank_weapon_starup"] = function(weaponId)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(weaponId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_WEAPON_STARUP, info)
	end
end

--[[
--请求战车武器枪加经验值
_ncf["tank_weapon_addexp"] = function(weaponId, expAdd)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(weaponId) .. ";"
		info = info .. tostring(expAdd) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_WEAPON_ADDEXP, info)
	end
end
]]

--请求战车武器枪升级
_ncf["tank_weapon_levelup"] = function(weaponId)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(weaponId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_WEAPON_LEVELUP, info)
	end
end

--战车获取技能点数服务器数据同步
_ncf["tank_sync_talentpoint_info"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_QUERY_TANK_TALENTPOINT_INFO, info)
	end
end

--战车加经验值
_ncf["tank_talentpoint_addexp"] = function(tankId, expAdd)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(tankId) .. ";"
		info = info .. tostring(expAdd) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_TALENTPOINT_ADDEXP, info)
	end
end

--战车分配天赋点数
_ncf["tank_talentpoint_addpoint"] = function(tankId, talentId)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(tankId) .. ";"
		info = info .. tostring(talentId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_TALENTPOINT_ADDPOINT, info)
	end
end

--战车重置天赋点数
_ncf["tank_talentpoint_restore"] = function(tankId)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(tankId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_TALENTPOINT_RESTORE, info)
	end
end

--战车获取宠物服务器数据同步
_ncf["tank_sync_pet_info"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_QUERY_TANK_PET_INFO, info)
	end
end

--请求战车宠物升星
_ncf["tank_pet_starup"] = function(petId)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(petId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_PET_STARUP, info)
	end
end

--[[
--请求战车宠物加经验值
_ncf["tank_pet_addexp"] = function(petId, expAdd)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(petId) .. ";"
		info = info .. tostring(expAdd) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_PET_ADDEXP, info)
	end
end
]]

--请求战车宠物升级
_ncf["tank_pet_levelup"] = function(petId)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(petId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_PET_LEVELUP, info)
	end
end

--战车获取战术卡服务器数据同步
_ncf["tank_sync_tactic_info"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_QUERY_TANK_TACTIC_INFO, info)
	end
end

--请求战车战术卡升级
_ncf["tank_tactic_levelup"] = function(tacticId)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(tacticId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_TACTIC_LEVELUP, info)
	end
end

--请求清除数据
_ncf["tank_cleardata"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_CLEARDATA, info)
	end
end

--请求战车宠物挖矿
_ncf["tank_pet_send_wakuang"] = function(petId)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(petId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_PET_WAKUANG, info)
	end
end

--请求战车宠物挖体力
_ncf["tank_pet_send_watili"] = function(petId)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(petId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_PET_WATILI, info)
	end
end

--请求战车宠物取消挖矿
_ncf["tank_pet_send_cancel_wakuang"] = function(petId)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(petId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_PET_CANCEL_WAKUANG, info)
	end
end

--请求战车宠物取消挖体力
_ncf["tank_pet_send_cancel_watili"] = function(petId)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(petId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_PET_CANCEL_WATILI, info)
	end
end

--请求查询体力产量信息
_ncf["tank_reqiure_tili_info"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_TILI_INFO, info)
	end
end

--请求兑换体力
_ncf["tank_exchange_tili"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_TILI_EXCHANGE, info)
	end
end

--请求领取挖矿氪石
_ncf["tank_addones_keshi"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_ADDONES_KESHI, info)
	end
end

--请求领取挖矿体力
_ncf["tank_addones_tili"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_ADDONES_TILI, info)
	end
end

--请求领取挖矿宝箱
_ncf["tank_addones_chest"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_ADDONES_CHEST, info)
	end
end

--请求查询玩家当前的称号
_ncf["require_query_champion"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_USER_CHAMPION_INFO,info)
	end
end

--请求查询任务（新）进度
_ncf["task_type_query"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		local iChannelId = getChannelInfo() --渠道号
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(iChannelId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TASK_QUERY_STATE,info)
	end
end

--请求增加任务（新）进度
_ncf["task_type_finish"] = function(taskType, addCount)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(taskType) .. ";"
		info = info .. tostring(addCount) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TASK_TYPE_FINISH,info)
	end
end

--请求完成任务（新）领取奖励
_ncf["task_type_takereward"] = function(taskId)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(taskId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TASK_TAKEREWARD,info)
	end
end

--请求一键领取全部已达成任务（新）的奖励
_ncf["task_type_takereward_all"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TASK_TAKEREWARD_ALL,info)
	end
end

--请求领取周任务（新）进度奖励
_ncf["taskstone_week_takereward"] = function(index)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(index) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TASK_WEEK_REWARD,info)
	end
end

--请求领取评价奖励（新）
_ncf["comment_takereward"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(index) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_TAKEREWAED,info)
	end
end

--管理员调试指令
--debug
_ncf["gm_debug"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_DEBUG,info)
	end
end

_ncf["require_playgopher"] = function(diff)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(diff) .. ";"

		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_PLAYGOPHER,info)
	end
end

_ncf["require_gamegopher_reward"] = function(diff,score)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()
	if uId and rId and uId > 0 and rId > 0 then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(diff) .. ";"
		info = info .. tostring(score) .. ";"

		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_GAMEGOPHER_REWARD,info)
	end
end

--本地查询新玩家14日签到活动，今日是否可以领取奖励
_ncf["request_activity_today_state"] = function(aid)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()				--我使用角色rid
	if uId and rId and aid and uId > 0 and rId > 0 and aid > 0 then
		local info = ""
		local iChannelId = getChannelInfo() --渠道号
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(aid) .. ";"
		info = info .. tostring(iChannelId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_ACTIVITY_TODAY_STATE,info)
	end
end

--新玩家14日签到活动今日签到
_ncf["request_activity_today_signin"] = function(aid, progress)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()				--我使用角色rid
	if uId and rId and aid and progress and uId > 0 and rId > 0 and aid > 0 and (progress > 0) then
		local info = ""
		local iChannelId = getChannelInfo() --渠道号
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(aid) .. ";"
		info = info .. tostring(iChannelId) .. ";"
		info = info .. tostring(progress) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_ACTIVITY_TODAY_SIGNIN,info)
	end
end

--新玩家14日签到活动购买特惠礼包
_ncf["request_activity_signin_buygift"] = function(aid, progress)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()				--我使用角色rid
	if uId and rId and aid and progress and uId > 0 and rId > 0 and aid > 0 and (progress > 0) then
		local info = ""
		local iChannelId = getChannelInfo() --渠道号
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(aid) .. ";"
		info = info .. tostring(iChannelId) .. ";"
		info = info .. tostring(progress) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_ACTIVITY_SIGNIN_BUYGIFT,info)
	end
end

--查询系统邮件列表（新）
_ncf["get_system_mail_list"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		local iChannelId = getChannelInfo() --渠道号
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(iChannelId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_SYSTEM_MAIL_LIST,info)
	end
end

--请求一键领取全部邮件
_ncf["takereward_all_system_mail_prize"] = function(totalNum, strIdList)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		local iChannelId = getChannelInfo() --渠道号
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(iChannelId) .. ";"
		info = info .. tostring(totalNum) .. ";"
		info = info .. tostring(strIdList) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_SYSTEM_MAIL_REWAR_ALL,info)
	end
end

--请求查询玩家特惠购买道具列表
_ncf["require_giftequip_info"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		local iChannelId = getChannelInfo() --渠道号
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(iChannelId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_GIFT_EQUIP_INFO,info)
	end
end

--玩家请求购买特惠道具商品
_ncf["require_gift_equip_buyitem"] = function(shopIdx)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		local iChannelId = getChannelInfo() --渠道号
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(iChannelId) .. ";"
		info = info .. tostring(shopIdx) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_GIFT_EQUIP_BUYITEM,info)
	end
end

--玩家请求领取分享奖励
_ncf["require_share_takereward"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		local iChannelId = getChannelInfo() --渠道号
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(iChannelId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_SHARE_REWARD,info)
	end
end

--请求添加碎片（仅管理员可用）
_ncf["gm_add_debris"] = function(debirsNum)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		local iChannelId = getChannelInfo() --渠道号
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(debirsNum) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_GM_ADDDEBRIS,info)
	end
end

--战车上传战斗结果数据
_ncf["tank_send_game_result"] = function(strGameInfo)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(strGameInfo) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_SEND_GAMEEND_INFO, info)
	end
end

--战车获取地图服务器数据同步
_ncf["tank_sync_map_info"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_QUERY_TANK_MAP_INFO, info)
	end
end

--请求游戏中战车复活
_ncf["tank_require_rebirth"] = function(battlecfg_id)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	--if uId and rId and (uId > 0) and (rId > 0) then
	if uId and rId and (uId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(battlecfg_id) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_REBIRTH, info)
	end
end

--请求查询成就完成情况
_ncf["achievement_query_info"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_ACHIEVEMENT_QUERY,info)
	end
end

--请求领取成就奖励
_ncf["achievement_takereward"] = function(medalId)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(medalId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_ACHIEVEMENT_TAKEREWARD,info)
	end
end

--查询月卡和月卡每日领奖
_ncf["query_month_card"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and (uId > 0) and (rId > 0) then
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_MONTH_CARD, info)
	end
end

--人族无敌/守卫剑阁/双人守卫剑阁/决战虚鲲 重抽卡片
_ncf["renzuwudi_redrawcard"] = function(unitId, wave)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(unitId) .. ";"
		info = info .. tostring(wave) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_RENZUWUDI_REDRAWCARD,info)
	end
end

--[[
--请求查询随机迷宫排行榜
_ncf["query_randommap_billboard"] = function()
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_RANDOMMAP_BOLLBOARD,info)
	end
end
]]



























--安卓，同步存档日志
_ncf["android_savelog"] = function(block, notice)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	if uId and rId and uId > 0 and rId > 0 then
		
		local info = ""
		info = info .. tostring(uId) .. ";"
		info = info .. tostring(rId) .. ";"
		info = info .. tostring(block) .. ";"
		info = info .. tostring(notice) .. ";"
		
		--print("android_savelog:",info)
		
		_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_ANDROID_SAVE_LOG, info)
	end
end

--如果改变游戏币则会再次获取游戏币
xlLuaEvent_IAPResult = function()
	if g_vs_number > 4 then
		_ncf["gamecoin"]()
	else
		if g_phone_mode ~= 0 then
			hVar.ROLE_PLAYER_GOLD = xlGetGameCoinNum() --存储本地金币数量
			hGlobal.event:event("LocalEvent_Phone_SetCurGameCoin_Game",xlGetGameCoinNum())
		else
			hVar.ROLE_PLAYER_GOLD = xlGetGameCoinNum() --存储本地金币数量
			hGlobal.event:event("LocalEvent_SetCurGameCoin",xlGetGameCoinNum())
		end
	end
end

local _xlSendIosReceipt_count = 0

function xlOnNetPacket(packet)
	local log_temp_uid = xlPlayer_GetUID()
	local id = packet:readUInt()
	--print("********rev packet: id:"..id)
	local nolocaldataRS = 0
	--允许部分协议在没有本地数据时执行
	for i = 1,#hVar.NoLocalDataID do
		if id == hVar.NoLocalDataID[i] then
			nolocaldataRS = 1
			break
		end
	end
	
	--[[
	if (id == 32005) or (id == 32007) then
		local strText = "xlOnNetPacket(), id=" .. tostring(id)
		hGlobal.UI.MsgBox(strText,{
			font = hVar.FONTC,
			ok = function()
				--
			end,
		})
	end
	]]
	
	if nolocaldataRS == 0 then
		if g_curPlayerName == nil and log_temp_uid ~= 0 then 
			--[[
			local strText = "return 1"
			hGlobal.UI.MsgBox(strText,{
				font = hVar.FONTC,
				ok = function()
					--
				end,
			})
			]]
			xlAppAnalysis("log_xlonnetpacket_return",0,1,"info-","uID:"..tostring(log_temp_uid).."-g_curPlayerName is nil-T:"..tostring(os.date("%m%d%H%M%S")))
			return 
		end
		if Save_PlayerData == nil and log_temp_uid ~= 0 then 
			--[[
			local strText = "return 2"
			hGlobal.UI.MsgBox(strText,{
				font = hVar.FONTC,
				ok = function()
					--
				end,
			})
			]]
			xlAppAnalysis("log_xlonnetpacket_return",0,1,"info-","uID:"..tostring(log_temp_uid).."-Save_PlayerData is nil-T:"..tostring(os.date("%m%d%H%M%S")))
			return
		end
		if Save_playerList == nil and log_temp_uid ~= 0 then 
			--[[
			local strText = "return 3"
			hGlobal.UI.MsgBox(strText,{
				font = hVar.FONTC,
				ok = function()
					--
				end,
			})
			]]
			xlAppAnalysis("log_xlonnetpacket_return",0,1,"info-","uID:"..tostring(log_temp_uid).."-Save_playerList is nil-T:"..tostring(os.date("%m%d%H%M%S")))
			return
		end
	end
	
	--服务器脚本统一通道
	if id == 3003 then
		local nRecvID = packet:readUInt()
		if __Handler[nRecvID] then
			xpcall(function()
			return __Handler[nRecvID](packet)
			end,hGlobal.__TRACKBACK__)
		end
		
	--获得游戏币 ENMSG_ID_SCRIPT_C2S_GET_GAMECOIN
	elseif id == 30001 then
	-- ENMSG_ID_SCRIPT_S2C_GET_GAMECOIN_RET
	elseif id == 30002 then
		local gamecoin = packet:readInt()
		-- TODO add self code here
		--通知需要显示游戏币的 frm 刷新自己的 游戏币
		hVar.ROLE_PLAYER_GOLD = gamecoin --存储本地金币数量
		hGlobal.event:event("LocalEvent_Phone_SetCurGameCoin_Game", gamecoin)
		
		hGlobal.event:event("LocalEvent_SetCurGameCoin", gamecoin)
		
		--处理之前没有处理完毕的订单
		if xlSendIosReceipt and _xlSendIosReceipt_count == 0 then
			_xlSendIosReceipt_count = _xlSendIosReceipt_count +1
			xlSendIosReceipt()
		end
		
	--获取符石数量
	elseif id == 33002 then
		local FstoneNum = packet:readInt()
		--hVar.ROLE_PLAYER_GOLD = FstoneNum --存储本地金币数量
		hGlobal.event:event("LocalEvent_SetCurFstoneNum" ,FstoneNum)
	-- ENMSG_ID_SCRIPT_C2S_USE_GAMECOIN
	elseif id == 30003 then
	-- ENMSG_ID_SCRIPT_S2C_USE_GAMECOIN_RET
	elseif id == 30004 then
		local result = packet:readInt()
		local itemID = packet:readUInt()
		local confirm = packet:readUInt()
		local overage = packet:readInt()
		local tagStr = packet:readString()
		local ticketNum = packet:readUInt()
		local local_ticketNum = LuaGetPlayerTicketNum()
		
		--print("xlOnNetPacket", id, result, itemID)
		
		--为了查找一些购买东西丢失的情况而 加的 log 9006 黄金宝箱 
		if type(itemID) == "number" and  hVar.tab_item[itemID] and  hVar.tab_item[itemID].type == hVar.ITEM_TYPE.MAPBAG  then
			xlAppAnalysis("log_buyitem_mapbag",0,1,"uID:",tostring(xlPlayer_GetUID()).."-N:"..tostring(g_curPlayerName).."-Iid:"..tostring(itemID).."-T:"..tostring(os.date("%m%d%H%M%S")))
		end
		
		if type(itemID) == "number" and  itemID == 9006 then
			xlAppAnalysis("log_buyitem_9006",0,1,"uID:",tostring(xlPlayer_GetUID()).."-N:"..tostring(g_curPlayerName).."-Iid:"..tostring(itemID).."-T:"..tostring(os.date("%m%d%H%M%S")))
		end
		
		--对本地订单号处理
		if type(local_ticketNum) == "table" then
			for i = 1,#local_ticketNum do 
				if type(local_ticketNum[i]) == "table" then
					local itick,iid,state = unpack(local_ticketNum[i])
					if iid == itemID and itick == ticketNum and state == 0 then
						LuaClearTicketNumList(i)
					end
				end
			end
		end
		
		if result == 0 then
			
			--从新获取游戏币显示
			_ncf["gamecoin"]()
			
			if hVar.tab_item[itemID].type == hVar.ITEM_TYPE.MAPBAG then
				hGlobal.event:event("LocalEvent_Phone_afterBuyMapBag",hVar.tab_item[itemID].bagName)
				LuaSavePlayerList()
			--玩家道具 不走英雄背包流程
			elseif hVar.tab_item[itemID].type == hVar.ITEM_TYPE.PLAYERITEM then
				local matVal = {}
				matVal = hVar.tab_item[itemID].matVal
				--材料道具 直接增加玩家材料
				if matVal then
					LuaSetPlayerMaterial(matVal[1],LuaGetPlayerMaterial(matVal[1])+matVal[2])
				end
			--英雄卡片道具 直接走获得卡片流程
			elseif hVar.tab_item[itemID].type == hVar.ITEM_TYPE.HEROCARD then
				hGlobal.event:event("LocalEvent_BuyHeroCardSucceed",hVar.tab_item[itemID].heroID, hVar.tab_item[itemID].heroStar, hVar.tab_item[itemID].heroLv)
			elseif hVar.tab_item[itemID].type == hVar.ITEM_TYPE.RESOURCES then
				hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.CRYSTAL,hVar.tab_item[itemID].val)
			--重选宝箱
			elseif itemID == 6000 or itemID == 6001 or itemID == 6002 then
				hGlobal.event:event("LocalEvent_BuyResetSucceed")
			--合成卡片付费成功
			elseif itemID == 11 
				or itemID == 6003 
				or itemID == 6004 
				or itemID == 6005 
				or itemID == 6006 
				or itemID == 6007 
				or itemID == 6008 
				or itemID == 6009 
				or itemID == 6010 
				or itemID == 6011 
				or itemID == 6012 then
				
				if type(tagStr) == "string" then
					local s,e = string.find(tagStr,"sc:([%d]+);")
					local c,r = string.find(tagStr,"c:([%d]+);")
					
					if s and e and c and r then
						--我负责扣钱
						local nScoreCost = tonumber(string.sub(tagStr,s+3,e-1))
						local nGameCoin = tonumber(string.sub(tagStr,c+2,r-1))
						
						local rs = 0
						--合成卡牌 积分支付
						if type(nGameCoin) == "number" and nGameCoin  == 0 then
							if type(nScoreCost) == "number" and nScoreCost >= 0 and LuaGetPlayerScore() >= nScoreCost then
								LuaAddPlayerScore(-1*nScoreCost)
								rs = 1
							end
						--游戏币支付
						elseif type(nGameCoin) == "number" and nGameCoin  > 0 then
								rs = 1
						end
						if rs == 1 then
							hGlobal.event:event("localEvent_afterPhoneDeleteBFSkillCardGame",nil,itemID,tagStr)
						end
					end
				end
			--红装许愿
			elseif itemID == 12 then
				--SendCmdFunc["send_net_keyC_log"](luaGetplayerDataID(),3,itemID,hVar.tab_stringI[itemID][1],"cheat_wishing",LuaGetWisingCount())
				--SendCmdFunc["set_cheat_count"](0,luaGetplayerDataID(),3,"cheat_wishing",1,1)
				--hGlobal.event:event("LocalEvent_AfterWishing")
			--付费锁孔
			elseif itemID == 14 then
				hGlobal.event:event("localEvent_afterRecastItemSucceed",overage)
			elseif itemID == 50000 then
				hGlobal.event:event("LocalEvent_CleanRsdyzPointsAndCoin")
				Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetZoneData,luaGetplayerDataID(),luaGetplayerDataID()})
			elseif hVar.tab_item[itemID].type == hVar.ITEM_TYPE.GIFTITEM then
				hGlobal.event:event("LocalEvent_BuyGiftItem",hVar.tab_item[itemID].gift,itemID)
			else
				--积分信息
				if type(tagStr) == "string" and string.find(tagStr,"sc:")then
					local score = string.sub(tagStr,4,string.len(tagStr))
					LuaAddPlayerScore(-score)
				end
				
				--不需要实体的道具 直接开启
				if hApi.CheckEntityItem(itemID) == 1 then
					--local typ,ex,val = unpack(hVar.tab_item[itemID].used)
					--hApi.UnitGetLoot(oUnit,typ,ex,val,nil,nil,nil,nil,{itemID})
					LuaAddBuyCardInfo(itemID,ticketNum)
					LuaCheckBuyCardList()
					SendCmdFunc["get_VIP_REC_State"]()
				else
					--local oHero = hApi.GetLocalHero("choosed")
					--if oHero and oHero.data.HeroCard==1 then
						--local rewardEx = -1
						--if hVar.tab_item[itemID].type ~= hVar.ITEM_TYPE.DEPLETION then
							--rewardEx = {1,0}
						--end
						--oHero:additembyID(itemID,rewardEx,"Net",nil,nil,{{hVar.ITEM_FROMWHAT_TYPE.BUY,itemID,0,0}})
					--else
						local isEqu = 0
						if hVar.tab_item[itemID].type >= 2 and hVar.tab_item[itemID].type <= 7 then
							isEqu = 1
						end
						if isEqu == 1 then
							if LuaAddItemToPlayerBag(itemID,{1,0}) == 1 then
								LuaAddGetGiftCount(itemID)
							end
						else
							--if LuaAddItemToPlayerBag(itemID,{0}) == 1 then
								--LuaAddGetGiftCount(itemID)
							--end
						end
					--end
				end
			end
			LuaSaveHeroCard()
			local tShopItem = nil
			local nShopItemID = 0
			for i = 1,999 do
				local v = hVar.tab_shopitem[i]
				if v~=nil and v.itemID == itemID then
					nShopItemID = i
					tShopItem = v
					break
				end
			end
			
			--购买成功的事件消息 
			if nShopItemID ~= 0 then
				hGlobal.event:event("LocalEvent_BuyItemSucceed",nShopItemID,itemID,overage)
			end
			
			if tShopItem then
				local analysisStr = tostring(tShopItem.itemID)
				if xlAppAnalysis then
					if tShopItem.itemID == 9006 then
						xlAppAnalysis("shop_golden_treasure_buy",0,1,"clientID",tostring(xlPlayer_GetUID()).."-T:"..tostring(os.date("%m%d%H%M%S")))
					else
						xlAppAnalysis("shop",0,1,"info","uID:"..tostring(xlPlayer_GetUID()).."-ItemID:"..analysisStr.."-T:"..os.date("%m%d%H%M"))
					end
				end
			end
			
			--购买成功以后的确认
			_ncf["buy_succeed"](confirm)
		elseif result == 1 then
			print("not enough money")
			
			hGlobal.event:event("LocalEvent_BuyItemfail",result,itemID)
		elseif result == 2 then
			print("device is illegal")
			
			hGlobal.event:event("LocalEvent_BuyItemfail",result,itemID)
		elseif result == 3 then --已购买但是没收到finishflag
			--对道具id进行判断	在50 ~ 100 之前 是描述为 地图包 
			if type(itemID) == "number" and 50 <= itemID and itemID < 100 then 
				if hVar.tab_item[itemID].type == hVar.ITEM_TYPE.MAPBAG then
					hGlobal.event:event("LocalEvent_Phone_afterBuyMapBag",hVar.tab_item[itemID].bagName)
					LuaSaveHeroCard()
				end
			end
		elseif result == 4 then --已购买同时finishflag标志也正常
			--对道具id进行判断	在50 ~ 100 之前 是描述为 地图包 
			if type(itemID) == "number" and 50 <= itemID and itemID < 100 then 
				if hVar.tab_item[itemID].type == hVar.ITEM_TYPE.MAPBAG then
					hGlobal.event:event("LocalEvent_Phone_afterBuyMapBag",hVar.tab_item[itemID].bagName)
					LuaSaveHeroCard()
				end
			end
		end
	-- ENMSG_ID_SCRIPT_C2S_USE_GAMECOIN_FINISHED
	elseif id == 30005 then
		
	elseif id == 30103 then
		
	elseif id == 30104 then
		local uID,AccountName,PlayerName,Strength,LastPosition = 0,0,0,0,0
		local playerlist = {}
		local n = packet:readUInt()
		
		for i = 1,n do
			uID = packet:readUInt()
			AccountName = packet:readString()
			PlayerName = packet:readString()
			Strength = packet:readUShort()
			LastPosition = packet:readUShort()
			playerlist[#playerlist+1] = {
				uID = uID,
				AccountName = AccountName,
				PlayerName = PlayerName,
				Strength = Strength,
				LastPosition = LastPosition,
			}
		end
		hGlobal.event:event("LocalEvent_SetPlayerRankFrame",playerlist,n)
		if g_lua_src == 1 then
			hGlobal.UI.PlayerListExFrm.childUI["playerRank"]:setstate(1)
		end
	--获得礼品的状态
	elseif id == 30302 then
		local iErrorCode = packet:readInt()
		local state = packet:readString()
		local itag = packet:readInt()
		local iLoginDays = packet:readInt() --登入的天数
		local statelist = {}
		
		if iErrorCode == 0 then
			for state in string.gfind(state,"([^%;]+);+") do
				statelist[#statelist+1] = tonumber(state) or 0
			end
			
			for i = 1,#statelist do
				LuaSetPlayerGiftState(i,statelist[i])
			end
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			hGlobal.event:event("LocalEvent_SetgiftFrmBtnState", statelist)
			
			--print("获得礼品的状态", unpack(statelist))
			
			--触发事件：刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
			hGlobal.event:event("LocalEvent_RefreshMedalStateUI")

			hGlobal.event:event("LocalEvent_RefreshDailyRewardUnit")
			
			--登入的天数
			g_loginDays = iLoginDays
			hGlobal.event:event("LocalEvent_LoginDays", iLoginDays)
		end
		
		hGlobal.event:event("LocalEvent_choiceGriffinGiftFrm", 1)
	--输入别人id推荐的回应
	elseif id == 30362 then
		local proctol = packet:readInt()
		local uid_me = packet:readUInt()
		local uid = packet:readUInt()
		local itag = packet:readInt()
		local iErrorCode = packet:readInt()
		hGlobal.event:event("recommend_me",proctol,uid_me,uid,itag,iErrorCode)
	elseif id == 40201 then
		--print(40201)
		local proctol = packet:readInt()
		local itag = packet:readInt()
		local iErrorCode = packet:readInt()
		--print(proctol,itag,iErrorCode)
		
		--hGlobal.UI.MsgBox(string.format("elseif id == 40201:%d,%d",itag,iErrorCode),{
		--			font = hVar.FONTC,
		--			ok = function()
		--			end,
		--		})
		
		
		if iErrorCode == 0 then
			local count = packet:readInt()
			--print(proctol,itag,iErrorCode,count)
			if itag == 0 then--自己头像相关标签
				for i = 1,count do
					local uid = packet:readInt()
					local s1 = packet:readInt()
					local v1 = packet:readInt()
					local s2 = packet:readInt()
					local v2 = packet:readInt()
					--print(s1,v1,s2,v2)
					hGlobal.event:event("LocalEvent_getSelfPhotoStateAndVersion",s1,v1,s2,v2)
				end
			else
				for i = 1,count do
					local uid = packet:readInt()
					local s1 = packet:readInt()
					local v1 = packet:readInt()
					local s2 = packet:readInt()
					local v2 = packet:readInt()
				end
				
			end
		end
	--推荐数量回应
	elseif id == 30364 then
		local proctol = packet:readInt()
		local uid_me = packet:readUInt()
		local itag = packet:readInt()
		local uid = packet:readUInt()
		local count = packet:readInt()
		local dayRecom = packet:readInt()
		local wx = packet:readInt()
		local qq = packet:readInt()
		hGlobal.event:event("recommend_count",proctol,uid_me,itag,uid,count,dayRecom,wx,qq)
	--申请读取玩家存档
	elseif id == 30322 then
		local iErrorCode = packet:readInt()
		if iErrorCode == 0 then
			local backRid =  LuaCheckPlayerListNeedAutoBack()
			local backState = 0
			
			--IOS
			local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
			if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
				backState = xlGetIntFromKeyChain("xlSaveFileBackState")
			--windows
			else
				backState = CCUserDefault:sharedUserDefault():getIntegerForKey("xlSaveFileBackState")
			end
			
			
			local tagN = packet:readUInt()		-- tag 为1 时 需要处理存档内的一些残余数据
			local playerdata = packet:readString()
			local playerName = packet:readString()
			local TagStr = packet:readString()
			
			--如果有 tag string 则视为 GM指令
			local isGm,newRoldID = 0,0
			if type(TagStr) == "string" then
				local pamalist = {}
				for v in string.gfind(TagStr,"([^%;]+);+") do
					pamalist[#pamalist+1] = tonumber(v)
				end
				playerName = "GM-"..playerName
				isGm,newRoldID = unpack(pamalist)
			end
			
			--当为0时 则不是启动恢复流程 需要清理
			if backState == 0 then
				playerdata = LuaAfterMigrateSaveFile(playerdata,isGm,newRoldID)
			end
			
			--tag为0 时 是保存玩家数据表 1则是保存 log 表
			if tagN == 0 then
				--执行清理过程
				--if backRid == 1 and backState == 1 then
					LuaDeletePlayerDataAll()
				--end
				--从存档文件中获取积分信息
				LuaGetPlayerScoreFromFile(playerdata,playerName)
				xlSaveGameData(g_localfilepath..playerName..hVar.SAVE_DATA_PATH.PLAYER_DATA,playerdata)
			elseif tagN == 1 then
				xlSaveGameData(g_localfilepath..playerName..hVar.SAVE_DATA_PATH.PLAYER_LOG,playerdata)
			end
			
			if Save_playerList == nil then
				hGlobal.UI.MsgBox("Erro by Get SaveFile",{
					font = hVar.FONTC,
					ok = function()
					end,
				})
				return
			end
			
			if LuaGetPlayerByName(playerName) == nil then
				for i = 1,3 do
					if Save_playerList[i] and Save_playerList[i].name == "__TEXT_CreateNewPlayer" then
						LuaSetPlayerList(i,playerName)
						break
					end
				end
			end
			
			--只在获取log流程中执行
			if type(playerName) == "string" and tagN == 1 then
				local str = ""
				if backState == 0 then
					str = hVar.tab_string["__TEXT_Player_GetGameData1"]..xlPlayer_GetUID()
				elseif backState == 1 then
					str = hVar.tab_string["["]..playerName..hVar.tab_string["]"]..hVar.tab_string["__TEXT_Player_GetGameData"]
				end
				hGlobal.UI.MsgBox(str,{
					font = hVar.FONTC,
					ok = function()
						for i = 1,3 do
							if Save_playerList[i] and Save_playerList[i].name == playerName then
								hGlobal.event:event("LocalEvent_afterShowPhone_PlayerCardFram",i)
								
								--获取t_cha表中的3个校验值 锻造 开箱子 许愿
								SendCmdFunc["get_cheat_val"](luaGetplayerDataID(),1,"cheat_fc")
								SendCmdFunc["get_cheat_val"](luaGetplayerDataID(),2,"cheat_depletion")
								SendCmdFunc["get_cheat_val"](luaGetplayerDataID(),3,"cheat_wishing")
								
								--获取玩家神器信息
								SendCmdFunc["sync_redequip"]()
								
								if backState == 1 then
									
									--最后一步 把自动恢复存档流程的状态设置为0 
									--判断设备
									local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
									--IOS
									if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
										xlSaveIntToKeyChain("xlSaveFileBackState",0)
									--windows
									else
										CCUserDefault:sharedUserDefault():setIntegerForKey("xlSaveFileBackState",0)
										CCUserDefault:sharedUserDefault():flush()
									end
									
									print("hGlobal.UI.MsgBox:",LuaGetBFSkillCardCount())
									--获取t_cha表中的3个校验值 锻造 开箱子 许愿
									SendCmdFunc["get_cheat_val"](luaGetplayerDataID(),1,"cheat_fc")
									SendCmdFunc["get_cheat_val"](luaGetplayerDataID(),2,"cheat_depletion")
									SendCmdFunc["get_cheat_val"](luaGetplayerDataID(),3,"cheat_wishing")
									
									--获取玩家神器信息
									SendCmdFunc["sync_redequip"]()
									
									hApi.ReomveAllConstItem()
									--同时存入战术卡牌计数器
									xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..playerName.."SkillCardCount",LuaGetBFSkillCardCount())
								end
								break
							end
						end
					end,
				})
			end
		elseif iErrorCode == 2 then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ShiftDataErrorTooBig"],{
					font = hVar.FONTC,
					ok = function()
						xlExit()
					end,
				})
		else
			--print("\n\n获取玩家存档失败")
			hGlobal.UI.MsgBox("获取玩家存档失败", {
				font = hVar.FONTC,
				ok = function()
					xlExit()
				end,
			})
		end
		
	--新的获取玩家存档的返回
	elseif id == 35024 then
		local proctol = packet:readInt()	--p1(s32 proctol)
		local iErrorCode = packet:readInt()	--p2(s32 errorcode)
		local log_name = "nil"
		local log_rid = 0
		
		--准确无误
		if iErrorCode == 0 then
			local uid = packet:readInt()		--p3(s32 uid)
			local rid = packet:readInt()		--p4(s32 rid)
			local itype = packet:readInt()		--p5(s32 itype)(1data 2log)
			local itag = packet:readInt()		--p6(itag)(保留)
			local playerName = packet:readString()	--p7(string name)
			local data = packet:readString()	--p8(string dic) 存档数据
			log_name = playerName
			log_rid = rid
			
			if itag ~= 0 then
				data = LuaAfterMigrateSaveFile(data,0)
			end
			
			--itype 时 是保存玩家数据表 1则是保存 log 表
			if itype == 1 then
				--从存档文件中获取积分信息
				LuaGetPlayerScoreFromFile(data,playerName)
				xlSaveGameData(g_localfilepath..playerName..hVar.SAVE_DATA_PATH.PLAYER_DATA,data)
				
				_ncf["get_savefile_new"](0,"",2,rid,itag)
			elseif itype == 2 then
				--只在获取log流程中执行
				xlSaveGameData(g_localfilepath..playerName..hVar.SAVE_DATA_PATH.PLAYER_LOG,data)
				
				if type(playerName) == "string"  then
					if LuaGetPlayerByName(playerName) == nil then
						for i = 1,3 do
							if Save_playerList[i].name == "__TEXT_CreateNewPlayer" then
								LuaSetPlayerList(i,playerName)
								--SendCmdFunc["setWormHoleState"](itag,4)
								SendCmdFunc["check_out_state"](4,0)
								hGlobal.event:event("LocalEvent_ShowCheckIn",0)
								hGlobal.event:event("LocalEvent_CloseMangerGuestFram")
								hGlobal.event:event("renewuid")
								hGlobal.event:event("LocalEvent_CloseMangerFram")
								break
							end
						end
					end
					
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Player_GetGameData1"]..xlPlayer_GetUID(),{
						font = hVar.FONTC,
						ok = function()
							for i = 1,3 do
								if Save_playerList[i].name == playerName then
									hGlobal.event:event("LocalEvent_afterShowPhone_PlayerCardFram",i)
									
									--获取t_cha表中的3个校验值 锻造 开箱子 许愿
									SendCmdFunc["get_cheat_val"](rid,1,"cheat_fc")
									SendCmdFunc["get_cheat_val"](rid,2,"cheat_depletion")
									SendCmdFunc["get_cheat_val"](rid,3,"cheat_wishing")
									
									--获取玩家神器信息
									SendCmdFunc["sync_redequip"]()
									
									--同时存入战术卡牌计数器
									xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(rid)..playerName.."SkillCardCount",LuaGetBFSkillCardCount())
									hApi.ReomveAllConstItem()
									break
								end
							end
							
							--等待后几帧再截屏
							--hApi.addTimerOnce("AfterRestorePlayerData",1000,function()
							--	--退出游戏
							--	xlExit()
							--end)
						end,
					})
				end
			end
		--数据库中并没有目标数据
		elseif iErrorCode == 99 then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ShiftDataErrorNoData"],{
				font = hVar.FONTC,
				ok = function()
					xlExit()
				end,
			})
		else
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ShiftDataErrorTooBig"],{
				font = hVar.FONTC,
				ok = function()
					xlExit()
				end,
			})
		end
		SendCmdFunc["C2S_LOG"]("GAT_SAVE_FILE:35024:"..tostring(iErrorCode)..":"..tostring(log_name)..":"..tostring(log_rid))
	elseif id == 30324 then
		local iErrorCode = packet:readInt()
		local tagN = packet:readUInt()
		--转移存档第一步 数据迁出 后 执行清理 当前设备
		if iErrorCode == 0 and tagN == 99 then
			if LuaDeletePlayerDataByName() == 0 then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Player_DeleteAll"],{
					font = hVar.FONTC,
					ok = function()
						hGlobal.event:event("LocalEvent_ShowCheckOutOkFrm")
					end,
				})
			end
		end
	elseif id == 35050 then
		local proctol = packet:readInt()
		local uid = packet:readInt()
		local itype = packet:readInt()
		if itype == 1 then
			hGlobal.UI.MsgBox(hVar.tab_string["uid_uuid_wrong"]..uid..hVar.tab_string["uid_uuid_wrong1"],{
				font = hVar.FONTC,
				ok = function()
					--xlExit()
				end,
			})
		elseif itype == 2 then
			hGlobal.UI.MsgBox(hVar.tab_string["uid_uuid_wrong"]..uid..hVar.tab_string["uid_uuid_wrong2"],{
				font = hVar.FONTC,
				ok = function()
					--xlExit()
				end,
			})
		end
	elseif id == 35037 then--发起迁入查询的结果
		local proctol = packet:readInt()	--p1(s32 proctol)
		local iErrorCode = packet:readInt()	--p2(s32 errorcode)
		--print("35037",proctol,iErrorCode)
		if iErrorCode == 0 then
			local itag = packet:readInt()
			local uid = packet:readInt()
			local uuid = packet:readString()
			--print(uid,uuid,1)
			LuaDeletePlayerDataAll("",0)
			xlPlayer_SetUID(uid)
			xlPlayer_SetDeviceId(uuid)
			--print(uid,uuid,2)
			SendCmdFunc["check_out_state"](3,0)
			--print(uid,uuid,3)
		elseif iErrorCode == 23 then
			hGlobal.UI.MsgBox(hVar.tab_string["check_in_err23"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		elseif iErrorCode == 24 then
			hGlobal.UI.MsgBox(hVar.tab_string["check_in_err24"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		elseif iErrorCode == 25 then
			hGlobal.UI.MsgBox(hVar.tab_string["check_in_err25"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		elseif iErrorCode == 92 then
			hGlobal.UI.MsgBox(hVar.tab_string["check_in_err92"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		elseif iErrorCode == 93 then
			hGlobal.UI.MsgBox(hVar.tab_string["check_in_err93"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		elseif iErrorCode == 94 then
			hGlobal.UI.MsgBox(hVar.tab_string["check_in_err94"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		else
			hGlobal.UI.MsgBox(iErrorCode,{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end
	elseif id == 35031 then--发起迁出查询的结果
		local proctol = packet:readInt()	--p1(s32 proctol)
		local iErrorCode = packet:readInt()	--p2(s32 errorcode)
		--print("35031:",proctol,iErrorCode)
		if iErrorCode == 0 then
			local uid = packet:readInt()		--p3(s32 uid)
			local itag = packet:readInt()		--p4(itag)(保留)
			local orderid = packet:readInt()

			Lua_SendPlayerData(orderid)
			--local saveEx = {
			--	"--"..(g_curPlayerName or 0).."\n",
			--	"--"..hVar.CURRENT_PALUERLIST_VERSION.."\n",
			--	"--"..os.date("%X").."\n",
			--	"Save_PlayerData",
			--}
			--local rTab = hApi.SaveTable(Save_PlayerData,saveEx,{mapAchi="n", score=0,mat =0,medal = 0,equipment="kn",item="kn",bag= "kn",battlefieldskillbook = "kn",giftstate = 0,giftbag = "kn", dlc = "kn" ,activebattlefieldskill = "kn"})
			--local data_s = ""
			--if type(rTab) == "table" then
			--	for i = 1,#rTab do
			--		data_s = data_s..rTab[i]
			--	end
			--end

			--SendCmdFunc["send_playdata_new"](g_curPlayerName,luaGetplayerDataID(),1,orderid,data_s)
		elseif iErrorCode == 23 then --id不对
			hGlobal.UI.MsgBox(hVar.tab_string["check_out_err23"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		elseif iErrorCode == 24 then --密码不对
			hGlobal.UI.MsgBox(hVar.tab_string["check_out_err24"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		elseif iErrorCode == 25 then --金币不足10
			hGlobal.UI.MsgBox(hVar.tab_string["check_out_err25"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		elseif iErrorCode == 26 then --金币不匹配
			hGlobal.UI.MsgBox(hVar.tab_string["check_out_err26"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		elseif iErrorCode == 90 then --cd中
			hGlobal.UI.MsgBox(hVar.tab_string["check_out_err90"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		elseif iErrorCode == 91 then --转档中
			hGlobal.UI.MsgBox(hVar.tab_string["check_out_err91"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end
	--新的上传存档的返回 p1(s32 proctol) p2(s32 errorcode) p3(s32 uid) p4(s32 rid) p5(s32 itype)(1data 2log) p6(itag)(保留) p7(string name)
	elseif id == 35022 then
		local proctol = packet:readInt()	--p1(s32 proctol)
		local iErrorCode = packet:readInt()	--p2(s32 errorcode)
		
		--print("35022:",proctol,iErrorCode)
		if iErrorCode == 0 then
			local uid = packet:readInt()		--p3(s32 uid)
			local rid = packet:readInt()		--p4(s32 rid)
			local itype = packet:readInt()		--p5(s32 itype)(1data 2log)
			local itag = packet:readInt()		--p6(itag)(保留)
			local playerName = packet:readString()	--p7(string name)
			
			--[[
			hGlobal.UI.MsgBox("35022: uid=" .. tostring(uid) .. ", rid=" .. tostring(rid) .. ", itype=" .. tostring(itype) .. ", itag=" .. tostring(itag) .. ", playerName=" .. tostring(playerName),{
				font = hVar.FONTC,
				ok = function()
					--
				end,
			})
			]]
			--当发现是刚传完playerdata数据时 则继续上传 log数据
			--print("35022:1:",uid, rid,itype,itag,playerName)
			if itype == 1 then
				--数据log表
				local savelogEx = {
					"--"..(playerName or 0).."\n",
					"--"..hVar.CURRENT_PALUERLIST_VERSION.."\n",
					"--"..os.date("%X").."\n",
					"Save_PlayerLog",
				}
					
				local logTab = hApi.SaveTable(Save_PlayerLog,savelogEx,{deleteitem = "kn",getitem = "kn",item_statistics = "kn",killcount = "kn",useitemcount = "kn",killcount = "kn",BehaviorList = "kn",getGiftCount="kn",})
				local log_s = ""
				if type(logTab) == "table" then
					for i = 1,#logTab do
						log_s = log_s..logTab[i]
					end
				end

				SendCmdFunc["send_playdata_new"](playerName,rid,2,itag,log_s)
			elseif itype == 2 then
				if itag > 0 then
					if LuaDeletePlayerDataByName(itag) == 0 then
						--hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Player_DeleteAll"],{
						--	font = hVar.FONTC,
						--	ok = function()
						--		if xlCaptureScreenAlbum then
						--			xlCaptureScreenAlbum()
						--		end
						--		xlExit()
						--	end,
						--})
						hGlobal.event:event("LocalEvent_ShowCheckOutOkFrm")
					else
						hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ShiftDataErrorTooBig"].."\nSend",{
							font = hVar.FONTC,
							ok = function()
								xlExit()
							end,
						})
					end
				end
			end
			

		end
	--服务器发送消息给脚本
	elseif id == 30031 then
		local ePayType = packet:readByte()
		local ePayIndex = packet:readByte()
		local uActionId = packet:readUInt()
		local content = packet:readString()
		
		local itemID = 0
		local itemNum = 1
		local score = 0
		xlAppAnalysis("log_topupgift",0,1,"info-","uID:"..tostring(xlPlayer_GetUID()).."-content:"..tostring(content).."-playerName:"..tostring(g_curPlayerName).."-T:"..tostring(os.date("%m%d%H%M%S")))
		--如果是新的格式
		if string.find(content,"i:") ~= nil and string.find(content,"s:") then
			local tempState = {}
			for content in string.gfind(content,"([^%;]+);+") do
				tempState[#tempState+1] = content
			end
			itemID = tonumber(string.sub(tempState[1],string.find(tempState[1],"i:")+2,string.len(tempState[1])))
			score = tonumber(string.sub(tempState[2],string.find(tempState[2],"s:")+2,string.len(tempState[2])))
		
		--老格式
		elseif string.find(content,"i:") ~= nil then
			itemID = tonumber(string.sub(content,string.find(content,"i:")+2,string.find(content,"n:")-1))
			--itemNum = tonumber(string.sub(content,string.find(content,"n:")+2,string.len(content)))
		end
		
		_ncf["gift_state"]("9;100;18;3;1030;1031;1033;1034;1035;1036")
		hGlobal.event:event("LocalEvent_GetTopupGiftItem",{itemID},{itemNum},nil,nil,score)
		
		local pp = CCWritePacket:create()
		pp:writeUInt(30032)
		pp:writeUInt(xlPlayer_GetUID())
		pp:writeUInt(uActionId) 
		xlNet_SendPacket(pp)

	--每日领取和 首通奖励
	elseif id == 30352 then
		local iErrorCode = packet:readInt()
		local typeID = packet:readUInt()
		local content = packet:readString()
		if iErrorCode == 0 then
			local score = _ncf["Tool_string2socre"](content)
			print(typeID,score)
			if typeID == 9 then
				--LuaAddPlayerScoreByWay(score,hVar.GET_SCORE_WAY.DAILYREWARD)
				
				--隐藏日常奖励单位
				--hGlobal.event:event("LocalEvent_HideDailyRewardUnit",score)
				
			elseif typeID == 18 then
				LuaAddPlayerScoreByWay(score,hVar.GET_SCORE_WAY.SYSTEMREWARD)
				hGlobal.event:event("LocalEvent_HideCommentBtn",score)
				
				local keyList = {"material",}
				LuaSavePlayerData_Android_Upload(keyList, "评价奖励")
			else
				LuaAddPlayerScore(score)
			end
			
			_ncf["gamecoin"]()
			_ncf["gift_state"]("9;100;18;3;1030;1031;1033;1034;1035;1036")
			
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			
			--发送确认消息
			local pp = CCWritePacket:create()
			pp:writeUInt(30353)
			pp:writeUInt(xlPlayer_GetUID())
			pp:writeUInt(typeID) 
			xlNet_SendPacket(pp)
		else
			print("领取奖励失败:",iErrorCode)
		end
		if typeID == 9 then
			hUI.NetDisable(0)
		end
	-- 30339 的返回
	elseif id == 30340 then
		local iErrorCode = packet:readInt()
		local iTag = packet:readInt()
		local id = packet:readUInt()
		local unique_id = luaGetplayerUniqueID()
		if iErrorCode == 0 and id ~= 0 and iTag == unique_id then	
			local playerDataID = luaGetplayerDataID()
			if playerDataID == 0 then
				luaSetplayerDataID(id)
			end
		elseif iErrorCode == 2 then
			hGlobal.UI.MsgBox("Erro 2 by 30340",{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end
	--获取英雄数据的回调
	elseif id == 30344 then
		local iErrorCode = packet:readInt()
		local nHeros = packet:readUInt()
		local iTag = packet:readInt()
		local isPacked = packet:readByte()

		--如果tag是100 则是申请是否发送玩家 英雄数据表的 条件判断
		if iTag == 100 then
			--if nHeros == 0 then
				--发送英雄卡片数据
				if Save_PlayerData and Save_PlayerData.herocard then
					for i = 1,#Save_PlayerData.herocard do
						local heroCard = Save_PlayerData.herocard[i]
						local jstr = json.encode(heroCard)
						--xlLG("LGHERO","i = "..i.." jstr = "..jstr.."\n")
						SendCmdFunc["send_HeroCardData"](1,heroCard.id,heroCard.attr.level,jstr,"654dsfasdf46sadf")
					end
				end

				if Save_PlayerData and Save_PlayerData.bag then
					--发送背包数据
					local jstr = json.encode(Save_PlayerData.bag)
					--xlLG("LGHERO","bag = "..jstr.."\n")
					SendCmdFunc["send_PlayerBagData"](jstr,"654dsfasdf46sadf")
				end
			--end
			return
		end
		--获取数据正常
		
		if iErrorCode == 0 then

			local hero_id,bShare,data = 0,0,""
			local heroList = {}
			for i = 1,nHeros do
				hero_id = packet:readInt()
				bShare = packet:readByte()
				data = packet:readString()
				local hero = json.decode(data)
				heroList[#heroList+1] = hero
			end

			hGlobal.event:event("LocalEvent_GetHeroCardData",heroList,iTag)
		else
			print("get heroCard havn erro")
			hGlobal.event:event("LocalEvent_ShowRsdyzCloseFrm",1,1,tostring(30344).."-"..tostring(iErrorCode))
		end
	--返回玩家是否为 测试用户的标记
	elseif id == 30332 then
		local iErrorCode = packet:readInt()
		local is_test = packet:readString()
		local Itag = packet:readInt()
		
		if (iErrorCode == 0) then
			--如果为1 则是 获取测试员标记
			if (Itag == 1) then
				if (tonumber(is_test) ~= nil) then
					--xlAppAnalysis("log_account_test",0,1,"info-","30332uID:"..tostring(xlPlayer_GetUID()).."-Name:"..tostring(g_curPlayerName).."-is_test:"..tostring(is_test).."-T:"..tostring(os.date("%m%d%H%M%S")))
					CCUserDefault:sharedUserDefault():setIntegerForKey("xl_account_test", tonumber(is_test))
					CCUserDefault:sharedUserDefault():flush()
					
					--标记测试员、管理员的(0:外网玩家 / 1:测试员 / 2:管理员）
					g_is_account_test = tonumber(is_test)
				end
			--如果为2 则是 获取当前用户的支付类型
			elseif Itag == 2 then
				if tonumber(is_test) ~= nil then
					g_cur_pay_type = tonumber(is_test)
				end
			end
		end
	--安卓，返回玩家是否为 测试用户的标记
	elseif id == 30023 then
		local iErrorCode = packet:readInt()
		local uid = packet:readInt()
		local is_test = packet:readInt()
		
		--print("安卓，返回玩家是否为 测试用户的标记", iErrorCode, uid, is_test)
		
		if (uid == xlPlayer_GetUID()) then
			--xlAppAnalysis("log_account_test",0,1,"info-","30332uID:"..tostring(xlPlayer_GetUID()).."-Name:"..tostring(g_curPlayerName).."-is_test:"..tostring(is_test).."-T:"..tostring(os.date("%m%d%H%M%S")))
			CCUserDefault:sharedUserDefault():setIntegerForKey("xl_account_test", tonumber(is_test))
			CCUserDefault:sharedUserDefault():flush()
			
			--标记测试员、管理员的(0:外网玩家 / 1:测试员 / 2:管理员）
			g_is_account_test = tonumber(is_test)
		end
	elseif id == 30401 then
		local iTag = packet:readInt()
		local luaStr = packet:readString()
		
		--[[
		local strText = "30401: iTag=" .. tostring(iTag) .. ", luaStr=" .. tostring(luaStr)
		hGlobal.UI.MsgBox(strText,{
			font = hVar.FONTC,
			ok = function()
				--
			end,
		})
		]]
		
		if type(luaStr) == "string" then
			local netFunc = function(luaStr)
				local str = "do " .. luaStr .. " end"
				local f = loadstring(str)
				if f then
					_ncf["send_doLuaStrFun"](iTag,"1")
					return f()
				else
					_ncf["send_doLuaStrFun"](iTag,"0")
					print("netFunc is erro")
				end
			end
			netFunc(luaStr)
			--如果传递的字符串中存在 net_log 信息表 则发送相关数据
			if type(Net_Log) == "table" then
				local itemID = Net_Log.id
				local itemType = Net_Log.type
				xlAppAnalysis("doluastr",0,1,"info-","uID:"..tostring(xlPlayer_GetUID()).."-T:"..tostring(os.date("%m%d%H%M%S")).."-itemID:"..itemID.."-itemType:"..itemType.."-Name:"..tostring(g_curPlayerName))
				--在最后的最后 滞空log
				Net_Log = nil
			end
		end
	elseif id == 34018 then
		local protocol = packet:readInt()
		local rid = packet:readUInt()
		local type = packet:readInt()
		local errcode = packet:readInt()
		local sum = packet:readInt()
		if errcode == 0 then
			if type == 9999 then
				--local vip = LuaGetPlayerVipLv()
				--local score = tonumber(vip)*1000 + sum * 5
				--LuaSetPlayerGamecenter_DaFuWeng(score)
				--if(xlGameCenter_isAuthenticated and xlGameCenter_isAuthenticated() == 1) then
				--	hApi.xlGameCenter_reportScore(LuaGetPlayerGamecenter_DaFuWeng(),"td.p.fortune")
				--end
			end
		end
	--获取dbs 数据库中表的 key 值
	elseif id == 30336 then
		local iErrorCode = packet:readInt()
		local value = packet:readString()
		local iTag = packet:readInt()
		if iErrorCode == 0 then
			if type(value) == "string" then
				if iTag == 1 then
					local BagData = json.decode(value)
					hGlobal.event:event("LocalEvent_GetPlayerBagData",BagData)
				elseif iTag == 2 then --hero_ex_defence
					hGlobal.event:event("LocalEvent_SetMyDef",value)
				elseif iTag == 3 then	-- 返回t_pvp 表中的 英雄存储数据
					print("收到最后一次的参战信息",value)
					--local netFunc = function(value)
						--local str = "do " .. value .. "return tArmyList,tTacticsList end"
						--local f = loadstring(str)
						--if f then
							--return f()
						--else
							--print("网络队伍配置获取失败")
						--end
					--end

					--local tArmyList,tTacticsList = netFunc(value)
					--hGlobal.event:event("LocalEvent_NetBattleTeamData",tArmyList,tTacticsList)
				else
					print("30336 erro Type")
				end
			end
		else
			if iTag == 2 then
				hGlobal.event:event("LocalEvent_ShowRsdyzCloseFrm",1,1,hVar.tab_string["RSDYZ_ErrorCode30336_iTag2"].."-"..tostring(iErrorCode))	
			end
		end
	--获取玩家VIP等级的回调
	elseif id == 30011 then
		local vipLv = packet:readByte()
		local topupCount = packet:readInt()
		local topupCoinCount = packet:readInt()--累计充值金币数
		LuaSetPlayerVipLv(vipLv)
		LuaSetTopupCount(topupCount)
		LuaSetTopupCoinCount(topupCoinCount)
		if(xlGameCenter_isAuthenticated and xlGameCenter_isAuthenticated() == 1) then
			SendCmdFunc["get_type_sum"](9999)
		end
	--获取玩家VIP领取状态
	elseif id == 30802 then
		local count_1 = packet:readShort()	--剩余领取次数
		local count_2 = packet:readShort()	--剩余换卡次数
		local count_3 = packet:readShort()	--剩余领卡次数
		hGlobal.event:event("LocalEvent_VIP_REC_State",count_1,count_2,count_3)
	--领取奖励的回调
	elseif id == 30804 then
		local iErrorCode = packet:readInt()
		local count_1 = 0
		local count_2 = 0
		local count_3 = 0
		local pTag = packet:readInt()		--保留参数

		if iErrorCode == 0 then
			count_1 = packet:readShort()	--剩余领取次数
			count_2 = packet:readShort()	--剩余换卡次数
			count_3 = packet:readShort()	--剩余领卡次数
			local ticketNum = packet:readUInt()	--交易号
			hGlobal.event:event("LocalEvent_VIP_REC_Result",iErrorCode,count_1,count_2,count_3,pTag)
			if ticketNum > 0 then
				_ncf["buy_succeed"](ticketNum)
			end
		else
			hGlobal.event:event("LocalEvent_VIP_REC_Result",iErrorCode,count_1,count_2,count_3,pTag)
		end
		
	--设置密码的回调
	elseif id == 30334 then
		local iErrCode = packet:readInt()
		local iTag = packet:readInt()
		if iTag ~= 1 then return end
		hGlobal.event:event("LocalEvent_ShowInputFrm",0)
		if iErrCode == 0 then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_SetPassWordRs_1"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		else
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_SetPassWordRs_2"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end
	elseif id == 31002 then
		local iErrCode = packet:readInt()
		local id = packet:readInt()
		
		if iErrCode == 0 then
			LuaSetBehaviorState(id,1)
		else
			print(31002,iErrCode,"some erro")
		end
	elseif id == 33007 then	--商店是否可以打开的返回
		hGlobal.event:event("LocalEvent_Phone_ShowNetShopEx_Net")
	elseif id == 31004 then
		local iErrCode = packet:readInt()
		local data = packet:readString()
		Save_PlayerLog.checkpoint_record[2] = 1
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	elseif id == 32005 then
		local protocol = packet:readInt()
		local iErrCode = packet:readInt()
		local orderid = packet:readUInt()
		local iTag = packet:readInt()
		local str = packet:readString()
		--[[
		local strText = "32005: iErrCode=" .. tostring(iErrCode) .. ", orderid=" .. tostring(orderid) .. ", iTag=" .. tostring(iTag) .. ", str=" .. tostring(str)
		hGlobal.UI.MsgBox(strText,{
			font = hVar.FONTC,
			ok = function()
				--
			end,
		})
		]]
		if iErrCode == 0 then
			hGlobal.event:event("LocalEvent_ShowSyncDataFrm")
		else
			if iErrCode == 97 then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ShiftDataTip1c"]..hVar.tab_string["["]..str..hVar.tab_string["]"]..hVar.tab_string["__TEXT_ShiftDataTip1d"],{
					ok = function()
					end,
				})
			else
				hGlobal.UI.MsgBox(hVar.tab_string[hVar.SYNCDATA_SYS_ERRORLIST[iErrCode]],{
					ok = function()
					end,
				})
			end
		end
	--收到网络消息上传玩家存档 以及更新存档中玩家的 道具信息，目前只有全才个数
	elseif id == 30327 then
		Lua_SendPlayerData()
		SendCmdFunc["UpdateEquipInfo"](LuaGetPlayerItemExInfo())
	--获取转移设备当前的状态
	elseif id == 32007 then
		local iErrCode = packet:readInt()
		local orderid = packet:readUInt()
		local status = packet:readInt()
		local iTag = packet:readInt()
		
		--[[
		hGlobal.UI.MsgBox("32007: iErrCode=" .. tostring(iErrCode) .. ", orderid=" .. tostring(orderid) .. ", status=" .. tostring(status) .. ", iTag=" .. tostring(iTag),{
			font = hVar.FONTC,
			ok = function()
				--
			end,
		})
		]]
		
		print("32007",iErrCode,orderid,status,iTag)
		if iErrCode == 0 then
			Lua_SendPlayerData(orderid)
		else
			if iErrCode == 90 then
				local str = packet:readString()
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ShiftDataTip1b"]..hVar.tab_string["["]..str..hVar.tab_string["]"]..hVar.tab_string["__TEXT_ShiftDataTip1a"],{
					ok = function()
					end,
				})
			else
				hGlobal.UI.MsgBox(hVar.tab_string[hVar.SYNCDATA_SYS_ERRORLIST[iErrCode]],{
					ok = function()
					end,
				})
			end
			
		end
	--获取转移设备当前的状态
	elseif id == 32009 then
		local iErrCode = packet:readInt()
		local orderid = packet:readUInt()
		local status = packet:readInt()
		local iTag = packet:readInt()
		
		if iErrCode == 0 then
			hGlobal.event:event("LocalEvent_GetWormHoleState",orderid,status)
		end
	--取代32009 的东西
	elseif id == 35020 then
		hGlobal.event:event("LocalEvent_CloseGetAutoSaveFiletipFrm")
		local orderid = packet:readInt()
		local status  = packet:readInt()
		local rid = packet:readInt()-- 只在原来触发器3中有用 表示发起方的UID

		g_SyncDataTicketNum = orderid
		g_SyncDataState = status
		
		--状态0，订单刚产生 客户端并不处理任何逻辑
		if status == 0 then
		
		--开始上传存档
		elseif status == 1 then
			LuaDeletePlayerDataByName(orderid)
		--存档已上传完毕 B设备启动
		elseif status == 2 then
			LuaDeletePlayerDataAll(orderid)
		elseif status == 3 then
			_ncf["get_savefile_new"](0,"",1,rid,orderid)
		--这是服务器处理的本地不处理任何逻辑 4
		elseif status == 4 then
		
		--这是服务器处理的本地不处理任何逻辑 5
		elseif status == 5 then
		
		end
		
	elseif id == 33009 then
		local iErrCode = packet:readInt()
		local key = packet:readString()
		local data = packet:readString()
		--print("id == 33009", "iErrCode=" .. tostring(iErrCode) .. ", key=" .. tostring(key) .. ", data=" .. tostring(data))
		
		if iErrCode == 0 then
			local oWorld =  hGlobal.LocalPlayer:getfocusworld()
			if oWorld == nil then
				oWorld = hGlobal.LocalPlayer:getfocusmap()
			end
			
			--只在大厅界面处理以下逻辑
			if oWorld and (oWorld.data.map == hVar.PHONE_MAINMENU or hApi.CheckMapIsChapter(oWorld.data.map)) then
				local mode_s = string.sub(key, 1, string.find(key,"_") - 1)
				--print("mode_s=" .. tostring(mode_s))
				
				if (mode_s == "update") then
					hGlobal.event:event("LocalEvent_NewVerAction", data)
				elseif (mode_s == "notice") then
					hGlobal.event:event("LocalEvent_NewWebAction", data)
				end
			end
		end
	--查询锻造次数的返回，
	elseif id == 34003 then
		local type = packet:readInt() -- 34001,34002
		
		local iErrCode = packet:readInt()

		--print("34003:",type,iErrCode)
		
		if iErrCode == 0 then
			local tag = packet:readInt()
			local tradeid = packet:readInt()
			local param_num  = packet:readInt()

			local tempT = {}
			for i = 1,param_num do
				local key = packet:readString()
				local val = packet:readInt()
				tempT[key] = val
				--print("34003 1:",key,val)
			end

			local isFix = packet:readInt()
			
			--设置的返回接口
			if type == 34001  then
				--hGlobal.event:event("LocalEvent_Cheat_Set_NetMSG",tempT,tag,tradeid)
			--查询的返回接口 现在在自动恢复存档流程中 最后一步设置本地的 3个校验值
			elseif type == 34002 then
				for k,v in pairs(tempT) do
					if k == "cheat_depletion"  then
						LuaSetUseDepletion(v)
					elseif k == "cheat_fc" then
						LuaSetForgeCount(v)
						--print("just ....................... cheat_fc:",v)
					elseif k == "cheat_wishing" then
						LuaSetWisingCount(v)
					end
				end
				--hGlobal.event:event("LocalEvent_Cheat_Get_NetMSG",tempT,tag,tradeid,isFix)
			end
		end
	--elseif id == 34005 then
	--	local iErrCode = packet:readInt()
	--	local tag = packet:readInt()
	--	local tradeid = packet:readUInt()
	--	local itemID = packet:readInt()
	--
	--	if iErrCode == 0 then
	--		--如果是1 则发送申请锻造+1 
	--		if tag == 1 then
	--			SendCmdFunc["set_cheat_count"](tradeid,luaGetplayerDataID(),1,"cheat_fc",1,1)
	--		--如果是2 则发送使用宝箱
	--		elseif tag == 2 then
	--			SendCmdFunc["set_cheat_count"](tradeid,luaGetplayerDataID(),2,"cheat_depletion",1,1)
	--		--如果是3 则发送许愿
	--		elseif tag == 3 then
	--			SendCmdFunc["set_cheat_count"](tradeid,luaGetplayerDataID(),3,"cheat_wishing",1,1)
	--		--网络宝箱申请返回
	--		elseif tag == 4 then
	--			hGlobal.event:event("LocalEvent_Use_Net_chest",itemID,tradeid)
	--		end
	--	end
	elseif id == 34008 then
		local cheatflag = packet:readInt()
		xlSaveIntToKeyChain("cheatflag", cheatflag)
		
		--如果检测到作弊，直接提示作弊弹框，点击后退出
		if (cheatflag > 0) then
			local userID = xlPlayer_GetUID()
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_WanJia"].."ID:"..userID.."\n"..hVar.tab_string["__TEXT_cheatPlayer"],{
				font = hVar.FONTC,
				ok = function()
					xlExit()
				end,
			})
			return
		end
	elseif id == 33012 then
		--dlc 的返回
		local iErrCode = packet:readInt()
		local tag1 = packet:readInt()
		local tag2 = packet:readInt()
		local itemID = packet:readInt()
		local flag = packet:readInt()
		
		if flag ~= 0 then
			hGlobal.event:event("LocalEvent_Phone_afterBuyMapBag",hVar.tab_item[itemID].bagName)
			LuaSavePlayerList()
		end
		
	elseif id == 33014 then
		local iErrCode = packet:readInt()
		local tag1 = packet:readInt()
		local gameScore = packet:readInt()
		local itemID = packet:readInt()
		local op = packet:readInt()
		local ticketNum = packet:readInt()
		local tradeid = packet:readInt()
		
		if iErrCode == 0 then
			if hApi.CheckEntityItem(itemID) == 1 then
				LuaAddBuyCardInfo(itemID,ticketNum)
				LuaCheckBuyCardList()
				SendCmdFunc["get_VIP_REC_State"]()
				_ncf["buy_succeed"](tradeid)
			end
		end
	--网络宝箱 礼品卷 返回值
	elseif id == 34010 then
		local iErrCode = packet:readInt()
		
		if iErrCode == 0 then
			local tagN = packet:readUInt()
			local tagM = packet:readInt()
			local keyValN = packet:readInt()
			
			local tempList = {}
			for i = 1,keyValN do
				local key = packet:readString()
				local val = packet:readInt()
				tempList[key] = val
			end
			
			hGlobal.event:event("LocalEvent_getNetChestNum", tempList)
		end
	-- 描述：30311的回应包 返回以上数据 参数：p1(s32 proctol) p2(u32 uid) p3(s32 itag) p4(s32 listnum) p5(u32 prizeid) p6(s32 prizetype) p7(string prizecode)
	elseif id == 30312 then
--		local proctol = packet:readInt()
--		local uID = packet:readUInt()
--		local itag = packet:readInt()
--		local listN = packet:readInt()
--		
--		local dataTab = {}
--		for i = 1,listN do
--			local prizeid = packet:readUInt()
--			local prizetype = packet:readInt()		-- 1030 - 1035 分别对应 6,18,45,68,98,198 充值奖励 1038 , 1039 是充值送的积分箱子
--			local prizecode = packet:readString()
--			if hApi.CheckPrizeType(prizetype) == 1 then
--				dataTab[#dataTab+1] = {prizeid = prizeid,prizetype = prizetype,prizecode = prizecode,}
--				--print("prizeid,prizetype,prizecode:",prizeid,prizetype,prizecode)
--			end
--			
--		end
--		
--		hGlobal.event:event("LocalEvent_SetSystemMailData", proctol, uID, itag, dataTab)
		local proctol = packet:readInt()
		local uID = packet:readUInt()
		local itag = packet:readInt()
		if 2 <= proctol then
		    local iLanguage = packet:readInt()
		end
		local listN = packet:readInt()

		local dataTab = {}
		--老的解析过程
		if proctol == 0 then
			for i = 1,listN do
				local prizeid = packet:readUInt()
				local prizetype = packet:readInt()		-- 1030 - 1035 分别对应 6,18,45,68,98,198 充值奖励 1038 , 1039 是充值送的积分箱子
				local prizecode = packet:readString()
				if hApi.CheckPrizeType(prizetype) == 1 then
					dataTab[#dataTab+1] = {prizeid = prizeid,prizetype = prizetype,prizecode = prizecode,}
				end
			end
		--新的解析过程
		elseif proctol == 1 then
			for i = 1,listN do
				local prizeid = packet:readUInt()
				local prizetype = packet:readInt()		-- 1030 - 1035 分别对应 6,18,45,68,98,198 充值奖励 1038 , 1039 是充值送的积分箱子
				local prizecode = packet:readString()
				local prizecode2 = packet:readString()
				
				if hApi.CheckPrizeType(prizetype) == 1 then
					dataTab[#dataTab+1] = {prizeid = prizeid,prizetype = prizetype,prizecode = prizecode,prizecode2 = prizecode2,}
				end
			end
		--由服务器下发的描述信息
		elseif proctol == 2 then
			for i = 1,listN do
				local prizeid = packet:readUInt()
				local prizetype = packet:readInt()		-- 1030 - 1036 分别对应 6,18,68,98,198,388 充值奖励 1038 , 1039 是充值送的积分箱子
				local prizecode = packet:readString()
				local prizecode2 = packet:readString()
				local prizeinfo = packet:readString()
				if string.len(prizeinfo) < 8 then prizeinfo = nil end
				--print(string.format("%d prize_type:%d info:%s",i,prizetype,tostring(prizeinfo)))
				
				
				if hApi.CheckPrizeType(prizetype) == 1 then
					dataTab[#dataTab+1] = {prizeid = prizeid,prizetype = prizetype,prizecode = prizecode,prizecode2 = prizecode2,prizeinfo = prizeinfo}
				end
			end
		end
		
		hGlobal.event:event("LocalEvent_SetSystemMailData",proctol,uID,itag,dataTab)
		
	--描述：30313的回应包 返回以上数据 参数：p1(s32 proctol) p2(u32 uid) p3(u32 prizeid) p4(s32 itag) p5(s32 errcode) errcode: 0(成功) 1(没有该记录) 2(领取异常) 3(已经领取) 4(非法FLAG) 5(更新数据库失败)
	-- [p6(s32 prizetpe) p7(string prizecode)]
	elseif id == 30314 then
		local proctol = packet:readInt()
		local uID = packet:readUInt()
		local prizeid = packet:readUInt()
		local itag = packet:readInt()
		local iErrCode = packet:readInt()
		
		--0时 可以继续领取流程
		if iErrCode == 0 then
			local prizetype = packet:readInt()
			local prizecode = packet:readString()

			if type(prizecode) ~= "string" then
				xlAppAnalysis("prizecode-nil",0,1,"info",tostring(xlPlayer_GetUID()).."-T:"..tostring(os.date("%m%d%H%M%S")))
				return
			end
			local itemID,itemNum,itemName,itemHole,coin,score,itemBack,itemModel,GiftTip,_,_,_,_,giftType = hApi.UnpackPrizeData(prizetype,prizeid,prizecode)

			--针对首冲奖励的解析
			if prizetype == 1030 or prizetype == 1031 or  prizetype == 1032 or prizetype == 1033 or prizetype == 1034 or prizetype == 1035 then
				if giftType == 0 then
					hGlobal.event:event("LocalEvent_GetTopupGiftItem",{itemID},{itemNum},nil,nil,score,nil,nil,546,nil,prizeid)
				elseif giftType == 1 then
					hGlobal.event:event("LocalEvent_BuyHeroCardSucceed",itemID,1,1,prizeid)
					hGlobal.event:event("LocalEvent_SetConFirmImage",prizeid)
				end
			elseif prizetype == 9004 or prizetype == 9005 or prizetype == 9006 then
				hGlobal.event:event("LocalEvent_GetTopupGiftItem",{itemID},{itemNum},3,nil,score,nil,nil,546,nil,prizeid)
			elseif prizetype == 4 or prizetype == 6 then
				hGlobal.event:event("LocalEvent_GetTopupGiftItem",{itemID},{itemNum},1,nil,nil,nil,{itemHole},546,nil,prizeid)
			elseif prizetype == 7 then
				if type(itemName) == "string" then
					itemName = tonumber(string.sub(itemName,string.find(itemName,"Lv:")+3,string.len(itemName)))
				end
				hGlobal.event:event("localEvent_ShowBattlefieldSkillFrm",{{itemID,itemName,itemHole}},hGlobal.UI.WebViewNewVerFrm.data.x + 30,nil,1,1,prizeid)
				hGlobal.event:event("LocalEvent_SetConFirmImage",prizeid)

			elseif prizetype == 8 then
				hGlobal.event:event("LocalEvent_BuyHeroCardSucceed",itemID,1,1,prizeid)
				hGlobal.event:event("LocalEvent_SetConFirmImage",prizeid)
			elseif prizetype >=10 and  prizetype ~= 17 and prizetype <= 21 then
				hGlobal.event:event("LocalEvent_GetTopupGiftItem",{25,27},{score,coin},4,prizetype,score,nil,{itemHole},546,nil,prizeid)
			elseif prizetype == 1038 then
				hGlobal.event:event("LocalEvent_GetTopupGiftItem",{itemID},{itemNum},1,nil,nil,nil,{itemHole},546,nil,prizeid)
			elseif prizetype == 1039 or prizetype == 1060 then
				hGlobal.event:event("LocalEvent_GetTopupGiftItem",{25},{itemNum},1,nil,itemNum,nil,{itemHole},546,nil,prizeid)
			elseif prizetype == 1201 or prizetype == 1202 then
				hGlobal.event:event("LocalEvent_GetTopupGiftItem",{27},{coin},5,prizetype,score,nil,{itemHole},546,nil,prizeid)
			elseif prizetype == 1203 or prizetype == 1204 then
				hGlobal.event:event("LocalEvent_GetTopupGiftItem",{itemID},{itemNum},5,prizetype,score,nil,{itemHole},546,nil,prizeid)
			elseif prizetype == 9999 then
				hGlobal.event:event("LocalEvent_GetTopupGiftItem",{itemID},{itemNum},1,nil,score,nil,nil,546,nil,prizeid)
			elseif prizetype == 5000 then
				hGlobal.event:event("LocalEvent_GetTopupGiftItem",{27},{coin},6,prizetype,score,nil,{itemHole},546,nil,prizeid)
			elseif prizetype >= 9300 and prizetype <= 9305 then
				hGlobal.event:event("LocalEvent_GetTopupGiftItem",{itemID},{itemNum},3,nil,score,nil,nil,546,nil,prizeid)
			elseif prizetype == 6008 then
				if type(prizecode) == "string" then
					if string.find(prizecode,"h:") then
						hGlobal.event:event("LocalEvent_BuyHeroCardSucceed",itemID,1,1,prizeid)
					elseif string.find(prizecode,"b:") then
						hGlobal.event:event("localEvent_ShowBattlefieldSkillFrm",{{itemID,1}},hGlobal.UI.WebViewNewVerFrm.data.x + 30,nil,1,1,prizeid)
					end
					hGlobal.event:event("LocalEvent_SetConFirmImage",prizeid)
				end
			elseif prizetype == 7000 then
				local bfsList = {}
				if type(prizecode) == "string" then
					for v in string.gfind(prizecode,"([^%;]+);+") do
						bfsList[#bfsList+1] = {tonumber(string.sub(v,string.find(v,"ID:")+3,string.find(v,"LV:")-1)),tonumber(string.sub(v,string.find(v,"LV:")+3,string.len(v)))}
					end
					
					hGlobal.event:event("LocalEvent_ShowBFSEliteFrm",itemID,bfsList,1,prizeid)
				end
			--领取逻辑
			elseif prizetype == 10000 then
				local tempState = {}
				for prizecode in string.gfind(prizecode,"([^%;]+);+") do
					tempState[#tempState+1] = prizecode
				end
				--多个奖励
				if #tempState > 1 then
					for i = 1,#tempState do 
						local itemID,itemNum,itemName,itemHole,coin,score,itemBack,itemModel,GiftTip,GiftTip_Ex,giftType = hApi.UnpackPrizeDataEx(tempState[i],1)
						if (itemID == 27) then
							local reward = {{7, itemNum, 0, 0},}
							hApi.BubbleGiftAnim(reward, 1, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
						end
					end
				--只有一种奖励
				else
					local itemID,itemNum,itemName,itemHole,coin,score,itemBack,itemModel,GiftTip,GiftTip_Ex,giftType = hApi.UnpackPrizeDataEx(tempState[1],1)
					if (itemID == 27) then
						local reward = {{7, itemNum, 0, 0},}
						hApi.BubbleGiftAnim(reward, 1, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
					end
				end
				
				--print(#tempState)
				
				--漂浮文字提示
				hGlobal.event:event("LocalEvent_GetSystemGiftFloatNumber",tempState)
				hGlobal.event:event("LocalEvent_SetConFirmImage",prizeid)
				SendCmdFunc["confirm_prize_list"](prizeid)
			elseif prizetype == 11000 or prizetype == 11006 then
				print("prizeid",prizeid)
				local tempState = {}
				for prizecode in string.gfind(prizecode,"([^%;]+);+") do
					tempState[#tempState+1] = prizecode
				end
				--多个奖励
				if #tempState > 1 then
					for i = 1,#tempState do 
						local itemID,itemNum,itemName,itemHole,coin,score,itemBack,itemModel,GiftTip,GiftTip_Ex,giftType = hApi.UnpackPrizeDataEx(tempState[i])
						if (itemID == 25) then
							--修改添加积分的同时加上来源以便统计
							LuaAddPlayerScoreByWay(tonumber(itemNum),hVar.GET_SCORE_WAY.PURCHASE)
							hGlobal.event:event("LocalEvent_GetSystemMailScoreAward",itemNum)
						end
					end
				--只有一种奖励
				else
					local itemID,itemNum,itemName,itemHole,coin,score,itemBack,itemModel,GiftTip,GiftTip_Ex,giftType = hApi.UnpackPrizeDataEx(tempState[1])
					if (itemID == 25) then
						--修改添加积分的同时加上来源以便统计
						LuaAddPlayerScoreByWay(tonumber(itemNum),hVar.GET_SCORE_WAY.PURCHASE)
						hGlobal.event:event("LocalEvent_GetSystemMailScoreAward",itemNum)
					end
				end
				
				local keyList = {"material",}
				LuaSavePlayerData_Android_Upload(keyList, "充值成功")
				
				SendCmdFunc["confirm_prize_list"](prizeid)
			elseif (prizetype == 20001) then
				--脚本db协议处理该奖励
			elseif (prizetype == 20002) then
				--推荐人20游戏币领奖
			elseif (prizetype >= 20003 and prizetype <= 20007) then
				--推荐奖励
			elseif (prizetype == 20008) or (prizetype == 20009) then
				--活动奖励
			elseif (prizetype == 20010) or (prizetype == 20011) then
				--vip一次性奖励
			elseif (prizetype == 1036) then
				--首冲388档
			elseif (prizetype == 40000) then
				--策马三国志用户导入奖励
				--
				local reward = {{7, itemNum, 0, 0},}
				hApi.BubbleGiftAnim(reward, 1, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
			end
		else
			hGlobal.UI.MsgBox("iErrCode = "..iErrCode,{
				ok = function()
				end,
			})
		end
	elseif id == 32022 then
		local proctol = packet:readInt()
		local uID = packet:readUInt()
		local roleid = packet:readUInt()
		local itag = packet:readInt()
		local log_id = packet:readUInt()
		local log_state = packet:readInt()
		local log_time = packet:readString()

		hGlobal.event:event("LocalEvent_Get_Auto_Save_File",log_state,log_id,roleid,log_time)
	--获取t_user表中启动恢复存档的状态 show_getchadic
	elseif id == 32028 then
		local proctol = packet:readInt()
		local uID = packet:readUInt()
		local itag = packet:readInt()
		local iErrCode = packet:readInt()
		local show = packet:readInt()
		
		if iErrCode == 0 then
			hGlobal.event:event("LocalEvent_Set_Auto_Save_File_btn",show)
		end

	--elseif id == 32024 then
		--local proctol = packet:readInt()
		--local uID = packet:readUInt()
		--local roleid = packet:readUInt()
		--local itag = packet:readInt()
		--local fileN = packet:readInt()

		--local file_list = {}
		--for i = 1,fileN do
			--local dic_id = packet:readUInt()		--存档个数
			--local s_name = packet:readString()
			--local s_time = packet:readString()
			--file_list[#file_list+1] = {dic_id,s_name,s_time}
		--end
		
	elseif id == 32026 then
		local proctol = packet:readInt()
		local uID = packet:readUInt()
		local roleid = packet:readUInt()
		local itag = packet:readInt()			-- 当值为99 时，是服务器发起的 ，而不是通过 25发起的 回调
		local log_id = packet:readUInt()
		local dic_id = packet:readUInt()
		local iErrCode = packet:readInt()
		
		hUI.NetDisable(0)
		if iErrCode == 0 then
			----判断设备
			--local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
			------IOS
			--if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
			--	xlSaveIntToKeyChain("xlSaveFileBackState",1)
			----windows
			--else
			--	CCUserDefault:sharedUserDefault():setIntegerForKey("xlSaveFileBackState",1)
			--	CCUserDefault:sharedUserDefault():flush()
			--end
			_ncf["auto_saveFile_finishi"](log_id,dic_id)
			_ncf["get_savefile"](uID,"",1,dic_id)
		end
	elseif id == 34014 then
		local proctol = packet:readInt()
		local roleid = packet:readUInt()
		local type = packet:readInt()
		local num = packet:readInt()
		local strTag = packet:readString()
		local itag = packet:readInt()

		local iErrCode = packet:readInt()
		local logid = packet:readUInt()
		local num_left = packet:readInt()
		
		if iErrCode == 0 then
			
			hGlobal.event:event("LocalEvent_setNetChest_redNum",num_left,strTag,logid)
		elseif iErrCode == 4 then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant'UseDepletion3_Net"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end
	--删除存档的请求返回
	elseif id == 32035 then
		local proctol = packet:readInt()
		local uid = packet:readUInt()
		local roleid = packet:readUInt()
		local itag = packet:readInt()
		local iErrCode = packet:readInt()
		
		--
		hGlobal.event:event("LocalEvent_Phone_DeletePlayer",nil,itag)
	--查询Uid下更新过的 Rid
	elseif id == 32033 then
		local proctol = packet:readInt()
		local uid = packet:readUInt()
		local itag = packet:readInt()
		local iErrCode = packet:readInt()
		
		SendCmdFunc["C2S_LOG"]("CHECK_RID:32033:"..tostring(iErrCode))
		--只有为0时才有更新过的存档
		if iErrCode == 0 then
			local roleid = packet:readUInt()
			local gamescore = packet:readInt()
			local name = packet:readString()
			local time = packet:readString()
			
			SendCmdFunc["C2S_LOG"]("CHECK_RID:32033:"..tostring(name)..":"..tostring(roleid)..":"..tostring(time)..":"..tostring(gamescore))
			if Save_playerList and roleid ~= 0 then
				Save_playerList.SaveBackName = name
				Save_playerList.SaveBackRid = roleid
				Save_playerList.SaveBackTime = time
				Save_playerList.SaveBackGameScore = gamescore
				LuaSavePlayerList()
			else
			
			end
			
		end
	--打开活动查询邮件的特殊回调
	elseif id == 30317 then
		local proctol = packet:readInt()
		local uid = packet:readUInt()
		local itag = packet:readInt()
		local aid = packet:readUInt()
		local mail_type = packet:readInt()
		local detail = packet:readString()
		local maxM = packet:readInt()

		if proctol == 0 then
			if type(detail) ~= "string" then
				xlAppAnalysis("prizecode-nil",0,1,"info",tostring(xlPlayer_GetUID()).."-T:"..tostring(os.date("%m%d%H%M%S")))
				return
			end
			
			local itemID,itemNum,itemName,itemHole,coin,score,itemBack,itemModel,GiftTip,GiftTip_Ex,TopUpMax,BarY,ExG = hApi.UnpackPrizeData(mail_type,aid,detail)
			if type(TopUpMax) == "string" then
				TopUpMax = tonumber(TopUpMax)
			end
			if type(BarY) == "string" then
				BarY = tonumber(BarY)
			end
			
			hGlobal.event:event("LocalEvent_WebViewNewVerFrm", GiftTip, GiftTip_Ex, maxM, TopUpMax, BarY, ExG)
		end
	--获取
	elseif id == 34021 then
		local proctol = packet:readInt()
		local uid = packet:readUInt()
		local rid = packet:readUInt()
		local itag = packet:readInt()
		local iErrCode = packet:readInt()
		local ext_consuming = packet:readString() or ""
		
		if iErrCode == 0 then
			--print("ext_consuming", ext_consuming)
			hGlobal.event:event("LocalEvent_GetBuyItmeState", ext_consuming)
		end

	--设置 t_cha表中 ext_consuming 的返回
	elseif id == 34023 then
		local proctol = packet:readInt()
		local uid = packet:readUInt()
		local rid = packet:readUInt()
		local itag = packet:readInt()
		local iErrCode = packet:readInt()
		local strTag = packet:readString()
		
		if (iErrCode == 0) then
			local tabSI = hVar.tab_shopitem[itag]
			if tabSI==nil then
				return
			end
			local nItemID = tabSI.itemID
			local nCostScore = tabSI.score
			local nCostRMB = tabSI.rmb
			local sItemName = hVar.tab_stringI[nItemID][1]
			
			--SendCmdFunc["buy_shopitem"](nItemID,nCostRMB,sItemName,nCostScore,strTag)
			SendCmdFunc["order_begin"](6,nItemID,nCostRMB,1,sItemName,nCostScore,0,"sc:".. tostring(nCostScore or 0))
		else
			hGlobal.UI.MsgBox("Error account number",{ 
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end
	--新的 订单系统的 申请返回
	elseif id == 40001 then
		local proctol = packet:readInt()		--(protocol	int)
		local iErrCode = packet:readInt()		--(errcode	int) 0 表示成功
		local order_id = packet:readInt()		--(order_id	int)
		local order_type =  packet:readInt()		--(type		int)
		local uid = packet:readInt()			--(uid		int)
		local rid = packet:readInt()			--(rid		int)
		local item_id = packet:readInt()		--(item_id	int)
		local item_num = packet:readInt()		--(item_num	int)
		local overage = packet:readInt()		-- 余额
		local LC = packet:readInt()			--客户端校验值
		local SC = packet:readInt()			--服务器校验值
		local count = packet:readInt()			--如果是密保碎片箱子的话 会有值
		local strTag = packet:readString()
		
		--print("iErrCode=", iErrCode)

		if type(count) == "number" and count > 0 then
			hGlobal.event:event("LocalEvent_setChipNum",count)
		end
		
		if iErrCode == 0 then
			if order_type ~= 5 then
				local refreshFlag = false
				for i = 1,999 do
					local v = hVar.tab_shopitem[i]
					if v~=nil and v.itemID == item_id and (v.rmb or 0) > 0 then
						refreshFlag = true
						break
					end
				end
				if refreshFlag then
					hVar.ROLE_PLAYER_GOLD = overage --存储本地金币数量
					hGlobal.event:event("LocalEvent_Phone_SetCurGameCoin_Game",overage)
					hGlobal.event:event("LocalEvent_SetCurGameCoin",overage)
				end
			end
			
			--锻造流程
			if order_type == 1 then
				--todo:zhenkira 2016.03.18 目前锻造流程无法扣除游戏币，需要程序修改才能正常使用
				----合成
				if item_id == 9901 then
					hGlobal.event:event("LocalEvent_order_forge",SC,order_type,order_id,strTag)
				----洗练
				--elseif item_id >= 9902 and item_id <= 9905 then
				--	hGlobal.event:event("LocalEvent_order_xilian",SC,order_type,order_id,strTag)
				----重铸
				--elseif item_id >= 9906 and item_id <= 9909 then
				--	hGlobal.event:event("LocalEvent_order_rebuild",SC,order_type,order_id,strTag)
				end
				
			--使用宝箱流程
			elseif order_type == 2 then
				hGlobal.event:event("LocalEvent_order_useritem",SC,order_type,order_id)
			--使用网络宝箱流程
			elseif order_type == 4 then
				--print("使用网络宝箱流程")
				hGlobal.event:event("LocalEvent_order_Use_Net_chest",item_id,order_id)
			--购买地图包流程
			elseif hVar.tab_item[item_id].type == hVar.ITEM_TYPE.MAPBAG then
				hGlobal.event:event("LocalEvent_Phone_afterBuyMapBag",hVar.tab_item[item_id].bagName,order_id)
				LuaSavePlayerList()
			--玩家道具 不走英雄背包流程
			elseif hVar.tab_item[item_id].type == hVar.ITEM_TYPE.PLAYERITEM then
				local matVal = {}
				matVal = hVar.tab_item[item_id].matVal
				--材料道具 直接增加玩家材料
				if matVal then
					LuaSetPlayerMaterial(matVal[1],LuaGetPlayerMaterial(matVal[1])+matVal[2])
				end
				local tShopItem = nil
				local nShopItemID = 0
				for i = 1,999 do
					local v = hVar.tab_shopitem[i]
					if v~=nil and v.itemID == item_id then
						nShopItemID = i
						tShopItem = v
						break
					end
				end
				
				--购买成功的事件消息
				if nShopItemID ~= 0 then
					hGlobal.event:event("LocalEvent_BuyItemSucceed",nShopItemID,item_id,overage)
				end
				_ncf["order_update"](order_id,1,strTag)
			--英雄卡片道具 直接走获得卡片流程
			elseif hVar.tab_item[item_id].type == hVar.ITEM_TYPE.HEROCARD then
				hGlobal.event:event("LocalEvent_BuyHeroCardSucceed",hVar.tab_item[item_id].heroID, hVar.tab_item[item_id].heroStar, hVar.tab_item[item_id].heroLv)
				local tShopItem = nil
				local nShopItemID = 0
				for i = 1,999 do
					local v = hVar.tab_shopitem[i]
					if v~=nil and v.itemID == item_id then
						nShopItemID = i
						tShopItem = v
						break
					end
				end
				
				--购买成功的事件消息
				if nShopItemID ~= 0 then
					hGlobal.event:event("LocalEvent_BuyItemSucceed",nShopItemID,item_id,overage)
				end
				_ncf["order_update"](order_id,1,strTag)
			elseif hVar.tab_item[item_id].type == hVar.ITEM_TYPE.RESOURCES then
				
				--积分信息
				if type(strTag) == "string" and string.find(strTag,"sc:")then
					local score = string.sub(strTag,4,string.len(strTag))
					LuaAddPlayerScore(-score)
				end
				
				--zhenkira, 订单系统的资源类流程，现在被接管了，目前用来增加积分
				--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.CRYSTAL,hVar.tab_item[item_id].val)
				
				if hVar.tab_item[item_id].resource and type(hVar.tab_item[item_id].resource) == "table" then
					local rType = hVar.tab_item[item_id].resource[1] or ""
					local rVal = hVar.tab_item[item_id].resource[2] or 0
					if rType == "score" then
						LuaAddPlayerScore(rVal)
					end
				end
				
				local tShopItem = nil
				local nShopItemID = 0
				for i = 1,999 do
					local v = hVar.tab_shopitem[i]
					if v~=nil and v.itemID == item_id then
						nShopItemID = i
						tShopItem = v
						break
					end
				end
				
				--购买成功的事件消息
				if nShopItemID ~= 0 then
					hGlobal.event:event("LocalEvent_BuyItemSucceed",nShopItemID,item_id,overage)
				end
				_ncf["order_update"](order_id,1,strTag)
			--重选宝箱
			elseif item_id == 6000 or item_id == 6001 or item_id == 6002 then
				hGlobal.event:event("LocalEvent_BuyResetSucceed",order_id)
			--合成卡片付费成功
			elseif item_id == 11 
				or item_id == 6003 
				or item_id == 6004 
				or item_id == 6005 
				or item_id == 6006 
				or item_id == 6007 
				or item_id == 6008 
				or item_id == 6009 
				or item_id == 6010 
				or item_id == 6011 
				or item_id == 6012 then
				
				if type(strTag) == "string" then
					local s,e = string.find(strTag,"sc:([%d]+);")
					local c,r = string.find(strTag,"c:([%d]+);")
					
					if s and e and c and r then
						--我负责扣钱
						local nScoreCost = tonumber(string.sub(strTag,s+3,e-1))
						local nGameCoin = tonumber(string.sub(strTag,c+2,r-1))
						
						local rs = 0
						--合成卡牌 积分支付
						if type(nGameCoin) == "number" and nGameCoin  == 0 then
							if type(nScoreCost) == "number" and nScoreCost >= 0 and LuaGetPlayerScore() >= nScoreCost then
								LuaAddPlayerScore(-1*nScoreCost)
								rs = 1
							end
						--游戏币支付
						elseif type(nGameCoin) == "number" and nGameCoin  > 0 then
								rs = 1
						end
						if rs == 1 then
							hGlobal.event:event("localEvent_afterPhoneDeleteBFSkillCardGame",nil,item_id,strTag)
							_ncf["order_update"](order_id,1,strTag)
						end
					end
				end
			--红装许愿
			elseif item_id == 12 then
				--SendCmdFunc["send_net_keyC_log"](luaGetplayerDataID(),3,item_id,hVar.tab_stringI[item_id][1],"cheat_wishing",LuaGetWisingCount())
				--SendCmdFunc["set_cheat_count"](0,luaGetplayerDataID(),3,"cheat_wishing",1,1)
				hGlobal.event:event("LocalEvent_AfterWishing",order_id,SC)
			--付费锁孔
			elseif item_id == 14 then
				_ncf["order_update"](order_id,1,strTag)
				hGlobal.event:event("localEvent_afterRecastItemSucceed",overage,strTag,order_id)
			elseif item_id == 50000 then
				--hGlobal.event:event("LocalEvent_CleanRsdyzPointsAndCoin")
				--Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetZoneData,luaGetplayerDataID(),luaGetplayerDataID()})
			--技能升级
			elseif item_id >= 10001 and item_id <= 10040 then
				_ncf["order_update"](order_id,1,strTag)
				hGlobal.event:event("localEvent_afterSkillLvUpSucceed", overage, strTag, order_id)
			--战术技能卡升级
			elseif item_id >= 10101 and item_id <= 10110 then
				_ncf["order_update"](order_id,1,strTag)
				--print(overage, " ", strTag, " ", order_id)
				hGlobal.event:event("localEvent_afterTacticLvUpSucceed", overage, strTag, order_id)
			--英雄升星
			elseif item_id >= 10191 and item_id <= 10200 then
				_ncf["order_update"](order_id,1,strTag)
				hGlobal.event:event("localEvent_afterHeroStarUpSucceed",overage,strTag,order_id)
			-----------------------------------------------------暂时写在这里----------------------------------------------------------
			--洗练
			elseif item_id >= 9902 and item_id <= 9905 then
				hGlobal.event:event("LocalEvent_order_xilian",SC,order_type,order_id,strTag)
			--重铸
			elseif item_id >= 9906 and item_id <= 9909 then
				hGlobal.event:event("LocalEvent_order_rebuild",SC,order_type,order_id,strTag)
			-----------------------------------------------------暂时写在这里----------------------------------------------------------
			--购买新手礼包
			elseif hVar.tab_item[item_id].type == hVar.ITEM_TYPE.GIFTITEM then
				--积分信息
				if type(strTag) == "string" and string.find(strTag,"sc:")then
					local score = string.sub(strTag,4,string.len(strTag))
					LuaAddPlayerScore(-score)
				end
				hGlobal.event:event("LocalEvent_BuyGiftItem",hVar.tab_item[item_id].gift,item_id)
				local tShopItem = nil
				local nShopItemID = 0
				for i = 1,999 do
					local v = hVar.tab_shopitem[i]
					if v~=nil and v.itemID == item_id then
						nShopItemID = i
						tShopItem = v
						break
					end
				end
				--购买成功的事件消息
				if nShopItemID ~= 0 then
					hGlobal.event:event("LocalEvent_BuyItemSucceed",nShopItemID,item_id,overage)
				end
				_ncf["order_update"](order_id,1,strTag)
			--商店购物
			else
				--积分信息
				if type(strTag) == "string" and string.find(strTag,"sc:")then
					local score = string.sub(strTag,4,string.len(strTag))
					LuaAddPlayerScore(-score)
				end
				
				local tShopItem = nil
				local nShopItemID = 0
				for i = 1,999 do
					local v = hVar.tab_shopitem[i]
					if v~=nil and v.itemID == item_id then
						nShopItemID = i
						tShopItem = v
						break
					end
				end
				
				--不需要实体的道具 直接开启
				if hApi.CheckEntityItem(item_id) == 1 then
					local typ,ex,val = unpack(hVar.tab_item[item_id].used)
					hApi.UnitGetLoot(nil,typ,ex,val,nil,nil,nil,nil,{item_id})
					--LuaAddBuyCardInfo(item_id,ticketNum)
					--LuaCheckBuyCardList()
					SendCmdFunc["get_VIP_REC_State"]()
				else
					
					local isEqu = 0
					if hVar.tab_item[item_id].type >= hVar.ITEM_TYPE.HEAD and hVar.tab_item[item_id].type <= hVar.ITEM_TYPE.FOOT then
						isEqu = 1
					end
					if isEqu == 1 then
						if LuaAddItemToPlayerBag(item_id,{1,0},nil,tShopItem.exValueRatio or 0) == 1 then
							LuaAddGetGiftCount(item_id)
						end
					end
				end
				
				--购买成功的事件消息
				if nShopItemID ~= 0 then
					hGlobal.event:event("LocalEvent_BuyItemSucceed",nShopItemID,item_id,overage)
				end
				_ncf["order_update"](order_id,1,strTag)
			end
			LuaSaveHeroCard()
		elseif (iErrCode == 1) then
			print("not enough money")
			if hVar.tab_item[item_id].onlyonce == 1 then
				--SendCmdFunc["setShopState"](strTag,0,"")
			end
			
			hGlobal.event:event("LocalEvent_BuyItemfail", iErrCode, item_id)
		elseif (iErrCode == 2) then
			print("device is illegal")
			if hVar.tab_item[item_id].onlyonce == 1 then
				--SendCmdFunc["setShopState"](strTag,0,"")
			end
			
			hGlobal.event:event("LocalEvent_BuyItemfail", iErrCode, item_id)
		elseif (iErrCode == 23) then
			hGlobal.event:event("LocalEvent_BuyItemfail", iErrCode, item_id)
		elseif (iErrCode == 30) then --版本太旧
			--服务器会触发弹框本地版本太旧
			--[[
			hGlobal.UI.MsgBox(hVar.ORDER_SYS_ERRORLIST[iErrCode].."\nerrcode="..tostring(iErrCode),{
				font = hVar.FONTC,
				ok = function()
				end,
			})
			]]
		elseif (iErrCode == 45) then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_WattingPlease"], {
				font = hVar.FONTC,
				ok = function()
				end,
			})
			hGlobal.event:event("LocalEvent_BuyItemfail", iErrCode, item_id)
		elseif (iErrCode == 112) then
			--获取t_cha表中的3个校验值 锻造 开箱子 许愿
			local type_1 = LuaGetForgeCount()
			local type_2 = LuaGetUseDepletion()
			local type_3 = LuaGetWisingCount()
			
			if type_1 == 0 then
				SendCmdFunc["get_cheat_val"](luaGetplayerDataID(),1,"cheat_fc")
			elseif type_2 == 0 then
				SendCmdFunc["get_cheat_val"](luaGetplayerDataID(),2,"cheat_depletion")
			elseif type_3 == 0 then
				SendCmdFunc["get_cheat_val"](luaGetplayerDataID(),3,"cheat_wishing")
			end
			
			hGlobal.UI.MsgBox(hVar.tab_string["ios_tip_network_waiting_server_response1"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			hGlobal.event:event("LocalEvent_BuyItemfail", iErrCode, item_id)
		elseif (iErrCode == 166) then --已购买但是没收到finishflag
			--对道具id进行判断	在50 ~ 100 之前 是描述为 地图包 
			if type(item_id) == "number" then
				if 50 <= item_id and item_id < 100 then
					if hVar.tab_item[item_id].type == hVar.ITEM_TYPE.MAPBAG then
						hGlobal.event:event("LocalEvent_Phone_afterBuyMapBag", hVar.tab_item[item_id].bagName)
						LuaSaveHeroCard()
					end
				elseif 9103 <= item_id and item_id < 9199 then
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Can'tBuyAgain"],{             --弹出只能购买一次的MessageBox
						font = hVar.FONTC,
						ok = function()
							hGlobal.event:event("LocalEvent_BuyGiftfail", iErrCode, item_id)
						end,
					})
				end
			end
			--hGlobal.event:event("LocalEvent_BuyItemfail",iErrCode,item_id)
		elseif (iErrCode == 188) then --已购买但是没收到finishflag
			print("not enough money")
			--该流程已废弃
			--if hVar.tab_item[item_id].onlyonce == 1 then
				--SendCmdFunc["setShopState"](strTag,0,"")
			--end
			
			hGlobal.event:event("LocalEvent_BuyItemfail", iErrCode, item_id)
		elseif hVar.ORDER_SYS_ERRORLIST[iErrCode] then --其他错误码
			hGlobal.UI.MsgBox(hVar.ORDER_SYS_ERRORLIST[iErrCode].."\nerrcode="..tostring(iErrCode),{
				font = hVar.FONTC,
				ok = function()
				end,
			})
			hGlobal.event:event("LocalEvent_BuyItemfail", iErrCode, item_id)
		end
	--获取能量值的返回
	elseif id == 50001 then
		local proctol = packet:readInt()
		local iErrCode = packet:readInt()
		
		if iErrCode == 0 then
			local uid = packet:readInt()
			local rid = packet:readInt()
			local key = packet:readString()
			local ptype = packet:readInt()
			local val = nil
			if ptype == 0 then
				val = packet:readInt()
			elseif ptype == 1 then
				val = packet:readString()
			end
			
			print("50001",val)
			hGlobal.event:event("LocalEvent_GetEnergy_Success", val)
		else
			hGlobal.UI.MsgBox("Error 50001 iErrCode = \n"..tostring(iErrCode),{ 
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end
		
		
	
	--设置能量值的返回
	elseif id == 50003 then
		local proctol = packet:readInt()
		local iErrCode = packet:readInt()
		
		if iErrCode == 0 then
			local uid = packet:readInt()
			local rid = packet:readInt()
			local key = packet:readString()
			
			--hGlobal.UI.MsgBox("succeed 50003 key = \n"..tostring(key),{ 
			--	font = hVar.FONTC,
			--	ok = function()
			--	end,
			--})
		else
			hGlobal.UI.MsgBox("Error 50003 iErrCode = \n"..tostring(iErrCode),{ 
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end
		
		hGlobal.event:event("LocalEvent_SetEnergy_Return", iErrCode, key)
	elseif (id == 35012) then --获得活动列表返回
		local protocol = packet:readInt()			--预留
		local iErrCode = packet:readInt()			--(errcode int) 0 表示成功
		local uid = packet:readInt()				--uId
		local rid = packet:readInt()				--rId
		local itag = packet:readInt()				--itag
		local listnum = packet:readInt()			--listnum
		--print("iErrCode", iErrCode, "itag", itag, "listnum", listnum)
		
		if (iErrCode == 0) then
			--[[
			local t = {}
			for i = 1,listnum do
				local tempT = {}
				tempT.aid = packet:readInt()
				tempT.ptype = packet:readInt()
				
				newTemp = {}
				local tt = packet:readString()
				
				local sPrize = ""
				if type(tt) == "string" then
					sPrize = "newTemp = {"..tt.."}"
				end
				local f = loadstring(sPrize)
				if type(f) == "function" then
					f()
				else
					return
				end
				tempT.prize = newTemp
				newTemp = nil
				
				for j = 1,#tempT.prize do
					local v = tempT.prize[j].prize
					for k=1,#v do
						if "ix" == v[k].type and 
						   (9300 == v[k].id or
						    9301 == v[k].id or
						    9302 == v[k].id or
						    9303 == v[k].id or
						    9304 == v[k].id or
						    9305 == v[k].id) then
							v[k].id = hVar.tab_item[v[k].id].chipid or 0
						end
					end
				end
				tempT.title = packet:readString()
				tempT.describe = packet:readString()
				tempT.time_begin = packet:readInt()
				tempT.time_end = packet:readInt()
				
				t[#t+1] = tempT
				
			end
			
			local tCurTask = {}
			local tComingTask = {}
			local tEndTask = {}
			for i = 1,#t do
				if t[i].time_end < 0 then
					tEndTask[#tEndTask+1] = t[i]
				elseif t[i].time_begin > 0 then
					tComingTask[#tComingTask+1] = t[i]
				else
					tCurTask[#tCurTask+1] = t[i]
				end
			end
			local tTaskList = {}
			for i = 1,#tCurTask do
				tTaskList[#tTaskList+1] = tCurTask[i]
			end
			for i = 1,#tComingTask do
				tTaskList[#tTaskList+1] = tComingTask[i]
			end
			for i = 1,#tEndTask do
				tTaskList[#tTaskList+1] = tEndTask[i]
			end
			
			hGlobal.event:event("localEvent_UpdateActivityInfo", tTaskList)
			]]
			local t = {}
			for i = 1, listnum, 1 do
				local tempT = {}
				tempT.aid = packet:readInt()
				tempT.ptype = packet:readInt()
				tempT.prize = {} --默认为空表（有时候取到nil）
				
				local szPrize = packet:readString()
				--print("szPrize=", szPrize)
				if (type(szPrize) == "string") and (szPrize ~= "{}") then
					szPrize = "{" .. szPrize .. "}"
					local tmp = "local prize = " .. szPrize .. " return prize"
					tempT.prize = assert(loadstring(tmp))()
				end
				
				tempT.title = packet:readString()
				tempT.describe = packet:readString()
				tempT.time_begin = packet:readInt()
				tempT.time_end = packet:readInt()
				
				--geyachao: 只有在查询活动进度时候，才会发奖，这里只好在获得任务后查询一次（是否需要这么做？？？）
				--发起查询，本条活动的完成进度
				--ptype:300: 显示夺塔奇兵娱乐房开放时间（仅用于界面显示，不发奖）
				--ptype:301: 显示夺塔奇兵主菜单按钮开启时间（仅用于界面显示，不发奖）
				if (tempT.ptype > 0) then
					--非300、301号活动加到数组里
					if (tempT.ptype ~= 300) and (tempT.ptype ~= 301) then
						t[#t+1] = tempT
						
						--本地标记已看过此活动
						--LuaAddActivityAid(g_curPlayerName, tempT.aid)
						
						--print(tempT.aid, tempT.ptype)
						if (#tempT.prize > 0) then
							SendCmdFunc["get_ActivityRate"](tempT.aid, tempT.ptype)
						end
					end
				end
				
				--竞技场测试期间，娱乐房开启时间
				if (tempT.ptype == 300) then
					g_pvp_room_title = tempT.title
					g_pvp_room_describe = tempT.describe
					g_pvp_room_begintime = hApi.GetNewDate(g_systime) + tempT.time_begin
					g_pvp_room_closetime = hApi.GetNewDate(g_systime) + tempT.time_end
				end
				
				--竞技场测试期间，主菜单按钮开启时间
				if (tempT.ptype == 301) then
					g_pvp_button_begintime = hApi.GetNewDate(g_systime) + tempT.time_begin
					g_pvp_button_closetime = hApi.GetNewDate(g_systime) + tempT.time_end
				end
			end
			hGlobal.event:event("localEvent_UpdateActivityInfo", t)
		else
			--print("35012",iErrCode)
		end
	elseif id == 35014 then
		local protocol = packet:readInt()			--预留
		local iErrCode = packet:readInt()			--(errcode int) 0 表示成功
		
		
		local uid = packet:readInt()				--uId
		local rid = packet:readInt()				--rId
		local aid = packet:readInt()				--aid
		local itag = packet:readInt()				--itag
		local num = packet:readInt()				--进度的条目
		
		local t = {}
		for i = 1,num do
			t[i] = packet:readInt()				--t
		end
		hGlobal.event:event("localEvent_UpdateActivityReward",aid,itag,t)
	elseif id == 36051 then
		local protocol = packet:readInt()	--预留
		local iErrCode = packet:readInt()

		local uid = packet:readInt()		--uId
		local nPassTime = packet:readInt()	--时间
		hGlobal.event:event("LocalEvent_GetAdsTime",nPassTime)
	elseif id == 37001 then
		local protocol = packet:readInt()	--预留
		local iErrCode = packet:readInt()
		
		hUI.NetDisable(0)
		
		if iErrCode == 0 then
			local uid_me = packet:readInt()		--uId_me
			local uid_to = packet:readInt()		--uId_to
			local itag = packet:readInt()		--itag

			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT__Applied"],{ 
				font = hVar.FONTC,
				ok = function()
				end,
			})
		elseif iErrCode == 101 then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT__Have_Applied_toUID"],{ 
				font = hVar.FONTC,
				ok = function()
				end,
			})
		elseif iErrCode == 102 then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT__Have_Applied_meUID"],{ 
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end
	elseif id == 40101 then
		local protocol = packet:readInt()
		local iErrCode = packet:readInt()
		local iIapType = packet:readInt()
		local iUid = packet:readInt()
		local iRid = packet:readInt()
		local iItemNum = packet:readInt()
		local iItemSections = packet:readInt()
		local list = {}
		if 0 == iErrCode and iItemNum > 0 and iItemSections > 0 then
			for i = 1,iItemNum do
				list[i] = {}
				list[i].itemid = packet:readInt() --id
				list[i].coin = packet:readInt() --coin
				list[i].money = packet:readInt() --money
				print("list[%d] id:%d coin:%d money:%d \n",list[i][1],list[i][2],list[i][3])
			end
		end
		getIapMgr().OnGetItemList(iIapType,list)
	elseif id == 40103 then
		local protocol = packet:readInt()
		local iErrCode = packet:readInt()
		local iIapType = packet:readInt()
		local iUid = packet:readInt()
		local iRid = packet:readInt()
		local iItemId = packet:readInt()
		local sOrderId = nil
		local sOrderData = nil
        local sPrice = nil
		if 0 == iErrCode then
			sOrderId = packet:readString()
			sOrderData = packet:readString()
            sPrice = packet:readString()
            getIapMgr().OnGetItemOrder(iIapType,iItemId,sOrderId,sOrderData,sPrice)
        else
            xlLuaEvent_Topup_Failed(1)
		end
	elseif id == 40105 then
		local protocol = packet:readInt()
		local iErrCode = packet:readInt()
		local iIapType = packet:readInt()
		local iUid = packet:readInt()
		local iRid = packet:readInt()
		local iItemNum = packet:readInt()
		local list = {}
		for i = 1,iItemNum do
		    local szProductId   =   packet:readString()
		    local szName        =   packet:readString()
		    local iPrice        =   packet:readInt()
		    local iCoin         =   packet:readInt()
		    local szPriceDesc   =   string.format(hVar.tab_string["cmd_40105"],iPrice)
		    local iProductId    =   tonumber(szProductId)
		    local iProductPrice =   string.format("%.2f",iPrice)
		    list[#list + 1] = {productId = iProductId,productName = szName,productPriceDesc = szPriceDesc,productGameCoin = iCoin,productPrice = iProductPrice}
		end
		print("40105",iErrCode)
		--local uid = xlPlayer_GetUID()
		--local rid = luaGetplayerDataID()
		--local strText = "40105 iErrCode:"..iErrCode.." num:"..#list.." UID:"..uid.." RID:"..rid
		--table_print(list)
		--hGlobal.UI.MsgBox(strText, {
			--font = hVar.FONTC,
			--ok = function()
				----self:setstate(1)
			--end,
		--})
		xlLuaEvent_OnIapList(list)
	elseif id == 30012 then
		local protocol = packet:readInt()
		local uid = packet:readInt()
		local coin = packet:readInt()
		local vip = packet:readInt()
		local money = packet:readInt()

		--hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Topup_Success_Tip"],{
			--font = hVar.FONTC,
			--ok = function()
			--end,
		--})

		hGlobal.event:event("LocalEvent_RechargeSuccess")
		
		hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
		hGlobal.event:event("LocalEvent_CloseMonthCardInfoFrm")
		hGlobal.event:event("LocalEvent_Purchase_Back", 1)

		xlAppAnalysis("topup_ok",0,1,"info",tostring(xlPlayer_GetUID()).."-"..tostring(coin).."-T:"..tostring(os.date("%m%d%H%M%S")))
		
		--if coin == 0 then
			--hGlobal.event:event("LocalEvent_Phone_SetCurGameCoin_Game",coin)
			--hGlobal.event:event("LocalEvent_SetCurGameCoin",coin)
			--LuaSetPlayerVipLv(vip)
			--LuaSetTopupCoinCount(money*5)
		--end
	elseif (id == 30013) then --1元档充值成功（安卓）
		local protocol = packet:readInt()
		local uid = packet:readInt()
		local giftId = packet:readInt()
		local money = packet:readInt()
		
		--触发事件：1元档充值返回（安卓）
		hGlobal.event:event("localEvent_LimitTimeGiftOrderRet", iErrCode)
		
	elseif id == 4103 then
		NetCallBack_Login(packet)
	elseif (id == 40109) then --安卓，1元档返回
		--print("40109")
		local protocol = packet:readInt()
		local iErrCode = packet:readInt()
		local iIapType = packet:readInt()
		local iUid = packet:readInt()
		local iRid = packet:readInt()
		local iItemNum = packet:readInt()
		--print("protocol=", protocol)
		--print("iErrCode=", iErrCode)
		--print("iIapType=", iIapType)
		--print("iUid=", iUid)
		--print("iRid=", iRid)
		--print("iItemNum=", iItemNum)
		local list = {}
		for i = 1, iItemNum, 1 do
			local iGiftId = packet:readInt() --礼包id
			local iGiftMoney = packet:readInt() --价格(元)
			local iCount = packet:readInt() --以购买次数
			local szGiftInfo = packet:readString() --礼包信息
			local szGiftPrize = packet:readString() --礼包奖励
			local sProductId = 0
			local iMaxCount = 1 --最大购买次数
			if protocol == 1 then
				sProductId = packet:readString() --充值条目
			end
			if protocol == 2 then
				sProductId = packet:readString() --充值条目
				iMaxCount = packet:readInt() --以购买次数
			end
			list[#list + 1] = {iGiftId = iGiftId, iGiftMoney = iGiftMoney, iCount = iCount, iMaxCount = iMaxCount, szGiftInfo = szGiftInfo, szGiftPrize = szGiftPrize,sProductId = sProductId}
			--print("	i=", i)
			--print("	iGiftId=", iGiftId)
			--print("	iGiftMoney=", iGiftMoney)
			--print("	iCount=", iCount)
			--print("	szGiftInfo=", szGiftInfo)
			--print("	szGiftPrize=", szGiftPrize)
		end
		--table_print(list)
		hGlobal.event:event("GetPurchaseGiftList",iErrCode, iIapType, iUid, iRid, iItemNum, list)
	elseif (id == 40111) then --安卓，1元档充值返回
		local protocol = packet:readInt()
		local iErrCode = packet:readInt()
		local iIapType = packet:readInt()
		local iUid = packet:readInt()
		local iRid = packet:readInt()
		local iItemId = packet:readInt()
		local sOrderId = 0
		local sOrderData = ""
		local sPrice = ""
		--print("protocol=", protocol)
		--print("iErrCode=", iErrCode)
		--print("iIapType=", iIapType)
		--print("iUid=", iUid)
		--print("iRid=", iRid)
		--print("iItemId=", iItemId)
		--print("sOrderId=", sOrderId)
		--print("sOrderData=", sOrderData)
		--print("sPrice=", sPrice)
		if (iErrCode == 0) then
			--挡操作
			hUI.NetDisable(5000, "purchase")
			
			sOrderId = packet:readString()
			sOrderData = packet:readString()
			sPrice = packet:readString()
			getIapMgr().OnGetItemOrder(iIapType,iItemId,sOrderId,sOrderData,sPrice)
			--print("	i=", i)
			--print("	iGiftId=", iGiftId)
			--print("	iGiftMoney=", iGiftMoney)
			--print("	szGiftInfo=", szGiftInfo)
			--print("	szGiftPrize=", szGiftPrize)
		else
			hUI.NetDisable(0)
			
			--[[
			if iErrCode == 103 then
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext("please try it later！", hVar.FONTC, 32, "MC", 0, 0,nil,1)
			end
			]]
			xlLuaEvent_Topup_Failed(1)
			--触发事件：1元档充值返回（安卓）
			hGlobal.event:event("localEvent_LimitTimeGiftOrderRet", iErrCode)
		end
		
		--print("40111 安卓，1元档充值返回")
		
		--触发事件：1元档充值返回（安卓）
		--hGlobal.event:event("localEvent_LimitTimeGiftOrderRet", iErrCode, iIapType, iUid, iRid, iItemId, sOrderId, sOrderData, sPrice)
	elseif (id == 40113) then --ios，礼包充值确认返回
		local protocol = packet:readInt()
		local iErrCode = packet:readInt()
		local iIapType = packet:readInt()
		local sProductId = packet:readString()
		
		if (iErrCode == 0) then
			local tIapList = xlLuaEvent_GetIapList()
			if (type(tIapList) == "table") and (#tIapList > 0) then
				for i = 1,#tIapList do
					if sProductId == tIapList[i].productId then
						--挡操作
						hUI.NetDisable(5000, "purchase")
						
						local id = tIapList[i].custombuyindex - 1
						xlIapBuyItem(iIapType, id)
						
						--触发事件：1元档充值返回（苹果）
						--hGlobal.event:event("localEvent_LimitTimeGiftOrderRet", iErrCode, iIapType, iUid, iRid, iItemId, sOrderId, sOrderData, sPrice)
						
						return
					end
				end
				
				--没找到商品 "not find gift"
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(hVar.tab_string["ios_pruchase_connect_ios"], hVar.FONTC, 32, "MC", 0, 0,nil,1) --"内购条目准备中"
			else
				local iChannelId = getChannelInfo()
				if (iChannelId < 100) then
					--geyachao: 应王总要求，ios没收到内购条目，发起本地假的充值
					--挡操作
					hUI.NetDisable(5000, "purchase")
					
					--直接按key买商品
					xlIapBuyIosItem(sProductId)
				else
					--没找到商品 "not find gift"
					hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "",
						lifetime = 1000,
						fadeout = -550,
						moveY = 32,
					}):addtext(hVar.tab_string["ios_pruchase_connect_ios"], hVar.FONTC, 32, "MC", 0, 0,nil,1) --"内购条目准备中"
				end
			end
		else
			--
		end
		hUI.NetDisable(0)
		
		--触发事件：1元档充值返回（苹果）
		--hGlobal.event:event("localEvent_LimitTimeGiftOrderRet", iErrCode, iIapType, iUid, iRid, iItemId, sOrderId, sOrderData, sPrice)
	elseif(id == 40114) then	--ios 充值结束回调
		local protocol = packet:readInt()
		local iIndex = packet:readInt()
		--local strText = "40114 protocol:" .. tostring(protocol).." iIndex:" .. tostring(iIndex).." xlIapFinishReceipt:"..tostring(type(xlIapFinishReceipt))
		--hGlobal.UI.MsgBox(strText, {
			--font = hVar.FONTC,
			--ok = function()
				----self:setstate(1)
			--end,
		--})
		if "function" == type(xlIapFinishReceipt) then
			xlIapFinishReceipt(iIndex)
		end
		
		--print("40114 ios 充值结束回调")
		
		--触发事件：1元档充值返回（苹果）
		local iErrCode = 0
		hGlobal.event:event("localEvent_LimitTimeGiftOrderRet", iErrCode)
	elseif id == 44444 then -- 心跳包
		--用于掉线框判断是否需要重连
		--hGlobal.event:event("localEvent_GetHeartPacket")
	elseif id == 44445 then
		local protocol = packet:readInt()
		local uid = packet:readInt()
		local iTag = packet:readInt()
		
		--print("44445", "uid="..tostring(uid), "iTag="..tostring(iTag))
		
		if (iTag ~= 0) then
			hApi.clearTimer("__Android_HEART_BEAT")
			--print("44444 clearTimer __Android_HEART_BEAT")
			
			--geyachao: 检测是否需要游戏内重连
			if (g_cur_net_state == 1) then --连接状态
				if (g_cur_login_state ~= 1) then --不是登陆状态
					if (g_isReconnection == 1) then --重连状态
						local t_type,uid,pass,itag,reconnection = unpack(g_lastPtable)
						--print(g_lastPid,t_type,uid,pass,itag,reconnection)
						GluaSendNetCmd[hVar.ONLINECMD.NEW_RE_LOGIN](t_type,uid,pass,itag,g_isReconnection) --游戏内重连
					end
				end
			end
			
			--隐藏安卓重连的框
			--hGlobal.event:event("LocalEvent_showAndroidNetAlreadyFrm", 0)
		end
	--接收抢夺奖励次数
	elseif id == 34203 then
		--删除作弊日志
		print("34203")
		LuaDelCheatLog()
	else
		--print("unknown network message id:"..id)
		xlAppAnalysis("log_unknown_message",0,1,"info-","uID:"..tostring(xlPlayer_GetUID()).."-content:"..tostring(id).."-playerName:"..tostring(g_curPlayerName).."-T:"..tostring(os.date("%m%d%H%M%S")))
	end
end

--如果开启了活动服务，这里可以直接收到
local __AnalyzeActivitiesFromServer = function(id,tickLeft,content)
	if id==100 then
		-- 100:青铜箱子中的装备掉率
		local cTab = hApi.ReadNumberFromString(content)
		if cTab and #cTab>=3 then
			hVar.tab_drop.init("copper_box",cTab)
		end
	elseif id==101 then
		-- 101:白银箱子中的装备掉率
		local cTab = hApi.ReadNumberFromString(content)
		if cTab and #cTab>=3 then
			hVar.tab_drop.init("silver_box",cTab)
		end
	elseif id==102 then
		-- 102:黄金箱子中的装备掉率
		local cTab = hApi.ReadNumberFromString(content)
		if cTab and #cTab>=3 then
			hVar.tab_drop.init("gold_box",cTab)
		end
	end
end

--全局用来显示充值道具的ID
g_TopupGiftItemList = {}
for i = 1,#hVar.GiftItem do
	g_TopupGiftItemList[i] = {hVar.GiftItem[i][1],hVar.GiftItem[i][2],hVar.GiftItem[i][3],hVar.GiftItem[i][4]}
end

--每日领取游戏币 扣除的积分 默认值200
g_DailyRewardScore = 500
g_DailyRewardCoin = nil
local __UpdateTopupGiftItem = function(id,tickLeft,content)
--print("__UpdateTopupGiftItem:", id, content)
	local itemID = 0
	local itemNum = 1
	local score = 0
	local sType = "i"
	if id == 1030 or id == 1031 or  id == 1032 or id == 1033 or id == 1034 or id == 1035 then
		--如果是新的格式
		if string.find(content,"i:") ~= nil and string.find(content,"s:") then
			local tempState = {}
			for content in string.gfind(content,"([^%;]+);+") do
				tempState[#tempState+1] = content
			end
			itemID = tonumber(string.sub(tempState[1],string.find(content,"i:")+2,string.len(tempState[1])))
			score = tonumber(string.sub(tempState[2],string.find(content,"s:")+2,string.len(tempState[2])))
		
		--老格式
		elseif string.find(content,"i:") ~= nil then
			itemID = tonumber(string.sub(content,string.find(content,"i:")+2,string.find(content,"n:")-1))
			--itemNum = tonumber(string.sub(content,string.find(content,"n:")+2,string.len(content)))
		--英雄令的奖励
		elseif string.find(content,"H:") then
				local tempState = {}
				for content in string.gfind(content,"([^%;]+);+") do
					tempState[#tempState+1] = content
				end
				itemID = tonumber(string.sub(tempState[1],string.find(tempState[1],"H:")+2,string.len(tempState[1])))
				sType = "H"
		end
	elseif id == 1036 then
		local tContent = hApi.Split(content, ";")
		local reward = tContent[1] or ""
		local tReward = hApi.Split(reward, ":")
		itemID = tonumber(tReward[2]) or 0
	end
	
	--首充奖励6
	if id == 1030 then
		g_TopupGiftItemList[1] = {itemID,itemNum,score,sType}
	--18
	elseif id == 1031 then
		g_TopupGiftItemList[2] = {itemID,itemNum,score,sType}
	--45
	--elseif id == 1032 then
	--	g_TopupGiftItemList[3] = {itemID,itemNum,score,sType}
	--68
	elseif id == 1033 then
		g_TopupGiftItemList[3] = {itemID,itemNum,score,sType}
	--98
	elseif id == 1034 then
		g_TopupGiftItemList[4] = {itemID,itemNum,score,sType}
	--198 
	elseif id == 1035 then
		g_TopupGiftItemList[5] = {itemID,itemNum,score,sType}
	--388
	elseif id == 1036 then
		g_TopupGiftItemList[6] = {itemID,itemNum,score,sType}
	end
end

--每周的 将星表
g_HeroWeekStar = {}
--活动相关接口
xlLuaEvent_online_shop_activity_refresh = function(nActivityCount)
	print("xlLuaEvent_online_shop_activity_refresh")
	local activity_list = {}
	
	for i = 0, nActivityCount-1 do
		
		local id, leftTimsInSec, content = xlGetShopActivityByIndex(i)
		__AnalyzeActivitiesFromServer(id, leftTimsInSec, content)
		--白银宝箱活动
		if id == 200 then
			
		elseif id == 201 then
			
		elseif id == 1310 then
			--刷新礼品按钮
			local state = -1
			if tonumber(content) == 0 then
				state = -1
			elseif tonumber(content) == 1 then
				state = 1
			end
			
			hGlobal.event:event("LocalEvent_Setbtn_compensate",state)
		elseif id == 304 then
			--设置积分和游戏币 lab
			if string.find(content,"c:") and string.find(content,"s:") then
				local rmb = string.sub(content,string.find(content,"c:")+2,string.find(content,"s:")-2)
				local score = 0
				score  = _ncf["Tool_string2socre"](content)
				activity_list[#activity_list+1] = {id = id,index = 3,itemID = 9005,score =tonumber(score),rmb = tonumber(rmb)}
			end
		elseif id == 305 then
			--设置积分和游戏 lab
			if string.find(content,"c:") and string.find(content,"s:") then
				local rmb = string.sub(content,string.find(content,"c:")+2,string.find(content,"s:")-2)
				local score = 0
				score  =_ncf["Tool_string2socre"](content)
				activity_list[#activity_list+1] = {id = id,index = 5,itemID = 9006,score =tonumber(score),rmb = tonumber(rmb)}
			end

		elseif id == 306 then
			--设置炎晶 游戏币
			if string.find(content,"c:") and string.find(content,"s:") then
				local rmb = string.sub(content,string.find(content,"c:")+2,string.find(content,"s:")-2)
				local score = 0
				score  =_ncf["Tool_string2socre"](content)
				activity_list[#activity_list+1] = {id = id,index = 6,itemID = 9009,score =tonumber(score),rmb = tonumber(rmb)}
			end
		elseif id == 307 then
			if string.find(content,"c:") and string.find(content,"s:") then
				local rmb = string.sub(content,string.find(content,"c:")+2,string.find(content,"s:")-2)
				local score = 0
				score  =_ncf["Tool_string2socre"](content)
				activity_list[#activity_list+1] = {id = id,index = 7,itemID = 9101,score =tonumber(score),rmb = tonumber(rmb)}
			end
		elseif id == 308 then
			if string.find(content,"c:") and string.find(content,"s:") then
				local rmb = string.sub(content,string.find(content,"c:")+2,string.find(content,"s:")-2)
				local score = 0
				score  =_ncf["Tool_string2socre"](content)
				activity_list[#activity_list+1] = {id = id,index = 9,itemID = 9102,score =tonumber(score),rmb = tonumber(rmb)}
			end

		elseif id == 303 then
			--商店左上角的显示
			if type(content) == "string" then
				local tempStr = {}
				for content in string.gfind(content,"([^%;]+);+") do
					tempStr[#tempStr+1] = content
				end
				local ShopItemID,ShopItemState,ShopItemPrice = 0,0,0
				for i = 1,#tempStr do
					if string.find(tempStr[i],"i:") and string.find(tempStr[i],"t:") and string.find(tempStr[i],"p:") then
						ShopItemID = string.sub(tempStr[i],string.find(tempStr[i],"i:")+2,string.find(tempStr[i],"t")-1)
						ShopItemState = string.sub(tempStr[i],string.find(tempStr[i],"t:")+2,string.find(tempStr[i],"t:")+2)
						ShopItemPrice = string.sub(tempStr[i],string.find(tempStr[i],"p:")+2,string.len(tempStr[i]))

						activity_list[#activity_list+1] = {id = 303,ShopItemID = tonumber(ShopItemID),ShopItemState = tonumber(ShopItemState),ShopItemPrice = tonumber(ShopItemPrice)}
					end
				end
			else
				print("303","erro")
			end
		elseif (id == 1800) then --显示充值功能的开关
			--刷新礼品按钮
			local state = -1
			if tonumber(content) == 0 then
				state = -1
			elseif tonumber(content) == 1 then
				state = 1
			end
			
			--geyachao: 服务器控制是否开放充值功能
			hVar.SHOW_PURCHASE_HOST = state
		end
		
		--刷新 首充奖励界面的奖品信息
		__UpdateTopupGiftItem(id, leftTimsInSec, content)
		--刷新 每日奖励 扣除的积分信息
		if id == 9 then
			if string.find(content,"s:") ~= nil then
				local score = _ncf["Tool_string2socre"](content)
				g_DailyRewardScore = math.abs(tonumber(score))
			end
			if string.find(content,"c:") ~= nil then
				local coin = string.sub(content,string.find(content,"c:")+2,string.find(content,"s:")-2)
				g_DailyRewardCoin = math.abs(tonumber(coin))
			end
		end

		if id == 5000 then
			if string.find(content,"s:") ~= nil then
				local score = _ncf["Tool_string2socre"](content)
				g_DailyRewardScore_m = math.abs(tonumber(score))
			end
			if string.find(content,"c:") ~= nil then
				local coin = string.sub(content,string.find(content,"c:")+2,string.find(content,"s:")-2)
				g_DailyRewardCoin_m = math.abs(tonumber(coin))
			end
		end
		
		--每周将星数据
		if id == 1500 then
			g_HeroWeekStar = {}
			--解析将星字段， id == 英雄ID，
			local heroID = 0
			local odds = 0
			if string.find(content,"id:") ~= nil then
				heroID = tonumber(string.sub(content,string.find(content,"id:")+3,string.find(content,";")-1))
				odds = tonumber(string.sub(content,string.find(content,"ps:")+3,string.len(content)))
				g_HeroWeekStar[#g_HeroWeekStar+1] = {heroID,odds}
			end
			hGlobal.event:event("LocalEvent_showweekstarherofrm",g_HeroWeekStar)
		end
	end
	print("g_DailyRewardScore",g_DailyRewardScore)
	print("g_DailyRewardCoin",g_DailyRewardCoin)
	print("g_DailyRewardScore_m",g_DailyRewardScore_m)
	print("g_DailyRewardCoin_m",g_DailyRewardCoin_m)

	hGlobal.event:event("LocalEvent_Set_activity_list",activity_list)
end

--程序调用的设置积分的接口
xlLuaEvent_withdrawGift = function(ptype, num)
	if ptype == 1 then
		if type(tonumber(num)) == "number" then
			LuaAddPlayerScore(tonumber(num))
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
		
		if g_phone_mode ~= 0 then
			hGlobal.event:event("LocalEvent_Phone_SetCurGameCoin_Game")
		else
			hGlobal.event:event("LocalEvent_SetCurGameCoin")
		end
	elseif ptype == 0 then

	elseif ptype == 199 then
		--xlAppAnalysis("log_account_test",0,1,"info-","199uID:"..tostring(xlPlayer_GetUID()).."-Name:"..tostring(g_curPlayerName).."-is_test:"..tostring(1).."-T:"..tostring(os.date("%m%d%H%M%S")))
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_account_test", 1)
		CCUserDefault:sharedUserDefault():flush()
	elseif ptype == 200 then
		--xlAppAnalysis("log_account_test",0,1,"info-","200uID:"..tostring(xlPlayer_GetUID()).."-Name:"..tostring(g_curPlayerName).."-is_test:"..tostring(0).."-T:"..tostring(os.date("%m%d%H%M%S")))
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_account_test", 0)
		CCUserDefault:sharedUserDefault():flush()
	elseif ptype == 4 then
		--一般的道具补偿
		
		--老格式的道具补偿
		if string.find(num,";") == nil then
			if string.find(num,"i:") ~= nil then
				local itemID = 0
				local itemNum = 1
				itemID = tonumber(string.sub(num,string.find(num,"i:")+2,string.find(num,"n:")-1))
				itemNum = tonumber(string.sub(num,string.find(num,"n:")+2,string.len(num)))
				hGlobal.event:event("LocalEvent_GetTopupGiftItem",{itemID},{itemNum},1)
			end
		elseif string.find(num,";") ~= nil then
		--新格式的道具补偿 都用 ; 隔开了
			local tempStr = {}
			for content in string.gfind(num,"([^%;]+);+") do
				tempStr[#tempStr+1] = content
			end
			
			local itemID = tonumber(string.sub(tempStr[1],3,string.len(tempStr[1])))
			local itemNum = tonumber(string.sub(tempStr[2],3,string.len(tempStr[2])))
			local itemHole = tonumber(string.sub(tempStr[3],3,string.len(tempStr[3])))
			
			hGlobal.event:event("LocalEvent_GetTopupGiftItem",{itemID},{itemNum},1,nil,nil,nil,{itemHole})
		end
	--获取其他玩家存档的功能
	elseif ptype == 6 then
		--local uID = 0
		--local dataName = ""
		--if string.find(num,"uid:") ~= nil then
			--uID = tonumber(string.sub(num,string.find(num,"uid:")+4,string.len(num)))
			--_ncf["get_savefile"](uID,dataName)
		--end
	elseif ptype == 7 then
		--战术技能卡补偿
		if string.find(num,"bfs:") ~= nil then
			local cardid = tonumber(string.sub(num,string.find(num,"bfs:")+4,string.find(num,"lv:")-1))
			local cardlv = tonumber(string.sub(num,string.find(num,"lv:")+3,string.len(num)))
			
			
			hGlobal.event:event("localEvent_ShowBattlefieldSkillFrm",{{cardid,cardlv}},nil,nil,1)
			
		end
	elseif ptype == 8 then
		--英雄令的补偿
		if string.find(num,"ID:") ~= nil then
			local heroID = tonumber(string.sub(num,string.find(num,"ID:")+3,string.find(num,";")-1))
			if type(heroID) == "number" then
				hGlobal.event:event("LocalEvent_BuyHeroCardSucceed",heroID, 1, 1)
			end
		end
	else
		--有积分相关的内容
		local score = _ncf["Tool_string2socre"](num)
		if score > 0 then
			LuaAddPlayerScore(score)
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			
			if g_phone_mode ~= 0 then
				hGlobal.event:event("LocalEvent_Phone_SetCurGameCoin_Game")
			else
				hGlobal.event:event("LocalEvent_SetCurGameCoin")
			end
		end
		
	end
	
	if g_vs_number > 4 then
		_ncf["gamecoin"]()
	end
end

local _topuptype = {}
_topuptype[1] = "Apple"
_topuptype[2] = "Alipay"

local _topupindex = {}
_topupindex[1] = 60
_topupindex[2] = 200
_topupindex[3] = 350
_topupindex[4] = 800
_topupindex[5] = 1200
_topupindex[6] = 2500

--充值成功后
xlLuaEvent_Topup_Success = function(TopupType, TopupIndex)
	local payType = _topuptype[TopupType] --支付类型
	local getRmb = _topupindex[TopupIndex+1] --获得的游戏币
	
	local p = CCWritePacket:create()
	p:writeUInt(30337)
	p:writeUInt(xlPlayer_GetUID())
	p:writeInt(0) --tag
	p:writeString("user_event")
	p:writeString("event_id:100;event_name:" .. tostring(payType) .. "-" .. tostring(getRmb)) 
	xlNet_SendPacket(p)
	
	--日志
	_ncf["get_VIP_Lv"]()
	xlAppAnalysis("topup_ok", 0, 1, "info", tostring(xlPlayer_GetUID()) .. "-" .. tostring(payType) .. "-" .. tostring(getRmb) .. "-T:" .. tostring(os.date("%m%d%H%M%S")))
	
	----弹框
	--hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Topup_Success_Tip2"], {
		--font = hVar.FONTC,
		--ok = function()
		--end,
	--})
	
	--触发事件: 充值成功事件回调
	hGlobal.event:event("LocalEvent_Purchase_Back", 1)
end

--充值失败后
xlLuaEvent_Topup_Failed = function()
	--[[
	--弹框
	hGlobal.UI.MsgBox(hVar.tab_string["xlLuaEvent_Topup_Failed 充值失败"], {
		font = hVar.FONTC,
		ok = function()
		end,
	})
	]]
	
	--充值失败有可能程序在后台，延时一会再触发事件
	hApi.addTimerOnce("__Timer_xlLuaEvent_Topup_Failed_", 1000, function()
		--触发事件: 充值失败事件回调
		hGlobal.event:event("LocalEvent_Purchase_Back", 0)
	end)
end

--礼包接口
Gift_Function = {}
--每日礼包 5游戏币 同时 回扣除 500积分
Gift_Function["reward_1"] = function()
	_ncf["receive_gift"](9)
	--友盟统计,每日统计,统计当前情况
	if xlAppAnalysis then
		local mapNow = "N/A"
		if hVar.tab_chapter and hVar.tab_chapter[1] and hVar.tab_chapter[1].firstmap then
			local nextMap = hVar.tab_chapter[1].firstmap
			while(1) do
				if mapNow == nextMap then
					break
				end

				local tabM = hVar.MAP_INFO[nextMap]
				if not tabM then
					break
				end

				local isFinish = LuaGetPlayerMapAchi(nextMap,hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
				if isFinish  == 0 then
					break
				end

				mapNow = nextMap
				
				if hVar.MAP_INFO[nextMap].nextmap and type(hVar.MAP_INFO[nextMap].nextmap) == "table" and hVar.MAP_INFO[nextMap].nextmap[1] then
					nextMap = hVar.MAP_INFO[nextMap].nextmap[1]
				end
			end
		end
		local tmp = hApi.Split(mapNow, "/")
		xlAppAnalysis("dailyStatistics",0,2,"mapProgress", tmp[#tmp], "star", LuaGetPlayerCountVal(hVar.MEDAL_TYPE.starCount))
	end
end
--首次登陆奖励 50个游戏币
Gift_Function["reward_2"] = function()
	_ncf["receive_gift"](100)
end
--评论奖励
Gift_Function["reward_3"] = function()
	--Appstore评价链接
	--local commentUrl = "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1104158404&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8" --策马守天关app评论地址
	--if (hVar.SYS_IS_NEWTD_APP == 1) then --新塔防app程序
		--commentUrl = "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1262272804&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8" --魔塔前线app评论地址
	--end
	
	--_ncf["receive_gift"](18)
	--if 4 == LANGUAG_SITTING then -- 英文
		----xlOpenUrl("itms-apps://itunes.apple.com/cn/app/ce-ma-san-guo-zhi/id680495664?l=en&mt=8")
		----xlOpenUrl("https://itunes.apple.com/cn/app/ce-ma-shou-tian-guan-ta-fang/id1104158404?mt=8")
		--xlOpenUrl(commentUrl)
		
	--else
		----xlOpenUrl("itms-apps://itunes.apple.com/cn/app/ce-ma-san-guo-zhi/id680495664?l=cn&mt=8")
		----xlOpenUrl("https://itunes.apple.com/cn/app/ce-ma-shou-tian-guan-ta-fang/id1104158404?mt=8")
		--xlOpenUrl(commentUrl)
	--end
	--老的直接切换到评论页面的方式
	--xlOpenUrl("itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=680495664")
	--战车评价
	--local commentUrl = "https://www.taptap.com/app/177577"
	commentUrl = "https://www.taptap.cn/app/177559/review"
	
	local iChannelId = xlGetChannelId()
	if iChannelId < 100 then
		commentUrl = "itms-apps://itunes.apple.com/cn/app/id6443552084?mt=8&action=write-review"
		
		local sysVersion = xlGetSystemVersion()
		local temp_V = getMainVersion(sysVersion)
		if (temp_V < 11) then
			commentUrl = "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=6443552084&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8" --(iso10)
		end
	end
	xlOpenUrl(commentUrl)
	if LuaGetPlayerGiftstate(3) == 0 then
		--_ncf["receive_gift"](18)
		--请求领取评价奖励（新）
		SendCmdFunc["comment_takereward"]()
	end
end

function getMainVersion(sVersion)
	local temp = "0"
	for i = 1,4 do
		local v = string.sub(sVersion,i,i)
		if "0" <= v and v <= "9" then
			temp = temp .. v
		else
		return tonumber(temp)
		end
	end
end

local sendDeviceInfo = function(iMsgId)
	local isSystemBroken = xlIsSystemBroken()
	local isAppBroken = xlIsAppBroken()
	local iMemSize = xlGetMemoryInfo()
	
	local deviceName = xlGetDeviceName()
	local sysName 	 = xlGetSystemName()
	local modelName  = xlGetModelName()
	local bundleId 	 = xlGetBundleID()
	
	local sysVersion = xlGetSystemVersion()
	local temp_V = getMainVersion(sysVersion)
	local system_lang = "nil"
	if xlSystemLanguage then
		system_lang = xlSystemLanguage()
		
	end

	local macAddr, openUDID, IFV, IFA

	 if 10 <= temp_V then
		IFV = xlGetIdentifierForVendor()
		IFA = xlGetAdvertisingIdentifier()
	elseif temp_V < 6 then
		macAddr = xlGetMacAddress()
		openUDID = xlGetOpenUDID()
	elseif temp_V < 7 then
		openUDID = xlGetOpenUDID()
		IFV = xlGetIdentifierForVendor()
		IFA = xlGetAdvertisingIdentifier()
	else
		IFV = xlGetIdentifierForVendor()
		IFA = xlGetAdvertisingIdentifier()
	end
	
	local p = CCWritePacket:create()
	p:writeUInt(iMsgId)
	p:writeByte(isSystemBroken)
	p:writeByte(isAppBroken)
	p:writeInt(iMemSize)
	
	p:writeString(deviceName or "")
	p:writeString(sysName or "")
	p:writeString(modelName or "")
	p:writeString(bundleId or "")
	
	p:writeString(macAddr or "")
	p:writeString(openUDID or "")
	p:writeString(IFV or "")
	p:writeString(IFA or "")
	p:writeString(sysVersion or "")
	p:writeString(system_lang)
	xlNet_SendPacket(p)
end

xlLuaEvent_sendDeviceInfo = function()
	--local uid = xlPlayer_GetUID()
	--if uid == 0 then
	--	return
	--end
	
	--sendDeviceInfo(30009)
end

xlLuaEvent_onUIDCreated = function()
	--sendDeviceInfo(30008)
end

xlLuaEvent_RealName_CheckId = function(err)
	hUI.NetDisable(0)
	hGlobal.event:event("LocalEvent_RealNameCheckId_cb",err)
	local text = hVar.tab_string["realnamecheck_err"..err]
	if err == 0 then
		--从身份证信息获取出年月日 截取出生年月日 发给服务器绑定
		local sbirthday = ""
		if string.len(g_ReviewInfo.idcard) == 18 then
			sbirthday = string.sub(g_ReviewInfo.idcard,7,14)
		end

		hUI.NetDisable(10000)
		print("hVar.ONLINECMD.BIND_REALNAMEINFO",g_ReviewInfo.idcard,g_ReviewInfo.name,sbirthday)
		GluaSendNetCmd[hVar.ONLINECMD.BIND_REALNAMEINFO](tonumber(sbirthday),g_ReviewInfo.idcard,g_ReviewInfo.name)
		if hVar.RealNameMode == 1 then
			GluaNetCmd[hVar.ONLINECMD.BIND_REALNAMEINFO_RES](0,0,g_ReviewTestInfo.bindtotalday)
		end
	elseif err == 1 or err == 2 or err == 3 or err == 20010 or 20310 then
		--弹漂浮文字
	else
		--其余的直接弹框 显示错误码
		hGlobal.UI.MsgBox(hVar.tab_string["errcode"]..":"..err,{
			font = hVar.FONTC,
			ok = function()
				
			end,
		})
		return
	end
	hUI.floatNumber:new({
		x = hVar.SCREEN.w / 2,
		y = hVar.SCREEN.h / 2,
		align = "MC",
		text = "",
		lifetime = 2500,
		fadeout = -550,
		--moveY = 32,
	}):addtext(text, hVar.FONTC, 40, "MC", 0, 0,nil,1)
end

Lua_DoLogin = function()
    --00 protocol
    local iProtocol = 0
    --01 uid
    local iUid = xlPlayer_GetUID() or 0
    --02 uuid
    local sUuid = xlPlayer_GetDeviceId() or ""

    --03 gamebranch
    local iGameBranch = 0
    --04 channelid
    local iChannelId = getChannelInfo()

    --05 systembroken
    local iSystemBroken = xlIsSystemBroken()
    --06 appbroken
    local iAppBroken = xlIsAppBroken()
    
    --07 devicename
    local sDeviceName = xlGetDeviceName() or ""
    --08 bundleid
    local sBundleId = xlGetBundleID() or ""
    --09 mode
    local sModel  = xlGetModelName() or ""
    --10 systemname
    local sSystemName 	 = xlGetSystemName() or ""
    --11 systemversion
    local sSystemVersion = xlGetSystemVersion() or ""
    --12 memsize
    local iMemSize = xlGetMemoryInfo()
    
    --13 mac
    local sMac = ""--xlGetMacAddress() or ""
    --14 openudid
    local sOpenUdid = ""--xlGetOpenUDID() or ""
    --15 idfv
    local sIdfv = xlGetIdentifierForVendor() or ""
    --16 idfa
    local sIdfa = xlGetAdvertisingIdentifier() or ""

    --17 systemlanguage
    local sSystemLanguage = xlSystemLanguage() or "nil"
    --18 scriptversion
    local sScriptVersion = string.format("%s-%s",tostring(hVar.CURRENT_ITEM_VERSION),tostring(xlGetExeVersion()))

    --prepare for sending
    local p = CCWritePacket:create()
    p:writeInt(4102)

    p:writeInt(iProtocol)
    p:writeInt(iUid)
    p:writeString(sUuid)

    p:writeInt(iGameBranch)
    p:writeInt(iChannelId)

    p:writeInt(iSystemBroken)
    p:writeInt(iAppBroken)

    p:writeString(sDeviceName)
    p:writeString(sBundleId)
    p:writeString(sModel)
    p:writeString(sSystemName)
    p:writeString(sSystemVersion)
    p:writeInt(iMemSize)

    p:writeString(sMac)
    p:writeString(sOpenUdid)
    p:writeString(sIdfv)
    p:writeString(sIdfa)

    p:writeString(sSystemLanguage)
    p:writeString(sScriptVersion)

    xlNet_SendPacket(p)

    --print("bcd:"..bcd)
end

ShowMsgBoxOldVersion = function(sInfo)
	local tipFrm = hUI.frame:new({
		x = hVar.SCREEN.w/2 - 250,
		y = hVar.SCREEN.h/2 + 160,
		dragable = 2,
		w = 500,
		h = 320,
		titlebar = 0,
		show = 0,
		bgAlpha = 0,
		bgMode = "tile",
		border = 1,
		autoactive = 0,
		z = 1000000, --临时增加，避免被设置窗口遮挡 2022-12-27 测试分享功能
	})
	
	--提示文字title
	tipFrm.childUI["tipLab"] =  hUI.label:new({
		parent = tipFrm.handle._n,
		x = 30,
		y = -50,
		text = sInfo,
		size = 32,
		width = tipFrm.data.w-55,
		font = hVar.FONTC,
		align = "LT",
		border = 1,
	})
	
	--确定按钮
	tipFrm.childUI["confirmBtn"] =  hUI.button:new({
		parent = tipFrm.handle._n,
		dragbox = tipFrm.childUI["dragBox"],
		model = "UI:ButtonBack2",
		font = hVar.FONTC,
		label = hVar.tab_string["__TEXT_Confirm"],
		border = 1,
		x = tipFrm.data.w/2,
		y = -tipFrm.data.h + 40,
		code = function()
			--xlExit()
			tipFrm:del()
		end,
	})
	
	tipFrm:active()
	tipFrm:show(1)
end
NetCallBack_Login = function(packet)
	local iChannelId = xlGetChannelId()
	--if iChannelId >= 100 then
		--return
	--end
	if true then
		return
	end
	local iProtocol = packet:readInt()
	local iErrorCode = packet:readInt()
	local iType = packet:readInt()
	local iUid = packet:readInt()
	local iGm = packet:readInt()
	local sDevice = packet:readString()
	local iTestor = packet:readInt()
	local sVersionServer = packet:readString()
	print(string.format("onlogin %d,%d,%d,%d,%d,%s,%s,%s",iProtocol,iErrorCode,iType,iUid,iGm,tostring(sDevice),tostring(iTestor),tostring(sVersionServer)))
	if 0 == iErrorCode then
		
		if 0 == iType then 
			xlPlayer_SetUID(iUid)
			xlPlayer_SetDeviceId(sDevice)
		end
		
		--刷新活动相关数据
		xlRequestShopActivityList()
		
		local playerDataID = luaGetplayerDataID()
		SendCmdFunc["get_cheatflag"]()
		
		--发送获取游戏币信令
		SendCmdFunc["gamecoin"]()
		--发送获取游戏能量命令 zhenkira
		--SendCmdFunc["ENMSG_SCRIPT_ID_CHA_GET"]("energy",0)
		--获取VIP等级
		--SendCmdFunc["get_VIP_Lv"]()
		SendCmdFunc["get_VIP_Lv_New"]()
		--获取符石数据
		SendCmdFunc["Fstone"]()
		
		local channel_id,flag = getChannelInfo()
		SendCmdFunc["channel_info"](channel_id,flag)
		
		local verPc =xlGetExeVersion()
		local verLua = hVar.CURRENT_ITEM_VERSION
		--发送当前版信息相关
		SendCmdFunc["send_cur_version"](tostring(verLua).."-"..tostring(verPc))
		SendCmdFunc["get_Account_Test"]()
		SendCmdFunc["get_PayType"]()
		--SendCmdFunc["get_VIP_REC_State"](LuaGetPlayerVipLv())
		SendCmdFunc["send_cur_device_type"](hApi.GetCurDevTypeEx())
		
		--获取服务器版本控制信息
		SendCmdFunc["get_version_control"]()
		
		--更新常用的角色id
		SendCmdFunc["send_useingRoldID"]()
		
		--连上网络时 发起检测公告和版本是否 有更新的 协议 
		SendCmdFunc["get_NweVer"]()
		SendCmdFunc["get_NewWebView"]()
		
		--连上网络时发送一次 发送状态为 0 的玩家行为ID
		local playerBehavior = LuaGetBehaviorList()
		if type(playerBehavior) == "table" then
			for i = 1,#playerBehavior do
				local v = playerBehavior[i]
				if v[2] == 0 then
					SendCmdFunc["send_UserBehavior"](v[1])
				end
			end
		end

		--连上网络时检查是否有未传的作弊log
		if iGm == 1 then
			LuaDelCheatLog()
		else
			LuaCheckCheatLog()
		end
		
		--发送通关信息
		SendCmdFunc["send_checkpoint"](playerDataID,Save_PlayerLog)
		--检测是否发送过锻造校验值状态
		--SendCmdFunc["get_cheat_val"](playerDataID,0,"cheat_fcstatus")
		
		--DLC检测
		LuaCheckDLCFunc()
		
		--发起查询服务器系统时间
		SendCmdFunc["refresh_systime"]()
		
		--获取活动
		local langIdx = g_Cur_Language - 1
		SendCmdFunc["get_ActivityList"](langIdx)
		
		--获取邮件（放在最后，因为如果有活动，优先查询活动）
		--SendCmdFunc["get_prize_list"]()
		
		--获取玩家神器信息
		SendCmdFunc["sync_redequip"]()
		
		--连接pvp服务器
		if (Pvp_Server:GetState() ~= 1) then --未连接
			Pvp_Server:Connect()
		elseif (not hGlobal.LocalPlayer:getonline()) then --不重复登陆
			Pvp_Server:UserLogin()
		end
		
		--查询是否有可用的角色ID
		if Save_playerList then
			for i = 1,hVar.OPTIONS.MAX_PLAYER_NUM do
				local playerInfo = Save_playerList[i]
				if playerInfo and type(playerInfo.roleID) == "number" and  playerInfo.roleID > 0 then
					LuaResetSaveBackInfo()
					return
				end
			end
			SendCmdFunc["check_cha_rid"]()
		end
    elseif iErrorCode == 30 then
	--防止未收到协议 没清理
	LuaDelCheatLog()
	--作弊标志保存到本地
	xlSaveIntToKeyChain("cheatflag",1)
    elseif iErrorCode <= 40 then
        local sInfo = string.format(hVar.tab_string["script_login_error_40"],iUid,iErrorCode)
        hGlobal.UI.MsgBox(sInfo,{font = hVar.FONTC,ok = function()xlExit()end,})
    elseif 98 == iErrorCode then
        local sInfo = string.format(hVar.tab_string["uid_old_version"],sVersionServer,tostring(hVar.CURRENT_ITEM_VERSION))
        ShowMsgBoxOldVersion(sInfo)
        --hGlobal.UI.MsgBox(sInfo,{font = hVar.FONTC,ok = function()xlExit()end,})
    elseif 100 == iErrorCode then
       -- hGlobal.UI.MsgBox(hVar.tab_string["uid_uuid_wrong"]..iUid..hVar.tab_string["uid_uuid_wrong1"],{font = hVar.FONTC,ok = function()xlExit()end,})
		local bundleId = xlGetBundleID()
		--print(bundleId)
		if (bundleId == "alien.xingames.com") then
			--没有uid
			if Save_playerList then
				Save_playerList.LastSwitchPlayer = 1
			end
			
			local curPlayer = g_curPlayerName
			
			xlAppAnalysis("delete_savefile",0,1,"info","uID:"..tostring(xlPlayer_GetUID()).."-name:"..tostring(curPlayer).."-localuID:"..tostring(luaGetplayerUniqueID()).."-T:"..os.date("%m%d%H%M%S"))
			--清除掉全部的成就信息
			LuaDeletePlayerAutoSave(curPlayer)
			LuaClearLootFromUnit(curPlayer)
			LuaClearSelectConfig(curPlayer) --清空本地选人配置
			LuaClearSystemMailTitle(curPlayer) --清空玩家最近一次已阅读的系统邮件的标题
			LuaClearActivityAidList(curPlayer)--清空玩家已查看的活动aid列表
			LuaClearPVPUserInfo(curPlayer) --清空pvp玩家本局对战的对手信息
			LuaClearPVPIsShowGuide(curPlayer)--清空玩家pvp是否显示引导
			LuaClearPlayerBillBoard(curPlayer) --清空玩家今日本地排行榜的数据
			LuaClearTodayShopItemLimitCount(curPlayer) --清空玩家锁孔洗炼购买次数数据
			LuaClearTodayNetShopGoods(curPlayer) --清空玩家的今日商城商品列表
			LuaSetPlayerListMapUniqueID(curPlayer, 0)
			LuaClearGuiderecodeList(curPlayer)
			LuaClearRidByName(curPlayer)
			
			LuaSavePlayerList()
			
			--重置玩家的 keyChain 值
			for i = 1,#hVar.ConstItemIDList do
				xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..curPlayer..tostring(hVar.ConstItemIDList[i]),0)
			end
			
			xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..curPlayer.."SkillCardCount",0)
			xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..curPlayer.."WishingCount",0)
			xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..curPlayer.."ResolveBFSkillCount",0)
			
			xlDeleteFileWithFullPath(g_localfilepath..curPlayer..hVar.SAVE_DATA_PATH.MAP_SAVE)
			xlDeleteFileWithFullPath(g_localfilepath..curPlayer..hVar.SAVE_DATA_PATH.FOG)
			xlDeleteFileWithFullPath(g_localfilepath..curPlayer..hVar.SAVE_DATA_PATH.PLAYER_DATA)
			xlDeleteFileWithFullPath(g_localfilepath..curPlayer..hVar.SAVE_DATA_PATH.PLAYER_LOG)
			
			--设置当前玩家为创建新用户
			local index = 1
			LuaSetPlayerList(index,"__TEXT_CreateNewPlayer","local")
			if Save_PlayerData then 
				Save_PlayerData = {}
				Save_PlayerData = nil
			end
			
			if Save_PlayerLog then
				Save_PlayerLog = {}
				Save_PlayerLog = nil
			end
			
			xlPlayer_SetUID(0)
			
			hGlobal.UI.MsgBox(hVar.tab_string["uid_uuid_wrong"]..iUid..hVar.tab_string["uid_uuid_wrong1"],{font = hVar.FONTC,ok = function()xlExit()end,})
		end
	elseif 101 == iErrorCode then
        hGlobal.UI.MsgBox(hVar.tab_string["uid_uuid_wrong"]..iUid..hVar.tab_string["uid_uuid_wrong2"],{font = hVar.FONTC,ok = function()xlExit()end,})
    elseif 99 == iErrorCode then
		local bundleId = xlGetBundleID()
		--print(bundleId)
		if (bundleId == "alien.xingames.com") then
			--没有uid
			if Save_playerList then
				Save_playerList.LastSwitchPlayer = 1
			end
			
			local curPlayer = g_curPlayerName
			
			xlAppAnalysis("delete_savefile",0,1,"info","uID:"..tostring(xlPlayer_GetUID()).."-name:"..tostring(curPlayer).."-localuID:"..tostring(luaGetplayerUniqueID()).."-T:"..os.date("%m%d%H%M%S"))
			--清除掉全部的成就信息
			LuaDeletePlayerAutoSave(curPlayer)
			LuaClearLootFromUnit(curPlayer)
			LuaClearSelectConfig(curPlayer) --清空本地选人配置
			LuaClearSystemMailTitle(curPlayer) --清空玩家最近一次已阅读的系统邮件的标题
			LuaClearActivityAidList(curPlayer)--清空玩家已查看的活动aid列表
			LuaClearPVPUserInfo(curPlayer) --清空pvp玩家本局对战的对手信息
			LuaClearPVPIsShowGuide(curPlayer)--清空玩家pvp是否显示引导
			LuaClearPlayerBillBoard(curPlayer) --清空玩家今日本地排行榜的数据
			LuaClearTodayShopItemLimitCount(curPlayer) --清空玩家锁孔洗炼购买次数数据
			LuaClearTodayNetShopGoods(curPlayer) --清空玩家的今日商城商品列表
			LuaSetPlayerListMapUniqueID(curPlayer, 0)
			LuaClearGuiderecodeList(curPlayer)
			LuaClearRidByName(curPlayer)
			
			LuaSavePlayerList()
			
			--重置玩家的 keyChain 值
			for i = 1,#hVar.ConstItemIDList do
				xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..curPlayer..tostring(hVar.ConstItemIDList[i]),0)
			end
			
			xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..curPlayer.."SkillCardCount",0)
			xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..curPlayer.."WishingCount",0)
			xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..curPlayer.."ResolveBFSkillCount",0)
			
			xlDeleteFileWithFullPath(g_localfilepath..curPlayer..hVar.SAVE_DATA_PATH.MAP_SAVE)
			xlDeleteFileWithFullPath(g_localfilepath..curPlayer..hVar.SAVE_DATA_PATH.FOG)
			xlDeleteFileWithFullPath(g_localfilepath..curPlayer..hVar.SAVE_DATA_PATH.PLAYER_DATA)
			xlDeleteFileWithFullPath(g_localfilepath..curPlayer..hVar.SAVE_DATA_PATH.PLAYER_LOG)
			
			--设置当前玩家为创建新用户
			local index = 1
			LuaSetPlayerList(index,"__TEXT_CreateNewPlayer","local")
			if Save_PlayerData then 
				Save_PlayerData = {}
				Save_PlayerData = nil
			end
			
			if Save_PlayerLog then
				Save_PlayerLog = {}
				Save_PlayerLog = nil
			end
			
			xlPlayer_SetUID(0)
			
			local sInfo = string.format(hVar.tab_string["script_login_error_other"],iUid,iErrorCode)
			hGlobal.UI.MsgBox(sInfo,{font = hVar.FONTC,ok = function()xlExit()end,})
		end
	else
        local sInfo = string.format(hVar.tab_string["script_login_error_other"],iUid,iErrorCode)
        hGlobal.UI.MsgBox(sInfo,{font = hVar.FONTC,ok = function()xlExit()end,})
    end
end


-------------------------------------------test code --------------------------------------------------
-- 模拟充值 类型 参数 字符串 1 - 6
_ncf["send_TopUp"] = function(pType)
	local packet = CCWritePacket:create()
	packet:writeInt(10010)             -- 协议id
	packet:writeByte(pType) -- 充值类型 1-6
	xlNet_SendPacket(packet)
end

--------------------------------------------------------------------------------------------------------
--脚本触发一些连接服务器时的函数
function Lua_ConncctToServer(Connect_Result)
	--print("Lua_ConncctToServer" ,Connect_Result)
	--判断game_up.ss 里全局是否链接上DB的 全局变量
	if (Connect_Result == 1) then
		g_cur_net_state = 1
		Lua_DoLogin()
		
	elseif (Connect_Result == 0) then
		g_cur_net_state = -1
		
		if (g_phone_mode ~= 0) then
			hVar.ROLE_PLAYER_GOLD = 0 --存储本地金币数量
			hGlobal.event:event("LocalEvent_Phone_SetCurGameCoin_Game", "...")
		else
			hVar.ROLE_PLAYER_GOLD = 0 --存储本地金币数量
			hGlobal.event:event("LocalEvent_SetCurGameCoin", "...")
		end
	end
	
	--断开链接后的脚本通知
	hGlobal.event:event("LocalEvent_Set_activity_refresh",g_cur_net_state)
end

function xlLuaEvent_iapserver_connect_result(isShow)
	print("xlLuaEvent_iapserver_connect_result")
	--local iChannelId = xlGetChannelId()
	--if iChannelId < 100 then
		--Update_Data_Table.IsDBConnected = isShow
		--Lua_ConncctToServer(isShow)
	--end
end


--geyachao
--pc渠道号为106
local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
if TargetPlatform == g_tTargetPlatform.kTargetWindows then
	function xlGetChannelId()
		return 106
	end
end

--获取渠道信息
-- 0 保留
-- 1 appstore
-- 2 windows
-- 3 kuaiyong
-- 4 itools
-- 5 pp
-- 100 开始为android xinline
-- 101 android 删档1次测试
-- 102 android 删档2次测试
-- 1001 百度越狱版
function getChannelInfo()
	local iChannelId = 0
	local iKuaiyong = 0
	if xlGetChannelId then
		iChannelId = xlGetChannelId()
	else
		local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
		if TargetPlatform == g_tTargetPlatform.kTargetWindows then 
			iChannelId = 2
		elseif TargetPlatform == g_tTargetPlatform.kTargetIphone or TargetPlatform == g_tTargetPlatform.kTargetIpad then
			iChannelId = 1
			if xlIsFileExist("ky_install_sign") ~= 0 then
				iKuaiyong = 1
			end
		else --android
			iChannelId = 100
		end
	end
	
	print(string.format("getChannelInfo iChannelId:%d iKuaiyong:%d\n",iChannelId,iKuaiyong))

	return iChannelId,iKuaiyong
end

_ncf["iap_itemlistnew"] = function(iIapType)
	local packet = CCWritePacket:create()
	packet:writeInt(40104)
	packet:writeInt(0)
	packet:writeInt(iIapType)
	packet:writeInt(xlPlayer_GetUID())
	packet:writeInt(luaGetplayerDataID())
	local iChannelId = xlGetChannelId()
	print("40104",iChannelId,iIapType,xlPlayer_GetUID(),luaGetplayerDataID())
	xlNet_SendPacket(packet)
end

_ncf["iap_requestorder"] = function(iIapType,iItemId)
	local packet = CCWritePacket:create()
	packet:writeInt(40102)
	packet:writeInt(0)
	packet:writeInt(iIapType)
	packet:writeInt(xlPlayer_GetUID())
	packet:writeInt(luaGetplayerDataID())
	packet:writeInt(iItemId)
	xlNet_SendPacket(packet)
end

_ncf["iap_updateorder"] = function(sOrder,iRet)
	local packet = CCWritePacket:create()
	packet:writeInt(40106)
	packet:writeInt(0)
	packet:writeString(sOrder)
	packet:writeInt(iRet)
	xlNet_SendPacket(packet)
end

local function ReplaceSpChar(message)
	--去除特殊符号
	local origin = {"%(", "%)", "%.", "%%", "%+", "%-", "%*", "%?", "%[", "%]", "%^", "%$", ";", "/", "\\", "|", ":", ",","'",}
	local replace = {"（", "）", "·", "％", "＋", "－", "＊", "？", "【", "】", "∧", "＄", "；", "╱", "╲", "│", "：", "，","’",}
	for i = 1, #origin, 1 do
		local originChar = origin[i]
		local replaceChar = replace[i]
		--print(i, originChar, replaceChar)
		while true do
		--print(message)
			local pos = string.find(message, originChar)
			--print(pos)
			if (pos ~= nil) then
				if (pos < #message) then --不是最后一个字符
					message = string.sub(message, 1, pos - 1) .. replaceChar .. string.sub(message, pos + 1, #message)
				else --最后一个字符
					message = string.sub(message, 1, pos - 1) .. replaceChar
				end
			else
				break
			end
		end
	end

	--去除回车等控制字符
	string.gsub(message, "%c", "")
	return message
end

--评论弹幕系统，增加评论
_ncf["comment_system_add_comment"] = function(commentType,typeID,isBarrage,commentStr)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid

	local info = ""
	info = info .. tostring(uId) .. ";"
	info = info .. tostring(rId) .. ";"
	info = info .. tostring(commentType) .. ";"
	info = info .. tostring(typeID) .. ";"
	info = info .. tostring(isBarrage) .. ";"

	local see = ReplaceSpChar(commentStr)
	info = info .. see .. ";"
	print(see)

	_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_ADD,info)
	print("ncf comment_system_add_comment")
end

--评论弹幕系统，修改评论
_ncf["comment_system_edit_comment"] = function(commentID,isBarrage,commentStr)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	local info = ""
	info = info .. tostring(uId) .. ";"
	info = info .. tostring(rId) .. ";"
	info = info .. tostring(commentID) .. ";"
	info = info .. tostring(isBarrage) .. ";"
	info = info .. ReplaceSpChar(commentStr) .. ";"

	_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_EDIT,info)
	print("ncf comment_system_edit_comment")
end

--评论弹幕系统，删除评论
_ncf["comment_system_del_comment"] = function(commentID)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	local info = ""
	info = info .. tostring(uId) .. ";"
	info = info .. tostring(rId) .. ";"
	info = info .. tostring(commentID) .. ";"

	_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_DEL,info)
	print("ncf comment_system_del_comment")
end

--评论弹幕系统，查询评论
_ncf["comment_system_look_comment"] = function(commentType,typeID,pageIndex,orderType,getNum)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	local info = ""
	info = info .. tostring(uId) .. ";"
	info = info .. tostring(rId) .. ";"
	info = info .. tostring(commentType) .. ";"
	info = info .. tostring(typeID) .. ";"
	info = info .. tostring(pageIndex) .. ";"
	info = info .. tostring((getNum or 20)) .. ";"
	info = info .. tostring((orderType or 0)) .. ";"
	

	_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_LOOK,info)
	print("ncf comment_system_look_comment " ,info)
end

--评论弹幕系统，点赞评论
_ncf["comment_system_like_comment"] = function(commentID)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	local info = ""
	info = info .. tostring(uId) .. ";"
	info = info .. tostring(rId) .. ";"
	info = info .. tostring(commentID) .. ";"

	_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_LIKES,info)

	print("ncf comment_system_like_comment")

end

--评论弹幕系统，取消点赞评论
_ncf["comment_system_cannel_like_comment"] = function(commentID)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	local info = ""
	info = info .. tostring(uId) .. ";"
	info = info .. tostring(rId) .. ";"
	info = info .. tostring(commentID) .. ";"

	_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_CANNEL_LIKES,info)

	print("ncf comment_system_cannel_like_comment")
end

--评论弹幕系统，查看评论点赞数
_ncf["comment_system_like_count"] = function(commentID)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	local info = ""
	info = info .. tostring(commentID) .. ";"

	_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_LIKES_COUNT,info)

	print("ncf comment_system_like_count")
end

--评论弹幕系统，查看玩家是否对评论点赞
_ncf["comment_system_self_dolike_comment"] = function(commentID)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	local info = ""
	info = info .. tostring(uId) .. ";"
	info = info .. tostring(rId) .. ";"
	info = info .. tostring(commentID) .. ";"

	_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_USER_LIKES,info)

	print("ncf comment_system_self_dolike_comment")
end


--评论弹幕系统，获得评论标题
_ncf["comment_system_query_title"] = function(commentType,typeID)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	local info = ""
	info = info .. tostring(commentType) .. ";"
	info = info .. tostring(typeID) .. ";"

	_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_QUERY_TITLE,info)

	print("ncf comment_system_query_title",commentType,typeID)
end

--评论弹幕系统，修改创建评论标题
_ncf["comment_system_edit_title"] = function(commentType,typeID,title)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	local info = ""
	info = info .. tostring(commentType) .. ";"
	info = info .. tostring(typeID) .. ";"
	info = info .. tostring(title) .. ";"

	_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_EDIT_TITLE,info)

	print("ncf comment_system_edit_title")
end

--评论弹幕系统，获得弹幕
_ncf["comment_system_query_barrage"] = function(commentType,typeID,pageIndex)
	local uId = xlPlayer_GetUID()				--我的uid
	local rId = luaGetplayerDataID()			--我使用角色rid
	
	local info = ""
	info = info .. tostring(commentType) .. ";"
	info = info .. tostring(typeID) .. ";"
	info = info .. tostring(pageIndex) .. ";"

	_Lua_SendPacket(hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_BARRAGE_LOOK,info)

	print("ncf comment_system_query_barrage")
end

