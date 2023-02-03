--玩家英雄管理类
local Hero = class("Hero")

	--英雄解锁商品id
	Hero.HERO_UNLOCK_SHOPITEMID = 290
	--当前开放的星级上限
	Hero.MAX_STAR_LV = 3
	
	--构造函数
	function Hero:ctor()
		self._id = -1
		self._star = -1
		self._soulstone = -1
		self._totalSoulstone = -1

		return self
	end
	--初始化函数
	function Hero:Init(id,star,soulstone,totalSoulstone)
		self._id = id
		self._star = star or 1
		self._soulstone = soulstone or 0
		self._totalSoulstone = totalSoulstone or 0
		return self
	end
	
	--析构函数
	function Hero:Release()
		self._id = -1
		self._star = -1
		self._soulstone = -1
		self._totalSoulstone = -1
		
		return self
	end
	
	--获取英雄Id
	function Hero:GetID()
		return self._id
	end
	--获取英雄星级
	function Hero:GetStar()
		return self._star
	end
	--设置英雄星级
	function Hero:SetStar(star)
		self._star = star or 1
	end
	--获取英雄剩余将魂
	function Hero:GetSoulstone()
		return self._soulstone
	end
	--获取英雄历史上获得的所有将魂
	function Hero:GetTotalSoulstone()
		return self._totalSoulstone
	end
	--英雄将魂增加
	function Hero:AddSoulstone(num)
		local addNum = num or 0
		self._soulstone = self._soulstone + addNum
		self._totalSoulstone = self._totalSoulstone + addNum
	end
	--检测英雄是否可以升星
	function Hero:CheckCanStarLvUp()
		local ret = false
		
		local star = self:GetStar()
		local soulstone = self:GetSoulstone()
		local heroId = self:GetID()
		local tabH = hVar.tab_hero[heroId]
		
		--星级已经大于当前设定的最大等级，返回失败
		if tabH and star < Hero.MAX_STAR_LV then
			local heroStarInfo = tabH.starInfo
			if heroStarInfo then
				local starInfo = heroStarInfo[star]
				local costSoulStone = starInfo.costSoulStone			--升至下一级需要将魂数量
				
				--如果当前将魂小于需要消耗的将魂，返回失败
				if soulstone >= costSoulStone then
					ret = true
				end
			end
		end

		return ret
	end
	--英雄升星
	function Hero:StarLvUp()
		local ret = false
		if self:CheckCanStarLvUp() then
			local star = self:GetStar()
			local heroId = self:GetID()
			local tabH = hVar.tab_hero[heroId]
			if tabH then
				local heroStarInfo = tabH.starInfo
				if heroStarInfo then
					local starInfo = heroStarInfo[star]
					local costSoulStone = starInfo.costSoulStone			--升至下一级需要将魂数量
					self._star = self._star + 1
					self._soulstone = self._soulstone - costSoulStone
					ret = true
				end
			end
		end
		return ret
	end
	--获取升星所需消耗(返回: 对应商品id,对应道具id,游戏币消耗,积分消耗)
	function Hero:GetStarLvUpCost()
		local star = self:GetStar()
		local shopItemId = 0
		local itemId = 0
		local gamecoin = 0
		local score = 0
		local heroId = self:GetID()
		local tabH = hVar.tab_hero[heroId]
		if tabH then
			local heroStarInfo = tabH.starInfo
			if heroStarInfo then
				local starInfo = heroStarInfo[star]
				shopItemId = starInfo.shopItemId or 0
				local tabShopItem = hVar.tab_shopitem[shopItemId]
				if tabShopItem then
					itemId = tabShopItem.itemID or 0
					gamecoin = tabShopItem.rmb
					score = tabShopItem.score
				end
			end
		end
		return shopItemId,itemId,gamecoin,score
	end

	--检测英雄是否可以解锁
	function Hero:CheckCanUnlock()
		local ret = false
		
		local star = self:GetStar()
		local soulstone = self:GetSoulstone()
		local heroId = self:GetID()
		local tabH = hVar.tab_hero[heroId]
		
		--星级已经大于当前设定的最大等级，返回失败
		if star <= 0 then
			local unlockInfo = tabH.unlock
			if unlockInfo and unlockInfo.arenaUnlock then
				local costSoulStone = unlockInfo.costSoulStone			--升至下一级需要将魂数量
				
				--如果当前将魂小于需要消耗的将魂，返回失败
				if soulstone >= costSoulStone then
					ret = true
				end
			end
		end

		return ret
	end
	--英雄解锁
	function Hero:Unlock()
		local ret = false
		if self:CheckCanUnlock() then
			local star = self:GetStar()
			local heroId = self:GetID()
			local tabH = hVar.tab_hero[heroId]
			if tabH then
				local unlockInfo = tabH.unlock
				if unlockInfo then
					local costSoulStone = unlockInfo.costSoulStone			--升至下一级需要将魂数量
					self._star = 1
					self._soulstone = self._soulstone - costSoulStone
					ret = true
				end
			end
		end
		return ret
	end
	--获取解锁所需消耗(返回: 对应商品id,对应道具id,游戏币消耗,积分消耗)
	function Hero:GetUnlockCost()
		local shopItemId = 0
		local itemId = 0
		local gamecoin = 0
		local score = 0

		shopItemId = Hero.HERO_UNLOCK_SHOPITEMID or 0
		local tabShopItem = hVar.tab_shopitem[shopItemId]
		if tabShopItem then
			itemId = tabShopItem.itemID or 0
			gamecoin = tabShopItem.rmb
			score = tabShopItem.score
		end

		return shopItemId,itemId,gamecoin,score
	end
	

	--基本信息转化
	function Hero:InfoToCmd()
		local cmd = tostring(self:GetID()) .. ":" .. tostring(self:GetStar()) .. ":" .. tostring(self:GetSoulstone()) .. ":".. tostring(self:GetTotalSoulstone()) .. ";"
		return cmd
	end
return Hero