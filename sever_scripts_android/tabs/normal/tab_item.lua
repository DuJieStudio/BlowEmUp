hVar.tab_item = {}
local _tab_item = hVar.tab_item


----默认单位
_tab_item[1] = {
	type = hVar.ITEM_TYPE.NONE,
	name = "NONE",
	model = "MODEL:default",
	icon = "MODEL:default",
	itemLv = hVar.ITEM_QUALITY.WHITE,	--装备背景色
	itemValue = 1,	--道具价值 --zhenkira add. 2016.2.29
	elite = 0,	--精英装备标记，1:精英地图打出来的
	--numUI = "",	--如果存在此值，则在UITemplate的bagItem显示时，在数量前面补上此字符串，例如"+"..10，默认为"x"..10
	--uiXYWH = {0,0,-1,-1},	--如果存在此值，则在背包中显示此图标时，使用固定的坐标偏移和大小
	require = {
		{"level",1},
	},		--道具需求的英雄等级
	unique = 0,	--是否独特道具(不能分解，不能合成)
	--skillId = 0,	--技能ID --老版技能填法
	--skillId = {{id = 0, lv = 0, cd = 0}} --新版技能填法
	Atk = {0,0},	--攻击力，最小攻击，最大攻击
	def = 0,	--护甲
	lea = 0,	--统帅
	led = 0,	--防御
	str = 0,	--武力
	int = 0,	--智力
	con = 0,	--体质
	mxhp = 0,	--生命
	mxmp = 0,	--魔法
	activity = 0,	--速度
	tactics = 0,	--战术等级
	move = 0,	--移动范围
	atkRange = 0,	--攻击范围
	hpRecover = 0,	--生命回复(每日)
	mpRecover = 0,	--魔法回复(每日)
	allAttr = 0,	--全部基础属性 
	toughness = 0,	--韧性
	eliteDef = 0,	--精英减伤
	meleeDef = 0,	--近战减伤
	rangeDef = 0,	--远程减伤
	--geyachao: TD道具奖励属性
	reward = {
		[1] = {"hp_max", 10}, --血量
		[24] = {"hp_max_rate", 10}, --攻击力比例值（最小、最大都加）（去掉百分号之后的值）
		[2] = {"atk", {1, 2}}, --攻击力（最小、最大都加）
		[23] = {"atk_rate", 10}, --血量比例值（去掉百分号之后的值）
		[3] = {"atk_min", 1}, --最小攻击力
		[4] = {"atk_max", 2}, --最大攻击力
		[5] = {"atk_speed", 10}, --攻击速度（去掉百分号之后的值）
		[25] = {"atk_radius_rate", 10}, --攻击范围比例值（去掉百分号之后的值）
		[6] = {"move_speed", 120}, --移动速度
		[7] = {"atk_radius", 200}, --攻击范围
		[8] = {"def_physic", 5}, --物理防御
		[9] = {"def_magic", 3}, --法术防御
		[10] = {"dodge_rate", 100}, --闪避几率（去掉百分号之后的值）
		[11] = {"crit_rate", 30}, --暴击几率（去掉百分号之后的值）
		[12] = {"crit_value", 2.3}, --暴击倍数（支持小数）
		[13] = {"kill_gold", 20}, --击杀奖励的金币
		[14] = {"escape_punish", -1}, --逃怪惩罚
		[15] = {"hp_restore", 0.5}, --回血速度（每秒）（支持小数）
		[16] = {"rebirth_time", -2000}, --复活时间（毫秒）
		[17] = {"suck_blood_rate", 10}, --吸血率（去掉百分号之后的值）
		[18] = {"active_skill_cd_delta", -1000}, --主动技能冷却时间变化值（毫秒）
		[19] = {"active_skill_cd_delta_rate", -40}, --主动技能冷却时间变化比例值（去百分号后的值）
		[20] = {"passive_skill_cd_delta", -1000}, --被动技能冷却时间变化值（毫秒）
		[21] = {"passive_skill_cd_delta_rate", -40}, --被动技能冷却时间变化比例值（去百分号后的值）
		[22] = {"AI_attribute", 1}, --AI行为（0:被动怪 / 1:主动怪）
	}
}
----头盔
_tab_item[2] = {
	type = hVar.ITEM_TYPE.HEAD,
	name = "HEAD",
	icon = "ICON:icon01_x7y6",
	reward = {
		int = 3,
	}
}
----衣服
_tab_item[3] = {
	type = hVar.ITEM_TYPE.BODY,
	name = "BODY",
	model = "ICON:icon01_x8y6",
	reward = {
		def = 2,
	}
}
----武器
_tab_item[4] = {
	type = hVar.ITEM_TYPE.WEAPON,
	name = "WEAPON",
	model = "ICON:HeroAttr",
	reward = {
		minAtk = 2,
		maxAtk = 4,
	}
}
----手部
_tab_item[5] = {
	type = hVar.ITEM_TYPE.ORNAMENTS,
	name = "ORNAMENTS",
	model = "ICON:icon01_x15y4",
	reward = {
		lea = 2,
	}
}
----戒指
_tab_item[6] = {
	type = hVar.ITEM_TYPE.ORNAMENTS,
	name = "ORNAMENTS",
	model = "ICON:icon01_x9y8",
	reward = {
		str = 2,
	}
}
----鞋子
_tab_item[7] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "FOOT",
	model = "ICON:icon01_x6y16",
	reward = {
		activity = {2,30}
	}
}
----马
_tab_item[8] = {
	type = hVar.ITEM_TYPE.MOUNT,
	name = "MOUNT",
	model = "ICON:icon01_x6y13",
	reward = {
		hpRecover = 5,
	}
}

--任意数量的积分
_tab_item[25] = {
	type = hVar.ITEM_TYPE.RESOURCES,
	name = "积分",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	uiXYWH = {0,0,-1,-1},
	icon = "misc/skillup/mu_coin.png",
	scale = 1,
}

--任意数量的兵符
_tab_item[26] = {
	type = hVar.ITEM_TYPE.RESOURCES,
	name = "兵符",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	uiXYWH = {0,0,-1,-1},
	icon = "UI:pvptoken",
	scale = 1,
}

--任意数量的金币
_tab_item[27] = {
	type = hVar.ITEM_TYPE.RESOURCES,
	name = "金币",
	itemLv = hVar.ITEM_QUALITY.RED,
	uiXYWH = {0,0,-1,-1},
	icon = "misc/skillup/keshi.png",
	scale = 1,
}

--巨型机械蜘蛛战役包
_tab_item[57] = {
	name = "巨型机械蜘蛛战役包",
	bagName = "world/dlc_yxys_spider",
	type = hVar.ITEM_TYPE.MAPBAG,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = nil,
	xlobj = nil,
}

--飞船战役包
_tab_item[58] = {
	name = "巨型机械蜘蛛",
	bagName = "world/dlc_yxys_airship",
	type = hVar.ITEM_TYPE.MAPBAG,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = nil,
	xlobj = nil,
}

--生化战役包
_tab_item[59] = {
	name = "生化战役包",
	bagName = "world/dlc_bio_airship",
	type = hVar.ITEM_TYPE.MAPBAG,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = nil,
	xlobj = nil,
}

--飞碟战役包
_tab_item[60] = {
	name = "飞碟战役包",
	bagName = "world/dlc_yxys_plate",
	type = hVar.ITEM_TYPE.MAPBAG,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = nil,
	xlobj = nil,
}

--机械飞船战役包
_tab_item[61] = {
	name = "机械飞船战役包",
	bagName = "world/dlc_yxys_mechanics",
	type = hVar.ITEM_TYPE.MAPBAG,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = nil,
	xlobj = nil,
}

--虫族战役包
_tab_item[62] = {
	name = "虫族战役包",
	bagName = "world/dlc_yxys_zerg",
	type = hVar.ITEM_TYPE.MAPBAG,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = nil,
	xlobj = nil,
}

--尤达战役包
_tab_item[63] = {
	name = "尤达战役包",
	bagName = "world/dlc_yxys_yoda",
	type = hVar.ITEM_TYPE.MAPBAG,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = nil,
	xlobj = nil,
}

--瓦力战役包
_tab_item[64] = {
	name = "瓦力战役包",
	bagName = "world/dlc_yxys_walle",
	type = hVar.ITEM_TYPE.MAPBAG,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = nil,
	xlobj = nil,
}














--网页积分
_tab_item[1039] = {
	name = "网页积分",
	type = hVar.ITEM_TYPE.MAPBAG,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "misc/skillup/mu_coin.png",
	xlobj = nil,
}

--网页积分
_tab_item[1060] = {
	name = "网页积分",
	type = hVar.ITEM_TYPE.MAPBAG,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "misc/skillup/mu_coin.png",
	xlobj = nil,
}

---------------------------------------------------------------
--开启武器枪宝箱
_tab_item[9920] = {
	type = hVar.ITEM_TYPE.RESOURCES,
	name = "开启武器枪宝箱",
	itemLv = hVar.ITEM_QUALITY.RED,
	uiXYWH = {0,0,-1,-1},
	icon = "UI:game_coins",
	scale = 1,
}

--开启战术卡宝箱
_tab_item[9921] = {
	type = hVar.ITEM_TYPE.RESOURCES,
	name = "开启战术卡宝箱",
	itemLv = hVar.ITEM_QUALITY.RED,
	uiXYWH = {0,0,-1,-1},
	icon = "UI:game_coins",
	scale = 1,
}

--开启宠物宝箱
_tab_item[9922] = {
	type = hVar.ITEM_TYPE.RESOURCES,
	name = "开启宠物宝箱",
	itemLv = hVar.ITEM_QUALITY.RED,
	uiXYWH = {0,0,-1,-1},
	icon = "UI:game_coins",
	scale = 1,
}

