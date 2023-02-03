hVar.tab_treasure = {}
local _tab_treasure = hVar.tab_treasure

--用于界面展示排序
hVar.tab_treasureEx =
{
	1,2,3,4,5,
	6,7,8,9,10,
	11,12,13,14,15,
	16,17,18,19,20,
	21,22,23,24,25,
}


--孟德新编
_tab_treasure[1] = {
	name = "孟德新编",
	icon = "misc/addition/treasure_01.png",
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
				addHero = {18005,   18305,}, --曹操
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
				addHero = {18005,   18305,}, --曹操
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
				addHero = {18005,   18305,}, --曹操
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
				addHero = {18005,   18305,}, --曹操
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
				addHero = {18005,   18305,}, --曹操
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
				addHero = {18005,   18305,}, --曹操
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
				addHero = {18005,   18305,}, --曹操
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
				addHero = {18005,   18305,}, --曹操
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
				addHero = {18005,   18305,}, --曹操
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
				addHero = {18005,   18305,}, --曹操
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
				addHero = {18005,   18305,}, --曹操
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
				addHero = {18005,   18305,}, --曹操
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
				addHero = {18005,   18305,}, --曹操
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
				addHero = {18005,   18305,}, --曹操
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
				addHero = {18005,   18305,}, --曹操
				addTower = {},
			},
		},
	},
}

--英雄救美
_tab_treasure[2] = {
	name = "英雄救美",
	icon = "misc/addition/treasure_02.png",
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
				addHero = {18023, 18012, 18022, 18031, 18046, 18045, 18037, 18052,
						18323, 18312, 18322, 18331, 18346, 18345, 18337, 18352,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬, 祝融夫人, 大乔, 蔡文姬,
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
				addHero = {18023, 18012, 18022, 18031, 18046, 18045, 18037, 18052,
						18323, 18312, 18322, 18331, 18346, 18345, 18337, 18352,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬, 祝融夫人, 大乔, 蔡文姬,
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
				addHero = {18023, 18012, 18022, 18031, 18046, 18045, 18037, 18052,
						18323, 18312, 18322, 18331, 18346, 18345, 18337, 18352,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬, 祝融夫人, 大乔, 蔡文姬,
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
				addHero = {18023, 18012, 18022, 18031, 18046, 18045, 18037, 18052,
						18323, 18312, 18322, 18331, 18346, 18345, 18337, 18352,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬, 祝融夫人, 大乔, 蔡文姬,
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
				addHero = {18023, 18012, 18022, 18031, 18046, 18045, 18037, 18052,
						18323, 18312, 18322, 18331, 18346, 18345, 18337, 18352,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬, 祝融夫人, 大乔, 蔡文姬,
				addTower = {},
			},
		},
	},
}

--桃园香炉
_tab_treasure[3] = {
	name = "桃园香炉",
	icon = "misc/addition/treasure_03.png",
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
				addHero = {18001, 18002, 18003,   18301, 18302, 18303,}, --刘备、关羽、张飞
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
				addHero = {18001, 18002, 18003,   18301, 18302, 18303,}, --刘备、关羽、张飞
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
				addHero = {18001, 18002, 18003,   18301, 18302, 18303,}, --刘备、关羽、张飞
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
				addHero = {18001, 18002, 18003,   18301, 18302, 18303,}, --刘备、关羽、张飞
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
				addHero = {18001, 18002, 18003,   18301, 18302, 18303,}, --刘备、关羽、张飞
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
				addHero = {18001, 18002, 18003,   18301, 18302, 18303,}, --刘备、关羽、张飞
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
				addHero = {18001, 18002, 18003,   18301, 18302, 18303,}, --刘备、关羽、张飞
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
				addHero = {18001, 18002, 18003,   18301, 18302, 18303,}, --刘备、关羽、张飞
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
				addHero = {18001, 18002, 18003,   18301, 18302, 18303,}, --刘备、关羽、张飞
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
				addHero = {18001, 18002, 18003,   18301, 18302, 18303,}, --刘备、关羽、张飞
				addTower = {},
			},
		},
	},
}

--服部半藏面罩
_tab_treasure[4] = {
	name = "服部半藏面罩",
	icon = "misc/addition/treasure_04.png",
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
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038, 18050,
						18301, 18302, 18333, 18320, 18305, 18310, 18311, 18338, 18350,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕, 庞德
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
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038, 18050,
						18301, 18302, 18333, 18320, 18305, 18310, 18311, 18338, 18350,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕, 庞德
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
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038, 18050,
						18301, 18302, 18333, 18320, 18305, 18310, 18311, 18338, 18350,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕, 庞德
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
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038, 18050,
						18301, 18302, 18333, 18320, 18305, 18310, 18311, 18338, 18350,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕, 庞德
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
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038, 18050,
						18301, 18302, 18333, 18320, 18305, 18310, 18311, 18338, 18350,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕, 庞德
				addTower = {},
			},
		},
	},
}

