--服务器接收协议号
hVar.GROUP_OPR_TYPE = {
	
	--1~99,系统消息
	C2L_REQUIRE_HEART		= 1,					--心跳包
	C2L_REQUIRE_DEBUG		= 2,					--GM_Debug
	
	--GROUP系统
	C2L_REQUIRE_CHAT_INIT	= 100,					--请求初始化玩家聊天
	C2L_REQUIRE_CHAT_ID_LIST	= 101,				--获取聊天消息id列表
	C2L_REQUIRE_CHAT_CONTENT_LIST	= 102,			--获取指定聊天消息id列表的内容
	C2L_REQUIRE_CHAT_SEND_MESSAGE	= 103,			--请求发送一条聊天消息
	C2L_REQUIRE_CHAT_UPDATE_MESSAGE	= 104,			--请求更新一条聊天消息
	C2L_REQUIRE_CHAT_REMOVE_MESSGAE	= 105,			--请求删除一条聊天消息
	C2L_REQUIRE_CHAT_FORBIDDEN_USER	= 106,			--请求禁言玩家聊天
	C2L_REQUIRE_CHAT_PRIVATE_INVITE	= 107,			--请求和对方玩家私聊
	C2L_REQUIRE_CHAT_PRIVATE_INVITE_OP	= 108,		--私聊验证消息操作
	C2L_REQUIRE_CHAT_PRIVATE_DELETE	= 109,			--请求删除私聊好友
	C2L_REQUIRE_CHAT_SEND_GROUP_SYSTEM_MESSAGE	= 110,--请求发送一条军团系统聊天消息
	C2L_REQUIRE_EXCHAGE_TACTIC_DEBRIS	= 111,		--请求兑换战术卡碎片
	C2L_REQUIRE_EXCHAGE_HERO_DEBRIS	= 112,			--请求兑换英雄将魂
	C2L_REQUIRE_EXCHAGE_GROUPCOIN_CHEST	= 113,		--请求兑换军团币宝箱
	C2L_REQUIRE_HERO_DEBRIS_INFO	= 114,			--请求查询英雄将魂信息
	C2L_REQUIRE_BUY_BATTLE_COUNT	= 115,			--请求购买军团副本次数
	C2L_REQUIRE_SEND_GROUP_REDPACKET	= 116,		--请求发送军团红包
	C2L_REQUIRE_RECEIVE_GROUP_REDPACKET	=117,		--请求领取军团红包
	C2L_REQUIRE_CHAT_SEND_WORLD_BATTLE_SYSTEM_MESSAGE	= 118,--请求发送一条世界关卡通关系统聊天消息
	C2L_REQUIRE_GROUP_MILITARY_TASK_INFO	= 119,		--请求查询军团军饷任务完成情况
	C2L_REQUIRE_GROUP_MILITARY_TASK_TAKEREWARD	= 120,	--请求领取军团军饷任务
	C2L_REQUIRE_RECEIVE_PAY_REDPACKET	=121,		--请求领取支付（土豪）红包
	C2L_REQUIRE_VIEWDETAIL_PAY_REDPACKET	=122,		--请求查看支付（土豪）红包的领取详情
	C2L_REQUIRE_GROUP_KICK_OFFLINE_PLAYER	= 123,		--请求踢出长期不在线的其他军团的玩家（仅管理员可操作）
	C2L_REQUIRE_GROUP_ASSET_ADMIN_PLAYER	= 124,		--请求任命玩家为会长（仅管理员可操作）
	C2L_REQUIRE_GROUP_TRANSFER		= 125,		--请求转让军团
	C2L_REQUIRE_GROUP_DISOLUTE		= 126,		--请求解散军团（仅管理员可操作）
	C2L_REQUIRE_GROUP_INVITE_CREATE		= 127,		--请求创建军团邀请函
	C2L_REQUIRE_GROUP_INVITE_JOIN		= 128,		--请求加入军团邀请函
	C2L_REQUIRE_CHAT_ID_LIST_GROUP_GM	= 129,		--获取指定军团的聊天消息id列表（仅管理员可操作）
	C2L_REQUIRE_CHAT_CONTENT_LIST_GROUP_GM	= 130,		--获取指定军团的聊天消息id列表的内容（仅管理员可操作）
	C2L_REQUIRE_CHAT_REMOVE_MESSGAE_BATTLE	= 131,		--请求删除一条组队副本邀请聊天消息
	C2L_REQUIRE_CHAT_SEND_MESSAGE_BATTLE	= 132,		--请求发送一条组队副本邀请聊天消息
	
	
	
	
	
	
	
	--新手营
	C2L_NOVICECAMP_LIST		= 1001,				--请求新手营列表
	C2L_NOVICECAMP_CREATE		= 1002,				--创建新手营
	C2L_NOVICECAMP_REMOVE		= 1003,				--解散新手营
	C2L_MEMBER_LIST			= 1004,				--查看成员列表
	C2L_POWER_JION_ACCEPT		= 1005,				--营长通过新手申请
	C2L_POWER_JION_REJECT		= 1006,				--营长驳回新手申请
	C2L_POWER_JION_REQUEST		= 1007,				--新手申请加营
	C2L_POWER_JION_CANCEL		= 1008,				--新手取消申请
	C2L_NOVICECAMP_UPDATE		= 1009,				--更新新手营信息
	C2L_POWER_FIRE			= 1010,				--踢人
	C2L_CONFIG_PRIZE		= 1011,				--请求奖励信息
	C2L_NOVICECAMP_RENAME		= 1012,				--修改新手营名字
	C2L_BUILDING_UPGRADE		= 1013,				--建筑升级
	C2L_BUILDING_PRIZE		= 1014,				--获取建筑奖励
	C2L_POWER_QUIT			= 1015,				--退出公会
	C2L_CARD_UPGRADE		= 1016,				--战术卡升级
	C2L_POWER_ASSISTANT_APPOINT	= 1017,				--会长任命助理
	C2L_POWER_ASSISTANT_DISAPPOINT	= 1018,				--会长取消任命助理
	C2L_NOVICECAMP_LIST_JOIN	= 1019,				--请求申请加入军团列表
	C2L_REQUIRE_GROUP_SEARCH	= 1020,				--请求查找军团
}

--服务器返回协议号
hVar.GROUP_RECV_TYPE = {
	--1~99,系统消息
	L2C_NOTICE_USER_LOGIN		= 1,				--玩家登陆1
	L2C_NOTICE_PING			= 2,					--ping协议
	L2C_NOTICE_ERROR		= 98,					--错误事件1
	
	--GROUP系统
	L2C_NOTICE_CHAT_ORPEATION_RESULT	= 100,		--返回操作结果通知
	L2C_NOTICE_CHAT_INIT		= 101,				--返回初始化玩家聊天结果
	L2C_NOTICE_CHAT_ID_LIST		= 102,				--返回聊天消息id列表
	L2C_NOTICE_CHAT_CONTENT_LIST		= 103,		--返回指定聊天消息id列表的内容
	L2C_NOTICE_CHAT_SINGLE_MESSAGE	= 104,			--返回单条聊天消息
	L2C_NOTICE_CHAT_UPDATE_MESSAGE	= 105,			--返回更新单条聊天消息
	L2C_NOTICE_CHAT_REMOVE_MESSAGE	= 106,			--返回删除聊天消息
	L2C_NOTICE_CHAT_USER_FORBIDDEN	= 107,			--返回玩家被禁言的结果
	L2C_NOTICE_CHAT_PRIVATE_INVITE	= 108,			--返回请求和对方玩家私聊的结果
	L2C_NOTICE_CHAT_SINGLE_PRIVATE_USER	= 109,		--返回收到增加单个私聊好友
	L2C_NOTICE_CHAT_REMOVE_PRIVATE_USER	= 110,		--返回收到移除单个私聊好友
	L2C_NOTICE_EXCHAGE_TACTIC_DEBRIS	= 111,		--返回兑换战术卡碎片结果
	L2C_NOTICE_EXCHAGE_HERO_DEBRIS	= 112,			--返回兑换英雄将魂结果
	L2C_NOTICE_EXCHAGE_GROUPCOIN_CHEST	= 113,		--返回兑换军团币宝箱结果
	L2C_NOTICE_QUERY_HERO_DEBRIS_INFO	= 114,		--返回查询英雄将魂信息结果
	L2C_NOTICE_GROUP_RESOURCE_INFO	= 115,			--返回军团资源变化结果
	L2C_NOTICE_GROUP_BUY_BATTLE_COUNT	= 116,		--返回军团会长购买副本次数结果
	L2C_NOTICE_GROUP_SEND_REDPACKET	= 117,			--返回发送军团红包结果
	L2C_NOTICE_GROUP_RECEIVE_REDPACKET	= 118,		--返回领取军团红包结果
	L2C_NOTICE_GROUP_MILITARY_TASK_QUERY	= 119,		--返回查询军团军饷任务完成结果
	L2C_NOTICE_GROUP_MILITARY_TASK_TAKEREWARD	= 120,	--返回领取军团军饷任务结果
	L2C_NOTICE_PAY_RECEIVE_REDPACKET	= 121,		--返回领取支付（土豪）红包结果
	L2C_NOTICE_PAY_VIEWDETAIL_REDPACKET	= 122,		--返回查看支付（土豪）红包的领取详情结果
	L2C_NOTICE_GROUP_KICK_OFFLINE_PLAYER	= 123,		--返回踢出长期不在线的其他军团的玩家结果（仅管理员可操作）
	L2C_NOTICE_GROUP_ASSET_ADMIN_PLAYER	= 124,		--返回任命玩家为会长结果（仅管理员可操作）
	L2C_NOTICE_GROUP_TRANSFER		= 125,		--返回军团转让结果
	L2C_NOTICE_GROUP_DISOLUTE		= 126,		--返回军团解散结果（仅管理员可操作）
	L2C_NOTICE_GROUP_INVITE_CREATE		= 127,		--返回创建军团邀请函结果
	L2C_NOTICE_GROUP_INVITE_JOIN		= 128,		--返回加入军团邀请函结果
	L2C_NOTICE_CHAT_SEND_MESSAGE_BATTLE	= 129,		--返回请求发送一条组队副本邀请聊天消息结果
	
	
	
	
	
	
	--新手营
	L2C_NOVICECAMP_LIST		= 1001,				--返回新手营列表
	L2C_NOVICECAMP_CREATE		= 1002,				--返回新手营创建结果
	L2C_NOVICECAMP_REMOVE		= 1003,				--返回新手营解散结果
	L2C_MEMBER_LIST			= 1004,				--返回成员列表
	L2C_POWER_JION_ACCEPT		= 1005,				--返回营长通过新手申请
	L2C_POWER_JION_REJECT		= 1006,				--返回营长驳回新手申请
	L2C_POWER_JION_REQUEST		= 1007,				--返回新手申请加营结果
	L2C_POWER_JION_CANCEL		= 1008,				--返回新手取消申请结果
	L2C_NOVICECAMP_UPDATE		= 1009,				--返回更新新手营信息结果
	L2C_POWER_FIRE			= 1010,				--返回踢人结果
	L2C_CONFIG_PRIZE		= 1011,				--返回奖励信息
	L2C_NOVICECAMP_RENAME		= 1012,				--返回修改新手营名字结果
	L2C_BUILDING_UPGRADE		= 1013,				--返回建筑升级结果
	L2C_BUILDING_PRIZE		= 1014,				--返回建筑奖励
	L2C_POWER_QUIT			= 1015,				--返回退出公会结果
	L2C_CARD_UPGRADE		= 1016,				--返回战术卡升级结果
	L2C_POWER_ASSISTANT_APPOINT	= 1017,				--返回会长任命助理结果
	L2C_POWER_ASSISTANT_DISAPPOINT	= 1018,				--返回会长取消任命助理结果
	L2C_NOVICECAMP_LIST_JOIN	= 1019,				--返回申请加入军团列表
	L2C_NOTICE_GROUP_SEARCH_RET	= 1020,				--返回军团查找结果
}

--GROUP服务器错误码
hVar.GROUPNETERR = 
{
	UNKNOW_ERROR = 0,				--未知错误
	LOGIN_PLAYER_EXEIST = 1,			--玩家已存在
	LOGIN_PLAYER_FULL = 2,				--玩家已满
}

--网络协议接收处理
GroupLuaNetCmd = {}
--收到消息的总入口
--GroupLuaOnNetPack = function(NetPack)
function GroupLuaOnNetPack(NetPack)
	local protocolId = NetPack[1]
	--程序的约定,服务器脚本协议协议号为66666
	if protocolId and protocolId == 66666 then
		--从第二位开始去协议ID
		local typeID = NetPack[2]
		local param1 = NetPack[3]
		local param2 = NetPack[4]
		local data = NetPack[5]
		--print("GroupLuaOnNetPack typeid:" .. tostring(typeID))
		if typeID and data and type(data) == "string" and type(GroupLuaNetCmd[typeID]) == "function" then
			--local netData = {}
			--for i = 3,#NetPack do
			--	netData[#netData+1] = NetPack[i]
			--end
			--脚本协议数据,第三位为字符串.
			if typeID < 1000 then
				local tCmd = hApi.Split(data, ";")
				GroupLuaNetCmd[typeID](tCmd)
			else
				GroupLuaNetCmd[typeID](data)
			end
		end
	else
		print("GroupLuaOnNetPack unknown potocolId:", protocolId)
	end
end


--GROUP玩家登入事件
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_USER_LOGIN] = function(tCmd)
	local iResult = tonumber(tCmd[1]) --0:失败 / 1:成功
	local playerId = 0
	
	if (iResult == 1) then --成功
		--版本号
		g_pvp_control = tostring(tCmd[1])
		
		--基本信息
		playerId = tonumber(tCmd[2])
	elseif (iResult == 0) then --失败
		--
	end
	
	hGlobal.event:event("LocalEvent_Group_UserLoginEvent", iResult, playerId) --0失败 1成功
	print("GROUP玩家登入事件", iResult, playerId)
end


--ping协议
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_PING] = function(tCmd)
	local onlineCount = tonumber(tCmd[1])
	
	--print("onlineCount=", onlineCount)
end