--开启装备宝箱
_tab_item[9923] = {
	type = hVar.ITEM_TYPE.RESOURCES,
	name = "开启武器枪宝箱",
	itemLv = hVar.ITEM_QUALITY.RED,
	uiXYWH = {0,0,-1,-1},
	icon = "UI:game_coins",
	scale = 1,
}

--刷新商店
_tab_item[9924] = {
	type = hVar.ITEM_TYPE.RESOURCES,
	name = "刷新商店",
	itemLv = hVar.ITEM_QUALITY.RED,
	uiXYWH = {0,0,-1,-1},
	icon = "UI:game_coins",
	scale = 1,
}

--开启神器宝箱
_tab_item[9925] = {
	type = hVar.ITEM_TYPE.RESOURCES,
	name = "开启神器宝箱",
	itemLv = hVar.ITEM_QUALITY.RED,
	uiXYWH = {0,0,-1,-1},
	icon = "UI:game_coins",
	scale = 1,
}

--战车改名
_tab_item[9926] = {
	type = hVar.ITEM_TYPE.RESOURCES,
	name = "战车改名",
	itemLv = hVar.ITEM_QUALITY.RED,
	uiXYWH = {0,0,-1,-1},
	icon = "UI:game_coins",
	scale = 1,
}

--特惠装备
_tab_item[9927] = {
	type = hVar.ITEM_TYPE.RESOURCES,
	name = "特惠装备",
	itemLv = hVar.ITEM_QUALITY.RED,
	uiXYWH = {0,0,-1,-1},
	icon = "UI:game_coins",
	scale = 1,
}







--清除账号数据
_tab_item[9999] = {
	type = hVar.ITEM_TYPE.RESOURCES,
	name = "清除账号数据",
	itemLv = hVar.ITEM_QUALITY.RED,
	scale = 1,
}

