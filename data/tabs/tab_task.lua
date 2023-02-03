hVar.tab_task = {}
local _tab_task = hVar.tab_task

----每日奖励
--_tab_task[1] = {
	--name = "每日奖励",
	--icon = "UI:next_day",
	--dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	--width = 70,
	--height = 70,
	--quality = hVar.ITEM_QUALITY.WHITE, --品质
	--maxProgress = 1, --最大进度
	--unlockMap = "", --解锁条件
	--taskType = hVar.TASK_TYPE.TASK_DALILY_REWARD, --每日奖励
	--reward =
	--{
		--{7, 10, 0,0},
		--{100, 1, 0,0},
	--},
--}


----商城抽卡
--_tab_task[2] = {
	--name = "商城抽卡",
	--icon = "UI:TACTICCARD_FREETICKET",
	--dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	--width = 62,
	--height = 62,
	--quality = hVar.ITEM_QUALITY.WHITE, --品质
	--maxProgress = 1, --最大进度
	--unlockMap = "", --解锁条件
	--taskType = hVar.TASK_TYPE.TASK_TACTICCARD_ONCE, --商城抽卡
	--reward =
	--{
		--{1, 1000, 0,0},
	--},
--}



----商城抽装
--_tab_task[3] = {
	--name = "商城抽装",
	--icon = "UI:EDCHEST_FREETICKET",
	--dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	--width = 62,
	--height = 62,
	--quality = hVar.ITEM_QUALITY.WHITE, --品质
	--maxProgress = 1, --最大进度
	--unlockMap = "", --解锁条件
	--taskType = hVar.TASK_TYPE.TASK_REDCHEST_ONCE, --商城抽装
	--reward =
	--{
		--{11, 20, 0,0},
	--},
--}



----百炼成钢
--_tab_task[4] = {
	--name = "百炼成钢",
	--icon = "UI:Attr_CritValue",
	--dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	--width = 58,
	--height = 58,
	--quality = hVar.ITEM_QUALITY.WHITE, --品质
	--maxProgress = 1, --最大进度
	--unlockMap = "", --解锁条件
	--taskType = hVar.TASK_TYPE.TASK_EQUIP_XILIAN, --百炼成钢
	--reward =
	--{
		--{1, 2000, 0,0},
	--},
--}



----小试牛刀
--_tab_task[5] = {
	--name = "小试牛刀",
	--icon = "ICON:Item_Weapon09",
	--dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	--width = 56,
	--height = 56,
	--quality = hVar.ITEM_QUALITY.WHITE, --品质
	--maxProgress = 1, --最大进度
	--unlockMap = "", --解锁条件
	--taskType = hVar.TASK_TYPE.TASK_BASE_BATTLE_WIN, --小试牛刀
	--reward =
	--{
		--{15, 9956, 1,0},
	--},
--}



----无尽使命
--_tab_task[6] = {
	--name = "无尽使命",
	--icon = "ICON:HeroAttr_str",
	--dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	--width = 60,
	--height = 60,
	--quality = hVar.ITEM_QUALITY.WHITE, --品质
	--maxProgress = 3000, --最大进度
	--unlockMap = "", --解锁条件
	--taskType = hVar.TASK_TYPE.TASK_ENDLESS_SCORE, --无尽使命
	--reward =
	--{
		--{15, 9973, 1,0},
		--{14, 0, 500,0},
	--},
--}



----竞技锦囊
--_tab_task[7] = {
	--name = "竞技锦囊",
	--icon = "ui/chest_6.png",
	--dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	--width = 74,
	--height = 74,
	--quality = hVar.ITEM_QUALITY.WHITE, --品质
	--maxProgress = 1, --最大进度
	--unlockMap = "", --解锁条件
	--taskType = hVar.TASK_TYPE.TASK_PVP_OPENCHEST, --竞技锦囊
	--reward =
	--{
		--{1, 1000, 0,0},
	--},
--}



