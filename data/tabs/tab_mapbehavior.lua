hVar.tab_mapbehavior = {}
local _tab_mapbehavior = hVar.tab_mapbehavior

-----------------------------------------------------------------
--引导关 
-----------------------------------------------------------------
--[1] = 100270001,	--全打死蜘蛛怪
--[2] = 100270002,	--破坏阻挡物
--[3] = 100270003,	--打死机枪怪
--[4] = 100270004,	--营救科学家
--[5] = 100270005,	--打死口水怪
--[6] = 100270006,	--使用火箭战术卡
--[7] = 100270007,	--打死第二批蜘蛛怪
--[8] = 100270008,	--打死大蜘蛛怪
--[9] = 100270009,	--进入黑龙区域
_tab_mapbehavior[100270001] = {--全打死蜘蛛怪
	sType = "killunit", --击杀怪
	unitidlist = {11113,11114},
	times = 2,
	inArea = {
		{450,600,1600,600}, --区域1
	}
	--condition = { -- 附加条件 
		--relation = "and",--"or"	--若存在多个附加条件  根据此参数判断是同时满足还是只需满足其一
		
	--},
}

_tab_mapbehavior[100270002] = {--破坏阻挡物
	sType = "killunit", --击杀怪
	unitidlist = {5177,5199},
	times = 2,
	inArea = {
		{1400,400,400,400}, --区域1
	},
}

_tab_mapbehavior[100270003] = {--打死机枪怪
	sType = "killunit", --击杀怪
	unitidlist = {11103},
	times = 1,
}

_tab_mapbehavior[100270004] = {--营救科学家
	sType = "getsource", --获取资源
	list = {"scientist"},
	times = 1,
}

_tab_mapbehavior[100270005] = {--打死口水怪
	sType = "killunit", --击杀怪
	unitidlist = {11100},
	times = 1,
}

_tab_mapbehavior[100270006] = {--使用火箭战术卡
	sType = "usetactics", --使用战术卡
	tacticsidlist = {12013},--单位id 非战术卡技能
	times = 1,
}

_tab_mapbehavior[100270007] = {--打死第二批蜘蛛怪
	sType = "killunit", --击杀怪
	unitidlist = {11113,11114},
	times = 6,
	inArea = {
		{2750,1950,1000,1000}, --区域1
	},
}

_tab_mapbehavior[100270008] = {--打死大蜘蛛怪
	sType = "killunit", --击杀怪
	unitidlist = {11105},
	times = 1,
}

_tab_mapbehavior[100270009] = {--进入黑龙区域
	sType = "enterarea", --进入区域
	times = 1,
	inArea = {
		{840,2520,100,240}, --区域1
	},
}