--神叼侠侣
_tab_treasure[5] = {
	name = "神叼侠侣",
	icon = "misc/addition/treasure_05.png",
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
				addHero = {18021, 18023,   18321, 18323,}, --诸葛亮, 黄月英
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
				addHero = {18011, 18012,   18311, 18312,}, --吕布, 貂蝉
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
				addHero = {18019, 18022,   18319, 18322,}, --周瑜, 小乔
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
				addHero = {18021, 18023,   18321, 18323,}, --诸葛亮, 黄月英
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
				addHero = {18011, 18012,   18311, 18312,}, --吕布, 貂蝉
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
				addHero = {18019, 18022,   18319, 18322,}, --周瑜, 小乔
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
				addHero = {18021, 18023,   18321, 18323,}, --诸葛亮, 黄月英
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
				addHero = {18011, 18012,   18311, 18312,}, --吕布, 貂蝉
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
				addHero = {18019, 18022,   18319, 18322,}, --周瑜, 小乔
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
				addHero = {18021, 18023,   18321, 18323,}, --诸葛亮, 黄月英
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
				addHero = {18011, 18012,   18311, 18312,}, --吕布, 貂蝉
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
				addHero = {18019, 18022,   18319, 18322,}, --周瑜, 小乔
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
				addHero = {18021, 18023,   18321, 18323,}, --诸葛亮, 黄月英
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
				addHero = {18011, 18012,   18311, 18312,}, --吕布, 貂蝉
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
				addHero = {18019, 18022,   18319, 18322,}, --周瑜, 小乔
				addTower = {},
			},
		},
	},
}

--拿破仑选集
_tab_treasure[6] = {
	name = "拿破仑选集",
	icon = "misc/addition/treasure_06.png",
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
	icon = "misc/addition/treasure_07.png",
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
	icon = "misc/addition/treasure_08.png",
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
				addHero = {18021, 18025,   18321, 18325,}, --诸葛亮, 庞统
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
				addHero = {18021, 18025,   18321, 18325,}, --诸葛亮, 庞统
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
				addHero = {18021, 18025,   18321, 18325,}, --诸葛亮, 庞统
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
				addHero = {18021, 18025,   18321, 18325,}, --诸葛亮, 庞统
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
				addHero = {18021, 18025,   18321, 18325,}, --诸葛亮, 庞统
				addTower = {},
			},
		},
	},
}

--莫邪之血
_tab_treasure[9] = {
	name = "莫邪之血",
	icon = "misc/addition/treasure_09.png",
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
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038, 18050,
						18301, 18302, 18333, 18320, 18305, 18310, 18311, 18338, 18350,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕, 庞德
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
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038, 18050,
						18301, 18302, 18333, 18320, 18305, 18310, 18311, 18338, 18350,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕, 庞德
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
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038, 18050,
						18301, 18302, 18333, 18320, 18305, 18310, 18311, 18338, 18350,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕, 庞德
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
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038, 18050,
						18301, 18302, 18333, 18320, 18305, 18310, 18311, 18338, 18350,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕, 庞德
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
				addHero = {18001, 18002, 18033, 18020, 18005, 18010, 18011, 18038, 18050,
						18301, 18302, 18333, 18320, 18305, 18310, 18311, 18338, 18350,}, --刘备, 关羽, 马超, 徐庶, 曹操, 夏侯敦, 吕布, 曹丕, 庞德
				addTower = {},
			},
		},
	},
}

--五虎上将令
_tab_treasure[10] = {
	name = "五虎上将令",
	icon = "misc/addition/treasure_10.png",
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
				addHero = {18002, 18003, 18008, 18033, 18032,   18302, 18303, 18308, 18333, 18332,}, --关羽, 张飞, 赵云, 马超, 黄忠
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
				addHero = {18002, 18003, 18008, 18033, 18032,   18302, 18303, 18308, 18333, 18332,}, --关羽, 张飞, 赵云, 马超, 黄忠
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
				addHero = {18002, 18003, 18008, 18033, 18032,   18302, 18303, 18308, 18333, 18332,}, --关羽, 张飞, 赵云, 马超, 黄忠
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
				addHero = {18002, 18003, 18008, 18033, 18032,   18302, 18303, 18308, 18333, 18332,}, --关羽, 张飞, 赵云, 马超, 黄忠
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
				addHero = {18002, 18003, 18008, 18033, 18032,   18302, 18303, 18308, 18333, 18332,}, --关羽, 张飞, 赵云, 马超, 黄忠
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
				addHero = {18002, 18003, 18008, 18033, 18032,   18302, 18303, 18308, 18333, 18332,}, --关羽, 张飞, 赵云, 马超, 黄忠
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
				addHero = {18002, 18003, 18008, 18033, 18032,   18302, 18303, 18308, 18333, 18332,}, --关羽, 张飞, 赵云, 马超, 黄忠
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
				addHero = {18002, 18003, 18008, 18033, 18032,   18302, 18303, 18308, 18333, 18332,}, --关羽, 张飞, 赵云, 马超, 黄忠
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
				addHero = {18002, 18003, 18008, 18033, 18032,   18302, 18303, 18308, 18333, 18332,}, --关羽, 张飞, 赵云, 马超, 黄忠
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
				addHero = {18002, 18003, 18008, 18033, 18032,   18302, 18303, 18308, 18333, 18332,}, --关羽, 张飞, 赵云, 马超, 黄忠
				addTower = {},
			},
		},
	},
}

