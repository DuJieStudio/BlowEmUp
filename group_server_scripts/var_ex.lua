--本地文件
g_outsyncfilepath=".\\log\\outsync\\"
g_serverLog=".\\log\\"

--网络error定义
--GROUP服务器错误码
hVar.GROUPNETERR = 
{
	UNKNOW_ERROR = 0,				--未知错误
	LOGIN_PLAYER_EXEIST = 1,			--玩家已存在
	LOGIN_PLAYER_FULL = 2,				--玩家已满
}

--势力定义
hVar.FORCE_DEF = 
{
	GOD = 0,		--神
	SHU = 1,		--蜀国
	WEI = 2,		--魏国
	NEUTRAL = 3,		--中立无敌意
	NEUTRAL_ENEMY = 4,	--中立有敌意
}

--房间玩家电脑类型定义
hVar.POS_TYPE = 
{
	CLOSED = -1,		--关闭
	BLANK = 0,		--空位
	PLAYER = 1,		--玩家
	AI_EASY = 2,		--简单
	AI_NORMAL = 3,		--普通
	AI_HARD = 4,		--困难
	AI_EXPERTS = 5,		--极难
	AI_PROFESSIONAL = 6,	--专家
}

--设备类型定义
hVar.DEVICE_TYPE_EX = 
{
	DEVIDE_UNKNOWN = 0,		--未知设备
	DEVIDE_IPHONE = 1,		--苹果设备
	DEVICE_ANDROID = 2,		--安卓设备
	DEVICE_WINDOWS = 3,		--Windows设备
}

--游戏内走马灯冒字通知类型
hVar.BUBBLE_NOTICE_TYPE = 
{
	ARENA_CREATE = 0,		--创建擂台赛
	ARENA_SUCCESS = 1,		--擂台赛战胜对手
	MLBK_SUCCESS = 2,		--魔龙宝库胜利
	TQT_SUCCESS = 3,		--铜雀台胜利
	PVP_SUCCESS = 4,		--夺塔奇兵竞技场胜利
	JTMJSL_SUCCESS = 8,		--军团秘境试炼胜利
	JTMJSL_ZS_SUCCESS = 9,		--军团秘境试炼胜利（驻守模式）
	RZWD_SUCCESS = 10,		--人族无敌胜利
	MTSZ_SUCCESS = 11,		--魔塔杀阵胜利
	SWJG_SUCCESS = 12,		--守卫剑阁胜利
	SWJG2_SUCCESS = 13,		--双人守卫剑阁胜利
	XZXD_SUCCESS = 14,		--仙之侠道胜利
	BWDL_SUCCESS = 15,		--霸王大陆胜利
	HERO_UNLOCK = 100,		--解锁获得英雄
	HERO_STARUP2 = 101,		--英雄升2星
	HERO_STARUP3 = 102,		--英雄升3星
	RED_EQUIP = 1001,		--获得4孔神器
	MLBK_OPEN = 1002,		--魔龙宝库开放
	JTMJSL_OPEN = 1003,		--军团秘境试炼开放
	PVP_OPEN = 1004,		--夺塔奇兵匹配房开放
	TACTICCARD = 1006,		--获得限量战术卡
	TACTICCARD_DEBRIS = 1007,	--获得限量战术卡碎片
	RED_EQUIP_GIFT = 1008,		--获得活动礼包
	QYG_SUCCESS = 1009,		--群英阁胜利
	TOWER_ADDONES = 1010,		--解锁防御塔属性强化
	TREASURE_STARUP = 1011,		--宝物升星
	SERVER_RESTART = 1012,		--服务器重启
	SERVER_WARNING_MSG = 1013,	--服务器提醒类走马灯消息
	ENDLESS_SUCCESS = 1014,		--无尽地图胜利
}

--宝物属性位叠加规则
hVar.TREASURE_ATTR_INCREASE_TYPE =
{
	ADD = 1,		--相加
	COVER = 2,		--覆盖
	MIN = 3,		--取较小值
	MAX = 4,		--取较大值
}

--任务（新）类型
hVar.TASK_TYPE =
{
	TASK_DALILY_REWARD = 1,			--每日奖励
	TASK_TACTICCARD_ONCE = 2,		--商城抽卡
	TASK_REDCHEST_ONCE = 3,			--商城抽装
	TASK_REFRESH_SHOP = 4,			--刷新商店
	TASK_EQUIP_XILIAN = 5,			--百炼成钢
	TASK_BASE_BATTLE_WIN = 6,		--小试牛刀
	TASK_ENDLESS_SCORE = 7,			--无尽使命
	TASK_QSZD_WAVE = 8,			--前哨阵地波次
	TASK_RANDOMMAP_STAGE = 9,		--随机迷宫层数
	TASK_PVP_OPENCHEST = 10,		--竞技锦囊
	TASK_PVP_BATTLE = 11,			--竞技切磋
	TASK_PVPTOKEN_USE = 12,			--兵符达人
	TASK_OPEN_WEPONCHEST = 13,		--武器宝箱
	TASK_OPEN_TACTICCHEST = 14,		--战术宝箱
	TASK_OPEN_PETCHEST = 15,		--宠物宝箱
	TASK_OPEN_EQUIPCHEST = 16,		--装备宝箱
	TASK_KILL_ENEMY = 17,			--击杀敌人
	TASK_KILL_BOSS = 18,			--击杀BOSS
	TASK_DEADTH = 19,			--战车死亡
	TASK_USE_TACTIC = 20,			--使用战术卡
	TASK_RESCUE_SCIENTIST = 21,		--拯救科学家
	TASK_MAP_SUCCESS_N = 22,		--通关指定关卡
	TASK_MAP_SUCCESS_NOHURT_N = 23,		--无损通关指定关卡
	TASK_KILL_BOSS_N = 24,			--击杀指定BOSS
	TASK_USE_TACTIC_N = 25,			--使用指定战术卡
	TASK_MAX_PET_FOLLOW_AMOUNT = 26,	--宠物跟随数量
	TASK_USE_CHIP_TO_REFORM_EQUIP_TIMES = 27,--使用芯片改造装备次数
	TASK_UPGRADE_TACTICAL_CARD_TIMES = 28,	--升级任意战术卡次数
	TASK_UPGRADE_WEAPON_TIMES = 29,		--升级任意枪塔武器次数
	TASK_UPGRADE_PET_TIMES = 30,		--升级任意宠物次数
	TASK_MAP_SUCCESS_DIFFICULTY_N = 31,	--通关指定关卡难度
	TASK_SHARE_COUINT = 32,			--分享次数
}

