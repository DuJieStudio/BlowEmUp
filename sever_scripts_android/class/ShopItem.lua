--��Ʒ��
local ShopItem = class("ShopItem")
	
	--���캯��
	function ShopItem:ctor()

		self._id = -1				--��ƷID
		self._itemID = -1			--��Ʒ��Ӧ����ID
		self._num = -1				--��Ʒ��Ӧ���ߵ�����(������Ƭ20��)
		self._score = -1			--��Ʒ���ۼ�(����)
		self._rmb = -1				--��Ʒ���ۼ�(rmb)
		self._crystal = -1			--��Ʒ���ۼ�(��װ��ʯ)��ֻ�к�װ���Ҷһ������ĺ�װ��ʯ
		self._cangbaotu = -1			--��Ʒ���ۼ�(�ر�ͼ)��ֻ�вر�ͼ�̵�һ������Ĳر�ͼ
		self._cangbaotu_high = -1		--��Ʒ���ۼ�(�߼��ر�ͼ)��ֻ�и߼��ر�ͼ�̵�һ������Ĳر�ͼ
		
		self._quota = -1			--����������(-1��ʾ����������)
		self._saleCount = -1			--����������(-1��ʾ����������)
		
		return self
	end
	
	--��ʼ������
	function ShopItem:Init(id,quota,itemId,num,score,rmb,saledCount)
		
		local tShopItem = hVar.tab_shopitem[id]
		if tShopItem then
			
			self._id = id						--��ƷID
			self._itemID = itemId or tShopItem.itemID		--��Ʒ��Ӧ����ID
			self._num = num or tShopItem.num or 1			--��Ʒ��Ӧ���ߵ�����(������Ƭ20��)
			self._score = score or tShopItem.score or 0		--��Ʒ���ۼ�(����)
			self._rmb = rmb or tShopItem.rmb or 0			--��Ʒ���ۼ�(rmb)
			self._crystal = tShopItem.crystal or 0			--��Ʒ���ۼ�(��װ��ʯ)��ֻ�к�װ���Ҷһ������ĺ�װ��ʯ
			self._cangbaotu = tShopItem.cangbaotu or 0		--��Ʒ���ۼ�(�ر�ͼ)��ֻ�вر�ͼ�̵�һ������Ĳر�ͼ
			self._cangbaotu_high = tShopItem.cangbaotu_high or 0	--��Ʒ���ۼ�(�߼��ر�ͼ)��ֻ�и߼��ر�ͼ�̵�һ������Ĳر�ͼ
			
			self._quota = quota or -1				--����������(-1��ʾ����������)
			self._saledCount = saledCount or 0			--����������
			
			return self
		end
	end
	
	--------------------------------------------------------------------------------------------------------------
	--��ȡ��ƷID
	function ShopItem:GetID()
		return self._id
	end
	--��ȡ��Ʒ��Ӧ����ID
	function ShopItem:GetItemID()
		return self._itemID
	end
	--��ȡ��Ʒ��Ӧ���ߵ�����
	function ShopItem:GetItemNum()
		return self._num
	end
	--��ȡ��Ʒ���ۼ�(����)
	function ShopItem:GetScoreCost()
		return self._score
	end
	--��ȡ��Ʒ���ۼ�(rmb)
	function ShopItem:GetRmbCost()
		return self._rmb
	end
	--��ȡ��Ʒ���ۼ�(crystal)
	function ShopItem:GetCrystalCost()
		return self._crystal
	end
	--��ȡ��Ʒ���ۼ�(cangbaotu)
	function ShopItem:GetCangBaoTuCost()
		return self._cangbaotu
	end
	--��ȡ��Ʒ���ۼ�(cangbaotu_high)
	function ShopItem:GetCangBaoTuHighCost()
		return self._cangbaotu_high
	end
	--��ȡ����������
	function ShopItem:GetQuota()
		return self._quota
	end
	--��ȡ��ǰ�Ѿ���������
	function ShopItem:GetSaledCount()
		return self._saledCount
	end
	--���ӵ�ǰ�Ѿ���������
	function ShopItem:AddSaledCount()
		self._saledCount = self._saledCount + 1
	end
	
	--���δ�����װ����
	function ShopItem:_DBGetNotGainRedEquipCount(uid)
		
		local sql = string.format("SELECT u.notgain_redequip FROM t_user as u where u.uid=%d",uid)
		local err,notgain_redequip = xlDb_Query(sql)
		if err == 0 then
			
		end
		
		return (notgain_redequip or 0)
	end
	
	--���δ����������ʯ�һ���װ����
	function ShopItem:_DBGetNotGainRedCrystalCount(uid)
		
		local sql = string.format("SELECT u.notgain_redcrystal FROM t_user as u where u.uid=%d",uid)
		local err,notgain_redcrystal = xlDb_Query(sql)
		if err == 0 then
			
		end
		
		return (notgain_redcrystal or 0)
	end
	
	--����δ�����װ����
	function ShopItem:_DBSetNotGainRedEquipCount(uid)
		
		local sql = string.format("UPDATE t_user SET `notgain_redequip` = `notgain_redequip` + 1 where uid=%d",uid)
		local err = xlDb_Execute(sql)
	end
	
	--����δ�����װ����*5
	function ShopItem:_DBSetNotGainRedEquipCount5(uid)
		
		local sql = string.format("UPDATE t_user SET `notgain_redequip` = `notgain_redequip` + 5 where uid=%d",uid)
		local err = xlDb_Execute(sql)
	end
	
	--����δ�����װ����*10
	function ShopItem:_DBSetNotGainRedEquipCount10(uid)
		
		local sql = string.format("UPDATE t_user SET `notgain_redequip` = `notgain_redequip` + 10 where uid=%d",uid)
		local err = xlDb_Execute(sql)
	end
	
	--���δ�����װ����
	function ShopItem:_DBClearNotGainRedEquipCount(uid)
		local sql = string.format("UPDATE t_user SET `notgain_redequip` = 0 where uid=%d",uid)
		local err = xlDb_Execute(sql)
	end
	
	--����δ����һ�������ʯ��װ����
	function ShopItem:_DBSetNotGainRedCrystalCount(uid)
		
		local sql = string.format("UPDATE t_user SET `notgain_redcrystal` = `notgain_redcrystal` + 1 where uid=%d",uid)
		local err = xlDb_Execute(sql)
	end
	
	--����δ����һ�������ʯ��װ����*5
	function ShopItem:_DBSetNotGainRedCrystalCount5(uid)
		
		local sql = string.format("UPDATE t_user SET `notgain_redcrystal` = `notgain_redcrystal` + 5 where uid=%d",uid)
		local err = xlDb_Execute(sql)
	end
	
	--����δ����һ�������ʯ��װ����*10
	function ShopItem:_DBSetNotGainRedCrystalCount10(uid)
		
		local sql = string.format("UPDATE t_user SET `notgain_redcrystal` = `notgain_redcrystal` + 10 where uid=%d",uid)
		local err = xlDb_Execute(sql)
	end
	
	--���δ����һ�������ʯ��װ����
	function ShopItem:_DBClearNotGainRedCrystalCount(uid)
		local sql = string.format("UPDATE t_user SET `notgain_redcrystal` = 0 where uid=%d",uid)
		local err = xlDb_Execute(sql)
	end
	
	--��һ�ȡ����
	--��������todo
	--���ݲ�ͬ��Ʒ������ͬreward
	--user:takereward
	--���ݲ�ͬ��Ʒˢ�²�ͬ������
	function ShopItem:DBGetItem(udbid, rid, cRedequipCrystal)
		
		local ret = false
		local itemId = self:GetItemID()
		local itemNum = self:GetItemNum()
		--print(itemId,itemNum)
		--�������id�Ϸ������ҵ�����������0
		if itemId > 0 and hVar.tab_item[itemId] and itemNum > 0 then
			
			--���ҵ���
			if itemId >= hClass.Chest.TYPE.COPPER and itemId <= hClass.Chest.TYPE.CHEST_TYPE_MAXNUM then
				
				if itemId >= hClass.Chest.TYPE.COPPER and itemId <= hClass.Chest.TYPE.GOLD then --��ͨ����
					--todo
				elseif itemId == hClass.Chest.TYPE.ARENA then --��̨����
					--todo
				elseif (itemId == hClass.Chest.TYPE.REDEQUIP) or (itemId == hClass.Chest.TYPE.REDEQUIP_CRYSTAL) then --��װ���ҡ�������ʯ�һ�
					
					local chest = hClass.Chest:create():Init(itemId,0)	--��װ����
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local notgain_redequip = 0
						local NOTGAIN_MAX = 0
						if cRedequipCrystal then
							--������ʯ�һ�
							notgain_redequip = self:_DBGetNotGainRedCrystalCount(udbid)
							NOTGAIN_MAX = hVar.NOTGAIN_REDCRYSTAL_MAX
						else
							--��������
							notgain_redequip = self:_DBGetNotGainRedEquipCount(udbid)
							NOTGAIN_MAX = hVar.NOTGAIN_REDEQUIP_MAX
						end
						local chestid = chest:GetID()
						local mustRed = false
						
						if notgain_redequip >= NOTGAIN_MAX then
							mustRed = true
						end
						
						local reward = chest:Open(mustRed)
						--������������˵��ߣ��򶪸�user����
						if reward then
							--ʣ�࿪��ʱ�� * ÿ�����ĵ���Ϸ��
							
							--����������������
							if cRedequipCrystal then
								reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_REDDEBRIS"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDDEBRIS)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							else
								reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_REDCHEST"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDCHEST)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							end
							self:AddSaledCount()
							--���δ��ú�װ����Ҫ����ͳ��ֵ,������ո�ֵ
							if not reward:HaveDrop(hClass.Reward.TYPE.REDEQUIP) then
								if cRedequipCrystal then
									--������ʯ�һ�
									self:_DBSetNotGainRedCrystalCount(udbid)
								else
									--��������
									self:_DBSetNotGainRedEquipCount(udbid)
								end
							else
								if cRedequipCrystal then
									--������ʯ�һ�
									self:_DBClearNotGainRedCrystalCount(udbid)
								else
									--��������
									self:_DBClearNotGainRedEquipCount(udbid)
								end
							end
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.REDEQUIP_FIVE) or (itemId == hClass.Chest.TYPE.REDEQUIP_CRYSTAL_FIVE) then --��װ����*5��������ʯ�һ�*5
					
					local chest = hClass.Chest:create():Init(itemId,0)	--��װ����
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local notgain_redequip = 0
						local NOTGAIN_MAX = 0
						if cRedequipCrystal then
							--������ʯ�һ�
							notgain_redequip = self:_DBGetNotGainRedCrystalCount(udbid)
							NOTGAIN_MAX = hVar.NOTGAIN_REDCRYSTAL_MAX
						else
							--��������
							notgain_redequip = self:_DBGetNotGainRedEquipCount(udbid)
							NOTGAIN_MAX = hVar.NOTGAIN_REDEQUIP_MAX
						end
						local chestid = chest:GetID()
						local mustRed = false
						
						if notgain_redequip >= NOTGAIN_MAX then
							mustRed = true
						end
						
						local reward = chest:Open(mustRed)
						--������������˵��ߣ��򶪸�user����
						if reward then
							--ʣ�࿪��ʱ�� * ÿ�����ĵ���Ϸ��
							
							--����������������
							if cRedequipCrystal then
								reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_REDDEBRIS"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDDEBRIS)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							else
								reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_REDCHEST"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDCHEST)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							end
							self:AddSaledCount()
							--���δ��ú�װ����Ҫ����ͳ��ֵ,������ո�ֵ
							if not reward:HaveDrop(hClass.Reward.TYPE.REDEQUIP) then
								if cRedequipCrystal then
									--������ʯ�һ�
									self:_DBSetNotGainRedCrystalCount5(udbid)
								else
									--��������
									self:_DBSetNotGainRedEquipCount5(udbid)
								end
							else
								if cRedequipCrystal then
									--������ʯ�һ�
									self:_DBClearNotGainRedCrystalCount(udbid)
								else
									--��������
									self:_DBClearNotGainRedEquipCount(udbid)
								end
							end
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.CANGBAOTU_NORMAL_CRYSTAL) then --�ر�ͼ�һ�
					
					local chest = hClass.Chest:create():Init(itemId,0)	--�ر�ͼ
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local chestid = chest:GetID()
						local reward = chest:Open()
						--������������˵��ߣ��򶪸�user����
						if reward then
							--ʣ�࿪��ʱ�� * ÿ�����ĵ���Ϸ��
							
							--����������������
							reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_CANGBAOTU"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_CANGBAOTU)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							self:AddSaledCount()
							
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.CANGBAOTU_HIGH_CRYSTAL) then --�߼��ر�ͼ�һ�
					
					local chest = hClass.Chest:create():Init(itemId,0)	--�߼��ر�ͼ
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local chestid = chest:GetID()
						local reward = chest:Open()
						--������������˵��ߣ��򶪸�user����
						if reward then
							--ʣ�࿪��ʱ�� * ÿ�����ĵ���Ϸ��
							
							--����������������
							reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_CANGBAOTU_HIGH"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_CANGBAOTU_HIGH)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							self:AddSaledCount()
							
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.YELLOWEQUIP) or (itemId == hClass.Chest.TYPE.YELLOWEQUIP_FIVE) then --��װ���ҡ���װ����*5
					
					local chest = hClass.Chest:create():Init(itemId,0)	--��װ����
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local chestid = chest:GetID()
						local reward = chest:Open()
						--������������˵��ߣ��򶪸�user����
						if reward then
							--ʣ�࿪��ʱ�� * ÿ�����ĵ���Ϸ��
							
							--����������������
							reward:TakeReward(udbid, rid, nil, cRedequipCrystal)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							self:AddSaledCount()
							
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.REDCHEST_ONCE) or (itemId == hClass.Chest.TYPE.REDCHEST_ONCE_FREE) then --���������һ�Ρ�����������ѳ�һ��
					
					local chest = hClass.Chest:create():Init(itemId,0)	--��װ����
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local notgain_redequip = self:_DBGetNotGainRedEquipCount(udbid)
						local NOTGAIN_MAX = hVar.NOTGAIN_REDEQUIP_MAX
						local chestid = chest:GetID()
						local mustRed = false
						
						if notgain_redequip >= NOTGAIN_MAX then
							mustRed = true
						end
						
						local reward = chest:Open(mustRed)
						--������������˵��ߣ��򶪸�user����
						if reward then
							--ʣ�࿪��ʱ�� * ÿ�����ĵ���Ϸ��
							
							--����������������
							reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_REDCHEST"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDCHEST)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							
							self:AddSaledCount()
							--���δ��ú�װ����Ҫ����ͳ��ֵ,������ո�ֵ
							if not reward:HaveDrop(hClass.Reward.TYPE.REDEQUIP) then
								self:_DBSetNotGainRedEquipCount(udbid)
							else
								self:_DBClearNotGainRedEquipCount(udbid)
							end
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.REDCHEST_TENTH) or (itemId == hClass.Chest.TYPE.REDCHEST_TENTH_FREE) then --���������ʮ�Ρ�����������ѳ�ʮ��
					
					local chest = hClass.Chest:create():Init(itemId,0)	--��װ����
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local notgain_redequip = self:_DBGetNotGainRedEquipCount(udbid)
						local NOTGAIN_MAX = hVar.NOTGAIN_REDEQUIP_MAX - 9 --��ʮ�Σ���ʮ��Ҳ��������(N-1)
						local chestid = chest:GetID()
						local mustRed = false
						
						if notgain_redequip >= NOTGAIN_MAX then
							mustRed = true
						end
						
						local reward = chest:Open(mustRed)
						--������������˵��ߣ��򶪸�user����
						if reward then
							--ʣ�࿪��ʱ�� * ÿ�����ĵ���Ϸ��
							
							--����������������
							reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_REDCHEST"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDCHEST)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							
							self:AddSaledCount()
							--���δ��ú�װ����Ҫ����ͳ��ֵ,������ո�ֵ
							if not reward:HaveDrop(hClass.Reward.TYPE.REDEQUIP) then
								self:_DBSetNotGainRedEquipCount10(udbid)
							else
								self:_DBClearNotGainRedEquipCount(udbid)
							end
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.TACTICCARD_ONCE) or (itemId == hClass.Chest.TYPE.TACTICCARD_ONCE_FREE)
				or (itemId == hClass.Chest.TYPE.TACTICCARD_TENTH) or (itemId == hClass.Chest.TYPE.TACTICCARD_TENTH_FREE) then --ս��������һ�Ρ�ս��������ѳ�һ�Ρ�ս��������ʮ�Ρ�ս��������ѳ�ʮ��
					
					local chest = hClass.Chest:create():Init(itemId,0)	--��װ����
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local chestid = chest:GetID()
						local reward = chest:Open()
						--������������˵��ߣ��򶪸�user����
						if reward then
							--ʣ�࿪��ʱ�� * ÿ�����ĵ���Ϸ��
							
							--����������������
							reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_REDCHEST"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDCHEST)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							
							self:AddSaledCount()
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.REDEQUIP_CRYSTAL_TENTH) then --������ʯ�һ�ʮ��
					local chest = hClass.Chest:create():Init(itemId,0)	--��װ����
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local notgain_redequip = self:_DBGetNotGainRedCrystalCount(udbid)
						local NOTGAIN_MAX = hVar.NOTGAIN_REDCRYSTAL_MAX - 9 --��ʮ�Σ���ʮ��Ҳ��������(N-1)
						local chestid = chest:GetID()
						local mustRed = false
						
						if notgain_redequip >= NOTGAIN_MAX then
							mustRed = true
						end
						
						local reward = chest:Open(mustRed)
						--������������˵��ߣ��򶪸�user����
						if reward then
							--ʣ�࿪��ʱ�� * ÿ�����ĵ���Ϸ��
							
							--����������������
							reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_REDDEBRIS"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDDEBRIS)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							
							self:AddSaledCount()
							--���δ��ú�װ����Ҫ����ͳ��ֵ,������ո�ֵ
							if not reward:HaveDrop(hClass.Reward.TYPE.REDEQUIP) then
								self:_DBSetNotGainRedCrystalCount10(udbid)
							else
								self:_DBClearNotGainRedCrystalCount(udbid)
							end
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.REDEQUIP_CRYSTAL_FIFTY) then --������ʯ�һ�50��
					local chest = hClass.Chest:create():Init(itemId,0)	--��װ����
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						--local notgain_redequip = self:_DBGetNotGainRedCrystalCount(udbid)
						local NOTGAIN_MAX = 0 --��50�Σ��س���װ
						local chestid = chest:GetID()
						local mustRed = true
						
						--if notgain_redequip >= NOTGAIN_MAX then
						--	mustRed = true
						--end
						
						local reward = chest:Open(mustRed)
						--������������˵��ߣ��򶪸�user����
						if reward then
							--ʣ�࿪��ʱ�� * ÿ�����ĵ���Ϸ��
							
							--����������������
							reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_REDDEBRIS"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDDEBRIS)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							
							self:AddSaledCount()
							--���δ��ú�װ����Ҫ����ͳ��ֵ,������ո�ֵ
							--if not reward:HaveDrop(hClass.Reward.TYPE.REDEQUIP) then
							--	self:_DBSetNotGainRedCrystalCount10(udbid)
							--else
								self:_DBClearNotGainRedCrystalCount(udbid)
							--end
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.TACTICCEST) then --ս������
					
					local chest = hClass.Chest:create():Init(itemId,0)	--ս������
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local chestid = chest:GetID()
						local reward = chest:Open()
						--������������˵��ߣ��򶪸�user����
						if reward then
							--ʣ�࿪��ʱ�� * ÿ�����ĵ���Ϸ��
							
							--����������������
							reward:TakeReward(udbid, rid, nil, cRedequipCrystal)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							self:AddSaledCount()
							
							ret = reward:ToCmd()
						end
					end
				end
			--һ�����
			else
				local itemType = hVar.tab_item[itemId].type
				
				local rollDrop = {}
				if itemType == hVar.ITEM_TYPE.TACTICDEBRIS then --ս������Ƭ
					rollDrop[1] = hClass.Reward.TYPE.TACTICDEBRIS
					rollDrop[2] = itemId
					rollDrop[3] = itemNum
				elseif itemType == hVar.ITEM_TYPE.SOULSTONE then --Ӣ�۽���
					rollDrop[1] = hClass.Reward.TYPE.HERODEBRIS
					rollDrop[2] = itemId
					rollDrop[3] = itemNum
				elseif itemType == hVar.ITEM_TYPE.CANGBAOTU_NORMAL then --�ر�ͼ
					rollDrop[1] = hClass.Reward.TYPE.CANGBAOTU_NORMAL
					rollDrop[2] = itemNum
					rollDrop[3] = 0
				elseif itemType == hVar.ITEM_TYPE.CANGBAOTU_HIGH then --�߼��ر�ͼ
					rollDrop[1] = hClass.Reward.TYPE.CANGBAOTU_HIGH
					rollDrop[2] = itemNum
					rollDrop[3] = 0
				elseif itemType == hVar.ITEM_TYPE.WEAPONGUNDEBRIS then --����ǹ��Ƭ
					rollDrop[1] = hClass.Reward.TYPE.WEAPONGUN_DEBRIS
					rollDrop[2] = itemId
					rollDrop[3] = itemNum
				elseif itemType == hVar.ITEM_TYPE.PETDEBRIS then --������Ƭ
					rollDrop[1] = hClass.Reward.TYPE.PET_DEBRIS
					rollDrop[2] = itemId
					rollDrop[3] = itemNum
				elseif (itemType == hVar.ITEM_TYPE.WEAPON) or (itemType == hVar.ITEM_TYPE.BODY) or (itemType == hVar.ITEM_TYPE.ORNAMENTS) or (itemType == hVar.ITEM_TYPE.MOUNT) then --����
					--rollDrop[1] = hClass.Reward.TYPE.EQUIPITEM
					rollDrop[1] = hClass.Reward.TYPE.REDEQUIP
					rollDrop[2] = itemId
					rollDrop[3] = 0
					rollDrop[4] = 0
				end
				
				local reward = hClass.Reward:create():Init()
				reward:Add(rollDrop)
				
				if reward then
					reward:TakeReward(udbid, rid)--self:_TakeReward(udbid, rid, reward)
					self:AddSaledCount()
					ret = reward:ToCmd()
				end
			end
		end
		
		return ret
		
	end
	
	--������Ϣת��
	function ShopItem:InfoToCmd()
		local cmd = tostring(self:GetID()) .. ":" .. tostring(self:GetItemID()) .. ":" .. tostring(self:GetItemNum()) .. ":".. tostring(self:GetScoreCost()) .. ":" .. tostring(self:GetRmbCost()) .. ":" .. tostring(self:GetQuota()) .. ":" .. tostring(self:GetSaledCount()) .. ";"
		return cmd
	end
return ShopItem