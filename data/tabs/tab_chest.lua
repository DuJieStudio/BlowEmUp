hVar.tab_chest = {}

local _tab_chest = hVar.tab_chest

--用于界面展示排序
hVar.tab_chestEx =
{
	1,2,3,4,5,
}


--武器枪宝箱
_tab_chest[1] = {
	name = "武器枪宝箱",
	icon = "misc/chest/chest_01.png",
	width = 274,
	height = 230,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	itemType = hVar.ITEM_TYPE.CHEST_WEAPON_GUN,
	shopItemId = 398, --商品id
}

--战术宝箱
_tab_chest[2] = {
	name = "战术宝箱",
	icon = "misc/chest/chest_02.png",
	width = 274,
	height = 230,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	itemType = hVar.ITEM_TYPE.CHEST_TACTIC,
	shopItemId = 399, --商品id
}

--宠物宝箱
_tab_chest[3] = {
	name = "宠物宝箱",
	icon = "misc/chest/chest_03.png",
	width = 274,
	height = 230,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	itemType = hVar.ITEM_TYPE.CHEST_PET,
	shopItemId = 400, --商品id
}

--装备宝箱
_tab_chest[4] = {
	name = "装备宝箱",
	icon = "misc/chest/chest_04.png",
	width = 274,
	height = 230,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	itemType = hVar.ITEM_TYPE.CHEST_EQUIP,
	shopItemId = 401, --商品id
}

--神器宝箱
_tab_chest[5] = {
	name = "神器宝箱",
	icon = "misc/chest/chest_05.png",
	width = 274,
	height = 230,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	itemType = hVar.ITEM_TYPE.CHEST_REDEQUIP,
	shopItemId = 402, --商品id
}



------------------------------------------------------------------------------------------------------------------------------------------
--免费锦囊
_tab_chest[9913] = 
{
	openCost = 0,					--打开锦囊需要gamecoin
	openDelay = 0,					--获得宝箱后多久可以打开(单位分钟)
	reward = {
		{"Gold_Free",1,1,1},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
		{"Amy_Nommal",5,10,2},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
		{"Amy_Rare",1,3,1},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
		{"Hero_Free",0,1,1},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
	},
}

--战功锦囊
_tab_chest[9914] = 
{
	openCost = 18,					--打开锦囊需要gamecoin
	openDelay = 180,				--获得宝箱后多久可以打开(单位分钟)
	reward = {
		{"Gold_Small",1,1,1},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
		{"Amy_Nommal",12,15,2},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
		{"Amy_Rare",1,3,1},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
		--{"Hero_Free",1,1,1},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
		{"Hero_Normal",0,2,1},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
		{"Ruby_001",1,1,1},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
	},
}

--武侯锦囊
_tab_chest[9915] = 
{
	openCost = 48,					--打开锦囊需要gamecoin
	openDelay = 480,				--获得宝箱后多久可以打开(单位分钟)
	reward = {
		{"Gold_Big",1,1,1},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
		{"Amy_Nommal",36,45,3},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
		{"Amy_Rare",4,8,2},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
		{"Hero_Normal",1,4,1},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
		{"Ruby_002",1,1,1},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
	},
}

--擂台锦囊
_tab_chest[9916] = 
{
	openCost = 0,					--打开锦囊需要gamecoin
	openDelay = 0,					--获得宝箱后多久可以打开(单位分钟)
	reward = {
		{"Gold_Free",1,1,1},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
		{"Amy_Nommal",5,10,2},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
		{"Amy_Rare",1,3,1},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
		{"Hero_Normal",0,1,1},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
		{"Ruby_001",1,1,1},			--{奖池,最小个数,最大个数,分段数(切2刀)(分段数直接变成碎片数，金币数为分段数*所填掉落数)}
	},
}

