hVar.tab_roomcfg = {}

local _tab_room = hVar.tab_roomcfg


-----------------------------------------------------------【夺塔奇兵-娱乐】--------------------------------------------------------
--娱乐房、擂台赛
_tab_room[1] = 
{
	mapkey = "world/td_pvp_001",
	--mapkey = "td_pvp_001",
	
	kickoutCD = 75, --玩家超时踢出的最大等待时间(秒)
	
	groupMapFlag = 0, --是否为军团地图
	
	confgInfo = 
	{
		--势力1
		[1] = 
		{
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_SHU"],		--势力描述
			defaultType = hVar.POS_TYPE.BLANK,				--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = false,				--是否只允许电脑

		},
		--势力2
		[2] = 
		{
			--默认
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_WEI"],		--势力描述
			defaultType = hVar.POS_TYPE.BLANK,				--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = false,				--是否只允许电脑

		},
	},
	
	--开放时间段(每日可配置多个时间段)
	openTime = 
	{
		normal = {
			{beginTime = "00:00:00", endTime = "23:59:59",},
		},
		arena = {
			{beginTime = "00:00:00", endTime = "23:59:59",},
			--{beginTime = "12:00:00", endTime = "12:59:59",},
			--{beginTime = "18:30:00", endTime = "20:29:59",},
		},
		
	},
	
	--有效局条件(夺塔奇兵)
	validCondition = 
	{
		--3分钟
		timeLimit = 180000,					--最低游戏时长（单位毫秒）
	},
	
	reward = {
	},
}


-----------------------------------------------------------【魔龙宝库】--------------------------------------------------------
--魔龙宝库
_tab_room[2] = 
{
	
	mapkey = "world/td_wj_003",	---老的地图
	--mapkey = "world/td_wj_003_ex4",	---新年活动
	
	kickoutCD = 180, --玩家超时踢出的最大等待时间(秒)
	
	--挑战次数
	challengeMaxCount = 1,
	
	groupMapFlag = 1, --是否为军团地图
	
	confgInfo = 
	{
		--势力1
		[1] = 
		{
			maxNum = 2,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_SHU"],		--势力描述
			defaultType = hVar.POS_TYPE.BLANK,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = false,				--该势力允许玩家进入
			
		},
		--势力2
		[2] = 
		{
			--默认
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_WEI"],		--势力描述
			defaultType = hVar.POS_TYPE.AI_EASY,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = true,				--该势力不允许玩家进入
			
		},
	},
	
	--显示奖励
	rewardShow = 
	{
		--[[
		--新年活动
		[hVar.POS_TYPE.AI_EASY] = {
			{10,12412}, --军团神器
			--{1,1000},
			{10,12613,}, --玄甲金牛
			{5,10231,1,}, --孙坚将魂
		},
		]]
		
		
		--客户端界面显示
		[hVar.POS_TYPE.AI_EASY] = {
			--{10,12406},
			--{1,1000},
			--{11,100},
			{10,12412}, --军团神器
			{10,12406}, --献祭之石
			{5,10231,1,}, --孙坚将魂
		},
		
	},
	
	--魔龙宝库结束奖励
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 2,				--抽的数量
			
			
			--老的掉落
			{"Boss_001",1,1},			--{奖池,最小个数,最大个数)} --献祭之石
			{"juntuan_sunjian",1,1},		--{奖池,最小个数,最大个数)} --孙坚将魂
			{"Equip_juntuanfuben",1,1},		--{奖池,最小个数,最大个数)} --军团神器
			{"Boss_003",1,2},			--{奖池,最小个数,最大个数)} --神器晶石
			
			
			--[[
			--新年活动掉落--玄甲金牛
			{"Boss_nianshou",1,1},			--{奖池,最小个数,最大个数)} --玄甲金牛
			{"Boss_001",1,1},			--{奖池,最小个数,最大个数)} --献祭之石
			{"juntuan_sunjian",1,1},		--{奖池,最小个数,最大个数)} --孙坚将魂
			{"Equip_juntuanfuben",1,1},		--{奖池,最小个数,最大个数)} --军团神器
			]]
		},
	},
	
	--魔龙宝库结束奖励,每周必掉
	rewardPerWeek = {
		[hVar.POS_TYPE.AI_EASY] = {
			min = 5,
			max = 10,
			
			---老的掉落
			--{5,10207},	--郭嘉
			--{5,10206},	--太史慈
			--{5,10214},	--张辽
			--{5,10216},	--典韦
			--{5,10215},	--许褚
			--{5,10220},	--徐庶
			--{5,10221},	--诸葛亮
			
			---新的掉落
			{5,10206},	--太史慈
			{5,10220},	--徐庶
			{5,10224},	--庞统
			{5,10221},	--诸葛亮
			{5,10227},	--贾诩
			{5,10226},	--黄月英
		},
	},
	
	--开放时间段(每日可配置多个时间段)
	openTime = 
	{
		normal = {
			--{beginTime = "12:00:00", endTime = "13:59:59",},
			--{beginTime = "20:00:00", endTime = "22:59:59",},
			{beginTime = "05:00:00", endTime = "23:59:59",},
		},
	},
	
	--有效局条件(魔龙宝库)
	validCondition = 
	{
		--10分钟
		--timeLimit = 600000,					--最低游戏时长（单位毫秒）
		timeLimit = 0,					--最低游戏时长（单位毫秒）
	},
	
	--使用道具技能是否发游戏币奖励
	bUseItemRewardFlag = false,
}



-----------------------------------------------------------【铜雀台】--------------------------------------------------------
--铜雀台
_tab_room[3] = 
{
	mapkey = "world/td_sl_01",
	
	groupMapFlag = 0, --是否为军团地图
	
	confgInfo = 
	{
		--势力1
		[1] = 
		{
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_SHU"],		--势力描述
			defaultType = hVar.POS_TYPE.BLANK,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = false,				--是否只允许电脑
			
		},
		--势力2
		[2] = 
		{
			--默认
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_WEI"],		--势力描述
			defaultType = hVar.POS_TYPE.AI_HARD,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = true,				--是否只允许电脑
			
		},
	},
	
	kickoutCD = 86400, --玩家超时踢出的最大等待时间(秒)
	
	--挑战次数
	challengeMaxCount = 99999,
	
	--显示奖励
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{1,1000},
			{11,100},
			{23,1},
		},
		[hVar.POS_TYPE.AI_NORMAL] = {
			{1,1000},
			{11,100},
			{23,1},
			{24,1},
		},
		[hVar.POS_TYPE.AI_HARD] = {
			{10,12406},
			{11,100},
			{23,1},
			{24,1},
		},
	},
	
	--铜雀台结束奖励
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"Boss_002",1,2},			--{奖池,最小个数,最大个数)} --积分
			{"Boss_003",1,2},			--{奖池,最小个数,最大个数)} --神器晶石
			{"treasure_tongquetai_eazy",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（铜雀台简单掉落）
			{"treasure_tongquetai_eazy",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（铜雀台简单掉落）
			{"treasure_tongquetai_eazy",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（铜雀台简单掉落）
		},
		[hVar.POS_TYPE.AI_NORMAL] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"Boss_002",1,2},			--{奖池,最小个数,最大个数)} --积分
			{"Boss_003",1,2},			--{奖池,最小个数,最大个数)} --神器晶石
			{"treasure_tongquetai_middle",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（铜雀台中等掉落）
			{"treasure_tongquetai_middle",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（铜雀台中等掉落）
			{"treasure_tongquetai_middle",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（铜雀台中等掉落）
		},
		[hVar.POS_TYPE.AI_HARD] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"Boss_004",1,1},			--{奖池,最小个数,最大个数)} --献祭之石
			{"Boss_003",1,2},			--{奖池,最小个数,最大个数)} --神器晶石
			{"treasure_tongquetai_hard",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（铜雀台困难掉落）
			{"treasure_tongquetai_hard",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（铜雀台困难掉落）
			{"treasure_tongquetai_hard",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（铜雀台困难掉落）
		},
	},
	
	--[[
	--铜雀台结束宝物碎片奖励
	rewardTreasure = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 1,				--抽的数量
			{"treasure_tongquetai_eazy", 1, 1,},			--{奖池,最小个数,最大个数)}
		},
		
		[hVar.POS_TYPE.AI_NORMAL] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 1,				--抽的数量
			{"treasure_tongquetai_middle", 1, 1,},			--{奖池,最小个数,最大个数)}
		},
		
		[hVar.POS_TYPE.AI_HARD] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 1,				--抽的数量
			{"treasure_tongquetai_hard", 1, 1,},			--{奖池,最小个数,最大个数)}
		},
	},
	]]
	
	--[[
	--铜雀台结束奖励,每周必掉1个
	rewardPerWeek = {
		--简单难度
		[hVar.POS_TYPE.AI_EASY] = {
			min = 5,
			max = 9,
			{5,10214},	--张辽
			{5,10216},	--典韦
			{5,10215},	--许褚
			{5,10207},	--郭嘉
			{5,10228},	--孙尚香
		},
		
		--中等难度
		[hVar.POS_TYPE.AI_NORMAL] = {
			min = 6,
			max = 12,
			{5,10214},	--张辽
			{5,10216},	--典韦
			{5,10215},	--许褚
			{5,10207},	--郭嘉
			{5,10228},	--孙尚香
		},
		
		--困难难度
		[hVar.POS_TYPE.AI_HARD] = {
			min = 7,
			max = 15,
			{5,10214},	--张辽
			{5,10216},	--典韦
			{5,10215},	--许褚
			{5,10207},	--郭嘉
			{5,10228},	--孙尚香
		},
	},
	]]
	
	--地图全局战术技能(铜雀台)
	tacticPool = 
	{
		--第一类
		[1] = {
			totalValue = 60,
			{value = 10, reward = {3180,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3181,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3182,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3183,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3184,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3185,1},},			--战术技能卡id，战术技能卡等级
		},
		
		--第二类
		[2] = {
			totalValue = 20,
			{value = 10, reward = {3190,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3191,1},},			--战术技能卡id，战术技能卡等级
		},
	},
	
	--开放时间段(每日可配置多个时间段)
	openTime = 
	{
		normal = {
			{beginTime = "00:00:00", endTime = "23:59:59",},
		},
	},
	
	--有效局条件(铜雀台)
	validCondition = 
	{
		--2分钟
		--timeLimit = 120000,					--最低游戏时长（单位毫秒）
		timeLimit = 0,					--最低游戏时长（单位毫秒）
	},
}




