--地图目标表 在uiInit 中初始化
hVar.MAP_INTENT = {}
hVar.MAP_INFO = {}
hVar.MAP_LEGION = {}
hVar.MAP_AI = {}
hVar.MAP_COLLECT_GARBAGE_PERWAVE = {}
--地图信息表 uniqueID 键值千万不要重复否则会造成玩家地图成就表项的缺失
--切记其中地图包不能拥有 uniqueID 同时必须拥有 childmap 项来描述此地图包所包含的地图
--此处的ID必须连续的数字，而且不能占数字以后待用！mazheng 2015 5 29


--非洲难民
hVar.MAP_INFO["world/td_001"] =
{
	mapType = 4,
	uniqueID = 1,
	level = 1,
	chapter = 1,
	nextmap = {"world/dark_002"},
	thumbnail = "misc/thumb_td_demo.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = "fight_base_02", --背景音乐
	
	scoreV = 70,
	exp = 60,
}


hVar.MAP_LEGION["world/td_001"] =
{
	[1] = {1,"__TEXT_Liubei"},
	[2] = {2,"__TEXT_HuangjinArmy"},
}

hVar.MAP_INFO["world/dark_002"] =
{
	mapType = 4,
	uniqueID = 2,
	level = 2,
	chapter = 1,
	nextmap = {"world/dark_003"},
	thumbnail = "misc/thumb_td_demo.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = "fight_base_02", --背景音乐
	
	scoreV = 70,
	exp = 65,
}


hVar.MAP_LEGION["world/dark_002"] =
{
	[1] = {1,"__TEXT_Liubei"},
	[2] = {2,"__TEXT_HuangjinArmy"},
}

hVar.MAP_INFO["world/dark_003"] =
{
	mapType = 4,
	uniqueID = 3,
	level = 3,
	chapter = 1,
	nextmap = {"world/dark_004"},
	thumbnail = "misc/thumb_td_demo.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = "fight_base_02", --背景音乐
	
	scoreV = 70,
	exp = 60,
}


hVar.MAP_LEGION["world/dark_003"] =
{
	[1] = {1,"__TEXT_Liubei"},
	[2] = {2,"__TEXT_HuangjinArmy"},
}


hVar.MAP_INFO["world/yqzc_001"] =
{
	mapType = 4,
	uniqueID = 4,
	level = 4,
	chapter = 1,
	nextmap = {"world/yqzc_001"},
	thumbnail = "misc/thumb_td_demo.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = "ResidentEvil", --背景音乐
	
	scoreV = 70,
	exp = 60,
	
	--使用地形底图类型(区分大小写,需与文件命名一致),s01 = 废土 + 草丛的经典风格
	terrainType = {"world/s01_rand001","world/s01_rand002","world/s01_rand003",},

	--地图随机场景
	randomSceneObj = {
		--最大物件数量
		maxNum = 50,
		--物件之间最小间隔，最小值为0
		minDistance = 12,
		--物件列表
		--sobjPool = {1, 2, 3, 4, 3, 4 ,3, 4 ,3, 4 ,3, 4 ,3, 4 ,3, 4 ,3, 4 ,3, 4 , 5, 6},
		sobjPool = {1,2,3,4,5,6,7,8,9,10,11},
	},

	--怪物掉落表
	publicDrop = {
		
		["pt"] = {
			totalValue = 306,	--掉落总权值
			pool = {
				{value = 1, id = {11000}}, --闪电弹
				{value = 1, id = {11001}}, --穿透弹
				{value = 1, id = {11002}}, --喷火
				{value = 1, id = {11003}}, --激光
				{value = 1, id = {11004}}, --高斯射线
				{value = 1, id = {11006}}, --离子炮
				{value = 1, id = {11007}}, --高斯机枪
				{value = 1, id = {11008}}, --高斯机枪
				{value = 3, id = {11016}}, --疯狂扫射
				{value = 3, id = {11017}}, --群体冰冻
				{value = 3, id = {11018}}, --超级子弹
				{value = 3, id = {11020}}, --加速
				{value = 3, id = {11021}}, --回血
				{value = 1, id = {12000}}, --移动速度
				{value = 1, id = {12001}}, --生命上限
				{value = 1, id = {12002}}, --冲刺距离
				{value = 1, id = {12003}}, --冲刺冷却
				{value = 1, id = {12004}}, --手雷冷却
				{value = 1, id = {12005}}, --蜘蛛雷冷却
				{value = 1, id = {12006}}, --蜘蛛雷伤害
				--{value = 6, id = {11023}}, --获得5个手雷
				{value = 6, id = {12030}}, --加魔法
				{value = 270, id = "NA"}, --无
			},
		},
		
		--[[
		--测试 --test
		["pt"] = {
			totalValue = 6,	--掉落总权值
			pool = {
				{value = 1, id = {11000}}, --闪电弹
				{value = 1, id = {11001}}, --穿透弹
				{value = 1, id = {11002}}, --喷火
				{value = 1, id = {11003}}, --激光
				{value = 1, id = {11004}}, --高斯射线
				{value = 1, id = {12007}}, --加魔法
			},
		},
		]]
		
		["boss"] = {
			totalValue = 36,	--掉落总权值
			pool = {
				{value = 1, id = {11000}}, --闪电弹
				{value = 1, id = {11001}}, --穿透弹
				{value = 1, id = {11002}}, --喷火
				{value = 1, id = {11003}}, --激光
				{value = 1, id = {11004}}, --高斯射线
				{value = 1, id = {11006}}, --离子炮
				{value = 1, id = {11007}}, --高斯机枪
				{value = 1, id = {11008}}, --高斯机枪
				{value = 3, id = {11016}}, --疯狂扫射
				{value = 3, id = {11017}}, --群体冰冻
				{value = 3, id = {11018}}, --超级子弹
				{value = 3, id = {11020}}, --加速
				{value = 3, id = {11021}}, --回血
				{value = 1, id = {12000}}, --移动速度
				{value = 1, id = {12001}}, --生命上限
				{value = 1, id = {12002}}, --冲刺距离
				{value = 1, id = {12003}}, --冲刺冷却
				{value = 1, id = {12004}}, --手雷冷却
				{value = 1, id = {12005}}, --蜘蛛雷冷却
				{value = 1, id = {12006}}, --蜘蛛雷伤害
				--{value = 6, id = {11023}}, --获得5个手雷
				{value = 6, id = {12030}}, --加魔法
			},
		},
	},
}


hVar.MAP_INFO["world/yqzc_001b"] =
{
	mapType = 4,
	uniqueID = 4,
	level = 4,
	chapter = 1,
	nextmap = {"world/yqzc_001b"},
	thumbnail = "misc/thumb_td_demo.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = "ResidentEvil", --背景音乐
	
	scoreV = 70,
	exp = 60,
	
	publicDrop = {
		["pt"] = {
			totalValue = 306,	--掉落总权值
			pool = {
				{value = 1, id = {11000}}, --闪电弹
				{value = 1, id = {11001}}, --穿透弹
				{value = 1, id = {11002}}, --喷火
				{value = 1, id = {11003}}, --激光
				{value = 1, id = {11004}}, --高斯射线
				{value = 1, id = {11006}}, --离子炮
				{value = 1, id = {11007}}, --高斯机枪
				{value = 1, id = {11008}}, --高斯机枪
				{value = 3, id = {11016}}, --疯狂扫射
				{value = 3, id = {11017}}, --群体冰冻
				{value = 3, id = {11018}}, --超级子弹
				{value = 3, id = {11020}}, --加速
				{value = 3, id = {11021}}, --回血
				{value = 1, id = {12000}}, --移动速度
				{value = 1, id = {12001}}, --生命上限
				{value = 1, id = {12002}}, --冲刺距离
				{value = 1, id = {12003}}, --冲刺冷却
				{value = 1, id = {12004}}, --手雷冷却
				{value = 1, id = {12005}}, --蜘蛛雷冷却
				{value = 1, id = {12006}}, --蜘蛛雷伤害
				--{value = 6, id = {11023}}, --获得5个手雷
				{value = 6, id = {12030}}, --加魔法
				{value = 270, id = "NA"}, --无
			},
		},
		["boss"] = {
			totalValue = 36,	--掉落总权值
			pool = {
				{value = 1, id = {11000}}, --闪电弹
				{value = 1, id = {11001}}, --穿透弹
				{value = 1, id = {11002}}, --喷火
				{value = 1, id = {11003}}, --激光
				{value = 1, id = {11004}}, --高斯射线
				{value = 1, id = {11006}}, --离子炮
				{value = 1, id = {11007}}, --高斯机枪
				{value = 1, id = {11008}}, --高斯机枪
				{value = 3, id = {11016}}, --疯狂扫射
				{value = 3, id = {11017}}, --群体冰冻
				{value = 3, id = {11018}}, --超级子弹
				{value = 3, id = {11020}}, --加速
				{value = 3, id = {11021}}, --回血
				{value = 1, id = {12000}}, --移动速度
				{value = 1, id = {12001}}, --生命上限
				{value = 1, id = {12002}}, --冲刺距离
				{value = 1, id = {12003}}, --冲刺冷却
				{value = 1, id = {12004}}, --手雷冷却
				{value = 1, id = {12005}}, --蜘蛛雷冷却
				{value = 1, id = {12006}}, --蜘蛛雷伤害
				--{value = 6, id = {11023}}, --获得5个手雷
				{value = 6, id = {12030}}, --加魔法
				--{value = 6, id = {11023}}, --获得5个手雷
			},
		},
	},
}



hVar.MAP_INFO["world/yqzc_002"] =
{
	mapType = 4,
	uniqueID = 5,
	level = 5,
	chapter = 1,
	nextmap = {"world/yqzc_002"},
	thumbnail = "misc/thumb_td_demo.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = "ResidentEvil", --背景音乐
	
	scoreV = 70,
	exp = 60,
	
	--地图随机场景
	randomSceneObj = {
		--最大物件数量
		maxNum = 50,
		--物件之间最小间隔，最小值为0
		minDistance = 12,
		--物件列表
		--sobjPool = {1, 2, 3, 4, 3, 4 ,3, 4 ,3, 4 ,3, 4 ,3, 4 ,3, 4 ,3, 4 ,3, 4 , 5, 6},
		sobjPool = {10,11,12,13,14,15,16,17},
	},

	--怪物掉落表
	publicDrop = {
		["pt"] = {
			totalValue = 306,	--掉落总权值
			pool = {
				{value = 1, id = {11000}}, --闪电弹
				{value = 1, id = {11001}}, --穿透弹
				{value = 1, id = {11002}}, --喷火
				{value = 1, id = {11003}}, --激光
				{value = 1, id = {11004}}, --高斯射线
				{value = 1, id = {11006}}, --离子炮
				{value = 1, id = {11007}}, --高斯机枪
				{value = 1, id = {11008}}, --高斯机枪
				{value = 3, id = {11016}}, --疯狂扫射
				{value = 3, id = {11017}}, --群体冰冻
				{value = 3, id = {11018}}, --超级子弹
				{value = 3, id = {11020}}, --加速
				{value = 3, id = {11021}}, --回血
				{value = 1, id = {12000}}, --移动速度
				{value = 1, id = {12001}}, --生命上限
				{value = 1, id = {12002}}, --冲刺距离
				{value = 1, id = {12003}}, --冲刺冷却
				{value = 1, id = {12004}}, --手雷冷却
				{value = 1, id = {12005}}, --蜘蛛雷冷却
				{value = 1, id = {12006}}, --蜘蛛雷伤害
				--{value = 6, id = {11023}}, --获得5个手雷
				{value = 6, id = {12030}}, --加魔法
				{value = 270, id = "NA"}, --无
			},
		},
		["boss"] = {
			totalValue = 36,	--掉落总权值
			pool = {
				{value = 1, id = {11000}}, --闪电弹
				{value = 1, id = {11001}}, --穿透弹
				{value = 1, id = {11002}}, --喷火
				{value = 1, id = {11003}}, --激光
				{value = 1, id = {11004}}, --高斯射线
				{value = 1, id = {11006}}, --离子炮
				{value = 1, id = {11007}}, --高斯机枪
				{value = 1, id = {11008}}, --高斯机枪
				{value = 3, id = {11016}}, --疯狂扫射
				{value = 3, id = {11017}}, --群体冰冻
				{value = 3, id = {11018}}, --超级子弹
				{value = 3, id = {11020}}, --加速
				{value = 3, id = {11021}}, --回血
				{value = 1, id = {12000}}, --移动速度
				{value = 1, id = {12001}}, --生命上限
				{value = 1, id = {12002}}, --冲刺距离
				{value = 1, id = {12003}}, --冲刺冷却
				{value = 1, id = {12004}}, --手雷冷却
				{value = 1, id = {12005}}, --蜘蛛雷冷却
				{value = 1, id = {12006}}, --蜘蛛雷伤害
				{value = 6, id = {12030}}, --加魔法
			},
		},
	},
}

