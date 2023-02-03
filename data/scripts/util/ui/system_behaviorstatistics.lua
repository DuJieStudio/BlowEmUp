BehaviorStatistics = {}
BehaviorStatistics.ShowTest = 0
BehaviorStatistics.Init = function()
	BehaviorStatistics.Clear()
	if BehaviorStatistics.data == nil then
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			local mapname = oWorld.data.map
			local nMapDifficulty = oWorld.data.MapDifficulty
			local tMapInfo = hVar.MAP_INFO[mapname]
			if type(tMapInfo) == "table" then
				local nUid = tMapInfo.uniqueID
				local realId = (nMapDifficulty + 1) * 10000 + nUid
				local BehaviorIdList = hVar.PlayerBehaviorList.Map[realId]
				print("BehaviorStatistics.Init",mapname,nMapDifficulty,nUid,realId)
				if BehaviorIdList then
					print("success")
					BehaviorStatistics.data = {}
					BehaviorStatistics.data.mapRid = realId
					BehaviorStatistics.ReadBehavior(BehaviorIdList)
					BehaviorStatistics.AddMapEvent()
					BehaviorStatistics.AssociationTarget(oWorld)
					--进入地图
					local behaviorId = realId * 10000 + 9000
					print("addbehaviorId",behaviorId)
					LuaAddBehaviorID(behaviorId)
					if BehaviorStatistics.ShowTest == 1 then
						BehaviorStatistics.CreateEditorPanel(oWorld)
						BehaviorStatistics.CreateEditorFrm()
					end
				else
					print("fail")
				end
			end
		end
	end
end

BehaviorStatistics.Reload = function()
	local parent = BehaviorStatistics.data.parent
	parent:getParent():removeChild(parent,true)
	BehaviorStatistics.Clear()
	hApi.LoadLua("tabs/tab_mapbehavior")
	BehaviorStatistics.Init()
end

BehaviorStatistics.Clear = function()
	BehaviorStatistics.data = nil
	if hGlobal.UI.BehaviorStatisticsFrm then
		hGlobal.UI.BehaviorStatisticsFrm:del()
		hGlobal.UI.BehaviorStatisticsFrm = nil
	end
	BehaviorStatistics.ClearMapEvent()
end

BehaviorStatistics.ShowEditor = function()
	if BehaviorStatistics and type(BehaviorStatistics.data) == "table" then
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			BehaviorStatistics.ShowTest = 1
			BehaviorStatistics.CreateEditorPanel(oWorld)
			BehaviorStatistics.CreateEditorFrm()
		end
	end
end

BehaviorStatistics.CloseEditor = function()
	hGlobal.event:event("LocalEvent_CloseBehaviorStatistics")
	if BehaviorStatistics.data then
		BehaviorStatistics.ShowTest = 0
		BehaviorStatistics.data.childList = {}
		local pNodeC = BehaviorStatistics.data.parent
		pNodeC:getParent():removeChild(pNodeC,true)
	end
end

BehaviorStatistics.RestartGame = function(bFlag)
	if type(BehaviorStatistics.data) == "table" then
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			local mapname = oWorld.data.map
			local nMapDifficulty = oWorld.data.MapDifficulty

			if bFlag then
				BehaviorStatistics.ClearMapBehaviorStatistics()
			end

			BehaviorStatistics.Clear()
			hGlobal.event:event("LocalEvent_CloseBehaviorStatistics")

			local __MAPDIFF = 0
			local __MAPMODE = hVar.MAP_TD_TYPE.NORMAL
			hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
			xlScene_LoadMap(g_world, mapname,nMapDifficulty,__MAPMODE)
		end
	end
end

BehaviorStatistics.ClearMapBehaviorStatistics = function()
	local clearlist = {}
	for i = 1,#BehaviorStatistics.data.InfoIdx do
		local id = BehaviorStatistics.data.InfoIdx[i]

		clearlist[id] = 1
	end
	
	LuaDelBeviorByList(clearlist)
	local keyList = {"log"}
	LuaSavePlayerData_Android_Upload(keyList, "清理行为统计")
end

