--*************************************************************
-- Copyright (c) 2016, XinLine Co.,Ltd
-- Author: Red
-- Detail: 游戏服务器相关模块
---------------------------------------------------------------

--世界聊天消息最大数量
hVar.CHAT_MAX_LENGTH_WORLD = 100

--私聊消息最大数量
hVar.CHAT_MAX_LENGTH_PRIVATE = 30

--私聊好友最大人数（管理员）
hVar.CHAT_MAX_USERNUM_PRIVATE_GM = 30

--私聊同一个好友每天最大次数
hVar.CHAT_MAX_COUNT_PRIVATE = 3

--工会聊天消息最大数量（仅限玩家聊天的数量，工会系统消息数量当前全部保留）
hVar.CHAT_MAX_LENGTH_GROUP = 60

--本地聊天防刷屏的检测时间范围（秒）
hVar.CHAT_ANTI_FLOODSCREEN_TIME = 300

--本地聊天防刷屏的检测语句频次
hVar.CHAT_ANTI_FLOODSCREEN_COUNT = 10

--本地聊天防刷屏一分钟内最大打字次数
hVar.CHAT_ONEMINUTE_MAXNUM = 12

--聊天频道类型定义
hVar.CHAT_TYPE =
{
	WORLD = 0,		--世界频道
	INVITE = 1,		--邀请频道
	PRIVATE = 2,		--私聊频道
	GROUP = 3,		--工会频道
	COUPLE = 4,		--组队频道
}

--消息类型定义
hVar.MESSAGE_TYPE =
{
	TEXT = 0,					--文本消息
	TEXT_SYSTEM_NOTICE = 1,				--系统文本提示消息（世界）
	TEXT_SYSTEM_FORBIDDEN = 2,			--系统文本禁言消息（世界）
	PRIVATE_INVITE = 3,				--私聊好友验证消息
	PRIVATE_INVITE_ACCEPT = 4,			--私聊通过消息
	PRIVATE_INVITE_REFUSE = 5,			--私聊拒绝消息
	PRIVATE_DELETE = 6,				--私聊删除好友
	IMAGE = 7,					--图片消息
	VOICE = 8,					--语音消息
	VIDEO = 9,					--视频消息
	LINK = 10,					--超链接消息
	TEXT_SYSTEM_GROUP_NOTICE = 11,			--军团系统文本提示消息
	TEXT_SYSTEM_GROUP_WARNING = 12,			--军团系统文本警告消息
	TEXT_SYSTEM_GROUP_TODAY = 13,			--军团系统文本当日消息
	TEXT_SYSTEM_GROUP_REDPACKET_SEND = 14,		--军团发红包
	TEXT_SYSTEM_GROUP_REDPACKET_RECEIVE = 15,	--军团收红包
	TEXT_SYSTEM_FORBIDDEN_ALL = 16,			--系统文本全员禁言消息（世界）
	TEXT_SYSTEM_CANCEL_FORBIDDEN_ALL = 17,		--系统文本取消全员禁言消息（世界）
	TEXT_SYSTEM_WARNING = 18,			--系统文本警告消息（世界）
	TEXT_SYSTEM_USER_BATTLE = 19,			--系统文本玩家关卡通关消息（世界）
	TEXT_SYSTEM_PAY_REDPACKET_SEND = 20,		--发支付（土豪）红包（世界）
	TEXT_SYSTEM_PAY_REDPACKET_RECEIVE = 21,		--收支付（土豪）红包（世界）
	TEXT_SYSTEM_ADVISE = 22,			--系统聊天忠告文本消息（世界）
	TEXT_SYSTEM_ADVISE2 = 23,			--系统聊天忠告2文本消息（世界）
	INVITE_GROUP = 24,				--军团邀请函消息
	INVITE_BATTLE = 25,				--组队副本邀请
}