hVar.MAP_INFO["world/yqzc_test"] =
{
	mapType = 4,
	uniqueID = 6,
	level = 6,
	chapter = 1,
	nextmap = {"world/yqzc_test"},
	thumbnail = "misc/thumb_td_demo.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = "ResidentEvil", --背景音乐
	
	scoreV = 70,
	exp = 60,
	
	--使用地形底图类型(区分大小写,需与文件命名一致),s01 = 废土 + 草丛的经典风格
	terrainType = {"world/indoor_base_01",},
	
	--地图随机场景
	randomSceneObj = {
		--物件位置检测模式(0 圆形检测,1 矩形检测),默认为0 圆形检测
		checkMode = 1,
		--最大物件数量
		maxNum = 25,
		--物件之间最小间隔，最小值为0
		minDistance = 40,
		--随机物件位置在地图上下左右边界偏移
		border = {150,170,50,50},
		--物件列表
		--sobjPool = {1, 2, 3, 4, 3, 4 ,3, 4 ,3, 4 ,3, 4 ,3, 4 ,3, 4 ,3, 4 ,3, 4 , 5, 6},
		sobjPool = {19,20,21,22,23},
	},

	--怪物掉落表
	publicDrop = {
		["pt"] = {
			totalValue = 306,	--掉落总权值
			pool = {
				{value = 1, id = {11000}}, --闪电弹
				{value = 1, id = {11001}}, --穿透弹
				{value = 1, id = {11002}}, --喷火
				{value = 1, id = {11003}}, --激光
				{value = 1, id = {11004}}, --高斯射线
				{value = 1, id = {11006}}, --离子炮
				{value = 1, id = {11007}}, --高斯机枪
				{value = 1, id = {11008}}, --高斯机枪
				{value = 3, id = {11016}}, --疯狂扫射
				{value = 3, id = {11017}}, --群体冰冻
				{value = 3, id = {11018}}, --超级子弹
				{value = 3, id = {11020}}, --加速
				{value = 3, id = {11021}}, --回血
				{value = 1, id = {12000}}, --移动速度
				{value = 1, id = {12001}}, --生命上限
				{value = 1, id = {12002}}, --冲刺距离
				{value = 1, id = {12003}}, --冲刺冷却
				{value = 1, id = {12004}}, --手雷冷却
				{value = 1, id = {12005}}, --蜘蛛雷冷却
				{value = 1, id = {12006}}, --蜘蛛雷伤害
				{value = 6, id = {12030}}, --加魔法
				{value = 270, id = "NA"}, --无
			},
		},
		["boss"] = {
			totalValue = 36,	--掉落总权值
			pool = {
				{value = 1, id = {11000}}, --闪电弹
				{value = 1, id = {11001}}, --穿透弹
				{value = 1, id = {11002}}, --喷火
				{value = 1, id = {11003}}, --激光
				{value = 1, id = {11004}}, --高斯射线
				{value = 1, id = {11006}}, --离子炮
				{value = 1, id = {11007}}, --高斯机枪
				{value = 1, id = {11008}}, --高斯机枪
				{value = 3, id = {11016}}, --疯狂扫射
				{value = 3, id = {11017}}, --群体冰冻
				{value = 3, id = {11018}}, --超级子弹
				{value = 3, id = {11020}}, --加速
				{value = 3, id = {11021}}, --回血
				{value = 1, id = {12000}}, --移动速度
				{value = 1, id = {12001}}, --生命上限
				{value = 1, id = {12002}}, --冲刺距离
				{value = 1, id = {12003}}, --冲刺冷却
				{value = 1, id = {12004}}, --手雷冷却
				{value = 1, id = {12005}}, --蜘蛛雷冷却
				{value = 1, id = {12006}}, --蜘蛛雷伤害
				{value = 6, id = {12030}}, --加魔法
			},
		},
	},
}


------【战车关卡如下】-------------------------------------------------------------------------------------------


hVar.MAP_INFO["world/csys_001"] =
{
	mapType = 4,
	uniqueID = 7,
	level = 7,
	chapter = 1,
	nextmap = {"world/csys_002"},
	thumbnail = "misc/selectmap_1.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 70,
	
	--经验值
	exp = 120,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 15, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 75, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 100, id = {12022}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 100, id = {12017,}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["mgbox_0"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12010}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/csys_002"] =
{
	mapType = 4,
	uniqueID = 8,
	level = 8,
	chapter = 1,
	nextmap = {"world/csys_003"},
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 130,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 15, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 75, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/csys_003"] =
{
	mapType = 4,
	uniqueID = 9,
	level = 9,
	chapter = 1,
	nextmap = {"world/csys_004"},
	thumbnail = "misc/selectmap_3.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 210,
	
	--经验值
	exp = 130,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 300, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 3, id = {12008}}, --强化星
				{value = 6, id = {12009}}, --加血
				{value = 5, id = {12010}}, --强化星
				{value = 89, id = "NA"}, --无
			},
		},
		["ptex"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 100, id = {12008}}, --强化星
				{value = 100, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/csys_004"] =
{
	mapType = 4,
	uniqueID = 10,
	level = 10,
	chapter = 1,
	nextmap = {"world/csys_005"},
	thumbnail = "misc/selectmap_4.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 350,
	
	--经验值
	exp = 130,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 300, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 15, id = {12008}}, --强化星
				{value = 15, id = {12010}}, --强化星
				{value = 15, id = {12009}}, --加血
				{value = 70, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 100, id = {12013}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/csys_005"] =
{
	mapType = 4,
	uniqueID = 11,
	level = 11,
	chapter = 1,
	nextmap = {"world/csys_006"},
	thumbnail = "misc/selectmap_5.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 660,
	
	--经验值
	exp = 130,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 420, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 3, id = {12008}}, --强化星
				{value = 9, id = {12009}}, --加血
				{value = 6, id = {12010}}, --强化星
				{value = 85, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/csys_006"] =
{
	mapType = 4,
	uniqueID = 12,
	level = 12,
	chapter = 1,
	nextmap = {"world/endless_001"},
	thumbnail = "misc/selectmap_6.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 1010,
	
	--经验值
	exp = 130,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 2, id = {12009}}, --加血
				{value = 1, id = {12010}}, --强化星
				{value = 97, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/start_001"] =
{
	mapType = 4,
	uniqueID = 13,
	level = 13,
	chapter = 1,
	nextmap = {"world/csys_001"},
	thumbnail = "misc/thumb_td_demo.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/base_01", "music/base_02", "music/base_03",}, --背景音乐
	
	--积分
	scoreV = 70,
	
	--经验值
	exp = 130,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 2, id = {12009}}, --加血
				{value = 1, id = {12010}}, --强化星
				{value = 97, id = "NA"}, --无
			},
		},
		["ptex"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 25, id = {12008}}, --强化星
				{value = 50, id = {12009}}, --加血
				{value = 50, id = {12010}}, --强化星
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12020,12021,12022,12023}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["boss"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12009}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
	},
}

--随机迷宫
--随机地图
hVar.MAP_INFO["world/csys_random_test"] =
{
	mapType = 4,
	uniqueID = 14,
	level = 14,
	chapter = 1,
	nextmap = {"world/csys_001a"},
	thumbnail = "misc/selectmap_6.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
		
	--积分
	scoreV = 70,
	
	--经验值
	exp = 130,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 5, id = {12009}}, --加血
				{value = 1, id = {12008}}, --加血
				{value = 1, id = {12010}}, --强化星
				--{value = 6, id = {13005,13007,13009}}, --宝箱
				{value = 93, id = "NA"}, --无
			},
		},
		["elite"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {13005,13007,13009}}, --宝箱
			},
		},
		["boss"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 10, id = {13000}},
				{value = 15, id = {13001}},
				{value = 20, id = {13002}},
				{value = 15, id = {13003}},
				{value = 10, id = {13004}},
				{value = 30, id = {13005,13007,13009}}, --宝箱
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 5, id = {12009}}, --加血
				{value = 1, id = {12008}}, --加血
				{value = 1, id = {12010}},--强化星
				{value = 5, id = {12013,12014,12015,12016,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --道具卡
				{value = 1, id = {11000,11001,11002,11003,11004,11005,11006,11007,11008,11009}},--切枪
				--{value = 2, id = {13005,13007,13009}}, --宝箱
				{value = 87, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 10, id = {12010}},--强化星
				{value = 90, id = {12013,12014,12015,12016,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --道具卡
			},
		},
		["trap_1"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, dropAll = true, id = {12008,12009,12009,12009}}, --加血
			},
		},
		["trap_2"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 15, id = {13000}},
				{value = 20, id = {13001}},
				{value = 35, id = {13002}},
				{value = 20, id = {13003}},
				{value = 10, id = {13004}},
			},
		},
		["crystal"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 15, id = {13000}},
				{value = 20, id = {13001}},
				{value = 30, id = {13002}},
				{value = 20, id = {13003}},
				{value = 15, id = {13004}},
			},
		},
	},
	
	--每层对应的敌人战术卡
	diffTacticByStage =
	{
		[1] = {},
		[2] = {{1201, 1,},{1202, 1,},},
		[3] = {{1201, 3,},{1202, 3,},},
		[4] = {{1201, 5,},{1202, 5,},},
		[5] = {{1201, 7,},{1202, 7,},},
		[6] = {{1201, 10,},{1202, 10,},},
		[7] = {{1201, 13,},{1202, 13,},},
		[8] = {{1201, 16,},{1202, 16,},},
		[9] = {{1201, 19,},{1202, 19,},},
		[10] = {{1201, 20,},{1202, 20,},},
		[11] = {{1201, 22,},{1202, 22,},},
		[12] = {{1201, 24,},{1202, 24,},},
		[13] = {{1201, 26,},{1202, 26,},},
		[14] = {{1201, 28,},{1202, 28,},},
		[15] = {{1201, 30,},{1202, 30,},},
		[16] = {{1201, 32,},{1202, 32,},},
		[17] = {{1201, 34,},{1202, 34,},},
		[18] = {{1201, 36,},{1202, 36,},},
		[19] = {{1201, 38,},{1202, 38,},},
		[20] = {{1201, 40,},{1202, 40,},},
	},
	
	--每层敌人掉落道具的倍率（默认值1.0）
	diffEnemyDropRatio =
	{
		[1] = 0.5,
		[2] = 0.6,
		[3] = 0.7,
		[4] = 0.8,
		[5] = 0.9,
		[6] = 1.0,
		[7] = 1.0,
		[8] = 1.0,
		[9] = 1.0,
		[10] = 1.0,
		[11] = 1.0,
		[12] = 1.0,
		[13] = 1.0,
		[14] = 1.0,
		[15] = 1.0,
		[16] = 1.0,
		[17] = 1.0,
		[18] = 1.0,
		[19] = 1.0,
		[20] = 1.0,
	},
}

