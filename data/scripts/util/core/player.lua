-----------------------------------
--@ by EFF 2012/12/25
--@游戏中的玩家类
--@玩家等同于游戏中的阵营
--@玩家包含了operator
hClass.player = eClass:new("sync")
hClass.player:sync("local",{"localdata","localoperate","heros"}) --设置这些表项下面的数据为本地数据，无需保存
--hClass.player:sync("simple",{"ownTown","resource"})		--简单保存

local _hp = hClass.player
_hp.__static = {}
hGlobal.player = {}
--初始化
local __DefaultParam = {
	name = "noname",	--玩家姓名
	playerId = -1,		--玩家id
	dbid = -1,		--玩家dbid
	rid = -1,		--玩家rid
	utype = 0,		--默认类型 0空 1玩家 2简单电脑 3普通电脑 4高级电脑
	force = -1,		--势力
	pos = -1,		--位置信息
	
	allys = 0,
	ownTown = 0,
	IsLocalPlayer = 0,
	IsAIPlayer = 0,
	reviveCount = 0,	--当前游戏局中的复活次数
	hirecount = 0,		--当前剩余的雇佣次数
	hirelist = 0,		--当前的雇佣列表{0,5,id,id,id,id,id}
	detercount = 0,		--威吓次数(野外生物逃散)
	deterlevel = 0,		--威吓等级(野外生物逃散)
	
	mainbasePosX = -1,	--主基地x坐标
	mainbasePosY = -1,	--主基地y坐标
	mainbaseFacing = -1,	--主基地战车面向角度
	
	godUnit = 0,		--玩家所属上帝角色
	userdata = {length = 10,},		--用户自定义数据
	offline = true,		--玩家是否在线
	diablodata = 0, --大菠萝数据
	weapondata = 0, --玩家武器数据
	
}
_hp.init = function(self,p)
	self.data = hApi.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	local d = self.data
	d.reviveCount = 0
	
	d.mainbasePosX = -1 --主基地x坐标
	d.mainbasePosY = -1 --主基地y坐标
	d.mainbaseFacing = -1 --主基地战车面向角度
	
	self.localdata = {
		focusWorld = {},	--已废弃
		focusUnitT = {},
		operate = {n=0},
		LastOperateUnique = 0,
	}
	self.localoperate = {}
	self:cleardata()
	self:setlocalplayer(0)
	--hGlobal.player[d.playerId] = self
end

_hp.cleardata = function(self)
	local d = self.data
	self.heros = {}
	self.localdata = {
		focusWorld = {},	--已废弃
		focusUnitT = {},
		operate = {n=0},
		LastOperateUnique = 0,
	}
	d.resource = {}
	--资源
	for k,v in pairs(hVar.RESOURCE_TYPE)do
		d.resource[v] = 0
	end
	d.allys = {}
	d.ownTown = {}
	--玩家当局游戏启动的战术技能
	d.tactics = {}
	--获得过多少金
	d.getgold = 0
	
	--获得过多少经验值
	d.getexp = 0
	
	--清空复活次数
	d.reviveCount = 0
	d.hirecount = 0
	d.hirelist = 0
	d.detercount = 0
	d.deterlevel = 0
	
	--清空上帝角色
	d.godUnit = 0
	d.diablodata = 0 --大菠萝数据
	
	self:initweapon()
	
	--清空用户自定义数据
	d.userdata = {length = 10,}
	
	--清空相关数据
	d.expAdd = 0		--经验值额外增加
	d.scoreAdd = 0		--积分额外增加
	d.goldPerWaveAdd = {}	--每回合金币额外增加
end

_hp.destroy = function(self)
	local d = self.data
	local h = self.handle
	
	self:cleardata()
end

--大菠萝
--数据初始化
_hp.initweapon = function(self)
	local d = self.data
	local h = self.handle
	
	d.weapondata = {} --玩家武器数据
	d.weapondata.manaMax_Basic = 200
	d.weapondata.manaMax_Add = 0
	d.weapondata.mana = 200
	d.weapondata.weapons = {11005, 0,}
	d.weapondata.noticeWeaponId = 0
end

--大菠萝
--添加武器
_hp.addweapon = function(self, oItem)
	local d = self.data
	local h = self.handle
	
	local typeId = oItem.data.id
	--local tabU = hVar.tab_unit[typeId] or {}
	--local fromItemId = tabU.fromItemId
	local fromItemId = oItem:getitemid()
	
	--存在掉落的道具
	if fromItemId and (fromItemId ~= 0) then
		--玩家武器数据
		local oWorld = hGlobal.WORLD.LastWorldMap
		local oUnit = oWorld:GetPlayerMe().heros[1]:getunit()
		
		--我方英雄活着
		if oUnit and (oUnit ~= 0) and (oUnit.data.IsDead ~= 1) then
			local weapondata = d.weapondata
			local weapons = weapondata.weapons
			
			--不与已有的武器道具重复
			for i = 1, #weapons, 1 do
				if (weapons[i] == fromItemId) then
					return
				end
			end
			
			--找到位置为0的
			local ppos = 0
			for i = 1, #weapons, 1 do
				if (weapons[i] == 0) then
					ppos = i --找到了
					break
				end
			end
			
			--有空位
			if (ppos > 0) then
				--往后挪
				for i = #weapons - 1, 1, -1 do
					weapons[i + 1] = weapons[i]
				end
				
				--填充首项
				weapons[1] = fromItemId
			else
				--最末尾的武器扔地上
				local lastItemId = weapons[#weapons]
				local lastTypeId = hVar.tab_item[lastItemId].dropUnit
				
				--往后挪
				for i = #weapons - 1, 1, -1 do
					weapons[i + 1] = weapons[i]
				end
				
				--填充首项
				weapons[1] = fromItemId
				
				--地上添加新道具
				local deadUnitX, deadUnitY = hApi.chaGetPos(oUnit.handle) --死亡的单位的坐标
				--local gridX, gridY = oWorld:xy2grid(deadUnitX, deadUnitY)
				local gridX, gridY = deadUnitX, deadUnitY
				
				local radius = 120
				
				--local r = oWorld:random(90, radius) --随机偏移半径
				local r = radius
				local face = 0
				
				while true do
					face = oWorld:random(0, 360)
					local fangle = face * math.pi / 180 --弧度制
					fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
					local dx = r * math.cos(fangle) --随机偏移值x
					local dy = r * math.sin(fangle) --随机偏移值y
					dx = math.floor(dx * 100) / 100  --保留2位有效数字，用于同步
					dy = math.floor(dy * 100) / 100  --保留2位有效数字，用于同步
					
					gridX = gridX + dx --随机x位置
					gridY = gridY + dy --随机y位置
					
					local result = xlScene_IsGridBlock(g_world, gridX / 24, gridY / 24) --某个坐标是否是障碍
					if (result == 1) or (hApi.IsPosInWater(gridX, gridY) == 1) then --寻路失败，或者在水里
						--
					else
						break
					end
				end
				
				local oKillerPos = 1
				
				--print("oWorld:dropunit:",lastItemId,oKillerPos,face,gridX,gridY)
				local ou = oWorld:addunit(lastTypeId, oKillerPos,nil,nil,face,gridX,gridY,nil,nil)
				ou:setitemid(lastItemId)
				--local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(1.0, 1.1), CCScaleTo:create(1.0, 1.0))
				--ou.handle._n:runAction(CCRepeatForever:create(towAction))
				--print(ou, ou.data.name)
				
				--设置生存时间
				local livetime = hVar.tab_item[lastItemId].dropUnitLivetime
				if livetime and (livetime > 0) then
					ou:setLiveTime(livetime)
				end
			end
			
			--拾取道具
			hVar.CmdMgr[hVar.Operation.PickUpItem](oWorld.data.sessionId, oUnit:getowner(), oUnit:getworldI(), oUnit:getworldC(), oItem:getworldI(), oItem:getworldC())
			
			--隐藏拾取武器提示
			self:noticeweapon(nil)
			
			--更新武器界面
			self:__updateweapon()
			
			return 1
		end
	end
end

--大菠萝
--切换武器
_hp.switchweapon = function(self)
	local d = self.data
	local h = self.handle
	
	--玩家武器数据
	local oWorld = hGlobal.WORLD.LastWorldMap
	local oUnit = oWorld:GetPlayerMe().heros[1]:getunit()
	
	--我方英雄活着
	if oUnit and (oUnit ~= 0) and (oUnit.data.IsDead ~= 1) then
		local weapondata = d.weapondata
		local weapons = weapondata.weapons
		
		--找到位置为0的
		local ppos = #weapons + 1
		for i = 1, #weapons, 1 do
			if (weapons[i] == 0) then
				ppos = i --找到了
				break
			end
		end
		
		
		--只有1把武器，不用切换
		if (ppos <= 2) then
			--print("只有1把武器，不用切换")
			return
		end
		
		local fromItemId = weapons[1]
		local newItemId = weapons[2]
		table.remove(weapons, 1)
		table.insert(weapons, ppos - 1, fromItemId)
		
		--装备新武器
		local tabI = hVar.tab_item[newItemId]
		local unitX, unitY = hApi.chaGetPos(oUnit.handle)
		local gridX, gridY = oWorld:xy2grid(unitX, unitY)
		local tCastParam =
		{
			level = 1, --技能的等级
		}
		hApi.CastSkill(oUnit, tabI.passiveSkill, 0, nil, nil, gridX, gridY, tCastParam)
		
		--更新武器界面
		self:__updateweapon()
	end
end

--大菠萝
--更新武器界面
_hp.__updateweapon = function(self)
	local d = self.data
	local h = self.handle
	
	--玩家武器数据
	local weapondata = d.weapondata
	local weapons = weapondata.weapons
	
	--绘制武器图标
	local _frm = hGlobal.UI.TDSystemMenuBar
	local _parent = _frm.handle._n
	for i = 1, #weapons, 1 do
		local node = _frm.childUI["Diablo_Weapon_SkillBtn" .. i]
		if node then
			local itemId = weapons[i]
			if (itemId > 0) then
				--显示技能图标
				node.childUI["icon"].handle._n:setVisible(true)
				
				--更改图标
				local tabI = hVar.tab_item[itemId]
				local icon = tabI.icon
				local mana = tabI.mana
				node.childUI["icon"]:setmodel(icon)
				
				--更新在使用的武器的魔法值
				if (i == 1) then
					node.childUI["manaCostLabel"]:setText(mana)
				end
			else
				--隐藏技能图标
				node.childUI["icon"].handle._n:setVisible(false)
			end
		end
	end
end

--大菠萝
--提示拾取武器
_hp.noticeweapon = function(self, oItem)
	local d = self.data
	local h = self.handle
	
	--隐藏提示
	if (oItem == nil) then
		local weapondata = d.weapondata
		local noticeWeaponId = weapondata.noticeWeaponId
		if (noticeWeaponId ~= 0) then
			local _frm = hGlobal.UI.TDSystemMenuBar
			local node = _frm.childUI["Diablo_Weapon_SkillBtnHint"]
			if node then
				--隐藏提示技能图标
				node:setstate(-1)
				--print("node 隐藏提示技能图标")
			end
			
			--标记
			weapondata.noticeWeaponId = 0
			
			--更新数据
			node.data.oItem = nil --待拾取的道具
			node.data.oItem_worldC = 0 --待拾取的道具的唯一id
		end
		
		return
	end
	
	local typeId = oItem.data.id
	--local tabU = hVar.tab_unit[typeId] or {}
	--local fromItemId = tabU.fromItemId
	local fromItemId = oItem:getitemid()
	
	--存在掉落的道具
	if fromItemId and (fromItemId ~= 0) then
		--玩家武器数据
		local weapondata = d.weapondata
		local weapons = weapondata.weapons
		local noticeWeaponId = weapondata.noticeWeaponId
		
		--不与上次提示的重复
		if (fromItemId == noticeWeaponId) then
			--print("不与上次提示的重复")
			return
		end
		
		--不与已有的武器道具重复
		for i = 1, #weapons, 1 do
			if (weapons[i] == fromItemId) then
				--print("不与已有的武器道具重复")
				return
			end
		end
		
		--提示界面
		local _frm = hGlobal.UI.TDSystemMenuBar
		local _parent = _frm.handle._n
		local node = _frm.childUI["Diablo_Weapon_SkillBtnHint"]
		if node then
			--显示提示技能图标
			node:setstate(1)
			--print("node 显示提示技能图标")
			
			--更改图标
			local tabI = hVar.tab_item[fromItemId]
			local icon = tabI.icon
			local mana = tabI.mana
			node.childUI["icon"]:setmodel(icon)
			
			--更新魔法值
			node.childUI["manaCostLabel"]:setText(mana)
			
			--更新数据
			node.data.oItem = oItem --待拾取的道具
			node.data.oItem_worldC = oItem:getworldC() --待拾取的道具的唯一id
		end
		
		--标记
		weapondata.noticeWeaponId = fromItemId
	end
end

--大菠萝
--获得当前的武器道具id
_hp.getweaponitem = function(self)
	local d = self.data
	local h = self.handle
	
	--玩家武器数据
	local weapondata = d.weapondata
	local weapons = weapondata.weapons
	
	return weapons[1]
end

--大菠萝
--设置当前的武器道具id
_hp.setweaponitem = function(self, weaponItemId)
	local d = self.data
	local h = self.handle
	
	--玩家武器数据
	local weapondata = d.weapondata
	local weapons = weapondata.weapons
	
	weapons[1] = weaponItemId
	
	local oWorld = hGlobal.WORLD.LastWorldMap
	local oUnit = oWorld:GetPlayerMe().heros[1]:getunit()
	
	--我方英雄活着
	if oUnit and (oUnit ~= 0) and (oUnit.data.IsDead ~= 1) then
		--装备新武器
		local tabI = hVar.tab_item[weaponItemId]
		local unitX, unitY = hApi.chaGetPos(oUnit.handle)
		local gridX, gridY = oWorld:xy2grid(unitX, unitY)
		local tCastParam =
		{
			level = 1, --技能的等级
		}
		hApi.CastSkill(oUnit, tabI.passiveSkill, 0, nil, nil, gridX, gridY, tCastParam)
	end
	
	--更新武器界面
	self:__updateweapon()
end

--大菠萝
--获得魔法最大值
_hp.getmanamax = function(self)
	local d = self.data
	local h = self.handle
	
	--玩家武器数据
	local weapondata = d.weapondata
	local weapons = weapondata.weapons
	local manaMax_Basic = d.weapondata.manaMax_Basic
	local manaMax_Add = d.weapondata.manaMax_Add
	
	return (manaMax_Basic + manaMax_Add)
end

--大菠萝
--获得魔法值
_hp.getmana = function(self)
	local d = self.data
	local h = self.handle
	
	--玩家武器数据
	local weapondata = d.weapondata
	local weapons = weapondata.weapons
	
	return weapondata.mana
end

--大菠萝
--更新魔法值
_hp.setmana = function(self, mana)
	local d = self.data
	local h = self.handle
	
	--玩家武器数据
	local weapondata = d.weapondata
	local weapons = weapondata.weapons
	local manaMax_Basic = d.weapondata.manaMax_Basic
	local manaMax_Add = d.weapondata.manaMax_Add
	
	--最小值
	if (mana < 0) then
		mana = 0
	end
	
	--最大值
	if (mana > (manaMax_Basic + manaMax_Add)) then
		mana = manaMax_Basic + manaMax_Add
	end
	
	weapondata.mana = mana
	
	--更新控件
	local _frm = hGlobal.UI.TDSystemMenuBar
	local _parent = _frm.handle._n
	local progress = _frm.childUI["Diablo_Weapon_Progress"] --大菠萝的魔法进度条
	local progress_num = _frm.childUI["Diablo_Weapon_Progress_Num"] --大菠萝的魔法进度文字
	
	if progress then
		progress:setV(mana, manaMax_Basic + manaMax_Add)
	end
	if progress_num then
		progress_num:setText(mana .. "/" .. (manaMax_Basic + manaMax_Add))
	end
end

--战术技能卡自动释放技能（改变单位属性等操作，单位学习被动技能等）
local __tacticsTakeEffect_CastSkill = function(w, player, tId, lv, oUnit)

	local tabT = hVar.tab_tactics[tId]
	
	--local mapInfo = w.data.tdMapInfo
	--if not mapInfo then
	--	return
	--end
	--local caster = mapInfo.godUnit
	--if not caster then
	--	return
	--end
	
	--参数判定合法性判定
	if (not w) or (not tabT) or (not oUnit) or (not player) then
		return
	end
	
	--施法者为玩家对应的上帝角色
	local caster
	caster = player:getgod()
	--print("caster=", caster)
	if not caster or caster == 0 then
		return
	end
	--战术技能卡全局被动技能
	if tabT.skillId and tabT.skillId > 0 then
		local tabS = hVar.tab_skill[tabT.skillId]
		if tabS and tabS.cast_type == hVar.CAST_TYPE.AUTO then
			local world = hGlobal.WORLD.LastWorldMap
			local tCastParam = {level = lv,}
			hApi.CastSkill(caster, tabT.skillId, -1, nil, oUnit, nil, nil, tCastParam)
		end
	end
end

local __tacticsRemoveEffect_CastSkill = function(w, player, tId, lv, oUnit)
	local tabT = hVar.tab_tactics[tId]

	--参数判定合法性判定
	if (not w) or (not tabT) or (not oUnit) or (not player) then
		return
	end
	
	--施法者为玩家对应的上帝角色
	local caster
	caster = player:getgod()
	
	if not caster or caster == 0 then
		return
	end
	--战术技能卡全局被动技能
	if tabT.removeskillId and tabT.removeskillId > 0 then
		local tabS = hVar.tab_skill[tabT.removeskillId]
		if tabS and tabS.cast_type == hVar.CAST_TYPE.AUTO then
			local world = hGlobal.WORLD.LastWorldMap
			local tCastParam = {level = lv,}
			hApi.CastSkill(caster, tabT.removeskillId, -1, nil, oUnit, nil, nil, tCastParam)
		end
	end
end

--战术技能卡建造消耗影响值
local __tacticsTakeEffect_RemouldCost = function(w, player, tId, lv, oUnit)

	local tabT = hVar.tab_tactics[tId]
	
	--local mapInfo = w.data.tdMapInfo
	--if not mapInfo then
	--	return
	--end

	--参数判定合法性判定
	if (not w) or (not tabT) or (not oUnit) or (not player) then
		return
	end

	--属方判定，只影响自己或者本势力方的角色(关于同一势力方的单位被重复添加效果的情况，由外层是否重复释放逻辑来处理)
	local owner = oUnit:getowner()
	if player == owner or player == w:GetForce(owner:getforce()) or player == w:GetPlayerGod() then
		--战术技能卡建造消耗影响值
		if tabT.remouldCost then
			
			local baseTowerList = tabT.remouldCost.baseTowerId
			if type(baseTowerList) == "number" then
				baseTowerList = {baseTowerList}
			end
			for n = 1, #baseTowerList do
				local baseTowerId = baseTowerList[n]
				local targetIdList = tabT.remouldCost.targetId
				--塔基、塔基数据、目标列表存在（合法），并且当前角色是塔基
				if baseTowerId and hVar.tab_unit[baseTowerId] and targetIdList and type(targetIdList) == "table" and #targetIdList > 0 and baseTowerId == oUnit.data.id then
					--如果塔基含有建造列表
					if oUnit.td_upgrade and type(oUnit.td_upgrade) == "table" and oUnit.td_upgrade.remould then
						--遍历目标列表
						for i = 1, #targetIdList do
							local targetId = targetIdList[i]
							--遍历角色的建造列表
							--for j = 1, #d.td_upgrade.remould do
							for remouldInfoId, remouldInfo in pairs(oUnit.td_upgrade.remould) do
								--local remouldInfo = d.td_upgrade.remould[j]
								--如果建造列表中存在目标
								if remouldInfoId == targetId then
									local costAddTab = tabT.remouldCost[lv] or {}
									
									--计算消耗的增加值
									local costAdd = costAddTab.value or 0
									local costAddPer = costAddTab.per or 0
									--直接数值
									remouldInfo.costAdd = (remouldInfo.costAdd or 0) + costAdd
									--百分比值
									remouldInfo.costAdd = (remouldInfo.costAdd or 0) + hApi.getint(remouldInfo.cost * (costAddPer / 100))
									
								end
							end
						end
					end
				end
			end
		end
	end
end

--战术技能卡建造解锁
local __tacticsTakeEffect_RemouldUnlock = function(w, player, tId, lv, oUnit)
	
	local tabT = hVar.tab_tactics[tId]
	
	--print("-----------------------------------------------------------------------  __tacticsTakeEffect_RemouldUnlock", w, player, tabT, lv, oUnit.data.name)
	--local mapInfo = w.data.tdMapInfo
	--if not mapInfo then
	--	return
	--end
	
	--参数判定合法性判定
	if (not w) or (not tabT) or (not oUnit) or (not player) then
		return
	end
	
	--属方判定，只影响自己或者本势力方的角色(关于同一势力方的单位被重复添加效果的情况，由外层是否重复释放逻辑来处理)
	local owner = oUnit:getowner()
	--print("-----------------------------------------------------------------------", oUnit.data.name, owner:getpos())
	if (player == owner or player == w:GetForce(owner:getforce()) or player == w:GetPlayerGod()) and player:getgod() ~= oUnit then
		if tabT.remouldUnlock then
			local baseTowerList = tabT.remouldUnlock.baseTowerId
			if type(baseTowerList) == "number" then
				baseTowerList = {baseTowerList}
			end
			
			for n = 1, #baseTowerList do
				local baseTowerId = baseTowerList[n]
				local unlockIdList = tabT.remouldUnlock[lv] or {}
				
				--如果塔基合法，并且当前单位为塔基
				if baseTowerId and hVar.tab_unit[baseTowerId] and baseTowerId == oUnit.data.id then
					--如果塔基含有建造列表
					if oUnit.td_upgrade and type(oUnit.td_upgrade) == "table" and oUnit.td_upgrade.remould then
						--遍历战术技能卡中的解锁列表
						
						--遍历建造列表
						--for j = 1, #d.td_upgrade.remould do
						for remouldInfoId, remouldInfo in pairs(oUnit.td_upgrade.remould) do
							for i = 1, #unlockIdList do
								local unlockId = unlockIdList[i]
								local unlockCondition = remouldInfo.unlockCondition
								--local remouldInfo = d.td_upgrade.remould[j]
								--如果建造列表中存在目标则解锁
								if remouldInfoId == unlockId or (unlockCondition and unlockCondition[1] == tId) then
									remouldInfo.isUnlock = true
									if (unlockCondition and unlockCondition[1] == tId) then
										oUnit.td_upgrade.remould[remouldInfoId].unlockCondition[3] = unlockIdList
										--print("oUnit.td_upgrade.remould:",remouldInfoId,unlockIdList)
									end
									break
								end
							end
						end
					end
				end
			end
		end
	elseif player:getgod() == oUnit then
		local godU = oUnit
		
		if tabT.remouldUnlock then
			local baseTowerList = tabT.remouldUnlock.baseTowerId
			if type(baseTowerList) == "number" then
				baseTowerList = {baseTowerList}
			end
			
			for n = 1, #baseTowerList do
				local baseTowerId = baseTowerList[n]
				local unlockIdList = tabT.remouldUnlock[lv] or {}

				local godInit = false
				--如果不存在则初始化
				if not godU.td_upgrade[baseTowerId] then
					godU.td_upgrade[baseTowerId] = {}
					local tabU = hVar.tab_unit[baseTowerId]
					hApi.ReadParamWithDepth(tabU.td_upgrade,nil,godU.td_upgrade[baseTowerId],4)
				end
				
				--遍历战术技能卡中的解锁列表
				
				--遍历建造列表
				for remouldInfoId, remouldInfo in pairs(godU.td_upgrade[baseTowerId].remould) do
					for i = 1, #unlockIdList do
						local unlockId = unlockIdList[i]
						local unlockCondition = remouldInfo.unlockCondition
						--local remouldInfo = d.td_upgrade.remould[j]
						--如果建造列表中存在目标则解锁
						if remouldInfoId == unlockId or (unlockCondition and unlockCondition[1] == tId) then
							remouldInfo.isUnlock = true
							break
						end
					end
				end
				
			end
			
		end
	end
