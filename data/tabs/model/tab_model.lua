local function __ModelDataConfig(m)
	local a = m.animation
	for k = 1,#a do
		local _a = m[a[k]]
		if _a==nil then
			_DEBUG_MSG("模型表["..i.."]"..tab_model[i].name.."中不存在动作: "..a[k].." !")
			m[a[k]] = {{0,0,16,16}}
			_a = m[a[k]]
		end
		_a.animationtime = 1
		if #_a<=0 or (#_a==1 and (_a[1][5] or 1)==1) then
			if type(_a.interval)=="number" then
				_a.animationtime = _a.interval
			else
				_a.animationtime = 1
				_a.interval = 0		--标记为单帧图片
			end
		else
			--计算一下此帧动画总耗时
			for n = 1,#_a do
				_a.animationtime = _a.animationtime + _a.interval*(_a[n][5] or 1)
			end
		end
	end
end

hVar.tab_model = {
	index = {},
	i = 90000,
	add = function(_,m)
		local tab_model = hVar.tab_model
		if m.name==nil then
			return
		end
		local index = tab_model.index[m.name]
		if index==nil then
			tab_model.i = tab_model.i + 1
			index = tab_model.i
		end
		tab_model[index] = m
		tab_model.index[m.name] = index
		__ModelDataConfig(m)
		return index
	end,
	init = function()
		local tab_model = hVar.tab_model
		--90000~99999留空,自动分配用
		for i = 1,tab_model.i-1 do
			if tab_model[i]~=0 and tab_model[i].name then
				local m = tab_model[i]
				tab_model.index[m.name] = i
				__ModelDataConfig(m)
			end
		end
	end
}
--连续的数组型表格！
for i = 1,99999 do
	hVar.tab_model[i] = 0
end
-----------------------------------------
--范例
--png
--_tab_model[1] = {
	--name = "MODEL:default",
	--image = "xxx.png",
	--animation = {
		--"stand",
	--},
	--stand = {
		--interval = 1000,
		--[1] = {0,0,32,32},
	--},
--}
--plist
--_tab_model[1] = {
	--name = "MODEL:default",
	--loadmode = "plist",
	--plist = "xxx.plist",
	--image = "xxx.pvr.ccz",
	--animation = {
		--"stand",
	--},
	--stand = {
		--interval = 1000,
		--pName = "xxx_",	--[plist key必须为 xxx_0001.png~xxx_000n.png,n为下表中的第5个参数]
		--[1] = {0,0,32,32,8},
	--},
--}
-----------------------------------------
local _tab_model = hVar.tab_model
_tab_model[1] = {
	name = "MODEL:default",
	image = "misc/mask.png",
	animation = {
		"stand",
	},
	stand = {
		interval = 1000,
		[1] = {0,0,32,32},
	},
}

--_tab_model[2] = {
	--name = "MODEL:grid",
	--image = "grid.png",
	--animation = {
		--"blue",
		--"red",
		--"green",
	--},
	--blue = {
		--interval = 1000,
		--[1] = {1,2,67,61},
	--},
	--red = {
		--interval = 1000,
		--[1] = {71,2,67,61},
	--},
	--green = {
		--interval = 1000,
		--[1] = {141,2,67,61},
	--},
--}
_tab_model[2] = {
	name = "MODEL:grid",
	image = "misc/gridAx6.png",
	animation = {
		"gray",
		"blue",
		"red",
		"green",
		"yellow",
		"gray_blue",
		"gray_red",
		"gray_green",
		"gray_yellow",
	},
	gray = {
		[1] = {0,64*2,64,64},
	},
	blue = {
		[1] = {0,0,64,64},
	},
	red = {
		[1] = {64,0,64,64},
	},
	green = {
		[1] = {64*2,0,64,64},
	},
	yellow = {
		[1] = {64*3,0,64,64},
	},
	gray_blue = {
		[1] = {0,64,64,64},
	},
	gray_red = {
		[1] = {64,64,64,64},
	},
	gray_green = {
		[1] = {64*2,64,64,64},
	},
	gray_yellow = {
		[1] = {64*3,64,64,64},
	},
}