--建筑师证书
_tab_treasure[11] = {
	name = "建筑师证书",
	icon = "misc/addition/treasure_11.png",
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
	icon = "misc/addition/treasure_12.png",
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
				addHero = {18008, 18023, 18016, 18012, 18031, 18006, 18035, 18017, 18032, 18045,
						18308, 18323, 18316, 18312, 18331, 18306, 18335, 18317, 18332, 18345,}, --赵云, 黄月英, 典韦, 貂蝉, 孙尚香, 太史慈, 陆逊, 甘宁, 黄忠, 祝融夫人
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
				addHero = {18008, 18023, 18016, 18012, 18031, 18006, 18035, 18017, 18032, 18045,
						18308, 18323, 18316, 18312, 18331, 18306, 18335, 18317, 18332, 18345,}, --赵云, 黄月英, 典韦, 貂蝉, 孙尚香, 太史慈, 陆逊, 甘宁, 黄忠, 祝融夫人
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
				addHero = {18008, 18023, 18016, 18012, 18031, 18006, 18035, 18017, 18032, 18045,
						18308, 18323, 18316, 18312, 18331, 18306, 18335, 18317, 18332, 18345,}, --赵云, 黄月英, 典韦, 貂蝉, 孙尚香, 太史慈, 陆逊, 甘宁, 黄忠, 祝融夫人
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
				addHero = {18008, 18023, 18016, 18012, 18031, 18006, 18035, 18017, 18032, 18045,
						18308, 18323, 18316, 18312, 18331, 18306, 18335, 18317, 18332, 18345,}, --赵云, 黄月英, 典韦, 貂蝉, 孙尚香, 太史慈, 陆逊, 甘宁, 黄忠, 祝融夫人
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
				addHero = {18008, 18023, 18016, 18012, 18031, 18006, 18035, 18017, 18032, 18045,
						18308, 18323, 18316, 18312, 18331, 18306, 18335, 18317, 18332, 18345,}, --赵云, 黄月英, 典韦, 貂蝉, 孙尚香, 太史慈, 陆逊, 甘宁, 黄忠, 祝融夫人
				addTower = {},
			},
		},
	},
}

--战斗天使
_tab_treasure[13] = {
	name = "战斗天使",
	icon = "misc/addition/treasure_13.png",
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
				addHero = {18023, 18012, 18022, 18031, 18046, 18045, 18037, 18052,
						18323, 18312, 18322, 18331, 18346, 18345, 18337, 18352,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬, 祝融夫人, 大乔, 蔡文姬,
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
				addHero = {18023, 18012, 18022, 18031, 18046, 18045, 18037, 18052,
						18323, 18312, 18322, 18331, 18346, 18345, 18337, 18352,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬, 祝融夫人, 大乔, 蔡文姬,
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
				addHero = {18023, 18012, 18022, 18031, 18046, 18045, 18037, 18052,
						18323, 18312, 18322, 18331, 18346, 18345, 18337, 18352,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬, 祝融夫人, 大乔, 蔡文姬,
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
				addHero = {18023, 18012, 18022, 18031, 18046, 18045, 18037, 18052,
						18323, 18312, 18322, 18331, 18346, 18345, 18337, 18352,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬, 祝融夫人, 大乔, 蔡文姬,
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
				addHero = {18023, 18012, 18022, 18031, 18046, 18045, 18037, 18052,
						18323, 18312, 18322, 18331, 18346, 18345, 18337, 18352,}, --黄月英, 貂蝉, 小乔, 孙尚香, 甄姬, 祝融夫人, 大乔, 蔡文姬,
				addTower = {},
			},
		},
	},
}

--铁人之心
_tab_treasure[14] = {
	name = "铁人之心",
	icon = "misc/addition/treasure_14.png",
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
	icon = "misc/addition/treasure_15.png",
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
				--刘备,关羽,张飞,赵云,马超,黄忠,诸葛亮,黄月英,徐庶,孟获,祝融夫人,庞统,曹操,曹丕,夏侯敦,郭嘉,张辽,徐晃,典韦,许褚,
				--庞德,司马懿,贾诩,荀彧,甄姬,蔡文姬,吕布,貂蝉,董卓,孙坚,孙策,孙权,周瑜,大乔,小乔,孙尚香,太史慈,陆逊,甘宁
				addHero = {18001,18002,18003,18008,18033,18032,18021,18023,18020,18041,18045,18025,18005,18038,18010,18007,18014,18049,18016,18015,
						18050,18036,18029,18028,18046,18052,18011,18012,18027,18034,18018,18024,18019,18037,18022,18031,18006,18035,18017, --全体英雄
					   18301,18302,18303,18308,18333,18332,18321,18323,18320,18341,18345,18325,18305,18338,18310,18307,18314,18349,18316,18315,
						18350,18336,18329,18328,18346,18352,18311,18312,18327,18334,18318,18324,18319,18337,18322,18331,18306,18335,13017,},
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
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041, 18049,
						18303, 18314, 18315, 18327, 18334, 18318, 18324, 18341, 18349,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获, 徐晃
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
				--刘备,关羽,张飞,赵云,马超,黄忠,诸葛亮,黄月英,徐庶,孟获,祝融夫人,庞统,曹操,曹丕,夏侯敦,郭嘉,张辽,徐晃,典韦,许褚,
				--庞德,司马懿,贾诩,荀彧,甄姬,蔡文姬,吕布,貂蝉,董卓,孙坚,孙策,孙权,周瑜,大乔,小乔,孙尚香,太史慈,陆逊,甘宁
				addHero = {18001,18002,18003,18008,18033,18032,18021,18023,18020,18041,18045,18025,18005,18038,18010,18007,18014,18049,18016,18015,
						18050,18036,18029,18028,18046,18052,18011,18012,18027,18034,18018,18024,18019,18037,18022,18031,18006,18035,18017, --全体英雄
					   18301,18302,18303,18308,18333,18332,18321,18323,18320,18341,18345,18325,18305,18338,18310,18307,18314,18349,18316,18315,
						18350,18336,18329,18328,18346,18352,18311,18312,18327,18334,18318,18324,18319,18337,18322,18331,18306,18335,13017,},
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
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041, 18049,
						18303, 18314, 18315, 18327, 18334, 18318, 18324, 18341, 18349,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获, 徐晃
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
				--刘备,关羽,张飞,赵云,马超,黄忠,诸葛亮,黄月英,徐庶,孟获,祝融夫人,庞统,曹操,曹丕,夏侯敦,郭嘉,张辽,徐晃,典韦,许褚,
				--庞德,司马懿,贾诩,荀彧,甄姬,蔡文姬,吕布,貂蝉,董卓,孙坚,孙策,孙权,周瑜,大乔,小乔,孙尚香,太史慈,陆逊,甘宁
				addHero = {18001,18002,18003,18008,18033,18032,18021,18023,18020,18041,18045,18025,18005,18038,18010,18007,18014,18049,18016,18015,
						18050,18036,18029,18028,18046,18052,18011,18012,18027,18034,18018,18024,18019,18037,18022,18031,18006,18035,18017, --全体英雄
					   18301,18302,18303,18308,18333,18332,18321,18323,18320,18341,18345,18325,18305,18338,18310,18307,18314,18349,18316,18315,
						18350,18336,18329,18328,18346,18352,18311,18312,18327,18334,18318,18324,18319,18337,18322,18331,18306,18335,13017,},
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
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041, 18049,
						18303, 18314, 18315, 18327, 18334, 18318, 18324, 18341, 18349,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获, 徐晃
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
				--刘备,关羽,张飞,赵云,马超,黄忠,诸葛亮,黄月英,徐庶,孟获,祝融夫人,庞统,曹操,曹丕,夏侯敦,郭嘉,张辽,徐晃,典韦,许褚,
				--庞德,司马懿,贾诩,荀彧,甄姬,蔡文姬,吕布,貂蝉,董卓,孙坚,孙策,孙权,周瑜,大乔,小乔,孙尚香,太史慈,陆逊,甘宁
				addHero = {18001,18002,18003,18008,18033,18032,18021,18023,18020,18041,18045,18025,18005,18038,18010,18007,18014,18049,18016,18015,
						18050,18036,18029,18028,18046,18052,18011,18012,18027,18034,18018,18024,18019,18037,18022,18031,18006,18035,18017, --全体英雄
					   18301,18302,18303,18308,18333,18332,18321,18323,18320,18341,18345,18325,18305,18338,18310,18307,18314,18349,18316,18315,
						18350,18336,18329,18328,18346,18352,18311,18312,18327,18334,18318,18324,18319,18337,18322,18331,18306,18335,13017,},
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
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041, 18049,
						18303, 18314, 18315, 18327, 18334, 18318, 18324, 18341, 18349,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获, 徐晃
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
				--刘备,关羽,张飞,赵云,马超,黄忠,诸葛亮,黄月英,徐庶,孟获,祝融夫人,庞统,曹操,曹丕,夏侯敦,郭嘉,张辽,徐晃,典韦,许褚,
				--庞德,司马懿,贾诩,荀彧,甄姬,蔡文姬,吕布,貂蝉,董卓,孙坚,孙策,孙权,周瑜,大乔,小乔,孙尚香,太史慈,陆逊,甘宁
				addHero = {18001,18002,18003,18008,18033,18032,18021,18023,18020,18041,18045,18025,18005,18038,18010,18007,18014,18049,18016,18015,
						18050,18036,18029,18028,18046,18052,18011,18012,18027,18034,18018,18024,18019,18037,18022,18031,18006,18035,18017, --全体英雄
					   18301,18302,18303,18308,18333,18332,18321,18323,18320,18341,18345,18325,18305,18338,18310,18307,18314,18349,18316,18315,
						18350,18336,18329,18328,18346,18352,18311,18312,18327,18334,18318,18324,18319,18337,18322,18331,18306,18335,13017,},
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
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041, 18049,
						18303, 18314, 18315, 18327, 18334, 18318, 18324, 18341, 18349,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获, 徐晃
				addTower = {},
			},
		},
	},
}

