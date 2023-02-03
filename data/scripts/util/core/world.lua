-----------------------------------
--@ by EFF 2012/12/25
--@游戏中的世界地图类
--@部队在大地图上移动和遇敌
hClass.world = eClass:new("static enum sync")
hClass.world:sync("local",{"handle","worldUI","__LOG","map","block","unitInGrid","sceobjs","worldUI","aura","aurarect","HeroLeader","HeroCardUsed","codeOnExit","netdata","bfdata"})		--设置这些表项下面的数据为本地数据，无需保存
hClass.world:sync("simple",{"units","effects","talk","team","QuestList","mapbag"})
local _hw = hClass.world

--搜索优化参数
local SORTTT_SIZE = 100 --预分配sortt表数量
local ENUM_SOTRE_SIZE = 1 --搜敌存储表数量
local ENUM_SOTRE_GAMETIME = 100 --搜敌存储表有效时间误差
local ENUM_SOTRE_WORLDX = 20 --搜敌存储表有效worldX误差
local ENUM_SOTRE_WORLDY = 20 --搜敌存储表有效worldY误差
local ENUM_SOTRE_RADIUS = 20 --搜敌存储表有效radius误差

_hw.__static = {}
local __DefaultParam = {
	netdata = 0,		--联网数据，小战场用
	bfdata = 0,		--战斗数据，小战场用
	HeroLeader = 0,		--战场专用，用以记录战场领队英雄(统帅防御等)
	userdata = 0,
	id = 0,
	w = 14,			--地图网格宽(0~w-1)
	h = 9,			--地图网格高(0~h-1)
	borderW = 0,		--不可通行边框宽度
	borderH = 0,		--不可通行边框宽度
	map = 0,		--地图名称(仅仅记录用)
	background = 0,		--地形路径，如果存在就会读取
	type = "none",		--世界类型，将锁定某个layer
	typeEX = 0,		--世界额外类型，一般是给小战场使用
	autoBF = 0,		--如果是自动小战场则此值为1
	scenetype = 0,		--世界scene字符串，如果填了此值将忽视type，加载到目标scene上
	gridtype = "Ax4",	--地图类型，奇偶格
	mapOriginX = 0,		--世界逻辑坐标左上角偏移
	mapOriginY = 0,
	bgOffsetX = 0,		--背景左上角偏移
	bgOffsetY = 0,
	gridW = 24,
	gridH = 24,
	gridOffsetX = 0,
	gridOffsetY = 0,
	gridMaskW = 0,
	gridMaskH = 0,
	gridMaskOffsetX = 0,
	gridMaskOffsetY = 0,
	sizeW = 640,
	sizeH = 480,
	IsReplay = 0,		--是否正在播放录像(小战场专用)
	codeOnExit = 0,		--小战场退出时，如果此值为function，那么执行此代码
	IsLoading = 0,		--读取标记，1:地图正在初始化,2:正在从存档读取地图，禁止创建任何特效和单位
	ImmediateLoad = 1,	--如果此项为0，则将延迟加载所有单位以及地形
	IsQuickBattlefield = 0,	--如果此项为1，则认为是一个快速战场!不加载任何资源，直接计算战斗结果
	IsPaused = 0,		--此项为1的话玩家不能操作地图
	IsNormalVictory = 1,	--如果此项为非1，则不走常规的判断胜负流程（敌人死光也不结束）
	PausedByWhat = 0,	--暂停的原因
	IsDestroyed = 0,	--如果此项为1，则地图上的物件被删除时将不执行与地图的解绑操作
	IsDrawGrid = 1,
	roundcount = 0,		--回合计数(战场专用)，这个值如果小于等于0，则禁止游戏中的单位使用技能
	started = 0,		--战场专用(首次单位激活时会对战场进行一定的处理,并将此值设置为1)
	actioncount = 0,	--执行中的action计数(战场专用)，如果此值大于0说明仍有action在执行,世界将不自动跳转到下一回合
	speed = 100,		--单位播放动画的速度，会影响出手速度
	--movespeed = 100,	--调整展场内单位的移动速度,单位的移动速度将使用此数值*基本移动速度 --geyachao: 不再生效
	unitcountM = 0,		--正在移动的单位计数
	roundID = 0,		--战场专用，用来指定一个round管理器，会在后面被指定
	playerLog = 0,		--玩家记录(积分计算)
	attackPlayerId = 0,	--战场状态时，发起进攻的玩家id
	bgm = "",
	MapMode = 0,		--地图类型
	MapDifficulty = 0,	--地图难度
	--banLimitTable = 0, --排行榜禁用表
	QuestList = 0,		--地图内的所有任务
	RandomGroupTag = 0,	--如果指定了此值，那么在随机怪组时，会优先选择和此Tag相同的随机怪组
	SelectHeroNum = 0,	--可选择英雄的数量
	playmode = 0,		--游戏模式
	MonGrowth = 50,		--随机生物每天生长率(基础5%)
	ProvidePec = 100,	--建筑资源产量比率(仅野外建筑有效)
	explock = 0,
	tactics = 0,		--已激活的战术技能(战场/世界都有)
	armybounce = 0,		--已激活的单位属性加成(仅战场有效)
	mapbag = 0,		--地图背包(仅hVar.PLAY_MODE.NO_HERO_CARD模式可用)
	uniquecast = 0,		--战场中只允许施展一次的技能
	BFTeamName = 0,		--战场中如果此项为{}，那么会为BFTeamName[playerId]显示为名字
	--PlayerInfoTgrID = {},	--玩家参数单位的tgrID
	--aura = {},
	--aurarect = {},
	--units = {},
	--sceobjs = {},
	--effects = {},
	--cover = {pec=100,rpec=0},		--战场专用,用作掩体{[gx.."|"..gy]=1},这些格子以外的单位对掩护以内的单位造成pec%的伤害，并且每个合法的墙死亡都会使伤害百分比回复rpec%
	--block = {w=1,h=1},	--战场专用
	--unitInGrid = {},
	--unitcount = {},
	--triggerIndex = {},
	--HeroCardUsed = {},
	--waypoint = {},
	--tdMapInfo, --td地图专用
	
	activeSelectedUnit = 0, --主动选中的英雄单位
	
	randomcount = 0, --随机数调用次数
	
	--randomMapRooms = 0, --随机地图房间表
	--randomMapFarSceneObj = 0, --随机地图远景物件
	--randomMapNearSceneObj = 0, --随机地图近景物件
	randommapInfo = 0, --随机地图信息
	randommapIdx = 0, --当前所在随机地图索引
	randommapStage = 0, --当前所在随机地图层数
	
	keypadEnabled = true, --是否允许响应事件
	keypadState = {}, --按键状态
	keypadWASD = "----", --WASD按键值
	
	--可到达边界
	rangeL = 0,
	rangeR = 0,
	rangeU = 0,
	rangeD = 0,
	
	--主角坦克
	rpgunit_tank = 0,
	
	--主角坦克上一帧坐标（用于扔手雷更远）
	rpgunit_last_x = 0,
	rpgunit_last_y = 0,
	
	--我方单位
	rpgunits = {},
	
	--我方跟随的宠物
	follow_pet_unit = 0,
	
	--统计单位死亡的次数
	unitdeathcounts = 0,
	
	--touchDown = false, --是否touch按下
	
	--地图内普通单位的数量
	unit_num = 0, --地图内单位的数量
	
	rebirthT = {}, --geyachao: 复活英雄存储的表{[index] = {oDeadHero = xx, deadoUint = xx, beginTick = 0, rebithTime = 10000, progressUI = xx, labelUI = xx, roadPoint = xx,}, ...}
	--buildT = {}, --geyachao: 造塔的按钮控件集
	selectedHeroList = {}, --geyachao: 本局选择的英雄列表
	tacticCardCtrls = {}, --geyachao: 战术技能卡控件集（一般类战术技能卡，还有难度附加的敌人增益类战术卡）
	statistics = {hero = {}, tower = {}, tactic = {}, mapTactic = {}, deadCount = {}, killEnemyNum = {}, killBossNum = {},}, --geyachao: 本局对战中使用的统计数据
	statistics_dmg_sum = 0, --统计总有效伤害
	statistics_dmg_hurt = 0, --统计战车受到的总伤害
	statistics_dmg_lasttick = 0, --统计总有效伤害的上次时间
	statistics_rescue_count = 0,--大菠萝营救的科学家数量(随机关单局数据)
	statistics_rescue_num = 0, --大菠萝营救的科学家数量(随机关累加数据)
	statistics_rescue_costnum = 0,--大菠萝营救的科学家消耗数量
	
	
	linkeffect_counter = 0, --连接特效计数器
	linkeffects = {}, --连接特效表
	
	hookeffect_counter = 0, --钩子特效计数器
	hookeffects = {}, --钩子特效表
	
	endless_build_tactics = {}, --新无尽群英阁地图全体玩家的选卡列表 {[pos1] = {...}, [pos2] = {...},[pos3] = {...},[pos4] = {...},[pos5] = {...},}
	endless_redraw_count = {}, --新无尽群英阁重抽卡的次数 {[pos1] = 0, [pos2] = 0,[pos3] = 0,[pos4] = 0,[pos5] = 0,}
	
	damageAreaPerfList = {}, --范围伤害效率优化表
	
	--大菠萝
	weapon_attack_state = 0, --武器是否为攻击状态(1:攻击/0:不是攻击/2:自动攻击)
	tank_bossmode = 0, --是否为打boss状态
	
	tactic_use_state = 0, --战术卡已释放状态(1:已经使用过了/0:从未使用过战术卡)
	
	shaketick = 0,		--震动剩余时间
	shakestarttime = 0,	--开启震动的时间
	lockscreen = 0,		--锁屏
	
	--world的timer相关参数
	__timers = {},
	__beginFrameCount = 0, --开始计时时的帧数
	__frameCount = 0, --当前帧数
	__bEnableTimer = false, --是否允许timer
	
	--计数本world里创建了多少个单位
	__unitCounter = 0,
	
	--虚拟摇杆控件
	__virtualController = 0,
	
	--world的搜敌优化相关参数
	__areaT = {}, --geyachao: 所有单位所在的区域表（用于搜敌优化）
	__sorttt = {}, --geyachao: 搜敌排序表（用于内存优化）
	__enumStore = {}, --geyachao: 存储之前搜敌数据（用于搜敌优化）
	
	--world的水区域
	__waterRegionT = {}, --geyachao: 地图内所有水区域box
	
	sessionId = 0, --游戏局id,只有pvp有正数值
	session_dbId = 0, --游戏局唯一id,只有pvp有正数值
	session_cfgId = 0, --竞技场配置id
	randomSeed = 0, --随机种子
	pvpTempTable = {}, --pvp的存储数据的表
	
	endTurnInterval = 0, --每回合客户端提前多少帧发送结束回合
	framePerTurn = 0, --每回合多少帧
	opExecuteInterval = 0, --每回合执行op的帧数间隔（第一回合的指令执行时间是 第一回合对应帧数+间隔）
	bUseEquip = false, --是否使装备生效
	validTime = 0, --有效局的最少时长
	bIsArena = false, --是否是擂台赛
	
	pvp_buy_rebirth_count = {}, --pvp购买复活的次数
	pvp_rewardInfo = 0, --魔龙宝库、铜雀台抽奖信息
	
	pvp_round_ahead = 0, --铜雀台、新手地图的前置层数（打完boss就标记前置层数加1，传送后才真正标记层数加1，两者最大相差1）
	pvp_round = 0, --铜雀台、新手地图的层数
	
	tinyboss_occurtime = -1, --小Boss出场倒计时（单位: 毫秒）
	
	result_invalid_str = "", --pvp无效局的原因描述
	result_envaluate_table = nil, --pvp战绩结果下发
	
	box_dynamic_points = {}, --动态障碍所属坐标点（除以24后的结果）
	
	Trigger_OnUnitDead_UnitList = {}, --战车单位死亡后触发的事件检测（用于追查问题，有时boss死后未触发技能）
	
	client_fps = 60,	--客户端帧数
	tick_time = 16,		--客户端每一帧的间隔时间（毫秒）
	
	hTurn = 0, --服务器的turn
	cTurn = 0, --客户端的turn
	cTurnFinish = 0, --客户端完成指令的turn
	
	heartTime = 0, --心跳包上次收到的时间
	leftHeartTime = 60 * 1000, --心跳包剩余等待时间（毫秒）
	
	customData = {}, --用户自定义数据块
	customDataPivot = 0, --用户自定义数据块可用索引（自增值）
}
---------------------------------------------------------
-- 地形模式
-- Ax4,Ax6,Ax6o,Ax6e
hGlobal.GridFunc = {
	["Ax4"] = {},		--四方格
	--["Ax6"] = {},		--六角格
	["Ax6o"] = {},		--六角格，奇数行+1
	["Ax6e"] = {},		--四方格，偶数行+1
}
local __loadGridMode = hApi.DoNothing		--后面有此函数的定义
local __EmptyParam = {}

------------------------
-- 初始化
_hw.init = function(self, p)
	p = p or __EmptyParam
	--INIT START--
	self.data = hApi.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.handle = hApi.clearTable("H",rawget(self,"handle"))
	self.worldUI = hApi.clearTable("H",rawget(self,"worldUI"))
	self.map = {}				--地图信息(虽然data里面也有一个map但是那只是个字符串)
	self.__LOG = {i=0,cur=0}		--战报专用
	
	local d = self.data
	local h = self.handle
	--记录到全局变量
	hGlobal.LastCreateWorld = self
	if d.type=="worldmap" and d.scenetype==0 then	
		hGlobal.WORLD.LastWorldMap = self
		d.dayscore = 0
	elseif d.type=="town" then
		hGlobal.WORLD.LastTown = self
	end
	if d.scenetype==0 then
		if d.type=="worldmap" then
			d.scenetype = "worldmap"
		elseif d.type=="town" then
			d.scenetype = "town"
		elseif d.type=="battlefield" then
			d.scenetype = "battlefield"
		else
			d.scenetype = "worldmap"
		end
	end
	d.netdata = 0						--读档的话没有网络数据
	d.IsLoading = 0						--关掉读档开关
	d.lords = hApi.clearTable("H",d.lords)			--参战英雄
	d.units = hApi.clearTable("I",d.units)			--世界单位
	d.sceobjs = hApi.clearTable("I",d.sceobjs)		--世界场景物件
	d.effects = hApi.clearTable("I",d.effects)		--世界特效
	d.aura = hApi.clearTable("I",d.aura)			--世界光环
	d.aura.__count = 0					--光环绝对计数
	d.aurarect = {}						--世界光环作用区域
	d.PlayerInfoTgrID = {}					--玩家参数tgrID表
	d.PlayerList = {}					--玩家列表 add by zhenkira
	d.PlayerDic = {}					--玩家列表 add by zhenkira
	d.PlayerMe = nil					--自己
	d.sessionId = p.sessionId or -1				--游戏局id,只有pvp有正数值
	d.session_dbId = p.session_dbId or -1		--游戏局唯一id,只有pvp有正数值
	d.session_cfgId = p.session_cfgId or -1		--竞技场配置id,只有pvp有正数值
	d.randomSeed = p.randomSeed or os.time()		--随机种子
	d.pvpTempTable = {} --pvp的存储数据的表
	
	d.endTurnInterval = p.endTurnInterval or 1		--每回合客户端提前多少帧发送结束回合
	d.framePerTurn = p.framePerTurn or 6			--每回合多少帧
	d.opExecuteInterval = p.opExecuteInterval or 1		--每回合执行op的帧数间隔（第一回合的指令执行时间是 第一回合对应帧数+间隔）
	d.bUseEquip = p.bUseEquip or false
	d.validTime = p.validTime or 0
	d.bIsArena = p.bIsArena or false --是否是擂台赛
	d.pvp_buy_rebirth_count = {} --pvp购买复活的次数
	for i = 1, 20, 1 do
		d.pvp_buy_rebirth_count[i] = 5
	end
	d.pvp_rewardInfo = 0 --铜雀台抽奖信息
	d.pvp_round_ahead = 0 --铜雀台、新手地图的前置层数（打完boss就标记前置层数加1，传送后才真正标记层数加1，两者最大相差1）
	d.pvp_round = 0 --铜雀台、新手地图的层数
	d.tinyboss_occurtime = -1 --小Boss出场倒计时（单位: 毫秒）
	d.result_invalid_str = "" --pvp无效局的原因描述
	d.result_envaluate_table = nil --pvp战绩结果下发
	
	d.box_dynamic_points = {} --动态障碍所属坐标点（除以24后的结果）
	
	d.Trigger_OnUnitDead_UnitList = {} --战车单位死亡后触发的事件检测（用于追查问题，有时boss死后未触发技能）
	
	d.client_fps = 60 --客户端帧数
	d.tick_time = 16 --客户端每一帧的间隔时间（毫秒）
	
	--低配模式
	local flag = LuaGetTankLowConfigMode()
	if (flag == 1) then
		d.client_fps = 30 --客户端帧数
		d.tick_time = 32 --客户端每一帧的间隔时间（毫秒）
	end
	
	if xlSetFPSInterval then
		xlSetFPSInterval(d.client_fps)
	end
	
	d.hTurn = 0 --服务器的turn
	d.cTurn = 0 --客户端的turn
	d.cTurnFinish = 0 --客户端完成指令的turn
	d.heartTime = 0 --心跳包上次收到的时间
	d.leftHeartTime = 60 * 1000 --心跳包剩余等待时间（秒）
	
	d.customData = {} --用户自定义数据块
	d.customDataPivot = 0 --用户自定义数据块可用索引（自增值）
	
	math.randomseed(d.randomSeed)
	
	--清空指令表
	hVar.CommandList = {} --指令列表
	hVar.CheckSumList = {} --客户端校验值缓存表
	
	--加载资源之前需要初始化进入当前地图的所有玩家信息
	self:SetPlayerList(p.pList)
	
	d.HeroCardUsed = {}					--已生效的英雄卡片，防止重复加载(临时)
	d.cover = {pec=100,rpec=0}
	d.block = {w=1,h=1}
	d.unitInGrid = {{},{},{}}				--{[1] = {单位},[2] = {建筑},[3] = {被动单位,这一项可以有多个单位在同个格子上}}
	d.waypoint = {}						--{{key,x,y},}
	d.tdMapInfo = {
		mapState = hVar.MAP_TD_STATE.IDLE,
		mapLastState = hVar.MAP_TD_STATE.IDLE,
		mapSetting = {},
		allMovePointPos = {},
		allBeginPointPos = {},
		wildPoint = {},
		portal = {},
		portalFinishState = {}, --某层是否已传送过
		passthrough = {}, --穿越区域
		eventUnit = {},		--事件单位
	}							--td地图专用信息列表
	
	d.baseTower = 0
	d.activeSelectedUnit = 0 --主动选中的英雄单位
	
	--geyachao: 复活相关 初始化
	d.keypadEnabled = true --是否允许响应事件
	d.keypadState = {} --按键状态
	d.keypadWASD = "----" --WASD按键值
	--d.touchDown = false --是否touch按下
	d.unit_num = 0 --地图内单位的数量
	d.rpgunit_tank = 0 --主角坦克
	d.rpgunit_last_x = 0 --主角坦克上一帧坐标（用于扔手雷更远）
	d.rpgunit_last_y = 0 --主角坦克上一帧坐标（用于扔手雷更远）
	d.rpgunits = {} --我方单位
	d.follow_pet_unit = 0 --我方跟随的宠物
	d.unitdeathcounts = {} --统计单位死亡的次数
	d.unitdeathcounts[hVar.FORCE_DEF.GOD] = {} --神
	d.unitdeathcounts[hVar.FORCE_DEF.SHU] = {} --蜀国
	d.unitdeathcounts[hVar.FORCE_DEF.WEI] = {} --魏国
	d.unitdeathcounts[hVar.FORCE_DEF.NEUTRAL] = {} --中立无敌意
	d.unitdeathcounts[hVar.FORCE_DEF.NEUTRAL_ENEMY] = {} --中立有敌意
	
	--d.randomMapRooms = 0 --随机地图房间表
	--d.randomMapFarSceneObj = 0 --随机地图远景物件
	--d.randomMapNearSceneObj = 0 --随机地图近景物件
	d.randommapInfo = {} --随机地图信息
	d.randommapIdx = 0 --当前所在随机地图索引
	d.randommapStage = 0 --当前所在随机地图层数
	
	--可到达边界
	d.rangeL = 0
	d.rangeR = 0
	d.rangeU = 0
	d.rangeD = 0
	d.rebirthT = {} --复活存储数据 {[index] = {deadoUint = xx, beginTick = 0, rebithTime = 10000, progressUI = xx, labelUI = xx,}, ...}
	d.selectedHeroList = {} --geyachao: 本局选择的英雄列表
	d.tacticCardCtrls = {} --geyachao: 战术技能卡控件集（一般类战术技能卡，还有难度附加的敌人增益类战术卡）
	d.statistics = {hero = {}, tower = {}, tactic = {}, mapTactic = {}, deadCount = {}, killEnemyNum = {}, killBossNum = {},} --geyachao: 本局对战中使用的统计数据
	d.__timers = {} --监听timer表
	d.statistics_dmg_sum = 0 --统计总有效伤害
	d.statistics_dmg_hurt = 0 --统计战车受到的总伤害
	d.statistics_dmg_lasttick = 0 --统计总有效伤害的上次时间
	d.statistics_rescue_count = 0--大菠萝营救的科学家数量(随机关单局数据)
	d.statistics_rescue_num = 0 --大菠萝营救的科学家数量(随机关累加数据)
	d.statistics_rescue_costnum = 0 --大菠萝营救的科学家消耗数量
	d.statistics_current_pet_follow = 0 --当前跟随宠物数量
	d.statistics_max_pet_follow = 0 --最大跟随宠物数量

	d.mapShareGroup = {}	--地图共享随机组  如果只需要初始随一次的存这里
	
	--大菠萝
	d.weapon_attack_state = 0 --武器是否为攻击状态
	d.tank_bossmode = 0 --是否为打boss状态
	
	d.tactic_use_state = 0 --战术卡已释放状态
	
	d.linkeffect_counter = 0 --连接特效计数器
	d.linkeffects = {} --连接特效表
	
	d.hookeffect_counter = 0 --钩子特效计数器
	d.hookeffects = {} --钩子特效表
	
	d.endless_build_tactics = {} --新无尽群英阁地图全体玩家的选卡列表 {[pos1] = {...}, [pos2] = {...},[pos3] = {...},[pos4] = {...},[pos5] = {...},}
	d.endless_redraw_count = {} --新无尽群英阁重抽卡的次数 {[pos1] = 0, [pos2] = 0,[pos3] = 0,[pos4] = 0,[pos5] = 0,}
	
	d.damageAreaPerfList = {} --范围伤害效率优化表
	
	d.__timers = {} --监听timer表
	d.__beginFrameCount = 0 --开始计时时的帧数
	d.__frameCount = 0 --当前帧数
	d.__bEnableTimer = false --是否允许timer
	
	d.__unitCounter = 0 --统计world的单位数量计数器
	
	d.__virtualController = 0 --虚拟摇杆控件
	
	d.__areaT = {} --geyachao: 所有单位所在的区域表（用于搜敌优化）
	for force = hVar.FORCE_DEF.FORCE_MIN, hVar.FORCE_DEF.FORCE_MAX, 1 do
		d.__areaT[force] = {} --每个阵营都单独存储格子信息
	end
	
	d.__sorttt = {} --geyachao: 搜敌排序表（用于内存优化）
	--预分配内存
	for i = 1, SORTTT_SIZE, 1 do
		d.__sorttt[i] = {}
	end
	
	d.__enumStore = {} --geyachao: 存储之前搜敌数据（用于搜敌优化）
	d.__enumStore[hVar.PLAYER_ALLIENCE_TYPE.NONE] = {} --enumAll
	d.__enumStore[hVar.PLAYER_ALLIENCE_TYPE.ALLY] = {} --enumAlly
	d.__enumStore[hVar.PLAYER_ALLIENCE_TYPE.ENEMY] = {} --enumEnemy
	for i = 1, ENUM_SOTRE_SIZE, 1 do
		d.__enumStore[hVar.PLAYER_ALLIENCE_TYPE.NONE][i] = {gametime = 0, worldX = 0, worldY = 0, radius = 0, unitlist = {},}
		d.__enumStore[hVar.PLAYER_ALLIENCE_TYPE.ALLY][i] = {gametime = 0, worldX = 0, worldY = 0, radius = 0, unitlist = {},}
		d.__enumStore[hVar.PLAYER_ALLIENCE_TYPE.ENEMY][i] = {gametime = 0, worldX = 0, worldY = 0, radius = 0, unitlist = {},}
	end
	
	d.__waterRegionT = {} --geyachao: 地图内所有水区域box
	
	--d.UnitArriving = {}
	if d.type=="worldmap"then
		d.playerLog = {}					--玩家记录(积分计算)
	elseif d.type=="battlefield" then
		d.HeroLeader = {}					--英雄领队
	end
	
	d.unitcount = {idx={}}						--单位计数
	d.triggerIndex = {}						--触发器数据
	
	d.IsDrawGrid = hVar.OPTIONS.IS_DRAW_GRID			--记在全局变量中的"是否绘制网格"
	d.roundID = 0							--战场管理器，可能在后面被设置
	
	--读取参数中的特殊信息
	if p.gridOffsetX~=nil and p.gridOffsetY~=nil then
		d.gridOffsetX = hApi.getint(d.gridW/2)
		d.gridOffsetY = hApi.getint(d.gridH/2)
	end
	
	--geyachao: 读取排行榜配置信息
	if p.banLimitTable then
		d.banLimitTable = p.banLimitTable
	else
		d.banLimitTable = nil
	end
	
	--zhenkira: 读取服务器全局战术技能信息(铜雀台会下发)
	if p.pveMultiTacticCfg then
		d.pveMultiTacticCfg = p.pveMultiTacticCfg
	else
		d.pveMultiTacticCfg = nil
	end
	
	local sTemplateMap = p.template
	if sTemplateMap==nil then
		if d.type=="worldmap"then
			sTemplateMap = hVar.DEFAULT_WORLDMAP
		elseif d.type=="town" then
			sTemplateMap = hVar.DEFAULT_TOWN
		elseif d.type=="battlefield" then
			sTemplateMap = hVar.DEFAULT_BATTLEFIELD
		end
	end
	
	--DEBUG--
	if (d.map == 0) then
		_map = hApi.ReadParam(hVar.MAPS.DEFAULT,nil,{},2)
		rawset(self,"map",_map)
		d.gridtype = "Ax4"
		__loadGridMode(self,d.gridtype)
		_DEBUG_MSG("	- [world]"..tostring(self.ID)..":未指定地图文件，此世界不触发事件[Event_WorldCreated]，请手动调用世界创建事件")
	elseif d.ImmediateLoad==0 then
		--_DEBUG_MSG("	- [world]"..tostring(d.map)..":将延迟加载，此世界不触发事件[Event_WorldCreated]，请手动调用世界创建事件")
	else
		local mapBackground,unitList,triggerData = hApi.LoadMap(d.map,sTemplateMap)
		print("加载地图！read from param = "..tostring(d.background).."  read from DAT = "..tostring(mapBackground))
		if type(p.background)=="string" then
			--使用参数里面传入的背景图
		elseif type(mapBackground)=="string" then
			--使用读取的背景图
			d.background = mapBackground
		end
		self:loadMapTile(d.background)
		if unitList~=nil then
			self:loadAllObjects(unitList,triggerData)
		end
		hGlobal.event:call("Event_WorldCreated",self,0)
	end
	
	--经验锁定模式
	--d.explock = 0
	--for i = 1,#hVar.CanNotGetExpMapName do
		--if hVar.CanNotGetExpMapName[i] == d.map then
			----马征让我改掉，以后地图没有经验锁定模式了
			----d.explock = 1
		--end
	--end
	
	--武器数据初始化
	hGlobal.LocalPlayer:initweapon()
	hGlobal.LocalPlayer:__updateweapon()
	hGlobal.LocalPlayer:noticeweapon(nil)
end

--world的timer逻辑
local __timer_loop_no_error = true
hClass.world.__timer_loop = function(__self, frame_count)
	--如果程序执行错误，直接返回
	if (not __timer_loop_no_error) then
		return
	end
	
	--遍历每个world
	hClass.world:enum(function(self)
		local d = self.data
		local tick_time = d.tick_time
		
		--print("速率:", hApi.GetTimeScale(), d.cTurn, d.hTurn)
		--加速
		for i = 1, hApi.GetTimeScale(), 1 do
			--如果游戏暂停，直接跳出循环
			if (d.IsPaused == 1) then
				return
			end
			
			--timer未启动，直接退出
			if (not d.__bEnableTimer) then
				return
			end
			
			--非TD地图，直接跳出循环
			local mapInfo = d.tdMapInfo
			if (not mapInfo) then
				return
			end
			
			--游戏暂停或结束，直接退出
			if (mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE) or (mapInfo.mapState == hVar.MAP_TD_STATE.END) then
				return
			end
			
			--如果客户端的turn大于服务器的turn，暂停逻辑，不跑timer
			--print("cTurn=" .. d.cTurn, "hTurn=" .. d.hTurn)
			if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
				--客户端本帧是否发送新的turn
				local fc = d.__frameCount - d.__beginFrameCount
				local tickMod = (fc + 1) % d.framePerTurn --余数
				local triggerTickMod = d.framePerTurn - d.endTurnInterval --客户端下次发送同步消息的帧数
				if ((tickMod) == triggerTickMod) then
					--print("endTurnInterval", d.endTurnInterval, "framePerTurn", d.framePerTurn, "opExecuteInterval", d.opExecuteInterval)
					
					---if (d.cTurn > d.hTurn) or (d.cTurnFinish < d.hTurn) then
					--geyachao: 此处为非同步日志: timer_loop
					if (hVar.IS_ASYNC_LOG == 1) then
						d.__frameCount = d.__frameCount + 1 -- * hApi.GetTimeScale()
						local msg = "xxx-timer_loop: " .. ", hTurn=" .. d.hTurn .. ", cTurn=" .. d.cTurn
						hApi.AsyncLog(msg)
						d.__frameCount = d.__frameCount - 1 -- * hApi.GetTimeScale()
					end
					
					if (d.cTurn >= d.hTurn) then
						--暂停
						self:pause(1, "TD_PAUSE")
						mapInfo.mapLastState = mapInfo.mapState
						mapInfo.mapState = hVar.MAP_TD_STATE.PAUSE
						
						--冒字暂停
						if (hVar.IS_CLIENT_NET_UI == 1) then --geyachao: 是否显示客户端网络状态界面（等待服务器、追帧）
							local strText = "等待服务器响应..."
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
						
						--跳出循环
						return
					--elseif (d.cTurn == d.hTurn) then --停止追帧
						--
					else --客户端慢
						--[[
						local speed = hApi.GetTimeScale()
						--恢复速度
						if (speed > 1) then
							self:speedUp(false)
						end
						]]
						
						d.cTurn = d.cTurn + 1
						--print("d.cTurn=", d.cTurn)
						
						--计算同步检验和
						local checkSum_RandomNum, checkSum_UnitNum, checkSum_Pos, checkSum_Attr = hApi.CheckSum_Sync()
						--print("checkSum=", checkSum_RandomNum, checkSum_UnitNum, checkSum_Pos, checkSum_Attr)
						
						--插入客户端校验值缓存表
						hVar.CheckSumList[d.cTurn] = {checkSum_RandomNum, checkSum_UnitNum, checkSum_Pos, checkSum_Attr,}
						--if hVar.CheckSumList[d.cTurn - 50] then
						--	hVar.CheckSumList[d.cTurn - 50] = nil
						--end
						
						--客户端本帧是否发送新的turn
						--print("客户端本帧是否发送新的turn")
						hApi.AddCommand(hVar.Operation.BeginTurn, d.cTurn, checkSum_RandomNum, checkSum_UnitNum, checkSum_Pos, checkSum_Attr)
					end
				end
			end
			
			--存储当前的帧数(从启动world就开始计时了)
			--print(d.__frameCount)
			d.__frameCount = d.__frameCount + 1 -- * hApi.GetTimeScale()
			
			--现在实际的帧数
			local fc = d.__frameCount - d.__beginFrameCount
			
			--if (fc == 1000) then
			--	--加载当前玩家pvp相关操作界面
			--	hGlobal.event:event("LocalEvent_TD_NextWave", true)
			--end
			
			--依次遍历每个timer
			for i = 1, #d.__timers, 1 do
				local v = d.__timers[i]
				local key = v[1] --key
				local tickTimer = v[2] --timer时间
				local lasttime = v[3] --上次触发的时间
				local callback = v[4] --回调函数
				local currenttime = fc * tick_time --当前时间
				local deltatime = currenttime - lasttime --距离上次触发的时间差
				
				--print("tickTimer=", tickTimer, "lastFrame=", lastFrame, "frameDelta=", frameDelta)
				if (deltatime >= tickTimer) then
					--触发timer
					if callback then
						--安全执行
						local bError = hpcall(callback, deltatime)
						if (not bError) then
							--如果执行失败，会弹框，timer要停掉
							__timer_loop_no_error = false
						end
						--callback(deltatime)
					end
					
					--标记这次timer触发的帧数
					--v[3] = currenttime
					v[3] = lasttime + tickTimer --geyachao: 为了修正timer精度导致的积累误差，这里修改写法
				end
			end
		end
	end)
end

--启动word的timer
_hw.enableTimer = function(self)
	--print("_hw.enableTimer", tostring(self))
	local d = self.data
	
	if (not d.__bEnableTimer) then
		d.__beginFrameCount = d.__frameCount
		
		--对已有的timer，重置开始时间
		for i = 1, #d.__timers, 1 do
			d.__timers[i][3] = 0 --上次触发的帧数(实际帧数)
		end
		d.__bEnableTimer = true
	end
end

--停用word的timer
_hw.disableTimer = function(self)
	--print("_hw.enableTimer", tostring(self))
	local d = self.data
	
	d.__bEnableTimer = false
end

--继续word的timer
_hw.resumeTimer = function(self)
	--print("_hw.enableTimer", tostring(self))
	local d = self.data
	
	d.__bEnableTimer = true
end

--添加world的timer
_hw.addtimer = function(self, key, tickTimer, callback)
	local d = self.data
	local tick_time = d.tick_time
	
	--检测是否已存在
	for i = 1, #d.__timers, 1 do
		if (d.__timers[i][1] == key) then
			print("_hw.addTimer, 已存在key=" .. tostring(key))
			return
		end
	end
	
	--timer最小精度
	if (tickTimer < tick_time) then
		tickTimer = tick_time
	end
	
	--现在实际的帧数
	local fc = d.__frameCount - d.__beginFrameCount
	local currenttime = fc * tick_time
	--local tick = math.ceil(tickTimer / tick_time)
	table.insert(d.__timers, {key, tickTimer, currenttime, callback}) --key, tickTimer, lasttime, callback
end

--移除world的timer
_hw.removetimer = function(self, key)
	local d = self.data
	
	--检测是否已存在
	for i = 1, #d.__timers, 1 do
		if (d.__timers[i][1] == key) then
			table.remove(d.__timers, i)
			return
		end
	end
end

--获取当前world的游戏帧数
_hw.gametick = function(self)
	local d = self.data
	
	if (not d.__bEnableTimer) then
		return 0
	else
		--现在实际的帧数
		local fc = d.__frameCount - d.__beginFrameCount
		return fc
	end
end

--获取当前world的游戏时间
_hw.gametime = function(self)
	local d = self.data
	local tick_time = d.tick_time
	
	if (not d.__bEnableTimer) then
		return 0
	else
		--现在实际的帧数
		local fc = d.__frameCount - d.__beginFrameCount
		return fc * tick_time
	end
end

--添加单位的区域信息
_hw.addArea = function(self, oUnit, ux, uy)
	local d = self.data
	local owner = oUnit.data.owner --位置
	local force = 0 --属方
	if (owner >= 1) and (owner <= 10) then
		force = hVar.FORCE_DEF.SHU --蜀国
	elseif (owner >= 11) and (owner <= 20) then
		force = hVar.FORCE_DEF.WEI --魏国
	elseif (owner == 21) then
		force = hVar.FORCE_DEF.SHU --蜀国(上帝)
	elseif (owner == 22) then
		force = hVar.FORCE_DEF.WEI --魏国(上帝)
	elseif (owner == 23) then
		force = hVar.FORCE_DEF.NEUTRAL --中立无敌意
	elseif (owner == 24) then
		force = hVar.FORCE_DEF.NEUTRAL_ENEMY --中立有敌意
	end
	
	local areaTS = d.__areaT[force] --所有单位所在的区域表（用于搜敌优化）
	
	if (not ux) or (not uy) then
		ux, uy = hApi.chaGetPos(oUnit.handle) --角色的坐标
	end
	
	local area_xn = math.ceil(ux / hVar.AREA_EDGE)
	local area_yn = math.ceil(uy / hVar.AREA_EDGE)
	
	--存储角色的区域
	if (areaTS[area_xn] == nil) then
		areaTS[area_xn] = {}
	end
	if (areaTS[area_xn][area_yn] == nil) then
		areaTS[area_xn][area_yn] = {}
	end
	
	--建立2份表，一个是数组表，一个是hash表
	--数组表用于遍历，hash表用于快速定位oUnit的位置
	local areaTSXY = areaTS[area_xn][area_yn]
	local areaTSXYLength = #areaTSXY --长度
	areaTSXY[areaTSXYLength + 1] = oUnit
	areaTSXY[oUnit] = areaTSXYLength + 1
	
	oUnit.data.area_xn = area_xn
	oUnit.data.area_yn = area_yn
	--print("addArea ".. force, oUnit.data.name, "(" .. area_xn .. ", " .. area_yn .. ")")
end

--更新单位的区域信息
_hw.updateArea = function(self, oUnit, ux, uy)
	local d = self.data
	local owner = oUnit.data.owner --位置
	local force = 0 --属方
	if (owner >= 1) and (owner <= 10) then
		force = hVar.FORCE_DEF.SHU --蜀国
	elseif (owner >= 11) and (owner <= 20) then
		force = hVar.FORCE_DEF.WEI --魏国
	elseif (owner == 21) then
		force = hVar.FORCE_DEF.SHU --蜀国(上帝)
	elseif (owner == 22) then
		force = hVar.FORCE_DEF.WEI --魏国(上帝)
	elseif (owner == 23) then
		force = hVar.FORCE_DEF.NEUTRAL --中立无敌意
	elseif (owner == 24) then
		force = hVar.FORCE_DEF.NEUTRAL_ENEMY --中立有敌意
	end
	
	local areaTS = d.__areaT[force] --所有单位所在的区域表（用于搜敌优化）
	
	if (not ux) or (not uy) then
		ux, uy = hApi.chaGetPos(oUnit.handle) --角色的坐标
	end
	
	local area_xn = math.ceil(ux / hVar.AREA_EDGE)
	local area_yn = math.ceil(uy / hVar.AREA_EDGE)
	
	--存储角色的区域
	local old_area_xn = oUnit.data.area_xn
	local old_area_yn = oUnit.data.area_yn
	
	if (old_area_xn == nil) then
		return
	end
	
	if (old_area_yn == nil) then
		return
	end
	
	--不重复设置
	if (old_area_xn ~= area_xn) or (old_area_yn ~= area_yn) then
		--存储角色的区域
		if (areaTS[area_xn] == nil) then
			areaTS[area_xn] = {}
		end
		if (areaTS[area_xn][area_yn] == nil) then
			areaTS[area_xn][area_yn] = {}
		end
		
		if (areaTS[old_area_xn] == nil) then
			return
		end
		
		local areaTSXY_old = areaTS[old_area_xn][old_area_yn]
		local areaTSXY = areaTS[area_xn][area_yn]
		
		--删除旧信息
		local oldLength = #areaTSXY_old --原格子表长度
		local oldIndex = areaTSXY_old[oUnit]
		areaTSXY_old[oUnit] = nil
		areaTSXY_old[oldIndex] = nil
		
		--旧信息的最后一项，填充到被删除的位置
		if (oldIndex < oldLength) then
			local oUnit_old_last = areaTSXY_old[oldLength] --原格子的最后一项(角色)
			areaTSXY_old[oldIndex] = oUnit_old_last
			areaTSXY_old[oldLength] = nil
			areaTSXY_old[oUnit_old_last] = oldIndex
		end
		
		--旧表已经没内容了
		if (oldLength <= 1) then
			areaTS[old_area_xn][old_area_yn] = nil
		end
		
		--更新新信息
		local areaTSXYLength = #areaTSXY --长度
		areaTSXY[areaTSXYLength + 1] = oUnit
		areaTSXY[oUnit] = areaTSXYLength + 1
		
		oUnit.data.area_xn = area_xn
		oUnit.data.area_yn = area_yn
		--print("updateArea ".. force, oUnit.data.name, "(" .. old_area_xn .. ", " .. old_area_yn .. ") -> (" .. area_xn .. ", " .. area_yn .. ")")
	end
end

--删除单位的区域信息
_hw.removeArea = function(self, oUnit)
	local d = self.data
	local owner = oUnit.data.owner --位置
	local force = 0 --属方
	if (owner >= 1) and (owner <= 10) then
		force = hVar.FORCE_DEF.SHU --蜀国
	elseif (owner >= 11) and (owner <= 20) then
		force = hVar.FORCE_DEF.WEI --魏国
	elseif (owner == 21) then
		force = hVar.FORCE_DEF.SHU --蜀国(上帝)
	elseif (owner == 22) then
		force = hVar.FORCE_DEF.WEI --魏国(上帝)
	elseif (owner == 23) then
		force = hVar.FORCE_DEF.NEUTRAL --中立无敌意
	elseif (owner == 24) then
		force = hVar.FORCE_DEF.NEUTRAL_ENEMY --中立有敌意
	end
	
	local areaTS = d.__areaT[force] --所有单位所在的区域表（用于搜敌优化）
	
	local old_area_xn = oUnit.data.area_xn
	local old_area_yn = oUnit.data.area_yn
	
	--删除角色的区域
	local areaTSXY_old = areaTS[old_area_xn][old_area_yn]
	local oldLength = #areaTSXY_old --原格子表长度
	local oldIndex = areaTSXY_old[oUnit]
	
	areaTSXY_old[oUnit] = nil
	areaTSXY_old[oldIndex] = nil
	
	--旧信息的最后一项，填充到被删除的位置
	if (oldIndex < oldLength) then
		local oUnit_old_last = areaTSXY_old[oldLength] --原格子的最后一项(角色)
		areaTSXY_old[oldIndex] = oUnit_old_last
		areaTSXY_old[oldLength] = nil
		areaTSXY_old[oUnit_old_last] = oldIndex
	end
	
	--旧表已经没内容了
	if (oldLength <= 1) then
		areaTS[old_area_xn][old_area_yn] = nil
	end
	
	oUnit.data.area_xn = 0
	oUnit.data.area_yn = 0
	--print("removeArea ".. force, oUnit.data.name, "(" .. old_area_xn .. ", " .. old_area_yn .. ")")
end

--依次遍历地图上指定范围内的所有单位
_hw.enumunitArea = function(self, force, worldX, worldY, radius, code, param, param2, ...)
	if (radius > 0) then
		if code then
			worldX = math.floor(worldX * 100) / 100  --保留2位有效数字，用于同步
			worldY = math.floor(worldY * 100) / 100  --保留2位有效数字，用于同步
			radius = math.floor(radius * 100) / 100  --保留2位有效数字，用于同步
			
			local pos_xn_left = math.floor((worldX - radius) / hVar.AREA_EDGE) --区域最左侧
			local pos_xn_right = math.ceil((worldX + radius) / hVar.AREA_EDGE) --区域最右侧
			local pos_yn_up = math.floor((worldY - radius) / hVar.AREA_EDGE) --区域最上侧
			local pos_yn_down = math.ceil((worldY + radius) / hVar.AREA_EDGE) --区域最下侧
			
			--依次遍历在这些区域内的所有单位
			local d = self.data
			local DISTANCE = (radius + hVar.ROLE_COLLISION_EDGE / 2) * (radius + hVar.ROLE_COLLISION_EDGE / 2)
			
			--如果__sortt表没有元素，可以拿来复用
			local sortt = nil
			local __sorttt = d.__sorttt --搜敌排序表（用于内存优化）
			for st = 1, #__sorttt, 1 do
				local __sortt = __sorttt[st]
				if (#__sortt == 0) then --找到空位
					sortt = __sortt --复用
					--print("复用 enumunitArea")
					break
				end
			end
			if (sortt == nil) then
				sortt = {}
				--print("新用 enumunitArea")
			end
			
			--依次遍历每个阵营
			for force = hVar.FORCE_DEF.FORCE_MIN, hVar.FORCE_DEF.FORCE_MAX, 1 do
				local areaTS = d.__areaT[force] --所有单位所在的区域表（用于搜敌优化）
				--local sortt = {}
				for xn = pos_xn_left, pos_xn_right, 1 do
					if areaTS[xn] then
						for yn = pos_yn_up, pos_yn_down, 1 do
							local areaTSXY = areaTS[xn][yn]
							if areaTSXY then
								--for oUnit, _ in pairs(areaT[xn][yn]) do
								for i = 1, #areaTSXY, 1 do
									local oUnit = areaTSXY[i]
									
									--检测距离
									local cx, cy = hApi.chaGetPos(oUnit.handle)
									local dx = cx - worldX
									local dy = cy - worldY
									local distance = dx * dx + dy * dy
									
									--在范围内
									if (distance <= DISTANCE) then
										sortt[#sortt + 1] = oUnit
										--code(oUnit, param, param2, ...)
									end
								end
							end
						end
					end
				end
			end
			
			--[[
			--排序
			table.sort(sortt, function(ca, cb)
				return (ca:getworldC() < cb:getworldC())
			end)
			
			for k, oUnit in ipairs(sortt) do
				code(oUnit, param, param2, ...)
			end
			]]
			
			--逐一执行
			for i = #sortt, 1, -1 do
				local oUnit = sortt[i]
				code(oUnit, param, param2, ...)
				
				--为了继续复用，清空sortt表
				sortt[i] = nil
			end
		end
	end
end

--依次遍历地图上指定范围内的所有敌方势力单位
_hw.enumunitAreaEnemy = function(self, force, worldX, worldY, radius, code, param, param2, ...)
	if (worldX == nil) then
		return
	end
	
	if (worldY == nil) then
		return
	end
	
	if (radius > 0) then
		if code then
			local enemyF1 = -1
			local enemyF2 = -1
			local enemyF3 = -1
			
			if (force == hVar.FORCE_DEF.GOD) then --上帝的敌人
				enemyF1 = hVar.FORCE_DEF.WEI --魏国
				enemyF2 = hVar.FORCE_DEF.NEUTRAL --中立无敌意
				enemyF3 = hVar.FORCE_DEF.NEUTRAL_ENEMY --中立有敌意
			elseif (force == hVar.FORCE_DEF.SHU) then --蜀国的敌人
				enemyF1 = hVar.FORCE_DEF.WEI --魏国
				enemyF2 = hVar.FORCE_DEF.NEUTRAL --中立无敌意
				enemyF3 = hVar.FORCE_DEF.NEUTRAL_ENEMY --中立有敌意
			elseif (force == hVar.FORCE_DEF.WEI) then --魏国的敌人
				enemyF1 = hVar.FORCE_DEF.SHU --蜀国
				enemyF2 = hVar.FORCE_DEF.NEUTRAL --中立无敌意
				enemyF3 = hVar.FORCE_DEF.NEUTRAL_ENEMY --中立有敌意
			elseif (force == hVar.FORCE_DEF.NEUTRAL) then --中立无敌意的敌人
				enemyF1 = hVar.FORCE_DEF.SHU --蜀国
				enemyF2 = hVar.FORCE_DEF.WEI --魏国
			elseif (force == hVar.FORCE_DEF.NEUTRAL_ENEMY) then --中立有敌意的敌人
				enemyF1 = hVar.FORCE_DEF.SHU --蜀国
				enemyF2 = hVar.FORCE_DEF.WEI --魏国
			end
			
			local pos_xn_left = math.floor((worldX - radius) / hVar.AREA_EDGE) --区域最左侧
			local pos_xn_right = math.ceil((worldX + radius) / hVar.AREA_EDGE) --区域最右侧
			local pos_yn_up = math.floor((worldY - radius) / hVar.AREA_EDGE) --区域最上侧
			local pos_yn_down = math.ceil((worldY + radius) / hVar.AREA_EDGE) --区域最下侧
			
			--依次遍历在这些区域内的所有单位
			local d = self.data
			local DISTANCE = (radius + hVar.ROLE_COLLISION_EDGE / 2) * (radius + hVar.ROLE_COLLISION_EDGE / 2)
			
			--如果__sortt表没有元素，可以拿来复用
			local sortt = nil
			local __sorttt = d.__sorttt --搜敌排序表（用于内存优化）
			for st = 1, #__sorttt, 1 do
				local __sortt = __sorttt[st]
				if (#__sortt == 0) then --找到空位
					sortt = __sortt --复用
					--print("复用 enumunitArea")
					break
				end
			end
			if (sortt == nil) then
				sortt = {}
				--print("新用 enumunitArea")
			end
			
			--依次遍历每个阵营
			for force = hVar.FORCE_DEF.FORCE_MIN, hVar.FORCE_DEF.FORCE_MAX, 1 do
				if (force == enemyF1) or (force == enemyF2) or (force == enemyF3) then --敌方阵营
					local areaTS = d.__areaT[force] --所有单位所在的区域表（用于搜敌优化）
					for xn = pos_xn_left, pos_xn_right, 1 do
						if areaTS[xn] then
							for yn = pos_yn_up, pos_yn_down, 1 do
								local areaTSXY = areaTS[xn][yn]
								if areaTSXY then
									for i = 1, #areaTSXY, 1 do
										local oUnit = areaTSXY[i]
										
										--检测距离
										local cx, cy = hApi.chaGetPos(oUnit.handle)
										local dx = cx - worldX
										local dy = cy - worldY
										local distance = dx * dx + dy * dy
										
										--在范围内
										if (distance <= DISTANCE) then
											--code(oUnit, param, param2, ...)
											sortt[#sortt + 1] = oUnit
										end
									end
								end
							end
						end
					end
				end
			end
			
			--逐一执行
			for i = #sortt, 1, -1 do
				local oUnit = sortt[i]
				code(oUnit, param, param2, ...)
				
				--为了继续复用，清空sortt表
				sortt[i] = nil
			end
		end
	end
end

--依次遍历地图上指定范围内的所有友军势力单位
_hw.enumunitAreaAlly = function(self, force, worldX, worldY, radius, code, param, param2, ...)
	if (radius > 0) then
		if code then
			local allyF1 = -1
			local allyF2 = -1
			local allyF3 = -1
			
			if (force == hVar.FORCE_DEF.GOD) then --上帝的友军
				allyF1 = hVar.FORCE_DEF.GOD --上帝
				allyF2 = hVar.FORCE_DEF.SHU --蜀国
			elseif (force == hVar.FORCE_DEF.SHU) then --蜀国的友军
				allyF1 = hVar.FORCE_DEF.GOD --上帝
				allyF2 = hVar.FORCE_DEF.SHU --蜀国
			elseif (force == hVar.FORCE_DEF.WEI) then --魏国的友军
				allyF1 = hVar.FORCE_DEF.WEI --魏国
			elseif (force == hVar.FORCE_DEF.NEUTRAL) then --中立无敌意的友军
				--
			elseif (force == hVar.FORCE_DEF.NEUTRAL_ENEMY) then --中立有敌意的友军
				--
			end
			
			local pos_xn_left = math.floor((worldX - radius) / hVar.AREA_EDGE) --区域最左侧
			local pos_xn_right = math.ceil((worldX + radius) / hVar.AREA_EDGE) --区域最右侧
			local pos_yn_up = math.floor((worldY - radius) / hVar.AREA_EDGE) --区域最上侧
			local pos_yn_down = math.ceil((worldY + radius) / hVar.AREA_EDGE) --区域最下侧
			
			--依次遍历在这些区域内的所有单位
			local d = self.data
			local DISTANCE = (radius + hVar.ROLE_COLLISION_EDGE / 2) * (radius + hVar.ROLE_COLLISION_EDGE / 2)
			
			--如果__sortt表没有元素，可以拿来复用
			local sortt = nil
			local __sorttt = d.__sorttt --搜敌排序表（用于内存优化）
			for st = 1, #__sorttt, 1 do
				local __sortt = __sorttt[st]
				if (#__sortt == 0) then --找到空位
					sortt = __sortt --复用
					--print("复用 enumunitArea")
					break
				end
			end
			if (sortt == nil) then
				sortt = {}
				--print("新用 enumunitArea")
			end
			
			--依次遍历每个阵营
			for force = hVar.FORCE_DEF.FORCE_MIN, hVar.FORCE_DEF.FORCE_MAX, 1 do
				if (force == allyF1) or (force == allyF2) or (force == allyF3) then --友军阵营
					local areaTS = d.__areaT[force] --所有单位所在的区域表（用于搜敌优化）
					for xn = pos_xn_left, pos_xn_right, 1 do
						if areaTS[xn] then
							for yn = pos_yn_up, pos_yn_down, 1 do
								local areaTSXY = areaTS[xn][yn]
								if areaTSXY then
									for i = 1, #areaTSXY, 1 do
										local oUnit = areaTSXY[i]
										
										--检测距离
										local cx, cy = hApi.chaGetPos(oUnit.handle)
										local dx = cx - worldX
										local dy = cy - worldY
										local distance = dx * dx + dy * dy
										
										--在范围内
										if (distance <= DISTANCE) then
											--code(oUnit, param, param2, ...)
											sortt[#sortt + 1] = oUnit
										end
									end
								end
							end
						end
					end
				end
			end
			
			--逐一执行
			for i = #sortt, 1, -1 do
				local oUnit = sortt[i]
				code(oUnit, param, param2, ...)
				
				--为了继续复用，清空sortt表
				sortt[i] = nil
			end
		end
	end
end

--大菠萝：优化敌人搜敌
--依次遍历当前屏幕内的所有敌方势力单位
_hw.enumunitScreenEnemy = function(self, force, code, param, param2, ...)
	
	if code then
		local enemyF1 = -1
		local enemyF2 = -1
		local enemyF3 = -1
		
		if (force == hVar.FORCE_DEF.GOD) then --上帝的敌人
			enemyF1 = hVar.FORCE_DEF.WEI --魏国
			enemyF2 = hVar.FORCE_DEF.NEUTRAL --中立无敌意
			enemyF3 = hVar.FORCE_DEF.NEUTRAL_ENEMY --中立有敌意
		elseif (force == hVar.FORCE_DEF.SHU) then --蜀国的敌人
			enemyF1 = hVar.FORCE_DEF.WEI --魏国
			enemyF2 = hVar.FORCE_DEF.NEUTRAL --中立无敌意
			enemyF3 = hVar.FORCE_DEF.NEUTRAL_ENEMY --中立有敌意
		elseif (force == hVar.FORCE_DEF.WEI) then --魏国的敌人
			enemyF1 = hVar.FORCE_DEF.SHU --蜀国
			enemyF2 = hVar.FORCE_DEF.NEUTRAL --中立无敌意
			enemyF3 = hVar.FORCE_DEF.NEUTRAL_ENEMY --中立有敌意
		elseif (force == hVar.FORCE_DEF.NEUTRAL) then --中立无敌意的敌人
			enemyF1 = hVar.FORCE_DEF.SHU --蜀国
			enemyF2 = hVar.FORCE_DEF.WEI --魏国
		elseif (force == hVar.FORCE_DEF.NEUTRAL_ENEMY) then --中立有敌意的敌人
			enemyF1 = hVar.FORCE_DEF.SHU --蜀国
			enemyF2 = hVar.FORCE_DEF.WEI --魏国
		end
		
		local camX, camY = xlGetViewNodeFocus() --当前屏幕正中央
		local pos_x_left = camX - hVar.SCREEN.w / 2 - 100 --屏幕最左侧
		local pos_x_right = camX + hVar.SCREEN.w / 2 + 100 --屏幕最右侧
		local pos_y_up = camY - hVar.SCREEN.h / 2 - 100 --屏幕最上侧
		local pos_y_down = camY + hVar.SCREEN.h / 2 + 100 --屏幕最下侧
		--print("world",pos_x_left,pos_x_right,pos_y_up,pos_y_down)
		
		local pos_xn_left = math.floor(pos_x_left / hVar.AREA_EDGE) --区域最左侧
		local pos_xn_right = math.ceil(pos_x_right / hVar.AREA_EDGE) --区域最右侧
		local pos_yn_up = math.floor(pos_y_up / hVar.AREA_EDGE) --区域最上侧
		local pos_yn_down = math.ceil(pos_y_down / hVar.AREA_EDGE) --区域最下侧
		
		--依次遍历在这些区域内的所有单位
		local d = self.data
		--local DISTANCE = (radius + hVar.ROLE_COLLISION_EDGE / 2) * (radius + hVar.ROLE_COLLISION_EDGE / 2)
		
		--如果__sortt表没有元素，可以拿来复用
		local sortt = nil
		local __sorttt = d.__sorttt --搜敌排序表（用于内存优化）
		for st = 1, #__sorttt, 1 do
			local __sortt = __sorttt[st]
			if (#__sortt == 0) then --找到空位
				sortt = __sortt --复用
				--print("复用 enumunitArea")
				break
			end
		end
		if (sortt == nil) then
			sortt = {}
			--print("新用 enumunitArea")
		end
		
		--依次遍历每个阵营
		for force = hVar.FORCE_DEF.FORCE_MIN, hVar.FORCE_DEF.FORCE_MAX, 1 do
			if (force == enemyF1) or (force == enemyF2) or (force == enemyF3) then --敌方阵营
				local areaTS = d.__areaT[force] --所有单位所在的区域表（用于搜敌优化）
				for xn = pos_xn_left, pos_xn_right, 1 do
					if areaTS[xn] then
						for yn = pos_yn_up, pos_yn_down, 1 do
							local areaTSXY = areaTS[xn][yn]
							if areaTSXY then
								for i = 1, #areaTSXY, 1 do
									local oUnit = areaTSXY[i]
									
									--检测距离
									local cx, cy = hApi.chaGetPos(oUnit.handle)
									local dx = cx - 0
									local dy = cy - 0
									--local distance = dx * dx + dy * dy
									--print(dx, dy)
									
									--在屏幕范围内
									if (dx >= pos_x_left) and (dx <= pos_x_right) and (dy >= pos_y_up) and (dy <= pos_y_down) then
										--code(oUnit, param, param2, ...)
										sortt[#sortt + 1] = oUnit
									end
								end
							end
						end
					end
				end
			end
		end
		
		--逐一执行
		for i = #sortt, 1, -1 do
			local oUnit = sortt[i]
			code(oUnit, param, param2, ...)
			
			--为了继续复用，清空sortt表
			sortt[i] = nil
		end
	end
end

--大菠萝：优化敌人搜敌
--依次遍历当前屏幕之外的所有敌方势力单位
_hw.enumunitScreenOutEnemy = function(self, force, code, param, param2, ...)
	
	if code then
		local enemyF1 = -1
		local enemyF2 = -1
		local enemyF3 = -1
		
		if (force == hVar.FORCE_DEF.GOD) then --上帝的敌人
			enemyF1 = hVar.FORCE_DEF.WEI --魏国
			enemyF2 = hVar.FORCE_DEF.NEUTRAL --中立无敌意
			enemyF3 = hVar.FORCE_DEF.NEUTRAL_ENEMY --中立有敌意
		elseif (force == hVar.FORCE_DEF.SHU) then --蜀国的敌人
			enemyF1 = hVar.FORCE_DEF.WEI --魏国
			enemyF2 = hVar.FORCE_DEF.NEUTRAL --中立无敌意
			enemyF3 = hVar.FORCE_DEF.NEUTRAL_ENEMY --中立有敌意
		elseif (force == hVar.FORCE_DEF.WEI) then --魏国的敌人
			enemyF1 = hVar.FORCE_DEF.SHU --蜀国
			enemyF2 = hVar.FORCE_DEF.NEUTRAL --中立无敌意
			enemyF3 = hVar.FORCE_DEF.NEUTRAL_ENEMY --中立有敌意
		elseif (force == hVar.FORCE_DEF.NEUTRAL) then --中立无敌意的敌人
			enemyF1 = hVar.FORCE_DEF.SHU --蜀国
			enemyF2 = hVar.FORCE_DEF.WEI --魏国
		elseif (force == hVar.FORCE_DEF.NEUTRAL_ENEMY) then --中立有敌意的敌人
			enemyF1 = hVar.FORCE_DEF.SHU --蜀国
			enemyF2 = hVar.FORCE_DEF.WEI --魏国
		end
		
		local camX, camY = xlGetViewNodeFocus() --当前屏幕正中央
		local pos_x_left = camX - hVar.SCREEN.w / 2 - 100 --屏幕最左侧
		local pos_x_right = camX + hVar.SCREEN.w / 2 + 100 --屏幕最右侧
		local pos_y_up = camY - hVar.SCREEN.h / 2 - 100 --屏幕最上侧
		local pos_y_down = camY + hVar.SCREEN.h / 2 + 100 --屏幕最下侧
		--print("world",pos_x_left,pos_x_right,pos_y_up,pos_y_down)
		
		local pos_xn_left = math.floor(pos_x_left / hVar.AREA_EDGE) --区域最左侧
		local pos_xn_right = math.ceil(pos_x_right / hVar.AREA_EDGE) --区域最右侧
		local pos_yn_up = math.floor(pos_y_up / hVar.AREA_EDGE) --区域最上侧
		local pos_yn_down = math.ceil(pos_y_down / hVar.AREA_EDGE) --区域最下侧
		
		--依次遍历在这些区域内的所有单位
		local d = self.data
		--local DISTANCE = (radius + hVar.ROLE_COLLISION_EDGE / 2) * (radius + hVar.ROLE_COLLISION_EDGE / 2)
		
		--依次遍历每个阵营
		self:enumunit(function(oUnit)
			local force = oUnit:getowner():getforce()
			if (force == enemyF1) or (force == enemyF2) or (force == enemyF3) then --敌方阵营
				--检测距离
				local cx, cy = hApi.chaGetPos(oUnit.handle)
				local dx = cx - 0
				local dy = cy - 0
				--local distance = dx * dx + dy * dy
				--print(dx, dy)
				
				--在屏幕范围外
				if (dx < pos_x_left) or (dx > pos_x_right) or (dy < pos_y_up) or (dy > pos_y_down) then
					code(oUnit, param, param2)
				end
			end
		end)
	end
end

--加入范围伤害性能优化表
_hw.addDamageAreaPerf = function(self, oUnit, skillId, nDmgMode, dMin ,dMax, radius, worldX, worldY)
	local d = self.data
	--print("加入范围伤害性能优化表", "LENTGH=", #d.damageAreaPerfList)
	--计算本次搜地的覆盖区域
	local pos_xn_left = math.floor((worldX - radius) / hVar.AREA_EDGE) --区域最左侧
	local pos_xn_right = math.ceil((worldX + radius) / hVar.AREA_EDGE) --区域最右侧
	local pos_yn_up = math.floor((worldY - radius) / hVar.AREA_EDGE) --区域最上侧
	local pos_yn_down = math.ceil((worldY + radius) / hVar.AREA_EDGE) --区域最下侧
	
	--依次遍历已有项，检测是否可合并
	for t = 1, #d.damageAreaPerfList, 1 do
		local tPerf = d.damageAreaPerfList[t]
		
		--在处理dmg时可能再次触发添加，所以这里出现nil的情况
		--如果遇到nil，为避免出错，本次不执行
		if (tPerf == nil) then
			return
		end
		
		local oUnit_i = tPerf.oUnit
		local oUnitForce_i = tPerf.oUnitForce
		local skillId_i = tPerf.skillId
		local nDmgMode_i = tPerf.nDmgMode
		local pos_xn_left_i = tPerf.pos_xn_left
		local pos_xn_right_i = tPerf.pos_xn_right
		local pos_yn_up_i = tPerf.pos_yn_up
		local pos_yn_down_i = tPerf.pos_yn_down
		local data_i = tPerf.data
		
		--施法者一致，技能一致，伤害类型一致，并且搜敌覆盖区域是包含关系，可合并
		if (oUnit_i == oUnit) and (skillId_i == skillId) and (nDmgMode_i == nDmgMode) then
			--比当前区域要小
			if (pos_xn_left >= pos_xn_left_i) and (pos_xn_right <= pos_xn_right_i) and (pos_yn_up >= pos_yn_up_i) and (pos_yn_down <= pos_yn_down_i) then
				--是子集
				--插入性能优化表
				print("addDamageAreaPerf", "是子集" .. t)
				data_i[#data_i+1] = {dMin ,dMax, radius, worldX, worldY,}
				return
			--比当前区域更大
			elseif (pos_xn_left <= pos_xn_left_i) and (pos_xn_right >= pos_xn_right_i) and (pos_yn_up <= pos_yn_up_i) and (pos_yn_down >= pos_yn_down_i) then
				--是超集
				--插入性能优化表
				print("addDamageAreaPerf", "是超集" .. t)
				data_i[#data_i+1] = {dMin ,dMax, radius, worldX, worldY,}
				
				--更新覆盖区域
				tPerf.pos_xn_left = pos_xn_left
				tPerf.pos_xn_right = pos_xn_right
				tPerf.pos_yn_up = pos_yn_up
				tPerf.pos_yn_down = pos_yn_down
				
				return
			end
		end
	end
	
	--走到这里说明没有可合并的项
	--插入末尾
	local tPerf ={oUnit = oUnit, oUnitForce = oUnit:getowner():getforce(), skillId = skillId, nDmgMode = nDmgMode, pos_xn_left = pos_xn_left, pos_xn_right = pos_xn_right, pos_yn_up = pos_yn_up, pos_yn_down = pos_yn_down, data = {{dMin ,dMax, radius, worldX, worldY,},},}
	d.damageAreaPerfList[#d.damageAreaPerfList+1] = tPerf
	print("addDamageAreaPerf", "插入末尾" .. #d.damageAreaPerfList)
end

--处理范围伤害性能优化表
_hw.processDamageAreaPerf = function(self)
	local d = self.data
	
	--依次遍历所有搜敌项
	local perfNum = #d.damageAreaPerfList
	for t = 1, perfNum, 1 do
		local tPerf = d.damageAreaPerfList[t]
		if tPerf then
			local oUnit_i = tPerf.oUnit
			local oUnitForce_i = tPerf.oUnitForce
			local skillId_i = tPerf.skillId
			local nDmgMode_i = tPerf.nDmgMode
			local pos_xn_left_i = tPerf.pos_xn_left
			local pos_xn_right_i = tPerf.pos_xn_right
			local pos_yn_up_i = tPerf.pos_yn_up
			local pos_yn_down_i = tPerf.pos_yn_down
			local data_i = tPerf.data
			
			--施法者的阵营
			local force = oUnitForce_i --oUnit_i:getowner():getforce() --施法者的属方阵营
			local tabS = hVar.tab_skill[skillId_i]
			local cast_target_type = tabS.cast_target_type --技能可生效的目标的类型
			local cast_target_space_type = tabS.cast_target_space_type or hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL --技能可生效的目标的空间类型
			
			local enemyF1 = -1
			local enemyF2 = -1
			local enemyF3 = -1
			
			if (force == hVar.FORCE_DEF.GOD) then --上帝的敌人
				enemyF1 = hVar.FORCE_DEF.WEI --魏国
				enemyF2 = hVar.FORCE_DEF.NEUTRAL --中立无敌意
				enemyF3 = hVar.FORCE_DEF.NEUTRAL_ENEMY --中立有敌意
			elseif (force == hVar.FORCE_DEF.SHU) then --蜀国的敌人
				enemyF1 = hVar.FORCE_DEF.WEI --魏国
				enemyF2 = hVar.FORCE_DEF.NEUTRAL --中立无敌意
				enemyF3 = hVar.FORCE_DEF.NEUTRAL_ENEMY --中立有敌意
			elseif (force == hVar.FORCE_DEF.WEI) then --魏国的敌人
				enemyF1 = hVar.FORCE_DEF.SHU --蜀国
				enemyF2 = hVar.FORCE_DEF.NEUTRAL --中立无敌意
				enemyF3 = hVar.FORCE_DEF.NEUTRAL_ENEMY --中立有敌意
			elseif (force == hVar.FORCE_DEF.NEUTRAL) then --中立无敌意的敌人
				enemyF1 = hVar.FORCE_DEF.SHU --蜀国
				enemyF2 = hVar.FORCE_DEF.WEI --魏国
			elseif (force == hVar.FORCE_DEF.NEUTRAL_ENEMY) then --中立有敌意的敌人
				enemyF1 = hVar.FORCE_DEF.SHU --蜀国
				enemyF2 = hVar.FORCE_DEF.WEI --魏国
			end
			
			--如果__sortt表没有元素，可以拿来复用
			--[[
			local sortt = nil
			local __sortt = d.__sortt --搜敌排序表（用于内存优化）
			if (#__sortt == 0) then
				sortt = __sortt --复用
				--print("复用 processDamageAreaPerf")
			else
				sortt = {}
				--print("新用 processDamageAreaPerf")
			end
			]]
			local sortt = nil
			local __sorttt = d.__sorttt --搜敌排序表（用于内存优化）
			for st = 1, #__sorttt, 1 do
				local __sortt = __sorttt[st]
				if (#__sortt == 0) then --找到空位
					sortt = __sortt --复用
					--print("复用 processDamageAreaPerf")
					break
				end
			end
			if (sortt == nil) then
				sortt = {}
				--print("新用 processDamageAreaPerf")
			end
			
			--依次遍历每个阵营
			for force = hVar.FORCE_DEF.FORCE_MIN, hVar.FORCE_DEF.FORCE_MAX, 1 do
				if (force == enemyF1) or (force == enemyF2) or (force == enemyF3) then --敌方阵营
					local areaTS = d.__areaT[force] --所有单位所在的区域表（用于搜敌优化）
					for xn = pos_xn_left_i, pos_xn_right_i, 1 do
						if areaTS[xn] then
							for yn = pos_yn_up_i, pos_yn_down_i, 1 do
								local areaTSXY = areaTS[xn][yn]
								if areaTSXY then
									for i = 1, #areaTSXY, 1 do
										local eu = areaTSXY[i]
										local subType = eu.data.type --目标子类型
										
										--子类型包含
										if cast_target_type[subType] then
											--目标与技能的空间类型一致
											--技能对地和空都生效, 或 目标是地面、技能对地, 或 目标是空中、技能对空
											if (cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL)
											or ((cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_GROUND) and (eu:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_GROUND))
											or ((cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_FLY) and (eu:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_FLY))
											then
												sortt[#sortt + 1] = eu
											end
										end
									end
								end
							end
						end
					end
				end
			end
			
			--逐一执行
			--遍历每个搜到的可能的敌人，检测是否在本组搜敌内
			for i = #sortt, 1, -1 do
				local eu = sortt[i]
				
				--活着的单位
				if (eu.attr.hp > 0) and (eu.data.dead ~= 1) then
					--本组搜敌对该目标造成的总伤害
					local eu_dMin = 0
					local eu_dMax = 0
					
					local cx, cy = hApi.chaGetPos(eu.handle)
					
					--遍历本组搜敌的每个搜敌半径，是否对目标造成伤害
					for j = 1, #data_i, 1 do
						--{dMin ,dMax, radius, worldX, worldY,},
						local data_ij = data_i[j]
						local dMin_ij = data_ij[1]
						local dMax_ij = data_ij[2]
						local radius_ij = data_ij[3]
						local worldX_ij = data_ij[4]
						local worldY_ij = data_ij[5]
						
						--检测距离
						--local cx, cy = hApi.chaGetPos(eu.handle)
						local dx = cx - worldX_ij
						local dy = cy - worldY_ij
						local distance_j = dx * dx + dy * dy
						local DISTANCE_j = (radius_ij + hVar.ROLE_COLLISION_EDGE / 2) * (radius_ij + hVar.ROLE_COLLISION_EDGE / 2)
						
						--检测是否在范围内
						if (distance_j <= DISTANCE_j) then
							--叠加伤害
							eu_dMin = eu_dMin + dMin_ij
							eu_dMax = eu_dMax + dMax_ij
							print("processDamageAreaPerf", "叠加伤害" .. t, "j=" .. j, eu.data.name .. "_" .. eu:getworldI(), eu_dMin, eu_dMax)
						end
					end
					
					--本组搜敌对此目标有伤害
					if (eu_dMin > 0) or (eu_dMax > 0) then
						local nPower = 100
						local dmgSumMin, dmgSumMax = oUnit_i:calculate("CombatDamage", eu, eu_dMin, eu_dMax, nPower, skillId_i, nDmgMode_i, 0)
						local dmgSum = self:random(dmgSumMin, dmgSumMax)
						--print(dmgSum)
						if (dmgSum > 0) then
							print("本组搜敌对此目标有伤害", eu.data.name,skillId_i,nDmgMode_i,dmgSum,0,oUnit_i.data.name,force)
							hGlobal.event:call("Event_UnitDamaged", eu, skillId_i, nDmgMode_i, dmgSum, 0, oUnit_i, nil, force, oUnit_i:getowner():getpos())
							print("剩余血量", eu.data.name, eu.data.id, eu.attr.hp)
						end
					end
				end
				
				--为了继续复用，清空sortt表
				sortt[i] = nil
			end
			
			--本组搜敌处理完毕，清空数据
			d.damageAreaPerfList[t] = nil
		end
	end
	--print("处理范围伤害性能优化表", "LENTGH=", #d.damageAreaPerfList)
end

--取随机数
--_hw.randomcount = 0
_hw.random = function(self, minValue, maxValue)
	local d = self.data
	local h = self.handle
	
	minValue = minValue or 1
	maxValue = maxValue or 10000
	
	if (minValue > maxValue) then
		local tmp = minValue
		minValue = maxValue
		maxValue = tmp
	end
	
	--local randomseed = 555
	--local logiccount = 400
	local logiccount = d.__frameCount - d.__beginFrameCount
	d.randomcount = d.randomcount + 1
	local idx = (d.randomSeed + logiccount + d.randomcount) % 10000 + 1
	local r = hVar.RANDOM_NUMBER_LIST[idx] --随机数
	local mod = r % (maxValue - minValue + 1)
	if (mod == 0) then
		mod = maxValue - minValue + 1
	end
	
	local value = mod + (minValue - 1)
	
	--[[
	--geyachao: 同步日志: 随机数
	if (hVar.IS_SYNC_LOG == 1) then
		local msg = "random: randomseed=" .. d.randomSeed .. ",min=" .. minValue .. ",max=" .. maxValue .. ",value=" .. value
		hApi.SyncLog(msg)
	end
	]]
	
	--geyachao: 非同步日志: 随机数
	if (hVar.IS_ASYNC_LOG == 1) then
		local msg = "random: randomseed=" .. d.randomSeed .. ",min=" .. minValue .. ",max=" .. maxValue .. ",value=" .. value .. "\n" .. debug.traceback()
		--local msg = "random: randomseed=" .. d.randomSeed .. ",min=" .. minValue .. ",max=" .. maxValue .. ",value=" .. value
		hApi.AsyncLog(msg)
	end
	
	return value
end

------------------------
-- 删除地图
local __ENUM__RemoveActionObject = function(oAction,oWorld)
	if oAction.data.unit~=0 and oAction.data.unit:getworld()==oWorld then
		oAction:del()
	end
end
local __ENUM__RemoveFloatNumber = function(o,pLayer)
	if o.data.parent==pLayer then
		o:del()
	end
end

_hw.destroy = function(self)
	local d = self.data
	local h = self.handle
	
	--清除游戏信息文本
	hApi.AppendGameInfo(nil, true)
	
	if d.map and hVar.MAP_INFO[d.map] and hVar.MAP_INFO[d.map].mapType and hVar.MAP_INFO[d.map].mapType == 4 then	--zhenkira
		--print("RemoveTimer by zhenkira")
		
		--取消监听
		hGlobal.event:listen("LocalEvent_AppEnterBackground", "TD", nil)
		hGlobal.event:listen("Event_UnitDamaged", "TD_Unit_Damged_HpBar", nil) --取消监听 角色受到伤害事件，更新血条、数字血量
		hGlobal.event:listen("Event_UnitDamaged", "TD_Unit_Damged_SuckBlood", nil) --取消监听 角色受到伤害事件，攻击者吸血
		hGlobal.event:listen("Event_UnitDamaged", "TD_Unit_Damged_GoldUnitAddGold", nil) --取消监听 角色受到伤害事件，检测金钱怪每次被攻击，加钱
		hGlobal.event:listen("Event_UnitDamaged", "TD_Unit_Damged_SleepWakeUp", nil) --取消监听 角色受到伤害事件，沉睡的单位被唤醒
		hGlobal.event:listen("Event_UnitDamaged", "TD_Unit_PVE_MULTY_STUN", nil) --取消监听 角色受到伤害事件，魔龙检测是否击晕
		hGlobal.event:listen("Event_UnitDamaged", "TD_Unit_PVE_MULTY_REACT", nil) --取消监听 角色受到伤害事件，魔龙检测是否敌方BOSS反击
		hGlobal.event:listen("Event_UnitBorn", "TD_Unit_PVE_MULTY_STEALLIFE", nil) --取消监听 角色出生事件，魔龙检测是否窃取技能
		hGlobal.event:listen("LocalEvent_Pvp_Sync_CMD", "TD_PVP_CMD_EVENT", nil)--取消监听 收到网络cmd指令
		
		--监听：pvp服务器断网事件
		hGlobal.event:listen("LocalEvent_Pvp_NetEvent", "TD_Pvp_NetEvent", nil) --1online 其它offline
		hGlobal.event:listen("LocalEvent_Pvp_LogEvent", "TD_Pvp_LogEvent", nil) --0:kick 1:in 2:out 3:dis
		
		--监听：pvp服务器玩家被踢出事件
		--hGlobal.event:listen("LocalEvent_Pvp_PlayerLoginEvent", "PlayerKickEvent", nil) --0:kick 1:in 2:out 3:dis
		
		--监听pvp游戏结果为无效局的描述信息
		hGlobal.event:listen("LocalEvent_Pvp_GameResult_Invalid", "TD_Pvp_GameResult_Invalid", nil)
		hGlobal.event:listen("LocalEvent_Pvp_GameResult_Invalid", "TD_Pvp_GameResult_Invalid_OnGameEnd", nil)
		
		--监听pvp战绩结果下发
		hGlobal.event:listen("LocalEvent_Pvp_GameResult_RewardStar", "TD_Pvp_GameResult_RewardStar", nil)
		hGlobal.event:listen("LocalEvent_Pvp_GameResult_RewardStar", "TD_Pvp_GameResult_RewardStar_OnGameEnd", nil)
		
		--监听pvp等待玩家事件
		hGlobal.event:listen("LocalEvent_Pvp_Delay_Player", "TD_Pvp_DelayPlayerEvent", nil)
		--监听pvp英雄升级pvp等级事件
		hGlobal.event:listen("Event_HeroPvpLvUp", "TD_HeroPvpLvUp", nil)
		--监听pvp英雄增加经验事件
		hGlobal.event:listen("Event_HeroPvpAddExp", "TD_HeroPvpAddExp", nil)
		
		--监听pvp铜雀台游戏结束抽奖结果
		hGlobal.event:listen("localEvent_ShowChoiceAwardFrm", "TD_PVP_ShowChoiceAward", nil)
		hGlobal.event:listen("localEvent_ShowChoiceAwardFrm", "TD_GameEnd_ShowChoiceAward", nil)
		
		--TD单位移动到达回调
		hGlobal.event:listen("Event_UnitArrive_TD", "TD_RoadUnitMove_TD", nil)
		hGlobal.event:listen("Event_UnitArrive_TD", "TD_NoRoadUnitMove_TD", nil)
		
		--角色眩晕或僵直或混乱状态变化事件
		hGlobal.event:listen("Event_UnitStunStaticState", "TD_UnitSunStatic_TD", nil)
		
		--TD敌方小兵受到普通攻击事件
		--hGlobal.event:listen("Event_UnitAttack_TD", "__Event_UnitAttacked_TD", nil)
		--取消监听单位死亡，取消所有单位对它的锁定，有正在朝他移动的单位改为移动到死之前的目标点
		hGlobal.event:listen("Event_UnitDead", "__TD_EnemyDead_TD", nil)
		--取消监听单位死亡，检测是否有成就变化
		hGlobal.event:listen("Event_UnitDead", "__TD_AchievementCheck", nil)
		--取消监听死亡事件，标记是哪个战术技能杀死了敌方单位
		hGlobal.event:listen("Event_UnitDead", "__TD_TacticSkillCheck", nil)
		--取消监听铜雀台，敌人BOSS死了，层数加1
		hGlobal.event:listen("Event_UnitDead", "__TD_TongQueTaiRound", nil)
		--取消监听死亡事件，如果是td塔，那么把它变成塔基
		hGlobal.event:listen("Event_UnitDead", "__TD_TowerDeadCheck", nil)
		--取消监听单位生存时间到了消失事件，如果是td塔，那么把它变成塔基
		hGlobal.event:listen("Event_UnitLiveTime_Disappear", "__TD_TowerLiveTimeCheck", nil)
		
		--小兵漏怪，有正在朝他移动的单位改为移动到漏怪前的目标点
		hGlobal.event:listen("LocalEvent_TD_UnitReached", "__TD_EnemyReached", nil)
		--提前发兵，重刷英雄复活时间
		hGlobal.event:listen("Event_ClickNextWaveButtonInAdvance", "__TD_NEXTWAVE_COME_TD", nil)
		
		--监听pvp本地的ping事件，刷新本地的ping值
		hGlobal.event:listen("LocalEvent_Pvp_Ping", "GamePvpPing", nil)
		
		--监听重练失败事件
		hGlobal.event:listen("LocalEvent_Pvp_ReLogin_Fail", "_Pvp_ReLogin_Fail_EVENT_", nil)
		
		--监听野怪死亡事件
		hGlobal.event:listen("Event_UnitDead", "TD_WildCheckDead", nil)
		
		--虚拟摇杆双击事件
		hGlobal.event:listen("LocalEvent_VitrualControllerTouchDoubleClick", "TD_VCTouchDoubleClick", nil)
		--虚拟摇杆单击事件
		hGlobal.event:listen("LocalEvent_VitrualControllerTouchClick", "TD_VCTouchClick", nil)
		
		--关闭连斩系统统计
		hGlobal.event:event("OpenContinuousKillingSystem",false)
		
		--清除检测长按的timer
		hApi.clearTimer("__LONGTOUCH_CHECK_TIMER__")
		
		--zhenkira: 取消地图AI事件监听
		TD_MapAIEventRemoveListen()
		
		--删除timer
		hApi.clearTimer("__SYS__ObjectAutoUpdate")
		hApi.clearTimer("__TD__SkillObjLoop")
		hApi.clearTimer("__TD__CollEffectLoop")
		hApi.clearTimer("__TD__AICommonOperate")
		hApi.clearTimer("__TD__AI_Timer")
		hApi.clearTimer("__TD__UnitArriveNew")
		hApi.clearTimer("__TD__CommandSequence")
		hApi.clearTimer("__TD__UnitHpRecover")
		hApi.clearTimer("__TD__MainLogic")
		hApi.clearTimer("__TD__PAINT_AI_timer", nil) --geyachao: 删除timer
		hApi.clearTimer("__TD__PVP_HEART_timer", nil) --geyachao: 心跳包检测超时timer
		--hApi.clearTimer("__TD__COLLECTGARBAGE_Timer", nil) --geyachao: 删除collectgarbage timer
		hGlobal.event:listen("LocalEvent_MemoryWarning", "__COLLECTGARBAGE_", nil)
		hApi.clearTimer("__TD__CAST_SKILL_Timer") --geyachao: 删除timer
		hApi.clearTimer("__TD__PAINT_BOX_TIMER_") --geyachao: 删除timer
		hApi.clearTimer("__TD__MapAI") --zhenkira: 删除timer
		--hGlobal.UnitArriving = {}
		hApi.ResumeTimer()
		
		--删除world的timer
		d.__timers = {} --监听timer表
		d.__beginFrameCount = 0 --开始计时时的帧数
		d.__frameCount = 0 --当前帧数
		d.__bEnableTimer = false --是否允许timer
		
		--删除虚拟摇杆
		if (type(d.__virtualController) == "userdata") then
			d.__virtualController:destroy()
			--print("删除虚拟摇杆", debug.traceback())
			d.__virtualController = 0
		end
		
		--删除pvp资源
		--xlReleaseResourceFromPList("data/image/misc/pvp.plist")
		
		--geyachao: 复活相关 删除控件
		--复活存储数据 {[index] = {deadoUint = xx, beginTick = 0, rebithTime = 10000, progressUI = xx, labelUI = xx,}, ...}
		for k, v in pairs(d.rebirthT) do
			v.progressUI:del()
			v.progressUI = nil
			v.labelUI:del()
			v.labelUI = nil
			--if oHero.heroUI["btnIcon"].childUI["rebirth_time"] then
			--	oHero.heroUI["btnIcon"].childUI["rebirth_time"]:setText("") --头像栏显示复活数字倒计时
			--end
		end
		
		d.tdMapInfo = 0

		--优化内存
		hApi.ReleaseUnusedUnitPlist(self)
		--collectgarbage()
	end
	
	if g_map_on_scene[d.scenetype]== self then
		g_map_on_scene[d.scenetype] = nil
	end
	local wUI = rawget(self, "worldUI")
	if wUI then
		for k,v in pairs(wUI)do
			v:del()
		end
	end
	--[[
	if d.type=="battlefield" then
		hClass.action:enum(__ENUM__RemoveActionObject,self)
		for k in pairs(d.lords)do
			local u = self:getlordU(k)
			if u then
				u.data.IsBusy = 0
			end
			self:setlordU(k,nil)
		end
		if d.IsQuickBattlefield~=1 then
			hUI.floatNumber:enum(__ENUM__RemoveFloatNumber,h.worldLayer)
		end
	end
	]]
	d.uniquecast = 0
	self.__LOG = 0
	d.IsDestroyed = 1
	h.__trigger_data = nil
	self:removeAll()
	
	d.customData = {} --用户自定义数据块
	d.customDataPivot = 0 --用户自定义数据块可用索引（自增值）
	
	--geyachao: 出大地图，回收lua内存
	if (d.type == "worldmap") then
		hClass.action:del_all() --删除所有的技能物体
		hClass.action:clear_static()
		hClass.effect:clear_static()
		hClass.hero:clear_static()
		hClass.item:clear_static()
		hClass.unit:clear_static()
		--collectgarbage()
	end

	--如果自己就是世界地图，并且有worldLayer，那么尝试在1帧之后清理内存
	if self.handle.worldLayer~=nil and self==hGlobal.WORLD.LastWorldMap then
		hApi.addTimerOnce("SYSReleaseCacheWM",1,function()
			if hGlobal.LocalPlayer:getfocusmap()~=nil and hGlobal.WORLD.LastWorldMap==nil then
				--删除世界地图的时候一并移除xlobjs,但是因此引起的其他状况我不能确定
				xlReleasePlistForWorldMap(d.background)
				hResource.model:releaseCache({hVar.TEMP_HANDLE_TYPE.OBJECT_WM,hVar.TEMP_HANDLE_TYPE.UNIT_WM,hVar.TEMP_HANDLE_TYPE.EFFECT_WM})	--读取地图,清理大地图显存
			end
		end)
	end
	
	--
	--清除场景的所有子节点
	hApi.DestroyWorldMap(self.handle)
	
	--移除round
	if d.roundID~=0 then
		local r = hClass.round:find(d.roundID)
		if r then
			if r.data.worldID==self.ID then
				r.data.worldID = 0
				r:del()
			else
				xlLG("world","round绑定数据发生混乱！"..tostring(self.data.map)..","..tostring(self.data.type)..","..tostring(self.ID).."\n")
			end
		end
	end
	if self.SetUnitPosList then
		self.SetUnitPosList = nil
	end
	
	if self.HunterWithCount then
		self.HunterWithCount = nil
	end
	
	if self == hGlobal.WORLD.LastTown then
		hGlobal.WORLD.LastTown = nil
	end
	
	if self == hGlobal.WORLD.LastWorldMap then
		hGlobal.WORLD.LastWorldMap = nil
	end
	
	--释放内存
	collectgarbage()
end

----------------------------------------------
--重新读取后，初始化数据
_hw.__InitAfterLoaded = function(self)
	local d = self.data
	if d.type=="none" or d.type=="worldmap" then
		self.map = {}				--地图信息(虽然data里面也有一个map但是那只是个字符串)
		self.__LOG = {i=0,cur=0}		--战报专用
		self.data.IsDrawGrid = hVar.OPTIONS.IS_DRAW_GRID		--记在全局变量中的"是否绘制网格"
		self.data.sceobjs = {i=0}
		self.data.HeroCardUsed = {}		--已经使用的英雄卡片，读取后由于需要重新加载英雄属性，所以直接重置
		--版本兼容数据，以后去掉
		if self.data.playerLog==nil then
			self.data.playerLog = {}
		end
		--创造的空世界不用管它,重置数据就行
		if d.type=="none" then
			return
		end
	else
		--这个世界从此就废弃了
		self.data.sceobjs = {i=0}
		print("不能读取世界地图以外的类型！",d.type,d.background)
		return
	end
	
	local d = self.data
	local h = self.handle
	--记录到全局变量
	
	if d.scenetype~=-1 and g_map_on_scene[d.scenetype]==self then
		g_map_on_scene[d.scenetype] = nil
	end
	
	hGlobal.LastCreateWorld = self
	hGlobal.WORLD.LastWorldMap = self
	--hApi.debug_floatNumber("hGlobal.WORLD.LastWorldMap = self 19")
	
	--场景类型
	d.scenetype = "worldmap"
	
	--把天数记录回程序用的全局变量里面
	g_game_days = d.roundcount
	--local mapBackground,unitList,triggerData = hApi.LoadMap(d.map)
	--地图名字转换兼容
	d.map = SaveModifyFunc["mapName"](d.map)
	d.background = SaveModifyFunc["mapName"](d.background)
	
	--经验锁
	--d.explock = d.explock or 0
	--for i = 1,#hVar.CanNotGetExpMapName do
		--if hVar.CanNotGetExpMapName[i] == d.map then
			--d.explock = 1
		--end
	--end
	--恢复地图参数表触发器ID
	d.PlayerInfoTgrID = d.PlayerInfoTgrID or {}
	--恢复地图路点信息
	d.waypoint = d.waypoint or {}
	--恢复默认参数
	for k,v in pairs(__DefaultParam)do
		if type(v)=="number" and d[k]==nil then
			d[k] = v
		end
	end
	--读取存档的时候如果是暂停状态，恢复暂停标记
	self:pause(0)
	--读取地图时加载xlobjs EFF 2015/4/20
	xlLoadPlistForWorldMap(d.background)
	self:loadMapTile(d.background)
	self:loadAllSceobjs()
	--移除已经完成的首杀任务
	local tQuest = d.QuestList
	if type(tQuest)=="table" then
		for i = 1,#tQuest do
			local v = tQuest[i]
			if type(v[4])=="table" and v[4][5]~=0 then
				local UniqueQuestID = v[4][5]
				if UniqueQuestID==nil then
					v[4][5] = 0
				else
					local IsCompleted = LuaGetPlayerMapAchi(d.map,hVar.ACHIEVEMENT_TYPE["UNIQUE_QUEST_"..UniqueQuestID])
					--已经完成了该任务，就直接删掉
					if IsCompleted~=0 and hVar.OPTIONS.TEST_UNIQUE_QUEST~=1 then
						tQuest[i] = 0
					end
				end
			end
		end
		hApi.SortTableI(tQuest,1)
	end
end

_hw.__DeadObjectAfterLoaded = function(self)
	self.__LOG = {i=0,cur=0}
end

----------------------------------------------
--世界暂停、恢复
_hw.pause = function(self,IsPause,ByWhat)
	--print("_hw.pause", debug.traceback())
	
	if (IsPause == 0) then --取消暂停
		self.data.IsPaused = 0
		self.data.PausedByWhat = 0
		
		--恢复逻辑循环、恢复cocos的动画播放速度
		hApi.ResumeTimer()
		
		--[[
		--geyachao: 不再依赖程序
		--恢复所有角色移动速度（c++控制）
		self:enumunit(function(eu)
			local tabU = hVar.tab_unit[eu.data.id]
			local speed = (tabU.movespeed or hVar.UNIT_DEFAULT_SPEED)		--by zhenkira:移动速度程序控制
			hApi.chaSetMoveSpeed(eu.handle,speed)
		end)
		]]
		
	else --暂停
		--print("_hw.pause", debug.traceback())
		self.data.IsPaused = 1
		if ByWhat==nil and type(IsPause)=="string" then
			self.data.PausedByWhat = IsPause
		else
			self.data.PausedByWhat = ByWhat or 0
		end
		
		--暂停逻辑循环、暂停cocos的动画播放速度
		--hApi.PauseTimer()
		--恢复逻辑循环、恢复cocos的动画播放速度
		hApi.ResumeTimer()
		
		--[[
		--geyachao: 不再依赖程序
		--暂停现有角色移动速度（c++控制）
		self:enumunit(function(eu)
			local tabU = hVar.tab_unit[eu.data.id]
			local speed = (tabU.movespeed or hVar.UNIT_DEFAULT_SPEED) --by zhenkira:移动速度程序控制
			hApi.chaSetMoveSpeed(eu.handle,speed)
			
		end)
		]]
	end
end

--世界加速、恢复
_hw.speedUp = function(self, IsSpeedUp, speed)
	if (not IsSpeedUp) then --不加速
		
		--恢复逻辑循环、恢复cocos的动画播放速度
		hApi.ResumeTimer()
		
		--[[
		--geyachao: 不再依赖程序
		--恢复所有角色移动速度（c++控制）
		self:enumunit(function(eu)
			local tabU = hVar.tab_unit[eu.data.id]
			local speed = (tabU.movespeed or hVar.UNIT_DEFAULT_SPEED)		--by zhenkira:移动速度程序控制
			hApi.chaSetMoveSpeed(eu.handle,speed)
		end)
		]]
		
	else --加速
		--加速逻辑循环、加速cocos的动画播放速度
		if (speed == nil) then
			--没传入指定的倍率，那么按当前的2倍速度加速
			hApi.SpeedUpTimer()
		else
			--指定倍率的加速
			hApi.SpeedUpTimerByValue(speed)
		end
		
		--[[
		--geyachao: 不再依赖程序
		--加速现有角色移动速度（c++控制）
		self:enumunit(function(eu)
			local tabU = hVar.tab_unit[eu.data.id]
			local speed = (tabU.movespeed or hVar.UNIT_DEFAULT_SPEED)		--by zhenkira:移动速度程序控制
			hApi.chaSetMoveSpeed(eu.handle,speed)
			
		end)
		]]
		
	end
end

_hw.setlordU = function(self,forceKey,oUnit)
	if oUnit==nil then
		self.data.lords[forceKey] = nil
	else
		local typ = self.data.type
		if typ=="battlefield" then
			oUnit.data.IsBusy = 1
			local oTown = oUnit:gettown()
			if oTown then
				local oGuard = oTown:getunit("guard")
				if oGuard~=nil then
					oGuard.data.IsBusy = 1
				end
			end
		end
		self.data.lords[forceKey] = {oUnit.ID,oUnit.__ID}
	end
end

_hw.getlordU = function(self,forceKey)
	local lord = self.data.lords[forceKey]
	if lord~=nil then
		local u = hClass.unit:find(lord[1])
		if u~=nil and u.__ID==lord[2] then
			return u
		end
	end
end

_hw.getmapdata = function(self,nPlayerId)
	local d = self.data
	if type(d.PlayerInfoTgrID)=="table" then
		local tID = d.PlayerInfoTgrID[1]
		if tID and tID~=0 and type(d.triggerIndex[tID])=="table" then
			return d.triggerIndex[tID][3]
		end
	end
end

--geyachao: 获得本局选择出战的英雄列表
_hw.GetSelectedHeroList = function(self)
	local d = self.data
	return d.selectedHeroList
end

_hw.loadhire = function(self,oUnitB,tgrDataP)
	if tgrDataP==nil then
		tgrDataP = self:getmapdata(1)
	end
	if tgrDataP~=nil then
		local oTown = oUnitB:gettown()
		if oTown then
			if type(oTown.data.townData)=="table" and (tgrDataP.TownHirePec or 100)~=100 then
				local nPec = tgrDataP.TownHirePec
				local townData = oTown.data.townData
				for i = 1, #townData do
					if type(townData[i])=="table" and townData[i].hireList ~= 0 then
						local hL = townData[i].hireList
						for j = 1,#hL do
							local v = hL[j]
							if v[3]>0 then
								v[2] = hApi.floor(v[2]*nPec/100)
								v[3] = hApi.floor(v[3]*nPec/100)
								v[4] = hApi.floor(v[4]*nPec/100)
							end
						end
					end
				end
			end
		else
			if type(oUnitB.data.hireList)=="table" and (tgrDataP.HirePec or 100)~=100 then
				local nPec = tgrDataP.HirePec
				local tHire = oUnitB.data.hireList
				for i = 1,#tHire do
					tHire[i][3] = math.max(1,hApi.floor(tHire[i][3]*nPec/100))
					tHire[i][2] = tHire[i][3]
				end
			end
		end
	end
end

----------------------------------------------------
-- 玩家积分
_hw.getplayerlog = function(self,nPlayerId,mode)
	local pLog = self.data.playerLog
	if (pLog ~= 0) then
		if (mode=="Init") then
			pLog[nPlayerId] = {
				star = {0,0,0,0,0,0,},		--对应1~6星
				starV = 0,			--胜利评价,1~6星
				scoreV = 0,			--游戏胜利时会计算给予玩家一定积分，会写在这个值里
				killCount = 0,			--总击杀数量
				lostCount = 0,			--总损失数量
				endlessLastScore = 0, --无尽模式历史最高值
				endlessCurrentScore = 0, --无尽模式本次值
			}
		elseif pLog[nPlayerId]~=nil then
			return pLog[nPlayerId]
		end
	end
end
-----------------------------------------------------
_hw.startround = function(self,length,tPlayerSort)
	local d = self.data
	local r = self:getround()
	if r~=nil then
		r:del()
	end
	return hClass.round:new({
		world = self,
		length = length or 9,
		PlayerSort = tPlayerSort,
	})
end

_hw.getround = function(self)
	local r = hClass.round:find(self.data.roundID)
	if r and r.data.worldID==self.ID then
		return r
	end
end

local __SelectTargetFromChaTab = function(oWorld,worldX,worldY,tUnitList,sOperate)
	local selectU
	local selectV
	if #tUnitList>0 then
		for i = 1,#tUnitList do
			local u = tUnitList[i]
			if u~=0 then
				if u:getworld()~=oWorld then
					xlLG("hit_error","oWorld:hit2unit("..tostring(sOperate)..")返回错误，返回了不在当前世界上的单位：单位["..u.data.name.."] - 世界layer:["..oWorld.data.type.."]\n")
				end
				local v = 0
				if oWorld.data.type=="worldmap" then
					if u.data.type==hVar.UNIT_TYPE.ITEM or u.data.type==hVar.UNIT_TYPE.RESOURCE then
						v = 0
					else
						local cx,cy = u:getXY()
						local x,y,w,h = u:getbox()
						if x~=nil then
							cx = cx + x + w/2
							cy = cy + y + h/2
						end
						local w,h = math.abs(cx-worldX),math.abs(cy-worldY)
						v = w*w+h*h
						if u==hGlobal.LocalPlayer:getfocusunit() then
							v = v*2
						end
					end
				else
					local cx,cy = u:getXY()
					local x,y,w,h = u:getbox()
					if x~=nil then
						cx = cx + x + w/2
						cy = cy + y + h/2
					end
					local w,h = math.abs(cx-worldX),math.abs(cy-worldY)
					v = w*w+h*h
					if u.data.type==hVar.UNIT_TYPE.BUILDING then
						v = v*2
					end
				end
				if selectV==nil then
					selectU = u
					selectV = v
				elseif v<selectV then
					selectU = u
					selectV = v
				end
			end
		end
	end
	return selectU
end

_hw.hit4unit = function(self,worldX,worldY,sOperate,oUnit)
	local tUnitList = {hApi.GetWorldChaByHit(self.data.scenetype,worldX,worldY)}
	if #tUnitList>0 then
		for i = 1,#tUnitList do
			local c = tUnitList[i]
			local u = hApi.findUnitByCha(c)
			if u and u.data.IsDead~=1 and u.data.IsHide~=1 and oUnit==u then
				return oUnit
			end
		end
	end
end

_hw.hit2unit = function(self,worldX,worldY,sOperate,oUnit,nSkillId)
	local tUnitList = {hApi.GetWorldChaByHit(self.data.scenetype,worldX,worldY)}
	--安卓测试代码
	--if g_phone_mode==3 then
		--hGlobal.event:event("LocalEvent_Hit2Unit",self,worldX,worldY,tUnitList)
	--end
	local selectU
	if #tUnitList>0 then
		for i = 1,#tUnitList do
			local c = tUnitList[i]
			local u = hApi.findUnitByCha(c)
			if u and u.data.IsDead~=1 and u.data.IsHide~=1 then
				tUnitList[i] = u
			else
				tUnitList[i] = 0
			end
		end
		if oUnit and nSkillId then
			local tUnitListII = {}
			for i = 1,#tUnitList do
				if tUnitList[i]~=0 then
					if hApi.IsAvailableTarget(oUnit,nSkillId,tUnitList[i])~=hVar.RESULT_SUCESS then
						tUnitListII[#tUnitListII+1] = tUnitList[i]
						tUnitList[i] = 0
					end
				end
			end
			if #tUnitListII>0 then
				selectU = __SelectTargetFromChaTab(self,worldX,worldY,tUnitList,sOperate)
				if selectU==nil then
					selectU = __SelectTargetFromChaTab(self,worldX,worldY,tUnitListII,sOperate)
				end
			else
				selectU = __SelectTargetFromChaTab(self,worldX,worldY,tUnitList,sOperate)
			end
		else
			selectU = __SelectTargetFromChaTab(self,worldX,worldY,tUnitList,sOperate)
		end
	end
	return selectU
end

_hw.tgrid2unit = function(self,triggerID)
	local tgrIndex = self.data.triggerIndex
	if triggerID~=nil and triggerID~=0 and tgrIndex~=nil then
		local v = tgrIndex[triggerID]
		if v then
			local u = hClass.unit:find(v[1])
			--if u and u.__ID==v[2] then
			if u and u:getworldC()==v[2] then
				return u,v[3]
			end
		end
	end
end

_hw.tgrid2data = function(self,triggerID)
	local tgrIndex = self.data.triggerIndex
	if triggerID~=nil and triggerID~=0 and tgrIndex~=nil then
		local v = tgrIndex[triggerID]
		if v then
			return v[3]
		end
	end
end

_hw.reloadtriggerID = function(self,unit,triggerID)
	local tgrIndex = self.data.triggerIndex
	if triggerID~=nil and triggerID~=0 and tgrIndex~=nil then
		local v = tgrIndex[triggerID]
		--v[2] = unit.__ID
		v[2] = unit:getworldC()
	end
end

local __CODE__GetRandomNum = function(r,a,b)
	if a==b then
		return a
	else
		local mn,mx
		if a>b then
			mn = b
			mx = a
		else
			mn = a
			mx = b
		end
		r.randomcount = r.randomcount + 1
		local RAND_MAX = 2147483647
		--这个算法保证所产生的值不会超过(2^31 - 1)
		--这里(2^31 - 1)就是 0x7FFFFFFF。而 0x7FFFFFFF
		--等于127773 * (7^5) + 2836,7^5 = 16807。
		--整个算法是通过：t = (7^5 * t) mod (2^31 - 1)
		--这个公式来计算随机值，并且把这次得到的值，作为
		--下次计算的随机种子值。
		r.randomvalue = math.floor((16807*r.randomvalue/127773 - 2836*r.randomvalue%127773)%(RAND_MAX+1))
		local rRange = mx-mn+1
		if r.randomvalue<rRange then
			r.randomvalue = r.randomvalue + RAND_MAX
		end
		--if why then
			--if r.__LOG==nil then
				--r.__LOG = {}
			--end
			--r.__LOG[#r.__LOG+1] = {why,r.randomvalue,r.framecount}
		--end
		return math.floor(r.randomvalue%rRange+mn)
	end
end

--_hw.random = function(self,a,b,why)
--	local d = self.data
--	if d.netdata==0 then
--		return hApi.random(a,b)
--	else
--		return __CODE__GetRandomNum(d.netdata,a,b)
--	end
--end

_hw.addcover = function(self,g,nPercent,nPercentR)
	local d = self.data
	local c = d.cover
	if type(nPercent)=="number" then
		c.pec = nPercent
	end
	if type(nPercentR)=="number" then
		c.rpec = nPercentR
	end
	if type(g)=="table" and #g>0 then
		for i = 1,#g do
			c[g[i].x.."|"..g[i].y] = 1
		end
	end
end

_hw.IsUnitCovered = function(self,oUnit)
	local g = oUnit:getgrid()
	local tCover = self.data.cover
	if #g>0 then
		for i = 1,#g do
			if tCover[g[i].x.."|"..g[i].y]==nil then
				return hVar.RESULT_FAIL
			end
		end
		return hVar.RESULT_SUCESS
	end
	return hVar.RESULT_FAIL
end

------------------------
-- 世界log
_hw.log = function(self,tabLog)
	--geyachao: todo 暂时注释掉
	--[[
	if type(tabLog)=="table" then
		tabLog.round = self.data.roundcount
		local lg = self.__LOG
		lg.i = lg.i + 1
		lg[lg.i] = tabLog
		if tabLog[1]==0 then
			tabLog[1] = lg.i
			lg.cur = lg.i
		end
	end
	]]
end

----------------------
-- 遍历地图上的单位
_hw.enumunit = function(self,code,param,param2)
	if code then
		return hApi.enumByClassR(self,hClass.unit,self.data.units,code,param,param2)
	end
end

----------------------
-- 遍历地图上的特效
_hw.enumeffect = function(self,code,param,param2)
	if code then
		return hApi.enumByClassR(self,hClass.unit,self.data.effects,code,param,param2)
	end
end

--检查单位是否站在该节点上
local __CODE__CallFuncForUnitOnNode = function(oWorld,tTemp,tGrid,tNode,code,param,param2)
	for i = 1,#tGrid do
		local unitID = tNode[oWorld:grid2n(tGrid[i].x,tGrid[i].y)]
		if unitID~=nil and unitID~=0 and tTemp[unitID]~=1 then
			local oUnit = hClass.unit:find(unitID)
			if oUnit then
				tTemp[unitID] = 1
				code(oUnit,param,param2,oWorld)
			end
		end
	end
end

local __CODE__CallFuncForUnitOnNodeT = function(oWorld,tTemp,tGrid,tNode,code,param,param2)
	for i = 1,#tGrid do
		local tList = tNode[oWorld:grid2n(tGrid[i].x,tGrid[i].y)]
		if (tList or 0)~=0 then
			local t
			for n = 1,#tList do
				local unitID = tList[n]
				if unitID~=0 and tTemp[unitID]~=1 then
					local oUnit = hClass.unit:find(unitID)
					if oUnit then
						tTemp[unitID] = 1
						if t==nil then
							t = {}
						end
						t[#t+1] = oUnit
					end
				end
			end
			if t~=nil then
				for n = 1,#t do
					local oUnit = t[n]
					code(oUnit,param,param2,oWorld)
				end
			end
		end
	end
end

local __count = 0
_hw.enumunitR = function(self,gridX,gridY,rMin,rMax,code,param,param2)
	local d = self.data
	if gridX and gridY and rMin and rMax then
		if d.type=="battlefield" then
			local tGrid = {}
			if type(code)=="function" then
				if rMax<0 then
					return self:enumunit(code,param,param2)
				elseif self:gridinrange(tGrid,gridX,gridY,rMin,rMax)>0 then
					local temp = {}
					__CODE__CallFuncForUnitOnNode(self,temp,tGrid,d.unitInGrid[1],code,param,param2)
					__CODE__CallFuncForUnitOnNode(self,temp,tGrid,d.unitInGrid[2],code,param,param2)
					__CODE__CallFuncForUnitOnNodeT(self,temp,tGrid,d.unitInGrid[3],code,param,param2)
				end
			end
		else
			if type(code)=="function" then
				return hApi.enumByClassR(self,hClass.unit,self.data.units,function(u)
					local w = math.abs(u.data.gridX - gridX)
					local h = math.abs(u.data.gridY - gridY)
					local v = w*w+h*h
					rMin = math.max(0,rMin)
					if rMax<0 or(v>=rMin*rMin and v<=rMax*rMax) then
						code(u,param,param2,self)
					end
				end)
			else
				local r = {}
				hApi.enumByClassR(self,hClass.unit,self.data.units,function(u)
					local w = math.abs(u.data.gridX - gridX)
					local h = math.abs(u.data.gridY - gridY)
					local v = w*w+h*h
					rMin = math.max(0,rMin)
					if rMax<0 or(v>=rMin*rMin and v<=rMax*rMax) then
						r[#r+1] = u
					end
				end)
				return r
			end
		end
	else
		_DEBUG_MSG("[LUA ERR] - world:enumunitR(x,y,rMin,rMax,code) 错误的地图坐标！",gridX,gridY,rMin,rMax)
	end
end

local __count = 0
_hw.enumunitUR = function(self,oUnit,rMin,rMax,code,param,param2)
	local d = self.data
	if d.type=="battlefield" then
		local tGrid = {}
		if type(code)=="function" then
			if rMax<=-1 then
				return self:enumunit(code,param,param2)
			elseif self:gridinunitrange(tGrid,oUnit,rMin,rMax)>0 then
				local temp = {}
				__CODE__CallFuncForUnitOnNode(self,temp,tGrid,d.unitInGrid[1],code,param,param2)
				__CODE__CallFuncForUnitOnNode(self,temp,tGrid,d.unitInGrid[2],code,param,param2)
				__CODE__CallFuncForUnitOnNodeT(self,temp,tGrid,d.unitInGrid[3],code,param,param2)
			end
		end
	end
end

_hw.enumunitG = function(self,tGrid,code,param,param2)
	local d = self.data
	if d.type=="battlefield" and type(code)=="function" and type(tGrid)=="table" then
		local temp = {}
		__CODE__CallFuncForUnitOnNode(self,temp,tGrid,d.unitInGrid[1],code,param,param2)
		__CODE__CallFuncForUnitOnNode(self,temp,tGrid,d.unitInGrid[2],code,param,param2)
		__CODE__CallFuncForUnitOnNodeT(self,temp,tGrid,d.unitInGrid[3],code,param,param2)
	end
end


local __ENUM__CloseGate = function(t,oPlayer,sAnimation,oWorld)
	if t.data.IsGate==2 and t.data.IsDead~=1 and oPlayer:allience(t:getowner())==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
		t.data.IsGate = 1
		oWorld:addblockU(t,nil,nil,1)
		if sAnimation~=nil then
			t:setanimation(sAnimation)
		end
	end
end
local __GateCheck = 0
local __ENUM__IsSomeoneOnGate = function(u)
	if u.data.IsDead~=1 and (u.data.type==hVar.UNIT_TYPE.UNIT or u.data.type==hVar.UNIT_TYPE.HERO) then
		__GateCheck = 1
	end
end
local __ENUM__CloseGateChecked = function(t,oPlayer,sAnimation,oWorld)
	if t.data.IsGate==2 and t.data.IsDead~=1 and oPlayer:allience(t:getowner())==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
		local g = t:getgrid()
		__GateCheck = 0
		oWorld:enumunitG(g,__ENUM__IsSomeoneOnGate)
		if __GateCheck==1 then
			return
		end
		t.data.IsGate = 1
		oWorld:addblockU(t,nil,nil,1)
		if sAnimation~=nil then
			t:setanimation(sAnimation)
		end
	end
end
local __ENUM__OpenGate = function(t,oPlayer,sAnimation,oWorld)
	if t.data.IsGate==1 and t.data.IsDead~=1 and oPlayer:allience(t:getowner())==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
		t.data.IsGate = 2
		oWorld:removeblockU(t,nil,nil,1)
		if sAnimation~=nil then
			t:setanimation(sAnimation)
		end
	end
end
_hw.opengate = function(self,oPlayer,IsOpen,sAnimation)
	if IsOpen==-1 then
		--强制关门
		return self:enumunit(__ENUM__CloseGate,oPlayer,sAnimation)
	elseif IsOpen==0 then
		--非强制关门
		return self:enumunit(__ENUM__CloseGateChecked,oPlayer,sAnimation)
	else
		--芝麻开门
		return self:enumunit(__ENUM__OpenGate,oPlayer,sAnimation)
	end
end

local __ENUM__OpenGateT = function(t,oPlayer,gTab,oWorld)
	if t.data.IsGate==1 and t.data.IsDead~=1 and oPlayer:allience(t:getowner())==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
		t.data.IsGate = 2
		oWorld:removeblockU(t,nil,nil,1)
		gTab[#gTab+1] = t
	end
end
_hw.opengateT = function(self,oPlayer,IsOpen,gTab)
	gTab = gTab or {}
	if IsOpen==1 then
		self:enumunit(__ENUM__OpenGateT,oPlayer,gTab)
		return gTab
	else
		for i = 1,#gTab do
			local t = gTab[i]
			t.data.IsGate = 1
			self:addblockU(t,nil,nil,1)
		end
	end
	return gTab
end
-----------------------------------

local __CountR = 0
local __CountBusyUnit = function(u)
	if u.data.IsDead~=1 and u.data.IsBusy~=0 then
		__CountR = __CountR + 1
	end
end
_hw.count = function(self,key)
	__CountR = 0
	if key=="BusyUnit" then
		self:enumunit(__CountBusyUnit)
	end
	return __CountR
end

----------------------
-- 移除地图上的所有物体
local __ClearPlayerHero = function(p)
	hApi.clearTable("H",p.heros)
end
local __ClearBuildingData = function(u)
	local t = u:gettown()
	if t~=nil then
		t.data.townID = 0
		t:del()
	end
end
local __RemoveObjectOnWorldDestroy = function(o)
	o.handle.__manager = "OnWorldDestroy"
	o:del()
end
_hw.removeAll = function(self)
	local d = self.data
	local IsDestroyed = d.IsDestroyed
	d.HeroLeader = 0	--战场临时数据清零
	if d.type=="worldmap" then
		--如果自己是世界地图
		--那么就连所有英雄一起删掉
		hClass.player:enum(__ClearPlayerHero)
		hClass.hero:enum(hApi.removeObject)
		--然后把地图上建筑的town删掉
		hApi.enumByClass(self,hClass.unit,d.units,__ClearBuildingData)
		
	end
	
	d.IsDestroyed = 1
	--必须先删单位,单位会删除身上的特效
	hApi.enumByClass(self,hClass.unit,d.units,__RemoveObjectOnWorldDestroy)
	--随后删除特效
	hApi.enumByClass(self,hClass.effect,d.effects,__RemoveObjectOnWorldDestroy)
	--什么时候删场景物件其实无所谓
	hApi.enumByClass(self,hClass.sceobj,d.sceobjs,__RemoveObjectOnWorldDestroy)
	
	d.IsDestroyed = IsDestroyed
	
	d.units = hApi.clearTable("I",d.units)			--清除所有世界单位
	d.sceobjs = hApi.clearTable("I",d.sceobjs)		--清除所有世界场景物件
	d.effects = hApi.clearTable("I",d.effects)		--清除所有世界特效
	
	--删除所有玩家数据
	for pos, player in pairs(d.PlayerList) do
		if player and type(player) == "table" then
			player:del()
		end
	end
	d.PlayerList = 0
	d.PlayerDic = 0
	d.PlayerMe = 0
	d.sessionId = -1
	d.session_dbId = -1
	d.session_cfgId = -1
	d.randomSeed = 0
	d.pvpTempTable = {} --pvp的存储数据的表
end

---------------------------------------------------------
hApi.ConvertMapString = function(s,n)
	if s and type(s)=="string" and string.sub(s,1,1)=="$" then
		n = n or 1
		local t = hVar.tab_stringM[s]
		if type(t)=="table" then
			return (t[n] or t[#t])
		elseif t then
			return tostring(t)
		else
			return s
		end
	else
		return s
	end
end

--hApi.InitTeamForUnit = function(oUnit,tgrDataU,paramTemp)
--	local oWorld = oUnit:getworld()
--	if oWorld==nil then
--		return
--	elseif oWorld.data.type~="worldmap" then
--		return
--	elseif oUnit.data.type==hVar.UNIT_TYPE.GROUP then
--		--随机怪组不会产生兵
--		return
--	end
--	if paramTemp==nil then
--		paramTemp = {}
--	end
--	if paramTemp.EnemyBornPec and paramTemp.AllyBornPec and paramTemp.CreepBornPec then
--		--若拥有所有的参数则不重新读取
--	else
--		--参数不完整的话，读取一遍
--		paramTemp.EnemyBornPec = hApi.GetMapValueByDifficulty(oWorld,"EnemyBorn")
--		if paramTemp.EnemyBornPec<=0 then
--			paramTemp.EnemyBornPec = 0
--		end
--		paramTemp.AllyBornPec = hApi.GetMapValueByDifficulty(oWorld,"AllyBorn")
--		if paramTemp.AllyBornPec<=0 then
--			paramTemp.AllyBornPec = 0
--		end
--		paramTemp.CreepBornPec = hApi.GetMapValueByDifficulty(oWorld,"CreepBorn")
--		if paramTemp.CreepBornPec<=0 then
--			paramTemp.CreepBornPec = 0
--		end
--	end
--	local team
--	if tgrDataU then
--		team = tgrDataU.team
--	end
--	if type(team)~="table" then
--		local tabU = oUnit:gettab()
--		if tabU and tabU.team~=nil then
--			team = tabU.team
--		end
--	end
--	local IsAI = hApi.IsUnitManagedByAI(oUnit)
--	--如果读取到team则使用team中的部队初始化单位
--	if type(team)=="table" then
--		if oUnit.data.type==hVar.UNIT_TYPE.HERO or oUnit.data.type==hVar.UNIT_TYPE.UNIT then
--			local TeamSlotPlus = 0
--			if oUnit.data.team==0 then
--				oUnit.data.team = hApi.InitUnitTeam()
--			else
--				for i = 1,#oUnit.data.team do
--					if oUnit.data.team[i]~=0 then
--						TeamSlotPlus = i
--					end
--				end
--			end
--			local teamAdd = {}
--			for i = 1,#team do
--				local id,nMin,nMax,tIndex = unpack(team[i])
--				if type(id)=="number" then
--					if id<=0 then
--						id = oUnit.data.id
--					end
--					if hVar.tab_unit[id] then
--						local num = nMin or 1
--						if nMin~=nil and nMax~=nil and nMin~=nMax then
--							num = oWorld:random(nMin,nMax)
--						end
--						if num>0 then
--							if oUnit.data.owner==0 then
--								--野怪
--								num = math.max(1,hApi.floor(paramTemp.CreepBornPec*num))
--							elseif IsAI==1 then
--								--任何电脑控制的单位（敌人）
--								num = math.max(1,hApi.floor(paramTemp.EnemyBornPec*num))
--							elseif IsAI==-1 then
--								--任何电脑控制的单位（友军）
--								num = math.max(1,hApi.floor(paramTemp.AllyBornPec*num))
--							end
--							teamAdd[#teamAdd+1] = {id,num,tIndex or i+TeamSlotPlus,1}
--						end
--					else
--						_DEBUG_MSG("[DAT ERROR]初始化部队单位出错，"..oUnit.data.name.."("..oUnit.data.owner..")的队伍中不存在id=["..tostring(id).."]的单位")
--					end
--				end
--			end
--			if #teamAdd>0 then
--				oUnit:teamaddunit(teamAdd)
--			end
--		end
--	end
--	--增加随机的怪物组
--	if tgrDataU and tgrDataU.randomTeamGroup then
--		local tabG = hVar.tab_unit[tgrDataU.randomTeamGroup]
--		if tabG and tabG.group then
--			local tScore = tgrDataU.score or tabG.score
--			local oPlayer = oUnit:getowner()
--			if oUnit.data.owner==0 or (oPlayer and oPlayer.data.IsAIPlayer==1) then
--				local nScorePec
--				if oUnit.data.owner==0 then
--					--野怪
--					nScorePec = paramTemp.CreepBornPec
--				elseif IsAI==1 then
--					--任何电脑控制的单位（敌人）
--					nScorePec = paramTemp.EnemyBornPec
--				elseif IsAI==-1 then
--					--任何电脑控制的单位（友军）
--					nScorePec = paramTemp.AllyBornPec
--				end
--				--AI敌人的兵力更厉
--				hApi.CreateArmyByGroup(oWorld,nil,oUnit,tabG.group,tScore,oWorld.data.MonGrowth/1000,nScorePec)
--			else
--				--非AI玩家的部队不自动增长
--				hApi.CreateArmyByGroup(oWorld,nil,oUnit,tabG.group,tScore,0)
--			end
--		end
--	end
--	----如果是英雄的话，把初始单位记录下来,长兵用(必须放在最后)
--	--if oUnit.data.type==hVar.UNIT_TYPE.HERO then
--	--	local oHero = oUnit:gethero()
--	--	if oHero then
--	--		local p = oUnit:getowner()
--	--		if p and p.data.IsAIPlayer==1 then
--	--			oHero.data.AITeam = hApi.InitUnitTeam()
--	--			local team = oUnit.data.team
--	--			local teamH = oHero.data.AITeam
--	--			for i = 1,#team do
--	--				if team[i]~=0 and team[i][1]~=id then
--	--					teamH[i] = {unpack(team[i])}
--	--				end
--	--			end
--	--		end
--	--	end
--	--end
--end


local __self,__unitList,__triggerData,__codeOnCreate

--计算路点方程信息（原始数据初始化时，重新组织路点数据）
hApi.CalculateMovePointFunction = function (pointInfo)

	local x = pointInfo[1] or 0 --路点坐标x
	local y = pointInfo[2] or 0 --路点坐标y
	local angle = pointInfo[3] or 90 --路点与x轴夹角
	local rangeRadius = pointInfo[4] or 0 --路点覆盖半径
	local faceTo = pointInfo[5] or 0 --路点覆盖半径
	local isHide = pointInfo[6] or 0 --经过路点怪物是否隐身
	
	--local dx = rangeRadius * math.cos(math.rad(angle))
	--local dy = rangeRadius * math.sin(math.rad(angle))
	local pathInfo = 
	{
		x = x,					--中心坐标x
		y = y,					--中心坐标y
		angle = angle,				--直线与x轴角度
		rangeRadius = rangeRadius,		--线段长度
		faceTo = faceTo,
		--maxX = x + math.abs(dx),		--x最大值
		--minX = x - math.abs(dx),		--x最小值
		--maxY = y + math.abs(dy),		--y最大值
		--minY = y - math.abs(dy),		--y最小值
		isHide = isHide,
	}
	----直线不垂直于x轴
	--if math.cos(math.rad(angle)) ~=  0 then
	--	local k = math.tan(math.rad(angle))
	--	local b = y - k * x
	--
	--	pathInfo.k = k				--直线方程斜率
	--	pathInfo.b = b				--直线方程偏移
	--end

	return pathInfo
end



--根据路点（起点）数据，返回符合条件的点
hApi.ReturnPointByDistancePer = function (pointInfo, distancePer)
	
	--原始值
	local x = pointInfo.x or 0			--原点坐标x
	local y = pointInfo.y or 0			--原点坐标y
	local r = pointInfo.rangeRadius or 0		--原点的覆盖半径
	local a = pointInfo.angle or 90			--经过原点的直线与x轴角度
	
	--返回值
	local x0 = x					--最终点坐标x
	local y0 = y					--最重点坐标y
	
	--如果起点的出兵范围半径为0，那么他就是个普通的点
	if r > 0 then
		local newR = distancePer * r
		x0 = newR * math.cos(math.rad(-a)) + x
		y0 = newR * math.sin(math.rad(-a)) + y
		x0 = math.floor(x0 * 100) / 100  --保留2位有效数字，用于同步
		y0 = math.floor(y0 * 100) / 100  --保留2位有效数字，用于同步
	end
	
	return {x = x0, y = y0, distancePer = distancePer}
end

--
hApi.CalculateMovePoint = function(world, wayPointInfo)
	
	local retMP = {} --角色移动路点move_point
	local dType = hVar.TD_DEPLOY_TYPE
	for formation = hVar.TD_DEPLOY_TYPE.ONE_POINT_CENTER , hVar.TD_DEPLOY_TYPE.THREE_RANDOM_DISTANCE do
		
		retMP[formation] = {}
		if formation == dType.ONE_POINT_CENTER then

			--计算路点信息
			local tTmp = {}
			for i = 1, #wayPointInfo do
				tTmp[#tTmp + 1] = {x = wayPointInfo[i].x, y = wayPointInfo[i].y,isHide = wayPointInfo[i].isHide}
				--测试路点位置
				--world:addunit(69997, 1, nil,nil, hVar.UNIT_DEFAULT_FACING, wayPointInfo[i].x, wayPointInfo[i].y)
			end
			retMP[formation][1] = tTmp
		elseif formation == dType.ONE_SAME_DISTANCE or formation == dType.ONE_RANDOM_DISTANCE then

			local distancePer = (world:random(1, 100) / 100)
			local tmp = world:random(0, 1)
			if tmp == 1 then
				distancePer = -1 * distancePer
			end
			
			--计算路点信息
			local tTmp = {}
			for i = 1, #wayPointInfo do
				--if formation == dType.ONE_RANDOM_DISTANCE then
				--	distancePer = (world:random(1, 100) / 100)
				--	tmp = world:random(0, 1)
				--	if tmp == 1 then
				--		distancePer = -1 * distancePer
				--	end
				--end
				if formation == dType.ONE_SAME_DISTANCE then
					local ret = hApi.ReturnPointByDistancePer(wayPointInfo[i], distancePer)
					tTmp[#tTmp + 1] = {x = ret.x, y = ret.y,isHide = wayPointInfo[i].isHide}
				else
					tTmp[#tTmp + 1] = wayPointInfo[i]
				end
			end
			retMP[formation][1] = tTmp
		
		elseif formation == dType.THREE_POINT_CENTER or formation == dType.THREE_AVERAGE_CENTER then
			
			--计算路点信息
			local tTmp = {{},{},{}}
			for i = 1, #wayPointInfo do
				
				if formation == dType.THREE_POINT_CENTER then
					for j = 1, 3 do
						tTmp[j][#tTmp[j] + 1] = {x = wayPointInfo[i].x, y = wayPointInfo[i].y,isHide = wayPointInfo[i].isHide}
					end
				else
					--最上方的点
					local ret = hApi.ReturnPointByDistancePer(wayPointInfo[i], 1)
					tTmp[1][#tTmp[1] + 1] = {x = ret.x, y = ret.y,isHide = wayPointInfo[i].isHide}
					--中点
					tTmp[2][#tTmp[2] + 1] = {x = wayPointInfo[i].x, y = wayPointInfo[i].y,isHide = wayPointInfo[i].isHide}
					--最下方的点
					ret = hApi.ReturnPointByDistancePer(wayPointInfo[i], -1)
					tTmp[3][#tTmp[3] + 1] = {x = ret.x, y = ret.y,isHide = wayPointInfo[i].isHide}
				end
			end
			retMP[formation] = tTmp

		elseif formation == dType.THREE_SAME_DISTANCE or formation == dType.THREE_RANDOM_DISTANCE then
			
			local distancePer = (world:random(30, 100) / 100)

			if formation == dType.THREE_SAME_DISTANCE then
				distancePer = 80 / 100
			end

			--计算路点信息
			local tTmp = {{},{},{}}
			for i = 1, #wayPointInfo do
				
				--if formation == dType.THREE_RANDOM_DISTANCE then
				--	distancePer = (world:random(1, 100) / 100)
				--end
				if formation == dType.THREE_SAME_DISTANCE then	
					--最上方的点
					local ret = hApi.ReturnPointByDistancePer(wayPointInfo[i], distancePer)
					tTmp[1][#tTmp[1] + 1] = {x = ret.x, y = ret.y,isHide = wayPointInfo[i].isHide}
					--中点
					tTmp[2][#tTmp[2] + 1] = {x = wayPointInfo[i].x, y = wayPointInfo[i].y,isHide = wayPointInfo[i].isHide}
					--最下方的点
					ret = hApi.ReturnPointByDistancePer(wayPointInfo[i], -distancePer)
					tTmp[3][#tTmp[3] + 1] = {x = ret.x, y = ret.y,isHide = wayPointInfo[i].isHide}
				else
					tTmp[1][#tTmp[1] + 1] = wayPointInfo[i]
				end
			end
			retMP[formation] = tTmp
			retMP[formation].distancePer = distancePer
		end
	end

	return retMP
end

--计算起点
function hApi.calculateBeginPos(world, beginPos, formation, pathInfo, index)

	local pathId = 0
	if type(pathInfo) == "number" then
		pathId = pathInfo
	else
		if pathInfo then
			local tPathInfo = hApi.String2Type(pathInfo, ":") or {}
			if tPathInfo[1] == "e" or tPathInfo[1] == "event" then
				pathId = tonumber(tPathInfo[2]) or 0
			else
				pathId = tonumber(tPathInfo[1]) or 0
			end
		end
	end

	local retPos = {}
	retPos.x = beginPos.x
	retPos.y = beginPos.y
	retPos.faceTo = beginPos.faceTo
	retPos.isHide = beginPos.isHide
	
	local dType = hVar.TD_DEPLOY_TYPE
	
	if formation == dType.ONE_POINT_CENTER then
	elseif formation == dType.ONE_SAME_DISTANCE or formation == dType.ONE_RANDOM_DISTANCE then
		
		local distancePer = (world:random(1, 100) / 100)
		local tmp = world:random(0, 1)
		if tmp == 1 then
			distancePer = -1 * distancePer
		end
		
		--计算起点位置
		local ret = hApi.ReturnPointByDistancePer(beginPos, distancePer)
		
		retPos.x = ret.x
		retPos.y = ret.y
		
	elseif formation == dType.THREE_POINT_CENTER or formation == dType.THREE_AVERAGE_CENTER then
		
		--计算起点位置
		if not index then
		else
			if index == 1 then  --最上方的点
				local ret = hApi.ReturnPointByDistancePer(beginPos, 1)
				retPos.x = ret.x
				retPos.y = ret.y
			elseif index == 2 then --中点
				
			elseif index == 3 then --最下方的点
				local ret = hApi.ReturnPointByDistancePer(beginPos, -1)
				retPos.x = ret.x
				retPos.y = ret.y
			end
		end
	elseif formation == dType.THREE_SAME_DISTANCE or formation == dType.THREE_RANDOM_DISTANCE then
		
		local distancePer
		if formation == dType.THREE_SAME_DISTANCE then
			--print("pathId=", pathId, type(pathId))
			--print("formation=", formation)
			--print(#world.data.tdMapInfo.pathList, world.data.tdMapInfo.pathList[pathId])
			--print(world.data.tdMapInfo.pathList[pathId][formation])
			distancePer = world.data.tdMapInfo.pathList[pathId][formation].distancePer
		elseif formation == dType.THREE_RANDOM_DISTANCE then
			distancePer = (world:random(30, 100) / 100)
			if formation == dType.THREE_SAME_DISTANCE then
				distancePer = 80 / 100
			end
		end
		
		--计算起点位置
		if not index then
		else
			if index == 1 then  --最上方的点
				local ret = hApi.ReturnPointByDistancePer(beginPos, distancePer)
				retPos.x = ret.x
				retPos.y = ret.y
			elseif index == 2 then --中点
			elseif index == 3 then --最下方的点
				local ret = hApi.ReturnPointByDistancePer(beginPos, -distancePer)
				retPos.x = ret.x
				retPos.y = ret.y
			end
		end

	else
	end

	return retPos
end

--计算当前出兵点及路点
--[[
mapInfo.hApi.CalculateMovePoint = function(beginPosInfo, wayPointInfo, formation)

	for k in pairs(retBP) do
		retBP[k] = nil
	end
	
	for k in pairs(retMP) do
		retMP[k] = nil
	end
	
	local dType = hVar.TD_DEPLOY_TYPE

	if formation == dType.ONE_POINT_CENTER then
		--计算起点位置
		table.insert(retBP, {x = beginPosInfo.x, y = beginPosInfo.y,faceTo = beginPosInfo.faceTo,isHide = beginPosInfo.isHide})

		--计算路点信息
		table.insert(retMP, {})
		for i = 1, #wayPointInfo do
			local wayPoint = {x = wayPointInfo[i].x, y = wayPointInfo[i].y,isHide = wayPointInfo[i].isHide}
			table.insert(retMP[1], wayPoint)
		end

	elseif formation == dType.ONE_SAME_DISTANCE or formation == dType.ONE_RANDOM_DISTANCE then

		local distancePer = (self:random(1, 100) / 100)
		local tmp = self:random(0, 1)
		if tmp == 1 then
			distancePer = -1 * distancePer
		end

		--计算起点位置
		local ret = hApi.ReturnPointByDistancePer(beginPosInfo, distancePer)
		table.insert(retBP, {x = ret.x, y = ret.y,faceTo = beginPosInfo.faceTo,isHide = beginPosInfo.isHide})
		
		--计算路点信息
		table.insert(retMP,{})
		for i = 1, #wayPointInfo do
			if formation == dType.ONE_RANDOM_DISTANCE then
				distancePer = (self:random(1, 100) / 100)
				tmp = self:random(0, 1)
				if tmp == 1 then
					distancePer = -1 * distancePer
				end
			end
			ret = hApi.ReturnPointByDistancePer(wayPointInfo[i], distancePer)
			table.insert(retMP[1], {x = ret.x, y = ret.y,isHide = wayPointInfo[i].isHide})
		end
	
	elseif formation == dType.THREE_POINT_CENTER or formation == dType.THREE_AVERAGE_CENTER then

		--计算起点位置
		--最上方的点
		local ret = hApi.ReturnPointByDistancePer(beginPosInfo, 1)
		table.insert(retBP, {x = ret.x, y = ret.y,faceTo = beginPosInfo.faceTo,isHide = beginPosInfo.isHide})
		--中点
		table.insert(retBP, {x = beginPosInfo.x, y = beginPosInfo.y,faceTo = beginPosInfo.faceTo,isHide = beginPosInfo.isHide})
		--最下方的点
		ret = hApi.ReturnPointByDistancePer(beginPosInfo, -1)
		table.insert(retBP, {x = ret.x, y = ret.y,faceTo = beginPosInfo.faceTo,isHide = beginPosInfo.isHide})
		
		--计算路点信息
		table.insert(retMP, {})
		table.insert(retMP, {})
		table.insert(retMP, {})
		for i = 1, #wayPointInfo do
			
			if formation == dType.THREE_POINT_CENTER then
				for j = 1, 3 do
					table.insert(retMP[j], {x = wayPointInfo[i].x, y = wayPointInfo[i].y,isHide = wayPointInfo[i].isHide})
				end
			else
				--最上方的点
				local ret = hApi.ReturnPointByDistancePer(wayPointInfo[i], 1)
				table.insert(retMP[1], {x = ret.x, y = ret.y,isHide = wayPointInfo[i].isHide})
				--中点
				table.insert(retMP[2], {x = wayPointInfo[i].x, y = wayPointInfo[i].y,isHide = wayPointInfo[i].isHide})
				--最下方的点
				ret = hApi.ReturnPointByDistancePer(wayPointInfo[i], -1)
				table.insert(retMP[3], {x = ret.x, y = ret.y,isHide = wayPointInfo[i].isHide})
			end
		end

	elseif formation == dType.THREE_SAME_DISTANCE or formation == dType.THREE_RANDOM_DISTANCE then
		
		local distancePer = (self:random(30, 100) / 100)

		if formation == dType.THREE_SAME_DISTANCE then
			distancePer = 80 / 100
		end

		--计算起点位置
		--最上方的点
		local ret = hApi.ReturnPointByDistancePer(beginPosInfo, distancePer)
		table.insert(retBP, {x = ret.x, y = ret.y,faceTo = beginPosInfo.faceTo,isHide = beginPosInfo.isHide})
		--中点
		table.insert(retBP, {x = beginPosInfo.x, y = beginPosInfo.y,faceTo = beginPosInfo.faceTo,isHide = beginPosInfo.isHide})
		--最下方的点
		ret = hApi.ReturnPointByDistancePer(beginPosInfo, -distancePer)
		table.insert(retBP, {x = ret.x, y = ret.y,faceTo = beginPosInfo.faceTo,isHide = beginPosInfo.isHide})

		--计算路点信息
		table.insert(retMP, {})
		table.insert(retMP, {})
		table.insert(retMP, {})
		for i = 1, #wayPointInfo do
			
			if formation == dType.THREE_RANDOM_DISTANCE then
				distancePer = (self:random(1, 100) / 100)
			end
				
			--最上方的点
			local ret = hApi.ReturnPointByDistancePer(wayPointInfo[i], distancePer)
			table.insert(retMP[1], {x = ret.x, y = ret.y,isHide = wayPointInfo[i].isHide})
			--中点
			table.insert(retMP[2], {x = wayPointInfo[i].x, y = wayPointInfo[i].y,isHide = wayPointInfo[i].isHide})
			--最下方的点
			ret = hApi.ReturnPointByDistancePer(wayPointInfo[i], -distancePer)
			table.insert(retMP[3], {x = ret.x, y = ret.y,isHide = wayPointInfo[i].isHide})
		end
	else
		table.insert(retBP, {x = beginPosInfo.x, y = beginPosInfo.y,faceTo = beginPosInfo.faceTo,isHide = beginPosInfo.isHide})
		table.insert(retMP, {})
	end

	return retBP, retMP
end
--]]

--初始化td地图信息
local __InitTDMapInfo = function()
	
	--[[
	self.data.tdMapInfo = 
	{
		mapMode = 0 --关卡模式
		mapDifficulty = 0 --关卡当前难度
		mapMaxDiff = 0 --关卡最高难度
		combatEva = 0 --挑战关卡战绩
		--godUnit = nil, --上帝角色(已转移到玩家身上)
		nextwaveBtnAppearDelay = 10000,
		mapLastState = hVar.MAP_TD_STATE.IDLE,
		mapState = hVar.MAP_TD_STATE.IDLE,
		
		buildTogether = false,
		
		viewRange = {}, --视窗移动范围
		viewOffset = {}, --视窗初始聚焦点
		viewOffsetPhone = {}, --手机版本视窗初始聚焦点
		
		--英雄出生点(已转移到上帝角色上)
		--heroBornPoint = 
		--{
		--	x = 0,
		--	y = 0,
		--	facing = 0,
		--},
		
		rebirthOnBirthPoint = 0,
		
		mapSetting = nil, --地图设置（初始化结束后删除）
		allMovePointPos = nil, --地图所有路点（初始化结束后删除）
		allBeginPointPos = nil, --地图所有起点位置（初始化结束后删除）
		wildPoint = nil,
		portal = nil,
		portalFinishState = nil, --某层是否已传送过
		sendArmyState = {}, --各起点没波出兵状态表
		totalWave = 0, --总波数
		wave = 0, --当前波数
		totalLife = 1, --总生命
		--life = 1, --当前生命
		gold = 0, --当前获得的金钱
		goldPerWave = {}, --每回合获得金钱
		--goldPerWaveAdd = {}, --每回合获得金钱的增加值
		beginTimeDelayPerWave = {}, --每回合发兵时间延迟
		talkScript = {},	--剧情
		talkScriptIdx = 1,	--当前剧情进行到哪里
		nextBeginTime = 0, --下回合出兵时刻
		exp = 0, --关卡结束获得经验
		--expAdd = 0, --关卡结束获得经验增加值
		maxHero = 0, --当前关卡可使用的英雄最大数量
		maxTactics = 0, --当前关卡可使用的战术技能卡（非塔类）最大数量
		maxTower = 0, --当前关卡可使用的塔最大数量
		maxGold = nil, --关卡最大金钱
		scoreV = 0, --当前关卡可获取的积分
		starReward = {}, --星级奖励() {(0,0)(1,100)(2,100,1,2)(3,100,2)}
		chestPool = {}, --挑战关卡奖池() {(0,0)(1,100)(2,100,1,2)(3,100,2)}
		getStarReward = {},

		firstBeginAdd = { --第一次游戏时剧情开始添加：1战术技能卡,2英雄
			{1,1000,1},				--类型,ID,等级
			{2,5000,1,1,1},				--类型,ID,等级(不填默认为己方1),属方(不填默认为己方1),星级(不填默认为1)
		}, 

		monsterTip = {
			[1] = {uid1,uid2,...},
			[2] = {},
			...,
			[totalWave] = {},
		}, --出怪信息提示
		
		--路线信息
		mapInfo.pathList = 
		{
			[formation1] = {
				[1] = {
					{x = 0, y = 0, isHide = 0},
					{x = 0, y = 0, isHide = 0},
					{x = 0, y = 0, isHide = 0},
					...,
				},
				[2] = {},		--三个一组的整形会有索引2
				[3] = {},		--三个一组的整形会有索引3
			},
			[formation2] = {
				[1] = {
					{x = 0, y = 0, isHide = 0},
					{x = 0, y = 0, isHide = 0},
					{x = 0, y = 0, isHide = 0},
					...,
				},
			},
			...,
			[formation7] = {
				[1] = {
					{x = 0, y = 0, isHide = 0},
					{x = 0, y = 0, isHide = 0},
					{x = 0, y = 0, isHide = 0},
					...,
				},
			},
		}
		
		--怪物模板信息(可能没有用)
		mapInfo.monstTemplate = {}

		--塔基信息（todo）
		mapInfo.towerBase = {}
		
		
		--记录每波会出兵的出兵点
		mapInfo.showFlagInfo = {
			[1] = {[bpTgrId] = soliderNum,...},
			[2] = {bpTgrId,...},
			...,
		}

		--起点信息
		mapInfo.beginPointList =
		{
			[beginPointTgrId] = 
			{
				beginWave = 1, --从第几波之后开始发兵
				beginStage = 0, --从第几层之后开始发兵
				showPos = {x, y}, --地图提示的位置信息
				unitPerWave = 
				{
					[1] = 
					{
						delay = 0, --上一波结束后多久开始发兵
						beginTime = 0, --波次开始时间
						unitInfoList = 
						{
							[1] = 
							{
								beginTime = 0,
								path = 1, --路线
								formation = 1, --阵型
								nextDelay = 0, --下一组延时
								perUnitDelay = 0, --每一组的每个小兵之间的间隔
								unitList = { --角色列表
									[1] = {id = 1, num = 1, owner = 2},
									[2] = {id = 2, num = 1, owner = 2},
									...,
								},
							},
							[2] = {...},
							...,
						}
					},
					[2] = {...},
					...,
				},
			}
		}
	}
	--]]
	
	local self = __self
	local mapInfo = self.data.tdMapInfo
	local mapMode = self.data.MapMode
	local mapDifficulty = self.data.MapDifficulty
	local banLimitTable = self.data.banLimitTable --排行榜，禁用的英雄、塔、战术卡、卡牌等级表
	local mapTab = hVar.MAP_INFO[self.data.map] or {}
	
	mapInfo.mapMode = mapMode
	mapInfo.mapDifficulty = mapDifficulty
	mapInfo.mapMaxDiff = 0
	--mapInfo.combatEva = 0
	local diablodata = hGlobal.LocalPlayer.data.diablodata --大菠萝的数据
	if (diablodata ~= 0) then
		mapInfo.combatEva = diablodata.score
	end
	
	--普通模式
	if (mapMode == hVar.MAP_TD_TYPE.NORMAL) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then
		mapInfo.banLimitTable = banLimitTable
	--挑战难度模式
	elseif mapMode == hVar.MAP_TD_TYPE.DIFFICULT then
		mapInfo.banLimitTable = banLimitTable
		
		local DiffMode = mapTab.DiffMode
		--如果挑战模式难度表信息不存在，则默认为普通模式
		if not DiffMode then
			self.data.MapMode = hVar.MAP_TD_TYPE.NORMAL
			self.data.MapDifficulty = 0
			
			mapInfo.mapMode = hVar.MAP_TD_TYPE.NORMAL
			mapInfo.mapDifficulty = 0
			mapInfo.mapMaxDiff = 0
		else
			--挑战难度模式难度信息初始化
			if mapDifficulty <= 0 then
				self.data.MapDifficulty = 1
				mapInfo.mapDifficulty = 1
			elseif mapDifficulty >= DiffMode.maxDiff then
				self.data.MapDifficulty = DiffMode.maxDiff
				mapInfo.mapDifficulty = DiffMode.maxDiff
			end
			mapInfo.mapMaxDiff = DiffMode.maxDiff
		end
	end
	
	--设置pve的战术技能卡
	local godPlayer = self:GetPlayerGod()
	if godPlayer then
		self:settactics(godPlayer, self.data.pveMultiTacticCfg)
	end

	local mapSetting = mapInfo.mapSetting
	if not mapSetting then
		return
	end

	--常量,下一波按钮显示延时(提前发兵)
	mapInfo.nextwaveBtnAppearDelay = 5000

	--常量
	mapInfo.buildTogether = mapSetting.buildTogether
	if mapInfo.buildTogether and mapInfo.buildTogether == 1 then
		mapInfo.buildTogether = true
	else
		mapInfo.buildTogether = false
	end

	--技能等级是否直接升满
	mapInfo.skillLvupToMax = mapSetting.skillLvupToMax
	if mapInfo.skillLvupToMax and mapInfo.skillLvupToMax == 1 then
		mapInfo.skillLvupToMax = true
	else
		mapInfo.skillLvupToMax = false
	end

	--地图中是否支持打怪掉落
	mapInfo.dropFlag = mapSetting.dropFlag or 0
	mapInfo.dropNum = 0
	
	--联网地图，英雄地图内最高等级(默认10)
	mapInfo.heroLvInPvpMap = mapSetting.heroLvInPvpMap or 10
	
	--是否自由造塔
	mapInfo.freeBuildTowerMode = mapSetting.freeBuildTowerMode or 0
	
	--联网地图，装备等级解锁或直接解锁(0 根据等级解锁 1 直接解锁)
	--mapInfo.equipUnlockMode = mapSetting.equipUnlockMode or 0
	--if mapInfo.equipUnlockMode > 0 then
	--	mapInfo.equipUnlockMode = 1
	--end

	----联网地图，技能按pve等级解锁或按局内等级上限解锁 (0 根据pve解锁 1 根据局内等级上限解锁)
	--mapInfo.skillUnlockMode = mapSetting.skillUnlockMode or 0
	--if mapInfo.skillUnlockMode > 0 then
	--	mapInfo.skillUnlockMode = 1
	--end

	--联网地图，是否直接使用pve角色(0不使用(使用pvp角色) 1使用)
	mapInfo.pveHeroMode = mapSetting.pveHeroMode or 0
	if mapInfo.pveHeroMode > 0 then
		mapInfo.pveHeroMode = 1
	end
	
	
	--可视范围
	mapInfo.viewRange = mapSetting.viewRange or {}
	--视点距离中心位置偏移
	mapInfo.viewOffset = mapSetting.viewOffset or {}
	mapInfo.viewOffsetPhone = mapSetting.viewOffsetPhone --这里不 "or{}"因为这个是可选项，如果不存在则使用viewOffset中的值
	
	--总波数
	mapInfo.totalWave = mapSetting.totalWave or 0
	--当前波数
	mapInfo.wave = 0
	--总生命
	mapInfo.totalLife = mapSetting.totalLife or 1
	--当前生命
	--mapInfo.life = mapSetting.totalLife or 1
	self:InitAllPlayerResource(hVar.RESOURCE_TYPE.LIFE, mapSetting.totalLife or 1)
	--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.LIFE, mapInfo.life)
	
	--当前金钱
	--mapInfo.gold = mapSetting.gold or 0
	self:InitAllPlayerResource(hVar.RESOURCE_TYPE.GOLD, mapSetting.gold or 0)
	--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, mapInfo.gold)
	
	--每回合发钱
	mapInfo.goldPerWave = mapSetting.goldPerWave or {}
	--每回合发钱的增加值（目前各个回合都增加同样的值）
	--mapInfo.goldPerWaveAdd = {}
	--for i = 1, #mapInfo.goldPerWave do
	--	mapInfo.goldPerWaveAdd[i] = 0 
	--end
	self:InitAllPlayerGoldPerWaveAdd(mapInfo.totalWave)

	--每回合发钱
	mapInfo.GetGoldPerWaveNow = function(player)
		--local gold = (mapInfo.goldPerWave[mapInfo.wave] or 0) + (mapInfo.goldPerWaveAdd[mapInfo.wave] or 0)
		local gold = (mapInfo.goldPerWave[mapInfo.wave] or 0) + (player:getGoldPerWaveAdd(mapInfo.wave))
		return gold
	end
	
	--每回合发兵时间延迟
	mapInfo.beginTimeDelayPerWave = mapSetting.beginTimeDelayPerWave or {}
	--下回合出兵时刻
	mapInfo.nextBeginTime = 0
	
	--剧情内容初始化
	mapInfo.talkScript = mapSetting.talkScript or {}
	mapInfo.talkScriptIdx = 1

	--关卡结束获得经验
	--mapInfo.exp = mapSetting.exp or 0
	mapInfo.exp = mapTab.exp or 0

	--关卡结束获得经验的增加值
	--mapInfo.expAdd = 0
	
	
	--当前关卡可使用的英雄最大数量
	mapInfo.maxHero = mapSetting.maxHero or 0
	--当前关卡可使用的战术技能卡（非塔类）最大数量
	mapInfo.maxTactics = mapSetting.maxTactics or 0
	--当前关卡可使用的塔最大数量
	mapInfo.maxTower = mapSetting.maxTower or 0
	--关卡最大金钱
	mapInfo.maxGold = mapSetting.maxGold

	--关卡奖励类型(每个星级奖励的类型) (0无, 1积分, 2战术技能卡, 3道具)
	--mapInfo.rewardType = mapSetting.rewardType or {0,0,0}
	--关卡奖励(每个星级奖励的内容)
	--mapInfo.reward = mapSetting.reward or {0,0,0}
	
	--当前关卡可获取的积分
	mapInfo.scoreV = mapTab.scoreV or 0

	--当前关卡是否在出生点复活
	mapInfo.rebirthOnBirthPoint = mapSetting.rebirthOnBirthPoint or 0

	if mapInfo.mapMode == hVar.MAP_TD_TYPE.DIFFICULT then
		if mapInfo.mapDifficulty ==  1 then
			mapInfo.scoreV = math.floor((mapInfo.scoreV or 0) * 1.1)
			mapInfo.exp = math.floor((mapInfo.exp or 0) * 1.1)
		elseif mapInfo.mapDifficulty == 2 then
			mapInfo.scoreV = math.floor((mapInfo.scoreV or 0) * 1.2)
			mapInfo.exp = math.floor((mapInfo.exp or 0) * 1.2)
		elseif mapInfo.mapDifficulty == 3 then
			mapInfo.scoreV = math.floor((mapInfo.scoreV or 0) * 1.3)
			mapInfo.exp = math.floor((mapInfo.exp or 0) * 1.3)
		end
	end
	
	----当前关卡可获取的星级奖励
	--mapInfo.starReward = mapSetting.starReward or {} --zhenkira 修改，奖励道具搬到tab表里
	--星级奖励及挑战难度的战术技能
	if mapInfo.mapMode == hVar.MAP_TD_TYPE.NORMAL  then --普通地图
		mapInfo.starReward = mapTab.starReward or {}
		mapInfo.diffTactic = nil
	elseif mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS then --无尽地图
		mapInfo.starReward = mapTab.starReward or {}
		mapInfo.diffTactic = mapTab.diffTactic or {}
	elseif mapInfo.mapMode == hVar.MAP_TD_TYPE.DIFFICULT then --难度地图
		--print("______mapInfo.mapMode1")
		local diffMode = mapTab.DiffMode
		if diffMode and diffMode[mapInfo.mapDifficulty] then
			--print("______mapInfo.mapMode2 mapInfo.mapDifficulty:",mapInfo.mapDifficulty)
			local diffInfo = diffMode[mapInfo.mapDifficulty]
			if diffInfo.starReward then
				--print("______mapInfo.mapMode3")
				mapInfo.starReward = diffInfo.starReward
			else
				--print("______mapInfo.mapMode4")
				mapInfo.starReward = nil
			end
			
			--print("______mapInfo.mapMode5")
			if diffInfo.diffTactic then
				--print("______mapInfo.mapMode6")
				mapInfo.diffTactic = diffInfo.diffTactic
			else
				--print("______mapInfo.mapMode7")
				mapInfo.diffTactic = nil
			end
		else
			--print("______mapInfo.mapMode8")
			mapInfo.starReward = nil
			mapInfo.diffTactic = nil
		end
	elseif mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP then
		mapInfo.starReward = mapTab.starReward or {}
		mapInfo.diffTactic = nil
	end

	
	--本关卡获得的星级奖励（留给界面使用）
	mapInfo.getStarReward = {}
	
	--如果都漏写了，设置最多带一个塔
	--if mapInfo.maxHero == 0 and mapInfo.maxTactics == 0 and mapInfo.maxTower == 0 then
	--	mapInfo.maxTower = 1
	--end
	
	--第一次游戏时剧情开始添加
	mapInfo.firstBeginAdd = mapSetting.firstBeginAdd or {}
	
	
	-------------------------------------------------------------------------------------v
	--发兵相关
	--怪物提示信息
	mapInfo.monsterTip = {}
	--为每一波次创建
	for i = 1, mapInfo.totalWave do
		mapInfo.monsterTip[i] = {}
		
		if mapSetting.monsterTip then
			for j = 1, #mapSetting.monsterTip do
				if mapSetting.monsterTip[j][1] == i then
					mapInfo.monsterTip[i][#mapInfo.monsterTip[i] + 1] = mapSetting.monsterTip[j][2]
				end
			end
		end
		
	end
	
	
	--初始化路线信息
	mapInfo.pathList = {}
	local pathList = mapSetting.pathList or {}
	for i = 1, #pathList do
		local path = pathList[i]
		local tmpPathList = {}
		for j = 1, #path do
			local movePoint = path[j]
			if mapInfo.allMovePointPos and mapInfo.allMovePointPos[movePoint] then
				local movePointInfo = mapInfo.allMovePointPos[movePoint]
				local pathInfo = hApi.CalculateMovePointFunction(movePointInfo)
				tmpPathList[#tmpPathList + 1] = pathInfo
			end
		end

		--生成路点
		mapInfo.pathList[#mapInfo.pathList + 1] = hApi.CalculateMovePoint(self, tmpPathList)
	end

	--初始化怪物模板信息
	mapInfo.monstTemplate = mapSetting.monstTemplate or {}

	--初始化塔基信息
	mapInfo.towerBase = mapSetting.towerBase or {}

	--初始化起点信息
	mapInfo.beginPointList = {}
	mapInfo.sendArmyState = {}	--发兵状态
	local beginPointList = mapSetting.beginPointList or {}
	
	--记录每波会出兵的出兵点
	mapInfo.showFlagInfo = {}
	for i = 1, mapInfo.totalWave do
		mapInfo.showFlagInfo[i] = {}
		for j = 1, #beginPointList do
			local beginPointTgrId = beginPointList[j]
			mapInfo.showFlagInfo[i][beginPointTgrId] = 0
		end
	end
	--地图是否支持死亡后自动提前发兵
	mapInfo.deathAutoNextWave = false
	if mapSetting.deathAutoNextWave and mapSetting.deathAutoNextWave > 0 then
		mapInfo.deathAutoNextWave = true
	end
	--地图是否采用英雄车轮战模式
	mapInfo.isWheelWar = false
	if mapSetting.isWheelWar and mapSetting.isWheelWar > 0 then
		mapInfo.isWheelWar = true
	end
	
	--地图是否采用不等待同步帧模式
	mapInfo.isNoWaitFrame = false
	if mapSetting.isNoWaitFrame and mapSetting.isNoWaitFrame > 0 then
		mapInfo.isNoWaitFrame = true
	end
	
	--地图难度是否影响出兵等级
	mapInfo.isMapDiffEnemyLv = false
	if mapSetting.isMapDiffEnemyLv and mapSetting.isMapDiffEnemyLv > 0 then
		mapInfo.isMapDiffEnemyLv = true
	end
	
	--不同难度下士兵等级
	mapInfo.mapDiffEnemyLv = {}
	if mapInfo.isMapDiffEnemyLv and mapSetting.mapDiffEnemyLv and type(mapSetting.mapDiffEnemyLv) == "table" then
		for i = 1, #mapSetting.mapDiffEnemyLv do
			mapInfo.mapDiffEnemyLv[i] = mapSetting.mapDiffEnemyLv[i] or 1
		end
	end

	--记录每个波次当前已死亡单位数量
	mapInfo.deadUnitPerWave = {}
	for i = 1, mapInfo.totalWave do
		mapInfo.deadUnitPerWave[i] = 0
	end
	--记录每波次结束后显存清理情况
	mapInfo.colectGarbageState = {}
	
	--随机出怪类型
	mapInfo.randomUnitType = {}
	local tmpRandomUnitType = mapSetting.randomUnitType or {}
	for i = 1, #tmpRandomUnitType do
		local unitType = tmpRandomUnitType[i]
		if type(unitType) == "table" then
			for j = 1, mapInfo.totalWave do
				if not mapInfo.randomUnitType[j] then
					mapInfo.randomUnitType[j] = {}
				end
				--local r = self:random(1, #unitType)
				--mapInfo.randomUnitType[j][i] = unitType[r]
				--
				--mapInfo.randomUnitType[j][i] = unitType --大菠萝，出兵的时候才随机
				--
				--geyachao: 新需求，最后一项如果是"|n"，表示这个随机组在每波开始时，只随机出n项供发兵使用
				local lastValue = unitType[#unitType] --最后一个值
				if (type(lastValue) == "number") then
					mapInfo.randomUnitType[j][i] = unitType --大菠萝，出兵的时候才随机
				elseif (type(lastValue) == "string") then
					--创建拷贝
					local unitTypeCopy = {}
					for i = 1, #unitType - 1, 1 do
						unitTypeCopy[i] = unitType[i]
					end
					local UNIT_NUM = #unitTypeCopy --数组总长度
					local randNum = tonumber(string.sub(lastValue, 2, #lastValue)) or 0
					if (randNum > 0) and (randNum <= UNIT_NUM) then --有效的参数
						--剔除的次数
						local filterCount = UNIT_NUM - randNum
						for i = 1, filterCount, 1 do
							local r = self:random(1, #unitTypeCopy)
							table.remove(unitTypeCopy, r)
						end
						mapInfo.randomUnitType[j][i] = unitTypeCopy --大菠萝，出兵的时候才随机
					else --无效的参数
						mapInfo.randomUnitType[j][i] = unitTypeCopy --大菠萝，出兵的时候才随机
					end
				end
			end
		else
			for j = 1, mapInfo.totalWave do
				if not mapInfo.randomUnitType[j] then
					mapInfo.randomUnitType[j] = {}
				end
				mapInfo.randomUnitType[j][i] = 0
			end
		end
	end

	local randomUnitList = mapSetting.randomUnitList or {}
	--遍历起点索引,整理起点信息
	for i = 1, #beginPointList do
		local beginPointTgrId = beginPointList[i]
		local tgr = self:tgrid2data(beginPointTgrId)
		local beginPos = mapInfo.allBeginPointPos[beginPointTgrId]
		--判断起点信息是否合法，type == 1表示是起点
		if tgr and tgr.pointType and tgr.pointType == 1 then
			local beginPoint = {}

			
			--出兵点标示坐标显示
			beginPoint.showPos = {x = beginPos[1], y = beginPos[2], facing = 0,}
			if tgr.showPos then
				beginPoint.showPos.x = tgr.showPos[1] or beginPos[1]
				beginPoint.showPos.y = tgr.showPos[2] or beginPos[2]
				beginPoint.showPos.facing = tgr.showPos[3] or 0
			end
			--添加用于显示的角色
			beginPoint.showUnit = self:addunit(70001,1,nil,nil,hVar.UNIT_DEFAULT_FACING,beginPoint.showPos.x,beginPoint.showPos.y)
			if beginPoint.showUnit then
				--local scale = 0.9
				--local a = CCScaleBy:create(0.35, scale, scale)
				--local a = CCMoveBy:create(0.35, ccp(10,0))
				--local aR = a:reverse()
				--local seq = tolua.cast(CCSequence:createWithTwoActions(a,aR), "CCActionInterval")
				--beginPoint.showUnit.handle.s:runAction(CCRepeatForever:create(seq))
				beginPoint.showUnit:sethide(1)
				beginPoint.showUnit.handle._n:setRotation(beginPoint.showPos.facing)
			end
			
			
			--初始化该起点每波兵的发兵状态为结束状态
			local sendArmyState = {}
			for n = 1, mapInfo.totalWave do
				sendArmyState[n] = hVar.MAP_TD_WAVE_STATE.END
			end
			
			beginPoint.beginWave = tgr.beginWave or 1 --开始波次，默认第一波开始
			beginPoint.beginStage = tgr.beginStage or 0 --开始层数，默认第0层开始
			
			--出怪信息
			beginPoint.unitPerWave = {}
			local beginWaveDelay = tgr.beginWaveDelay or {}
			local unitPerWave = {}
			--如果地图编辑了随机出怪，则取随机出怪中的信息
			if tgr.unitPerWaveRandom then
				for i = 1, math.min(#tgr.unitPerWaveRandom, mapInfo.totalWave) do
					local unitList = tgr.unitPerWaveRandom[i]
					local tmpUnitList = {}
					for j = 1, #unitList do
						local randomUnit = unitList[j]
						if randomUnit and type(randomUnit) == "string" then
							if randomUnit ~= "" then
								local parsedUnitInfo = hApi.String2Type(randomUnit, "|") or {}
								if #parsedUnitInfo > 0 then
									local rIdx = self:random(1, #parsedUnitInfo)
									local unitPollIdx = tonumber(parsedUnitInfo[rIdx]) or 0
									--todo
									if randomUnitList[unitPollIdx] then
										local unitInfo = randomUnitList[unitPollIdx]
										for k = 1, #unitInfo do
											tmpUnitList[#tmpUnitList + 1] = unitInfo[k]
										end
									end
								end
							else
								tmpUnitList[#tmpUnitList + 1] = ""
							end
						end
					end
					unitPerWave[#unitPerWave + 1] = tmpUnitList
				end
			else
				unitPerWave = tgr.unitPerWave or {}
			end
			
			for i = 1, #unitPerWave do
				local waveNow = beginPoint.beginWave - 1 + i
				local tmpWaveNow = {}
				tmpWaveNow.delay = tonumber(beginWaveDelay[i]) or 0 --每波开始延时
				tmpWaveNow.beginTime = 0 --设置波次开始时间为0
				tmpWaveNow.unitInfoList = {}
				local wave = unitPerWave[i]
				if type(wave) == "table" then
					for j = 1, #wave do
						local unitInfos = wave[j]
						local tmpUnitInfo = {}
						tmpUnitInfo.beginPos = hApi.CalculateMovePointFunction(beginPos)	--初始位置
						tmpUnitInfo.beginTime = 0			--开始时间
						tmpUnitInfo.path = 1				--路点
						tmpUnitInfo.formation = 1			--阵型
						tmpUnitInfo.nextDelay = 0			--下一波延迟
						tmpUnitInfo.perUnitDelay = 0			--每个单位延迟
						tmpUnitInfo.unitList = {}			--单位列表
						--开始解析unitInfo
						local parsedUnitInfo = hApi.String2Type(unitInfos, "|") or {}
						for k = 1, #parsedUnitInfo do
							if k == 1 then
								--tmpUnitInfo.path = tonumber(parsedUnitInfo[k]) or 1
								tmpUnitInfo.path = parsedUnitInfo[k]
							elseif k == 2 then
								tmpUnitInfo.formation = tonumber(parsedUnitInfo[k]) or 1
							elseif k == 3 then
								tmpUnitInfo.nextDelay = tonumber(parsedUnitInfo[k]) or 0
							elseif k == 4 then
								tmpUnitInfo.perUnitDelay = tonumber(parsedUnitInfo[k]) or 0
							else
								local parsedAllUnit = hApi.String2Type(parsedUnitInfo[k], "_")
								for n = 1, #parsedAllUnit do
									local tmpUnitTab = hApi.String2Type(parsedAllUnit[n], "*") or {}
									if tmpUnitTab and tmpUnitTab ~= {} then
										local unitObj = {}
										local uId = tmpUnitTab[1]
										local _,_,rUIdx = string.find(uId, "&(%d+)")
										
										if rUIdx then
											local rIdx = tonumber(rUIdx)
											unitObj.id = mapInfo.randomUnitType[waveNow][rIdx] or 0
										else
											unitObj.id = tonumber(tmpUnitTab[1]) or 0
										end
										
										unitObj.num = tonumber(tmpUnitTab[2]) or 0
										local force = tonumber(tmpUnitTab[3]) or 2
										if force == 0 then
											force = hVar.FORCE_DEF.SHU
										end
										local forcePlayer = self:GetForce(force)
										if forcePlayer then
											unitObj.owner = forcePlayer:getpos()
										else
											if force == hVar.FORCE_DEF.SHU then
												unitObj.owner = 21
											elseif force == hVar.FORCE_DEF.WEI then
												unitObj.owner = 22
											elseif force == hVar.FORCE_DEF.NEUTRAL then
												unitObj.owner = 23
											elseif force == hVar.FORCE_DEF.NEUTRAL_ENEMY then
												unitObj.owner = 24
											end
										end
										
										--if unitObj.id > 0 and unitObj.num > 0 then
										if (unitObj.num > 0) then
											--table.insert(tmpUnitInfo.unitList, 1, unitObj) --大菠萝，每个单独随机
											for n = 1, unitObj.num, 1 do
												local unitObjCopy = {}
												for k, v in pairs(unitObj) do
													unitObjCopy[k] = v
												end
												if (type(unitObjCopy.id) == "table") then
													local r = self:random(1, #unitObjCopy.id)
													unitObjCopy.id = unitObjCopy.id[r]
												end
												unitObjCopy.num = 1
												
												table.insert(tmpUnitInfo.unitList, 1, unitObjCopy)
											end
											
											--每个波次当前起点发兵总数
											mapInfo.showFlagInfo[waveNow][beginPointTgrId] = mapInfo.showFlagInfo[waveNow][beginPointTgrId] + (unitObj.num or 0)
										end
									end
								end
							end
							
						end
						table.insert(tmpWaveNow.unitInfoList, 1, tmpUnitInfo) --注意这里是反向插入，因为遍历的时候要从末尾删除
					end
				end
				table.insert(beginPoint.unitPerWave, tmpWaveNow)
				
				--如果有角色，设置该起点该波次状态为begin
				if tmpWaveNow.unitInfoList ~= {} then
					sendArmyState[waveNow] = hVar.MAP_TD_WAVE_STATE.BEGIN
				end
			end
			mapInfo.beginPointList[beginPointTgrId] = beginPoint
			mapInfo.sendArmyState[beginPointTgrId] = sendArmyState
		end
	end

	------------------------------------------------金钱怪特殊处理-------------------------------------------------------
	--金钱怪出现几率（目前10％）
	local goldMonsterFlag = false --本次是否出金钱怪
	local isFinish03 = LuaGetPlayerMapAchi("world/td_003_tflw", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --是否通关第三关
	
	--通关第三关才会出金钱怪、非pvp模式
	if (isFinish03 == 1 and mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP) then
		--hVar.GOLDUNIT_PROBALITY = 100 --test 金钱怪概率100
		if (hApi.random(1, 100) <= hVar.GOLDUNIT_PROBALITY) then
			goldMonsterFlag = true
		end
	end
	
	--如果出金钱怪，则遍历出兵点，进行随机
	if goldMonsterFlag then
		--所有出兵队列
		local tmp = {}
		local printtmp = {}
		--遍历所有出兵队列，如果出兵队列中有中立怪3则不作为出兵序列
		for bpTgrId,bpInfo in pairs(mapInfo.beginPointList) do
			if bpInfo.unitPerWave then
				for i = 1, #bpInfo.unitPerWave do
					local waveNow = bpInfo.beginWave + i - 1
					local unitPerWave = bpInfo.unitPerWave[i]
					--最后三波肯定不出木牛
					if waveNow <= math.max((mapInfo.totalWave - 3),3) and unitPerWave and unitPerWave.unitInfoList then
						for j = 1, #unitPerWave.unitInfoList do
							local unitInfo = unitPerWave.unitInfoList[j]
							if unitInfo and unitInfo.path and mapInfo.pathList[unitInfo.path] and unitInfo.unitList and type(unitInfo.unitList) == "table" and #unitInfo.unitList > 0 then
								local flag = true
								for k = 1, #unitInfo.unitList do
									local unit = unitInfo.unitList[k]
									if unit.owner ~= 22 then
										flag = false
										--print("%%%%%%%%%%%%%%%%%DSFSKGJGOJSOIDFJSO break",bpTgrId,waveNow,j)
										break
									end
								end
								if flag then
									tmp[#tmp + 1] = unitInfo.unitList
									printtmp[#printtmp + 1] = {bpTgrId,waveNow,j}
									--print("%%%%%%%%%%%%%%%%%DSFSKGJGOJSOIDFJSO init",bpTgrId,waveNow,j)
								end
							end
						end
					end
				end
			end
		end
		
		if #tmp > 0 then
			local rIdx = hApi.random(1, #tmp)
			local targetUnitList = tmp[rIdx]
			if targetUnitList and type(targetUnitList) == "table" then 
				if #targetUnitList > 0 then
					local rUnitIdx = hApi.random(1, #targetUnitList) or 1
					if rUnitIdx > #targetUnitList then
						rUnitIdx = 1
					end
					table.insert(targetUnitList, rUnitIdx, {id = 15035, num = 1, owner = 22})
					for k = 1, #targetUnitList do
						local unit = targetUnitList[k]
						print("muniu unit:",unit.id,unit.num,unit.owner)
					end
					--print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%DSFSKGJGOJSOIDFJSOIOIGNIGN:",printtmp[rIdx][1],printtmp[rIdx][2],printtmp[rIdx][3])
				else
					table.insert(targetUnitList, {id = 15035, num = 1, owner = 22})
					for k = 1, #targetUnitList do
						local unit = targetUnitList[k]
						print("muniu unit:",unit.id,unit.num,unit.owner)
					end
					--print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%DSFSKGJGOJSOIDFJSOIOIGNIGN why why:",printtmp[rIdx][1],printtmp[rIdx][2],printtmp[rIdx][3])
				end
			end
		end
	end

	------------------------------------------------金钱怪特殊处理-------------------------------------------------------
	--zhenkira todo 测试代码
	if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
		
		--英雄随机路线
		mapInfo.heroRandomRoad = 
		{
			{
				{x = 756, y = 252, isHide = 0},
				{x = 612, y = 348, isHide = 0},
				{x = 468, y = 516, isHide = 0},
				{x = 420, y = 852, isHide = 0},
			},
			{
				{x = 1044, y = 516, isHide = 0},
				{x = 972, y = 636, isHide = 0},
				{x = 780, y = 780, isHide = 0},
				{x = 420, y = 852, isHide = 0},
			},
		}
		
		--zhenkira pvpui pvp倒计时
		----游戏结束时间
		--mapInfo.gameTimeLimit = 0
		
		--游戏主营
		--mapInfo.gameCamp = 
		--{
		--	--势力1
		--	[0] = {
		--		{tgrId = 48, defeat = false},
		--	},	
		--	--势力1
		--	[1] = {
		--		{tgrId = 48, defeat = false},
		--	},
		--	--势力2
		--	[2] = {
		--		{tgrId = 47, defeat = false},
		--	},
		--}
	--else
	--	if mapSetting.gameCamp and type(mapSetting.gameCamp) == "table" then
	--		mapInfo.gameCamp = {}
	--		for i = 1, #(mapSetting.gameCamp) do
	--			local tgrIdList = mapSetting.gameCamp[i]
	--			mapInfo.gameCamp[i - 1] = {}
	--			for j = 1, #tgrIdList do
	--				mapInfo.gameCamp[i - 1][j] = {tgrId = tgrIdList[j], defeat = false}
	--			end
	--		end
	--	end
	end

	if mapSetting.gameCamp and type(mapSetting.gameCamp) == "table" then
		mapInfo.gameCamp = {}
		for i = 1, #(mapSetting.gameCamp) do
			local tgrIdList = mapSetting.gameCamp[i]
			mapInfo.gameCamp[i - 1] = {}
			for j = 1, #tgrIdList do
				mapInfo.gameCamp[i - 1][j] = {tgrId = tgrIdList[j], defeat = false}
			end
		end
	end
	
	if mapSetting.escapeWin and type(mapSetting.escapeWin) == "table" then
		mapInfo.escapeWin = {}
		for i = 1, #(mapSetting.escapeWin) do
			local typeIdList = mapSetting.escapeWin[i]
			mapInfo.escapeWin[i - 1] = {}
			for j = 1, #typeIdList do
				mapInfo.escapeWin[i - 1][j] = {typeId = typeIdList[j], escape = false}
			end
		end
	end
	
	--清空触发器提供的初始数据
	mapInfo.mapSetting = nil
	mapInfo.allMovePointPos = nil
	mapInfo.allBeginPointPos = nil
	
	----初始化结束设置游戏局开始 先注释掉，由load界面来发起状态改变
	--mapInfo.mapState = hVar.MAP_TD_STATE.BEGIN
	mapInfo.mapState = hVar.MAP_TD_STATE.INIT
end

local __LoadAllChaOnMap = function()
	local self = __self
	local unitList = __unitList
	local triggerData = type(__triggerData)=="table" and __triggerData or nil
	local codeOnCreate = type(__codeOnCreate)=="function" and __codeOnCreate or nil
	if type(self)~="table" or self.ID==0 or type(unitList)~="table" then
		return
	end
	local worldScene
	if self.handle and type(self.handle.worldScene)=="userdata" then
		worldScene = self.handle.worldScene
		--清除地图上单位使用的编辑器ID
		xlScene_ClearUniqueID(self.handle.worldScene)
	end
	local convertedDataTab
	if triggerData~=nil then
		if type(triggerData.__convertedTab)=="table" then
			convertedDataTab = triggerData.__convertedTab
		else
			convertedDataTab = {}
			for k,v in pairs(triggerData)do
				if v.uniqueID~=nil then
					triggerData[k] = 0
					convertedDataTab[v.uniqueID] = v
				end
			end
			triggerData.__convertedTab = convertedDataTab
		end
	end
	local d = self.data
	if unitList~=nil then
		local IsInitQuest = 0
		--未初始化任务的状态
		if d.QuestList==0 then
			d.QuestList = {}
			--仅3难度以上允许额外奖励任务
			--if d.type=="worldmap" and hVar.MAP_INFO[d.map] then
			--	local default_diff = 3
			--	if hVar.MAP_INFO[d.map].default_diff then
			--		default_diff = hVar.MAP_INFO[d.map].default_diff
			--	end
			--	if self.data.MapDifficulty==0 or self.data.MapDifficulty>= default_diff then
					IsInitQuest = 1
			--	end
			--end
		end
		local tempWorldParam = {}
		local tempHero = {}
		local tempTown = {}
		for i = 1,#unitList do
			local tgrDataU
			local unitType,id,owner,worldX,worldY,facing,triggerID
			if #unitList[i]==7 then
				unitType,id,owner,worldX,worldY,facing,triggerID = unpack(unitList[i])
			else
				id,owner,worldX,worldY,facing,triggerID = unpack(unitList[i])
			end
			if convertedDataTab~=nil and triggerID~=nil and triggerID~=0 then
				tgrDataU = convertedDataTab[triggerID]
				if tgrDataU then
					d.triggerIndex[triggerID] = {0,0,tgrDataU}
				end
			end
			----编辑器加出来的单位,要用这种东西在加回去编辑器才能认
			local c,u
			--如果表项中不存在此id的单位，直接就不加载
			--print("unitType=", unitType)
			if unitType==hVar.UNIT_TYPE.ITEM then
				--如果类型是道具，那么走特殊流程
				if hVar.tab_item[id] then
					hApi.addItemByID(self,owner,id,worldX,worldY,facing)
				end
			else
				if unitType==hVar.UNIT_TYPE.SCEOBJ and hVar.OPTIONS.IS_NO_SCEOBJ==1 then
					--无场景物件模式不加载场景物件
				elseif unitType==hVar.UNIT_TYPE.PLAYER_INFO then
					if g_editor == 1 then
						--玩家参数专用单位单位
						if triggerID and triggerID~=0 then
							self.data.PlayerInfoTgrID[owner] = triggerID
						end
						--如果地图类型是Td则初始化TD对战信息
						if hVar.MAP_INFO[d.map].mapType and hVar.MAP_INFO[d.map].mapType == 4 and tgrDataU then
							self.data.tdMapInfo.mapSetting = tgrDataU
							--self.data.tdMapInfo.mapState = hVar.MAP_TD_STATE.INIT
							--self.data.tdMapInfo.heroBornPoint = {x = worldX,y = worldY,facing = facing}
						end
						local ec = hApi.addChaByID(self,owner,id,worldX,worldY,facing,nil,{hint=hint,triggerID=triggerID,editorID = id,indexOfCreate = i})
						local eu = hApi.findUnitByCha(ec)
						if tgrDataU~=nil and worldScene then
							hApi.chaSetUniqueID(eu.handle,triggerID,worldScene)
						end
					else
						--玩家信息现在变成了地图配置信息，然后作为上帝存在
						local ownerEx = 0
						
						--玩家参数专用单位单位
						if triggerID and triggerID~=0 then
							self.data.PlayerInfoTgrID[ownerEx] = triggerID
						end
						
						--如果地图类型是Td则初始化TD对战信息
						if hVar.MAP_INFO[d.map].mapType and hVar.MAP_INFO[d.map].mapType == 4 and tgrDataU then
							self.data.tdMapInfo.mapSetting = tgrDataU
							--self.data.tdMapInfo.mapState = hVar.MAP_TD_STATE.INIT
							--self.data.tdMapInfo.heroBornPoint = {x = worldX,y = worldY,facing = facing}
						end
						
						
						
						
						
						local godPlayer = self:GetPlayerGod()
						if godPlayer and not godPlayer:getgod() then
							local name = "god_0"
							local ec = hApi.addChaByID(self,ownerEx,id,worldX,worldY,facing,nil,{name = name,hint=hint,triggerID=triggerID,editorID = id,indexOfCreate = i})
							local eu = hApi.findUnitByCha(ec)
							if eu then
								
								--设置单位触发器ID
								if tgrDataU~=nil and worldScene then
									hApi.chaSetUniqueID(eu.handle,triggerID,worldScene)
								end
								
								godPlayer:setgod(eu)
								eu:sethide(1)
							end
						end
					end
					

				elseif unitType==hVar.UNIT_TYPE.WAY_POINT then
					
					if g_editor==1 then
						local name = "god_"..owner
						local ec = hApi.addChaByID(self,owner,id,worldX,worldY,facing,nil,{name=name,hint=hint,triggerID=triggerID,editorID = id,indexOfCreate = i})
						local eu = hApi.findUnitByCha(ec)
						--设置单位触发器ID
						if tgrDataU~=nil and worldScene then
							hApi.chaSetUniqueID(eu.handle,triggerID,worldScene)
						end
					else
						--如果地图类型是Td则初始化TD对战信息
						if hVar.MAP_INFO[d.map] and hVar.MAP_INFO[d.map].mapType and hVar.MAP_INFO[d.map].mapType == 4 and tgrDataU then
							if tgrDataU.pointType == 0 then --普通路点
								if not self.data.tdMapInfo.allMovePointPos then
									self.data.tdMapInfo.allMovePointPos = {}
								end
								self.data.tdMapInfo.allMovePointPos[triggerID] = {worldX, worldY, tgrDataU.angle, tgrDataU.rangeRadius, nil, tgrDataU.isHide}
							elseif tgrDataU.pointType == 1 then --出兵点
								if not self.data.tdMapInfo.allBeginPointPos then
									self.data.tdMapInfo.allBeginPointPos = {}
								end
								self.data.tdMapInfo.allBeginPointPos[triggerID] = {worldX, worldY, tgrDataU.angle, tgrDataU.rangeRadius, tgrDataU.defaultFacing, tgrDataU.isHide}
							elseif tgrDataU.pointType == 2 then --英雄出生点
								local player = self:GetPlayer(owner)
								if player and not player:getgod() then
									local name = "god_"..owner
									
									--大菠萝，英雄出生点读填表值，没填默认超上
									if tgrDataU.angle then
										facing = tgrDataU.angle
									else
										facing = 0
									end
									
									local ec = hApi.addChaByID(self,owner,id,worldX,worldY,facing,nil,{name = name, hint=hint,triggerID=triggerID,editorID = id,indexOfCreate = i})
									local eu = hApi.findUnitByCha(ec)
									if eu then
										eu:sethide(1)
										player:setgod(eu)
									end
								end
							elseif tgrDataU.pointType == 3 then --野怪点
								local name = "wildpoint_"..triggerID
								local ec = hApi.addChaByID(self,owner,id,worldX,worldY,facing,nil,{name = name, hint=hint,triggerID=triggerID,editorID = id,indexOfCreate = i})
								local eu = hApi.findUnitByCha(ec)
								if eu then
									eu:sethide(1)
									eu:WildInit()
								end
								if not self.data.tdMapInfo.wildPoint then
									self.data.tdMapInfo.wildPoint = {}
								end
								self.data.tdMapInfo.wildPoint[#self.data.tdMapInfo.wildPoint + 1] = eu
							elseif tgrDataU.pointType == 4 then --传送门
								
								if not self.data.tdMapInfo.portal then
									self.data.tdMapInfo.portal = {}
									self.data.tdMapInfo.portalFinishState = {} --某层是否已传送过
								end
								local searchRadius = tgrDataU.searchRadius or 100

								local startConditionType = tonumber(tgrDataU.startConditionType) or 0
								local startCondition = {}
								local tStarCondition = hApi.Split(tgrDataU.startCondition or "",";")
								--print("startCondition:",startCondition,tgrDataU.startCondition,#tStarCondition)
								for i = 1, #tStarCondition do
									local c = hApi.Split(tStarCondition[i] or "", ":")
									--print(""..abc)
									if c and c[1] and c[1] ~= "" then
										if string.upper(c[1]) == "KILL" then
											startCondition[#startCondition + 1] = {c[1], tonumber(c[2]) or 2, tonumber(c[3]) or 0, tonumber(c[4]) or 1}
										elseif string.upper(c[1]) == "WAVE" then
											startCondition[#startCondition + 1] = {c[1], tonumber(c[2]) or 0}
										elseif string.upper(c[1]) == "GAMETIME" then
											startCondition[#startCondition + 1] = {c[1], tonumber(c[2]) or 0}
										elseif string.upper(c[1]) == "COMBATEVA" then
											startCondition[#startCondition + 1] = {c[1], tonumber(c[2]) or 0}
										end
									end
								end

								local portalType = tgrDataU.portalType or 0
								local moveToWhere = tgrDataU.moveToWhere or {}
								local toX, toY, toMap
								if tonumber(portalType) == 0 then
									toX = moveToWhere[1] or worldX
									toY = moveToWhere[2] or worldY
								elseif tonumber(portalType) == 1 then
									toMap = moveToWhere[1] or ""
									if toMap ~= "" then
										toMap = "world/" .. toMap
									end
								end

								local viewReset
								if tgrDataU.viewReset and type(tgrDataU.viewReset) == "table" then
									viewReset = {}
									local w,h = self.data.sizeW,self.data.sizeH
									--right
									viewReset[1] = math.max(w - ((tgrDataU.viewReset[1] or 0) + (tgrDataU.viewReset[3] or 0)),0)
									--left
									viewReset[2] = tgrDataU.viewReset[1] or 0
									--up
									viewReset[3] = tgrDataU.viewReset[2] or 0
									--bottom
									viewReset[4] =math.max(h - ((tgrDataU.viewReset[2] or 0) + (tgrDataU.viewReset[4] or 0)),0)
								end
								local ec = hApi.addChaByID(self,owner, (tgrDataU.modelUnit or 19),worldX,worldY,facing,nil,{name = name, hint=hint,triggerID=triggerID,editorID = id,indexOfCreate = i})
								--print("hApi.addChaByID", tgrDataU.modelUnit, worldX,worldY)
								local eu = hApi.findUnitByCha(ec)
								if (eu == nil) then --尝试找场景物件
									eu = hApi.findSceobjByCha(ec)
								end
								if eu then
									eu:sethide(1)
									--eu.handle.s:setVisible(false)
									--eu.handle._n:setVisible(false)
								end
								
								local enterMusic = tgrDataU.enterMusic or "" --传送后背景音乐
								local bBeginInside = false --初始是否已经在传送门里（如果初始已经在，需要先出来再进去才能触发传送）
								self.data.tdMapInfo.portal[#self.data.tdMapInfo.portal + 1] = {x = worldX, y = worldY, owner = owner, searchRadius = searchRadius, startConditionType = startConditionType, startCondition = startCondition, portalType = portalType, toX = toX, toY = toY, toMap = toMap, isShow = false, eu = eu,viewReset = viewReset, enterMusic = enterMusic, bBeginInside = bBeginInside,}
								
							elseif tgrDataU.pointType == 5 then --区域触发
								if not self.data.tdMapInfo.areatrigger then
									self.data.tdMapInfo.areatrigger = {}
								end
								
								local areaTriggerRadius = tgrDataU.areaTriggerRadius or 100 --区域触发半径
								
								local areaTriggerEnterCount = tgrDataU.areaTriggerEnterCount or 0 --进入区域触发次数
								if (areaTriggerEnterCount < 0) then
									areaTriggerEnterCount = math.huge
								end
								local areaTriggerEnterSkillId = tgrDataU.areaTriggerEnterSkillId or 0 --进入区域触发技能id
								local areaTriggerEnterMusic = tgrDataU.areaTriggerEnterMusic or "" --进入区域触发背景音乐
								local areaTriggerEnterIsBoss = tgrDataU.areaTriggerEnterIsBoss or 0 --进入区域是否是BOSS
								
								local areaTriggerLeaveCount = tgrDataU.areaTriggerLeaveCount or 0 --离开区域触发次数
								if (areaTriggerLeaveCount < 0) then
									areaTriggerLeaveCount = math.huge
								end
								local areaTriggerLeaveSkillId = tgrDataU.areaTriggerLeaveSkillId or 0 --离开区域触发技能id
								local areaTriggerLeaveMusic = tgrDataU.areaTriggerLeaveMusic or "" --离开区域触发背景音乐
								
								self.data.tdMapInfo.areatrigger[#self.data.tdMapInfo.areatrigger + 1] =
								{
									areaTriggerRadius = areaTriggerRadius, --区域触发半径
									areaTriggerWorldX = worldX, --区域点坐标x
									areaTriggerWorldY = worldY, --区域点坐标y
									
									areaTriggerEnterCount = areaTriggerEnterCount, --进入区域触发次数
									areaTriggerEnterSkillId = areaTriggerEnterSkillId, --进入区域触发技能id
									areaTriggerEnterMusic = areaTriggerEnterMusic, --进入区域触发背景音乐
									areaTriggerEnterIsBoss = areaTriggerEnterIsBoss, --进入区域是否是BOSS
									
									areaTriggerLeaveCount = areaTriggerLeaveCount, --离开区域触发次数
									areaTriggerLeaveSkillId = areaTriggerLeaveSkillId, --离开区域触发技能id
									areaTriggerLeaveMusic = areaTriggerLeaveMusic, --离开区域触发背景音乐
									
									areaTriggerEnterFinishCount = 0, --进入区域触发完成的次数
									areaTriggerLeaveFinishCount = 0, --离开区域触发完成的次数
									
									areaTriggerFinishState = false, --区域触发当前状态(true:在区域里 /false:不在区域里)
								}
								
							end
						end
						
						--毫无作用的数据结构
						--self.data.waypoint[#self.data.waypoint+1] = {tgrDataU.name or i,worldX,worldY}
					end
				elseif (unitType == hVar.UNIT_TYPE.GROUP) and (g_editor ~= 1) then --组
					if (g_editor ~= 1) then --非编辑器模式
						local group = hVar.tab_unit[id] and hVar.tab_unit[id].group
						if group then
							local nShareType = 0
							local t_MSGroup = self.data.mapShareGroup
							if type(group.shareGroup) == "number" then
								-- 类型1 同ID只随1次	2019/04/22 新增
								if group.shareGroup == 1 then
									nShareType = 1
								-- 类型2 同共同组id（shareGroupId）只取1次序号 以便风格统一 2019/05/10 新增
								elseif group.shareGroup == 2 then
									nShareType = 2
								end
							end
							--{"xx",11221,11225,1},
							local randgroup = self:random(1, #group)
							--共享类型1  该id只随一次组
							if nShareType == 1 then
								if type(t_MSGroup[id]) ~= "number" then
									t_MSGroup[id] = randgroup
								else
									randgroup = t_MSGroup[id]
								end
							end
							local group1 = group[randgroup]
							local maxnum = group1[#group1]
							local num = 0
							while (num < maxnum) do
								local randIdx = self:random(2, #group1 - 1)
								local randId = group1[randIdx]
								num = num + 1
								
								--共享类型2 该id在共享id组里 只随1个序号
								if nShareType == 2 then
									local nShareGroupId = group.shareGroupId or 0
									if type(t_MSGroup[nShareGroupId]) == "number" then
										local randIdx = t_MSGroup[nShareGroupId]
										randId = group1[randIdx]
									else
										t_MSGroup[nShareGroupId] = randIdx
									end
								end
								
								--有效的单位id
								if (randId > 0) then
									local name,hint
									if tgrDataU then
										name = hApi.ConvertMapString(tgrDataU.name,1)
										hint = hApi.ConvertMapString(tgrDataU.name,2)
									end
									local IsHide
									local nMapScorePec
									if tgrDataU~=nil then
										if tgrDataU.IsHide==1 then
											IsHide = 1
										end
										if type(tgrDataU.MapScorePec)=="number" then
											nMapScorePec = tgrDataU.MapScorePec
										end
									end
									--print("-----------------GROUP", owner,randId,worldX,worldY,facing)
									local tabU = hVar.tab_unit[randId]
									if tabU then
										--可破坏物件、可破坏房子
										if (tabU.type == hVar.UNIT_TYPE.UNITBROKEN) or (tabU.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE)
										or (tabU.type == hVar.UNIT_TYPE.UNITDOOR) then
											owner = 23
											
											--设置到24的整数倍的位置
											worldX = math.floor(worldX / hVar.ROLE_COLLISION_EDGE) * hVar.ROLE_COLLISION_EDGE
											worldY = math.floor(worldY / hVar.ROLE_COLLISION_EDGE) * hVar.ROLE_COLLISION_EDGE
											
											--可破坏物件有几率变别的单位
											if (randId == hVar.UNITBROKEN_STONE_ORINGIN_ID) then
												local r = self:random(1, 100)
												if (r <= hVar.UNITBROKEN_STONE_PROBABLITY) then
													randId = hVar.UNITBROKEN_STONE_CHANGETO_ID
												end
											end
											u = self:addunit(randId, owner, nil, nil, facing, worldX, worldY)
											--print("添加可破坏物件", randId, owner, facing, worldX, worldY)
											
											--生成随机可破坏物件的四周物件
											--self:_addBlockArount(u)
										else
											c = hApi.addChaByID(self,owner,randId,worldX,worldY,facing,nil,{name=name,hint=hint,triggerID=triggerID,editorID = randId,indexOfCreate = i,IsHide = IsHide,mapScorePec = nMapScorePec})
											u = hApi.findUnitByCha(c)
											
											--动态创建的区域单位，z值更大一点
											if u~=nil then
												--场景物件，强制设置z值为3
												
												if (tabU.type == hVar.UNIT_TYPE.NOT_USED) then
													xlChaSetZOrderOffset(c, 3-worldY)
													--print(tabU and tabU.name, worldY, 2-worldY)
												end
											end
										end
									end
								end
							end
						end
					end
				elseif hVar.tab_unit[id] then
					local name,hint
					if tgrDataU then
						name = hApi.ConvertMapString(tgrDataU.name,1)
						hint = hApi.ConvertMapString(tgrDataU.name,2)
					end
					local IsHide
					local nMapScorePec
					if tgrDataU~=nil then
						if tgrDataU.IsHide==1 then
							IsHide = 1
						end
						if type(tgrDataU.MapScorePec)=="number" then
							nMapScorePec = tgrDataU.MapScorePec
						end
					end
					--print("-----------------__LoadAllChaOnMap", owner,id,worldX,worldY,facing)
					c = hApi.addChaByID(self,owner,id,worldX,worldY,facing,nil,{name=name,hint=hint,triggerID=triggerID,editorID = id,indexOfCreate = i,IsHide = IsHide,mapScorePec = nMapScorePec})
					u = hApi.findUnitByCha(c)
				end
			end
			if u~=nil then
				local TeamSlotPlus = 0
				local tabU = hVar.tab_unit[id]
				local oHero
				--世界地图上的英雄将被记录为可用英雄
				if tabU~=nil and d.type=="worldmap" then
					if tabU.type==hVar.UNIT_TYPE.HERO then
						--[[
						--geyachao: TD初始添加的英雄单位不需要绑定heroobj
						local player = self:GetPlayer(owner)
						if player then
							oHero = player:createhero(id)
							if oHero then
								oHero:bind(u)
							end
						end
						]]
						
						--oHero = hClass.hero:new({
						--	name = hVar.tab_stringU[id][1],
						--	id = id,
						--	owner = owner,
						--	unit = u,
						--	CreatedOnMapInit = 1,
						--})
					--elseif tabU.type==hVar.UNIT_TYPE.BUILDING and u.data.townID~=0 then
					--	--主城默认会有兵槽
					--	--u.data.team = hApi.InitUnitTeam()
					end
				end
				--加载触发器数据
				if tgrDataU~=nil then
					--设置单位触发器ID
					if worldScene then
						hApi.chaSetUniqueID(u.handle,triggerID,worldScene)
					end
					--世界地图特殊处理
					if d.type=="worldmap" then
						if tgrDataU.MovePointIdx then
							u:setRoadPoint(tgrDataU.MovePointIdx, hVar.TD_DEPLOY_TYPE.ONE_POINT_CENTER)
						end

--						--加载单位任务
--						if IsInitQuest==1 then
--							--可重复完成任务
--							if type(tgrDataU.quest)=="table" then
--								local q = tgrDataU.quest
--								local UniqueQuestID = 0
--								local text = q[1]
--								local nMin = 0
--								local nMax = 1
--								local tUnique = {u.ID,u.__ID,u.data.id,triggerID,UniqueQuestID,0}
--								local tQuest = {1,nMin,nMax,tUnique,text}
--								--非首杀任务只能奖励物品！
--								tUnique[6] = "item"
--								for i = 2,#q do
--									if type(q[i])=="number" then
--										tQuest[#tQuest+1] = q[i]
--									end
--								end
--								if #tQuest>=6 then
--									d.QuestList[#d.QuestList+1] = tQuest
--								end
--							end
--							--首杀任务
--							if type(tgrDataU.UniqueQuest)=="table" and type(tgrDataU.UniqueQuestID)=="number" and hVar.ACHIEVEMENT_TYPE["UNIQUE_QUEST_"..tgrDataU.UniqueQuestID]~=nil then
--								local q = tgrDataU.UniqueQuest
--								local UniqueQuestID = tgrDataU.UniqueQuestID
--								local IsCompleted = LuaGetPlayerMapAchi(d.map,hVar.ACHIEVEMENT_TYPE["UNIQUE_QUEST_"..UniqueQuestID])
--								--0才允许获得此任务,或者测试模式打开(测试模式即使打开，显示可以完成的话，也不能获得任务奖励)
--								if IsCompleted==0 or hVar.OPTIONS.TEST_UNIQUE_QUEST==1 then
--									local text = q[1]
--									local nMin = 0
--									local nMax = 1
--									local tUnique = {u.ID,u.__ID,u.data.id,triggerID,UniqueQuestID,0}
--									local tQuest = {1,nMin,nMax,tUnique,text}
--									--首杀任务可以奖励一些奇怪的东西
--									if type(q[2])=="string" then
--										tUnique[6] = q[2]
--										for i = 3,#q do
--											if type(q[i])=="number" then
--												tQuest[#tQuest+1] = q[i]
--											end
--										end
--									else
--										tUnique[6] = "item"
--										for i = 2,#q do
--											if type(q[i])=="number" then
--												tQuest[#tQuest+1] = q[i]
--											end
--										end
--									end
--									if #tQuest>=6 then
--										d.QuestList[#d.QuestList+1] = tQuest
--									end
--								end
--							end
--						end
					end
--					--英雄处理
--					if oHero and d.type=="worldmap" then
--						oHero:loadtriggerdata(tgrDataU)
--						if type(tgrDataU.sortIndex)=="number" then
--							tempHero[#tempHero+1] = {oHero,tgrDataU.sortIndex}
--						end
--						if type(tgrDataU.BornMount)=="number" then
--							oHero:setGameVar("_MOUNT",tgrDataU.BornMount)
--						end
--					end
				end
--				if tgrDataU~=nil and u:gettown()~=nil then
--					tempTown[#tempTown+1] = {u,tgrDataU}
--				end
				hGlobal.event:call("Event_UnitBorn",u)
				if codeOnCreate~=nil then
					codeOnCreate(u,i,triggerID)
				end
			end
		end

		--如果是TD地图，转换角色路点信息
		--if hVar.MAP_INFO[d.map] and hVar.MAP_INFO[d.map].mapType and hVar.MAP_INFO[d.map].mapType == 4 then
		if g_editor ~= 1 then
			__InitTDMapInfo()
		end
		--end
		
		--遍历所有单位，setlevel
		local mapInfo = self.data.tdMapInfo
		local lv = 1
		local diff = self.data.MapDifficulty
		if mapInfo.isMapDiffEnemyLv then
			lv = mapInfo.mapDiffEnemyLv[diff] or 1
			--print("TD_Invasion_Loop lv:",diff,lv)
			
			--遍历地图上的编辑器放置已有的单位，设置等级
			self:enumunit(function(eu)
				if (eu.data.type == hVar.UNIT_TYPE.UNIT) or (eu.data.type==hVar.UNIT_TYPE.HERO) then
					eu:SetLevel(lv)
				end
			end)
		end
		
		----如果任何城镇拥有任何守卫者，且是英雄单位，则直接设置为守城英雄
		--if #tempTown>0 then
		--	for i = 1,#tempTown do
		--		local oBuilding,tD = tempTown[i][1],tempTown[i][2]
		--		if oBuilding.ID>0 and tD.guard~=nil then
		--			local gIndex = 0
		--			for i = 1,#tD.guard do
		--				local gu = self:tgrid2unit(tD.guard[i])
		--				if gu~=nil and gu:gethero()~=nil then
		--					gIndex = i
		--					break
		--				end
		--			end
		--			if gIndex>0 then
		--				local gu = self:tgrid2unit(tD.guard[gIndex])
		--				--if #tD.guard==1 then
		--					--tD.guard = nil
		--				--else
		--					--tD.guard[gIndex] = 0
		--				--end
		--				if gu and gu:getowner() then
		--					--设置单位为城镇的守卫
		--					oBuilding:gettown():setguard(gu)
		--				end
		--			end
		--		end
		--	end
		--end
		--如果英雄优先级需要排序(仅世界地图有效)
		if #tempHero>0 and d.type=="worldmap" then
			local tabP = {}
			for i = 1,#tempHero do
				local oHero = tempHero[i][1]
				local p = oHero.data.owner
				if tabP[p]==nil then
					tabP[p] = {}
				end
				tabP[p][#tabP[p]+1] = tempHero[i]
			end
			for p,v in pairs(tabP) do
				--if hGlobal.player[p] then
				--	hGlobal.player[p]:sortherobyindex(v)
				--end
				if self:GetPlayer(p) then
					self:GetPlayer(p):sortherobyindex(v)
				end
			end
		end
	end
end

--检测物件位置附近是否已经有其他物件
_hw._checkCanPlaceObject = function(self, checkMode, uList, minDistance, x, y, range, w, h)
	
	local checkFlag = true
							
	--计算新随机出的点是否已经有东西在了
	
	--矩形检测
	if checkMode == 1 then

		local minX = x - w * 0.5 -  minDistance
		local maxX = x + w * 0.5 +  minDistance
		local minY = y - h * 0.5 -  minDistance
		local maxY = y + h * 0.5 +  minDistance

		for k = 1, #uList do
			local x0 = uList[k][2]
			local y0 = uList[k][3]
			local w0 = uList[k][5]
			local h0 = uList[k][6]

			local minX0 = x0 - w0 * 0.5
			local maxX0 = x0 + w0 * 0.5
			local minY0 = y0 - h0 * 0.5
			local maxY0 = y0 + h0 * 0.5
			
			--简单的平行坐标轴矩形的相交判定
			if math.min(maxX,maxX0) >= math.max(minX,minX0) and math.min(maxY,maxY0) >= math.max(minY,minY0) then
				checkFlag = false
				break
			end
		end
	else
		for k = 1, #uList do
			local x0 = uList[k][2]
			local y0 = uList[k][3]
			local range0 = uList[k][4]

			if x0 and y0 and range0 then
				--print("check1:",(x0 - x) * (x0 - x) + (y0 - y) * (y0 - y),range0 + range + borderGap )
				--如果两个单位相交，则跳过
				if (x0 - x) * (x0 - x) + (y0 - y) * (y0 - y) < (range0 + range + minDistance) * (range0 + range + minDistance) then
					checkFlag = false
					break
				end
			else
				checkFlag = false
				break
			end
		end
	end

	return checkFlag
end

--计算随机场景
_hw._caculateRandomObject = function(self)
	
	local ret = {}

	if g_editor == 1 then return ret end
	
	--for i = 1, #__unitList do
	--	print("__unitList[" .. i .. "]:", __unitList[i][1],__unitList[i][2],__unitList[i][3],__unitList[i][4],__unitList[i][5],__unitList[i][6],__unitList[i][7],__unitList[i][8])
	--end
	
	local d = self.data
	local mapName = self.data.map

	--print("_hw._caculateRandomObject:",d.map,hVar.MAPS[d.map])

	if d.map and hVar.MAP_INFO[d.map] and hVar.MAP_INFO[d.map].randomSceneObj and type(hVar.MAP_INFO[d.map].randomSceneObj) == "table" then
		
		--地图上已经随机出的场景物件信息
		local uList = {}
		--存储已经加载的场景模板信息（文件型的场景模板）
		local template = {}
		
		--预先检测出生点信息
		local _,unitList,triggerData = hApi.LoadMap(d.map)
		local convertedDataTab = {}
		if triggerData then
			for k,v in pairs(triggerData)do
				if v.uniqueID~=nil then
					triggerData[k] = 0
					convertedDataTab[v.uniqueID] = v
				end
			end
		end
		if unitList then
			for i = 1,#unitList do
				local unitType,id,owner,worldX,worldY,facing,triggerID = unpack(unitList[i])
				local tgrDataU = convertedDataTab[triggerID]
				
				if unitType==hVar.UNIT_TYPE.PLAYER_INFO then
					uList[#uList + 1] = {id,worldX,worldY,10,10,10}
				elseif unitType==hVar.UNIT_TYPE.WAY_POINT then
					if tgrDataU and tgrDataU.pointType == 2 or tgrDataU.pointType == 4 then --英雄出生点
						uList[#uList + 1] = {id,worldX,worldY,10,10,10}
					end
				end
			end
		end
		
		--开始随机场景物件
		local cfg = hVar.MAP_INFO[d.map].randomSceneObj
		local maxNum = cfg.maxNum or 1
		local minDistance = cfg.minDistance or 0
		local border = cfg.border or {}
		local left = border[1] or 0
		local right = border[2] or 0
		local up = border[3] or 0
		local down = border[4] or 0
		local sobjPool = cfg.sobjPool
		local checkMode = cfg.checkMode or 0

		local mapW, mapH = d.sizeW,d.sizeH
		
		--加载地形开始（在地形加载开始及结束时调用xlMap_LoadTerrainPiece，为了优化效率，相当于统一进行一次批量处理。如果没有xlMap_LoadTerrainPiece调用，也不影响，正常地执行一次地形拷贝（多了一次开销））
		if xlMap_BeginLoadTerrain then
			xlMap_BeginLoadTerrain()
			print("xlMap_BeginLoadTerrain:!!!!!!!!!!!!!!")
		end
		
		--循环添加场景物件
		for i = 1, maxNum do
			local idx = self:random(1, #sobjPool)
			local sId = sobjPool[idx]
			if sId and hVar.tab_sceneobj[sId] then
				local sceneObjInfo = hVar.tab_sceneobj[sId]
				local range = sceneObjInfo.range or 50
				local w = sceneObjInfo.w or 100
				local h = sceneObjInfo.h or 100
				
				local borderGap = math.max((range + minDistance + left),100)
				local minX = math.min(borderGap,mapW * 0.5)

				borderGap = math.max((range + minDistance + right),100)
				local maxX = math.max(mapW - borderGap, mapW * 0.5)

				borderGap = math.max((range + minDistance + up),100)
				local minY = math.min(borderGap,mapH * 0.5)

				borderGap = math.max((range + minDistance + down),100)
				local maxY =math.max(mapH - borderGap, mapH * 0.5)

				if checkMode == 1 then
					borderGap = math.max((w * 0.5 + minDistance + left),100)
					minX = math.min(borderGap,mapW * 0.5)

					borderGap = math.max((w * 0.5 + minDistance + right),100)
					maxX = math.max(mapW - borderGap, mapW * 0.5)

					borderGap = math.max((h * 0.5 + minDistance + up),100)
					minY = math.min(borderGap,mapH * 0.5)

					borderGap = math.max((h * 0.5 + minDistance + down),100)
					maxY =math.max(mapH - borderGap, mapH * 0.5)
				end
				
				--unitType,id,owner,worldX,worldY,facing,triggerID = unpack(unitList[i])
				if sceneObjInfo.sets then
					
					local sets,ter
					local offsetX, offsetY = 0,0
					--判定是加载场景物件模板，还是场景物件表信息
					if type(sceneObjInfo.sets) == "table" then
						sets = sceneObjInfo.sets
					elseif type(sceneObjInfo.sets) == "string" then
						local map = sceneObjInfo.sets
						
						local a,b
						if not template[map] then
							a,template[map],b = hApi.LoadMap(map)
						end
						sets = template[map]
						ter = hApi.GetMapPath(map .. ".ter")
						--将左上角为原点局部坐标系修改为地图中心为原点的局部坐标系
						offsetX, offsetY = (tonumber(w) or 0) * -0.5, (tonumber(h) or 0) * -0.5
					end
					
					--如果场景物件信息存在
					if sets then
						--循环10次直到找到位置，超出10次还没找到，则不再添加这个单位了
						for j = 1, 10 do

							local rX = self:random(minX, maxX)
							local rY = self:random(minY, maxY)
							local rFace = self:random(1, 360)
							rFace = 0
							
							--参数: 检测方式（圆形,矩形）, 已添加的物件列表, 物件之间的最小间距,放置坐标x,放置坐标y,物件范围,物件宽,物件高
							local checkFlag = self:_checkCanPlaceObject(checkMode,uList,minDistance,rX,rY,range,w,h)

							--print("11111111111111111111111111111:",sId, 0,rX,rY,rFace,0)
							
							--如果最终随机出了合法位置，则添加场景物件
							if checkFlag then
								--将位置信息加入到已添加场景信息列表中
								uList[#uList + 1] = {sId,rX,rY,range,w,h}
								--逐个遍历场景物件组中的所有物件
								for n = 1, #sets do
									--是否是多个方向物件
									local bMulti = sets[n].bMulti
									--最终物件集合
									local objSet = sets[n]

									if sets[n].bMulti then
										local mapRangeW = mapW - (left + right)
										if rX >= right and rX < left + mapRangeW * 0.33 then
											objSet = sets[n].l
										elseif rX >= left + mapRangeW * 0.33 and rX < left + mapRangeW * 0.67 then
											objSet = sets[n].m
										elseif rX >= left + mapRangeW * 0.67 then
											objSet = sets[n].r
										end
									end

									--场景物件表
									if #objSet == 4 then
										local uid = objSet[1]
										if uid and hVar.tab_unit[uid] then
											local uType = hVar.tab_unit[uid].type
											local dx = objSet[2] or 0
											local dy = objSet[3] or 0
											local face = objSet[4] or 0
											--__unitList[#__unitList + 1] = {uType,uid,0,rX + dx + offsetX,rY + dy + y,face + rFace,0}
											ret[#ret + 1] = {uType,uid,0,rX + dx + offsetX,rY + dy + offsetY,face + rFace,0}
											--print("__unitList:",uType,uid,0,rX + dx + offsetX,rY + dy + offsetY,face + rFace,0)
										end
									--场景物件模板
									elseif #sets[n] == 7 then
										ret[#ret + 1] = {objSet[1], objSet[2], objSet[3], rX + objSet[4] + offsetX, rY + objSet[5] + offsetY, objSet[6], objSet[7]}
										--print("__unitList1:",objSet[1], objSet[2], objSet[3], rX + objSet[4] + offsetX, rY + objSet[5] + offsetY, objSet[6], objSet[7])
									end
								end

								--如果存在地表信息则添加地表信息
								if ter then
									--if xlMap_LoadTerrainSprite then
									--	xlMap_LoadTerrainSprite(ter, rX + offsetX, rY + offsetY, 1)
									--end
									if xlMap_LoadTerrainPiece then
										xlMap_LoadTerrainPiece(ter, rX + offsetX, rY + offsetY, 1)
									end
								end

								break
							end
						end
					end
				end
			end
		end
		
		--加载地形结束（在地形加载开始及结束时调用xlMap_LoadTerrainPiece，为了优化效率，相当于统一进行一次批量处理。如果没有xlMap_LoadTerrainPiece调用，也不影响，正常地执行一次地形拷贝（多了一次开销））
		if xlMap_EndLoadTerrain then
			xlMap_EndLoadTerrain()
			print("xlMap_EndLoadTerrain:!!!!!!!!!!!!!!!!!!")
		end
	end

	return ret
end

_hw.loadAllObjects = function(self,unitList,triggerData,codeOnCreate)
	local d = self.data
	local h = self.handle
	if h.worldScene==nil then
		--世界场景并未加载，不加载单位
		return
	end
	
	if xlError_SetLuaDebugInfo then
		local strText = tostring(d.map)
		--print("xlError_SetLuaDebugInfo:", strText)
		xlError_SetLuaDebugInfo(strText)
	end
	
	if unitList ~= nil and unitList.b_random_map == true then
		--仅供编辑器查看
		--print("g_editor=", g_editor)
		if g_editor == 1 then
			--RandomMap.EasyMap(d.w,d.h, 100, unitList.random_RoomClass, unitList.random_seed)
			local map_offsetX = 0
			local map_offsetY = 0
			RandomMap.EasyMap(d.w / 3, d.h / 3, unitList.random_RoomClass, os.time())
			local rooms = nil
			__unitList, rooms = RandomMap.GetAllObject(unitList.random_ObjectInfo,16 * 3,unitList.random_RoomClass, map_offsetX, map_offsetY)
			__triggerData = triggerData
			
			--存储
			--d.randomMapRooms = rooms
			
			--存储生成的单位
			local tmp_unitList = {}
			for i = 1, #__unitList, 1 do
				table.insert(tmp_unitList, __unitList[i])
			end
			__unitList = {}
			
			--附加原来的地图摆放单位
			for i = 1, #unitList, 1 do
				table.insert(__unitList, i, unitList[i])
			end
			
			--[[
			--地图内铺地板的物件
			local pixSize = 16
			local xlobjId = 4013
			local GRIDWIDTH = 24
			local GTIDHEIGHT = 16
			local GRIDOFFETX = 384/2
			local GRIDOFFETY = 256/2
			for _, RoomValue in pairs(rooms) do
				local PX = RoomValue.x
				local PY = RoomValue.y
				local PW = RoomValue.w
				local PH = RoomValue.h
				print(PX, PY, PW, PH)
				
				for dx = 1, PW - GRIDOFFETX / pixSize, GRIDWIDTH do
					for dy = 1, PH - GRIDOFFETY / pixSize, GTIDHEIGHT do
						local obj = {4, xlobjId, 0, PX * pixSize + dx * pixSize + GRIDOFFETX, PY * pixSize + dy * pixSize + GRIDOFFETY, 0, 0}
						table.insert(__unitList, obj)
					end
				end
				--local inside = RoomValue._inside
				
			end
			]]
			local texture = CCTextureCache:sharedTextureCache():textureForKey("data/xlobj/floor_ice6.png")
			if (not texture) then
				texture = CCTextureCache:sharedTextureCache():addImage("data/xlobj/floor_ice6.png")
				--print("加载大图！")
			end
			local worldLayer = self.handle.worldLayer
			local tSize = texture:getContentSize()
			--地图内铺地板的物件
			local pixSize = 16 * 3
			local xlobjId = 4013
			local GRIDWIDTH = tSize.width / pixSize
			local GTIDHEIGHT = tSize.height / pixSize
			local GRIDOFFETX = 0
			local GRIDOFFETY = 0
			for _, RoomValue in pairs(rooms) do
				local PX = RoomValue.x + map_offsetX
				local PY = RoomValue.y + map_offsetY
				local PW = RoomValue.w
				local PH = RoomValue.h
				--print(PX, PY, PW, PH)
				
				for dx = 1, PW - GRIDOFFETX / pixSize, GRIDWIDTH do
					for dy = 1, PH - GRIDOFFETY / pixSize, GTIDHEIGHT do
						local xl = PX * pixSize + dx * pixSize + GRIDOFFETX
						local yt = PY * pixSize + dy * pixSize + GRIDOFFETY
						local xr = xl + tSize.width
						local yb = yt + tSize.height
						local RIGHT = (PX + PW) * pixSize + pixSize
						local BOTTOM = (PY + PH) * pixSize + pixSize
						if (xr > RIGHT) then
							xr =  RIGHT
						end
						if (yb > BOTTOM) then
							yb = BOTTOM
						end
						if (xr > 0) and (yb > 0) then
							--print(0, 0, xr - xl, yb - yt)
							local sprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, xr - xl, yb - yt))
							sprite:setAnchorPoint(ccp(0, 1))
							
							sprite:setPosition(ccp(xl-pixSize/2, -yt+pixSize/2))
							worldLayer:addChild(sprite, 20)
						end
						
						--local obj = {4, xlobjId, 0, PX * pixSize + dx * pixSize + GRIDOFFETX, PY * pixSize + dy * pixSize + GRIDOFFETY, 0, 0}
						--table.insert(__unitList, obj)
					end
				end
				--local inside = RoomValue._inside
				
			end
			
			--附加之前的单位
			for i = 1, #tmp_unitList, 1 do
				table.insert(__unitList, tmp_unitList[i])
			end
		end
		
--		--RandomMap.EasyMap(d.w,d.h, 100, unitList.random_RoomClass, unitList.random_seed)
--		local map_offsetX = 0
--		local map_offsetY = 0
--		RandomMap.EasyMap(d.w / 3, d.h / 3, unitList.random_RoomClass, os.time())
--		local rooms = nil
--		__unitList, rooms = RandomMap.GetAllObject(unitList.random_ObjectInfo,16 * 3,unitList.random_RoomClass, map_offsetX, map_offsetY)
--		__triggerData = triggerData
--		
--		--存储
--		d.randomMapRooms = rooms
--		
--		--存储生成的单位
--		local tmp_unitList = {}
--		for i = 1, #__unitList, 1 do
--			table.insert(tmp_unitList, __unitList[i])
--		end
--		__unitList = {}
--		
--		--附加原来的地图摆放单位
--		for i = 1, #unitList, 1 do
--			table.insert(__unitList, i, unitList[i])
--		end
--		
--		--[[
--		--地图内铺地板的物件
--		local pixSize = 16
--		local xlobjId = 4013
--		local GRIDWIDTH = 24
--		local GTIDHEIGHT = 16
--		local GRIDOFFETX = 384/2
--		local GRIDOFFETY = 256/2
--		for _, RoomValue in pairs(rooms) do
--			local PX = RoomValue.x
--			local PY = RoomValue.y
--			local PW = RoomValue.w
--			local PH = RoomValue.h
--			print(PX, PY, PW, PH)
--			
--			for dx = 1, PW - GRIDOFFETX / pixSize, GRIDWIDTH do
--				for dy = 1, PH - GRIDOFFETY / pixSize, GTIDHEIGHT do
--					local obj = {4, xlobjId, 0, PX * pixSize + dx * pixSize + GRIDOFFETX, PY * pixSize + dy * pixSize + GRIDOFFETY, 0, 0}
--					table.insert(__unitList, obj)
--				end
--			end
--			--local inside = RoomValue._inside
--			
--		end
--		]]
--		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/xlobj/floor_ice6.png")
--		if (not texture) then
--			texture = CCTextureCache:sharedTextureCache():addImage("data/xlobj/floor_ice6.png")
--			--print("加载大图！")
--		end
--		local worldLayer = self.handle.worldLayer
--		local tSize = texture:getContentSize()
--		--地图内铺地板的物件
--		local pixSize = 16 * 3
--		local xlobjId = 4013
--		local GRIDWIDTH = tSize.width / pixSize
--		local GTIDHEIGHT = tSize.height / pixSize
--		local GRIDOFFETX = 0
--		local GRIDOFFETY = 0
--		for _, RoomValue in pairs(rooms) do
--			local PX = RoomValue.x + map_offsetX
--			local PY = RoomValue.y + map_offsetY
--			local PW = RoomValue.w
--			local PH = RoomValue.h
--			--print(PX, PY, PW, PH)
--			
--			for dx = 1, PW - GRIDOFFETX / pixSize, GRIDWIDTH do
--				for dy = 1, PH - GRIDOFFETY / pixSize, GTIDHEIGHT do
--					local xl = PX * pixSize + dx * pixSize + GRIDOFFETX
--					local yt = PY * pixSize + dy * pixSize + GRIDOFFETY
--					local xr = xl + tSize.width
--					local yb = yt + tSize.height
--					local RIGHT = (PX + PW) * pixSize
--					local BOTTOM = (PY + PH) * pixSize
--					if (xr > RIGHT) then
--						xr =  RIGHT
--					end
--					if (yb > BOTTOM) then
--						yb = BOTTOM
--					end
--					if (xr > 0) and (yb > 0) then
--						--print(0, 0, xr - xl, yb - yt)
--						local sprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, xr - xl, yb - yt))
--						sprite:setAnchorPoint(ccp(0, 1))
--						
--						sprite:setPosition(ccp(xl-pixSize/2, -yt+pixSize/2))
--						worldLayer:addChild(sprite, 20)
--					end
--					
--					--local obj = {4, xlobjId, 0, PX * pixSize + dx * pixSize + GRIDOFFETX, PY * pixSize + dy * pixSize + GRIDOFFETY, 0, 0}
--					--table.insert(__unitList, obj)
--				end
--			end
--			--local inside = RoomValue._inside
--			
--		end
--		
--		--附加之前的单位
--		for i = 1, #tmp_unitList, 1 do
--			table.insert(__unitList, tmp_unitList[i])
--		end
--		
--		--宇宙层远景物件
--		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/xlobj/meteoritespace2.jpg")
--		if (not texture) then
--			texture = CCTextureCache:sharedTextureCache():addImage("data/xlobj/meteoritespace2.jpg")
--			print("加载宇宙层远景物件图！")
--		end
--		local tSize = texture:getContentSize()
--		local sprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
--		sprite:setAnchorPoint(ccp(0.5, 0.5))
--		sprite:setPosition(ccp(0, 0))
--		--sprite:setContentSize(CCSizeMake(d.sizeW, d.sizeH))
--		--sprite:setScaleX(d.sizeW/tSize.width)
--		--sprite:setScaleY(d.sizeH/tSize.height)
--		sprite:setScaleX(1.5)
--		sprite:setScaleY(1.5)
--		worldLayer:addChild(sprite, 0)
--		local camX, camY = xlGetViewNodeFocus()
--		d.randomMapFarSceneObj = {node = {sprite,},}
--		
--		--宇宙层近景物件
--		local tNodeNear = {}
--		for loop = 1, 3, 1 do
--			for m = 1, 5, 1 do
--				local texture = CCTextureCache:sharedTextureCache():textureForKey("data/xlobj/meteorite" .. m .. ".png")
--				if (not texture) then
--					texture = CCTextureCache:sharedTextureCache():addImage("data/xlobj/meteorite" .. m .. ".png")
--					print("加载宇宙层近景物件" .. m .. "图！")
--				end
--				local tSize = texture:getContentSize()
--				local sprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
--				local randX = math.random(0, d.sizeW)
--				local randY = math.random(0, d.sizeH)
--				local rot = math.random(0, 360)
--				sprite:setAnchorPoint(ccp(0.5, 0.5))
--				sprite:setPosition(ccp(randX, -randY))
--				sprite:setRotation(rot)
--				--sprite:setContentSize(CCSizeMake(d.sizeW, d.sizeH))
--				--sprite:setScaleX(d.sizeW/tSize.width)
--				--sprite:setScaleY(d.sizeH/tSize.height)
--				--sprite:setScaleX(2.5)
--				--sprite:setScaleY(2.5)
--				worldLayer:addChild(sprite, 1)
--				tNodeNear[#tNodeNear+1] = sprite
--				
--				--动画
--				--宝物图标随机动画
--				local delayTime1 = math.random(800, 1600)
--				local delayTime2 = math.random(800, 1600)
--				local moveTime = math.random(1000, 2500)
--				local scaleTo = math.random(1001, 1050) / 1000
--				local act1 = CCDelayTime:create(delayTime1/1000)
--				local act2 = CCScaleTo:create(moveTime/1000, scaleTo)
--				local act3 = CCDelayTime:create(delayTime2/1000)
--				local act4 = CCScaleTo:create(moveTime/1000, 1)
--				local a = CCArray:create()
--				a:addObject(act1)
--				a:addObject(act2)
--				a:addObject(act3)
--				a:addObject(act4)
--				local sequence = CCSequence:create(a)
--				--oItem.handle.s:stopAllActions() --先停掉之前的动作
--				sprite:runAction(CCRepeatForever:create(sequence))
--			end
--		end
--		local camX, camY = xlGetViewNodeFocus()
--		d.randomMapNearSceneObj = {node = tNodeNear, camX = camX, camY = camY,}
--		
--		--生成随机地图野怪
--		hApi.CreateRandMapEnemys()
		
		if g_editor ~= 1 then
			__unitList,__triggerData = unitList,triggerData
		end
	else
		--地图随机场景
		local randomSceneObjList = self:_caculateRandomObject()
		
		if unitList==nil then
			local _,unitList,triggerData = hApi.LoadMap(d.map)
			__unitList,__triggerData = unitList,triggerData
		else
			__unitList,__triggerData = unitList,triggerData
		end
		
		--将随机场景物件添加进列表
		for i = 1, #randomSceneObjList do
			__unitList[#__unitList + 1] = randomSceneObjList[i]
		end
	end

	__self = self
	__codeOnCreate = codeOnCreate
	d.IsLoading = 1
	xpcall(__LoadAllChaOnMap,hGlobal.__TRACKBACK__)
	d.IsLoading = 0
	--self:__ReadGuardFromDatToC()
end

_hw.__ReadGuardFromDatToC = function(self)
	self:enumunit(function(eu)
		--城镇没有"守卫"，只有守城英雄
		if eu:gettown()~=nil then
			return
		end
		local tgr = eu:gettriggerdata()
		local gu = nil
		if tgr ~= nil then
			gu = tgr.guard
		end
		if gu ~= nil then
			local g = self:tgrid2unit(gu[1])
			if g ~= nil then
				xlCha_SetGuard(eu.handle._c,g.handle._c)
			end
		end
	end)
end
---------------------------------------------------------
local __self,__unitList
local __LoadAllSceobjOnMap = function()
	local self = __self
	local unitList = __unitList
	if type(self)~="table" or self.ID==0 or type(unitList)~="table" then
		return
	end
	local worldScene
	if self.handle and type(self.handle.worldScene)=="userdata" then
		worldScene = self.handle.worldScene
		--清除地图上单位使用的编辑器ID
		xlScene_ClearUniqueID(self.handle.worldScene)
	end
	local d = self.data
	if unitList~=nil then
		for i = 1,#unitList do
			local unitType,id,owner,worldX,worldY,facing,triggerID
			if #unitList[i]==7 then
				unitType,id,owner,worldX,worldY,facing,triggerID = unpack(unitList[i])
			else
				id,owner,worldX,worldY,facing,triggerID = unpack(unitList[i])
			end
			if unitType~=hVar.UNIT_TYPE.ITEM then
				if hVar.tab_unit[id]~=nil and hVar.tab_unit[id].type==hVar.UNIT_TYPE.SCEOBJ then
					hApi.addChaByID(self,owner,id,worldX,worldY,facing,nil,{editorID = id,indexOfCreate = i})
				end
			end
		end
	end
end

_hw.loadAllSceobjs = function(self,unitList)
	local d = self.data
	if self.handle.worldScene==nil then
		--地形尚未加载，不允许加载物件
		return
	end
	if unitList==nil then
		local _,unitList,triggerData = hApi.LoadMap(d.map)
		__unitList = unitList
	else
		__unitList = unitList
	end
	__self = self
	xpcall(__LoadAllSceobjOnMap,hGlobal.__TRACKBACK__)
end
---------------------------------------------------------
_hw.loadMapGrid = function(self,mapName)
	local d = self.data
	if d.type=="battlefield" then
		local tMap
		if type(mapName)=="string" then
			d.map = mapName
		end
		if type(hVar.MAPS[d.map])=="table" then
			tMap = hApi.ReadParam(hVar.MAPS[d.map],nil,{},2)
		else
			tMap = hApi.ReadParam(hVar.MAPS.BATTLEFIELD,nil,{},2)
		end
		rawset(self,"map",tMap)
		d.mapOriginX,d.mapOriginY,d.bgOffsetX,d.bgOffsetY = unpack(tMap.backgroundOrigin)
		d.w,d.h,d.gridW,d.gridH,d.gridOffsetX,d.gridOffsetY = unpack(tMap.grid)
		d.block.w,d.block.h = d.w,d.h
		d.gridtype = tMap.gridtype or "Ax6e"
		__loadGridMode(self,d.gridtype)
		--刷新一下碰撞信息
		for i = 0,d.w*d.h,1 do
			d.block[i] = 0
			for n = 1,#d.unitInGrid do
				d.unitInGrid[n][i] = 0
			end
		end
		return tMap
	end
end

_hw.loadMapTile = function(self,mapPath)
	local d = self.data
	local h = self.handle
	mapPath = mapPath or d.background
	local _map
	--加载地图地形
	if d.type=="worldmap" or d.type=="town" then
		--加载世界地图
		_map = hApi.ReadParam(hVar.MAPS.DEFAULT,nil,{},2)
		rawset(self,"map",_map)
		d.gridtype = "Ax4"
		__loadGridMode(self,d.gridtype)
		--加载世界layer
		hApi.LoadWorldLayer(h,d.scenetype)
		if d.scenetype~=-1 then
			if g_map_on_scene[d.scenetype] and g_map_on_scene[d.scenetype]~=self then
				xlEvent_BeforeLayerClear(d.scenetype)
			end
			g_map_on_scene[d.scenetype] = self
		end
		--创建XL模式的地图
		if d.type=="town" then
			d.w,d.h,d.sizeW,d.sizeH = hApi.CreateWorldMapXL(self.handle,d.map,mapPath,"town4")
		else
			d.w,d.h,d.sizeW,d.sizeH = hApi.CreateWorldMapXL(self.handle,d.map,mapPath,"worldmap_3")
		end
		d.gridW = 24
		d.gridH = 24
		d.borderW = 1
		d.borderH = 1
	elseif d.type=="battlefield" then
		_map = self:loadMapGrid(d.map)
		--加载战场数据
		if mapPath==0 and _map~=nil then
			mapPath = _map.background
		end
		--加载世界layer
		hApi.LoadWorldLayer(h,d.scenetype)
		if d.scenetype~=-1 then
			if g_map_on_scene[d.scenetype] and g_map_on_scene[d.scenetype]~=self then
				xlEvent_BeforeLayerClear(d.scenetype)
			end
			g_map_on_scene[d.scenetype] = self
		end
		--创建战场地图
		local _,_,sizeW,sizeH = hApi.CreateWorldMapXL_BF(self.handle,d.map,mapPath,"battlefield/battlefield_boss")
		--创建自定义图片地图（中古方法，已废弃）
		--hApi.CreateWorldMapPNG(self.handle,"map/"..mapPath..".png",d.bgOffsetX,d.bgOffsetY,d.w,d.h,d.gridW,d.gridH)
		if h._n then
			local gridMaskModel
			--初始化"Ax6e"的grid显示batchNode
			if d.gridtype=="Ax6" or d.gridtype=="Ax6e" or d.gridtype=="Ax6o" then
				gridMaskModel = "MODEL:grid"
				d.gridMaskW = 61	--64 - 3
				d.gridMaskH = 50	--40 + 10
				d.gridMaskOffsetX = 0
				d.gridMaskOffsetY = 5
			else
				gridMaskModel = "MODEL:gridAx4"
				d.gridMaskW = d.gridW-1
				d.gridMaskH = d.gridH-1
				d.gridMaskOffsetX = 0
				d.gridMaskOffsetY = 0
			end
			if type(_map.gridmask)=="table" then
				local gModel,gW,gH,gX,gY = unpack(_map.gridmask)
				gridMaskModel = gModel
				if gW~=nil and gH~=nil and gX~=nil and gY~=nil then
					d.gridMaskW,d.gridMaskH,d.gridMaskOffsetX,d.gridMaskOffsetY = gW,gH,gX,gY
				end
			end
			if gridMaskModel~=nil then
				h._bn = hApi.SpriteInitBatchNode(h,gridMaskModel)
				h._n:addChild(h._bn,hVar.ObjectZ.MAP+1)
				self:drawgrid("default","gray")
			end
		end
		d.sizeW = sizeW
		d.sizeH = sizeH
		--d.sizeW = d.w*d.gridW
		--d.sizeH = d.h*d.gridH
	else
		_map = hApi.ReadParam(hVar.MAPS.DEFAULT,nil,{},2)
		rawset(self,"map",_map)
		d.gridtype = "Ax4"
		__loadGridMode(self,d.gridtype)
		--计算地图尺寸
		d.sizeW = d.w*d.gridW
		d.sizeH = d.h*d.gridH
	end
end

_hw.gettacticalgrid = function(self,nTeamId,nLen,tGrid,tNode)
	if tGrid==nil then
		tGrid = {}
	end
	if tNode==nil then
		tNode = {}
	end
	local d = self.data
	if d.type=="battlefield" then
		if nTeamId==2 and (d.gridtype=="Ax6e" or d.gridtype=="Ax6o") then
			local nColL = d.w - 1 - nLen
			local nColR = d.w - 1
			--e
			--  * *      1 2 (3)
			-- * * *    4 5 6
			--  * *      7 8 (9)
			--o
			-- * * *     1 2 3
			--  * *       4 5 (6)
			-- * * *     7 8 9
			local nModeMatch = 0
			if d.gridtype=="Ax6e" then
				nModeMatch = 0
			else
				nModeMatch = 1
			end
			for y = 0,d.h-1,1 do
				local nPlus = 0
				if math.mod(y,2)==nModeMatch then
					nPlus = -1
				end
				for x = nColL+nPlus,nColR+nPlus,1 do
					tNode[self:grid2n(x,y)] = 1
					tGrid[#tGrid+1] = {x=x,y=y}
				end
			end
		else
			local nColL,nColR
			if nTeamId==2 then
				nColL = d.w - 1 - nLen
				nColR = d.w - 1
			else
				nColL = 0
				nColR = nLen
			end
			for y = 0,d.h-1,1 do
				for x = nColL,nColR,1 do
					tNode[self:grid2n(x,y)] = 1
					tGrid[#tGrid+1] = {x=x,y=y}
				end
			end
		end
	end
	return tGrid,tNode
end
--------------------------------------------
local __WorldAddBlock = function(x,y,w,v)
	if w:IsSafeGrid(x,y) then
		local n = w:grid2n(x,y)
		local block = w.data.block
		block[n] = block[n] + (v or 1)
	end
end

local __WorldRemoveBlock = function(x,y,w,v)
	if w:IsSafeGrid(x,y) then
		local n = w:grid2n(x,y)
		local block = w.data.block
		block[n] = block[n] - (v or 1)
	end
end

local __WorldUnitEnterGrid = function(x,y,p)
	local w,u = p.w,p.u
	if w:IsSafeGrid(x,y) and u.ID then
		local n = w:grid2n(x,y)
		local g
		--unitInGrid:{[1] = {单位},[2] = {建筑},[3] = {被动单位,这一项可以有多个单位在同个格子上}}
		if u.data.type==hVar.UNIT_TYPE.BUILDING then
			g = w.data.unitInGrid[1]
		else
			g = w.data.unitInGrid[2]
		end
		if g[n]==nil or g[n]==0 or g[n]==u.ID then
			--普通的单位
			g[n] = u.ID
		else
			--该位置已经被占据
			if u.attr.mxhp<0 then
				--死亡的单位就不管啦
			elseif u.attr.passive>0 or u.attr.IsSummoned~=0 then
				--被动的单位,召唤的单位可以放到特殊的格子上
				local ex = w.data.unitInGrid[3]
				if type(ex[n])~="table" then
					ex[n] = {}
				end
				ex[n][#ex[n]+1] = u.ID
			else
				--普通单位添加到已经有碰撞的格子就会出错
				_DEBUG_MSG("("..u.ID..")["..u.data.name.."]set on grid with block:",x,y)
			end
		end
	end
end

local __WorldUnitLeaveGrid = function(x,y,p)
	local w,u = p.w,p.u
	if w:IsSafeGrid(x,y) and u.ID then
		local n = w:grid2n(x,y)
		local g = w.data.unitInGrid
		local g
		--unitInGrid:{[1] = {单位},[2] = {建筑},[3] = {被动单位,这一项可以有多个单位在同个格子上}}
		if u.data.type==hVar.UNIT_TYPE.BUILDING then
			g = w.data.unitInGrid[1]
		else
			g = w.data.unitInGrid[2]
		end
		if g[n]==nil or g[n]==0 or g[n]==u.ID then
			--普通地离开
			g[n] = 0
		end
		--检查多单位在同一格子上的情况
		local ex = w.data.unitInGrid[3]
		if (ex[n] or 0)~=0 then
			local t = ex[n]
			local sus = 0
			for i = 1,#t do
				if t[i]==u.ID then
					t[i] = 0
					sus = 1
				end
			end
			if sus==1 then
				hApi.CompressNumTab(t)
				if #t==0 then
					ex[n] = 0
				end
			end
		end
	end
end
------------------------------------------
-- 设置碰撞格函数
-- 按理说这些东西只有在战场中会被用到
_hw.addblock = function(self,gridX,gridY,vBlock)
	return hApi.enumNearGrid(gridX,gridY,vBlock,__WorldAddBlock,self,1)
end

_hw.addblockT = function(self,tGrid)
	for i = 1,(tGrid.n or #tGrid) do
		__WorldAddBlock(tGrid[i].x,tGrid[i].y,self,1)
	end
end

_hw.removeblockT = function(self,tGrid)
	for i = 1,(tGrid.n or #tGrid) do
		__WorldAddBlock(tGrid[i].x,tGrid[i].y,self,-1)
	end
end

_hw.removeblock = function(self,gridX,gridY,vBlock)
	return hApi.enumNearGrid(gridX,gridY,vBlock,__WorldRemoveBlock,self,1)
end

_hw.addblockU = function(self,oUnit,gridX,gridY,blockMode)
	if not(gridX and gridY) then
		gridX,gridY = oUnit.data.gridX,oUnit.data.gridY
	end
	local blockN = 1
	if oUnit.data.type==hVar.UNIT_TYPE.BUILDING then
		blockN = 10
	end
	return hApi.enumNearGrid(gridX,gridY,oUnit:getblock(gridX,gridY,blockMode),__WorldAddBlock,self,blockN)
end

_hw.removeblockU = function(self,oUnit,gridX,gridY,blockMode)
	if not(gridX and gridY) then
		gridX,gridY = oUnit.data.gridX,oUnit.data.gridY
	end
	local blockN = 1
	if oUnit.data.type==hVar.UNIT_TYPE.BUILDING then
		blockN = 10
	end
	return hApi.enumNearGrid(gridX,gridY,oUnit:getblock(gridX,gridY,blockMode),__WorldRemoveBlock,self,blockN)
end

local __BF_MoveTemp = {w=0,u=0}
_hw.entergridU = function(self,oUnit,gridX,gridY)
	if self.data.type=="battlefield" then
		if not(gridX and gridY) then
			gridX,gridY = oUnit.data.gridX,oUnit.data.gridY
		end
		__BF_MoveTemp.w = self
		__BF_MoveTemp.u = oUnit
		hApi.enumNearGrid(gridX,gridY,oUnit:getblock(gridX,gridY),__WorldUnitEnterGrid,__BF_MoveTemp)
		return self:addblockU(oUnit,gridX,gridY)
	end
end

local __BF_MoveTemp = {w=0,u=0}
_hw.leavegridU = function(self,oUnit,gridX,gridY)
	if self.data.type=="battlefield" then
		if not(gridX and gridY) then
			gridX,gridY = oUnit.data.gridX,oUnit.data.gridY
		end
		__BF_MoveTemp.w = self
		__BF_MoveTemp.u = oUnit
		hApi.enumNearGrid(gridX,gridY,oUnit:getblock(gridX,gridY),__WorldUnitLeaveGrid,__BF_MoveTemp)
		return self:removeblockU(oUnit,gridX,gridY)
	end
end

-----------------------
-- 为战场内的军团添加一个单位
--@unitId:待添加的单位ID
--@ownerId:所属玩家
--@x,y:坐标
--@返回值:无
local __ADDU_PARAM = {}
--[[
local unit_init = false
local unit_list = {}
local AsyncFile = io.open("log/unit_name.log", "w+")
]]
_hw.addunit = function(self, unitId ,owner, gridX, gridY, facing, worldX, worldY, attr, data, lv, star)
	--print("addunit", "unitId = " .. unitId, "worldX = " .. worldX, "worldY = " .. worldY) --geyachao
	if self.data.IsLoading==2 then
		xlLG("sav_error","[UNIT]读取时创建单位,"..tostring(unitId).."("..tostring(worldX)..","..tostring(worldY)..")\n")
		return
	end
	
	local tabU = hVar.tab_unit[unitId]
	
	if (tabU == nil) then
		print("unitId=", unitId, "nil!")
	end
	
	local unitType = tabU.type
	if (unitType == hVar.UNIT_TYPE.UNIT) then
		--地图内单位的数量
		if (self.data.unit_num > hVar.WORLD_MAX_UNIT_NUM) then
			print("游戏内单位数量超过" .. hVar.WORLD_MAX_UNIT_NUM .. "，单位[" .. unitId .. "]创建失败！")
			return
		else
			self.data.unit_num = self.data.unit_num + 1
			--print("++ unit_num=", self.data.unit_num)
		end
	end
	
	__ADDU_PARAM.id = unitId
	if type(owner)=="table" then
		__ADDU_PARAM.owner = owner.data.playerId
	else
		__ADDU_PARAM.owner = owner
	end
	
	--[[
	if (owner == 22) then
		if (not unit_init) then
			for k, v in ipairs(hVar.tab_unitShowEx[1]) do
				unit_list[ v[1] ] = true
			end
			for k, v in ipairs(hVar.tab_unitShowEx[2]) do
				unit_list[ v[1] ] = true
			end
			unit_init = true
		end
		
		if (not unit_list[unitId]) then
			unit_list[unitId] = true
			
			--日志
			local mapname = self.data.map
			local unitName = hVar.tab_stringU[unitId] and hVar.tab_stringU[unitId][1] or ("未知单位_" .. unitId)
			AsyncFile:write("{" .. unitId .. ", \"" .. mapname .. "\",}, --" .. unitName .. "\n")
			AsyncFile:flush()
		end
	end
	]]
	
	__ADDU_PARAM.gridX = gridX
	__ADDU_PARAM.gridY = gridY
	__ADDU_PARAM.facing = facing
	__ADDU_PARAM.worldX = worldX
	__ADDU_PARAM.worldY = worldY
	__ADDU_PARAM.lv = lv --geyachao --角色的等级
	__ADDU_PARAM.star = star --zhenkria --角色的星级
	
	--__ADDU_PARAM.animation = animation
	__ADDU_PARAM.bindW = self.ID
	__ADDU_PARAM.worldI = 0
	if attr and type(attr)=="table" then
		__ADDU_PARAM.attr = attr
	else
		__ADDU_PARAM.attr = nil
	end
	if data and type(data)=="table" then
		__ADDU_PARAM.data = data
	else
		__ADDU_PARAM.data = nil
	end
	local u = hClass.unit:new(__ADDU_PARAM)
	
	--单位出生特效
	local addEffect = tabU.addEffect
	if addEffect then
		local effectId = addEffect.id or 0
		local effectDx = addEffect.dx or 0
		local effectDy = addEffect.dy or 0
		local effectScale = addEffect.scale or 1.0
		if (effectId > 0) then
			self:addeffect(effectId, 1, nil, worldX + effectDx, worldY + effectDy) --56
		end
	end
	
	--设置朝向
	if facing then
		hApi.ChaSetFacing(u.handle, facing)
	end
	
	--添加单位回调函数
	if On_AddUnit_Special_Event then
		--安全执行
		hpcall(On_AddUnit_Special_Event, u, unitId ,owner, gridX, gridY, facing, worldX, worldY, attr, data, lv, star)
		--On_AddUnit_Special_Event(u, unitId ,owner, gridX, gridY, facing, worldX, worldY, attr, data, lv, star)
	end
	
	--geyachao: 同步日志: 添加单位
	if (hVar.IS_SYNC_LOG == 1) then
		local msg = "addunit: typeId=" .. unitId .. ",owner=" .. tostring(owner)  .. ",u_ID=" .. tostring(u:getworldC()) .. ",facing=" .. tostring(facing) .. ",wx=" .. tostring(worldX) .. ",wy=" .. tostring(worldY) .. ",lv=" .. tostring(lv) .. ",star=" .. tostring(star)
		hApi.SyncLog(msg)
	end
	
	local diablodata = hGlobal.LocalPlayer.data.diablodata --大菠萝数据
	
	--tank: 是否有绑定的单位（坦克炮口）
	local bindU = tabU.bind_unit
	if bindU then
		local bind_unit = self:addunit(bindU, owner, gridX, gridY, facing, worldX, worldY, attr, data, lv, star)
		u.data.bind_unit = bind_unit
		bind_unit.data.bind_unit_owner = u
	end
	
	--tank: 是否有绑定的单位（坦克机枪）
	local bindWeapon = nil
	local bindWeaponLv = 1
	local bindWeaponStar = 1
	if (unitId == hVar.MY_TANK_ID) then --我的坦克
		if diablodata and (diablodata ~= 0) then
			bindWeapon = diablodata.bind_weapon
			diablodata.bind_weapon = 0 --加载一次生效
			if (bindWeapon == 0) then
				bindWeapon = tabU.bind_weapon
				
				--大菠萝，读取存档玩家配置的武器索引
				local weaponIdx = LuaGetHeroWeaponIdx(unitId) --当前选中的武器索引值
				--print("unitId=", unitId)
				--print("weaponIdx=", weaponIdx)
				local weaponId = tabU.weapon_unit[weaponIdx].unitId
				bindWeapon = weaponId
				bindWeaponStar = LuaGetHeroWeaponLv(unitId, weaponIdx) --当前指定武器的星级
				bindWeaponLv = LuaGetHeroWeaponExp(unitId, weaponIdx) --当前指定武器的等级
			end
		end
	else
		bindWeapon = tabU.bind_weapon
	end
	if bindWeapon and (bindWeapon ~= 0) then
		local bind_weapon = self:addunit(bindWeapon, owner, gridX, gridY, facing, worldX, worldY, attr, data, bindWeaponLv, bindWeaponStar)
		u.data.bind_weapon = bind_weapon
		bind_weapon.data.bind_weapon_owner = u
		
		print("加载战车武器: id="..bindWeapon .. ",star="..bindWeaponStar)
		
		--大菠萝，重置武器
		--local weaponItemId = hGlobal.LocalPlayer:getweaponitem()
		--hGlobal.LocalPlayer:setweaponitem(weaponItemId)
	end
	
	--tank: 是否有绑定的单位（坦克大灯光照）
	local bindLight = tabU.bind_light
	if bindLight then
		local bind_light = self:addunit(bindLight, owner, gridX, gridY, facing, worldX, worldY, attr, data, lv, star)
		u.data.bind_light = bind_light
		bind_light.data.bind_light_owner = u
	end
	
	--tank: 是否有绑定的单位（坦克轮子）
	local bindWheel = tabU.bind_wheel
	if bindWheel then
		local bind_wheel = self:addunit(bindWheel, owner, gridX, gridY, facing, worldX, worldY, attr, data, lv, star)
		u.data.bind_wheel = bind_wheel
		bind_wheel.data.bind_wheel_owner = u
	end
	
	--tank: 是否有绑定的单位（坦克影子）
	local bindShadow = tabU.bind_shadow
	if bindShadow and (bindShadow > 0) then
		local worldX_shadow = worldX + hVar.tab_unit[bindShadow].attr.bind_offsetX or 0
		local worldY_shadow = worldY + hVar.tab_unit[bindShadow].attr.bind_offsetY or 0
		local bind_shadow = self:addunit(bindShadow, owner, gridX, gridY, facing, worldX_shadow, worldY_shadow, attr, data, lv, star)
		u.data.bind_shadow = bind_shadow
		bind_shadow.data.bind_shadow_owner = u
	end
	
	--tank: 是否有绑定的单位（坦克能量圈）
	local bindEnergy = tabU.bind_energy
	if bindEnergy then
		local bind_energy = self:addunit(bindEnergy, owner, gridX, gridY, facing, worldX, worldY, attr, data, lv, star)
		u.data.bind_energy = bind_energy
		bind_energy.data.bind_energy_owner = u
	end
	
	--tank: 是否有绑定的单位（坦克大灯）
	local bindLamp = tabU.bind_lamp
	if bindLamp then
		local bind_lamp = self:addunit(bindLamp, owner, gridX, gridY, facing, worldX, worldY, attr, data, lv, star)
		u.data.bind_lamp = bind_lamp
		bind_lamp.data.bind_lamp_owner = u
	end
	
	--标记是主角
	if (unitId == 6000) or (unitId == 6012) or (unitId == hVar.MY_TANK_ID) then
		self.data.rpgunit_tank = u --标记是主角
	end
	
	--标记是我方单位
	if (unitId == 6000) or (unitId == 6012) or (unitId == hVar.MY_TANK_ID) then
		self.data.rpgunits[u] = u:getworldC() --标记是我方单位
	end
	
	--添加坦克的buff
	if (unitId == 6000) or (unitId == 6012) then
		if diablodata and (diablodata ~= 0) then
			for i = 1, #diablodata.tankbuffs, 1 do
				local buff = diablodata.tankbuffs[i]
				local buffId = buff.buffId
				local gridX = buff.gridX
				local gridY = buff.gridY
				local tCastParam = buff.tCastParam
				
				hApi.CastSkill(u, buffId, 0, 100, u, gridX, gridY, tCastParam)
			end
			
			--一次性添加完毕
			diablodata.tankbuffs = {}
			
			--添加坦克武器的buff
			if bindWeapon and (bindWeapon ~= 0) then
				for i = 1, #diablodata.tankweaponbuffs, 1 do
					local buff = diablodata.tankweaponbuffs[i]
					local buffId = buff.buffId
					local gridX = buff.gridX
					local gridY = buff.gridY
					local tCastParam = buff.tCastParam
					
					hApi.CastSkill(u, buffId, 0, 100, bind_weapon, gridX, gridY, tCastParam)
				end
				
				--一次性添加完毕
				diablodata.tankweaponbuffs = {}
			end
		end
	end
	
	return u
end

-----------------------
-- 添加一个道具
--@unitId:待添加的单位ID
--@ownerId:所属玩家
--@x,y:坐标
--@返回值:无
local __ADDI_PARAM = {}
local __ADDI_PARAM_U = {}
--[[
_hw.additem = function(self,itemId,owner,gridX,gridY,facing,worldX,worldY,stack,rewardEx,item_version,item_uniqueID)
	if self.data.IsLoading==2 then
		xlLG("sav_error","[ITEM]读取时创建道具,"..tostring(unitId).."("..tostring(worldX)..","..tostring(worldY)..")\n")
		return
	end
	local tabI = hVar.tab_item[itemId]
	if tabI then
		__ADDI_PARAM_U.model = tabI.model
		__ADDI_PARAM_U.xlobj = tabI.xlobj
		__ADDI_PARAM_U.scale = hApi.floor((tabI.scale or 1)*100)
		__ADDI_PARAM.unit = self:addunit(hVar.ITEM_UNIT_ID,owner,gridX,gridY,facing,worldX,worldY,nil,__ADDI_PARAM_U)
	else
		__ADDI_PARAM.unit = self:addunit(hVar.ITEM_UNIT_ID,owner,gridX,gridY,facing,worldX,worldY)
	end
	__ADDI_PARAM.id = itemId
	__ADDI_PARAM.stack =  stack or 1
	__ADDI_PARAM.continuedays = tabI.continuedays
	__ADDI_PARAM.rewardEx = rewardEx or -1
	__ADDI_PARAM.version = item_version
	__ADDI_PARAM.uniqueID = item_uniqueID
	return hClass.item:new(__ADDI_PARAM)
end
--]]

local __ADDSO_PARAM = {}
_hw.addsceobj = function(self,id,gridX,gridY,model,animation,scale,facing,worldX,worldY,height)
	if self.data.IsLoading==2 then
		xlLG("sav_error","[SCEOBJ]读取时创建场景物件,"..tostring(model).."("..tostring(worldX)..","..tostring(worldY)..")\n")
		return
	end
	__ADDSO_PARAM.id = id
	__ADDSO_PARAM.gridX = gridX
	__ADDSO_PARAM.gridY = gridY
	__ADDSO_PARAM.model = model
	__ADDSO_PARAM.animation = animation
	if scale and type(scale)=="number" then
		__ADDSO_PARAM.scale = hApi.floor(scale*100)
	else
		__ADDSO_PARAM.scale = nil
	end
	__ADDSO_PARAM.bindW = self.ID
	__ADDSO_PARAM.worldI = 0
	__ADDSO_PARAM.facing = facing
	__ADDSO_PARAM.worldX = worldX
	__ADDSO_PARAM.worldY = worldY
	__ADDSO_PARAM.height = height
	local s = hClass.sceobj:new(__ADDSO_PARAM)
	
	--处理水
	if hGlobal.WORLD.LastWorldMap then
		local modelLength = string.len(tostring(model))
		for i = 1, #hVar.UNIT_RIVER_MODEL, 1 do
			if (string.upper(tostring(model)) == string.upper(hVar.UNIT_RIVER_MODEL[i])) then --找到了
			--if (modelLength > 5) and (string.upper(string.sub(tostring(model), 1, 5)) == "RIVER") then
				--print("处理水", model)
				local d = hGlobal.WORLD.LastWorldMap.data
				d.__waterRegionT[#d.__waterRegionT+1] = {x = worldX, y = worldY, w = 256, h = 256, model = tostring(model),}
				
				break
			end
		end
	end
	
	--geyachao: 同步日志: 加载场景物件
	if (hVar.IS_SYNC_LOG == 1) then
		local msg = "addsceobj: typeId=" .. tostring(id) .. ",model=" .. tostring(model) .. ",animation=" .. tostring(animation) .. ",worldX=" .. tostring(worldX) .. ",worldY=" .. tostring(worldY) .. ",gridX=" .. tostring(gridX) .. ",gridY=" .. tostring(gridY) .. ",facing=" .. tostring(facing) .. ",height=" .. tostring(height)
		hApi.SyncLog(msg)
	end
	
	--print(nil .. nil)
	return s
end

local __ADDE_PARAM = {}
_hw.addeffect = function(self,effectId,playTime,playParam,worldX,worldY,facing,scale,animation, oTarget, oAction, szType, collision, collParam) --geyachao：添加参数 oTarget, oAction, szType, collision, collParam
	--print("addeffect", facing, debug.traceback())
	--print("addeffect=", "effectId=", effectId, "oAction=", oAction)
	if self.data.IsLoading==2 then
		local effectType = 0
		if type(playParam)=="table" then
			effectType = tostring(playParam[1])
		end
		if type(effectId)=="table" then
			effectId = 0
		end
		xlLG("sav_error","[EFFECT]读取时创建特效,"..tostring(effectId).."类型:"..effectType.."("..tostring(worldX)..","..tostring(worldY)..")\n")
		return
	end
	__ADDE_PARAM.id = effectId
	__ADDE_PARAM.playtime = playTime
	if playParam~=nil and playParam~=0 and type(playParam)=="string" then
		__ADDE_PARAM.playparam = nil
		__ADDE_PARAM.animation = playParam
	else
		__ADDE_PARAM.playparam = playParam
		__ADDE_PARAM.animation = animation
	end
	__ADDE_PARAM.x = worldX
	__ADDE_PARAM.y = worldY
	__ADDE_PARAM.facing = facing
	__ADDE_PARAM.scale = scale
	__ADDE_PARAM.bindW = self.ID
	__ADDE_PARAM.worldI = 0
	__ADDE_PARAM.oTarget = oTarget -- geyachao: 添加追踪类飞行特效的追踪目标
	__ADDE_PARAM.oAction = oAction -- geyachao: 添加追踪类飞行特效的action
	__ADDE_PARAM.szType = szType -- geyachao: 添加追踪类飞行特效的类型（直线型、抛物线型）
	__ADDE_PARAM.collision = collision -- geyachao: 添加碰撞类型飞行特效的标记
	__ADDE_PARAM.collParam = collParam -- geyachao: 添加碰撞类型飞行特效的相关参数
	
	--print("__ADDE_PARAM.worldI" .. tostring(oTarget))
	local e = hClass.effect:new(__ADDE_PARAM)

	__ADDE_PARAM.playparam = nil

	return e
end

--==================================
-- 画行进路径用的函数
-----------------------
_hw.drawwaypoint = function(self,oUnit,worldX,worldY,oTarget)
	local w = self
	local u = oUnit
	
	--geyachao: 不要画线
	if true then
		return hVar.RESULT_SUCESS
	end
	
	if w.data.type=="worldmap" then
		if worldX and worldY then
			local gx,gy = w:xy2grid(worldX,worldY)
			local cx,cy = hApi.chaGetPos(u.handle)
			local cgx,cgy = w:xy2grid(cx,cy)
			if u.handle.UnitInMove==1 then
				u:arrive(u:getworld(),cgx,cgy,hVar.UNIT_ARRIVE_MODE.NORMAL,nil)
			else
				u:arrive(u:getworld(),cgx,cgy,hVar.UNIT_ARRIVE_MODE.NOTMOVE,nil)
			end
			--因为这里单位会停住，所以记录一下单位的worldX和worldY
			u.data.gridX,u.data.gridY = w:xy2grid(cx,cy)
			u.data.worldX = cx
			u.data.worldY = cy
			if oTarget~=nil and type(oTarget)=="table" then
				local tTgrData = oTarget:gettriggerdata()
				if tTgrData and (tTgrData.gate or 0)~=0 then
					--传送门特别处理 hVar.OPERATE_TYPE.UNIT_TELEPORT
					local oWorld = self
					local sus = hApi.chaDrawWayPoint(u.handle,gx,gy,oTarget.handle._c)
					if sus~=hVar.RESULT_SUCESS then
						local oTargetG = oWorld:tgrid2unit(tTgrData.gate)
						if oTargetG then
							local gx,gy = oTargetG.data.gridX,oTargetG.data.gridY
							return hApi.chaDrawWayPoint(u.handle,gx,gy,oTargetG.handle._c)
						end
					end
					return sus
				else
					return hApi.chaDrawWayPoint(u.handle,gx,gy,oTarget.handle._c)
				end
			else
				return hApi.chaDrawWayPoint(u.handle,gx,gy,t)
			end
		end
	elseif w.data.type=="battlefield" then
		if u and u.data.world==w.ID then
			if worldX and wolrdY then
				
			else
				local wl = w.data.w
				local wp = u.handle.waypoint
				local lNode = wp[wp.n+1]
					for i = wp.n+1,wp.e,1 do
					local cNode = wp[i]
					local nNode = wp[i+1<=wp.e and i+1 or wp.e]
					local animation = "normal"
					local gx,gy = w:n2grid(cNode)
					local x,y = w:grid2xy(gx,gy)
					if cNode~=nNode then
						local tx,ty = w:grid2xy(w:n2grid(nNode))
						animation = "stand_"..hApi.calAngleD("DIRECTIONx8",hApi.angleBetweenPoints(x,y,tx,ty))
					end
					local tBlock = oUnit:getblock()
					if animation=="normal" and type(tBlock)=="table" then
						for i = 1,#tBlock do
							local v = tBlock[i]
							local x,y = w:grid2xy(gx+v[1],gy+v[2])
							--local e = w:addeffect(5,0,nil,x,y,0,100,animation)
							--e.data.userdata = "WAY_POINT"
							--e.data.userparam = u.ID
						end
					else
						--local e = w:addeffect(5,0,nil,x+oUnit.data.standX,y+oUnit.data.standY,0,100,animation)
						--e.data.userdata = "WAY_POINT"
						--e.data.userparam = u.ID
					end
				end
			end
			return hVar.RESULT_SUCESS
		end
	end
end

_hw.__static.RemoveWayPointByUnit = function(oEffect,oUnit,_,oWorld)
	local d = oEffect.data
	if d.userdata=="WAY_POINT" and (oUnit==nil or d.userparam==oUnit.ID) then
		oEffect:del()
	end
end

_hw.clearwaypoint = function(self,oUnit)
	local d = self.data
	if oUnit then
		hApi.enumByClass(self,hClass.effect,d.effects,hClass.world.__static.RemoveWayPointByUnit,oUnit)
	elseif oUnit=="all" then
		hApi.enumByClass(self,hClass.effect,d.effects,hClass.world.__static.RemoveWayPointByUnit,nil)
	end
end

_hw.WDLD_RemoveLastGuard = function(self,t)
	local w = self
	--print(t.data.triggerID,"&&&&&&&&")
	--print(t.chaUI[t.data.triggerID.."GBG"],"******************")
	if t.chaUI[t.data.triggerID.."GBG"] then
		hApi.safeRemoveT(t.chaUI,t.data.triggerID.."GBG")
	end
	if t.chaUI[t.data.triggerID.."GIcon"] then
		hApi.safeRemoveT(t.chaUI,t.data.triggerID.."GIcon")
	end
	local lgtid = t:gettriggerdata().guard[1]
	if lgtid ~= 0 then
		local lgu = w:tgrid2unit(lgtid)
		if lgu ~= nil then
			lgu:sethide(0)
			hGlobal.LocalPlayer:focusunit(lgu,"worldmap")
		end
	end
	t:gettriggerdata().guard[1] = 0
end

_hw.WDLD_BuildingSetGuard = function(self,t,u,bHide)
	local bHide = bHide or 1
	t:gettriggerdata().guard = {u.data.triggerID}
	if bHide == 1 then
		u:sethide(1)
	end

	local worldX1,worldY1 = t:getstopXY()
	local worldX2,worldY2 = t:getXY()
	local posX = worldX1 - worldX2
	local directionX = 0
	--大于0时 向→偏移
	if posX > 0 then
		directionX = 20
	--小于0时 向←偏移
	elseif posX < 0 then
		directionX = -20
	end
	if hVar.tab_unit[u.data.id].type == 2 then
		t.chaUI[t.data.triggerID.."GBG"] = hUI.image:new({
			parent = t.handle._tn,
			model = "UI_frm:slot",
			animation = "lightSlim",
			w = 50,
			h = 50,
			x = posX - directionX,
			y = -(worldY1 - worldY2) + 45,
		})
		local img = hVar.tab_unit[u.data.id].icon
		if img == nil then
			img = hVar.tab_unit[u.data.id].model
		end
		t.chaUI[t.data.triggerID.."GIcon"] = hUI.thumbImage:new(
		{
			parent = t.handle._tn,
			model = img, --hVar.tab_unit[5000].icon,
			w = 44,
			h = 44,
			x = posX - directionX,
			y = -(worldY1 - worldY2) + 45,
		})
	end
end

--_hw.unitarrive = function(self,oArriveUnit,gridX,gridY,oTarget,nOperate,nOperateId)
--	local w = self
--	local d = self.data
--	local u = oArriveUnit
--	if w.data.type=="worldmap" then
--		local t = oTarget
--		if type(t)=="table" and t.data.IsDead~=1 and t:gettab()~=nil and nOperate~=hVar.OPERATE_TYPE.NONE then
--			local tTab = t:gettab()
--			if nOperate==hVar.OPERATE_TYPE.UNIT_MOVE then
--				--啥也不干
--			elseif nOperate==hVar.OPERATE_TYPE.UNIT_TALK then
--				
--				local tTalk = oTarget:gettalk()
--				if tTalk then
--					hGlobal.event:call("Event_HeroStartTalk",w,oArriveUnit,oTarget,tTalk)
--				end
--			elseif nOperate==hVar.OPERATE_TYPE.UNIT_LOOT then
--				if tTab.interaction~=nil and (hApi.HaveValue(tTab.interaction,hVar.INTERACTION_TYPE.LOOT) or hApi.HaveValue(tTab.interaction,hVar.INTERACTION_TYPE.PICK))then
--					hGlobal.event:call("Event_HeroLoot",w,oArriveUnit,t)
--				end
--			elseif nOperate==hVar.OPERATE_TYPE.UNIT_VISIT then
--				if tTab.interaction~=nil and hApi.HaveValue(tTab.interaction,hVar.INTERACTION_TYPE.VISIT) then
--					hGlobal.event:call("Event_HeroVisit",w,oArriveUnit,t)
--				end
--			--elseif nOperate==hVar.OPERATE_TYPE.UNIT_CAPTURE then
--				--if t.data.team~=0 and u:getowner():allience(t:getowner())~=hVar.PLAYER_ALLIENCE_TYPE.ALLY then
--					--local tgrData = oTarget:gettriggerdata()
--					--if type(tgrData)=="table" and tgrData.surrender==1 then
--						--if type(nOperateId)~="number" then
--							--nOperateId = 0
--						--end
--						--hGlobal.event:call("Event_HeroCaptureEnemy",w,u,t,nOperateId)
--					--else
--						--hGlobal.event:call("Event_HeroAttackEnemy",w,u,t)
--					--end
--				--end
--			elseif nOperate==hVar.OPERATE_TYPE.UNIT_ATTACK or nOperate==hVar.OPERATE_TYPE.AI_UNIT_ATTACK then
--				if u:getowner():allience(t:getowner())~=hVar.PLAYER_ALLIENCE_TYPE.ALLY then
--					hGlobal.event:call("Event_HeroAttackEnemy",w,u,t)
--				end
--			elseif nOperate==hVar.OPERATE_TYPE.UNIT_ENTER then
--				_DEBUG_MSG("进入城池")
--				local oTown = t:gettown()
--				if oTown~=nil then
--					return hGlobal.event:call("Event_HeroEnterTown",w,u,t,oTown)
--				end
--			elseif nOperate==hVar.OPERATE_TYPE.UNIT_OCCUPY then
--				_DEBUG_MSG("占领建筑！")
--				local oTown = t:gettown()
--				--可被占据的或者可进入的城池都可以被占据
--				if oTown~=nil or tTab.seizable==1 then
--					local allience = u:getowner():allience(t:getowner())
--					if allience==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
--						_DEBUG_MSG("不能占领属于自己的建筑")
--					elseif allience==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
--						_DEBUG_MSG("不能占领盟友的建筑")
--					else
--						if oTown~=nil then
--							--城只能攻打
--							return hGlobal.event:call("Event_HeroAttackEnemy",w,u,t)
--						else
--							return hGlobal.event:call("Event_HeroOccupy",w,u,t)
--						end
--					end
--				else
--					_DEBUG_MSG("该建筑不可被攻占")
--				end
--			elseif nOperate==hVar.OPERATE_TYPE.UNIT_JOIN then
--				--_DEBUG_MSG("英雄合并！")
--			elseif nOperate==hVar.OPERATE_TYPE.UNIT_TELEPORT then
--				local tgrData = oTarget:gettriggerdata()
--				if tgrData and tgrData.teleport then
--					local x,y = 0,0
--					--兼容老的地图格式，否则传送点会失效
--					if type(tgrData.teleport[1]) == "table" then
--						local rIndex = hApi.random(1,#tgrData.teleport)
--						x,y = tgrData.teleport[rIndex][1],tgrData.teleport[rIndex][2]
--					elseif type(tgrData.teleport[1]) == "number" then
--						x,y = tgrData.teleport[1],tgrData.teleport[2]
--					end
--					local toX,toY = self:xy2grid(x,y)
--					local oUnit = oArriveUnit
--					local ox,oy = oUnit:getXY()
--					oUnit:setgrid(toX,toY)
--
--					local cx,cy = oUnit:getXY()
--					local px,py = 0,1
--					--根据朝向，让英雄移动一个短的距离，来规避掉存档的问题，顺带摆正朝向
--					--|1 2 3|
--					--|4 * 5|
--					--|6 7 8|
--					local tDir = {
--						{-1,-1},{0,-1},{1,-1},
--						{-1,0},        {1,0},
--						{-1,1}, {0,1}, {1,1},
--					}
--					local tPos = tDir[hApi.calAngleD("DIRECTIONx8",hApi.angleBetweenPoints(ox,oy,cx,cy))]
--					if tPos then
--						px,py = unpack(tPos)
--					end
--					hApi.chaMoveTo(oUnit.handle,cx+px,cy+py,nil)
--					
--					local effx,effy = cx+px,cy+py
--					self:addeffect(12,2,nil,effx,effy)
--					hApi.setViewNodeFocus(effx,effy)
--					if type(tgrData.talk)=="table" then
--						local vTalk = hApi.InitUnitTalk(oTarget,oUnit,tgrData.talk,"teleport")
--						if vTalk and hGlobal.UI.CreateUnitTalk then
--							hGlobal.UI.CreateUnitTalk(vTalk)
--						end
--					end
--				end
--			elseif nOperate==hVar.OPERATE_TYPE.UNIT_WDLD_ATK_BUILDING then
--				hVar.WDLD_ATK_Building.needNextBattleFinish = 1 --需要结果
--				hVar.WDLD_ATK_Building.attackU = u
--				--hVar.WDLD_ATK_Building.attackWhat = t
--				hVar.WDLD_ATK_Building.theWorld = self
--				hGlobal.event:call("Event_HeroAttackEnemy",self,u,self:tgrid2unit(t:gettriggerdata().guard[1]))
--			elseif nOperate==hVar.OPERATE_TYPE.UNIT_DEFENSE then--去守卫
--				--弹出上一个守卫英雄
--				--if t.chaUI[t.data.triggerID.."GBG"] then
--					--hApi.safeRemoveT(t.chaUI,t.data.triggerID.."GBG")
--				--end
--				--if t.chaUI[t.data.triggerID.."GIcon"] then
--					--hApi.safeRemoveT(t.chaUI,t.data.triggerID.."GIcon")
--				--end
--				--local lgtid = t:gettriggerdata().guard[1]
--				--if lgtid ~= 0 then
--					--local lgu = w:tgrid2unit(lgtid)
--					--if lgu ~= nil then
--						--lgu:sethide(0)
--					--end
--				--end
--				self:WDLD_RemoveLastGuard(t)
--				--------------------
--
--
--				w:enumunit(function(eu)
--					local tgrData = eu:gettriggerdata()
--					if tgrData ~= nil and tgrData.guard then
--						if tgrData.guard[1] == u.data.triggerID then
--							tgrData.guard = nil
--						end
--					end
--				end)
--				
--				w:WDLD_BuildingSetGuard(t,u)
--
--				local oUnitOld = nil
--				--for k,v in pairs(hGlobal.LocalPlayer.localdata.focusUnitT) do
--				for k,v in pairs(w:GetPlayerMe().localdata.focusUnitT) do
--					oUnitOld = hApi.GetObject(v)
--					if oUnitOld~=nil then
--						hApi.chaShowPath(oUnitOld.handle,0)
--					end
--				end
--				w:GetPlayerMe().localdata.focusUnitT = {}--清除焦点
--			end
--		end
--	elseif w.data.type=="battlefield" then
--		local a = d.aura
--		if a.i>0 and u.data.IsDead~=1 then
--			--刷新角色的光环位置
--			if u.data.auraCount>0 then
--				self:updateaurarect(u)
--			elseif u.data.type==hVar.UNIT_TYPE.UNIT or u.data.type==hVar.UNIT_TYPE.HERO then
--				--判断是否允许接受光环，对建筑无效
--				self:reloadaura(u,1)
--			end
--		end
--	end
--end


local __CODE__InitAuraRect = function(nAuraUnique,oUnit,oUnitC,nSkillId,sBuffName,rMin,rMax,gridX,gridY)
	if sBuffName=="count" then
		_DEBUG_MSG("[LOGIC ERROR]不允许使用'n'作为光环的key!强行转换为'error'")
		sBuffName = "error"
	end
	local tAuraData = {
		[1] = nAuraUnique,
		[2] = hApi.SetObjectEx({},oUnit),
		[3] = {nSkillId,sBuffName,sBuffName.."|"..oUnit.data.owner},
		[4] = {0,0,gridX,gridY,rMin,rMax},
		[5] = {},
	}
	if oUnitC~=nil then
		local tParam = tAuraData[4]
		tParam[1] = oUnitC.ID
		tParam[2] = oUnitC.__ID
		tParam[3] = oUnitC.data.gridX
		tParam[4] = oUnitC.data.gridY
	end
	return tAuraData
end
local __CODE__UpdateAuraRect = function(oWorld,tAuraData,IsUpdate)
	local tAuraRect = oWorld.data.aurarect
	local nAuraUnique = tAuraData[1]
	local nSkillId = tAuraData[3][1]
	local sBuffName = tAuraData[3][3]
	local tParam = tAuraData[4]
	local tAuraGrid = tAuraData[5]
	local nAuraMode = 0
	for i = #tAuraGrid,1,-1 do
		local k = tAuraGrid[i]
		tAuraGrid[i] = nil
		if tAuraRect[k] then
			local v = tAuraRect[k]
			v.n = v.n - 1
			v[nAuraUnique] = 0
			v[sBuffName] = (v[sBuffName] or 0)-1
		end
	end
	if IsUpdate==-1 then
		return
	end
	local tTempGrid = {}
	if tParam[1]~=0 then
		local oUnitC = hApi.GetObjectEx(hClass.unit,tParam)
		if oUnitC~=nil then
			nAuraMode = 1
			tParam[3] = oUnitC.data.gridX
			tParam[4] = oUnitC.data.gridY
			local rMin,rMax = tParam[5],tParam[6]
			oWorld:gridinunitrange(tTempGrid,oUnitC,rMin,rMax)
		end
	else
		nAuraMode = 2
		local gridX,gridY = tParam[3],tParam[4]
		local rMin,rMax = tParam[5],tParam[6]
		oWorld:gridinrange(tTempGrid,gridX,gridY,rMin,rMax)
	end
	if #tTempGrid>0 then
		for i = 1,#tTempGrid do
			local k = tTempGrid[i].x.."|"..tTempGrid[i].y
			tAuraGrid[i] = k
			if tAuraRect[k]==nil then
				tAuraRect[k] = {n=0}
				v = tAuraRect[k]
			end
			local v = tAuraRect[k]
			v.n = v.n + 1
			v[nAuraUnique] = 1
			v[sBuffName] = (v[sBuffName] or 0)+1
		end
	end
	local oUnit = hApi.GetObjectEx(hClass.unit,tAuraData[2])
	if oUnit~=nil and IsUpdate==1 and nAuraMode~=0 then
		--刷新附近单位身上的光环
		if nAuraMode==1 then
			local oUnitC = hApi.GetObjectEx(hClass.unit,tParam)
			local rMin,rMax = tParam[5],tParam[6]
			oWorld:enumunitUR(oUnitC,rMin,rMax,function(oTarget,oUnit,_,oWorld)
				if oTarget.data.type==hVar.UNIT_TYPE.UNIT or oTarget.data.type==hVar.UNIT_TYPE.HERO then
					if hApi.IsSafeTarget(oUnit,nSkillId,oTarget)==hVar.RESULT_SUCESS then
						oWorld:reloadaura(oTarget,0)
					end
				end
			end,oUnit)
		elseif nAuraMode==2 then
			local gridX,gridY = tParam[3],tParam[4]
			local rMin,rMax = tParam[5],tParam[6]
			oWorld:enumunitR(gridX,gridY,rMin,rMax,function(oTarget,oUnit,_,oWorld)
				if oTarget.data.type==hVar.UNIT_TYPE.UNIT or oTarget.data.type==hVar.UNIT_TYPE.HERO then
					if hApi.IsSafeTarget(oUnit,nSkillId,oTarget)==hVar.RESULT_SUCESS then
						oWorld:reloadaura(oTarget,0)
					end
				end
			end,oUnit)
		end
	end
end
--在世界上添加一个光环区域
_hw.addaura = function(self,oAction,oUnit,gridX,gridY,nSkillId,rMin,rMax,sBuffName)
	local tAura = self.data.aura
	local unitName = "ground"
	local nAuraMode = 0
	if oUnit~=nil then
		unitName = oUnit.data.id
	end
	print("添加光环技能,id="..nSkillId.." oUnit="..unitName)
	--oAction非法时不添加光环
	if oAction==nil or oAction.ID==0 then
		return
	end
	--指定单位中心，且oUnit非法时不添加光环
	if oUnit~=nil and (oUnit.ID==0 or oUnit.data.IsDead==1) then
		return
	end
	hApi.SortTableI(tAura,1)
	tAura.__count = tAura.__count + 1
	local nAuraUnique = tAura.__count
	--设置此技能物体的光环标记
	oAction.data.IsAura = nAuraUnique
	if oUnit~=nil then
		nAuraMode = 1
		oUnit.data.auraCount = oUnit.data.auraCount + 1
		tAura.i = tAura.i + 1
		tAura[tAura.i] = __CODE__InitAuraRect(nAuraUnique,oAction.data.unit,oUnit,nSkillId,sBuffName,rMin,rMax,0,0)
	else
		nAuraMode = 2
		tAura.i = tAura.i + 1
		tAura[tAura.i] = __CODE__InitAuraRect(nAuraUnique,oAction.data.unit,nil,nSkillId,sBuffName,rMin,rMax,gridX,gridY)
	end
	if oAction.data.CastOrder==hVar.ORDER_TYPE.SYSTEM_FIRST_ROUND then
		--如果是首回合添加的光环，那么等战场开始后会对所有单位刷新一次光环，这里就不立刻刷新了
		__CODE__UpdateAuraRect(self,tAura[tAura.i],0)
	else
		__CODE__UpdateAuraRect(self,tAura[tAura.i],1)
	end
end

local __ENUM__ReloadAuraForAllUnit = function(oTarget,nLoadMode,_,oWorld)
	if oTarget.data.type==hVar.UNIT_TYPE.UNIT or oTarget.data.type==hVar.UNIT_TYPE.HERO then
		oWorld:reloadaura(oTarget,nLoadMode)
	end
end

local __ENUM__RemoveAuraOnUnit = function(oAction,oWorld,_,oUnit)
	if oAction.data.IsAura~=0 then
		local nAuraUnique = oAction.data.IsAura
		oAction.data.IsAura = 0
		if type(nAuraUnique)=="number" then
			return oWorld:removeaura(nAuraUnique)
		end
	end
end
--移除光环
_hw.removeaura = function(self,nAuraUnique_or_oUnit)
	local case = type(nAuraUnique_or_oUnit)
	if case=="table" then
		local oUnit = nAuraUnique_or_oUnit
		if oUnit.ID~=0 and oUnit.data.auraCount>0 then
			oUnit:enumbuff(__ENUM__RemoveAuraOnUnit,self)
			return self:enumunit(__ENUM__ReloadAuraForAllUnit,0)
		end
	elseif case=="number" then
		local nAuraUnique = nAuraUnique_or_oUnit
		local tAura = self.data.aura
		local tAuraData
		for i = 1,tAura.i,1 do
			if tAura[i]~=0 and tAura[i][1]==nAuraUnique then
				tAuraData = tAura[i]
				tAura[i] = 0
				break
			end
		end
		if tAuraData then
			hApi.SortTableI(tAura,1)
			local tParam = tAuraData[4]
			if tParam[1]~=0 then
				local oUnitC = hApi.GetObjectEx(hClass.unit,tParam)
				if oUnitC then
					oUnitC.data.auraCount = oUnitC.data.auraCount - 1
				end
			end
			return __CODE__UpdateAuraRect(self,tAuraData,-1)
		end
	end
end

--刷新光环的作用区域
_hw.updateaurarect = function(self,oUnit)
	if oUnit and oUnit.data.auraCount>0 then
		local tAura = self.data.aura
		for i = 1,tAura.i do
			local v = tAura[i]
			if v and v~=0 and v[4][1]==oUnit.ID and v[4][2]==oUnit.__ID then
				__CODE__UpdateAuraRect(self,v,0)
			end
		end
		return self:enumunit(__ENUM__ReloadAuraForAllUnit,1)
	end
end

local __ENUM__CheckAuraForUnit = function(oAction,tBuffToRemove,tAuraRect)
	local d = oAction.data
	if d.IsAuraBuff~=0 and type(d.IsBuff)=="string" then
		for i = 1,#tBuffToRemove.gridI do
			local v = tAuraRect[tBuffToRemove.gridI[i]]
			if v and (v[d.IsBuff.."|"..d.owner] or 0)>0 then
				return
			end
		end
		tBuffToRemove[#tBuffToRemove+1] = oAction
	end
end
_hw.reloadaura = function(self,oTarget,IsImmediateAdd)
	local oRound = self:getround()
	if not(hApi.IsUnitAlive(oTarget) and oRound~=nil) then
		return
	end
	local tAura = self.data.aura
	local tAuraRect = self.data.aurarect
	local tGridI = {}
	local tStandGrid = oTarget:getgrid()
	for i = 1,#tStandGrid do
		tGridI[#tGridI+1] = tStandGrid[i].x.."|"..tStandGrid[i].y
	end
	local tBuffToRemove = {gridI = tGridI}
	oTarget:enumbuff(__ENUM__CheckAuraForUnit,tBuffToRemove,tAuraRect)
	local tLog = {}
	--移除已经不在光环范围内的buff
	if #tBuffToRemove>0 then
		for i = 1,#tBuffToRemove do
			local oBuff = tBuffToRemove[i]
			oBuff.data.IsBuff = -1
			oBuff.data.IsPaused = 0
			oBuff:go("continue",1)
		end
	end
	if IsImmediateAdd==-1 then
		--不添加新的光环
	elseif oRound.data.auto==1 then
		--只有在自动模式下才允许添加新的光环
		local tBuffName = {}
		--尝试添加新的光环
		for i = 1,tAura.i do
			for x = 1,#tGridI do
				local k = tGridI[x]
				if tAuraRect[k] and tAuraRect[k].n>0 then
					local tAuraData = tAura[i]
					if tAuraData and tAuraData~=0 and tAuraRect[k][tAuraData[1]]==1 then
						local nAuraUnique = tAuraData[1]
						local nSkillId = tAuraData[3][1]
						local sBuffName = tAuraData[3][2]
						if tBuffName[sBuffName]==1 then
							--已经有这个光环了，跳过
						elseif oTarget:getbuff(sBuffName) then
							--已经有这个光环了，跳过
						else
							--添加这个光环
							local oUnit = hApi.GetObjectEx(hClass.unit,tAuraData[2])
							if oUnit and hApi.IsSafeTarget(oUnit,nSkillId,oTarget)==hVar.RESULT_SUCESS then
								tBuffName[sBuffName] = 1
								if IsImmediateAdd==1 then
									--插队模式
									oRound:autoorder(-1,oUnit,hVar.ORDER_TYPE.SYSTEM,hVar.OPERATE_TYPE.AURA_TO_UNIT,oTarget,nSkillId,nAuraUnique,sBuffName)
								else
									--排队模式
									oRound:autoorder(0,oUnit,hVar.ORDER_TYPE.SYSTEM,hVar.OPERATE_TYPE.AURA_TO_UNIT,oTarget,nSkillId,nAuraUnique,sBuffName)
								end
							end
						end
					end
				end
			end
		end
	end
end

---------------------------------------------------------

_hw.n2grid = function(self,n)
	return math.mod(n,self.data.w),math.floor(n/self.data.w)
end

_hw.grid2n = function(self,x,y)
	return x+y*self.data.w
end
---------------------------------------------------------------------
-- 画出地形网格
_hw.drawgrid = function(self,drawTag,maskColor,gridTable,withoutMask,zOrder)
	local d = self.data
	local h = self.handle
	if drawTag=="mask" then
		return
	end
	if h._bn then
		drawTag = drawTag or "default"
		local g = hApi.GetWorldMapGridTable(h,drawTag)
		if maskColor=="clear" then
			for k,v in pairs(g)do
				v:getParent():removeChild(v,true)
				g[k] = nil
			end
			if drawTag=="default" then
				h.gridMaskColor = 0
			end
		elseif maskColor=="show" then
			if drawTag=="default" and d.IsDrawGrid==0 then
				return
			end
			local m = hApi.GetWorldMapGridTable(h,"mask")
			for k,v in pairs(g)do
				if m[k]==1 then
					g[k]:setVisible(true)
				end
			end
		elseif maskColor=="hide" then
			for k,v in pairs(g)do
				g[k]:setVisible(false)
			end
		elseif maskColor=="reset" then
			local m = hApi.GetWorldMapGridTable(h,"mask")
			for k,v in pairs(m)do
				m[k] = 1
			end
		else
			maskColor = maskColor or "gray"
			if drawTag=="default" then
				local m = hApi.GetWorldMapGridTable(h,"mask")
				local ClearOtherGrid = 1
				if type(gridTable)=="table" then
					_DEBUG_MSG("[LUA WARNING]尝试以 default 模式显示若干网格！->"..tostring(maskColor))
				else
					if gridTable=="unclear" then
						ClearOtherGrid = 0
					end
				end
				if ClearOtherGrid==1 then
					for k in pairs(h.grid) do
						if k~="default" and k~="mask" then
							self:drawgrid(k,"clear")
						end
					end
					for k in pairs(m)do
						m[k] = 1
					end
				end
				if d.IsDrawGrid==0 then
					return self:drawgrid("default","hide")
				end
				if h.gridMaskColor==maskColor then
					return self:drawgrid("default","show")
				else
					self:drawgrid("default","clear")
				end
				h.gridMaskColor = maskColor
				for i = 0,d.w*d.h - 1,1 do
					local _gx,_gy = self:n2grid(i)
					local gx,gy = self:safeGrid(_gx,_gy)
					if gx==_gx and gy==_gy then
						local wx,wy = self:grid2xy(gx,gy,"LT")
						local s = hApi.SpriteBatchNodeAddChild(h,maskColor,"MC",d.gridMaskW,d.gridMaskH)
						if s then
							s:setPosition(wx+d.gridMaskOffsetX,-1*wy+d.gridMaskOffsetY)
							s:setAnchorPoint(ccp(0,1))
							g[i] = s
							if ClearOtherGrid==1 then
								m[i] = 1
							else
								m[i] = m[i] or 1
								if m[i]==0 then
									s:setVisible(false)
								end
							end
						end
					end
				end
			elseif type(gridTable)=="table" then
				local m = hApi.GetWorldMapGridTable(h,"mask")
				self:drawgrid(drawTag,"clear")
				if type(zOrder)~="number" then
					zOrder = nil
				end
				local _grid = hApi.GetWorldMapGridTable(h,"default")
				for i = 1,(gridTable.n or #gridTable),1 do
					local v = gridTable[i]
					local gx,gy = v.x,v.y
					local wx,wy = self:grid2xy(gx,gy,"LT")
					local s = hApi.SpriteBatchNodeAddChild(h,maskColor,"MC",d.gridMaskW,d.gridMaskH,nil,nil,nil,zOrder)
					if s then
						s:setPosition(wx+d.gridMaskOffsetX,-1*wy+d.gridMaskOffsetY)
						s:setAnchorPoint(ccp(0,1))
						g["gridMask_"..i] = s
						local n = self:grid2n(gx,gy)
						if withoutMask~="unrecord" and withoutMask~="unclear" then
							m[n] = 0
						end
						if _grid[n] and withoutMask~="unclear" then
							_grid[n]:setVisible(false)
						end
					end
				end
			else
				_DEBUG_MSG("[LUA WARNING]以未指定坐标的标签 "..drawTag.." 显示网格！")
			end
		end
	end
end

--==================================
-- AxFunc
--==================================
local __AxTable = {}
local __GridFunc = {}
local __GridFuncIndex = {}
__GridFunc[1] = hGlobal.GridFunc["Ax4"]
__GridFuncIndex["Ax4"] = 1
__AxTable[__GridFuncIndex["Ax4"]] = 1
for k,v in pairs(hGlobal.GridFunc)do
	if k~="Ax4" then
		local i = #__GridFunc + 1
		__GridFuncIndex[k] = i
		__GridFunc[i] = hGlobal.GridFunc[k]
	end
end
__loadGridMode = function(self,gridtype)
	if type(__GridFuncIndex[gridtype])=="number" then
		self.handle.__gridtype = __GridFuncIndex[gridtype]
	else
		self.handle.__gridtype = 1
	end
end

_hw.Ax = function(self)
	return __AxTable[self.handle.__gridtype or 1]
end

_hw._gridfunc = function(self)
	return __GridFunc[self.handle.__gridtype or 1]
end
-------------------------------------------------
--------------------------------------------------
-- Ax4
--------------------------------------------------
__AxTable[__GridFuncIndex["Ax4"]] = hApi.InitAxFunc(hGlobal.GridFunc["Ax4"],hGlobal.AxBasic:new({
	name = "Ax4",
	nearNode = {
		--这里表示是四方向搜索格子，如果需要多方向寻路请扩展
		--{x偏移，y偏移，移动权值G}
		{0,-1,10},
		{-1,0,10},
		{1,0,10},
		{0,1,10},
		--打开下面的就变成八方向了
		--{-1,-1,14},
		--{-1,1,14},
		--{1,-1,14},
		--{1,1,14},
	},
	getNearNode = function(self,n,x,y)
		return self.nearNode
	end,
}),nil,nil)

--------------------------------------------------
-- Ax6e
--------------------------------------------------
--  * *      1 2 (3)
-- * * *    4 5 6
--  * *      7 8 (9)
__AxTable[__GridFuncIndex["Ax6e"]] = hApi.InitAxFunc(hGlobal.GridFunc["Ax6e"],hGlobal.AxBasic:new({
	name = "Ax6e",
	nearNode = {
		--标准行
		{-1,-1,10},
		{0,-1,10},
		{-1,0,10},
		{1,0,10},
		{0,1,10},
		{-1,1,10},
	},
	nearNodeR = {
		--右偏移行
		{0,-1,10},
		{1,-1,10},
		{-1,0,10},
		{1,0,10},
		{1,1,10},
		{0,1,10},
	},
	getNearNode = function(self,n,x,y)
		if math.mod(y,2)==0 then
			return self.nearNodeR
		else
			return self.nearNode
		end
	end,
	calV = hApi.Ax6calV(0),
	isNodeSafe = hApi.Ax6isNodeSafe(0),
}),0,0)

--------------------------------------------------
-- Ax6o
--------------------------------------------------
-- * * *     1 2 3
--  * *       4 5 (6)
-- * * *     7 8 9
__AxTable[__GridFuncIndex["Ax6o"]] = hApi.InitAxFunc(hGlobal.GridFunc["Ax6o"],hGlobal.AxBasic:new({
	name = "Ax6o",
	nearNode = {
		--标准行
		{-1,-1,10},
		{0,-1,10},
		{-1,0,10},
		{1,0,10},
		{0,1,10},
		{-1,1,10},
	},
	nearNodeR = {
		--右偏移行
		{0,-1,10},
		{1,-1,10},
		{-1,0,10},
		{1,0,10},
		{1,1,10},
		{0,1,10},
	},
	getNearNode = function(self,n,x,y)
		if math.mod(y,2)==1 then
			return self.nearNodeR
		else
			return self.nearNode
		end
	end,
	calV = hApi.Ax6calV(1),
	isNodeSafe = hApi.Ax6isNodeSafe(1),
}),1,1)
-------------------------------------------------
_hw.xy2grid = function(self,worldX,worldY)
	return self:_gridfunc().xy2grid(self,worldX,worldY)
end

_hw.grid2xy = function(self,gridX,gridY,IsLT)
	return self:_gridfunc().grid2xy(self,gridX,gridY,IsLT)
end

_hw.safeGrid = function(self,gridX,gridY)
	return self:_gridfunc().safeGrid(self,gridX,gridY)
end

_hw.IsSafeGrid = function(self,gridX,gridY)
	local x,y = self:_gridfunc().safeGrid(self,gridX,gridY)
	return x==gridX and y==gridY
end

_hw.distanceG = function(self,gridX,gridY,tGridX,tGridY,nVal)
	return self:_gridfunc().distanceG(self,gridX,gridY,tGridX,tGridY,nVal)
end

_hw.distanceU = function(self,oUnit,oTarget,nVal,gridX,gridY)
	local uB = oUnit:getblock()
	if type(uB)~="table" then
		uB = nil
	end
	local uX,uY = oUnit.data.gridX,oUnit.data.gridY
	local tB
	local tX,tY
	if type(oTarget)=="table" then
		if oTarget.ID~=nil then
			tB = oTarget:getblock()
			if type(tB)~="table" then
				tB = nil
			end
			tX,tY = oTarget.data.gridX,oTarget.data.gridY
		else
			tB = nil
			tX = oTarget.x
			tY = oTarget.y
		end
		if gridX and gridY then
			uX = gridX
			uY = gridY
		end
	elseif type(gridX)=="number" and type(gridY)=="number" then
		tX = gridX
		tY = gridY
	end
	if not(uX and uY and tX and tY) then
		return -1
	end
	if uB or tB then
		if uB and tB then
			local dis
			hApi.enumNearGrid(uX,uY,uB,function(cx,cy)
				hApi.enumNearGrid(tX,tY,tB,function(nx,ny)
					local v = self:_gridfunc().distanceG(self,cx,cy,nx,ny,nVal)
					if dis==nil or dis>v then
						dis = v
					end
				end)
			end)
			dis = dis or 0
			return dis
		elseif uB then
			local dis
			hApi.enumNearGrid(uX,uY,uB,function(cx,cy)
				local v = self:_gridfunc().distanceG(self,cx,cy,tX,tY,nVal)
				if dis==nil or dis>v then
					dis = v
				end
			end)
			dis = dis or 0
			return dis
		elseif tB then
			local dis
			hApi.enumNearGrid(tX,tY,tB,function(cx,cy)
				local v = self:_gridfunc().distanceG(self,cx,cy,uX,uY,nVal)
				if dis==nil or dis>v then
					dis = v
				end
			end)
			dis = dis or 0
			return dis
		end
	else
		return self:_gridfunc().distanceG(self,uX,uY,tX,tY,nVal)
	end
end

_hw.safeGridU = function(self,oUnit,gridX,gridY,availableNodeList)
	local d = self.data
	local ux,uy = oUnit.data.gridX,oUnit.data.gridY
	local gx,gy = self:safeGrid(gridX,gridY)
	if gridX==gx and gy==gridY then
		if gridX==ux and gridY==uy then
			return hVar.RESULT_SUCESS
		else
			local ax = self:Ax()
			local n = ax:grid2n(gridX,gridY,d.block.w)
			self:removeblockU(oUnit,ux,uy)
			local r = ax:checkBlockIN(n,d.block,oUnit:getblock(),availableNodeList)	--EFF BLOCK
			self:addblockU(oUnit,ux,uy)
			return r
		end
	else
		return hVar.RESULT_FAIL
	end
end

local __MoveGridCheckT = {1,3,5,999}
local __GetSafeMoveGrid = function(u,s)
	for i = 1,#s do
		local r = u:getmovegrid(s[i],1)
		if #r>0 then
			return r
		end
	end
end

_hw.standGridU = function(self,oUnit,gridX,gridY,worldX,worldY)
	local d = self.data
	local ux,uy = oUnit.data.gridX,oUnit.data.gridY
	local gx,gy = self:safeGrid(gridX,gridY)
	local rx,ry = 0,0
	local ax = self:Ax()
	local n = ax:grid2n(gx,gy,d.block.w)
	local sus
	if oUnit.data.IsDead==-1 then
		--单位尚未进入地图
		sus = ax:checkBlock(n,d.block,oUnit:getblock(),gx,gy)	--EFF BLOCK
	else
		--单位已经在地图上
		self:removeblockU(oUnit,ux,uy)
		sus = ax:checkBlock(n,d.block,oUnit:getblock(),gx,gy)	--EFF BLOCK
		self:addblockU(oUnit,ux,uy)
	end
	if sus==hVar.RESULT_SUCESS then
		rx,ry = gx,gy
	else
		if worldX==nil or worldY==nil then
			worldX,worldY = self:grid2xy(gx,gy)
		end
		local tG = __GetSafeMoveGrid(oUnit,__MoveGridCheckT)
		if tG and #tG>0 then
			local fDis
			local selectI = 0
			local cx,cy = oUnit:getstandXY()
			for i = 1,#tG do
				local wx,wy = self:grid2xy(tG[i].x,tG[i].y)
				local dis = (wx+cx-worldX)^2+(wy+cy-worldY)^2
				if fDis==nil or fDis>dis then
					fDis = dis
					selectI = i
				end
			end
			if tG[selectI]~=nil then
				rx,ry = tG[selectI].x,tG[selectI].y
			end
		end
	end
	return rx,ry
end

------------------------------------------------------------------------
------------------------------------------------------------------------

--_hw.findwayto = function(self,wayTable,unitBlock,gridX,gridY,tGridX,tGridY,isContiune)
	--return self:_gridfunc().findwayto(self,wayTable,unitBlock,gridX,gridY,tGridX,tGridY,isContiune)
--end

_hw.findunitwayto = function(self,wayTable,oUnit,tGridX,tGridY,isContiune)
	local gridX,gridY = oUnit.data.gridX,oUnit.data.gridY
	local ret = 0
	local IsFlyer = 0
	if oUnit.attr.IsFlyer>0 then
		IsFlyer = 1
	end
	if oUnit.data.IsDead==-1 then
		--单位尚未进入地图
		ret = rpcall(self:_gridfunc().findwayto,self,wayTable,oUnit:getblock(),gridX,gridY,tGridX,tGridY,isContiune,IsFlyer) or 0	--EFF BLOCK
	else
		--单位已经在地图上
		self:removeblockU(oUnit,gridX,gridY)
		ret = rpcall(self:_gridfunc().findwayto,self,wayTable,oUnit:getblock(),gridX,gridY,tGridX,tGridY,isContiune,IsFlyer) or 0	--EFF BLOCK
		self:addblockU(oUnit,gridX,gridY)
	end
	return ret
end

_hw.gridinrange = function(self,gridTable,gridX,gridY,rMin,rMax)
	return self:_gridfunc().gridinrange(self,gridTable,gridX,gridY,rMin,rMax)
end

--_hw.gridinreach = function(self,gridTable,gridX,gridY,rMax)
	--return self:_gridfunc().gridinreach(self,gridTable,gridX,gridY,rMax)
--end

_hw.gridinunitreach = function(self,gridTable,oUnit,rMax,IsFlyer)
	local gridX,gridY = oUnit.data.gridX,oUnit.data.gridY
	local ret = 0
	if oUnit.data.IsDead==-1 then
		--单位尚未进入地图
		ret = rpcall(self:_gridfunc().gridinreach,self,gridTable,gridX,gridY,rMax,oUnit:getblock(),IsFlyer) or 0	--EFF BLOCK
	else
		--单位已经在地图上
		self:removeblockU(oUnit,gridX,gridY)
		ret = rpcall(self:_gridfunc().gridinreach,self,gridTable,gridX,gridY,rMax,oUnit:getblock(),IsFlyer) or 0	--EFF BLOCK
		self:addblockU(oUnit,gridX,gridY)
	end
	return ret
end

_hw.gridinunitrange = function(self,gridTable,oUnit,rMin,rMax)
	local gridX,gridY = oUnit.data.gridX,oUnit.data.gridY
	return self:_gridfunc().gridinrange(self,gridTable,gridX,gridY,rMin,rMax,oUnit:getblock())
end

--_hw.selectgrid = function(self,mode,grid,wx,wy,randNum)
--	if mode=="near" then
--		local dis = 0
--		--local wx,wy = self:grid2xy(x,y)
--		local rx,ry,rv
--		local rand = 0
--		local pec = 1
--		if self.data.gridW~=0 then
--			pec = 1.2*self.data.gridH/self.data.gridW
--		end
--		if type(randNum)=="number" then
--			rand = math.abs(randNum)
--		end
--		for i = 1,(grid.n or #grid) do
--			local v = grid[i]
--			if v.x==x and v.y==y then
--				return x,y
--			else
--				local cx,cy = self:grid2xy(v.x,v.y)
--				local d = (pec*(cx-wx))^2+(cy-wy)^2
--				if rand~=0 then
--					d = d + hApi.random(0,rand) - hApi.getint(rand/2)
--				end
--				if dis==0 or dis>d then
--					dis = d
--					rx,ry = v.x,v.y
--					rv = v
--				end
--			end
--		end
--		return rx,ry,rv
--	elseif mode=="far" then
--		local dis = 0
--		--local wx,wy = self:grid2xy(x,y)
--		local rx,ry,rv
--		local rand = 0
--		local pec = 1
--		if self.data.gridW~=0 then
--			pec = self.data.gridH/self.data.gridW
--		end
--		if type(randNum)=="number" then
--			rand = math.abs(randNum)
--		end
--		for i = 1,(grid.n or #grid) do
--			local v = grid[i]
--			if v.x==x and v.y==y then
--				return x,y
--			else
--				local cx,cy = self:grid2xy(v.x,v.y)
--				local d = (pec*(cx-wx))^2+(cy-wy)^2
--				if rand~=0 then
--					d = d + hApi.random(0,rand) - hApi.getint(rand/2)
--				end
--				if dis<d then
--					dis = d
--					rx,ry = v.x,v.y
--					rv = v
--				end
--			end
--		end
--		return rx,ry,rv
--	end
--end

--检查技能目标是否合法
local __ENUM__CheckActionTarget = function(oAction)
	if oAction.data.target~=0 and oAction.data.target.ID==0 then
		oAction.data.target = 0
	end
	if oAction.data.targetC~=0 and oAction.data.targetC.ID==0 then
		oAction.data.targetC = 0
	end
	if oAction.data.unit~=0 and oAction.data.unit.ID==0 then
		_DEBUG_MSG("[LOGIC ERROR]技能施放者已死亡并且被移除，这不科学")
		oAction.data.IsBuff = -1
	end
end

--移除死亡单位
local __BF__RemoveUnitCount = 0
local __ENUM__UpdateWorldUnitBF = function(oUnit,nPlusTick)
	if oUnit.handle.removetime==-1 then
		--需要移除的单位
		__BF__RemoveUnitCount = __BF__RemoveUnitCount + 1
		oUnit.handle.removetime = 0
		return oUnit:del("safe")
	elseif oUnit.handle.removetime>0 then
		--仅隐藏的单位
		oUnit.handle.removetime = oUnit.handle.removetime - nPlusTick
		if oUnit.handle.removetime<=0 then
			oUnit.handle.removetime = 0
			oUnit:cleardata()
			oUnit:sethide(1)
		end
	end
end

--追帧流程
local __GoToNetFrameCount
__GoToNetFrameCount = function(self,nSysFrameCount,nFrameCount)
	local d = self.data
	local tNetData = d.netdata
	tNetData.framestart = tNetData.framestart - 1
	self:frameloopBF(nSysFrameCount,1)
	if tNetData.framecount<nFrameCount then
		return __GoToNetFrameCount(self,nSysFrameCount,nFrameCount)
	end
end

--战场循环
_hw.frameloopBF = function(self,nSysFrameCount,IsSpecialProcess)
	local d = self.data
	
	--geyachao:大地图放技能
	--action解析
	if hClass and hClass.action then
		if (d.IsPaused ~= 1) and d.tdMapInfo and (d.tdMapInfo.mapState < hVar.MAP_TD_STATE.PAUSE) then
			if not(hpcall(hClass.action.__updateAll, nSysFrameCount)) then
				self:pause(1,"BUG")
			end
		end
	end
	
	--[[
	if d.type~="battlefield" then
		return
	end
	local nFrameCount = nSysFrameCount
	local oRound = self:getround()
	--网络信息处理
	local tNetData = d.netdata
	if tNetData~=0 then
		hApi.PVPNetGo(self)
	end
	if d.PausedByWhat~="BUG" then
		if oRound then
			if oRound.data.LockFrameCount>0 then
				oRound.data.LockFrameCount = oRound.data.LockFrameCount - 1
			end
			--action解析
			if hClass and hClass.action then
				if not(hpcall(hClass.action.__updateAll,nFrameCount)) then
					self:pause(1,"BUG")
				end
			end
			--ActionLoop
			if oRound.data.codeActionLoop~=0 then
				if not(hpcall(oRound.data.codeActionLoop,oRound,nFrameCount)) then
					self:pause(1,"BUG")
				end
			end
			--AutoOrder
			if oRound.data.codeRoundLoop~=0 then
				if not(hpcall(oRound.data.codeRoundLoop,nFrameCount)) then
					self:pause(1,"BUG")
				end
			end
		end
		local nPlusTick = math.ceil(1000/hApi.GetFrameCountByTick(1000))
		--处理战场上的死亡单位
		__BF__RemoveUnitCount = 0
		if not(hpcall(hClass.world.enumunit,self,__ENUM__UpdateWorldUnitBF,nPlusTick)) then
			self:pause(1,"BUG")
		end
		--如果移除了任何死亡单位，那么将所有技能物体的target检查一遍
		if __BF__RemoveUnitCount>0 then
			hpcall(hClass.action.enum,hClass.action,__ENUM__CheckActionTarget)
		end
	end
	]]
end

--[[
_hw.newunitBF = function(self,oUnit,tAutoList)
	local d = self.data
	if tAutoList==nil then
		tAutoList = {}
	end
	--非战场没有这个
	if type(d.uniquecast)~="table" then
		return tAutoList
	end
	--计算单位是否在掩体内部
	if self:IsUnitCovered(oUnit)==hVar.RESULT_SUCESS then
		oUnit.data.IsCovered = 1
	else
		oUnit.data.IsCovered = 0
	end
	local nOwner = oUnit.data.owner
	if d.uniquecast[nOwner]==nil then
		d.uniquecast[nOwner] = {}
	end
	local tUniqueCast = d.uniquecast[nOwner]
	--自动执行一次进战场生效的技能
	local s = oUnit.attr.skill
	if s.num>0 then
		for i = 1,s.i do
			if type(s[i])=="table" then
				local id,lv = s[i][1],s[i][2]
				local tabS = hVar.tab_skill[id]
				if lv>0 and id~=0 and tUniqueCast[id]~=1 and tabS and tabS.cast_type==hVar.CAST_TYPE.AUTO then
					if tabS.unique==1 then
						tUniqueCast[id] = 1
					end
					hApi.InsertValueIntoTabForKey(tAutoList,1,{tabS.cast_sort or 10,oUnit,id,lv})
				end
			end
		end
	end
	return tAutoList
end
]]

_hw.autoorderBF = function(self,tAutoList)
	if type(tAutoList)=="table" and #tAutoList>0 then
		local oRound = self:getround()
		if oRound~=nil then
			for i = 1,#tAutoList do
				local _,u,id = unpack(tAutoList[i])
				oRound:autoorder(0,u,hVar.ORDER_TYPE.SYSTEM_FIRST_ROUND,hVar.OPERATE_TYPE.SKILL_AUTO,id)
			end
		end
	end
end

_hw.operateable = function(self)
	if self.data.unitcountM>0 then
		return hVar.RESULT_FAIL
	end
	if self.data.actioncount>0 then
		return hVar.RESULT_FAIL
	end
	if self.data.IsPaused==1 then
		return hVar.RESULT_FAIL
	end
	local oRound = self:getround()
	if oRound~=nil and oRound.data.auto==1 then
		return hVar.RESULT_FAIL
	end
	return hVar.RESULT_SUCESS
end

_hw.exit = function(self,why,tParam)
	if self.data.codeOnExit==1 then
		return
	else
		local code = self.data.codeOnExit
		self.data.codeOnExit = 1
		if code(self,why,tParam)==0 then
			self.data.codeOnExit = code
		end
	end
end

--根据战术卡是否重复，世界中也生成一份玩家战术卡数据，这份数据，只在世界生效战术技能的时候用到
local _settactics = function(self, force, player, tacticId, tacticlv, norepeat)
	
	local forceTactics = self.data.tactics[force]
	if not forceTactics then
		forceTactics = {}
	end
	
	--如果是不能重复的卡，则要遍历本势力方已有的卡
	if norepeat then
		local flag = false	--是否找到重复的
		local oldPobj = -1	--同样的卡存储的位置
		
		--遍历所有玩家的战术技能卡
		for player, playerTactics in pairs(forceTactics) do
			--如果找到重复的卡则退出
			if flag then
				break
			end
			--遍历玩家的所有战术技能卡
			for id, lv in pairs(playerTactics) do
				--找到了战术卡
				if id == tacticId then
					
					--如果新插入的等级大于已经插入的，则需要记录下老的位置
					if tacticlv > lv then
						oldPobj = player
					end
					
					--设置标志并退出
					flag = true
					break
				end
			end
		end
		
		--如果没找到重复的，或者找到重复的但等级比较小，则先插入一条新的
		if not flag then
			if not forceTactics[player] then
				forceTactics[player] = {}
			end
			
			local playerTactics = forceTactics[player]
			playerTactics[tacticId] = tacticlv
		end

		--删除老的,如果记录了oldPobj并且oldPobj不是当前player
		if oldPobj ~= -1 and oldPobj ~= player then
			if forceTactics[oldPobj] then
				forceTactics[oldPobj][tacticId] = nil
			end
		end
	else
		if not forceTactics[player] then
			forceTactics[player] = {}
		end
		
		local playerTactics = forceTactics[player]
		playerTactics[tacticId] = tacticlv
	end
end

--设置激活的战术卡片(玩家 战术技能卡列表)(目前是增加形式设置)
_hw.settactics = function(self, player, tTactics)
	local d = self.data
	local tmpPlayer
	if type(player) == "table" then
		tmpPlayer = player
	elseif type(player) == "number" then
		tmpPlayer = self:GetPlayer(player)
	end
	
	if not tmpPlayer then
		return
	end
	
	--更新释放屏蔽列表
	if (type(tTactics)=="table") then
		if (not d.tactics) or (d.tactics and d.tactics == 0) then
			d.tactics = {}
		end
		
		local force = player:getforce()
		if not d.tactics[force] then
			d.tactics[force] = {}
		end
		--for i = 1,hVar.PLAYER_ACTIVED_BFSKILL_NUM do
		for i = 1,#tTactics do
			if type(tTactics[i])=="table" then
				local id, lv, typeId = tTactics[i][1], tTactics[i][2], tTactics[i][3]
				local tabT = hVar.tab_tactics[id]
				--表存在并且不是主动释放类的才会进入筛选
				if tabT then
					--默认可重复
					local norepeat = tabT.norepeat
					if (tabT.activeSkill) then
						norepeat = false
					end
					
					----不是主动释放的卡，则不能重复
					--if (not tabT.activeSkill) then
					--	norepeat = true
					--end
					
					
					_settactics(self, force, player, id, lv, norepeat)
				end
			end
		end
	end
	
	--设置玩家的战术技能卡
	tmpPlayer:settactics(tTactics)
	
	--if (type(tTactics)=="table") then
	--	if d.tactics==0 then
	--		d.tactics = {}
	--	end
	--	d.tactics[nPlayerID] = {}
	--	for i = 1,hVar.PLAYER_ACTIVED_BFSKILL_NUM do
	--		if type(tTactics[i])=="table" then
	--			local id, lv, typeId = tTactics[i][1], tTactics[i][2], tTactics[i][3]
	--			d.tactics[nPlayerID][i] = {id, lv, typeId}
	--		else
	--			d.tactics[nPlayerID][i] = 0
	--		end
	--	end
	--else
	--	if (d.tactics ~= 0) then
	--		d.tactics[nPlayerID] = 0
	--	end
	--end
	
	--if (nPlayerID == 1) then
	--	--战术技能卡资源生效
	--	self:tacticsTakeEffect(nil)
	--	
	--	--战术技能卡对地图已有角色生效
	--	self:enumunit(function(u)
	--		self:tacticsTakeEffect(u)
	--	end)
	--end
	
	return
	--return hGlobal.event:event("LocalEvent_ReloadTacticsCard",1)
end

--获得激活的战术卡片
_hw.gettactics = function(self,pos)
	local player = self:GetPlayer(pos)
	if player then
		return player:gettactics()
	end
	
	--local d = self.data
	--if d.tactics~=0 and type(d.tactics[nPlayerID])=="table" then
	--	return d.tactics[nPlayerID]
	--end
end

--清除战术卡片
_hw.cleartactics = function(self,pos)
	local player = self:GetPlayer(pos)
	if player then
		return player:cleartactics()
	end
end

--检测重复，如果数据结构中有该卡，则不重复（可释放）
_hw.checkTacticsRepeat = function(self, force, player, id)
	local ret = true
	local d = self.data
	
	--判定是否重复，如果存在，说明不重复
	if force and player and d.tactics and type(d.tactics) == "table" and d.tactics[force] and d.tactics[force][player] and d.tactics[force][player][id] and d.tactics[force][player][id] > 0 then
		ret = false
	end
	
	return ret
end

--战术技能卡生效
_hw.tacticsTakeEffect = function(self, u)
	--print("tacticsTakeEffect", u and u.data.name)
	for i = 0, 22 do
		local player = self.data.PlayerList[i]
		if player then
			player:tacticsTakeEffect(self, u, true)
			--战术技能卡资源生效
			--player:tacticsTakeEffect(self, nil)
			
			--战术技能卡对地图已有角色生效
			--self:enumunit(function(u)
				--player:tacticsTakeEffect(self, u)
			--end)
		end
	end
end

--pvp添加所有的玩家的英雄单位（只在pvp初始生成英雄时使用）
_hw.addPlayerAllHeroUnit_PVP = function(self)
	for i = 1, 20 do
		local player = self.data.PlayerList[i]
		if player then
			player:addAllHeroUnit_PVP(self)
		end
	end
end

_hw.netlog = function(self,sLog)
	--geyachao: todo 暂时注释掉
	--[[
	local tNetData = self.data.netdata
	if tNetData~=0 then
		--EFF--print(sLog)
		local tNetLog = tNetData.netlog
		tNetLog[#tNetLog+1] = sLog
	end
	]]
end

--网络战场专用，上传log
_hw.c2llog = function(self,mode,sTittle)
	local tNetData = self.data.netdata
	if tNetData~=0 and type(tNetData.PlayerParam)=="table" and hGlobal.LocalPlayer~=nil then
		local tNetLog = tNetData.netlog
		local tMyNetData = tNetData.PlayerParam[hGlobal.LocalPlayer.data.playerId]
		if type(tMyNetData)=="table" then
			if mode=="sync_error" and tNetData.sync_error==1 then
				return hVar.RESULT_FAIL
			end
			if g_NetManager:isConnected() then
				local sHead = ""
				if type(sTittle)=="string" then
					sHead = sTittle.."\n"
				end
				local t = {
					"--ver:"..hVar.CURRENT_ITEM_VERSION..";",
					sHead,
				}
				t[#t+1] = "--"
				for i = 1,#hVar.PVP_NET_BF_SWITCH do
					local k = hVar.PVP_NET_BF_SWITCH[i]
					local v = tostring(tNetData.switch[k] or 0)
					t[#t+1] = "sw:"..k..":"..v..";"
				end
				t[#t+1] = "\n\n"
				for i = 1,#tNetLog do
					t[#t+1] = tNetLog[i]
					t[#t+1] = "\n"
				end
				if mode=="sync_error" then
					tNetData.sync_error = 1
					g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_LOG,hVar.PVP_LOG_TYPE.SYNC_ERROR,table.concat(t))
				elseif mode=="replay" then
					g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_LOG,hVar.PVP_LOG_TYPE.DUEL_REPLAY,table.concat(t))
				--elseif mode=="quick_replay" then
					--g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_LOG,hVar.PVP_LOG_TYPE.QUICK_REPLAY,table.concat(t))
				elseif mode=="npc_replay" then
					g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_LOG,hVar.PVP_LOG_TYPE.NPC_REPLAY,table.concat(t))
				elseif mode=="npc_rank_king" then
					g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_LOG,hVar.PVP_LOG_TYPE.NPC_RANK_KING,table.concat(t))
				end
				return hVar.RESULT_SUCESS
			end
		end
	end
	return hVar.RESULT_FAIL
end

--设置玩家列表
_hw.SetPlayerList = function(self,pList)
	
	if pList and type(pList) == "table" then
		for i = 1, #pList do
			local player = hClass.player:new({
				name = pList[i].name or "noname",
				playerId = pList[i].pid,
				dbid = pList[i].dbid,				--玩家dbid
				rid = pList[i].rid,				--玩家rid
				utype = pList[i].utype,				--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
				force = pList[i].force,				--势力
				pos = pList[i].pos,
			})
			--print("====================SetPlayerList", i, pList[i].force, pList[i].pos)
			player:setonline()
			
			self.data.PlayerList[pList[i].pos] = player
			self.data.PlayerDic[pList[i].pid] = pList[i].pos
			
			if pList[i].dbid == xlPlayer_GetUID() then
				self.data.PlayerMe = pList[i].pos
				player:setlocalplayer(1)
			end
			
			--local idx = #self.data.PlayerList + 1
			--self.data.PlayerList[idx] = player
			--self.data.PlayerDic[pList[i].pid] = idx
			--
			--if pList[i].dbid == xlPlayer_GetUID() then
			--	self.data.PlayerMe = idx
			--end
		end
	end

	--特殊势力初始化
	--神势力
	local player = hClass.player:new({
		name = "God",					--势力方
		playerId = -1,					--玩家id
		dbid = -1,					--玩家dbid
		rid = -1,					--玩家rid
		utype = 4,					--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
		force = 0,					--势力
		pos = 0,
	})
	self.data.PlayerList[0] = player

	--势力1
	local player = hClass.player:new({
		name = "势力1",					--势力方
		playerId = -1,					--玩家id
		dbid = -1,					--玩家dbid
		rid = -1,					--玩家rid
		utype = 4,					--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
		force = hVar.FORCE_DEF.SHU,					--势力
		pos = 21,
	})
	self.data.PlayerList[21] = player

	--势力2
	local player = hClass.player:new({
		name = "势力2",					--势力方
		playerId = -2,					--玩家id
		dbid = -2,					--玩家dbid
		rid = -2,					--玩家rid
		utype = 4,					--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
		force = hVar.FORCE_DEF.WEI,					--势力
		pos = 22,
	})
	self.data.PlayerList[22] = player

	--中立无敌意
	local player = hClass.player:new({
		name = "中立无敌意",				--势力方
		playerId = -3,					--玩家id
		dbid = -3,					--玩家dbid
		rid = -3,					--玩家rid
		utype = 4,					--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
		force = hVar.FORCE_DEF.NEUTRAL,					--势力
		pos = 23,
	})
	self.data.PlayerList[23] = player
	
	--中立有敌意
	local player = hClass.player:new({
		name = "中立有敌意",				--势力方
		playerId = -4,					--玩家id
		dbid = -4,					--玩家dbid
		rid = -4,					--玩家rid
		utype = 4,					--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
		force = hVar.FORCE_DEF.NEUTRAL_ENEMY,		--势力
		pos = 24,
	})
	self.data.PlayerList[24] = player
end

--获取玩家
_hw.GetPlayer = function(self, pos)
	if pos and pos >= 0 then
		return self.data.PlayerList[pos]
	end
end

--获取玩家
_hw.GetPlayerByID = function(self, pid)
	local idx = self.data.PlayerDic[pid]
	if idx and idx > 0 then
		return self.data.PlayerList[idx]
	end
end

--获取玩家bydbid
_hw.GetPlayerByDBID = function(self, dbid)
	for pos, player in pairs(self.data.PlayerList) do
		--local player = self.data.PlayerList[i]
		if player and player.data.dbid > 0 and player.data.dbid == dbid then
			return player
		end
	end
end

--获取自己的玩家对象
_hw.GetPlayerMe = function(self)
	local idx = self.data.PlayerMe
	if idx and idx > 0 then
		return self.data.PlayerList[idx]
	end
end

--获取上帝玩家对象
_hw.GetPlayerGod = function(self)
	return self.data.PlayerList[0]
end

--获取势力方
_hw.GetForce = function(self, force)
	if force == hVar.FORCE_DEF.SHU then
		return self.data.PlayerList[21]
	elseif force == hVar.FORCE_DEF.WEI then
		return self.data.PlayerList[22]
	elseif force == hVar.FORCE_DEF.NEUTRAL then
		return self.data.PlayerList[23]
	elseif force == hVar.FORCE_DEF.NEUTRAL_ENEMY then
		return self.data.PlayerList[24]
	elseif force == hVar.FORCE_DEF.GOD then
		return self.data.PlayerList[0]
	end
end


local AMPLITUDE = 10 --振幅（默认值）
local THICKNESS = 24 --厚度
local CURDETAIL = 10
local DISPLACEMENT = 20 --面片数（默认值）
--添加连接特效
--返回值: 唯一id（用于删除连接特效传入此id）
_hw.AddLinkEffect = function(self, oUnit, oTarget, strEffectFileName, udx, udy, tdx, tdy, amplitude)
	local d = self.data
	local h = self.handle
	
	--返回值: 唯一id（用于删除连接特效传入此id）
	local linkId = 0
	
	--存在活着的单位和目标
	if oUnit and oTarget and (oUnit.data.IsDead ~= 1) and (oTarget.data.IsDead ~= 1) then
		--计数器加1
		d.linkeffect_counter = d.linkeffect_counter + 1
		linkId = d.linkeffect_counter
		
		--生成数据
		local tParam = {}
		tParam.unit = oUnit
		tParam.unit_worldC = oUnit:getworldC()
		tParam.unit_dx = udx or 0
		tParam.unit_dy = udy or 0
		tParam.target = oTarget
		tParam.target_worldC = oTarget:getworldC()
		tParam.target_dx = tdx or 0
		tParam.target_dy = tdy or 0
		tParam.amplitude = amplitude or AMPLITUDE --振幅
		tParam.effect_fileName = strEffectFileName or "data/image/effect/daoguang04.png"
		tParam.spriteList = {} --贴图列表
		tParam.spriteNum = 0 --贴图数量
		
		--计算振幅
		local u1_x, u1_y = hApi.chaGetPos(oUnit.handle)
		local u1_bx, u1_by, u1_bw, u1_bh = oUnit:getbox() --包围盒
		local u1_center_x = u1_x + (u1_bx + u1_bw / 2) + tParam.unit_dx --中心点x位置
		local u1_center_y = u1_y + (u1_by + u1_bh / 2) + tParam.unit_dy --中心点y位置
		
		local u2_x, u2_y = hApi.chaGetPos(oTarget.handle)
		local u2_bx, u2_by, u2_bw, u2_bh = oTarget:getbox() --包围盒
		local u2_center_x = u2_x + (u2_bx + u2_bw / 2) + tParam.target_dx --中心点x位置
		local u2_center_y = u2_y + (u2_by + u2_bh / 2) + tParam.target_dy --中心点y位置
		local dis = math.sqrt((u1_center_x-u2_center_x)*(u1_center_x-u2_center_x)+(u1_center_y-u2_center_y)*(u1_center_y-u2_center_y))
		
		tParam.displacement = math.ceil(dis / 128 / 2) * DISPLACEMENT
		if (tParam.displacement < DISPLACEMENT) then
			tParam.displacement = DISPLACEMENT
		end
		--print("dis=", dis)
		--print("tParam.displacement=", tParam.displacement)
		
		--存储
		d.linkeffects[linkId] = tParam
	end
	
	return linkId
end

--删除连接特效
_hw.RemoveLinkEffect = function(self, linkId)
	local d = self.data
	local h = self.handle
	
	if linkId and (linkId > 0) then
		local tParam = d.linkeffects[linkId]
		
		--清除贴图控件
		if tParam then
			local spriteList = tParam.spriteList --贴图列表
			for i = 1, #spriteList, 1 do
				local pSprite = spriteList[i]
				self.handle.worldLayer:removeChild(pSprite, true)
			end
		end
		
		d.linkeffects[linkId] = nil
	end
end

--作者：jff316948714 
--来源：CSDN 
--原文：https://blog.csdn.net/xiefeifei316948714/article/details/42424275
--版权声明：本文为博主原创文章，转载请附上博文链接！
--绘制一段连接特效
local drawsingleline = function(world, x1, y1, x2, y2, tParam)
	local angle = GetFaceAngle(x1, y1, x2, y2) --角度制
	local dx = x1 - x2
	local dy = y1 - y2
	local dis = math.sqrt(dx * dx + dy * dy)
	
	--每绘制一次，数量加1
	local spriteNum = tParam.spriteNum
	spriteNum = spriteNum + 1
	tParam.spriteNum = spriteNum
	--print("spriteNum=", spriteNum)
	
	--一段连接特效
	if tParam.spriteList[spriteNum] then
		local pSprite = tParam.spriteList[spriteNum]
		pSprite:setPosition((x1+x2)/2, (y1+y2)/2)
		--pSprite:setContentSize(CCSizeMake(dis, THICKNESS))
		pSprite:setScaleX(dis / tParam.width)
		pSprite:setScaleY(THICKNESS / tParam.height)
		pSprite:setRotation(angle)
	else
		local texture = CCTextureCache:sharedTextureCache():textureForKey(tParam.effect_fileName)
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage(tParam.effect_fileName)
		end
		local size = texture:getContentSize()
		tParam.width = size.width
		tParam.height = size.height
		
		local pSprite = CCSprite:createWithTexture(texture, CCRectMake(0,0,tParam.width, tParam.height))
		--pSprite:setContentSize(CCSizeMake(985, 59))
		pSprite:setAnchorPoint(0.5, 0.5)
		world.handle.worldLayer:addChild(pSprite, 100000)
		
		tParam.spriteList[spriteNum] = pSprite
		
		pSprite:setPosition((x1+x2)/2, (y1+y2)/2)
		--pSprite:setContentSize(CCSizeMake(dis, THICKNESS))
		pSprite:setScaleX(dis / tParam.width)
		pSprite:setScaleY(THICKNESS / tParam.height)
		pSprite:setRotation(angle)
		
		CCTextureCache:sharedTextureCache():removeTexture(texture)
	end
end

--绘制连接特效
local drawLighting = nil
drawLighting = function(world, x1, y1, x2, y2, displace, tParam)
	if (displace < CURDETAIL) then
		drawsingleline(world, x1, y1, x2, y2, tParam)
	else
		local mid_x = (x2+x1)/2
		local mid_y = (y2+y1)/2
		mid_x = mid_x + (math.random(0, 1) - 0.5) * tParam.amplitude
		mid_y = mid_y + (math.random(0, 1) - 0.5) * tParam.amplitude
		
		drawLighting(world, x1, y1, mid_x, mid_y, displace/2, tParam)
		
		drawLighting(world, mid_x, mid_y, x2, y2, displace/2, tParam)
	end
end

--连接特效更新timer
_hw.__update_linkeffect_timer = function()
	local self = hGlobal.WORLD.LastWorldMap
	
	if (type(self) ~= "table") or (self.ID == 0) then
		return
	end
	
	local d = self.data
	local h = self.handle
	
	--依次更新每个连接特效(不是同步的方式)
	--for linkId = 1, d.linkeffect_counter, 1 do
	for linkId, tParam in pairs(d.linkeffects) do
		--local tParam = d.linkeffects[linkId]
		if tParam then
			local oUnit = tParam.unit
			local oTarget = tParam.target
			
			--检测单位的有效性
			if (oUnit == nil) or (oUnit == 0) or (oUnit.data.IsDead == 1) or (oUnit:getworldC() ~= tParam.unit_worldC) then
				--无效的连接特效，清除
				self:RemoveLinkEffect(linkId)
			elseif (oTarget == nil) or (oTarget == 0) or (oTarget.data.IsDead == 1) or (oTarget:getworldC() ~= tParam.target_worldC) then
				--无效的连接特效，清除
				self:RemoveLinkEffect(linkId)
			else
				local u1_x, u1_y = hApi.chaGetPos(oUnit.handle)
				local u1_bx, u1_by, u1_bw, u1_bh = oUnit:getbox() --包围盒
				local u1_center_x = u1_x + (u1_bx + u1_bw / 2) + tParam.unit_dx --中心点x位置
				local u1_center_y = u1_y + (u1_by + u1_bh / 2) + tParam.unit_dy --中心点y位置
				
				local u2_x, u2_y = hApi.chaGetPos(oTarget.handle)
				local u2_bx, u2_by, u2_bw, u2_bh = oTarget:getbox() --包围盒
				local u2_center_x = u2_x + (u2_bx + u2_bw / 2) + tParam.target_dx --中心点x位置
				local u2_center_y = u2_y + (u2_by + u2_bh / 2) + tParam.target_dy --中心点y位置
				
				--上一次的总数量
				local oldIdxNum = tParam.spriteNum
				
				--绘制前重置数量
				tParam.spriteNum = 0
				
				--绘制连接特效
				drawLighting(self, u1_center_x, -u1_center_y, u2_center_x, -u2_center_y, tParam.displacement, tParam)
				
				--删除多于的线
				for i = oldIdxNum, tParam.spriteNum + 1, -1 do
					local pSprite = tParam.spriteList[i]
					if pSprite then
						self.handle.worldLayer:removeChild(pSprite, true)
						tParam.spriteList[i] = nil
					end
				end
			end
		end
	end
end

local HOOK_HEAD_IMGPATH = "data/image/effect/hook_head2.png" --钩子头部图片
local HOOK_MIDDLE_IMGPATH = "data/image/effect/hook_middle2.png" --钩子身体图片
--添加钩子
--参数 beginAngle: 逆时针坐标系
--参数 flyTime: 单位(毫秒)
--返回值: 唯一id
_hw.AddHookEffect = function(self, oUnit, skillId, worldX, worldY, beginAngle, flySpeed, flyTime, targetType, hitSkillId, hitSkillLv, movetoSkillId, movetoSkillLv, strHeadFileName, headWidth, headHeight, strMiddleFileName, middleWidth, middleHeight)
	local d = self.data
	local h = self.handle
	
	hitSkillId = hitSkillId or 0
	hitSkillLv = hitSkillLv or 0
	movetoSkillId = movetoSkillId or 0
	movetoSkillLv = movetoSkillLv or 0
	strHeadFileName = strHeadFileName or HOOK_HEAD_IMGPATH
	headWidth = headWidth or 24
	headHeight = headHeight or 24
	strMiddleFileName = strMiddleFileName or HOOK_MIDDLE_IMGPATH
	middleWidth = middleWidth or 24
	middleHeight = middleHeight or 24
	
	--返回值: 唯一id
	local hookId = 0
	
	--存在活着的单位和目标
	if oUnit and (oUnit.data.IsDead ~= 1) then
		--计数器加1
		d.hookeffect_counter = d.hookeffect_counter + 1
		hookId = d.hookeffect_counter
		
		--钩子数据表
		local tHooks = {}
		
		local worldLayer = h.worldLayer
		--local angle = -beginAngle
		local angle = beginAngle
		if (angle < 0) then
			angle = angle + 360
		elseif (angle >= 360) then
			angle = 360 - angle
		end
		local fangle = (angle) * math.pi / 180 --弧度制
		fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
		
		--身体
		local texture = CCTextureCache:sharedTextureCache():textureForKey(strMiddleFileName)
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage(strMiddleFileName)
			--print("加载大图！")
		end
		--local tSizeMiddle = texture:getContentSize()
		local sprite = CCSprite:createWithTexture(texture)
		sprite:setAnchorPoint(ccp(0, 0.5))
		sprite:setPosition(ccp(worldX, -worldY))
		sprite:setRotation(-angle)
		worldLayer:addChild(sprite, 20)
		
		--计算头部坐标
		--local head_begin_x = worldX + tSizeMiddle.width * math.cos(fangle)
		--local head_begin_y = worldY - tSizeMiddle.width * math.sin(fangle)
		local head_begin_x = worldX + middleWidth * math.cos(fangle)
		local head_begin_y = worldY - middleWidth * math.sin(fangle)
		head_begin_x = math.floor(head_begin_x * 100) / 100 --保留2位有效数字，用于同步
		head_begin_y = math.floor(head_begin_y * 100) / 100 --保留2位有效数字，用于同步
		head_begin_x = math.floor(head_begin_x + 0.5) --四舍五入，用于同步
		head_begin_y = math.floor(head_begin_y + 0.5) --四舍五入，用于同步
		
		--存储身体
		tHooks.tMiddleSprites = {}
		local tSprit = {}
		tSprit.middle_sprite = sprite
		tSprit.middle_begin_x = worldX
		tSprit.middle_begin_y = worldY
		tSprit.middle_end_x = head_begin_x --结束x
		tSprit.middle_end_y = head_begin_y --结束y
		tSprit.middle_width = middleWidth --tSizeMiddle.width
		tSprit.middle_height = middleHeight --tSizeMiddle.height
		tSprit.middle_sprite_pos_x = worldX
		tSprit.middle_sprite_pos_y = worldY
		tSprit.middle_angle = angle
		tSprit.middle_fangle = fangle
		tHooks.tMiddleSprites[#tHooks.tMiddleSprites+1] = tSprit
		
		--头部
		local texture = CCTextureCache:sharedTextureCache():textureForKey(strHeadFileName)
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage(strHeadFileName)
			--print("加载大图！")
		end
		--local tSizeHead = texture:getContentSize()
		local sprite = CCSprite:createWithTexture(texture)
		
		sprite:setAnchorPoint(ccp(0, 0.5))
		sprite:setPosition(ccp(head_begin_x, -head_begin_y))
		sprite:setRotation(-angle)
		worldLayer:addChild(sprite, 20)
		
		--存储头部
		tHooks.head_sprite = sprite
		tHooks.head_width = headWidth --tSizeHead.width
		tHooks.head_height = headHeight --tSizeHead.height
		tHooks.head_pos_x = head_begin_x
		tHooks.head_pos_y = head_begin_y
		tHooks.head_angle = angle
		tHooks.head_fangle = fangle
		
		tHooks.middle_width = middleWidth
		tHooks.middle_height = middleHeight
		
		--存储控制参数
		tHooks.strHeadFileName = strHeadFileName
		tHooks.strMiddleFileName = strMiddleFileName
		tHooks.unit = oUnit
		tHooks.unit_worldC = oUnit:getworldC()
		tHooks.unit_pos = oUnit:getowner():getpos()
		tHooks.unit_force = oUnit:getowner():getforce()
		tHooks.target = 0
		tHooks.target_worldC = 0
		tHooks.flyAngle = angle
		tHooks.flySpeed = flySpeed
		tHooks.flyTimeMax = flyTime
		tHooks.flyTime = 0
		tHooks.skillId = skillId
		tHooks.hitSkillId = hitSkillId --命中的技能id
		tHooks.hitSkillLv = hitSkillLv --命中的技能lv
		tHooks.movetoSkillId = movetoSkillId --勾到身边的技能id
		tHooks.movetoSkillLv = movetoSkillLv --勾到身边的技能lv
		tHooks.targetType = targetType
		tHooks.hookId = hookId
		tHooks.direction = hVar.HOOK_DIRECTION_FRONT --向前运动
		
		local tabS = hVar.tab_skill[skillId] --技能表
		tHooks.cast_target_type = tabS.cast_target_type --有效的目标列表(效率优化)
		tHooks.cast_target_space_type = tabS.cast_target_space_type --技能可生效的目标的空间类型(效率优化)
		tHooks.collision_uidList = {} --一碰撞到的单位表
		
		--存储
		d.hookeffects[#d.hookeffects+1] = tHooks
	end
	
	return hookId
end

--删除钩子特效
_hw.__RemoveHookEffect = function(self, idx)
	local d = self.data
	local h = self.handle
	
	local tHooks = d.hookeffects[idx]
	
	--清除特效
	--清除身体
	local tMiddleSprites = tHooks.tMiddleSprites --贴图列表
	for i = 1, #tMiddleSprites, 1 do
		local pSpriteMiddle = tMiddleSprites[i].middle_sprite
		self.handle.worldLayer:removeChild(pSpriteMiddle, true)
	end
	
	--清除头部
	local pSpriteHead = tHooks.head_sprite
	self.handle.worldLayer:removeChild(pSpriteHead, true)
	
	--清除角色
	tHooks.unit = 0
	
	--清除表
	table.remove(d.hookeffects, idx)
end

--钩子特效更新timer
_hw.__update_hookeffect_timer = function(deltaTime)
	local self = hGlobal.WORLD.LastWorldMap
	
	if (type(self) ~= "table") or (self.ID == 0) then
		return
	end
	
	local d = self.data
	local h = self.handle
	local worldLayer = h.worldLayer
	
	--依次更新每个钩子特效(同步方式)
	for i = #d.hookeffects, 1, -1 do
		local tHooks = d.hookeffects[i]
		if tHooks then
			local oUnit = tHooks.unit --施法者
			local unit_worldC = tHooks.unit_worldC --施法者唯一id
			local unit_pos = tHooks.unit_pos --施法者所属upos
			local unit_force = tHooks.unit_force --施法者所属uforce
			--检测单位的有效性
			--if (oUnit == nil) or (oUnit == 0) or (oUnit.data.IsDead == 1) or (oUnit:getworldC() ~= tHooks.unit_worldC) then
			local direction = tHooks.direction --方向
			local angle = tHooks.flyAngle --角度
			local flySpeed = tHooks.flySpeed --速度
			local flyTimeMax = tHooks.flyTimeMax --最大生存时间
			local flyTime = tHooks.flyTime --当前生存时间
			local hookId = tHooks.hookId --唯一id
			local fangle = tHooks.head_fangle --弧度制
			local middleWidth = tHooks.middle_width
			local middleHeight = tHooks.middle_height
			local headWidth = tHooks.head_width
			local headHeight = tHooks.head_height
			--print(angle, fangle)
			
			--向前运动
			if (direction == hVar.HOOK_DIRECTION_FRONT) then
				--检测生存时间是否到了
				flyTime = flyTime + deltaTime
				tHooks.flyTime = flyTime
				
				if (flyTime <= flyTimeMax) then
					--print(angle, fangle)
					
					--头部往前运动一段距离
					local head_to_x = tHooks.head_pos_x + flySpeed * deltaTime * math.cos(fangle) / 1000
					local head_to_y = tHooks.head_pos_y - flySpeed * deltaTime * math.sin(fangle) / 1000
					head_to_x = math.floor(head_to_x * 100) / 100 --保留2位有效数字，用于同步
					head_to_y = math.floor(head_to_y * 100) / 100 --保留2位有效数字，用于同步
					head_to_x = math.floor(head_to_x + 0.5) --四舍五入，用于同步
					head_to_y = math.floor(head_to_y + 0.5) --四舍五入，用于同步
					tHooks.head_sprite:setPosition(ccp(head_to_x, -head_to_y))
					tHooks.head_pos_x = head_to_x
					tHooks.head_pos_y = head_to_y
					
					--检测身体是否继续上一个运动，还是需要新创建一个身体
					local tMiddleSprites = tHooks.tMiddleSprites
					local tSpritMiddle = tHooks.tMiddleSprites[#tHooks.tMiddleSprites] --取最前面的身体
					local middle_begin_x = tSpritMiddle.middle_begin_x
					local middle_begin_y = tSpritMiddle.middle_begin_y
					local middle_end_x = tSpritMiddle.middle_end_x
					local middle_end_y = tSpritMiddle.middle_end_y
					
					local middle_to_x = head_to_x - tSpritMiddle.middle_width * math.cos(fangle)
					local middle_to_y = head_to_y + tSpritMiddle.middle_width * math.sin(fangle)
					middle_to_x = math.floor(middle_to_x * 100) / 100 --保留2位有效数字，用于同步
					middle_to_y = math.floor(middle_to_y * 100) / 100 --保留2位有效数字，用于同步
					middle_to_x = math.floor(middle_to_x + 0.5) --四舍五入，用于同步
					middle_to_y = math.floor(middle_to_y + 0.5) --四舍五入，用于同步
					
					--检测是否未到达本段末尾
					local bInsideM = false
					local PI = math.floor(math.pi * 100) / 100 --保留2位有效数字，用于同步
					if (fangle >= 0) and (fangle <= PI/2) then --第一象限
						bInsideM = ((middle_to_x <= middle_end_x) and (middle_to_y >= middle_end_y))
						--print("第一象限", middle_to_x, middle_end_x, " ", middle_to_y, middle_end_y)
					elseif (fangle > PI/2) and (fangle <= PI) then --第二象限
						bInsideM = ((middle_to_x >= middle_end_x) and (middle_to_y >= middle_end_y))
						--print("第二象限", middle_to_x, middle_end_x, " ", middle_to_y, middle_end_y)
					elseif (fangle > PI) and (fangle <= PI*1.5) then --第三象限
						bInsideM = ((middle_to_x >= middle_end_x) and (middle_to_y <= middle_end_y))
						--print("第三象限", middle_to_x, middle_end_x, " ", middle_to_y, middle_end_y)
					elseif (fangle > PI*1.5) and (fangle < PI*2) then --第四象限
						bInsideM = ((middle_to_x <= middle_end_x) and (middle_to_y <= middle_end_y))
						--print("第四象限", middle_to_x, middle_end_x, " ", middle_to_y, middle_end_y)
					end
					
					if (not bInsideM) then
						--print("not bInsideM 原身体运动到终点")
						--原身体运动到终点
						tSpritMiddle.middle_sprite:setPosition(ccp(middle_end_x, -middle_end_y))
						tSpritMiddle.middle_sprite_pos_x = middle_end_x
						tSpritMiddle.middle_sprite_pos_y = middle_end_y
						
						--新身体
						local texture = CCTextureCache:sharedTextureCache():textureForKey(tHooks.strMiddleFileName)
						if (not texture) then
							texture = CCTextureCache:sharedTextureCache():addImage(tHooks.strMiddleFileName)
							--print("加载大图！")
						end
						--local tSizeMiddle = texture:getContentSize()
						local sprite = CCSprite:createWithTexture(texture)
						sprite:setAnchorPoint(ccp(0, 0.5))
						sprite:setPosition(ccp(middle_to_x, -middle_to_y))
						sprite:setRotation(-angle)
						worldLayer:addChild(sprite, 20)
						
						--存储身体
						--由于积累性误差，身体可能离头部越来越远，这里需要重新计算角度
						local new_angle = GetLineAngle(middle_begin_x, middle_begin_y, head_to_x, head_to_y)
						new_angle = 360 - new_angle
						local new_fangle = (new_angle) * math.pi / 180 --弧度制
						new_fangle = math.floor(new_fangle * 100) / 100  --保留2位有效数字，用于同步
						--local new_end_x = middle_end_x + tSizeMiddle.width * math.cos(new_fangle) --结束点x
						--local new_end_y = middle_end_y - tSizeMiddle.width * math.sin(new_fangle) --结束点y
						local new_end_x = middle_end_x + middleWidth * math.cos(new_fangle) --结束点x
						local new_end_y = middle_end_y - middleWidth * math.sin(new_fangle) --结束点y
						new_end_x = math.floor(new_end_x * 100) / 100 --保留2位有效数字，用于同步
						new_end_y = math.floor(new_end_y * 100) / 100 --保留2位有效数字，用于同步
						new_end_x = math.floor(new_end_x + 0.5) --四舍五入，用于同步
						new_end_y = math.floor(new_end_y + 0.5) --四舍五入，用于同步
						local tSprit = {}
						tSprit.middle_sprite = sprite
						tSprit.middle_begin_x = middle_end_x
						tSprit.middle_begin_y = middle_end_y
						tSprit.middle_end_x = new_end_x --结束点x
						tSprit.middle_end_y = new_end_y --结束点y
						tSprit.middle_width = middleWidth
						tSprit.middle_height = middleHeight
						tSprit.middle_sprite_pos_x = middle_to_x
						tSprit.middle_sprite_pos_y = middle_to_y
						tSprit.middle_angle = new_angle
						tSprit.middle_fangle = new_fangle
						tHooks.tMiddleSprites[#tHooks.tMiddleSprites+1] = tSprit
					else
						--原身体继续运动
						tSpritMiddle.middle_sprite:setPosition(ccp(middle_to_x, -middle_to_y))
						tSpritMiddle.middle_sprite_pos_x = middle_to_x
						tSpritMiddle.middle_sprite_pos_y = middle_to_y
					end
				else --生存时间到了
					--self:__RemoveHookEffect(i)
					--标记向后运动
					tHooks.direction = hVar.HOOK_DIRECTION_BACK --方向
				end
			--向后运动
			elseif (direction == hVar.HOOK_DIRECTION_BACK) then
				--最前面的身体
				local tMiddleSprites = tHooks.tMiddleSprites
				local tSpritMiddle = tHooks.tMiddleSprites[#tHooks.tMiddleSprites] --取最前面的身体
				local angle_middle = tSpritMiddle.middle_angle
				local fangle_middle = tSpritMiddle.middle_fangle
				local target = tHooks.target --目标
				local target_worldC = tHooks.target_worldC --目标唯一id
				local hitSkillId = tHooks.hitSkillId --命中的技能id
				local hitSkillLv = tHooks.hitSkillLv --命中的技能lv
				local movetoSkillId = tHooks.movetoSkillId --勾到身边的技能id
				local movetoSkillLv = tHooks.movetoSkillLv --勾到身边的技能lv
				
				--print(angle_middle, fangle_middle)
				
				--头部往后运动一段距离
				local head_to_x = tHooks.head_pos_x - flySpeed * deltaTime * math.cos(fangle_middle) / 1000
				local head_to_y = tHooks.head_pos_y + flySpeed * deltaTime * math.sin(fangle_middle) / 1000
				head_to_x = math.floor(head_to_x * 100) / 100 --保留2位有效数字，用于同步
				head_to_y = math.floor(head_to_y * 100) / 100 --保留2位有效数字，用于同步
				head_to_x = math.floor(head_to_x + 0.5) --四舍五入，用于同步
				head_to_y = math.floor(head_to_y + 0.5) --四舍五入，用于同步
				tHooks.head_sprite:setPosition(ccp(head_to_x, -head_to_y))
				tHooks.head_sprite:setRotation(-angle_middle)
				tHooks.head_pos_x = head_to_x
				tHooks.head_pos_y = head_to_y
				
				--检测身体是否继续后一个运动，还是需要删除一个身体
				local middle_begin_x = tSpritMiddle.middle_begin_x
				local middle_begin_y = tSpritMiddle.middle_begin_y
				local middle_to_x = head_to_x - tSpritMiddle.middle_width * math.cos(fangle_middle)
				local middle_to_y = head_to_y + tSpritMiddle.middle_width * math.sin(fangle_middle)
				middle_to_x = math.floor(middle_to_x * 100) / 100 --保留2位有效数字，用于同步
				middle_to_y = math.floor(middle_to_y * 100) / 100 --保留2位有效数字，用于同步
				middle_to_x = math.floor(middle_to_x + 0.5) --四舍五入，用于同步
				middle_to_y = math.floor(middle_to_y + 0.5) --四舍五入，用于同步
				
				--检测是否未到达本段起点
				local bInsideMB = false
				local PI = math.floor(math.pi * 100) / 100 --保留2位有效数字，用于同步
				if (fangle_middle >= 0) and (fangle_middle <= PI/2) then --第一象限
					bInsideMB = ((middle_to_x >= middle_begin_x) and (middle_to_y <= middle_begin_y))
					--print("B 第一象限", middle_to_x, middle_begin_x, " ", middle_to_y, middle_begin_y)
				elseif (fangle_middle > PI/2) and (fangle_middle <= PI) then --第二象限
					bInsideMB = ((middle_to_x <= middle_begin_x) and (middle_to_y <= middle_begin_y))
					--print("B 第二象限", middle_to_x, middle_begin_x, " ", middle_to_y, middle_begin_y)
				elseif (fangle_middle > PI) and (fangle_middle <= PI*1.5) then --第三象限
					bInsideMB = ((middle_to_x <= middle_begin_x) and (middle_to_y >= middle_begin_y))
					--print("B 第三象限", middle_to_x, middle_begin_x, " ", middle_to_y, middle_begin_y)
				elseif (fangle_middle > PI*1.5) and (fangle_middle < PI*2) then --第四象限
					bInsideMB = ((middle_to_x >= middle_begin_x) and (middle_to_y >= middle_begin_y))
					--print("B 第四象限", middle_to_x, middle_begin_x, " ", middle_to_y, middle_begin_y)
				end
				
				if (not bInsideMB) then
					--删除原身体
					--print("B 删除原身体")
					local pSprite = tSpritMiddle.middle_sprite
					self.handle.worldLayer:removeChild(pSprite, true)
					
					--删除原身体表
					tHooks.tMiddleSprites[#tHooks.tMiddleSprites] = nil
					
					--前一个身体移动到新位置
					if (#tHooks.tMiddleSprites > 0) then
						--原身体继续运动
						local tSpritMiddlePrev = tHooks.tMiddleSprites[#tHooks.tMiddleSprites] --取再前一个身体
						tSpritMiddlePrev.middle_sprite:setPosition(ccp(middle_to_x, -middle_to_y))
						tSpritMiddlePrev.middle_sprite_pos_x = middle_to_x
						tSpritMiddlePrev.middle_sprite_pos_y = middle_to_y
					else
						--没有身体了，死亡
						--print("没有身体了，死亡")
						self:__RemoveHookEffect(i)
						
						--目标解禁
						if (target == nil) or (target == 0) or (target.data.IsDead == 1) or (target:getworldC() ~= target_worldC) then
							--
						else
							--标记目标AI状态
							target:setAIState(hVar.UNIT_AI_STATE.IDLE)
							
							--解除目标眩晕、免控
							if (target.attr.stun_stack > 0) then
								target.attr.stun_stack = target.attr.stun_stack - 1
							end
							if (target.attr.immue_control_stack > 0) then
								target.attr.immue_control_stack = target.attr.immue_control_stack - 1
							end
							
							--勾到身边对目标释放技能
							if (movetoSkillId ~= 0) then
								--有效的施法者
								local oAttacker = nil
								if (oUnit:getworldC() == unit_worldC) and (oUnit.data.IsDead ~= 1) and (oUnit.attr.hp > 0) then --施法者没被复用，活着
									oAttacker = oUnit
								else
									oAttacker = self:GetPlayer(unit_pos):getgod()
								end
								
								--如果施法者还活着
								if oAttacker then
									local targetX, targetY = hApi.chaGetPos(target.handle) --目标的坐标
									local gridX, gridY = self:xy2grid(targetX, targetY)
									local tCastParam =
									{
										level = movetoSkillLv, --技能的等级
									}
									hApi.CastSkill(oAttacker, movetoSkillId, 0, nil, target, gridX, gridY, tCastParam)
								end
							end
						end
					end
				else
					--原身体继续运动
					tSpritMiddle.middle_sprite:setPosition(ccp(middle_to_x, -middle_to_y))
					tSpritMiddle.middle_sprite_pos_x = middle_to_x
					tSpritMiddle.middle_sprite_pos_y = middle_to_y
				end
				
				--检测是否勾中目标，目标跟随钩子头部运动
				if (target == nil) or (target == 0) or (target.data.IsDead == 1) or (target:getworldC() ~= target_worldC) then
					--
				else
					local bIngoreBlock = true --忽略障碍
					target:setPos(head_to_x, head_to_y, bIngoreBlock)
					--print("忽略障碍", target.data.name)
				end
			end
			
			--检测钩子尾部，是否需要新绘制以接近英雄
			if (oUnit == nil) or (oUnit == 0) or (oUnit.data.IsDead == 1) or (oUnit:getworldC() ~= tHooks.unit_worldC) then
				--不处理
			else
				--比较最末尾的身体
				if (#tHooks.tMiddleSprites > 0) then
					local tSpritMiddle1 = tHooks.tMiddleSprites[1]
					local m1x = tSpritMiddle1.middle_sprite_pos_x
					local m1y = tSpritMiddle1.middle_sprite_pos_y
					local m1w = tSpritMiddle1.middle_width
					local ux, uy = hApi.chaGetPos(oUnit.handle) --角色的坐标
					local dx = math.abs(ux - m1x)
					local dy = math.abs(uy - m1y)
					if (dx > m1w) or (dy > m1w) then
						local a1 = GetFaceAngle(ux, uy, m1x, m1y)
						--print("a1=", a1)
						--a1 = a1 + 180
						local fa1 = (a1) * math.pi / 180 --弧度制
						fa1 = math.floor(fa1 * 100) / 100  --保留2位有效数字，用于同步
						local m1_to_x = m1x - m1w * math.cos(fa1)
						local m1_to_y = m1y + m1w * math.sin(fa1)
						m1_to_x = math.floor(m1_to_x * 100) / 100 --保留2位有效数字，用于同步
						m1_to_y = math.floor(m1_to_y * 100) / 100 --保留2位有效数字，用于同步
						m1_to_x = math.floor(m1_to_x + 0.5) --四舍五入，用于同步
						m1_to_y = math.floor(m1_to_y + 0.5) --四舍五入，用于同步
						
						--新身体(新末尾)
						local texture = CCTextureCache:sharedTextureCache():textureForKey(tHooks.strMiddleFileName)
						if (not texture) then
							texture = CCTextureCache:sharedTextureCache():addImage(tHooks.strMiddleFileName)
							--print("加载大图！")
						end
						--local tSizeMiddle = texture:getContentSize()
						local sprite = CCSprite:createWithTexture(texture)
						sprite:setAnchorPoint(ccp(0, 0.5))
						sprite:setPosition(ccp(m1_to_x, -m1_to_y))
						sprite:setRotation(-a1)
						worldLayer:addChild(sprite, 20)
						
						--存储身体(新末尾)
						local tSprit = {}
						tSprit.middle_sprite = sprite
						tSprit.middle_begin_x = m1_to_x
						tSprit.middle_begin_y = m1_to_y
						tSprit.middle_end_x = m1x --结束点x
						tSprit.middle_end_y = m1y --结束点y
						tSprit.middle_width = middleWidth --tSizeMiddle.width
						tSprit.middle_height = middleHeight --tSizeMiddle.height
						tSprit.middle_sprite_pos_x = m1_to_x
						tSprit.middle_sprite_pos_y = m1_to_y
						tSprit.middle_angle = a1
						tSprit.middle_fangle = fa1
						--tHooks.tMiddleSprites[#tHooks.tMiddleSprites+1] = tSprit
						table.insert(tHooks.tMiddleSprites, 1, tSprit)
					end
				end
			end
		end
	end
end

--初始化所有玩家资源
_hw.InitAllPlayerResource = function(self, rtype, val)
	for i = 1, 24 do
		local player = self.data.PlayerList[i]
		if player then
			player:addresource(rtype, 0)
			player:addresource(rtype, val)
		end
	end
end

--增加化所有玩家资源
_hw.AddAllPlayerResource = function(self, rtype, val)
	for i = 1, 24 do
		local player = self.data.PlayerList[i]
		if player then
			player:addresource(rtype, val)
		end
	end
end

--每个回合增加金钱
_hw.AddAllPlayerGoldWave = function(self)
	local mapInfo = self.data.tdMapInfo
	local waveNow = mapInfo.wave
	local goldPerwave = (mapInfo.goldPerWave[waveNow] or 0)
	for i = 1, 24 do
		local player = self.data.PlayerList[i]
		if player then
			local gold = goldPerwave + (player:getGoldPerWaveAdd(waveNow))
			--print("(((((((((((((((((((((((((((((((((((((gold:",player:getpos(),goldPerwave,(player:getGoldPerWaveAdd(waveNow)),gold)
			player:addresource(hVar.RESOURCE_TYPE.GOLD, gold)
		end
	end
end

--返回指定势力的所有玩家
_hw.GetAllPlayerInForce = function(self, force)
	local ret = {}
	for i = 1, 20 do
		local player = self.data.PlayerList[i]
		if player and player:getforce() == force then
			ret[#ret + 1] = player
		end
	end
	return ret
end

--初始化所有角色每回合经前额外增加值
_hw.InitAllPlayerGoldPerWaveAdd = function(self, totalwave)
	for i = 1, 20 do
		local player = self.data.PlayerList[i]
		if player then
			player:initGoldPerWaveAdd(totalwave)
		end
	end
end
------------------------------------------------
--世界水花
------------------------------------------------
--世界特效类
do
	hClass.WMEffect = eClass:new("static")
	local _wme = hClass.WMEffect
	_wme.init = function(self,tParam)
		self.data = self.data or {}
		self.handle = self.handle or {}
		local d = self.data
		local h = self.handle
		local oWorld = tParam.world
		local model,x,y,scale,facing,scaleByUnit = unpack(tParam.effect)
		hApi.CreateEffect("effectG",h,tParam.scene,model,scale,tParam.x+x,tParam.y+y,tParam.z,tParam.facing,"normal",1)
		if type(h.animationtime)=="number" then
			d.tick = hApi.gametime() + h.animationtime + 1
			--print("d.tick4=" .. d.tick)
		else
			d.tick = 0
		end
	end
	_wme.destroy = function(self)
		local h = self.handle
		h._n:getParent():removeChild(self.handle._n,true)
		h._n = nil
		h.s = nil
	end
end

--播放水波函数
do
	local __TEMP__MountUnit = {}
	local __ENUM__GetMountHero = function(oHero)
		if oHero.data.IsDefeated==0 then
			local nMountId = oHero:getGameVar("_MOUNT")
			if nMountId~=0 then
				local oUnit = oHero:getunit("worldmap")
				if oUnit and oUnit.handle._c and oUnit.data.IsHide==0 then
					__TEMP__MountUnit[#__TEMP__MountUnit+1] = oUnit
				end
			end
		end
	end

	local __TEMP__Param = {}
	local __CODE__ShowMountEffect = function(oWorld,oUnit,tEffect)
		local d = oUnit.data
		local cx,cy = oUnit:getXY()
		for i = 1,#tEffect do
			if type(tEffect[i][1])=="string" then
				__TEMP__Param.scene = oWorld.handle.worldScene
				__TEMP__Param.x = cx
				__TEMP__Param.y = cy
				__TEMP__Param.z = -1
				__TEMP__Param.facing = d.facing
				__TEMP__Param.effect = tEffect[i]
				hClass.WMEffect:new(__TEMP__Param)
				if oWorld.worldUI["WMEffect"]==nil then
					oWorld.worldUI["WMEffect"] = {
						del = function()
							hClass.WMEffect:del_all()
						end,
					}
				end
			end
		end
	end

	local __TEMP__DeadWMEffect = {tick=0}
	local __ENUM__UpdateWMEffect = function(self)
		if self.data.tick<__TEMP__DeadWMEffect.tick then
			__TEMP__DeadWMEffect[#__TEMP__DeadWMEffect+1] = self
		end
	end
	
	local __TEMP__WMEffectTick = {}
	
	hApi.WMEffectLoop = function(frame_count)
		local oWorld = hGlobal.LocalPlayer:getfocusworld()
		if oWorld and oWorld.ID~=0 and oWorld.data.type=="worldmap" then
			__TEMP__MountUnit = {}
			local nGameTime = hApi.gametime()
			hClass.hero:enum(__ENUM__GetMountHero)
			for i = 1,#__TEMP__MountUnit do
				local oUnit = __TEMP__MountUnit[i]
				local oHero = oUnit:gethero()
				if oHero then
					local nMountId = oHero:getGameVar("_MOUNT")
					local nTick = __TEMP__WMEffectTick[oHero.ID] or 0
					local tabU = hVar.tab_unit[nMountId]
					if tabU then
						if tabU.effectM and oUnit.data.IsMoving==1 then
							if (nGameTime-nTick)>(tabU.effectM_dur or 0) then
								__TEMP__WMEffectTick[oHero.ID] = nGameTime
								__CODE__ShowMountEffect(oWorld,oUnit,tabU.effectM)
							end
						end
					end
				end
			end
			if oWorld.worldUI["WMEffect"]~=nil then
				__TEMP__DeadWMEffect = {tick=hApi.gametime()}
				hClass.WMEffect:enum(__ENUM__UpdateWMEffect)
				for i = 1,#__TEMP__DeadWMEffect do
					__TEMP__DeadWMEffect[i]:del()
				end
			end
		end
	end
end