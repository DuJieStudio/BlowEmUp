--本地文件
g_outsyncfilepath=".\\log\\outsync\\"
g_serverLog=".\\log\\"

--网络error定义
hVar.DBNETERR = 
{
	UNKNOW_ERROR = 0,				--未知错误
	UPDATE_BILLBOARD_RANK_FAILED = 1,		--更新排行榜数据失败

	--pvp_server搬过来的功能
	GET_PVPCOIN_EVERYDAY_FAILD = 29,		--每日领取兵符失败
	HALL_REWARD_PVPCHEST_FAILD = 31,		--兑换竞技场宝箱失败
	HALL_OPEN_PVPCHEST_FAILD = 32,			--打开竞技场宝箱失败
	HALL_HERO_STARLVUP_FAILD = 34,			--英雄升星失败
	HALL_ARMY_LVUP_FAILD = 35,			--兵种卡升级失败
	HALL_HERO_UNLOCK_FAILD = 44,			--英雄解锁失败
	GET_BUY_PVPCOIN_FAILD = 45,			--购买兵符失败
	HALL_ARMY_REFRESH_ADDONES_FAILD = 46,		--刷新战术卡附加属性失败
	HALL_ARMY_NEW_ADDONES_FAILD = 47,		--新增战术卡附加属性失败
	HALL_ARMY_RESTORE_ADDONES_FAILD = 48,		--还原战术卡附加属性失败

}

--军团币兑换宝箱需要数量
hVar.GROUP_COIN_ECHANGE_CHEST_NUM = 100

--游戏币一次性获取最大值（gm除外）
hVar.ROLE_GAMECOIN_ADD_MAXNUM = 18000

--每日可领取分享奖励的最大次数
hVar.ROLE_DAILY_SHAREREWARD_MAXCOUNT = 3

--宝物属性位
hVar.TREASURE_ATTR =
{
	NONE = 0,					--无
	PVP_WINCOUNT_CAOCAO = 1,			--竞技场使用曹操胜利场次
	PVP_WINCOUNT_LIUGUANZHANG = 2,			--竞技场使用刘关张胜利场次
	PVP_WINCOUNT_ZHOUYUXIAOQIAO = 3,		--竞技场使用周瑜小乔胜利场次
	TONGQUETAI_WINCOUNT_EAZY_DEATH1 = 4,		--铜雀台最多死1次通关简单难度次数
	TONGQUETAI_WINCOUNT_DIFFICULT = 5,		--铜雀台通关噩梦难度次数
	TONGQUETAI_WINCOUNT_DIFFICULT_USE_WUHU = 6,	--铜雀台使用五虎上将通关噩梦难度次数
	ENDLESS_WINCOUNT_LIUGUANZHANG = 7,		--无尽试炼使用刘关张通关次数
	ENDLESS_WINCOUNT_LVBU_DIAOCHAN = 8,		--无尽试炼使用吕布貂蝉通关次数
	QUNYINGGE_WINCOUNT_10_CAOCAO = 9,		--群英阁10+难度使用曹操通关次数
	QUNYINGGE_WINCOUNT_PURPLECARD_NUM = 10,		--群英阁、人族无敌胜利抽到紫卡数量
	QUNYINGGE_WINCOUNT_10_BUILD_JUPAOTA_10 = 11,	--群英阁10+难度建造10个巨炮塔抽到巨炮精研
	QUNYINGGE_WINCOUNT_5_BUILD_JUJITA_10 = 12,	--群英阁5+难度建造10个狙击塔抽到全屏卡
	MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_PANGTONG = 13,	--魔塔杀阵使用诸葛亮庞统通关次数
	MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_HUANGYUEYING = 14,	--魔塔杀阵使用诸葛亮黄月英通关次数
	HERO_COUNT_WEI = 15,				--魏国英雄总数量
	HERO_COUNT_FEMALE = 16,				--女性英雄总数量
	OPEN_PVP_CHEST = 17,				--开启战功锦囊
	EQUIP_XILIAN_LOCK = 18,				--锁孔洗炼红装
	EQUIP_COUNT_MOUNT_SLOT4 = 19,			--累计获得4孔坐骑数量
	TOWER_COUNT_LV5 = 20,				--五级塔总数量
	CHAPTER_UNLOCKED_NUM = 21,			--解锁章节总数量
	HERO_COUNT_LV15 = 22,				--15级英雄总数量
	CONSUME_GAMECOIN_TOTALNUM = 23,			--累计消耗游戏币
	UNLOCK_SLOT_TOTALNUM = 24,			--累计打孔次数
	REDEQUIP_MERGE_SLOT3_COUNT = 25,		--合成3孔红装次数
	QUNYINGGE_WINCOUNT_5_CLEARWUGUI = 26,		--群英阁5+难度全清乌龟怪次数
	
	ATTR_MAXCOUNT = 26,
}

--宝物属性位叠加规则
hVar.TREASURE_ATTR_INCREASE_TYPE =
{
	ADD = 1,		--相加
	COVER = 2,		--覆盖
	MIN = 3,		--取较小值
	MAX = 4,		--取较大值
}

--宝物属性位叠加规则
hVar.TREASURE_ATTR_INCREASE_TYPE_LIST =
{
	[hVar.TREASURE_ATTR.PVP_WINCOUNT_CAOCAO] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.PVP_WINCOUNT_LIUGUANZHANG] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.PVP_WINCOUNT_ZHOUYUXIAOQIAO] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_EAZY_DEATH1] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_DIFFICULT] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.TONGQUETAI_WINCOUNT_DIFFICULT_USE_WUHU] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.ENDLESS_WINCOUNT_LIUGUANZHANG] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.ENDLESS_WINCOUNT_LVBU_DIAOCHAN] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_10_CAOCAO] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_PURPLECARD_NUM] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_10_BUILD_JUPAOTA_10] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_5_BUILD_JUJITA_10] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_PANGTONG] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.MOTASHAZHEN_WINCOUNT_USE_ZHUGELIANG_HUANGYUEYING] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.HERO_COUNT_WEI] = hVar.TREASURE_ATTR_INCREASE_TYPE.COVER, --覆盖
	[hVar.TREASURE_ATTR.HERO_COUNT_FEMALE] = hVar.TREASURE_ATTR_INCREASE_TYPE.COVER, --覆盖
	[hVar.TREASURE_ATTR.OPEN_PVP_CHEST] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.EQUIP_XILIAN_LOCK] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.EQUIP_COUNT_MOUNT_SLOT4] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.TOWER_COUNT_LV5] = hVar.TREASURE_ATTR_INCREASE_TYPE.COVER, --覆盖
	[hVar.TREASURE_ATTR.CHAPTER_UNLOCKED_NUM] = hVar.TREASURE_ATTR_INCREASE_TYPE.COVER, --覆盖
	[hVar.TREASURE_ATTR.HERO_COUNT_LV15] = hVar.TREASURE_ATTR_INCREASE_TYPE.COVER, --覆盖
	[hVar.TREASURE_ATTR.CONSUME_GAMECOIN_TOTALNUM] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.UNLOCK_SLOT_TOTALNUM] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.REDEQUIP_MERGE_SLOT3_COUNT] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TREASURE_ATTR.QUNYINGGE_WINCOUNT_5_CLEARWUGUI] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
}

