------------------------------------------------------------------
------------------------军团战术卡升级----------------------------
------------------------------------------------------------------
--军团战术卡升级列表
hVar.LegionTacticsUpgradeList = {
	[1080] = {
		[1] = {FOOD = 400,WOOD = 400,IRON = 200,},
		[2] = {FOOD = 600,WOOD = 600,IRON = 300,},
		[3] = {FOOD = 800,WOOD = 800,IRON = 400,},
		[4] = {FOOD = 1000,WOOD = 1000,IRON = 500,},
		[5] = {FOOD = 1200,WOOD = 1200,IRON = 600,},
	},
	[1081] = {
		[1] = {FOOD = 400,WOOD = 400,IRON = 200,},
		[2] = {FOOD = 600,WOOD = 600,IRON = 300,},
		[3] = {FOOD = 800,WOOD = 800,IRON = 400,},
		[4] = {FOOD = 1000,WOOD = 1000,IRON = 500,},
		[5] = {FOOD = 1200,WOOD = 1200,IRON = 600,},
	},
	[1082] = {
		[1] = {FOOD = 400,WOOD = 400,IRON = 200,},
		[2] = {FOOD = 600,WOOD = 600,IRON = 300,},
		[3] = {FOOD = 800,WOOD = 800,IRON = 400,},
		[4] = {FOOD = 1000,WOOD = 1000,IRON = 500,},
		[5] = {FOOD = 1200,WOOD = 1200,IRON = 600,},
	},
	[1088] = {
		[1] = {FOOD = 400,WOOD = 400,IRON = 200,},
		[2] = {FOOD = 600,WOOD = 600,IRON = 300,},
		[3] = {FOOD = 800,WOOD = 800,IRON = 400,},
		[4] = {FOOD = 1000,WOOD = 1000,IRON = 500,},
		[5] = {FOOD = 1200,WOOD = 1200,IRON = 600,},
	},
	[1089] = {
		[1] = {FOOD = 400,WOOD = 400,IRON = 200,},
		[2] = {FOOD = 600,WOOD = 600,IRON = 300,},
		[3] = {FOOD = 800,WOOD = 800,IRON = 400,},
		[4] = {FOOD = 1000,WOOD = 1000,IRON = 500,},
		[5] = {FOOD = 1200,WOOD = 1200,IRON = 600,},
	},
	[1093] = {
		[1] = {FOOD = 400,WOOD = 400,IRON = 200,},
		[2] = {FOOD = 600,WOOD = 600,IRON = 300,},
		[3] = {FOOD = 800,WOOD = 800,IRON = 400,},
		[4] = {FOOD = 1000,WOOD = 1000,IRON = 500,},
		[5] = {FOOD = 1200,WOOD = 1200,IRON = 600,},
	},
	[1094] = {
		[1] = {FOOD = 400,WOOD = 400,IRON = 200,},
		[2] = {FOOD = 600,WOOD = 600,IRON = 300,},
		[3] = {FOOD = 800,WOOD = 800,IRON = 400,},
		[4] = {FOOD = 1000,WOOD = 1000,IRON = 500,},
		[5] = {FOOD = 1200,WOOD = 1200,IRON = 600,},
	},
	[1095] = {
		[1] = {FOOD = 400,WOOD = 400,IRON = 200,},
		[2] = {FOOD = 600,WOOD = 600,IRON = 300,},
		[3] = {FOOD = 800,WOOD = 800,IRON = 400,},
		[4] = {FOOD = 1000,WOOD = 1000,IRON = 500,},
		[5] = {FOOD = 1200,WOOD = 1200,IRON = 600,},
	},
}



------------------------------------------------------------------
---------------------------军团建筑-------------------------------
------------------------------------------------------------------
if type(hVar.tab_unit) ~= "table" then
	hVar.tab_unit = {}
end
if type(hVar.tab_build) ~= "table" then
	hVar.tab_build = hVar.tab_unit