--私聊好友验证操作结果(可交互事件的交互结果)
hVar.PRIVATE_INVITE_TYPE =
{
	NONE = 0,					--等待验证
	ACCEPT = 1,					--通过
	REFUSE = 2,					--拒绝
	REFUSEBY = 3,				--被对方拒绝
	DELETE = 4,					--删除
	DELETEBY = 5,				--被删除
}

--军团每日系统消息类型(可交互事件的交互结果)
hVar.GROUP_MESSAGE_TODAY_TYPE =
{
	NONE = 0,				--无
	BATTLE_IRON = 16,			--成功挑战铁副本
	BATTLE_WOOD = 17,			--成功挑战木材副本
	BATTLE_FOOD = 18,			--成功挑战粮食副本
}

--红包类型(可交互事件的交互结果)
hVar.RED_PACKET_TYPE =
{
	GROUP_SEND = 20,			--发军团红包
	GROUP_RECEIVE = 21,			--收军团红包
	PAY_SEND = 22,				--发支付（土豪）红包
	PAY_RECEIVE = 23,			--收支付（土豪）红包
}

--军团邀请函类型(可交互事件的交互结果)
hVar.GROUP_INVITE_TYPE =
{
	GROUP_INVITE_SEND = 24,			--发送军团邀请函
}

--组队副本邀请类型(可交互事件的交互结果)
hVar.BATTLE_INVITE_TYPE =
{
	BATTLE_INVITE_SEND_MLBK = 25,		--发送组队副本邀请（魔龙宝库）
	BATTLE_INVITE_SEND_GROUP = 26,		--发送组队副本邀请（秘境试炼）
	BATTLE_INVITE_SEND_GROUP_STATION = 27,	--发送组队副本邀请（秘境试炼驻守模式）
	BATTLE_INVITE_SEND_RZWD = 28,		--发送组队副本邀请（人族无敌）
	BATTLE_INVITE_SEND_SWJG2 = 29,		--发送组队副本邀请（双人守卫剑阁）
	BATTLE_INVITE_SEND_XZXD = 30,		--发送组队副本邀请（仙之侠道）
}

--聊天组队副本的配置参数
hVar.tChatBattleIcon =
{
	--[cfgId] = {敌人的名字, 图标, 图标缩放, 可交互事件的类型, 地图名, 兵符, 是否为军团副本, 解锁需要通关的关卡名, 未解锁的提示文字,}
	
	--魔龙宝库
	[2] = {enemyName = "__TEXT_PVP_DRAGON", icon = "ui/icon_mlbk.png", scale = 0.8, interactType = hVar.BATTLE_INVITE_TYPE.BATTLE_INVITE_SEND_MLBK,
		mapName = "world/td_wj_003", pvpcoin = 0, isgroup = 1,
		unlockMap = "world/td_109_xpzz", unlockText = "__TEXT_MOLONGBAOKU_archiLock",},
	
	--军团秘境试炼
	[8] = {enemyName = "__TEXT_PVP_GROUP_DRAGON", icon = "icon/item/item_treasure01.png", scale = 1.0, interactType = hVar.BATTLE_INVITE_TYPE.BATTLE_INVITE_SEND_GROUP,
		mapName = "world/td_jt_004", pvpcoin = 0, isgroup = 1,
		unlockMap = "world/td_109_xpzz", unlockText = "__TEXT_MOLONGBAOKU_archiLock",},
	
	--军团秘境试炼（驻守模式）
	[9] = {enemyName = "__TEXT_PVP_GROUP_DRAGON", icon = "icon/item/item_treasure01.png", scale = 1.0, interactType = hVar.BATTLE_INVITE_TYPE.BATTLE_INVITE_SEND_GROUP_STATION,
		mapName = "world/td_jt_004", pvpcoin = 0, isgroup = 1,
		unlockMap = "world/td_109_xpzz", unlockText = "__TEXT_MOLONGBAOKU_archiLock",},
	
	--人族无敌
	[10] = {enemyName = "__TEXT_PVP_RENZUWUD", icon = "UI:RZWD", scale = 1.0, interactType = hVar.BATTLE_INVITE_TYPE.BATTLE_INVITE_SEND_RZWD,
		mapName = "world/td_wj_007", pvpcoin = hVar.ENDLESS_BATTLE_COST_PVPCOIN_RENZUWUD, isgroup = 0,
		unlockMap = "world/td_109_xpzz", unlockText = "__TEXT_RENZUWUDI_archiLock",},
	
	--双人守卫剑阁
	[13] = {enemyName = "__TEXT_PVP_SWJG", icon = "UI:SWJG2", scale = 1.0, interactType = hVar.BATTLE_INVITE_TYPE.BATTLE_INVITE_SEND_SWJG2,
		mapName = "world/td_swjg2", pvpcoin = hVar.SHOUWEIJIANGE2_BATTLE_COST_PVPCOIN, isgroup = 0,
		unlockMap = "world/td_416_cbzz", unlockText = "__TEXT_SHOUWEIJIANGE2_archiLock",},
	
	--仙之侠道
	[14] = {enemyName = "__TEXT_PVP_SWJG", icon = "UI:SWJG2", scale = 1.0, interactType = hVar.BATTLE_INVITE_TYPE.BATTLE_INVITE_SEND_XZXD,
		mapName = "world/td_swjg2", pvpcoin = hVar.SHOUWEIJIANGE2_BATTLE_COST_PVPCOIN, isgroup = 0,
		unlockMap = "world/td_416_cbzz", unlockText = "__TEXT_SHOUWEIJIANGE2_archiLock",},
}