----竞技切磋
--_tab_task[8] = {
	--name = "竞技切磋",
	--icon = "ICON:Item_Weapon19",
	--dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	--width = 56,
	--height = 56,
	--quality = hVar.ITEM_QUALITY.WHITE, --品质
	--maxProgress = 1, --最大进度
	--unlockMap = "", --解锁条件
	--taskType = hVar.TASK_TYPE.TASK_PVP_BATTLE, --竞技切磋
	--reward =
	--{
		--{27, 10, 0,0},
		----{15, 9974, 1,0},
		----{13, 1, 10, "6_10501_10_0|6_10502_10_0|6_10503_10_0|6_10505_10_0|6_10504_10_0|6_10506_10_0|6_10507_10_0|6_10509_10_0|6_10512_10_0|6_10514_10_0|6_10515_10_0|6_10516_10_0|6_10518_10_0|6_10517_10_0|6_10508_10_0|6_10513_10_0",},
		--{13, 1, 1, "6_10501_10_0|6_10502_10_0|6_10503_10_0|6_10505_10_0|6_10504_10_0|6_10506_10_0|6_10507_10_0|6_10509_10_0|6_10512_10_0|6_10514_10_0|6_10515_10_0|6_10516_10_0|6_10518_10_0|6_10517_10_0|6_10508_10_0|6_10513_10_0",},
	--},
--}



----兵符达人
--_tab_task[9] = {
	--name = "兵符达人",
	--icon = "UI:uitoken_new",
	--dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	--width = 64,
	--height = 64,
	--quality = hVar.ITEM_QUALITY.WHITE, --品质
	--maxProgress = 30, --最大进度
	--unlockMap = "", --解锁条件
	--taskType = hVar.TASK_TYPE.TASK_PVPTOKEN_USE, --兵符达人
	--reward =
	--{
		--{7, 10, 0,0},
	--},
--}




----击杀指定BOSS [蜘蛛]
--_tab_task[10] = {
	--name = "击杀指定BOSS",
	--icon = "misc/task/task_003.png",
	--dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	--width = 97,
	--height = 65,
	--quality = hVar.ITEM_QUALITY.WHITE, --品质
	--maxProgress = 5, --最大进度
	--unlockMap = "", --解锁条件
	--typeId = 11105, --id [蜘蛛]
	--taskType = hVar.TASK_TYPE.TASK_KILL_BOSS_N, --击杀指定BOSS
	--reward =
	--{
		--{107, 10, 0,0},
		--{100, 2, 0,0},
	--},
--}



----使用指定战术卡 [黑洞]
--_tab_task[11] = {
	--name = "使用指定战术卡",
	--icon = "misc/task/task_000.png",
	--dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	--width = 97,
	--height = 65,
	--quality = hVar.ITEM_QUALITY.WHITE, --品质
	--maxProgress = 10, --最大进度
	--unlockMap = "", --解锁条件
	--typeId = 12023, --id [黑洞]
	--taskType = hVar.TASK_TYPE.TASK_USE_TACTIC_N, --使用指定战术卡
	--reward =
	--{
		--{108, 10, 0,0},
		--{100, 2, 0,0},
	--},
--}

------------------------------------------------------------------------------
--------------------【分享任务】100
_tab_task[100] = {
	name = "每日分享",
	icon = "misc/task/task_019.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 3, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_SHARE_COUINT, --分享次数
	reward =
	{
		{7, 20, 0,0},
		{100, 3, 0,0},
	},
}


------------------------------------------------------------------------------
--------------------【通关关卡任务】101-200


_tab_task[101] = {
	name = "通关关卡-矿山巨兽1",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_spider_01", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[102] = {
	name = "通关关卡-矿山巨兽2",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_spider_02", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[103] = {
	name = "通关关卡-矿山巨兽3",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_spider_03", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[104] = {
	name = "通关关卡-矿山巨兽4",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_spider_04", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[105] = {
	name = "通关关卡-母舰1",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_airship_01", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[106] = {
	name = "通关关卡-母舰2",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_airship_02", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[107] = {
	name = "通关关卡-母舰3",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_airship_03", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[108] = {
	name = "通关关卡-母舰4",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_airship_04", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[109] = {
	name = "通关关卡-异虫1",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_zerg_001", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[110] = {
	name = "通关关卡-异虫2",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_zerg_002", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[111] = {
	name = "通关关卡-异虫3",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_zerg_003", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[112] = {
	name = "通关关卡-异虫4",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_zerg_004", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[113] = {
	name = "通关关卡-魔眼1",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_bio_001", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[114] = {
	name = "通关关卡-魔眼2",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_bio_002", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[115] = {
	name = "通关关卡-魔眼3",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_bio_003", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[116] = {
	name = "通关关卡-魔眼4",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_bio_004", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[117] = {
	name = "通关关卡-空中堡垒1",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_mechanics_001", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[118] = {
	name = "通关关卡-空中堡垒2",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_mechanics_002", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[119] = {
	name = "通关关卡-空中堡垒3",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_mechanics_003", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[120] = {
	name = "通关关卡-空中堡垒4",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_mechanics_004", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[121] = {
	name = "通关关卡-弧反应堆1",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_plate_01", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[122] = {
	name = "通关关卡-弧反应堆2",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_plate_02", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[123] = {
	name = "通关关卡-弧反应堆3",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_plate_03", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[124] = {
	name = "通关关卡-弧反应堆4",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_plate_04", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_N, --通关指定关卡
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}





