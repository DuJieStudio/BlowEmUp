--��ҿ��ƹ�����
local Tactic = class("Tactic")

	Tactic.LVUP_BASE_ITEM = 10151			--ս�����ܿ�������Ӧ�ĵ���id
	Tactic.RESTORE_ADDONES_SHOPITEM = 346		--��ԭ�������Զ�Ӧ�ĵ���id
	Tactic.REFRESH_ADDONES_SHOPITEM = 347		--ˢ�¸������Զ�Ӧ�ĵ���id
	Tactic.NEW_ADDONES_SHOPITEM = 348		--�����������Զ�Ӧ�ĵ���id

	Tactic.ADDONES_MAXNUM = 3			--������֧��n�鸽������
	Tactic.ADDONES_ATTR_MAXNUM = 3			--ÿ�鸽���������n��������Ŀ
    
	--���캯��
	function Tactic:ctor()
		self._id = -1
		self._lv = -1
		self._debris = -1
		self._totalDebris = -1
		self._addons = -1
		self._addonsNum = -1

		return self
	end
	--��ʼ������
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
	--��ȡ����Id
	function Tactic:GetID()
		return self._id
	end
	--��ȡ���Ƶȼ�
	function Tactic:GetLv()
		return self._lv
	end
	--��ȡ����ʣ����Ƭ
	function Tactic:GetDebris()
		return self._debris
	end
	--��ȡ������ʷ�ϻ�õ�������Ƭ
	function Tactic:GetTotalDebris()
		return self._totalDebris
	end
	--��ȡ���Ƶ�ǰ������������
	function Tactic:GetAddOnsNum()
		return self._addonsNum
	end
	--������Ƭ����
	function Tactic:AddDebris(num)
		local addNum = num or 0
		self._debris = math.max(self._debris + addNum,0)
		if (addNum > 0) then
			self._totalDebris = math.max(self._totalDebris + addNum,0)
		end
	end
	--��⿨���Ƿ��������
	function Tactic:CheckCanLvUp()
		local ret = false
		
		local lv = self:GetLv()
		
		--�ȼ��Ѿ����ڵ�ǰ�趨�����ȼ�������ʧ��
		if lv < hVar.TACTIC_LVUP_INFO.maxArmyLv and lv >= 0 then
			ret = true
		end

		return ret
	end
	--��������
	function Tactic:LvUp()
		local ret = false
		if self:CheckCanLvUp() then
			self._lv = self._lv + 1
			ret = true
		end
		return ret
	end
	--��ȡ������������(����: ��Ӧ����id,��������,��Ϸ������,��������)
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
	--��⿨���Ƿ����ˢ��ս�����ܿ���������
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
	--ˢ��ս�����ܿ���������
	function Tactic:RefreshAddOnes(idx)

		local ret = false
		
		local id = self:GetID()
		local tTab = hVar.tab_tactics[id]

		if tTab and tTab.addonesPool then

			local pool = tTab.addonesPool
			
			--�жϵ�ǰ�����������Ƿ��Ѿ��ﵽ����
			if self._addons[idx] then
				local addones = ""
				
				--����������Ŀ�������
				for n = 1, Tactic.ADDONES_ATTR_MAXNUM do
					local value = math.random(1, pool.totalValue)
					local initialValue = 0
					--��������Ȩ�������ĸ�����
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
	--��ȡˢ�¸���������������(����: ��Ӧ����id,��������,��Ϸ������,��������)
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
	--��⿨���Ƿ��������µĸ�������
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
	--Ϊս�����ܿ�����µĸ�������
	function Tactic:NewAddOnes()

		local ret = false
		
		local id = self:GetID()
		local tTab = hVar.tab_tactics[id]

		if tTab and tTab.addonesPool then

			local pool = tTab.addonesPool
			
			if pool.initAttr then
				--�жϵ�ǰ�����������Ƿ��Ѿ��ﵽ����
				if self._addonsNum < Tactic.ADDONES_MAXNUM then

					local addones = ""
					
					--����������Ŀ�������
					for n = 1, Tactic.ADDONES_ATTR_MAXNUM do
						--local value = math.random(1, pool.totalValue)
						--local initialValue = 0
						----��������Ȩ�������ĸ�����
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
	--��ȡ����µĸ���������������(����: ��Ӧ����id,��������,��Ϸ������,��������)
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
	--��⿨���Ƿ���Ի�ԭս�����ܿ���������
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
	--��ԭս�����ܿ���������
	function Tactic:RestoreAddOnes(idx)

		local ret = false
		
		local id = self:GetID()
		local tTab = hVar.tab_tactics[id]

		if tTab and tTab.addonesPool then

			local pool = tTab.addonesPool
			
			if pool.initAttr then
				--�жϵ�ǰ�����������Ƿ��Ѿ��ﵽ����
				if self._addons[idx] then
					local addones = ""
					
					--����������Ŀ�������
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
	--��ȡ��ԭ����������������(����: ��Ӧ����id,��������,��Ϸ������,��������)
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
	

	--����������Ϣת��
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
	--������Ϣת��
	function Tactic:InfoToCmd()
		local cmd = tostring(self:GetID()) .. ":" .. tostring(self:GetDebris()) .. ":".. tostring(self:GetTotalDebris()) .. ":" .. tostring(self:GetLv()) .. ":" .. self:AddOnesInfoToCmd() .. ";"
		return cmd
	end
return Tactic