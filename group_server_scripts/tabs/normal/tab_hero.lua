hVar.tab_hero = {}
local _tab_hero = hVar.tab_hero

--=============================================================================================--
--英雄: 18001 - 18099
--=============================================================================================--
--TD-刘备
_tab_hero[18001] = {
	name = "刘备",
	talent = {
		{11002, 1, 3000,}, --{skillId, lv, cd}
		{11003, 1, 12000,}, --{skillId, lv, cd}
		--{11004, 1, 5000,}, --{skillId, lv, cd}
		--{11005, 1, 5000,}, --{skillId, lv, cd}
	},
	tactics = {1103}, --英雄战术技能
	
	--unlock = {},

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 100,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 100,		--对应将魂数量
			costSoulStone = 150,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 250,		--对应将魂数量
			costSoulStone = 200,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 450,		--对应将魂数量
			costSoulStone = 250,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}

--TD-关羽
_tab_hero[18002] =
{
	name = "关羽",
	talent = {
		{11012, 1, 9000,},
		{11013, 1, 10000,},
	--	{11014, 1, 15000,},
	--	{11015, 1, 15000,},
	},
	tactics = {1105},

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 100,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 100,		--对应将魂数量
			costSoulStone = 150,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 250,		--对应将魂数量
			costSoulStone = 200,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 450,		--对应将魂数量
			costSoulStone = 250,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}


--TD-张飞
_tab_hero[18003] = {
	
	name = "张飞",
	talent = {
		{11022, 1, 15000,},
		{11024, 1, 24000,},
	--	{11025, 1, 15000,},
	--	{11026, 1, 15000,},
	},
	tactics = {1104},

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 100,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 100,		--对应将魂数量
			costSoulStone = 150,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 250,		--对应将魂数量
			costSoulStone = 200,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 450,		--对应将魂数量
			costSoulStone = 250,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}

--TD-曹操
_tab_hero[18005] = {
	
	name = "曹操",
	talent = {
		{11052, 1, 30000,}, --{skillId, lv, cd}
		{11313, 1, 5000,}, --{skillId, lv, cd}--鞭策（15级技能）
	},
	tactics = {1106}, --英雄战术技能

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 100,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 100,		--对应将魂数量
			costSoulStone = 150,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 250,		--对应将魂数量
			costSoulStone = 200,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 450,		--对应将魂数量
			costSoulStone = 250,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},

}

--TD-太史慈
_tab_hero[18006] = {

	name = "太史慈",
	talent = {
		{11042, 1, 10000,}, --{skillId, lv, cd}
		{11314, 1, 7000,}, --{skillId, lv, cd} --问号技能(暂未开放)
	},
	tactics = {1107}, --英雄战术技能

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 200,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 200,		--对应将魂数量
			costSoulStone = 400,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 600,		--对应将魂数量
			costSoulStone = 600,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 1200,		--对应将魂数量
			costSoulStone = 800,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},

}

--TD 郭嘉
_tab_hero[18007] = {
	
	name = "郭嘉",
	talent = {
		{11062, 1, 15000,}, --{skillId, lv, cd}
		{11315, 1, 30000,}, --{skillId, lv, cd}
		--{11315, 1, 60000,}, --{skillId, lv, cd} --问号技能(暂未开放)
	},
	tactics = {1108}, --英雄战术技能

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 100,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 100,		--对应将魂数量
			costSoulStone = 200,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 300,		--对应将魂数量
			costSoulStone = 300,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 600,		--对应将魂数量
			costSoulStone = 400,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}


--TD-赵云
_tab_hero[18008] = {
	
	name = "赵云",
	talent = {
		{11082, 1, 30000,},
		{11129, 1, 9000,},
	},
	tactics = {1109},

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 100,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 100,		--对应将魂数量
			costSoulStone = 200,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 300,		--对应将魂数量
			costSoulStone = 300,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 600,		--对应将魂数量
			costSoulStone = 400,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}

--TD-夏侯惇
_tab_hero[18010] =
{
	name = "夏侯惇",
	talent = {
		{11086, 1, 15000,},
		{11317, 1, 15000,},--{skillId, lv, cd} --15级技能
	},
	tactics = {1110},

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 100,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 100,		--对应将魂数量
			costSoulStone = 150,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 250,		--对应将魂数量
			costSoulStone = 200,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 450,		--对应将魂数量
			costSoulStone = 250,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}

--TD-吕布
_tab_hero[18011] = {
	
	name = "吕布",
	talent = {
		{11101, 1, 10000,},
		{11318, 1, 10000,}, --{skillId, lv, cd} --15级技能
	},
	tactics = {1111},

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 200,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 200,		--对应将魂数量
			costSoulStone = 400,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 600,		--对应将魂数量
			costSoulStone = 600,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 1200,		--对应将魂数量
			costSoulStone = 800,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}

