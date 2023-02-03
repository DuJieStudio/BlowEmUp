--网络协议define
hVar.PVP_OPR_TYPE = {
	
	--1~99,系统消息
	C2L_REQUIRE_HEART		= 1,				--心跳包
	C2L_REQUIRE_DEBUG		= 2,				--GM_Debug
	
	--PVP房间系统
	C2L_REQUIRE_REFRESH_ROOM_LIST	= 100,				--获取房间列表1
	C2L_REQUIRE_ROOMS_ABSTRACT	= 101,				--获取房间摘要1
	C2L_REQUIRE_CREATE_ROOM		= 102,				--创建房间1
	C2L_REQUIRE_ENTER_ROOM		= 103,				--进入房间1
	C2L_REQUIRE_LEAVE_ROOM		= 104,				--离开房间1
	C2L_REQUIRE_PREPARE_GAME	= 105,				--房间中准备1
	C2L_REQUIRE_BEGIN_GAME		= 106,				--房主开始游戏
	C2L_REQUIRE_CHANGE_POS		= 107,				--房间中换位子
	C2L_REQUIRE_CHANGE_POS_TYPE	= 108,				--房间中修改当前位置的类型
	C2L_REQUIRE_LOAD_GAME		= 109,				--客户端开始加载游戏
	C2L_REQUIRE_LOAD_GAME_END	= 110,				--客户端加载游戏结束
	C2L_REQUIRE_SEND_CMD		= 111,				--游戏操作指令
	C2L_REQUIRE_GAME_END		= 112,				--客户端游戏结束
	C2L_REQUIRE_UPLOAD_BATTLE_CFG	= 113,				--更新战斗配置
	C2L_REQUIRE_GET_BATTLE_CFG	= 114,				--获取战斗配置
	C2L_REQUIRE_LEAVE_GAME		= 115,				--玩家主动离开游戏
	--C2L_REQUIRE_GET_BATTLE_SCORE	= 116,				--获取战绩信息
	C2L_REQUIRE_GET_DELAY_IN_ROOM	= 117,				--获取房间中玩家网络延迟
	C2L_REQUIRE_CHANGE_EQUIP_FLAG	= 118,				--修改房间是否使用装备
	C2L_REQUIRE_PVPCOIN_COST_OK	= 119,				--游戏局中兵符消耗确认
	C2L_REQUIRE_GET_PVPCOIN_EVERYDAY = 120,				--每天领取兵符
	C2L_REQUIRE_UPLOAD_OUTSYNC_LOG	= 121,				--上传不同步日志
	C2L_REQUIRE_USER_BASEINFO	= 122,				--获取玩家基本信息
	C2L_REQUIRE_REWARD_PVP_CHEST	= 123,				--获取竞技场宝箱
	C2L_REQUIRE_OPEN_PVP_CHEST	= 124,				--打开竞技场宝箱
	C2L_REQUIRE_HERO_STAR_LVUP	= 125,				--英雄升星
	C2L_REQUIRE_UPLOAD_BATTLE_INFO	= 126,				--提交战斗英雄，塔，兵种卡使用情况
	C2L_REQUIRE_GET_BATTLE_STATISTICS= 127,				--获取战斗英雄，塔，兵种卡使用情况
	C2L_REQUIRE_ARMY_LVUP		= 128,				--兵种卡升级
	--自动匹配
	C2L_REQUIRE_REFRESH_MATCH_LIST =  129,				--获取匹配房间列表1
	C2L_REQUIRE_BEGIN_MATCH		= 130,				--开始匹配
	C2L_REQUIRE_CANCEL_MATCH	= 131,				--取消匹配
	
	C2L_REQUIRE_HERO_UNLOCK		= 132,				--英雄解锁
	C2L_REQUIRE_BUY_PVPCOIN		= 133,				--购买兵符
	
	C2L_REQUIRE_REFRESH_DBINFO	= 134,				--告诉服务器需要刷新数据
	
	C2L_REQUIRE_ARMY_REFRESH_ADDONES= 135,				--刷新战术卡附加属性
	C2L_REQUIRE_ARMY_NEW_ADDONES	= 136,				--新增战术卡附加属性
	C2L_REQUIRE_ARMY_RESTORE_ADDONES= 137,				--还原战术卡附加属性
	
	C2L_REQUIRE_ROOM_OPEN_TIME	= 138,				--获取当前房间开放时间段

	C2L_REQUIRE_GET_PVE_MULTI_CFG	= 139,				--获取铜雀台配置信息
	C2L_REQUIRE_GET_PVE_MULTI_LOG	= 140,				--获取铜雀台玩家战绩排行
}

hVar.PVP_RECV_TYPE = {
	--1~99,系统消息
	L2C_NOTICE_PLAYER_LOGIN		= 1,				--玩家登陆1
	L2C_NOTICE_PING			= 2,				--ping协议
	L2C_NOTICE_ERROR		= 98,				--错误事件1
	L2C_NOTICE_ROOM_EVENT		= 99,				--房间事件消息1
	
	--PVP房间系统
	L2C_REQUEST_ROOM_LIST		= 100,				--房间列表返回1
	L2C_REQUEST_ROOMS_ABSTRACT	= 101,				--房间摘要返回1
	L2C_REQUEST_ROOMINFO		= 102,				--房间信息1
	L2C_NOTICE_LEAVE_ROOM		= 103,				--离开房间1
	L2C_NOTICE_SWITCH_GAME		= 104,				--通知客户端切换进游戏1
	L2C_NOTICE_PLAYER_BATTLE_INFO	= 105,				--通知客户端当前玩家对战信息
	L2C_NOTICE_GAME_START		= 106,				--游戏开始
	L2C_NOTICE_GAME_SYNC_CMD	= 107,				--同步客户端指令
	L2C_REQUEST_BATTLE_CFG		= 108,				--更新战斗配置返回
	L2C_NOTICE_GAME_PLAYER_DELAY	= 109,				--游戏局中玩家延迟
	--L2C_REQUEST_BATTLE_SCORE	= 110,				--获取战绩信息返回
	L2C_NOTICE_ROOM_CHANGE		= 111,				--通知房间信息变更（大厅中的玩家才会收到消息）
	L2C_NOTICE_USER_BASEINFO	= 112,				--通知玩家基本信息
	L2C_NOTICE_OUTSYNC_LOG_STATE	= 113,				--通知客户端不同步日志更新状态
	L2C_NOTICE_EVALUATE_STATE	= 114,				--通知客户端游戏局获得评价
	L2C_NOTICE_REWARD_FROM_PVPCHEST = 115,				--通知客户端竞技场宝箱开出的物品
	L2C_NOTICE_HERO_STAR_LVUP	= 116,				--通知客户端英雄升星成功
	L2C_NOTICE_BATTLE_STATISTICS	= 117,				--通知客户端当前战斗配置统计数据
	L2C_NOTICE_ARMY_LVUP		= 118,				--通知客户端兵种卡升级成功
	
	--自动匹配
	L2C_REQUEST_MATCH_LIST		= 119,				--匹配房间列表返回
	L2C_NOTICE_MATCHUSER_INFO	= 120,				--玩家匹配信息返回
	L2C_REQUEST_CANCEL_MATCH	= 121,				--取消匹配成功返回
	
	--擂台赛
	L2C_NOTICE_ARENA_CREATEROOM_INFO= 122,				--广播创建房间信息
	L2C_NOTICE_ARENA_RESULT_INFO	= 123,				--广播游戏结果信息
	
	L2C_NOTICE_HERO_UNLOCK		= 124,				--通知客户端英雄解锁成功
	
	L2C_NOTICE_ARMY_REFRESH_ADDONES	= 125,				--通知刷新战术卡附加属性成功
	L2C_NOTICE_ARMY_NEW_ADDONES	= 126,				--通知新增战术卡附加属性成功
	L2C_NOTICE_ARMY_RESTORE_ADDONES	= 127,				--通知还原战术卡附加属性成功
	
	L2C_REQUEST_ROOM_OPEN_TIME	= 128,				--获取当前房间开放时间段

	L2C_REQUEST_GET_PVE_MULTI_CFG	= 129,				--获取铜雀台配置信息返回
	L2C_NOTICE_PVEMULTI_REWARD	= 130,				--通知铜雀台获得的奖励
	L2C_REQUEST_GET_PVE_MULTI_LOG	= 131,				--获取铜雀台玩家战绩排行返回
}


hVar.NETERR = 
{
	UNKNOW_ERROR = 0,				--未知错误
	LOGIN_PLAYER_EXEIST = 1,			--玩家已存在
	LOGIN_PLAYER_FULL = 2,				--玩家已满

	ROOM_GETLIST_FAILD = 3,				--获取房间列表失败
	ROOM_GETABSTRACT_FAILD = 4,			--获取房间摘要失败
	ROOM_CREATE_FAILD = 5,				--创建房间失败
	ROOM_ENTER_FAILD = 6,				--进入房间失败
	ROOM_LEAVE_FAILD = 7,				--离开房间失败
	ROOM_PREPARE_FAILD = 8,				--游戏准备失败
	ROOM_BEGIN_FAILD_1 = 9,				--房主才能开始游戏
	ROOM_BEGIN_FAILD_2 = 10,			--玩家未准备
	ROOM_BEGIN_FAILD_3 = 11,			--创建游戏局失败
	ROOM_CHANGE_POSTYPE_FAILD = 12,			--修改位置类型失败
	ROOM_CHANGE_EQUIP_FLAG_FAILD = 13,		--修改房间是否可带装备属性失败

	ROOM_POSTYPE_ONLY_RM_OP = 14,			--房主才能操作
	ROOM_POSTYPE_INVALID_TYPE = 15,			--非法的位置类型
	ROOM_POSTYPE_ONLY_COMPUTER = 16,		--该位置只允许设置成电脑
	ROOM_POSTYPE_ONLY_OTHER = 17,			--房主不能操作自己
	ROOM_POSTYPE_INVALID_FORCE = 18,		--非法的势力
	ROOM_POSTYPE_INVALID_POS = 19,			--非法的位置
	ROOM_POSTYPE_INVALID_ROOM = 20,			--房间不存在

	GAME_ENTER_NO_SESSION = 21,			--切换游戏过程中游戏局不存在
	GAME_ENTER_NO_PLAYER = 22,			--切换游戏过程中玩家不在游戏局中

	HALL_UPLOAD_BATTLE_CFG_FAILD = 23,		--更新战斗配置失败
	HALL_GET_BATTLE_CFG_FAILD = 24,			--玩家不存在或不在大厅,更新(获取)战斗配置失败
	--HALL_GET_BATTLE_SCORE_FAILD = 25,		--获取战绩信息失败

	GAME_RESULT_SESSION_INVALID = 26,		--游戏局异常（时间时长不足等）
	GAME_RESULT_SCORE_INVALID = 27,			--游戏玩家上传积分不一致
	GAME_RESULT_PLAYER_ERROR = 28,			--玩家掉线或离开异常

	GET_PVPCOIN_EVERYDAY_FAILD = 29,		--每日领取兵符失败

	HALL_GET_USER_BASEINFO_FAILD = 30,		--获取玩家基本信息失败
	HALL_REWARD_PVPCHEST_FAILD = 31,		--兑换竞技场宝箱失败
	HALL_OPEN_PVPCHEST_FAILD = 32,			--打开竞技场宝箱失败

	ROOM_ESCAPE_PUNISH_ERROR = 33,			--逃跑3次以上，无法进入竞技场
	HALL_HERO_STARLVUP_FAILD = 34,			--英雄升星失败
	HALL_ARMY_LVUP_FAILD = 35,			--兵种卡升级失败

	MATCH_GETLIST_FAILD = 36,			--获取匹配房间列表失败
	MATCH_ENTER_FAILD = 37,				--进入匹配房间失败
	MATCH_CANCEL_FAILD = 38,			--取消匹配失败
	MATCH_BEGINGAME_FAILD = 39,			--进入匹配游戏局失败

	ROOM_CLOSED_NOW = 40,				--当前时间暂未开放

	MATCH_OVER_TIME = 41,				--匹配超时

	RELOGIN_ERR_NOT_IN_GAME = 42,			--无法重连玩家已不在游戏局中
	RELOGIN_ERR_GAME_END = 43,			--无法重连游戏局已经结束

	HALL_HERO_UNLOCK_FAILD = 44,			--英雄解锁失败
	GET_BUY_PVPCOIN_FAILD = 45,			--购买兵符失败

	HALL_ARMY_REFRESH_ADDONES_FAILD = 46,		--刷新战术卡附加属性失败
	HALL_ARMY_NEW_ADDONES_FAILD = 47,		--新增战术卡附加属性失败
	HALL_ARMY_RESTORE_ADDONES_FAILD = 48,		--还原战术卡附加属性失败
}