--随机地图（用户自定义地图）
hVar.MAP_INFO["world/csys_random_test_userdef"] =
{
	mapType = 4,
	uniqueID = 14,
	level = 14,
	chapter = 1,
	nextmap = {"world/csys_001a"},
	thumbnail = "misc/selectmap_6.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
		
	--积分
	scoreV = 70,
	
	--经验值
	exp = 130,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 5, id = {12009}}, --加血
				{value = 1, id = {12008}}, --加血
				--{value = 10, id = {12010}}, --强化星
				{value = 6, id = {13005,13007,13009}}, --宝箱
				{value = 88, id = "NA"}, --无
			},
		},
		["elite"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {13005,13007,13009}}, --宝箱
			},
		},
		["boss"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 10, id = {13000}},
				{value = 15, id = {13001}},
				{value = 30, id = {13002}},
				{value = 15, id = {13003}},
				{value = 10, id = {13004}},
				{value = 20, id = {13005,13007,13009}}, --宝箱
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 5, id = {12009}}, --加血
				{value = 1, id = {12008}}, --加血
				{value = 1, id = {12010}},--强化星
				{value = 10, id = {12013,12014,12015,12016,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --道具卡
				{value = 1, id = {11000,11001,11002,11003,11004,11005,11006,11007,11008,11009}},--切枪
				{value = 2, id = {13005,13007,13009}}, --宝箱
				{value = 80, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 10, id = {12010}},--强化星
				{value = 90, id = {12013,12014,12015,12016,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --道具卡
			},
		},
		["trap_1"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, dropAll = true, id = {12008,12009,12009,12009}}, --加血
			},
		},
		["trap_2"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 15, id = {13000}},
				{value = 20, id = {13001}},
				{value = 35, id = {13002}},
				{value = 20, id = {13003}},
				{value = 10, id = {13004}},
			},
		},
		["crystal"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 15, id = {13000}},
				{value = 20, id = {13001}},
				{value = 30, id = {13002}},
				{value = 20, id = {13003}},
				{value = 15, id = {13004}},
			},
		},
	},
	
	--每层对应的敌人战术卡
	diffTacticByStage =
	{
		[1] = {},
		[2] = {{1201, 1,},{1202, 1,},},
		[3] = {{1201, 3,},{1202, 3,},},
		[4] = {{1201, 5,},{1202, 5,},},
		[5] = {{1201, 7,},{1202, 7,},},
		[6] = {{1201, 10,},{1202, 10,},},
		[7] = {{1201, 13,},{1202, 13,},},
		[8] = {{1201, 16,},{1202, 16,},},
		[9] = {{1201, 19,},{1202, 19,},},
		[10] = {{1201, 20,},{1202, 20,},},
		[11] = {{1201, 20,},{1202, 20,},},
		[12] = {{1201, 20,},{1202, 20,},},
		[13] = {{1201, 20,},{1202, 20,},},
		[14] = {{1201, 20,},{1202, 20,},},
		[15] = {{1201, 20,},{1202, 20,},},
	},
}

hVar.MAP_INFO["world/csys_001a"] =
{
	mapType = 4,
	uniqueID = 15,
	level = 15,
	chapter = 1,
	nextmap = {"world/csys_002"},
	thumbnail = "misc/selectmap_1.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 70,
	
	--经验值
	exp = 120,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 15, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 75, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["mgbox_0"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12010}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/csys_001b"] =
{
	mapType = 4,
	uniqueID = 16,
	level = 16,
	chapter = 1,
	nextmap = {"world/csys_002"},
	thumbnail = "misc/selectmap_1.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 70,
	
	--经验值
	exp = 120,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 15, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 75, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["mgbox_0"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12010}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/csys_002a"] =
{
	mapType = 4,
	uniqueID = 17,
	level = 17,
	chapter = 1,
	nextmap = {"world/csys_003"},
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 130,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 15, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 75, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/csys_002b"] =
{
	mapType = 4,
	uniqueID = 18,
	level = 18,
	chapter = 1,
	nextmap = {"world/csys_003"},
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 130,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 15, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 75, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/csys_003a"] =
{
	mapType = 4,
	uniqueID = 19,
	level = 19,
	chapter = 1,
	nextmap = {"world/csys_004"},
	thumbnail = "misc/selectmap_3.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 210,
	
	--经验值
	exp = 130,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 300, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 3, id = {12008}}, --强化星
				{value = 6, id = {12009}}, --加血
				{value = 5, id = {12010}}, --强化星
				{value = 89, id = "NA"}, --无
			},
		},
		["ptex"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 100, id = {12008}}, --强化星
				{value = 100, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/csys_003b"] =
{
	mapType = 4,
	uniqueID = 20,
	level = 20,
	chapter = 1,
	nextmap = {"world/csys_004"},
	thumbnail = "misc/selectmap_3.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 210,
	
	--经验值
	exp = 130,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 300, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 3, id = {12008}}, --强化星
				{value = 6, id = {12009}}, --加血
				{value = 5, id = {12010}}, --强化星
				{value = 89, id = "NA"}, --无
			},
		},
		["ptex"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 100, id = {12008}}, --强化星
				{value = 100, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, dropAll = false, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/csys_004a"] =
{
	mapType = 4,
	uniqueID = 21,
	level = 21,
	chapter = 1,
	nextmap = {"world/csys_005"},
	thumbnail = "misc/selectmap_4.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 350,
	
	--经验值
	exp = 130,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 300, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 15, id = {12008}}, --强化星
				{value = 15, id = {12010}}, --强化星
				{value = 15, id = {12009}}, --加血
				{value = 70, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/csys_004b"] =
{
	mapType = 4,
	uniqueID = 22,
	level = 22,
	chapter = 1,
	nextmap = {"world/csys_005"},
	thumbnail = "misc/selectmap_4.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 350,
	
	--经验值
	exp = 130,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 300, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 15, id = {12008}}, --强化星
				{value = 15, id = {12010}}, --强化星
				{value = 15, id = {12009}}, --加血
				{value = 70, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/csys_005a"] =
{
	mapType = 4,
	uniqueID = 23,
	level = 23,
	chapter = 1,
	nextmap = {"world/csys_006"},
	thumbnail = "misc/selectmap_5.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 660,
	
	--经验值
	exp = 130,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 420, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 3, id = {12008}}, --强化星
				{value = 9, id = {12009}}, --加血
				{value = 6, id = {12010}}, --强化星
				{value = 85, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/csys_005b"] =
{
	mapType = 4,
	uniqueID = 24,
	level = 24,
	chapter = 1,
	nextmap = {"world/csys_006"},
	thumbnail = "misc/selectmap_5.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 660,
	
	--经验值
	exp = 130,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 420, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 3, id = {12008}}, --强化星
				{value = 9, id = {12009}}, --加血
				{value = 6, id = {12010}}, --强化星
				{value = 85, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/csys_006a"] =
{
	mapType = 4,
	uniqueID = 25,
	level = 25,
	chapter = 1,
	nextmap = {"world/endless_001"},
	thumbnail = "misc/selectmap_6.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
		
	--积分
	scoreV = 1010,
	
	--经验值
	exp = 130,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 2, id = {12009}}, --加血
				{value = 1, id = {12010}}, --强化星
				{value = 97, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/csys_006b"] =
{
	mapType = 4,
	uniqueID = 26,
	level = 26,
	chapter = 1,
	nextmap = {"world/endless_001"},
	thumbnail = "misc/selectmap_6.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
		
	--积分
	scoreV = 1010,
	
	--经验值
	exp = 130,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 2, id = {12009}}, --加血
				{value = 1, id = {12010}}, --强化星
				{value = 97, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

--动画关
hVar.MAP_INFO["world/csys_000"] =
{
	mapType = 4,
	uniqueID = 27,
	level = 10027,
	chapter = 1,
	nextmap = {"world/csys_001"},
	thumbnail = "misc/selectmap_1.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	roomObjId = 104, --宇宙背景风格部件id
	
	--积分
	scoreV = 70,
	
	--经验值
	exp = 120,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 30, id = {12009}}, --加血
				--{value = 30, id = {12010}}, --强化星
				{value = 70, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12010}}, --强化星
				--{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024}}, --强化星
				--{value = 100, id = {12017,}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["mgbox_0"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12010}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["mgbox_1"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12013}}, --导弹
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				--{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 1, id = {13005,13007}}, --宝箱
				{value = 100, id = "NA"}, --无
			},
		},
		["money"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {13010}},
			},
		},
	},
}

hVar.MAP_INFO["world/csys_001c"] =
{
	mapType = 4,
	uniqueID = 28,
	level = 28,
	chapter = 1,
	nextmap = {"world/csys_002"},
	thumbnail = "misc/selectmap_1.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 70,
	
	--经验值
	exp = 120,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 15, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 75, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 100, id = {12017,}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["mgbox_0"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12010}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/csys_ex_001"] =
{
	mapType = 4,
	uniqueID = 29,
	level = 29,
	chapter = 1,
	nextmap = {"world/csys_ex_002"},
	thumbnail = "misc/selectmap_1.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 70,
	
	--经验值
	exp = 120,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = "NA"}, --无
				--{value = 100, id = {12013}}, --强化星
			},
		},
		["item"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12013,12014,12015,12016,12017,12018,12019,12020,12021,12022,12023,12024,12025}},
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12027}}, --强化星
				--{value = 100, id = {11000,11001,11002,11003,11004,11005,11006,11007,11008,11009}},--切枪
				--{value = 100, id = {13005,13007}}, --宝箱
				--{value = 90, id = "NA"}, --无
				--{value = 100, id = {12017},}, --瓦力
				--{value = 100, id = {12016},}, --存盘点
			},
		},
	},
}

hVar.MAP_INFO["world/csys_ex_002_randommap"] =
{
	mapType = 4,
	uniqueID = 30,
	level = 30,
	chapter = 1,
	nextmap = {"world/endless_001"},
	thumbnail = "misc/selectmap_1.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/base_01", "music/base_02", "music/base_03",}, --背景音乐
	
	--积分
	scoreV = 70,
	
	--经验值
	exp = 120,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["item"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12013,12014,12015,12016,12017,12018,12019,12020,12021,12022,12023,12024,12025}},
			},
		},
	},
}

--母巢之战
--塔防图
hVar.MAP_INFO["world/yxys_ex_001"] =
{
	mapType = 4,
	uniqueID = 31,
	level = 31,
	chapter = 1,
	nextmap = {"world/yxys_ex_001"},
	thumbnail = "misc/selectmap_1.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 70,
	
	--经验值
	exp = 120,
	
	DiffMode =
	{
		--最大难度
		maxDiff = 20,
		
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,1},
				{1202,1},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 20, 0, 0,},
				{101, 15002, 20, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 1, 0, 0,},
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
			},
			
		},
		
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,2},
				{1202,2},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 25, 0, 0,},
				{101, 15002, 25, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 1, 0, 0,},
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
			},
		},
		
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,3},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 30, 0, 0,},
				{101, 15002, 30, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 1, 0, 0,},
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
			},
		},
		
		--每个难度的配置
		[4] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,4},
				{1202,4},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 35, 0, 0,},
				{101, 15002, 35, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{10, 1, 0, 0,},
				{10, 2, 0, 0,},
				{10, 3, 0, 0,},
			},
		},
		
		--每个难度的配置
		[5] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,5},
				{1202,5},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 40, 0, 0,},
				{101, 15002, 40, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 1, 0, 0,},
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
			},
		},
		
		--每个难度的配置
		[6] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_ex_004",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,1},
				{1202,1},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 45, 0, 0,},
				{101, 15002, 45, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 1, 0, 0,},
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
			},
		},
		
		--每个难度的配置
		[7] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_ex_004",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,2},
				{1202,2},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 50, 0, 0,},
				{101, 15002, 50, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 1, 0, 0,},
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
			},
		},
		
		--每个难度的配置
		[8] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_ex_004",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,3},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 55, 0, 0,},
				{101, 15002, 55, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 1, 0, 0,},
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
			},
		},
		
		--每个难度的配置
		[9] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_ex_004",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,4},
				{1202,4},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 60, 0, 0,},
				{101, 15002, 60, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 1, 0, 0,},
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
			},
		},
		
		--每个难度的配置
		[10] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_ex_004",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,5},
				{1202,5},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 65, 0, 0,},
				{101, 15002, 65, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 1, 0, 0,},
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
			},
		},
		
		--每个难度的配置
		[11] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_ex_004",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,6},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 70, 0, 0,},
				{101, 15002, 70, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 1, 0, 0,},
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
			},
		},
		
		--每个难度的配置
		[12] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_ex_004",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,7},
				{1202,7},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 75, 0, 0,},
				{101, 15002, 75, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 1, 0, 0,},
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
			},
		},
		
		--每个难度的配置
		[13] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_ex_004",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,8},
				{1202,8},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 80, 0, 0,},
				{101, 15002, 80, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 1, 0, 0,},
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
			},
		},
		
		--每个难度的配置
		[14] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_ex_004",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,9},
				{1202,9},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 90, 0, 0,},
				{101, 15002, 90, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 1, 0, 0,},
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
			},
		},
		
		--每个难度的配置
		[15] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_ex_004",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,10},
				{1202,10},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 100, 0, 0,},
				{101, 15002, 100, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 1, 0, 0,},
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
			},
		},
		
		--每个难度的配置
		[16] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_ex_004",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,11},
				{1202,11},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 110, 0, 0,},
				{101, 15002, 110, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 1, 0, 0,},
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
			},
		},
		
		--每个难度的配置
		[17] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_ex_004",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,12},
				{1202,12},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 120, 0, 0,},
				{101, 15002, 120, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 1, 0, 0,},
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
			},
		},
		
		--每个难度的配置
		[18] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_ex_004",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,13},
				{1202,13},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 130, 0, 0,},
				{101, 15002, 130, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 1, 0, 0,},
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
			},
		},
		
		--每个难度的配置
		[19] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_ex_004",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,14},
				{1202,14},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 140, 0, 0,},
				{101, 15002, 140, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 1, 0, 0,},
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
			},
		},
		
		--每个难度的配置
		[20] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_ex_004",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,15},
				{1202,15},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 150, 0, 0,},
				{101, 15002, 150, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 1, 0, 0,},
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 100, dropAll = true, id = {12200,12201,12202,12203,12204,12205,12206,}}, --道具卡
				{value = 100, id = {12013,12014,12015,12016,12017,12018,12019,12020,12021,12022,12023,12024,12025,}},
			},
		},
		["mgbox_0"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12100,12101,12102,12103,12104,}},
			},
		},
		["mgbox_s"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12200,12201,12202,12203,12204,12205,12206,}},
			},
		},
		["mgbox_s2"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12010,}},
			},
		},
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 73, id = "NA"}, --无
				{value = 5, id = {12009}}, --加血
				{value = 1, id = {12008}}, --加血
				{value = 1, id = {12010}}, --强化星
				{value = 20, id = {12013,12014,12015,12016,12017,12018,12019,12020,12021,12022,12023,12024,12025,}}, --道具卡
			},
		},
		["boss"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12013,12014,12015,12016,12017,12018,12019,12020,12021,12022,12023,12024,12025,}}, --道具卡
			},
		},
		["boss2"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12016,}}, --道具卡
			},
		},
	},
}

