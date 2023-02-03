--网络协发送处理
SendGroupCmdFunc = {}
local _ncf = SendGroupCmdFunc

--心跳包
_ncf["heart"] = function()
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	send[3] = math.floor(os.clock() * 1000)			--pvp当前ping时间
	send[4] = g_lastDelay_pvp				--pvp当前延时
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_HEART, send)
end




-----------------------------------------------------------------------------------------
--工会逻辑开始

--玩家聊天模块初始化
_ncf["chat_init"] = function()
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_INIT, send)
end

--查询指定聊天频道的和对方玩家的聊天id列表
_ncf["chat_get_id_list"] = function(chatType, touid)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = chatType or 0					--聊天频道
	send[4] = touid or 0					--对方好友uid(世界聊天不需要对方好友uid)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_ID_LIST, send)
end

--获取指定聊天消息id列表的内容
_ncf["chat_get_content_list"] = function(chatType, friendUid, tChatIdList, index, totalnum)
	local strIDList = ""
	local num = #tChatIdList
	for i = 1, num, 1 do
		strIDList = strIDList .. tostring(tChatIdList[i]) .. ";"
	end
	strIDList = tostring(num) .. ";" .. strIDList
	
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()				--我使用角色rid
	send[3] = chatType or 0					--聊天频道
	send[4] = friendUid or 0				--对方好友uid(世界聊天不需要对方好友uid)
	send[5] = index						--当前索引
	send[6] = totalnum					--总索引
	send[7] = strIDList					--聊天id列表
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_CONTENT_LIST, send)
end

--查询指定指定军团的聊天id列表（仅管理员可操作）
_ncf["chat_get_id_list_group_gm"] = function(chatType, touid)
	local send = {}
	send[1] = xlPlayer_GetUID()			--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = chatType or 0				--聊天频道
	send[4] = touid or 0				--军团id
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_ID_LIST_GROUP_GM, send)
end

--获取指定军团的聊天消息id列表的内容（仅管理员可操作）
_ncf["chat_get_content_list_group_gm"] = function(chatType, touid, tChatIdList, index, totalnum)
	local strIDList = ""
	local num = #tChatIdList
	for i = 1, num, 1 do
		strIDList = strIDList .. tostring(tChatIdList[i]) .. ";"
	end
	strIDList = tostring(num) .. ";" .. strIDList
	
	local send = {}
	send[1] = xlPlayer_GetUID()			--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = chatType or 0				--聊天频道
	send[4] = touid or 0				--军团id
	send[5] = index					--当前索引
	send[6] = totalnum				--总索引
	send[7] = strIDList				--聊天id列表
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_CONTENT_LIST_GROUP_GM, send)
end

--发送一条聊天消息
_ncf["chat_send_message"] = function(chatType, msgType, message, touid, tolist)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = chatType or 0					--聊天频道
	send[4] = msgType or 0					--消息类型
	
	--安卓，存档名都是online，这里读取showname
	local myName = g_curPlayerName
	if Save_playerList and Save_playerList[1] then
		myName = Save_playerList[1].showName
	end
	
	send[5] = tostring(hApi.StringEncodeEmoji(myName))				--玩家名 --处理表情
	send[6] = xlGetChannelId()				--渠道号
	send[7] = LuaGetPlayerVipLv()			--vip等级
	send[8] = LuaGetPlayerBorderID()		--玩家边框id
	send[9] = LuaGetPlayerIconID()			--玩家头像id
	send[10] = LuaGetPlayerChampionID()		--玩家称号id
	send[11] = LuaGetPlayerLeaderID()		--玩家会长权限
	send[12] = LuaGetPlayerDragonID()		--玩家聊天龙王id
	send[13] = LuaGetPlayerHeadID()			--玩家头衔id
	send[14] = LuaGetPlayerLineID()			--玩家线索id
	send[15] = tostring(hApi.StringEncodeEmoji(message))				--聊天内容 --处理表情
	send[16] = touid				--接收者uid
	send[17] = 0					--可交互类型消息的操作结果
	send[18] = 0					--可交互类型消息的操作参数
	
	--指定发送给的uid玩家列表
	send[19] = ""							--指定发送给的uid列表
	if (type(tolist) == "table") then
		send[19] = hApi.Array2String(tolist)
	end
	
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_SEND_MESSAGE, send)
end