--网络协议接收处理
PluaNetCmd = {}
--收到消息的总入口
--LuaOnNetPack = function(NetPack)
function LuaOnNetPack(NetPack)
	local protocolId = NetPack[1]
	--程序的约定,服务器脚本协议协议号为66666
	if protocolId and protocolId == 66666 then
		--从第二位开始去协议ID
		local typeID = NetPack[2]
		local param1 = NetPack[3]
		local param2 = NetPack[4]
		local data = NetPack[5]
		--print("LuaOnNetPack typeid:" .. tostring(typeID))
		if typeID and data and type(data) == "string" and type(PluaNetCmd[typeID]) == "function" then
			--local netData = {}
			--for i = 3,#NetPack do
			--	netData[#netData+1] = NetPack[i]
			--end
			--脚本协议数据,第三位为字符串.
			local tCmd = hApi.Split(data, ";")
			PluaNetCmd[typeID](tCmd)
		end
	else
		print("LuaOnNetPack unknown potocolId:", protocolId)
	end
end

--房间列表返回
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_REQUEST_ROOM_LIST] = function(tCmd)
	local roomNum = tCmd[1]
	local roomIdList = {}
	local roomStateList = {}
	for i = 1, roomNum do
		local roomTitle = tCmd[1 + i]
		local tRoomTitle = hApi.Split(roomTitle,":")
		local roomId = tonumber(tRoomTitle[1]) or 0
		local roomState = 1	--1 初始化 2 启动游戏中 3正在游戏
		if tRoomTitle[2] and (tRoomTitle[2] ~= "" or tRoomTitle[2] ~= "nil" )then
			roomState = tonumber(tRoomTitle[2])
		end
		roomIdList[#roomIdList + 1] = roomId
		roomStateList[#roomStateList + 1] = roomState
		
		--print("roomIdList:", roomId, roomState)
	end
	hGlobal.event:event("LocalEvent_Pvp_RoomList", roomIdList, roomStateList)
end

--房间摘要返回
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_REQUEST_ROOMS_ABSTRACT] = function(tCmd)
	local roomNum = tCmd[1]
	local roomAbstractList = {}
	for i = 1, roomNum do
		local roomAbstract = {}
		local idx = 1 + (i - 1) * 16
		roomAbstract.id				= tonumber(tCmd[idx + 1])		--房间id
		roomAbstract.cfgId			= tonumber(tCmd[idx + 2])		--房间地图配置索引
		roomAbstract.name			= tCmd[idx + 3]				--房间名
		roomAbstract.rm				= tonumber(tCmd[idx + 4])		--房主
		roomAbstract.mapName			= tCmd[idx + 5]				--房间地图名
		roomAbstract.mapInfo			= tCmd[idx + 6]				--房主地图信息
		roomAbstract.mapKey			= tCmd[idx + 7]				--地图键值
		roomAbstract.state			= tonumber(tCmd[idx + 8])		--房主状态(未开始，正在游戏)
		roomAbstract.bUseEquip			= false					--是否携带装备
		if tonumber(tCmd[idx + 9]) == 1 then
			roomAbstract.bUseEquip = true						--是否携带装备
		end
		roomAbstract.bIsArena			= false					--是否擂台
		if (tonumber(tCmd[idx + 10]) == 1) then
			roomAbstract.bIsArena = true						--是否擂台
		end
		roomAbstract.bIsPveMulti		= false					--是否铜雀台
		if (tonumber(tCmd[idx + 11]) == 1) then
			roomAbstract.bIsPveMulti = true
		end
		roomAbstract.allPlayerNum		= tonumber(tCmd[idx + 12])		--玩家总数
		roomAbstract.enterPlayerNum		= tonumber(tCmd[idx + 13])		--已进入玩家数
		roomAbstract.sessionState		= tonumber(tCmd[idx + 14])		--游戏局状态	-1未初始化 1初始化 2在游戏 3游戏开始 4游戏结束
		roomAbstract.sessionBeginTimestamp	= tonumber(tCmd[idx + 15])		--游戏开始时间
		roomAbstract.enterPlayerName		= tCmd[idx + 16]			--玩家姓名
		roomAbstractList[#roomAbstractList + 1] = roomAbstract
		
		--[[
		print("=============================================================")
		print("roomAbstract.i:",i)
		print("roomAbstract.id:",roomAbstract.id)					--房间id
		print("roomAbstract.cfgId:",roomAbstract.cfgId)				--房间地图配置索引
		print("roomAbstract.name:",roomAbstract.name)					--房间名
		print("roomAbstract.rm:",roomAbstract.rm)					--房主
		print("roomAbstract.mapName:",roomAbstract.mapName)				--房间地图名
		print("roomAbstract.mapInfo:",roomAbstract.mapInfo)				--房主地图信息
		print("roomAbstract.mapKey:",roomAbstract.mapKey)				--地图键值
		print("roomAbstract.state:",roomAbstract.state)				--房主状态(未开始，正在游戏)
		print("roomAbstract.allPlayerNum:",roomAbstract.allPlayerNum)			--玩家总数
		print("roomAbstract.enterPlayerNum:",roomAbstract.enterPlayerNum)		--已进入玩家数
		print("roomAbstract.sessionState:",roomAbstract.sessionState)		--游戏局状态	-1未初始化 1初始化 2在游戏 3游戏开始 4游戏结束
		print("roomAbstract.sessionBeginTimestamp:",roomAbstract.sessionBeginTimestamp)		--游戏开始时间
		print("roomAbstract.enterPlayerName:",roomAbstract.enterPlayerName)		--玩家姓名
		--]]
	end
	
	hGlobal.event:event("LocalEvent_Pvp_RoomsAbstract", roomAbstractList)
end

--单个房间状态发生了变化（roomNum为1）
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_ROOM_CHANGE] = function(tCmd)
	
	--print(" 房间发生了变化  hVar.PVP_RECV_TYPE.L2C_NOTICE_ROOM_CHANGE:")
	
	local roomNum = tonumber(tCmd[1])
	local roomAbstractList = {}
	if (roomNum == -1) then
		local roomAbstract = {}
		roomAbstract.id = tonumber(tCmd[2])
		roomAbstract.released = true --是否已删除本房间
		roomAbstractList[#roomAbstractList + 1] = roomAbstract
	else
		for i = 1, roomNum do
			local roomAbstract = {}
			local idx = 1 + (i - 1) * 16
			roomAbstract.id				= tonumber(tCmd[idx + 1])		--房间id
			roomAbstract.released		= nil							--是否已删除本房间
			roomAbstract.cfgId			= tonumber(tCmd[idx + 2])		--房间地图配置索引
			roomAbstract.name			= tCmd[idx + 3]				--房间名
			roomAbstract.rm				= tonumber(tCmd[idx + 4])		--房主
			roomAbstract.mapName			= tCmd[idx + 5]				--房间地图名
			roomAbstract.mapInfo			= tCmd[idx + 6]				--房主地图信息
			roomAbstract.mapKey			= tCmd[idx + 7]				--地图键值
			roomAbstract.state			= tonumber(tCmd[idx + 8])		--房主状态(未开始，正在游戏)
			roomAbstract.bUseEquip			= false					--是否携带装备
			if (tonumber(tCmd[idx + 9]) == 1) then
				roomAbstract.bUseEquip = true						--是否携带装备
			end
			roomAbstract.bIsArena			= false					--是否擂台
			if (tonumber(tCmd[idx + 10]) == 1) then
				roomAbstract.bIsArena = true						--是否擂台
			end
			roomAbstract.bIsPveMulti		= false					--是否铜雀台
			if (tonumber(tCmd[idx + 11]) == 1) then
				roomAbstract.bIsPveMulti = true
			end
			roomAbstract.allPlayerNum		= tonumber(tCmd[idx + 12])		--玩家总数
			roomAbstract.enterPlayerNum		= tonumber(tCmd[idx + 13])		--已进入玩家数
			roomAbstract.sessionState		= tonumber(tCmd[idx + 14])		--游戏局状态	-1未初始化 1初始化 2在游戏 3游戏开始 4游戏结束
			roomAbstract.sessionBeginTimestamp	= tonumber(tCmd[idx + 15])		--游戏开始时间
			roomAbstract.enterPlayerName		= tCmd[idx + 16]			--玩家姓名
			roomAbstractList[#roomAbstractList + 1] = roomAbstract
			
			--[[
			print("=============================================================")
			print("roomAbstract.i:",i)
			print("roomAbstract.id:",roomAbstract.id)					--房间id
			print("roomAbstract.cfgId:",roomAbstract.cfgId)				--房间地图配置索引
			print("roomAbstract.name:",roomAbstract.name)					--房间名
			print("roomAbstract.rm:",roomAbstract.rm)					--房主
			print("roomAbstract.mapName:",roomAbstract.mapName)				--房间地图名
			print("roomAbstract.mapInfo:",roomAbstract.mapInfo)				--房主地图信息
			print("roomAbstract.mapKey:",roomAbstract.mapKey)				--地图键值
			print("roomAbstract.state:",roomAbstract.state)				--房主状态(未开始，正在游戏)
			print("roomAbstract.allPlayerNum:",roomAbstract.allPlayerNum)			--玩家总数
			print("roomAbstract.enterPlayerNum:",roomAbstract.enterPlayerNum)		--已进入玩家数
			print("roomAbstract.sessionState:",roomAbstract.sessionState)		--游戏局状态	-1未初始化 1初始化 2在游戏 3游戏开始 4游戏结束
			print("roomAbstract.sessionBeginTimestamp:",roomAbstract.sessionBeginTimestamp)		--游戏开始时间
			print("roomAbstract.enterPlayerName:",roomAbstract.enterPlayerName)		--玩家姓名
			]]
		end
	end
	
	--触发事件：单个房间的摘要信息发生变化
	hGlobal.event:event("LocalEvent_Pvp_SingleRoomsAbstractChanged", roomAbstractList)
end



--自己所处的房间信息
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_REQUEST_ROOMINFO] = function(tCmd)
	
	local room = {}
	room.id			= tonumber(tCmd[1])					--房间id
	room.cfgId		= tonumber(tCmd[2])					--房间地图配置索引
	room.name		= tCmd[3]						--房间名
	room.rm			= tonumber(tCmd[4])					--房主
	room.mapName		= tCmd[5]						--房间地图名
	room.mapInfo		= tCmd[6]						--房主地图信息
	room.mapKey		= tCmd[7]						--地图键值
	room.state		= tonumber(tCmd[8])					--房主状态(未开始，正在游戏)
	room.bUseEquip		= false							--是否携带装备
	if tonumber(tCmd[9]) == 1 then
		room.bUseEquip = true							--是否携带装备
	end
	room.bIsArena		= false							--是否擂台
	if tonumber(tCmd[10]) == 1 then
		room.bIsArena = true							--是否擂台
	end
	room.bIsPveMulti	= false						--是否铜雀台
	if tonumber(tCmd[11]) == 1 then
		room.bIsPveMulti = true							--是否铜雀台
	end
	
	room.pList		= {}
	
	--玩家列表信息
	local forceNum = tonumber(tCmd[12])	--势力数量
	local forceIdx = 13
	--遍历玩家列表
	for force = 1, forceNum do
		room.pList[force] = {}
		local forceInfo = room.pList[force]
		local pNum = tonumber(tCmd[forceIdx])
		for i = 1, pNum do
			local tmpPInfo = {} 
			local pInfo = tCmd[forceIdx + i]
			local tPInfo = hApi.Split(pInfo,":")
			tmpPInfo.pos = tonumber(tPInfo[1])				--用户位置
			tmpPInfo.uid = tonumber(tPInfo[2])				--用户id
			tmpPInfo.dbid = tonumber(tPInfo[3])				--用户dbid
			tmpPInfo.rid = tonumber(tPInfo[4])				--用户rid
			tmpPInfo.name = tPInfo[5]					--用户姓名
			tmpPInfo.utype = tonumber(tPInfo[6])				--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			tmpPInfo.ready = tonumber(tPInfo[7])				--是否准备 0 未准备 1 准备
			tmpPInfo.computerOnly = tonumber(tPInfo[8])			--是否只允许电脑 0 否 1 是
			
			tmpPInfo.winE = tonumber(tPInfo[9])				--用户娱乐房胜场
			tmpPInfo.loseE = tonumber(tPInfo[10])				--用户娱乐房败场
			tmpPInfo.drawE = tonumber(tPInfo[11])				--用户娱乐房平局
			tmpPInfo.errE = tonumber(tPInfo[12])				--用户娱乐房异常场
			tmpPInfo.escapeE = tonumber(tPInfo[13])				--用户娱乐房异常场
			tmpPInfo.outsyncE = tonumber(tPInfo[14])			--用户娱乐房不同步场
			tmpPInfo.totalE = tonumber(tPInfo[15])				--用户娱乐房总场
			
			tmpPInfo.winM = tonumber(tPInfo[16])				--用户匹配房胜场
			tmpPInfo.loseM = tonumber(tPInfo[17])				--用户匹配房败场
			tmpPInfo.drawM = tonumber(tPInfo[18])				--用户匹配房平局
			tmpPInfo.errM = tonumber(tPInfo[19])				--用户匹配房异常场
			tmpPInfo.escapeM = tonumber(tPInfo[20])				--用户匹配房异常场
			tmpPInfo.outsyncM = tonumber(tPInfo[21])			--用户匹配房不同步场
			tmpPInfo.totalM = tonumber(tPInfo[22])				--用户匹配房总场
			
			tmpPInfo.evaluateE = tonumber(tPInfo[23])			--用户娱乐模式累计星星评价
			
			--tmpPInfo.winE = tonumber(tPInfo[9])				--用户娱乐房胜场
			--tmpPInfo.loseE = tonumber(tPInfo[10])				--用户娱乐房败场
			--tmpPInfo.drawE = tonumber(tPInfo[11])				--用户娱乐房平局
			--tmpPInfo.errE = tonumber(tPInfo[12])				--用户娱乐房异常场
			--tmpPInfo.escapeE = tonumber(tPInfo[13])			--用户娱乐房异常场
			--tmpPInfo.outsyncE = tonumber(tPInfo[14])			--用户娱乐房不同步场
			--tmpPInfo.evaluateE = tonumber(tPInfo[15])			--用户娱乐模式累计星星评价
			--tmpPInfo.totalE = tonumber(tPInfo[16])			--用户娱乐房总场
			--tmpPInfo.total = tonumber(tPInfo[17])				--用户所有房间总场
			tmpPInfo.coppercount = tonumber(tPInfo[24])			--开过的铜宝箱总量
			tmpPInfo.silvercount = tonumber(tPInfo[25])			--开过的银宝箱总量
			tmpPInfo.goldcount = tonumber(tPInfo[26])			--开过的金宝箱总量
			tmpPInfo.chestexp = tonumber(tPInfo[27])			--开锦囊得到的经验
			
			--[[
			print("tmpPInfo.pos:",tmpPInfo.pos)
			print("tmpPInfo.uid:",tmpPInfo.uid)
			print("tmpPInfo.dbid:",tmpPInfo.dbid)
			print("tmpPInfo.rid:",tmpPInfo.rid)
			print("tmpPInfo.name:",tmpPInfo.name)
			print("tmpPInfo.utype:",tmpPInfo.utype)
			print("tmpPInfo.ready:",tmpPInfo.ready)
			print("tmpPInfo.computerOnly:",tmpPInfo.computerOnly)
			print("tmpPInfo.winE:",tmpPInfo.winE)
			print("tmpPInfo.loseE:",tmpPInfo.loseE)
			print("tmpPInfo.drawE:",tmpPInfo.drawE)
			print("tmpPInfo.errE:",tmpPInfo.errE)
			print("tmpPInfo.escapeE:",tmpPInfo.escapeE)
			print("tmpPInfo.outsyncE:",tmpPInfo.outsyncE)
			print("tmpPInfo.evaluateE:",tmpPInfo.evaluateE)
			print("tmpPInfo.totalE:",tmpPInfo.totalE)
			print("tmpPInfo.total:",tmpPInfo.total)
			--]]
			
			forceInfo[#forceInfo + 1] = tmpPInfo
		end
		forceIdx = forceIdx + pNum + 1
	end
	
	hGlobal.event:event("LocalEvent_Pvp_RoomInfo", room)
end

--离开房间
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_LEAVE_ROOM] = function(tCmd)
	local roomId = tonumber(tCmd[1])
	hGlobal.event:event("LocalEvent_Pvp_RoomLeave",roomId)
end

--消息
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_ROOM_EVENT] = function(tCmd)
	local eventId = tonumber(tCmd[1]) --1创建 2离开 3准备 4进入游戏 5房主变更 6被房主踢出
	local user = {}
	user.id = tonumber(tCmd[2])
	user.dbid = tonumber(tCmd[3])
	user.rid = tonumber(tCmd[4])
	user.name = tCmd[5]
	hGlobal.event:event("LocalEvent_Pvp_RoomEvent",eventId, user)
end

--返回错误消息
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_ERROR] = function(tCmd)
	local errorId = tonumber(tCmd[1])
	local errorStr = nil
	if (errorId == hVar.NETERR.UNKNOW_ERROR) then
		print("Net Logic Error:未知错误")
		errorStr = "未知错误"
	elseif errorId == hVar.NETERR.LOGIN_PLAYER_EXEIST then
		print("Net Logic Error:玩家已存在")
		errorStr = "玩家已存在"
	elseif errorId == hVar.NETERR.LOGIN_PLAYER_FULL then
		print("Net Logic Error:玩家已满")
		errorStr = "玩家已满"
	elseif errorId == hVar.NETERR.ROOM_GETLIST_FAILD then
		print("Net Logic Error:获取房间列表失败")
		errorStr = "获取房间列表失败"
	elseif errorId == hVar.NETERR.ROOM_GETABSTRACT_FAILD then
		print("Net Logic Error:获取房间摘要失败")
		errorStr = "获取房间摘要失败"
	elseif errorId == hVar.NETERR.ROOM_CREATE_FAILD then
		print("Net Logic Error:创建房间失败")
		errorStr = "创建房间失败"
	elseif errorId == hVar.NETERR.ROOM_ENTER_FAILD then
		print("Net Logic Error:进入房间失败")
		errorStr = "进入房间失败"
		
		--触发进入房间失败事件
		hGlobal.event:event("LocalEvent_Pvp_RoomEnter_Fail")
	elseif errorId == hVar.NETERR.ROOM_LEAVE_FAILD then
		print("Net Logic Error:离开房间失败")
		errorStr = "离开房间失败"
	elseif errorId == hVar.NETERR.ROOM_PREPARE_FAILD then
		print("Net Logic Error:游戏准备失败")
		errorStr = "游戏准备失败"
	elseif errorId ==  hVar.NETERR.GAME_ENTER_NO_SESSION then
		print("Net Logic Error:切换游戏过程中游戏局不存在")
		errorStr = "切换游戏过程中游戏局不存在"
		
		--触发切换游戏失败事件
		--hGlobal.event:event("LocalEvent_Pvp_EnterGame_Fail")
	elseif errorId == hVar.NETERR.GAME_ENTER_NO_PLAYER then
		print("Net Logic Error:切换游戏过程中玩家不在游戏局中")
		errorStr = "切换游戏过程中玩家不在游戏局中"
	elseif errorId == hVar.NETERR.HALL_UPLOAD_BATTLE_CFG_FAILD then
		print("Net Logic Error:更新战斗配置失败")
		errorStr = "更新战斗配置失败"
	elseif errorId == hVar.NETERR.HALL_GET_BATTLE_CFG_FAILD then
		print("Net Logic Error:玩家不存在或不在大厅,更新(获取)战斗配置失败")
		errorStr = "玩家不存在或不在大厅,更新(获取)战斗配置失败"
	elseif errorId == hVar.NETERR.ROOM_CHANGE_POSTYPE_FAILD then
		print("Net Logic Error:修改位置类型失败")
		errorStr = "修改位置类型失败"
	elseif errorId == hVar.NETERR.ROOM_CHANGE_EQUIP_FLAG_FAILD then
		print("Net Logic Error:修改房间是否可带装备失败")
		errorStr = "修改房间是否可带装备失败"
	elseif errorId == hVar.NETERR.ROOM_POSTYPE_ONLY_RM_OP then
		print("Net Logic Error:房主才能操作")
		errorStr = "房主才能操作"
	elseif errorId == hVar.NETERR.ROOM_POSTYPE_INVALID_TYPE then
		print("Net Logic Error:非法的位置类型")
		errorStr = "非法的位置类型"
	elseif errorId == hVar.NETERR.ROOM_POSTYPE_ONLY_COMPUTER then
		print("Net Logic Error:该位置只允许设置成电脑")
		errorStr = "该位置只允许设置成电脑"
	elseif errorId == hVar.NETERR.ROOM_POSTYPE_ONLY_OTHER then
		print("Net Logic Error:房主不能操作自己")
		errorStr = "房主不能操作自己"
	elseif errorId == hVar.NETERR.ROOM_POSTYPE_INVALID_FORCE then
		print("Net Logic Error:非法的势力")
		errorStr = "非法的势力"
	elseif errorId == hVar.NETERR.ROOM_POSTYPE_INVALID_POS then
		print("Net Logic Error:非法的位置")
		errorStr = "非法的位置"
	elseif errorId == hVar.NETERR.ROOM_POSTYPE_INVALID_ROOM then
		print("Net Logic Error:房间不存在")
		errorStr = "房间不存在"
	--elseif errorId == hVar.NETERR.HALL_GET_BATTLE_SCORE_FAILD then
	--	print("Net Logic Error:获取战绩信息失败")
	--	errorStr = "获取战绩信息失败"
	elseif errorId == hVar.NETERR.GAME_RESULT_SESSION_INVALID then
		print("Net Logic Error:（游戏不足3分钟，非有效局）")
		errorStr = "（游戏不足3分钟，非有效局）"
		
		--触发游戏结果为无效事件
		hGlobal.event:event("LocalEvent_Pvp_GameResult_Invalid", errorStr)
	elseif errorId == hVar.NETERR.GAME_RESULT_SCORE_INVALID then
		print("Net Logic Error:游戏玩家上传积分不一致")
		errorStr = "游戏玩家上传积分不一致"
		
		--触发游戏结果为无效事件
		hGlobal.event:event("LocalEvent_Pvp_GameResult_Invalid", errorStr)
	elseif errorId == hVar.NETERR.GAME_RESULT_PLAYER_ERROR then
		print("Net Logic Error:玩家掉线或离开异常")
		errorStr = "玩家掉线或离开异常"
		
		--触发游戏结果为无效事件
		hGlobal.event:event("LocalEvent_Pvp_GameResult_Invalid", errorStr)
	elseif errorId == hVar.NETERR.GET_PVPCOIN_EVERYDAY_FAILD then
		print("Net Logic Error:每日领取兵符失败")
		errorStr = "每日领取兵符失败"
	elseif errorId == hVar.NETERR.HALL_GET_USER_BASEINFO_FAILD then
		print("Net Logic Error:获取玩家基本信息失败")
		errorStr = "获取玩家基本信息失败"
	elseif errorId == hVar.NETERR.HALL_REWARD_PVPCHEST_FAILD then
		print("Net Logic Error:兑换竞技场锦囊失败")
		errorStr = "兑换竞技场锦囊失败"
	elseif errorId == hVar.NETERR.HALL_OPEN_PVPCHEST_FAILD then
		print("Net Logic Error:打开竞技场锦囊失败")
		errorStr = "打开竞技场锦囊失败"
	elseif errorId == hVar.NETERR.ROOM_ESCAPE_PUNISH_ERROR then
		print("Net Logic Error:逃跑3次以上，20分钟内无法对战")
		errorStr = "逃跑3次以上，20分钟内无法对战"
	elseif errorId == hVar.NETERR.HALL_HERO_STARLVUP_FAILD then
		print("Net Logic Error:英雄升星失败")
		errorStr = "英雄升星失败"
	elseif errorId == hVar.NETERR.HALL_ARMY_LVUP_FAILD then
		print("Net Logic Error:兵种卡升级失败")
		errorStr = "兵种卡升级失败"
	elseif errorId == hVar.NETERR.MATCH_GETLIST_FAILD then
		print("Net Logic Error:获取匹配房间列表失败")
		errorStr = "获取匹配房间列表失败"
	elseif errorId == hVar.NETERR.MATCH_ENTER_FAILD then
		print("Net Logic Error:进入匹配房间失败")
		errorStr = "进入匹配房间失败"
	elseif errorId == hVar.NETERR.MATCH_CANCEL_FAILD then
		print("Net Logic Error:取消匹配失败")
		errorStr = "取消匹配失败"
	elseif errorId == hVar.NETERR.MATCH_BEGINGAME_FAILD then
		print("Net Logic Error:进入匹配游戏局失败")
		errorStr = "进入匹配游戏局失败"
	elseif errorId == hVar.NETERR.ROOM_CLOSED_NOW then
		print("Net Logic Error:当前时间暂未开放")
		errorStr = "当前时间暂未开放"
	elseif errorId == hVar.NETERR.MATCH_OVER_TIME then
		print("Net Logic Error:匹配时间结束，未找到对手")
		errorStr = "匹配时间结束，未找到对手"
	elseif errorId == hVar.NETERR.RELOGIN_ERR_NOT_IN_GAME then
		print("Net Logic Error:无法重连，玩家已不在游戏局中")
		errorStr = "无法重连，玩家已不在游戏局中"
		
		--触发重练失败事件
		hGlobal.event:event("LocalEvent_Pvp_ReLogin_Fail", errorStr)
	elseif errorId == hVar.NETERR.RELOGIN_ERR_GAME_END then
		print("Net Logic Error:无法重连，游戏局已经结束")
		errorStr = "无法重连，游戏局已经结束"
		
		--触发重练失败事件
		hGlobal.event:event("LocalEvent_Pvp_ReLogin_Fail", errorStr)
	elseif errorId == hVar.NETERR.HALL_HERO_UNLOCK_FAILD then
		print("Net Logic Error:英雄解锁失败")
		errorStr = "英雄解锁失败"
	elseif errorId == hVar.NETERR.GET_BUY_PVPCOIN_FAILD then
		print("Net Logic Error:购买兵符失败")
		errorStr = "购买兵符失败"
	elseif errorId == hVar.NETERR.HALL_ARMY_REFRESH_ADDONES_FAILD then
		print("Net Logic Error:刷新战术卡附加属性失败")
		errorStr = "刷新战术卡附加属性失败"
	elseif errorId == hVar.NETERR.HALL_ARMY_NEW_ADDONES_FAILD then
		print("Net Logic Error:新增战术卡附加属性失败")
		errorStr = "新增战术卡附加属性失败"
	elseif errorId == hVar.NETERR.HALL_ARMY_RESTORE_ADDONES_FAILD then
		print("Net Logic Error:还原战术卡附加属性失败")
		errorStr = "还原战术卡附加属性失败"
	else
		print("Net Logic Error:未知")
		errorStr = "未知"
	end
	
	--pvp错误提示信息
	hGlobal.event:event("LocalEvent_Pvp_NetLogicError", errorStr)
