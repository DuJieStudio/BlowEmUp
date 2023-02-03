--=============================================================
-- 事件
--=============================================================
hVar.EVENT_NAME = {
	"Event_UnitStartMove",				--function(oWorld,oUnit,gridX,gridY,oTarget,nOperate)
	"Event_UnitNotMove",				--function(oWorld,oUnit,gridX,gridY)
	"Event_UnitArrive",				--function(oWorld,oUnit,gridX,gridY,oTarget,nOperate,nOperateId)
	"Event_AfterUnitArrive",			--function(oWorld,oUnit,gridX,gridY,oTarget,nOperate,nOperateId)
	
	"Event_UnitCreated",				--function(oUnit)
	"Event_ItemCreated",				--function(Item)
	"Event_UnitDead",				--function(oUnit,nOperate,oKillerUnit,nId,vParam, oKillerSide, oKillerPos)
	"Event_BeforeUnitDamaged",			--function(oUnit,tDamageData,oAttacker)				--tDamageData:{id=id,mode=mode,dmg=dmg}
	"Event_UnitDamaged",				--function(oUnit,nSkillId,nDmgMode,nDmg,nLost,oAttacker,nAbsorb, oAttackerSide, oAttackerPos)
	"Event_UnitBeforeHealed",			--function(oUnit,tDamageData,oAttacker)				--tDamageData:{id=id,mode=mode,dmg=dmg}
	"Event_UnitHealed",				--function(oUnit,nSkillId,nDmgMode,nHeal,nRevive,oAttacker)
	
	"Event_BuildingCreated",			--function(oUnit)
	
	"Event_UnitJoinTeam",				--function(oUnit,oJoinUnit,tTeamAdd)
	
	"Event_UnitStartCast",				--function(oWorld,IsAutoOrder,nOrderType,nOperate,oUnit,vOrderId,oTarget,gridX,gridY)
	"Event_UnitCastSkill",				--function(oUnit,nSkillId,oAction)
	
	"Event_UnitStepMove",				--function(oWorld,oUnit,worldX,worldY)		--单位在世界地图上每走一步的回调，一般来说只有英雄有这个回调
	
	"Event_WorldCreated",				--function(oWorld,IsCreatedFromLoad)
	
	"Event_UnitBorn",				--function(oUnit)
	
	"Event_TeamChange",				--function(mode,oUnit,nParam1,nParam2)				--玩家交换单位
	
	"Event_HeroCreated",				--function(oHero,CreatedOnMapInit)
	"Event_HeroChangeOwner",			--function(oHero,oPlayer,oPlayerOld)
	"Event_HeroRevive",				--function(oHero,oUnit,oBuilding,worldX,worldY)
	"Event_HeroEnterMap",				--function(oHero,oUnit)
	"Event_HeroLevelUp",				--function(oHero,nLastLevel)
	
	"Event_HeroAttackEnemy",			--function(oWorld,oUnit,oTarget)
	
	"Event_HeroStartTalk",				--function(oWorld,oUnit,oTarget,tTalk)
	"Event_HeroLoot",				--function(oWorld,oUnit,oTarget)
	"Event_HeroOccupy",				--function(oWorld,oUnit,oTarget)
	"Event_PlayerGetBuilding",			--function(oWorld,oPlayer,oTarget)
	"Event_HeroVisit",				--function(oWorld,oUnit,oTarget)
	"Event_HeroEnterTown",				--function(oWorld,oUnit,oBuilding,oTown)
	"Event_HeroLeaveTown",				--function(oWorld,oUnit,oBuilding,oTown)
	
	"Event_HeroVictory",				--function(oWorld,oHero,tLoot,oDefeatTarget)
	"Event_HeroDefeated",				--function(oHero,oDefeatHero)
	
	"Event_HeroSurrender",				--function(oBattlefield,oHero,oUnit)
	
	"Event_HeroTakeShop",				--function(oWorld,oUnit,oTarget,nOperate,tData)	--英雄访问商店
	
	"Event_UnitDefeated",				--function(oBattlefield,oUnit,oDefeatHero)
	
	"Event_EndDay",					--function(nDayCount)
	"Event_NewDay",					--function(nDayCount)
	
	"Event_BattlefieldStart",			--function(oWorld)
	"Event_BattlefieldRoundStart",			--function(oWorld,oRound)
	"Event_BattlefieldUnitSkip",			--function(oWorld,oRound,oUnit)
	"Event_BattlefieldUnitActived",			--function(oWorld,oRound,oUnit)		--单位战场操作权激活
	
	"Event_HireConfirm",				--function(oWorld,oUnit,oTarget)
	
	
	"Event_HeroAttackConfirm",			--function(oWorld,oHero)
	
	"Event_BuildingUpgrade",			--function(nOperate,oWorld,oUnit,oTown,oTarget) --建筑升级
	
	"Event_TownSetGuard",				--function(oWorld,TownUnit,oGuard,nOperate)	--设置主城守卫
	"Event_TownSetVisitor",				--function(oWorld,TownUnit,oVisitor,nOperate)	--设置主城访问者
	"Event_TownShiftGuardAndVisitor",		--function(oWorld,TownUnit,oGuard,oVisitor,nOperate)
	
	"Event_HeroGetItem",				--function(oHero,oItem,sBagName,nIndex)		--英雄捡取道具
	"Event_HeroDropItem",				--function(oHero,oWorld,itemID,fromInedx)	--英雄丢弃道具
	"Event_HeroSortItem",				--function(oHero,IsUpdateAttr,ByWhatOperate,tChangeSlot)	--整理道具栏内的道具
	"Event_WorldDropItem",				--function(oUnit)				--世界地图上产生道具
	"Event_SetTownTech",				--function(oTown)				--设置城镇科技等级
	"Event_HeroUseItem",				--function(oHero)				--英雄使用道具
	"Event_UnitArrive_TD",				--function(oUnit, nIsSuccess, callbackSkillId) --英雄移动到达 --geyachao: TD测试移动到达
	"Event_UnitAttack_TD",				--function(oAttacter, oTarget) --普通攻击事件 --geyachao: TD测试普通攻击事件
	"Event_UnitStunStaticState",		--function(oUnit, stun, static, chaos) --普通攻击事件 --geyachao: TD角色眩晕或僵直或混乱状态变化
}


hVar.LOCAL_EVENT_NAME = {
	"LocalEvent_WorldMapStart",			--function(oWorld)				--世界地图开始，第0天事件触发后调用
	"LocalEvent_PlayerSelectHero",			--function(oPlayer,newUnit,oldUnit,oWorld)	--本地玩家选择一个英雄(大地图)
	"LocalEvent_PlayerSelectUnit",			--function(oPlayer,newUnit,oldUnit,oWorld)	--本地玩家选择一个单位(战场)
	"LocalEvent_PlayerCancelSelectUnit",		--function(oPlayer,oldUnit,oWorld)		--本地玩家取消选择一个单位(战场)
	
	"LocalEvent_PlayerEnterBattlefield",		--function(oWorld,oUnit,oTarget)		--本地玩家进入战场
	"LocalEvent_PlayerLeaveBattlefield",		--function(oPlayer)				--本地玩家离开战场
	
	"LocalEvent_PlayerFocusWorld",			--function(sSceneType,oWorld,oMap)		--本地玩家聚焦到世界/场景
	
	"LocalEvent_TeamChange",			--function(mode,oUnit)				--本地玩家交换单位
	
	"LocalEvent_SkillButtonDown",			--function(nOperateType,oPlayer,oWorld,oUnit,nSkillId,oTarget,gridX,gridY)	--本地玩家点击技能按钮(战场)
	
	"LocalEvent_HitOnTarget",			--function(oWorld,oUnit,worldX,worldY)				--点到了任何单位
	"LocalEvent_TouchOnWorld",			--function(oWorld,worldX,worldY)				--点到了地图上(在大地图上抬起)
	
	"LocalEvent_TouchDown_BF",			--function(oWorld,gridX,gridY,worldX,worldY)			--点到了战场上(在战场上按下)
	"LocalEvent_TouchMove_BF",			--function(oWorld,gridX,gridY,worldX,worldY)			--点到了战场上(在战场上移动)
	"LocalEvent_TouchUp_BF",			--function(oWorld,gridX,gridY,worldX,worldY)			--点到了战场上(在战场上弹起)
	
	"localEvent_HeroTryCaptureEnemy",		--function(oWorld,oUnit,oTarget)		--本地玩家尝试捕获单位
	
	"LocalEvent_ShowBuildingUpgrade",		--本地玩家尝试打开升级建筑面板
	
	"LocalEvent_PlayerEnterTown",			--function(oBuilding,oTown,oVisitor)	--本地玩家进城
	
	"LocalEvent_PlayerReviveHero",			--function(nOperate,oWorld,oUnit,oBuilding,oTarget)
	
	"LocalEvent_CannotBuildingUpGrade",		--function()
	
	"LocalEvent_SystemMsgBox",			--function(BuildingRet,MovePointRet)	--本地的一天结束后信息面板 能否建造 能否移动 
	
	"LocalEvent_InitLocalPlayer",			--function(oWorld,oPlayer)		--初始化本地玩家
	
	"LocalEvent_HeroInfoFram",			--function(oHero)			--打开英雄信息面板
	
	"LocalEvent_TechnologyUpgrade",			--function(nOperate,oWorld,oUnit,TownUnit,oTarget)
	
	"LocalEvent_ShowSkillInfoFram",			--function(oUnit,SkillID,x,y,mode)	--打开技能信息面板
	
	"LocalEvent_ShowUnitInfoFram",			--function(oUnit,UnitID,x,y)		--打开单位信息面板
	
	"LocalEvent_ShowPlayerInfoFram",		--function(playerinfo,index)			--打开玩家信息面板
	
	"LocalEvent_UnitAddAttrByAction",		--function(oAction,oUnit,sAttr,nVal,sVal)
	
	"LocalEvent_ShowPlayerListFram",		--function(playerList)			--单机游戏中打开本地玩家列表的事件
	
	"LocalEvent_ShowWorldRank",			--function()				--打开势力排行榜
	
	"LocalEvent_GetHeroCard",			--function(oHero)			--本地玩家获得英雄卡片事件
	
	"LocalEvent_ErroFram",				--function(msg_str)			--错误信息的脚本弹框事件
	
	"LocalEvent_ShowPlayerCardFram",		--function(index)			--打开玩家卡片界面
	
	"LocalEvent_HeroCardFram",			--function(heroinfo)			--本地打开英雄面板的函数
	
	"LocalEvent_ShowNetShop",			--function()				--本地玩家打开网络商店事件
	
	"LocalEvent_BattlefieldResult",			--function(oWorld,oUnitV,oUnitD,tLoot)	--本地玩家战场结束事件
	
	"LocalEvent_ShowSelectedLevelFram",		--function()				--显示关卡选择界面
	
	"LocalEvent_ShowItemTipFram",			--function(itemIDlist,isshow)		--显示道具提示面板
	
	"LocalEvent_TouchOnActionList",			--function(oTarget,nRoundCount)		--点到了行动队列面板上就会触发这个事件
	
	"LocalEvent_MsgTipFrm",				--function(text)			--执行后会出现一个 信息面板提示
	
	"LocalEvent_ShowImperialAcademy",		--function()				--打开翰林院学习技能面板
	
	"LocalEvent_ShowLevelUpFrm",			--function()				--升级后弹出升级面板
	
	"LocalEvent_ShowItemInfoFrm",			--function(itemID)			--在大地图上点击问好查看道具属性
	
	--"LocalEvent_ShowCtrlFrm",			--function(grid,x,y,parma)		--显示操控面板
	"LocalEvent_ShowPartArmyFrm",			--function(oUnit)			--显示分兵界面
	"LocalEvetn_ShowUpgradeArmyFrm",		--function(oUnit)			--显示升级兵种界面
	
	"LocalEvent_UpdateMapQuest",			--function(oWorld,oUnit)		--刷新任务面板
	"LocalEvent_ShowTalkFrm",			--function()				--对话面板显示(用于关闭msgbox)
	
	"LocalEvent_SetCurGameCoin",			--function(rmb)				--通过网络设置本地游戏币数量
	
	"LocalEvent_HeroOprBtnUpdate",			--function()				--刷新本地玩家英雄操作头像
}