---------------------------------------------------------------
--武器升星Star1
_tab_item[10161] = 
{
	name = "武器升星Star1",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升星Star2
_tab_item[10162] = 
{
	name = "武器升星Star2",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升星Star3
_tab_item[10163] = 
{
	name = "武器升星Star3",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升星Star4
_tab_item[10164] = 
{
	name = "武器升星Star4",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升星Star5
_tab_item[10165] = 
{
	name = "武器升星Star5",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升星Star6
_tab_item[10166] = 
{
	name = "武器升星Star6",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升星Star7
_tab_item[10167] = 
{
	name = "武器升星Star7",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升星Star8
_tab_item[10168] = 
{
	name = "武器升星Star8",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升星Star9
_tab_item[10169] = 
{
	name = "武器升星Star9",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升星Star10
_tab_item[10170] = 
{
	name = "武器升星Star10",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器加经验值
_tab_item[10171] = 
{
	name = "武器加经验值",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--战车加经验值
_tab_item[10172] = 
{
	name = "战车加经验值",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--战车分配天赋点
_tab_item[10173] = 
{
	name = "战车分配天赋点",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物加经验值
_tab_item[10174] = 
{
	name = "宠物加经验值",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升星Star1
_tab_item[10175] = 
{
	name = "宠物升星Star1",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升星Star2
_tab_item[10176] = 
{
	name = "宠物升星Star2",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升星Star3
_tab_item[10177] = 
{
	name = "宠物升星Star3",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升星Star4
_tab_item[10178] = 
{
	name = "宠物升星Star4",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升星Star5
_tab_item[10179] = 
{
	name = "宠物升星Star5",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升星Lv6
_tab_item[10180] = 
{
	name = "宠物升星Lv6",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升星Lv7
_tab_item[10181] = 
{
	name = "宠物升星Lv7",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升星Lv8
_tab_item[10182] = 
{
	name = "宠物升星Lv8",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升星Lv9
_tab_item[10183] = 
{
	name = "宠物升星Lv9",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升星Lv10
_tab_item[10184] = 
{
	name = "宠物升星Lv10",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--战车重置天赋点
_tab_item[10185] = 
{
	name = "战车重置天赋点",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--服务器分解红装
_tab_item[10458] = 
{
	name = "分解红装",
	type = hVar.ITEM_TYPE.TACTICDEBRIS,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "ICON:skill_icon3_x16y8",
	tacticID = 1100,
}

---------------------------------------------------------------
--武器升级Lv1
_tab_item[10459] = 
{
	name = "武器升级Lv1",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv2
_tab_item[10460] = 
{
	name = "武器升级Lv2",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv3
_tab_item[10461] = 
{
	name = "武器升级Lv3",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv4
_tab_item[10462] = 
{
	name = "武器升级Lv4",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv5
_tab_item[10463] = 
{
	name = "武器升级Lv5",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv6
_tab_item[10464] = 
{
	name = "武器升级Lv6",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv7
_tab_item[10465] = 
{
	name = "武器升级Lv7",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv8
_tab_item[10466] = 
{
	name = "武器升级Lv8",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv9
_tab_item[10467] = 
{
	name = "武器升级Lv9",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv10
_tab_item[10468] = 
{
	name = "武器升级Lv10",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv11
_tab_item[10469] = 
{
	name = "武器升级Lv11",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv12
_tab_item[10470] = 
{
	name = "武器升级Lv12",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv13
_tab_item[10471] = 
{
	name = "武器升级Lv13",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv14
_tab_item[10472] = 
{
	name = "武器升级Lv14",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv15
_tab_item[10473] = 
{
	name = "武器升级Lv15",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv16
_tab_item[10474] = 
{
	name = "武器升级Lv16",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv17
_tab_item[10475] = 
{
	name = "武器升级Lv17",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv18
_tab_item[10476] = 
{
	name = "武器升级Lv18",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv19
_tab_item[10477] = 
{
	name = "武器升级Lv19",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv20
_tab_item[10478] = 
{
	name = "武器升级Lv20",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv21
_tab_item[10479] = 
{
	name = "武器升级Lv21",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv22
_tab_item[10480] = 
{
	name = "武器升级Lv22",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv23
_tab_item[10481] = 
{
	name = "武器升级Lv23",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv24
_tab_item[10482] = 
{
	name = "武器升级Lv24",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv25
_tab_item[10483] = 
{
	name = "武器升级Lv25",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv26
_tab_item[10484] = 
{
	name = "武器升级Lv26",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv27
_tab_item[10485] = 
{
	name = "武器升级Lv27",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv28
_tab_item[10486] = 
{
	name = "武器升级Lv28",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv29
_tab_item[10487] = 
{
	name = "武器升级Lv29",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv30
_tab_item[10488] = 
{
	name = "武器升级Lv30",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv31
_tab_item[10489] = 
{
	name = "武器升级Lv31",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv32
_tab_item[10490] = 
{
	name = "武器升级Lv32",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv33
_tab_item[10491] = 
{
	name = "武器升级Lv33",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv34
_tab_item[10492] = 
{
	name = "武器升级Lv34",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv35
_tab_item[10493] = 
{
	name = "武器升级Lv35",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv36
_tab_item[10494] = 
{
	name = "武器升级Lv36",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv37
_tab_item[10495] = 
{
	name = "武器升级Lv37",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv38
_tab_item[10496] = 
{
	name = "武器升级Lv38",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv39
_tab_item[10497] = 
{
	name = "武器升级Lv39",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv40
_tab_item[10498] = 
{
	name = "武器升级Lv40",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv41
_tab_item[10499] = 
{
	name = "武器升级Lv41",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv42
_tab_item[10500] = 
{
	name = "武器升级Lv42",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv43
_tab_item[10501] = 
{
	name = "武器升级Lv43",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv44
_tab_item[10502] = 
{
	name = "武器升级Lv44",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv45
_tab_item[10503] = 
{
	name = "武器升级Lv45",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv46
_tab_item[10504] = 
{
	name = "武器升级Lv46",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv47
_tab_item[10505] = 
{
	name = "武器升级Lv47",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv48
_tab_item[10506] = 
{
	name = "武器升级Lv48",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv49
_tab_item[10507] = 
{
	name = "武器升级Lv49",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--武器升级Lv50
_tab_item[10508] = 
{
	name = "武器升级Lv50",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

---------------------------------------------------------------
--宠物升级Lv1
_tab_item[10509] = 
{
	name = "宠物升级Lv1",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv2
_tab_item[10510] = 
{
	name = "宠物升级Lv2",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv3
_tab_item[10511] = 
{
	name = "宠物升级Lv3",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv4
_tab_item[10512] = 
{
	name = "宠物升级Lv4",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv5
_tab_item[10513] = 
{
	name = "宠物升级Lv5",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv6
_tab_item[10514] = 
{
	name = "宠物升级Lv6",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv7
_tab_item[10515] = 
{
	name = "宠物升级Lv7",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv8
_tab_item[10516] = 
{
	name = "宠物升级Lv8",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv9
_tab_item[10517] = 
{
	name = "宠物升级Lv9",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv10
_tab_item[10518] = 
{
	name = "宠物升级Lv10",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv11
_tab_item[10519] = 
{
	name = "宠物升级Lv11",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv12
_tab_item[10520] = 
{
	name = "宠物升级Lv12",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv13
_tab_item[10521] = 
{
	name = "宠物升级Lv13",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv14
_tab_item[10522] = 
{
	name = "宠物升级Lv14",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv15
_tab_item[10523] = 
{
	name = "宠物升级Lv15",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv16
_tab_item[10524] = 
{
	name = "宠物升级Lv16",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv17
_tab_item[10525] = 
{
	name = "宠物升级Lv17",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv18
_tab_item[10526] = 
{
	name = "宠物升级Lv18",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv19
_tab_item[10527] = 
{
	name = "宠物升级Lv19",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv20
_tab_item[10528] = 
{
	name = "宠物升级Lv20",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv21
_tab_item[10529] = 
{
	name = "宠物升级Lv21",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv22
_tab_item[10530] = 
{
	name = "宠物升级Lv22",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv23
_tab_item[10531] = 
{
	name = "宠物升级Lv23",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv24
_tab_item[10532] = 
{
	name = "宠物升级Lv24",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv25
_tab_item[10533] = 
{
	name = "宠物升级Lv25",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv26
_tab_item[10534] = 
{
	name = "宠物升级Lv26",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv27
_tab_item[10535] = 
{
	name = "宠物升级Lv27",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv28
_tab_item[10536] = 
{
	name = "宠物升级Lv28",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv29
_tab_item[10537] = 
{
	name = "宠物升级Lv29",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物升级Lv30
_tab_item[10538] = 
{
	name = "宠物升级Lv30",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--挑战普通剧情地图
_tab_item[10539] = 
{
	name = "挑战普通剧情地图",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--挑战娱乐地图
_tab_item[10540] = 
{
	name = "挑战娱乐地图",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}





















---------------------------------------------------------------
--普通机枪
_tab_item[11000] = {
	type = hVar.ITEM_TYPE.WEAPON_GUN,
	name = "切枪",
	icon = "icon/item/gun_1.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20001,
	--mana = 3, --耗魔
	--isWeapon = 1, --是武器
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		--
	},
	reward = {
		--
	},
	--[[
	activeSkill =								--主动释放的技能
	{
		id = 12004,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
	]]
	passiveSkill = 12004,
	--tacticId = 5100,
}

--散弹枪
_tab_item[11001] = {
	type = hVar.ITEM_TYPE.WEAPON_GUN,
	name = "切枪",
	icon = "icon/item/gun_2.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20002,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	--[[
	activeSkill =								--主动释放的技能
	{
		id = 12005,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
	]]
	passiveSkill = 12005,
	--tacticId = 5101,
}

--弹射枪
_tab_item[11002] = {
	type = hVar.ITEM_TYPE.WEAPON_GUN,
	name = "切枪",
	icon = "icon/item/gun_3.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20003,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	--[[
	activeSkill =								--主动释放的技能
	{
		id = 12006,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
	]]
	passiveSkill = 12006,
	--tacticId = 5102,
}

--火焰枪
_tab_item[11003] = {
	type = hVar.ITEM_TYPE.WEAPON_GUN,
	name = "切枪",
	icon = "icon/item/gun_4.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20004,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	--[[
	activeSkill =								--主动释放的技能
	{
		id = 12007,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
	]]
	passiveSkill = 12007,
	--tacticId = 5103,
}

--射线枪
_tab_item[11004] = {
	type = hVar.ITEM_TYPE.WEAPON_GUN,
	name = "切枪",
	icon = "icon/item/gun_5.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20005,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	--[[
	activeSkill =								--主动释放的技能
	{
		id = 12008,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
	]]
	passiveSkill = 12008,
	--tacticId = 5104,
}

--闪电枪
_tab_item[11005] = {
	type = hVar.ITEM_TYPE.WEAPON_GUN,
	name = "切枪",
	icon = "icon/item/gun_6.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20006,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	--[[
	activeSkill =								--主动释放的技能
	{
		id = 12009,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
	]]
	passiveSkill = 12009,
	--tacticId = 5105,
}

--毒枪
_tab_item[11006] = {
	type = hVar.ITEM_TYPE.WEAPON_GUN,
	name = "切枪",
	icon = "icon/item/gun_7.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20007,
	passiveSkill = 12010,
}

--缩小枪
_tab_item[11007] = {
	type = hVar.ITEM_TYPE.WEAPON_GUN,
	name = "切枪",
	icon = "icon/item/gun_8.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20008,
	passiveSkill = 12011,
}

--镭射枪
_tab_item[11008] = {
	type = hVar.ITEM_TYPE.WEAPON_GUN,
	name = "切枪",
	icon = "icon/item/gun_9.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20009,
	passiveSkill = 12012,
}

--冲击枪
_tab_item[11009] = {
	type = hVar.ITEM_TYPE.WEAPON_GUN,
	name = "切枪",
	icon = "icon/item/gun_10.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20010,
	passiveSkill = 12013,
}

--火箭枪
_tab_item[11010] = {
	type = hVar.ITEM_TYPE.WEAPON_GUN,
	name = "切枪",
	icon = "icon/item/gun_11.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20011,
	passiveSkill = 12014,
}

--导弹枪
_tab_item[11011] = {
	type = hVar.ITEM_TYPE.WEAPON_GUN,
	name = "切枪",
	icon = "icon/item/gun_12.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20012,
	passiveSkill = 12015,
}

--终结者
_tab_item[11012] = {
	type = hVar.ITEM_TYPE.WEAPON_GUN,
	name = "切枪",
	icon = "icon/item/gun_12.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20013,
	passiveSkill = 12016,
}

--流浪者
_tab_item[11013] = {
	type = hVar.ITEM_TYPE.WEAPON_GUN,
	name = "切枪",
	icon = "icon/item/gun_12.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20014,
	passiveSkill = 12017,
}


--瓦力 闪电枪
_tab_item[11015] = {
	type = hVar.ITEM_TYPE.WEAPON_GUN,
	name = "切枪",
	icon = "icon/item/gun_6.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20015,

	passiveSkill = 12009,
	--tacticId = 5105,
}
------------------------------------------------------------------------------------------


--道具技能-机枪
_tab_item[11100] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-机枪",
	icon = "icon/skill/icon6.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	--dropUnit = 20105,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 12000,					--技能id
		lv = 1,								--释放的技能的等级
		count = -1,							--可释放次数， -1表示无限
		cd = {0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--道具技能-散弹枪
_tab_item[11101] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-散弹枪",
	icon = "icon/skill/icon5.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	--dropUnit = 20105,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 12000,					--技能id
		lv = 1,								--释放的技能的等级
		count = -1,							--可释放次数， -1表示无限
		cd = {0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--道具技能-反弹光球
_tab_item[11102] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-反弹光球",
	icon = "icon/skill/icon2.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	--dropUnit = 20105,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 12000,					--技能id
		lv = 1,								--释放的技能的等级
		count = -1,							--可释放次数， -1表示无限
		cd = {0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--道具技能-喷火枪
_tab_item[11103] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-喷火枪",
	icon = "icon/skill/icon3.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	--dropUnit = 20105,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 12000,					--技能id
		lv = 1,								--释放的技能的等级
		count = -1,							--可释放次数， -1表示无限
		cd = {0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--道具技能-透射枪
_tab_item[11104] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-透射枪",
	icon = "icon/skill/icon1.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	--dropUnit = 20105,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 12000,					--技能id
		lv = 1,								--释放的技能的等级
		count = -1,							--可释放次数， -1表示无限
		cd = {0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--道具技能-雷神之锤
_tab_item[11105] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-雷神之锤",
	icon = "icon/skill/icon7.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	--dropUnit = 20105,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 12000,					--技能id
		lv = 1,								--释放的技能的等级
		count = -1,							--可释放次数， -1表示无限
		cd = {0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--道具技能-毒液枪
_tab_item[11106] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-毒液枪",
	icon = "icon/skill/icon3.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	--dropUnit = 20105,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 12000,					--技能id
		lv = 1,								--释放的技能的等级
		count = -1,							--可释放次数， -1表示无限
		cd = {0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--道具技能-缩小枪
_tab_item[11107] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-缩小枪",
	icon = "icon/skill/icon7.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	--dropUnit = 20105,
	dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 12000,					--技能id
		lv = 1,								--释放的技能的等级
		count = -1,							--可释放次数， -1表示无限
		cd = {0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--道具技能-反弹光线
_tab_item[11108] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-反弹光线",
	icon = "icon/skill/icon2.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	--dropUnit = 20105,
	dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 12000,					--技能id
		lv = 1,								--释放的技能的等级
		count = -1,							--可释放次数， -1表示无限
		cd = {0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--道具技能-冲击波
_tab_item[11109] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-冲击波",
	icon = "icon/skill/icon1.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	--dropUnit = 20105,
	dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 12000,					--技能id
		lv = 1,								--释放的技能的等级
		count = -1,							--可释放次数， -1表示无限
		cd = {0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--道具技能-火箭枪
_tab_item[11110] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-火箭枪",
	icon = "icon/skill/icon6.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	--dropUnit = 20105,
	dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 12000,					--技能id
		lv = 1,								--释放的技能的等级
		count = -1,							--可释放次数， -1表示无限
		cd = {0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--道具技能-导弹枪
_tab_item[11111] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-导弹枪",
	icon = "icon/skill/icon5.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	--dropUnit = 20105,
	dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 12000,					--技能id
		lv = 1,								--释放的技能的等级
		count = -1,							--可释放次数， -1表示无限
		cd = {0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--道具技能-终结者
_tab_item[11112] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-终结者",
	icon = "icon/skill/icon5.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	--dropUnit = 20105,
	dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 12000,					--技能id
		lv = 1,								--释放的技能的等级
		count = -1,							--可释放次数， -1表示无限
		cd = {0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--道具技能-流浪者
_tab_item[11113] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-流浪者",
	icon = "icon/skill/icon6.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	--dropUnit = 20105,
	dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 12000,					--技能id
		lv = 1,								--释放的技能的等级
		count = -1,							--可释放次数， -1表示无限
		cd = {0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2,0.2},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}


--道具技能-扔手雷
_tab_item[11200] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-扔手雷",
	icon = "icon/skill/icon4.png",
	--icon_cd = "icon/skill/icon4.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	--dropUnit = 20105,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 12200,					--技能id
		lv = 1,								--释放的技能的等级
		count = -1,							--可释放次数， -1表示无限
		useCount = 1,						--放完几次后才开始转cd
		cd = {1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}



--道具--大血包
_tab_item[12008] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "buff--修理1",
	icon = "ICON:Item_Shoe02",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	dropUnit = 20108,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	passiveSkill = 12002,
}

--道具-小血包
_tab_item[12009] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "buff4-修理2",
	icon = "ICON:Item_Shoe02",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	dropUnit = 20109,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	passiveSkill = 12001,
}

--道具---提升武器等级
_tab_item[12010] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "buff--武器之星LV1-提升武器等级",
	icon = "ICON:Item_Shoe02",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	dropUnit = 20110,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	passiveSkill = 12003,
}

--机甲少女
--道具技能-动感光波
_tab_item[11211] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-动感光波",
	icon = "icon/skill/icon_fag2.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	--dropUnit = 20105,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 12401,					--技能id
		lv = 1,								--释放的技能的等级
		count = -1,							--可释放次数， -1表示无限
		useCount = 1,						--放完几次后才开始转cd
		cd = {3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--机甲少女
--道具技能-普通攻击
_tab_item[11212] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-普通攻击",
	icon = "icon/skill/icon_fag1.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	--dropUnit = 20105,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 12400,					--技能id
		lv = 1,								--释放的技能的等级
		count = -1,							--可释放次数， -1表示无限
		useCount = 1,						--放完几次后才开始转cd
		cd = {1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5,1.5},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}




------------------------------------------------------------------------------------
_tab_item[12013] = {
	type = hVar.ITEM_TYPE.TACTIC_USE,
	name = "道具技能-追踪导弹",
	icon = "effect/buff_n4.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	dropUnit = 20113,
	tacticId = 5001,
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 31000,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

_tab_item[12014] = {
	type = hVar.ITEM_TYPE.TACTIC_USE,
	name = "道具技能-召唤机枪塔",
	icon = "effect/buff_n2.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	dropUnit = 20114,
	tacticId = 5002,
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 31005,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

_tab_item[12015] = {
	type = hVar.ITEM_TYPE.TACTIC_USE,
	name = "道具技能-护盾",
	icon = "effect/buff_n5.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	dropUnit = 20115,
	tacticId = 5003,
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 31010,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

_tab_item[12016] = {
	type = hVar.ITEM_TYPE.TACTIC_USE,
	name = "道具技能-核爆",
	icon = "effect/buff_n1.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	dropUnit = 20116,
	tacticId = 5004,
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 31015,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

_tab_item[12017] = {
	type = hVar.ITEM_TYPE.TACTIC_USE,
	name = "道具技能-召唤导弹塔",
	icon = "effect/buff_n3.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	dropUnit = 20117,
	tacticId = 5005,
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 31020,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
	--passiveSkill = 31020,
}

_tab_item[12018] = {
	type = hVar.ITEM_TYPE.TACTIC_USE,
	name = "道具技能-十字炸弹",
	icon = "effect/buff_n6.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	dropUnit = 20118,
	tacticId = 5006,
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 31025,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

_tab_item[12019] = {
	type = hVar.ITEM_TYPE.TACTIC_USE,
	name = "道具技能-卫星炮",
	icon = "effect/buff_n7.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 0.6,
	dropUnit = 20119,
	tacticId = 5007,
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 31030,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

_tab_item[12020] = {
	type = hVar.ITEM_TYPE.TACTIC_USE,
	name = "道具技能-群体冰冻",
	icon = "effect/buff_n10.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20120,
	tacticId = 5008,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 31035,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

_tab_item[12021] = {
	type = hVar.ITEM_TYPE.TACTIC_USE,
	name = "道具技能-延时炸弹",
	icon = "effect/buff_n9.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20121,
	tacticId = 5010,
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 31045,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

_tab_item[12022] = {
	type = hVar.ITEM_TYPE.TACTIC_USE,
	name = "道具技能-弹射球",
	icon = "effect/buff_n11.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20122,
	tacticId = 5011,
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 31050,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--穿越
--黑洞
_tab_item[12023] = {
	type = hVar.ITEM_TYPE.TACTIC_USE,
	--name = "道具技能-穿越",
	name = "道具技能-黑洞",
	icon = "effect/buff_n12.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20123,
	tacticId = 5012,
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 31055,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--缩小
_tab_item[12024] = {
	type = hVar.ITEM_TYPE.TACTIC_USE,
	name = "道具技能-缩小",
	icon = "effect/buff_n8.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20124,
	tacticId = 5013,
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 31060,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {10000,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--巨浪
_tab_item[12025] = {
	type = hVar.ITEM_TYPE.TACTIC_USE,
	name = "道具技能-巨浪",
	icon = "effect/buff_n13.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20125,
	tacticId = 5014,
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 31070,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--陷阱
_tab_item[12026] = {
	type = hVar.ITEM_TYPE.TACTIC_USE,
	name = "道具技能-陷阱",
	icon = "effect/buff_n14.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20126,
	tacticId = 5015,
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 31090,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--变身机甲少女
_tab_item[12027] = {
	type = hVar.ITEM_TYPE.TACTIC_USE,
	name = "道具技能-变身机甲少女",
	icon = "effect/buff_n15.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20127,
	tacticId = 5016,
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 31040,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--枪塔过载
_tab_item[12028] = {
	type = hVar.ITEM_TYPE.TACTIC_USE,
	name = "道具技能-枪塔过载",
	icon = "effect/buff_n17.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20128,
	tacticId = 5017,
	require = {
		{"level",1},
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 31085,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--召唤铁人
_tab_item[12029] = {
	type = hVar.ITEM_TYPE.TACTIC_USE,
	name = "道具技能-召唤铁人",
	icon = "effect/buff_n18.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20129,
	tacticId = 5018,
	require = {
		{"level",1},
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 31138,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}

--改变数字
_tab_item[12030] = {
	type = hVar.ITEM_TYPE.TACTIC_USE,
	name = "道具技能-改变数字",
	icon = "effect/buff_n20.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20130,
	tacticId = 5019,
	require = {
		{"level",1},
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 17622,					--技能id
		lv = 1,								--释放的技能的等级
		count = 9999,							--可释放次数， -1表示无限
		cd = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.IMMEDIATE,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
	},
}



------------------------------------------------------------------------------------
--高射塔
_tab_item[12100] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-高射塔",
	icon = "icon/item/tower_01.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20200,
	tacticId = 5100,
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 30100,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
		isBuildTower = 1, --标记是建造塔（战术卡界面放左边）
	},
}

--激光塔
_tab_item[12101] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-激光塔",
	icon = "icon/item/tower_02.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20201,
	tacticId = 5101,
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 30102,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
		isBuildTower = 1, --标记是建造塔（战术卡界面放左边）
	},
}

--机枪塔
_tab_item[12102] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-机枪塔",
	icon = "icon/item/tower_03.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20202,
	tacticId = 5102,
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 30104,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
		isBuildTower = 1, --标记是建造塔（战术卡界面放左边）
	},
}

--炮台塔
_tab_item[12103] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-炮台塔",
	icon = "icon/item/tower_04.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20203,
	tacticId = 5103,
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 30106,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
		isBuildTower = 1, --标记是建造塔（战术卡界面放左边）
	},
}

--射击塔
_tab_item[12104] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-射击塔",
	icon = "icon/item/tower_05.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20204,
	tacticId = 5104,
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 30108,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
		isBuildTower = 1, --标记是建造塔（战术卡界面放左边）
	},
}

-----------------------------------------------------------------

--机枪塔
_tab_item[12200] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-机枪塔",
	icon = "icon/item/towergun_1.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20205,
	tacticId = 5200,
	require = {
		{"level",1},
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 30200,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
		isBuildTower = 1, --标记是建造塔（战术卡界面放左边）
	},
}

--散弹枪塔
_tab_item[12201] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-散弹枪塔",
	icon = "icon/item/towergun_2.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20206,
	tacticId = 5201,
	require = {
		{"level",1},
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 30201,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
		isBuildTower = 1, --标记是建造塔（战术卡界面放左边）
	},
}

--喷火枪塔
_tab_item[12202] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-喷火枪塔",
	icon = "icon/item/towergun_3.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20207,
	tacticId = 5202,
	require = {
		{"level",1},
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 30202,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
		isBuildTower = 1, --标记是建造塔（战术卡界面放左边）
	},
}

--透射枪塔
_tab_item[12203] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-透射枪塔",
	icon = "icon/item/towergun_4.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20208,
	tacticId = 5203,
	require = {
		{"level",1},
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 30203,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
		isBuildTower = 1, --标记是建造塔（战术卡界面放左边）
	},
}

--雷神之锤塔
_tab_item[12204] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-雷神之锤塔",
	icon = "icon/item/towergun_5.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20209,
	tacticId = 5204,
	require = {
		{"level",1},
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 30204,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
		isBuildTower = 1, --标记是建造塔（战术卡界面放左边）
	},
}

--冲击波塔
_tab_item[12205] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-冲击波塔",
	icon = "icon/item/towergun_6.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20210,
	tacticId = 5205,
	require = {
		{"level",1},
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 30205,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
		isBuildTower = 1, --标记是建造塔（战术卡界面放左边）
	},
}

--毒枪塔
_tab_item[12206] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-毒枪塔",
	icon = "icon/item/towergun_7.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20211,
	tacticId = 5206,
	require = {
		{"level",1},
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 30206,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
		isBuildTower = 1, --标记是建造塔（战术卡界面放左边）
	},
}

--障碍塔
_tab_item[12207] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-障碍塔",
	icon = "icon/item/tower_container.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20212,
	tacticId = 5207,
	require = {
		{"level",1},
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 30207,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
		isBuildTower = 1, --标记是建造塔（战术卡界面放左边）
	},
}

--金属障碍
_tab_item[12208] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-金属障碍",
	icon = "icon/item/tower_container2.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20213,
	tacticId = 5208,
	require = {
		{"level",1},
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 30208,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
		isBuildTower = 1, --标记是建造塔（战术卡界面放左边）
	},
}

--反弹光线塔
_tab_item[12209] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-反弹光线塔",
	icon = "icon/item/towergun_8.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20214,
	tacticId = 5209,
	require = {
		{"level",1},
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 30209,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
		isBuildTower = 1, --标记是建造塔（战术卡界面放左边）
	},
}

--反弹光球塔
_tab_item[12210] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-反弹光球塔",
	icon = "icon/item/towergun_9.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20215,
	tacticId = 5210,
	require = {
		{"level",1},
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 30210,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
		isBuildTower = 1, --标记是建造塔（战术卡界面放左边）
	},
}

--缩小枪塔
_tab_item[12211] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-缩小枪塔",
	icon = "icon/item/towergun_10.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20216,
	tacticId = 5211,
	require = {
		{"level",1},
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 30211,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
		isBuildTower = 1, --标记是建造塔（战术卡界面放左边）
	},
}

--兵营塔
_tab_item[12212] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "道具技能-兵营塔",
	icon = "icon/item/tower_bunker.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20217,
	tacticId = 5212,
	require = {
		{"level",1},
	},
	--主动释放技能
	activeSkill =								--主动释放的技能
	{
		id = 30212,					--技能id
		lv = 1,								--释放的技能的等级
		count = 1,							--可释放次数， -1表示无限
		cd = {0.5,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15},		--技能cd(单位: 秒)
		type = hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY,		--施法类型
		effectRange = {80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,80},	--技能生效范围
		costMana = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},		--技能资源消耗
		deadUnUse = 1, --英雄死亡后禁止使用(0:死后也可以使用 / 1:死后禁用)
		isBuildTower = 1, --标记是建造塔（战术卡界面放左边）
	},
}







-----------水晶
_tab_item[13000] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "水晶(5)",
	icon = "misc/skillup/mu_coin.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 30000,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--passiveSkill = 9003,
}

_tab_item[13001] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "水晶(6)",
	icon = "misc/skillup/mu_coin.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 30001,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--passiveSkill = 9003,
}

_tab_item[13002] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "水晶(8)",
	icon = "misc/skillup/mu_coin.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 30002,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--passiveSkill = 9003,
}

_tab_item[13003] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "水晶(10)",
	icon = "misc/skillup/mu_coin.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 30003,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--passiveSkill = 9003,
}

_tab_item[13004] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "水晶(15)",
	icon = "misc/skillup/mu_coin.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 30004,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--passiveSkill = 9003,
}

--武器枪宝箱
_tab_item[13005] = {
	type = hVar.ITEM_TYPE.CHEST_WEAPON_GUN,
	name = "武器枪宝箱",
	icon = "icon/item/chest_1.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20155,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--passiveSkill = 9003,
}

--战术卡宝箱
_tab_item[13006] = {
	type = hVar.ITEM_TYPE.CHEST_TACTIC,
	name = "战术卡宝箱",
	icon = "icon/item/chest_2.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20156,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--passiveSkill = 9003,
}

--宠物宝箱
_tab_item[13007] = {
	type = hVar.ITEM_TYPE.CHEST_PET,
	name = "宠物宝箱",
	icon = "icon/item/chest_3.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20157,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--passiveSkill = 9003,
}

--存档点
--存盘点
_tab_item[13008] = {
	type = hVar.ITEM_TYPE.SAVEDATAPOINT,
	name = "存盘点",
	icon = "icon/item/chest_3.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 5197,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--passiveSkill = 9003,
}

--装备宝箱
_tab_item[13009] = {
	type = hVar.ITEM_TYPE.CHEST_EQUIP,
	name = "装备宝箱",
	icon = "icon/item/chest_4.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 20158,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--passiveSkill = 9003,
}

_tab_item[13010] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "水晶(50)",
	icon = "misc/skillup/mu_coin.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 30005,
	--dropUnitLivetime = 25000, --生存时间（毫秒）
	require = {
		{"level",1},
	},
	reward = {
		--
	},
	--passiveSkill = 9003,
}

_tab_item[13011] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "水晶(1)",
	icon = "misc/skillup/mu_coin.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 30006,
	require = {
		{"level",1},
	},
}

_tab_item[13012] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "水晶(2)",
	icon = "misc/skillup/mu_coin.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 30006,
	require = {
		{"level",1},
	},
}

_tab_item[13013] = {
	type = hVar.ITEM_TYPE.FOOT,
	name = "水晶(3)",
	icon = "misc/skillup/mu_coin.png",
	xlobj = "item_ornaments",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 1,
	scale = 1.0,
	dropUnit = 30006,
	require = {
		{"level",1},
	},
}





------------------------------------------------------------------
_tab_item[15000] = 
{
	name = "赵云将魂",
	type = hVar.ITEM_TYPE.SOULSTONE,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "icon/portrait/hero_zhaoyun_s.png",
	heroID = 6000,
}


------------------------------------------------------------------
--普通机枪碎片
_tab_item[15001] = 
{
	name = "普通机枪碎片",
	txt = "txt_gun_1",
	type = hVar.ITEM_TYPE.WEAPONGUNDEBRIS,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "icon/item/gun_1.png",
	weaponId = 6013,
}

--散弹枪碎片
_tab_item[15002] = 
{
	name = "散弹枪碎片",
	txt = "txt_gun_2",
	type = hVar.ITEM_TYPE.WEAPONGUNDEBRIS,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "icon/item/gun_2.png",
	weaponId = 6014,
}

--弹射枪碎片
_tab_item[15003] = 
{
	name = "弹射枪碎片",
	txt = "txt_gun_3",
	type = hVar.ITEM_TYPE.WEAPONGUNDEBRIS,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "icon/item/gun_3.png",
	weaponId = 6007,
}

--火焰枪碎片
_tab_item[15004] = 
{
	name = "火焰枪碎片",
	txt = "txt_gun_4",
	type = hVar.ITEM_TYPE.WEAPONGUNDEBRIS,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "icon/item/gun_4.png",
	weaponId = 6003,
}

--射线枪碎片
_tab_item[15005] = 
{
	name = "射线枪碎片",
	txt = "txt_gun_5",
	type = hVar.ITEM_TYPE.WEAPONGUNDEBRIS,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "icon/item/gun_5.png",
	weaponId = 6006,
}

--闪电枪碎片
_tab_item[15006] = 
{
	name = "闪电枪碎片",
	txt = "txt_gun_6",
	type = hVar.ITEM_TYPE.WEAPONGUNDEBRIS,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "icon/item/gun_6.png",
	weaponId = 6004,
}

--毒液枪碎片
_tab_item[15007] = 
{
	name = "毒液枪碎片",
	txt = "txt_gun_7",
	type = hVar.ITEM_TYPE.WEAPONGUNDEBRIS,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "icon/item/gun_7.png",
	weaponId = 6016,
}

--缩小枪碎片
_tab_item[15008] = 
{
	name = "缩小枪碎片",
	txt = "txt_gun_8",
	type = hVar.ITEM_TYPE.WEAPONGUNDEBRIS,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "icon/item/gun_8.png",
	weaponId = 6017,
}

--镭射枪碎片
_tab_item[15009] = 
{
	name = "镭射枪碎片",
	txt = "txt_gun_9",
	type = hVar.ITEM_TYPE.WEAPONGUNDEBRIS,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "icon/item/gun_9.png",
	weaponId = 6002,
}

--冲击枪碎片
_tab_item[15010] = 
{
	name = "冲击枪碎片",
	txt = "txt_gun_10",
	type = hVar.ITEM_TYPE.WEAPONGUNDEBRIS,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "icon/item/gun_10.png",
	weaponId = 6005,
}

--火箭枪碎片
_tab_item[15011] = 
{
	name = "火箭枪碎片",
	txt = "txt_gun_11",
	type = hVar.ITEM_TYPE.WEAPONGUNDEBRIS,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "icon/item/gun_11.png",
	weaponId = 6008,
}

--导弹枪碎片
_tab_item[15012] = 
{
	name = "导弹枪碎片",
	txt = "txt_gun_12",
	type = hVar.ITEM_TYPE.WEAPONGUNDEBRIS,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "icon/item/gun_12.png",
	weaponId = 6009,
}

--终结者碎片
_tab_item[15013] = 
{
	name = "终结者碎片",
	txt = "txt_gun_13",
	type = hVar.ITEM_TYPE.WEAPONGUNDEBRIS,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "icon/item/gun_13.png",
	weaponId = 6019,
}

--流浪者碎片
_tab_item[15014] = 
{
	name = "流浪者碎片",
	txt = "txt_gun_14",
	type = hVar.ITEM_TYPE.WEAPONGUNDEBRIS,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "icon/item/gun_14.png",
	weaponId = 6020,
}





------------------------------------------------------------------
--瓦力宠物碎片
_tab_item[15101] = 
{
	name = "瓦力宠物碎片",
	txt = "txt_pet",
	type = hVar.ITEM_TYPE.PETDEBRIS,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "icon/item/pet_01.png",
	petId = 13041,
}

--尤达宠物碎片
_tab_item[15102] = 
{
	name = "尤达宠物碎片",
	txt = "txt_pet",
	type = hVar.ITEM_TYPE.PETDEBRIS,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "icon/item/pet_02.png",
	petId = 13042,
}

--支援战机宠物碎片
_tab_item[15103] = 
{
	name = "支援战机宠物碎片",
	txt = "txt_pet",
	type = hVar.ITEM_TYPE.PETDEBRIS,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "icon/item/pet_03.png",
	petId = 13043,
}

--刺蛇宝宝宠物碎片
_tab_item[15104] = 
{
	name = "刺蛇宝宝宠物碎片",
	txt = "txt_pet",
	type = hVar.ITEM_TYPE.PETDEBRIS,
	itemLv = hVar.ITEM_QUALITY.GOLD,
	icon = "icon/item/pet_04.png",
	petId = 13044,
}



------------------------------------------------------------------
--核爆碎片
_tab_item[15201] = {
	type = hVar.ITEM_TYPE.TACTICDEBRIS,
	name = "核爆碎片",
	txt = "txt_tactics_card",
	icon = "effect/buff_n1.png",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	tacticID = 5004,
}

--召唤机枪塔碎片
_tab_item[15202] = {
	type = hVar.ITEM_TYPE.TACTICDEBRIS,
	name = "召唤机枪塔碎片",
	txt = "txt_tactics_card",
	icon = "effect/buff_n2.png",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	tacticID = 5002,
}

--召唤导弹塔碎片
_tab_item[15203] = {
	type = hVar.ITEM_TYPE.TACTICDEBRIS,
	name = "召唤导弹塔碎片",
	txt = "txt_tactics_card",
	icon = "effect/buff_n3.png",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	tacticID = 5005,
}

--追踪导弹碎片
_tab_item[15204] = {
	type = hVar.ITEM_TYPE.TACTICDEBRIS,
	name = "追踪导弹碎片",
	txt = "txt_tactics_card",
	icon = "effect/buff_n4.png",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	tacticID = 5001,
}

--护盾碎片
_tab_item[15205] = {
	type = hVar.ITEM_TYPE.TACTICDEBRIS,
	name = "护盾碎片",
	txt = "txt_tactics_card",
	icon = "effect/buff_n5.png",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	tacticID = 5003,
}

--十字炸弹碎片
_tab_item[15206] = {
	type = hVar.ITEM_TYPE.TACTICDEBRIS,
	name = "十字炸弹碎片",
	txt = "txt_tactics_card",
	icon = "effect/buff_n6.png",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	tacticID = 5006,
}

--卫星炮碎片
_tab_item[15207] = {
	type = hVar.ITEM_TYPE.TACTICDEBRIS,
	name = "卫星炮碎片",
	txt = "txt_tactics_card",
	icon = "effect/buff_n7.png",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	tacticID = 5007,
}

--缩小碎片
_tab_item[15208] = {
	type = hVar.ITEM_TYPE.TACTICDEBRIS,
	name = "缩小碎片",
	txt = "txt_tactics_card",
	icon = "effect/buff_n8.png",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	tacticID = 5013,
}

--延时炸弹碎片
_tab_item[15209] = {
	type = hVar.ITEM_TYPE.TACTICDEBRIS,
	name = "延时炸弹碎片",
	txt = "txt_tactics_card",
	icon = "effect/buff_n9.png",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	tacticID = 5010,
}

--冰冻碎片
_tab_item[15210] = {
	type = hVar.ITEM_TYPE.TACTICDEBRIS,
	name = "冰冻碎片",
	txt = "txt_tactics_card",
	icon = "effect/buff_n10.png",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	tacticID = 5008,
}

--弹射球碎片
_tab_item[15211] = {
	type = hVar.ITEM_TYPE.TACTICDEBRIS,
	name = "弹射球碎片",
	txt = "txt_tactics_card",
	icon = "effect/buff_n11.png",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	tacticID = 5011,
}

--黑洞碎片
_tab_item[15212] = {
	type = hVar.ITEM_TYPE.TACTICDEBRIS,
	name = "黑洞碎片",
	txt = "txt_tactics_card",
	icon = "effect/buff_n12.png",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	tacticID = 5012,
}

--巨浪碎片
_tab_item[15213] = {
	type = hVar.ITEM_TYPE.TACTICDEBRIS,
	name = "巨浪碎片",
	txt = "txt_tactics_card",
	icon = "effect/buff_n13.png",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	tacticID = 5014,
}

--变身机甲少女碎片
_tab_item[15214] = {
	type = hVar.ITEM_TYPE.TACTICDEBRIS,
	name = "变身机甲少女碎片",
	txt = "txt_tactics_card",
	icon = "effect/buff_n13.png",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	tacticID = 5016,
}









---------------------------------------------------------------------
--模板
--AK47（可升级）
_tab_item[19000] = {
	type = hVar.ITEM_TYPE.MOUNT,
	name = "AK47（可升级）",
	icon = "ICON:Item_Horse01",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	maxQuality = 5,	--最高品质
	itemValue = 5,
	scale = 0.6,
	reward = {
		[1] = {"hp_max", "10+@lv*10"}, --血量
		[2] = {"atk", {"10+@lv*10", "10+@lv*10"}}, --攻击力（最小、最大都加）
		[3] = {"move_speed", "10+@lv*10"}, --移动速度
		[4] = {"dodge_rate", "10+@lv*10"}, --闪避几率（去掉百分号之后的值）
		[5] = {"crit_rate", "10+@lv*10"}, --手雷暴击几率（去掉百分号之后的值）
		[6] = {"crit_value", "1+@lv*0.1"}, --手雷暴击倍数（支持小数）
		
		[7] = {"atk_ice", "1+@lv*0.1"}, --冰攻击力
		[8] = {"atk_thunder", "1+@lv*0.1"}, --雷攻击力
		[9] = {"atk_fire", "1+@lv*0.1"}, --火攻击力
		[10] = {"atk_poison", "1+@lv*0.1"}, --毒攻击力
		[11] = {"atk_bullet", "1+@lv*0.1"}, --子弹攻击力
		[12] = {"atk_bomb", "1+@lv*0.1"}, --爆炸攻击力
		[13] = {"atk_chuanci", "1+@lv*0.1"}, --穿刺攻击力
		
		[14] = {"def_ice", "1+@lv*0.1"}, --冰防御
		[15] = {"def_thunder", "1+@lv*0.1"}, --雷防御
		[16] = {"def_fire", "1+@lv*0.1"}, --火防御
		[17] = {"def_poison", "1+@lv*0.1"}, --毒防御
		[18] = {"def_bullet", "1+@lv*0.1"}, --子弹防御
		[19] = {"def_bomb", "1+@lv*0.1"}, --爆炸防御
		[20] = {"def_chuanci", "1+@lv*0.1"}, --穿刺防御
		
		[21] = {"bullet_capacity", "1+@lv*0.1"}, --携弹数量
		[22] = {"grenade_capacity", "1+@lv*0.1"}, --手雷数量
		[23] = {"grenade_child", "1+@lv*0.1"}, --子母雷数量
		[24] = {"inertia", "1+@lv*0.1"}, --惯性
		[25] = {"crystal_rate", "@lv*0.1"}, --水晶收益率（去百分号后的值）
		[26] = {"grenade_cd", "@lv*0.1"}, --手雷冷却时间（单位：毫秒）
		[27] = {"melee_bounce", "@lv*0.1"}, --近战弹开
		[28] = {"melee_fight", "@lv*0.1"}, --近战反击
		[29] = {"melee_stone", "@lv*0.1"}, --近战碎石
		[30] = {"pet_hp_restore", "@lv*0.1"}, --宠物回血
		[31] = {"pet_capacity", "@lv*0.1"}, --宠物携带数量
		[32] = {"trap_ground", "@lv*0.1"}, --陷阱持续时间（单位：毫秒）
		[33] = {"trap_groundcd", "@lv*0.1"}, --陷阱施法间隔（单位：毫秒）
		[34] = {"trap_groundenemy", "@lv*0.1"}, --陷阱困敌时间（单位：毫秒）
		[35] = {"trap_fly", "@lv*0.1"}, --天网持续时间（单位：毫秒）
		[36] = {"trap_flycd", "@lv*0.1"}, --天网施法间隔（单位：毫秒）
		[37] = {"trap_flyenemy", "@lv*0.1"}, --天网困敌时间（单位：毫秒）
		[38] = {"puzzle", "@lv*0.1"}, --迷惑几率（去百分号后的值）
		[39] = {"basic_weapon_level", "@lv*1"}, --武器等级
		[40] = {"weapon_crit_shoot", "@lv*1"}, --射击暴击
		[41] = {"weapon_crit_frozen", "@lv*1"}, --冰冻暴击
		[42] = {"weapon_crit_fire", "@lv*1"}, --火焰暴击
		[43] = {"weapon_crit_hit", "@lv*1"}, --击退暴击
		[44] = {"weapon_crit_blow", "@lv*1"}, --吹风暴击
		[45] = {"weapon_crit_poison", "@lv*1"}, --毒液暴击
		[46] = {"weapon_crit_equip", "@lv*1"}, --装备暴击
		
	},
	
	--skillId = {
		--{id = 15014, lv = "@lv", cd = 15000},
	--},
	
	unlockSkill = {
		--技能1
		[1] = {
			id = 11000,
			maxLv = 1,
			cd = 15000,
			require =
			{
				--升1级
				[1] =
				{
					material = {
						{materialId = 10001, materialNum = 10,}, --棒子材料
						{materialId = 10002, materialNum = 10,}, --阿三材料
					},
					score = 1000,
					rmb = 10,
					requireItemLv = 10, --需求道具等级
				},
			},
		},
		
		----技能2
		--[2] = ...
	},
	
	randskill = {		
		randnum = {0,2,},--随机属性个数
		{12001,1,5},
		{12002,1,5},
		{12003,1,5},
		{12004,1,5},
	},
}

--战车道具
--王尼玛-测试装备
_tab_item[20000] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_105.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 10,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_frozen",
	reward = {
		[1] = {"hp_max", 9999}, --生命值
		[2] = {"atk_bullet", "1000+@quality*2"}, --子弹攻击力
		[3] = {"move_speed", 999}, --移动速度
		[4] = {"hp_restore",1000}, --回血
		[5] = {"pet_hp_restore", 999}, --宠物回血
	},
	skillId = {
		--{id = 32116, lv = 1, cd = 350},
		{id = 32118, lv = 1, cd = 100},
	},
}


--宠物派遣挖矿
_tab_item[20025] = 
{
	name = "宠物派遣挖矿",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物派遣挖体力
_tab_item[20026] = 
{
	name = "宠物派遣挖体力",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物取消派遣挖矿
_tab_item[20027] = 
{
	name = "宠物取消派遣挖矿",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物取消派遣挖体力
_tab_item[20028] = 
{
	name = "宠物取消派遣挖体力",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物兑换体力
_tab_item[20029] = 
{
	name = "宠物兑换体力",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物领取挖矿氪石
_tab_item[20030] = 
{
	name = "宠物领取挖矿氪石",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物领取挖矿体力
_tab_item[20031] = 
{
	name = "宠物领取挖矿体力",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--战车复活
_tab_item[20032] = 
{
	name = "战车复活",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--雕像重抽一次
_tab_item[20033] = 
{
	name = "雕像重抽一次",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--宠物领取挖矿宝箱
_tab_item[20034] = 
{
	name = "宠物领取挖矿宝箱",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}

--邮件领取体力
_tab_item[20035] = 
{
	name = "邮件领取体力",
	type = hVar.ITEM_TYPE.RESOURCES,
	itemLv = hVar.ITEM_QUALITY.WHITE,
	icon = "ICON:skill_icon1_x13y2",
}




---------------------------------------------------------------------------------

--20100~20199白
--水晶雷达
_tab_item[20101] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_118.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"crystal_rate",3,5},
	},
}

--战车道具
--装填电机
_tab_item[20102] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_112.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"grenade_cd",-30,-50},
	},
}

--战车道具
--刀片轮毂
_tab_item[20103] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_121.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"melee_fight",20,35},
	},
}

--战车道具
--反应装甲
_tab_item[20104] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_115.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"hp_max",90,150},
	},
}

--战车道具
--涡轮引擎
_tab_item[20105] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_006.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"move_speed",5,8},
	},
}

--合金装甲
_tab_item[20106] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_007.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"def_physic",1,2},
	},
}

--防火装甲
_tab_item[20107] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_102.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"def_fire",1,2},
	},
}

_tab_item[20108] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_103.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"def_thunder",1,2},
	},
}

_tab_item[20109] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_104.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"def_poison",1,2},
	},
}

_tab_item[20110] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_013.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"pet_hp_restore",9,15},
	},
}
_tab_item[20111] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_012.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"atk_bullet",1,2},
	},
}

_tab_item[20112] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_091.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	reward = {
		[1] = {"weapon_crit_poison",3,}, 
	},
}

_tab_item[20113] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_092.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	reward = {
		[1] = {"weapon_crit_frozen",3,}, 
	},
}

_tab_item[20114] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_093.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	reward = {
		[1] = {"weapon_crit_blow",3,}, 
	},
}

_tab_item[20115] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_094.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	reward = {
		[1] = {"weapon_crit_fire",3,}, 
	},
}

_tab_item[20116] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_095.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	reward = {
		[1] = {"weapon_crit_hit",3,}, 
	},
}

_tab_item[20117] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_096.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	reward = {
		[1] = {"weapon_crit_shoot",3,}, 
	},
}
--20100~20199白
--水晶雷达
_tab_item[20121] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_053.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	reward = {
		[1] = {"crystal_rate", 9,},
	},
}

--战车道具
--改良装填电机
_tab_item[20122] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_113.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	reward = {
		[1] = {"grenade_cd", -100,}, --手雷冷却时间（单位：毫秒）
	},
}

--战车道具
--焰形尖刺
_tab_item[20123] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_055.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	reward = {
		[1] = {"melee_fight",45,},
	},
}

--战车道具
--合金装甲
_tab_item[20124] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_056.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	reward = {
		[1] = {"hp_max",200,},
	},
}

--战车道具
--涡轮引擎
_tab_item[20125] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_057.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	reward = {
		[1] = {"move_speed",20,},
	},
}

--钛合金装甲
_tab_item[20126] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_015.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	reward = {
		[1] = {"def_physic",5,},
	},
}

--水冷装置
_tab_item[20127] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_058.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	reward = {
		[1] = {"def_fire",5,}, 
	},
}

_tab_item[20128] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_059.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	reward = {
		[1] = {"def_thunder",5,}, 
	},
}

_tab_item[20129] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_060.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	reward = {
		[1] = {"def_poison",5,}, 
	},
}

_tab_item[20130] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_061.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	reward = {
		[1] = {"pet_hp_restore",30,}, 
	},
}
_tab_item[20131] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_062.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	reward = {
		[1] = {"atk_bullet",3,}, 
	},
}

_tab_item[20132] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_077.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	reward = {
		[1] = {"pet_hp",200,}, 
	},
}

_tab_item[20133] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_108.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	reward = {
		[1] = {"pet_atk",12,}, 
	},
}

_tab_item[20134] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_107.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.WHITE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	reward = {
		[1] = {"pet_atk_speed",5,}, 
	},
}
--20200~20300蓝
--水晶雷达
_tab_item[20201] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_119.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"crystal_rate",6,8},
	},
}

--战车道具
--装填电机
_tab_item[20202] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_113.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"grenade_cd",-60,-80},
	},
}

--战车道具
--刀片轮毂
_tab_item[20203] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_122.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"melee_fight",40,60},
	},
}

--战车道具
--反应装甲
_tab_item[20204] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_116.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"hp_max",160,220},
	},
}

--战车道具
--涡轮引擎
_tab_item[20205] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_006.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"move_speed",9,12},
	},
}

--合金装甲
_tab_item[20206] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_007.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"def_physic",3,4},
	},
}

--防火装甲
_tab_item[20207] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_030.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"def_fire",3,4},
	},
}

_tab_item[20208] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_031.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"def_thunder",3,4},
	},
}

_tab_item[20209] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_032.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"def_poison",3,4},
	},
}

_tab_item[20210] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_013.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"pet_hp_restore",18,24},
	},
}
_tab_item[20211] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_012.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"atk_bullet",3,4},
	},
}

--火控芯片
_tab_item[20212] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_038.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	reward = {
		[1] = {"atk_bullet", "2"}, --子弹攻击力
	},
	
	randreward = {		
		randnum = {1,3},--随机属性个数
		{"move_speed",30,50},
		{"def_physic",5,15},
		{"def_thunder",1,5},
	},
	
	skillId = {
		{id = 32102, lv = 1, cd = 999999},
	},
}

--装填电机
_tab_item[20213] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_002.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	reward = {
		[1] = {"grenade_cd", "-300",}, --手雷冷却时间（单位：毫秒）
	},
}

_tab_item[20214] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_050.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	skillId = {
		{id = 32101, lv = 1, cd = 6000},
	},
}
_tab_item[20215] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_065.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	skillId = {
		{id = 32104, lv = 1, cd = 25000},
	},
}

_tab_item[20216] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_063.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	skillId = {
		{id = 32103, lv = 1, cd = 10000},
	},
}
_tab_item[20217] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_064.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	skillId = {
		{id = 32016, lv = 1, cd = 12000},
	},
}


_tab_item[20218] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_082.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	skillId = {
		{id = 32036, lv = 1, cd = 12000},
	},
}

--灭火器1
_tab_item[20219] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_097.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	skillId = {
		{id = 32041, lv = 1, cd = 5000},
	},
}


_tab_item[20220] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_109.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"pet_hp",250,300},
	},
}

_tab_item[20221] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_110.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"pet_atk",15,20},
	},
}

_tab_item[20222] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_111.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.BLUE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"pet_atk_speed",6,9},
	},
}

--20300~20400黄
--水晶雷达
_tab_item[20301] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_120.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"crystal_rate",9,12},
	},
}