--任务（新）的日期类型
hVar.TASK_DAILY_TYPE =
{
	DAY = 1,	--每日任务
	WEEK = 2,	--周任务
}

--任务（新）的周任务奖励需要任务之石数量
hVar.TASK_STONE_COST =
{
	[1] = {num = 10, reward = {7, 30, 0, 0,},},
	[2] = {num = 30, reward = {106, 50, 0, 0,},},
	[3] = {num = 50, reward = {107, 70, 0, 0,},},
	[4] = {num = 70, reward = {108, 90, 0, 0,},},
	[5] = {num = 100, reward = {11, 188, 0, 0,},},
}

--任务（新）类型对应的数据库字段
hVar.TASK_DBKEY =
{
	[hVar.TASK_TYPE.TASK_DALILY_REWARD] = "task_daily",
	[hVar.TASK_TYPE.TASK_TACTICCARD_ONCE] = "task_drawcard",
	[hVar.TASK_TYPE.TASK_REDCHEST_ONCE] = "task_redchest",
	[hVar.TASK_TYPE.TASK_REFRESH_SHOP] = "task_refreshshop",
	[hVar.TASK_TYPE.TASK_EQUIP_XILIAN] = "task_xilian",
	[hVar.TASK_TYPE.TASK_BASE_BATTLE_WIN] = "task_battle_pve",
	[hVar.TASK_TYPE.TASK_ENDLESS_SCORE] = "task_endless",
	[hVar.TASK_TYPE.TASK_QSZD_WAVE] = "task_qszdwave",
	[hVar.TASK_TYPE.TASK_RANDOMMAP_STAGE] = "task_randmapstage",
	[hVar.TASK_TYPE.TASK_PVP_OPENCHEST] = "task_pvp_chest",
	[hVar.TASK_TYPE.TASK_PVP_BATTLE] = "task_pvp_battle",
	[hVar.TASK_TYPE.TASK_PVPTOKEN_USE] = "task_pvpcoin",
	[hVar.TASK_TYPE.TASK_OPEN_WEPONCHEST] = "task_weaponchest",
	[hVar.TASK_TYPE.TASK_OPEN_TACTICCHEST] = "task_tacticchest",
	[hVar.TASK_TYPE.TASK_OPEN_PETCHEST] = "task_petchest",
	[hVar.TASK_TYPE.TASK_OPEN_EQUIPCHEST] = "task_equipchest",
	[hVar.TASK_TYPE.TASK_KILL_ENEMY] = "task_killenemy",
	[hVar.TASK_TYPE.TASK_KILL_BOSS] = "task_killboss",
	[hVar.TASK_TYPE.TASK_DEADTH] = "task_deadth",
	[hVar.TASK_TYPE.TASK_USE_TACTIC] = "task_usetactic",
	[hVar.TASK_TYPE.TASK_RESCUE_SCIENTIST] = "task_scientist",
	[hVar.TASK_TYPE.TASK_MAP_SUCCESS_N] = "task_mapsuccess_n",
	[hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N] = "task_mapsuccess_nohurt_n",
	[hVar.TASK_TYPE.TASK_KILL_BOSS_N] = "task_killboss_n",
	[hVar.TASK_TYPE.TASK_USE_TACTIC_N] = "task_usetactic_n",
	[hVar.TASK_TYPE.TASK_MAX_PET_FOLLOW_AMOUNT] = "task_max_pet_follow_amount",
	[hVar.TASK_TYPE.TASK_USE_CHIP_TO_REFORM_EQUIP_TIMES] = "task_use_chip_to_reform_equip_times",
	[hVar.TASK_TYPE.TASK_UPGRADE_TACTICAL_CARD_TIMES] = "task_upgrade_tactical_card_times",
	[hVar.TASK_TYPE.TASK_UPGRADE_WEAPON_TIMES] = "task_upgrade_weapon_times",
	[hVar.TASK_TYPE.TASK_UPGRADE_PET_TIMES] = "task_upgrade_pet_times",
	[hVar.TASK_TYPE.TASK_MAP_SUCCESS_DIFFICULTY_N] = "task_map_success_difficulty_n",
	[hVar.TASK_TYPE.TASK_SHARE_COUINT] = "task_sharecount",
}

--任务（新）类型叠加规则
hVar.TASK_INCREASE_TYPE =
{
	[hVar.TASK_TYPE.TASK_DALILY_REWARD] = hVar.TREASURE_ATTR_INCREASE_TYPE.COVER, --覆盖
	[hVar.TASK_TYPE.TASK_TACTICCARD_ONCE] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_REDCHEST_ONCE] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_REFRESH_SHOP] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_EQUIP_XILIAN] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_BASE_BATTLE_WIN] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_ENDLESS_SCORE] = hVar.TREASURE_ATTR_INCREASE_TYPE.MAX, --取较大值
	[hVar.TASK_TYPE.TASK_QSZD_WAVE] = hVar.TREASURE_ATTR_INCREASE_TYPE.MAX, --取较大值
	[hVar.TASK_TYPE.TASK_RANDOMMAP_STAGE] = hVar.TREASURE_ATTR_INCREASE_TYPE.MAX, --取较大值
	[hVar.TASK_TYPE.TASK_PVP_OPENCHEST] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_PVP_BATTLE] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_PVPTOKEN_USE] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_OPEN_WEPONCHEST] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_OPEN_TACTICCHEST] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_OPEN_PETCHEST] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_OPEN_EQUIPCHEST] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_KILL_ENEMY] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_KILL_BOSS] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_DEADTH] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_USE_TACTIC] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_RESCUE_SCIENTIST] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_MAP_SUCCESS_N] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_KILL_BOSS_N] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_USE_TACTIC_N] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_MAX_PET_FOLLOW_AMOUNT] = hVar.TREASURE_ATTR_INCREASE_TYPE.MAX, --取最大值
	[hVar.TASK_TYPE.TASK_USE_CHIP_TO_REFORM_EQUIP_TIMES] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_UPGRADE_TACTICAL_CARD_TIMES] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_UPGRADE_WEAPON_TIMES] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_UPGRADE_PET_TIMES] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_MAP_SUCCESS_DIFFICULTY_N] = hVar.TREASURE_ATTR_INCREASE_TYPE.MAX, --取最大值
	[hVar.TASK_TYPE.TASK_SHARE_COUINT] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
}