------------------------------------------------------------------------------
--------------------【无损通关关卡任务】201-300


_tab_task[201] = {
	name = "无损通关关卡-矿山巨兽1",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_spider_01", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[202] = {
	name = "无损通关关卡-矿山巨兽2",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_spider_02", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[203] = {
	name = "无损通关关卡-矿山巨兽3",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_spider_03", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[204] = {
	name = "无损通关关卡-矿山巨兽4",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_spider_04", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[205] = {
	name = "无损通关关卡-母舰1",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_airship_01", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[206] = {
	name = "无损通关关卡-母舰2",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_airship_02", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[207] = {
	name = "无损通关关卡-母舰3",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_airship_03", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[208] = {
	name = "无损通关关卡-母舰4",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_airship_04", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[209] = {
	name = "无损通关关卡-异虫1",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_zerg_001", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[210] = {
	name = "无损通关关卡-异虫2",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_zerg_002", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[211] = {
	name = "无损通关关卡-异虫3",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_zerg_003", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[212] = {
	name = "无损通关关卡-异虫4",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_zerg_004", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[213] = {
	name = "无损通关关卡-魔眼1",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_bio_001", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[214] = {
	name = "无损通关关卡-魔眼2",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_bio_002", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[215] = {
	name = "无损通关关卡-魔眼3",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_bio_003", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[216] = {
	name = "无损通关关卡-魔眼4",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_bio_004", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[217] = {
	name = "无损通关关卡-空中堡垒1",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_mechanics_001", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[218] = {
	name = "无损通关关卡-空中堡垒2",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_mechanics_002", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[219] = {
	name = "无损通关关卡-空中堡垒3",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_mechanics_003", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[220] = {
	name = "无损通关关卡-空中堡垒4",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_mechanics_004", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[221] = {
	name = "无损通关关卡-弧反应堆1",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_plate_01", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[222] = {
	name = "无损通关关卡-弧反应堆2",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_plate_02", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[223] = {
	name = "无损通关关卡-弧反应堆3",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_plate_03", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[224] = {
	name = "无损通关关卡-弧反应堆4",
	icon = "misc/task/task_001.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_plate_04", --关卡ID
	difficulty = 0, --难度
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N, --无损通关指定关卡
	reward =
	{
		{11, 10, 0,0},
		{100, 2, 0,0},
	},
}






------------------------------------------------------------------------------
--------------------【刷新商店任务】


_tab_task[301] = {
	name = "刷新1次商店",
	icon = "misc/task/task_006.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_REFRESH_SHOP, --刷新商店
	reward =
	{
		{7, 20, 0,0},
		{100, 2, 0,0},
	},
}


------------------------------------------------------------------------------
--------------------【开启武器宝箱任务】


_tab_task[311] = {
	name = "开启武器宝箱1次",
	icon = "misc/task/task_000.png",
	icon_sub = "icon/item/chest_1.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_OPEN_WEPONCHEST, --武器宝箱
	reward =
	{
		{7, 10, 0,0},
		{100, 1, 0,0},
	},
}



------------------------------------------------------------------------------
--------------------【开启战术宝箱任务】


_tab_task[321] = {
	name = "开启战术宝箱1次",
	icon = "misc/task/task_000.png",
	icon_sub = "icon/item/chest_2.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_OPEN_TACTICCHEST, --战术宝箱
	reward =
	{
		{7, 10, 0,0},
		{100, 1, 0,0},
	},
}


