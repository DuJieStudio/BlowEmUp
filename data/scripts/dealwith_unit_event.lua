--事件单位触发类型
hVar.EnumEventUnitTriggerType = {
	NEAR = 1,	--靠近
}

--单位事件定义
hVar.EventUnitDefine = {
	[5151] = {
		triggerType = hVar.EnumEventUnitTriggerType.NEAR,
		event = "LocalEvent_InMap_Showskillfrm",
		count = -1,		--进入范围后只触发一次
		distype = 2,		--类型2计算到达目标的格数
		triggerDis = 4,		--4步
		leavePos = {0,128},
	},
	
	--加血台子
	[5186] = {
		triggerType = hVar.EnumEventUnitTriggerType.NEAR,
		event = "LocalEvent_ShowUseHpRecoverBtn", --"LocalEvent_InMap_ShowAddPetHp",
		count = 1,		--进入范围后无限触发
		distype = 1,		--类型1距离目标的直线像素
		triggerDis = 150,	--150像素
		eventtype = 2,
		leaveEvent = "LocalEvent_CloseSelectHpRecoverFrm", --"clearAddPetHpfrm",
	},
	
	--雕像
	[5171] = {
		triggerType = hVar.EnumEventUnitTriggerType.NEAR,
		event = "LocalEvent_ShowUseAuraBtn",
		count = 1,		--进入范围后无限触发
		distype = 1,		--类型1距离目标的直线像素
		triggerDis = 150,	--150像素
		eventtype = 2,
		leaveEvent = "LocalEvent_CloseSelectAuraFrm",
	},
	
	--雕像(vip5附赠雕像)
	[13018] = {
		triggerType = hVar.EnumEventUnitTriggerType.NEAR,
		event = "LocalEvent_ShowUseAuraBtn",
		count = 1,		--进入范围后无限触发(初始无次数)
		distype = 1,		--类型1距离目标的直线像素
		triggerDis = 150,	--150像素
		eventtype = 2,
		leaveEvent = "LocalEvent_CloseSelectAuraFrm",
	},
	
	--雕像2(塔防地图)
	[17002] = {
		triggerType = hVar.EnumEventUnitTriggerType.NEAR,
		event = "LocalEvent_ShowUseAuraBtn",
		count = 0,		--进入范围后无限触发(初始无次数)
		distype = 1,		--类型1距离目标的直线像素
		triggerDis = 150,	--150像素
		eventtype = 2,
		leaveEvent = "LocalEvent_CloseSelectAuraFrm",
	},
	
	--雕像3(塔防地图)
	[17019] = {
		triggerType = hVar.EnumEventUnitTriggerType.NEAR,
		event = "LocalEvent_ShowUseAuraBtn",
		count = 0,		--进入范围后无限触发(初始无次数)
		distype = 1,		--类型1距离目标的直线像素
		triggerDis = 150,	--150像素
		eventtype = 2,
		leaveEvent = "LocalEvent_CloseSelectAuraFrm",
	},
	
	--雕像2(塔防地图2-前哨阵地)
	[17204] = {
		triggerType = hVar.EnumEventUnitTriggerType.NEAR,
		event = "LocalEvent_ShowUseAuraBtn",
		count = 1,		--进入范围后无限触发(初始无次数)
		distype = 1,		--类型1距离目标的直线像素
		triggerDis = 150,	--150像素
		eventtype = 2,
		leaveEvent = "LocalEvent_CloseSelectAuraFrm",
	},
	
	--雕像3(塔防地图2-前哨阵地)
	[17205] = {
		triggerType = hVar.EnumEventUnitTriggerType.NEAR,
		event = "LocalEvent_ShowUseAuraBtn",
		count = 1,		--进入范围后无限触发(初始无次数)
		distype = 1,		--类型1距离目标的直线像素
		triggerDis = 150,	--150像素
		eventtype = 2,
		leaveEvent = "LocalEvent_CloseSelectAuraFrm",
	},
	
	--雕像2(随机迷宫)
	[13006] = {
		triggerType = hVar.EnumEventUnitTriggerType.NEAR,
		event = "LocalEvent_ShowUseAuraBtn",
		count = 1,		--进入范围后无限触发(初始无次数)
		distype = 1,		--类型1距离目标的直线像素
		triggerDis = 150,	--150像素
		eventtype = 2,
		leaveEvent = "LocalEvent_CloseSelectAuraFrm",
	},
	
	--结算点
	[5197] = {
		triggerType = hVar.EnumEventUnitTriggerType.NEAR,
		event = "LocalEvent_ShowSettlementBtn",
		count = 1,		--进入范围后无限触发
		distype = 1,		--类型1距离目标的直线像素
		triggerDis = 150,	--150像素
		eventtype = 2,
		leaveEvent = "LocalEvent_CloseSelectSettlementFrm",
	},
	
	--宠物NPC对话
	[15504] = {
		triggerType = hVar.EnumEventUnitTriggerType.NEAR,
		event = "LocalEvent_ShowUsePetBtn",
		count = 1,		--进入范围后无限触发
		distype = 1,		--类型1距离目标的直线像素
		triggerDis = 150,	--150像素
		eventtype = 2,
		leaveEvent = "LocalEvent_CloseSelectPetFrm",
	},
	
	--基地战术卡问号
	[11029] = {
		triggerType = hVar.EnumEventUnitTriggerType.NEAR,
		event = "LocalEvent_ShowBaseNPCBtn",
		count = -1,		--进入范围后无限触发
		distype = 1,		--类型1距离目标的直线像素
		triggerDis = 150,	--150像素
		eventtype = 2,
		leaveEvent = "LocalEvent_CloseSelectBaseNPCFrm",
		code = function(oUnit) --点击事件
			hGlobal.event:event("LocalEvent_Barrage_Pause")  --关闭弹幕
			--hGlobal.event:event("LocalEvent_Barrage_Clean")  --关闭弹幕
			--hGlobal.event:event("LocalEvent_Comment_Open","",hVar.CommentTargetTypeDefine.TACTICS_ALL,1,0)  --类型 id  弹幕起始号
			hGlobal.event:event("LocalEvent_DoCommentProcess",{})
		end,
	},

	--精炼厂问号
	[11000] = {
		triggerType = hVar.EnumEventUnitTriggerType.NEAR,
		event = "LocalEvent_ShowBaseNPCBtn",
		count = -1,		--进入范围后无限触发
		distype = 1,		--类型1距离目标的直线像素
		triggerDis = 200,	--150像素
		eventtype = 2,
		leaveEvent = "LocalEvent_CloseSelectBaseNPCFrm",
		code = function(oUnit) --点击事件
			hGlobal.event:event("LocalEvent_Barrage_Pause")  --关闭弹幕
			--hGlobal.event:event("LocalEvent_Barrage_Clean")  --关闭弹幕
			--hGlobal.event:event("LocalEvent_Comment_Open","",hVar.CommentTargetTypeDefine.TACTICS_ALL,1,0)  --类型 id  弹幕起始号
			CommentManage.ReadyComment(hVar.CommentTargetTypeDefine.REFINERY)
			hGlobal.event:event("LocalEvent_DoCommentProcess",{})
		end,
	},

	[11066] = {
		triggerType = hVar.EnumEventUnitTriggerType.NEAR,
		event = "LocalEvent_ShowBaseNPCBtn",
		count = -1,		--进入范围后无限触发
		distype = 1,		--类型1距离目标的直线像素
		triggerDis = 200,	--150像素
		eventtype = 2,
		leaveEvent = "LocalEvent_CloseSelectBaseNPCFrm",
		code = function(oUnit) --点击事件
			hGlobal.event:event("LocalEvent_Barrage_Pause")  --关闭弹幕
			--hGlobal.event:event("LocalEvent_Barrage_Clean")  --关闭弹幕
			--hGlobal.event:event("LocalEvent_Comment_Open","",hVar.CommentTargetTypeDefine.TACTICS_ALL,1,0)  --类型 id  弹幕起始号
			CommentManage.ReadyComment(hVar.CommentTargetTypeDefine.WEAPON_ALL)
			hGlobal.event:event("LocalEvent_DoCommentProcess",{})
		end,
	},

	--兵营(yxys_yoda_02)
	[12232] = {
		triggerType = hVar.EnumEventUnitTriggerType.NEAR,
		event = "LocalEvent_ShowUseAuraBtn",
		count = 9999,		--进入范围后无限触发(初始无次数)
		distype = 1,		--类型1距离目标的直线像素
		triggerDis = 150,	--150像素
		eventtype = 2,
		leaveEvent = "LocalEvent_CloseSelectAuraFrm",
	},
	--兵营2(yxys_yoda_02)
	[12245] = {
		triggerType = hVar.EnumEventUnitTriggerType.NEAR,
		event = "LocalEvent_ShowUseAuraBtn",
		count = 9999,		--进入范围后无限触发(初始无次数)
		distype = 1,		--类型1距离目标的直线像素
		triggerDis = 150,	--150像素
		eventtype = 2,
		leaveEvent = "LocalEvent_CloseSelectAuraFrm",
	},
}