end

--玩家登入事件
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_PLAYER_LOGIN] = function(tCmd)
	local iResult = tonumber(tCmd[1]) --0:失败 / 1:成功
	local playerId = 0
	
	if (iResult == 1) then --成功
		
		--版本号
		g_pvp_control = tostring(tCmd[2])
		----------------------------------------------------------------------------------------------------------------------------
		
		--存储pvp服务器时间
		g_systime_pvp = tonumber(tCmd[3]) --存储服务器时间戳(整数)
		local localTime_pvp = os.time() --pvp客户端时间
		g_localDeltaTime_pvp = localTime_pvp - g_systime_pvp --pvp存储客户端的时间和服务器的时间误差(Local = Host + deltaTime)
		----------------------------------------------------------------------------------------------------------------------------
		
		--基本信息
		playerId = tonumber(tCmd[4])
		----------------------------------------------------------------------------------------------------------------------------
	elseif (iResult == 0) then --失败
	end
	
	hGlobal.LocalPlayer.data.playerId = playerId
	hGlobal.event:event("LocalEvent_Pvp_PlayerLoginEvent", iResult, playerId) --0失败 1成功
	--print("玩家登入事件",iResult,playerId)
end

--切换游戏（服务器通知各个客户端进入游戏）
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_SWITCH_GAME] = function(tCmd)
	
	--游戏局信息
	local session = {}
	session.id			= tonumber(tCmd[1])				--游戏局Id
	session.dbId			= tonumber(tCmd[2])				--游戏局dbId
	session.cfgId			= tonumber(tCmd[3])				--对应房间配置id
	session.ip			= tCmd[4]					--游戏局Ip
	session.port			= tonumber(tCmd[5])				--游戏局Port
	session.randomSeed		= tonumber(tCmd[6])				--当前游戏局随机种子
	session.mapName			= tCmd[7]					--游戏局地图
	session.endTurnInterval		= tCmd[8]					--每回合客户端提前多少帧发送结束回合 3frame
	session.framePerTurn		= tonumber(tCmd[9])				--每回合帧数 6frame
	session.opExecuteInterval	= tonumber(tCmd[10])				--每回合指令执行的间隔 3frame
	session.bUseEquip		= false						--是否携带装备
	if tonumber(tCmd[11]) == 1 then
		session.bUseEquip = true						--是否携带装备
	end
	session.bIsArena		= false						--是否携带装备
	if tonumber(tCmd[12]) == 1 then
		session.bIsArena = true						--是否携带装备
	end
	session.validTime		= tonumber(tCmd[13])				--有效局的最少时长
	
	--print("hVar.PVP_RECV_TYPE.L2C_NOTICE_SWITCH_GAME:",session.id,session.dbId,session.ip,session.port,session.randomSeed,session.mapName,session.endTurnInterval,session.framePerTurn,session.opExecuteInterval,session.bUseEquip,session.bIsArena,session.validTime)
	
	session.pList		= {}
	--玩家列表信息
	local pNum = tonumber(tCmd[14])	--数量
	local forceIdx = 15
	--遍历玩家列表
	for i = 1, pNum do
		local tmpPInfo = {} 
		local pInfo = tCmd[forceIdx]
		local tPInfo = hApi.Split(pInfo,":")
		tmpPInfo.pos = tonumber(tPInfo[1])				--玩家位置
		tmpPInfo.pid = tonumber(tPInfo[2])				--玩家id
		tmpPInfo.dbid = tonumber(tPInfo[3])				--玩家dbid
		tmpPInfo.rid = tonumber(tPInfo[4])				--玩家rid
		tmpPInfo.name = tPInfo[5]					--玩家姓名
		tmpPInfo.utype = tonumber(tPInfo[6])				--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
		tmpPInfo.force = tonumber(tPInfo[7])				--势力
		
		session.pList[#session.pList + 1] = tmpPInfo
		forceIdx = forceIdx + 1
	end

	local tacticIdx = forceIdx
	local tactic_amount = tonumber(tCmd[tacticIdx]) or 0
	if tactic_amount > 0 then
		session.tacticList = {}
		for i = 1, tactic_amount do
			local tacticInfo = tCmd[tacticIdx + i]
			local tTacticInfo = hApi.Split(tacticInfo,":")
			local id = tonumber(tTacticInfo[1]) or 0
			local lv = tonumber(tTacticInfo[2]) or 0
			--print(id, debris, debris, lv)
			if id > 0 and lv > 0 then
				session.tacticList[#session.tacticList + 1] = {id,lv}
			end
		end
	end
	
	hGlobal.event:event("LocalEvent_Pvp_SwitchGame", session)
end

--切换游戏
hGlobal.event:listen("LocalEvent_Pvp_SwitchGame", "", function(session)
	--关闭同步日志文件（第二把游戏开始时）
	--hApi.SyncLogClose()
	--关闭非同步日志文件（第二把游戏开始时）
	--hApi.AsyncLogClose()
	
	--[[
	--geyachao: 同步日志: 游戏局开始
	if (hVar.IS_SYNC_LOG == 1) then
		local msg = "session: mapName=" .. tostring(mapName) .. ",mapMode=" .. tostring(mapMode) .. ",session_id=" .. tostring(session)
		hApi.SyncLog(msg)
	end
	]]
	
	--打开同步日志文件
	local session_dbId = session.dbId
	local SyncFileName = "log/sync_log_" .. session_dbId .. ".log"
	hApi.SyncLogOpen(SyncFileName)
	
	--打开非同步日志文件
	local AsyncFileName = "log/async_log" .. session_dbId .. ".log"
	hApi.AsyncLogOpen(AsyncFileName)
	
	local mapName = session.mapName
	local mapMode = hVar.MAP_TD_TYPE.PVP
	xlScene_LoadMap(g_world, mapName, 0, mapMode, session)
end)
---------------------------------------------------------------------------------------

--服务器返回玩家信息
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_PLAYER_BATTLE_INFO] = function(tCmd)

	local isPveMulti = tonumber(tCmd[1]) or 0
	local myBattleInfo = {}
	--配置的战虎卡、兵符、塔、等信息下发
	--...
	myBattleInfo.pos = tonumber(tCmd[2])			--玩家位置
	myBattleInfo.id = tonumber(tCmd[3])			--内存id
	myBattleInfo.dbId = tonumber(tCmd[4])			--数据库id
	myBattleInfo.rId = tonumber(tCmd[5])			--当前使用的角色Id
	myBattleInfo.force = tonumber(tCmd[6])			--势力

	if tCmd[7] == "" then
		myBattleInfo.battlecfg = {}
	else
		local tmp = "local strCfg = ".. tostring(tCmd[7]) .. " return strCfg"
		myBattleInfo.battlecfg = assert(loadstring(tmp))()	--用户战斗配置
	end
	
	
	hGlobal.event:event("LocalEvent_Pvp_GetBattleInfo", myBattleInfo)
	
	if isPveMulti > 0 and xlPlayer_GetUID() == myBattleInfo.dbId then
		SendPvpCmdFunc["upload_my_battle_info"](myBattleInfo.battlecfg)
	end
end

--玩家对战信息
hGlobal.event:listen("LocalEvent_Pvp_GetBattleInfo", "__PVP_GetBattleInfo", function(myBattleInfo)
	--当前世界
	local w = hGlobal.WORLD.LastWorldMap
	
	--添加游戏信息文本
	hApi.AppendGameInfo("GetBattleInfo,w=" .. tostring(w) .. ",pos=" .. tostring(myBattleInfo.pos) .. ",state=" .. tostring(w and w.data.tdMapInfo and w.data.tdMapInfo.mapState))
	
	--如果当前世界存在
	if w then
		local mapInfo = w.data.tdMapInfo
		--如果游戏局处于初始化完毕但还未开始游戏状态
		if mapInfo and mapInfo.mapState >= hVar.MAP_TD_STATE.INIT and mapInfo.mapState < hVar.MAP_TD_STATE.BEGIN then
			
			--如果收到协议的玩家dbid存在
			if myBattleInfo and myBattleInfo.dbId then
				--local player = w:GetPlayerByDBID(myBattleInfo.dbId)
				local player = w:GetPlayer(myBattleInfo.pos)
				--如果玩家存在
				if player then
					--更新玩家pvp数据
					local battlecfg = myBattleInfo.battlecfg
					--如果有战斗配置
					if battlecfg and (type(battlecfg) == "table") then
						--塔的配置
						if battlecfg.towercard and (type(battlecfg.towercard) == "table") then
							w:settactics(player, battlecfg.towercard)
						end
						--卡的配置
						if battlecfg.tacticcard and (type(battlecfg.tacticcard) == "table") then
							--zhenkira 不添加战术技能卡
							w:settactics(player, battlecfg.tacticcard)
						end
						
						--英雄的配置
						if battlecfg.herocard and (type(battlecfg.herocard) == "table") then
							for i = 1, #battlecfg.herocard, 1 do
								local tHeroCard = battlecfg.herocard[i]
								
								--geyachao: 电脑出阵，英雄随机
								if player and (player:gettype() >= 2) and (player:gettype() <= 6) then --0空 1玩家 2简单电脑 3中等电脑 4困难电脑 5大师电脑 6专家电脑
									--print("位置" .. myBattleInfo.pos, "是电脑")
									if (tHeroCard.id == 18003) then --张飞
										local randHeros = {18003, 18011, 18015} --张飞, 吕布, 许褚
										local randIdx = (w:random(1, 997) + w.data.session_dbId) % (#randHeros) + 1
										tHeroCard.id = randHeros[randIdx]
									end
									
									if (tHeroCard.id == 18002) then --关羽
										local randHeros = {18002, 18006, 18010} --关羽, 太史慈, 夏侯惇
										local randIdx = (w:random(1, 997) + w.data.session_dbId) % (#randHeros) + 1
										tHeroCard.id = randHeros[randIdx]
									end
								end
								
								local heroId = tHeroCard.id
								if (heroId > 0) and (hVar.tab_unit[heroId]) then
									
									--print("tHeroCard.attr.level:",tHeroCard.attr.level)
									
									--临时代码-------------------------------------------------------
									
									--使用pvp角色需要重新调整数据
									if mapInfo.pveHeroMode == 0 then
										--计算技能解锁等级
										local unlockLv = mapInfo.heroLvInPvpMap
										--if mapInfo.skillUnlockMode == 1 then
										--	unlockLv = tHeroCard.attr.level
										--end
										
										tHeroCard.id = tHeroCard.id + 100
										tHeroCard.attr.exp = 2875
										tHeroCard.attr.level = 10
										tHeroCard.attr.star = 1
										tHeroCard.talent = {}
										tHeroCard.tactic = {}
										local tabT = hVar.tab_unit[tHeroCard.id]
										if tabT then
											--加载talent表里的数据
											if tabT.talent then
												local unlockTalent = hApi.GetUnlockTalentNum(unlockLv)
												for i = 1, unlockTalent do
												--for i = 1, #tabT.talent do
													local talentObj = tabT.talent[i]
													local skillId = talentObj[1] or 0
													local skillLv = talentObj[2] or 0
													
													tHeroCard.talent[i] = {id = skillId, lv = 1}
												end
											end
											if tabT.tactics then
												for i = 1, math.min(#tabT.tactics, hVar.HERO_TACTIC_SIZE) do
													
													local tacticId = 0
													local tacticLv = 0
													if tabT.tactics[i] then
														tacticId = tabT.tactics[i] or 0
													end
													--目前逻辑写死，每颗星级开放一个技能
													if tacticId > 0 then
														tacticLv = 1
													end
													tHeroCard.tactic[i] = {id = tacticId, lv = 1}
												end
											end
										end
									end
									--临时代码-------------------------------------------------------
									
									local oHero = player:createhero(tHeroCard.id, tHeroCard)
									
									--英雄战术技能
									--local tactics = hApi.GetHeroTactic(tHeroCard.id,tHeroCard)
									local tactics = oHero:gettactics()
									local tTacticAllList = {}
									for i = 1, #tactics, 1 do
										local tactic = tactics[i]
										if tactic then
											local tacticId = tactic.id or 0
											local tacticLv = tactic.lv or 1
											--显示不超过最大等级
											--if (tacticLv > maxLv) then
											--	tacticLv = maxLv
											--end
											if (tacticId > 0) and (tacticLv > 0) then
												tTacticAllList[#tTacticAllList + 1] = {tacticId, tacticLv, tHeroCard.id} --geyachao:标识此战术卡属于哪个英雄
											end
										end
									end
									
									--英雄战术技能
									--zhenkira 暂时不添加英雄战术技能
									w:settactics(player, tTacticAllList)
								end
							end
							
						end
					end
				end
			end
		end
	end

end)
---------------------------------------------------------------------------------------

--服务器返游戏局开始
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_GAME_START] = function(tCmd)
	--todo
	local result = tonumber(tCmd[1])		--0失败 1成功
	local sessionId = tonumber(tCmd[2])
	
	hGlobal.event:event("LocalEvent_Pvp_StartGame", result, sessionId)
end

--游戏开始
hGlobal.event:listen("LocalEvent_Pvp_StartGame", "", function(result, sessionId)
	local w = hGlobal.WORLD.LastWorldMap
	--添加游戏信息文本
	hApi.AppendGameInfo("StartGame,w=" .. tostring(w))
	
	if w then
		local mapInfo = w.data.tdMapInfo
		if mapInfo then
			--设置游戏为开始状态
			mapInfo.mapState = hVar.MAP_TD_STATE.BEGIN
			xlScene_Switch(g_world)
			map_start()
			--调用xlScene_Switch后,load就会断掉。但又无法把xlScene_Switch移动到最后一步做因为map_start，如果在xlScene_Switch之前调用，好像流程会异常，而map_start本身需要同步执行
			--todo: 先后顺序？？？观察update loop loading条
			g_ProgressFunctions = nil
			g_UpdateProgressDelay = nil
			
			--添加游戏信息文本
			--hApi.AppendGameInfo("g_ProgressFunctions=" .. tostring(g_ProgressFunctions))
			--hApi.AppendGameInfo("g_UpdateProgressDelay=" .. tostring(g_UpdateProgressDelay))
		end
	end
end)

--收到服务器的同步消息
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_GAME_SYNC_CMD] = function(tCmd)
	local opInfo = {}
	
	opInfo.sessionId = tonumber(tCmd[1])
	opInfo.endTurnInterval = tonumber(tCmd[2])					--每回合客户端提前多少帧发送结束回合 1frame
	opInfo.framePerTurn = tonumber(tCmd[3])
	opInfo.OpExecuteInterval = tonumber(tCmd[4])
	opInfo.hTurn = tonumber(tCmd[5])
	opInfo.hTick = opInfo.hTurn * opInfo.framePerTurn + opInfo.OpExecuteInterval
	--opInfo.hTick = opInfo.OpExecuteInterval
	opInfo.opNum = tonumber(tCmd[6])
	opInfo.opList = {}
	
	local opIdx = 7
	--遍历玩家列表
	for i = 1, opInfo.opNum do
		local tmpOpInfo = {}
		local sOp = tCmd[opIdx]
		local tOp= hApi.Split(sOp,":")
		
		tmpOpInfo.pId = tonumber(tOp[1])
		tmpOpInfo.tick = tonumber(tOp[2])
		tmpOpInfo.opType = tonumber(tOp[3])
		tmpOpInfo.sOp = tOp[4]
		
		opInfo.opList[#opInfo.opList + 1] = tmpOpInfo
		opIdx = opIdx + 1
	end
	
	hGlobal.event:event("LocalEvent_Pvp_Sync_CMD", opInfo)
end

--返回战斗配置信息
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_REQUEST_BATTLE_CFG] = function(tCmd)
	
	local udbid = tonumber(tCmd[1])
	
	--print("LocalEvent_Pvp_battleCfg", tCmd)
	local tCfg = {}
	
	if (tCmd[2] == "") or (tCmd[2] == nil) then
		--
	else
		local tmp = "local strCfg = "..tCmd[2].." return strCfg"
		tCfg = assert(loadstring(tmp))()
	end
	
	--print("tCfg=", tCfg)
	hGlobal.event:event("LocalEvent_Pvp_battleCfg", tCfg, udbid)
end

--返回玩家战绩信息
--PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_REQUEST_BATTLE_SCORE] = function(tCmd)
--	
--	local scoreInfo = {}
--	scoreInfo.id = tonumber(tCmd[1])		--内存id
--	scoreInfo.dbId = tonumber(tCmd[2])		--数据库id
--	scoreInfo.rId = tonumber(tCmd[3])		--当前使用的角色Id
--	
--	scoreInfo.winE = tonumber(tCmd[4])		--用户娱乐房胜场
--	scoreInfo.loseE = tonumber(tCmd[5])		--用户娱乐房败场
--	scoreInfo.drawE = tonumber(tCmd[6])		--用户娱乐房平局
--	scoreInfo.errE = tonumber(tCmd[7])		--用户娱乐房异常场
--	scoreInfo.escapeE = tonumber(tCmd[8])		--用户娱乐场逃跑场
--	scoreInfo.outsyncE = tonumber(tCmd[9])		--用户娱乐场不同步场
--	scoreInfo.evaluateE = tonumber(tCmd[10])	--用户娱乐模式累计星星评价
--	scoreInfo.totalE = tonumber(tCmd[11])		--用户娱乐房总场
--	scoreInfo.total = tonumber(tCmd[12])		--用户所有房间总场
--	
--	--存储我的pvp基础信息
--	g_myPvP_BaseInfo = baseInfo
--	
--	hGlobal.event:event("LocalEvent_Pvp_battleScore", scoreInfo)
--end

--延时的玩家
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_GAME_PLAYER_DELAY] = function(tCmd)
	local num = tonumber(tCmd[1])
	local delayPlayer = {}
	
	local pIdx = 2
	for i = 1, num do
		local tmpInfo = {}
		local sInfo = tCmd[pIdx]
		local tInfo = hApi.Split(sInfo,":")
		tmpInfo.dbId = tonumber(tInfo[1])
		tmpInfo.kickCD = tonumber(tInfo[2])
		
		delayPlayer[#delayPlayer + 1] = tmpInfo
		
		pIdx = pIdx + 1
	end
	
	hGlobal.event:event("LocalEvent_Pvp_Delay_Player", num, delayPlayer)
end

--ping协议
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_PING] = function(tCmd)
	
	local lastClock = tonumber(tCmd[1])
	g_lastDelay_pvp = math.floor(os.clock() * 1000 - lastClock)
	
	g_pvp_control = tostring(tCmd[2])
	
	--当前在线人数
	local onlineCount = tonumber(tCmd[3])

	--匹配房人数
	local tmp = hApi.Split((tCmd[4] or ""),":")
	local matchuserInEnter = tonumber(tmp[1]) or 0
	local matchuserInGame = tonumber(tmp[2]) or 0

	--本次登陆匹配失败次数
	local matchovertime = tonumber(tCmd[5])
	
	hGlobal.event:event("LocalEvent_Pvp_Ping", g_lastDelay_pvp, onlineCount, matchuserInEnter, matchuserInGame, matchovertime)
end

--返回玩家基本信息
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_USER_BASEINFO] = function(tCmd)
	
	local baseInfo = {}
	
	--基本信息
	baseInfo.id = tonumber(tCmd[1])			--内存id
	baseInfo.dbId = tonumber(tCmd[2])		--数据库id
	baseInfo.rId = tonumber(tCmd[3])		--当前使用的角色Id
	
	--baseInfo.winE = tonumber(tCmd[4])		--用户娱乐房胜场
	--baseInfo.loseE = tonumber(tCmd[5])		--用户娱乐房败场
	--baseInfo.drawE = tonumber(tCmd[6])		--用户娱乐房平局
	--baseInfo.errE = tonumber(tCmd[7])		--用户娱乐房异常场
	--baseInfo.escapeE = tonumber(tCmd[8])		--用户娱乐房逃跑场
	--baseInfo.outsyncE = tonumber(tCmd[9])		--用户娱乐房不同步场
	--baseInfo.evaluateE = tonumber(tCmd[10])		--用户娱乐模式累计星星评价
	--baseInfo.totalE = tonumber(tCmd[11])		--用户娱乐房总场
	--baseInfo.total = tonumber(tCmd[12])		--用户所有房间总场

	baseInfo.winE = tonumber(tCmd[4])		--用户娱乐房胜场
	baseInfo.loseE = tonumber(tCmd[5])		--用户娱乐房败场
	baseInfo.drawE = tonumber(tCmd[6])		--用户娱乐房平局
	baseInfo.errE = tonumber(tCmd[7])		--用户娱乐房异常场
	baseInfo.escapeE = tonumber(tCmd[8])		--用户娱乐房逃跑场
	baseInfo.outsyncE = tonumber(tCmd[9])		--用户娱乐房不同步场
	baseInfo.totalE = tonumber(tCmd[10])		--用户娱乐房总场
	
	baseInfo.winM = tonumber(tCmd[11])		--用户匹配房胜场
	baseInfo.loseM = tonumber(tCmd[12])		--用户匹配房败场
	baseInfo.drawM = tonumber(tCmd[13])		--用户匹配房平局
	baseInfo.errM = tonumber(tCmd[14])		--用户匹配房异常场
	baseInfo.escapeM = tonumber(tCmd[15])		--用户匹配房逃跑场
	baseInfo.outsyncM = tonumber(tCmd[16])		--用户匹配房不同步场
	baseInfo.totalM = tonumber(tCmd[17])		--用户匹配房总场
	
	baseInfo.evaluateE = tonumber(tCmd[18])		--用户娱乐模式累计星星评价
	
	
	baseInfo.escapePunishTime = tonumber(tCmd[19])	--逃跑惩罚时间(单位:秒)
	baseInfo.punishCount = tonumber(tCmd[20])	--惩罚次数累加
	baseInfo.lastPunishTime = tonumber(tCmd[21])	--上一次惩罚时间(数值)
	baseInfo.punishCount1 = tonumber(tCmd[22])	--投降惩罚次数累加
	baseInfo.lastPunishTime1 = tonumber(tCmd[23])	--上一次投降惩罚时间(数值)
	baseInfo.coppercount = tonumber(tCmd[24])	--开过的铜宝箱总量
	baseInfo.silvercount = tonumber(tCmd[25])	--开过的银宝箱总量
	baseInfo.goldcount = tonumber(tCmd[26])		--开过的金宝箱总量
	baseInfo.chestexp = tonumber(tCmd[27])		--开锦囊得到的经验
	baseInfo.arenachest = tonumber(tCmd[28])	--擂台赛锦囊的当前数量
	baseInfo.gamecoin = tonumber(tCmd[29]) or 0	--游戏币
	baseInfo.pvpcoin = tonumber(tCmd[30]) or 0	--兵符
	baseInfo.pvpcoin_last_gettime = tCmd[31]	--兵符每日领取上一次领取时间
	
	--锦囊信息
	local chest_amount = tonumber(tCmd[32]) or 6	--锦囊总数量
	local chestIdx = 32
	baseInfo.chestList = {}
	for i = 1, chest_amount do
		local chestInfo = tCmd[chestIdx + i]
		local tChestInfo = hApi.Split(chestInfo,":")
		
		--免费箱子
		if (i == 1) then
			baseInfo.freechest = {}
			baseInfo.freechest.id = tonumber(tChestInfo[1]) or 0
			baseInfo.freechest.gettime = tonumber(tChestInfo[2]) or 0
		else
			baseInfo.chestList[i-1] = {}
			local chest = baseInfo.chestList[i-1]
			chest.id = tonumber(tChestInfo[1]) or 0
			chest.gettime = tonumber(tChestInfo[2]) or 0
			
			--print(i, chest.id, chest.gettime)
		end
	end
	
	--战术技能卡碎片
	local tacticIdx = chestIdx + chest_amount + 1
	local tactic_amount = tonumber(tCmd[tacticIdx]) or 0
	baseInfo.tacticInfo = {}
	for i = 1, tactic_amount do
		local tacticInfo = tCmd[tacticIdx + i]
		local tTacticInfo = hApi.Split(tacticInfo,":")
		local id = tonumber(tTacticInfo[1]) or 0
		local debris = tonumber(tTacticInfo[2]) or 0
		local totalDebris = tonumber(tTacticInfo[3]) or 0
		local lv = tonumber(tTacticInfo[4]) or 0
		local addonesNum = tonumber(tTacticInfo[5]) or 0
		local addones = {}
		local idx = 5
		for n = 1, addonesNum do
			addones[n] = hApi.String2Type(tTacticInfo[idx + n], "|", false)
		end
		--print(id, debris, debris, lv)
		if id > 0 and (totalDebris > 0 or lv > 0) then
			baseInfo.tacticInfo[id] = {id = id, debris = debris, lv = lv, totalDebris = totalDebris, addonesNum = addonesNum, addones = addones}
		end
	end

	--英雄将魂碎片
	local heroIdx = tacticIdx + tactic_amount + 1
	local hero_amount = tonumber(tCmd[heroIdx]) or 0
	baseInfo.heroInfo = {}
	for i = 1, hero_amount, 1 do
		local heroInfo = tCmd[heroIdx + i]
		local tHeroInfo = hApi.Split(heroInfo,":")
		local id = tonumber(tHeroInfo[1]) or 0
		local star = tonumber(tHeroInfo[2]) or 1
		local soulstone = tonumber(tHeroInfo[3]) or 0
		local totalSoulstone = tonumber(tHeroInfo[4]) or 0
		if (id > 0) then
			baseInfo.heroInfo[id] = {id = id, soulstone = soulstone, star = star, totalSoulstone = totalSoulstone}
		end
	end
	
	--夺塔奇兵匹配局最近10场信息
	local matchRecentIdx = heroIdx + hero_amount + 1
	local matchRecent_amount = tonumber(tCmd[matchRecentIdx]) or 0
	baseInfo.matchRecent = {}
	for i = 1, matchRecent_amount, 1 do
		local battleInfo = tCmd[matchRecentIdx + i]
		local tBattleInfo = hApi.Split(battleInfo,":")
		local evaluePoint = tonumber(tBattleInfo[1]) or 0
		local rivalName = tostring(tBattleInfo[2])
		local rType = tonumber(tBattleInfo[3]) or 0
		local rivalId = tonumber(tBattleInfo[4]) or 0
		local isEquip = tonumber(tBattleInfo[5]) or 0
		baseInfo.matchRecent[i] = {evaluePoint = evaluePoint, rivalName = rivalName, rType = rType, rivalId = rivalId, isEquip = isEquip}
	end
	--print("夺塔奇兵匹配局最近10场信息 #baseInfo.matchRecent=" .. #baseInfo.matchRecent)
	
	--夺塔奇兵擂台最近10场信息
	local arenaRecentIdx = matchRecentIdx + matchRecent_amount + 1
	local arenaRecent_amount = tonumber(tCmd[arenaRecentIdx]) or 0
	baseInfo.arenaRecent = {}
	for i = 1, arenaRecent_amount, 1 do
		local battleInfo = tCmd[arenaRecentIdx + i]
		local tBattleInfo = hApi.Split(battleInfo,":")
		local evaluePoint = tonumber(tBattleInfo[1]) or 0
		local rivalName = tostring(tBattleInfo[2])
		local rType = tonumber(tBattleInfo[3]) or 0
		local rivalId = tonumber(tBattleInfo[4]) or 0
		local isEquip = tonumber(tBattleInfo[5]) or 0
		baseInfo.arenaRecent[i] = {evaluePoint = evaluePoint, rivalName = rivalName, rType = rType, rivalId = rivalId, isEquip = isEquip}
	end
	--print("夺塔奇兵擂台最近10场信息 #baseInfo.arenaRecent=" .. #baseInfo.arenaRecent)
	
	--标记已经是最新
	baseInfo.updated = 1
	
	--存储我的pvp基础信息
	g_myPvP_BaseInfo = baseInfo

	--检测pvp版本号，是否为最新版本
	local local_srcVer = tostring(hVar.CURRENT_ITEM_VERSION) --1.0.070502
	local pvp_control = tostring(g_pvp_control) --1.0.070502-v018-018-app
	local vbpos = string.find(pvp_control, "-")
	if vbpos then
		pvp_control = string.sub(pvp_control, 1, vbpos - 1)
	end
	
	--如果pvp版本号一致，同步数据
	if (local_srcVer == pvp_control) then
		
		--print("存储我的pvp基础信息, baseInfo.updated")
		--print("pvpcoin", baseInfo.pvpcoin)
		
		--同步存档中的兵种碎片(pve用的时候再开放)
		--LuaSyncArmyTactic(baseInfo.tacticInfo)
		
		--同步存档中的英雄星级和将魂
		LuaSyncHeroStarAndSoulStone(baseInfo.heroInfo)
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
	
	--更新客户端游戏币界面
	SendCmdFunc["gamecoin"]()
	
	--触发事件
	hGlobal.event:event("LocalEvent_Pvp_UserBaseInfo", baseInfo)
end

--通知客户端不同步日志更新状态
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_OUTSYNC_LOG_STATE] = function(tCmd)
	--积分信息
	local result = tonumber(tCmd[1])		--内存id
	
	--失败角色不存在，无法保存日志
	if (result == 0) then
		--触发事件
		hGlobal.event:event("LocalEvent_Pvp_SyncLog", result)
	elseif (result == 1) then
		local dbId = tonumber(tCmd[2])		--数据库Id
		local rId = tonumber(tCmd[3])		--当前使用的角色Id
		local session_dbId = tonumber(tCmd[4])	--游戏局Id
		local packageNum = tonumber(tCmd[5])	--当前包的编号
		
		--触发事件
		hGlobal.event:event("LocalEvent_Pvp_SyncLog", result, dbId, rId, session_dbId, packageNum)
	end
end

--通知客户端游戏局获得评价
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_EVALUATE_STATE] = function(tCmd)

	--print("hVar.PVP_RECV_TYPE.L2C_NOTICE_EVALUATE_STATE:",hVar.PVP_RECV_TYPE.L2C_NOTICE_EVALUATE_STATE)
	
	local envaluate = {}
	envaluate.id = tonumber(tCmd[1])				--玩家id
	envaluate.dbid = tonumber(tCmd[2])				--玩家dbid
	envaluate.rid = tonumber(tCmd[3])				--玩家rid
	envaluate.session_dbId = tonumber(tCmd[4])			--游戏局dbid
	envaluate.evaluatePoint = tonumber(tCmd[5])			--游戏局评价点数（星星）
	envaluate.medalList = {}
	local medalNum = tonumber(tCmd[6]) or 0				--游戏局获得评价数量（勋章数量）
	for i=1, medalNum do
		local medalFlag = tonumber(tCmd[6 + i])
		if medalFlag == 1 then
			envaluate.medalList[i] = true
		elseif medalFlag == 0 then
			envaluate.medalList[i] = false
		end
	end
	
	--触发事件
	hGlobal.event:event("LocalEvent_Pvp_GameResult_RewardStar", envaluate)