--发送一条组队副本邀请聊天消息
_ncf["chat_send_message_battle"] = function(message, result, resultParam)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = hVar.CHAT_TYPE.INVITE			--聊天频道
	send[4] = hVar.MESSAGE_TYPE.INVITE_BATTLE	--消息类型
	
	--安卓，存档名都是online，这里读取showname
	local myName = g_curPlayerName
	if Save_playerList and Save_playerList[1] then
		myName = Save_playerList[1].showName
	end
	
	send[5] = tostring(hApi.StringEncodeEmoji(myName))				--玩家名 --处理表情
	send[6] = xlGetChannelId()				--渠道号
	send[7] = LuaGetPlayerVipLv()			--vip等级
	send[8] = LuaGetPlayerBorderID()		--玩家边框id
	send[9] = LuaGetPlayerIconID()			--玩家头像id
	send[10] = LuaGetPlayerChampionID()		--玩家称号id
	send[11] = LuaGetPlayerLeaderID()		--玩家会长权限
	send[12] = LuaGetPlayerDragonID()		--玩家聊天龙王id
	send[13] = LuaGetPlayerHeadID()			--玩家头衔id
	send[14] = LuaGetPlayerLineID()			--玩家线索id
	send[15] = tostring(hApi.StringEncodeEmoji(message))				--聊天内容 --处理表情
	send[16] = 0					--接收者uid
	send[17] = result or 0				--可交互类型消息的操作结果
	send[18] = resultParam or 0			--可交互类型消息的操作参数
	send[19] = ""					--指定发送给的uid列表
	
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_SEND_MESSAGE_BATTLE, send)
end

--请求更新指定消息id的内容
_ncf["chat_update_message"] = function(chatType, msgId, touid)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = chatType						--聊天频道
	send[4] = msgId							--消息id
	send[5] = touid							--接收者uid
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_UPDATE_MESSAGE, send)
end

--删除一条聊天消息（只有管理员才有权限操作）
_ncf["chat_remove_message"] = function(msgId)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = msgId							--消息唯一id
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_REMOVE_MESSGAE, send)
end

--删除一条组队邀请消息
_ncf["chat_remove_message_battle"] = function(msgId)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = msgId							--消息唯一id
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_REMOVE_MESSGAE_BATTLE, send)
end

--禁言聊天玩家（只有管理员才有权限操作）
_ncf["chat_forbidden_user"] = function(uid, minute)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = uid							--玩家uid
	send[4] = minute						--禁言时长（单位: 分钟）
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_FORBIDDEN_USER, send)
end

--请求和对方玩家发起私聊
_ncf["chat_private_invite"] = function(tMsg)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	
	--安卓，存档名都是online，这里读取showname
	local myName = g_curPlayerName
	if Save_playerList and Save_playerList[1] then
		myName = Save_playerList[1].showName
	end
	
	send[3] = tostring(hApi.StringEncodeEmoji(myName))	--我的玩家名 --处理表情
	send[4] = xlGetChannelId()				--我的渠道号
	send[5] = LuaGetPlayerVipLv()			--我的vip等级
	send[6] = LuaGetPlayerBorderID()		--我的边框id
	send[7] = LuaGetPlayerIconID()			--我的头像id
	send[8] = LuaGetPlayerChampionID()		--玩家称号id
	send[9] = LuaGetPlayerLeaderID()		--玩家会长权限
	send[10] = LuaGetPlayerDragonID()		--玩家聊天龙王id
	send[11] = LuaGetPlayerHeadID()			--玩家头衔id
	send[12] = LuaGetPlayerLineID()			--玩家线索id
	send[13] = tMsg.uid						--对方uid
	send[14] = tostring(hApi.StringEncodeEmoji(tMsg.name))		--对方玩家名
	send[15] = tMsg.channelId					--对方渠道号
	send[16] = tMsg.vip						--对方vip等级
	send[17] = tMsg.borderId					--对方边框id
	send[18] = tMsg.iconId						--对方头像id
	send[19] = tMsg.championId					--对方称号id
	send[20] = tMsg.leaderId					--对方会长权限
	send[21] = tMsg.dragonId					--对方聊天龙王id
	send[22] = tMsg.headId						--对方头衔id
	send[23] = tMsg.lineId						--对方线索id
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_PRIVATE_INVITE, send)
end

