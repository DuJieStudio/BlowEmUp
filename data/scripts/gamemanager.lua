--游戏类型
hVar.GameType = {
	MAINBASS = 0,		--主基地
	FOURSR = 1,		--4小关
	SIXBR = 2,		--6大关随机 
	RANDBATTLE = 4,		--随机战役
	ENDLESS = 10,		--无尽地图
	TEST = 97,		--测试地图
	CHECKCONTINUE = 98,	--中续
	BEGINNER = 99,		--新手流程
}

--游戏临时数据存档说明
--以本地文件形式存储  存储个事如下
--player.game_info = {
--	curInfo = {},		--存储关卡临时数据   比如当前战场血量 武器  战术卡  宠物
--	typeinfo = {},		--存储不同类型游戏临时数据  比如关卡1的各项数据 关卡2的各项数据
--}
--存储游戏当前临时数据
--LuaGetPlayerTempGameInfo
--LuaSetPlayerTempGameInfo
--根据游戏类型存储游戏临时数据
--LuaGetPlayerTempGameInfoByType
--LuaSetPlayerTempGameInfoByType
--情况所有临时数据
--LuaClearPlayerTempGameInfo

--1.重新开始
--2.中断开始
--3.继续下一关

--本地游戏管理
GameManager = {}
GameManager.ClearData = function()
	--清理
	LuaClearPlayerRandMapInfo(g_curPlayerName)--准备废弃
	LuaClearPlayerTempGameInfo(g_curPlayerName)
end

GameManager.GameClear = function()
	GameManager.ClearData()
	GameManager.Data = {}
end

GameManager.InitDiabloData = function()
	--大菠萝数据初始化
	hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()

	if GameManager and GameManager.Data.gametype ~= hVar.GameType.BEGINNER and GameManager.Data.gametype ~= hVar.GameType.MAINBASS then
		local curScore = LuaGetPlayerScore()
		local costScore = hApi.NumBetween(0,200,curScore)
		if costScore > 0 then 
			LuaAddPlayerScore(- costScore)
			local keyList = {"material"}
			LuaSavePlayerData_Android_Upload(keyList, "进随机地图")
		end
		GameManager.AddGameInfo("scoreingame",200)
	end
end