end

--通知客户端竞技场锦囊开出的物品
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_REWARD_FROM_PVPCHEST] = function(tCmd)
	
	local chestItemId = tonumber(tCmd[1]) or 0
	local rewardNum = tonumber(tCmd[2]) or 0
	local rIdx = 2
	local reward = {}
	for i = 1, rewardNum do
		local rewardInfo = tCmd[rIdx + i] or ""
		local tRewardInfo = hApi.Split(rewardInfo,":")
		reward[#reward + 1] = tRewardInfo
		--print(i, unpack(tRewardInfo))
	end
	
	--填充本地存档
	hApi.GetReawrdGift(reward, rewardNum)
	
	--触发事件
	hGlobal.event:event("LocalEvent_Pvp_Reward_from_Pvpchest", chestItemId, reward)
end

--通知客户端英雄升星成功
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_HERO_STAR_LVUP] = function(tCmd)
	
	--print("hVar.PVP_RECV_TYPE.L2C_NOTICE_HERO_STAR_LVUP:")
	
	local shopItemId = tonumber(tCmd[1]) or 0
	local itemId = tonumber(tCmd[2]) or 0
	local gamecoin = tonumber(tCmd[3]) or 0
	local score = tonumber(tCmd[4]) or 0
	local tHero = hApi.Split(tCmd[5],":")
	
	----填充本地存档
	--if score > 0 then
	--	LuaAddPlayerScore(-score)
	--end
	----英雄升星
	--ret = LuaHeroStarLevelUp(nHeroId)
	--if ret then
	--		--保存英雄
	--		LuaSaveHeroCard()	--这里不传参数，因为不需要保存经验
	--end
	
	--触发事件
	hGlobal.event:event("LocalEvent_Pvp_Hero_StarLvup_Ok", tHero)
	
	--任务：累计击购买N个指定道具
	LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.buyItem, shopItemId, 1)