--红装锦囊
_tab_chest[9917] = 
{
	openCost = 30,					--打开锦囊需要gamecoin
	openDelay = 0,					--获得宝箱后多久可以打开(单位分钟)
	openCostCrystals = 100,				--打开锦囊需要消耗多少神器晶石
	--红装掉落(每个掉落池，都必定会进行掉落计算。每个)
	rewardEx = {
		--掉落池
		[1] = {
			tag = "Equip",	--保底计算时需要使用该值标识正在处理红装
			mustDrop = {"Equip_Red",1}, --保底必定掉落的奖池
			rollCount = 1, --掉落池掉落次数
			--具体的子池配置
			pool = {
				totalValue = 100,
				{value = 38, reward = {"Equip_Blue",1}},
				{value = 55, reward = {"Equip_Yellow",1}},
				{value = 7, reward = {"Equip_Red",1}},
			},
		},
		--掉落池2
		[2] = {
			tag = "Other",
			rollCount = 2, 
			pool = {
				totalValue = 100,
				{value = 60, reward = {"Score_Free",1}},
				{value = 10, reward = {"Amy_Nommal",3}},
				{value = 10, reward = {"Amy_Nommal",5}},
				{value = 10, reward = {"Hero_Free",1}},
				{value = 10, reward = {"Hero_Free",2}},
			},
		},
	},
}

--幸运神器锦囊
_tab_chest[9919] = 
{
	openCost = 0,					--打开锦囊需要gamecoin
	openDelay = 0,					--获得宝箱后多久可以打开(单位分钟)
	openCostCrystals = 0,				--打开锦囊需要消耗多少神器晶石
	
	--红装掉落(每个掉落池，都必定会进行掉落计算。每个)
	rewardEx = {
		--掉落池
		[1] = {
			tag = "Equip",	--保底计算时需要使用该值标识正在处理红装
			mustDrop = {"Equip_Red",1}, --保底必定掉落的奖池
			rollCount = 1, --掉落池掉落次数
			--具体的子池配置
			pool = {
				totalValue = 100,
				{value = 100, reward = {"Equip_Red",1}},
			},
		},
		
		--掉落池2
		[2] = {
			tag = "Other",
			rollCount = 2, 
			pool = {
				totalValue = 100,
				{value = 60, reward = {"Score_Free",1}},
				{value = 10, reward = {"Amy_Nommal",3}},
				{value = 10, reward = {"Amy_Nommal",5}},
				{value = 10, reward = {"Hero_Free",1}},
				{value = 10, reward = {"Hero_Free",2}},
			},
		},
	},
}

--武器枪锦囊
_tab_chest[9920] = 
{
	openCost = 0,					--打开锦囊需要gamecoin
	openDelay = 0,					--获得宝箱后多久可以打开(单位分钟)
	openCostCrystals = 0,				--打开锦囊需要消耗多少神器晶石
	
	--红装掉落(每个掉落池，都必定会进行掉落计算。每个)
	rewardEx = {
		--掉落池1
		[1] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Weapon_Normal",1,1}},
				{value = 30, reward = {"Weapon_Normal",2,2}},
				{value = 20, reward = {"Weapon_Normal",5,5}},
			},
		},
		
		--掉落池2
		[2] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Weapon_Normal",1,1}},
				{value = 30, reward = {"Weapon_Normal",2,2}},
				{value = 20, reward = {"Weapon_Normal",5,5}},
			},
		},
		
		--掉落池3
		[3] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Weapon_Normal",0,0}},
				{value = 25, reward = {"Weapon_Normal",1,1}},
				{value = 15, reward = {"Weapon_Normal",2,2}},
				{value = 10, reward = {"Weapon_Normal",5,5}},
			},
		},
	},
}

--战术卡锦囊
_tab_chest[9921] = 
{
	openCost = 0,					--打开锦囊需要gamecoin
	openDelay = 0,					--获得宝箱后多久可以打开(单位分钟)
	openCostCrystals = 0,				--打开锦囊需要消耗多少神器晶石
	
	--红装掉落(每个掉落池，都必定会进行掉落计算。每个)
	rewardEx = {
		--掉落池1
		[1] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Tactic_Normal",2,2}},
				{value = 30, reward = {"Tactic_Normal",5,5}},
				{value = 20, reward = {"Tactic_Normal",10,10}},
			},
		},
		
		--掉落池2
		[2] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Tactic_Normal",2,2}},
				{value = 30, reward = {"Tactic_Normal",5,5}},
				{value = 20, reward = {"Tactic_Normal",10,10}},
			},
		},
		
		--掉落池3
		[3] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Tactic_Normal",0,0}},
				{value = 25, reward = {"Tactic_Normal",2,2}},
				{value = 15, reward = {"Tactic_Normal",5,5}},
				{value = 10, reward = {"Tactic_Normal",10,10}},
			},
		},
		
	},
}