--前哨阵地
hVar.MAP_INFO["world/yxys_ex_002"] =
{
	mapType = 4,
	uniqueID = 32,
	level = 32,
	chapter = 1,
	nextmap = {"world/yxys_ex_002"},
	thumbnail = "misc/selectmap_1.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 70,
	
	--经验值
	exp = 120,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 88, id = "NA"}, --无
				{value = 5, id = {12009}}, --加血
				{value = 1, id = {12008}}, --加血
				{value = 1, id = {12010}}, --强化星
				{value = 5, id = {12013,12014,12015,12016,12017,12018,12019,12020,12021,12022,12023,12024,12025,}}, --道具卡
			},
		},
		["boss"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 65, id = "NA"}, --无
				{value = 35, id = {12013,12014,12015,12016,12017,12018,12019,12020,12021,12022,12023,12024,12025,}}, --道具卡
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, dropAll = true, id = {12200,12207,}}, --道具卡
			},
		},
	},
}

hVar.MAP_INFO["world/start_001_ex"] =
{
	mapType = 4,
	uniqueID = 33,
	level = 33,
	chapter = 1,
	nextmap = {"world/csys_001"},
	thumbnail = "misc/thumb_td_demo.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/base_01", "music/base_02", "music/base_03",}, --背景音乐
	
	--积分
	scoreV = 70,
	
	--经验值
	exp = 130,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
}

--================机械蜘蛛战役包================--
hVar.MAP_INFO["world/dlc_yxys_spider"] =
{
	mapType = 4,
	uniqueID = 0,
	icon = "ICON_world/level_xpzz",
	--显示解锁
	unLock = {"world/td_109_xpzz"},
	--dlc的shopid
	dlc = 141,
	--购买条件
	buyCondition = 
	{
		--通关某地图
		map = "world/td_109_xpzz",
	},
	--dlc子地图
	childMap = {
		"world/yxys_spider_01",
		"world/yxys_spider_02",
		"world/yxys_spider_03",
		"world/yxys_spider_04",
	},
	starReward =
	{
		--
	},
}

hVar.MAP_INFO["world/yxys_spider_01"] =
{
	mapType = 4,
	uniqueID = 34,
	icon = "icon/xlobj/spider01.png",
	icon_title = "icon/xlobj/spider01_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_spider", --所属的地图包名字
	level = 10034,
	chapter = 1,
	nextmap = {"world/yxys_spider_02"},
	unLock = {}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 60,
	
	starReward =
	{
		{7, 100, 0}, --氪石
		{10, 20111, 0, 0}, --装备
		{101, 15002, 5, 0}, --枪
		--{6, 15204, 5, 0}, --战术卡
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{
			--当前难度加载的地图
			diffMapName = "world/yxys_spider_01_lv1",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,3},
				{1202,1},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15002, 5, 0}, --枪
				{11, 5, 0}, --强化材料
				{108, 5, 0}, --装备箱
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_spider_01_lv2",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,2},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15002, 5, 0}, --枪
				{11, 5, 0}, --强化材料
				{108, 10, 0}, --装备箱
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_spider_01_lv3",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,9},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15002, 5, 0}, --枪
				{11, 10, 0}, --强化材料
				{105, 10, 0}, --武器箱
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["mgbox_0"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12010}}, --强化星
			},
		},
		["money"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {13010}},
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12014}},
			},
		},
	},
}

hVar.MAP_INFO["world/yxys_spider_02"] =
{
	mapType = 4,
	uniqueID = 35,
	icon = "icon/xlobj/spider02.png",
	icon_title = "icon/xlobj/spider02_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_spider", --所属的地图包名字
	level = 10035,
	chapter = 1,
	nextmap = {"world/yxys_spider_03"},
	unLock = {"world/yxys_spider_01",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 60,
	
	starReward =
	{
		{10, 20102, 0, 0}, --装备
		{101, 15002, 5, 0}, --枪
		{6, 15204, 5, 0}, --战术卡
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_spider_02_lv1",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,3},
				{1202,1},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15002, 5, 0}, --枪
				{11, 5, 0}, --强化材料
				{108, 5, 0}, --装备箱
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_spider_02_lv2",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,2},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15002, 5, 0}, --枪
				{11, 5, 0}, --强化材料
				{108, 10, 0}, --装备箱
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_spider_02_lv3",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,9},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15002, 5, 0}, --枪
				{11, 10, 0}, --强化材料
				{105, 10, 0}, --武器箱
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, dropAll = true, id = {12018,12018,12018}},
			},
		},
		["crystal"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 14, id = {13000}},
				{value = 19, id = {13001}},
				{value = 34, id = {13002}},
				{value = 19, id = {13003}},
				{value = 14, id = {13004}},
			},
		},
	},
}

hVar.MAP_INFO["world/yxys_spider_03"] =
{
	mapType = 4,
	uniqueID = 36,
	icon = "icon/xlobj/spider03.png",
	icon_title = "icon/xlobj/spider03_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_spider", --所属的地图包名字
	level = 10036,
	chapter = 1,
	nextmap = {"world/yxys_spider_04"},
	unLock = {"world/yxys_spider_02",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 60,
	
	starReward =
	{
		{10, 20105, 0, 0}, --装备
		{101, 15002, 5, 0}, --枪
		{11, 10, 0}, --强化材料
		--{6, 15204, 5, 0}, --战术卡
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_spider_03_lv1",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,3},
				{1202,1},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15002, 5, 0}, --枪
				{11, 5, 0}, --强化材料
				{108, 5, 0}, --装备箱
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_spider_03_lv2",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,2},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15002, 5, 0}, --枪
				{11, 5, 0}, --强化材料
				{108, 10, 0}, --装备箱
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_spider_03_lv3",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,9},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15002, 5, 0}, --枪
				{11, 10, 0}, --强化材料
				{105, 10, 0}, --武器箱
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12015,}}, --强化星
				
			},
		},
	},
}

hVar.MAP_INFO["world/yxys_spider_04"] =
{
	mapType = 4,
	uniqueID = 37,
	icon = "icon/xlobj/spider04.png",
	icon_title = "icon/xlobj/spider04_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_spider", --所属的地图包名字
	level = 10037,
	chapter = 1,
	nextmap = {"world/yxys_airship_01"},
	unLock = {"world/yxys_spider_03",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/boss_01", "music/boss_02","music/boss_03","music/boss_04",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 60,
	
	starReward =
	{
		{10, 20106, 0, 0}, --装备
		--{6, 15204, 5, 0}, --战术卡
		{7, 10, 0}, --氪石
		{101, 15002, 10, 0}, --枪
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,3},
				{1202,1},
			},
			
			--当前难度星级掉落
			starReward = {
				{108, 5, 0}, --装备箱
				{11, 5, 0}, --强化材料
				{101, 15002, 10, 0}, --枪
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,2},
			},
			
			--当前难度星级掉落
			starReward = {
				{108, 5, 0}, --装备箱
				{11, 10, 0}, --强化材料
				{101, 15002, 10, 0}, --枪
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,9},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 10, 0}, --武器箱
				{7, 50, 0}, --氪石
				{101, 15002, 10, 0}, --枪
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 15, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 75, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12010,}}, --强化星
				
			},
		},
		["mgbox_0"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, dropAll = true, id = {12013,12014,}},
				
			},
		},
	},
}

--================飞船战役包================--
hVar.MAP_INFO["world/dlc_yxys_airship"] =
{
	mapType = 4,
	uniqueID = 0,
	icon = "ICON_world/level_xpzz",
	--显示解锁
	unLock = {"world/td_109_xpzz"},
	--dlc的shopid
	dlc = 142,
	--购买条件
	buyCondition = 
	{
		--通关某地图
		map = "world/td_109_xpzz",
	},
	--dlc子地图
	childMap = {
		"world/yxys_airship_01",
		"world/yxys_airship_02",
		"world/yxys_airship_03",
		"world/yxys_airship_04",
	},
	starReward =
	{
		{4, 18011, 1, 1,},	--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
		{4, 18012, 1, 1,},	--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
		{3,11055,10,},		--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
		{3,11056,10,},		--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
	},
}