--军团成员权限
hVar.GROUP_MEMBER_AUTORITY =
{
	NONE = 0,				--无
	ADMIN = 99,				--会长
	ASSISTANT = 98,				--助理
	ASSISTANT_SYSTEM = 97,			--助理（系统生成）
	NORMAL = 1,				--普通成员
	APPLY = 0,				--申请中
}

--军团市场每天可兑换战术卡最大次数、消耗游戏币、获得军团币数量
hVar.GROUP_ECHANGE_TACTICCARD_NUM = 20
hVar.GROUP_ECHANGE_TACTICCARD_COST_GAMECOIN = 0
hVar.GROUP_ECHANGE_TACTICCARD_COIN = 5

--军团市场每天可兑换英雄将魂最大次数、消耗游戏币、获得军团币数量
hVar.GROUP_ECHANGE_HERODEBRIS_NUM = 10
hVar.GROUP_ECHANGE_HERODEBRIS_COST_GAMECOIN = 0
hVar.GROUP_ECHANGE_HERODEBRIS_COIN = 15

--军团币兑换宝箱需要数量
hVar.GROUP_COIN_ECHANGE_CHEST_NUM = 100

--军团每日领奖需要完成的单人副本次数
hVar.GROUP_DAYEWARD_SINGLE_BATTLE_COUNT = 1

--军团每日领奖需要完成的组队副本次数
hVar.GROUP_DAYEWARD_COUPLE_BATTLE_COUNT = 1

--军团会长每日购买副本最大次数
hVar.GROUP_BUY_BATTLE_MAXCOUNT = 1

--军团购买次数需要的游戏币系数N（游戏币=军团总人数*N）
hVar.GROUP_BUY_BATTLE_MULTYPLICATE_IRON = 5
hVar.GROUP_BUY_BATTLE_MULTYPLICATE_WOOD = 10
hVar.GROUP_BUY_BATTLE_MULTYPLICATE_FOOD = 10

--军团币开宝箱需要数量
hVar.GROUP_ECHANGE_CHEST_NUM = 100

