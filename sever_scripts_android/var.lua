if nil == loadstring then
	loadstring = load
	xlDb_Execute = red.xlDb_Execute
	xlDb_Query = red.xlDb_Query
end

hVar = {}
hGlobal = {}
hHandler = {}
hClass = {}
hApi = {}
hGlobal.init = {
	code = {},
	add = function(self,pFunc)
		self.code[#self.code+1] = pFunc
	end,
}

--服务器最大人数
hVar.MaxUser = 3000

--全局对象初始化
hGlobal.init:add(function()
	--系统配置管理
	hGlobal.sysCfg = hClass.SysCfg:create():Init()
	--玩家信息管理
	hGlobal.uMgr = hClass.UserMgr:create():Init(hVar.MaxUser)
	--排行榜管理
	hGlobal.bbMgr = hClass.BillboardMgr:create()
	--商城管理
	hGlobal.shopMgr = hClass.ShopMgr:create()
	--vip管理
	hGlobal.vipMgr = hClass.VipMgr:create()
	--用户货币管理
	hGlobal.userCoinMgr = hClass.UserCoinMgr:create()
	
	--用户红装缓存管理
	hGlobal.redEquipUserCacheMgr = hClass.RedEquipUserCacheMgr:create():Init()
	
	--战车每日排行榜奖励
	hGlobal.tankbbMgr = hClass.TankBillboardMgr:create():Init()
	
	--创建体力管理单例类
	hGlobal.tiliMgr = hClass.TiLiMgr:create():Init()
	
	--用户走马灯冒字管理
	hGlobal.bubblleNoticeMgr = hClass.BubblleNoticeMgr:create():Init()
end)



--printf = function(s,...)
--	return print(string.format(s,...),"\n")
--end
--xlout = function()end--print
--xlout = print

hVar.shop_control = 0
hVar.version_control = 0
hVar.debug_version_control = 0

hVar.START_TIME = -1				--服务器的开始时间点
hVar.DELT_TIME = -1				--服务器与db的时间差

hVar.QUEST_TYPE = 
{
	NORMAL = 1,
	DAILY = 2,
}
--单位的标记
hVar.UNIT_TAG_TYPE =
{
	TAG_NONE = "TAG_NONE", --无
	
	--塔相关
	TOWER =
	{
		TAG_BASIC	=	"TAG_BASIC"		,	--基础塔
		TAG_BJ		=	"TAG_BJ"		,	--基础箭塔
		TAG_BS		=	"TAG_BS"		,	--基础法术塔
		TAG_BP		=	"TAG_BP"		,	--基础炮塔
		
		TAG_JIANTA	=	"TAG_JIANTA"		,	--箭塔系
		TAG_FASHUTA	=	"TAG_FASHUTA"		,	--法术塔系
		TAG_PAOTA	=	"TAG_PAOTA"		,	--炮塔系
		TAG_SPECIAL	=	"TAG_SPECIAL"		,	--特殊塔系
		
		TAG_DUTA	=	"TAG_DUTA"		,	--毒塔
		TAG_LIANNUTA	=	"TAG_LIANNUTA"		,	--连弩塔
		TAG_JUJITA	=	"TAG_JUJITA"		,	--狙击塔
		
		TAG_HUOTA	=	"TAG_HUOTA"		,	--火塔
		TAG_BINGTA	=	"TAG_BINGTA"		,	--冰塔
		TAG_SHANDIANTA	=	"TAG_SHANDIANTA"	,	--闪电塔
		
		TAG_JUPAOTA	=	"TAG_JUPAOTA"		,	--巨炮塔
		TAG_HONGTIANTA	=	"TAG_HONGTIANTA"	,	--轰天塔
		TAG_GUNSHITA	=	"TAG_GUNSHITA"		,	--滚石塔
		
		TAG_LIANGCANG	=	"TAG_LIANGCANG"		,	--粮仓
		TAG_YAOFA	=	"TAG_YAOFA"		,	--妖法塔
		TAG_SIMING	=	"TAG_SIMING"		,	--司命塔
	},
	
	--战术技能
	TAG_TACTIC_SKILL = "TAG_TACTIC_SKILL",	--战术技能
	
	--单位相关
	OTHER = 
	{
		TAG_BOSS = "TAG_BOSS",					--主将
		TAG_NORMAL = "TAG_NORMAL",				--普通单位
		TAG_GOLDUNIT = "TAG_GOLDUNIT",				--金钱单位
		TAG_RIDER = "TAG_RIDER",				--骑兵单位
		TAG_BOAT = "TAG_BOAT",					--船
	},
}

--成就(任务)类型
hVar.MEDAL_TYPE = {
	
	--无
	none = "none",
	
	--地图通关信息
	map = "map",						--过第N关1
	mapCondition = "mapCondition",				--满足条件过第N关（成就无此项）
	chapterCondition = "chapterCondition",			--满足条件过某章节(成就无此项)
	gameTimesNormal = "gameTimesNormal",			--累计完成N个普通游戏局
	gameTimesDiff1 = "gameTimesDiff1",			--累计完成N个挑战1游戏局
	gameTimesDiff2 = "gameTimesDiff2",			--累计完成N个挑战2游戏局
	gameTimesDiff3 = "gameTimesDiff3",			--累计完成N个挑战3游戏局
	gameTimesDiff = "gameTimesDiff",			--累计完成N个挑战游戏局
	gameTimes = "gameTimes",				--累计完成N个游戏局1
	starCount = "starCount",				--累计获得N个星1
	allStarNormal = "allStarNormal",			--满星通关N次普通
	allStarDiff1 = "allStarDiff1",				--满星通关N次挑战1
	allStarDiff2 = "allStarDiff2",				--满星通关N次挑战2
	allStarDiff3 = "allStarDiff3",				--满星通关N次挑战3
	allStarDiff = "allStarDiff",				--满星通关N次挑战
	allStar = "allStar",					--满星通关N次关卡
	gameFailed = "gameFailed",				--游戏失败次数
	td_wj_001 = "td_wj_001",				--无尽关卡1战绩(任务无此项)
	td_wj_002 = "td_wj_002",				--无尽关卡2战绩(任务无此项)
	
	--击杀信息
	killU = "killU",					--累计击杀N个敌人
	killUB = "killUB",					--累计击杀N个BOSS
	killUT = "killUT",					--累计击杀N个指定敌人
	killUS = "killUS",					--使用战术技能技能累计击杀N个敌人(tab_tacticId, num)
	
	--升级信息
	sLvUp = "sLvUp",					--累计升级英雄技能N次1
	heroN = "heroN",					--累计收集N个英雄1
	mergeN = "mergeN",					--累计合成N次1
	xilianN = "xilianN",					--累计洗练N次1
	rebuidlN = "rebuidlN",					--累计重铸N次1
	tLvUp = "tLvUp",					--累计升级卡牌N次1
	tacticNum = "tacticNum",				--累计收集N张张术卡1
	
	--消费信息
	deposit = "deposit",					--累计充值XXX1
	--scoreCost = "scoreCost",				--累计花费积分XXX
	--rmbCost = "rmbCost",					--累计花费金币XXX
	openChest = "openChest",				--累计开N个宝箱1
	rollTactic = "rollTactic",				--累计抽N张卡1
	costScore = "costScore",				--累计消耗积分（成就无此项）（只有任务使用，接到任务后累计消耗的积分）
	
	--局内建造信息
	buildT = "buildT",					--累计建造N个塔1
	buildTT = "buildTT",					--(tag) --累计建造N个塔(箭塔，炮塔，法术塔，毒塔，连弩塔，狙击塔，巨炮塔，地震塔，滚石塔，火塔，电塔，冰塔)1
	buildS = "buildS",					--累计升级科技N次1
	
	--任务相关
	apNum = "apNum",					--累计获得N个成就点(achievement point)
	missionN = "missionN",					--累计完成N个任务 --todo
	
	--购买信息
	buyItem = "buyItem",					--购买商城道具（成就无此项）
	
	--评价星级条件
	passSuccess = "passSuccess", --成功通关关卡
	passTimeLess = "passTimeLess", --通关时间少于指定值
	passTimeMore = "passTimeMore", --通关时间大于指定值
	passHeroDeathLess = "passHeroDeathLess", --通关英雄死亡次数少于指定值
	passKillUnit = "passKillUnit", --通关击杀指定单位n次
	passProtectUnit = "passProtectUnit", --通关保护指定单位不死
	
	--连杀记录
	--bestContinuousKilling = "bestContinuousKilling",	--最大连杀
	
	rescueScientist = "rescueScientist",			--累计拯救科学家数量
	tankDeadthCount = "tankDeadthCount",			--累计战车死亡数量
}

hVar.QUEST_DAILY_NUM = 3					--每日任务数量
hVar.QUEST_DAILY_REWARD_NUM = 3					--每日任务奖励数量

--每日任务池
hVar.QUEST_DAILY_POOL = {
	--第一档
	[1] = {100,101,102,103,104,105,106,107,108,109,110,111,},
	--第二档
	[2] = {300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,},
	--第三档
	[3] = {500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552},
}

--每日任务限时领取池
--国庆任务池
hVar.QUEST_DAILY_POOL_EX = {
	beginTime = "2018-09-30 00:00:00",
	endTime = "2018-10-07 23:59:59",
	--第一档
	[1] = {38,41,44,},
	--第二档
	[2] = {39,42,45,},
	--第三档
	[3] = {40,43,46,},
}

--战车排行榜类型
hVar.TANK_BILLBOARD_RANK_TYPE =
{
	RANK_STAGE = 1,			--过图排行榜
	RANK_CONTINOUSKILL = 2,		--连杀排行榜
}

--td地图类型
hVar.MAP_TD_TYPE = 
{
	NORMAL = 0,				--普通模式
	DIFFICULT = 1,			--挑战难度模式
	PVP = 2,				--在线数据pk模式
	ENDLESS = 3,			--无尽模式
	NEWGUIDE = 4,			--新手引导地图模式
	YUEYINGZHUAN = 5,		--新游戏月英传模式
	SUNSHANGXIANGZHUAN = 6,	--新游戏孙尚香传模式
}

hVar.GM_ROLE_ID = {}				--GM的roleid

--日志常数
hVar.REWARD_LOG_TYPE = {
	--目前邮件系统支持类型说明
	--0	num		游戏币
	nRmb = 0,
	--1	num		积分
	nScore = 1,
	--2	s:20		积分?
	sScore = 2,
	--3	c:20;s:200;	推荐新玩家奖励
	recommendNew = 3,
	--4	i:9100n:1	道具奖励
	itemReward =4,
	--5	c:800;s:8000;	积分游戏币
	sScoreRmb = 5,
	--6	i:xxx;n:xxx     锻造材料
	forgeMaterial = 6,
	--7	bfs:103lv:2	战术技能卡
	tactic = 7,
	--8	ID:5024		英雄卡
	heroCard = 8,
	--10	c:10;s:200;	分享到腾讯微博
	shareTWeibo = 10,
	--11	c:10;s:200;	分享到新浪微博
	shareSWeibo = 11,
	--12	c:10;s:200;	分享到微信
	shareWeChat = 12,
	--13	c:10;s:200;	分享到好友圈
	shareWeChatFriends = 13,
	--14	c:10;s:200;	分享到QQ
	shareQQ = 14,
	--15	c:10;s:200;	分享到QZONE
	shareQzone = 15,
	--16	c:10;s:200;	分享到人人网
	shareRenren = 16,
	--18	c:10;s:500;	苹果商店评分
	shareAppStore = 18,
	--19	c:10;s:200;	分享到facebook
	shareFacebook = 19,
	--20	c:10;s:200;	分享到twitter
	shareTwitter = 20,
	--21	c:10;s:200;	分享到google+
	shareGooglePlus = 21,

	--30	m1:20;		皮革
	materialLeather = 30,
	--31	m2:20;		玄铁
	materialDarksteel = 31,
	--32	m3:20;		眼睛
	materialEye = 32,

	--100	c:50;s:200;	首次进入游戏
	welcom = 100,
	--400			服务器给金币统一入口(调用xlPrize_AddCoin服务器程序自动添加)
	--1030	i:8200n:1	首充礼包（6元）校尉重铠
	tier01 = 1030,
	--1031	i:8201n:1	首充礼包（18元）炎雀指环
	tier03 = 1031,
	--1032	i:8203n:1	首充礼包（45元）神鹰令
	tier07 = 1032,
	--1033	i:8204n:1	首充礼包（68元）绝影
	tier10 = 1033,
	--1034	i:8202n:1	首充礼包（98元）贪狼
	tier15 = 1034,
	--1035	i:8020;s:10000;	首充礼包（198元）青龙偃月刀
	tier30 = 1035,
	--1036 10:12003:4:0; 首充礼包（388元）天公之怒
	tier40 = 1036,
	--1039	8000;		直接给积分 目前就198送的8000积分用到
	nScore198 = 1039,

	customRewardBegin = 1900,	--[1900,2000)自定义奖励
	customRewardEnd = 1999,

	--1201	c:20;		推荐好友奖励 l1
	recommendFriend1 = 1201,
	--1202	c:120;		推荐好友奖励 l2
	recommendFriend2 = 1202,
	--1203	i:9006n:20;	推荐好友奖励 l3
	recommendFriend3 = 1203,
	--1204	i:9006n:50;	推荐好友奖励 l4
	recommendFriend4 = 1204,

	--2000 - 3000	string	各种消息

	--4000			充值活动
	topupActivity = 4000,

	--5000	num		微信月卡
	wechatMonth = 5000,

	--6000	i:8200n:1h:2;m1:20;		新手礼品码
	noviceReward = 6000,

	--6008	h:id		-- 英雄		5024
	--6008	b:id		-- 技能 SBTJ	(506,509)
	hero = 6008,
	skill = 6008,

	--7000	i:8200n:1h:2;m1:20;		活动战术卡
	activityTactic = 7000,

	--9004	num		网络宝箱 铜
	--9005	num		网络宝箱 银
	--9006	num		网络宝箱 金
	copperChest = 9004,
	silverChest = 9005,
	goldChest = 9006,

	--9300 - 9320		秘宝

	--9999	num		红装卷轴
	redScroll = 9999,

	--2000 - 3000 消息流程说明

	--20000 - 21000		任务系统
	dailyQuest = 20000,
	billboard	= 20001,	--排行榜发奖
	rewardMail	= 20002,	--推荐人20游戏币领奖
	recommend1	= 20003,	--推荐奖励1
	recommend2	= 20004,	--推荐奖励2
	recommend3	= 20005,	--推荐奖励3
	recommend4	= 20006,	--推荐奖励4
	recommend5	= 20007,	--推荐奖励5
	activity	= 20008,	--活动奖励
	activityEx	= 20009,	--活动奖励ex
	
	vip5		= 20010,	--vip5一次性奖励
	vip6		= 20011,	--vip6一次性奖励
	vip7		= 20012,	--vip7一次性奖励
	vip8		= 20013,	--vip8一次性奖励
	vip7_2		= 20014,	--vip7一次性奖励2
	vip8_2		= 20015,	--vip8一次性奖励2
	vip8_3		= 20016,	--vip8一次性奖励3(红妆兑换券*3, 仅限韩国版)
	vip3		= 20017,	--vip3一次性奖励
	vip4		= 20018,	--vip4一次性奖励
	
	vip7Above = 20020,		--vip7以上每充2000奖励
	
	activityDrawCard = 20028,		--服务器抽卡类奖励
	billboardEndless = 20029,		--无尽地图排行榜奖励
	pveMultyHardwork = 20030,		--魔龙宝库勤劳奖
	mailTitleMsgReward = 20031,		--带有标题和正文的奖励
	activitOpenChest = 20032,		--直接开锦囊的奖励
	mailTitleMsgNotice = 20033,		--只有标题和正文，没有奖励
	pvpRankTitleMsgReward = 20034,		--夺塔奇兵带有段位、标题和正文的奖励
	chatDragonReward = 20035,		--聊天龙王奖
	groupMultyHardwork = 20036,		--军团秘境试炼勤劳奖
	groupWeekDonateRank = 20037,		--军团本周声望排名奖励
	groupWeekDonateMax = 20038,		--军团本周声望第一名奖励
	updateTitleMsgReward = 20039,		--更新维护带有标题和正文的奖励
	tiliTitleMsgReward = 20040,		--体力带有标题和正文的奖励
	thankTitleMsgReward = 20041,		--感谢信带有标题和正文的奖励
	shareTitleMsgReward = 20042,		--分享信带有标题和正文的奖励
}

hVar.SCRIPTS_PATH = {

	--base define
	"scripts/var_ex.lua",				--各种hVar的定义
	"scripts/define.lua",				--协议定义
	"scripts/tabs/normal/var_config.lua",		--扩展hVar的定义

	--tab
	"scripts/tabs/tab_string.lua",			--字符串定义
	"scripts/tabs/tab_quest.lua",			--每日任务
	"scripts/tabs/tab_shop.lua",			--商店
	"scripts/tabs/tab_rankboard_prize.lua",	--排行榜的奖励信息表
	--tab/normal
	"scripts/tabs/normal/tab_stringI.lua",		--道具字符串定义
	"scripts/tabs/normal/tab_stringTask.lua",		--任务（新）字符串定义
	"scripts/tabs/normal/tab_stringAchievement.lua",	--成就字符串定义
	"scripts/tabs/normal/tab_droppool.lua",		--掉落奖池
	"scripts/tabs/normal/tab_item.lua",		--道具列表
	"scripts/tabs/normal/tab_shopitem.lua",		--商店道具
	"scripts/tabs/normal/tab_chest.lua",		--竞技场宝箱配置
	"scripts/tabs/normal/tab_tactics.lua",		--战术技能卡
	"scripts/tabs/normal/tab_hero.lua",		--英雄配置
	"scripts/tabs/normal/tab_chapter.lua",		--章节信息配置
	"scripts/tabs/normal/tab_map.lua",		--地图信息配置
	"scripts/tabs/normal/tab_chariottalent.lua",	--天赋表
	"scripts/tabs/normal/tab_task.lua",		--任务（新）表
	"scripts/tabs/normal/tab_map.lua",		--地图表
	"scripts/tabs/normal/tab_medal.lua",		--成就表
	
	
	--luascript
	"scripts/public/hApi.lua",			--通用接口
	"scripts/public/functions.lua",
	"scripts/c2ldbopr.lua",				--自己的数据操作
	"scripts/callback.lua",				--回调
	"scripts/prize.lua",				--慧敏的活动系统
	--"scripts/novicecamp.lua",			--新手营
}

hVar.SCRIPTS_CLASS = 
{
	"CircleFixedLenthStore",			--固定长度的循环存取容器
	"Queue",					--队列（先进先出）
	"SysCfg",				--系统配置
	"User",						--用户类
	"UserMgr",					--用户管理
	"UserCoinMgr",					--用户货币管理类
	"VipMgr",					--Vip管理类
	"Hero",						--英雄类
	"HeroMgr",					--英雄管理类
	"Tactic",					--战术技能卡类
	"TacticMgr",					--战术技能卡管理类
	"RedEquip",					--红装（装备道具）
	"RedEquipMgr",					--红装管理（玩家所有装备道具实体管理）
	"RedEquipUserCacheMgr",				--用户红装缓存管理
	"InventoryMgr",					--背包管理类(玩家仓库，英雄装备dbid容器)
	"Level",					--关卡类
	"LevelMgr",					--关卡管理类
	"Reward",					--奖励类
	"GroupReward",				--军团奖励类
	"Chest",					--箱子类
	"ShopItem",					--商品类
	"BillboardMgr",					--排行榜管理类
	"ShopMgr",					--商城管理类
	"MonthCard",				--月卡类
	"ActivitySignIn",			--新玩家七日签到活动类
	"ActivityTurnTable",		--消费转盘活动类
	"ActivitySevenDayPay",		--七日连续充值活动类
	"TankBillboardMgr",				--战车排行榜管理类
	"TankWeapon",					--战车武器枪类
	"TankTalentPoint",				--战车技能点数枪类
	"TankPet",					--战车宠物类
	"Treasure",					--宝物类
	"TaskMgr",					--任务类（新）
	"TiLiMgr",					--体力类
	"TankMap",					--地图类
	"TankGiftEquip",				--特惠礼包装备类
	"Achievement",					--成就类
	"GameGopherMgr",				--地鼠游戏
	"BubblleNoticeMgr",				--用户走马灯冒字管理类
}

--是否为主服务器（主服务器结算每日排名奖励）
hVar.IS_MAIN_SERVER = 0
local err, value = xlConfig_GetString("NET", "mainserver")
--print("xlConfig_GetString", err, value)
if (err == 0) then
	local isMain = tonumber(value) or 0
	hVar.IS_MAIN_SERVER = isMain
end
print("IS_MAIN_SERVER=", hVar.IS_MAIN_SERVER)

------------------
-- debug函数
local __LG = xlLG or function()end
G_Lua_Error_Msg = 1				--是否输出print的开关
hGlobal.__TRACKBACK__ = function(msg)
	if G_Lua_Error_Msg == 1 then
		print("----------------------------------------")
		print("LUA ERROR: " .. tostring(msg) .. "\n")
	end
	__LG("lua_error",tostring(msg))
	local text = debug.traceback()
	if G_Lua_Error_Msg == 1 then
		print(text)
		print("----------------------------------------")
	end
	__LG("log_err",tostring(text))
	--G_Lua_Error_Msg = 1
end

function xlError_CFunc(msg)
	return hGlobal.__TRACKBACK__(msg)
end

--初始化
local function __DoInit()
	do
		--所有脚本dofile
		for i = 1,#hVar.SCRIPTS_PATH do
			--print("dofile: ",i,hVar.SCRIPTS_PATH[i])
			dofile(hVar.SCRIPTS_PATH[i])
		end
		--print("done 1")
		--注册脚本类
		for i = 1,#hVar.SCRIPTS_CLASS do
			--print("scripts.class."..tostring(hVar.SCRIPTS_CLASS[i]))
			hClass[tostring(hVar.SCRIPTS_CLASS[i])] = require("scripts.class."..tostring(hVar.SCRIPTS_CLASS[i]))
		end
		--print("done 2")
		
		--设置服务器启动时间
		local err,sTick = xlDb_Query("SELECT NOW()")
		--print("done 22")
		if err == 0 then
			hVar.START_TIME = sTick
			hVar.DELT_TIME = os.time() - hApi.GetNewDate(sTick)	--deltaTime = Local - Host
		end
		--print("done 3")
		--设置版本号控制信息 todo:以后要整理成一个类去处理系统配置
		-------------------------------------------------------------------------------------------
		local sql = string.format("SELECT content from tconfig where `key` = '%s'", "shop_control")
		local nErr,content = xlDb_Query(sql)
		if nErr == 0 then
			hVar.shop_control = content
		end
		--print("done 4")
		sql = string.format("SELECT content from tconfig where `key` = '%s'", "version_control")
		nErr,content = xlDb_Query(sql)
		if nErr == 0 then
			hVar.version_control = content
		end
		--print("done 5")
		sql = string.format("SELECT content from tconfig where `key` = '%s'", "debug_version_control")
		nErr,content = xlDb_Query(sql)
		if nErr == 0 then
			hVar.debug_version_control = content
		end
		-------------------------------------------------------------------------------------------
		--print("done 6")
		
		for i = 1,#hGlobal.init.code do
			if type(hGlobal.init.code[i])=="function" then
				hGlobal.init.code[i](i)
			end
		end
		--print("done 7")
		--随机种子
		math.randomseed(os.time())
		
		--排行榜初始化
		hGlobal.bbMgr:Init(hVar.START_TIME)
		--print("done 8")
		
		print("android server init OK!")
	end
end
xpcall(__DoInit,hGlobal.__TRACKBACK__)