--返回收到操作结果通知事件
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT] = function(tCmd)
	local result = tonumber(tCmd[1]) or 0			--操作结果
	
	--local strText = "操作失败，错误码: " .. result
	local strText = string.format(hVar.tab_string["__TEXT_OperationFail_ErrorCode"], hVar.tab_string["__TEXT_PVP_Operation"], result)
	
	if (result == hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_AUTHORITY"] --"您没有权限进行此操作"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_MSGID) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_MSGID"] --"无效的消息"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_UID"] --"无效的玩家"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_USER_INIT) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_USER_INIT"] --"玩家未初始化"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] --"参数不合法"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_FOBIDDEN) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_FOBIDDEN"] --"您被禁言无法发送消息"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PRIVATE_FOBIDDEN) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PRIVATE_FOBIDDEN"] --"您被禁言无法发起私聊"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_TYPE) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_TYPE"] --"只能发送私聊消息"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_FRIEND) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_FRIEND"] --"对方不在您的私聊列表里"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_FRIEND_ME) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_FRIEND_ME"] --"您不在对方的私聊列表里"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_INVITE"] --"等待对方通过私聊请求"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_USER_OFFLINE) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_USER_OFFLINE"] --"对方不在线，无法发起私聊"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_USER_NUMMAX) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_USER_NUMMAX"] --"您的私聊人数已达上限，无法发起私聊"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_USER_NUMMAX_ME) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_USER_NUMMAX_ME"] --"对方私聊人数已达上限，无法发起私聊"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_USER_SAMEME) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_USER_SAMEME"] --"不能和自己私聊"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_SAME) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_INVITE_SAME"] --"不能重复发送私聊请求"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REMOVE) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_INVITE_OP_REMOVE"] --"对方已关闭和你的私聊"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REMOVE_ME) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_INVITE_OP_REMOVE_ME"] --"您已将对方删除"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REFUSE) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_INVITE_OP_REFUSE"] --"对方已拒绝您的私聊请求"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REFUSE_ME) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_INVITE_OP_REFUSE_ME"] --"您已拒绝对方的私聊请求"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_MAXCOUNT) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_PRIVATE_INVITE_MAXCOUNT"] --"您今日请求私聊该玩家的次数已达上限"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_NOT_IN_GROUP) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_NOT_IN_GROUP"] --"您还未加入军团"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_INVALID_GROUP) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_INVALID_GROUP"] --"您不在此军团里"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISSOLUTION_GROUP) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_DISSOLUTION_GROUP"] --"该军团不存在或已解散"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_USER_NOT_JOIN) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_USER_NOT_JOIN"] --"玩家未加入军团"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_KICK_24HOUR) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_KICK_24HOUR"] --"玩家加入军团24小时以上才能移除"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_KICK_24HOUR_NODONATE) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_KICK_24HOUR_NODONATE"] --"玩家最近24小时内无贡献度才能移除"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_LEAVE_24HOUR) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_LEAVE_24HOUR"] --"加入军团24小时以上才能退出"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISSOLUTION_24HOUR) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_DISSOLUTION_24HOUR"] --"加入军团24小时以上才能解散"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_OPERATION_SELF_INVALID) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_OPERATION_SELF_INVALID"] --"会长不能对自己操作"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_CREATE_24HOUR) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_CREATE_24HOUR"] --"退出军团24小时以上才能创建"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_JOIN_24HOUR) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_JOIN_24HOUR"] --"退出军团24小时以上才能申请"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_NOT_ENOUGH_GAMECOIN) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_NOT_ENOUGH_GAMECOIN"] --"您没有足够的游戏币"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_JOIN_OR_SUBMIT_GROUP) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_JOIN_OR_SUBMIT_GROUP"] --"您已加入或申请军团"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_GROUPNAME_SAME) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_GROUPNAME_SAME"] --"您输入的军团名已存在"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_MENBER_NUM_MAX) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_MENBER_NUM_MAX"] --"军团人数已满"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_EXCHANGE_TACTIC_DEBIRS_MAXCOUNT) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_EXCHANGE_TACTIC_DEBIRS_MAXCOUNT"] --"今日可捐献次数已用完"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_EXCHANGE_TACTIC_DEBIRS_INVALID) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_EXCHANGE_TACTIC_DEBIRS_INVALID"] --"无效的战术卡碎片"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_EXCHANGE_TACTIC_DEBIRS_NUMERROR) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_EXCHANGE_TACTIC_DEBIRS_NUMERROR"] --"战术卡碎片不足"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_EXCHANGE_HERO_DEBIRS_MAXCOUNT) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_EXCHANGE_HERO_DEBIRS_MAXCOUNT"] --"今日可捐献次数已用完"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_EXCHANGE_HERO_DEBIRS_INVALID) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_EXCHANGE_HERO_DEBIRS_INVALID"] --"无效的英雄将魂"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_EXCHANGE_HERO_DEBIRS_NUMERROR) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_EXCHANGE_HERO_DEBIRS_NUMERROR"] --"英雄将魂不足"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_BUY_BATTLE_MAXCOUNT) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_BUY_BATTLE_MAXCOUNT"] --"今日购买次数已达上限"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_SEND_RED_PACKET_MAXCOUNT) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_SEND_RED_PACKET_MAXCOUNT"] --"今日发红包次数已达上限"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_DELETE_MSGTYPE) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_CHAT_DELETE_MSGTYPE"] --"此类型消息不能删除"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_RED_PACKET_INVALID) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_RED_PACKET_INVALID"] --"该红包不存在或已过期"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_RECEIVE_RED_PACKET_EMYPT) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_RECEIVE_RED_PACKET_EMYPT"] --"该红包已全部领完"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_RED_PACKET_SEND_24HOUR) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_RED_PACKET_SEND_24HOUR"] --"加入军团24小时以上才能发红包"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_RED_PACKET_RECEIVE_24HOUR) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_RED_PACKET_RECEIVE_24HOUR"] --"加入军团24小时以上才能领红包"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_RED_PACKET_RECEIVE_MAXCOUNT) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_RED_PACKET_RECEIVE_MAXCOUNT"] --"您已领取过该红包"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_JOIN_POWER_NUM_MAX) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_JOIN_POWER_NUM_MAX"] --"该军团目前已有太多申请人数"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_FOBIDDEN_ALL) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_FOBIDDEN_ALL"] --"全员禁言中，只允许管理员发言"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_ASSISTANT_EXIST) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_ASSISTANT_EXIST"] --"军团助理已被任命"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_ASSISTANT_24HOUR) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_ASSISTANT_24HOUR"] --"取消军团助理24小时以上才能再次任命"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_ASSISTANT_CANCEL_NOVALID) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_ASSISTANT_CANCEL_NOVALID"] --"玩家不是军团助理"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_KICK_ASSISTANT) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_KICK_ASSISTANT"] --"移除军团助理前请先解除其职务"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_ACCEPT_ASSISTANT_DAY_MAX) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_ACCEPT_ASSISTANT_DAY_MAX"] --"军团助理每日只能操作2名玩家的申请"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_KICK_ASSISTANT_DAY_MAX) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_KICK_ASSISTANT_DAY_MAX"] --"军团助理每日只能移除2名玩家"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_RESOURCE_NOT_ENOUTH) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_RESOURCE_NOT_ENOUTH"] --"需要的资源不足"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_KICK_ADMIN) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_KICK_ADMIN"] --"会长不能被移除"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_MILITARY_TAKEREWARD_ONCE) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_MILITARY_TAKEREWARD_ONCE"] --"今日已领取过军饷"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_MILITARY_TAKEREWARD_FAIL) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_MILITARY_TAKEREWARD_FAIL"] --"未满足领取军饷条件"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_PAY_RED_PACKET_RECEIVE_FORBIDDEN) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_PAY_RED_PACKET_RECEIVE_FORBIDDEN"] --"您被禁言无法领取红包"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_PAY_RED_PACKET_INVALID) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_PAY_RED_PACKET_INVALID"] --"该红包不存在或已过期"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_PAY_RECEIVE_RED_PACKET_EMYPT) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_PAY_RECEIVE_RED_PACKET_EMYPT"] --"该红包已全部领完"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_PAY_RED_PACKET_RECEIVE_MAXCOUNT) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_PAY_RED_PACKET_RECEIVE_MAXCOUNT"] --"您已领取过该红包"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_CREATE_VIP_LEVEL) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_CREATE_VIP_LEVEL"] --"VIP2及以上才能创建军团"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_RESOURCE_ENOUGH_IRON) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_RESOURCE_ENOUGH_IRON"] --"军团铁资源不足"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_RESOURCE_ENOUGH_WOOD) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_RESOURCE_ENOUGH_WOOD"] --"军团木材资源不足"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_RESOURCE_ENOUGH_FOOD) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_RESOURCE_ENOUGH_FOOD"] --"军团粮食资源不足"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_KICK_30DADS_OFFLINE) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_KICK_30DADS_OFFLINE"] --"玩家30天未登录才能移除"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_ASSET_ADMIN_NOTASSITANT) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_ASSET_ADMIN_NOTASSITANT"] --"待任命的玩家必须是助理"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_ASSET_ADMIN_30DADS_OFFLINE) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_ASSET_ADMIN_30DADS_OFFLINE"] --"会长30天未登录才能卸任"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_ASSET_ADMIN_VIP_LEVEL) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_ASSET_ADMIN_VIP_LEVEL"] --"助理VIP2及以上才能任命为会长"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_TRANSFER_CREATE_30_DAYS) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_TRANSFER_CREATE_30_DAYS"] --"军团创建时间达到30天才能转让"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_TRANSFER_NOTASSITANT) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_TRANSFER_NOTASSITANT"] --"待转让的玩家必须是助理"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_TRANSFER_HAVE_TRANSFERD_30_DAYS) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_TRANSFER_HAVE_TRANSFERD_30_DAYS"] --"军团近30天内已经转让过"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_TRANSFER_ASSIST_VIP2) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_TRANSFER_ASSIST_VIP2"] --"助理达到VIP2才能转让"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_TRANSFER_NO_ASSIST) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_TRANSFER_NO_ASSIST"] --"军团助理尚未任命，无法转让"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_TRANSFER_MAINTOWN_LV3) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_TRANSFER_MAINTOWN_LV3"] --"主城达到3级才能转让"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISOLUTE_MEMBER1) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_DISOLUTE_MEMBER1"] --"军团只剩1人才能解散"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISOLUTE_30DADS_OFFLINE) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_DISOLUTE_30DADS_OFFLINE"] --"会长30天未登录才能解散"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_MODIFY_NOTICE_FORBIDDEN) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_MODIFY_NOTICE_FORBIDDEN"] --"您被禁言无法修改军团公告"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_MODIFY_NAME_FORBIDDEN) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_MODIFY_NAME_FORBIDDEN"] --"您被禁言无法修改军团名"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_CREATE_GROUP_FORBIDDEN) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_CREATE_GROUP_FORBIDDEN"] --"您被禁言无法创建军团"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_KICK_ACTIVE_PLAYER_NUM_MAX) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_KICK_ACTIVE_PLAYER_NUM_MAX"] --"军团每日只能移除2名活跃玩家"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_INVITE_TOOMAYN) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_INVITE_TOOMAYN"] --"当前已有军团邀请函数量达到上限"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_INVITE_ADMIN) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_INVITE_ADMIN"] --"只有会长才能发送军团邀请函"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_INVITE_EXISTED) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_INVITE_EXISTED"] --"您的军团邀请函已存在"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_INVITE_EXPIRED) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_INVITE_EXPIRED"] --"军团邀请函不存在或已过期"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_INVITE_VIP) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_INVITE_VIP"] --"您的VIP等级不符合军团邀请函条件"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_INVITE_REGTIME) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_INVITE_REGTIME"] --"您的注册时间不符合军团邀请函条件"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_JOIN_GROUP) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_JOIN_GROUP"] --"您已加入了军团"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_TACTICCARD_INTEGER) then
		strText = string.format(hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_TACTICCARD_INTEGER"], hVar.GROUP_ECHANGE_TACTICCARD_NUM) --"选择的碎片数量需为N的整数倍"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_HEROCARD_INTEGER) then
		strText = string.format(hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_HEROCARD_INTEGER"], hVar.GROUP_ECHANGE_HERODEBRIS_NUM) --"选择的英雄将魂数量需为N的整数倍"
	elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_NOCOUPLE_MAXNUM) then
		strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NOCOUPLE_MAXNUM"] --"当前组队邀请数量已达上限"
	end
	
	--冒字
	if (result ~= 1) then
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
	
	--通知事件：工会服务器收到操作结果返回
	hGlobal.event:event("LocalEvent_Group_OperationRet", result)
end

--返回玩家聊天模块初始化结果
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_INIT] = function(tCmd)
	local version = tostring(tCmd[1]) --工会服务器正式服版本号
	local debug_version = tostring(tCmd[2]) --工会服务器测试员版本号
	local world_flag = tonumber(tCmd[3]) or 0 --世界聊天开关
	local msgWorldNum = tonumber(tCmd[4]) or 0 --世界聊天次数
	local strWorldTime = tostring(tCmd[5]) --上次世界聊天时间
	local lastWorldMsgId = tonumber(tCmd[6]) or 0 --最近一条世界消息id
	local lastGroupMsgId = tonumber(tCmd[7]) or 0 --最近一条工会消息id
	local forbidden = tonumber(tCmd[8]) or 0 --是否禁言
	local strForbiddenTime = tostring(tCmd[9]) --禁言时间
	local forbidden_minute = tonumber(tCmd[10]) or 0 --禁言时常（单位:分钟）
	local forbidden_op_uid = tonumber(tCmd[11]) or 0 --禁言操作者uid
	local groupId = tonumber(tCmd[12]) or 0 --玩家所在的军团id
	local groupLevel = tonumber(tCmd[13]) or 0 --玩家所在的军团权限
	
	local inviteGroupNum = tonumber(tCmd[14]) or 0 --军团邀请函数量
	local invite_group_list = {} --军团邀请函数id表
	local rIdx = 15
	for i = 1, inviteGroupNum, 1 do
		local inviteGroupId = tonumber(tCmd[rIdx]) or 0			--军团邀请函id
		invite_group_list[#invite_group_list+1] = inviteGroupId
		rIdx = rIdx + 1
	end
	
	local inviteBattleNum = tonumber(tCmd[rIdx]) or 0 --组队副本邀请数量
	local invite_battle_list = {} --组队副本邀请消息id表
	rIdx = rIdx + 1
	for i = 1, inviteBattleNum, 1 do
		local msgId = tonumber(tCmd[rIdx]) or 0			--消息id
		invite_battle_list[#invite_battle_list+1] = msgId
		rIdx = rIdx + 1
	end
	
	local msg_private_friend_count = tonumber(tCmd[rIdx]) or 0 --私聊好友数量
	local msg_private_friend_chat_list = {} --私聊好友信息
	rIdx = rIdx + 1
	for i = 1, msg_private_friend_count, 1 do
		local touid = tonumber(tCmd[rIdx]) or 0				--好友uid
		local inviteflag = tonumber(tCmd[rIdx+1]) or 0			--好友是否通过邀请
		local online = tonumber(tCmd[rIdx+2]) or 0				--好友是否在线
		local toname = hApi.StringDecodeEmoji(tCmd[rIdx+3])		--好友玩家名 --解析表情
		local tochannelId = tonumber(tCmd[rIdx+4]) or 0			--好友玩家渠道号
		local tovip = tonumber(tCmd[rIdx+5]) or 0			--好友玩家vip等级
		local toborderId = tonumber(tCmd[rIdx+6]) or 0			--好友玩家边框id
		local toiconId = tonumber(tCmd[rIdx+7]) or 0			--好友玩家头像id
		local tochampionId = tonumber(tCmd[rIdx+8]) or 0		--好友玩家称号id
		local toleaderId = tonumber(tCmd[rIdx+9]) or 0			--好友玩家会长权限
		local todragonId = tonumber(tCmd[rIdx+10]) or 0			--好友玩家聊天龙王id
		local toheadId = tonumber(tCmd[rIdx+11]) or 0			--好友玩家头衔id
		local tolineId = tonumber(tCmd[rIdx+12]) or 0			--好友玩家线索id
		local lastMsgId = tonumber(tCmd[rIdx+13]) or 0			--好友最近一次聊天消息唯一ID
		--print("好友信息" .. i, touid, inviteflag, online, toname, tochannelId, tovip, toborderId, toiconId, tochampionId, toleaderId, todragonId, toheadId, tolineId, lastMsgId)
		
		local tFriend = {}
		tFriend.touid = touid
		tFriend.inviteflag = inviteflag
		tFriend.online = online
		tFriend.toname = toname
		tFriend.tochannelId = tochannelId
		tFriend.tovip = tovip
		tFriend.toborderId = toborderId
		tFriend.toiconId = toiconId
		tFriend.tochampionId = tochampionId
		tFriend.toleaderId = toleaderId
		tFriend.todragonId = todragonId
		tFriend.toheadId = toheadId
		tFriend.tolineId = tolineId
		tFriend.lastMsgId = lastMsgId
		msg_private_friend_chat_list[#msg_private_friend_chat_list+1] = tFriend
		
		rIdx = rIdx + 14
	end
	
	local msg_private_friend_last_uid = tonumber(tCmd[rIdx]) or 0 --私聊最近一次的好友uid
	local send_redpacket_num = tonumber(tCmd[rIdx+1]) or 0 --今日发军团红包次数
	local last_send_redpacket_time = tostring(tCmd[rIdx+2]) --最近一次发军团红包的时间
	
	--print("返回玩家聊天模块初始化结果", version, debug_version, world_flag, msgWorldNum, strWorldTime, lastWorldMsgId, lastGroupMsgId, forbidden, strForbiddenTime, forbidden_minute, forbidden_op_uid, groupId, groupLevel, invite_group_list, msg_private_friend_count, msg_private_friend_last_uid, send_redpacket_num, last_send_redpacket_time)
	
	--设置会长权限
	LuaSetPlayerLeaderID(groupLevel)
	
	--设置世界聊天的新收到的消息id
	local receive_msgid = LuaGetChatWorldReceiveMsgId(g_curPlayerName)
	if (receive_msgid >= 0) then
		LuaSetChatWorldReceiveMsgId(g_curPlayerName, lastWorldMsgId)
	elseif (lastWorldMsgId > math.abs(receive_msgid)) then --负数是聊天忠告
		LuaSetChatWorldReceiveMsgId(g_curPlayerName, lastWorldMsgId)
	end
	
	--设置邀请聊天的新收到的消息id
	if (inviteGroupNum > 0) then
		LuaSetChatInviteReceiveMsgId(g_curPlayerName, invite_group_list[inviteGroupNum])
	else
		LuaSetChatInviteReceiveMsgId(g_curPlayerName, 0)
	end
	
	--设置组队副本邀请消息是否未读
	if (inviteBattleNum > 0) then
		--本地有一些已读的消息id，检测是否和这些消息一致，一致的就不加入未读列表了
		local tBattle = LuaGetBattleInviteMsgIdList(g_curPlayerName)
		
		local notSaveFlag = true
		LuaRemoveBattleInviteMsgAll(g_curPlayerName, notSaveFlag)
		
		for i = 1, inviteBattleNum, 1 do
			local msgId = invite_battle_list[i]
			--print("msgId=", msgId)
			
			local bFind = false
			for t = 1, #tBattle, 1 do
				if (tBattle[t] == -msgId) then --找到了
					--print("找到了")
					bFind = true
					LuaSetBattleInviteMsgIdRead(g_curPlayerName, msgId, notSaveFlag)
					break
				end
			end
			
			if (not bFind) then
				LuaAddBattleInviteMsgId(g_curPlayerName, msgId, notSaveFlag)
				--print("添加消息")
			end
		end
	else
		LuaRemoveBattleInviteMsgAll(g_curPlayerName)
		--print("无消息")
	end
	
	--设置私聊提示进度
	LuaSetChatPrivateFriendList(g_curPlayerName, msg_private_friend_chat_list)
	
	--设置军团聊天的新收到的消息id
	LuaSetChatGroupReceiveMsgId(g_curPlayerName, lastGroupMsgId)
	
	--通知事件：工会服务器收到聊天模块初始化结果
	hGlobal.event:event("LocalEvent_Group_ChatInitEvent", version, debug_version, world_flag, msgWorldNum, strWorldTime, lastWorldMsgId, lastGroupMsgId, forbidden, strForbiddenTime, forbidden_minute, forbidden_op_uid, groupId, groupLevel, invite_group_list, msg_private_friend_chat_list, msg_private_friend_last_uid, send_redpacket_num, last_send_redpacket_time)
end

--返回聊天消息id列表
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ID_LIST] = function(tCmd)
	local chatType = tonumber(tCmd[1]) or 0 --聊天频道
	local friendUid = tonumber(tCmd[2]) or 0 --聊天好友uid
	local msgNum = tonumber(tCmd[3]) or 0 --消息数量
	local msgIDList = {}
	--print("返回聊天消息id列表", chatType, friendUid, msgNum)
	local rIdx = 4
	for i = 1, msgNum, 1 do
		local msgId = tonumber(tCmd[rIdx]) or 0 --消息id
		msgIDList[#msgIDList+1] = msgId
		rIdx = rIdx + 1
	end
	
	--通知事件：工会服务器收到聊天id列表
	hGlobal.event:event("LocalEvent_Group_ChatIDListEvent", chatType, friendUid, msgNum, msgIDList)
end

--返回指定聊天消息id列表的内容
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_CONTENT_LIST] = function(tCmd)
	local index = tonumber(tCmd[1]) or 0 --当前索引
	local totalnum = tonumber(tCmd[2]) or 0 --总索引
	local chatType = tonumber(tCmd[3]) or 0 --聊天频道
	local friendUid = tonumber(tCmd[4]) or 0 --聊天好友uid
	local msgNum = tonumber(tCmd[5]) or 0 --消息数量
	local tChatMsgList = {}
	--print("指定聊天消息id列表的内容", chatType, friendUid, msgNum)
	local rIdx = 6
	for i = 1, msgNum, 1 do
		local id = tonumber(tCmd[rIdx]) or 0				--消息唯一id
		local chatType = tonumber(tCmd[rIdx+1]) or 0			--聊天频道
		local msgType = tonumber(tCmd[rIdx+2]) or 0			--消息类型
		local uid = tonumber(tCmd[rIdx+3]) or 0				--玩家id
		local name = hApi.StringDecodeEmoji(tCmd[rIdx+4])		--玩家名 --解析表情
		local channelId = tonumber(tCmd[rIdx+5]) or 0			--玩家渠道号
		local vip = tonumber(tCmd[rIdx+6]) or 0				--玩家vip等级
		local borderId = tonumber(tCmd[rIdx+7]) or 0			--玩家边框id
		local iconId = tonumber(tCmd[rIdx+8]) or 0			--玩家头像id
		local championId = tonumber(tCmd[rIdx+9]) or 0			--玩家称号id
		local leaderId = tonumber(tCmd[rIdx+10]) or 0			--玩家会长权限
		local dragonId = tonumber(tCmd[rIdx+11]) or 0			--玩家聊天龙王id
		local headId = tonumber(tCmd[rIdx+12]) or 0			--玩家头衔id
		local lineId = tonumber(tCmd[rIdx+13]) or 0			--玩家线索id
		local content = hApi.StringDecodeEmoji(tCmd[rIdx+14])		--聊天内容 --解析表情
		local date = tCmd[rIdx+15]					--聊天时间
		local touid = tonumber(tCmd[rIdx+16]) or 0			--接收者uid
		local result = tonumber(tCmd[rIdx+17]) or 0			--可交互类型消息的操作结果
		local resultParam = tonumber(tCmd[rIdx+18]) or 0		--可交互类型消息的操作参数
		local redPacketParam = tostring(tCmd[rIdx+19])			--红包消息参数
		
		--print("收到聊天信息" .. i, id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, "touid=" .. touid, "result=" .. result, "resultParam=" .. resultParam, "redPacketParam=" .. redPacketParam)
		
		local tChatMsg = {}
		tChatMsg.id = id
		tChatMsg.uid = uid
		tChatMsg.chatType = chatType
		tChatMsg.msgType = msgType
		tChatMsg.name = name
		tChatMsg.channelId = channelId
		tChatMsg.vip = vip
		tChatMsg.borderId = borderId
		tChatMsg.iconId = iconId
		tChatMsg.championId = championId
		tChatMsg.leaderId = leaderId
		tChatMsg.dragonId = dragonId
		tChatMsg.headId = headId
		tChatMsg.lineId = lineId
		tChatMsg.content = content
		tChatMsg.date = date
		tChatMsg.touid = touid
		tChatMsg.result = result
		tChatMsg.resultParam = resultParam
		tChatMsg.redPacketParam = {}
		
		--军团发红包的红包参数信息
		if (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) then --军团发红包
			local redPacketParam = hApi.Split(redPacketParam, "|")
			local redPacketId = tonumber(redPacketParam[1]) or 0 --红包唯一id
			local send_uid = tonumber(redPacketParam[2]) or 0 --红包发送者uid
			local send_name = hApi.StringDecodeEmoji(redPacketParam[3]) --红包发送者名字 --解析表情
			local group_id = tonumber(redPacketParam[4]) or 0 --红包军团id
			local send_num = tonumber(redPacketParam[5]) or 0 --红包发送数量
			local content = hApi.StringDecodeEmoji(redPacketParam[6]) --内容 --解析表情
			local coin = tonumber(redPacketParam[7]) or 0 --游戏币
			local order_id = tonumber(redPacketParam[8]) or 0 --订单号
			local msg_id = tonumber(redPacketParam[9]) or 0 --消息id
			local receive_num = tonumber(redPacketParam[10]) or 0 --红包接收数量
			local send_time = tostring(redPacketParam[11]) --红包发送时间
			local expire_time = tostring(redPacketParam[12]) --红包过期时间
			local redPacketReceiveList = {}
			local tReceiveList = hApi.Split(redPacketParam[13], "_") --红包领取uid列表
			for k, strUID in pairs(tReceiveList) do
				local receive_uid = tonumber(strUID) or 0
				if (receive_uid > 0) then
					redPacketReceiveList[receive_uid] = receive_uid
				end
			end
			
			tChatMsg.redPacketParam.redPacketId = redPacketId
			tChatMsg.redPacketParam.send_uid = send_uid
			tChatMsg.redPacketParam.send_name = send_name
			tChatMsg.redPacketParam.group_id = group_id
			tChatMsg.redPacketParam.send_num = send_num
			tChatMsg.redPacketParam.content = content
			tChatMsg.redPacketParam.coin = coin
			tChatMsg.redPacketParam.order_id = order_id
			tChatMsg.redPacketParam.msg_id = msg_id
			tChatMsg.redPacketParam.receive_num = receive_num
			tChatMsg.redPacketParam.send_time = send_time
			tChatMsg.redPacketParam.expire_time = expire_time
			tChatMsg.redPacketParam.redPacketReceiveList = redPacketReceiveList
		elseif (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --发支付（土豪）红包
			local redPacketParam = hApi.Split(redPacketParam, "|")
			local redPacketId = tonumber(redPacketParam[1]) or 0 --红包唯一id
			local send_uid = tonumber(redPacketParam[2]) or 0 --红包发送者uid
			local send_name = hApi.StringDecodeEmoji(redPacketParam[3]) --红包发送者名字 --解析表情
			local send_num = tonumber(redPacketParam[4]) or 0 --红包发送数量
			local content = hApi.StringDecodeEmoji(redPacketParam[5]) --内容 --解析表情
			local money = tonumber(redPacketParam[6]) or 0 --充值金额
			local iap_id = tonumber(redPacketParam[7]) or 0 --充值记录id
			local channelId = tonumber(redPacketParam[8]) or 0 --渠道号
			local vipLv = tonumber(redPacketParam[9]) or 0 --vip等级
			local borderId = tonumber(redPacketParam[10]) or 0 --边框id
			local iconId = tonumber(redPacketParam[11]) or 0 --头像id
			local championId = tonumber(redPacketParam[12]) or 0 --称号id
			local leaderId = tonumber(redPacketParam[13]) or 0 --会长权限
			local dragonId = tonumber(redPacketParam[14]) or 0 --聊天龙王id
			local headId = tonumber(redPacketParam[15]) or 0 --头衔id
			local lineId = tonumber(redPacketParam[16]) or 0 --线索id
			local msg_id = tonumber(redPacketParam[17]) or 0 --消息id
			local receive_num = tonumber(redPacketParam[18]) or 0 --红包接收数量
			local send_time = tostring(redPacketParam[19]) --红包发送时间
			local expire_time = tostring(redPacketParam[20]) --红包过期时间
			local redPacketReceiveList = {}
			local tReceiveList = hApi.Split(redPacketParam[21], "_") --红包领取uid列表
			for k, strUID in pairs(tReceiveList) do
				local receive_uid = tonumber(strUID) or 0
				if (receive_uid > 0) then
					redPacketReceiveList[receive_uid] = receive_uid
				end
			end
			
			tChatMsg.redPacketParam.redPacketId = redPacketId
			tChatMsg.redPacketParam.send_uid = send_uid
			tChatMsg.redPacketParam.send_name = send_name
			tChatMsg.redPacketParam.send_num = send_num
			tChatMsg.redPacketParam.content = content
			tChatMsg.redPacketParam.money = money
			tChatMsg.redPacketParam.iap_id = iap_id
			tChatMsg.redPacketParam.channelId = channelId
			tChatMsg.redPacketParam.vipLv = vipLv
			tChatMsg.redPacketParam.borderId = borderId
			tChatMsg.redPacketParam.iconId = iconId
			tChatMsg.redPacketParam.championId = championId
			tChatMsg.redPacketParam.leaderId = leaderId
			tChatMsg.redPacketParam.dragonId = dragonId
			tChatMsg.redPacketParam.headId = headId
			tChatMsg.redPacketParam.lineId = lineId
			tChatMsg.redPacketParam.msg_id = msg_id
			tChatMsg.redPacketParam.receive_num = receive_num
			tChatMsg.redPacketParam.send_time = send_time
			tChatMsg.redPacketParam.expire_time = expire_time
			tChatMsg.redPacketParam.redPacketReceiveList = redPacketReceiveList
		elseif (msgType == hVar.MESSAGE_TYPE.INVITE_GROUP) then --军团邀请函
			--print(redPacketParam)
			local redPacketParam = hApi.Split(redPacketParam, "|")
			local inviteGroupId = tonumber(redPacketParam[1]) or 0 --军团邀请函唯一id
			local groupId = tonumber(redPacketParam[2]) or 0 --军团id
			local groupName = hApi.StringDecodeEmoji(redPacketParam[3]) --军团名 --解析表情
			local groupLevel = tonumber(redPacketParam[4]) or 0 --军团主城等级
			local groupForce = tonumber(redPacketParam[5]) or 0 --军团阵营
			local groupMember = tonumber(redPacketParam[6]) or 0 --军团当前成员人数
			local groupMemberMax = tonumber(redPacketParam[7]) or 0 --军团总人数
			local groupIntroduce = hApi.StringDecodeEmoji(redPacketParam[8]) --军团介绍 --解析表情
			local dayMin = tonumber(redPacketParam[9]) or 0 --军团需要的最小注册时间（天）
			local vipMin = tonumber(redPacketParam[10]) or 0 --军团需要的最小vip等级
			local msg_id = tonumber(redPacketParam[11]) or 0 --消息id
			local create_time = tostring(redPacketParam[12]) --军团邀请函发起时间
			local expire_time = tostring(redPacketParam[13]) --军团邀请函过期时间
			
			tChatMsg.redPacketParam.inviteGroupId = inviteGroupId
			tChatMsg.redPacketParam.groupId = groupId
			tChatMsg.redPacketParam.groupName = groupName
			tChatMsg.redPacketParam.groupLevel = groupLevel
			tChatMsg.redPacketParam.groupForce = groupForce
			tChatMsg.redPacketParam.groupMember = groupMember
			tChatMsg.redPacketParam.groupMemberMax = groupMemberMax
			tChatMsg.redPacketParam.groupIntroduce = groupIntroduce
			tChatMsg.redPacketParam.dayMin = dayMin
			tChatMsg.redPacketParam.vipMin = vipMin
			tChatMsg.redPacketParam.msg_id = msg_id
			tChatMsg.redPacketParam.create_time = create_time
			tChatMsg.redPacketParam.expire_time = expire_time
		end
		
		tChatMsgList[#tChatMsgList+1] = tChatMsg
		
		rIdx = rIdx + 20
	end
	
	--通知事件：工会服务器收到聊天id列表
	hGlobal.event:event("LocalEvent_Group_ChatContentListEvent", chatType, friendUid, msgNum, tChatMsgList, index, totalnum)
end

--收到玩家单条聊天信息
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE] = function(tCmd)
	local id = tonumber(tCmd[1]) or 0				--消息唯一id
	local chatType = tonumber(tCmd[2]) or 0				--聊天频道
	local msgType = tonumber(tCmd[3]) or 0				--消息类型
	local uid = tonumber(tCmd[4]) or 0				--玩家id
	local name = hApi.StringDecodeEmoji(tCmd[5])			--玩家名 --解析表情
	local channelId = tonumber(tCmd[6]) or 0			--玩家渠道号
	local vip = tonumber(tCmd[7]) or 0				--玩家vip等级
	local borderId = tonumber(tCmd[8]) or 0				--玩家边框id
	local iconId = tonumber(tCmd[9]) or 0				--玩家头像id
	local championId = tonumber(tCmd[10]) or 0			--玩家称号id
	local leaderId = tonumber(tCmd[11]) or 0			--玩家会长权限
	local dragonId = tonumber(tCmd[12]) or 0			--玩家聊天龙王id
	local headId = tonumber(tCmd[13]) or 0				--玩家头衔id
	local lineId = tonumber(tCmd[14]) or 0				--玩家线索id
	local content = hApi.StringDecodeEmoji(tCmd[15])		--聊天内容 --解析表情
	local date = tCmd[16]						--聊天时间
	local touid = tonumber(tCmd[17]) or 0				--接收者uid
	local result = tonumber(tCmd[18]) or 0				--可交互类型消息的操作结果
	local resultParam = tonumber(tCmd[19]) or 0			--可交互类型消息的操作参数
	local redPacketParam = tostring(tCmd[20])			--红包消息参数
	
	--print("收到玩家单条聊天信息", id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, "touid=" .. touid, "result=" .. result, "resultParam=" .. resultParam, "redPacketParam=" .. redPacketParam)
	
	--检测消息的有效性
	--组队副本消息，只能收到和自己游戏局id一致的消息
	if (chatType == hVar.CHAT_TYPE.COUPLE) then
		local sessionId = 0
		local world = hGlobal.WORLD.LastWorldMap
		if world then
			sessionId = world.data.session_dbId
		end
		if (sessionId ~= touid) then
			--print("组队副本消息，只能收到和自己游戏局id一致的消息")
			return
		end
	end
	
	local tChatMsg = {}
	tChatMsg.id = id
	tChatMsg.uid = uid
	tChatMsg.chatType = chatType
	tChatMsg.msgType = msgType
	tChatMsg.name = name
	tChatMsg.channelId = channelId
	tChatMsg.vip = vip
	tChatMsg.borderId = borderId
	tChatMsg.iconId = iconId
	tChatMsg.championId = championId
	tChatMsg.leaderId = leaderId
	tChatMsg.dragonId = dragonId
	tChatMsg.headId = headId
	tChatMsg.lineId = lineId
	tChatMsg.content = content
	tChatMsg.date = date
	tChatMsg.touid = touid
	tChatMsg.result = result
	tChatMsg.resultParam = resultParam
	tChatMsg.redPacketParam = {}
	
	--军团发红包的红包参数信息
	if (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) then --军团发红包
		local redPacketParam = hApi.Split(redPacketParam, "|")
		local redPacketId = tonumber(redPacketParam[1]) or 0 --红包唯一id
		local send_uid = tonumber(redPacketParam[2]) or 0 --红包发送者uid
		local send_name = hApi.StringDecodeEmoji(redPacketParam[3]) --红包发送者名字 --解析表情
		local group_id = tonumber(redPacketParam[4]) or 0 --红包军团id
		local send_num = tonumber(redPacketParam[5]) or 0 --红包发送数量
		local content = hApi.StringDecodeEmoji(redPacketParam[6]) --内容 --解析表情
		local coin = tonumber(redPacketParam[7]) or 0 --游戏币
		local order_id = tonumber(redPacketParam[8]) or 0 --订单号
		local msg_id = tonumber(redPacketParam[9]) or 0 --消息id
		local receive_num = tonumber(redPacketParam[10]) or 0 --红包接收数量
		local send_time = tostring(redPacketParam[11]) --红包发送时间
		local expire_time = tostring(redPacketParam[12]) --红包过期时间
		local redPacketReceiveList = {}
		local tReceiveList = hApi.Split(redPacketParam[13], "_") --红包领取uid列表
		for k, strUID in pairs(tReceiveList) do
			local receive_uid = tonumber(strUID) or 0
			if (receive_uid > 0) then
				redPacketReceiveList[receive_uid] = receive_uid
			end
		end
		
		tChatMsg.redPacketParam.redPacketId = redPacketId
		tChatMsg.redPacketParam.send_uid = send_uid
		tChatMsg.redPacketParam.send_name = send_name
		tChatMsg.redPacketParam.group_id = group_id
		tChatMsg.redPacketParam.send_num = send_num
		tChatMsg.redPacketParam.content = content
		tChatMsg.redPacketParam.coin = coin
		tChatMsg.redPacketParam.order_id = order_id
		tChatMsg.redPacketParam.msg_id = msg_id
		tChatMsg.redPacketParam.receive_num = receive_num
		tChatMsg.redPacketParam.send_time = send_time
		tChatMsg.redPacketParam.expire_time = expire_time
		tChatMsg.redPacketParam.redPacketReceiveList = redPacketReceiveList
	elseif (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --发支付（土豪）红包
		local redPacketParam = hApi.Split(redPacketParam, "|")
		local redPacketId = tonumber(redPacketParam[1]) or 0 --红包唯一id
		local send_uid = tonumber(redPacketParam[2]) or 0 --红包发送者uid
		local send_name = hApi.StringDecodeEmoji(redPacketParam[3]) --红包发送者名字 --解析表情
		local send_num = tonumber(redPacketParam[4]) or 0 --红包发送数量
		local content = hApi.StringDecodeEmoji(redPacketParam[5]) --内容 --解析表情
		local money = tonumber(redPacketParam[6]) or 0 --充值金额
		local iap_id = tonumber(redPacketParam[7]) or 0 --充值记录id
		local channelId = tonumber(redPacketParam[8]) or 0 --渠道号
		local vipLv = tonumber(redPacketParam[9]) or 0 --vip等级
		local borderId = tonumber(redPacketParam[10]) or 0 --边框id
		local iconId = tonumber(redPacketParam[11]) or 0 --头像id
		local championId = tonumber(redPacketParam[12]) or 0 --称号id
		local leaderId = tonumber(redPacketParam[13]) or 0 --会长权限
		local dragonId = tonumber(redPacketParam[14]) or 0 --聊天龙王id
		local headId = tonumber(redPacketParam[15]) or 0 --头衔id
		local lineId = tonumber(redPacketParam[16]) or 0 --线索id
		local msg_id = tonumber(redPacketParam[17]) or 0 --消息id
		local receive_num = tonumber(redPacketParam[18]) or 0 --红包接收数量
		local send_time = tostring(redPacketParam[19]) --红包发送时间
		local expire_time = tostring(redPacketParam[20]) --红包过期时间
		local redPacketReceiveList = {}
		local tReceiveList = hApi.Split(redPacketParam[21], "_") --红包领取uid列表
		for k, strUID in pairs(tReceiveList) do
			local receive_uid = tonumber(strUID) or 0
			if (receive_uid > 0) then
				redPacketReceiveList[receive_uid] = receive_uid
			end
		end
		
		tChatMsg.redPacketParam.redPacketId = redPacketId
		tChatMsg.redPacketParam.send_uid = send_uid
		tChatMsg.redPacketParam.send_name = send_name
		tChatMsg.redPacketParam.send_num = send_num
		tChatMsg.redPacketParam.content = content
		tChatMsg.redPacketParam.money = money
		tChatMsg.redPacketParam.iap_id = iap_id
		tChatMsg.redPacketParam.channelId = channelId
		tChatMsg.redPacketParam.vipLv = vipLv
		tChatMsg.redPacketParam.borderId = borderId
		tChatMsg.redPacketParam.iconId = iconId
		tChatMsg.redPacketParam.championId = championId
		tChatMsg.redPacketParam.leaderId = leaderId
		tChatMsg.redPacketParam.dragonId = dragonId
		tChatMsg.redPacketParam.headId = headId
		tChatMsg.redPacketParam.lineId = lineId
		tChatMsg.redPacketParam.msg_id = msg_id
		tChatMsg.redPacketParam.receive_num = receive_num
		tChatMsg.redPacketParam.send_time = send_time
		tChatMsg.redPacketParam.expire_time = expire_time
		tChatMsg.redPacketParam.redPacketReceiveList = redPacketReceiveList
	elseif (msgType == hVar.MESSAGE_TYPE.INVITE_GROUP) then --军团邀请函
		--print(redPacketParam)
		local redPacketParam = hApi.Split(redPacketParam, "|")
		local inviteGroupId = tonumber(redPacketParam[1]) or 0 --军团邀请函唯一id
		local groupId = tonumber(redPacketParam[2]) or 0 --军团id
		local groupName = hApi.StringDecodeEmoji(redPacketParam[3]) --军团名 --解析表情
		local groupLevel = tonumber(redPacketParam[4]) or 0 --军团主城等级
		local groupForce = tonumber(redPacketParam[5]) or 0 --军团阵营
		local groupMember = tonumber(redPacketParam[6]) or 0 --军团当前成员人数
		local groupMemberMax = tonumber(redPacketParam[7]) or 0 --军团总人数
		local groupIntroduce = hApi.StringDecodeEmoji(redPacketParam[8]) --军团介绍 --解析表情
		local dayMin = tonumber(redPacketParam[9]) or 0 --军团需要的最小注册时间（天）
		local vipMin = tonumber(redPacketParam[10]) or 0 --军团需要的最小vip等级
		local msg_id = tonumber(redPacketParam[11]) or 0 --消息id
		local create_time = tostring(redPacketParam[12]) --军团邀请函发起时间
		local expire_time = tostring(redPacketParam[13]) --军团邀请函过期时间
		
		tChatMsg.redPacketParam.inviteGroupId = inviteGroupId
		tChatMsg.redPacketParam.groupId = groupId
		tChatMsg.redPacketParam.groupName = groupName
		tChatMsg.redPacketParam.groupLevel = groupLevel
		tChatMsg.redPacketParam.groupForce = groupForce
		tChatMsg.redPacketParam.groupMember = groupMember
		tChatMsg.redPacketParam.groupMemberMax = groupMemberMax
		tChatMsg.redPacketParam.groupIntroduce = groupIntroduce
		tChatMsg.redPacketParam.dayMin = dayMin
		tChatMsg.redPacketParam.vipMin = vipMin
		tChatMsg.redPacketParam.msg_id = msg_id
		tChatMsg.redPacketParam.create_time = create_time
		tChatMsg.redPacketParam.expire_time = expire_time
	end
	
	if (chatType == hVar.CHAT_TYPE.WORLD) then --世界频道
		--设置世界聊天的新收到的消息id
		local receive_msgid = LuaGetChatWorldReceiveMsgId(g_curPlayerName)
		if (receive_msgid >= 0) then
			LuaSetChatWorldReceiveMsgId(g_curPlayerName, id)
		elseif (id > math.abs(receive_msgid)) then --负数是聊天忠告
			LuaSetChatWorldReceiveMsgId(g_curPlayerName, id)
		end
	elseif (chatType == hVar.CHAT_TYPE.INVITE) then --邀请频道
		--军团邀请函
		if (msgType == hVar.MESSAGE_TYPE.INVITE_GROUP) then --军团邀请函
			--设置邀请聊天的新收到的消息id
			--local receive_msgid = LuaGetChatInviteReceiveMsgId(g_curPlayerName)
			LuaSetChatInviteReceiveMsgId(g_curPlayerName, id)
		elseif (msgType == hVar.MESSAGE_TYPE.INVITE_BATTLE) then --组队副本邀请
			--新增组队副本邀请未查看的消息id
			LuaAddBattleInviteMsgId(g_curPlayerName, id)
			--print("新增组队副本邀请未查看的消息id", id)
		end
	elseif (chatType == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
		--设置私聊的新收到的消息id
		local friendUid = 0
		if (uid ~= xlPlayer_GetUID()) then --找到对方的uid
			friendUid = uid
		elseif (touid ~= xlPlayer_GetUID()) then
			friendUid = touid
		end
		if (friendUid > 0) then
			--print("设置私聊的新收到的消息id", g_curPlayerName, friendUid, id)
			LuaSetChatPrivateFriendReceiveMsgId(g_curPlayerName, friendUid, id)
		end
	elseif (chatType == hVar.CHAT_TYPE.GROUP) then --军团频道
		--设置军团聊天的新收到的消息id
		LuaSetChatGroupReceiveMsgId(g_curPlayerName, id)
	elseif (chatType == hVar.CHAT_TYPE.COUPLE) then --组队频道
		--设置组队聊天的新收到的消息id
		LuaSetChatCoupleReceiveMsgId(g_curPlayerName, id)
	end
	
	--通知事件：工会服务器收到玩家单条聊天信息
	hGlobal.event:event("LocalEvent_Group_SingleChatMessageEvent", tChatMsg)
end

--收到玩家更新单条聊天信息
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_UPDATE_MESSAGE] = function(tCmd)
	local id = tonumber(tCmd[1]) or 0				--消息唯一id
	local chatType = tonumber(tCmd[2]) or 0				--聊天频道
	local msgType = tonumber(tCmd[3]) or 0				--消息类型
	local uid = tonumber(tCmd[4]) or 0				--玩家id
	local name = hApi.StringDecodeEmoji(tCmd[5])			--玩家名 --解析表情
	local channelId = tonumber(tCmd[6]) or 0			--玩家渠道号
	local vip = tonumber(tCmd[7]) or 0				--玩家vip等级
	local borderId = tonumber(tCmd[8]) or 0				--玩家边框id
	local iconId = tonumber(tCmd[9]) or 0				--玩家头像id
	local championId = tonumber(tCmd[10]) or 0			--玩家称号id
	local leaderId = tonumber(tCmd[11]) or 0			--玩家会长权限
	local dragonId = tonumber(tCmd[12]) or 0			--玩家聊天龙王id
	local headId = tonumber(tCmd[13]) or 0				--玩家头衔id
	local lineId = tonumber(tCmd[14]) or 0				--玩家线索id
	local content = hApi.StringDecodeEmoji(tCmd[15])		--聊天内容 --解析表情
	local date = tCmd[16]						--聊天时间
	local touid = tonumber(tCmd[17]) or 0				--接收者uid
	local result = tonumber(tCmd[18]) or 0				--可交互类型消息的操作结果
	local resultParam = tonumber(tCmd[19]) or 0			--可交互类型消息的操作参数
	local redPacketParam = tostring(tCmd[20])			--红包消息参数
	
	--print("收到玩家更新单条聊天信息", id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, "touid=" .. touid, "result=" .. result, "resultParam=" .. resultParam, "redPacketParam=" .. redPacketParam)
	
	local tChatMsg = {}
	tChatMsg.id = id
	tChatMsg.uid = uid
	tChatMsg.chatType = chatType
	tChatMsg.msgType = msgType
	tChatMsg.name = name
	tChatMsg.channelId = channelId
	tChatMsg.vip = vip
	tChatMsg.borderId = borderId
	tChatMsg.iconId = iconId
	tChatMsg.championId = championId
	tChatMsg.leaderId = leaderId
	tChatMsg.dragonId = dragonId
	tChatMsg.headId = headId
	tChatMsg.lineId = lineId
	tChatMsg.content = content
	tChatMsg.date = date
	tChatMsg.touid = touid
	tChatMsg.result = result
	tChatMsg.resultParam = resultParam
	tChatMsg.redPacketParam = {}
	
	--军团发红包的红包参数信息
	if (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) then --军团发红包
		local redPacketParam = hApi.Split(redPacketParam, "|")
		local redPacketId = tonumber(redPacketParam[1]) or 0 --红包唯一id
		local send_uid = tonumber(redPacketParam[2]) or 0 --红包发送者uid
		local send_name = hApi.StringDecodeEmoji(redPacketParam[3]) --红包发送者名字 --解析表情
		local group_id = tonumber(redPacketParam[4]) or 0 --红包军团id
		local send_num = tonumber(redPacketParam[5]) or 0 --红包发送数量
		local content = hApi.StringDecodeEmoji(redPacketParam[6]) --内容 --解析表情
		local coin = tonumber(redPacketParam[7]) or 0 --游戏币
		local order_id = tonumber(redPacketParam[8]) or 0 --订单号
		local msg_id = tonumber(redPacketParam[9]) or 0 --消息id
		local receive_num = tonumber(redPacketParam[10]) or 0 --红包接收数量
		local send_time = tostring(redPacketParam[11]) --红包发送时间
		local expire_time = tostring(redPacketParam[12]) --红包过期时间
		local redPacketReceiveList = {}
		local tReceiveList = hApi.Split(redPacketParam[13], "_") --红包领取uid列表
		for k, strUID in pairs(tReceiveList) do
			local receive_uid = tonumber(strUID) or 0
			if (receive_uid > 0) then
				redPacketReceiveList[receive_uid] = receive_uid
			end
		end
		
		tChatMsg.redPacketParam.redPacketId = redPacketId
		tChatMsg.redPacketParam.send_uid = send_uid
		tChatMsg.redPacketParam.send_name = send_name
		tChatMsg.redPacketParam.group_id = group_id
		tChatMsg.redPacketParam.send_num = send_num
		tChatMsg.redPacketParam.content = content
		tChatMsg.redPacketParam.coin = coin
		tChatMsg.redPacketParam.order_id = order_id
		tChatMsg.redPacketParam.msg_id = msg_id
		tChatMsg.redPacketParam.receive_num = receive_num
		tChatMsg.redPacketParam.send_time = send_time
		tChatMsg.redPacketParam.expire_time = expire_time
		tChatMsg.redPacketParam.redPacketReceiveList = redPacketReceiveList
	elseif (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --发支付（土豪）红包
		local redPacketParam = hApi.Split(redPacketParam, "|")
		local redPacketId = tonumber(redPacketParam[1]) or 0 --红包唯一id
		local send_uid = tonumber(redPacketParam[2]) or 0 --红包发送者uid
		local send_name = hApi.StringDecodeEmoji(redPacketParam[3]) --红包发送者名字 --解析表情
		local send_num = tonumber(redPacketParam[4]) or 0 --红包发送数量
		local content = hApi.StringDecodeEmoji(redPacketParam[5]) --内容 --解析表情
		local money = tonumber(redPacketParam[6]) or 0 --充值金额
		local iap_id = tonumber(redPacketParam[7]) or 0 --充值记录id
		local channelId = tonumber(redPacketParam[8]) or 0 --渠道号
		local vipLv = tonumber(redPacketParam[9]) or 0 --vip等级
		local borderId = tonumber(redPacketParam[10]) or 0 --边框id
		local iconId = tonumber(redPacketParam[11]) or 0 --头像id
		local championId = tonumber(redPacketParam[12]) or 0 --称号id
		local leaderId = tonumber(redPacketParam[13]) or 0 --会长权限
		local dragonId = tonumber(redPacketParam[14]) or 0 --聊天龙王id
		local headId = tonumber(redPacketParam[15]) or 0 --头衔id
		local lineId = tonumber(redPacketParam[16]) or 0 --线索id
		local msg_id = tonumber(redPacketParam[17]) or 0 --消息id
		local receive_num = tonumber(redPacketParam[18]) or 0 --红包接收数量
		local send_time = tostring(redPacketParam[19]) --红包发送时间
		local expire_time = tostring(redPacketParam[20]) --红包过期时间
		local redPacketReceiveList = {}
		local tReceiveList = hApi.Split(redPacketParam[21], "_") --红包领取uid列表
		for k, strUID in pairs(tReceiveList) do
			local receive_uid = tonumber(strUID) or 0
			if (receive_uid > 0) then
				redPacketReceiveList[receive_uid] = receive_uid
			end
		end
		
		tChatMsg.redPacketParam.redPacketId = redPacketId
		tChatMsg.redPacketParam.send_uid = send_uid
		tChatMsg.redPacketParam.send_name = send_name
		tChatMsg.redPacketParam.send_num = send_num
		tChatMsg.redPacketParam.content = content
		tChatMsg.redPacketParam.money = money
		tChatMsg.redPacketParam.iap_id = iap_id
		tChatMsg.redPacketParam.channelId = channelId
		tChatMsg.redPacketParam.vipLv = vipLv
		tChatMsg.redPacketParam.borderId = borderId
		tChatMsg.redPacketParam.iconId = iconId
		tChatMsg.redPacketParam.championId = championId
		tChatMsg.redPacketParam.leaderId = leaderId
		tChatMsg.redPacketParam.dragonId = dragonId
		tChatMsg.redPacketParam.headId = headId
		tChatMsg.redPacketParam.lineId = lineId
		tChatMsg.redPacketParam.msg_id = msg_id
		tChatMsg.redPacketParam.receive_num = receive_num
		tChatMsg.redPacketParam.send_time = send_time
		tChatMsg.redPacketParam.expire_time = expire_time
		tChatMsg.redPacketParam.redPacketReceiveList = redPacketReceiveList
	elseif (msgType == hVar.MESSAGE_TYPE.INVITE_GROUP) then --军团邀请函
		local redPacketParam = hApi.Split(redPacketParam, "|")
		local inviteGroupId = tonumber(redPacketParam[1]) or 0 --军团邀请函唯一id
		local groupId = tonumber(redPacketParam[2]) or 0 --军团id
		local groupName = hApi.StringDecodeEmoji(redPacketParam[3]) --军团名 --解析表情
		local groupLevel = tonumber(redPacketParam[4]) or 0 --军团主城等级
		local groupForce = tonumber(redPacketParam[5]) or 0 --军团阵营
		local groupMember = tonumber(redPacketParam[6]) or 0 --军团当前成员人数
		local groupMemberMax = tonumber(redPacketParam[7]) or 0 --军团总人数
		local groupIntroduce = hApi.StringDecodeEmoji(redPacketParam[8]) --军团介绍 --解析表情
		local dayMin = tonumber(redPacketParam[9]) or 0 --军团需要的最小注册时间（天）
		local vipMin = tonumber(redPacketParam[10]) or 0 --军团需要的最小vip等级
		local msg_id = tonumber(redPacketParam[11]) or 0 --消息id
		local create_time = tostring(redPacketParam[12]) --军团邀请函发起时间
		local expire_time = tostring(redPacketParam[13]) --军团邀请函过期时间
		
		tChatMsg.redPacketParam.inviteGroupId = inviteGroupId
		tChatMsg.redPacketParam.groupId = groupId
		tChatMsg.redPacketParam.groupName = groupName
		tChatMsg.redPacketParam.groupLevel = groupLevel
		tChatMsg.redPacketParam.groupForce = groupForce
		tChatMsg.redPacketParam.groupMember = groupMember
		tChatMsg.redPacketParam.groupMemberMax = groupMemberMax
		tChatMsg.redPacketParam.groupIntroduce = groupIntroduce
		tChatMsg.redPacketParam.dayMin = dayMin
		tChatMsg.redPacketParam.vipMin = vipMin
		tChatMsg.redPacketParam.msg_id = msg_id
		tChatMsg.redPacketParam.create_time = create_time
		tChatMsg.redPacketParam.expire_time = expire_time
	end
	
	--通知事件：工会服务器收到玩家更新单条聊天信息
	hGlobal.event:event("LocalEvent_Group_UpdatChatMessageEvent", tChatMsg)
end

--收到删除玩家聊天信息
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE] = function(tCmd)
	local id = tonumber(tCmd[1]) or 0			--消息唯一id
	--print("收到删除玩家聊天信息", id)
	
	--删除组队副本邀请未查看的消息id
	LuaRemoveBattleInviteMsgId(g_curPlayerName, id)
	--print("删除组队副本邀请未查看的消息id", id)
	
	--通知事件：工会服务器收到删除玩家聊天信息
	hGlobal.event:event("LocalEvent_Group_RemoveChatMessageEvent", id)
end

--收到请求发送组队副本聊天信息结果返回
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SEND_MESSAGE_BATTLE] = function(tCmd)
	--print("收到请求发送组队副本聊天信息结果返回", result)
	
	local result = tonumber(tCmd[1]) or 0			--操作结果（1成功 / 0失败）
	local msgId = tonumber(tCmd[2]) or 0			--消息id
	
	--通知事件：工会服务器请求发送组队副本聊天信息结果返回
	hGlobal.event:event("LocalEvent_Group_OnSendMessageBattleRet", result, msgId)
end

--收到被禁言的通知
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_USER_FORBIDDEN] = function(tCmd)
	local version = tostring(tCmd[1]) --工会服务器正式服版本号
	local debug_version = tostring(tCmd[2]) --工会服务器测试员版本号
	local world_flag = tonumber(tCmd[3]) or 0 --世界聊天开关
	local msgWorldNum = tonumber(tCmd[4]) or 0 --世界聊天次数
	local strWorldTime = tostring(tCmd[5]) --上次世界聊天时间
	local lastWorldMsgId = tonumber(tCmd[6]) or 0 --最近一条世界消息id
	local lastGroupMsgId = tonumber(tCmd[7]) or 0 --最近一条工会消息id
	local forbidden = tonumber(tCmd[8]) or 0 --是否禁言
	local strForbiddenTime = tostring(tCmd[9]) --禁言时间
	local forbidden_minute = tonumber(tCmd[10]) or 0 --禁言时常（单位:分钟）
	local forbidden_op_uid = tonumber(tCmd[11]) or 0 --禁言操作者uid
	local groupId = tonumber(tCmd[12]) or 0 --玩家所在的军团id
	local groupLevel = tonumber(tCmd[13]) or 0 --玩家所在的军团权限
	
	local inviteGroupNum = tonumber(tCmd[14]) or 0 --军团邀请函数量
	local invite_group_list = {} --军团邀请函数id表
	local rIdx = 15
	for i = 1, inviteGroupNum, 1 do
		local inviteGroupId = tonumber(tCmd[rIdx]) or 0			--军团邀请函id
		invite_group_list[#invite_group_list+1] = inviteGroupId
		rIdx = rIdx + 1
	end
	
	local inviteBattleNum = tonumber(tCmd[rIdx]) or 0 --组队副本邀请数量
	local invite_battle_list = {} --组队副本邀请消息id表
	rIdx = rIdx + 1
	for i = 1, inviteBattleNum, 1 do
		local msgId = tonumber(tCmd[rIdx]) or 0			--消息id
		invite_battle_list[#invite_battle_list+1] = msgId
		rIdx = rIdx + 1
	end
	
	local msg_private_friend_count = tonumber(tCmd[rIdx]) or 0 --私聊好友数量
	local msg_private_friend_chat_list = {} --私聊好友信息
	rIdx = rIdx + 1
	for i = 1, msg_private_friend_count, 1 do
		local touid = tonumber(tCmd[rIdx]) or 0				--好友uid
		local inviteflag = tonumber(tCmd[rIdx+1]) or 0			--好友是否通过邀请
		local online = tonumber(tCmd[rIdx+2]) or 0				--好友是否在线
		local toname = hApi.StringDecodeEmoji(tCmd[rIdx+3])		--好友玩家名 --解析表情
		local tochannelId = tonumber(tCmd[rIdx+4]) or 0			--好友玩家渠道号
		local tovip = tonumber(tCmd[rIdx+5]) or 0			--好友玩家vip等级
		local toborderId = tonumber(tCmd[rIdx+6]) or 0			--好友玩家边框id
		local toiconId = tonumber(tCmd[rIdx+7]) or 0			--好友玩家头像id
		local tochampionId = tonumber(tCmd[rIdx+8]) or 0		--好友玩家称号id
		local toleaderId = tonumber(tCmd[rIdx+9]) or 0			--好友玩家会长权限
		local todragonId = tonumber(tCmd[rIdx+10]) or 0			--好友玩家聊天龙王id
		local toheadId = tonumber(tCmd[rIdx+11]) or 0			--好友玩家头衔id
		local tolineId = tonumber(tCmd[rIdx+12]) or 0			--好友玩家线索id
		local lastMsgId = tonumber(tCmd[rIdx+13]) or 0			--好友最近一次聊天消息唯一ID
		--print("好友信息" .. i, touid, inviteflag, online, toname, tochannelId, tovip, toborderId, toiconId, tochampionId, toleaderId, todragonId, toheadId, tolineId, lastMsgId)
		
		local tFriend = {}
		tFriend.touid = touid
		tFriend.inviteflag = inviteflag
		tFriend.online = online
		tFriend.toname = toname
		tFriend.tochannelId = tochannelId
		tFriend.tovip = tovip
		tFriend.toborderId = toborderId
		tFriend.toiconId = toiconId
		tFriend.tochampionId = tochampionId
		tFriend.toleaderId = toleaderId
		tFriend.todragonId = todragonId
		tFriend.toheadId = toheadId
		tFriend.tolineId = tolineId
		tFriend.lastMsgId = lastMsgId
		msg_private_friend_chat_list[#msg_private_friend_chat_list+1] = tFriend
		
		rIdx = rIdx + 14
	end
	
	local msg_private_friend_last_uid = tonumber(tCmd[rIdx]) or 0 --私聊最近一次的好友uid
	local send_redpacket_num = tonumber(tCmd[rIdx+1]) or 0 --今日发军团红包次数
	local last_send_redpacket_time = tostring(tCmd[rIdx+2]) --最近一次发军团红包的时间
	
	--print("收到被禁言的通知", version, debug_version, world_flag, msgWorldNum, strWorldTime, lastWorldMsgId, lastGroupMsgId, forbidden, strForbiddenTime, forbidden_minute, forbidden_op_uid, groupId, groupLevel, invite_group_list, msg_private_friend_count, msg_private_friend_last_uid, send_redpacket_num, last_send_redpacket_time)
	
	--设置会长权限
	LuaSetPlayerLeaderID(groupLevel)
	
	--设置世界聊天的新收到的消息id
	local receive_msgid = LuaGetChatWorldReceiveMsgId(g_curPlayerName)
	if (receive_msgid >= 0) then
		LuaSetChatWorldReceiveMsgId(g_curPlayerName, lastWorldMsgId)
	elseif (lastWorldMsgId > math.abs(receive_msgid)) then --负数是聊天忠告
		LuaSetChatWorldReceiveMsgId(g_curPlayerName, lastWorldMsgId)
	end
	
	--设置邀请聊天的新收到的消息id
	if (inviteGroupNum > 0) then
		LuaSetChatInviteReceiveMsgId(g_curPlayerName, invite_group_list[inviteGroupNum])
	else
		LuaSetChatInviteReceiveMsgId(g_curPlayerName, 0)
	end
	
	--设置组队副本邀请消息是否未读
	if (inviteBattleNum > 0) then
		--本地有一些已读的消息id，检测是否和这些消息一致，一致的就不加入未读列表了
		local tBattle = LuaGetBattleInviteMsgIdList(g_curPlayerName)
		
		local notSaveFlag = true
		LuaRemoveBattleInviteMsgAll(g_curPlayerName, notSaveFlag)
		
		for i = 1, inviteBattleNum, 1 do
			local msgId = invite_battle_list[i]
			
			local bFind = false
			for t = 1, #tBattle, 1 do
				if (tBattle[t] == -msgId) then --找到了
					bFind = true
					LuaSetBattleInviteMsgIdRead(g_curPlayerName, msgId, notSaveFlag)
					break
				end
			end
			
			if (not bFind) then
				LuaAddBattleInviteMsgId(g_curPlayerName, msgId, notSaveFlag)
			end
		end
	else
		LuaRemoveBattleInviteMsgAll(g_curPlayerName)
	end
	
	--设置私聊提示进度
	LuaSetChatPrivateFriendList(g_curPlayerName, msg_private_friend_chat_list)
	
	--设置军团聊天的新收到的消息id
	LuaSetChatGroupReceiveMsgId(g_curPlayerName, lastGroupMsgId)
	
	--通知事件：工会服务器收到被禁言的通知
	hGlobal.event:event("LocalEvent_Group_ChatForbiddenEvent", version, debug_version, world_flag, msgWorldNum, strWorldTime, lastWorldMsgId, lastGroupMsgId, forbidden, strForbiddenTime, forbidden_minute, forbidden_op_uid, groupId, groupLevel, invite_group_list, msg_private_friend_chat_list, msg_private_friend_last_uid, send_redpacket_num, last_send_redpacket_time)
end

--收到发起私聊请求的结果返回
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_PRIVATE_INVITE] = function(tCmd)
	local result = tonumber(tCmd[1]) or 0			--操作结果
	--print("收到发起私聊请求的结果返回", result)
	
	--通知事件：工会服务器收到发起私聊请求的结果返回
	hGlobal.event:event("LocalEvent_Group_PrivateInviteChatEvent", result)
end

--收到增加单个私聊好友
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_PRIVATE_USER] = function(tCmd)
	local touid = tonumber(tCmd[1]) or 0			--好友uid
	local inviteflag = tonumber(tCmd[2]) or 0		--好友是否通过邀请
	local online = tonumber(tCmd[3]) or 0			--好友是否在线
	local toname = hApi.StringDecodeEmoji(tCmd[4])	--好友玩家名 --解析表情
	local tochannelId = tonumber(tCmd[5]) or 0		--好友玩家渠道号
	local tovip = tonumber(tCmd[6]) or 0			--好友玩家vip等级
	local toborderId = tonumber(tCmd[7]) or 0		--好友玩家边框id
	local toiconId = tonumber(tCmd[8]) or 0			--好友玩家头像id
	local tochampionId = tonumber(tCmd[9]) or 0		--好友玩家称号id
	local toleaderId = tonumber(tCmd[10]) or 0		--好友玩家会长权限
	local todragonId = tonumber(tCmd[11]) or 0		--好友玩家聊天龙王id
	local toheadId = tonumber(tCmd[12]) or 0		--好友玩家头衔id
	local tolineId = tonumber(tCmd[13]) or 0		--好友玩家线索id
	local lastMsgId = tonumber(tCmd[14]) or 0		--好友最近一次聊天消息唯一ID
	--print("添加单个好友信息", touid, inviteflag, online, toname, tochannelId, tovip, toborderId, toiconId, tochampionId, toleaderId, todragonId, toheadId, tolineId, lastMsgId)
	
	local tFriend = {}
	tFriend.touid = touid
	tFriend.inviteflag = inviteflag
	tFriend.online = online
	tFriend.toname = toname
	tFriend.tochannelId = tochannelId
	tFriend.tovip = tovip
	tFriend.toborderId = toborderId
	tFriend.toiconId = toiconId
	tFriend.tochampionId = tochampionId
	tFriend.toleaderId = toleaderId
	tFriend.todragonId = todragonId
	tFriend.toheadId = toheadId
	tFriend.tolineId = tolineId
	tFriend.lastMsgId = lastMsgId
	
	--此好友可能在我列表里，也可能是新加的
	--检查此好友之前的已读的消息id
	local read_msgid = LuaGetChatPrivateFriendReadMsgId(g_curPlayerName, touid) or 0
	if (read_msgid == 0) then
		LuaSetChatPrivateFriendReceiveMsgId(g_curPlayerName, touid, 1)
	end
	
	--通知事件：工会服务器收到增加单个私聊好友
	hGlobal.event:event("LocalEvent_Group_PrivateFriendAddEvent", tFriend)
end

--收到删除单个私聊好友
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_PRIVATE_USER] = function(tCmd)
	local touid = tonumber(tCmd[1]) or 0			--好友uid
	--print("删除单个好友信息", touid)
	
	--设置私聊进度
	LuaSetChatPrivateFriendReceiveMsgId(g_curPlayerName, touid, 0)
	LuaSetChatPrivateFriendReadMsgId(g_curPlayerName, touid, 0)
	
	--通知事件：工会服务器收到删除单个私聊好友
	hGlobal.event:event("LocalEvent_Group_PrivateFriendRemoveEvent", touid)
end

--收到兑换战术卡碎片结果
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_EXCHAGE_TACTIC_DEBRIS] = function(tCmd)
	local iResult = tonumber(tCmd[1]) --0:失败 / 1:成功
	local tCardList = {}
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--操作成功
	if (iResult == 1) then
		local cardNum = tonumber(tCmd[2]) or 0 --选择的卡片种类总数量
		local rIdx = 2
		for i = 1, cardNum, 1 do
			local tTacticInfo = hApi.Split(tCmd[rIdx+i], ":")
			local tacticId = tonumber(tTacticInfo[1]) or 0 --战术卡id
			local tacticNum = tonumber(tTacticInfo[2]) or 0 --战术卡数量
			--print(tacticId, tacticNum)
			tCardList[#tCardList+1] = {id = tacticId, num = tacticNum,}
		end
		
		--奖励信息
		local rewardResult = {}
		local rIdx = 2 + cardNum + 1
		local rewardNum = tonumber(tCmd[rIdx]) or 0 --奖励的数量
		for i = 1, rewardNum, 1 do
			local tReward = hApi.Split(tCmd[rIdx+i], ":")
			local rewardType = tonumber(tReward[1]) or 0 --奖励类型
			local rewardNum = tonumber(tReward[2]) or 0 --奖励数量
			--print(rewardType, rewardNum)
			rewardResult[#rewardResult+1] = {rewardType, rewardNum,}
		end
		
		--扣除战术卡碎片
		for i = 1, #tCardList, 1 do
			local tacticId = tCardList[i].id
			local tacticNum = tCardList[i].num
			
			--加(减)战术卡碎片数量
			LuaAddPlayerTacticDebris(tacticId, -tacticNum)
		end
		
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
	end
	
	--通知事件：工会服务器收到兑换战术卡碎片结果
	hGlobal.event:event("LocalEvent_Group_ExcnageTacticDebirsEvent", iResult, tCardList)
end

--收到查询英雄将魂信息结果
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_QUERY_HERO_DEBRIS_INFO] = function(tCmd)
	local heroNum = tonumber(tCmd[1]) --英雄数量
	local tHeroInfo = {}
	local rIdx = 1
	for i = 1, heroNum, 1 do
		local tHero = hApi.Split(tCmd[rIdx+1], ":")
		local heroId = tonumber(tHero[1]) or 0 --英雄id
		local star = tonumber(tHero[2]) or 0 --英雄星级
		local debrisNum = tonumber(tHero[3]) or 0 --英雄碎片数量
		local debrisTotalNum = tonumber(tHero[4]) or 0 --英雄碎片历史总数量
		--print(heroId, star, debrisNum, debrisTotalNum)
		
		tHeroInfo[#tHeroInfo+1] = {heroId = heroId, star = star, debrisNum = debrisNum, debrisTotalNum = debrisTotalNum,}
		
		rIdx = rIdx + 1
	end
	
	--取消挡操作
	hUI.NetDisable(0)

	--通知事件：工会服务器收到查询英雄将魂信息结果
	hGlobal.event:event("LocalEvent_Group_QueryHeroDebrisInfoEvent", tHeroInfo)
end

--收到兑换英雄将魂结果
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_EXCHAGE_HERO_DEBRIS] = function(tCmd)
	local iResult = tonumber(tCmd[1]) --0:失败 / 1:成功
	local tCardList = {}
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--操作成功
	if (iResult == 1) then
		local cardNum = tonumber(tCmd[2]) or 0 --选择的卡片种类总数量
		local rIdx = 2
		for i = 1, cardNum, 1 do
			local tHeroInfo = hApi.Split(tCmd[rIdx+i], ":")
			local heroId = tonumber(tHeroInfo[1]) or 0 --英雄id
			local heroNum = tonumber(tHeroInfo[2]) or 0 --英雄碎片数量
			--print(heroId, heroNum)
			tCardList[#tCardList+1] = {id = heroNum, num = heroNum,}
		end
		
		--奖励信息
		local rewardResult = {}
		local rIdx = 2 + cardNum + 1
		local rewardNum = tonumber(tCmd[rIdx]) or 0 --奖励的数量
		for i = 1, rewardNum, 1 do
			local tReward = hApi.Split(tCmd[rIdx+i], ":")
			local rewardType = tonumber(tReward[1]) or 0 --奖励类型
			local rewardNum = tonumber(tReward[2]) or 0 --奖励数量
			--print(rewardType, rewardNum)
			rewardResult[#rewardResult+1] = {rewardType, rewardNum,}
		end
		
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
	end
	
	--通知事件：工会服务器收到兑换战术卡碎片结果
	hGlobal.event:event("LocalEvent_Group_ExcnageHeroDebirsEvent", iResult, tCardList)
end

--收到军团资源变化后的结果
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_RESOURCE_INFO] = function(tCmd)
	local groupId = tonumber(tCmd[1]) or 0 --军团id
	local iIron = tonumber(tCmd[2]) or 0 --铁
	local iWood = tonumber(tCmd[3]) or 0 --木材
	local iFood = tonumber(tCmd[4]) or 0 --粮食
	
	if (groupId > 0) then
		--通知事件：军团资源变化后的结果
		--print(groupId, iIron, iWood, iFood)
		hGlobal.event:event("LocalEvent_Group_ResourceChangedEvent", groupId, iIron, iWood, iFood)
	end
end

--收到会长购买军团副本次数的结果
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_BUY_BATTLE_COUNT] = function(tCmd)
	local result = tonumber(tCmd[1]) or 0 --结果
	--print(result)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	if (result == 1) then --成功
		local strText = hVar.tab_string["ios_payment_success"] --购买成功
		hGlobal.UI.MsgBox(strText, {
			font = hVar.FONTC,
			ok = function()
				--
			end,
		})
	end
	
	--广播事件: 会长购买军团副本次数结果
	hGlobal.event:event("LocalEvent_GroupBattleCountBuyResult", result)
end

--收到发送军团红包结果
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_SEND_REDPACKET] = function(tCmd)
	local result = tonumber(tCmd[1]) or 0 --结果
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--print("收到发送军团红包结果", result)
	
	if (result == 1) then --操作成功
		local rewardN = tonumber(tCmd[2])
		
		local reward = {}
		local rewardIdx = 3
		
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
							local strInfo = hVar.tab_string["__ITEM_PANEL__PAGE_GROUPREDPACKET"] --"在军团红包中获得"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
			end
			
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
					local strInfo = hVar.tab_string["__ITEM_PANEL__PAGE_GROUPREDPACKET"] --"在军团红包中获得"
					--SendPvpCmdFunc["request_broad_get_tacticcard"](rewardType, tacticId, itemNum, strInfo)
					SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.TACTICCARD_DEBRIS, strInfo, tacticId)
				end
			end
		end
		
		local tag, rewardResult = hApi.GetReawrdGift(reward, rewardN)
		
		--hApi.BubbleGiftAnim(reward, rewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		--SendCmdFunc["update_reward_log"](prizeId)
		--print(tag)
		
		--更新客户端游戏币界面
		SendCmdFunc["gamecoin"]()
	end
	
	--广播事件: 发送军团红包结果
	--hGlobal.event:event("LocalEvent_GroupBattleCountBuyResult", result)
end

--收到领取军团红包结果
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_RECEIVE_REDPACKET] = function(tCmd)
	local result = tonumber(tCmd[1]) or 0 --结果
	--print("收到领取军团红包结果", result)
	
	if (result == 1) then --操作成功
		local orderId = tonumber(tCmd[2]) or 0 --订单id
		local rewardN = tonumber(tCmd[3]) or 0 --奖励数量
		
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
							local strInfo = hVar.tab_string["__ITEM_PANEL__PAGE_GROUPREDPACKET"] --"在军团红包中获得"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
			end
			
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
					local strInfo = hVar.tab_string["__ITEM_PANEL__PAGE_GROUPREDPACKET"] --"在军团红包中获得"
					--SendPvpCmdFunc["request_broad_get_tacticcard"](rewardType, tacticId, itemNum, strInfo)
					SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.TACTICCARD_DEBRIS, strInfo, tacticId)
				end
			end
		end
		
		local tag, rewardResult = hApi.GetReawrdGift(reward, rewardN)
		
		--hApi.BubbleGiftAnim(reward, rewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
		
		--SendCmdFunc["update_reward_log"](prizeId)
		--print(tag)
	end

	--广播事件: 发送军团红包结果
	--hGlobal.event:event("LocalEvent_GroupBattleCountBuyResult", result)
end

--收到领取支付（土豪）红包结果
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_PAY_RECEIVE_REDPACKET] = function(tCmd)
	local result = tonumber(tCmd[1]) or 0 --结果
	--print("收到领取支付（土豪）红包结果", result)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local reward = {} --奖励表
	
	if (result == 1) then --操作成功
		local orderId = tonumber(tCmd[2]) or 0 --订单id
		local rewardN = tonumber(tCmd[3]) or 0 --奖励数量
		
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
							local strInfo = hVar.tab_string["__ITEM_PANEL__PAGE_PAYREDPACKET"] --"在红包中获得"
							SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.RED_EQUIP, strInfo, itemId)
						end
					--end
				end
			end
			
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
					local strInfo = hVar.tab_string["__ITEM_PANEL__PAGE_PAYREDPACKET"] --"在红包中获得"
					--SendPvpCmdFunc["request_broad_get_tacticcard"](rewardType, tacticId, itemNum, strInfo)
					SendCmdFunc["request_bubble_notice"](hVar.BUBBLE_NOTICE_TYPE.TACTICCARD_DEBRIS, strInfo, tacticId)
				end
			end
		end
		
		--领取世界频到红包，上传宝物属性位日志
		local tTreasureAttr = {}
		for i = 1, hVar.TREASURE_ATTR.ATTR_MAXCOUNT, 1 do
			tTreasureAttr[i] = 0
		end
		
		--世界聊天频到抢到红包
		tTreasureAttr[hVar.TREASURE_ATTR.WORLD_CHANNEL_RED_PACKGET_NUM] = 1
		
		--上传宝物属性位值（世界聊天频到抢到红包）
		local sessionId = 0
		local orderId = orderId
		local battleId = 0
		local mapName = hVar.tab_string["__TEXT_MAINUI_BTN_REDPACKET"] --"红包"
		SendCmdFunc["upload_treasure_attr"](sessionId, orderId, battleId, mapName, tTreasureAttr)
		
		--geyachao: 领红包有动画，这里延时播放领奖结果动画，在回调里处理动画
		--[[
		local tag, rewardResult = hApi.GetReawrdGift(reward, rewardN)
		
		--hApi.BubbleGiftAnim(reward, rewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
		--新的动画表现获得奖励
		hApi.PlayChestRewardAnimation(0, rewardResult)
		]]
		
		--SendCmdFunc["update_reward_log"](prizeId)
		--print(tag)
	end
	
	--广播事件: 收到领取支付（土豪）红包结果结果
	hGlobal.event:event("LocalEvent_OnReceivePayRedPacketResult", result, reward)
end

--收到查看支付（土豪）红包的领取详情结果
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_PAY_VIEWDETAIL_REDPACKET] = function(tCmd)
	local result = tonumber(tCmd[1]) or 0 --结果
	--print("收到查看支付（土豪）红包的领取详情结果", result)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	local tSend = {} --红包发送表
	local tReceive = {} --红包领取表
	
	if (result == 1) then --操作成功
		local redPacketParam = tostring(tCmd[2]) --红包信息
		local redPacketParam = hApi.Split(redPacketParam, "|")
		local redPacketId = tonumber(redPacketParam[1]) or 0 --红包唯一id
		local send_uid = tonumber(redPacketParam[2]) or 0 --红包发送者uid
		local send_name = hApi.StringDecodeEmoji(redPacketParam[3]) --红包发送者名字 --解析表情
		local send_num = tonumber(redPacketParam[4]) or 0 --红包发送数量
		local content = hApi.StringDecodeEmoji(redPacketParam[5]) --内容 --解析表情
		local money = tonumber(redPacketParam[6]) or 0 --充值金额
		local iap_id = tonumber(redPacketParam[7]) or 0 --充值记录id
		local channelId = tonumber(redPacketParam[8]) or 0 --渠道号
		local vipLv = tonumber(redPacketParam[9]) or 0 --vip等级
		local borderId = tonumber(redPacketParam[10]) or 0 --边框id
		local iconId = tonumber(redPacketParam[11]) or 0 --头像id
		local championId = tonumber(redPacketParam[12]) or 0 --称号id
		local leaderId = tonumber(redPacketParam[13]) or 0 --会长权限
		local dragonId = tonumber(redPacketParam[14]) or 0 --聊天龙王id
		local headId = tonumber(redPacketParam[15]) or 0 --头衔id
		local lineId = tonumber(redPacketParam[16]) or 0 --线索id
		local msg_id = tonumber(redPacketParam[17]) or 0 --消息id
		local receive_num = tonumber(redPacketParam[18]) or 0 --红包接收数量
		local send_time = tostring(redPacketParam[19]) --红包发送时间
		local expire_time = tostring(redPacketParam[20]) --红包过期时间
		
		tSend.redPacketId = redPacketId
		tSend.send_uid = send_uid
		tSend.send_name = send_name
		tSend.send_num = send_num
		tSend.content = content
		tSend.money = money
		tSend.iap_id = iap_id
		tSend.channelId = channelId
		tSend.vipLv = vipLv
		tSend.borderId = borderId
		tSend.iconId = iconId
		tSend.championId = championId
		tSend.leaderId = leaderId
		tSend.dragonId = dragonId
		tSend.headId = headId
		tSend.lineId = lineId
		tSend.msg_id = msg_id
		tSend.receive_num = receive_num
		tSend.send_time = send_time
		tSend.expire_time = expire_time
		
		--[[
		print("redPacketId=", redPacketId)
		print("send_uid=", send_uid)
		print("send_name=", send_name)
		print("send_num=", send_num)
		print("content=", content)
		print("money=", money)
		print("iap_id=", iap_id)
		print("channelId=", channelId)
		print("vipLv=", vipLv)
		print("borderId=", borderId)
		print("iconId=", iconId)
		print("championId=", championId)
		print("leaderId=", leaderId)
		print("dragonId=", dragonId)
		print("headId=", headId)
		print("lineId=", lineId)
		print("msg_id=", msg_id)
		print("receive_num=", receive_num)
		print("send_time=", send_time)
		print("expire_time=", expire_time)
		]]
		
		local rIdx = 2
		for i = 1, receive_num, 1 do
			local redPacketReceiveId = tonumber(tCmd[rIdx+1]) or 0 --红包接收唯一id
			local redPacketId = tonumber(tCmd[rIdx+2]) or 0 --红包唯一id
			local receive_uid = tonumber(tCmd[rIdx+3]) or 0 --红包接收者uid
			local receive_name = hApi.StringDecodeEmoji(tCmd[rIdx+4]) --红包接收者名字 --解析表情
			local channelId = tonumber(tCmd[rIdx+5]) or 0 --渠道号
			local vipLv = tonumber(tCmd[rIdx+6]) or 0 --vip等级
			local borderId = tonumber(tCmd[rIdx+7]) or 0 --边框id
			local iconId = tonumber(tCmd[rIdx+8]) or 0 --头像id
			local championId = tonumber(tCmd[rIdx+9]) or 0 --称号id
			local leaderId = tonumber(tCmd[rIdx+10]) or 0 --会长权限
			local dragonId = tonumber(tCmd[rIdx+11]) or 0 --聊天龙王id
			local headId = tonumber(tCmd[rIdx+12]) or 0 --头衔id
			local lineId = tonumber(tCmd[rIdx+13]) or 0 --线索id
			local msg_id = tonumber(tCmd[rIdx+14]) or 0 --消息id
			local rewardNum = tonumber(tCmd[rIdx+15]) or 0 --奖励数量
			local strReward = tostring(tCmd[rIdx+16]) --奖励信息
			local receive_time = tostring(tCmd[rIdx+17]) --红包领取时间
			
			--解析奖励
			local reward = {}
			for i = 1, rewardNum do
				local tmp = {}
				local tRInfo = hApi.Split(strReward,":")
				tmp[#tmp + 1] = tonumber(tRInfo[1])				--奖励类型
				tmp[#tmp + 1] = tonumber(tRInfo[2])				--参数1
				tmp[#tmp + 1] = tRInfo[3]				--参数2
				tmp[#tmp + 1] = tRInfo[4]				--参数3
				--print(tRInfo[1],tRInfo[2],tRInfo[3],tRInfo[4])
				reward[#reward + 1] = tmp
				
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
				end
			end
			
			rIdx = rIdx + 17
			
			tReceive[i] = {}
			tReceive[i].redPacketReceiveId = redPacketReceiveId
			tReceive[i].redPacketId = redPacketId
			tReceive[i].receive_uid = receive_uid
			tReceive[i].receive_name = receive_name
			tReceive[i].channelId = channelId
			tReceive[i].vipLv = vipLv
			tReceive[i].borderId = borderId
			tReceive[i].iconId = iconId
			tReceive[i].championId = championId
			tReceive[i].leaderId = leaderId
			tReceive[i].dragonId = dragonId
			tReceive[i].headId = headId
			tReceive[i].lineId = lineId
			tReceive[i].msg_id = msg_id
			tReceive[i].rewardNum = rewardNum
			tReceive[i].reward = reward
			tReceive[i].receive_time = receive_time
			
			--[[
			print("[" .. i .. "]=")
			print("    redPacketReceiveId=", redPacketReceiveId)
			print("    redPacketId=", redPacketId)
			print("    receive_uid=", receive_uid)
			print("    receive_name=", receive_name)
			print("    channelId=", channelId)
			print("    vipLv=", vipLv)
			print("    borderId=", borderId)
			print("    iconId=", iconId)
			print("    championId=", championId)
			print("    leaderId=", leaderId)
			print("    dragonId=", dragonId)
			print("    headId=", headId)
			print("    lineId=", lineId)
			print("    msg_id=", msg_id)
			print("    rewardNum=", rewardNum)
			print("    reward=", strReward)
			print("    receive_time=", receive_time)
			]]
		end
	end
	
	--广播事件: 收到查看支付（土豪）红包的领取详情结果
	hGlobal.event:event("LocalEvent_ViewDetailPayRedPacketResult", result, tSend, tReceive)
end

--收到查询军团军饷任务完成结果
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_MILITARY_TASK_QUERY] = function(tCmd)
	local singleCount =  tonumber(tCmd[1]) or 0	--军团单人副本今日完成次数
	local coupleCount =  tonumber(tCmd[2]) or 0	--军团组队副本今日完成次数
	local rewardFlag =  tonumber(tCmd[3]) or 0	--是否已领取今日军饷
	
	--今日已领取军团军饷，本地标记
	if (rewardFlag == 1) then
		--取现在时间
		local clienttime = os.time()
		local hosttime = clienttime - g_localDeltaTime --(Local = Host + deltaTime)
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
		hosttime = hosttime - delteZone * 3600
		--local tabNow = os.date("*t", hosttime) --北京时区
		
		--设置领取军团军饷的时间
		local strDate = os.date("%Y-%m-%d", hosttime)
		LuaSetGroupMilitaryTakeDate(g_curPlayerName, strDate)
	end
	
	--设置可领取军团军饷的时间
	if (singleCount >= hVar.GROUP_DAYEWARD_SINGLE_BATTLE_COUNT) and (coupleCount >= hVar.GROUP_DAYEWARD_COUPLE_BATTLE_COUNT) then
		local strDate = os.date("%Y-%m-%d", hosttime)
		LuaSetGroupMilitaryRewardDate(g_curPlayerName, strDate)
	end
	
	--触发事件：获得玩家军团军饷任务完成状态信息
	hGlobal.event:event("LocalEvent_GetGroupMilitaryTaskState", singleCount, coupleCount, rewardFlag)
end

--收到领取军团军饷任务结果
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_MILITARY_TASK_TAKEREWARD] = function(tCmd)
	local result =  tonumber(tCmd[1]) or 0		--结果
	local singleCount =  tonumber(tCmd[2]) or 0	--军团单人副本今日完成次数
	local coupleCount =  tonumber(tCmd[3]) or 0	--军团组队副本今日完成次数
	local rewardFlag =  tonumber(tCmd[4]) or 0	--是否已领取今日军饷
	local iCoin =  tonumber(tCmd[5]) or 0		--领取的游戏币
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--动画表现获得游戏币
	if (result == 1) then
		--动画打开宝箱奖励播放（类似葫芦娃的动画效果）
		local rewardResult = {}
		rewardResult[#rewardResult+1] = {7, iCoin, 0,}
		hApi.PlayChestRewardAnimation(0, rewardResult)
	end
	
	--今日已领取军团军饷，本地标记
	if (rewardFlag == 1) then
		--取现在时间
		local clienttime = os.time()
		local hosttime = clienttime - g_localDeltaTime --(Local = Host + deltaTime)
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
		hosttime = hosttime - delteZone * 3600
		--local tabNow = os.date("*t", hosttime) --北京时区
		
		--设置领取军团军饷的时间
		local strDate = os.date("%Y-%m-%d", hosttime)
		LuaSetGroupMilitaryTakeDate(g_curPlayerName, strDate)
	end
	
	--设置可领取军团军饷的时间
	if (singleCount >= hVar.GROUP_DAYEWARD_SINGLE_BATTLE_COUNT) and (coupleCount >= hVar.GROUP_DAYEWARD_COUPLE_BATTLE_COUNT) then
		local strDate = os.date("%Y-%m-%d", hosttime)
		LuaSetGroupMilitaryRewardDate(g_curPlayerName, strDate)
	end
	
	--触发事件：获得玩家领取军团军饷结果返回
	hGlobal.event:event("LocalEvent_TakeGroupMilitaryTaskRet", result, singleCount, coupleCount, rewardFlag, iCoin)
end

--收到踢出长期不在线的其他军团的玩家结果（仅管理员可操作）
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_KICK_OFFLINE_PLAYER] = function(tCmd)
	local result = tonumber(tCmd[1]) or 0 --结果
	--print("收到踢出长期不在线的其他军团的玩家结果（仅管理员可操作）", result)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--操作成功
	if (result == 1) then
		--"操作成功"
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_DoSuccess"],{
			font = hVar.FONTC,
			ok = function()
				hGlobal.event:event("localEvent_UpdateGuildMember")
			end,
		})
	end
end

--收到任命玩家为会长结果（仅管理员可操作）
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_ASSET_ADMIN_PLAYER] = function(tCmd)
	local result = tonumber(tCmd[1]) or 0 --结果
	--print("收到任命玩家为会长结果（仅管理员可操作）", result)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--操作成功
	if (result == 1) then
		--"操作成功"
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_DoSuccess"],{
			font = hVar.FONTC,
			ok = function()
				hGlobal.event:event("localEvent_UpdateGuildMember")
			end,
		})
	end