--私聊验证消息操作
_ncf["chat_private_invite_op"] = function(msgId, touid, inviteflag)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = msgId							--消息唯一id
	send[4] = touid							--消息接收者uid
	send[5] = inviteflag					--操作结果
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_PRIVATE_INVITE_OP, send)
end

--删除私聊好友
_ncf["chat_private_delete"] = function(touid)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = touid							--删除好友的uid
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_PRIVATE_DELETE, send)
end

--兑换军团战术卡碎片
_ncf["group_exchange_tacticcard"] = function(strSelectCardInfo)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = strSelectCardInfo				--选择的战术卡信息
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_EXCHAGE_TACTIC_DEBRIS, send)
end

--获取英雄将魂信息
_ncf["group_query_herodebris_info"] = function()
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_HERO_DEBRIS_INFO, send)
end

--兑换军团英雄将魂
_ncf["group_exchange_herodebris"] = function(strSelectCardInfo)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = strSelectCardInfo				--选择的英雄将魂信息
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_EXCHAGE_HERO_DEBRIS, send)
end

--会长、助理购买副本次数
_ncf["group_buy_battle_count"] = function()
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_BUY_BATTLE_COUNT, send)
end

--军团发送红包
_ncf["group_send_redpacket"] = function(groupId, sendIndex)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	
	--安卓，存档名都是online，这里读取showname
	local myName = g_curPlayerName
	if Save_playerList and Save_playerList[1] then
		myName = Save_playerList[1].showName
	end
	
	send[3] = tostring(hApi.StringEncodeEmoji(myName))				--玩家名 --处理表情
	send[4] = xlGetChannelId()				--渠道号
	send[5] = LuaGetPlayerVipLv()			--vip等级
	send[6] = LuaGetPlayerBorderID()		--玩家边框id
	send[7] = LuaGetPlayerIconID()			--玩家头像id
	send[8] = LuaGetPlayerChampionID()		--玩家称号id
	send[9] = LuaGetPlayerLeaderID()		--玩家会长权限
	send[10] = LuaGetPlayerDragonID()		--玩家聊天龙王id
	send[11] = LuaGetPlayerHeadID()			--玩家头衔id
	send[12] = LuaGetPlayerLineID()			--玩家线索id
	send[13] = groupId				--军团id
	send[14] = sendIndex				--红包索引
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_SEND_GROUP_REDPACKET, send)
end

--领取军团红包
_ncf["receive_group_redpacket"] = function(groupId, redPacketId)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	
	--安卓，存档名都是online，这里读取showname
	local myName = g_curPlayerName
	if Save_playerList and Save_playerList[1] then
		myName = Save_playerList[1].showName
	end
	
	send[3] = tostring(hApi.StringEncodeEmoji(myName))				--玩家名 --处理表情
	send[4] = xlGetChannelId()				--渠道号
	send[5] = LuaGetPlayerVipLv()			--vip等级
	send[6] = LuaGetPlayerBorderID()		--玩家边框id
	send[7] = LuaGetPlayerIconID()			--玩家头像id
	send[8] = LuaGetPlayerChampionID()		--玩家称号id
	send[9] = LuaGetPlayerLeaderID()		--玩家会长权限
	send[10] = LuaGetPlayerDragonID()		--玩家聊天龙王id
	send[11] = LuaGetPlayerHeadID()			--玩家头衔id
	send[12] = LuaGetPlayerLineID()			--玩家线索id
	send[13] = groupId				--军团id
	send[14] = redPacketId				--红包id
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_RECEIVE_GROUP_REDPACKET, send)
end