--宠物锦囊
_tab_chest[9922] = 
{
	openCost = 0,					--打开锦囊需要gamecoin
	openDelay = 0,					--获得宝箱后多久可以打开(单位分钟)
	openCostCrystals = 0,				--打开锦囊需要消耗多少神器晶石
	
	--红装掉落(每个掉落池，都必定会进行掉落计算。每个)
	rewardEx = {
		--掉落池1
		[1] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Pet_Normal",1,1}},
				{value = 30, reward = {"Pet_Normal",2,2}},
				{value = 20, reward = {"Pet_Normal",5,5}},
			},
		},
		
		--掉落池2
		[2] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Pet_Normal",1,1}},
				{value = 30, reward = {"Pet_Normal",2,2}},
				{value = 20, reward = {"Pet_Normal",5,5}},
			},
		},
		
		--掉落池3
		[3] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Pet_Normal",0,0}},
				{value = 25, reward = {"Pet_Normal",1,1}},
				{value = 15, reward = {"Pet_Normal",2,2}},
				{value = 10, reward = {"Pet_Normal",5,5}},
			},
		},
	},
}

--装备锦囊
_tab_chest[9923] = 
{
	openCost = 0,					--打开锦囊需要gamecoin
	openDelay = 0,					--获得宝箱后多久可以打开(单位分钟)
	openCostCrystals = 0,				--打开锦囊需要消耗多少神器晶石
	
	--红装掉落(每个掉落池，都必定会进行掉落计算。每个)
	rewardEx = {
		--掉落池1
		[1] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 45, reward = {"Equip_Normal",1,1}},
				{value = 33, reward = {"Equip_Normal2",1,1}},
				{value = 21, reward = {"Equip_Normal3",1,1}},
				{value = 1, reward = {"Equip_High",1,1}},
			},
		},
		
	},
}

--神器锦囊
_tab_chest[9925] = 
{
	openCost = 0,					--打开锦囊需要gamecoin
	openDelay = 0,					--获得宝箱后多久可以打开(单位分钟)
	openCostCrystals = 0,				--打开锦囊需要消耗多少神器晶石
	
	--红装掉落(每个掉落池，都必定会进行掉落计算。每个)
	rewardEx = {
		--掉落池1
		[1] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 62, reward = {"Equip_Normal2",1,1}},
				{value = 36, reward = {"Equip_Normal3",1,1}},
				{value = 2, reward = {"Equip_High",1,1}},
			},
		},
		--掉落池2
		[2] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Weapon_Normal",1,1}},
				{value = 30, reward = {"Weapon_Normal",2,2}},
				{value = 20, reward = {"Weapon_Normal",5,5}},
			},
		},
		--掉落池3
		[3] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 50, reward = {"Weapon_Normal",0,0}},
				{value = 25, reward = {"Weapon_Normal",1,1}},
				{value = 15, reward = {"Weapon_Normal",2,2}},
				{value = 10, reward = {"Weapon_Normal",5,5}},
			},
		},
		
	},
}

--宠物挖矿宝箱
_tab_chest[9926] = 
{
	openCost = 0,					--打开锦囊需要gamecoin
	openDelay = 0,					--获得宝箱后多久可以打开(单位分钟)
	openCostCrystals = 0,				--打开锦囊需要消耗多少神器晶石
	
	--红装掉落(每个掉落池，都必定会进行掉落计算。每个)
	rewardEx = {
		--掉落池1
		[1] = {
			tag = "Other",
			rollCount = 1, 
			pool = {
				totalValue = 100,
				{value = 20, reward = {"Weapon_Normal",1,1}},
				{value = 20, reward = {"Tactic_Normal",1,1}},
				{value = 20, reward = {"Pet_Normal",1,1}},
				{value = 20, reward = {"Chip_Wakuang",1,1}},
				{value = 5, reward = {"Weapon_Normal",2,2}},
				{value = 5, reward = {"Tactic_Normal",2,2}},
				{value = 5, reward = {"Pet_Normal",2,2}},
				{value = 5, reward = {"Chip_Wakuang",2,2}},
				
			},
		},
	},
}