end

--收到军团转让结果
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_TRANSFER] = function(tCmd)
	local result = tonumber(tCmd[1]) or 0 --结果
	local groupId = tonumber(tCmd[2]) or 0 --军团id
	local adminUID = tonumber(tCmd[3]) or 0 --原会长uid
	local assistUID = tonumber(tCmd[4]) or 0 --原助理uid
	local adminName =  hApi.StringDecodeEmoji(tCmd[5]) --新会长名字 --解析表情
	--print("收到军团转让结果", result)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--操作成功
	if (result == 1) then
		--"操作成功"
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_DoSuccess"],{
			font = hVar.FONTC,
			ok = function()
				hGlobal.event:event("localEvent_UpdateGuildMember")
				hGlobal.event:event("localEvent_GroupTranserRet", groupId, adminUID, assistUID, adminName)
			end,
		})
		
		--播放音效
		hApi.PlaySound("magic12")
	end
end

--收到军团解散结果（仅管理员可操作）
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_DISOLUTE] = function(tCmd)
	local result = tonumber(tCmd[1]) or 0 --结果
	--print("收到军团解散结果", result)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--操作成功
	if (result == 1) then
		--"操作成功"
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_DISBAND_SUCCESS"],{
			font = hVar.FONTC,
			ok = function()
				hGlobal.event:event("CloseLegionMemberFrm")
			end,
		})
	end