end

--通知客户端英雄解锁成功
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_HERO_UNLOCK] = function(tCmd)
	
	--print("hVar.PVP_RECV_TYPE.L2C_NOTICE_HERO_UNLOCK:")
	
	local shopItemId = tonumber(tCmd[1]) or 0
	local itemId = tonumber(tCmd[2]) or 0
	local gamecoin = tonumber(tCmd[3]) or 0
	local score = tonumber(tCmd[4]) or 0
	local tHero = hApi.Split(tCmd[5],":")
	
	local id = tonumber(tHero[1]) or 0
	local star = tonumber(tHero[2]) or 1
	local soulstone = tonumber(tHero[3]) or 0
	local totalStone = tonumber(tHero[4]) or 0

	local newHeroOk = false

	local HeroCard = hApi.GetHeroCardById(id)
	--如果不存在英雄则插入新英雄
	if not HeroCard and id > 0 then
		
		----填充本地存档
		--if score > 0 then
		--	LuaAddPlayerScore(-score)
		--end
		
		LuaAddNewHeroCard(id, star, 1, true)
		
		--如果剩余将魂大于0则增加将魂
		if soulstone > 0 then
			LuaAddHeroCardSoulStone(id, soulstone)
		end
		
		--存档
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		newHeroOk = true
	end
	
	--触发事件
	hGlobal.event:event("LocalEvent_Pvp_Hero_Unlock_Ok", newHeroOk, tHero)

	--任务：累计击购买N个指定道具
	LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.buyItem, shopItemId, 1)