end

--战术技能卡升级解锁新技能
local __tacticsTakeEffect_UpgradeSkillUnlock = function(w, player, tId, lv, oUnit)
	
	local tabT = hVar.tab_tactics[tId]
	
	--local mapInfo = w.data.tdMapInfo
	--if not mapInfo then
	--	return
	--end
	
	--参数判定合法性判定
	if (not w) or (not tabT) or (not oUnit) or (not player) then
		return
	end
	
	--属方判定，只影响自己或者本势力方的角色(关于同一势力方的单位被重复添加效果的情况，由外层是否重复释放逻辑来处理)
	local owner = oUnit:getowner()
	if player == owner or player == w:GetForce(owner:getforce()) or player == w:GetPlayerGod() then
		if tabT.upgradeSkillUnlock then
			local targetIdList = tabT.upgradeSkillUnlock.targetId
			local unlockSkillIdList = tabT.upgradeSkillUnlock.unlockSkillId
			--如果目标列表、解锁技能列表合法
			if targetIdList and unlockSkillIdList and type(targetIdList) == "table" and type(unlockSkillIdList) == "table" and #targetIdList > 0 and #unlockSkillIdList > 0 then
				--如果塔基含有升级列表
				if oUnit.td_upgrade and type(oUnit.td_upgrade) == "table" and oUnit.td_upgrade.upgradeSkill then
					--遍历所有目标列表，检测当前角色是否属于目标列表
					for i = 1, #targetIdList do
						local targetId = targetIdList[i]
						if targetId and hVar.tab_unit[targetId] and targetId == oUnit.data.id then
							--遍历解锁技能列表
							for j = 1, #unlockSkillIdList do
								local unlockSkillId = unlockSkillIdList[j]
								--遍历升级列表中的所有技能
								--for k = 1, #d.td_upgrade.upgradeSkill do
								for upgradeSkillInfoId, upgradeSkillInfo in pairs(oUnit.td_upgrade.upgradeSkill) do
									--local upgradeSkillInfo = d.td_upgrade.upgradeSkill[k]
									if upgradeSkillInfoId == unlockSkillId then
										upgradeSkillInfo.isUnlock = true
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

