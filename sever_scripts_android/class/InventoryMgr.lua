--背包配管理类(可用作背包和玩家穿着装备的存储)
local InventoryMgr = class("InventoryMgr")

	--构造函数
	function InventoryMgr:ctor()

		self._list = -1		--初始化时是否自动从db初始化玩家的红装数据
		self._capacity = -1

		return self
	end
	--初始化函数
	function InventoryMgr:Init(capacity, itemInfo)

		self._list = {}
		self._capacity = capacity or 0
	
		if itemInfo then
			if type(itemInfo) == "table" then
				for i = 1, self._capacity do
					self._list[i] = itemInfo[i]
				end
			elseif type(itemInfo) == "string" then
				local tItemInfo = hApi.Split(itemInfo or "", ";")
				local itemNum = tonumber(tItemInfo[1]) or 0
				self._capacity = math.max(itemNum,self._capacity)
				for i = 1, self._capacity do
					self._list[i] = tonumber(tItemInfo[i + 1]) or 0
				end
			end
		else
			for i = 1, self._capacity do
				self._list[i] = 0
			end
		end
		
		return self
	end

	--析构函数
	function InventoryMgr:Release()
		self._list = -1
		self._capacity = -1
		
		return self
	end
	
	------------------------------------------------------------private-------------------------------------------------------
	
	------------------------------------------------------------public-------------------------------------------------------
	--获取背包格子内容
	function InventoryMgr:GetItem(slot)
		return self._list[slot]
	end
	--设置背包格子内容
	function InventoryMgr:SetItem(slot, item)
		self._list[slot] = item
	end
	--清空背包格子内容
	function InventoryMgr:ClearItem(slot)
		self._list[slot] = 0
	end
	--获取背包容量
	function InventoryMgr:GetCapacity()
		return self._capacity
	end
	--设置背包容量（只有vip增加之后道具容量增加时才使用）
	function InventoryMgr:SetCapacity(capacity)
		if capacity and capacity > self._capacity then
			for i = self._capacity + 1, capacity do
				self._list[i] = 0
			end
		end
	end
	--背包格子信息转化成Cmd
	function InventoryMgr:InfoToCmd()
		local cmd = ""
		for i = 1, self._capacity do
			cmd = cmd .. (self._list[i]) .. ";"
		end

		cmd = self._capacity .. ";" .. cmd

		return cmd
	end

return InventoryMgr