hVar.MAP_INFO["world/yxys_airship_01"] =
{
	mapType = 4,
	uniqueID = 46,
	icon = "icon/xlobj/airship01.png",
	icon_title = "icon/xlobj/airship01_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_airship", --所属的地图包名字
	level = 10046,
	chapter = 2,
	nextmap = {"world/yxys_airship_02"},
	unLock = {"world/yxys_spider_04",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 80,
	
	starReward =
	{
		{10, 20204, 1, 0}, --装备
		{103, 15101, 5, 0}, --宠物
		{6, 15202, 5, 0}, --战术卡
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,3},
				{1202,1},
			},
			
			--当前难度星级掉落
			starReward = {
				{103, 15101, 5, 0}, --宠物
				{11, 5, 0}, --强化材料
				{108, 5, 0}, --装备箱
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,2},
			},
			
			--当前难度星级掉落
			starReward = {
				{103, 15101, 5, 0}, --宠物
				{11, 5, 0}, --强化材料
				{108, 10, 0}, --装备箱
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,9},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{103, 15101, 5, 0}, --宠物
				{11, 10, 0}, --强化材料
				{107, 10, 0}, --宠物箱
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 10, id = {12009}}, --加血
				{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 10, id = {12009}}, --加血
				{value = 5, id = {12010}}, --强化星
				{value = 10, id = {12013,12014}},
				{value = 5, id = {13000}},
				{value = 10, id = {13001}},
				{value = 15, id = {13002}},
				{value = 10, id = {13003}},
				{value = 5, id = {13004}},
				{value = 30, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/yxys_airship_02"] =
{
	mapType = 4,
	uniqueID = 47,
	icon = "icon/xlobj/airship02.png",
	icon_title = "icon/xlobj/airship02_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_airship", --所属的地图包名字
	level = 10047,
	chapter = 2,
	nextmap = {"world/yxys_airship_03"},
	unLock = {"world/yxys_airship_01",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 80,
	
	starReward =
	{
		{10, 20211, 1, 0}, --装备
		{103, 15101, 5, 0}, --宠物
		{6, 15202, 5, 0}, --战术卡
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_airship_02_lv1",

			--当前难度生效的战术卡
			diffTactic = {
				{1201,3},
				{1202,1},
			},
			
			--当前难度星级掉落
			starReward = {
				{103, 15101, 5, 0}, --宠物
				{11, 5, 0}, --强化材料
				{108, 5, 0}, --装备箱
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_airship_02_lv2",
		
			--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,2},
			},
			
			--当前难度星级掉落
			starReward = {
				{103, 15101, 5, 0}, --宠物
				{11, 5, 0}, --强化材料
				{108, 10, 0}, --装备箱
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_airship_02_lv2",
		
			--当前难度生效的战术卡
			diffTactic = {
				{1201,9},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{103, 15101, 5, 0}, --宠物
				{11, 10, 0}, --强化材料
				{107, 10, 0}, --宠物箱
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 10, id = {12009}}, --加血
				{value = 90, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/yxys_airship_03"] =
{
	mapType = 4,
	uniqueID = 48,
	icon = "icon/xlobj/airship03.png",
	icon_title = "icon/xlobj/airship03_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_airship", --所属的地图包名字
	level = 10048,
	chapter = 2,
	nextmap = {"world/yxys_airship_04"},
	unLock = {"world/yxys_airship_02",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 80,
	
	starReward =
	{
		{10, 20203, 1, 0}, --装备
		{103, 15101, 5, 0}, --宠物
		{6, 15202, 5, 0}, --战术卡
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_airship_03_lv1",

			--当前难度生效的战术卡
			diffTactic = {
				{1201,3},
				{1202,1},
			},
			
			--当前难度星级掉落
			starReward = {
				{103, 15101, 5, 0}, --宠物
				{11, 5, 0}, --强化材料
				{108, 5, 0}, --装备箱
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_airship_03_lv2",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,2},
			},
			
			--当前难度星级掉落
			starReward = {
				{103, 15101, 5, 0}, --宠物
				{11, 5, 0}, --强化材料
				{108, 10, 0}, --装备箱
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_airship_03_lv3",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,9},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{103, 15101, 5, 0}, --宠物
				{11, 10, 0}, --强化材料
				{107, 10, 0}, --宠物箱
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 5, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 85, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 50, id = {12014,12015}}, --强化星
				{value = 50, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/yxys_airship_04"] =
{
	mapType = 4,
	uniqueID = 49,
	icon = "icon/xlobj/airship04.png",
	icon_title = "icon/xlobj/airship04_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_airship", --所属的地图包名字
	level = 10049,
	chapter = 2,
	nextmap = {"world/yxys_zerg_001",},
	unLock = {"world/yxys_airship_03",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/boss_01", "music/boss_02","music/boss_03","music/boss_04",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 80,
	
	starReward =
	{
		{10, 20210, 1, 0}, --装备
		{7, 10, 0}, --氪石
		{103, 15101, 10, 0}, --宠物
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_airship_04_lv1",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,3},
				{1202,1},
			},
			
			--当前难度星级掉落
			starReward = {
				{108, 5, 0}, --装备箱
				{6, 15202, 5, 0}, --战术卡
				{103, 15101, 10, 0}, --宠物
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_airship_04_lv2",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,2},
			},
			
			--当前难度星级掉落
			starReward = {
				{108, 10, 0}, --装备箱
				{11, 10, 0}, --强化材料
				{103, 15101, 10, 0}, --宠物
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度加载的地图
			diffMapName = "world/yxys_airship_04_lv3",
			
			--当前难度生效的战术卡
			diffTactic = {
				{1201,9},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{107, 10, 0}, --宠物箱
				{7, 50, 0}, --氪石
				{103, 15101, 10, 0}, --宠物
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 3, id = {12008}}, --强化星
				{value = 10, id = {12009}}, --加血
				{value = 5, id = {12010}}, --强化星
				{value = 85, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 30, id = {12010,}}, --强化星
				{value = 70, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}},
			},
		},
		["ptex"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 15, id = {13000}},
				{value = 20, id = {13001}},
				{value = 30, id = {13002}},
				{value = 20, id = {13003}},
				{value = 15, id = {13004}},
			},
		},
	},
}


--================虫族战役包================--
hVar.MAP_INFO["world/dlc_yxys_zerg"] =
{
	mapType = 4,
	uniqueID = 0,
	icon = "ICON_world/level_xpzz",
	--显示解锁
	unLock = {"world/td_109_xpzz"},
	--dlc的shopid
	dlc = 146,
	--购买条件
	buyCondition = 
	{
		--通关某地图
		map = "world/td_109_xpzz",
	},
	--dlc子地图
	childMap = {
		"world/yxys_zerg_001",
		"world/yxys_zerg_002",
		"world/yxys_zerg_003",
		"world/yxys_zerg_004",
	},
	starReward =
	{
		{4, 18011, 1, 1,},	--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
		{4, 18012, 1, 1,},	--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
		{3,11055,10,},		--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
		{3,11056,10,},		--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
	},
}

--以下为虫族战役
hVar.MAP_INFO["world/yxys_zerg_001"] =
{
	mapType = 4,
	uniqueID = 38,
	icon = "icon/xlobj/zerg01.png",
	icon_title = "icon/xlobj/zerg01_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_zerg", --所属的地图包名字
	level = 10038,
	chapter = 3,
	nextmap = {"world/yxys_zerg_002"},
	unLock = {"world/yxys_airship_04",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 70,
	
	starReward =
	{
		{6, 15211, 5, 0}, --战术卡
		{6, 15206, 5, 0}, --战术卡
		{11, 5, 0}, --强化材料
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	
			diffMapName = "world/yxys_zerg_001",
			--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15004, 5, 0}, --武器
				{11, 5, 0}, --强化材料
				{105, 5, 0}, --武器箱
			},
		},
		--每个难度的配置
		[2] = 
		{	
			diffMapName = "world/yxys_zerg_001_lv1",
			--当前难度生效的战术卡
			diffTactic = {
				{1201,12},
				{1202,6},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15004, 5, 0}, --武器
				{11, 5, 0}, --强化材料
				{108, 10, 0}, --装备箱
			},
		},
		--每个难度的配置
		[3] = 
		{	
			diffMapName = "world/yxys_zerg_001_lv1",
			--当前难度生效的战术卡
			diffTactic = {
				{1201,18},
				{1202,9},
			},
			
			--当前难度星级掉落
			starReward = {
				{107, 5, 0}, --宠物箱
				{11, 10, 0}, --强化材料
				{108, 10, 0}, --装备箱
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 9, id = {12009}}, --加血
				{value = 1, id = {12010}}, --强化星
				{value = 90, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["mgbox_s"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 100, id = {12200,12201,12202,12203,12204,12205,12206,}},
				{value = 100, id = {12200,12201,12203}},
			},
		},
		["mgbox_0"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12100,12101,12102,12103,12104,}},
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/yxys_zerg_002"] =
{
	mapType = 4,
	uniqueID = 39,
	icon = "icon/xlobj/zerg02.png",
	icon_title = "icon/xlobj/zerg02_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_zerg", --所属的地图包名字
	level = 10039,
	chapter = 3,
	nextmap = {"world/yxys_zerg_003"},
	unLock = {"world/yxys_zerg_001",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 70,
	
	starReward =
	{
		{6, 15211, 5, 0}, --战术卡
		{6, 15206, 5, 0}, --战术卡
		{11, 5, 0}, --强化材料
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15004, 5, 0}, --武器
				{11, 5, 0}, --强化材料
				{105, 5, 0}, --武器箱
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,12},
				{1202,6},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15004, 5, 0}, --武器
				{11, 5, 0}, --强化材料
				{108, 10, 0}, --装备箱
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,18},
				{1202,9},
			},
			
			--当前难度星级掉落
			starReward = {
				{107, 5, 0}, --宠物箱
				{11, 10, 0}, --强化材料
				{108, 10, 0}, --装备箱
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 3, id = {12009}}, --加血
				{value = 1, id = {12010}}, --强化星
				{value = 96, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["mgbox_s"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12200,}},
			},
		},
		["mgbox_0"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12202,}},
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/yxys_zerg_003"] =
{
	mapType = 4,
	uniqueID = 40,
	icon = "icon/xlobj/zerg03.png",
	icon_title = "icon/xlobj/zerg03_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_zerg", --所属的地图包名字
	level = 10040,
	chapter = 3,
	nextmap = {"world/yxys_zerg_004"},
	unLock = {"world/yxys_zerg_002",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 70,
	
	starReward =
	{
		{6, 15211, 5, 0}, --战术卡
		{6, 15206, 5, 0}, --战术卡
		{11, 5, 0}, --强化材料
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15004, 5, 0}, --武器
				{11, 5, 0}, --强化材料
				{105, 5, 0}, --武器箱
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,12},
				{1202,6},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15004, 5, 0}, --武器
				{11, 5, 0}, --强化材料
				{108, 10, 0}, --装备箱
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,18},
				{1202,9},
			},
			
			--当前难度星级掉落
			starReward = {
				{107, 5, 0}, --宠物箱
				{11, 10, 0}, --强化材料
				{108, 10, 0}, --装备箱
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 15, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 75, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/yxys_zerg_004"] =
{
	mapType = 4,
	uniqueID = 41,
	icon = "icon/xlobj/zerg04.png",
	icon_title = "icon/xlobj/zerg04_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_zerg", --所属的地图包名字
	level = 10041,
	chapter = 3,
	nextmap = {"world/yxys_bio_001",},
	unLock = {"world/yxys_zerg_003",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 70,
	
	starReward =
	{
		{6, 15211, 5, 0}, --战术卡
		{7, 20, 0}, --氪石
		{6, 15206, 5, 0}, --战术卡
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{107, 5, 0}, --宠物箱
				{11, 5, 0}, --强化材料
				{101, 15004, 10, 0}, --武器
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,12},
				{1202,6},
			},
			
			--当前难度星级掉落
			starReward = {
				{108, 5, 0}, --装备箱
				{11, 10, 0}, --强化材料
				{101, 15004, 10, 0}, --武器
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,18},
				{1202,9},
			},
			
			--当前难度星级掉落
			starReward = {
				{105, 10, 0}, --武器箱
				{7, 50, 0}, --氪石
				{108, 10, 0}, --装备箱
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 15, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 75, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 30, id = {12010}}, --强化星
				{value = 70, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}},
			},
		},
		["mgbox_0"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12010}}, --强化星
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}


--================生化战役包================--
hVar.MAP_INFO["world/dlc_bio_airship"] =
{
	mapType = 4,
	uniqueID = 0,
	icon = "ICON_world/level_xpzz",
	--显示解锁
	unLock = {"world/td_109_xpzz"},
	--dlc的shopid
	dlc = 143,
	--购买条件
	buyCondition = 
	{
		--通关某地图
		map = "world/td_109_xpzz",
	},
	--dlc子地图
	childMap = {
		"world/yxys_bio_001",
		"world/yxys_bio_002",
		"world/yxys_bio_003",
		"world/yxys_bio_004",
	},
	starReward =
	{
		{4, 18011, 1, 1,},	--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
		{4, 18012, 1, 1,},	--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
		{3,11055,10,},		--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
		{3,11056,10,},		--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
	},
}