-----------------------------------------------------------【夺塔奇兵-匹配】--------------------------------------------------------
_tab_room[4] = 
{
	mapkey = "world/td_pvp_001",
	--mapkey = "td_pvp_001",
	
	kickoutCD = 75, --玩家超时踢出的最大等待时间(秒)
	
	groupMapFlag = 0, --是否为军团地图
	
	confgInfo = 
	{
		--势力1
		[1] = 
		{
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_SHU"],		--势力描述
			defaultType = hVar.POS_TYPE.BLANK,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = false,				--是否只允许电脑

		},
		--势力2
		[2] = 
		{
			--默认
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_WEI"],		--势力描述
			defaultType = hVar.POS_TYPE.BLANK,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = false,				--是否只允许电脑
			
		},
	},
	
	--是否自动匹配标志
	matchFlag = true,
	
	--[[
	--匹配设置
	matchSetting = {
		
		--玩家分类
		playerType = {
			
			CLevel5 = hVar.POS_TYPE.AI_PROFESSIONAL,		--超级AI
			CLevel4 = hVar.POS_TYPE.AI_EXPERTS,			--高级AI
			CLevel3 = hVar.POS_TYPE.AI_HARD,			--中等AI
			CLevel2 = hVar.POS_TYPE.AI_NORMAL,			--简单AI
			CLevel1 = hVar.POS_TYPE.AI_EASY,			--新手AI
			
			SKIP = 0,						--跳过
			
			PLevel1 = {"normalSection","tStar1"},		--新玩家(第1把)
			PLevel2 = {"normalSection","tStar2"},		--菜鸟玩家
			PLevel3 = {"normalSection","tStar3"},		--普通玩家
			PLevel4 = {"normalSection","tStar4"},		--老玩家
			
			PLevel11 = {"extraSection","rStar1"},		--协助刷分玩家（高挫折感玩家）
			PLevel12 = {"extraSection","rStar2"},		--一般玩家
			PLevel13 = {"extraSection","rStar3"},		--高水平玩家、刷分玩家
		},
		
		--玩家匹配房总胜场数区间[区间左闭右开)
		normalSection = {
			tStar1 = {min = -9999, max = 1},			--新玩家(第1把)
			tStar2 = {min = 1, max = 10},				--菜鸟玩家
			tStar3 = {min = 10, max = 50},				--普通玩家
			tStar4 = {min = 50, max = math.huge},		--老玩家
		},
		
		--最近5场总星数[区间左闭右开)
		extraSection = {
			rStar1 = {min = -9999, max = 10},			--协助刷分玩家（高挫折感玩家）
			rStar2 = {min = 10, max = 40},				--一般玩家
			rStar3 = {min = 40, max = math.huge},		--高水平玩家、刷分玩家()
		},
		
		--匹配检测时间区段（队列中的玩家每当到达时间点便尝试发起一次匹配）（区间左闭右开）
		timeSection = {
			--(min最小值 max最大值 idx程序用的排序索引)
			time1 = {min = 0, max = 10, idx = 1},			--初始进入
			time2 = {min = 10, max = 20, idx = 2},			--10秒时
			time3 = {min = 20, max = 30, idx = 3},			--20秒时
			time4 = {min = 30, max = 40, idx = 4},			--30秒时
			time5 = {min = 40, max = 50, idx = 5},			--40秒时
			time6 = {min = 50, max = 60, idx = 6},			--50秒时
			time7 = {min = 60, max = math.huge, idx = 7},		--60秒时
		},
		
		--一般匹配规则
		normalRule = {
			--新玩家(第1把)
			tStar1 = {
				--time1 = {"CLevel1"},					--初始进入
				--time2 = {"CLevel1"},					--10秒时
				--time3 = {"CLevel1"},					--20秒时
				--time4 = {"CLevel1"},					--30秒时
				time1 = {"CLevel1"},					--初始进入
				time2 = {"CLevel1"},					--10秒时
				time3 = {"CLevel1"},					--20秒时
				time4 = {"CLevel1"},					--30秒时
				time5 = {"CLevel1"},					--40秒时
				time6 = {"CLevel1"},					--50秒时
				time7 = {"CLevel1"},					--60秒时
			},
			
			--菜鸟玩家
			tStar2 = {
				time1 = {"PLevel2"},						--初始进入
				time2 = {"PLevel2","PLevel3"},				--10秒时
				--time3 = {"PLevel2","PLevel3","CLevel2"},	--20秒时
				time3 = {"PLevel2","PLevel3"},				--20秒时
				time4 = {"PLevel2","PLevel3"},				--30秒时
				time5 = {"PLevel2","PLevel3","PLevel4"},	--40秒时
				time6 = {"PLevel2","PLevel3","PLevel4"},	--50秒时
				time7 = {"PLevel2","PLevel3","PLevel4"},	--50秒时
			},
			
			--普通玩家
			tStar3 = {
				time1 = {"PLevel3"},						--初始进入
				time2 = {"PLevel3","PLevel2","PLevel4"},		--10秒时
				--time3 = {"PLevel3","PLevel2","PLevel4","CLevel3"},	--20秒时
				time3 = {"PLevel3","PLevel2","PLevel4"},	--20秒时
				time4 = {"PLevel3","PLevel2","PLevel4"},	--30秒时
				time5 = {"PLevel3","PLevel2","PLevel4"},--40秒时
				time6 = {"PLevel3","PLevel2","PLevel4"},--50秒时
				time7 = {"PLevel3","PLevel2","PLevel4"},--50秒时
			},
			
			--老玩家
			tStar4 = {
				time1 = {"PLevel4"},					--初始进入
				time2 = {"PLevel4","PLevel3",},			--10秒时
				--time3 = {"PLevel4","PLevel3","CLevel4"},	--20秒时
				time3 = {"PLevel4","PLevel3"},			--20秒时
				time4 = {"PLevel4","PLevel3"},			--30秒时
				time5 = {"PLevel4","PLevel3","PLevel2"},	--40秒时
				time6 = {"PLevel4","PLevel3","PLevel2"},	--50秒时
				time7 = {"PLevel4","PLevel3","PLevel2"},	--50秒时
			},
		},
		
		--特殊规则
		extraRule = {
			--最近5场 协助刷分玩家（高挫折感玩家）
			rStar1 = {
				time1 = {"PLevel11"},					--初始进入
				--time2 = {"PLevel11","CLevel2"},		--10秒时
				time2 = {"PLevel11"},					--10秒时
				time3 = {"PLevel11"},					--20秒时
				time4 = {"PLevel11"},					--30秒时
				time5 = {"PLevel11"},					--40秒时
				time6 = {"PLevel11"},					--50秒时
				time7 = {"PLevel11"},					--60秒时
			},
			
			--最近5场 一般玩家
			rStar2 = {
				time1 = {"PLevel12"},					--初始进入
				time2 = {"PLevel12"},					--10秒时
				time3 = {"PLevel12"},					--20秒时
				time4 = {"PLevel12"},					--30秒时
				time5 = {"PLevel12"},					--40秒时
				time6 = {"PLevel12"},					--50秒时
				time7 = {"PLevel12"},					--60秒时
			},
			
			--最近5场 高水平玩家、刷分玩家
			rStar3 = {
				time1 = {"PLevel4"},					--初始进入
				--time2 = {"PLevel4","CLevel5"},		--10秒时
				time2 = {"PLevel4"},					--10秒时
				time3 = {"PLevel4"},					--20秒时
				time4 = {"PLevel4"},					--30秒时
				time5 = {"PLevel4"},					--40秒时
				time6 = {"PLevel4"},					--50秒时
				time7 = {"PLevel4"},					--60秒时
			},
			
		},
	},
	]]
	
	--匹配设置（新）
	matchSetting = {
		
		--玩家分类
		playerType = {
			
			
			CLevelAI_01 = hVar.POS_TYPE.AI_EASY,			--新手AI
			CLevelAI_02 = hVar.POS_TYPE.AI_NORMAL,			--简单AI
			CLevelAI_03 = hVar.POS_TYPE.AI_HARD,			--中等AI
			CLevelAI_04 = hVar.POS_TYPE.AI_EXPERTS,			--高级AI
			CLevelAI_05 = hVar.POS_TYPE.AI_PROFESSIONAL,		--超级AI
			
			SKIP = 0,						--跳过
			
			PLevel_01 = {"normalSection", "tStar1"},		--段位1
			PLevel_02 = {"normalSection", "tStar2"},		--段位2
			PLevel_03 = {"normalSection", "tStar3"},		--段位3
			PLevel_04 = {"normalSection", "tStar4"},		--段位4
			PLevel_05 = {"normalSection", "tStar5"},		--段位5
			PLevel_06 = {"normalSection", "tStar6"},		--段位6
			PLevel_07 = {"normalSection", "tStar7"},		--段位7
			PLevel_08 = {"normalSection", "tStar8"},		--段位8
			PLevel_09 = {"normalSection", "tStar9"},		--段位9
			PLevel_10 = {"normalSection", "tStar10"},		--段位10
			PLevel_11 = {"normalSection", "tStar11"},		--段位11
			PLevel_12 = {"normalSection", "tStar12"},		--段位12
			PLevel_13 = {"normalSection", "tStar13"},		--段位13
			PLevel_14 = {"normalSection", "tStar14"},		--段位14
			PLevel_15 = {"normalSection", "tStar15"},		--段位15
			PLevel_16 = {"normalSection", "tStar16"},		--段位16
			
			--PLevel11 = {"extraSection","rStar1"},		--协助刷分玩家（高挫折感玩家）
			--PLevel12 = {"extraSection","rStar2"},		--一般玩家
			--PLevel13 = {"extraSection","rStar3"},		--高水平玩家、刷分玩家
		},
		
		--玩家匹配房总胜场数区间 [区间左闭右开)
		normalSection = {
			tStar1 = {min = 0, max = 2,},				--段位1
			tStar2 = {min = 2, max = 3,},				--段位2
			tStar3 = {min = 3, max = 4},				--段位3
			tStar4 = {min = 4, max = 5},				--段位4
			tStar5 = {min = 5, max = 6},				--段位5
			tStar6 = {min = 6, max = 7},				--段位6
			tStar7 = {min = 7, max = 8},				--段位7
			tStar8 = {min = 8, max = 9},				--段位8
			tStar9 = {min = 9, max = 10},				--段位9
			tStar10 = {min = 10, max = 11},				--段位10
			tStar11 = {min = 11, max = 12},				--段位11
			tStar12 = {min = 12, max = 13},				--段位12
			tStar13 = {min = 13, max = 14},				--段位13
			tStar14 = {min = 14, max = 15},				--段位14
			tStar15 = {min = 15, max = 16},				--段位15
			tStar16 = {min = 16, max = math.huge},			--段位16
		},
		
		--最近5场总星数[区间左闭右开)
		extraSection = {
			rStar1 = {min = -9999, max = math.huge},		--无
		},
		
		--匹配检测时间区段（队列中的玩家每当到达时间点便尝试发起一次匹配） [区间左闭右开）
		timeSection = {
			--(min最小值 max最大值 idx程序用的排序索引)
			time1 = {min = 1, max = 5, idx = 1},			--初始进入
			time2 = {min = 5, max = 10, idx = 2},			--5秒时
			time3 = {min = 10, max = 15, idx = 3},			--10秒时
			time4 = {min = 15, max = 20, idx = 4},			--15秒时
			time5 = {min = 20, max = 25, idx = 5},			--20秒时
			time6 = {min = 25, max = 30, idx = 6},			--25秒时
			time7 = {min = 30, max = 35, idx = 7},			--30秒时
			time8 = {min = 35, max = 40, idx = 8},			--35秒时
			time9 = {min = 40, max = 45, idx = 9},			--40秒时
			time10 = {min = 45, max = 50, idx = 10},		--45秒时
			time11 = {min = 50, max = 55, idx = 11},		--50秒时
			time12 = {min = 55, max = 60, idx = 12},		--55秒时
			time13 = {min = 60, max = math.huge, idx = 13},		--60秒时
		},
		
		--一般匹配规则
		normalRule = {
			--段位1 无名小将III 匹配规则（受保护1-4）（15秒内）
			tStar1 = {
				time1 = {"PLevel_01","PLevel_02",},				--初始进入（受保护-2）
				time2 = {"PLevel_01","PLevel_02","PLevel_03",},			--5秒时（受保护-1）
				time3 = {"PLevel_01","PLevel_02","PLevel_03","PLevel_04",},	--10秒时(end!)（受保护）
				time4 = {"CLevelAI_01",},					--15秒时
				time5 = {"CLevelAI_01",},					--20秒时
				time6 = {"CLevelAI_01",},					--25秒时
				time7 = {"CLevelAI_01",},					--30秒时
				time8 = {"CLevelAI_01",},					--35秒时
				time9 = {"CLevelAI_01",},					--40秒时
				time10 = {"CLevelAI_01",},					--45秒时
				time11 = {"CLevelAI_01",},					--50秒时
				time12 = {"CLevelAI_01",},					--55秒时
				time13 = {"CLevelAI_01",},					--60秒时
			},
			
			--段位2 无名小将II 匹配规则（20秒内）
			tStar2 = {
				time1 = {"PLevel_02","PLevel_01","PLevel_03","PLevel_04","PLevel_05",},		--初始进入
				time2 = {"PLevel_02","PLevel_01","PLevel_03","PLevel_04","PLevel_05","PLevel_06",},		--5秒时
				time3 = {"PLevel_02","PLevel_01","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_07",},		--10秒时
				time4 = {"PLevel_02","PLevel_01","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08",},		--15秒时(end!)
				time5 = {"CLevelAI_01",},					--20秒时
				time6 = {"CLevelAI_01",},					--25秒时
				time7 = {"CLevelAI_01",},					--30秒时
				time8 = {"CLevelAI_01",},					--35秒时
				time9 = {"CLevelAI_01",},					--40秒时
				time10 = {"CLevelAI_01",},					--45秒时
				time11 = {"CLevelAI_01",},					--50秒时
				time12 = {"CLevelAI_01",},					--55秒时
				time13 = {"CLevelAI_01",},					--60秒时
			},
			
			--段位3 无名小将I 匹配规则（20秒内）
			tStar3 = {
				time1 = {"PLevel_03","PLevel_01","PLevel_02","PLevel_04","PLevel_05","PLevel_06",},		--初始进入
				time2 = {"PLevel_03","PLevel_01","PLevel_02","PLevel_04","PLevel_05","PLevel_06","PLevel_07",},		--5秒时
				time3 = {"PLevel_03","PLevel_01","PLevel_02","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08",},		--10秒时
				time4 = {"PLevel_03","PLevel_01","PLevel_02","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09",},		--15秒时(end!)
				time5 = {"CLevelAI_01",},					--20秒时
				time6 = {"CLevelAI_01",},					--25秒时
				time7 = {"CLevelAI_01",},					--30秒时
				time8 = {"CLevelAI_01",},					--35秒时
				time9 = {"CLevelAI_01",},					--40秒时
				time10 = {"CLevelAI_01",},					--45秒时
				time11 = {"CLevelAI_01",},					--50秒时
				time12 = {"CLevelAI_01",},					--55秒时
				time13 = {"CLevelAI_01",},					--60秒时
			},
			
			--段位4 一骑当先III 匹配规则（20秒内）
			tStar4 = {
				time1 = {"PLevel_04","PLevel_01","PLevel_02","PLevel_03","PLevel_05","PLevel_06","PLevel_07",},		--初始进入
				time2 = {"PLevel_04","PLevel_01","PLevel_02","PLevel_03","PLevel_05","PLevel_06","PLevel_07","PLevel_08",},		--5秒时
				time3 = {"PLevel_04","PLevel_01","PLevel_02","PLevel_03","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09",},		--10秒时
				time4 = {"PLevel_04","PLevel_01","PLevel_02","PLevel_03","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10",},		--15秒时(end!)
				time5 = {"CLevelAI_02",},					--20秒时
				time6 = {"CLevelAI_02",},					--25秒时
				time7 = {"CLevelAI_02",},					--30秒时
				time8 = {"CLevelAI_02",},					--35秒时
				time9 = {"CLevelAI_02",},					--40秒时
				time10 = {"CLevelAI_02",},					--45秒时
				time11 = {"CLevelAI_02",},					--50秒时
				time12 = {"CLevelAI_02",},					--55秒时
				time13 = {"CLevelAI_02",},					--60秒时
			},
			
			--段位5 一骑当先II 匹配规则（20秒内）
			tStar5 = {
				time1 = {"PLevel_05","PLevel_02","PLevel_03","PLevel_04","PLevel_06","PLevel_07","PLevel_08",},		--初始进入
				time2 = {"PLevel_05","PLevel_02","PLevel_03","PLevel_04","PLevel_06","PLevel_07","PLevel_08","PLevel_09",},		--5秒时
				time3 = {"PLevel_05","PLevel_02","PLevel_03","PLevel_04","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10",},		--10秒时
				time4 = {"PLevel_05","PLevel_02","PLevel_03","PLevel_04","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11",},		--15秒时(end!)
				time5 = {"CLevelAI_02",},					--20秒时
				time6 = {"CLevelAI_02",},					--25秒时
				time7 = {"CLevelAI_02",},					--30秒时
				time8 = {"CLevelAI_02",},					--35秒时
				time9 = {"CLevelAI_02",},					--40秒时
				time10 = {"CLevelAI_02",},					--45秒时
				time11 = {"CLevelAI_02",},					--50秒时
				time12 = {"CLevelAI_02",},					--55秒时
				time13 = {"CLevelAI_02",},					--60秒时
			},
			
			--段位6 一骑当先I 匹配规则（20秒内）
			tStar6 = {
				time1 = {"PLevel_06","PLevel_03","PLevel_04","PLevel_05","PLevel_07","PLevel_08","PLevel_09",},		--初始进入
				time2 = {"PLevel_06","PLevel_02","PLevel_03","PLevel_04","PLevel_05","PLevel_07","PLevel_08","PLevel_09","PLevel_10",},		--5秒时
				time3 = {"PLevel_06","PLevel_02","PLevel_03","PLevel_04","PLevel_05","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11",},		--10秒时
				time4 = {"PLevel_06","PLevel_02","PLevel_03","PLevel_04","PLevel_05","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12",},		--15秒时(end!)
				time5 = {"CLevelAI_02",},					--20秒时
				time6 = {"CLevelAI_02",},					--25秒时
				time7 = {"CLevelAI_02",},					--30秒时
				time8 = {"CLevelAI_02",},					--35秒时
				time9 = {"CLevelAI_02",},					--40秒时
				time10 = {"CLevelAI_02",},					--45秒时
				time11 = {"CLevelAI_02",},					--50秒时
				time12 = {"CLevelAI_02",},					--55秒时
				time13 = {"CLevelAI_02",},					--60秒时
			},
			
			--段位7 勇冠三军III 匹配规则（25秒内）
			tStar7 = {
				time1 = {"PLevel_07","PLevel_04","PLevel_05","PLevel_06","PLevel_08","PLevel_09","PLevel_10",},		--初始进入
				time2 = {"PLevel_07","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_08","PLevel_09","PLevel_10","PLevel_11",},		--5秒时
				time3 = {"PLevel_07","PLevel_02","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12",},		--10秒时
				time4 = {"PLevel_07","PLevel_02","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13",},		--15秒时
				time5 = {"PLevel_07","PLevel_02","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14",},		--20秒时(end!)
				time6 = {"CLevelAI_03",},					--25秒时
				time7 = {"CLevelAI_03",},					--30秒时
				time8 = {"CLevelAI_03",},					--35秒时
				time9 = {"CLevelAI_03",},					--40秒时
				time10 = {"CLevelAI_03",},					--45秒时
				time11 = {"CLevelAI_03",},					--50秒时
				time12 = {"CLevelAI_03",},					--55秒时
				time13 = {"CLevelAI_03",},					--60秒时
			},
			
			--段位8 勇冠三军II 匹配规则（25秒内）
			tStar8 = {
				time1 = {"PLevel_08","PLevel_05","PLevel_06","PLevel_07","PLevel_09","PLevel_10","PLevel_11",},		--初始进入
				time2 = {"PLevel_08","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_09","PLevel_10","PLevel_11","PLevel_12",},		--5秒时
				time3 = {"PLevel_08","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13",},		--10秒时
				time4 = {"PLevel_08","PLevel_02","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14",},		--15秒时
				time5 = {"PLevel_08","PLevel_02","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15",},		--20秒时(end!)
				time6 = {"CLevelAI_03",},					--25秒时
				time7 = {"CLevelAI_03",},					--30秒时
				time8 = {"CLevelAI_03",},					--35秒时
				time9 = {"CLevelAI_03",},					--40秒时
				time10 = {"CLevelAI_03",},					--45秒时
				time11 = {"CLevelAI_03",},					--50秒时
				time12 = {"CLevelAI_03",},					--55秒时
				time13 = {"CLevelAI_03",},					--60秒时
			},
			
			--段位9 勇冠三军I 匹配规则（25秒内）
			tStar9 = {
				time1 = {"PLevel_09","PLevel_06","PLevel_07","PLevel_08","PLevel_10","PLevel_11","PLevel_12",},		--初始进入
				time2 = {"PLevel_09","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_10","PLevel_11","PLevel_12","PLevel_13",},		--5秒时
				time3 = {"PLevel_09","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14",},		--10秒时
				time4 = {"PLevel_09","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15",},		--15秒时
				time5 = {"PLevel_09","PLevel_02","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--20秒时(end!)
				time6 = {"CLevelAI_03",},					--25秒时
				time7 = {"CLevelAI_03",},					--30秒时
				time8 = {"CLevelAI_03",},					--35秒时
				time9 = {"CLevelAI_03",},					--40秒时
				time10 = {"CLevelAI_03",},					--45秒时
				time11 = {"CLevelAI_03",},					--50秒时
				time12 = {"CLevelAI_03",},					--55秒时
				time13 = {"CLevelAI_03",},					--60秒时
			},
			
			--段位10 威震八方III 匹配规则（25秒内）
			tStar10 = {
				time1 = {"PLevel_10","PLevel_07","PLevel_08","PLevel_09","PLevel_11","PLevel_12","PLevel_13",},		--初始进入
				time2 = {"PLevel_10","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_11","PLevel_12","PLevel_13","PLevel_14",},		--5秒时
				time3 = {"PLevel_10","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15",},		--10秒时
				time4 = {"PLevel_10","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--15秒时
				time5 = {"PLevel_10","PLevel_03","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--20秒时(end!)
				time6 = {"CLevelAI_04",},					--25秒时
				time7 = {"CLevelAI_04",},					--30秒时
				time8 = {"CLevelAI_04",},					--35秒时
				time9 = {"CLevelAI_04",},					--40秒时
				time10 = {"CLevelAI_04",},					--45秒时
				time11 = {"CLevelAI_04",},					--50秒时
				time12 = {"CLevelAI_04",},					--55秒时
				time13 = {"CLevelAI_04",},					--60秒时
			},
			
			--段位11 威震八方II 匹配规则（25秒内）
			tStar11 = {
				time1 = {"PLevel_11","PLevel_08","PLevel_09","PLevel_10","PLevel_12","PLevel_13","PLevel_14",},		--初始进入
				time2 = {"PLevel_11","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_12","PLevel_13","PLevel_14","PLevel_15",},		--5秒时
				time3 = {"PLevel_11","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_12","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--10秒时
				time4 = {"PLevel_11","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_12","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--15秒时
				time5 = {"PLevel_11","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_12","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--20秒时(end!)
				time6 = {"CLevelAI_04",},					--25秒时
				time7 = {"CLevelAI_04",},					--30秒时
				time8 = {"CLevelAI_04",},					--35秒时
				time9 = {"CLevelAI_04",},					--40秒时
				time10 = {"CLevelAI_04",},					--45秒时
				time11 = {"CLevelAI_04",},					--50秒时
				time12 = {"CLevelAI_04",},					--55秒时
				time13 = {"CLevelAI_04",},					--60秒时
			},
			
			--段位12 威震八方I 匹配规则（30秒内）
			tStar12 = {
				time1 = {"PLevel_12","PLevel_09","PLevel_10","PLevel_11","PLevel_13","PLevel_14","PLevel_15",},		--初始进入
				time2 = {"PLevel_12","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--5秒时
				time3 = {"PLevel_12","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--10秒时
				time4 = {"PLevel_12","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--15秒时
				time5 = {"PLevel_12","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--20秒时
				time6 = {"PLevel_12","PLevel_04","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_13","PLevel_14","PLevel_15","PLevel_16",},		--25秒时(end!)
				time7 = {"CLevelAI_04",},					--30秒时
				time8 = {"CLevelAI_04",},					--35秒时
				time9 = {"CLevelAI_04",},					--40秒时
				time10 = {"CLevelAI_04",},					--45秒时
				time11 = {"CLevelAI_04",},					--50秒时
				time12 = {"CLevelAI_04",},					--55秒时
				time13 = {"CLevelAI_04",},					--60秒时
			},
			
			--段位13 横扫千军III 匹配规则（30秒内）
			tStar13 = {
				time1 = {"PLevel_13","PLevel_10","PLevel_11","PLevel_12","PLevel_14","PLevel_15","PLevel_16",},		--初始进入
				time2 = {"PLevel_13","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_14","PLevel_15","PLevel_16",},		--5秒时
				time3 = {"PLevel_13","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_14","PLevel_15","PLevel_16",},		--10秒时
				time4 = {"PLevel_13","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_14","PLevel_15","PLevel_16",},		--15秒时
				time5 = {"PLevel_13","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_14","PLevel_15","PLevel_16",},		--20秒时
				time6 = {"PLevel_13","PLevel_05","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_14","PLevel_15","PLevel_16",},		--25秒时(end!)
				time7 = {"CLevelAI_04",},					--30秒时
				time8 = {"CLevelAI_04",},					--35秒时
				time9 = {"CLevelAI_04",},					--40秒时
				time10 = {"CLevelAI_04",},					--45秒时
				time11 = {"CLevelAI_04",},					--50秒时
				time12 = {"CLevelAI_04",},					--55秒时
				time13 = {"CLevelAI_04",},					--60秒时
			},
			
			--段位14 横扫千军II 匹配规则（30秒内）
			tStar14 = {
				time1 = {"PLevel_14","PLevel_11","PLevel_12","PLevel_13","PLevel_15","PLevel_16",},		--初始进入
				time2 = {"PLevel_14","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_15","PLevel_16",},		--5秒时
				time3 = {"PLevel_14","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_15","PLevel_16",},		--10秒时
				time4 = {"PLevel_14","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_15","PLevel_16",},		--15秒时
				time5 = {"PLevel_14","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_15","PLevel_16",},		--20秒时
				time6 = {"PLevel_14","PLevel_06","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_15","PLevel_16",},		--25秒时(end!)
				time7 = {"CLevelAI_05",},					--30秒时
				time8 = {"CLevelAI_05",},					--35秒时
				time9 = {"CLevelAI_05",},					--40秒时
				time10 = {"CLevelAI_05",},					--45秒时
				time11 = {"CLevelAI_05",},					--50秒时
				time12 = {"CLevelAI_05",},					--55秒时
				time13 = {"CLevelAI_05",},					--60秒时
			},
			
			--段位15 横扫千军I 匹配规则（30秒内）
			tStar15 = {
				time1 = {"PLevel_15","PLevel_12","PLevel_13","PLevel_14","PLevel_16",},	--初始进入
				time2 = {"PLevel_15","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_16",},		--5秒时
				time3 = {"PLevel_15","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_16",},		--10秒时
				time4 = {"PLevel_15","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_16",},		--15秒时
				time5 = {"PLevel_15","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_16",},		--20秒时
				time6 = {"PLevel_15","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_16",},		--25秒时(end!)
				time7 = {"CLevelAI_05",},					--30秒时
				time8 = {"CLevelAI_05",},					--35秒时
				time9 = {"CLevelAI_05",},					--40秒时
				time10 = {"CLevelAI_05",},					--45秒时
				time11 = {"CLevelAI_05",},					--50秒时
				time12 = {"CLevelAI_05",},					--55秒时
				time13 = {"CLevelAI_05",},					--60秒时
			},
			
			--段位16 天下无双 匹配规则（30秒内）
			tStar16 = {
				time1 = {"PLevel_16","PLevel_13","PLevel_14","PLevel_15",},	--初始进入
				time2 = {"PLevel_16","PLevel_12","PLevel_13","PLevel_14","PLevel_15",},		--5秒时
				time3 = {"PLevel_16","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15",},		--10秒时
				time4 = {"PLevel_16","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15",},		--15秒时
				time5 = {"PLevel_16","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15",},		--20秒时
				time6 = {"PLevel_16","PLevel_07","PLevel_08","PLevel_09","PLevel_10","PLevel_11","PLevel_12","PLevel_13","PLevel_14","PLevel_15",},		--25秒时(end!)（额外+1）
				time7 = {"CLevelAI_05",},					--30秒时
				time8 = {"CLevelAI_05",},					--35秒时
				time9 = {"CLevelAI_05",},					--40秒时
				time10 = {"CLevelAI_05",},					--45秒时
				time11 = {"CLevelAI_05",},					--50秒时
				time12 = {"CLevelAI_05",},					--55秒时
				time13 = {"CLevelAI_05",},					--60秒时
			},
		},
		
		--特殊规则
		extraRule = {
			--最近5场 协助刷分玩家（高挫折感玩家）
			--无
		},
	},
	
	--开放时间段(每日可配置多个时间段)
	openTime = 
	{
		normal = {
			{beginTime = "12:00:00", endTime = "12:59:59",},
			{beginTime = "19:00:00", endTime = "19:59:59",},
		},
	},
	
	--有效局条件(夺塔奇兵-匹配)
	validCondition = 
	{
		--3分钟
		timeLimit = 180000,					--最低游戏时长（单位毫秒）
	},
	reward = {
	},
}


-----------------------------------------------------------【军团-铁】--------------------------------------------------------
--geyachao: 新加房间的配置项 军团
--军团-铁
_tab_room[5] = 
{
	mapkey = "world/td_jt_003",
	
	groupMapFlag = 1, --是否为军团地图
	fps = 60, --指定帧数fps
	
	confgInfo = 
	{
		--势力1
		[1] = 
		{
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_SHU"],		--势力描述
			defaultType = hVar.POS_TYPE.BLANK,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = false,				--是否只允许电脑
			
		},
		--势力2
		[2] = 
		{
			--默认
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_WEI"],		--势力描述
			defaultType = hVar.POS_TYPE.AI_HARD,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = true,				--是否只允许电脑
			
		},
	},
	
	kickoutCD = 86400, --玩家超时踢出的最大等待时间(秒)
	
	--挑战次数
	challengeMaxCount = 1,
	
	--显示奖励
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{16,1},
			{1,1},
			{20,5},
		},
		[hVar.POS_TYPE.AI_NORMAL] = {
			{16,2},
			{1,1},
			{20,5},
		},
		[hVar.POS_TYPE.AI_HARD] = {
			{16,3},
			{1,1},
			{20,5},
			{11,100},
		},
	},
	
	--铁结束奖励
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"tie_001",1,1},			--{奖池,最小个数,最大个数)}
			{"tie_001",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_002",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_002",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_002",1,1},			--{奖池,最小个数,最大个数)}
		},
		[hVar.POS_TYPE.AI_NORMAL] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"tie_001",1,1},			--{奖池,最小个数,最大个数)}
			{"tie_001",1,1},			--{奖池,最小个数,最大个数)}
			{"tie_001",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_002",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_002",1,1},			--{奖池,最小个数,最大个数)}
		},
		[hVar.POS_TYPE.AI_HARD] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"tie_001",1,1},			--{奖池,最小个数,最大个数)}
			{"tie_001",1,1},			--{奖池,最小个数,最大个数)}
			{"tie_001",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_003",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_003",1,1},			--{奖池,最小个数,最大个数)}
		},
	},
	
	--地图全局战术技能(铜雀台)
	tacticPool = 
	{
		--第一类
		[1] = {
			totalValue = 30,
			{value = 10, reward = {3220,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3221,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3222,1},},			--战术技能卡id，战术技能卡等级
		},
		
		--第二类
		[2] = {
			totalValue = 40,
			{value = 10, reward = {3210,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3211,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3212,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3213,1},},			--战术技能卡id，战术技能卡等级
		},
	},
	
	--开放时间段(每日可配置多个时间段)
	openTime = 
	{
		normal = {
			{beginTime = "00:00:00", endTime = "23:59:59",},
		},
	},
	
	--有效局条件(铜雀台)
	validCondition = 
	{
		--2分钟
		--timeLimit = 120000,					--最低游戏时长（单位毫秒）
		timeLimit = 0,					--最低游戏时长（单位毫秒）
	},
}