--朱雀信条
_tab_treasure[16] = {
	name = "朱雀信条",
	icon = "misc/addition/treasure_16.png",
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
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046, 18037,
						18321, 18307, 18336, 18329, 18328, 18319, 18322, 18325, 18346, 18337,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬, 大乔
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
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046, 18037,
						18321, 18307, 18336, 18329, 18328, 18319, 18322, 18325, 18346, 18337,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬, 大乔
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
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046, 18037,
						18321, 18307, 18336, 18329, 18328, 18319, 18322, 18325, 18346, 18337,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬, 大乔
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
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046, 18037,
						18321, 18307, 18336, 18329, 18328, 18319, 18322, 18325, 18346, 18337,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬, 大乔
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
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046, 18037,
						18321, 18307, 18336, 18329, 18328, 18319, 18322, 18325, 18346, 18337,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬, 大乔
				addTower = {},
			},
		},
	},
}

--主公玉玺
_tab_treasure[17] = {
	name = "主公玉玺",
	icon = "misc/addition/treasure_17.png",
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
				addHero = {18001,18005,18024,   18301,18305,18324,}, --刘备、曹操、孙权
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_LV15, --15级英雄总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 2,},
				},
				attrSkill = {},
				addHero = {18001,18005,18024,   18301,18305,18324,}, --刘备、曹操、孙权
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
				addHero = {18001,18005,18024,   18301,18305,18324,}, --刘备、曹操、孙权
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_LV15, --15级英雄总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 3,},
				},
				attrSkill = {},
				addHero = {18001,18005,18024,   18301,18305,18324,}, --刘备、曹操、孙权
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
				addHero = {18001,18005,18024,   18301,18305,18324,}, --刘备、曹操、孙权
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_LV15, --15级英雄总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 5,},
				},
				attrSkill = {},
				addHero = {18001,18005,18024,   18301,18305,18324,}, --刘备、曹操、孙权
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
				addHero = {18001,18005,18024,   18301,18305,18324,}, --刘备、曹操、孙权
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_LV15, --15级英雄总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 6,},
				},
				attrSkill = {},
				addHero = {18001,18005,18024,   18301,18305,18324,}, --刘备、曹操、孙权
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
				addHero = {18001,18005,18024,   18301,18305,18324,}, --刘备、曹操、孙权
				addTower = {},
			},
			{
				attrType = hVar.TREASURE_ATTR.HERO_COUNT_LV15, --15级英雄总数量
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd =
				{
					{attr = "hp_max", value = 7,},
				},
				attrSkill = {},
				addHero = {18001,18005,18024,   18301,18305,18324,}, --刘备、曹操、孙权
				addTower = {},
			},
		},
	},
}

