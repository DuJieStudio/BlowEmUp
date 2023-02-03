hVar.tab_treasure = {}
local _tab_treasure = hVar.tab_treasure

--用于界面展示排序
hVar.tab_treasureEx =
{
	1,2,3,4,5,
	6,7,8,9,10,
	11,12,13,14,15,
	16,17,18,19,20,
	21,
}


--孟德新编
_tab_treasure[1] = {
	name = "孟德新编",
	icon = "misc/treasure/treasure_01.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 5,
	debrisId = 10801, --孟德新编碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.PVP_WINCOUNT_CAOCAO, --竞技场使用曹操胜利场次
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 2,},
					{attr = "atk", value = 1,},
				},
				attrSkill = {},
				addHero = {18005,}, --曹操
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_10_CAOCAO, --群英阁10+难度使用曹操通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 2,},
					{attr = "def_magic", value = 1,},
				},
				attrSkill = {},
				addHero = {18005,}, --曹操
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_WEI, --魏国英雄总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 1,},
				},
				attrSkill = {},
				addHero = {18005,}, --曹操
				addTower = {},
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.PVP_WINCOUNT_CAOCAO, --竞技场使用曹操胜利场次
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 4,},
					{attr = "atk", value = 2,},
				},
				attrSkill = {},
				addHero = {18005,}, --曹操
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_10_CAOCAO, --群英阁10+难度使用曹操通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 4,},
					{attr = "def_magic", value = 2,},
				},
				attrSkill = {},
				addHero = {18005,}, --曹操
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_WEI, --魏国英雄总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 2,},
				},
				attrSkill = {},
				addHero = {18005,}, --曹操
				addTower = {},
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.PVP_WINCOUNT_CAOCAO, --竞技场使用曹操胜利场次
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 6,},
					{attr = "atk", value = 3,},
				},
				attrSkill = {},
				addHero = {18005,}, --曹操
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_10_CAOCAO, --群英阁10+难度使用曹操通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 6,},
					{attr = "def_magic", value = 3,},
				},
				attrSkill = {},
				addHero = {18005,}, --曹操
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_WEI, --魏国英雄总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 3,},
				},
				attrSkill = {},
				addHero = {18005,}, --曹操
				addTower = {},
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.PVP_WINCOUNT_CAOCAO, --竞技场使用曹操胜利场次
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 8,},
					{attr = "atk", value = 4,},
				},
				attrSkill = {},
				addHero = {18005,}, --曹操
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_10_CAOCAO, --群英阁10+难度使用曹操通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 8,},
					{attr = "def_magic", value = 4,},
				},
				attrSkill = {},
				addHero = {18005,}, --曹操
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_WEI, --魏国英雄总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 4,},
				},
				attrSkill = {},
				addHero = {18005,}, --曹操
				addTower = {},
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.PVP_WINCOUNT_CAOCAO, --竞技场使用曹操胜利场次
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 10,},
					{attr = "atk", value = 5,},
				},
				attrSkill = {},
				addHero = {18005,}, --曹操
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_10_CAOCAO, --群英阁10+难度使用曹操通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 10,},
					{attr = "def_magic", value = 5,},
				},
				attrSkill = {},
				addHero = {18005,}, --曹操
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_WEI, --魏国英雄总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 5,},
				},
				attrSkill = {},
				addHero = {18005,}, --曹操
				addTower = {},
			},
		},
	},
}

--英雄救美
_tab_treasure[2] = {
	name = "英雄救美",
	icon = "misc/treasure/treasure_02.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 5,
	debrisId = 10802, --英雄救美碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_DIFFICULT, --铜雀台通关噩梦难度次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 2,},
					{attr = "def_physic", value = 1,},
				},
				attrSkill = {},
				addHero = {18023, 18012, 18022, 18031, 18046,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬
				addTower = {},
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_DIFFICULT, --铜雀台通关噩梦难度次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 4,},
					{attr = "def_physic", value = 2,},
				},
				attrSkill = {},
				addHero = {18023, 18012, 18022, 18031, 18046,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬
				addTower = {},
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_DIFFICULT, --铜雀台通关噩梦难度次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 6,},
					{attr = "def_physic", value = 3,},
				},
				attrSkill = {},
				addHero = {18023, 18012, 18022, 18031, 18046,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬
				addTower = {},
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_DIFFICULT, --铜雀台通关噩梦难度次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 8,},
					{attr = "def_physic", value = 4,},
				},
				attrSkill = {},
				addHero = {18023, 18012, 18022, 18031, 18046,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬
				addTower = {},
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_DIFFICULT, --铜雀台通关噩梦难度次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 10,},
					{attr = "def_physic", value = 5,},
				},
				attrSkill = {},
				addHero = {18023, 18012, 18022, 18031, 18046,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬
				addTower = {},
			},
		},
	},
}

