--玩家卡牌管理类
local Tactic = class("Tactic")

	Tactic.LVUP_BASE_ITEM = 10151			--战术技能卡升级对应的道具id
	Tactic.RESTORE_ADDONES_SHOPITEM = 346		--还原附加属性对应的道具id
	Tactic.REFRESH_ADDONES_SHOPITEM = 347		--刷新附加属性对应的道具id
	Tactic.NEW_ADDONES_SHOPITEM = 348		--新增附加属性对应的道具id

	Tactic.ADDONES_MAXNUM = 3			--最多可以支持n组附加属性
	Tactic.ADDONES_ATTR_MAXNUM = 3			--每组附加属性最多n条属性条目
    
	--构造函数
	function Tactic:ctor()
		self._id = -1
		self._lv = -1
		self._debris = -1
		self._totalDebris = -1
		self._addons = -1
		self._addonsNum = -1

		return self
	end
	--初始化函数
	function Tactic:Init(id,lv,debris,totalDebris, addonsNum, addons)
		self._id = id
		self._lv = lv or 0
		self._debris = debris or 0
		self._totalDebris = totalDebris or 0
		if self._debris > self._totalDebris then
			self._totalDebris = self._debris
		end

		if addonsNum and addonsNum > 0 and addons then
			self._addonsNum = addonsNum
			self._addons = addons
		else
			self._addonsNum = 0
			self._addons = {}
			self:NewAddOnes()
		end
		return self
	end
	--获取卡牌Id
	function Tactic:GetID()
		return self._id
	end
	--获取卡牌等级
	function Tactic:GetLv()
		return self._lv
	end
	--获取卡牌剩余碎片
	function Tactic:GetDebris()
		return self._debris
	end
	--获取卡牌历史上获得的所有碎片
	function Tactic:GetTotalDebris()
		return self._totalDebris
	end
	--获取卡牌当前附加属性数量
	function Tactic:GetAddOnsNum()
		return self._addonsNum
	end
	--卡牌碎片增加
	function Tactic:AddDebris(num)
		local addNum = num or 0
		self._debris = math.max(self._debris + addNum,0)
		if (addNum > 0) then
			self._totalDebris = math.max(self._totalDebris + addNum,0)
		end
	end
	--检测卡牌是否可以升级
	function Tactic:CheckCanLvUp()
		local ret = false
		
		local lv = self:GetLv()
		
		--等级已经大于当前设定的最大等级，返回失败
		if lv < hVar.TACTIC_LVUP_INFO.maxArmyLv and lv >= 0 then
			ret = true
		end

		return ret
	end
	--卡牌升级
	function Tactic:LvUp()
		local ret = false
		if self:CheckCanLvUp() then
			self._lv = self._lv + 1
			ret = true
		end
		return ret
	end
	--获取升级所需消耗(返回: 对应道具id,材料消耗,游戏币消耗,积分消耗)
	function Tactic:GetLvUpCost()
		local id = self:GetID()
		local lv = self:GetLv()
		local tTab = hVar.tab_tactics[id]
		local itemId = 0
		local materialList = {}
		local gamecoin = 0
		local score = 0
		if tTab and tTab.armLvupInfo then
			local lvupInfo = tTab.armLvupInfo[lv]
			if lvupInfo then
				itemId = Tactic.LVUP_BASE_ITEM + lv
				materialList = lvupInfo.material
				gamecoin = lvupInfo.gold
				score = lvupInfo.score
			end
		end

		return itemId,materialList,gamecoin,score
	end
	
	-----------------------------------------------------------------------------
	--检测卡牌是否可以刷新战术技能卡附加属性
	function Tactic:CheckCanRefreshAddOnes(idx)
		local ret = false

		local id = self:GetID()
		local tTab = hVar.tab_tactics[id]

		if tTab and tTab.addonesPool then
			if self._addons[idx] then
				ret = true
			end
		end

		return ret
	end
	--刷新战术技能卡附加属性
	function Tactic:RefreshAddOnes(idx)

		local ret = false
		
		local id = self:GetID()
		local tTab = hVar.tab_tactics[id]

		if tTab and tTab.addonesPool then

			local pool = tTab.addonesPool
			
			--判断当前属性组数量是否已经达到上限
			if self._addons[idx] then
				local addones = ""
				
				--根据属性条目进行随机
				for n = 1, Tactic.ADDONES_ATTR_MAXNUM do
					local value = math.random(1, pool.totalValue)
					local initialValue = 0
					--遍历，看权重落在哪个区段
					for i = 1, #pool do
						if value > initialValue and value <= initialValue + pool[i].value then
							addones = addones .. pool[i].attrAdd
							if n < Tactic.ADDONES_ATTR_MAXNUM then
								addones = addones .. "|"
							end
							break
						end
						initialValue = initialValue + pool[i].value
					end
				end
				
				self._addons[idx] = addones

				ret = true
			end
		end

		return ret
	end
	--获取刷新附加属性所需消耗(返回: 对应道具id,材料消耗,游戏币消耗,积分消耗)
	function Tactic:GetRefreshAddOnesCost()
		local id = self:GetID()
		local tTab = hVar.tab_tactics[id]

		local shopItemId = 0
		local itemId = 0
		local materialList = {}
		local gamecoin = 0
		local score = 0

		if tTab and tTab.addonesPool and tTab.addonesPool.cost then

			local costInfo = tTab.addonesPool.cost

			local shopItemId = costInfo.shopItemId or 0
			local tabShopItem = hVar.tab_shopitem[shopItemId]

			if tabShopItem then
				itemId = tabShopItem.itemID or 0
				gamecoin = tabShopItem.rmb
				score = tabShopItem.score
				materialList = costInfo.material
			end
		end

		return itemId,materialList,gamecoin,score
	end
	-----------------------------------------------------------------------------
	--检测卡牌是否可以添加新的附加属性
	function Tactic:CheckCanNewAddOnes()
		local ret = false

		local id = self:GetID()
		local tTab = hVar.tab_tactics[id]

		if tTab and tTab.addonesPool and tTab.addonesPool.initAttr then
			if self._addonsNum < Tactic.ADDONES_MAXNUM then
				ret = true
			end
		end

		return ret
	end
	--为战术技能卡添加新的附加属性
	function Tactic:NewAddOnes()

		local ret = false
		
		local id = self:GetID()
		local tTab = hVar.tab_tactics[id]

		if tTab and tTab.addonesPool then

			local pool = tTab.addonesPool
			
			if pool.initAttr then
				--判断当前属性组数量是否已经达到上限
				if self._addonsNum < Tactic.ADDONES_MAXNUM then

					local addones = ""
					
					--根据属性条目进行随机
					for n = 1, Tactic.ADDONES_ATTR_MAXNUM do
						--local value = math.random(1, pool.totalValue)
						--local initialValue = 0
						----遍历，看权重落在哪个区段
						--for i = 1, #pool do
						--	if value > initialValue and value <= initialValue + pool[i].value then
						--		addones = addones .. pool[i].attrAdd
						--		if n < Tactic.ADDONES_ATTR_MAXNUM then
						--			addones = addones .. "|"
						--		end
						--		break
						--	end
						--	initialValue = initialValue + pool[i].value
						--end
						addones = addones .. (pool.initAttr[n])
						if n < Tactic.ADDONES_ATTR_MAXNUM then
							addones = addones .. "|"
						end
					end
					
					self._addonsNum = self._addonsNum + 1
					self._addons[self._addonsNum] = addones

					ret = true
				end
			end
		end

		return ret
	end
	--获取添加新的附加属性所需消耗(返回: 对应道具id,材料消耗,游戏币消耗,积分消耗)
	function Tactic:GetNewAddOnesCost()
		local id = self:GetID()
		local tTab = hVar.tab_tactics[id]

		--local shopItemId = 0
		local itemId = 0
		local materialList = {}
		local gamecoin = 0
		local score = 0

		--if tTab and tTab.addonesPool and tTab.addonesPool.cost then
		if tTab then

			--local costInfo = tTab.addonesPool.cost

			local shopItemId = Tactic.NEW_ADDONES_SHOPITEM or 0
			local tabShopItem = hVar.tab_shopitem[shopItemId]

			if tabShopItem then
				itemId = tabShopItem.itemID or 0
				gamecoin = tabShopItem.rmb
				score = tabShopItem.score
				--materialList = costInfo.material
			end
		end

		return itemId,materialList,gamecoin,score
	end
	-----------------------------------------------------------------------------
	--检测卡牌是否可以还原战术技能卡附加属性
	function Tactic:CheckCanRestoreAddOnes(idx)
		local ret = false
		
		
		local id = self:GetID()
		local tTab = hVar.tab_tactics[id]
		
		--print("CheckCanRestoreAddOnes:",id,idx,tTab,tTab.addonesPool,self._addons[idx])

		if tTab and tTab.addonesPool and tTab.addonesPool.initAttr then
			if self._addons[idx] then
				ret = true
			end
		end

		return ret
	end
	--还原战术技能卡附加属性
	function Tactic:RestoreAddOnes(idx)

		local ret = false
		
		local id = self:GetID()
		local tTab = hVar.tab_tactics[id]

		if tTab and tTab.addonesPool then

			local pool = tTab.addonesPool
			
			if pool.initAttr then
				--判断当前属性组数量是否已经达到上限
				if self._addons[idx] then
					local addones = ""
					
					--根据属性条目进行随机
					for n = 1, Tactic.ADDONES_ATTR_MAXNUM do
						addones = addones .. (pool.initAttr[n])
						if n < Tactic.ADDONES_ATTR_MAXNUM then
							addones = addones .. "|"
						end
					end
					
					self._addons[idx] = addones

					ret = true
				end
			end
		end

		return ret
	end
	--获取还原附加属性所需消耗(返回: 对应道具id,材料消耗,游戏币消耗,积分消耗)
	function Tactic:GetRestoreAddOnesCost()
		local id = self:GetID()
		local tTab = hVar.tab_tactics[id]

		--local shopItemId = 0
		local itemId = 0
		local materialList = {}
		local gamecoin = 0
		local score = 0

		--if tTab and tTab.addonesPool and tTab.addonesPool.cost then
		if tTab then

			--local costInfo = tTab.addonesPool.cost

			local shopItemId = Tactic.RESTORE_ADDONES_SHOPITEM or 0
			local tabShopItem = hVar.tab_shopitem[shopItemId]

			if tabShopItem then
				itemId = tabShopItem.itemID or 0
				gamecoin = tabShopItem.rmb
				score = tabShopItem.score
				--materialList = costInfo.material
			end
		end

		return itemId,materialList,gamecoin,score
	end
	

	--附加属性信息转化
	function Tactic:AddOnesInfoToCmd()
		local cmd = ""
		for i = 1, self._addonsNum do
			cmd = cmd .. self._addons[i]
			if i < self._addonsNum then
				cmd = cmd .. ":"
			end
		end

		cmd = self._addonsNum .. ":" .. cmd

		return cmd
	end
	--基本信息转化
	function Tactic:InfoToCmd()
		local cmd = tostring(self:GetID()) .. ":" .. tostring(self:GetDebris()) .. ":".. tostring(self:GetTotalDebris()) .. ":" .. tostring(self:GetLv()) .. ":" .. self:AddOnesInfoToCmd() .. ";"
		return cmd
	end
return Tactic