BehaviorStatistics.ReadBehavior = function(BehaviorIdList)
	BehaviorStatistics.data.Info = {}		--行为统计总信息
	BehaviorStatistics.data.InfoIdx = {}		--行为统计序号
	BehaviorStatistics.data.KillEvent = {}		--击杀事件
	BehaviorStatistics.data.SourceEvent = {}	--资源事件
	BehaviorStatistics.data.UseTacticsEvent = {}	--使用战术卡事件
	BehaviorStatistics.data.AreaEvent = {}		--区域事件
	BehaviorStatistics.data.AssociationTarget = {}	--目标单位
	BehaviorStatistics.data.AssociationUnitIdlist = {} --击杀事件关联单位id列表(优化索检)
	local killevent = BehaviorStatistics.data.KillEvent
	local sourceevent = BehaviorStatistics.data.SourceEvent
	local usetacticsevent = BehaviorStatistics.data.UseTacticsEvent
	local areaevent = BehaviorStatistics.data.AreaEvent
	local tIgnoreList = {}
	local tlist = LuaGetBehaviorList()
	if type(tlist) == "table" then
		for i = 1,#tlist do
			local id = tlist[i][1]
			tIgnoreList[id] = 1
		end
	end
	for i = 1,#BehaviorIdList do
		local id = BehaviorIdList[i]
		local info = hVar.tab_mapbehavior[id]
		if type(info) == "table" then
			BehaviorStatistics.data.Info[id] = {
				count = 0,
				times = info.times or 1,
			}
			BehaviorStatistics.data.InfoIdx[i] = id
			local shouldIgnore = 0
			if tIgnoreList[id] == 1 then
				shouldIgnore = 1
				BehaviorStatistics.data.Info[id].clear = 1
				BehaviorStatistics.data.Info[id].count = BehaviorStatistics.data.Info[id].times
			end
			local behaviorname = ""
			if info.sType == "killunit" then --击杀事件
				killevent[id] = {unitlist = {}}
				behaviorname = "击杀"
				local unitidlist = info.unitidlist
				if type(unitidlist) == "table" then
					for z = 1,#unitidlist do
						local unitid = unitidlist[z]
						behaviorname = behaviorname .. unitid
						killevent[id].unitlist[unitid] = 1
						local num = 0
						if BehaviorStatistics.data.AssociationUnitIdlist[unitid] == nil then
							BehaviorStatistics.data.AssociationUnitIdlist[unitid] = {}
						else
							num = #BehaviorStatistics.data.AssociationUnitIdlist[unitid]
						end
						BehaviorStatistics.data.AssociationUnitIdlist[unitid][num + 1] = id
						if z ~= #unitidlist then
							behaviorname = behaviorname .. "|"
						end
					end
				elseif unitidlist == -1 then
					killevent[id].unitlist = -1
					behaviorname = "击杀任意单位"
				end
			elseif info.sType == "usetactics" then --使用战术卡
				behaviorname = "使用战术卡"
				usetacticsevent[id] = {}
				local tacticsidlist = info.tacticsidlist
				if type(tacticsidlist) == "table" then
					for z = 1,#tacticsidlist do
						local tacticsid = tacticsidlist[z]
						usetacticsevent[id][tacticsid] = 1
						behaviorname = behaviorname .. tacticsid
						if z ~= #tacticsidlist then
							behaviorname = behaviorname .. "|"
						end
					end
				elseif tacticsidlist == -1 then
					behaviorname = "使用任意战术卡"
				end
			elseif info.sType == "getsource" then
				behaviorname = "获取资源"
				sourceevent[id] = {}
				local list = info.list
				if type(list) == "table" then
					for z = 1,#list do
						local s = list[z]
						sourceevent[id][s] = 1
						if s == "scientist" then
							behaviorname = behaviorname .. "科学家"
						end
						if z ~= #list then
							behaviorname = behaviorname .. "|"
						end
					end
				else
					behaviorname = behaviorname .. "未识别"
				end
			elseif info.sType == "enterarea" then
				behaviorname = "进入区域"
				areaevent[id] = {}
			end
			if shouldIgnore == 1 then
				BehaviorStatistics.data.KillEvent[id] = nil
				BehaviorStatistics.data.SourceEvent[id] = nil
				BehaviorStatistics.data.UseTacticsEvent[id] = nil
				BehaviorStatistics.data.AreaEvent[id] = nil
			end
			BehaviorStatistics.data.Info[id].str = behaviorname
			local tInArea = info.inArea
			if type(tInArea) == "table" then
				BehaviorStatistics.data.Info[id].DrawArea = {}
				for i = 1,#tInArea do
					local tArea = tInArea[i]
					BehaviorStatistics.data.Info[id].DrawArea[i] = {
						x = tArea[1],
						y = tArea[2],
						w = tArea[3],
						h = tArea[4],
					}
				end
			end
		end
	end
end