--桃园香炉
_tab_treasure[3] = {
	name = "桃园香炉",
	icon = "misc/treasure/treasure_03.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.BLUE, --品质
	maxStar = 5,
	debrisId = 10803, --桃园香炉碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.ENDLESS_WINCOUNT_LIUGUANZHANG, --无尽试炼使用刘关张通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 2,},
					{attr = "atk", value = 1,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18003,}, --刘备、关羽、张飞
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.PVP_WINCOUNT_LIUGUANZHANG, --竞技场使用刘关张胜利场次
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 2,},
					{attr = "atk", value = 1,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18003,}, --刘备、关羽、张飞
				addTower = {},
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.ENDLESS_WINCOUNT_LIUGUANZHANG, --无尽试炼使用刘关张通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 4,},
					{attr = "atk", value = 2,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18003,}, --刘备、关羽、张飞
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.PVP_WINCOUNT_LIUGUANZHANG, --竞技场使用刘关张胜利场次
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 4,},
					{attr = "atk", value = 2,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18003,}, --刘备、关羽、张飞
				addTower = {},
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.ENDLESS_WINCOUNT_LIUGUANZHANG, --无尽试炼使用刘关张通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 6,},
					{attr = "atk", value = 3,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18003,}, --刘备、关羽、张飞
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.PVP_WINCOUNT_LIUGUANZHANG, --竞技场使用刘关张胜利场次
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 6,},
					{attr = "atk", value = 3,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18003,}, --刘备、关羽、张飞
				addTower = {},
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.ENDLESS_WINCOUNT_LIUGUANZHANG, --无尽试炼使用刘关张通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 8,},
					{attr = "atk", value = 4,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18003,}, --刘备、关羽、张飞
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.PVP_WINCOUNT_LIUGUANZHANG, --竞技场使用刘关张胜利场次
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 8,},
					{attr = "atk", value = 4,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18003,}, --刘备、关羽、张飞
				addTower = {},
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.ENDLESS_WINCOUNT_LIUGUANZHANG, --无尽试炼使用刘关张通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 10,},
					{attr = "atk", value = 5,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18003,}, --刘备、关羽、张飞
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.PVP_WINCOUNT_LIUGUANZHANG, --竞技场使用刘关张胜利场次
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 10,},
					{attr = "atk", value = 5,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18003,}, --刘备、关羽、张飞
				addTower = {},
			},
		},
	},
}

--服部半藏面罩
_tab_treasure[4] = {
	name = "服部半藏面罩",
	icon = "misc/treasure/treasure_04.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 5,
	debrisId = 10804, --服部半藏面罩碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_EAZY_DEATH1, --铜雀台最多死1次通关简单难度次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "move_speed", value = 2,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕
				addTower = {},
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_EAZY_DEATH1, --铜雀台最多死1次通关简单难度次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "move_speed", value = 4,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕
				addTower = {},
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_EAZY_DEATH1, --铜雀台最多死1次通关简单难度次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "move_speed", value = 6,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕
				addTower = {},
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_EAZY_DEATH1, --铜雀台最多死1次通关简单难度次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "move_speed", value = 8,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕
				addTower = {},
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_EAZY_DEATH1, --铜雀台最多死1次通关简单难度次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "move_speed", value = 10,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕
				addTower = {},
			},
		},
	},
}

