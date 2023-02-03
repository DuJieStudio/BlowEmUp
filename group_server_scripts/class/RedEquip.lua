--��װ��
local RedEquip = class("RedEquip")
    
	--���캯��
	function RedEquip:ctor()
		self._dbid = -1
		self._typeid = -1
		self._slotnum = -1
		self._attr = -1
		self._xilianCount = -1
		self._deleteFlag = -1
		self._cUnique = -1

		return self
	end
	--��ʼ������
	function RedEquip:Init(dbid,typeid,slotnum,strattr,xilianCount,cUnique)
		self._dbid = dbid
		self._typeid = typeid
		self._slotnum = slotnum or 0
		self._xilianCount = xilianCount or 0
		self._deleteFlag = 0
		self._cUnique = cUnique or 0
		if self._slotnum > 0 and strattr then
			--string���͵�����ת���ַ�������
			self._attr = self:_S2TAttr(strattr)
		else
			self._attr = {}
		end
		return self
	end
	--��������
	function RedEquip:Release()
		self._dbid = -1
		self._typeid = -1
		self._slotnum = -1
		self._attr = -1
		self._xilianCount = -1
		self._deleteFlag = -1
		self._cUnique = -1
	end
	
	------------------------------------------------------------private-------------------------------------------------------
	--��ȡ��װdbid
	function RedEquip:_SetDBID(dbid)
		self._dbid = dbid
	end

	--��������ϴ������Ʒ��
	function RedEquip:_MakeItemXiLianAttrLv(itemLv)
		--��������Ʒ��
		local ret
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
			local rWeight = math.random(1, sumWeight)
			
			--����Ȩ�ط�Χ��ʱֵ,�����Ȩֵ�����ĸ�����
			for attr, weightInfo in pairs(tmpAttrInfo) do
				if rWeight > weightInfo.min and rWeight <= weightInfo.max then
					ret = attr
					break
				end
			end
		end

		return ret
	end

	--��ȡװ���������
	function RedEquip:_GetItemRandomAttr(attrR, excludeAttr)
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
			local itemLv = hVar.ITEM_QUALITY.ORANGE			--�����ߵ���Ʒ��
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
				sql = string.format("UPDATE t_user_redequip SET `slotNum`=%d,`itemAttr`='%s',`xilian_count`=%d, `cUnique`=%d WHERE `id`=%d AND `uid`=%d AND `rid`=%d",slotnum,strattr,xiliancount,cUnique,dbid,uid,rid)
			end
		else --�½�װ��
			sql = string.format("INSERT INTO t_user_redequip (`uid`,`rid`,`itypeid`,`slotNum`,`itemAttr`,`cUnique`) VALUES (%d,%d,%d,%d,'%s',%d)", uid,rid,typeid,slotnum,strattr,cUnique)
		end

		--ִ��sql
		local err = xlDb_Execute(sql)
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
	
	--������Ϣת��
	function RedEquip:InfoToCmd()
		local cmd = tostring(self:GetDBID()) .. ":" .. tostring(self:GetTypeID()) .. ":" .. tostring(self:GetSlotNum()) .. ":" .. tostring(self:GetStrAttr()) .. ":" .. tostring(self:GetCUnique())
		return cmd
	end

	--������Ϣת��2
	function RedEquip:InfoToCmdEx()
		local cmd = tostring(self:GetDBID()) .. "|" .. tostring(self:GetTypeID()) .. "|" .. tostring(self:GetSlotNum()) .. "|" .. tostring(self:GetStrAttr()) .. "|" .. tostring(self:GetCUnique())
		return cmd
	end

return RedEquip