--战车道具
--装填电机
_tab_item[20302] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_114.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"grenade_cd",-90,-120},
	},
}

--战车道具
--刀片轮毂
_tab_item[20303] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_123.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"melee_fight",70,90},
	},
}

--战车道具
--反应装甲
_tab_item[20304] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_116.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"hp_max",240,300},
	},
}

--战车道具
--涡轮引擎
_tab_item[20305] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_006.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"move_speed",13,16},
	},
}

--合金装甲
_tab_item[20306] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_007.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"def_physic",5,6},
	},
}

--防火装甲
_tab_item[20307] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_030.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {2,2},--随机属性个数
		{"def_physic",1,2},
		{"def_fire",3,5},
	},
}

_tab_item[20308] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_031.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {2,2},--随机属性个数
		{"def_physic",1,2},
		{"def_thunder",3,5},
	},
}

_tab_item[20309] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_032.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {2,2},--随机属性个数
		{"def_physic",1,2},
		{"def_poison",3,5},
	},
}

_tab_item[20310] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_013.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"pet_hp_restore",36,48},
	},
}

_tab_item[20311] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_012.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {2,2},--随机属性个数
		{"basic_weapon_level",1,1},
		{"atk_bullet",3,5},
	},
}

_tab_item[20312] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_037.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"hp_max",120,180},
	},
	skillId = {
		{id = 32101, lv = 1, cd = 4000},
	},
}

