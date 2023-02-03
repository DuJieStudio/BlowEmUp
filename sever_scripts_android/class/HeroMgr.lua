--战术技能卡管理类
local HeroMgr = class("HeroMgr")

	--构造函数
	function HeroMgr:ctor()
		
		self._heroNum = -1		--玩家英雄数量
		self._heroDic = -1		--存储玩家所有英雄信息
		
		--其他
		return self
	end
	--初始化函数
	function HeroMgr:Init(heroInfo)
		
		--初始化战术技能卡信息
		self._heroDic = {}
		self._heroNum = 0
		
		--print("HeroMgr:Init 1")
		self:_InitHeroInfo(heroInfo)
		--print("HeroMgr:Init 2")
		
		return self
	end
	--析构函数
	function HeroMgr:Release()

		for k, h in pairs(self._heroDic) do
			if h and type(h) == "table" and h:getCName() == "Hero" then
				h:Release()
				h = nil
			else
				h = nil
			end
		end
		self._heroDic = -1
		self._heroNum = -1
		
		return self
	end
	
	------------------------------------------------------------private-------------------------------------------------------
	
	--初始化英雄信息
	function HeroMgr:_InitHeroInfo(heroInfo)
		--print("初始化英雄信息", heroInfo)
		if heroInfo then
			local tHeroInfo = hApi.Split(heroInfo or "", ";")
			self._heroNum = tonumber(tHeroInfo[1]) or 0
			local infoIdx = 1
			
			--遍历所有英雄
			for i = 1, self._heroNum do
				local heroList = tHeroInfo[infoIdx + i] or ""
				--local tHeroList = hApi.Split(heroList,":")
				--local id = tonumber(tHeroList[1]) or 0
				--local star = tonumber(tHeroList[2]) or 1
				--local num = tonumber(tHeroList[3]) or 0
				--local totalNum = tonumber(tHeroList[4]) or 0
				
				--if id > 0 then
				--	self._heroDic[id] = hClass.Hero:create():Init(id, star, num, totalNum)
				--end
				
				local oHero = hClass.Hero:create()
				
				--print("遍历所有英雄" .. i, "oHero=", oHero)
				if oHero:InitByProtoBuf(heroList) then
					self._heroDic[oHero:GetID()] = oHero
					--print("self._heroDic[oHero:GetID()] = oHero")
				else
					oHero = nil
					--print("oHero = nil")
				end
			end
		end
	end

	------------------------------------------------------------public-------------------------------------------------------
	
	--获取英雄
	function HeroMgr:GetHero(heroId)
		return self._heroDic[heroId]
	end
	
	--添加英雄
	function HeroMgr:AddNewHero(id)
		local ret
		if id > 0 then
			if not self:GetHero(id) then
				local star = 1
				local totalSoulStone = 0
				if hVar.tab_hero[id] and hVar.tab_hero[id].starInfo and hVar.tab_hero[id].starInfo[star] then
					totalSoulStone = hVar.tab_hero[id].starInfo[star].toSoulStone
				end
				self._heroDic[id] = hClass.Hero:create():Init(id, (star or 1), 0, totalSoulStone)
				self._heroNum = self._heroNum + 1
			end
			ret = self:GetHero(id)
		end
		return ret
	end
	
	--增加英雄将魂碎片
	function HeroMgr:AddHeroSoulstone(id,num)
		local ret = false
		if id > 0 and num > 0 then
			local hero = self:GetHero(id)
			if hero then
				hero:AddSoulstone(num)
				ret = true
			else
				local star = 1
				local tabH = hVar.tab_hero[id]
				if tabH and tabH.unlock and tabH.unlock.arenaUnlock then
					star = 0
				end
				self._heroDic[id] = hClass.Hero:create():Init(id, star, num, num)
				ret = true
			end
		end
		return ret
	end

	function HeroMgr:InfoToCmd()
		local cmd = ""
		
		for id, hero in pairs(self._heroDic) do
			cmd = cmd .. (hero:InfoToCmd())
		end
		
		cmd = (self._heroNum) .. ";" .. cmd
		return cmd
	end

return HeroMgr