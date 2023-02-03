--���ߵ���
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
		--�״μ���
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
		--�ؼ����ض�����
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
--��ɫװ��
local __TAB__ItemDrop_Lv1 = {
	100,101,102,103,104,105,106,107,
}
--��ɫװ��(ͭ������)
local __TAB__ItemDrop_Lv2_copper = {
	500,501,502,600,601,602,603,604,
}
--��ɫװ��
local __TAB__ItemDrop_Lv2 = {
	501,502,504,620,621,622,623,624,
}
--��ɫװ��
local __TAB__ItemDrop_Lv3 = {
	--�㳦,���๭,��������,����ǹ,Ѫ����,��ɫ��,�Ŷ���
	1001,1002,1003,1004,1005,1006,1007,
}
--��ɫװ��
local __TAB__ItemDrop_Lv4 = {
	--̫ƽҪ��,���ǵ�,���컭�,���쾪����,���,�ڷ�˫��,�������
	8000,8001,8002,8003,8004,8005,8006,
}


--���¼�����Ը������ĵ���
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

	--td�����������
	td_basic = {
		maxPool = 3,					--��������
		maxDrop = 8,					--����������
		dropSetting = {5,2,1},				--���ص������
		pool = {
			--1������
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
			--2������
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
			--3������
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
		--�ȼ�2�ĵ���
		__DropList("silver_box_lv2",__TAB__ItemDrop_Lv2,{
			chance = 3000,
			default = {0,80,40,2,0},
		}),
		--�ȼ�3�ĵ���
		__DropList("silver_box_lv3",__TAB__ItemDrop_Lv3,{
			chance = 2000,
			default = {0,100,70,5,0},
			[1500] = {1500,80,70,5,0},		--����ѥ
			[1706] = {1706,80,70,5,0},		--ҹ����
			[3001] = {3001,80,70,5,0},		--����2
		}),
		--�ȼ�4�ĵ���
		__DropList("silver_box_lv4",__TAB__ItemDrop_Lv4,{
			chance = 300,
			default = {0,100,100,6,0},
			[3005] = {3005,80,100,6,0},		--����3
		}),
	},
	--td�����������
	td_basic = {
		maxPool = 3,					--��������
		maxDrop = 8,					--����������
		dropSetting = {5,2,1},				--���ص������
		pool = {
			--1������
			[1] = {
				{11023,3},
			},
			--2������
			[2] = {
				{11024,4},
			},
			--3������
			[3] = {
				{11025,4},
			},
		},
	},
}

_tab_drop[3] = {
	name = "gold_box",
	basic = {
		--�ȼ�2�ĵ���
		__DropList("gold_box_lv2",__TAB__ItemDrop_Lv2,{
			chance = 1600,
			default = {0,100,40,2,0},
		}),
		--�ȼ�3�ĵ���
		__DropList("gold_box_lv3",__TAB__ItemDrop_Lv3,{
			chance = 2000,
			default = {0,100,70,3,0},
			[1500] = {1500,80,70,3,0},		--����ѥ
			[1706] = {1706,80,70,3,0},		--ҹ����
			[3001] = {3001,80,70,3,0},		--����2
		}),
		--�ȼ�4�ĵ���
		__DropList("gold_box_lv4",__TAB__ItemDrop_Lv4,{
			chance = 500,
			default = {0,100,100,7,0},
			[3005] = {3005,80,100,7,0},		--����3
		}),
	},
	--td�����������
	td_basic = {
		maxPool = 3,					--��������
		maxDrop = 8,					--����������
		dropSetting = {5,2,1},				--���ص������
		pool = {
			--1������
			[1] = {
				{11023,3},
			},
			--2������
			[2] = {
				{11024,4},
			},
			--3������
			[3] = {
				{11025,4},
			},
		},
	},
}






----------------------------------------------------------
--ս�����ܿ�����
hVar.tab_dropT = {}
local _tab_dropT = hVar.tab_dropT
_tab_dropT.index = {}
_tab_dropT.map = {
	--����ʹ�õĵ�ͼ
	--{"world/level_tyjy",0,},
	--{"world/level_xsnd",0,},
	--{��ͼ��,����Ʒ��,{��ͬ�Ѷ�ս������������},{��ߵ���ȼ�}}
	{"world/level_hjzl",100,{0,800,1000,1300,1600},{3,}},
}


_tab_dropT[1] = {
	DropLv = {[1] = 1},					--{��ߵ���ȼ�}
	CombatRequire = {0,0,9999999,9999999,9999999},		--{��ͬ�Ѷ�ս������������}
	--����ID,��������,���ս��������,ս�����ڲ�ͬ�Ѷ��¶Ե���ȼ���Ӱ��(�Ǳ���ʹ��CombatRequire)
	--����
	{101,100,0,0},
}
--����������չ����
_tab_dropT[2] = {
	--����
	{156,20,0,0},
}
--�߼�������չ����
_tab_dropT[3] = {
	--����
	{156,30,0,0},
}