-----------------------------------------------------------【军团-木材】--------------------------------------------------------
--geyachao: 新加房间的配置项 军团
--军团-木材
_tab_room[6] = 
{
	mapkey = "world/td_jt_001",
	
	groupMapFlag = 1, --是否为军团地图
	fps = 60, --指定帧数fps
	
	confgInfo = 
	{
		--势力1
		[1] = 
		{
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_SHU"],		--势力描述
			defaultType = hVar.POS_TYPE.BLANK,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = false,				--是否只允许电脑
			
		},
		--势力2
		[2] = 
		{
			--默认
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_WEI"],		--势力描述
			defaultType = hVar.POS_TYPE.AI_HARD,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = true,				--是否只允许电脑
			
		},
	},
	
	kickoutCD = 86400, --玩家超时踢出的最大等待时间(秒)
	
	--挑战次数
	challengeMaxCount = 1,
	
	--显示奖励
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{17,1},
			{1,1},
			{20,5},
		},
		[hVar.POS_TYPE.AI_NORMAL] = {
			{17,2},
			{1,1},
			{20,5},
		},
		[hVar.POS_TYPE.AI_HARD] = {
			{17,3},
			{1,1},
			{20,5},
			{11,100},
		},
	},
	
	--木材结束奖励
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"mucai_001",1,1},			--{奖池,最小个数,最大个数)}
			{"mucai_001",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_002",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_002",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_002",1,1},			--{奖池,最小个数,最大个数)}
		},
		[hVar.POS_TYPE.AI_NORMAL] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"mucai_001",1,1},			--{奖池,最小个数,最大个数)}
			{"mucai_001",1,1},			--{奖池,最小个数,最大个数)}
			{"mucai_001",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_002",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_002",1,1},			--{奖池,最小个数,最大个数)}
		},
		[hVar.POS_TYPE.AI_HARD] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"mucai_001",1,1},			--{奖池,最小个数,最大个数)}
			{"mucai_001",1,1},			--{奖池,最小个数,最大个数)}
			{"mucai_001",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_003",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_003",1,1},			--{奖池,最小个数,最大个数)}
		},
	},
	
	--地图全局战术技能(铜雀台)
	tacticPool = 
	{
		--第一类
		[1] = {
			totalValue = 30,
			{value = 10, reward = {3220,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3221,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3222,1},},			--战术技能卡id，战术技能卡等级
		},
		
		--第二类
		[2] = {
			totalValue = 40,
			{value = 10, reward = {3210,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3211,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3212,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3213,1},},			--战术技能卡id，战术技能卡等级
		},
	},
	
	--开放时间段(每日可配置多个时间段)
	openTime = 
	{
		normal = {
			{beginTime = "00:00:00", endTime = "23:59:59",},
		},
	},
	
	--有效局条件(铜雀台)
	validCondition = 
	{
		--2分钟
		--timeLimit = 120000,					--最低游戏时长（单位毫秒）
		timeLimit = 0,					--最低游戏时长（单位毫秒）
	},
}