local _checkinarea = function(BehaviorId,u)
	--print("_checkinarea")
	local ox, oy = hApi.chaGetPos(u.handle) --战车坐标
	local tInfo = BehaviorStatistics.data.Info[BehaviorId]
	if type(tInfo) == "table" then
		local DrawArea = tInfo.DrawArea
		if type(DrawArea) == "table" then
			for i = 1,#DrawArea do
				local area = DrawArea[i]
				local rect = {area.x - area.w/2,area.y + area.h/2,area.w,area.h}
				if hApi.IsInBox(ox, oy,rect) then	--在长方形那
					return true
				end
			end
		else
			print("aaaaa",u.data.id)
			return true
		end
	end
	return false
end

local _drawBehaviorId = function(u)
	if BehaviorStatistics.ShowTest ~= 1 then
		return
	end
	if u then--防止死亡清理
		print("_drawBehaviorId",u.data.id)
		local behaviorList = u.localdata.behaviorList
		if type(behaviorList) == "table" then
			for BehaviorId in pairs(behaviorList) do
				local num = #BehaviorStatistics.data.childList[BehaviorId]
				u.chaUI["BehaviorId"..BehaviorId] = hUI.label:new({
					parent = u.handle._tn,
					font = "numWhite",
					align = "MC",
					size = 12,
					text = "["..BehaviorId.."]",
					RGB = {255,200,0},
				})
				u.chaUI["BehaviorId"..BehaviorId].handle._n:setVisible(false)
				BehaviorStatistics.data.childList[BehaviorId][num + 1] = {"unit_bid",u}
			end
		end
	end
end

