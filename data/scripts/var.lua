 --=============================================================
-- hVar定义
--=============================================================

--各种开关
hVar.OPTIONS = {
	IS_DRAW_GRID = 0,
	IS_SHOW_ACTION_LIST = 1,
	IS_SHOW_QUEST_LIST = 1,				--是否显示任务列表
	IS_NO_TEXTURE = 0,				--无贴图模式,如果这个值等于1那么所有的png资源都变绿块
	IS_NO_SCEOBJ = 0,				--无场景物件模式,如果这个值等于1那么不加载所有的场景物件
	--IS_NO_PLIST = 0,				--不加载所有plist文件的模式(已废弃)
	IS_NO_AI = 0,					--AI是否关闭
	AUTO_COLLECTGARBAGE = 1,			--存档/切场景时自动回收垃圾
	AUTO_RELEASE_TEXTURE = 1,			--是否允许回收贴图(如果打开此项,安卓系统下可能会很慢)
	AUTO_BATTLEFIELD = 0,				--战场自动运行(启动后将会设置世界变量oWorld.data.autoBF)
	AI_HOLY_SHIT = 0,				--AI打野是否不战而胜
	PVP_ENABLE = 1,					--是否开启pvp测试
	LOW_QUALITY_MODE = 0,				--低画质模式
	SHOW_WEEK_STAR_HERO = 1,			--开始游戏时提示每周积分翻倍英雄
	PLAY_SOUND = 1,					--是否播放音乐
	PLAY_SOUND_BG = 1,				--是否播放背景音乐
	--PVP_ROOM_FILTER = 0,				--PVP房间只显示战力相近
	--PVP_CMD_LOG = 0,				--是否打印PVP recv和send的log
	TEST_NOOB_TIP = 0,				--新手指引测试开关(打开后永远显示新手指引)
	TEST_UNIQUE_QUEST = 0,				--测试任务(打开后唯一任务不能完成,用于测试任务文字)
	AI_LOG = 0,					--是否允许xlLG->AI系统的log
	BF_AI_LOG = 0,					--是否允许print->小战场AI的log
	IS_OPEN_PVP_RANK = 1,				--是否打开精英挑战房间
	
	SHOW_DEBUG_NEXTWAVE_BTN = 0,			--zhenkira: 是否显示提前发兵按钮
	
	INVASION_FLAG = 1,				--是否发兵
	
	SHOW_HP_BAR_FLAG = 0,			--geyachao: 是否显示血条和冒字
	SHOW_BOX_FLAG = 0,				--geyachao: 是否显示包围盒子的开关
	SHOW_AI_UI_FLAG = 0,			--geyachao: 是否显示AI辅助界面的开关
	SHOW_DEBUG_INFO_FLAG = 0,		--geyachao: 是否显示看内存的开关
	SHOW_DMG_DPS_FLAG = 0,			--geyachao: 是否显示伤害和DPS的开关
	
	IS_SHOW_GUIDE = 0,				--geyachao: 是否显示新手引导
	
	TEST_MODE = 0,					--geyachao: 大菠萝是否显示开场动画
	HPADD_MODE = 0,					--geyachao: 大菠萝是否战车加血
	SPEEDADD_MODE = 0,					--geyachao: 大菠萝是否战车加速度
	
	IS_TD_ENTER = 0,				--zhenkira: 进入初始场景，0 原有流程， 1, 游戏开始便进入选关
	
	MAX_PLAYER_NUM = 1,				--zhenkira: 最大可创建角色数
	MAX_GAME_SPEED = 2,				--游戏最大加速倍率
	SYSTEM_MAINBASE_NOCLEAR = 0,			--基地不清除监听模式（切换黑龙scene，不清除）
	
	VIRTUAL_CONTROL_MOVE = 0,			--跟随摇杆开关
	VIRTUAL_CONTROL_DIRNUM = 32,			--虚拟摇杆的方向数量
	SHOW_TANK_HP_FLAG = 0,				--显示战车血条模式
}

hVar.MUSIC_VOLUME = 0.8	--背景音乐音量(范围 0.1  ~  1 )

--PVP点选模式开关
hVar.IS_DIABOLO_APP = 1 --是否为大菠萝游戏
hVar.OP_LASTING_MODE = 1 --是否持续选中
hVar.MY_TANK_ID = 6000 --我的坦克id
hVar.MY_TANK_FOLLOW_ID = {12217, 13051, 13052, 13053, 13054, 12220,} --我的坦克跟随单位id 瓦力
hVar.MY_TANK_FOLLOW_RADIUS = 180 --宠物跟随坦克的距离
hVar.MY_TANK_SCIENTST_ID = 11209 --科学家 人质id
hVar.MY_TANK_SCIENTST2_ID = 19021 --乱走单位
hVar.ENEMY_AI_RADIUS = 1200 --敌人AI响应半径（敌人距离我的坦克一定范围内，才会有AI行为）
hVar.HOSTAGE_FOLLOW_RADIUS = 250 --人质跟随坦克的距离

--英雄装备容量
hVar.ItemGridLine = 4
hVar.ItemGridCow = 3

hVar.DEFAULT_LIFT_NUM = 1 --默认坦克命的数量
hVar.CAN_BUY_LIFE_NUM = 1 --可以购买命的数量
hVar.BUY_LIFE_COST = 300  --购买命的花费
hVar.COIN_WITH_RESCUED = 20 --营救一个30金币
hVar.GuideMap = "world/csys_000" --引导关
hVar.MainBase = "world/start_001"	--主基地
hVar.LoginMap = "world/csys_ex_002_randommap"	--登录界面地图
hVar.RandomMap = "world/csys_random_test" --随机迷宫地图
hVar.QianShaoZhenDiMap = "world/yxys_ex_002" --前哨阵地地图
hVar.MuChaoZhiZhanMap = "world/yxys_ex_001" --母巢之战地图
hVar.DuoBaoQiBingMap = "world/yxys_ex_003" --夺宝奇兵地图
hVar.ReviewMode = 0		--内网审核模式
hVar.RealNameMode = 0		--内网实名流程 1开启 0 关闭  查询表g_ReviewTestInfo 填写相关参数
hVar.ShowGMUI = 0		--0默认不出现 1 默认出现 每次重启都重置 不保留（仅内网和GM有效）

hVar.AUTOATTACK_CHECKTIME = 250		--长按攻击的判定时间

--每局抽卡总次数
hVar.ENDLESS_TACTICCARD_REDRAW_MAXCOUNT = 20 --新无尽群英阁，每局可重抽卡的总次数

--新无尽群英阁，可以重抽卡的次数
hVar.ENDLESS_TACTICCARD_REDRAW_BEGIN_WAVE = 1

--新无尽群英阁，不会抽到的战术卡列表
hVar.ENDLESS_TACTICCARD_FILTERS = {} --练兵,固若金汤,塔基加固,砖瓦结构,摧城拔寨,冻土,

--新无尽群英阁，战术卡档位（稀有度）
hVar.ENDLESS_TACTICCARD_COLOR =
{
	WHITE		= 1,		--白卡
	YELLOW		= 2,		--黄卡
	RED		= 3,		--红卡
	PURPLE		= 4,		--紫卡
	
	COLOR_MAX	= 4,		--档位总数量
}

--新无尽群英阁，战术卡档位（稀有度）的几率
hVar.ENDLESS_TACTICCARD_COLOR_PROBABLITY =
{
	
	[hVar.ENDLESS_TACTICCARD_COLOR.WHITE]	= 50,	--白卡几率
	[hVar.ENDLESS_TACTICCARD_COLOR.YELLOW]	= 40,	--黄卡几率
	[hVar.ENDLESS_TACTICCARD_COLOR.RED]	= 8,	--红卡几率
	[hVar.ENDLESS_TACTICCARD_COLOR.PURPLE]	= 2,	--紫卡几率
	
	
	--[[
	--测试 --test
	[hVar.ENDLESS_TACTICCARD_COLOR.WHITE]	= 1,	--白卡几率
	[hVar.ENDLESS_TACTICCARD_COLOR.YELLOW]	= 0,	--黄卡几率
	[hVar.ENDLESS_TACTICCARD_COLOR.RED]	= 0,	--红卡几率
	[hVar.ENDLESS_TACTICCARD_COLOR.PURPLE]	= 99,	--紫卡几率
	]]
	
}

--装备最大数量
hVar.EquipMaxNum = 300

--给宠物回血消耗
hVar.AddPetHpCost = {
	requireScore = 500,
	--requireMan = 1,
}

--有几率将可破坏物件变成能掉宝的单位（九宫格里最多只有1个宝）
hVar.UNITBROKEN_STONE_ORINGIN_ID = 5108 --原单位id
hVar.UNITBROKEN_STONE_CHANGETO_ID = 5109 --变成的单位id
hVar.UNITBROKEN_STONE_PROBABLITY = 3 --几率 3％

--可破化物件被打几次爆掉
hVar.UNITBROKEN_DEADCOUNT = 3

--（四宫格）
hVar.UNITBROKEN_STONE_GOLD_ID = 5110 --金砖id

--随机地图砖块
hVar.UNITBROKEN_STONE_NORMAL = 5136
hVar.UNITBROKEN_STONE_SPECIAL = 5191

--随机地图平房X
hVar.UNITBROKENHOUSE_X1 = 13000
hVar.UNITBROKENHOUSE_X2 = 13001

--标枪追踪导弹id
hVar.TRACING_BIAOQIANG_ID = 3180

--战车每日排名奖励
hVar.TANK_BILLBOARD_REWARD =
{
	{from = 1, to = 3, score = 800, model = "misc/billboard/top3.png",},
	{from = 4, to = 10, score = 500, model = "misc/billboard/top10.png",},
	{from = 11, to = 20, score = 300, model = "misc/billboard/top20.png",},
	{from = 21, to = 50, score = 200, model = "misc/billboard/top50.png",},
	{from = 51, to = 100, score = 150, model = "misc/billboard/top100.png",},
	{from = 0, to = 0, score = 100, model = -1,},
}

--战车排行榜类型
hVar.TANK_BILLBOARD_RANK_TYPE =
{
	RANK_STAGE = 1,			--过图排行榜
	RANK_CONTINOUSKILL = 2,		--连杀排行榜
}

--战车天赋升级天赋树表
hVar.TANK_TAKENT_TREE =
{
	[1] =
	{
		attrType = "inertia", --惯性
		maxLv = 2, --最大等级
		costP = 4, --每级扣除点数
		attrAdd = --每级增加属性
		{
			[1] = 20,
			[2] = 40,
		}
	},
	[2] =
	{
		attrType = "grenade_capacity", --携弹
		maxLv = 8, --最大等级
		costP = 1, --每级扣除点数
		attrAdd = --每级增加属性
		{
			[1] = 20,
			[2] = 40,
			[3] = 60,
			[4] = 80,
			[5] = 100,
			[6] = 120,
			[7] = 140,
			[8] = 160,
		}
	},
	[3] =
	{
		attrType = "atk", --杀伤
		maxLv = 8, --最大等级
		costP = 1, --每级扣除点数
		attrAdd = --每级增加属性
		{
			[1] = 3,
			[2] = 6,
			[3] = 9,
			[4] = 12,
			[5] = 15,
			[6] = 18,
			[7] = 21,
			[8] = 24,
		}
	},
	[4] =
	{
		attrType = "grenade_fire", --燃烧
		maxLv = 4, --最大等级
		costP = 2, --每级扣除点数
		attrAdd = --每级增加属性
		{
			[1] = 1,
			[2] = 2,
			[3] = 3,
			[4] = 4,
		}
	},
	[5] =
	{
		attrType = "grenade_dis", --射程
		maxLv = 8, --最大等级
		costP = 1, --每级扣除点数
		attrAdd = --每级增加属性
		{
			[1] = 10,
			[2] = 20,
			[3] = 30,
			[4] = 40,
			[5] = 50,
			[6] = 60,
			[7] = 70,
			[8] = 80,
		}
	},
	[6] =
	{
		attrType = "grenade_cd", --射速
		maxLv = 4, --最大等级
		costP = 2, --每级扣除点数
		attrAdd = --每级增加属性
		{
			[1] = -200,
			[2] = -400,
			[3] = -600,
			[4] = -800,
		}
	},
	[7] =
	{
		attrType = "grenade_crit", --暴击
		maxLv = 8, --最大等级
		costP = 1, --每级扣除点数
		attrAdd = --每级增加属性
		{
			[1] = 1,
			[2] = 2,
			[3] = 3,
			[4] = 4,
			[5] = 5,
			[6] = 6,
			[7] = 7,
			[8] = 8,
		}
	},
	[8] =
	{
		attrType = "basic_skill_usecount", --双雷
		maxLv = 1, --最大等级
		costP = 8, --每级扣除点数
		attrAdd = --每级增加属性
		{
			[1] = 1,
		}
	},
	[9] =
	{
		attrType = "grenade_child", --子母
		maxLv = 8, --最大等级
		costP = 1, --每级扣除点数
		attrAdd = --每级增加属性
		{
			[1] = 1,
			[2] = 2,
			[3] = 3,
			[4] = 4,
			[5] = 5,
			[6] = 6,
			[7] = 7,
			[8] = 8,
		}
	},
}

--排行榜的一些颜色
hVar.RANKBOARD_COLOR = {}
if ccc3 then
	hVar.RANKBOARD_COLOR.GOLD = ccc3(255, 204, 0) --金色
	hVar.RANKBOARD_COLOR.SILVER = ccc3(226, 226, 226) --银色
	hVar.RANKBOARD_COLOR.COPPER = ccc3(212, 168, 96) --铜色
	hVar.RANKBOARD_COLOR.TINTBLUE = ccc3(212, 248, 255) --淡蓝色
	hVar.RANKBOARD_COLOR.TINTGREEN = ccc3(234, 255, 234) --淡绿色
	hVar.RANKBOARD_COLOR.TINTWHITE = ccc3(255, 255, 228) --淡白色
	hVar.RANKBOARD_COLOR.GRAYWHITE = ccc3(224, 224, 224) --灰白色
	hVar.RANKBOARD_COLOR.GRAY = ccc3(192, 192, 192) --灰色（无名次）
	hVar.RANKBOARD_COLOR.DARKGRAY = ccc3(156, 156, 156) --灰黑色（线条边框）
end


--连斩道具奖励 对应表
hVar.ContinuousKillingItemAward = {
	[13000] = {
		{"score",5},
	},
	[13001] = {
		{"score",6},
	},
	[13002] = {
		{"score",8}
	},
	[13003] = {
		{"score",10}
	},
	[13004] = {
		{"score",15}
	},
	[13010] = {
		{"score",50}
	},
	[13011] = {
		{"score",1}
	},
	[13012] = {
		{"score",2}
	},
	[13013] = {
		{"score",3}
	},
}

--连斩气泡特效
hVar.CKSYSTEM_EFFECTBLOOD = {
	[1] = "misc/continuouskilling/blood1.png",
	[2] = "misc/continuouskilling/blood2.png",
	[3] = "misc/continuouskilling/blood3.png",
	[4] = "misc/continuouskilling/blood4.png",
}

hVar.TANKSKILL_EMPTY = 2 --战车技能的预留（占位）
hVar.TANKSKILL_IDX = 3 --战车技能的图标位置索引值
hVar.NORMALATK_IDX = 4 --普通攻击的图标位置索引值

hVar.MAX_RECORD_GAMEDATA_NUM = 300	--最多保留游戏数据300条

--统计游戏数据  以每局游戏为间隔 (为了节约内存 没有初始值)
hVar.STATISTICAL_GAMEDATA = {
	UNKOWN = 0,			--未知
	--游戏时间
	INITIALTIME = 11,		--开局时间 (日_分_秒 8位)
	GAMEOVERTIME = 12,		--结算时间 (日_分_秒 8位)
	GAMETIME = 13,			--游戏时间 (分_秒 5位)

	--游戏内的积分变化（1~7）
	INITIALSCORE = 1,		--初始开局积分
	CKSCORE = 2,			--连斩积分统计
	MAPPURCHASESCORE = 3,		--地图内充值积分 (广告 充值)
	MAPCOSTSCORE = 4,		--地图内消耗积分 (复活 升级天赋 宠物加血)
	MAPGETSCORE = 5,		--地图获取积分 (单关卡奖励)
	SETTLEMENTSCORE = 6,		--结算积分(营救人质 总关卡奖励)
	GAMEOVERSCORE = 7,		--结算时积分
	
	--游戏外的积分变化 （21 ~ 24）
	BASEPURCHASESCORE = 21,		--基地充值积分 (广告 充值)
	BASECOSTSCORE = 22,		--基地消耗积分 (解锁武器,升级道具天赋)
	BASEDAILYSCORE = 23,		--基地日常积分 (补给箱)
	ACHIEVEMENTSCORE = 24,		--成就积分

	GMCHEAT = 98,			--GM作弊
	--系统奖励
	SYSTEMREWARDSCORE = 99,		--系统奖励
}

--获得积分的途径
hVar.GET_SCORE_WAY = {
	SRC = 0,			--内网作弊
	ADS = 1,			--广告
	PURCHASE = 2,			--充值
	CK = 3,				--连斩
	CLEARSTAGE = 4,			--单关卡奖励
	GAMESETTLEMENT = 5,		--游戏结算
	DAILYREWARD = 6,		--日常奖励
	ACHIEVEMENT = 7,		--成就奖励

	GMCHEAT = 98,			--GM作弊
	SYSTEMREWARD = 99,		--系统奖励
	
	DIVIDINGLINE = 100,		--分界线  仅判定用
	--101 开始为负值
	UNLOCKWEAPON = 101,		--解锁武器
	UPGRADETACTICS = 102,		--升级天赋
	REVIVE = 103,			--复活
	UPGRADEITEMTACTICS = 104,	--升级道具天赋
	UPGRADEPET = 105,		--升级宠物
	PETADHP = 106,			--宠物加血
	BUYPETFOLLOW = 107,		--地图内购买跟随的宠物
}

--积分来源的上限 超过则传log
hVar.ScoreSourceLimit = {
	[hVar.GET_SCORE_WAY.ADS] = "200",
	[hVar.GET_SCORE_WAY.PURCHASE] = "12000",
	[hVar.GET_SCORE_WAY.CK] = "50",
	[hVar.GET_SCORE_WAY.CLEARSTAGE] = "1500",
	[hVar.GET_SCORE_WAY.GAMESETTLEMENT] = "8000",
	[hVar.GET_SCORE_WAY.DAILYREWARD] = "1000",
	[hVar.GET_SCORE_WAY.ACHIEVEMENT] = "2000",
}

--例
--作弊类型8 
--(1)积分异常 "Score Anomaly:".." last:"..nLastScore.." new:"..nCurScore
--(2)积分来源异常 "ScoreSource Anomaly:".." way:"..nWay.." score:"..nScore.." limit:"..nLimit
--作弊类型
hVar.CHEATTYPE = {
	SCORECHEAT = 8,	--积分作弊 
}

--道具类型定义
hVar.ITEM_TYPE = {
	NONE = 1,
	HEAD = 2,
	BODY = 3,
	WEAPON = 4,
	ORNAMENTS = 5,
	MOUNT = 6,
	FOOT = 7,
	HEROCARD = 8,
	PLAYERITEM = 9,
	DEPLETION = 10, --消耗品
	RESOURCES = 11,
	MAPBAG = 12,
	REWARD = 13,
	GIFTITEM = 14,
	SOULSTONE = 15,
	TACTICDEBRIS = 16,
	MAPITEM = 17,
	TREASUREDEBRIS = 18, --宝物碎片
	CANGBAOTU_NORMAL = 19, --藏宝图
	CANGBAOTU_HIGH = 20, --高级藏宝图
	WEAPON_GUN = 21, --武器枪
	
	CHEST_WEAPON_GUN = 22, --武器枪宝箱
	CHEST_TACTIC = 23, --战术卡宝箱
	CHEST_PET = 24, --宠物宝箱
	CHEST_EQUIP = 25, --装备宝箱
	
	TACTIC_USE = 26, --使用类战术卡
	
	WEAPONGUNDEBRIS = 27, --武器枪碎片
	PETDEBRIS = 28, --宠物碎片
	SAVEDATAPOINT = 29, --存盘点
	
	TALK = 30, --对话类道具
	CHEST_REDEQUIP = 31, --神器宝箱
}

--势力定义
hVar.FORCE_DEF = 
{
	GOD = 0,		--神
	SHU = 1,		--蜀国
	WEI = 2,		--魏国
	NEUTRAL = 3,		--中立无敌意
	NEUTRAL_ENEMY = 4,	--中立有敌意
	
	FORCE_MIN = 0, --最小值（用于遍历）
	FORCE_MAX = 4, --最大值（用于遍历）
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

--角色性别
hVar.ROLE_SEX = 
{
	NONE = 0,		--空位
	MALE = 0,		--男性
	FEMALE = 1,		--女性
	ANIMAL = 2,		--动物
}

--geyachao: AI行为类型定义
hVar.AI_ATTRIBUTE_TYPE =
{
	POSITIVE = 0, --被动行为
	ACTIVE = 1, --主动行为
}

--geyachao: 是否为新td塔防app程序，新程序会定义"newtd" = 1
hVar.SYS_IS_NEWTD_APP = (newtd or 0)

--地图内普通单位最大数量
hVar.WORLD_MAX_UNIT_NUM = 2000

--geyachao: 普通攻击最大等级（武器等级最大等级）
hVar.ROLE_NORMALATK_MAXLV = 99

--geyachao: 角色碰撞边长
hVar.ROLE_COLLISION_EDGE = 24

--geyachao: 玩家的金币数量
hVar.ROLE_PLAYER_GOLD = 0

--geyachao: 玩家的芯片数量
hVar.ROLE_PLAYER_CHIP = 0

hVar.SCREEN_MODE_DEFINE = {
	HORIZONTAL = 0,		--横屏
	VERTICAL = 1,		--竖屏
}

hVar.CONTROL_MODE_DEFINE = {
	LOCAL_NO = 0,		--无锁
	LOCAL_LEFT = 1,		--锁左边操作
	LOCAL_RIGHT = 2,	--锁右边操作
}

hVar.SCREEN_MODE = hVar.SCREEN_MODE_DEFINE.HORIZONTAL
hVar.CONTROL_MODE = hVar.CONTROL_MODE_DEFINE.LOCAL_NO
hVar.CONTROL_NOW = 0

--geyachao: 角色路点的类型
hVar.ROLE_ROAD_POINT_TYPE =
{
	ROAD_POINT_NONE = 0, --不用走路点
	ROAD_POINT_LINE = 1, --按路点走直线，走完角色消失
	ROAD_POINT_CIRCLE = 2, --循环模式，走到最后路点，再走到第一个
	ROAD_POINT_LINE_EVENT = 3, --按路点走直线，走完触发事件
}

--大菠萝，难度模式，敌人飞行特效的速度加快倍数
hVar.ROLE_FLYSEPPD_DIFF_ADDRATE = 10

--大菠萝，机枪进入闲置后，多久和车身同步（单位:毫秒）
hVar.ROLE_TANKWEAPON_SYNCTIME = 500

--geyachao: 排行榜的配置数据
hVar.BILL_BOARD_MAP =
{
	--黄巾试炼排行榜
	[1] =
	{
		bid = 1,
		type = 1,
		mapName = "world/td_wj_001",
		name = "__TEXT_RANK_1", --"无尽试炼每日排行"
		bUpload = true, --是否需要上传本地积分
	},
	
	--夺塔奇兵排行榜
	[2] =
	{
		bid = 2,
		type = 3,
		mapName = "world/td_pvp_001",
		name = "__TEXT_RankBoardIntro_PVP", --"竞技场排行榜"
		bUpload = false, --是否需要上传本地积分
	},
}

--shader容器 创建的shader都放里面 不去重复创建
hVar.SHADER_CONTAINER = {
}

--各个语言版本不加载的模块
hVar.LANGUAGE_EXCLUDE = {
	CS = {},
	CT = {},
	ENG = {"pvp","rsdyz"}
}
--会被保存为.cfg的开关
hVar.USER_OPTIONS = {
	PLAY_SOUND = 1,					--是否播放音乐
	PLAY_SOUND_BG = 1,				--是否播放背景音乐
	PVP_ROOM_FILTER = 1,				--PVP房间只显示战力相近
	IS_DRAW_GRID = 1,				--小战场是否画格子
}

if type(g_ip_list) ~= "table" then
	g_ip_list = {}
end

g_game_Ip = g_ip_list.game or "47.103.51.230"	--外网
g_pvp_Ip = g_ip_list.pvp or "47.103.51.230"	--外网
g_lrc_Ip = "192.168.1.30"			--内网

IAPServerIP = g_game_Ip		--外网服务器
hVar.PVP_Add = g_pvp_Ip
IAPServerPort = 10024 --8023/8024     8026/8027
PVPServerPort = 10032

if (g_lua_src == 1) then --源代码模式下打开以下开关
	--IAPServerIP = g_lrc_Ip --内网
	--hVar.PVP_Add = g_lrc_Ip --内网
	--IAPServerPort = 10024
	
	hVar.OPTIONS.TEST_NOOB_TIP = 1
	hVar.OPTIONS.TEST_UNIQUE_QUEST = 0
	--hVar.OPTIONS.AI_LOG = 0
end

--该版本文件对应的竞技场版本号，用于控制允许竞技场进入的版本
hVar.PVP_VERSION = "1.1.081101"

hVar.DeBugBtnList = {
	[1] = {"ShowMiniWindow"},
	[2] = {"otherFunc"},
}

--不同分辨率下的显示用参数
--g_phone_mode:0.pad, 1.ip4, 2.ip5, 3.android
hVar.DEVICE_PARAM = {
	
	--大菠萝
	--ipad
	[0] = {
		menu_view = {0,0,0,0,0,0},		--主菜单的视角偏移(可卷动区域调整，视角中心调整)
		town_view = {0,0,0,0,0,0},		--城市的视角偏移
		loading_view = {0,0,1},
		world_scale = 0.9,			--世界地图的视角缩放
	},
	
	--大菠萝
	--iphone4
	[1] = {
		menu_view = {0,0,0,0,0,0},		--主菜单的视角偏移(可卷动区域调整，视角中心调整)
		town_view = {0,0,0,0,0,0},		--城市的视角偏移
		loading_view = {0,0,1},
		world_scale = 0.9,			--世界地图的视角缩放
	},
	
	--大菠萝
	--iphone5
	[2] = {
		menu_view = {0,0,0,0,0,0},		--主菜单的视角偏移(可卷动区域调整，视角中心调整)
		town_view = {0,0,0,0,0,0},		--城市的视角偏移
		loading_view = {0,0,1},
		world_scale = 0.9,			--世界地图的视角缩放
	},
	
	--大菠萝
	--iphone6-iphone8
	[3] = {
		menu_view = {0,0,0,0,0,0},		--主菜单的视角偏移(可卷动区域调整，视角中心调整)
		town_view = {0,0,0,0,0,0},		--城市的视角偏移
		loading_view = {0,0,1},
		world_scale = 0.9,			--世界地图的视角缩放
	},
	
	--大菠萝
	--iphoneX
	[4] = {
		menu_view = {0,0,0,0,0,0},		--主菜单的视角偏移(可卷动区域调整，视角中心调整)
		town_view = {0,0,0,0,0,0},		--城市的视角偏移
		loading_view = {0,0,1},
		world_scale = 0.9,			--世界地图的视角缩放
	},
}

--[[
--编辑器模式
if (g_editor == 1) then
	for k, v in pairs(hVar.DEVICE_PARAM) do
		v.world_scale = 1.0
	end
end
]]

--为了优化hApi.GetIDByName接口的执行效率，增加一张内存表用来缓存UID和地图名的映射 此表在成就表数据格式化时会填充
hVar.MAP_UID2NAME = {}

hVar.Enable_PVP = 1			--是否加载PVP相关的脚本
--商店里面道具显示多少排
hVar.SHOP_ITEM_ROW = 20
--任务道具奖励的孔数(白蓝黄红橙)
hVar.REWARD_EQUIPMENT_SLOT = {1,1,1,1,2}
hVar.EQUIPMENT_MAX_SLOT = {2,2,2,3}
--如果是这张表里面记录的单位，必须购买此卡片才能对话(已废弃)
hVar.HERO_NEED_BUY = {
	--[5025] = 1,		--张辽
}
--如果这张表里面记录了单位，那么可以免费获得
hVar.HERO_FREE = {
	--[5000] = 1,		--刘备
}
--如果这张表里面记录了单位，并且英雄是购买dlc赠送，只要购买了就视为免费英雄
hVar.HERO_IN_DLC = {
	[5026] = {"world/level_tqt"},	--貂蝉 {铜雀台赠送}
}

-----------------------------------------zhenkira hero setting-----------------------------------------
--“我的英雄令”界面中的所有英雄			added by pangyong 2015/3/5 
hVar.HERO_AVAILABLE_LIST = {
	--[[
	--免费
	{id = 18001, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--刘备
	{id = 18002, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--关羽
	{id = 18003, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--张飞
	{id = 18008, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--赵云		--赠送
	{id = 18005, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--曹操
	{id = 18010, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--夏侯敦	--付费
	{id = 18007, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--郭嘉		--付费
	{id = 18006, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--太史慈	--付费
	{id = 18011, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--吕布		--吕布传
	{id = 18012, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--貂蝉		--吕布传
	{id = 18014, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--张辽		--付费
	{id = 18016, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--典韦		--付费
	{id = 18015, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--许褚		--付费
	{id = 18028, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--荀彧		--付费
	{id = 18018, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--孙策
	{id = 18019, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--周瑜
	{id = 18022, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--小乔		--VIP6专属
	{id = 18020, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--徐庶		--付费
	{id = 18021, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--诸葛亮
	{id = 18023, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--黄月英	--？？
	{id = 18017, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = true,},		--甘宁		--PVP专属
	{id = 18024, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--孙权		--？？	
	{id = 18025, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = true,},		--庞统		--PVP + 魔龙宝库
	{id = 18027, attr = {level = 1, star = 1,}, debris_open = true, pvp_only = false,},		--董卓	--？？
	]]
}

--

--zhenkira 英雄购买解锁（通关某关卡后解锁购买,不填的项自动解锁）
hVar.NET_SHOP_ITEM_LIMIT =
{
	[15] = "world/td_104_hsly", --郭嘉
	[19] = "world/td_106_bhzw", --太史慈
	[13] = "world/td_109_xpzz", --张辽
	[16] = "world/td_107_jjjj", --典韦
	[18] = "world/td_109_xpzz", --许褚
	[388] = "world/td_303_swxd", --荀彧
	[386] = "world/td_406_sl", --孙权
	[382] = "world/td_409_zpbm", --徐庶
	[383] = "world/td_410_wlcs", --诸葛亮
}

--精英装备表（和英雄页一起的）
hVar.RedEquip = {
	sort = {
		[hVar.ITEM_TYPE.WEAPON] = 1,		--武器
		[hVar.ITEM_TYPE.BODY] = 2,			--身体
		[hVar.ITEM_TYPE.ORNAMENTS] = 3,		--饰品
		[hVar.ITEM_TYPE.MOUNT] = 4,			--坐骑
	},
	20400, --寒渊
	20401, --光幕
	20402, --原子切割
	20403, --超合金装甲
	20404, --超合金轮毂
	20405, --暴风雨

	20406, --猩红闪电
	20407, --地狱火
	20408, --方舟核心
	20409, --全自动布雷机
	20410, --绝对零度
	20411, --量子玫瑰

	20412, --超新星
	20413, --震荡波
	20414, --极光
	20415, --奇美拉
	20416, --瘟疫使者
	20417, --次声波炸弹

	20418, --风火轮
	20419, --智能灭火装置
	20420, --自动爆破机

	20480, --闪电风暴
	20483, --白昼
	20484, --基因拟态酶
	20481, --便携式机枪
	20482, --羽蛇神
}

hVar.RedEquip_ROW = 7 --一页展示7个红装

--装备icon统一大小
hVar.EquipWH = 78


--英雄星级配置信息
hVar.HERO_STAR_INFO = 
{	
	maxStarLv = 1,				--当前开放的星级上限
	
	--
	[6000] = {
		--1星
		[1] = {
			maxLv = 100,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 100,		--升至下一级需要将魂数量
			--shopItemId = 291,
		},
	},
	
	--
	[6107] = {
		--1星
		[1] = {
			maxLv = 100,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 100,		--升至下一级需要将魂数量
			--shopItemId = 291,
		},
	},
	
	--
	[6108] = {
		--1星
		[1] = {
			maxLv = 100,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 100,		--升至下一级需要将魂数量
			--shopItemId = 291,
		},
	},
	
	--
	[6109] = {
		--1星
		[1] = {
			maxLv = 100,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 100,		--升至下一级需要将魂数量
			--shopItemId = 291,
		},
	},
}

--英雄技能升级消耗
hVar.SKILL_LVUP_COST = 
{
	[1] =	101, --商品id
	[2] =	102,
	[3] =	103,
	[4] =	104,
	[5] =	105,
	[6] =	106,
	[7] =	107,
	[8] =	108,
	[9] =	109,
	[10] =	110,
	[11] =	111,
	[12] =	112,
	[13] =	113,
	[14] =	114,
	[15] =	115,
	[16] =	116,
	[17] =	117,
	[18] =	118,
	[19] =	119,
	[20] =	120,
	[21] =	121,
	[22] =	122,
	[23] =	123,
	[24] =	124,
	[25] =	125,
	[26] =	126,
	[27] =	127,
	[28] =	128,
	[29] =	129,
	[30] =	130,
	[31] =	131,
	[32] =	132,
	[33] =	133,
	[34] =	134,
	[35] =	135,
	[36] =	136,
	[37] =	137,
	[38] =	138,
	[39] =	139,
	[40] =	140,
}

--战术技能卡升级消耗
hVar.TACTIC_LVUP_INFO =
{
	--除了兵种卡外的等级上限
	maxTacticLv = 30,
	--[等级] = {商品id(包含消耗的积分和金币), 转化的碎片数, 升级下一级需要消耗的碎片数}
	[0] =	{shopItemId = 201,		toDebris = 0,		costDebris = 0},
	[1] =	{shopItemId = 202,		toDebris = 0,		costDebris = 10},
	[2] =	{shopItemId = 203,		toDebris = 30,		costDebris = 20},
	[3] =	{shopItemId = 204,		toDebris = 60,		costDebris = 30},
	[4] =	{shopItemId = 205,		toDebris = 110,		costDebris = 50},
	[5] =	{shopItemId = 206,		toDebris = 180,		costDebris = 70},
	[6] =	{shopItemId = 207,		toDebris = 270,		costDebris = 90},
	[7] =	{shopItemId = 208,		toDebris = 380,		costDebris = 110},
	[8] =	{shopItemId = 209,		toDebris = 510,		costDebris = 130},
	[9] =	{shopItemId = 210,		toDebris = 660,		costDebris = 150},
	[10] =	{shopItemId = 211,		toDebris = 830,		costDebris = 170},
	[11] =	{shopItemId = 212,		toDebris = 1020,	costDebris = 190},
	[12] =	{shopItemId = 213,		toDebris = 1230,	costDebris = 210},
	[13] =	{shopItemId = 214,		toDebris = 1460,	costDebris = 230},
	[14] =	{shopItemId = 215,		toDebris = 1720,	costDebris = 260},
	[15] =	{shopItemId = 216,		toDebris = 2010,	costDebris = 290},
	[16] =	{shopItemId = 217,		toDebris = 2330,	costDebris = 320},
	[17] =	{shopItemId = 218,		toDebris = 2680,	costDebris = 350},
	[18] =	{shopItemId = 219,		toDebris = 3060,	costDebris = 380},
	[19] =	{shopItemId = 220,		toDebris = 3470,	costDebris = 410},
	[20] =	{shopItemId = 221,		toDebris = 3910,	costDebris = 440},
	[21] =	{shopItemId = 222,		toDebris = 4380,	costDebris = 470},
	[22] =	{shopItemId = 223,		toDebris = 4880,	costDebris = 500},
	[23] =	{shopItemId = 224,		toDebris = 5410,	costDebris = 530},
	[24] =	{shopItemId = 225,		toDebris = 5980,	costDebris = 570},
	[25] =	{shopItemId = 226,		toDebris = 6600,	costDebris = 620},
	[26] =	{shopItemId = 227,		toDebris = 7300,	costDebris = 700},
	[27] =	{shopItemId = 228,		toDebris = 8100,	costDebris = 800},
	[28] =	{shopItemId = 229,		toDebris = 9000,	costDebris = 900},
	[29] =	{shopItemId = 230,		toDebris = 10000,	costDebris = 1000},
	[30] =	{shopItemId = nil,		toDebris = 0,		costDebris = nil},
	
	--兵种卡的等级上限（升级信息在兵种卡tab中配置）
	maxArmyLv = 1,
	--兵种卡升级所需材料种类上限
	maxMaterialType = 3,
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

--宝物属性位叠加规则
hVar.TREASURE_ATTR_INCREASE_TYPE =
{
	ADD = 1,		--相加
	COVER = 2,		--覆盖
	MIN = 3,		--取较小值
	MAX = 4,		--取较大值
}

--宝物属性位的已获得描述词
hVar.TREASURE_ATTR_GAIN_STRING =
{
	[hVar.TREASURE_ATTR.PVP_WINCOUNT_CAOCAO] = "CurrentWin", --已胜利
	[hVar.TREASURE_ATTR.PVP_WINCOUNT_LIUGUANZHANG] = "CurrentWin", --已胜利
	[hVar.TREASURE_ATTR.PVP_WINCOUNT_ZHOUYUXIAOQIAO] = "CurrentWin", --已胜利
	[hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_EAZY_DEATH1] = "CurrentBattleStage", --已通关
	[hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_DIFFICULT] = "CurrentBattleStage", --已通关
	[hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_DIFFICULT_USE_WUHU] = "CurrentBattleStage", --已通关
	[hVar.TREASURE_ATTR.ENDLESS_WINCOUNT_LIUGUANZHANG] = "CurrentBattleStage", --已通关
	[hVar.TREASURE_ATTR.ENDLESS_WINCOUNT_LVBU_DIAOCHAN] = "CurrentBattleStage", --已通关
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_10_CAOCAO] = "CurrentBattleStage", --已通关
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_PURPLECARD_NUM] = "CurrentDraw", --已抽到
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_10_BUILD_JUPAOTA_10] = "CurrentBattleStage", --已通关
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_5_BUILD_JUJITA_10] = "CurrentBattleStage", --已通关
	[hVar.TREASURE_ATTR.MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_PANGTONG] = "CurrentBattleStage", --已通关
	[hVar.TREASURE_ATTR.MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_HUANGYUEYING] = "CurrentBattleStage", --已通关
	[hVar.TREASURE_ATTR.HERO_COUNT_WEI] = "CurrentGet", --已获得
	[hVar.TREASURE_ATTR.HERO_COUNT_FEMALE] = "CurrentGet", --已获得
	[hVar.TREASURE_ATTR.OPEN_PVP_CHEST] = "CurrentOpenChest", --已开启
	[hVar.TREASURE_ATTR.EQUIP_XILIAN_LOCK] = "CurrentXiLian", --已洗炼
	[hVar.TREASURE_ATTR.EQUIP_COUNT_MOUNT_SLOT4] = "CurrentGet", --已获得
	[hVar.TREASURE_ATTR.TOWER_COUNT_LV5] = "CurrentGet", --已获得
	[hVar.TREASURE_ATTR.CHAPTER_UNLOCKED_NUM] = "__HaveUnlock", --已解锁
	[hVar.TREASURE_ATTR.HERO_COUNT_LV15] = "CurrentGet", --已获得
	[hVar.TREASURE_ATTR.CONSUME_GAMECOIN_TOTALNUM] = "CurrentConsume", --已消耗
	[hVar.TREASURE_ATTR.UNLOCK_SLOT_TOTALNUM] = "CurrentAddSlot", --已打孔
	[hVar.TREASURE_ATTR.REDEQUIP_MERGE_SLOT3_COUNT] = "CurrentMergeRedEquip", --已献祭
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_5_CLEARWUGUI] = "CurrentBattleStage", --已通关
}

--宝物属性位叠加规则
hVar.TREASURE_ATTR_INCREASE_TYPE_LIST =
{
	[hVar.TREASURE_ATTR.PVP_WINCOUNT_CAOCAO] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.PVP_WINCOUNT_LIUGUANZHANG] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.PVP_WINCOUNT_ZHOUYUXIAOQIAO] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_EAZY_DEATH1] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_DIFFICULT] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_DIFFICULT_USE_WUHU] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.ENDLESS_WINCOUNT_LIUGUANZHANG] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.ENDLESS_WINCOUNT_LVBU_DIAOCHAN] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_10_CAOCAO] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_PURPLECARD_NUM] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_10_BUILD_JUPAOTA_10] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_5_BUILD_JUJITA_10] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_PANGTONG] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_HUANGYUEYING] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.HERO_COUNT_WEI] = hVar.TREASURE_ATTR_INCREASE_TYPE.COVER, --覆盖
	[hVar.TREASURE_ATTR.HERO_COUNT_FEMALE] = hVar.TREASURE_ATTR_INCREASE_TYPE.COVER, --覆盖
	[hVar.TREASURE_ATTR.OPEN_PVP_CHEST] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.EQUIP_XILIAN_LOCK] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.EQUIP_COUNT_MOUNT_SLOT4] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.TOWER_COUNT_LV5] = hVar.TREASURE_ATTR_INCREASE_TYPE.COVER, --覆盖
	[hVar.TREASURE_ATTR.CHAPTER_UNLOCKED_NUM] = hVar.TREASURE_ATTR_INCREASE_TYPE.COVER, --覆盖
	[hVar.TREASURE_ATTR.HERO_COUNT_LV15] = hVar.TREASURE_ATTR_INCREASE_TYPE.COVER, --覆盖
	[hVar.TREASURE_ATTR.CONSUME_GAMECOIN_TOTALNUM] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.UNLOCK_SLOT_TOTALNUM] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.REDEQUIP_MERGE_SLOT3_COUNT] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_5_CLEARWUGUI] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.WORLD_CHANNEL_RED_PACKGET_NUM] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.SHOUWEIJIANGE_WINCOUNT] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.JUEZHNANXUKUN_WINCOUNT] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
}

--宝物属性位获取条件
hVar.TREASURE_ATTR_UNLOCK_CONDITION =
{
	--[[
	--模板
	[hVar.TREASURE_ATTR.XXXXXXXXXXXXXX] =
	{
		mapName = {"world/td_wj_006", "world/td_wj_006_02", "world/td_wj_006_03", "world/td_wj_006_04", "world/td_wj_001",}, --地图名 --群英阁
		sessionCfgId = 4, --游戏局配置id（-1或nil表示不限）
		mapDifficultyMin = 0, --最小难度（-1或nil表示不限）
		mapDifficultyMax = 20, --最大难度（-1或nil表示不限）
		useHero = {18001,}, --使用英雄（-1或nil表示不限）
		useHeroBan = {18002,18003,}, --禁用英雄（-1或nil表示不限）
		useHeroAnimType = hVar.ANIMAL_TD_TYPE.DRAGON, --使用英雄的觉醒类型（-1或nil表示不限）
		useHeroInclude = {heros = {}, num = 2,}, --使用其中几个英雄（-1或nil表示不限）
		heroDeathCountMax = 2, --英雄最多死亡次数（-1或nil表示不限）
		gameTimeMax = 200, --最长通关时间（单位:秒）（-1或nil表示不限）
		lifeMin = 5, --最小生命点数（-1或nil表示不限）
		useItem = {12001,12204,12403,12604,}, --携带装备（-1或nil表示不限）
		buildTower = {towerId = 1011, towerNum = 5,}, --地图内塔（塔的战术卡id）达到指定次数（-1或nil表示不限）
		useTactic = {3526,3527,}, --使用战术卡（-1或nil表示不限）
		escapeEnemy = {typeId = 15045, maxCount = 3,}, --漏指定怪最大次数（-1或nil表示不限）
	},
	]]
	
	--竞技场使用曹操胜利场次
	[hVar.TREASURE_ATTR.PVP_WINCOUNT_CAOCAO] =
	{
		mapName = {"world/td_pvp_001",}, --地图名 --夺塔奇兵
		sessionCfgId = 4, --游戏局配置id（-1或nil表示不限）
		mapDifficultyMin = nil, --最小难度（-1或nil表示不限）
		mapDifficultyMax = nil, --最大难度（-1或nil表示不限）
		useHero = {18005,}, --使用英雄（-1或nil表示不限）
		useHeroBan = nil, --禁用英雄（-1或nil表示不限）
		useHeroAnimType = nil, --使用英雄的觉醒类型（-1或nil表示不限）
		useHeroInclude = nil, --使用其中几个英雄（-1或nil表示不限）
		heroDeathCountMax = nil, --英雄最多死亡次数（-1或nil表示不限）
		gameTimeMax = nil, --最长通关时间（单位:秒）（-1或nil表示不限）
		lifeMin = nil, --最小生命点数（-1或nil表示不限）
		useItem = nil, --携带装备（-1或nil表示不限）
		buildTower = nil, --地图内塔（塔的战术卡id）达到指定次数（-1或nil表示不限）
		useTactic = nil, --使用战术卡（-1或nil表示不限）
		escapeEnemy = nil, --漏指定怪最大次数（-1或nil表示不限）
	},
	
	--竞技场使用刘关张胜利场次
	[hVar.TREASURE_ATTR.PVP_WINCOUNT_LIUGUANZHANG] =
	{
		mapName = {"world/td_pvp_001",}, --地图名 --夺塔奇兵
		sessionCfgId = 4, --游戏局配置id（-1或nil表示不限）
		mapDifficultyMin = nil, --最小难度（-1或nil表示不限）
		mapDifficultyMax = nil, --最大难度（-1或nil表示不限）
		useHero = nil, --使用英雄（-1或nil表示不限）
		useHeroBan = nil, --禁用英雄（-1或nil表示不限）
		useHeroAnimType = nil, --使用英雄的觉醒类型（-1或nil表示不限）
		useHeroInclude = {heros = {18001,18002,18003,}, num = 2,}, --使用其中几个英雄（-1或nil表示不限）
		heroDeathCountMax = nil, --英雄最多死亡次数（-1或nil表示不限）
		gameTimeMax = nil, --最长通关时间（单位:秒）（-1或nil表示不限）
		lifeMin = nil, --最小生命点数（-1或nil表示不限）
		useItem = nil, --携带装备（-1或nil表示不限）
		buildTower = nil, --地图内塔（塔的战术卡id）达到指定次数（-1或nil表示不限）
		useTactic = nil, --使用战术卡（-1或nil表示不限）
		escapeEnemy = nil, --漏指定怪最大次数（-1或nil表示不限）
	},
	
	--竞技场使用周瑜小乔胜利场次
	[hVar.TREASURE_ATTR.PVP_WINCOUNT_ZHOUYUXIAOQIAO] =
	{
		mapName = {"world/td_pvp_001",}, --地图名 --夺塔奇兵
		sessionCfgId = 4, --游戏局配置id（-1或nil表示不限）
		mapDifficultyMin = nil, --最小难度（-1或nil表示不限）
		mapDifficultyMax = nil, --最大难度（-1或nil表示不限）
		useHero = {18019,18022,}, --使用英雄（-1或nil表示不限）
		useHeroBan = nil, --禁用英雄（-1或nil表示不限）
		useHeroAnimType = nil, --使用英雄的觉醒类型（-1或nil表示不限）
		useHeroInclude = nil, --使用其中几个英雄（-1或nil表示不限）
		heroDeathCountMax = nil, --英雄最多死亡次数（-1或nil表示不限）
		gameTimeMax = nil, --最长通关时间（单位:秒）（-1或nil表示不限）
		lifeMin = nil, --最小生命点数（-1或nil表示不限）
		useItem = nil, --携带装备（-1或nil表示不限）
		buildTower = nil, --地图内塔（塔的战术卡id）达到指定次数（-1或nil表示不限）
		useTactic = nil, --使用战术卡（-1或nil表示不限）
		escapeEnemy = nil, --漏指定怪最大次数（-1或nil表示不限）
	},
	
	--铜雀台最多死1次通关简单难度次数
	[hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_EAZY_DEATH1] =
	{
		mapName = {"world/td_sl_01", "world/td_sl_02",}, --地图名 --铜雀台
		sessionCfgId = nil, --游戏局配置id（-1或nil表示不限）
		mapDifficultyMin = 1, --最小难度（-1或nil表示不限）
		mapDifficultyMax = 1, --最大难度（-1或nil表示不限）
		useHero = nil, --使用英雄（-1或nil表示不限）
		useHeroBan = nil, --禁用英雄（-1或nil表示不限）
		useHeroAnimType = nil, --使用英雄的觉醒类型（-1或nil表示不限）
		useHeroInclude = nil, --使用其中几个英雄（-1或nil表示不限）
		heroDeathCountMax = 1, --英雄最多死亡次数（-1或nil表示不限）
		gameTimeMax = nil, --最长通关时间（单位:秒）（-1或nil表示不限）
		lifeMin = nil, --最小生命点数（-1或nil表示不限）
		useItem = nil, --携带装备（-1或nil表示不限）
		buildTower = nil, --地图内塔（塔的战术卡id）达到指定次数（-1或nil表示不限）
		useTactic = nil, --使用战术卡（-1或nil表示不限）
		escapeEnemy = nil, --漏指定怪最大次数（-1或nil表示不限）
	},
	
	--铜雀台通关噩梦难度次数
	[hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_DIFFICULT] =
	{
		mapName = {"world/td_sl_01", "world/td_sl_02",}, --地图名 --铜雀台
		sessionCfgId = nil, --游戏局配置id（-1或nil表示不限）
		mapDifficultyMin = 3, --最小难度（-1或nil表示不限）
		mapDifficultyMax = 3, --最大难度（-1或nil表示不限）
		useHero = nil, --使用英雄（-1或nil表示不限）
		useHeroBan = nil, --禁用英雄（-1或nil表示不限）
		useHeroAnimType = nil, --使用英雄的觉醒类型（-1或nil表示不限）
		useHeroInclude = nil, --使用其中几个英雄（-1或nil表示不限）
		heroDeathCountMax = nil, --英雄最多死亡次数（-1或nil表示不限）
		gameTimeMax = nil, --最长通关时间（单位:秒）（-1或nil表示不限）
		lifeMin = nil, --最小生命点数（-1或nil表示不限）
		useItem = nil, --携带装备（-1或nil表示不限）
		buildTower = nil, --地图内塔（塔的战术卡id）达到指定次数（-1或nil表示不限）
		useTactic = nil, --使用战术卡（-1或nil表示不限）
		escapeEnemy = nil, --漏指定怪最大次数（-1或nil表示不限）
	},
	
	--铜雀台使用五虎上将通关噩梦难度次数
	[hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_DIFFICULT_USE_WUHU] =
	{
		mapName = {"world/td_sl_01", "world/td_sl_02",}, --地图名 --铜雀台
		sessionCfgId = nil, --游戏局配置id（-1或nil表示不限）
		mapDifficultyMin = 3, --最小难度（-1或nil表示不限）
		mapDifficultyMax = 3, --最大难度（-1或nil表示不限）
		useHero = {18002,18003,18008,18033,18032,}, --使用英雄（-1或nil表示不限）
		useHeroBan = nil, --禁用英雄（-1或nil表示不限）
		useHeroAnimType = nil, --使用英雄的觉醒类型（-1或nil表示不限）
		useHeroInclude = nil, --使用其中几个英雄（-1或nil表示不限）
		heroDeathCountMax = nil, --英雄最多死亡次数（-1或nil表示不限）
		gameTimeMax = nil, --最长通关时间（单位:秒）（-1或nil表示不限）
		lifeMin = nil, --最小生命点数（-1或nil表示不限）
		useItem = nil, --携带装备（-1或nil表示不限）
		buildTower = nil, --地图内塔（塔的战术卡id）达到指定次数（-1或nil表示不限）
		useTactic = nil, --使用战术卡（-1或nil表示不限）
		escapeEnemy = nil, --漏指定怪最大次数（-1或nil表示不限）
	},
	
	--无尽试炼使用刘关张通关次数
	[hVar.TREASURE_ATTR.ENDLESS_WINCOUNT_LIUGUANZHANG] =
	{
		mapName = {"world/td_wj_001",}, --地图名 --无尽试炼
		sessionCfgId = nil, --游戏局配置id（-1或nil表示不限）
		mapDifficultyMin = nil, --最小难度（-1或nil表示不限）
		mapDifficultyMax = nil, --最大难度（-1或nil表示不限）
		useHero = {18001,18002,18003,}, --使用英雄（-1或nil表示不限）
		useHeroBan = nil, --禁用英雄（-1或nil表示不限）
		useHeroAnimType = nil, --使用英雄的觉醒类型（-1或nil表示不限）
		useHeroInclude = nil, --使用其中几个英雄（-1或nil表示不限）
		heroDeathCountMax = nil, --英雄最多死亡次数（-1或nil表示不限）
		gameTimeMax = nil, --最长通关时间（单位:秒）（-1或nil表示不限）
		lifeMin = nil, --最小生命点数（-1或nil表示不限）
		useItem = nil, --携带装备（-1或nil表示不限）
		buildTower = nil, --地图内塔（塔的战术卡id）达到指定次数（-1或nil表示不限）
		useTactic = nil, --使用战术卡（-1或nil表示不限）
		escapeEnemy = nil, --漏指定怪最大次数（-1或nil表示不限）
	},
	
	--无尽试炼使用吕布貂蝉通关次数
	[hVar.TREASURE_ATTR.ENDLESS_WINCOUNT_LVBU_DIAOCHAN] =
	{
		mapName = {"world/td_wj_001",}, --地图名 --无尽试炼
		sessionCfgId = nil, --游戏局配置id（-1或nil表示不限）
		mapDifficultyMin = nil, --最小难度（-1或nil表示不限）
		mapDifficultyMax = nil, --最大难度（-1或nil表示不限）
		useHero = {18011,18012,}, --使用英雄（-1或nil表示不限）
		useHeroBan = nil, --禁用英雄（-1或nil表示不限）
		useHeroAnimType = nil, --使用英雄的觉醒类型（-1或nil表示不限）
		useHeroInclude = nil, --使用其中几个英雄（-1或nil表示不限）
		heroDeathCountMax = nil, --英雄最多死亡次数（-1或nil表示不限）
		gameTimeMax = nil, --最长通关时间（单位:秒）（-1或nil表示不限）
		lifeMin = nil, --最小生命点数（-1或nil表示不限）
		useItem = nil, --携带装备（-1或nil表示不限）
		buildTower = nil, --地图内塔（塔的战术卡id）达到指定次数（-1或nil表示不限）
		useTactic = nil, --使用战术卡（-1或nil表示不限）
		escapeEnemy = nil, --漏指定怪最大次数（-1或nil表示不限）
	},
	
	--群英阁10+难度使用曹操通关次数
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_10_CAOCAO] =
	{
		mapName = {"world/td_wj_006", "world/td_wj_006_02", "world/td_wj_006_03", "world/td_wj_006_04",}, --地图名 --群英阁
		sessionCfgId = nil, --游戏局配置id（-1或nil表示不限）
		mapDifficultyMin = 10, --最小难度（-1或nil表示不限）
		mapDifficultyMax = 20, --最大难度（-1或nil表示不限）
		useHero = {18005,}, --使用英雄（-1或nil表示不限）
		useHeroBan = nil, --禁用英雄（-1或nil表示不限）
		useHeroAnimType = nil, --使用英雄的觉醒类型（-1或nil表示不限）
		useHeroInclude = nil, --使用其中几个英雄（-1或nil表示不限）
		heroDeathCountMax = nil, --英雄最多死亡次数（-1或nil表示不限）
		gameTimeMax = nil, --最长通关时间（单位:秒）（-1或nil表示不限）
		lifeMin = nil, --最小生命点数（-1或nil表示不限）
		useItem = nil, --携带装备（-1或nil表示不限）
		buildTower = nil, --地图内塔（塔的战术卡id）达到指定次数（-1或nil表示不限）
		useTactic = nil, --使用战术卡（-1或nil表示不限）
		escapeEnemy = nil, --漏指定怪最大次数（-1或nil表示不限）
	},
	
	--群英阁、人族无敌胜利抽到紫卡数量
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_PURPLECARD_NUM] =
	{
		mapName = {"world/td_wj_006", "world/td_wj_006_02", "world/td_wj_006_03", "world/td_wj_006_04", "world/td_wj_007",}, --地图名 --群英阁、人族无敌
		sessionCfgId = nil, --游戏局配置id（-1或nil表示不限）
		mapDifficultyMin = nil, --最小难度（-1或nil表示不限）
		mapDifficultyMax = nil, --最大难度（-1或nil表示不限）
		useHero = nil, --使用英雄（-1或nil表示不限）
		useHeroBan = nil, --禁用英雄（-1或nil表示不限）
		useHeroAnimType = nil, --使用英雄的觉醒类型（-1或nil表示不限）
		useHeroInclude = nil, --使用其中几个英雄（-1或nil表示不限）
		heroDeathCountMax = nil, --英雄最多死亡次数（-1或nil表示不限）
		gameTimeMax = nil, --最长通关时间（单位:秒）（-1或nil表示不限）
		lifeMin = nil, --最小生命点数（-1或nil表示不限）
		useItem = nil, --携带装备（-1或nil表示不限）
		buildTower = nil, --地图内塔（塔的战术卡id）达到指定次数（-1或nil表示不限）
		useTactic = nil, --使用战术卡（-1或nil表示不限）
		escapeEnemy = nil, --漏指定怪最大次数（-1或nil表示不限）
	},
	
	--群英阁10+难度建造10个巨炮塔抽到巨炮精研
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_10_BUILD_JUPAOTA_10] =
	{
		mapName = {"world/td_wj_006", "world/td_wj_006_02", "world/td_wj_006_03", "world/td_wj_006_04",}, --地图名 --群英阁
		sessionCfgId = nil, --游戏局配置id（-1或nil表示不限）
		mapDifficultyMin = 10, --最小难度（-1或nil表示不限）
		mapDifficultyMax = 20, --最大难度（-1或nil表示不限）
		useHero = nil, --使用英雄（-1或nil表示不限）
		useHeroBan = nil, --禁用英雄（-1或nil表示不限）
		useHeroAnimType = nil, --使用英雄的觉醒类型（-1或nil表示不限）
		useHeroInclude = nil, --使用其中几个英雄（-1或nil表示不限）
		heroDeathCountMax = nil, --英雄最多死亡次数（-1或nil表示不限）
		gameTimeMax = nil, --最长通关时间（单位:秒）（-1或nil表示不限）
		lifeMin = nil, --最小生命点数（-1或nil表示不限）
		useItem = nil, --携带装备（-1或nil表示不限）
		buildTower = {towerId = 1012, towerNum = 10,}, --地图内塔（塔的战术卡id）达到指定次数（-1或nil表示不限）
		useTactic = {3077,}, --使用战术卡（-1或nil表示不限）
		escapeEnemy = nil, --漏指定怪最大次数（-1或nil表示不限）
	},
	
	--群英阁5+难度建造10个狙击塔抽到全屏卡
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_5_BUILD_JUJITA_10] =
	{
		mapName = {"world/td_wj_006", "world/td_wj_006_02", "world/td_wj_006_03", "world/td_wj_006_04",}, --地图名 --群英阁
		sessionCfgId = nil, --游戏局配置id（-1或nil表示不限）
		mapDifficultyMin = 5, --最小难度（-1或nil表示不限）
		mapDifficultyMax = 20, --最大难度（-1或nil表示不限）
		useHero = nil, --使用英雄（-1或nil表示不限）
		useHeroBan = nil, --禁用英雄（-1或nil表示不限）
		useHeroAnimType = nil, --使用英雄的觉醒类型（-1或nil表示不限）
		useHeroInclude = nil, --使用其中几个英雄（-1或nil表示不限）
		heroDeathCountMax = nil, --英雄最多死亡次数（-1或nil表示不限）
		gameTimeMax = nil, --最长通关时间（单位:秒）（-1或nil表示不限）
		lifeMin = nil, --最小生命点数（-1或nil表示不限）
		useItem = nil, --携带装备（-1或nil表示不限）
		buildTower = {towerId = 1017, towerNum = 10,}, --地图内塔（塔的战术卡id）达到指定次数（-1或nil表示不限）
		useTactic = {3531,}, --使用战术卡（-1或nil表示不限）
		escapeEnemy = nil, --漏指定怪最大次数（-1或nil表示不限）
	},
	
	--魔塔杀阵使用诸葛亮庞统通关次数
	[hVar.TREASURE_ATTR.MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_PANGTONG] =
	{
		mapName = {"world/td_wj_004",}, --地图名 --魔塔杀阵
		sessionCfgId = nil, --游戏局配置id（-1或nil表示不限）
		mapDifficultyMin = nil, --最小难度（-1或nil表示不限）
		mapDifficultyMax = nil, --最大难度（-1或nil表示不限）
		useHero = {18021,18025,}, --使用英雄（-1或nil表示不限）
		useHeroBan = nil, --禁用英雄（-1或nil表示不限）
		useHeroAnimType = nil, --使用英雄的觉醒类型（-1或nil表示不限）
		useHeroInclude = nil, --使用其中几个英雄（-1或nil表示不限）
		heroDeathCountMax = nil, --英雄最多死亡次数（-1或nil表示不限）
		gameTimeMax = nil, --最长通关时间（单位:秒）（-1或nil表示不限）
		lifeMin = nil, --最小生命点数（-1或nil表示不限）
		useItem = nil, --携带装备（-1或nil表示不限）
		buildTower = nil, --地图内塔（塔的战术卡id）达到指定次数（-1或nil表示不限）
		useTactic = nil, --使用战术卡（-1或nil表示不限）
		escapeEnemy = nil, --漏指定怪最大次数（-1或nil表示不限）
	},
	
	--魔塔杀阵使用诸葛亮黄月英通关次数
	[hVar.TREASURE_ATTR.MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_HUANGYUEYING] =
	{
		mapName = {"world/td_wj_004",}, --地图名 --魔塔杀阵
		sessionCfgId = nil, --游戏局配置id（-1或nil表示不限）
		mapDifficultyMin = nil, --最小难度（-1或nil表示不限）
		mapDifficultyMax = nil, --最大难度（-1或nil表示不限）
		useHero = {18021,18023,}, --使用英雄（-1或nil表示不限）
		useHeroBan = nil, --禁用英雄（-1或nil表示不限）
		useHeroAnimType = nil, --使用英雄的觉醒类型（-1或nil表示不限）
		useHeroInclude = nil, --使用其中几个英雄（-1或nil表示不限）
		heroDeathCountMax = nil, --英雄最多死亡次数（-1或nil表示不限）
		gameTimeMax = nil, --最长通关时间（单位:秒）（-1或nil表示不限）
		lifeMin = nil, --最小生命点数（-1或nil表示不限）
		useItem = nil, --携带装备（-1或nil表示不限）
		buildTower = nil, --地图内塔（塔的战术卡id）达到指定次数（-1或nil表示不限）
		useTactic = nil, --使用战术卡（-1或nil表示不限）
		escapeEnemy = nil, --漏指定怪最大次数（-1或nil表示不限）
	},
	
	--魏国英雄总数量
	[hVar.TREASURE_ATTR.HERO_COUNT_WEI] =
	{
	},
	
	--女性英雄总数量
	[hVar.TREASURE_ATTR.HERO_COUNT_FEMALE] =
	{
	},
	
	--开启战功锦囊
	[hVar.TREASURE_ATTR.OPEN_PVP_CHEST] =
	{
	},
	
	--锁孔洗炼红装
	[hVar.TREASURE_ATTR.EQUIP_XILIAN_LOCK] =
	{
	},
	
	--累计获得4孔坐骑数量
	[hVar.TREASURE_ATTR.EQUIP_COUNT_MOUNT_SLOT4] =
	{
	},
	
	--五级塔总数量
	[hVar.TREASURE_ATTR.TOWER_COUNT_LV5] =
	{
	},
	
	--解锁章节总数量
	[hVar.TREASURE_ATTR.CHAPTER_UNLOCKED_NUM] =
	{
	},
	
	--15级英雄总数量
	[hVar.TREASURE_ATTR.HERO_COUNT_LV15] =
	{
	},
	
	--累计消耗游戏币
	[hVar.TREASURE_ATTR.CONSUME_GAMECOIN_TOTALNUM] =
	{
	},
	
	--累计打孔次数
	[hVar.TREASURE_ATTR.UNLOCK_SLOT_TOTALNUM] =
	{
	},
	
	--合成3孔红装次数
	[hVar.TREASURE_ATTR.REDEQUIP_MERGE_SLOT3_COUNT] =
	{
	},
	
	--群英阁5+难度全清乌龟怪次数
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_5_CLEARWUGUI] =
	{
		mapName = {"world/td_wj_006", "world/td_wj_006_02", "world/td_wj_006_03", "world/td_wj_006_04",}, --地图名 --群英阁
		sessionCfgId = nil, --游戏局配置id（-1或nil表示不限）
		mapDifficultyMin = 5, --最小难度（-1或nil表示不限）
		mapDifficultyMax = 20, --最大难度（-1或nil表示不限）
		useHero = nil, --使用英雄（-1或nil表示不限）
		useHeroBan = nil, --禁用英雄（-1或nil表示不限）
		useHeroAnimType = nil, --使用英雄的觉醒类型（-1或nil表示不限）
		useHeroInclude = nil, --使用其中几个英雄（-1或nil表示不限）
		heroDeathCountMax = nil, --英雄最多死亡次数（-1或nil表示不限）
		gameTimeMax = nil, --最长通关时间（单位:秒）（-1或nil表示不限）
		lifeMin = nil, --最小生命点数（-1或nil表示不限）
		useItem = nil, --携带装备（-1或nil表示不限）
		buildTower = nil, --地图内塔（塔的战术卡id）达到指定次数（-1或nil表示不限）
		useTactic = nil, --使用战术卡（-1或nil表示不限）
		escapeEnemy = {typeId = 21009, maxCount = 0,}, --漏指定怪最大次数（-1或nil表示不限）
	},
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
	[1] = {num = 15, reward = {11, 50, 0, 0,},},
	[2] = {num = 30, reward = {106, 70, 0, 0,},},
	[3] = {num = 50, reward = {108, 90, 0, 0,},},
	[4] = {num = 70, reward = {105, 110, 0, 0,},},
	[5] = {num = 100, reward = {107, 150, 0, 0,},},
}

--宝物升级消耗
hVar.TREASURE_LVUP_INFO = 
{
	--等级上限
	maxTreasureLv = 5,
	
	--[等级] = {商品id(包含消耗的积分和金币), 转化的碎片数, 升级下一级需要消耗的碎片数}
	[0] =	{shopItemId = 414,		toDebris = 0,		costDebris = 20},
	[1] =	{shopItemId = 415,		toDebris = 20,		costDebris = 40},
	[2] =	{shopItemId = 416,		toDebris = 60,		costDebris = 80},
	[3] =	{shopItemId = 417,		toDebris = 140,		costDebris = 120},
	[4] =	{shopItemId = 418,		toDebris = 260,		costDebris = 160},
	[5] =	{shopItemId = 419,		toDebris = 420,		costDebris = nil},
}

------------------------------------------------------------------------
--战车武器枪升星消耗
hVar.WEAPON_STARUP_INFO =
{
	--星级上限
	maxWeaponStar = 4,
	
	--[等级] = {商品id(包含消耗的积分和金币), 转化的碎片数, 升星需要的的等级}
	[0] =	{shopItemId = 424,	costDebris = 100,	requireLv = 0,},
	[1] =	{shopItemId = 425,	costDebris = 200,	requireLv = 9,},
	[2] =	{shopItemId = 426,	costDebris = 300,	requireLv = 19,},
	[3] =	{shopItemId = 427,	costDebris = 500,	requireLv = 29,},
}

------------------------------------------------------------------------
--战车武器升级消耗
hVar.WEAPON_LVUP_INFO =
{
	--等级上限
	maxWeaponLv = 30,
	
	--[等级] = {商品id(包含消耗的积分和金币), 需要的碎片数, 需要的星级}（升星时填的消耗游戏币无效）
	[0] =	{shopItemId = 557,	costDebris = 100,	reqiureStar = 1,},
	[1] =	{shopItemId = 557,	costDebris = 10,	reqiureStar = 1,},
	[2] =	{shopItemId = 558,	costDebris = 10,	reqiureStar = 1,},
	[3] =	{shopItemId = 559,	costDebris = 10,	reqiureStar = 1,},
	[4] =	{shopItemId = 560,	costDebris = 10,	reqiureStar = 1,},
	[5] =	{shopItemId = 561,	costDebris = 10,	reqiureStar = 1,},
	[6] =	{shopItemId = 562,	costDebris = 10,	reqiureStar = 1,},
	[7] =	{shopItemId = 563,	costDebris = 10,	reqiureStar = 1,},
	[8] =	{shopItemId = 564,	costDebris = 10,	reqiureStar = 1,},
	[9] =	{shopItemId = 565,	costDebris = 200,	reqiureStar = 2,},
	[10] =	{shopItemId = 566,	costDebris = 30,	reqiureStar = 2,},
	[11] =	{shopItemId = 567,	costDebris = 30,	reqiureStar = 2,},
	[12] =	{shopItemId = 568,	costDebris = 30,	reqiureStar = 2,},
	[13] =	{shopItemId = 569,	costDebris = 30,	reqiureStar = 2,},
	[14] =	{shopItemId = 570,	costDebris = 30,	reqiureStar = 2,},
	[15] =	{shopItemId = 571,	costDebris = 30,	reqiureStar = 2,},
	[16] =	{shopItemId = 572,	costDebris = 30,	reqiureStar = 2,},
	[17] =	{shopItemId = 573,	costDebris = 30,	reqiureStar = 2,},
	[18] =	{shopItemId = 574,	costDebris = 30,	reqiureStar = 2,},
	[19] =	{shopItemId = 575,	costDebris = 300,	reqiureStar = 3,},
	[20] =	{shopItemId = 576,	costDebris = 50,	reqiureStar = 3,},
	[21] =	{shopItemId = 577,	costDebris = 50,	reqiureStar = 3,},
	[22] =	{shopItemId = 578,	costDebris = 50,	reqiureStar = 3,},
	[23] =	{shopItemId = 579,	costDebris = 50,	reqiureStar = 3,},
	[24] =	{shopItemId = 580,	costDebris = 50,	reqiureStar = 3,},
	[25] =	{shopItemId = 581,	costDebris = 50,	reqiureStar = 3,},
	[26] =	{shopItemId = 582,	costDebris = 50,	reqiureStar = 3,},
	[27] =	{shopItemId = 583,	costDebris = 50,	reqiureStar = 3,},
	[28] =	{shopItemId = 584,	costDebris = 50,	reqiureStar = 3,},
	[29] =	{shopItemId = 585,	costDebris = 500,	reqiureStar = 4,},
	[30] =	{shopItemId = 999,	costDebris = 999,	reqiureStar = 999,},
}

------------------------------------------------------------------------
--战车升级经验、天赋点数表
hVar.TANK_LEVELUP_EXP = 
{	
	--等级上限
	maxLv = 100,
	
	--[[
	--[等级] = {当前等级最低经验值 = 10, 升到下一级所需经验值 = 10,}
	[1] =	{minExp = 0,						nextExp = 50,					talentNum = 1},
	[2] =	{minExp = 50,						nextExp = 100,					talentNum = 2},
	[3] =	{minExp = 150,						nextExp = 150,					talentNum = 3},
	[4] =	{minExp = 300,						nextExp = 200,					talentNum = 4},
	[5] =	{minExp = 500,						nextExp = 250,					talentNum = 5},
	[6] =	{minExp = 750,						nextExp = 300,					talentNum = 6},
	[7] =	{minExp = 1050,						nextExp = 350,					talentNum = 7},
	[8] =	{minExp = 1400,						nextExp = 400,					talentNum = 8},
	[9] =	{minExp = 1800,						nextExp = 450,					talentNum = 9},
	[10] =	{minExp = 2250,						nextExp = 500,					talentNum = 10},
	
	[11] =	{minExp = 2750,						nextExp = 550,					talentNum = 11},
	[12] =	{minExp = 3300,						nextExp = 600,					talentNum = 12},
	[13] =	{minExp = 3900,						nextExp = 650,					talentNum = 13},
	[14] =	{minExp = 4550,						nextExp = 700,					talentNum = 14},
	[15] =	{minExp = 5250,						nextExp = 750,					talentNum = 15},
	[16] =	{minExp = 6000,						nextExp = 800,					talentNum = 16},
	[17] =	{minExp = 6800,						nextExp = 850,					talentNum = 17},
	[18] =	{minExp = 7650,						nextExp = 900,					talentNum = 18},
	[19] =	{minExp = 8550,						nextExp = 950,					talentNum = 19},
	[20] =	{minExp = 9500,						nextExp = nil,					talentNum = 20},
	]]
}
--初始100   后面每级=上级升级需要经验*1.03+100
for i = 1, hVar.TANK_LEVELUP_EXP.maxLv, 1 do
	hVar.TANK_LEVELUP_EXP[i] = {}
	if (i == 1) then
		hVar.TANK_LEVELUP_EXP[i].minExp = 0
		hVar.TANK_LEVELUP_EXP[i].nextExp = 100
	else
		hVar.TANK_LEVELUP_EXP[i].minExp = hVar.TANK_LEVELUP_EXP[i-1].minExp + hVar.TANK_LEVELUP_EXP[i-1].nextExp
		hVar.TANK_LEVELUP_EXP[i].nextExp = math.ceil(hVar.TANK_LEVELUP_EXP[i-1].nextExp*1.05)+50
	end
	hVar.TANK_LEVELUP_EXP[i].talentNum = i
end

------------------------------------------------------------------------
--宠物升星消耗
hVar.PET_STAR_INFO_NEW =
{
	--宠物星级上限
	maxPetStar = 4,
	
	--[等级] = {商品id(包含消耗的积分和金币), 转化的碎片数, 升星需要的的等级}
	[0] =	{shopItemId = 438,	costDebris = 100,	requireLv = 0,},
	[1] =	{shopItemId = 439,	costDebris = 200,	requireLv = 9,},
	[2] =	{shopItemId = 440,	costDebris = 300,	requireLv = 19,},
	[3] =	{shopItemId = 441,	costDebris = 500,	requireLv = 29,},
}

------------------------------------------------------------------------
--宠物升级消耗
hVar.PET_LVUP_INFO_NEW =
{
	--等级上限
	maxPetLv = 30,
	
	--[等级] = {商品id(包含消耗的积分和金币), 需要的碎片数, 需要的星级}（升星时填的消耗游戏币无效，取hVar.PET_STAR_INFO_NEW）
	[0] =	{shopItemId = 607,	costDebris = 100,	reqiureStar = 1,},
	[1] =	{shopItemId = 607,	costDebris = 10,	reqiureStar = 1,},
	[2] =	{shopItemId = 608,	costDebris = 10,	reqiureStar = 1,},
	[3] =	{shopItemId = 609,	costDebris = 10,	reqiureStar = 1,},
	[4] =	{shopItemId = 610,	costDebris = 10,	reqiureStar = 1,},
	[5] =	{shopItemId = 611,	costDebris = 10,	reqiureStar = 1,},
	[6] =	{shopItemId = 612,	costDebris = 10,	reqiureStar = 1,},
	[7] =	{shopItemId = 613,	costDebris = 10,	reqiureStar = 1,},
	[8] =	{shopItemId = 614,	costDebris = 10,	reqiureStar = 1,},
	[9] =	{shopItemId = 615,	costDebris = 200,	reqiureStar = 2,},
	[10] =	{shopItemId = 616,	costDebris = 30,	reqiureStar = 2,},
	[11] =	{shopItemId = 617,	costDebris = 30,	reqiureStar = 2,},
	[12] =	{shopItemId = 618,	costDebris = 30,	reqiureStar = 2,},
	[13] =	{shopItemId = 619,	costDebris = 30,	reqiureStar = 2,},
	[14] =	{shopItemId = 620,	costDebris = 30,	reqiureStar = 2,},
	[15] =	{shopItemId = 621,	costDebris = 30,	reqiureStar = 2,},
	[16] =	{shopItemId = 622,	costDebris = 30,	reqiureStar = 2,},
	[17] =	{shopItemId = 623,	costDebris = 30,	reqiureStar = 2,},
	[18] =	{shopItemId = 624,	costDebris = 30,	reqiureStar = 2,},
	[19] =	{shopItemId = 625,	costDebris = 300,	reqiureStar = 3,},
	[20] =	{shopItemId = 626,	costDebris = 50,	reqiureStar = 3,},
	[21] =	{shopItemId = 627,	costDebris = 50,	reqiureStar = 3,},
	[22] =	{shopItemId = 628,	costDebris = 50,	reqiureStar = 3,},
	[23] =	{shopItemId = 629,	costDebris = 50,	reqiureStar = 3,},
	[24] =	{shopItemId = 630,	costDebris = 50,	reqiureStar = 3,},
	[25] =	{shopItemId = 631,	costDebris = 50,	reqiureStar = 3,},
	[26] =	{shopItemId = 632,	costDebris = 50,	reqiureStar = 3,},
	[27] =	{shopItemId = 633,	costDebris = 50,	reqiureStar = 3,},
	[28] =	{shopItemId = 634,	costDebris = 50,	reqiureStar = 3,},
	[29] =	{shopItemId = 635,	costDebris = 500,	reqiureStar = 4,},
	[30] =	{shopItemId = 999,	costDebris = 999,	reqiureStar = 999,},
}

------------------------------------------------------------------------
--宠物挖矿收益表
hVar.PET_WAKUANG_INFO =
{
	--1星
	[1] = {
		wakuangRequireHour = 999999, --挖矿需要的时间（小时）
		watiliRequireHour = 999999, --挖体力需要的时间（小时）
		wachestRequireHour = 999999, --挖宝箱需要的时间（小时）
	},
	
	--2星
	[2] = {
		wakuangRequireHour = 3, --挖矿需要的时间（小时）
		watiliRequireHour = 3, --挖体力需要的时间（小时）
		wachestRequireHour = 12, --挖宝箱需要的时间（小时）
	},
	
	--3星
	[3] = {
		wakuangRequireHour = 2, --挖矿需要的时间（小时）
		watiliRequireHour = 2, --挖体力需要的时间（小时）
		wachestRequireHour = 6, --挖宝箱需要的时间（小时）
	},
	
	--4星
	[4] = {
		wakuangRequireHour = 1, --挖矿需要的时间（小时）
		watiliRequireHour = 1, --挖体力需要的时间（小时）
		wachestRequireHour = 4, --挖宝箱需要的时间（小时）
	},
}

--基础塔升级分支参数
hVar.TACTIC_UPDATE_JIANTA = {1011, 1014, 1017} --箭塔升级的分支战术技能卡
hVar.TACTIC_UPDATE_FASHUTA = {1013, 1015, 1016,} --法术塔升级的分支战术技能卡
hVar.TACTIC_UPDATE_PAOTA = {1012, 1019, 1018} --炮塔升级的分支战术技能卡

--英雄卡升级经验
hVar.HERO_EXP = hVar.TANK_LEVELUP_EXP
--[等级] = {当前等级最低经验值 = 10, 升到下一级所需经验值 = 10,}



--pvp游戏局内升级最大等级
hVar.HEOR_PVP_LV_MAX = 10
--pvp游戏局内升级经验
hVar.HERO_PVP_EXP = 
{
	--[等级] = {当前等级最低经验值 = 10, 升到下一级所需经验值 = 10,}
	[1] =	{minExp = 0,						nextExp = 600},
	[2] =	{minExp = 600,						nextExp = 800},
	[3] =	{minExp = 1400,						nextExp = 1000},
	[4] =	{minExp = 2400,						nextExp = 1200},
	[5] =	{minExp = 3600,						nextExp = 1400},
	[6] =	{minExp = 5000,						nextExp = 1600},
	[7] =	{minExp = 6600,						nextExp = 1800},
	[8] =	{minExp = 8400,						nextExp = 2000},
	[9] =	{minExp = 10400,					nextExp = 2200},
	[10] =	{minExp = 12600,					nextExp = 2400},		--升满级了，就不让再吃经验了。满级这里填nil
	[11] =	{minExp = 15000,					nextExp = 2600},		--升满级了，就不让再吃经验了。满级这里填nil
	[12] =	{minExp = 17600,					nextExp = 2800},		--升满级了，就不让再吃经验了。满级这里填nil
	[13] =	{minExp = 20400,					nextExp = 3000},		--升满级了，就不让再吃经验了。满级这里填nil
	[14] =	{minExp = 23400,					nextExp = 3200},		--升满级了，就不让再吃经验了。满级这里填nil
	[15] =	{minExp = 26600,					nextExp = nil},			--升满级了，就不让再吃经验了。满级这里填nil

}
-----------------------------------------zhenkira hero setting-----------------------------------------

--td奖励类型
hVar.REWARD_TYPE = {
	SCORE = 1,			--1:积分
	TACTIC = 2,			--2:战术卡
	EQUIPITEM = 3,			--3:道具
	HEROCARD = 4,			--4:英雄
	HERODEBRIS = 5,			--5:英雄将魂
	TACTICDEBRIS = 6,		--6:战术卡碎片
	ONLINECOIN = 7,			--7:游戏币
	NETCHEST = 8,			--8:网络宝箱
	DRAWCARD = 9,			--9:战术卡卡包
	REDEQUIP = 10,			--10:红色神器
	CRYSTAL = 11,			--11:神器晶石
	REDSCROLL = 12,			--12:红装兑换券
	NETDRAWCARD = 13,		--13:服务器下发的抽卡类卡包
	HEROEXP = 14,			--14:英雄经验
	LUCKYREDCHEST = 15,		--15:幸运神器锦囊
	IRON = 16,			--16:铁
	WOOD = 17,			--17:木材
	FOOD = 18,			--18:粮食
	GROUPCOIN = 20,			--19:军团币
	TOWERADDONESFREE = 21,		--21:强化免费券
	TREASUREDEBRIS = 22,		--22:宝物碎片
	CANGBAOTU_NORMAL = 23,		--23:藏宝图
	CANGBAOTU_HIGH = 24,		--24:高级藏宝图
	PVPCOIN = 25,			--25:兵符
	CHOUJIANG_FREETICKET = 26,	--26:抽奖免费券
	
	----------------------------------------------------
	--战车新加奖励类型
	TASK_STONE = 100,		--100:任务之石
	WEAPONGUN_DEBRIS = 101,		--101:武器枪碎片
	PET_DEBRIS = 103,		--103:宠物碎片
	SCIENTIST_DEBRIS = 104,		--104:科学家碎片
	WEAPONGUN_CHEST = 105,		--105:武器枪宝箱
	TACTIC_CHEST = 106,		--106:战术卡宝箱
	PET_CHEST = 107,		--107:宠物宝箱
	EQUIP_CHEST = 108,		--108:装备宝箱
	SCIENTIST_CHEST = 109,		--109:科学家宝箱
	SCIENTIST_ACHEVEMENT1 = 110,	--110:科学家成就1
	SCIENTIST_ACHEVEMENT2 = 111,	--111:科学家成就2
	SCIENTIST_ACHEVEMENT3 = 112,	--112:科学家成就3
	SCIENTIST_ACHEVEMENT4 = 113,	--113:科学家成就4
	DISHU_COIN = 114,		--114:地鼠币
	TANKDEEADTH_ACHEVEMENT1 = 115,	--115:垃圾堆成就1
	TANKDEEADTH_ACHEVEMENT2 = 116,	--116:垃圾堆成就2
	TANKDEEADTH_ACHEVEMENT3 = 117,	--117:垃圾堆成就3
	TANKDEEADTH_ACHEVEMENT4 = 118,	--118:垃圾堆成就4
	TANKDEEADTH_ACHEVEMENT5 = 119,	--119:垃圾堆成就5
	TALENT_POINT = 120,		--120:天赋点
	
	
	REWARD_MAXNUM = 120,		--定义奖励类型最大值
}

--游戏模式
hVar.PLAY_MODE = {
	NORMAL = 0,					--正常游戏模式
	CLASSIC = 1,					--经典英雄无敌模式
	OTHER_LAND = 2,					--别人的领地
	NO_HERO_CARD = 3,				--非装备/经验带入带出模式
	KUMA_GAME = 4,					--特殊模式，此模式下不会获得随机资源和积分
}

--充值赠送的道具
hVar.VIP_GIFT_ITEM = {8200,8201,8203,8204,8202,8020}	--校尉重铠，炎雀指环，神鹰令，绝影，贪狼，青龙偃月刀

--网络商店里面卖的东西
hVar.NET_SHOP_ITEM_DAY_LIMIT = 9999999 --每天购买商品的次数限制
hVar.NET_SHOP_ITEM = {
	
	["Page_Item"] = {
		{345,},
		{92},
		{95},
		{1, hVar.NET_SHOP_ITEM_DAY_LIMIT},
		{7, hVar.NET_SHOP_ITEM_DAY_LIMIT},
		{9, hVar.NET_SHOP_ITEM_DAY_LIMIT},--{3},{5}, --第二个参数为每日购买的次数限制
	},


	
	["Page_HeroCard"] = {
		{15},{19},{13},
		{16},{18},{388},
		{386},
		{382},
		{383},
	},
	
	--geyachao: 每日商品
	["Page_Rune"] = {--兑换类商品
		{198},{199},{200},
	},
	
}



--zhenkira
--DLC地图包列表(shopId)
hVar.NET_SHOP_MAP_DLC = 
{
	[1] = 84,
	[2] = 141,
	[3] = 142,
}

--zhenkira
--App内部互推
hVar.ToOther_Game = 
{
	[1] = "world/td_to_cema_sanguo",
}

if LANGUAG_SITTING and LANGUAG_SITTING == 4 then
	hVar.NET_SHOP_ITEM["Page_Rune"] = nil
end

--战术技能卡片的分解可得积分
hVar.BFSKILL2SOCRE = {
	[1] = {1},
	[2] = {0,0},
	[3] = {50,300,600},
	[4] = {0,0,0,0},
	[5] = {20,50,200,400,600},
	[6] = {0,0,0,0,0,0},
	[7] = {0,0,0,0,0,0,0},
	[8] = {0,0,0,0,0,0,0,0},
	[9] = {0,0,0,0,0,0,0,0,0},
	[10] ={10,20,30,50,100,200,300,400,500,600},
}

--战术技能卡片的升级所需要的条件 {需要同等级卡片的数量,积分,需要游戏币}
hVar.BFSKILL_UPGRADE = {
	[1] = {0},
	[2] = {0,0},
	[3] = {{3,2000,10,6003},{3,5000,20,6004},0,},
	[4] = {0,0,0,0},
	[5] = {0,{2,1000,5,6005},{2,2500,10,6006},{2,5000,20,6007},0,},
	[6] = {0,0,0,0,0,0},
	[7] = {0,0,0,0,0,0,0},
	[8] = {0,0,0,0,0,0,0,0},
	[9] = {0,0,0,0,0,0,0,0,0},
	[10] =
	{
		{1, 10, 1, 0},
		{1, 20, 2, 0},
		{1, 30, 3, 0},
		{1, 40, 4, 0},
		{1, 50, 5, 6008},
		{1, 60, 6, 6009},
		{1, 70, 7, 6010},
		{1, 80, 8, 6011},
		{1, 90, 9, 6012},
		0,
	},
}

hVar.BFSKILL_QUALITY = {
	[1] = {4},
	[2] = {0,0},
	[3] = {2,3,4,},
	[4] = {0,0,0,0},
	[5] = {1,2,2,3,4,},
	[6] = {0,0,0,0,0,0},
	[7] = {0,0,0,0,0,0,0},
	[8] = {0,0,0,0,0,0,0,0},
	[9] = {0,0,0,0,0,0,0,0,0},
	[10] ={1,1,1,1,2,2,3,3,3,4},
}

hVar.BFSKILL_LEVEL = {
	[1] = {10},
	[2] = {0,0},
	[3] = {4,7,10,},
	[4] = {0,0,0,0},
	[5] = {2,4,6,8,10,},
	[6] = {0,0,0,0,0,0},
	[7] = {0,0,0,0,0,0,0},
	[8] = {0,0,0,0,0,0,0,0},
	[9] = {0,0,0,0,0,0,0,0,0},
	[10] ={1,2,3,4,5,6,7,8,9,10},
}

--兵种卡片升级需要消耗的资源{pvp点数}
hVar.PVP_ARMY_PUNISH = 20				--PVP战斗中，拖放多组相同兵种会受到数量惩罚(递减)
hVar.PVP_TACTICS_CARD_LIMIT = 4				--PVP战斗中，最多允许使用4张战术卡片
hVar.PVP_TACTICS_CARD_CLASS_LIMIT = 3			--PVP战斗中，每类兵种的战术卡片最多允许使用3张
hVar.PVP_ARMY_CARD_UPRADE = {
	[1] = {0},
	[2] = {0,0},
	[3] = {0,0,0},
	[4] = {0,0,0,0},
	[5] = {200,350,500,700,900},
	[6] = {0,0,0,0,0,0},
	[7] = {0,0,0,0,0,0,0},
	[8] = {0,0,0,0,0,0,0,0},
	[9] = {100,150,200,250,300,350,400,450,500},
	[10] ={0,0,0,0,0,0,0,0,0,0},
}

--副将ID表
hVar.ASSISTANT_ID_LIST = {
	--6000,
	--6001,
	--6002,
	--6003,
}

hVar.FONTC = "coh_2018.ttf"
--hVar.FONTC = "Arial"
hVar.LANGUAGE = {
	SC = 1,
	TC = 2,
	EN = 3,
	JP = 4,
}

--vip配置 zhenkira
hVar.Vip_Conifg =
{
	maxVipLv = 5,		--当前开放vip最大等级
	condition = {		--达成vip所需条件
		rmb = {
			[0] = 0,
			[1] = 10,
			[2] = 50,
			[3] = 100,
			[4] = 200,
			[5] = 500,
			[6] = 1000,
			[7] = 2000,
			[8] = 4000,
		},
		coin = {--充值多少金币变vip
			[0] = 0,
			[1] = 100,
			[2] = 500,
			[3] = 1000,
			[4] = 2000,
			[5] = 5000,
			[6] = 10000,
			[7] = 20000,
			[8] = 40000,
		},
	},
	
	--每日领取
	dailyReward = {
		[0] = nil,
		[1] = {
			--每日奖励1
			[1] = {
				{114,3}, --地鼠币
			},
			
			--每日奖励2
			[2] = {
				{105,5}, --武器枪宝箱
				{11,10}, --锻造材料
			},
		},
		[2] = {
			--每日奖励1
			[1] = {
				{114,6}, --地鼠币
			},
			
			--每日奖励2
			[2] = {
				{105,10}, --武器枪宝箱
				{11,20}, --锻造材料
			},
		},
		[3] = {
			--每日奖励1
			[1] = {
				{114,6}, --地鼠币
			},
			
			--每日奖励2
			[2] = {
				{105,10}, --武器枪宝箱
				{11,20}, --锻造材料
			},
		},
		[4] = {
			--每日奖励1
			[1] = {
				{114,6}, --地鼠币
			},
			
			--每日奖励2
			[2] = {
				{105,10}, --武器枪宝箱
				{11,20}, --锻造材料
			},
		},
		[5] = {
			--每日奖励1
			[1] = {
				{114,6}, --地鼠币
			},
			
			--每日奖励2
			[2] = {
				{105,10}, --武器枪宝箱
				{11,20}, --锻造材料
			},
		},
		[6] = {
			--每日奖励1
			[1] = {
				{114,6}, --地鼠币
			},
			
			--每日奖励2
			[2] = {
				{105,10}, --武器枪宝箱
				{11,20}, --锻造材料
			},
		},
		[7] = {
			--每日奖励1
			[1] = {
				{114,6}, --地鼠币
			},
			
			--每日奖励2
			[2] = {
				{105,10}, --武器枪宝箱
				{11,20}, --锻造材料
			},
		},
		[8] = {
			--每日奖励1
			[1] = {
				{114,6}, --地鼠币
			},
			
			--每日奖励2
			[2] = {
				{105,10}, --武器枪宝箱
				{11,20}, --锻造材料
			},
		},
	},
	
	--一次性奖励
	oneoffReward = {
		[0] = nil,
		[1] = nil,
		[2] = nil,
		[3] = {
			{6,15211,2000,1,},		--类型，数量，等级
		},
		[4] = {
			{6,15213,2000,1,},		--类型，数量，等级
		},
		[5] = {
			{101,15013,380,1,},		--类型，数量，等级
		},
		[6] = {
			{4,18022,2,1,},		--类型,英雄ID，星级，等级 (小乔2星)
		},
		[7] = {
			{12,2,0,0,},		--红装兑换券
			{22,10824,260,0,},		--宝物碎片
		},
		[8] = {
			{4,18037,1,1,},		--类型,英雄ID，星级，等级 (大乔1星)
		},
	},
	
	--vip7以上额外奖励，每充2000rmb，得奖励
	vip7ExtraReward = {
		rmb = 2000,				--每充n游戏币
		reward = {				--获得奖励, 红装兑换券
			{12,1,0,0,},
		},
	},
	
	--背包容量
	bagPageNum = {
		[0] = 5,
		[1] = 6,
		[2] = 7,
		[3] = 8,
		[4] = 9,
		[5] = 10,
		[6] = 11,
		[7] = 12,
		[8] = 13,
	},
	
	--免费刷新碎片商店次数
	netshopRefreshCount = {
		[0] = 0,
		[1] = 6,
		[2] = 7,
		[3] = 8,
		[4] = 9,
		[5] = 10,
		[6] = 10,
		[7] = 10,
		[8] = 10,
	},
	
	--锁孔洗练限制次数
	xilianLockCount = {
		[0] = -1, --50,
		[1] = -1, --50,
		[2] = -1, --50,
		[3] = -1,
		[4] = -1,
		[5] = -1,
		[6] = -1,
		[7] = -1,
		[8] = -1,
	},
	
	--开启竞技场锦囊是否不需要等待直接开
	openChestFree = {
		[0] = false,
		[1] = false,
		[2] = false,
		[3] = false,
		[4] = false,
		[5] = false,
		[6] = true,
		[7] = true,
		[8] = true,
	},
	
	--游戏内加速倍率
	playSpeed = {
		[0] = 2,
		[1] = 2,
		[2] = 3,
		[3] = 3,
		[4] = 3,
		[5] = 3,
		[6] = 3,
		[7] = 3,
		[8] = 3,
	},
	
	--世界聊天每日最大次数(-1表示无限制)
	chatWorldMsgNum = {
		[0] = -1, --10,
		[1] = -1, --20,
		[2] = -1, --30,
		[3] = -1,
		[4] = -1,
		[5] = -1,
		[6] = -1,
		[7] = -1,
		[8] = -1,
	},
	
	--创建军团权限
	createGroup = {
		[0] = false,
		[1] = false,
		[2] = true,
		[3] = true,
		[4] = true,
		[5] = true,
		[6] = true,
		[7] = true,
		[8] = true,
	},
	
	--军团兑换碎片每日次数
	groupExchageDebrisCount = {
		[0] = 1,
		[1] = 1,
		[2] = 2,
		[3] = 3,
		[4] = 4,
		[5] = 5,
		[6] = 6,
		[7] = 7,
		[8] = 8,
	},
	
	--军团发红包每日次数
	groupSendRedpacketCount = {
		[0] = 0,
		[1] = 0,
		[2] = 0,
		[3] = 1,
		[4] = 2,
		[5] = 3,
		[6] = 4,
		[7] = 5,
		[8] = 6,
	},
	
	--每日可扫荡次数
	dailySaoDangCount = {
		[0] = 0,
		[1] = 0,
		[2] = 0,
		[3] = 10,
		[4] = 15,
		[5] = 20,
		[6] = 25,
		[7] = 30,
		[8] = 35,
	},
	
	--宠物可派遣数量
	petSendMaxCount = {
		[0] = 2,
		[1] = 2,
		[2] = 2,
		[3] = 2,
		[4] = 3,
		[5] = 4,
		[6] = 4,
		[7] = 4,
		[8] = 4,
	},
	
	--每日体力上限
	tiliDailyMax = {
		[0] = 60,
		[1] = 70,
		[2] = 80,
		[3] = 90,
		[4] = 100,
		[5] = 110,
		[6] = 120,
		[7] = 130,
		[8] = 140,
	},
	
	--每日体力补给
	tiliDailySupply = {
		[0] = 60,
		[1] = 70,
		[2] = 80,
		[3] = 90,
		[4] = 100,
		[5] = 110,
		[6] = 120,
		[7] = 130,
		[8] = 140,
	},
	
	--每日体力购买次数上限
	tiliDailyBuyCount = {
		[0] = 2,
		[1] = 3,
		[2] = 4,
		[3] = 5,
		[4] = 6,
		[5] = 7,
		[6] = 8,
		[7] = 9,
		[8] = 10,
	},
	
	--战车经验额外加成
	tankExpAddRate = {
		[0] = 0,
		[1] = 0.1,
		[2] = 0.15,
		[3] = 0.2,
		[4] = 0.25,
		[5] = 0.3,
		[6] = 0,
		[7] = 0,
		[8] = 0,
	},
	
	--vip地图内摆放的单位
	mapUnit = {
		[0] = 0,
		[1] = 40008,
		[2] = 40007,
		[3] = 40000,
		[4] = 40001,
		[5] = 40003,
		[6] = 0,
		[7] = 0,
		[8] = 0,
	},
	
	--战斗开始雕像数量
	ironmanItemSkillNum = {
		[0] = 0,
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
		[5] = 1,
		[6] = 1,
		[7] = 1,
		[8] = 1,
	},
}

--VIP说明表
hVar.VipInfo = {
	iconList =
	{
		[1] = "misc/tempbag/iconbag.png",		--仓库
		[2] = "misc/gameover/icon_exp.png",		--经验值
		[3] = "effect/sf3.png",				--顺丰快递箱
		[4] = "effect/sf4.png",				--高级顺丰快递箱
		[5] = "misc/coin2.png",				--地鼠币
		[6] = "misc/task/tili.png",			--体力
		[7] = "misc/task/ironbuf_refresh.png",			--商店刷新
		[8] = "icon/hero/tank_01.png",			--蜘蛛坦克1
		[9] = "icon/hero/tank_02.png",			--蜘蛛坦克2
		[10] = "effect/buff_n11.png",			--弹射球碎片
		[11] = "effect/buff_n13.png",			--巨浪碎片
		[12] = "icon/hero/pet_01.png",			--宠物碎片
		[13] = "icon/item/gun_13.png",			--终结者机枪碎片
		[14] = "MODEL:UNIT_IRONMAN",			--铁人雕像
	},
	
	icon =
	{
		[1] = {1, 2, 3, 5, 6, 7, 8,},
		[2] = {1, 2, 4, 5, 6, 7, 9,},
		[3] = {1, 2, 4, 5, 6, 7, 10,},
		[4] = {1, 2, 4, 5, 6, 7, 11, 12,},
		[5] = {1, 2, 4, 5, 6, 7, 13, 12, 14},
		[6] = {1, 2, 11, 12, 14, 4, 5, 7, 15,},
		[7] = {1, 2, 11, 12, 14, 4, 5, 9, 16, 10,},
		[8] = {1, 2, 11, 12, 14, 4, 5, 13, 17, 10,},
	},
	
	[1] = {"vipStr1", "vipStr9", "vipStr2", "vipStr3", "vipStr16", "vipStr17", "vipStr18",},
	[2] = {"vipStr4", "vipStr19", "vipStr5", "vipStr6", "vipStr20", "vipStr21", "vipStr22",},
	[3] = {"vipStr7", "vipStr23", "vipStr5", "vipStr6", "vipStr31", "vipStr24", "vipStr8",},
	[4] = {"vipStr10", "vipStr25", "vipStr5", "vipStr6", "vipStr32", "vipStr26", "vipStr11", "vipStr27",},
	[5] = {"vipStr13", "vipStr28", "vipStr5", "vipStr6", "vipStr33", "vipStr29", "vipStr14", "vipStr30", "vipStr15"},
}


--vip等级对应的充值的金钱
hVar.VipRmb = hVar.Vip_Conifg.condition.rmb

---vip等级对应的充值的游戏币
hVar.VipCoin = hVar.Vip_Conifg.condition.coin

hVar.VipCard = {
	NOCARD = -2,
	CHANGE1 = -1,
	NOREST = 0,
	ONE = 1,
	TWO = 2,
	THREE = 3,
	FOUR = 4,
}

hVar.TEMP_HANDLE_TYPE = {
	NONE = 0,
	NORMAL = 1,
	OBJECT_UI = 2,
	OBJECT_WM = 3,
	OBJECT_BF = 4,
	OBJECT_TN = 5,
	IMAGE_UI = 6,
	UNIT_WM = 7,
	EFFECT_WM = 8,
	MAP_CHOOSE_LEVEL = 9,
	MAP_PHONE_MAIN_MENU = 10,
	UI_SHOP = 11,
	UI_GRID_AUTO_RELEASE = 12,
	UI_IMAGE_AUTO_RELEASE = 13,
}

hVar.FONTC_SIZE = {
	[hVar.LANGUAGE.SC] = {
		
	},
	[hVar.LANGUAGE.TC] = {
		--[16] = 14,
		--[18] = 16,
		--[20] = 18,
		--[22] = 20,
		--[24] = 22,
		--[26] = 24,
		--[28] = 26,
		--[30] = 28,
		--[32] = 30,
		--[34] = 32,
		--[36] = 34,
		--[38] = 36,
		--[40] = 38,
		--[42] = 40,
		--[44] = 42,
		--[46] = 44,
		--[48] = 46,
	},
	[hVar.LANGUAGE.EN] = {
		--[16] = 10,
		--[18] = 12,
		--[20] = 14,
		--[22] = 16,
		--[24] = 18,
		--[26] = 20,
		--[28] = 22,
		--[30] = 24,
		--[32] = 26,
		--[34] = 28,
		--[36] = 30,
		--[38] = 32,
		--[40] = 34,
		--[42] = 36,
		--[44] = 38,
		--[46] = 40,
		--[48] = 42,
	},
	[hVar.LANGUAGE.JP] = {
		--[16] = 12,
		--[18] = 14,
		--[20] = 16,
		--[22] = 18,
		--[24] = 20,
		--[26] = 22,
		--[28] = 24,
		--[30] = 26,
		--[32] = 28,
		--[34] = 30,
		--[36] = 32,
		--[38] = 34,
		--[40] = 36,
		--[42] = 38,
		--[44] = 40,
		--[46] = 42,
		--[48] = 44,
	},
}

hVar.MadelGift = {
	{705,1},
	{455,1},
	{550,1},
	{703,1},
	{0,0},
	{20,8},
	{704,1},
	{701,5},
	{700,2},
	{152,3},
}

hVar.PHONE_MAINDOTA =  "town/town_maindota"
hVar.PHONE_MAINMENU =  "town/town_mainmenu"
hVar.PHONE_SELECTLEVEL = "town/select_map"
hVar.PHONE_SELECTLEVEL_3 = "town/select_map3"
hVar.PHONE_VIPMAP = "town/select_vipmap"
hVar.PVP_MAP = "town/pvp_map"

--为了使一些地图在手机模式下拥有相同的UI层判断 故增加此表 这张表在 函数 CheckMapNameIsPhoneCondition 中使用
hVar.PHONE_Legal_MapName = {
	[1] = hVar.PHONE_SELECTLEVEL,
	[2] = hVar.PHONE_VIPMAP,
}

hVar.CURRENT_SAVE_VERSION		=	5	--当前存档的版本号
hVar.CURRENT_PALUERLIST_VERSION		=	1	--当前玩家表版本号
hVar.CURRENT_ITEM_VERSION		=	1	--本设备当前道具的版本号（游戏脚本版本号）
hVar.MAXMEDALNUM =				12	--玩家勋章个数
hVar.RESULT_SUCESS = 1
hVar.RESULT_FAIL = false
hVar.ZERO = 0
hVar.DEFAULT_MAP_DIFFICULTY		= 3		--地图难度(1~6)
hVar.TEAM_UNIT_MAX = 7
hVar.UNIT_STACK_MAX = 99999
hVar.HERO_EQUIP_SIZE = 12			--战车英雄可穿12件装备
hVar.HERO_BAG_SIZE = 0
hVar.HERO_TALENT_TREE_SIZE = 8			--大菠萝坦克天赋技能总数量
hVar.HERO_WEAPON_UNIT_SIZE = 20			--大菠萝坦克武器总数量
hVar.HERO_PET_UNIT_SIZE = 10			--大菠萝坦克宠物总数量
hVar.HERO_TALENT_SIZE = 4				--当前开放的最大英雄技能数量 --zhenkira
hVar.HERO_TACTIC_SIZE = 1				--当前开放的最大英雄战术技能数量 --zhenkira
hVar.MAP_BAG_SIZE = 32
hVar.DEFAULT_BATTLEFIELD = "battlefield_1"
hVar.DEFAULT_WORLDMAP = "worldmap_1"
hVar.DEFAULT_EDITOR_WORLDMAP = "test/empty"
hVar.DEFAULT_TOWN = "town01"
hVar.DEFAULT_FONT = "Arial"
hVar.DEFAULT_FONT_SIZE = 24
hVar.BATTLEFIELD_MOVE_SPEED = 20			--战场内单位移动速度 --geyachao: 修改默认值 80
hVar.BATTLEFIELD_ACTION_SPEED = 100			--战场内单位技能施放速度（动画）
hVar.BUTTON_BORDER = 15					--在较小的设备上工作时，按钮touchUp的成功区域会被放大，数值等于此像素的级别
hVar.SCEOBJ_SELECTABLE = 0				--允许选择场景物件
hVar.ITEM_UNIT_ID = 2					--道具单位ID
hVar.CREEP_PLAYER_ID = -1				--野怪玩家ID
hVar.MAX_PLAYER_NUM = 12				--最大玩家数量1~N
hVar.UNIT_DEFAULT_SPEED = 80				--默认移动速度 --geyachao: 修改默认值
hVar.UNIT_DEFAULT_MOVEPOINT = 65535			--默认移动点数 --geyachao: 修改默认值
hVar.UNIT_DEFAULT_MOVEPOINT_W = 400			--默认水上移动点数
hVar.UNIT_DAMAGE_TO_HERO_NORMAL = 20			--单位对英雄造成伤害时，如果（堆叠）数量超过此值，计算堆叠伤害时超过部分将产生递减
hVar.UNIT_DAMAGE_TO_HERO_MAX = 56			--单位对英雄造成伤害时，计算伤害（堆叠）数量不会超过此值
hVar.UNIT_DAMAGE_TO_HERO_BY_LEVEL = 2			--单位对英雄造成伤害时，上限会随着此等级提升
hVar.UNIT_DEFAULT_FACING = 270				--单位默认出生角度
hVar.HERO_LEVEL_LIMIT = 12				--英雄等级上限
hVar.HERO_RELIVE_MAX_COUNT = 10				--关切免游戏币复活次数
hVar.PLAYER_ACTIVED_BFSKILL_NUM = 100			--玩家可使用的战术技能卡片数量
hVar.PLAYER_UNLOCK_ACTIVED_BFSKILL_NUM = 6		--玩家可使用的战术技能卡片数量
hVar.HERO_SKILL_REQUIRE = {				--英雄技能等级需求
	1,3,6,9,12,
}
--复生英雄花费(lv)
hVar.HERO_REVIVE_COST = {
	1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,
}
--雇佣英雄花费(雇佣英雄数量)
hVar.HERO_HIRE_COST = {
	3000,
}
hVar.PLAYER = {
	NEUTRAL_ENEMY = -1,				--野怪,战场敌军
	NEUTRAL = 0,					--野怪
	NEUTRAL_ALLY = 8,				--中立友军玩家(和玩家1是友好关系，和其他玩家敌对)
	NEUTRAL_PASSIVE = 9				--中立友好玩家(不会被任何敌人注意到)
}
hVar.TGR_CODE_IN_TALK = {}				--解析触发器对话的表
hVar.MOVE_SKILL_ID = 10					--移动技能id
hVar.ENCOUNTERED_ATTACK_ID = 22				--远程单位（措手不及）攻击技能ID
hVar.GUARD_SKILL_ID = 12				--防御技能id
hVar.WAIT_SKILL_ID = 11					--等待技能id
hVar.PUBLIC_SKILL_ID = {				--单位拥有的公共技能,公共技能需要在这里注册，否则禁止施放
	[hVar.MOVE_SKILL_ID] = 1,
	[hVar.ENCOUNTERED_ATTACK_ID] = 1,
	[hVar.GUARD_SKILL_ID] = 1,
}
hVar.AI_MODE = {
	NORMAL = 0,			--一般的AI
	GUARD = 1,			--守卫模式的AI 不动只长兵
	CHASE = 2,			--追击模式的AI
	PASSIVE = 3,		--什么也不做的AI，也会被所有其他AI自动忽略
	GUARD_CITY = 4,		--守卫城市的AI
	POLICY_CHASE = 5,	--在有追击目标的大方针下 进行类似普通ai的行动
	DIRECT_CHASE = 6,	--只往目标前进 中间不做任何事情
	GUARD_AGAINST = 7,	--守卫领地AI 如果范围内有敌人自动攻击否则不动（不长兵的哦）
}

--刀光类型对应的路径
hVar.SLASH_PATH = {
	["slash_1"] = {"data/image/effect/daoguang.png","data/image/effect/daoguang01.png","data/image/effect/chain_001.png","data/image/effect/stone_f.png",},
	--["slash_2"] = "data/image/effect/daoguang01.png",
}

hVar.SAVE_DATA_PATH = {
	PLAYER_LIST = "playerlist.sav",
	HERO_LIST = "herolist.sav",
	MAP_SAVE = "autosave.sav",
	FOG = "autosave.fog",
	MY_CITY = "citysave.sav",
	PLAYER_DATA = "playerdata.sav",
	PLAYER_LOG = "playerlog.sav",

	--安卓版特有的数据分片存档
	TEMP_PLAYER_BAG = "tempB.d",
	TEMP_PLAYER_HERO = "tempH.d",
	TEMP_PLAYER_CARD = "tempC.d",
	TEMP_PLAYER_MAP = "tempM.d",
	TEMP_PLAYER_MAT = "tempMT.d",
	TEMP_PLAYER_LOG = "tempLG.d",
}

--存在于 keyChain 中的存档上传状态标记，客户端根据此值判断是否需要上传存档分段
hVar.DATA_SEND_STATE = {
	TEMP_PLAYER_BAG = "_bag",
	TEMP_PLAYER_HERO = "_hero",
	TEMP_PLAYER_CARD = "_card",
	TEMP_PLAYER_MAP = "_map",
	TEMP_PLAYER_MAT = "_mat",
	TEMP_PLAYER_LOG = "_log",
}

--根据参数列表格式化本地存档
--是否更换设备
--是否启用服务器存档
--快照ID
hVar.CONST_KEY2PATH = {
	["map"] = "TEMP_PLAYER_MAP",
	["card"] = "TEMP_PLAYER_HERO",
	["skill"] = "TEMP_PLAYER_CARD",
	["material"] = "TEMP_PLAYER_MAT",
	["bag"] = "TEMP_PLAYER_BAG",
	["log"] = "TEMP_PLAYER_LOG",
}
------------------------------------------------
-- 回合定义(会在round.lua中被重载)
hVar.ROUND_DEFINE = {
	ACTIVE_MODE = {},
	SORT_MODE = {},
	DATA_INDEX = {},
}
------------------------------------------------

--主城的科技类型
hVar.TECHNOLOGY_TYPE = {
	[1] = "atklevel",
	[2] = "deflevel",
	[3] = "templelv",
	
}

--成就信息
hVar.ACHIEVEMENT_TYPE = {
	LEVEL = 1,			--是否通关 ok
	MAPSTAR = 2,			--评价星星 ok
	RICHMAN = 3,			--富可敌国成就
	BLITZ = 4,			--闪电战成就
	BATTLECOUNT = 5,		--发生过的战斗次数
	PLAYDAY = 6,			--完成天数
	GETGOLD = 7,			--获得过的最多金钱数
	IMPERIAL = 8,			--挑战难度模式获得的评价星星 ok
	KILLSMOEBOSS = 9,		--击杀的boss 数
	SPECIAL_EVENT = 10,		--特殊事件
	UNIQUE_QUEST_1 = 11,		--任务1
	UNIQUE_QUEST_2 = 12,		--任务2
	UNIQUE_QUEST_3 = 13,		--任务3
	UNIQUE_QUEST_4 = 14,		--任务4
	UNIQUE_QUEST_5 = 15,		--任务5
	FINISH_COUNT = 16,		--通关次数 ok
	Map_Difficult = 17,		--地图难度 ok
	Enemy_Num = 18,			--敌人波数
	Map_GetScore = 19,		--通关时在本关获得过的积分累积 ok
	Map_ScoreRound = 20,		--获得积分时打了多少个怪
	Map_ScoreFinishiCount = 21,	--有了统计获得积分之后的通关次数
}

--试炼地图成就信息 【已废弃，如果要用找 陶晶...】
hVar.ACHIEVEMENTEX_TYPE = {
	Map_Difficult= 1,
	Enemy_Num = 2,
	LEVEL = 3,
	SPECIAL_EVENT = 10,	--特殊事件
	UNIQUE_QUEST_1 = 11,	--任务1
	UNIQUE_QUEST_2 = 12,	--任务2
	UNIQUE_QUEST_3 = 13,	--任务3
	UNIQUE_QUEST_4 = 14,	--任务4
	UNIQUE_QUEST_5 = 15,	--任务5
	FINISH_COUNT = 16,	--通关次数
}

--勋章信息
--hVar.MEDAL_TYPE = {
--}
--for i = 1,12 do
--	hVar.MEDAL_TYPE[i] = i
--end

--默认首冲奖励道具
hVar.GiftItem = {
	{11001,1,0,"i"},	--6元档
	{11002,1,0,"i"},	--18元档
	--{11003,1,0,"i"},	--已废弃30元档
	{11004,1,0,"i"},	--68元档
	{18008,1,0,"H"},	--98元档
	{11005,1,0,"i"},	--198元档
	{12003,1,0,"i"},	--388元档
}

hVar.SCREEN = {w=1024,h=768,offx = 0,battleUI_offy = 0}

--在目标点施法的结果类型
hVar.CAST_POINT_SKILL_RESULT =
{
	NONE = 0,		--无
	SUCCESS = 1,		--成功
	INVALID_POINT = 2,	--无效的目标点
	INVALID_ROAD = 3,	--该路面不能建造塔
	COLLAPSE_UNIT = 4,	--目标点和单位重叠
	COLLAPSE_TOWER = 5,	--目标点和附近建筑重叠
	
	TRIANGLE_TOONEAR = 6,	--目标点距离附近风暴塔太近
	TRIANGLE_TOOFAR = 7,	--目标点距离附近风暴塔太远
	TRIANGLE_INVALID_ANGLE = 8,	--目标点和现有风暴塔组成的三角形区域太小
}

--新无尽塔之间建造的最短距离
hVar.ROLE_BUILD_TOWER_DIS_MIN = 72

--钩子运动方向
hVar.HOOK_DIRECTION_FRONT = 1 --向前运动
hVar.HOOK_DIRECTION_BACK = 2 --向后运动

hVar.ObjectZ = {
	MAP = -1,
	GROUND = 0,
	SCEOBJ = 1,
	EFFECT = 5,
	UNIT = 10,
	OVERHEAD = 10000,
	UI = 50000,
}

hVar.DefaultBox = {
	NONE = {0,0,0,0},
	UNIT = {-20,-34,40,44},
	EFFECT = {-10,-10,20,20},
	SCEOBJ = {-15,-15,30,30},
	RESOURCE = {-15,-15,30,30},
}
hVar.BUILDING_TYPE_EX = {--建筑物的扩展类型
	NONE = 0,--无
	TOWN = 1,--主城
	PROVIDE = 2,--资源矿场
	VISIT = 3,--奖励建筑
	HIRE = 4,--野外雇佣
	SHOP = 5,--商店
}
hVar.ROUND_ORDER_TYPE = {
	NONE = 0,
	FINISHED = 1,
	AVAILABLE = 2,
	AUTO = 3,
}
hVar.UNIT_LOOT_TYPE = {
	NONE = 0,
	CHOOSE = 1,			--可选择的必然有UI
	ALL = 2,			--全部给
	RANDOM = 3,			--随机给一个
	ALL_WITH_UI = 4,		--全部给，并且显示UI
	RANDOM_WITH_UI = 5,		--随机给，并且显示UI
}
hVar.INTERACTIONBOX_TYPE = {
	NONE = 0,
	REWARD = 1,
}
hVar.UNIT_REWARD_TYPE = {
	NONE = 0,
	CHOOSE = 1,
	RANDOM = 2,
	ALL = 3,
	RANDOMBOX = 4,
}

hVar.VIP_REC_TYPE = {
	RECEIVE = 1,
	CHANGECARD = 2,
	GETCARD = 3,
}

--VIP 对应的背包长度
hVar.VIP_BAG_LEN = hVar.Vip_Conifg.bagPageNum

--=============================================================
-- 技能AI类型
--=============================================================
--{优先级,选择概率}
--会将角色拥有的技能按照优先度从高到低排列
--从同优先级的技能中选择随机技能施放
--范围技能自动追加Area后缀
--tab_skill[id].ai_type = "Damage"/"Heal"/"Buff"/"Debuff"
hVar.SKILL_AI_TYPE = {
	["Default"] = {1,100},
	["Damage"] = {4,75},
	["Heal"] = {3,75},
	["DamageArea"] = {4,50},
	["HealArea"] = {2,50},
	["Buff"] = {2,50},
	["Debuff"] = {2,50},
	["BuffArea"] = {3,20},
	["DebuffArea"] = {3,20},
}
--=============================================================
-- 伤害类型
--=============================================================
hVar.DAMAGE_TYPE = {
	NONE = 0,		--真实伤害
	PHYSICAL = 1,		--物理
	MAGIC = 2,		--法术
	ICE = 3,		--冰
	THUNDER = 4,		--雷
	FIRE = 5,		--火
	POISON = 6,		--毒
	BULLET = 7,		--子弹伤害
	BOMB = 8,		--爆炸伤害
	CHUANCI = 9,		--穿刺伤害
}
hVar.DAMAGE_DEF_MODULUS = 100 --伤害的防御系数
--=============================================================
-- 玩家定义
--=============================================================
hVar.LOCAL_OPERATE_TYPE = {
	NONE = 0,
	TOUCH_DOWN = 1,
	TOUCH_UP = 2,
	TOUCH_MOVE = 3,

	SELECT_GRID = 4,
	SELECT_UNIT = 5,
}
hVar.ORDER_TYPE = {
	NONE =			0,
	NORMAL =		1,	--一般命令
	SYSTEM_FIRST_ROUND =	2,	--首回合发出的系统命令，必须执行
	SYSTEM =		3,	--系统命令，必须执行
	COUNTER =		4,	--反击发出的命令
	ASSIST =		5,	--触发型技能发出的命令
	AFTER_COUNTER =		6,	--成功反击后发出的命令
	COPY_CAST =		7,	--复制施法
}
hVar.OPERATE_TYPE = {
	OB_MODE = -1,			--此模式下玩家将不能进行操作
	NONE =			0,
	UNIT_MOVE =		1,
	UNIT_MOVE_TO_UNIT =	2,
	UNIT_LOOT =		3,
	UNIT_ATTACK =		4,
	UNIT_ENTER =		5,
	UNIT_OCCUPY =		6,
	UNIT_CAPTURE =		7,
	UNIT_VISIT =		8,
	UNIT_JOIN =		9,
	UNIT_REST =		10,
	UNIT_TALK =		11,
	
	UNIT_MARKET =		12,
	UNIT_HIRE =		13,
	UNIT_SHOP =		14,
	
	SKILL_AUTO =		15,
	SKILL_IMMEDIATE =	16,
	SKILL_TO_GRID =		17,
	SKILL_TO_UNIT =		18,
	SKILL_TO_UNIT_WITH_MOVE = 19,
	
	MOVE_TO_GRID =		20,
	FACE_TO_GRID =		21,
	
	TEAM_SHIFT =		22,
	
	PLACE_TO =		23,
	DAMAGE_TO_UNIT =	24,
	SPLASH_DAMAGE_TO_UNIT = 25,
	
	PLAYER_ROUND_READY =	26,
	PLAYER_SKIP_UNIT_OPERATE = 27,
	UNIT_WAIT = 28,			--这是战场里面才会有的命令啊
	PLAYER_SURRENDER =	29,
	
	HERO_REVIVE =		30,
	UNIT_UPGRADE =		31,
	
	UNIT_TELEPORT =		32,
	
	SET_GUARD =		33,
	SET_VISITOR =		34,
	
	HERO_GETITEM =		35,
	HERO_DROPITEM =		36,
	HERO_SORTITEM =		37,
	HERO_SETEQUIPMENT =	38,
	HERO_REMOVEEQUIPMENT =	39,
	
	AURA_TO_UNIT =		40,
	
	OPEN_GATE =		41,
	CLOSE_GATE =		42,
	
	ARMY_UPGRADE =		43,
	ARMY_PART =		44,
	HERO_USEITEM =		45,	--使用物品
	HERO_LEAVETOWN =	46,	--守卫英雄离开城镇
	HERO_SETATTR =		47,	--设置英雄属性
	HERO_DECOMPOSEITEM =	48,	--分解道具
	HERO_FORGEITEM =	49,	--锻造道具
	HERO_RECASTITEM =	50,	--重铸道具
	PLAYER_SETSKILLBOOK =	51,	--设置玩家的战术技能书
	PLAYER_DELETEBFSKILLCARD = 52,	--删除战术技能卡片
	
	UNIT_DEFENSE = 53,		--我的领地在用 防守建筑
	UNIT_WDLD_ATK_BUILDING = 54,	--我的领地在用 进攻有守卫的建筑
	UNIT_WDLD_GUARD_OUT = 55,	--我的领地在用 取消守卫
	
	AI_UNIT_ATTACK = 56,		--AI对目标发动攻击，无视目标是否隐藏
}
--在世界地图上发出的命令,若在此处注册过，则此命令发出时附带移动效果
hVar.WORLD_OPERATE_WITH_MOVE = {}
local __WORLD_OPERATE_WITH_MOVE = {
	NONE = 1,
	UNIT_MOVE = 1,
	UNIT_MOVE_TO_UNIT = 1,
	UNIT_LOOT = 1,
	UNIT_ATTACK = 1,
	UNIT_ENTER = 1,
	UNIT_OCCUPY = 1,
	UNIT_HIRE = 1,
	UNIT_SHOP = 1,
	UNIT_CAPTURE = 1,
	UNIT_VISIT = 1,
	UNIT_JOIN = 1,
	UNIT_MARKET = 1,
	UNIT_DEFENSE = 1,		--我的领地在用 防守建筑
	UNIT_WDLD_ATK_BUILDING = 1,	--我的领地在用 进攻有守卫的建筑
	--UNIT_WDLD_GUARD_OUT = 1,	--我的领地在用 取消守卫
	--UNIT_REST = 1,
	UNIT_TALK = 1,
	UNIT_TELEPORT = 1,
	HERO_GETITEM = 1,
	HERO_REVIVE = 1,
	AI_UNIT_ATTACK = 1,
}
for k,v in pairs(__WORLD_OPERATE_WITH_MOVE)do
	hVar.WORLD_OPERATE_WITH_MOVE[hVar.OPERATE_TYPE[k]] = 1
end
hVar.CAST_TYPE = {
	NONE = 0,
	MOVE = 1,
	IMMEDIATE = 2, --对自己生效（立即生效）
	SKILL_TO_GRID = 3,
	SKILL_TO_UNIT = 4, --对单位生效
	BUFF_TO_GRID = 5,
	BUFF_TO_UNIT = 6,
	SKILL_TO_GROUND = 7, --geyachao: TD对地面
	SKILL_TO_GROUND_BLOCK = 8, --geyachao: TD对地面有效的非障碍点地方
	AUTO = 9,		--进入战场时会自动作用在自己身上一次
	SKILL_TO_GROUND_MOVE_TO_POINT = 10, --geyachao: TD移动到技能范围后，再对地面生效
	SKILL_TO_GROUND_MOVE_TO_POINT_BLOCK = 11, --geyachao: TD移动到技能范围后，再对有效地面非障碍点生效
	SKILL_TO_UNIT_IMMEDIATE = 12, --对周围随机单位生效（需要自身周围存在目标才会释放成功）
	SKILL_TO_UNIT_MOVE_TO_POINT = 13, --移动到技能范围后，再对施法点周围随机单位生效（需要施法点周围存在目标才会释放成功）
	SKILL_TO_GROUND_BLOCK_ENERGY = 14, --TD对地面有效的非障碍点地方，靠近能量圈附近
}

--geyachao: 单位的空间位置类型
hVar.UNIT_SPACE_TYPE =
{
	SPACE_GROUND = 0, --地面单位
	SPACE_FLY = 1, --空中单位
}

--geyachao: 单位的可攻击目标所属于的空间位置的类型
hVar.UNIT_ATTACK_SPACE_TYPE =
{
	ATTACK_SPACE_GROUND = 0, --可攻击地面单位
	ATTACK_SPACE_ALL = 1, --可攻击地面单位和空中单位
	ATTACK_SPACE_FLY = 2, --可攻击空中单位
}

--geyachao: 长按时间设定值(单位:毫秒)
hVar.LONG_TOUCH_TIME = 1500

hVar.EXCHANGE_CANGBAOTU_NORMAL_NUM = 50 --藏宝图兑换比例
hVar.EXCHANGE_CANGBAOTU_HIGH_NUM = 100 --高级藏宝图兑换比例

--geyachao: 选人界面，一共可以选多少个卡片和需要的星星
hVar.SELECT_CARD_MAX_NUM = 9
hVar.SELECT_CARD_REQUIRE_STARS = {0, 0, 0, 0, 10, 20, 50, 100, 200}

--geyachao: 击杀敌人得钱，有一定几率暴钱
hVar.UNIT_KILLGOLD_CRIT_RATE = 10 --几率（去掉百分号后的值） 
hVar.UNIT_KILLGOLD_CRIT_VALUE = 2 --暴倍数
hVar.UNIT_KILLGOLD_GOLD_MIN = 5 --爆钱的最小获得的钱

--geyachao:每次打金钱怪，得的钱（通关第三关后才会出现）
hVar.GOLDUNIT_PROBALITY = 10 --几率
hVar.GOLDUNIT_ATK_ADDGOLD = 1

--geyachao: 寻路多走一段距离（防止一直追着屁股后面跑，就是砍不下去）
hVar.MOVE_EXTRA_DISTANCE = 24

--geyachao: 角色搜敌最大数量限制
hVar.ROLE_SEARCH_MAX = 50

--geyachao: 角色路点的最大数量
hVar.ROLE_ROAD_POINT_MAX_NUM = 20

--geyachao: 角色复活相关的参数配置
hVar.ROLE_REBIRTH_MAX_TIME = 90000 --复活最大时间（单位：毫秒）
hVar.ROLE_REBIRTH_MIN_TIME = 1000 --复活最小时间（单位：毫秒）
hVar.ROLE_REBIRTH_DEATH_TIME = 0 --每死亡一次，复活额外增加的时间（单位：毫秒）

--geyachao: 角色物防的上下限
hVar.ROLE_DEF_PHYSIC_MIN = -500
hVar.ROLE_DEF_PHYSIC_MAX = 500

--geyachao: 角色法防的上下限
hVar.ROLE_DEF_MAGIC_MIN = -500
hVar.ROLE_DEF_MAGIC_MAX = 500

--geyachao: 角色冰防的上下限
hVar.ROLE_DEF_ICE_MIN = -500
hVar.ROLE_DEF_ICE_MAX = 500

--geyachao: 角色雷防的上下限
hVar.ROLE_DEF_THUNDER_MIN = -500
hVar.ROLE_DEF_THUNDER_MAX = 500

--geyachao: 角色火防的上下限
hVar.ROLE_DEF_FIRE_MIN = -500
hVar.ROLE_DEF_FIRE_MAX = 500

--geyachao: 角色毒防的上下限
hVar.ROLE_DEF_POISON_MIN = -500
hVar.ROLE_DEF_POISON_MAX = 500

--geyachao: 角色子弹防的上下限
hVar.ROLE_DEF_BULLET_MIN = -500
hVar.ROLE_DEF_BULLET_MAX = 500

--geyachao: 角色爆炸防的上下限
hVar.ROLE_DEF_BOMB_MIN = -500
hVar.ROLE_DEF_BOMB_MAX = 500

--geyachao: 角色穿刺防的上下限
hVar.ROLE_DEF_CHUANCI_MIN = -500
hVar.ROLE_DEF_CHUANCI_MAX = 500

--geyachao: 角色攻速叠加的上下限
hVar.ROLE_ATK_SPEED_MIN = 10 --攻击速度（去百分号后的值）最小只能减为10％
hVar.ROLE_ATK_SPEED_MAX = 500 --攻击速度（去百分号后的值）最大只能加为500％

--geyachao: 角色闪避几率的上限
hVar.ROLE_DODGE_RATE_MAX = 95 --闪避几率（去百分号后的值）最大只能加为95％

--geyachao: 角色暴击倍数值的上限
hVar.ROLE_CRIT_VALUE_MAX = 8.0 --暴击倍数值（支持小数）最大只能为8.0

--geyachao: 角色技能减CD百分比值的下限
hVar.ROLE_CD_REDUICE_RATE_MAX = -50

--geyachao: 角色手雷的下限（毫秒）
hVar.ROLE_CD_GERENADER_RATE_MAX = 600

--geyachao: 角色移动速度的下限
hVar.ROLE_MOVE_SPEED_MAX = 800
hVar.ROLE_MOVE_SPEED_MIN = 3

--geyachao: 角色战车双雷最大数量
hVar.ROLE_GRENADE_MULTIPLY_MAX = 2


--geyachao: 检测野怪自动沉睡的时间（毫秒）
hVar.ROLE_AUTO_SLEEP_TIME = 6000

--geyachao: 每日领取竞技场兵符的上限
hVar.PVP_COIN_MAX_NUM = 100

hVar.AREA_EDGE = 96 --区域边长（用于搜敌优化）
--hVar.TICK_TIME = 16 --每个tick的时间间隔
--hVar.CLIENT_FPS = 60 --客户端60帧
hVar.TURN_TRACE_DELTA_NET = 4 --联机版本，客户端turn与服务器turn相差大于等于此值，就追帧
hVar.TURN_TRACE_OK_NET = 1 --联机版本，客户端turn与服务器turn相差等于此值，就停止追帧

--geyachao: 当前是否正在引导中
hVar.IS_IN_GUIDE_STATE = 0

--geyachao: 是否显示同步日志
hVar.IS_SYNC_LOG = 0 --大菠萝，不显示同步日志

--geyachao: 是否显示非同步日志（本地查不同步用的）
hVar.IS_ASYNC_LOG = 0

--geyachao: 是否显示客户端网络状态界面（本地显示等待服务器响应、追帧中，等等冒泡文字）
hVar.IS_CLIENT_NET_UI = 0

--geyachao: 战车是否显示命中特效
--hVar.IS_SHOW_HIT_EFFECT_FLAG = 1
hVar.IS_SHOW_HIT_EFFECT_FLAG = 1

hVar.TRAP_GROUND_CASTCD = 15000		--陷阱默认施法间隔（单位：毫秒）
hVar.TRAP_GROUND_TRAPTIME = 2000	--陷阱默认困敌时间（单位：毫秒）
hVar.TRAP_FLY_CASTCD = 15000		--天网默认施法间隔（单位：毫秒）
hVar.TRAP_FLY_TRAPTIME = 2000		--天网默认困敌时间（单位：毫秒）
hVar.PUZZLE_CDTIME = 2000		--迷惑默认冷却时间（单位：毫秒）

--geyachao: 单位的标记
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
		TAG_SPECIAL	=	"TAG_SPECIAL"	,	--特殊塔系
		
		TAG_DUTA	=	"TAG_DUTA"		,	--毒塔
		TAG_LIANNUTA	=	"TAG_LIANNUTA"		,	--连弩塔
		TAG_JUJITA	=	"TAG_JUJITA"		,	--狙击塔
		
		TAG_HUOTA	=	"TAG_HUOTA"		,	--火塔
		TAG_BINGTA	=	"TAG_BINGTA"		,	--冰塔
		TAG_SHANDIANTA	=	"TAG_SHANDIANTA"	,	--闪电塔
		
		TAG_JUPAOTA	=	"TAG_JUPAOTA"		,	--巨炮塔
		TAG_HONGTIANTA	=	"TAG_HONGTIANTA"		,	--轰天塔
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
		TAG_GOLDUNIT = "TAG_GOLDUNIT",			--金钱单位
		TAG_RIDER = "TAG_RIDER",				--骑兵单位
		TAG_BOAT = "TAG_BOAT",					--船
		TAG_ELITE = "TAG_ELITE",				--精英怪
	},
}

--geyachao: 要处理的河的模型名标记（不能点击）
hVar.UNIT_RIVER_MODEL =
{
	"river28",
}

--怪物品质价值
hVar.UNIT_QUALITY_VALUE = 
{
	[hVar.UNIT_TAG_TYPE.OTHER.TAG_NORMAL] = 1,		--普通怪
	[hVar.UNIT_TAG_TYPE.OTHER.TAG_ELITE] = 3,		--精英怪
	[hVar.UNIT_TAG_TYPE.OTHER.TAG_BOSS] = 6,		--关底BOSS
}

--战车随机地图房间类型
hVar.RANDMAP_ROOMTYPE =
{
	ROOM_NORMAL_SMALL = 1,		--普通房间（小）
	ROOM_NORMAL_BIG = 2,		--普通房间（大）
	ROOM_BOSS = 3,			--BOSS大房间
	ROOM_BOSS_TERNIMAL = 4,		--终极BOSS大房间
	ROOM_ROAD_W = 5,		--通路（长条形）
	ROOM_ROAD_H = 6,		--通路（竖条形）
	ROOM_ROAD_TERMINAL = 7,		--断头路
}


hVar.RANDMAP_ROOM_NORMAL_BIG_EDGE = 0 --随机地大房间的尺寸

hVar.RANDMAP_ENEMY_TRANSPORT_ID = 5141 --战车传送点单位id
hVar.RANDMAP_ENEMY_TRANSPORT_ID_TERMINAL = 11045 --5196 --战车传送点单位id（最后一关）
hVar.RANDMAP_ENEMY_TRANSPORT_BACK_ID = 5188 --战车传送点返回单位id

hVar.RANDMAP_ENEMY_JIANTOU_LEFT = 5204 --战车箭头（左）单位id
hVar.RANDMAP_ENEMY_JIANTOU_RIGHT = 5205 --战车箭头（右）单位id
hVar.RANDMAP_ENEMY_JIANTOU_UP = 5206 --战车箭头（上）单位id
hVar.RANDMAP_ENEMY_JIANTOU_DOWN = 5207 --战车箭头（下）单位id
hVar.RANDMAP_ENEMY_JIANTOU_EFFECT = 3006 --战车箭头光照特效单位id

hVar.RANDMAP_ENEMY_JIANTOU_EXIT = 5195 --战车箭头（下）（出口）单位id
hVar.RANDMAP_ENEMY_JIANTOU_EXIT_EFFECT = 3001 --战车箭头（出口）光照特效单位id

hVar.RANDMAP_ENEMY_BOSS_KILL_ADDUNIT_GROUPID = 4--5171 --击杀boss后添加的组
hVar.RANDMAP_ENEMY_BIGBOSS_KILL_ADDUNIT_GROUPID = 7 --5197 --击杀大boss后添加的组

--战车随机地图小兵路点类型
hVar.RANDMAP_ROADPOINT_TYPE =
{
	NONE = 0,			--无
	HORIZONTAL = 1,			--横向走
	VERTICAL = 2,			--竖向走
	SKEW_LEFT = 3,			--左斜走
	SKEW_RIGHT = 4,			--右斜走
	CIRCLE_CLOCKWISE = 5,		--圆型走（顺时针）
	CIRCLE_ANTI_CLOCKWISE = 6,	--圆型走（逆时针）
	RANDOM = 7,			--随机走
}



--=============================================================
-- 资源类型
--=============================================================
hVar.RESOURCE_TYPE = {
	NONE = 0,		--没有
	LIFE = 1,		--生命
	WOOD = 2,		--木头
	FOOD = 3,		--食物
	GOLD = 4,		--黄金
	STONE = 5,		--石头
	CRYSTAL = 6,		--水晶
	EXP = 7,		--经验值
}
hVar.RESOURCE_NAME = {
	NONE = "NONE",		--没有
	IRON = "铁",		--铁
	WOOD = "木头",		--木头
	FOOD = "食物",		--食物
	GOLD = "黄金",		--黄金
	STONE = "石头",		--石头
	CRYSTAL = "水晶",	--水晶
}
hVar.ATTR_NAME = {
	NONE = "NONE",		--没有
	HP = "体力",		--体力
	MP = "魔法",		--魔法
	exp = "经验",		--经验
}

hVar.RESOURCE_KEY_DEFINE = {
	[hVar.RESOURCE_TYPE.NONE] = "NONE",
	[hVar.RESOURCE_TYPE.LIFE] = "LIFE",
	[hVar.RESOURCE_TYPE.WOOD] = "WOOD",
	[hVar.RESOURCE_TYPE.FOOD] = "FOOD",
	[hVar.RESOURCE_TYPE.GOLD] = "GOLD",
	[hVar.RESOURCE_TYPE.STONE] = "STONE",
	[hVar.RESOURCE_TYPE.CRYSTAL] = "CRYSTAL",
}

hVar.RESOURCE_VALUE = {
	DISCOUNT = -400,		--兑换折扣（-400%）
	[hVar.RESOURCE_TYPE.NONE] = 1,
	[hVar.RESOURCE_TYPE.LIFE] = 250,
	[hVar.RESOURCE_TYPE.WOOD] = 25,
	[hVar.RESOURCE_TYPE.FOOD] = 5,
	[hVar.RESOURCE_TYPE.GOLD] = 1,
	[hVar.RESOURCE_TYPE.STONE] = 25,
	[hVar.RESOURCE_TYPE.CRYSTAL] = 1250,
}

hVar.RESOURCE_CHANGE_VALUE = {
	{0,25,250,250,1250,5000},
	{1,0,50,50,250,1250},
	{0.1,0.5,0,5,25,125},
	{0.1,0.5,5,0,25,125},
	{0.02,0.1,1,1,0,25},
	{1,1,1,1,1,1,0},
}

hVar.RESOURCE_ART = {
	[hVar.RESOURCE_TYPE.NONE] = {icon = nil,font = "numWhite"},
	[hVar.RESOURCE_TYPE.LIFE] = {icon = "UI:ICON_main_frm_ResourceIron",font = "numRed"},
	[hVar.RESOURCE_TYPE.WOOD] = {icon = "UI:ICON_main_frm_ResourceWood",font = "numGreen"},
	[hVar.RESOURCE_TYPE.FOOD] = {icon = "UI:ICON_main_frm_ResourceFood",font = "numBlue"},
	[hVar.RESOURCE_TYPE.GOLD] = {icon = "UI:ICON_main_frm_ResourceGold",font = "num"},
	[hVar.RESOURCE_TYPE.STONE] = {icon = "UI:ICON_main_frm_ResourceStone",font = "num"},
	[hVar.RESOURCE_TYPE.CRYSTAL] = {icon = "UI:ICON_main_frm_ResourceJewel",font = "numWhite"},
}
hVar.RESOURCE_GET_TYPE = {
	NONE = 0,
	LOOT = 1,
}
--=============================================================
-- Timer定义
--=============================================================
hVar.TIMER_MODE = {
	PCTIME = 0,
	GAMETIME = 1,
}
hVar.TIMER_LOOP_MODE = {
	DISABLE = 0,
	DEBUG = 1,		--此类型timer一旦出错就会停止运行
	RELEASE = 2,		--此类型timer会不断循环执行
}
--=============================================================
-- 单位定义
--=============================================================
hVar.UNIT_TYPE = {
	UNIT = 1,				--普通单位、小兵
	HERO = 2,				--英雄
	BUILDING = 3,			--建筑（可以点击）
	SCEOBJ = 4,				--场景物件
	RESOURCE = 5,
	ITEM = 6,
	NPC = 7,				--TD地图的装饰物
	GROUP = 8,
	AREA = 9,
	PLAYER_INFO = 10,		--玩家信息
	WAY_POINT = 11,			--路点、集合点
	NOT_USED = 12,			--区域范围
	TOWER = 13,				--TD的塔（可以点击）
	NPC_TALK = 14,			--TD地图可以交互的装饰物（可以点击）
	HERO_TOKEN = 15,		--英雄替代物(图腾)
	UNITBOX = 16,			--箱子单位
	UNITCAN = 17,			--汽油桶单位
	UNITGUN = 18,			--武器单位
	UNITBROKEN = 19,		--可破坏物件单位
	UNITBROKEN_HOUSE = 20,		--可破坏房子单位
	UNITDOOR = 21,			--可破坏门单位
	UNITWALL = 22,			--矮墙
}

hVar.UNIT_ROUND_STATE = {
	NONE = 0,
	ROUND_START = 1,	--每轮新开始
	AFTER_MOVE = 2,		--移动后进入此状态
	ROUND_END = 3,		--单位完成了所有行为
}
hVar.UNIT_ARRIVE_MODE = {
	NOT_MOVE = 0,
	NORMAL = 1,
	DEAD = 2,
	BIRTH = 3,
	STOP = 4,
}
hVar.UNIT_PRICE_DEFINE = {
	--编辑器里面填写的单位价格是按照这个顺序写进去的
	--{num,num,num,num,num,num}
	[1] = hVar.RESOURCE_TYPE.GOLD,		--黄金
	[2] = hVar.RESOURCE_TYPE.FOOD,		--食物
	[3] = hVar.RESOURCE_TYPE.STONE,		--石头
	[4] = hVar.RESOURCE_TYPE.WOOD,	--额外经验值
	[5] = hVar.RESOURCE_TYPE.LIFE,		--铁
	[6] = hVar.RESOURCE_TYPE.CRYSTAL,	--水晶
}

--TD角色AI状态
hVar.UNIT_AI_STATE =
{
	IDLE = 0,			--空闲状态
	MOVE = 1,			--移动状态
	MOVE_TANK_NEARBY = 2,		--移动到坦克附近状态
	MOVE_TANK = 3,			--移动到坦克状态
	MOVE_ADJUST = 4,		--移动调整状态（围殴嘲讽单位）
	MOVE_CHAOS = 5,			--移动混乱状态（单位无目的乱走）
	MOVE_HOSTAGE_TANK = 6,		--人质移动跟随坦克状态
	MOVE_HOSTAGE_ChAOS = 7,		--人质移动混乱状态（单位无目的乱走）
	ATTACK = 8,			--攻击状态
	FOLLOW = 9,			--跟随单位状态
	MOVE_TO_POINT = 10,		--移动到达目标点后释放战术技能
	MOVE_TO_POINT_CASTSKILL = 11,	--移动到达目标点后继续释放技能
	FOLLOW_TO_TARGET = 12,		--移动到达目标后释放战术技能
	SEARCH = 13,			--搜敌状态
	CAST = 14,			--施法状态
	CAST_STATIC = 15,		--施法后的僵直状态
	STUN = 16,			--眩晕状态
	MOVE_BY_TRACK = 17,		--滑行状态
	SLEEP = 18,			--沉睡状态
	REACHEND = 19,			--到达终点
}

--TD角色搜敌优先级类型
hVar.AI_PRIORITY =
{
	PRI_LOCKED_TARGET = 1,     --优先搜锁定的单位
	PRI_HERO = 2,              --优先搜英雄
	PRI_UNIT = 3,              --优先搜小兵
	PRI_HERO_UNIT = 4,         --优先搜英雄和小兵
	PRI_BUILDING = 5,          --优先搜建筑
	PRI_TOWER = 6,             --优先搜塔
	PRI_UNITBOX = 7,           --优先搜箱子
	PRI_UNITCAN = 8,           --优先搜汽油桶
	PRI_UNITGUN = 9,           --优先搜武器
	PRI_UNITBROKEN = 10,       --优先搜可破坏物件
	PRI_UNITBROKEN_HOUSE = 11, --优先搜可破坏房子单位
	PRI_NEAREST = 12,          --优先搜最近
	PRI_HIGH_HP = 13,          --优先搜血多
	PRI_LOW_HP = 14,           --优先搜血少
	PRI_HIGH_HP_RATE = 15,     --优先搜血比例多
	PRI_LOW_HP_RATE = 16,      --优先搜血比例少
	PRI_FAST_SPEED = 17,       --优先搜移动速度快
	PRI_SLOW_SPEED = 18,       --优先搜移动速度慢
	PRI_BUFF = 19,             --优先搜有某种tag的buff
	PRI_NOBUFF = 20,           --优先搜没某种tag的buff
	PRI_FLY_UNIT = 21,         --优先搜飞行单位
	PRI_GROUND_UNIT = 22,      --优先搜地面单位
	PRI_NO_BLOCK = 23,         --优先搜两者间无障碍的单位
	PRI_UNITDOOR = 24,		--优先搜可破坏门单位
}

--TD角色搜敌优先级字符串类型转化表
hVar.AI_PRIORITY_STRING_MAP =
{
	["PRI_LOCKED_TARGET"] = hVar.AI_PRIORITY.PRI_LOCKED_TARGET,
	["PRI_HERO"] = hVar.AI_PRIORITY.PRI_HERO,
	["PRI_UNIT"] = hVar.AI_PRIORITY.PRI_UNIT,
	["PRI_HERO_UNIT"] = hVar.AI_PRIORITY.PRI_HERO_UNIT,
	["PRI_BUILDING"] = hVar.AI_PRIORITY.PRI_BUILDING,
	["PRI_TOWER"] = hVar.AI_PRIORITY.PRI_TOWER,
	["PRI_UNITBOX"] = hVar.AI_PRIORITY.PRI_UNITBOX,
	["PRI_UNITCAN"] = hVar.AI_PRIORITY.PRI_UNITCAN,
	["PRI_UNITGUN"] = hVar.AI_PRIORITY.PRI_UNITGUN,
	["PRI_UNITBROKEN"] = hVar.AI_PRIORITY.PRI_UNITBROKEN,
	["PRI_UNITBROKEN_HOUSE"] = hVar.AI_PRIORITY.PRI_UNITBROKEN_HOUSE,
	["PRI_NEAREST"] = hVar.AI_PRIORITY.PRI_NEAREST,
	["PRI_HIGH_HP"] = hVar.AI_PRIORITY.PRI_HIGH_HP,
	["PRI_LOW_HP"] = hVar.AI_PRIORITY.PRI_LOW_HP,
	["PRI_HIGH_HP_RATE"] = hVar.AI_PRIORITY.PRI_HIGH_HP_RATE,
	["PRI_LOW_HP_RATE"] = hVar.AI_PRIORITY.PRI_LOW_HP_RATE,
	["PRI_FAST_SPEED"] = hVar.AI_PRIORITY.PRI_FAST_SPEED,
	["PRI_SLOW_SPEED"] = hVar.AI_PRIORITY.PRI_SLOW_SPEED,
	["PRI_BUFF"] = hVar.AI_PRIORITY.PRI_BUFF,
	["PRI_NOBUFF"] = hVar.AI_PRIORITY.PRI_NOBUFF,
	["PRI_FLY_UNIT"] = hVar.AI_PRIORITY.PRI_FLY_UNIT,
	["PRI_GROUND_UNIT"] = hVar.AI_PRIORITY.PRI_GROUND_UNIT,
	["PRI_NO_BLOCK"] = hVar.AI_PRIORITY.PRI_NO_BLOCK,
}

--TD角色默认的搜敌优先级表
hVar.AI_PRIORITY_DEFAULT =
{
	{hVar.AI_PRIORITY.PRI_LOCKED_TARGET,},
	{hVar.AI_PRIORITY.PRI_NEAREST,},
}

hVar.UNIT_TALK_DEFINE = {
	TALK = {head = "talk"},							--交谈
	SURRENDER = {head = "surrender"},					--投降
	DEFEAT = {head = "defeat"},						--被击败
	ATTACK = {head = "attack"},						--被攻击的谈话
}

hVar.UNIT_ATTACKMODE = {				--单位的攻击类型
	{23,"__Attr_ATTACKMODE_23"},
	{24,"__Attr_ATTACKMODE_24"},
	{28,"__Attr_ATTACKMODE_28"},
	{29,"__Attr_ATTACKMODE_29"},
	{30,"__Attr_ATTACKMODE_30"},
}

hVar.UNIT_EXP = {		--每个等级的怪物给予的经验值
	[0] = 1,
	[1] = 2,
	[2] = 4,
	[3] = 10,
	[4] = 20,
	[5] = 50,
	[6] = 75,
	[7] = 100,
}

---------------------------------
---设定经验上限
hVar.HeroMaxExp = 100		--英雄经验上限 目前公式是 math.min(hVar.HeroMaxExp,math.floor((6000+hpMax*0.1+atk*20)*0.001))
hVar.UnitMaxExp = 5		--单位经验上限 目前公式是 math.min(hVar.UnitMaxExp,math.floor((300+hpMax*0.1+atk*5)*0.001))
hVar.SettlementExp = 500	--每局结算获得经验上限为500
-------------------------------------------------

hVar.UNIT_COMBAT_SCORE = {	--每个等级的怪物强度数值(暂时就第一项有效)
	--    {基础强度,攻击力系数,血量系数,防御系数,技能系数}
	[0] = {1,	0.1,	0.02,	0.1,	0.25,},
	[1] = {2,	0.1,	0.02,	0.15,	0.5,},
	[2] = {4,	0.1,	0.02,	0.2,	1.0,},
	[3] = {10,	0.1,	0.02,	0.5,	2.5,},
	[4] = {20,	0.1,	0.02,	1.0,	5.0,},
	[5] = {50,	0.1,	0.02,	2.5,	12.0,},
	[6] = {75,	0.1,	0.02,	4.2,	18.0,},
	[7] = {100,	0.1,	0.02,	5.0,	25.0,},
}
------------怪物随时间增加数量
hVar.UNIT_AI_INCREASE_PER_DAY = {
	[0] = 0,
	[1] = 1.2,
	[2] = 0.8,
	[3] = 0.5,
	[4] = 0.3,
	[5] = 0.2,
	[6] = 0.1,
}

--=============================================================
-- 特效类型定义
--=============================================================
hVar.EFFECT_TYPE = {
	NONE = 0,
	NORMAL = 1,		--随坐标偏移
	OVERHEAD = 2,		--永远在头顶
	GROUND = 3,		--永远处在地面
	UNIT = 4,		--{_,bindKey,oUnit}
	MISSILE = 5,		--{_,oLaunchUnit,launchX,launchX,speed}
	ARROW = 6,		--{_,worldX,worldY,speed}
	SCEOBJ = 7,		--提前算好坐标 套用NORMAL
}
--=============================================================
-- 充值类型定义
--=============================================================
hVar.IAP_TYPE = {
	NONE = 0,
	IOS = 1,
	ALI = 2,
	DIY = 3,
	WEIXIN = 4, --微信支付
	MI  = 103,
	HW  = 104,
	JY  = 105,
	TX  = 106,
	OP  = 107,
	VV  = 108,
	LHH = 109,
	ZL  = 110,
	GG  = 112,
	YZYZ = 113,
	HYKB = 114,
	TXN  = 121, --新版应用宝
}
--=============================================================
-- 对齐定义
--=============================================================
hVar.UI_ALIGN = {
	["LT"] = {0	,2},
	["MT"] = {1	,2},
	["RT"] = {2	,2},
	["LC"] = {0	,1},
	["MC"] = {1	,1},
	["RC"] = {2	,1},
	["LB"] = {0	,0},
	["MB"] = {1	,0},
	["RB"] = {2	,0},
}
--=============================================================
-- timerbar类型定义
--=============================================================
hVar.UI_TIMERBAR_TYPE = {
	kCCProgressTimerTypeRadialCW = 0,		--顺时针生成Radial Counter-Clockwise
	kCCProgressTimerTypeBar = 1,			--从上到下生成
}
--=============================================================
-- 交互方式定义
--=============================================================
hVar.INTERACTION_TYPE = {
	DETAIL = 0,		--详细信息
	MOVETO = 1,		--移动到
	JOIN = 2,		--进攻
	ATTACK = 3,		--进攻
	ENTER = 4,		--进城
	OCCUPY = 5,		--占领城市
	LOOT = 6,		--获取宝箱
	SHOP = 7,		--商店
	HIRE = 8,		--雇佣
	TALK = 9,		--交谈
	VISIT = 10,		--访问
	MARKET = 11,		--市场
	UPGRADE = 12,		--升级
	LOOK = 13,		--查看(建筑)
	REVIVE = 14,		--复活英雄
	TELEPORT = 15,		--传送门
	PICK = 16,		--获取资源
	TECHNOLOGY = 17,	--升级科技
	ACADEMY = 18,		--翰林院学习技能
	PartArmy = 19,		--分兵按钮
	UpgradeArmy = 20,	--升级军队
	LEAVETOWN = 21,		--离开城镇
	DEFENSE = 22,		--驻守
	WDLD_ATK_BUILDING = 23,	--我的领地在用 进攻有守卫的建筑
	WDLD_GUARD_OUT = 24,	--我的领地在用 取消守卫
	
	PHONE_SELECTLEVEL = 25,	--手机版选择关卡,
	PHONE_OPENHEROCARD = 26,--手机版英雄卡片,
	PHONE_OPENGIFFRM = 27,	--手机版打开领奖界面,
	PHONE_OPENBFSFRM = 28,	--手机版打开战术技能卡,
	PHONE_OPENACHI = 29,	--手机版打开成就
	PHONE_VIP = 30,		--VIP
	PHONE_BACKBTN = 31,	--返回至主菜单按钮
	PHONE_PLAYERLIST = 32,	--玩家列表按钮
	PHONE_SELECTLEVEL_AMUSEMENT = 33,	--手机版娱乐地图选择关卡,
	PHONE_SHOP = 36,			--手机商店
	
	PHONE_GAME_NEWS =	34,		--手机版的游戏公告
	GAME_SETTING =		35,		--游戏设置
	GAME_PVP = 37,				--PVP
	GAME_GGZJ = 38,				--过关斩将
	RSDYZ_INFO_1 = 100,			--燃烧的远征信息
	RSDYZ_INFO_2 = 101,			--燃烧的远征信息
	RSDYZ_INFO_3 = 102,			--燃烧的远征信息
	
	TD_VIEW_TOWER_INFO = 996,		--td查看塔的介绍(天关塔诀界面)
	TD_SELL_TOWER = 997,			--td出售塔(避免出错只能用负的)			--zhenkira:新加
	TD_UPGRADE_SKILL = 998,			--td升级技能			--zhenkira:新加
	TD_REMOULD = 999,			--td改造塔			--zhenkira:新加

}

hVar.INTERACTION_ART = {
	[hVar.INTERACTION_TYPE.DETAIL] = {icon = "ICON:action_info"},		--详细信息
	[hVar.INTERACTION_TYPE.MOVETO] = {icon = "ICON:action_move"},		--移动到
	[hVar.INTERACTION_TYPE.JOIN] = {icon = "ICON:action_join"},		--加入
	[hVar.INTERACTION_TYPE.ATTACK] = {icon = "ICON:action_attack"},		--进攻
	[hVar.INTERACTION_TYPE.ENTER] = {icon = "ICON:action_enter"},		--进城
	[hVar.INTERACTION_TYPE.OCCUPY] = {icon = "ICON:action_occupy"},		--占领城池
	[hVar.INTERACTION_TYPE.LOOT] = {icon = "ICON:action_loot"},		--获取资源
	[hVar.INTERACTION_TYPE.PICK] = {icon = "ICON:PICK"},			--获取资源
	[hVar.INTERACTION_TYPE.SHOP] = {icon = "ICON:icon01_x1y12"},		--商店
	[hVar.INTERACTION_TYPE.HIRE] = {icon = "ICON:icon01_x6y1"},		--雇佣
	[hVar.INTERACTION_TYPE.TALK] = {icon = "ICON:action_talk"},		--交谈
	[hVar.INTERACTION_TYPE.VISIT] = {icon = "ICON:icon01_x1y1"},		--访问
	[hVar.INTERACTION_TYPE.MARKET] = {icon = "ICON:TRADE"},			--市场
	[hVar.INTERACTION_TYPE.UPGRADE] = {icon = "ICON:Hammer"},		--升级按钮
	[hVar.INTERACTION_TYPE.LOOK] = {icon = "ICON:action_look"},		--查看(建筑)
	[hVar.INTERACTION_TYPE.REVIVE] = {icon = "ICON:ReviveHero"},		--复活英雄
	[hVar.INTERACTION_TYPE.TELEPORT] = {icon = "ICON:icon01_x6y5"},		--传送门
	[hVar.INTERACTION_TYPE.TECHNOLOGY] = {icon = "ICON:TechnologyUpgrade"},	--升级科技
	[hVar.INTERACTION_TYPE.ACADEMY] = {icon = "ICON:Imperial_Academy"},	--翰林院
	[hVar.INTERACTION_TYPE.PartArmy] = {icon = "ICON:PartArmy"},		--分兵按钮
	[hVar.INTERACTION_TYPE.UpgradeArmy] = {icon = "ICON:UnitUpGrade"},	--升级军队按钮
	[hVar.INTERACTION_TYPE.LEAVETOWN] = {icon = "ICON:outtown"},		--离开城镇
	[hVar.INTERACTION_TYPE.DEFENSE] = {icon = "ICON:Defense"},		--驻守
	[hVar.INTERACTION_TYPE.WDLD_ATK_BUILDING] = {icon = "ICON:action_attack"},
	[hVar.INTERACTION_TYPE.WDLD_GUARD_OUT] = {icon = "ICON:outtown"},

	[hVar.INTERACTION_TYPE.PHONE_SELECTLEVEL] = {icon = "ICON:outtown"},		--选择关卡
	[hVar.INTERACTION_TYPE.PHONE_OPENHEROCARD] = {icon = "ICON:outtown"},		--英雄卡片
	[hVar.INTERACTION_TYPE.PHONE_OPENGIFFRM] = {icon = "ICON:outtown"},		--奖励
	[hVar.INTERACTION_TYPE.PHONE_OPENBFSFRM] = {icon = "ICON:outtown"},		--战术卡片
	[hVar.INTERACTION_TYPE.PHONE_OPENACHI] = {icon = "ICON:outtown"},		--成就
	[hVar.INTERACTION_TYPE.PHONE_VIP] = {icon = "ICON:outtown"},			--VIP
	[hVar.INTERACTION_TYPE.PHONE_BACKBTN] = {icon = "ICON:outtown"},		--返回至主菜单的按钮
	[hVar.INTERACTION_TYPE.PHONE_PLAYERLIST] = {icon = "ICON:outtown"},		--玩家列表
	[hVar.INTERACTION_TYPE.PHONE_SELECTLEVEL_AMUSEMENT] = {icon = "ICON:outtown"},	--娱乐地图选择关卡
	[hVar.INTERACTION_TYPE.PHONE_SHOP] = {icon = "ICON:outtown"},			--
	
	[hVar.INTERACTION_TYPE.PHONE_GAME_NEWS] = {icon = "ICON:outtown"},		--手机版的游戏公告
	
	[hVar.INTERACTION_TYPE.GAME_SETTING] = {icon = "ICON:outtown"},			--游戏设置
	[hVar.INTERACTION_TYPE.GAME_PVP] = {icon = "ICON:outtown"},			--PVP
	[hVar.INTERACTION_TYPE.GAME_GGZJ] = {icon = "ICON:outtown"},			--过关斩将
	
	[hVar.INTERACTION_TYPE.TD_VIEW_TOWER_INFO] = {icon = "ICON:action_info"},		--查看塔介绍(天关塔诀界面)
	[hVar.INTERACTION_TYPE.TD_SELL_TOWER] = {icon = "ICON:skill_icon1_x9y2"},		--售卖塔 拆塔
	
}

--=============================================================
-- 城镇科技树
--=============================================================
hVar.TOWN_TECHNOLOGY = {}
hVar.TOWN_TECHNOLOGY.NORMAL = {
	--科技树
	TREE = {
		{"TOWN_HALL_1",	"MILITARY_1",		"RANGE_1",		    0,		0,		"ACADEMY_1",	},
		{    "|",	    "|",		    "|",		"MARKET_1",	    "|-",	    "|",	},
		{    "|",	"MILITARY_2",		"RANGE_2",		"FACTORY_1",	"TEMPLE_1",	    "|",	},
		{"TOWN_HALL_2",	    0,			"STABLE_1",		    "#",	    "#",	    "|",	},
		{    "|",	    0,			    "|",		    "|",	    "|",	    "|",	},
		{    "|",	"MONASTERY_1",		"STABLE_2",		    "|",	"TEMPLE_2",	"ACADEMY_2",	},
		{    "|",	    0,			    "|",		    "|",	    0,		    "|",	},
		{"TOWN_HALL_3",	"ELITE_MILITARY_1",	"ELITE_STABLE_1",	"FACTORY_2",	"LEGEND_1",	"ACADEMY_3",	},
		{    0,		    0,			    "|",		0,		    "|",	    0,		},
		{    0,		"MONASTERY_1",		"ELITE_STABLE_2",	0,		"LEGEND_2",	    0,		},
	},
	--{名字,{需求1,需求2,{需求A或B或C},...},}
	--府邸
	TOWN_HALL = {
		{"TOWN_HALL_1",},
		{"TOWN_HALL_2",{
			{"MILITARY","RANGE","ACADEMY"},
		}},
		{"TOWN_HALL_3",{
			{"STABLE","FACTORY","TEMPLE"},
		}},
	},
	--兵营
	MILITARY = {
		{"MILITARY_1",},
		{"MILITARY_2",},
	},
	--靶场
	RANGE = {
		{"RANGE_1",},
		{"RANGE_2",},
	},
	--马厩
	STABLE = {
		{"STABLE_1",{
			"TOWN_HALL_2",
		}},
		{"STABLE_2",},
	},
	--精英兵营
	ELITE_MILITARY = {
		{"ELITE_MILITARY_1",{
			"TOWN_HALL_3",
		}},
		{"ELITE_MILITARY_2",},
	},
	--精英马厩
	ELITE_STABLE = {
		{"ELITE_STABLE_1",{
			"STABLE",
		}},
		{"ELITE_STABLE_2",{
			"TOWN_HALL_3",
		}},
	},
	--兵工坊
	FACTORY = {
		{"FACTORY_1",},
		{"FACTORY_2",{
			"TOWN_HALL_2",
		}},
	},
	--观星台
	TEMPLE = {
		{"TEMPLE_1","ACADEMY_1",},
		{"TEMPLE_2","TOWN_HALL_2",},
	},
	--翰林院
	ACADEMY = {
		{"ACADEMY_1",},
		{"ACADEMY_2",{
			"TOWN_HALL_2",
		}},
		{"ACADEMY_3",{
			"TOWN_HALL_3",
		}},
	},
	--寺庙
	MONASTERY = {
		{"MONASTERY_1"},
	},
	--市场
	MARKET = {
		{"MARKET_1"},
	},
	--城防
	SIEGE = {
		{"SIEGE_1"},
	},
	TOWER = {
		{"TOWER_1"},
	},
	
}
--=============================================================
-- 护甲类型(动画、音效、计算)
--=============================================================
hVar.ARMOR_TYPE = {
	ARMOR = 0,	--盔甲
	BODY = 1,	--皮毛
	WALL = 2,	--城墙
	ARMOR2 = 3,	--盔甲2
}

--=============================================================
-- 阵营（关系）
--=============================================================
hVar.PLAYER_ALLIENCE_TYPE = {
	NONE = 0,
	NEUTRAL = 1,
	OWNER = 2,
	ALLY = 3,
	ENEMY = 4,
	SUFFER = 5,
}
--=============================================================
-- 冷却类型
--=============================================================
hVar.COOLDOWN_TYPE = {
	NONE = 0,		--普通，等于单位独立
	UNIT = 1,		--单位自己
	PLAYER = 2,		--本玩家所有单位共享CD
	ALLY = 3,		--友军共享CD
	ALL = 4,		--全部玩家共享CD
}
--=============================================================
-- 碰撞类型
--=============================================================
hVar.UNIT_BLOCK = {
	[0] = 0,				--无碰撞
	[1] = 1,				--普通单位
	[2] = {{0,0},{1,0}},			--骑士
	[3] = {{0,0},{0,1},{0,-1}},		--城门
	[4] = {{0,1},{0,-1}},			--城门(被攻破的)
	[5] = {{0,0},{0,-1},{-1,-1}},		--门上面的城楼
	[6] = {{0,0},{0,1},{-1,1}},		--门下面的城楼
	[7] = {{0,0},{1,0}},			--门上面的城楼
	[8] = {{0,0},{1,0}},			--门下面的城楼
	[9] = {
		{-1,-4},{0,-4},{1,-4},{2,-4},{3,-4},
		{-2,-3},{-1,-3},{0,-3},{1,-3},{2,-3},{3,-3},
		{-1,-2},{0,-2},{1,-2},{2,-2},{3,-2},{4,-2},
		{-3,-1},{-2,-1},{-1,-1},{0,-1},{1,-1},{2,-1},{3,-1},
		{-2,0},{-1,0},{0,0},{1,0},{2,0},{3,0},
		{-3,1},{-2,1},{-1,1},{0,1},{1,1},{2,1},{3,1},
		{-2,2},{-1,2},{0,2},{1,2},{2,2},{3,2},{4,2},
		{-3,3},{-2,3},{-1,3},{0,3},{1,3},{2,3},{3,3},
		{-1,4},{0,4},{1,4},{2,4},{3,4},{4,4},
	},				--巨型战船
	[10] = {
			{2,6},
			{0,5},{1,5},
			{1,4},{2,4},
			{0,3},
			{0,2},{1,2},
			{-1,1},{0,1},
			{0,0},{1,0},
			{0,-1},
			{1,-2},{2,-2},
		},
	[11] = {
			{-3,-4},{-2,-4},{-1,-4},{-0,-4},{1,-4},{2,-4},{3,-4},{4,-4},{5,-4},{6,-4},{7,-4},
			{-4,-3},{-3,-3},{-2,-3},{-1,-3},{0,-3},{1,-3},{2,-3},{3,-3},{4,-3},{5,-3},{6,-3},{7,-3},
			{-4,-2},{-3,-2},{-2,-2},{-1,-2},{0,-2},{1,-2},{2,-2},{3,-2},{4,-2},{5,-2},{6,-2},{7,-2},
			{-4,-1},{-3,-1},{-2,-1},{-1,-1},{0,-1},{1,-1},{2,-1},{3,-1},{4,-1},{5,-1},{6,-1},{7,-1},
			{-4,0},{-3,0},{-2,0},{-1,0},{0,0},{1,0},{2,0},{3,0},{4,0},{5,0},{6,0},{7,0},
			{-4,1},{-3,1},{-2,1},{-1,1},{0,1},{1,1},{2,1},{3,1},{4,1},{5,1},{6,1},{7,1},
			{-4,2},{-3,2},{-2,2},{-1,2},{0,2},{1,2},{2,2},{3,2},{4,2},{5,2},{6,2},{7,2},
			{-4,3},{-3,3},{-2,3},{-1,3},{0,3},{1,3},{2,3},{3,3},{4,3},{5,3},{6,3},{7,3},
			{-2,4},{-1,4},{0,4},{1,4},{2,4},{3,4},{4,4},{5,4},{6,4},{7,4},
		},
	[12] = {
			{-3,-4},{-2,-4},{-1,-4},{-0,-4},{1,-4},{2,-4},{3,-4},{4,-4},{5,-4},{6,-4},{7,-4},
			{-2,-3},{-1,-3},{0,-3},{1,-3},{2,-3},{3,-3},{4,-3},{5,-3},{6,-3},{7,-3},
			{-3,-2},{-2,-2},{-1,-2},{0,-2},{1,-2},{2,-2},{3,-2},{4,-2},{5,-2},{6,-2},{7,-2},
			{-3,-1},{-2,-1},{-1,-1},{0,-1},{1,-1},{2,-1},{3,-1},{4,-1},{5,-1},{6,-1},{7,-1},
			{-4,0},{-3,0},{-2,0},{-1,0},{0,0},{1,0},{2,0},{3,0},{4,0},{5,0},{6,0},{7,0},
			{-4,1},{-3,1},{-2,1},{-1,1},{0,1},{1,1},{2,1},{3,1},{4,1},{5,1},{6,1},{7,1},
			{-4,2},{-3,2},{-2,2},{-1,2},{0,2},{1,2},{2,2},{3,2},{4,2},{5,2},{6,2},{7,2},
			{-4,3},{-3,3},{-2,3},{-1,3},{0,3},{1,3},{2,3},{3,3},{4,3},{5,3},{6,3},{7,3},
			{-3,4},{-2,4},{-1,4},{0,4},{1,4},{2,4},{3,4},{4,4},{5,4},{6,4},{7,4},
		},
	[13] = {
			{-1,-1},{0,-1},
			{-1,0},{0,0},
			{-1,1},{0,1},
			{-1,2},{0,2},
			{-1,3},{0,3},
			{-1,4},{0,4},
			{-1,5},{0,5},
			{0,6},

		},
}
hVar.UNIT_BLOCK_MODE = {
	NONE = 0,		--无碰撞单位
	NORMAL = 1,		--1格单位
	RIDER = 2,		--2格单位
	GATE = 3,		--门
	GATE_DEAD = 4,		--门(打开的)
	TOWER_UP = 5,		--门上面的城楼
	TOWER_DOWN = 6,		--门下面的城楼
	WALL_UP = 7,		--门上面的城墙（可攻破）
	WALL_DOWN = 8,		--门下面的城楼（可攻破）
	BIG_BATTLE_SHIP = 9,	--巨型战船
	BIG_BATTLE_SHIP_HEAD = 10,	--巨型战船头
	MON = 11,	--山怪整体障碍
	MON_1 = 12,	--山怪整体障碍 空出第一排
	MON_H = 13,	--山怪 可攻击最外圈 
}
hVar.STRING_TRIM_MODE = {
	SUCCEED = 0,
	SAME_NAME = 1, --"名字与已有存档同名"
	NAME_NULL = 2, --"您还没有输入名字"
	BLANK = 3, --"名字不能包含空格"
	TOOLONG = 4, --"名字最长支持15个英文或5个汉字"
	ILLEGAL_SIGN = 5, --"名字不能使用特殊字符"
	ILLEGAL_TEXT = 6, --"你输入的内容含有敏感词汇"
	ILLEGAL_BEGGING = 7, --"名字不能以数字和标点符号开头"
	SAME_NAME_HOST = 8, --"您输入的名字与已有玩家重名，请更换名字"
}
--=============================================================
-- 地图参数
--=============================================================
--不同地图通关的积分在这里填
--=============================================================
--积分修改必看（考虑因素：1：地图大小，2：BOSS数量，3：玩家首次通关时难度，4：地图可产出其他奖励数等等)
--修改时间2014-7-22--mazheng

hVar.MAP_SCORE = {
	--{积分百分比,基本分数,天数目标,{6星目标,5星目标,4星目标},富可敌国,闪电战,首次通关奖励积分,战斗力积分对应关系(分为几档,最低战斗力,最高战斗力,最低分数,最高分数)}
	["world/level_tyjy"] = {70,	8,	7,	{3,4,4},	3000,	5,	200,	{1,400,800,12,15}},
}




--不同难度的地图参数
hVar.MAP_VALUE_BY_DIFFICULTY = {
	["AI_Garrision"] =	{0.5,	0.7,	1,	1.6,	2,	2.0},		--电脑自动长兵速度
	["AI_Occupy"] =		{0.5,	0.7,	1,	1.6,	2,	2.5},		--电脑占领城市以后城里兵力比例
	["EnemyBorn"] =		{0.5,	0.7,	1,	1.6,	2,	2.5},		--电脑初始兵力
	["AllyBorn"] =		{1,	1,	1,	1,	1,	1},		--友军初始兵力
	["RandomNpc"] =		{0.8,	0.9,	1,	1.5,	2,	2.5},		--随机产生的电脑初始兵力(李宁7-24号说已废弃)
	["CreepGarrision"] =	{0.4,	0.5,	0.7,	0.9,	1,	1.6},		--野怪自动长兵速度
	["CreepBorn"] =		{0.7,	0.8,	1,	1.2,	1.3,	1.6},		--野怪初始兵力
	["RandomCreep"] =	{0.7,	0.8,	1,	1.2,	1.3,	1.6},		--随机野怪初始兵力
}

--不同难度下获得的积分将乘以此比例，最低1分
hVar.MAP_SCORE_BY_DIFFICULTY = {
	[1] = 40,
	[2] = 60,
	[3] = 90,
	[4] = 105,
	[5] = 115,
}

hVar.MAPS = {}
hVar.MAPS.DEFAULT = {
	name = "default_world",
	background = "",
	--{ox,oy,bgOffsetX,bgOffsetY}
	backgroundOrigin = {0,0,0,0},
	--{w,h,gridW,gridH,gridCenterX,gridCenterY}
	grid = {64,64,16,16,8,8},
	unit = {
		--{force,id,gridX,gridY,facing,triggerType,triggerArea,triggerParam}
	},
	scemodel = {},
	block = {},
	sceobj = {},	--{id,gridX,gridY,offsetX,offsetY,facing,scale,animation,isBlock}
}
hVar.MAPS.BATTLEFIELD = {
	name = "battlefield_default",
	background = "battlefield/battlefield_plain",		--现在这路径改成和程序那边一样的路径了
	--background = "map/battlefield/battlefield_plain.png",
	--{ox,oy,bgOffsetX,bgOffsetY}
	backgroundOrigin = {32,170,0,0},
	gridtype = "Ax6o",
	--{w,h,gridW,gridH,gridCenterX,gridCenterY}
	grid = {15,9,64,48,32,24},
	--{maskModel,gridMaskW,gridMaskH,gridMaskOffsetX,gridMaskOffsetY}
	gridmask = {"MODEL:grid",64,64,0,8},
	unit = {
		--{force,id,gridX,gridY,facing,triggerType,triggerArea,triggerParam}
	},
	position = {
		["SIEGE"] = {508,0},
	},
	scemodel = {
	},
	block = {
	},
	sceobj = {
		--{id,gridX,gridY,offsetX,offsetY,facing,scale,animation,isBlock}
	},
}
--战场阵型
hVar.BATTLEFIELD_DEPLOY_POS = {
	--[slot] = {gridX,gridY,facing}
	[0] = {
		[1] = {
			{0,0,0},
			{0,1,0},
			{0,2,0},
			{0,3,0},
			{0,4,0},
			{0,5,0},
			{0,6,0},
		},
		[2] = {
			{14,0,180},
			{13,1,180},
			{14,2,180},
			{13,3,180},
			{14,4,180},
			{13,5,180},
			{14,6,180},
		},
	},
	[1] = {
		[1] = {
			{0,0,0},
			{0,1,0},
			{0,3,0},
			{0,4,0},
			{0,5,0},
			{0,7,0},
			{0,8,0},
		},
		[2] = {
			{14,0,180},
			{13,1,180},
			{14,3,180},
			{13,4,180},
			{14,5,180},
			{13,7,180},
			{14,8,180},
		},
	},
}

--战场阵型
hVar.TD_DEPLOY_TYPE = {
	ONE_POINT_CENTER = 1,		--沿路点中心点一个一个出兵
	ONE_SAME_DISTANCE = 2,		--距离路点中心点相同距离比例（初始距离随机）
	ONE_RANDOM_DISTANCE = 3,	--距离路点中心点随机距离（初始距离随机）
	THREE_POINT_CENTER = 4,		--连续出3个兵，平均分布在路点中点及最大半径的两端点上。三个兵都走向下一个路点位置
	THREE_AVERAGE_CENTER = 5,	--连续出3个兵，平均分布在路点中点及最大半径的两端点上。直接走向下一个路点的对应的位置
	THREE_SAME_DISTANCE = 6,	--连续出3个兵，平均分布在路点中间及半径内随机距离的两端点上。直接走向下一个路点的对应的位置
	THREE_RANDOM_DISTANCE = 7,	--连续出3个兵，平均分布在路点中间及半径内随机距离的两端点上。到达下一个路点的随机间隔位置
}

--攻城地图1
--不同地图文件使用的城墙风格不一样
hVar.SIEGE_STYLE = {default="land"}	--城防类型
hVar.SIEGE_STYLE["battlefield/battlefield_plain_t"] = "land"
hVar.SIEGE_STYLE["battlefield/battlefield_water_t"] = "water"
hVar.SIEGE_STYLE["battlefield/battlefield_highland_t"] = "highland"
hVar.SIEGE_STYLE["battlefield/battlefield_depot_t"] = "depot"
hVar.SIEGE_GATE_UNIT = {
	--{team,id,gridX,gridY,facing}
	{2,5,10,0,180},
	{2,6,9,0,180},
	{2,7,9,2,180},

	{2,8,8,4,180},		--城门

	{2,9,9,6,180},
	{2,10,9,8,180},
	{2,11,10,8,180},
}

--战场世界类型
hVar.BF_WORLD_TYPE_EX = {
	NORMAL = 0,
	PVP = 1,
}

--战场地图背景
hVar.BATTLEFIELD_BG = {
	"battlefield/battlefield_shore",
	"battlefield/battlefield_plain5",
	"battlefield/battlefield_plain2",
	"battlefield/battlefield_plain3",
	"battlefield/battlefield_plain",
	"battlefield/battlefield_forest",
	"battlefield/battlefield_boss",
	"battlefield/battlefield_depot_t",
	"battlefield/battlefield_plain4",
	"battlefield/battlefield_water_c",
}
--战场随机障碍
--1无 2~6树+石头 7~9很多树 10石头堡垒 11~12若干石头
hVar.BATTLEFIELD_ENVIRONMENT = {
	["battlefield/battlefield_shore"] = {0},
	["battlefield/battlefield_plain"] = {0,0,0,0,0,2,3,4,6,11,12},
	["battlefield/battlefield_plain2"] = {0,0,3},
	["battlefield/battlefield_plain3"] = {0},
	["battlefield/battlefield_plain4"] = {0},
	["battlefield/battlefield_plain5"] = {0},
	["battlefield/battlefield_forest"] = {0,0,0,7,8,9,11,12},
	["battlefield/battlefield_boss"] = {0,0,3,4,5,6},
	["battlefield/battlefield_depot_t"] = {0,0,2,5,11,12},
	["battlefield/battlefield_water_c"] = {0},
}

---------------------------------zhenkira道具地图相关属性-----------------------------------
--td地图游戏状态机
hVar.MAP_TD_STATE = 
{
	IDLE = 0,				--空闲状态
	INIT = 1,				--初始化状态
	WAITING = 2,				--等待游戏开始状态
	BEGIN = 3,				--游戏局开始状态
	SENDARMY = 4,				--发兵中状态
	SENDARMYEND = 5,			--发兵结束状态
	PAUSE = 6,				--暂停状态
	SUCCESS = 7,				--游戏胜利
	FAILED = 8,				--游戏失败
	DRAW = 9,				--游戏平局(pvp中才有可能出现)
	END = 10,				--游戏结束状态
}

--geyachao: 游戏总星数
--hVar.MAX_STAR_NUM = 264

--td每波发兵状态
hVar.MAP_TD_WAVE_STATE = 
{
	BEGIN = 0,
	END = 1,
}

--td地图类型
hVar.MAP_TD_TYPE = 
{
	NORMAL = 0,				--普通模式
	DIFFICULT = 1,			--挑战难度模式
	PVP = 2,				--在线数据pk模式
	ENDLESS = 3,			--无尽模式
	NEWGUIDE = 4,			--新手引导地图模式
	TANKCONFIG = 5,			--配置坦克底图模式
}

--装备道具相关常量定义
hVar.ITEM_EQUIPMENT_POS = {
	--[hVar.ITEM_TYPE.HEAD] = 1,
	[hVar.ITEM_TYPE.BODY] = 1,
	[hVar.ITEM_TYPE.WEAPON] = 1,
	[hVar.ITEM_TYPE.ORNAMENTS] = 1,
	[hVar.ITEM_TYPE.MOUNT] = 1,
	--[hVar.ITEM_TYPE.FOOT] = 1,
}


--道具品质
hVar.ITEM_QUALITY = {
	UNKNOWN = 0,					--未知（仅供界面展示孔数）
	WHITE = 1,					--白色
	BLUE = 2,					--蓝色
	GOLD = 3,					--金色
	RED = 4,					--红色
	ORANGE = 5,					--橙色
	
	MAX = 5,					--最高品质
}
local __I_Q = hVar.ITEM_QUALITY



--[[
hVar.ITEM_QUALITY_BG = {
	[0] = "misc/chariotconfig/equipbg_white.png",
	[1] = "misc/chariotconfig/equipbg_white.png",
	[2] = "misc/chariotconfig/equipbg_white.png",
	[3] = "misc/chariotconfig/equipbg_blue.png",
	[4] = "misc/chariotconfig/equipbg_blue.png",
	[5] = "misc/chariotconfig/equipbg_yellow.png",
	[6] = "misc/chariotconfig/equipbg_yellow.png",
	[7] = "misc/chariotconfig/equipbg_orange.png",
	[8] = "misc/chariotconfig/equipbg_orange.png",
	[9] = "misc/chariotconfig/equipbg_red.png",
	[10] = "misc/chariotconfig/equipbg_red.png",
}
]]

--道具扩展属性上限
hVar.ITEM_ATTR_EX_LIMIT = {
	[__I_Q.WHITE] = 1,				--白色品质扩展属性条目上限
	[__I_Q.BLUE] = 1,				--蓝色品质扩展属性条目上限
	[__I_Q.GOLD] = 3,				--黄色品质扩展属性条目上限
	[__I_Q.RED] = 3,				--红色品质扩展属性条目上限
	[__I_Q.ORANGE] = 4,				--橙色品质扩展属性条目上限
}

--道具扩展属性价值
hVar.ITEM_ATTR_EX_VALUE = {
	[__I_Q.WHITE] = 1,				--白色品质扩展属性价值
	[__I_Q.BLUE] = 2,				--蓝色品质扩展属性价值
	[__I_Q.GOLD] = 3,				--黄色品质扩展属性价值
	[__I_Q.RED] = 4,				--红色品质扩展属性价值
	[__I_Q.ORANGE] = 5,				--橙色品质扩展属性价值
}

--道具不同品质是否可以出售
hVar.ITEM_ENABLE_SELL = {
	[__I_Q.WHITE] = true,				--白色品质是否可以出售
	[__I_Q.BLUE] = true,				--蓝色品质是否可以出售
	[__I_Q.GOLD] = true,				--黄色品质是否可以出售
	[__I_Q.RED] = false,				--红色品质是否可以出售
	[__I_Q.ORANGE] = false,				--橙色品质是否可以出售
}

--道具孔的属性定义
hVar.ITEM_ATTR_DEF = {
	UNKNWON = "unknwon",			--未知
	
	ATK1 = "atk1",					--攻击 1
	ATK2 = "atk2",					--攻击 2
	ATK3 = "atk3",					--攻击 3
	ATK4 = "atk4",					--攻击 4
	ATK5 = "atk5",					--攻击 5
	
	ATK_BULLET1 = "atk_bullet1",			--武器攻击 1
	ATK_BULLET2 = "atk_bullet2",			--武器攻击 2
	ATK_BULLET3 = "atk_bullet3",			--武器攻击 3
	ATK_BULLET4 = "atk_bullet4",			--武器攻击 4
	ATK_BULLET5 = "atk_bullet5",			--武器攻击 5
	
	HP1 = "hp1",					--血量 1
	HP2 = "hp2",					--血量 2
	HP3 = "hp3",					--血量 3
	HP4 = "hp4",					--血量 4
	HP5 = "hp5",					--血量 5
	
	DP1 = "dp1",					--物理防御 1
	DP2 = "dp2",					--物理防御 2
	DP3 = "dp3",					--物理防御 3
	DP4 = "dp4",					--物理防御 4
	DP5 = "dp5",					--物理防御 5
	
	DM1 = "dm1",					--法术防御 1
	DM2 = "dm2",					--法术防御 2
	DM3 = "dm3",					--法术防御 3
	DM4 = "dm4",					--法术防御 4
	DM5 = "dm5",					--法术防御 5
	
	DR1 = "dr1",					--物理闪避 1
	DR2 = "dr2",					--物理闪避 2
	DR3 = "dr3",					--物理闪避 3
	DR4 = "dr4",					--物理闪避 4
	DR5 = "dr5",					--物理闪避 5
	
	HR1 = "hr1",					--命中几率 1
	HR2 = "hr2",					--命中几率 2
	HR3 = "hr3",					--命中几率 3
	HR4 = "hr4",					--命中几率 4
	HR5 = "hr5",					--命中几率 5
	
	CR1 = "cr1",					--暴击几率 1
	CR2 = "cr2",					--暴击几率 2
	CR3 = "cr3",					--暴击几率 3
	CR4 = "cr4",					--暴击几率 4
	CR5 = "cr5",					--暴击几率 5
	
	CV1 = "cv1",					--暴击倍率 1
	CV2 = "cv2",					--暴击倍率 2
	CV3 = "cv3",					--暴击倍率 3
	CV4 = "cv4",					--暴击倍率 4
	CV5 = "cv5",					--暴击倍率 5
	
	HPR3 = "hpr3",					--回血 3
	HPR4 = "hpr4",					--回血 4
	HPR5 = "hpr5",					--回血 5
	
	RT3 = "rt3",					--复活时间 3
	RT4 = "rt4",					--复活时间 4
	RT5 = "rt5",					--复活时间 5
	
	AS1 = "as1",					--攻击速度 1
	AS2 = "as2",					--攻击速度 2
	AS3 = "as3",					--攻击速度 3
	AS4 = "as4",					--攻击速度 4
	AS5 = "as5",					--攻击速度 5
	
	PCD1 = "pcd1",					--被动技能CD 1
	PCD2 = "pcd2",					--被动技能CD 2
	PCD3 = "pcd3",					--被动技能CD 3
	PCD4 = "pcd4",					--被动技能CD 4
	PCD5 = "pcd5",					--被动技能CD 5
	
	LS4 = "ls4",					--吸血4
	LS5 = "ls5",					--吸血5
	
	
	THUNDER_DEF1 = "thunder_def1",			--雷防御1
	THUNDER_DEF2 = "thunder_def2",			--雷防御2
	THUNDER_DEF3 = "thunder_def3",			--雷防御3
	THUNDER_DEF4 = "thunder_def4",			--雷防御4
	THUNDER_DEF5 = "thunder_def5",			--雷防御5
	
	FIRE_DEF1 = "fire_def1",			--火防御1
	FIRE_DEF2 = "fire_def2",			--火防御2
	FIRE_DEF3 = "fire_def3",			--火防御3
	FIRE_DEF4 = "fire_def4",			--火防御4
	FIRE_DEF5 = "fire_def5",			--火防御5
	
	POISON_DEF1 = "poison_def1",			--毒防御1
	POISON_DEF2 = "poison_def2",			--毒防御2
	POISON_DEF3 = "poison_def3",			--毒防御3
	POISON_DEF4 = "poison_def4",			--毒防御4
	POISON_DEF5 = "poison_def5",			--毒防御5
	
	CRYSTAL_RATE1 = "crystal1",			--水晶收益率1
	CRYSTAL_RATE2 = "crystal2",			--水晶收益率2
	CRYSTAL_RATE3 = "crystal3",			--水晶收益率3
	CRYSTAL_RATE4 = "crystal4",			--水晶收益率4
	CRYSTAL_RATE5 = "crystal5",			--水晶收益率5
	
	GENADE_CD1 = "genade_cd1",			--手雷冷却1
	GENADE_CD2 = "genade_cd2",			--手雷冷却2
	GENADE_CD3 = "genade_cd3",			--手雷冷却3
	GENADE_CD4 = "genade_cd4",			--手雷冷却4
	GENADE_CD5 = "genade_cd5",			--手雷冷却5
	
	MELEE_BOUNCE1 = "melee_bounce1",		--近战弹开1
	MELEE_BOUNCE2 = "melee_bounce2",		--近战弹开2
	MELEE_BOUNCE3 = "melee_bounce3",		--近战弹开3
	MELEE_BOUNCE4 = "melee_bounce4",		--近战弹开4
	MELEE_BOUNCE5 = "melee_bounce5",		--近战弹开5
	
	MELEE_FIGHT1 = "melee_fight1",			--近战反击1
	MELEE_FIGHT2 = "melee_fight2",			--近战反击2
	MELEE_FIGHT3 = "melee_fight3",			--近战反击3
	MELEE_FIGHT4 = "melee_fight4",			--近战反击4
	MELEE_FIGHT5 = "melee_fight5",			--近战反击5
	
	MELEE_STONE1 = "melee_stone1",			--近战碎石1
	MELEE_STONE2 = "melee_stone2",			--近战碎石2
	MELEE_STONE3 = "melee_stone3",			--近战碎石3
	MELEE_STONE4 = "melee_stone4",			--近战碎石4
	MELEE_STONE5 = "melee_stone5",			--近战碎石5
	
	PET_HR1 = "pet_hr1",				--宠物回血1
	PET_HR2 = "pet_hr2",				--宠物回血2
	PET_HR3 = "pet_hr3",				--宠物回血3
	PET_HR4 = "pet_hr4",				--宠物回血4
	PET_HR5 = "pet_hr5",				--宠物回血5
	
	PET_HP1 = "pet_hp1",				--宠物生命1
	PET_HP2 = "pet_hp2",				--宠物生命2
	PET_HP3 = "pet_hp3",				--宠物生命3
	PET_HP4 = "pet_hp4",				--宠物生命4
	PET_HP5 = "pet_hp5",				--宠物生命5
	
	PET_ATK1 = "pet_atk1",				--宠物攻击1
	PET_ATK2 = "pet_atk2",				--宠物攻击2
	PET_ATK3 = "pet_atk3",				--宠物攻击3
	PET_ATK4 = "pet_atk4",				--宠物攻击4
	PET_ATK5 = "pet_atk5",				--宠物攻击5
	
	PET_AS1 = "pet_as1",				--宠物攻速1
	PET_AS2 = "pet_as2",				--宠物攻速2
	PET_AS3 = "pet_as3",				--宠物攻速3
	PET_AS4 = "pet_as4",				--宠物攻速4
	PET_AS5 = "pet_as5",				--宠物攻速5
	
	TRAP_GCD1 = "trap_gcd1",			--陷阱施法间隔1
	TRAP_GCD2 = "trap_gcd2",			--陷阱施法间隔2
	TRAP_GCD3 = "trap_gcd3",			--陷阱施法间隔3
	TRAP_GCD4 = "trap_gcd4",			--陷阱施法间隔4
	TRAP_GCD5 = "trap_gcd5",			--陷阱施法间隔5
	
	TRAP_GE1 = "trap_ge1",				--陷阱困敌时间1
	TRAP_GE2 = "trap_ge2",				--陷阱困敌时间2
	TRAP_GE3 = "trap_ge3",				--陷阱困敌时间3
	TRAP_GE4 = "trap_ge4",				--陷阱困敌时间4
	TRAP_GE5 = "trap_ge5",				--陷阱困敌时间5
	
	FLY_GCD1 = "fly_gcd1",				--天网施法间隔1
	FLY_GCD2 = "fly_gcd2",				--天网施法间隔2
	FLY_GCD3 = "fly_gcd3",				--天网施法间隔3
	FLY_GCD4 = "fly_gcd4",				--天网施法间隔4
	FLY_GCD5 = "fly_gcd5",				--天网施法间隔5
	
	FLY_GE1 = "fly_ge1",				--天网困敌时间1
	FLY_GE2 = "fly_ge2",				--天网困敌时间2
	FLY_GE3 = "fly_ge3",				--天网困敌时间3
	FLY_GE4 = "fly_ge4",				--天网困敌时间4
	FLY_GE5 = "fly_ge5",				--天网困敌时间5
	
	PUZZLE1 = "puzzle1",				--迷惑几率1
	PUZZLE2 = "puzzle2",				--迷惑几率2
	PUZZLE3 = "puzzl3",				--迷惑几率3
	PUZZLE4 = "puzzle4",				--迷惑几率4
	PUZZLE5 = "puzzle5",				--迷惑几率5
	
	--兵种卡附加的属性类型
	HP_RATE5 = "hp_rate5",			--血量+5％
	ATK_RATE5 = "atk_rate5",		--攻击+5％
	AR5 = "ar5",					--射程+50
	DMG5 = "dmg5",					--伤害+5％
	--DP5 = "dp5",					--物防+5
	--DM5 = "dm5",					--法防+5
	--DR5 = "dr5",					--闪避+5％
	--CR5 = "cr5",					--暴率+5％
	--CV5 = "cv5",					--暴倍+0.5
	HPR7 = "hpr7",					--回血+5
	--AS1 = "as1",					--攻速+5％
	MS_RATE5 = "ms_rate5",			--移速+5％
	LS8 = "ls8",					--吸血+5％
	LT5 = "lt5",					--存活+5％
	DSCT5 = "dsct5",				--价格-5％
	CD1S = "cd1s",					--冷却-1秒
	SKILL_CD1S = "skill_cd1s",		--技能冷却-1秒
	SKILL_DMG5 = "skill_dmg5",		--技能伤害+5％
	SKILL_RNG5 = "skill_rng5",		--技能范围+5％
	SKILL_COS5 = "skill_cos5",		--技能混乱+1秒
	SKILL_NUM5 = "skill_num5",		--技能数量+5％
	SKILL_POI5 = "skill_poi5",		--技能中毒+1层
	SKILL_LT1 = "skill_lt1",		--技能时间+1秒
}

local __I_A_D = hVar.ITEM_ATTR_DEF

--洗炼能洗出的属性
--道具属性品质分类池
hVar.ITEM_ATTR_QUALITY_DEF = {
	
	--{攻击        , 血量       , 物理防御   , 法术防御   , 物理闪避   , 暴击几率   , 暴击倍率   , 回血        , 复活时间   , 攻击速度   , 被动技能CD  , 吸血       },
	[__I_Q.WHITE]	= {__I_A_D.ATK_BULLET1, __I_A_D.HP1, __I_A_D.DP1, __I_A_D.THUNDER_DEF1, __I_A_D.FIRE_DEF1, __I_A_D.POISON_DEF1, __I_A_D.CRYSTAL_RATE1, __I_A_D.GENADE_CD1, __I_A_D.MELEE_BOUNCE1, __I_A_D.MELEE_FIGHT1, __I_A_D.PET_HR1, __I_A_D.PET_HP1, __I_A_D.PET_ATK1, __I_A_D.PET_AS1, __I_A_D.TRAP_GCD1, __I_A_D.TRAP_GE1, __I_A_D.FLY_GCD1, __I_A_D.FLY_GE1, __I_A_D.PUZZLE1,},
	[__I_Q.BLUE]	= {__I_A_D.ATK_BULLET2, __I_A_D.HP2, __I_A_D.DP2, __I_A_D.THUNDER_DEF2, __I_A_D.FIRE_DEF2, __I_A_D.POISON_DEF2, __I_A_D.CRYSTAL_RATE2, __I_A_D.GENADE_CD2, __I_A_D.MELEE_BOUNCE2, __I_A_D.MELEE_FIGHT2, __I_A_D.PET_HR2, __I_A_D.PET_HP2, __I_A_D.PET_ATK2, __I_A_D.PET_AS2, __I_A_D.TRAP_GCD2, __I_A_D.TRAP_GE2, __I_A_D.FLY_GCD2, __I_A_D.FLY_GE2, __I_A_D.PUZZLE2,},
	[__I_Q.GOLD]	= {__I_A_D.ATK_BULLET3, __I_A_D.HP3, __I_A_D.DP3, __I_A_D.THUNDER_DEF3, __I_A_D.FIRE_DEF3, __I_A_D.POISON_DEF3, __I_A_D.CRYSTAL_RATE3, __I_A_D.GENADE_CD3, __I_A_D.MELEE_BOUNCE3, __I_A_D.MELEE_FIGHT3, __I_A_D.PET_HR3, __I_A_D.PET_HP3, __I_A_D.PET_ATK3, __I_A_D.PET_AS3, __I_A_D.TRAP_GCD3, __I_A_D.TRAP_GE3, __I_A_D.FLY_GCD3, __I_A_D.FLY_GE3, __I_A_D.PUZZLE3,},
	[__I_Q.RED]	= {__I_A_D.ATK_BULLET4, __I_A_D.HP4, __I_A_D.DP4, __I_A_D.THUNDER_DEF4, __I_A_D.FIRE_DEF4, __I_A_D.POISON_DEF4, __I_A_D.CRYSTAL_RATE4, __I_A_D.GENADE_CD4, __I_A_D.MELEE_BOUNCE4, __I_A_D.MELEE_FIGHT4, __I_A_D.PET_HR4, __I_A_D.PET_HP4, __I_A_D.PET_ATK4, __I_A_D.PET_AS4, __I_A_D.TRAP_GCD4, __I_A_D.TRAP_GE4, __I_A_D.FLY_GCD4, __I_A_D.FLY_GE4, __I_A_D.PUZZLE4,},
	[__I_Q.ORANGE]	= {__I_A_D.ATK_BULLET5, __I_A_D.HP5, __I_A_D.DP5, __I_A_D.THUNDER_DEF5, __I_A_D.FIRE_DEF5, __I_A_D.POISON_DEF5, __I_A_D.CRYSTAL_RATE5, __I_A_D.GENADE_CD5, __I_A_D.MELEE_BOUNCE5, __I_A_D.MELEE_FIGHT5, __I_A_D.PET_HR5, __I_A_D.PET_HP5, __I_A_D.PET_ATK5, __I_A_D.PET_AS5, __I_A_D.TRAP_GCD5, __I_A_D.TRAP_GE5, __I_A_D.FLY_GCD5, __I_A_D.FLY_GE5, __I_A_D.PUZZLE5,},
}

--道具属性配置（属性值, 显示用的品质颜色）
hVar.ITEM_ATTR_VAL = {
	[__I_A_D.UNKNWON] = {value1 = 0, value2 = 0, quality = __I_Q.UNKNOWN, strTip = "__TEXT_Unknwon", attrAdd = "unknwon"}, --未知
	
	[__I_A_D.ATK1] = {value1 = 1, value2 = 3, quality = __I_Q.WHITE, strTip = "__Attr_Hint_atk", attrAdd = "atk"}, --攻击力
	[__I_A_D.ATK2] = {value1 = 3, value2 = 6, quality = __I_Q.BLUE, strTip = "__Attr_Hint_atk", attrAdd = "atk"}, --攻击力
	[__I_A_D.ATK3] = {value1 = 5, value2 = 9, quality = __I_Q.GOLD, strTip = "__Attr_Hint_atk", attrAdd = "atk"}, --攻击力
	[__I_A_D.ATK4] = {value1 = 7, value2 = 12, quality = __I_Q.RED, strTip = "__Attr_Hint_atk", attrAdd = "atk"}, --攻击力
	[__I_A_D.ATK5] = {value1 = 9, value2 = 15, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_atk", attrAdd = "atk"}, --攻击力
	
	[__I_A_D.ATK_BULLET1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_atk_bullet", attrAdd = "atk_bullet"}, --武器攻击力
	[__I_A_D.ATK_BULLET2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_atk_bullet", attrAdd = "atk_bullet"}, --武器攻击力
	[__I_A_D.ATK_BULLET3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_atk_bullet", attrAdd = "atk_bullet"}, --武器攻击力
	[__I_A_D.ATK_BULLET4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_atk_bullet", attrAdd = "atk_bullet"}, --武器攻击力
	[__I_A_D.ATK_BULLET5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_atk_bullet", attrAdd = "atk_bullet"}, --武器攻击力
	
	[__I_A_D.HP1] = {value1 = 40, quality = __I_Q.WHITE, strTip = "__ATTR__hp_max", attrAdd = "hp_max"}, --血量
	[__I_A_D.HP2] = {value1 = 80, quality = __I_Q.BLUE, strTip = "__ATTR__hp_max", attrAdd = "hp_max"}, --血量
	[__I_A_D.HP3] = {value1 = 120, quality = __I_Q.GOLD, strTip = "__ATTR__hp_max", attrAdd = "hp_max"}, --血量
	[__I_A_D.HP4] = {value1 = 160, quality = __I_Q.RED, strTip = "__ATTR__hp_max", attrAdd = "hp_max"}, --血量
	[__I_A_D.HP5] = {value1 = 200, quality = __I_Q.ORANGE, strTip = "__ATTR__hp_max", attrAdd = "hp_max"}, --血量
	
	[__I_A_D.DP1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_def_physic", attrAdd = "def_physic"}, --物理防御
	[__I_A_D.DP2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_def_physic", attrAdd = "def_physic"}, --物理防御
	[__I_A_D.DP3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_def_physic", attrAdd = "def_physic"}, --物理防御
	[__I_A_D.DP4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_def_physic", attrAdd = "def_physic"}, --物理防御
	[__I_A_D.DP5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_def_physic", attrAdd = "def_physic"}, --物理防御
	
	[__I_A_D.DM1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_def_magic", attrAdd = "def_magic"}, --法术防御
	[__I_A_D.DM2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_def_magic", attrAdd = "def_magic"}, --法术防御
	[__I_A_D.DM3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_def_magic", attrAdd = "def_magic"}, --法术防御
	[__I_A_D.DM4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_def_magic", attrAdd = "def_magic"}, --法术防御
	[__I_A_D.DM5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_def_magic", attrAdd = "def_magic"}, --法术防御
	
	[__I_A_D.DR1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_dodge_rate", attrAdd = "dodge_rate"}, --闪避几率（去百分号后的值）
	[__I_A_D.DR2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_dodge_rate", attrAdd = "dodge_rate"}, --闪避几率（去百分号后的值）
	[__I_A_D.DR3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_dodge_rate", attrAdd = "dodge_rate"}, --闪避几率（去百分号后的值）
	[__I_A_D.DR4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_dodge_rate", attrAdd = "dodge_rate"}, --闪避几率（去百分号后的值）
	[__I_A_D.DR5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_dodge_rate", attrAdd = "dodge_rate"}, --闪避几率（去百分号后的值）
	
	[__I_A_D.HR1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_hit_rate", attrAdd = "hit_rate"}, --命中几率（去百分号后的值）
	[__I_A_D.HR2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_hit_rate", attrAdd = "hit_rate"}, --命中几率（去百分号后的值）
	[__I_A_D.HR3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_hit_rate", attrAdd = "hit_rate"}, --命中几率（去百分号后的值）
	[__I_A_D.HR4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_hit_rate", attrAdd = "hit_rate"}, --命中几率（去百分号后的值）
	[__I_A_D.HR5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_hit_rate", attrAdd = "hit_rate"}, --命中几率（去百分号后的值）
	
	[__I_A_D.CR1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_crit_rate", attrAdd = "crit_rate"}, --暴击几率（去百分号后的值）
	[__I_A_D.CR2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_crit_rate", attrAdd = "crit_rate"}, --暴击几率（去百分号后的值）
	[__I_A_D.CR3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_crit_rate", attrAdd = "crit_rate"}, --暴击几率（去百分号后的值）
	[__I_A_D.CR4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_crit_rate", attrAdd = "crit_rate"}, --暴击几率（去百分号后的值）
	[__I_A_D.CR5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_crit_rate", attrAdd = "crit_rate"}, --暴击几率（去百分号后的值）
	
	[__I_A_D.CV1] = {value1 = 0.1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_crit_value", attrAdd = "crit_value"}, --暴击倍数（支持小数）
	[__I_A_D.CV2] = {value1 = 0.2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_crit_value", attrAdd = "crit_value"}, --暴击倍数（支持小数）
	[__I_A_D.CV3] = {value1 = 0.3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_crit_value", attrAdd = "crit_value"}, --暴击倍数（支持小数）
	[__I_A_D.CV4] = {value1 = 0.4, quality = __I_Q.RED, strTip = "__Attr_Hint_crit_value", attrAdd = "crit_value"}, --暴击倍数（支持小数）
	[__I_A_D.CV5] = {value1 = 0.5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_crit_value", attrAdd = "crit_value"}, --暴击倍数（支持小数）
	
	[__I_A_D.HPR3] = {value1 = 4, quality = __I_Q.GOLD, strTip = "__Attr_Hint_hp_restore", attrAdd = "hp_restore"}, --回血速度（每秒）（支持小数）
	[__I_A_D.HPR4] = {value1 = 6, quality = __I_Q.RED, strTip = "__Attr_Hint_hp_restore", attrAdd = "hp_restore"}, --回血速度（每秒）（支持小数）
	[__I_A_D.HPR5] = {value1 = 8, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_hp_restore", attrAdd = "hp_restore"}, --回血速度（每秒）（支持小数）
	
	[__I_A_D.RT3] = {value1 = -1000, quality = __I_Q.GOLD, strTip = "__Attr_Hint_rebirth_time", attrAdd = "rebirth_time"}, --复活时间（毫秒）
	[__I_A_D.RT4] = {value1 = -2000, quality = __I_Q.RED, strTip = "__Attr_Hint_rebirth_time", attrAdd = "rebirth_time"}, --复活时间（毫秒）
	[__I_A_D.RT5] = {value1 = -3000, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_rebirth_time", attrAdd = "rebirth_time"}, --复活时间（毫秒）
	
	[__I_A_D.AS1] = {value1 = 5, quality = __I_Q.WHITE, strTip = "__Attr_Hint_atk_speed", attrAdd = "atk_speed"}, --攻击速度（去百分号后的值）
	[__I_A_D.AS2] = {value1 = 10, quality = __I_Q.BLUE, strTip = "__Attr_Hint_atk_speed", attrAdd = "atk_speed"}, --攻击速度（去百分号后的值）
	[__I_A_D.AS3] = {value1 = 15, quality = __I_Q.GOLD, strTip = "__Attr_Hint_atk_speed", attrAdd = "atk_speed"}, --攻击速度（去百分号后的值）
	[__I_A_D.AS4] = {value1 = 20, quality = __I_Q.RED, strTip = "__Attr_Hint_atk_speed", attrAdd = "atk_speed"}, --攻击速度（去百分号后的值）
	[__I_A_D.AS5] = {value1 = 25, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_atk_speed", attrAdd = "atk_speed"}, --攻击速度（去百分号后的值）
	
	[__I_A_D.PCD1] = {value1 = -1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_passive_skill_cd_delta_rate", attrAdd = "passive_skill_cd_delta_rate"}, --被动技能CD
	[__I_A_D.PCD2] = {value1 = -2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_passive_skill_cd_delta_rate", attrAdd = "passive_skill_cd_delta_rate"}, --被动技能CD
	[__I_A_D.PCD3] = {value1 = -3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_passive_skill_cd_delta_rate", attrAdd = "passive_skill_cd_delta_rate"}, --被动技能CD
	[__I_A_D.PCD4] = {value1 = -4, quality = __I_Q.RED, strTip = "__Attr_Hint_passive_skill_cd_delta_rate", attrAdd = "passive_skill_cd_delta_rate"}, --被动技能CD
	[__I_A_D.PCD5] = {value1 = -5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_passive_skill_cd_delta_rate", attrAdd = "passive_skill_cd_delta_rate"}, --被动技能CD
	
	[__I_A_D.LS4] = {value1 = 1, quality = __I_Q.RED, strTip = "__Attr_Hint_suck_blood_rate", attrAdd = "suck_blood_rate"}, --吸血
	[__I_A_D.LS5] = {value1 = 2, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_suck_blood_rate", attrAdd = "suck_blood_rate"}, --吸血
	
	[__I_A_D.THUNDER_DEF1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_def_thunder", attrAdd = "def_thunder"}, --雷防御1
	[__I_A_D.THUNDER_DEF2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_def_thunder", attrAdd = "def_thunder"}, --雷防御2
	[__I_A_D.THUNDER_DEF3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_def_thunder", attrAdd = "def_thunder"}, --雷防御3
	[__I_A_D.THUNDER_DEF4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_def_thunder", attrAdd = "def_thunder"}, --雷防御4
	[__I_A_D.THUNDER_DEF5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_def_thunder", attrAdd = "def_thunder"}, --雷防御5
	
	[__I_A_D.FIRE_DEF1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_def_fire", attrAdd = "def_fire"}, --火防御1
	[__I_A_D.FIRE_DEF2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_def_fire", attrAdd = "def_fire"}, --火防御2
	[__I_A_D.FIRE_DEF3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_def_fire", attrAdd = "def_fire"}, --火防御3
	[__I_A_D.FIRE_DEF4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_def_fire", attrAdd = "def_fire"}, --火防御4
	[__I_A_D.FIRE_DEF5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_def_fire", attrAdd = "def_fire"}, --火防御5
	
	[__I_A_D.POISON_DEF1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_def_poison", attrAdd = "def_poison"}, --毒防御1
	[__I_A_D.POISON_DEF2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_def_poison", attrAdd = "def_poison"}, --毒防御2
	[__I_A_D.POISON_DEF3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_def_poison", attrAdd = "def_poison"}, --毒防御3
	[__I_A_D.POISON_DEF4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_def_poison", attrAdd = "def_poison"}, --毒防御4
	[__I_A_D.POISON_DEF5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_def_poison", attrAdd = "def_poison"}, --毒防御5
	
	[__I_A_D.CRYSTAL_RATE1] = {value1 = 1, quality = __I_Q.WHITE, strTip = "__Attr_Hint_crystal_rate", attrAdd = "crystal_rate"}, --水晶收益率1
	[__I_A_D.CRYSTAL_RATE2] = {value1 = 2, quality = __I_Q.BLUE, strTip = "__Attr_Hint_crystal_rate", attrAdd = "crystal_rate"}, --水晶收益率2
	[__I_A_D.CRYSTAL_RATE3] = {value1 = 3, quality = __I_Q.GOLD, strTip = "__Attr_Hint_crystal_rate", attrAdd = "crystal_rate"}, --水晶收益率3
	[__I_A_D.CRYSTAL_RATE4] = {value1 = 4, quality = __I_Q.RED, strTip = "__Attr_Hint_crystal_rate", attrAdd = "crystal_rate"}, --水晶收益率4
	[__I_A_D.CRYSTAL_RATE5] = {value1 = 5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_crystal_rate", attrAdd = "crystal_rate"}, --水晶收益率5
	
	[__I_A_D.GENADE_CD1] = {value1 = -20, quality = __I_Q.WHITE, strTip = "__Attr_Hint_grenade_cd", attrAdd = "grenade_cd"}, --手雷冷却1
	[__I_A_D.GENADE_CD2] = {value1 = -40, quality = __I_Q.BLUE, strTip = "__Attr_Hint_grenade_cd", attrAdd = "grenade_cd"}, --手雷冷却2
	[__I_A_D.GENADE_CD3] = {value1 = -60, quality = __I_Q.GOLD, strTip = "__Attr_Hint_grenade_cd", attrAdd = "grenade_cd"}, --手雷冷却3
	[__I_A_D.GENADE_CD4] = {value1 = -80, quality = __I_Q.RED, strTip = "__Attr_Hint_grenade_cd", attrAdd = "grenade_cd"}, --手雷冷却4
	[__I_A_D.GENADE_CD5] = {value1 = -100, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_grenade_cd", attrAdd = "grenade_cd"}, --手雷冷却5
	
	[__I_A_D.MELEE_BOUNCE1] = {value1 = 5, quality = __I_Q.WHITE, strTip = "__Attr_Hint_melee_bounce", attrAdd = "melee_bounce"}, --近战弹开1
	[__I_A_D.MELEE_BOUNCE2] = {value1 = 10, quality = __I_Q.BLUE, strTip = "__Attr_Hint_melee_bounce", attrAdd = "melee_bounce"}, --近战弹开2
	[__I_A_D.MELEE_BOUNCE3] = {value1 = 15, quality = __I_Q.GOLD, strTip = "__Attr_Hint_melee_bounce", attrAdd = "melee_bounce"}, --近战弹开3
	[__I_A_D.MELEE_BOUNCE4] = {value1 = 20, quality = __I_Q.RED, strTip = "__Attr_Hint_melee_bounce", attrAdd = "melee_bounce"}, --近战弹开4
	[__I_A_D.MELEE_BOUNCE5] = {value1 = 25, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_melee_bounce", attrAdd = "melee_bounce"}, --近战弹开5
	
	[__I_A_D.MELEE_FIGHT1] = {value1 = 60, quality = __I_Q.WHITE, strTip = "__Attr_Hint_melee_fight", attrAdd = "melee_fight"}, --近战反击1
	[__I_A_D.MELEE_FIGHT2] = {value1 = 120, quality = __I_Q.BLUE, strTip = "__Attr_Hint_melee_fight", attrAdd = "melee_fight"}, --近战反击2
	[__I_A_D.MELEE_FIGHT3] = {value1 = 180, quality = __I_Q.GOLD, strTip = "__Attr_Hint_melee_fight", attrAdd = "melee_fight"}, --近战反击3
	[__I_A_D.MELEE_FIGHT4] = {value1 = 240, quality = __I_Q.RED, strTip = "__Attr_Hint_melee_fight", attrAdd = "melee_fight"}, --近战反击4
	[__I_A_D.MELEE_FIGHT5] = {value1 = 300, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_melee_fight", attrAdd = "melee_fight"}, --近战反击5
	
	[__I_A_D.MELEE_STONE1] = {value1 = 60, quality = __I_Q.WHITE, strTip = "__Attr_Hint_melee_stone", attrAdd = "melee_stone"}, --近战碎石1
	[__I_A_D.MELEE_STONE2] = {value1 = 120, quality = __I_Q.BLUE, strTip = "__Attr_Hint_melee_stone", attrAdd = "melee_stone"}, --近战碎石2
	[__I_A_D.MELEE_STONE3] = {value1 = 180, quality = __I_Q.GOLD, strTip = "__Attr_Hint_melee_stone", attrAdd = "melee_stone"}, --近战碎石3
	[__I_A_D.MELEE_STONE4] = {value1 = 240, quality = __I_Q.RED, strTip = "__Attr_Hint_melee_stone", attrAdd = "melee_stone"}, --近战碎石4
	[__I_A_D.MELEE_STONE5] = {value1 = 300, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_melee_stone", attrAdd = "melee_stone"}, --近战碎石5
	
	[__I_A_D.PET_HR1] = {value1 = 10, quality = __I_Q.WHITE, strTip = "__Attr_Hint_pet_hp_restore", attrAdd = "pet_hp_restore"}, --宠物回血1
	[__I_A_D.PET_HR2] = {value1 = 20, quality = __I_Q.BLUE, strTip = "__Attr_Hint_pet_hp_restore", attrAdd = "pet_hp_restore"}, --宠物回血2
	[__I_A_D.PET_HR3] = {value1 = 30, quality = __I_Q.GOLD, strTip = "__Attr_Hint_pet_hp_restore", attrAdd = "pet_hp_restore"}, --宠物回血3
	[__I_A_D.PET_HR4] = {value1 = 40, quality = __I_Q.RED, strTip = "__Attr_Hint_pet_hp_restore", attrAdd = "pet_hp_restore"}, --宠物回血4
	[__I_A_D.PET_HR5] = {value1 = 50, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_pet_hp_restore", attrAdd = "pet_hp_restore"}, --宠物回血5
	
	[__I_A_D.PET_HP1] = {value1 = 200, quality = __I_Q.WHITE, strTip = "__Attr_Hint_pet_hp", attrAdd = "pet_hp"}, --宠物生命1
	[__I_A_D.PET_HP2] = {value1 = 400, quality = __I_Q.BLUE, strTip = "__Attr_Hint_pet_hp", attrAdd = "pet_hp"}, --宠物生命2
	[__I_A_D.PET_HP3] = {value1 = 600, quality = __I_Q.GOLD, strTip = "__Attr_Hint_pet_hp", attrAdd = "pet_hp"}, --宠物生命3
	[__I_A_D.PET_HP4] = {value1 = 800, quality = __I_Q.RED, strTip = "__Attr_Hint_pet_hp", attrAdd = "pet_hp"}, --宠物生命4
	[__I_A_D.PET_HP5] = {value1 = 1000, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_pet_hp", attrAdd = "pet_hp"}, --宠物生命5
	
	[__I_A_D.PET_ATK1] = {value1 = 5, quality = __I_Q.WHITE, strTip = "__Attr_Hint_pet_atk", attrAdd = "pet_atk"}, --宠物攻击1
	[__I_A_D.PET_ATK2] = {value1 = 10, quality = __I_Q.BLUE, strTip = "__Attr_Hint_pet_atk", attrAdd = "pet_atk"}, --宠物攻击2
	[__I_A_D.PET_ATK3] = {value1 = 15, quality = __I_Q.GOLD, strTip = "__Attr_Hint_pet_atk", attrAdd = "pet_atk"}, --宠物攻击3
	[__I_A_D.PET_ATK4] = {value1 = 20, quality = __I_Q.RED, strTip = "__Attr_Hint_pet_atk", attrAdd = "pet_atk"}, --宠物攻击4
	[__I_A_D.PET_ATK5] = {value1 = 25, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_pet_atk", attrAdd = "pet_atk"}, --宠物攻击5
	
	[__I_A_D.PET_AS1] = {value1 = 2, quality = __I_Q.WHITE, strTip = "__Attr_Hint_pet_atk_speed", attrAdd = "pet_atk_speed"}, --宠物攻速1
	[__I_A_D.PET_AS2] = {value1 = 4, quality = __I_Q.BLUE, strTip = "__Attr_Hint_pet_atk_speed", attrAdd = "pet_atk_speed"}, --宠物攻速2
	[__I_A_D.PET_AS3] = {value1 = 6, quality = __I_Q.GOLD, strTip = "__Attr_Hint_pet_atk_speed", attrAdd = "pet_atk_speed"}, --宠物攻速3
	[__I_A_D.PET_AS4] = {value1 = 8, quality = __I_Q.RED, strTip = "__Attr_Hint_pet_atk_speed", attrAdd = "pet_atk_speed"}, --宠物攻速4
	[__I_A_D.PET_AS5] = {value1 = 10, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_pet_atk_speed", attrAdd = "pet_atk_speed"}, --宠物攻速5
	
	[__I_A_D.TRAP_GCD1] = {value1 = -500, quality = __I_Q.WHITE, strTip = "__Attr_Hint_trap_groundcd", attrAdd = "trap_groundcd"}, --陷阱施法间隔1
	[__I_A_D.TRAP_GCD2] = {value1 = -1000, quality = __I_Q.BLUE, strTip = "__Attr_Hint_trap_groundcd", attrAdd = "trap_groundcd"}, --陷阱施法间隔2
	[__I_A_D.TRAP_GCD3] = {value1 = -1500, quality = __I_Q.GOLD, strTip = "__Attr_Hint_trap_groundcd", attrAdd = "trap_groundcd"}, --陷阱施法间隔3
	[__I_A_D.TRAP_GCD4] = {value1 = -2000, quality = __I_Q.RED, strTip = "__Attr_Hint_trap_groundcd", attrAdd = "trap_groundcd"}, --陷阱施法间隔4
	[__I_A_D.TRAP_GCD5] = {value1 = -2500, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_trap_groundcd", attrAdd = "trap_groundcd"}, --陷阱施法间隔5
	
	[__I_A_D.TRAP_GE1] = {value1 = 500, quality = __I_Q.WHITE, strTip = "__Attr_Hint_trap_groundenemy", attrAdd = "trap_groundenemy"}, --陷阱困敌时间1
	[__I_A_D.TRAP_GE2] = {value1 = 1000, quality = __I_Q.BLUE, strTip = "__Attr_Hint_trap_groundenemy", attrAdd = "trap_groundenemy"}, --陷阱困敌时间2
	[__I_A_D.TRAP_GE3] = {value1 = 1500, quality = __I_Q.GOLD, strTip = "__Attr_Hint_trap_groundenemy", attrAdd = "trap_groundenemy"}, --陷阱困敌时间3
	[__I_A_D.TRAP_GE4] = {value1 = 2000, quality = __I_Q.RED, strTip = "__Attr_Hint_trap_groundenemy", attrAdd = "trap_groundenemy"}, --陷阱困敌时间4
	[__I_A_D.TRAP_GE5] = {value1 = 2500, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_trap_groundenemy", attrAdd = "trap_groundenemy"}, --陷阱困敌时间5
	
	[__I_A_D.FLY_GCD1] = {value1 = -500, quality = __I_Q.WHITE, strTip = "__Attr_Hint_trap_flycd", attrAdd = "trap_flycd"}, --天网施法间隔1
	[__I_A_D.FLY_GCD2] = {value1 = -1000, quality = __I_Q.BLUE, strTip = "__Attr_Hint_trap_flycd", attrAdd = "trap_flycd"}, --天网施法间隔2
	[__I_A_D.FLY_GCD3] = {value1 = -1500, quality = __I_Q.GOLD, strTip = "__Attr_Hint_trap_flycd", attrAdd = "trap_flycd"}, --天网施法间隔3
	[__I_A_D.FLY_GCD4] = {value1 = -2000, quality = __I_Q.RED, strTip = "__Attr_Hint_trap_flycd", attrAdd = "trap_flycd"}, --天网施法间隔4
	[__I_A_D.FLY_GCD5] = {value1 = -2500, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_trap_flycd", attrAdd = "trap_flycd"}, --天网施法间隔5
	
	[__I_A_D.FLY_GE1] = {value1 = 500, quality = __I_Q.WHITE, strTip = "__Attr_Hint_trap_flyenemy", attrAdd = "trap_flyenemy"}, --天网困敌时间1
	[__I_A_D.FLY_GE2] = {value1 = 1000, quality = __I_Q.BLUE, strTip = "__Attr_Hint_trap_flyenemy", attrAdd = "trap_flyenemy"}, --天网困敌时间2
	[__I_A_D.FLY_GE3] = {value1 = 1500, quality = __I_Q.GOLD, strTip = "__Attr_Hint_trap_flyenemy", attrAdd = "trap_flyenemy"}, --天网困敌时间3
	[__I_A_D.FLY_GE4] = {value1 = 2000, quality = __I_Q.RED, strTip = "__Attr_Hint_trap_flyenemy", attrAdd = "trap_flyenemy"}, --天网困敌时间4
	[__I_A_D.FLY_GE5] = {value1 = 2500, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_trap_flyenemy", attrAdd = "trap_flyenemy"}, --天网困敌时间5
	
	[__I_A_D.PUZZLE1] = {value1 = 0.3, quality = __I_Q.WHITE, strTip = "__Attr_Hint_puzzle", attrAdd = "puzzle"}, --迷惑几率1
	[__I_A_D.PUZZLE2] = {value1 = 0.6, quality = __I_Q.BLUE, strTip = "__Attr_Hint_puzzle", attrAdd = "puzzle"}, --迷惑几率2
	[__I_A_D.PUZZLE3] = {value1 = 0.9, quality = __I_Q.GOLD, strTip = "__Attr_Hint_puzzle", attrAdd = "puzzle"}, --迷惑几率3
	[__I_A_D.PUZZLE4] = {value1 = 1.2, quality = __I_Q.RED, strTip = "__Attr_Hint_puzzle", attrAdd = "puzzle"}, --迷惑几率4
	[__I_A_D.PUZZLE5] = {value1 = 1.5, quality = __I_Q.ORANGE, strTip = "__Attr_Hint_puzzle", attrAdd = "puzzle"}, --迷惑几率5
	
	--兵种卡附加的属性类型
	[__I_A_D.HP_RATE5] = {value1 = 5, quality = __I_Q.RED, strTip = "__ATTR__hp_max", attrAdd = "hp_max_rate"}, --血量+5％
	[__I_A_D.ATK_RATE5] = {value1 = 5, quality = __I_Q.RED, strTip = "__Attr_Hint_atk", attrAdd = "atk_rate"}, --攻击+5％
	[__I_A_D.AR5] = {value1 = 50, quality = __I_Q.RED, strTip = "__Attr_Atk_Range", attrAdd = "atk_radius"}, --射程+50
	[__I_A_D.DMG5] = {value1 = 5, quality = __I_Q.RED, strTip = "__ATTR__power", attrAdd = "army_damage"}, --伤害+5％
	--DP5 = "dp5",					--物防+5
	--DM5 = "dm5",					--法防+5
	--DR5 = "dr5",					--闪避+5％
	--CR5 = "cr5",					--暴率+5％
	--CV5 = "cv5",					--暴倍+0.5
	[__I_A_D.HPR7] = {value1 = 5, quality = __I_Q.RED, strTip = "__Attr_Hint_hp_restore", attrAdd = "hp_restore"}, --回血+5
	--AS1 = "as1",					--攻速+5％
	[__I_A_D.MS_RATE5] = {value1 = 5, quality = __I_Q.RED, strTip = "__Attr_Hint_move_speed", attrAdd = "move_speed"}, --移速+5％
	[__I_A_D.LS8] = {value1 = 5, quality = __I_Q.RED, strTip = "__Attr_Hint_suck_blood_rate", attrAdd = "suck_blood_rate"}, --吸血+5％
	[__I_A_D.LT5] = {value1 = 5, quality = __I_Q.RED, strTip = "__Attr_Hint_LiveTime", attrAdd = "live_time"}, --存活+5％
	[__I_A_D.DSCT5] = {value1 = -5, quality = __I_Q.RED, strTip = "__Attr_Hint_army_discount", attrAdd = "army_discount"}, --价格-5％
	[__I_A_D.CD1S] = {value1 = -1, quality = __I_Q.RED, strTip = "__Attr_Hint_army_cooldown", attrAdd = "army_cooldown"}, --冷却-1秒
	[__I_A_D.SKILL_CD1S] = {value1 = -1, quality = __I_Q.RED, strTip = "__Attr_Hint_skill_cooldown", attrAdd = "skill_cooldown"}, --技能冷却-1秒
	[__I_A_D.SKILL_DMG5] = {value1 = 5, quality = __I_Q.RED, strTip = "__Attr_Hint_skill_damage", attrAdd = "skill_damage"}, --技能伤害+5％
	[__I_A_D.SKILL_RNG5] = {value1 = 5, quality = __I_Q.RED, strTip = "__Attr_Hint_skill_range", attrAdd = "skill_range"}, --技能范围+5％
	[__I_A_D.SKILL_COS5] = {value1 = 1, quality = __I_Q.RED, strTip = "__Attr_Hint_skill_chaos", attrAdd = "skill_chaos"}, --技能混乱+1秒
	[__I_A_D.SKILL_NUM5] = {value1 = 5, quality = __I_Q.RED, strTip = "__Attr_Hint_skill_num", attrAdd = "skill_num"}, --技能数量+5％
	[__I_A_D.SKILL_POI5] = {value1 = 1, quality = __I_Q.RED, strTip = "__Attr_Hint_skill_poison", attrAdd = "skill_poison"}, --技能中毒+1层
	[__I_A_D.SKILL_LT1] = {value1 = 1, quality = __I_Q.RED, strTip = "__Attr_Hint_skill_lasttime", attrAdd = "skill_lasttime"}, --技能时间+1秒
}

--道具孔品质对应的图片
hVar.ITEM_ATTR_CHIP_IMG_DEF = {
	
	[__I_Q.UNKNOWN] = "ICON:CHIP_SLOT", --仅供界面展示孔数
	[__I_Q.WHITE]	= "misc/button_null.png", --白色
	[__I_Q.BLUE]	= "ICON:CHIP_BLUE", --蓝色
	[__I_Q.GOLD]	= "ICON:CHIP_YELLOW", --黄色
	[__I_Q.RED]	= "ICON:CHIP_RED", --橙色
	[__I_Q.ORANGE]	= "ICON:CHIP_PURPLE", --红色
}

--道具孔品质对应的颜色
hVar.ITEM_ATTR_CHIP_COLOR_DEF = {
	
	[__I_Q.WHITE]	= {255,255,255}, --白色
	[__I_Q.BLUE]	= {117,141,240}, --蓝色
	[__I_Q.GOLD]	= {213,173,65}, --黄色
	[__I_Q.RED]	= {255,0,0}, --橙色
	[__I_Q.ORANGE]	= {255,0,255}, --红色
}


--挑战模式抽宝箱基础奖池
hVar.MAP_DIFF_BASE_CHEST_POOL = 
{
	[1] = --1阶普通装备池
	{
		{3,11011,0,},		--青铜剑
		{3,11012,0,},		--青铜双剑
		{3,11013,0,},		--粗布衣
		{3,11014,0,},		--木棉布衣
		{3,11015,0,},		--草鞋
		{3,11016,0,},		--乌拉草鞋
	},

	[2] =  --2阶普通装备池
	{
		{3,11017,0,},		--长矛
		{3,11018,0,},		--三丈矛
		{3,11019,0,},		--皮甲
		{3,11020,0,},		--镶钉皮甲
		{3,11021,0,},		--香囊
		{3,11022,0,},		--绮罗香囊
		{3,11034,0,},		--白马
	},
	[3] =  --3阶普通装备池
	{
		{3,11023,0,},		--朴刀
		{3,11024,0,},		--大砍刀
		{3,11028,0,},		--青铜甲
		{3,11029,0,},		--青铜重甲
		{3,11031,0,},		--狼牙挂饰
		{3,11032,0,},		--狼牙项链
		{3,11035,0,},		--乌丸马
	},
	[4] =  --4阶普通装备池
	{
		{3,11037,0,},		--镔铁刀
		{3,11038,0,},		--镔铁枪
		{3,11041,0,},		--镔铁甲
		{3,11043,0,},		--西凉马
		{3,11045,0,},		--刺客面具
	},
	[5] =  --5阶普通装备池
	{
		{3,11047,0,},		--镔铁戟
		{3,11049,0,},		--大宛马
		{3,11051,0,},		--爆弹护腕
		{3,11053,0,},		--培元甲
	},
	[6] =  --6阶普通装备池
	{
		{3,11115,0,},		--护手钺
		{3,11116,0,},		--夜行衣
		{3,11117,0,},		--护心镜
		{3,11118,0,},		--吐谷浑马
	},
	[7] =  --7阶普通装备池
	{
		{3,11071,0,},		--钩镰刀
		{3,11072,0,},		--铁锁甲
		{3,11073,0,},		--血精石
		{3,11074,0,},		--大郦马
	},
	[8] =  --8阶普通装备池---------------预留
	{
		{3,11071,0,},		--钩镰刀
	},
	[9] =  --9阶普通装备池---------------预留
	{
		{3,11071,0,},		--钩镰刀
	},
	[10] =  --10阶普通装备池---------------预留
	{
		{3,11071,0,},		--钩镰刀
	},
	[11] =  --1级碎片池
	{
		{6,10301,1},		--剧毒塔碎片
		{6,10302,1},		--巨炮塔碎片
		{6,10303,1},		--火焰塔碎片
		{6,10304,1},		--连弩塔碎片
		{6,10305,1},		--寒冰塔碎片
		{6,10401,1},		--练兵卡碎片
		{6,10402,1},		--桃园结义卡碎片
	},
	[12] =  --2级碎片池
	{
		{6,10306,1},		--天雷塔碎片
		{6,10307,1},		--狙击塔碎片
		{6,10309,1},		--轰天塔碎片
		{6,10409,1},		--富豪碎片
		{6,10411,1},		--妙手回春碎片
		{6,10403,1},		--破敌碎片
		{6,10404,1},		--弱敌碎片
		{6,10405,1},		--乱敌碎片
	},
	[13] =  --3级碎片池
	{
		{6,10308,1},		--滚石塔碎片
		{6,10310,1},		--粮仓碎片
		{6,10406,1},		--箭塔精通碎片
		{6,10407,1},		--炮塔精通碎片
		{6,10408,1},		--术塔精通碎片
		{6,10412,1},		--固若金汤碎片
		{6,10413,1},		--塔基加固碎片
	},
	[14] =  --4级碎片池
	{
		{6,10415,1},		--摧城拔寨碎片
		{6,10416,1},		--强化毒素碎片
		{6,10417,1},		--致命连射碎片
		--{6,10418,1},		--穿云一击碎片
		--{6,10419,1},		--天雷滚滚碎片
		{6,10420,1},		--三味真火碎片
		{6,10421,1},		--冻土碎片
		{6,10422,1},		--弹道学碎片
		{6,10423,1},		--连续发射碎片
		--{6,10424,1},		--碾压碎片
	},
	[15] =  --5级碎片池
	{
		{6,10311,1},		--擂鼓塔碎片
		{6,10312,1},		--地刺塔碎片
	},
}




--挑战模式难度及获取星数对应权值配置
hVar.MAP_DIFF_STAR_CONFIG = 
{
	--[难度] = {1星, 2星, 3星}
	[1]	= {1,2,3},				--难度1
	[2]	= {4,5,6},				--难度2
	[3]	= {7,8,9},				--难度3
}
------------------------------------------------------------------------
--当前版本合成最大支持的道具素材数量
hVar.ITEM_MERGE_LIMIT_COUNT = 2

--当前版本合成最大支持的红装神器合成素材数量
hVar.ITEM_MERGE_LIMIT_RED_QUIP_COUNT = 1

--当前版本开放的合成等级
hVar.ITEM_MERGE_LIMIT = 
{
	[__I_Q.WHITE]	= true,
	[__I_Q.BLUE]	= true,
	[__I_Q.GOLD]	= true,
	[__I_Q.RED]	= false,
	[__I_Q.ORANGE]	= false,
}

--道具等级划分（道具合成用）
hVar.ITEM_LVLIMIT_LEVEL = 
{
	--当前最大穿戴等级
	maxLimitLv = 20,
	--[道具穿戴等级] = 层次
	[1] = 1,
	[2] = 2,
	[3] = 3,
	[4] = 4,
	[5] = 5,
	[6] = 6,
	[7] = 7,
	[8] = 8,
	[9] = 9,
	[10] = 10,
	[11] = 11,
	[12] = 12,
	[13] = 13,
	[14] = 14,
	[15] = 15,
	[16] = 16,
	[17] = 17,
	[18] = 18,
	[19] = 19,
	[20] = 20,
}

--道具合成成功需要的价值
hVar.ITEM_MERGE_VALUE = 
{
	[__I_Q.WHITE]	= 3,
	[__I_Q.BLUE]	= 9,
	[__I_Q.GOLD]	= 27,
	[__I_Q.RED]	= 54,
	[__I_Q.ORANGE]	= 54,

}

--道具合成信息
hVar.ITEM_MERGE_INFO = 
{	
	------------------------说明------------------------
	--			素材道具（横轴）……
	--主道具（纵轴）	{{概率1,花费1,}, {概率2,花费2}, ……}
	--……			……
	----------------------------------------------------

	--			__I_Q.WHITE,	__I_Q.BLUE,	__I_Q.GOLD,	__I_Q.RED,	__I_Q.ORANGE
	[__I_Q.WHITE]	={	{1,10,},	{3, 20,},	{9, 50,},	{18, 100,},	{27, 300,},	},
	[__I_Q.BLUE]	={	{1,10,},	{3, 20,},	{9, 50,},	{18, 100,},	{27, 300,},	},
	[__I_Q.GOLD]	={	{1,10,},	{3, 20,},	{9, 50,},	{18, 100,},	{27, 300,},	},
	[__I_Q.RED]	={	{1,10,},	{3, 20,},	{9, 50,},	{18, 100,},	{27, 300,},	},
	[__I_Q.ORANGE]	={	{1,10,},	{3, 20,},	{9, 50,},	{18, 100,},	{27, 300,},	},
}

local __I_T = hVar.ITEM_TYPE
--道具合成池
hVar.ITEM_MERGE_POOL = 
{
	--品质白
	[__I_Q.WHITE]	={
		--部位武器
		[__I_T.WEAPON] = {11011,11017,11023,},
		--部位身体
		[__I_T.BODY] = {11013,11019,11028,},
		--部位饰品
		[__I_T.ORNAMENTS] = {11015,11021,11031,},
		--部位马
		[__I_T.MOUNT] = {11034,},
	},
	--品质蓝
	[__I_Q.BLUE]	={
		--部位武器
		[__I_T.WEAPON] = {11115,11012,11018,11071,11038,11024,11037,11047,},
		--部位身体
		[__I_T.BODY] = {11116,11029,11041,11014,11072,11053,11020,},
		--部位饰品
		[__I_T.ORNAMENTS] = {11016,11022,11032,11045,11051,11117,11073},
		--部位马
		[__I_T.MOUNT] = {11035,11043,11049,11118,11074,},
		
	},
	--品质金
	[__I_Q.GOLD]	={
		--部位武器
		[__I_T.WEAPON] = {11075,11039,11027,11040,11025,11062,11059,11057,11113,11048,11066,11076,11067,11026,11063,11109},
		--部位身体
		[__I_T.BODY] = {11110,11077,11058,11068,11061,11030,11054,11042,11092},
		--部位饰品
		[__I_T.ORNAMENTS] = {11114,11111,11052,11050,11046,11069,11064,11078,11079,11033,11088,11093,11065},
		--部位马
		[__I_T.MOUNT] = {11080,11070,11112,11044,11036,11050,11089},
	},
	--品质红
	[__I_Q.RED]	={
		--部位武器
		[__I_T.WEAPON] = {},
		--部位身体
		[__I_T.BODY] = {},
		--部位饰品
		[__I_T.ORNAMENTS] = {},
		--部位马
		[__I_T.MOUNT] = {},
	},
	--品质橙
	[__I_Q.ORANGE]	={
		--部位武器
		[__I_T.WEAPON] = {},
		--部位身体
		[__I_T.BODY] = {},
		--部位饰品
		[__I_T.ORNAMENTS] = {},
		--部位马
		[__I_T.MOUNT] = {},
	},
}

--道具洗练信息
hVar.ITEM_XILIAN_INFO = 
{
	--锁孔后的外信息
	lockInfo = {
		maxLockCountDay = 999, --每日最多洗炼的次数
		maxLock = 3,
		--[孔数] = {金币消耗，对应的道具id}   (备注：这里的金币消耗和数据库道具id对应的金币消耗需要一致)
		[0] = {0, 9902},
		[1] = {10, 9903},
		[2] = {30, 9904},
		[3] = {60, 9905},
	},
	--品质1
	[__I_Q.WHITE]	= {
		cost = --材料消耗和神器的孔数有关
		{
			[1] = 1,
		},
		attr = {						--权值
			[__I_Q.WHITE] = 0,				--白色孔属性
			[__I_Q.BLUE] = 0,				--蓝色孔属性
			[__I_Q.GOLD] = 0,				--黄色孔属性
			[__I_Q.RED] = 0,				--红色孔属性
			[__I_Q.ORANGE] = 0,				--紫色孔属性
		},		
	},
	--品质-蓝装
	[__I_Q.BLUE]	={
		cost = --材料消耗和神器的孔数有关
		{
			[1] = 2,
			[2] = 2,
		},
		attr = {						--权值
			[__I_Q.WHITE] = 0,				--白色孔属性
			[__I_Q.BLUE] = 80,				--蓝色孔属性
			[__I_Q.GOLD] = 20,				--黄色孔属性
			[__I_Q.RED] = 0,				--红色孔属性
			[__I_Q.ORANGE] = 0,				--紫色孔属性
		},		
	},
	--品质-黄装
	[__I_Q.GOLD]	={
		cost = --材料消耗和神器的孔数有关
		{
			[1] = 3,
			[2] = 3,
			[3] = 3,
		},
		attr = {						--权值
			[__I_Q.WHITE] = 0,				--白色孔属性
			[__I_Q.BLUE] = 60,				--蓝色孔属性
			[__I_Q.GOLD] = 30,				--黄色孔属性
			[__I_Q.RED] = 10,				--红色孔属性
			[__I_Q.ORANGE] = 0,				--紫色孔属性
		},		
	},
	--品质-橙装
	[__I_Q.RED]	={
		cost = --材料消耗和神器的孔数有关
		{
			[1] = 0,
			[2] = 0,
			[3] = 0,
			[4] = 0,
		},
		attr = {						--权值
			[__I_Q.WHITE] = 0,				--白色孔属性
			[__I_Q.BLUE] = 0,				--蓝色孔属性
			[__I_Q.GOLD] = 0,				--黄色孔属性
			[__I_Q.RED] = 0,				--红色孔属性
			[__I_Q.ORANGE] = 0,				--紫色孔属性
		},		
	},
	--品质-红装
	[__I_Q.ORANGE]	={
		--cost = 200,						--积分消耗
		cost = --材料消耗和神器的孔数有关
		{
			[1] = 10,
			[2] = 10,
			[3] = 10,
			[4] = 10,
		},
		attr = {						--权值
			[__I_Q.WHITE] = 0,				--白色孔属性
			[__I_Q.BLUE] = 40,				--蓝色孔属性
			[__I_Q.GOLD] = 30,				--黄色孔属性
			[__I_Q.RED] = 20,				--红色孔属性
			[__I_Q.ORANGE] = 10,				--紫色孔属性
		},		
	},
}


--道具分解神器晶石-芯片材料
hVar.ITEM_SELL_CRYSTAL = {
	[__I_Q.WHITE] = 1,				--白色装备
	[__I_Q.BLUE] = 3,				--蓝色装备分解芯片
	[__I_Q.GOLD] = 9,				--黄色装备分解芯片
	[__I_Q.RED] = 0,				--橙色装备
	[__I_Q.ORANGE] = 30,				--红色装备分解芯片
}


--道具重铸扩孔信息
hVar.ITEM_REBUILD_INFO = 
{
	--[第几个孔] = {金币消耗，对应的道具id}   (备注：这里的金币消耗和数据库道具id对应的金币消耗需要一致)
	[1] = {10, 9906},		--第一个孔价格
	[2] = {30, 9907},		--第二个孔价格
	[3] = {60, 9908},		--第三个孔价格
	[4] = {100, 9909},		--第四个孔价格
}



--战术技能卡5抽n配置
hVar.TACTIC_RANDOM_CONFIG = 
{	
	--5选1的 卡包 掉落权值
	[9101] = 
	{
		--权值，	各个品质掉落的个数（4个品质，由低到高，掉落总个数为5）--（里面的第一个位置下面第一个表，里面的数字代表数量）
		{20,		{3,2,0,0}				},
		{30,		{3,1,1,0}				},
		{30,		{2,2,1,0}				},
		{20,		{2,1,1,1}				},
	},
	--5选3的 卡包 掉落权值
	[9102] = 
	{
		--权值，	各个品质掉落的个数（4个品质，总和5）
		{20,		{2,1,1,1}				},
		{20,		{1,2,1,1}				},
		{20,		{1,1,2,1}				},
		{10,		{1,1,1,2}				},
		{10,		{0,2,1,2}				},
		{10,		{0,1,2,2}				},
	},
	
	--掉落奖池
	pool = 
	{	
		--品质1
		[1] = {
			--战术技能卡Id,		等级
			{1003,			1}, --练兵
			{1031,			1}, --破敌
			{1032,			1}, --弱敌
			{1033,			1}, --乱敌
		},
		
		--品质2
		[2] = {
			--战术技能卡Id,		等级
			{1005,			1}, --桃园结义
			{1034,			1}, --箭塔精通
			{1035,			1}, --炮塔精通
			{1036,			1}, --术塔精通
			{1047,			1}, --强化毒素
			{1051,			1}, --三味真火
			{1053,			1}, --弹道学
		},
		
		--品质3
		[3] = {
			--战术技能卡Id,		等级
			{1011,			1}, --剧毒塔
			{1012,			1}, --巨炮塔
			{1013,			1}, --火焰塔
			{1037,			1}, --富豪
			{1039,			1}, --妙手回春
			{1040,			1}, --固若金汤
			{1041,			1}, --塔基加固
			{1046,			1}, --摧城拔寨
			{1048,			1}, --致命连射
			{1052,			1}, --冻土
			{1054,			1}, --连续发射
		},
		--品质4
		[4] = {
			--战术技能卡Id,		等级
			{1014,			1}, --连弩塔
			{1015,			1}, --寒冰塔
			{1016,			1}, --天雷塔
			{1017,			1}, --狙击塔
			{1018,			1}, --滚石塔
			{1019,			1}, --轰天塔
		},
	},
}
---------------------------------zhenkira道具地图相关属性-----------------------------------


---------------------------------zhenkira任务及成就相关属性-----------------------------------
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
---------------------------------zhenkira任务及成就相关属性-----------------------------------

--道具锻造强化类型表
hVar.ItemEnhanceType = {
	[1] = {	hVar.ITEM_TYPE.HEAD,		--头部锻造表
		{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,32,39,40,41,42,43},
	},
	[2] = {	hVar.ITEM_TYPE.BODY,		--衣服锻造表
		{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,32,39,40,41,42,43},
	},
	[3] = {	hVar.ITEM_TYPE.WEAPON,		--武器锻造表
		{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,26,27,32,34,35,39,40,41,42,43},
	},
	[4] = {	hVar.ITEM_TYPE.ORNAMENTS,	--宝物锻造表
		{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,19,20,21,22,23,24,28,29,30,31,32,37,38,39,40,41,42,43},
	},
	[5] = {	hVar.ITEM_TYPE.MOUNT,		--坐骑锻造表
		{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,19,20,21,22,23,24,32,36,39,40,41,42,43},
	},
	[6] = {	hVar.ITEM_TYPE.FOOT,		--鞋子锻造表
		{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,19,20,21,22,23,24,32,39,40,41,42,43},
	},
}

--道具不同品质强化次数随机表
--{几率参数,可强化次数}
hVar.ITEM_ENHANCE_NUM = {
	[1] = {{90,0},{10,1}},				--白色
	[2] = {{70,0},{30,1},},				--蓝色
	[3] = {{50,0},{30,1},{20,2},},			--黄色
	[4] = {{50,1},{30,2},{20,3},},			--红色
}

--道具来源表,来源类型
hVar.ITEM_FROMWHAT_TYPE = {
	PICK		= 1,	--拾取		{1,3(地图唯一ID),Uid(拾取的道具的唯一ID)}
	MISSION		= 2,	--任务		{2,3(地图唯一ID),Uid(任务单位的唯一ID)}
	BUY		= 3,	--购买		{3,9004(购买商品的ID)0 (补齐位置)}
	TREASURE	= 4,	--宝箱		{4,9004'9005'9006 (青铜,白银,黄金宝箱种类),0 (如果是黄金宝箱 1,0 代表是否重转)}
	GIFT		= 5,	--网络发送的礼物{5,id,0,0}
	WISHING		= 6,	--许愿
	MAPREWARD	= 7,	--从地图中获得	特殊的地图奖励道具， 此类型道具会在新开一局游戏时被清理掉
	NET_MISSION	= 8,	--联网任务获取的道具
	UNKNOWN		= 9,	--未知
	NET		= 10,	--服务器分发
}

--[[	道具格式 1.物品ID，2.物品个数，3.额外属性{孔数，属性1，属性2...属n}，4.拾取时间{游戏内的天数，持续天数}，5.当前的道具版本号，6.道具唯一ID，7.是否可用 8.锻造锁 当锻造过 且没有锻造至顶级时 设置为0，否则设置为1 9 道具来源
	itemID,1,rewardEx,{-1,-1},hVar.CURRENT_ITEM_VERSION,item_uniqueID
--]]
hVar.ITEM_DATA_INDEX = {
	ID = 1,			--物品ID
	NUM = 2,		--个数
	SLOT = 3,		--锻造孔{孔数，属性1，属性2...属n}
	PICK = 4,		--拾取时间{游戏内的天数，持续天数}
	VERSION = 5,	--获得道具的版本号
	UNIQUE = 6,		--物品唯一ID
	--ENABLE = 7,		--物品是否可装备(满足等级需求)
	QUALITY = 7,		--物品的随机品质值（新）
	LOCK = 8,		--锻造锁 当锻造过 且没有锻造至顶级时 设置为0，否则设置为1 9 道具来源
	FROM = 9,		--来源追溯(hVar.ITEM_FROMWHAT_TYPE.NET,itemdbid,装备最大孔数（）)
	UNKNOWN = 10,		--未知
	XILIAN_COUNT = 11, --今日锁孔洗炼次数
	XILIAN_DATE = 12, --今日锁孔洗炼次数最后一次的日期（字符串）（北京时间）
	RAND_IDX1 = 13,		--随机属性索引1
	RAND_VAL1 = 14,		--随机属性值1
	RAND_IDX2 = 15,		--随机属性索引2
	RAND_VAL2 = 16,		--随机属性值2
	RAND_IDX3 = 17,		--随机属性索引3
	RAND_VAL3 = 18,		--随机属性值3
	RAND_IDX4 = 19,		--随机属性索引4
	RAND_VAL4 = 20,		--随机属性值4
	RAND_IDX5 = 21,		--随机属性索引5
	RAND_VAL5 = 22,		--随机属性值5
	RAND_SKILLIDX1 = 23,	--随机技能索引1
	RAND_SKILLLV1 = 24,	--随机技能等级1
	RAND_SKILLIDX2 = 25,	--随机技能索引2
	RAND_SKILLLV2 = 26,	--随机技能等级2
	RAND_SKILLIDX3 = 27,	--随机技能索引3
	RAND_SKILLLV3 = 28,	--随机技能等级3
}

--许愿池中的道具(现在会在tab_drop里面被重载)
hVar.WISHING_WELL_ITEM = {
	8000,		--太平要术
}  


----手机版的商店--每项第一个为 itemID，2 3 项分别是 积分和游戏币
-------------------------------------------------------------------


--装备	
hVar.GoodsEquip = {
	[1] = {1009,1200,50},
}

--消耗品
hVar.GoodsExpendable = {
	{1},{3},{5},
	{7},{9},{2},
	{4},{6},{8},
}

--HOT商品
hVar.ShopHotItem = {
	{5},{9},{6},
	{1},{10},{34},
	{35},{44},
}

--pad版 商店中商品的位置顺序
hVar.NetShopItemPos = {
	--神木剑,紫藤古仗,鱼肠
	{10},{12},{13},
}

--分解材料表,	下面的表很畸形，第1,2项是随机的，第3项是挑一个数字的    added by pangyong 2015/4/22
hVar.DecomposeMat3 = {
	[1000] = {{15,20},{3,4},{0,1,1}},--神木剑
}

--在各种作弊监测中，可被使用类以及删除存档时需要用到的 可实用类道具表
hVar.ConstItemIDList = {
	9004,
	9005,
	9006,
	9100,
	9101,
	9102,
	9202,
	9203,
	9204,
	9205,
}

--如果啥都没转到，给他们这个表里面的装备
hVar.TokenRandomItem = {
	100,		--青铜剑
	101,		--白羽扇
	102,		--匕首
	103,		--铁剑
	104,		--朴刀
	105,		--古藤杖
	106,		--镔铁枪
	107,		--巨木槌
	300,		--布衣
	301,		--白罗衫
	302,		--木棉袍
	350,		--牛皮甲
	351,		--青铜重甲
}

--装备栏坐标
--local _head,_body,_weapon,_ornaments1,_ornaments2,_mount,_foot =1,2,3,4,5,6,7
local _weapon, _body, _mount, _ornaments1, _head, _ornaments2, _foot = 1,2,3,4,5,6,7
--新版英雄卡牌装备栏坐标
hVar.NEW_EQUIPAGE_POS = {
	[1] = {
		[_weapon] = {529, -54},
		[_body] = {529, -130},
		[_mount] = {529,-288},
		[_ornaments1] = {529, -208},
		[_head] = {529, -72},
		[_ornaments2] = {597, -204},
		[_foot] = {529, -335},
	},
}

--订单系统需要的数据表
hVar.ORDER_SYS_TYPE = {
	[9004] = 7,
	[9005] = 7,
	[9006] = 7,
}

--订单系统错误列表
hVar.ORDER_SYS_ERRORLIST = {
	[1] = "P1 ERROR",
	[2] = "P2 ERROR",
	[3] = "P3 ERROR",
	[4] = "P4 ERROR",
	[5] = "P5 ERROR",
	[6] = "P6 ERROR",
	[7] = "P7 ERROR",
	[8] = "P8 ERROR",
	[9] = "P9 ERROR",
	[10] = "P10 ERROR",
	[11] = "P11 ERROR",
	[12] = "P12 ERROR",
	[13] = "P13 ERROR",
	[14] = "P14 ERROR",
	[15] = "P15 ERROR",
	[16] = "P16 ERROR",
	[17] = "P17 ERROR",
	[18] = "P18 ERROR",
	[19] = "P19 ERROR",
	[20] = "P20 ERROR",
	
	[22] = "NoAuthened",
	[23] = "NoDbCoin",
	[30] = "OldVersion",
	[44] = "ErrorOrder",
	[45] = "OrderUnfinished",
	[60] = "UidOrRidError",
	[99] = "UnknowType",
	
	[104] = "ForgeCheat",
	[110] = "ChestErrorItem",
	[111] = "NoChest",
	[112] = "ChestCheat",
	[114] = "ShopCheat",
	[120] = "VipErrorItem",
	[121] = "NoPrize",
	[144] = "ShopCheat",
	[166] = "ShopHasBuy",
	[188] = "ShopCoinNotEnough",
	[199] = "ShopErrorParam",
}

--发起设备迁移的错误列表
hVar.SYNCDATA_SYS_ERRORLIST = {
	[90] = "__TEXT_ShiftDataTip1",
	[97] = "__TEXT_ShiftDataError97",
	[98] = "__TEXT_ShiftDataError98",
	[99] = "__TEXT_ShiftDataError99",
	[100] = "__TEXT_ShiftDataError100",
	[101] = "__TEXT_ShiftDataError101",
}

--装备类型对应的位置
hVar.ITEM_EQUIPMENT_UI_INDEX = {
	[hVar.ITEM_TYPE.WEAPON] = _weapon,
	[hVar.ITEM_TYPE.BODY] = _body,
	[hVar.ITEM_TYPE.MOUNT] = _mount,
	[hVar.ITEM_TYPE.ORNAMENTS] = _ornaments1,

	[hVar.ITEM_TYPE.HEAD] = _head,
	[hVar.ITEM_TYPE.FOOT] = _foot,
}

--新版英雄卡牌道具栏坐标
hVar.ITEMPAGE_POS = {
	[1] = {
		[1] = {371,-450},
		[2] = {435,-450},
		[3] = {499,-450},
		[4] = {563,-450},
		[5] = {627,-450},
		
	},
	[2] = {
		[1] = {371,-514},
		[2] = {435,-514},
		[3] = {499,-514},
		[4] = {563,-514},
		[5] = {627,-514},
	},
}

--geyachao: 背包的每个分页的行数和列数
hVar.PLAYERBAG_X_NUM = 6 --行数
hVar.PLAYERBAG_Y_NUM = 5 --列数
hVar.PLAYERBAG_NAXNUM = 300 --最大值

--玩家背包栏坐标
hVar.NEW_PLAYERBAG_POS = {
	[1] = {
		[1] = {625 + 72 * 0 + 0, -116 - 72 * 0},
		[2] = {625 + 72 * 1 + 2, -116 - 72 * 0},
		[3] = {625 + 72 * 2 + 4, -116 - 72 * 0},
		[4] = {625 + 72 * 3 + 6, -116 - 72 * 0},
		
	},
	[2] = {
		[1] = {625 + 72 * 0 + 0, -116 - 72 * 1 - 2},
		[2] = {625 + 72 * 1 + 2, -116 - 72 * 1 - 2},
		[3] = {625 + 72 * 2 + 4, -116 - 72 * 1 - 2},
		[4] = {625 + 72 * 3 + 6, -116 - 72 * 1 - 2},
		
	},
	[3] = {
		[1] = {625 + 72 * 0 + 0, -116 - 72 * 2 - 4},
		[2] = {625 + 72 * 1 + 2, -116 - 72 * 2 - 4},
		[3] = {625 + 72 * 2 + 4, -116 - 72 * 2 - 4},
		[4] = {625 + 72 * 3 + 6, -116 - 72 * 2 - 4},
		
	},
	[4] = {
		[1] = {625 + 72 * 0 + 0, -116 - 72 * 3 - 6},
		[2] = {625 + 72 * 1 + 2, -116 - 72 * 3 - 6},
		[3] = {625 + 72 * 2 + 4, -116 - 72 * 3 - 6},
		[4] = {625 + 72 * 3 + 6, -116 - 72 * 3 - 6},
	},
	[5] = {
		[1] = {625 + 72 * 0 + 0, -116 - 72 * 4 - 8},
		[2] = {625 + 72 * 1 + 2, -116 - 72 * 4 - 8},
		[3] = {625 + 72 * 2 + 4, -116 - 72 * 4 - 8},
		[4] = {625 + 72 * 3 + 6, -116 - 72 * 4 - 8},
		
	},
	[6] = {
		[1] = {625 + 72 * 0 + 0, -116 - 72 * 5 - 10},
		[2] = {625 + 72 * 1 + 2, -116 - 72 * 5 - 10},
		[3] = {625 + 72 * 2 + 4, -116 - 72 * 5 - 10},
		[4] = {625 + 72 * 3 + 6, -116 - 72 * 5 - 10},
		
	},
	[7] = {
		[1] = {625 + 72 * 0 + 0, -116 - 72 * 6 - 12},
		[2] = {625 + 72 * 1 + 2, -116 - 72 * 6 - 12},
		[3] = {625 + 72 * 2 + 4, -116 - 72 * 6 - 12},
		[4] = {625 + 72 * 3 + 6, -116 - 72 * 6 - 12},
		
	},
}

--翰林院技能
hVar.ACADEMYSKILL = {
	[1] = {5000,5002,5004,5006,5008},
	[2] = {5200,5202,5204,5206,5208},
	[3] = {5400,5402,5404,5406,5408},
}

--群英阁模式分解装备返还金钱
--道具参数
hVar.ITEMLEVEL = {
	[0] = {NAMERGB = {255,255,255}, BACKMODEL = "misc/chariotconfig/equipbg_white.png", label = "__LABEL_COLOR_WHITE", MAT = {{0,0},{0,0},{0,0}},DEPLETE = {1,0,0},MAPGOLD = 0, ITEMMODEL = "ICON:Back_white_item", BORDERMODEL = "ICON:Border_white_item",},
	[1] = {NAMERGB = {255,255,255}, BACKMODEL = "misc/chariotconfig/equipbg_white.png", label = "__LABEL_COLOR_WHITE", MAT = {{1,5},{0,0},{0,0}},DEPLETE = {1,0,0},MAPGOLD = 200, ITEMMODEL = "ICON:Back_white_item", BORDERMODEL = "ICON:Border_white_item",},
	[2] = {NAMERGB = {117,141,240}, BACKMODEL = "misc/chariotconfig/equipbg_blue.png", label = "__LABEL_COLOR_BLUE", MAT = {{5,15},{0,2},{0,0}},DEPLETE = {5,1,0},MAPGOLD = 500, ITEMMODEL = "ICON:Back_blue_item", BORDERMODEL = "ICON:Border_blue_item",},
	[3] = {NAMERGB = {213,173,65}, BACKMODEL = "misc/chariotconfig/equipbg_yellow.png", label = "__LABEL_COLOR_GOLD", MAT = {{15,30},{3,6},{1,3}},DEPLETE = {10,3,1},MAPGOLD = 1500, ITEMMODEL = "ICON:Back_yellow_item", BORDERMODEL = "ICON:Border_yellow_item",},
	[4] = {NAMERGB = {255,96,0}, BACKMODEL = "misc/chariotconfig/equipbg_orange.png", label = "__LABEL_COLOR_ORANGE", MAT = {{30,60},{6,12},{3,6}},DEPLETE = {20,5,2},MAPGOLD = 5000, ITEMMODEL = "ICON:Back_orange_item", BORDERMODEL = "ICON:Border_orange_item",},
	[5] = {NAMERGB = {255,0,0}, BACKMODEL = "misc/chariotconfig/equipbg_red.png", label = "__LABEL_COLOR_RED", MAT = {{30,60},{6,12},{3,6}},DEPLETE = {20,5,2},MAPGOLD = 10000, ITEMMODEL = "ICON:Back_red_item", BORDERMODEL = "ICON:Border_red_item",},
}

--精英模式道具颜色
hVar.ITEM_ELITE_LEVEL = {
	[1] = {NAMERGB = {255,255,255},},
	[2] = {NAMERGB = {117,141,240},},
	[3] = {NAMERGB = {213,173,65},},
	[4] = {NAMERGB = {255,96,0},},
	[5] = {NAMERGB = {255,0,0},},
}

--不需要实体的道具列表，如果得到则直接使用 1直接使用 0不使用
hVar.NO_ENTITY_ITEM = {
	{9004,0},
	{9005,0},
	{9006,0},
	{9101,1},
	{9102,1},
}

--装备的属性映射字符串表
hVar.ItemRewardStr = {
	Atk = "__Attr_Hint_atk",
	def = "__Attr_Def",
	lea = "__Attr_Hint_Lea",
	led = "__Attr_Hint_Led",
	str = "__Attr_Hint_Str",
	int = "__Attr_Hint_Int",
	con = "__Attr_Hint_Con",
	mxhp = "__Attr_Hint_Hp",
	mxmp = "__Attr_Hint_Mp",
	activity = "__Attr_Speed",
	move = "__Attr_MoveRange",
	AtkRange = "__Attr_AtkRange",
	hpRecover = "__Attr_hpRecover",
	mpRecover = "__Attr_mpRecover",
	allAttr = "__Attr_Hint_AllAttr",
	tactics = "__Attr_tactics",
	hpSteal = "__Attr_hpSteal",
	attackHeal = "__ATTR__attackHeal",
	movepoint = "__Attr_MovePoint",
	toughness = "__Attr_Toughness",
	eliteDef = "__ATTR__eliteDef",
	meleeDef = "__ATTR__meleeDef",
	rangeDef = "__ATTR__rangeDef",
	
	--geyachao: TD的显示属性
	hp_max = "__ATTR__hp_max", --血量
	atk = "__Attr_Hint_atk", --攻击力
	atk_min = "__Attr_Hint_atk_min", --最小攻击力
	atk_max = "__Attr_Hint_atk_max", --最大攻击力
	atk_interval = "__Attr_Hint_atk_interval", --攻击间隔
	atk_speed = "__Attr_Hint_atk_speed", --攻击速度
	move_speed = "__Attr_Hint_move_speed", --移动速度
	atk_radius = "__Attr_Hint_atk_radius", --攻击范围
	def_physic = "__Attr_Hint_def_physic", --物理防御
	def_magic = "__Attr_Hint_def_magic", --法术防御
	dodge_rate = "__Attr_Hint_dodge_rate", --闪避几率（去掉百分号后的值）
	hit_rate = "__Attr_Hint_hit_rate", --命中几率（去掉百分号后的值）
	crit_rate = "__Attr_Hint_crit_rate", --暴击几率（去掉百分号后的值）
	crit_value = "__Attr_Hint_crit_value", --暴击倍数（支持小数）
	kill_gold = "__Attr_Hint_kill_gold", --击杀奖励的金币
	escape_punish = "__Attr_Hint_escape_punish", --逃怪惩罚
	hp_restore = "__Attr_Hint_hp_restore", --回血速度（每秒）（支持小数）
	suck_blood_rate = "__Attr_Hint_suck_blood_rate", --吸血率（去百分号后的值）
	rebirth_time = "__Attr_Hint_rebirth_time", --复活时间（毫秒）
	AI_attribute = "__Attr_Hint_AI_attribute", --AI行为（0:被动怪 / 1:主动怪）
	active_skill_cd_delta = "__Attr_Hint_active_skill_cd_delta", --主动技能冷却时间变化值（毫秒）
	passive_skill_cd_delta = "__Attr_Hint_passive_skill_cd_delta", --被动技能冷却时间变化值（毫秒）
	active_skill_cd_delta_rate = "__Attr_Hint_active_skill_cd_delta_rate", --主动技能冷却时间变化比例值（去百分号后的值）
	passive_skill_cd_delta_rate = "__Attr_Hint_passive_skill_cd_delta_rate", --被动技能冷却时间变化比例值（去百分号后的值）
	hp_max_rate = "__ATTR__hp_max", --血量（去百分号后的值）
	atk_rate = "__Attr_Hint_atk", --攻击力（去百分号后的值）
	atk_radius_rate = "__Attr_Hint_atk_radius", --攻击范围（去百分号后的值）
	atk_ice = "__Attr_Hint_atk_ice", --冰攻击力
	atk_thunder = "__Attr_Hint_atk_thunder", --雷攻击力
	atk_fire = "__Attr_Hint_atk_fire", --火攻击力
	atk_poison = "__Attr_Hint_atk_poison", --毒攻击力
	atk_bullet = "__Attr_Hint_atk_bullet", --子弹攻击力
	atk_bomb = "__Attr_Hint_atk_bomb", --爆炸攻击力
	atk_chuanci = "__Attr_Hint_atk_chuanci", --穿刺攻击力
	def_ice = "__Attr_Hint_def_ice", --冰防御
	def_thunder = "__Attr_Hint_def_thunder", --雷防御
	def_fire = "__Attr_Hint_def_fire", --火防御
	def_poison = "__Attr_Hint_def_poison", --毒防御
	def_bullet = "__Attr_Hint_def_bullet", --子弹防御
	def_bomb = "__Attr_Hint_def_bomb", --爆炸防御
	def_chuanci = "__Attr_Hint_def_chuanci", --穿刺防御
	bullet_capacity = "__Attr_Hint_bullet_capacity", --携弹数量
	grenade_capacity = "__Attr_Hint_grenade_capacity", --手雷数量
	grenade_child = "__Attr_Hint_grenade_child", --子母雷数量
	grenade_fire = "__Attr_Hint_grenade_fire", --手雷爆炸火焰
	grenade_dis = "__Attr_Hint_grenade_dis", --手雷投弹距离
	grenade_cd = "__Attr_Hint_grenade_cd", --手雷冷却时间
	grenade_crit = "__Attr_Hint_grenade_crit", --手雷暴击
	grenade_multiply = "__Attr_Hint_grenade_multiply", --手雷冷却前使用次数
	inertia = "__Attr_Hint_inertia", --惯性
	crystal_rate = "__Attr_Hint_crystal_rate", --水晶收益率（去百分号后的值）
	melee_bounce = "__Attr_Hint_melee_bounce", --近战弹开
	melee_fight = "__Attr_Hint_melee_fight", --近战反击
	melee_stone = "__Attr_Hint_melee_stone", --近战碎石
	basic_weapon_level = "__Attr_Hint_basic_weapon_level", --武器等级
	pet_hp_restore = "__Attr_Hint_pet_hp_restore", --宠物回血
	pet_hp = "__Attr_Hint_pet_hp", --宠物生命
	pet_atk = "__Attr_Hint_pet_atk", --宠物攻击
	pet_atk_speed = "__Attr_Hint_pet_atk_speed", --宠物攻速
	pet_capacity = "__Attr_Hint_pet_capacity", --宠物携带数量
	trap_ground = "__Attr_Hint_trap_ground", --陷阱时间（单位：毫秒）
	trap_groundcd = "__Attr_Hint_trap_groundcd", --陷阱施法间隔（单位：毫秒）
	trap_groundenemy = "__Attr_Hint_trap_groundenemy", --陷阱困敌时间（单位：毫秒）
	trap_fly = "__Attr_Hint_trap_fly", --天网时间（单位：毫秒）
	trap_flycd = "__Attr_Hint_trap_flycd", --天网施法间隔（单位：毫秒）
	trap_flyenemy = "__Attr_Hint_trap_flyenemy", --天网困敌时间（单位：毫秒）
	puzzle = "__Attr_Hint_puzzle", --迷惑几率（去百分号后的值）
	weapon_crit_shoot = "__Attr_Hint_weapon_crit_shoot", --射击暴击
	weapon_crit_frozen = "__Attr_Hint_weapon_crit_frozen", --冰冻暴击
	weapon_crit_fire = "__Attr_Hint_weapon_crit_fire", --火焰暴击
	weapon_crit_equip = "__Attr_Hint_weapon_crit_equip", --装备暴击
	weapon_crit_hit = "__Attr_Hint_weapon_crit_hit", --击退暴击
	weapon_crit_blow = "__Attr_Hint_weapon_crit_blow", --吹风暴击
	weapon_crit_poison = "__Attr_Hint_weapon_crit_poison", --毒液暴击
}

--装备的属性是否百分比显示
hVar.ItemRewardStrMode =
{
	hpSteal = 1,
	eliteDef = 1,
	meleeDef = 1,
	rangeDef = 1,
	atk_speed = 1, --geyachao: TD道具属性百分号类型
	dodge_rate = 1, --geyachao: TD道具属性百分号类型
	hit_rate = 1, --geyachao: TD道具属性百分号类型
	crit_rate = 1, --geyachao: TD道具属性百分号类型
	suck_blood_rate = 1, --geyachao: TD道具属性百分号类型
	active_skill_cd_delta_rate = 1, --geyachao: TD道具属性百分号类型
	passive_skill_cd_delta_rate = 1, --geyachao: TD道具属性百分号类型
	hp_max_rate = 1, --geyachao: TD道具属性百分号类型
	atk_rate = 1, --geyachao: TD道具属性百分号类型
	atk_radius_rate = 1, --geyachao: TD道具属性百分号类型
	
	--geyachao:兵种属性部分
	army_damage = 1, --伤害
	live_time = 1, --生存时间
	--move_speed = 1, --移动速度
	army_discount = 1, --发兵价格
	skill_damage = 1, --技能伤害
	skill_range = 1, --技能范围
	skill_num = 1, --技能数量
	crystal_rate = 1, --水晶收益率
	pet_atk_speed = 1, --宠物攻速
	atk_bullet = 1, --子弹攻击
	weapon_crit_shoot = 1, --射击暴击
	weapon_crit_frozen = 1, --冰冻暴击
	weapon_crit_fire = 1, --火焰暴击
	weapon_crit_equip = 1, --装备暴击
	weapon_crit_hit = 1, --击退暴击
	weapon_crit_blow = 1, --吹风暴击
	weapon_crit_poison = 1, --毒液暴击
	grenade_crit = 1, --手雷暴击
	puzzle = 1, --迷惑几率
}

--装备的属性是否除以1000（毫秒）
hVar.ItemRewardMillinSecondMode =
{
	--grenade_cd = 1, --手雷冷却时间（单位：毫秒）
	trap_ground = 1, --陷阱持续时间（单位：毫秒）
	trap_groundcd = 1, --陷阱施法间隔（单位：毫秒）
	trap_groundenemy = 1, --陷阱困敌时间（单位：毫秒）
	trap_fly = 1, --天网持续时间（单位：毫秒）
	trap_flycd = 1, --天网施法间隔（单位：毫秒）
	trap_flyenemy = 1, --天网困敌时间（单位：毫秒）
	rebirth_time = 1, --复活时间（单位：毫秒）
}

--装备属性正面值符号
hVar.ItemAttrPositiveSign = 
{
	--geyachao: TD的显示属性
	hp_max = 1, --血量
	atk = 1, --攻击力
	atk_min = 1, --最小攻击力
	atk_max = 1, --最大攻击力
	atk_interval = 1, --攻击间隔
	atk_speed = 1, --攻击速度
	move_speed = 1, --移动速度
	atk_radius = 1, --攻击范围
	def_physic = 1, --物理防御
	def_magic = 1, --法术防御
	dodge_rate = 1, --物理闪避几率（去掉百分号后的值）
	dodge_magic_rate = 1, --法术闪避几率（去掉百分号后的值）
	hit_rate = 1, --命中几率（去掉百分号后的值）
	crit_rate = 1, --暴击几率（去掉百分号后的值）
	crit_value = 1, --暴击倍数（支持小数）
	kill_gold = 1, --击杀奖励的金币
	escape_punish = -1, --逃怪惩罚
	hp_restore = 1, --回血速度（每秒）（支持小数）
	suck_blood_rate = 1, --吸血率（去百分号后的值）
	rebirth_time = -1, --复活时间（毫秒）
	AI_attribute = 1, --AI行为（0:被动怪 / 1:主动怪）
	active_skill_cd_delta = -1, --主动技能冷却时间变化值（毫秒）
	passive_skill_cd_delta = -1, --被动技能冷却时间变化值（毫秒）
	active_skill_cd_delta_rate = -1, --主动技能冷却时间变化比例值（去百分号后的值）
	passive_skill_cd_delta_rate = -1, --被动技能冷却时间变化比例值（去百分号后的值）
	hp_restore_delta_rate = 1, --回血倍率比例值（去百分号后的值）
	hp_max_rate = 1, --血量（去百分号后的值）
	atk_rate = 1, --攻击力（去百分号后的值）
	atk_radius_rate = 1, --攻击范围（去百分号后的值）
}

--战车武器枪的攻击暴击属性枚举
hVar.ItemAttrAttackCrit =
{
	weapon_crit_shoot = 1, --射击暴击
	weapon_crit_frozen = 1, --冰冻暴击
	weapon_crit_fire = 1, --火焰暴击
	weapon_crit_hit = 1, --击退暴击
	weapon_crit_blow = 1, --吹风暴击
	weapon_crit_poison = 1, --毒液暴击
}

local __ItemAttrSort = {
	"def",
	"allAttr","lea","led","str","int","con","toughness",
	"mxhp","mxmp","hpRecover","mpRecover","eliteDef","meleeDef","rangeDef","hpSteal","attackHeal",
	"Atk",
	"movepoint","tactics","activity","move","AtkRange"
}

--PVP结果相关
hVar.PVP_ResultArt = {
	pvp_exp = {"UI:pvp_exp"},		--战斗力
	pvp_coin = {"UI:pvptoken"},		--PVP点数
	pvp_elo = {"UI:pvp_elo"},		--排行相关
	game_score = {"UI:score"},		--积分奖励
}

hVar.PVP_ResultInfoLab = {
	none = "",
	victory = "PVPSuccessfully",
	quick = "__TEXT_Quick",
	duel = "__TEXT_Duel",
	lost = "__TEXT_Fail",
	alive = "__TEXT_Alive",
	delay = "__TEXT_Delay",
	max_dps = "__Attr_Crit",
	max_hps = "__TEXT_Heal",
	weak = "__TEXT_Weak",
	defend = "__TEXT_Defend",
	extra = "__TEXT_Extra",
}
hVar.ITEM_ATTR_SORT = {
	--[hVar.ITEM_TYPE.ORNAMENTS] = {
	--},
	--[hVar.ITEM_TYPE.HEAD] = {
		--def = 1,
	--},
	--[hVar.ITEM_TYPE.BODY] = {
		--def = 1,
	--},
	--[hVar.ITEM_TYPE.FOOT] = {
		--def = 1,
	--},
	[hVar.ITEM_TYPE.WEAPON] = {
		Atk = 1,
	},
	[hVar.ITEM_TYPE.MOUNT] = {
		movepoint = 1,
	},
	
}
for _,t in pairs(hVar.ITEM_ATTR_SORT)do
	for k in pairs(t)do
		t[k] = t[k] + #__ItemAttrSort
	end
end
for i = 1,#__ItemAttrSort do
	hVar.ITEM_ATTR_SORT[__ItemAttrSort[i]] = #__ItemAttrSort-i+1
end

--英雄特有属性说明
hVar.attr_info = {
	[1] = {icon = "ICON:HeroAttr_leadship",name = "__Attr_Hint_Lea",info = "__TEXT_Attr_Lea_Info"},
	[2] = {icon = "ICON:HeroAttr_defense",name = "__Attr_Hint_Led",info = "__TEXT_Attr_Led_Info"},
	[3] = {icon = "ICON:HeroAttr_str",name = "__Attr_Hint_Str",info = "__TEXT_Attr_Str_Info"},
	[4] = {icon = "ICON:HeroAttr_int",name = "__Attr_Hint_Int",info = "__TEXT_Attr_Int_Info"},
	[5] = {icon = "ICON:HeroAttr_con",name = "__Attr_Hint_Con",info = "__TEXT_Attr_Con_Info"},
}

--英雄基础属性说明
hVar.HeroAttrInfo = {
	[1] = {x = 80, y = -146,icon = "ICON:HeroAttr",name = "__ATTR__hp_max",info = "__TEXT_Attr_HP_Info",info2 = "",animation = "hp_pec"},				--生命
	[2] = {x = 80,y = -174,icon = "ICON:action_attack",name = "__Attr_Hint_atk",info = "__TEXT_Attr_Atk_Info",info2 = ""},						--攻击
	[3] = {x = 80,y = -202,icon = "ICON:DETICON",name = "__Attr_Hint_def_physic",info = "__TEXT_Attr_Def_Info",info2 = ""},							--物防
	[4] = {x = 80,y = -230,icon = "ICON:icon01_x1y1",name = "__Attr_Hint_def_magic",info = "__TEXT_Attr_toughness_Info1",info2 = ""},						--法防
	[5] = {x = 80,y = -258,icon = "ICON:Item_Horse01",name = "__Attr_Hint_move_speed",info = "__TEXT_Attr_MovePoint_Info1",info2 = ""},						--速度
	[6] = {x = 80,y = -286,icon = "ICON:MOVESPEED",name = "__Attr_Hint_atk_speed",info = "__TEXT_Attr_activity_Info1",info2 = ""},							--攻速
}

--英雄基本属性需要用以解释的数据
hVar.HeroAttrNeedShow = {
	{attr = "lea",font = "numGreen",	text = "__Attr_Hint_Lea",	model = {"ICON:HeroAttr_leadship","normal"}},		--部队攻
	{attr = "led",font = "numWhite",	text = "__Attr_Hint_Led",	model = {"ICON:HeroAttr_defense","normal"}},		--部队防
	{attr = "str",font = "numRed",		text = "__Attr_Hint_Str",	model = {"ICON:HeroAttr_str","normal"}},		--力量
	{attr = "int",font = "numBlue",		text = "__Attr_Hint_Int",	model = {"ICON:HeroAttr_int","normal"}},		--智力
	{attr = "con",font = "num",		text = "__Attr_Hint_Con",	model = {"ICON:HeroAttr_con","normal"}},		--体力
}

--装备的装备需求映射字符串表
hVar.ItemRequireStr = {
	level = "__Item_Require_Level",
	str = "__Item_Require_Str",
	def = "__Item_Require_Def",
	int = "__Item_Require_Int",
	led = "__Item_Require_Led",
	lda = "__Item_Require_Lea",
}

--装备种类映射的字符串表
hVar.ItemTypeStr = {
	[1] = "__TEXT_ITEM_TYPE_NONE",
	[2] = "__TEXT_ITEM_TYPE_HEAD",
	[3] = "__TEXT_ITEM_TYPE_BODY",
	[4] = "__TEXT_ITEM_TYPE_WEAPON",
	[5] = "__TEXT_ITEM_TYPE_ORNAMENTS",
	[6] = "__TEXT_ITEM_TYPE_MOUNT",
	[7] = "__TEXT_ITEM_TYPE_FOOT",
	[8] = "__TEXT_ITEM_TYPE_HEROCARD",
	[9] = "__TEXT_ITEM_TYPE_PLAYERITEM",
	[10] = "__TEXT_ITEM_TYPE_DEPLETION",
	[11] = "__TEXT_ITEM_TYPE_RESOURCES",
	[12] = "__TEXT_ITEM_TYPE_MAPBAG",
	[13] = "__TEXT_ITEM_TYPE_REWARD",
	[14] = "__TEXT_ITEM_TYPE_GIFTITEM",
	[15] = "__TEXT_ITEM_TYPE_SOULSTONE",
	[16] = "__TEXT_ITEM_TYPE_TACTICDEBRIS",
}

--战术技能书标签lab
hVar.SOLDIERLABTXT = {
	[1] = "__TEXT_SOLDIER_FIGHTER",
	[2] = "__TEXT_SOLDIER_SHOOTER",
	[3] = "__TEXT_SOLDIER_RIDER",
	[4] = "__TEXT_SOLDIER_WIZARD",
	[5] = "__TEXT_SOLDIER_LEGEND",
	[6] = "__TEXT_SOLDIER_MACHINE",
	[7] = "__TEXT_SOLDIER_OTHER",
	[8] = "__TEXT_SOLDIER_TOWER", --geyachao: 塔
}

--战术技能卡的分类
hVar.TACTICS_TYPE =
{
	FIGHTER = 1,	--战士
	SHOOTER = 2,	--射手
	RIDER = 3,		--骑兵
	WIZARD = 4,		--法师
	LEGEND = 5,		--圣兽
	MACHINE = 6,	--机械
	OTHER = 7,		--一般战术卡
	TOWER = 8,		--塔
	SPECIAL = 9,	--特殊塔
	ARMY = 10,		--PVP兵种卡
}
--hVar.TARCTICS_TYPE = hVar.TACTICS_TYPE		--笔误

hVar.PHONE_MENU_OPR = {
	ACHI = 1,		--成就
	BFSFRM = 2,		--战术技能卡
	HEROES = 3,		--我的英雄
	GIFT = 4,		--我的奖励
	VIP = 5,		--VIP
	SELECTMAP = 6,		--选择关卡
	AMUSEMENT = 7,		--娱乐地图
	PLAYERLIST = 8,		--玩家列表
	NETSHOP = 9,		--道具商城
}
--定义手机大厅主界面		[1].用到的哪张图 [2]面板的X坐标 [3]面板的Y坐标 [4] 对应的 哪个命令 PHONE_MENU_OPR [5]名字相关信息
hVar.PHONE_MAIN_MENU = {
	[1] = {"UI:menu_talents",166,-135,1,"__TEXT_Achievement"},---成就
	[2] = {"UI:menu_cards",635,-205,2,"Battlefieldskillbook"},---战术技能卡
	[3] = {"UI:menu_heroes",810,-315,3,"__TEXT_MyHero"},---我的英雄
	[4] = {"UI:menu_rewards",280,-300,4,"__TEXT_MyAward"},---我的奖励
	[5] = {"UI:menu_achievements",320,-120,5,"MyVIP"},---VIP
	[6] = {"UI:menu_vip",770,-440,6,"__TEXT_SelectedMap"},---选择关卡
	[7] = {"UI:menu_vip",630,-430,7,"__TEXT_Amusement_map"},---娱乐地图
	[8] = {"UI:menu_vip",370,-400,8,"__TEXT_PlayerList"},---玩家列表
	[9] = {"UI:menu_vip",456,-251,9,"__TEXT_NetShopTitle"},---道具商城
}

-----------------------------------
--我的领地专用
hVar.WDLD_ATK_Building = {
	needNextBattleFinish = 0,
	attackU = nil,
	attackWhat = nil,
	theWorld = nil
}
hVar.WDLD_RResB = {
	43001,
	43002,
	43003,
	43004,
}

hVar.WDLD_RTownB = {
	40000,
	40001,
	40002,
}

hVar.WDLD_MAP_FILE = {
	"world/level_wdld",
	"world/level_wdld2",
	"world/level_wdld3",
	"world/level_wdld4",
	"world/level_wdld5",
	"world/level_fb01",
	"world/level_fb02",
	"world/level_fb03",
}

--推荐奖励对应的分享， key 是服务器定义的 type 字段
hVar.SHARTEXT = {
	[10] = "ios_success_social_share_tencent",
	[11] = "ios_success_social_share_sina",
	[12] = "ios_success_social_share_weixin",
	[13] = "ios_success_social_share_weixin_friends",
	[14] = "ios_success_social_share_qq",
	[15] = "ios_success_social_share_qq_space",
	[16] = "ios_success_social_share_renren",
	[18] = "ios_prize_share_apple_store",
	[19] = "ios_success_social_share_facebook",
	[20] = "ios_success_social_share_twitter",
	[21] = "ios_success_social_share_googleplus",
}

hVar.RECOMMENDTEXT = {
	[1201] = "recomm_g1info",
	[1202] = "recomm_g5info",
	[1203] = "recomm_g10info",
	[1204] = "recomm_g20info",
	[1205] = "recomm_g50info",
	[40000] = "__TEXT_CMSTG_PLAY1",
}

--分享类型，SNS平台
hVar.ShareType = {
	Wechat = 1, --微信聊天
	WechatFriends = 2, --微信朋友圈
	QQChat = 4, --QQ聊天
	Qzone = 5, --QQ空间
	DouYin = 37, --抖音
}

--合法的奖励类型ID，如果不再此表内 则剔除显示
hVar.LEGALPRIZE_TYPE = {
	1030,		--首冲奖励1
	1031,		--首冲奖励2
	1032,		--首冲奖励3 --30元档
	1033,		--首冲奖励4
	1034,		--首冲奖励5
	1035,		--首冲奖励6
	1036,		--首冲奖励7
	1038,		--首充送积分箱子
	1039,		--充值198 送的 8000积分奖励
	1060,		--积分
	9004,		--网络宝箱-青铜
	9005,		--网络宝箱-白银
	9006,		--网络宝箱-黄金
	4,		--能进入仓库背包的道具
	6,		--锻造材料
	7,		--战术技能卡
	8,		--英雄卡牌
	10,		--分享到腾讯微博奖励
	11,		--分享到新浪微博奖励
	12,		--分享到微信奖励
	13,		--分享到微信好友圈奖励
	14,		--分享到QQ奖励
	15,		--分享到QQ空间奖励
	16,		--分享到人人网奖励
	18,		--苹果商店推荐奖励
	19,		--分享到faceBook奖励
	20,		--分享到twitter奖励
	21,		--分享到google+奖励
	1201,		--好友推荐1
	1202,		--好友推荐2
	1203,		--好友推荐3
	1204,		--好友推荐4
	--1205,		--好友推荐5
	1900,		--自定义奖励00
	1901,		--自定义奖励01
	1902,		--自定义奖励02
	1903,		--自定义奖励03
	1904,		--自定义奖励04
	1905,		--自定义奖励05
	1906,		--自定义奖励06
	1907,		--自定义奖励07
	1908,		--自定义奖励08
	1909,		--自定义奖励09
	1910,		--自定义奖励10
	1911,		--自定义奖励11
	1912,		--自定义奖励12
	1913,		--自定义奖励13
	1914,		--自定义奖励14
	1915,		--自定义奖励15
	1916,		--自定义奖励16
	1917,		--自定义奖励17
	1918,		--自定义奖励18
	1919,		--自定义奖励19
	1920,		--自定义奖励20
	1921,		--自定义奖励21
	1922,		--自定义奖励22
	1923,		--自定义奖励23
	1924,		--自定义奖励24
	1925,		--自定义奖励25
	1926,		--自定义奖励26
	1927,		--自定义奖励27
	1928,		--自定义奖励28
	1929,		--自定义奖励29
	1930,		--自定义奖励30
	1931,		--自定义奖励31
	1932,		--自定义奖励32
	1933,		--自定义奖励33
	1934,		--自定义奖励34
	1935,		--自定义奖励35
	1936,		--自定义奖励36
	1937,		--自定义奖励37
	1938,		--自定义奖励38
	1939,		--自定义奖励39
	1940,		--自定义奖励40
	1941,		--自定义奖励41
	1942,		--自定义奖励42
	1943,		--自定义奖励43
	1944,		--自定义奖励44
	1945,		--自定义奖励45
	1946,		--自定义奖励46
	1947,		--自定义奖励47
	1948,		--自定义奖励48
	1949,		--自定义奖励49
	1950,		--自定义奖励50
	1951,		--自定义奖励51
	1952,		--自定义奖励52
	1953,		--自定义奖励53
	1954,		--自定义奖励54
	1955,		--自定义奖励55
	1956,		--自定义奖励56
	1957,		--自定义奖励57
	1958,		--自定义奖励58
	1959,		--自定义奖励59
	1960,		--自定义奖励60
	1961,		--自定义奖励61
	1962,		--自定义奖励62
	1963,		--自定义奖励63
	1964,		--自定义奖励64
	1965,		--自定义奖励65
	1966,		--自定义奖励66
	1967,		--自定义奖励67
	1968,		--自定义奖励68
	1969,		--自定义奖励69
	1970,		--自定义奖励70
	1971,		--自定义奖励71
	1972,		--自定义奖励72
	1973,		--自定义奖励73
	1974,		--自定义奖励74
	1975,		--自定义奖励75
	1976,		--自定义奖励76
	1977,		--自定义奖励77
	1978,		--自定义奖励78
	1979,		--自定义奖励79
	1980,		--自定义奖励80
	1981,		--自定义奖励81
	1982,		--自定义奖励82
	1983,		--自定义奖励83
	1984,		--自定义奖励84
	1985,		--自定义奖励85
	1986,		--自定义奖励86
	1987,		--自定义奖励87
	1988,		--自定义奖励88
	1989,		--自定义奖励89
	1990,		--自定义奖励90
	1991,		--自定义奖励91
	1992,		--自定义奖励92
	1993,		--自定义奖励93
	1994,		--自定义奖励94
	1995,		--自定义奖励95
	1996,		--自定义奖励96
	1997,		--自定义奖励97
	1998,		--自定义奖励98
	1999,		--自定义奖励99
	2000,		--系统消息
	9999,		--红装兑换卷
	4000,		--活动信息
	5000,		--微信月卡
	--6008,		--VIP8的奖励
	--9300,		--碎片1
	--9301,		--碎片2
	--9302,		--碎片3
	--9303,		--碎片4
	--9304,		--碎片5
	--9305,		--碎片6
	--7000,		--战术精英包
	20001,		--排行榜领奖
	20002,		--邮件奖励 推荐人20游戏币领奖
	20003,		--推荐奖励1
	20004,		--推荐奖励2
	20005,		--推荐奖励3
	20006,		--推荐奖励4
	20007,		--推荐奖励5
	20008,		--活动奖励
	20009,		--活动奖励ex
	20010,		--vip5一次性奖励
	20011,		--vip6一次性奖励
	20012,		--vip7一次性奖励
	20013,		--vip8一次性奖励
	20014,		--vip7一次性奖励2
	20015,		--vip8一次性奖励2
	20016,		--vip8一次性奖励3(红妆兑换券*3, 仅限韩国版)
	20017,		--vip3一次性奖励
	20018,		--vip4一次性奖励
	20020,		--vip7以上每充2000奖励
	20028,		--服务器抽卡类奖励
	20029,		--无尽地图排行榜通知
	20030,		--魔龙宝库勤劳奖
	20031,		--带有标题和正文的奖励
	20032,		--直接开锦囊的奖励
	20033,		--只有标题和正文，没有奖励
	20034,		--夺塔奇兵带有段位、标题和正文的奖励
	20035,		--聊天龙王奖
	20036,		--军团秘境试炼勤劳奖
	20037,		--军团本周声望排名奖励
	20038,		--军团本周声望第一名奖励
	20039,		--更新维护带有标题和正文的奖励
	20040,		--体力带有标题和正文的奖励
	20041,		--感谢信带有标题和正文的奖励
	20042,		--分享信带有标题和正文的奖励
	40000,		--策马守天关推荐奖励
	40001,		--策马守天关推荐奖励
	10000,		--活动奖励
	11000,		--tank topup rewards
	11006,
}

for i = 2001,3000 do
	hVar.LEGALPRIZE_TYPE[#hVar.LEGALPRIZE_TYPE+1] = i
end

hVar.RSYZ_MAP_FILE = {
	"world/level_hdmj",
}

hVar.YXWD_MAP_FILE = {
	"world/level_yxwd",
	"world/level_yxwd2",
}

hVar.WDLD_BUILDING_REWARD = {--奖励 木、粮、石、铁、晶、钱
	{43001,0,75,0,0,0,0,10},--田
	{43002,3,0,0,0,0,0,10},--木
	{43003,0,0,3,0,0,0,10},--石
	{43004,0,0,0,2,0,0,10},--铁
	{40000,0,0,0,0,1,500,20},--城
	{40001,0,0,0,0,1,500,20},--城
	{40002,0,0,0,0,1,500,20},--城
}

hVar.TownMusicList = {
	["town/town_land02"]	= "wei",
	["town/town_depot"]	= "wei",
	["town/town_land"]	= "wei",
	["town/town_water"]	= "wei",
	["town/town_highland"]	= "wei",
}

-- 组成 战斗等级 的底板 文字 以及 X 和 Y 的 坐标偏移量 
hVar.PVPRankUI = {
	[1] = {"UI:pvp_wood", "PVPRankLevel1"}, --"百夫长"
	[2] = {"UI:pvp_wood", "PVPRankLevel2"}, --"军候"
	[3] = {"UI:pvp_wood", "PVPRankLevel3"}, --"校尉"
	[4] = {"UI:pvp_iron", "PVPRankLevel4"}, -- "中郎将"
	[5] = {"UI:pvp_iron", "PVPRankLevel5"}, --"荡寇"
	[6] = {"UI:pvp_iron", "PVPRankLevel6"}, --"虎威"
	[7] = {"UI:pvp_copper", "PVPRankLevel7"}, --"骠骑"
	[8] = {"UI:pvp_copper", "PVPRankLevel8"}, --"大将军"
	--"UI:pvp_gold"
	--"UI:pvp_crystal
}
hVar.PVPRankUIEx = {
	[1] = {"UI:pvp_crystal",0,"UI:pvp_crystal_1"},
}
--根据PVP_EXP 得到玩家当前的战斗等级
hVar.PVPLVMAX = 6 --pvp最大等级
hVar.PVPExp2Lv = {
	[1] = 0,
	[2] = 60,
	[3] = 150,
	[4] = 300,
	[5] = 540,
	[6] = 930,
	[7] = 64000,
	[8] = 128000,
	[9] = 256000,
	[10] = 512000,
	[11] = 1024000,
}
--pvp_exp的方案
hVar.PowerLvList = {
	[1] = {0,100},
	[2] = {100,300},
	[3] = {300,600},
	[4] = {600,900},
	[5] = {900,1200},
	[6] = {1200,1600},
	[7] = {1600,2000},
	[8] = {2000,2400},
	[9] = {2400,3000},
	[10] = {3000,4000},
	[11] = {4000,5000},
	[12] = {5000,6000},
	[13] = {6000,7500},
	[14] = {7500,9000},
	[15] = {9000,-1},
}

hVar.WDLD_TownHirePec = {200,200,200,200,200,300,300,300,300,300,300,400,400,400,400,400,400,500,500,500,500,500,500,600,600,600,600,600,600,700,}

hVar.WDLD_RandomBattleScore = {
	4500,
	4650,
	4800,
	4950,
	5100,
	7875,
	8100,
	8325,
	8550,
	8775,
	9000,
	12300,
	12600,
	12900,
	13200,
	13500,
	13800,
	17625,
	18000,
	18375,
	18750,
	19125,
	19500,
	23850,
	24300,
	24750,
	25200,
	25650,
	26100,
	30975,
}
hVar.WDLD_Heros = {}--进我的领地的英雄
hVar.WDLD_HeroNum = {
	["level_wdld"] = 6,
	["level_wdld2"] = 6,
	["level_wdld3"] = 6,
	["level_wdld4"] = 8,
	["level_wdld5"] = 8,
	["level_fb01"] = 1,
	["level_fb02"] = 1,
	["level_fb03"] = 2,
} -- 我的领地只能进6个
hVar.WDLD_AtkHeroNum = 3 --进攻别人的只能3人

hVar.WDLD_Exploit = {
	{1,0,{0,0,1,0,0},"",},--领地等级 统帅 附加基本属性 附加额外属性
	{1,1000,{0,0,1,0,0},"",},
	{1,1000,{0,0,1,0,0},"",},
	{1,1000,{0,0,1,0,0},"",},
	{3,1000,{0,0,0,1,0},"",},
	{3,1000,{0,0,0,1,0},"",},
	{3,1000,{0,0,0,1,0},"",},
	{3,1000,{0,0,0,1,0},"",},
	{6,2000,{0,0,1,1,0},"",},--建议校尉
}
---------------------------------------------------------
--三个章节 镜头的初始化位置
hVar.CAMERA_VIEW = {
	[1] = {0,0},
	[2] = {1024,0},
	[3] = {0,0},
}

--地图章节分类 根据地图判断章节时 所需要的表
hVar.CHAPTER_MAP = {
	--第一章乱世
	[1] = {
		["world/level_tyjy"] = 1,
		["world/level_xsnd"] = 2,
	},
}

--定义剧情地图 的按钮风格---
--[2] x [3] y [4] 地图名字的 lab 坐标和 字体大小 颜色
hVar.STORYMAP = {
	--第一章 乱世
	[1] = {
		[1] = {"world/level_tyjy",350,-100,{labX = -1,labY = 45,size = 23,RGB = {230,180,50}}},
		[2]= {"world/level_xsnd" ,600,-130,{labX = -1,labY = 45,size = 23,RGB = {230,180,50}}},
	},
}

--定义地图之间的 连接箭头---（已经废弃了）
hVar.STORYMAPARROW = {
	--乱世
	[1] = {
		[1] = {"tyjy_xsnd" ,470,-130,"map_arrow_01","DR"},
		[2] = {"xsnd_hjzl" ,720,-160,"map_arrow_02","RD"},
	},
}

--定义娱乐地图----
--[2] x [3] y [4] 地图名字的 lab 坐标和 字体大小 颜色  [5]一些会在外面显示的内容
hVar.AMUSEMENTMAP = {
	--乱世娱乐地图
	[1] = {
		[1] = {"world/level_lcfj",240,-300,{labX = -1,labY = 45,size = 23,RGB = {230,180,50}},"all"},
		[2] = {"world/level_zlzy",240,-130,{labX = -1,labY = 45,size = 23,RGB = {230,180,50}},"ach_king",},
	},

}


--特殊的地图包地图
hVar.MAP_BAG_EX = {
	"world/level_bmzw",		--白马之围
}


hVar.CloseButtonWH = {
	[1] = 79,
	[2] = 73,
}
hVar.ShopTemporaryData = {
	[1] = {id = 303,ShopItemID = 9006,ShopItemState = 1,ShopItemPrice = 0},
}

--玩家游戏行为表，用来统计玩家在地图中的 游戏进程
--9位数来统计玩家行为， 从左边数，5位代表地图唯一ID， 后4位代表地图行为ID
hVar.PlayerBehaviorList = {
	--[20000]  = 911000000,	--获取权限(此时无UID 所以无效 废弃)
	--[20001]  = 911000001,	--点击开始按钮(第一次游戏不会点开始按钮  只有重进才能统计到)
	[20002]  = 911000002,	--实名认证
	[20003]  = 911000003,	--输入名字
	[20004]  = 911000004,	--继续探险
	--[20005]  = 911000005,	--回到基地(废弃)
	[20006]  = 911000006,	--注册账号
}

--地图引导统计
--地图标识id 5位组成 首位表示难度(难度+1 默认难度0)  后几位表示地图uid
hVar.PlayerBehaviorList.Map = {
	[10027] = {	--引导图
		--9000 - 9002默认存在
		--100279000,	--进入地图
		--100279001,	--游戏失败
		--100279002,	--通关地图
		[1] = 100270001,	--全打死蜘蛛怪
		[2] = 100270002,	--破坏阻挡物
		[3] = 100270003,	--打死机枪怪
		[4] = 100270004,	--营救科学家
		[5] = 100270005,	--打死口水怪
		[6] = 100270006,	--使用火箭战术卡
		[7] = 100270007,	--打死第二批蜘蛛怪
		[8] = 100270008,	--打死大蜘蛛怪
		[9] = 100270009,	--进入黑龙区域
	},
	[10034] = {	--矿山巨兽1
	},
	[10035] = {	--矿山巨兽2
	},
	[10036] = {	--矿山巨兽3
	},
	[10037] = {	--矿山巨兽4
	},
	[10046] = {	--母舰1
	},
	[10047] = {	--母舰2
	},
	[10048] = {	--母舰3
	},
	[10049] = {	--母舰4
	},
	[10038] = {	--异虫1
	},
	[10039] = {	--异虫2
	},
	[10040] = {	--异虫3
	},
	[10041] = {	--异虫4
	},
	[10042] = {	--魔眼1
	},
	[10043] = {	--魔眼2
	},
	[10044] = {	--魔眼3
	},
	[10045] = {	--魔眼4
	},
	[10051] = {	--空中堡垒1
	},
	[10052] = {	--空中堡垒2
	},
	[10053] = {	--空中堡垒3
	},
	[10054] = {	--空中堡垒4
	},
	[10055] = {	--弧反应堆1
	},
	[10056] = {	--弧反应堆2
	},
	[10057] = {	--弧反应堆3
	},
	[10058] = {	--弧反应堆4
	},
}

--完成地图解锁显示
hVar.UnlockAumMapList = {

	--黄巾之乱对应的解锁地图
	["world/level_hjzl"] = {
		[0] = "UnlockAum_hjzl",
		[1] = "world/level_scs",
		[2] = "world/level_qyg",
		[3] = "world/level_yxwd",
		[4] = "world/level_yxwd2",
	},

}

--玩家起名、改名，服务器返回的玩家名已存在的列表
hVar.NetPlayerNamesRet = {}

--英文版用的 替换文字太长的 哈希表
hVar.ReSetBtnLab = {
	["Swear Brotherhood"] = "Brotherhood",
	["Yellow-turban Rebellion"] = "Yellow-turban",
	["Crusade Against Dong"] = "Crusade Against",
	["Re-fight the Three Brothers"] = "Re-fight Brothers",
	["Battle of Ziwu Valley"] = "Ziwu Valley",
}

--地图额外资源支持,内存优化,海战用,填了以后这些地图才能用水
hVar.MAP_RESOURCE_EX = {
	["world/level_cbzz1"] = {"data/xlobj/xlobjs_sea_battle.plist"},
}

--1~1000的随机数表
hVar.RANDOM_NUMBER_LIST =
{
	38,7974,9109,9715,4341,713,7092,7735,2673,3637,9266,4254,6351,5810,4401,82,6601,7577,4376,5830, --row:1
	7827,2025,6052,7561,6904,8334,7454,9489,1327,8599,3579,7800,4015,4652,2153,4634,7589,6485,6321,5939, --row:2
	8802,2790,4906,5882,7290,6150,7045,6733,1151,646,9321,606,3473,3762,4051,1232,5986,6498,4647,4149, --row:3
	9787,7463,4582,6026,8578,9410,9042,5983,5980,3523,3306,6682,3508,1773,6935,8019,734,2651,7820,1228, --row:4
	4235,594,5158,6207,6864,4412,5411,9875,3917,5035,328,8386,7761,7886,1063,994,7479,199,7483,8392, --row:5
	5091,8586,6711,3342,4935,7174,9963,6399,7737,1621,1756,4541,5962,9320,541,5531,1995,1110,4819,5803, --row:6
	5714,4805,3811,4708,3021,5847,6745,2906,1894,5401,9813,7747,7521,1212,4868,3422,3077,1516,8923,8718, --row:7
	7706,7339,8514,191,8279,3485,7984,3542,6477,3527,5761,1051,7776,9114,7685,7841,3878,8907,1446,4813, --row:8
	5175,7461,1200,1045,4786,9353,6422,3486,737,8882,4063,6738,7859,647,8067,757,5942,1316,5310,9265, --row:9
	5732,7896,2041,6714,9314,2825,9855,6578,6460,1190,5296,8824,3488,384,2125,9341,6214,7523,330,9162, --row:10
	3534,4920,942,6281,3229,8951,699,7883,6524,2599,5658,5790,2994,7011,7771,2951,2352,2367,3535,3773, --row:11
	4703,3382,8736,6116,9740,8381,7756,8947,6798,5864,5140,9898,6839,430,7232,6659,6218,7010,2274,407, --row:12
	8685,7475,266,9311,231,7378,8983,1728,7253,6342,359,2730,2521,6924,3928,2659,1075,5472,7938,4818, --row:13
	2604,5173,1072,3412,8712,3539,8806,2976,7911,3699,787,2487,4525,3907,3543,3477,5600,3094,5088,2472, --row:14
	4849,5264,2991,3047,7717,548,2447,7837,6625,5953,5785,446,2074,4973,7286,3212,8140,6320,4623,988, --row:15
	3673,8479,5883,1989,2361,9231,7490,2631,2896,3702,5477,5582,9973,4706,5705,5350,8780,5528,6763,5846, --row:16
	3572,462,9599,7723,6881,3418,2959,8324,943,9903,8683,2034,7885,2699,5935,3850,252,6538,8410,4001, --row:17
	8425,2102,3600,6397,6494,4643,8175,8754,3154,7552,8530,7181,9184,6177,580,3058,8064,2207,7853,5011, --row:18
	1308,3943,1940,3792,5057,2747,4382,2892,9513,1007,4037,2677,1911,8999,878,5554,6356,7133,7247,8610, --row:19
	4284,5170,8995,6817,4224,8082,7153,6363,9403,3469,1142,5220,6553,2282,9634,7786,6235,4807,3191,9804, --row:20
	8934,6761,6254,7967,9907,4895,6378,998,9686,1693,9308,7019,2836,1676,1861,9452,2469,354,7959,165, --row:21
	7075,4996,2583,8874,8541,1820,6433,393,6673,3679,9140,6264,535,7292,3815,2358,1918,4090,759,8984, --row:22
	1247,3737,3152,5085,4392,2520,3080,8673,8767,6804,5908,9414,54,8837,2850,7299,6773,8046,5670,1899, --row:23
	609,3183,1666,5644,6305,8916,5165,5576,7661,4065,4045,41,8711,4322,2835,5627,4143,7252,8965,4683, --row:24
	8013,2390,3716,8704,4826,4253,4443,2044,1067,9631,2343,8076,7041,3346,4750,4829,973,638,630,8862, --row:25
	9031,469,5699,220,4499,7722,6115,3011,2307,852,6775,1164,2722,1096,9350,5789,3895,9211,3636,6425, --row:26
	3319,1497,1453,9204,3465,840,3391,1259,7458,5360,9416,7183,9428,5013,9413,3392,3001,5295,2777,9051, --row:27
	3635,5965,6818,7466,697,6078,7909,3902,253,6857,9129,3889,6398,8949,4731,1083,3935,5647,6731,8733, --row:28
	208,8632,3947,3830,8917,7785,8784,7992,3711,1662,2090,4378,156,1389,3093,3451,5950,2807,6031,6279, --row:29
	2000,7650,653,1607,4400,7431,3985,88,5474,7204,3613,9705,6835,6931,4057,9832,7877,2132,5674,6691, --row:30
	2027,5915,4406,3951,8811,3097,585,1241,6698,3146,2778,2232,5654,526,9282,7641,9459,5989,7433,4038, --row:31
	4292,9665,1114,1153,1618,2245,8003,1700,1050,6612,9280,7646,5147,4700,5297,4466,2903,8286,9463,727, --row:32
	7237,8169,9567,6797,7958,9555,3640,7406,5092,8946,64,3432,3876,3749,6968,4421,8875,5651,7302,9156, --row:33
	2897,7570,9456,315,488,9816,2989,2910,1106,8785,5505,1402,4561,481,7695,8597,1872,3052,7914,8852, --row:34
	2255,36,7822,797,1980,1451,2158,5078,4885,3701,5718,9736,6080,1029,1716,5629,3250,5464,5748,2813, --row:35
	6566,7778,9776,2758,4260,1272,2084,9897,3328,4586,4674,2294,2378,8502,371,929,7096,6586,9669,6577, --row:36
	9935,4956,7594,2624,5550,7173,2756,4688,7746,2322,1422,8406,1294,6030,1869,8461,8594,6749,6795,7609, --row:37
	3848,9477,3399,6317,2233,5206,5326,9227,5599,4693,474,5877,644,768,42,9515,5534,190,4991,8555, --row:38
	6147,6967,3363,3678,1011,8805,7180,8398,5859,4675,5996,9642,2555,9927,9914,6768,1406,9968,7606,7452, --row:39
	6452,8400,7013,8895,1824,7112,4618,187,9627,6648,3209,9498,3785,834,7716,458,3062,4787,9916,1849, --row:40
	4383,5918,6448,4871,4736,5897,4100,9041,6757,7430,4625,8360,7298,6729,4680,2170,453,4000,1193,2048, --row:41
	9381,1080,9711,3178,8069,2398,2772,5470,9210,7593,3299,9630,7258,8605,4581,3476,716,3389,8825,2728, --row:42
	8698,7808,4039,848,6334,4083,7370,5446,8777,7291,5719,2719,7284,4642,1168,5529,6406,9563,4715,4429, --row:43
	7659,2204,6831,246,6865,5178,4433,2966,6827,6800,7401,3468,8372,9206,486,9027,87,388,3449,4152, --row:44
	2064,4217,7236,3317,3954,7525,8996,7146,2656,8289,3765,8624,9946,5619,882,5358,4268,6109,3136,4632, --row:45
	6720,2801,6324,9040,274,5725,5016,5910,4832,4536,7160,5643,1460,4226,8215,2121,2174,1249,5843,3019, --row:46
	4354,9549,8000,628,971,7018,5385,5545,8221,8908,5027,5707,9372,1341,9295,9561,9808,634,4350,6937, --row:47
	6013,9144,1055,9276,4154,1695,5156,3683,4889,5380,3174,2198,2279,2473,9911,3797,1649,1044,1565,6224, --row:48
	8639,9979,7720,5863,2377,9905,1418,3666,4327,1821,822,4624,57,477,2337,2572,3908,313,5243,6862, --row:49
	1244,9971,5440,5480,6140,8715,2451,2237,8297,1787,7533,2970,9660,2495,4549,3893,2793,9943,8014,7032, --row:50
	9900,1915,1703,4215,7410,1542,5258,8994,8480,6905,9100,741,4227,4293,248,5740,8757,7535,3799,1483, --row:51
	5541,6563,2425,7668,7216,568,6041,3479,3262,1626,6401,8465,126,1524,2284,2689,1005,9689,1079,4578, --row:52
	6081,5530,445,5518,8730,599,2066,7550,3119,325,2037,6694,9006,1245,7933,9854,6532,8989,9687,1765, --row:53
	2888,2817,5633,1172,268,6855,7440,3741,8384,5685,9481,7828,8084,2214,6273,3237,4755,8454,1152,1018, --row:54
	4491,9017,3138,5079,9151,3827,4388,8130,8050,7597,5469,8447,4105,344,8638,8154,3568,2524,3807,9275, --row:55
	7202,4945,9084,4857,6144,9099,9565,588,8789,9784,6778,540,5977,1640,1653,1712,5825,4735,6906,735, --row:56
	2087,2927,8316,6166,5014,6897,4106,4482,605,5708,9294,7078,1123,9542,725,8554,3836,7972,1766,8335, --row:57
	104,9386,5716,5363,2012,5796,6742,1541,5655,7119,6391,8407,2590,5182,9469,2932,1030,3911,846,6998, --row:58
	1614,4960,4122,2069,7294,788,3276,5329,322,7784,5395,5607,1713,552,5425,3037,9306,799,7586,1936, --row:59
	4219,7961,172,2601,5023,5549,7568,203,7040,4856,3758,2988,3545,3980,802,7613,5384,2357,1057,6056, --row:60
	1178,376,9343,2537,8644,2442,9178,4249,6860,1461,3930,4020,6762,2717,1560,7581,9654,9348,2974,7869, --row:61
	912,7049,2485,711,9223,8741,6151,7639,2172,6130,2952,7310,2022,2748,2238,7658,7645,7028,1606,2416, --row:62
	3163,5956,3781,2782,84,5058,5099,8288,9196,8833,6483,7905,3348,4417,4457,3264,9062,3014,8109,3995, --row:63
	1750,482,8585,5512,9888,2660,4550,8277,3861,6948,2774,1224,9528,4328,3756,97,3871,9136,3658,3922, --row:64
	2299,2685,903,5318,8261,5689,5177,4769,6704,9132,1049,993,9191,167,6500,3492,4592,1933,2379,5459, --row:65
	2468,1397,6003,7140,3447,974,3398,3060,2432,8772,5517,8636,9488,495,5642,6832,5568,5096,8481,3763, --row:66
	2578,4236,3695,785,658,6652,1117,5577,9714,2387,2331,5656,9720,4854,3915,9290,2633,7772,1146,6769, --row:67
	2658,8681,5161,6286,3071,6641,5611,288,4638,6825,1780,3129,2512,2878,9112,3189,3194,2171,6170,2664, --row:68
	8853,3582,1290,9233,8371,4598,1395,2071,1214,6458,7407,9238,543,8726,5397,4179,9086,2709,5492,5130, --row:69
	429,6685,4892,7359,1194,6504,3562,8126,8119,9401,9805,6715,5970,9983,8977,1506,2544,7066,5062,7989, --row:70
	8675,2587,4831,5485,9147,1579,5816,6059,8808,8113,8595,3802,7670,4257,4961,1355,1963,9846,4842,5613, --row:71
	5941,2275,572,1023,6920,2654,4669,7505,7742,9643,4575,7459,2009,2194,8422,2368,74,1019,7188,6806, --row:72
	8674,2128,3126,7678,4764,8455,2240,8018,8831,1578,1822,8516,6669,3197,9680,68,4742,2162,3693,8368, --row:73
	9619,5795,4972,2001,7094,6487,9089,9541,6609,5540,7121,5906,8023,4088,162,9577,6275,1548,8241,4900, --row:74
	9536,5635,905,7573,2139,9858,2056,5584,2062,4681,1191,234,7362,8283,8387,5129,1764,2210,2024,7515, --row:75
	6063,898,3331,5097,7969,3745,1540,2900,9248,687,9108,3470,5659,8881,6530,9137,9706,2667,5268,9725, --row:76
	1039,3867,7603,7136,9126,7968,2271,6064,1994,5025,222,6505,2811,1092,1638,7873,8438,5281,5109,1634, --row:77
	5958,5285,9585,3200,7745,8131,9338,3376,1598,3575,6540,9492,4505,4631,3439,408,1464,979,3682,6651, --row:78
	7164,8375,4238,4518,8294,8924,6780,2115,9978,8047,4099,4475,3179,3514,491,7916,8671,8010,8086,9862, --row:79
	4672,6384,8146,1189,5018,5828,8176,1070,6655,8517,7810,8083,9450,3879,4720,9991,8088,7899,8794,2224, --row:80
	7279,20,4622,1896,7161,7584,238,7787,1762,5495,5755,296,6605,9860,399,2650,6241,6961,8529,4809, --row:81
	1528,4157,4507,3956,8740,5257,9785,2030,8622,1424,2623,5038,5696,9573,2045,2356,5911,6283,1934,1379, --row:82
	8769,9672,1991,2187,8415,9460,1631,732,6974,1459,1836,9909,6872,1253,3677,554,9910,9572,9329,3046, --row:83
	286,6316,1204,3929,9621,7857,1485,459,6185,7107,4660,2178,1986,2082,1417,5452,9483,7203,4953,9161, --row:84
	3252,3111,9866,7417,5880,8444,9404,4825,5116,2779,4590,2185,8821,9038,4526,991,9514,5113,2328,1205, --row:85
	1248,1386,4310,8120,6165,6938,221,1615,5426,4617,6360,4620,51,6091,7081,3459,7163,6340,8747,4730, --row:86
	3103,6221,8099,9316,1378,3548,3759,8274,6253,1840,9217,1547,5571,5302,3267,6926,3245,2584,4173,6248, --row:87
	9679,9571,6876,6417,1226,8072,1088,7672,1998,8538,102,7635,6038,612,9758,8959,2412,966,7307,255, --row:88
	5838,7996,4930,9243,5817,9546,5390,362,5580,9383,3170,512,4495,3147,4503,6158,6069,566,2796,8905, --row:89
	2375,1203,7625,2787,9600,520,3914,9582,7091,9828,1509,4974,3407,7323,5833,816,4241,45,331,9319, --row:90
	8985,6597,9433,2405,8572,5445,3976,6619,4073,6756,4514,7254,3443,9285,642,8608,470,2993,5028,4285, --row:91
	2901,5463,4827,3742,6499,3160,3082,9058,7021,7751,5247,3063,9506,3115,6572,8765,2266,1218,3974,2456, --row:92
	7804,6707,7199,6455,4471,4124,7762,7226,8819,3982,3977,6617,8583,4723,109,7783,2518,2278,1314,3195, --row:93
	8561,4494,186,8879,1759,456,6061,8174,2827,8250,1757,3133,4291,4760,4281,113,2889,8391,4237,2212, --row:94
	563,8619,6841,326,2680,405,8217,783,6274,9176,9803,7648,9362,6702,5087,3517,2597,4342,1570,1549, --row:95
	4449,8760,7241,1217,5030,9376,4975,9292,6916,5557,386,2785,2519,2135,7763,9901,1705,1413,4546,9235, --row:96
	4017,4795,7059,1546,4031,4402,7834,4160,2830,8032,8204,5200,3193,2386,9952,2829,9448,2938,134,7413, --row:97
	8365,6252,3587,9640,619,5319,8142,4390,48,229,5792,5842,2869,3070,5199,1816,7486,2810,6588,750, --row:98
	2552,6952,1317,3691,1046,5737,8483,3531,2295,7986,8847,1090,7704,5866,6496,758,395,3625,5933,597, --row:99
	2884,9664,2032,925,8909,8012,2573,7818,2483,4071,2138,493,2475,581,9076,8763,8418,5612,3653,1358, --row:100
	5662,6776,7506,9653,9092,595,5736,4855,8395,6502,6739,5145,9214,4239,7187,108,2059,6807,9213,5730, --row:101
	8919,8723,146,8259,1818,8385,5766,7026,2735,3028,7208,8817,6479,1696,2863,6517,6256,2108,2014,3032, --row:102
	297,2437,6219,3238,5151,1321,9636,1552,7102,698,6051,5601,111,7411,7099,6039,1897,1211,2858,3403, --row:103
	7546,7851,4968,7696,7654,7196,3798,170,5934,7027,9972,3323,9148,1736,5711,7780,6947,4165,3386,9639, --row:104
	6727,3360,7285,103,4665,6559,5261,7620,5300,2531,1391,4068,523,5921,5784,9160,8642,9801,9216,8173, --row:105
	1003,6414,3663,5774,7457,6569,4113,2287,9072,1170,4076,4148,2312,15,5278,7705,767,9159,9534,4571, --row:106
	2166,2705,1795,5493,1031,2684,7709,3345,7326,8648,2931,1723,1944,4864,2103,6459,664,4075,4840,6520, --row:107
	3651,8456,2318,292,9520,1890,1091,118,1467,2181,591,4193,442,4884,3939,8783,5752,2739,4498,2688, --row:108
	5620,8813,7425,977,1489,7793,435,7701,9726,1684,507,4658,4067,6962,9774,7277,673,6592,4046,6664, --row:109
	3085,7485,9510,2050,703,4556,6910,455,9980,7201,1501,2822,7369,8714,8843,4218,1033,6079,7817,5657, --row:110
	1366,3821,8993,7020,3870,849,1350,8472,7398,6244,4670,7375,2941,7838,8485,627,6672,1958,4997,7612, --row:111
	9186,4893,5428,55,5994,551,3746,6940,9545,8603,6050,2308,3393,3282,3408,3463,5504,2971,4176,1632, --row:112
	5379,8552,3715,4985,9165,639,5223,6306,7995,4770,3952,7462,3979,5552,9150,3324,1147,5895,4713,1935, --row:113
	3843,1601,3616,1000,8152,5031,5648,3512,404,1048,7846,8191,9155,2628,1037,550,3156,3100,8865,3511, --row:114
	8393,8352,6446,8136,66,6319,2928,4,8904,2768,7602,4458,2898,7576,1069,8332,9618,9746,4766,876, --row:115
	479,4087,4661,7795,1650,6474,641,7892,9884,8667,5065,1555,4834,4139,9024,5154,9728,574,4464,9694, --row:116
	9745,5727,6028,6803,9418,1825,3624,9455,5799,6262,4788,9289,8157,3522,593,5559,3720,5229,7512,7600, --row:117
	8468,7029,1544,720,79,1181,5823,6603,9497,2060,4793,7856,984,5521,5221,951,6884,8202,9379,1102, --row:118
	4399,5448,3072,1066,8285,4990,2791,6554,112,8266,3790,8328,3242,1498,7144,5742,8021,7919,168,6159, --row:119
	9259,3862,1969,6019,1412,9647,5565,9356,8105,1687,4337,8768,6469,964,7945,837,9969,6212,369,4904, --row:120
	2629,5671,8598,6562,267,8141,2254,5726,5824,5153,9796,8477,9609,8306,5682,9487,132,7950,1812,2349, --row:121
	8311,7262,4450,3078,4096,2914,8124,657,9142,7054,1403,6966,4264,3380,1927,7699,484,7866,1234,1475, --row:122
	4049,8437,7926,9566,5139,9495,544,8026,9737,8986,2540,9633,5121,3253,3507,2733,7700,8901,8613,1584, --row:123
	9188,6288,7347,2225,7150,2804,1863,1543,7376,9852,8321,1622,9590,2965,2462,4441,5399,2116,7477,2874, --row:124
	3157,5142,8902,8827,9397,9772,8029,3196,2222,8559,2833,1458,2327,1223,9824,938,2854,532,867,3813, --row:125
	6053,2340,7738,6373,2983,9183,2783,9518,9297,7229,4962,9272,2635,8640,3783,9560,1575,3602,9974,8471, --row:126
	8028,6092,7537,2925,420,1778,6712,8258,9457,8713,6290,823,539,2309,4246,2234,169,5263,1162,9782, --row:127
	5841,72,5163,726,4251,780,367,8429,6190,264,2643,4878,5525,2289,5564,5475,2868,4166,1960,9000, --row:128
	4928,7038,1806,6793,5762,5392,7191,3664,1838,3402,8863,860,7980,4980,2419,9751,7922,3137,2620,853, --row:129
	4914,5037,6983,1508,4302,135,7193,3494,3718,4347,6692,3608,7499,7415,1393,9958,5071,2798,2055,7069, --row:130
	8394,6149,8841,4070,8340,6113,2571,1767,2648,7074,4115,9891,5394,5043,9947,1720,7815,1550,975,305, --row:131
	2110,7572,2183,790,5456,6076,9698,9391,2608,9134,6842,6616,4987,8370,6890,2765,1932,5749,5587,702, --row:132
	6912,7923,1134,3173,2962,4092,466,2627,2213,6375,2978,6171,9941,6514,9359,9722,1220,4711,7848,2249, --row:133
	2263,2499,4989,4543,9962,2306,4419,8866,8118,6918,2920,5333,7934,2771,4859,465,8755,6357,5180,5692, --row:134
	9389,7274,364,4860,3073,9317,4963,8816,8125,2881,9697,3584,1143,2471,707,1877,333,5253,6070,2574, --row:135
	7223,6257,4438,9122,7168,2397,6629,5111,8329,1078,5441,67,1559,3924,7363,3740,4635,3506,341,3769, --row:136
	1781,9439,2242,3984,1784,1229,562,6533,869,3644,5366,8935,287,6771,3114,1112,8160,5289,2490,561, --row:137
	8489,5400,4128,733,6405,2017,7149,9071,3994,9703,997,9049,7663,6461,2446,4916,3278,9471,3700,5840, --row:138
	873,401,282,1711,7058,5701,9950,8967,4725,9729,5678,2954,1850,8319,7328,4013,5603,801,1754,3499, --row:139
	7565,9622,3132,9750,8975,2247,2223,21,7137,8196,240,8254,5955,5093,3526,8682,7790,3159,4847,3779, --row:140
	7865,9360,9409,3270,4278,9915,7993,8093,1683,3576,1909,3849,5275,75,2944,560,6736,915,9819,8932, --row:141
	3886,8237,5388,4982,8748,8672,2876,2083,1800,4194,9440,879,1293,4313,4072,9700,4321,2270,9018,8143, --row:142
	920,4535,7496,8799,8303,2593,2933,2433,5865,2720,3340,6146,4081,5179,291,6915,7128,1469,3722,5055, --row:143
	2385,4604,5724,7889,7154,6386,5961,5509,7876,5304,6350,5928,5967,2016,8707,9113,6473,3618,4639,8809, --row:144
	5783,7854,3140,6901,3571,7297,6988,9771,8725,8011,6526,2403,3884,6986,5405,5594,3172,4877,2458,8591, --row:145
	7657,777,7332,4317,5242,6333,4014,1405,2491,4296,4177,3436,9829,4925,1843,2363,3205,6574,8520,2297, --row:146
	9793,2816,6312,6437,7591,8836,1789,228,9556,712,9153,6963,8992,4659,8797,5680,7268,1743,1646,8563, --row:147
	8035,6418,217,1357,6982,7850,3165,4078,2324,1630,227,9205,3051,58,6265,6129,4773,5419,3786,5479, --row:148
	7616,6677,1835,8856,5453,9330,8246,4976,8658,6970,1518,163,4403,4276,5283,7024,9222,4311,3838,8576, --row:149
	5807,575,9066,3916,6866,4547,6933,2241,2899,4240,6087,492,9777,2402,4137,1955,8887,3585,8040,8922, --row:150
	8839,476,9173,6898,1445,4010,6705,6551,9759,2140,3771,9802,4887,4448,6121,1647,188,8186,5373,3988, --row:151
	7404,7653,5901,9957,2753,8102,9461,779,4802,4554,6991,1913,1141,1661,2837,7342,7243,7728,709,3124, --row:152
	6576,1420,9641,8943,6925,8987,8699,4527,2697,1099,9889,1532,6476,3810,9313,6480,387,2119,3434,4662, --row:153
	1118,9355,2767,1285,4969,9408,8071,2634,2404,506,8804,5198,6183,1734,7034,5616,3927,2413,3647,4021, --row:154
	3207,2130,8722,5438,5975,3249,8302,9270,2731,4028,7765,654,3726,2177,2142,5467,1484,9225,2329,3038, --row:155
	6753,8957,5943,8556,3012,4305,7381,4060,981,4283,2703,206,9421,8906,6844,1916,6954,385,7862,7516, --row:156
	5639,7391,3556,4626,815,4752,8339,7666,3725,8017,9501,2961,3372,1330,2923,8729,4646,7416,2401,7744, --row:157
	9626,3841,95,8575,4587,7656,3743,1252,3656,4263,2150,4888,5907,4850,7913,6370,1104,2459,9932,1568, --row:158
	53,2035,3186,308,3609,918,6636,1008,6128,8720,2099,6722,5420,6073,5523,2984,7721,5356,6220,7871, --row:159
	1254,281,2683,6647,6042,5588,5136,2789,3373,8686,3480,6112,4537,3221,9917,884,6382,8966,881,2508, --row:160
	5375,8147,6843,1339,6250,366,2757,5118,7652,9325,717,9800,4181,4519,1925,7280,2107,546,2619,9257, --row:161
	9685,207,9739,3287,4881,2714,6921,5248,5652,8574,25,8942,5637,3595,4919,3150,1347,5516,6034,8424, --row:162
	9491,5966,9016,1742,2821,8564,9853,3859,3622,4186,6975,6801,3864,9994,133,7677,2570,5029,6724,9250, --row:163
	1633,7022,987,448,7743,4603,5455,9405,6120,4380,7320,6182,6484,5102,9247,7335,7519,2496,4506,391, --row:164
	2093,2895,4185,214,6117,5212,5174,2273,9168,2215,3164,5344,2302,5834,1583,5327,6848,3668,1222,4074, --row:165
	9305,6272,335,9422,8213,3541,3233,6014,4306,9615,7849,1500,7988,3717,3400,1376,2762,5839,1892,9203, --row:166
	6995,1,6004,9607,110,5539,812,8185,7891,4093,5207,8661,1490,8988,7047,7082,1345,9426,5640,1450, --row:167
	8214,7999,1950,6996,9610,4336,7257,8379,4608,2973,8647,5609,3487,9181,236,3996,1411,3662,2269,3370, --row:168
	6055,1267,5954,2085,7689,1517,4687,5988,3855,3578,271,680,9054,4220,8270,81,9441,7578,7714,8469, --row:169
	8496,2852,4300,7928,1116,7493,1491,9228,3426,4199,8891,2118,6085,7036,6372,3377,2698,4685,6834,7503, --row:170
	2461,6107,7632,2362,6821,5794,9632,5728,9975,7276,3,2724,2875,9005,4473,9766,9230,5679,4696,5051, --row:171
	3404,4247,6544,8545,5033,7601,2996,4932,9807,5272,4811,9118,3273,4366,4175,9881,4159,9085,171,6008, --row:172
	4098,922,1853,5869,8498,1421,7346,9300,4927,122,7548,4615,6439,7304,3837,327,6040,2314,6622,7894, --row:173
	5722,3941,4677,2538,125,4579,1616,9661,4379,5309,4557,423,7830,1596,158,3271,1221,9447,3302,7007, --row:174
	1370,7365,557,4746,7142,7472,226,9583,6027,8944,1059,4423,1663,4589,7782,9182,9402,3301,7902,1071, --row:175
	3567,7831,8106,1455,4167,3354,6062,5408,5133,9043,1520,1669,2999,7823,3599,2937,8331,5450,4091,573, --row:176
	3117,195,1624,3973,8148,3569,3420,3210,4395,1024,194,8244,8939,9200,6755,9097,9649,9508,885,2814, --row:177
	7088,4368,6361,1470,5667,9588,5991,2265,5489,2076,8976,1839,8094,4934,3230,3227,4273,5224,3502,99, --row:178
	6552,1830,4290,7377,9394,2713,4456,3086,5815,9382,8255,6232,7289,7397,6388,9003,6615,7385,6313,8230, --row:179
	4126,9504,5704,7100,2145,6292,3739,3321,9719,9948,5060,4732,1904,1512,3419,4295,348,9930,5266,1982, --row:180
	1726,416,205,2466,2506,3007,510,9575,6889,9026,1943,2477,5201,5758,900,5744,8310,8848,9264,4270, --row:181
	5720,3938,91,9465,8482,7727,7009,2290,9543,6068,3923,2248,8823,5389,5225,4440,377,857,43,9411, --row:182
	4040,6419,6934,1240,147,3334,2582,643,5335,748,345,700,7227,4767,6096,9336,32,3169,3707,2795, --row:183
	4979,5216,2891,2410,2463,6816,6251,8801,6024,2420,1351,120,4329,5621,8664,4820,3155,6930,329,2253, --row:184
	6760,827,8075,1028,3770,4351,4308,9977,9436,7414,2141,3791,919,9601,9445,8979,7976,258,8312,8864, --row:185
	8914,9077,1318,3015,6330,8615,1597,4521,5837,39,7998,3002,5916,9296,5465,3109,8009,564,2542,5625, --row:186
	8739,7665,6200,9014,7758,9484,9821,9103,4882,8149,571,8972,4648,3536,8474,5801,3655,6688,2338,7719, --row:187
	9850,8164,9334,5745,1771,9030,8779,2092,8358,4298,6522,9834,4768,7912,5215,2320,7529,3808,7829,7273, --row:188
	1434,6154,6325,6226,44,5015,5535,2917,7798,7210,6447,3909,4104,6472,576,2559,8532,6486,3256,5893, --row:189
	8593,6799,2992,2205,516,2374,9773,4267,9053,2464,6201,6240,7895,1922,106,6877,7158,2737,6846,7990, --row:190
	2053,9856,166,1591,5382,5000,173,5945,7588,1954,5045,4135,1635,6919,9961,2434,4908,2945,1962,5709, --row:191
	3547,8703,4178,3851,138,7511,2716,2921,4206,5780,6509,9650,4389,2231,3452,1291,9105,3064,1368,5157, --row:192
	7575,5478,9284,7353,6435,1837,4211,6791,8612,8002,8761,303,8880,3123,8355,3731,4522,5995,8027,5805, --row:193
	2360,4839,8582,6541,1401,4151,5982,7624,6507,105,5543,3866,3532,1937,1158,8313,9047,9079,7858,1751, --row:194
	4500,4596,6247,5985,4986,343,8396,6282,7244,8869,7517,5063,1617,8380,6098,814,218,5527,8284,5347, --row:195
	2335,8963,4936,6680,875,5923,2197,34,2786,1408,9833,6431,7449,241,8657,6428,8580,5548,2865,5781, --row:196
	8850,9929,3375,8652,7368,1201,1060,3852,9646,7354,92,2669,3490,9606,2192,2189,7176,5152,868,2838, --row:197
	7190,3211,4131,6127,8320,1184,7322,530,8620,1286,1121,8731,4454,6929,9652,5119,9526,4743,3611,7947, --row:198
	960,6573,5026,2394,2885,8051,3316,7921,8537,381,3801,2987,7143,6719,9045,6196,4430,2259,5210,8499, --row:199
	9760,1343,845,6941,3158,9553,3983,6451,831,4335,3936,5896,679,1519,9822,270,4377,2636,4079,1056, --row:200
	3971,4365,3313,2525,3387,1300,7264,8535,1129,6178,841,6258,6971,6772,3120,6359,8700,3800,2239,370, --row:201
	6646,7775,3615,6126,1697,872,5267,1058,7628,447,5925,101,3495,7826,490,2943,7002,7327,3888,8426, --row:202
	6527,2104,3035,8899,3076,2157,272,4282,4931,2586,1155,16,731,2382,5471,3102,7076,9988,8941,7774, --row:203
	1537,7288,5127,3364,5974,5068,1973,2389,7768,5340,5731,1302,944,3775,5987,9177,4018,7428,4898,9892, --row:204
	6189,7983,2625,8581,9063,8546,613,8962,2670,6549,6535,696,1846,2391,9157,9896,1698,9883,3885,8080, --row:205
	7259,2100,835,8347,999,9281,6837,2272,9406,3450,1672,864,6914,7337,5508,8896,2494,1664,1009,4719, --row:206
	3999,1325,1567,7245,4444,896,3141,8709,9663,7219,1948,1439,3444,3784,1605,8430,1658,2163,1171,4312, --row:207
	4192,3187,7184,413,663,3394,3425,7660,813,1752,3610,9535,2191,9123,4611,8689,6708,8159,3875,4488, --row:208
	2154,1585,2441,4394,8702,159,3006,2148,5645,8885,7213,1246,708,1665,276,7334,4698,2856,1859,8209, --row:209
	9976,7642,3274,2883,2346,667,3777,4205,1409,7186,5687,2493,3738,6570,2642,659,7799,1768,8264,5334, --row:210
	4136,3648,4502,6911,4740,7446,3708,9095,9267,8439,5984,9551,2353,6579,9765,6829,8991,3805,1628,7867, --row:211
	5532,1878,4340,8878,5228,4077,8308,3266,9331,1690,116,5926,7712,9763,4002,6824,1966,8038,3368,7611, --row:212
	6567,2510,1625,5488,6602,8716,5021,7604,4248,3645,8818,2369,1511,9232,559,2621,6318,6198,886,7117, --row:213
	2708,9592,2841,3344,3899,26,8475,1580,8054,1348,365,1972,1441,9070,9057,8190,9874,2117,7104,2696, --row:214
	415,1965,5100,9171,4318,4783,1299,9229,6344,4451,4386,3030,9291,675,7840,6335,7590,505,5387,968, --row:215
	851,4141,7497,6840,3806,1774,2175,8412,5683,6037,3139,8351,5124,4108,5618,2305,690,8248,2918,5430, --row:216
	7680,8521,9201,1834,1530,963,7281,1208,284,1260,7157,3182,3255,4566,3128,3705,6945,6015,9035,3265, --row:217
	6927,4655,6454,1749,2321,2038,9629,8742,8138,7450,7592,4950,1319,2505,6210,7754,5537,1796,5860,5291, --row:218
	8687,8756,277,6181,6105,5813,8990,5341,5274,3009,3326,5294,4243,9539,9339,9574,8857,861,2612,7114, --row:219
	4032,5098,9683,340,8144,9937,1996,1526,3199,5831,4003,1817,9059,5148,5141,3339,115,5002,9209,1901, --row:220
	9666,4789,7538,5691,3959,193,5741,8171,5298,8061,9999,8409,7338,4397,3293,6531,3455,7640,6303,3533, --row:221
	1495,1313,5328,8937,3036,528,9990,7451,4064,830,6593,6564,1655,1641,7530,4197,3341,8507,4775,6792, --row:222
	8293,6090,5927,1337,3108,2576,3596,3991,7797,3713,947,651,114,5049,4545,2741,3257,1808,3149,149, --row:223
	4567,811,8419,323,1381,9942,9814,4830,6155,7256,1139,7587,8216,3417,363,645,4487,6293,5826,8070, --row:224
	2766,9130,7340,279,3659,1637,1977,7249,7073,8122,8431,7879,7055,8974,8435,8832,2844,7423,3853,6430, --row:225
	5698,5349,9028,3361,803,71,4633,9998,6083,7618,7536,6449,3461,6782,358,1507,9158,5234,7966,7764, --row:226
	632,5305,6471,7769,9939,7329,7884,3594,3004,4707,4678,9589,7805,7583,139,6289,2922,972,616,3166, --row:227
	9293,1885,2727,5444,1941,821,9799,5279,8781,1905,6285,2957,2655,4408,6555,5862,5573,2040,6660,2029, --row:228
	9659,8758,4250,7671,3603,8737,4952,9335,7444,6735,1333,4082,8432,5929,1791,4155,1874,7271,9352,247, --row:229
	17,5972,5891,8322,2839,3735,3074,7875,9885,1704,5034,5710,1103,9468,4231,517,8484,8844,5904,7636, --row:230
	1100,4320,961,9254,7917,9019,192,4008,7637,2068,1891,509,623,3712,5500,1481,1429,5421,6387,5739, --row:231
	1476,6960,7004,4486,8007,9365,8958,2743,6808,8240,5973,7539,3714,866,1400,5631,4774,1192,8670,9050, --row:232
	1138,3588,7095,6453,2095,9464,7051,2486,6490,2788,6977,9741,2663,4172,1047,9096,5331,3171,4576,4180, --row:233
	2316,4902,5073,7470,6464,5905,770,4369,3478,4047,6624,6420,2440,2127,8505,434,5879,8656,9651,7607, --row:234
	3774,7239,590,5365,3349,7089,3926,5499,7691,1457,334,5186,5713,3903,828,5271,4516,3087,6302,3374, --row:235
	6269,7997,9299,3530,7676,1128,316,7456,5867,5074,6174,5138,2484,9835,9451,865,3505,7957,3414,3553, --row:236
	7305,9908,8650,1213,7109,2763,8155,8053,2912,9558,3121,2644,7083,7200,3206,244,1847,202,8445,1682, --row:237
	9419,4833,4800,978,4824,710,3493,4690,1001,9278,6896,4158,2580,7435,8766,6021,426,2729,9637,7367, --row:238
	175,5497,6957,7434,3549,692,6044,6337,4757,8056,9872,9509,9255,6348,4261,916,7303,5899,3780,3657, --row:239
	8953,2649,1939,4726,6819,1556,37,3135,7767,892,577,4145,5993,893,4411,5432,3942,5888,5203,496, --row:240
	9067,4563,3298,8342,685,2554,1288,8511,7108,3822,2333,4202,6462,256,4027,9949,2615,8592,7215,7282, --row:241
	3241,5675,7633,6759,8691,9778,3059,6828,7522,5409,5605,3440,8634,8508,2894,7448,2581,3945,1845,6689, --row:242
	6908,8189,6495,1373,9034,3359,1779,7392,30,9845,9925,9369,5362,761,3309,8936,7965,6409,299,5510, --row:243
	4097,1804,8547,6980,4029,7551,4883,2257,136,9087,2781,4761,7471,674,3733,5017,7730,3703,6513,2611, --row:244
	4943,4331,5115,5103,3960,2317,4367,1236,4539,2227,624,3142,8771,7427,7544,9769,4577,5361,2049,4597, --row:245
	6589,4280,7482,1581,7103,59,9344,5546,2867,8079,8506,1886,1352,9902,7598,9749,3592,2997,7159,752, --row:246
	2043,6036,5336,73,5483,1706,23,5526,3291,8721,6951,1135,6364,9466,1898,6152,7963,9052,6205,2797, --row:247
	9849,932,5371,9332,880,2668,8918,6885,2607,4891,8063,2853,8515,6627,2589,1844,9851,9121,4515,161, --row:248
	8413,7071,3787,1448,5519,9061,4022,1148,8077,5746,8851,9478,9597,6156,5086,164,1231,742,7500,992, --row:249
	9579,5249,5560,4907,7250,6813,2501,5832,1493,7532,5343,1269,8980,3674,8236,7242,1265,2081,6958,9444, --row:250
	76,349,3680,6571,5665,8928,2028,4560,5511,3546,8423,6104,3953,213,9273,4941,3272,3384,8440,4435, --row:251
	7357,6640,9195,6213,2109,4101,6468,7495,4971,4958,8276,9415,4966,3767,4118,1371,1627,197,5313,2551, --row:252
	6671,7358,3018,7087,6895,5254,4806,4520,2665,3219,2026,4432,4937,4360,2967,2916,8961,8550,6687,1006, --row:253
	98,5090,5005,1297,6809,3350,223,8609,983,9260,3804,4420,1387,9954,350,3881,14,3639,3580,5123, --row:254
	6637,4484,9608,2384,1094,4409,9443,4460,8888,2645,7384,4184,5829,850,7508,7006,9287,6434,5632,3516, --row:255
	9208,6204,3768,6595,9865,1790,7702,8486,6810,3041,5818,8577,9398,3619,8982,4223,9220,2693,4371,225, --row:256
	5433,958,5239,8876,4303,2262,1815,1534,5787,9895,6277,2905,8062,5575,5858,9081,7669,8451,3846,1026, --row:257
	8927,6195,2754,7814,2561,8223,8903,52,635,3027,2315,5120,8361,4733,9815,4332,2857,9163,9485,2761, --row:258
	8256,1823,5075,7220,6944,6521,1926,7015,8304,4993,4465,8815,8323,4562,9249,7982,1361,1390,4911,9552, --row:259
	6928,5176,3605,4359,4114,5747,2545,4212,6613,1855,2470,4035,8389,1946,8405,3125,5514,1396,6309,9702, --row:260
	8558,5284,2444,6225,3054,178,8178,9708,85,383,176,7540,3632,3898,3435,1150,9224,6222,8567,655, --row:261
	3554,7030,6097,7383,2160,4729,4297,1356,7111,3180,1472,2123,1273,3509,9734,1298,6203,4666,1025,4654, --row:262
	4510,3246,7269,3816,5007,4744,9258,4207,2773,4489,4600,8359,9412,6440,7205,5791,2851,1474,3466,2380, --row:263
	143,843,1589,8708,1077,7278,4837,211,4055,8309,6492,8036,8194,7977,8830,9842,2694,4496,353,2186, --row:264
	4862,6233,793,1553,215,1670,300,4763,2640,8117,1851,542,94,6894,8346,6238,665,7003,8145,1745, --row:265
	7077,2206,6575,7811,7331,5323,2882,6594,312,4894,9239,3351,6880,1907,2427,1582,8548,4191,5845,9082, --row:266
	2428,5706,4684,5004,1268,2366,9716,2156,9425,941,1947,9219,7263,6424,533,6822,1021,4428,7408,9449, --row:267
	6270,684,1452,9002,2149,1889,7562,5524,5661,3937,3620,56,1964,9166,4508,6969,1107,8167,9119,6341, --row:268
	5735,7667,2752,3540,4304,4843,8604,7514,7325,1364,3259,4938,5798,7725,8192,5032,4445,7067,3897,825, --row:269
	729,4853,792,5337,789,6558,2431,1523,6371,7835,9357,6770,8295,6823,6758,5451,3932,3686,669,2097, --row:270
	1471,934,8299,4274,9823,5496,2750,4814,8579,775,5870,5413,907,5076,4216,3222,9989,2,117,8744, --row:271
	2407,587,766,4452,1255,6208,2826,100,909,9068,2818,3890,9141,5226,1959,6956,5244,5193,9194,6882, --row:272
	5686,8443,2764,4436,515,9009,6294,9346,9326,6512,2298,390,4391,948,414,5146,1017,1305,3289,2052, --row:273
	4628,7177,3084,2190,3688,9347,4086,7860,928,5150,4946,2388,6075,6587,148,4998,497,7125,1732,6169, --row:274
	6856,7991,1984,3458,5303,4542,6102,5886,2381,8762,614,504,8110,7615,1893,8717,5723,3429,410,5227, --row:275
	7924,4791,1154,4287,3075,4593,8166,1230,1477,9146,483,3236,5793,5561,6534,4613,4472,4899,5693,5604, --row:276
	8045,5595,9125,2610,7097,5080,3112,2065,3220,5913,5024,4523,5230,8795,5851,7460,9987,9727,4316,1573, --row:277
	549,1613,4668,2535,4201,4470,5270,7904,4019,3388,5592,2211,677,9970,8732,3275,930,1644,6005,1186, --row:278
	3968,398,874,1278,6506,2168,3362,96,8940,3949,9868,4619,7501,1407,2840,4559,8920,8231,47,5715, --row:279
	2890,625,6035,4011,6550,765,8458,4025,1906,8041,2155,3964,2051,4338,1295,1522,7309,6845,6217,4242, --row:280
	9532,5009,9430,2482,5551,9748,9318,9065,7939,230,1848,9202,5020,1652,6018,7033,553,5583,3068,4759, --row:281
	4132,8933,3067,1169,8513,8165,3104,2244,9775,6964,2565,3065,5544,2828,314,1027,931,3650,3503,1482, --row:282
	5481,7052,2873,1928,2147,5558,3944,6230,4777,7318,3669,5775,9187,9179,9951,5614,9840,2594,9479,8153, --row:283
	8764,3029,379,8187,5623,2880,9226,6984,2808,9473,7135,3231,8404,927,3555,4080,4357,1125,7736,269, --row:284
	5920,2776,196,6623,4006,1515,6071,9088,1238,2304,8751,6336,1131,8182,2769,1207,6676,7005,8655,2277, --row:285
	2802,2169,5743,7039,8282,1156,8868,2280,7981,210,9993,6747,4016,8855,6546,9617,6167,6138,3437,9015, --row:286
	9873,7824,6580,7321,9841,1610,9867,1679,8643,6369,1776,6548,3900,4140,9811,9503,901,1865,5089,1394, --row:287
	6346,819,9605,8753,6644,9795,2979,1841,4948,3912,7031,8004,3020,3055,3122,2902,3024,2845,7887,1961, --row:288
	8790,9620,4459,804,8926,8115,7240,8208,7687,9674,4375,567,8549,6135,5077,5695,1741,7316,8910,5159, --row:289
	1688,7622,7781,179,9699,5293,2474,8291,7037,2806,4555,1758,2755,8973,6891,7944,4144,4823,4163,80, --row:290
	6426,472,6444,7855,8388,2019,808,1797,2744,598,9692,5381,351,2529,3757,6402,1124,9524,2701,7843, --row:291
	5971,7740,3500,6737,6123,5462,4751,6411,5681,9522,607,8960,4343,1279,6703,8362,1993,418,3814,1619, --row:292
	7673,7453,78,368,7145,3475,6142,1040,4762,2235,5649,7518,1303,4213,2182,1786,8770,1967,2919,3248, --row:293
	9701,5376,8494,7792,5585,4222,8055,1612,3144,5567,7400,6215,8353,9742,817,9878,4616,2196,5125,8719, --row:294
	6783,4524,1988,1199,3501,8773,7222,3901,1914,8201,570,8128,2332,7311,4553,5312,7970,4712,1283,8450, --row:295
	3045,7979,4504,4844,7380,27,6639,2220,8463,1385,6710,5597,7962,1722,1430,3690,4509,9712,3338,5213, --row:296
	3748,3411,8343,5041,6943,5311,3661,9,3285,7494,6139,7394,2450,762,4053,1710,7690,9779,3213,2439, --row:297
	243,3591,522,2350,8654,7509,5468,4551,6365,485,2067,5610,8929,8107,5697,7703,1657,7605,6859,6390, --row:298
	9446,7531,7816,9537,6082,936,6503,9857,584,8478,4187,8539,4981,8487,2530,6591,5538,382,9127,3353, --row:299
	4200,8260,9731,9012,1157,4324,832,5494,4116,301,8735,1738,8037,683,467,141,538,6642,4134,6470, --row:300
	6525,513,2246,3969,4913,5750,7739,4915,9780,9180,9117,1724,3482,6547,6280,8964,4614,5646,7507,9198, --row:301
	5114,3162,9218,7110,9924,8653,1209,4609,5,908,3022,1353,4056,1120,4861,5252,5039,33,9074,5650, --row:302
	3894,2216,8205,7465,1140,596,949,4370,1384,1686,6141,1775,5288,6681,6301,9635,4988,3515,5804,1219, --row:303
	5443,4410,8466,4422,1440,9997,4896,4753,4425,5273,5769,7543,7724,2479,7389,8378,9385,4480,1813,7893, --row:304
	3460,3330,902,4630,9623,6122,9262,6784,9309,890,9283,5307,6510,5857,3623,6352,9710,7098,8913,5290, --row:305
	3472,8493,5149,2445,7688,772,744,9818,8184,8363,3723,3987,3401,1604,7468,5664,7106,2672,2193,6438, --row:306
	4084,2497,6849,1857,5663,1338,2478,917,4785,3296,5188,5354,389,7113,9004,1126,7224,1737,8161,7627, --row:307
	2134,7547,7931,3820,6542,8414,4161,5914,304,950,5990,7888,8690,1349,3497,4437,6442,7211,7842,2887, --row:308
	5622,5082,2313,6023,9894,2630,3335,5992,695,4362,8745,8659,4319,1880,6131,4595,3385,1992,5797,1196, --row:309
	9688,35,7555,3244,6338,2950,6239,3113,1895,3464,7524,4095,6978,8257,2334,503,2527,8442,8490,441, --row:310
	7749,302,3858,945,9104,1814,4970,4528,6133,9676,5668,8557,2481,2707,1427,7419,5776,7141,7343,2373, --row:311
	5809,5418,2355,2423,1566,7035,6987,5947,5066,4569,7351,6175,3772,6754,6989,4042,3307,8290,9960,4275, --row:312
	5317,4701,6662,1656,9429,2219,5427,2292,4352,6362,5001,9602,8570,5053,7179,6734,2911,160,723,3431, --row:313
	9252,2760,7502,2908,5232,1680,3430,2855,3642,7399,4799,5064,3269,63,9167,5800,4924,7759,3574,5878, --row:314
	8357,1073,4007,2342,7955,8436,9982,9010,8778,7920,3892,4301,8180,5617,3675,1487,8596,1277,1468,8796, --row:315
	3906,7197,3442,3369,5222,6794,4957,2411,6740,7120,9517,2476,6020,5255,360,83,9965,5598,6236,755, --row:316
	7897,8317,1755,1831,9400,4886,2173,3519,8635,1603,5424,1942,8058,6598,9055,5811,5352,6907,1561,1323, --row:317
	5868,1590,2371,8314,5889,1968,8220,2395,1016,7295,6060,2421,4815,4570,1438,9327,3525,5461,586,3043, --row:318
	4334,8860,7973,9324,9570,5431,7261,7387,3023,7442,6568,8488,3872,6049,6093,5308,7296,4385,8222,8645, --row:319
	4111,2195,6358,1183,121,2871,4272,6690,450,6400,1588,257,1699,7447,8531,2058,1554,307,7732,5276, --row:320
	7750,9007,6766,3684,5036,9882,7371,9090,8337,9995,3685,7675,8420,4612,8587,2909,8828,4644,6065,2603, --row:321
	9527,7314,7964,2710,672,7908,400,2666,5624,4610,9073,3809,8098,4277,9098,7373,858,7189,3966,1919, --row:322
	2671,5134,2243,9744,6976,6585,5112,3824,940,9048,2953,1763,8033,6583,4828,7821,7643,5345,1593,670, --row:323
	3355,781,2311,8701,8551,1012,6732,3788,6355,620,3428,6611,7151,8931,431,4153,4469,1315,6946,9525, --row:324
	4821,7418,2430,8127,8978,1312,926,6025,9133,7361,6045,738,5280,6833,1342,8971,6949,3537,2039,3667, --row:325
	7975,6209,6202,8955,2736,8446,1365,8421,1098,6380,2226,3491,1423,4478,6392,8665,611,592,8519,6670, --row:326
	2228,782,6878,8569,5325,7812,4061,8085,7198,9361,5873,4657,7729,1310,6429,4804,3918,3671,6421,3327, --row:327
	578,1002,3649,2061,4784,8156,4817,5299,4138,1794,1685,9395,5277,728,5172,3484,7255,4034,1133,5773, --row:328
	260,7910,601,3168,2070,8894,1180,2448,5402,3329,9992,7356,2159,2376,7563,3357,6626,5788,201,119, --row:329
	3232,7301,555,3904,6153,5240,7734,131,5630,5999,2711,6491,3202,7987,2842,618,1032,3397,9681,3728, --row:330
	8566,615,6709,9029,8030,3258,899,9682,3643,6374,1772,4085,3079,6764,4512,7396,9454,2096,250,2595, --row:331
	4872,3689,671,6404,9236,2678,4709,7874,5410,6684,3185,8834,3214,3604,4580,1015,8509,6665,760,3563, --row:332
	6377,9269,2036,1284,5442,6186,9791,9091,8588,529,3092,7182,7300,1793,8330,9472,8350,6596,7794,9781, --row:333
	6243,9474,6022,2870,4780,9923,5287,3203,2579,4588,5084,355,8367,5876,8504,6046,5757,6805,1503,8397, --row:334
	2252,7755,8696,6366,4533,9861,7731,6785,795,8227,2105,2088,6693,2161,1479,649,652,1760,1331,9554, --row:335
	7845,2558,5434,7115,1176,1233,1383,3481,5250,5806,1572,4863,1770,2208,5155,8338,1819,8253,9529,1332, --row:336
	3406,962,1428,2229,5574,5506,800,3628,6193,1563,427,394,8629,2359,4127,5490,6047,7571,2598,7881, --row:337
	842,9926,3217,3153,4637,275,1608,8510,1888,721,3234,8669,6006,4468,5936,2560,5167,5449,2031,9242, --row:338
	7057,7360,6450,1264,3997,5641,9388,311,9576,4798,289,5717,7167,9557,5185,2877,2981,6767,4640,751, --row:339
	4792,8074,7086,631,409,1065,4558,7000,6100,4845,5128,1359,6518,2504,6029,3521,4728,3433,8218,4697, --row:340
	3646,8679,8150,5590,906,7558,2453,6630,8846,2662,5533,724,3504,6157,40,478,7132,9584,6108,4259, --row:341
	3581,7266,7390,9611,142,1271,5979,856,2872,3629,7801,2528,2641,6909,251,3789,6188,2692,3778,324, --row:342
	3529,499,8225,6599,778,1921,259,3958,7655,3215,6657,293,8845,9286,8826,6621,9754,3005,9011,7265, --row:343
	4782,2824,4929,5673,1667,5491,9934,7344,4607,3877,5209,3467,608,7726,7345,9912,145,8301,3570,5770, --row:344
	4453,2281,9263,6741,9721,1363,6774,7942,8501,5563,1504,7707,6410,2929,4265,1502,7526,8383,2438,4461, --row:345
	3033,8873,786,356,5850,9470,216,9598,7230,990,579,4903,9986,5765,6713,6086,9363,2114,1876,8364, --row:346
	2111,1174,280,1609,4942,7061,6695,152,6796,2723,9628,9237,8948,6666,2264,913,3986,8123,1740,9080, --row:347
	2011,1243,144,5771,7796,5660,9093,4949,8727,5751,9548,8842,5351,2522,2691,5117,397,1404,7195,6191, --row:348
	1708,7608,740,1671,1807,3736,3031,1953,6242,5586,6536,2936,3261,2591,1185,9333,1753,4050,8544,7172, --row:349
	2126,6103,9128,7566,7757,1833,4921,9240,9770,8048,4852,5827,6997,6394,952,3110,3131,5241,9564,5019, --row:350
	339,1882,7560,7116,5812,5902,9789,8333,8121,3975,2653,9145,7352,805,3445,6456,5218,7441,7527,5192, --row:351
	6903,1329,1392,3681,6565,4544,9876,820,5423,3510,7872,980,2500,877,4778,3573,9944,7711,2006,6407, --row:352
	8249,5374,8738,1082,2523,8462,3218,6297,7684,1639,8177,7403,3612,1198,9806,6072,2609,5835,6118,3383, --row:353
	4649,3283,3520,5320,9696,3732,5981,9591,1369,9036,8883,8234,8871,836,3096,9396,6701,5081,6744,8525, --row:354
	7386,290,5105,6678,2004,6529,2770,4004,2136,1856,4692,4164,8759,9658,8497,6310,7287,715,2862,6228, --row:355
	8872,6922,494,693,9322,3223,6345,428,6443,2106,8151,4574,5555,189,8800,1912,2347,4344,8573,2046, --row:356
	9836,9354,8025,4870,774,7819,633,1811,8533,1714,9303,8467,7504,8915,6432,3796,847,5067,9384,9358, --row:357
	1870,7207,1346,7118,8602,691,5894,6902,8348,1334,1326,2600,4517,5429,471,6482,9323,5952,3970,6820, --row:358
	7900,1931,2288,69,2323,2348,9516,6861,1990,2112,798,8838,1296,6489,4353,8382,5059,7557,4606,1144, --row:359
	2165,7554,4738,3761,336,8243,4289,2089,5778,1505,6990,9568,4355,794,6661,1782,3280,321,2712,273, --row:360
	3998,2399,4233,976,5292,2718,2179,10,5522,7985,2960,9709,7484,6789,4538,2732,4442,7464,6887,6106, --row:361
	3633,6965,4964,5042,7878,1447,4939,5040,6650,7319,5482,285,2546,5822,9480,600,1038,8621,1215,89, --row:362
	3538,6308,4676,502,4772,7395,7836,1717,8606,7994,4994,439,3617,626,2616,6161,1239,5542,8625,5054, --row:363
	3322,3577,5700,4426,3552,3842,1809,8,6311,1109,4481,4836,6099,7534,9604,8631,6194,3905,9848,9713, --row:364
	6206,829,5581,2553,8092,9375,4407,4183,2526,7940,2556,3358,2514,525,7960,8453,2078,8601,9154,3308, --row:365
	4463,9298,7715,1730,8114,8183,7374,3860,7283,9830,6180,9500,3607,2674,4058,6436,6084,433,583,7802, --row:366
	8287,346,8938,3697,9919,8060,4822,3251,6339,5251,5364,9938,3948,2319,3590,6635,7060,4256,730,4103, --row:367
	8476,9246,1175,8245,3145,4190,5606,5061,1145,9193,955,2457,7275,8390,8198,2133,3873,6716,5160,7221, --row:368
	6581,3498,3240,3724,9274,3303,209,1127,2502,3874,8272,9380,3415,6883,7169,2637,6953,6268,6148,1097, --row:369
	7313,2534,923,124,3048,3887,4052,9107,1022,150,8750,6697,7941,4955,2383,1873,8886,8812,2406,3286, --row:370
	1739,1974,5131,4995,1242,1571,9890,361,8052,6329,4398,3764,2202,1659,5963,9078,7402,137,2843,935, --row:371
	3295,9022,9662,2013,4271,5473,2218,7556,1372,5006,5183,2094,8262,7644,995,8193,2489,1167,5703,1785, --row:372
	1344,4747,9521,4262,6765,7927,5626,1304,9580,4754,763,8945,8835,8705,9906,5836,1292,9859,666,7388, --row:373
	4531,4905,2536,7070,7679,1527,5166,8049,8089,1388,8273,5957,4704,5507,6633,452,818,8627,7599,5322, --row:374
	5194,2657,810,6134,5968,4387,2080,1510,4879,3566,9817,1997,1860,2435,2422,2848,9438,9735,424,2054, --row:375
	7748,7162,8219,8042,457,3151,6416,7619,1425,9724,859,2047,1087,2005,3882,2467,7710,9490,7192,7272, --row:376
	8268,1678,461,6481,9046,937,2557,1263,5638,6114,6870,2618,90,1747,3844,5246,4867,294,8199,3524, --row:377
	4048,7218,2940,9761,9020,954,8870,454,4771,3564,7492,3704,4493,1999,1161,4269,180,531,5260,1480, --row:378
	5871,6614,8663,3284,9001,4501,2977,1270,4356,4326,8678,637,7718,986,7429,9377,2915,373,9690,463, --row:379
	6942,8179,8523,7043,9371,3454,8898,2990,5368,8210,2364,6643,8571,8417,4796,545,1261,4650,4564,8226, --row:380
	747,7293,5187,9351,6172,2101,1416,1442,3992,9695,4835,4534,9044,403,8752,5412,7694,4565,807,4721, --row:381
	6010,374,8345,2124,1335,4169,7880,5856,2563,1206,9337,9271,4023,4977,7956,9192,3863,8892,7946,2982, --row:382
	7915,8280,5786,6706,1557,1380,8024,4315,8560,844,185,6187,6618,29,7930,6886,3290,2426,2934,3963, --row:383
	8239,9827,3638,4790,2345,3410,5404,6590,6604,5593,7233,5615,5135,2687,4474,8473,2291,1115,3489,2866, --row:384
	1558,7424,9256,6519,9877,7585,1952,4119,5262,4869,5191,5898,4490,4232,6415,6284,883,9614,3366,6649, --row:385
	2449,443,4244,7421,5487,3263,1529,6077,2098,2003,4848,3751,3868,9594,6259,7355,1113,9755,7567,3175, --row:386
	5760,9197,1449,8787,1132,3621,8512,9505,2199,5282,5690,7649,9655,3513,77,3378,233,8491,3371,501, --row:387
	2418,8043,8526,1225,4110,7152,7122,2569,5881,7170,791,3752,7870,4345,1674,4756,9794,1978,9644,722, --row:388
	8428,8267,1042,9743,6631,8162,8006,854,9730,8065,6879,4875,6814,5415,1377,1805,8022,5417,1281,5919, --row:389
	4252,2746,2276,6653,1456,5339,332,9279,2057,7445,6847,914,824,2517,4033,3972,3551,5403,6136,7260, --row:390
	2613,140,3025,9936,771,7935,2007,4874,5855,9616,5372,4146,9959,3315,4841,8275,9215,1340,9569,5900, --row:391
	2605,8116,1924,7426,2465,3652,8228,4133,9175,5321,2230,46,1854,5562,1594,5819,6634,9675,9945,9512, --row:392
	5589,2176,4954,6683,7952,1280,2008,4286,2365,3243,8271,2167,1105,5286,9251,317,5367,4309,6328,8135, --row:393
	249,7623,6125,7366,3641,6917,9378,9185,9581,262,2742,3396,8911,7379,8522,8798,3413,3840,6376,9871, --row:394
	739,2303,7270,8307,22,4694,3277,9847,1089,6465,5439,2675,3766,4917,5694,239,3961,4374,5383,7901, --row:395
	1862,7412,4812,7681,933,6143,5853,1163,4479,1466,352,5944,2794,7023,7225,6300,3300,3593,151,6537, --row:396
	9102,3167,6979,5946,8859,7042,6560,7084,1179,5466,3333,5072,656,2023,9393,3053,3957,1119,3965,3925, --row:397
	7016,1173,5237,4653,2617,1827,6667,6656,5932,2740,9135,7488,128,1702,2547,61,8111,2020,4330,3833, --row:398
	3098,6343,1981,2780,7127,6331,969,6830,2203,6981,1513,6255,7405,2681,8646,4455,5712,5579,8318,3161, --row:399
	3421,8534,3381,1564,8776,2986,8617,9131,6628,1274,1275,9244,7864,3116,8540,7513,8694,3698,1360,6403, --row:400
	660,5214,7498,1545,3204,2606,3606,9869,7062,1538,5393,8104,4294,5596,7898,5931,7708,6427,6368,2596, --row:401
	2695,5197,2626,3239,6322,6663,3729,1719,9825,2221,3201,7155,8057,1052,8734,1920,7943,6992,5885,6110, --row:402
	1810,8492,2792,2886,4189,2370,6717,2042,9366,8203,5872,8697,6950,5104,3753,5460,8728,2592,7487,5569, --row:403
	2759,3390,5108,6836,4923,9838,5269,2998,5044,7214,6261,6067,4462,6132,1881,49,9843,10000,7610,2562, --row:404
	6173,7217,1354,2417,3208,3933,1227,3794,1675,3008,3826,4307,6017,9810,743,2539,4279,3395,1858,2704, --row:405
	9879,3744,694,4651,5861,2516,8637,6381,9732,4314,1731,7008,8568,6852,8354,5324,4583,7520,7847,603, --row:406
	8600,380,6383,4748,1496,6750,5204,2452,8746,1799,1053,6781,3462,5498,6654,9538,6395,3367,6608,2146, --row:407
	392,6993,438,1868,4890,8197,8251,9671,5256,1514,5202,2511,7044,7085,9417,9172,6752,3692,338,3665, --row:408
	6216,7839,2904,2849,1930,4102,5503,602,6007,4992,7807,3865,8460,9268,2567,2639,6959,7595,3017,4794, --row:409
	4741,5132,8649,7579,1884,8626,19,4396,8005,7072,464,8956,6463,357,6367,8503,8969,3314,2131,6111, --row:410
	6939,9587,3216,6237,3627,2819,5406,6725,9494,4349,4485,1636,5756,6620,432,3993,8877,378,6211,2515, --row:411
	9432,6002,1611,3050,6610,8252,4816,2015,718,1320,2260,4089,7476,4156,2152,6162,5217,5386,9424,9373, --row:412
	519,2947,1744,6850,4909,558,7803,7949,904,4107,9928,2251,6686,8327,9241,473,3325,8623,7178,3544, --row:413
	5572,4876,4497,754,2201,4573,2488,6972,7341,7753,1262,2568,4258,6888,1979,4568,7478,7925,2861,9955, --row:414
	2676,7553,6493,9315,7001,3405,4005,8861,5414,6168,2847,8676,3247,6812,1654,4361,1182,6668,6788,5976, --row:415
	9367,982,2310,9486,8039,7682,8448,8695,7312,9693,8495,2968,9023,8829,1908,6854,7634,7825,6561,3003, --row:416
	9831,5010,9704,3559,4922,8001,3845,745,7510,3044,8890,9304,1473,8292,437,4667,9762,8565,5887,6863, --row:417
	6249,2646,9190,8791,6721,7209,3793,9638,9253,1725,2533,5636,5938,129,9437,4682,5759,181,4679,9368, --row:418
	2454,3812,2236,589,1535,2072,8242,9342,9312,9648,3356,8528,8464,8073,6802,4117,3409,2726,4758,547, --row:419
	2588,2548,475,8095,9593,6874,9064,2393,396,3719,8349,806,855,8376,419,1539,3260,3061,1414,3710, --row:420
	5457,6385,4779,8232,4325,5184,1551,3950,9170,9544,9550,9559,3776,5553,9887,9940,9221,7638,4803,8584, --row:421
	5357,283,7549,3550,6314,6718,8238,5854,897,8912,8884,318,7596,2455,9462,1595,6396,1903,1399,7569, --row:422
	5162,5355,839,6267,6287,2622,6379,4511,8822,4447,4605,6327,7080,2690,7065,7564,2033,7053,4195,676, --row:423
	4109,5734,9025,7246,6,6088,5940,8356,4699,7693,1792,498,7165,7056,3013,8518,887,4094,8078,3226, --row:424
	8296,6295,4204,6445,3448,1216,5008,5892,1137,8614,9345,8500,3589,7954,7324,5779,7882,7651,2492,9496, --row:425
	7437,9921,6276,5012,4210,1951,5672,5628,668,6467,4477,9899,5233,444,8743,468,9523,6332,155,3586, --row:426
	3946,7978,7766,4431,2424,9152,2800,3598,1574,9922,4664,7631,1531,8374,8589,7580,5602,7194,5767,6011, --row:427
	7545,4739,6973,1081,3869,582,9106,3831,8524,9032,204,1866,65,1256,9199,130,2577,9864,524,2566, --row:428
	9595,4346,4530,1525,1673,1043,1983,4918,8044,8968,3672,9933,6012,4476,183,5122,7134,773,7948,7686, --row:429
	9458,8402,4208,6278,8235,177,3089,5844,6700,989,2975,5515,4851,3654,9786,2823,6349,7308,965,4663, --row:430
	4170,8553,5782,5306,7439,4245,2351,9578,245,3750,4112,5924,9718,9328,9387,7306,1398,1761,12,9423, --row:431
	9307,1692,688,1681,4234,8810,9863,8618,1101,5917,2507,3940,1328,1160,8281,9302,2120,1301,7171,3083, --row:432
	1095,9981,534,3457,2267,8457,8449,8889,3883,7139,2775,5547,1431,5814,3614,3828,719,1729,3224,985, --row:433
	3337,224,9530,1826,2963,3091,4299,1068,5634,2995,7234,2341,1883,9984,3709,1536,2543,1165,8807,3747, --row:434
	1648,9120,9288,9138,776,6223,319,2751,7809,7129,9920,4182,9839,2143,9069,1842,8369,3294,8344,2972, --row:435
	4552,1362,5069,6858,8536,1777,1769,7148,2585,704,7489,8434,1735,2498,7491,967,4288,9753,2575,4621, --row:436
	3565,4602,2820,3856,5314,8543,8997,8059,3107,5608,5948,2250,6645,7068,3040,8247,4540,3281,8168,4381, --row:437
	8366,1871,4880,9013,1879,278,5922,1108,4198,7443,1923,946,1499,11,1426,8925,9645,956,4372,3228, --row:438
	4130,1521,1938,8305,1689,5820,8103,3438,174,6994,1783,3225,1788,3066,8137,4838,6176,8706,6582,9844, --row:439
	7626,1041,7185,487,8211,2018,50,871,5930,7918,9996,7937,9673,9733,4529,7206,1478,6296,648,9427, --row:440
	4054,7330,1257,3967,6315,7105,8954,8181,2460,8858,2091,2734,8170,8616,2268,7542,7382,8452,6790,9603, --row:441
	3039,298,8212,1576,4716,5196,7791,5422,436,4230,1436,5536,7251,9340,6119,1985,4323,8930,1187,2400, --row:442
	953,706,6516,7420,2784,8016,406,2509,3483,5316,1577,4024,3118,662,6263,3427,5164,9625,8112,337, --row:443
	4734,8900,7231,894,5802,2939,749,31,6815,7906,7662,9985,5056,6347,9953,4125,8326,7248,1586,8188, --row:444
	3332,8433,4865,2113,3496,7147,2344,6057,489,1801,2831,3847,8081,9116,3190,8459,9021,2396,1084,1258, --row:445
	1917,263,5083,460,3056,5937,2702,2924,9788,3343,5346,796,6298,6556,9596,6260,9277,3176,2301,8611, --row:446
	537,7349,440,3660,2564,3143,2948,7333,4209,6528,5110,5370,3106,8814,1715,2325,4446,9670,556,3081, --row:447
	4897,242,4405,5874,9586,4999,9008,4873,8020,1887,2010,235,2549,3823,3188,4142,1054,4965,3453,4959, --row:448
	1642,4629,5653,9767,3631,6066,4645,9783,2330,2614,3292,6266,3424,4714,9310,372,6441,2164,2715,5591, --row:449
	6508,4781,705,1629,6412,70,7697,5688,5348,2864,1289,7617,9752,1410,1013,2832,7832,1251,2077,5890, --row:450
	2805,7336,3825,7025,5969,5753,198,5353,5772,2429,3177,9111,8782,6016,9493,3090,1562,9511,4513,6606, --row:451
	5738,9094,569,2602,1415,6488,4745,3088,2956,8008,6751,3198,4673,8158,681,261,7932,9189,4393,7175, --row:452
	5048,9370,3835,3101,6423,910,7126,1803,746,2073,2632,3978,3854,5236,5330,3105,9101,8129,1309,2985, --row:453
	4266,3817,6674,1237,7317,6164,1492,2258,2799,7789,1727,7907,4737,8031,5501,1085,417,4585,2021,9431, --row:454
	8263,6192,4926,5189,5181,753,1130,5821,8998,3034,5332,9757,5047,6853,9913,6095,2480,2638,640,7156, --row:455
	295,1076,8269,9482,1828,9797,1976,5733,8206,7779,2946,4492,7267,480,6160,2893,9809,1419,9531,8684, --row:456
	7315,1159,1488,1287,6658,4414,9407,1721,4705,5106,5903,8108,3347,4686,8325,1250,3670,4636,7079,237, --row:457
	8416,924,6867,2261,4384,3192,9442,1902,1020,6094,863,5454,9364,3268,6124,1533,5137,5190,2700,9678, --row:458
	3730,5978,9562,6497,2738,8229,232,9826,5022,9212,1832,5342,8893,3557,9657,1957,736,4548,8970,8134, --row:459
	2930,8724,8651,2749,1443,9677,7469,8200,4749,2151,5721,2086,1454,8100,8399,9931,7574,3919,9612,895, --row:460
	4671,9245,3352,6584,8774,9502,5046,5359,9392,5168,3795,8341,28,4339,2188,4866,7473,7480,3832,939, --row:461
	621,1195,2926,8096,4188,1336,182,889,6413,870,7432,1645,2809,4424,2283,4984,9717,4012,7,6899, --row:462
	1802,1975,5143,1064,2408,5301,8101,7674,6354,891,7813,1668,1852,8441,9476,7868,1949,5195,4858,1900, --row:463
	6184,6326,3989,9870,107,3318,4910,9707,8633,402,3913,6089,2293,8336,4069,5378,1266,1435,1010,1987, --row:464
	8628,7806,5231,421,4171,6048,7890,8066,8139,3934,3320,2443,4967,4009,6873,3880,8952,1864,9880,3597, --row:465
	1691,769,8981,7621,2846,511,7064,4641,157,8849,6699,1074,9149,2541,6009,3288,1746,1701,7971,8662, --row:466
	701,4030,2682,9820,2286,5669,153,629,617,6826,1307,2002,6299,8820,3910,1718,8411,4846,7063,1600, --row:467
	3558,838,7629,5768,9966,4947,2184,3148,4601,1324,8527,18,309,636,5849,888,9613,6875,2706,5003, --row:468
	3931,93,4036,4066,4059,5520,2815,5909,3000,3057,265,5435,8373,306,2958,3734,826,3181,3694,425, --row:469
	3441,4801,5666,4228,4483,8091,1197,9904,2964,5677,7393,1322,8542,4691,4129,7770,6539,347,536,2513, --row:470
	1709,6291,2532,7017,2129,219,9747,4174,7123,9790,2392,5171,1367,1599,5502,60,8668,9798,8408,5998, --row:471
	6871,3446,7238,5398,1035,5391,4229,5211,6234,1945,7436,521,957,2879,5764,5235,1707,3304,5960,911, --row:472
	5458,3365,1643,1970,9668,2209,8207,9723,6515,6936,5101,6869,3782,8034,3601,3310,2436,8607,9207,4418, --row:473
	3099,4044,7844,3630,3834,212,7777,8224,6199,422,9475,7046,2955,4062,514,3839,1465,3634,7936,6779, --row:474
	200,5052,4776,8803,5070,4121,3312,4656,3528,3297,6478,527,5912,5416,9164,8788,9964,3676,6743,622, --row:475
	9812,7773,508,8315,5777,8677,5107,6101,62,1462,3754,3857,2686,2942,154,4358,3254,1592,6900,8300, --row:476
	6389,2063,9792,3379,9143,8172,127,1306,8068,6475,5964,4944,5513,7752,4120,1136,9234,7630,4702,7455, --row:477
	5407,4147,1875,4363,3095,833,4364,2859,565,1004,4162,5884,5556,6748,6197,2075,2860,6545,3474,8015, --row:478
	6501,3016,3279,6511,2834,9056,6932,8097,9918,6137,1956,5315,7664,3755,6001,2354,7014,2300,2679,7953, --row:479
	1748,5377,1867,1210,1188,6892,5676,6043,412,6523,7614,184,3803,4572,4026,5050,2949,1282,4196,2409, --row:480
	9764,5369,8427,518,8710,5763,342,7372,6868,970,9083,1375,2550,4978,7048,9519,3962,4043,5338,1235, --row:481
	4373,1061,9115,3311,3130,682,5265,6811,4348,6466,3696,9060,9547,3721,3336,4434,6913,9261,9037,1437, --row:482
	1602,9039,4689,1660,9533,6600,1122,4983,2137,7833,8132,7647,8921,6058,6245,8265,5219,1062,3626,7422, --row:483
	3920,714,809,6726,1374,7692,2913,6923,7124,5437,9507,7559,7903,6696,9499,6787,4901,1623,9684,1444, --row:484
	5436,5245,1651,8090,7438,6851,5169,5729,6777,3235,6786,5566,6179,9467,1111,7541,8163,8692,4594,6675, --row:485
	959,6074,9169,9390,2180,9768,8854,2812,8233,8666,2122,8087,9301,2372,9453,784,9174,9033,8786,3760, --row:486
	5997,1929,6457,3416,6054,9886,7733,8693,3305,1798,449,6271,8377,9420,4225,6246,1093,4710,921,8195, --row:487
	6543,9399,5848,1034,3896,4123,375,5396,1494,661,3583,9139,4041,9756,8278,4416,6163,4214,3049,2144, --row:488
	6323,689,1733,7698,9956,6307,3727,9540,320,4591,6955,9435,2969,3990,5208,8792,3819,7788,3127,13, --row:489
	8403,9624,7481,1432,6231,4940,4150,8688,9349,4627,9837,1486,4724,6985,8470,5949,3042,1910,7863,1677, --row:490
	2414,5684,5486,7760,3010,2200,1463,4808,4810,2296,7131,7212,4717,4415,7474,1014,7852,3955,1276,2721, --row:491
	6723,686,8562,4413,7166,2285,1569,8590,8298,4599,2935,6632,3829,24,1971,7012,2079,6746,8749,1433, --row:492
	8793,8775,3687,6229,9967,500,8660,2661,6227,650,7582,8630,6304,2326,8401,4168,7228,5959,4467,9124, --row:493
	7348,3423,5578,123,4333,1587,2503,451,8133,310,3561,2647,2803,5259,6033,3069,5570,764,6557,6408, --row:494
	7093,2745,4765,9691,7713,1202,4203,6638,9374,7528,5875,2652,2415,3471,604,4727,1086,5852,6679,7101, --row:495
	8897,3921,7235,7364,6353,3518,5126,7050,3891,7861,1694,7467,7741,1382,4584,4439,86,5238,5808,996, --row:496
	411,254,8641,6393,4695,4722,3134,2725,1036,7090,5476,4404,6999,3981,1149,7951,1166,2980,678,3456, --row:497
	610,7350,3026,3184,5951,9075,5094,6893,6730,862,4951,5144,1829,8680,4221,7409,3706,6000,756,1177, --row:498
	3560,5447,4532,2339,2336,7130,6838,6032,1620,9110,5754,6145,9667,2256,5484,4797,1311,6607,9893,4933, --row:499
	9738,9656,4912,9434,5702,2907,4427,7683,6728,2217,8840,5095,8950,4718,8867,5205,7138,7929,4255,3818, --row:500
}

--geyachao: 内网允许创建3个存档，8倍速度跑游戏，开同步日志
if (IAPServerIP == "192.168.1.30") then --内网
	hVar.OPTIONS.MAX_PLAYER_NUM = 3 --最大可创建角色数
	hVar.OPTIONS.MAX_GAME_SPEED = 8 --游戏最大加速倍率
	hVar.IS_SYNC_LOG = 0 --显示同步日志 --大菠萝，不显示同步日志
	hVar.IS_ASYNC_LOG = 0 --不显示非同步日志
	hVar.IS_CLIENT_NET_UI = 0 --geyachao: 是否显示客户端网络状态界面（本地显示等待服务器响应、追帧中，等等冒泡文字）
end

--print("var 读取完毕！")
--服务器配置是否显示充值功能（服务器下发）
hVar.SHOW_PURCHASE_HOST = 1

--客户端配置是否显示充值功能（晚8点-早6点开放）
hVar.SHOW_PURCHASE_CLIENT = 1

--充值礼包相关存储数据
hVar.PurchaseGiftRelatedInfo = {
	[1] = {
		nGiftIndex = 3,
		nGiftBuilding = 11031,
		nAddEffect = 3180,
	}

}

--geyachao: 客户端采用的时区
hVar.SYS_TIME_ZONE = 8 --北京时间

--定义图片
hVar.TacticsDescribeIcon = {
	["missles"] = "misc/tactics/tac01.png",
	["time"] = "misc/tactics/tac02.png",
	["gun"] = "misc/tactics/tac03.png",
	["shield"] = "misc/tactics/tac04.png",
	["hp"] = "misc/tactics/tac05.png",
	["range"] = "misc/tactics/tac06.png",
	["bounce"] = "misc/tactics/tac07.png",
	["fireline"] = "misc/tactics/tac08.png",
	["ball"] = "misc/tactics/tac09.png",
	["hole"] = "misc/tactics/tac10.png",
	["wave"] = "misc/tactics/tac11.png",
	["fire"] = "misc/tactics/tac12.png",
	["ddta"] = "misc/tactics/tac13.png",
	["dmg"] = "misc/tactics/tac14.png",
}

--定义升级数据
hVar.TacticsUpgradeInfo = {
	[5001] = {
		--[1] = {},
		[2] = {{"missles","+1"},},
		[3] = {{"missles","+2"},},
		[4] = {{"dmg","+1%"},},
		[5] = {{"missles","+3"},},
		[6] = {{"missles","+4"},},
		[7] = {{"dmg","+2%"},},
		[8] = {{"missles","+5"},},
		[9] = {{"missles","+6"},},
		[10] = {{"dmg","+3%"},},
		[11] = {{"missles","+7"},},
		[12] = {{"missles","+8"},},
		[13] = {{"dmg","+4%"},},
		[14] = {{"missles","+9"},},
		[15] = {{"missles","+10"},},
		[16] = {{"dmg","+5%"},},
		[17] = {{"missles","+11"},},
		[18] = {{"missles","+12"},},
		[19] = {{"dmg","+6%"},},
		[20] = {{"missles","+13"},},
		[21] = {{"missles","+14"},},
		[22] = {{"dmg","+7%"},},
		[23] = {{"missles","+15"},},
		[24] = {{"missles","+16"},},
		[25] = {{"dmg","+8%"},},
		[26] = {{"missles","+17"},},
		[27] = {{"missles","+18"},},
		[28] = {{"dmg","+9%"},},
		[29] = {{"missles","+19"},},
		[30] = {{"missles","+20"},},
	},
	[5002] = {
		[2] = {{"dmg","+10%"},},
		[3] = {{"time","+5%"},},
		[4] = {{"dmg","+20%"},},
		[5] = {{"time","+10%"},},
		[6] = {{"dmg","+30%"},},
		[7] = {{"time","+15%"},},
		[8] = {{"dmg","+40%"},},
		[9] = {{"time","+20%"},},
		[10] = {{"dmg","+50%"},},
		[11] = {{"gun","+1"},},
		[12] = {{"dmg","+10%"},},
		[13] = {{"time","+25%"},},
		[14] = {{"dmg","+20%"},},
		[15] = {{"time","+30%"},},
		[16] = {{"dmg","+30%"},},
		[17] = {{"time","+35%"},},
		[18] = {{"dmg","+40%"},},
		[19] = {{"time","+40%"},},
		[20] = {{"dmg","+50%"},},
		[21] = {{"gun","+2"},},
		[22] = {{"dmg","+10%"},},
		[23] = {{"time","+45%"},},
		[24] = {{"dmg","+20%"},},
		[25] = {{"time","+50%"},},
		[26] = {{"dmg","+30%"},},
		[27] = {{"time","+55%"},},
		[28] = {{"dmg","+40%"},},
		[29] = {{"time","+60%"},},
		[30] = {{"dmg","+50%"},},
	},
	[5003] = {
		[2] = {{"time","+7%"},},
		[3] = {{"time","+14%"},},
		[4] = {{"time","+21%"},},
		[5] = {{"time","+28%"},},
		[6] = {{"time","+35%"},},
		[7] = {{"time","+42%"},},
		[8] = {{"time","+49%"},},
		[9] = {{"time","+56%"},},
		[10] = {{"time","+63%"},},
		[11] = {{"time","+70%"},},
		[12] = {{"time","+77%"},},
		[13] = {{"time","+84%"},},
		[14] = {{"time","+91%"},},
		[15] = {{"time","+98%"},},
		[16] = {{"time","+105%"},},
		[17] = {{"time","+112%"},},
		[18] = {{"time","+119%"},},
		[19] = {{"time","+126%"},},
		[20] = {{"time","+133%"},},
		[21] = {{"time","+140%"},},
		[22] = {{"time","+147%"},},
		[23] = {{"time","+154%"},},
		[24] = {{"time","+161%"},},
		[25] = {{"time","+168%"},},
		[26] = {{"time","+175%"},},
		[27] = {{"time","+182%"},},
		[28] = {{"time","+189%"},},
		[29] = {{"time","+196%"},},
		[30] = {{"time","+203%"},},
	},
	[5004] = {
		[2] = {{"fire","+1"},},
		[3] = {{"dmg","+10%"},},
		[4] = {{"fire","+2"},},
		[5] = {{"dmg","+20%"},},
		[6] = {{"fire","+3"},},
		[7] = {{"dmg","+30%"},},
		[8] = {{"fire","+4"},},
		[9] = {{"dmg","+40%"},},
		[10] = {{"fire","+5"},},
		[11] = {{"dmg","+50%"},},
		[12] = {{"fire","+6"},},
		[13] = {{"dmg","+60%"},},
		[14] = {{"fire","+7"},},
		[15] = {{"dmg","+70%"},},
		[16] = {{"fire","+8"},},
		[17] = {{"dmg","+80%"},},
		[18] = {{"fire","+9"},},
		[19] = {{"dmg","+90%"},},
		[20] = {{"fire","+10"},},
		[21] = {{"dmg","+100%"},},
		[22] = {{"fire","+11"},},
		[23] = {{"dmg","+110%"},},
		[24] = {{"fire","+12"},},
		[25] = {{"dmg","+120%"},},
		[26] = {{"fire","+13"},},
		[27] = {{"dmg","+130%"},},
		[28] = {{"fire","+14"},},
		[29] = {{"dmg","+140%"},},
		[30] = {{"fire","+15"},},
	},
	[5005] = {
		[2] = {{"dmg","+20%"},},
		[3] = {{"dmg","+40%"},},
		[4] = {{"dmg","+60%"},},
		[5] = {{"dmg","+80%"},},
		[6] = {{"ddta","+1"},},
		[7] = {{"dmg","+20%"},},
		[8] = {{"dmg","+40%"},},
		[9] = {{"dmg","+60%"},},
		[10] = {{"dmg","+80%"},},
		[11] = {{"ddta","+2"},},
		[12] = {{"dmg","+20%"},},
		[13] = {{"dmg","+40%"},},
		[14] = {{"dmg","+60%"},},
		[15] = {{"dmg","+80%"},},
		[16] = {{"ddta","+3"},},
		[17] = {{"dmg","+20%"},},
		[18] = {{"dmg","+40%"},},
		[19] = {{"dmg","+60%"},},
		[20] = {{"dmg","+80%"},},
		[21] = {{"ddta","+4"},},
		[22] = {{"dmg","+20%"},},
		[23] = {{"dmg","+40%"},},
		[24] = {{"dmg","+60%"},},
		[25] = {{"dmg","+80%"},},
		[26] = {{"ddta","+5"},},
		[27] = {{"dmg","+20%"},},
		[28] = {{"dmg","+40%"},},
		[29] = {{"dmg","+60%"},},
		[30] = {{"dmg","+80%"},},
	},
	[5006] = {
		[2] = {{"dmg","+10%"},},
		[3] = {{"dmg","+20%"},},
		[4] = {{"time","+10%"},},
		[5] = {{"dmg","+30%"},},
		[6] = {{"dmg","+40%"},},
		[7] = {{"time","+20%"},},
		[8] = {{"dmg","+50%"},},
		[9] = {{"dmg","+60%"},},
		[10] = {{"time","+30%"},},
		[11] = {{"fireline","+1"},},
		[12] = {{"dmg","+70%"},},
		[13] = {{"dmg","+80%"},},
		[14] = {{"time","+40%"},},
		[15] = {{"dmg","+90%"},},
		[16] = {{"dmg","+100%"},},
		[17] = {{"time","+50%"},},
		[18] = {{"dmg","+110%"},},
		[19] = {{"dmg","+120%"},},
		[20] = {{"time","+60%"},},
		[21] = {{"fireline","+3"},},
		[22] = {{"dmg","+130%"},},
		[23] = {{"dmg","+140%"},},
		[24] = {{"time","+70%"},},
		[25] = {{"dmg","+150%"},},
		[26] = {{"dmg","+160%"},},
		[27] = {{"time","+80%"},},
		[28] = {{"dmg","+170%"},},
		[29] = {{"dmg","+180%"},},
		[30] = {{"time","+90%"},},
	},
	[5007] = {
		[2] = {{"dmg","+5%"},},
		[3] = {{"dmg","+10%"},},
		[4] = {{"dmg","+15%"},},
		[5] = {{"range","+10%"},},
		[6] = {{"dmg","+20%"},},
		[7] = {{"dmg","+25%"},},
		[8] = {{"dmg","+30%"},},
		[9] = {{"dmg","+35%"},},
		[10] = {{"dmg","+40%"},},
		[11] = {{"dmg","+45%"},},
		[12] = {{"range","+20%"},},
		[13] = {{"dmg","+50%"},},
		[14] = {{"dmg","+55%"},},
		[15] = {{"dmg","+60%"},},
		[16] = {{"dmg","+65%"},},
		[17] = {{"dmg","+70%"},},
		[18] = {{"dmg","+75%"},},
		[19] = {{"range","+30%"},},
		[20] = {{"dmg","+80%"},},
		[21] = {{"dmg","+85%"},},
		[22] = {{"dmg","+90%"},},
		[23] = {{"dmg","+95%"},},
		[24] = {{"dmg","+100%"},},
		[25] = {{"dmg","+105%"},},
		[26] = {{"range","+40%"},},
		[27] = {{"dmg","+110%"},},
		[28] = {{"dmg","+115%"},},
		[29] = {{"dmg","+120%"},},
		[30] = {{"dmg","+125%"},},
	},
	[5008] = {
		[2] = {{"time","+6%"},},
		[3] = {{"time","+12%"},},
		[4] = {{"time","+18%"},},
		[5] = {{"range","+15%"},},
		[6] = {{"time","+24%"},},
		[7] = {{"time","+30%"},},
		[8] = {{"time","+36%"},},
		[9] = {{"time","+42%"},},
		[10] = {{"time","+48%"},},
		[11] = {{"time","+54%"},},
		[12] = {{"range","+30%"},},
		[13] = {{"time","+60%"},},
		[14] = {{"time","+66%"},},
		[15] = {{"time","+72%"},},
		[16] = {{"time","+78%"},},
		[17] = {{"time","+84%"},},
		[18] = {{"time","+90%"},},
		[19] = {{"range","+45%"},},
		[20] = {{"time","+96%"},},
		[21] = {{"time","+102%"},},
		[22] = {{"time","+108%"},},
		[23] = {{"time","+114%"},},
		[24] = {{"time","+120%"},},
		[25] = {{"time","+126%"},},
		[26] = {{"range","+60%"},},
		[27] = {{"time","+132%"},},
		[28] = {{"time","+138%"},},
		[29] = {{"time","+144%"},},
		[30] = {{"time","+150%"},},
	},
	[5010] = {
		[2] = {{"missles","+1"},},
		[3] = {{"missles","+2"},},
		[4] = {{"missles","+3"},},
		[5] = {{"missles","+4"},},
		[6] = {{"missles","+5"},},
		[7] = {{"missles","+6"},},
		[8] = {{"missles","+7"},},
		[9] = {{"missles","+8"},},
		[10] = {{"missles","+9"},},
		[11] = {{"missles","+10"},},
		[12] = {{"missles","+11"},},
		[13] = {{"missles","+12"},},
		[14] = {{"missles","+13"},},
		[15] = {{"missles","+14"},},
		[16] = {{"missles","+15"},},
		[17] = {{"missles","+16"},},
		[18] = {{"missles","+17"},},
		[19] = {{"missles","+18"},},
		[20] = {{"missles","+19"},},
		[21] = {{"missles","+20"},},
		[22] = {{"missles","+21"},},
		[23] = {{"missles","+22"},},
		[24] = {{"missles","+23"},},
		[25] = {{"missles","+24"},},
		[26] = {{"missles","+25"},},
		[27] = {{"missles","+26"},},
		[28] = {{"missles","+27"},},
		[29] = {{"missles","+28"},},
		[30] = {{"missles","+29"},},
	},
	[5011] = {
		[2] = {{"bounce","+2"},},
		[3] = {{"dmg","+5%"},},
		[4] = {{"dmg","+10%"},},
		[5] = {{"dmg","+15%"},},
		[6] = {{"dmg","+20%"},},
		[7] = {{"ball","+24"},},
		[8] = {{"dmg","+25%"},},
		[9] = {{"dmg","+30%"},},
		[10] = {{"dmg","+35%"},},
		[11] = {{"dmg","+40%"},},
		[12] = {{"bounce","+4"},},
		[13] = {{"dmg","+45%"},},
		[14] = {{"dmg","+50%"},},
		[15] = {{"dmg","+55%"},},
		[16] = {{"dmg","+60%"},},
		[17] = {{"bounce","+7"},},
		[18] = {{"dmg","+70%"},},
		[19] = {{"dmg","+80%"},},
		[20] = {{"dmg","+90%"},},
		[21] = {{"dmg","+100%"},},
		[22] = {{"ball","+48"},},
		[23] = {{"dmg","+110%"},},
		[24] = {{"dmg","+120%"},},
		[25] = {{"dmg","+130%"},},
		[26] = {{"dmg","+140%"},},
		[27] = {{"bounce","+10"},},
		[28] = {{"dmg","+150%"},},
		[29] = {{"dmg","+160%"},},
		[30] = {{"dmg","+170%"},},
	},
	[5012] = {
		[2] = {{"hole","+1"},},
		[3] = {{"time","+5%"},},
		[4] = {{"time","+10%"},},
		[5] = {{"time","+15%"},},
		[6] = {{"time","+20%"},},
		[7] = {{"hole","+2"},},
		[8] = {{"time","+25%"},},
		[9] = {{"time","+30%"},},
		[10] = {{"time","+35%"},},
		[11] = {{"time","+40%"},},
		[12] = {{"hole","+3"},},
		[13] = {{"time","+45%"},},
		[14] = {{"time","+50%"},},
		[15] = {{"time","+55%"},},
		[16] = {{"time","+60%"},},
		[17] = {{"hole","+4"},},
		[18] = {{"time","+65%"},},
		[19] = {{"time","+70%"},},
		[20] = {{"time","+75%"},},
		[21] = {{"time","+80%"},},
		[22] = {{"hole","+5"},},
		[23] = {{"time","+85%"},},
		[24] = {{"time","+90%"},},
		[25] = {{"time","+95%"},},
		[26] = {{"time","+100%"},},
		[27] = {{"hole","+6"},},
		[28] = {{"time","+110%"},},
		[29] = {{"time","+120%"},},
		[30] = {{"time","+130%"},},
	},
	[5013] = {
		[2] = {{"time","+5%"},},
		[3] = {{"time","+10%"},},
		[4] = {{"time","+15%"},},
		[5] = {{"range","+15%"},},
		[6] = {{"time","+20%"},},
		[7] = {{"time","+25%"},},
		[8] = {{"time","+30%"},},
		[9] = {{"time","+35%"},},
		[10] = {{"time","+40%"},},
		[11] = {{"time","+45%"},},
		[12] = {{"range","+30%"},},
		[13] = {{"time","+50%"},},
		[14] = {{"time","+55%"},},
		[15] = {{"time","+60%"},},
		[16] = {{"time","+65%"},},
		[17] = {{"time","+70%"},},
		[18] = {{"time","+75%"},},
		[19] = {{"range","+45%"},},
		[20] = {{"time","+80%"},},
		[21] = {{"time","+85%"},},
		[22] = {{"time","+90%"},},
		[23] = {{"time","+95%"},},
		[24] = {{"time","+100%"},},
		[25] = {{"time","+105%"},},
		[26] = {{"range","+60%"},},
		[27] = {{"time","+110%"},},
		[28] = {{"time","+115%"},},
		[29] = {{"time","+120%"},},
		[30] = {{"time","+125%"},},
	},
	[5014] = {
		[2] = {{"wave","+1"},},
		[3] = {{"dmg","+10%"},},
		[4] = {{"dmg","+20%"},},
		[5] = {{"dmg","+30%"},},
		[6] = {{"dmg","+40%"},},
		[7] = {{"wave","+2"},},
		[8] = {{"dmg","+50%"},},
		[9] = {{"dmg","+60%"},},
		[10] = {{"dmg","+70%"},},
		[11] = {{"dmg","+80%"},},
		[12] = {{"wave","+3"},},
		[13] = {{"dmg","+90%"},},
		[14] = {{"dmg","+100%"},},
		[15] = {{"dmg","+110%"},},
		[16] = {{"dmg","+120%"},},
		[17] = {{"wave","+4"},},
		[18] = {{"dmg","+130%"},},
		[19] = {{"dmg","+140%"},},
		[20] = {{"dmg","+150%"},},
		[21] = {{"dmg","+160%"},},
		[22] = {{"wave","+5"},},
		[23] = {{"dmg","+170%"},},
		[24] = {{"dmg","+180%"},},
		[25] = {{"dmg","+190%"},},
		[26] = {{"dmg","+200%"},},
		[27] = {{"wave","+6"},},
		[28] = {{"dmg","+220%"},},
		[29] = {{"dmg","+240%"},},
		[30] = {{"dmg","+260%"},},
	},
}

--开启宠物升级 1 开启 0 关闭
hVar.EnablePetUpgrade = 1

--[[
--武器升级消耗
hVar.WEAPON_LVUP_INFO = {
	maxlv = 10,
	["default"] = {
		--		2	3	4	5	6	7	8	9	10
		requireScore =	{100,	500,	1000,	2000,	5000,	10000,	20000,	50000,	100000},
		requireDebris =	{25,	50,	75,	100,	150,	200,	250,	400,	500},
	},
	[6013] = {
		requireDebrisId = 15001,
		loadparam = "default",
	},
	[6014] = {
		requireDebrisId = 15002,
		loadparam = "default",
	},
	[6007] = {
		requireDebrisId = 15003,
		loadparam = "default",
	},
	[6003] = {
		requireDebrisId = 15004,
		loadparam = "default",
	},
	[6006] = {
		requireDebrisId = 15005,
		loadparam = "default",
	},
	[6004] = {
		requireDebrisId = 15006,
		loadparam = "default",
	},
	[6016] = {
		requireDebrisId = 15007,
		loadparam = "default",
	},
	[6017] = {
		requireDebrisId = 15008,
		loadparam = "default",
	},
	[6002] = {
		requireDebrisId = 15009,
		loadparam = "default",
	},
	[6005] = {
		requireDebrisId = 15010,
		loadparam = "default",
	},
	[6008] = {
		requireDebrisId = 15011,
		loadparam = "default",
	},
	[6009] = {
		requireDebrisId = 15012,
		loadparam = "default",
	},
}
]]

--武器皮肤临时定义
hVar.WEAPON_SKIN_TEMPDEFINE = {
	--[6013] = {
		--{model = "MODEL:UNIT_JEEP_GUN"},
		--{model = "MODEL:UNIT_JEEP_GUN_A"},
		--{model = "MODEL:UNIT_JEEP_GUN_B"},
	--},
	--[6016] = {
		--{model = "MODEL:UNIT_JEEP_POSION"},
		--{model = "MODEL:UNIT_JEEP_POSION_A"},
		--{model = "MODEL:UNIT_JEEP_POSION_B"},
		
	--},
	--[6004] = {
		--{effect = {{3165,0,-12,0.9,},},},
		--{effect = {{3256,0,-12,0.9,},},},
		--{effect = {{3257,0,-12,0.9,},},},
	--},
	--[6017] = {
		--{model = "MODEL:UNIT_JEEP_SHRINK"},
		--{model = "MODEL:UNIT_JEEP_SHRINK_A"},
		--{model = "MODEL:UNIT_JEEP_SHRINK_B"},
	--},
	--[6008] = {
		--{model = "MODEL:UNIT_JEEP_GAOSI"},
		--{model = "MODEL:UNIT_JEEP_GAOSI_A"},
		--{model = "MODEL:UNIT_JEEP_GAOSI_B"},
	--},
	--[6009] = {
		--{model = "MODEL:UNIT_JEEP_CHASER"},
		--{model = "MODEL:UNIT_JEEP_CHASER_A"},
		--{model = "MODEL:UNIT_JEEP_CHASER_B"},
	--},
	--[6005] = {
		--{model = "MODEL:UNIT_JEEP_LASER"},
		--{model = "MODEL:UNIT_JEEP_LASER_A"},
		--{model = "MODEL:UNIT_JEEP_LASER_B"},
	--},
	--[6014] = {
		--{model = "MODEL:UNIT_JEEP_GATLIN"},
		--{model = "MODEL:UNIT_JEEP_GATLIN_A"},
	--},
	--[6003] = {
		--{model = "MODEL:UNIT_JEEP_FIRE"},
		--{model = "MODEL:UNIT_JEEP_FIRE_A"},
	--},
	--[6006] = {
		--{model = "MODEL:UNIT_JEEP_TRIPLE"},
		--{model = "MODEL:UNIT_JEEP_TRIPLE_A"},
	--},
	--[6002] = {
		--{model = "MODEL:UNIT_JEEP_GUN10"},
		--{model = "MODEL:UNIT_JEEP_GUN10_A"},
		--{model = "MODEL:UNIT_JEEP_GUN10_B"},
	--},
}

--武器皮肤临时索引表
hVar.WEAPON_SKIN_TEMPINDEX = {}

--宠物升级消耗
--hVar.PET_LVUP_INFO = {
	--maxlv = 10,
	--["default"] = {
		----		2	3	4	5	6	7	8	9	10
		--requireScore =	{100,	500,	1000,	2000,	5000,	10000,	20000,	50000,	100000},
		--requireDebris =	{25,	50,	75,	100,	150,	200,	250,	400,	500},
	--},
	--[13041] = {
		--requireDebrisId = 15101,
		--loadparam = "default",
	--},
	--[13042] = {
		--requireDebrisId = 15102,
		--loadparam = "default",
	--},
	--[13043] = {
		--requireDebrisId = 15103,
		--loadparam = "default",
	--},
	--[13044] = {
		--requireDebrisId = 15104,
		--loadparam = "default",
	--},
--}

--宠物升级信息 显示下一级升级信息
hVar.PetUpgradeInfo = {
	[13041] = {
		[1] = {
			{"dmg","+30%"},
		},
		[2] = {
			{"dmg","+35%"},
		},
	},
	[13042] = {
		[1] = {
			{"hp","+33%"},
		},
		[2] = {
			{"hp","+66%"},
		},
	},
	[13043] = {
		[1] = {
			{"dmg","+30%"},
		},
		[2] = {
			{"dmg","+35%"},
		},
	},
	[13044] = {
		[1] = {
			{"hp","+33%"},
		},
		[2] = {
			{"hp","+66%"},
		},
	},
}

--开启成就 1 开启 0 关闭
hVar.EnableAchievement = 0

--成就类型
hVar.AchievementType = {
	CLEARANCE = 1,	--通关时间
	BATTER = 2,	--最大连击
	MAXPET = 3,	--最多携带宠物数
	ROLLING = 4,	--碾压总数
	ONEPASS = 5,	--一命闯关
}

hVar.DeleteEquipMat = {
	[1] = {
		score = {50,90},
	},
	[2] = {
		score = {150,250},
	},
	[3] = {
		score = {400,600},
	},
	[4] = {
		score = {1000,1500},
	},
}

--成就评级标准
hVar.AchievementRatingCriteria = {	--铜 银 金标准   自己的数据 与  标准比较
	[hVar.AchievementType.CLEARANCE] = {		--通关时间
		compareType = {"moreE","lessE"},	--比较方式 {大等于 小等于}
		criteria = {{6,30},{6,20},{6,10}}	--(关数)(分钟)
	},
	[hVar.AchievementType.BATTER] = {		--最大连击
		compareType = {"moreE"},		--比较方式 {大等于}
		criteria = {{20},{50},{80}},		--(个数)
	},
	[hVar.AchievementType.MAXPET] = {		--最多携带宠物数
		compareType = {"moreE"},		--比较方式 {大等于}
		criteria = {{2},{4},{6}},		--(个数)
		text = "pet_criteria",			--描述文字
		award = {100,200,300},			--奖励积分
	},
	[hVar.AchievementType.ROLLING] = {		--碾压总数
		compareType = {"moreE"},		--比较方式 {大等于}
		criteria = {{5},{10},{15}},		--(个数)
		text = "rolling_criteria",		--描述文字
		award = {100,200,300},			--奖励积分
	},
	[hVar.AchievementType.ONEPASS] = {		--一命闯关
		compareType = {"moreE"},		--比较方式 {大等于}
		criteria = {{2},{4},{6}},		--(关数)
		text = "onepass_criteria",		--描述文字
		award = {100,200,300},			--奖励积分
	},
}

--炸地鼠难度配置表
hVar.GameGopherVersion = "1.0"
hVar.GameGopherDiffDefine = {
	[1] = {
		unitid = 11109,		--地鼠id
		unitid_ds = 11111,	--双倍积分怪
		unit_ds_num = 1,	--双倍积分怪出现次数
		gametime = 90,		--游戏时间 秒
		costcoin = 0,		--消耗货币1
		refreshline = {	--刷新线程  每一条线程自己单独控制刷新时间和消失时间  和怪物类型
			[1] = {
				refreshtime = 3500,	--刷新时间 毫秒
				refreshstart = 500,	--第一个刷新时间 毫秒
				refreshend = 65000,	--结束时间 毫秒
				--mode 1参数
				disappeartime = 7000,	--消失时间 毫秒
			},
			[2] = {
				refreshtime = 2500,	--刷新时间 毫秒
				refreshstart = 63000,	--第一个刷新时间 毫秒
				--mode 1参数
				disappeartime = 6000,	--消失时间 毫秒
			},
		},
		rule = {	--总计30怪
			unit_score = 1,--普通地鼠积分
			unitds_score = 2,--特殊地鼠积分
			awards = {--从上往下只选一个
				{--达到分数的奖励
					shouldscole = 999,	--指标
					must = {	--必给
							{108,3},
						
					},
					rand = {	--随机给
						num = 1,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,3},
							{106,3},
							{107,3},
							{108,3},
						},
					},
				},
				{--达到分数的奖励
					shouldscole = 999,	--指标
					must = {	--必给
							{108,5},
						
					},
					rand = {	--随机给
						num = 1,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,5},
							{106,5},
							{107,5},
							{108,5},
						},
					},
				},
				{--达到分数的奖励
					shouldscole = 999,	--指标
					must = {	--必给
							{108,7},
						
					},
					rand = {	--随机给
						num = 1,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,7},
							{106,7},
							{107,7},
							{108,7},
						},
					},
				},
			},
		},
	},
	[2] = {
		unitid = 11109,		--地鼠id
		unitid_ds = 11111,	--双倍积分怪
		unit_ds_num = 2,	--双倍积分怪出现次数
		gametime = 90,		--游戏时间 秒
		costcoin = 1,		--消耗货币1
		refreshline = {	--刷新线程  每一条线程自己单独控制刷新时间和消失时间  和怪物类型
			[1] = {
				refreshtime = 3500,	--刷新时间 毫秒
				refreshstart = 500,	--第一个刷新时间 毫秒
				refreshend = 65000,	--结束时间 毫秒
				--mode 1参数
				disappeartime = 4000,	--消失时间 毫秒
			},
			[2] = {
				refreshtime = 2500,	--刷新时间 毫秒
				refreshstart = 63000,	--第一个刷新时间 毫秒
				--mode 1参数
				disappeartime = 4000,	--消失时间 毫秒
			},
		},
		rule = {	--总计30怪
			unit_score = 1,--普通地鼠积分
			unitds_score = 2,--特殊地鼠积分
			awards = {--从上往下只选一个
				{--达到分数的奖励
					shouldscole = 28,	--指标
					must = {	--必给
							{108,4},
						
					},
					rand = {	--随机给
						num = 2,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,4},
							{106,4},
							{107,4},
							{108,4},
						},
					},
				},
				{--达到分数的奖励
					shouldscole = 30,	--指标
					must = {	--必给
							{108,7},
						
					},
					rand = {	--随机给
						num = 2,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,7},
							{106,7},
							{107,7},
							{108,7},
						},
					},
				},
				{--达到分数的奖励
					shouldscole = 32,	--指标
					must = {	--必给
							{108,10},
						
					},
					rand = {	--随机给
						num = 2,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,10},
							{106,10},
							{107,10},
							{108,10},
						},
					},
				},
			},
		},
	},
	[3] = {
		unitid = 11109,		--地鼠id
		unitid_ds = 11111,	--双倍积分怪
		unit_ds_num = 3,	--双倍积分怪出现次数
		gametime = 90,		--游戏时间 秒
		costcoin = 1,		--消耗货币1
		refreshline = {	--刷新线程  每一条线程自己单独控制刷新时间和消失时间  和怪物类型
			[1] = {
				refreshtime = 3000,	--刷新时间 毫秒
				refreshstart = 500,	--第一个刷新时间 毫秒
				refreshend = 65000,	--结束时间 毫秒
				--mode 1参数
				disappeartime = 4000,	--消失时间 毫秒
				--mode 2参数
				movespeed = 60,	--移动速度
				movelength = 200,	--移动距离
				standtime = 500,	--移动到目的地后的等待时间 毫秒
				--actionmode 不填默认模式1
				--actionmode 可以直接填数字
				--actionmode = 2
				--actionmode 可以填表格 填权重
				actionmode = {	-- 1 原地不动 权重40 受消失时间影响   2 移动 权重 60  受移动距离 和 移动速度影响
					{1,30},
					{2,70},
				}
			},
			[2] = {
				refreshtime = 2000,	--刷新时间 毫秒
				refreshstart = 65000,	--第一个刷新时间 毫秒
				--mode 1参数
				disappeartime = 4000,	--消失时间 毫秒
				--mode 2参数
				movespeed = 60,	--移动速度
				movelength = 200,	--移动距离
				standtime = 500,	--移动到目的地后的等待时间 毫秒
				actionmode = {	-- 1 原地不动 权重40 受消失时间影响   2 移动 权重 60  受移动距离 和 移动速度影响
					{1,30},
					{2,70},
				}
			},
			[3] = {
				refreshtime = 2000,	--刷新时间 毫秒
				refreshstart = 87000,	--第一个刷新时间 毫秒
				--mode 1参数
				disappeartime = 4000,	--消失时间 毫秒
				--mode 2参数
				movespeed = 60,	--移动速度
				movelength = 200,	--移动距离
				standtime = 500,	--移动到目的地后的等待时间 毫秒
				actionmode = {	-- 1 原地不动 权重40 受消失时间影响   2 移动 权重 60  受移动距离 和 移动速度影响
					{1,30},
					{2,70},
				}
			},
		},
		rule = {	--总计37怪
			unit_score = 1,--普通地鼠积分
			unitds_score = 2,--特殊地鼠积分
			awards = {--从上往下只选一个
				{--达到分数的奖励
					shouldscole = 36,	--指标
					must = {	--必给
							{108,7},
						
					},
					rand = {	--随机给
						num = 3,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,7},
							{106,7},
							{107,7},
							{108,7},
						},
					},
				},
				{--达到分数的奖励
					shouldscole = 38,	--指标
					must = {	--必给
							{108,11},
						
					},
					rand = {	--随机给
						num = 3,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,11},
							{106,11},
							{107,11},
							{108,11},
						},
					},
				},
				{--达到分数的奖励
					shouldscole = 40,	--指标
					must = {	--必给
							{108,15},
						
					},
					rand = {	--随机给
						num = 3,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,15},
							{106,15},
							{107,15},
							{108,15},
						},
					},
				},
			},
		},
	},
	[4] = {
		unitid = 11109,		--地鼠id
		unitid_ds = 11111,	--双倍积分怪
		unit_ds_num = 5,	--双倍积分怪出现次数
		gametime = 90,		--游戏时间 秒
		costcoin = 1,		--消耗货币1
		refreshline = {	--刷新线程  每一条线程自己单独控制刷新时间和消失时间  和怪物类型
			[1] = {
				refreshtime = 3000,	--刷新时间 毫秒
				refreshstart = 500,	--第一个刷新时间 毫秒
				refreshend = 62000,	--结束时间 毫秒
				--mode 1参数
				disappeartime = 4000,	--消失时间 毫秒
				--mode 2参数
				movespeed = 100,	--移动速度
				movelength = 200,	--移动距离
				standtime = 200,	--移动到目的地后的等待时间 毫秒
				--actionmode 不填默认模式1
				--actionmode 可以直接填数字
				--actionmode = 2
				--actionmode 可以填表格 填权重
				actionmode = {	-- 1 原地不动 权重40 受消失时间影响   2 移动 权重 60  受移动距离 和 移动速度影响
					{1,20},
					{2,80},
				}
			},
			[2] = {
				refreshtime = 5000,	--刷新时间 毫秒
				refreshstart = 5000,	--第一个刷新时间 毫秒
				refreshend = 62000,	--结束时间 毫秒
				--mode 1参数
				disappeartime = 4000,	--消失时间 毫秒
				--mode 2参数
				movespeed = 100,	--移动速度
				movelength = {200,350},	--移动距离
				standtime = 200,	--移动到目的地后的等待时间 毫秒
				--actionmode 不填默认模式1
				--actionmode 可以直接填数字
				--actionmode = 2
				--actionmode 可以填表格 填权重
				actionmode = 2,
			},
			[3] = {
				refreshtime = 2500,	--刷新时间 毫秒
				refreshstart = 65000,	--第一个刷新时间 毫秒
				refreshend = 89000,	--结束时间 毫秒
				--mode 1参数
				disappeartime = 4000,	--消失时间 毫秒
				--mode 2参数
				movespeed = 100,	--移动速度
				movelength = 200,	--移动距离
				standtime = 200,	--移动到目的地后的等待时间 毫秒
				--actionmode 不填默认模式1
				--actionmode 可以直接填数字
				--actionmode = 2
				--actionmode 可以填表格 填权重
				actionmode = {	-- 1 原地不动 权重40 受消失时间影响   2 移动 权重 60  受移动距离 和 移动速度影响
					{1,20},
					{2,80},
				}
			},
			[4] = {
				refreshtime = 4000,	--刷新时间 毫秒
				refreshstart = 64000,	--第一个刷新时间 毫秒
				--mode 1参数
				disappeartime = 4000,	--消失时间 毫秒
				--mode 2参数
				movespeed = 100,	--移动速度
				movelength = {200,350},	--移动距离
				standtime = 200,	--移动到目的地后的等待时间 毫秒
				--actionmode 不填默认模式1
				--actionmode 可以直接填数字
				--actionmode = 2
				--actionmode 可以填表格 填权重
				actionmode = 2,
			},
		},
		rule = {	--总计50怪
			unit_score = 1,--普通地鼠积分
			unitds_score = 2,--特殊地鼠积分
			awards = {--从上往下只选一个
				{--达到分数的奖励
					shouldscole = 53,	--指标
					must = {	--必给
							{108,10},
						
					},
					rand = {	--随机给
						num = 4,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,10},
							{106,10},
							{107,10},
							{108,10},
						},
					},
				},
				{--达到分数的奖励
					shouldscole = 54,	--指标
					must = {	--必给
							{108,15},
						
					},
					rand = {	--随机给
						num = 4,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,15},
							{106,15},
							{107,15},
							{108,15},
						},
					},
				},
				{--达到分数的奖励
					shouldscole = 55,	--指标
					must = {	--必给
							{108,20},
						
					},
					rand = {	--随机给
						num = 4,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,20},
							{106,20},
							{107,20},
							{108,20},
						},
					},
				},
			},
		},
	},
}

hVar.AuraBuffType = {
	NO_TYPE = 0,		--无分类
	DEF_PHYSICAL = 1,	--物理防御
	DEF_POISON = 2,		--毒防御
	DEF_FIRE = 3,		--火防御
	DEF_THUNDER = 4,	--雷防御
	DEF_BOMB = 5,		--爆炸防御
	GRENADE_CHILD = 6,	--子母雷
	GRENADE_CRIT = 7,	--手雷暴击
	GRENADE_FIRE = 8,	--手雷爆炸火焰
	GRENADE_NUM = 9,	--双雷
	GRENADE_DIS = 10,	--投弹距离
}

--战车天赋类型
hVar.ChariotTalentType = {
	BOMB = 1,	--投雷专家
	SURVIVE = 2,	--生存意志
	HUNTER = 3,	--战地猎人
}
hVar.ChariotAttrList = {}

--使用皮肤的条件
hVar.UseAvaterCondition = {
	[1] = {
		mapstar = 0,
	},
	[2] = {
		vip = 1,
		showIconStr = {
			--图片 缩放 X Y
			{"icon/item/vip_01.png",0.5,16,0},
			--文字
			"vipStr101",
		}
	},
	[4] = {
		mapstar = 50,
	},
	[5] = {
		mapstar = 100,
		
	},
	[7] = {
		mapstar = 200,
	},
	[8] = {
		vip = 2,
		showIconStr = {
			--图片 缩放 X Y
			{"icon/item/vip_02.png",0.43,10,0},
			--文字
			"vipStr102",
		}
	},

}

--特殊武器获取条件
hVar.SpecialWeaponGetCondition = {
	[6019] = {
		vip = 5,
		showIconStr = {
			--图片 缩放 X Y
			{"icon/item/vip_05.png",0.36,8,2},
			--文字
			"vipStr103",
		}
	},
}

--评论类型定义
hVar.CommentTargetTypeDefine = {
	TEST		=	1,			--测试用类型
	COMMENT		=	2,			--针对评论的评论
	ITEM		=	3,			--道具的评论
	EQUIPMENT	=	4,			--武器的评论
	TACTICS		=	5,			--战术卡的评论
	PET		=	6,			--宠物的评论
	TACTICS_ALL	=	15,			--战术卡汇总评论（主基地地区）
	DRAGON		=	16,			--黑龙
	ENGINEER	=	17,			--工程师（主基地地区）
	CAMPAIGN	=	18,			--战役（主基地地区）
	MAZE		=	19,			--迷宫（主基地地区）
	DEFENCE		=	20,			--前哨阵地（主基地地区）
	STAGE		=	21,			--关卡战斗
	VIP		=	22,			--vip评论(黑龙洞窟)
	TANKTALENT	=	23,			--战车天赋(界面)
	TANKAVATER	=	24,			--战车皮肤(界面)
	REFINERY	=	25,			--精炼厂(主基地地区)
	PIECES		=	26,			--碎片处理中旬(界面)
	WEAPON_ALL	=	27,			--战术卡汇总评论（主基地地区）
	MONTH_CARD	=	28,			--月卡

	PROLOADTEXT	=	998,			--预加载文字
	NAMELIBRARY	=	999,			--用户名库
}

--各界面z值
--100001: 系统弹框、顶部广播消息、邮件正文
--100002: 游戏内顶部广播文字、无尽每日榜邮件正文、魔龙宝库勤劳奖邮件正文
--100003: 皇室战争、葫芦娃抽卡动画
--100006: 英雄技能升级界面、英雄属性界面
--100007: 无尽排行榜tip、英雄升星界面、英雄技能界面
--100008: 英雄属性tip、服务器抽卡类tip、英雄tip
--100009: 各种tip
--100010: 安卓掉线框、PVP掉线框、PVP等待玩家框
--100011: 飘浮文字
--10000000: MsgBox


--游戏内走马灯冒字通知类型
hVar.BUBBLE_NOTICE_TYPE = 
{
	RED_EQUIP = 1001,		--获得4孔神器
	PET_STARUP = 1002,		--宠物升星（解锁）
	WEAPON_STARUP = 1003,	--武器枪升星（解锁）
}