local _count = 0
local _countMax = 3

--循环检测单位事件
CheckUnitEventLoop = function()
	local w = hGlobal.WORLD.LastWorldMap
	
	if (not w) then
		return
	end
	
	local mapInfo = w.data.tdMapInfo
	
	if not w or not mapInfo then
		return
	end
	
	--游戏暂停或结束，直接退出
	if mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE then
		return
	end
	
	--如果回合还没开始，退出
	if mapInfo.wave <= 0 then
		return
	end

	--减少判断频率
	_count = _count%_countMax + 1
	if _count ~= _countMax then
		return
	end


	for i = 1,#mapInfo.eventUnit do
		local tInfo = mapInfo.eventUnit[i]
		local nId = tInfo[1]		--单位ID
		local oUnit = tInfo[2]		--单位
		local nCount = tInfo[3]		--剩余触发次数
		local tTab_EventUnit = hVar.EventUnitDefine[nId]
		if type(nCount) == "number" and nCount ~= 0 and type(tTab_EventUnit) == "table" then
			local triggerType = tTab_EventUnit.triggerType
			if triggerType == hVar.EnumEventUnitTriggerType.NEAR then
				Code_Trigger_Near_Event(i)
			end
		end
	end
end

local _Code_GetDistance = function(oUnit1,oUnit2)
	local ux,uy = oUnit1:getXY()
	local toX = oUnit2.data.worldX
	local toY =  oUnit2.data.worldY
	local dx = ux - toX
	local dy = uy - toY
	local dis = math.sqrt(dx * dx + dy * dy)
	return dis
end

local _GetDistance = function(oUnit1,oUnit2,distype)
	if distype == 2 then
		return hApi.GetDistanceByPathCount(oUnit1,oUnit2)
	else
		return _Code_GetDistance(oUnit1,oUnit2)
	end
end

--触发解禁事件
Code_Trigger_Near_Event = function(index)
	local w = hGlobal.WORLD.LastWorldMap
	if w.data.keypadEnabled == false then
		return
	end
	local mapInfo = w.data.tdMapInfo
	local oPlayerMe = w:GetPlayerMe() --我的玩家对象
	local nForceMe = oPlayerMe:getforce() --我的势力
	local oOwnUnit
	if type(oPlayerMe.heros) == "table" then
		local oHero = oPlayerMe.heros[1]
		if oHero then
			oOwnUnit = oHero:getunit()
		end
	end
	local tInfo = mapInfo.eventUnit[index]
	local nId = tInfo[1]		--单位ID
	local oUnit = tInfo[2]		--单位
	local nCount = tInfo[3]		--剩余触发次数
	local tTab_EventUnit = hVar.EventUnitDefine[nId]
	if type(nCount) == "number" and nCount ~= 0 and type(tTab_EventUnit) == "table" and oOwnUnit and oUnit and oUnit.data.IsHide ~= 1 then
		--local dis = _Code_GetDistance(oOwnUnit,oUnit)
		local dis = _GetDistance(oOwnUnit,oUnit,tTab_EventUnit.distype)
		local triggerDis = tTab_EventUnit.triggerDis
		if dis > 0 and dis < triggerDis then
			local sEvent = tTab_EventUnit.event
			local tLeavePos = tTab_EventUnit.leavePos
			local eventtype = tTab_EventUnit.eventtype
			if type(sEvent) == "string" then
				if eventtype ~= 2 then
					if tInfo[3] > 0 then
						tInfo[3] = tInfo[3] - 1
					end
				end
				hGlobal.event:event(sEvent,index,oOwnUnit,oUnit,tLeavePos)
			end
		else
			if tTab_EventUnit.leaveEvent then
				hGlobal.event:event(tTab_EventUnit.leaveEvent,index)
			end
		end
	end
end



