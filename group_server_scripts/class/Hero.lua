--���Ӣ�۹�����
local Hero = class("Hero")

	--Ӣ�۽�����Ʒid
	Hero.HERO_UNLOCK_SHOPITEMID = 290
	--��ǰ���ŵ��Ǽ�����
	Hero.MAX_STAR_LV = 3
	
	--���캯��
	function Hero:ctor()
		self._id = -1
		self._star = -1
		self._soulstone = -1
		self._totalSoulstone = -1

		return self
	end
	--��ʼ������
	function Hero:Init(id,star,soulstone,totalSoulstone)
		self._id = id
		self._star = star or 1
		self._soulstone = soulstone or 0
		self._totalSoulstone = totalSoulstone or 0
		return self
	end
	
	--��������
	function Hero:Release()
		self._id = -1
		self._star = -1
		self._soulstone = -1
		self._totalSoulstone = -1
		
		return self
	end
	
	--��ȡӢ��Id
	function Hero:GetID()
		return self._id
	end
	--��ȡӢ���Ǽ�
	function Hero:GetStar()
		return self._star
	end
	--����Ӣ���Ǽ�
	function Hero:SetStar(star)
		self._star = star or 1
	end
	--��ȡӢ��ʣ�ཫ��
	function Hero:GetSoulstone()
		return self._soulstone
	end
	--��ȡӢ����ʷ�ϻ�õ����н���
	function Hero:GetTotalSoulstone()
		return self._totalSoulstone
	end
	--Ӣ�۽�������
	function Hero:AddSoulstone(num)
		local addNum = num or 0
		self._soulstone = self._soulstone + addNum
		self._totalSoulstone = self._totalSoulstone + addNum
	end
	--���Ӣ���Ƿ��������
	function Hero:CheckCanStarLvUp()
		local ret = false
		
		local star = self:GetStar()
		local soulstone = self:GetSoulstone()
		local heroId = self:GetID()
		local tabH = hVar.tab_hero[heroId]
		
		--�Ǽ��Ѿ����ڵ�ǰ�趨�����ȼ�������ʧ��
		if tabH and star < Hero.MAX_STAR_LV then
			local heroStarInfo = tabH.starInfo
			if heroStarInfo then
				local starInfo = heroStarInfo[star]
				local costSoulStone = starInfo.costSoulStone			--������һ����Ҫ��������
				
				--�����ǰ����С����Ҫ���ĵĽ��꣬����ʧ��
				if soulstone >= costSoulStone then
					ret = true
				end
			end
		end

		return ret
	end
	--Ӣ������
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
					local costSoulStone = starInfo.costSoulStone			--������һ����Ҫ��������
					self._star = self._star + 1
					self._soulstone = self._soulstone - costSoulStone
					ret = true
				end
			end
		end
		return ret
	end
	--��ȡ������������(����: ��Ӧ��Ʒid,��Ӧ����id,��Ϸ������,��������)
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

	--���Ӣ���Ƿ���Խ���
	function Hero:CheckCanUnlock()
		local ret = false
		
		local star = self:GetStar()
		local soulstone = self:GetSoulstone()
		local heroId = self:GetID()
		local tabH = hVar.tab_hero[heroId]
		
		--�Ǽ��Ѿ����ڵ�ǰ�趨�����ȼ�������ʧ��
		if star <= 0 then
			local unlockInfo = tabH.unlock
			if unlockInfo and unlockInfo.arenaUnlock then
				local costSoulStone = unlockInfo.costSoulStone			--������һ����Ҫ��������
				
				--�����ǰ����С����Ҫ���ĵĽ��꣬����ʧ��
				if soulstone >= costSoulStone then
					ret = true
				end
			end
		end

		return ret
	end
	--Ӣ�۽���
	function Hero:Unlock()
		local ret = false
		if self:CheckCanUnlock() then
			local star = self:GetStar()
			local heroId = self:GetID()
			local tabH = hVar.tab_hero[heroId]
			if tabH then
				local unlockInfo = tabH.unlock
				if unlockInfo then
					local costSoulStone = unlockInfo.costSoulStone			--������һ����Ҫ��������
					self._star = 1
					self._soulstone = self._soulstone - costSoulStone
					ret = true
				end
			end
		end
		return ret
	end
	--��ȡ������������(����: ��Ӧ��Ʒid,��Ӧ����id,��Ϸ������,��������)
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
	

	--������Ϣת��
	function Hero:InfoToCmd()
		local cmd = tostring(self:GetID()) .. ":" .. tostring(self:GetStar()) .. ":" .. tostring(self:GetSoulstone()) .. ":".. tostring(self:GetTotalSoulstone()) .. ";"
		return cmd
	end
return Hero