--骤雨
_tab_item[20313] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_038.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"atk_bullet",2,4},
	},
	skillId = {
		{id = 32113, lv = 1, cd = 999999},
	},
}

_tab_item[20314] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_039.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_ysj",
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"melee_fight",40,60},
	},
	skillId = {
		{id = 32103, lv = 1, cd = 6000},
	},
}

_tab_item[20315] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_040.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_ysj",
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"def_physic",2,3},
	},
	skillId = {
		{id = 32104, lv = 1, cd = 15000},
	},
}


--飞星
_tab_item[20316] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_041.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"atk_bullet",3,5},
	},
	skillId = {
		{id = 32106, lv = 1, cd = 999999},
	},
}


---多管火箭
_tab_item[20317] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_042.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"atk_bullet",3,5},
	},
	skillId = {
		{id = 32107, lv = 1, cd = 8000},
	},
}

_tab_item[20318] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_043.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {2,2},--随机属性个数
		{"def_physic",1,2},
		{"hp_max",70,150},
	},
	skillId = {
		{id = 32109, lv = 1, cd = 9000},
	},
}

_tab_item[20319] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_078.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"def_poison",5,9},
	},
	skillId = {
		{id = 32035, lv = 1, cd = 12000},
	},
}

_tab_item[20320] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_068.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"def_physic",5,9},
	},
	skillId = {
		{id = 32115, lv = 1, cd = 7000},
	},
}