--神叼侠侣
_tab_treasure[5] = {
	name = "神叼侠侣",
	icon = "misc/treasure/treasure_05.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 5,
	debrisId = 10805, --神叼侠侣碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_HUANGYUEYING, --魔塔杀阵使用诸葛亮黄月英通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 2,},
				},
				attrSkill = {},
				addHero = {18021, 18023,}, --诸葛亮, 黄月英
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.ENDLESS_WINCOUNT_LVBU_DIAOCHAN, --无尽试炼使用吕布貂蝉通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 2,},
				},
				attrSkill = {},
				addHero = {18011, 18012,}, --吕布, 貂蝉
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.PVP_WINCOUNT_ZHOUYUXIAOQIAO, --竞技场使用周瑜小乔胜利场次
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 2,},
				},
				attrSkill = {},
				addHero = {18019, 18022,}, --周瑜, 小乔
				addTower = {},
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_HUANGYUEYING, --魔塔杀阵使用诸葛亮黄月英通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 4,},
				},
				attrSkill = {},
				addHero = {18021, 18023,}, --诸葛亮, 黄月英
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.ENDLESS_WINCOUNT_LVBU_DIAOCHAN, --无尽试炼使用吕布貂蝉通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 4,},
				},
				attrSkill = {},
				addHero = {18011, 18012,}, --吕布, 貂蝉
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.PVP_WINCOUNT_ZHOUYUXIAOQIAO, --竞技场使用周瑜小乔胜利场次
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 4,},
				},
				attrSkill = {},
				addHero = {18019, 18022,}, --周瑜, 小乔
				addTower = {},
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_HUANGYUEYING, --魔塔杀阵使用诸葛亮黄月英通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 6,},
				},
				attrSkill = {},
				addHero = {18021, 18023,}, --诸葛亮, 黄月英
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.ENDLESS_WINCOUNT_LVBU_DIAOCHAN, --无尽试炼使用吕布貂蝉通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 6,},
				},
				attrSkill = {},
				addHero = {18011, 18012,}, --吕布, 貂蝉
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.PVP_WINCOUNT_ZHOUYUXIAOQIAO, --竞技场使用周瑜小乔胜利场次
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 6,},
				},
				attrSkill = {},
				addHero = {18019, 18022,}, --周瑜, 小乔
				addTower = {},
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_HUANGYUEYING, --魔塔杀阵使用诸葛亮黄月英通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 8,},
				},
				attrSkill = {},
				addHero = {18021, 18023,}, --诸葛亮, 黄月英
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.ENDLESS_WINCOUNT_LVBU_DIAOCHAN, --无尽试炼使用吕布貂蝉通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 8,},
				},
				attrSkill = {},
				addHero = {18011, 18012,}, --吕布, 貂蝉
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.PVP_WINCOUNT_ZHOUYUXIAOQIAO, --竞技场使用周瑜小乔胜利场次
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 8,},
				},
				attrSkill = {},
				addHero = {18019, 18022,}, --周瑜, 小乔
				addTower = {},
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_HUANGYUEYING, --魔塔杀阵使用诸葛亮黄月英通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 10,},
				},
				attrSkill = {},
				addHero = {18021, 18023,}, --诸葛亮, 黄月英
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.ENDLESS_WINCOUNT_LVBU_DIAOCHAN, --无尽试炼使用吕布貂蝉通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 10,},
				},
				attrSkill = {},
				addHero = {18011, 18012,}, --吕布, 貂蝉
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.PVP_WINCOUNT_ZHOUYUXIAOQIAO, --竞技场使用周瑜小乔胜利场次
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 10,},
				},
				attrSkill = {},
				addHero = {18019, 18022,}, --周瑜, 小乔
				addTower = {},
			},
		},
	},
}

--拿破仑选集
_tab_treasure[6] = {
	name = "拿破仑选集",
	icon = "misc/treasure/treasure_06.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.BLUE, --品质
	maxStar = 5,
	debrisId = 10806, --拿破仑选集碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_10_BUILD_JUPAOTA_10, --群英阁10+难度建造10个巨炮塔抽到巨炮精研
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 1,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1012,}, --巨炮塔
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_10_BUILD_JUPAOTA_10, --群英阁10+难度建造10个巨炮塔抽到巨炮精研
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 2,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1012,}, --巨炮塔
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_10_BUILD_JUPAOTA_10, --群英阁10+难度建造10个巨炮塔抽到巨炮精研
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 3,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1012,}, --巨炮塔
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_10_BUILD_JUPAOTA_10, --群英阁10+难度建造10个巨炮塔抽到巨炮精研
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 4,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1012,}, --巨炮塔
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_10_BUILD_JUPAOTA_10, --群英阁10+难度建造10个巨炮塔抽到巨炮精研
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 5,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1012,}, --巨炮塔
			},
		},
	},
}

--兵临城下
_tab_treasure[7] = {
	name = "兵临城下",
	icon = "misc/treasure/treasure_07.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.BLUE, --品质
	maxStar = 5,
	debrisId = 10807, --兵临城下碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_5_BUILD_JUJITA_10, --群英阁5+难度建造10个狙击塔抽到全屏卡
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "atk_speed", value = 1,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1017,}, --狙击塔
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_5_BUILD_JUJITA_10, --群英阁5+难度建造10个狙击塔抽到全屏卡
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "atk_speed", value = 2,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1017,}, --狙击塔
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_5_BUILD_JUJITA_10, --群英阁5+难度建造10个狙击塔抽到全屏卡
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "atk_speed", value = 3,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1017,}, --狙击塔
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_5_BUILD_JUJITA_10, --群英阁5+难度建造10个狙击塔抽到全屏卡
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "atk_speed", value = 4,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1017,}, --狙击塔
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_5_BUILD_JUJITA_10, --群英阁5+难度建造10个狙击塔抽到全屏卡
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "atk_speed", value = 5,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1017,}, --狙击塔
			},
		},
	},
}

