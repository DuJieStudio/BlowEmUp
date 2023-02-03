--道具掉落
hVar.tab_drop = {index = {}}
local _tab_drop = hVar.tab_drop
local __InitBasic = function(cTab,vChance,rTab)
	local chanceA = 0
	local chanceB = vChance
	if vChance<=1 then
		return rTab
	end
	for i = 1,#cTab do
		chanceA = chanceA + cTab[i][2]
	end
	--local pec = chanceB/chanceA
	for i = 1,#cTab do
		local v = {unpack(cTab[i])}
		v[2] = math.floor(v[2]*chanceB/chanceA)
		rTab[#rTab+1] = v
	end
	return rTab
end
hVar.tab_drop.init = function(name,tNewCance)
	if name==nil then
		--首次加载
		for i = 1,99 do
			local v = _tab_drop[i]
			if v then
				if v.name then
					_tab_drop.index[v.name] = i
				end
				if v.basic then
					for i = 1,#v.basic do
						local vChance = v.basic[i].chance or 0
						__InitBasic(v.basic[i],vChance,v)
					end
				end
			end
		end
	elseif _tab_drop.index[name] then
		--重加载特定掉落
		local index = _tab_drop.index[name]
		local c = _tab_drop[index]
		local v = {name = c.name,basic = c.basic}
		_tab_drop[index] = v
		for i = 1,#v.basic do
			local vChance = v.basic[i].chance
			if type(tNewCance)=="table" and tNewCance[i] and tNewCance[i]>0 then
				vChance = tNewCance[i]
			end
			__InitBasic(v.basic[i],vChance,v)
		end
	end
end
--白色装备
local __TAB__ItemDrop_Lv1 = {
	100,101,102,103,104,105,106,107,
}
--蓝色装备(铜箱特殊)
local __TAB__ItemDrop_Lv2_copper = {
	500,501,502,600,601,602,603,604,
}
--蓝色装备
local __TAB__ItemDrop_Lv2 = {
	501,502,504,620,621,622,623,624,
}
--黄色装备
local __TAB__ItemDrop_Lv3 = {
	--鱼肠,龙舌弓,仙灵羽扇,狼牙枪,血饮斧,五色剑,古锭刀
	1001,1002,1003,1004,1005,1006,1007,
}
--红色装备
local __TAB__ItemDrop_Lv4 = {
	--太平要术,七星刀,方天画戟,九天惊雷仗,碎金,黑风双镰,伏完风衣
	8000,8001,8002,8003,8004,8005,8006,
}


--重新加载许愿池里面的道具
hVar.WISHING_WELL_ITEM = {}
for i = 1,#__TAB__ItemDrop_Lv4 do
	hVar.WISHING_WELL_ITEM[i] = __TAB__ItemDrop_Lv4[i]
end
local __CreateDropListData = function(nItemId,tDefaultData,tData)
	local id,c,q,v,p = unpack(tDefaultData)
	id = nItemId
	if tData[nItemId] then
		id,c,q,v,p = unpack(tData[nItemId])
	end
	return {id,c,q,v,p}
end
local __DropList = function(sDropName,tItemList,tData,tPlusData)
	local tList = {
		chance = tData.chance,
	}
	local tDefaultData = tData.default
	if tDefaultData then
		for i = 1,#tItemList do
			tList[#tList+1] = __CreateDropListData(tItemList[i],tDefaultData,tData)
		end
	end
	if type(tPlusData)=="table" then
		for i = 1,#tPlusData do
			tList[#tList+1] = tPlusData[i]
		end
	end
	return tList
end
_tab_drop[1] = {
	name = "copper_box",

	--td宝箱掉落配置
	td_basic = {
		maxPool = 3,					--奖池数量
		maxDrop = 8,					--最大掉落数量
		dropSetting = {5,2,1},				--奖池掉落个数
		pool = {
			--1级奖池
			[1] = {
				{11011,0},
				{11013,0},
				{11015,0},
				{11017,0},
				{11019,0},
				{11021,0},
				{11023,0},
				{11028,0},
				{11031,0},
				{11034,0},
				{11012,1},
				{11014,1},
				{11016,1},
				{11018,1},
				{11020,1},
				{11022,1},
				{11024,1},
				{11029,1},
				{11032,1},
				{11035,1},
			},
			--2级奖池
			[2] = {
				{11012,4},
				{11014,4},
				{11016,4},
				{11018,4},
				{11020,4},
				{11022,4},
				{11024,4},
				{11029,4},
				{11032,4},
				{11035,4},
				{11037,3},
				{11038,3},
				{11041,3},
				{11043,3},
				{11045,3},
				{11047,3},
				{11049,3},
				{11051,3},

				{11012,2},
				{11014,2},
				{11016,2},
				{11018,2},
				{11020,2},
				{11022,2},
				{11024,2},
				{11029,2},
				{11032,2},
				{11035,2},
				{11037,1},
				{11038,1},
				{11041,1},
				{11043,1},
				{11045,1},
				{11047,1},
				{11049,1},
				{11051,1},
			},
			--3级奖池
			[3] = {
				{11025,7},
				{11026,7},
				{11027,7},
				{11030,7},
				{11033,7},
				{11036,7},
				{11039,6},
				{11040,6},
				{11042,6},
				{11044,6},
				{11046,6},
				{11048,5},
				{11050,5},
				{11052,5},

				{11025,5},
				{11026,5},
				{11027,5},
				{11030,5},
				{11033,5},
				{11036,5},
				{11039,4},
				{11040,4},
				{11042,4},
				{11044,4},
				{11046,4},
				{11048,3},
				{11050,3},
				{11052,3},

				{11025,3},
				{11026,3},
				{11027,3},
				{11030,3},
				{11033,3},
				{11036,3},
				{11039,2},
				{11040,2},
				{11042,2},
				{11044,2},
				{11046,2},
				{11048,1},
				{11050,1},
				{11052,1},

				{11037,5},
				{11038,5},
				{11041,5},
				{11043,5},
				{11045,5},
				{11047,5},
				{11049,5},
				{11051,5},
			},
		},
	},
}

_tab_drop[2] = {
	name = "silver_box",
	basic = {
		--等级2的道具
		__DropList("silver_box_lv2",__TAB__ItemDrop_Lv2,{
			chance = 3000,
			default = {0,80,40,2,0},
		}),
		--等级3的道具
		__DropList("silver_box_lv3",__TAB__ItemDrop_Lv3,{
			chance = 2000,
			default = {0,100,70,5,0},
			[1500] = {1500,80,70,5,0},		--翔云靴
			[1706] = {1706,80,70,5,0},		--夜明珠
			[3001] = {3001,80,70,5,0},		--幼麟2
		}),
		--等级4的道具
		__DropList("silver_box_lv4",__TAB__ItemDrop_Lv4,{
			chance = 300,
			default = {0,100,100,6,0},
			[3005] = {3005,80,100,6,0},		--亢龙3
		}),
	},
	--td宝箱掉落配置
	td_basic = {
		maxPool = 3,					--奖池数量
		maxDrop = 8,					--最大掉落数量
		dropSetting = {5,2,1},				--奖池掉落个数
		pool = {
			--1级奖池
			[1] = {
				{11023,3},
			},
			--2级奖池
			[2] = {
				{11024,4},
			},
			--3级奖池
			[3] = {
				{11025,4},
			},
		},
	},
}

_tab_drop[3] = {
	name = "gold_box",
	basic = {
		--等级2的道具
		__DropList("gold_box_lv2",__TAB__ItemDrop_Lv2,{
			chance = 1600,
			default = {0,100,40,2,0},
		}),
		--等级3的道具
		__DropList("gold_box_lv3",__TAB__ItemDrop_Lv3,{
			chance = 2000,
			default = {0,100,70,3,0},
			[1500] = {1500,80,70,3,0},		--翔云靴
			[1706] = {1706,80,70,3,0},		--夜明珠
			[3001] = {3001,80,70,3,0},		--幼麟2
		}),
		--等级4的道具
		__DropList("gold_box_lv4",__TAB__ItemDrop_Lv4,{
			chance = 500,
			default = {0,100,100,7,0},
			[3005] = {3005,80,100,7,0},		--亢龙3
		}),
	},
	--td宝箱掉落配置
	td_basic = {
		maxPool = 3,					--奖池数量
		maxDrop = 8,					--最大掉落数量
		dropSetting = {5,2,1},				--奖池掉落个数
		pool = {
			--1级奖池
			[1] = {
				{11023,3},
			},
			--2级奖池
			[2] = {
				{11024,4},
			},
			--3级奖池
			[3] = {
				{11025,4},
			},
		},
	},
}






----------------------------------------------------------
--战术技能卡掉落
hVar.tab_dropT = {}
local _tab_dropT = hVar.tab_dropT
_tab_dropT.index = {}
_tab_dropT.map = {
	--允许使用的地图
	--{"world/level_tyjy",0,},
	--{"world/level_xsnd",0,},
	--{地图名,掉落品质,{不同难度战斗力基本需求},{最高掉落等级}}
	{"world/level_hjzl",100,{0,800,1000,1300,1600},{3,}},
}


_tab_dropT[1] = {
	DropLv = {[1] = 1},					--{最高掉落等级}
	CombatRequire = {0,0,9999999,9999999,9999999},		--{不同难度战斗力基本需求}
	--掉落ID,基本掉率,最低战斗力需求,战斗力在不同难度下对掉落等级的影响(非表则使用CombatRequire)
	--步兵
	{101,100,0,0},
}
--初级卡包扩展掉落
_tab_dropT[2] = {
	--步兵
	{156,20,0,0},
}
--高级卡包扩展掉落
_tab_dropT[3] = {
	--步兵
	{156,30,0,0},
}