--领取支付（土豪）红包
_ncf["receive_pay_redpacket"] = function(redPacketId)
	local send = {}
	send[1] = xlPlayer_GetUID()			--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	
	
	--安卓，存档名都是online，这里读取showname
	local myName = g_curPlayerName
	if Save_playerList and Save_playerList[1] then
		myName = Save_playerList[1].showName
	end
	
	send[3] = tostring(hApi.StringEncodeEmoji(myName))				--玩家名 --处理表情
	send[4] = xlGetChannelId()			--渠道号
	send[5] = LuaGetPlayerVipLv()			--vip等级
	send[6] = LuaGetPlayerBorderID()		--玩家边框id
	send[7] = LuaGetPlayerIconID()			--玩家头像id
	send[8] = LuaGetPlayerChampionID()		--玩家称号id
	send[9] = LuaGetPlayerLeaderID()		--玩家会长权限
	send[10] = LuaGetPlayerDragonID()		--玩家聊天龙王id
	send[11] = LuaGetPlayerHeadID()			--玩家头衔id
	send[12] = LuaGetPlayerLineID()			--玩家线索id
	send[13] = redPacketId				--红包id
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_RECEIVE_PAY_REDPACKET, send)
end

--查看支付（土豪）红包的领取详情
_ncf["viewdetail_pay_redpacket"] = function(redPacketId)
	local send = {}
	send[1] = xlPlayer_GetUID()			--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = redPacketId				--红包id
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_VIEWDETAIL_PAY_REDPACKET, send)
end

--请求发送一条军团今日系统消息
_ncf["chat_send_group_system_message"] = function(message, nInteractType)
	local send = {}
	send[1] = xlPlayer_GetUID()			--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = tostring(hApi.StringEncodeEmoji(message))				--聊天内容 --处理表情
	send[4] = nInteractType					--可交互事件的类型
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_SEND_GROUP_SYSTEM_MESSAGE, send)
end

--请求发送一条世界关卡通关系统消息
_ncf["chat_send_world_battle_system_message"] = function(message)
	local send = {}
	send[1] = xlPlayer_GetUID()			--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = tostring(hApi.StringEncodeEmoji(message))				--聊天内容 --处理表情
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_SEND_WORLD_BATTLE_SYSTEM_MESSAGE, send)
end

--请求查询军团军饷任务完成情况
_ncf["group_military_task_query"] = function()
	local send = {}
	send[1] = xlPlayer_GetUID()			--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_MILITARY_TASK_INFO, send)
end

--请求领取军团军饷任务
_ncf["group_military_task_takereward"] = function()
	local send = {}
	send[1] = xlPlayer_GetUID()			--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_MILITARY_TASK_TAKEREWARD, send)
end

--踢出其他军团长期不在线成员（仅管理员可操作）
_ncf["group_kick_offline_player"] = function(groupId, uid)
	local send = {}
	send[1] = xlPlayer_GetUID()			--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = groupId				--军团id
	send[4] = uid					--踢出的玩家id
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_KICK_OFFLINE_PLAYER, send)
end

--任命玩家为会长（仅管理员可操作）
_ncf["group_assetadmin_player"] = function(groupId, uid)
	local send = {}
	send[1] = xlPlayer_GetUID()			--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = groupId				--军团id
	send[4] = uid					--任命的玩家id
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_ASSET_ADMIN_PLAYER, send)
end

