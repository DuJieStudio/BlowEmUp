--�Զ�ƥ�������
local RedEquipMgr = class("RedEquipMgr")
	
	RedEquipMgr.MERGE_BASE_VALUE = 27	--��װ�ϳɻ�����ֵ
	RedEquipMgr.MERGE_SUCCESS_VALUE = 54	--��װ�ϳɰٷְٳɹ��ܼ�ֵ
	
	RedEquipMgr.MERGE_ORANGE_SHOPITEMID = 338	--��װ�ϳɶ�Ӧ����Ʒid
	
	RedEquipMgr.MERGE_SHOPITEMID = 340	--��װ�ϳɶ�Ӧ����Ʒid

	RedEquipMgr.DESCOMPOS_SHOPITEMID = 507	--��װ���۶�Ӧ����Ʒid

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
		
		--local sql = string.format("SELECT `id`,`itypeid`,`slotNum`,`itemAttr`,`xilian_count`,`cUnique` FROM t_user_redequip where `uid`=%d AND `rid`=%d AND deleteflag=0",uid,rid)
		local sql = string.format("SELECT `id`, `itypeid`, `slotNum`, `itemAttr`, `xilian_count`, `cUnique`, `quality`,`randIdx1`,`randVal1`,`randIdx2`,`randVal2`,`randIdx3`,`randVal3`,`randIdx4`,`randVal4`,`randIdx5`,`randVal5`,`randSkillIdx1`,`randSkillLv1`,`randSkillIdx2`,`randSkillLv2`,`randSkillIdx3`,`randSkillLv3` FROM `t_user_redequip` where `uid` = %d and `rid`= %d AND `deleteflag` = %d", uid, rid, 0)
		local err, tTemp = xlDb_QueryEx(sql)
		--print("sql:",err,sql)
		if err == 0 then
			for n = 1, #tTemp do
				local dbid = tonumber(tTemp[n][1])
				local typeid = tonumber(tTemp[n][2])
				local slotnum = tonumber(tTemp[n][3]) or 0
				local strattr = tTemp[n][4]
				local xilianCount = tonumber(tTemp[n][5]) or 0
				local cUnique = tonumber(tTemp[n][6]) or 0
				local quality = tonumber(tTemp[n][7]) or 0 --Ʒ��
				local randIdx1 = tonumber(tTemp[n][8]) or 0 --�����������1
				local randVal1 = tonumber(tTemp[n][9]) or 0 --�������ֵ1
				local randIdx2 = tonumber(tTemp[n][10]) or 0 --�����������2
				local randVal2 = tonumber(tTemp[n][11]) or 0 --�������ֵ2
				local randIdx3 = tonumber(tTemp[n][12]) or 0 --�����������3
				local randVal3 = tonumber(tTemp[n][13]) or 0 --�������ֵ3
				local randIdx4 = tonumber(tTemp[n][14]) or 0 --�����������4
				local randVal4 = tonumber(tTemp[n][15]) or 0 --�������ֵ4
				local randIdx5 = tonumber(tTemp[n][16]) or 0 --�����������5
				local randVal5 = tonumber(tTemp[n][17]) or 0 --�������ֵ5
				local randSkillIdx1 = tonumber(tTemp[n][18]) or 0 --�����������1
				local randSkillLv1 = tonumber(tTemp[n][19]) or 0 --������ܵȼ�1
				local randSkillIdx2 = tonumber(tTemp[n][20]) or 0 --�����������2
				local randSkillLv2 = tonumber(tTemp[n][21]) or 0 --������ܵȼ�2
				local randSkillIdx3 = tonumber(tTemp[n][22]) or 0 --�����������3
				local randSkillLv3 = tonumber(tTemp[n][23]) or 0 --������ܵȼ�3
				
				local equip = hClass.RedEquip:create():Init(dbid,typeid,slotnum,quality,strattr,xilianCount,cUnique,randIdx1,randVal1,randIdx2,randVal2,randIdx3,randVal3,randIdx4,randVal4,randIdx5,randVal5,randSkillIdx1,randSkillLv1,randSkillIdx2,randSkillLv2,randSkillIdx3,randSkillLv3)
				
				--�����ڴ�
				self._edic[dbid] = equip
			end
		end
	end
	
	--��ȡ��ҵ���װ����Ϣ
	function RedEquipMgr:_DBGetRedEquipByDBID(itemdbid)
		
		local uid = self._uid
		local rid = self._rid
		
		--���ȶ�ȡ�ڴ�ֵ
		local equip = self._edic[itemdbid]
		if (equip == nil) then
			local sql = string.format("SELECT `id`,`itypeid`,`slotNum`,`itemAttr`,`xilian_count`,`cUnique`, `quality`,`randIdx1`,`randVal1`,`randIdx2`,`randVal2`,`randIdx3`,`randVal3`,`randIdx4`,`randVal4`,`randIdx5`,`randVal5`,`randSkillIdx1`,`randSkillLv1`,`randSkillIdx2`,`randSkillLv2`,`randSkillIdx3`,`randSkillLv3` FROM t_user_redequip where `id`=%d AND `uid`=%d AND `rid`=%d AND deleteflag=0",itemdbid,uid,rid)
			local err, dbid, typeid, slotnum, strattr, xilian_count,cUnique,quality,randIdx1,randVal1,randIdx2,randVal2,randIdx3,randVal3,randIdx4,randVal4,randIdx5,randVal5,randSkillIdx1,randSkillLv1,randSkillIdx2,randSkillLv2,randSkillIdx3,randSkillLv3 = xlDb_Query(sql)
			--print("sql:",err,sql)
			if err == 0 then
				equip = hClass.RedEquip:create():Init(dbid,typeid,slotnum,quality,strattr,xilian_count,cUnique,randIdx1,randVal1,randIdx2,randVal2,randIdx3,randVal3,randIdx4,randVal4,randIdx5,randVal5,randSkillIdx1,randSkillLv1,randSkillIdx2,randSkillLv2,randSkillIdx3,randSkillLv3)
				--�����ڴ�
				self._edic[dbid] = equip
			end
			--print("_DBGetRedEquipByDBID, load sql:", uid, rid, itemdbid)
		end
		
		return equip
	end
	
	--��ȡ��Ҷ��װ����Ϣ
	function RedEquipMgr:_DBGetRedEquipsByDBIDList(itemDbidList)
		
		local uid = self._uid
		local rid = self._rid
		
		local equipDic = {}
		
		local strIds = ""
		
		--���ȶ�ȡ�ڴ�ֵ
		for i = 1, #itemDbidList, 1 do
			local itemDbid = itemDbidList[i]
			local equip = self._edic[itemDbid]
			
			if (equip == nil) then
				if (strIds == "") then
					strIds = strIds .. itemDbid
				else
					strIds = strIds .. "," .. itemDbid
				end
				--if i < #itemDbidList then
				--	strIds = strIds .. ","
				--end
			else
				equipDic[itemDbid] = equip
			end
		end
		
		if (strIds ~= "") then
			local sql = string.format("SELECT `id`,`itypeid`,`slotNum`,`itemAttr`,`xilian_count`,`cUnique`, `quality`,`randIdx1`,`randVal1`,`randIdx2`,`randVal2`,`randIdx3`,`randVal3`,`randIdx4`,`randVal4`,`randIdx5`,`randVal5`,`randSkillIdx1`,`randSkillLv1`,`randSkillIdx2`,`randSkillLv2`,`randSkillIdx3`,`randSkillLv3` FROM t_user_redequip where `id` IN (%s) AND `uid`=%d AND `rid`=%d AND deleteflag=0",strIds,uid,rid)
			local err, tTemp = xlDb_QueryEx(sql)
			--print("sql:",err,sql)
			if err == 0 then
				for n = 1, #tTemp do
					local dbid = tonumber(tTemp[n][1])
					local typeid = tonumber(tTemp[n][2])
					local slotnum = tonumber(tTemp[n][3]) or 0
					local strattr = tTemp[n][4]
					local xilianCount = tonumber(tTemp[n][5]) or 0
					local cUnique = tonumber(tTemp[n][6]) or 0
					local quality = tonumber(tTemp[n][7]) or 0 --Ʒ��
					local randIdx1 = tonumber(tTemp[n][8]) or 0 --�����������1
					local randVal1 = tonumber(tTemp[n][9]) or 0 --�������ֵ1
					local randIdx2 = tonumber(tTemp[n][10]) or 0 --�����������2
					local randVal2 = tonumber(tTemp[n][11]) or 0 --�������ֵ2
					local randIdx3 = tonumber(tTemp[n][12]) or 0 --�����������3
					local randVal3 = tonumber(tTemp[n][13]) or 0 --�������ֵ3
					local randIdx4 = tonumber(tTemp[n][14]) or 0 --�����������4
					local randVal4 = tonumber(tTemp[n][15]) or 0 --�������ֵ4
					local randIdx5 = tonumber(tTemp[n][16]) or 0 --�����������5
					local randVal5 = tonumber(tTemp[n][17]) or 0 --�������ֵ5
					local randSkillIdx1 = tonumber(tTemp[n][18]) or 0 --�����������1
					local randSkillLv1 = tonumber(tTemp[n][19]) or 0 --������ܵȼ�1
					local randSkillIdx2 = tonumber(tTemp[n][20]) or 0 --�����������2
					local randSkillLv2 = tonumber(tTemp[n][21]) or 0 --������ܵȼ�2
					local randSkillIdx3 = tonumber(tTemp[n][22]) or 0 --�����������3
					local randSkillLv3 = tonumber(tTemp[n][23]) or 0 --������ܵȼ�3
					
					local equip = hClass.RedEquip:create():Init(dbid,typeid,slotnum,quality,strattr,xilianCount,cUnique,randIdx1,randVal1,randIdx2,randVal2,randIdx3,randVal3,randIdx4,randVal4,randIdx5,randVal5,randSkillIdx1,randSkillLv1,randSkillIdx2,randSkillLv2,randSkillIdx3,randSkillLv3)
					
					--�����ڴ�
					if equip then
						self._edic[dbid] = equip
					end
				end
			end
			--print("_DBGetRedEquipsByDBIDList load sql:", uid, rid, strIds)
		end
		
		return equipDic
	end
	
	--�����º�װ����
	function RedEquipMgr:_NewEquip(typeid,slotnum,quality,cRedequipCrystal,strHint, nHintType)
		local uid = self._uid
		local rid = self._rid
		
		local ret = false
		local tabI = hVar.tab_item[typeid]
		local slotnum = slotnum or -1
		if slotnum > 0 then
			slotnum = math.min(slotnum,4)
		else
			--�Ǻ�װ������Ϊ0
			--local tabI = hVar.tab_item[typeid]
			if tabI then
				local itemLv = tabI.itemLv or 0
				
				--�����������
				local tPool = hVar.ITEM_CHEST_SLOT_PROB[itemLv] --�������ҳ���
				if cRedequipCrystal then
					tPool = hVar.ITEM_DEBRIS_EXCHANGE_SLOT_PROB --������ʯ����
				end
				
				
				--�������
				--for i = 1, #tPool, 1 do
				--	print(tPool[i].value, tPool[i].reward)
				--end
				
				
				--�������60% 2��, 35% 3��, 5% 4��
				local r = math.random(1, tPool.totalValue)
				if (r > 0) and (r <= tPool[1].value) then
					slotnum = tPool[1].reward
				elseif (r > tPool[1].value) and r <= (tPool[1].value + tPool[2].value) then
					slotnum = tPool[2].reward
				elseif r > (tPool[1].value + tPool[2].value) and r <= (tPool[1].value + tPool[2].value + tPool[3].value) then
					slotnum = tPool[3].reward
				end
			end
		end
		
		local strattr = ""
		
		--�Ѿ����������
		local excludeAttr = {}
		--����ÿһ���ף��������
		for i = 1, slotnum do
			--�������Ʒ��
			--local attrR = math.random(1,5) --������Ե�Ʒ��
			--print("attrR=", attrR)
			local itemLv = tabI.itemLv or 0
			local attrR = hClass.RedEquip:_MakeItemXiLianAttrLv(itemLv)
			--print("attrR=", attrR)
			local attr = self:_GetItemRandomAttr(attrR, excludeAttr)
			if attr then
				strattr = strattr .. attr
				if i < slotnum then
					strattr = strattr .. "|"
				end
			end
		end
		
		--���Ʒ��
		if (quality <= 0) then
			--���Ʒ�ʳ���
			local tPool = hVar.ITEM_QUALITY_PROB --�������ҳ���
			--local tabI = hVar.tab_item[typeid] or {}
			local tabI_quality = tabI.maxQuality or 1
			local maxQuality = math.min(tPool.maxQuality, tabI_quality)
			
			--���һ������
			--�����ܼ���
			--���������
			local totalValue = 0
			for i = 1, maxQuality, 1 do
				totalValue = totalValue + tPool[i].value
			end
			--local rand = math.random(1, tPool.totalValue)
			local rand = math.random(1, totalValue)
			--����������
			local pivot = rand
			for i = 1, #tPool, 1 do
				if (pivot <= tPool[i].value) then --�ҵ���
					quality = i
					break
				else
					pivot = pivot - tPool[i].value
				end
			end
		end
		
		--print("DBAddEquip:",uid,rid,typeid, slotnum, quality, strattr)
		
		--�����¼
		local xilianCount = 0
		local cUnique = 0
		
		local randIdx1 = 0
		local randVal1 = 0
		local randIdx2 = 0
		local randVal2 = 0
		local randIdx3 = 0
		local randVal3 = 0
		local randIdx4 = 0
		local randVal4 = 0
		local randIdx5 = 0
		local randVal5 = 0
		
		--�����������
		--print("typeid=", typeid)
		local randreward = tabI.randreward
		if (type(randreward) == "table") then
			local randAttrNum = 0
			--print(typeid, randreward.randnum[1], randreward.randnum[2])
			if (randreward.randnum[1] <= randreward.randnum[2]) then
				randAttrNum = math.random(randreward.randnum[1], randreward.randnum[2])
			else
				randAttrNum = math.random(randreward.randnum[2], randreward.randnum[1])
			end
			--print("randAttrNum=", randAttrNum)
			
			if (randAttrNum > 0) then
				--�����n������
				local tAttrDic = {}
				for j = 1, randAttrNum, 1 do
					while true do
						local ranIdx = math.random(1, #randreward)
						
						--δ�浽
						if (tAttrDic[ranIdx] == nil) then
							local randVal = 0
							if (randreward[ranIdx][2] <= randreward[ranIdx][3]) then
								randVal = math.random(randreward[ranIdx][2], randreward[ranIdx][3])
							else
								randVal = math.random(randreward[ranIdx][3], randreward[ranIdx][2])
							end
							
							tAttrDic[ranIdx] = randVal
							
							break
						end
					end
				end
				
				--ת�����
				local tAttrList = {}
				for k = 1, 5, 1 do
					if tAttrDic[k] then
						tAttrList[#tAttrList+1] = {k, tAttrDic[k],}
					end
				end
				--����
				table.sort(tAttrList, function(ta, tb)
					if (ta[1] == tb[1]) then
						return false
					else
						return (ta[1] < tb[1])
					end
				end)
				
				--�������1
				if (randAttrNum >= 1) then
					randIdx1 = tAttrList[1][1]
					randVal1 = tAttrList[1][2]
				end
				--�������2
				if (randAttrNum >= 2) then
					randIdx2 = tAttrList[2][1]
					randVal2 = tAttrList[2][2]
				end
				--�������3
				if (randAttrNum >= 3) then
					randIdx3 = tAttrList[3][1]
					randVal3 = tAttrList[3][2]
				end
				--�������4
				if (randAttrNum >= 4) then
					randIdx4 = tAttrList[4][1]
					randVal4 = tAttrList[4][2]
				end
				--�������5
				if (randAttrNum >= 5) then
					randIdx5 = tAttrList[5][1]
					randVal5 = tAttrList[5][2]
				end
			end
		end
		
		local randSkillIdx1 = 61
		local randSkillLv1 = 62
		local randSkillIdx2 = 71
		local randSkillLv2 = 72
		local randSkillIdx3 = 81
		local randSkillLv3 = 82
		local equip = hClass.RedEquip:create():Init(0,typeid,slotnum,quality,strattr,xilianCount,cUnique,randIdx1,randVal1,randIdx2,randVal2,randIdx3,randVal3,randIdx4,randVal4,randIdx5,randVal5,randSkillIdx1,randSkillLv1,randSkillIdx2,randSkillLv2,randSkillIdx3,randSkillLv3)
		
		--�����ڴ�
		--self._edic[dbid] = equip
		
		--[[
		--geyachao: todo ս����ʱ������
		--4��������־
		if (slotnum == 4) then
		--if (slotnum > 0) then
			local sendnum = 0
			local flag = 99
			
			--Ŀǰ��Ҫ����������������Դ;��
			if (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_PURCHASE388) then --�׳�388Ԫ����
				sendnum = 10
				flag = 0
			elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_PURCHASE198) then --�׳�198Ԫ����
				sendnum = 10
				flag = 0
			elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDCHEST) then --�������ҳ鵽
				sendnum = 6
				flag = 0
			elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDDEBRIS) then --������ʯ�һ�
				sendnum = 6
				flag = 0
			elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_CANGBAOTU_HIGH) then --�߼��ر�ͼ�鵽
				sendnum = 6
				flag = 0
			elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_GROUPCHEST) then --���ű���鵽
				sendnum = 6
				flag = 0
			elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAILDRAWCARD) then --�ʼ�nѡ1��ȡ
				sendnum = 10
				flag = 0
			elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MERGE) then --�ϳ�
				sendnum = 6
				flag = 0
			end
			
			local itemName = hVar.tab_item[typeid] and hVar.tab_item[typeid].name or ""
			local sql = string.format("INSERT INTO `chat_redpacket_pay_redequip` (`uid`, `rid`, `itemId`, `itemName`, `gettime`, `gettype`, `gethint`, `sendnum`, `flag`) VALUES (%d, %d, %d, '%s', NOW(), %d, '%s', %d, %d)", uid, rid, typeid, itemName, nHintType, strHint, sendnum, flag)
			--print(sql)
			local err = xlDb_Execute(sql)
		end
		]]
		
		--[[
		--geyachao: todo ս����ʱ������
		--ͳ�Ʊ���4���������
		if (slotnum == 4) then
			local treasure = hClass.Treasure:create():Init(uid, rid)
			treasure:IncreaseMountCount(equip:GetCUnique(), typeid, slotnum, strattr)
		end
		]]
		
		return equip
	end
	
	--��õ���ϴ����Ҫ�Ļ��֣�оƬ��
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
		--[[
		--geyachao: ս������ת����װ��
		for i = 1, cOldRedEquipNum do
			local old = oldList[i]
			if old then
				local typeId = tonumber(old.typeId) or 0
				local uniqueId = tonumber(old.uniqueId) or 0
				local slotNum = tonumber(old.slotNum) or 0
				local strAttr = old.strAttr
				
				--�ϰ� ��ӥ����񻤼�
				if (typeId == 11007 or typeId == 11082) and uniqueId > 0 then
					local equip = self:_NewEquip(RedEquipMgr.OLD_TYPEID_CHANGE[typeId],4,0,nil,tab_string["__TEXT_REWARDTYPE_TRANFSORM"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_TRANFSORM)
					if equip then
						equip:SetCUnique(uniqueId)
					
						local tAttr = hApi.Split(strAttr,":")
						for n = 1, slotNum do
							equip:SetAttr(n, tAttr[n])
						end
						
						local saveOk = equip:DBSave(uid,rid)
						if saveOk then
							--�����ڴ�
							self._edic[equip:GetDBID()] = equip
						end
					end
				end
			end
		end
		]]
	end
	
	--[[
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
	]]
	
	--DB��������
	function RedEquipMgr:DBAddEquip(typeid,slotnum,quality,cRedequipCrystal,strHint, nHintType)
		
		local uid = self._uid
		local rid = self._rid
		
		local equip = self:_NewEquip(typeid,slotnum,quality,cRedequipCrystal,strHint, nHintType)
		
		--print("RedEquipMgr:DBAddEquip equip=", typeid, equip)
		if equip then
			local saveOk = equip:DBSave(uid,rid)
			if saveOk then
				--�����ڴ�
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
		--		local equip = hClass.RedEquip:create():Init(dbid,typeid,slotnum,quality,strattr)
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
		local bRet = false
		
		local uid = self._uid
		local rid = self._rid
		
		local equip = self:_DBGetRedEquipByDBID(itemDbid)
		if equip then
			local itemId = equip:GetTypeID()
			local tabI = hVar.tab_item[itemId]
			local oldInfo = equip:InfoToCmd()
			if tabI then
				local itemLv = tabI.itemLv
				
				--���Ļ��֣�оƬ��
				local costScore = self:_GetItemXiLianScore(equip, itemLv)
				local rmb, sendItemId = self:_GetItemLockInfo(lockNum)
				
				--print("rmb:",lockNum,rmb,sendItemId,costScore)
				
				--оƬ�Ƿ��㹻
				local debrisNum = 0
				local sql = string.format("SELECT `equip_crystal` FROM `t_user` where  `uid`= %d", uid)
				local err, equip_crystal = xlDb_Query(sql)
				--print("sql:",err,sql)
				if err == 0 then
					debrisNum = equip_crystal
				end
				
				if (debrisNum >= costScore) then
					--����ϴ��
					local xilianOk = equip:XiLian(lockIdDic)
					
					if xilianOk then
						local newInfo = equip:InfoToCmd()
						--�ж���Ϸ���Ƿ��㹻
						local bSuccess, orderId = hGlobal.userCoinMgr:DBUserPurchase(uid,rid,sendItemId,1,rmb,costScore,oldInfo .. ";" .. newInfo)
						if bSuccess then
							equip:AddXiLianCount()
							local saveOk = equip:DBSave(uid,rid)
							if saveOk then
								--�����ڴ�
								self._edic[equip:GetDBID()] = equip
								
								--[[
								--geyachao: todo ս����ʱ������
								--ͳ�Ʊ�������ϴ������
								if (lockNum > 0) then
									local treasure = hClass.Treasure:create():Init(uid, rid)
									treasure:IncreaseXiLianCount(orderId, itemDbid, itemId, lockNum, lockIdDic)
								end
								]]
								
								--[[
								--geyachao: todo ս����ʱ������
								--����ÿ�������£�
								--�����ɸ֣���װ��
								local taskType = hVar.TASK_TYPE.TASK_EQUIP_XILIAN --�����ɸ֣���װ��
								local addCount = 1
								local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(uid, rid)
								taskMgr:AddTaskFinishCount(taskType, addCount)
								]]
								
								--����оƬ
								--����
								local sUpdate = string.format("UPDATE `t_user` SET `equip_crystal` = `equip_crystal` - %d where `uid` = %d", costScore, uid)
								--print("sUpdate1:",sUpdate)
								xlDb_Execute(sUpdate)
								
								--����ɹ�
								ret = "1;" .. ret
								ret = ret .. tostring(0) .. ":" .. tostring(sendItemId) .. ":" .. tostring(1) .. ":".. tostring(costScore) .. ":" .. tostring(rmb) .. ":" .. tostring(1) .. ":" .. tostring(1) .. ";"
								ret = ret .. newInfo

								bRet = true
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
					ret = "-6;" .. ret	--оƬ����
				end
			else
				ret = "-2;" .. ret	--װ�����Ͳ�����
			end
		else
			ret = "-1;" .. ret	--װ��������
		end
		
		return ret, bRet
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
				--[[
				--�������
				for i = 1, #hVar.ITEM_MERGE_SLOT_PROB, 1 do
					print(hVar.ITEM_MERGE_SLOT_PROB[i].value, hVar.ITEM_MERGE_SLOT_PROB[i].reward)
				end
				]]
				slotnum = self:_RollDrop(hVar.ITEM_MERGE_SLOT_PROB) --��̳����
			end
			local newEquip = self:_NewEquip(newInfo[2],slotnum,0,nil,hVar.tab_string["__TEXT_REWARDTYPE_MERGE"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MERGE)
			
			local purchaseInfo = tostring(okFlag) .. ";"
			if okFlag == 1 then
				purchaseInfo = purchaseInfo .. oldInfo .. newEquip:InfoToCmd()
			else
				purchaseInfo = purchaseInfo .. oldInfo
			end
			
			--�ж���Ϸ���Ƿ��㹻
			local rmbCost = math.ceil(shopItem:GetRmbCost() * (math.max(materialNum,1)))
			local bSuccess, orderId = hGlobal.userCoinMgr:DBUserPurchase(uid,rid,shopItem:GetItemID(),1,rmbCost,0,purchaseInfo)
			if bSuccess then
				for i = 1, materialNum do
					local material = equipDic[materialDbidList[i]]
					material:DBSave(uid,rid)
					
					--�����ڴ�
					self._edic[material:GetDBID()] = nil
				end
				ret = "1;" .. ret .. tostring(okFlag) ..";"
				if okFlag == 1 then
					mergeItem:DBSave(uid,rid)
					newEquip:DBSave(uid,rid)
					
					--�����ڴ�
					self._edic[mergeItem:GetDBID()] = nil
					
					--�����ڴ�
					self._edic[newEquip:GetDBID()] = newEquip
					
					--ͳ�Ʊ���ϳ�3�׺�װ��������
					if (slotnum >= 3) then
						local treasure = hClass.Treasure:create():Init(uid, rid)
						treasure:IncreaseMerge3SlotCount(newEquip:GetCUnique(), newEquip:GetTypeID(), slotnum, orderId)
					end
					
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

	--�ֽ��װ
	function RedEquipMgr:DBDescomposRedEquip(materialNum, materialDbidList)
		local ret =  tostring(materialNum) .. ";"
		
		
		local uid = self._uid
		local rid = self._rid

		--����װ��������װ����dbid�����б���
		local itemDBidList = {}
		for i = 1, materialNum do
			itemDBidList[#itemDBidList + 1] = materialDbidList[i]
			ret = ret .. materialDbidList[i] .. ";"
		end

		local equipDic = self:_DBGetRedEquipsByDBIDList(itemDBidList)
		local oldInfo = ""
		--�ж��ֽ�װ���Ƿ����
		for i = 1, #itemDBidList do
			local equip = equipDic[itemDBidList[i]]
			if not equip then
				ret = "-1;"..ret
				return ret
			else
				oldInfo = oldInfo .. equip:InfoToCmd() .. ";"
			end
		end

		--���ۼ�Ǯ
		local shopItem = hClass.ShopItem:create():Init(RedEquipMgr.DESCOMPOS_SHOPITEMID)
		local purchaseInfo = "1;".. oldInfo

		--�ж���Ϸ���Ƿ��㹻
		local rmbCost = 0
		local bSuccess, orderId = hGlobal.userCoinMgr:DBUserPurchase(uid,rid,shopItem:GetItemID(),1,rmbCost,0,purchaseInfo)
		if bSuccess then
			
			local crystalSum = 0
			
			for i = 1, materialNum do
				local material = equipDic[materialDbidList[i]]
				--��ֽ��װ������Ϊɾ��
				material:SetDelete()
				material:DBSave(uid,rid)
				
				--�����ڴ�
				self._edic[material:GetDBID()] = nil
				
				--���������ʯ
				local typeid = material:GetTypeID()
				local tabI = hVar.tab_item[typeid]
				local itemLv = tabI.itemLv or 0
				local crystal = hVar.ITEM_SELL_CRYSTAL[itemLv] or 0
				crystalSum = crystalSum + crystal
				
			end
			
			if (crystalSum > 0) then
				hGlobal.userCoinMgr:DBAddCrystal(uid,crystalSum)
			end
			
			ret = "1;" .. crystalSum .. ";" .. ret
			
		else
			ret = "-2;0;"..ret
		end

		return ret
	end
	
	--��װ����һ���װ
	function RedEquipMgr:DBScroll2RedEquip(idx)
		local cmd = ""
		local result = 0
		local prizeId = 0 --���佱��id
		
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
						--����id
						local err1, pid = xlDb_Query("select last_insert_id()")
						if (err1 == 0) then
							prizeId = pid
						end
						
						--�����ɹ�
						result = 1
						
						--��ȡ���佱��
						local fromIdx = 2
						cmd = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_REDSCROLL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDSCROLL)
					end
					
				end
			end
		end
		
		local sL2CCmd = result .. ";" .. cmd
		return sL2CCmd
	end
	
	--������Ʒ�ʺ�������ԣ�
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