--以下为生化战役（大眼睛）
hVar.MAP_INFO["world/yxys_bio_001"] =
{
	mapType = 4,
	uniqueID = 42,
	icon = "icon/xlobj/bio01.png",
	icon_title = "icon/xlobj/bio01_title.png", --标题图片
	dlcMapPackageName = "world/dlc_bio_airship", --所属的地图包名字
	level = 10042,
	chapter = 4,
	nextmap = {"world/yxys_bio_002"},
	unLock = {"world/yxys_zerg_004",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 90,
	
	starReward =
	{
		{6, 15209, 5, 0}, --战术卡
		{107, 5, 0}, --宠物箱
		{11, 5, 0}, --强化材料
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15205, 5, 0}, --战术卡
				{105, 5, 0}, --武器箱
				{11, 5, 0}, --强化材料
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,12},
				{1202,6},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15210, 5, 0}, --战术卡
				{108, 5, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,18},
				{1202,9},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15009, 5, 0}, --武器
				{108, 10, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 3, id = {12009}}, --加血
				{value = 1, id = {12010}}, --强化星
				{value = 96, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12200,}},
				--{value = 90, id = "NA"}, --无
			},
		},
		["mgbox_s"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12200,}},
			},
		},
		["mgbox_0"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12202,}},
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/yxys_bio_002"] =
{
	mapType = 4,
	uniqueID = 43,
	icon = "icon/xlobj/bio02.png",
	icon_title = "icon/xlobj/bio02_title.png", --标题图片
	dlcMapPackageName = "world/dlc_bio_airship", --所属的地图包名字
	level = 10043,
	chapter = 4,
	nextmap = {"world/yxys_bio_003"},
	unLock = {"world/yxys_bio_001",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 90,
	
	starReward =
	{
		{6, 15209, 5, 0}, --战术卡
		{107, 5, 0}, --宠物箱
		{11, 5, 0}, --强化材料
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15205, 5, 0}, --战术卡
				{105, 5, 0}, --武器箱
				{11, 5, 0}, --强化材料
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,12},
				{1202,6},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15210, 5, 0}, --战术卡
				{108, 5, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,18},
				{1202,9},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15009, 5, 0}, --武器
				{108, 10, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 15, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 75, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/yxys_bio_003"] =
{
	mapType = 4,
	uniqueID = 44,
	icon = "icon/xlobj/bio03.png",
	icon_title = "icon/xlobj/bio03_title.png", --标题图片
	dlcMapPackageName = "world/dlc_bio_airship", --所属的地图包名字
	level = 10044,
	chapter = 4,
	nextmap = {"world/yxys_bio_004"},
	unLock = {"world/yxys_bio_002",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 90,
	
	starReward =
	{
		{6, 15209, 5, 0}, --战术卡
		{107, 5, 0}, --宠物箱
		{11, 5, 0}, --强化材料
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15205, 5, 0}, --战术卡
				{105, 5, 0}, --武器箱
				{11, 5, 0}, --强化材料
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,12},
				{1202,6},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15210, 5, 0}, --战术卡
				{108, 5, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,18},
				{1202,9},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15009, 5, 0}, --武器
				{108, 10, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 7, id = {12009}}, --加血
				{value = 3, id = {12010}}, --强化星
				{value = 90, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["mgbox_s"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12200,12201,12202,12203,12204,12205,12206,}},
			},
		},
		["mgbox_0"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12100,12101,12102,12103,12104,}},
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/yxys_bio_004"] =
{
	mapType = 4,
	uniqueID = 45,
	icon = "icon/xlobj/bio04.png",
	icon_title = "icon/xlobj/bio04_title.png", --标题图片
	dlcMapPackageName = "world/dlc_bio_airship", --所属的地图包名字
	level = 10045,
	chapter = 4,
	nextmap = {"world/yxys_mechanics_001"},
	unLock = {"world/yxys_bio_003",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 90,
	
	starReward =
	{
		{6, 15209, 5, 0}, --战术卡
		{7, 20, 0}, --氪石
		{107, 5, 0}, --宠物箱
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15205, 5, 0}, --战术卡
				{105, 5, 0}, --武器箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,12},
				{1202,6},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15210, 5, 0}, --战术卡
				{108, 10, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,18},
				{1202,9},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15009, 10, 0}, --武器
				{7, 50, 0}, --氪石
				{108, 10, 0}, --装备箱
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 15, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 75, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 30, id = {12010}}, --强化星
				{value = 70, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}},
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}



--================机械飞船战役包================--
hVar.MAP_INFO["world/dlc_yxys_mechanics"] =
{
	mapType = 4,
	uniqueID = 0,
	icon = "ICON_world/level_xpzz",
	--显示解锁
	unLock = {"world/td_109_xpzz"},
	--dlc的shopid
	dlc = 145,
	--购买条件
	buyCondition = 
	{
		--通关某地图
		map = "world/td_109_xpzz",
	},
	--dlc子地图
	childMap = {
		"world/yxys_mechanics_001",
		"world/yxys_mechanics_002",
		"world/yxys_mechanics_003",
		"world/yxys_mechanics_004",
	},
	starReward =
	{
		--
	},
}

--以下为机械战役
hVar.MAP_INFO["world/yxys_mechanics_001"] =
{
	mapType = 4,
	uniqueID = 51,
	icon = "icon/xlobj/mechanics01.png",
	icon_title = "icon/xlobj/mechanics01_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_mechanics", --所属的地图包名字
	level = 10051,
	chapter = 5,
	nextmap = {"world/yxys_mechanics_002"},
	unLock = {"world/yxys_bio_004",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 100,
	
	starReward =
	{
		{6, 15203, 5, 0}, --战术卡
		{107, 5, 0}, --宠物箱
		{11, 5, 0}, --强化材料
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15213, 5, 0}, --战术卡
				{105, 5, 0}, --武器箱
				{11, 5, 0}, --强化材料
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,12},
				{1202,6},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15208, 5, 0}, --战术卡
				{108, 5, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,18},
				{1202,9},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15006, 5, 0}, --武器
				{108, 10, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 3, id = {12009}}, --加血
				{value = 1, id = {12010}}, --强化星
				{value = 96, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12200,}},
				--{value = 90, id = "NA"}, --无
			},
		},
		["mgbox_s"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12200,}},
			},
		},
		["mgbox_0"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12202,}},
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/yxys_mechanics_002"] =
{
	mapType = 4,
	uniqueID = 52,
	icon = "icon/xlobj/mechanics02.png",
	icon_title = "icon/xlobj/mechanics02_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_mechanics", --所属的地图包名字
	level = 10052,
	chapter = 5,
	nextmap = {"world/yxys_mechanics_003"},
	unLock = {"world/yxys_mechanics_001",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 100,
	
	starReward =
	{
		{6, 15203, 5, 0}, --战术卡
		{107, 5, 0}, --宠物箱
		{11, 5, 0}, --强化材料
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15213, 5, 0}, --战术卡
				{105, 5, 0}, --武器箱
				{11, 5, 0}, --强化材料
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,12},
				{1202,6},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15208, 5, 0}, --战术卡
				{108, 5, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,18},
				{1202,9},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15006, 5, 0}, --武器
				{108, 10, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 15, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 75, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/yxys_mechanics_003"] =
{
	mapType = 4,
	uniqueID = 53,
	icon = "icon/xlobj/mechanics03.png",
	icon_title = "icon/xlobj/mechanics03_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_mechanics", --所属的地图包名字
	level = 10053,
	chapter = 5,
	nextmap = {"world/yxys_mechanics_004"},
	unLock = {"world/yxys_mechanics_002",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 100,
	
	starReward =
	{
		{6, 15203, 5, 0}, --战术卡
		{107, 5, 0}, --宠物箱
		{11, 5, 0}, --强化材料
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15213, 5, 0}, --战术卡
				{105, 5, 0}, --武器箱
				{11, 5, 0}, --强化材料
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,12},
				{1202,6},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15208, 5, 0}, --战术卡
				{108, 5, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,18},
				{1202,9},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15006, 5, 0}, --武器
				{108, 10, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 7, id = {12009}}, --加血
				{value = 3, id = {12010}}, --强化星
				{value = 90, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["mgbox_s"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12200,12201,12202,12203,12204,12205,12206,}},
			},
		},
		["mgbox_0"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12100,12101,12102,12103,12104,}},
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/yxys_mechanics_004"] =
{
	mapType = 4,
	uniqueID = 54,
	icon = "icon/xlobj/mechanics04.png",
	icon_title = "icon/xlobj/mechanics04_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_mechanics", --所属的地图包名字
	level = 10054,
	chapter = 5,
	nextmap = {"world/yxys_plate_01"},
	unLock = {"world/yxys_mechanics_003",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 100,
	
	starReward =
	{
		{6, 15203, 5, 0}, --战术卡
		{7, 30, 0}, --氪石
		{107, 5, 0}, --宠物箱
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15213, 5, 0}, --战术卡
				{105, 5, 0}, --武器箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,12},
				{1202,6},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15208, 5, 0}, --战术卡
				{108, 10, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,18},
				{1202,9},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15006, 10, 0}, --武器
				{7, 50, 0}, --氪石
				{108, 10, 0}, --装备箱
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 3, id = {12008}}, --强化星
				{value = 9, id = {12009}}, --加血
				{value = 6, id = {12010}}, --强化星
				{value = 85, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 30, id = {12010}}, --强化星
				{value = 70, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}},
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

--================飞碟战役包================--
hVar.MAP_INFO["world/dlc_yxys_plate"] =
{
	mapType = 4,
	uniqueID = 0,
	icon = "ICON_world/level_xpzz",
	--显示解锁
	unLock = {"world/td_109_xpzz"},
	--dlc的shopid
	dlc = 144,
	--购买条件
	buyCondition = 
	{
		--通关某地图
		map = "world/td_109_xpzz",
	},
	--dlc子地图
	childMap = {
		"world/yxys_plate_01",
		"world/yxys_plate_02",
		"world/yxys_plate_03",
		"world/yxys_plate_04",
	},
	starReward =
	{
		--
	},
}

hVar.MAP_INFO["world/yxys_plate_01"] =
{
	mapType = 4,
	uniqueID = 55,
	icon = "icon/xlobj/plate01.png",
	icon_title = "icon/xlobj/plate01_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_plate", --所属的地图包名字
	level = 10055,
	chapter = 6,
	nextmap = {"world/yxys_plate_02"},
	unLock = {"world/yxys_mechanics_004"}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 110,
	
	starReward =
	{
		{6, 15212, 5, 0}, --战术卡
		{107, 5, 0}, --宠物箱
		{11, 5, 0}, --强化材料
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,3},
				{1202,1},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15201, 5, 0}, --战术卡
				{105, 5, 0}, --武器箱
				{11, 5, 0}, --强化材料
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,2},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15207, 5, 0}, --战术卡
				{108, 5, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,9},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15003, 5, 0}, --武器
				{108, 10, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 10, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 80, id = "NA"}, --无
			},
		},
		["crystal"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 14, id = {13000}},
				{value = 19, id = {13001}},
				{value = 34, id = {13002}},
				{value = 19, id = {13003}},
				{value = 14, id = {13004}},
			},
		},
	},
}

hVar.MAP_INFO["world/yxys_plate_02"] =
{
	mapType = 4,
	uniqueID = 56,
	icon = "icon/xlobj/plate02.png",
	icon_title = "icon/xlobj/plate02_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_plate", --所属的地图包名字
	level = 10056,
	chapter = 6,
	nextmap = {"world/yxys_plate_03"},
	unLock = {"world/yxys_plate_01",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 110,
	
	starReward =
	{
		{6, 15212, 5, 0}, --战术卡
		{107, 5, 0}, --宠物箱
		{11, 5, 0}, --强化材料
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{
			--当前难度加载的地图
			diffMapName = "world/yxys_plate_02_lv1",

			--当前难度生效的战术卡
			diffTactic = {
				{1201,3},
				{1202,1},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15201, 5, 0}, --战术卡
				{105, 5, 0}, --武器箱
				{11, 5, 0}, --强化材料
			},
		},
		--每个难度的配置
		[2] = 
		{
			--当前难度加载的地图
			diffMapName = "world/yxys_plate_02_lv1",
		
			--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,2},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15207, 5, 0}, --战术卡
				{108, 5, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[3] = 
		{
			--当前难度加载的地图
			diffMapName = "world/yxys_plate_02_lv1",

			--当前难度生效的战术卡
			diffTactic = {
				{1201,9},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15003, 5, 0}, --武器
				{108, 10, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		
	},
}

hVar.MAP_INFO["world/yxys_plate_03"] =
{
	mapType = 4,
	uniqueID = 57,
	icon = "icon/xlobj/plate03.png",
	icon_title = "icon/xlobj/plate03_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_plate", --所属的地图包名字
	level = 10057,
	chapter = 6,
	nextmap = {"world/yxys_plate_04"},
	unLock = {"world/yxys_plate_02",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 110,
	
	starReward =
	{
		{6, 15212, 5, 0}, --战术卡
		{107, 5, 0}, --宠物箱
		{11, 5, 0}, --强化材料
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,3},
				{1202,1},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15201, 5, 0}, --战术卡
				{105, 5, 0}, --武器箱
				{11, 5, 0}, --强化材料
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,2},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15207, 5, 0}, --战术卡
				{108, 5, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,9},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15003, 5, 0}, --武器
				{108, 10, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12208}},
			},
		},
	},
}

hVar.MAP_INFO["world/yxys_plate_04"] =
{
	mapType = 4,
	uniqueID = 58,
	icon = "icon/xlobj/plate04.png",
	icon_title = "icon/xlobj/plate04_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_plate", --所属的地图包名字
	level = 10058,
	chapter = 6,
	nextmap = {},
	unLock = {"world/yxys_plate_03",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/boss_01", "music/boss_02","music/boss_03","music/boss_04",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 110,
	
	starReward =
	{
		{6, 15212, 5, 0}, --战术卡
		{7, 30, 0}, --氪石
		{107, 5, 0}, --宠物箱
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,3},
				{1202,1},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15201, 5, 0}, --战术卡
				{105, 5, 0}, --武器箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,2},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15207, 5, 0}, --战术卡
				{108, 10, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,9},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15003, 10, 0}, --武器
				{7, 50, 0}, --氪石
				{108, 10, 0}, --装备箱
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 2, id = {12009}}, --加血
				{value = 1, id = {12010}}, --强化星
				{value = 97, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 30, id = {12010}}, --强化星
				{value = 70, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}},
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}