end
local _tab_unit = hVar.tab_unit
---------军团-80000--80500-----
--_tab_unit[80000] = {
	--type = 3,
	--xlobj = "visit_cityhall_lv1",
	--name = "府邸LV1（平原城）",
	--seizable = 1,
	--legioninfo = {
		--maxlv = 10,	--最高等级
		--providemode = 1,--产出模式 1 默认获取所有 可不填 2 获取其中一个
		--country = 0,	--0(不可用),1(魏),2(蜀),3(吴),99(通用) 枚举 hVar.BUILDING_COUNTRY
		--build_type = 0,	--建筑类型
		--provide = {--功能数据 
			----资源 1级产出 2级产出 ....n级产出
			--["FOOD"] = {10,20,30,40,50,60,70,80,90,100,},
			----["FOOD"] = {{10,15},{20,25},{30,35},{40,45}},--随机填法
			--["WOOD"] = {10,20,30,40,50,60,70,80,90,100,},
			--["IRON"] = {10,20,30,40,50,60,70,80,90,100,},
			--["TACTICS"]={1083,1084,1085,1086,1087,},
			--["MEMBERS"]={50,80,120,160,200,200,200,200,200,200,},
		--},
		--upgrade = {--升级所需资源 
			----食物 木头 铁 军团等级 科技等级
			--[1] = {FOOD = 500,WOOD = 500,IRON = 500,LEGIONLV = 1,TECHNOLOGY = 1},
			--[2] = {FOOD = 1000,WOOD = 1000,IRON = 1000,LEGIONLV = 2,TECHNOLOGY = 1},
			--[3] = {FOOD = 1500,WOOD = 1500,IRON = 1500,LEGIONLV = 3,TECHNOLOGY = 1},
			--[4] = {FOOD = 2000,WOOD = 2000,IRON = 2000,LEGIONLV = 4,TECHNOLOGY = 1},
			--[5] = {FOOD = 2500,WOOD = 2500,IRON = 2500,LEGIONLV = 5,TECHNOLOGY = 1},
			--[6] = {FOOD = 3000,WOOD = 3000,IRON = 3000,LEGIONLV = 6,TECHNOLOGY = 1},
			--[7] = {FOOD = 3500,WOOD = 3500,IRON = 3500,LEGIONLV = 7,TECHNOLOGY = 1},
			--[8] = {FOOD = 4000,WOOD = 4000,IRON = 4000,LEGIONLV = 8,TECHNOLOGY = 1},
			--[9] = {FOOD = 4500,WOOD = 4500,IRON = 4500,LEGIONLV = 9,TECHNOLOGY = 1},
		--},
		--updatemodel = {--跟着等级改变模型
			----等级 模型
			--{4,"visit_cityhall_lv2"},	
			--{7,"visit_cityhall_lv3"},
		--},
	--},
--}

_tab_unit[80058] = {---41050
	type = 3,
	xlobj = "gres_farm",
	name = "农田（平原城）",
	labXY = {-9,50},
	seizable = 1,
	legioninfo = {
		maxlv = 5,	--最高等级
		country = 3,	--魏蜀独有
		build_type = hVar.LEGION_BUILDIND_TYPE.PRODUCE,	--生产建筑
		providemode = 1,--产出模式 1 默认获取所有 可不填 2 获取其中一个
		provide = {--生产资源 
			--资源 1级产出 2级产出 ....n级产出
			["FOOD"] = {40,80,120,160,200,200,200,200,200,200,},
		},
		upgrade = {--升级所需资源 
			--食物 木头 铁 军团等级 科技等级
			[1] = {FOOD = 200,WOOD = 200,IRON = 100,LEGIONLV = 1}, ---前置科技主城
			[2] = {FOOD = 300,WOOD = 300,IRON = 150,LEGIONLV = 2},
			[3] = {FOOD = 400,WOOD = 400,IRON = 200,LEGIONLV = 3},
			[4] = {FOOD = 500,WOOD = 500,IRON = 250,LEGIONLV = 4},
			[5] = {FOOD = 600,WOOD = 600,IRON = 300,LEGIONLV = 5},
		},
		updatemodel = {--跟着等级改变模型
			--等级 模型
---			{3,"gres_farm"},	
---			{5,"gres_farm"},
		},
	},
}

