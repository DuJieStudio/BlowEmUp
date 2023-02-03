hVar.tab_quest = {}
local _tab_quest = hVar.tab_quest
--_tab_quest[0] = {
--	conditions = {
--		--地图通关信息
--		[hVar.MEDAL_TYPE.map] = "world/td_001_yxcs",						--过第N关

--		--满足特定条件通过某关
--		--字符串规则："mapName:mapDiff:clearNum|condition1|condition2|condition3|(...)"			--任务填写格式(分隔符(|)分开的第一个是地图信息（地图名:地图难度（-1标示对所有模式生效,普通模式为0或者不填,1以上为挑战难度）:满足条件情况下的通关次数默认为1）,后续为各种限制条件)
--		--条件说明：condition = "conditionType:argument1:argument2(...)"			--条件格式(冒号(:)分开的第一个为条件类型,后续为参数。不同条件的参数不同,没有参数默认填0,不要乱搞)
--		--条件类型：		"useS:tacticId1:tacticId2(...)"					--只使用某类型的战术技能卡(条件类型:技能Id...)
--					"unuseS:tacticId1:tacticId2(...)"				--不使用某类型的战术技能卡(条件类型:技能Id...(条件填all标示全部))
--					"useT:tacticId1:tacticId2(...)"					--只使用某种类型的塔(条件类型:塔战术技能卡id...)
--					"unuseT:tacticId1:tacticId2(...)"				--不使用某种类型的塔(条件类型:塔战术技能卡id...(条件填all标示全部))
--					"deadH:deadNum"							--英雄死亡次数小于n(条件类型:死亡次数)
--					"useH:unitId1:unitId2(...)"					--只使用某英雄(条件类型:英雄Id...)
--					"unuseH:unitId1:unitId2(...)"					--不使用某英雄(条件类型:英雄Id...(条件填all标示全部))
--					"star:starnum:num"						--要求星数(0表示只需要通关，1以上表示星数)

--		--范例
--		[hVar.MEDAL_TYPE.mapCondition] = "world/td_001_yxcs:0:2|useS:1037:1039|unuseS:1037:1039|useT:1012:1013|unuseT:1012:1013|deadH:6|useH:18001|unuseH:18001|",

--		满足特定条件通过章节
--		--字符串规则："chapterId:mapDiff:clearNum|condition1|condition2|condition3|(...)"	--任务填写格式(分隔符(|)分开的第一个是章节信息（章节Id:地图难度（-1标示对所有模式生效,普通模式为0或者不填,1以上为挑战难度）:满足条件情况下的通关次数默认为1）,后续为各种限制条件)
--		--条件说明：condition = "conditionType:argument1:argument2(...)"			--条件格式(冒号(:)分开的第一个为条件类型,后续为参数。不同条件的参数不同,没有参数默认填0,不要乱搞)
--		--条件类型：		"useS:tacticId1:tacticId2(...)"					--只使用某类型的战术技能卡(条件类型:技能Id...)
--					"unuseS:tacticId1:tacticId2(...)"				--不使用某类型的战术技能卡(条件类型:技能Id...(条件填all标示全部))
--					"useT:tacticId1:tacticId2(...)"					--只使用某种类型的塔(条件类型:塔战术技能卡id...)
--					"unuseT:tacticId1:tacticId2(...)"				--不使用某种类型的塔(条件类型:塔战术技能卡id...(条件填all标示全部))
--					"deadH:deadNum"							--英雄死亡次数小于n(条件类型:死亡次数)
--					"useH:unitId1:unitId2(...)"					--只使用某英雄(条件类型:英雄Id...)
--					"unuseH:unitId1:unitId2(...)"					--不使用某英雄(条件类型:英雄Id...(条件填all标示全部))
--					"star:starnum"						--要求星数(0表示只需要通关，1以上表示星数)
--		--范例
--		[hVar.MEDAL_TYPE.chapterCondition] = "1:0:2|useS:1037:1039|unuseS:1037:1039|useT:1012:1013|unuseT:1012:1013|deadH:6|useH:18001|unuseH:18001|",
--
--		[hVar.MEDAL_TYPE.gameTimesNormal] = 2,							--累计完成N个普通游戏局*
--		[hVar.MEDAL_TYPE.gameTimesDiff1] = 2,							--累计完成N个挑战1游戏局*
--		[hVar.MEDAL_TYPE.gameTimesDiff2] = 2,							--累计完成N个挑战2游戏局*
--		[hVar.MEDAL_TYPE.gameTimesDiff3] = 2,							--累计完成N个挑战3游戏局*
--		[hVar.MEDAL_TYPE.gameTimesDiff] = 2,							--累计完成N个挑战游戏局*
--		[hVar.MEDAL_TYPE.gameTimes] = 2,							--累计完成N个游戏局
--		[hVar.MEDAL_TYPE.starCount] = 2,							--累计获得N个星
--		[hVar.MEDAL_TYPE.allStarNormal] = 2,							--满星通关N次普通*
--		[hVar.MEDAL_TYPE.allStarDiff1] = 2,							--满星通关N次挑战1*
--		[hVar.MEDAL_TYPE.allStarDiff2] = 2,							--满星通关N次挑战2*
--		[hVar.MEDAL_TYPE.allStarDiff3] = 2,							--满星通关N次挑战3*
--		[hVar.MEDAL_TYPE.allStarDiff] = 2,							--满星通关N次挑战*
--		[hVar.MEDAL_TYPE.allStar] = 2,								--满星通关N次关卡*
--		[hVar.MEDAL_TYPE.gameFailed] = 2,							--游戏失败次数*
--		[hVar.MEDAL_TYPE.td_wj_001] = 1000,							--无尽关卡1战绩*
--		[hVar.MEDAL_TYPE.td_wj_002] = 3000,							--无尽关卡2战绩*

--
--		--击杀信息
--		[hVar.MEDAL_TYPE.killU] = 2,								--累计击杀N个敌人
--		[hVar.MEDAL_TYPE.killUB] = 7,								--累计击杀N个BOSS
--		[hVar.MEDAL_TYPE.killUT] = {14001, 7},							--累计击杀N个指定敌人
--		[hVar.MEDAL_TYPE.killUS] = {1105, 7},							--使用战术技能技能累计击杀N个敌人(tab_tacticId, num)
--
--		--升级信息
--		[hVar.MEDAL_TYPE.sLvUp] = 7,								--累计升级英雄技能N次
--		[hVar.MEDAL_TYPE.heroN] = 12,								--累计收集N个英雄
--		[hVar.MEDAL_TYPE.mergeN] = 13,								--累计合成N次
--		[hVar.MEDAL_TYPE.xilianN] = 14,								--累计洗练N次
--		[hVar.MEDAL_TYPE.rebuidlN] = 3,								--累计重铸N次
--		[hVar.MEDAL_TYPE.tLvUp] = 14,								--累计升级卡牌N次
--		[hVar.MEDAL_TYPE.tacticNum] = 15,							--累计收集N张战术卡
--
--		--消费信息
--		{hVar.MEDAL_TYPE.deposit] = 3000,							--累计充值XXX
--		--[hVar.MEDAL_TYPE.scoreCost] = 3000,							--累计花费积分XXX(暂无)
--		--{hVar.MEDAL_TYPE.rmbCost] = 300,							--累计花费金币XXX(暂无)
--		[hVar.MEDAL_TYPE.openChest] = 29,							--累计开N个宝箱
--		[hVar.MEDAL_TYPE.rollTactic] = 30,							--累计抽N张卡
--		[hVar.MEDAL_TYPE.costScore] = 30,							--累计消耗N积分
--
--		--局内建造信息
--		[hVar.MEDAL_TYPE.buildT] = 30,								--累计建造N个塔
--		[hVar.MEDAL_TYPE.buildTT] = {hVar.UNIT_TAG_TYPE.TOWER.TAG_JIANTA, 30},			--累计建造N个塔(箭塔,炮塔,法术塔,毒塔,连弩塔,狙击塔,巨炮塔,地震塔,滚石塔,火塔,电塔,冰塔)
--		[hVar.MEDAL_TYPE.buildS] = 30,								--累计升级科技N次
--
--		--任务相关
--		[hVar.MEDAL_TYPE.apNum] = 30,								--累计获得N个成就点(achievement point)
--		[hVar.MEDAL_TYPE.missionN] = 30,							--累计完成N个任务
--
--		--购买信息
--		[hVar.MEDAL_TYPE.buyItem] = {shopitemId, 30},						--累计购买n个商品(345红装锦囊,290解锁,291升星1到2,340红装合成,339红装洗练,349商店刷新)
--
--	},
--	reward = {											--星级奖励:1积分,2战术技能卡,3道具,4英雄,5将魂,6战术技能卡碎片,7游戏币,8网络宝箱,9抽卡
--		{1,1000,},										--
--		{2,1000,1,2,},										--类型,ID,数量,等级
--		{3,8996,4},										--类型,ID,道具,属性价值倍率
--		{4,5000,1,1},										--类型,ID(道具id),星级（默认为1）,等级（默认为1,慎用）
--		{5,10200,1},										--类型,ID(道具id),数量
--		{6,10300,1},										--类型,ID(道具id),数量
--		{7,10,},										--类型,金额(最大20)
--		{8,9004,1},										--类型,ID(道具id,9004,9005,9006),数量
--		{9,9101,1,0,},										--类型,ID(道具id,9101,9102)
--	},
--}


--洗炼道具5次
_tab_quest[1] = {
	type = hVar.QUEST_TYPE.DAILY,
	conditions = {
		[hVar.MEDAL_TYPE.xilianN] = 5, --累计洗练N次
	},
	reward = { --星级奖励:(1:积分 / 2:战术卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术卡碎片 / 7:游戏币最多20 / 8:网络宝箱(9004) / 9:卡包(9101))/ 11:神器晶石
		{1,500,},
		{8,9004,2,},
	},
}