-----------------------------------------------------------【军团-粮食】--------------------------------------------------------
--geyachao: 新加房间的配置项 军团
--军团-粮食
_tab_room[7] = 
{
	mapkey = "world/td_jt_002",
	
	groupMapFlag = 1, --是否为军团地图
	fps = 60, --指定帧数fps
	
	confgInfo = 
	{
		--势力1
		[1] = 
		{
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_SHU"],		--势力描述
			defaultType = hVar.POS_TYPE.BLANK,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = false,				--是否只允许电脑
			
		},
		--势力2
		[2] = 
		{
			--默认
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_WEI"],		--势力描述
			defaultType = hVar.POS_TYPE.AI_HARD,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = true,				--是否只允许电脑
			
		},
	},
	
	kickoutCD = 86400, --玩家超时踢出的最大等待时间(秒)
	
	--挑战次数
	challengeMaxCount = 1,
	
	--显示奖励
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{18,1},
			{1,1},
			{20,5},
		},
		[hVar.POS_TYPE.AI_NORMAL] = {
			{18,2},
			{1,1},
			{20,5},
		},
		[hVar.POS_TYPE.AI_HARD] = {
			{18,3},
			{1,1},
			{20,5},
			{11,100},
		},
	},
	
	--粮食结束奖励
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"liangshi_001",1,1},			--{奖池,最小个数,最大个数)}
			{"liangshi_001",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_002",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_002",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_002",1,1},			--{奖池,最小个数,最大个数)}
		},
		[hVar.POS_TYPE.AI_NORMAL] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"liangshi_001",1,1},			--{奖池,最小个数,最大个数)}
			{"liangshi_001",1,1},			--{奖池,最小个数,最大个数)}
			{"liangshi_001",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_002",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_002",1,1},			--{奖池,最小个数,最大个数)}
		},
		[hVar.POS_TYPE.AI_HARD] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"liangshi_001",1,1},			--{奖池,最小个数,最大个数)}
			{"liangshi_001",1,1},			--{奖池,最小个数,最大个数)}
			{"liangshi_001",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_003",1,1},			--{奖池,最小个数,最大个数)}
			{"Boss_003",1,1},			--{奖池,最小个数,最大个数)}
		},
	},
	
	
	--地图全局战术技能(铜雀台)
	tacticPool = 
	{
		--第一类
		[1] = {
			totalValue = 30,
			{value = 10, reward = {3220,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3221,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3222,1},},			--战术技能卡id，战术技能卡等级
		},
		
		--第二类
		[2] = {
			totalValue = 40,
			{value = 10, reward = {3210,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3211,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3212,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3213,1},},			--战术技能卡id，战术技能卡等级
		},
	},
	
	--开放时间段(每日可配置多个时间段)
	openTime = 
	{
		normal = {
			{beginTime = "00:00:00", endTime = "23:59:59",},
		},
	},
	
	--有效局条件(铜雀台)
	validCondition = 
	{
		--2分钟
		--timeLimit = 120000,					--最低游戏时长（单位毫秒）
		timeLimit = 0,					--最低游戏时长（单位毫秒）
	},
}