end

--收到创建军团邀请函结果
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_INVITE_CREATE] = function(tCmd)
	local result = tonumber(tCmd[1]) or 0 --结果
	--print("收到创建军团邀请函结果", result)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--操作成功
	if (result == 1) then
		--"操作成功"
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_DoSuccess"],{
			font = hVar.FONTC,
			ok = function()
				--触发事件：创建军团邀请函成功
				hGlobal.event:event("LocalEvent_GroupInviteCreateSuccess")
			end,
		})
	end
end

--收到加入军团邀请函结果
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_INVITE_JOIN] = function(tCmd)
	local result = tonumber(tCmd[1]) or 0 --结果
	local inviteGroupId = tonumber(tCmd[2]) or 0 --军团邀请函id
	local msgId = tonumber(tCmd[3]) or 0 --消息id
	local groupId = tonumber(tCmd[4]) or 0 --军团id
	local groupLv = tonumber(tCmd[5]) or 0 --军团职务
	--print("收到加入军团邀请函结果", result, inviteGroupId, msgId, groupId, groupLv)
	
	--取消挡操作
	hUI.NetDisable(0)
	
	--触发事件：收到加入军团邀请函结果返回
	hGlobal.event:event("localEvent_GroupInviteJoinBack", result, inviteGroupId, msgId, groupId, groupLv)