--龙凤灰袍
_tab_treasure[8] = {
	name = "龙凤灰袍",
	icon = "misc/treasure/treasure_08.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 5,
	debrisId = 10808, --龙凤灰袍碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_PANGTONG, --魔塔杀阵使用诸葛亮庞统通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 1,},
				},
				attrSkill = {},
				addHero = {18021, 18025,}, --诸葛亮, 庞统
				addTower = {},
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_PANGTONG, --魔塔杀阵使用诸葛亮庞统通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 2,},
				},
				attrSkill = {},
				addHero = {18021, 18025,}, --诸葛亮, 庞统
				addTower = {},
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_PANGTONG, --魔塔杀阵使用诸葛亮庞统通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 3,},
				},
				attrSkill = {},
				addHero = {18021, 18025,}, --诸葛亮, 庞统
				addTower = {},
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_PANGTONG, --魔塔杀阵使用诸葛亮庞统通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 4,},
				},
				attrSkill = {},
				addHero = {18021, 18025,}, --诸葛亮, 庞统
				addTower = {},
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_PANGTONG, --魔塔杀阵使用诸葛亮庞统通关次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 5,},
				},
				attrSkill = {},
				addHero = {18021, 18025,}, --诸葛亮, 庞统
				addTower = {},
			},
		},
	},
}

--莫邪之血
_tab_treasure[9] = {
	name = "莫邪之血",
	icon = "misc/treasure/treasure_09.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.BLUE, --品质
	maxStar = 5,
	debrisId = 10809, --莫邪之血碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.EQUIP_XILIAN_LOCK, --锁孔洗炼红装
				attrCountDivisor = 100, --加属性次数计算的除数
				attrCountMax = 2000, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 1,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕
				addTower = {},
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.EQUIP_XILIAN_LOCK, --锁孔洗炼红装
				attrCountDivisor = 100, --加属性次数计算的除数
				attrCountMax = 2000, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 2,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕
				addTower = {},
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.EQUIP_XILIAN_LOCK, --锁孔洗炼红装
				attrCountDivisor = 100, --加属性次数计算的除数
				attrCountMax = 2000, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 3,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕
				addTower = {},
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.EQUIP_XILIAN_LOCK, --锁孔洗炼红装
				attrCountDivisor = 100, --加属性次数计算的除数
				attrCountMax = 2000, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 3,},
					{attr = "def_magic", value = 1,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕
				addTower = {},
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.EQUIP_XILIAN_LOCK, --锁孔洗炼红装
				attrCountDivisor = 100, --加属性次数计算的除数
				attrCountMax = 2000, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 3,},
					{attr = "def_magic", value = 2,},
				},
				attrSkill = {},
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕
				addTower = {},
			},
		},
	},
}

--五虎上将令
_tab_treasure[10] = {
	name = "五虎上将令",
	icon = "misc/treasure/treasure_10.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 5,
	debrisId = 10810, --五虎上将令碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 2,},
				},
				attrSkill = {},
				addHero = {18002, 18003, 18008, 18033, 18032,}, --关羽, 张飞, 赵云, 马超, 黄忠
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_DIFFICULT_USE_WUHU, --铜雀台使用五虎上将通关噩梦难度次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 2,},
				},
				attrSkill = {},
				addHero = {18002, 18003, 18008, 18033, 18032,}, --关羽, 张飞, 赵云, 马超, 黄忠
				addTower = {},
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 4,},
				},
				attrSkill = {},
				addHero = {18002, 18003, 18008, 18033, 18032,}, --关羽, 张飞, 赵云, 马超, 黄忠
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_DIFFICULT_USE_WUHU, --铜雀台使用五虎上将通关噩梦难度次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 4,},
				},
				attrSkill = {},
				addHero = {18002, 18003, 18008, 18033, 18032,}, --关羽, 张飞, 赵云, 马超, 黄忠
				addTower = {},
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 6,},
				},
				attrSkill = {},
				addHero = {18002, 18003, 18008, 18033, 18032,}, --关羽, 张飞, 赵云, 马超, 黄忠
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_DIFFICULT_USE_WUHU, --铜雀台使用五虎上将通关噩梦难度次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 6,},
				},
				attrSkill = {},
				addHero = {18002, 18003, 18008, 18033, 18032,}, --关羽, 张飞, 赵云, 马超, 黄忠
				addTower = {},
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 8,},
				},
				attrSkill = {},
				addHero = {18002, 18003, 18008, 18033, 18032,}, --关羽, 张飞, 赵云, 马超, 黄忠
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_DIFFICULT_USE_WUHU, --铜雀台使用五虎上将通关噩梦难度次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 8,},
				},
				attrSkill = {},
				addHero = {18002, 18003, 18008, 18033, 18032,}, --关羽, 张飞, 赵云, 马超, 黄忠
				addTower = {},
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 10,},
				},
				attrSkill = {},
				addHero = {18002, 18003, 18008, 18033, 18032,}, --关羽, 张飞, 赵云, 马超, 黄忠
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_DIFFICULT_USE_WUHU, --铜雀台使用五虎上将通关噩梦难度次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 10,},
				},
				attrSkill = {},
				addHero = {18002, 18003, 18008, 18033, 18032,}, --关羽, 张飞, 赵云, 马超, 黄忠
				addTower = {},
			},
		},
	},
}