--任务（新）类型
hVar.TASK_TYPE =
{
	TASK_DALILY_REWARD = 1,			--每日奖励
	TASK_TACTICCARD_ONCE = 2,		--商城抽卡
	TASK_REDCHEST_ONCE = 3,			--商城抽装
	TASK_REFRESH_SHOP = 4,			--刷新商店
	TASK_EQUIP_XILIAN = 5,			--百炼成钢
	TASK_BASE_BATTLE_WIN = 6,		--小试牛刀
	TASK_ENDLESS_SCORE = 7,			--无尽使命
	TASK_QSZD_WAVE = 8,			--前哨阵地波次
	TASK_RANDOMMAP_STAGE = 9,		--随机迷宫层数
	TASK_PVP_OPENCHEST = 10,		--竞技锦囊
	TASK_PVP_BATTLE = 11,			--竞技切磋
	TASK_PVPTOKEN_USE = 12,			--兵符达人
	TASK_OPEN_WEPONCHEST = 13,		--武器宝箱
	TASK_OPEN_TACTICCHEST = 14,		--战术宝箱
	TASK_OPEN_PETCHEST = 15,		--宠物宝箱
	TASK_OPEN_EQUIPCHEST = 16,		--装备宝箱
	TASK_KILL_ENEMY = 17,			--击杀敌人
	TASK_KILL_BOSS = 18,			--击杀BOSS
	TASK_DEADTH = 19,			--战车死亡
	TASK_USE_TACTIC = 20,			--使用战术卡
	TASK_RESCUE_SCIENTIST = 21,		--拯救科学家
	TASK_MAP_SUCCESS_N = 22,		--通关指定关卡
	TASK_MAP_SUCCESS_NOHURT_N = 23,		--无损通关指定关卡
	TASK_KILL_BOSS_N = 24,			--击杀指定BOSS
	TASK_USE_TACTIC_N = 25,			--使用指定战术卡
	TASK_MAX_PET_FOLLOW_AMOUNT = 26,	--宠物跟随数量
	TASK_USE_CHIP_TO_REFORM_EQUIP_TIMES = 27,--使用芯片改造装备次数
	TASK_UPGRADE_TACTICAL_CARD_TIMES = 28,	--升级任意战术卡次数
	TASK_UPGRADE_WEAPON_TIMES = 29,		--升级任意枪塔武器次数
	TASK_UPGRADE_PET_TIMES = 30,		--升级任意宠物次数
	TASK_MAP_SUCCESS_DIFFICULTY_N = 31,	--通关指定关卡难度
	TASK_SHARE_COUINT = 32,			--分享次数
}

--任务（新）的日期类型
hVar.TASK_DAILY_TYPE =
{
	DAY = 1,	--每日任务
	WEEK = 2,	--周任务
}

--任务（新）的周任务奖励需要任务之石数量
hVar.TASK_STONE_COST =
{
	[1] = {num = 10, reward = {7, 30, 0, 0,},},
	[2] = {num = 30, reward = {106, 50, 0, 0,},},
	[3] = {num = 50, reward = {107, 70, 0, 0,},},
	[4] = {num = 70, reward = {108, 90, 0, 0,},},
	[5] = {num = 100, reward = {11, 188, 0, 0,},},
}

--任务（新）类型对应的数据库字段
hVar.TASK_DBKEY =
{
	[hVar.TASK_TYPE.TASK_DALILY_REWARD] = "task_daily",
	[hVar.TASK_TYPE.TASK_TACTICCARD_ONCE] = "task_drawcard",
	[hVar.TASK_TYPE.TASK_REDCHEST_ONCE] = "task_redchest",
	[hVar.TASK_TYPE.TASK_REFRESH_SHOP] = "task_refreshshop",
	[hVar.TASK_TYPE.TASK_EQUIP_XILIAN] = "task_xilian",
	[hVar.TASK_TYPE.TASK_BASE_BATTLE_WIN] = "task_battle_pve",
	[hVar.TASK_TYPE.TASK_ENDLESS_SCORE] = "task_endless",
	[hVar.TASK_TYPE.TASK_QSZD_WAVE] = "task_qszdwave",
	[hVar.TASK_TYPE.TASK_RANDOMMAP_STAGE] = "task_randmapstage",
	[hVar.TASK_TYPE.TASK_PVP_OPENCHEST] = "task_pvp_chest",
	[hVar.TASK_TYPE.TASK_PVP_BATTLE] = "task_pvp_battle",
	[hVar.TASK_TYPE.TASK_PVPTOKEN_USE] = "task_pvpcoin",
	[hVar.TASK_TYPE.TASK_OPEN_WEPONCHEST] = "task_weaponchest",
	[hVar.TASK_TYPE.TASK_OPEN_TACTICCHEST] = "task_tacticchest",
	[hVar.TASK_TYPE.TASK_OPEN_PETCHEST] = "task_petchest",
	[hVar.TASK_TYPE.TASK_OPEN_EQUIPCHEST] = "task_equipchest",
	[hVar.TASK_TYPE.TASK_KILL_ENEMY] = "task_killenemy",
	[hVar.TASK_TYPE.TASK_KILL_BOSS] = "task_killboss",
	[hVar.TASK_TYPE.TASK_DEADTH] = "task_deadth",
	[hVar.TASK_TYPE.TASK_USE_TACTIC] = "task_usetactic",
	[hVar.TASK_TYPE.TASK_RESCUE_SCIENTIST] = "task_scientist",
	[hVar.TASK_TYPE.TASK_MAP_SUCCESS_N] = "task_mapsuccess_n",
	[hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N] = "task_mapsuccess_nohurt_n",
	[hVar.TASK_TYPE.TASK_KILL_BOSS_N] = "task_killboss_n",
	[hVar.TASK_TYPE.TASK_USE_TACTIC_N] = "task_usetactic_n",
	[hVar.TASK_TYPE.TASK_MAX_PET_FOLLOW_AMOUNT] = "task_max_pet_follow_amount",
	[hVar.TASK_TYPE.TASK_USE_CHIP_TO_REFORM_EQUIP_TIMES] = "task_use_chip_to_reform_equip_times",
	[hVar.TASK_TYPE.TASK_UPGRADE_TACTICAL_CARD_TIMES] = "task_upgrade_tactical_card_times",
	[hVar.TASK_TYPE.TASK_UPGRADE_WEAPON_TIMES] = "task_upgrade_weapon_times",
	[hVar.TASK_TYPE.TASK_UPGRADE_PET_TIMES] = "task_upgrade_pet_times",
	[hVar.TASK_TYPE.TASK_MAP_SUCCESS_DIFFICULTY_N] = "task_map_success_difficulty_n",
	[hVar.TASK_TYPE.TASK_SHARE_COUINT] = "task_sharecount",
}