---------------------------------------------
--夺宝奇兵
hVar.MAP_INFO["world/yxys_ex_003"] =
{
	mapType = 4,
	uniqueID = 50,
	level = 50,
	chapter = 1,
	nextmap = {"world/yxys_ex_003"},
	thumbnail = "misc/selectmap_1.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 70,
	
	--经验值
	exp = 120,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{
			--当前难度生效的战术卡
			diffTactic = {
				--{1201,3},
				--{1202,1},
			},
			
			--当前难度星级掉落
			starReward = {
				{107, 20, 0, 0,},
				{103, 15101, 20, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{107, 20, 0, 0,},
				{103, 15101, 20, 0,},
			},
		},
		--每个难度的配置
		[2] = 
		{
			--当前难度加载的地图
			diffMapName = "world/yxys_ex_005",
			
			--当前难度生效的战术卡
			diffTactic = {
				--{1201,3},
				--{1202,1},
			},
			
			--当前难度星级掉落
			starReward = {
				{107, 40, 0, 0,},
				{103, 15101, 40, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 2, 0, 0,},
				{11, 3, 0, 0,},
				{11, 4, 0, 0,},
			},
		},
		
		--每个难度的配置
		[3] = 
		{
			--当前难度加载的地图
			diffMapName = "world/yxys_ex_005",
			
			--当前难度生效的战术卡
			diffTactic = {
				--{1201,6},
				--{1202,2},
			},
			
			--当前难度星级掉落
			starReward = {
				{107, 60, 0, 0,},
				{103, 15101, 60, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 3, 0, 0,},
				{11, 4, 0, 0,},
				{11, 5, 0, 0,},
			},
		},
		
		--每个难度的配置
		[4] = 
		{
			--当前难度加载的地图
			diffMapName = "world/yxys_ex_005",
			
			--当前难度生效的战术卡
			diffTactic = {
				--{1201,9},
				--{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{107, 80, 0, 0,},
				{103, 15101, 80, 0,},
			},
			
			--当前难度随机掉落（仅用于界面展示）
			randReward = {
				{11, 4, 0, 0,},
				{11, 5, 0, 0,},
				{11, 6, 0, 0,},
			},
		},
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 5, id = {12009}}, --加血
				{value = 5, id = {12010}}, --强化星
				{value = 5, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}},
				{value = 85, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 5, id = {12009}}, --加血
				{value = 5, id = {12010}}, --强化星
				{value = 5, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}},
				{value = 85, id = "NA"}, --无
			},
		},
		["boss"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 30, id = {12009}}, --加血
				{value = 35, id = {12010}}, --强化星
				{value = 35, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}},
			},
		},
	},
}

--母巢之战2
--塔防图2
hVar.MAP_INFO["world/yxys_ex_004"] =
{
	mapType = 4,
	uniqueID = 59,
	level = 59,
	chapter = 1,
	nextmap = {"world/yxys_ex_001"},
	thumbnail = "misc/selectmap_1.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 70,
	
	--经验值
	exp = 120,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 100, dropAll = true, id = {12200,12201,12202,12203,12204,12205,12206,}}, --道具卡
				{value = 100, id = {12013,12014,12015,12016,12017,12018,12019,12020,12021,12022,12023,12024,12025,}},
			},
		},
		["mgbox_0"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12100,12101,12102,12103,12104,}},
			},
		},
		["mgbox_s"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12200,12201,12202,12203,12204,12205,12206,}},
			},
		},
		["mgbox_s2"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12010,}},
			},
		},
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 73, id = "NA"}, --无
				{value = 5, id = {12009}}, --加血
				{value = 1, id = {12008}}, --加血
				{value = 1, id = {12010}}, --强化星
				{value = 20, id = {12013,12014,12015,12016,12017,12018,12019,12020,12021,12022,12023,12024,12025,}}, --道具卡
			},
		},
		["boss"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12013,12014,12015,12016,12017,12018,12019,12020,12021,12022,12023,12024,12025,}}, --道具卡
			},
		},
		["boss2"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12016,}}, --道具卡
			},
		},
	},
}

--夺宝奇兵2
hVar.MAP_INFO["world/yxys_ex_005"] =
{
	mapType = 4,
	uniqueID = 60,
	level = 60,
	chapter = 1,
	nextmap = {"world/yxys_ex_003"},
	thumbnail = "misc/selectmap_1.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 70,
	
	--经验值
	exp = 120,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 240, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{
			--当前难度生效的战术卡
			diffTactic = {
				{1201,3},
				{1202,1},
			},
			
			--当前难度星级掉落
			starReward = {
				--
			},
		},
		--每个难度的配置
		[2] = 
		{
			--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,2},
			},
			
			--当前难度星级掉落
			starReward = {
				--
			},
		},
		--每个难度的配置
		[3] = 
		{
			--当前难度生效的战术卡
			diffTactic = {
				{1201,9},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				--
			},
		},
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 5, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 85, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 5, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 85, id = "NA"}, --无
			},
		},
		["boss"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 35, id = {12009}}, --加血
				{value = 65, id = {12010}}, --强化星
			},
		},
	},
}




--================尤达故事包================--
hVar.MAP_INFO["world/dlc_yxys_yoda"] =
{
	mapType = 4,
	uniqueID = 0,
	icon = "ICON_world/level_xpzz",
	--显示解锁
	unLock = {"world/td_109_xpzz"},
	--dlc的shopid
	dlc = 147,
	--购买条件
	buyCondition = 
	{
		--通关某地图
		map = "world/td_109_xpzz",
	},
	--dlc子地图
	childMap = {
		"world/yxys_yoda_01",
		"world/yxys_yoda_02",
		"world/yxys_yoda_03",
		"world/yxys_yoda_04",
	},
	starReward =
	{
		--
	},
}

hVar.MAP_INFO["world/yxys_yoda_01"] =
{
	mapType = 4,
	uniqueID = 61,
	icon = "icon/hero/soldier_02.png",
	dlcMapPackageName = "world/dlc_yxys_yoda", --所属的地图包名字
	level = 10061,
	chapter = 7,
	nextmap = {"world/yxys_yoda_02"},
	unLock = {"world/yxys_plate_04"}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 50,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 10, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 5, id = {12013,12014,12015,12016,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --道具卡
				{value = 75, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/yxys_yoda_02"] =
{
	mapType = 4,
	uniqueID = 62,
	icon = "icon/hero/soldier_03.png",
	dlcMapPackageName = "world/dlc_yxys_yoda", --所属的地图包名字
	level = 10062,
	chapter = 7,
	nextmap = {"world/yxys_yoda_03"},
	unLock = {"world/yxys_yoda_01"}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 50,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		--["pt"] = {
			--totalValue = 100,	--掉落总权值
			--pool = {
				--{value = 10, id = {12009}}, --加血
				--{value = 10, id = {12010}}, --强化星
				--{value = 80, id = "NA"}, --无
			--},
		--},
	},
}

hVar.MAP_INFO["world/yxys_yoda_03"] =
{
	mapType = 4,
	dlcMapPackageName = "world/dlc_yxys_yoda", --所属的地图包名字
	uniqueID = 63,
	level = 10063,
	chapter = 7,
	nextmap = {"world/yxys_yoda_04"},
	unLock = {"world/yxys_yoda_02"}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 50,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 10, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 80, id = "NA"}, --无
			},
		},
	},
}

hVar.MAP_INFO["world/yxys_yoda_04"] =
{
	mapType = 4,
	uniqueID = 64,
	dlcMapPackageName = "world/dlc_yxys_yoda", --所属的地图包名字
	level = 10064,
	chapter = 7,
	--nextmap = {"world/yxys_yoda_02"},
	unLock = {"world/yxys_yoda_03"}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 50,
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 10, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 80, id = "NA"}, --无
			},
		},
	},
}


--================瓦力战役包================--
hVar.MAP_INFO["world/dlc_yxys_walle"] =
{
	mapType = 4,
	uniqueID = 0,
	icon = "ICON_world/level_xpzz",
	--显示解锁
	unLock = {"world/td_109_xpzz"},
	--dlc的shopid
	dlc = 148,
	--购买条件
	buyCondition = 
	{
		--通关某地图
		map = "world/td_109_xpzz",
	},
	--dlc子地图
	childMap = {
		"world/yxys_walle_001",
		"world/yxys_walle_002",
		"world/yxys_walle_003",
		"world/yxys_walle_004",
	},
	starReward =
	{
		{4, 18011, 1, 1,},	--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
		{4, 18012, 1, 1,},	--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
		{3,11055,10,},		--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
		{3,11056,10,},		--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
	},
}

--以下为瓦力战役
--瓦力1
hVar.MAP_INFO["world/yxys_walle_001"] =
{
	mapType = 4,
	uniqueID = 65,
	icon = "icon/xlobj/walle01.png",
	icon_title = "icon/xlobj/walle01_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_walle", --所属的地图包名字
	level = 10042,
	chapter = 4,
	nextmap = {"world/yxys_walle_002"},
	unLock = {"world/yxys_plate_04",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 90,
	
	starReward =
	{
		{6, 15209, 5, 0}, --战术卡
		{107, 5, 0}, --宠物箱
		{11, 5, 0}, --强化材料
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15205, 5, 0}, --战术卡
				{105, 5, 0}, --武器箱
				{11, 5, 0}, --强化材料
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,12},
				{1202,6},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15210, 5, 0}, --战术卡
				{106, 5, 0}, --战术卡箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,18},
				{1202,9},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15009, 5, 0}, --武器
				{108, 10, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 3, id = {12009}}, --加血
				{value = 1, id = {12010}}, --强化星
				{value = 96, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12200,}},
				--{value = 90, id = "NA"}, --无
			},
		},
		["mgbox_s"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12200,}},
			},
		},
		["mgbox_0"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12202,}},
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13006,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

--瓦力2
hVar.MAP_INFO["world/yxys_walle_002"] =
{
	mapType = 4,
	uniqueID = 66,
	icon = "icon/xlobj/walle02.png",
	icon_title = "icon/xlobj/walle02_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_walle", --所属的地图包名字
	level = 10043,
	chapter = 4,
	nextmap = {"world/yxys_walle_003"},
	unLock = {"world/yxys_walle_001",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 90,
	
	starReward =
	{
		{6, 15209, 5, 0}, --战术卡
		{107, 5, 0}, --宠物箱
		{11, 5, 0}, --强化材料
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15205, 5, 0}, --战术卡
				{105, 5, 0}, --武器箱
				{11, 5, 0}, --强化材料
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,12},
				{1202,6},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15210, 5, 0}, --战术卡
				{106, 5, 0}, --战术卡箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,18},
				{1202,9},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15009, 5, 0}, --武器
				{108, 10, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 15, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 75, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13006,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

--瓦力3
hVar.MAP_INFO["world/yxys_walle_003"] =
{
	mapType = 4,
	uniqueID = 67,
	icon = "icon/xlobj/walle03.png",
	icon_title = "icon/xlobj/walle03_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_walle", --所属的地图包名字
	level = 10044,
	chapter = 4,
	nextmap = {"world/yxys_walle_004"},
	unLock = {"world/yxys_walle_002",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 90,
	
	starReward =
	{
		{6, 15209, 5, 0}, --战术卡
		{107, 5, 0}, --宠物箱
		{11, 5, 0}, --强化材料
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15205, 5, 0}, --战术卡
				{105, 5, 0}, --武器箱
				{11, 5, 0}, --强化材料
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,12},
				{1202,6},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15210, 5, 0}, --战术卡
				{106, 5, 0}, --战术卡箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,18},
				{1202,9},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15009, 5, 0}, --武器
				{108, 10, 0}, --装备箱
				{11, 10, 0}, --强化材料
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 7, id = {12009}}, --加血
				{value = 3, id = {12010}}, --强化星
				{value = 90, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 100, id = {12010,12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				--{value = 90, id = "NA"}, --无
			},
		},
		["mgbox_s"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12200,12201,12202,12203,12204,12205,12206,}},
			},
		},
		["mgbox_0"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12100,12101,12102,12103,12104,}},
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13006,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
		["mmx"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 100, id = {12030,}},
			},
		},
	},
}

