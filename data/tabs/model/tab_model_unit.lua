local _tab_model = hVar.tab_model

--|  1  |
--|2 * 3|
--|  4  |
local function CreateModelDx4(m,code)
	m.modelmode = "DIRECTIONx4"
	for i = 1,4 do
		local a = code("stand",i)
		if a~=nil then
			m.animation[#m.animation+1] = "DIRECTION:"..i.."_stand"
			m["DIRECTION:"..i.."_stand"] = a
		end
		local a = code("walk",i)
		if a~=nil then
			m.animation[#m.animation+1] = "DIRECTION:"..i.."_walk"
			m["DIRECTION:"..i.."_walk"] = a
		end
		local a = code("attack",i)
		if a~=nil then
			m.animation[#m.animation+1] = "DIRECTION:"..i.."_attack"
			m["DIRECTION:"..i.."_attack"] = a
		end
	end
	return m
end

local function __512x512_Move3AttackN(attackNum,anchor)
	return function(anim,i)
		local row,flipX = {2,1,1,0},{0,0,1,0}
		if anim=="walk" then
			return {
				interval = 200,
				[1] = {128,row[i]*128,128,128},
				[2] = {0,row[i]*128,128,128},
				[3] = {128*2,row[i]*128,128,128},
				[4] = {0,row[i]*128,128,128},
				flipX = flipX[i],
				anchor = anchor,
			}
		elseif anim=="stand" then
			return {
				interval = 1000,
				[1] = {0,row[i]*128,128,128},
				flipX = flipX[i],
				anchor = anchor,
			}
		elseif anim=="attack" and attackNum>0 then
			return {
				interval = 150,
				[1] = {0,3*128,128,128,attackNum},
				anchor = anchor,
			}
		end
	end
end

local function __512x512_Move4AttackN(attackNum,anchor)
	return function(anim,i)
		local row,flipX = {2,1,1,0},{0,0,1,0}
		if anim=="walk" then
			return {
				interval = 100,
				[1] = {0,row[i]*128,128,128,4},
				flipX = flipX[i],
				anchor = anchor,
			}
		elseif anim=="stand" then
			return {
				interval = 1000,
				[1] = {0,row[i]*128,128,128},
				flipX = flipX[i],
				anchor = anchor,
			}
		elseif anim=="attack" and attackNum>0 then
			return {
				interval = 150,
				[1] = {0,3*128,128,128,attackNum},
				anchor = anchor,
			}
		end
	end
end



_tab_model[9] = CreateModelDx4({
	name = "MODEL:creature_white_knignt",
	image = "unit/shengwu/white_knight.png",
	animation = {},
},__512x512_Move4AttackN(4,{0.5,0.8}))

_tab_model[10] = CreateModelDx4({
	name = "MODEL:creature_red_knignt",
	image = "unit/shengwu/red_knight.png",
	animation = {},
},__512x512_Move4AttackN(4,{0.5,0.8}))

_tab_model[11] = CreateModelDx4({
	name = "MODEL:creature_soul_master",
	image = "unit/shengwu/soul_master.png",
	animation = {},
},__512x512_Move4AttackN(4,{0.5,0.8}))

_tab_model[12] = CreateModelDx4({
	name = "MODEL:creature_nightmare",
	image = "unit/shengwu/nightmare.png",
	animation = {},
},__512x512_Move3AttackN(4,{0.5,0.7}))

_tab_model[13] = CreateModelDx4({
	name = "MODEL:creature_ogre",
	image = "unit/shengwu/ogre.png",
	animation = {},
},__512x512_Move3AttackN(0,{0.5,0.9}))

_tab_model[14] = CreateModelDx4({
	name = "MODEL:creature_wurm",
	image = "unit/shengwu/wurm.png",
	animation = {},
},__512x512_Move3AttackN(4,{0.5,0.9}))

_tab_model[15] = CreateModelDx4({
	name = "MODEL:creature_headless_knight",
	image = "unit/shengwu/headless_knight.png",
	animation = {},
},__512x512_Move4AttackN(0,{0.5,0.9}))

_tab_model[16] = CreateModelDx4({
	name = "MODEL:creature_demon_hunter",
	image = "unit/shengwu/demon_hunter.png",
	animation = {},
},__512x512_Move4AttackN(4,{0.5,0.8}))

_tab_model[17] = CreateModelDx4({
	name = "MODEL:creature_heilong",
	image = "unit/shengwu/heilong.png",
	animation = {},
},__512x512_Move3AttackN(3,{0.5,0.9}))


_tab_model[18] = {
	name = "MODEL:cell",
	image = "unit/shengwu/cell.png",
	animation = {
		"stand",
		"walk",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,118,118,1},
		
	},
	walk = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {118,0,118,118,1},
	},
}

_tab_model[19] = {
	name = "MODEL:palace",
	image = "unit/shengwu/palace.png",
	animation = {
		"stand",
		"walk",
	},
	stand = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {0,0,176,160,1},
		
	},
	walk = {
		anchor = {0.5,0.5},
		interval = 100,
		[1] = {176,0,176,160,1},
	},
}

_tab_model[650] = {
	name = "MODEL:UNIT_JEEP_SHANDIAN",
	loadmode = "plist",
	plist = "unit/jeepgun6.plist",
	image = "unit/jeepgun6.png",
	animation = {
		"stand",
		"attack",
	},
	stand = {
		anchor = {0.5,0.45},
		interval = 100,
		pName = "jeepgun6/stand/1000",
		pMode = 2,
		[1] = {0,0,0,0,1},
	},
	attack = {
		anchor = {0.5,0.45},
		interval = 100,
		pName = "jeepgun6/attack/1000",
		pMode = 2,
		[1] = {0,0,0,0,3},
	},
}

--====================================================
-- 以下为自动生成的表项
--[301+]普通单位4方向
local baseID = 300
local CreatureUnitDx4 = {
	{"shijiu",396,180},
	{"lvlong",268,272},
	{"honglong",294,200},
	{"juzhuayalong",342,184},
	{"tianmaqishi",336,280},
}
local dt = {
	[1] = {y=4,flipX = 0,flipY = 0},
	[2] = {y=2,flipX = 0,flipY = 0},
	[3] = {y=3,flipX = 0,flipY = 0},
	[4] = {y=1,flipX = 0,flipY = 0},
}
local index = 0
for i = 1,#CreatureUnitDx4 do
	local v = CreatureUnitDx4[i]
	index = index + 1
	local w,h = math.floor(v[2]/6),math.floor(v[3]/4)
	local name = v[1]
	local path = "unit/shengwu/"
	_tab_model[baseID+index] = {
		name = "MODEL:creature_"..name,
		image = path..name..".png",
		modelmode = "DIRECTIONx4",
		animation = {},
	}
	local t = _tab_model[baseID+index]
	for n = 1,#dt do
		local d =dt[n]
		local index = #t.animation+1
		t.animation[index] = "DIRECTION:"..n.."_stand"
		t["DIRECTION:"..n.."_stand"] = {
			anchor = {0.5,0.7},
			interval = 100,
			flipX = d.flipX,
			flipY = d.flipY,
			[1] = {0,(d.y-1)*h,w,h,6},
		}
		t.animation[index+1] = "DIRECTION:"..n.."_walk"
		t["DIRECTION:"..n.."_walk"] = {
			anchor = {0.5,0.7},
			interval = 100,
			flipX = d.flipX,
			flipY = d.flipY,
			[1] = {0,(d.y-1)*h,w,h,6},
		}
	end
end

---------------------------------------
--[401+]普通单位4方向
--local baseID = 400
--local HumanUnitDx4 = {
	--group = {
		--"NPC",
		--"wei",
		--"shu",
		--"wu",
	--},
	--["NPC"] = {
		--"canjun",
		--"ceshi",
		--"daozei",
		--"daozeitoumu",
		--"gongbing",
		--"gongqibing",
		--"jinweibing",
		--"mangfu",
		--"moushi",
		--"mubing",
		--"muren",
		--"nubing",
		--"nuqibing",
		--"qingbubing",
		--"qingqibing",
		--"she",
		--"wunv",
		--"yunshubing",
		--"zhongbubing",
		--"zhongqibing",
	--},
	--["wei"] = {
		--"caocao(qima)",
		--"caoren",
		--"pangde",
		--"simayi",
		--"xiahoudun",
		--"xiahoudun(qima)",
		--"xuhuang",
		--"xuhuang(qima)",
		--"xuzhu",
		--"xuzhu(qima)",
		--"zhanghe",
		--"zhangliao(qima)",
	--},
	--["shu"] = {
		--"guanping",
		--"guanyu",
		--"guanyu(qima)",
		--"huangzhong(qima)",
		--"liubei(qima)",
		--"machao(qima)",
		--"weiyan",
		--"zhangfei",
		--"zhangfei(qima)",
		--"zhaoyun",
		--"zhaoyun(qima)",
		--"zhoucang",
		--"zhugeliang"
	--},
	--["wu"] = {
		--"ganning",
		--"huanggai",
		--"luxun",
		--"sunce",
		--"sunjian",
		--"sunshangxiang",
		--"zhoutai",
	--},
--}

--|  1  |
--|2 * 3|
--|  4  |
local dt = {
	[1] = {y=4,flipX = 0,flipY = 0},
	[2] = {y=2,flipX = 0,flipY = 0},
	[3] = {y=2,flipX = 1,flipY = 0},
	[4] = {y=1,flipX = 0,flipY = 0},
}

_tab_model[444] = {
	name = "MODEL:unit_zhoucang",
	image = "unit/shengwu/hunter.png",
	animation = {
		"stand",
	},
	stand = {
		anchor = {0.5,0.6},
		interval = 100,
		[1] = {0,0,64,112,1},
	},
}

for n = 1,#dt do
	local w,h = 48,64
	local d =dt[n]
	local index = #_tab_model[444].animation+1
	_tab_model[444].animation[index] = "DIRECTION:"..n.."_stand"
	_tab_model[444]["DIRECTION:"..n.."_stand"] = {
		anchor = {0.5,0.7},
		interval = 1000,
		flipX = d.flipX,
		flipY = d.flipY,
		[1] = {0,(d.y-1)*h,w,h,1},
	}
	_tab_model[444].animation[index+1] = "DIRECTION:"..n.."_walk"
	_tab_model[444]["DIRECTION:"..n.."_walk"] = {
		anchor = {0.5,0.7},
		interval = 100,
		flipX = d.flipX,
		flipY = d.flipY,
		[1] = {48,(d.y-1)*h,w,h,1},
		[2] = {48*3,(d.y-1)*h,w,h,1},
	}
end
--local index = 0
--for k = 1,#HumanUnitDx4.group do
	--local group = HumanUnitDx4.group[k]
	--local v = HumanUnitDx4[group]
	--for i = 1,#v do
		--index = index + 1
		--local w,h = 48,64
		--local name = v[i]
		--local path = "unit/"..group.."/"..name.."/"
		--_tab_model[baseID+index] = {
			--name = "MODEL:unit_"..name,
			--image = path..name..".png",
			--modelmode = "DIRECTIONx4",
			--animation = {},
		--}
		--local t = _tab_model[baseID+index]
		--for n = 1,#dt do
			--local d =dt[n]
			--local index = #t.animation+1
			--t.animation[index] = "DIRECTION:"..n.."_stand"
			--t["DIRECTION:"..n.."_stand"] = {
				--anchor = {0.5,0.7},
				--interval = 1000,
				--flipX = d.flipX,
				--flipY = d.flipY,
				--[1] = {0,(d.y-1)*h,w,h,1},
			--}
			--t.animation[index+1] = "DIRECTION:"..n.."_walk"
			--t["DIRECTION:"..n.."_walk"] = {
				--anchor = {0.5,0.7},
				--interval = 100,
				--flipX = d.flipX,
				--flipY = d.flipY,
				--[1] = {48,(d.y-1)*h,w,h,1},
				--[2] = {48*3,(d.y-1)*h,w,h,1},
			--}
			----这是另外一张图！
			--local w,h =64,64
			--t.animation[index+2] = "DIRECTION:"..n.."_attack"
			--t["DIRECTION:"..n.."_attack"] = {
				--image = path..name.."_melee.png",
				--anchor = {0.5,0.7},
				--interval = 150,
				--flipX = d.flipX,
				--flipY = d.flipY,
				--[1] = {0,(d.y-1)*h,w,h,4},
			--}
		--end
	--end
--end


--[501~518]大地图英雄8方向
--|1 2 3|
--|4 * 5|
--|6 7 8|
local baseID = 500
local dt =
{
	[1] = {x=4,flipX = 1,flipY = 0},
	[2] = {x=5,flipX = 0,flipY = 0},
	[3] = {x=4,flipX = 0,flipY = 0},
	[4] = {x=3,flipX = 1,flipY = 0},
	[5] = {x=3,flipX = 0,flipY = 0},
	[6] = {x=2,flipX = 1,flipY = 0},
	[7] = {x=1,flipX = 0,flipY = 0},
	[8] = {x=2,flipX = 0,flipY = 0},
}