--任务（新）类型叠加规则
hVar.TASK_INCREASE_TYPE =
{
	[hVar.TASK_TYPE.TASK_DALILY_REWARD] = hVar.TREASURE_ATTR_INCREASE_TYPE.COVER, --覆盖
	[hVar.TASK_TYPE.TASK_TACTICCARD_ONCE] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_REDCHEST_ONCE] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_REFRESH_SHOP] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_EQUIP_XILIAN] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_BASE_BATTLE_WIN] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_ENDLESS_SCORE] = hVar.TREASURE_ATTR_INCREASE_TYPE.MAX, --取较大值
	[hVar.TASK_TYPE.TASK_QSZD_WAVE] = hVar.TREASURE_ATTR_INCREASE_TYPE.MAX, --取较大值
	[hVar.TASK_TYPE.TASK_RANDOMMAP_STAGE] = hVar.TREASURE_ATTR_INCREASE_TYPE.MAX, --取较大值
	[hVar.TASK_TYPE.TASK_PVP_OPENCHEST] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_PVP_BATTLE] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_PVPTOKEN_USE] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_OPEN_WEPONCHEST] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_OPEN_TACTICCHEST] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_OPEN_PETCHEST] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_OPEN_EQUIPCHEST] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_KILL_ENEMY] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_KILL_BOSS] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_DEADTH] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_USE_TACTIC] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_RESCUE_SCIENTIST] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_MAP_SUCCESS_N] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_KILL_BOSS_N] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_USE_TACTIC_N] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_MAX_PET_FOLLOW_AMOUNT] = hVar.TREASURE_ATTR_INCREASE_TYPE.MAX, --取最大值
	[hVar.TASK_TYPE.TASK_USE_CHIP_TO_REFORM_EQUIP_TIMES] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_UPGRADE_TACTICAL_CARD_TIMES] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_UPGRADE_WEAPON_TIMES] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_UPGRADE_PET_TIMES] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
	[hVar.TASK_TYPE.TASK_MAP_SUCCESS_DIFFICULTY_N] = hVar.TREASURE_ATTR_INCREASE_TYPE.MAX, --取最大值
	[hVar.TASK_TYPE.TASK_SHARE_COUINT] = hVar.TREASURE_ATTR_INCREASE_TYPE.ADD, --相加
}

hVar.GuideMap = "world/csys_000" --引导关
hVar.MainBase = "world/start_001"	--主基地
hVar.LoginMap = "world/csys_ex_002_randommap"	--登录界面地图
hVar.RandomMap = "world/csys_random_test" --随机迷宫地图
hVar.QianShaoZhenDiMap = "world/yxys_ex_002" --前哨阵地地图
hVar.MuChaoZhiZhanMap = "world/yxys_ex_001" --母巢之战地图
hVar.DuoBaoQiBingMap = "world/yxys_ex_003" --夺宝奇兵地图

--随机迷宫上榜的最小分数
hVar.RANDOMMAP_RANDBOARD_SCORE_MIN = 21

--前哨阵地上榜的最小分数
hVar.QIANSHAOZHHENDI_RANDBOARD_SCORE_MIN = 10

--红装神器获得途径
hVar.REDEQUIP_REWARDTYPE =
{
	NONE = 0,				--无
	REWARDTYPE_MAIL = 1,			--邮件直接领取
	REWARDTYPE_ENDLESSRANKBOARD = 2,	--邮件无尽排名奖励
	REWARDTYPE_PVEMULTYWORK = 3,		--邮件魔龙宝库勤劳奖励
	REWARDTYPE_MAILREAD = 4,		--邮件标题正文领取
	REWARDTYPE_SEVENDAYPAY = 5,		--七日充值活动奖励
	REWARDTYPE_SINGINREWARD = 6,		--签到活动获得
	REWARDTYPE_SINGINDRAW = 7,		--签到活动抽到
	REWARDTYPE_TURNTABLE = 8,		--转盘活动抽到
	REWARDTYPE_REDSCROLL = 9,		--红装兑换券选择
	REWARDTYPE_MAILDRAWCARD = 10,		--邮件n选1领取
	REWARDTYPE_MAILCHEST = 11,		--邮件锦囊抽到
	REWARDTYPE_REDCHEST = 12,		--神器锦囊抽到
	REWARDTYPE_REDDEBRIS = 13,		--神器晶石抽到
	REWARDTYPE_GROUPCHEST = 14,		--军团宝箱抽到
	REWARDTYPE_MERGE = 15,			--合成
	REWARDTYPE_PURCHASE198 = 16,		--首充198元奖励
	REWARDTYPE_PURCHASE388 = 17,		--首充388元奖励
	REWARDTYPE_TRANFSORM = 18,		--老装备转换
	REWARDTYPE_CANGBAOTU = 19,		--藏宝图抽到
	REWARDTYPE_CANGBAOTU_HIGH = 20,		--高级藏宝图抽到
	REWARDTYPE_QUNYINGGEREWARD = 21,	--通关群英阁获得
	REWARDTYPE_TURNCHOUJIANG = 22,		--夺宝活动抽到
	REWARDTYPE_PURCHASE328 = 23,		--首充328元奖励
	REWARDTYPE_PVPSHOP = 24,		--夺塔奇兵积分商城抽到
	REWARDTYPE_CHATDRAGON = 25,		--聊天龙王奖励
	
	REWARDTYPE_TREASURE_STAR1 = 101,	--宝物升1星
	REWARDTYPE_TREASURE_STAR2 = 102,	--宝物升2星
	REWARDTYPE_TREASURE_STAR3 = 103,	--宝物升3星
	REWARDTYPE_TREASURE_STAR4 = 104,	--宝物升4星
	REWARDTYPE_TREASURE_STAR5 = 105,	--宝物升5星
}