--屯田令牌
_tab_treasure[18] = {
	name = "屯田令牌",
	icon = "misc/addition/treasure_18.png",
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
	icon = "misc/addition/treasure_19.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.BLUE, --品质
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
				addHero = {18005, 18010, 18007, 18014, 18016, 18015, 18036, 18029, 18028, 18046, 18038, 18049, 18050, 18052,
						18305, 18310, 18307, 18314, 18316, 18315, 18336, 18329, 18328, 18346, 18338, 18349, 18350, 18352,}, --曹操, 夏侯敦, 郭嘉, 张辽, 典韦, 许褚, 司马懿, 贾诩, 荀彧, 甄姬, 曹丕, 徐晃, 庞德, 蔡文姬
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
				addHero = {18005, 18010, 18007, 18014, 18016, 18015, 18036, 18029, 18028, 18046, 18038, 18049, 18050, 18052,
						18305, 18310, 18307, 18314, 18316, 18315, 18336, 18329, 18328, 18346, 18338, 18349, 18350, 18352,}, --曹操, 夏侯敦, 郭嘉, 张辽, 典韦, 许褚, 司马懿, 贾诩, 荀彧, 甄姬, 曹丕, 徐晃, 庞德, 蔡文姬
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
				addHero = {18005, 18010, 18007, 18014, 18016, 18015, 18036, 18029, 18028, 18046, 18038, 18049, 18050, 18052,
						18305, 18310, 18307, 18314, 18316, 18315, 18336, 18329, 18328, 18346, 18338, 18349, 18350, 18352,}, --曹操, 夏侯敦, 郭嘉, 张辽, 典韦, 许褚, 司马懿, 贾诩, 荀彧, 甄姬, 曹丕, 徐晃, 庞德, 蔡文姬
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
				addHero = {18005, 18010, 18007, 18014, 18016, 18015, 18036, 18029, 18028, 18046, 18038, 18049, 18050, 18052,
						18305, 18310, 18307, 18314, 18316, 18315, 18336, 18329, 18328, 18346, 18338, 18349, 18350, 18352,}, --曹操, 夏侯敦, 郭嘉, 张辽, 典韦, 许褚, 司马懿, 贾诩, 荀彧, 甄姬, 曹丕, 徐晃, 庞德, 蔡文姬
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
				addHero = {18005, 18010, 18007, 18014, 18016, 18015, 18036, 18029, 18028, 18046, 18038, 18049, 18050, 18052,
						18305, 18310, 18307, 18314, 18316, 18315, 18336, 18329, 18328, 18346, 18338, 18349, 18350, 18352,}, --曹操, 夏侯敦, 郭嘉, 张辽, 典韦, 许褚, 司马懿, 贾诩, 荀彧, 甄姬, 曹丕, 徐晃, 庞德, 蔡文姬
				addTower = {},
			},
		},
	},
}

--干将之鼎
_tab_treasure[20] = {
	name = "干将之鼎",
	icon = "misc/addition/treasure_20.png",
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
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046, 18037,
						18321, 18307, 18336, 18329, 18328, 18319, 18322, 18325, 18346, 18337,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬, 大乔
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
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046, 18037,
						18321, 18307, 18336, 18329, 18328, 18319, 18322, 18325, 18346, 18337,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬, 大乔
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
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046, 18037,
						18321, 18307, 18336, 18329, 18328, 18319, 18322, 18325, 18346, 18337,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬, 大乔
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
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046, 18037,
						18321, 18307, 18336, 18329, 18328, 18319, 18322, 18325, 18346, 18337,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬, 大乔
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
				addHero = {18021, 18007, 18036, 18029, 18028, 18019, 18022, 18025, 18046, 18037,
						18321, 18307, 18336, 18329, 18328, 18319, 18322, 18325, 18346, 18337,}, --诸葛亮, 郭嘉, 司马懿, 贾诩, 荀彧, 周瑜, 小乔, 庞统, 甄姬, 大乔
				addTower = {},
			},
		},
	},
}