for i = 1,18,1 do
	local num = i<=9 and 1 or 2
	local oY = i<=9 and i or i-9
	local t = {
		name = "MODEL:worldmap_hero_"..i,
		image = "misc/mask.png",
		modelmode = "DIRECTIONx8",
		animation = {},
	}
	for k = 1,#dt do
		local d = dt[k]
		t.animation[k] = "DIRECTION:"..k.."_stand"
		t["DIRECTION:"..k.."_stand"] = {
			image = "unit/heroMove8_"..num.."_STAND.png",
			anchor = {0.6,0.8},
			interval = 100,
			flipX = d.flipX,
			flipY = d.flipY,
			[1] = {(d.x-1)*96,(oY-1)*64,80,64,1,16},
		}
		t.animation[#d+k] = "DIRECTION:"..k.."_walk"
		t["DIRECTION:"..k.."_walk"] = {
			image = "unit/heroMove8_"..num.."_WALK_"..d.x..".png",
			anchor = {0.6,0.8},
			interval = 100,
			flipX = d.flipX,
			flipY = d.flipY,
			[1] = {0,(oY-1)*64,80,64,8,16},
		}
	end
	_tab_model[baseID+i] = t
end

--|  1  |--|    90   |
--|     |--|         |
--|2 * 3|--|180  *  0|
--|     |--|         |
--|  4  |--|   270   |
local _dTab4 =
{
	[1] = {row=3,flipX = 0,flipY = 0},
	[2] = {row=2,flipX = 1,flipY = 0},
	[3] = {row=2,flipX = 0,flipY = 0},
	[4] = {row=1,flipX = 0,flipY = 0},
}

--[501~518]三国英雄8方向
--|1 2 3|--|135   90   45|
--|     |--|             |
--|4 * 5|--|180   *     0|
--|     |--|             |
--|6 7 8|--|225  270  315|
local _dTab8 =
{
	[1] = {row=4,flipX = 1,flipY = 0},
	[2] = {row=5,flipX = 0,flipY = 0},
	[3] = {row=4,flipX = 0,flipY = 0},
	[4] = {row=3,flipX = 1,flipY = 0},
	[5] = {row=3,flipX = 0,flipY = 0},
	[6] = {row=2,flipX = 1,flipY = 0},
	[7] = {row=1,flipX = 0,flipY = 0},
	[8] = {row=2,flipX = 0,flipY = 0},
}

--16方向
--|1   2   3   4   5|--|135      112.5    90     67.5      45|
--|6               7|--|157.5                            22.5|
--|8       *       9|--|180               *                 0|
--|10             11|--|202.5                           337.5|
--|12  13  14  15 16|--|225     247.5    270    292.5     315|
local _dTab16 =
{
	[1] = {row=7,flipX = 1,flipY = 0},
	[2] = {row=8,flipX = 1,flipY = 0},
	[3] = {row=9,flipX = 0,flipY = 0},
	[4] = {row=8,flipX = 0,flipY = 0},
	[5] = {row=7,flipX = 0,flipY = 0},
	[6] = {row=6,flipX = 1,flipY = 0},
	[7] = {row=6,flipX = 0,flipY = 0},
	[8] = {row=5,flipX = 1,flipY = 0},
	[9] = {row=5,flipX = 0,flipY = 0},
	[10] = {row=4,flipX = 1,flipY = 0},
	[11] = {row=4,flipX = 0,flipY = 0},
	[12] = {row=3,flipX = 1,flipY = 0},
	[13] = {row=2,flipX = 1,flipY = 0},
	[14] = {row=1,flipX = 0,flipY = 0},
	[15] = {row=2,flipX = 0,flipY = 0},
	[16] = {row=3,flipX = 0,flipY = 0},
}

--|1    2    3    4    5    6    7|--|123.75    112.5     101.25     90     78.75     67.5     56.25|
--|8                             9|--|135                                                         45|
--|10                           11|--|146.25                                                   33.75|
--|12                           13|--|157.5                                                     22.5|
--|14                           15|--|168.75                                                   11.25|
--|16             *             17|--|180                            *                             0|
--|18                           19|--|191.25                                                  348.75|
--|20                           21|--|202.5                                                    337.5|
--|22                           23|--|213.75                                                  326.25|
--|24                           25|--|225                                                        315|
--|26   27   28   29   30   31  32|--|236.25    247.5    258.75     270    281.25    292.5    303.75|
--32方向
local _dTab32 =
{
	[1] = {row=14,flipX = 1,flipY = 0},
	[2] = {row=15,flipX = 1,flipY = 0},
	[3] = {row=16,flipX = 1,flipY = 0},
	[4] = {row=17,flipX = 0,flipY = 0},
	[5] = {row=16,flipX = 0,flipY = 0},
	[6] = {row=15,flipX = 0,flipY = 0},
	[7] = {row=14,flipX = 0,flipY = 0},
	[8] = {row=13,flipX = 1,flipY = 0},
	[9] = {row=13,flipX = 0,flipY = 0},
	[10] = {row=12,flipX = 1,flipY = 0},
	[11] = {row=12,flipX = 0,flipY = 0},
	[12] = {row=11,flipX = 1,flipY = 0},
	[13] = {row=11,flipX = 0,flipY = 0},
	[14] = {row=10,flipX = 1,flipY = 0},
	[15] = {row=10,flipX = 0,flipY = 0},
	[16] = {row=9,flipX = 1,flipY = 0},
	[17] = {row=9,flipX = 0,flipY = 0},
	[18] = {row=8,flipX = 1,flipY = 0},
	[19] = {row=8,flipX = 0,flipY = 0},
	[20] = {row=7,flipX = 1,flipY = 0},
	[21] = {row=7,flipX = 0,flipY = 0},
	[22] = {row=6,flipX = 1,flipY = 0},
	[23] = {row=6,flipX = 0,flipY = 0},
	[24] = {row=5,flipX = 1,flipY = 0},
	[25] = {row=5,flipX = 0,flipY = 0},
	[26] = {row=4,flipX = 1,flipY = 0},
	[27] = {row=3,flipX = 1,flipY = 0},
	[28] = {row=2,flipX = 1,flipY = 0},
	[29] = {row=1,flipX = 0,flipY = 0},
	[30] = {row=2,flipX = 0,flipY = 0},
	[31] = {row=3,flipX = 0,flipY = 0},
	[32] = {row=4,flipX = 0,flipY = 0},
}

function HeroModelDx8(name,path,animation,anchor, _dTab, _modelmode)
	_dTab = _dTab or _dTab8
	_modelmode = _modelmode or "DIRECTIONx8"
	
	local t = {
		name = name,
		image = "misc/mask.png",
		modelmode = _modelmode,
		animation = {},
	}
	--path..name..".png",
	for i = 1,#animation do
		local aName,aCount,aW,aH,aInterval,aAppendX = unpack(animation[i])
		for x = 1,#_dTab do
			local d = _dTab[x]
			local aniKey = "DIRECTION:"..x.."_"..aName
			t.animation[#t.animation+1] = aniKey
			local _a = {0.5,0.7}
			if anchor~=nil then
				_a[1],_a[2] = anchor[1],anchor[2]
			end
			local _path = string.gsub(path,"@",aName)
			t[aniKey] = {
				image = _path,
				anchor = _a,
				interval = aInterval or 100,
				flipX = d.flipX,
				flipY = d.flipY,
				[1] = {0,(d.row-1)*aH,aW,aH,aCount,aAppendX},
			}
		end
	end
	return t
end

function HeroModelDx8PL(name,plPath,pDoc,animation,anchor, _dTab, _modelmode)
	_dTab = _dTab or _dTab8
	_modelmode = _modelmode or "DIRECTIONx8"
	
	local s,e = string.find(plPath,".plist")
	if s and e then
		plPath = string.sub(plPath,1,s-1)
	end
	local t = {
		name = name,
		loadmode = "plist",
		plist = plPath..".plist",
		image = plPath..".pvr.ccz",
		--image = plPath..".png",
		modelmode = _modelmode,
		animation = {},
	}
	for i = 1,#animation do
		local aName,aCount,aW,aH,aInterval,aAppendX = unpack(animation[i])
		for x = 1,#_dTab do
			local d = _dTab[x]
			local aniKey = "DIRECTION:"..x.."_"..aName
			t.animation[#t.animation+1] = aniKey
			local _a = {0.5,0.7}
			if anchor~=nil then
				_a[1],_a[2] = anchor[1],anchor[2]
			end
			t[aniKey] = {
				pName = pDoc..aName.."/"..d.row,
				anchor = _a,
				interval = aInterval or 100,
				flipX = d.flipX,
				flipY = d.flipY,
				[1] = {0,0,aW,aH,aCount,aAppendX},
			}
		end
	end
	return t
end

function HeroModelDx8PL_2PIC(name,plPath,pDoc,animation,anchor, _dTab, _modelmode)
	_dTab = _dTab or _dTab8
	_modelmode = _modelmode or "DIRECTIONx8"
	
	local s,e = string.find(plPath,".plist")
	if s and e then
		plPath = string.sub(plPath,1,s-1)
	end
	local t = {
		name = name,
		loadmode = "plist",
		plist = plPath..".plist",
		image = plPath..".pvr.ccz",
		--image = plPath..".png",
		modelmode = _modelmode,
		animation = {},
	}
	for i = 1,#animation do
		local aName,aCount,aW,aH,aInterval,aAppendX = unpack(animation[i])
		local aPath = aName
		if type(aName)=="table" then
			aName,aPath = unpack(aName)
		end
		local mid = ""
		if aPath == "walk" or aPath == "stand" then
			mid = "_world"
		elseif aPath == "attack" or aPath == "skill" or aPath == "hit" or aPath == "dead" then
			mid = "_battle"
		end
		for x = 1,#_dTab do
			local d = _dTab[x]
			local aniKey = "DIRECTION:"..x.."_"..aName
			t.animation[#t.animation+1] = aniKey
			local _a = {0.5,0.7}
			if anchor~=nil then
				_a[1],_a[2] = anchor[1],anchor[2]
			end
			local pMode = nil
			local nFrameCount = aCount
			if type(aCount)=="table" then
				pMode = {aCount[1],aCount[2]}
				nFrameCount = math.abs(aCount[2]-aCount[1])
			end
			t[aniKey] = {
				pMode = pMode,
				pName = pDoc..mid.."/"..aPath.."/"..d.row,
				anchor = _a,
				interval = aInterval or 100,
				plist = plPath..mid..".plist",
				image = plPath..mid..".pvr.ccz",
				flipX = d.flipX,
				flipY = d.flipY,
				[1] = {0,0,aW,aH,nFrameCount,aAppendX},
			}
		end
	end
	return t
end

function HeroModelDx8PL_2PIC_2PAT(name,plPath,pDoc,plPath2,pDoc2,animation,anchor, _dTab, _modelmode)
	_dTab = _dTab or _dTab8
	_modelmode = _modelmode or "DIRECTIONx8"
	
	local s,e = string.find(plPath,".plist")
	if s and e then
		plPath = string.sub(plPath,1,s-1)
	end
	s,e = string.find(plPath2,".plist")
	if s and e then
		plPath2 = string.sub(plPath2,1,s-1)
	end
	local t = {
		name = name,
		loadmode = "plist",
		plist = plPath..".plist",
		image = plPath..".pvr.ccz",
		--image = plPath..".png",
		modelmode = _modelmode,
		animation = {},
	}
	for i = 1,#animation do
		local aName,aCount,aW,aH,aInterval,aAppendX = unpack(animation[i])
		local aPath = aName
		if type(aName)=="table" then
			aName,aPath = unpack(aName)
		end
		local mid = ""
		local pPath = ""
		local ppDoc = ""
		if aPath == "walk" or aPath == "stand" then
			mid = "_world"
			pPath = plPath
			ppDoc = pDoc
		elseif aPath == "attack" or aPath == "skill" or aPath == "hit" then
			mid = "_battle"
			pPath = plPath2
			ppDoc = pDoc2
		end
		for x = 1,#_dTab do
			local d = _dTab[x]
			local aniKey = "DIRECTION:"..x.."_"..aName
			t.animation[#t.animation+1] = aniKey
			local _a = {0.5,0.7}
			if anchor~=nil then
				_a[1],_a[2] = anchor[1],anchor[2]
			end
			local pMode = nil
			local nFrameCount = aCount
			if type(aCount)=="table" then
				pMode = {aCount[1],aCount[2]}
				nFrameCount = math.abs(aCount[2]-aCount[1])
			end
			t[aniKey] = {
				pMode = pMode,
				pName = ppDoc..mid.."/"..aPath.."/"..d.row,
				anchor = _a,
				interval = aInterval or 100,
				plist = pPath..mid..".plist",
				image = pPath..mid..".pvr.ccz",
				flipX = d.flipX,
				flipY = d.flipY,
				[1] = {0,0,aW,aH,nFrameCount,aAppendX},
			}
		end
	end
	return t
end

--UnitModelDx8PL_noplist("MODEL:8Dir2","misc/arrow_ext.png",80,40,{1,2,3,4,5,6,7,8},_animation_XVVI,{0.5,0.5})
function UnitModelDx8PL_noplist(name,image,w,h,ft,animation,anchor, _dTab, _modelmode)
	_dTab = _dTab or _dTab8
	_modelmode = _modelmode or "DIRECTIONx8"
	
	local t = {
		name = name,
		loadmode = "png",
		--plist = plPath..".plist",
		image = image,
		modelmode = _modelmode,
		animation = {},
	}
	for i = 1,#animation do
		local aName,aCount,aW,aH,aInterval,aAppendX = unpack(animation[i])
		local mid = ""
		local aPath = aName
		if type(aName)=="table" then
			aName,aPath = unpack(aName)
		end
		if aName == "walk" or aName == "stand" then
			mid = "_world"
		elseif aName == "attack" or aName == "skill" or aName == "hit" then
			mid = "_battle"
		end
		for x = 1,#_dTab do
			local d = _dTab[x]
			local aniKey = "DIRECTION:"..x.."_"..aName
			t.animation[#t.animation+1] = aniKey
			local _a = {0.5,0.7}
			if anchor~=nil then
				_a[1],_a[2] = anchor[1],anchor[2]
			end
			t[aniKey] = {
				pName = aPath.."/"..d.row,
				anchor = _a,
				interval = aInterval or 100,
				--plist = plPath..mid..".plist",
				image = image,
				flipX = 0,
				flipY = 0,
				[1] = {(ft[x] - 1)*w,0,aW,aH,aCount,aAppendX},
			}
		end
	end
	return t
end

function HeroModelDx8PL_1PIC(name,plPath,pDoc,animation,anchor, _dTab, _modelmode)
	_dTab = _dTab or _dTab8
	_modelmode = _modelmode or "DIRECTIONx8"
	
	local s,e = string.find(plPath,".plist")
	if s and e then
		plPath = string.sub(plPath,1,s-1)
	end
	local t = {
		name = name,
		loadmode = "plist",
		plist = plPath..".plist",
		image = plPath..".pvr.ccz",
		--image = plPath..".png",
		modelmode = _modelmode,
		animation = {},
	}
	for i = 1,#animation do
		local aName,aCount,aW,aH,aInterval,aAppendX = unpack(animation[i])
		local aPath = aName
		if type(aName)=="table" then
			aName,aPath = unpack(aName)
		end
		local mid = ""
		--if aPath == "walk" or aPath == "stand" then
			--mid = "_world"
		--elseif aPath == "attack" or aPath == "skill" or aPath == "hit" then
			--mid = "_battle"
		--end
		mid = "_battle"
		for x = 1,#_dTab do
			local d = _dTab[x]
			local aniKey = "DIRECTION:"..x.."_"..aName
			t.animation[#t.animation+1] = aniKey
			local _a = {0.5,0.7}
			if anchor~=nil then
				_a[1],_a[2] = anchor[1],anchor[2]
			end
			local pMode = nil
			local nFrameCount = aCount
			if type(aCount)=="table" then
				pMode = {aCount[1],aCount[2]}
				nFrameCount = math.abs(aCount[2]-aCount[1])
			end
			t[aniKey] = {
				pMode = pMode,
				pName = pDoc..mid.."/"..aPath.."/"..d.row,
				anchor = _a,
				interval = aInterval or 100,
				plist = plPath..mid..".plist",
				image = plPath..mid..".pvr.ccz",
				flipX = d.flipX,
				flipY = d.flipY,
				[1] = {0,0,aW,aH,nFrameCount,aAppendX},
			}
		end
	end
	return t
end

--2方向
function HeroModelDx2PL(name,plPath,pDoc,animation,anchor)
	local s,e = string.find(plPath,".plist")
	if s and e then
		plPath = string.sub(plPath,1,s-1)
	end
	local t = {
		name = name,
		loadmode = "plist",
		plist = plPath..".plist",
		image = plPath..".pvr.ccz",
		animation = {},
	}
	for i = 1,#animation do
		local aName,aCount,aW,aH,aInterval,aAppendX = unpack(animation[i])
		local aniKey = aName
		t.animation[#t.animation+1] = aniKey
		local _a = {0.5,0.7}
		if anchor~=nil then
			_a[1],_a[2] = anchor[1],anchor[2]
		end
		t[aniKey] = {
			pName = pDoc..aName.."/3",
			anchor = _a,
			flipX = 1,
			interval = aInterval or 100,
			[1] = {0,0,aW,aH,aCount,aAppendX},
		}
	end
	return t
end

function UnitModelDx2PL(name,plPath,pDoc,animation,anchor)
	local s,e = string.find(plPath,".plist")
	if s and e then
		plPath = string.sub(plPath,1,s-1)
	end
	local t = {
		name = name,
		loadmode = "plist",
		plist = plPath..".plist",
		image = plPath..".pvr.ccz",
		animation = {},
	}
	for i = 1,#animation do
		local aName,aCount,aW,aH,aInterval,aAppendX = unpack(animation[i])
		local aniKey = aName
		if type(aName)=="table" then
			aniKey = aName[1]
			aName = aName[2]
		end
		t.animation[#t.animation+1] = aniKey
		local _a = {0.5,0.7}
		if anchor~=nil then
			_a[1],_a[2] = anchor[1],anchor[2]
		end
		local pMode = 1
		if type(aCount)=="table" then
			pMode = aCount
			pMode[3] = 1
			aCount = 1
		end
		t[aniKey] = {
			pName = pDoc..aName.."/2",
			pMode = pMode,
			anchor = _a,
			flipX = 1,
			interval = aInterval or 100,
			[1] = {0,0,aW,aH,aCount,aAppendX},
		}
	end
	return t
end

--2方向读 plist
function UnitModelDx2PL_plist(name,plPath,pDoc,animation,anchor)
	--print("UnitModelDx2PL_plist")
	local s,e = string.find(plPath,".plist")
	if s and e then
		plPath = string.sub(plPath,1,s-1)
	end
	local t = {
		name = name,
		loadmode = "plist",
		plist = plPath..".plist",
		image = plPath..".pvr.ccz",
		animation = {},
	}

	for i = 1,#animation do
		local aName,aCount,aW,aH,aInterval,aAppendX = unpack(animation[i])
		local aniKey = aName
		if type(aName)=="table" then
			aniKey = aName[1]
			aName = aName[2]
		end
		
		t.animation[#t.animation+1] = aniKey
		local _a = {0.5,0.7}
		if anchor~=nil then
			_a[1],_a[2] = anchor[1],anchor[2]
		end
		local pMode = nil
		local nFrameCount = aCount
		if type(aCount)=="table" then
			pMode = {aCount[1],aCount[2]}
			pMode[3] = 1
			nFrameCount = math.abs(aCount[2]-aCount[1]+1)
		end
		--print(pDoc,aName,plPath,aniKey,nFrameCount,pMode)
		t[aniKey] = {
			pName = pDoc.."/"..aName.."/2",
			pMode = pMode,
			anchor = _a,
			plist = plPath..".plist",
			image = plPath..".pvr.ccz",
			flipX = 1,
			interval = aInterval or 100,
			[1] = {0,0,aW,aH,nFrameCount,aAppendX},
		}
	end
	return t
end

function UnitModelDx2PL_2PIC(name,plPath,pDoc,animation,anchor)
	local s,e = string.find(plPath,".plist")
	if s and e then
		plPath = string.sub(plPath,1,s-1)
	end
	local t = {
		name = name,
		loadmode = "plist",
		plist = plPath..".plist",
		image = plPath..".pvr.ccz",
		animation = {},
	}
	for i = 1,#animation do
		local aName,aCount,aW,aH,aInterval,aAppendX = unpack(animation[i])
		local aniKey = aName
		if type(aName)=="table" then
			aniKey = aName[1]
			aName = aName[2]
		end
		local mid = ""
		if aName == "walk" or aName == "stand" then
			mid = "_world"
		elseif aName == "attack" or aName == "attack1" or aName == "hit" or aName == "skill" or aName == "fly" then
			mid = "_battle"
		end
		t.animation[#t.animation+1] = aniKey
		local _a = {0.5,0.7}
		if anchor~=nil then
			_a[1],_a[2] = anchor[1],anchor[2]
		end
		local pMode = 1
		if type(aCount)=="table" then
			pMode = aCount
			pMode[3] = 1
			aCount = 1
		end
		t[aniKey] = {
			pName = pDoc..mid.."/"..aName.."/2",
			pMode = pMode,
			anchor = _a,
			plist = plPath..mid..".plist",
			image = plPath..mid..".pvr.ccz",
			flipX = 1,
			interval = aInterval or 100,
			[1] = {0,0,aW,aH,aCount,aAppendX},
		}
	end
	return t
end

function UnitModelDx2PL_2PIC_2PAT(name,plPath,pDoc,plPath2,pDoc2,animation,anchor)--从两个不同的资源名文件里加载
	local s,e = string.find(plPath,".plist")
	if s and e then
		plPath = string.sub(plPath,1,s-1)
	end
	s,e = string.find(plPath2,".plist")
	if s and e then
		plPath2 = string.sub(plPath2,1,s-1)
	end
	local t = {
		name = name,
		loadmode = "plist",
		plist = plPath..".plist",
		image = plPath..".pvr.ccz",
		animation = {},
	}
	for i = 1,#animation do
		local aName,aCount,aW,aH,aInterval,aAppendX = unpack(animation[i])
		local aniKey = aName
		if type(aName)=="table" then
			aniKey = aName[1]
			aName = aName[2]
		end
		local mid = ""
		local pPath = ""
		local ppDoc = ""
		if aName == "walk" or aName == "stand" then
			mid = "_world"
			pPath = plPath
			ppDoc = pDoc
		elseif aName == "attack" or aName == "attack1" or aName == "hit" or aName == "skill" or aName == "fly" then
			mid = "_battle"
			pPath = plPath2
			ppDoc = pDoc2
		end
		t.animation[#t.animation+1] = aniKey
		local _a = {0.5,0.7}
		if anchor~=nil then
			_a[1],_a[2] = anchor[1],anchor[2]
		end
		local pMode = 1
		if type(aCount)=="table" then
			pMode = aCount
			pMode[3] = 1
			aCount = 1
		end
		t[aniKey] = {
			pName = ppDoc..mid.."/"..aName.."/2",
			pMode = pMode,
			anchor = _a,
			plist = pPath..mid..".plist",
			image = pPath..mid..".pvr.ccz",
			flipX = 1,
			interval = aInterval or 100,
			[1] = {0,0,aW,aH,aCount,aAppendX},
		}
	end
	return t
end

function UnitModelDx2PL_2PIC_2PAT_FLY(name,plPath,pDoc,plPath2,pDoc2,animation,anchor)--从两个不同的资源名文件里加载
	local s,e = string.find(plPath,".plist")
	if s and e then
		plPath = string.sub(plPath,1,s-1)
	end
	s,e = string.find(plPath2,".plist")
	if s and e then
		plPath2 = string.sub(plPath2,1,s-1)
	end
	local t = {
		name = name,
		loadmode = "plist",
		plist = plPath..".plist",
		image = plPath..".pvr.ccz",
		animation = {},
	}
	for i = 1,#animation do
		local aName,aCount,aW,aH,aInterval,aAppendX,part = unpack(animation[i])
		local aniKey = aName
		if type(aName)=="table" then
			aniKey = aName[1]
			aName = aName[2]
		end
		local mid = ""
		local pPath = ""
		local ppDoc = ""
		if aName == "walk" or aName == "walk_shadow" or aName == "stand"  or aName == "fly" or aName == "fly_shadow" or aName == "land" or aName == "land_shadow" then
			mid = "_world"
			pPath = plPath
			ppDoc = pDoc
		elseif aName == "attack" or aName == "attack1" or aName == "hit" or aName == "skill" or aName == "skill1" or aName == "skill_shadow" or aName == "skill1_shadow" then
			mid = "_battle"
			pPath = plPath2
			ppDoc = pDoc2
		end
		t.animation[#t.animation+1] = aniKey
		local _a = {0.5,0.7}
		if anchor~=nil then
			_a[1],_a[2] = anchor[1],anchor[2]
		end
		local pMode = 1
		if type(aCount)=="table" then
			pMode = {aCount[1],aCount[2],1}
			aCount = 1
		end
		local aPath = aName
		if animation.reverse and animation.reverse[aName] then
			aPath = animation.reverse[aName]
			aCount = -1*aCount
		end
		t[aniKey] = {
			pName = ppDoc..mid.."/"..aPath.."/2",
			pMode = pMode,
			anchor = _a,
			plist = pPath..mid..".plist",
			image = pPath..mid..".pvr.ccz",
			flipX = 1,
			interval = aInterval or 100,
			part = part,
			[1] = {0,0,aW,aH,aCount,aAppendX},
		}
	end
	return t
end

--geyachao: 4方向的接口
function HeroModelDx4(name,path,animation,anchor)
	return HeroModelDx8(name,path,animation,anchor, _dTab4, "DIRECTIONx4")
end
function HeroModelDx4PL(name,plPath,pDoc,animation,anchor)
	return HeroModelDx8PL(name,plPath,pDoc,animation,anchor, _dTab4, "DIRECTIONx4")
end
function HeroModelDx4PL_2PIC(name,plPath,pDoc,animation,anchor)
	return HeroModelDx8PL_2PIC(name,plPath,pDoc,animation,anchor, _dTab4, "DIRECTIONx4")
end
function HeroModelDx4PL_2PIC_2PAT(name,plPath,pDoc,plPath2,pDoc2,animation,anchor)
	return HeroModelDx8PL_2PIC_2PAT(name,plPath,pDoc,plPath2,pDoc2,animation,anchor, _dTab4, "DIRECTIONx4")
end
function UnitModelDx4PL_noplist(name,image,w,h,ft,animation,anchor)
	return UnitModelDx8PL_noplist(name,image,w,h,ft,animation,anchor, _dTab4, "DIRECTIONx4")
end
function HeroModelDx4PL_1PIC(name,plPath,pDoc,animation,anchor)
	return HeroModelDx8PL_1PIC(name,plPath,pDoc,animation,anchor, _dTab4, "DIRECTIONx4")
end

--geyachao: 16方向的接口
function HeroModelDx16(name,path,animation,anchor)
	return HeroModelDx8(name,path,animation,anchor, _dTab16, "DIRECTIONx16")
end
function HeroModelDx16PL(name,plPath,pDoc,animation,anchor)
	return HeroModelDx8PL(name,plPath,pDoc,animation,anchor, _dTab16, "DIRECTIONx16")
end
function HeroModelDx16PL_2PIC(name,plPath,pDoc,animation,anchor)
	return HeroModelDx8PL_2PIC(name,plPath,pDoc,animation,anchor, _dTab16, "DIRECTIONx16")
end
function HeroModelDx16PL_2PIC_2PAT(name,plPath,pDoc,plPath2,pDoc2,animation,anchor)
	return HeroModelDx8PL_2PIC_2PAT(name,plPath,pDoc,plPath2,pDoc2,animation,anchor, _dTab16, "DIRECTIONx16")
end
function UnitModelDx16PL_noplist(name,image,w,h,ft,animation,anchor)
	return UnitModelDx8PL_noplist(name,image,w,h,ft,animation,anchor, _dTab16, "DIRECTIONx16")
end
function HeroModelDx16PL_1PIC(name,plPath,pDoc,animation,anchor)
	return HeroModelDx8PL_1PIC(name,plPath,pDoc,animation,anchor, _dTab16, "DIRECTIONx16")
end

--32方向
function HeroModelDx32PL_2PIC(name,plPath,pDoc,animation,anchor,_dTab,_modelmode)
	_dTab = _dTab or _dTab32
	_modelmode = _modelmode or "DIRECTIONx32"
	
	local s,e = string.find(plPath,".plist")
	if s and e then
		plPath = string.sub(plPath,1,s-1)
	end
	local t = {
		name = name,
		loadmode = "plist",
		plist = plPath..".plist",
		image = plPath..".pvr.ccz",
		--image = plPath..".png",
		modelmode = _modelmode,
		animation = {},
	}
	for i = 1,#animation do
		local aName,aCount,aW,aH,aInterval,aAppendX = unpack(animation[i])
		if (aCount > 0) then
			local aPath = aName
			if type(aName)=="table" then
				aName,aPath = unpack(aName)
			end
			local mid = ""
			if aPath == "walk" or aPath == "stand" then
				--mid = "_world"
			elseif aPath == "attack" or aPath == "skill" or aPath == "hit" then
				--mid = "_battle"
			end
			for x = 1,#_dTab do
				local d = _dTab[x]
				local aniKey = "DIRECTION:"..x.."_"..aName
				t.animation[#t.animation+1] = aniKey
				local _a = {0.5,0.7}
				if anchor~=nil then
					_a[1],_a[2] = anchor[1],anchor[2]
				end
				local pMode = nil
				local nFrameCount = aCount
				if type(aCount)=="table" then
					pMode = {aCount[1],aCount[2]}
					nFrameCount = math.abs(aCount[2]-aCount[1])
				end
				t[aniKey] = {
					pMode = pMode,
					pName = pDoc..mid.."/"..aPath.."/"..d.row,
					anchor = _a,
					interval = aInterval or 100,
					plist = plPath..mid..".plist",
					image = plPath..mid..".pvr.ccz",
					flipX = d.flipX,
					flipY = d.flipY,
					[1] = {0,0,aW,aH,nFrameCount,aAppendX},
				}
			end
		end
	end
	
	return t
end


function SinglePicModel(name,plPath,picName,_anchor) --从两个不同的资源名文件里加载
	local s,e = string.find(plPath,".plist")
	if s and e then
		plPath = string.sub(plPath,1,s-1)
	end

	local t = {
		name = name,
		loadmode = "plist",
		plist = plPath..".plist",
		image = plPath..".pvr.ccz",
		animation = {
			"stand",
		},
		stand = {
			anchor = _anchor or {0.5,0.5},
			interval = 0,
			[1] = {0,0,0,0,1},
			pMode = 0,
			pName = picName,
		},
	}
	return t
end

--local _animation = {
	--{"stand",5,256,256,120},
	--{"walk",8,256,256,120},
	--{"attack",8,256,256,120},
	--{"skill",8,256,256,120},
--}
--local _animation_II = {
	--{"stand",4,256,256,120},
	--{"walk",8,256,256,120},
	--{"attack",6,256,256,120},
	--{"skill",8,256,256,120},
	--{"hit",1,192,192,350},
--}
--local _animation_III = {
	--{"stand",4,128,128,120},
	--{"walk",8,128,128,120},
	--{"attack",6,128,128,120},
	--{"skill",8,128,128,120},
	--{"hit",1,128,128,350},
--}
--local _animation_IV = {
	--{"stand",4,128,128,120},
	--{"walk",8,128,128,120},
	--{"attack",6,128,128,120},
	--{"skill",8,128,128,120},
	--{"hit",1,128,128,350},
--}
local _animation_V = {
	{"stand",4,160,160,120},
	{"walk",8,160,160,100},
	{"attack",6,160,160,120},
	{"skill",8,160,160,120},
	{"hit",1,160,160,350},
}

--新版小兵(近战)
local _animation_VI = {
	{"stand",8,160,160,120},
	{"walk",8,160,160,100},
	{"attack",6,160,160,120},
	{"hit",1,160,160,350},
}

--新版小兵(远程)
local _animation_VII = {
	{"stand",8,160,160,120},
	{"walk",8,160,160,120},
	{"attack",6,160,160,120},
	{"attack1",6,160,160,120},
	{{"attackX","attack"},{4,6},160,160,120},
	{"hit",1,160,160,350},
}

--水兵
local _animation_VIII = {
	{"stand",8,160,160,120},
	{"walk",8,160,160,120},
	{"attack",8,160,160,120},
	{"hit",1,160,160,350},
}

--鳞甲水兵
local _animation_IX = {
	{"stand",8,160,160,120},
	{"walk",8,160,160,120},
	{"attack",8,160,160,120},
	{"skill",8,160,160,120},
	{"hit",1,160,160,350},
}

local _animation_X = {
	{"stand",4,160,160,120},
	{"walk",8,160,160,120},
	{"attack",8,160,160,120},
	{"skill",8,160,160,120},
	{"hit",1,160,160,350},
}

local _animation_XI = {
	{"stand",12,160,160,100},
	{"walk",8,160,160,120},
	{"attack",8,160,160,120},
	{"skill",8,160,160,120},
	{"hit",1,160,160,350},
}

local _animation_XII = {--80速度的攻击
	{"stand",8,160,160,120},
	{"walk",8,160,160,120},
	{"attack",6,160,160,80},
	{"hit",1,160,160,350},
}

local _animation_XIII = {
	{"stand",4,160,160,120},
	{"walk",8,160,160,120},
	{"attack",7,160,160,120},
	{"skill",7,160,160,120},
	{"hit",1,160,160,350},
}

local _animation_XIV = {
	{"stand",4,160,160,120},
	{"walk",8,160,160,120},
	{"attack",8,160,160,120},
	{"skill",7,160,160,120},
	{"hit",1,160,160,350},
}

local _animation_XV = {
	{"stand",4,160,160,120},
	{"walk",8,160,160,120},
	{"attack",8,160,160,120},
	{"skill",10,160,160,120},
	{"hit",1,160,160,350},
}

local _animation_XVI = {
	{"stand",4,160,160,120},
	{"walk",8,160,160,120},
	{"attack",7,160,160,80},
	{"attack1",7,160,160,80},
	{{"attackX","attack"},{4,7},160,160,80},
	{"hit",1,160,160,350},
}

local _animation_XVII= {
	{"stand",4,160,160,120},
	{"walk",4,160,160,120},
	{"attack",7,160,160,120},
	{"skill",7,160,160,120},
	{"hit",1,160,160,350},
}

local _animation_XVIII= {
	{"stand",4,160,160,120},
	{"walk",4,160,160,120},
	{"attack",7,160,160,120},
	{"skill",4,160,160,120},
	{"hit",1,160,160,350},
}

local _animation_XVIV= {
	{"stand",5,160,160,120},
	{"walk",5,160,160,120},
	{"attack",7,160,160,120},
	{"skill",7,160,160,120},
	{"hit",1,160,160,350},
}

local _animation_XVV= {
	reverse = {land="fly",land_shadow="fly_shadow"},
	{"stand",4,160,160,120},
	{"walk",5,160,160,120,0,{{"walk_shadow",1,0,0}}},
	{"walk_shadow",5,160,160,120},
	{"attack",7,160,160,120},
	{"skill",7,160,160,120,0,{{"skill_shadow",1,0,0}}},
	{"skill1",7,160,160,120,0,{{"skill1_shadow",1,0,0}}},
	{"skill_shadow",7,160,160,120},
	{"skill1_shadow",7,160,160,120},
	{"hit",1,160,160,350},
	{"fly",2,160,160,120,0,{{"fly_shadow",1,0,0}}},
	{"fly_shadow",2,160,160,120},
	{"land",2,160,160,90,0,{{"land_shadow",1,0,0}}},
	{"land_shadow",2,160,160,90},
}

local _animation_XVVI = {
	{"stand",1,40,40,120},
	{{"walk","stand"},1,40,40,120},
}

local _animation_XVVII= {
	{"stand",4,160,160,120},
	{"walk",5,160,160,120},
	{"attack",6,160,160,120},
	{"skill",7,160,160,120},
	{"hit",1,160,160,350},
}

--甘宁特殊
local _animation_XVVIII = {
	{"stand",4,160,160,120},
	{"walk",8,160,160,120},
	{"attack",5,160,160,120},
	{{"attack_slam","attack"},{4,9},160,160,120},
	{{"charge_start","attack"},{4,7},160,160,120},
	{{"charge_end","attack"},{6,9},160,160,120},
	{{"attack_ex","attack"},9,160,160,120},
	{"skill",7,160,160,120},
	{"hit",1,160,160,350},
}

local _animation_XVVIV = {
	{"attack",4,80,92,120},
	{{"stand","attack"},1,80,92,120},
}

--黄月英特殊
local _animation_XVVV = {
	{"stand",4,160,160,120},
	{"walk",8,160,160,120},
	{"attack",7,160,160,120},
	{"skill",7,160,160,120},
	{{"attackX","skill"},{4,7},160,160,120},
	{"hit",1,160,160,350},
}

local _animation_XVVVI = {
	{"stand",8,160,160,120},
	{"walk",8,160,160,120},
	{"attack",7,160,160,120},
	{"skill",7,160,160,120},
	{"hit",1,160,160,350},
}

local _animation_XVVVII = {
	{"stand",8,160,160,120},
	{"walk",4,160,160,120},
	{"attack",7,160,160,120},
	{"skill",7,160,160,120},
	{"hit",1,160,160,350},
}

local _animation_XVVVIII = {
	{"attack",6,200,200,120},
	{{"walk","attack"},1,200,200,120},
	{{"stand","attack"},1,200,200,120},
}

local _animation_XVVVIII_I = {
	{"attack",5,100,100,120},
	{{"walk","attack"},1,100,100,120},
	{{"stand","attack"},1,100,100,120},
}

--新版坦克(近战)
local _animation_XVVVIIII = {
	{"stand",1,160,160,120},
	{"walk",9,160,160,100},
	{"attack",1,160,160,120},
	-- {"hit",1,160,160,350},
}

--导弹塔2
local _animation_ddta = {
	{"attack",43,200,200,120},
	{"walk",1,200,200,120},
	{"stand",1,200,200,120},
}

local _animation_32 = {
	{"stand",1,256,256,120},
	{"walk",5,256,256,100},
	{"attack",5,256,256,120},
}

local _animation_32_4 = {
	{"stand",4,256,256,120},
	{"walk",4,256,256,100},
	{"attack",1,256,256,120},
}

local _animation_32_spaceship = {
	{"stand",9,410,410,400},
	{"attack",9,410,410,400},
}

local _animation_32_game = {
	{"stand",30,256,256,100},
	{"attack",30,256,256,100},
}

local _animation_32_dragon_stand = {
	{"stand",13,512,512,100},
	{"attack",13,512,512,100},
}

_tab_model[523] = HeroModelDx8PL_2PIC("MODEL:HERO_liubei_qima","unit/liubei.plist","liubei",_animation_V,{0.5,0.7})
_tab_model[524] = HeroModelDx8PL_2PIC("MODEL:HERO_guanyu_qima","unit/guanyu.plist","guanyu",_animation_V,{0.5,0.7})
_tab_model[525] = HeroModelDx8PL_2PIC("MODEL:HERO_zhangfei_qima","unit/zhangfei.plist","zhangfei",_animation_V,{0.5,0.7})
_tab_model[526] = HeroModelDx8PL_2PIC("MODEL:HERO_zhaoyun_qima","unit/zhaoyun.plist","zhaoyun",_animation_V,{0.5,0.7})
_tab_model[527] = HeroModelDx8PL_2PIC("MODEL:HERO_caocao_qima","unit/caocao.plist","caocao",_animation_V,{0.5,0.7})
_tab_model[528] = HeroModelDx8PL_2PIC("MODEL:HERO_dianwei","unit/dianwei.plist","dianwei",_animation_V,{0.5,0.7})
_tab_model[529] = HeroModelDx8PL_2PIC("MODEL:HERO_guojia","unit/guojia.plist","guojia",_animation_X,{0.5,0.7})
_tab_model[530] = HeroModelDx8PL_2PIC("MODEL:HERO_zhangliao_qima","unit/zhangliao.plist","zhangliao",_animation_V,{0.5,0.7})
_tab_model[531] = HeroModelDx8PL_2PIC("MODEL:HERO_sunjian_qima","unit/hero/wu/sunjian.plist","sunjian",_animation_V,{0.5,0.7})
_tab_model[532] = HeroModelDx8PL_2PIC("MODEL:HERO_lvbu_qima","unit/hero/qun/lvbu.plist","lvbu",_animation_V,{0.5,0.7})
_tab_model[533] = HeroModelDx8PL_2PIC("MODEL:HERO_dongzhuo","unit/hero/qun/dongzhuo.plist","dongzhuo",_animation_V,{0.5,0.7})
_tab_model[534] = HeroModelDx8PL_2PIC("MODEL:HERO_yuanshao_qima","unit/hero/qun/yuanshao.plist","yuanshao",_animation_V,{0.5,0.7})


_tab_model[535] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_FootMan","unit/units.plist","footman","unit/footman.plist","footman",_animation_VI,{0.5,0.7})----
_tab_model[536] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Archer","unit/units.plist","archer","unit/archer.plist","archer",_animation_VII,{0.5,0.7})----


_tab_model[537] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_catapult","unit/units.plist","catapult","unit/catapult.plist","catapult",_animation_VI,{0.5,0.7})----
_tab_model[538] = HeroModelDx8PL_2PIC("MODEL:HERO_diaochan","unit/hero/qun/diaochan.plist","diaochan",_animation_V,{0.5,0.7})
_tab_model[539] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Rider","unit/units.plist","elite_rider","unit/elite_rider.plist","elite_rider",_animation_VI,{0.5,0.7})----
_tab_model[540] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Elite_Footman","unit/units.plist","elite_footman","unit/elite_footman.plist","elite_footman",_animation_VI,{0.5,0.7})--
_tab_model[541] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Elite_Archer","unit/units.plist","elite_archer","unit/elite_archer.plist","elite_archer",_animation_VII,{0.5,0.7})--
_tab_model[543] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Wizard","unit/units.plist","wizard","unit/wizard.plist","wizard",_animation_VI,{0.5,0.7})
_tab_model[544] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Lancer","unit/units.plist","lancer","unit/lancer.plist","lancer",_animation_VI,{0.5,0.7})
_tab_model[545] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Cavalry_Commander","unit/units.plist","cavalry_commander","unit/cavalry_commander.plist","cavalry_commander",_animation_VI,{0.5,0.7})
_tab_model[546] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Peasant","unit/units.plist","peasant","unit/peasant.plist","peasant",_animation_VI,{0.5,0.7})--
_tab_model[548] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Cateran","unit/units.plist","cateran","unit/cateran.plist","cateran",_animation_VI,{0.5,0.7})--
_tab_model[549] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_HuangJinArmy","unit/units.plist","huangjinarmy","unit/huangjinarmy.plist","huangjinarmy",_animation_VI,{0.5,0.7})--
_tab_model[550] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Wolf","unit/units.plist","wolf","unit/wolf.plist","wolf",_animation_VI,{0.5,0.7})--
_tab_model[551] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Ballista","unit/units.plist","ballista","unit/ballista.plist","ballista",_animation_VI,{0.5,0.7})--
_tab_model[552] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_GreyWolf","unit/units.plist","greywolf","unit/greywolf.plist","greywolf",_animation_VI,{0.5,0.7})--
_tab_model[553] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Giant","unit/units.plist","giant","unit/giant.plist","giant",_animation_VI,{0.5,0.7})--
_tab_model[554] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Elephant","unit/units.plist","elephant","unit/elephant.plist","elephant",_animation_VI,{0.5,0.7})--
_tab_model[555] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Phoenix","unit/units.plist","phoenix","unit/phoenix.plist","phoenix",_animation_VI,{0.5,0.7})--
_tab_model[556] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Fly_Archer","unit/units.plist","fly_archer","unit/fly_archer.plist","fly_archer",_animation_VII,{0.5,0.7})--
_tab_model[557] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Tortoise","unit/units.plist","tortoise","unit/tortoise.plist","tortoise",_animation_VI,{0.5,0.7})--
_tab_model[558] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Steal","unit/units.plist","steal","unit/steal.plist","steal",_animation_VI,{0.5,0.7})--
_tab_model[559] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Zhangjiao","unit/units.plist","zhangjiao","unit/zhangjiao.plist","zhangjiao",_animation_VI,{0.5,0.7})--
_tab_model[560] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_ShuiBing","unit/units.plist","shuibing","unit/shuibing.plist","shuibing",_animation_IX,{0.5,0.7})--
_tab_model[561] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_LinJiaShuiBing","unit/units.plist","linjiashuibing","unit/linjiashuibing.plist","linjiashuibing",_animation_IX,{0.5,0.7})--
_tab_model[562] = HeroModelDx8PL_2PIC("MODEL:HERO_xiahoudun","unit/xiahoudun.plist","xiahoudun",_animation_X,{0.5,0.7})
_tab_model[563] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_HuangLong","unit/units2.plist","huanglong","unit/huanglong.plist","huanglong",_animation_XI,{0.5,0.6})--
_tab_model[564] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_QingLong","unit/units2.plist","qinglong","unit/qinglong.plist","qinglong",_animation_XI,{0.5,0.6})--
_tab_model[565] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_FuZhou","unit/units.plist","fuzhou","unit/fuzhou.plist","fuzhou",_animation_X,{0.5,0.7})--
_tab_model[566] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_SanXian","unit/units.plist","sanxian","unit/sanxian.plist","sanxian",_animation_X,{0.5,0.7})--
_tab_model[567] = HeroModelDx8PL_2PIC("MODEL:HERO_taishici_qima","unit/hero/wu/taishici.plist","taishici",_animation_V,{0.5,0.7})
_tab_model[568] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Sishi","unit/units.plist","sishi","unit/sishi.plist","sishi",_animation_XII,{0.5,0.7})--
_tab_model[569] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Xiandengsishi","unit/units.plist","xiandengsishi","unit/xiandengsishi.plist","xiandengsishi",_animation_XII,{0.5,0.7})--
_tab_model[570] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_HuBao","unit/units.plist","hubaoqi","unit/hubaoqi.plist","hubaoqi",_animation_VIII,{0.5,0.6})--
_tab_model[571] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_HuLang","unit/units.plist","hulangqi","unit/hulangqi.plist","hulangqi",_animation_VIII,{0.5,0.6})--
_tab_model[572] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_BaiEr","unit/units.plist","jinwei","unit/baier.plist","baier",_animation_VI,{0.5,0.7})--
_tab_model[573] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_JinWei","unit/units.plist","baier","unit.plist","jinwei",_animation_VI,{0.5,0.7})--
_tab_model[574] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_YaoShu","unit/units.plist","yaoshu","unit/yaoshu.plist","yaoshu",_animation_VI,{0.5,0.7})
_tab_model[575] = HeroModelDx8PL_2PIC("MODEL:HERO_jiaxu","unit/jiaxu.plist","jiaxu",_animation_XIII,{0.5,0.7})
_tab_model[576] = HeroModelDx8PL_2PIC("MODEL:HERO_xuchu","unit/xuchu.plist","xuchu",_animation_X,{0.5,0.7})
_tab_model[577] = HeroModelDx8PL_2PIC("MODEL:HERO_zhanghe","unit/zhanghe.plist","zhanghe",_animation_XIV,{0.5,0.7})
_tab_model[578] = HeroModelDx8PL_2PIC("MODEL:HERO_xunyu","unit/xunyu.plist","xunyu",_animation_XIII,{0.5,0.7})
_tab_model[579] = HeroModelDx8PL_2PIC("MODEL:HERO_sunce","unit/hero/wu/sunce.plist","sunce",_animation_XIII,{0.5,0.7})
_tab_model[580] = HeroModelDx8PL_2PIC("MODEL:HERO_xiaoqiao","unit/hero/wu/xiaoqiao.plist","xiaoqiao",_animation_XIII,{0.5,0.7})
_tab_model[581] = HeroModelDx8PL_2PIC("MODEL:HERO_zhouyu","unit/hero/wu/zhouyu.plist","zhouyu",_animation_XV,{0.5,0.7})
_tab_model[582] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Eg_Archer","unit/units.plist","eg_archer","unit/eg_archer.plist","eg_archer",_animation_XVI,{0.5,0.7})
_tab_model[583] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_HuoDou","unit/units3.plist","huodou","unit/huodou.plist","huodou",_animation_XVII,{0.5,0.65})
_tab_model[584] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_DiJiang","unit/units3.plist","dijiang","unit/dijiang.plist","dijiang",_animation_XVIII,{0.5,0.65})
_tab_model[585] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_NvWoHouRen","unit/units3.plist","nvwohouren","unit/nvwohouren.plist","nvwohouren",_animation_XVII,{0.5,0.65})
_tab_model[586] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_XianRen","unit/units3.plist","xianren","unit/xianren.plist","xianren",_animation_XVIV,{0.5,0.65})
_tab_model[587] = UnitModelDx2PL_2PIC_2PAT_FLY("MODEL:UNIT_FengBo","unit/units3.plist","fengbo","unit/fengbo.plist","fengbo",_animation_XVV,{0.5,0.65})
_tab_model[588] = UnitModelDx8PL_noplist("MODEL:8Dir2","misc/arrow_ext.png",40,40,{1,2,3,4,5,6,7,8},_animation_XVVI,{0.5,0.5})
_tab_model[589] = UnitModelDx8PL_noplist("MODEL:8Dir1","misc/arrow.png",40,40,{1,3,5,7,9,11,13,15},_animation_XVVI,{0.5,0.5})
_tab_model[590] = HeroModelDx8PL_2PIC("MODEL:HERO_huangyueying","unit/huangyueying.plist","huangyueying",_animation_XVVV,{0.5,0.7})
_tab_model[591] = HeroModelDx8PL_2PIC("MODEL:HERO_zhugeliang","unit/zhugeliang.plist","zhugeliang",_animation_XVII,{0.5,0.7})
_tab_model[592] = HeroModelDx8PL_2PIC("MODEL:HERO_xushu","unit/xushu.plist","xushu",_animation_XIII,{0.5,0.7})
_tab_model[593] = HeroModelDx8PL_2PIC("MODEL:BOAT","unit/boat.plist","boat",_animation_XVVI,{0.5,0.53})
_tab_model[594] = HeroModelDx8PL_2PIC("MODEL:BOAT2","unit/boat2.plist","boat2",_animation_XVVI,{0.5,0.53})
_tab_model[595] = HeroModelDx8PL_2PIC("MODEL:HERO_ganning","unit/hero/wu/ganning.plist","ganning",_animation_XVVIII,{0.5,0.7})

----------船怪------------
_tab_model[596] = SinglePicModel("MODEL:BattleShip_energy_bottom","unit/battle_ship.plist","unit/bb_energy_b",{0.5,0.5})
_tab_model[597] = SinglePicModel("MODEL:BattleShip_body","unit/battle_ship.plist","unit/bb_body",{0.5,0.5})
_tab_model[598] = SinglePicModel("MODEL:BattleShip_energy_mid","unit/battle_ship.plist","unit/bb_energy_m",{0.5,0.5})
_tab_model[599] = SinglePicModel("MODEL:BattleShip_energy_top","unit/battle_ship.plist","unit/bb_energy_t",{0.5,0.5})
_tab_model[600] = SinglePicModel("MODEL:BattleShip_mid_back","unit/battle_ship.plist","unit/bb_mid_back",{0.5,0.5})
_tab_model[601] = SinglePicModel("MODEL:BattleShip_can","unit/battle_ship.plist","unit/bb_can",{0.5,0.5})
_tab_model[602] = SinglePicModel("MODEL:BattleShip_can3mask","unit/battle_ship.plist","unit/bb_can3mask",{0.5,0.5})
_tab_model[603] = SinglePicModel("MODEL:BattleShip_can4mask","unit/battle_ship.plist","unit/bb_can4mask",{0.5,0.5})
_tab_model[604] = SinglePicModel("MODEL:BattleShip_arrow_bottom","unit/battle_ship.plist","unit/bb_arrow_b",{0.5,0.5})
_tab_model[605] = SinglePicModel("MODEL:BattleShip_arrow","unit/battle_ship.plist","unit/bb_arrow",{0.5,0.5})
_tab_model[606] = SinglePicModel("MODEL:BattleShip_arrow_circle","unit/battle_ship.plist","unit/bb_arrow_c",{0.5,0.5})
_tab_model[607] = SinglePicModel("MODEL:BattleShip_arrow_handel","unit/battle_ship.plist","unit/bb_arrow_h",{0.5,0.5})
_tab_model[608] = SinglePicModel("MODEL:BattleShip_arrow_hand_bottom","unit/battle_ship.plist","unit/bb_mouth1",{0.5,0.5})
----------船怪------------

_tab_model[609] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_MuNiu","unit/units2.plist","muniu","unit/muniu.plist","muniu",_animation_XVVII,{0.5,0.7})--
_tab_model[610] = UnitModelDx2PL_2PIC_2PAT("MODEL:pao","unit/units3.plist","pao","unit/pao.plist","pao",_animation_XVVIV,{0.5,0.7})
_tab_model[611] = HeroModelDx8PL_2PIC("MODEL:HERO_pangtong","unit/pangtong.plist","pangtong",_animation_XIII,{0.5,0.7})
_tab_model[612] = HeroModelDx8PL_2PIC("MODEL:HERO_sunquan","unit/hero/wu/sunquan.plist","sunquan",_animation_XVVVI,{0.5,0.7})

---------山怪------------
_tab_model[613] = SinglePicModel("MODEL:MM_spt","unit/mountain_monster.plist","unit/mon_spt",{0.5,0.5})
_tab_model[614] = SinglePicModel("MODEL:MM_spt_r","unit/mountain_monster.plist","unit/mon_spt_r",{0.5,0.5})
_tab_model[615] = SinglePicModel("MODEL:MM_mom","unit/mountain_monster.plist","unit/mon_mon",{0.5,0.5})
_tab_model[616] = SinglePicModel("MODEL:MM_wall_1","unit/mountain_monster.plist","unit/mon_wall_1",{0.5,0.5})
_tab_model[617] = SinglePicModel("MODEL:MM_wall_2","unit/mountain_monster.plist","unit/mon_wall_2",{0.5,0.5})
_tab_model[618] = SinglePicModel("MODEL:MM_spb","unit/mountain_monster.plist","unit/mon_skb",{0.5,0.5})
_tab_model[619] = SinglePicModel("MODEL:MM_stone","unit/mountain_monster.plist","unit/mon_stone",{0.5,0.5})
_tab_model[620] = SinglePicModel("MODEL:MM_floor","unit/mountain_monster.plist","unit/mon_floor",{0.5,1.0})
_tab_model[621] = SinglePicModel("MODEL:MM_lf_1","unit/mountain_monster.plist","unit/mon_lf1",{0.5,0.5})
_tab_model[622] = SinglePicModel("MODEL:MM_lf_2","unit/mountain_monster.plist","unit/mon_lf2",{0.5,0.5})
_tab_model[623] = SinglePicModel("MODEL:MM_stone1","unit/mountain_monster.plist","unit/mon_stone1",{0.5,0.5})
_tab_model[624] = SinglePicModel("MODEL:MM_stone2","unit/mountain_monster.plist","unit/mon_stone2",{0.5,0.5})
_tab_model[625] = SinglePicModel("MODEL:MM_stone3","unit/mountain_monster.plist","unit/mon_stone3",{0.5,0.5})
_tab_model[626] = SinglePicModel("MODEL:MM_world_model","../xlobj/xlobjs.plist","data/xlobj/gres_bandit02",{0.5,0.8})
---------山怪------------

_tab_model[627] = SinglePicModel("MODEL:wobj_boat03_mask","../xlobj/xlobjs_sea_battle.plist","data/xlobj/wobj_boat03_mask",{0.5,0.8})
_tab_model[628] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Boom","unit/units2.plist","boom","unit/boom.plist","boom",_animation_XVVVII,{0.5,0.7})
_tab_model[629] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Boomex","unit/units2.plist","boomex","unit/boomex.plist","boomex",_animation_XVVVII,{0.5,0.7})

_tab_model[630] = SinglePicModel("MODEL:BattleShip_energy_des","unit/battle_ship.plist","unit/bb_energy_des",{0.5,0.5})
_tab_model[631] = SinglePicModel("MODEL:BattleShip_arrow_des","unit/battle_ship.plist","unit/bb_arrow_des",{0.5,0.5})
_tab_model[632] = SinglePicModel("MODEL:zhangpeng","../xlobj/xlobjs.plist","data/xlobj/visit_medic",{0.5,0.8})
_tab_model[633] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Phoenix","unit/units.plist","phoenix","unit/phoenix.plist","phoenix",_animation_VI,{0.5,0.7})--

_tab_model[634] = HeroModelDx16PL_1PIC("MODEL:HERO_td_jianta","unit/hero/qun/tdjianta.plist","tdjianta",_animation_XVVVIII,{0.5,0.7}) --基础箭塔
_tab_model[635] = HeroModelDx16PL_1PIC("MODEL:HERO_td_liannuta","unit/hero/qun/tdjianta1.plist","tdjianta1",_animation_XVVVIII,{0.5,0.7}) --连弩塔
_tab_model[636] = HeroModelDx16PL_1PIC("MODEL:HERO_td_duta","unit/hero/qun/tdjianta2.plist","tdjianta2",_animation_XVVVIII,{0.5,0.7}) --毒塔
_tab_model[637] = HeroModelDx16PL_1PIC("MODEL:HERO_td_jujita","unit/hero/qun/tdjianta3.plist","tdjianta3", _animation_XVVVIII,{0.5,0.7}) --狙击塔
_tab_model[638] = HeroModelDx16PL_1PIC("MODEL:HERO_td_paota","unit/hero/qun/tdpaota.plist","tdpaota", _animation_XVVVIII,{0.5,0.7}) --炮塔
_tab_model[639] = HeroModelDx16PL_1PIC("MODEL:HERO_td_gunshita","unit/hero/qun/tdpaota1.plist","tdpaota1", _animation_XVVVIII,{0.5,0.7}) --炮塔
_tab_model[640] = HeroModelDx16PL_1PIC("MODEL:HERO_td_jupaota","unit/hero/qun/tdpaota2.plist", "tdpaota2", _animation_XVVVIII,{0.5, 0.7}) --巨炮塔


-----------------------------------
---DOTA新动作组
-----------------------------------



---英雄动作
local _animation_Normal = {
	{"stand",4,160,160,120},
	{"walk",8,160,160,120},
	{"attack",7,160,160,120},
	{"skill",7,160,160,120},
	{{"skill_qs_long","skill"},{5,6},160,160,500},
	{"hit",1,160,160,350},
}

local _animation_Shoot_A = {
	{"stand",4,160,160,120},
	{"walk",8,160,160,120},
	{"attack",7,160,160,120},
	{{"attackX","attack"},{4,7},160,160,120}, ---4-7代表用的是attack的第4-7帧
	{"skill",7,160,160,120},
	{"hit",1,160,160,350},
}

local _animation_Shoot_B = {
	{"stand",4,160,160,120},
	{"walk",8,160,160,120},
	{"attack",7,160,160,120},
	{{"attackX","attack"},{4,7},160,160,120},---4-7代表用的是attack的第4-7帧
	{"skill",7,160,160,120},
	{{"skillX","skill"},{6,7},160,160,120},---6-7代表用的是skill的第6-7帧
	{"hit",1,160,160,350},
}

---鸟人
local _animation_niaoren = {
	{"stand",4,160,160,150},
	{"walk",8,160,160,120},
	{"attack",7,160,160,120},
	{"skill",7,160,160,120},
	{{"skill_qs_long","skill"},{5,6},160,160,500},
	{"hit",1,160,160,350},
}



---小兵动作1(站立快)

local _animation_Bing_01 = {
	{"stand",4,160,160,120},
	{"walk",8,160,160,120},
	{"attack",6,160,160,120},
	{"hit",1,160,160,350},
}


---小兵动作2(站立慢)
local _animation_Bing_02 = {
	{"stand",4,160,160,130},
	{"walk",8,160,160,120},
	{"attack",6,160,160,120},
	{"hit",1,160,160,350},
}

---士兵动作
local _animation_Soldier = {
	{"stand",8,160,160,120},
	{"walk",9,160,160,120},
	{"attack",15,160,160,120},
	{"hit",7,160,160,120},
}

---士官长动作
local _animation_Soldier2 = {
	{"stand",9,300,300,120},
	{"walk",11,300,300,120},
	{"attack",9,300,300,120},
	{"skill",8,300,300,120},
	{"hit",16,300,300,120},
}

---机枪士官长动作
local _animation_Soldier3 = {
	{"stand",8,300,300,120},
	{"walk",10,300,300,120},
	{"attack",9,300,300,120},
	{"skill",9,300,300,120},
}

--科学家动作
local _animation_Scientist = {
	{"stand",10,160,160,120},
	{"walk",10,160,160,120},
	{"attack",15,160,160,120},
}

--伊娃动作
local _animation_eve = {
	{"stand",6,256,256,120},
	{"walk",6,256,256,120},
	{"attack",10,256,256,120},
	{"skill",10,256,256,120},
}

--球形机器人
local _animation_ball_robot = {
	{"stand",5,256,256,120},
	{"walk",6,256,256,120},
	{"attack",5,256,256,120},
	--{{"attack1","attack"},{1,12},600,600,120},
	--{{"attack2","attack"},{6,17},600,600,120},
	{"skill",5,256,256,60},
}

--菱形机器人
local _animation_ramiel = {
	{"stand",6,256,256,120},
	{"walk",6,256,256,120},
	{"attack",8,256,256,80},
	{"skill",8,256,256,80},
	--{"dead",10,256,256,120},
}

--异虫
local _animation_zerg = {
	{"stand",10,300,300,120},
	{"walk",10,300,300,140},
	{"attack",10,300,300,140},
	{"skill",1,300,300,200},
	{"dead",10,300,300,250}, --geyachao: 查bug临时去掉，待恢复
}

--异虫2
local _animation_zerg2 = {
	{"stand",10,300,300,120},
	{"walk",10,300,300,140},
	{"attack",10,300,300,140},
	{"skill",1,300,300,200},
	--{"dead",10,300,300,250},
}

--超级太空舰队
local _animation_superairship = {
	{"stand",1,400,320,120},
	{"walk",1,400,320,140},
	{"attack",1,400,320,140},
	{"skill",1,400,320,200},
	--{"dead",2,400,320,1200},
}

--高射塔
local _animation_GAOSHETA = {
	{"stand",15,175,350,100},
	{"attack",15,175,350,90},
}

--高射塔生长动画
local _animation_GAOSHETA_GROW = {
	{"stand",1,175,175,110},
	{"walk",21,175,175,110},
}

--激光塔
local _animation_JIGUANGTA = {
	{"stand",15,300,300,100},
	{"walk",15,300,300,100},
	{"attack",15,300,300,90},
}

--激光塔生长动画
local _animation_JIGUANGTA_GROW = {
	{"stand",1,300,300,110},
	{"walk",21,300,300,110},
}

--机枪塔生长动画
local _animation_JIQIANGTA_GROW = {
	{"stand",1,175,175,110},
	{"walk",22,175,175,110},
}

--炮台塔
local _animation_PAOTAITA = {
	{"stand",15,175,175,100},
	{"attack",15,175,175,90},
}

--炮台塔生长动画
local _animation_PAOTAITA_GROW = {
	{"stand",1,175,175,110},
	{"walk",21,175,175,110},
}

--射击塔
local _animation_SHEJITA = {
	{"stand",15,175,175,100},
	{"attack",15,175,175,90},
}

--射击塔生长动画
local _animation_SHEJITA_GROW = {
	{"stand",1,175,175,110},
	{"walk",23,175,175,110},
}

--空中堡垒
local _animation_sky_fortress = {
	{"stand",7,600,600,120},
	{"walk",7,600,600,120},
	{"attack",17,600,600,120},
	{{"attack1","attack"},{1,12},600,600,120},
	{{"attack2","attack"},{6,17},600,600,120},
	{"skill",5,600,600,120},
	{"dead",8,600,600,250}, --geyachao: 查bug临时去掉，待恢复
}

--飞碟
local _animation_plate = {
	{"stand",1,320,320,120},
	{"walk",1,320,320,140},
	{"attack",1,320,320,140},
	{"skill",1,320,320,200},
	--{"dead",2,320,320,1200},
}

--眼睛
local _animation_gazer = {
	{"stand",6,100,100,120},
	{"walk",6,100,100,140},
	{"attack",6,100,100,140},
	{"skill",6,100,100,200},
	--{"dead",6,100,100,300}, --todo: 临时注释掉，检查是否是crash的原因
}

--钢铁气球BOSS
local _animation_metal_balloon = {
	{"stand",16,100,100,120},
	{"walk",16,100,100,120},
	{"attack",16,100,100,120},
	{"dead",10,100,100,120}, --geyachao: 查bug临时去掉，待恢复
}

--钢铁气球
local _animation_metal_balloon2 = {
	{"stand",16,100,100,120},
	{"walk",16,100,100,120},
	{"attack",16,100,100,120},
	--{"dead",10,100,100,120},
}

local _animation_yoda = {
	{"stand",7,300,300,120},
	{"walk",8,300,300,120},
	{"attack",9,300,300,120},
	{"skill",9,300,300,120},
	--{"dead",6,300,300,120},
}

local _animation_tie = {
	{"stand",5,300,300,120},
	{"walk",5,300,300,120},
	{"attack",4,300,300,120},
	{"skill",4,300,300,120},
	--{"dead",8,300,300,120},
}

--飞船怪物
local _animation_monster = {
	{"stand",6,512,512,120},
	{"walk",6,512,512,120},
	{"attack",8,512,512,120},
	{"skill",7,512,512,120},
	{"dead",8,512,512,250}, --geyachao: 查bug临时去掉，待恢复
}

--机械兽
local _animation_metal_beast = {
	{"stand",5,400,400,120},
	{"walk",8,400,400,120},
	{"attack",7,400,400,120},
	{"dead",6,400,400,250}, --geyachao: 查bug临时去掉，待恢复
}

--超级机器人
local _animation_super_robot = {
	{"stand",6,300,300,120},
	{"walk",8,300,300,120},
	{"attack",8,300,300,150},
	{"skill",8,300,300,120},
	{"hit",9,300,300,120},
}

--机甲少女
local _animation_fag = {
	{"stand",6,256,256,120},
	{"walk",7,256,256,120},
	{"attack",9,256,256,60},
	{"skill",21,256,256,50},
	--{"roll",23,256,256,120},
	--{"dash",7,256,256,120},
	--{"dead",9,256,256,120},
}

--量产机
local _animation_mpe = {
	{"stand",8,300,500,120},
	{"walk",8,300,500,120},
	{"attack",8,300,500,120},
	{"attack2",8,300,500,120},
	{"skill",8,300,500,120},
	{"rise",6,300,500,120},
	{"down",4,300,500,120},
	{"fly",8,300,500,120},
}

--异形女王
local _animation_alien_q = {
	{"stand",8,300,300,120},
	{"walk",8,300,300,120},
	{"attack",8,300,300,120},
	{"skill1",8,300,300,120},
	{"skill2",8,300,300,120},
	{"dead",11,300,300,120}, --geyachao: 查bug临时去掉，待恢复
}

--虫卵
local _animation_egg = {
	{"stand",13,300,300,120},
	{"walk",13,300,300,120},
	{"attack",13,300,300,120},
	--{"dead",13,300,300,120},
}

--兵工厂
local _animation_BINGGONGCHANG = {
	{"stand",12,512,512,200},
	{"walk",12,512,512,200},
	{"attack",21,512,512,100},
}

--黑龙
local _animation_blackdragon = {
	--{"stand",5,410,410,120},
	{{"stand2","stand"},{1,5},410,410,400},
	{{"stand","stand"},{17,31},410,410,120},
	{{"wakeup","stand"},{32,40},410,410,120},
	{{"lie","stand"},{6,16},410,410,120},
}

local _animation_taizi = {
	{{"stand","stand"},{3,3},118,138,120},
	{{"stand2","stand"},{1,2},118,138,120},
	{{"up","stand"},{3,6},118,138,120},
	{{"down","stand"},{6,9},118,138,120},
}

local _animation_train = {
	{"stand",1,256,256,120},
	{"walk",1,256,256,120},
}

local _animation_ironman = {
	{"stand",5,192,192,120},
	{{"stand2","stand"},{1,1},192,192,120},
	{"walk",5,192,192,120},
}

local _animation_nest = {
	{"stand",11,358,358,240},
	{"walk",11,358,358,240},
}

local _animation_techcenter = {
	{"stand",2,300,300,1000},
	{"walk",2,300,300,1000},
}

--2方向(蜘蛛坦克)
local _animation_jeep_spider = {
	{"stand",1,256,256,120},
	{"walk",12,256,256,120},
}

--机械臂
local _animation_arm = {
	{{"stand","stand"},{1,1},300,300,120},
	{{"stand2","stand"},{15,15},300,300,120},
	{{"up","stand"},{1,15},300,300,120},
	{{"down","stand"},{15,29},300,300,120},
}


_tab_model[582] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Eg_Archer","unit/units.plist","eg_archer","unit/eg_archer.plist","eg_archer",_animation_XVI,{0.5,0.7})
_tab_model[641] = HeroModelDx16PL_2PIC("MODEL:UNIT_TANK","unit/tank.plist","tank",_animation_XVVIII,{0.5,0.7}) --tank_test:测试用: 坦克模型
_tab_model[642] = HeroModelDx16PL_2PIC("MODEL:UNIT_TANK_WEAPON","unit/tankweapon.plist","tankweapon",_animation_XVVIII,{0.5,0.7}) --tank_test:测试用: 坦克炮口模型

--32方向(无技能动作)
local _animation_32_ex = function(s, w, a, d)
	return
	{
		{"stand",s,256,256,120},
		{"walk",w,256,256,100},
		{"attack",a,256,256,120},
		{"dead",d,256,256,60}, --geyachao: 查bug临时去掉，待恢复
	}
end

--[[
--32方向(有技能动作)
local _animation_32_skill_ex = function(s, w, a, d, skill)
	return
	{
		{"stand",s,256,256,120},
		{"walk",w,256,256,100},
		{"attack",a,256,256,120},
		{"dead",d,256,256,100},
		{"skill",skill,256,256,60},
	}
end
]]

--32方向(有技能动作，动作快,无死亡)
local _animation_32_quickskill_ex = function(s, w, a, skill)
	return
	{
		{"stand",s,256,256,120},
		{"walk",w,256,256,100},
		{"attack",a,256,256,120},
		{"skill",skill,256,256,35},
	}
end

--32方向大图(有技能动作)
local _animation_32_skill_ex_big = function(s, w, a, d, skill)
	return
	{
		{"stand",s,400,400,120},
		{"walk",w,400,400,100},
		{"attack",a,400,400,50},
		{"dead",d,400,400,250}, --geyachao: 查bug临时去掉，待恢复
		{"skill",skill,400,400,120},
	}
end

--32方向中图(有技能动作)
local _animation_32_skill_ex_mid = function(s, w, a, d, skill)
	return
	{
		{"stand",s,300,300,120},
		{"walk",w,300,300,120},
		{"attack",a,300,300,120},
		{"dead",d,300,300,120}, --geyachao: 查bug临时去掉，待恢复
		{"skill",skill,300,300,120},
	}
end
--32方向中图(有技能动作,无死亡)
local _animation_32_skill_ex_mid_nd = function(s, w, a, skill)
	return
	{
		{"stand",s,300,300,120},
		{"walk",w,300,300,120},
		{"attack",a,300,300,120},
		{"skill",skill,300,300,120},
	}
end

--[[
--32方向(无技能动作,慢死亡)
local _animation_32_ex_sd = function(s, w, a, d)
	return
	{
		{"stand",s,256,256,120},
		{"walk",w,256,256,100},
		{"attack",a,256,256,120},
		{"dead",d,256,256,100},
	}
end
]]

--32方向(无技能动作,慢死亡,300尺寸)
local _animation_32_ex_sd2 = function(s, w, a, d)
	return
	{
		{"stand",s,300,300,120},
		{"walk",w,300,300,100},
		{"attack",a,300,300,120},
		{"dead",d,300,300,250}, --geyachao: 查bug临时去掉，待恢复
	}
end

--32方向(有技能动作,无死亡)
local _animation_32_skill_nd = function(s, w, a, skill)
	return
	{
		{"stand",s,256,256,120},
		{"walk",w,256,256,120},
		{"attack",a,256,256,120},
		{"skill",skill,256,256,120},
	}
end

--32方向(有技能动作,无死亡2)
local _animation_32_skill_nd2 = function(s, w, a, skill)
	return
	{
		{"stand",s,256,256,120},
		{"walk",w,256,256,120},
		{"attack",a,256,256,120},
		{"skill",skill,256,256,60},
	}
end

--32方向(无技能动作,无死亡)
local _animation_32_ex_nd = function(s, w, a)
	return
	{
		{"stand",s,256,256,120},
		{"walk",w,256,256,100},
		{"attack",a,256,256,120},
	}
end

local HMDx32P2PIC = HeroModelDx32PL_2PIC
_tab_model[643] = HMDx32P2PIC("MODEL:UNIT_JEEP","unit/jeep.plist","jeep",_animation_32_ex(1,1,1,10),{0.5,0.45}) --tank: 装甲车身体（绿色）
_tab_model[644] = HMDx32P2PIC("MODEL:UNIT_JEEP_GUN","unit/jeepgun.plist","jeepgun",_animation_32,{0.5,0.45}) --tank: 装甲车机关枪
_tab_model[645] = HMDx32P2PIC("MODEL:UNIT_JEEP_FIRE","unit/jeepgun1.plist","jeepgun1",_animation_32,{0.5,0.45}) --tank: 装甲车火焰枪
_tab_model[646] = HMDx32P2PIC("MODEL:UNIT_JEEP_GATLIN","unit/jeepgun2.plist","jeepgun2",_animation_32,{0.5,0.45}) --tank: 装甲车加特林散弹枪
_tab_model[647] = HMDx32P2PIC("MODEL:UNIT_JEEP_LASER","unit/jeepgun3.plist","jeepgun3",_animation_32,{0.5,0.45}) --tank: 装甲车激光枪
_tab_model[648] = HMDx32P2PIC("MODEL:UNIT_JEEP_GUN_SHORT","unit/jeepgun4.plist","jeepgun4",_animation_32,{0.5,0.45}) --tank: 装甲车机关枪（短）
_tab_model[649] = HMDx32P2PIC("MODEL:UNIT_JEEP_ENERGYGUN","unit/jeepgun5.plist","jeepgun5",_animation_32,{0.5,0.45}) --tank: 装甲车能量炮
--_tab_model[650] = HMDx32P2PIC("MODEL:UNIT_JEEP_SHANDIAN","unit/jeepgun6.plist","jeepgun6",_animation_32,{0.5,0.45}) --tank: 装甲车闪电链
_tab_model[651] = HMDx32P2PIC("MODEL:UNIT_JEEP_GAOSI","unit/jeepgun9.plist","jeepgun9",_animation_32,{0.5,0.45}) --tank: 装甲车穿透枪
_tab_model[652] = HMDx32P2PIC("MODEL:UNIT_JEEP_CHASER","unit/jeepgun8.plist","jeepgun8",_animation_32,{0.5,0.45})
_tab_model[653] = HMDx32P2PIC("MODEL:UNIT_JEEP_LAMP","unit/jeeplamp.plist","jeeplamp",_animation_32,{0.5,0.45}) --tank: 装甲车大灯
_tab_model[654] = HMDx32P2PIC("MODEL:UNIT_JEEP_LIGHT","unit/jeeplamplight.plist","jeeplamplight",_animation_32,{0.5,0.45}) --tank: 装甲车光照
_tab_model[655] = HMDx32P2PIC("MODEL:UNIT_JEEP_WHITE","unit/jeep1.plist","jeep1",_animation_32,{0.5,0.45}) --tank: 装甲车（白色）
_tab_model[656] = HMDx32P2PIC("MODEL:UNIT_JEEP_WHEEL","unit/jeepwheel.plist","jeepwheel",_animation_32_ex(1,5,1,0),{0.5,0.45}) --tank: 装甲车轮子
_tab_model[657] = HMDx32P2PIC("MODEL:UNIT_JEEP_WHEELLIGHT","unit/jeepwheel1.plist","jeepwheel1",_animation_32_ex(1,5,1,0),{0.5,0.45}) --tank: 装甲车轮子发亮
_tab_model[658] = HMDx32P2PIC("MODEL:UNIT_JEEP_SHADOW","unit/jeepshadow.plist","jeepshadow",_animation_32,{0.5,0.45}) --tank: 装甲车影子
_tab_model[659] = HMDx32P2PIC("MODEL:UNIT_JEEP_ENERGY","unit/jeepenergy.plist","jeepenergy",_animation_32,{0.5,0.45}) --tank: 装甲车能量圈
_tab_model[660] = HMDx32P2PIC("MODEL:UNIT_PANZER","unit/panzer.plist","panzer",_animation_32,{0.5,0.45}) --tank: 旧版坦克
_tab_model[661] = HMDx32P2PIC("MODEL:UNIT_SPIDER","unit/spider.plist","spider",_animation_32_ex_nd(9,8,9),{0.5,0.45}) --tank: 蜘蛛
_tab_model[662] = HMDx32P2PIC("MODEL:UNIT_ROBOT","unit/robot.plist","robot",_animation_32_ex_nd(6,8,6),{0.5,0.45}) --tank: 机器人
_tab_model[663] = HMDx32P2PIC("MODEL:UNIT_RPGZOMBIE","unit/rpgzombie.plist","rpgzombie",_animation_32_ex_nd(7,12,12),{0.5,0.45}) --tank: 僵尸
--卡通坦克车
_tab_model[664] = HMDx32P2PIC("MODEL:UNIT_JEEP3","unit/jeep3.plist","jeep3",_animation_32_ex(1,1,1,10),{0.5,0.45}) --tank: 装甲车身体
_tab_model[665] = HMDx32P2PIC("MODEL:UNIT_JEEP_WHEELL2","unit/jeepwheel2.plist","jeepwheel2",_animation_32_ex(1,5,1,0),{0.5,0.45}) --tank: 装甲车轮子发亮
_tab_model[666] = HMDx32P2PIC("MODEL:UNIT_JEEP_GUN10","unit/jeepgun10.plist","jeepgun10",_animation_32,{0.5,0.45}) --tank: 装甲车机关枪
--飞船
_tab_model[667] = HMDx32P2PIC("MODEL:UNIT_AIRSHIP","unit/airship.plist","airship",_animation_32_ex_nd(1,1,1,10),{0.5,0.45}) --tank: 飞船身体
_tab_model[668] = HMDx32P2PIC("MODEL:UNIT_AIRSHIP_GUN","unit/airshipgun.plist","airshipgun",_animation_32,{0.5,0.45}) --tank: 飞船机关枪
_tab_model[669] = HMDx32P2PIC("MODEL:UNIT_AIRSHIP2","unit/airship2.plist","airship2",_animation_32_ex_nd(9,1,1,10),{0.5,0.45}) --tank: 飞船2身体
_tab_model[670] = HMDx32P2PIC("MODEL:UNIT_AIRSHIP2_SHADOW","unit/airship2shadow.plist","airship2shadow",_animation_32,{0.5,0.45}) --tank: 飞船2影子

--章鱼怪
_tab_model[671] = HeroModelDx4PL_2PIC("MODEL:HERO_zhangyuguai","unit/zhangyuguai.plist","zhangyuguai",_animation_zerg,{0.5,0.5})

_tab_model[672] = HeroModelDx16PL_1PIC("MODEL:UNIT_CANNON","unit/cannon.plist","cannon",_animation_XVVVIII,{0.5,0.7}) --cannon
_tab_model[673] = HeroModelDx16PL_1PIC("MODEL:UNIT_CANNON2","unit/cannon2.plist","cannon2",_animation_XVVVIII,{0.5,0.7}) --cannon2
_tab_model[674] = HeroModelDx16PL_1PIC("MODEL:UNIT_MACHINE_GUN","unit/machine_gun.plist","machine_gun",_animation_XVVVIII,{0.5,0.7}) --machine_gun
_tab_model[675] = HeroModelDx16PL_1PIC("MODEL:UNIT_ICETOWER","unit/icetower.plist","icetower",_animation_XVVVIII,{0.5,0.7}) --icetower
_tab_model[676] = HeroModelDx16PL_1PIC("MODEL:UNIT_GRENADE","unit/grenade.plist","grenade",_animation_XVVVIII,{0.5,0.7}) --grenade

--蓝菌怪
_tab_model[677] = HeroModelDx16PL_1PIC("MODEL:UNIT_BLUE_CARRIER","unit/bluecarrier.plist","bluecarrier",_animation_XVVVIII,{0.5,0.7}) --tank: 装甲车能量圈

--老奶奶
_tab_model[678] = UnitModelDx2PL_2PIC("MODEL:HERO_OLD_WOMEN","unit/oldwomen.plist","oldwomen",_animation_Bing_02,{0.35,0.7})
--士兵
_tab_model[679] = UnitModelDx2PL_2PIC("MODEL:HERO_SOLDIER","unit/soldier.plist","soldier",_animation_Soldier,{0.35,1.0})
--科学家
_tab_model[680] = UnitModelDx2PL_2PIC("MODEL:HERO_SCIENTIST","unit/scientist.plist","scientist",_animation_Scientist,{0.35,0.5})
--吉普车死亡单位
_tab_model[681] = HMDx32P2PIC("MODEL:UNIT_JEEP3_DEAD","unit/jeep3_dead.plist","jeep3_dead",_animation_32_ex(1,1,1,1),{0.5,0.45}) --tank: 装甲车身体
--蜘蛛2
_tab_model[682] = HMDx32P2PIC("MODEL:UNIT_BIO_SPIDER","unit/bio_spider.plist","bio_spider",_animation_32_quickskill_ex(8,12,12,14),{0.5,0.45}) --tank: 蜘蛛2
--钢铁蜘蛛2
_tab_model[683] = HeroModelDx4PL_2PIC("MODEL:UNIT_METAL_SPIDER2","unit/metal_spider2.plist","metal_spider2",_animation_32_skill_ex_big(9,11,11,13,11),{0.5,0.5})
--钢铁蜘蛛
_tab_model[684] = HeroModelDx4PL_2PIC("MODEL:UNIT_METAL_SPIDER","unit/metal_spider.plist","metal_spider",_animation_32_skill_ex_big(9,11,11,13,11),{0.5,0.5}) --tank_test:测试用: 坦克炮口模型
--瓦力
_tab_model[685] = HMDx32P2PIC("MODEL:UNIT_WALLE","unit/walle.plist","walle",_animation_32_skill_nd(11,11,11,13,11),{0.5,0.45}) --tank: 瓦力
--刺蛇
_tab_model[686] = HMDx32P2PIC("MODEL:UNIT_Hydralisk","unit/hydralisk.plist","hydralisk",_animation_32_skill_nd2(8,12,12,14),{0.5,0.45}) --tank:刺蛇
--静止小飞机
_tab_model[687] = HMDx32P2PIC("MODEL:UNIT_AIRSHIP2_static","unit/airship2.plist","airship2",_animation_32_ex_nd(1,1,1,10),{0.5,0.45})
--死神
_tab_model[688] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_sishen","unit/sishen.plist","sishen","sishen.plist","sishen",_animation_Bing_02,{0.5,0.62})
--亡灵
_tab_model[689] = UnitModelDx2PL_2PIC("MODEL:UNIT_youling_wangling","unit/youling.plist","youling",_animation_XVII,{0.5,0.66})
--朱雀 
--_tab_model[690] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Phoenix","unit/Phoenix.plist","phoenix","unit/phoenix.plist","phoenix",_animation_VI,{0.5,0.7})--
_tab_model[690] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_Phoenix","unit/units.plist","phoenix","unit/phoenix.plist","phoenix",_animation_XVII,{0.5,0.7})--
--魔王
_tab_model[691] = HeroModelDx8PL_2PIC("MODEL:HERO_mowang","unit/mowang.plist","mowang",_animation_Normal,{0.5,0.62})
--蝙蝠
_tab_model[692] = UnitModelDx2PL_2PIC_2PAT("MODEL:UNIT_bianfu","unit/bianfu.plist","bianfu","unit/bianfu.plist","bianfu",_animation_XVII,{0.5,0.7})
_tab_model[693] = HMDx32P2PIC("MODEL:UNIT_AIRSHIP3_SHADOW","unit/airship3shadow.plist","airship3shadow",_animation_32_ex_sd2(1,1,1,1),{0.5,0.45}) --tank: 飞船3影子
--大飞船
_tab_model[694] = HMDx32P2PIC("MODEL:UNIT_AIRSHIP3","unit/airship3.plist","airship3",_animation_32_ex_sd2(7,7,1,10),{0.5,0.45})

--太空飞船
_tab_model[695] = HMDx32P2PIC("MODEL:UNIT_SPACESHIP","unit/spaceship.plist","spaceship",_animation_32_spaceship,{0.5,0.5})

--飞碟
_tab_model[696] = HeroModelDx4PL_2PIC("MODEL:HERO_plate","unit/plate.plist","plate",_animation_plate,{0.5,0.5})

--眼睛
_tab_model[697] = HeroModelDx4PL_2PIC("MODEL:HERO_gazer","unit/gazer.plist","gazer",_animation_gazer,{0.5,0.5})

--车灯光照2
_tab_model[698] = HMDx32P2PIC("MODEL:UNIT_JEEP_LIGHT2","unit/jeeplamplight2.plist","jeeplamplight2",_animation_32_4,{0.5,0.45}) --tank: 装甲车光照

--坦克雷神之锤
_tab_model[699] = HMDx32P2PIC("MODEL:UNIT_JEEP_THUNDER","unit/jeepthunder.plist","jeepthunder",_animation_32,{0.5,0.45}) --tank: 装甲车光照
--小章鱼怪
_tab_model[700] = HMDx32P2PIC("MODEL:HERO_zhangyuguai_s","unit/zhangyuguai_small.plist","zhangyuguai_small",_animation_32_ex_nd(10,10,10,10),{0.5,0.45}) --tank: 瓦力

--导弹
_tab_model[701] = HMDx32P2PIC("MODEL:UNIT_DAODAN","unit/daodan.plist","daodan",_animation_32,{0.5,0.45}) --tank: 导弹
_tab_model[702] = HMDx32P2PIC("MODEL:UNIT_JEEP_TRIPLE","unit/jeepgun11.plist","jeepgun11",_animation_32,{0.5,0.45}) --tank: 三管光枪
_tab_model[703] = HMDx32P2PIC("MODEL:UNIT_JEEP_POSION","unit/jeepgun12.plist","jeepgun12",_animation_32,{0.5,0.45}) --tank: 毒枪
_tab_model[704] = HMDx32P2PIC("MODEL:UNIT_JEEP_SHRINK","unit/jeepgun13.plist","jeepgun13",_animation_32,{0.5,0.45}) --tank: 缩小枪
--空中堡垒
_tab_model[705] = HeroModelDx4PL_2PIC("MODEL:HERO_SKY_FORTRESS","unit/sky_fortress.plist","sky_fortress",_animation_sky_fortress,{0.5,0.5})
--尤达
_tab_model[706] = HeroModelDx4PL_2PIC("MODEL:UNIT_YODA","unit/yoda.plist","yoda",_animation_yoda,{0.5,0.5})
--支援战机
_tab_model[707] = HMDx32P2PIC("MODEL:UNIT_TIE","unit/tie.plist","tie",_animation_tie,{0.5,0.5})
--飞船怪物
_tab_model[708] = HeroModelDx4PL_2PIC("MODEL:HERO_MONSTER","unit/monster.plist","monster",_animation_monster,{0.5,0.5})
--机械兽
_tab_model[709] = HMDx32P2PIC("MODEL:METAL_BEAST","unit/metal_beast.plist","metal_beast",_animation_metal_beast,{0.5,0.5})
--超级机器人
_tab_model[710] = HeroModelDx16PL_2PIC("MODEL:SUPER_ROBOT","unit/super_robot.plist","super_robot",_animation_super_robot,{0.5,0.5})

---究极飞船部件
---炮1
_tab_model[711] = HMDx32P2PIC("MODEL:BOSS_GUN_1","unit/bossgun1.plist","bossgun1",_animation_32,{0.5,0.5}) --tank: 装甲车机关枪
---炮2
_tab_model[712] = HMDx32P2PIC("MODEL:BOSS_GUN_2","unit/bossgun2.plist","bossgun2",_animation_32,{0.5,0.5}) --tank: 装甲车机关枪
--船体
_tab_model[713] = HeroModelDx4PL_2PIC("MODEL:HERO_ultimaairship","unit/ultimaairship.plist","ultimaairship",_animation_superairship,{0.5,0.5})

--高射塔
_tab_model[714] = HeroModelDx16PL_1PIC("MODEL:HERO_td_gaosheta","unit/gaosheta.plist", "gaosheta", _animation_GAOSHETA,{0.5, 0.5}) --高射塔

--高射塔生长动画
_tab_model[715] = UnitModelDx2PL_2PIC("MODEL:HERO_td_gaosheta_grow","unit/gaosheta_grow.plist","gaosheta_grow",_animation_GAOSHETA_GROW,{0.5,0.5})

--激光塔
_tab_model[716] = UnitModelDx2PL_2PIC("MODEL:HERO_td_jiguangta","unit/jiguangta.plist","jiguangta",_animation_JIGUANGTA,{0.5,0.5})

--激光塔生长动画
_tab_model[717] = UnitModelDx2PL_2PIC("MODEL:HERO_td_jiguangta_grow","unit/jiguangta_grow.plist","jiguangta_grow",_animation_JIGUANGTA_GROW,{0.5,0.5})

--机枪塔
_tab_model[718] = HeroModelDx16PL_1PIC("MODEL:HERO_td_jiqiangta","unit/jiqiangta.plist", "jiqiangta", _animation_GAOSHETA,{0.5, 0.5}) --机枪塔

--机枪塔生长动画
_tab_model[719] = UnitModelDx2PL_2PIC("MODEL:HERO_td_jiqiangta_grow","unit/jiqiangta_grow.plist","jiqiangta_grow",_animation_JIQIANGTA_GROW,{0.5,0.5})

--炮台塔
_tab_model[720] = HeroModelDx16PL_1PIC("MODEL:HERO_td_paotaita","unit/paotaita.plist", "paotaita", _animation_PAOTAITA,{0.5, 0.5}) --炮台塔

--炮台塔生长动画
_tab_model[721] = UnitModelDx2PL_2PIC("MODEL:HERO_td_paotaita_grow","unit/paotaita_grow.plist","paotaita_grow",_animation_PAOTAITA_GROW,{0.5,0.5})

--射击塔
_tab_model[722] = HeroModelDx16PL_1PIC("MODEL:HERO_td_shejita","unit/shejita.plist", "shejita", _animation_SHEJITA,{0.5, 0.5}) --射击塔

--射击塔生长动画
_tab_model[723] = UnitModelDx2PL_2PIC("MODEL:HERO_td_shejita_grow","unit/shejita_grow.plist","shejita_grow",_animation_SHEJITA_GROW,{0.5,0.5})

--飞龙
_tab_model[724] = HMDx32P2PIC("MODEL:UNIT_DRAGON","unit/dragon.plist","dragon",_animation_32_skill_nd(16,16,16,16),{0.5,0.5})

--兵工厂
_tab_model[725] = UnitModelDx2PL_2PIC("MODEL:HERO_td_binggongchang","unit/binggongchang.plist","binggongchang",_animation_BINGGONGCHANG,{0.5,0.7})

--地鼠机
_tab_model[726] = HMDx32P2PIC("MODEL:UNIT_GAME","unit/game.plist","game",_animation_32_game,{0.5,0.5})

--升降台
_tab_model[727] = UnitModelDx2PL_plist("MODEL:UNIT_taizi","unit/taizi_world.plist","taizi_world",_animation_taizi,{0.5,0.5})

--黑龙
_tab_model[728] = UnitModelDx2PL_plist("MODEL:UNIT_DRAGON_4ACTION","unit/blackdragon_world.plist","blackdragon_world",_animation_blackdragon,{0.5,0.5})

--火车头
_tab_model[729] = HeroModelDx16PL_1PIC("MODEL:UNIT_TRAIN01","unit/train01.plist","train01",_animation_train,{0.5,0.5})
--火车厢
_tab_model[730] = HeroModelDx16PL_1PIC("MODEL:UNIT_TRAIN02","unit/train02.plist","train02",_animation_train,{0.5,0.5})

--铁人
_tab_model[731] = UnitModelDx2PL_2PIC("MODEL:UNIT_IRONMAN","unit/ironman.plist","ironman",_animation_ironman,{0.5,0.5})
--导弹塔2
_tab_model[732] = HeroModelDx8PL_2PIC("MODEL:HERO_td_daodanta2","unit/tdpaota3.plist", "tdpaota3", _animation_ddta,{0.5, 0.5})

--卡通飞行车
_tab_model[733] = HMDx32P2PIC("MODEL:UNIT_JEEP4","unit/jeep4.plist","jeep4",_animation_32_ex(1,1,1,1),{0.5,0.5}) --tank: 装甲车身体

--球形机器人
_tab_model[734] = HMDx32P2PIC("MODEL:UNIT_BALL_ROBOT","unit/ball_robot.plist","ball_robot",_animation_ball_robot,{0.5,0.5})
--菱形机器人
_tab_model[735] = HeroModelDx4PL_2PIC("MODEL:UNIT_RAMIEL","unit/ramiel.plist","ramiel",_animation_ramiel,{0.5,0.5})
--星河虫
_tab_model[736] = HMDx32P2PIC("MODEL:UNIT_WARRIOR","unit/warrior.plist","warrior",_animation_32_ex_nd(6,8,6,8),{0.5,0.5})
--盾牌机器人
_tab_model[737] = HMDx32P2PIC("MODEL:SHIELD_ROBOT","unit/shield_robot.plist","shield_robot",_animation_32_skill_ex_mid(6,7,8,7,6),{0.5,0.5})
--触手怪
_tab_model[738] = HMDx32P2PIC("MODEL:UNIT_TENTACLE","unit/tentacle.plist","tentacle",_animation_32_skill_ex_mid_nd(9,9,9,11,9),{0.5,0.5})
--卡车
_tab_model[739] = HMDx32P2PIC("MODEL:UNIT_TRUCK","unit/truck.plist","truck",_animation_32_ex(1,1,8,12),{0.5,0.5})
--钢铁气球
_tab_model[740] = HeroModelDx4PL_2PIC("MODEL:METAL_BALLOON","unit/metal_balloon.plist","metal_balloon",_animation_metal_balloon,{0.5,0.5})
--钢铁气球2
_tab_model[741] = HeroModelDx4PL_2PIC("MODEL:METAL_BALLOON2","unit/metal_balloon2.plist","metal_balloon2",_animation_metal_balloon2,{0.5,0.5})
--钢铁大脑怪
_tab_model[742] = HMDx32P2PIC("MODEL:UNIT_METAL_BRAIN","unit/metal_brain.plist","metal_brain",_animation_32_skill_ex_mid_nd(6,6,11,10),{0.5,0.5})
--大脑怪
_tab_model[743] = HMDx32P2PIC("MODEL:UNIT_BRAIN","unit/brain.plist","brain",_animation_32_skill_ex_mid_nd(6,6,11,10),{0.5,0.5})
--机甲少女
_tab_model[744] = HMDx32P2PIC("MODEL:FRAME_ARMS_GIRL","unit/fag.plist","fag",_animation_fag,{0.5,0.5})
--量产机-白
_tab_model[745] = HMDx32P2PIC("MODEL:MASS_PRODUCTION_EVA_WHITE","unit/mpew.plist","mpew",_animation_mpe,{0.5,0.72})
--量产机-黑
_tab_model[746] = HMDx32P2PIC("MODEL:MASS_PRODUCTION_EVA_BLACK","unit/mpeb.plist","mpeb",_animation_mpe,{0.5,0.72})

_tab_model[747] = HMDx32P2PIC("MODEL:UNIT_JEEP_GUN_A","unit/jeepgun_a.plist","jeepgun_a",_animation_32,{0.5,0.45}) --tank: 装甲车机关枪a
_tab_model[748] = HMDx32P2PIC("MODEL:UNIT_JEEP_GUN_B","unit/jeepgun_b.plist","jeepgun_b",_animation_32,{0.5,0.45}) --tank: 装甲车机关枪b

--虫巢
_tab_model[749] = UnitModelDx2PL_2PIC("MODEL:UNIT_NEST","unit/nest.plist","nest",_animation_nest,{0.5,0.5})

_tab_model[750] = HMDx32P2PIC("MODEL:UNIT_JEEP_POSION_A","unit/jeepgun12_a.plist","jeepgun12_a",_animation_32,{0.5,0.45}) --tank: 毒枪
_tab_model[751] = HMDx32P2PIC("MODEL:UNIT_JEEP_POSION_B","unit/jeepgun12_b.plist","jeepgun12_b",_animation_32,{0.5,0.45}) --tank: 毒枪

--科技中心
_tab_model[752] = UnitModelDx2PL_2PIC("MODEL:UNIT_TECHCENTER","unit/techcenter.plist","techcenter",_animation_techcenter,{0.5,0.5})

_tab_model[753] = HMDx32P2PIC("MODEL:UNIT_JEEP_SHRINK_A","unit/jeepgun13_a.plist","jeepgun13_a",_animation_32,{0.5,0.45}) --tank: 缩小枪
_tab_model[754] = HMDx32P2PIC("MODEL:UNIT_JEEP_SHRINK_B","unit/jeepgun13_b.plist","jeepgun13_b",_animation_32,{0.5,0.45}) --tank: 缩小枪
_tab_model[755] = HMDx32P2PIC("MODEL:UNIT_JEEP_GAOSI_A","unit/jeepgun9_a.plist","jeepgun9_a",_animation_32,{0.5,0.45}) --tank: 火箭枪
_tab_model[756] = HMDx32P2PIC("MODEL:UNIT_JEEP_GAOSI_B","unit/jeepgun9_b.plist","jeepgun9_b",_animation_32,{0.5,0.45}) --tank: 火箭枪
_tab_model[757] = HMDx32P2PIC("MODEL:UNIT_JEEP_CHASER_A","unit/jeepgun8_a.plist","jeepgun8_a",_animation_32,{0.5,0.45}) --tank: 导弹枪
_tab_model[758] = HMDx32P2PIC("MODEL:UNIT_JEEP_CHASER_B","unit/jeepgun8_b.plist","jeepgun8_b",_animation_32,{0.5,0.45}) --tank: 导弹枪
_tab_model[759] = HMDx32P2PIC("MODEL:UNIT_JEEP_LASER_A","unit/jeepgun3_a.plist","jeepgun3_a",_animation_32,{0.5,0.45}) --tank: 装甲车激光枪
_tab_model[760] = HMDx32P2PIC("MODEL:UNIT_JEEP_LASER_B","unit/jeepgun3_b.plist","jeepgun3_b",_animation_32,{0.5,0.45}) --tank: 装甲车激光枪

--异形女王
_tab_model[761] = HMDx32P2PIC("MODEL:HERO_ALIEN_QUEEN","unit/alien_queen.plist","alien_queen",_animation_alien_q,{0.5,0.5})
--虫卵
_tab_model[762] = HeroModelDx4PL_2PIC("MODEL:UNIT_EGG","unit/egg.plist","egg",_animation_egg,{0.45,0.55})
--虫卵(空心)
_tab_model[763] = HeroModelDx4PL_2PIC("MODEL:UNIT_EGG2","unit/egg2.plist","egg2",_animation_egg,{0.45,0.55})
_tab_model[764] = HMDx32P2PIC("MODEL:UNIT_JEEP_TANK","unit/jeep_tank.plist","jeep_tank",_animation_32_ex_nd(1,5,1),{0.5,0.45}) --tank: 装甲车身体
_tab_model[765] = HMDx32P2PIC("MODEL:UNIT_JEEP_TERMINATOR","unit/jeepgun14.plist","jeepgun14",_animation_32,{0.5,0.65})
_tab_model[766] = HMDx32P2PIC("MODEL:UNIT_JEEP_GIPSY","unit/jeepgun15.plist","jeepgun15",_animation_32,{0.5,0.65})
_tab_model[767] = UnitModelDx2PL_2PIC("MODEL:UNIT_JEEP_SPIDER","unit/jeep_spider.plist","jeep_spider",_animation_jeep_spider,{0.5,0.41}) --tank: 装甲车身体

_tab_model[768] = HMDx32P2PIC("MODEL:UNIT_JEEP_DAPAO","unit/jeepgun7.plist","jeepgun7",_animation_32,{0.5,0.45})
_tab_model[769] = HMDx32P2PIC("MODEL:UNIT_JEEP_GREEN","unit/jeep_green.plist","jeep_green",_animation_32_ex_nd(1,4,1),{0.5,0.55})
_tab_model[770] = HMDx32P2PIC("MODEL:UNIT_JEEP_TANK2","unit/jeep_tank2.plist","jeep_tank2",_animation_32_ex_nd(1,5,1),{0.5,0.55})
_tab_model[771] = UnitModelDx2PL_2PIC("MODEL:UNIT_JEEP_SPIDER2","unit/jeep_spider2.plist","jeep_spider2",_animation_jeep_spider,{0.5,0.57})
_tab_model[772] = HMDx32P2PIC("MODEL:UNIT_UGLY_SPIDER","unit/ugly_spider.plist","ugly_spider",_animation_32_ex(6,8,1,10),{0.5,0.5})
_tab_model[773] = HMDx32P2PIC("MODEL:UNIT_JEEPGUN_TANK","unit/jeepgun_tank.plist","jeepgun_tank",_animation_32,{0.5,0.5})
_tab_model[774] = HMDx32P2PIC("MODEL:UNIT_JEEPGUN_SPIDER2","unit/jeepgun_spider2.plist","jeepgun_spider2",_animation_32,{0.5,0.6})
--机械臂
_tab_model[775] = UnitModelDx2PL_plist("MODEL:UNIT_ARM","unit/arm_world.plist","arm_world",_animation_arm,{0.5,0.5})
--士官长
_tab_model[776] = UnitModelDx2PL_2PIC("MODEL:HERO_SOLDIER2","unit/soldier2.plist","soldier2",_animation_Soldier2,{0.35,1.0})

_tab_model[777] = HMDx32P2PIC("MODEL:UNIT_JEEP_FIRE_A","unit/jeepgun1_a.plist","jeepgun1_a",_animation_32,{0.5,0.45})
_tab_model[778] = HMDx32P2PIC("MODEL:UNIT_JEEP_GATLIN_A","unit/jeepgun2_a.plist","jeepgun2_a",_animation_32,{0.5,0.45})
_tab_model[779] = HMDx32P2PIC("MODEL:UNIT_JEEP_TRIPLE_A","unit/jeepgun11_a.plist","jeepgun11_a",_animation_32,{0.5,0.45})
_tab_model[780] = HMDx32P2PIC("MODEL:UNIT_JEEP_GUN10_A","unit/jeepgun10_a.plist","jeepgun10_a",_animation_32,{0.5,0.45})
_tab_model[781] = HMDx32P2PIC("MODEL:UNIT_JEEP_GUN10_B","unit/jeepgun10_b.plist","jeepgun10_b",_animation_32,{0.5,0.45})
--伊娃
_tab_model[782] = UnitModelDx2PL_2PIC("MODEL:UNIT_EVE","unit/eve.plist","eve",_animation_eve,{0.4,0.6})
--机枪士官长
_tab_model[783] = HeroModelDx8PL_2PIC("MODEL:HERO_SOLDIER3","unit/soldier3.plist","soldier3",_animation_Soldier3,{0.35,1.0})