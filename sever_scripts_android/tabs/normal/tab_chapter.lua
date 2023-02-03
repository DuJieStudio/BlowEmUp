hVar.tab_chapter = {}
local _tab_chapter = hVar.tab_chapter
--为了让 gird框架 可以显示 0 索引的 skill icon 故 在这里做一个 看不见的空 icon

_tab_chapter[0] = {
	icon = "MODEL:default"
	--template = "RangeAttack",		--施展方式：移动施展(UnitAttack),远程全屏施展(RangeAtack)
	--cast_sort = 5,			--如果本技能为自动施展，或者条件触发，那么会根据此数值调整在队列中的顺序，自大向小排列
	--enhanceID = {1},			--如果本技能会从其他技能得到强化，那么把强化的技能id填写在这里
	--cooldown = 0,				--技能的冷却回合
	--manacost = 1,				--技能的法力消耗
	--_manacost = 1,			--特定效果计算法力消耗时，可使用此数值代替manacost（连锁施法，疯魔，范围闪避）
	--count = 1,				--技能的限定施展次数(不填为无限次,-1则为初始没有堆叠，需要后续添加次数)
	--maxcount = 1,				--技能的最大施放次数(不填则和count一致)
	--enhanceParam = {{"@name",100}},	--如果本技能会强化其他技能，那么把强化技能的param写在这里
	--counterID = 0,			--如果单位普攻技能为此技能，那么会使用该ID进行反击,-1无法反击
	--encounterID = 0,			--如果单位普攻技能为此技能，且技能施展方式为远程，那么当被包围时会使用该ID进行替换攻击,-1无法攻击
	--area = {1,1},				--技能的作用范围，例如爆炸范围
	--range = {1,2},			--技能的施展范围，可对a~b格内的敌人施展(自身算0格)，近战技能才有效
	--target = {"ENEMY"},			--技能允许的作用目标:[所有(ALL)],[自身(SELF),OTHER(非自身)],[友军(ALLY),敌人(ENEMY)],[建筑(BUILDING),单位(UNIT)]
	--targetEX = {"FIGHTER",5000},		--技能允许的作用目标ex，仅TargetArea有效，填写单位分类或单位id
	--activemode = 1,			--技能如果存在Active,则激活受此效果限制。1.每回合限1次 2.每回合可激活多次 3.每回合可激活多次，并且等待也能激活
	--cast_check = 1,			--如果此值为1,那么在CastSkill时必须检测目标是否满足target类型
	--trigger_mode = 1,			--如果此值为1,那么条件触发(SetAssist)时必定触发,无视眩晕状态
	--target_mode = 0,			--如果此值为1,那么在CastSkill时，所用的targetC会设置为当前target，否则会设置为父技能的targetC
	--tip = {{},{}},			--如果有此项，那么将会尝试替换技能说明中的[P1],[P2]字符串
}