--_tab_unit[80062] = {---41045
	--type = 3,
	--xlobj = "visit_bar01",
	--name = "民居（城）",
	--upgrade = {0,},
	--price = {500,0,2,2,},
	--population = 1,
--}
_tab_unit[80062] = {---41045
	type = 3,
	xlobj = "visit_bar01",
	labXY = {-9,50},
	name = "民居（城）",
	seizable = 1,
	legioninfo = {
		maxlv = 5,	--最高等级
		country = 255,	--通用
		build_type = hVar.LEGION_BUILDIND_TYPE.RESIDENCE,	--住所
		providemode = 1,--产出模式 1 默认获取所有 可不填 2 获取其中一个
		provide = {--生产资源 
			--资源 1级产出 2级产出 ....n级产出
			["MEMBERS"] = {15,20,30,40,50,		50,50,50,50,50,},
		},
		upgrade = {--升级所需资源 
			--食物 木头 铁 军团等级 科技等级
			[1] = {FOOD = 400,WOOD = 400,IRON = 200,LEGIONLV = 1}, ---前置科技主城
			[2] = {FOOD = 600,WOOD = 600,IRON = 300,LEGIONLV = 2},
			[3] = {FOOD = 800,WOOD = 800,IRON = 400,LEGIONLV = 3},
			[4] = {FOOD = 1000,WOOD = 1000,IRON = 500,LEGIONLV = 4},
			[5] = {FOOD = 1200,WOOD = 1200,IRON = 600,LEGIONLV = 5},
---			[6] = {FOOD = 3000,WOOD = 3000,IRON = 3000,LEGIONLV = 6,TECHNOLOGY = 1},
---			[7] = {FOOD = 3500,WOOD = 3500,IRON = 3500,LEGIONLV = 7,TECHNOLOGY = 1},
---			[8] = {FOOD = 4000,WOOD = 4000,IRON = 4000,LEGIONLV = 8,TECHNOLOGY = 1},
---			[9] = {FOOD = 4500,WOOD = 4500,IRON = 4500,LEGIONLV = 9,TECHNOLOGY = 1},
		},
		updatemodel = {--跟着等级改变模型
			--等级 模型
---			{3,"visit_cityhall_lv2"},	
---			{5,"visit_cityhall_lv3"},
		},
	},
}





_tab_unit[80063] = {---43002
	type = 3,
	xlobj = "gres_wood",
	name = "伐木场",
	labXY = {-9,50},
	seizable = 1,
	legioninfo = {
		maxlv = 5,	--最高等级
		country = 255,	--通用
		build_type = hVar.LEGION_BUILDIND_TYPE.PRODUCE,	--生产建筑
		providemode = 1,--产出模式 1 默认获取所有 可不填 2 获取其中一个
		provide = {--生产资源 
			--资源 1级产出 2级产出 ....n级产出
			["WOOD"] = {40,80,120,160,200,200,200,200,200,200,},
		},
		upgrade = {--升级所需资源 
			--食物 木头 铁 军团等级 科技等级
			[1] = {FOOD = 200,WOOD = 200,IRON = 100,LEGIONLV = 1}, ---前置科技主城
			[2] = {FOOD = 300,WOOD = 300,IRON = 150,LEGIONLV = 2},
			[3] = {FOOD = 400,WOOD = 400,IRON = 200,LEGIONLV = 3},
			[4] = {FOOD = 500,WOOD = 500,IRON = 250,LEGIONLV = 4},
			[5] = {FOOD = 600,WOOD = 600,IRON = 300,LEGIONLV = 5},
		},
		updatemodel = {--跟着等级改变模型
			--等级 模型
---			{3,"gres_farm"},	
---			{5,"gres_farm"},
		},
	},
}