----------------------------------------------------------------------------------------
--靠近雕像（持续触发）
--多个雕像都会触发
hGlobal.event:listen("LocalEvent_ShowUseAuraBtn","__UnitEvent",function(index,oUnit1,oUnit2)
	local w = hGlobal.WORLD.LastWorldMap
	local mapInfo = w.data.tdMapInfo
	local tInfo = mapInfo.eventUnit[index]
	if tInfo then
		if type(tInfo.list) ~= "table" then
			local id = oUnit2.data.id
			local groupindex = hVar.UnitAuraGroupDefine[id] or 1
			tInfo.list = hVar.GetRandAuraList(groupindex)
		end
		
		--无效的目标
		if (oUnit2.ID == 0) then
			return
		end
		
		--local tCallback = {"LocalEvent_UseAuraBack",{index,oUnit2}}
		--hGlobal.event:event("LocalEvent_ShowSelectAuraFrm",index,tInfo.list,tCallback)
		--print("靠近雕像1")
		--print(oUnit2.data.name)
		--读取单位身上的技能
		local td_upgrade = oUnit2.td_upgrade
		if (type(td_upgrade) == "table") then
			local castSkill = td_upgrade.castSkill
			if (type(castSkill) == "table") then
				local order = castSkill.order
				if (type(order) == "table") then
					local skillId = order[1]
					if (type(skillId) == "number") then
						local skillObj = oUnit2:getskill(skillId)
						if skillObj then
							local lv = skillObj[2]
							local count = skillObj[4]
							local cd = skillObj[5]
							local lasttime = skillObj[6]
							
							if (count > 0) then
								local panel = hGlobal.O["__WM__TargetOperatePanel"]
								if (panel == nil) then
									hGlobal.event:event("LocalEvent_HitOnTarget",w,oUnit2,worldX,worldY)
									local panel = hGlobal.O["__WM__TargetOperatePanel"]
									local _childUI = panel.childUI
									if _childUI and _childUI["actions"] then
										local self = _childUI["actions"]
										self.data.oUnit2 = oUnit2
										self.data.index = index
										
										--临时存储
										skillObj[7] = index
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)

--远离很多雕像（持续触发）
--多个雕像都会触发
hGlobal.event:listen("LocalEvent_CloseSelectAuraFrm","__UnitEvent",function(index)
	--print("远离某个雕像2")
	local w = hGlobal.WORLD.LastWorldMap
	local mapInfo = w.data.tdMapInfo
	
	local panel = hGlobal.O["__WM__TargetOperatePanel"]
	if (panel ~= nil) then
		local _childUI = panel.childUI
		if _childUI and _childUI["actions"] then
			local self = _childUI["actions"]
			local oUnit2 = self.data.oUnit2
			local nIndex = self.data.index
			
			if (nIndex == index) then
				local tInfo = mapInfo.eventUnit[index]
				if tInfo then
					hGlobal.O:replace("__WM__TargetOperatePanel", nil)
					
					--hGlobal.event:event("LocalEvent_HitOnTarget",w,nil,worldX,worldY)
					--hGlobal.event:event("LocalEvent_UseAuraBack", {index,oUnit2})
				end
			end
		end
	end
end)

--远离指定雕像（使用掉次数）
hGlobal.event:listen("LocalEvent_UseAuraBack","__UnitEvent",function(tParam)
	if type(tParam) == "table" then
		local index = tParam[1]
		local oUnit = tParam[2]
		
		--无效的目标
		if (oUnit.ID == 0) then
			return
		end
		
		local w = hGlobal.WORLD.LastWorldMap
		local mapInfo = w.data.tdMapInfo
		local tInfo = mapInfo.eventUnit[index]
		if type(tInfo) == "table" then
			if tInfo[3] > 0 then
				tInfo[3] = tInfo[3] - 1
			end
			if tInfo[3] == 0 then
				--oUnit:sethide(1)
				oUnit:setanimation("stand2")
			end
			
			--清除抽卡信息
			tInfo.list = nil
			
			--如果在游戏里关闭此界面，恢复暂停
			local mapInfo = w.data.tdMapInfo
			--print(mapInfo.mapState, hVar.MAP_TD_STATE.PAUSE)
			if (mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE) then --当前是暂停状态
				--进入恢复
				w:pause(0)
				mapInfo.mapState = mapInfo.mapLastState
				mapInfo.mapLastState = hVar.MAP_TD_STATE.IDLE
				
				--恢复游戏当前速率
				hGlobal.event:event("LocalEvent_ResumeSpeed")
			end
		end
	end
	hGlobal.event:event("LocalEvent_CloseOpenAuraFrm")
	--hGlobal.event:event("Event_StartPauseSwitch",false)
end)

--关闭雕像
hGlobal.event:listen("LocalEvent_CloseAuraBack", "__UnitEvent", function(tParam)
	if type(tParam) == "table" then
		local index = tParam[1]
		local oUnit2 = tParam[2]
		
		--无效的目标
		if (oUnit2.ID == 0) then
			return
		end
		
		--print(index, oUnit2.data.name)
		
		local w = hGlobal.WORLD.LastWorldMap
		local mapInfo = w.data.tdMapInfo
		local tInfo = mapInfo.eventUnit[index]
		if type(tInfo) == "table" then
			--单位技能可使用次数加1
			local td_upgrade = oUnit2.td_upgrade
			if (type(td_upgrade) == "table") then
				local castSkill = td_upgrade.castSkill
				if (type(castSkill) == "table") then
					local order = castSkill.order
					if (type(order) == "table") then
						local skillId = order[1]
						if (type(skillId) == "number") then
							local skillObj = oUnit2:getskill(skillId)
							if skillObj then
								local lv = skillObj[2]
								local count = skillObj[4]
								local cd = skillObj[5]
								local lasttime = skillObj[6]
								
								skillObj[4] = skillObj[4] + 1
							end
						end
					end
				end
			end
			
			--如果在游戏里关闭此界面，恢复暂停
			local mapInfo = w.data.tdMapInfo
			--print(mapInfo.mapState, hVar.MAP_TD_STATE.PAUSE)
			if (mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE) then --当前是暂停状态
				--进入恢复
				w:pause(0)
				mapInfo.mapState = mapInfo.mapLastState
				mapInfo.mapLastState = hVar.MAP_TD_STATE.IDLE
				
				--恢复游戏当前速率
				hGlobal.event:event("LocalEvent_ResumeSpeed")
			end
		end
	end
end)





