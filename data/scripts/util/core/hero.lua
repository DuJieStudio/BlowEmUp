-----------------------------------
--@ by EFF 2012/12/25
--@游戏中的英雄类
--@玩家的部队以英雄为单位进行组织
hClass.hero = eClass:new("static enum sync")
hClass.hero:sync("local",{"heroUI","talent","talentlv"})		--设置这些表项下面的数据为本地数据，无需保存
hClass.hero:sync("simple",{"item","equipment","AITeam","mastery","masteryActive","HeroTeam","IgnoredTalk"})--设置这些表项下面的数据为简单存储,只会存.n,.i以及1~(t.i or #t)的数据项，且以{1,2,3}的方式存储
local _hh = hClass.hero

----------------------------------------
--默认参数表
local __DefaultParam = {
	name = 0,
	owner = -1,
	id = 0,
	bindU = 0,
	team = 0,
	icon = "MODEL:Default",	--图标
	portrait = "icon/portrait/hero_liubei.png", --半身像
	IsDefeated = 0,
	deadX = 0, --死亡时的x坐标 --geyachao: 新加大地图复活流程，记录死亡的位置
	deadY = 0, --死亡时的y坐标 --geyachao: 新加大地图复活流程，记录死亡的位置
	LocalIndex = 0,		--玩家获得此英雄时，将此数值设置为hGlobal.LocalPlayer.heros[i]的索引
	nDayDefeated = 0,	--上次死亡的日期
	AITeam = 0,		--电脑英雄初始拥有的部队，每天涨兵按照这个基准生长
	AIMode = 0,		--电脑英雄在特定情况下会根据此项决定自己的行为,例如守城英雄必然是hVar.AI_MODE.GUARD
	AIModeBasic = 0,	--从表格中读取出来的基本AI模式，大部分时间等于上面那项，但是在特殊时候上面的那个会被设置成其他，所以这里留个东西设置回来
	AIExtData = 0,
	AIEXtDataChangeAIMode = -1,	--在游戏过程中改变的AI模式，发生变化后则不再从地图中读取
	HeroCard = 0,
	triggerID = 0,	--如果是从地图上创建出来，则此triggerID等于单位的triggerID,复活以后产生的单位会被设置回去
	academySkill = 0,
	------------------------------------
	--下面的东西要记录到存档里面
	------------------------------------
	ex_attrPoint = 0,	--额外的属性点数 随着等级提升增加
	ex_attr = 0,
	item = 0,
	equipment = 0,
	ex_skill = 0,		--额外技能(NPC专用)
	talent = 0,		--天赋
	tactics = 0,		--主动战术技能
	skill = 0, --技能 --geyachao: TD里用到
	talentlv = 0,
	deadCount = 0, --死亡的次数 --geyachao: TD里用到
	cardLv = 0,		--英雄卡片等级
	mastery = 0,		--战术精通
	masteryPoint = 0,	--战术技能点数
	masteryActive = 0,	--激活的战术
	HeroTeam = 0,		--超过一个英雄上战场的时候，这里会记录着其他的英雄
	HeroTeamLeader = 0,	--如果英雄处在其他英雄的队伍中，此值会变为目标英雄的ID
	LoadTriggerData = 0,	--如果曾经读取过一次属性，再调用loadtriggerdata时不会生效
	IgnoredTalk = 0,	--如果此项为一张表，那么会忽略自己tgrData中的某些对话{"xxxxx","xxxxx"}
	GameVar = 0,		--地图作者强行设置在此英雄身上的变量
	------------------------------------
	--用来记录改变生命法力值时的生命百分比
	chp = 0,
	cmxhp = 0,
	cmp = 0,
	cmxmp = 0,
	clevel = 0,	--用来记录上一次获得经验时英雄的等级
	cexp = 0,	--用来记录英雄存到卡片里面的经验值
	deploymode = 0,	--阵型(进入小战场时，根据此值选择初始站位)
	playmode = 0,	--用来记录此英雄的游戏模式{0.正常模式,1.英雄无敌模式,2.别人的领地模式}
	exploit = 0,	--领地模式特有功勋
	--addAttrList = 0, --geyachao: 英雄附加的属性集
	activeSkillCDOrigin = 0, --geyachao: 主动技能的原始CD（单位:秒）
	activeSkillCD = 0, --geyachao: 主动技能的CD（单位:秒）
	activeSkillLastCastTime = 0, --geyachao: 主动技能的上次释放的时间（单位:毫秒）
	itemSkillT = 0, --geyachao: 道具主动技能参数
	itemSkillTCache = 0, --geyachao: 道具主动技能缓存参数（一般用于减道具cd，但是此时刚添加单位，还没创建道具技能，所以先缓存）
}

local __CommonAttr = {
	level = 1,	--等级
	exp = 0,	--经验值
	hp = 0,		--当前生命值
	mxhp = 0,	--最大魔法值
	mp = 0,		--当前魔法值
	mxmp = 0,	--最大魔法值
	minAtk = 0,	--最小攻击力
	maxAtk = 0,	--最大攻击力
	star = 1,	--星级
	soulstone = 0,	--拥有多少灵魂碎片
	pvpexp = 0,	--pvp局内升级经验
	pvplv = 0,	--pvp局内升级等级
}
local __HeroicAttr = {
	--这里面是和tab_unit.hero_attr不同的表项
	--英雄属性:{基本属性,每级成长}
	str = 0,	--力量
	con = 0,	--体力
	int = 0,	--智慧
	lea = 0,	--统率*进攻
	led = 0,	--统率*防御
}
local __DefaultAttr = {
	movepoint = hVar.UNIT_DEFAULT_MOVEPOINT,	--行动点数
	hpRecover = 0,					--每日生命恢复 --geyachao: 改为0
	mpRecover = 0,					--每日法力恢复 --geyachao: 改为0
	def = 0,
	move = 0,
	activity = 0,
	hpSteal = 0,	--吸血
	attackHeal = 0,	--攻击回血(主动使用单体#MELEE,#RANGE或普通攻击技能会回血)
	toughness = 0,	--强韧(控制减免)
	eliteDef = 0,	--精英减伤
	meleeDef = 0,	--近战单位减伤
	rangeDef = 0,	--远程单位减伤
}
hVar.HERO_ATTR_KEY = {}		--英雄属性KEY
hApi.ReadParam(__HeroicAttr,nil,hVar.HERO_ATTR_KEY)
hApi.ReadParam(__DefaultAttr,nil,hVar.HERO_ATTR_KEY)
--这些英雄属性会在战场内被覆盖到目标身上
local __UnitAttrKey = {"def","move","activity","hpSteal","attackHeal","toughness","eliteDef","meleeDef","rangeDef"}

--初始化
_hh.init = function(self, p)
	--print(debug.traceback())
	
	self.data = hApi.ReadParam(__DefaultParam,p,rawget(self,"data") or {})
	self.heroUI = {}
	
	local d = self.data
	local a = self.attr
	--拥有者检查
	if type(d.owner)=="table" then
		d.owner = d.owner.data.playerId
	end
	--如果传入了初始单位，那么以此单位作为英雄初始化的id根据
	if p and p.unit and d.id==0 then
		d.id = p.unit.data.id
	end
	d.item = hApi.NumTable(hVar.HERO_BAG_SIZE)		-- 初始化英雄道具表
	d.equipment = hApi.NumTable(hVar.HERO_EQUIP_SIZE)	-- 初始化英雄装备
	d.academySkill = hApi.NumTable(1) -- 初始化英雄的学院技能表（从翰林院学习的技能存放在这里）
	d.ex_attr = hApi.ReadParam(__HeroicAttr,p.ex_Attr,{})	--英雄的额外属性附加点数
	d.cardLv = 1 or p.cardLv
	d.deadCount = 0 --死亡的次数 --geyachao: TD里用到
	d.talent = 0
	d.tactics = 0
	d.skill = 0
	d.HeroTeam = {n=0}		--共同上场的英雄列表
	--d.addAttrList = {} --geyachao: 英雄附加的属性集
	d.activeSkillCDOrigin = 0 --geyachao: 主动技能的原始CD（单位:秒）
	d.activeSkillCD = 0 --geyachao: 主动技能的CD
	d.activeSkillLastCastTime = -math.huge --geyachao: 主动技能的上次释放的时间（单位:毫秒）
	d.itemSkillT = {} --geyachao: 道具主动技能参数
	d.itemSkillTCache = {} --geyachao: 道具主动技能缓存参数（一般用于减道具cd，但是此时刚添加单位，还没创建道具技能，所以先缓存）
	
	hApi.LoadDefaultHeroAttr(self,p)

	--绑定英雄单位
	self:loadbaseattr(p)			--等级星级等基础信息
	--self:loadattr()			--初始化血量等基本信息，这里没有传参数，所以没有刷新装备部分的数据
	self:loadtalent(p.HeroCard)		--加载天赋技能
	self:loadequip(p.HeroCard)		--加载英雄装备
	if p.unit then
		self:bind(p.unit)			--绑定unit，英雄id等数据传给unit,bind之后会调用loadattr()
	else
		--不需要读att了，没必要
		self:loadattr()				--初始化血量等基本信息，这里没有传参数，所以没有刷新装备部分的数据
	end
	
	----与玩家绑定
	--local owner = self:getowner()
	--if owner then
	--	owner.heros[#owner.heros+1] = self
	--	d.LocalIndex = #owner.heros
	--end
	
	--local CreatedOnMapInit = 0
	--if p and rawget(p,"CreatedOnMapInit")==1 then
	--	CreatedOnMapInit = 1
	--end
	--hGlobal.event:call("Event_HeroCreated",oHero,CreatedOnMapInit)
end

_hh.destroy = function(self)
	local _childUI = self.heroUI
	for k in pairs(_childUI) do
		if (k == "btnIcon") then
			--geyachao: 这里加了个非空判断，为什么会是nil？？？
			if _childUI[k].childUI["flag"] then
				_childUI[k].childUI["flag"].destroy = hUI.destroyDefault
			end
		end
		hApi.safeRemoveT(_childUI, k)
	end
	local owner = self:getowner()
	if owner and #owner.heros>0 then
		local owningHero = owner.heros
		for i = 1,#owningHero do
			if owningHero[i]==self then
				owningHero[i] = 0
			end
		end
		hApi.SortTableI(owningHero)
	end
end

--读取默认属性(也会被外面的英雄属性面板调用)
hApi.LoadDefaultHeroAttr = function(self,p)
	local tAttr = rawget(self,"attr") or {}
	hApi.ReadParam(__CommonAttr,nil,tAttr)
	hApi.ReadParam(__DefaultAttr,nil,tAttr)
	hApi.ReadParam(__HeroicAttr,nil,tAttr)
	self.attr = tAttr
	self.__attr = {}	--一禁止修改此表的内容，此为系统记录用
	self.attrW = {}		--每周临时增加的属性，持续一周
	
	local d = self.data
	local a = self.attr
	d.clevel = 0
	d.chp = 100
	d.cmxhp = 100
	d.cmp = 100
	d.cmxmp = 100
	d.cexp = 0
	a.pvpexp = 0
	a.pvplv = 1
	
	local tAttrU
	local tabU = hVar.tab_unit[d.id]
	if tabU then
		--初始化半身像和头像
		d.icon = tabU.icon or d.icon
		d.portrait = tabU.portrait or d.portrait
		if tabU.attr then
			tAttrU = tabU.attr
		end
	end
	--初始化英雄生命魔法
	if tAttrU and tAttrU.hp then
		a.hp = math.max(0,tAttrU.hp)
		a.mxhp = math.max(0,tAttrU.hp)
	elseif p and p.hp then
		a.hp = p.hp
		a.mxhp = p.hp
	else
		a.hp = 0
		a.mxhp = 0
	end
	if tAttrU and tAttrU.mp then
		a.mp = tAttrU.mp
		a.mxmp = tAttrU.mp
	elseif p and p.mp then
		a.mp = p.mp
		a.mxmp = p.mp
	else
		a.mp = 0
		a.mxmp = 0
	end
	--初始化英雄基本单位属性
	if tAttrU then
		if tAttrU.attack then
			a.minAtk = tAttrU.attack[4] or 0		--最小攻击
			a.maxAtk = tAttrU.attack[5] or 0		--最大攻击
		end
		for k,v in pairs(__DefaultAttr)do
			a[k] = tAttrU[k] or v
		end
	end
	
end

--返回功勋值
_hh.getExploit = function(self)
	local d = self.data
	return d.exploit or 0
end

_hh.setExploit = function(self,exp)
	local d = self.data
	d.exploit = exp
end

--增加功勋值
_hh.addExploit = function(self,exp)
	local d = self.data
	self:setExploit(self:getExploit() + exp)
end

--升级后判断装备是否可用
--local __CalculateAllEquipmentAvailable = function(oHero,tempAttr)
--	local e = oHero.data.equipment
--	if type(e)=="table" then
--		for i = 1,#e do
--			local oItem = e[i]
--			if oItem ~= 0 then
--				local c = hApi.CheckItemAvailable(oItem)
--				local a = hApi.IsAttrMeetEquipRequire(oHero, oHero.attr,oItem[hVar.ITEM_DATA_INDEX.ID])
--				if c==a then
--					--一致，啥也不做
--				elseif a==1 then
--					--如果可用，设置可用
--					hApi.SetItemAvailable(oItem,1)
--					if tempAttr then
--						hApi.GetEquipmentAttr(oItem[hVar.ITEM_DATA_INDEX.ID],oItem[hVar.ITEM_DATA_INDEX.SLOT],tempAttr,1)
--					end
--				else
--					--否则设置不可用
--					hApi.SetItemAvailable(oItem,0)
--					if tempAttr then
--						hApi.GetEquipmentAttr(oItem[hVar.ITEM_DATA_INDEX.ID],oItem[hVar.ITEM_DATA_INDEX.SLOT],tempAttr,-1)
--					end
--				end
--			end
--		end
--	end
--end

--是否拥有此英雄的卡片
hApi.IsHaveHeroCard = function(id)
	if Save_PlayerData.herocard then
		for i = 1,#Save_PlayerData.herocard do
			if Save_PlayerData.herocard[i].id==id then
				return hVar.RESULT_SUCESS
			end
		end
	end
	
	return hVar.RESULT_FAIL
end

--根据id获得卡片
hApi.GetHeroCardById = function(id)
	if Save_PlayerData and Save_PlayerData.herocard then
		for i = 1,#Save_PlayerData.herocard do
			if Save_PlayerData.herocard[i].id==id then
				return Save_PlayerData.herocard[i]
			end
		end
	end
end

hApi.GetHeroEquipAttr = function(oHero,tTempAttr,plus)
	plus = plus or 1
	local tEquipment = oHero.data.equipment
	for i = 1,#tEquipment do
		local oItem = tEquipment[i]
		--print("GetHeroEquipAttr", i, "oItem=", oItem)
		if oItem ~= 0 then
			--print(oItem[1], oItem[2], oItem[3], oItem[4], oItem[5], oItem[6], oItem[7], oItem[8])
			if hApi.CheckItemAvailable(oItem)==1 then
				--print("CheckItemAvailable")
				hApi.GetEquipmentAttr(oItem[hVar.ITEM_DATA_INDEX.ID],oItem[hVar.ITEM_DATA_INDEX.SLOT],tTempAttr,plus,oItem[hVar.ITEM_DATA_INDEX.QUALITY],oItem)
			end
		end
	end
	return tTempAttr
end

local __LoadExAttr = function(a,t,plus)
	for k,v in pairs(t)do
		a[k] = a[k] + plus*v
	end
end

local __AttrKeyTab = {"lea","led","str","int","con","mxhp","mxmp"}
local __GetAttrFromTab = function(plus,aTab,rTab)
	for i = 1,#__AttrKeyTab do
		local k = __AttrKeyTab[i]
		if type(aTab[k])=="number" then
			rTab[#rTab+1] = {k,aTab[k]*plus}
		end
	end
end

----------------------------------------------
--重读存档后从英雄卡片初始化英雄身上的道具和装备(新)
--_hh.LoadHeroFromCard = function(self,mode)
--	--geyachao
--	--print("LoadHeroFromCard", self.data.playmode)
--	--无卡片模式不返回任何东西
--	if self.data.playmode==hVar.PLAY_MODE.NO_HERO_CARD then
--		return
--	end
--	local oWorld = hGlobal.WORLD.LastWorldMap
--	local HeroCard = hApi.GetHeroCardById(self.data.id)
--	local IsHaveCard = nil
--	local tempAttr = {}
--	local d = self.data
--	
--	--如果存在合法卡片，则使用卡片中的装备替换身上的
--	if HeroCard then
--		IsHaveCard = 1
--		local CanLoad = 1
--		local IsFirstLoad = 1
--		
--		--mode: "load"、"reload"、"buycard"、
--		--if (mode=="load" or mode=="reload") then
--		--	if d.HeroCard~=1 then
--		--		CanLoad = 0
--		--	end
--		--end
--		
--		--if oWorld and CanLoad==1 then
--		if oWorld and CanLoad==1 then
--			if mode=="buycard" then
--				--买英雄令模式的英雄是个假的，用完就删了，无需记录
--			else
--				--记录一下我已经使用的英雄
--				oWorld.data.HeroCardUsed[self.data.id] = 1
--			end
--			
--			--先除去原本装备的属性加成
--			hApi.GetHeroEquipAttr(self,tempAttr,-1)
--			--调整卡片数据合法性
--			hApi.CheckHeroBagItem(self.data.id)
--			--替换装备数据
--			self:updatebag()
--			--替换为新的装备属性加成
--			hApi.GetHeroEquipAttr(self,tempAttr,1)
--			
--			--读取额外属性加成
--			if type(d.ex_attr)=="table" then
--				__LoadExAttr(self.attr,d.ex_attr,-1)
--				if type(HeroCard.ex_Attr) == "table" then
--					d.ex_attr = HeroCard.ex_Attr
--					__LoadExAttr(self.attr,HeroCard.ex_Attr,1)
--				end
--			end
--			
--			d.ex_attrPoint = HeroCard.ex_AttrPoint
--			--获得所有附加属性
--			if #tempAttr>0 then
--				self:__loadattr(tempAttr)
--			end
--			
--			--self:loadtalent(self:getunit())
--			self:loadtalent(HeroCard)
--		else
--			--非法的话禁止使用此卡片
--			HeroCard = nil
--		end
--	else
--		--非法的话禁止使用此卡片
--		HeroCard = nil
--	end
--
--	return HeroCard,IsHaveCard
--end

_hh.setGameVar = function(self,k,v)
	local d = self.data
	if (v or 0)==0 then
		if type(d.GameVar)=="table" then
			d.GameVar[k] = v
		end
	else
		if type(d.GameVar)~="table" then
			d.GameVar = {}
		end
		d.GameVar[k] = v
	end
end

_hh.getGameVar = function(self,k,v)
	local d = self.data
	if type(d.GameVar)=="table" then
		return d.GameVar[k] or 0
	else
		return 0
	end
end

_hh.setowner = function(self,nOwnerId)
	local d = self.data
	if type(nOwnerId)=="number" and d.owner~=nOwnerId then
		local oldOwner = d.owner
		d.owner = nOwnerId
		local w = hGlobal.WORLD.LastWorldMap
		local oPlayer = hGlobal.player[nOwnerId]
		local oPlayerOld = hGlobal.player[oldOwner]	
		if w then
			oPlayer = w:GetPlayer(nOwnerId)
			oPlayerOld = w:GetPlayer(oldOwner)
		end
		
		if oPlayer and oPlayerOld then
			local heros = oPlayerOld.heros
			local isFind = 0
			for i = 1,#heros do
				if heros[i]==self then
					isFind = 1
				elseif isFind==1 then
					heros[i].data.LocalIndex = i-1
					heros[i-1] = heros[i]
				end
			end
			if isFind==1 then
				heros[#heros] = nil
			end
			oPlayer.heros[#oPlayer.heros+1] = self
			self.data.LocalIndex = #oPlayer.heros
			local oUnit = self:getunit()
			if oUnit then
				oUnit:setowner(nOwnerId)
			end
			hGlobal.event:call("Event_HeroChangeOwner",self,oPlayer,oPlayerOld)
		end
	end
end

_hh.setHp = function(self,val,plus,nMnhp,nMxhp)
	local a = self.attr
	local d = self.data
	if val then
		a.hp = val
	end
	if plus then
		a.hp = a.hp + plus
	end
	if nMnhp then
		nMxhp = nMxhp or a.mxhp
		a.hp = math.max(nMnhp,math.min(a.hp,nMxhp))
	end
	d.chp = a.hp
	d.cmxhp = a.mxhp
	--print("_hh.setHp", val,plus,nMnhp,nMxhp)
end

_hh.setMp = function(self,val,plus,check)
	local a = self.attr
	local d = self.data
	if val then
		a.mp = val
	end
	if plus then
		a.mp = a.mp + plus
	end
	if check then
		a.mp = math.max(check,math.min(a.mp,a.mxmp))
	end
	d.cmp = a.mp
	d.cmxmp = a.mxmp
end

_hh.setHpMpPec = function(self,hpPec,mpPec)
	local a = self.attr
	local d = self.data
	if hpPec then
		a.hp = math.max(1,hApi.floor(a.mxhp*hpPec))
	end
	if mpPec then
		a.mp = math.max(0,hApi.floor(a.mxmp*mpPec))
	end
	d.chp = a.hp
	d.cmxhp = a.mxhp
	d.cmp = a.mp
	d.cmxmp = a.mxmp
end

local __BasicAttr = {"str","int","con","lea","led"}
local __HeroicAttr = {
	--这里面是和tab_unit.hero_attr不同的表项
	--英雄属性:{基本属性,每级成长}
	str = 0,	--力量
	con = 0,	--体力
	int = 0,	--智慧
	lea = 0,	--统率*进攻
	led = 0,	--统率*防御
}

hApi.AddAttrByTab = function(oUnit,tAddAttr)
	local cAttr = oUnit.attr
	local ReloadNewLevelAttr = 0
	for i = 1,#tAddAttr do
		if type(tAddAttr[i])=="table" then
			local typ,num = unpack(tAddAttr[i])
			if typ and num then
				if cAttr[typ] then
					cAttr[typ] = cAttr[typ] + num
					if typ=="level" then
						ReloadNewLevelAttr = 1
					end
				else
					--_DEBUG_MSG("尝试添加未知的属性类型:"..tostring(typ))
				end
			end
		end
	end
	return ReloadNewLevelAttr
end

hApi.LoadBaseAttr = function(oHero)
	local cAttr = oHero.attr
	local bAttr = oHero.__attr
	local tabU = hVar.tab_unit[oHero.data.id]
	if tabU and tabU.hero_attr~=nil then
		local tAttr = tabU.hero_attr
		local hLv = math.max(1,cAttr.level)
		for i = 1,#__BasicAttr do
			local key = __BasicAttr[i]
			cAttr[key] = cAttr[key] - (bAttr[key] or 0)
			--英雄属性:{基本属性,每级成长}
			if type(tAttr[key])=="table" then
				local basicV,plusV = unpack(tAttr[key])
				basicV = basicV or 0
				plusV = plusV or 0
				bAttr[key] = hApi.floor(basicV+plusV*(hLv-1))
			else
				bAttr[key] = 0
			end
			cAttr[key] = cAttr[key] + (bAttr[key] or 0)
		end
	end
end

--等级星级等信息 --zhenkira
_hh.loadbaseattr = function(self, p)
	
	local d = self.data
	local a = self.attr
	local heroId = d.id
	
	--读取卡片经验 zhenkira
	--local HeroCard = hApi.GetHeroCardById(heroId)
	local HeroCard = p.HeroCard
	
	--if HeroCard and HeroCard.talent then
	if HeroCard then
		local ha = HeroCard.attr
		
		d.cexp = ha.exp or 0
		a.exp = ha.exp or 0
		a.level = ha.level or 1
		a.star = ha.star or 1
		a.soulstone = ha.soulstone or 0
	end

	--如果参数中直接设置相关参数，则以设置的为准
	if p.exp and p.exp >= 0 then
		d.cexp = p.exp
		a.exp = p.exp
	end
	if p.level and p.level > 0 then
		a.level = p.level
	end
	if p.star and p.star > 0 then
		a.star = p.star
	end
	if p.soulstone and p.soulstone >= 0 then
		a.soulstone = p.soulstone
	end
end

--附加属性
_hh.__loadattr = function(self, tAddAttr)
	local d = self.data
	--[[
	local addAttrList = d.addAttrList --存储所有附加属性的表
	
	--geyachao: 先把所有附加的属性存起来
	if tAddAttr and addAttrList then
		
		local oUnit = self:getunit() --绑定的单位
		
		--附加属性
		for i = 1, #tAddAttr, 1 do
			if (type(tAddAttr[i]) == "table") then
				--属性类型、值
				local typ, num = unpack(tAddAttr[i])
				--print(typ, num)
				if typ and num then
					--将最终的值存储起来
					if addAttrList[typ] then
						addAttrList[typ] = addAttrList[typ] + num
					else
						addAttrList[typ] = num
					end
					
					--修改英雄单位的属性值
					--单位附加当前值
					if oUnit then
						if (typ == "hp_max") then --血量
							oUnit.attr.hp_max_item = oUnit.attr.hp_max_item + num
							oUnit.attr.hp = oUnit.attr.hp + num
						elseif (typ == "atk") then --攻击力
							oUnit.attr.attack[4] = oUnit.attr.attack[4] + num[1]
							oUnit.attr.attack[5] = oUnit.attr.attack[5] + num[2]
						elseif (typ == "atk_min") then --最小攻击力
							oUnit.attr.attack[4] = oUnit.attr.attack[4] + num
						elseif (typ == "atk_max") then --最大攻击力
							oUnit.attr.attack[5] = oUnit.attr.attack[5] + num
						elseif (typ == "atk_interval") then --攻击间隔（毫秒）
							oUnit.attr.atk_interval_item = oUnit.attr.atk_interval_item + num
						elseif (typ == "atk_speed") then --攻击速度（去百分号后的值）
							oUnit.attr.atk_speed_item = oUnit.attr.atk_speed_item + num
						elseif (typ == "move_speed") then --移动速度
							oUnit.attr.move_speed_item = oUnit.attr.move_speed_item + num
						elseif (typ == "atk_radius") then --攻击范围
							oUnit.attr.atk_radius_item = oUnit.attr.atk_radius_item + num
						elseif (typ == "atk_radius_min") then --攻击范围最小值
							oUnit.attr.atk_radius_min_item = oUnit.attr.atk_radius_min_item + num
						elseif (typ == "def_physic") then --物理防御
							oUnit.attr.def_physic_item = oUnit.attr.def_physic_item + num
						elseif (typ == "def_magic") then --法术防御
							oUnit.attr.def_magic_item = oUnit.attr.def_magic_item + num
						elseif (typ == "dodge_rate") then --闪避几率（去百分号后的值）
							oUnit.attr.dodge_rate_item = oUnit.attr.dodge_rate_item + num
						elseif (typ == "crit_rate") then --暴击几率（去百分号后的值）
							oUnit.attr.crit_rate_item = oUnit.attr.crit_rate_item + num
						elseif (typ == "crit_value") then --暴击倍数（支持小数）
							oUnit.attr.crit_value_item = oUnit.attr.crit_value_item + num
						elseif (typ == "kill_gold") then --击杀获得的金币
							oUnit.attr.kill_gold_item = oUnit.attr.kill_gold_item + num
						elseif (typ == "escape_punish") then --逃怪惩罚
							oUnit.attr.escape_punish_item = oUnit.attr.escape_punish_item + num
						elseif (typ == "hp_restore") then --回血速度（每秒）（支持小数）
							oUnit.attr.hp_restore_item = oUnit.attr.hp_restore_item + num
						elseif (typ == "AI_attribute") then --AI行为（0：被动怪 / 1:主动怪）
							oUnit.attr.AI_attribute_item = oUnit.attr.AI_attribute_item + num
						elseif (typ == "rebirth_time") then --复活时间（毫秒）
							oUnit.attr.rebirth_time_item = oUnit.attr.rebirth_time_item + num
						elseif (typ == "suck_blood_rate") then --吸血率（去百分号后的值）
							oUnit.attr.suck_blood_rate_item = oUnit.attr.suck_blood_rate_item + num
						elseif (typ == "active_skill_cd_delta") then --主动技能冷却时间变化值（毫秒）
							oUnit.attr.active_skill_cd_delta_item = oUnit.attr.active_skill_cd_delta_item + num
						elseif (typ == "passive_skill_cd_delta") then --被动技能冷却时间变化值（毫秒）
							oUnit.attr.passive_skill_cd_delta_item = oUnit.attr.passive_skill_cd_delta_item + num
						elseif (typ == "active_skill_cd_delta_rate") then --主动技能冷却时间变化比例值（去百分号后的值）
							oUnit.attr.active_skill_cd_delta_rate_item = oUnit.attr.active_skill_cd_delta_rate_item + num
						elseif (typ == "passive_skill_cd_delta_rate") then --被动技能冷却时间变化比例值（去百分号后的值）
							oUnit.attr.passive_skill_cd_delta_rate_item = oUnit.attr.passive_skill_cd_delta_rate_item + num
						end
					end
				end
			end
		end
		
		--刷新单位的血条
		if oUnit then
			--更新血条控件
			if oUnit.chaUI["hpBar"] then
				oUnit.chaUI["hpBar"]:setV(oUnit.attr.hp, oUnit:GetHpMax())
			end
			if oUnit.chaUI["numberBar"] then
				oUnit.chaUI["numberBar"]:setText(oUnit.attr.hp .. "/" .. oUnit:GetHpMax())
			end
		end
	end
	]]
	
	local d = self.data
	local cAttr = self.attr
	local bAttr = self.__attr
	
	local hpPerCon = 20		--每点体质增加生命
	local mpPerInt = 1		--每点智力增加魔法
	local atkPerStr = 2		--每点力量增加攻击
	local defPerCon = 0.1		--每点体质增加防御
	
	local hpPec,mpPec = 1,1
	if d.cmxhp>0 then
		hpPec = d.chp/d.cmxhp
	end
	if d.cmxmp>0 then
		mpPec = d.cmp/d.cmxmp
	end
	
	local ReloadNewLevelAttr = 0
	
	--[[
	--清除属性攻击力/生命/魔法附加
	cAttr.mxhp = cAttr.mxhp - hApi.floor(cAttr.con*hpPerCon)
	cAttr.mxmp = cAttr.mxmp - hApi.floor(cAttr.int*mpPerInt)
	--清除属性防御力附加
	cAttr.def = cAttr.def - hApi.floor(cAttr.con*defPerCon)
	
	cAttr.minAtk = cAttr.minAtk - hApi.floor(cAttr.str*atkPerStr)
	cAttr.maxAtk = cAttr.maxAtk - hApi.floor(cAttr.str*atkPerStr)
	
	if tAddAttr and type(tAddAttr)=="table" then
		ReloadNewLevelAttr = hApi.AddAttrByTab(self,tAddAttr)
	end
	
	--等级不同的话，需要重新读取升级数据
	if d.clevel~=cAttr.level then
		d.clevel = cAttr.level
		ReloadNewLevelAttr = 1
	end
	
	if ReloadNewLevelAttr==1 then
		--读取升级数据
		hApi.LoadBaseAttr(self)
	end
	
	--添加属性攻击力/生命/魔法附加
	cAttr.mxhp = cAttr.mxhp + hApi.floor(cAttr.con*hpPerCon)
	cAttr.mxmp = cAttr.mxmp + hApi.floor(cAttr.int*mpPerInt)
	--添加属性防御力附加
	cAttr.def = cAttr.def + hApi.floor(cAttr.con*defPerCon)
	
	cAttr.minAtk = cAttr.minAtk + hApi.floor(cAttr.str*atkPerStr)
	cAttr.maxAtk = cAttr.maxAtk + hApi.floor(cAttr.str*atkPerStr)
	
	cAttr.hp = math.min(cAttr.mxhp,math.max(1,hApi.floor(cAttr.mxhp*hpPec)))
	cAttr.mp = math.min(cAttr.mxmp,math.max(0,hApi.floor(cAttr.mxmp*mpPec)))
	]]
	
	if tAddAttr and type(tAddAttr)=="table" then
		ReloadNewLevelAttr = hApi.AddAttrByTab(self,tAddAttr)
	end
	
	--记录保存的生命血量值
	if d.chp==0 and d.cmxhp==0 then
		d.chp = cAttr.hp
		d.cmxhp = cAttr.mxhp
	end
	if d.cmp==0 and d.cmxmp==0 then
		d.cmp = cAttr.mp
		d.cmxmp = cAttr.mxmp
	end
end

_hh.loadattr = function(self,tAddAttr)
	self:__loadattr(tAddAttr)
	return
	--zhenkira 有问题再改回来
	--return self:loadtalent()
end

local __CheckSkillLevelByAttr = function(oHero,sTab)
	local a = oHero.attr
	local sLv = 0
	if sTab==nil then
		return sLv
	elseif #sTab<=0 then
		return 1
	end
	for i = 1,#sTab do
		local sus = 1
		for k,v in pairs(sTab[i]) do
			if a[k]~=nil and a[k]<v then
				sus = 0
				break
			end
		end
		if sus==1 then
			sLv = i
		else
			break
		end
	end
	return sLv
end

local __TalentRequireAttr = hApi.IndexTable({"lea","led","str","int","con"})
local __IfMeetAttrRequire = function(tAttr,tReq)
	for i = 1,#__TalentRequireAttr do
		if (tAttr[__TalentRequireAttr[i]] or 0)<(tReq[i] or 0) then
			return 0
		end
	end
	return 1
end
hApi.GetHeroTalentLv = function(oHero,id)
	local d = oHero.data
	if type(d.talent)=="table" and type(d.talentlv)=="table" then
		if (d.talentlv[id] or 0)>0 then
			local nUpgradeNum = 0
			for i = 1,#d.talent do
				local v = d.talent[i]
				if v~=0 and v[2] and v[2][1]==id then
					nUpgradeNum = v[1]
					break
				end
			end
			return d.talentlv[id],nUpgradeNum
		end
	end
	return 0,0
end

--获得英雄默认战术技能
hApi.GetHeroTactic = function(heroId, tHero)
	local tactics = {}
		
	if heroId and hVar.tab_unit[heroId] then
		local tabU = hVar.tab_unit[heroId]
		local tabTactic = hVar.tab_unit[heroId].tactics or {}
		local tHeroCard = tHero
		if not tHeroCard then
			tHeroCard = hApi.GetHeroCardById(heroId)
		end
		for idx = 1, hVar.HERO_TACTIC_SIZE do
			local tacticId = 0
			local tacticLv = 0
			if tabTactic[idx] then
				tacticId = tabTactic[idx] or 0
			end
			--目前逻辑写死，每颗星级开放一个技能
			if tacticId > 0 then
				tacticLv = 1
			end
			if tHeroCard and tHeroCard.tactic and tHeroCard.tactic[idx] then
				if tHeroCard.tactic[idx].id == tacticId and tHeroCard.tactic[idx].lv then
					tacticLv = tHeroCard.tactic[idx].lv
				end
			end
			tactics[idx] = {id = tacticId, lv = tacticLv}
		end
	end

	return tactics
end

--加载英雄装备(英雄装备读取到英雄对象上)
_hh.loadequip = function(self, tCard)
	local d = self.data
	if tCard and type(tCard) == "table" then
		for i = 1,#d.equipment do
			hApi.CopyItemFromCardToGameHero(tCard,self,"equip",i)
		end
	end
end

--刷新装备信息（等级提升及加载到角色时）
_hh.refreshequip = function(self, u)
	
	local d = self.data
	
	--检测背包道具合法性，如果等级不满足会设定道具的值(每次调用会根据当前等级进行重算)
	hApi.CheckHeroBagItem(self)
	
	--读取英雄装备的属性，赋值给单位
	local tempAttr = {}
	--替换为新的装备属性加成
	hApi.GetHeroEquipAttr(self, tempAttr, 1)
	u:AttrRecheckItem(tempAttr)
	
	--获得所有附加属性
	if (#tempAttr > 0) then
		self:__loadattr(tempAttr)
	end

	--读取装备技能
	--local tEquipFlag = {}
	--print("d.equipment1")
	for i = 1, #d.equipment, 1 do
		--print("d.equipment2")
		if d.equipment[i]~=0 and type(d.equipment[i])=="table" then
		--local uniqueId = d.equipment[i]
		--print("uniqueId=", uniqueId)
		--local _, item = LuaFindEquipByUniqueId(uniqueId)
		--if (type(item) == "table") then
			--print("d.equipment3")
			local itemID = d.equipment[i][1]
			--print("itemID=", itemID)
			--local itemID = item[1]
			local itemInfo = hVar.tab_item[itemID]
			--if tEquipFlag[itemID]~=1 and itemInfo and hApi.IsAttrMeetEquipRequire(self, self.attr,itemID)==1 then
			if not u:GetEquipState(i) and itemInfo and hApi.IsAttrMeetEquipRequire(self, self.attr,itemID)==1 then
				--print("d.equipment4")
				--tEquipFlag[itemID] = 1
				u:SetEquipState(i, true)
				--技能id列表
				local skillList = {}
				if itemInfo.skillId and type(itemInfo.skillId) == "number" then
					table.insert(skillList, {id = itemInfo.skillId, lv = 1, cd = 1000})
				elseif itemInfo.skillId and type(itemInfo.skillId) == "table" then
					skillList = itemInfo.skillId
				end
				
				for j = 1, #skillList, 1 do
					local id = skillList[j].id
					local lv = skillList[j].lv or 1
					local cd = skillList[j].cd or 1000
					local stackable = skillList[j].stackable or 0 --是否可堆叠（如果能堆叠，人身上的lv会叠上去）
					local skillObj = u:getskill(id)
					local addFlag = false
					--判断是否已经添加过此技能
					if not skillObj then
						addFlag = true
					else
						if skillObj[1] ~= id and skillObj[2] ~= lv and skillObj[5] ~= cd then
							addFlag = true
						end
					end
					
					addFlag = true
					
					if id~=0 and hVar.tab_skill[id] and addFlag then --技能id在tab_skill中存在，并且角色身上还没有添加该技能
						local tabS = hVar.tab_skill[id]
						local castType = tabS.cast_type
						if castType == hVar.CAST_TYPE.AUTO then
							u:learnSkill(id,lv)
						else
							--print("u:addskill:",id, lv,stackable)
							u:addskill(id, lv, nil, nil, stackable, cd, i) --道具技能使用表中填写的堆叠次数(相同道具只会添加1次)
							
							--为角色的技能释放AI规则加上道具的技能
							if (u.attr.skill_AI_sequence ~= 0) then
								table.insert(u.attr.skill_AI_sequence, {weight = 10, skills = {id}})
								--print("u.attr.skill_AI_sequence", id)
								
								--geyachao: 同步日志: 添加道具技能
								if (hVar.IS_SYNC_LOG == 1) then
									local msg = "ItemSkillAdd: u=" .. u.data.id .. ",u_ID=" .. u:getworldC() .. "#skill_AI_sequence=" .. (#u.attr.skill_AI_sequence) .. ",skillId=" .. id .. ", weight=10"
									hApi.SyncLog(msg)
								end
								
								--geyachao: 非同步日志: 添加道具技能
								if (hVar.IS_ASYNC_LOG == 1) then
									local msg = "ItemSkillAdd: u=" .. u.data.name .. ",u_ID=" .. u:getworldC() .. "#skill_AI_sequence=" .. #u.attr.skill_AI_sequence .. ",skillId=" .. id .. ", weight=10" .. "\n" .. debug.traceback()
									hApi.AsyncLog(msg)
								end
							end
						end
					end
				end
			end
		else
			--print("itemID=", "0")
		end
	end
end

--zhenkira 重写loadtalent
_hh.loadtalent = function(self,HeroCard)
	local d = self.data
	local a = self.attr
	local heroId = d.id
	
	d.talent = {}
	d.tactics = {}
	
	--local HeroCard = hApi.GetHeroCardById(heroId)
	if HeroCard then
		if HeroCard.talent then
			for i = 1, #HeroCard.talent do
				local talentObj = HeroCard.talent[i]
				if not talentObj then
					talentObj = {}
				end
				local skillId = talentObj.id or 0
				local skillLv = talentObj.lv or 0
				
				--在拥有英雄卡的情况下，技能等级不得大于英雄等级
				if skillLv > a.level then
					skillLv = a.level
				end
				local skillCD = 100
				if hVar.tab_unit[d.id] and hVar.tab_unit[d.id].talent and hVar.tab_unit[d.id].talent[i] then
					skillCD = hVar.tab_unit[d.id].talent[i][3] or 100
				end
				
				
				d.talent[i] = {id = skillId, lv = skillLv, cd = skillCD}
				--print("_hh.loadtalent:",skillId, skillLv, skillCD)
			end
		else
			--如果英雄卡里无技能，则说明没填，不添加技能
		end

		if HeroCard.tactic then
			for i = 1, math.min(#HeroCard.tactic, hVar.HERO_TACTIC_SIZE) do
				local tacticObj = HeroCard.tactic[i]
				if not tacticObj then
					tacticObj = {}
				end
				local tacticId = tacticObj.id or 0
				local tacticLv = tacticObj.lv or 0
				--在拥有英雄卡的情况下，技能等级不得大于英雄等级
				if tacticLv > a.level then
					tacticLv = a.level
				end
				d.tactics[i] = {id = tacticId, lv = tacticLv}
			end
		else
			--如果英雄主动战术里无技能
		end
	else
		local tabT = hVar.tab_unit[d.id]
		if tabT then
			--加载talent表里的数据
			if tabT.talent then
				local unlockNum = hApi.GetUnlockTalentNum(a.level)
				--for i = 1, #tabT.talent do
				for i = 1, unlockNum do
					local talentObj = tabT.talent[i]
					local skillId = talentObj[1] or 0
					local skillLv = talentObj[2] or 0
					local skillCD = talentObj[3] or 100
					
					d.talent[i] = {id = skillId, lv = skillLv, cd = skillCD}
				end
			end
			--加载skill表里的数据
			if tabT.attr and tabT.attr.skill then
				for i = 1, #tabT.attr.skill do
					local talentObj = tabT.attr.skill[i]
					local skillId = talentObj[1] or 0
					local skillLv = talentObj[2] or 0
					local skillCD = talentObj[3] or 100
					
					d.talent[#d.talent + 1] = {id = skillId, lv = skillLv, cd = skillCD}
				end
			end
			
			if tabT.tactics then
				for i = 1, math.min(#tabT.tactics, hVar.HERO_TACTIC_SIZE) do
					
					local tacticId = 0
					local tacticLv = 0
					if tabT.tactics[i] then
						tacticId = tabT.tactics[i] or 0
					end
					--目前逻辑写死，每颗星级开放一个技能
					if tacticId > 0 then
						tacticLv = 1
					end
					d.tactics[i] = {id = tacticId, lv = tacticLv}
				end
			end
		end
	end
	
end

_hh.bind = function(self, u)
	local d = self.data
	local a = self.attr
	local w = hGlobal.WORLD.LastWorldMap
	if u then
		if u.data.heroID~=0 then
			_DEBUG_MSG("[LUA WARNING]尝试为已经绑定过的单位绑定hero")
		end
		d.IsDefeated = 0
		d.triggerID = u.data.triggerID
		u.data.heroID = self.ID
		u.data.reciveMoveStepEvent = 1
		
		self.data.bindU = u.ID
		u.attr.heroic = 1	--是英雄
		local tabU = u:gettab()
		if tabU then
			if tabU.icon~=nil then
				d.icon = tabU.icon
			end
		end
		
		--英雄绑定的角色pvp经验等级初始化
		local pvp_lv = self:getpvplv()
		local pvp_exp = self:getpvpexp()
		u:SetPvpLevel(pvp_lv, pvp_exp)
		
		--读取天赋,自定义技能
		for i = 1, #d.talent, 1 do
			local talentObj = d.talent[i]
			local skillId = talentObj.id
			local skillLv = talentObj.lv
			local skillCD = talentObj.cd
			local skillObj = u:getskill(skillId)
			local addFlag = false
			--判断是否已经添加过此技能
			if (not skillObj) then
				addFlag = true
			else
				if (skillObj[1] ~= skillId) and (skillObj[2] ~= skillLv) and (skillObj[5] ~= skillCD) then
					addFlag = true
				end
			end
			
			if addFlag then
				--技能存在，并且技能等级大于0
				if (skillId > 0) and hVar.tab_skill[skillId] and (skillLv > 0) then
					u:addskill(skillId, skillLv, nil, nil, nil, skillCD, 0)
					
					--print(u.data.name, "技能存在，并且技能等级大于0")
					
					--如果该技能为被动既能，那么添加的时候，释放一次
					if (hVar.tab_skill[skillId].cast_type == hVar.CAST_TYPE.AUTO) then
						local tCastParam = {level = skillLv,}
						hApi.CastSkill(u, skillId, 0, 100, u, nil, nil, tCastParam)
					end
				end
			end
		end
		
		--加载装备附加属性
		self:refreshequip(u)
		
		--读取英雄主动类战术技能的原始CD
		--local tactics = hApi.GetHeroTactic(d.id)
		local tactics = self:gettactics()
		for i = 1, #tactics, 1 do
			local tactic = tactics[i]
			if tactic then
				local tacticId = tactic.id or 0
				local tacticLv = tactic.lv or 1
				if (tacticId > 0) and (tacticLv > 0) then
					local tabT = hVar.tab_tactics[tacticId]
					local typeT = tabT.type or hVar.TACTICS_TYPE.OTHER
					local activeSkill = tabT.activeSkill
					
					--技能释放
					if tabT and (typeT == hVar.TACTICS_TYPE.OTHER) and activeSkill then
						local activeSkillId = tabT.activeSkill.id
						local activeSkillLv = tacticLv
						local activeSkillCDOrigin = tabT.activeSkill.cd[activeSkillLv] or 0 --原始CD（单位:秒）
						local activeSkillCDMul = activeSkillCDOrigin * 1000
						local active_skill_cd_delta = u:GetActiveSkillCDDelta() --geyachao: cd附加改变值
						local active_skill_cd_delta_rate = u:GetActiveSkillCDDeltaRate() --geyachao: cd附加改变比例值
						local delta = active_skill_cd_delta + hApi.floor(activeSkillCDMul * active_skill_cd_delta_rate / 100)
						activeSkillCDMul = activeSkillCDMul + delta
						local activeSkillCD = hApi.ceil(activeSkillCDMul / 1000)
						
						d.activeSkillCDOrigin = activeSkillCDOrigin --原始CD（单位:秒）
						d.activeSkillCD = activeSkillCD --CD（单位:秒）
						
						--print(d.name, "activeSkillCDOrigin=", activeSkillCDOrigin, "activeSkillCD=", activeSkillCD)
						--geyachao: 电脑AI，把主动战术技能改为被动释放了
						local player = u:getowner()
						if player and (player:gettype() >= 2) and (player:gettype() <= 6) then --0空 1玩家 2简单电脑 3中等电脑 4困难电脑 5大师电脑 6专家电脑
							--print("电脑", player:getpos(), u.data.name)
							local activeSkillObj = u:getskill(activeSkillId)
							local activeAddFlag = false
							--判断是否已经添加过此技能
							if (not activeSkillObj) then
								activeAddFlag = true
							else
								--print("技能存在", activeSkillId, activeSkillLv, activeSkillCD * 1000)
								if (activeSkillObj[1] ~= activeSkillId) and (activeSkillObj[2] ~= activeSkillLv) and (activeSkillObj[5] ~= activeSkillCD) then
									activeAddFlag = true
								end
							end
							if activeAddFlag then
								--技能存在，并且技能等级大于0
								if (activeSkillId > 0) and hVar.tab_skill[activeSkillId] and (activeSkillLv > 0) then
									u:addskill(activeSkillId, activeSkillLv, nil, nil, nil, activeSkillCD * 1000, 0)
									--print("技能不存在，并且技能等级大于零", activeSkillId, activeSkillLv, activeSkillCD * 1000)
									table.insert(u.attr.skill_AI_sequence, {weight = 10, skills = {activeSkillId}})
								end
							end
						end
					end
				end
			end
		end
		
		--带入上一局的雕像buff
		local tInfo = GameManager.GetGameInfo("auraInfo")
		if tInfo then
			local oUnit = w:GetPlayerMe().heros[1]:getunit() --玩家的第一个英雄
			if (oUnit == u) then
				local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
				local gridX, gridY = w:xy2grid(targetX, targetY)
				
				for nIndex, auraInfo in pairs(tInfo) do
					--local tData = {_nIndex, {id = aura_id, lv = lv,}}
					local aura_id = auraInfo.id
					local lv = auraInfo.lv
					print("auraInfo:", "nIndex=", nIndex, "aura_id=", aura_id, "lv=", lv)
					local tabAura = hVar.tab_aura[aura_id]
					if tabAura then
						local skillAttrbuteType = tabAura.skillAttrbuteType
						local skill_id = tabAura.skill
						
						--只添加被动类技能
						if (skillAttrbuteType == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then
							local tCastParam =
							{
								level = lv, --等级
							}
							hApi.CastSkill(oUnit, skill_id, 0, 100, oUnit, gridX, gridY, tCastParam) --战车雕像技能
							--print("CastSkill:", skill_id)
						end
					end
				end
			end
		end
		
		--重置当前血量
		u.attr.hp = u:GetHpMax()
		
		--读取坐骑，设置行动力
		u:loadmount(self:getGameVar("_MOUNT"))
		u:setmovepoint("born")
		hGlobal.event:call("Event_HeroEnterMap",self,u)
	else
		self.data.bindU = 0
	end
end

--_hh.bindBF = function(self,u)
--	print(nil .. nil)
--	local d = self.data
--	if u.data.heroID~=0 then
--		_DEBUG_MSG("[LUA WARNING]尝试为已经绑定过的单位绑定hero，绑定失败")
--	elseif u~=nil then
--		u.data.heroID = self.ID
--		u.attr.hp = self.attr.hp
--		u.attr.mxhp = self.attr.mxhp
--		u.attr.__mxhp = self.attr.mxhp		--记录单位基础最大生命值
--
--		--如果表格里面填死生物hp等于-1，或者IsGhost==1那么不可被攻击
--		local tabU = hVar.tab_unit[d.id]
--		if tabU.IsGhost==1 or (tabU.attr and tabU.attr.hp==-1) then
--			u.attr.hp = -1
--			u.attr.mxhp = -1
--			u.attr.__mxhp = -1
--		end
--
--		u.attr.mp = self.attr.mp
--		u.attr.mxmp = self.attr.mxmp
--		u.attr.attack[4] = self.attr.minAtk
--		u.attr.attack[5] = self.attr.maxAtk
--		for i = 1,#__UnitAttrKey do
--			local sAttrName = __UnitAttrKey[i]
--			u.attr[sAttrName] = self.attr[sAttrName]
--		end
--		u.attr.heroic = 1		--是英雄
--		self:loadtalent(u)
--		--读取额外技能
--		if type(d.ex_skill)=="table" then
--			local es = d.ex_skill
--			for i = 1,#es do
--				if type(es[i])=="table" then
--					local id = es[i][1]
--					if id~=0 and hVar.tab_skill[id] then
--						u:addskill(id,1)
--					end
--				end
--			end
--		end
--		--读取战术技能
--		if type(d.mastery)=="table" then
--			local ms = d.mastery
--			local msA = d.masteryActive
--			for i = 1,#ms do
--				local id,lv = ms[i][1],ms[i][2]
--				if lv>0 and id~=0 and hVar.tab_skill[id] then
--					local IsActived = 0
--					for n = 1,#msA do
--						if msA[n]==id then
--							IsActived = 1
--							break
--						end
--					end
--					if IsActived==1 then
--						u:addskill(id,lv)
--					end
--				end
--			end
--		end
--		--读取学院技能
--		if type(d.academySkill)=="table" then
--			local as = d.academySkill
--			for i = 1,#as do
--				if type(as[i])=="table" then
--					local id = as[i][1]
--					if id~=0 and hVar.tab_skill[id] then
--						u:addskill(id,1)
--					end
--				end
--			end
--		end
--		--读取装备技能
--		local tEquipFlag = {}
--		for i = 1,#d.equipment do
--			if d.equipment[i]~=0 and type(d.equipment[i])=="table" then
--				local itemID = d.equipment[i][1]
--				if tEquipFlag[itemID]~=1 and hVar.tab_item[itemID] and hApi.IsAttrMeetEquipRequire(self, self.attr,itemID)==1 then
--					tEquipFlag[itemID] = 1
--					local id = hVar.tab_item[itemID].skillId
--					if id~=0 and hVar.tab_skill[id] then
--						local tabS = hVar.tab_skill[id]
--						--判断技能是否激活
--						local sus = 1
--						local tAttrRequire = hApi.GetItemAttrRequire(itemID)
--						if #tAttrRequire>0 then
--							for n = 1,#tAttrRequire do
--								if (self.attr[tAttrRequire[n][1]] or 0)<tAttrRequire[n][2] then
--									sus = 0
--								end
--							end
--						end
--						if sus==1 then
--							u:addskill(id,1,nil,tabS.cooldown_ex,tabS.stackable)	--道具技能使用表中填写的堆叠次数(相同道具只会添加1次)
--						end
--					end
--				end
--			end
--		end
--	end
--end

_hh.unbind = function(self)
	local u = self:getunit()
	if u then
		u.data.heroID = 0
		u.data.reciveMoveStepEvent = 0
		u.data.triggerID = 0
		self.data.bindU = 0
	end
end

_hh.getunit = function(self,key)
	local oUnit = hClass.unit:find(self.data.bindU)
	if oUnit and oUnit.data.heroID==self.ID then
		return oUnit
	end
end

_hh.getowner = function(self)
	--战斗地图英雄是挂在某个玩家下的，非战斗地图是挂在hGlobal.player下的
	local w = hGlobal.WORLD.LastWorldMap
	if w then
		return w:GetPlayer(self.data.owner)
	else
		return hGlobal.player[self.data.owner]
	end
	--return hGlobal.player[self.data.owner]
end

--复活英雄单位
_hh.enterworld = function(self, w, gridX, gridY, facing)
	local d = self.data
	local a = self.attr
	
	--添加单位
	local oUnit = w:addunit(d.id, d.owner, gridX, gridY, facing ,nil ,nil, nil, {triggerID = d.triggerID}, a.level or 1, a.star or 1)
	
	self:bind(oUnit)
	
	--添加战术技能卡技能
	w:tacticsTakeEffect(oUnit)
	
	return oUnit
end

----此函数在ai_calculate函数中被重载了,经验值和等级的具体计算方法在重载的地方计算
--_hh.addexp = function(self,num)
--	local a = self.attr
--	a.exp = a.exp + num
--end

--_hh.addexp = function(self,num,IsWithEffect)
--	local a = self.attr
--	local tExp = self:__exptab()
--	local expMax = tExp[100] or 0
--	if hVar.HERO_LEVEL_LIMIT and hVar.HERO_LEVEL_LIMIT>0 then
--		expMax = tExp[hVar.HERO_LEVEL_LIMIT] or 0
--	end
--	if expMax>0 and a.exp>=expMax and num>=0 then
--		--已经超过了经验上限则什么都不做
--		return
--	end
--	local oldExp = math.max(0,a.exp)
--	local oldLv = math.max(1,a.level)
--	a.exp = a.exp + num
--	if expMax>0 and expMax<a.exp then
--		a.exp = expMax
--	end
--	local newLv
--	if num>=0 then
--		newLv = __CalLevelByExp(oldLv,a.exp,tExp)
--	else
--		newLv = __CalLevelByExp(1,a.exp,tExp)
--	end
--	if newLv~=a.level then
--		self:levelup(newLv,IsWithEffect)
--	end
--	return hGlobal.event:event("Local_EventHeroGetExp",self,num,oldLv)
--end
--
--_hh.levelup = function(self,nNewLv,IsWithEffect)
--	local a = self.attr
--	local d = self.data
--	local olv = a.level
--	if olv==nNewLv then
--		--等级相同不做任何操作
--		return
--	elseif olv<nNewLv then
--		a.level = nNewLv
--		--升级
--		local _,_,_,expCur = self:getexp()
--		if a.exp<expCur then
--			a.exp = expCur
--		end
--		local tempAttr = {}
--		__CalculateAllEquipmentAvailable(self,tempAttr)
--		self:loadattr(tempAttr)
--		--获得战术技能点，数量等于升级数
--		d.masteryPoint = d.masteryPoint + (a.level-olv)
--		if IsWithEffect~=0 then
--			IsWithEffect = 1
--		end
--		hGlobal.event:call("Event_HeroLevelUp",self,olv,IsWithEffect)
--	else
--		--降级
--		a.level = nNewLv + 0
--		local expCur = hVar.HERO_EXP[nNewLv] or 0
--		if expCur~=0 then
--			a.exp = expCur
--		end
--		--降级以后先把装备脱了，然后再重新检查一遍
--		local tempAttr = {}
--		__CalculateAllEquipmentAvailable(self,tempAttr)
--		self:loadattr(tempAttr)
--		--降级时重置所有战术技能
--		d.masteryPoint = nNewLv
--		if type(d.mastery)=="table" then
--			for i = 1,#d.mastery do
--				d.mastery[i][2] = 0
--			end
--		end
--		--hGlobal.event:call("Event_HeroLevelDown",self,olv)
--	end
--end

_hh.__exptab = function(self)
	--zhenkira
	--local oWorld = hGlobal.WORLD.LastWorldMap

	--if self.data.playmode==hVar.PLAY_MODE.CLASSIC then
	--	return hVar.HERO_EXP_TURBO
	--else
	--	return hVar.HERO_EXP
	--end
	return hVar.HERO_EXP
end

--这个函数会在外面被以hClass.hero.getexp({})的方式调用，要小心修改此处代码
_hh.getexp = function(self)
	local a = self.attr
	local d = self.data
	local tExp = hClass.hero.__exptab(self)
	local LExp = tExp[a.level].minExp
	local CExp = a.exp - LExp
	local MExp = tExp[a.level].nextExp or 0
	
	return a.exp,CExp,MExp,LExp	--当前经验, 当前级别多出的经验, 下一级到当前级别的经验,  --当前级别经验
end

local __attrArt = {
	hp = {model = "ICON:skill_icon_x2y3",animation = "normal",font = "numGreen",},
	mp = {model = "ICON:/battle_attack03",animation = "dex",font = "numBlue",},
	lea = {model = "ICON:HeroAttr_leadship",animation = "normal",font = "num",},
	led = {model = "ICON:HeroAttr_defense",animation = "normal",font = "numGreen",},
	str = {model = "ICON:HeroAttr_str",animation = "normal",font = "numRed",},
	int = {model = "ICON:HeroAttr_int",animation = "normal",font = "numBlue",},
	con = {model = "ICON:HeroAttr_con",animation = "normal",font = "num",},
	exp = {model = "ICON:HeroAttr",animation = "exp",font = "num",},
	movepoint = {model = "ICON:Item_Horse01",animation = "normal",font = "num",},
}
local __BasicAttrI = {lea=1,led=1,str=1,con=1,int=1}
local __BasicAttrTemp = {{0,0}}
local __LastU,__LastTick,__PlusY
_hh.addattr = function(self,typ,num,IsNoSound,fromUnit)
	local d = self.data
	local a = self.attr
	if type(num)=="number" then
		if typ=="hp_pec" then
			typ = "hp"
			num = hApi.getint(a.mxhp*num/100)
		elseif typ=="mp_pec" then
			typ = "mp"
			num = hApi.getint(a.mxmp*num/100)
		end
	else
		num = 0
	end
	if a and type(a[typ])=="number" then
		local floatText,sound
		if typ=="hp" then
			if num>0 then
				floatText = "+"..tostring(num)
			end
			self:setHp(nil,num,0)
			sound = "recover_hp"
			if a.hp<=0 then
				--扣血，嗝屁了
				local oUnit = self:getunit("worldmap")
				if oUnit then
					oUnit:beforedead(fromUnit)
					--记录英雄死亡的位置
					--local posX, posY = hApi.chaGetPos(oUnit.handle) --英雄的坐标
					--d.deadX = posX --死亡时的x坐标 --geyachao: 新加大地图复活流程，记录死亡的位置
					--d.deadY = posY --死亡时的y坐标 --geyachao: 新加大地图复活流程，记录死亡的位置
					--print("扣血，嗝屁了", posX, posY)
					oUnit:dead() --扣血扣死了
					hGlobal.event:call("Event_HeroDefeated",self, nil)
				end
			end
		elseif typ=="mp" then
			if num>0 then
				floatText = "+"..tostring(num)
			end
			self:setMp(nil,num,0)
			sound = "recover_hp"
		elseif typ=="mxmp" then
			a.mxmp = a.mxmp + num
			self:setMp(nil,num,0)
			sound = "level_up"
		elseif typ=="mxhp" then
			a.mxhp = a.mxhp + num
			self:setHp(nil,num,0)
			sound = "level_up"
		elseif typ=="exp" then
			if hGlobal.WORLD.LastWorldMap.data.explock == 0 then
				self:addexp(num)
				floatText = "+"..tostring(num)
				sound = "recover_hp"
			end
		elseif typ=="level" then
			if num>0 then
				self:levelup(oHero.attr.level+num)
			end
		else
			sound = "level_up"
			if num>0 then
				floatText = "+"..tostring(num)
			else
				floatText = tostring(num)
			end
			if __BasicAttrI[typ]==1 then
				__BasicAttrTemp[1][1] = typ
				__BasicAttrTemp[1][2] = num
				self:loadattr(__BasicAttrTemp)
			else
				a[typ] = a[typ] + num
			end
		end
		if sound and IsNoSound~=1 then
			hApi.PlaySound(sound)
		end
		if floatText and __attrArt[typ] then
			local oUnit = self:getunit("worldmap")
			if oUnit and oUnit.data.IsHide~=1 and oUnit:isInScreen() then
				local y = 40
				local tick = hApi.gametime()
				if __LastU==oUnit and tick==__LastTick then
					__PlusY = (__PlusY or 0) - 16
					y = y + __PlusY
				else
					__LastU = oUnit
					__LastTick = tick
					__PlusY = 0
				end
				hUI.floatNumber:new({
					unit = oUnit,
					size = 12,
					text = floatText,
					font = __attrArt[typ].font,
					lifetime = 1000,
					fadeout = -500,
					y = y,
					moveY = 32,
					icon = __attrArt[typ].model,
					iconAnimation = __attrArt[typ].animation,
					iconScale = 0.3,
				})
			end
		end
	else
		if typ == "allAttr" then
			if num>0 then
				local tempAttr = {}
				tempAttr[#tempAttr+1] = {"str",num}
				tempAttr[#tempAttr+1] = {"con",num}
				tempAttr[#tempAttr+1] = {"int",num}
				tempAttr[#tempAttr+1] = {"lea",num}
				tempAttr[#tempAttr+1] = {"led",num}
				self:loadattr(tempAttr)
			end
		else
			_DEBUG_MSG("增加非法的英雄属性！",typ,num)
		end
	end
end

--增加持续一周的属性(和普通补充属性不同，如果是行动力，会立刻补充)
_hh.addattrW = function(self,typ,num,IsNoSound)
	local a = self.attr
	local aW = self.attrW
	if a and type(a[typ])=="number" then
		aW[typ] = (aW[typ] or 0) + num
		self:addattr(typ,num,IsNoSound)
	end
end

--给英雄身上的道具栏空位添加道具
_hh.pickitem = function(self,itemU)
	local oItem = itemU:getitem()
	if oItem then
		local itemID = oItem.data.id
		local ItemNum = oItem.data.stack or 1
		local itemList = self.data.item
		local equipmentList = self.data.equipment
		local rewardEx = oItem.data.rewardEx
		local continuedays = oItem.data.continuedays
		local item_version = oItem.data.version
		local item_uniqueID = 0
		
		local tabI = hVar.tab_item[itemID]
		if tabI then
			local oItemToPick
			if tabI.type==hVar.ITEM_TYPE.DEPLETION then
				oItemToPick = {itemID,ItemNum,-1,{g_game_days,continuedays},item_version,item_uniqueID,0,1,{{hVar.ITEM_FROMWHAT_TYPE.PICK,hVar.MAP_INFO[itemU:getworld().data.map].uniqueID,itemU.data.worldX,itemU.data.worldY}}}
			else
				oItemToPick = {itemID,1,rewardEx,{g_game_days,continuedays},item_version,item_uniqueID,0,1,{{hVar.ITEM_FROMWHAT_TYPE.PICK,hVar.MAP_INFO[itemU:getworld().data.map].uniqueID,itemU.data.worldX,itemU.data.worldY}}}
			end
			return hGlobal.event:call("Event_HeroGetItem",self,oItemToPick,nil,nil,itemU,oItem)
		end
	end
end

--添加宝箱
local __TokenItem = {
	ID = 0,
	__ID = 0,
	del = function(self)
		self.ID = 0
	end,
}
_hh.additembyID = function(self,itemID,rewardEx,fromWhat,sBagName,nBagIndex,fromlist)
	return hApi.GiveItemToHeroByID(self,itemID,rewardEx,fromWhat,sBagName,nBagIndex,fromlist)
end

_hh.pickitemO = function(self,oItemToPick)
	__TokenItem.ID = -1
	hGlobal.event:call("Event_HeroGetItem",self,oItemToPick,"bag",nil,nil,__TokenItem)
	if __TokenItem.ID==0 then
		return 1
	else
		return 0
	end
end

--英雄扔掉道具
_hh.dropitem = function(self,fromPos)
	local fromInedx = hApi.HeroItemGrid2Index(fromPos.x,fromPos.y)
	local itemID = self.data.item[fromInedx][1]
	local itemstack = self.data.item[fromInedx][2]
	local rewardEx = self.data.item[fromInedx][3]
	local item_version = (self.data.item[fromInedx][5] or 0)
	local item_uniqueID = (self.data.item[fromInedx][6] or 0)
	local w = self:getunit():getworld()
	if w then
		local itemtype = hVar.tab_item[itemID].type
		--非消耗类道具才可以
		if itemtype ~= hVar.ITEM_TYPE.DEPLETION and hVar.tab_item[itemID].continuedays == nil then
			hGlobal.event:call("Event_HeroDropItem",self,w,itemID,fromInedx,itemstack,rewardEx,item_version,item_uniqueID)
		else
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Can'tDorpItem"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end
	end
end

--根据attr表检测物品是否可以使用
local __IsItemMeedRequire = function(oHero, tAttr, itemID)
	--print("__IsItemMeedRequire", oHero and oHero.data.name, hVar.tab_item[itemID].name)
	if hVar.tab_item[itemID] then
		local nRequireLv = hApi.GetItemRequire(itemID,"level")
		local lv = tAttr.level
		local w = hGlobal.WORLD.LastWorldMap
		if w then
			local mapInfo = w.data.tdMapInfo
			if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
				if w.data.bUseEquip then --装备局，允许带装备
					--if mapInfo.equipUnlockMode == 0 then
					if mapInfo.pveHeroMode == 0 then
						lv = tAttr.pvplv
					else
						return 1
					end
				--0空 1玩家 2简单电脑 3中等电脑 4困难电脑 5大师电脑 6专家电脑
				elseif (oHero and oHero:getowner() and oHero:getowner():gettype() and (oHero:getowner():gettype() >= 2) and (oHero:getowner():gettype() <= 6)) then
					lv = tAttr.pvplv
				else
					return 0
				end
			end
		end
		if nRequireLv>0 and lv<nRequireLv then
			return 0
		else
			return 1
		end
	end
	return 0
end

local __CheckBagItemsByAttr = function(oHero, tBag, nDayCount,tCheckAttr,tTempAttr)
	for i = 1,#tBag do
		local oItem = tBag[i]
		if type(oItem)=="table" then
			local tabI = hVar.tab_item[oItem[hVar.ITEM_DATA_INDEX.ID]]
			if tabI then
				if tabI.type == hVar.ITEM_TYPE.DEPLETION then
					--重新设置宝箱道具的打开时间
					oItem[hVar.ITEM_DATA_INDEX.PICK] = {-1,-1}
				else
					--一般的装备道具
					--限时道具删除
					if type(nDayCount)=="number" and type(oItem[hVar.ITEM_DATA_INDEX.PICK]) == "table" then
						local d = oItem[hVar.ITEM_DATA_INDEX.PICK][1] or 0
						local c = oItem[hVar.ITEM_DATA_INDEX.PICK][2] or 0
						if c~=-1 and (nDayCount==0 or (nDayCount - d>=c) or nDayCount==d) then
							tBag[i] = 0
						end
					end
					--非法道具直接删除(洪慧敏专用)
					--if type(oItem[hVar.ITEM_DATA_INDEX.SLOT]) == "table" and oItem[hVar.ITEM_DATA_INDEX.SLOT][1]>3 then
					--	tBag[i] = 0
					--end
					if tBag[i]==0 then
						if tTempAttr then
							hApi.GetEquipmentAttr(oItem[hVar.ITEM_DATA_INDEX.ID],oItem[hVar.ITEM_DATA_INDEX.SLOT],tTempAttr,-1,oItem[hVar.ITEM_DATA_INDEX.QUALITY],oItem)
						end
					else
						if tCheckAttr then
							if __IsItemMeedRequire(oHero, tCheckAttr,oItem[hVar.ITEM_DATA_INDEX.ID])==1 then
								hApi.SetItemAvailable(oItem,1)
							else
								hApi.SetItemAvailable(oItem,0)
							end
						end
					end
				end
			end
		end
	end
end

--英雄是否满足装备需求
hApi.IsAttrMeetEquipRequire = function(oHero, tAttr,itemID)
	return __IsItemMeedRequire(oHero, tAttr,itemID)
end

--检查背包中所有不合法的道具，并删除之
hApi.CheckHeroBagItem = function(oHero,tTempAttr)
	if hGlobal.WORLD.LastWorldMap then
		local nDayCount = hGlobal.WORLD.LastWorldMap.data.roundcount
		local case = type(oHero)
		if (case == "table") then
			--检查目标英雄
			local d = oHero.data
			__CheckBagItemsByAttr(oHero, d.equipment,nDayCount,oHero.attr,tTempAttr)
			__CheckBagItemsByAttr(oHero, d.item,nDayCount,nil,nil)
		elseif (case == "number") then
			--检查卡片数据
			local nHeroID = oHero
			local tCard = hApi.GetHeroCardById(nHeroID)
			if tCard then
				__CheckBagItemsByAttr(oHero, tCard.equipment,nDayCount,nil,nil)
				__CheckBagItemsByAttr(oHero, tCard.item,nDayCount,nil,nil)
			end
		elseif (oHero == "playerbag") then
			--检查背包
			local playerbag = LuaGetPlayerBag()
			if (type(playerbag)=="table") then
				__CheckBagItemsByAttr(oHero, playerbag,nDayCount,nil,nil)
			end
		end
	end
end

local __GetItemFromCardBag = function(tCard,k,i)
	--print("__GetItemFromCardBag",tCard,k,i)
	local oItem
	if k=="bag" then
		oItem = tCard.item[i]
	elseif k=="equip" then
		local uniqueId = tCard.equipment[i]
		--print("uniqueId=", uniqueId)
		local _, item = LuaFindEquipByUniqueId(uniqueId)
		oItem = item
		--if oItem and (oItem ~= 0) then
		--	print(oItem[1], oItem[2], oItem[3], oItem[4], oItem[5], oItem[6], oItem[7], oItem[8])
		--end
	elseif k=="playerbag" then
		oItem = LuaGetPlayerBag()[i]
	end
	if type(oItem)=="table" then
		return oItem
	end
end
local __PutItemToCardBag = function(tCard,k,i,oItem)
	if k=="bag" then
		tCard.item[i] = oItem or 0
	elseif k=="equip" then
		tCard.equipment[i] = oItem or 0
	elseif k=="playerbag" then
		LuaGetPlayerBag()[i] = oItem or 0
	else
		return oItem
	end
end
hApi.CopyObjectItem = function(oItem)
	if type(oItem)=="table" then
		return hApi.ReadParamWithDepth(oItem,nil,{},2)
	else
		return 0
	end
end
hApi.CopyItemFromCardToGameHero = function(tCard,oHero,k,i)
	if k=="bag" then
		if i<1 or type(oHero.data.item)~="table" or i>#oHero.data.item then
			return 0
		end
	elseif k=="equip" then
		if i<1 or type(oHero.data.equipment)~="table" or i>#oHero.data.equipment then
			return 0
		end
	else
		return 0
	end
	local oItem = __GetItemFromCardBag(tCard,k,i)
	--print(i, "oItem=", oItem)
	local oCopyItem = hApi.CopyObjectItem(oItem)
	if k=="bag" then
		oHero.data.item[i] = oCopyItem
	elseif k=="equip" then
		oHero.data.equipment[i] = oCopyItem
		if type(oCopyItem)=="table" then
			if hApi.IsAttrMeetEquipRequire(oHero, oHero.attr,oCopyItem[1])==1 then
				hApi.SetItemAvailable(oCopyItem,1)
			else
				hApi.SetItemAvailable(oCopyItem,0)
			end
		end
	end
	return 1
end
hApi.GetItemFromBag = function(oHero,k,i,mode)
	
	if type(i) ~= "number" or i<=0 then
		return
	else
		if oHero.data.HeroCard==1 and mode~="ui" then
			--卡片模式
			local tCard = hApi.GetHeroCardById(oHero.data.id)
			if tCard then
				return __GetItemFromCardBag(tCard,k,i)
			end
		else
			if k=="bag" then
				return oHero.data.item[i]
			elseif k=="equip" then
				return oHero.data.equipment[i]
			elseif k=="playerbag" then
				return LuaGetPlayerBag()[i]
			elseif k=="mapbag" then
				--这个模式才允许使用地图背包
				if oHero.data.playmode==hVar.PLAY_MODE.NO_HERO_CARD then
					local oWorld = hGlobal.WORLD.LastWorldMap
					if oWorld and oWorld.ID>0 and type(oWorld.data.mapbag)=="table" then
						return oWorld.data.mapbag[i]
					end
				end
			end
		end
	end
end
local __PutItemToBag = function(oHero,k,i,oItem,mode)
	if i<=0 then
		return
	else
		if k=="bag" or k=="equip" then
			--放入背包/装备栏
			if oHero.data.HeroCard==1 then
				--卡片模式
				local oItemR
				local tCard = hApi.GetHeroCardById(oHero.data.id)
				if tCard then
					oItemR = __PutItemToCardBag(tCard,k,i,oItem)
					hApi.CopyItemFromCardToGameHero(tCard,oHero,k,i)
				end
				return oItemR
			else
				--非卡片模式
				if k=="bag" then
					if i>=1 and i<=#oHero.data.item then
						oHero.data.item[i] = oItem or 0
					end
				elseif k=="equip" then
					if i>=1 and i<=#oHero.data.equipment then
						if type(oItem)=="table" then
							oHero.data.equipment[i] = oItem
							if hApi.IsAttrMeetEquipRequire(oHero, oHero.attr,oItem[hVar.ITEM_DATA_INDEX.ID])==1 then
								hApi.SetItemAvailable(oItem,1)
							else
								hApi.SetItemAvailable(oItem,0)
							end
						else
							oHero.data.equipment[i] = 0
						end
					end
				end
			end
		elseif k=="playerbag" then
			--放入玩家背包
			LuaGetPlayerBag()[i] = oItem or 0
		elseif k=="mapbag" then
			--放入地图背包
			if oHero.data.playmode==hVar.PLAY_MODE.NO_HERO_CARD then
				local oWorld = hGlobal.WORLD.LastWorldMap
				if oWorld and oWorld.ID>0 and type(oWorld.data.mapbag)=="table" then
					oWorld.data.mapbag[i] = oItem or 0
				end
			end
		else
			return oItem
		end
	end
end

hApi.PutItemToBag = __PutItemToBag
local __HeroBagName = {
	["equip"] = 1,
	["bag"] = 1,
}
local __IsSafeItemShift = function(oHero,fromKey,fromI,toKey,toI)
	if fromKey~=toKey then
		if oHero.data.HeroCard==1 then
			--卡片英雄禁止与地图背包交互
			if (fromKey=="mapbag" and __HeroBagName[toKey]==1) or (__HeroBagName[fromKey]==1 and toKey=="mapbag") then
				return 0
			end
		else
			--非卡片英雄禁止与仓库交互
			if (fromKey=="playerbag" and __HeroBagName[toKey]==1) or (__HeroBagName[fromKey]==1 and toKey=="playerbag") then
				return 0
			end
		end
	end
	return 1
end
hApi.IsSafeItemShift = __IsSafeItemShift

--刷新背包(卡片类英雄专用，但是在这个接口里面不判断自己是否卡片英雄，调用请小心)
_hh.updatebag = function(self,tUpdateSlot)
	local d = self.data
	local tCard = hApi.GetHeroCardById(d.id)
	if tCard~=nil then
		if type(tUpdateSlot)=="table" then
			for i = 1,#tUpdateSlot do
				local v = tUpdateSlot[i]
				hApi.CopyItemFromCardToGameHero(tCard,self,v[1],v[2])
			end
		else
			for i = 1,#d.item do
				hApi.CopyItemFromCardToGameHero(tCard,self,"bag",i)
			end
			for i = 1,#d.equipment do
				hApi.CopyItemFromCardToGameHero(tCard,self,"equip",i)
			end
		end
	end
end

--获得一个背包中的物品
_hh.getbagitem = function(self,key,index,mode)
	local oItem = hApi.GetItemFromBag(self,key,index,mode)
	if type(oItem)=="table" then
		return oItem
	end
end

--为某个npc读取英雄装备和经验(会强制将此英雄设置为非卡片模式)
_hh.LoadHeroFromCardForNPC = function(self,tHeroCard,IsLoadExp)
	local d = self.data
	local a = self.attr
	local IsReload = 0
	--d.HeroCard = 0
	local tEquip = tHeroCard.equipment
	local tItem = tHeroCard.item
	local nExp = tHeroCard.attr.exp
	local tempAttr = {}
	if type(tEquip)=="table" then
		--除去原本装备的属性加成
		hApi.GetHeroEquipAttr(self,tempAttr,-1)
		--替换装备
		for i = 1,#d.equipment do
			d.equipment[i] = 0
		end
	end
	if type(nExp)=="number" and IsLoadExp==1 then
		--重新读取经验
		self:addexp(math.max(0,nExp)-a.exp,0)
		IsReload = 1
	end
	if type(tEquip)=="table" then
		--替换新的装备
		for i = 1,#tEquip do
			__PutItemToBag(self,"equip",i,tEquip[i])
		end
		hApi.CheckHeroBagItem(self)
		--替换为新的装备属性加成
		hApi.GetHeroEquipAttr(self,tempAttr,1)
	end
	--获得所有附加属性
	if #tempAttr>0 then
		self:__loadattr(tempAttr)
		IsReload = 1
	end
	if IsReload==1 then
		--self:loadtalent()
		self:loadtalent(tHeroCard)
	end
end

local __AddEQAttrByIndex = function(tEquipment,k,i,IsPlus,tTempAttr)
	if k=="equip" then
		local oItem = tEquipment[i]
		if type(oItem)=="table" and hApi.CheckItemAvailable(oItem)==1 then
			hApi.GetEquipmentAttr(oItem[1],oItem[3],tTempAttr,IsPlus,oItem[hVar.ITEM_DATA_INDEX.QUALITY],oItem)
		end
	end
end
hApi.AddEQAttrByIndex = __AddEQAttrByIndex
local __IfHeroCanEquipItem = function(oHero, id,pos,tAttr)
	if pos~=hApi.GetHeroEquipmentIndexType(hVar.tab_item[id].type) then
		--_DEBUG_MSG("不可将装备"..id.."放置到位置"..pos)
		return 0
	elseif hApi.IsAttrMeetEquipRequire(oHero, tAttr,id)~=1 then
		--_DEBUG_MSG("不满足装备"..id.."的需求")
		return 0
	else
		return 1
	end
end

hApi.IfHeroCanEquipItem = __IfHeroCanEquipItem

--交换英雄背包栏内的 item
_hh.shiftitem = function(self,fromKey,fromI,toKey,toI)
	--判断是否合法的道具交换
	if __IsSafeItemShift(self,fromKey,fromI,toKey,toI)~=1 then
		return hVar.RESULT_FAIL,0,0
	end
	--交换流程开始
	local oItemF
	if type(fromI)=="table" and type(fromI[1])=="number" then
		if hVar.tab_item[fromI[1]]~=nil then
			oItemF = fromI
		end
		fromI = 0
	else
		oItemF = hApi.GetItemFromBag(self,fromKey,fromI)
	end
	local oItemT = hApi.GetItemFromBag(self,toKey,toI)
	
	if type(oItemF)=="table" then
		local nItemID_F = oItemF[hVar.ITEM_DATA_INDEX.ID] or 0
		local nItemID_T = 0
		local oItemR
		--完全相同不做操作
		if fromKey==toKey and fromI==toI then
			return hVar.RESULT_FAIL,nItemID_F,nItemID_F
		end
		--如果目标栏位是装备栏，进行合法性检测
		if toKey=="equip" then
			if __IfHeroCanEquipItem(self, oItemF[hVar.ITEM_DATA_INDEX.ID],toI,self.attr)~=1 then
				return hVar.RESULT_FAIL,0,0
			end
		end
		--如果是来自物品栏的替换，那么也进行合法性检测
		if fromKey=="equip" and type(oItemT)=="table" then
			if __IfHeroCanEquipItem(self, oItemT[hVar.ITEM_DATA_INDEX.ID],fromI,self.attr)~=1 then
				return hVar.RESULT_FAIL,0,0
			end
		end
		if type(oItemT)=="table" then
			nItemID_T = oItemT[hVar.ITEM_DATA_INDEX.ID] or 0
		else
			oItemT = 0
		end
		local IsUpdateAttr = 0
		--交换物品，某些情况下要重算属性
		if (fromKey=="equip" or toKey=="equip") and fromKey~=toKey then
			local tTempAttr = {}
			__AddEQAttrByIndex(self.data.equipment,fromKey,fromI,-1,tTempAttr)
			__AddEQAttrByIndex(self.data.equipment,toKey,toI,-1,tTempAttr)
			__PutItemToBag(self,fromKey,fromI,oItemT)
			oItemR = __PutItemToBag(self,toKey,toI,oItemF)
			__AddEQAttrByIndex(self.data.equipment,fromKey,fromI,1,tTempAttr)
			__AddEQAttrByIndex(self.data.equipment,toKey,toI,1,tTempAttr)
			if #tTempAttr>0 then
				IsUpdateAttr = 1
				self:loadattr(tTempAttr)
			end
		else
			__PutItemToBag(self,fromKey,fromI,oItemT)
			oItemR = __PutItemToBag(self,toKey,toI,oItemF)
		end
		hGlobal.event:call("Event_HeroSortItem",self,IsUpdateAttr,hVar.OPERATE_TYPE.HERO_SORTITEM)

		return hVar.RESULT_SUCESS,nItemID_F,nItemID_T,oItemR
	else
		return hVar.RESULT_FAIL,0,0
	end
end

hApi.GetItemFromHeroCard = function(id,k,i)
	local tCard = hApi.GetHeroCardById(id)
	if tCard then
		return __GetItemFromCardBag(tCard,k,i)
	end
end

hApi.ShiftItemByHeroCard = function(id,fromKey,fromI,toKey,toI,tAttr)
	local tCard = hApi.GetHeroCardById(id)
	if tCard then
		local oItemF = __GetItemFromCardBag(tCard,fromKey,fromI)
		local oItemT = __GetItemFromCardBag(tCard,toKey,toI)
		if type(tAttr)~="table" then
			tAttr = nil
		end
		if type(oItemF)=="table" then
			--完全相同不做操作
			if fromKey==toKey and fromI==toI then
				return hVar.RESULT_FAIL
			end
			--如果目标栏位是装备栏，进行合法性检测
			if tAttr then
				local oHero = nil
				if (hGlobal.WORLD.LastWorldMap ~= nil) then
					local me = hGlobal.WORLD.LastWorldMap:GetPlayerMe()
					for i = 1, #me.heros, 1 do
						local oHeroi = me.heros[i]
						if type(oHeroi)=="table" and oHeroi.ID~=0 and oHeroi.data.HeroCard==1 and oHeroi.data.id==id then
							oHero = oHeroi
							break
						end
					end
				end
				if toKey=="equip" then
					if __IfHeroCanEquipItem(oHero, oItemF[1],toI,tAttr)~=1 then
						return hVar.RESULT_FAIL
					end
				end
				--如果是来自物品栏的替换，那么也进行合法性检测
				if fromKey=="equip" and type(oItemT)=="table" then
					if __IfHeroCanEquipItem(oHero, oItemT[1],fromI,tAttr)~=1 then
						return hVar.RESULT_FAIL
					end
				end
			end
			if type(oItemT)=="table" then
				__PutItemToCardBag(tCard,fromKey,fromI,oItemT)
				__PutItemToCardBag(tCard,toKey,toI,oItemF)
			else
				__PutItemToCardBag(tCard,fromKey,fromI,0)
				__PutItemToCardBag(tCard,toKey,toI,oItemF)
			end
			if hGlobal.WORLD.LastWorldMap~=nil then
				if fromKey=="equip" or fromKey=="bag" or toKey=="equip" or toKey=="bag" then
					local me = hGlobal.WORLD.LastWorldMap:GetPlayerMe()
					for i = 1,#me.heros do
						local oHero = me.heros[i]
						if type(oHero)=="table" and oHero.ID~=0 and oHero.data.HeroCard==1 and oHero.data.id==id then
							oHero:LoadHeroFromCard("reload")
							break
						end
					end
				end
			end
			hGlobal.event:call("Event_HeroCardSortItem",id)
			return hVar.RESULT_SUCESS
		else
			return hVar.RESULT_FAIL
		end
	end
end

hApi.GetEquipmentAttr = function(id,enhance,tempAttr,IsPlus,quality,oItem)
	local tabI = hVar.tab_item[id]
	local p = IsPlus==1 and 1 or -1
	if tabI and tabI.reward then
		for i = 1,#tabI.reward do
			local v = tabI.reward[i]
			if v~=0 then
				if v[1] == "Atk" then
					
					tempAttr[#tempAttr+1] = {"minAtk",p*v[2][1]}
					tempAttr[#tempAttr+1] = {"maxAtk",p*v[2][2]}
				elseif v[1] == "allAttr" then
					tempAttr[#tempAttr+1] = {"str",p*v[2]}
					tempAttr[#tempAttr+1] = {"con",p*v[2]}
					tempAttr[#tempAttr+1] = {"int",p*v[2]}
					tempAttr[#tempAttr+1] = {"lea",p*v[2]}
					tempAttr[#tempAttr+1] = {"led",p*v[2]}
				elseif v[1] == "atk" then --geyachao: TD道具的属性
					
					tempAttr[#tempAttr+1] = {"atk_min",p*v[2][1]}
					tempAttr[#tempAttr+1] = {"atk_max",p*v[2][2]}
				else
					local lv = 1
					local strExpress = tostring(v[2])
					local v2 = hApi.AnalyzeValueExpr(nil, nil, {["@lv"] = lv, ["@quality"] = quality,}, strExpress, 0)
					
					tempAttr[#tempAttr+1] = {v[1],p*v2}
				end
			end
		end
	end
	
	--道具的随机属性
	local randreward = tabI.randreward --道具随机奖励的属性表
	if (type(randreward) == "table") and (type(oItem) == "table") then
		--将随机属性加入列表
		local reward = {}
		local randIdx1 = oItem[hVar.ITEM_DATA_INDEX.RAND_IDX1]
		local randVal1 = oItem[hVar.ITEM_DATA_INDEX.RAND_VAL1]
		if (randIdx1 > 0) then
			if randreward[randIdx1] then
				local key = randreward[randIdx1][1]
				local value = randVal1
				--print("随机属性1", key, value)
				reward[#reward+1] = {key, value,}
			end
		end
		
		--随机属性2
		local randIdx2 = oItem[hVar.ITEM_DATA_INDEX.RAND_IDX2]
		local randVal2 = oItem[hVar.ITEM_DATA_INDEX.RAND_VAL2]
		if (randIdx2 > 0) then
			if randreward[randIdx2] then
				local key = randreward[randIdx2][1]
				local value = randVal2
				--print("随机属性2", key, value)
				reward[#reward+1] = {key, value,}
			end
		end
		
		--随机属性3
		local randIdx3 = oItem[hVar.ITEM_DATA_INDEX.RAND_IDX3]
		local randVal3 = oItem[hVar.ITEM_DATA_INDEX.RAND_VAL3]
		if (randIdx3 > 0) then
			if randreward[randIdx3] then
				local key = randreward[randIdx3][1]
				local value = randVal3
				--print("随机属性3", key, value)
				reward[#reward+1] = {key, value,}
			end
		end
		
		--随机属性4
		local randIdx4 = oItem[hVar.ITEM_DATA_INDEX.RAND_IDX4]
		local randVal4 = oItem[hVar.ITEM_DATA_INDEX.RAND_VAL4]
		if (randIdx4 > 0) then
			if randreward[randIdx4] then
				local key = randreward[randIdx4][1]
				local value = randVal4
				--print("随机属性4", key, value)
				reward[#reward+1] = {key, value,}
			end
		end
		
		--随机属性5
		local randIdx5 = oItem[hVar.ITEM_DATA_INDEX.RAND_IDX5]
		local randVal5 = oItem[hVar.ITEM_DATA_INDEX.RAND_VAL5]
		if (randIdx5 > 0) then
			if randreward[randIdx5] then
				local key = randreward[randIdx5][1]
				local value = randVal5
				--print("随机属性5", key, value)
				reward[#reward+1] = {key, value,}
			end
		end
		
		for index, list in ipairs(reward) do
			local typ = list[1] --属性类型
			local num = list[2] --属性值
			
			tempAttr[#tempAttr+1] = {typ,p*num,}
			--print("随机属性"..index, typ,num)
		end
	end
	
	--强化的属性
	if (enhance) and (type(enhance) == "table") then
		--geyachao: 附加道具孔的属性
		for j = 1, #enhance, 1 do
			local arrtEx = enhance[j] --道具孔属性位
			if (type(arrtEx) == "string") and hVar.ITEM_ATTR_VAL[arrtEx] then
				local attrVal = hVar.ITEM_ATTR_VAL[arrtEx] --道具孔的属性表
				local attrAdd = attrVal.attrAdd --属性类型
				local value1 = attrVal.value1 --属性值1
				local value2 = attrVal.value2 --属性值2
				
				if (attrAdd == "atk") then
					tempAttr[#tempAttr+1] = {"atk_min", p * value1}
					tempAttr[#tempAttr+1] = {"atk_max", p * value2}
				else
					tempAttr[#tempAttr+1] = {attrAdd, p * value1}
				end
			end
		end
	end
	
	return tempAttr
end

--给英雄添身上添加一件装备（游戏初始化用,只可调用一次）参数3 额外奖励的属性 参数4 是一张表 第一个值是装备时间 第二个值 是持续天数 参数5为 道具版本号
--根据身上装备增加英雄属性
_hh.addEQHeroAttr = function(self,equipment,mode,AvailableCheckMode)
	local IsPlus = 1
	if mode=="-" then
		IsPlus = -1
	end
	if AvailableCheckMode==nil then
		--无限制模式
	elseif AvailableCheckMode=="check" then
		--合法性检测模式
		if hApi.CheckItemAvailable(equipment)~=1 then
			return
		end
	elseif AvailableCheckMode=="init" then
		--初始化模式
		if hApi.IsAttrMeetEquipRequire(self, self.attr,equipment[1])==1 then
			hApi.SetItemAvailable(equipment,1)
		else
			hApi.SetItemAvailable(equipment,0)
			return
		end
	end
	local tempAttr = hApi.GetEquipmentAttr(equipment[1],equipment[3],{},IsPlus,equipment[hVar.ITEM_DATA_INDEX.QUALITY],equipment)
	if #tempAttr>0 then
		return self:loadattr(tempAttr)
	end
end

--设置英雄单位学院技能
_hh.setacademyskill = function(self,index,skillId)
	--对已有技能进行判断
	local as = self.data.academySkill
	--必须在合法的技能位置里面
	if index>0 and index<=#as then
		if skillId~=0 and hVar.tab_skill[skillId] then
			--如果拖放到当前方格的话，不改变技能
			if as[index]~=0 and as[index][1]==skillId then
				return
			end
			for i = 1,#as do
				if as[i]~=0 and as[i][1]==skillId then
					as[i] = 0
				end
			end
			as[index] = {skillId,1}
		else
			as[index] = 0
		end
	end
end

--翰林院技能
_hh.getacademyskill = function(self,index)
	return self.data.academySkill[index]
end

--使用消耗类道具
_hh.useitem = function(self,sBagName,nBagIndex,tradeid)
	if self.data.HeroCard~=1 and sBagName~="playerbag" then
		--禁止无卡片英雄使用仓库栏以外的道具
		return
	end
	
	local oUnit = self:getunit()
	local oItem = self:getbagitem(sBagName,nBagIndex)
	if oItem then
		local itemID = oItem[hVar.ITEM_DATA_INDEX.ID]
		local tabI = hVar.tab_item[itemID]
		if tabI==nil then
			return
		end
		local getDay = -1
		local cDay = -1
		if type(oItem[hVar.ITEM_DATA_INDEX.PICK]) == "table" then
			getDay = oItem[hVar.ITEM_DATA_INDEX.PICK][1]
			cDay = oItem[hVar.ITEM_DATA_INDEX.PICK][2]
		end
		if getDay>=g_game_days and cDay~=999 then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Can'tOpenItem"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		else
			--先把该消耗道具移除
			if self:shiftitem(sBagName,nBagIndex,"use",0)~=hVar.RESULT_SUCESS then
				print("使用物品失败！",sBagName,nBagIndex,"id = "..oItem[hVar.ITEM_DATA_INDEX.ID])
				return
			end
			
			--如果该物品拥有使用效果
			if type(tabI.used)=="table" then
				local typ,ex,val = unpack(hVar.tab_item[itemID].used)
				--如果是黄金宝箱则设置可以重转
				if itemID == 9006 then
					hApi.UnitGetLoot(oUnit,typ,ex,val,nil,1,sBagName,nBagIndex,oItem,nil,tradeid)
				else
					hApi.UnitGetLoot(oUnit,typ,ex,val,nil,0,sBagName,nBagIndex,oItem,nil,tradeid)
				end
			end
			
			--LuaAddPlayerCountVal("useitem",itemID,1)
			LuaSaveHeroCard()
			--针对宝箱做keyChain
			local new_Key_UsedItemCount = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName..tostring(itemID))
			if new_Key_UsedItemCount == 0 then
				local UseCount = LuaGetPlayerCountVal("useitem",itemID)
				xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName..tostring(itemID),UseCount)
			else
				xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName..tostring(itemID),new_Key_UsedItemCount+1)
			end

			--记录消耗类道具的使用
			local new_itemCount = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."UseDepletionItem"..itemID) + 1
			xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."UseDepletionItem"..itemID,new_itemCount)
		end
	end
end

--读取战术技能
_hh.learnmastery = function(self,id,lv)
	
end

----增加一个英雄到队伍中 zhenkira delete 2016.7.12
--_hh.teamaddmember = function(self,oHero,nInsertIndex,IfWithChangeOwner)
--	local d = self.data
--	if oHero.data.id==d.id then
--		return hVar.RESULT_FAIL
--	end
--	if oHero.data.HeroTeamLeader~=0 then
--		return hVar.RESULT_FAIL
--	end
--	local tTeam = d.HeroTeam
--	local nTeamUnitCount = 0
--	local u = self:getunit()
--	local t = oHero:getunit()
--	if u then
--		for i = 1,#u.data.team do
--			local v = u.data.team[i]
--			if v~=0 then
--				nTeamUnitCount = nTeamUnitCount + 1
--			end
--		end
--	end
--	if nTeamUnitCount<=6 then
--		local findI = #tTeam + 1
--		for i = 1,#tTeam do
--			if tTeam[i]==0 then
--				findI = i
--			end
--		end
--		if u then
--			if u:teamaddunit({{oHero.data.id,1,nInsertIndex,1}})==hVar.RESULT_SUCESS then
--				tTeam.n = tTeam.n + 1
--				tTeam[findI] = {oHero.ID,oHero.__ID}
--				oHero.data.HeroTeamLeader = self.ID
--				if t~=nil then
--					t.data.team = hApi.InitUnitTeam()
--					t:teamaddunit({{oHero.data.id,1}})
--					t:sethide(1)
--					if t.handle._c then
--						hApi.chaSetMovePoint(t.handle,0)
--					end
--				end
--				--加入英雄后，刷新本地头像列表
--				if self:getowner()==hGlobal.LocalPlayer and oHero:getowner()==hGlobal.LocalPlayer then
--					IfWithChangeOwner = IfWithChangeOwner or 0
--					hGlobal.event:event("LocalEvent_HeroOprBtnUpdate",oHero,IfWithChangeOwner)
--				end
--				return hVar.RESULT_SUCESS
--			end
--		end
--	end
--	return hVar.RESULT_FAIL
--end

_hh.teamremoveunit = function(self,id,IsWithEvent)
	local oUnit = self:getunit()
	if oUnit and type(oUnit.data.team)=="table" then
		local nLeaveCount = 0
		for i = 1,#oUnit.data.team do
			local v = oUnit.data.team[i]
			if type(v)=="table" and v[1]==id then
				oUnit.data.team[i] = 0
				nLeaveCount = nLeaveCount + 1
			end
		end
		if nLeaveCount>0 and IsWithEvent~=0 then
			hGlobal.event:call("Event_TeamChange","remove",oUnit)
		end
	end
end

_hh.teamremovemember = function(self,oHero,nFindI,IsWithEvent)
	if self.ID==0 then
		return
	end
	if oHero.data.HeroTeamLeader~=self.ID then
		_DEBUG_MSG("英雄"..oHero.data.id.."不是该英雄的副将")
		return
	end
	local HeroTeam = self.data.HeroTeam
	if type(HeroTeam)=="table" and HeroTeam.n>0 then
		if nFindI~=nil then
			local v = HeroTeam[nFindI]
			if type(v)=="table" and oHero.ID==v[1] and oHero.__ID==v[2] then
			else
				nFindI = nil
			end
		end
		if nFindI==nil then
			for i = 1,#HeroTeam do
				local v = HeroTeam[i]
				if type(v)=="table" and oHero.ID==v[1] and oHero.__ID==v[2] then
					nFindI = i
					break
				end
			end
		end
		if nFindI~=nil then
			oHero.data.HeroTeamLeader = 0
			HeroTeam[nFindI] = 0
			HeroTeam.n = HeroTeam.n - 1
			self:teamremoveunit(oHero.data.id,IsWithEvent)
		end
	end
end

--根据id取得一个同队英雄
_hh.getteammemberbyid = function(self,id)
	local HeroTeam = self.data.HeroTeam
	if type(HeroTeam)=="table" and HeroTeam.n>0 then
		for i = 1,#HeroTeam do
			local v = HeroTeam[i]
			if type(v)=="table" then
				local oHeroC = hClass.hero:find(v[1])
				if oHeroC and oHeroC.__ID==v[2] and oHeroC.data.id==id then
					return oHeroC
				end
			end
		end
	end
end

--遍历自己的队友英雄
_hh.enumteam = function(self,pFunc,paramI,paramII)
	local HeroTeam = self.data.HeroTeam
	if type(HeroTeam)=="table" and HeroTeam.n>0 then
		for i = 1,#HeroTeam do
			local v = HeroTeam[i]
			if type(v)=="table" then
				local oHeroC = hClass.hero:find(v[1])
				if oHeroC and oHeroC.__ID==v[2] then
					pFunc(oHeroC,self,i,paramI,paramII)
				end
			end
		end
	end
end

--_hh.teamdefeat = function(self,oHeroK,tDefeatID)
--	local HeroTeam = self.data.HeroTeam
--	if type(HeroTeam)=="table" and HeroTeam.n>0 then
--		local IsLeaveTeam = 0
--		local nLeaveCount = 0
--		local oUnitL = self:getunit()
--		local tTeam
--		if oUnitL and type(oUnitL.data.team)=="table" then
--			tTeam = oUnitL.data.team
--		end
--		for i = 1,#HeroTeam do
--			local v = HeroTeam[i]
--			if type(v)=="table" and not(type(tDefeatID)=="table" and tDefeatID[v[1]]~=1) then
--				local oHeroC = hClass.hero:find(v[1])
--				if oHeroC and oHeroC.__ID==v[2] and oHeroC.data.IsDefeated~=1 then
--					nLeaveCount = nLeaveCount + 1
--					hGlobal.event:call("Event_HeroDefeated",oHeroC,oHeroK)
--					--print("Event_HeroDefeated")
--					local oUnitC = oHeroC:getunit()
--					if oUnitC then
--						oUnitC:dead(-1)
--					end
--					if IsLeaveTeam==1 then
--						self:teamremovemember(oHeroC,i,0)
--						oHeroC:setowner(0)
--					else
--						self:teamremoveunit(oHeroC.data.id,0)
--					end
--				end
--			end
--		end
--		if nLeaveCount>0 then
--			local oUnit = self:getunit()
--			if oUnit and type(oUnit.data.team)=="table" then
--				hGlobal.event:call("Event_TeamChange","remove",oUnit)
--			end
--		end
--	end
--end


--[[
local __loadAttrByItem = function(self,tItem,tempAttr)
	local ex_skill = self.data.ex_skill
	if type(ex_skill)~="table" then
		ex_skill = {}
		self.data.ex_skill = ex_skill
	end
	for i = 1,#tItem do
		local itemId = tItem[i]
		if itemId~=0 and hVar.tab_item[itemId] then
			hApi.GetEquipmentAttr(itemId,nil,tempAttr,1)
			local skillId = hVar.tab_item[itemId].skillId
			if skillId and skillId~=0 and hVar.tab_skill[skillId] then
				ex_skill[#ex_skill+1] = {skillId,1}
			end
		end
	end
end
]]
--[[
--给npc英雄加装备属性和技能
local __tempItems = {}
_hh.addattrbyitem = function(self,tItem)
	if type(tItem)=="number" then
		__tempItems[1] = tItem
		tItem = __tempItems
	end
	if type(tItem)=="table" then
		local tempAttr = {}
		__loadAttrByItem(self,tItem,tempAttr)
		if #tempAttr>0 then
			self:loadattr(tempAttr)
		end
	end
end
]]

--从triggerdata里面读取一遍自己的属性
local __TgrDataAttrKey = {"lea","led","str","int","con","mxhp","mxmp"}
_hh.loadtriggerdata = function(self,tgrDataU)
	local d = self.data
	if d.LoadTriggerData==1 then
		return
	end
	if type(tgrDataU)~="table" then
		local u = self:getunit("worldmap")
		if u~=nil then
			tgrDataU = u:gettriggerdata()
		end
	end
	if type(tgrDataU)~="table" then
		return
	end
	d.LoadTriggerData = 1
	--读取触发器英雄等级
	if tgrDataU.level~=nil then
--		self:levelup(tgrDataU.level,0)
	end
	--从dat 文件中获取当前单位的AImode
	if tgrDataU.AIMode~=nil then
		local oPlayer = self:getowner()
		if oPlayer and oPlayer.data.IsAIPlayer==1 then
			d.AIModeBasic = tgrDataU.AIMode or 0
			d.AIMode = tgrDataU.AIMode or 0
		end
	end
	--可能获得额外的属性加成
	local tempAttr = {}
	----如果是npc英雄，并具有额外装备，视同该英雄装备了这些装备 zhenkira delete 2016.7.12
	--if tgrDataU.EquipOnNpc~=nil and self:getowner()~=hGlobal.LocalPlayer then
	--	__loadAttrByItem(self,tgrDataU.EquipOnNpc,tempAttr)
	--end
	--如果具有额外技能，则视同英雄具有这些技能
	if tgrDataU.ExtraSkill~=nil then
		if type(self.data.ex_skill)~="table" then
			self.data.ex_skill = {}
		end
		local s = tgrDataU.ExtraSkill
		for i = 1,#s do
			local skillId = s[i]
			if hVar.tab_skill[skillId] then
				self.data.ex_skill[#self.data.ex_skill+1] = {skillId,1}
			end
		end
	end
	--如果拥有额外的属性加成
	for i = 1,#__TgrDataAttrKey do
		local k = __TgrDataAttrKey[i]
		if tgrDataU[k] and type(tgrDataU[k])=="number" then
			tempAttr[#tempAttr+1] = {k,tgrDataU[k]}
		end
	end
	if #tempAttr>0 then
		self:loadattr(tempAttr)
	end
end

--获取当前pvp经验值
_hh.getpvpexp = function(self)
	local a = self.attr
	return a.pvpexp or 0
end

--获取当前pvp等级
_hh.getpvplv = function(self)
	local a = self.attr
	return a.pvplv or 1
end

--英雄增加pvp经验(自动升级流程)
_hh.addpvpexp = function(self,exp)
	
	local d = self.data
	local a = self.attr
	local ret = false

	--
	if not exp or exp <= 0 then
		return ret
	end
	
	--获取英雄绑定的角色
	local bindU = self:getunit()
	
	--如果英雄没有绑定单位，说明英雄单位已经死亡此时不增加经验（todo:如果有其他判定死亡的方式这里需要继续添加）
	if not bindU or bindU == 0 then
		return ret
	end
	
	--获取当前等级及当前经验值
	local expNow = self:getpvpexp()				--当前经验值
	local lvNow = self:getpvplv()				--当前等级
	
	
	--人物可升级的最大等级。（如果未达到版本最大等级，升级经验可以超出，但不能升至下一级）
	local maxLv = hVar.HEOR_PVP_LV_MAX
	local w = hGlobal.WORLD.LastWorldMap
	if w then
		local mapInfo = w.data.tdMapInfo
		if mapInfo then
			maxLv = mapInfo.heroLvInPvpMap
		end
		--pve角色无局内升级
		if mapInfo.pveHeroMode > 0 then
			return ret
		end
	end
	
	
	
	--初步计算增加经验可提升的等级
	local tmpExp = expNow + exp
	local tmpLv = hApi.PvpGetLevelByExp(tmpExp)
	
	if tmpLv < maxLv then
		--如果小于等于最大等级，则直接修改经验及等级
		a.pvpexp = tmpExp
		a.pvplv = tmpLv
	elseif tmpLv >= maxLv then
		--如果大于版本等级，等级为版本等级，经验值为版本等级所对应的最小经验值
		local expInfo = hVar.HERO_PVP_EXP[maxLv]
		a.pvpexp = expInfo.minExp
		a.pvplv = maxLv
	end
	
	--如果到达的等级大于当前等级，并且当前等级小于最大等级
	if (lvNow < tmpLv) and (lvNow < maxLv) then
		local pvp_exp = self:getpvpexp()
		local pvp_lv = self:getpvplv()
		
		--绑定的角色技能升级
		self:pvpLvupAllSkill(bindU)
		
		--绑定的角色要进行属性重算（基础属性）
		bindU:SetPvpLevel(pvp_lv, pvp_exp)
		
		--附加道具属性（道具属性）
		self:refreshequip(bindU)
		
		--读取英雄主动类战术技能的原始CD
		--local tactics = hApi.GetHeroTactic(d.id)
		local tactics = self:gettactics()
		for i = 1, #tactics, 1 do
			local tactic = tactics[i]
			if tactic then
				local tacticId = tactic.id or 0
				local tacticLv = tactic.lv or 1
				if (tacticId > 0) and (tacticLv > 0) then
					local tabT = hVar.tab_tactics[tacticId]
					local typeT = tabT.type or hVar.TACTICS_TYPE.OTHER
					local activeSkill = tabT.activeSkill
					
					--技能释放
					if tabT and (typeT == hVar.TACTICS_TYPE.OTHER) and activeSkill then
						local activeSkillCDOrigin = tabT.activeSkill.cd[tacticLv] or 0 --原始CD（单位:秒）
						local activeSkillCDMul = activeSkillCDOrigin * 1000
						local active_skill_cd_delta = bindU:GetActiveSkillCDDelta() --geyachao: cd附加改变值
						local active_skill_cd_delta_rate = bindU:GetActiveSkillCDDeltaRate() --geyachao: cd附加改变比例值
						local delta = active_skill_cd_delta + hApi.floor(activeSkillCDMul * active_skill_cd_delta_rate / 100)
						activeSkillCDMul = activeSkillCDMul + delta
						local activeSkillCD = hApi.ceil(activeSkillCDMul / 1000)
						
						d.activeSkillCDOrigin = activeSkillCDOrigin --原始CD（单位:秒）
						d.activeSkillCD = activeSkillCD --CD（单位:秒）
						
						--print(d.name, "activeSkillCDOrigin=", activeSkillCDOrigin, "activeSkillCD=", activeSkillCD)
					end
				end
			end
		end
		
		--局内英雄升级事件:英雄,上一个等级,当前等级
		hGlobal.event:event("Event_HeroPvpLvUp", self, lvNow, pvp_lv)
	end
	
	--局内英雄增加经验事件:英雄,上一次经验,增加的经验,当前经验
	hGlobal.event:event("Event_HeroPvpAddExp", self, expNow, exp, tmpExp)
	
	ret = true
	
	return ret
	
end

_hh.pvpLvupAllSkill = function(self, u)
	
	local d = self.data
	local ret = false
	if not u or u == 0 then
		return ret
	end
	
	--技能最大等级
	local maxLv = hVar.HEOR_PVP_LV_MAX
	local w = hGlobal.WORLD.LastWorldMap
	if w then
		local mapInfo = w.data.tdMapInfo
		if mapInfo then
			maxLv = mapInfo.heroLvInPvpMap
		end
	end

	local tmpLvupLog = {}

	--读取天赋,自定义技能
	for i = 1, #d.talent do
		local talentObj = d.talent[i]
		local skillId = talentObj.id
		if not tmpLvupLog[skillId] then
			--当前技能等级增加
			talentObj.lv = math.min(talentObj.lv + 1, maxLv)
			--角色身上的技能等级增加
			u:lvupskill(skillId, maxLv)
			tmpLvupLog[skillId] = true

			--print("tmpLvupLog[skillId] = true:",skillId,maxLv)
		end
	end
	
	tmpLvupLog = {}
	--读取主动战术技能
	for i = 1, #d.tactics do
		local tacticObj = d.tactics[i]
		local tacticId = tacticObj.id
		if not tmpLvupLog[tacticId] then
			--当前技能等级增加
			tacticObj.lv = math.min(tacticObj.lv + 1, maxLv)
			tmpLvupLog[tacticId] = true
		end
	end
	
	ret = true
	return ret
end

--获取英雄主动战术技能
_hh.gettactics = function(self)
	local d = self.data
	return d.tactics
end

--Diablo重新加载存档信息
_hh.reloadHeroCard = function(self)
	local d = self.data
	local a = self.attr

	local id = self.data.id
	local HeroCard = hApi.GetHeroCardById(id)

	local ha = HeroCard.attr
		
	d.cexp = ha.exp or 0
	a.exp = ha.exp or 0
	a.level = ha.level or 1
end