_tab_unit[80065] = {---43004
	type = 3,
	xlobj = "gres_mine",
	name = "铁矿洞",
	labXY = {1,50},
	seizable = 1,
	legioninfo = {
		maxlv = 5,	--最高等级
		country = 255,	--通用
		build_type = hVar.LEGION_BUILDIND_TYPE.PRODUCE,	--生产建筑
		providemode = 1,--产出模式 1 默认获取所有 可不填 2 获取其中一个
		provide = {--生产资源 
			--资源 1级产出 2级产出 ....n级产出
---			{"FOOD",10,20,30,40,50,60,70,80,90,100,},
			--{"FOOD",{10,15},{20,25},{30,35},{40,45}},--随机填法
----			{"WOOD",10,20,30,40,50,60,70,80,90,100,},
			["IRON"] = {20,40,60,80,100,200,200,200,200,200,},
		},
		upgrade = {--升级所需资源 
			--食物 木头 铁 军团等级 科技等级
			[1] = {FOOD = 200,WOOD = 200,IRON = 100,LEGIONLV = 1}, ---前置科技主城
			[2] = {FOOD = 300,WOOD = 300,IRON = 150,LEGIONLV = 2},
			[3] = {FOOD = 400,WOOD = 400,IRON = 200,LEGIONLV = 3},
			[4] = {FOOD = 500,WOOD = 500,IRON = 250,LEGIONLV = 4},
			[5] = {FOOD = 600,WOOD = 600,IRON = 300,LEGIONLV = 5},
		},
		updatemodel = {--跟着等级改变模型
			--等级 模型
---			{3,"gres_farm"},	
---			{5,"gres_farm"},
		},
	},
}


_tab_unit[80066] = {---41071
	type = 3,
	xlobj = "visit_market",
	name = "市场（城）",
	seizable = 1,
	labXY = {-9,50},
	legioninfo = {
		maxlv = 1,	--最高等级
		--notenable = 1,	--暂未开放
		country = 255,	--通用
		build_type = hVar.LEGION_BUILDIND_TYPE.SHOP,	--市场
		providemode = 1,--产出模式 1 默认获取所有 可不填 2 获取其中一个
		provide = {--生产资源 
			--资源 1级产出 2级产出 ....n级产出
			
		},
		upgrade = {--升级所需资源 
			--食物 木头 铁 军团等级 科技等级
			[1] = {FOOD = 1000,WOOD = 1000,IRON = 500,TECHNOLOGY = 2},
---			[2] = {FOOD = 1000,WOOD = 1000,IRON = 1000,TECHNOLOGY = 2},
---			[3] = {FOOD = 1500,WOOD = 1500,IRON = 1500,TECHNOLOGY = 3},
---			[4] = {FOOD = 2000,WOOD = 2000,IRON = 2000,TECHNOLOGY = 4},
---			[5] = {FOOD = 2500,WOOD = 2500,IRON = 2500,TECHNOLOGY = 5},
---			[6] = {FOOD = 3000,WOOD = 3000,IRON = 3000,LEGIONLV = 6,TECHNOLOGY = 1},
---			[7] = {FOOD = 3500,WOOD = 3500,IRON = 3500,LEGIONLV = 7,TECHNOLOGY = 1},
---			[8] = {FOOD = 4000,WOOD = 4000,IRON = 4000,LEGIONLV = 8,TECHNOLOGY = 1},
---			[9] = {FOOD = 4500,WOOD = 4500,IRON = 4500,LEGIONLV = 9,TECHNOLOGY = 1},
		},
		updatemodel = {--跟着等级改变模型
			--等级 模型
---			{3,"gres_cityhall_lv2"},	
---			{5,"gres_cityhall_lv3"},
		},
	},
}

