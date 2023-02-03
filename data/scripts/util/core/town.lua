-----------------------------------
--@ by EFF 2012/12/25
--@游戏中的主城类
--@主城是一个特殊的战场逻辑层
hClass.town = eClass:new("static enum sync")
hClass.town:sync("simple",{"unitList","CreateIndex2TownIndex","upgradeState","guard","visitor","unitB","hireList","shopList"})
local _ht = hClass.town
_ht.__static = {}
local __DefaultParam = {
	ID = 0,
	owningPlayer = 0,
	name = "默认城堡",
	map = hVar.DEFAULT_TOWN,
	mapBackground = 0,
	buildingCount = 0,
	unitList = 0,
	townData = 0,
	upgrade = 0,
	--require = 0,
	upgradeState = 0,
	guard = 0,
	visitor = 0,
	unitB = 0,
	technologyLevel = 0,
	population = 0,		--通过可以提供人口的建筑 累加的人口值
	academyskill = 0,	--翰林院的技能表 通过规则生成后不再变化...
	scoreCount = 0,		--玩家如果从这座城获得一次积分，此数值便+1，多次从同一座城获得积分将产生递减
	LastProvideDate = 0,	--上一次提供主城产量的日期
	ProvidePec = 100,	--主城资源产量百分比
}
--初始化
_ht.init = function(self,p)
	self.data = hApi.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	--self.handle = hApi.clearTable(0,rawget(self,"handle") or {})
	local d = self.data
	local mapBackground,unitList = hApi.LoadMap(d.map,hVar.DEFAULT_TOWN)
	d.buildingCount = 0
	d.mapBackground = mapBackground or 0
	d.unitList = unitList or 0
	d.CreateIndex2TownIndex = {}
	d.townData = {}
	d.upgrade = {} -- 升级列表 陶晶 2013-4-12 
	d.upgradeState = {}
	d.guard = {}
	d.visitor = {}
	d.unitB = {}
	d.academyskill = {}
	hApi.SetObjectUnit(d.unitB,p.unit)


	--初始化主城科技，目前只有 攻击和防御两项
	d.technologyLevel = {}
	local tech = d.technologyLevel
	for i = 1,#hVar.TECHNOLOGY_TYPE do
		tech[hVar.TECHNOLOGY_TYPE[i]] = 0
	end
	
	d.population = 0
	d.owningPlayer = p.unit.data.owner

	--保存至玩家信息表中
	local index = #hGlobal.player[d.owningPlayer].data.ownTown
	hGlobal.player[d.owningPlayer].data.ownTown[index+1] = {}
	hApi.SetObjectUnit(hGlobal.player[d.owningPlayer].data.ownTown[index+1],p.unit)
	if unitList then
		for i = 1,#unitList do
			local _,id,owner,worldX,worldY,facing,triggerID = unpack(unitList[i])
			local tabU = hVar.tab_unit[id]
			d.CreateIndex2TownIndex[i] = 0
			d.upgradeState[i] = 0

			if tabU~=nil and tabU.type==hVar.UNIT_TYPE.BUILDING then
				local hireList = hApi.ReadListParam(tabU.hireList,4)
				--拥有雇佣列表或者是市场
				if hireList or (tabU.interaction and hApi.HaveValue(tabU.interaction,hVar.INTERACTION_TYPE.MARKET)) then
					local index = #d.townData+1
					d.townData[index] = {
						id = id,
						indexOfTown = index,
						indexOfCreate = i,
						hireList = hireList or 0,
						shopList = 0,
					}
					d.CreateIndex2TownIndex[i] = index
				end
				
				--构造升级列表
				local tempupgradelist = hApi.LoadTableWithDepth(tabU.upgrade,2,0)
				if tempupgradelist then
					local index = #d.upgrade+1
					d.upgrade[index] = {
						indexOfTown = index,
						indexOfCreate = i,
						upgradelist = tempupgradelist or 0
					}

					if tempupgradelist[1] == 1 then
						d.upgradeState[i] = 1
					end

				else
					d.upgradeState[i] = 1
				end
			end
		end
	end
	self:setAcademySkill()
	self:buildingInit()