_tab_model[3] = {
	name = "MODEL:gridAx4",
	image = "misc/gridAx4.png",
	animation = {
		"gray",
		"blue",
		"red",
		"green",
	},
	gray = {
		[1] = {0,0,128,128},
	},
	blue = {
		[1] = {0,0,128,128},
	},
	red = {
		[1] = {129,0,128,128},
	},
	green = {
		[1] = {258,0,128,128},
	},
}

_tab_model[4] = {
	name = "MODEL:pSword",
	image = "misc/mask.png",
	loadmode = "plist",
	plist = "misc/psword.plist",
	image = "misc/psword.png",
	animation = {},
}
local _ConvI = {1,2,3,8,4,7,6,5}
local _Anim = _tab_model[4].animation
local _TabM = _tab_model[4]
for i = 1,8 do
	local cI = _ConvI[i]
	_Anim[#_Anim+1] = "stand_"..i
	_TabM["stand_"..i] = {
		pName = "psword/0"..cI.."/00"..cI,
		interval = 100,
		[1] = {0,0,256,256,5},
	}
end

_tab_model[5] = {
	name = "UI:pointer",
	image = "ui/up.png",
	animation = {
		"U",
		"D",
		"L",
		"R",
	},
	U = {
		[1] = {0,0,128,128},
	},
	D = {
		[1] = {0,0,128,128},
		flipY = 1,
	},
	L = {
		[1] = {0,0,128,128},
		roll = 90,
	},
	R = {
		[1] = {0,0,128,128},
		roll = 270,
	},
}
--9号往下都是单位模型了

--一个会动的箭头动画
_tab_model[100] = {
	name = "Action:updown",
	image = "ui/map_arrow_03.png",
	motion = {{0,-5,0.3},{0,0,0.3}},
	animation = {
		"updown",
	},
	updown = {
		interval = 100,
		[1] = {0,0,64,64},
	},
}

_tab_model[101] = {
	name = "Action:button_return",
	image = "ui/button_return01.png",
	motion = {{0,0,0.3},{-5,0,0.3}},
	animation = {
		"Action_return",
		"Action_next",

	},
	Action_return = {
		interval = 100,
		[1] = {0,0,64,64},
	},
	Action_next = {
		flipX = 1,
		interval = 100,
		[1] = {0,0,64,64},
	},
}


_tab_model[102] = {
	name = "Action:Hammer",
	image = "ui/hammer.png",
	motion = {{0,5,0.4},{0,0,0.4}},
	animation = {
		"updown",
	},
	updown = {
		interval = 100,
		[1] = {0,0,64,64},
		--[2] = {0,-2,64,64},
		--[3] = {0,-5,64,64},
		--[4] = {0,-2,64,64},
		--[5] = {0,0,64,64},
	},
}

_tab_model[103] = {
	name = "Action:Hire",
	image = "ui/icon01_x6y1.png",
	motion = {{0,5,0.4},{0,0,0.4}},
	animation = {
		"updown",
	},
	updown = {
		interval = 100,
		[1] = {0,0,62,62},
		--[2] = {0,-2,62,62},
		--[3] = {0,-5,62,62},
		--[4] = {0,-2,62,62},
		--[5] = {0,0,62,62},
	},
}

_tab_model[104] = {
	name = "MODEL:duest",
	loadmode = "plist",
	plist = "effect/myztx.plist",
	image = "effect/myztx.pvr.ccz",
	animation = {
		"stand",
	},
	stand = {
		interval = 100,
		pName = "myz_",	--[plist key必须为 xxx_0001.png~xxx_000n.png,n为下表中的第5个参数]
		[1] = {0,0,32,32,9},
	},
}

_tab_model[105] = {
	name = "Action:button_next",
	image = "ui/button_resume.png",
	motion = {{0,0,0.3},{5,0,0.3}},
	animation = {
		"Action_next",
	},
	Action_next = {
		interval = 100,
		[1] = {0,0,64,64},
		--[2] = {-2,0,64,64},
		--[3] = {-5,0,64,64},
		--[4] = {-2,0,64,64},
		--[5] = {0,0,64,64},
	},
}

_tab_model[106] = {
	name = "Action:button_up_down",
	image = "ui/button_return01.png",
	motion = {{0,5,0.3},{0,0,0.3}},
	animation = {
		"Action_Up",
		"Action_Down",
	},
	Action_Up = {
		interval = 100,
		[1] = {0,0,64,64},
	},
	Action_Down = {
		flipX = 1,
		interval = 100,
		[1] = {0,0,64,64},
	},
}


_tab_model[107] = {
	name = "Action:button_gift",
	image = "ui/gift.png",
	motion = {{0,0,0.3},{0,-5,0.3}},
	animation = {
		"UPDOWN",
	},
	UPDOWN = {
		interval = 100,
		[1] = {0,0,64,64},
	},
}

--Frame基本样式
_tab_model[108] = {
	name = "UI:TileFrmBasic",
	image = "panel/panel_part_00.png",
	animation = {
		"normal",
		"LT",
		"MT",
		"RT",
		"LC",
		"RC",
		"LB",
		"MB",
		"RB",
	},
	normal = {
		[1] = {0,0,256,256},
	},
	LT = {
		plus = {-24,24},
		image = "panel/panel_part_05.png",
		[1] = {0,0,96,96},
	},
	LB = {
		plus = {-23,-24},
		image = "panel/panel_part_08.png",
		[1] = {0,0,96,96},
	},
	RT = {
		plus = {23,24},
		image = "panel/panel_part_06.png",
		[1] = {0,0,96,96},
	},
	RB = {
		plus = {23,-24},
		image = "panel/panel_part_07.png",
		[1] = {0,0,96,96},
	},
	LC = {
		plus = {-30,0,0,48},
		image = "panel/panel_part_03.png",
		[1] = {0,0,48,48},
	},
	RC = {
		plus = {33,0,0,48},
		image = "panel/panel_part_04.png",
		[1] = {0,0,48,48},
	},
	MT = {
		plus = {0,25,48,0},
		image = "panel/panel_part_01.png",
		[1] = {0,0,48,48},
	},
	MB = {
		plus = {0,-27,48,0},
		image = "panel/panel_part_02.png",
		[1] = {0,0,48,48},
	},
}

_tab_model[109] = {
	name = "UI:TileFrmBasic_thin",
	image = "panel/panel_part_00.png",
	animation = {
		"normal",
		"LT",
		"MT",
		"RT",
		"LC",
		"RC",
		"LB",
		"MB",
		"RB",
	},
	normal = {
		[1] = {0,0,256,256},
	},
	LT = {
		plus = {-18,24},
		image = "panel/thin_LT.png",
		[1] = {0,0,96,96},
	},
	LB = {
		plus = {-17,-16},
		image = "panel/thin_LB.png",
		[1] = {0,0,96,96},
	},
	RT = {
		plus = {14,24},
		image = "panel/thin_RT.png",
		[1] = {0,0,96,96},
	},
	RB = {
		plus = {14,-16},
		image = "panel/thin_RB.png",
		[1] = {0,0,96,96},
	},
	LC = {
		plus = {-24,0,0,48},
		image = "panel/thin_LC.png",
		[1] = {0,0,48,48},
	},
	RC = {
		plus = {24,0,0,48},
		image = "panel/thin_RC.png",
		[1] = {0,0,48,48},
	},
	MT = {
		plus = {0,25,48,0},
		image = "panel/thin_MT.png",
		[1] = {0,0,48,48},
	},
	MB = {
		plus = {0,-19,48,0},
		image = "panel/thin_MB.png",
		[1] = {0,0,48,48},
	},
}