--请求转让军团
_ncf["group_transfer"] = function(groupId, uid)
	local send = {}
	send[1] = xlPlayer_GetUID()			--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = groupId				--军团id
	send[4] = uid					--转让的玩家id
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_TRANSFER, send)
end

--请求解散军团（仅管理员可操作）
_ncf["group_assetadmin_disolute"] = function(groupId)
	local send = {}
	send[1] = xlPlayer_GetUID()			--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = groupId				--军团id
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_DISOLUTE, send)
end

--请求创建军团邀请函
_ncf["group_invite_create"] = function(groupId, dayMin, vipMin)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	
	--安卓，存档名都是online，这里读取showname
	local myName = g_curPlayerName
	if Save_playerList and Save_playerList[1] then
		myName = Save_playerList[1].showName
	end
	
	send[3] = tostring(hApi.StringEncodeEmoji(myName))				--玩家名 --处理表情
	send[4] = xlGetChannelId()				--渠道号
	send[5] = LuaGetPlayerVipLv()			--vip等级
	send[6] = LuaGetPlayerBorderID()		--玩家边框id
	send[7] = LuaGetPlayerIconID()			--玩家头像id
	send[8] = LuaGetPlayerChampionID()		--玩家称号id
	send[9] = LuaGetPlayerLeaderID()		--玩家会长权限
	send[10] = LuaGetPlayerDragonID()		--玩家聊天龙王id
	send[11] = LuaGetPlayerHeadID()			--玩家头衔id
	send[12] = LuaGetPlayerLineID()			--玩家线索id
	send[13] = groupId				--军团id
	send[14] = dayMin				--需要的最小注册天数
	send[15] = vipMin				--需要的最小vip等级
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_INVITE_CREATE, send)
end

--请求加入军团邀请函
_ncf["group_invite_join"] = function(inviteId)
	local send = {}
	send[1] = xlPlayer_GetUID()			--我的uid
	send[2] = luaGetplayerDataID()			--我使用角色rid
	send[3] = inviteId				--军团邀请函id
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_INVITE_JOIN, send)
end















-------------------------------------------------------------
--军团 1000+

--获取公会列表
_ncf["get_guild_list"] = function(ptype)
	print("get_guild_list")
	local t = {type=ptype,uid=xlPlayer_GetUID()}	--组织传入参数
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_NOVICECAMP_LIST,sCmd)
end

--申请加入军团获取军团列表
_ncf["get_guild_join_list"] = function(ptype)
	print("get_guild_join_list")
	local t = {type=ptype,uid=xlPlayer_GetUID()}	--组织传入参数
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_NOVICECAMP_LIST_JOIN,sCmd)
end

--申请加入某公会
_ncf["apply_join_guild"] = function(ncid)
	print("apply_join_guild")
	local t = {ncid=ncid,uid=xlPlayer_GetUID()}
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_POWER_JION_REQUEST,sCmd)
end

--申请创建公会
_ncf["apply_create_guild"] = function(ptype,guild_name,descripe,master_name,master_uid,country)
	print("apply_create_guild")
	
	--安卓，存档名都是online，这里读取showname
	local myName = g_curPlayerName
	if Save_playerList and Save_playerList[1] then
		myName = Save_playerList[1].showName
	end
	
	local t = {type=ptype,master_uid = master_uid or xlPlayer_GetUID(), master_name = hApi.StringEncodeEmoji(myName),name=hApi.StringEncodeEmoji(guild_name),descripe=hApi.StringEncodeEmoji(descripe),country = country}
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_NOVICECAMP_CREATE,sCmd)
end

--查询公会成员
_ncf["get_guild_member_list"] = function(ncid,level)
	local t = {ncid=ncid,uid=xlPlayer_GetUID(),level=level}
	--table_print(t)
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_MEMBER_LIST,sCmd)
end