-----------------------------------------------------------
-- 切场景事件队列
-----------------------------------------------------------
hGlobal.SceneEvent = {
	temp = {
		scene = 0,
		lock = 0,
	},
	data = {},
	add = function(self,sSceneName,nIfPause,pFunc,tParam)
		local e = self.data[sSceneName]
		if e==nil then
			e = {i=0,paused=0}
			self.data[sSceneName] = e
			if sSceneName==self.temp.scene then
				hApi.addTimer("__WD__SceneEventTimer",hVar.TIMER_MODE.GAMETIME,0,100,self.loop)
			end
		end
		e[#e+1] = {nIfPause,pFunc,tParam}
	end,
	switch = function(self,sSceneName)
		if type(sSceneName)=="string" then
			self.temp.scene = sSceneName
			--local e = self.data[sSceneName]
			--if e and #e>0 then
				hApi.addTimer("__WD__SceneEventTimer",hVar.TIMER_MODE.GAMETIME,0,100,self.loop)
			--end
		else
			self.temp.scene = 0
			hApi.clearTimer("__WD__SceneEventTimer")
		end
	end,
	continue = function(self,nLockTick)
		local d = hGlobal.SceneEvent.data
		local tEvent = d[self.temp.scene]
		if type(tEvent)=="table" then
			tEvent.paused = 0
			if type(nLockTick)=="number" then
				self.temp.lock = hApi.gametime() + nLockTick
				hUI.Disable(nLockTick,"SceneEvent")
			end
		end
	end,
	clear = function(self)
		self.temp.scene = 0
		self.temp.lock = 0
		self.data = {}
	end,
	loop = function()
		local self = hGlobal.SceneEvent
		if self.temp.lock~=0 then
			if self.temp.lock<=hApi.gametime() then
				self.temp.lock = 0
			else
				return
			end
		end
		local d = self.data
		local tEvent = d[self.temp.scene]
		if type(tEvent)=="table" then
			if tEvent.paused==1 then
				return
			end
			tEvent.i = tEvent.i + 1
			local v = tEvent[tEvent.i]
			if v~=nil then
				if v[1]==1 then
					tEvent.paused = 1
				end
				return v[2](v[3])
			else
				d[self.temp.scene] = nil
			end
		end
		hApi.clearTimer("__WD__SceneEventTimer")
	end,
}

-----------------------------------------------------------
-- event
-----------------------------------------------------------
hGlobal.event["Event_UnitNotMove"] = function(oWorld,oUnit,gridX,gridY,bRes)
	local u = oUnit
	local oWorld = oWorld
	if oWorld.data.type=="battlefield" then
		--if u.data.roundState==hVar.UNIT_ROUND_STATE.ROUND_START then
			----如果单位还有攻击能力，则进入等待攻击状态，否则回合结束
			--if u.attr.attack[1]~=0 then
				--u:setroundstate(hVar.UNIT_ROUND_STATE.AFTER_MOVE)
			--else
				--u:setroundstate(hVar.UNIT_ROUND_STATE.ROUND_END)
			--end
		--end
		if oWorld.data.IsQuickBattlefield==1 then
			return
		end
	end
	return hGlobal.event:event("Event_UnitNotMove",oWorld,oUnit,gridX,gridY,bRes)
end

hGlobal.event["Event_UnitStartMove"] = function(oWorld,oUnit,gridX,gridY,oTarget,nOperate)
	local u = oUnit
	local oWorld = oWorld
	if oWorld.data.type=="worldmap" then
		if u.data.curTown~=0 then
			local oTown = hClass.town:find(u.data.curTown)
			u.data.curTown = 0
			if oTown~=nil and oTown:getunit("visitor")==u then
				hGlobal.event:call("Event_HeroLeaveTown",oWorld,oUnit,oTown:getunit(),oTown)
			end
		end
	elseif oWorld.data.type=="battlefield" then
		--如果单位还有攻击能力，则进入等待攻击状态
		u:setroundstate(hVar.UNIT_ROUND_STATE.AFTER_MOVE)
		--战场log:移动
		--oWorld:log({
			--key = "unit_moved",
			--x = gridX,
			--y = gridY,
			--unit = {
				--objectID = oUnit.ID,
				--id = oUnit.data.id,
				--name = oUnit.handle.name,
				--indexOfTeam = oUnit.data.indexOfTeam,
				--owner = oUnit.data.owner,
				--old = {
					--x = oUnit.data.gridX,
					--y = oUnit.data.gridY,
				--},
			--},
		--})
		if oWorld.data.IsQuickBattlefield==1 then
			return
		end
	end
	return hGlobal.event:event("Event_UnitStartMove",oWorld,u,gridX,gridY,oTarget,nOperate)
end

hGlobal.event["Event_HeroTakeShop"] = function(oWorld,oUnit,oTarget,nOperate,tData,nOperateId)
	if nOperate==hVar.OPERATE_TYPE.UNIT_HIRE then
		if tData.hireList==0 then
			return
		end
	elseif nOperate==hVar.OPERATE_TYPE.UNIT_SHOP then
		if tData.shopList==0 then
			return
		end
	elseif nOperate==hVar.OPERATE_TYPE.UNIT_MARKET then
		
	else
		return
	end
	if nOperateId == 1 then	-- AI 走到并且开始雇佣
		local buyList = heroGameAIExplore.GetCanHireList(oUnit,oTarget)
		return oUnit:getowner():order(oWorld,hVar.OPERATE_TYPE.UNIT_HIRE,oUnit,buyList,oTarget,oTarget.data.gridX,oTarget.data.gridY)

	else -- 玩家雇佣
		return hGlobal.event:event("Event_HeroTakeShop",oWorld,oUnit,oTarget,nOperate,tData,nOperateId)
	end
end

hGlobal.event["Event_UnitArrive"] = function(oWorld,oUnit,gridX,gridY,oTarget,nOperate,nOperateId,oGridX,oGridY)
	if oWorld.data.type=="battlefield" then
		if oWorld:IsUnitCovered(oUnit)==hVar.RESULT_SUCESS then
			oUnit.data.IsCovered = 1
		else
			oUnit.data.IsCovered = 0
		end
		if nOperate==hVar.OPERATE_TYPE.SKILL_TO_UNIT or nOperate==hVar.OPERATE_TYPE.SKILL_TO_GRID or nOperate==hVar.OPERATE_TYPE.SKILL_IMMEDIATE then
			--oGridX,oGridY:这2个值只有瞬移时才有效
			--战场log:瞬移
			--oWorld:log({
				--key = "unit_moved",
				--x = gridX,
				--y = gridY,
				--unit = {
					--objectID = oUnit.ID,
					--id = oUnit.data.id,
					--name = oUnit.handle.name,
					--indexOfTeam = oUnit.data.indexOfTeam,
					--owner = oUnit.data.owner,
					--old = {
						--x = oGridX,
						--y = oGridY,
					--},
				--},
			--})
		end
		if oWorld.data.IsQuickBattlefield==1 then
			return
		end
	elseif oTarget~=nil then
		hGlobal.event:call("Event_HeroTakeShop",oWorld,oUnit,oTarget,nOperate,oTarget.data,nOperateId)
	end
	--玩家到达地点
	return hGlobal.event:event("Event_UnitArrive",oWorld,oUnit,gridX,gridY,oTarget,nOperate,nOperateId)
end

--geyachao: TD游戏开始事件
hGlobal.event["LocalEvent_TDGameBegin"] = function(oMap, oWorld)
	
	--触发TD游戏开始特殊处理回调
	if On_TDGameBegin_Special_Event then
		--安全执行
		hpcall(On_TDGameBegin_Special_Event, oMap, oWorld)
		--On_TDGameBegin_Special_Event(oMap, oWorld)
	end
	
	--触发事件
	return hGlobal.event:event("LocalEvent_TDGameBegin", oMap, oWorld)
end

hGlobal.event["Event_TeamChange"] = function(mode,oUnit,nParam1,nParam2)
	if oUnit:getowner()==hGlobal.LocalPlayer then
		hGlobal.event:event("LocalEvent_TeamChange",mode,oUnit,nParam1,nParam2)
	end
end

hGlobal.event["Event_HeroCreated"] = function(oHero,CreatedOnMapInit)
	return hGlobal.event:event("Event_HeroCreated",oHero,CreatedOnMapInit)
end

hGlobal.event["Event_HeroChangeOwner"] = function(oHero,oPlayer,oPlayerOld)
	return hGlobal.event:event("Event_HeroChangeOwner",oHero,oPlayer,oPlayerOld)
end

hGlobal.event["Event_UnitJoinTeam"] = function(oUnit,oJoinUnit,tTeamAdd)
	return hGlobal.event:event("Event_UnitJoinTeam",oUnit,oJoinUnit,tTeamAdd)
end

hApi.GetHeroHireCost = function(oWorld)
	if oWorld then
		local tMapData = oWorld:getmapdata(1)
		if tMapData and type(tMapData.HeroHireCost)=="table" and #tMapData.HeroHireCost>=1 then
			return tMapData.HeroHireCost
		end
	end
	return hVar.HERO_HIRE_COST
end

hApi.GetHeroReviveCost = function(oWorld)
	if oWorld then
		local tMapData = oWorld:getmapdata(1)
		if tMapData and type(tMapData.HeroReviveCost)=="table" and #tMapData.HeroReviveCost>=1 then
			return tMapData.HeroReviveCost
		end
	end
	return hVar.HERO_REVIVE_COST
end

hGlobal.event["Event_HeroRevive"] = function(oWorld,oHero,oUnit,oBuilding,gridX,gridY)
	local oWorld = hGlobal.WORLD.LastWorldMap
	if oWorld==nil then
		_DEBUG_MSG("[REVIVE WARNING]worldmap is not exist")
		return
	end
	if oHero.data.HeroTeamLeader~=0 then
		_DEBUG_MSG("[REVIVE WARNING]assist hero can not revive")
		return
	end
	
	local IsNewHero = 0
	--看看是不是买出来的英雄
	if oHero.data.nDayDefeated==-1 then
		oHero.data.nDayDefeated = 0
		IsNewHero = 1
	end
	--复活英雄
	if oUnit==nil then
		oHero.data.IsDefeated = 0
		local worldX,worldY = oWorld:grid2xy(gridX,gridY)
		local x,y = hApi.Scene_GetSpace(worldX, worldY, 60)
		if not(x==0 and y==0) then
			gridX,gridY = oWorld:xy2grid(x,y)
		end
		oUnit = oHero:enterworld(oWorld,gridX,gridY)
		oUnit:getowner().data.reviveCount = oUnit:getowner().data.reviveCount + 1
	end
	if IsNewHero==1 then
		--刚买出来的英雄！拥有100%的生命值和100%的魔法值
		oHero:setHpMpPec(1,1)
		--买英雄扣钱
	else
		--刚复活的英雄拥有100%的生命值和0%的魔法值
		oHero:setHpMpPec(1,0)
		--如果当天死亡的英雄复活出来的时候是没有行动力的
		if oHero.data.nDayDefeated==oWorld.data.roundcount then
			hApi.chaSetMovePoint(oUnit.handle,0)
		end
		--同队复活英雄
		oHero:enumteam(function(oHeroC)
			oHeroC.data.IsDefeated = 0
			oHeroC.data.nDayDefeated = 0
			oHeroC:setHpMpPec(1,0)
			oUnit:teamaddunit({{oHeroC.data.id,1}})
			local oUnitC = oHeroC:enterworld(oWorld,gridX,gridY)
			hGlobal.event:event("Event_HeroRevive",oWorld,oHeroC,oUnitC,oBuilding,gridX,gridY)
		end)
		--复活扣钱
		local tReviveCost = hApi.GetHeroReviveCost(oWorld)
		local nGoldCost = tReviveCost[oHero.attr.level] or tReviveCost[#tReviveCost]
		oUnit:getowner():addresource(hVar.RESOURCE_TYPE.GOLD,-1*nGoldCost)
	end
	--复活以后塞到AI搜索列表中
	--主城里面复活的特殊处理(设置成守卫或者丢到门口)
	local oTown = oBuilding:gettown()
	if oTown then
		local vU = oTown:getunit("visitor")
		local gU = oTown:getunit("guard")
		if gU~=nil then
			--守卫存在时
			if vU==nil then
				--当守卫存在时，先尝试丢到访问位
				hGlobal.event:call("Event_TownSetVisitor",oWorld,oBuilding,oUnit,hVar.OPERATE_TYPE.HERO_REVIVE)
			else
				--否则丢到城门口
			end
		else
			--没有守卫时，成为守卫
			--如果成功添加队列则删除主城里的单位
			local teamAdd = {}
			for i = 1,#oBuilding.data.team do
				if oBuilding.data.team[i] ~= 0 then
					local id,nMin = unpack(oBuilding.data.team[i])
					teamAdd[#teamAdd+1] = {id,nMin}
				end
			end
			if oUnit:teamaddunit(teamAdd) then
				for i = 1,#oBuilding.data.team do
					oBuilding:teamremoveunit(i)
				end
				hGlobal.event:call("Event_TownSetGuard",oWorld,oBuilding,oUnit,hVar.OPERATE_TYPE.HERO_REVIVE)
			elseif vU==nil then
				--合并单位失败，设置成访问者
				hGlobal.event:call("Event_TownSetVisitor",oWorld,oBuilding,oUnit,hVar.OPERATE_TYPE.HERO_REVIVE)
			else
				--丢到城门口
			end
		end
	end
	return hGlobal.event:event("Event_HeroRevive",oWorld,oHero,oUnit,oBuilding,gridX,gridY)
end

local __CODE__LocalHeroLevelUp = function(tParam)
	local oHero = tParam.hero
	local nLastLevel = tParam.level
	if oHero.ID>0 and oHero.data.IsDefeated~=1 then
		hApi.ShowHeroLevelUp(oHero)
		hApi.addTimerOnce("LocalEvent_showLevelUpFrmC",500,function()
			hGlobal.event:event("LocalEvent_showLevelUpFrmC",1,oHero.data.id,oHero.attr.level,nLastLevel)
		end)
	else
		hGlobal.SceneEvent:continue()
	end
end

hGlobal.event["Event_HeroLevelUp"] = function(oHero,nLastLevel,nIfPlayEffect)
	if nIfPlayEffect==1 then
		if oHero.data.owner==hGlobal.LocalPlayer.data.playerId then
			hGlobal.SceneEvent:add("worldmap",1,__CODE__LocalHeroLevelUp,{hero=oHero,level=nLastLevel})
		else
			hApi.ShowHeroLevelUp(oHero)
		end
	end
	return hGlobal.event:event("Event_HeroLevelUp",oHero,nLastLevel,nIfPlayEffect)
end

hGlobal.event["Event_HeroEnterMap"] = function(oHero,oUnit)
	hGlobal.event:event("Event_HeroEnterMap",oHero,oUnit)
	if oHero.ID~=0 and oUnit.ID~=0 then
		if oUnit.handle._c then
			--如果已经在多英雄队伍中则设置行动力为0
			if oHero.data.HeroTeamLeader~=0 then
				oUnit:setmovepoint(0)
				oUnit:sethide(1)
			else
				oUnit:setmovepoint("born")
			end
		end
	end
end

hGlobal.event["Event_UnitCreated"] = function(oUnit)
	local oWorld = oUnit:getworld()
	if oWorld then
		if oWorld.data.type=="battlefield" then
			if oUnit.attr.passive>0 then
				--被动单位创建时不增加unit count
			else
				--一般单位
				local nUnitForce = oUnit.data.owner
				oWorld.data.unitcount[nUnitForce] = (oWorld.data.unitcount[nUnitForce] or 0) + 1
				oWorld.data.unitcount.idx[oUnit.__ID] = nUnitForce
			end
		end
		if oWorld.data.IsQuickBattlefield~=1 then
			return hGlobal.event:event("Event_UnitCreated",oUnit)
		end
	end
end

hGlobal.event["Event_ItemCreated"] = function(oItem)
	--local oUnit = oItem:getunit()
	--local oWorld = oUnit:getworld()
	--if oWorld and oWorld.data.type == "worldmap" then
		
	--end
	return hGlobal.event:event("Event_ItemCreated",oItem)
end
hGlobal.event["Event_BuildingCreated"] = function(oUnit)
	local oWorld = oUnit:getworld()
	if oWorld then
		if oWorld.data.IsQuickBattlefield~=1 then
			return hGlobal.event:event("Event_BuildingCreated",oUnit)
		end
	end
end

--回蓝/扣蓝处理
hApi.UnitUseManaByCast = function(oUnit,nSkillId,nManaCost,mode)
	if nManaCost and nManaCost~=0 and type(nManaCost)=="number" and oUnit and oUnit.ID~=0 then
		local a = oUnit.attr
		local omp = a.mp
		a.mp = math.min(a.mxmp,math.max(0,a.mp-nManaCost))
		if nManaCost>0 then
			a.ManaUsed = a.ManaUsed + nManaCost
		end
		local nFinalCost = omp - a.mp
		local oHero = oUnit:gethero()
		local oWorld = oUnit:getworld()
		if oHero and oWorld and nFinalCost~=0 then
			oWorld:log({		--回复/扣除法力
				key = "hero_mana",
				skillId = nSkillId,
				manacost = nFinalCost,
				unit = {
					objectID = oUnit.ID,
					id = oUnit.data.id,
					name = oUnit.handle.name,
					indexOfTeam = oUnit.data.indexOfTeam,
					owner = oUnit.data.owner,
					hero_objectID = oHero.ID,
				},
			})
		end
		return nManaCost
	end
	return 0
end

local __tParamEx = {}
local __ReadParam = function(t,r)
	if t then
		for k,v in pairs(t)do
			r[k] = v
		end
	end
	return r
end
hApi.CastSkill = function(oUnit,nSkillId,nManaCost,nPower,oTarget,gridX,gridY, tParamEx)
	--print("CastSkill", oUnit.data.name, oTarget.data.name, nSkillId, gridX, gridY, debug.traceback())
	
	if not(oUnit~=nil and oUnit~=0 and oUnit.ID>0) then
		return
	end
	if tParamEx==nil then
		tParamEx = __tParamEx
	end
	local nSkillLv = 1
	local tabS = hVar.tab_skill[nSkillId]
	if nSkillId~=0 and tabS~=nil and type(tabS.action)=="table" then
		if not(type(oTarget)=="table" and oTarget.ID>0) then
			oTarget = nil
		end
		local cast = tabS.cast_type
		--print("cast=" .. cast)
		if (cast == hVar.CAST_TYPE.SKILL_TO_UNIT) or (cast == hVar.CAST_TYPE.SKILL_TO_UNIT_IMMEDIATE) or (cast == hVar.CAST_TYPE.SKILL_TO_UNIT_MOVE_TO_POINT) then
			if oTarget==nil then
				oTarget = oUnit
				--print("目标不存在，直接返回，不释放本次技能")
				return --geyachao: 目标不存在，直接返回，不释放本次技能
			end
			if oTarget.data.IsDead==0 then
				--if tabS.cast_check==1 and hApi.IsSafeTarget(oUnit,nSkillId,oTarget)~=hVar.RESULT_SUCESS then
				--	return
				--end
				
				--geyachao: TD检测技能目标是否合法
				if (hApi.IsSkillTargetValid(oUnit, oTarget, nSkillId)~= hVar.RESULT_SUCESS) then
					--print(oUnit.data.name .. "A 技能释放失败, nSkillId=" .. tostring(nSkillId))
					return
				end
				
				if nManaCost==-1 then
					nManaCost = hApi.UnitUseManaByCast(oUnit,nSkillId,tabS.manacost,"auto")
				end
				--print("hClass.action:new", oUnit.data.name, oTarget.data.name, oTarget.data.id, nSkillId)
				return hClass.action:new(__ReadParam(tParamEx,{
					mode = "skill",
					cast = hVar.OPERATE_TYPE.SKILL_TO_UNIT,
					CastOrder = hVar.ORDER_TYPE.SYSTEM,
					skillId = nSkillId,
					manacost = nManaCost,
					power = nPower,
					unit = oUnit,
					target = oTarget,
					IsFacingTo = 0,
					IsNoTrigger = 1,
				}))
			end
		elseif (cast == hVar.CAST_TYPE.SKILL_TO_GROUND) or (cast == hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK) or (cast == hVar.CAST_TYPE.SKILL_TO_GROUND_MOVE_TO_POINT) or (cast == hVar.CAST_TYPE.SKILL_TO_GROUND_MOVE_TO_POINT_BLOCK) or (cast == hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY) then --geyachao: 对地面生效
			if nManaCost==-1 then
				nManaCost = hApi.UnitUseManaByCast(oUnit,nSkillId,tabS.manacost,"auto")
			end
			--print("释放xxxxxxxxxxxxxxxxxxxxxxxxxx")
			return hClass.action:new(__ReadParam(tParamEx,{
				mode = "skill",
				cast = hVar.OPERATE_TYPE.SKILL_TO_UNIT,
				CastOrder = hVar.ORDER_TYPE.SYSTEM,
				skillId = nSkillId,
				manacost = nManaCost,
				power = nPower,
				unit = oUnit,
				target = oTarget,
				gridX = gridX, --geyachao: 标记地面的x坐标
				gridY = gridY, --geyachao: 标记地面的y坐标
				IsFacingTo = 0,
				IsNoTrigger = 1,
			}))
		elseif cast==hVar.CAST_TYPE.IMMEDIATE or cast==hVar.CAST_TYPE.AUTO then
			if nManaCost==-1 then
				nManaCost = hApi.UnitUseManaByCast(oUnit,nSkillId,tabS.manacost,"auto")
			end
			
			--geyachao: 直接释放类，如果没填目标，那么对自己释放
			if (oTarget == nil) then
				oTarget = oUnit
			end
			
			--geyachao: TD检测技能目标是否合法，如果不合法，尝试对自己释放
			if (hApi.IsSkillTargetValid(oUnit, oTarget, nSkillId)~= hVar.RESULT_SUCESS) then
				--print(oUnit.data.name .. "B 技能释放失败, nSkillId=" .. tostring(nSkillId))
				--尝试对自己释放
				oTarget = oUnit
			end
			
			--geyachao: TD检测技能目标是否合法，如果不合法，返回
			if (hApi.IsSkillTargetValid(oUnit, oTarget, nSkillId)~= hVar.RESULT_SUCESS) then
				return
			end
			
			return hClass.action:new(__ReadParam(tParamEx,{
				mode = "skill",
				cast = hVar.OPERATE_TYPE.SKILL_IMMEDIATE,
				CastOrder = hVar.ORDER_TYPE.SYSTEM,
				skillId = nSkillId,
				manacost = nManaCost,
				power = nPower,
				unit = oUnit,
				target = oTarget,
				IsFacingTo = 0,
				IsNoTrigger = 1,
			}))
		elseif cast==hVar.CAST_TYPE.SKILL_TO_GRID then
			if nManaCost==-1 then
				nManaCost = hApi.UnitUseManaByCast(oUnit,nSkillId,tabS.manacost,"auto")
			end
			if not(gridX and gridY) and oTarget then
				local worldX,worldY = oUnit:getXY()
				gridX,gridY = hApi.GetGridByUnitAndXY(oTarget,"near",worldX,worldY)
			end
			return hClass.action:new(__ReadParam(tParamEx,{
				mode = "skill",
				cast = hVar.OPERATE_TYPE.SKILL_TO_GRID,
				CastOrder = hVar.ORDER_TYPE.SYSTEM,
				skillId = nSkillId,
				manacost = nManaCost,
				power = nPower,
				unit = oUnit,
				gridX = gridX,
				gridY = gridY,
				IsFacingTo = 0,
				IsNoTrigger = 1,
			}))
		end
	end
end

local __ENUM__RemoveStealth = function(oAction,tTemp)
	local tState = oAction.data.BuffState
	if type(tState)=="table" then
		for i = 1,#tState do
			if type(tState[i])=="table" and tState[i][2]=="stealth" then
				tTemp[#tTemp+1] = oAction
				return
			end
		end
	end
end

local __CODE__RemoveUnitStealth = function(oUnit,nSkillId)
	--移除潜行
	if oUnit.attr.stealth>0 then
		if nSkillId~=nil then
			local ai_type = hApi.GetSkillAIType(nSkillId)
			if ai_type=="Buff" then
				return
			end
		end
		local tBuff = {}
		oUnit:enumbuff(__ENUM__RemoveStealth,tBuff)
		if #tBuff>0 then
			for i = 1,#tBuff do
				local oBuff = tBuff[i]
				if oBuff and oBuff.ID~=0 then
					hApi.unbind2Object(oBuff,"bindU",oUnit,"buffs")
					oBuff.data.IsBuff = -1
					oBuff.data.IsPaused = 0
					oBuff:go("continue",1)
				end
			end
		end
	end
end

local __AssistKeyOfCast = {
	["#CAST"] = 1,
	["#CAST_MANA"] = 1,
}

hGlobal.event["Event_UnitStartCast"] = function(oWorld,IsAutoOrder,nCastOrder,nOperate,oUnit,nSkillId,oTarget,gridX,gridY)
	local oRound = oWorld:getround()
	if nSkillId<0 then
		nSkillId = math.abs(nSkillId)
	end
	local tabS = hVar.tab_skill[nSkillId]
	if tabS==nil then
		_DEBUG_MSG("无此技能！",oUnit.data.id,nSkillId)
		return hVar.RESULT_FAIL
	end
	if nCastOrder==hVar.ORDER_TYPE.SYSTEM or nCastOrder==hVar.ORDER_TYPE.SYSTEM_FIRST_ROUND then
		--这俩命令不判断眩晕
	elseif oUnit.attr.stun>0 then
		if nCastOrder==hVar.ORDER_TYPE.COUNTER then
			--反击这个没log
			return hVar.RESULT_FAIL
		else
			_DEBUG_MSG("单位眩晕，无法使用技能！",oUnit.data.id,nSkillId)
			return hVar.RESULT_FAIL
		end
	end
	if nOperate==hVar.OPERATE_TYPE.SKILL_TO_UNIT and oTarget==nil then
		_DEBUG_MSG("[LUA WARNING] order:SKILL_TO_UNIT 必须拥有参数[技能目标]！")
		return hVar.RESULT_FAIL
	end
	local nManaRequire = tabS.manacost or 0
	local UseSkillCount = 1
	local nCoolDown = tabS.cooldown or 0
	local oMp = oUnit.attr.mp
	local oHero = oUnit:gethero()
	local sData = oUnit:getskill(nSkillId)
	local sDataOld
	local IsFacingTo = 1
	local IsCast = 0
	local IsAttack = 0
	local nDamageType = 0
	local IsUnitStealth = 0
	if oUnit.attr.stealth>0 then
		IsUnitStealth = 1
	end
	if tabS.FacingToTarget==0 then
		--如果该技能禁止转向，那么不转向
		IsFacingTo = 0
	end
	if type(tabS.IsAttack)=="number" then
		--如果强行指定该技能是否普攻
		IsAttack = tabS.IsAttack
	elseif nSkillId==hApi.GetDefaultSkill(oUnit) then
		--如果等于默认技能，那么视为attack
		IsAttack = 1
	end
	if nCastOrder==hVar.ORDER_TYPE.COPY_CAST then
		--复制施法，最高优先级，不计算消耗，也不处理冷却
		nManaRequire = 0
		nCoolDown = 0
		UseSkillCount = 0
	elseif nCastOrder==hVar.ORDER_TYPE.COUNTER then
		IsAttack = 1
		UseSkillCount = 0
		--反击流程，不计算冷却
		--如果是反击命令的话，尝试扣除反击次数
		if oUnit.attr.counter<=0 then
			--如果反击次数已耗尽，那么不反击，跳过此命令
			return hVar.RESULT_FAIL
		else
			--扣除一次反击机会
			oUnit.attr.counter = oUnit.attr.counter - 1
			--增加1次当前阶段反击记录
			oUnit.attr.countercount = oUnit.attr.countercount + 1
		end
	elseif nCastOrder==hVar.ORDER_TYPE.AFTER_COUNTER then
		--必须反击成功才触发的技能，反击失败则不触发
		if oUnit.attr.countercount<=0 then
			return hVar.RESULT_FAIL
		end
	elseif nCastOrder==hVar.ORDER_TYPE.NORMAL then
		--普通命令检测
		if sData==nil then
			--特殊技能,无消耗无冷却
			--但是依然需要判断此技能是否可用
			if hApi.IsSkillAvailable(oUnit,nSkillId)~=hVar.RESULT_SUCESS then
				_DEBUG_MSG("not have skill!",nSkillId,tabS.name)
				return hVar.RESULT_FAIL
			end
		else
			--一般技能
			local _,_,cd,count = unpack(sData)
			if cd>0 then
				_DEBUG_MSG("skill is still in cooldown!",nSkillId,tabS.name)
				return hVar.RESULT_FAIL
			elseif count<0 then
				_DEBUG_MSG("skill is out of stack!",nSkillId,tabS.name)
				return hVar.RESULT_FAIL
			end
			--判断是否满足了魔法消耗
			if nManaRequire~=0 and oUnit.attr.mp<nManaRequire then
				_DEBUG_MSG("not enough mana!",nSkillId,tabS.name)
				return hVar.RESULT_FAIL
			end
		end
	else
		--其余情况不做任何特殊检测
	end
	--扣蓝
	--if manaCost~=0 then
		--oUnit.attr.mp = math.max(0,math.min(oUnit.attr.mxmp,oUnit.attr.mp - manaCost))
	--end
	--一般技能
	if sData~=nil then
		--判断此技能的施展模式等于"施放"
		IsCast = 1
		sDataOld = {}		--存战报用的技能上次冷却
		for i = 1,#sData do
			sDataOld[i] = sData[i]
		end
		--进入cd
		if nCoolDown>0 then
			sData[3] = nCoolDown + 1
		end
		--扣除使用次数
		if sData[4]>0 and UseSkillCount==1 then
			sData[4] = sData[4] - 1
			if sData[4]<=0 then
				sData[4] = -1
			end
		end
	end
	--尝试进行技能转换
	local tReplaceID = oUnit.attr.replaceID
	if type(tabS.replace)=="string" and #tReplaceID>0 then
		local sReplaceType = tabS.replace
		--替换技能(使用最后一个)
		--{sMatchKey,sReplaceKey,nReplaceID,tRplaceOrder}
		for i = 1,#tReplaceID do
			local v = tReplaceID[i]
			if v~=0 then
				local sMatchKey,sReplaceKey,nReplaceID,tRplaceOrder = v[1],v[2],v[3],v[4]
				local tabSR = hVar.tab_skill[nReplaceID]
				if sReplaceKey==sReplaceType and tabSR and tabSR.cast_type==tabS.cast_type and (tRplaceOrder==0 or hApi.HaveValue(tRplaceOrder)) then
					nSkillId = nReplaceID
					tabS = tabSR
				end
			end
		end
	end
	--设置元素伤害属性
	if tabS.damage_type then
		nDamageType = tabS.damage_type
	end
	--扣蓝处理
	local nManaCost = hApi.UnitUseManaByCast(oUnit,nSkillId,nManaRequire,"cast")
	--检查自动施放技能
	local NeedAssistCast = 0
	if nCastOrder==hVar.ORDER_TYPE.NORMAL and sData~=nil and type(oRound.data.AssistUnit)=="table" then
		for k in pairs(__AssistKeyOfCast) do
			if (oRound.data.AssistUnit.key[k] or 0)>0 then
				NeedAssistCast = 1
				break
			end
		end
	end
	--真正施放技能的流程
	if nOperate==hVar.OPERATE_TYPE.SKILL_IMMEDIATE then
		oWorld:log({		--使用技能(自身)
			key = "cast_skill",
			id = nSkillId,
			cast = hVar.OPERATE_TYPE.SKILL_IMMEDIATE,
			CastOrder = nCastOrder,
			IsAttack = IsAttack,
			IsCast = IsCast,
			gridX = gridX,
			gridY = gridY,
			unit = {
				objectID = oUnit.ID,
				id = oUnit.data.id,
				indexOfTeam = oUnit.data.indexOfTeam,
				owner = oUnit.data.owner,
			},
		})
		if NeedAssistCast==1 then
			oRound:checkassist(oUnit,oUnit,__AssistKeyOfCast,nSkillId)
		end
		--IMMEDIATE的释放方式信任传入的gridX和gridY
		--有一类调用是自身施放但是会传送到目标地点，为什么这么写呢。。
		local action = hClass.action:new({
			mode = "skill",
			cast = hVar.OPERATE_TYPE.SKILL_IMMEDIATE,
			skillId = nSkillId,
			IsCast = IsCast,
			IsAttack = IsAttack,
			damageType = nDamageType,
			manacost = nManaCost,
			CastOrder = nCastOrder,
			unit = oUnit,
			targetC = oUnit,
			gridX = gridX,
			gridY = gridY,
		})
		if oRound.data.auto==0 then
			oRound:closeallorder()
			oRound:auto(oUnit,action)
		end
		if IsUnitStealth==1 then
			__CODE__RemoveUnitStealth(oUnit,nSkillId)
		end
		return hVar.RESULT_SUCESS,action
	elseif nOperate==hVar.OPERATE_TYPE.SKILL_TO_UNIT then
		if oTarget~=nil then
			local nGridX,nGridY
			if tabS.selectXY~=nil and gridX and gridY then
				nGridX,nGridY = gridX,gridY
			end
			oWorld:log({		--使用技能(目标)
				key = "cast_skill",
				id = nSkillId,
				cast = hVar.OPERATE_TYPE.SKILL_TO_UNIT,
				CastOrder = nCastOrder,
				IsAttack = IsAttack,
				IsCast = IsCast,
				gridX = nGridX,
				gridY = nGridY,
				unit = {
					objectID = oUnit.ID,
					id = oUnit.data.id,
					indexOfTeam = oUnit.data.indexOfTeam,
					owner = oUnit.data.owner,
				},
				target = {
					objectID = oTarget.ID,
					id = oTarget.data.id,
					indexOfTeam = oTarget.data.indexOfTeam,
					owner = oTarget.data.owner,
				},
			})
			if NeedAssistCast==1 then
				oRound:checkassist(oUnit,oTarget,__AssistKeyOfCast,nSkillId)
			end
			--普攻额外技能处理
			if IsAttack==1 then
				if type(oUnit.attr.BeforeAttackID)=="table" then
					local tCastParam = {
						IsAttack=0,
						IsCast=0,
						damageType = nDamageType,
						IsShowPlus = -1,
						targetC = oTarget,
						tempValue = {["@aid"] = nSkillId},
					}
					for i = 1,#oUnit.attr.BeforeAttackID do
						local v = oUnit.attr.BeforeAttackID[i]
						if type(v)=="table" then
							local id = v[1]
							local ex = v[2]
							local CanCast = 0
							if v[2]==0 then
								--非反击类有效
								if nCastOrder~=hVar.ORDER_TYPE.COUNTER then
									CanCast = 1
								end
							elseif v[2]==1 then
								--仅普通命令有效
								if nCastOrder==hVar.ORDER_TYPE.NORMAL then
									CanCast = 1
								end
							elseif v[2]==2 then
								--仅反击命令有效
								if nCastOrder==hVar.ORDER_TYPE.COUNTER then
									CanCast = 1
								end
							end
							if CanCast==1 then
								hApi.CastSkill(oUnit,id,-1,nil,oTarget,nGridX,nGridY,tCastParam)
							end
						end
					end
				end
				if oUnit.attr.NextAttackID~=0 then
					nSkillId = oUnit.attr.NextAttackID
					oUnit.attr.NextAttackID = 0
				end
			end
			local action = hClass.action:new({
				mode = "skill",
				cast = hVar.OPERATE_TYPE.SKILL_TO_UNIT,
				skillId = nSkillId,
				IsCast = IsCast,
				IsAttack = IsAttack,
				damageType = nDamageType,
				manacost = nManaCost,
				CastOrder = nCastOrder,
				unit = oUnit,
				target = oTarget,
				targetC = oTarget,
				gridX = nGridX,
				gridY = nGridY,
				IsFacingTo = IsFacingTo,
			})
			if oRound.data.auto==0 then
				oRound:closeallorder()
				oRound:auto(oUnit,action)
			end
			if IsUnitStealth==1 then
				if oTarget==oUnit then
					__CODE__RemoveUnitStealth(oUnit,nSkillId)
				else
					__CODE__RemoveUnitStealth(oUnit)
				end
			end
			return hVar.RESULT_SUCESS,action
		else
			return hVar.RESULT_FAIL,nil
		end
	elseif nOperate==hVar.OPERATE_TYPE.SKILL_TO_GRID then
		local nGridX,nGridY
		if gridX and gridY then
			nGridX,nGridY = gridX,gridY
		else
			nGridX,nGridY = oUnit.data.gridX,oUnit.data.gridY
		end
		oWorld:log({		--使用技能(范围)
			key = "cast_skill",
			id = nSkillId,
			cast = hVar.OPERATE_TYPE.SKILL_IMMEDIATE,
			CastOrder = nCastOrder,
			IsAttack = IsAttack,
			IsCast = IsCast,
			gridX = nGridX,
			gridY = nGridY,
			unit = {
				objectID = oUnit.ID,
				id = oUnit.data.id,
				indexOfTeam = oUnit.data.indexOfTeam,
				owner = oUnit.data.owner,
			},
		})
		if NeedAssistCast==1 then
			oRound:checkassist(oUnit,nil,__AssistKeyOfCast,nSkillId,nGridX,nGridY)
		end
		if oWorld.data.IsQuickBattlefield~=1 and oUnit.data.type~=hVar.UNIT_TYPE.BUILDING then
			if nGridX==oUnit.data.gridX and nGridY==oUnit.data.gridY then
				--单位对自己格子施放范围技能的时候永远不进行转向
			elseif IsFacingTo~=0 then
				local tx,ty = oWorld:grid2xy(nGridX,nGridY)
				oUnit:facetoXY(tx,ty,1)
			end
		end
		local action = hClass.action:new({
			mode = "skill",
			cast = hVar.OPERATE_TYPE.SKILL_TO_GRID,
			skillId = nSkillId,
			IsCast = IsCast,
			IsAttack = IsAttack,
			damageType = nDamageType,
			manacost = nManaCost,
			CastOrder = nCastOrder,
			unit = oUnit,
			gridX = nGridX,
			gridY = nGridY,
			IsFacingTo = IsFacingTo,
		})
		if oRound.data.auto==0 then
			oRound:closeallorder()
			oRound:auto(oUnit,action)
		end
		if IsUnitStealth==1 then
			__CODE__RemoveUnitStealth(oUnit)
		end
		return hVar.RESULT_SUCESS,action
	else
		return hVar.RESULT_FAIL
	end
end

local __ENUM__UseFleeCount = function(oAction,tParam)
	if tParam.sus==0 then
		local u = oAction.data.unit
		local tState = oAction.data.BuffState
		if type(tState)=="table" and u~=0 and u.data.IsDead~=1 then
			for i = 1,#tState do
				if tState[i]~=0 and tState[i][2]=="flee" and type(oAction.data.tempValue)=="table" and (oAction.data.tempValue["@flee"] or 0)>0 then
					oAction.data.tempValue["@flee"] = oAction.data.tempValue["@flee"] - 1
					tParam.sus = 1
					return
				end
			end
		end
	end
end

local __AssistKeyOfCounter = {["#COUNTER"] = 1}
hGlobal.event["Event_UnitCastSkill"] = function(oUnit,nSkillId,oAction)
	local oWorld = oUnit:getworld()
	if oWorld and oWorld.data.type=="battlefield" then
		local oRound = oWorld:getround()
		local oTarget = oAction.data.target
		if type(oTarget)~="table" then
			oTarget = nil
		end
		if oRound~=nil and oAction.data.IsNoTrigger~=1 and type(oAction.data.action)=="table" and #oAction.data.action>0 then
			--转向
			if oTarget~=nil and oUnit.data.type~=hVar.UNIT_TYPE.BUILDING and oAction.data.IsFacingTo==1 then
				if oTarget==oUnit then
					--以自己为目标的技能不会导致转向
				else
					local tx,ty = oTarget:getXY()
					oUnit:facetoXY(tx,ty,1)
				end
			end
			--反击与协助
			local NeedCounter = 0
			local NeedAssist = 0
			local AssiatTab = oRound.data.AssistUnit
			local aKey = AssiatTab.key
			local aFlag = AssiatTab.flag
			--判断是否允许条件触发技能
			if oAction.data.CastOrder==hVar.ORDER_TYPE.NORMAL then
				if (aKey["#ATTACK"] or 0)>0 and oAction.data.IsAttack==1 then
					NeedAssist = 1
				end
				local tA = oAction.data.action
				for k,v in pairs(aFlag) do
					aFlag[k] = 0
				end
				for i = 1,#tA do
					local key = tA[i][1]
					if key=="CombatDamage" then
						NeedCounter = 1
					end
					if (aKey[key] or 0)>0 then
						aFlag[key] = 1
						NeedAssist = 1
					end
				end
			end
			--判断闪避(眩晕状态下不能触发闪避)
			if oTarget~=nil and oAction.data.IsAttack==1 and oTarget.attr.flee>0 and oTarget.attr.stun<=0 then
				if oTarget.attr.fleecount>0 then
					--本轮行动已经触发过闪避
					oTarget.attr.fleecount = oTarget.attr.fleecount + 1
					oAction.data.IsFlee = 1
				elseif oTarget.attr.fleecount==0 then
					--本轮行动还未触发闪避
					local tParam = {sus=0}
					oTarget:enumbuff(__ENUM__UseFleeCount,tParam)
					if tParam.sus==1 then
						oAction.data.IsFlee = 1
						oTarget.attr.fleecount = 1
					end
				end
			end
			--击中回血(#MELEE 和 #RANGE 都可以触发)
			if oAction.data.IsFlee==0 and oUnit.attr.attackHeal>0 and oTarget and oTarget~=oUnit then
				local IsAttack = 0
				for i = 1,#oAction.data.action do
					local v = oAction.data.action
					if v[i][1]=="#MELEE" or v[i][1]=="#RANGE" then
						IsAttack = 1
						break
					end
				end
				if oAction.data.IsAttack==1 or IsAttack==1 then
					local x,y = oUnit:getXY()
					oWorld:addeffect(18,1,nil,x,y,oUnit.data.facing,100)
					hGlobal.event:call("Event_UnitHealed",oUnit,nSkillId,0,oUnit.attr.attackHeal,0,oUnit)
				end
			end
			--反击检查
			local CounterId = 0
			local cRMin,cRMax
			if oTarget~=nil and NeedCounter==1 and oUnit.attr.stealth<=0 and oUnit.attr.fearful<=0 and oTarget.data.type~=hVar.UNIT_TYPE.BUILDING and oUnit.data.owner~=oTarget.data.owner and oTarget.attr.counter>0 and oTarget.attr.stun<=0 then
				local id = hApi.GetDefaultSkill(oTarget,"counter")
				if id~=0 then
					local rMin,rMax = hApi.GetSkillRange(id,oTarget)
					if rMax<0 then
						--远程反击
						CounterId = id
						cRMin = nil
						cRMax = nil
					else
						local v = oWorld:distanceU(oTarget,oUnit,1)
						if v>=rMin and v<=rMax then
							--如果敌人在反击范围内的话，反击敌人
							CounterId = id
							cRMin = rMin
							cRMax = rMax
						end
					end
				end
			end
			--if CounterId~=0 and aKey["#COUNTER"]~=nil then
				--NeedAssist = 1
				--aFlag["#COUNTER"] = 1
			--end
			--协助攻击
			if NeedAssist==1 and #AssiatTab>0 and hVar.tab_skill[nSkillId] then
				if (aKey["#COUNTER"] or 0)>0 then
					aFlag["#COUNTER"] = 0
				end
				local nCastType = hVar.tab_skill[nSkillId].cast_type
				--如果是普通攻击，那么加入#ATTACK判断(只允许目标类普通攻击协助)
				if oAction.data.IsAttack==1 and nCastType==hVar.CAST_TYPE.SKILL_TO_UNIT then
					aFlag["#ATTACK"] = 1
				else
					aFlag["#ATTACK"] = 0
				end
				if nCastType==hVar.CAST_TYPE.IMMEDIATE then
					oRound:checkassist(oUnit,oUnit,aFlag,nSkillId)
				elseif nCastType==hVar.CAST_TYPE.SKILL_TO_UNIT then
					if oTarget~=nil then
						oRound:checkassist(oUnit,oTarget,aFlag,nSkillId)
					end
				elseif nCastType==hVar.CAST_TYPE.SKILL_TO_GRID then
					oRound:checkassist(oUnit,nil,aFlag,nSkillId)
				end
			end
			--可发动反击
			if oTarget~=nil and CounterId~=0 then
				oRound:autoorder(200,oTarget,hVar.ORDER_TYPE.COUNTER,hVar.OPERATE_TYPE.SKILL_TO_UNIT,oUnit,CounterId,cRMin,cRMax)
				--如果可以反击，那么进行协助反击(协助反击的执行过程要靠后)
				if (aKey["#COUNTER"] or 0)>0 and #AssiatTab>0 then
					oRound:checkassist(oTarget,oUnit,__AssistKeyOfCounter,nSkillId)
				end
			end
		end
		if oWorld.data.IsQuickBattlefield==1 then
			return
		end
	end
	return hGlobal.event:event("Event_UnitCastSkill",oUnit,nSkillId,oAction)
end

hGlobal.event["Event_UnitStepMove"] = function(oWorld,oUnit,worldX,worldY)
	return hGlobal.event:event("Event_UnitStepMove",oWorld,oUnit,worldX,worldY)
end

hGlobal.event["Event_UnitBorn"] = function(oUnit)
	local oWorld = oUnit:getworld()
	if oWorld.data.type=="battlefield" then
		--战场log:单位出生
		--oWorld:log({
			--key = "unit_born",
			--unit = {
				--objectID = oUnit.ID,
				--id = oUnit.data.id,
				--name = oUnit.handle.name,
				--indexOfTeam = oUnit.data.indexOfTeam,
				--owner = oUnit.data.owner,
			--},
		--})
	end

	--zhenkira: 处理战术技能卡
	oWorld:tacticsTakeEffect(oUnit)

	return hGlobal.event:event("Event_UnitBorn",oUnit)
end

--TD有路点的单位，走到终点到达的事件
hGlobal.event["LocalEvent_TD_UnitReached"] = function(oUnit)
	local world = hGlobal.WORLD.LastWorldMap
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end
	
	--[[
	if (mapInfo.mapMode == hVar.MAP_TD_TYPE.NORMAL) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.DIFFICULT) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then --普通模式、挑战难度模式
		--触发单位到达终点特殊处理回调
		if On_Unit_Reached_Special_Event then
			--安全执行
			hpcall(On_Unit_Reached_Special_Event, oUnit)
			--On_Unit_Reached_Special_Event(oUnit)
		end
		
		--普通模式，触发到达路点终点事件
		hGlobal.event:event("LocalEvent_TD_UnitReached", oUnit)
		
		oUnit.attr.hp = 0
		oUnit.data.IsDead = 1
		oUnit:del()
	elseif (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
		--PVP模式，角色的路点设置为无，它变成了一个无路点单位
		oUnit:setRoadPoint(0)
		
		--设置ai状态为闲置
		oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
		
		--触发到达路点终点事件
		--hGlobal.event:event("LocalEvent_TD_UnitReached", oUnit)
	end
	]]
	
	--触发单位到达终点特殊处理回调
	if On_Unit_Reached_Special_Event then
		--安全执行
		hpcall(On_Unit_Reached_Special_Event, oUnit)
		--On_Unit_Reached_Special_Event(oUnit)
	end
	
	--普通模式，触发到达路点终点事件
	hGlobal.event:event("LocalEvent_TD_UnitReached", oUnit)
	
	--获得单位所属波次(目前只有发兵需要检测)
	local wave = oUnit:getWaveBelong()
	--设置波次角色被消灭或漏怪
	hApi.SetUnitInWaveKilled(wave)
	
	--清除单位死亡后事件
	--清除世界检测
	--local world = self:getworld()
	local cha_worldC = oUnit:getworldC()
	world.data.Trigger_OnUnitDead_UnitList[cha_worldC] = nil
	
	--删除角色
	oUnit.attr.hp = 0
	oUnit.data.IsDead = 1
	oUnit:del()
end

local __ENUM__DamageToShield = function(oAction,tParam,tActionDead)
	if tParam.dmg<=0 and oAction.data.IsBuff~=-1 then
		return
	end
	local v = oAction.data.tempValue
	local n = v["@exhp"]
	if n and type(n)=="number" and n>0 then
		if n>tParam.dmg then
			--护盾还在
			v["@exhp"] = n - tParam.dmg
			tParam.dmg = 0
		else
			--护盾爆了
			v["@exhp"] = 0
			tParam.dmg = tParam.dmg - n
			tActionDead[#tActionDead+1] = oAction
		end
	end
end

local __CODE__ShieldExplode = function(oAction,oUnit)
	local a = oAction.data.action
	for i = 1,#a do
		if a[i][1]=="#explode" then
			oAction.data.actionIndex = i - 1
			return oAction:go("continue",1)
		end
	end
	hApi.unbind2Object(oAction,"bindU",oUnit,"buffs")
	oAction.data.IsBuff = -1
	oAction.data.IsPaused = 0
	return oAction:go("continue",1)
end

local __CODE__DamageToShield = function(oWorld,oUnit,nDmgToShield)
	oUnit.attr.exhp = math.max(0,oUnit.attr.exhp - nDmgToShield)
	local tActionDead = {}
	oUnit:enumbuff(__ENUM__DamageToShield,{dmg=nDmgToShield},tActionDead)
	--有盾爆掉了！
	if #tActionDead>0 then
		for i = 1,#tActionDead do
			--单位死了就算了
			if oUnit.data.IsDead~=0 then
				return
			end
			__CODE__ShieldExplode(tActionDead[i],oUnit)
		end
	end
end

hGlobal.event["Event_UnitDamaged"] = function(oUnit,nSkillId,nDmgMode,nDmg,_,oAttacker,vTemp, oAttackerSide, oAttackerPos)
	--print("Event_UnitDamaged", oUnit.data.name, "nDmg=" .. nDmg, "oAttacker=", oAttacker and oAttacker.data.name, oAttackerSide, oAttackerPos) --geyachao
	local id,mode,dmg = nSkillId,nDmgMode,nDmg
	local tDamageData = vTemp or {}
	tDamageData.id = id
	tDamageData.dmg = dmg
	tDamageData.mode = mode
	tDamageData.dhp = 0
	hGlobal.event:event("Event_BeforeUnitDamaged",oUnit,tDamageData,oAttacker)
	if tDamageData.id~=id and type(tDamageData.id)=="number" and hVar.tab_skill[tDamageData.id]~=nil then
		id = tDamageData.id
	end
	if tDamageData.mode~=mode and tDamageData.mode~=nil then
		mode = tDamageData.mode
	end
	if tDamageData.dmg~=dmg and type(tDamageData.dmg)=="number" then
		dmg = tDamageData.dmg
	end
	tDamageData = nil
	local ohp = oUnit.attr.hp
	local ostack = oUnit.attr.stack
	local oHero = oUnit:gethero()
	local oWorld = oUnit:getworld()
	local nAbsorb = 0
	if dmg>0 then
		--增加攻击者的伤害统计
		if oAttacker and (oAttacker ~= 0) then --geyachao: 避免没传入攻击者
			oAttacker.attr.DamageCount = oAttacker.attr.DamageCount + dmg
		end
		
		--检查护盾
		if oUnit.attr.exhp>0 then
			nAbsorb = math.min(dmg,oUnit.attr.exhp)
			dmg = dmg - nAbsorb
			--对单位的护盾造成伤害
			__CODE__DamageToShield(oWorld,oUnit,nAbsorb)
		end
	end
	--单位受伤流程(伤害已被护盾减免过)
	if dmg<=0 then
		--没造成伤害
		if oWorld.data.IsQuickBattlefield~=1 then
			hGlobal.event:event("Event_UnitDamaged", oUnit, id, mode, 0, 0, oAttacker, nAbsorb, oAttackerSide, oAttackerPos)
		end
	else
		--造成了伤害
		
		--处理伤害前特殊处理事件
		if On_Hp_Dmg_Before_Special_Event then
			--oDmgUnit, skillId, mode, dmg, oAttacker
			dmg = On_Hp_Dmg_Before_Special_Event(oUnit, id, mode, dmg, oAttacker, oAttackerSide, oAttackerPos)
		end
		
		--防止脏数据
		ohp = oUnit.attr.hp
		
		local dhp, nLost = oUnit:calculate("SufferDamage", oAttacker, dmg, id, mode)
		--print("造成了伤害, dhp=" .. dhp .. ", nLost=" .. nLost) --geyachao: print
		nLost = math.min(oUnit.attr.stack, nLost)
		oUnit.attr.hp = ohp - dmg --geyachao: 修改写法 oUnit.attr.hp = ohp - dhp
		if (oUnit.attr.hp < 0) then
			oUnit.attr.hp = 0
		end
		
		--geyachao: 同步日志: 造成伤害
		if (hVar.IS_SYNC_LOG == 1) then
			local msg = "unitdmg: oUnit=" .. oUnit.data.id .. ",u_ID=" .. oUnit:getworldC() .. ",hp=" .. oUnit.attr.hp
			hApi.SyncLog(msg)
		end
		
		if (hVar.OPTIONS.SHOW_DMG_DPS_FLAG == 1) then --如果统计了伤害和dps
			if (oUnit:getowner():getforce() ~= oWorld:GetPlayerMe():getforce()) then --敌方单位
				local w = hGlobal.WORLD.LastWorldMap
				local dmgValid = ohp - oUnit.attr.hp
				w.data.statistics_dmg_sum = w.data.statistics_dmg_sum + dmgValid --统计总有效伤害
			end
		end
		
		--print("oUnit.attr.hp=" .. oUnit.attr.hp .. ", oUnit=" .. oUnit.data.name) --geyachao: print
		oUnit.attr.stack = math.max(0,ostack - nLost)
		oUnit.attr.DamageTaken = oUnit.attr.DamageTaken + dhp
		if oHero and oUnit.attr.hp<=0 then
			oUnit.attr.stack = 0
			nLost = 1
		end
		if (oWorld.data.IsQuickBattlefield ~= 1) then
			hGlobal.event:event("Event_UnitDamaged", oUnit, id, mode, dmg, nLost, oAttacker, nAbsorb, oAttackerSide, oAttackerPos)
		end
		--geyachao: 战场log:伤害不要了
		--[[
		--战场log:伤害
		if oHero then
			oWorld:log({	--英雄伤害
				key = "hero_damaged",
				id = id,
				mode = mode,
				dmg = dmg,
				dhp = dhp,
				lost = nLost,
				unit = {
					objectID = oAttacker.ID,
					id = oAttacker.data.id,
					name = oAttacker.handle.name,
					indexOfTeam = oAttacker.data.indexOfTeam,
					owner = oAttacker.data.owner,
				},
				target = {
					objectID = oUnit.ID,
					id = oUnit.data.id,
					name = oUnit.handle.name,
					indexOfTeam = oUnit.data.indexOfTeam,
					owner = oUnit.data.owner,
					hero_objectID = oHero.ID,
				},
			})
		else
			oWorld:log({	--单位伤害
				key = "unit_damaged",
				id = id,
				mode = mode,
				dmg = dmg,
				dhp = dhp,
				lost = nLost,
				unit = {
					objectID = oAttacker.ID,
					id = oAttacker.data.id,
					name = oAttacker.handle.name,
					indexOfTeam = oAttacker.data.indexOfTeam,
					owner = oAttacker.data.owner,
				},
				target = {
					objectID = oUnit.ID,
					id = oUnit.data.id,
					name = oUnit.handle.name,
					indexOfTeam = oUnit.data.indexOfTeam,
					owner = oUnit.data.owner,
					--old = {
						--hp = ohp,
						--stack = ostack,
					--},
				},
			})
		end
		]]
		--_DEBUG_MSG(oUnit.data.name.." 受到了来自 "..oAttacker.data.name.." 的 "..dmg.." 点伤害(id="..id..")")
		--计算吸血
		--对自己造成的伤害不计算吸血
		if oAttacker~=nil and oAttacker~=oUnit and oAttacker.ID~=0 and oAttacker.data.IsDead~=1 and oAttacker.attr.hp>0 then
			local HealNum = 0
			if oAttacker.attr.hpSteal>0 then
				--吸血
				HealNum = hApi.getint(oAttacker.attr.hpSteal*dmg/100)
			end
			if HealNum>0 then
				--获得了治疗
				hGlobal.event:call("Event_UnitHealed",oAttacker,1,0,HealNum,0,oAttacker)
			end
		end
	end
	local sLinkTag = 0		--是否需要更改前缀
	local sNewAnimation = 0		--是否需要转换动画
	local nIsHit = 1		--是否播放受击动画
	local nHpCur
	if oUnit.attr.__stack>=1 and oUnit.attr.mxhp>0 then
		nHpCur = math.floor(100*math.max(0,oUnit.attr.hp+oUnit.attr.mxhp*(oUnit.attr.stack-1))/(oUnit.attr.__stack*oUnit.attr.mxhp))
		local nDamaged = 100 - nHpCur
		if oUnit.attr.damaged<nDamaged then
			local tabU = hVar.tab_unit[oUnit.data.id]
			if tabU then
				if tabU.type==hVar.UNIT_TYPE.BUILDING then
					nIsHit = 0
				end
				if tabU.animation and type(tabU.animation)=="table" then
					for i = 1,#tabU.animation do
						local v = tabU.animation[i]
						if (100-oUnit.attr.damaged)>=v[1] and (100-nDamaged)<=v[1] then
							sLinkTag = v[2]
							sNewAnimation = v[3]
						end
					end
				end
			end
			oUnit.attr.damaged = nDamaged
		end
		
	end
	--尝试播放动画
	if oUnit.handle._c and not(hApi.IsSpriteHaveAnimationList(oUnit.handle)) then
		if sLinkTag~=0 then
			if type(sLinkTag)=="string" then
				oUnit.handle.animationlink = sLinkTag.."_"
			else
				oUnit.handle.animationlink = 0
			end
		end
		if sNewAnimation~=0 then
			if type(sNewAnimation)=="string" then
				--oUnit:setanimation(sNewAnimation,1) --geyachao: 不要hit动作
			else
				--oUnit:setanimation(tostring(oUnit.handle._animation),1) --geyachao: 不要hit动作
			end
		elseif nIsHit==1 and oUnit.attr.stack>0 then
			--local _,sus = oUnit:safeanimation("hit") --geyachao: 不要hit动作
			if sus==hVar.RESULT_SUCESS then
				--oUnit:setanimation({"hit","stand"}) --geyachao: 不要hit动作
			end
		end
	end
	
	--如果需要计算hp
	--geyachao: 这里没oRound
	--if nHpCur~=nil then
	--	local oRound = oWorld:getround()
	--	oRound:onUnitHpLower(oUnit,nHpCur)
	--end
	
	--if oUnit.attr.stack<=0 and oUnit.data.IsDead==0 then
	--print("oUnit.data.IsDead=" .. oUnit.data.IsDead, " oUnit.attr.stack" ..  oUnit.attr.stack) --geyachao: print
	if (oUnit.data.IsDead == 0) and ((oUnit.attr.hp <= 0) or (oUnit.attr.stack <= 0)) then --geyachao: 修改写法
		hApi.BFUnitDeadLog(oWorld,oUnit,oAttacker,id)
		--print("oUnit:dead") --geyachao
		--xlLG("RoadPoint", "小兵被击杀, unit=" .. tostring(oUnit.data.name) .. "_" .. tostring(oUnit.__ID) .. ", 剩余路点_num=" .. #(oUnit:getRoadPoint()) .. "\n")
		return oUnit:dead(hVar.OPERATE_TYPE.SKILL_TO_UNIT, oAttacker, id, dmg, oAttackerSide, oAttackerPos)
	end
end

hApi.BFUnitDeadLog = function(oWorld,oUnit,oAttacker,nSkillId)
	--geyachao: TD不需要记录此log
	--[[
	--战场log:死亡
	if oWorld and oUnit and oAttacker then
		local level = 0
		local hero = 0
		local oHero = oUnit:gethero()
		if oHero then
			level = oHero.attr.level
			hero = 1
		end
		oWorld:log({	--死亡
			key = "unit_killed",
			unit = {
				objectID = oAttacker.ID,
				id = oAttacker.data.id,
				name = oAttacker.handle.name,
				indexOfTeam = oAttacker.data.indexOfTeam,
				owner = oAttacker.data.owner,
			},
			target = {
				objectID = oUnit.ID,
				id = oUnit.data.id,
				name = oUnit.handle.name,
				indexOfTeam = oUnit.data.indexOfTeam,
				owner = oUnit.data.owner,
				stack = oUnit.attr.__stack,
				level = level,
				hero = hero,
			},
		})
	end
	]]
end

hGlobal.event["Event_UnitHealed"] = function(oUnit,nSkillId,nDmgMode,nHeal,_,oAttacker,vTemp)
	local id = nSkillId
	local mode = nDmgMode
	if nHeal>=0 then
		--计算治疗加成
		if nDmgMode<0 then
			--伤害模式小于0时
			if nDmgMode==-2 and oUnit.attr.healpower<0 then
				--伤害模式为-2时，受到负数的治疗加成影响
				nHeal = hApi.floor(nHeal*math.max(1,100+oUnit.attr.healpower)/100)
			end
		elseif oUnit.attr.healpower~=0 then
			--一般模式，受到治疗加成影响
			nHeal = hApi.floor(nHeal*math.max(1,100+oUnit.attr.healpower)/100)
		end
		local dmg = -1*nHeal
		local tDamageData = vTemp or {}
		tDamageData.id = id
		tDamageData.dmg = dmg
		tDamageData.mode = mode
		tDamageData.dhp = 0
		hGlobal.event:event("Event_BeforeUnitHealed",oUnit,tDamageData,oAttacker)
		if tDamageData.id~=id and type(tDamageData.id)=="number" and hVar.tab_skill[tDamageData.id]~=nil then
			id = tDamageData.id
		end
		if tDamageData.dmg~=dmg and type(tDamageData.dmg)=="number" then
			dmg = tDamageData.dmg
		end
		if tDamageData.mode~=mode and tDamageData.mode~=nil then
			mode = tDamageData.mode
		end
		tDamageData = nil
		--增加治疗者的治疗统计
		if dmg<0 then
			oAttacker.attr.HealCount = oAttacker.attr.HealCount - dmg
		end
		local ohp = oUnit.attr.hp
		local ostack = oUnit.attr.stack
		local mstack = oUnit.attr.__stack	--这里计算出可以救活单位的数量
		local dhp,nLost = oUnit:calculate("SufferDamage",oAttacker,dmg,id,mode)
		local nRevive = -1*nLost
		local oHero = oUnit:gethero()
		oUnit.attr.hp = ohp - dhp
		if oHero~=nil then
			--英雄没得救
		else
			oUnit.attr.stack = math.min(mstack,ostack + nRevive)
		end
		local oWorld = oUnit:getworld()
		local oWorld = oWorld
		if oWorld.data.IsQuickBattlefield~=1 then
			hGlobal.event:event("Event_UnitHealed",oUnit,id,mode,nHeal,nRevive,oAttacker)
		end
		--战场log:治疗
		if oHero then
			oWorld:log({	--英雄治疗
				key = "hero_healed",
				id = id,
				mode = mode,
				dmg = dmg,
				dhp = dhp,
				revive = nRevive,
				unit = {
					objectID = oAttacker.ID,
					id = oAttacker.data.id,
					name = oAttacker.handle.name,
					indexOfTeam = oAttacker.data.indexOfTeam,
					owner = oAttacker.data.owner,
				},
				target = {
					objectID = oUnit.ID,
					id = oUnit.data.id,
					name = oUnit.handle.name,
					indexOfTeam = oUnit.data.indexOfTeam,
					owner = oUnit.data.owner,
					hero_objectID = oHero.ID,
				},
			})
		else
			--[[
			oWorld:log({	--单位治疗
				key = "unit_healed",
				id = id,
				mode = mode,
				dmg = dmg,
				dhp = dhp,
				revive = nRevive,
				unit = {
					objectID = oAttacker.ID,
					id = oAttacker.data.id,
					name = oAttacker.handle.name,
					indexOfTeam = oAttacker.data.indexOfTeam,
					owner = oUnit.data.owner,
				},
				target = {
					objectID = oUnit.ID,
					id = oUnit.data.id,
					name = oUnit.handle.name,
					indexOfTeam = oUnit.data.indexOfTeam,
					owner = oUnit.data.owner,
					--old = {
						--hp = ohp,
						--stack = ostack,
					--},
				},
			})
			]]
		end
	else
		return hGlobal.event:call("Event_UnitDamaged",oUnit,nSkillId,nDmgMode,-1*nHeal,0,oAttacker, nil, oUnit:getowner():getforce(), oUnit:getowner():getpos())
	end
end

local __AssistKeyOfKill = {["#KILL"]=1}
hGlobal.event["Event_UnitDead"] = function(oUnit, nOperate, oKillerUnit, nId, vParam, oKillerSide, oKillerPos)
	--print("Event_UnitDead, oUnit=" .. oUnit.data.name, "oKillerUnit=", oKillerUnit and oKillerUnit.data.name) --geyachao
	local oWorld = oUnit:getworld()
	--if oWorld.data.type=="battlefield" then  --zhenkira：删除
	if oWorld.data.type=="worldmap" then
		local tabU = hVar.tab_unit[oUnit.data.id]
		if tabU==nil then
			--不知道什么东西死了
		elseif tabU.type==hVar.UNIT_TYPE.UNIT or tabU.type==hVar.UNIT_TYPE.HERO then
			--单位,英雄死亡
			local NeedEvent = 0
			local nUnitForce = oWorld.data.unitcount.idx[oUnit.__ID]
			if nUnitForce~=nil then
				NeedEvent = 1
				oWorld.data.unitcount[nUnitForce] = (oWorld.data.unitcount[nUnitForce] or 0) - 1
			end
			--print(oUnit.data.name.."死亡,属方"..oUnit.data.owner..",凶手:"..oKillerUnit.data.name.."属方"..oKillerUnit.data.owner.."剩余单位数量"..oWorld.data.unitcount[oUnit.data.owner])
			local fCodeOnRoundEnd
			if oWorld.data.IsQuickBattlefield==1 then
				--快速战场流程走这里
				if oWorld.data.unitcount[oUnit.data.owner]<=0 and NeedEvent==1 then
					local nPlayerV
					local nPlayerD = oUnit.data.owner
					for nOwner,nNum in pairs(oWorld.data.unitcount)do
						if type(nOwner)=="number" and type(nNum)=="number" and nNum>0 and nOwner~=oUnit.data.owner then
							nPlayerV = nOwner
						end
					end
					fCodeOnRoundEnd = function()
						oWorld:pause(1,"Victory")
						if nPlayerV and hGlobal.player[nPlayerV] then
							oWorld.handle.__oUnitV = oWorld:getlordU(nPlayerV)
						end
						if nPlayerD and hGlobal.player[nPlayerD] then
							oWorld.handle.__oUnitD = oWorld:getlordU(nPlayerD)
						end
					end
				end
			else
				--一般战场走通用函数
				if NeedEvent==1 then
					fCodeOnRoundEnd = hApi.CalculateUnitDeadBF(oUnit,oKillerUnit,nId,vParam)
				end
			end
			--死亡时移除光环信息
			oWorld:removeaura(oUnit)
			local oRound = oWorld:getround()
			if oRound~=nil then
				oRound:removeunit(oUnit)
				oRound:__loadbylength()
				--非召唤生物才会有击杀特殊处理
				if oUnit.data.IsSummoned==0 and type(oRound.data.AssistUnit)=="table" and (oRound.data.AssistUnit.key["#KILL"] or 0)>0 then
					oRound:checkassist(oKillerUnit,oUnit,__AssistKeyOfKill,nId)
				end
				if oWorld.data.IsQuickBattlefield~=1 and hGlobal.LocalPlayer:getfocusworld()==oWorld then
					hGlobal.event:event("LocalEvent_RoundChanged",oWorld,oRound)
				end
				--存在胜利或失败者时，在oRound:auto()之后将执行此代码
				if oRound.data.codeOnRoundEnd==0 and type(fCodeOnRoundEnd)=="function" then
					oRound.data.IsEnd = 1
					if oRound.data.auto==1 then
						--如果回合处在自动中，等待结束后执行
						oRound.data.codeOnRoundEnd = fCodeOnRoundEnd
					else
						--如果回合并非处在自动运行中，直接执行
						hpcall(fCodeOnRoundEnd)
					end
				end
			end
		elseif tabU.type_ex and (tabU.type_ex[1]=="GATE" or tabU.type_ex[1]=="WALL" or tabU.type_ex[1]=="TOWER") then
			--城墙跪了
			local tCover = oWorld.data.cover
			if tCover[oUnit.ID]==oUnit.__ID then
				tCover[oUnit.ID] = nil
				tCover.pec = tCover.pec+tCover.rpec
			end
		end
		
		--非TD地图，直接跳出循环
		local mapInfo = oWorld.data.tdMapInfo
		if (mapInfo) then
			local bIsReborn = false --是否是能重生复活的单位
			local tOwner = oUnit:getowner() --单位所属的阵营
			
			--如果自己是个英雄，既然自己已经死了，那么标记死亡的位置 --geyachao: 用于复活
			local oHero = oUnit:gethero()
			if oHero and (oHero:getunit("worldmap") == oUnit) then
				bIsReborn = true --是可以重生的单位
				
				local index = 0 --英雄的索引值
				--local owner = oUnit.data.owner
				local heros = tOwner.heros
				for i = 1, #heros, 1 do
					if (heros[i] == oHero) then
						index = i
						break
					end
				end
				
				--自己依然可以拿到目标英雄
				--oUnit.data.heroID = 0
				--[[
				--geyachao: 主动类战术技能，重算CD
				local activeSkillCDOrigin = oHero.data.activeSkillCDOrigin --原始CD（单位:秒）
				local activeSkillCDMul = activeSkillCDOrigin * 1000
				local active_skill_cd_delta = oUnit:GetActiveSkillCDDelta() --geyachao: cd附加改变值
				local active_skill_cd_delta_rate = oUnit:GetActiveSkillCDDeltaRate() --geyachao: cd附加改变比例值
				local delta = active_skill_cd_delta + hApi.floor(activeSkillCDMul * active_skill_cd_delta_rate / 100)
				activeSkillCDMul = activeSkillCDMul + delta
				local activeSkillCD = hApi.ceil(activeSkillCDMul / 1000)
				
				oHero.data.activeSkillCD = activeSkillCD --CD（单位:秒）
				]]
				oHero:bind(nil)
				
				--标记英雄的复活点
				local posX, posY = hApi.chaGetPos(oUnit.handle) --英雄的坐标
				oHero.data.deadX = posX --死亡时的x坐标 --geyachao: 新加大地图复活流程，记录死亡的位置
				oHero.data.deadY = posY --死亡时的y坐标 --geyachao: 新加大地图复活流程，记录死亡的位置
				
				--标记英雄死亡的次数加1
				local deadCount = oHero.data.deadCount
				oHero.data.deadCount = deadCount + 1
				
				--死亡的英雄头像灰掉
				if oHero.heroUI and oHero.heroUI["btnIcon"] then
					hApi.AddShader(oHero.heroUI["btnIcon"].handle.s, "gray")
				end
				
				--隐藏可能的英雄头像选中框
				if oHero.heroUI and oHero.heroUI["btnIcon"] and oHero.heroUI["btnIcon"].childUI["SelectBorder"] then
					oHero.heroUI["btnIcon"].childUI["SelectBorder"].handle._n:setVisible(false) --不显示
				end
				
				--pvp模式下，显示立即复活的控件
				if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
					--本局剩余购买复活英雄的次数
					local pos = oHero:getowner():getpos()
					local rebirth_count = oWorld.data.pvp_buy_rebirth_count[pos]
					
					if oHero.heroUI and oHero.heroUI["btnIcon"] and oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"] then
						oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"].handle._n:setVisible(true) --显示
					end
					if oHero.heroUI and oHero.heroUI["btnIcon"] and oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"] then
						oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"].handle._n:setVisible(true) --显示
						oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"]:setText("x" .. rebirth_count)
					end
					
					--设置复活次数颜色
					if (rebirth_count > 0) then
						if oHero.heroUI and oHero.heroUI["btnIcon"] and oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"] then
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"].handle.s:setColor(ccc3(255, 255, 255))
						end
						if oHero.heroUI and oHero.heroUI["btnIcon"] and oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"] then
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"].handle.s:setColor(ccc3(255, 255, 255))
						end
					else
						if oHero.heroUI and oHero.heroUI["btnIcon"] and oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"] then
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"].handle.s:setColor(ccc3(168, 168, 168))
						end
						if oHero.heroUI and oHero.heroUI["btnIcon"] and oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"] then
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"].handle.s:setColor(ccc3(168, 168, 168))
						end
					end
				end
				
				--在原地创建一个倒计时的单位
				--复活专用旗子角色
				local type_id = 0
				if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
					if (tOwner:getforce() == hVar.FORCE_DEF.SHU) then --蜀国
						type_id = 55556 --55555
					elseif (tOwner:getforce() == hVar.FORCE_DEF.WEI) then --魏国
						type_id = 55556
					end
				else --其他模式
					if (tOwner == oWorld:GetPlayerMe()) then --我方单位
						type_id = 55556 --55555
					elseif (tOwner == oWorld:GetForce(tOwner:getforce())) then --中立单位
						type_id = 55556 --55555
					elseif (tOwner:getforce() ~= oWorld:GetPlayerMe():getforce()) then --敌方单位
						type_id = 55556
					end
				end
				
				--读取单位的死亡后尸体单位
				local deadCreateUnit = tabU.deadCreateUnit
				if deadCreateUnit and (deadCreateUnit > 0) then
					type_id = deadCreateUnit
				end
				
				--local facing = hVar.UNIT_DEFAULT_FACING
				local facing = oUnit.data.facing
				local deadoUint = oWorld:addunit(type_id, 1, nil, nil, facing, posX, posY)
				deadoUint:setPos(posX, posY, facing)
				
				local rebirthtime = oUnit:GetRebirthTime() --复活时间（单位：毫秒）
				local rebirth_wudi_time = oUnit:GetRebirthWudiTime() --复活后无敌时间（单位：毫秒）
				local basic_weapon_level = oUnit:GetBasicWeaponLevel() --基础武器等级
				if (oUnit.data.bind_weapon ~= 0) then
					basic_weapon_level = oUnit.data.bind_weapon:GetBasicWeaponLevel() --基础武器等级
				end
				local basic_skill_level = oUnit:GetBasicSkillLevel() --基础技能等级
				local basic_skill_usecount = oUnit:GetGrenadeMultiply() --GetBasicSkillUseCount() --基础技能使用次数
				--print(oUnit.data.name, rebirthtime, basic_weapon_level, basic_skill_level, basic_skill_usecount)
				
				local basic_weapon_id = 0 --武器id
				if (oUnit.data.bind_weapon ~= 0) then
					basic_weapon_id = oUnit.data.bind_weapon.data.id --基础武器id
				end
				
				--geyachao:修改英雄复活时间的计算方法，每死一次，需要复活的时间就多一点
				rebirthtime = rebirthtime + deadCount * hVar.ROLE_REBIRTH_DEATH_TIME
				if (rebirthtime > hVar.ROLE_REBIRTH_MAX_TIME) then --复活最大时间（单位：毫秒）
					rebirthtime = hVar.ROLE_REBIRTH_MAX_TIME
				end
				if (rebirthtime < hVar.ROLE_REBIRTH_MIN_TIME) then --复活最小时间（单位：毫秒）
					rebirthtime = hVar.ROLE_REBIRTH_MIN_TIME
				end
				
				--如果复活时间增加，显示个浮动文字
				if (hVar.ROLE_REBIRTH_DEATH_TIME > 0) then
					--local showText = "复活时间+" .. (hVar.ROLE_REBIRTH_DEATH_TIME / 1000) .. "秒" --language
					local showText = hVar.tab_string["__Attr_Hint_rebirth_time"] .. "+" .. (hVar.ROLE_REBIRTH_DEATH_TIME / 1000) .. hVar.tab_string["__Second"] --language
					hApi.ShowLabelBubble(deadoUint, showText, ccc3(255, 64, 0), -15, 20, nil, 1500)
				end
				
				--复活倒计时进度条
				local dx = -17
				local dy = 50
				deadoUint.chaUI["rebirthProgress"] = hUI.valbar:new({
					parent = deadoUint.handle._n,
					x = dx - 20,
					y = dy,
					w = 60,
					h = 7,
					align = "LC",
					back = {model = "UI:BAR_ValueBar_BG", x = -2},
					model = "UI:IMG_ValueBar",
					animation = "blue",
					v = 1,
					max = 1,
					show = 1,
				})
				
				--复活倒计时文字
				deadoUint.chaUI["numberBar"] = hUI.label:new({
					parent = deadoUint.handle._n,
					font = "numGreen",
					--text = math.ceil(rebirthtime / 1000) .. "秒后复活", --language
					--text = math.ceil(rebirthtime / 1000) .. hVar.tab_string["__SecondToRelive"], --language
					text = math.ceil(rebirthtime / 1000),
					size = 20,
					align = "MC",
					x = dx + 11,
					y = dy + 15 + 2,
					border = 1,
				})
				if (tOwner == oWorld:GetPlayerMe()) then --我方单位
					deadoUint.chaUI["numberBar"].handle.s:setColor(ccc3(0, 255, 0))
				elseif (tOwner == oWorld:GetForce(tOwner:getforce())) or (tOwner:getforce() == oWorld:GetPlayerMe():getforce()) then --中立单位、我方其它势力的友军
					deadoUint.chaUI["numberBar"].handle.s:setColor(ccc3(255, 255, 0))
				elseif (tOwner:getforce() ~= oWorld:GetPlayerMe():getforce()) then --敌方单位
					deadoUint.chaUI["numberBar"].handle.s:setColor(ccc3(255, 0, 0))
				end
				deadoUint.chaUI["numberBar"].handle._n:setVisible(false)
				
				--[[
				--我方头像栏显示复活数字倒计时
				local CDLabel = nil
				if (tOwner == oWorld:GetPlayerMe()) then
					if oHero.heroUI["btnIcon"] then
						local _frm = hGlobal.UI.HeroFrame
						local frm_x, frm_y = _frm.data.x, _frm.data.y
						local hero_x, hero_y = oHero.heroUI["btnIcon"].data.x, oHero.heroUI["btnIcon"].data.y
						local pos_x, pos_y = frm_x + hero_x, frm_y + hero_y
						CDLabel = hUI.label:new({
							parent = nil,
							font = hVar.DEFAULT_FONT,
							border = 1,
							size = 50,
							align = "MC",
							x = pos_x,
							y = pos_y,
							text = "",
						})
					end
				end
				]]
				
				--geyachao: 统计我方英雄的死亡次数
				if (tOwner == oWorld:GetPlayerMe()) then
					local upos = tOwner:getpos()
					if (oWorld.data.statistics.deadCount[upos] == nil) then
						oWorld.data.statistics.deadCount[upos] = 0
					end
					oWorld.data.statistics.deadCount[upos] = oWorld.data.statistics.deadCount[upos] + 1 --geyachao: 本局对战中英雄死亡的次数
				end
				
				--geyachao: 我方英雄死亡时，检测是否有绑定的死亡后禁用的战术技能卡
				if (tOwner == oWorld:GetPlayerMe()) then
					local tacticCardCtrls = oWorld.data.tacticCardCtrls --战术技能卡控件集
					for i = 1, #tacticCardCtrls, 1 do
						local cardi = tacticCardCtrls[i]
						if cardi and (cardi ~= 0) then
							if (cardi.data.deadUnUse == 1) and (cardi.data.bindHero == oHero) then --死亡后禁用状态，并且是绑定的该英雄
								--禁用该战术卡
								cardi.childUI["ban"].handle.s:setVisible(true) --显示禁用的图标
								
								--取消该战术卡的选中状态
								if (cardi.data.selected == 1) then
									hApi.safeRemoveT(cardi.childUI, "selectbox") --删除选中特效
									cardi.data.selected = 0
								end
							end
						end
					end
				end
				
				--记录大菠萝英雄死亡的次数
				local diablodata = hGlobal.LocalPlayer.data.diablodata --大菠萝数据
				if (diablodata.deathcount == 0) then --第一次死亡
					diablodata.deathscore = diablodata.score --第一次死亡的得分
				end
				
				diablodata.lifecount = diablodata.lifecount - 1
				diablodata.deathcount = diablodata.deathcount + 1
				
				if diablodata and type(diablodata.randMap) == "table" then
					local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
					--阶段1不存储信息
					if tInfo.id then
						--没命且没购买次数
						--if diablodata.lifecount <= 0 and diablodata.canbuylife <= 0 then
							--清理太早导致总结算时没有数据
							--LuaClearPlayerRandMapInfo(g_curPlayerName)
						--else
							--记录随机地图数据
							local tInfos = {
								{"lifecount",diablodata.lifecount},
								{"deathcount",diablodata.deathcount},
								{"weaponlevel",1},
							}
							LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)
						--end
					end
				end
				
				local _frm = hGlobal.UI.TDSystemMenuBar
				--if _frm.childUI["Endless_ScorePrefixLabel"] then
				--	--_frm.childUI["Endless_ScorePrefixLabel"]:setText("死亡:" .. diablodata.deathcount .. "      首局得分:" .. diablodata.deathscore .. " ")
				--	_frm.childUI["Endless_ScorePrefixLabel"]:setText("死亡:" .. diablodata.deathcount)
				--end
				
				if (diablodata.lifecount <= 0) then
					--如果是战役地图的普通剧情模式，不需要弹出复活框
					--print("mapMode=", oWorld.data.tdMapInfo.mapMode)
					--print("MapDifficulty=", oWorld.data.MapDifficulty)
					if (oWorld.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.NORMAL) and (oWorld.data.MapDifficulty == 0) then
						if diablodata.canbuylife <= 0 then
							--游戏暂停
							hGlobal.event:event("Event_StartPauseSwitch", true)
							
							--大菠萝游戏结束结算
							local bResult = false
							TD_OnGameOver_Diablo(bResult)
							
							--大菠萝游戏结束,刷新界面
							local nResult = 0
							hGlobal.event:event("LocalEvent_GameOver_Diablo", nResult)
						end
						
						diablodata.canbuylife = diablodata.canbuylife - 1
					else
						--游戏暂停
						hGlobal.event:event("Event_StartPauseSwitch", true)
						
						--[[
						local MsgSelections = nil
						MsgSelections = {
							style = "mini",
							select = 0,
							ok = function()
								--继续暂停
								hGlobal.event:event("Event_StartPauseSwitch", false)
							end,
							cancel = function()
								--geyachao: 先存档
								--存档
								LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
								
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
								
								local w = hGlobal.WORLD.LastWorldMap
								local map = w.data.map
								local tabM = hVar.MAP_INFO[map]
								local chapterId = 1
								if tabM then
									chapterId = tabM.chapter or 1
								end
								--todo zhenkira 这里以后要读取当前地图所在章节进行切换
								
								--zhenkira 注释
								--if g_vs_number > 4 and g_lua_src == 1 then
								--	local mapname = hGlobal.WORLD.LastWorldMap.data.map
								--	if hApi.Is_WDLD_Map(mapname) ~= -1 then
								--		Game_Zone_OnGameEvent(GZone_Event_TypeDef.Leave,luaGetplayerDataID())
								--	end
								--end
								
								--if hGlobal.WORLD.LastTown~=nil then
								--	hGlobal.WORLD.LastTown:del()
								--end
								
								--zhenkira 注释
								local currentMapMode = hVar.MAP_TD_TYPE.NORMAL
								if (hGlobal.WORLD.LastWorldMap ~= nil) then
									--存储地图模式
									currentMapMode = hGlobal.WORLD.LastWorldMap.data.tdMapInfo and (hGlobal.WORLD.LastWorldMap.data.tdMapInfo.mapMode)
									
									local mapname = hGlobal.WORLD.LastWorldMap.data.map
									--if hApi.Is_RSYZ_Map(mapname) ~= -1 then
									--	print(".."..nil)
									--	Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleEnd_Fire,luaGetplayerDataID(),g_RSDYZ_BattleID})
									--end
									hGlobal.WORLD.LastWorldMap:del()
									
									hGlobal.LocalPlayer:setfocusworld(nil)
									hApi.clearCurrentWorldScene()
								end
								
								--无尽地图、pvp，返回新主界面
								if (currentMapMode == hVar.MAP_TD_TYPE.ENDLESS) or (currentMapMode == hVar.MAP_TD_TYPE.PVP) then --无尽地图、pvp
									--切换到新主界面事件
									hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
								else
									--zhenkira 注释
									--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
									--zhenkira 新增
									--hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", chapterId)
									--hGlobal.event:event("LocalEvent_Phone_ShowReturnContinue",1)
									--hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
									
									--大菠萝
									--切换到新主界面事件
									hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
								end
							end,
							--cancelFun = cancelCallback, --点否的回调函数
							textOk = "复活",
							textCancel = "退出",
							userflag = 0, --用户的标记
						}
						local showTitle = "游戏失败！"
						local msgBox = hGlobal.UI.MsgBox(showTitle, MsgSelections)
						msgBox:active()
						msgBox:show(1,"fade",{time=0.08})
						]]
						
						--[[
						local showTitle = "游戏失败！"
						hGlobal.UI.MsgBox(showTitle,{
							font = hVar.FONTC,
							ok = function()
								--zhenkira 注释
								--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
								--zhenkira 新增
								--hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", chapterId)
								--hGlobal.event:event("LocalEvent_Phone_ShowReturnContinue",1)
								--hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
								
								--大菠萝
								--切换到新主界面事件
								hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
							end,
						})
						]]
						if diablodata.canbuylife <= 0 then
							--大菠萝游戏结束结算
							local bResult = false
							TD_OnGameOver_Diablo(bResult)
							
							--大菠萝游戏结束,刷新界面
							local nResult = 0
							hGlobal.event:event("LocalEvent_GameOver_Diablo", nResult)
						else
							--显示购买命的界面
							hGlobal.event:call("Event_HeroBuyLife")
						end
					end
				end
				
				--普攻的等级界面刷新为1
				local tacticCardCtrls = oWorld.data.tacticCardCtrls --战术技能卡控件集
				local btn1 = tacticCardCtrls[hVar.NORMALATK_IDX]
				local lv1 = 0
				if btn1 and (btn1 ~= 0) then
					lv1 = btn1.childUI["labSkillLv"].handle.s:getString()
					btn1.childUI["labSkillLv"]:setText(basic_weapon_level) --普通攻击等级
					btn1.childUI["labSkillLv"].handle._n:setVisible(false)
					btn1.childUI["labSkillMana"].handle._n:setVisible(false)
				end
				--[[
				--大菠萝，技能不重置了
				--技能的等级界面刷新为1
				local btn2 = tacticCardCtrls[hVar.TANKSKILL_IDX]
				local lv2 = btn2.childUI["labSkillLv"].handle._n:getString()
				btn2.childUI["labSkillLv"]:setText(basic_skill_level) --技能等级
				
				--设置技能等级为1级
				local itemSkillT = oHero.data.itemSkillT
				if (itemSkillT) then
					local k = 1
					local activeItemId = itemSkillT[k].activeItemId --主动技能的id
					local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
					local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
					local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:秒）
					--print(activeItemId)
					
					--存储
					itemSkillT[k].activeItemLv = basic_skill_level
				end
				]]
				
				--掉落一半的武器
				--local weaopNum = lv1 + lv2 - basic_weapon_level - basic_skill_level --大菠萝，技能不重置了
				local weaopNum = lv1 - basic_weapon_level
				if (weaopNum < 0) then
					weaopNum = 0
				end
				local dropMin = math.min(weaopNum / 2) --最小值
				local dropMax = math.max(weaopNum / 2) --最大值
				if (dropMin < 0) then
					dropMin = 0
				end
				if (dropMax > weaopNum) then
					dropMax = weaopNum
				end
				local dropNum = oWorld:random(dropMin, dropMin)
				if (dropNum > 0) then
					for dn = 1, dropNum, 1 do
						local id = 12010 --掉落的道具id --提升武器等级
						local randId = oWorld:random(1, 2)
						if (randId == 1) then
							--id = 12008 --掉落的道具id --提升技能等级 --大菠萝，技能不重置了
						end
						local tabI = hVar.tab_item[id]
						local uId = tabI.dropUnit or 20001
						
						local deadUnitX, deadUnitY = hApi.chaGetPos(oUnit.handle) --死亡的单位的坐标
						--local gridX, gridY = oWorld:xy2grid(deadUnitX, deadUnitY)
						local gridX, gridY = deadUnitX, deadUnitY
						
						local radius = 120
						
						local r = oWorld:random(12, radius) --随机偏移半径
						
						local face = oWorld:random(0, 360)
						local fangle = face * math.pi / 180 --弧度制
						fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
						local dx = r * math.cos(fangle) --随机偏移值x
						local dy = r * math.sin(fangle) --随机偏移值y
						dx = math.floor(dx * 100) / 100  --保留2位有效数字，用于同步
						dy = math.floor(dy * 100) / 100  --保留2位有效数字，用于同步
						
						gridX = gridX + dx --随机x位置
						gridY = gridY + dy --随机y位置
						gridX, gridY = hApi.Scene_GetSpace(gridX, gridY, 60)
						
						--local forcePlayer = oWorld:GetForce(oKillerSide)
						--local owner = forcePlayer:getpos()
						
						--print("oWorld:dropunit:",id,oKillerPos,face,gridX,gridY)
						local oItem = oWorld:addunit(uId, 1,nil,nil,face,gridX,gridY,nil,nil)
						oItem:setitemid(id)
						mapInfo.dropNum = mapInfo.dropNum + 1
						--local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(1.0, 1.1), CCScaleTo:create(1.0, 1.0))
						--oItem.handle._n:runAction(CCRepeatForever:create(towAction))
						--print(oItem, oItem.data.name)
						
						--设置生存时间
						local livetime = hVar.tab_item[id].dropUnitLivetime
						if livetime and (livetime > 0) then
							oItem:setLiveTime(livetime)
						end
						
						--淡入动画效果
						if livetime and (livetime > 0) then
							if oItem.handle.s then
								local act1 = CCEaseSineOut:create(CCFadeIn:create(1.0)) --淡入
								local actDelay = CCDelayTime:create(livetime/1000-5)
								local act2 = CCFadeOut:create(0.5)
								local act3 = CCFadeIn:create(0.5)
								local act4 = CCFadeOut:create(0.5)
								local act5 = CCFadeIn:create(0.5)
								local act6 = CCFadeOut:create(0.5)
								local act7 = CCFadeIn:create(0.5)
								local act8 = CCFadeOut:create(0.5)
								local act9 = CCFadeIn:create(0.5)
								local a = CCArray:create()
								a:addObject(act1)
								a:addObject(actDelay)
								a:addObject(act2)
								a:addObject(act3)
								a:addObject(act4)
								a:addObject(act5)
								a:addObject(act6)
								a:addObject(act7)
								a:addObject(act8)
								a:addObject(act9)
								local sequence = CCSequence:create(a)
								oItem.handle.s:runAction(CCRepeatForever:create(sequence))
							end
						end
					end
				end
				
				--加入到表中
				local t =
				{
					oDeadHero = oHero, --死亡的英雄
					deadoUint = deadoUint,
					roadPoint = oUnit:copyRoadPointInfo(), --把该英雄的路点存下来，复活时继续沿路点走路
					
					beginTick = oWorld:gametime(), --当前时间
					rebithTime = rebirthtime,
					rebirth_wudi_time = rebirth_wudi_time, --复活后无敌时间（单位：毫秒）
					basic_weapon_id = basic_weapon_id, --基础武器id
					basic_weapon_level = basic_weapon_level, --基础武器等级
					basic_skill_level = basic_skill_level, --基础技能等级
					basic_skill_usecount = basic_skill_usecount, --基础技能使用次数
					progressUI = deadoUint.chaUI["rebirthProgress"],
					labelUI = deadoUint.chaUI["numberBar"],
					--CDLabel = CDLabel, --头像栏显示复活数字倒计时
				}
				table.insert(oWorld.data.rebirthT, t)
				--print("添加对应的复活表", #oWorld.data.rebirthT)
				
				--重新标记主角
				oWorld.data.rpgunit_tank = deadoUint --标记主角是地上的棍子
			end
			
			--确实死了的单位
			if (not bIsReborn) then
				if (mapInfo.mapMode == hVar.MAP_TD_TYPE.NORMAL) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.DIFFICULT) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then --普通模式、挑战难度模式、无尽模式
					--geyachao: 统计本局杀了多少敌人
					--local upos = tOwner:getpos()
					--击杀者的阵营
					local kupos = 0
					if oKillerUnit then
						if oKillerUnit:getowner() then
							kupos = oKillerUnit:getowner():getpos()
						end
					end
					--统计击杀敌人
					if (oUnit.data.type == hVar.UNIT_TYPE.UNIT) or (oUnit.data.type == hVar.UNIT_TYPE.HERO) then
						if (oWorld.data.statistics.killEnemyNum[kupos] == nil) then
							oWorld.data.statistics.killEnemyNum[kupos] = 0
						end
						oWorld.data.statistics.killEnemyNum[kupos] = oWorld.data.statistics.killEnemyNum[kupos] + 1 --geyachao: 本局对战中杀了多少敌人
					end
					
					--统计击杀boss
					if oUnit.attr.tag[hVar.UNIT_TAG_TYPE.OTHER.TAG_BOSS] then
						if (oWorld.data.statistics.killBossNum[kupos] == nil) then
							oWorld.data.statistics.killBossNum[kupos] = 0
						end
						oWorld.data.statistics.killBossNum[kupos] = oWorld.data.statistics.killBossNum[kupos] + 1 --geyachao: 本局对战中杀了多少BOSS
						--print("kupos=", kupos)
						--print("killBossNum=", oWorld.data.statistics.killBossNum[kupos])
					end
				elseif (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
					--
				end
				
				--计算是否主营被打掉
				local triggerID = oUnit.data.triggerID
				--local owner = oUnit.data.owner
				local owner = oUnit:getowner()
				if owner and type(owner) == "table" then
					local force = owner:getforce() or -1
					local gameCampT = mapInfo.gameCamp and mapInfo.gameCamp[force]
					if gameCampT then
						if triggerID and (triggerID > 0) then
							for i = 1, #gameCampT, 1 do
								if (gameCampT[i].tgrId == triggerID) then
									gameCampT[i].defeat = true --被打掉了
									
									break
								end
							end
						end
					end
				end
				
			end
		end
		
		--if oWorld.data.IsQuickBattlefield~=1 then --TD都触发事件
		--geyachao: 死亡特殊处理函数
		--print("oKillerUnit=", oKillerUnit and oKillerUnit.data.name)
		--if OnChaDie_Special_Event then
		--	OnChaDie_Special_Event(oUnit, nOperate, oKillerUnit, nId, vParam, oKillerSide, oKillerPos)
		--end
		
		--[[
		--触发器，检测死亡者是否有死亡后释放的技能
		local Trigger_OnUnitDead_SkillId = oUnit.attr.Trigger_OnUnitDead_SkillId
		if Trigger_OnUnitDead_SkillId and (Trigger_OnUnitDead_SkillId > 0) then
			--死亡者不是沉默状态
			--if (oUnit.attr.suffer_chenmo_stack == 0) then
				--寻找施法目标
				local oTarget = nil
				local tabS = hVar.tab_skill[Trigger_OnUnitDead_SkillId]
				local target = tabS.target and tabS.target[1]
				if (target == "ENEMY") then
					if oKillerUnit and tabS.cast_target_type[oKillerUnit.data.type] then --能对目标施法
						oTarget = oKillerUnit
					else
						--找附近的敌人
						oWorld:enumunitAreaEnemy(tForce, deadUnitX, deadUnitY, 500, function(eu)
							if (oTarget == nil) then
								if tabS.cast_target_type[eu.data.type] then
									oTarget = eu
								end
							end
						end)
					end
				elseif (target == "SELF") then
					oTarget = oUnit
				elseif (target == "ALLY") then
					--找附近的友军
					oWorld:enumunitAreaAlly(tForce, deadUnitX, deadUnitY, 500, function(eu)
						if (oTarget == nil) then
							if (eu ~= oUnit) then --不是自己
								if tabS.cast_target_type[eu.data.type] then
									oTarget = eu
								end
							end
						end
					end)
					
					--实在找不到友军，对自己施法
					if (oTarget == nil) then
						oTarget = oUnit
					end
				elseif (target == "ALL") then
					--找附近的人
					oWorld:enumunitArea(tForce, deadUnitX, deadUnitY, 500, function(eu)
						if (oTarget == nil) then
							if (eu ~= oUnit) then --不是自己
								if tabS.cast_target_type[eu.data.type] then
									oTarget = eu
								end
							end
						end
					end)
					
					--实在找不到人，对自己施法
					if (oTarget == nil) then
						oTarget = oUnit
					end
				end
				
				--避免死循环
				oUnit.attr.Trigger_OnUnitDead_SkillId = 0
				
				--清除世界检测
				--local oWorld = self:getworld()
				local cha_worldC = oUnit:getworldC()
				oWorld.data.Trigger_OnUnitDead_UnitList[cha_worldC] = nil
				
				local tCastParam =
				{
					level = 1, --技能的等级
				}
				local deadUnitX, deadUnitY = hApi.chaGetPos(oUnit.handle) --死亡的单位的坐标
				local gridX, gridY = oWorld:xy2grid(deadUnitX, deadUnitY)
				--print("检测死亡者是否有死亡后释放的技能", oUnit.data.name, Trigger_OnUnitDead_SkillId, oTarget.data.name)
				hApi.CastSkill(oUnit, Trigger_OnUnitDead_SkillId, 0, 100, oTarget, gridX, gridY, tCastParam) --固定时间的眩晕（避免滑行提前到达）
				
				--避免死循环
				--oUnit.attr.Trigger_OnUnitDead_SkillId = 0
			--end
		end
		
		--触发器，检测死亡者是否有死亡后，战车释放的技能
		local Trigger_OnUnitDead_Tank_SkillId = oUnit.attr.Trigger_OnUnitDead_Tank_SkillId
		if Trigger_OnUnitDead_Tank_SkillId and (Trigger_OnUnitDead_Tank_SkillId > 0) then
			--寻找坦克
			local myTank = nil
			oWorld:enumunit(function(eu)
				if (eu.data.id == hVar.MY_TANK_ID) then --我的坦克
					myTank = eu
				end
			end)
			--存在坦克
			if myTank then
				local tCastParam =
				{
					level = 1, --技能的等级
				}
				local deadUnitX, deadUnitY = hApi.chaGetPos(oUnit.handle) --死亡的单位的坐标
				local gridX, gridY = oWorld:xy2grid(deadUnitX, deadUnitY)
				hApi.CastSkill(myTank, Trigger_OnUnitDead_Tank_SkillId, 0, 100, myTank, gridX, gridY, tCastParam) --固定时间的眩晕（避免滑行提前到达）
				
				--避免死循环
				oUnit.attr.Trigger_OnUnitDead_Tank_SkillId = 0
			end
		end
		]]
		
		return hGlobal.event:event("Event_UnitDead", oUnit, nOperate, oKillerUnit, nId, vParam, oKillerSide, oKillerPos)
		--end
	end
end

hGlobal.event["Event_UnitDefeated"] = function(oBattlefield,oUnit,oDefeatHero)
	return hGlobal.event:event("Event_UnitDefeated",oBattlefield,oUnit,oDefeatHero)
end

hGlobal.event["Event_HeroSurrender"] = function(oBattlefield,oHero,oUnit)
	--oHero可能为空(虽然一般不会为空)
	local oWorld = oBattlefield
	local oUnitV
	local oUnitD = oUnit
	local pCount = 0
	local nPlayerV
	for k,v in pairs(oWorld.data.unitcount)do
		if type(k)=="number" and type(v)=="number" and v>0 then
			pCount = pCount + 1
			if k~=oUnit.data.owner then
				nPlayerV = k
				oUnitV = oWorld:getlordU(nPlayerV)
				break
			end
		end
	end
	if pCount<=2 and nPlayerV~=nil then
		local tTeam
		if type(oUnit.data.team)=="table" then
			tTeam = hApi.ReadParamWithDepth(oUnit.data.team,nil,{},3)
		else
			tTeam = {}
		end
		oWorld:log({		--战场log:认输
			key = "hero_surrender",
			unit = {
				id = oUnit.data.id,
			},
			player = oUnit.data.owner,
			team = tTeam,
			lost = 1,
		})
		oWorld:pause(1,"Victory")
	end
	return hApi.GetVictoryFuncBF(oWorld,nPlayerV,0)()
end

hGlobal.event["Event_WorldCreated"] = function(oWorld,IsCreatedFromLoad)
	--if oWorld.data.scenetype=="worldmap" then
		--hApi.CheckHeroBagItem("playerbag")
	--end
	if oWorld.data.scenetype=="worldmap" then
		g_WorldMusicMode = 1
	end
	if oWorld.data.scenetype=="worldmap" or oWorld.data.scenetype=="town" then
		
		local sce = hGlobal.WORLD_SCENE[oWorld.data.scenetype]
		if type(sce)=="userdata" then
			hApi.SceneRefreshBuildingData(sce)
		end
	end
	--省内存优化(EFF)
	if oWorld.data.scenetype=="worldmap" and IsCreatedFromLoad==1 then
		hApi.InitModelForHeroOnMap(oWorld)
		hApi.ReleaseUnusedUnitPlist(oWorld)
	end
	--创建世界地图时重置场景事件
	if oWorld.data.scenetype=="worldmap" then
		hGlobal.SceneEvent:clear()
	end
	--读取地图时，对触发器做一些处理
	if oWorld.data.scenetype=="worldmap" and IsCreatedFromLoad==1 then
		hApi.DoWithTempGameVar("load",oWorld)
	end
	return hGlobal.event:event("Event_WorldCreated",oWorld,IsCreatedFromLoad)
end

hGlobal.event["Event_HeroVictory"] = function(oWorld,oHero,tLoot,oDefeatTarget)
	return hGlobal.event:event("Event_HeroVictory",oWorld,oHero,tLoot,oDefeatTarget)
end

hGlobal.event["Event_HeroDefeated"] = function(oHero,oDefeatHero)
	oHero.data.IsDefeated = 1
	--死亡后清除载具
	oHero:setGameVar("_MOUNT",0)
	if hGlobal.WORLD.LastWorldMap then
		oHero.data.nDayDefeated = hGlobal.WORLD.LastWorldMap.data.roundcount
	end
	return hGlobal.event:event("Event_HeroDefeated",oHero,oDefeatHero)
end

--购买命
hGlobal.event["Event_HeroBuyLife"] = function()
	hGlobal.event:event("LocalEvent_ShowBuyLifeFrm")
end
----------------------------------------------------
-- 
local __tempAddResource = {}
local __tryResetTempResource = function(oPlayer)
	if __tempAddResource[oPlayer.data.playerId]==nil then
		__tempAddResource[oPlayer.data.playerId] = {[0]=0}
	end
	if __tempAddResource[oPlayer.data.playerId][0]==0 then
		__tempAddResource[oPlayer.data.playerId][0] = 1	--这个值用来标识此玩家的数据是否被初始化过了，每次遍历一个单位都会调一次这个
		for k,v in pairs(hVar.RESOURCE_TYPE)do
			if v~=0 then
				__tempAddResource[oPlayer.data.playerId][v] = 0
			end
		end
	end
end
local __allGamePlayerGetTempResource = function()
	for k,v in pairs(__tempAddResource)do
		if v[0]==1 then
			v[0] = 0		--重置初始化标识
			local p = hGlobal.player[k]
			if p~=nil then
				for _,typ in pairs(hVar.RESOURCE_TYPE)do
					local a = v[typ] or 0
					if a>0 then
						p:addresource(typ,a)
					end
				end
			end
		end
	end
end
local __showTempProvide = function(oPlayer,oUnit,tResourceGet)
	local r = tResourceGet
	if r then
		for k,v in pairs(hVar.RESOURCE_TYPE)do
			if r[v] and r[v]~=0 and r[v] >=1 then
				oPlayer:showlootart(oUnit,v,r[v])
			end
		end
	end
end
--local __addTempProvide = function(oPlayer,oUnit,tProvide,mode,nProvidePec,tResourceGet)
--	local i = 1
--	local oWorld = oUnit:getworld()
--	local v = tProvide[1]
--	if #tProvide>1 then
--		v = tProvide[oWorld:random(1,#tProvide)]
--	end
--	if type(v)=="table" then
--		local r = __tempAddResource[oPlayer.data.playerId]
--		local rType = hVar.RESOURCE_TYPE[v[1]]
--		if rType~=nil then
--			local Min = v[2] or 1
--			local Max = v[3] or v[2]
--			if nProvidePec~=100 then
--				Min = hApi.floor(Min*nProvidePec/100)
--				Max = hApi.floor(Max*nProvidePec/100)
--			end
--			local nGet = Min
--			if Min<Max then
--				nGet = oWorld:random(Min,Max)
--			end
--			r[rType] = (r[rType] or 0) + nGet
--			if tResourceGet then	--显示专用临时表
--				tResourceGet[rType] = (tResourceGet[rType] or 0) + nGet
--			end
--		end
--	end
--end
--local __ENUM__WorldUnitEveryDay = function(oUnit,oWorld,tGrowthPec)
--	if oUnit.data.IsDead==1 then
--		return
--	end
--	local tabU = oUnit:gettab()
--	local oPlayer = oUnit:getowner()
--	if oPlayer==nil then
--		--不属于任何玩家的单位？
--		return
--	end
--	--补充产量
--	if oUnit.data.type==hVar.UNIT_TYPE.BUILDING then
--		if oPlayer~=nil and oPlayer.data.playerId>0 and tabU~=nil then
--			__tryResetTempResource(oPlayer)
--			local IsProvide = 0
--			local tResourceGet = {}
--			local oTown = oUnit:gettown()
--			if oTown then
--				--主城产出
--				local unitList = oTown.data.unitList
--				local upgradeState = oTown.data.upgradeState
--				for i = 1, #upgradeState do
--					if (upgradeState[i] or 0)>0 then
--						if hVar.tab_unit[unitList[i][2]].provide then
--							local provide = hVar.tab_unit[unitList[i][2]].provide
--							if #provide == 1 then
--								IsProvide = 1
--								__addTempProvide(oPlayer,oUnit,provide,"random",oTown.data.ProvidePec,tResourceGet)
--							--长度为6 是寺庙
--							elseif #provide == 6 and math.mod(oWorld.data.roundcount,7) == 0 then
--								IsProvide = 1
--								__addTempProvide(oPlayer,oUnit,provide,"random",oTown.data.ProvidePec,tResourceGet)
--							end
--						end
--					end
--				end
--			elseif tabU.provide~=nil and #tabU.provide>0 then
--				IsProvide = 1
--				--野外建筑产出
--				__addTempProvide(oPlayer,oUnit,tabU.provide,"random",oWorld.data.ProvidePec,tResourceGet)
--			end
--			if IsProvide==1 and oPlayer==hGlobal.LocalPlayer and oUnit:isInScreen() then
--				__showTempProvide(oPlayer,oUnit,tResourceGet)	--这里只是显示用，实际是在下面一次性把所有的钱加给玩家
--			end
--		end
--	end
--	--(单位,建筑)野外生物生长
--	if oWorld.data.roundcount>0 and oUnit.data.team~=0 and (oPlayer.data.IsAIPlayer==1 or oPlayer==hGlobal.NeutralPlayer) and oUnit.data.IsDead~=1 then
--		local team = oUnit.data.team
--		local nPec = tGrowthPec[oUnit.data.owner] or tGrowthPec[hGlobal.NeutralPlayer.data.playerId] or 100
--		if oUnit.data.type==hVar.UNIT_TYPE.UNIT or oUnit.data.type==hVar.UNIT_TYPE.BUILDING then
--			--普通生物生长
--			local fPec = tGrowthPec.creep_pec
--			--无人看守的建筑内生物生长率不受生长参数影响
--			if oUnit.data.type==hVar.UNIT_TYPE.BUILDING then
--				fPec = 1.0
--				nPec = 100
--			end
--			if type(team)=="table" and nPec>0 and fPec>0 then
--				local nDayCount =  oWorld.data.roundcount
--				for i = 1,#team do
--					if type(team[i]) == "table" then
--						local id = team[i][1]
--						if id~=0 and hVar.tab_unit[id]~=nil then
--							--增加生物
--							local v = (hVar.UNIT_AI_INCREASE_PER_DAY[hVar.tab_unit[id].unitlevel or 0] or 0)*fPec*nPec/100
--							local num = hApi.floor((nDayCount+1)*v)-hApi.floor(v*nDayCount)
--							team[i][2] = team[i][2] + num
--						end
--					end
--				end
--				hApi.RefreshCombatScore(oUnit)
--			end
--		elseif oUnit.data.type==hVar.UNIT_TYPE.HERO then
--			--英雄兵力生长
--			--AI_Garrison(oUnit)
--			local fPec = tGrowthPec.ai_pec
--			local oHero = oUnit:gethero()
--			local teamH
--			if oHero then
--				teamH = oHero.data.AITeam
--				if oHero.data.AIModeBasic==hVar.AI_MODE.GUARD or oHero.data.AIModeBasic==hVar.AI_MODE.PASSIVE then
--					fPec = fPec*(0.8 + oHero.attr.level*0.1)
--				else
--					fPec = fPec*(1.5 + oHero.attr.level*0.1)
--				end
--			end
--			if type(teamH)~="table" then
--				teamH = team
--			end
--			if type(team)=="table" and nPec>0 and fPec>0 then
--				local nDayCount = oWorld.data.roundcount
--				for i = 1,#team do
--					local nUnitId,nGrowthNum = 0,0
--					if type(team[i])=="table" then
--						nUnitId = team[i][1]
--					end
--					if nUnitId==0 and type(teamH[i]) == "table" then
--						nUnitId = teamH[i][1]
--					end
--					if nUnitId~=0 and hVar.tab_unit[nUnitId]~=nil and hVar.tab_unit[nUnitId].type~=hVar.UNIT_TYPE.HERO then
--						--增加生物
--						local v = (hVar.UNIT_AI_INCREASE_PER_DAY[hVar.tab_unit[nUnitId].unitlevel or 0] or 0)*fPec*nPec/100
--						--投石车生长速度慢
--						if nUnitId==10008 then
--							v = 0.2*fPec*nPec/100
--						end
--						--农民每天+5个
--						if nUnitId==10021 then
--							v = 5*fPec*nPec/100
--						end
--						nGrowthNum = hApi.floor((nDayCount+1)*v)-hApi.floor(v*nDayCount)
--					end
--					if nUnitId~=0 and nGrowthNum>0 then
--						if type(team[i])=="table" then
--							if team[i][1]==0 then
--								team[i][1] = nUnitId
--							end
--							if team[i][1]~=nUnitId then
--								_DEBUG_MSG("AI英雄"..oUnit.data.name.."部队增长错误！请检查触发器")
--							else
--								team[i][2] = team[i][2] + nGrowthNum
--							end
--						else
--							team[i] = {nUnitId,nGrowthNum}
--						end
--					end
--				end
--				hApi.RefreshCombatScore(oUnit)
--			end
--		end
--	end
--end

hApi.LoadPlayerProvideEx = function(nPlayerId)
	local tProvideEx_P
	local oPlayer = hGlobal.player[nPlayerId]
	if oPlayer then
		--获取玩家的战术技能等级
		local tTacticsLv = oPlayer:gettactics()
		--将额外产量加入到玩家额外生产列表中
		for id,lv in pairs(tTacticsLv) do
			local tabT = hVar.tab_tactics[id]
			if tabT and tabT.growth then
				local nlv = math.min(tabT.level or 1,lv)
				if tProvideEx_P==nil then
					tProvideEx_P = {}
				end
				local tGrowth = tabT.growth
				for i = 1,#tGrowth do
					local uid = tGrowth[i][1]
					tProvideEx_P[uid] = (tProvideEx_P[uid] or 0) + (tGrowth[i][nlv+1] or 0)
				end
			end
		end
	end
	return tProvideEx_P
end

local __LoadPlayerProvideEx = hApi.LoadPlayerProvideEx
local __LoadProvideExFromTactics = function()
	local tProvideEx = {}
	for nPlayerId = 1,hVar.MAXMEDALNUM do
		tProvideEx[nPlayerId] = __LoadPlayerProvideEx(nPlayerId)
	end
	return tProvideEx
end

local __WorldBuildingProvideEveryWeek = function(u,tProvideEx)
	if u.data.type==hVar.UNIT_TYPE.BUILDING then
		if u:gettown()==nil then
			local hireList = u.data.hireList
			if hireList~=0 then
				for i = 1,#hireList do
					local v = hireList[i]
					local growthNumBasic = v[3]
					--print(hVar.tab_unit[u.data.id].name,hVar.tab_unit[v[1]].name,growthNumBasic)
					--至多产生两倍于基本产量的兵种
					v[2] = math.min(math.max(0,v[2] + growthNumBasic),growthNumBasic*2)
				end
			end
		end
	end
end

local __WorldTownProvideEveryWeek = function(u,IsFirstWeek,tProvideEx)
	if u.data.type==hVar.UNIT_TYPE.BUILDING then
		local oTown = u:gettown()
		if oTown then
			--首周生产，且已经有过生产记录的城镇不提供产量
			if IsFirstWeek==1 and oTown.data.LastProvideDate==1 then
				return
			end
			oTown:providearmy(IsFirstWeek,tProvideEx[oTown.data.owningPlayer])	--主城每周产兵
		end
	end
end

local __WorldGroupRefresh = function(u,_,_,oWorld)
	--每周刷怪
	local d = u.data
	if d.type~=hVar.UNIT_TYPE.GROUP then
		return
	end
	--因为某些原因禁止刷怪的话，直接返回
	if d.nTarget==-1 then
		return
	end
	local tData = u:gettriggerdata()
	local IsHide = 0
	local CheckBlock = 1
	local IsFirstCreature = 0
	if tData~=nil then
		local nWeek = tData.week or 1
		local nStartDay = tData.startday or 0
		IsHide = tData.IsHide or 0
		if nWeek<=0 and oWorld.data.roundcount~=0 then
			--首周以外，如果刷新周次如果等于0，那么不刷新
			return
		elseif nStartDay>(oWorld.data.roundcount+1) then
			--首次刷新日期如果小于当前日期，那么不刷新
			return
		elseif nWeek>=2 then
			--N周刷一次
			local p = hApi.floor(7*nWeek)
			local nLast = hApi.floor(oWorld.data.roundcount/p)
			local nCur = hApi.floor(oWorld.data.roundcount+1/p)
			if nLast==nCur then
				return
			end
		elseif oWorld.data.roundcount==0 then
			--首周刷怪必然通过
		end
		if (nStartDay==0 and oWorld.data.roundcount==0) or (nStartDay~=0 and nStartDay==(oWorld.data.roundcount+1)) then
			IsFirstCreature = 1
		end
		--隐藏单位必刷，不做碰撞检测
		if IsHide==1 then
			CheckBlock = 0
		end
	end
	--查看一下是否替换刷怪模式
	--如果指定了这个模式，那么只能刷1只怪，并且替换为目标(把原来的刷怪单位删掉)
	--并且无视触发器数据
	local tabU = hVar.tab_unit[d.id]
	if tabU and tabU.group~=nil and tabU.group[1] and tabU.group[1][2] and hVar.tab_unit[tabU.group[1][2]] then
		local nType = hVar.tab_unit[tabU.group[1][2]].type
		local oUnitNew
		local sus = 1
		if nType==hVar.UNIT_TYPE.HERO then
			--oUnitNew = hApi.CreateHeroByGroup(oWorld,u)
		elseif nType==hVar.UNIT_TYPE.BUILDING then
			oUnitNew = hApi.CreateBuildingByGroup(oWorld,u)
		else
			sus = 0
		end
		if oUnitNew~=nil then
			--刚刷出来的时候就是隐藏状态，并且这些怪物会被电脑自动忽略
			if IsHide==1 then
				oUnitNew:sethide(1)
			else
				heroGameInfo.worldMap.AddUnit(oUnitNew)
				--heroGameInfo.worldMap.AddMonster(oUnitNew)
			end
		end
		if sus==1 then
			return
		end
	end
	--如果是普通刷怪模式
	--看看之前刷的怪还在不在
	local t
	if d.nTarget~=0 then
		t = hClass.unit:find(d.nTarget)
	end
	if t~=nil and t.data.triggerID==d.triggerID and t.data.nTarget==u.ID then
		--上次刷的怪还存在就返回
		return
	else
		local CanCreate = 1
		--如果需要进行碰撞检测
		if CheckBlock==1 then
			local ux,uy = u:getXY()
			local x, y = hApi.Scene_GetSpace(ux, uy, 60)
			if ux==x and uy==y then
				--没碰撞，可以刷
			else
				--上面踩着任何单位的话，就不刷新任何单位
				CanCreate = 0
			end
		end
		--如果允许刷怪
		if CanCreate==1 then
			local mon
			local p = u:getowner()
			if u.data.owner==0 or (p and p.data.IsAIPlayer==1) then
				mon = hApi.CreateArmyByGroup(oWorld,u,nil,nil,nil,oWorld.data.MonGrowth/1000)
			else
				--非AI玩家的部队不自动增长
				mon = hApi.CreateArmyByGroup(oWorld,u,nil,nil,nil,0)
			end
			if mon~=nil then
				--如果是单位组首个刷出来的单位，则允许拥有MapScorePec
				if IsFirstCreature==1 then
					mon.data.mapScorePec = d.mapScorePec
				end
				--刚刷出来的时候就是隐藏状态，并且这些怪物会被电脑自动忽略
				if IsHide==1 then
					mon:sethide(1)
				else
					heroGameInfo.worldMap.AddUnit(mon)
					--heroGameInfo.worldMap.AddMonster(mon)
				end
			end
		end
		return
	end
end

local __RemoveOngoingBattlefield = function(oWorld)
	if oWorld.data.type=="battlefield" then
		--一天结束时把正在进行的战场清掉,把里面的英雄t出来(如果出bug的话)
		for i = -1,hVar.MAX_PLAYER_NUM,1 do
			local u = oWorld:getlordU(i)
			if u then
				u.data.IsBusy = 0
			end
		end
		if hGlobal.LocalPlayer:getfocusworld()==oWorld and hGlobal.WORLD.LastWorldMap then
			hGlobal.LocalPlayer:focusworld(hGlobal.WORLD.LastWorldMap)
		end
		oWorld:del()
	end
end

local __RefreshHeroAttrEveryDay = function(oHero)
	--如果是队伍中的英雄，啥都不做
	if oHero.data.HeroTeamLeader~=0 then
		return
	end
	--回复10%的血和5点魔法
	if oHero.data.IsDefeated~=1 then
		local exHeal = 0
		local exMana = 0
		local oUnit = oHero:getunit()
		if oUnit~=nil then
			local oTown = hClass.town:find(oUnit.data.curTown)
			if oUnit and oUnit:isTownGuard()==1 then
				--在城里的单位+30%生命回复
				exHeal = 30
				if oTown then
					local templelv = oTown:gettech("templelv")
					if templelv > 0 then
						--有寺庙的话,+100%生命恢复,+20%法力回复
						exHeal = 100
						exMana = 20
					end
				end
			end
		end
		oHero:addattr("hp_pec",oHero.attr.hpRecover+exHeal,1)
		oHero:addattr("mp",oHero.attr.mpRecover+math.floor(oHero.attr.mxmp*(10+exMana)/100),1)
		--同队英雄回血和队长做相同处理
		local hTeam = oHero.data.HeroTeam
		if hTeam.n>0 then
			for i = 1,#hTeam do
				if type(hTeam[i])=="table" then
					local cHero = hClass.hero:find(hTeam[i][1])
					if cHero and cHero.__ID==hTeam[i][2] then
						cHero:addattr("hp_pec",cHero.attr.hpRecover+exHeal,1)
						cHero:addattr("mp",cHero.attr.mpRecover+math.floor(oHero.attr.mxmp*(10+exMana)/100),1)
					end
				end
			end
		end
	end
	--恢复行动力
	local oUnit = oHero:getunit("worldmap")
	if oUnit~=nil then
		--如果是桃园结义则添加一个行动力恢复的提示文字
		if oUnit:getowner() == hGlobal.LocalPlayer then
			local mapname = hGlobal.WORLD.LastWorldMap.data.map
			if mapname == "world/level_tyjy" then
				hUI.floatNumber:new({
					unit = oUnit,
					text = "",
					x = 120,
					font = "numRed",
					moveY = 64,
				}):addtext(hVar.tab_string["__TEXT_Removepoint"],hVar.FONTC,36,"RC",-10,6):setColor(ccc3(255,255,255))
			end
		end
		oUnit:setmovepoint("newday")
	end
end

local __ResetHeroAttrEveryWeek = function(oHero)
	local aW = oHero.attrW
	for k,v in pairs(aW)do
		aW[k] = nil
		if type(v)=="number" and v~=0 then
			oHero:addattr(k,-1*v,1)
		end
	end
end

local __ResetBuildingCount = function(oPlayer)
	for i = 1, #oPlayer.data.ownTown do
		if oPlayer.data.ownTown[i] then
			local Town = hApi.GetObjectUnit(oPlayer.data.ownTown[i])
			if Town then
				local oTown = Town:gettown()
				if oTown then
					oTown.data.buildingCount = 0
				end
			end
		end
	end
end

hGlobal.event["Event_EndDay"] = function(nDayCount)
	local oWorld = hGlobal.WORLD.LastWorldMap
	if oWorld==nil then
		return
	elseif oWorld.data.IsPaused==1 then
		_DEBUG_MSG("世界暂停中，禁止跳转到下一天")
		return
	end
	for k,v in pairs(__tempAddResource)do
		for n in pairs(v) do
			v[n] = 0
		end
	end
	hClass.world:enum(__RemoveOngoingBattlefield)
	--新的一天
	oWorld.data.roundcount = oWorld.data.roundcount + 1
	--清除每周额外附加的属性
	if math.mod(oWorld.data.roundcount,7)==0 then
		hClass.hero:enum(__ResetHeroAttrEveryWeek)
	end
	--刷新英雄属性,另外允许英雄获得当日的经验
	hClass.hero:enum(__RefreshHeroAttrEveryDay)
	local tGrowthPec = {
		creep_pec = (hApi.GetMapValueByDifficulty(oWorld,"CreepGarrision") or 1),
		ai_pec = (hApi.GetMapValueByDifficulty(oWorld,"AI_Garrision") or 1),
	}
	for nPlayerId = 0,hVar.MAX_PLAYER_NUM,1 do
		local tgrDataP = oWorld:getmapdata(nPlayerId)
		if tgrDataP and type(tgrDataP.GrowthEveryDayPec)=="number" then
			tGrowthPec[nPlayerId] = tgrDataP.GrowthEveryDayPec
		end
	end
	--oWorld:enumunit(__ENUM__WorldUnitEveryDay,oWorld,tGrowthPec)
	if math.mod(oWorld.data.roundcount,7)==0 then
		--补充所有野外兵营兵力
		oWorld:enumunit(__WorldBuildingProvideEveryWeek)
		--补充所有主城产量
		oWorld:enumunit(__WorldTownProvideEveryWeek,0,__LoadProvideExFromTactics())
	end
	__allGamePlayerGetTempResource()
	hClass.player:enum(__ResetBuildingCount)
	--第0天的刷怪在别的地方特殊处理
	if oWorld.data.roundcount~=0 then
		if math.mod(oWorld.data.roundcount,7)==0 then
			--每周刷怪
			local tGroupUnit = {}
			oWorld:enumunit(function(t)
				if t.data.type==hVar.UNIT_TYPE.GROUP and t.data.nTarget~=-1 then
					tGroupUnit[#tGroupUnit+1] = t
				end
			end)
			for i = 1,#tGroupUnit do
				__WorldGroupRefresh(tGroupUnit[i],nil,nil,oWorld)
			end
		else
			--每日刷怪，只处理具有“首次刷怪日”的怪点
			local tGroupUnit = {}
			oWorld:enumunit(function(t,nDayCount)
				if t.data.type==hVar.UNIT_TYPE.GROUP and t.data.nTarget~=-1 then
					local tData = t:gettriggerdata()
					if tData and tData.startday==nDayCount then
						tGroupUnit[#tGroupUnit+1] = t
					end
				end
			end,oWorld.data.roundcount+1)
			for i = 1,#tGroupUnit do
				__WorldGroupRefresh(tGroupUnit[i],nil,nil,oWorld)
			end
		end
	end
	--世界解除暂停状态
	if oWorld.data.IsPaused==1 then
		xlLG("error","世界意外处于暂停状态,请检查"..tostring(oWorld.data.PausedByWhat).."\n")
		oWorld:pause(0)
	end
	return hGlobal.event:call("Event_NewDay",oWorld.data.roundcount)
end

local __ENUM__InitTalkEveryDay = function(u,TalkUnit,TalkName)
	if u.data.talkTag~=-1 and u.data.IsDead~=1 then
		local tData = u:gettriggerdata()
		if tData and tData.talk~=nil then
			local nSortIndex = tData.sortIndex or 0
			local tTalkToAdd = {}
			if u.data.talkTag=="everyday" and TalkName~="day0" then
				tTalkToAdd[#tTalkToAdd+1] = {u,tData.talk,"everyday",nSortIndex}
			else
				local IgnoredKey = {}
				local SpecialTag = TalkName.."p"..u.data.owner
				local EveryDayTag = "everyday"
				local DTalk,DPTalk,EDTalk = 0,0,0
				local oHero = u:gethero()
				if oHero then
					local tIgnored = oHero.data.IgnoredTalk
					if tIgnored~=0 and type(tIgnored)=="table" then
						for i = 1,#tIgnored do
							IgnoredKey[tIgnored[i]] = 1
						end
					end
				end
				for i = 1,#tData.talk do
					local v = tData.talk[i]
					if IgnoredKey[v[1]]==1 then
						--被忽视的对话不触发
					elseif v[1]==TalkName then
						if DTalk==0 then
							DTalk = 1
							tTalkToAdd[#tTalkToAdd+1] = {u,tData.talk,TalkName,nSortIndex}
						end
					elseif v[1]==SpecialTag then
						if DPTalk==0 then
							DPTalk = 1
							tTalkToAdd[#tTalkToAdd+1] = {u,tData.talk,SpecialTag,nSortIndex}
						end
					elseif v[1]==EveryDayTag then
						if EDTalk==0 then
							EDTalk = 1
							tTalkToAdd[#tTalkToAdd+1] = {u,tData.talk,EveryDayTag,nSortIndex}
						end
					end
				end
			end
			if #tTalkToAdd>0 then
				local nStartPos = #TalkUnit
				local nNum = #tTalkToAdd
				if nSortIndex~=0 then
					for i = 1,#TalkUnit do
						local v = TalkUnit[i]
						if v[4]==0 or v[4]>nSortIndex then
							nStartPos = i-1
							break
						end
					end
					for i = 1,nNum do
						TalkUnit[#TalkUnit+1] = 0
					end
					for i = #TalkUnit,nStartPos+nNum+1,-1 do
						TalkUnit[i] = TalkUnit[i-nNum]
					end
				end
				for i = 1,nNum do
					TalkUnit[nStartPos+i] = tTalkToAdd[i]
				end
			end
		end
	end
end

local __CODE__OnNewDay = function(oWorld)
	if oWorld.data.roundcount==0 then
		--补充所有主城产量(首周)
		oWorld:enumunit(__WorldTownProvideEveryWeek,1,__LoadProvideExFromTactics())
	end
	oWorld:pause(0)
	if g_editor ~= 1 then
		xlScene_SaveMap(g_curPlayerName)
	end
	if xlScene_RefreshChaDynmaicBlock~=nil and type(oWorld.handle.worldScene)=="userdata" then
		xlScene_RefreshChaDynmaicBlock(oWorld.handle.worldScene)
	end
	hApi.ReleaseUnusedUnitPlist(oWorld)
end

local __ENUM__EnableHeroFog = function(oHero)
	local oUnit = oHero:getunit("worldmap")
	if oUnit and oUnit.data.IsHide==0 then
		if oHero:getowner()==hGlobal.LocalPlayer or oHero:getGameVar("_ALLY")>0 then
			hApi.chaEnableClearFog(oUnit.handle,1,-1)	--默认视野是14
		else
			hApi.chaEnableClearFog(oUnit.handle,0,-1)
		end
	end
end

hGlobal.event["Event_NewDay"] = function(nDayCount)
	local oWorld = hGlobal.WORLD.LastWorldMap
	if oWorld==nil then
		return
	end

	--每天刷新所有英雄是否可以开启视野
	hClass.hero:enum(__ENUM__EnableHeroFog)

	--给UI用的刷新面板日期
	if oWorld.data.roundcount>0 then
		g_game_days = oWorld.data.roundcount
		hApi.UpdataDate(g_game_days)
	end

	--每日例行刷新所有玩家的数据
	for i = -1,hVar.MAX_PLAYER_NUM,1 do
		if hGlobal.player[i] then
			hGlobal.player[i]:reseteveryday(nDayCount)
		end
	end

	--第一天的事件在这里处理
	if oWorld.data.roundcount==0 then
		--day0的事件里面仅允许纯函数！
		local tTalkTab = {}
		oWorld:enumunit(__ENUM__InitTalkEveryDay,tTalkTab,"day0")
		if #tTalkTab>0 then
			for i = 1,#tTalkTab do
				local u,tTalk,sTalkName = unpack(tTalkTab[i])
				local vTalk = hApi.InitUnitTalk(u,u,tTalk,sTalkName)
				if vTalk and #vTalk>0 then
					hApi.ProcessTalkCodeOnly(vTalk)
				end
			end
		end
		local tGroupUnit = {}
		oWorld:enumunit(function(t)
			if t.data.type==hVar.UNIT_TYPE.GROUP and t.data.nTarget~=-1 then
				tGroupUnit[#tGroupUnit+1] = t
			end
		end)
		for i = 1,#tGroupUnit do
			__WorldGroupRefresh(tGroupUnit[i],nil,nil,oWorld)
		end
		--选过英雄的话，重置迷雾信息
		if oWorld.data.SelectHeroNum>0 then
			if xlMap_ResetFog then
				xlMap_ResetFog()
			end
			oWorld:enumunit(function(u)
				if u.data.owner==hGlobal.LocalPlayer.data.playerId and u.data.IsDead~=1 then
					local worldX,worldY = u:getXY()
					xlClearFogByPoint(worldX,worldY)
				end
			end)
			--聚焦到第一个可用英雄身上
			local tHero = hGlobal.LocalPlayer.heros
			for i = 1,#tHero do
				if type(tHero[i])=="table" and tHero[i].ID~=0 then
					local u = tHero[i]:getunit("worldmap")
					if u then
						local worldX,worldY = u:getXY()
						hApi.setViewNodeFocus(worldX,worldY)
						break
					end
				end
			end
		end
		--创建所有英雄的头像
		hGlobal.event:event("LocalEvent_WorldMapStart",oWorld)
		--为不同难度的英雄添加属性
		local sMapLv = "lv"..oWorld.data.MapDifficulty
		oWorld:enumunit(function(t)
			if t.data.type==hVar.UNIT_TYPE.HERO then
				local oHero = t:gethero()
				local tgrDataH = t:gettriggerdata()
				if oHero and tgrDataH and type(tgrDataH.attrForDifficulty)=="table" then
					for lv = 1,#tgrDataH.attrForDifficulty do
						local v = tgrDataH.attrForDifficulty[lv]
						if v[1]==sMapLv then
							local tAttr = {}
							local i = 2
							while(i<#v)do
								local k,v = v[i],v[i+1]
								i = i + 2
								local typ = type(v)
								if type(k)=="string" and (typ=="number" or typ=="string") then
									tAttr[#tAttr+1] = {k,(tonumber(v) or 0)}
								end
							end
							oHero:loadattr(tAttr)
							return
						end
					end
				end
			end
		end)
	end
	local tTalkTab = {}
	oWorld:enumunit(__ENUM__InitTalkEveryDay,tTalkTab,"day"..(oWorld.data.roundcount+1))
	hApi.InitModelForHeroOnMap(oWorld)
	local tHeroList = hGlobal.LocalPlayer.heros
	if g_editor ~= 1 then
		--进入游戏时加载英雄等级
		if nDayCount == 0 then
			for _,oHero in pairs(tHeroList) do
				if type(oHero)=="table" and oHero.ID and oHero.ID~=0 then
					--尝试加载卡片
					local HeroCard = oHero:LoadHeroFromCard("newgame")
					if HeroCard then
						--oHero.data.HeroCard = 1
						oHero:loadtalent(HeroCard)
					end
					--设置行动力
					local u = oHero:getunit("worldmap")
					if u then
						u:setmovepoint("newday")
					end
				end
			end
		end
		--时效性道具检测 游戏第一天时 自动清除之前的 时效性道具
		--特殊调用，用来清理玩家背包,一般地方请不要这么调用
		hApi.CheckHeroBagItem("playerbag")
	end

	--每周一自动加入的部队(战术卡片技能)
	if g_editor ~= 1 and oWorld.data.roundcount~=0 and (oWorld.data.roundcount==1 or math.mod(oWorld.data.roundcount,7)==0) then
		--第2天,或者每周一生效
		local oUnitH
		for i = 1,#tHeroList do
			local v = tHeroList[i]
			if type(v)=="table" and v:getunit() then
				oUnitH = v:getunit()
				break
			end
		end
		if oUnitH then
			local tTacticsLv = hGlobal.LocalPlayer:gettactics()
			if type(tTacticsLv)=="table" then
				for id,lv in pairs(tTacticsLv) do
					local tabT = hVar.tab_tactics[id]
					if tabT and tabT.autohire then
						local nLv = math.min(tabT.level or 1,lv)
						local vTalk = hApi.InitCreepJoinTalk(oUnitH,tabT.autohire[nLv],1)
						if vTalk then
							tTalkTab[#tTalkTab+1] = {oUnitH,{},vTalk}
						end
					end
				end
			end
		end
	end
	oWorld:pause(1,"DayEnd")
	hApi.DoWithTempGameVar("newday",oWorld)
	local tWorld = hApi.SetObjectEx({},oWorld)
	if #tTalkTab>0 then
		tTalkTab.ExitCode = function()
			local oWorld = hApi.GetObjectEx(hClass.world,tWorld)
			if oWorld~=nil and oWorld.data.PausedByWhat~="Defeat" and oWorld.data.PausedByWhat~="Victory" then
				--胜利或者失败的话，就不自动存档
				__CODE__OnNewDay(oWorld)
				return hGlobal.event:event("Event_NewDay",oWorld.data.roundcount)
			end
		end
		return hApi.CreateMultiUnitTalk(tTalkTab)
	else
		__CODE__OnNewDay(oWorld)
		return hGlobal.event:event("Event_NewDay",oWorld.data.roundcount)
	end
end

local __ENUM__InitUnitFirstRound = function(oUnit,tAutoList,_,oWorld)
	oWorld:newunitBF(oUnit,tAutoList)
end
--战场开始
hGlobal.event["Event_BattlefieldStart"] = function(oWorld)
	local tPlayerSort = {oWorld.data.attackPlayerId}
	for nPlayer = -1,hVar.MAX_PLAYER_NUM,1 do
		if type(oWorld.data.lords[nPlayer])=="table" and nPlayer~=oWorld.data.attackPlayerId then
			tPlayerSort[#tPlayerSort+1] = nPlayer
		end
	end
	oWorld.data.uniquecast = {}		--战场内每名玩家只允许施展一次的技能记录
	local oRound = oWorld:startround(9,tPlayerSort)
	if oWorld.data.IsQuickBattlefield~=1 and hGlobal.LocalPlayer:getfocusworld()==oWorld then
		hGlobal.event:event("LocalEvent_UnitListCreated",oWorld,oRound)
	end
	if oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.oUnit)==nil then
		if oWorld.data.IsQuickBattlefield==1 then
			return hGlobal.event:event("Event_BattlefieldStart",oWorld)
		end
	else
		local tAutoList = {}
		
		oWorld:enumunit(__ENUM__InitUnitFirstRound,tAutoList)

		oWorld:autoorderBF(tAutoList)
		if oWorld.data.IsQuickBattlefield~=1 then
			hGlobal.event:event("Event_BattlefieldStart",oWorld)
		end
		return hGlobal.event:call("Event_BattlefieldRoundStart",oWorld,oRound)
	end
end

-------------------------------
--战场每回合开始
local __ENUM__GetGateOwner = function(oUnit,tGateOwner)
	if oUnit.data.type==hVar.UNIT_TYPE.BUILDING and oUnit.data.IsGate~=0 then
		--拥有门的玩家
		tGateOwner[oUnit.data.owner] = 1
	end
end
local __ENUM__UnitOnRoundStart = function(oUnit,nRoundCount)
	oUnit:onRoundStart(nRoundCount)
end
local __ENUM__HeroFirstRoundLog = function(oUnit,oWorld)
	if oUnit.data.type == hVar.UNIT_TYPE.HERO then
		local oHero = oUnit:gethero()
		if oHero~=nil then
			oWorld:log({	--英雄首回合的属性记录
				key = "hero_round1",
				unit = {
					id = oUnit.data.id,
					owner = oUnit.data.owner,
					indexOfTeam = oUnit.data.indexOfTeam,
					hp = oUnit.attr.hp,
					mxhp = oUnit.attr.mxhp,
					mp = oUnit.attr.mp,
					mxmp = oUnit.attr.mxmp,
					lea = oHero.attr.lea,
					led = oHero.attr.led,
					str = oHero.attr.str,
					int = oHero.attr.int,
					con = oHero.attr.con,
				},
			})
		end
	end
end
local __CODE__GetRoundTopUnit = function(oRound)
	for i = 1,20 do
		local oUnit = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.oUnit)
		if oUnit==nil then
			--没单位了？
			return
		elseif type(oUnit.data.id)=="number" and oUnit.data.IsDead==0 then
			return oUnit
		else
			oRound:pop()
		end
	end
end
local __CODE__RoundStart = function(oWorld,oRound)
	--对战场上的单位进行重新排序
	oRound:sortunitall()
	local oUnit = __CODE__GetRoundTopUnit(oRound)
	if oUnit then
		local nRound = oRound.data.roundCur
		--首回合增加当期英雄的全部血量记录
		if nRound == 1 then
			oWorld:enumunit(__ENUM__HeroFirstRoundLog,oWorld)
		end
		if oWorld.data.IsQuickBattlefield~=1 and hGlobal.LocalPlayer:getfocusworld()==oWorld then
			local oWorld__ID = oWorld.__ID
			return hApi.addTimerOnce("__BF__RoundStartTimerX",400,function()
				--如果世界结束了，那么不做任何操作
				if oWorld.ID==0 or oWorld__ID~=oWorld.__ID then
					return
				end
				hGlobal.event:event("LocalEvent_RoundChanged",oWorld,oRound)
				return hGlobal.event:call("Event_BattlefieldUnitActived",oWorld,oRound,oUnit)
			end)
		else
			return hGlobal.event:call("Event_BattlefieldUnitActived",oWorld,oRound,oUnit)
		end
	else
		_DEBUG_MSG("已无单位，战场结束")
		return oWorld:pause(1,"Victory")
	end
end
local __CODE__BeforeRoundStart = function(oWorld,oRound)
	local nRound = oRound.data.roundCur
	oWorld.data.roundcount = nRound
	--新的回合
	_DEBUG_MSG("[ROUND]回合:"..nRound)
	--每轮开始时,尝试关闭双方势力的城门
	local tGateOwner = {}
	oWorld:enumunit(__ENUM__GetGateOwner,tGateOwner)
	for nPlayer = -1,hVar.MAX_PLAYER_NUM,1 do
		if tGateOwner[nPlayer]==1 then
			oWorld:opengate(hGlobal.player[nPlayer],0,"stand")
		end
	end
	--每回合重置单位，计算冷却
	oWorld:enumunit(__ENUM__UnitOnRoundStart,nRound)
	if oWorld.data.IsQuickBattlefield~=1 then
		hGlobal.event:event("Event_BattlefieldRoundStart",oWorld,oRound)
	end
end
--回合开始
hGlobal.event["Event_BattlefieldRoundStart"] = function(oWorld,oRound)
	local oRoundToken = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.oUnit)
	if not(oRoundToken and oRoundToken.data.id=="round") then
		_DEBUG_MSG("[ROUND]回合RoundStart发生错误")
		return
	end
	local nRound = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.nRound)
	--回合开始Code
	local roundStartCode = function()
		return __CODE__RoundStart(oWorld,oRound)
	end
	--下面的调用必须放在末尾
	if nRound==1 then
		--第一轮时先启动一次自动运行
		oRound:pop(oRoundToken)
		__CODE__BeforeRoundStart(oWorld,oRound)
		return oRound:auto(nil,function()
			--如果存在光环的话
			if oWorld.data.PausedByWhat~="Victory" and type(oWorld.data.aura)=="table" and (oWorld.data.aura.i or 0)>0 then
				--首回合开始前刷新光环
				local UnitList = {}
				oWorld:enumunit(function(u)
					if u.data.IsDead~=1 and (u.data.type==hVar.UNIT_TYPE.UNIT or u.data.type==hVar.UNIT_TYPE.HERO) then
						UnitList[#UnitList+1] = u
					end
				end)
				--一定要这么弄不然没法刷光环
				local nAuto = oRound.data.auto
				oRound.data.auto = 1
				for i = 1,#UnitList do
					oWorld:reloadaura(UnitList[i],0)
				end
				oRound.data.auto = nAuto
				return oRound:auto(nil,roundStartCode)
			else
				return roundStartCode()
			end
		end)
	else
		--如果不是第一轮，先结束上一回合
		--第一轮时先启动一次自动运行
		--先让回合结束
		return oRound:activeaction(oRound.data.wAction.RoundEnd,"all",hVar.ROUND_DEFINE.ACTIVE_MODE.ALL,function()
			oRound:pop(oRoundToken)
			__CODE__BeforeRoundStart(oWorld,oRound)
			--重新激活所有"回合开始时自动激活"的buff
			return oRound:activeaction(oRound.data.wAction.RoundStart,"all",hVar.ROUND_DEFINE.ACTIVE_MODE.ALL,roundStartCode)
		end)
	end
end

--跳过此回合
hGlobal.event["Event_BattlefieldUnitSkip"] = function(oWorld,oRound,oUnitToSkip)
	oRound:pop(oUnitToSkip)
	--战斗队列更新
	if oWorld.data.IsPaused==1 and oWorld.data.PausedByWhat=="Victory" then
		--战斗已结束
		return
	end
	if oWorld.data.IsQuickBattlefield~=1 then
		hGlobal.event:event("LocalEvent_RoundChanged",oWorld,oRound)
	end
	local oUnit = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.oUnit)
	if oUnit then
		if oUnit.data.id=="round" then
			--新回合
			return hGlobal.event:call("Event_BattlefieldRoundStart",oWorld,oRound)
		else
			--下一个单位行动
			return hGlobal.event:call("Event_BattlefieldUnitActived",oWorld,oRound,oUnit)
		end
	end
end

--对战场单位胜利的处理
hApi.BattlefieldUnitVictory = function(oWorld,oUnitV)
	if oWorld.data.IsQuickBattlefield==1 then
		_DEBUG_MSG("[快速战场] player("..oUnitV.data.owner..")"..oUnitV.data.name.."取得了最终的胜利")
	else
		_DEBUG_MSG("[战场] player("..oUnitV.data.owner..")"..oUnitV.data.name.."取得了最终的胜利")
	end
	oUnitV.data.IsBusy = 0
	local oUnitG = hApi.GetBattleUnit(oUnitV)
	if oUnitG and oUnitG~=oUnitV then
		oUnitG.data.IsBusy = 0
	end
end

--对战场单位失败的处理
hApi.BattlefieldUnitDefeat = function(oWorld,oUnitD)
	oUnitD.data.IsBusy = 0
	local oUnitG = hApi.GetBattleUnit(oUnitD)
	if oUnitG and oUnitG~=oUnitD then
		oUnitG.data.IsBusy = 0
	end
end

local __EnemyCount = 0
local __ENUM__IsAnyEnemyExist = function(oTarget,oUnit)
	if oTarget.data.type==hVar.UNIT_TYPE.UNIT or oTarget.data.type==hVar.UNIT_TYPE.HERO then
		if oTarget.data.owner~=oUnit.data.owner then
			__EnemyCount = 1
		end
	end
end
local __ENUM__GetAllUnit = function(oTarget,rTab)
	if (oTarget.data.type==hVar.UNIT_TYPE.UNIT or oTarget.data.type==hVar.UNIT_TYPE.HERO) and oTarget.data.IsDead~=1 then
		rTab[#rTab+1] = oTarget
	end
end
local __ENUM__ReloadEncounter = function(oTarget,oUnit)
	if (oTarget.data.type==hVar.UNIT_TYPE.UNIT or oTarget.data.type==hVar.UNIT_TYPE.HERO) and oTarget.data.IsDead~=1 then
		--if hApi.IsSafeTarget(oUnit,hVar.ENCOUNTERED_ATTACK_ID,oTarget)==hVar.RESULT_SUCESS then
		if oUnit.data.owner~=oTarget.data.owner then
			oUnit.data.IsEncountered = oUnit.data.IsEncountered + 1
		end
	end
end
local __ENUM__BFStartProcess = function(oTarget,_,_,oWorld)
	if oTarget.data.type==hVar.UNIT_TYPE.HERO then
		--PVP战场内的英雄首回合触发韧性
		if oWorld.data.typeEX==hVar.BF_WORLD_TYPE_EX.PVP then
			local nNoStunRound = math.floor(oTarget.attr.toughness/5)
			if nNoStunRound>0 then
				oTarget.attr.stunimmunity = oTarget.attr.stunimmunity + nNoStunRound
				oTarget:setbuffhint(7500,1,nNoStunRound,{5})
			end
		end
	end
end
local __CODE__BFUnitActived = function(oWorld,oRound,oUnit)
	oUnit.data.rfacing = oUnit.data.facing
	oUnit.data.rgridX = oUnit.data.gridX
	oUnit.data.rgridY = oUnit.data.gridY
	--玩家允许的操作在这里注册
	if oUnit.attr.stun>0 then
		--眩晕的单位啥都不让做
	else
		oRound:enableorder(oUnit,hVar.OPERATE_TYPE.UNIT_MOVE)
		oRound:enableorder(oUnit,hVar.OPERATE_TYPE.NONE)
	end
	--首次轮到单位行动时进行特殊处理
	if oWorld.data.started==0 then
		oWorld.data.started = 1
		oWorld:enumunit(__ENUM__BFStartProcess)
	end
	--回合的行动计数+1
	oRound.data.operatecount = oRound.data.operatecount + 1
	if oWorld.data.IsQuickBattlefield~=1 then
		if oWorld.data.IsReplay==1 then
			--录像
			return hGlobal.event:event("Event_ReplayUnitActived",oWorld,oRound,oUnit)
		elseif oWorld.data.typeEX==hVar.BF_WORLD_TYPE_EX.PVP then
			--PVP战场
			return hApi.NBUnitActived(oWorld,oRound,oUnit)
		else
			return hGlobal.event:event("Event_BattlefieldUnitActived",oWorld,oRound,oUnit)
		end
	end
end
hGlobal.event["Event_BattlefieldUnitActived"] = function(oWorld,oRound,oUnit,param)
	oUnit.data.IsEncountered = 0
	oUnit.attr.activecount = oUnit.attr.activecount + 1
	--任何单位激活时,强制判断战场是否已经胜利，若无敌人则胜利
	__EnemyCount = 0
	oWorld:enumunit(__ENUM__IsAnyEnemyExist,oUnit)
	if __EnemyCount==0 then
		--无敌人则直接胜利
		oWorld:pause(1,"Victory")
		local oUnitV,oUnitD
		local winnerId = oUnit.data.owner
		--中立无敌意的玩家在战场里面拥有者是-1
		if winnerId==-1 then
			winnerId = 0
		end
		for k,v in pairs(oWorld.data.lords)do
			if type(v)=="table" then
				local u = hApi.GetObjectEx(hClass.unit,v)
				if u then
					if u.data.owner==winnerId then
						oUnitV = u
					else
						oUnitD = u
					end
				end
			end
		end
		oRound.data.IsEnd = 1
		hApi.BattlefieldUnitVictory(oWorld,oUnitV)
		hApi.CalculateBattle(oWorld,oUnitV,oUnitD)	--对战斗结果进行结算
		hApi.CalculateBattleUnit(oWorld,oUnitV,oUnitD,"Victory")
		if oUnitD~=nil then
			hApi.BattlefieldUnitDefeat(oWorld,oUnitD)
			hApi.CalculateBattleUnit(oWorld,oUnitV,oUnitD,"Defeat")
		end
		--直接返回不做任何操作
		return
	end
	local tUnit = {}
	oWorld:enumunit(__ENUM__GetAllUnit,tUnit)
	--通用数据处理
	for i = 1,#tUnit do
		tUnit[i]:onAnyUnitActive(oUnit)
		--重新计算单位是否处在光环范围内
		oWorld:reloadaura(tUnit[i],-1)
	end
	--计算单位是否被敌军接近（远程单位将失去远程攻击能力）
	for i = 1,#tUnit do
		--远程单位的特殊处理
		local u = tUnit[i]
		oWorld:enumunitUR(u,1,1,__ENUM__ReloadEncounter,u)
		local id = u.attr.attack[1]--hApi.GetDefaultSkill(oUnit)
		if hVar.tab_skill[id] and hVar.tab_skill[id].template=="RangeAttack" then
			local encounterID = u.attr.encounterID
			if encounterID==0 then
				local eId = hVar.tab_skill[id].encounterID
				if eId and hVar.tab_skill[eId] then
					--如果技能表项里面填写了encounterID,则使用此encounterID作为包围攻击技能
					encounterID = eId
				else
					encounterID = hVar.ENCOUNTERED_ATTACK_ID
				end
			end
			--远程攻击单位被近身后，替换为遭遇攻击的技能ID
			if u.data.IsEncountered>0 then
				if u.attr.attackID==0 then
					u.attr.attackID = encounterID
				end
			elseif u.attr.attackID==encounterID then
				u.attr.attackID = 0
			end
		end
	end
	--移交战场控制权
	oRound:activeunit(oUnit)
	local oUnitC = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.oUnit)
	local nActiveMode = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.nActiveMode)
	if oUnitC~=oUnit then
		--出错啦，这啥情况？
		oUnit = oUnitC
	end
	if oUnit~=nil and oUnit.data.id~="round" then
		--local nUnique = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.nUnique)
		--if nUnique==102 then
			
		--end
		--此调用必须放在末尾
		return oRound:activeaction(oRound.data.wAction.UnitActive,oUnit,nActiveMode,function()
			--如果半中间被别人插了个自动命令进来。。。再走一遍自动命令吧
			if oRound.order.i>0 then
				return oRound:auto(oUnit,function()
					return __CODE__BFUnitActived(oWorld,oRound,oUnit)
				end)
			else
				return __CODE__BFUnitActived(oWorld,oRound,oUnit)
			end
		end)
	end
end

--这个其实是本地事件啊
hGlobal.event:listen("Event_BattlefieldUnitActived","__BF__AICommonOperate",function(oWorld,oRound,oUnit)
	--PVP模式下交给玩家控制，没有AI
	if oWorld.data.typeEX==hVar.BF_WORLD_TYPE_EX.PVP then
		return
	end
	if oUnit:getowner()~=hGlobal.LocalPlayer and oWorld.data.PausedByWhat~="Victory" then
		local AIPlayer = oUnit:getowner()
		local oWorld__ID = oWorld.__ID
		hApi.addTimerOnce("__BF__AICommonOperate",500,function()
			--如果世界结束了，那么不做任何操作
			if oWorld.ID==0 or oWorld__ID~=oWorld.__ID then
				return
			end
			return AIPlayer:order(oWorld,hVar.OPERATE_TYPE.PLAYER_SKIP_UNIT_OPERATE,oUnit)
		end)
	end
end)

hGlobal.event["Event_HeroCaptureEnemy"] = function(oWorld,oUnit,oTarget,nCaptureId)
end

--此事件和界面有关系，以后改！
hGlobal.event["Event_HeroStartTalk"] = function(oWorld,oUnit,oTarget,tTalk)
	local vTalk = hApi.InitUnitTalk(oUnit,oTarget,tTalk,"talk")
	if vTalk and hGlobal.UI.CreateUnitTalk then
		hGlobal.UI.CreateUnitTalk(vTalk)
	end
	return hGlobal.event:event("Event_HeroStartTalk",oWorld,oUnit,oTarget,tTalk)
end

--此事件和界面有关系，以后改！
hGlobal.event["Event_HeroAttackEnemy"] = function(oWorld,oUnit,oTarget)
	--if oTarget ~= nil then
		--g_CombatPower = heroGameAI.CalculateSystem.Calculate(oTarget,nil,heroGameAI.CalculateSystem.CALC_TYPE_DEF.COMBATSCORE)
	--end
	if oUnit.data.IsBusy==1 then
		_DEBUG_MSG("英雄繁忙中，不能攻击敌人！")
		return
	end
	if oTarget.data.IsBusy==1 then
		_DEBUG_MSG("目标繁忙中，不能被攻击！")
		return
	end

	if oUnit:getowner()==oTarget:getowner() then
		_DEBUG_MSG("禁止攻击自己的单位！")
		return
	end
	local oTargetX = oTarget
	local tTeam
	--判断是否攻城
	local oGuard,oVisitor
	local oTown = oTarget:gettown()
	if oTown then
		oVisitor = oTown:getunit("visitor")
		if oVisitor~=nil and oVisitor~=oUnit and oVisitor:gettown()==nil then
			--存在访问者的情况下，直接转向攻击访问者
			return hGlobal.event:call("Event_HeroAttackEnemy",oWorld,oUnit,oVisitor)
		end
		oGuard = oTown:getunit("guard")
		if oGuard then
			oTargetX = oGuard
			--如果城镇具有守城英雄,那么使用守城英雄的部队列表而非城自身的部队列表
			tTeam = oGuard.data.team
		else
			tTeam = oTarget.data.team
		end
	else
		tTeam = oTarget.data.team
	end
	--攻击判断
	if oUnit.data.team==0 then
		_DEBUG_MSG("你没有部队不能攻击敌人")
		return
	else
		local IsHaveEnemy = 0
		if tTeam~=0 then
			for i = 1,#tTeam do
				if tTeam[i] and tTeam[i]~=0 then
					IsHaveEnemy = 1
					break
				end
			end
		end
		if IsHaveEnemy==0 then
			local tabT = oTarget:gettab()
			if oTown~=nil or tabT.seizable==1 then
				--占领无人守卫的建筑
				--同时城市也算是战败了
				local vTalk = hApi.InitTalkAfterBattle(oUnit,oTarget)
				if vTalk~=nil then
					return hApi.CreateUnitTalk(vTalk,function()
						hGlobal.event:event("Event_UnitDefeated",oWorld,oTarget,oUnit:gethero())
						hGlobal.event:call("Event_HeroOccupy",oWorld,oUnit,oTarget)
						return hGlobal.event:event("Event_HeroAttackConfirm",nil,oUnit,true)
					end)
				else
					hGlobal.event:event("Event_UnitDefeated",oWorld,oTarget,oUnit:gethero())
					hGlobal.event:call("Event_HeroOccupy",oWorld,oUnit,oTarget)
					return hGlobal.event:event("Event_HeroAttackConfirm",nil,oUnit,true)
				end
			else
				--没队伍的敌人直接就死了
				oTarget:beforedead(oUnit)
				return oTarget:dead()	--被击败
			end
		end
		--电脑不打非英雄的野怪直接胜利
		if hVar.OPTIONS.AI_HOLY_SHIT==1 then
			if oUnit:getowner()~= hGlobal.LocalPlayer and oTarget:gethero()==nil then
				oTarget:beforedead(oUnit)
				return oTarget:dead()	--被击败
			end
		end
	end

	--判断属方
	local aTypeU = hGlobal.LocalPlayer:allience(oUnit:getowner())
	local aTypeT = hGlobal.LocalPlayer:allience(oTarget:getowner())

	--判断是否需要进入战场
	local oHeroU = oUnit:gethero()
	local oHeroT = oTargetX:gethero()
	local nBFMode = 0
	if aTypeU==hVar.PLAYER_ALLIENCE_TYPE.OWNER or aTypeT==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
		--我方参战
		nBFMode = 1
	elseif oHeroU and oHeroT then
		if aTypeU==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
			--友军参战(攻击)
			if oHeroU:getGameVar("_ALLY")>0 then
				nBFMode = 2
			else
				oHeroU:enumteam(function(oHeroEnum)
					if oHeroEnum:getGameVar("_ALLY")>0 then
						nBFMode = 2
					end
				end)
			end
		elseif aTypeT==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
			--友军参战(被攻击)
			if oHeroT:getGameVar("_ALLY")>0 then
				nBFMode = 3
			else
				oHeroT:enumteam(function(oHeroEnum)
					if oHeroEnum:getGameVar("_ALLY")>0 then
						nBFMode = 3
					end
				end)
			end
		end
	end
	local tTalk,oTalkUnit
	--加载谈话
	if aTypeU==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
		--攻击者是玩家的情况
		if oGuard~=nil then
			oTalkUnit = oGuard
			tTalk = oGuard:gettalk()
		else
			oTalkUnit = oTarget
			tTalk = oTarget:gettalk()
		end
	elseif aTypeT==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
		--被攻击者是玩家的情况
		oTalkUnit = oUnit
		tTalk = oUnit:gettalk()
	elseif oHeroU and oHeroT then
		--其余情况，双方必须都是英雄才能触发对话，并且一定选择被攻击者
		if oGuard~=nil then
			oTalkUnit = oGuard
		else
			oTalkUnit = oTarget
		end
		tTalk = oTalkUnit:gettalk()
	end

	--野外生物逃散(如果没有攻击对话，并且是本地玩家对普通单位进行的攻击(非攻城战)，并且不在AI行动轮中，目标不是英雄)
	if tTalk==nil and oTown==nil and not(heroGameRule.isAiTurn()) and oUnit:getowner()==hGlobal.LocalPlayer and oTarget.data.type==hVar.UNIT_TYPE.UNIT and oTarget:gethero()==nil then
		if hApi.CreateDeterTalk(oUnit,oTarget,1)==hVar.RESULT_SUCESS then
			return
		end
	end

	if nBFMode>0 then
		--需要进入战场的战斗
		hGlobal.BattleField = hApi.CreateBattlefield(oUnit,oTarget)
		--如果AI正在行动
		if heroGameRule.isAiTurn() then
			heroGameAI.ShowAiControl(false)
		end
		hGlobal.BattleField.data.bfdata.EnableQuest = 1		--这个战场可以完成任务
		local ImmediateEnter = 1
		if oTalkUnit~=nil and tTalk~=nil then
			local sTalkName = ""
			if aTypeT==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
				sTalkName = tostring(oTarget.data.id)
			else
				sTalkName = tostring(oUnit.data.id)
			end
			local vTalk = hApi.InitUnitTalk(oUnit,oTalkUnit,tTalk,"attack"..sTalkName)
			if vTalk==nil then
				vTalk = hApi.InitUnitTalk(oUnit,oTalkUnit,tTalk,"attack")
			end
			if vTalk then
				oWorld:pause(1,"Battlefield")
				ImmediateEnter = 0
				hApi.CreateUnitTalk(vTalk,function()
					hUI.Disable(600,"Battlefield")
					hApi.addTimerOnce("EnterBattleAfterTalk",500,function()
						hApi.EnterBattlefield(hGlobal.BattleField,oUnit,oTarget)
					end)
				end)
			end
		end
		if ImmediateEnter==1 then
			oWorld:pause(1,"Battlefield")
			hApi.EnterBattlefield(hGlobal.BattleField,oUnit,oTarget)
		end
	else
		--快速战场战斗
		local _CodeOnAIAttack
		_CodeOnAIAttack = function()
			--------------------
			--快速AI
			local u,t = oUnit,oTarget
			local paramOfCreate = {IsQuickBattlefield = 1,ImmediateLoad=0}
			local codeOnCreate = function(oWorld)
				return oWorld:loadMapGrid(oWorld.data.map)
			end
			local oWorld = hApi.CreateBattlefield(u,t,nil,paramOfCreate,codeOnCreate)
			print("[快速战场]:player("..u.data.owner..")"..u.data.name.." 攻击 player("..t.data.owner..")"..t.data.name)
			local CurRound
			oWorld.data.roundcount = 1
			--快速战场中，控制者必须保证和属方一致，否则会出问题
			oWorld:enumunit(function(u)
				u.data.control = u.data.owner
				u.data.__control = u.data.owner
			end)
			hGlobal.event:call("Event_BattlefieldStart",oWorld)
			local oRound = oWorld:getround()
			local RunCount = 1
			hApi.UpdateAIMemory("init")
			local nLastUnique
			local nErrorCount = 0
			while(oWorld.data.IsPaused~=1 and RunCount<2000)do
				RunCount = RunCount + 1
				if oWorld.data.PausedByWhat=="Victory" then
					break
				else
					local oUnit = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.oUnit)
					local nUnique = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.nUnique)
					if oUnit==nil or nUnique==nLastUnique or nErrorCount>1 then
						break
					elseif oUnit.data.id=="round" then
						--这是啥
						oRound:pop()
						nErrorCount = nErrorCount + 1
					else
						nErrorCount = 0
						nLastUnique = nUnique
						local tAIPlayerMemory,tAIUnitMemory = hApi.UpdateAIMemory(oUnit)
						local AIGrid = oUnit:calculate("AiTarget",tAIPlayerMemory.mode)
						hApi.AIMove(oUnit,AIGrid,tAIUnitMemory)
					end
				end
			end
			hApi.UpdateAIMemory("release")
			local oUnitV = oWorld.handle.__oUnitV
			local oUnitD = oWorld.handle.__oUnitD
			oWorld.handle.__oUnitV = nil
			oWorld.handle.__oUnitD = nil
			u.data.IsBusy = 0
			t.data.IsBusy = 0
			--排错
			if oWorld.data.PausedByWhat~="Victory" then
				--for i = 1,oWorld.__LOG.i do
					--print(oWorld.__LOG[i].key)
				--end
				if u.ID~=0 then
					u.data.IsBusy = 0
				end
				if t.ID~=0 then
					t.data.IsBusy = 0
				end
				_DEBUG_MSG("快速战场运行错误，请查看bf_error.log")
				oWorld:enumunit(function(u)
					xlLG("bf_error","u["..u.data.id.."] player["..u.data.owner.."] name:"..u.data.name.."\n")
				end)
			end
			local bResult = oUnitV==u
			--快速战场对话，因为洪慧敏的bug无法启用
			local oUnitVx = hApi.GetBattleUnit(oUnitV)
			local oUnitDx = hApi.GetBattleUnit(oUnitD)
			local vTalk = hApi.InitTalkAfterBattle(oUnitVx,oUnitDx)
			--如果仅是函数对话
			if vTalk~=nil and hApi.ProcessTalkCodeOnly(vTalk)==1 then
				vTalk = nil
			end
			if vTalk~=nil then
				heroGameAI.ShowAiControl(false)
				--hUI.Disable(0,"NPC_Talk")
				oUnitD.handle.removetime = 0
				hGlobal.event:event("LocalEvent_QuickBattlefieldDefeatTalk",oWorld,oUnitV,oUnitD)
				return hApi.CreateUnitTalk(vTalk,function()
					if oUnitV~=nil then
						hApi.BattlefieldUnitVictory(oWorld,oUnitV)
						hApi.CalculateBattle(oWorld,oUnitV,oUnitD)	--对战斗结果进行结算
						hApi.CalculateBattleUnit(oWorld,oUnitV,oUnitD,"Victory")
					end
					if oUnitD~=nil then
						hApi.BattlefieldUnitDefeat(oWorld,oUnitD)
						hApi.CalculateBattleUnit(oWorld,oUnitV,oUnitD,"Defeat")
					end
					
					oWorld:del()
					hApi.LuaReleaseBattlefield(0)
					local oWorld = hGlobal.WORLD.LastWorldMap
					if oWorld.data.PausedByWhat=="Victory" or oWorld.data.PausedByWhat=="Defeat" then
						--游戏结束了你还想干啥
					else
						heroGameAI.ShowAiControl(true)
						--hUI.Disable(99999,"AI_Move")
						return hGlobal.event:event("Event_HeroAttackConfirm",nil,u,bResult)
					end
				end)
			else
				if oUnitV~=nil then
					hApi.BattlefieldUnitVictory(oWorld,oUnitV)
					hApi.CalculateBattle(oWorld,oUnitV,oUnitD)	--对战斗结果进行结算
					hApi.CalculateBattleUnit(oWorld,oUnitV,oUnitD,"Victory")
				end
				if oUnitD~=nil then
					hApi.BattlefieldUnitDefeat(oWorld,oUnitD)
					hApi.CalculateBattleUnit(oWorld,oUnitV,oUnitD,"Defeat")
				end
				oWorld:del()
				hApi.LuaReleaseBattlefield(0)
				return hGlobal.event:event("Event_HeroAttackConfirm",nil,u,bResult)
			end
		end
		if tTalk~=nil then
			local sTalkName = tostring(oUnit.data.id)
			local vTalk = hApi.InitUnitTalk(oUnit,oTalkUnit,tTalk,"attack"..sTalkName)
			if vTalk==nil then
				vTalk = hApi.InitUnitTalk(oUnit,oTalkUnit,tTalk,"attack")
			end
			if vTalk then
				local _oWorld = hApi.SetObject({},oWorld)
				hUI.Disable(0)
				heroGameAI.ShowAiControl(false)
				oWorld:pause(1,"NpcTalk")
				return hApi.CreateUnitTalk(vTalk,function()
					hUI.Disable(99000,"AIMove")
					heroGameAI.ShowAiControl(true)
					hApi.addTimerOnce("QuickBattleAfterTalk",500,function()
						local oWorld = hApi.GetObject(_oWorld)
						if oWorld then
							oWorld:pause(0)
							return _CodeOnAIAttack()
						else
							hUI.Disable(0)
							heroGameAI.ShowAiControl(false)
						end
					end)
				end)
			end
		end
		return _CodeOnAIAttack()
	end
end

hGlobal.event["Event_HeroEnterTown"] = function(oWorld,oUnit,oBuilding,oTown)
	oTown:setvisitor(oUnit)
	hGlobal.event:event("Event_HeroEnterTown",oWorld,oUnit,oBuilding,oTown)
	local oPlayer = oUnit:getowner()
	if hGlobal.LocalPlayer:allience(oPlayer)==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
		--本地玩家的英雄进城
		local oVisitor = oUnit
		return hGlobal.event:event("LocalEvent_PlayerEnterTown",oBuilding,oTown,oVisitor)
	end
end

hGlobal.event["Event_HeroLeaveTown"] = function(oWorld,oUnit,oBuilding,oTown)
	oTown:setvisitor(nil)
	return hGlobal.event:event("Event_HeroLeaveTown",oWorld,oUnit,oBuilding,oTown)
end

--玩家进入城池(系统触发器,在此事件的第一步执行，禁止删除)
hGlobal.event:listen("LocalEvent_PlayerEnterTown","__SYS_CreateLocalTownWhenEnter",function(oBuilding,oTown,oVisitor)
	--oVisitor可能为空！！！
	if hGlobal.WORLD.LastTown ~=nil then
		hGlobal.WORLD.LastTown:del()
		hGlobal.WORLD.LastTown = nil
	end

	local oWorld = hClass.world:new({
		map = oTown.data.map,
		background = oTown.data.map,
		type = "town",
		ImmediateLoad = 0,
		ProvidePec = oTown.data.ProvidePec,
	})

	hGlobal.WORLD["last_town"] = oWorld
	oWorld:setlordU("building",oBuilding)
	oTown:loadTown(oWorld)
	hGlobal.event:call("Event_WorldCreated",oWorld,0)
	hGlobal.WORLD.LastTown:setlordU("visitor",oVisitor)
	hGlobal.LocalPlayer:focusworld(hGlobal.WORLD.LastTown)
end)

hGlobal.event["Event_HeroLoot"] = function(oWorld,oUnit,oTarget)
--[[	
	local u = oUnit
	local t = oTarget
	local tTab = t:gettab()
	--拾取完就死掉
	t:dead(hVar.OPERATE_TYPE.UNIT_LOOT,u)
	--拾取了资源
	local res = hApi.GetTableRandom("SYS",tTab.loot)
	if res~=nil then
		local resType,resTypeEx,resMin,resMax = unpack(res)
		local resValue = hApi.random(resMin,resMax)
		hApi.UnitGetLoot(oUnit,resType,resTypeEx,resValue,oUnit)
	end
--]]
	return hGlobal.event:event("Event_HeroLoot",oWorld,oUnit,oTarget)
end

hGlobal.event["Event_HeroVisit"] = function(oWorld,oUnit,oTarget)
	--如果是访问后改变动画的建筑，在这里做出调整
	if oTarget.data.animationTag==0 and oTarget.data.type==hVar.UNIT_TYPE.BUILDING then
		local tabT = oTarget:gettab()
		if tabT and tabT.xlobj~=nil and tabT.xlobjv~=nil and oTarget.handle._c~=nil then
			oTarget:setanimation(1)
		end
	end

	return hGlobal.event:event("Event_HeroVisit",oWorld,oUnit,oTarget)
end

hGlobal.event["Event_HeroOccupy"] = function(oWorld,oUnit,oTarget)
	--如果是访问后改变动画的建筑，在这里做出调整
	if oTarget.data.animationTag==0 and oTarget.data.type==hVar.UNIT_TYPE.BUILDING then
		local tabT = oTarget:gettab()
		if tabT and tabT.xlobj~=nil and tabT.xlobjv~=nil then
			oTarget:setanimation(1)
		end
	end

	local oTown = oTarget:gettown()
	local tTgrData = oTarget:gettriggerdata()
	if tTgrData and tTgrData.UnableToOccupy==1 then
		--如果该建筑是不可占领的，直接返回结果并且设置为玩家9所有
		oTarget:setowner(9)
		if oTown then
			oTown.data.owningPlayer = 9
			oTown:setvisitor(nil)
		end
		--占领失败
		return hGlobal.event:event("Event_HeroOccupyFail",oWorld,oUnit,oTarget)
	else
		oTarget:setowner(oUnit.data.owner)
		if oTown then
			oTown.data.owningPlayer = oUnit.data.owner
			oTown:setvisitor(oUnit)
		end
		return hGlobal.event:event("Event_HeroOccupy",oWorld,oUnit,oTarget)
	end
end

hGlobal.event["Event_PlayerGetBuilding"] = function(oWorld,oPlayer,oTarget)
	oTarget:setowner(oPlayer.data.playerId)
	local oTown = oTarget:gettown()
	if oTown then
		oTown.data.owningPlayer = oPlayer.data.playerId
	end
	return hGlobal.event:event("Event_PlayerGetBuilding",oWorld,oPlayer,oTarget)
end

--声明雇佣确认事件
hGlobal.event["Event_HireConfirm"] = function(oUnit,oTarget,tData)

	--local oWorld = oUnit:getworld()
	--if oWorld and hVar.PlayerBehaviorList[oWorld.data.map] then
	--	if oWorld.data.map == "world/level_tyjy" then
	--		--刘备成功从驯兽师处雇佣了单位
	--		if oUnit.data.id == 5000 and oTarget.data.id == 43102 then
	--			LuaAddBehaviorID(100000008)
	--			
	--		--刘备成功从弓箭营雇佣 弓手
	--		elseif oUnit.data.id == 5000 and oTarget.data.id == 43104 then
	--			LuaAddBehaviorID(100000015)
	--		end
	--	end
	--end
	return hGlobal.event:event("Event_HireConfirm",oUnit,oTarget,tData)
end

--声明升级确认事件
hGlobal.event["Event_BuildingUpgrade"] = function(oOperatingUnit,oWorld,oTarget,vOrderId)
	--判断 vOrderId 是建造建筑的ID
	local oTown = oOperatingUnit:gettown()
	if hVar.tab_unit[vOrderId] then
		local oPlayer = oOperatingUnit:getowner()
		if oPlayer==nil then
			return
		end
		local upgradelist = oTown.data.upgrade
		local buildingState = oTown.data.upgradeState
		local resourceCost = {}
		--判断是否满足资源需求
		local price = hVar.tab_unit[vOrderId].price
		if price~=nil then
			for i = 1,#hVar.UNIT_PRICE_DEFINE do
				resourceCost[i] = 0 + (price[i] or 0)
			end
			for i = 1,#hVar.UNIT_PRICE_DEFINE do
				if oPlayer:getresource(hVar.UNIT_PRICE_DEFINE[i])<resourceCost[i] then
					print("[HINT]升级建筑所需的资源:"..(hVar.RESOURCE_KEY_DEFINE[hVar.UNIT_PRICE_DEFINE[i]] or "NONE").."不足！升级失败！")
					return
				end
			end
		end
		--判断是否满足科技
		local requirelist = hVar.tab_unit[vOrderId].require
		if requirelist~=nil then
			local RequireCount = 0
			local requireBase = 0
			local _style = hVar.tab_unit[oOperatingUnit.data.id].townstyle
			--判断当前城内的前置建筑
			if requirelist~=nil and requirelist~=0 then
				--遍历单位判断
				oWorld:enumunit(function(eu)
					for i = 1,#requirelist do
						if type(requirelist[i]) == "table" then
							if _style == requirelist[i][1] and eu.data.id == requirelist[i][2] and buildingState[eu.data.indexOfCreate] == 1 then
								RequireCount = RequireCount +1
							end
							local tabupgrade = hVar.tab_unit[requirelist[i][2]].upgrade
							local tempLen = 2
							for j = 1,tempLen do
								if tabupgrade and  tabupgrade[2] then
									if eu.data.id == tabupgrade[2]then
										RequireCount = RequireCount +1
									end
									tabupgrade = hVar.tab_unit[tabupgrade[2]].upgrade
									if tabupgrade then
										tempLen = tempLen + 1
									end
								end
							end
						elseif type(requirelist[i]) == "number" then
							if eu.data.id == requirelist[i] and buildingState[eu.data.indexOfCreate] == 1 then
								RequireCount = RequireCount +1
							end
							local tabupgrade = hVar.tab_unit[requirelist[i]].upgrade
							if tabupgrade then
								local tempLen = 2
								for j = 1,tempLen do
									if tabupgrade and tabupgrade[2] then
										if eu.data.id == tabupgrade[2] then
											RequireCount = RequireCount+1
										end
										tabupgrade = hVar.tab_unit[tabupgrade[2]].upgrade
										if tabupgrade then
											tempLen = tempLen + 1
										end
									end
								end
							end
						end
					end
				end)
				for i = 1,#requirelist do
					if type(requirelist[i]) == "table" then
						if _style == requirelist[i][1] then
							requireBase = requireBase +1
						end
					elseif type(requirelist[i]) == "number" then
						requireBase = #requirelist
					end
				end
				if RequireCount ~= requireBase then
					print("升级条件不满足")
					return
				end
			end
		end
		--升级成功,刷新数据并重新创造建筑
		do
			for i = 1,#hVar.UNIT_PRICE_DEFINE do
				if (resourceCost[i] or 0)>0 then
					oPlayer:addresource(hVar.UNIT_PRICE_DEFINE[i],-1*resourceCost[i])
				end
			end
			
			oTown.data.buildingCount =oTown.data.buildingCount+1

			local UpGradeList = {}
			local tData = oTown.data
			local tempindexOfTown = oTarget.data.indexOfTown
			local tempindexOfCreat = oTarget.data.indexOfCreate
			local tempfacing = oTarget.data.facing
			
			--默认显示的
			local x,y = oWorld:grid2xy(oTarget.data.gridX,oTarget.data.gridY)
			if vOrderId == oTarget.data.id then
				for i = 1, #upgradelist do
					if upgradelist[i].indexOfCreate == oTarget.data.indexOfCreate then
						upgradelist[i].upgradelist[1] = 1
						UpGradeList = upgradelist[i].upgradelist
						break
					end
				end
				--如果是新创建的建筑
				if buildingState[oTarget.data.indexOfCreate]~=1 then
					--修改雇佣列表(重置产量)
					oTown:__ReloadHireListByIndex(oTarget.data.indexOfCreate,0,vOrderId,1)
					--设置建造状态，该数值用来判断是否可以提供正常的每日收益
					buildingState[oTarget.data.indexOfCreate] = 1
				end
				oWorld:addeffect(96,1,nil,x+10,y+30)
				hApi.PlaySound("build")
				oTarget.handle.s:setOpacity(255)
				local upgradeID = UpGradeList[2]
				--当没有升级列表时判断 该建筑只是建造
				if upgradeID then
					--_frm:show(1)
				else
					for i = 1, #upgradelist do
						if upgradelist[i].indexOfCreate == oTarget.data.indexOfCreate then
							upgradelist[i].upgradelist[2] = 0
							break
						end
					end
				end
				
				--判断是否可以提供多余的人口
				if hVar.tab_unit[oTarget.data.id].population then
					tData.population = tData.population +  hVar.tab_unit[oTarget.data.id].population
				end

				--判断是否可以提供给主城科技
				if hVar.tab_unit[oTarget.data.id].townTech then
					local tech = hVar.tab_unit[oTarget.data.id].townTech
					for i = 1, #tech do
						oTown:settech(tech[i][1],tech[i][2])
					end
				end
				
			else
				--从新构建城内建筑数据表
				local tabU = hVar.tab_unit[vOrderId]
				--根据unil表映射到hirelist 修改升级后的建筑雇佣列表
				tData.unitList[oTarget.data.indexOfCreate][2] = vOrderId
				--修改雇佣列表(替换产兵类型)
				oTown:__ReloadHireListByIndex(oTarget.data.indexOfCreate,0,vOrderId,0)
				--删除原来的单位 并添加新升级的单位
				oTarget:del()
				local target = oWorld:addunit(vOrderId,oTarget:getowner(),nil,nil,tempfacing,oTarget.data.worldX,oTarget.data.worldY)
				target.data.indexOfTown = tempindexOfTown
				target.data.indexOfCreate = tempindexOfCreat
				--再加个特效
				oWorld:addeffect(96,1,nil,x+10,y+30)
				hApi.PlaySound("build")
				--修改uiGame 中添加 targetPanel 所需要的 判断，当升级至顶级时 不需要显示 建造按钮
				if  hVar.tab_unit[vOrderId].upgrade then
					upgradeID = hVar.tab_unit[vOrderId].upgrade[2]
					for i = 1, #upgradelist do
						if upgradelist[i].indexOfCreate == oTarget.data.indexOfCreate then
							upgradelist[i].upgradelist[1] = 1
							upgradelist[i].upgradelist[2] = upgradeID
						end
					end
				else
					for i = 1, #upgradelist do
						if upgradelist[i].indexOfCreate == oTarget.data.indexOfCreate then
							upgradelist[i].upgradelist[1] = 1
							upgradelist[i].upgradelist[2] = 0
						end
					end
				end

				--判断是否可以提供多余的人口
				if hVar.tab_unit[target.data.id].population then
					tData.population = tData.population +  hVar.tab_unit[target.data.id].population
				end
			end

		end
	end
	return hGlobal.event:event("Event_BuildingUpgrade",oOperatingUnit,oWorld,oTarget,vOrderId)
end

-- 打开不能建造升级的消息提示
hGlobal.event["LocalEvent_CannotBuildingUpGrade"] = function()
	return hGlobal.event:event("LocalEvent_CannotBuildingUpGrade")
end

-- 判断玩家是否有剩余行动点数以及建造项
hGlobal.event["LocalEvent_SystemMsgBox"] = function(BuildingRet,MovePointRet)
	return hGlobal.event:event("LocalEvent_SystemMsgBox",BuildingRet,MovePointRet)
end

--城镇变更守卫系列...
hGlobal.event["Event_TownShiftGuardAndVisitor"] = function(oWorld,TownUnit,oGuard,oVisitor,nOperate)
	local oTown = TownUnit:gettown()
	oTown:setguard(oVisitor)
	oTown:setvisitor(oGuard)
	return hGlobal.event:event("Event_TownShiftGuardAndVisitor",oWorld,TownUnit,oGuard,oVisitor,nOperate)
end

hGlobal.event["Event_TownSetGuard"] = function(oWorld,TownUnit,oGuard,nOperate)
	local oTown = TownUnit:gettown()
	oTown:setguard(oGuard)
	return hGlobal.event:event("Event_TownSetGuard",oWorld,TownUnit,oGuard,nOperate)
end

hGlobal.event["Event_TownSetVisitor"] = function(oWorld,TownUnit,oVisitor,nOperate)
	local oTown = TownUnit:gettown()
	oTown:setvisitor(oVisitor)
	return hGlobal.event:event("Event_TownSetVisitor",oWorld,TownUnit,oVisitor,nOperate)
end

--拾取道具
local __TEMP__SetData = function(self,n,a,b,c)
	if self[n]==nil then
		self[n] = {a,b,c}
	else
		self[n][1] = a
		self[n][2] = b
		self[n][3] = c
	end
end
local __TEMP__PickSort = {
	n = 0,
	clear = function(self)
		self.n = 0
		for i = 1,#self,1 do
			__TEMP__SetData(self,i,0,1,0)
		end
	end,
	add = function(self,key,mn,mx)
		if key and mn and mx then
			self.n = self.n + 1
			__TEMP__SetData(self,self.n,key,mn,mx)
		else
			if key=="bag" then
				self.n = self.n + 1
				__TEMP__SetData(self,self.n,key,1,hVar.HERO_BAG_SIZE)
			elseif key=="equip" then
				self.n = self.n + 1
				__TEMP__SetData(self,self.n,key,1,hVar.HERO_EQUIP_SIZE)
			elseif key=="playerbag" then
				self.n = self.n + 1
				__TEMP__SetData(self,self.n,key,1,LuaGetPlayerBagLenByVipLv(LuaGetPlayerVipLv()))
			elseif key=="mapbag" then
				local oWorld = hGlobal.WORLD.LastWorldMap
				if oWorld and oWorld.ID>0 and type(oWorld.data.mapbag)=="table" then
					self.n = self.n + 1
					__TEMP__SetData(self,self.n,key,1,#oWorld.data.mapbag)
				end
			end
		end
	end,
	pick = function(self,oHero,oItem)
		local t = self
		local id = oItem[hVar.ITEM_DATA_INDEX.ID]
		local tabI = hVar.tab_item[id]
		if tabI then
			for n = 1,#self do
				local v = self[n]
				local bag = v[1]
				if bag~=0 then
					for i = v[2],v[3] do
						local CanPushIn = 1
						if oHero:getbagitem(bag,i,"ui")~=nil then
							--该位置有东西
							CanPushIn = 0
						elseif bag=="equip" then
							--如果类型是装备，做一些逻辑判断
							if hApi.GetHeroEquipmentIndexType(tabI.type)~= i then
								--位置不对
								CanPushIn = 0
							elseif hApi.IsAttrMeetEquipRequire(oHero, oHero.attr,id)~=1 then
								--需求不满足
								CanPushIn = 0
							end
						end
						if CanPushIn==1 then
							oHero:shiftitem("loot",oItem,bag,i)
							return 1
						end
					end
				end
			end
		end
		return 0
	end,
}
hGlobal.event["Event_HeroGetItem"] = function(oHero,oItem,sBagName,nIndex,oItemU,oItemX)
	local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
	--获得道具后 根据道具类型初始化额外属性槽子个数 以及具体数值
	local itemID = oItem[hVar.ITEM_DATA_INDEX.ID]
	local tabI = hVar.tab_item[itemID]
	if tabI==nil then
		--你获得了什么？
	else
		--重置临时数据
		__TEMP__PickSort:clear()
		--按顺序指定列表 
		if type(sBagName)=="string" then
			if type(nIndex)=="number" and nIndex~=0 then
				__TEMP__PickSort:add(sBagName,nIndex,nIndex)
			else
				__TEMP__PickSort:add(sBagName)
			end
		end
		if oHero.data.HeroCard==1 then
			
			if nIndex~=0 then
				--非使用型道具，尝试装备给英雄
				if tabI.type~=hVar.ITEM_TYPE.DEPLETION then
					__TEMP__PickSort:add("equip")
				end
				--先放进背包
				__TEMP__PickSort:add("bag")
				--尝试塞到玩家背包
				__TEMP__PickSort:add("playerbag")
			end
			--如果失败了，丢到邮件里面
			--2014年5月22日 为了解决 背包满 仓库满 的情况下，通过任务奖励获得的道具 会丢失的问题， 
			--在这里加入 流程 增加到 礼品背包中 按照李宁的 叮嘱 在这里写 添加至礼品背包流程 
			--李宁拥有最终解释权 【陶晶 2014-5-22】 
			if __TEMP__PickSort:pick(oHero,oItem)~=1 then
				--拥有卡片的英雄尝试塞到邮件系统里
				if LuaAddItemToGiftBag(oItem) == 1 then
					if hGlobal.UI.SystemMenuBar then
						hGlobal.UI.SystemMenuBar.childUI["giftbtn"]:setstate(1)
					end
					local itemLv = hVar.tab_item[itemID].itemLv or 1
					if itemLv == 4 and itemID ~= 9006 then	--排除黄金宝箱
						LuaAddItemStatisticsLog(itemID,"A")
					end
				else
					--失败的话发日志
					
				end
			end
			if tabI.type==hVar.ITEM_TYPE.DEPLETION then
				--获得了箱子
				if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
					local itemCount = xlGetIntFromKeyChain(g_curPlayerName.."GetDepletionItem"..itemID) + 1
					local new_itemCount = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."GetDepletionItem"..itemID) + 1
					if new_itemCount == 1 then
						new_itemCount = itemCount
					end
					xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."GetDepletionItem"..itemID,new_itemCount)
				end
			else
				local itemLv = tabI.itemLv or 1
				--新获得了道具(非限时道具)
				if oItem[hVar.ITEM_DATA_INDEX.SLOT]==-1 and itemLv>0 and tabI.continuedays==nil then
					local nSlotNum = hApi.CalculateItemRewardEx(itemID)
					oItem[hVar.ITEM_DATA_INDEX.SLOT] = hApi.NumTable(nSlotNum+1)
					oItem[hVar.ITEM_DATA_INDEX.SLOT][1] = nSlotNum
					
					--只有道具lv 为4品质时候 进行记录 mode == 1 记录为拾取红装
					if itemLv == 4 and itemID ~= 9006 then	--排除黄金宝箱
						LuaAddItemStatisticsLog(itemID,"A")
					end
				end
			end
		else
			if nIndex~=0 then
				--非使用型道具，尝试装备给英雄
				if tabI.type~=hVar.ITEM_TYPE.DEPLETION then
					__TEMP__PickSort:add("equip")
				end
				--没有卡片的英雄尝试塞到地图背包
				__TEMP__PickSort:add("mapbag")
			end
			if __TEMP__PickSort:pick(oHero,oItem)~=1 then
				--print("丢了")
			end
		end
		--如果有物品单位，那么拾取成功后删除改装备
		--请不要对这俩对象做多余的操作
		if oItemU then
			oItemU:dead(hVar.OPERATE_TYPE.UNIT_LOOT,oHero:getunit())
		end
		if oItemX then
			oItemX:del()
		end
		return hGlobal.event:event("Event_HeroGetItem",oHero,oItem,sBagName,nIndex)
	end
end
--扔到道具
hGlobal.event["Event_HeroDropItem"] = function(oHero,oWorld,itemID,fromIndex,itemstack,rewardEx,item_version,item_uniqueID)
	local u = oHero:getunit()
	oWorld:additem(itemID,u.data.owner,u.data.gridX,u.data.gridY,0,nil,nil,itemstack,rewardEx,item_version,item_uniqueID)
	oHero.data.item[fromIndex] = 0
	return hGlobal.event:event("Event_HeroDropItem",oHero,oWorld,itemID,fromIndex,itemstack)
end

--交换道具
hGlobal.event["Event_HeroSortItem"] = function(oHero,IsUpdateAttr,ByWhatOperate)
	LuaSaveHeroCard("HeroItemShift")
	return hGlobal.event:event("Event_HeroSortItem",oHero,IsUpdateAttr,ByWhatOperate)
end

--交换道具
hGlobal.event["Event_HeroCardSortItem"] = function(nHeroId)
	LuaSaveHeroCard("HeroCardItemShift")
	return hGlobal.event:event("Event_HeroCardSortItem",nHeroId)
end

--在地图上掉落道具
hGlobal.event["Event_WorldDropItem"] = function(oUnit)
	return hGlobal.event:event("Event_WorldDropItem",oUnit)
end

--本地玩家打开玩家信息面板的事件
hGlobal.event["LocalEvent_ShowPlayerInfoFram"] = function(playerinfo,index)
	return hGlobal.event:event("LocalEvent_ShowPlayerInfoFram",playerinfo,index)
end

--本地玩家获得英雄卡片事件
hGlobal.event["LocalEvent_GetHeroCard"] = function(oHero,mode,prizeid)
	if type(oHero)=="table" and LuaAddNewHeroCard(oHero.data.id, oHero.attr.star, oHero.attr.level)==1 then
		--oHero.data.HeroCard = 1
		if mode=="ReadGameData" then
			local tCard = hApi.GetHeroCardById(oHero.data.id)
			if tCard then
				tCard.attr.exp = oHero.attr.exp
				tCard.attr.level = hApi.GetLevelByExp(tCard.attr.exp)
				for i = 1,hVar.HERO_BAG_SIZE do
					tCard.item[i] = hApi.CopyObjectItem(oHero.data.item[i])
				end
				for i = 1,hVar.HERO_EQUIP_SIZE do
					tCard.equipment[i] = hApi.CopyObjectItem(oHero.data.equipment[i])
				end
			end
			oHero:LoadHeroFromCard("getcard")
		elseif mode=="BuyHeroCard" then
			--oHero:LoadHeroFromCard("buycard")
		else
			oHero:LoadHeroFromCard("getcard")
		end

		--玩家行为统计
		--if hGlobal.WORLD.LastWorldMap then
		--	local oWorld = hGlobal.WORLD.LastWorldMap
		--	if hVar.PlayerBehaviorList[oWorld.data.map] then
		--		--桃园结义
		--		if oWorld.data.map == "world/level_tyjy" then
		--			--是刘备
		--			if oHero.data.id == 5000 then
		--				LuaAddBehaviorID(100000001)
		--			end
		--		end
		--	end
		--end

		return hGlobal.event:event("LocalEvent_GetHeroCard",oHero,nil,prizeid)
	end
end

hGlobal.event["Event_SetTownTech"] = function(oTown)
	return hGlobal.event:event("Event_SetTownTech",oTown)
end

hGlobal.event["LocalEvent_PlayerLeaveBattlefield"] = function(oPlayer)
	return hGlobal.event:event("LocalEvent_PlayerLeaveBattlefield",oPlayer)
end

hGlobal.event["LocalEvent_PlayerFocusWorld"] = function(sSceneType,oWorld,oMap)
	if oWorld~=nil then
		hGlobal.SceneEvent:switch(oWorld.data.type)
	end
	--print("event LocalEvent_PlayerFocusWorld", sSceneType,oWorld,oMap)
	return hGlobal.event:event("LocalEvent_PlayerFocusWorld",sSceneType,oWorld,oMap)
end


--------------------------------------------------------------
-- 检查玩家是否拥有足够的金钱
local __nCurRmbNum = 0
local __CODE__ReadGameRmb = function(nCurRmb)
	if type(nCurRmb)=="number" then
		__nCurRmbNum = nCurRmb
	else
		__nCurRmbNum = 0
	end
end
hGlobal.event:listen("LocalEvent_SetCurGameCoin","__setGameCoin",__CODE__ReadGameRmb)
hGlobal.event:listen("LocalEvent_Phone_SetCurGameCoin_Game","__setGameCoin",__CODE__ReadGameRmb)

hApi.IfPlayerHaveMoney = function(sType,nNum,pLabel)
	local nCurrentNum = 0
	if sType=="score" then
		nCurrentNum = LuaGetPlayerScore() or 0
	elseif sType=="rmb" then
		if g_cur_net_state==1 then
			nCurrentNum = __nCurRmbNum
		else
			nCurrentNum = -1
		end
	end
	if nCurrentNum>=nNum then
		if pLabel then
			pLabel:setString(nNum.." ")
			pLabel:setColor(ccc3(255,255,255))
		end
		return hVar.RESULT_SUCESS
	else
		if pLabel then
			pLabel:setString(nNum.." ")
			pLabel:setColor(ccc3(255,0,0))
		end
		return hVar.RESULT_FAIL
	end
end

hApi.GetPlayerMoney = function(sType,pLabel)
	local nCurrentNum = 0
	if sType=="score" then
		nCurrentNum = LuaGetPlayerScore() or 0
	elseif sType=="rmb" then
		if g_cur_net_state==1 then
			nCurrentNum = __nCurRmbNum
		else
			nCurrentNum = -1
		end
	end
	if pLabel then
		if nCurrentNum>=0 then
			pLabel:setString(nNum.." ")
		else
			pLabel:setString("...")
		end
	end
	return nCurrentNum
end