------------------------------------------------------------------------------
--------------------【开启宠物宝箱任务】


_tab_task[331] = {
	name = "开启宠物宝箱1次",
	icon = "misc/task/task_000.png",
	icon_sub = "icon/item/chest_3.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_OPEN_PETCHEST, --宠物宝箱
	reward =
	{
		{7, 10, 0,0},
		{100, 1, 0,0},
	},
}

------------------------------------------------------------------------------
--------------------【开启装备宝箱任务】



_tab_task[341] = {
	name = "开启装备宝箱1次",
	icon = "misc/task/task_000.png",
	icon_sub = "icon/item/chest_4.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_OPEN_EQUIPCHEST, --装备宝箱
	reward =
	{
		{7, 10, 0,0},
		{100, 1, 0,0},
	},
}

------------------------------------------------------------------------------
--------------------【累计击杀敌人任务】


_tab_task[351] = {
	name = "累计击杀敌人100次",
	icon = "misc/task/task_003.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 100, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_KILL_ENEMY, --击杀敌人
	reward =
	{
		{105, 5, 0,0},
		{100, 1, 0,0},
	},
}



_tab_task[352] = {
	name = "累计击杀敌人200次",
	icon = "misc/task/task_003.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 200, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_KILL_ENEMY, --击杀敌人
	reward =
	{
		{105, 10, 0,0},
		{100, 2, 0,0},
	},
}


_tab_task[353] = {
	name = "累计击杀敌人300次",
	icon = "misc/task/task_003.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 300, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_KILL_ENEMY, --击杀敌人
	reward =
	{
		{105, 15, 0,0},
		{100, 3, 0,0},
	},
}





------------------------------------------------------------------------------
--------------------【累计击杀BOSS任务】


_tab_task[361] = {
	name = "累计击杀5个BOSS",
	icon = "misc/task/task_003.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 5, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_KILL_BOSS, --击杀BOSS
	reward =
	{
		{105, 5, 0,0},
		{100, 1, 0,0},
	},
}


_tab_task[362] = {
	name = "累计击杀10个BOSS",
	icon = "misc/task/task_003.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 10, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_KILL_BOSS, --击杀BOSS
	reward =
	{
		{105, 10, 0,0},
		{100, 2, 0,0},
	},
}


_tab_task[363] = {
	name = "累计击杀15个BOSS",
	icon = "misc/task/task_003.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 15, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_KILL_BOSS, --击杀BOSS
	reward =
	{
		{105, 15, 0,0},
		{100, 3, 0,0},
	},
}


------------------------------------------------------------------------------
--------------------【累计使用战术卡任务】


_tab_task[371] = {
	name = "累计使用战术卡30次",
	icon = "misc/task/task_002.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 30, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_USE_TACTIC, --使用战术卡
	reward =
	{
		{7, 5, 0,0},
		{100, 1, 0,0},
	},
}


_tab_task[372] = {
	name = "累计使用战术卡60次",
	icon = "misc/task/task_002.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 60, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_USE_TACTIC, --使用战术卡
	reward =
	{
		{7, 10, 0,0},
		{100, 2, 0,0},
	},
}


_tab_task[373] = {
	name = "累计使用战术卡90次",
	icon = "misc/task/task_002.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 90, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_USE_TACTIC, --使用战术卡
	reward =
	{
		{7, 15, 0,0},
		{100, 3, 0,0},
	},
}

------------------------------------------------------------------------------
--------------------【累计拯救科学家任务】


_tab_task[381] = {
	name = "累计拯救科学家10个",
	icon = "misc/task/task_004.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 10, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_RESCUE_SCIENTIST, --拯救科学家
	reward =
	{
		{107, 5, 0,0},
		{100, 1, 0,0},
	},
}


--累计拯救科学家
_tab_task[382] = {
	name = "累计拯救科学家20个",
	icon = "misc/task/task_004.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 20, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_RESCUE_SCIENTIST, --拯救科学家
	reward =
	{
		{107, 10, 0,0},
		{100, 2, 0,0},
	},
}