end

--通知客户端当前战斗配置统计数据
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_BATTLE_STATISTICS] = function(tCmd)
	--print("hVar.PVP_RECV_TYPE.L2C_NOTICE_BATTLE_STATISTICS:",tCmd[1],tCmd[2],tCmd[3])
	
	local statisticsInfo = {}
	
	local strHero = tCmd[1]
	statisticsInfo.herocard = {}
	local tHero = hApi.Split(strHero, ":")
	if tHero then
		local heroNum = tonumber(tHero[1])
		local idx = 1
		for i = 1, heroNum do
			local tTmp = hApi.Split(tHero[idx + i], ",")
			local id = tonumber(tTmp[1]) or 0
			local num = tonumber(tTmp[2]) or 0
			if (id > 0) then
				statisticsInfo.herocard[#statisticsInfo.herocard+1] = {id = id, num = num,}
			end
		end
	end
	
	local strTower = tCmd[2]
	statisticsInfo.towercard = {}
	local tTower = hApi.Split(strTower, ":")
	if tTower then
		local towerNum = tonumber(tTower[1])
		local idx = 1
		for i = 1, towerNum do
			local tTmp = hApi.Split(tTower[idx + i], ",")
			local id = tonumber(tTmp[1]) or 0
			local num = tonumber(tTmp[2]) or 0
			if (id > 0) then
				statisticsInfo.towercard[#statisticsInfo.towercard+1] = {id = id, num = num,}
			end
		end
	end
	
	local strTactic = tCmd[3]
	statisticsInfo.tacticcard = {}
	local tTactic = hApi.Split(strTactic, ":")
	if tTactic then
		local tacticNum = tonumber(tTactic[1])
		local idx = 1
		for i = 1, tacticNum do
			local tTmp = hApi.Split(tTactic[idx + i], ",")
			local id = tonumber(tTmp[1]) or 0
			local num = tonumber(tTmp[2]) or 0
			if (id > 0) then
				statisticsInfo.tacticcard[#statisticsInfo.tacticcard+1] = {id = id, num = num,}
				--print(hVar.tab_stringT[id][1], num)
			end
		end
	end
	
	--总的兵符消耗
	statisticsInfo.tokenCost = tonumber(tCmd[4])
	
	--总游戏局数
	statisticsInfo.tokenWinnerCost = tonumber(tCmd[5])
	
	--总的胜利者兵符消耗
	statisticsInfo.totalSession = tonumber(tCmd[6])
	
	--排序算法
	local _CompareAB = function(ta, tb)
		if (ta.num ~= tb.num) then
			return (ta.num > tb.num)
		else
			return (ta.id < tb.id)
		end
	end
	table.sort(statisticsInfo.herocard, _CompareAB)
	table.sort(statisticsInfo.towercard, _CompareAB)
	table.sort(statisticsInfo.tacticcard, _CompareAB)
	
	--补齐未使用的英雄
	for k, v in ipairs(hVar.HERO_AVAILABLE_LIST) do
		local heroId = v.id + 100 --pvp英雄id加100
		
		local bExsted = false --是否存在
		for i = 1, #statisticsInfo.herocard, 1 do
			if (statisticsInfo.herocard[i].id == heroId) then
				bExsted = true --找到了
				break
			end
		end
		
		if (not bExsted) then
			statisticsInfo.herocard[#statisticsInfo.herocard+1] = {id = heroId, num = 0,}
		end
	end
	
	--补齐未使用的塔
	local towerlist = {}
	for i = 1, #hVar.TACTIC_UPDATE_JIANTA, 1 do
		towerlist[#towerlist+1] = hVar.TACTIC_UPDATE_JIANTA[i] --箭塔升级的分支战术技能卡
	end
	for i = 1, #hVar.TACTIC_UPDATE_FASHUTA, 1 do
		towerlist[#towerlist+1] = hVar.TACTIC_UPDATE_FASHUTA[i] --法术塔升级的分支战术技能卡
	end
	for i = 1, #hVar.TACTIC_UPDATE_PAOTA, 1 do
		towerlist[#towerlist+1] = hVar.TACTIC_UPDATE_PAOTA[i] --炮塔升级的分支战术技能卡
	end
	for k, v in ipairs(towerlist) do
		local towerId = v
		
		local bExsted = false --是否存在
		for i = 1, #statisticsInfo.towercard, 1 do
			if (statisticsInfo.towercard[i].id == towerId) then
				bExsted = true --找到了
				break
			end
		end
		
		if (not bExsted) then
			statisticsInfo.towercard[#statisticsInfo.towercard+1] = {id = towerId, num = 0,}
		end
	end
	
	--存储
	g_pvpStatisticsInfo = statisticsInfo
	
	--触发事件
	hGlobal.event:event("LocalEvent_Pvp_notice_battle_statistics", statisticsInfo)
end

--通知客户端兵种卡升级成功
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_ARMY_LVUP] = function(tCmd)
	
	--print("hVar.PVP_RECV_TYPE.L2C_NOTICE_ARMY_LVUP:")
	
	--local shopItemId = tonumber(tCmd[1]) or 0
	local itemId = tonumber(tCmd[1]) or 0
	local gamecoin = tonumber(tCmd[2]) or 0
	local score = tonumber(tCmd[3]) or 0
	local tTactic = hApi.Split(tCmd[4],":") --{[1]=id,[2]=debris,[3]=totalDebris,[4]=lv}
	
	local tacticId = tonumber(tTactic[1]) or 0
	local tacticLv = tonumber(tTactic[4]) or 0
	local tacticDebris = tonumber(tTactic[2]) or 0

	local addonesNum = tonumber(tTactic[5]) or 0
	local addones = {}
	local idx = 5
	for n = 1, addonesNum do
		addones[n] = hApi.String2Type(tTactic[idx + n], "|", false)
	end
	
	--填充本地存档
	if score > 0 then
		LuaAddPlayerScore(-score)
	end
	
	--触发事件
	hGlobal.event:event("LocalEvent_Pvp_Army_Lvup_Ok", tacticId, tacticLv, tacticDebris)
end

--通知刷新战术卡附加属性成功
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_ARMY_REFRESH_ADDONES] = function(tCmd)
	
	--print("hVar.PVP_RECV_TYPE.L2C_NOTICE_ARMY_REFRESH_ADDONES:")
	
	--local shopItemId = tonumber(tCmd[1]) or 0
	local itemId = tonumber(tCmd[1]) or 0
	local gamecoin = tonumber(tCmd[2]) or 0
	local score = tonumber(tCmd[3]) or 0
	local addonesIdx = tonumber(tCmd[4]) or 0
	local tTactic = hApi.Split(tCmd[5],":") --{[1]=id,[2]=debris,[3]=totalDebris,[4]=lv}
	
	local tacticId = tonumber(tTactic[1]) or 0
	local tacticLv = tonumber(tTactic[4]) or 0
	local tacticDebris = tonumber(tTactic[2]) or 0
	
	local addonesNum = tonumber(tTactic[5]) or 0
	local addones = {}
	local idx = 5
	for n = 1, addonesNum do
		addones[n] = hApi.String2Type(tTactic[idx + n], "|", false)
	end
	
	--填充本地存档
	if score > 0 then
		LuaAddPlayerScore(-score)
	end
	
	--触发事件
	hGlobal.event:event("LocalEvent_Pvp_Army_Refresh_AddOnes_Ok", tacticId, addonesIdx, addonesNum, addones)
end

--通知新增战术卡附加属性成功
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_ARMY_NEW_ADDONES] = function(tCmd)
	
	--print("hVar.PVP_RECV_TYPE.L2C_NOTICE_ARMY_NEW_ADDONES:")
	
	--local shopItemId = tonumber(tCmd[1]) or 0
	local itemId = tonumber(tCmd[1]) or 0
	local gamecoin = tonumber(tCmd[2]) or 0
	local score = tonumber(tCmd[3]) or 0
	local addonesIdx = tonumber(tCmd[4]) or 0
	local tTactic = hApi.Split(tCmd[5],":") --{[1]=id,[2]=debris,[3]=totalDebris,[4]=lv}
	
	local tacticId = tonumber(tTactic[1]) or 0
	local tacticLv = tonumber(tTactic[4]) or 0
	local tacticDebris = tonumber(tTactic[2]) or 0
	
	local addonesNum = tonumber(tTactic[5]) or 0
	local addones = {}
	local idx = 5
	for n = 1, addonesNum do
		addones[n] = hApi.String2Type(tTactic[idx + n], "|", false)
	end
	
	--填充本地存档
	if score > 0 then
		LuaAddPlayerScore(-score)
	end
	
	--触发事件
	hGlobal.event:event("LocalEvent_Pvp_Army_New_AddOnes_Ok", tacticId, addonesIdx, addonesNum, addones)
end


--通知还原战术卡附加属性成功
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_ARMY_RESTORE_ADDONES] = function(tCmd)
	
	--print("hVar.PVP_RECV_TYPE.L2C_NOTICE_ARMY_RESTORE_ADDONES:")
	
	--local shopItemId = tonumber(tCmd[1]) or 0
	local itemId = tonumber(tCmd[1]) or 0
	local gamecoin = tonumber(tCmd[2]) or 0
	local score = tonumber(tCmd[3]) or 0
	local addonesIdx = tonumber(tCmd[4]) or 0
	local tTactic = hApi.Split(tCmd[5],":") --{[1]=id,[2]=debris,[3]=totalDebris,[4]=lv}
	
	local tacticId = tonumber(tTactic[1]) or 0
	local tacticLv = tonumber(tTactic[4]) or 0
	local tacticDebris = tonumber(tTactic[2]) or 0

	local addonesNum = tonumber(tTactic[5]) or 0
	local addones = {}
	local idx = 5
	for n = 1, addonesNum do
		addones[n] = hApi.String2Type(tTactic[idx + n], "|", false)
		--print("addones[n]:", addones[n])
	end
	
	--填充本地存档
	if score > 0 then
		LuaAddPlayerScore(-score)
	end
	
	--触发事件
	hGlobal.event:event("LocalEvent_Pvp_Army_Restore_AddOnes_Ok", tacticId, addonesIdx, addonesNum, addones)
end


--匹配房间列表返回
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_REQUEST_MATCH_LIST] = function(tCmd)
	--print("hVar.PVP_RECV_TYPE.L2C_REQUEST_MATCH_LIST:")
	
	local matchNum = tCmd[1]
	--print("matchNum:", matchNum)
	local matchList = {}
	for i = 1, matchNum do
		local matchTitle = tCmd[1 + i]
		local tMatchTitle = hApi.Split(matchTitle,":")
		local matchId = tonumber(tMatchTitle[1]) or 0
		local matchCfgId = tonumber(tMatchTitle[2]) or 0
		matchList[#matchList + 1] = {id = matchId, rCfgId = matchCfgId}		--匹配房间的id, 匹配房间对应的tab_roomcfg的索引（匹配成功后会创建该索引类型的房间）
		--print("matchList:", matchId, matchCfgId)
	end
	hGlobal.event:event("LocalEvent_Pvp_MatchList", matchList)
end

--玩家匹配信息返回
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_MATCHUSER_INFO] = function(tCmd)
	--print("hVar.PVP_RECV_TYPE.L2C_NOTICE_MATCHUSER_INFO:")
	
	local matchUserInfo = {}
	
	--基本信息
	matchUserInfo.id = tonumber(tCmd[1])			--内存id
	matchUserInfo.dbId = tonumber(tCmd[2])			--数据库id
	matchUserInfo.state = tonumber(tCmd[3])			--当前匹配状态( 1进入匹配 2匹配成功 3在游戏中 )
	matchUserInfo.matchTime = tonumber(tCmd[4])		--用户开始匹配时间(时间戳)
	
	--print("matchUserInfo.id:",matchUserInfo.id)
	--print("matchUserInfo.dbId:",matchUserInfo.dbId)
	--print("matchUserInfo.state:",matchUserInfo.state)
	--print("matchUserInfo.matchTime:",matchUserInfo.matchTime)
	
	hGlobal.event:event("LocalEvent_Pvp_MatchUserInfo", matchUserInfo)
end

--取消匹配成功返回
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_REQUEST_CANCEL_MATCH] = function(tCmd)
	--print("hVar.PVP_RECV_TYPE.L2C_REQUEST_CANCEL_MATCH:")

	hGlobal.event:event("LocalEvent_Pvp_CancelMatchOk")
end

--擂台赛
--广播擂台赛创建房间信息
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_ARENA_CREATEROOM_INFO] = function(tCmd)
	local rmdbid = tonumber(tCmd[1]) or 0
	local rmName = tCmd[2]
	
	hGlobal.event:event("LocalEvent_Pvp_CreateArenaRoom_Info", rmdbid, rmName)
end

--擂台赛
--广播擂台赛游戏结果信息
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_ARENA_RESULT_INFO] = function(tCmd)
	
	local sessionType = tonumber(tCmd[1]) or 1			--1擂台赛 2铜雀台
	
	local pResultList = {}
	local pRIdx = 1
	
	if tCmd and type(tCmd) == "table" then
		
		for i = 1, #tCmd, 1 do
			local tmpPInfo = {}
			local playerInfo = tCmd[pRIdx + i]
			local tPInfo = hApi.Split(playerInfo or "",":")
			if tPInfo then
				tmpPInfo.dbid = tonumber(tPInfo[1]) or 0			--用户dbid
				tmpPInfo.name = tPInfo[2]					--用户姓名
				tmpPInfo.result = tonumber(tPInfo[3]) or -1			--游戏结果
				
				pResultList[#pResultList + 1] = tmpPInfo
			end
		end
	end
	
	--print("广播擂台赛、铜雀台游戏结果信息", #pResultList)
	hGlobal.event:event("LocalEvent_Pvp_ArenaResult_Info", pResultList, sessionType)
end

--获取当前房间开放时间段
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_REQUEST_ROOM_OPEN_TIME] = function(tCmd)
	--开放时间段
	local openTime = {
		normal = {},
		arena = {},
	}
	
	local roomCfgId = tonumber(tCmd[1]) or 0
	local normalNum = tonumber(tCmd[2]) or 0
	local normalIdx = 2
	
	--竞技房
	for i = 1, normalNum do
		local normalInfo = tCmd[normalIdx + i]
		local tNormalInfo = hApi.Split(normalInfo,"|")
		openTime.normal[#openTime.normal + 1] = {beginTime = tNormalInfo[1], endTime = tNormalInfo[2]}
		--print(tNormalInfo[1], tNormalInfo[2])
	end
	
	--娱乐房
	local arenaIdx = normalIdx + normalNum + 1
	local arenaNum = tonumber(tCmd[arenaIdx]) or 0
	for i = 1, arenaNum do
		local arenaInfo = tCmd[arenaIdx + i]
		local tArenaInfo = hApi.Split(arenaInfo,"|")
		openTime.arena[#openTime.arena + 1] = {beginTime = tArenaInfo[1], endTime = tArenaInfo[2]}
	end
	
	--存储
	g_pvp_openTime = openTime
end

--获取铜雀台配置信息
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_REQUEST_GET_PVE_MULTI_CFG] = function(tCmd)
	
	local roomCfg = {}
	
	local challengeMaxCount = tonumber(tCmd[1]) or 0			--当前的剩余次数
	local challengeRefreshTime = tCmd[2]					
	
	local roomCfgId = tonumber(tCmd[3]) or 0
	if roomCfgId > 0 then
		
		roomCfg.roomCfgId = roomCfgId
		roomCfg.challengeMaxCount = challengeMaxCount
		roomCfg.challengeRefreshTime = challengeRefreshTime
		
		--刷新类型 1周 2半月（暂无） 3月（暂无）
		local refreshType = tonumber(tCmd[4]) or 0
		local challengeMaxCountCfg = tonumber(tCmd[5]) or 0		--配置的最大次数
		roomCfg.challengeMaxCountCfg = challengeMaxCountCfg
		
		--当前生效的战术技能卡
		local tacticNum = tonumber(tCmd[6]) or 0
		local tacticIdx = 6
		roomCfg.tacticList = {}
		for i = 1, tacticNum do
			local tacticInfo = tCmd[tacticIdx + i]
			local tTacticInfo = hApi.Split(tacticInfo,":")
			
			roomCfg.tacticList[#roomCfg.tacticList + 1] = {tonumber(tTacticInfo[1]) or 0, tonumber(tTacticInfo[2]) or 0}
		end
		
		--当前关卡奖励的道具
		local rewardShowIdx = tacticIdx + tacticNum + 1
		local rewardShowNum = tonumber(tCmd[rewardShowIdx]) or 0
		roomCfg.rewardShowList = {}
		for i = 1, rewardShowNum do
			local rewardShowInfo = tCmd[rewardShowIdx + i]
			local tRewardShowInfo = hApi.Split(rewardShowInfo,":")
			
			roomCfg.rewardShowList[#roomCfg.rewardShowList + 1] = {tonumber(tRewardShowInfo[1]) or 0, tonumber(tRewardShowInfo[2]) or 0, tonumber(tRewardShowInfo[3]) or 0, tonumber(tRewardShowInfo[4]) or 0}
		end
	end
	
	--触发事件: 铜雀台生效配置信息
	hGlobal.event:event("LocalEvent_PvpMulty_RoomTakeEffectCfg", roomCfg)
end

--通知铜雀台获得的奖励
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_NOTICE_PVEMULTI_REWARD] = function(tCmd)
	--print("通知铜雀台获得的奖励")
	--for i = 1, #tCmd do
	--	print("tCmd["..i.."]:"..tCmd[i])
	--end
	
	local rewardInfo = {}
	
	--获得的奖励列表
	local getRewardNum = tonumber(tCmd[1]) or 0	--获得的奖励数量
	rewardInfo.getRewardNum = getRewardNum
	
	local getRewardIdx = 1
	if getRewardNum > 0 then
		rewardInfo.getIdxList = {}
		for i = 1, getRewardNum do
			rewardInfo.getIdxList[#(rewardInfo.getIdxList) + 1] = tonumber(tCmd[getRewardIdx + i]) or 0
		end
	end
	
	--所有奖励的信息
	local rewardIdx = getRewardIdx + getRewardNum + 1
	local rewardNum = tonumber(tCmd[rewardIdx]) or 0
	local reward = {}
	if rewardNum > 0 then
		rewardInfo.allRewardNum = rewardNum
		rewardInfo.allReward = {}
		for i = 1, rewardNum do
			
			local strRewardInfo = tCmd[rewardIdx + i] or ""
			local tRewardInfo = hApi.Split(strRewardInfo,":")
			rewardInfo.allReward[#rewardInfo.allReward + 1] = tRewardInfo
			
			--筛选出奖励的信息
			local canGet = false
			if rewardInfo.getIdxList then
				for n = 1, #rewardInfo.getIdxList do
					if i == rewardInfo.getIdxList[n] then
						canGet = true
						break
					end
				end
			else
				canGet = true
			end
			
			if canGet then
				reward[#reward + 1] = tRewardInfo
			end
		end
	end
	
	--如果获得的奖励数量大于0，则获取奖励
	if getRewardNum > 0 and rewardNum > 0 then
		--填充本地存档
		--hApi.GetReawrdGift(reward, getRewardNum)
	end
	
	--触发事件: 铜雀台获得抽奖奖励
	hGlobal.event:event("localEvent_ShowChoiceAwardFrm", rewardInfo)
end

--获取铜雀台玩家战绩排行返回
PluaNetCmd[hVar.PVP_RECV_TYPE.L2C_REQUEST_GET_PVE_MULTI_LOG] = function(tCmd)
	
	local pveMultiLog = {}
	local cFirstIdx = tonumber(tCmd[1]) or 0		--起始条目idx
	local cNum = tonumber(tCmd[2]) or 0			--条目数
	
	local sNum = tonumber(tCmd[3]) or 0
	local sIdx = 3
	
	pveMultiLog.cFirstIdx = cFirstIdx --起始条目idx
	pveMultiLog.cNum = cNum --条目数
	pveMultiLog.num = sNum --查询到的数量
	
	for i = 1, sNum do
		local sId = tonumber(tCmd[sIdx + 1]) or 0
		local sGameTime = tonumber(tCmd[sIdx + 2]) or 0
		local sInfo = tCmd[sIdx + 3]
		
		pveMultiLog[#pveMultiLog + 1] = {}
		pveMultiLog[#pveMultiLog].id = sId
		pveMultiLog[#pveMultiLog].gametime = sGameTime
		pveMultiLog[#pveMultiLog].playerInfo = {}
		--pveMultiLog[#pveMultiLog].playerInfo.hero = {}
		--pveMultiLog[#pveMultiLog].playerInfo.tower = {}
		
		
		local tInfo = hApi.Split(sInfo or "", ":")
		
		local playerNum = tonumber(tInfo[1]) or 0
		local pIdx = 1
		local playerInfo = pveMultiLog[#pveMultiLog].playerInfo
		
		--local hero = pveMultiLog[#pveMultiLog].playerInfo.hero
		--local tower = pveMultiLog[#pveMultiLog].playerInfo.tower
		
		for j = 1, playerNum do
			
			playerInfo[#playerInfo + 1] = {}
			local p = playerInfo[#playerInfo]
			
			
			p.udbid = tonumber(tInfo[pIdx + 1]) or 0
			p.name = tInfo[pIdx + 2] or 0
			
			p.hero = {}
			p.tower = {}
			
			local hero = p.hero
			local tower = p.tower
			
			local heroIdx = pIdx + 3
			local heroNum = tonumber(tInfo[heroIdx]) or 0
			for n = 1, heroNum do
				local heroInfo = tInfo[heroIdx + n]
				local tHeroInfo = hApi.Split(heroInfo or "", "|")
				
				hero[#hero + 1] = {}
				
				local hInfo = hero[#hero]
				
				hInfo.id = tonumber(tHeroInfo[1]) or 0
				hInfo.lv = tonumber(tHeroInfo[2]) or 0
				hInfo.star = tonumber(tHeroInfo[3]) or 0
				
				local equipIdx = 4
				local equipNum = tonumber(tHeroInfo[equipIdx])
				
				
				hInfo.equip = {}
				
				for m = 1, equipNum do
					
					local equipInfo = tHeroInfo[equipIdx + m]
					
					local tEquip = hApi.Split(equipInfo or "", "_")
					
					
					
					hInfo.equip[#hInfo.equip + 1] = {}
					hInfo.equip[#hInfo.equip].id = tonumber(tEquip[1]) or 0
					local attrNum = tonumber(tEquip[2]) or 0
					local attrIdx = 2
					hInfo.equip[#hInfo.equip].attr = {}
					local attr = hInfo.equip[#hInfo.equip].attr
					for x = 1, attrNum do
						attr[#attr + 1] = tEquip[attrIdx + x]
					end
				end
				
				
			end
			
			local towerIdx = heroIdx + heroNum + 1
			local towerNum = tonumber(tInfo[towerIdx]) or 0
			for n = 1, towerNum do
				local towerInfo = tInfo[towerIdx + n]
				
				tower[#tower + 1] = {}
				
				local tTower = hApi.Split(towerInfo or "", "|")
				
				tower[#tower].id = tonumber(tTower[1]) or 0
				tower[#tower].lv = tonumber(tTower[2]) or 0
				tower[#tower].ex = tonumber(tTower[3]) or 0
				
				
			end
			
			pIdx = towerIdx + towerNum
		end
		
		sIdx = sIdx + 3
	end
	
	--调试输出
	--print(hApi.serialize(pveMultiLog))
	--for i = 1, #tCmd do
	--	print("tCmd[" .. i .. "]=" .. tCmd[i])
	--	print()
	--end
	
	--返回数据格式
	--pveMultiLog = {
	--	[1] = {
	--		id = 123,
	--		gametime = 234235,
	--		playerInfo = {
	--			[1] = {
	--				udbid = 23535,
	--				name = "abc",
	--				hero = {
	--					[1] =
	--					{
	--						id = 12325,
	--						lv = 15,
	--						star = 1,
	--						equip = 
	--						{
	--							[1] = {
	--								id = 123,
	--								attr = {
	--									"atk5",
	--									"as5",
	--									"cr5"
	--								},
	--							},
	--							[2] = {
	--								id = 123,
	--								attr = {
	--									"atk5",
	--									"as5",
	--									"cr5"
	--								},
	--							},
	--							[3] = {
	--								id = 123,
	--								attr = {
	--									"atk5",
	--									"as5",
	--									"cr5"
	--								},
	--							},
	--							[4] = {
	--								id = 123,
	--								attr = {
	--									"atk5",
	--									"as5",
	--									"cr5"
	--								},
	--							},
	--						},
	--					},
	--					[2] = ...
	--				},
	--				tower = {
	--					[1] = {
	--						id = 123,
	--						lv = 4,
	--						ex = 0
	--					},
	--					[2] = {
	--						id = 123,
	--						lv = 4,
	--						ex = 0
	--					},
	--				},
	--			},
	--			[2] = {...},
	--			
	--		},
	--	},
	--	[2] = {...},
	--}
	
	--优化: 删除玩家相同的数据
	local pveMultiLogReslut = {} --返回值
	local playerRankList = {} --玩家排行表
	for i = 1, sNum, 1 do
		local id = pveMultiLog[i].id
		local gametime = pveMultiLog[i].gametime
		local playerInfo = pveMultiLog[i].playerInfo
		local nSamePlayerNum = 0 --相同玩家数量
		local nTotalPlayerNum = #playerInfo --总玩家数量
		for p = 1, nTotalPlayerNum, 1 do
			local tp = playerInfo[p]
			local udbid = tp.udbid --玩家dibid
			if playerRankList[udbid] then
				--相同玩家数量+1
				nSamePlayerNum = nSamePlayerNum + 1
				--print(i, "相同玩家数量+1", udbid)
			else
				--新存玩家数据
				playerRankList[udbid] = {i, gametime}
				--print(i, "新存玩家数据", udbid, i)
			end
		end
		
		--存在不相同的玩家，才认为是有效的数据
		if (nSamePlayerNum < nTotalPlayerNum) then
			pveMultiLogReslut[#pveMultiLogReslut+1] = pveMultiLog[i]
		end
	end
	
	pveMultiLogReslut.cFirstIdx = cFirstIdx --起始条目idx
	pveMultiLogReslut.cNum = cNum --条目数
	pveMultiLogReslut.num = #pveMultiLogReslut --查询到的数量
	
	local udbidMe = xlPlayer_GetUID()
	pveMultiLogReslut.rankingMe = playerRankList[udbidMe] and playerRankList[udbidMe][1] or -1 --我的排名
	pveMultiLogReslut.gametimeMe = playerRankList[udbidMe] and playerRankList[udbidMe][2] or -1 --我的通关时间
	
	--处理: 只取前10条
	if (pveMultiLogReslut.num > 10) then
		pveMultiLogReslut.num = 10
	end
	
	--触发事件: 铜雀台排行榜信息返回
	hGlobal.event:event("localEvent_ShowPvpEndlessBillboard", pveMultiLogReslut)
end