--红装神器获得途径
hVar.REDEQUIP_REWARDTYPE =
{
	NONE = 0,				--无
	REWARDTYPE_MAIL = 1,			--邮件直接领取
	REWARDTYPE_ENDLESSRANKBOARD = 2,	--邮件无尽排名奖励
	REWARDTYPE_PVEMULTYWORK = 3,		--邮件魔龙宝库勤劳奖励
	REWARDTYPE_MAILREAD = 4,		--邮件标题正文领取
	REWARDTYPE_SEVENDAYPAY = 5,		--七日充值活动奖励
	REWARDTYPE_SINGINREWARD = 6,		--签到活动获得
	REWARDTYPE_SINGINDRAW = 7,		--签到活动抽到
	REWARDTYPE_TURNTABLE = 8,		--转盘活动抽到
	REWARDTYPE_REDSCROLL = 9,		--红装兑换券选择
	REWARDTYPE_MAILDRAWCARD = 10,		--邮件n选1领取
	REWARDTYPE_MAILCHEST = 11,		--邮件锦囊抽到
	REWARDTYPE_REDCHEST = 12,		--神器锦囊抽到
	REWARDTYPE_REDDEBRIS = 13,		--神器晶石抽到
	REWARDTYPE_GROUPCHEST = 14,		--军团宝箱抽到
	REWARDTYPE_MERGE = 15,			--合成
	REWARDTYPE_PURCHASE198 = 16,		--首充198元奖励
	REWARDTYPE_PURCHASE388 = 17,		--首充388元奖励
	REWARDTYPE_TRANFSORM = 18,		--老装备转换
	REWARDTYPE_CANGBAOTU = 19,		--藏宝图抽到
	REWARDTYPE_CANGBAOTU_HIGH = 20,		--高级藏宝图抽到
	REWARDTYPE_QUNYINGGEREWARD = 21,	--通关群英阁获得
	REWARDTYPE_TURNCHOUJIANG = 22,		--夺宝活动抽到
	REWARDTYPE_PURCHASE328 = 23,		--首充328元奖励
	REWARDTYPE_PVPSHOP = 24,		--夺塔奇兵积分商城抽到
	REWARDTYPE_CHATDRAGON = 25,		--聊天龙王奖励
	REWARDTYPE_GROUPMULTYWORK = 26,		--邮件军团秘境试炼勤劳奖励
	REWARDTYPE_MAILBATTLESUCCESS_MLBK = 27,	--邮件通关魔龙宝库抽到
	REWARDTYPE_MAILBATTLESUCCESS_JTMJSL = 28,--邮件通关军团秘境试炼抽到
	
	REWARDTYPE_TREASURE_STAR1 = 101,	--宝物升1星
	REWARDTYPE_TREASURE_STAR2 = 102,	--宝物升2星
	REWARDTYPE_TREASURE_STAR3 = 103,	--宝物升3星
	REWARDTYPE_TREASURE_STAR4 = 104,	--宝物升4星
	REWARDTYPE_TREASURE_STAR5 = 105,	--宝物升5星
}

--世界聊天消息最大数量
hVar.CHAT_MAX_LENGTH_WORLD = 100

--邀请频道消息最大数量
hVar.CHAT_MAX_LENGTH_INVITE = 30

--邀请频道组队副本邀请消息最大数量
hVar.CHAT_MAX_LENGTH_INVITE_BATTLE = 20

--私聊消息最大数量
hVar.CHAT_MAX_LENGTH_PRIVATE = 30

--私聊好友最大人数（管理员）
hVar.CHAT_MAX_USERNUM_PRIVATE_GM = 30

--私聊好友最大人数
hVar.CHAT_MAX_USERNUM_PRIVATE = 20

--私聊同一个好友每天最大次数
hVar.CHAT_MAX_COUNT_PRIVATE = 3

--工会聊天消息最大数量（仅限玩家聊天的数量，工会系统消息数量当前全部保留）
hVar.CHAT_MAX_LENGTH_GROUP = 60

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