--同意申请
_ncf["Agree_guild_member_join"] = function(ncid,uid_member)
	local t = {ncid=ncid,uid=xlPlayer_GetUID(),uid_member=uid_member}
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_POWER_JION_ACCEPT,sCmd)
end

--修改公会介绍
_ncf["change_guild_descripe"] = function(ncid,descripe)
	local t = {ncid=ncid,uid=xlPlayer_GetUID(),descripe=hApi.StringEncodeEmoji(descripe)}
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_NOVICECAMP_UPDATE,sCmd)
end

--解散公会
_ncf["disband_legion"] = function(ncid)
	local t = {ncid=ncid,uid=xlPlayer_GetUID()}
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_NOVICECAMP_REMOVE,sCmd)
end

--公会踢人
_ncf["guild_kick_player"] = function(ncid,uid_member,kickActive)
	local t = {ncid=ncid,uid=xlPlayer_GetUID(),uid_member=uid_member,kickActive=kickActive,}
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_POWER_FIRE,sCmd)
end

--公会任命助理
_ncf["assitant_member_appointment"] = function(ncid,uid_member)
	local t = {ncid=ncid,uid=xlPlayer_GetUID(),uid_member=uid_member}
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_POWER_ASSISTANT_APPOINT,sCmd)
end

--公会取消任命助理
_ncf["assitant_member_disappointment"] = function(ncid,uid_member)
	local t = {ncid=ncid,uid=xlPlayer_GetUID(),uid_member=uid_member}
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_POWER_ASSISTANT_DISAPPOINT,sCmd)
end

--获取公会奖励信息
_ncf["get_guild_rewardInfo"] = function()
	local t = {uid=xlPlayer_GetUID()}
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_CONFIG_PRIZE,sCmd)
end

--取消申请公会
_ncf["cancel_guild_join"] = function(ncid) 
	local t = {ncid=ncid,uid=xlPlayer_GetUID()}
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_POWER_JION_CANCEL,sCmd)
end

--驳回申请
_ncf["turndown_guild_join"] = function(ncid,uid_member) 
	local t = {ncid=ncid,uid=xlPlayer_GetUID(),uid_member=uid_member}
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_POWER_JION_REJECT,sCmd)
end

--修改公会名字 
_ncf["change_guild_name"] = function(ncid,name)
	local t = {ncid=ncid,uid=xlPlayer_GetUID(),name=hApi.StringEncodeEmoji(name)}
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_NOVICECAMP_RENAME,sCmd)
end

--升级公会建筑
_ncf["upgrade_legion_build"] = function(ncid,bid)
	local t = {uid=xlPlayer_GetUID(),rid=luaGetplayerDataID(),ncid=ncid,bid = bid,}
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_BUILDING_UPGRADE,sCmd)
end

_ncf["get_build_prize"] = function(ncid,bid,nindex)
	local t = {uid=xlPlayer_GetUID(),rid=luaGetplayerDataID(),ncid=ncid,bid = bid,blv = nindex,}
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_BUILDING_PRIZE,sCmd)
end

--退出军团
_ncf["quit_legion"] = function(ncid)
	local t = {uid=xlPlayer_GetUID(),rid=luaGetplayerDataID(),ncid=ncid}
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_POWER_QUIT,sCmd)
end

_ncf["upgrade_legion_tactics"] = function(ncid,bid,nindex)
	local t = {uid=xlPlayer_GetUID(),rid=luaGetplayerDataID(),ncid=ncid,bid = bid,blv = nindex,}
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_CARD_UPGRADE,sCmd)
end

--请求查找军团
_ncf["group_search"] = function(ptype, searchName)
	local t = {uid=xlPlayer_GetUID(),rid=luaGetplayerDataID(),type=ptype, searchName = hApi.StringEncodeEmoji(searchName),}
	local sCmd = Table2Cmd(t)
	Group_Server:Send(hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_SEARCH,sCmd)
end