----------------------------------------------------------------------------------------
--靠近宠物（持续触发）
--多个宠物都会触发
hGlobal.event:listen("LocalEvent_ShowUsePetBtn","__UnitEvent",function(index,oUnit1,oUnit2)
	local w = hGlobal.WORLD.LastWorldMap
	local mapInfo = w.data.tdMapInfo
	local tInfo = mapInfo.eventUnit[index]
	if tInfo then
		--无效的目标
		if (oUnit2.ID == 0) then
			return
		end
		
		--local tCallback = {"LocalEvent_UseAuraBack",{index,oUnit2}}
		--hGlobal.event:event("LocalEvent_ShowSelectAuraFrm",index,tInfo.list,tCallback)
		--print("靠近雕像1")
		--print(oUnit2.data.name)
		--读取单位身上的技能
		local td_upgrade = oUnit2.td_upgrade
		if (type(td_upgrade) == "table") then
			local castSkill = td_upgrade.castSkill
			if (type(castSkill) == "table") then
				local order = castSkill.order
				if (type(order) == "table") then
					local skillId = order[1]
					if (type(skillId) == "number") then
						local skillObj = oUnit2:getskill(skillId)
						if skillObj then
							local lv = skillObj[2]
							local count = skillObj[4]
							local cd = skillObj[5]
							local lasttime = skillObj[6]
							
							if (count > 0) then
								local panel = hGlobal.O["__WM__TargetOperatePanel"]
								if (panel == nil) then
									hGlobal.event:event("LocalEvent_HitOnTarget",w,oUnit2,worldX,worldY)
									local panel = hGlobal.O["__WM__TargetOperatePanel"]
									local _childUI = panel.childUI
									if _childUI and _childUI["actions"] then
										local self = _childUI["actions"]
										self.data.oUnit2 = oUnit2
										self.data.index = index
										
										--临时存储
										skillObj[7] = index
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)

--远离指定宠物（使用掉次数）
hGlobal.event:listen("LocalEvent_UsePetBack","__UnitEvent",function(tParam)
	--print("远离指定宠物", tParam[1], tParam[2].data.name)
	if type(tParam) == "table" then
		local index = tParam[1]
		local oUnit = tParam[2]
		
		--无效的目标
		if (oUnit.ID == 0) then
			return
		end
		
		local w = hGlobal.WORLD.LastWorldMap
		local mapInfo = w.data.tdMapInfo
		local tInfo = mapInfo.eventUnit[index]
		if type(tInfo) == "table" then
			--print("tInfo[3]=", tInfo[3])
			if tInfo[3] > 0 then
				tInfo[3] = tInfo[3] - 1
			end
			if tInfo[3] == 0 then
				oUnit:sethide(1)
				--oUnit:setanimation("stand2")
			end
			
			--如果在游戏里关闭此界面，恢复暂停
			local mapInfo = w.data.tdMapInfo
			--print(mapInfo.mapState, hVar.MAP_TD_STATE.PAUSE)
			if (mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE) then --当前是暂停状态
				--进入恢复
				w:pause(0)
				mapInfo.mapState = mapInfo.mapLastState
				mapInfo.mapLastState = hVar.MAP_TD_STATE.IDLE
				
				--恢复游戏当前速率
				hGlobal.event:event("LocalEvent_ResumeSpeed")
			end
		end
	end
	hGlobal.event:event("LocalEvent_CloseOpenPetFrm")
	--hGlobal.event:event("Event_StartPauseSwitch",false)
end)

--关闭宠物
hGlobal.event:listen("LocalEvent_ClosePetBack", "__UnitEvent", function(tParam)
	if type(tParam) == "table" then
		local index = tParam[1]
		local oUnit2 = tParam[2]
		
		--无效的目标
		if (oUnit2.ID == 0) then
			return
		end
		
		--print(index, oUnit2.data.name)
		
		local w = hGlobal.WORLD.LastWorldMap
		local mapInfo = w.data.tdMapInfo
		local tInfo = mapInfo.eventUnit[index]
		if type(tInfo) == "table" then
			--单位技能可使用次数加1
			local td_upgrade = oUnit2.td_upgrade
			if (type(td_upgrade) == "table") then
				local castSkill = td_upgrade.castSkill
				if (type(castSkill) == "table") then
					local order = castSkill.order
					if (type(order) == "table") then
						local skillId = order[1]
						if (type(skillId) == "number") then
							local skillObj = oUnit2:getskill(skillId)
							if skillObj then
								local lv = skillObj[2]
								local count = skillObj[4]
								local cd = skillObj[5]
								local lasttime = skillObj[6]
								
								skillObj[4] = skillObj[4] + 1
							end
						end
					end
				end
			end
			
			--如果在游戏里关闭此界面，恢复暂停
			local mapInfo = w.data.tdMapInfo
			--print(mapInfo.mapState, hVar.MAP_TD_STATE.PAUSE)
			if (mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE) then --当前是暂停状态
				--进入恢复
				w:pause(0)
				mapInfo.mapState = mapInfo.mapLastState
				mapInfo.mapLastState = hVar.MAP_TD_STATE.IDLE
				
				--恢复游戏当前速率
				hGlobal.event:event("LocalEvent_ResumeSpeed")
			end
		end
	end
end)

--远离很多宠物（持续触发）
--多个宠物都会触发
hGlobal.event:listen("LocalEvent_CloseSelectPetFrm","__UnitEvent",function(index)
	--print("远离某个雕像2")
	local w = hGlobal.WORLD.LastWorldMap
	local mapInfo = w.data.tdMapInfo
	
	local panel = hGlobal.O["__WM__TargetOperatePanel"]
	if (panel ~= nil) then
		local _childUI = panel.childUI
		if _childUI and _childUI["actions"] then
			local self = _childUI["actions"]
			local oUnit2 = self.data.oUnit2
			local nIndex = self.data.index
			
			if (nIndex == index) then
				local tInfo = mapInfo.eventUnit[index]
				if tInfo then
					hGlobal.O:replace("__WM__TargetOperatePanel", nil)
					
					--hGlobal.event:event("LocalEvent_HitOnTarget",w,nil,worldX,worldY)
					--hGlobal.event:event("LocalEvent_UseAuraBack", {index,oUnit2})
				end
			end
		end
	end
end)

----------------------------------------------------------------------------------------
--靠近加血台子（持续触发）
--多个加血台子都会触发
hGlobal.event:listen("LocalEvent_ShowUseHpRecoverBtn","__UnitEvent",function(index,oUnit1,oUnit2)
	local w = hGlobal.WORLD.LastWorldMap
	local mapInfo = w.data.tdMapInfo
	local tInfo = mapInfo.eventUnit[index]
	if tInfo then
		--无效的目标
		if (oUnit2.ID == 0) then
			return
		end
		
		--local tCallback = {"LocalEvent_UseAuraBack",{index,oUnit2}}
		--hGlobal.event:event("LocalEvent_ShowSelectAuraFrm",index,tInfo.list,tCallback)
		--print("靠近雕像1")
		--print(oUnit2.data.name)
		--读取单位身上的技能
		local td_upgrade = oUnit2.td_upgrade
		if (type(td_upgrade) == "table") then
			local castSkill = td_upgrade.castSkill
			if (type(castSkill) == "table") then
				local order = castSkill.order
				if (type(order) == "table") then
					local skillId = order[1]
					if (type(skillId) == "number") then
						local skillObj = oUnit2:getskill(skillId)
						if skillObj then
							local lv = skillObj[2]
							local count = skillObj[4]
							local cd = skillObj[5]
							local lasttime = skillObj[6]
							
							if (count > 0) then
								local panel = hGlobal.O["__WM__TargetOperatePanel"]
								if (panel == nil) then
									hGlobal.event:event("LocalEvent_HitOnTarget",w,oUnit2,worldX,worldY)
									local panel = hGlobal.O["__WM__TargetOperatePanel"]
									local _childUI = panel.childUI
									if _childUI and _childUI["actions"] then
										local self = _childUI["actions"]
										self.data.oUnit2 = oUnit2
										self.data.index = index
										
										--临时存储
										skillObj[7] = index
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)