--累计拯救科学家
_tab_task[383] = {
	name = "累计拯救科学家30个",
	icon = "misc/task/task_004.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 30, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_RESCUE_SCIENTIST, --拯救科学家
	reward =
	{
		{107, 15, 0,0},
		{100, 3, 0,0},
	},
}


------------------------------------------------------------------------------
--------------------【前哨阵地波次任务】


_tab_task[391] = {
	name = "前哨阵地5波",
	icon = "misc/task/task_008.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 5, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_QSZD_WAVE, --前哨阵地波次
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[392] = {
	name = "前哨阵地10波",
	icon = "misc/task/task_008.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 10, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_QSZD_WAVE, --前哨阵地波次
	reward =
	{
		{108, 10, 0,0},
		{100, 2, 0,0},
	},
}


_tab_task[393] = {
	name = "前哨阵地15波",
	icon = "misc/task/task_008.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 15, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_QSZD_WAVE, --前哨阵地波次
	reward =
	{
		{108, 15, 0,0},
		{100, 3, 0,0},
	},
}


------------------------------------------------------------------------------
--------------------【随机迷宫层数任务】


_tab_task[401] = {
	name = "随机迷宫2-1层",
	icon = "misc/task/task_007.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 21, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_RANDOMMAP_STAGE, --随机迷宫层数
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[402] = {
	name = "随机迷宫3-1层",
	icon = "misc/task/task_007.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 31, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_RANDOMMAP_STAGE, --随机迷宫层数
	reward =
	{
		{108, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[403] = {
	name = "随机迷宫4-1层",
	icon = "misc/task/task_007.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 41, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_RANDOMMAP_STAGE, --随机迷宫层数
	reward =
	{
		{108, 15, 0,0},
		{100, 3, 0,0},
	},
}

_tab_task[404] = {
	name = "随机迷宫5-1层",
	icon = "misc/task/task_007.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 51, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_RANDOMMAP_STAGE, --随机迷宫层数
	reward =
	{
		{108, 20, 0,0},
		{100, 5, 0,0},
	},
}


------------------------------------------------------------------------------
--------------------【累计战车死亡任务】


_tab_task[411] = {
	name = "累计战车死亡3次",
	icon = "misc/task/task_012.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 3, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_DEADTH, --战车死亡
	reward =
	{
		{107, 5, 0,0},
		{100, 1, 0,0},
	},
}

_tab_task[412] = {
	name = "累计战车死亡6次",
	icon = "misc/task/task_012.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 6, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_DEADTH, --战车死亡
	reward =
	{
		{107, 10, 0,0},
		{100, 2, 0,0},
	},
}

_tab_task[413] = {
	name = "累计战车死亡9次",
	icon = "misc/task/task_012.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 9, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_DEADTH, --战车死亡
	reward =
	{
		{107, 15, 0,0},
		{100, 3, 0,0},
	},
}


------------------------------------------------------------------------------
--------------------【累计宠物跟随数量任务】


_tab_task[421] = {
	name = "【同时最多跟随3个宠物】",
	icon = "misc/task/task_013.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 3, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_MAX_PET_FOLLOW_AMOUNT, --宠物跟随数量
	reward =
	{
		{107, 5, 0,0},
		{100, 1, 0,0},
	},
}
_tab_task[422] = {
	name = "【同时最多跟随6个宠物】",
	icon = "misc/task/task_013.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 6, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_MAX_PET_FOLLOW_AMOUNT, --宠物跟随数量
	reward =
	{
		{107, 10, 0,0},
		{100, 2, 0,0},
	},
}
_tab_task[423] = {
	name = "【同时最多跟随9个宠物】",
	icon = "misc/task/task_013.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 9, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_MAX_PET_FOLLOW_AMOUNT, --宠物跟随数量
	reward =
	{
		{107, 15, 0,0},
		{100, 3, 0,0},
	},
}


------------------------------------------------------------------------------
--------------------【累计使用芯片改造装备次数任务】



_tab_task[431] = {
	name = "【累计使用芯片改造装备3次】",
	icon = "misc/task/task_015.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 3, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_USE_CHIP_TO_REFORM_EQUIP_TIMES, --使用芯片改造装备次数
	reward =
	{
		{11, 10, 0,0},
		{100, 1, 0,0},
	},
}
_tab_task[432] = {
	name = "【累计使用芯片改造装备6次】",
	icon = "misc/task/task_015.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 6, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_USE_CHIP_TO_REFORM_EQUIP_TIMES, --使用芯片改造装备次数
	reward =
	{
		{11, 20, 0,0},
		{100, 2, 0,0},
	},
}
_tab_task[433] = {
	name = "【累计使用芯片改造装备9次】",
	icon = "misc/task/task_015.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 9, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_USE_CHIP_TO_REFORM_EQUIP_TIMES, --使用芯片改造装备次数
	reward =
	{
		{11, 30, 0,0},
		{100, 3, 0,0},
	},
}



------------------------------------------------------------------------------
--------------------【累计升级任意战术卡次数任务】



_tab_task[441] = {
	name = "【累计升级任意战术卡1次】",
	icon = "misc/task/task_002.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_UPGRADE_TACTICAL_CARD_TIMES, --升级任意战术卡次数
	reward =
	{
		{107, 5, 0,0},
		{100, 1, 0,0},
	},
}
_tab_task[442] = {
	name = "【累计升级任意战术卡2次】",
	icon = "misc/task/task_002.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 2, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_UPGRADE_TACTICAL_CARD_TIMES, --升级任意战术卡次数
	reward =
	{
		{107, 10, 0,0},
		{100, 2, 0,0},
	},
}
_tab_task[443] = {
	name = "【累计升级任意战术卡3次】",
	icon = "misc/task/task_002.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 3, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_UPGRADE_TACTICAL_CARD_TIMES, --升级任意战术卡次数
	reward =
	{
		{107, 15, 0,0},
		{100, 3, 0,0},
	},
}


------------------------------------------------------------------------------
--------------------【累计升级任意枪塔武器次数任务】



_tab_task[451] = {
	name = "【累计升级任意枪塔武器1次】",
	icon = "misc/task/task_014.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_UPGRADE_WEAPON_TIMES, --升级任意枪塔武器次数
	reward =
	{
		{107, 5, 0,0},
		{100, 1, 0,0},
	},
}
_tab_task[452] = {
	name = "【累计升级任意枪塔武器2次】",
	icon = "misc/task/task_014.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 2, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_UPGRADE_WEAPON_TIMES, --升级任意枪塔武器次数
	reward =
	{
		{107, 10, 0,0},
		{100, 2, 0,0},
	},
}
_tab_task[453] = {
	name = "【累计升级任意枪塔武器3次】",
	icon = "misc/task/task_014.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 3, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_UPGRADE_WEAPON_TIMES, --升级任意枪塔武器次数
	reward =
	{
		{107, 15, 0,0},
		{100, 3, 0,0},
	},
}


------------------------------------------------------------------------------
--------------------【累计升级任意宠物次数任务】



_tab_task[461] = {
	name = "【累计升级任意宠物1次】",
	icon = "misc/task/task_013.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_UPGRADE_PET_TIMES, --升级任意宠物次数
	reward =
	{
		{107, 5, 0,0},
		{100, 1, 0,0},
	},
}
_tab_task[462] = {
	name = "【累计升级任意宠物2次】",
	icon = "misc/task/task_013.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 2, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_UPGRADE_PET_TIMES, --升级任意宠物次数
	reward =
	{
		{107, 10, 0,0},
		{100, 2, 0,0},
	},
}
_tab_task[463] = {
	name = "【累计升级任意宠物3次】",
	icon = "misc/task/task_013.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 3, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_UPGRADE_PET_TIMES, --升级任意宠物次数
	reward =
	{
		{107, 15, 0,0},
		{100, 3, 0,0},
	},
}


------------------------------------------------------------------------------
--------------------【通关关卡难度任务】501-600


_tab_task[501] = {
	name = "通关关卡难度1-母巢之战",
	icon = "misc/task/task_013.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_ex_001", --关卡ID
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_DIFFICULTY_N, --通关指定关卡难度
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}
_tab_task[502] = {
	name = "通关关卡难度2-母巢之战",
	icon = "misc/task/task_013.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 2, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_ex_001", --关卡ID
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_DIFFICULTY_N, --通关指定关卡难度
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}
_tab_task[503] = {
	name = "通关关卡难度3-母巢之战",
	icon = "misc/task/task_013.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 3, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_ex_001", --关卡ID
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_DIFFICULTY_N, --通关指定关卡难度
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}


_tab_task[521] = {
	name = "通关关卡简单难度-夺宝奇兵",
	icon = "misc/task/task_013.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_ex_003", --关卡ID
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_DIFFICULTY_N, --通关指定关卡难度
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}
_tab_task[522] = {
	name = "通关关卡正常难度-夺宝奇兵",
	icon = "misc/task/task_013.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 2, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_ex_003", --关卡ID
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_DIFFICULTY_N, --通关指定关卡难度
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}
_tab_task[523] = {
	name = "通关关卡困难难度-夺宝奇兵",
	icon = "misc/task/task_013.png",
	dailyType = hVar.TASK_DAILY_TYPE.DAY, --每日任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 3, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_ex_003", --关卡ID
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_DIFFICULTY_N, --通关指定关卡难度
	reward =
	{
		{108, 5, 0,0},
		{100, 1, 0,0},
	},
}


---====================================================================================================
-------------------------【每周任务】----------------------------------------------
---====================================================================================================



-----------------------------------------------------------------------------

_tab_task[1001] = {
	name = "开启武器宝箱20次",
	icon = "misc/task/task_000.png",
	icon_sub = "icon/item/chest_1.png",
	dailyType = hVar.TASK_DAILY_TYPE.WEEK, --周任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 20, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_OPEN_WEPONCHEST, --武器宝箱
	reward =
	{
		{7, 50, 0,0},
		{100, 10, 0,0},
	},
}

_tab_task[1002] = {
	name = "开启战术宝箱20次",
	icon = "misc/task/task_000.png",
	icon_sub = "icon/item/chest_2.png",
	dailyType = hVar.TASK_DAILY_TYPE.WEEK, --周任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 20, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_OPEN_TACTICCHEST, --战术宝箱
	reward =
	{
		{7, 50, 0,0},
		{100, 10, 0,0},
	},
}

_tab_task[1003] = {
	name = "开启宠物宝箱20次",
	icon = "misc/task/task_000.png",
	icon_sub = "icon/item/chest_3.png",
	dailyType = hVar.TASK_DAILY_TYPE.WEEK, --周任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 20, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_OPEN_PETCHEST, --宠物宝箱
	reward =
	{
		{7, 50, 0,0},
		{100, 10, 0,0},
	},
}

_tab_task[1004] = {
	name = "开启装备宝箱20次",
	icon = "misc/task/task_000.png",
	icon_sub = "icon/item/chest_4.png",
	dailyType = hVar.TASK_DAILY_TYPE.WEEK, --周任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 20, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_OPEN_EQUIPCHEST, --装备宝箱
	reward =
	{
		{7, 50, 0,0},
		{100, 10, 0,0},
	},
}

_tab_task[1005] = {
	name = "累计击杀敌人1000次",
	icon = "misc/task/task_003.png",
	dailyType = hVar.TASK_DAILY_TYPE.WEEK, --周任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1000, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_KILL_ENEMY, --击杀敌人
	reward =
	{
		{11, 50, 0,0},
		{100, 10, 0,0},
	},
}


_tab_task[1006] = {
	name = "累计拯救科学家80个",
	icon = "misc/task/task_004.png",
	dailyType = hVar.TASK_DAILY_TYPE.WEEK, --周任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 80, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_RESCUE_SCIENTIST, --拯救科学家
	reward =
	{
		{107, 30, 0,0},
		{100, 10, 0,0},
	},
}

_tab_task[1007] = {
	name = "累计战车死亡30次",
	icon = "misc/task/task_012.png",
	dailyType = hVar.TASK_DAILY_TYPE.WEEK, --周任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 30, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_DEADTH, --战车死亡
	reward =
	{
		{11, 50, 0,0},
		{100, 10, 0,0},
	},
}

_tab_task[1008] = {
	name = "前哨阵地30波",
	icon = "misc/task/task_008.png",
	dailyType = hVar.TASK_DAILY_TYPE.WEEK, --周任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 30, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_QSZD_WAVE, --前哨阵地波次
	reward =
	{
		{108, 30, 0,0},
		{100, 10, 0,0},
	},
}

_tab_task[1009] = {
	name = "随机迷宫6-1层",
	icon = "misc/task/task_007.png",
	dailyType = hVar.TASK_DAILY_TYPE.WEEK, --周任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 61, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_RANDOMMAP_STAGE, --随机迷宫层数
	reward =
	{
		{108, 30, 0,0},
		{100, 10, 0,0},
	},
}


_tab_task[1010] = {
	name = "累计击杀50个BOSS",
	icon = "misc/task/task_003.png",
	dailyType = hVar.TASK_DAILY_TYPE.WEEK, --周任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 50, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_KILL_BOSS, --击杀BOSS
	reward =
	{
		{105, 30, 0,0},
		{100, 10, 0,0},
	},
}


_tab_task[1011] = {
	name = "累计使用战术卡300次",
	icon = "misc/task/task_002.png",
	dailyType = hVar.TASK_DAILY_TYPE.WEEK, --周任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 300, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_USE_TACTIC, --使用战术卡
	reward =
	{
		{108, 30, 0,0},
		{100, 10, 0,0},
	},
}


_tab_task[1012] = {
	name = "同时最多跟随15个宠物",
	icon = "misc/task/task_013.png",
	dailyType = hVar.TASK_DAILY_TYPE.WEEK, --周任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 15, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_MAX_PET_FOLLOW_AMOUNT, --宠物跟随数量
	reward =
	{
		{107, 30, 0,0},
		{100, 10, 0,0},
	},
}


_tab_task[1013] = {
	name = "累计使用芯片改造装备20次",
	icon = "misc/task/task_015.png",
	dailyType = hVar.TASK_DAILY_TYPE.WEEK, --周任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 20, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_USE_CHIP_TO_REFORM_EQUIP_TIMES, --使用芯片改造装备次数
	reward =
	{
		{11, 50, 0,0},
		{100, 10, 0,0},
	},
}


_tab_task[1014] = {
	name = "累计升级任意战术卡10次",
	icon = "misc/task/task_002.png",
	dailyType = hVar.TASK_DAILY_TYPE.WEEK, --周任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 10, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_UPGRADE_TACTICAL_CARD_TIMES, --升级任意战术卡次数
	reward =
	{
		{7, 80, 0,0},
		{100, 10, 0,0},
	},
}


_tab_task[1015] = {
	name = "累计升级任意枪塔武器10次",
	icon = "misc/task/task_014.png",
	dailyType = hVar.TASK_DAILY_TYPE.WEEK, --周任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 10, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_UPGRADE_WEAPON_TIMES, --升级任意枪塔武器次数
	reward =
	{
		{7, 80, 0,0},
		{100, 10, 0,0},
	},
}


_tab_task[1016] = {
	name = "累计升级任意宠物10次",
	icon = "misc/task/task_013.png",
	dailyType = hVar.TASK_DAILY_TYPE.WEEK, --周任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 10, --最大进度
	unlockMap = "", --解锁条件
	taskType = hVar.TASK_TYPE.TASK_UPGRADE_PET_TIMES, --升级任意宠物次数
	reward =
	{
		{7, 80, 0,0},
		{100, 10, 0,0},
	},
}


_tab_task[1017] = {
	name = "通关母巢之战-难度1",
	icon = "misc/task/task_016.png",
	dailyType = hVar.TASK_DAILY_TYPE.WEEK, --周任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_ex_001", --关卡ID
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_DIFFICULTY_N, --通关指定关卡难度
	reward =
	{
		{7, 50, 0,0},
		{100, 10, 0,0},
	},
}


_tab_task[1018] = {
	name = "通关夺宝奇兵-简单难度",
	icon = "misc/task/task_018.png",
	dailyType = hVar.TASK_DAILY_TYPE.WEEK, --周任务
	width = 97,
	height = 65,
	quality = hVar.ITEM_QUALITY.WHITE, --品质
	maxProgress = 1, --最大进度
	unlockMap = "", --解锁条件
	typeId = "world/yxys_ex_003", --关卡ID
	taskType = hVar.TASK_TYPE.TASK_MAP_SUCCESS_DIFFICULTY_N, --通关指定关卡难度
	reward =
	{
		{7, 50, 0,0},
		{100, 10, 0,0},
	},
}