--宝物升级消耗
hVar.TREASURE_LVUP_INFO = 
{
	--等级上限
	maxTreasureLv = 5,
	
	--[等级] = {商品id(包含消耗的积分和金币), 转化的碎片数, 升级下一级需要消耗的碎片数}
	[0] =	{shopItemId = 414,		toDebris = 0,		costDebris = 20},
	[1] =	{shopItemId = 415,		toDebris = 20,		costDebris = 40},
	[2] =	{shopItemId = 416,		toDebris = 60,		costDebris = 80},
	[3] =	{shopItemId = 417,		toDebris = 140,		costDebris = 120},
	[4] =	{shopItemId = 418,		toDebris = 260,		costDebris = 160},
	[5] =	{shopItemId = 419,		toDebris = 420,		costDebris = nil},
}

------------------------------------------------------------------------
--战车武器枪升星消耗
hVar.WEAPON_STARUP_INFO =
{
	--星级上限
	maxWeaponStar = 4,
	
	--[等级] = {商品id(包含消耗的积分和金币), 转化的碎片数, 升星需要的的等级}
	[0] =	{shopItemId = 424,	costDebris = 100,	requireLv = 0,},
	[1] =	{shopItemId = 425,	costDebris = 200,	requireLv = 9,},
	[2] =	{shopItemId = 426,	costDebris = 300,	requireLv = 19,},
	[3] =	{shopItemId = 427,	costDebris = 500,	requireLv = 29,},
}

------------------------------------------------------------------------
--战车武器升级消耗
hVar.WEAPON_LVUP_INFO =
{
	--等级上限
	maxWeaponLv = 30,
	
	--[等级] = {商品id(包含消耗的积分和金币), 需要的碎片数, 需要的星级}（升星时填的消耗游戏币无效）
	[0] =	{shopItemId = 557,	costDebris = 100,	reqiureStar = 1,},
	[1] =	{shopItemId = 557,	costDebris = 10,	reqiureStar = 1,},
	[2] =	{shopItemId = 558,	costDebris = 10,	reqiureStar = 1,},
	[3] =	{shopItemId = 559,	costDebris = 10,	reqiureStar = 1,},
	[4] =	{shopItemId = 560,	costDebris = 10,	reqiureStar = 1,},
	[5] =	{shopItemId = 561,	costDebris = 10,	reqiureStar = 1,},
	[6] =	{shopItemId = 562,	costDebris = 10,	reqiureStar = 1,},
	[7] =	{shopItemId = 563,	costDebris = 10,	reqiureStar = 1,},
	[8] =	{shopItemId = 564,	costDebris = 10,	reqiureStar = 1,},
	[9] =	{shopItemId = 565,	costDebris = 200,	reqiureStar = 2,},
	[10] =	{shopItemId = 566,	costDebris = 30,	reqiureStar = 2,},
	[11] =	{shopItemId = 567,	costDebris = 30,	reqiureStar = 2,},
	[12] =	{shopItemId = 568,	costDebris = 30,	reqiureStar = 2,},
	[13] =	{shopItemId = 569,	costDebris = 30,	reqiureStar = 2,},
	[14] =	{shopItemId = 570,	costDebris = 30,	reqiureStar = 2,},
	[15] =	{shopItemId = 571,	costDebris = 30,	reqiureStar = 2,},
	[16] =	{shopItemId = 572,	costDebris = 30,	reqiureStar = 2,},
	[17] =	{shopItemId = 573,	costDebris = 30,	reqiureStar = 2,},
	[18] =	{shopItemId = 574,	costDebris = 30,	reqiureStar = 2,},
	[19] =	{shopItemId = 575,	costDebris = 300,	reqiureStar = 3,},
	[20] =	{shopItemId = 576,	costDebris = 50,	reqiureStar = 3,},
	[21] =	{shopItemId = 577,	costDebris = 50,	reqiureStar = 3,},
	[22] =	{shopItemId = 578,	costDebris = 50,	reqiureStar = 3,},
	[23] =	{shopItemId = 579,	costDebris = 50,	reqiureStar = 3,},
	[24] =	{shopItemId = 580,	costDebris = 50,	reqiureStar = 3,},
	[25] =	{shopItemId = 581,	costDebris = 50,	reqiureStar = 3,},
	[26] =	{shopItemId = 582,	costDebris = 50,	reqiureStar = 3,},
	[27] =	{shopItemId = 583,	costDebris = 50,	reqiureStar = 3,},
	[28] =	{shopItemId = 584,	costDebris = 50,	reqiureStar = 3,},
	[29] =	{shopItemId = 585,	costDebris = 500,	reqiureStar = 4,},
	[30] =	{shopItemId = 999,	costDebris = 999,	reqiureStar = 999,},
}

--机枪武器表
hVar.tab_weapon =
{
	[1] = {unitId = 6013, unlock = true,}, --武器单位id、初始是否解锁、解锁每点所需要的积分
	[2] = {unitId = 6014, unlock = false,}, --散射枪
	[3] = {unitId = 6007, unlock = false,}, --弹射枪
	[4] = {unitId = 6003, unlock = false,}, --火焰枪
	[5] = {unitId = 6006, unlock = false,}, --射线枪
	[6] = {unitId = 6004, unlock = false,}, --闪电枪
	[7] = {unitId = 6016, unlock = false,}, --毒液枪
	[8] = {unitId = 6017, unlock = false,}, --缩小枪
	[9] = {unitId = 6002, unlock = false,}, --镭射枪
	[10] = {unitId = 6005, unlock = false,}, --冲击枪
	[11] = {unitId = 6008, unlock = false,}, --火箭枪
	[12] = {unitId = 6009, unlock = false,}, --导弹枪
	[13] = {unitId = 6019, unlock = false,}, --终结者
	[14] = {unitId = 6020, unlock = false,}, --流浪者
}