-----------------------------------------------------------【军团-军团宝库副本】--------------------------------------------------------
--geyachao: 新加房间的配置项 军团
--军团-军团宝库
_tab_room[8] = 
{
	mapkey = "world/td_jt_004",
	
	groupMapFlag = 1, --是否为军团地图
	
	confgInfo = 
	{
		--势力1
		[1] = 
		{
			maxNum = 2,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_SHU"],		--势力描述
			defaultType = hVar.POS_TYPE.BLANK,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = false,				--该势力允许玩家进入
			
		},
		--势力2
		[2] = 
		{
			--默认
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_WEI"],		--势力描述
			defaultType = hVar.POS_TYPE.AI_EASY,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = true,				--该势力不允许玩家进入
			
		},
	},
	
	kickoutCD = 180, --玩家超时踢出的最大等待时间(秒)
	
	--挑战次数
	challengeMaxCount = 1,
	
	--显示奖励
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{10,12412},
			{10,12406},
			{5,10231,1,},
			{5,10235,1,},
		},
	},
	
	--军团宝库结束奖励
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"Boss_001",1,1},			--{奖池,最小个数,最大个数)} --献祭之石
			{"Equip_juntuanfuben",1,1},		--{奖池,最小个数,最大个数)} --军团神器
			{"juntuan_dongzhuo",1,1},		--{奖池,最小个数,最大个数)} --董卓将魂
			{"juntuan_sunjian",1,1},		--{奖池,最小个数,最大个数)} --孙坚将魂
			{"Boss_003",1,2},			--{奖池,最小个数,最大个数)} --神器晶石
		},
	},
	
	--地图全局战术技能(军团宝库)
	tacticPool = 
	{
		--第一类
		[1] = {
			totalValue = 110,
			{value = 10, reward = {3001,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3002,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3003,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3004,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3005,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3006,1},},			--战术技能卡id，战术技能卡等级
			--{value = 10, reward = {3007,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3008,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3009,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3010,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3011,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3012,1},},			--战术技能卡id，战术技能卡等级
		},
		--第二类
		[2] = {
			totalValue = 180,
			{value = 10, reward = {3021,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3022,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3023,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3024,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3025,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3026,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3027,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3028,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3029,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3030,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3031,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3032,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3033,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3034,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3035,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3036,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3037,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3038,1},},			--战术技能卡id，战术技能卡等级
		},
		--第三类
		[3] = {
			totalValue = 140,
			{value = 10, reward = {3041,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3042,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3043,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3044,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3045,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3046,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3047,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3048,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3049,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3050,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3051,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3052,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3053,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3054,1},},			--战术技能卡id，战术技能卡等级
			   
		},
	},
	
	--开放时间段(每日可配置多个时间段)
	openTime = 
	{
		normal = {
			--{beginTime = "12:00:00", endTime = "13:59:59",},
			--{beginTime = "20:00:00", endTime = "22:59:59",},
			{beginTime = "05:00:00", endTime = "23:59:59",},
		},
	},
	
	--每周几开放的日期
	openDayOfWeek =
	{
		5,6,7,
	},
	
	--有效局条件(军团宝库)
	validCondition = 
	{
		--2分钟
		--timeLimit = 120000,					--最低游戏时长（单位毫秒）
		timeLimit = 0,					--最低游戏时长（单位毫秒）
	},
}