_tab_unit[80067] = {---41055
	type = 3,
	xlobj = "gres_factory",
	name = "兵工坊（城）",
	labXY = {-9,50},
	seizable = 1,
	legioninfo = {
		maxlv = 5,	--最高等级
		country = 255,	--通用
		build_type = hVar.LEGION_BUILDIND_TYPE.UNIQUETACTICS,	--战术
		providemode = 1,--产出模式 1 默认获取所有 可不填 2 获取其中一个
		provide = {--生产资源 
			--资源 1级产出 2级产出 ....n级产出
			["UNIQUETACTICS"] = {1088,1089,1093,1094,1095,},
		},
		upgrade = {--升级所需资源 
			--食物 木头 铁 军团等级 科技等级
			[1] = {FOOD = 400,WOOD = 400,IRON = 200,TECHNOLOGY = 1},
			[2] = {FOOD = 600,WOOD = 600,IRON = 300,TECHNOLOGY = 2},
			[3] = {FOOD = 800,WOOD = 800,IRON = 400,TECHNOLOGY = 3},
			[4] = {FOOD = 1000,WOOD = 1000,IRON = 500,TECHNOLOGY = 4},
			[5] = {FOOD = 1200,WOOD = 1200,IRON = 600,TECHNOLOGY = 5},
---			[6] = {FOOD = 3000,WOOD = 3000,IRON = 3000,LEGIONLV = 6,TECHNOLOGY = 1},
---			[7] = {FOOD = 3500,WOOD = 3500,IRON = 3500,LEGIONLV = 7,TECHNOLOGY = 1},
---			[8] = {FOOD = 4000,WOOD = 4000,IRON = 4000,LEGIONLV = 8,TECHNOLOGY = 1},
---			[9] = {FOOD = 4500,WOOD = 4500,IRON = 4500,LEGIONLV = 9,TECHNOLOGY = 1},
		},
		updatemodel = {--跟着等级改变模型
			--等级 模型
---			{3,"gres_cityhall_lv2"},	
---			{5,"gres_cityhall_lv3"},
		},
	},
}



_tab_unit[80068] = {---41000
	type = 3,
	xlobj = "visit_cityhall_lv1",
	name = "府邸LV1（平原城）",
	labXY = {15,70},
	seizable = 1,
	legioninfo = {
		maxlv = 5,	--最高等级
		country = 255,	--通用
		build_type = hVar.LEGION_BUILDIND_TYPE.MAIN,	--主城
		providemode = 1,--产出模式 1 默认获取所有 可不填 2 获取其中一个
		provide = {--生产资源 
			--资源 1级产出 2级产出 ....n级产出
			["COIN"] = {5,10,15,20,25,25,25,25,25,25},
		},
		upgrade = {--升级所需资源 
			--食物 木头 铁 军团等级 科技等级
			[1] = {FOOD = 0,WOOD = 0,IRON = 0,},
			[2] = {FOOD = 3000,WOOD = 3000,IRON = 1500,},
			[3] = {FOOD = 4000,WOOD = 4000,IRON = 2000,},
			[4] = {FOOD = 5000,WOOD = 5000,IRON = 2500,},
			[5] = {FOOD = 6000,WOOD = 6000,IRON = 3000,},
---			[6] = {FOOD = 3000,WOOD = 3000,IRON = 3000,LEGIONLV = 6,TECHNOLOGY = 1},
---			[7] = {FOOD = 3500,WOOD = 3500,IRON = 3500,LEGIONLV = 7,TECHNOLOGY = 1},
---			[8] = {FOOD = 4000,WOOD = 4000,IRON = 4000,LEGIONLV = 8,TECHNOLOGY = 1},
---			[9] = {FOOD = 4500,WOOD = 4500,IRON = 4500,LEGIONLV = 9,TECHNOLOGY = 1},
		},
		updatemodel = {--跟着等级改变模型
			--等级 模型
			{3,"visit_cityhall_lv2"},	
			{5,"visit_cityhall_lv3"},
		},
	},
}



