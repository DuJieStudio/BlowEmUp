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


--初始化时需要运行的函数
hGlobal.init:add(function()
	--创建写日志单例类
	hGlobal.fileWriter = hClass.FileWriter:create():Init("log")
	
	--创建聊天日志单例类
	hGlobal.chatWriter = hClass.FileWriter:create():Init("chat")
	
	--用户货币管理
	hGlobal.userCoinMgr = hClass.UserCoinMgr:create()
	
	--创建用户管理单例类
	hGlobal.uMgr = hClass.UserMgr:create():Init(hVar.MaxUser)
	
	--创建工会管理单例类
	hGlobal.groupMgr = hClass.GroupMgr:create():Init()
	
	--创建军团红包管理单例类
	hGlobal.redPacketGroupMgr = hClass.RedPacketGroupMgr:create():Init()
	
	--创建支付（土豪）红包管理单例类
	hGlobal.redPacketPayMgr = hClass.RedPacketPayMgr:create():Init()
	
	--创建军团邀请函管理单例类
	hGlobal.inviteGroupMgr = hClass.InviteGroupMgr:create():Init()
	
	--创建聊天管理单例类（在红包初始化之后）
	hGlobal.chatMgr = hClass.ChatMgr:create():Init()
	
	--军团
	NoviceCampMgr.OnLoop()
	
	--vip管理单例类
	hGlobal.vipMgr = hClass.VipMgr:create()
	
	--英雄将魂管理单例类
	hGlobal.heroDebrisMgr = hClass.HeroDebrisMgr:create()
	
	--战术卡碎片管理单例类
	hGlobal.tacticDebrisMgr = hClass.TacticDebrisMgr:create()
	
	--用户走马灯冒字管理
	hGlobal.bubblleNoticeMgr = hClass.BubblleNoticeMgr:create():Init()
end)

xlout = function()end--printji

hVar.START_TIME = -1				--服务器的开始时间点
hVar.DELT_TIME = -1				--服务器与db的时间差

hVar.SCRIPTS_PATH = {
	--base define
	"scripts/var_ex.lua",			--各种hVar的定义
	"scripts/define.lua",			--协议定义
	"scripts/tabs/normal/var_config.lua",		--扩展hVar的定义
	
	--tab
	"scripts/tabs/tab_string.lua",		--字符串定义
	"scripts/tabs/tab_roomcfg.lua",		--房间配置
	--tab/normal
	"scripts/tabs/normal/tab_stringI.lua",	--道具字符串定义
	"scripts/tabs/normal/tab_stringTR.lua",	--宝物字符串定义
	"scripts/tabs/normal/tab_stringU.lua",	--单位字符串定义
	"scripts/tabs/normal/tab_stringTask.lua",	--任务（新）字符串定义
	"scripts/tabs/normal/tab_droppool.lua",	--掉落奖池
	"scripts/tabs/normal/tab_item.lua",	--道具列表
	"scripts/tabs/normal/tab_shopitem.lua",	--商品列表
	"scripts/tabs/normal/tab_chest.lua",	--竞技场宝箱配置
	"scripts/tabs/normal/tab_tactics.lua",	--战术技能卡
	"scripts/tabs/normal/tab_hero.lua",	--英雄配置
	"scripts/tabs/normal/tab_treasure.lua",		--宝物配置
	"scripts/tabs/normal/tab_task.lua",		--任务（新）表
	
	"scripts/tabs/tab_legionInfo.lua",	--公会建筑
	
	--luascript
	"scripts/public/hApi.lua",		--通用接口
	"scripts/public/functions.lua",
	"scripts/c2lpvpopr.lua",		--自己的数据操作
	"scripts/callback.lua",			--回调
	
	"scripts/novicecamp.lua",		--工会
}

hVar.SCRIPTS_CLASS = 
{
	"CircleFixedLenthStore",		--固定长度的循环存取容器
	"Queue",				--队列（先进先出）
	"SysCfg",				--系统配置
	"User",					--用户类
	"UserMgr",				--用户管理
	"GroupMgr",				--工会管理
	"Chat",					--聊天消息
	"ChatMgr",				--聊天管理
	"RedPacketGroup",			--军团红包
	"RedPacketGroupMgr",			--军团红包管理
	"RedPacketPay",				--支付（土豪）红包
	"RedPacketPayMgr",			--支付（土豪）红包管理
	"InviteGroup",				--军团邀请函
	"InviteGroupMgr",			--军团邀请函管理
	"FileWriter",				--写日志
	"VipMgr",				--VIP管理
	"HeroDebrisMgr",			--英雄将魂管理
	
	"UserCoinMgr",				--用户货币管理类
	"Hero",					--英雄类
	"Tactic",				--战术技能卡类
	"RedEquip",				--红装
	"RedEquipMgr",				--红装管理
	"Reward",				--奖励类
	"GroupReward",				--军团奖励类
	"Chest",				--箱子类
	"TreasureReward",			--宝物碎片奖励类
	"TacticDebrisMgr",			--宝物碎片操作类
	"BubblleNoticeMgr",			--走马灯冒字提示类
	"TaskMgr",				--任务（新）管理类
}

------------------
-- debug函数
local __LG = xlLG or function()end
G_Lua_Error_Msg = 1				--是否输出print的开关
hGlobal.__TRACKBACK__ = function(msg)
	if G_Lua_Error_Msg == 1 then
		_print("----------------------------------------")
		_print("LUA ERROR: " .. tostring(msg) .. "\n")
	end
	__LG("lua_error",tostring(msg))
	local text = debug.traceback()
	if G_Lua_Error_Msg == 1 then
		_print(text)
		_print("----------------------------------------")
	end
	__LG("log_err",tostring(text))
	--G_Lua_Error_Msg = 1
end

function xlError_CFunc(msg)
	return hGlobal.__TRACKBACK__(msg)
end


--日志常数
hVar.REWARD_LOG_TYPE = {
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

--初始化
local function __DoInit()
	do	
		
		--所有脚本dofile
		for i = 1,#hVar.SCRIPTS_PATH do
			dofile(hVar.SCRIPTS_PATH[i])
		end
		
		--注册脚本类
		for i = 1,#hVar.SCRIPTS_CLASS do
			hClass[tostring(hVar.SCRIPTS_CLASS[i])] = require("scripts.class."..tostring(hVar.SCRIPTS_CLASS[i]))
		end
		
		--设置服务器启动时间
		local err,sTick = xlDb_Query("SELECT NOW()")
		if err == 0 then
			hVar.START_TIME = sTick
			hVar.DELT_TIME = os.time() - hApi.GetNewDate(sTick)	--deltaTime = Local - Host
		else
			hVar.START_TIME = hApi.Timestamp2Time(os.time())
			hVar.DELT_TIME = 0
		end
		
		--设置服务器log等级为ELL_WARNING才能输出
		--hApi.SetLogLevel(2)
		
		--随机种子
		math.randomseed(os.time())
		
		--执行初始化时需要运行的函数
		for i = 1,#hGlobal.init.code do
			if type(hGlobal.init.code[i])=="function" then
				hGlobal.init.code[i](i)
			end
		end
		
		
		print("groupserver init OK!")
	end
end
xpcall(__DoInit,hGlobal.__TRACKBACK__)