end
















------------------------------------------------------------------------------------------------------------
--新手营
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_LIST] = function(sCmd)
	print("hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_LIST")
	local t = Cmd2Table(sCmd)

	if type(t) ~= "table" then print("ERROR L2C_NOVICECAMP_LIST") return end
	if t.err == 0 then
		hGlobal.event:event("LocalEvent_Group_LegionListEvent",t.data)
		--hGlobal.event:event("LocalEvent_GetGuildData","Guild_List",t.data)
	else
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		print("ERROR L2C_NOVICECAMP_LIST",t.err)
	end
	--取消挡操作
	hUI.NetDisable(0)
end

--返回申请加入军团请求军团列表
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_LIST_JOIN] = function(sCmd)
	print("hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_LIST_JOIN")
	local t = Cmd2Table(sCmd)

	if type(t) ~= "table" then print("ERROR L2C_NOVICECAMP_LIST_JOIN") return end
	if t.err == 0 then
		hGlobal.event:event("LocalEvent_Group_LegionListJoinEvent",t.data)
		--hGlobal.event:event("LocalEvent_GetGuildData","Guild_List",t.data)
	else
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		print("ERROR L2C_NOVICECAMP_LIST_JOIN",t.err)
	end
	--取消挡操作
	hUI.NetDisable(0)