_tab_unit[80069] = {---41015
	type = 3,
	xlobj = "gres_cityhall_lv1",
	name = "翰林院LV1（平原城）",
	labXY = {-9,50},
	seizable = 1,
	legioninfo = {
		maxlv = 5,	--最高等级
		country = 255,	--通用
		build_type = hVar.LEGION_BUILDIND_TYPE.TECHNOLOGY,	--科技
		providemode = 1,--产出模式 1 默认获取所有 可不填 2 获取其中一个
		provide = {--生产资源 
			--资源 1级产出 2级产出 ....n级产出
		},
		upgrade = {--升级所需资源 
			--食物 木头 铁 军团等级 科技等级
			[1] = {FOOD = 800,WOOD = 800,IRON = 400,LEGIONLV = 1,},
			[2] = {FOOD = 1200,WOOD = 1200,IRON = 600,LEGIONLV = 2,},
			[3] = {FOOD = 1600,WOOD = 1600,IRON = 800,LEGIONLV = 3,},
			[4] = {FOOD = 2000,WOOD = 2000,IRON = 1000,LEGIONLV = 4,},
			[5] = {FOOD = 2400,WOOD = 2400,IRON = 1200,LEGIONLV = 5,},
---			[1] = {FOOD = 1600,WOOD = 1600,IRON = 800,},
---			[2] = {FOOD = 2400,WOOD = 2400,IRON = 1200,},
---			[3] = {FOOD = 3200,WOOD = 3200,IRON = 1600,},
---			[4] = {FOOD = 4000,WOOD = 4000,IRON = 2000,},
---			[5] = {FOOD = 4800,WOOD = 4800,IRON = 2400,},
---			[6] = {FOOD = 3000,WOOD = 3000,IRON = 3000,LEGIONLV = 6,TECHNOLOGY = 1},
---			[7] = {FOOD = 3500,WOOD = 3500,IRON = 3500,LEGIONLV = 7,TECHNOLOGY = 1},
---			[8] = {FOOD = 4000,WOOD = 4000,IRON = 4000,LEGIONLV = 8,TECHNOLOGY = 1},
---			[9] = {FOOD = 4500,WOOD = 4500,IRON = 4500,LEGIONLV = 9,TECHNOLOGY = 1},
		},
		updatemodel = {--跟着等级改变模型
			--等级 模型
			{3,"gres_cityhall_lv2"},	
			{5,"gres_cityhall_lv3"},
		},
	},
}


_tab_unit[80207] = {---41072
	type = 3,
	xlobj = "visit_temple",
	name = "寺庙（城）",
	labXY = {-9,50},
	seizable = 1,
	legioninfo = {
		maxlv = 5,	--最高等级
		country = 255,	--通用
		build_type = hVar.LEGION_BUILDIND_TYPE.PRODUCE,	--生产资源类
		providemode = 2,--产出模式 1 默认获取所有 可不填 2 获取其中一个
		provide = {--生产资源 
			--资源 1级产出 2级产出 ....n级产出
			["FOOD"] = {40,80,120,160,200,200,200,200,200,200,},
			["WOOD"] = {40,80,120,160,200,200,200,200,200,200,},
			["IRON"] = {20,40,60,80,100,100,100,100,100,100,},
		},
		upgrade = {--升级所需资源 
			--食物 木头 铁 军团等级 科技等级
			[1] = {FOOD = 200,WOOD = 200,IRON = 100,LEGIONLV = 1}, ---前置科技主城
			[2] = {FOOD = 300,WOOD = 300,IRON = 150,LEGIONLV = 2},
			[3] = {FOOD = 400,WOOD = 400,IRON = 200,LEGIONLV = 3},
			[4] = {FOOD = 500,WOOD = 500,IRON = 250,LEGIONLV = 4},
			[5] = {FOOD = 600,WOOD = 600,IRON = 300,LEGIONLV = 5},
---			[6] = {FOOD = 3000,WOOD = 3000,IRON = 3000,LEGIONLV = 6,TECHNOLOGY = 1},
---			[7] = {FOOD = 3500,WOOD = 3500,IRON = 3500,LEGIONLV = 7,TECHNOLOGY = 1},
---			[8] = {FOOD = 4000,WOOD = 4000,IRON = 4000,LEGIONLV = 8,TECHNOLOGY = 1},
---			[9] = {FOOD = 4500,WOOD = 4500,IRON = 4500,LEGIONLV = 9,TECHNOLOGY = 1},
		},
		updatemodel = {--跟着等级改变模型
			--等级 模型
---			{3,"gres_cityhall_lv2"},	
--			{5,"gres_cityhall_lv3"},
		},
	},
}