--玄武水晶
_tab_treasure[21] = {
	name = "玄武水晶",
	icon = "misc/addition/treasure_21.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.BLUE, --品质
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
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041, 18049,
						18303, 18314, 18315, 18327, 18334, 18318, 18324, 18341, 18349,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获, 徐晃
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
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041, 18049,
						18303, 18314, 18315, 18327, 18334, 18318, 18324, 18341, 18349,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获, 徐晃
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
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041, 18049,
						18303, 18314, 18315, 18327, 18334, 18318, 18324, 18341, 18349,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获, 徐晃
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
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041, 18049,
						18303, 18314, 18315, 18327, 18334, 18318, 18324, 18341, 18349,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获, 徐晃
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
				addHero = {18003, 18014, 18015, 18027, 18034, 18018, 18024, 18041, 18049,
						18303, 18314, 18315, 18327, 18334, 18318, 18324, 18341, 18349,}, --张飞, 张辽, 许褚, 董卓, 孙坚, 孙策, 孙权, 孟获, 徐晃
				addTower = {},
			},
		},
	},
}

--琉璃簪
_tab_treasure[22] = {
	name = "琉璃簪",
	icon = "misc/addition/treasure_22.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 5,
	debrisId = 10822, --琉璃簪碎片
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
					{attr = "build_cost", value = -10,},
					{attr = "atk_radius", value = 10,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1015,}, --寒冰塔
			},
			{
				attrType = hVar.TREASURE_ATTR.WORLD_CHANNEL_RED_PACKGET_NUM, --世界聊天频到抢到红包次数
				attrCountDivisor = 20, --加属性次数计算的除数
				attrCountMax = 200, --最大统计次数
				attrAdd =
				{
					{attr = "atk_radius", value = 1,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1015,}, --寒冰塔
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
					{attr = "build_cost", value = -10,},
					{attr = "atk_radius", value = 10,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1015,}, --寒冰塔
			},
			{
				attrType = hVar.TREASURE_ATTR.WORLD_CHANNEL_RED_PACKGET_NUM, --世界聊天频到抢到红包次数
				attrCountDivisor = 20, --加属性次数计算的除数
				attrCountMax = 200, --最大统计次数
				attrAdd =
				{
					{attr = "atk_radius", value = 2,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1015,}, --寒冰塔
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
					{attr = "build_cost", value = -10,},
					{attr = "atk_radius", value = 10,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1015,}, --寒冰塔
			},
			{
				attrType = hVar.TREASURE_ATTR.WORLD_CHANNEL_RED_PACKGET_NUM, --世界聊天频到抢到红包次数
				attrCountDivisor = 20, --加属性次数计算的除数
				attrCountMax = 200, --最大统计次数
				attrAdd =
				{
					{attr = "atk_radius", value = 3,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1015,}, --寒冰塔
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
					{attr = "build_cost", value = -10,},
					{attr = "atk_radius", value = 10,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1015,}, --寒冰塔
			},
			{
				attrType = hVar.TREASURE_ATTR.WORLD_CHANNEL_RED_PACKGET_NUM, --世界聊天频到抢到红包次数
				attrCountDivisor = 20, --加属性次数计算的除数
				attrCountMax = 200, --最大统计次数
				attrAdd =
				{
					{attr = "atk_radius", value = 4,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1015,}, --寒冰塔
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
					{attr = "build_cost", value = -10,},
					{attr = "atk_radius", value = 10,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1015,}, --寒冰塔
			},
			{
				attrType = hVar.TREASURE_ATTR.WORLD_CHANNEL_RED_PACKGET_NUM, --世界聊天频到抢到红包次数
				attrCountDivisor = 20, --加属性次数计算的除数
				attrCountMax = 200, --最大统计次数
				attrAdd =
				{
					{attr = "atk_radius", value = 4,},
					{attr = "atk", value = 1,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1015,}, --寒冰塔
			},
		},
	},
}

--剑仙长明灯
_tab_treasure[23] = {
	name = "剑仙长明灯",
	icon = "misc/addition/treasure_23.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 5,
	debrisId = 10823, --剑仙长明灯碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd = {},
				attrSkill = {},
				addHero = {},
				addTower = {},
				addButton = true, --是否有按钮
			},
			{
				attrType = hVar.TREASURE_ATTR.SHOUWEIJIANGE_WINCOUNT, --守卫剑阁通关次数
				attrCountDivisor = 20, --加属性次数计算的除数
				attrCountMax = 200, --最大统计次数
				attrAdd =
				{
					{attr = "atk_radius", value = 1,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1013,}, --火焰塔
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd = {},
				attrSkill = {},
				addHero = {},
				addTower = {},
				addButton = true, --是否有按钮
			},
			{
				attrType = hVar.TREASURE_ATTR.SHOUWEIJIANGE_WINCOUNT, --守卫剑阁通关次数
				attrCountDivisor = 20, --加属性次数计算的除数
				attrCountMax = 200, --最大统计次数
				attrAdd =
				{
					{attr = "atk_radius", value = 2,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1013,}, --火焰塔
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd = {},
				attrSkill = {},
				addHero = {},
				addTower = {},
				addButton = true, --是否有按钮
			},
			{
				attrType = hVar.TREASURE_ATTR.SHOUWEIJIANGE_WINCOUNT, --守卫剑阁通关次数
				attrCountDivisor = 20, --加属性次数计算的除数
				attrCountMax = 200, --最大统计次数
				attrAdd =
				{
					{attr = "atk_radius", value = 3,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1013,}, --火焰塔
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd = {},
				attrSkill = {},
				addHero = {},
				addTower = {},
				addButton = true, --是否有按钮
			},
			{
				attrType = hVar.TREASURE_ATTR.SHOUWEIJIANGE_WINCOUNT, --守卫剑阁通关次数
				attrCountDivisor = 20, --加属性次数计算的除数
				attrCountMax = 200, --最大统计次数
				attrAdd =
				{
					{attr = "atk_radius", value = 4,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1013,}, --火焰塔
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd = {},
				attrSkill = {},
				addHero = {},
				addTower = {},
				addButton = true, --是否有按钮
			},
			{
				attrType = hVar.TREASURE_ATTR.SHOUWEIJIANGE_WINCOUNT, --守卫剑阁通关次数
				attrCountDivisor = 20, --加属性次数计算的除数
				attrCountMax = 200, --最大统计次数
				attrAdd =
				{
					{attr = "atk_radius", value = 4,},
					{attr = "atk", value = 1,},
				},
				attrSkill = {},
				addHero = {},
				addTower = {1013,}, --火焰塔
			},
		},
	},
}

--扫荡令
_tab_treasure[24] = {
	name = "扫荡令",
	icon = "misc/addition/treasure_24.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 5,
	debrisId = 10824, --扫荡令碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd = {},
				attrSkill = {},
				addHero = {},
				addTower = {},
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd = {},
				attrSkill = {},
				addHero = {},
				addTower = {},
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd = {},
				attrSkill = {},
				addHero = {},
				addTower = {},
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd = {},
				attrSkill = {},
				addHero = {},
				addTower = {},
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.NONE, --一次性加成
				attrCountDivisor = -1, --加属性次数计算的除数
				attrCountMax = -1, --最大统计次数
				attrAdd = {},
				attrSkill = {},
				addHero = {},
				addTower = {},
			},
		},
	},
}