--远离指定加血台子（使用掉次数）
hGlobal.event:listen("LocalEvent_UseHpRecoverBack","__UnitEvent",function(tParam)
	--print("远离指定加血台子", tParam[1], tParam[2].data.name)
	if type(tParam) == "table" then
		local index = tParam[1]
		local oUnit = tParam[2]
		
		--无效的目标
		if (oUnit.ID == 0) then
			return
		end
		
		local w = hGlobal.WORLD.LastWorldMap
		local mapInfo = w.data.tdMapInfo
		local tInfo = mapInfo.eventUnit[index]
		if type(tInfo) == "table" then
			--print("tInfo[3]=", tInfo[3])
			if tInfo[3] > 0 then
				tInfo[3] = tInfo[3] - 1
			end
			if tInfo[3] == 0 then
				oUnit:sethide(1)
				--oUnit:setanimation("stand2")
			end
			
			--如果在游戏里关闭此界面，恢复暂停
			local mapInfo = w.data.tdMapInfo
			--print(mapInfo.mapState, hVar.MAP_TD_STATE.PAUSE)
			if (mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE) then --当前是暂停状态
				--进入恢复
				w:pause(0)
				mapInfo.mapState = mapInfo.mapLastState
				mapInfo.mapLastState = hVar.MAP_TD_STATE.IDLE
				
				--恢复游戏当前速率
				hGlobal.event:event("LocalEvent_ResumeSpeed")
			end
		end
	end
	hGlobal.event:event("LocalEvent_CloseOpenPetFrm")
	--hGlobal.event:event("Event_StartPauseSwitch",false)
end)

--关闭加血台子
hGlobal.event:listen("LocalEvent_CloseHpRecoverBack", "__UnitEvent", function(tParam)
	if type(tParam) == "table" then
		local index = tParam[1]
		local oUnit2 = tParam[2]
		
		--无效的目标
		if (oUnit2.ID == 0) then
			return
		end
		
		--print(index, oUnit2.data.name)
		
		local w = hGlobal.WORLD.LastWorldMap
		local mapInfo = w.data.tdMapInfo
		local tInfo = mapInfo.eventUnit[index]
		if type(tInfo) == "table" then
			--单位技能可使用次数加1
			local td_upgrade = oUnit2.td_upgrade
			if (type(td_upgrade) == "table") then
				local castSkill = td_upgrade.castSkill
				if (type(castSkill) == "table") then
					local order = castSkill.order
					if (type(order) == "table") then
						local skillId = order[1]
						if (type(skillId) == "number") then
							local skillObj = oUnit2:getskill(skillId)
							if skillObj then
								local lv = skillObj[2]
								local count = skillObj[4]
								local cd = skillObj[5]
								local lasttime = skillObj[6]
								
								skillObj[4] = skillObj[4] + 1
							end
						end
					end
				end
			end
			
			--如果在游戏里关闭此界面，恢复暂停
			local mapInfo = w.data.tdMapInfo
			--print(mapInfo.mapState, hVar.MAP_TD_STATE.PAUSE)
			if (mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE) then --当前是暂停状态
				--进入恢复
				w:pause(0)
				mapInfo.mapState = mapInfo.mapLastState
				mapInfo.mapLastState = hVar.MAP_TD_STATE.IDLE
				
				--恢复游戏当前速率
				hGlobal.event:event("LocalEvent_ResumeSpeed")
			end
		end
	end
end)

--远离很多加血台子（持续触发）
--多个加血台子都会触发
hGlobal.event:listen("LocalEvent_CloseSelectHpRecoverFrm","__UnitEvent",function(index)
	--print("远离某个雕像2")
	local w = hGlobal.WORLD.LastWorldMap
	local mapInfo = w.data.tdMapInfo
	
	local panel = hGlobal.O["__WM__TargetOperatePanel"]
	if (panel ~= nil) then
		local _childUI = panel.childUI
		if _childUI and _childUI["actions"] then
			local self = _childUI["actions"]
			local oUnit2 = self.data.oUnit2
			local nIndex = self.data.index
			
			if (nIndex == index) then
				local tInfo = mapInfo.eventUnit[index]
				if tInfo then
					hGlobal.O:replace("__WM__TargetOperatePanel", nil)
					
					--hGlobal.event:event("LocalEvent_HitOnTarget",w,nil,worldX,worldY)
					--hGlobal.event:event("LocalEvent_UseAuraBack", {index,oUnit2})
				end
			end
		end
	end
end)

--[[
hGlobal.event:listen("LocalEvent_InMap_ShowAddPetHp","__UnitEvent",function(index,oUnit1,oUnit2)
	--print("LocalEvent_InMap_ShowAddPetHp")
	local tCallback = {"LocalEvent_AddPetHpBack",{index}}
	hGlobal.event:event("LocalEvent_ShowAddPetHpfrm",tCallback)
end)
]]

--[[
hGlobal.event:listen("LocalEvent_AddPetHpBack","__UnitEvent",function(tParam,result)
	if type(tParam) == "table" then
		local index = tParam[1]
		if result == 1 then
			local w = hGlobal.WORLD.LastWorldMap
			local mapInfo = w.data.tdMapInfo
			local tInfo = mapInfo.eventUnit[index]
			if type(tInfo) == "table" and tInfo[3] < 0 then
				--原本是-1无限次触发  加到0不再触发
				tInfo[3] = tInfo[3] + 1
			end
		end
	end
end)
]]