_tab_unit[80203] = {---41052
	type = 3,
	xlobj = "visit_wobjfisher",
	mask = "visit_wobjfisher_mask",
	name = "农田（水城）",
	labXY = {-9,50},
	seizable = 1,
	legioninfo = {
		maxlv = 5,	--最高等级
		country = 4,	--吴
		build_type = hVar.LEGION_BUILDIND_TYPE.PRODUCE,	--生产建筑
		providemode = 1,--产出模式 1 默认获取所有 可不填 2 获取其中一个
		provide = {--生产资源 
			--资源 1级产出 2级产出 ....n级产出
			["FOOD"] = {40,80,120,160,200,200,200,200,200,200,},
		},
		upgrade = {--升级所需资源 
			--食物 木头 铁 军团等级 科技等级
			[1] = {FOOD = 200,WOOD = 200,IRON = 100,LEGIONLV = 1}, ---前置科技主城
			[2] = {FOOD = 300,WOOD = 300,IRON = 150,LEGIONLV = 2},
			[3] = {FOOD = 400,WOOD = 400,IRON = 200,LEGIONLV = 3},
			[4] = {FOOD = 500,WOOD = 500,IRON = 250,LEGIONLV = 4},
			[5] = {FOOD = 600,WOOD = 600,IRON = 300,LEGIONLV = 5},
		},
		updatemodel = {--跟着等级改变模型
			--等级 模型
---			{3,"gres_farm"},	
---			{5,"gres_farm"},
		},
	},
}


_tab_unit[80208] = {---41150
	type = 3,
	xlobj = "visit_tortoise",
	name = "玄龟池（城）",
	labXY = {-9,50},
	seizable = 1,
	legioninfo = {
		maxlv = 1,	--最高等级
		country = 4,	--吴
		build_type = hVar.LEGION_BUILDIND_TYPE.UNIQUETACTICS,	--战术
		providemode = 1,--产出模式 1 默认获取所有 可不填 2 获取其中一个
		provide = {--生产资源 
			--资源 1级产出 2级产出 ....n级产出
			["UNIQUETACTICS"] = {1081},
		},
		upgrade = {--升级所需资源 
			--食物 木头 铁 军团等级 科技等级
			[1] = {FOOD = 4000,WOOD = 4000,IRON = 2000,TECHNOLOGY = 5},
--			[2] = {FOOD = 1000,WOOD = 1000,IRON = 1000,TECHNOLOGY = 2},
---			[3] = {FOOD = 1500,WOOD = 1500,IRON = 1500,TECHNOLOGY = 3},
---			[4] = {FOOD = 2000,WOOD = 2000,IRON = 2000,TECHNOLOGY = 4},
---			[5] = {FOOD = 2500,WOOD = 2500,IRON = 2500,TECHNOLOGY = 5},
---			[6] = {FOOD = 3000,WOOD = 3000,IRON = 3000,LEGIONLV = 6,TECHNOLOGY = 1},
---			[7] = {FOOD = 3500,WOOD = 3500,IRON = 3500,LEGIONLV = 7,TECHNOLOGY = 1},
---			[8] = {FOOD = 4000,WOOD = 4000,IRON = 4000,LEGIONLV = 8,TECHNOLOGY = 1},
---			[9] = {FOOD = 4500,WOOD = 4500,IRON = 4500,LEGIONLV = 9,TECHNOLOGY = 1},
		},
		updatemodel = {--跟着等级改变模型
			--等级 模型
--			{3,"gres_cityhall_lv2"},	
--			{5,"gres_cityhall_lv3"},
		},
	},
}