end

_ht.destroy = function(self)

end

_ht.__ReloadHireListByIndex = function(self,indexOfCreate,indexOfData,nUnitId,IsResetHireNum)
	if not(hVar.tab_unit[nUnitId] and hVar.tab_unit[nUnitId].hireList) then
		return
	end
	local tList = self.data.townData
	local tData
	if indexOfData>0 and tList[indexOfData] and tList[indexOfData].indexOfCreate==indexOfCreate then
		tData = tList[indexOfData]
	end
	if tData==nil then
		for i = 1,#tList do
			if tList[i] and tList[i].indexOfCreate==indexOfCreate then
				tData = tList[i]
				break
			end
		end
	end
	if tData==nil then
		return
	end
	local tHireList = tData.hireList
	local tHireListU = hVar.tab_unit[nUnitId].hireList
	if type(tHireList)~="table" then
		return
	end
	--替换雇佣类型
	if nUnitId~=tData.id then
		for i = 1,#tHireList do
			if tHireListU[i] then
				tHireList[i][1] = tHireListU[i][1]
			end
		end
	end
	--重置生物产量
	if IsResetHireNum==1 then
		local population = self.data.population
		local tProvideEx = hApi.LoadPlayerProvideEx(self.data.owningPlayer)
		for i = 1,#tHireList do
			local v = tHireList[i]
			if v[3]>0 then
				local growthParamExtra = (v[4] or 0)
				v[2] = v[3] + hApi.floor(growthParamExtra*population/100)
				if tProvideEx and type(tProvideEx[v[1]])=="number" then
					v[2] = v[2] + tProvideEx[v[1]]
				end
			end
		end
	end
end

_ht.providearmy = function(self,IsFirstWeek,tProvideEx)
	local d = self.data
	local townData = self.data.townData
	local population = self.data.population
	local buildingState = self.data.upgradeState
	if hGlobal.WORLD.LastWorldMap then
		d.LastProvideDate = hGlobal.WORLD.LastWorldMap.data.roundcount + 1
	else
		d.LastProvideDate = 1
	end
	if IsFirstWeek==1 then
		--print("主城提供产量")
		for i = 1, #townData do
			if townData[i] and townData[i].hireList ~= 0 then
				local hL = townData[i].hireList
				for n = 1,#hL do
					local v = hL[n]
					local growthNumBasic = v[3]
					--产量系数,将主城的产量系数转换为生物个数
					local growthParamExtra = (v[4] or 0)
					--由于主城额外产量带来的系数
					local growthNumExtra = hApi.floor(growthParamExtra*population/100)
					--如果基本产量大于0，且存在扩展产量，那么增加额外的产量
					if growthNumBasic>0 and tProvideEx and tProvideEx[v[1]] and type(tProvideEx[v[1]])=="number" then
						growthNumExtra = growthNumExtra + tProvideEx[v[1]]
						--print("额外产量",v[1],tProvideEx[v[1]],growthNumExtra)
					end
					--提供首周生物产量
					v[2] = math.max(0, growthNumBasic + growthNumExtra)
				end
			end
		end
	else
		for i = 1, #townData do
			if townData[i] and townData[i].hireList ~= 0 and buildingState[townData[i].indexOfCreate]==1 then
				local hL = townData[i].hireList
				for n = 1,#hL do
					local v = hL[n]
					local growthNumBasic = v[3]
					--产量系数,将主城的产量系数转换为生物个数
					local growthParamExtra = (v[4] or 0)
					--由于主城额外产量带来的系数
					local growthNumExtra = hApi.floor(growthParamExtra*population/100)
					--如果基本产量大于0，且存在扩展产量，那么增加额外的产量
					if growthNumBasic>0 and tProvideEx and tProvideEx[v[1]] and type(tProvideEx[v[1]])=="number" then
						growthNumExtra = growthNumExtra + tProvideEx[v[1]]
					end
					--print("主城产量",hVar.tab_unit[v[1]].name,growthNumBasic + growthNumExtra)
					--至多产生两倍于基本产量的兵种
					v[2] = math.min(v[2] + math.max(0, growthNumBasic + growthNumExtra),(growthNumBasic + growthNumExtra)*2)
				end
			end
		end
	end