--建筑师证书
_tab_treasure[11] = {
	name = "建筑师证书",
	icon = "misc/treasure/treasure_11.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 5,
	debrisId = 10811, --建筑师证书碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.TOWER_COUNT_LV5, --五级塔总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "build_cost", value = -1,},
					{attr = "atk_radius", value = 1,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1022, 1023,}, --擂鼓塔, 地刺塔
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.TOWER_COUNT_LV5, --五级塔总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "build_cost", value = -2,},
					{attr = "atk_radius", value = 2,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1022, 1023,}, --擂鼓塔, 地刺塔
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.TOWER_COUNT_LV5, --五级塔总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "build_cost", value = -3,},
					{attr = "atk_radius", value = 3,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1022, 1023,}, --擂鼓塔, 地刺塔
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.TOWER_COUNT_LV5, --五级塔总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "build_cost", value = -4,},
					{attr = "atk_radius", value = 4,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1022, 1023,}, --擂鼓塔, 地刺塔
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.TOWER_COUNT_LV5, --五级塔总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "build_cost", value = -5,},
					{attr = "atk_radius", value = 5,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1022, 1023,}, --擂鼓塔, 地刺塔
			},
		},
	},
}

--战功金腰带
_tab_treasure[12] = {
	name = "战功金腰带",
	icon = "misc/treasure/treasure_12.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.BLUE, --品质
	maxStar = 5,
	debrisId = 10812, --战功金腰带碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.OPEN_PVP_CHEST, --开启战功锦囊
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 2,},
				},
				attrSkill = {},
				addHero = {18008, 18023, 18016, 18012, 18031, 18006, 18035, 18017, 18032,}, --赵云, 黄月英, 典韦, 貂蝉, 孙尚香, 太史慈, 陆逊, 甘宁, 黄忠
				addTower = {},
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.OPEN_PVP_CHEST, --开启战功锦囊
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 4,},
				},
				attrSkill = {},
				addHero = {18008, 18023, 18016, 18012, 18031, 18006, 18035, 18017, 18032,}, --赵云, 黄月英, 典韦, 貂蝉, 孙尚香, 太史慈, 陆逊, 甘宁, 黄忠
				addTower = {},
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.OPEN_PVP_CHEST, --开启战功锦囊
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 6,},
				},
				attrSkill = {},
				addHero = {18008, 18023, 18016, 18012, 18031, 18006, 18035, 18017, 18032,}, --赵云, 黄月英, 典韦, 貂蝉, 孙尚香, 太史慈, 陆逊, 甘宁, 黄忠
				addTower = {},
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.OPEN_PVP_CHEST, --开启战功锦囊
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 8,},
				},
				attrSkill = {},
				addHero = {18008, 18023, 18016, 18012, 18031, 18006, 18035, 18017, 18032,}, --赵云, 黄月英, 典韦, 貂蝉, 孙尚香, 太史慈, 陆逊, 甘宁, 黄忠
				addTower = {},
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.OPEN_PVP_CHEST, --开启战功锦囊
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 100, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 10,},
				},
				attrSkill = {},
				addHero = {18008, 18023, 18016, 18012, 18031, 18006, 18035, 18017, 18032,}, --赵云, 黄月英, 典韦, 貂蝉, 孙尚香, 太史慈, 陆逊, 甘宁, 黄忠
				addTower = {},
			},
		},
	},
}

--战斗天使
_tab_treasure[13] = {
	name = "战斗天使",
	icon = "misc/treasure/treasure_13.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.BLUE, --品质
	maxStar = 5,
	debrisId = 10813, --战斗天使碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_FEMALE, --女性英雄总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 3,},
				},
				attrSkill = {},
				addHero = {18023, 18012, 18022, 18031, 18046,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬
				addTower = {},
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_FEMALE, --女性英雄总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 5,},
				},
				attrSkill = {},
				addHero = {18023, 18012, 18022, 18031, 18046,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬
				addTower = {},
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_FEMALE, --女性英雄总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 7,},
				},
				attrSkill = {},
				addHero = {18023, 18012, 18022, 18031, 18046,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬
				addTower = {},
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_FEMALE, --女性英雄总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 10,},
				},
				attrSkill = {},
				addHero = {18023, 18012, 18022, 18031, 18046,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬
				addTower = {},
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_FEMALE, --女性英雄总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 15,},
				},
				attrSkill = {},
				addHero = {18023, 18012, 18022, 18031, 18046,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬
				addTower = {},
			},
		},
	},
}

--铁人之心
_tab_treasure[14] = {
	name = "铁人之心",
	icon = "misc/treasure/treasure_14.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.BLUE, --品质
	maxStar = 5,
	debrisId = 10814, --铁人之心碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_PURPLECARD_NUM, --群英阁、人族无敌胜利抽到紫卡数量
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 200, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 1,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1016,}, --天雷塔
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_PURPLECARD_NUM, --群英阁、人族无敌胜利抽到紫卡数量
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 200, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 2,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1016,}, --天雷塔
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_PURPLECARD_NUM, --群英阁、人族无敌胜利抽到紫卡数量
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 200, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 3,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1016,}, --天雷塔
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_PURPLECARD_NUM, --群英阁、人族无敌胜利抽到紫卡数量
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 200, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 4,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1016,}, --天雷塔
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_PURPLECARD_NUM, --群英阁、人族无敌胜利抽到紫卡数量
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 200, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 5,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1016,}, --天雷塔
			},
		},
	},
}