--TD-貂蝉
_tab_hero[18012] = {
	
	name = "貂蝉",
	talent = {
		{11112, 1, 0,},
		{11319, 1, 0,}, --{skillId, lv, cd} --15级技能
	},
	tactics = {1112},

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 200,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 200,		--对应将魂数量
			costSoulStone = 400,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 600,		--对应将魂数量
			costSoulStone = 600,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 1200,		--对应将魂数量
			costSoulStone = 800,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}

--TD-张辽
_tab_hero[18014] =
{
	name = "TD-张辽",
	talent = {
		{11122, 1, 5000,},
		{11320, 1, 20000,}, --{skillId, lv, cd} --15级技能
	},
	tactics = {1113},

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 100,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 100,		--对应将魂数量
			costSoulStone = 200,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 300,		--对应将魂数量
			costSoulStone = 300,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 600,		--对应将魂数量
			costSoulStone = 400,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}

--TD-许褚
_tab_hero[18015] =
{
	name = "许褚",
	talent = {
		{11123, 1, 5000,},
		{11321, 1, 0,}, --{skillId, lv, cd} --15级技
	},
	tactics = {1114},

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 100,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 100,		--对应将魂数量
			costSoulStone = 200,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 300,		--对应将魂数量
			costSoulStone = 300,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 600,		--对应将魂数量
			costSoulStone = 400,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}


--TD-典韦
_tab_hero[18016] =
{
	name = "典韦",
	talent = {
		{11127, 1, 7000,},
		{11322, 1, 5000,}, --{skillId, lv, cd} --15级技能
	},
	tactics = {1115},

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 200,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 200,		--对应将魂数量
			costSoulStone = 400,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 600,		--对应将魂数量
			costSoulStone = 600,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 1200,		--对应将魂数量
			costSoulStone = 800,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}



--TD-甘宁
_tab_hero[18017] = 
{
	name = "甘宁",
	talent = {
		{11135, 1, 10000,},
		{11136, 1, 10000,}, --{skillId, lv, cd} --15级技能
	},
	tactics = {1116},

	--甘宁
	unlock = {
		arenaUnlock = true,
		costSoulStone = 400,
	},

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 400,		--升至下一级需要将魂数量
			shopItemId = 290,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 400,		--对应将魂数量
			costSoulStone = 500,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 900,		--对应将魂数量
			costSoulStone = 600,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 1500,		--对应将魂数量
			costSoulStone = 700,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}



--TD-孙策
_tab_hero[18018] = 
{
	name = "孙策",
	talent = {
		{11350, 1, 9000,}, --{skillId, lv, cd}
		{11353, 1, 12000,}, --{skillId, lv, cd}
		--{11004, 1, 5000,}, --{skillId, lv, cd}
		--{11005, 1, 5000,}, --{skillId, lv, cd}
	},
	tactics = {1117}, --英雄战术技能

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 100,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 100,		--对应将魂数量
			costSoulStone = 150,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 250,		--对应将魂数量
			costSoulStone = 200,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 450,		--对应将魂数量
			costSoulStone = 250,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}




--TD-周瑜
_tab_hero[18019] = 
{
	name = "周瑜",
	talent = {
		{11370, 1, 12000,}, --{skillId, lv, cd}
		{11372, 1, 24000,}, --{skillId, lv, cd}
		--{11004, 1, 5000,}, --{skillId, lv, cd}
		--{11005, 1, 5000,}, --{skillId, lv, cd}
	},
	tactics = {1118}, --英雄战术技能

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 100,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 100,		--对应将魂数量
			costSoulStone = 150,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 250,		--对应将魂数量
			costSoulStone = 200,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 450,		--对应将魂数量
			costSoulStone = 250,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}

--TD-徐庶
_tab_hero[18020] = 
{
	name = "徐庶",
	talent = {
		{30039, 1, 10000,},
		{30041, 1, 0,},
	},
	tactics = {1119},

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 200,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 200,		--对应将魂数量
			costSoulStone = 400,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 600,		--对应将魂数量
			costSoulStone = 600,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 1200,		--对应将魂数量
			costSoulStone = 800,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}




--TD 诸葛亮
_tab_hero[18021] = 
{
	name = "诸葛亮",
	talent = {
		{31102, 1, 10000,}, --{skillId, lv, cd}
		{31104, 1, 12000,}, --{skillId, lv, cd}
		--{11315, 1, 60000,}, --{skillId, lv, cd} --问号技能(暂未开放)
	},
	tactics = {1120}, --英雄战术技能

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 200,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 200,		--对应将魂数量
			costSoulStone = 400,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 600,		--对应将魂数量
			costSoulStone = 600,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 1200,		--对应将魂数量
			costSoulStone = 800,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}

