--�����������(��������������Ҵ���װ���Ĵ洢)
local InventoryMgr = class("InventoryMgr")

	--���캯��
	function InventoryMgr:ctor()

		self._list = -1		--��ʼ��ʱ�Ƿ��Զ���db��ʼ����ҵĺ�װ����
		self._capacity = -1

		return self
	end
	--��ʼ������
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

	--��������
	function InventoryMgr:Release()
		self._list = -1
		self._capacity = -1
		
		return self
	end
	
	------------------------------------------------------------private-------------------------------------------------------
	
	------------------------------------------------------------public-------------------------------------------------------
	--��ȡ������������
	function InventoryMgr:GetItem(slot)
		return self._list[slot]
	end
	--���ñ�����������
	function InventoryMgr:SetItem(slot, item)
		self._list[slot] = item
	end
	--��ձ�����������
	function InventoryMgr:ClearItem(slot)
		self._list[slot] = 0
	end
	--��ȡ��������
	function InventoryMgr:GetCapacity()
		return self._capacity
	end
	--���ñ���������ֻ��vip����֮�������������ʱ��ʹ�ã�
	function InventoryMgr:SetCapacity(capacity)
		if capacity and capacity > self._capacity then
			for i = self._capacity + 1, capacity do
				self._list[i] = 0
			end
		end
	end
	--����������Ϣת����Cmd
	function InventoryMgr:InfoToCmd()
		local cmd = ""
		for i = 1, self._capacity do
			cmd = cmd .. (self._list[i]) .. ";"
		end

		cmd = self._capacity .. ";" .. cmd

		return cmd
	end

return InventoryMgr