--毒液轮
_tab_item[20321] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_101.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {2,2},--随机属性个数
		{"move_speed",10,15},
		{"def_poison",3,5},
	},
	skillId = {
		{id = 32040, lv = 1, cd = 999999},
	},
}
--灭火器2
_tab_item[20322] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_098.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"def_fire",3,5},
	},
	skillId = {
		{id = 32041, lv = 1, cd = 3000},
	},
}

_tab_item[20323] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_085.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {2,2},--随机属性个数
		{"pet_hp",250,300},
		{"pet_hp_restore",18,27},
	},
}

_tab_item[20324] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_088.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {2,2},--随机属性个数
		{"pet_atk",12,20},
		{"pet_atk_speed",6,9},
	},
}
--20400~20500红
--寒渊
_tab_item[20400] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_025.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	--txt = "txt_ftjp",
	randreward = {		
		randnum = {2,3},--随机属性个数
		{"trap_ground",1000,1500},
		{"trap_groundcd",-1500,-1000},
		{"trap_groundenemy",1000,1500},
	},
	skillId = {
		{id = 32000, lv = 1, cd = 12000},
	},
}

--战车道具
--光幕
_tab_item[20401] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_011.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	--txt = "txt_sdj",
	randreward = {		
		randnum = {2,3},--随机属性个数
		{"def_thunder",6,12},
		{"def_fire",6,12},
		{"def_poison",6,12},
		{"def_physic",6,12},
	},
	skillId = {
		{id = 32001, lv = 1, cd = 15000},
	},
}