--战车升级经验、天赋点数表
hVar.TANK_LEVELUP_EXP = 
{	
	--等级上限
	maxLv = 100,
	
	--[[
	--[等级] = {当前等级最低经验值 = 10, 升到下一级所需经验值 = 10,}
	[1] =	{minExp = 0,						nextExp = 50,					talentNum = 1},
	[2] =	{minExp = 50,						nextExp = 100,					talentNum = 2},
	[3] =	{minExp = 150,						nextExp = 150,					talentNum = 3},
	[4] =	{minExp = 300,						nextExp = 200,					talentNum = 4},
	[5] =	{minExp = 500,						nextExp = 250,					talentNum = 5},
	[6] =	{minExp = 750,						nextExp = 300,					talentNum = 6},
	[7] =	{minExp = 1050,						nextExp = 350,					talentNum = 7},
	[8] =	{minExp = 1400,						nextExp = 400,					talentNum = 8},
	[9] =	{minExp = 1800,						nextExp = 450,					talentNum = 9},
	[10] =	{minExp = 2250,						nextExp = 500,					talentNum = 10},

	[11] =	{minExp = 2750,						nextExp = 550,					talentNum = 11},
	[12] =	{minExp = 3300,						nextExp = 600,					talentNum = 12},
	[13] =	{minExp = 3900,						nextExp = 650,					talentNum = 13},
	[14] =	{minExp = 4550,						nextExp = 700,					talentNum = 14},
	[15] =	{minExp = 5250,						nextExp = 750,					talentNum = 15},
	[16] =	{minExp = 6000,						nextExp = 800,					talentNum = 16},
	[17] =	{minExp = 6800,						nextExp = 850,					talentNum = 17},
	[18] =	{minExp = 7650,						nextExp = 900,					talentNum = 18},
	[19] =	{minExp = 8550,						nextExp = 950,					talentNum = 19},
	[20] =	{minExp = 9500,						nextExp = nil,					talentNum = 20},
	]]
}
--初始100   后面每级=上级升级需要经验*1.03+100
for i = 1, hVar.TANK_LEVELUP_EXP.maxLv, 1 do
	hVar.TANK_LEVELUP_EXP[i] = {}
	if (i == 1) then
		hVar.TANK_LEVELUP_EXP[i].minExp = 0
		hVar.TANK_LEVELUP_EXP[i].nextExp = 100
	else
		hVar.TANK_LEVELUP_EXP[i].minExp = hVar.TANK_LEVELUP_EXP[i-1].minExp + hVar.TANK_LEVELUP_EXP[i-1].nextExp
		hVar.TANK_LEVELUP_EXP[i].nextExp = math.ceil(hVar.TANK_LEVELUP_EXP[i-1].nextExp*1.05)+50
	end
	hVar.TANK_LEVELUP_EXP[i].talentNum = i
end

--战车天赋类型
hVar.ChariotTalentType = {
	BOMB = 1,	--投雷专家
	SURVIVE = 2,	--生存意志
	HUNTER = 3,	--战地猎人
}

--战车表
hVar.tank_unit =
{
	[1] = 6109,	--普通战车
	[2] = 6107,	--重型坦克
	[3] = 6108,	--蜘蛛坦克
}

--天赋树表
hVar.talent_tree =
{
	--天赋id
	--1,2,3,4,5,6,7,8,
	1,2,3,4,6,7,8,
	21,22,23,24,25,26,27,
	41,42,43,44,45,
}

--宠物表
hVar.tab_pet =
{
	[1] = {unitId = 13041, unlock = false,}, --宠物单位id、初始是否解锁、解锁每点所需要的积分
	[2] = {unitId = 13042, unlock = false,}, --尤达
	[3] = {unitId = 13043, unlock = false,}, --支援战机
	[4] = {unitId = 13044, unlock = false,}, --刺蛇宝宝
}

------------------------------------------------------------------------
--宠物升星消耗
hVar.PET_STAR_INFO_NEW =
{
	--宠物星级上限
	maxPetStar = 5,
	
	--[等级] = {商品id(包含消耗的积分和金币), 转化的碎片数, 升星需要的的等级}
	[0] =	{shopItemId = 438,	costDebris = 100,	requireLv = 0,},
	[1] =	{shopItemId = 439,	costDebris = 200,	requireLv = 9,},
	[2] =	{shopItemId = 440,	costDebris = 300,	requireLv = 19,},
	[3] =	{shopItemId = 441,	costDebris = 500,	requireLv = 29,},
}