--菜虚鲲
_tab_treasure[25] = {
	name = "菜虚鲲",
	icon = "misc/addition/treasure_25.png",
	width = 96,
	height = 96,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 5,
	debrisId = 10825, --菜虚鲲碎片
	takeEffect = --生效的宝物属性位
	{
		[1] = --1星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.JUEZHNANXUKUN_WINCOUNT, --决战虚鲲通关次数
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = 10, --最大统计次数
				attrAdd =
				{
					{attr = "atk_radius", value = 2,},
					{attr = "atk", value = 1,},
				},
				attrSkill = {},
				--刘备,关羽,张飞,赵云,马超,黄忠,诸葛亮,黄月英,徐庶,孟获,祝融夫人,庞统,曹操,曹丕,夏侯敦,郭嘉,张辽,徐晃,典韦,许褚,
				--庞德,司马懿,贾诩,荀彧,甄姬,蔡文姬,吕布,貂蝉,董卓,孙坚,孙策,孙权,周瑜,大乔,小乔,孙尚香,太史慈,陆逊,甘宁
				addHero = {
				--	   18001,18002,18003,18008,18033,18032,18021,18023,18020,18041,18045,18025,18005,18038,18010,18007,18014,18049,18016,18015,
				--		18050,18036,18029,18028,18046,18052,18011,18012,18027,18034,18018,18024,18019,18037,18022,18031,18006,18035,18017, --全体英雄
				--	只加驻守的英雄
					   18301,18302,18303,18308,18333,18332,18321,18323,18320,18341,18345,18325,18305,18338,18310,18307,18314,18349,18316,18315,
						18350,18336,18329,18328,18346,18352,18311,18312,18327,18334,18318,18324,18319,18337,18322,18331,18306,18335,13017,},
				addTower = {},
			},
		},
		[2] = --2星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.JUEZHNANXUKUN_WINCOUNT, --决战虚鲲通关次数
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = 20, --最大统计次数
				attrAdd =
				{
					{attr = "atk_radius", value = 4,},
					{attr = "atk", value = 2,},
				},
				attrSkill = {},
				--刘备,关羽,张飞,赵云,马超,黄忠,诸葛亮,黄月英,徐庶,孟获,祝融夫人,庞统,曹操,曹丕,夏侯敦,郭嘉,张辽,徐晃,典韦,许褚,
				--庞德,司马懿,贾诩,荀彧,甄姬,蔡文姬,吕布,貂蝉,董卓,孙坚,孙策,孙权,周瑜,大乔,小乔,孙尚香,太史慈,陆逊,甘宁
				addHero = {
				--	   18001,18002,18003,18008,18033,18032,18021,18023,18020,18041,18045,18025,18005,18038,18010,18007,18014,18049,18016,18015,
				--		18050,18036,18029,18028,18046,18052,18011,18012,18027,18034,18018,18024,18019,18037,18022,18031,18006,18035,18017, --全体英雄
				--	只加驻守的英雄
					   18301,18302,18303,18308,18333,18332,18321,18323,18320,18341,18345,18325,18305,18338,18310,18307,18314,18349,18316,18315,
						18350,18336,18329,18328,18346,18352,18311,18312,18327,18334,18318,18324,18319,18337,18322,18331,18306,18335,13017,},
				addTower = {},
			},
		},
		[3] = --3星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.JUEZHNANXUKUN_WINCOUNT, --决战虚鲲通关次数
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = 30, --最大统计次数
				attrAdd =
				{
					{attr = "atk_radius", value = 6,},
					{attr = "atk", value = 3,},
				},
				attrSkill = {},
				--刘备,关羽,张飞,赵云,马超,黄忠,诸葛亮,黄月英,徐庶,孟获,祝融夫人,庞统,曹操,曹丕,夏侯敦,郭嘉,张辽,徐晃,典韦,许褚,
				--庞德,司马懿,贾诩,荀彧,甄姬,蔡文姬,吕布,貂蝉,董卓,孙坚,孙策,孙权,周瑜,大乔,小乔,孙尚香,太史慈,陆逊,甘宁
				addHero = {
				--	   18001,18002,18003,18008,18033,18032,18021,18023,18020,18041,18045,18025,18005,18038,18010,18007,18014,18049,18016,18015,
				--		18050,18036,18029,18028,18046,18052,18011,18012,18027,18034,18018,18024,18019,18037,18022,18031,18006,18035,18017, --全体英雄
				--	只加驻守的英雄
					   18301,18302,18303,18308,18333,18332,18321,18323,18320,18341,18345,18325,18305,18338,18310,18307,18314,18349,18316,18315,
						18350,18336,18329,18328,18346,18352,18311,18312,18327,18334,18318,18324,18319,18337,18322,18331,18306,18335,13017,},
				addTower = {},
			},
		},
		[4] = --4星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.JUEZHNANXUKUN_WINCOUNT, --决战虚鲲通关次数
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = 40, --最大统计次数
				attrAdd =
				{
					{attr = "atk_radius", value = 8,},
					{attr = "atk", value = 4,},
				},
				attrSkill = {},
				--刘备,关羽,张飞,赵云,马超,黄忠,诸葛亮,黄月英,徐庶,孟获,祝融夫人,庞统,曹操,曹丕,夏侯敦,郭嘉,张辽,徐晃,典韦,许褚,
				--庞德,司马懿,贾诩,荀彧,甄姬,蔡文姬,吕布,貂蝉,董卓,孙坚,孙策,孙权,周瑜,大乔,小乔,孙尚香,太史慈,陆逊,甘宁
				addHero = {
				--	   18001,18002,18003,18008,18033,18032,18021,18023,18020,18041,18045,18025,18005,18038,18010,18007,18014,18049,18016,18015,
				--		18050,18036,18029,18028,18046,18052,18011,18012,18027,18034,18018,18024,18019,18037,18022,18031,18006,18035,18017, --全体英雄
				--	只加驻守的英雄
					   18301,18302,18303,18308,18333,18332,18321,18323,18320,18341,18345,18325,18305,18338,18310,18307,18314,18349,18316,18315,
						18350,18336,18329,18328,18346,18352,18311,18312,18327,18334,18318,18324,18319,18337,18322,18331,18306,18335,13017,},
				addTower = {},
			},
		},
		[5] = --5星 加属性
		{
			{
				attrType = hVar.TREASURE_ATTR.JUEZHNANXUKUN_WINCOUNT, --决战虚鲲通关次数
				attrCountDivisor = 1, --加属性次数计算的除数
				attrCountMax = 50, --最大统计次数
				attrAdd =
				{
					{attr = "atk_radius", value = 10,},
					{attr = "atk", value = 5,},
				},
				attrSkill = {},
				--刘备,关羽,张飞,赵云,马超,黄忠,诸葛亮,黄月英,徐庶,孟获,祝融夫人,庞统,曹操,曹丕,夏侯敦,郭嘉,张辽,徐晃,典韦,许褚,
				--庞德,司马懿,贾诩,荀彧,甄姬,蔡文姬,吕布,貂蝉,董卓,孙坚,孙策,孙权,周瑜,大乔,小乔,孙尚香,太史慈,陆逊,甘宁
				addHero = {
				--	   18001,18002,18003,18008,18033,18032,18021,18023,18020,18041,18045,18025,18005,18038,18010,18007,18014,18049,18016,18015,
				--		18050,18036,18029,18028,18046,18052,18011,18012,18027,18034,18018,18024,18019,18037,18022,18031,18006,18035,18017, --全体英雄
				--	只加驻守的英雄
					   18301,18302,18303,18308,18333,18332,18321,18323,18320,18341,18345,18325,18305,18338,18310,18307,18314,18349,18316,18315,
						18350,18336,18329,18328,18346,18352,18311,18312,18327,18334,18318,18324,18319,18337,18322,18331,18306,18335,13017,},
				addTower = {},
			},
		},
	},
}










