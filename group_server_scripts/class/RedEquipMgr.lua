--�Զ�ƥ�������
local RedEquipMgr = class("RedEquipMgr")
	
	RedEquipMgr.MERGE_BASE_VALUE = 27	--��װ�ϳɻ�����ֵ
	RedEquipMgr.MERGE_SUCCESS_VALUE = 54	--��װ�ϳɰٷְٳɹ��ܼ�ֵ
	
	RedEquipMgr.MERGE_ORANGE_SHOPITEMID = 338	--��װ�ϳɶ�Ӧ����Ʒid
	
	RedEquipMgr.MERGE_SHOPITEMID = 340	--��װ�ϳɶ�Ӧ����Ʒid
	RedEquipMgr.REDEQUIP_SCROLL_ITEM = 9918	--��װ����id
	RedEquipMgr.SCROLL_TO_EQUIP_SLOTNUM = 4	--��װ����һ���װ�Ŀ���
	
	--�Ϻ�װת��Ϊ�º�װ
	RedEquipMgr.OLD_TYPEID_CHANGE = 
	{
		[11007] = 12405,
		[11082] = 12205,
	}

	--���캯��
	function RedEquipMgr:ctor(flag)
		
		self._uid = -1			--���id
		self._rid = -1			--��ɫid
		self._edic = -1			--��װ�洢
		self._autoGetDB = flag		--��ʼ��ʱ�Ƿ��Զ���db��ʼ����ҵĺ�װ����

		--��õ���
		--����
		--ϴ��
		--�ϳ�
		
		--����
		return self
	end
	--��ʼ������
	function RedEquipMgr:Init(uid,rid)
		
		self._uid = uid
		self._rid = rid
		
		self._edic = {}
		
		if self._autoGetDB then
			self:_DBGetAllRedEquip()
		else
			
		end
		
		return self
	end
	--��������
	function RedEquipMgr:Release()
		
		self._uid = -1
		self._rid = -1

		for k, e in pairs(self._edic) do
			if e and type(e) == "table" and e:getCName() == "RedEquip" then
				e:Release()
				e = nil
			else
				e = nil
			end
		end
		self._edic = -1
		
		return self
	end
	
	------------------------------------------------------------private-------------------------------------------------------
	--��ȡ�������װ����Ϣ
	function RedEquipMgr:_DBGetAllRedEquip()
		
		local uid = self._uid
		local rid = self._rid
		
		local sql = string.format("SELECT `id`,`itypeid`,`slotNum`,`itemAttr`,`xilian_count`,`cUnique` FROM t_user_redequip where `uid`=%d AND `rid`=%d AND deleteflag=0",uid,rid)
		local err, tTemp = xlDb_QueryEx(sql)
		--print("sql:",err,sql)
		if err == 0 then
			for n = 1, #tTemp do
				local dbid = tonumber(tTemp[n][1])
				local typeid = tonumber(tTemp[n][2])
				local slotnum = tonumber(tTemp[n][3]) or 0
				local strattr = tTemp[n][4]
				local xilianCount = tonumber(tTemp[n][4]) or 0
				local cUnique = tonumber(tTemp[n][5]) or 0

				local equip = hClass.RedEquip:create():Init(dbid,typeid,slotnum,strattr,xilianCount,cUnique)

				self._edic[dbid] = equip
			end
		end
	end
	
	--��ȡ��ҵ���װ����Ϣ
	function RedEquipMgr:_DBGetRedEquipByDBID(itemdbid)

		local uid = self._uid
		local rid = self._rid

		local equip
		local sql = string.format("SELECT `id`,`itypeid`,`slotNum`,`itemAttr`,`xilian_count`,`cUnique` FROM t_user_redequip where `id`=%d AND `uid`=%d AND `rid`=%d AND deleteflag=0",itemdbid,uid,rid)
		local err, dbid, typeid, slotnum, strattr, xilian_count,cUnique = xlDb_Query(sql)
		--print("sql:",err,sql)
		if err == 0 then
			equip = hClass.RedEquip:create():Init(dbid,typeid,slotnum,strattr,xilian_count,cUnique)
		end
		return equip
	end
	
	--��ȡ��Ҷ��װ����Ϣ
	function RedEquipMgr:_DBGetRedEquipsByDBIDList(itemDbidList)

		local uid = self._uid
		local rid = self._rid

		local equipDic = {}

		local strIds = ""
		for i = 1, #itemDbidList do
			strIds = strIds .. itemDbidList[i]
			if i < #itemDbidList then
				strIds = strIds .. ","
			end
		end
		
		local sql = string.format("SELECT `id`,`itypeid`,`slotNum`,`itemAttr`,`xilian_count`,`cUnique` FROM t_user_redequip where `id` IN (%s) AND `uid`=%d AND `rid`=%d AND deleteflag=0",strIds,uid,rid)
		local err, tTemp = xlDb_QueryEx(sql)
		--print("sql:",err,sql)
		if err == 0 then
			for n = 1, #tTemp do
				local dbid = tonumber(tTemp[n][1])
				local typeid = tonumber(tTemp[n][2])
				local slotnum = tonumber(tTemp[n][3]) or 0
				local strattr = tTemp[n][4]
				local xilianCount = tonumber(tTemp[n][4]) or 0
				local cUnique = tonumber(tTemp[n][5]) or 0

				local equip = hClass.RedEquip:create():Init(dbid,typeid,slotnum,strattr,xilianCount,cUnique)
				
				if equip then
					equipDic[dbid] = equip
				end
			end
		end

		return equipDic
	end

	function RedEquipMgr:_NewEquip(typeid,slotnum)
		local uid = self._uid
		local rid = self._rid
		
		local ret = false
		local slotnum = slotnum or -1
		if slotnum >= 0 then
			slotnum = math.min(slotnum,4)
		else
			--[[
			--�������45% 2��,40% 3��,15% 4��
			local r = math.random(1, 100)
			if r > 0 and r <= 45 then
				slotnum = 2
			elseif r > 45 and r <= 85 then
				slotnum = 3
			elseif r > 85 and r <= 100 then
				slotnum = 4
			end
			]]
			
			--�������60% 2��, 35% 3��, 5% 4��
			local r = math.random(1, hVar.ITEM_CHEST_SLOT_PROB.totalValue)
			if (r > 0) and (r <= hVar.ITEM_CHEST_SLOT_PROB[1].value) then
				slotnum = hVar.ITEM_CHEST_SLOT_PROB[1].reward
			elseif (r > hVar.ITEM_CHEST_SLOT_PROB[1].value) and r <= (hVar.ITEM_CHEST_SLOT_PROB[1].value + hVar.ITEM_CHEST_SLOT_PROB[2].value) then
				slotnum = hVar.ITEM_CHEST_SLOT_PROB[2].reward
			elseif r > (hVar.ITEM_CHEST_SLOT_PROB[1].value + hVar.ITEM_CHEST_SLOT_PROB[2].value) and r <= (hVar.ITEM_CHEST_SLOT_PROB[1].value + hVar.ITEM_CHEST_SLOT_PROB[2].value + hVar.ITEM_CHEST_SLOT_PROB[3].value) then
				slotnum = hVar.ITEM_CHEST_SLOT_PROB[3].reward
			end
		end
		
		local strattr = ""
		
		--�Ѿ����������
		local excludeAttr = {}
		--����ÿһ���ף��������
		for i = 1, slotnum do
			--�������Ʒ��
			local attrR = math.random(1,5) --������Ե�Ʒ��
			local attr = self:_GetItemRandomAttr(attrR, excludeAttr)
			if attr then
				strattr = strattr .. attr
				if i < slotnum then
					strattr = strattr .. "|"
				end
			end
		end
		
		--print("DBAddEquip:",uid,rid,typeid, slotnum, strattr)

		--�����¼
		local equip = hClass.RedEquip:create():Init(0,typeid,slotnum,strattr)

		return equip
	end

	--��õ���ϴ����Ҫ�Ļ���
	function RedEquipMgr:_GetItemXiLianScore(equip, qualityLv)
		local ret = 0
		
		--[[
		--��ȡ��ǰ����Ʒ�ʵȼ���Ӧ������Ȩֵ��Ϣ
		if hVar.ITEM_XILIAN_INFO[qualityLv] and hVar.ITEM_XILIAN_INFO[qualityLv].cost then
			ret = hVar.ITEM_XILIAN_INFO[qualityLv].cost
		end
		]]
		--��ȡ������ǰ����Ʒ�ʵȼ���Ӧ������Ȩֵ��Ϣ
		if hVar.ITEM_XILIAN_INFO[qualityLv] and hVar.ITEM_XILIAN_INFO[qualityLv].cost then
			local cost = hVar.ITEM_XILIAN_INFO[qualityLv].cost
			local slotNum = equip:GetSlotNum()
			ret = cost[slotNum]
		end
		
		return ret
	end
	
	--���ϴ������������Ҫ�Ľ�ҺͶ�Ӧ�ĵ���id
	function RedEquipMgr:_GetItemLockInfo(lockNum)
		local rmb = 0
		local itemId = 9902
		
		if hVar.ITEM_XILIAN_INFO.lockInfo then
			local num = math.min(math.max((lockNum or 0), 0), hVar.ITEM_XILIAN_INFO.lockInfo.maxLock)
			local lockInfo = hVar.ITEM_XILIAN_INFO.lockInfo[num]
			rmb = lockInfo[1] or 0
			itemId = lockInfo[2] or 9902
		end

		return rmb, itemId
	end
	
	--roll�㣬����Ȩֵ�����ĸ����䣬���ص���
	function RedEquipMgr:_RollDrop(pool)
		local ret 
		if not pool then
			return ret
		end

		local value = math.random(1, pool.totalValue)
		local initialValue = 0
		--��������Ȩ�������ĸ�����
		for i = 1, #pool do
			if value > initialValue and value <= initialValue + pool[i].value then
				ret = pool[i].reward
				break
			end
			initialValue = initialValue + pool[i].value
		end
		return ret
	end
	
	--��ȡװ���������(����Ʒ�ʣ��Ѿ��е�����)
	function RedEquipMgr:_GetItemRandomAttr(attrR, excludeAttr)
		local baseAttrSet = hVar.ITEM_ATTR_QUALITY_DEF[attrR]

		--��ȡ���Գ�
		--���㣬����Ѿ���ȡ�����Բ��ٳ�ȡ
		local attrSet = {}
		for i = 1, #hVar.ITEM_ATTR_QUALITY_DEF[attrR] do
			local flag = true
			local baseAttr = hVar.ITEM_ATTR_QUALITY_DEF[attrR][i]
			for j = 1, #excludeAttr do
				local excludeAttr = excludeAttr[j]
				--�ų��Ѿ���ȡ������
				if hVar.ITEM_ATTR_VAL[baseAttr].attrAdd == hVar.ITEM_ATTR_VAL[excludeAttr].attrAdd then
					flag = false
					break
				end
			end
			if flag then
				attrSet[#attrSet + 1] = baseAttr
			end
		end
		
		--һ����������ƣ�������������е����Զ��Ѿ�����������򽱳ص��ڻ�������
		if #attrSet <= 0 then
			attrSet = baseAttrSet
		end
		--local attrSet = hVar.ITEM_ATTR_QUALITY_DEF[attrR]
		if #attrSet > 0 then
			--�����������
			local attrIdx = math.random(1,#attrSet)
			--�����������
			local attr = attrSet[attrIdx]
			if hVar.ITEM_ATTR_VAL[attr] then
				excludeAttr[#excludeAttr+1] = attr
				return attr
			end
		end
	end
	
	

	------------------------------------------------------------public-------------------------------------------------------
	--��ȡ���к�װ(����ɶһ�)��Ϣ
	function RedEquipMgr:GetAllScrollEquip()
		local cmd = ""
		local num = 0

		if hVar.SCROLL_TO_EQUIP_POOL and type(hVar.SCROLL_TO_EQUIP_POOL) == "table" then
			for i = 1, #hVar.SCROLL_TO_EQUIP_POOL do
				cmd = cmd .. hVar.SCROLL_TO_EQUIP_POOL[i] .. ";"
				num = num + 1
			end
		end

		cmd = num .. ";" .. cmd

		return cmd
	end
	
	
	------------------------------------------------------------db public-------------------------------------------------------

	--���ϵĺ�װת��Ϊ�µ�
	function RedEquipMgr:DBChangeOld(uid,rid,cOldRedEquipNum,oldList)
		--����ͻ��˴�����Ҫͬ��������,�����Ƿ��Ѿ�ͬ������ص�������,todo
		
		for i = 1, cOldRedEquipNum do
			local old = oldList[i]
			if old then
				local typeId = tonumber(old.typeId) or 0
				local uniqueId = tonumber(old.uniqueId) or 0
				local slotNum = tonumber(old.slotNum) or 0
				local strAttr = old.strAttr
				
				if (typeId == 11007 or typeId == 11082) and uniqueId > 0 then
					local equip = self:_NewEquip(RedEquipMgr.OLD_TYPEID_CHANGE[typeId],4)
					if equip then
						equip:SetCUnique(uniqueId)
					
						local tAttr = hApi.Split(strAttr,":")
						for n = 1, slotNum do
							equip:SetAttr(n, tAttr[n])
						end

						local saveOk = equip:DBSave(uid,rid)
						if saveOk then
							self._edic[equip:GetDBID()] = equip
						end
					end
				end
			end
		end
	end

	--�ֶ���db��ȡ��������
	function RedEquipMgr:DBGetRedEquip(uid,rid)
		
		--��ɾ��֮ǰ�Ĵ洢����
		for k, e in pairs(self._edic) do
			if e and type(e) == "table" and e:getCName() == "RedEquip" then
				e:Release()
				e = nil
			else
				e = nil
			end
		end
		self._edic = {}

		self:_DBGetAllRedEquip(uid,rid)
	end

	--DB��������
	function RedEquipMgr:DBAddEquip(typeid,slotnum)
		
		local uid = self._uid
		local rid = self._rid

		local equip = self:_NewEquip(typeid,slotnum)

		if equip then
			local saveOk = equip:DBSave(uid,rid)
			if saveOk then
				self._edic[equip:GetDBID()] = equip
				ret = equip
			end
		end

		----�����¼
		--local sql = string.format("INSERT INTO t_user_redequip (`uid`,`rid`,`itypeid`,`slotNum`,`itemAttr`) VALUES (%d,%d,%d,%d,'%s')", uid,rid,typeid, slotnum, strattr)
		--local err = xlDb_Execute(sql)
		--if err == 0 then
		--	local err1, dbid = xlDb_Query("select last_insert_id()")
		--	if err1 == 0 then
		--		local equip = hClass.RedEquip:create():Init(dbid,typeid,slotnum,strattr)
		--		self._edic[dbid] = equip
		--		ret = equip
		--	else
		--
		--	end
		--end

		return ret
	end
	
	--ϴ��
	function RedEquipMgr:DBXiLian(itemDbid, lockNum, lockIdDic)
		
		local ret =  tostring(itemDbid) .. ";"

		local uid = self._uid
		local rid = self._rid
		
		local equip = self:_DBGetRedEquipByDBID(itemDbid)
		if equip then
			local itemId = equip:GetTypeID()
			local tabI = hVar.tab_item[itemId]
			local oldInfo = equip:InfoToCmd()
			if tabI then
				local itemLv = tabI.itemLv

				--���Ļ���
				local costScore = self:_GetItemXiLianScore(equip, itemLv)
				local rmb, sendItemId = self:_GetItemLockInfo(lockNum)

				--print("rmb:",lockNum,rmb,sendItemId,costScore)
				
				--����ϴ��
				local xilianOk = equip:XiLian(lockIdDic)
				
				if xilianOk then
					local newInfo = equip:InfoToCmd()
					--�ж���Ϸ���Ƿ��㹻
					if hGlobal.userCoinMgr:DBUserPurchase(uid,rid,sendItemId,1,rmb,costScore,oldInfo .. ";" .. newInfo) then
						equip:AddXiLianCount()
						local saveOk = equip:DBSave(uid,rid)
						if saveOk then
							--����ɹ�
							ret = "1;" .. ret
							ret = ret .. tostring(0) .. ":" .. tostring(sendItemId) .. ":" .. tostring(1) .. ":".. tostring(costScore) .. ":" .. tostring(rmb) .. ":" .. tostring(1) .. ":" .. tostring(1) .. ";"
							ret = ret .. newInfo
						else
							--����ʧ��
							hGlobal.userCoinMgr:DBAddGamecoin(uid,rmb)
							ret = "-4;" .. ret	--����װ����Ϣʧ��
						end
					else
						ret = "-3;" .. ret	--��Ϸ�Ҳ���
					end
				else
					ret = "-5;" .. ret	--����ϴ��ʧ��

				end
			else
				ret = "-2;" .. ret	--װ�����Ͳ�����
			end
		else
			ret = "-1;" .. ret	--װ��������
		end

		return ret
	end

	--�ϳ�
	function RedEquipMgr:DBMerge(mainDbid, materialNum, materialDbidList)

		local ret =  tostring(mainDbid) .. ";" .. materialNum .. ";"


		local uid = self._uid
		local rid = self._rid

		--todo
		--���ۼ�Ǯ
		local shopItem = hClass.ShopItem:create():Init(RedEquipMgr.MERGE_SHOPITEMID)
		
		--����װ��������װ����dbid�����б���
		local itemDBidList = {}
		local itemTypeIdList = {}
		itemDBidList[#itemDBidList + 1] = mainDbid
		for i = 1, materialNum do
			itemDBidList[#itemDBidList + 1] = materialDbidList[i]
			ret = ret .. materialDbidList[i] .. ";"
		end

		--print("DBMerge Info:", ret)

		local equipDic = self:_DBGetRedEquipsByDBIDList(itemDBidList)
		local oldInfo = ""
		--�ж���װ���Ͳ���װ���Ƿ����
		for i = 1, #itemDBidList do
			local equip = equipDic[itemDBidList[i]]
			if not equip then
				ret = "-1;"..ret
				return ret
			else
				oldInfo = oldInfo .. equip:InfoToCmd() .. ";"
			end
		end
		
		--��ȡ�ϳ�������
		local mergeItem = equipDic[mainDbid]
			
		--��������
		local baseRatio = 0
		
		local mergeItemId = mergeItem:GetTypeID()		--������id
		local mergeItemTabI = hVar.tab_item[mergeItemId]	--������tab��
		
		--���������tab����ڣ���������װ��
		if mergeItemTabI then

			itemTypeIdList[mergeItemId] = true
			
			--����������tab��������
			local mergeItemItemLv = mergeItemTabI.itemLv or hVar.ITEM_QUALITY.WHITE			--�����ߵ���Ʒ��
			--��ǰƷ�ʵ��������Ƿ���Բ���ϳ�
			baseRatio = math.min(baseRatio + RedEquipMgr.MERGE_BASE_VALUE,100)			--�����߸���Ȩֵ
			
			--��ȡ���ϵ���
			for i = 1, materialNum do
				local material = equipDic[materialDbidList[i]]
				if material and type(material) == "table" then
					
					local materialId = material:GetTypeID()			--���ϵ���id
					local materialTabI = hVar.tab_item[materialId]		--���ϵ���tab��
					--������ϵ���tab����ڣ����ϵ�����װ��
					if materialTabI then

						itemTypeIdList[materialId] = true

						baseRatio = math.min(baseRatio + RedEquipMgr.MERGE_BASE_VALUE,100)				--���ϵ��߸���Ȩֵ
					end

					--����װ������Ϊɾ��
					material:SetDelete()
				end
			end
			
			--
			local rRatio = math.random(1, RedEquipMgr.MERGE_SUCCESS_VALUE)
			local okFlag = 0
			--�ɹ�
			if rRatio <= baseRatio then
				okFlag = 1
				--������������Ϊɾ��
				mergeItem:SetDelete()
			end

			--�ӳ���ɸѡ�����в���
			tmpPool = {}
			tmpPool.totalValue = 0
			for i = 1, #hVar.ITEM_MERGE_POOL do
				local itemInfo = hVar.ITEM_MERGE_POOL[i]
				local value = itemInfo.value
				local reward = itemInfo.reward
				local redequipTypeId = reward[2]
				if not itemTypeIdList[redequipTypeId] then
					tmpPool[#tmpPool + 1] = itemInfo
					tmpPool.totalValue = tmpPool.totalValue + value
				end
			end

			--�����µ���
			local newInfo = self:_RollDrop(tmpPool)
			local slotnum = tonumber(newInfo[3]) or 0
			if slotnum == -1 then
				slotnum = self:_RollDrop(hVar.ITEM_MERGE_SLOT_PROB)
			end
			local newEquip = self:_NewEquip(newInfo[2],slotnum)

			local purchaseInfo = tostring(okFlag) .. ";"
			if okFlag == 1 then
				purchaseInfo = purchaseInfo .. oldInfo .. newEquip:InfoToCmd()
			else
				purchaseInfo = purchaseInfo .. oldInfo
			end
			
			--�ж���Ϸ���Ƿ��㹻
			local rmbCost = math.ceil(shopItem:GetRmbCost() * (math.max(materialNum,1)))
			if hGlobal.userCoinMgr:DBUserPurchase(uid,rid,shopItem:GetItemID(),1,rmbCost,0,purchaseInfo) then
				for i = 1, materialNum do
					local material = equipDic[materialDbidList[i]]
					material:DBSave(uid,rid)
				end
				ret = "1;" .. ret .. tostring(okFlag) ..";"
				if okFlag == 1 then
					mergeItem:DBSave(uid,rid)
					newEquip:DBSave(uid,rid)
					ret = ret .. newEquip:InfoToCmd()
				end
			else
				ret = "-3;"..ret	--�ϳɵ���ʧ��:��Ϸ�Ҳ���
			end
		else
			ret = "-2;"..ret	--�ϳɵ���ʧ��:���������Ͳ�����
		end

		return ret
	end

	--��װ����һ���װ
	function RedEquipMgr:DBScroll2RedEquip(idx)
		local cmd = ""
		local result = 0

		local uid = self._uid
		local rid = self._rid

		if hVar.SCROLL_TO_EQUIP_POOL and type(hVar.SCROLL_TO_EQUIP_POOL) == "table" then
			if idx and hVar.SCROLL_TO_EQUIP_POOL[idx] then
				local itemId = hVar.SCROLL_TO_EQUIP_POOL[idx]
				--�ж���Ϸ���Ƿ��㹻
				if hGlobal.userCoinMgr:DBUserCostScroll(uid,rid,RedEquipMgr.REDEQUIP_SCROLL_ITEM,1,1,0,itemId..";") then
					local mykey = ""
					mykey = mykey .. hVar.tab_string["__TEXT_REWARD_REDEQUIP"] .. ";" .. "10:" .. itemId .. ":" .. RedEquipMgr.SCROLL_TO_EQUIP_SLOTNUM .. ":0;"

					local insertSql = string.format("INSERT INTO prize (uid,`type`, mykey) VALUES (%d,20008,'%s')",uid,mykey)
				
					--ִ��sql
					local err = xlDb_Execute(insertSql)
					if err == 0 then
						--��������
						result = 1
					end

				end
			end
		end

		cmd = result .. ";" .. cmd
		return cmd
	end

	function RedEquipMgr:InfoToCmd()
		local cmd = ""
		local enum = 0
		for k, equip in pairs(self._edic) do
			cmd = cmd .. (equip:InfoToCmd()) .. ";"
			enum = enum + 1
		end

		cmd = enum .. ";" .. cmd

		return cmd
	end

return RedEquipMgr