-----------------------------------------------------------【军团-军团驻守模式地图】--------------------------------------------------------
--军团-军团驻守模式
_tab_room[9] = 
{
	
	mapkey = "world/td_wj_005",
	
	groupMapFlag = 1, --是否为军团地图
	
	confgInfo = 
	{
		--势力1
		[1] = 
		{
			maxNum = 2,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_SHU"],		--势力描述
			defaultType = hVar.POS_TYPE.BLANK,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = false,				--该势力允许玩家进入
			
		},
		--势力2
		[2] = 
		{
			--默认
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_WEI"],		--势力描述
			defaultType = hVar.POS_TYPE.AI_EASY,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = true,				--该势力不允许玩家进入
			
		},
	},
	
	kickoutCD = 180, --玩家超时踢出的最大等待时间(秒)
	
	--挑战次数
	challengeMaxCount = 1,
	
	--显示奖励
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{10,12412},
			{10,12406},
			{5,10231,1,},
			{5,10235,1,},
		},
	},
	
	--军团宝库结束奖励
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"Boss_001",1,1},			--{奖池,最小个数,最大个数)} --献祭之石
			{"Equip_juntuanfuben",1,1},		--{奖池,最小个数,最大个数)} --军团神器
			{"juntuan_dongzhuo",1,1},		--{奖池,最小个数,最大个数)} --董卓将魂
			{"juntuan_sunjian",1,1},		--{奖池,最小个数,最大个数)} --孙坚将魂
			{"Boss_003",1,2},			--{奖池,最小个数,最大个数)} --神器晶石
		},
	},
	
	--地图全局战术技能(军团驻守模式)
	tacticPool = 
	{
		--第一类
		[1] = {
			totalValue = 110,
			{value = 10, reward = {3001,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3002,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3003,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3004,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3005,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3006,1},},			--战术技能卡id，战术技能卡等级
			--{value = 10, reward = {3007,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3008,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3009,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3010,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3011,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3012,1},},			--战术技能卡id，战术技能卡等级
		},
		--第二类
		[2] = {
			totalValue = 180,
			{value = 10, reward = {3021,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3022,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3023,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3024,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3025,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3026,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3027,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3028,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3029,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3030,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3031,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3032,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3033,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3034,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3035,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3036,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3037,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3038,1},},			--战术技能卡id，战术技能卡等级
		},
		--第三类
		[3] = {
			totalValue = 140,
			{value = 10, reward = {3041,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3042,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3043,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3044,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3045,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3046,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3047,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3048,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3049,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3050,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3051,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3052,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3053,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3054,1},},			--战术技能卡id，战术技能卡等级
			   
		},
	},
	
	--开放时间段(每日可配置多个时间段)
	openTime = 
	{
		normal = {
			--{beginTime = "12:00:00", endTime = "13:59:59",},
			--{beginTime = "20:00:00", endTime = "22:59:59",},
			{beginTime = "05:00:00", endTime = "23:59:59",},
		},
	},
	
	--每周几开放的日期
	openDayOfWeek =
	{
		5,6,7,
	},
	
	--有效局条件(军团驻守模式)
	validCondition = 
	{
		--2分钟
		--timeLimit = 120000,					--最低游戏时长（单位毫秒）
		timeLimit = 0,					--最低游戏时长（单位毫秒）
	},
}