--第1章 机械蜘蛛
_tab_chapter[1] =
{
	background = "misc/button_null",
	map = "town/select_map1",
	icon = "icon/xlobj/spider04.png",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/yxys_spider_01", --第一关
	lastmap = "world/yxys_spider_04", --最后一关
	endlessMap = {},
	camera = --镜头控制
	{
		--默认镜头位置
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
	mapX = 1350+256, --摆放物件在地图上的坐标X
	mapY = 720, --摆放物件在地图上的坐标Y
	mapFacing = 90, --摆放物件在地图上的面向角度
}

--第2章 飞船
_tab_chapter[2] =
{
	background = "misc/button_null",
	map = "town/select_map1",
	icon = "icon/xlobj/airship04.png",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/yxys_airship_01", --第一关
	lastmap = "world/yxys_airship_04", --最后一关
	endlessMap = {},
	camera = --镜头控制
	{
		--默认镜头位置
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
	mapX = 1630+256, --摆放物件在地图上的坐标X
	mapY = 690, --摆放物件在地图上的坐标Y
	mapFacing = 90, --摆放物件在地图上的面向角度
}

--第3章 虫族
_tab_chapter[3] =
{
	background = "misc/button_null",
	map = "town/select_map1",
	icon = "icon/xlobj/zerg04.png",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/yxys_zerg_001", --第一关
	lastmap = "world/yxys_zerg_004", --最后一关
	endlessMap = {},
	camera = --镜头控制
	{
		--默认镜头位置
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
	mapX = 1830+256, --摆放物件在地图上的坐标X
	mapY = 500, --摆放物件在地图上的坐标Y
	mapFacing = 90, --摆放物件在地图上的面向角度
}

--第4章 生化大眼睛
_tab_chapter[4] =
{
	background = "misc/button_null",
	map = "town/select_map1",
	icon = "icon/xlobj/bio01.png",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/yxys_bio_001", --第一关
	lastmap = "world/yxys_bio_004", --最后一关
	endlessMap = {},
	camera = --镜头控制
	{
		--默认镜头位置
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
	mapX = 2090+256, --摆放物件在地图上的坐标X
	mapY = 460, --摆放物件在地图上的坐标Y
	mapFacing = 90, --摆放物件在地图上的面向角度
}

--第5章 机械飞船
_tab_chapter[5] =
{
	background = "misc/button_null",
	map = "town/select_map1",
	icon = "icon/xlobj/mechanics04.png",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/yxys_mechanics_001", --第一关
	lastmap = "world/yxys_mechanics_004", --最后一关
	endlessMap = {},
	camera = --镜头控制
	{
		--默认镜头位置
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
	mapX = 2030+256, --摆放物件在地图上的坐标X
	mapY = 650, --摆放物件在地图上的坐标Y
	mapFacing = 0, --摆放物件在地图上的面向角度
}

--第6章 飞碟
_tab_chapter[6] =
{
	background = "misc/button_null",
	map = "town/select_map1",
	icon = "icon/xlobj/plate04.png",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/yxys_plate_01", --第一关
	lastmap = "world/yxys_plate_04", --最后一关
	endlessMap = {},
	camera = --镜头控制
	{
		--默认镜头位置
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
	mapX = 2020+256, --摆放物件在地图上的坐标X
	mapY = 850, --摆放物件在地图上的坐标Y
	mapFacing = 270, --摆放物件在地图上的面向角度
}

--[[
--第7章 尤达
_tab_chapter[6] =
{
	background = "misc/button_null",
	map = "town/select_map1",
	icon = "icon/xlobj/plate04.png",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/yxys_yoda_01", --第一关
	lastmap = "world/yxys_yoda_02", --最后一关
	endlessMap = {},
	camera = --镜头控制
	{
		--默认镜头位置
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
	mapX = 3492, --摆放物件在地图上的坐标X
	mapY = 3228, --摆放物件在地图上的坐标Y
	mapFacing = 90, --摆放物件在地图上的面向角度
}
]]

--第7章 瓦力
_tab_chapter[7] =
{
	background = "misc/button_null",
	map = "town/select_map1",
	icon = "icon/xlobj/plate04.png",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/yxys_walle_001", --第一关
	lastmap = "world/yxys_walle_004", --最后一关
	endlessMap = {},
	camera = --镜头控制
	{
		--默认镜头位置
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
	mapX = 3492, --摆放物件在地图上的坐标X
	mapY = 3228, --摆放物件在地图上的坐标Y
	mapFacing = 90, --摆放物件在地图上的面向角度
}

--第8章 尤达
_tab_chapter[8] =
{
	background = "misc/button_null",
	map = "town/select_map1",
	icon = "icon/xlobj/plate04.png",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/yxys_yoda_01", --第一关
	lastmap = "world/yxys_yoda_04", --最后一关
	endlessMap = {},
	camera = --镜头控制
	{
		--默认镜头位置
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
	mapX = 3492, --摆放物件在地图上的坐标X
	mapY = 3228, --摆放物件在地图上的坐标Y
	mapFacing = 90, --摆放物件在地图上的面向角度
}



















--第99章 黑龙vip
_tab_chapter[99] =
{
	background = "town/tback_blackdragon_nest",
	map = "town/blackdragon_nest",
	scrollW = 2768,
	scrollH = 2768,
	firstmap = "world/csys_001", --第一关
	lastmap = "world/csys_006", --最后一关
	endlessMap = {},
	camera = --镜头控制
	{
		--默认镜头位置
		[1] =
		{
			["mapName"] = 0,
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
		
		--通关"剿灭黄巾"后的镜头位置
		[2] =
		{
			["mapName"] = "world/td_009_jmhj",
			["pad"] = {dx = 0, dy = 0,},
			["phone"] = {dx = 0, dy = 0,},
		},
	},
}