---------------------------------------------------------------------------------------------------------------
--藏宝图（仅供界面显示用）
_tab_treasure[99998] = {
	name = "藏宝图",
	icon = "UI:CANGBAOTU_NORMAL",
	width = 80,
	height = 80,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 0,
	debrisId = 0,
}

--高级藏宝图（仅供界面显示用）
_tab_treasure[99999] = {
	name = "高级藏宝图",
	icon = "UI:CANGBAOTU_HIGH",
	width = 80,
	height = 80,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxStar = 0,
	debrisId = 0,
}




--================================================================================
--================================================================================
--geyachao: 将生效的英雄和防御塔转化为dic表类型(优化效率)
for index, tabTR in pairs(_tab_treasure) do
	local takeEffect = tabTR.takeEffect
	if takeEffect then
		--逐一转化
		for star = 1, #takeEffect, 1 do
			local tTakeEffect = takeEffect[star]
			if tTakeEffect then
				for te = 1, #tTakeEffect, 1 do
					--英雄dic
					local addHero = tTakeEffect[te].addHero
					if addHero then
						local addHeroDic = {}
						for h = 1, #addHero, 1 do
							local heroId = addHero[h]
							addHeroDic[heroId] = heroId
						end
						tTakeEffect[te].addHeroDic = addHeroDic --存储
					end
					
					--防御塔dic
					local addTower = tTakeEffect[te].addTower
					if addTower then
						local addTowerDic = {}
						for t = 1, #addTower, 1 do
							local towerId = addTower[t]
							addTowerDic[towerId] = heroId
						end
						tTakeEffect[te].addTowerDic = addTowerDic
					end
				end
			end
		end
	end
end