_tab_unit[80209] = {---41130
	type = 3,
	xlobj = "visit_dragon",
	name = "盘龙崖（城）",
	labXY = {1,50},
	seizable = 1,
	legioninfo = {
		maxlv = 1,	--最高等级
		country = 2,	--蜀
		build_type = hVar.LEGION_BUILDIND_TYPE.UNIQUETACTICS,	--战术
		providemode = 1,--产出模式 1 默认获取所有 可不填 2 获取其中一个
		provide = {--生产资源 
			--资源 1级产出 2级产出 ....n级产出
			["UNIQUETACTICS"] = {1080},
		},
		upgrade = {--升级所需资源 
			--食物 木头 铁 军团等级 科技等级
			[1] = {FOOD = 4000,WOOD = 4000,IRON = 2000,TECHNOLOGY = 5},
--			[2] = {FOOD = 1000,WOOD = 1000,IRON = 1000,TECHNOLOGY = 2},
--			[3] = {FOOD = 1500,WOOD = 1500,IRON = 1500,TECHNOLOGY = 3},
---			[4] = {FOOD = 2000,WOOD = 2000,IRON = 2000,TECHNOLOGY = 4},
---			[5] = {FOOD = 2500,WOOD = 2500,IRON = 2500,TECHNOLOGY = 5},
---			[6] = {FOOD = 3000,WOOD = 3000,IRON = 3000,LEGIONLV = 6,TECHNOLOGY = 1},
---			[7] = {FOOD = 3500,WOOD = 3500,IRON = 3500,LEGIONLV = 7,TECHNOLOGY = 1},
---			[8] = {FOOD = 4000,WOOD = 4000,IRON = 4000,LEGIONLV = 8,TECHNOLOGY = 1},
---			[9] = {FOOD = 4500,WOOD = 4500,IRON = 4500,LEGIONLV = 9,TECHNOLOGY = 1},
		},
		updatemodel = {--跟着等级改变模型
			--等级 模型
--			{3,"gres_cityhall_lv2"},	
--			{5,"gres_cityhall_lv3"},
		},
	},
}

_tab_unit[80210] = {---41110
	type = 3,
	xlobj = "visit_phoenix_lv1",
	name = "铜雀台（城）",
	labXY = {1,50},
	seizable = 1,
	legioninfo = {
		maxlv = 1,	--最高等级
		country = 1,	--魏
		build_type = hVar.LEGION_BUILDIND_TYPE.UNIQUETACTICS,	--战术
		providemode = 1,--产出模式 1 默认获取所有 可不填 2 获取其中一个
		provide = {--生产资源 
			--资源 1级产出 2级产出 ....n级产出
			["UNIQUETACTICS"] = {1082},
		},
		upgrade = {--升级所需资源 
			--食物 木头 铁 军团等级 科技等级
			[1] = {FOOD = 4000,WOOD = 4000,IRON = 2000,TECHNOLOGY = 5},
---			[2] = {FOOD = 1000,WOOD = 1000,IRON = 1000,TECHNOLOGY = 2},
---			[3] = {FOOD = 1500,WOOD = 1500,IRON = 1500,TECHNOLOGY = 3},
---			[4] = {FOOD = 2000,WOOD = 2000,IRON = 2000,TECHNOLOGY = 4},
---			[5] = {FOOD = 2500,WOOD = 2500,IRON = 2500,TECHNOLOGY = 5},
---			[6] = {FOOD = 3000,WOOD = 3000,IRON = 3000,LEGIONLV = 6,TECHNOLOGY = 1},
---			[7] = {FOOD = 3500,WOOD = 3500,IRON = 3500,LEGIONLV = 7,TECHNOLOGY = 1},
---			[8] = {FOOD = 4000,WOOD = 4000,IRON = 4000,LEGIONLV = 8,TECHNOLOGY = 1},
---			[9] = {FOOD = 4500,WOOD = 4500,IRON = 4500,LEGIONLV = 9,TECHNOLOGY = 1},
		},
		updatemodel = {--跟着等级改变模型
			--等级 模型
--			{3,"gres_cityhall_lv2"},	
--			{5,"gres_cityhall_lv3"},
		},
	},
}