------------------------------------------------------------------------
--宠物升级消耗
hVar.PET_LVUP_INFO_NEW =
{
	--等级上限
	maxPetLv = 30,
	
	--[等级] = {商品id(包含消耗的积分和金币), 需要的碎片数, 需要的星级}（升星时填的消耗游戏币无效，取hVar.PET_STAR_INFO_NEW）
	[0] =	{shopItemId = 607,	costDebris = 100,	reqiureStar = 1,},
	[1] =	{shopItemId = 607,	costDebris = 10,	reqiureStar = 1,},
	[2] =	{shopItemId = 608,	costDebris = 10,	reqiureStar = 1,},
	[3] =	{shopItemId = 609,	costDebris = 10,	reqiureStar = 1,},
	[4] =	{shopItemId = 610,	costDebris = 10,	reqiureStar = 1,},
	[5] =	{shopItemId = 611,	costDebris = 10,	reqiureStar = 1,},
	[6] =	{shopItemId = 612,	costDebris = 10,	reqiureStar = 1,},
	[7] =	{shopItemId = 613,	costDebris = 10,	reqiureStar = 1,},
	[8] =	{shopItemId = 614,	costDebris = 10,	reqiureStar = 1,},
	[9] =	{shopItemId = 615,	costDebris = 200,	reqiureStar = 2,},
	[10] =	{shopItemId = 616,	costDebris = 30,	reqiureStar = 2,},
	[11] =	{shopItemId = 617,	costDebris = 30,	reqiureStar = 2,},
	[12] =	{shopItemId = 618,	costDebris = 30,	reqiureStar = 2,},
	[13] =	{shopItemId = 619,	costDebris = 30,	reqiureStar = 2,},
	[14] =	{shopItemId = 620,	costDebris = 30,	reqiureStar = 2,},
	[15] =	{shopItemId = 621,	costDebris = 30,	reqiureStar = 2,},
	[16] =	{shopItemId = 622,	costDebris = 30,	reqiureStar = 2,},
	[17] =	{shopItemId = 623,	costDebris = 30,	reqiureStar = 2,},
	[18] =	{shopItemId = 624,	costDebris = 30,	reqiureStar = 2,},
	[19] =	{shopItemId = 625,	costDebris = 300,	reqiureStar = 3,},
	[20] =	{shopItemId = 626,	costDebris = 50,	reqiureStar = 3,},
	[21] =	{shopItemId = 627,	costDebris = 50,	reqiureStar = 3,},
	[22] =	{shopItemId = 628,	costDebris = 50,	reqiureStar = 3,},
	[23] =	{shopItemId = 629,	costDebris = 50,	reqiureStar = 3,},
	[24] =	{shopItemId = 630,	costDebris = 50,	reqiureStar = 3,},
	[25] =	{shopItemId = 631,	costDebris = 50,	reqiureStar = 3,},
	[26] =	{shopItemId = 632,	costDebris = 50,	reqiureStar = 3,},
	[27] =	{shopItemId = 633,	costDebris = 50,	reqiureStar = 3,},
	[28] =	{shopItemId = 634,	costDebris = 50,	reqiureStar = 3,},
	[29] =	{shopItemId = 635,	costDebris = 500,	reqiureStar = 4,},
	[30] =	{shopItemId = 999,	costDebris = 999,	reqiureStar = 999,},
}

------------------------------------------------------------------------
--宠物挖矿收益表
hVar.PET_WAKUANG_INFO =
{
	--1星
	[1] = {
		wakuangRequireHour = 999999, --挖矿需要的时间（小时）
		watiliRequireHour = 999999, --挖体力需要的时间（小时）
		wachestRequireHour = 999999, --挖宝箱需要的时间（小时）
	},
	
	--2星
	[2] = {
		wakuangRequireHour = 3, --挖矿需要的时间（小时）
		watiliRequireHour = 3, --挖体力需要的时间（小时）
		wachestRequireHour = 12, --挖宝箱需要的时间（小时）
	},
	
	--3星
	[3] = {
		wakuangRequireHour = 2, --挖矿需要的时间（小时）
		watiliRequireHour = 2, --挖体力需要的时间（小时）
		wachestRequireHour = 6, --挖宝箱需要的时间（小时）
	},
	
	--4星
	[4] = {
		wakuangRequireHour = 1, --挖矿需要的时间（小时）
		watiliRequireHour = 1, --挖体力需要的时间（小时）
		wachestRequireHour = 4, --挖宝箱需要的时间（小时）
	},
}