end

GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_POWER_JION_REQUEST] = function(sCmd)
	print("L2C_POWER_JION_REQUEST")
	local t = Cmd2Table(sCmd)
	
	table_print(t)
	if t.err == 0 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_JoinSuccess"],{
			font = hVar.FONTC,
			ok = function()
			end,
		})
		--hGlobal.event:event("LocalEvent_ShowGuildFrm")
		hGlobal.event:event("LocalEvent_UpdateJoinLegionState",1,t.ncid,t.last_ncid)
	elseif t.err == 102 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_CanNotJoinAgain"],{
			font = hVar.FONTC,
			ok = function()
			end,
		})
	elseif t.err == 103 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_JoinError103"],{
			font = hVar.FONTC,
			ok = function()
			end,
		})
	elseif t.err == 104 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_2017NotJoin"],{
			font = hVar.FONTC,
			ok = function()
			end,
		})
	elseif t.err == 105 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_JoinError105"],{
			font = hVar.FONTC,
			ok = function()
			end,
		})
	else 
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		print("ERROR L2C_POWER_JION_REQUEST",t.err)
	end
	--取消挡操作
	hUI.NetDisable(0)
	--hGlobal.event:event("localEvent_UpdateGuildMember")
end

GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_CREATE] = function(sCmd)
	print("L2C_NOVICECAMP_CREATE")
	local t = Cmd2Table(sCmd)
	
	table_print(t)
	if t.err == 0 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_CreateSuccess"],{
			font = hVar.FONTC,
			ok = function()
				--进入军团地图界面
				--hGlobal.event:event("LocalEvent_CloseLegion")
				hGlobal.event:event("CloseLegionFrm")
				hGlobal.event:event("LocalEvent_EnterLegion",1)
			end,
		})
		

	elseif t.err == 102 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_HasJoinedOneGuild"],{
			font = hVar.FONTC,
			ok = function()
			end,
		})
	elseif  t.err == 103 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_not_enough_money"],{
			font = hVar.FONTC,
			ok = function()
			end,
		})
	else 
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		print("ERROR L2C_NOVICECAMP_CREATE",t.err)
	end

	--取消挡操作
	hUI.NetDisable(0)
	--hGlobal.event:event("LocalEvent_ShowCreateGuildFrm",0)
	hGlobal.event:event("LocalEvent_CloseCreateLegionFrm")