--TD 小乔
_tab_hero[18022] = 
{
	name = "小乔",
	talent = {
		{11360, 1, 0,}, --{skillId, lv, cd}
		{11374, 1, 0,}, --{skillId, lv, cd}
	},
	tactics = {1121}, --英雄战术技能

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 400,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 400,		--对应将魂数量
			costSoulStone = 500,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 900,		--对应将魂数量
			costSoulStone = 600,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 1500,		--对应将魂数量
			costSoulStone = 700,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}


--TD 黄月英
_tab_hero[18023] = 
{
	name = "黄月英",
	talent = {
		{11386, 1, 0,}, --{skillId, lv, cd}
		{11388, 1, 0,}, --{skillId, lv, cd}
	},
	tactics = {1124}, --英雄战术技能
	
	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 400,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 400,		--对应将魂数量
			costSoulStone = 500,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 900,		--对应将魂数量
			costSoulStone = 600,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 1500,		--对应将魂数量
			costSoulStone = 700,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}


--TD-孙权
_tab_hero[18024] = 
{
	talent = {
			{11377, 1, 25000,}, --{skillId, lv, cd}
			{11379, 1, 12000,}, --{skillId, lv, cd}
	},
	tactics = {1122}, --英雄战术技能
	
	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 400,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 400,		--对应将魂数量
			costSoulStone = 500,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 900,		--对应将魂数量
			costSoulStone = 600,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 1500,		--对应将魂数量
			costSoulStone = 700,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}

--TD-庞统
_tab_hero[18025] = 
{
	name = "庞统",
	talent = {
		{31116, 1, 10000,}, --{skillId, lv, cd}
		{31117, 1, 30000,}, --{skillId, lv, cd}
	},
	tactics = {1123}, --英雄战术技能
	--庞统解锁
	unlock = {
		arenaUnlock = true,
		costSoulStone = 400,
	},
	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 400,		--升至下一级需要将魂数量
			shopItemId = 290,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 400,		--对应将魂数量
			costSoulStone = 500,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 900,		--对应将魂数量
			costSoulStone = 600,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 1500,		--对应将魂数量
			costSoulStone = 700,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}


--TD 董卓
_tab_hero[18027] = 
{
	name = "董卓",
	talent = {
		{11393, 1, 9000,},
		{11394, 1, 0,},
	},
	tactics = {1125}, --英雄战术技能
	
	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 400,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 400,		--对应将魂数量
			costSoulStone = 500,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 900,		--对应将魂数量
			costSoulStone = 600,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 1500,		--对应将魂数量
			costSoulStone = 700,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}

--TD-荀彧
_tab_hero[18028] = {
	
	name = "荀彧",
	talent = {
		{11407, 1, 9000,}, --{skillId, lv, cd}
		{11408, 1, 12000,}, --{skillId, lv, cd}
	},
	tactics = {1126}, --英雄战术技能

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 200,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 200,		--对应将魂数量
			costSoulStone = 400,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 600,		--对应将魂数量
			costSoulStone = 600,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 1200,		--对应将魂数量
			costSoulStone = 800,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}

--TD-贾诩
_tab_hero[18029] = {
	
	name = "贾诩",
	talent = {
		{11411, 1, 7000,}, --{skillId, lv, cd}
		{11412, 1, 16000,}, --{skillId, lv, cd}
	},
	tactics = {1128}, --英雄战术技能

	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 200,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 200,		--对应将魂数量
			costSoulStone = 400,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 600,		--对应将魂数量
			costSoulStone = 600,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 1200,		--对应将魂数量
			costSoulStone = 800,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}

--TD 孙尚香
_tab_hero[18031] = 
{
	name = "孙尚香",
	talent = {
		{11415, 1, 0,},
		{11416, 1, 0,},
	},
	tactics = {1129}, --英雄战术技能
	
	starInfo = {
		--1星
		[1] = {
			maxLv = 10,			--等级上限
			unlockSkillNum = 1,		--解锁技能数量
			toSoulStone = 0,		--对应将魂数量
			costSoulStone = 400,		--升至下一级需要将魂数量
			shopItemId = 291,
		},
		--2星
		[2] = {
			maxLv = 15,			--等级上限
			unlockSkillNum = 2,		--解锁技能数量
			toSoulStone = 400,		--对应将魂数量
			costSoulStone = 500,		--升至下一级需要将魂数量
			shopItemId = 292,
		},
		--3星
		[3] = {
			maxLv = 20,			--等级上限
			unlockSkillNum = 3,		--解锁技能数量
			toSoulStone = 900,		--对应将魂数量
			costSoulStone = 600,		--升至下一级需要将魂数量
			shopItemId = 293,
		},
		--4星
		[4] = {
			maxLv = 25,			--等级上限
			unlockSkillNum = 4,		--解锁技能数量
			toSoulStone = 1500,		--对应将魂数量
			costSoulStone = 700,		--升至下一级需要将魂数量(最高星级时这里也要填，只是为了界面显示用)
			--shopItemId = 294,		--升至下一级的商品Id(最高星级时这里不填)
		},
	},
}