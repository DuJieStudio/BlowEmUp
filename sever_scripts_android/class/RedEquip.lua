--��װ��
local RedEquip = class("RedEquip")
    
	--���캯��
	function RedEquip:ctor()
		self._dbid = -1
		self._typeid = -1
		self._slotnum = -1
		self._attr = -1
		self._xilianCount = -1
		self._quality = -1 --Ʒ��
		self._deleteFlag = -1
		self._cUnique = -1
		self._cRandAttrIdx1 = -1	--�����������1
		self._cRandAttrVal1 = -1	--�������ֵ1
		self._cRandAttrIdx2 = -1	--�����������2
		self._cRandAttrVal2 = -1	--�������ֵ2
		self._cRandAttrIdx3 = -1	--�����������3
		self._cRandAttrVal3 = -1	--�������ֵ3
		self._cRandAttrIdx4 = -1	--�����������4
		self._cRandAttrVal4 = -1	--�������ֵ4
		self._cRandAttrIdx5 = -1	--�����������5
		self._cRandAttrVal5 = -1	--�������ֵ5
		self._cRandSkillIdx1 = -1	--�����������1
		self._cRandSkillLv1 = -1	--������ܵȼ�1
		self._cRandSkillIdx2 = -1	--�����������2
		self._cRandSkillLv2 = -1	--������ܵȼ�2
		self._cRandSkillIdx3 = -1	--�����������3
		self._cRandSkillLv3 = -1	--������ܵȼ�3
		
		return self
	end
	
	--��ʼ������
	function RedEquip:Init(dbid,typeid,slotnum,quality,strattr,xilianCount,cUnique,randIdx1,randVal1,randIdx2,randVal2,randIdx3,randVal3,randIdx4,randVal4,randIdx5,randVal5,randSkillIdx1,randSkillLv1,randSkillIdx2,randSkillLv2,randSkillIdx3,randSkillLv3)
		--print("RedEquip:Init", dbid,typeid,slotnum,quality,strattr,xilianCount,cUnique)
		self._dbid = dbid
		self._typeid = typeid
		self._slotnum = slotnum or 0
		self._xilianCount = xilianCount or 0
		self._quality = quality or 0 --Ʒ��
		self._deleteFlag = 0
		self._cUnique = cUnique or 0
		if self._slotnum > 0 and strattr then
			--string���͵�����ת���ַ�������
			self._attr = self:_S2TAttr(strattr)
		else
			self._attr = {}
		end
		
		self._cRandAttrIdx1 = randIdx1		--�����������1
		self._cRandAttrVal1 = randVal1		--�������ֵ1
		self._cRandAttrIdx2 = randIdx2		--�����������2
		self._cRandAttrVal2 = randVal2		--�������ֵ2
		self._cRandAttrIdx3 = randIdx3		--�����������3
		self._cRandAttrVal3 = randVal3		--�������ֵ3
		self._cRandAttrIdx4 = randIdx4		--�����������4
		self._cRandAttrVal4 = randVal4		--�������ֵ4
		self._cRandAttrIdx5 = randIdx5		--�����������5
		self._cRandAttrVal5 = randVal5		--�������ֵ5
		
		self._cRandSkillIdx1 = randSkillIdx1	--�����������1
		self._cRandSkillLv1 = randSkillLv1	--������ܵȼ�1
		self._cRandSkillIdx2 = randSkillIdx2	--�����������2
		self._cRandSkillLv2 = randSkillLv2	--������ܵȼ�2
		self._cRandSkillIdx3 = randSkillIdx3	--�����������3
		self._cRandSkillLv3 = randSkillLv3	--������ܵȼ�3
		
		return self
	end
	
	--��������
	function RedEquip:Release()
		self._dbid = -1
		self._typeid = -1
		self._slotnum = -1
		self._attr = -1
		self._xilianCount = -1
		self._quality = -1 --Ʒ��
		self._deleteFlag = -1
		self._cUnique = -1
		self._cRandAttrIdx1 = -1	--�����������1
		self._cRandAttrVal1 = -1	--�������ֵ1
		self._cRandAttrIdx2 = -1	--�����������2
		self._cRandAttrVal2 = -1	--�������ֵ2
		self._cRandAttrIdx3 = -1	--�����������3
		self._cRandAttrVal3 = -1	--�������ֵ3
		self._cRandAttrIdx4 = -1	--�����������4
		self._cRandAttrVal4 = -1	--�������ֵ4
		self._cRandAttrIdx5 = -1	--�����������5
		self._cRandAttrVal5 = -1	--�������ֵ5
		self._cRandSkillIdx1 = -1	--�����������1
		self._cRandSkillLv1 = -1	--������ܵȼ�1
		self._cRandSkillIdx2 = -1	--�����������2
		self._cRandSkillLv2 = -1	--������ܵȼ�2
		self._cRandSkillIdx3 = -1	--�����������3
		self._cRandSkillLv3 = -1	--������ܵȼ�3
	end
	
	------------------------------------------------------------private-------------------------------------------------------
	--��ȡ��װdbid
	function RedEquip:_SetDBID(dbid)
		self._dbid = dbid
	end
	
	--��������ϴ������Ʒ��
	function RedEquip:_MakeItemXiLianAttrLv(itemLv)
		--��������Ʒ��
		local ret = 0
		--����Ȩ�ط�Χ��ʱֵ
		local tmpAttrInfo = {}
		--��Ȩֵ
		local sumWeight = 0
		
		--��ȡ��ǰ����Ʒ�ʵȼ���Ӧ������Ȩֵ��Ϣ
		if hVar.ITEM_XILIAN_INFO[itemLv] and hVar.ITEM_XILIAN_INFO[itemLv].attr then
			
			--����Ȩ����Ϣ
			local attrInfo = hVar.ITEM_XILIAN_INFO[itemLv].attr
			
			--��������Ȩ����Ϣ����¼ÿһ������Ȩ�ط�Χ�������ܵ�Ȩ��
			for attr,weight in pairs(attrInfo) do
				--Ȩ��Ϊ0ֱ������
				if weight > 0 then
					tmpAttrInfo[attr] = {}
					tmpAttrInfo[attr].min = sumWeight
					sumWeight = sumWeight + weight
					tmpAttrInfo[attr].max = sumWeight
				end
			end
			
			--����Ȩ�ط�Χ�����
			if (sumWeight > 0) then
				local rWeight = math.random(1, sumWeight)
				
				--����Ȩ�ط�Χ��ʱֵ,�����Ȩֵ�����ĸ�����
				for attr, weightInfo in pairs(tmpAttrInfo) do
					if rWeight > weightInfo.min and rWeight <= weightInfo.max then
						ret = attr
						break
					end
				end
			end
		end
		
		return ret
	end
	
	--��ȡװ���������
	function RedEquip:_GetItemRandomAttr(attrR, excludeAttr)
		local baseAttrSet = hVar.ITEM_ATTR_QUALITY_DEF[attrR]
		
		if baseAttrSet then
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
	end
	
	------------------------------------------------------------public-------------------------------------------------------
	--��ȡ��װdbid
	function RedEquip:GetDBID()
		return self._dbid
	end
	--��ȡ��װtypeid
	function RedEquip:GetTypeID()
		return self._typeid
	end
	--��ȡ��װ����
	function RedEquip:GetSlotNum()
		return self._slotnum
	end
	--��ȡ��װ����
	function RedEquip:GetAttr()
		return self._attr
	end
	--��ȡ��װ�����ַ���
	function RedEquip:GetStrAttr()
		return self:_T2SAttr(self._attr)
	end
	
	--��ȡ��װϴ������
	function RedEquip:GetXiLianCount()
		return self._xilianCount
	end
	--��ȡ��װƷ��
	function RedEquip:GetQuality()
		return self._quality --Ʒ��
	end
	
	--��ȡ��װɾ�����
	function RedEquip:GetDeleteFlag()
		return self._deleteFlag
	end
	--��ȡ��װ�Ŀͻ���uniqueId
	function RedEquip:GetCUnique()
		return self._cUnique
	end
	--��װ�����ַ���ת��
	function RedEquip:_S2TAttr(strattr)
		local attr = hApi.Split(strattr, "|")
		return attr
	end
	--��װ���Ա�ת�ַ���
	function RedEquip:_T2SAttr(attr)
		local strattr = ""
		if attr and type(attr) == "table" then
			for i = 1, self:GetSlotNum() do
				strattr = strattr .. attr[i].. "|"
			end
		end
		return strattr
	end
	--��װϴ����������
	function RedEquip:AddXiLianCount()
		self._xilianCount = self._xilianCount + 1
	end
	
	--��װ����Ʒ��
	function RedEquip:SetQuality(quality)
		self._quality = quality --Ʒ��
	end
	
	--��װ���Ըı�
	function RedEquip:SetAttr(idx, attr)
		if idx > 0 and idx <= self:GetSlotNum() and hVar.ITEM_ATTR_VAL[attr] then
			self._attr[idx] = attr
		end
	end
	--���ú�װΪɾ��
	function RedEquip:SetDelete()
		self._deleteFlag = 1
	end
	--���ú�װ�Ŀͻ���uniqueId
	function RedEquip:SetCUnique(cUnique)
		self._cUnique = cUnique
	end

	--��װϴ��(����:�����б�)
	function RedEquip:XiLian(slotLock)

		
		--xilianItemIdx: Ҫϴ�����ߵı�������λ��
		--slotPosList: Ҫϴ�����ߵĲ۵�λ�ü�
		
		--print("XiLian Item begin:----------------------------------------")
		
		--��ʼϴ��
		--...
		local ret = false
		
		--��������
		local baseRatio = 0
		--�ϳɲ��ϼ�ֵ
		local totalItemValue = 0

		local typeId = self:GetTypeID()
		local itemTabI = hVar.tab_item[typeId]				--ϴ������tab��
		
		--���������tab����ڣ���������װ��
		if itemTabI then
			--����������tab��������
			--local itemLv = hVar.ITEM_QUALITY.ORANGE			--�����ߵ���Ʒ��
			local itemLv = itemTabI.itemLv		--�����ߵ���Ʒ��
			local itemMaxSlot = self:GetSlotNum()
			
			--���ڴ������������ԣ��´����ʱ�ų�������
			local excludeAttr = {}

			--����ϴ��������λ
			local attrList = self:GetAttr()

			--�Ȱ�װ�����Ѿ��е����Զ����ų��б�
			for lockIdx, _ in pairs(slotLock) do
				local attr = attrList[lockIdx]
				if attr and type(attr) == "string" and hVar.ITEM_ATTR_VAL[attr] then
					excludeAttr[#excludeAttr + 1] = attr
				end
			end

			
			local strTag = ""
			
			for i = 1, self:GetSlotNum() do
				local attr = attrList[i]
				if attr and type(attr) == "string" and hVar.ITEM_ATTR_VAL[attr] and not slotLock[i] then
					--���ݵ��ߵȼ����һ�����Եȼ�
					local attrLv = self:_MakeItemXiLianAttrLv(itemLv)
					--print("itemLv=", itemLv, "attrLv=", attrLv)
					local newAttr = self:_GetItemRandomAttr(attrLv, excludeAttr)
					self:SetAttr(i,newAttr)
				elseif slotLock[i] then
				end
			end

			ret = true

		else
			--todo:error ���ϳɵ��߲�����
		end
		
		return ret

	end

	function RedEquip:DBSave(uid,rid)
		
		local ret = false
		local dbid = self:GetDBID()
		local typeid = self:GetTypeID()
		local slotnum = self:GetSlotNum()
		local quality = self:GetQuality()
		local strattr = self:GetStrAttr()
		local xiliancount = self:GetXiLianCount()
		local deleteFlag = self:GetDeleteFlag()
		local cUnique = self:GetCUnique()
		
		local sql = ""
		--��������
		if dbid > 0 then
			if deleteFlag == 1 then
				sql = string.format("UPDATE t_user_redequip SET `deleteflag`=1 WHERE `id`=%d AND `uid`=%d AND `rid`=%d",dbid,uid,rid)
			else
				sql = string.format("UPDATE t_user_redequip SET `slotNum`=%d,`quality`=%d,`itemAttr`='%s',`xilian_count`=%d, `cUnique`=%d, `randIdx1` = %d, `randVal1` = %d, `randIdx2` = %d, `randVal2` = %d, `randIdx3` = %d, `randVal3` = %d, `randIdx4` = %d, `randVal4` = %d, `randIdx5` = %d, `randVal5` = %d, `randSkillIdx1` = %d, `randSkillLv1` = %d, `randSkillIdx2` = %d, `randSkillLv2` = %d, `randSkillIdx3` = %d, `randSkillLv3` = %d WHERE `id`=%d AND `uid`=%d AND `rid`=%d",slotnum,quality,strattr,xiliancount,cUnique,self._cRandAttrIdx1,self._cRandAttrVal1,self._cRandAttrIdx2,self._cRandAttrVal2,self._cRandAttrIdx3,self._cRandAttrVal3,self._cRandAttrIdx4,self._cRandAttrVal4,self._cRandAttrIdx5,self._cRandAttrVal5,self._cRandSkillIdx1,self._cRandSkillLv1,self._cRandSkillIdx2,self._cRandSkillLv2,self._cRandSkillIdx3,self._cRandSkillLv3,dbid,uid,rid)
			end
		else --�½�װ��
			sql = string.format("INSERT INTO t_user_redequip (`uid`,`rid`,`itypeid`,`slotNum`,`quality`,`itemAttr`,`cUnique`,`randIdx1`,`randVal1`,`randIdx2`,`randVal2`,`randIdx3`,`randVal3`,`randIdx4`,`randVal4`,`randIdx5`,`randVal5`,`randSkillIdx1`,`randSkillLv1`,`randSkillIdx2`,`randSkillLv2`,`randSkillIdx3`,`randSkillLv3`) VALUES (%d,%d,%d,%d,%d,'%s',%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d)", uid,rid,typeid,slotnum,quality,strattr,cUnique,self._cRandAttrIdx1,self._cRandAttrVal1,self._cRandAttrIdx2,self._cRandAttrVal2,self._cRandAttrIdx3,self._cRandAttrVal3,self._cRandAttrIdx4,self._cRandAttrVal4,self._cRandAttrIdx5,self._cRandAttrVal5,self._cRandSkillIdx1,self._cRandSkillLv1,self._cRandSkillIdx2,self._cRandSkillLv2,self._cRandSkillIdx3,self._cRandSkillLv3)
		end
		
		--print(sql)
		
		--ִ��sql
		local err = xlDb_Execute(sql)
		--print(err)
		if err == 0 then
			--��������
			if dbid > 0 then
				ret = true
			else
				local err1, dbid = xlDb_Query("select last_insert_id()")
				if err1 == 0 then
					self:_SetDBID(dbid)
					ret = true
				else

				end
			end
		end

		return ret

	end
	
	--������Ϣת��������Ʒ�ʺ�������ԣ�
	function RedEquip:InfoToCmd()
		local cmd = tostring(self:GetDBID()) .. ":" .. tostring(self:GetTypeID()) .. ":" .. tostring(self:GetSlotNum()) .. ":" .. tostring(self:GetStrAttr())
			.. ":" .. tostring(self:GetCUnique()) .. ":" .. tostring(self:GetQuality())
			.. ":" .. tostring(self._cRandAttrIdx1).. ":" .. tostring(self._cRandAttrVal1)
			.. ":" .. tostring(self._cRandAttrIdx2).. ":" .. tostring(self._cRandAttrVal2)
			.. ":" .. tostring(self._cRandAttrIdx3).. ":" .. tostring(self._cRandAttrVal3)
			.. ":" .. tostring(self._cRandAttrIdx4).. ":" .. tostring(self._cRandAttrVal4)
			.. ":" .. tostring(self._cRandAttrIdx5).. ":" .. tostring(self._cRandAttrVal5)
			.. ":" .. tostring(self._cRandSkillIdx1).. ":" .. tostring(self._cRandSkillLv1)
			.. ":" .. tostring(self._cRandSkillIdx2).. ":" .. tostring(self._cRandSkillLv2)
			.. ":" .. tostring(self._cRandSkillIdx3).. ":" .. tostring(self._cRandSkillLv3)
		return cmd
	end
	
	--������Ϣת��2������Ʒ�ʺ�������ԣ�
	function RedEquip:InfoToCmdEx()
		local cmd = tostring(self:GetDBID()) .. "|" .. tostring(self:GetTypeID()) .. "|" .. tostring(self:GetSlotNum()) .. "|" .. tostring(self:GetStrAttr())
			.. "|" .. tostring(self:GetCUnique()) .. "|" .. tostring(self:GetQuality())
			.. "|" .. tostring(self._cRandAttrIdx1).. "|" .. tostring(self._cRandAttrVal1)
			.. "|" .. tostring(self._cRandAttrIdx2).. "|" .. tostring(self._cRandAttrVal2)
			.. "|" .. tostring(self._cRandAttrIdx3).. "|" .. tostring(self._cRandAttrVal3)
			.. "|" .. tostring(self._cRandAttrIdx4).. "|" .. tostring(self._cRandAttrVal4)
			.. "|" .. tostring(self._cRandAttrIdx5).. "|" .. tostring(self._cRandAttrVal5)
			.. "|" .. tostring(self._cRandSkillIdx1).. "|" .. tostring(self._cRandSkillLv1)
			.. "|" .. tostring(self._cRandSkillIdx2).. "|" .. tostring(self._cRandSkillLv2)
			.. "|" .. tostring(self._cRandSkillIdx3).. "|" .. tostring(self._cRandSkillLv3)
		return cmd
	end

return RedEquip