----------------------------------------------------------------------------------------
--靠近存盘点（持续触发）
--多个存盘点都会触发
hGlobal.event:listen("LocalEvent_ShowSettlementBtn","__UnitEvent",function(index,oUnit1,oUnit2)
	local w = hGlobal.WORLD.LastWorldMap
	local mapInfo = w.data.tdMapInfo
	local tInfo = mapInfo.eventUnit[index]
	if tInfo then
		--无效的目标
		if (oUnit2.ID == 0) then
			return
		end
		
		--local tCallback = {"LocalEvent_UseAuraBack",{index,oUnit2}}
		--hGlobal.event:event("LocalEvent_ShowSelectAuraFrm",index,tInfo.list,tCallback)
		--print("靠近雕像1")
		--print(oUnit2.data.name)
		--读取单位身上的技能
		local td_upgrade = oUnit2.td_upgrade
		if (type(td_upgrade) == "table") then
			local castSkill = td_upgrade.castSkill
			if (type(castSkill) == "table") then
				local order = castSkill.order
				if (type(order) == "table") then
					local skillId = order[1]
					if (type(skillId) == "number") then
						local skillObj = oUnit2:getskill(skillId)
						if skillObj then
							local lv = skillObj[2]
							local count = skillObj[4]
							local cd = skillObj[5]
							local lasttime = skillObj[6]
							
							if (count > 0) then
								local panel = hGlobal.O["__WM__TargetOperatePanel"]
								if (panel == nil) then
									hGlobal.event:event("LocalEvent_HitOnTarget",w,oUnit2,worldX,worldY)
									local panel = hGlobal.O["__WM__TargetOperatePanel"]
									local _childUI = panel.childUI
									if _childUI and _childUI["actions"] then
										local self = _childUI["actions"]
										self.data.oUnit2 = oUnit2
										self.data.index = index
										
										--临时存储
										skillObj[7] = index
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)
--[[
hGlobal.event:listen("LocalEvent_ShowSettlementBtn","__UnitEvent",function(index,oUnit1,oUnit2)
	local tCallback = {"LocalEvent_SettlementBack",{index,oUnit1}}
	hGlobal.event:event("LocalEvent_ShowGameSettlementFrm",index,tCallback)
end)
]]

--远离指定存盘点（使用掉次数）
hGlobal.event:listen("LocalEvent_SettlementBack","__UnitEvent",function(tParam)
	--print("远离指定存盘点", tParam[1], tParam[2].data.name)
	if type(tParam) == "table" then
		local index = tParam[1]
		local oUnit = tParam[2]
		
		--无效的目标
		if (oUnit.ID == 0) then
			return
		end
		
		local w = hGlobal.WORLD.LastWorldMap
		local mapInfo = w.data.tdMapInfo
		local tInfo = mapInfo.eventUnit[index]
		if type(tInfo) == "table" then
			--print("tInfo[3]=", tInfo[3])
			if tInfo[3] > 0 then
				tInfo[3] = tInfo[3] - 1
			end
			if tInfo[3] == 0 then
				--oUnit:sethide(1)
				--oUnit:setanimation("stand2")
				local oPlayerMe = w:GetPlayerMe() --我的玩家对象
				local nForceMe = oPlayerMe:getforce() --我的势力
				local oHero = oPlayerMe.heros[1]
				if oHero then
					local oUnit = oHero:getunit()
					if oUnit then
						local targetInfo = {}
						local ox, oy = hApi.chaGetPos(oUnit.handle)
						w.enumunitAreaAlly(w,nForceMe,ox, oy,150,function(u)
							if u.data.id == 11008 then --飞行器
								local u = hApi.ChangeUnit(u, 11068, 21, 0, nil, nil, true, u.attr.lv)
								
								local toX, toY = u:getXY()
								--hApi.UnitMoveToPoint_TD(u, toX + 1600, toY - 3000, false,500)
								--u:sethide(1)
								
								w:addeffect(3229,1,nil, toX, toY + 50)
								
								local acttime1 = 600
								local act1 = CCScaleTo:create(acttime1/1000,1.2)
								local delay1 = CCDelayTime:create(400/1000)
								local act2 = CCCallFunc:create(function()
									hApi.UnitMoveToPoint_TD(u, toX + 200, toY - 360, false,100)
								end)
								local delay2 = CCDelayTime:create(1.5)
								local act3 = CCCallFunc:create(function()
									hApi.UnitMoveToPoint_TD(u, toX + 2000, toY - 3600, false,800)
								end)
								local a = CCArray:create()
								a:addObject(act1)
								a:addObject(delay1)
								a:addObject(act2)
								a:addObject(delay2)
								a:addObject(act3)
								local sequence = CCSequence:create(a)
								u.handle._n:runAction(sequence)
								
								local eventname = "eventunit"..index.."_"..u.data.id
								hApi.addTimerForever(eventname,hVar.TIMER_MODE.GAMETIME,5,function()
									if u then
										if u.getXY then
											local curX, curY = u:getXY()
											local angle = GetFaceAngle(toX,toY,curX,curY)
											--print("angle",angle)
											
											hApi.ObjectSetFacing(u.handle,angle)
										else
											hApi.clearTimer(eventname)
										end
									else
										hApi.clearTimer(eventname)
									end
								end)

								hApi.addTimerOnce("eventunit"..index,5000,function()
									hApi.clearTimer(eventname)
									if u then
										if u.del then
											u:del()
										end
									end
								end)
							end
						end)
					end
				end
			end
			
			--如果在游戏里关闭此界面，恢复暂停
			local mapInfo = w.data.tdMapInfo
			--print(mapInfo.mapState, hVar.MAP_TD_STATE.PAUSE)
			if (mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE) then --当前是暂停状态
				--进入恢复
				w:pause(0)
				mapInfo.mapState = mapInfo.mapLastState
				mapInfo.mapLastState = hVar.MAP_TD_STATE.IDLE
				
				--恢复游戏当前速率
				hGlobal.event:event("LocalEvent_ResumeSpeed")
			end
		end
	end
	hGlobal.event:event("LocalEvent_CloseOpenPetFrm")
	--hGlobal.event:event("Event_StartPauseSwitch",false)
end)