--军团建筑类型
hVar.LEGION_BUILDIND_TYPE = {
	UNKNOW = 0,		--未知类型建筑
	MAIN = 1,		--主城
	TECHNOLOGY = 2,		--科技
	RESIDENCE = 3,		--住所
	SHOP = 4,		--商店	（购买战术卡碎片）
	TACTICS = 5,		--战术卡
	PRODUCE = 6,		--生产资源类
	UNIQUETACTICS = 7,	--专属战术卡
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

--军团市场兑换后获得的随机奖励
hVar.GROUP_ECHANGE_REWARD =
{
	{16, 5,}, --16:铁
	{17, 10,}, --17:木材
	{18, 10,}, --18:粮食
}

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

--军团申请人自动取消申请的时间
hVar.GROUP_APPY_AUTOFIRE_TIME = 48 * 3600 --（秒）

--军团红包
hVar.CHAT_GROUP_RED_PACKET_SHOPITEM = --商品id
{
	[1] = 399, --军团红包（小）
	[2] = 400, --军团红包（大）
}
hVar.CHAT_GROUP_RED_PACKET_EXPIRETIME = 48 --红包有效时间（小时）
hVar.CHAT_GROUP_RED_PACKET_EMPTY_EXPIRETIME = 2 --红包全部领完后的有效时间（仅界面显示用）（小时）

--军团邀请函
hVar.CHAT_GROUP_INVITE_EXPIRETIME = 48 --军团邀请函有效时间（小时）

--军团助理每日权限
hVar.CHAT_GROUP_ASSITANT_OP_COUNT_MAX = 2 --助理每日操作审核人员最大次数
hVar.CHAT_GROUP_ASSITANT_KICK_COUNT_MAX = 2 --助理每日踢人最大次数

--军团每日可踢掉活跃玩家的次数
hVar.CHAT_GROUP_KICK_ACTIVE_PLAYER_MAX = 2

--军团红包发送者奖励列表
hVar.GROUP_RED_PACKET_SENDER_REWARDLIST =
{
	--红包（小）
	[1] =
	{
		{16, 11, 0, 0,}, --铁
		{17, 22, 0, 0,}, --木材
		{18, 22, 0, 0,}, --粮食
	},
	
	--红包（大）
	[2] =
	{
		{16, 36, 0, 0,}, --铁
		{17, 72, 0, 0,}, --木材
		{18, 72, 0, 0,}, --粮食
	},
}

--军团红包奖励列表
hVar.GROUP_RED_PACKET_REWARDLIST =
{
	[1] = --神器晶石
	{
		probablity = 30,
		reward =
		{
			param1 = 11, --11:神器晶石
			param2 = --神器晶石数量
			{
				{probablity = 15, value = 20,},
				{probablity = 30, value = 25,},
				{probablity = 10, value = 30,},
				{probablity = 9, value = 35,},
				{probablity = 8, value = 40,},
				{probablity = 7, value = 45,},
				{probablity = 6, value = 50,},
				{probablity = 5, value = 55,},
				{probablity = 4, value = 60,},
				{probablity = 3, value = 65,},
				{probablity = 2, value = 70,},
				{probablity = 1, value = 75,},
			},
			param3 = 0,
			param4 = 0,
		},
	},
	
	[2] = --积分
	{
		probablity = 8,
		reward =
		{
			param1 = 1, --1:积分
			param2 = --积分数量
			{
				{probablity = 10, value = 300,},
				{probablity = 20, value = 350,},
				{probablity = 20, value = 380,},
				{probablity = 14, value = 400,},
				{probablity = 10, value = 450,},
				{probablity = 8, value = 480,},
				{probablity = 8, value = 500,},
				{probablity = 6, value = 550,},
				{probablity = 4, value = 580,},
			},
			param3 = 0,
			param4 = 0,
		},
	},
	
	[3] = --战术卡碎片（普通）
	{
		probablity = 15,
		reward =
		{
			param1 = 6, --6:战术卡碎片
			param2 = --战术卡碎片id
			{
				{probablity = 1, value = 10401,}, --练兵碎片
				{probablity = 1, value = 10402,}, --桃园结义碎片
				{probablity = 1, value = 10409,}, --富豪碎片
				{probablity = 1, value = 10411,}, --妙手回春碎片
				{probablity = 1, value = 10403,}, --破敌碎片
				{probablity = 1, value = 10404,}, --弱敌碎片
				{probablity = 1, value = 10405,}, --乱敌碎片
				{probablity = 1, value = 10406,}, --箭塔精通碎片
				{probablity = 1, value = 10408,}, --术塔精通碎片
				{probablity = 1, value = 10407,}, --炮塔精通碎片
				{probablity = 1, value = 10412,}, --固若金汤碎片
				{probablity = 1, value = 10413,}, --塔基加固碎片
				{probablity = 1, value = 10443,}, --砖瓦结构碎片
				{probablity = 1, value = 10444,}, --修罗堡垒碎片
				{probablity = 1, value = 10415,}, --摧城拔寨碎片
				{probablity = 1, value = 10416,}, --强化毒素碎片
				{probablity = 1, value = 10417,}, --致命连射碎片
				{probablity = 1, value = 10420,}, --三味真火碎片
				{probablity = 1, value = 10421,}, --冻土碎片
				{probablity = 1, value = 10422,}, --弹道学碎片
				{probablity = 1, value = 10423,}, --致命轰击碎片
				{probablity = 1, value = 10431,}, --剧毒新星碎片
				{probablity = 1, value = 10433,}, --箭雨碎片
				{probablity = 1, value = 10432,}, --亡命狙击碎片
				{probablity = 1, value = 10430,}, --火借风威碎片
				{probablity = 1, value = 10434,}, --凛冬之寒碎片
				{probablity = 1, value = 10435,}, --复仇巨炮碎片
				{probablity = 1, value = 10437,}, --亡者天降碎片
				{probablity = 1, value = 10429,}, --飞沙走石碎片
				{probablity = 1, value = 10445,}, --威震四方碎片
				{probablity = 1, value = 10447,}, --紫气东来碎片
				{probablity = 1, value = 10440,}, --分秒必争碎片
				{probablity = 1, value = 10441,}, --先者之音碎片
				{probablity = 1, value = 10451,}, --调息碎片
				{probablity = 1, value = 10452,}, --复仇碎片
				{probablity = 1, value = 10453,}, --断粮碎片
				{probablity = 1, value = 10455,}, --崩裂碎片
				{probablity = 1, value = 10459,}, --扰敌碎片
				{probablity = 1, value = 10424,}, --碾压碎片
				{probablity = 1, value = 10436,}, --神火雷碎片
				{probablity = 1, value = 10418,}, --穿云一击碎片
				{probablity = 1, value = 10465,}, --引雷碎片
				{probablity = 1, value = 10466,}, --战歌碎片
				{probablity = 1, value = 10468,}, --足粮碎片
				{probablity = 1, value = 10469,}, --突刺碎片
			},
			param3 = --战术卡碎片数量
			{
				{probablity = 7, value = 2,},
				{probablity = 15, value = 3,},
				{probablity = 21, value = 4,},
				{probablity = 22, value = 5,},
				{probablity = 12, value = 6,},
				{probablity = 11, value = 7,},
				{probablity = 5, value = 8,},
				{probablity = 4, value = 9,},
				{probablity = 3, value = 10,},
			},
			param4 = 1,
		},
	},
	
	[4] = --战术卡碎片（高级）
	{
		probablity = 2,
		reward =
		{
			param1 = 6, --6:战术卡碎片
			param2 = --战术卡碎片id
			{
				--{probablity = 1, value = 10414,}, --破军碎片
				--{probablity = 1, value = 10418,}, --穿云一击碎片
				--{probablity = 1, value = 10419,}, --天雷滚滚碎片
				--{probablity = 1, value = 10424,}, --碾压碎片
				--{probablity = 1, value = 10428,}, --地刺陷阱碎片
				--{probablity = 1, value = 10436,}, --神火雷碎片
				--{probablity = 1, value = 10425,}, --王佐之才碎片
				--{probablity = 1, value = 10426,}, --月华碎片
				--{probablity = 1, value = 10442,}, --月光碎片
				{probablity = 1, value = 10449,}, --神火飞鸦碎片
				{probablity = 1, value = 10448,}, --余温碎片
				{probablity = 1, value = 10450,}, --引力炮弹碎片
				--{probablity = 1, value = 10438,}, --孤狼碎片
				--{probablity = 1, value = 10446,}, --炸弹人碎片
				--{probablity = 1, value = 10427,}, --凤翼天翔碎片
				--{probablity = 1, value = 10439,}, --逆转天机碎片
			},
			param3 = --战术卡碎片数量
			{
				{probablity = 95, value = 1,},
				{probablity = 5, value = 2,},
			},
			param4 = 1,
		},
	},
	
	[5] = --游戏币
	{
		probablity = 3,
		reward =
		{
			param1 = 7, --7:游戏币
			param2 = --游戏币数量
			{
				{probablity = 10, value = 3,},
				{probablity = 11, value = 4,},
				{probablity = 20, value = 5,},
				{probablity = 20, value = 6,},
				{probablity = 20, value = 7,},
				{probablity = 10, value = 8,},
				{probablity = 3, value = 9,},
				{probablity = 3, value = 10,},
				{probablity = 2, value = 11,},
				{probablity = 1, value = 12,},
			},
			param3 = 0,
			param4 = 0,
		},
	},
	
	[6] = --铁
	{
		probablity = 6,
		reward =
		{
			param1 = 16, --16:铁
			param2 = --铁数量
			{
				{probablity = 20, value = 4,},
				{probablity = 30, value = 5,},
				{probablity = 30, value = 6,},
				{probablity = 10, value = 7,},
				{probablity = 10, value = 8,},
			},
			param3 = 0,
			param4 = 0,
		},
	},
	
	[7] = --木材
	{
		probablity = 8,
		reward =
		{
			param1 = 17, --17:木材
			param2 = --木材数量
			{
				{probablity = 20, value = 6,},
				{probablity = 30, value = 7,},
				{probablity = 30, value = 8,},
				{probablity = 10, value = 9,},
				{probablity = 10, value = 10,},
			},
			param3 = 0,
			param4 = 0,
		},
	},
	
	[8] = --粮食
	{
		probablity = 8,
		reward =
		{
			param1 = 18, --18:粮食
			param2 = --粮食数量
			{
				{probablity = 20, value = 6,},
				{probablity = 30, value = 7,},
				{probablity = 30, value = 8,},
				{probablity = 10, value = 9,},
				{probablity = 10, value = 10,},
			},
			param3 = 0,
			param4 = 0,
		},
	},
	
	[9] = --军团币
	{
		probablity = 4,
		reward =
		{
			param1 = 20, --20:军团币
			param2 = --军团数量
			{
				{probablity = 20, value = 3,},
				{probablity = 30, value = 4,},
				{probablity = 30, value = 5,},
				{probablity = 10, value = 6,},
				{probablity = 10, value = 8,},
			},
			param3 = 0,
			param4 = 0,
		},
	},
	
	[10] = --英雄将魂（普通）
	{
		probablity = 6,
		reward =
		{
			param1 = 5, --5:英雄将魂
			param2 = --英雄将魂数量
			{
				{probablity = 1, value = 10201,}, --刘备将魂
				{probablity = 1, value = 10202,}, --关羽将魂
				{probablity = 1, value = 10203,}, --张飞将魂
				{probablity = 1, value = 10208,}, --赵云将魂
				{probablity = 1, value = 10205,}, --曹操将魂
				{probablity = 1, value = 10210,}, --夏侯敦将魂
				{probablity = 1, value = 10207,}, --郭嘉将魂
				{probablity = 1, value = 10206,}, --太史慈将魂
				{probablity = 1, value = 10214,}, --张辽将魂
				{probablity = 1, value = 10216,}, --典韦将魂
				{probablity = 1, value = 10215,}, --许褚将魂
				{probablity = 1, value = 10211,}, --吕布将魂
				{probablity = 1, value = 10212,}, --貂蝉将魂
				{probablity = 1, value = 10227,}, --贾诩将魂
				{probablity = 1, value = 10225,}, --荀彧将魂
				{probablity = 1, value = 10218,}, --孙策将魂
				{probablity = 1, value = 10219,}, --周瑜将魂
				--{probablity = 1, value = 10222,}, --小乔将魂
				{probablity = 1, value = 10223,}, --孙权将魂
				{probablity = 1, value = 10228,}, --孙尚香将魂
				{probablity = 1, value = 10220,}, --徐庶将魂
				{probablity = 1, value = 10221,}, --诸葛亮将魂
				{probablity = 1, value = 10226,}, --黄月英将魂
				--{probablity = 1, value = 10235,}, --董卓将魂
			},
			param3 = --英雄将魂数量
			{
				{probablity = 30, value = 2,},
				{probablity = 50, value = 3,},
				{probablity = 10, value = 4,},
				{probablity = 6, value = 5,},
				{probablity = 4, value = 6,},
			},
			param4 = 0,
		},
	},
	
	[11] = --英雄将魂（高级）
	{
		probablity = 2,
		reward =
		{
			param1 = 5, --5:英雄将魂
			param2 = --英雄将魂数量
			{
				{probablity = 1, value = 10217,}, --甘宁将魂
				{probablity = 1, value = 10224,}, --庞统将魂
			},
			param3 = --英雄将魂数量
			{
				{probablity = 80, value = 1,},
				{probablity = 15, value = 2,},
				{probablity = 5, value = 3,},
			},
			param4 = 0,
		},
	},
	
	[12] = --兵种卡碎片
	{
		probablity = 6,
		reward =
		{
			param1 = 6, --6:战术卡碎片
			param2 = --战术卡碎片id
			{
				{probablity = 1, value = 10501,}, --孔明灯
				{probablity = 1, value = 10502,}, --死士
				{probablity = 1, value = 10503,}, --投石车
				{probablity = 1, value = 10505,}, --自爆兵
				{probablity = 1, value = 10504,}, --力士
				{probablity = 1, value = 10506,}, --箭雨
				{probablity = 1, value = 10507,}, --象兵
				{probablity = 1, value = 10509,}, --虎豹骑
				{probablity = 1, value = 10512,}, --爆炎
				{probablity = 1, value = 10514,}, --狗雨
				{probablity = 1, value = 10515,}, --微笑力士
				{probablity = 1, value = 10517,}, --天网
				{probablity = 1, value = 10518,}, --捕兽夹
				{probablity = 1, value = 10508,}, --护城弩手
				{probablity = 1, value = 10513,}, --护城卫士
			},
			param3 = --兵种卡碎片数量
			{
				{probablity = 4, value = 2,},
				{probablity = 18, value = 3,},
				{probablity = 21, value = 4,},
				{probablity = 22, value = 5,},
				{probablity = 12, value = 6,},
				{probablity = 11, value = 7,},
				{probablity = 5, value = 8,},
				{probablity = 4, value = 9,},
				{probablity = 3, value = 10,},
			},
			param4 = 1,
		},
	},
	
	[13] = --献祭之石
	{
		probablity = 1,
		reward =
		{
			param1 = 10, --10:神器
			param2 = 12406, --道具id
			param3 = 0, --孔数
			param4 = 0,
		},
	},
	
	[14] = --董卓将魂
	{
		probablity = 1,
		reward =
		{
			param1 = 5, --5:英雄将魂
			param2 = --英雄将魂数量
			{
				{probablity = 50, value = 10231,}, --孙坚将魂
				{probablity = 50, value = 10235,}, --董卓将魂
			},
			param3 = --英雄将魂数量
			{
				{probablity = 100, value = 1,},
			},
			param4 = 0,
		},
	},
}

--支付（土豪）红包
hVar.CHAT_PAY_RED_PACKET_EXPIRETIME = 24 --红包有效时间（小时）
hVar.CHAT_PAY_RED_PACKET_EMPTY_EXPIRETIME = 4 --红包全部领完后的有效时间（仅界面显示用）（小时）

--支付（土豪）红包奖励列表
hVar.PAY_RED_PACKET_REWARDLIST =
{
	[1] = --神器晶石
	{
		probablity = 15,
		reward =
		{
			param1 = 11, --11:神器晶石
			param2 = --神器晶石数量
			{
				{probablity = 5, value = 5,},
				{probablity = 50, value = 10,},
				{probablity = 30, value = 15,},
				{probablity = 10, value = 20,},
				{probablity = 5, value = 25,},
		
			},
			param3 = 0,
			param4 = 0,
		},
	},
	
	[2] = --积分
	{
		probablity = 10,
		reward =
		{
			param1 = 1, --1:积分
			param2 = --积分数量
			{
				{probablity = 5, value = 200,},
				{probablity = 10, value = 250,},
				{probablity = 15, value = 280,},
				{probablity = 30, value = 300,},
				{probablity = 25, value = 350,},
				{probablity = 10, value = 380,},
				{probablity = 5, value = 400,},
			
			
			},
			param3 = 0,
			param4 = 0,
		},
	},
	
	[3] = --塔卡碎片（普通）
	{
		probablity = 18,
		reward =
		{
			param1 = 6, --6:战术卡碎片
			param2 = --战术卡碎片id
			{
				{probablity = 1, value = 10301,}, --剧毒塔碎片
				{probablity = 1, value = 10304,}, --连弩塔碎片
				{probablity = 1, value = 10307,}, --狙击塔碎片
				{probablity = 1, value = 10303,}, --火焰塔碎片
				{probablity = 1, value = 10305,}, --寒冰塔碎片
				{probablity = 1, value = 10306,}, --天雷塔碎片
				{probablity = 1, value = 10302,}, --巨炮塔碎片
				{probablity = 1, value = 10309,}, --轰天塔碎片
				{probablity = 1, value = 10308,}, --滚石塔碎片
			},
			param3 = --战术卡碎片数量
			{
				{probablity = 80, value = 1,},
				{probablity = 20, value = 2,},
		
			},
			param4 = 1,
		},
	},
	
	[4] = --塔卡碎片（高级）
	{
		probablity = 5,
		reward =
		{
			param1 = 6, --6:战术卡碎片
			param2 = --战术卡碎片id
			{
				{probablity = 1, value = 10310,}, --粮仓碎片
				{probablity = 1, value = 10311,}, --擂鼓塔碎片
				{probablity = 1, value = 10312,}, --地刺塔碎片
			},
			param3 = --战术卡碎片数量
			{
				{probablity = 90, value = 1,},
				{probablity = 10, value = 2,},
		
			},
			param4 = 1,
		},
	},
	
	[5] = --战术卡碎片（普通）
	{
		probablity = 11,
		reward =
		{
			param1 = 6, --6:战术卡碎片
			param2 = --战术卡碎片id
			{
				{probablity = 1, value = 10401,}, --练兵碎片
				{probablity = 1, value = 10402,}, --桃园结义碎片
				{probablity = 1, value = 10409,}, --富豪碎片
				{probablity = 1, value = 10411,}, --妙手回春碎片
				{probablity = 1, value = 10403,}, --破敌碎片
				{probablity = 1, value = 10404,}, --弱敌碎片
				{probablity = 1, value = 10405,}, --乱敌碎片
				{probablity = 1, value = 10406,}, --箭塔精通碎片
				{probablity = 1, value = 10408,}, --术塔精通碎片
				{probablity = 1, value = 10407,}, --炮塔精通碎片
				{probablity = 1, value = 10412,}, --固若金汤碎片
				{probablity = 1, value = 10413,}, --塔基加固碎片
				{probablity = 1, value = 10443,}, --砖瓦结构碎片
				{probablity = 1, value = 10444,}, --修罗堡垒碎片
				{probablity = 1, value = 10415,}, --摧城拔寨碎片
				{probablity = 1, value = 10416,}, --强化毒素碎片
				{probablity = 1, value = 10417,}, --致命连射碎片
				{probablity = 1, value = 10420,}, --三味真火碎片
				{probablity = 1, value = 10421,}, --冻土碎片
				{probablity = 1, value = 10422,}, --弹道学碎片
				{probablity = 1, value = 10423,}, --致命轰击碎片
				{probablity = 1, value = 10431,}, --剧毒新星碎片
				{probablity = 1, value = 10433,}, --箭雨碎片
				{probablity = 1, value = 10432,}, --亡命狙击碎片
				{probablity = 1, value = 10430,}, --火借风威碎片
				{probablity = 1, value = 10434,}, --凛冬之寒碎片
				{probablity = 1, value = 10435,}, --复仇巨炮碎片
				{probablity = 1, value = 10437,}, --亡者天降碎片
				{probablity = 1, value = 10429,}, --飞沙走石碎片
				{probablity = 1, value = 10445,}, --威震四方碎片
				{probablity = 1, value = 10447,}, --紫气东来碎片
				{probablity = 1, value = 10440,}, --分秒必争碎片
				{probablity = 1, value = 10441,}, --先者之音碎片
				{probablity = 1, value = 10451,}, --调息碎片
				{probablity = 1, value = 10452,}, --复仇碎片
				{probablity = 1, value = 10453,}, --断粮碎片
				{probablity = 1, value = 10455,}, --崩裂碎片
				{probablity = 1, value = 10459,}, --扰敌碎片
				{probablity = 1, value = 10424,}, --碾压碎片
				{probablity = 1, value = 10436,}, --神火雷碎片
				{probablity = 1, value = 10418,}, --穿云一击碎片
				{probablity = 1, value = 10465,}, --引雷碎片
				{probablity = 1, value = 10466,}, --战歌碎片
				{probablity = 1, value = 10468,}, --足粮碎片
				{probablity = 1, value = 10469,}, --突刺碎片
			},
			param3 = --战术卡碎片数量
			{
				{probablity = 80, value = 1,},
				{probablity = 20, value = 2,},
		
			},
			param4 = 1,
		},
	},
	
	[6] = --英雄将魂（普通）（前期）
	{
		probablity = 20,
		reward =
		{
			param1 = 5, --5:英雄将魂
			param2 = --英雄将魂数量
			{
				{probablity = 1, value = 10201,}, --刘备将魂
				{probablity = 1, value = 10202,}, --关羽将魂
				{probablity = 1, value = 10203,}, --张飞将魂
				{probablity = 1, value = 10208,}, --赵云将魂
				{probablity = 1, value = 10205,}, --曹操将魂
				{probablity = 1, value = 10210,}, --夏侯敦将魂
				{probablity = 1, value = 10207,}, --郭嘉将魂
				{probablity = 1, value = 10206,}, --太史慈将魂
				{probablity = 1, value = 10214,}, --张辽将魂
				{probablity = 1, value = 10216,}, --典韦将魂
				{probablity = 1, value = 10215,}, --许褚将魂
				{probablity = 1, value = 10211,}, --吕布将魂
				{probablity = 1, value = 10212,}, --貂蝉将魂
				--{probablity = 1, value = 10227,}, --贾诩将魂
				--{probablity = 1, value = 10225,}, --荀彧将魂
				--{probablity = 1, value = 10218,}, --孙策将魂
				--{probablity = 1, value = 10219,}, --周瑜将魂
				--{probablity = 1, value = 10222,}, --小乔将魂
				--{probablity = 1, value = 10223,}, --孙权将魂
				--{probablity = 1, value = 10228,}, --孙尚香将魂
				--{probablity = 1, value = 10220,}, --徐庶将魂
				--{probablity = 1, value = 10221,}, --诸葛亮将魂
				--{probablity = 1, value = 10226,}, --黄月英将魂
				--{probablity = 1, value = 10235,}, --董卓将魂
			},
			param3 = --英雄将魂数量
			{
				{probablity = 80, value = 1,},
				{probablity = 20, value = 2,},
			
			},
			param4 = 0,
		},
	},
	
	[7] = --游戏币
	{
		probablity = 3,
		reward =
		{
			param1 = 7, --7:游戏币
			param2 = --游戏币数量
			{
				{probablity = 15, value = 1,},
				{probablity = 50, value = 2,},
				{probablity = 15, value = 3,},
				{probablity = 10, value = 4,},
				{probablity = 5, value = 5,},
				{probablity = 3, value = 6,},
				{probablity = 1, value = 7,},
				{probablity = 1, value = 8,},
			
			},
			param3 = 0,
			param4 = 0,
		},
	},
	
	[8] = --战术卡碎片（高级）
	{
		probablity = 1,
		reward =
		{
			param1 = 6, --6:战术卡碎片
			param2 = --战术卡碎片id
			{
				{probablity = 1, value = 10449,}, --神火飞鸦碎片
				{probablity = 1, value = 10448,}, --余温碎片
				{probablity = 1, value = 10450,}, --引力炮弹碎片
			},
			param3 = --战术卡碎片数量
			{
				{probablity = 96, value = 1,},
				{probablity = 4, value = 2,},
			},
			param4 = 1,
		},
	},
	
	[9] = --藏宝图
	{
		probablity = 4,
		reward =
		{
			param1 = 23, --23:藏宝图
			param2 = --藏宝图数量
			{
				{probablity = 60, value = 1,},
				{probablity = 20, value = 2,},
				{probablity = 15, value = 3,},
				{probablity = 4, value = 4,},
				{probablity = 1, value = 5,},
			
			},
			param3 = 0,
			param4 = 0,
		},
	},
	
	[10] = --高级藏宝图
	{
		probablity = 1,
		reward =
		{
			param1 = 24, --24:高级藏宝图
			param2 = --高级藏宝图
			{
				{probablity = 96, value = 1,},
				{probablity = 4, value = 2,},
			
			},
			param3 = 0,
			param4 = 0,
		},
	},
	
	[11] = --兵符
	{
		probablity = 4,
		reward =
		{
			param1 = 25, --25:兵符
			param2 = --高级藏宝图
			{
				{probablity = 5, value = 2,},
				{probablity = 25, value = 3,},
				{probablity = 20, value = 4,},
				{probablity = 40, value = 5,},
				{probablity = 5, value = 6,},
				{probablity = 3, value = 8,},
				{probablity = 2, value = 10,},
			},
			param3 = 0,
			param4 = 0,
		},
	},
	
	[12] = --宝物碎片（普通）
	{
		probablity = 8,
		reward =
		{
			param1 = 22, --22:宝物碎片
			param2 = --宝物碎片id
			{
				{probablity = 1, value = 10801,}, --孟德新编碎片
				{probablity = 1, value = 10802,}, --英雄救美碎片
				{probablity = 1, value = 10805,}, --神雕侠侣碎片
				{probablity = 1, value = 10808,}, --龙凤灰袍碎片
				{probablity = 1, value = 10811,}, --建筑师证书碎片
				{probablity = 1, value = 10815,}, --神行鞭碎片
				{probablity = 1, value = 10816,}, --朱雀信条碎片
				{probablity = 1, value = 10817,}, --主公玉玺碎片
				{probablity = 1, value = 10823,}, --剑仙长明灯碎片
				{probablity = 1, value = 10825,}, --菜虚鲲碎片
			},
			param3 = --战术卡碎片数量
			{
				{probablity = 80, value = 1,},
				{probablity = 20, value = 2,},
			},
			param4 = 1,
		},
	},
}

--军团同时申请人数上限
hVar.CHAT_GROUP_REQUEST_NUM_MAX = 10

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

--宝物属性位
hVar.TREASURE_ATTR =
{
	NONE = 0,					--无
	PVP_WINCOUNT_CAOCAO = 1,			--竞技场使用曹操胜利场次
	PVP_WINCOUNT_LIUGUANZHANG = 2,			--竞技场使用刘关张胜利场次
	PVP_WINCOUNT_ZHOUYUXIAOQIAO = 3,		--竞技场使用周瑜小乔胜利场次
	TONGQUETAI_WINCOUNT_EAZY_DEATH1 = 4,		--铜雀台最多死1次通关简单难度次数
	TONGQUETAI_WINCOUNT_DIFFICULT = 5,		--铜雀台通关噩梦难度次数
	TONGQUETAI_WINCOUNT_DIFFICULT_USE_WUHU = 6,	--铜雀台使用五虎上将通关噩梦难度次数
	ENDLESS_WINCOUNT_LIUGUANZHANG = 7,		--无尽试炼使用刘关张通关次数
	ENDLESS_WINCOUNT_LVBU_DIAOCHAN = 8,		--无尽试炼使用吕布貂蝉通关次数
	QUNYINGGE_WINCOUNT_10_CAOCAO = 9,		--群英阁10+难度使用曹操通关次数
	QUNYINGGE_WINCOUNT_PURPLECARD_NUM = 10,		--群英阁、人族无敌胜利抽到紫卡数量
	QUNYINGGE_WINCOUNT_10_BUILD_JUPAOTA_10 = 11,	--群英阁10+难度建造10个巨炮塔抽到巨炮精研
	QUNYINGGE_WINCOUNT_5_BUILD_JUJITA_10 = 12,	--群英阁5+难度建造10个狙击塔抽到全屏卡
	MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_PANGTONG = 13,	--魔塔杀阵使用诸葛亮庞统通关次数
	MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_HUANGYUEYING = 14,	--魔塔杀阵使用诸葛亮黄月英通关次数
	HERO_COUNT_WEI = 15,				--魏国英雄总数量
	HERO_COUNT_FEMALE = 16,				--女性英雄总数量
	OPEN_PVP_CHEST = 17,				--开启战功锦囊
	EQUIP_XILIAN_LOCK = 18,				--锁孔洗炼红装
	EQUIP_COUNT_MOUNT_SLOT4 = 19,			--累计获得4孔坐骑数量
	TOWER_COUNT_LV5 = 20,				--五级塔总数量
	CHAPTER_UNLOCKED_NUM = 21,			--解锁章节总数量
	HERO_COUNT_LV15 = 22,				--15级英雄总数量
	CONSUME_GAMECOIN_TOTALNUM = 23,			--累计消耗游戏币
	UNLOCK_SLOT_TOTALNUM = 24,			--累计打孔次数
	REDEQUIP_MERGE_SLOT3_COUNT = 25,		--合成3孔红装次数
	QUNYINGGE_WINCOUNT_5_CLEARWUGUI = 26,		--群英阁5+难度全清乌龟怪次数
	WORLD_CHANNEL_RED_PACKGET_NUM = 27,		--世界聊天频到抢到红包次数
	SHOUWEIJIANGE_WINCOUNT = 28,			--守卫剑阁（双人守卫剑阁）通关次数
	JUEZHNANXUKUN_WINCOUNT = 29,			--决战虚鲲通关次数
	
	ATTR_MAXCOUNT = 29,
}