--神行鞭
_tab_treasure[15] = {
	name = "神行鞭",
	icon = "misc/treasure/treasure_15.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 5,
	debrisId = 10815, --神行鞭碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.EQUIP_COUNT_MOUNT_SLOT4, --累计获得4孔坐骑数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = 10, --最大统计次数
				attrAdd =
				{
					{attr = "move_speed", value = 1,},
				},
				attrSkill = {},
				addHero = {"ALL",}, --全体英雄
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "move_speed", value = 1,},
				},
				attrSkill = {},
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获
				addTower = {},
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.EQUIP_COUNT_MOUNT_SLOT4, --累计获得4孔坐骑数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = 20, --最大统计次数
				attrAdd =
				{
					{attr = "move_speed", value = 1,},
				},
				attrSkill = {},
				addHero = {"ALL",}, --全体英雄
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "move_speed", value = 2,},
				},
				attrSkill = {},
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获
				addTower = {},
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.EQUIP_COUNT_MOUNT_SLOT4, --累计获得4孔坐骑数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = 30, --最大统计次数
				attrAdd =
				{
					{attr = "move_speed", value = 1,},
				},
				attrSkill = {},
				addHero = {"ALL",}, --全体英雄
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "move_speed", value = 3,},
				},
				attrSkill = {},
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获
				addTower = {},
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.EQUIP_COUNT_MOUNT_SLOT4, --累计获得4孔坐骑数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = 40, --最大统计次数
				attrAdd =
				{
					{attr = "move_speed", value = 1,},
				},
				attrSkill = {},
				addHero = {"ALL",}, --全体英雄
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "move_speed", value = 4,},
				},
				attrSkill = {},
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获
				addTower = {},
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.EQUIP_COUNT_MOUNT_SLOT4, --累计获得4孔坐骑数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "move_speed", value = 1,},
				},
				attrSkill = {},
				addHero = {"ALL",}, --全体英雄
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "move_speed", value = 5,},
				},
				attrSkill = {},
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获
				addTower = {},
			},
		},
	},
}

--朱雀信条
_tab_treasure[16] = {
	name = "朱雀信条",
	icon = "misc/treasure/treasure_16.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 5,
	debrisId = 10816, --朱雀信条碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.CHAPTER_UNLOCKED_NUM, --解锁章节总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 3,},
				},
				attrSkill = {},
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬
				addTower = {},
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.CHAPTER_UNLOCKED_NUM, --解锁章节总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 5,},
				},
				attrSkill = {},
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬
				addTower = {},
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.CHAPTER_UNLOCKED_NUM, --解锁章节总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 7,},
				},
				attrSkill = {},
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬
				addTower = {},
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.CHAPTER_UNLOCKED_NUM, --解锁章节总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 10,},
				},
				attrSkill = {},
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬
				addTower = {},
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.CHAPTER_UNLOCKED_NUM, --解锁章节总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 15,},
				},
				attrSkill = {},
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬
				addTower = {},
			},
		},
	},
}

--主公玉玺
_tab_treasure[17] = {
	name = "主公玉玺",
	icon = "misc/treasure/treasure_17.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 5,
	debrisId = 10817, --主公玉玺碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 1,},
				},
				attrSkill = {},
				addHero = {18001,18005,18024,}, --刘备、曹操、孙权
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_LV15, --解锁章节总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 2,},
				},
				attrSkill = {},
				addHero = {18001,18005,18024,}, --刘备、曹操、孙权
				addTower = {},
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 2,},
				},
				attrSkill = {},
				addHero = {18001,18005,18024,}, --刘备、曹操、孙权
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_LV15, --解锁章节总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 3,},
				},
				attrSkill = {},
				addHero = {18001,18005,18024,}, --刘备、曹操、孙权
				addTower = {},
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 3,},
				},
				attrSkill = {},
				addHero = {18001,18005,18024,}, --刘备、曹操、孙权
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_LV15, --解锁章节总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 5,},
				},
				attrSkill = {},
				addHero = {18001,18005,18024,}, --刘备、曹操、孙权
				addTower = {},
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 4,},
				},
				attrSkill = {},
				addHero = {18001,18005,18024,}, --刘备、曹操、孙权
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_LV15, --解锁章节总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "move_speed", value = 6,},
				},
				attrSkill = {},
				addHero = {18001,18005,18024,}, --刘备、曹操、孙权
				addTower = {},
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 5,},
				},
				attrSkill = {},
				addHero = {18001,18005,18024,}, --刘备、曹操、孙权
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_LV15, --解锁章节总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 7,},
				},
				attrSkill = {},
				addHero = {18001,18005,18024,}, --刘备、曹操、孙权
				addTower = {},
			},
		},
	},
}