-----------------------------------------------------------【人族无敌】--------------------------------------------------------
--人族无敌
_tab_room[10] = 
{
	mapkey = "world/td_wj_007",
	
	groupMapFlag = 0, --是否为军团地图
	fps = 30, --指定帧数fps
	
	confgInfo = 
	{
		--势力1
		[1] = 
		{
			maxNum = 2,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_SHU"],		--势力描述
			defaultType = hVar.POS_TYPE.BLANK,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = false,				--该势力允许玩家进入
			
		},
		--势力2
		[2] = 
		{
			--默认
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_WEI"],		--势力描述
			defaultType = hVar.POS_TYPE.AI_EASY,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = true,				--该势力不允许玩家进入
			
		},
	},
	
	kickoutCD = 300, --玩家超时踢出的最大等待时间(秒)
	
	--挑战次数
	challengeMaxCount = 99999,
	
	--显示奖励
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{1,1000},
		},
	},
	
	--人族无敌结束奖励
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"Boss_004",1,1},			--{奖池,最小个数,最大个数)} --献祭之石
			{"Boss_003",1,2},			--{奖池,最小个数,最大个数)} --神器晶石
			{"treasure_renzuwudi",1,1},		--{奖池,最小个数,最大个数)} --藏宝图（人族无敌掉落）
			{"treasure_renzuwudi",1,1},		--{奖池,最小个数,最大个数)} --藏宝图（人族无敌掉落）
			{"treasure_renzuwudi",1,1},		--{奖池,最小个数,最大个数)} --藏宝图（人族无敌掉落）
		},
	},
	
	--[[
	--人族无敌结束宝物碎片奖励
	rewardTreasure = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 1,				--抽的数量
			{"treasure_renzuwudi", 1, 1,},			--{奖池,最小个数,最大个数)}
		},
	},
	]]
	
	--地图全局战术技能(人族无敌)
	tacticPool = 
	{
		--第一类
		[1] = {
			totalValue = 110,
			{value = 10, reward = {3001,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3002,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3003,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3004,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3005,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3006,1},},			--战术技能卡id，战术技能卡等级
			--{value = 10, reward = {3007,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3008,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3009,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3010,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3011,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3012,1},},			--战术技能卡id，战术技能卡等级
		},
		--第二类
		[2] = {
			totalValue = 180,
			{value = 10, reward = {3021,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3022,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3023,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3024,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3025,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3026,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3027,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3028,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3029,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3030,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3031,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3032,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3033,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3034,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3035,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3036,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3037,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3038,1},},			--战术技能卡id，战术技能卡等级
		},
		--第三类
		[3] = {
			totalValue = 140,
			{value = 10, reward = {3041,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3042,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3043,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3044,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3045,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3046,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3047,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3048,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3049,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3050,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3051,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3052,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3053,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3054,1},},			--战术技能卡id，战术技能卡等级
			   
		},
	},
	
	--开放时间段(每日可配置多个时间段)
	openTime = 
	{
		normal = {
			{beginTime = "05:00:00", endTime = "23:59:59",},
		},
	},
	
	--有效局条件(人族无敌)
	validCondition = 
	{
		--2分钟
		--timeLimit = 120000,					--最低游戏时长（单位毫秒）
		timeLimit = 0,					--最低游戏时长（单位毫秒）
	},
}

-----------------------------------------------------------【魔塔杀阵】--------------------------------------------------------
--魔塔杀阵
_tab_room[11] = 
{
	mapkey = "world/td_wj_004",
	
	groupMapFlag = 0, --是否为军团地图
	
	confgInfo = 
	{
		--势力1
		[1] = 
		{
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_SHU"],		--势力描述
			defaultType = hVar.POS_TYPE.BLANK,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = false,				--是否只允许电脑
			
		},
		--势力2
		[2] = 
		{
			--默认
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_WEI"],		--势力描述
			defaultType = hVar.POS_TYPE.AI_EASY,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = true,				--是否只允许电脑
			
		},
	},
	
	kickoutCD = 86400, --玩家超时踢出的最大等待时间(秒)
	
	--挑战次数
	challengeMaxCount = 99999,
	
	--显示奖励
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{1,1000},
			--{5,10232},	--黄忠
			{11,100},
			{23,1},
			{24,1},
		},
	},
	
	--魔塔杀阵结束奖励
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"Boss_002",1,2},			--{奖池,最小个数,最大个数)} --积分
			{"Boss_003",1,2},			--{奖池,最小个数,最大个数)} --神器晶石
			{"treasure_motashazhen",1,1},		--{奖池,最小个数,最大个数)} --藏宝图（魔塔杀阵掉落）
			{"treasure_motashazhen",1,1},		--{奖池,最小个数,最大个数)} --藏宝图（魔塔杀阵掉落）
			{"treasure_motashazhen",1,1},		--{奖池,最小个数,最大个数)} --藏宝图（魔塔杀阵掉落）
		},
	},
	
	--[[
	--魔塔杀阵结束宝物碎片奖励
	rewardTreasure = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 1,				--抽的数量
			{"treasure_motashazhen", 1, 1,},			--{奖池,最小个数,最大个数)}
		},
	},
	]]
	
	--[[
	--魔塔杀阵结束奖励,每周必掉1个
	rewardPerWeek = {
		--简单难度
		[hVar.POS_TYPE.AI_EASY] = {
			min = 3,
			max = 5,
			{5,10232},	--黄忠
		},
	},
	]]
	
	--地图全局战术技能(魔塔杀阵)
	tacticPool = 
	{
		--第一类
		[1] = {
			totalValue = 40,
			{value = 10, reward = {3041,5},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3041,6},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3041,7},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3041,8},},			--战术技能卡id，战术技能卡等级
		},
		
		--第二类
		[2] = {
			totalValue = 40,
			{value = 10, reward = {3043,1},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3043,2},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3043,3},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3043,4},},			--战术技能卡id，战术技能卡等级
		},
		
		--第三类
		[3] = {
			totalValue = 30,
			{value = 10, reward = {3046,3},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3048,3},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3050,3},},			--战术技能卡id，战术技能卡等级
		},
	},
	
	--开放时间段(每日可配置多个时间段)
	openTime = 
	{
		normal = {
			{beginTime = "00:00:00", endTime = "23:59:59",},
		},
	},
	
	--有效局条件(魔塔杀阵)
	validCondition = 
	{
		--2分钟
		--timeLimit = 120000,					--最低游戏时长（单位毫秒）
		timeLimit = 0,					--最低游戏时长（单位毫秒）
	},
}

-----------------------------------------------------------【守卫剑阁】--------------------------------------------------------
--守卫剑阁
_tab_room[12] = 
{
	mapkey = "world/td_swjg",
	
	groupMapFlag = 0, --是否为军团地图
	fps = 30, --指定帧数fps
	
	confgInfo = 
	{
		--势力1
		[1] = 
		{
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_SHU"],		--势力描述
			defaultType = hVar.POS_TYPE.BLANK,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = false,				--是否只允许电脑
			
		},
		--势力2
		[2] = 
		{
			--默认
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_WEI"],		--势力描述
			defaultType = hVar.POS_TYPE.AI_EASY,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = true,				--是否只允许电脑
			
		},
	},
	
	kickoutCD = 86400, --玩家超时踢出的最大等待时间(秒)
	
	--挑战次数
	challengeMaxCount = 99999,
	
	--显示奖励
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{1,1000},
			{11,100},
			{23,1},
		},
		[hVar.POS_TYPE.AI_NORMAL] = {
			{1,1000},
			{11,100},
			{23,1},
			{24,1},
		},
		[hVar.POS_TYPE.AI_HARD] = {
			{10,12406},
			{11,100},
			{23,1},
			{24,1},
		},
	},
	
	--守卫剑阁结束奖励
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"Boss_002",1,2},			--{奖池,最小个数,最大个数)} --积分
			{"Boss_003",1,2},			--{奖池,最小个数,最大个数)} --神器晶石
			{"treasure_shouweijiange_eazy",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（守卫剑阁掉落）
			{"treasure_shouweijiange_eazy",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（守卫剑阁掉落）
			{"treasure_shouweijiange_eazy",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（守卫剑阁掉落）
		},
		
		[hVar.POS_TYPE.AI_NORMAL] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"Boss_002",1,2},			--{奖池,最小个数,最大个数)} --积分
			{"Boss_003",1,2},			--{奖池,最小个数,最大个数)} --神器晶石
			{"treasure_shouweijiange_middle",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（守卫剑阁掉落）
			{"treasure_shouweijiange_middle",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（守卫剑阁掉落）
			{"treasure_shouweijiange_middle",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（守卫剑阁掉落）
		},
		
		[hVar.POS_TYPE.AI_HARD] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"Boss_004",1,1},			--{奖池,最小个数,最大个数)} --献祭之石
			{"Boss_003",1,2},			--{奖池,最小个数,最大个数)} --神器晶石
			{"treasure_shouweijiange_hard",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（守卫剑阁掉落）
			{"treasure_shouweijiange_hard",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（守卫剑阁掉落）
			{"treasure_shouweijiange_hard",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（守卫剑阁掉落）
		},
	},
	
	--[[
	--守卫剑阁结束宝物碎片奖励
	rewardTreasure = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 1,				--抽的数量
			{"treasure_shouweijiange", 1, 1,},			--{奖池,最小个数,最大个数)}
		},
	},
	]]
	
	--[[
	--守卫剑阁结束奖励,每周必掉1个
	rewardPerWeek = {
		--简单难度
		[hVar.POS_TYPE.AI_EASY] = {
			min = 3,
			max = 5,
			{5,10237},	--孟获
			{5,10238},	--祝融夫人
		},
	},
	]]
	
	--地图全局战术技能(守卫剑阁)
	tacticPool = 
	{
		--第一类
		[1] = {
			totalValue = 100,
			{value = 100, reward = {1245,1},},			--战术技能卡id，战术技能卡等级
		},
	},
	
	--开放时间段(每日可配置多个时间段)
	openTime = 
	{
		normal = {
			{beginTime = "00:00:00", endTime = "23:59:59",},
		},
	},
	
	--有效局条件(魔塔杀阵)
	validCondition = 
	{
		--2分钟
		--timeLimit = 120000,					--最低游戏时长（单位毫秒）
		timeLimit = 0,					--最低游戏时长（单位毫秒）
	},
}