local _AssociationTarget = function(associationlist,u,bDrawId)
	local unitid = u.data.id
	local nflag = 0
	if type(associationlist[unitid]) == "table" then
		for i = 1,#associationlist[unitid] do
			local BehaviorId = associationlist[unitid][i]
			local bflag = _checkinarea(BehaviorId,u)
			if bflag then
				if u.localdata.behaviorList == nil then
					u.localdata.behaviorList = {}
				end
				u.localdata.behaviorList[BehaviorId] = 1
				nflag = 1
			end
		end
		if nflag == 1 then
			--print("unitid",unitid)
			--table_print(u.localdata.behaviorList)
			local target = BehaviorStatistics.data.AssociationTarget
			target[#target + 1] = u
			if bDrawId then
				_drawBehaviorId(u)
			end
			--BehaviorStatistics.data.AssociationTarget = {}
		end
	end
end

BehaviorStatistics.AssociationTarget = function(oWorld)
	local associationlist = BehaviorStatistics.data.AssociationUnitIdlist
	oWorld:enumunit(function(u)
		_AssociationTarget(associationlist,u)
	end)
end

BehaviorStatistics.CreateEditorPanel = function(oWorld)
	local h = oWorld.handle
	local worldLayer = h.worldLayer
	if worldLayer then
		local pNodeC = CCNode:create()
		local w,h = oWorld.data.sizeW,oWorld.data.sizeH
		pNodeC:setPosition(0, 0)
		worldLayer:addChild(pNodeC,1000000)

		BehaviorStatistics.data.parent = pNodeC
		BehaviorStatistics.data.childList = {}

		BehaviorStatistics.data.childList["btn_node"] = hUI.button:new({
			parent = pNodeC,
			model = "misc/button_null.png",
			--model = "misc/mask.png",
			align = "LT",
			w = w,  
			h = h,
		})

		for i = 1,#BehaviorStatistics.data.InfoIdx do
			local BehaviorId = BehaviorStatistics.data.InfoIdx[i]
			BehaviorStatistics.data.childList[BehaviorId] = {}
			local num = 1
			local info = BehaviorStatistics.data.Info[BehaviorId]
			local DrawArea = info.DrawArea
			if type(DrawArea) == "table" then
				for i = 1,#DrawArea do
					local tArea = DrawArea[i]
					local img = hUI.image:new({
						parent = pNodeC,
						model = "misc/mask.png",
						x = tArea.x,
						y = -tArea.y,
						w = tArea.w, 
						h = tArea.h,
						z = 1,
					})
					img.handle._n:setVisible(false)
					img.handle.s:setOpacity(180)
					img.handle.s:setColor(ccc3(128, 128, 128))
					BehaviorStatistics.data.childList[BehaviorId][num] = {"area_img",img}
					num = num + 1

					local areaname = "area"..BehaviorId.."_"..i
					local lab = hUI.label:new({
						parent = pNodeC,
						x = tArea.x,
						y = -tArea.y,
						font = hVar.FONTC,
						size = 28,
						text = areaname,
						align = "MC",
						z = 2,
					})
					lab.handle._n:setVisible(false)
					BehaviorStatistics.data.childList[BehaviorId][num] = {"area_bid",lab}
					num = num + 1
				end
			end
		end

		local target = BehaviorStatistics.data.AssociationTarget
		for z = 1,#target do
			local u = target[z]
			if u then
				_drawBehaviorId(u)
			end
		end
		--BehaviorStatistics.data.AssociationTarget = {}
	end
end

BehaviorStatistics.CreateEditorFrm = function()
	hGlobal.UI.InitBehaviorStatisticsFrm("include")
	hGlobal.event:event("LocalEvent_ShowBehaviorStatisticsFrm")
end

BehaviorStatistics.Event_GameEnd = function(bFlag)
	print("BehaviorStatistics.Event_GameEnd",bFlag)
	if BehaviorStatistics and BehaviorStatistics.data then
		local tData = BehaviorStatistics.data
		local mapRid = BehaviorStatistics.data.mapRid
	
		if bFlag then
			--通关
			local behaviorId = mapRid * 10000 + 9002
			print("addbehaviorId",behaviorId)
			LuaAddBehaviorID(behaviorId)
		else
			--失败
			local behaviorId = mapRid * 10000 + 9001
			print("addbehaviorId",behaviorId)
			LuaAddBehaviorID(behaviorId)
		end
	end
	--游戏结束就清理
	BehaviorStatistics.Clear()
end

BehaviorStatistics.AddMapEvent = function()
	hGlobal.event:listen("LocalEvent_TD_NextWave","_BehaviorStatistics",BehaviorStatistics.NextWave)
	hGlobal.event:listen("Event_UnitDead", "_BehaviorStatistics",BehaviorStatistics.UnitDead)
	hGlobal.event:listen("Event_UnitBorn","_BehaviorStatistics",BehaviorStatistics.UnitBorn)
	hGlobal.event:listen("Event_GetSource","_BehaviorStatistics",BehaviorStatistics.GetSource)
	hGlobal.event:listen("Event_UseTactics","_BehaviorStatistics",BehaviorStatistics.UseTactics)
	hGlobal.event:listen("Event_GameEnd","_BehaviorStatistics",BehaviorStatistics.Event_GameEnd)
	hGlobal.event:listen("Event_TurnToMap","_BehaviorStatistics",BehaviorStatistics.Event_TurnToMap)
	hApi.addTimerForever("BehaviorStatistics_UnitMove",hVar.TIMER_MODE.GAMETIME,5,BehaviorStatistics.UnitMove)
end

BehaviorStatistics.ClearMapEvent = function()
	hGlobal.event:listen("LocalEvent_TD_NextWave","_BehaviorStatistics",nil)
	hGlobal.event:listen("Event_UnitDead", "_BehaviorStatistics",nil)
	hGlobal.event:listen("Event_UnitBorn","_BehaviorStatistics",nil)
	hGlobal.event:listen("Event_GetSource","_BehaviorStatistics",nil)
	hGlobal.event:listen("Event_UseTactics","_BehaviorStatistics",nil)
	hGlobal.event:listen("Event_GameEnd","_BehaviorStatistics",nil)
	hGlobal.event:listen("Event_TurnToMap","_BehaviorStatistics",nil)
	hApi.clearTimer("BehaviorStatistics_UnitMove")
end

BehaviorStatistics.NextWave = function()
	--多次加载怪物  进行监听
	--print("BehaviorStatistics.NextWave")
end

BehaviorStatistics.Event_TurnToMap = function(sToMap,nToMapMode)
	local oWorld = hGlobal.WORLD.LastWorldMap
	if oWorld then
		local mapname = oWorld.data.map
		--只在新手引导关统计
		if mapname == hVar.GuideMap then
			if sToMap == hVar.MainBase then
				--回到基地
				--local behaviorId = hVar.PlayerBehaviorList[20005]
				--LuaAddBehaviorID(behaviorId)
			else
				local behaviorId = hVar.PlayerBehaviorList[20004]
				LuaAddBehaviorID(behaviorId)
			end
		end
	end
	hGlobal.event:event("Event_GameEnd",true)
end

BehaviorStatistics.UnitBorn = function(oUnit)
	--print("BehaviorStatistics.UnitBorn",oUnit.data.id)
	local associationlist = BehaviorStatistics.data.AssociationUnitIdlist
	_AssociationTarget(associationlist,oUnit,true)
end

BehaviorStatistics.CheckClear = function(tBehaviorIdList)
	for i = 1,#tBehaviorIdList do
		local behaviorId = tBehaviorIdList[i]
		local Info = BehaviorStatistics.data.Info[behaviorId]
		if Info then
			--print("CheckClear",behaviorId,i)
			if Info.count >= Info.times then
				if Info.clear ~= 1 then
					LuaAddBehaviorID(behaviorId, true)
				end
				Info.clear = 1
			end
		end
	end
end

BehaviorStatistics.UnitMove = function()
	local oWorld = hGlobal.WORLD.LastWorldMap
	if oWorld then
		local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
		local nForceMe = oPlayerMe:getforce() --我的势力
		local oHero = oPlayerMe.heros[1]
		if oHero then
			local oUnit = oHero:getunit()
			if oUnit then
				local tBehaviorIdList = {}
				local areaevent = BehaviorStatistics.data.AreaEvent
				local ox, oy = hApi.chaGetPos(oUnit.handle) --战车坐标
				for behaviorId,event in pairs(areaevent) do
					local Info = BehaviorStatistics.data.Info[behaviorId]
					if Info.clear ~= 1 then
						local DrawArea = Info.DrawArea
						if type(DrawArea) == "table" then
							for i = 1,#DrawArea do
								local area = DrawArea[i]
								local rect = {area.x - area.w/2,area.y + area.h/2,area.w,area.h}
								if hApi.IsInBox(ox, oy,rect) then	--在长方形那
									Info.count = Info.count + 1
									tBehaviorIdList[#tBehaviorIdList + 1] = behaviorId
									break
								end
							end
						end
					end
				end
				--检测是否完成
				BehaviorStatistics.CheckClear(tBehaviorIdList)
				--刷新界面
				hGlobal.event:event("LocalEvent_UpdateBehaviorStatistics",tBehaviorIdList)
			end
		end
	end
end

BehaviorStatistics.GetSource = function(sType,nNum,tParam)
	local tBehaviorIdList = {}
	local sourceevent = BehaviorStatistics.data.SourceEvent
	for behaviorId,event in pairs(sourceevent) do
		local Info = BehaviorStatistics.data.Info[behaviorId]
		if Info.clear ~= 1 then
			if event[sType] == 1 and type(Info) == "table"  then
				Info.count = Info.count + nNum
				tBehaviorIdList[#tBehaviorIdList + 1] = behaviorId
			end
		end
	end
	--检测是否完成
	BehaviorStatistics.CheckClear(tBehaviorIdList)
	--刷新界面
	hGlobal.event:event("LocalEvent_UpdateBehaviorStatistics",tBehaviorIdList)
end

BehaviorStatistics.UseTactics = function(tacticId,tacticsLv,tacticsType)
	print("UseTactics",tacticId,tacticsLv,tacticsType)
	local tBehaviorIdList = {}
	local usetacticsevent = BehaviorStatistics.data.UseTacticsEvent
	for behaviorId,event in pairs(usetacticsevent) do
		local Info = BehaviorStatistics.data.Info[behaviorId]
		if Info.clear ~= 1 then
			if event[tacticId] == 1 and type(Info) == "table"  then
				Info.count = Info.count + 1
				tBehaviorIdList[#tBehaviorIdList + 1] = behaviorId
			end
		end
	end
	--检测是否完成
	BehaviorStatistics.CheckClear(tBehaviorIdList)
	--刷新界面
	hGlobal.event:event("LocalEvent_UpdateBehaviorStatistics",tBehaviorIdList)
end

BehaviorStatistics.UnitDead = function(oUnit, nOperate, oKillerUnit, nId, vParam, oKillerSide, oKillerPos)
	--print("UnitDead",oUnit.data.id)
	local tBehaviorIdList = {}
	local killevent = BehaviorStatistics.data.KillEvent
	local nUnitId = oUnit.data.id
	local localdata = oUnit.localdata
	for behaviorId,event in pairs(killevent) do
		--print("behaviorId",behaviorId)
		local Info = BehaviorStatistics.data.Info[behaviorId]
		if Info.clear ~= 1 then
			local unitlist = event.unitlist
			if type(Info) == "table" then
				--print(unitlist)
				if unitlist == -1 then
					--任意单位  根据额外击杀条件判断
				elseif type(unitlist) == "table" then
					--table_print(unitlist)
					if unitlist[nUnitId] == 1 and localdata.behaviorList and localdata.behaviorList[behaviorId] == 1 then
						Info.count = Info.count + 1
						tBehaviorIdList[#tBehaviorIdList + 1] = behaviorId
					end
				end
			end
		end
	end
	--检测是否完成
	BehaviorStatistics.CheckClear(tBehaviorIdList)
	--刷新界面
	hGlobal.event:event("LocalEvent_UpdateBehaviorStatistics",tBehaviorIdList)
end