--[[
--军团宝箱能开出的英雄将魂
hVar.GROUP_CHEST_OPEN_HERODEBRIS_PROBABLITY = 20 --几率
hVar.GROUP_CHEST_OPEN_HERODEBRIS =
{
	--英雄id、碎片道具id，抽卡获得的碎片数量（最小数量、最大数量）、最多累计可获得的碎片数量（达到此值后无法再抽到该英雄的碎片）
	[1] = {id = 18034, heroDebrisId = 10231, num = {1, 2,}, maxDebris = 800,}, --孙坚
	[2] = {id = 18027, heroDebrisId = 10235, num = {1, 2,}, maxDebris = 800,}, --董卓
}
]]

--军团红包
hVar.CHAT_GROUP_RED_PACKET_SHOPITEM = --商品id
{
	[1] = 399, --军团红包（小）
	[2] = 400, --军团红包（大）
}

--军团助理每日权限
hVar.CHAT_GROUP_ASSITANT_OP_COUNT_MAX = 2 --助理每日操作审核人员最大次数
hVar.CHAT_GROUP_ASSITANT_KICK_COUNT_MAX = 2 --助理每日踢人最大次数

--工会操作错误码
hVar.GROUPSERVER_ERROR_TYPE =
{
	FAILURE = 0,			--操作失败
	SUCCESS = 1,			--操作成功
	NO_AUTHORITY = 1001,	--您没有权限进行此操作
	NO_VALID_MSGID = 1002,	--无效的消息
	NO_VALID_UID = 1003,	--无效的玩家
	NO_USER_INIT = 1004,	--玩家未初始化
	NO_VALID_PARAM = 1005,	--参数不合法
	NO_VALID_FOBIDDEN = 1006,	--您被禁言无法发送消息
	NO_VALID_PRIVATE_FOBIDDEN = 1007,	--您被禁言无法发起私聊
	NO_CHAT_PRIVATE_TYPE = 1008,--只能发送私聊消息
	NO_CHAT_PRIVATE_FRIEND = 1009,--对方不在您的私聊列表里
	NO_CHAT_PRIVATE_FRIEND_ME = 1010,--您不在对方的私聊列表里
	NO_CHAT_PRIVATE_INVITE = 1011,--等待对方通过私聊请求
	NO_CHAT_PRIVATE_USER_OFFLINE = 1012,--对方不在线，无法发起私聊
	NO_CHAT_PRIVATE_USER_NUMMAX = 1013,--您的私聊人数已达上限，无法发起私聊
	NO_CHAT_PRIVATE_USER_NUMMAX_ME = 1014,--对方私聊人数已达上限，无法发起私聊
	NO_CHAT_PRIVATE_USER_SAMEME = 1015,--不能和自己私聊
	NO_CHAT_PRIVATE_INVITE_SAME = 1016,--不能重复发送私聊请求
	NO_CHAT_PRIVATE_INVITE_OP_REMOVE = 1017,--对方已关闭和你的私聊
	NO_CHAT_PRIVATE_INVITE_OP_REMOVE_ME = 1018,--您已将对方删除
	NO_CHAT_PRIVATE_INVITE_OP_REFUSE = 1019,--对方已拒绝您的私聊请求
	NO_CHAT_PRIVATE_INVITE_OP_REFUSE_ME = 1020, --您已拒绝对方的私聊请求
	NO_CHAT_PRIVATE_INVITE_MAXCOUNT = 1021, --您今日请求私聊该玩家的次数达到上限
	NO_GROUP_NOT_IN_GROUP = 1022, --您还未加入军团
	NO_GROUP_INVALID_GROUP = 1023, --您不在此军团里
	NO_GROUP_DISSOLUTION_GROUP = 1024, --该军团不存在或已解散
	NO_GROUP_USER_NOT_JOIN = 1025, --玩家未加入军团
	NO_GROUP_KICK_24HOUR = 1026, --玩家加入军团24小时以上才能移除
	NO_GROUP_KICK_24HOUR_NODONATE = 1027, --玩家最近24小时内无贡献度才能移除
	NO_GROUP_LEAVE_24HOUR = 1028, --加入军团24小时以上才能退出
	NO_GROUP_DISSOLUTION_24HOUR = 1029, --加入军团24小时以上才能解散
	NO_GROUP_OPERATION_SELF_INVALID = 1030, --会长不能对自己操作
	NO_GROUP_CREATE_24HOUR = 1031, --退出军团24小时以上才能创建
	NO_GROUP_JOIN_24HOUR = 1032, --退出军团24小时以上才能申请
	NO_GROUP_NOT_ENOUGH_GAMECOIN = 1033, --您没有足够的游戏币
	NO_GROUP_JOIN_OR_SUBMIT_GROUP = 1034, --您已加入或申请军团
	NO_GROUP_GROUPNAME_SAME = 1035, --您输入的军团名已存在
	NO_GROUP_MENBER_NUM_MAX = 1036, --军团人数已满
	NO_GROUP_EXCHANGE_TACTIC_DEBIRS_MAXCOUNT = 1037, --今日捐献战术卡碎片次数已用完
	NO_GROUP_EXCHANGE_TACTIC_DEBIRS_INVALID = 1038, --无效的战术卡碎片
	NO_GROUP_EXCHANGE_TACTIC_DEBIRS_NUMERROR = 1039, --战术卡碎片不足
	NO_GROUP_EXCHANGE_HERO_DEBIRS_MAXCOUNT = 1040, --今日捐献英雄将魂次数已用完
	NO_GROUP_EXCHANGE_HERO_DEBIRS_INVALID = 1041, --无效的英雄将魂
	NO_GROUP_EXCHANGE_HERO_DEBIRS_NUMERROR = 1042, --英雄将魂不足
	NO_GROUP_BUY_BATTLE_MAXCOUNT = 1043, --今日购买次数已达上限
	NO_GROUP_SEND_RED_PACKET_MAXCOUNT = 1044, --今日发红包次数已达上限
	NO_CHAT_DELETE_MSGTYPE = 1045, --此类型消息不能删除
	NO_GROUP_RED_PACKET_INVALID = 1046, --该红包不存在或已过期
	NO_GROUP_RECEIVE_RED_PACKET_EMYPT = 1047, --该红包已全部领完
	NO_GROUP_RED_PACKET_SEND_24HOUR = 1048, --加入军团24小时以上才能发红包
	NO_GROUP_RED_PACKET_RECEIVE_24HOUR = 1049, --加入军团24小时以上才能领红包
	NO_GROUP_RED_PACKET_RECEIVE_MAXCOUNT = 1050, --您已领取过该红包
	NO_GROUP_JOIN_POWER_NUM_MAX = 1051, --该军团目前已有太多申请人数
	NO_VALID_FOBIDDEN_ALL = 1052,	--全员禁言中，只允许管理员发言
	NO_GROUP_ASSISTANT_EXIST = 1053,	--军团助理已被任命
	NO_GROUP_ASSISTANT_24HOUR = 1054, --取消军团助理24小时以上才能再次任命
	NO_GROUP_ASSISTANT_CANCEL_NOVALID = 1055,	--玩家不是军团助理
	NO_GROUP_KICK_ASSISTANT = 1056, --移除军团助理前请先解除其职务
	NO_GROUP_ACCEPT_ASSISTANT_DAY_MAX = 1057, --军团助理每日只能操作2名玩家的申请
	NO_GROUP_KICK_ASSISTANT_DAY_MAX = 1058, --军团助理每日只能移除2名玩家
	NO_GROUP_RESOURCE_NOT_ENOUTH = 1059, --需要的资源不足
	NO_GROUP_KICK_ADMIN = 1060, --会长不能被移除
	NO_GROUP_MILITARY_TAKEREWARD_ONCE = 1061, --今日已领取过军饷
	NO_GROUP_MILITARY_TAKEREWARD_FAIL = 1062, --未满足领取军饷条件
	NO_PAY_RED_PACKET_RECEIVE_FORBIDDEN = 1063, --您被禁言无法领取红包
	NO_PAY_RED_PACKET_INVALID = 1064, --该红包不存在或已过期
	NO_PAY_RECEIVE_RED_PACKET_EMYPT = 1065, --该红包已全部领完
	NO_PAY_RED_PACKET_RECEIVE_MAXCOUNT = 1066, --您已领取过该红包
	NO_GROUP_CREATE_VIP_LEVEL = 1067, --VIP2及以上才能创建军团
	NO_GROUP_RESOURCE_ENOUGH_IRON = 1068, --军团铁资源不足
	NO_GROUP_RESOURCE_ENOUGH_WOOD = 1069, --军团木材资源不足
	NO_GROUP_RESOURCE_ENOUGH_FOOD = 1070, --军团粮食资源不足
	NO_GROUP_KICK_30DADS_OFFLINE = 1071, --玩家30天未登录才能移除
	NO_GROUP_ASSET_ADMIN_NOTASSITANT = 1072, --待任命的玩家必须是助理
	NO_GROUP_ASSET_ADMIN_30DADS_OFFLINE = 1073, --会长30天未登录才能卸任
	NO_GROUP_ASSET_ADMIN_VIP_LEVEL = 1074, --助理VIP2及以上才能任命为会长
	NO_GROUP_TRANSFER_CREATE_30_DAYS = 1075, --军团创建时间达到30天才能转让
	NO_GROUP_TRANSFER_NOTASSITANT = 1076, --待转让的玩家必须是助理
	NO_GROUP_TRANSFER_HAVE_TRANSFERD_30_DAYS = 1077, --军团近30天内已经转让过
	NO_GROUP_TRANSFER_ASSIST_VIP2 = 1078, --助理达到VIP2才能转让
	NO_GROUP_TRANSFER_NO_ASSIST = 1079, --军团助理尚未任命，无法转让
	NO_GROUP_TRANSFER_MAINTOWN_LV3 = 1080, --主城达到3级才能转让
	NO_GROUP_DISOLUTE_MEMBER1 = 1801, --军团只剩1人才能解散
	NO_GROUP_DISOLUTE_30DADS_OFFLINE = 1802, --会长30天未登录才能解散
	NO_GROUP_MODIFY_NOTICE_FORBIDDEN = 1083, --您被禁言无法修改军团公告
	NO_GROUP_MODIFY_NAME_FORBIDDEN = 1084, --您被禁言无法修改军团名
	NO_GROUP_CREATE_GROUP_FORBIDDEN = 1085, --您被禁言无法创建军团
	NO_GROUP_KICK_ACTIVE_PLAYER_NUM_MAX = 1086, --军团每日只能移除2名活跃玩家
	NO_GROUP_INVITE_TOOMAYN = 1087, --当前已有军团邀请函数量达到上限
	NO_GROUP_INVITE_ADMIN = 1088, --只有会长才能发送军团邀请函
	NO_GROUP_INVITE_EXISTED = 1089, --您的军团邀请函已存在
	NO_GROUP_INVITE_EXPIRED = 1090, --军团邀请函不存在或已过期
	NO_GROUP_INVITE_VIP = 1091, --您的VIP等级不符合军团邀请函条件
	NO_GROUP_INVITE_REGTIME = 1092, --您的注册时间不符合军团邀请函条件
	NO_GROUP_JOIN_GROUP = 1093, --您已加入了军团
	NO_GROUP_TACTICCARD_INTEGER = 1094, --选择的碎片数量需为N的整数倍
	NO_GROUP_HEROCARD_INTEGER = 1095, --选择的英雄将魂数量需为N的整数倍
	NO_GROUP_NOCOUPLE_MAXNUM = 1096, --当前组队邀请数量已达上限
}