end

--test code 
--local checktempID = function(v,IDlist)
	--for i = 1,#IDlist do
		--if IDlist[i][2] and IDlist[i][3] then
			--if IDlist[i][1] == v[1] and IDlist[i][2] == v[2] and IDlist[i][3] == v[3] then
				--return 1
			--end
		--else
			--if IDlist[i][1] == v[1] then
				--return 1
			--end
		--end
	--end
	--return 0
--end


local __GetUpgradeID
__GetUpgradeID = function(nId,nUpLv,oId)
	if nUpLv<=0 then
		return oId or nId
	end
	local tabU = hVar.tab_unit[nId]
	if tabU and tabU.type==hVar.UNIT_TYPE.BUILDING then
		if tabU.upgrade and type(tabU.upgrade[2])=="number" then
			return __GetUpgradeID(tabU.upgrade[2],nUpLv-1,nId)
		else
			return nId
		end
	else
		return oId
	end
end

local __MarkBuildingID
__MarkBuildingID = function(id,nIndex,tTab,nDepth)
	nDepth = nDepth or 1
	if nDepth>5 then
		return
	end
	if hVar.tab_unit[id] and hVar.tab_unit[id].type==hVar.UNIT_TYPE.BUILDING then
		if tTab[id]==nil then
			tTab[id] = {nDepth}
		end
		tTab[id][#tTab[id]+1] = {nIndex,0}
		if hVar.tab_unit[id].upgrade then
			local upID = hVar.tab_unit[id].upgrade[2]
			if upID and hVar.tab_unit[upID] then
				return __MarkBuildingID(upID,nIndex,tTab,nDepth+1)
			end
		end
	end
end

local __GetUpgradeIndex = function(tIndex,upLv)
	local chooseI = 0
	for i = 2,#tIndex do
		if tIndex[i][2]<upLv then
			chooseI = i
			if tIndex[i][2]==0 then
				break
			end
		end
	end
	if chooseI>0 then
		tIndex[chooseI][2] = upLv
		return tIndex[chooseI][1]
	else
		return 0
	end
end

local __GetUpgradeLv = function(mode,v,tTemp)
	if type(v)=="table" then
		if mode=="upgrade" then
			--老的buildupgradelist
			local id = v[1]
			if tTemp[id] then
				local upLv = (v[2] or 0)+1
				local upgradeI = __GetUpgradeIndex(tTemp[id],upLv)
				if upgradeI>0 then
					return upLv,upgradeI
				end
			end
		else
			--老的buildInit
			local id = v[1]
			if tTemp[id] then
				local upLv = tTemp[id][1]
				local upgradeI = __GetUpgradeIndex(tTemp[id],upLv)
				if upgradeI>0 then
					return upLv,upgradeI
				end
			end
		end
	else
		--新的
		local id = v
		if tTemp[id] then
			local upLv = tTemp[id][1]
			local upgradeI = __GetUpgradeIndex(tTemp[id],upLv)
			if upgradeI>0 then
				return upLv,upgradeI
			end
		end
	end
end

local __InitUpgradeTemp = function(mode,tUpgrade,tTemp,tTempU)
	if type(tUpgrade)~="table" then
		return
	end
	if tUpgrade[1]=="all" or (type(tUpgrade[1])=="table" and tUpgrade[1][1] == "all") then
		--全部建造
		for k,v in pairs(tTemp)do
			if v[1]==1 then
				for i = 2,#v do
					v[i][2] = 1
					tTempU[v[i][1]] = 1
				end
			end
		end
		if #tUpgrade>1 then
			for i = 2,#tUpgrade do
				local nUpgradeLv,nIndex = __GetUpgradeLv(mode,tUpgrade[i],tTemp)
				if nUpgradeLv then
					tTempU[nIndex] = math.max(tTempU[nIndex] or 0,nUpgradeLv)
				end
			end
		end
	else
		--根据列表建造
		for i = 1,#tUpgrade do
			local id = tUpgrade[i]
			local nUpgradeLv,nIndex = __GetUpgradeLv(mode,id,tTemp)
			if nUpgradeLv then
				--成功建造
				local nCurLv = tTempU[nIndex] or 0
				tTempU[nIndex] = math.max(nCurLv,nUpgradeLv)
			else
				--建造失败的话，可能是升级科技
				local tabU = hVar.tab_unit[id]
				if tabU and tabU.townTech then
					--重复建造同一建筑可能是科技升级
					tTempU.tech[id] = (tTempU.tech[id] or 0) + 1
				end
			end
		end
	end
end

--在初始化城镇时 根据data文件中的初始化描述进行一次 城镇建筑初始化建筑
_ht.buildingInit = function(self)
	local d = self.data
	--初始化建造表
	local unitB = hApi.GetObjectUnit(self.data.unitB)
	local tData = unitB:gettriggerdata()
	if tData and (tData.buildInit or tData.buildupgradelist or tData.buildAlready) then
		--生成一遍科技树
		local tTemp = {}
		local tTempU = {tech={}}
		for i = 1,#d.unitList do
			local _,id,_,x,y,_,_ = unpack(d.unitList[i])
			__MarkBuildingID(id,i,tTemp)
		end
		__InitUpgradeTemp("normal",tData.buildAlready,tTemp,tTempU)
		__InitUpgradeTemp("normal",tData.buildInit,tTemp,tTempU)
		__InitUpgradeTemp("upgrade",tData.buildupgradelist,tTemp,tTempU)
		--for k,v in pairs(tTemp)do
			--print(k,unpack(v))
		--end
		--print("----------------------------------")
		--for k,v in pairs(tTempU)do
			--print(k,v)
		--end
		--根据计算完毕的升级数量，对建筑进行升级
		for i = 1,#d.upgrade do
			local v = d.upgrade[i]
			if (tTempU[v.indexOfCreate] or 0)>0 then
				local id = __GetUpgradeID(d.unitList[v.indexOfCreate][2],tTempU[v.indexOfCreate])
				if id and hVar.tab_unit[id] and (d.upgradeState[v.indexOfCreate]==0 or d.unitList[v.indexOfCreate][2]~=id) then
					--print(i,hVar.tab_unit[d.unitList[v.indexOfCreate][2]].name,d.upgradeState[v.indexOfCreate])
					--print("	- 升级为",tTempU[v.indexOfCreate],hVar.tab_unit[id].name)
					local nUpgradeStateOld = d.upgradeState[v.indexOfCreate]
					local id_old = d.unitList[v.indexOfCreate][2]
					local tabU = hVar.tab_unit[id]
					local tabU_Old = hVar.tab_unit[id_old]
					d.unitList[v.indexOfCreate][2] = id
					if tabU_Old and nUpgradeStateOld==1 then
						--有老建筑的话
						--移除老建筑的人口加成
						if tabU_Old.population then
							d.population = d.population - tabU_Old.population
						end
					end
					--更新该建筑的升级信息
					v.upgradelist[1] = 1
					d.upgradeState[v.indexOfCreate] = 1
					if tabU.upgrade and tabU.upgrade[2]~=id then
						v.upgradelist[2] = tabU.upgrade[2] or 0
					else
						v.upgradelist[2] = 0
					end
					--替换为新建筑的人口加成
					if tabU.population then
						d.population = d.population + tabU.population
					end
					--增加科技
					if tabU.townTech then
						for i = 1, #tabU.townTech do
							local name,val = tabU.townTech[i][1],tabU.townTech[i][2]
							local bounceLv = tTempU.tech[id] or 0
							self:settech(name,val+bounceLv,0)
						end
					end
				end
			end
		end
		--最后重新读取建筑产量
		for i = 1,#d.upgrade do
			local v = d.upgrade[i]
			if d.upgradeState[v.indexOfCreate]==1 and (tTempU[v.indexOfCreate] or 0)>0 then
				self:__ReloadHireListByIndex(v.indexOfCreate,0,d.unitList[v.indexOfCreate][2],1)
			end
		end
	end
	--提供生物产量
	if hGlobal.WORLD.LastWorldMap and hGlobal.WORLD.LastWorldMap.data.IsLoading==2 then
		--从存档读取时的产量在其他地方提供
	else
		self:providearmy(1)
	end
end
----------------------------------------------
--重新读取后，把地图外面的单位赛回城里去
_ht.__InitAfterLoaded = function(self)
	local d = self.data
	local oVisitor = self:getunit("visitor")
	local oGuard = self:getunit("guard")
	d.guard = {}
	d.visitor = {}
	if d.scoreCount==nil then
		d.scoreCount = 0
	end
	--对资源产量百分比的支持
	d.ProvidePec = d.ProvidePec or 100
	--增加主城科技存档的兼容性
	if d.technologyLevel == nil or d.technologyLevel == 0 then
		d.technologyLevel = {}
		local tech = d.technologyLevel
		for i = 1,#hVar.TECHNOLOGY_TYPE do
			tech[hVar.TECHNOLOGY_TYPE[i]] = 0
		end
	end
	self:setvisitor(oVisitor)
	self:setguard(oGuard)
	--增加产兵兼容性
	if d.LastProvideDate==nil then
		if hGlobal.WORLD.LastWorldMap then
			d.LastProvideDate = hGlobal.WORLD.LastWorldMap.data.roundcount + 1
		else
			d.LastProvideDate = 1
		end
	end
end

local __townData,__CreateIndex2TownIndex
local __CodeOnCreateUnit = function(u,i,triggerID)
	local _townData = __townData
	local index = __CreateIndex2TownIndex[i] or 0
	if _townData[index] and _townData[index]~=0 then
		u.data.indexOfTown = index
		u.data.hireList = _townData[index].hireList
		u.data.shopList = _townData[index].shopList
	end
end

_ht.loadTown = function(self,oWorld)
	local d = self.data
	if oWorld.data.type=="town" then
		__CreateIndex2TownIndex = d.CreateIndex2TownIndex
		__townData = d.townData
		oWorld:loadMapTile(d.mapBackground)
		oWorld:loadAllObjects(d.unitList,nil,__CodeOnCreateUnit)
	end
end

_ht.getunit = function(self,mode)
	if mode == nil then
		return hApi.GetObjectUnit(self.data.unitB)
	elseif mode == "visitor" then
		return hApi.GetObjectUnit(self.data.visitor)
	elseif mode == "guard" then
		return hApi.GetObjectUnit(self.data.guard)
	else
		return hApi.GetObjectUnit(self.data.unitB)
	end
end

_ht.setguard = function(self,oUnit)
	if oUnit~=nil then
		hApi.SetObjectUnit(self.data.guard,oUnit)
		oUnit.data.curTown = self.ID
		oUnit:sethide(1) --隐藏单位
		local oHero = oUnit:gethero()
		if oHero then
			oHero.data.AIMode = hVar.AI_MODE.GUARD
		end
		hApi.chaShowPath(oUnit.handle,0)
	else
		hApi.SetObjectUnit(self.data.guard,nil)
	end
	local TownUnit = self:getunit()
	if TownUnit==nil then
		_DEBUG_MSG("[LOGIC WARNING]对没有单位的oTown设置守卫")
		return
	end
	--获取城镇守卫 并且在城镇上添加一个 英雄头像图标
	local worldX1,worldY1 = TownUnit:getstopXY()
	local worldX2,worldY2 = TownUnit:getXY()
	local oGuard = hApi.GetObjectUnit(self.data.guard)
	local posX = worldX1 - worldX2
	local directionX = 0
	--大于0时 向→偏移
	if posX > 0 then
		directionX = 20
	--小于0时 向←偏移
	elseif posX < 0 then
		directionX = -20
	end
	if oGuard then
		--设置单位左上图标
		hApi.safeRemoveT(TownUnit.chaUI,"guardImagenBG")
		hApi.safeRemoveT(TownUnit.chaUI,"guardImage")
		TownUnit.chaUI["guardImagenBG"] = hUI.image:new({
			parent = TownUnit.handle._tn,
			model = "UI_frm:slot",
			animation = "lightSlim",
			w = 50,
			h = 50,
			x = posX - directionX,
			y = -(worldY1 - worldY2) + 45,
		})
		TownUnit.chaUI["guardImage"] = hUI.thumbImage:new(
		{
			parent = TownUnit.handle._tn,
			model = hVar.tab_unit[oGuard.data.id].icon, --hVar.tab_unit[5000].icon,
			w = 44,
			h = 44,
			x = posX - directionX,
			y = -(worldY1 - worldY2) + 45,
		})
	else
		hApi.safeRemoveT(TownUnit.chaUI,"guardImagenBG")
		hApi.safeRemoveT(TownUnit.chaUI,"guardImage")
	end
end

_ht.setvisitor = function(self,oUnit)
	if oUnit~=nil then
		hApi.SetObjectUnit(self.data.visitor,oUnit)
		oUnit.data.curTown = self.ID

		if oUnit.data.IsHide==1 then
			--只有隐藏恢复的时候才会设置
			--设置访问者坐标
			local w = self:getunit():getworld()
			local wx,wy = self:getunit():getstopXY()
			local x, y = hApi.Scene_GetSpace(wx, wy, 60)
			local gridX, gridY = w:xy2grid(x,y)
			oUnit:setgrid(gridX,gridY)

			--设置访问者显示
			oUnit:sethide(0)
		end
		local oHero = oUnit:gethero()
		if oHero and oHero.data.AIMode==hVar.AI_MODE.GUARD then
			oHero.data.AIMode = oHero.data.AIModeBasic
		end
	else
		hApi.SetObjectUnit(self.data.visitor,nil)
	end

	local oGuard = hApi.GetObjectUnit(self.data.guard)
	if oGuard == nil then
		local TownUnit = self:getunit()
		if TownUnit then
			hApi.safeRemoveT(TownUnit.chaUI,"guardImagenBG")
			hApi.safeRemoveT(TownUnit.chaUI,"guardImage")
		end
	end
end

--交换守卫和访问者
_ht.shiftVG = function(self)
	local vU = hApi.GetObjectUnit(self.data.visitor)
	local gU = hApi.GetObjectUnit(self.data.guard)

	if vU and gU then
		self:setvisitor(gU)
		self:setguard(vU)
	end
end

--设置城的科技等级
_ht.settech = function(self,mode,level,IfWithEvent)
	local tech = self.data.technologyLevel
	if tech[mode] then
		tech[mode] = level
		if IfWithEvent~=0 then
			hGlobal.event:call("Event_SetTownTech",self)
		end
		return 1 
	end
end


local tempIDlist = {
	41060,
	41061,
	41062,
	41063,
	41064,
}

local fuckchecktempID = function(unitID,IDlist)
	for i = 1,#IDlist do
		if IDlist[i] == unitID then
			return 1
		end
	end
	return 0
end

--测试用临时代码
_ht.gettech = function(self,mode)
	local tech = self.data.technologyLevel
	
	--现在的 城镇等级
	if mode == "towerlevel" or mode == nil then
		local level = 0
		local maxlevel = 0
		for i =1,#self.data.unitList do
			local _,id,_,_,_,_,_ = unpack(self.data.unitList[i])
			if fuckchecktempID(id,tempIDlist) == 1 then 
				maxlevel = maxlevel + 1
				if (self.data.upgradeState[i] or 0)>0 then
					level = level + 1
				end
			end
		end
		return level,maxlevel
	end

	for i = 1,#hVar.TECHNOLOGY_TYPE do
		
		if mode == hVar.TECHNOLOGY_TYPE[i] then
			return tech[mode] or 0
		end
	end
	return 0
end

--检测主城是否还可以建造 返回值 1代表已无可升级建筑 0代表还有建筑可以升级或者建造
_ht.checkBuilding = function(self)
	--建造标记
	local buildlist = self.data.upgrade
	local upgradeState = self.data.upgradeState
	local unitList = self.data.unitList
	--检测建筑当前的状态 如果还未建造则返回0 
	for i =1,#upgradeState do
		for k,v in pairs(buildlist) do
			if i == v.indexOfCreate then
				if upgradeState[i] == 0 then
					return 0
				end
			end
		end
	end
	
	--如果建筑都已建造完毕 则判断是否有可以升级的内容 返回0 则代表还有升级内容
	for i =1,#unitList do
		for k,v in pairs(buildlist) do
			if i == v.indexOfCreate then
				local upgradelist = v.upgradelist
				if upgradelist[2] ~= nil and upgradelist[2] ~= 0 then
					return 0
				end
			end
		end
	end
	
	return 1
end

--消耗掉主城本周全部的可雇佣资源 修改此接口                                                                                   
_ht.gethirelist = function(self)
	local tD = self.data.townData
	local us = self.data.upgradeState
	local unitB = self:getunit()
	
	local returnList = {}
	for i = 1,#tD do
		local hL = tD[i].hireList
		if type(hL) == "table" then
			if us[tD[i].indexOfCreate] == 1 then
				--多单位雇佣
				if #hL > 1 then
					--雇佣个数大于0
					if hL[1][2] > 0 then
						for j = 1,#hL do
							returnList[#returnList+1] = {hL[j][1],hL[j][2]}
						end
					end
				--单单位雇佣
				else
					--雇佣个数大于0
					if hL[1][2] > 0 then
						returnList[#returnList+1] = {hL[1][1],hL[1][2]}
					end
				end
			end
		end
	end
	return returnList
end

--按照英雄无敌的要求，此接口变为返回 可雇佣，以雇佣，将来可雇佣的单位列表
_ht.gethirelistEx = function(self)
	local tD = self.data.townData
	local returnList = {}
	for i = 1,#tD do
		local hL = tD[i].hireList
		local id = tD[i].id
		local upgreadlist = hVar.tab_unit[id].upgrade
		--当前城内建筑的雇佣列表
		if type(hL) == "table" then
			if #hL > 1 then
				for j = 1,#hL do
					returnList[#returnList+1] = {hL[j][1],hL[j][2]}
				end
			else
				returnList[#returnList+1] = {hL[1][1],hL[1][2]}
			end

			
		end
		--将来可以升级的建筑的雇佣列表
		if type(upgreadlist) == "table" and hVar.tab_unit[upgreadlist[2]] then
			local uphirelist = hVar.tab_unit[upgreadlist[2]].hireList
			for j = 1,#uphirelist do
				returnList[#returnList+1] = {uphirelist[j][1],-1}
			end
		end
	end

	return returnList
end

--设置翰林院随机生成的技能表，只可增加..
_ht.setAcademySkill = function(self)
	--翰林院技能表
	local skilllist = {}
	local index = 1
	for i = 1,#hVar.ACADEMYSKILL do
		skilllist = hVar.ACADEMYSKILL[i]
		if skilllist and #skilllist>0 then
			index = hApi.random(1,#skilllist)
		end
		self.data.academyskill[#self.data.academyskill+1] = {skilllist[index]}
	end
end