------------------------------------------------------------------------
--任务池子列表
hVar.TASK_ILIST_NEW =
{
	--通关第1章任务池子 机械蜘蛛
	[1] =
	{
		--每日任务
		day = {
			taskNum = 6,
			pool = {
				
				{
					--通关
					totalNum = 2,
					pool = {101,102,103,104,},
				},
				--{
					----无损通关
					--totalNum = 1,
					--pool = {201,202,203,204,},
				--},
				{
					--刷新商店1次
					totalNum = 1,
					pool = {301,},
				},
				{
					--开启 武器/战术/宠物/装备 宝箱1次
					totalNum = 1,
					pool = {311,321,331,341,},
				},
				{
					--累计击杀 100/200/300 个敌人
					totalNum = 1,
					pool = {351,352,353,},
				},
				{
					--累计击杀 5/10/15 个BOSS
					totalNum = 1,
					pool = {361,362,363,},
				},
				{
					--累计使用战术卡 30/60/90 次
					totalNum = 1,
					pool = {371,372,373,},
				},
				{
					--累计营救 10/20/30 个工程师
					totalNum = 1,
					pool = {381,382,383,},
				},
				--{
				--	--前哨阵地达到 5/10/15 波
				--	totalNum = 1,
				--	pool = {391,392,393,},
				--},
				{
					--天梯迷宫抵达 2-1 层
					totalNum = 1,
					pool = {401,},
				},
				{
					--战车累计损坏 3/6/9 次
					totalNum = 1,
					pool = {411,412,413,},
				},
				{
					--改造装备 3/6/9 次
					totalNum = 1,
					pool = {431,432,433,},
				},
			},
		},
		
		--每周任务
		week = {
			taskNum = 5,
			pool = {
				1001, --本周开启武器宝箱20次
				1002, --本周开启战术宝箱20次
				1003, --本周开启宠物宝箱20次
				1004, --本周开启装备宝箱20次
				1005, --本周累计击杀1000个敌人
				1006, --本周累计营救60个工程师
				1007, --累计战车死亡30次
				--1008, --前哨阵地30波
				1009, --随机迷宫7-1层
				1010, --累计击杀50个BOSS
				1011, --累计使用战术卡300次
				1012, --跟随15个宠物
				1013, --累计使用芯片改造装备20次
				1014, --累计升级任意战术卡10次
				1015, --累计升级任意枪塔武器10次
				1016, --累计升级任意宠物10次
				1017, --通关母巢之战-难度1
				1018, --通关夺宝奇兵-简单难度
			},
		},
	},
	
	--通关第2章任务池子 飞船
	[2] =
	{
		--每日任务
		day = {
			taskNum = 6,
			pool = {
				
				{
					--通关
					totalNum = 2,
					pool = {105,106,107,108,},
				},
				--{
					----无损通关
					--totalNum = 1,
					--pool = {205,206,207,208,},
				--},
				{
					--刷新商店1次
					totalNum = 1,
					pool = {301,},
				},
				{
					--开启 武器/战术/宠物/装备 宝箱1次
					totalNum = 1,
					pool = {311,321,331,341,},
				},
				{
					--累计击杀 100/200/300 个敌人
					totalNum = 1,
					pool = {351,352,353,},
				},
				{
					--累计击杀 5/10/15 个BOSS
					totalNum = 1,
					pool = {361,362,363,},
				},
				{
					--累计使用战术卡 30/60/90 次
					totalNum = 1,
					pool = {371,372,373,},
				},
				{
					--累计营救 10/20/30 个工程师
					totalNum = 1,
					pool = {381,382,383,},
				},
				--{
				--	--前哨阵地达到 5/10/15 波
				--	totalNum = 1,
				--	pool = {391,392,393,},
				--},
				{
					--天梯迷宫抵达 3-1 层
					totalNum = 1,
					pool = {402,},
				},
				{
					--战车累计损坏 3/6/9 次
					totalNum = 1,
					pool = {411,412,413,},
				},
				{
					--改造装备 3/6/9 次
					totalNum = 1,
					pool = {431,432,433,},
				},
			},
		},
		
		--每周任务
		week = {
			taskNum = 5,
			pool = {
				1001, --本周开启武器宝箱20次
				1002, --本周开启战术宝箱20次
				1003, --本周开启宠物宝箱20次
				1004, --本周开启装备宝箱20次
				1005, --本周累计击杀1000个敌人
				1006, --本周累计营救60个工程师
				1007, --累计战车死亡30次
				--1008, --前哨阵地30波
				1009, --随机迷宫7-1层
				1010, --累计击杀50个BOSS
				1011, --累计使用战术卡300次
				1012, --跟随15个宠物
				1013, --累计使用芯片改造装备20次
				1014, --累计升级任意战术卡10次
				1015, --累计升级任意枪塔武器10次
				1016, --累计升级任意宠物10次
				1017, --通关母巢之战-难度1
				1018, --通关夺宝奇兵-简单难度
			},
		},
	},
	
	--通关第3章任务池子 虫族
	[3] =
	{
		--每日任务
		day = {
			taskNum = 6,
			pool = {
				
				{
					--通关
					totalNum = 2,
					pool = {109,110,111,112,},
				},
				--{
					----无损通关
					--totalNum = 1,
					--pool = {209,210,211,212,},
				--},
				{
					--刷新商店1次
					totalNum = 1,
					pool = {301,},
				},
				{
					--开启 武器/战术/宠物/装备 宝箱1次
					totalNum = 1,
					pool = {311,321,331,341,},
				},
				{
					--累计击杀 100/200/300 个敌人
					totalNum = 1,
					pool = {351,352,353,},
				},
				{
					--累计击杀 5/10/15 个BOSS
					totalNum = 1,
					pool = {361,362,363,},
				},
				{
					--累计使用战术卡 30/60/90 次
					totalNum = 1,
					pool = {371,372,373,},
				},
				{
					--累计营救 10/20/30 个工程师
					totalNum = 1,
					pool = {381,382,383,},
				},
				--{
				--	--前哨阵地达到 5/10/15 波
				--	totalNum = 1,
				--	pool = {391,392,393,},
				--},
				{
					--天梯迷宫抵达 4-1 层
					totalNum = 1,
					pool = {403,},
				},
				{
					--战车累计损坏 3/6/9 次
					totalNum = 1,
					pool = {411,412,413,},
				},
				{
					--改造装备 3/6/9 次
					totalNum = 1,
					pool = {431,432,433,},
				},
			},
		},
		
		--每周任务
		week = {
			taskNum = 5,
			pool = {
				1001, --本周开启武器宝箱20次
				1002, --本周开启战术宝箱20次
				1003, --本周开启宠物宝箱20次
				1004, --本周开启装备宝箱20次
				1005, --本周累计击杀1000个敌人
				1006, --本周累计营救60个工程师
				1007, --累计战车死亡30次
				1008, --前哨阵地30波
				1009, --随机迷宫7-1层
				1010, --累计击杀50个BOSS
				1011, --累计使用战术卡300次
				1012, --跟随15个宠物
				1013, --累计使用芯片改造装备20次
				1014, --累计升级任意战术卡10次
				1015, --累计升级任意枪塔武器10次
				1016, --累计升级任意宠物10次
				1017, --通关母巢之战-难度1
				1018, --通关夺宝奇兵-简单难度
			},
		},
	},
	
	--通关第4章任务池子 生化大眼睛
	[4] =
	{
		--每日任务
		day = {
			taskNum = 6,
			pool = {
				
				{
					--通关
					totalNum = 2,
					pool = {113,114,115,116,},
				},
				--{
					----无损通关
					--totalNum = 1,
					--pool = {213,214,215,216,},
				--},
				{
					--刷新商店1次
					totalNum = 1,
					pool = {301,},
				},
				{
					--开启 武器/战术/宠物/装备 宝箱1次
					totalNum = 1,
					pool = {311,321,331,341,},
				},
				{
					--累计击杀 100/200/300 个敌人
					totalNum = 1,
					pool = {351,352,353,},
				},
				{
					--累计击杀 5/10/15 个BOSS
					totalNum = 1,
					pool = {361,362,363,},
				},
				{
					--累计使用战术卡 30/60/90 次
					totalNum = 1,
					pool = {371,372,373,},
				},
				{
					--累计营救 10/20/30 个工程师
					totalNum = 1,
					pool = {381,382,383,},
				},
				{
					--前哨阵地达到 5 波
					totalNum = 1,
					pool = {391,},
				},
				{
					--天梯迷宫抵达 4-1/5-1 层
					totalNum = 1,
					pool = {403,404,},
				},
				{
					--战车累计损坏 3/6/9 次
					totalNum = 1,
					pool = {411,412,413,},
				},
				{
					--改造装备 3/6/9 次
					totalNum = 1,
					pool = {431,432,433,},
				},
			},
		},
		
		--每周任务
		week = {
			taskNum = 5,
			pool = {
				1001, --本周开启武器宝箱20次
				1002, --本周开启战术宝箱20次
				1003, --本周开启宠物宝箱20次
				1004, --本周开启装备宝箱20次
				1005, --本周累计击杀1000个敌人
				1006, --本周累计营救60个工程师
				1007, --累计战车死亡30次
				1008, --前哨阵地30波
				1009, --随机迷宫7-1层
				1010, --累计击杀50个BOSS
				1011, --累计使用战术卡300次
				1012, --跟随15个宠物
				1013, --累计使用芯片改造装备20次
				1014, --累计升级任意战术卡10次
				1015, --累计升级任意枪塔武器10次
				1016, --累计升级任意宠物10次
				1017, --通关母巢之战-难度1
				1018, --通关夺宝奇兵-简单难度
			},
		},
	},
	
	--通关第5章任务池子 机械飞船
	[5] =
	{
		--每日任务
		day = {
			taskNum = 6,
			pool = {
				
				{
					--通关
					totalNum = 2,
					pool = {117,118,119,120,},
				},
				--{
					----无损通关
					--totalNum = 1,
					--pool = {217,218,219,220,},
				--},
				{
					--刷新商店1次
					totalNum = 1,
					pool = {301,},
				},
				{
					--开启 武器/战术/宠物/装备 宝箱1次
					totalNum = 1,
					pool = {311,321,331,341,},
				},
				{
					--累计击杀 100/200/300 个敌人
					totalNum = 1,
					pool = {351,352,353,},
				},
				{
					--累计击杀 5/10/15 个BOSS
					totalNum = 1,
					pool = {361,362,363,},
				},
				{
					--累计使用战术卡 30/60/90 次
					totalNum = 1,
					pool = {371,372,373,},
				},
				{
					--累计营救 10/20/30 个工程师
					totalNum = 1,
					pool = {381,382,383,},
				},
				{
					--前哨阵地达到 5/10 波
					totalNum = 1,
					pool = {391,392,},
				},
				{
					--天梯迷宫抵达 4-1/5-1 层
					totalNum = 1,
					pool = {403,404,},
				},
				{
					--战车累计损坏 3/6/9 次
					totalNum = 1,
					pool = {411,412,413,},
				},
				{
					--改造装备 3/6/9 次
					totalNum = 1,
					pool = {431,432,433,},
				},
			},
		},
		
		--每周任务
		week = {
			taskNum = 5,
			pool = {
				1001, --本周开启武器宝箱20次
				1002, --本周开启战术宝箱20次
				1003, --本周开启宠物宝箱20次
				1004, --本周开启装备宝箱20次
				1005, --本周累计击杀1000个敌人
				1006, --本周累计营救60个工程师
				1007, --累计战车死亡30次
				1008, --前哨阵地30波
				1009, --随机迷宫7-1层
				1010, --累计击杀50个BOSS
				1011, --累计使用战术卡300次
				1012, --跟随15个宠物
				1013, --累计使用芯片改造装备20次
				1014, --累计升级任意战术卡10次
				1015, --累计升级任意枪塔武器10次
				1016, --累计升级任意宠物10次
				1017, --通关母巢之战-难度1
				1018, --通关夺宝奇兵-简单难度
			},
		},
	},
	
	--通关第6章任务池子 飞碟
	[6] =
	{
		--每日任务
		day = {
			taskNum = 6,
			pool = {
				
				{
					--通关
					totalNum = 2,
					pool = {121,122,123,124,},
				},
				{
					--无损通关
					totalNum = 1,
					pool = {201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,},
				},
				{
					--刷新商店1次
					totalNum = 1,
					pool = {301,},
				},
				{
					--开启 武器/战术/宠物/装备 宝箱1次
					totalNum = 1,
					pool = {311,321,331,341,},
				},
				{
					--累计击杀 100/200/300 个敌人
					totalNum = 1,
					pool = {351,352,353,},
				},
				{
					--累计击杀 5/10/15 个BOSS
					totalNum = 1,
					pool = {361,362,363,},
				},
				{
					--累计使用战术卡 30/60/90 次
					totalNum = 1,
					pool = {371,372,373,},
				},
				{
					--累计营救 10/20/30 个工程师
					totalNum = 1,
					pool = {381,382,383,},
				},
				{
					--前哨阵地达到 10/15 波
					totalNum = 1,
					pool = {392,393,},
				},
				{
					--天梯迷宫抵达 4-1/5-1 层
					totalNum = 1,
					pool = {403,404,},
				},
				{
					--战车累计损坏 3/6/9 次
					totalNum = 1,
					pool = {411,412,413,},
				},
				{
					--改造装备 3/6/9 次
					totalNum = 1,
					pool = {431,432,433,},
				},
			},
		},
		
		--每周任务
		week = {
			taskNum = 5,
			pool = {
				1001, --本周开启武器宝箱20次
				1002, --本周开启战术宝箱20次
				1003, --本周开启宠物宝箱20次
				1004, --本周开启装备宝箱20次
				1005, --本周累计击杀1000个敌人
				1006, --本周累计营救60个工程师
				1007, --累计战车死亡30次
				1008, --前哨阵地30波
				1009, --随机迷宫7-1层
				1010, --累计击杀50个BOSS
				1011, --累计使用战术卡300次
				1012, --跟随15个宠物
				1013, --累计使用芯片改造装备20次
				1014, --累计升级任意战术卡10次
				1015, --累计升级任意枪塔武器10次
				1016, --累计升级任意宠物10次
				1017, --通关母巢之战-难度1
				1018, --通关夺宝奇兵-简单难度
			},
		},
	},
}