--屯田令牌
_tab_treasure[18] = {
	name = "屯田令牌",
	icon = "misc/treasure/treasure_18.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 5,
	debrisId = 10818, --屯田令牌碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.CONSUME_GAMECOIN_TOTALNUM, --累计消耗游戏币
				attrCountDivisor = 1000, --加属性次数计算的除数
				attrCountMax = 10000, --最大统计次数
				attrAdd =
				{
					--
				},
				attrSkill = {},
				addHero = {},
				addTower = {},
				addGoldPerWave = 10, --每波加金币
			},
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					--
				},
				attrSkill = --添加的技能
				{
					{skillId = 33708, skillLv = 1,}, --加钱技能
					{skillId = 33709, skillLv = 1,}, --加光环技能
				},
				addHero = {},
				addTower = {1020,}, --粮仓
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.CONSUME_GAMECOIN_TOTALNUM, --累计消耗游戏币
				attrCountDivisor = 1000, --加属性次数计算的除数
				attrCountMax = 10000, --最大统计次数
				attrAdd =
				{
					--
				},
				attrSkill = {},
				addHero = {},
				addTower = {},
				addGoldPerWave = 15, --每波加金币
			},
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					--
				},
				attrSkill = --添加的技能
				{
					{skillId = 33708, skillLv = 1,}, --加钱技能
					{skillId = 33709, skillLv = 2,}, --加光环技能
				},
				addHero = {},
				addTower = {1020,}, --粮仓
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.CONSUME_GAMECOIN_TOTALNUM, --累计消耗游戏币
				attrCountDivisor = 1000, --加属性次数计算的除数
				attrCountMax = 10000, --最大统计次数
				attrAdd =
				{
					--
				},
				attrSkill = {},
				addHero = {},
				addTower = {},
				addGoldPerWave = 20, --每波加金币
			},
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					--
				},
				attrSkill = --添加的技能
				{
					{skillId = 33708, skillLv = 1,}, --加钱技能
					{skillId = 33709, skillLv = 3,}, --加光环技能
				},
				addHero = {},
				addTower = {1020,}, --粮仓
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.CONSUME_GAMECOIN_TOTALNUM, --累计消耗游戏币
				attrCountDivisor = 1000, --加属性次数计算的除数
				attrCountMax = 10000, --最大统计次数
				attrAdd =
				{
					--
				},
				attrSkill = {},
				addHero = {},
				addTower = {},
				addGoldPerWave = 25, --每波加金币
			},
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					--
				},
				attrSkill = --添加的技能
				{
					{skillId = 33708, skillLv = 1,}, --加钱技能
					{skillId = 33709, skillLv = 4,}, --加光环技能
				},
				addHero = {},
				addTower = {1020,}, --粮仓
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.CONSUME_GAMECOIN_TOTALNUM, --累计消耗游戏币
				attrCountDivisor = 1000, --加属性次数计算的除数
				attrCountMax = 10000, --最大统计次数
				attrAdd =
				{
					--
				},
				attrSkill = {},
				addHero = {},
				addTower = {},
				addGoldPerWave = 30, --每波加金币
			},
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					--
				},
				attrSkill = --添加的技能
				{
					{skillId = 33708, skillLv = 2,}, --加钱技能
					{skillId = 33709, skillLv = 5,}, --加光环技能
				},
				addHero = {},
				addTower = {1020,}, --粮仓
			},
		},
	},
}