--战车道具
--元素剑
_tab_item[20402] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_014.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	--txt = "txt_ysj",
	randreward = {		
		randnum = {2,2},--随机属性个数
		{"atk_bullet",5,9},
		{"melee_fight",100,150},
	},
	skillId = {
		{id = 32002, lv = 1, cd = 7000},
	},
}

--战车道具
--艾德曼合金装甲
_tab_item[20403] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_027.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	--txt = "txt_zjd",
	randreward = {		
		randnum = {2,2},--随机属性个数
		{"def_physic",6,12},
		{"hp_max",300,450},
	},
	skillId = {
		{id = 32003, lv = 1, cd = 2000},
	},
}

--战车道具
--艾德曼合金轮毂
_tab_item[20404] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_026.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_shoot",
	randreward = {		
		randnum = {3,3},--随机属性个数
		{"def_physic",4,7},
		{"melee_bounce",20,30},
		{"melee_fight",80,120},
	},
	skillId = {
		{id = 32005, lv = 1, cd = 3000},
	},
}

--战车道具
--暴风雨
_tab_item[20405] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_045.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_frozen",
	randreward = {		
		randnum = {2,2},--随机属性个数
		{"atk_bullet",3,6},
		{"grenade_cd",-150,-100},
	},
	skillId = {
		{id = 32008, lv = 1, cd = 999999},
	},
}

