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