-----------------------------------------------------------【双人守卫剑阁】--------------------------------------------------------
--双人守卫剑阁
_tab_room[13] = 
{
	mapkey = "world/td_swjg2",
	--mapkey = "world/td_swjg2_s", --虎年版
	
	groupMapFlag = 0, --是否为军团地图
	fps = 30, --指定帧数fps
	
	confgInfo = 
	{
		--势力1
		[1] = 
		{
			maxNum = 2,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_SHU"],		--势力描述
			defaultType = hVar.POS_TYPE.BLANK,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = false,				--该势力允许玩家进入
			
		},
		--势力2
		[2] = 
		{
			--默认
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_WEI"],		--势力描述
			defaultType = hVar.POS_TYPE.AI_EASY,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = true,				--该势力不允许玩家进入
			
		},
	},
	
	kickoutCD = 300, --玩家超时踢出的最大等待时间(秒)
	
	--挑战次数
	challengeMaxCount = 99999,
	
	--显示奖励
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{1,1000},
		},
	},
	
	--双人守卫剑阁结束奖励
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"Boss_004_swjg2",1,1},			--{奖池,最小个数,最大个数)} --献祭之石
			{"Boss_003",1,2},			--{奖池,最小个数,最大个数)} --神器晶石
			{"treasure_shouweijiange2",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（双人守卫剑阁掉落）
			{"treasure_shouweijiange2",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（双人守卫剑阁掉落）
			{"treasure_shouweijiange2",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（双人守卫剑阁掉落）
		},
	},
	
	--[[
	--双人守卫剑阁结束奖励 虎年版
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"Boss_004_swjg2",1,1},			--{奖池,最小个数,最大个数)} --献祭之石
			{"Boss_laohu",1,1},			--{奖池,最小个数,最大个数)} --龙须虎
			{"treasure_shouweijiange2",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（双人守卫剑阁掉落）
			{"treasure_shouweijiange2",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（双人守卫剑阁掉落）
			{"treasure_shouweijiange2",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（双人守卫剑阁掉落）
		},
	},
	]]
	
	--[[
	--双人守卫剑结束宝物碎片奖励
	rewardTreasure = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 1,				--抽的数量
			{"treasure_shouweijiange2", 1, 1,},			--{奖池,最小个数,最大个数)}
		},
	},
	]]
	
	--地图全局战术技能(双人守卫剑)
	tacticPool = 
	{
		--第一类
		[1] = {
			totalValue = 100,
			{value = 100, reward = {1246,1},},			--战术技能卡id，战术技能卡等级
		},
	},
	
	--开放时间段(每日可配置多个时间段)
	openTime = 
	{
		normal = {
			{beginTime = "05:00:00", endTime = "23:59:59",},
		},
	},
	
	--有效局条件(人族无敌)
	validCondition = 
	{
		--2分钟
		--timeLimit = 120000,					--最低游戏时长（单位毫秒）
		timeLimit = 0,					--最低游戏时长（单位毫秒）
	},
}


-----------------------------------------------------------【仙之侠道】--------------------------------------------------------
--仙之侠道
_tab_room[14] = 
{
	mapkey = "world/td_swjg2",
	--mapkey = "world/td_swjg2_s", --虎年版
	
	groupMapFlag = 0, --是否为军团地图
	fps = 30, --指定帧数fps
	
	confgInfo = 
	{
		--势力1
		[1] = 
		{
			maxNum = 2,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_SHU"],		--势力描述
			defaultType = hVar.POS_TYPE.BLANK,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = false,				--该势力允许玩家进入
			
		},
		--势力2
		[2] = 
		{
			--默认
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_WEI"],		--势力描述
			defaultType = hVar.POS_TYPE.AI_EASY,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = true,				--该势力不允许玩家进入
			
		},
	},
	
	kickoutCD = 300, --玩家超时踢出的最大等待时间(秒)
	
	--挑战次数
	challengeMaxCount = 99999,
	
	--显示奖励
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{1,1000},
		},
	},
	
	--双人守卫剑阁结束奖励
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"Boss_004_swjg2",1,1},			--{奖池,最小个数,最大个数)} --献祭之石
			{"Boss_003",1,2},			--{奖池,最小个数,最大个数)} --神器晶石
			{"treasure_shouweijiange2",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（双人守卫剑阁掉落）
			{"treasure_shouweijiange2",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（双人守卫剑阁掉落）
			{"treasure_shouweijiange2",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（双人守卫剑阁掉落）
		},
	},
	
	--[[
	--双人守卫剑阁结束奖励 虎年版
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"Boss_004_swjg2",1,1},			--{奖池,最小个数,最大个数)} --献祭之石
			{"Boss_laohu",1,1},			--{奖池,最小个数,最大个数)} --龙须虎
			{"treasure_shouweijiange2",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（双人守卫剑阁掉落）
			{"treasure_shouweijiange2",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（双人守卫剑阁掉落）
			{"treasure_shouweijiange2",1,1},	--{奖池,最小个数,最大个数)} --藏宝图（双人守卫剑阁掉落）
		},
	},
	]]
	
	--[[
	--双人守卫剑结束宝物碎片奖励
	rewardTreasure = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 1,				--抽的数量
			{"treasure_shouweijiange2", 1, 1,},			--{奖池,最小个数,最大个数)}
		},
	},
	]]
	
	--地图全局战术技能(双人守卫剑)
	tacticPool = 
	{
		--第一类
		[1] = {
			totalValue = 100,
			{value = 100, reward = {1246,1},},			--战术技能卡id，战术技能卡等级
		},
	},
	
	--开放时间段(每日可配置多个时间段)
	openTime = 
	{
		normal = {
			{beginTime = "05:00:00", endTime = "23:59:59",},
		},
	},
	
	--有效局条件(人族无敌)
	validCondition = 
	{
		--2分钟
		--timeLimit = 120000,					--最低游戏时长（单位毫秒）
		timeLimit = 0,					--最低游戏时长（单位毫秒）
	},
}

-----------------------------------------------------------【决战虚鲲】--------------------------------------------------------
--决战虚鲲
_tab_room[15] = 
{
	mapkey = "world/td_wj_008",
	
	groupMapFlag = 0, --是否为军团地图
	
	confgInfo = 
	{
		--势力1
		[1] = 
		{
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_SHU"],		--势力描述
			defaultType = hVar.POS_TYPE.BLANK,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = false,				--是否只允许电脑
			
		},
		--势力2
		[2] = 
		{
			--默认
			maxNum = 1,					--势力最大玩家数
			des = hVar.tab_string["__TEXT_WEI"],		--势力描述
			defaultType = hVar.POS_TYPE.AI_EASY,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
			computerOnly = true,				--是否只允许电脑
			
		},
	},
	
	kickoutCD = 86400, --玩家超时踢出的最大等待时间(秒)
	
	--挑战次数
	challengeMaxCount = 99999,
	
	--显示奖励
	rewardShow = 
	{
		[hVar.POS_TYPE.AI_EASY] = {
			{1,1000},
			--{5,10232},	--黄忠
			{11,100},
			{23,1},
			{24,1},
		},
	},
	
	--决战虚鲲结束奖励
	reward = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 3,				--抽的数量
			{"Boss_002",1,2},			--{奖池,最小个数,最大个数)} --积分
			{"Boss_003",1,2},			--{奖池,最小个数,最大个数)} --神器晶石
			{"treasure_motashazhen",1,1},		--{奖池,最小个数,最大个数)} --藏宝图（魔塔杀阵掉落）
			{"treasure_motashazhen",1,1},		--{奖池,最小个数,最大个数)} --藏宝图（魔塔杀阵掉落）
			{"treasure_motashazhen",1,1},		--{奖池,最小个数,最大个数)} --藏宝图（魔塔杀阵掉落）
		},
	},
	
	--[[
	--决战虚鲲结束宝物碎片奖励
	rewardTreasure = {
		[hVar.POS_TYPE.AI_EASY] = {
			--有几个奖池出几个，rewardNum标示从中抽几个
			rewardNum = 1,				--抽的数量
			{"treasure_motashazhen", 1, 1,},			--{奖池,最小个数,最大个数)}
		},
	},
	]]
	
	--[[
	--决战虚鲲结束奖励,每周必掉1个
	rewardPerWeek = {
		--简单难度
		[hVar.POS_TYPE.AI_EASY] = {
			min = 3,
			max = 5,
			{5,10232},	--黄忠
		},
	},
	]]
	
	--地图全局战术技能(决战虚鲲)
	tacticPool = 
	{
		--第一类
		[1] = {
			totalValue = 100,
			{value = 100, reward = {3041,49},},			--战术技能卡id，战术技能卡等级
		},
		
		--第二类
		[2] = {
			totalValue = 100,
			{value = 100, reward = {3043,96},},			--战术技能卡id，战术技能卡等级
		},
		
		--第三类
		[3] = {
			totalValue = 30,
			{value = 10, reward = {3140,5},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3171,3},},			--战术技能卡id，战术技能卡等级
			{value = 10, reward = {3172,9},},			--战术技能卡id，战术技能卡等级
		},
	},
	
	--开放时间段(每日可配置多个时间段)
	openTime = 
	{
		normal = {
			{beginTime = "00:00:00", endTime = "23:59:59",},
		},
	},
	
	--有效局条件(决战虚鲲)
	validCondition = 
	{
		--2分钟
		--timeLimit = 120000,					--最低游戏时长（单位毫秒）
		timeLimit = 0,					--最低游戏时长（单位毫秒）
	},
}