--合金钻头
_tab_treasure[19] = {
	name = "合金钻头",
	icon = "misc/treasure/treasure_19.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 5,
	debrisId = 10819, --合金钻头碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.UNLOCK_SLOT_TOTALNUM, --累计打孔次数
				attrCountDivisor = 30, --加属性次数计算的除数
				attrCountMax = 150, --最大统计次数
				attrAdd =
				{
					{attr = "atk_speed", value = 0.5,},
				},
				attrSkill = {},
				addHero = {18005, 18010, 18007, 18014,18016, 18015, 18036, 18029, 18028, 18046,}, --曹操, 夏侯敦, 郭嘉, 张辽, 典韦, 许褚, 司马懿, 贾诩, 荀彧, 甄姬
				addTower = {},
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.UNLOCK_SLOT_TOTALNUM, --累计打孔次数
				attrCountDivisor = 30, --加属性次数计算的除数
				attrCountMax = 150, --最大统计次数
				attrAdd =
				{
					{attr = "atk_speed", value = 1,},
				},
				attrSkill = {},
				addHero = {18005, 18010, 18007, 18014,18016, 18015, 18036, 18029, 18028, 18046,}, --曹操, 夏侯敦, 郭嘉, 张辽, 典韦, 许褚, 司马懿, 贾诩, 荀彧, 甄姬
				addTower = {},
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.UNLOCK_SLOT_TOTALNUM, --累计打孔次数
				attrCountDivisor = 30, --加属性次数计算的除数
				attrCountMax = 150, --最大统计次数
				attrAdd =
				{
					{attr = "atk_speed", value = 1.5,},
				},
				attrSkill = {},
				addHero = {18005, 18010, 18007, 18014,18016, 18015, 18036, 18029, 18028, 18046,}, --曹操, 夏侯敦, 郭嘉, 张辽, 典韦, 许褚, 司马懿, 贾诩, 荀彧, 甄姬
				addTower = {},
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.UNLOCK_SLOT_TOTALNUM, --累计打孔次数
				attrCountDivisor = 30, --加属性次数计算的除数
				attrCountMax = 150, --最大统计次数
				attrAdd =
				{
					{attr = "atk_speed", value = 2,},
				},
				attrSkill = {},
				addHero = {18005, 18010, 18007, 18014,18016, 18015, 18036, 18029, 18028, 18046,}, --曹操, 夏侯敦, 郭嘉, 张辽, 典韦, 许褚, 司马懿, 贾诩, 荀彧, 甄姬
				addTower = {},
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.UNLOCK_SLOT_TOTALNUM, --累计打孔次数
				attrCountDivisor = 30, --加属性次数计算的除数
				attrCountMax = 150, --最大统计次数
				attrAdd =
				{
					{attr = "atk_speed", value = 2.5,},
				},
				attrSkill = {},
				addHero = {18005, 18010, 18007, 18014,18016, 18015, 18036, 18029, 18028, 18046,}, --曹操, 夏侯敦, 郭嘉, 张辽, 典韦, 许褚, 司马懿, 贾诩, 荀彧, 甄姬
				addTower = {},
			},
		},
	},
}

--干将之鼎
_tab_treasure[20] = {
	name = "干将之鼎",
	icon = "misc/treasure/treasure_20.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 5,
	debrisId = 10820, --干将之鼎碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.REDEQUIP_MERGE_SLOT3_COUNT, --合成3孔红装次数
				attrCountDivisor = 5, --加属性次数计算的除数
				attrCountMax = 30, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 1,},
				},
				attrSkill = {},
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬
				addTower = {},
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.REDEQUIP_MERGE_SLOT3_COUNT, --合成3孔红装次数
				attrCountDivisor = 5, --加属性次数计算的除数
				attrCountMax = 30, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 2,},
				},
				attrSkill = {},
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬
				addTower = {},
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.REDEQUIP_MERGE_SLOT3_COUNT, --合成3孔红装次数
				attrCountDivisor = 5, --加属性次数计算的除数
				attrCountMax = 30, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 3,},
				},
				attrSkill = {},
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬
				addTower = {},
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.REDEQUIP_MERGE_SLOT3_COUNT, --合成3孔红装次数
				attrCountDivisor = 5, --加属性次数计算的除数
				attrCountMax = 30, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 4,},
				},
				attrSkill = {},
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬
				addTower = {},
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.REDEQUIP_MERGE_SLOT3_COUNT, --合成3孔红装次数
				attrCountDivisor = 5, --加属性次数计算的除数
				attrCountMax = 30, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 5,},
				},
				attrSkill = {},
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬
				addTower = {},
			},
		},
	},
}

--玄武水晶
_tab_treasure[21] = {
	name = "玄武水晶",
	icon = "misc/treasure/treasure_21.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 5,
	debrisId = 10821, --玄武水晶碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_5_CLEARWUGUI, --群英阁5+难度全清乌龟怪次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 1,},
				},
				attrSkill = {},
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获
				addTower = {},
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_5_CLEARWUGUI, --群英阁5+难度全清乌龟怪次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 2,},
				},
				attrSkill = {},
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获
				addTower = {},
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_5_CLEARWUGUI, --群英阁5+难度全清乌龟怪次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 3,},
				},
				attrSkill = {},
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获
				addTower = {},
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_5_CLEARWUGUI, --群英阁5+难度全清乌龟怪次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 4,},
				},
				attrSkill = {},
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获
				addTower = {},
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_5_CLEARWUGUI, --群英阁5+难度全清乌龟怪次数
				attrCountDivisor = 10, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "atk", value = 5,},
				},
				attrSkill = {},
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获
				addTower = {},
			},
		},
	},
}







--藏宝图（仅供界面显示用）
_tab_treasure[99998] = {
	name = "藏宝图",
	icon = "misc/treasure/cangbaotu_normal.png",
	width = 80,
	height = 80,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 0,
	debrisId = 0,
}

--高级藏宝图（仅供界面显示用）
_tab_treasure[99999] = {
	name = "高级藏宝图",
	icon = "misc/treasure/cangbaotu_high.png",
	width = 80,
	height = 80,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 0,
	debrisId = 0,
}