--检查新人玩家
GameManager.CheckIsBeginner = function()
	local isBeginer = 1
	local firstmap = hVar.GuideMap --第0关
	local isFinishFirstMap = LuaGetPlayerMapAchi(firstmap, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --是否通关第0关
	if (isFinishFirstMap == 1) then --已通关第一关
		isBeginer = 0
	end
	return isBeginer
end

GameManager.CheckIsGameType = function(ntype)
	local nResult = 0
	if GameManager and GameManager.Data and GameManager.Data.gametype == ntype then
		nResult = 1
	end
	return nResult
end

--检查游戏是否中续（中断后继续）
GameManager.CheckGameContinuation = function()
	local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
	--异常退出
	--table_print(tInfo)
	if tInfo.id and (tInfo.stage ~= 1 or tInfo.isguide == 1) and type(tInfo.lifecount) == "number" and tInfo.lifecount > 0 and tInfo.isclear ~= 1 and tInfo.istest ~= 1 then
		local nRandId = tInfo.id or 1
		hGlobal.event:event("LocalEvent_EnterRandMap",nRandId)
	else
		GameManager.GameStart(hVar.GameType.MAINBASS)
	end
end

GameManager.AddGameInfo = function(nType,data)
	local diablodata = hGlobal.LocalPlayer.data.diablodata
	if diablodata then
		if diablodata.game_info == nil then
			diablodata.game_info = {}
		end
		
		if type(data) == "number" then
			if diablodata.game_info[nType] == nil then
				diablodata.game_info[nType] = 0
			end
			
			if (type(diablodata.game_info[nType]) == "number") then
				diablodata.game_info[nType] = diablodata.game_info[nType] + data
			end
		elseif type(data) == "table" then
			if diablodata.game_info[nType] == nil then
				diablodata.game_info[nType] = {}
			end
			local num = #diablodata.game_info[nType]
			diablodata.game_info[nType][num+1] = data
		end
	end
end

GameManager.AddGameInfoGroup = function(nType,tGroup)
	local diablodata = hGlobal.LocalPlayer.data.diablodata
	if diablodata and type(tGroup) == "table" then
		if diablodata.game_info == nil then
			diablodata.game_info = {}
		end

		if diablodata.game_info[nType] == nil then
			diablodata.game_info[nType] = {}
		end

		for i = 1,#tGroup do
			local key,data = unpack(tGroup[i])
			if type(data) == "number" then
				if diablodata.game_info[nType][key] == nil then
					diablodata.game_info[nType][key] = 0
				end
				if (type(diablodata.game_info[nType][key]) == "number") then
					diablodata.game_info[nType][key] = diablodata.game_info[nType][key] + data
				end
			elseif type(data) == "table" then
				if diablodata.game_info[nType][key] == nil then
					diablodata.game_info[nType][key] = {}
				end
				local num = #diablodata.game_info[nType][key]
				diablodata.game_info[nType][key][num+1] = data
			end
		end
	end
end

GameManager.SetGameInfo = function(nType,tData)
	local diablodata = hGlobal.LocalPlayer.data.diablodata
	if diablodata then
		if diablodata.game_info == nil then
			diablodata.game_info = {}
		end
		if diablodata.game_info[nType] == nil then
			diablodata.game_info[nType] = {}
		end
		if type(tData) == "table" then
			for i = 1,#tData do
				local sKey = tData[i][1]
				local data = tData[i][2]
				diablodata.game_info[nType][sKey] = data
			end
		elseif type(tData) == "string" then
			if tData == "clear" then
				diablodata.game_info[nType] = {}
			else
				diablodata.game_info[nType] = tData
			end
		end
	end
end

GameManager.GetGameInfo = function(nType)
	local info = {}
	local diablodata = hGlobal.LocalPlayer.data.diablodata
	if diablodata and diablodata.game_info then
		if diablodata.game_info and diablodata.game_info[nType] then
			info = diablodata.game_info[nType]
		end
	end
	return info
end

GameManager.ClearGameInfo = function()
	local diablodata = hGlobal.LocalPlayer.data.diablodata
	if diablodata then
		diablodata.game_info = {}
	end
end

--进游戏管理 
GameManager.GameStart = function(ntype,data,param1,param2)
	GameManager.Data = {}

	--无指定的检测中续
	if ntype == hVar.GameType.CHECKCONTINUE then
		local gameContinuation,ntype,tData = GameManager.CheckGameContinuation(ntype)
		--需要中续 根据类型调用下一关接口
		if gameContinuation then
			
			return
		--无需中续  直接进主基地
		else
			GameManager.ClearData()
			GameManager.Data.gametype =  hVar.GameType.MAINBASS
			GameManager.InitDiabloData()
		end
	--有指定的直接赋值走初始流程
	else
		GameManager.ClearData()
		GameManager.Data.gametype = ntype
		GameManager.InitDiabloData()
	end

	if GameManager.Data.gametype == hVar.GameType.FOURSR then --随机迷宫地图
		GameManager.StartFOURSR(data,param1)
	elseif GameManager.Data.gametype == hVar.GameType.MAINBASS then
		GameManager.StartMainBase()
	elseif GameManager.Data.gametype == hVar.GameType.SIXBR then
		GameManager.StartSIXBR()
	elseif GameManager.Data.gametype == hVar.GameType.RANDBATTLE then
		GameManager.StartRANDBATTLE(data,param1,param2)
	elseif GameManager.Data.gametype == hVar.GameType.ENDLESS then
		GameManager.StartENDLESS()
	elseif GameManager.Data.gametype == hVar.GameType.TEST then
		GameManager.StartTest(data,param1,nil,param2)
	elseif GameManager.Data.gametype == hVar.GameType.BEGINNER then
		GameManager.StartBeginnerGame()
	end
end

GameManager.StartMainBase = function()
	--进入坦克配置界面
	local mapname = hVar.MainBase
	local MapDifficulty = 0
	local MapMode = hVar.MAP_TD_TYPE.TANKCONFIG --配置坦克模式
	xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
end

GameManager.StartBeginnerGame = function()
	local haveBeginnerAward = LuaGetHaveBeginnerAward()
	if haveBeginnerAward == 0 then
		local SelectParam_heroList =
		{
			{id = hVar.MY_TANK_ID,},
		}
		
		--检测存档中是否有英雄
		for i = 1, #SelectParam_heroList, 1 do
			local typeId = SelectParam_heroList[i].id
			local HeroCard = hApi.GetHeroCardById(typeId)
			--print("HeroCard", HeroCard)
			if (HeroCard == nil) then
				hGlobal.event:event("LocalEvent_BuyHeroCardSucceed",typeId, 1, 1)
				LuaSaveHeroCard()
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
				--print("添加存档", typeId)
			end
		end

		LuaSetHaveBeginnerAward(1)

		local keyList = {"skill", "card", "map", "bag", "material", "log",}
		LuaSavePlayerData_Android_Upload(keyList, "新手奖励")
	end
	--引导关
	local __MAPDIFF = 0
	local __MAPMODE = hVar.MAP_TD_TYPE.NORMAL
	local mapName = hVar.GuideMap
	
	xlScene_LoadMap(g_world, mapName,__MAPDIFF,__MAPMODE)
end

--随机迷宫地图
GameManager.StartFOURSR = function(data2, banLimitTable)
	if (type(data2) == "table") then
		--geyachao: 对话2选1，复用本局的大菠萝数据
		--hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
		hGlobal.LocalPlayer.data.diablodata.activeskill = data2.activeskill --坦克的上一局主动技能
		hGlobal.LocalPlayer.data.diablodata.basic_weapon_level = data2.basic_weapon_level --坦克的上一局武器等级
		hGlobal.LocalPlayer.data.diablodata.follow_pet_units = data2.follow_pet_units --坦克的上一局的宠物
		hGlobal.LocalPlayer.data.diablodata.statistics_rescue_count = data2.statistics_rescue_count --营救的科学家数量(随机关单局数据)
		hGlobal.LocalPlayer.data.diablodata.statistics_rescue_num = data2.statistics_rescue_num --营救的科学家数量(随机关累加数据)
		hGlobal.LocalPlayer.data.diablodata.statistics_rescue_costnum = data2.statistics_rescue_costnum --营救的科学家消耗数量
		hGlobal.LocalPlayer.data.diablodata.statistics_crystal_num = data2.statistics_crystal_num --水晶数量
		--命
		hGlobal.LocalPlayer.data.diablodata.lifecount = data2.lifecount
		hGlobal.LocalPlayer.data.diablodata.deathcount = data2.deathcount
		hGlobal.LocalPlayer.data.diablodata.canbuylife = data2.canbuylife
		--自动开枪标记
		hGlobal.LocalPlayer.data.diablodata.weapon_attack_state = data2.weapon_attack_state
		--战术卡信息
		hGlobal.LocalPlayer.data.diablodata.tTacticInfo = data2.tTacticInfo
		--宝箱信息
		hGlobal.LocalPlayer.data.diablodata.tChestInfo = data2.tChestInfo
		--战车生命百分比
		hGlobal.LocalPlayer.data.diablodata.hpRate = data2.hpRate
		--随机迷宫层数和小关数
		hGlobal.LocalPlayer.data.diablodata.randommapStage = data2.randommapStage
		hGlobal.LocalPlayer.data.diablodata.randommapIdx = data2.randommapIdx
		--print("随机迷宫地图", hGlobal.LocalPlayer.data.diablodata.randommapStage)
		--print("随机迷宫地图", hGlobal.LocalPlayer.data.diablodata.randommapIdx)
	end
	
	--local banLimitTable = {battlecfg_id = battlecfg_id or 0,}
	xlScene_LoadMap(g_world, hVar.RandomMap, 0, hVar.MAP_TD_TYPE.ENDLESS, nil, banLimitTable)
end

GameManager.StartSIXBR = function()
	
end

GameManager.StartRANDBATTLE = function(data,mapname,diff)
	local __MAPDIFF = diff or 0
	local __MAPMODE = hVar.MAP_TD_TYPE.NORMAL
	local mapName = mapname

	for i = 1,#hVar.tab_randmap do
		if type(hVar.tab_randmap[i]) == "table" then
			for j = 1,#hVar.tab_randmap[i] do
				if type(hVar.tab_randmap[i][j]) == "table" and type(hVar.tab_randmap[i][j].randmap) == "table" then
					for z = 1,#hVar.tab_randmap[i][j].randmap do
						if mapname == hVar.tab_randmap[i][j].randmap[z] then
							local index = math.random(1,#hVar.tab_randmap[i][j].randmap)
							mapName = hVar.tab_randmap[i][j].randmap[index]
							GameManager.Data.savemapname = mapname
							break
						end
					end
				end
			end
		end
	end
	
	xlScene_LoadMap(g_world, mapName,__MAPDIFF,__MAPMODE)
end

GameManager.StartENDLESS = function()
	local mapname = "world/endless_001"
	local MapDifficulty = 0
	local MapMode = hVar.MAP_TD_TYPE.ENDLESS --无尽模式
	
	xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
end

GameManager.StartTest = function(data,mapname, difficulty, banLimitTable)
	local MapDifficulty = difficulty or 0
	local MapMode = hVar.MAP_TD_TYPE.ENDLESS --无尽模式
	
	xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode,nil,banLimitTable)
end

--
GameManager.GameEnd = function(bResult,nResult,strResult)
	if GameManager.Data then
		if GameManager.Data.gametype == hVar.GameType.RANDBATTLE then
			local savemapname = GameManager.Data.savemapname
			if nResult == 1 then
				LuaSetPlayerMapAchi(savemapname,hVar.ACHIEVEMENT_TYPE.LEVEL,1)
			end
		else
		end
	end
	TD_OnGameOver_Diablo(bResult)
	hGlobal.event:event("LocalEvent_GameOver_Diablo", nResult)
end

GameManager.GameNext = function()
	if type(GameManager.Data) == "table" and GameManager.Data.gametype then
		
	end
end

--随机迷宫
--结算临时背包奖励
GameManager.SettlementTempBagAward = function()
	print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
	local oWorld = hGlobal.WORLD.LastWorldMap
	if oWorld then
		print("存宝箱")
		local weapongunChestNum = 0 --武器枪宝箱
		local tacticChestNum = 0 --战术卡宝箱
		local petChestNum = 0 --宠物宝箱
		local equipChestNum = 0 --装备宝箱
		local tInfo = GameManager.GetGameInfo("chestInfo")
		for itemId, itemNum in pairs(tInfo) do
			--print(itemId, itemNum)
			local tabI = hVar.tab_item[itemId] or {}
			local itemType = tabI.type
			
			--统计武器枪宝箱
			if (itemType == hVar.ITEM_TYPE.CHEST_WEAPON_GUN) then
				 weapongunChestNum = weapongunChestNum + itemNum
				
			end
			
			--统计战术卡宝箱
			if (itemType == hVar.ITEM_TYPE.CHEST_TACTIC) then
				 tacticChestNum = tacticChestNum + itemNum
			end
			
			--统计宠物宝箱
			if (itemType == hVar.ITEM_TYPE.CHEST_PET) then
				petChestNum = petChestNum + itemNum
			end
			
			--统计装备宝箱
			if (itemType == hVar.ITEM_TYPE.CHEST_EQUIP) then
				equipChestNum = equipChestNum + itemNum
			end
		end
		
		
		--存科学家
		print("存科学家")
		local scientistNum = oWorld.data.statistics_rescue_num --武器枪宝箱
		
		print("weapongunChestNum=", weapongunChestNum)
		print("tacticChestNum=", tacticChestNum)
		print("petChestNum=", petChestNum)
		print("equipChestNum=", equipChestNum)
		print("scientistNum=", scientistNum)
		
		--[[
		--geyachao: 加战术卡已改为服务器发奖了，会下发客户端增加奖励
		--存战术卡碎片
		local tInfo = GameManager.GetGameInfo("tacticInfo")
		for itemId, itemNum in pairs(tInfo) do
			local tabI = hVar.tab_item[itemId] or {}
			local itemType = tabI.type
			
			--统计使用的战术卡
			if (itemType == hVar.ITEM_TYPE.TACTIC_USE) then
				 local tacticId = tabI.tacticId or 0
				if (tacticId > 0) then
					local notSaveFlag = true --不存档，最后统一存档
					LuaAddPlayerTacticDebris(tacticId, itemNum, notSaveFlag) --加战术卡碎片
				end
			end
		end
		]]

		--存水晶
		local scoreNum = GameManager.GetGameInfo("ckscore")
		LuaAddPlayerScoreByWay(scoreNum,hVar.GET_SCORE_WAY.CK)
		hGlobal.event:event("LocalEvent_RefreshCurGameScore")
		
		--存档
		local notSaveFlag = true --不存档，最后统一存档
		LuaAddTankWeaponGunChestNum(weapongunChestNum, notSaveFlag)
		LuaAddTankTacticChestNum(tacticChestNum, notSaveFlag)
		LuaAddTankPetChestNum(petChestNum, notSaveFlag)
		LuaAddTankEquipChestNum(equipChestNum, notSaveFlag)
		--LuaAddTankScientistNum(scientistNum, notSaveFlag) --geyachao: 改为服务器下发奖励时再增加数量
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		--清空
		GameManager.SetGameInfo("tacticInfo","clear")
		GameManager.SetGameInfo("chestInfo","clear")
		GameManager.SetGameInfo("ckscore","clear")
		oWorld.data.statistics_rescue_count = 0
		oWorld.data.statistics_rescue_num = 0
		oWorld.data.statistics_rescue_costnum = 0
		hGlobal.event:event("Event_ResetRescuedPerson",oWorld)
		hGlobal.event:event("LocalEvent_ShowTempBagBtn",-1)
		
		--设置随机迷宫缓存信息（防止闪退记录的第n-1小关的进度信息）
		hApi.RandomMapToSaveData()
	end
end