--关闭存盘点
hGlobal.event:listen("LocalEvent_CloseSettlementBack", "__UnitEvent", function(tParam)
	if type(tParam) == "table" then
		local index = tParam[1]
		local oUnit2 = tParam[2]
		
		--无效的目标
		if (oUnit2.ID == 0) then
			return
		end
		
		--print(index, oUnit2.data.name)
		
		local w = hGlobal.WORLD.LastWorldMap
		local mapInfo = w.data.tdMapInfo
		local tInfo = mapInfo.eventUnit[index]
		if type(tInfo) == "table" then
			--单位技能可使用次数加1
			local td_upgrade = oUnit2.td_upgrade
			if (type(td_upgrade) == "table") then
				local castSkill = td_upgrade.castSkill
				if (type(castSkill) == "table") then
					local order = castSkill.order
					if (type(order) == "table") then
						local skillId = order[1]
						if (type(skillId) == "number") then
							local skillObj = oUnit2:getskill(skillId)
							if skillObj then
								local lv = skillObj[2]
								local count = skillObj[4]
								local cd = skillObj[5]
								local lasttime = skillObj[6]
								
								skillObj[4] = skillObj[4] + 1
							end
						end
					end
				end
			end
			
			--如果在游戏里关闭此界面，恢复暂停
			local mapInfo = w.data.tdMapInfo
			--print(mapInfo.mapState, hVar.MAP_TD_STATE.PAUSE)
			if (mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE) then --当前是暂停状态
				--进入恢复
				w:pause(0)
				mapInfo.mapState = mapInfo.mapLastState
				mapInfo.mapLastState = hVar.MAP_TD_STATE.IDLE
				
				--恢复游戏当前速率
				hGlobal.event:event("LocalEvent_ResumeSpeed")
			end
		end
	end
end)

--远离很多存盘点（持续触发）
--多个存盘点都会触发
hGlobal.event:listen("LocalEvent_CloseSelectSettlementFrm","__UnitEvent",function(index)
	--print("远离某个雕像2")
	local w = hGlobal.WORLD.LastWorldMap
	local mapInfo = w.data.tdMapInfo
	
	local panel = hGlobal.O["__WM__TargetOperatePanel"]
	if (panel ~= nil) then
		local _childUI = panel.childUI
		if _childUI and _childUI["actions"] then
			local self = _childUI["actions"]
			local oUnit2 = self.data.oUnit2
			local nIndex = self.data.index
			
			if (nIndex == index) then
				local tInfo = mapInfo.eventUnit[index]
				if tInfo then
					hGlobal.O:replace("__WM__TargetOperatePanel", nil)
					
					--hGlobal.event:event("LocalEvent_HitOnTarget",w,nil,worldX,worldY)
					--hGlobal.event:event("LocalEvent_UseAuraBack", {index,oUnit2})
				end
			end
		end
	end
end)


----------------------------------------------------------------------------------------
--通用基地NPC（持续触发）
--多个基地NPC都会触发
hGlobal.event:listen("LocalEvent_ShowBaseNPCBtn","__UnitEvent", function(index,oUnit1,oUnit2)
	local w = hGlobal.WORLD.LastWorldMap
	local mapInfo = w.data.tdMapInfo
	local tInfo = mapInfo.eventUnit[index]
	if tInfo then
		--无效的目标
		if (oUnit2.ID == 0) then
			return
		end
		--print("LocalEvent_ShowBaseNPCBtn",index,oUnit1.data.id,oUnit2.data.id)
		
		--local tCallback = {"LocalEvent_UseAuraBack",{index,oUnit2}}
		--hGlobal.event:event("LocalEvent_ShowSelectAuraFrm",index,tInfo.list,tCallback)
		--print("靠近雕像基地NPC")
		--print(oUnit2.data.name)
		--读取单位身上的技能
		local td_upgrade = oUnit2.td_upgrade
		if (type(td_upgrade) == "table") then
			local castSkill = td_upgrade.castSkill
			if (type(castSkill) == "table") then
				local order = castSkill.order
				if (type(order) == "table") then
					local skillId = order[1]
					if (type(skillId) == "number") then
						local skillObj = oUnit2:getskill(skillId)
						if skillObj then
							local lv = skillObj[2]
							local count = skillObj[4]
							local cd = skillObj[5]
							local lasttime = skillObj[6]
							
							if (count > 0) or (count == -1) then
								local panel = hGlobal.O["__WM__TargetOperatePanel"]
								if (panel == nil) then
									hGlobal.event:event("LocalEvent_HitOnTarget",w,oUnit2,worldX,worldY)
									local panel = hGlobal.O["__WM__TargetOperatePanel"]
									local _childUI = panel.childUI
									if _childUI and _childUI["actions"] then
										local self = _childUI["actions"]
										self.data.oUnit2 = oUnit2
										self.data.index = index
										
										--临时存储
										skillObj[7] = index
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)

--远离指定基地NPC（使用掉次数）
hGlobal.event:listen("LocalEvent_UseBaseNPCBack","__UnitEvent",function(tParam)
	--print("远离指定基地NPC", tParam[1], tParam[2].data.name)
	if type(tParam) == "table" then
		local index = tParam[1]
		local oUnit = tParam[2]
		
		--无效的目标
		if (oUnit.ID == 0) then
			return
		end
		
		local w = hGlobal.WORLD.LastWorldMap
		local mapInfo = w.data.tdMapInfo
		local tInfo = mapInfo.eventUnit[index]
		if type(tInfo) == "table" then
			--print("tInfo[3]=", tInfo[3])
			if tInfo[3] > 0 then
				tInfo[3] = tInfo[3] - 1
			end
			if tInfo[3] == 0 then
				oUnit:sethide(1)
				--oUnit:setanimation("stand2")
			end
			
			--如果在游戏里关闭此界面，恢复暂停
			local mapInfo = w.data.tdMapInfo
			--print(mapInfo.mapState, hVar.MAP_TD_STATE.PAUSE)
			if (mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE) then --当前是暂停状态
				--进入恢复
				w:pause(0)
				mapInfo.mapState = mapInfo.mapLastState
				mapInfo.mapLastState = hVar.MAP_TD_STATE.IDLE
				
				--恢复游戏当前速率
				hGlobal.event:event("LocalEvent_ResumeSpeed")
			end
			
			--触发点击事件
			local tTab_EventUnit = hVar.EventUnitDefine[oUnit.data.id]
			if tTab_EventUnit then
				if (type(tTab_EventUnit.code) == "function") then
					tTab_EventUnit.code(oUnit)
				end
			end
		end
	end
	hGlobal.event:event("LocalEvent_CloseOpenPetFrm")
	--hGlobal.event:event("Event_StartPauseSwitch",false)
end)