--瓦力4
hVar.MAP_INFO["world/yxys_walle_004"] =
{
	mapType = 4,
	uniqueID = 68,
	icon = "icon/xlobj/walle04.png",
	icon_title = "icon/xlobj/walle04_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_walle", --所属的地图包名字
	level = 10045,
	chapter = 4,
	nextmap = {"world/yxys_walle_004"},
	unLock = {"world/yxys_walle_003",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 90,
	
	starReward =
	{
		{6, 15209, 5, 0}, --战术卡
		{7, 20, 0}, --氪石
		{107, 5, 0}, --宠物箱
	},
	
	DiffMode =
	{
		--最大难度
		maxDiff = 3, 
		--每个难度的配置
		[1] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,6},
				{1202,3},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15205, 5, 0}, --战术卡
				{105, 5, 0}, --武器箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[2] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,12},
				{1202,6},
			},
			
			--当前难度星级掉落
			starReward = {
				{6, 15210, 5, 0}, --战术卡
				{106, 10, 0}, --战术卡箱
				{11, 10, 0}, --强化材料
			},
		},
		--每个难度的配置
		[3] = 
		{	--当前难度生效的战术卡
			diffTactic = {
				{1201,18},
				{1202,9},
			},
			
			--当前难度星级掉落
			starReward = {
				{101, 15009, 10, 0}, --武器
				{7, 50, 0}, --氪石
				{108, 10, 0}, --装备箱
			},
		},
	},
	
	--3星条件
	starCondition =
	{
		--1星条件
		[1] = {condition = hVar.MEDAL_TYPE.passSuccess, value1 = 0, value2 = 0,}, --{成功通关, 无, 无}
		
		--2星条件
		[2] = {condition = hVar.MEDAL_TYPE.passTimeLess, value1 = 360, value2 = 0,}, --{通关时间小于n秒, n, 无}
		
		--3星条件
		[3] = {condition = hVar.MEDAL_TYPE.passHeroDeathLess, value1 = 1, value2 = 0,}, --{英雄死亡小于n次, n, 无}
	},
	
	publicDrop = {
		["pt"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 5, id = {12008}}, --强化星
				{value = 15, id = {12009}}, --加血
				{value = 10, id = {12010}}, --强化星
				{value = 75, id = "NA"}, --无
			},
		},
		["mgbox"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				{value = 30, id = {12010}}, --强化星
				{value = 70, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}},
			},
		},
		["container"] = {
			totalValue = 100,	--掉落总权值
			pool = {
				--{value = 50, id = {12008}}, --强化星
				{value = 3, id = {12013,12014,12016,12015,12017,12018,12019,12020,12021,12022,12023,12024,12025}}, --强化星
				{value = 1, id = {13005,13006,13007}}, --宝箱
				{value = 96, id = "NA"}, --无
			},
		},
	},
}

----------------------------------------------------------------
---------战役图其他难度

hVar.MAP_INFO["world/yxys_spider_01_lv1"] =
{
	mapType = 4,
	uniqueID = 34,
	icon = "icon/xlobj/spider01.png",
	icon_title = "icon/xlobj/spider01_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_spider", --所属的地图包名字
	level = 20034,
	chapter = 1,
	nextmap = {"world/yxys_spider_02_lv1"},
	unLock = {}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	--积分
	scoreV = 140,
	--经验值
	exp = 60,
}

hVar.MAP_INFO["world/yxys_spider_01_lv2"] =
{
	mapType = 4,
	uniqueID = 34,
	icon = "icon/xlobj/spider01.png",
	icon_title = "icon/xlobj/spider01_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_spider", --所属的地图包名字
	level = 30034,
	chapter = 1,
	nextmap = {"world/yxys_spider_02_lv2"},
	unLock = {}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	--积分
	scoreV = 140,
	--经验值
	exp = 60,
}

hVar.MAP_INFO["world/yxys_spider_01_lv3"] =
{
	mapType = 4,
	uniqueID = 34,
	icon = "icon/xlobj/spider01.png",
	icon_title = "icon/xlobj/spider01_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_spider", --所属的地图包名字
	level = 40034,
	chapter = 1,
	nextmap = {"world/yxys_spider_02_lv3"},
	unLock = {}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	--积分
	scoreV = 140,
	--经验值
	exp = 60,
}

hVar.MAP_INFO["world/yxys_spider_02_lv1"] =
{
	mapType = 4,
	uniqueID = 35,
	icon = "icon/xlobj/spider02.png",
	icon_title = "icon/xlobj/spider02_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_spider", --所属的地图包名字
	level = 20035,
	chapter = 1,
	nextmap = {"world/yxys_spider_03_lv1"},
	unLock = {}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	--积分
	scoreV = 140,
	--经验值
	exp = 60,
}

hVar.MAP_INFO["world/yxys_spider_02_lv2"] =
{
	mapType = 4,
	uniqueID = 35,
	icon = "icon/xlobj/spider02.png",
	icon_title = "icon/xlobj/spider02_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_spider", --所属的地图包名字
	level = 30035,
	chapter = 1,
	nextmap = {"world/yxys_spider_03_lv2"},
	unLock = {}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	--积分
	scoreV = 140,
	--经验值
	exp = 60,
}

hVar.MAP_INFO["world/yxys_spider_02_lv3"] =
{
	mapType = 4,
	uniqueID = 35,
	icon = "icon/xlobj/spider02.png",
	icon_title = "icon/xlobj/spider02_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_spider", --所属的地图包名字
	level = 40035,
	chapter = 1,
	nextmap = {"world/yxys_spider_03_lv3"},
	unLock = {}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	--积分
	scoreV = 140,
	--经验值
	exp = 60,
}

hVar.MAP_INFO["world/yxys_spider_03_lv1"] =
{
	mapType = 4,
	uniqueID = 36,
	icon = "icon/xlobj/spider03.png",
	icon_title = "icon/xlobj/spider03_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_spider", --所属的地图包名字
	level = 20036,
	chapter = 1,
	nextmap = {"world/yxys_spider_04"},
	unLock = {}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	--积分
	scoreV = 140,
	--经验值
	exp = 60,
}

hVar.MAP_INFO["world/yxys_spider_03_lv2"] =
{
	mapType = 4,
	uniqueID = 36,
	icon = "icon/xlobj/spider03.png",
	icon_title = "icon/xlobj/spider03_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_spider", --所属的地图包名字
	level = 30036,
	chapter = 1,
	nextmap = {"world/yxys_spider_04"},
	unLock = {}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	--积分
	scoreV = 140,
	--经验值
	exp = 60,
}

hVar.MAP_INFO["world/yxys_spider_03_lv3"] =
{
	mapType = 4,
	uniqueID = 36,
	icon = "icon/xlobj/spider03.png",
	icon_title = "icon/xlobj/spider03_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_spider", --所属的地图包名字
	level = 40036,
	chapter = 1,
	nextmap = {"world/yxys_spider_04"},
	unLock = {}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	--积分
	scoreV = 140,
	--经验值
	exp = 60,
}

hVar.MAP_INFO["world/yxys_airship_02_lv1"] =
{
	mapType = 4,
	uniqueID = 47,
	icon = "icon/xlobj/airship03.png",
	icon_title = "icon/xlobj/airship03_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_airship", --所属的地图包名字
	level = 20047,
	chapter = 2,
	nextmap = {"world/yxys_airship_03"},
	unLock = {"world/yxys_airship_01",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 80,
}

hVar.MAP_INFO["world/yxys_airship_02_lv2"] =
{
	mapType = 4,
	uniqueID = 47,
	icon = "icon/xlobj/airship03.png",
	icon_title = "icon/xlobj/airship03_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_airship", --所属的地图包名字
	level = 20047,
	chapter = 2,
	nextmap = {"world/yxys_airship_03"},
	unLock = {"world/yxys_airship_01",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 80,
}

hVar.MAP_INFO["world/yxys_airship_03_lv1"] =
{
	mapType = 4,
	uniqueID = 48,
	icon = "icon/xlobj/airship03.png",
	icon_title = "icon/xlobj/airship03_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_airship", --所属的地图包名字
	level = 20048,
	chapter = 2,
	nextmap = {"world/yxys_airship_04"},
	unLock = {"world/yxys_airship_02",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 80,
}

hVar.MAP_INFO["world/yxys_airship_03_lv2"] =
{
	mapType = 4,
	uniqueID = 48,
	icon = "icon/xlobj/airship03.png",
	icon_title = "icon/xlobj/airship03_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_airship", --所属的地图包名字
	level = 30048,
	chapter = 2,
	nextmap = {"world/yxys_airship_04"},
	unLock = {"world/yxys_airship_02",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 80,
}

hVar.MAP_INFO["world/yxys_airship_03_lv3"] =
{
	mapType = 4,
	uniqueID = 48,
	icon = "icon/xlobj/airship03.png",
	icon_title = "icon/xlobj/airship03_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_airship", --所属的地图包名字
	level = 40048,
	chapter = 2,
	nextmap = {"world/yxys_airship_04"},
	unLock = {"world/yxys_airship_02",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 80,
}

hVar.MAP_INFO["world/yxys_airship_04_lv1"] =
{
	mapType = 4,
	uniqueID = 49,
	icon = "icon/xlobj/airship04.png",
	icon_title = "icon/xlobj/airship04_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_airship", --所属的地图包名字
	level = 20049,
	chapter = 2,
	nextmap = {"world/yxys_zerg_001",},
	unLock = {"world/yxys_airship_03",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/boss_01", "music/boss_02","music/boss_03","music/boss_04",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 80,
}

hVar.MAP_INFO["world/yxys_airship_04_lv2"] =
{
	mapType = 4,
	uniqueID = 49,
	icon = "icon/xlobj/airship04.png",
	icon_title = "icon/xlobj/airship04_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_airship", --所属的地图包名字
	level = 30049,
	chapter = 2,
	nextmap = {"world/yxys_zerg_001",},
	unLock = {"world/yxys_airship_03",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/boss_01", "music/boss_02","music/boss_03","music/boss_04",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 80,
}

hVar.MAP_INFO["world/yxys_airship_04_lv3"] =
{
	mapType = 4,
	uniqueID = 49,
	icon = "icon/xlobj/airship04.png",
	icon_title = "icon/xlobj/airship04_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_airship", --所属的地图包名字
	level = 40049,
	chapter = 2,
	nextmap = {"world/yxys_zerg_001",},
	unLock = {"world/yxys_airship_03",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/boss_01", "music/boss_02","music/boss_03","music/boss_04",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 80,
}

hVar.MAP_INFO["world/yxys_plate_02_lv1"] =
{
	mapType = 4,
	uniqueID = 56,
	icon = "icon/xlobj/plate02.png",
	icon_title = "icon/xlobj/plate02_title.png", --标题图片
	dlcMapPackageName = "world/dlc_yxys_plate", --所属的地图包名字
	level = 20056,
	chapter = 6,
	nextmap = {"world/yxys_plate_03"},
	unLock = {"world/yxys_plate_01",}, --解锁条件
	thumbnail = "misc/selectmap_2.png",
	heroLimit = {6000,},			--第一次进行关卡时选择的英雄
	sound = {"music/stage_01", "music/stage_02", "music/stage_03", "music/stage_04", "music/stage_05", "music/stage_06", "music/stage_07", "music/stage_08", "music/stage_09", "music/stage_10", "music/stage_11",}, --背景音乐
	
	--积分
	scoreV = 140,
	
	--经验值
	exp = 110,
}

--hVar.MAP_TEST = 
--{
	--["world/td_401_jbcz"] = true,
	--["world/td_402_stzz"] = true,
	--["world/td_403_dzybh"] = true,
	--["world/td_404_xqlj"] = true,
	--["world/td_405_jzhz"] = true,
	--["world/td_406_sl"] = true,
	--["world/td_402_2_pdkj"] = true,
	--["world/td_408_ymtx"] = true,
	--["world/td_409_zpbm"] = true,
	--["world/td_410_wlcs"] = true,
	--["world/td_411_hsbw"] = true,
	--["world/td_412_cbp"] = true,
	--["world/td_404_2_ljsz"] = true,
	--["world/td_414_ccjj"] = true,
	--["world/td_415_jdf"] = true,
	--["world/td_416_cbzz"] = true,
--}