--指定日期内的额外任务
hVar.TASKE_EXTRA_LIST =
{
	{
		beginTime = "2022-01-31 00:00:00",
		endTime = "2022-02-06 23:59:59",
		tasks = {11,12,},
	},
}

--指定渠道额外的固定任务
hVar.TASK_CHANNEL_ADDONES =
{
	[1] = {100,}, --苹果有分享任务
}

------------------------------------------------------------------------
--特惠礼包装备
hVar.SHOP_GIFT_EQUIP_LIST =
{
	totalNum = 6,
	
	[1] = {prize = "10:20211:1:0", maxcount = 1, goldCost = 1,},
	[2] = {prize = "10:20204:1:0", maxcount = 1, goldCost = 5,},
	[3] = {prize = "10:20214:1:0", maxcount = 1, goldCost = 10,},
	[4] = {prize = "10:20216:1:0", maxcount = 1, goldCost = 20,},
	[5] = {prize = "10:20307:1:0", maxcount = 1, goldCost = 50,},
	[6] = {prize = "10:20319:1:0", maxcount = 1, goldCost = 50,},
}

--游戏内走马灯冒字通知类型
hVar.BUBBLE_NOTICE_TYPE = 
{
	RED_EQUIP = 1001,		--获得4孔神器 --FIXME: 用的旧流程，待更新简化流程
	PET_STARUP = 1002,		--宠物升星（解锁）
	WEAPON_STARUP = 1003,	--武器枪升星（解锁）
}