--战车道具
--猩红闪电
_tab_item[20406] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_048.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {2,2},--随机属性个数
		{"basic_weapon_level",1,2},
		{"atk_bullet",5,8},
	},
	skillId = {
		{id = 32009, lv = 1, cd = 999999},
	},
}


--战车道具
--RPG
_tab_item[20407] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_028.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {2,2},--随机属性个数
		{"atk_bullet",6,9},
		{"hp_max",180,240},
	},
	skillId = {
		{id = 32010, lv = 1, cd = 999999},
	},
}

--方舟核心
_tab_item[20408] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_035.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {3,4},--随机属性个数
		{"basic_weapon_level",1,2},
		{"atk_bullet",4,7},
		{"melee_fight",80,120},
		{"grenade_cd",-150,-100},
		{"move_speed",12,20},
	},
}
--布雷机
_tab_item[20409] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_036.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {3,3},--随机属性个数
		{"move_speed",12,20},
		{"def_physic",4,7},
		{"hp_max",120,180},
	},
	skillId = {
		{id = 32011, lv = 1, cd = 2000},
	},
}

_tab_item[20410] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_044.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {3,3},--随机属性个数
		{"def_physic",3,5},
		{"def_thunder",4,7},
		{"hp_max",150,220},
	},
	skillId = {
		{id = 32110, lv = 1, cd = 7000},
	},
}

_tab_item[20411] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_049.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {2,2},--随机属性个数
		{"pet_hp_restore",24,36},
		{"melee_fight",80,120},
		{"puzzle",2,3},
	},
	skillId = {
		{id = 32114, lv = 1, cd = 9000},
	},
}


--超新星
_tab_item[20412] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_089.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {2,2},--随机属性个数
		{"atk_bullet",5,8},
		{"grenade_cd",-100,-50},
	},
	skillId = {
		{id = 32027, lv = 1, cd = 999999},
	},
}
--震荡波
_tab_item[20413] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_066.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {3,3},--随机属性个数
		{"melee_fight",80,120},
		{"move_speed",8,16},
		{"def_physic",6,12},
	},
	skillId = {
		{id = 32028, lv = 1, cd = 999999},
	},
}
--镭射+弹射光线
_tab_item[20414] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_079.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {3,3},--随机属性个数
		{"atk_bullet",5,8},
		{"basic_weapon_level",1,2},
		{"def_thunder",3,5},
	},
	skillId = {
		{id = 32030, lv = 1, cd = 999999},
	},
}

--毒枪
_tab_item[20415] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_080.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {3,3},--随机属性个数
		{"weapon_crit_poison",5,8},
		{"atk_bullet",6,9},
		{"def_poison",6,12},
	},
	skillId = {
		{id = 32031, lv = 1, cd = 999999},
	},
}

--瘟疫使者
_tab_item[20416] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_074.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {3,3},--随机属性个数
		{"def_poison",9,15},
		{"grenade_cd",-100,-50},
		{"hp_max",120,180},
	},
	skillId = {
		{id = 32032, lv = 1, cd = 9000},
	},
}

--
_tab_item[20417] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_090.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {1,1},--随机属性个数
		{"grenade_cd",-150,-100},
	},
	skillId = {
		{id = 32037, lv = 1, cd = 999999},
	},
}


--风火轮
_tab_item[20418] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_100.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	randreward = {		
		randnum = {2,2},--随机属性个数
		{"move_speed",20,30},
		{"def_fire",6,9},
	},
	skillId = {
		{id = 32039, lv = 1, cd = 999999},
	},
}

--灭火器3
_tab_item[20419] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_099.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {2,2},--随机属性个数
		{"def_fire",5,7},
		{"hp_max",200,300},
	},
	skillId = {
		{id = 32041, lv = 1, cd = 1000},
	},
}

_tab_item[20420] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_065.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 3,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {2,2},--随机属性个数
		{"grenade_cd",-150,-100},
		{"hp_max",200,300},
	},
	skillId = {
		{id = 32042, lv = 1, cd = 1000},
	},
}

_tab_item[20421] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_106.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {3,4},--随机属性个数
		{"pet_atk",18,30},
		{"pet_atk_speed",6,12},
		{"pet_hp",300,500},
		{"pet_hp_restore",27,48},
	},
}
_tab_item[20422] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_124.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 1,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {3,3},--随机属性个数
		{"pet_atk_speed",6,12},
		{"pet_hp",300,500},
		{"puzzle",1,2},
	},
	skillId = {
		{id = 32047, lv = 1, cd = 999999},
	},
}

---充值礼包红装
_tab_item[20480] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_008.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	reward = {
		[1] = {"basic_weapon_level", 1,}, --手雷冷却时间（单位：毫秒）
		[2] = {"def_physic", 6,},
		[3] = {"def_poison", 6,},
	},
	skillId = {
		{id = 32016, lv = 1, cd = 3000},
	},
}

_tab_item[20481] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_047.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	reward = {
		[1] = {"atk_bullet", 6,}, 
		[2] = {"grenade_cd", -150,}, 
		[3] = {"inertia", 15,}, 
	},
	skillId = {
		{id = 32111, lv = 1, cd = 15000},
	},
}

_tab_item[20482] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_125.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	reward = {
		[1] = {"atk_bullet", 12,}, 
		[2] = {"weapon_crit_frozen",7,}, 
		[3] = {"weapon_crit_fire",7,}, 
		[4] = {"weapon_crit_blow",7,}, 
		[5] = {"weapon_crit_poison",7,}, 
	},
}

_tab_item[20483] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_033.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	reward = {
		[1] = {"atk_bullet", 6,}, 
		[2] = {"def_fire", 5,}, 
		[3] = {"def_poison", 5,}, 
		[4] = {"def_physic", 5,}, 

	},
	skillId = {
		{id = 32117, lv = 1, cd = 12000},
	},
}

_tab_item[20484] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_124.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	reward = {
		[1] = {"pet_atk_speed", 12,}, 
		[2] = {"pet_hp",500,}, 
		[3] = {"puzzle",2,}, 
	},
	skillId = {
		{id = 32117, lv = 1, cd = 9000},
	},
}

--[[战车道具

_tab_item[20406] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_033.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.ORANGE,
	itemValue = 5,
	maxQuality = 5,	--最高品质
	scale = 0.6,
	--txt = "txt_crit_fire",
	randreward = {		
		randnum = {2,2},--随机属性个数
		{"basic_weapon_level",1,2},
		{"atk_bullet",5,8},
	},
	skillId = {
		{id = 32016, lv = 1, cd = 3000},
	},
}









--天网
_tab_item[20314] = {
	type = hVar.ITEM_TYPE.MOUNT,
	icon = "icon/item/item_024.png",
	xlobj = "item_horse",
	itemLv = hVar.ITEM_QUALITY.GOLD,
	itemValue = 5,
	maxQuality = 7,	--最高品质
	scale = 0.6,
	reward = {
		[1] = {"trap_fly","10000+@quality*200",}, --天网持续时间（单位：毫秒）
		[2] = {"trap_flycd", "-@quality*500"}, --天网施法间隔（单位：毫秒）
		[3] = {"trap_flyenemy", "@quality*500"}, --天网困敌时间（单位：毫秒）
	},
}
-]]
