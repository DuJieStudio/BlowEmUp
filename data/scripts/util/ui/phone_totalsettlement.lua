--总结算界面
hGlobal.UI.InitTotalSettlementFrm = function()
	--参数定义
	local _nTotalStageCount = 0				--总关卡个数
	local _nLineW = 1004					--总长度
	local _tUIRemoveList = {}				--UI清理列表
	local _nCurrentTankID = 0				--当前战车ID
	local _nRescueNum = 0					--营救个数
	local _nCupScore = 0					--排行积分
	local _nScore = 0					--积分
	local _nTotalTime = 0					--总耗时
	local _tClearanceInformation = {}			--清关信息
	local _nIsLeave = 0					--主动离开
	local _shouldShowSetName = 0				--需要弹设置名字界面
	local _tTacticsList = {}				--战术卡列表
	local _tSettlementGameIndex = {}			--游戏局结算标记
	--函数定义
	local CloseFunc = hApi.DoNothing			--关闭函数
	local EnterStartMap = hApi.DoNothing			--进入初始地图
	local RestartGuideMap = hApi.DoNothing			--重试新手地图
	local OnCreateTotalSettlementFrm = hApi.DoNothing	--创建总结算界面
	local CreateScoreInfo = hApi.DoNothing			--创建积分信息
	local CreatePlayerTank = hApi.DoNothing			--创建玩家战车
	local CreateTacticsInfo = hApi.DoNothing		--创建战术卡信息
	local PlayTotalSettlementAction = hApi.DoNothing	--播放总结算动画
	local PlayTankMoveAction = hApi.DoNothing		--播放坦克移动动画
	local PlayScoreAction = hApi.DoNothing			--播放积分动画
	local TotalSettlement = hApi.DoNothing			--总结算
	
	local modelParam = {
		[11246] = {
			w = 160,
			h = 160,
		},
		[13025] = {
			x = 15,
			y = - 15,
			w = 100,
			h = 100,
		},
		[11217] = {
			w = 160,
			h = 160,
		},
		[11247] = {
			w = 200,
			h = 200,
		},
	}

	local _frm
	local _parent
	local _childUI

	local _offx = hVar.SCREEN.w/2
	local _offy = hVar.SCREEN.h/2

	--local _scoreStartY = 50
	--local _scoredelayh = -80
	--local _tankStarty = 130
	local _scoreStartY = 10
	local _scoredelayh = -90
	local _scoredelayW = 240
	local _tankStarty = 110

	OnCreateTotalSettlementFrm = function()
		if hGlobal.UI.TotalSettlementFrm then
			hGlobal.UI.TotalSettlementFrm:del()
			hGlobal.UI.TotalSettlementFrm = nil
		end
		--界面
		hGlobal.UI.TotalSettlementFrm = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			show = 0,
			dragable = 2,
			autoactive = 0,
			border = 0,
		})
		_frm = hGlobal.UI.TotalSettlementFrm
			_parent = _frm.handle._n
			_childUI = _frm.childUI
			
			_childUI["closebtn"] = hUI.image:new({
			parent = _parent,
			model = "misc/bar_remould_bg.png", --"UI:playerBagD"
			x = _offx,
			y = _offy,
			z = -1,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
		})
		_childUI["closebtn"].handle.s:setOpacity(200)
		_childUI["closebtn"].handle.s:setColor(ccc3(0, 0, 0))

		local isGuide = 0
		local text = hVar.tab_string["leave"]
		local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
		if tInfo and tInfo.isguide == 1 and tInfo.stage < 1 and hApi.IsReviewMode() == false then
			text = hVar.tab_string["restart"]
			isGuide = 1
		end
		_childUI["btnOk"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/addition/cg.png",
			label = {text = text,size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
			scaleT = 0.95,
			x = _offx,
			y = 75,
			scale = 0.74,
			code = function(self)
				CloseFunc()
				if isGuide == 1 then
					RestartGuideMap()
				else
					EnterStartMap()
				end
			end,
		})
		if _shouldShowSetName == 1 then
			_childUI["btnOk"]:setstate(-1)
		end
		
		CreateScoreInfo()
		CreatePlayerTank()
		CreateTacticsInfo()
		_frm:show(1)
		_frm:active()
	end
	
	EnterStartMap = function()
		--删除pvp资源
		xlReleaseResourceFromPList("data/image/misc/pvp.plist")
		
		hUI.Disable(0, "离开游戏")
		
		if hGlobal.WORLD.LastWorldMap then
			local w = hGlobal.WORLD.LastWorldMap
			local currentMapMode = w.data.tdMapInfo and (w.data.tdMapInfo.mapMode)
			local map = w.data.map
			local tabM = hVar.MAP_INFO[map]
			local chapterId = 1
			if tabM then
				chapterId = tabM.chapter or 1
			end

			--关闭同步日志文件
			hApi.SyncLogClose()
			--关闭非同步日志文件
			hApi.AsyncLogClose()
			
			--隐藏可能的选人界面
			if hGlobal.UI.PhoneSelectedHeroFrm2 then
				hGlobal.UI.PhoneSelectedHeroFrm2:show(0)
				hGlobal.UI.PhoneSelectedHeroFrmBG.handle.s:setVisible(false) --隐藏背景框挡板
				hApi.clearTimer("__SELECT_HERO_UPDATE__")
				hApi.clearTimer("__SELECT_TOWER_UPDATE__")
				hApi.clearTimer("__SELECT_TACTIC_UPDATE__")
			end

			if (hGlobal.WORLD.LastWorldMap ~= nil) then
				hGlobal.WORLD.LastWorldMap:del()
				
				hGlobal.LocalPlayer:setfocusworld(nil)
				hApi.clearCurrentWorldScene()
			end
			
			--大菠萝数据初始化
			hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
			
			--切换到配置坦克地图
			local mapname = hVar.MainBase
			local MapDifficulty = 0
			local MapMode = hVar.MAP_TD_TYPE.TANKCONFIG --配置坦克模式
			xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
		end
	end

	RestartGuideMap = function()
		--删除pvp资源
		xlReleaseResourceFromPList("data/image/misc/pvp.plist")
		
		hUI.Disable(0, "离开游戏")
		
		if hGlobal.WORLD.LastWorldMap then
			local w = hGlobal.WORLD.LastWorldMap
			local currentMapMode = w.data.tdMapInfo and (w.data.tdMapInfo.mapMode)
			local map = w.data.map
			local tabM = hVar.MAP_INFO[map]
			local chapterId = 1
			if tabM then
				chapterId = tabM.chapter or 1
			end

			--关闭同步日志文件
			hApi.SyncLogClose()
			--关闭非同步日志文件
			hApi.AsyncLogClose()
			
			--隐藏可能的选人界面
			if hGlobal.UI.PhoneSelectedHeroFrm2 then
				hGlobal.UI.PhoneSelectedHeroFrm2:show(0)
				hGlobal.UI.PhoneSelectedHeroFrmBG.handle.s:setVisible(false) --隐藏背景框挡板
				hApi.clearTimer("__SELECT_HERO_UPDATE__")
				hApi.clearTimer("__SELECT_TOWER_UPDATE__")
				hApi.clearTimer("__SELECT_TACTIC_UPDATE__")
			end

			if (hGlobal.WORLD.LastWorldMap ~= nil) then
				hGlobal.WORLD.LastWorldMap:del()
				
				hGlobal.LocalPlayer:setfocusworld(nil)
				hApi.clearCurrentWorldScene()
			end

			GameManager.GameStart(hVar.GameType.BEGINNER)
		end
	end

	CloseFunc = function()
		hGlobal.event:event("LocalEvent_CloseEndingAction")
		hApi.clearTimer("TotalSettlement")
		for i = 1,#_tUIRemoveList do
			hApi.safeRemoveT(_childUI,_tUIRemoveList[i])
		end
		_tUIRemoveList = {}
		_nTotalStageCount = 0
		_nCurrentTankID = 0
		_nRescueNum = 0
		_nCupScore = 0
		_nScore = 0
		_nTotalTime = 0
		_nIsLeave = 0
		_shouldShowSetName = 0
		_tClearanceInformation = {}
		_tTacticsList = {}
		--虽然此处添加清除清理随机地图数据  但是如果闪退或者强退  不执行到  就会导致2次结算出现 
		--所以再调用总结算的地方需要自行添加结束标记 防止这类情况发生
		LuaClearPlayerRandMapInfo(g_curPlayerName)

		_frm = nil
		_parent = nil
		_childUI = nil

		if hGlobal.UI.TotalSettlementFrm then
			hGlobal.UI.TotalSettlementFrm:del()
			hGlobal.UI.TotalSettlementFrm = nil
		end
	end

	--总结算
	TotalSettlement = function()
		--测试
		--if true then
			--_nRescueNum = 20
			--_nCupScore = 40000
			--_nScore = 1600
			--_nCurrentTankID = 6000
			--_nTotalStageCount = 6
			--_tClearanceInformation = {
				--[1] = {
					--bossid = 12216,
					--gametime = 310,
					--mapname = "world/csys_001",
				--},
				--[2] = {
					--bossid = 12216,
					--gametime = 220,
					--mapname = "world/csys_002",
				--},
				--[3] = {
					--bossid = 12216,
					--gametime = 440,
					--mapname = "world/csys_003",
				--},
				--[4] = {
					--bossid = 12216,
					--gametime = 110,
					--mapname = "world/csys_004",
				--},
			--}
			--return 1
		--end

		local oWorld = hGlobal.WORLD.LastWorldMap
	
		--防止弹框
		if (not oWorld) then
			return 0
		end

		local gamelog = Save_PlayerLog.gamelog

		if (not gamelog) then
			return 0
		end
		local nIndex = gamelog.curIndex or 1
		
		--内存记录计算局 防止当前多次刷结算奖励
		if _tSettlementGameIndex[nIndex] ~= 1 then
			_tSettlementGameIndex[nIndex] = 1
		else
			return 0
		end

		local diablo = hGlobal.LocalPlayer.data.diablodata
		local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
		local oHero = oPlayerMe.heros[1]
		if diablo and type(diablo.randMap) == "table" and oHero then
			--测试防止多次调用结算
			--游戏存档记录结算信息 防止结算完 闪退再次进入游戏获得奖励
			local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
			if tInfo.haveTotalSettlement ~= 1 then
				local tInfos = {
					{"haveTotalSettlement",1},
				}
				_nScore = 0
				LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)
				local nTankID = oHero.data.id
				_nCurrentTankID = nTankID
				local clearStage = (tInfo.stage or 1) - 1
				local randMapId = tInfo.id or 1
				local nBestCK = tInfo.bestCK or 0
				_nRescueNum = tInfo.rescuedcount or 0
				if hVar.tab_randmap[randMapId] then
					_nTotalStageCount = #hVar.tab_randmap[randMapId]
				end
				
				local nTotalScore = 0	--排行总积分（不算入未通关的连斩积分）
				local nTotalTime = 0	--排行总时间（不算入未通关的时间）
				local nTotalRolling = 0	--本局游戏总碾压值（不算入未通关的碾压）
				--获取关卡信息
				if clearStage > 0 then
					for i = 1,clearStage do
						local nBossId = 0
						local nLittleBossId = 0
						local nGameTime = 0
						local sMapName = ""
						if tInfo.stageInfo and type(tInfo.stageInfo[i]) == "table" then
							nBossId = tInfo.stageInfo[i].bossid or nBossId
							nLittleBossId = tInfo.stageInfo[i].littleboss or nLittleBossId
							nGameTime = tInfo.stageInfo[i].gametime or gametime
							sMapName = tInfo.stageInfo[i].mapname
							--累计连斩积分
							nTotalScore = nTotalScore + (tInfo.stageInfo[i].ckscore or 0)
							nTotalRolling = nTotalRolling + (tInfo.stageInfo[i].rollingcount or 0)
						end
						_tClearanceInformation[i] = {
							bossid = nBossId,
							littlebossid = nLittleBossId,
							gametime = nGameTime,
							mapname = sMapName,
						}
						
						if hVar.MAP_INFO[sMapName] then
							_nScore = _nScore + hVar.MAP_INFO[sMapName].scoreV or 0
						else
							_nScore = _nScore + 0
						end
						_nTotalTime = _nTotalTime + nGameTime
					end
					local bIsSysName = false
					if (g_curPlayerName ~= nil) then
						--显示名
						local curMyName = ""
						local playerInfo = LuaGetPlayerByName(g_curPlayerName)
						if playerInfo and (playerInfo.showName) then
							curMyName = playerInfo.showName
						end
						if (curMyName == hVar.tab_string["guest"]) or (curMyName == "GUEST") or (curMyName == rgNameSystem) or (curMyName == "") then
							bIsSysName = true
						end
					end
					if bIsSysName and g_cur_net_state == 1 then
						_shouldShowSetName = 1
					end
				end
				nTotalTime = _nTotalTime
				if tInfo.stage < _nTotalStageCount then
					_nTotalTime = _nTotalTime + oWorld:gametime()
				end
				--结算 根据通关层数以及营救数量计算金币
				--_nRescueNum = oWorld.data.statistics_rescue_num
				_nCupScore = 0
				nTotalScore = nTotalScore + _nScore * 2 + _nRescueNum * hVar.COIN_WITH_RESCUED
				_nScore = _nScore + _nRescueNum * hVar.COIN_WITH_RESCUED

				local scoreingame = 0
				local tempscore = GameManager.GetGameInfo("scoreingame")
				if type(tempscore) == "number" then
					scoreingame = tempscore
				end
				_nScore = _nScore + scoreingame

				--更新碾压数记录
				LuaUpdateRandMapSingleBestRecord("totalrolling",nTotalRolling)
				
				--添加积分
				--LuaAddPlayerScore(_nScore)
				--修改添加积分的同时加上来源以便统计
				LuaAddPlayerScoreByWay(_nScore,hVar.GET_SCORE_WAY.GAMESETTLEMENT)
				
				--[[
				--添加捡取的战术卡碎片
				_tTacticsList = {}
				local tacticRewardInfo = {}
				local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
				if tInfo.stageInfo then
					for nStage, _ in pairs(tInfo.stageInfo) do
						--print("stage=" .. nStage)
						local tacticInfo = tInfo.stageInfo[nStage]["tacticInfo"] or {} --本关地图内捡取的战术卡碎片信息
						for tacticId, num in pairs(tacticInfo) do
							--print("    ", tacticId, num)
							local tacticNum = tacticRewardInfo[tacticId] or 0
							tacticRewardInfo[tacticId] = tacticNum + num
						end
					end
				end
				for tacticId, tacticNum in pairs(tacticRewardInfo) do
					--用于显示
					_tTacticsList[#_tTacticsList + 1] = {tacticId, tacticNum}
					--print(tacticId, tacticNum)
					local notSaveFlag = true --不存档，最后统一存档
					LuaAddPlayerTacticDebris(tacticId, tacticNum, notSaveFlag) --加战术卡碎片
				end
				]]
				
				--存档
				LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
				LuaSavePlayerList()
				
				--记录结算时积分值
				local curScore = LuaGetPlayerScore()
				--同步积分 
				SendCmdFunc["send_RoleData"](g_curPlayerName,curScore)
				--记录log
				LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.GAMEOVERSCORE,curScore)
				--记录该局游戏总共花费时间
				LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.GAMETIME,math.ceil(_nTotalTime / 1000))
				--记录该局游戏结束
				local curtime = os.time()
				local timeStr = os.date("%m_%d_%H_%M",curtime)
				LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.GAMEOVERTIME,timeStr)
				
				LuaUploadPlayerScoreInfo()
				
				local nWeaponIdx = LuaGetHeroWeaponIdx(_nCurrentTankID)
				local nWeaponId = 0
				local tabU = hVar.tab_unit[_nCurrentTankID]
				if tabU.weapon_unit and tabU.weapon_unit[nWeaponIdx] then
					local tWeaponInfo = tabU.weapon_unit[nWeaponIdx]
					nWeaponId = tWeaponInfo.unitId
				end
				local nTime = math.ceil(nTotalTime / 1000)
				print(clearStage, nTankID, nWeaponId, nTime, _nRescueNum, nTotalScore,nBestCK)
				--上传排行
				local tRecord = {
					stage = clearStage,
					tankID = nTankID,
					weaponID = nWeaponId,
					gametime = nTime,
					rescueNum = _nRescueNum,
					score = nTotalScore,
					bestCK = nBestCK,
				}
				local MapDifficulty = oWorld.data.MapDifficulty
				local bId = hVar.TANK_BILLBOARD_RANK_TYPE.RANK_STAGE --过图排行榜
				LuaUpdateRandMapBestRecord(g_curPlayerName,tRecord)
				SendCmdFunc["send_tank_socre"](bId,MapDifficulty,clearStage, nTankID, nWeaponId, nTime, _nRescueNum, nTotalScore,nBestCK)

				local tBestCK = LuaGetRandMapSingleBestRecord("bestCK")
				if type(tBestCK) == "table" then
					local bId = hVar.TANK_BILLBOARD_RANK_TYPE.RANK_CONTINOUSKILL --连击排行
					local stage_bestCK = tBestCK[2]
					local num_bestCk = tBestCK[1]
					print(stage_bestCK,num_bestCk)
					SendCmdFunc["send_tank_socre"](bId,MapDifficulty,stage_bestCK, nTankID, nWeaponId, nTime, _nRescueNum, nTotalScore,num_bestCk)
				end
				
				local keyList = {"skill", "map", "material", "log",}
				LuaSavePlayerData_Android_Upload(keyList, "总结算")
			end
		else
			return 0
		end
		return 1
	end

	--创建积分详情
	CreateScoreInfo = function()
		local tempY = _scoreStartY
		local delayh = _scoredelayh
		local index = 0
		local iconCount = 3

		--游戏时间图标
		_childUI["imgGameTime"] = hUI.image:new({
			model = "misc/gameover/icon_time.png",
			parent = _parent,
			w = 56,
			h = 56,
			--x = _offx - 62,
			--y = _offy + tempY + delayh * index,
			x = _offx - 36 + _scoredelayW * (index - math.ceil(iconCount/2)+1) - 30 ,
			y = _offy + tempY,
		})
		_tUIRemoveList[#_tUIRemoveList+1] = "imgGameTime"

		_childUI["labelGameTime"] = hUI.label:new({
			parent = _parent,
			--x = _offx - 2,
			--y = _offy + tempY + delayh * index - 4,
			x = _offx + 12 + _scoredelayW * (index - math.ceil(iconCount/2)+1) - 30 ,
			y = _offy + tempY - 4,
			font = "num",
			border = 0,
			width = 550,
			align = "LC",
			size = 26,
			text = 0,
		})
		_tUIRemoveList[#_tUIRemoveList+1] = "labelGameTime"

		index = index + 1

		--游戏营救人数图标
		_childUI["imgMan"] = hUI.image:new({
			model = "misc/gameover/icon_man.png",
			parent = _parent,
			--w = 56,
			--h = 56,
			--x = _offx - 62,
			--y = _offy + tempY + delayh * index,
			x = _offx - 36 + _scoredelayW * (index - math.ceil(iconCount/2)+1) ,
			y = _offy + tempY,
		})
		_tUIRemoveList[#_tUIRemoveList+1] = "imgMan"

		_childUI["labelManNum"] = hUI.label:new({
			parent = _parent,
			--x = _offx - 2,
			--y = _offy + tempY + delayh * index - 4,
			x = _offx + 12 + _scoredelayW * (index - math.ceil(iconCount/2)+1) ,
			y = _offy + tempY - 4,
			font = "num",
			border = 0,
			width = 550,
			align = "LC",
			size = 26,
			text = 0,
		})
		_tUIRemoveList[#_tUIRemoveList+1] = "labelManNum"
		index = index + 1

		--金币图标
		_childUI["imgGold"] = hUI.image:new({
			model = "misc/skillup/mu_coin.png",
			parent = _parent,
			--w = 56,
			--h = 56,
			--x = _offx - 62,
			--y = _offy + tempY + delayh * index,
			x = _offx - 36 + _scoredelayW * (index - math.ceil(iconCount/2)+1) ,
			y = _offy + tempY,
		})
		_tUIRemoveList[#_tUIRemoveList+1] = "imgGold"

		_childUI["labelGold"] = hUI.label:new({
			parent = _parent,
			--x = _offx - 2,
			--y = _offy + tempY + delayh * index - 4,
			x = _offx + 12 + _scoredelayW * (index - math.ceil(iconCount/2)+1) ,
			y = _offy + tempY - 4,
			font = "num",
			border = 0,
			width = 550,
			align = "LC",
			size = 26,
			text = 0,
		})
		_tUIRemoveList[#_tUIRemoveList+1] = "labelGold"
		index = index + 1

		_childUI["imgCup"] = hUI.image:new({
			model = "misc/totalsettlement/cup.png",
			parent = _parent,
			--w = 56,
			--h = 56,
			--x = _offx - 62,
			--y = _offy + tempY + delayh * index,
			x = _offx - 36 + _scoredelayW * (index - math.ceil(iconCount/2)+1) ,
			y = _offy + tempY,
		})
		_tUIRemoveList[#_tUIRemoveList+1] = "imgCup"

		_childUI["labelRankScore"] = hUI.label:new({
			parent = _parent,
			--x = _offx - 2,
			--y = _offy + tempY + delayh * index - 4,
			x = _offx + 12 + _scoredelayW * (index - math.ceil(iconCount/2)+1) ,
			y = _offy + tempY - 4,
			font = "num",
			border = 0,
			width = 550,
			align = "LC",
			size = 26,
			text = 0,
		})
		_tUIRemoveList[#_tUIRemoveList+1] = "labelRankScore"
		index = index + 1

		_childUI["imgGameTime"].handle.s:setOpacity(0)
		_childUI["labelGameTime"].handle.s:setOpacity(0)
		_childUI["imgCup"].handle.s:setOpacity(0)
		_childUI["labelRankScore"].handle.s:setOpacity(0)
		_childUI["imgMan"].handle.s:setOpacity(0)
		_childUI["labelManNum"].handle.s:setOpacity(0)
		_childUI["imgGold"].handle.s:setOpacity(0)
		_childUI["labelGold"].handle.s:setOpacity(0)
	end

	--创建坦克
	CreatePlayerTank = function()
		local tabU = hVar.tab_unit[_nCurrentTankID]
		local nWeaponIdx = LuaGetHeroWeaponIdx(_nCurrentTankID)
		local nWeaponId = 0
		local nwheel = tabU.bind_wheel
		if tabU.weapon_unit and tabU.weapon_unit[nWeaponIdx] then
			local tWeaponInfo = tabU.weapon_unit[nWeaponIdx]
			nWeaponId = tWeaponInfo.unitId
		end
		--_nCurrentTankID
		local nScaleTank = 0.6
		local nStartX = (hVar.SCREEN.w-_nLineW)/2
		local nOffY =  hVar.SCREEN.h/2 + _tankStarty

		_childUI["Node"] = hUI.button:new({
			parent = _frm.handle._n,
			model = -1,
			x = nStartX,
			y = nOffY,
		})
		_tUIRemoveList[#_tUIRemoveList+1] = "Node"
		_childUI["Node"].handle._n:setScale(nScaleTank)
		_childUI["Node"].childUI["Tank"] = hUI.thumbImage:new({
			parent = _childUI["Node"].handle._n,
			id = _nCurrentTankID,
			scale = 1,
			facing = 0,
		})
		
		_childUI["Node"].childUI["Wheel"] = hUI.thumbImage:new({
			parent = _childUI["Node"].handle._n,
			id = nwheel,
			facing = 0,
		})

		local tab = hVar.tab_unit[nWeaponId]
		if tab then
			if tab.model then
				_childUI["Node"].childUI["Weapon"] = hUI.thumbImage:new({
					parent = _childUI["Node"].handle._n,
					id = nWeaponId,
					facing = 0,
				})
			end

			if type(tab.effect) == "table" and #tab.effect > 0 then
				local _frmNode  = _childUI["Node"]
				local _parentNode = _childUI["Node"].handle._n
				for i = 1,#tab.effect do
					local effect = tab.effect[i]
					local effectId = effect[1]
					local effX = effect[2] or 0
					local effY = effect[3] or 0
					local effScale = effect[4] or 1.0
					--print(effectId, cardId)
					local effModel = effectId
					if (type(effectId) == "number") then
						effModel = hVar.tab_effect[effectId].model
					end
					if effModel then
						_frmNode.childUI["UnitEffModel" .. i] = hUI.image:new({
							parent = _parentNode,
							model = effModel,
							align = "MC",
							x = effX,
							y = effY,
							z = effect[4] or -1,
							scale = 1.2 * effScale,
						})
						
						local tabM = hApi.GetModelByName(effModel)
						if tabM then
							local tRelease = {}
							local path = tabM.image
							tRelease[path] = 1
							hResource.model:releasePlist(tRelease)
							
							--geyachao: 可能会弹框，这里不删除了，统一在回收资源的地方释放
							--[[
							local pngPath = "data/image/"..(tabM.image)
							local texture = CCTextureCache:sharedTextureCache():textureForKey(pngPath)
							--print("释放特效")
							--print("pngPath=", pngPath)
							--print("texture = ", texture)
							
							if texture then
								CCTextureCache:sharedTextureCache():removeTexture(texture)
							end
							]]
						end
					end
				end
			end
		end

		_childUI["Boss_bar"] = hUI.valbar:new({
			parent = _parent,
			model = "misc/totalsettlement/process.png",
			--back = {model = "misc/skillup/line.png",x=0,y=0,w=_nLineW,h=8},
			x = nStartX +5,
			y = nOffY + 70,
			--w = _nLineW,
			--h = 400,
			align = "LT",
			z = -1.
		})
		--_bar = _childUI["Boss_bar"]
		--_bar:setV(0,_nLineW)
		_tUIRemoveList[#_tUIRemoveList+1] = "Boss_bar"
		
		--每一段长度
		local nY = nOffY + 140
		local nOffW = math.floor(_nLineW / _nTotalStageCount)
		for i = 1,#_tClearanceInformation do
			local tInfo = _tClearanceInformation[i]
			--BOSS头像
			--_childUI["img_boss"..i] = hUI.thumbImage:new({
				--parent = _frm.handle._n,
				--id = tInfo.bossid,
				--facing = 0,
				--x = nStartX + i * nOffW - 5,
				--y = nY,
			--})
			local sModel = string.format("icon/hero/boss_%02d.png",i)
			_childUI["img_boss"..i] = hUI.image:new({
				parent = _frm.handle._n,
				model = sModel,
				align = "MC",
				x = nStartX + i * nOffW,
				y = nY,

			})
			_tUIRemoveList[#_tUIRemoveList+1] = "img_boss"..i
			_childUI["img_boss"..i].handle.s:setOpacity(0)

			if tInfo.littlebossid > 0 then
				local w,h = 60,60
				local x,y = 0,0
				if type(modelParam[tInfo.littlebossid]) == "table" then
					w = modelParam[tInfo.littlebossid].w or w
					h = modelParam[tInfo.littlebossid].h or y
					x = modelParam[tInfo.littlebossid].x or x
					y = modelParam[tInfo.littlebossid].y or y
				end
				_childUI["img_littleboss"..i] = hUI.thumbImage:new({
					parent = _frm.handle._n,
					id = tInfo.littlebossid,
					facing = 0,
					x = nStartX + (i-0.5) * nOffW - 5 + x,
					y = nY - 70 +y,
					w = w,
					h = h,
				})
				_tUIRemoveList[#_tUIRemoveList+1] = "img_littleboss"..i
				_childUI["img_littleboss"..i].handle.s:setOpacity(0)
			end

			--_childUI["lab_boss_number"..i] = hUI.label:new({
				--parent = _frm.handle._n,
				--size = 32,
				--font = "numWhite",
				--x = nStartX + i * nOffW - 13,
				--y = nY - 175,
				--text = i,
			--})
			--_childUI["lab_boss_number"..i].handle.s:setColor(ccc3(55,68,138))
			--_childUI["lab_boss_number"..i].handle.s:setOpacity(0)
			--_tUIRemoveList[#_tUIRemoveList+1] = "lab_boss_number"..i
		end

		local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
		if #_tClearanceInformation < tInfo.stage and tInfo.stage < 7 then
			
			if tInfo.bossid_l and tInfo.bossid_l > 0 then
				local i = #_tClearanceInformation + 1
				local w,h = 60,60
				local x,y = 0,0
				if type(modelParam[tInfo.bossid_l]) == "table" then
					w = modelParam[tInfo.bossid_l].w
					h = modelParam[tInfo.bossid_l].h
					x = modelParam[tInfo.bossid_l].x or x
					y = modelParam[tInfo.bossid_l].y or y
				end
				_childUI["img_littleboss"..i] = hUI.thumbImage:new({
					parent = _frm.handle._n,
					id = tInfo.bossid_l,
					facing = 0,
					x = nStartX + (i-0.5) * nOffW - 5 + x,
					y = nY - 70 + y,
					w = w,
					h = h,
				})
				_tUIRemoveList[#_tUIRemoveList+1] = "img_littleboss"..i
				_childUI["img_littleboss"..i].handle.s:setOpacity(0)
			end
		end
	end

	--创建战术卡信息
	CreateTacticsInfo = function()
		print("CreateTacticsInfo",#_tTacticsList)
		local index = 0
		local cow = 6
		local delayW = 150
		local startX = _offx - 66 - _scoredelayW
		print(startX)
		local startY = -116
		local count = #_tTacticsList
		local delayH = 90
		if count > 6 then
			startY = -94
		end
		for i = 1,count do
			local tacticsId,num = unpack(_tTacticsList[i])
			local tabT = hVar.tab_tactics[tacticsId]
			if tabT and tabT.itemId then
				local tabI = hVar.tab_item[tabT.itemId]
				if tabI and tabI.dropUnit then
					print(tacticsId,tabT.itemId,tabI.dropUnit)
					index = index + 1
					local yn = math.ceil(index / cow)
					_childUI["imgTactics"..index] = hUI.thumbImage:new({
						parent = _parent,
						id = tabI.dropUnit,
						x = startX + (index -1)% cow * delayW,
						y = _offy + startY - delayH * (yn - 1),
						scale = 0.8,
					})
					_childUI["imgTactics"..index].handle.s:setOpacity(0)
					_tUIRemoveList[#_tUIRemoveList+1] = "imgTactics"..index

					_childUI["LabTactics"..index] = hUI.label:new({
						parent = _parent,
						font = "num",
						text = "x"..tostring(num),
						x = startX + (index -1)% cow * delayW + 24,
						y = _offy + startY - delayH * (yn - 1),
					})
					_childUI["LabTactics"..index].handle.s:setOpacity(0)
					_tUIRemoveList[#_tUIRemoveList+1] = "LabTactics"..index
				end
			end
		end
	end

	--播放坦克移动动画
	PlayTankMoveAction = function()
		--轮子动画
		local act1 = CCMoveBy:create(0.1, ccp(0, 2))
		local act2 = CCMoveBy:create(0.15, ccp(2, 0))
		local act3 = CCMoveBy:create(0.1, ccp(0, -2))
		local act4 = CCMoveBy:create(0.15, ccp(-2, 0))
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_childUI["Node"].childUI["Wheel"].handle.s:runAction(CCRepeatForever:create(sequence))
		--战车行驶动画
		local a = CCArray:create()
		for i = 1,math.min(#_tClearanceInformation+1,_nTotalStageCount) do
			local nStartX = (hVar.SCREEN.w-_nLineW)/2
			local nOffW = math.floor(_nLineW / _nTotalStageCount)
			if i > #_tClearanceInformation then
				local moveTo = CCMoveTo:create(0.6,ccp(nStartX + nOffW * (i - 0.5) - 10,_childUI["Node"].data.y))
				if _nIsLeave == 0 then
					a:addObject(moveTo)
				end
				local callback = CCCallFunc:create(function()
					local act1 = CCEaseSineOut:create(CCFadeIn:create(0.2)) --淡入
					if _childUI["img_littleboss"..i] then
						_childUI["img_littleboss"..i].handle.s:runAction(act1)
					end
				end)
				a:addObject(callback)
			else
				local moveTo = CCMoveTo:create(0.3,ccp(nStartX + nOffW * (i - 0.5) - 10,_childUI["Node"].data.y))
				a:addObject(moveTo)
				local callback = CCCallFunc:create(function()
					local act1 = CCEaseSineOut:create(CCFadeIn:create(0.2)) --淡入
					if _childUI["img_littleboss"..i] then
						_childUI["img_littleboss"..i].handle.s:runAction(act1)
					end
				end)
				a:addObject(callback)
				local moveTo1 = CCMoveTo:create(0.3,ccp(nStartX + nOffW * i - 10,_childUI["Node"].data.y))
				a:addObject(moveTo1)
				local callback1 = CCCallFunc:create(function()
					local act1 = CCEaseSineOut:create(CCFadeIn:create(0.2)) --淡入
					if _childUI["img_boss"..i] then
						_childUI["img_boss"..i].handle.s:runAction(act1)
					end
				end)
				a:addObject(callback1)
			end
			local delta = CCDelayTime:create(0.2)
			a:addObject(delta)
		end
		local callback = CCCallFunc:create(function()
			_childUI["Node"].childUI["Wheel"].handle.s:stopAllActions()
			PlayScoreAction()
			PlayTacticsAction()
		end)
		a:addObject(callback)
		local sequence = CCSequence:create(a)
		_childUI["Node"].handle._n:runAction(sequence)
	end

	--播放积分动画
	PlayScoreAction = function()
		local actionList = {
			{_childUI["imgGameTime"],_childUI["labelGameTime"],math.ceil(_nTotalTime / 1000),0,0},
			{_childUI["imgMan"],_childUI["labelManNum"],_nRescueNum,0,0},
			{_childUI["imgGold"],_childUI["labelGold"],_nScore,0,0},
			--{_childUI["imgCup"],_childUI["labelRankScore"],_nCupScore,0,0},
		}
		local a = CCArray:create()

		local Settlement = CCCallFunc:create(function()
			hApi.addTimerForever("TotalSettlement",hVar.TIMER_MODE.GAMETIME,1,function()
				local count = #actionList
				for i = 1,#actionList do
					local lab = actionList[i][2]
					if lab and actionList[i][5] == 1 then
						if actionList[i][3] > 5000 then
							actionList[i][3] = actionList[i][3] - 800
							actionList[i][4] = actionList[i][4] + 800
						elseif actionList[i][3] > 1000 then
							actionList[i][3] = actionList[i][3] - 60
							actionList[i][4] = actionList[i][4] + 60
						elseif actionList[i][3] > 400 then
							actionList[i][3] = actionList[i][3] - 24
							actionList[i][4] = actionList[i][4] + 24
						elseif actionList[i][3] > 100 then
							actionList[i][3] = actionList[i][3] - 11
							actionList[i][4] = actionList[i][4] + 11
						elseif actionList[i][3] > 40 then
							actionList[i][3] = actionList[i][3] - 5
							actionList[i][4] = actionList[i][4] + 5
						elseif actionList[i][3] > 20 then
							actionList[i][3] = actionList[i][3] - 2
							actionList[i][4] = actionList[i][4] + 2
						elseif actionList[i][3] > 0 then
							actionList[i][3] = actionList[i][3] - 1
							actionList[i][4] = actionList[i][4] + 1
						else
							count = count - 1
						end
						--local gametime = world:gametime()
						--local seconds = math.ceil(gametime / 1000)
						--local minute = math.floor(seconds / 60)
						--local second = seconds - minute * 60
						if i == 1 then
							local seconds = actionList[i][4]
							local minute = math.floor(seconds / 60)
							local second = seconds - minute * 60
							local str = string.format("%d:%02d",minute,second)
							lab:setText(str)
						else
							lab:setText(tostring(actionList[i][4]))
						end
					end
				end
				if count == 0 then
					hGlobal.event:event("LocalEvent_RefreshCurGameScore")
					hApi.clearTimer("TotalSettlement")
					
					if _shouldShowSetName == 1 then
						_childUI["btnOk"]:setstate(1)
						hApi.CreateModifyInputBox_Diablo(1,2)
					end
					
				end
			end)
		end)
		
		for i = 1,#actionList do
			local callback = CCCallFunc:create(function()
				local act1 = CCEaseSineOut:create(CCFadeIn:create(0.2)) --淡入
				local img = actionList[i][1]
				if img then
					img.handle.s:runAction(act1)
				end
			end)
			local callback1 = CCCallFunc:create(function()
				local act1 = CCEaseSineOut:create(CCFadeIn:create(0.2)) --淡入
				local lab = actionList[i][2]
				if lab then
					lab.handle.s:runAction(act1)
				end
			end)
			local callback2 = CCCallFunc:create(function()
				actionList[i][5] = 1
			end)
			local delta = CCDelayTime:create(0.2)
			local delta1 = CCDelayTime:create(0.1)
			local delta2 = CCDelayTime:create(0.1)
			a:addObject(callback)
			a:addObject(delta)
			a:addObject(callback1)
			a:addObject(delta1)
			a:addObject(callback2)
			if i == 1 then
				a:addObject(Settlement)
			end
			a:addObject(delta2)
		end
		local sequence = CCSequence:create(a)
		_childUI["Node"].handle._n:runAction(sequence)
	end

	--播放战术卡动画
	PlayTacticsAction = function()
		local a = CCArray:create()
		for i = 1,#_tTacticsList do
			local callback = CCCallFunc:create(function()
				local act1 = CCEaseSineOut:create(CCFadeIn:create(0.2)) --淡入
				local img = _childUI["imgTactics"..i]
				if img then
					img.handle.s:runAction(act1)
				end
			end)
			local callback1 = CCCallFunc:create(function()
				local act1 = CCEaseSineOut:create(CCFadeIn:create(0.2)) --淡入
				local lab = _childUI["LabTactics"..i]
				if lab then
					lab.handle.s:runAction(act1)
				end
			end)
			local delta = CCDelayTime:create(0.2)
			local delta2 = CCDelayTime:create(0.2)
			a:addObject(callback)
			a:addObject(delta)
			a:addObject(callback1)
			a:addObject(delta2)
		end
		if (#_tTacticsList > 0) then
			local sequence = CCSequence:create(a)
			_childUI["Node"].handle._n:runAction(sequence)
		end
	end

	--播放总结算动画
	PlayTotalSettlementAction = function()
		PlayTankMoveAction()
	end

	hGlobal.event:listen("LocalEvent_PlayTotalSettlement","_play",function()
		OnCreateTotalSettlementFrm()
		PlayTotalSettlementAction()
	end)

	hGlobal.event:listen("LocalEvent_ShowTotalSettlement","_show",function(nleave)
		if type(nleave) == "number" then
			_nIsLeave = nleave
		end
		--总结算
		if TotalSettlement() == 1 then
			hApi.addTimerOnce("ShowTotalSettlement",1000,function()
				hGlobal.event:event("LocalEvent_PlayTotalSettlement")
			end)
		end
	end)
end
--if hGlobal.UI.TotalSettlementFrm then
	--hGlobal.UI.TotalSettlementFrm:del()
	--hGlobal.UI.TotalSettlementFrm = nil
--end
--hGlobal.UI.InitTotalSettlementFrm()
--hGlobal.event:event("LocalEvent_ShowTotalSettlement")

--存盘点
hGlobal.UI.InitGameSettlementFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowGameSettlementFrm","ShowFrm"}
	if mode ~= "include" then
		--return tInitEventName
	end

	local _bCanCreate = true
	local _frm,_parent,_childUI = nil,nil,nil
	local _tTacticsData = {}
	local _tCapsuleData = {}

	local _nTacticsW,_nTacticsH = 76,70
	local _nCapsuleW,_nCapsuleH = 76,76

	local _nBoardW,_nBoardH = 720,720
	local _nIndex = 0
	local _nGetExp = 0
	local _shouldPlayLvUp = 0

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CloseFrm = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateUI = hApi.DoNothing
	local _CODE_CreateTank = hApi.DoNothing
	local _CODE_CreateGameScore = hApi.DoNothing
	local _CODE_GetData = hApi.DoNothing
	local _CODE_CreateAward = hApi.DoNothing

	local _CODE_PlayLvUp = hApi.DoNothing

	_CODE_PlayLvUp = function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			local nForceMe = oPlayerMe:getforce() --我的势力
			local oHero = oPlayerMe.heros[1]
			if oHero then
				local oUnit = oHero:getunit()
				if oUnit then
					--print("aaaaaa")
					local ex, ey = hApi.chaGetPos(oUnit.handle) --攻击者的坐标
					local ebx, eby, ebw, ebh = oUnit:getbox() --攻击者的包围盒
					local ecenter_x = ex + (ebx + ebw / 2) --攻击者的中心点x位置
					local ecenter_y = ey + (eby + ebh) --攻击者的中心点y位置
					local eff = oWorld:addeffect(3333, 1 ,nil, ecenter_x, ecenter_y - 20) --56
					local eff = oWorld:addeffect(3023, 1 ,nil, ecenter_x, ecenter_y - 24) --56
					hApi.PlaySound("common_hero_lvlup")
				end
			end
		end
	end

	_CODE_ClearFunc = function()
		if hGlobal.UI.GameSettlementFrm then
			hGlobal.UI.GameSettlementFrm:del()
			hGlobal.UI.GameSettlementFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		
	end

	_CODE_CloseFrm = function()
		_tTacticsData = {}
		_tCapsuleData = {}
		_nGetExp = 0
		_nIndex = 0
		_tCallback = nil
		_CODE_ClearFunc()
	end

	_CODE_CreateUI = function()
		--_CODE_CreateTank()
		_CODE_CreateGameScore()
		_CODE_CreateAward()
	end

	_CODE_CreateTank = function()
		--[[
		_childUI["img_mask"] = hUI.image:new({
			parent = _parent,
			image = "misc/mask.png",
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h/2,
			w = 720,
			h = 720,
		})
		--]]

		local startx = (hVar.SCREEN.w - 720)/2
		local starty = (-hVar.SCREEN.h + 720)/2

		local tankID = 6000
		local weaponid = 6006
		local scale = 0.8

		local offx = 100
		local offy = - 78
		
		_childUI["MyTank"] = hUI.thumbImage:new({
			parent = _parent,
			x = startx + offx,
			y = starty + offy,
			id = tankID,
			facing = 0,
			align = "MC",
			scale = scale,
		})

		_childUI["MyTankWheel"] = hUI.thumbImage:new({
			parent = _parent,
			x = startx + offx,
			y = starty + offy,
			id = hVar.tab_unit[tankID].bind_wheel,
			facing = 0,
			align = "MC",
			scale = scale,
		})

		_childUI["Image_weapon"] = hUI.thumbImage:new({
			parent = _parent,
			id = weaponid,
			x = startx + offx,
			y = starty + offy,
			scale = scale,
			--z = 1,
		})
	end

	_CODE_CreateGameScore = function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		local startx = (hVar.SCREEN.w - 720)/2
		local starty = (-hVar.SCREEN.h + 720)/2 + 64

		_childUI["img_bag"] = hUI.image:new({
			parent = _parent,
			model = "misc/tempbag/iconbag.png",
			x = hVar.SCREEN.w/2 - 150,
			y = starty - 162,
		})

		_childUI["img_arrow"] = hUI.image:new({
			parent = _parent,
			model = "misc/tempbag/arrow.png",
			x = hVar.SCREEN.w/2,
			y = starty - 164,
		})

		_childUI["img_storehouse"] = hUI.image:new({
			parent = _parent,
			model = "misc/tempbag/storehouse.png",
			x = hVar.SCREEN.w/2 + 170,
			y = starty - 154,
		})

		--_childUI["img_line1"] = hUI.image:new({
			--parent = _parent,
			--model = "ui/title_line.png",
			--x = hVar.SCREEN.w/2,
			--y = starty - 240,
			--w = _nBoardW - 40,
			--h = 4,
		--})

		local offw = 104
		local offy = - 128


		--[[
		_childUI["imgMan"] = hUI.image:new({
			model = "misc/gameover/icon_man.png",
			parent = _parent,
			--w = 56,
			--h = 56,
			x = startx + 220 + offw,
			y = starty + offy,
		})

		_childUI["labelManNum"] = hUI.label:new({
			parent = _parent,
			x = startx + 266 + offw,
			y = starty + offy - 4,
			font = "num",
			border = 0,
			width = 550,
			align = "LC",
			size = 26,
			text = oWorld.data.statistics_rescue_count or 0,
		})
		--]]
	end
	
	local _CODE_Sortbysmallid = function(t1,t2)
		return t1[1] < t2[1]
	end
	
	_CODE_GetData = function()
		_tTacticsData = {}
		_tCapsuleData = {}
		local tacticInfo = GameManager.GetGameInfo("tacticInfo")
		for key,value in pairs(tacticInfo) do
			_tTacticsData[#_tTacticsData+1] = {key,value}
		end
		table.sort(_tTacticsData,_CODE_Sortbysmallid)
		
		local chestinfo = GameManager.GetGameInfo("chestInfo")
		for key,value in pairs(chestinfo) do
			_tCapsuleData[#_tCapsuleData+1] = {key,value}
		end
		table.sort(_tCapsuleData,_CODE_Sortbysmallid)

		local scoreNum = GameManager.GetGameInfo("ckscore")
		print(scoreNum)
		if type(scoreNum) == "number" and scoreNum > 0 then
			table.insert(_tCapsuleData,1,{13004,scoreNum})
		end
		
		--改为显示经验值
		local expAdd = 0
		local world = hGlobal.WORLD.LastWorldMap
		local me = world:GetPlayerMe()
		local expBasic = 0
		local expEnemy = me:getresource(hVar.RESOURCE_TYPE.EXP) or 0 --经验值
		expAdd = expBasic + expEnemy
		_nGetExp = expAdd
		
		--当前在使用的战车id
		local tankIdx = LuaGetHeroTankIdx()
		local tankId = hVar.tab_unit[hVar.MY_TANK_ID].tank_unit[tankIdx]
		
		--发送指令，发送战斗结束的数据
		--local world = hGlobal.WORLD.LastWorldMap
		local nIsWin = 0
		local maxStar = 0
		
		--上传游戏结束数据到服务器（飞船结算点）
		hApi.SendGameResultInfo(nIsWin, maxStar, expAdd)
		
		--经验加完后，清空经验
		me:addresource(hVar.RESOURCE_TYPE.EXP, -expEnemy)
	end
	
	_CODE_CreateAward = function()
		local startx = (hVar.SCREEN.w - _nBoardW)/2
		local starty = (-hVar.SCREEN.h + _nBoardH)/2 + 60
		
		--[[
		_tTacticsData= {
			{12013,3},
			{12014,3},
			{12015,2},
			{12016,1},
			{12013,3},
			{12014,3},
			{12015,2},
			{12016,1},
			{12013,3},
			{12014,3},
			{12015,2},
			{12016,1},
			{12014,3},
			{12015,2},
			{12016,1},
		}

		_tCapsuleData = {
			--{13004,4231},
			{13005,3},
			{13006,4},
			{13007,5},
		}
		--]]

		local nCow1 = math.floor(_nBoardW / _nTacticsW) - 2
		local nLine1 = math.ceil(#_tTacticsData / nCow1)
		local offw1 = (_nBoardW - _nTacticsW * nCow1 - 12)/(nCow1+1)
		local offh1 = 28

		local cx = startx + 6
		local cy = starty - 230

		local showline = math.min(nLine1,1)
		for j = 1,showline do
			for i = 1,nCow1 do
				local index = (j - 1) * nCow1 + i
				if _tTacticsData[index] then
					local id = _tTacticsData[index][1]
					local value = _tTacticsData[index][2]

					local x = cx + (i - 0.5) * _nTacticsW + offw1 * i
					local y = cy - (j - 0.5) * _nTacticsH - offh1 * j

					if #_tTacticsData > nCow1 * showline and index == nCow1 * showline then
						_childUI["lab_3point1"] = hUI.label:new({
							parent = _parent,
							x = x - 0.5 * _nTacticsW + 6,
							y = y + 4,
							font = "num",
							border = 0,
							width = 550,
							align = "LC",
							size = 22,
							text = "...",
						})

						_childUI["lab_showmax1"] = hUI.label:new({
							parent = _parent,
							x = x - 0.5 * _nTacticsW + 6 + 46,
							y = y,
							font = "num",
							border = 0,
							width = 550,
							align = "LC",
							size = 26,
							--text = (#_tTacticsData - nCow1 * showline + 1),
							text = #_tTacticsData,
						})
					else
						_childUI["img_tacticsbg"..index] = hUI.image:new({
							parent = _parent,
							model = "misc/tempbag/invertedtrg.png",
							x = x,
							y = y,
						})

						local tabI = hVar.tab_item[id]

						_childUI["img_tactics"..index] = hUI.image:new({
							parent = _parent,
							model = tabI.icon,
							x = x + 1,
							y = y - 2,
						})

						_childUI["lab_tactics"..index] = hUI.label:new({
							parent = _parent,
							text = tostring(value),
							align = "RC",
							font = "num",
							size = 18,
							x = x + 36,
							y = y - 26,
						})
					end
				end
			end
			--cy = cy - _nTacticsH - offh
		end

		cy = cy - showline * (_nTacticsH + offh1)

		local nCow2 = math.floor(_nBoardW / _nCapsuleW) - 2
		local nLine2 = math.ceil(#_tCapsuleData / nCow2)
		local offw2 = (_nBoardW - _nCapsuleW * nCow2 - 12)/(nCow2+1)
		local offh2 = 28

		for j = 1,nLine2 do
			for i = 1,nCow2 do
				local index = (j - 1) * nCow2 + i
				if _tCapsuleData[index] then
					local id = _tCapsuleData[index][1]
					local value = _tCapsuleData[index][2]

					local x = cx + (i - 0.5) * _nCapsuleW + offw2 * i
					local y = cy - (j - 0.5) * _nCapsuleH - offh2 * j
					local tabI = hVar.tab_item[id]

					--[[
					_childUI["img_capsulebg"..index] = hUI.button:new({
						parent = _parent,
						model = "misc/tempbag/square.png",--square
						x = x,
						y = y,
					})
					--]]

					_childUI["img_capsule"..index] = hUI.image:new({
						parent = _parent,
						model = tabI.icon,
						x = x + 1,
						y = y - 2,
					})

					_childUI["lab_capsule"..index] = hUI.label:new({
						parent = _parent,
						text = tostring(value),
						align = "RC",
						font = "num",
						size = 18,
						x = x + 36,
						y = y - 26,
					})
				end
			end
		end

		cy = cy - nLine2 * (_nCapsuleH + offh2)
		local oWorld = hGlobal.WORLD.LastWorldMap
		local maxshownum = 7
		local mannum = oWorld.data.statistics_rescue_count
		--mannum = 30
		local shownum = math.min(mannum,maxshownum)
		for i = 1,shownum do
			local x = cx + (i - 0.5) * _nCapsuleW + offw2 * i
			local y = cy - 0.5 * _nCapsuleH - offh2
			if i == maxshownum and mannum > maxshownum then
				_childUI["lab_3point2"] = hUI.label:new({
					parent = _parent,
					x = x - 0.5 * _nCapsuleW +6,
					y = y + 4,
					font = "num",
					border = 0,
					width = 550,
					align = "LC",
					size = 22,
					text = "...",
				})

				_childUI["lab_showmax3"] = hUI.label:new({
					parent = _parent,
					x = x - 0.5 * _nCapsuleW + 52,
					y = y,
					font = "num",
					border = 0,
					width = 550,
					align = "LC",
					size = 26,
					--text = (mannum - maxshownum + 1),
					text = mannum,
				})
			else
				_childUI["imgMan"] = hUI.thumbImage:new({
					parent = _parent,
					id = 11004,
					animation = hApi.animationByFacing(nUnitID,"stand",180),
					x = x + 1,
					y = y + 8,
					scale = 0.46,
				})
			end
		end
		if mannum > 0 then
			cy = cy - (_nCapsuleH + offh2)
		end

		--_nGetExp = 100
		if _nGetExp > 0 then
			local x = cx + 0.5 * _nCapsuleW + offw2
			local y = cy - 0.5 * _nCapsuleH - offh2
			_childUI["img_exp"] = hUI.image:new({
				parent = _parent,
				model = "misc/skillup/exp.png",
				x = x,
				y = y,
			})

			_childUI["lab_exp"] = hUI.label:new({
				parent = _parent,
				text = "+"..tostring(_nGetExp),
				align = "RC",
				font = "num",
				size = 22,
				x = x + 108,
				y = y,
			})
		end
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.GameSettlementFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = 10000,
			show = 0,
			--dragable = 2,
			dragable = 3, --点击后消失
			autoactive = 0,
			background = -1, --无底图
			border = 0, --无边框
		})
		_frm = hGlobal.UI.GameSettlementFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		--黑色底板
		_childUI["imgBackground"] = hUI.image:new({
			parent = _parent,
			model = "misc/mask_white.png",
			x = hVar.SCREEN.w / 2,
			y = -hVar.SCREEN.h / 2,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
		})
		_childUI["imgBackground"].handle.s:setOpacity(168)
		_childUI["imgBackground"].handle.s:setColor(ccc3(0, 0, 0))
		
		_childUI["imgBackboard"] = hUI.image:new({
			parent = _parent,
			model = "misc/tempbag/blackbg.png",
			x = hVar.SCREEN.w / 2,
			y = -hVar.SCREEN.h / 2,
			w = 896,
			h = 896,
		})
		_childUI["imgBackboard"].handle.s:setOpacity(120)
		
		_CODE_CreateUI()
		
		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/addition/cg.png",
			label = {text = hVar.tab_string["Exit_Ack"],size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
			x = hVar.SCREEN.w / 2,
			y = (-hVar.SCREEN.h + 720)/2 - 648,
			code = function()
				--结算
				GameManager.SettlementTempBagAward()
				if _shouldPlayLvUp == 1 then
					_shouldPlayLvUp = 0
					hApi.addTimerOnce("TankLvUp",1000,function()
						_CODE_PlayLvUp()
					end)
				end
				if type(_tCallback) == "table" then
					hGlobal.event:event(_tCallback[1],_tCallback[2])
				end
				_CODE_CloseFrm()
				_bCanCreate = true
			end,
		}) 

		_frm:show(1)
		_frm:active()
	end

	hGlobal.event:listen("LocalEvent_TankLvUp","GameSettlement",function()
		if _frm and _frm.data.show == 1 then
			_shouldPlayLvUp = 1
		end
		--_CODE_PlayLvUp()
	end)

	hGlobal.event:listen("LocalEvent_SpinScreen","GameSettlement",function()
		if _frm and _frm.data.show == 1 then
			_bCanCreate = true
			_CODE_ClearFunc()
			_CODE_CreateFrm()
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(index,tCallback)
		if _bCanCreate and _nIndex == 0 then
			_bCanCreate = false
			_CODE_ClearFunc()
			_CODE_GetData()
			_nIndex = index
			_tCallback = tCallback
			_CODE_CreateFrm()
		end
	end)
end