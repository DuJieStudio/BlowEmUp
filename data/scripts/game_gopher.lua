hGlobal.UI.InitGopherBoomGame = function(mode)
	local tInitEventName = {"LocalEvent_EnterGopherBoomGame", "_game",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local GAMESTATE_DEFINE = {
		NULL = 0,
		WAITING = 1,
		START = 2,
		WAITCLEAR = 3,
		SETTLEMENT = 4,
		END = 5,
	}

	--炸地鼠难度配置表
	local DIFF_DEFINE = {}

	local _gamestate = GAMESTATE_DEFINE.NULL
	local _oPlayerUnit = nil
	local _backX,_backY = nil,nil
	local _AwardX,_AwardY = nil,nil
	local _tGopherList = {}
	local _tGopherBirthList = {}
	local _tBirthIndexWithGopher = {}
	local _tUnitIDWithGameIndex = {}
	local _tUnitDSIndexList = {}
	local _tAwardUnit = {}

	local _frm,_childUI,_parent =  nil,nil,nil
	local _SystemTime = 0
	local _TimeAll = 0
	local _TimeRamain = 0 
	local _TimePause = 0
	local _PauseStart = 0
	local _IsPause = 0
	local _WaitRefreshTime = {}
	local _ChooseDiff = 0
	local _GameUnitIndex = 0
	local _UIoffY = 0
	local _CountKill = nil
	local _CountKillDSUnit = nil
	local _CountBoom = nil
	local _nMaxUnit = 0

	local _CODE_ResetDate = hApi.DoNothing
	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_GetGameDate = hApi.DoNothing
	local _CODE_GetEmptyBirthIndex = hApi.DoNothing
	local _CODE_GetCreateGopherId = hApi.DoNothing
	local _CODE_CreateGopher = hApi.DoNothing
	local _CODE_CreateGameManager =  hApi.DoNothing
	local _CODE_CountGopherDead = hApi.DoNothing

	local _CODE_EnterGameSpace = hApi.DoNothing
	local _CODE_BackToStartSpace = hApi.DoNothing

	local _CODE_GetDSUnitIndexList = hApi.DoNothing
	local _CODE_GetUnitActionMode = hApi.DoNothing
	local _CODE_GetUnitMoveToTarget = hApi.DoNothing

	local _CODE_StartGame = hApi.DoNothing
	local _CODE_ClearGame = hApi.DoNothing
	local _CODE_ExitGame = hApi.DoNothing

	local _CODE_NextState = hApi.DoNothing
	local _CODE_TotalSettlement = hApi.DoNothing
	local _CODE_GetFinalAward = hApi.DoNothing
	local _CODE_CreateAwardUnit = hApi.DoNothing
	local _CODE_CreateScoreUnit = hApi.DoNothing
	local _CODE_CreateChestUnit = hApi.DoNothing
	local _CODE_CreatePauseFrm = hApi.DoNothing

	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateKillNum = hApi.DoNothing
	local _CODE_UpdateKillNum = hApi.DoNothing
	local _CODE_SetTime = hApi.DoNothing
	local _CODE_ChangeTime = hApi.DoNothing
	local _CODE_IfAllGopherDead = hApi.DoNothing

	local _CODE_CreateInfoMsgbox = hApi.DoNothing

	local _CODE_UnitArrive = hApi.DoNothing
	local _CODE_CountBoomNum = hApi.DoNothing

	local _CODE_AddEvent = hApi.DoNothing
	local _CODE_ClearEvent = hApi.DoNothing

	_CODE_AddEvent = function()
		hGlobal.event:listen("Event_UnitDead", "GopherBoomGame", _CODE_CountGopherDead)
		hGlobal.event:listen("Event_UnitArrive_TD", "_GopherBoomGame",_CODE_UnitArrive)
		hGlobal.event:listen("Event_UnitUseItem", "_GopherBoomGame",_CODE_CountBoomNum)
	end

	_CODE_ClearEvent = function()
		hGlobal.event:listen("Event_UnitDead", "GopherBoomGame",nil)
		hGlobal.event:listen("Event_UnitArrive_TD", "_GopherBoomGame",nil)
		hGlobal.event:listen("Event_UnitUseItem", "_GopherBoomGame",nil)
	end

	_CODE_ClearFunc = function()
		_CODE_ResetDate()
		_CODE_ClearEvent()
		
		if hGlobal.UI.GopherBoomGameFrm then
			hGlobal.UI.GopherBoomGameFrm:del()
			hGlobal.UI.GopherBoomGameFrm = nil
		end
		if hGlobal.UI.GopherBoomGamePauseFrm then
			hGlobal.UI.GopherBoomGamePauseFrm:del()
			hGlobal.UI.GopherBoomGamePauseFrm = nil
		end
		_frm,_childUI,_parent =  nil,nil,nil
		_SystemTime = 0
		_TimeAll = 0
		_TimeRamain = 0
		_TimePause = 0
		_PauseStart = 0
		_WaitRefreshTime = {}
		DIFF_DEFINE = {}
		_ChooseDiff = 0
		_IsPause = 0
		_AwardX,_AwardY = nil,nil
	end

	_CODE_ResetDate = function()
		hApi.clearTimer("GopherBoomGameManager")
		_gamestate = GAMESTATE_DEFINE.NULL
		_tGopherBirthList = {}
		_tBirthIndexWithGopher = {}
		_tUnitIDWithGameIndex = {}
		_tUnitDSIndexList = {}
		_CountKill = nil
		_CountKillDSUnit = nil
		_CountBoom = nil
		_backX,_backY = nil,nil
		_nMaxUnit = 0
		for i = 1,#_tGopherList do
			--清理
			for id,tinfo in pairs(_tGopherList) do
				if tinfo then
					local nID = tinfo.unit_ID
					local u = hClass.unit:find(nID)
					if u then
						u:dead()
					end
				end
			end
		end
		for i = 1,#_tAwardUnit do
			--清理
			local nID = _tAwardUnit[i]
			local u = hClass.unit:find(nID)
			if u then
				u:dead()
			end
		end
		_tAwardUnit = {}
		_tGopherList = {}
		_oPlayerUnit = nil
		_GameUnitIndex = 0
	end

	_CODE_GetGameDate = function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			local nForceMe = oPlayerMe:getforce() --我的势力
			local oHero = oPlayerMe.heros[1]
			if oHero then
				_oPlayerUnit = oHero:getunit()
			end
		end

		DIFF_DEFINE = hVar.GameGopherDiffDefine

		_tGopherBirthList = hApi.GetMainBaseGophersBirth()
		if #_tGopherBirthList > 0 and _oPlayerUnit then
			return true
		end
	end

	local _Code_MoveTo = function(tviewReset,toX,toY)
		local viewReset
		if type(tviewReset) == "table" then
			viewReset = {}
			local w,h = 20,20
			--right
			viewReset[1] = math.max(w - ((tviewReset[1] or 0) + (tviewReset[3] or 0)),0)
			--left
			viewReset[2] = tviewReset[1] or 0
			--up
			viewReset[3] = tviewReset[2] or 0
			--bottom
			viewReset[4] =math.max(h - ((tviewReset[2] or 0) + (tviewReset[4] or 0)),0)
		end
		
		if toX and toY and tviewReset then
			local oWorld = hGlobal.WORLD.LastWorldMap
			_oPlayerUnit:setPos(toX, toY)

			TD_ViewSet(viewReset)
			hApi.setViewNodeFocus(toX,toY)
		end
	end
	
	_CODE_EnterGameSpace = function()
		--弹框了？
		if (_oPlayerUnit == nil) then
			return
		end
		
		local oWorld = hGlobal.WORLD.LastWorldMap
		oWorld.data.lockscreen = 1
		oWorld.data.lockscreenX = 1296
		oWorld.data.lockscreenY = 3240
		_backX,_backY = hApi.chaGetPos(_oPlayerUnit.handle)
		--锁定视角及屏幕
		if type(xlGetScreenRotation) == "function" and type(xlRotateScreen) == "function" then
			--不可旋转
			local orientation, lock_flag = xlGetScreenRotation()
			xlRotateScreen(orientation,  1)               --设置屏幕朝向以及是否锁定
		end
		if type(xlView_SetScale) == "function" then
			xlView_SetScale(0.9)
		end
		local tviewReset = {256,2478,2031,1106,}
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
			if hVar.SCREEN.h <= 1280 then
				tviewReset = {256,2600,2031,1106,}
			end
		end
		_Code_MoveTo(tviewReset,oWorld.data.lockscreenX,oWorld.data.lockscreenY)
		_AwardX = oWorld.data.lockscreenX
		_AwardY = oWorld.data.lockscreenY
		
		hGlobal.event:event("LocalEvent_ShowControlBtn",1)
		hGlobal.event:event("LocalEvent_EnableMainbaseFrm",0)
	end

	_CODE_BackToStartSpace = function()
		--恢复视角及锁屏
		hApi.ChangeScreenMode()
		hApi.ResetViewMode()

		local tviewReset = {0,0,3840,2478,}
		_Code_MoveTo(tviewReset,_backX,_backY)
		
		hGlobal.event:event("LocalEvent_ShowControlBtn",0)
		hGlobal.event:event("LocalEvent_EnableMainbaseFrm",1)

		local oWorld = hGlobal.WORLD.LastWorldMap
		oWorld.data.lockscreen = 0

		hGlobal.event:event("LocalEvent_refresheDishuCoin")
	end

	_CODE_GetEmptyBirthIndex = function()
		local index
		local canBirthList = {}
		hApi.gametime()
		--print(#_tGopherBirthList)
		if #_tGopherBirthList > 0 then
			for i = 1,#_tGopherBirthList do
				if _tBirthIndexWithGopher[i] == nil then
					canBirthList[#canBirthList+1] = i
				end
			end
		end
		if #canBirthList > 0 then
			index = canBirthList[math.random(1,#canBirthList)]
		end
		print("_CODE_GetEmptyBirthIndex",#canBirthList,index)
		return index
	end

	_CODE_GetUnitActionMode = function(Actionmode)
		local mode = 1
		if type(Actionmode) == "number" then
			mode = Actionmode
		elseif type(Actionmode) == "table" then
			local Weights = 0
			local tModeRange = {}
			for i = 1,#Actionmode do
				local nm,nw = unpack(Actionmode[i])
				Weights = Weights + nw
				tModeRange[i] = {nm,Weights}
			end
			local rand = math.random(1,Weights)
			for i = 1,#tModeRange do
				if rand <= tModeRange[i][2] then
					mode = tModeRange[i][1]
					break
				end
			end
		end
		return mode
	end

	_CODE_GetUnitMoveToTarget = function(actionmode,range,index)
		local target
		if actionmode == 2 then
			local ostartUnit = _tGopherBirthList[index]
			local sX,sY = ostartUnit.data.worldX,ostartUnit.data.worldY
			local tTarget = {}
			for i = 1,#_tGopherBirthList do
				if i ~= index then
					local endUnit = _tGopherBirthList[i]
					local eX,eY = endUnit.data.worldX,endUnit.data.worldY
					local dx = sX - eX
					local dy = sY - eY
					local dis = math.sqrt(dx * dx + dy * dy)
					if type(range) == "number" then
						if dis <= range then
							tTarget[#tTarget+1] = i
						end
					elseif type(range) == "table" then
						if dis >= range[1] and dis <= range[2] then
							tTarget[#tTarget+1] = i
						end
					end
				end
			end
			if #tTarget > 0 then
				local targetindex = tTarget[math.random(1,#tTarget)]
				target = _tGopherBirthList[targetindex]
			end
		end
		return target
	end

	_CODE_GetCreateGopherId = function()
		local unitid = 11109
		local diffDefine = DIFF_DEFINE[_ChooseDiff] or {}
		local index = _GameUnitIndex + 1
		if _tUnitDSIndexList[index] then
			unitid = diffDefine.unitid_ds or 11109
		else
			unitid = diffDefine.unitid or 11109
		end
		return unitid
	end

	_CODE_CreateGopher = function()	
		if _gamestate == GAMESTATE_DEFINE.START then
			if _IsPause == 1 then
				return
			end
			local curtime = hApi.gametime()
			local diffDefine = DIFF_DEFINE[_ChooseDiff] or {}

			if diffDefine.refreshline then
				for i = 1,#diffDefine.refreshline do
					local realtime = curtime  - _TimePause
					if realtime <= _WaitRefreshTime[i][2] then
						local tLine = diffDefine.refreshline[i]

						local passtime = realtime - _WaitRefreshTime[i][1]
						--print(_WaitRefreshTime,passtime)
						if passtime >= (tLine.refreshtime or 5000) then
							_WaitRefreshTime[i][1] = realtime
							local oUnit
							local index = _CODE_GetEmptyBirthIndex()
							--print("index",index)
							oUnit = _tGopherBirthList[index]
							if oUnit then
								local oWorld = hGlobal.WORLD.LastWorldMap
								local oldx = oUnit.data.worldX
								local oldy = oUnit.data.worldY
								local oGopher = oWorld:addunit(_CODE_GetCreateGopherId(), 24, nil, nil, 0, oldx, oldy, nil, nil, 1, 1)
								local px = _oPlayerUnit.data.worldX
								local py = _oPlayerUnit.data.worldY
								local angle = GetFaceAngle(oldx,oldy,px,py)
								local actionmode = _CODE_GetUnitActionMode(tLine.actionmode)
								local movetounit = _CODE_GetUnitMoveToTarget(actionmode,tLine.movelength,index)

								hApi.ObjectSetFacing(oGopher.handle,angle)
								oGopher.handle._n:setScale(0.1)

								_GameUnitIndex = _GameUnitIndex + 1

								_tGopherList[_GameUnitIndex] = {
									scale = 0.1,
									birthtime = hApi.gametime(),
									disappeartime = tLine.disappeartime,
									movespeed = tLine.movespeed,
									state = 0,
									birthindex =  index,
									unit_ID = oGopher.ID,
									actionmode = actionmode,
									movetounit = movetounit,
									standtime = tLine.standtime or 400,
								}
								_tUnitIDWithGameIndex[oGopher.ID] = _GameUnitIndex
								_tBirthIndexWithGopher[index] = _GameUnitIndex
							end
						end
					end
				end
			end
		end
	end

	_CODE_CreateGameManager = function()
		hApi.addTimerForever("GopherBoomGameManager",hVar.TIMER_MODE.PCTIME,1,function(tick)
			if _IsPause == 1 then
				return
			end
			_CODE_CreateGopher()
			local oWorld = hGlobal.WORLD.LastWorldMap
			local curtime = hApi.gametime()
			local diffDefine = DIFF_DEFINE[_ChooseDiff] or {}
			for index in pairs(_tGopherList) do
				local tInfo = _tGopherList[index]
				local id = _tGopherList[index].unit_ID
				local u = hClass.unit:find(id)
				if not(u and u.attr.hp > 0 and _tUnitIDWithGameIndex[u.ID] == index) then
					u = nil
				end
				local oBirth = _tGopherBirthList[tInfo.birthindex]
				if tInfo.state == 0 then	--初始阶段 地穴动作
					--print("id",id)
					if oBirth then
						oBirth:setanimation({"up","stand2"})
					end
					tInfo.state = 1
				elseif tInfo.state == 1 then	--第1阶段  怪物出生变大
					tInfo.scale = math.min(tInfo.scale + 0.04,1)
					if u then
						--变大
						u.handle._n:setScale(tInfo.scale)
					end
					if tInfo.scale == 1 then
						tInfo.state = 2
					end
				elseif tInfo.state == 2 then	--第2阶段  怪物动作分支 以及地穴动作
					if tInfo.actionmode == 2 then
						if u then
							local oUnit = tInfo.movetounit
							if oUnit then
								tInfo.actionmode = 99	
								local tox = oUnit.data.worldX
								local toy = oUnit.data.worldY

								local oldx = u.data.worldX
								local oldy = u.data.worldY
								local angle = GetFaceAngle(oldx,oldy,tox,toy)

								hApi.ObjectSetFacing(u.handle,angle)
								hApi.UnitMoveToPoint_TD(u,tox,toy,false,tInfo.movespeed)
							else
								tInfo.actionmode = 1
							end
						end
					end
					local deltaTime = curtime - tInfo.birthtime - (tInfo.pausetime1 or 0)
					if deltaTime > 200 and tInfo.actionmode == 99 then
						if oBirth and oBirth:getanimation() == "stand2" then
							oBirth:setanimation({"down","stand"})
						end
					end
					if deltaTime > tInfo.disappeartime then
						if tInfo.actionmode == 1 then
							if oBirth then
								oBirth:setanimation({"down","stand"})
							end
							tInfo.state = 99
						end
					end
				elseif tInfo.state == 3 then	--动作分支 行动模式走动的  后续等待阶段
					if tInfo.arrivetime == nil then
						tInfo.arrivetime = hApi.gametime()
					end
					local deltaTime = curtime - tInfo.arrivetime - (tInfo.pausetime2 or 0)
					if deltaTime >= tInfo.standtime then
						tInfo.state = 99
					end
				elseif tInfo.state == 99 then	--最后阶段 怪物变小消失
					--变小
					tInfo.scale = math.max(tInfo.scale - 0.03,0)
					if u then
						u.handle._n:setScale(tInfo.scale)
					end
					if tInfo.scale <= 0.5 then
						if u then
							u.attr.Trigger_OnUnitDead_SkillId = 0
							local cha_worldC = u:getworldC()
							oWorld.data.Trigger_OnUnitDead_UnitList[cha_worldC] = nil
							u:sethide(1)
							u:dead()
						end
						_tBirthIndexWithGopher[tInfo.birthindex] = nil
						_tGopherList[index] = nil
					end
				end
			end
			if _gamestate == GAMESTATE_DEFINE.WAITCLEAR then
				if _CODE_IfAllGopherDead() then
					_CODE_NextState()
				end
			end
		end)
	end

	_CODE_GetDSUnitIndexList = function()
		local diffDefine = DIFF_DEFINE[_ChooseDiff] or {}
		local totalnum = LuaGetGameGopherUnitMaxNum(_ChooseDiff)
		if type( diffDefine.unit_ds_num) == "number" and totalnum >= diffDefine.unit_ds_num then
			--print("aaaaaaaaaaaaaaaaaaaaaaaa")
			local tIndex = hApi.randomEx(nil,1,totalnum,diffDefine.unit_ds_num)
			for i = 1,#tIndex do
				_tUnitDSIndexList[tIndex[i]] = 1
			end
			table_print(_tUnitDSIndexList)
		end
	end

	_CODE_StartGame = function()
		_CountKill = 0
		_CountKillDSUnit = 0
		_GameUnitIndex = 0
		_CODE_GetDSUnitIndexList()
		hApi.addTimerOnce("disapperLabstate",1000,function()
			_CODE_AddEvent()
			local diffDefine = DIFF_DEFINE[_ChooseDiff] or {}
			_WaitRefreshTime = {}
			if type(diffDefine.refreshline) == "table" then
				local curtime = hApi.gametime()
				for i = 1,#diffDefine.refreshline do
					local tLine = diffDefine.refreshline[i] 
					_WaitRefreshTime[i] = {curtime - tLine.refreshtime + tLine.refreshstart,curtime + (tLine.refreshend or diffDefine.gametime * 1000)}
					--print("_WaitRefreshTime",i,_WaitRefreshTime[i][1],curtime)
				end
			end
			_CODE_CreateGameManager()
			_childUI["lab_State"]:setText("")
			
			_CODE_SetTime(diffDefine.gametime or 60)
			_CountBoom = 0
		end)
	end

	_CODE_ClearGame = function()
		hApi.clearTimer("GopherBoomGameManager")
		_CODE_ClearEvent()
		local oWorld = hGlobal.WORLD.LastWorldMap
		for i = 1,#_tGopherBirthList  do
			local oBirth = _tGopherBirthList[i]
			if oBirth then
				oBirth:setanimation("stand")
			end
		end
		for index in pairs(_tGopherList) do
			local id = _tGopherList[index].unit_ID
			local u = hClass.unit:find(id)
			if u then
				u.attr.Trigger_OnUnitDead_SkillId = 0
				u:sethide(1)
				local cha_worldC = u:getworldC()
				oWorld.data.Trigger_OnUnitDead_UnitList[cha_worldC] = nil
				u:dead()
			end
		end
		_tGopherList = {}
		_tBirthIndexWithGopher = {}
		_tUnitIDWithGameIndex = {}
	end

	_CODE_IfAllGopherDead = function()
		local bIsClear = true
		for index in pairs(_tGopherList) do
			local id = _tGopherList[index].unit_ID
			local u = hClass.unit:find(id)
			if u then
				return false
			end
		end
		return bIsClear
	end

	_CODE_CountGopherDead = function(oUnit, nOperate, oKillerUnit, nId, vParam, oKillerSide, oKillerPos)
		if _gamestate == GAMESTATE_DEFINE.START or _gamestate == GAMESTATE_DEFINE.WAITCLEAR then
			print("_CODE_CountBoomNum")
			local diffDefine = DIFF_DEFINE[_ChooseDiff] or {}
			local countid = diffDefine.unitid
			local countdsid = diffDefine.unitid_ds
			if oKillerUnit and oKillerUnit.data.id == _oPlayerUnit.data.id and _tUnitIDWithGameIndex[oUnit.ID] then
				local index
				if oUnit.data.id == countid then 
					index = _tUnitIDWithGameIndex[oUnit.ID]
					_tUnitIDWithGameIndex[oUnit.ID] = nil
					_CountKill = _CountKill + 1
					--_CODE_CreateKillNum()
					_CODE_UpdateKillNum()
				elseif oUnit.data.id == countdsid then
					index = _tUnitIDWithGameIndex[oUnit.ID]
					_tUnitIDWithGameIndex[oUnit.ID] = nil
					_CountKillDSUnit = _CountKillDSUnit + 1
					--_CODE_CreateKillNum()
					_CODE_UpdateKillNum()
				end
				local tInfo = _tGopherList[index]
				if tInfo and tInfo.actionmode == 99  then
					tInfo.state = 99
				end
			end
		end
	end

	_CODE_NextState = function()
		if _gamestate == GAMESTATE_DEFINE.NULL then
			_gamestate = GAMESTATE_DEFINE.WAITING
			_CODE_EnterGameSpace()
			_CODE_CreateFrm()
			_CODE_UpdateKillNum()
			_CODE_SetTime(3,{220,0,0})
			_childUI["lab_State"]:setText("Ready")
		elseif _gamestate == GAMESTATE_DEFINE.WAITING then
			_gamestate = GAMESTATE_DEFINE.START
			_childUI["lab_State"]:setText("Start")
			--开始游戏
			_CODE_StartGame()
		elseif _gamestate == GAMESTATE_DEFINE.START then
			_gamestate = GAMESTATE_DEFINE.WAITCLEAR
		elseif _gamestate == GAMESTATE_DEFINE.WAITCLEAR then
			--print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
			_gamestate = GAMESTATE_DEFINE.SETTLEMENT
			--清理游戏残留
			_CODE_ClearGame()

			--1秒后结算
			hApi.addTimerOnce("waitSettlement",1000,function()
				_CODE_NextState()
			end)
		elseif _gamestate == GAMESTATE_DEFINE.SETTLEMENT then
			 _CODE_TotalSettlement()
			--_gamestate = GAMESTATE_DEFINE.END
			
			--结算显示奖励
			--local tAward =
			--hApi.GetReawrdGift(tAward)
			--table_print(tAward)
			--_CODE_CreateAwardUnit(tAward)

			 -- if type(tAward) == "table" and #tAward > 0  then
				
			--else
				--_CODE_NextState()
			--end

			--
		elseif _gamestate == GAMESTATE_DEFINE.END then
			_CODE_BackToStartSpace()
			_CODE_ClearFunc()
		end
	end

	_CODE_CreateScoreUnit = function(value)
		local world = hGlobal.WORLD.LastWorldMap
		local numlist = {
			{10,13003},
			{5,13000},
			{3,13013},
			{2,13012},
			{1,13011},
		}

		local list = {}
		local temp = value
		for i = 1,#numlist do
			if temp > numlist[i][1] then
				local c = math.floor(temp/numlist[i][1])
				if i ~= #numlist then
					--print(c,math.max(1,math.floor(c/3)))
					local n = math.random(math.max(1,math.floor(c/3)),c)
					temp = temp - numlist[i][1]  * n
					list[#list + 1] = {numlist[i][2],n}
				else
					temp = temp - numlist[i][1]  * c
					list[#list + 1] = {numlist[i][2],c}
				end
			end
		end

		for i = 1,#list do
			local itemId = list[i][1]
			local num = list[i][2]
			for j = 1, num do
				local tabI = hVar.tab_item[itemId]
				local unitId = tabI.dropUnit
				local face = world:random(0, 360)
				local me = world:GetPlayerMe()
				local heros = me.heros
				local oHero = heros[1]
				local oUnit = oHero:getunit()
				local worldX, worldY = hApi.chaGetPos(oUnit.handle)
				worldX = math.floor(worldX)
				worldY = math.floor(worldY)
				local dropX = math.random(worldX - 160,worldX + 160)
				local dropY = math.random(worldY - 160,worldY + 160)
				local oItem = world:addunit(unitId, nil,nil,nil,face,dropX,dropY,nil,nil)
				oItem:setitemid(itemId)
			end
		end
	end

	_CODE_CreateChestUnit = function(id,value)
		local world = hGlobal.WORLD.LastWorldMap
		local itemId = id
		local worldX = math.floor(_AwardX)
		local worldY = math.floor(_AwardY)
		local range = 200
		local tShow = {}
		local n = value
		if math.floor(n/10) > 0 then
			local count = math.floor(n/10)
			for i = 1,count do
				tShow[#tShow+1] = 10
			end
			n = n % 10
		end
		if math.floor(n/5) > 0 then
			local count = math.floor(n/5)
			for i = 1,count do
				tShow[#tShow+1] = 5
			end
			n = n % 5
		end
		for i = 1,n do
			tShow[#tShow+1] = 1
		end
		--table_print(tShow)
		for i = 1,#tShow do
			local tabI = hVar.tab_item[itemId]
			local unitId = tabI.dropUnit
			local face = world:random(0, 360)
			local dropX = math.random(worldX - range,worldX + range)
			local dropY = math.random(worldY - range,worldY + range)
			local oItem = world:addunit(unitId, nil,nil,nil,face,dropX,dropY,nil,nil)
			oItem:setitemid(itemId)
			_tAwardUnit[#_tAwardUnit+1] = oItem.ID
			local value = tShow[i]
			if value > 1 then
				oItem.chaUI["num"] = hUI.label:new({
					parent = oItem.handle._tn,
					font = "numBlue",
					text = "x" .. tostring(value),
					size = 20,
					align = "MB",
					y = - 44,
				})
			end
			--宝物图标随机动画
			local time = math.random(800, 1200)
			local delayTime1 = math.random(800, 1200)
			local delayTime2 = math.random(900, 1500)
			local moveTime = math.random(1000, 2500)
			local moveDy = math.random(8, 16)
			local act1 = CCDelayTime:create(delayTime1/1000)
			local act2 = CCMoveBy:create(moveTime/1000, ccp(0, moveDy))
			local act3 = CCDelayTime:create(delayTime2/1000)
			local act4 = CCMoveBy:create(moveTime/1000, ccp(0, -moveDy))
			local a = CCArray:create()
			a:addObject(act1)
			a:addObject(act2)
			a:addObject(act3)
			a:addObject(act4)
			local sequence = CCSequence:create(a)
			--oItem.handle.s:stopAllActions() --先停掉之前的动作
			oItem.handle.s:runAction(CCRepeatForever:create(sequence))
		end
	end

	_CODE_CreateAwardUnit = function(tAward)
		table_print(tAward)
		for i = 1,#tAward do
			local ntype = tonumber(tAward[i][1])
			local p2 = tonumber(tAward[i][2])
			local p3 = tonumber(tAward[i][3])
			local p4 = tonumber(tAward[i][4])

			if ntype == hVar.REWARD_TYPE.SCORE then
				_CODE_CreateScoreUnit(nvalue)
			elseif ntype == hVar.REWARD_TYPE.WEAPONGUN_CHEST then
				_CODE_CreateChestUnit(13005,p2)
			elseif ntype == hVar.REWARD_TYPE.TACTIC_CHEST then
				_CODE_CreateChestUnit(13006,p2)
			elseif ntype == hVar.REWARD_TYPE.PET_CHEST then
				_CODE_CreateChestUnit(13007,p2)
			elseif ntype == hVar.REWARD_TYPE.EQUIP_CHEST then
				_CODE_CreateChestUnit(13009,p2)
			end
		end
	end

	_CODE_GetFinalAward = function(awardlist)
		local tAward = {}
		if type(awardlist) == "table" then
			local must = awardlist.must
			local rand = awardlist.rand
			if type(must) == "table" then
				for i = 1,#must do
					local ntype = must[i][1]
					local value = must[i][2]
					if type(value) == "number" then
						tAward[#tAward + 1] = {ntype,value}
					elseif type(value) == "table" then
						tAward[#tAward + 1] = {ntype,hApi.random(value[1],value[2])}
					end
				end
			end
			if type(rand) == "table" then
				for i = 1,#rand do
					local num = rand[i].num
					local pool = rand[i].pool

					if type(pool) == "table" then
						local tIndex = hApi.randomEx(nil,1,#pool,num)

						for j = 1,#tIndex do
							local index = tIndex[j]
							local award = pool[index]
							local ntype = award[1]
							local value = award[2]
							if type(value) == "number" and value > 0 then
								tAward[#tAward + 1] = {ntype,value}
							elseif type(value) == "table" then
								local n = hApi.random(value[1],value[2])
								if n > 0 then
									tAward[#tAward + 1] = {ntype,n}
								end
							end
						end
					end
				end
			end
		end
		return tAward
	end

	_CODE_TotalSettlement = function()
		local tAward = {}
		if _CountKill and _CountKillDSUnit and _CountBoom then
			--LuaRecordGameGopherLog(_ChooseDiff,_CountKill+_CountKillDSUnit,_CountBoom)
			local diffDefine = DIFF_DEFINE[_ChooseDiff] or {}
			local rule = diffDefine.rule
			if type(rule) == "table" then
				local unit_score = rule.unit_score or 0
				local unitds_score = rule.unitds_score or 0
				--local awardlist = rule.awards or {}
				local totalscore = _CountKill * unit_score +  _CountKillDSUnit * unitds_score
				SendCmdFunc["require_gamegopher_reward"](_ChooseDiff,totalscore)
				LuaRecordGameGopherLog2(_ChooseDiff,totalscore)
--				for i = 1,#awardlist do
--					local standard = awardlist[i].shouldscole --积分标准
--					print(totalscore,standard)
--					if totalscore >= standard then
--						tAward = _CODE_GetFinalAward(awardlist[i])
--						break
--					end
--				end
			end
		end
		--return tAward
	end

	_CODE_ExitGame = function()
		if _gamestate == GAMESTATE_DEFINE.START then
			--[[
			_gamestate = GAMESTATE_DEFINE.WAITCLEAR
			if _childUI["node"] and _childUI["node"].childUI["lab_refreshtime"] then
				local oLab = _childUI["node"].childUI["lab_refreshtime"]
				oLab.handle.s:stopAllActions()
				oLab:setText("")
			end
			if _childUI["lab_State"] then
				_childUI["lab_State"]:setText("")
			end
			_CODE_NextState()
			--]]
			local oWorld = hGlobal.WORLD.LastWorldMap
			if oWorld then
				oWorld:pause(1,"pause")
				_IsPause = 1
				_PauseStart = hApi.gametime()
				_CODE_CreatePauseFrm()
			end
		elseif _gamestate == GAMESTATE_DEFINE.SETTLEMENT then
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(hVar.tab_string["__TEXT_WaitTotalment"], hVar.FONTC, 40, "MC", 0, 0)
		elseif _gamestate == GAMESTATE_DEFINE.END then
			_CODE_NextState()
		end
	end

	_CODE_CreatePauseFrm = function()
		if hGlobal.UI.GopherBoomGamePauseFrm == nil then
			hGlobal.UI.GopherBoomGamePauseFrm = hUI.frame:new({
				x = 0,
				y = hVar.SCREEN.h,
				w = hVar.SCREEN.w,
				h = hVar.SCREEN.h,
				background = -1,
				dragable = 0,
				show = 0,
				--z = -1,
				--buttononly = 1,
			})
			local frm = hGlobal.UI.GopherBoomGamePauseFrm
			local parent = frm.handle._n
			local childUI = frm.childUI

			childUI["bg"] = hUI.image:new({
				parent = parent,
				model = "misc/mask.png",
				x = hVar.SCREEN.w/2,
				y = - hVar.SCREEN.h/2,
				w = hVar.SCREEN.w,
				h = hVar.SCREEN.h,
			})
			childUI["bg"].handle.s:setColor(ccc3(0,0,0))
			--childUI["bg"].handle.s:setOpacity(220)

			childUI["btn_continue"] = hUI.button:new({
				parent = parent,
				model = "misc/addition/cg.png",
				label = {text = hVar.tab_string["continue"],size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
				dragbox = childUI["dragBox"],
				scaleT = 0.95,
				x = hVar.SCREEN.w/2 + 140,
				y = -hVar.SCREEN.h/2,
				scale = 0.74,
				code = function()
					_IsPause = 0
					local oWorld = hGlobal.WORLD.LastWorldMap
					if oWorld then
						oWorld:pause(0)
					end
					local waitT = hApi.gametime() - _PauseStart
					_TimePause = _TimePause + waitT
					for index in pairs(_tGopherList) do
						local tInfo = _tGopherList[index]
						if tInfo.state == 2 then
							tInfo.pausetime1 = waitT + (tInfo.pausetime1 or 0)
						elseif tInfo.state == 3 then
							tInfo.pausetime2 = waitT + (tInfo.pausetime2 or 0)
						end
					end
					frm:show(0)
				end
			})

			childUI["btn_leave"] = hUI.button:new({
				parent = parent,
				model = "misc/addition/cg.png",
				label = {text = hVar.tab_string["leave"],size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
				dragbox = childUI["dragBox"],
				scaleT = 0.95,
				x = hVar.SCREEN.w/2 - 140,
				y = -hVar.SCREEN.h/2,
				scale = 0.74,
				code = function()
					local oWorld = hGlobal.WORLD.LastWorldMap
					if oWorld then
						oWorld:pause(0)
					end
					_gamestate = GAMESTATE_DEFINE.WAITCLEAR
					if _childUI["node"] and _childUI["node"].childUI["lab_refreshtime"] then
						local oLab = _childUI["node"].childUI["lab_refreshtime"]
						oLab.handle.s:stopAllActions()
						oLab:setText("")
					end
					if _childUI["lab_State"] then
						_childUI["lab_State"]:setText("")
					end
					_CODE_NextState()
					frm:show(0)
				end
			})
		end
		if hGlobal.UI.GopherBoomGamePauseFrm then
			hGlobal.UI.GopherBoomGamePauseFrm:show(1)
			hGlobal.UI.GopherBoomGamePauseFrm:active()
		end
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.GopherBoomGameFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			dragable = 0,
			show = 0,
			--z = -1,
			buttononly = 1,
		})
		_frm = hGlobal.UI.GopherBoomGameFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		local nOffw = 0

		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
			_UIoffY = - 50
			nOffw = 0
		else
			_UIoffY = 0
			nOffw = hVar.SCREEN.offx
		end

		
		_childUI["node"] = hUI.button:new({
			parent = _parent,
			model = "UI:button_null",
			x = hVar.SCREEN.w/2,
			y = - 48 + _UIoffY,
			w = 1,
			h = 1,
		})

		_childUI["node"].childUI["lab_refreshtime"] = hUI.label:new({
			parent = _childUI["node"].handle._n,
			size = 32,
			align = "MC",
			font = hVar.FONTC,
			x = 0,
			y = 0,
			border = 1,
			text = "",--nMin..":"..nSec,
		})

		_childUI["lab_State"] = hUI.label:new({
			parent = _parent,
			size = 40,
			align = "MC",
			font = hVar.FONTC,
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h/2 + 50,
			border = 1,
			text = "",
		})

		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/back.png",
			x = 54 + nOffw,
			y = -54 + _UIoffY,
			scaleT = 0.98,
			code = function()
				_CODE_ExitGame()
			end,
		})

		_childUI["img_bg"] = hUI.image:new({
			parent = _parent,
			model = "UI:selectbg",
			w = 200,
			h = 36,
			x = 220 + nOffw,
			y = -54 + _UIoffY,
		})

		_childUI["img_wave"] = hUI.image:new({
			parent = _parent,
			--model = "misc/wave_icon.png",
			model = "misc/gopherboom/gopher".._ChooseDiff..".png",
			scale = 0.8,
			x = 148 + nOffw,
			y = -54 + _UIoffY,
		})

		_childUI["lab_killnum"] = hUI.label:new({
			parent = _parent,
			size = 24,
			align = "LC",
			font = "num",
			x = 184 + nOffw,
			y = -54 + _UIoffY,
			--text = "0/45",
		})

		_frm:show(1)
		_frm:active()
	end

	_CODE_UpdateKillNum = function()
		if _childUI["lab_killnum"] then
			--local countnum = _CountKillDSUnit + _CountKill
			local dsnum = 1
			local unit_score = 1
			local unitds_score = 2
			local tDefine = hVar.GameGopherDiffDefine[_ChooseDiff]
			if tDefine then
				dsnum = tDefine.unit_ds_num
				if tDefine.rule then
					unit_score = tDefine.rule.unit_score
					unitds_score = tDefine.rule.unitds_score
				end
			end
	
			local score = (_CountKill or 0) * unit_score + (_CountKillDSUnit or 0) * unitds_score
			local maxscore = (_nMaxUnit - dsnum) * unit_score + dsnum * unitds_score
			local str = string.format("%d/%d",score,maxscore)
			_childUI["lab_killnum"]:setText(str,2)
		end
	end

	_CODE_CreateKillNum = function()
		hApi.safeRemoveT(_childUI,"node_kill")

		local startx = hVar.SCREEN.w - hVar.SCREEN.offx - 200
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
			startx = hVar.SCREEN.w - 80
		end

		_childUI["node_kill"] = hUI.button:new({
			parent = _parent,
			model = "UI:button_null",
			x = startx,
			y = - 56 + _UIoffY,
			w = 1,
			h = 1,
		})

		local nodeChildUI = _childUI["node_kill"].childUI
		local nodeParent = _childUI["node_kill"].handle._n

		nodeChildUI["img_kill"] = hUI.image:new({
			parent = nodeParent,
			model = "misc/continuouskilling/kill.png",
			x = - 60,
		})

		local countnum = _CountKillDSUnit + _CountKill
		local sNum = tostring(countnum)
		local length = #sNum
		for j = 1,length do
			local n = math.floor(countnum / (10^(length-j)))% 10
			nodeChildUI["lab_n"..j] = hUI.image:new({
				parent = nodeParent,
				model = "UI:CKSystemNum",
				animation = "N"..n,
				x = 30 * j - 20,
				y = 2,
				scale = 0.7
			})
		end

		local a = CCScaleTo:create(0.08,1.1,1)
		local aR = CCScaleTo:create(0.03,1,1.1)
		_childUI["node_kill"].handle._n:runAction(CCSequence:createWithTwoActions(a,aR))
	end

	_CODE_SetTime = function(nTime,tRGB)
		local _,Min,Sec = hApi.Seconds2HMS(nTime)
		--print(nTime,nMin,nSec)
		local oLab = _childUI["node"].childUI["lab_refreshtime"]
		oLab:setText(Min..":"..Sec)
		if tRGB then
			oLab.handle.s:setColor(ccc3(tRGB[1], tRGB[2], tRGB[3]))
		else
			oLab.handle.s:setColor(ccc3(255, 255, 255))
		end
		_SystemTime = hApi.gametime()
		
		_TimeAll = nTime
		_TimeRamain = nTime
		oLab.handle.s:stopAllActions()
		oLab.handle.s:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCCallFunc:create(_CODE_ChangeTime))))
	end

	_CODE_ChangeTime = function()
		if _IsPause == 1 then
			return
		end
		local nPassTime = hApi.gametime()-_SystemTime - _TimePause
		local nPassSeconds = math.floor(nPassTime/1000)
		_TimeRamain = _TimeAll - nPassSeconds

		--转换格式
		local _, Min, Sec = hApi.Seconds2HMS(_TimeRamain)
		local oLab = _childUI["node"].childUI["lab_refreshtime"]
		--显示时间
		oLab:setText(Min..":"..Sec)
		
		if 5 >= _TimeRamain and _TimeRamain >= 0 then
			if nPassTime%1000 < 100 then
				local a = CCScaleTo:create(0.08,1.1,1)
				local aR = CCScaleTo:create(0.03,1,1.1)
				_childUI["node"].handle._n:runAction(CCSequence:createWithTwoActions(a,aR))
			end
			--
		end

		
		--倒计时结束
		if 0 > _TimeAll - nPassTime/1000 then
			if _gamestate ~= GAMESTATE_DEFINE.START then
				oLab:setText("")
			end
			oLab.handle.s:stopAllActions()
			_CODE_NextState()
		end
	end

	_CODE_UnitArrive = function(oUnit)
		local unitIndex = _tUnitIDWithGameIndex[oUnit.ID]
		local tInfo = _tGopherList[unitIndex]
		if type(tInfo) == "table" then
			tInfo.state = 3
			tInfo.arrivetime = hApi.gametime()
		end
	end

	_CODE_CountBoomNum = function(itemid)
		if _gamestate == GAMESTATE_DEFINE.START or _gamestate == GAMESTATE_DEFINE.WAITCLEAR then
			if type(itemid) == "number" then
				--print("_CODE_CountBoomNum",itemid)
				local oWorld = hGlobal.WORLD.LastWorldMap
				if oWorld then
					local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
					local nForceMe = oPlayerMe:getforce() --我的势力
					local oHero = oPlayerMe.heros[1]
					if oHero then
						local itemSkillT = oHero.data.itemSkillT
						if (itemSkillT) then
							for k = 1, #itemSkillT, 1 do
								local activeItemId = itemSkillT[k].activeItemId --主动技能的id
								if (activeItemId == itemid) then --找到了
									_CountBoom = _CountBoom + 1
									print("_CountBoom",_CountBoom)
								end
							end
						end
					end
				end
			end
		end
	end

	_CODE_CreateInfoMsgbox = function()
		local dsnum = 1
		local unit_score = 1
		local unitds_score = 2
		local tDefine = hVar.GameGopherDiffDefine[_ChooseDiff]
		if tDefine then
			dsnum = tDefine.unit_ds_num
			if tDefine.rule then
				unit_score = tDefine.rule.unit_score
				unitds_score = tDefine.rule.unitds_score
			end
		end

		local score = (_CountKill or 0) * unit_score + (_CountKillDSUnit or 0) * unitds_score
		local maxscore = (_nMaxUnit - dsnum) * unit_score + dsnum * unitds_score

		local showstr = hVar.tab_string["gophernoreward"]
		if _ChooseDiff == 1 then
			showstr = hVar.tab_string["gophertestplay"]
		end
		local strText = string.format(showstr,score,maxscore)
			
		hGlobal.UI.MsgBox(strText, {
			textSize = 26,
			textFont = hVar.FONTC,
			style = "normal2",
			ok = function()
				_CODE_NextState()
			end,
		})
	end

	hGlobal.event:listen("LocalEvent_GetGameGopherReward_fail", "_GopherBoomGame",function()
		_gamestate = GAMESTATE_DEFINE.END
		_CODE_NextState()
	end)

	hGlobal.event:listen("LocalEvent_GetGameGopherReward", "_GopherBoomGame",function(tRewardResult)
		if _frm and _frm.data.show == 1 then
			_CODE_CreateAwardUnit(tRewardResult)
			_gamestate = GAMESTATE_DEFINE.END
			if _ChooseDiff == 1 then
				_CODE_CreateInfoMsgbox()
			else
				if #tRewardResult == 0 then
					_CODE_CreateInfoMsgbox()
					--_CODE_NextState()
				end
			end
		end
	end)

	hGlobal.event:listen("LocalEvent_refreshafterSpinScreen", "_GopherBoomGame",function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		if _frm and _frm.data.show == 1 and oWorld then
			if oWorld.data.lockscreen == 1 then
				hGlobal.event:event("LocalEvent_ShowControlBtn",1)
			end
		end
	end)
	
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(diff)
		hGlobal.event:event("clearGotoPlayfrm")
		_CODE_ClearFunc()
		local canPlay = _CODE_GetGameDate()
		if canPlay then
			_ChooseDiff = diff
			_nMaxUnit = LuaGetGameGopherUnitMaxNum(_ChooseDiff)
			_CODE_NextState()
		end
	end)
end