end

--解散军团
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_REMOVE] = function(sCmd)
	print("L2C_NOVICECAMP_REMOVE")
	local t = Cmd2Table(sCmd)
	if t.err == 0 then
		--"解散成功"
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_DISBAND_SUCCESS"],{
			font = hVar.FONTC,
			ok = function()
				hGlobal.event:event("CloseLegionMemberFrm")
				hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
				hGlobal.event:event("LocalEvent_OpenPhoneMainMenu_new",1)
			end,
		})
	else
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		print("ERROR L2C_NOVICECAMP_REMOVE",t.err)
	end
	--取消挡操作
	hUI.NetDisable(0)
end


GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_MEMBER_LIST] = function(sCmd)
	print("L2C_MEMBER_LIST")
	local t = Cmd2Table(sCmd)

	if t.err == 0 then
		--table_print(t.data)
		--hGlobal.event:event("LocalEvent_GetGuildData","Guild_Member",t.data)
		hGlobal.event:event("LocalEvent_Group_LegionInfoEvent",t.data)
	else 
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		print("ERROR L2C_GET_GUILD_MEMBER_LIST_RES",t.err)
	end
	--取消挡操作
	hUI.NetDisable(0)
end

--通过申请的返回
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_POWER_JION_ACCEPT] = function(sCmd)
	print("L2C_POWER_JION_ACCEPT")
	local t = Cmd2Table(sCmd)
	if t.err == 0 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_DoSuccess_Accept"],{
			font = hVar.FONTC,
			ok = function()
				hGlobal.event:event("localEvent_UpdateGuildMember")
			end,
		})
		--hGlobal.event:event("localEvent_UpdateGuildMember")
	elseif t.err == 105 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_JoinError105"],{
			font = hVar.FONTC,
			ok = function()
			end,
		})
	else 
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		print("ERROR L2C_POWER_JION_ACCEPT",t.err)
	end
	--取消挡操作
	hUI.NetDisable(0)