--关闭基地NPC
hGlobal.event:listen("LocalEvent_CloseBaseNPCBack", "__UnitEvent", function(tParam)
	if type(tParam) == "table" then
		local index = tParam[1]
		local oUnit2 = tParam[2]
		
		--无效的目标
		if (oUnit2.ID == 0) then
			return
		end
		
		--print(index, oUnit2.data.name)
		
		local w = hGlobal.WORLD.LastWorldMap
		local mapInfo = w.data.tdMapInfo
		local tInfo = mapInfo.eventUnit[index]
		if type(tInfo) == "table" then
			--单位技能可使用次数加1
			local td_upgrade = oUnit2.td_upgrade
			if (type(td_upgrade) == "table") then
				local castSkill = td_upgrade.castSkill
				if (type(castSkill) == "table") then
					local order = castSkill.order
					if (type(order) == "table") then
						local skillId = order[1]
						if (type(skillId) == "number") then
							local skillObj = oUnit2:getskill(skillId)
							if skillObj then
								local lv = skillObj[2]
								local count = skillObj[4]
								local cd = skillObj[5]
								local lasttime = skillObj[6]
								
								--非负数(-1表示无限制)
								if (skillObj[4] >= 0) then
									skillObj[4] = skillObj[4] + 1
								end
							end
						end
					end
				end
			end
			
			--如果在游戏里关闭此界面，恢复暂停
			local mapInfo = w.data.tdMapInfo
			--print(mapInfo.mapState, hVar.MAP_TD_STATE.PAUSE)
			if (mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE) then --当前是暂停状态
				--进入恢复
				w:pause(0)
				mapInfo.mapState = mapInfo.mapLastState
				mapInfo.mapLastState = hVar.MAP_TD_STATE.IDLE
				
				--恢复游戏当前速率
				hGlobal.event:event("LocalEvent_ResumeSpeed")
			end
		end
	end
end)

--远离很多基地NPC（持续触发）
--多个基地NPC都会触发
hGlobal.event:listen("LocalEvent_CloseSelectBaseNPCFrm","__UnitEvent",function(index)
	--print("远离某个雕像2")
	local w = hGlobal.WORLD.LastWorldMap
	local mapInfo = w.data.tdMapInfo
	
	local panel = hGlobal.O["__WM__TargetOperatePanel"]
	if (panel ~= nil) then
		local _childUI = panel.childUI
		if _childUI and _childUI["actions"] then
			local self = _childUI["actions"]
			local oUnit2 = self.data.oUnit2
			local nIndex = self.data.index
			
			if (nIndex == index) then
				local tInfo = mapInfo.eventUnit[index]
				if tInfo then
					hGlobal.O:replace("__WM__TargetOperatePanel", nil)
					
					--hGlobal.event:event("LocalEvent_HitOnTarget",w,nil,worldX,worldY)
					--hGlobal.event:event("LocalEvent_UseAuraBack", {index,oUnit2})
				end
			end
		end
	end
end)


----------------------------------------------------------------------------------------
--地图中显示强化战车界面
hGlobal.event:listen("LocalEvent_InMap_Showskillfrm","__UnitEvent",function(index,oUnit1,oUnit2,tLeavePos)
	local oWorld = hGlobal.WORLD.LastWorldMap
	if oWorld then
		--local toX, toY = hApi.chaGetPos(oUnit2.handle)
		local toX, toY = oUnit2.data.worldX,oUnit2.data.worldY
		oWorld.data.keypadEnabled = false
		local backX,backY
		print(tLeavePos)
		if type(tLeavePos) == "table" then
			print(tLeavePos[1],tLeavePos[2])
			backX = tLeavePos[1] + oUnit2.data.worldX
			backY = tLeavePos[2] + oUnit2.data.worldY
		else
			backX,backY = math.floor((oUnit1.data.worldX- toX)* 0.5 +  oUnit1.data.worldX), math.floor((oUnit1.data.worldY - toY)*0.5+oUnit1.data.worldY)
		end
		local tCallback = {"LocalEvent_AutoMoveBack",{index,oUnit1,oUnit2,backX,backY}}
		local mapInfo = oWorld.data.tdMapInfo
		mapInfo.CurrentEventIndex = index
		mapInfo.MoveArriveFunc = function()
			hGlobal.event:event("Event_StartPauseSwitch",true)
			hApi.PlaySound("open")
			--hGlobal.event:event("LocalEvent_Phone_ShowDiabloSkillUpInfoFrm_inMap",oUnit1.data.id,tCallback)
			hGlobal.event:event("LocalEvent_ShowChariotEquipFrm",tCallback)
		end
		hApi.UnitStop_TD(oUnit1)
		hApi.UnitMoveToPoint_TD(oUnit1, toX, toY, true)
		hApi.addTimerOnce("UnitEvnetMoveEvent",1,function()
			print("start")
			mapInfo.EventFuncEnable = true
		end)
	end
end)

hGlobal.event:listen("LocalEvent_AutoMoveBack","__UnitEvent",function(tParam,result)
	if type(tParam) == "table" then
		local index = tParam[1]
		local oUnit = tParam[2]
		local target = tParam[3]
		local backX,backY = tParam[4],tParam[5]
		
		local w = hGlobal.WORLD.LastWorldMap
		local mapInfo = w.data.tdMapInfo
		local tInfo = mapInfo.eventUnit[index]
		mapInfo.CurrentEventIndex = index
		mapInfo.MoveArriveFunc = function()
			local oWorld = hGlobal.WORLD.LastWorldMap
			oWorld.data.keypadEnabled = true
		end
		if result == 1 then
			--去除特效
			if target then
				if type(target.data.effectsOnCreate) == "table" then
					for i = 1, #target.data.effectsOnCreate, 1 do
						target.data.effectsOnCreate[i].handle._n:setVisible(false)
					end
				end
			end
		else
			if tInfo[3] >= 0 then
				tInfo[3] = tInfo[3] + 1
			end
		end
		hApi.UnitStop_TD(oUnit)
		hApi.UnitMoveToPoint_TD(oUnit, backX, backY, false)
		hGlobal.event:event("Event_StartPauseSwitch",false)
		hApi.addTimerOnce("UnitEvnetBackMoveEvent",1,function()
			print("end")
			--因为hApi.UnitMoveToPoint_TD 这个函数是根据 游戏帧运行  而计时器是根据时间走 所以掐不准时间  所以改写法
			mapInfo.EventFuncEnable = true
		end)
		
	end
end)

hGlobal.event:listen("Event_UnitArrive_TD","_unitEvent",function(oUnit)
	local w = hGlobal.WORLD.LastWorldMap
	if w then
		local oOwnUnit
		local oPlayerMe = w:GetPlayerMe() --我的玩家对象
		if type(oPlayerMe.heros) == "table" then
			local oHero = oPlayerMe.heros[1]
			if oHero then
				oOwnUnit = oHero:getunit()
			end
		end
		if oUnit == oOwnUnit then
			local mapInfo = w.data.tdMapInfo
			local index = mapInfo.CurrentEventIndex
			local func = mapInfo.MoveArriveFunc
			if mapInfo.EventFuncEnable then
				print("Event_UnitArrive_TD",type(func),index)
				if index and index > 0 then
					if type(func) == "function" then
						func()
					end
				end
				mapInfo.CurrentEventIndex = 0
				mapInfo.MoveArriveFunc = nil
				mapInfo.EventFuncEnable = nil
			end
		end
	end
end)