--战术技能卡可交互单位点击释放技能解锁
local __tacticsTakeEffect_CastSkillUnlock = function(w, player, tId, lv, oUnit, oTactic)
	
	local tabT = hVar.tab_tactics[tId]
	
	--local mapInfo = w.data.tdMapInfo
	--if not mapInfo then
	--	return
	--end
	
	--参数判定合法性判定
	if (not w) or (not tabT) or (not oUnit) or (not player) then
		return
	end
	
	--属方判定，只影响自己或者本势力方的角色(关于同一势力方的单位被重复添加效果的情况，由外层是否重复释放逻辑来处理)
	local owner = oUnit:getowner()
	--if player == owner or player == w:GetForce(owner:getforce()) or player == w:GetPlayerGod() then
	if (player == owner or player == w:GetForce(owner:getforce()) or player == w:GetPlayerGod()) and player:getgod() ~= oUnit then
		if tabT.castSkillUnlock then
			local targetIdList = tabT.castSkillUnlock.targetId
			local unlockSkillIdList = tabT.castSkillUnlock.unlockSkillId
			--如果目标列表、解锁技能列表合法
			if targetIdList and unlockSkillIdList and type(targetIdList) == "table" and type(unlockSkillIdList) == "table" and #targetIdList > 0 and #unlockSkillIdList > 0 then
				--如果塔基含有升级列表
				if oUnit.td_upgrade and type(oUnit.td_upgrade) == "table" and oUnit.td_upgrade.castSkill then
					--遍历所有目标列表，检测当前角色是否属于目标列表
					for i = 1, #targetIdList do
						local targetId = targetIdList[i]
						if targetId and hVar.tab_unit[targetId] and targetId == oUnit.data.id then
							--遍历解锁技能列表
							for j = 1, #unlockSkillIdList do
								local unlockSkillId = unlockSkillIdList[j]
								--遍历升级列表中的所有技能
								--for k = 1, #d.td_upgrade.castSkill do
								for castSkillInfoId, castSkillInfo in pairs(oUnit.td_upgrade.castSkill) do
									--local castSkillInfo = d.td_upgrade.castSkill[k]
									if castSkillInfoId == unlockSkillId then
										castSkillInfo.isUnlock = true
										
										--geyachao: 附加兵种减cd，减金钱
										if oTactic then
											local addonesIdx, attr1, attr2, attr3 = oTactic[4], oTactic[5], oTactic[6], oTactic[7]
											local tTacticAttrAdd = {}
											tTacticAttrAdd[#tTacticAttrAdd+1] = attr1
											tTacticAttrAdd[#tTacticAttrAdd+1] = attr2
											tTacticAttrAdd[#tTacticAttrAdd+1] = attr3
											
											--该单位附加兵种卡属性
											for k = 1, #tTacticAttrAdd, 1 do
												local strAttr = tTacticAttrAdd[k] --属性字符串
												if (type(strAttr) == "string") and hVar.ITEM_ATTR_VAL[strAttr] then
													local attrVal = hVar.ITEM_ATTR_VAL[strAttr] --兵种卡的属性表
													local attrAdd = attrVal.attrAdd --属性类型
													local num = attrVal.value1 --属性值1
													local value2 = attrVal.value2 --属性值2
													--print("塔基附加属性:", oUnit.data.name, tabT.name, attrAdd, num)
													
													if (attrAdd == "hp_max_rate") then --血量+5％
														--
													elseif (attrAdd == "atk_rate") then --攻击+5％
														--
													elseif (attrAdd == "atk_radius") then --射程+50
														--
													elseif (attrAdd == "army_damage") then --伤害+5％
														--
													elseif (attrAdd == "def_physic") then --物防+5
														--
													elseif (attrAdd == "def_magic") then --法防+5
														--
													elseif (attrAdd == "dodge_rate") then --闪避+5％
														--
													elseif (attrAdd == "crit_rate") then --暴率+5％
														--
													elseif (attrAdd == "crit_value") then --暴倍+0.5
														--
													elseif (attrAdd == "hp_restore") then --回血+5
														--
													elseif (attrAdd == "atk_speed") then --攻速+5％
														--
													elseif (attrAdd == "move_speed") then --移速+5％
														--
													elseif (attrAdd == "suck_blood_rate") then --吸血+5％
														--
													elseif (attrAdd == "live_time") then --存活+5％
														--
													elseif (attrAdd == "army_discount") then --价格-5％
														castSkillInfo.costAdd = castSkillInfo.costAdd or 0
														local value = math.floor(castSkillInfo.cost * num / 100)
														castSkillInfo.costAdd = castSkillInfo.costAdd + value
														--print("减cost")
													elseif (attrAdd == "army_cooldown") then --冷却-1秒
														castSkillInfo.cdAdd = castSkillInfo.cdAdd or 0
														castSkillInfo.cdAdd = castSkillInfo.cdAdd + num * 1000
														
														local skillObj = oUnit:getskill(castSkillInfoId)
														if skillObj then
															skillObj[5] = castSkillInfo.cd + castSkillInfo.cdAdd
															--print("减cd")
														end
													elseif (attrAdd == "skill_cooldown") then --技能冷却-1秒
														castSkillInfo.cdAdd = castSkillInfo.cdAdd or 0
														castSkillInfo.cdAdd = castSkillInfo.cdAdd + num * 1000
														
														local skillObj = oUnit:getskill(castSkillInfoId)
														if skillObj then
															skillObj[5] = castSkillInfo.cd + castSkillInfo.cdAdd
															--print("技能减cd")
														end
													elseif (attrAdd == "skill_damage") then --技能伤害+5％
														--
													elseif (attrAdd == "skill_range") then --技能范围+5％
														--
													elseif (attrAdd == "skill_chaos") then --技能混乱+1秒
														--
													elseif (attrAdd == "skill_num") then --技能数量+5％
														--
													elseif (attrAdd == "skill_poison") then --技能中毒+1层
														--
													elseif (attrAdd == "skill_lasttime") then --技能持续时间+1秒
														--
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	elseif player:getgod() == oUnit then
		local godU = oUnit
		
		if tabT.castSkillUnlock then
			local targetIdList = tabT.castSkillUnlock.targetId
			if type(targetIdList) == "number" then
				targetIdList = {targetIdList}
			end
			
			for n = 1, #targetIdList do
				local targetId = targetIdList[n]
				local unlockSkillIdList = tabT.castSkillUnlock.unlockSkillId
				
				local godInit = false
				--如果不存在则初始化
				if not godU.td_upgrade[targetId] then
					godU.td_upgrade[targetId] = {}
					local tabU = hVar.tab_unit[targetId]
					hApi.ReadParamWithDepth(tabU.td_upgrade,nil,godU.td_upgrade[targetId],4)
				end
				
				--遍历战术技能卡中的解锁列表
				for i = 1, #unlockSkillIdList do
					local unlockSkillId = unlockSkillIdList[i]
					--遍历建造列表
					for castSkillInfoId, castSkillInfo in pairs(godU.td_upgrade[targetId].castSkill) do
						--local remouldInfo = d.td_upgrade.remould[j]
						--如果建造列表中存在目标则解锁
						if castSkillInfoId == unlockSkillId then
							castSkillInfo.isUnlock = true
							--...
						end
					end
				end
			end
		end
	end
end

--战术技能卡升级消耗影响值
local __tacticsTakeEffect_UpgradeSkillCost = function(w, player, tId, lv, oUnit)
	
	local tabT = hVar.tab_tactics[tId]
	
	--local mapInfo = w.data.tdMapInfo
	--if not mapInfo then
	--	return
	--end
	
	--参数判定合法性判定
	if (not w) or (not tabT) or (not oUnit) or (not player) then
		return
	end
	
	--属方判定，只影响自己或者本势力方的角色(关于同一势力方的单位被重复添加效果的情况，由外层是否重复释放逻辑来处理)
	local owner = oUnit:getowner()
	if player == owner or player == w:GetForce(owner:getforce()) or player == w:GetPlayerGod() then
		if tabT.upgradeSkillCost then
			local targetIdList = tabT.upgradeSkillCost.targetId
			--塔基、塔基数据、目标列表存在（合法），并且当前角色是塔基
			if targetIdList and type(targetIdList) == "table" and #targetIdList > 0 then
				--遍历所有角色，如果当前角色是其中之一，则处理
				for i = 1, #targetIdList do
					if targetIdList[i] == oUnit.data.id then
						--如果当前单位含有升级列表
						if oUnit.td_upgrade and type(oUnit.td_upgrade) == "table" and oUnit.td_upgrade.upgradeSkill then
							--遍历升级列表中所有升级项，进行cost计算
							--for j = 1, #d.td_upgrade.upgradeSkill do
							for upgradeSkillId, upgradeSkillInfo in pairs (oUnit.td_upgrade.upgradeSkill) do
								--local upgradeSkillInfo = d.td_upgrade.upgradeSkill[j]
								local costAddTab = tabT.upgradeSkillCost[lv] or {}
								
								--计算消耗的增加值
								local costAdd = costAddTab.value or 0
								local costAddPer = costAddTab.per or 0
								if not upgradeSkillInfo.costAdd or type(upgradeSkillInfo.costAdd) ~= "table" then
									upgradeSkillInfo.costAdd = {}
								end
								for k = 1, #upgradeSkillInfo.cost do
									upgradeSkillInfo.costAdd[k] = upgradeSkillInfo.costAdd[k] or 0 
									--直接数值
									upgradeSkillInfo.costAdd[k] = (upgradeSkillInfo.costAdd[k] or 0) + costAdd
									--百分比值
									upgradeSkillInfo.costAdd[k] = (upgradeSkillInfo.costAdd[k] or 0) + hApi.getint(upgradeSkillInfo.cost[k] * (costAddPer / 100))
								end
							end
						end
					end
				end
			end
		end
	end
end

--战术技能卡每波金钱影响值
local __tacticsTakeEffect_GoldPerWave = function(w, player, tId, lv)
	
	local tabT = hVar.tab_tactics[tId]
	
	local mapInfo = w.data.tdMapInfo
	if not mapInfo then
		return
	end
	
	--参数判定合法性判定
	if (not w) or (not tabT) or (not player) then
		return
	end

	--普通玩家才生效
	if player:getpos() >= 1 and player:getpos() <= 20 then
		if tabT.goldPerWave then
			--计算每回合直接增加金币的值
			local goldAdd = 0
			if tabT.goldPerWave.value then
				goldAdd = tabT.goldPerWave.value[lv] or 0
			end
			
			----计算每回合百分比增加金币的值
			--for w = 1, #mapInfo.goldPerWave do
			--	mapInfo.goldPerWaveAdd[w] = mapInfo.goldPerWaveAdd[w] + goldAdd
			--
			--	local goldPerWave = mapInfo.goldPerWave[w] or 0
			--	if tabT.goldPerWave.per then
			--		mapInfo.goldPerWaveAdd[w] = mapInfo.goldPerWaveAdd[w] + hApi.getint(goldPerWave * ((tabT.goldPerWave.per[lv] or 0) / 100))
			--	end
			--end
			
			local allInfo = player:getAllGoldPerWaveAdd()
			if allInfo and type(allInfo) == "table" then
				for w = 1, #allInfo do
					player:addGoldPerWaveAdd(w, goldAdd)

					local goldPerWave = mapInfo.goldPerWave[w] or 0
					if tabT.goldPerWave.per then
						local goldAddPer = hApi.getint(goldPerWave * ((tabT.goldPerWave.per[lv] or 0) / 100))
						--print("1:",goldAddPer)
						player:addGoldPerWaveAdd(w, goldAddPer)
					end
				end
			end
		end

	elseif player:getpos() == 0 then
		if tabT.goldPerWave then
			--计算每回合直接增加金币的值
			local goldAdd = 0
			if tabT.goldPerWave.value then
				goldAdd = tabT.goldPerWave.value[lv] or 0
			end
			
			for i = 1, 24 do
				local p = w:GetPlayer(i)
				if p then
					local allInfo = p:getAllGoldPerWaveAdd()
					if allInfo and type(allInfo) == "table" then
						for w = 1, #allInfo do
							p:addGoldPerWaveAdd(w, goldAdd)

							local goldPerWave = mapInfo.goldPerWave[w] or 0
							if tabT.goldPerWave.per then
								local goldAddPer = hApi.getint(goldPerWave * ((tabT.goldPerWave.per[lv] or 0) / 100))
								--print("2:",i,w,goldAddPer)
								p:addGoldPerWaveAdd(w, goldAddPer)
							end
						end
					end
				end
			end
		end
	end
end

--每局额外经验
local __tacticsTakeEffect_ExpAdd = function(w, player, tId, lv)
	
	local tabT = hVar.tab_tactics[tId]
	
	local mapInfo = w.data.tdMapInfo
	if not mapInfo then
		return
	end
	
	--参数判定合法性判定
	if (not w) or (not tabT) or (not player) then
		return
	end
	--普通玩家才生效
	if player:getpos() >= 1 and player:getpos() <= 20 then
		if tabT.expAdd then
			--计算每回合直接增加经验的值
			local expAdd = 0
			if tabT.expAdd.value then
				expAdd = tabT.expAdd.value[lv] or 0
			end
			--mapInfo.expAdd = mapInfo.expAdd + expAdd
			
			----计算每回合百分比增加经验的值
			--local expNow = mapInfo.exp or 0
			--if tabT.expAdd.per then
			--	mapInfo.expAdd = mapInfo.expAdd + hApi.getint(expNow * ((tabT.expAdd.per[lv] or 0) / 100))
			--end

			player:addExpAdd(expAdd)
			local expNow = mapInfo.exp or 0
			if tabT.expAdd.per then
				expAdd = hApi.getint(expNow * ((tabT.expAdd.per[lv] or 0) / 100))
				player:addExpAdd(expAdd)
			end
		end
	end
end

--每局额外积分
local __tacticsTakeEffect_ScoreAdd = function(w, player, tId, lv)
	
	local tabT = hVar.tab_tactics[tId]
	
	local mapInfo = w.data.tdMapInfo
	if not mapInfo then
		return
	end
	
	--参数判定合法性判定
	if (not w) or (not tabT) or (not player) then
		return
	end
	--普通玩家才生效
	if player:getpos() >= 1 and player:getpos() <= 20 then
		if tabT.scoreAdd then
			--计算每回合直接增加经验的值
			local scoreAdd = 0
			if tabT.scoreAdd.value then
				scoreAdd = tabT.scoreAdd.value[lv] or 0
			end
			--mapInfo.expAdd = mapInfo.expAdd + expAdd
			
			----计算每回合百分比增加经验的值
			--local expNow = mapInfo.exp or 0
			--if tabT.expAdd.per then
			--	mapInfo.expAdd = mapInfo.expAdd + hApi.getint(expNow * ((tabT.expAdd.per[lv] or 0) / 100))
			--end

			player:addScoreAdd(scoreAdd)
			local scoreNow = mapInfo.scoreV or 0
			if tabT.scoreAdd.per then
				scoreAdd = hApi.getint(scoreNow * ((tabT.scoreAdd.per[lv] or 0) / 100))
				player:addScoreAdd(scoreAdd)
			end
		end
	end
end

--单个战术卡的技能生效
local __tacticsTakeEffect_single = function(w, player, oUnit, id, lv, oTactic)
	--作用于角色的战术技能卡，角色出生时生效一次
	local mapInfo = w.data.tdMapInfo
	if oUnit then
		--战术技能卡全局被动技能
		__tacticsTakeEffect_CastSkill(w, player, id, lv, oUnit)
		
		--local tabU = oUnit:gettab()
		--如果当前类型是塔建筑则进行一下处理
		--if tabU.isTower and tabU.isTower == 1 then
		if (oUnit.data.type == hVar.UNIT_TYPE.TOWER) or (oUnit.data.type == hVar.UNIT_TYPE.NPC_TALK) or (oUnit.data.type == hVar.UNIT_TYPE.BUILDING) or (oUnit.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE) or (oUnit.data.type == hVar.UNIT_TYPE.HERO_STATION) or (oUnit.data.type == hVar.UNIT_TYPE.STATION) then --geyachao: 已修改塔类型的读取方式
			
			--战术技能卡建造消耗影响值
			__tacticsTakeEffect_RemouldCost(w, player, id, lv, oUnit)
			
			--战术技能卡建造解锁
			__tacticsTakeEffect_RemouldUnlock(w, player, id, lv, oUnit)
			
			--战术技能卡升级解锁新技能
			__tacticsTakeEffect_UpgradeSkillUnlock(w, player, id, lv, oUnit)
			
			--战术技能卡可交互单位点击释放技能解锁
			__tacticsTakeEffect_CastSkillUnlock(w, player, id, lv, oUnit, oTactic)
			
			--战术技能卡升级消耗影响值
			__tacticsTakeEffect_UpgradeSkillCost(w, player, id, lv, oUnit)
		else
			--如果角色是本方的上帝角色，则给上帝角色初始化
			if oUnit == player:getgod() and mapInfo.buildTogether then
				--战术技能卡建造解锁
				__tacticsTakeEffect_RemouldUnlock(w, player, id, lv, oUnit)
				
				--战术技能卡可交互单位点击释放技能解锁
				__tacticsTakeEffect_CastSkillUnlock(w, player, id, lv, oUnit, oTactic)
			end
		end
		
	else
		--战术技能卡资源生效(只能生效一次，生效多次就嗝屁了)
		--每波金钱
		__tacticsTakeEffect_GoldPerWave(w, player, id, lv)
		
		--每局额外经验
		__tacticsTakeEffect_ExpAdd(w, player, id, lv)
		
		--每局额外积分
		__tacticsTakeEffect_ScoreAdd(w, player, id, lv)
	end
end

--zhenkira 修改td资源类的战术技能卡生效(战术技能卡生效的单位)
--战术技能卡生效处理(参数：世界|生效的单位)
_hp.tacticsTakeEffect = function(self, w, oUnit, checkRepeat)
	local mapInfo = w.data.tdMapInfo
	if not mapInfo then
		return
	end
	
	--获取本局激活的战术技能卡
	local tTactics = self:gettactics()
	if tTactics==nil then
		return
	end
	
	local force = self:getforce()
	
	--遍历战术技能卡执行生效流程
	for n = 1, #tTactics, 1 do
		if tTactics[n]~=0 then
			local id, lv = tTactics[n][1],tTactics[n][2]
			local tabT = hVar.tab_tactics[id]
			
			--这里做个筛选，填了activeSkill视为主动释放类的战术技能，这里不做处理
			if tabT and (not tabT.activeSkill) then
				
				--如果不重复,则执行
				--xlLG("pvp_server22222", "----------------------------w:checkTacticsRepeat(force, self, id)" .. tostring(force) .. ", " .. tostring(self) .. ", " .. tostring(id) .. ", " .. tostring(w:checkTacticsRepeat(force, self, id)) .. "\n")
				
				if (not checkRepeat) or (checkRepeat and not w:checkTacticsRepeat(force, self, id)) then
					--依次处理单个战术卡生效
					__tacticsTakeEffect_single(w, self, oUnit, id, lv, tTactics[n])
				end
				
			end
		end
	end
end

--单个战术技能卡生效处理
--(注意: 此接口仅用于单机地图地上捡到战术卡时调用，其他地方禁止调用)
_hp.tacticsTakeEffect_single = function(self, id, lv)
	local w = self:getfocusworld()
	
	--出错处理
	if (w == nil) then
		return
	end
	
	local oTactic = {id, lv,}
	
	--单个战术技能卡资源生效
	__tacticsTakeEffect_single(w, self, nil, id, lv, oTactic)
	
	--单个战术技能卡对地图已有角色生效
	w:enumunit(function(u)
		__tacticsTakeEffect_single(w, self, u, id, lv, oTactic)
	end)
end

_hp.tacticsRemoveEffect = function(self,w,oUnit,tacticsId,lv)
	local mapInfo = w.data.tdMapInfo
	if not mapInfo then
		return
	end

	--删除战术技能卡全局被动技能
	__tacticsRemoveEffect_CastSkill(w, self, tacticsId, lv, oUnit)
end

--获得玩家的战术技能
_hp.gettactics = function(self)
	--local tTacticsLv = {}
	----所有玩家都读取通用战术技能
	--local tTac = self.data.tactics
	--if tTac and #tTac>0 then
	--	for i = 1,#tTac do
	--		if type(tTac[i])=="table" then
	--			local id,lv = tTac[i][1],tTac[i][2]
	--			tTacticsLv[id] = math.max(tTacticsLv[id] or 0,lv)
	--		end
	--	end
	--end
	----本地玩家从表格中读取激活的战术技能
	--if self==hGlobal.LocalPlayer then
	--	local tTac = LuaGetActiveBattlefieldSkill()
	--	if tTac and #tTac>0 then
	--		for i = 1,#tTac do
	--			if type(tTac[i])=="table" then
	--				local id,lv = tTac[i][1],tTac[i][2]
	--				tTacticsLv[id] = math.max(tTacticsLv[id] or 0,lv)
	--			end
	--		end
	--	end
	--end
	local d = self.data
	return d.tactics
end

--清除玩家的战术技能
_hp.cleartactics = function(self)
	local d = self.data
	d.tactics = {}
end

_hp.settactics = function(self, tTactics)
	local d = self.data
	if (type(tTactics)=="table") then
		if d.tactics==0 then
			d.tactics = {}
		end
		local num = 1
		for i = #d.tactics + 1, hVar.PLAYER_ACTIVED_BFSKILL_NUM do
			if type(tTactics[num])=="table" then
				local id, lv, typeId, addonesIdx, attr1, attr2, attr3 = tTactics[num][1], tTactics[num][2], tTactics[num][3], tTactics[num][4], tTactics[num][5], tTactics[num][6], tTactics[num][7]
				--print("hp.settactics", id, lv, typeId, addonesIdx, attr1, attr2, attr3)
				d.tactics[i] = {id, lv, typeId, addonesIdx, attr1, attr2, attr3}
			else
				--d.tactics[i] = 0
				--print("_hp.settactics:",self:getpos(), "0")
			end
			num = num + 1
		end
	end
end

_hp.removetactics = function(self, tTactics)
	local d = self.data
	if (type(tTactics)=="table" and type(d.tactics)=="table") then
		local list = {}
		for i = 1,#d.tactics do
			local id,lv = d.tactics[i][1],d.tactics[i][2]
			if tTactics[id] and tTactics[id] == lv then
				list[#list+1] = i
			end
		end
		for i = #list,1,-1 do
			table.remove(d.tactics,list[i])
		end
	end
end

----------------------------------------------
--重新读取后，初始化数据
_hp.__InitAfterLoaded = function(self)
	local d = self.data
	self.localdata = {
		focusWorld = {},	--已废弃
		focusUnitT = {},
		operate = {n=0},
		LastOperateUnique = 0,
	}
	--做版本兼容，陶晶的坑
	d.hirecount = d.hirecount or 0
	--版本兼容
	d.tactics = d.tactics or {}
	d.detercount = d.detercount or 0
	d.deterlevel = d.deterlevel or 0
	d.hirelist = d.hirelist or 0
	--hGlobal.player[d.playerId] = self
	--if d.playerId==0 then
	--	hGlobal.NeutralPlayer = self
	--	d.IsAIPlayer = 0
	--end
	--if d.IsLocalPlayer==1 then
	--	hGlobal.LocalPlayer = self
	--	d.IsAIPlayer = 0
	--	self:setlocalplayer(1)
	--else
	--	self:setlocalplayer(0)
	--end
end
----------------------------------------------

_hp.showlootart = function(self,oTarget,resourceType,resourceValue)
	if oTarget~=nil and oTarget:isInScreen() then
		local art = hVar.RESOURCE_ART[resourceType] or hVar.RESOURCE_ART[hVar.RESOURCE_TYPE.NONE]
		hUI.floatNumber:new({
			unit = oTarget,
			font = art.font,
			size = 14,
			text = "+"..resourceValue,
			lifetime = 1500,
			fadeout = -250,
			y = 32,
			moveY = 4,
			jumpH = 10,
			icon = art.icon,
			iconScale = 0.4,
		})
	end
end

------------------
--玩家获得资源
_hp.addresource = function(self,resourceType,resourceValue,getMode,fromUnit,byUnit)
	--if getMode==hVar.RESOURCE_GET_TYPE.LOOT then
	--	if byUnit~=nil and self==hGlobal.LocalPlayer then
	--		self:showlootart(fromUnit,resourceType,resourceValue)
	--	end
	--end

	local w = hGlobal.WORLD.LastWorldMap
	local maxValue
	if w and w.data.tdMapInfo then
		maxValue = w.data.tdMapInfo.maxGold
	end

	if resourceType==nil or self.data.resource[resourceType]==nil then
		_DEBUG_MSG("[LOGIC ERR]添加未知的资源类型给玩家！")
		return
	end
	if resourceType==hVar.RESOURCE_TYPE.GOLD then
		self.data.resource[resourceType] = math.min(math.min(9999999,maxValue or 9999999),self.data.resource[resourceType] + resourceValue)
		if resourceValue > 0 then
			--self.data.getgold = (self.data.getgold or 0) + resourceValue
			self.data.getgold = math.min(math.min(9999999,maxValue or 9999999),self.data.resource[resourceType] + resourceValue)
		end
	elseif resourceType==hVar.RESOURCE_TYPE.EXP then
		--最大500
		self.data.resource[resourceType] = math.min(hVar.SettlementExp,self.data.resource[resourceType] + resourceValue)
	else
		self.data.resource[resourceType] = math.min(math.min(9999999,maxValue or 9999999),self.data.resource[resourceType] + resourceValue)
	end
	
	--geyachao: 资源不小于0
	if (self.data.resource[resourceType] < 0) then
		self.data.resource[resourceType] = 0
	end
	
	--显示部分
	if hGlobal.LocalRecource and hGlobal.LocalResourceIndex then
		local me = hGlobal.LocalPlayer
		if w and w:GetPlayerMe() then
			me = w:GetPlayerMe()
		end
		if self==me then 
			local index = hGlobal.LocalResourceIndex[resourceType]
			if index then
				hGlobal.LocalRecource[index] = self.data.resource[resourceType]
			end
		end
	end
end

--获取玩家当前资源
_hp.getresource = function(self,resourceType)
	if resourceType==nil or self.data.resource[resourceType]==nil then
		_DEBUG_MSG("[LOGIC ERR]获取玩家未知类型的资源！")
		return 0
	end
	return self.data.resource[resourceType]
end

--玩家所有英雄经验值增加（heroId如果为0标示所有英雄都加经验，否则给特定英雄加经验）
_hp.addHeroPvpExp = function(self, heroId, exp)
	for i = 1, #self.heros do
		local oHero = self.heros[i]
		if oHero and oHero.addpvpexp then
			local id = oHero.data.id --单位类型id
			if (heroId == 0) or (id == heroId and heroId > 0) then
				oHero:addpvpexp(exp)
			end
		end
	end
end

--获取当局玩家经验值额外增加值
_hp.getExpAdd = function(self)
	return self.data.expAdd or 0
end

-- 设置当局玩家经验值额外增加值
_hp.setExpAdd = function(self, expAdd)
	self.data.expAdd  = expAdd or 0
end

-- 增加当局玩家经验值额外增加值
_hp.addExpAdd = function(self, expAdd)
	self.data.expAdd  = math.max((self.data.expAdd + expAdd), 0)
end

--获取当局玩家积分额外增加值
_hp.getScoreAdd = function(self)
	return self.data.scoreAdd or 0
end

--设置当局玩家积分额外增加值
_hp.setScoreAdd = function(self, scoreAdd)
	self.data.scoreAdd  = scoreAdd or 0
end

--增加当局玩家积分额外增加值
_hp.addScoreAdd = function(self, scoreAdd)
	self.data.scoreAdd  = math.max((self.data.scoreAdd + scoreAdd), 0)
end

--获取当局玩家所有回合金币额外增加值
_hp.getAllGoldPerWaveAdd = function(self)
	local d = self.data
	return d.goldPerWaveAdd
end

--获取当局玩家每回合金币额外增加值
_hp.getGoldPerWaveAdd = function(self, wave)
	local d = self.data
	return d.goldPerWaveAdd[wave] or 0
end

--设置当局玩家每回合金币额外增加值
_hp.setGoldPerWaveAdd = function(self, wave, goldAdd)
	local d = self.data
	if d.goldPerWaveAdd and d.goldPerWaveAdd[wave] then
		d.goldPerWaveAdd[wave] = goldAdd
	end
end

--增加当局玩家每回合金币额外增加值
_hp.addGoldPerWaveAdd = function(self, wave, goldAdd)
	local d = self.data
	if d.goldPerWaveAdd and d.goldPerWaveAdd[wave] then
		--d.goldPerWaveAdd[wave] = math.max((d.goldPerWaveAdd[wave] + goldAdd), 0)
		d.goldPerWaveAdd[wave] = d.goldPerWaveAdd[wave] + goldAdd
	end
end

--初始化当局玩家每回合金币额外增加值
_hp.initGoldPerWaveAdd = function(self, totalwave)
	local d = self.data
	for i = 1, totalwave do
		d.goldPerWaveAdd[#d.goldPerWaveAdd + 1] = 0
	end
end

local __SetFocusWorld = function(self,oObject,IsEvent,IsSwitchScene,IsMoveCamera)
	--print("__SetFocusWorld__SetFocusWorld__SetFocusWorld__SetFocusWorld__SetFocusWorld")
	if self~=hGlobal.LocalPlayer then
		return
	end
	if oObject~=nil and oObject~=0 and oObject.ID~=0 then
		if oObject.classname=="world" then
			local oWorld = oObject
			local oWorld_old = hApi.GetObjectII(hClass.world,hGlobal.LastFocusWorld)
			if oWorld_old==oWorld and hGlobal.LastFocusSwitch==1 then
				return
			end
			hGlobal.LastFocusSwitch = 1
			hApi.SetObjectII(hGlobal.LastFocusMap,nil)
			hApi.SetObjectII(hGlobal.LastFocusWorld,oWorld)
			if IsSwitchScene==1 then
				hApi.EnableWorldLayer(oWorld.handle,1)
			end
			if IsMoveCamera==1 then
				hApi.SetCameraRect(-100,-100,oWorld.data.sizeW+200,oWorld.data.sizeH+200,1)
			end
			if IsEvent==1 then
				--print("LocalEvent_PlayerFocusWorld", "world", "IsEvent", IsEvent, "oWorld=", oWorld)
				hGlobal.event:call("LocalEvent_PlayerFocusWorld",oWorld.data.scenetype,oWorld,nil)
			end
		elseif oObject.classname=="map" then
			local oMap = oObject
			local oMap_old = hApi.GetObjectII(hClass.map,hGlobal.LastFocusMap)
			if oMap_old==oMap and hGlobal.LastFocusSwitch==2 then
				return
			end
			hGlobal.LastFocusSwitch = 2
			hApi.SetObjectII(hGlobal.LastFocusMap,oMap)
			hApi.SetObjectII(hGlobal.LastFocusWorld,nil)
			if IsSwitchScene==1 then
				hApi.EnableWorldLayer(oMap.handle,1)
			end
			if IsMoveCamera==1 then
				hApi.SetCameraRect(-100,-100,oMap.data.sizeW+200,oMap.data.sizeH+200,1)
			end
			if IsEvent==1 then
				--print("LocalEvent_PlayerFocusWorld", "map", "IsEvent", IsEvent)
				hGlobal.event:call("LocalEvent_PlayerFocusWorld",oMap.data.scenetype,nil,oMap)
			end
		else
			hGlobal.LastFocusSwitch = 0
			_DEBUG_MSG("[LUA WARNING]focusworld:聚焦到未知的场景！")
		end
	else
		hGlobal.LastFocusSwitch = 0
		local oWorld_old = hApi.GetObjectII(hClass.world,hGlobal.LastFocusWorld)
		local oMap_old = hApi.GetObjectII(hClass.map,hGlobal.LastFocusMap)
		hApi.SetObjectII(hGlobal.LastFocusMap,nil)
		hApi.SetObjectII(hGlobal.LastFocusWorld,nil)
		if IsEvent==1 and (oWorld_old~=nil or oMap_old~=nil) then
			hGlobal.event:call("LocalEvent_PlayerFocusWorld","none",nil,nil)
		end
	end
end

------------------------------------
--@设置当前聚焦的世界
_hp.focusworld = function(self,oWorld)
	--本地玩家才有这个设置
	return __SetFocusWorld(self,oWorld,1,1,1)
end

-------------------------------------
--@在程序的switch_scene回调中使用此接口
_hp.setfocusworld = function(self,oWorld,IsEvent,IsSwitchScene,IsMoveCamera)
	return __SetFocusWorld(self,oWorld,IsEvent,IsSwitchScene,IsMoveCamera)
end

_hp.getfocusworld = function(self)
	if hGlobal.LastFocusSwitch==1 then
		return hApi.GetObjectII(hClass.world,hGlobal.LastFocusWorld)
	end
end

_hp.getfocusmap = function(self)
	if hGlobal.LastFocusSwitch==2 then
		return hApi.GetObjectII(hClass.map,hGlobal.LastFocusMap)
	end
end

--获取player所属势力
_hp.getforce = function(self)
	return self.data.force
end

--获取player所在位置
_hp.getpos = function(self)
	return self.data.pos
end

--获取player类型
_hp.gettype = function(self)
	return self.data.utype
end

--设置玩家在线
_hp.setonline = function(self)
	self.data.offline = false
end
--设置玩家离线
_hp.setoffline = function(self)
	self.data.offline = true
end

--获取玩家是否在线
_hp.getonline = function(self)
	return (not self.data.offline)
end

--获取玩家是否离线
_hp.getoffline = function(self)
	return self.data.offline
end

--设置结盟(暂时废弃)
_hp.setally = function(self,oPlayer)
	if oPlayer then
		self.data.allys[oPlayer.data.playerId] = 1
		oPlayer.data.allys[self.data.playerId] = 1
	end
end

--设置敌对(暂时废弃)
_hp.setenemy = function(self,oPlayer)
	if oPlayer then
		self.data.allys[oPlayer.data.playerId] = 0
		oPlayer.data.allys[self.data.playerId] = 0
	end
end

--获取结盟关系(暂时废弃)
_hp.allience = function(self,oPlayer)
	if oPlayer then
		if oPlayer==self then
			return hVar.PLAYER_ALLIENCE_TYPE.OWNER
		--elseif oPlayer==hGlobal.player[0] then
		--	return hVar.PLAYER_ALLIENCE_TYPE.NEUTRAL
		elseif self.data.allys[oPlayer.data.playerId]==1 then
			return hVar.PLAYER_ALLIENCE_TYPE.ALLY
		else
			return hVar.PLAYER_ALLIENCE_TYPE.ENEMY
		end
	else
		return hVar.PLAYER_ALLIENCE_TYPE.NONE
	end
end

--获得上帝角色
_hp.getgod = function(self)
	local d = self.data
	if d.godUnit == 0 then
		return
	end
	return d.godUnit
end

--设置上帝角色
_hp.setgod = function(self, u)
	if type(u) == "table" then
		self.data.godUnit = u
	end
end

--获得用户自定义数据
_hp.getuserdata = function(self, idx)
	local d = self.data
	local ud = d.userdata
	
	return ud[idx]
end

--设置用户自定义数据
_hp.setuserdata = function(self, idx, value)
	local d = self.data
	local ud = d.userdata
	
	ud[idx] = value
end

--获得用户自定义数据的总长度
_hp.getuserdatalength = function(self)
	local d = self.data
	local ud = d.userdata
	
	return ud.length
end

------------------------------------
--@设置当前聚焦的单位
_hp.focusunit = function(self,oUnit,key)
	--print("focusunit", oUnit and oUnit.data.name)
	local localdata = self.localdata
	local focusT = self.localdata.focusUnitT
	local oWorld
	if key==nil then
		oWorld = self:getfocusworld()
		if oWorld~=nil then
			key = oWorld.data.type
		else
			key = 1
		end
	end
	--如果是被隐藏的单位 则直接返回
	if oUnit and oUnit~=0 then
		if oUnit.data.IsHide == 1 then
			return hVar.RESULT_FAIL
		end
	end
	
	if oUnit and oUnit~=0 then
		--print("asdfasfda set:", key,tostring(focusT),tostring(self.data.pos))
		if focusT[key]==nil then
			focusT[key] = {}
		end
		local v = focusT[key]
		local oUnitOld = hApi.GetObject(v)
		if oUnitOld~=oUnit then
			hApi.SetObject(v,oUnit)
			if oWorld==nil then
				--oWorld = self:getfocusworld()
				oWorld = oUnit:getworld()
			end
			--if self==hGlobal.LocalPlayer then
			if oWorld and self==oWorld:GetPlayerMe() then
				self.localoperate:clear()
				
				if oWorld.data.type=="worldmap" then
					--zhenkira: 点击不需要重新获取路径
					--if oUnitOld~=nil then
						--hApi.chaShowPath(oUnitOld.handle,0)
					--end
					if oUnit:operatable(self)==hVar.RESULT_SUCESS then
						--zhenkira: 点击不需要重新获取路径或者绑定镜头
						--hApi.chaShowPath(oUnit.handle,1)
						--hApi.chaSetCameraFollow(oUnit.handle)
						hGlobal.event:event("LocalEvent_PlayerSelectHero",self,oUnit,oUnitOld,oWorld)
					end
				elseif oWorld.data.type=="battlefield" then
					hGlobal.event:event("LocalEvent_PlayerSelectUnit",self,newUnit,oUnitOld,oWorld)
				end
			end
			return hVar.RESULT_SUCESS
		end
	else
		local v = focusT[key]
		--print("asdfasfda:",v, key, tostring(focusT),tostring(self.data.pos))
		if v~=nil then
			local oldUnit = hApi.GetObject(v)
			hApi.SetObject(v,nil)
			if oWorld==nil then
				oWorld = self:getfocusworld()
			end
			--if self==hGlobal.LocalPlayer and oldUnit~=nil then
			
			if oWorld and self==oWorld:GetPlayerMe() and oldUnit~=nil then
				self.localoperate:clear()
				
				
				if oWorld.data.type=="worldmap" then
					--zhenkira: 点击不需要重新获取路径或者绑定镜头
					--if oUnitOld~=nil then
						--hApi.chaShowPath(oUnitOld.handle,0)
					--end
					--hApi.chaSetCameraFollow(nil)
				--elseif oWorld.data.type=="battlefield" then
					hGlobal.event:event("LocalEvent_PlayerCancelSelectUnit",self,oldUnit,oWorld)
					--print("取消选中", oldUnit.data.name)
				end
			end
			return hVar.RESULT_SUCESS
		end
	end
	return hVar.RESULT_FAIL
end

_hp.getfocusunit = function(self,key)
	local focusT = self.localdata.focusUnitT
	if key==nil then
		local oWorld = self:getfocusworld()
		if oWorld~=nil then
			key = oWorld.data.type
		else
			key = 1
		end
	end
	local v = focusT[key]
	if v~=nil then
		return hApi.GetObject(v)
	end
end

--设置当前玩家使用的英雄
_hp.createhero = function(self, id, tHero)
	local d = self.data
	if d.pos > 0 then
		--英雄创建的时候就已经绑定玩家了
		local oHero = hClass.hero:new(
		{
			name = hVar.tab_stringU[id][1],
			id = id,
			owner = d.pos,
			HeroCard = tHero,
		})
		
		--与玩家绑定
		self.heros[#self.heros+1] = oHero
		oHero.data.LocalIndex = #self.heros
		
		hGlobal.event:call("Event_HeroCreated",oHero,0)
		
		return oHero
	end
end

--获得英雄对象
_hp.gethero = function(self, heroId)
	local d = self.data
	for i = 1, #self.heros do
		local hero = self.heros[i]
		if heroId > 0 and heroId == hero.data.id then
			return hero
		end
	end
end

--获得英雄对象by索引
_hp.getherobyidx = function(self, idx)
	local d = self.data
	local hero
	if self.heros and type(self.heros) == "table" then
		hero = self.heros[idx]
	end
	return hero
end

--获得所有英雄
_hp.getallhero = function(self)
	return self.heros
end

--pvp初始化，添加所有的英雄单位
_hp.addAllHeroUnit_PVP = function(self, w)
	
	local mapInfo = w.data.tdMapInfo
	local targetAngleOrigin = {0, 72, 144, 216, 288} --目标的坐标偏移角度列表（用于随机位置）
	local targetAngle = {} --目标的坐标偏移角度列表
	for i = 1, #self.heros do
		local oHero = self.heros[i]
		if oHero then
			local id = oHero.data.id --单位类型id
			if (id > 0) then
				local god = self:getgod()
				
				--添加单位
				--读取单位的等级
				local cardLv = 1 --英雄的等级
				local cardStar = 1 --英雄星级
				if oHero.attr then
					cardLv = oHero.attr.level or 1
					cardStar = oHero.attr.star or 1
				end
				
				local nStar = math.min(cardStar,hVar.HERO_STAR_INFO.maxStarLv)
				local pve_heroId = id
				if (mapInfo.pveHeroMode == 0) then
					pve_heroId = id - 100
				end
				local nLv = math.min(cardLv, hVar.HERO_STAR_INFO[pve_heroId][nStar].maxLv)
				
				--创建单位
				if (#targetAngle == 0) then --避免随不到
					for i = 1, #targetAngleOrigin, 1 do
						table.insert(targetAngle, targetAngleOrigin[i])
					end
				end
				local radius = 30
				local randAngleIdx = w:random(1, #targetAngle) --随机偏移角度索引值
				local angle = targetAngle[randAngleIdx] --随机角度
				table.remove(targetAngle, randAngleIdx)
				local fangle = angle * math.pi / 180 --弧度制
				fangle = math.floor(fangle * 100) / 100 --保留2位有效数字（用于同步）
				local dx = radius * math.cos(fangle) --随机偏移值x
				local dy = radius * math.sin(fangle) --随机偏移值y
				dx = math.floor(dx * 100) / 100  --保留2位有效数字，用于同步
				dy = math.floor(dy * 100) / 100  --保留2位有效数字，用于同步
				local randPosX, randPosY = god:getXY()
				randPosX = randPosX + dx --随机x位置
				randPosY = randPosY + dy --随机y位置
				randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 50)
				
				--god.data.facing
				local oUnit = w:addunit(id, self:getpos(), nil ,nil, angle, randPosX, randPosY, nil, nil, nLv, nStar)
				
				oHero:bind(oUnit)
				
				hGlobal.event:call("Event_UnitBorn", oUnit)
				
				--触发事件：pvp英雄升级pvp等级
				hGlobal.event:event("Event_HeroPvpLvUp", oHero, 0, 1)
			end
		end
	end
end

__BF_UnitMoveG = function(oPlayer,oWorld,oRound,oUnit,gridX,gridY,oOperatingTarget,nOperate,vOrderId)
	local IsMoveSucess = 0
	if oWorld.data.IsQuickBattlefield==1 then
		oWorld:opengate(oPlayer,1)
		if oUnit:movetogrid(gridX,gridY,oOperatingTarget,nOperate,vOrderId)==hVar.RESULT_SUCESS then
			--开门后成功移动
			IsMoveSucess = 1
		end
		oWorld:opengate(oPlayer,0)
	else
		local gTab = {}
		oWorld:opengateT(oPlayer,1,gTab)
		local wp = {n=0,e=0}
		oWorld:findunitwayto(wp,oUnit,gridX,gridY)
		oWorld:opengateT(oPlayer,0,gTab)
		if wp.e>0 then
			local moveN = 0
			local ax = oWorld:Ax()
			local ux,uy = oUnit.data.gridX,oUnit.data.gridY
			local ublock = oUnit:getblock()
			local wblock = oWorld.data.block
			oWorld:removeblockU(oUnit,ux,uy)
			for i = 1,wp.e do
				if ax:checkBlockIN(wp[i],wblock,ublock)==hVar.RESULT_SUCESS then
					moveN = wp[i]
				else
					break
				end
			end
			oWorld:addblockU(oUnit,ux,uy)
			if moveN>0 then
				local x,y = oWorld:n2grid(moveN)
				if oUnit:movetogrid(x,y,oOperatingTarget,nOperate,vOrderId)==hVar.RESULT_SUCESS then
					--先移动到门口
					IsMoveSucess = 1
					--开门
					oRound:autoorder(250,oUnit,hVar.ORDER_TYPE.SYSTEM,hVar.OPERATE_TYPE.OPEN_GATE,oPlayer)
					--继续移动到门口
					oRound:autoorder(250,oUnit,hVar.ORDER_TYPE.NORMAL,hVar.OPERATE_TYPE.UNIT_MOVE,gridX,gridY,oOperatingTarget,nOperate,vOrderId)
					--关门
					oRound:autoorder(250,oUnit,hVar.ORDER_TYPE.SYSTEM,hVar.OPERATE_TYPE.CLOSE_GATE,oPlayer)
				end
			elseif #wp>0 then
				--先移动到门口
				IsMoveSucess = 1
				oRound:autoorder(250,oUnit,hVar.ORDER_TYPE.SYSTEM,hVar.OPERATE_TYPE.OPEN_GATE,oPlayer)
				--移动
				oRound:autoorder(250,oUnit,hVar.ORDER_TYPE.NORMAL,hVar.OPERATE_TYPE.UNIT_MOVE,gridX,gridY,oOperatingTarget,nOperate,vOrderId)
				--关门
				oRound:autoorder(250,oUnit,hVar.ORDER_TYPE.SYSTEM,hVar.OPERATE_TYPE.CLOSE_GATE,oPlayer)
			end
		end
	end
	return IsMoveSucess
end

--检查是否可以操作
hApi.CheckRoundOpr = function(oRound,oPlayer)
	local tUnitData = oRound:top(1)
	if tUnitData==nil then
		_DEBUG_MSG("no unit in battlefield")
		return hVar.RESULT_FAIL
	elseif oPlayer~=hGlobal.player[oRound.data.operator] or oPlayer.localdata.LastOperateUnique~=tUnitData[hVar.ROUND_DEFINE.DATA_INDEX.nUnique] then
		_DEBUG_MSG("you are not controller")
		return hVar.RESULT_FAIL
	else
		return hVar.RESULT_SUCESS
	end
end

_hp.order = function(self,oWorld,nOrder,oOrderUnit,vOrderId,oOrderTarget,gridX,gridY,worldX,worldY)
	if g_editor ~= 1 then
		local b_prepared = g_WDLD_Attr
		if b_prepared == -1 and hApi.Is_WDLD_Map(hGlobal.WORLD.LastWorldMap.data.map) ~= -1 and WdldRoleId == luaGetplayerDataID() then 
			return hVar.RESULT_FAIL
		end
	end
	if oWorld.ID==0 then
		_DEBUG_MSG("world["..oWorld.data.type.."]is deleted,order fail:",nOrder,vOrderId)
		return hVar.RESULT_FAIL
	elseif oWorld.data.IsPaused==1 then
		_DEBUG_MSG("world["..oWorld.data.type.."]is paused,order fail:",nOrder,vOrderId)
		return hVar.RESULT_FAIL
	end
	--战场
	if oWorld.data.type=="battlefield" then
		if nOrder==hVar.OPERATE_TYPE.PLAYER_ROUND_READY then
			--准备就绪命令
		elseif nOrder==hVar.OPERATE_TYPE.PLACE_TO then
			--放置单位命令
		else
			--一般命令
			if oWorld.data.unitcountM>0 then
				_DEBUG_MSG("some unit still in move,order fail:")
				return hVar.RESULT_FAIL
			end
			if oWorld.data.actioncount>0 then
				_DEBUG_MSG("some skill still in process,order fail:")
				return hVar.RESULT_FAIL
			end
			local oRound = oWorld:getround()
			if oRound==nil then
				_DEBUG_MSG("round is null,order fail:")
				return hVar.RESULT_FAIL
			end
			if oRound.data.auto==1 then
				_DEBUG_MSG("world["..oWorld.data.type.."]in auto process,order fail:",nOrder,vOrderId)
				return hVar.RESULT_FAIL
			end
			if hApi.CheckRoundOpr(oRound,self)~=hVar.RESULT_SUCESS then
				_DEBUG_MSG("world["..oWorld.data.type.."]control is illegal,order fail:",nOrder,vOrderId)
				return hVar.RESULT_FAIL
			end
			--对于死亡的单位，强行将命令转换为跳过回合命令
			if type(oOrderUnit)=="table" and oOrderUnit.data.IsDead==1 then
				nOrder = hVar.OPERATE_TYPE.PLAYER_SKIP_UNIT_OPERATE
				vOrderId = nil
				oOrderUnit = nil
				oOrderTarget = nil
			end
			if nOrder==hVar.OPERATE_TYPE.PLAYER_SKIP_UNIT_OPERATE then
				--跳过回合命令必然被接受
			elseif nOrder==hVar.OPERATE_TYPE.UNIT_WAIT then
				--等待命令，如果已经等待过，自动转换为跳过回合命令
				if (oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.nActivityEx) or 0)<=-5000 then
					nOrder = hVar.OPERATE_TYPE.PLAYER_SKIP_UNIT_OPERATE
					vOrderId = nil
					oOrderUnit = nil
					oOrderTarget = nil
				end
			elseif oOrderUnit~=nil and oOrderUnit.attr.stun>0 then
				--眩晕单位禁止接受普通命令，当发布防御命令时，自动转换为跳过回合命令
				if nOrder==hVar.OPERATE_TYPE.SKILL_IMMEDIATE and vOrderId==hVar.GUARD_SKILL_ID then
					nOrder = hVar.OPERATE_TYPE.PLAYER_SKIP_UNIT_OPERATE
					vOrderId = nil
					oOrderUnit = nil
					oOrderTarget = nil
				else
					_DEBUG_MSG("unit["..oOrderUnit.data.name.."]stuned,order fail:",nOrder,vOrderId)
					return hVar.RESULT_FAIL
				end
			end
			--如果是跳过回合命令，在这里加上特殊限制
			if nOrder==hVar.OPERATE_TYPE.PLAYER_SKIP_UNIT_OPERATE then
				vOrderId = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.nUnique) or 0
			end
		end
	end
	--发出目前命令将直接收到..(下面都是单位命令)
	--return self:operate(oWorld,nOrder,oOrderUnit,vOrderId,oOrderTarget,gridX,gridY,worldX,worldY)
	if oWorld.data.type=="battlefield" and oWorld.data.netdata~=0 then
		hApi.PVPNetCmd(self,oWorld,nOrder,oOrderUnit,vOrderId,oOrderTarget,gridX,gridY,worldX,worldY)
		return hVar.RESULT_SUCESS
	else
		return g_Game_Agent.order(self,oWorld,nOrder,oOrderUnit,vOrderId,oOrderTarget,gridX,gridY,worldX,worldY)
	end
end


local __AssistKeyOfMoveTo = {["#MOVETO"] = 1}
local __NumberCheck2 = {"number","number"}
_hp.operate = function(self,oWorld,nOperate,oOperatingUnit,vOrderId,oOperatingTarget,gridX,gridY,worldX,worldY)
	
	local d = self.data
	local w = oWorld
	local u = oOperatingUnit
	local oUnit = oOperatingUnit
	--print("点击地图",gridX,gridY,worldX,worldY)
	--单位繁忙时不接受命令
	
	if w.data.type=="worldmap" and u~=nil and u~=0 then
		if u.data.IsBusy==1 then
			_DEBUG_MSG("[LUA WARNING]hero is busy")
			hUI.floatNumber:new({
				unit = u,
				size = 12,
				text = "!!!~~",
				font = "numRed",
				lifetime = 1000,
				fadeout = -500,
				y = 40,
				moveY = 32,
			})
			return hVar.RESULT_FAIL
		end
		if nOperate<=hVar.OPERATE_TYPE.UNIT_TALK then
			--基本命令不能对隐藏单位发出
			--隐藏单位禁止发出命令
			if u.data.IsHide==1 then
				_DEBUG_MSG("[LUA WARNING]unit is hide,id:" .. u.data.id)
				return hVar.RESULT_FAIL
			end
			--隐藏单位禁止接受命令
			local t = oOperatingTarget
			if t~=nil and t~=0 and u~=t and t.data.IsHide==1 then
				_DEBUG_MSG("[LUA WARNING]target is hide,id:" .. t.data.id)
				return hVar.RESULT_FAIL
			end
		end
	end
	
	--需要unit的命令
	if u~=nil and u~=0 then
		if oOperatingTarget~=nil and type(oOperatingTarget)~="table" then
			_DEBUG_MSG("[LUA WARNING]传入非Object的Target!")
		end
		
		--英雄拾取道具事件
		--if nOperate == hVar.OPERATE_TYPE.HERO_GETITEM then
			--local oItem = oOperatingTarget:getitem()
			--local oHero = oUnit:gethero()
			--if oHero and oItem then
				--return oHero:pickitem(oOperatingTarget)
			--end
		--end
		
		--英雄扔道具事件
		if nOperate == hVar.OPERATE_TYPE.HERO_DROPITEM then
			local oHero = oUnit:gethero()
			if type(vOrderId) == "table" and oHero then
				local from = vOrderId
				--无英雄卡片的英雄，禁止丢弃道具
				if oHero.data.HeroCard~=1 then
					return hVar.RESULT_FAIL
				end
				return oHero:dropitem(from)
			end
		end

		--英雄调整背包栏的道具(包括装备/卸下装备)
		if nOperate == hVar.OPERATE_TYPE.HERO_SORTITEM then
			local oHero = oUnit:gethero()
			if type(vOrderId) == "table" and #vOrderId==4 and oHero then
				--检测道具交互合法性
				if hApi.IsSafeItemShift(oHero,vOrderId[1],vOrderId[2],vOrderId[3],vOrderId[4])~=1 then
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_RequireHeroCardEx2"],{
						font = hVar.FONTC,
						ok = function()
						end,
					})
					print("非法的英雄道具交互",vOrderId[1],vOrderId[2],vOrderId[3],vOrderId[4])
					return hVar.RESULT_FAIL
				end
				if type(vOrderId[2])=="number" then	--必须有这个判断，防止作弊
					return oHero:shiftitem(vOrderId[1],vOrderId[2],vOrderId[3],vOrderId[4])
				end
			end
		end
		
		--从道具栏中把装备拖到装备槽上
		--if nOperate == hVar.OPERATE_TYPE.HERO_SETEQUIPMENT then
			--local oHero = oUnit:gethero()
			--if type(vOrderId) == "table" and #vOrderId==3 and oHero then
				--return oHero:setequipment(vOrderId[1],vOrderId[2],vOrderId[3])
			--end
		--end
		
		--从装备槽移除某道具放到道具栏中
		--if nOperate == hVar.OPERATE_TYPE.HERO_REMOVEEQUIPMENT then
			--local oHero = oUnit:gethero()
			--if type(vOrderId) == "table" and oHero then
				--local fromIndex = vOrderId[1]
				--local topos = vOrderId[2]
				--local mode = vOrderId[3]
				--return oHero:removeequipment(fromIndex,topos,mode)
			--end
		--end

		if nOperate==hVar.OPERATE_TYPE.TEAM_SHIFT then
			--队伍调整命令
			local t = oOperatingTarget or u
			if u:operatable(self)==hVar.RESULT_SUCESS and (u==t or t:operatable(self)==hVar.RESULT_SUCESS) and hApi.CheckTable(vOrderId,__NumberCheck2)==hVar.RESULT_SUCESS then
				local tS,tT = u.data.team,t.data.team
				if u==t then
					if vOrderId[2]==-1 then
						--丢弃单位
						u:teamremoveunit(vOrderId[1])
					else
						--移动单位
						u:teamshift(vOrderId[1],vOrderId[2])
					end
					return hVar.RESULT_SUCESS
				else
					--交换单位
					local uTeamUnit,uSus = u:teamgetunit(vOrderId[1])
					local tTeamUnit,tSus = t:teamgetunit(vOrderId[2])
					if uSus==hVar.RESULT_SUCESS and tSus==hVar.RESULT_SUCESS then
						local uId,uNum
						local tId,tNum
						if uTeamUnit then
							uId,uNum = uTeamUnit[1],uTeamUnit[2]
						end
						if tTeamUnit then
							tId,tNum = tTeamUnit[1],tTeamUnit[2]
						end
						if uId~=nil then
							u:teamremoveunit(vOrderId[1])
						end
						--如果两个单位id一样，那么做合并
						if uId==tId then
							if uId~=nil then
								t:teamaddunit({{uId,uNum,vOrderId[2]}})
							end
						else
							if tId~=nil then
								t:teamremoveunit(vOrderId[2])
							end
							if tId~=nil then
								u:teamaddunit({{tId,tNum,vOrderId[1]}})
							end
							if uId~=nil then
								t:teamaddunit({{uId,uNum,vOrderId[2]}})
							end
						end
					end
					return hVar.RESULT_SUCESS
				end
			else
				_DEBUG_MSG("[LUA WARNING] 对不可操作的单位执行交换team单位操作！")
			end
			return hVar.RESULT_FAIL
		else
			--购买命令处理
			if nOperate==hVar.OPERATE_TYPE.UNIT_HIRE or nOperate==hVar.OPERATE_TYPE.UNIT_SHOP or nOperate==hVar.OPERATE_TYPE.UNIT_MARKET or nOperate == hVar.OPERATE_TYPE.UNIT_UPGRADE then
				local oTarget = oOperatingTarget
				if type(vOrderId)=="table" and(nOperate==hVar.OPERATE_TYPE.UNIT_HIRE or nOperate==hVar.OPERATE_TYPE.UNIT_SHOP) then
					--确认需要购买的物品时，这项会是一个table，描述了具体购买了哪些东西
					local oTown = oTarget:gettown()
					local indexOfTown = vOrderId[0]
					local tData
					local buyList = vOrderId
					if oTown~=nil then
						if indexOfTown and indexOfTown~=0 and oTown.data.townData[indexOfTown]~=nil then
							tData = oTown.data.townData[indexOfTown]
						else
							_DEBUG_MSG("[LUA HINT] 城镇内购买出现问题,indexOfTown="..tostring(indexOfTown))
						end
					else
						tData = oTarget.data
					end
					if tData~=nil then
						if nOperate==hVar.OPERATE_TYPE.UNIT_HIRE then
							--说明是要从商店购买单位
							if hApi.HeroHireUnit(oWorld,oUnit,oTarget,tData,buyList)==hVar.RESULT_FAIL then
								return hVar.RESULT_FAIL
							end
						elseif nOperate==hVar.OPERATE_TYPE.UNIT_SHOP then
							if hApi.HeroBuyItem(oWorld,oUnit,oTarget,tData,buyList)==hVar.RESULT_FAIL then
								return hVar.RESULT_FAIL
							end
						end
					end
				elseif w.data.type=="worldmap" then
					--世界地图上发送购买物品但是无具体购买ID，数量的命令视为发送移动命令
					local moveX,moveY = oWorld:safeGrid(gridX,gridY)
					u:movetogrid(moveX,moveY,oOperatingTarget,nOperate,vOrderId)
					return hVar.RESULT_SUCESS
				elseif w.data.type=="town" then
					--城内的升级建筑命令 陶晶 2013-4-18

					if nOperate == hVar.OPERATE_TYPE.UNIT_UPGRADE then
						return hGlobal.event:rcall("Event_BuildingUpgrade",oOperatingUnit,oWorld,oOperatingTarget,vOrderId)
					end

					--此时目标单位必须为世界地图上的建筑，且具有一个合法城镇
					local oTown = oTarget:gettown()
					--城镇中发送命令，视为打开指定town.data.townData[vOrderId]的购买列表
					if oTown and type(vOrderId)=="number" then
						local tData = oTown.data.townData[vOrderId]
						if nOperate==hVar.OPERATE_TYPE.UNIT_MARKET then
							tData = tData or oTarget.data
							--市场必然可以弹出来
							hGlobal.event:call("Event_HeroTakeShop",oWorld,u,oTarget,nOperate,tData)
						elseif tData~=nil then
							hGlobal.event:call("Event_HeroTakeShop",oWorld,u,oTarget,nOperate,tData)
						else
							_DEBUG_MSG("找不到城镇的出售表格(1)",vOrderId)
						end
					else
						_DEBUG_MSG("找不到城镇建筑的数据表格",vOrderId)
					end
				end
				return hVar.RESULT_SUCESS
			end
			
			--一般移动,技能命令处理
			if w.data.type=="worldmap" then
				--oOperatingTarget不为空的时候，一定会收到arrive回调
				if nOperate==hVar.OPERATE_TYPE.UNIT_MOVE then
					if u.data.gridX==gridX and u.data.gridY==gridY then
						hGlobal.event:call("Event_UnitNotMove",w,u,gridX,gridY)
						--移动命令阶段点到了自己
						return hVar.RESULT_FAIL
					end
				end
				if gridX~=nil and gridY~=nil and (nOperate==nil or hVar.WORLD_OPERATE_WITH_MOVE[nOperate]~=nil) then
					local ImmediateArrive = 0
					local TargetOrder = 0
					local t = oOperatingTarget
					--为打野怪做了一个优化,如果自己站在和野怪一样的位置，可以不移动立刻发出命令
					if type(t)=="table" and t.classname=="unit" then
						TargetOrder = 1
						if t.data.type==hVar.UNIT_TYPE.UNIT and t.data.gridX==u.data.gridX and t.data.gridY==u.data.gridY then
							ImmediateArrive = 1
						end
					end
					if TargetOrder==1 and ImmediateArrive==1 then
						--可以立刻到达的目标类命令
						w:unitarrive(u,gridX,gridY,t,nOperate,vOrderId)
						hGlobal.event:event("Event_UnitNotMove",w,u,gridX,gridY)
					else
						local moveX,moveY = oWorld:safeGrid(gridX,gridY)
						u:movetogrid(moveX,moveY,t,nOperate,vOrderId)
					end
				end
				return hVar.RESULT_SUCESS
			elseif w.data.type=="battlefield" then
				if nOperate==hVar.OPERATE_TYPE.PLACE_TO then
					if u.data.owner~=self.data.playerId then
						_DEBUG_MSG("[LUA WARNING] 不能放置不属于自己的单位！")
						return hVar.RESULT_FAIL
					elseif w.data.roundcount~=0 then
						_DEBUG_MSG("[LUA WARNING] 回合已经开始！不能放置单位！")
						return hVar.RESULT_FAIL
					elseif u.data.indexOfTeam==0 then
						_DEBUG_MSG("[LUA WARNING] 不能放置战场上已存在的单位！")
						return hVar.RESULT_FAIL
					else
						u:setgrid(gridX,gridY,-1)
						return hVar.RESULT_SUCESS
					end
				end
				local oRound = w:getround()
				if oRound then
					--在非自动运行状态下，仅允许执行available的命令
					if oRound.data.auto==0 then
						if nOperate==hVar.OPERATE_TYPE.UNIT_WAIT then
							--等待命令，单位将延迟到本回合的末尾行动,此命令必然被允许
							--但是只可以等待一次
							local oUnitCur = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.oUnit)
							local nActivityEx = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.nActivityEx)
							if u==oUnitCur and (nActivityEx or 0)>-5000 then
								oRound:insertunit(oUnit,w.data.roundcount,-5000,hVar.ROUND_DEFINE.ACTIVE_MODE.NONE,hVar.ROUND_DEFINE.SORT_MODE.WAIT)
								oRound:closeallorder()
								oRound:auto(oUnit,"wait")
								if self==hGlobal.LocalPlayer then
									hGlobal.event:event("LocalEvent_PlayerConfirmOperateBF",w,oUnit,hVar.WAIT_SKILL_ID,nil,0,0)
								end
								return hVar.RESULT_SUCESS
							else
								return hVar.RESULT_FAIL
							end
						else
							--会导致不同步
							local oOrder,nFind = oRound:checkorder(oOperatingUnit,nOperate,1)
							if oOrder==nil then
								print("发送了禁止接受的命令！",nOperate,vOrderId)
								return hVar.RESULT_FAIL
							end
						end
					end
					if nOperate==hVar.OPERATE_TYPE.UNIT_MOVE then
						if u.data.gridX==gridX and u.data.gridY==gridY then
							hGlobal.event:call("Event_UnitNotMove",w,u,gridX,gridY)
							--移动命令阶段点到了自己
							return hVar.RESULT_FAIL
						else
							local moveX,moveY = oWorld:safeGrid(gridX,gridY)
							local IsMoveSucess = 0
							if u:movetogrid(moveX,moveY,oOperatingTarget,nOperate,vOrderId)==hVar.RESULT_SUCESS then
								--成功进行移动
								IsMoveSucess = 1
							else
								--移动失败的话，可能是因为门没开
								--打开城门试试
								IsMoveSucess = __BF_UnitMoveG(self,oWorld,oRound,u,moveX,moveY,oOperatingTarget,nOperate,vOrderId)
							end
							if IsMoveSucess==0 then
								u:facetogrid(moveX,moveY)
							end
							if oRound.data.auto==0 then
								oRound:closeallorder()
								oRound:auto(oUnit,"move")
							end
							return hVar.RESULT_SUCESS
						end
					else
						if type(vOrderId)~="number" then
							_DEBUG_MSG("[LUA WARNING] ordierId 为非数字！")
						end
						local oUnit,oTarget = oOperatingUnit,oOperatingTarget
						if nOperate==hVar.OPERATE_TYPE.SKILL_TO_UNIT_WITH_MOVE then
							local tabS = hVar.tab_skill[vOrderId]
							if tabS then
								local cast = tabS.cast_type or hVar.CAST_TYPE.NONE
								if tabS.moveid and type(tabS.moveid)=="number" then
									--如果此技能拥有移动id，那么不论如何都会触发移动技能
									local moveX,moveY = oWorld:safeGrid(gridX,gridY)
									local moveId = tabS.moveid
									if oRound.data.auto==0 then
										oRound:closeallorder()
										local tabMS = hVar.tab_skill[moveId]
										if tabMS then
											if tabMS.cast_type==hVar.CAST_TYPE.SKILL_TO_UNIT then
												oRound:autoorder(0,oUnit,hVar.ORDER_TYPE.SYSTEM,hVar.OPERATE_TYPE.SKILL_TO_UNIT,oTarget,moveId,0,0,moveX,moveY)
											elseif tabMS.cast_type==hVar.CAST_TYPE.IMMEDIATE then
												oRound:autoorder(0,oUnit,hVar.ORDER_TYPE.SYSTEM,hVar.OPERATE_TYPE.SKILL_IMMEDIATE,moveId,moveX,moveY)
											end
										end
										if cast==hVar.CAST_TYPE.SKILL_TO_UNIT then
											oRound:autoorder(0,oUnit,hVar.ORDER_TYPE.NORMAL,hVar.OPERATE_TYPE.SKILL_TO_UNIT,oTarget,vOrderId)
										elseif cast~=nil then
											oRound:autoorder(0,oUnit,hVar.ORDER_TYPE.NORMAL,hVar.OPERATE_TYPE.SKILL_IMMEDIATE,vOrderId)
										end
										oRound:auto(oUnit)
									end
								elseif u.data.gridX==gridX and u.data.gridY==gridY then
									--如果不需要移动的话
									--hGlobal.event:call("Event_UnitNotMove",w,u,gridX,gridY)
									if cast==hVar.CAST_TYPE.SKILL_TO_UNIT then
										return hGlobal.event:rcall("Event_UnitStartCast",oWorld,0,hVar.ORDER_TYPE.NORMAL,hVar.OPERATE_TYPE.SKILL_TO_UNIT,oUnit,vOrderId,oTarget,oTarget.data.gridX,oTarget.data.gridY)
									elseif cast~=nil then
										return hGlobal.event:rcall("Event_UnitStartCast",oWorld,0,hVar.ORDER_TYPE.NORMAL,hVar.OPERATE_TYPE.SKILL_IMMEDIATE,oUnit,vOrderId,nil,gridX,gridY)
									end
								else
									--移动并且对目标使用技能
									local moveX,moveY = oWorld:safeGrid(gridX,gridY)
									local IsMoveSucess = 0
									if u:movetogrid(moveX,moveY,oOperatingTarget,nOperate,vOrderId)==hVar.RESULT_SUCESS then
										IsMoveSucess = 1
									else
										--移动失败的话，可能是因为门没开
										--打开城门试试
										IsMoveSucess = __BF_UnitMoveG(self,oWorld,oRound,u,moveX,moveY,oOperatingTarget,nOperate,vOrderId)
									end
									if IsMoveSucess==0 then
										u:facetogrid(moveX,moveY)
									end
									if oRound.data.auto==0 then
										oRound:closeallorder()
										if type(oRound.data.AssistUnit)=="table" and (oRound.data.AssistUnit.key["#MOVETO"] or 0)>0 then
											oRound:checkassist(oUnit,oTarget,__AssistKeyOfMoveTo,0)
										end
										if cast==hVar.CAST_TYPE.SKILL_TO_UNIT then
											oRound:autoorder(0,oUnit,hVar.ORDER_TYPE.NORMAL,hVar.OPERATE_TYPE.SKILL_TO_UNIT,oTarget,vOrderId)
										elseif cast~=nil then
											oRound:autoorder(0,oUnit,hVar.ORDER_TYPE.NORMAL,hVar.OPERATE_TYPE.SKILL_IMMEDIATE,vOrderId)
										end
										oRound:auto(oUnit,"move")
									end
								end
							end
							return hVar.RESULT_SUCESS
						elseif nOperate==hVar.OPERATE_TYPE.SKILL_IMMEDIATE or nOperate==hVar.OPERATE_TYPE.SKILL_TO_UNIT or nOperate==hVar.OPERATE_TYPE.SKILL_TO_GRID then
							return hGlobal.event:rcall("Event_UnitStartCast",oWorld,0,hVar.ORDER_TYPE.NORMAL,nOperate,oUnit,vOrderId,oTarget,gridX,gridY)
						else
							if oRound.data.auto==0 then
								oRound:closeallorder()
								oRound:auto(oUnit,"unknown")
							end
							if nOperate==hVar.OPERATE_TYPE.FACE_TO_GRID then
								u:setroundstate(hVar.UNIT_ROUND_STATE.ROUND_END)
								u:facetogrid(gridX,gridY)	--战场内设置朝向
								return hVar.RESULT_SUCESS
							end
						end
						return hVar.RESULT_FAIL
					end
				end
			end
		end
	end
	return hVar.RESULT_SUCESS
end
----------------------------------------------
-- 选择单位函数
--local _p = {}
--hApi.testSelectUnit = function(oWorld,gridX,gridY,worldX,worldY)
	--return oWorld:enumunit(function(u,world)
		--if u.data.gridX==gridX and u.data.gridY==gridY then
			--return u
		--end
	--end)
--end
----------------------------------------------
_hp.__static.__LocalOperateFunc = {}
local __LocalOperateFunc = hClass.player.__static.__LocalOperateFunc
_hp.__static.__LocalOperateMeta = {
	__index = function(t,k) return __LocalOperateFunc[k] end,
}
_hp.__static.__N_LocalOperateMeta = {
	__index = function() return hApi.DoNothing end,
}
local __LocalOperateMeta = hClass.player.__static.__LocalOperateMeta
local __N_LocalOperateMeta = hClass.player.__static.__N_LocalOperateMeta
_hp.setlocalplayer = function(self,IsLocalPlayer)
	local o = rawget(self,"localoperate")
	if IsLocalPlayer==0 then
		self.data.IsLocalPlayer = 0
		setmetatable(o,__N_LocalOperateMeta)
	else
		self.data.IsLocalPlayer = 1
		rawset(o,"self",self)
		setmetatable(o,__LocalOperateMeta)
		hGlobal.event:event("LocalEvent_InitLocalPlayer",self)
	end
end


local function _OprLog(key,d)
	local s = {}
	if type(d)=="table" then
		for k,v in pairs(d)do
			s[#s+1] = tostring(k).." = "..tostring(v).."\n"
		end
	end
	xlLG("opr",key..":\n"..table.concat(s))
end

__LocalOperateFunc.clear = function(_self)
	local self = rawget(_self,"self")
	local o = self.localdata.operate
	local w = self:getfocusworld()
	if w and w.data.roundcount~=0 then
		w:drawgrid("default","gray")
	end
	o.n = 0
end

__LocalOperateFunc.top = function(_self)
	local self = rawget(_self,"self")
	local o = self.localdata.operate
	return o[o.n]
end

__LocalOperateFunc.push = function(_self,operateData)
	local self = rawget(_self,"self")
	local o = self.localdata.operate
	local s = ""
	if type(operateData)=="table" then
		o.n = o.n+1
		o[o.n] = operateData
	end
	return operateData
end

----------------------
-- 本地操作
--在不同map的操作是不一样的
--_hp.localoperate = function(_self,_,oWorld,nLocalOperate,gridX,gridY,worldX,worldY)
--end
local __WorldDownTarget = nil
__LocalOperateFunc.touch = function(_self,oWorld,nLocalOperate,gridX,gridY, worldX, worldY)
	--print("LocalOperateFunc.touch", nLocalOperate, gridX,gridY, worldX, worldY)
	
	local self = rawget(_self,"self")
	local w = oWorld
	local p = self
	local localdata = p.localdata
	
	--如果游戏暂停，直接跳出
	if (oWorld.data.IsPaused == 1) then
		if (w.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
			if (hVar.OP_LASTING_MODE == 1) then --持续选中模式，可以继续
				--contiune
			else
				--contiune
			end
		else
			return
		end
	end
	
	local oPlayerMe = w:GetPlayerMe() --我的玩家对象
	local nForceMe = oPlayerMe:getforce() --我的势力
	local oNeutralPlayer = w:GetForce(nForceMe) --中立阵营玩家对象（蜀国/魏国）
	
	--本地操作，传给operate的参数会增加一个"被操作单位"
	if (w.data.type == "worldmap") then
		if (nLocalOperate == hVar.LOCAL_OPERATE_TYPE.TOUCH_DOWN) then
			--[[
			--geyachao: 如果是选中了某张战术技能卡，本次点击是用来释放战术技能卡技能的，不是选中角色
			local tacticCardCtrls = w.data.tacticCardCtrls --战术技能卡控件集
			for i = 1, #tacticCardCtrls, 1 do
				local cardi = tacticCardCtrls[i]
				if cardi and (cardi ~= 0) then
					if (cardi.data.selected == 1) then --战术技能卡是选中状态
						return
					end
				end
			end
			]]
			return hVar.RESULT_FAIL --返回成功就不能滚动屏幕了
		elseif (nLocalOperate == hVar.LOCAL_OPERATE_TYPE.TOUCH_UP) then
			--local result = xlScene_IsGridBlock(g_world, worldX / 24, worldY / 24) --某个坐标是否是障碍
			--local count = xlScene_GetBlockCount(g_world) --获得大地图上的所有障碍的累加值
			--print(result, count)
			
			--geyachao: 如果是选中了某张战术技能卡，本次点击是用来释放战术技能卡技能的，不是选中角色
			local tacticCardCtrls = w.data.tacticCardCtrls --战术技能卡控件集
			for i = 1, #tacticCardCtrls, 1 do
				local cardi = tacticCardCtrls[i]
				if cardi and (cardi ~= 0) then
					if (cardi.data.selected == 1) then --战术技能卡是选中状态
						--print("战术技能卡是选中状态", i)
						local activeSkillType = cardi.data.skillType --技能释放的类型
						--print("activeSkillType=", activeSkillType)
						if (activeSkillType == hVar.CAST_TYPE.SKILL_TO_GROUND) then --对地面释放
							--施法
							--hApi.UseLocalTacticCard(cardi, worldX, worldY)
							--geyachao: 改为发送指令-使用战术卡
							--print("改为发送指令-使用战术卡3")
							hApi.AddCommand(hVar.Operation.UseTacticCard, cardi.data.tacticId, cardi.data.itemId, worldX, worldY, 0, 0)
							
							--geyachao: 客户端提前操作，取消对之前战术技能的选中
							if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
								hApi.safeRemoveT(cardi.childUI, "selectbox") --删除选中特效
								cardi.data.selected = 0
							end
						elseif (activeSkillType == hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK) then --对有效的地面坐标
							--[[
							--检测该点是否可到达
							--local godUnit = w.data.tdMapInfo.godUnit
							local godUnit = self:getgod()
							local waypoint = xlCha_MoveToGrid(godUnit.handle._c, worldX / 24, worldY / 24, 0, nil)
							local godX, godY = hApi.chaGetPos(godUnit.handle) --上帝的位置
							local issamepoint = ((math.floor(godX / 24) == math.floor(worldX / 24)) and (math.floor(godY / 24) == math.floor(worldY / 24)))
							if (waypoint[0] == 0) and (not issamepoint) then --寻路失败
							]]
							--检测该点是否是障碍物
							local result = xlScene_IsGridBlock(g_world, worldX / 24, worldY / 24) --某个坐标是否是障碍
							--print("result=", result)
							if (result == 0) then
								--不是障碍，检测是否在水里
								result = hApi.IsPosInWater(worldX, worldY)
							end
							
							if (result >= 1) then --不能到达
								--创建不能施法的特效
								local effect = w:addeffect(418, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y
								--0.8秒后删除自身
								local delay = CCDelayTime:create(0.8)
								local node = effect.handle._n --cocos对象
								local actCall = CCCallFunc:create(function(ctrl)
									effect:del()
								end)
								local actSeq = CCSequence:createWithTwoActions(delay, actCall)
								node:runAction(actSeq)
								
								--冒字
								local strText = "无效的目标点" --language
								--local strText = hVar.tab_string["__TEXT_PVP_WaitingHint"] --language
								hUI.floatNumber:new({
									x = hVar.SCREEN.w / 2,
									y = hVar.SCREEN.h / 2,
									align = "MC",
									text = "",
									lifetime = 1000,
									fadeout = -550,
									moveY = 32,
								}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
							else --寻路成功，并且不在水里
								--施法使用战术卡
								--hApi.UseLocalTacticCard(cardi, worldX, worldY)
								--geyachao: 改为发送指令-使用战术卡
								--print("改为发送指令-使用战术卡2")
								hApi.AddCommand(hVar.Operation.UseTacticCard, cardi.data.tacticId, cardi.data.itemId, worldX, worldY, 0, 0)
								
								--geyachao: 客户端提前操作，取消对之前战术技能的选中
								if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
									hApi.safeRemoveT(cardi.childUI, "selectbox") --删除选中特效
									cardi.data.selected = 0
								end
							end
						elseif (activeSkillType == hVar.CAST_TYPE.IMMEDIATE) then --直接生效类型
							--不会走进来
						elseif (activeSkillType == hVar.CAST_TYPE.SKILL_TO_UNIT_IMMEDIATE) then --点对自身周围的随机单位施法
							--不会走进来
						elseif (activeSkillType == hVar.CAST_TYPE.SKILL_TO_GROUND_MOVE_TO_POINT) then --移动到达射程后再对地生效
							--施法
							--hApi.UseLocalTacticCard(cardi, worldX, worldY)
							--geyachao: 改为发送指令-使用战术卡
							--print("改为发送指令-使用战术卡4")
							hApi.AddCommand(hVar.Operation.UseTacticCard, cardi.data.tacticId, cardi.data.itemId, worldX, worldY, 0, 0)
							
							--geyachao: 客户端提前操作，取消对之前战术技能的选中
							if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
								hApi.safeRemoveT(cardi.childUI, "selectbox") --删除选中特效
								cardi.data.selected = 0
							end
						elseif (activeSkillType == hVar.CAST_TYPE.SKILL_TO_GROUND_MOVE_TO_POINT_BLOCK) then --移动到达射程后再对有效地生效
							--检测该点是否是障碍物
							local result = xlScene_IsGridBlock(g_world, worldX / 24, worldY / 24) --某个坐标是否是障碍
							--print("result=", result)
							if (result == 0) then
								--不是障碍，检测是否在水里
								result = hApi.IsPosInWater(worldX, worldY)
							end
							
							if (result >= 1) then --不能到达
								--创建不能施法的特效
								local effect = w:addeffect(418, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y
								--0.8秒后删除自身
								local delay = CCDelayTime:create(0.8)
								local node = effect.handle._n --cocos对象
								local actCall = CCCallFunc:create(function(ctrl)
									effect:del()
								end)
								local actSeq = CCSequence:createWithTwoActions(delay, actCall)
								node:runAction(actSeq)
								
								--冒字
								local strText = "无效的目标点" --language
								--local strText = hVar.tab_string["__TEXT_PVP_WaitingHint"] --language
								hUI.floatNumber:new({
									x = hVar.SCREEN.w / 2,
									y = hVar.SCREEN.h / 2,
									align = "MC",
									text = "",
									lifetime = 1000,
									fadeout = -550,
									moveY = 32,
								}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
							else --寻路成功，并且不在水里
								--施法
								--hApi.UseLocalTacticCard(cardi, worldX, worldY)
								--geyachao: 改为发送指令-使用战术卡
								--print("改为发送指令-使用战术卡4")
								hApi.AddCommand(hVar.Operation.UseTacticCard, cardi.data.tacticId, cardi.data.itemId, worldX, worldY, 0, 0)
								
								--geyachao: 客户端提前操作，取消对之前战术技能的选中
								if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
									hApi.safeRemoveT(cardi.childUI, "selectbox") --删除选中特效
									cardi.data.selected = 0
								end
							end
						elseif (activeSkillType == hVar.CAST_TYPE.SKILL_TO_UNIT) then --对目标生效
							local t = w:hit2unit(worldX, worldY, "worldmap_up") --鼠标选中的角色
							if t then
								local tactciId = cardi.data.tacticId
								local skillId = cardi.data.skillId
								local bindHero = cardi.data.bindHero --此战术技能卡绑定的英雄对象
								if bindHero and (bindHero ~= 0) then
									local oUnit = bindHero:getunit()
									if oUnit and (oUnit ~= 0) then
										--检测战术技能是否能对该单位生效
										if (hApi.IsSkillTargetValid(oUnit, t, skillId) == hVar.RESULT_SUCESS) then
											--检测该点是否是障碍物
											local result = xlScene_IsGridBlock(g_world, worldX / 24, worldY / 24) --某个坐标是否是障碍
											--print("result=", result)
											if (result == 0) then
												--不是障碍，检测是否在水里
												result = hApi.IsPosInWater(worldX, worldY)
											end
											
											if (result >= 1) then --不能到达
												--目标无法到达
												local strText = "目标无法到达！"
												hUI.floatNumber:new({
													x = hVar.SCREEN.w / 2,
													y = hVar.SCREEN.h / 2,
													align = "MC",
													text = "",
													lifetime = 1000,
													fadeout = -550,
													moveY = 32,
												}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
											else --寻路成功，并且不在水里
												--施法
												--hApi.UseLocalTacticCard(cardi, worldX, worldY)
												--geyachao: 改为发送指令-使用战术卡
												--print("改为发送指令-使用战术卡4")
												hApi.AddCommand(hVar.Operation.UseTacticCard, cardi.data.tacticId, cardi.data.itemId, 0, 0, t:getworldI(), t:getworldC())
												
												--geyachao: 客户端提前操作，取消对之前战术技能的选中
												if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
													hApi.safeRemoveT(cardi.childUI, "selectbox") --删除选中特效
													cardi.data.selected = 0
												end
											end
										else
											--不能对此目标施法
											local strText = "不能对此目标施法！"
											hUI.floatNumber:new({
												x = hVar.SCREEN.w / 2,
												y = hVar.SCREEN.h / 2,
												align = "MC",
												text = "",
												lifetime = 1000,
												fadeout = -550,
												moveY = 32,
											}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
										end
									else
										--施法者已阵亡
										local strText = "施法者已阵亡，不能施法！"
										hUI.floatNumber:new({
											x = hVar.SCREEN.w / 2,
											y = hVar.SCREEN.h / 2,
											align = "MC",
											text = "",
											lifetime = 1000,
											fadeout = -550,
											moveY = 32,
										}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
									end
								else
									--未绑定施法者
									local strText = "未绑定施法者！"
									hUI.floatNumber:new({
										x = hVar.SCREEN.w / 2,
										y = hVar.SCREEN.h / 2,
										align = "MC",
										text = "",
										lifetime = 1000,
										fadeout = -550,
										moveY = 32,
									}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
								end
							else
								--未选中单位
								local strText = "未选中单位！"
								hUI.floatNumber:new({
									x = hVar.SCREEN.w / 2,
									y = hVar.SCREEN.h / 2,
									align = "MC",
									text = "",
									lifetime = 1000,
									fadeout = -550,
									moveY = 32,
								}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
							end
						elseif (activeSkillType == hVar.CAST_TYPE.SKILL_TO_UNIT_MOVE_TO_POINT) then --移动到达射程后再对施法点周围随机单位生效
							--施法
							--hApi.UseLocalTacticCard(cardi, worldX, worldY)
							--geyachao: 改为发送指令-使用战术卡
							--print("改为发送指令-使用战术卡4")
							hApi.AddCommand(hVar.Operation.UseTacticCard, cardi.data.tacticId, cardi.data.itemId, worldX, worldY, 0, 0)
							
							--geyachao: 客户端提前操作，取消对之前战术技能的选中
							if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
								hApi.safeRemoveT(cardi.childUI, "selectbox") --删除选中特效
								cardi.data.selected = 0
							end
						elseif (activeSkillType == hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY) then --TD对地面有效的非障碍点地方，靠近能量圈附近
							--[[
							--检测该点是否可到达
							--local godUnit = w.data.tdMapInfo.godUnit
							local godUnit = self:getgod()
							local waypoint = xlCha_MoveToGrid(godUnit.handle._c, worldX / 24, worldY / 24, 0, nil)
							local godX, godY = hApi.chaGetPos(godUnit.handle) --上帝的位置
							local issamepoint = ((math.floor(godX / 24) == math.floor(worldX / 24)) and (math.floor(godY / 24) == math.floor(worldY / 24)))
							if (waypoint[0] == 0) and (not issamepoint) then --寻路失败
							]]
							--检测该点是否是障碍物
							local result = xlScene_IsGridBlock(g_world, worldX / 24, worldY / 24) --某个坐标是否是障碍
							--print("result=", result)
							if (result == 0) then
								--不是障碍，检测是否在水里
								result = hApi.IsPosInWater(worldX, worldY)
							end
							
							if (result >= 1) then --不能到达
								--创建不能施法的特效
								local effect = w:addeffect(418, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y
								--0.8秒后删除自身
								local delay = CCDelayTime:create(0.8)
								local node = effect.handle._n --cocos对象
								local actCall = CCCallFunc:create(function(ctrl)
									effect:del()
								end)
								local actSeq = CCSequence:createWithTwoActions(delay, actCall)
								node:runAction(actSeq)
								
								--冒字
								local strText = "无效的目标点" --language
								--local strText = hVar.tab_string["__TEXT_PVP_WaitingHint"] --language
								hUI.floatNumber:new({
									x = hVar.SCREEN.w / 2,
									y = hVar.SCREEN.h / 2,
									align = "MC",
									text = "",
									lifetime = 1000,
									fadeout = -550,
									moveY = 32,
								}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
							else --寻路成功，并且不在水里
								--检测目标点周围是否有能量塔
								local bNearEnenegy = false
								local tabS = hVar.tab_skill[cardi.data.skillId]
								local energy_unit_id = tabS.energy_unit_id or 0 --充能塔单位id
								local energy_build_radius = tabS.energy_build_radius or 0 --充能塔可建造半径
								--print(energy_unit_id, energy_build_radius)
								if (energy_unit_id > 0) then
									--显示地图上全部充能塔的建造半径
									local world = hGlobal.WORLD.LastWorldMap
									world:enumunitArea(nil, worldX, worldY, energy_build_radius, function(eu)
										local typeId = eu.data.id --类型id
										if (typeId == energy_unit_id) then --找到了
											bNearEnenegy = true
										end
									end)
								end
								
								if bNearEnenegy then
									--尝试寻找一个可施法的点
									local nResult, tCollapeUnit, nResultX, nResultY = hApi.FindNearbyPoint(worldX, worldY)
									if (nResult == hVar.CAST_POINT_SKILL_RESULT.SUCCESS) then --有可施法点
										--施法使用战术卡
										--hApi.UseLocalTacticCard(cardi, worldX, worldY)
										--geyachao: 改为发送指令-使用战术卡
										--print("改为发送指令-使用战术卡2")
										hApi.AddCommand(hVar.Operation.UseTacticCard, cardi.data.tacticId, cardi.data.itemId, worldX, worldY, 0, 0)
										
										--geyachao: 客户端提前操作，取消对之前战术技能的选中
										if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
											hApi.safeRemoveT(cardi.childUI, "selectbox") --删除选中特效
											cardi.data.selected = 0
										end
									elseif (nResult == hVar.CAST_POINT_SKILL_RESULT.INVALID_POINT) then --无效的目标点
										--创建不能施法的特效
										local effect = w:addeffect(418, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y
										--0.8秒后删除自身
										local delay = CCDelayTime:create(0.8)
										local node = effect.handle._n --cocos对象
										local actCall = CCCallFunc:create(function(ctrl)
											effect:del()
										end)
										local actSeq = CCSequence:createWithTwoActions(delay, actCall)
										node:runAction(actSeq)
										
										--冒字
										--local strText = "该目标点不能建造塔" --language
										local strText = hVar.tab_string["__TEXT_BUILD_INVALID_POINT"] --language
										hUI.floatNumber:new({
											x = hVar.SCREEN.w / 2,
											y = hVar.SCREEN.h / 2,
											align = "MC",
											text = "",
											lifetime = 2000,
											fadeout = -550,
											moveY = 32,
										}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
									elseif (nResult == hVar.CAST_POINT_SKILL_RESULT.INVALID_ROAD) then --该路面不能建造塔
										--创建不能施法的特效
										local effect = w:addeffect(418, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y
										--0.8秒后删除自身
										local delay = CCDelayTime:create(0.8)
										local node = effect.handle._n --cocos对象
										local actCall = CCCallFunc:create(function(ctrl)
											effect:del()
										end)
										local actSeq = CCSequence:createWithTwoActions(delay, actCall)
										node:runAction(actSeq)
										
										--冒字
										--local strText = "该路面不能建造塔" --language
										local strText = hVar.tab_string["__TEXT_BUILD_INVALID_ROAD"] --language
										hUI.floatNumber:new({
											x = hVar.SCREEN.w / 2,
											y = hVar.SCREEN.h / 2,
											align = "MC",
											text = "",
											lifetime = 2000,
											fadeout = -550,
											moveY = 32,
										}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
									elseif (nResult == hVar.CAST_POINT_SKILL_RESULT.COLLAPSE_UNIT) then --目标点和单位重叠
										--标记相交单位
										local eu = tCollapeUnit
										--print("collapseUnit=", collapseUnit.data.name)
										
										if eu.chaUI["TD_Collapse"] then
											eu.chaUI["TD_Collapse"].handle.s:stopAllActions() --先停掉之前的动作
											hApi.safeRemoveT(eu.chaUI, "TD_Collapse")
										end
										
										--塔、驻守英雄
										local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --包围盒
										local eu_dx = eu_bx + eu_bw / 2 --中心点偏移x位置
										local eu_dy = eu_by + eu_bh / 2 --中心点偏移y位置
										--如果是塔显示攻击范围
										eu.chaUI["TD_Collapse"] = hUI.image:new({
											parent = eu.handle._n,
											x = eu_dx,
											y = -eu_dy,
											--model = "MODEL_EFFECT:SelectCircle",
											--animation = "range",
											model = "misc/mask_white.png",
											z = -255,
											--w = skillRange * 2 * 1.098, --geyachao: 实际的范围是程序的值的1.098倍
											w = eu_bw,
											h = eu_bh,
											scale = 1.0, --缩放比例
											--color = {128, 255, 128},
											--alpha = 48,
										})
										eu.chaUI["TD_Collapse"].handle.s:setColor(ccc3(255, 96, 48))
										
										--动画
										local act1 = CCFadeTo:create(0.2, 128)
										local act2 = CCFadeTo:create(0.2, 255)
										local act3 = CCFadeTo:create(0.2, 128)
										--local act4 = CCFadeTo:create(0.5, 255)
										local actCall = CCCallFunc:create(function(ctrl)
											hApi.safeRemoveT(eu.chaUI, "TD_Collapse")
										end)
										local a = CCArray:create()
										a:addObject(act1)
										a:addObject(act2)
										a:addObject(act3)
										--a:addObject(act4)
										a:addObject(actCall)
										local sequence = CCSequence:create(a)
										--eu.chaUI["TD_Collapse"].handle.s:stopAllActions() --先停掉之前的动作
										eu.chaUI["TD_Collapse"].handle.s:runAction(sequence)
										
										--创建不能施法的特效
										local effect = w:addeffect(418, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y
										--0.8秒后删除自身
										local delay = CCDelayTime:create(0.8)
										local node = effect.handle._n --cocos对象
										local actCall = CCCallFunc:create(function(ctrl)
											effect:del()
										end)
										local actSeq = CCSequence:createWithTwoActions(delay, actCall)
										node:runAction(actSeq)
										
										--冒字
										--local strText = "目标点和单位重叠" --language
										local strText = hVar.tab_string["__TEXT_BUILD_COLLAPSE_UNIT"] --language
										hUI.floatNumber:new({
											x = hVar.SCREEN.w / 2,
											y = hVar.SCREEN.h / 2,
											align = "MC",
											text = "",
											lifetime = 2000,
											fadeout = -550,
											moveY = 32,
										}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
									elseif (nResult == hVar.CAST_POINT_SKILL_RESULT.COLLAPSE_TOWER) then --目标点和附近建筑重叠
										--标记相交塔
										local eu = tCollapeUnit
										--print("collapseTower=", collapseTower.data.name)
										
										if eu.chaUI["TD_Collapse"] then
											eu.chaUI["TD_Collapse"].handle.s:stopAllActions() --先停掉之前的动作
											hApi.safeRemoveT(eu.chaUI, "TD_Collapse")
										end
										
										--塔
										local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --包围盒
										local eu_dx = eu_bx + eu_bw / 2 --中心点偏移x位置
										local eu_dy = eu_by + eu_bh / 2 --中心点偏移y位置
										--如果是塔显示攻击范围
										eu.chaUI["TD_Collapse"] = hUI.image:new({
											parent = eu.handle._n,
											x = eu_dx,
											y = -eu_dy,
											model = "MODEL_EFFECT:SelectCircle",
											animation = "range",
											z = -255,
											w = hVar.ROLE_BUILD_TOWER_DIS_MIN * 2 * 1.098, --geyachao: 实际的范围是程序的值的1.098倍
											--color = {128, 255, 128},
											--alpha = 48,
										})
										
										local scale = 0.99
										local a = CCScaleBy:create(0.75, scale, scale)
										local aR = a:reverse()
										local seq = tolua.cast(CCSequence:createWithTwoActions(a,aR),"CCActionInterval")
										eu.chaUI["TD_Collapse"].handle._n:runAction(CCRepeatForever:create(seq))
										
										local program = nil
										
										--蓝色绿色
										--显示最小攻击范围
										local atkRangeMin = 0
											
										local scale = atkRangeMin / hVar.ROLE_BUILD_TOWER_DIS_MIN / 1.098
										--print("scale=", scale)
										
										program = hApi.getShader("atkrange1", 9, scale) --geyachao: 如果一个shader要每次设置不同的颜色，这里第二个参数填写值用作区分
										local resolution = program:glGetUniformLocation("resolution")
										program:setUniformLocationWithFloats(resolution,66,66)
										
										local rr = program:glGetUniformLocation("rr")
										local gg = program:glGetUniformLocation("gg")
										local bb = program:glGetUniformLocation("bb")
										program:setUniformLocationWithFloats(rr, 22.1)
										program:setUniformLocationWithFloats(gg, 0.26)
										program:setUniformLocationWithFloats(bb, 0.2)
										
										--显示最小攻击范围
										local inner_r = program:glGetUniformLocation("inner_r")
										program:setUniformLocationWithFloats(inner_r, scale)
										eu.chaUI["TD_Collapse"].handle.s:setShaderProgram(program)
										
										--动画
										local act1 = CCDelayTime:create(0.6)
										local actCall = CCCallFunc:create(function(ctrl)
											hApi.safeRemoveT(eu.chaUI, "TD_Collapse")
										end)
										local a = CCArray:create()
										a:addObject(act1)
										--a:addObject(act4)
										a:addObject(actCall)
										local sequence = CCSequence:create(a)
										--eu.chaUI["TD_Collapse"].handle.s:stopAllActions() --先停掉之前的动作
										eu.chaUI["TD_Collapse"].handle.s:runAction(sequence)
										
										--创建不能施法的特效
										local effect = w:addeffect(418, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y
										--0.8秒后删除自身
										local delay = CCDelayTime:create(0.8)
										local node = effect.handle._n --cocos对象
										local actCall = CCCallFunc:create(function(ctrl)
											effect:del()
										end)
										local actSeq = CCSequence:createWithTwoActions(delay, actCall)
										node:runAction(actSeq)
										
										--冒字
										--local strText = "目标点和附近建筑重叠" --language
										local strText = hVar.tab_string["__TEXT_BUILD_COLLAPSE_TOWER"] --language
										hUI.floatNumber:new({
											x = hVar.SCREEN.w / 2,
											y = hVar.SCREEN.h / 2,
											align = "MC",
											text = "",
											lifetime = 2000,
											fadeout = -550,
											moveY = 32,
										}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
									end
								else
									--创建不能施法的特效
									local effect = w:addeffect(418, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y
									--0.8秒后删除自身
									local delay = CCDelayTime:create(0.8)
									local node = effect.handle._n --cocos对象
									local actCall = CCCallFunc:create(function(ctrl)
										effect:del()
									end)
									local actSeq = CCSequence:createWithTwoActions(delay, actCall)
									node:runAction(actSeq)
									
									--冒字
									local strText = "只能建造在充能塔周围" --language
									--local strText = hVar.tab_string["__TEXT_PVP_WaitingHint"] --language
									hUI.floatNumber:new({
										x = hVar.SCREEN.w / 2,
										y = hVar.SCREEN.h / 2,
										align = "MC",
										text = "",
										lifetime = 1000,
										fadeout = -550,
										moveY = 32,
									}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
								end
							end
						end
						
						return
					end
				end
			end
			
			--pvp模式，隐藏可能选中的头像栏的复活按钮
			if (w.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
				for i = 1, #(oPlayerMe.heros), 1 do
					local oHero = oPlayerMe.heros[i]
					if oHero then
						if oHero.heroUI["pvp_rebirth_btn_yes"] then
							oHero.heroUI["pvp_rebirth_btn_yes"]:setstate(-1) --不显示
						end
					end
				end
			end
			
			--大菠萝不触发事件
			if (hVar.IS_DIABOLO_APP == 1) then
				return
			end
			
			local t = w:hit2unit(worldX, worldY, "worldmap_up") --鼠标选中的角色
			--print("鼠标选中的角色", t)
			--死亡的单位不能被选中
			if t and (t.data.IsDead == 1) then
				t = nil
			end
			
			--敌方隐身单位不能被选中
			if t then
				local yinshen_state = t:GetYinShenState() --是否在隐身状态
				if (t:getowner():getforce() ~= oPlayerMe:getforce()) and (yinshen_state == 1) then --敌方操控的、隐身单位
					t = nil
				end
			end
			
			local oUnit = oPlayerMe:getfocusunit() --上次旋中的角色
			
			--优化操作：如果上次未选中单位，本次选中了小兵，如果我方英雄也在点击范围内，认为是点到了我方英雄
			if (not oUnit) and t and (t.data.type == hVar.UNIT_TYPE.UNIT) then
				w:enumunit(function(eu)
					if (eu.data.type == hVar.UNIT_TYPE.HERO) and (eu:getowner() == oPlayerMe) then --是本方的英雄单位
						local hero_x, hero_y = hApi.chaGetPos(eu.handle) --英雄的坐标
						local hero_bx, hero_by, hero_bw, hero_bh = eu:getbox() --英雄的包围盒
						local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --英雄的中心点x位置
						local hero_center_y = hero_y + (hero_by + hero_bh / 2) --英雄的中心点y位置
						local hero_left = hero_center_x - hero_bw / 2 --英雄选中区域的最左侧
						local hero_right = hero_center_x + hero_bw / 2 --英雄选中区域的最右侧
						local hero_top = hero_center_y - hero_bh / 2 --英雄选中区域的最上侧
						local hero_bottom = hero_center_y + hero_bh / 2 --英雄选中区域的最下侧
						
						--在英雄包围盒区域内
						if (worldX >= hero_left) and (worldX <= hero_right) and (worldY >= hero_top) and (worldY <= hero_bottom) then
							t = eu
							--print("如果上次未选中单位，本次选中了小兵，如果我方英雄也在点击范围内，认为是点到了我方英雄")
						end
					end
				end)
			end
			
			--优化操作：如果上次未选中单位，本次选中了道具，如果我方英雄也在点击范围内，认为是点到了我方英雄
			if (not oUnit) and t and (t.data.type == hVar.UNIT_TYPE.ITEM) then
				w:enumunit(function(eu)
					if (eu.data.type == hVar.UNIT_TYPE.HERO) and (eu:getowner() == oPlayerMe) then --是本方的英雄单位
						local hero_x, hero_y = hApi.chaGetPos(eu.handle) --英雄的坐标
						local hero_bx, hero_by, hero_bw, hero_bh = eu:getbox() --英雄的包围盒
						local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --英雄的中心点x位置
						local hero_center_y = hero_y + (hero_by + hero_bh / 2) --英雄的中心点y位置
						local hero_left = hero_center_x - hero_bw / 2 --英雄选中区域的最左侧
						local hero_right = hero_center_x + hero_bw / 2 --英雄选中区域的最右侧
						local hero_top = hero_center_y - hero_bh / 2 --英雄选中区域的最上侧
						local hero_bottom = hero_center_y + hero_bh / 2 --英雄选中区域的最下侧
						
						--在英雄包围盒区域内
						if (worldX >= hero_left) and (worldX <= hero_right) and (worldY >= hero_top) and (worldY <= hero_bottom) then
							t = eu
							--print("如果上次未选中单位，本次选中了小兵，如果我方英雄也在点击范围内，认为是点到了我方英雄")
						end
					end
				end)
			end
			
			--优化操作：如果上次未选中单位，本次选中了小兵，如果我方或中立塔也在点击范围内，认为是点到了我方或中立塔
			if (not oUnit) and t and (t.data.type == hVar.UNIT_TYPE.UNIT) then
				w:enumunit(function(eu)
					if ((eu.data.type == hVar.UNIT_TYPE.TOWER) or (eu.data.type == hVar.UNIT_TYPE.BUILDING) or (eu.data.type == hVar.UNIT_TYPE.NPC_TALK) or (eu.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE)) and ((eu:getowner():getforce() == oPlayerMe:getforce())) then --是我方或中立塔、建筑、对话NPC
						local tower_x, tower_y = hApi.chaGetPos(eu.handle) --塔的坐标
						local tower_bx, tower_by, tower_bw, tower_bh = eu:getbox() --塔的包围盒
						local tower_center_x = tower_x + (tower_bx + tower_bw / 2) --塔的中心点x位置
						local tower_center_y = tower_y + (tower_by + tower_bh / 2) --塔的中心点y位置
						local tower_left = tower_center_x - tower_bw / 2 --塔选中区域的最左侧
						local tower_right = tower_center_x + tower_bw / 2 --塔选中区域的最右侧
						local tower_top = tower_center_y - tower_bh / 2 --塔选中区域的最上侧
						local tower_bottom = tower_center_y + tower_bh / 2 --塔选中区域的最下侧
						
						--在塔的包围盒区域内
						if (worldX >= tower_left) and (worldX <= tower_right) and (worldY >= tower_top) and (worldY <= tower_bottom) then
							t = eu
							--print("如果上次未选中单位，本次选中了小兵，如果我方塔也在点击范围内，认为是点到了我方塔")
						end
					end
				end)
			end
			
			--优化操作：如果上次选中了我方英雄，本次还是选中我方英雄，那么检测是否选中了敌方单位
			if oUnit and t and (oUnit.data.type == hVar.UNIT_TYPE.HERO) and (t.data.type == hVar.UNIT_TYPE.HERO) and (t:getowner() == oPlayerMe) then
				w:enumunit(function(eu)
					if ((eu:getowner():getforce() ~= oPlayerMe:getforce())) then --是敌方单位
						local enemy_x, enemy_y = hApi.chaGetPos(eu.handle) --敌方单位的坐标
						local enemy_bx, enemy_by, enemy_bw, enemy_bh = eu:getbox() ---敌方单位的包围盒
						local enemy_center_x = enemy_x + (enemy_bx + enemy_bw / 2) ---敌方单位的中心点x位置
						local enemy_center_y = enemy_y + (enemy_by + enemy_bh / 2) ---敌方单位的中心点y位置
						local enemy_left = enemy_center_x - enemy_bw / 2 ---敌方单位选中区域的最左侧
						local enemy_right = enemy_center_x + enemy_bw / 2 ---敌方单位选中区域的最右侧
						local enemy_top = enemy_center_y - enemy_bh / 2 ---敌方单位选中区域的最上侧
						local enemy_bottom = enemy_center_y + enemy_bh / 2 ---敌方单位选中区域的最下侧
						
						--在敌方单位的包围盒区域内
						if (worldX >= enemy_left) and (worldX <= enemy_right) and (worldY >= enemy_top) and (worldY <= enemy_bottom) then
							t = eu
							--print("如果上次选中了我方英雄，本次还是选中我方英雄，那么检测是否选中了敌方单位")
						end
					end
				end)
			end
			
			--优化操作：如果上次选中了我方英雄，本次还是选中同一单位，那么检测是否选中了其他英雄
			if oUnit and t and (oUnit.data.type == hVar.UNIT_TYPE.HERO) and (oUnit:getowner() == oPlayerMe) and (oUnit == t) then
				w:enumunit(function(eu)
					if (eu:getowner() == oPlayerMe) and (eu.data.type == hVar.UNIT_TYPE.HERO) and (eu ~= oUnit) then --是我方其他英雄单位
						local hero_x, hero_y = hApi.chaGetPos(eu.handle) --其他英雄的坐标
						local hero_bx, hero_by, hero_bw, hero_bh = eu:getbox() ---其他英雄的包围盒
						local hero_center_x = hero_x + (hero_bx + hero_bw / 2) ---其他英雄的中心点x位置
						local hero_center_y = hero_y + (hero_by + hero_bh / 2) ---其他英雄的中心点y位置
						local hero_left = hero_center_x - hero_bw / 2 ---其他英雄选中区域的最左侧
						local hero_right = hero_center_x + hero_bw / 2 ---其他英雄选中区域的最右侧
						local hero_top = hero_center_y - hero_bh / 2 ---其他英雄选中区域的最上侧
						local hero_bottom = hero_center_y + hero_bh / 2 ---其他英雄选中区域的最下侧
						
						--在其他英雄的包围盒区域内
						if (worldX >= hero_left) and (worldX <= hero_right) and (worldY >= hero_top) and (worldY <= hero_bottom) then
							t = eu
							--print("如果上次选中了我方英雄，本次还是选中同一单位，那么检测是否选中了其他英雄")
						end
					end
				end)
			end
			
			--t = nil
			--print("t=", t and t.data.name)
			--优化操作：如果上次选中的是我方英雄，本次也选中了我方英雄（同一个），那么如果本地精确点击了英雄，才算点击到新英雄，否则还是认为点击地面
			if oUnit and t and (oUnit:getowner() == oPlayerMe) and (oUnit.data.type == hVar.UNIT_TYPE.HERO) and (t == oUnit) then
				--本次点击的英雄的中心位置
				local hero_x, hero_y = hApi.chaGetPos(t.handle) --本次点击的英雄的坐标
				local hero_bx, hero_by, hero_bw, hero_bh = t:getbox() --本次点击的英雄的包围盒
				local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --本次点击的英雄的中心点x位置
				local hero_center_y = hero_y + (hero_by + hero_bh / 2) --本次点击的英雄的中心点y位置
				local dx = hero_center_x - worldX
				local dy = hero_center_y - worldY
				local distance = math.sqrt(dx * dx + dy * dy) --精确的距离
				if (distance > 15) then
					t = nil
					--print("如果上次选中的是我方英雄，本次也选中了我方英雄（同一个），那么如果本地精确点击了英雄，才算点击到新英雄，否则还是认为点击地面")
				else
					--两次的格子是同一个
					local hero_gridX, hero_gridY = w:xy2grid(hero_x, hero_y)
					if (hero_gridX == gridX) and (hero_gridY == gridY) then
						t = nil
						--print("如果上次选中的是我方英雄，本次也选中了我方英雄（同一个），那么如果两次的格子是同一个，认为是点击地面")
					end
				end
			end
			
			--优化操作：如果上次选中了我方英雄，本次选中任何单位，除了敌方单位(道具可以点击)，都认为是点击地面
			if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
				if oUnit and t and (oUnit.data.type == hVar.UNIT_TYPE.HERO) and (t:getowner():getforce() == oPlayerMe:getforce()) then
					--print("如果上次选中了我方英雄，本次选中任何单位，除了敌方单位，都认为是点击地面")
					--if (t.data.id ~= 15034) then --geyachao: 极特殊处理，无尽模式大本营可以点
					
					--if (t.data.type ~= hVar.UNIT_TYPE.ITEM) then --道具可以点击 --大菠萝注释掉
						t = nil
					--end
					--end
				end
			end
			
			--持续选中模式：如果上次选中了我方英雄，本次选中了非敌方小兵，认为是点击地面
			if (hVar.OP_LASTING_MODE == 1) then --非持续选中模式
				if oUnit and t and (oUnit.data.type == hVar.UNIT_TYPE.HERO) and (t.data.type == hVar.UNIT_TYPE.UNIT) and (t:getowner():getforce() == oPlayerMe:getforce()) then
					--print("pvp持续选中模式：如果上次选中了我方英雄，本次选中了非敌方小兵，认为是点击地面")
					--if (t.data.type ~= hVar.UNIT_TYPE.ITEM) then --道具可以点击 --大菠萝注释掉
						t = nil
					--end
				end
			end
			
			--优化操作：如果上次选中了我方英雄，本次选中敌方的非英雄、非单位、非塔、非建筑，也认为是点击地面
			if (w.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
				if oUnit and t and (oUnit.data.type == hVar.UNIT_TYPE.HERO) and (t:getowner():getforce() ~= oPlayerMe:getforce()) and ((t.data.type ~= hVar.UNIT_TYPE.HERO) and (t.data.type ~= hVar.UNIT_TYPE.UNIT) and (t.data.type ~= hVar.UNIT_TYPE.TOWER) and (t.data.type ~= hVar.UNIT_TYPE.BUILDING)) then
					--print("如果上次选中了我方英雄，本次选中敌方塔，也认为是点击地面")
					--if (t.data.type ~= hVar.UNIT_TYPE.ITEM) then --道具可以点击 --大菠萝注释掉
						t = nil
					--end
				end
			else
				if oUnit and t and (oUnit.data.type == hVar.UNIT_TYPE.HERO) and (t:getowner():getforce() ~= oPlayerMe:getforce()) and ((t.data.type ~= hVar.UNIT_TYPE.HERO) and (t.data.type ~= hVar.UNIT_TYPE.UNIT)) then
					--print("如果上次选中了我方英雄，本次选中敌方塔，也认为是点击地面")
					--if (t.data.type ~= hVar.UNIT_TYPE.ITEM) then --道具可以点击 --大菠萝注释掉
						t = nil
					--end
				end
			end
			
			--大菠萝加上
			--点到道具，改为点地面
			if t and (t.data.type == hVar.UNIT_TYPE.ITEM) then
				t = nil
			end
			
			--[[
			--优化操作：不再需要能点到敌方单位
			if oUnit and t and (t:getowner():getforce() ~= oPlayerMe:getforce()) then
				print("不再需要能点到敌方单位")
				t = nil
			end
			]]
			
			--print("触发事件:TOUCH_DOWN")
			--print("__WorldDownTarget = " .. (t and t.data.name or tostring(t)) .. ", x=" .. worldX .. ", y=" .. worldY)
			if (t ~= nil) then --选中了某个单位
				__WorldDownTarget = t
				
				--geyachao: 不选中小兵
				if (oUnit) then
					--local isTower = hVar.tab_unit[t.data.id].isTower or 0 --是否为塔
					if ((t.data.type == hVar.UNIT_TYPE.TOWER) or (t.data.type == hVar.UNIT_TYPE.BUILDING) or (t.data.type == hVar.UNIT_TYPE.NPC_TALK) or (t.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE)) and ((t:getowner() == oPlayerMe) or (t:getowner() == oNeutralPlayer)) then --本次选中的为我方或中立的 塔、建筑、对话NPC
						if (oUnit == t) then --点击两次同一个单位，取消选中
							--geyachao: 操作优化，点击两次，取消对之前选中单位的选中
							p:focusunit(nil, "worldmap")
							hGlobal.event:event("LocalEvent_HitOnTarget", w, nil, worldX, worldY)
							hGlobal.event:event("Event_TDUnitActived", w, 1, nil)
							hGlobal.O:replace("__WM__TargetOperatePanel", nil)
							hGlobal.O:replace("__WM__MoveOperatePanel", nil)
							--hGlobal.event:event("LocalEvent_PlayerChooseHero", oHero)
							
							--触发事件: 操作面板关闭
							hGlobal.event:event("LocalEvent_OperationPanelClosed", "double_click_close")
						else
							p:focusunit(t, "worldmap")
							hGlobal.event:event("LocalEvent_HitOnTarget",w,t,worldX,worldY)
							--hGlobal.event:event("Event_BattlefieldUnitActived",w,1, t)
							hGlobal.event:event("Event_TDUnitActived",w,1, t)
							
							--刷新英雄头像
							hGlobal.event:event("LocalEvent_PlayerChooseHero", nil)
						end
					elseif (t.data.type == hVar.UNIT_TYPE.TOWER) and (t:getowner():getforce() ~= oPlayerMe:getforce()) and (oUnit.data.type ~= hVar.UNIT_TYPE.HERO)then --本次选中的为敌方的塔，上次选中的非英雄
						if (oUnit == t) then --点击两次同一个单位，取消选中
							--geyachao: 操作优化，点击两次，取消对之前选中单位的选中
							p:focusunit(nil, "worldmap")
							hGlobal.event:event("LocalEvent_HitOnTarget", w, nil, worldX, worldY)
							hGlobal.event:event("Event_TDUnitActived", w, 1, nil)
							hGlobal.O:replace("__WM__TargetOperatePanel", nil)
							hGlobal.O:replace("__WM__MoveOperatePanel", nil)
							
							--触发事件: 操作面板关闭
							hGlobal.event:event("LocalEvent_OperationPanelClosed", "double_click_close")
						else
							p:focusunit(t, "worldmap")
							hGlobal.event:event("LocalEvent_HitOnTarget",w,t,worldX,worldY)
							--hGlobal.event:event("Event_BattlefieldUnitActived",w,1, t)
							hGlobal.event:event("Event_TDUnitActived",w,1, t)
						end
					elseif (t:getowner() == oPlayerMe) and (t.data.type ~= hVar.UNIT_TYPE.ITEM) then --本次选中的是自己操控的玩家，非道具
						if (oUnit == t) then --点击两次，取消选中
							--geyachao: 操作优化，点击两次，取消对之前选中单位的选中
							if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
								p:focusunit(nil, "worldmap")
								hGlobal.event:event("LocalEvent_HitOnTarget", w, nil, worldX,worldY)
								hGlobal.event:event("Event_TDUnitActived", w, 1, nil)
								hGlobal.O:replace("__WM__TargetOperatePanel",nil)
								hGlobal.O:replace("__WM__MoveOperatePanel",nil)
								
								--刷新英雄头像
								hGlobal.event:event("LocalEvent_PlayerChooseHero", nil)
							end
						else
							p:focusunit(t, "worldmap")
							hGlobal.event:event("LocalEvent_HitOnTarget",w,t,worldX,worldY)
							--hGlobal.event:event("Event_BattlefieldUnitActived",w,1, t)
							hGlobal.event:event("Event_TDUnitActived",w, 1, t)
							
							--刷新英雄头像
							for i = 1, #oPlayerMe.heros, 1 do
								local oHero = oPlayerMe.heros[i]
								if oHero then
									local tt = oHero:getunit()
									if (tt == t) then
										hGlobal.event:event("LocalEvent_PlayerChooseHero", oHero)
									end
								end
							end
							
							--存储主动选中的英雄单位
							w.data.activeSelectedUnit = t
						end
					elseif (oUnit:getowner() == oPlayerMe) and (oUnit.data.type == hVar.UNIT_TYPE.HERO) and (t:getowner():getforce() ~= oPlayerMe:getforce()) then --上次选中本方、英雄，本次选中敌方单位
						--英雄试图移动到目标
						--检测目标是否可以到达
						local t_x, t_y = hApi.chaGetPos(t.handle) --目标的坐标
						local waypoint = xlCha_MoveToGrid(oUnit.handle._c, t_x / 24, t_y / 24, 0, nil)
						
						--两次的格子是同一个
						local nIsSameGrid = 0 --两次的格子是同一个
						local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --英雄的坐标
						local hero_gridX, hero_gridY = w:xy2grid(hero_x, hero_y)
						local target_gridX, target_gridY = w:xy2grid(t_x, t_y)
						if (hero_gridX == target_gridX) and (hero_gridY == target_gridY) then
							nIsSameGrid = 1
						end
						
						if (nIsSameGrid == 0) and (waypoint[0] == 0) then --如果寻路失败，那么提示该点不能到达
							--[[
							--删除移动的箭头特效
							if (oUnit.data.JianTouEffect ~= 0) then
								oUnit.data.JianTouEffect:del()
								oUnit.data.JianTouEffect = 0
							end
							
							--删除攻击箭头的特效
							if (oUnit.data.AttackEffect ~= 0) then
								oUnit.data.AttackEffect:del()
								oUnit.data.AttackEffect = 0
							end
							
							--创建不能移动的箭头特效
							oUnit.data.JianTouEffect = w:addeffect(418, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y, facing, scale
							--0.8秒后删除自身
							local delay = CCDelayTime:create(0.8)
							local node = oUnit.data.JianTouEffect.handle._n --cocos对象
							local actCall = CCCallFunc:create(function(ctrl)
								oUnit.data.JianTouEffect:del()
								oUnit.data.JianTouEffect = 0
							end)
							local actSeq = CCSequence:createWithTwoActions(delay, actCall)
							node:runAction(actSeq)
							]]
							--geyachao: 本地提前创建动画表现移动（收到指令才真正执行移动操作）
							--删除移动的箭头特效
							if (oUnit.data.JianTouEffect ~= 0) then
								oUnit.data.JianTouEffect:del()
								oUnit.data.JianTouEffect = 0
							end
							
							--删除攻击箭头的特效
							if (oUnit.data.AttackEffect ~= 0) then
								oUnit.data.AttackEffect:del()
								oUnit.data.AttackEffect = 0
							end
							
							--创建箭头特效
							local jiantouEff = w:addeffect(1, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y
							oUnit.data.JianTouEffect = jiantouEff
							--0.8秒后删除自身
							local delay = CCDelayTime:create(0.8)
							local node = oUnit.data.JianTouEffect.handle._n --cocos对象
							local actCall = CCCallFunc:create(function(ctrl)
								jiantouEff:del()
								oUnit.data.JianTouEffect = 0
							end)
							local actSeq = CCSequence:createWithTwoActions(delay, actCall)
							node:runAction(actSeq)
							
							--geyachao: 改为发送指令-移动到目标点(目标不能到达模式)
							--改为移动到目标点
							--print("改为发送指令-移动到目标点(目标不能到达模式)")
							hApi.AddCommand(hVar.Operation.Move, oUnit:getworldI(), oUnit:getworldC(), worldX, worldY, 0, 0, 0, 0, 0, 0)
							
							--geyachao: 客户端提前操作，取消对之前选中英雄的选中
							if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
								oPlayerMe:focusunit(nil, "worldmap")
								hGlobal.event:event("LocalEvent_HitOnTarget", w, nil, worldX, worldY)
								hGlobal.event:event("Event_TDUnitActived", w, 1, nil)
								hGlobal.O:replace("__WM__TargetOperatePanel",nil)
								hGlobal.O:replace("__WM__MoveOperatePanel",nil)
								
								--刷新英雄头像
								hGlobal.event:event("LocalEvent_PlayerChooseHero", nil)
							end
						else --可以到达
							--geyachao: 本地提前创建动画表现移动（收到指令才真正执行移动操作）
							--删除移动的箭头特效
							if (oUnit.data.JianTouEffect ~= 0) then
								oUnit.data.JianTouEffect:del()
								oUnit.data.JianTouEffect = 0
							end
							
							--删除攻击箭头的特效
							if (oUnit.data.AttackEffect ~= 0) then
								oUnit.data.AttackEffect:del()
								oUnit.data.AttackEffect = 0
							end
							
							--创建攻击箭头特效
							local tx, ty = hApi.chaGetPos(t.handle) --目标的坐标
							local attackEff = nil
							if (t.data.type == hVar.UNIT_TYPE.ITEM) then --捡道具图标
								attackEff = w:addeffect(413, -1, nil, tx, ty) --effectId, time(单位:秒), ???, pos_x, pos_y, facing, scale
								attackEff.handle.s:setPositionX(-25)
								attackEff.handle.s:setPositionY(10)
								attackEff.handle.s:setScale(0.9)
								attackEff.handle._n:setPosition(tx + 15, -ty + 20)
							else --攻击单位图标
								attackEff = w:addeffect(5, -1, nil, tx, ty) --effectId, time(单位:秒), ???, pos_x, pos_y, facing, scale
								attackEff.handle._n:setPosition(tx + 15, -ty + 20)
							end
							
							--print("创建攻击箭头特效", tx + 15, -ty + 20, t.data.name)
							oUnit.data.AttackEffect = attackEff
							--0.8秒后删除自身
							local delay = CCDelayTime:create(0.8)
							local node = oUnit.data.AttackEffect.handle._n --cocos对象
							local actCall = CCCallFunc:create(function(ctrl)
								attackEff:del()
								oUnit.data.AttackEffect = 0
							end)
							local actSeq = CCSequence:createWithTwoActions(delay, actCall)
							node:runAction(actSeq)
							
							--geyachao: 改为发送指令-移动到目标
							--print("改为发送指令-移动到目标")
							hApi.AddCommand(hVar.Operation.Move, oUnit:getworldI(), oUnit:getworldC(), worldX, worldY, t:getworldI(), t:getworldC(), 0, 0, 0, 0)
							
							--geyachao: 客户端提前操作，取消对之前选中英雄的选中
							if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
								oPlayerMe:focusunit(nil, "worldmap")
								hGlobal.event:event("LocalEvent_HitOnTarget", w, nil, worldX, worldY)
								hGlobal.event:event("Event_TDUnitActived", w, 1, nil)
								hGlobal.O:replace("__WM__TargetOperatePanel",nil)
								hGlobal.O:replace("__WM__MoveOperatePanel",nil)
								
								--刷新英雄头像
								hGlobal.event:event("LocalEvent_PlayerChooseHero", nil)
							end
						end
					--elseif (oUnit:getowner() == oPlayerMe) and (oUnit.data.type == hVar.UNIT_TYPE.HERO) and (t.data.type == hVar.UNIT_TYPE.ITEM) then --上次选中本方、英雄，本次选中道具
					elseif (oUnit:getowner() == oPlayerMe) and (oUnit.data.type == hVar.UNIT_TYPE.HERO) then --上次选中本方、英雄，本次选中道具 -)大菠萝注释掉
						--英雄试图移动到目标
						--检测目标是否可以到达
						local t_x, t_y = hApi.chaGetPos(t.handle) --目标的坐标
						local waypoint = xlCha_MoveToGrid(oUnit.handle._c, t_x / 24, t_y / 24, 0, nil)
						
						--两次的格子是同一个
						local nIsSameGrid = 0 --两次的格子是同一个
						local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --英雄的坐标
						local hero_gridX, hero_gridY = w:xy2grid(hero_x, hero_y)
						local target_gridX, target_gridY = w:xy2grid(t_x, t_y)
						if (hero_gridX == target_gridX) and (hero_gridY == target_gridY) then
							nIsSameGrid = 1
						end
						--print(nIsSameGrid, waypoint[0])
						if (nIsSameGrid == 0) and (waypoint[0] == 0) then --如果寻路失败，那么提示该点不能到达
							--[[
							--删除移动的箭头特效
							if (oUnit.data.JianTouEffect ~= 0) then
								oUnit.data.JianTouEffect:del()
								oUnit.data.JianTouEffect = 0
							end
							
							--删除攻击箭头的特效
							if (oUnit.data.AttackEffect ~= 0) then
								oUnit.data.AttackEffect:del()
								oUnit.data.AttackEffect = 0
							end
							
							--创建不能移动的箭头特效
							oUnit.data.JianTouEffect = w:addeffect(418, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y, facing, scale
							--0.7秒后删除自身
							local delay = CCDelayTime:create(0.7)
							local node = oUnit.data.JianTouEffect.handle._n --cocos对象
							local actCall = CCCallFunc:create(function(ctrl)
								oUnit.data.JianTouEffect:del()
								oUnit.data.JianTouEffect = 0
							end)
							local actSeq = CCSequence:createWithTwoActions(delay, actCall)
							node:runAction(actSeq)
							]]
							--geyachao: 本地提前创建动画表现移动（收到指令才真正执行移动操作）
							--删除移动的箭头特效
							if (oUnit.data.JianTouEffect ~= 0) then
								oUnit.data.JianTouEffect:del()
								oUnit.data.JianTouEffect = 0
							end
							
							--删除攻击箭头的特效
							if (oUnit.data.AttackEffect ~= 0) then
								oUnit.data.AttackEffect:del()
								oUnit.data.AttackEffect = 0
							end
							
							--创建箭头特效
							local jiantouEff = w:addeffect(1, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y
							oUnit.data.JianTouEffect = jiantouEff
							--0.8秒后删除自身
							local delay = CCDelayTime:create(0.8)
							local node = oUnit.data.JianTouEffect.handle._n --cocos对象
							local actCall = CCCallFunc:create(function(ctrl)
								jiantouEff:del()
								oUnit.data.JianTouEffect = 0
							end)
							local actSeq = CCSequence:createWithTwoActions(delay, actCall)
							node:runAction(actSeq)
							
							--geyachao: 改为发送指令-移动到目标点(目标不能到达模式)
							--改为移动到目标点
							--print("改为发送指令-移动到目标点(目标不能到达模式)")
							hApi.AddCommand(hVar.Operation.Move, oUnit:getworldI(), oUnit:getworldC(), worldX, worldY, 0, 0, 0, 0, 0, 0)
							
							--geyachao: 客户端提前操作，取消对之前选中英雄的选中
							if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
								oPlayerMe:focusunit(nil, "worldmap")
								hGlobal.event:event("LocalEvent_HitOnTarget", w, nil, worldX, worldY)
								hGlobal.event:event("Event_TDUnitActived", w, 1, nil)
								hGlobal.O:replace("__WM__TargetOperatePanel",nil)
								hGlobal.O:replace("__WM__MoveOperatePanel",nil)
								
								--刷新英雄头像
								hGlobal.event:event("LocalEvent_PlayerChooseHero", nil)
							end
						else --可以到达
							--geyachao: 本地提前创建动画表现移动（收到指令才真正执行移动操作）
							--删除移动的箭头特效
							if (oUnit.data.JianTouEffect ~= 0) then
								oUnit.data.JianTouEffect:del()
								oUnit.data.JianTouEffect = 0
							end
							
							--删除攻击箭头的特效
							if (oUnit.data.AttackEffect ~= 0) then
								oUnit.data.AttackEffect:del()
								oUnit.data.AttackEffect = 0
							end
							
							--创建攻击箭头特效
							local tx, ty = hApi.chaGetPos(t.handle) --目标的坐标
							local attackEff = w:addeffect(5, -1, nil, tx, ty) --effectId, time(单位:秒), ???, pos_x, pos_y, facing, scale
							attackEff.handle._n:setPosition(tx + 15, -ty + 20)
							--print("创建攻击箭头特效", tx + 15, -ty + 20, t.data.name)
							oUnit.data.AttackEffect = attackEff
							--0.8秒后删除自身
							local delay = CCDelayTime:create(0.8)
							local node = oUnit.data.AttackEffect.handle._n --cocos对象
							local actCall = CCCallFunc:create(function(ctrl)
								attackEff:del()
								oUnit.data.AttackEffect = 0
							end)
							local actSeq = CCSequence:createWithTwoActions(delay, actCall)
							node:runAction(actSeq)
							
							--geyachao: 改为发送指令-移动到目标
							--print("改为发送指令-移动到目标")
							hApi.AddCommand(hVar.Operation.Move, oUnit:getworldI(), oUnit:getworldC(), worldX, worldY, t:getworldI(), t:getworldC(), 0, 0, 0, 0)
							
							--geyachao: 客户端提前操作，取消对之前选中英雄的选中
							if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
								oPlayerMe:focusunit(nil, "worldmap")
								hGlobal.event:event("LocalEvent_HitOnTarget", w, nil, worldX, worldY)
								hGlobal.event:event("Event_TDUnitActived", w, 1, nil)
								hGlobal.O:replace("__WM__TargetOperatePanel",nil)
								hGlobal.O:replace("__WM__MoveOperatePanel",nil)
								
								--刷新英雄头像
								hGlobal.event:event("LocalEvent_PlayerChooseHero", nil)
							end
						end
					elseif ((oUnit.data.type == hVar.UNIT_TYPE.TOWER) or (oUnit.data.type == hVar.UNIT_TYPE.BUILDING) or (oUnit.data.type == hVar.UNIT_TYPE.NPC_TALK) or (oUnit.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE)) and (t.data.type == hVar.UNIT_TYPE.UNIT) then --上次选中塔、建筑、对话NPC，本次选中敌方单位
						--geyachao: 操作优化，点击小兵，取消对之前选中塔的选中
						p:focusunit(nil, "worldmap")
						hGlobal.event:event("LocalEvent_HitOnTarget", w, nil, worldX,worldY)
						hGlobal.event:event("Event_TDUnitActived", w, 1, nil)
						hGlobal.O:replace("__WM__TargetOperatePanel",nil)
						hGlobal.O:replace("__WM__MoveOperatePanel",nil)
					end
				else --上次没选中单位
					--local isTower = hVar.tab_unit[t.data.id].isTower or 0 --是否为塔
					if ((t.data.type == hVar.UNIT_TYPE.TOWER) or (t.data.type == hVar.UNIT_TYPE.BUILDING) or (t.data.type == hVar.UNIT_TYPE.NPC_TALK) or (t.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE)) then --本次选中的为塔、建筑、对话NPC
						p:focusunit(t, "worldmap")
						hGlobal.event:event("LocalEvent_HitOnTarget",w,t,worldX,worldY)
						--hGlobal.event:event("Event_BattlefieldUnitActived",w,1, t)
						hGlobal.event:event("Event_TDUnitActived",w,1, t)
					elseif (t:getowner() == oPlayerMe) and (t.data.type == hVar.UNIT_TYPE.HERO) then --本次选中的是自己操控的英雄
						p:focusunit(t, "worldmap")
						hGlobal.event:event("LocalEvent_HitOnTarget",w,t,worldX,worldY)
						--hGlobal.event:event("Event_BattlefieldUnitActived",w,1, t)
						hGlobal.event:event("Event_TDUnitActived",w, 1, t)
						--刷新英雄头像
						for i = 1, #oPlayerMe.heros, 1 do
							local oHero = oPlayerMe.heros[i]
							if oHero then
								local tt = oHero:getunit()
								if (tt == t) then
									hGlobal.event:event("LocalEvent_PlayerChooseHero", oHero)
								end
							end
						end
						
						--存储主动选中的英雄单位
						w.data.activeSelectedUnit = t
					end
				end
				
				
			end
			
			--------------------------------------------------------
			--处理本次没点到角色
			local t = __WorldDownTarget
			__WorldDownTarget = nil
			if (t == nil) then
				--print("触发事件:TOUCH_UP")
				--print("t = " .. (t and t.data.name or tostring(t)))
				
				--geyachao: 新流程: 移动
				local oUnit = oPlayerMe:getfocusunit() --当前旋中的角色
				if (oUnit) then
					--local UisTower = hVar.tab_unit[oUnit.data.id].isTower or 0 --当前旋中的角色是否为塔
					if (oUnit:getowner() == oPlayerMe) and (oUnit.data.type == hVar.UNIT_TYPE.HERO) then --自己操控的玩家、英雄
						--英雄试图移动到点击的地点
						--[[
						--检测该地点是否可以到达
						local waypoint = xlCha_MoveToGrid(oUnit.handle._c, worldX / 24, worldY / 24, 0, nil)
						
						--两次的格子是同一个
						local nIsSameGrid = 0 --两次的格子是同一个
						local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --英雄的坐标
						local hero_gridX, hero_gridY = w:xy2grid(hero_x, hero_y)
						if (hero_gridX == gridX) and (hero_gridY == gridY) then
							nIsSameGrid = 1
						end
						]]
						
						--空中单位，任何点都能到达
						--if (nIsSameGrid == 0) and (waypoint[0] == 0) and (oUnit:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_GROUND) then --如果寻路失败，那么提示该点不能到达
						--	--删除移动的箭头特效
						--	if (oUnit.data.JianTouEffect ~= 0) then
						--		oUnit.data.JianTouEffect:del()
						--		oUnit.data.JianTouEffect = 0
						--	end
						--	
						--	--删除攻击箭头的特效
						--	if (oUnit.data.AttackEffect ~= 0) then
						--		oUnit.data.AttackEffect:del()
						--		oUnit.data.AttackEffect = 0
						--	end
						--	
						--	--创建不能移动的箭头特效
						--	oUnit.data.JianTouEffect = w:addeffect(418, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y
						--	--0.8秒后删除自身
						--	local delay = CCDelayTime:create(0.8)
						--	local node = oUnit.data.JianTouEffect.handle._n --cocos对象
						--	local actCall = CCCallFunc:create(function(ctrl)
						--		oUnit.data.JianTouEffect:del()
						--		oUnit.data.JianTouEffect = 0
						--	end)
						--	local actSeq = CCSequence:createWithTwoActions(delay, actCall)
						--	node:runAction(actSeq)
						--else --该点可以到达，角色移动到该点
							--geyachao: 本地提前创建动画表现移动（收到指令才真正执行移动操作）
							--删除移动的箭头特效
							if (oUnit.data.JianTouEffect ~= 0) then
								oUnit.data.JianTouEffect:del()
								oUnit.data.JianTouEffect = 0
							end
							
							--删除攻击箭头的特效
							if (oUnit.data.AttackEffect ~= 0) then
								oUnit.data.AttackEffect:del()
								oUnit.data.AttackEffect = 0
							end
							
							--创建箭头特效
							local jiantouEff = w:addeffect(1, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y
							oUnit.data.JianTouEffect = jiantouEff
							--0.8秒后删除自身
							local delay = CCDelayTime:create(0.8)
							local node = oUnit.data.JianTouEffect.handle._n --cocos对象
							local actCall = CCCallFunc:create(function(ctrl)
								jiantouEff:del()
								oUnit.data.JianTouEffect = 0
							end)
							local actSeq = CCSequence:createWithTwoActions(delay, actCall)
							node:runAction(actSeq)
							
							--geyachao: 改为发送指令-移动到目标点
							--print("改为发送指令-移动到目标点")
							hApi.AddCommand(hVar.Operation.Move, oUnit:getworldI(), oUnit:getworldC(), worldX, worldY, 0, 0, 0, 0, 0, 0)
							
							--geyachao: 客户端提前操作，取消对之前选中英雄的选中
							if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
								oPlayerMe:focusunit(nil, "worldmap")
								hGlobal.event:event("LocalEvent_HitOnTarget", w, nil, worldX, worldY)
								hGlobal.event:event("Event_TDUnitActived", w, 1, nil)
								hGlobal.O:replace("__WM__TargetOperatePanel",nil)
								hGlobal.O:replace("__WM__MoveOperatePanel",nil)
								
								--刷新英雄头像
								hGlobal.event:event("LocalEvent_PlayerChooseHero", nil)
							end
						--end
					elseif ((oUnit.data.type == hVar.UNIT_TYPE.TOWER) or (oUnit.data.type == hVar.UNIT_TYPE.BUILDING) or (oUnit.data.type == hVar.UNIT_TYPE.NPC_TALK) or (oUnit.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE) ) then --本次选中的为塔、建筑、对话NPC
						--geyachao: 操作优化，点击完地面，取消对之前选中塔的选中
						p:focusunit(nil, "worldmap")
						hGlobal.event:event("LocalEvent_HitOnTarget", w, nil, worldX,worldY)
						hGlobal.event:event("Event_TDUnitActived", w, 1, nil)
						hGlobal.O:replace("__WM__TargetOperatePanel",nil)
						hGlobal.O:replace("__WM__MoveOperatePanel",nil)
						
						--触发事件: 操作面板关闭
						hGlobal.event:event("LocalEvent_OperationPanelClosed", "click_close")
					end
					--hGlobal.event:event("LocalEvent_HitOnTarget", w, nil, worldX,worldY)
				end
				
				--print("__WorldDownTarget = " .. (__WorldDownTarget and __WorldDownTarget.data.name or tostring(__WorldDownTarget)))
				hGlobal.event:event("LocalEvent_TouchOnWorld", w, worldX, worldY)
				
				return hVar.RESULT_SUCESS
			end
		end
	elseif w.data.type=="town" then
		--if nLocalOperate==hVar.LOCAL_OPERATE_TYPE.TOUCH_DOWN then
		if nLocalOperate == 2 then
			local t = w:hit2unit(worldX,worldY,"town_down")
			if t and t.data.IsDead==1 then
				t = nil
			end
			if t~=nil then
				hGlobal.event:event("LocalEvent_HitOnTarget",w,t,worldX,worldY)
				return hVar.RESULT_SUCESS
			end
		end
	elseif w.data.type=="battlefield" then
		--战场中只有这种情况需要挡掉
		local opr = p.localoperate:top()
		if opr and opr.id==hVar.OPERATE_TYPE.OB_MODE then
			return
		end
		--战场的触摸部分完全转入脚本UI中处理
		if nLocalOperate==hVar.LOCAL_OPERATE_TYPE.TOUCH_UP then
			return hGlobal.event:event("LocalEvent_TouchUp_BF",w,gridX,gridY,worldX,worldY)
		elseif nLocalOperate==hVar.LOCAL_OPERATE_TYPE.TOUCH_MOVE then
			return hGlobal.event:event("LocalEvent_TouchMove_BF",w,gridX,gridY,worldX,worldY)
		elseif nLocalOperate==hVar.LOCAL_OPERATE_TYPE.TOUCH_DOWN then
			return hGlobal.event:event("LocalEvent_TouchDown_BF",w,gridX,gridY,worldX,worldY)
		end
	end
	return hVar.RESULT_FAIL
end

--监听本地操作面板关闭事件，继续选中上一次的英雄单位
hGlobal.event:listen("LocalEvent_OperationPanelClosed", "__OperationPanelClosed", function(strType)
	--print("LocalEvent_OperationPanelClosed", strType)
	local w = hGlobal.WORLD.LastWorldMap
	
	if w then
		if (hVar.OP_LASTING_MODE ~= 0) then --持续选中模式
			local t = w.data.activeSelectedUnit --主动选中的英雄单位
			local oPlayerMe = w:GetPlayerMe() --我的玩家对象
			if t and (t ~= 0) then
				if (t:getowner() == oPlayerMe) and (t.data.type == hVar.UNIT_TYPE.HERO) then --本次选中的是自己操控的英雄
					local worldX, worldY = hApi.chaGetPos(t.handle) --位置
					oPlayerMe:focusunit(t, "worldmap")
					hGlobal.event:event("LocalEvent_HitOnTarget",w,t,worldX,worldY)
					--hGlobal.event:event("Event_BattlefieldUnitActived",w,1, t)
					hGlobal.event:event("Event_TDUnitActived",w, 1, t)
					
					--刷新英雄头像
					for i = 1, #oPlayerMe.heros, 1 do
						local oHero = oPlayerMe.heros[i]
						if oHero then
							local tt = oHero:getunit()
							if (tt == t) then
								hGlobal.event:event("LocalEvent_PlayerChooseHero", oHero)
							end
						end
					end
					
					--存储主动选中的英雄单位
					w.data.activeSelectedUnit = t
				end
			end
		end
	end
end)

--将英雄进行排序
_hp.sortherobyindex = function(self,tHero)
	table.sort(tHero,function(a,b)
		return a[2]<b[2]
	end)
	local heros = self.heros
	local cHero = {}
	local tIndex = {}
	for i = 1,#tHero do
		tIndex[tHero[i][1]] = 1
	end
	if #heros>0 then
		for i = 1,#heros do
			if tIndex[heros[i]]~=1 then
				cHero[#cHero+1] = heros[i]
			end
		end
		for i = #heros,1,-1 do
			heros[i] = nil
		end
	end
	for i = 1,#tHero do
		heros[#heros+1] = tHero[i][1]
		tHero[i][1].data.LocalIndex = #heros
	end
	for i = 1,#cHero do
		heros[#heros+1] = cHero[i]
		cHero[i].data.LocalIndex = #heros
	end
end

--hGlobal.event:listen("LocalEvent_OperationPanelClosed", "", function(str)
--	print("LocalEvent_OperationPanelClosed", str)
--end)

--监听虚拟摇杆事件
hGlobal.event:listen("LocalEvent_VitrualControllerUpdate", "__", function(strEventType, obj, directionX, directionY, distance)
	--print("LocalEvent_VitrualControllerUpdate", strEventType, obj, directionX, directionY, distance)
	local world = hGlobal.WORLD.LastWorldMap
	if world and (world.data.keypadEnabled == true) then --允许响应事件
		local me = world:GetPlayerMe()
		if me then
			local heros = me.heros
			if heros then
				local oHero = heros[1]
				if oHero then
					local oUnit = oHero:getunit()
					if oUnit then
						if (oUnit.data.IsDead ~= 1) then --活着的单位
							--角色不能在眩晕(滑行)、不在僵直中、不在混乱中、不在沉睡中
							if (oUnit.attr.stun_stack == 0) and (oUnit:getAIState() ~= hVar.UNIT_AI_STATE.CAST_STATIC) and (oUnit.attr.suffer_chaos_stack == 0) and (oUnit.attr.suffer_sleep_stack == 0) then
								if (strEventType == "begin") then
									--触发移动到达事件
									hGlobal.event:event("Event_UnitArrive_TD", oUnit, 0, 0)
									
									--停止移动
									hApi.UnitStop_TD(oUnit)
								elseif (strEventType == "move") then
									local fangle = math.atan(directionY / directionX)--弧度制
									local angle = fangle * 180 / math.pi --角度制
									
									if (directionX < 0) then
										angle = angle + 180
									end
									
									--0~360度
									if (angle < 0) then
										angle = angle + 360
									end
									
									if (angle > 360) then
										angle = angle - 360
									end
									--print(angle)
									
									--转32方向
									local N = hVar.OPTIONS.VIRTUAL_CONTROL_DIRNUM
									local DIV = 360 / N
									local degree = math.floor((angle + DIV/2) / DIV)
									if (degree == N) then
										degree = 0
									end
									local partAngle = degree * DIV
									--print("partAngle=", partAngle)
									angle = partAngle
									local fpartAngle = partAngle * math.pi / 180 --弧度制
									
									--发起移动(到指定地点)(英雄计算障碍)
									local ux, uy = hApi.chaGetPos(oUnit.handle) --位置
									--xlClearFogByPoint(ux,uy)
									local tox, toy = ux + math.cos(fpartAngle) * hVar.AREA_EDGE, uy - math.sin(fpartAngle) * hVar.AREA_EDGE
									
									--检测是否到地图的边界
									--左边界
									if (tox < world.data.rangeL) then
										tox = world.data.rangeL
									end
									--右边界
									if (tox > world.data.rangeR) then
										tox = world.data.rangeR
									end
									--上边界
									if (toy < world.data.rangeU) then
										toy = world.data.rangeU
									end
									--下边界
									if (toy > world.data.rangeD) then
										toy = world.data.rangeD
									end
									
									--hApi.UnitMoveToPoint_TD(oUnit, tox, toy, true)
									
									--发起移动(到指定地点)(英雄计算障碍)
									--检测两点之间是否有障碍
									local IsBolck = hApi.IsPathBlock(ux, uy, tox, toy)
									local result = xlScene_IsGridBlock(g_world, tox / 24, toy / 24) --某个坐标是否是障碍
									if (IsBolck == 1) or (result == 1) or (hApi.IsPosInWater(tox, toy) == 1) then
										--前面是障碍，无法移动了
										--print("TOUCH 仍然无法移动", angle, tox, toy)
										--检测在x, y坐标轴上的位移分量
										local delta_vx = math.cos(fpartAngle) * hVar.AREA_EDGE / 6
										local delta_vy = -math.sin(fpartAngle) * hVar.AREA_EDGE / 6
										--print(delta_vx, delta_vy)
										if ((math.abs(delta_vx) < hVar.AREA_EDGE / 24)) then
											delta_vx = 0
										end
										if ((math.abs(delta_vy) < hVar.AREA_EDGE / 24)) then
											delta_vy = 0
										end
										
										--x的分量更大，优先往x分量位移
										if ((math.abs(delta_vx)) >= (math.abs(delta_vy))) then
											--(1/6)(分量x)
											tox, toy = ux + delta_vx, uy + 0
											--print("x的分量更大，优先往x分量位移")
											local IsBolck = hApi.IsPathBlock(ux, uy, tox, toy)
											local result = xlScene_IsGridBlock(g_world, tox / 24, toy / 24) --某个坐标是否是障碍
											if (IsBolck == 1) or (result == 1) or (hApi.IsPosInWater(tox, toy) == 1) then
												--尝试y分量
												--(1/6)(分量y)
												tox, toy = ux + 0, uy + delta_vy
												--print("尝试y分量")
												local IsBolck = hApi.IsPathBlock(ux, uy, tox, toy)
												local result = xlScene_IsGridBlock(g_world, tox / 24, toy / 24) --某个坐标是否是障碍
												if (delta_vy <= 0) or (IsBolck == 1) or (result == 1) or (hApi.IsPosInWater(tox, toy) == 1) then
													--真的无法移动了
													--单位转向到目标方向
													--print("真的无法移动了x")
													if (tostring(angle) ~= "-1.#IND") then
														if (oUnit.data.facing ~= angle) then
															--print("x单位转向到目标方向", angle)
															hApi.ChaSetFacing(oUnit.handle, angle) --转向
															oUnit.data.facing = angle
															
															--tank: 同步更新绑定的单位的位置（炮口）
															if (oUnit.data.bind_unit ~= 0) then
																if (oUnit.data.bind_unit:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_unit.handle, angle)
																	oUnit.data.bind_unit.data.facing = angle
																end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯光照）
															if (oUnit.data.bind_light ~= 0) then
																--if (oUnit.data.bind_light:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_light.handle, angle)
																	oUnit.data.bind_light.data.facing = angle
																--end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯轮子）
															if (oUnit.data.bind_wheel ~= 0) then
																--if (oUnit.data.bind_wheel:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_wheel.handle, angle)
																	oUnit.data.bind_wheel.data.facing = angle
																--end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯影子）
															if (oUnit.data.bind_shadow ~= 0) then
																--if (oUnit.data.bind_shadow:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_shadow.handle, angle)
																	oUnit.data.bind_shadow.data.facing = angle
																--end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯能量圈）
															if (oUnit.data.bind_energy ~= 0) then
																--if (oUnit.data.bind_energy:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_energy.handle, angle)
																	oUnit.data.bind_energy.data.facing = angle
																--end
															end
															
															--tank: 同步更新绑定的单位的位置（机枪）
															if (oUnit.data.bind_weapon ~= 0) then
																--if (oUnit.data.bind_weapon:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																if (world.data.weapon_attack_state == 0) then
																	--print(world:gametime() - oUnit.data.bind_weapon.attr.last_attack_time)
																	if ((world:gametime() - oUnit.data.bind_weapon.attr.last_attack_time) > hVar.ROLE_TANKWEAPON_SYNCTIME) then --机枪1秒后才和车身同步
																		hApi.ChaSetFacing(oUnit.data.bind_weapon.handle, angle)
																		oUnit.data.bind_weapon.data.facing = angle
																	end
																end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯）
															if (oUnit.data.bind_lamp ~= 0) then
																--if (oUnit.data.bind_lamp:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_lamp.handle, angle)
																	oUnit.data.bind_lamp.data.facing = angle
																--end
															end
														end
													end
													
													return
												end
											end
										else
											--y的分量更大，优先往y分量位移
											--(1/6)(分量y)
											tox, toy = ux + 0, uy + delta_vy
											--print("y的分量更大，优先往y分量位移")
											local IsBolck = hApi.IsPathBlock(ux, uy, tox, toy)
											local result = xlScene_IsGridBlock(g_world, tox / 24, toy / 24) --某个坐标是否是障碍
											if (IsBolck == 1) or (result == 1) or (hApi.IsPosInWater(tox, toy) == 1) then
												--尝试x分量
												--(1/3)(分量x)
												tox, toy = ux + delta_vx, uy + 0
												--print("再尝试x分量")
												local IsBolck = hApi.IsPathBlock(ux, uy, tox, toy)
												local result = xlScene_IsGridBlock(g_world, tox / 24, toy / 24) --某个坐标是否是障碍
												if (delta_vx <= 0) or (IsBolck == 1) or (result == 1) or (hApi.IsPosInWater(tox, toy) == 1) then
													--真的无法移动了
													--print("真的无法移动了y")
													--单位转向到目标方向
													if (tostring(angle) ~= "-1.#IND") then
														if (oUnit.data.facing ~= angle) then
															hApi.ChaSetFacing(oUnit.handle, angle) --转向
															oUnit.data.facing = angle
															--print("y单位转向到目标方向", angle)
															
															--tank: 同步更新绑定的单位的位置（炮口）
															if (oUnit.data.bind_unit ~= 0) then
																if (oUnit.data.bind_unit:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_unit.handle, angle)
																	oUnit.data.bind_unit.data.facing = angle
																end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯光照）
															if (oUnit.data.bind_light ~= 0) then
																--if (oUnit.data.bind_light:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_light.handle, angle)
																	oUnit.data.bind_light.data.facing = angle
																--end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯轮子）
															if (oUnit.data.bind_wheel ~= 0) then
																--if (oUnit.data.bind_wheel:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_wheel.handle, angle)
																	oUnit.data.bind_wheel.data.facing = angle
																--end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯影子）
															if (oUnit.data.bind_shadow ~= 0) then
																--if (oUnit.data.bind_shadow:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_shadow.handle, angle)
																	oUnit.data.bind_shadow.data.facing = angle
																--end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯能量圈）
															if (oUnit.data.bind_energy ~= 0) then
																--if (oUnit.data.bind_energy:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_energy.handle, angle)
																	oUnit.data.bind_energy.data.facing = angle
																--end
															end
															
															--tank: 同步更新绑定的单位的位置（机枪）
															if (oUnit.data.bind_weapon ~= 0) then
																--if (oUnit.data.bind_weapon:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																if (world.data.weapon_attack_state == 0) then
																	--print(world:gametime() - oUnit.data.bind_weapon.attr.last_attack_time)
																	if ((world:gametime() - oUnit.data.bind_weapon.attr.last_attack_time) > hVar.ROLE_TANKWEAPON_SYNCTIME) then --机枪1秒后才和车身同步
																		hApi.ChaSetFacing(oUnit.data.bind_weapon.handle, angle)
																		oUnit.data.bind_weapon.data.facing = angle
																	end
																end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯）
															if (oUnit.data.bind_lamp ~= 0) then
																--if (oUnit.data.bind_lamp:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_lamp.handle, angle)
																	oUnit.data.bind_lamp.data.facing = angle
																--end
															end
														end
													end
													
													return
												end
											end
										end
									end
									
									--设置角色AI状态
									oUnit:setAIState(hVar.UNIT_AI_STATE.MOVE)
									--print("设置角色AI状态")
									
									--移动到达(不寻路)
									local bNoPlayMoveAmin = false
									if (oUnit.attr.isInPoseAttack == 1) then --是否在播放攻击动作（摇杆时不播走路动作）
										bNoPlayMoveAmin = true
									end
									hApi.UnitMoveToPoint_TD(oUnit, tox, toy, false, nil, bNoPlayMoveAmin, angle)
									
									--如果是在主基地，标记主基地战车的坐标
									if (world.data.map == hVar.MainBase) then
										hGlobal.LocalPlayer.data.mainbasePosX = ux
										hGlobal.LocalPlayer.data.mainbasePosY = uy
										hGlobal.LocalPlayer.data.mainbaseFacing = angle
									end
								elseif (strEventType == "end") then
									--触发移动到达事件
									hGlobal.event:event("Event_UnitArrive_TD", oUnit, 0, 0)
									
									--停止移动
									hApi.UnitStop_TD(oUnit)
								end
							end
						end
					end
				end
			end
		end
	end
end)

--监听按键事件
local WASD2DirT =
{
	["----"] = "end", --stop
	["W---"] = 90,
	["-A--"] = 180,
	["--S-"] = 270,
	["---D"] = 0,
	["WA--"] = 135,
	["W-S-"] = "end", --stop
	["W--D"] = 45,
	["-AS-"] = 225,
	["-A-D"] = "end", --stop
	["--SD"] = 315,
	["WAS-"] = 180,
	["WA-D"] = 90,
	["W-SD"] = 0,
	["-ASD"] = 270,
	["WASD"] = "end", --stop
}
--监听按键事件
hGlobal.event:listen("LocalEvent_KeypadEvent", "__", function(strKey)
	local world = hGlobal.WORLD.LastWorldMap
	if world and (world.data.keypadEnabled == true) then --允许响应事件
		local me = world:GetPlayerMe()
		if me then
			local heros = me.heros
			if heros then
				local oHero = heros[1]
				if oHero then
					local oUnit = oHero:getunit()
					if oUnit then
						if (oUnit.data.IsDead ~= 1) then --活着的单位
							--角色不能在眩晕(滑行)、不在僵直中、不在混乱中、不在沉睡中
							if (oUnit.attr.stun_stack == 0) and (oUnit:getAIState() ~= hVar.UNIT_AI_STATE.CAST_STATIC) and (oUnit.attr.suffer_chaos_stack == 0) and (oUnit.attr.suffer_sleep_stack == 0) then
								local angle = WASD2DirT[strKey]
								--print(angle)
								if (angle == "end") then
									--触发移动到达事件
									hGlobal.event:event("Event_UnitArrive_TD", oUnit, 0, 0)
									
									--停止移动
									hApi.UnitStop_TD(oUnit)
								else
									local fpartAngle = angle * math.pi / 180 --弧度制
									
									--发起移动(到指定地点)(英雄计算障碍)
									--(1/6)
									local ux, uy = hApi.chaGetPos(oUnit.handle) --位置
									--xlClearFogByPoint(ux,uy)
									local tox, toy = ux + math.cos(fpartAngle) * hVar.AREA_EDGE / 6, uy - math.sin(fpartAngle) * hVar.AREA_EDGE / 6
									
									--检测是否到地图的边界
									--左边界
									if (tox < world.data.rangeL) then
										tox = world.data.rangeL
									end
									--右边界
									if (tox > world.data.rangeR) then
										tox = world.data.rangeR
									end
									--上边界
									if (toy < world.data.rangeU) then
										toy = world.data.rangeU
									end
									--下边界
									if (toy > world.data.rangeD) then
										toy = world.data.rangeD
									end
									
									--hApi.UnitMoveToPoint_TD(oUnit, tox, toy, true)
									
									--发起移动(到指定地点)(英雄计算障碍)
									--检测两点之间是否有障碍
									local IsBolck = hApi.IsPathBlock(ux, uy, tox, toy)
									local result = xlScene_IsGridBlock(g_world, tox / 24, toy / 24) --某个坐标是否是障碍
									if (IsBolck == 1) or (result == 1) or (hApi.IsPosInWater(tox, toy) == 1) then
										--前面是障碍，无法移动了
										--print("WASD 仍然无法移动", angle, tox, toy)
										--检测在x, y坐标轴上的位移分量
										local delta_vx = math.cos(fpartAngle) * hVar.AREA_EDGE / 6
										local delta_vy = -math.sin(fpartAngle) * hVar.AREA_EDGE / 6
										--print(delta_vx, delta_vy)
										if ((math.abs(delta_vx) < hVar.AREA_EDGE / 24)) then
											delta_vx = 0
										end
										if ((math.abs(delta_vy) < hVar.AREA_EDGE / 24)) then
											delta_vy = 0
										end
										
										--x的分量更大，优先往x分量位移
										if ((math.abs(delta_vx)) >= (math.abs(delta_vy))) then
											--(1/6)(分量x)
											tox, toy = ux + delta_vx, uy + 0
											--print("x的分量更大，优先往x分量位移")
											local IsBolck = hApi.IsPathBlock(ux, uy, tox, toy)
											local result = xlScene_IsGridBlock(g_world, tox / 24, toy / 24) --某个坐标是否是障碍
											if (IsBolck == 1) or (result == 1) or (hApi.IsPosInWater(tox, toy) == 1) then
												--尝试y分量
												--(1/6)(分量y)
												tox, toy = ux + 0, uy + delta_vy
												--print("尝试y分量")
												local IsBolck = hApi.IsPathBlock(ux, uy, tox, toy)
												local result = xlScene_IsGridBlock(g_world, tox / 24, toy / 24) --某个坐标是否是障碍
												if (delta_vy <= 0) or (IsBolck == 1) or (result == 1) or (hApi.IsPosInWater(tox, toy) == 1) then
													--真的无法移动了
													--单位转向到目标方向
													--print("真的无法移动了x")
													if (tostring(angle) ~= "-1.#IND") then
														if (oUnit.data.facing ~= angle) then
															--print("x单位转向到目标方向", angle)
															hApi.ChaSetFacing(oUnit.handle, angle) --转向
															oUnit.data.facing = angle
															
															--tank: 同步更新绑定的单位的位置（炮口）
															if (oUnit.data.bind_unit ~= 0) then
																if (oUnit.data.bind_unit:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_unit.handle, angle)
																	oUnit.data.bind_unit.data.facing = angle
																end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯光照）
															if (oUnit.data.bind_light ~= 0) then
																--if (oUnit.data.bind_light:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_light.handle, angle)
																	oUnit.data.bind_light.data.facing = angle
																--end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯轮子）
															if (oUnit.data.bind_wheel ~= 0) then
																--if (oUnit.data.bind_wheel:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_wheel.handle, angle)
																	oUnit.data.bind_wheel.data.facing = angle
																--end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯影子）
															if (oUnit.data.bind_shadow ~= 0) then
																--if (oUnit.data.bind_shadow:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_shadow.handle, angle)
																	oUnit.data.bind_shadow.data.facing = angle
																--end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯能量圈）
															if (oUnit.data.bind_energy ~= 0) then
																--if (oUnit.data.bind_energy:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_energy.handle, angle)
																	oUnit.data.bind_energy.data.facing = angle
																--end
															end
															
															--tank: 同步更新绑定的单位的位置（机枪）
															if (oUnit.data.bind_weapon ~= 0) then
																--if (oUnit.data.bind_weapon:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																if (world.data.weapon_attack_state == 0) then
																	--print(world:gametime() - oUnit.data.bind_weapon.attr.last_attack_time)
																	if ((world:gametime() - oUnit.data.bind_weapon.attr.last_attack_time) > hVar.ROLE_TANKWEAPON_SYNCTIME) then --机枪1秒后才和车身同步
																		hApi.ChaSetFacing(oUnit.data.bind_weapon.handle, angle)
																		oUnit.data.bind_weapon.data.facing = angle
																	end
																end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯）
															if (oUnit.data.bind_lamp ~= 0) then
																--if (oUnit.data.bind_lamp:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_lamp.handle, angle)
																	oUnit.data.bind_lamp.data.facing = angle
																--end
															end
														end
													end
													
													return
												end
											end
										else
											--y的分量更大，优先往y分量位移
											--(1/6)(分量y)
											tox, toy = ux + 0, uy + delta_vy
											--print("y的分量更大，优先往y分量位移")
											local IsBolck = hApi.IsPathBlock(ux, uy, tox, toy)
											local result = xlScene_IsGridBlock(g_world, tox / 24, toy / 24) --某个坐标是否是障碍
											if (IsBolck == 1) or (result == 1) or (hApi.IsPosInWater(tox, toy) == 1) then
												--尝试x分量
												--(1/3)(分量x)
												tox, toy = ux + delta_vx, uy + 0
												--print("再尝试x分量")
												local IsBolck = hApi.IsPathBlock(ux, uy, tox, toy)
												local result = xlScene_IsGridBlock(g_world, tox / 24, toy / 24) --某个坐标是否是障碍
												if (delta_vx <= 0) or (IsBolck == 1) or (result == 1) or (hApi.IsPosInWater(tox, toy) == 1) then
													--真的无法移动了
													--print("真的无法移动了y")
													--单位转向到目标方向
													if (tostring(angle) ~= "-1.#IND") then
														if (oUnit.data.facing ~= angle) then
															hApi.ChaSetFacing(oUnit.handle, angle) --转向
															oUnit.data.facing = angle
															--print("y单位转向到目标方向", angle)
															
															--tank: 同步更新绑定的单位的位置（炮口）
															if (oUnit.data.bind_unit ~= 0) then
																if (oUnit.data.bind_unit:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_unit.handle, angle)
																	oUnit.data.bind_unit.data.facing = angle
																end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯光照）
															if (oUnit.data.bind_light ~= 0) then
																--if (oUnit.data.bind_light:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_light.handle, angle)
																	oUnit.data.bind_light.data.facing = angle
																--end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯轮子）
															if (oUnit.data.bind_wheel ~= 0) then
																--if (oUnit.data.bind_wheel:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_wheel.handle, angle)
																	oUnit.data.bind_wheel.data.facing = angle
																--end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯影子）
															if (oUnit.data.bind_shadow ~= 0) then
																--if (oUnit.data.bind_shadow:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_shadow.handle, angle)
																	oUnit.data.bind_shadow.data.facing = angle
																--end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯能量圈）
															if (oUnit.data.bind_energy ~= 0) then
																--if (oUnit.data.bind_energy:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_energy.handle, angle)
																	oUnit.data.bind_energy.data.facing = angle
																--end
															end
															
															--tank: 同步更新绑定的单位的位置（机枪）
															if (oUnit.data.bind_weapon ~= 0) then
																--if (oUnit.data.bind_weapon:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																if (world.data.weapon_attack_state == 0) then
																	--print(world:gametime() - oUnit.data.bind_weapon.attr.last_attack_time)
																	if ((world:gametime() - oUnit.data.bind_weapon.attr.last_attack_time) > hVar.ROLE_TANKWEAPON_SYNCTIME) then --机枪1秒后才和车身同步
																		hApi.ChaSetFacing(oUnit.data.bind_weapon.handle, angle)
																		oUnit.data.bind_weapon.data.facing = angle
																	end
																end
															end
															
															--tank: 同步更新绑定的单位的位置（大灯）
															if (oUnit.data.bind_lamp ~= 0) then
																--if (oUnit.data.bind_lamp:getAIState() ~= hVar.UNIT_AI_STATE.ATTACK) then
																	hApi.ChaSetFacing(oUnit.data.bind_lamp.handle, angle)
																	oUnit.data.bind_lamp.data.facing = angle
																--end
															end
														end
													end
													
													return
												end
											end
										end
									end
									
									--设置角色AI状态
									oUnit:setAIState(hVar.UNIT_AI_STATE.MOVE)
									
									--移动到达(不寻路)
									local bNoPlayMoveAmin = false
									if (oUnit.attr.isInPoseAttack == 1) then --是否在播放攻击动作（摇杆时不播走路动作）
										bNoPlayMoveAmin = true
									end
									hApi.UnitMoveToPoint_TD(oUnit, tox, toy, false, nil, bNoPlayMoveAmin, angle)
									
									--如果是在主基地，标记主基地战车的坐标
									if (world.data.map == hVar.MainBase) then
										hGlobal.LocalPlayer.data.mainbasePosX = ux
										hGlobal.LocalPlayer.data.mainbasePosY = uy
										hGlobal.LocalPlayer.data.mainbaseFacing = angle
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