end

--修改新手营介绍的返回
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_UPDATE] = function(sCmd)
	print("L2C_NOVICECAMP_UPDATE")
	local t = Cmd2Table(sCmd)
	table_print(t)
	if t.err == 0 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ChangeDesc_Success"],{
			font = hVar.FONTC,
			ok = function()
				hGlobal.event:event("LocalEvent_ChangeGuildDescripe",t.data.ncid,t.data.descripe)
			end,
		})
	else 
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		print("ERROR L2C_NOVICECAMP_UPDATE",t.err)
	end
	--取消挡操作
	hUI.NetDisable(0)
end

--踢人的返回
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_POWER_FIRE] = function(sCmd)
	print("L2C_POWER_FIRE")
	local t = Cmd2Table(sCmd)
	--table_print(t)
	if t.err == 0 then
		--是否需要提示操作者此玩家是活跃玩家
		local noticeActive = t.noticeActive or 0
		if (noticeActive == 1) then
			--"该成员最近24小时内有贡献度，是活跃玩家，你确定继续移除该成员吗？"
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_Kickout_Notice_ActivePlayer"],{
				font = hVar.FONTC,
				ok = function()
					--剔除活跃玩家
					local noticeActive = 1
					SendGroupCmdFunc["guild_kick_player"](t.ncid,t.uid_member,noticeActive)
				end,
				
				cancel = function()
					--
				end
			})
		else
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_Kickout_Success"],{
				font = hVar.FONTC,
				ok = function()
					hGlobal.event:event("localEvent_UpdateGuildMember")
				end,
			})
		end
	--不能剔除活跃用户
	elseif t.err == 105 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_Kickout_Fail"],{
			font = hVar.FONTC,
			ok = function()
			end,
		})
	elseif t.err == 104 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_Kickout_Fail_State"],{
			font = hVar.FONTC,
			ok = function()
			end,
		})
	else
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		print("ERROR L2C_POWER_FIRE",t.err)
	end
	--hGlobal.event:event("localEvent_UpdateGuildMember")
	--取消挡操作
	hUI.NetDisable(0)
end

--获取奖励信息的返回
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_CONFIG_PRIZE] = function(sCmd)
	print("L2C_CONFIG_PRIZE")
	local t = Cmd2Table(sCmd)
	if t.err == 0 then
		table_print(t.data)
		--hGlobal.event:event("LocalEvent_GetGuildRewardInfo",t.data)
	else 
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		print("ERROR L2C_CONFIG_PRIZE",t.err)
	end
	--取消挡操作
	hUI.NetDisable(0)
end

--取消申请的返回
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_POWER_JION_CANCEL] = function(sCmd)
	print("L2C_POWER_JION_CANCEL")
	local t = Cmd2Table(sCmd)
	if t.err == 0 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_JoinCancel"],{
			font = hVar.FONTC,
			ok = function()
			end,
		})
		hGlobal.event:event("LocalEvent_UpdateJoinLegionState",0,t.ncid,t.last_ncid)
		--hGlobal.event:event("LocalEvent_ShowGuildFrm")
	elseif t.err == 100 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_JoinCance2"],{
			font = hVar.FONTC,
			ok = function()
			end,
		})
		--hGlobal.event:event("LocalEvent_ShowGuildFrm")
	else 
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		print("ERROR L2C_POWER_JION_CANCEL",t.err)
	end
	--取消挡操作
	hUI.NetDisable(0)
end

--拒接申请的返回
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_POWER_JION_REJECT] = function(sCmd)
	print("L2C_POWER_JION_REJECT")
	local t = Cmd2Table(sCmd)
	if t.err == 0 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_DoSuccess_Reject"],{
			font = hVar.FONTC,
			ok = function()
				hGlobal.event:event("localEvent_UpdateGuildMember")
			end,
		})
		--hGlobal.event:event("localEvent_UpdateGuildMember")
	else 
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		print("ERROR L2C_POWER_JION_REJECT",t.err)
	end
	--取消挡操作
	hUI.NetDisable(0)
end

--修改公会名字的返回
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_RENAME] = function(sCmd)
	print("L2C_NOVICECAMP_RENAME")
	local t = Cmd2Table(sCmd)
	--table_print(t)
	if t.err == 0 then
		--播放音效
		hApi.PlaySound("pay_gold")
		
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_ChangeDesc_Success"],{
			font = hVar.FONTC,
			ok = function()
				hGlobal.event:event("LocalEvent_ChangeGuildName", t.data.ncid, t.data.name)
			end,
		})
	elseif t.err == 103 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_not_enough_money"],{
			font = hVar.FONTC,
			ok = function()
			end,
		})
	else 
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		
		print("ERROR L2C_NOVICECAMP_RENAME",t.err)
	end
	--取消挡操作
	hUI.NetDisable(0)
end

--返回建筑升级结果
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_BUILDING_UPGRADE] = function(sCmd)
	print("L2C_BUILDING_UPGRADE")
	print("sCmd",sCmd)
	local t = Cmd2Table(sCmd)
	if t.err == 0 then
		local bid = t.bid
		local blv = t.blv
		local niron = t.iron
		local nwood = t.wood
		local nfood = t.food
		--调用接口 更新升级信息
		hGlobal.event:event("LocalEvent_Group_UpgradeLegionBuild",bid,blv,niron,nwood,nfood)
	else
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		print("ERROR L2C_BUILDING_UPGRADE",t.err)
	end
	--取消挡操作
	hUI.NetDisable(0)
end

--返回建筑奖励
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_BUILDING_PRIZE] = function(sCmd)
	print("L2C_BUILDING_PRIZE")
	print("sCmd",sCmd)
	local t = Cmd2Table(sCmd)
	if t.err == 0 then
		local bid = t.bid
		local blv = t.blv
		hGlobal.event:event("LocalEvent_Group_GetLegionBuildPrize",bid,blv)
	else
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		print("ERROR L2C_BUILDING_PRIZE",t.err)
	end
	--取消挡操作
	hUI.NetDisable(0)
end

--退出工会结果
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_POWER_QUIT] = function(sCmd)
	print("L2C_POWER_QUIT")
	print("sCmd",sCmd)
	local t = Cmd2Table(sCmd)
	if t.err == 0 then
		--"操作成功"
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_DoSuccess"],{
			font = hVar.FONTC,
			ok = function()
				--hGlobal.event:event("LocalEvent_CloseLegion")
				hGlobal.event:event("CloseLegionMemberFrm")
				hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
				hGlobal.event:event("LocalEvent_OpenPhoneMainMenu_new",1)
			end,
		})
	else
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		print("ERROR L2C_POWER_QUIT",t.err)
	end
	--取消挡操作
	hUI.NetDisable(0)
end


GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_CARD_UPGRADE] = function(sCmd)
	print("L2C_CARD_UPGRADE")
	print("sCmd",sCmd)
	local t = Cmd2Table(sCmd)
	if t.err == 0 then
		local bid = t.bid
		local blv = t.blv
		local clv = t.clv
		local str = ""
		if clv == 1 then
			str = hVar.tab_string["__UNLOCK"]..hVar.tab_string["__TEXT_SUCCESSED"]
		else
			str = hVar.tab_string["__UPGRADE"]..hVar.tab_string["__TEXT_SUCCESSED"]
		end
		hUI.floatNumber:new({
			text = "",
			font = "numRed",
			moveY = 64,
		}):addtext(str,hVar.FONTC,26,"MC",hVar.SCREEN.w/2, hVar.SCREEN.h/2,nil,1):setColor(ccc3(255,255,255))
		hGlobal.event:event("LocalEvent_Group_UpgradeLegionTactics",bid,blv,clv)
		local niron = t.iron
		local nwood = t.wood
		local nfood = t.food
		--调用接口 更新升级信息
		hGlobal.event:event("LocalEvent_Group_UpgradeLegionBuild",bid,blv,niron,nwood,nfood)
	else
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		print("ERROR L2C_CARD_UPGRADE",t.err)
	end
	--取消挡操作
	hUI.NetDisable(0)
end

--会长任命助理的结果
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_POWER_ASSISTANT_APPOINT] = function(sCmd)
	print("L2C_POWER_ASSISTANT_APPOINT")
	local t = Cmd2Table(sCmd)
	if t.err == 0 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Assistant_Success"],{
			font = hVar.FONTC,
			ok = function()
				--更新成员列表
				hGlobal.event:event("localEvent_UpdateGuildMember")
			end,
		})
	else 
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		print("ERROR L2C_POWER_ASSISTANT_APPOINT",t.err)
	end
	
	--取消挡操作
	hUI.NetDisable(0)
end

--会长取消任命助理的结果
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_POWER_ASSISTANT_DISAPPOINT] = function(sCmd)
	print("L2C_POWER_ASSISTANT_DISAPPOINT")
	local t = Cmd2Table(sCmd)
	if t.err == 0 then
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Assistant_Cancel_Success"],{
			font = hVar.FONTC,
			ok = function()
				--更新成员列表
				hGlobal.event:event("localEvent_UpdateGuildMember")
			end,
		})
	else 
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		print("ERROR L2C_POWER_ASSISTANT_DISAPPOINT",t.err)
	end
	
	--取消挡操作
	hUI.NetDisable(0)
end

--收到查找军团列表结果返回
GroupLuaNetCmd[hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_SEARCH_RET] = function(sCmd)
	print("hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_SEARCH_RET")
	local t = Cmd2Table(sCmd)
	
	if type(t) ~= "table" then print("ERROR L2C_NOTICE_GROUP_SEARCH_RET") return end
	if t.err == 0 then
		hGlobal.event:event("LocalEvent_Group_LegionListJoinEvent",t.data)
		--hGlobal.event:event("LocalEvent_GetGuildData","Guild_List",t.data)
	else
		--hGlobal.UI.MsgBox("ERRORCODE:"..tostring(t.err),{
			--ok = function()
			--end,
		--})
		print("ERROR L2C_NOTICE_GROUP_SEARCH_RET",t.err)
	end
	--取消挡操作
	hUI.NetDisable(0)
end