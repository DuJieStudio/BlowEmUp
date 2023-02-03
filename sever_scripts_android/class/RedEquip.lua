--红装类
local RedEquip = class("RedEquip")
    
	--构造函数
	function RedEquip:ctor()
		self._dbid = -1
		self._typeid = -1
		self._slotnum = -1
		self._attr = -1
		self._xilianCount = -1
		self._quality = -1 --品质
		self._deleteFlag = -1
		self._cUnique = -1
		self._cRandAttrIdx1 = -1	--随机属性索引1
		self._cRandAttrVal1 = -1	--随机属性值1
		self._cRandAttrIdx2 = -1	--随机属性索引2
		self._cRandAttrVal2 = -1	--随机属性值2
		self._cRandAttrIdx3 = -1	--随机属性索引3
		self._cRandAttrVal3 = -1	--随机属性值3
		self._cRandAttrIdx4 = -1	--随机属性索引4
		self._cRandAttrVal4 = -1	--随机属性值4
		self._cRandAttrIdx5 = -1	--随机属性索引5
		self._cRandAttrVal5 = -1	--随机属性值5
		self._cRandSkillIdx1 = -1	--随机技能索引1
		self._cRandSkillLv1 = -1	--随机技能等级1
		self._cRandSkillIdx2 = -1	--随机技能索引2
		self._cRandSkillLv2 = -1	--随机技能等级2
		self._cRandSkillIdx3 = -1	--随机技能索引3
		self._cRandSkillLv3 = -1	--随机技能等级3
		
		return self
	end
	
	--初始化函数
	function RedEquip:Init(dbid,typeid,slotnum,quality,strattr,xilianCount,cUnique,randIdx1,randVal1,randIdx2,randVal2,randIdx3,randVal3,randIdx4,randVal4,randIdx5,randVal5,randSkillIdx1,randSkillLv1,randSkillIdx2,randSkillLv2,randSkillIdx3,randSkillLv3)
		--print("RedEquip:Init", dbid,typeid,slotnum,quality,strattr,xilianCount,cUnique)
		self._dbid = dbid
		self._typeid = typeid
		self._slotnum = slotnum or 0
		self._xilianCount = xilianCount or 0
		self._quality = quality or 0 --品质
		self._deleteFlag = 0
		self._cUnique = cUnique or 0
		if self._slotnum > 0 and strattr then
			--string类型的数据转成字符串类型
			self._attr = self:_S2TAttr(strattr)
		else
			self._attr = {}
		end
		
		self._cRandAttrIdx1 = randIdx1		--随机属性索引1
		self._cRandAttrVal1 = randVal1		--随机属性值1
		self._cRandAttrIdx2 = randIdx2		--随机属性索引2
		self._cRandAttrVal2 = randVal2		--随机属性值2
		self._cRandAttrIdx3 = randIdx3		--随机属性索引3
		self._cRandAttrVal3 = randVal3		--随机属性值3
		self._cRandAttrIdx4 = randIdx4		--随机属性索引4
		self._cRandAttrVal4 = randVal4		--随机属性值4
		self._cRandAttrIdx5 = randIdx5		--随机属性索引5
		self._cRandAttrVal5 = randVal5		--随机属性值5
		
		self._cRandSkillIdx1 = randSkillIdx1	--随机技能索引1
		self._cRandSkillLv1 = randSkillLv1	--随机技能等级1
		self._cRandSkillIdx2 = randSkillIdx2	--随机技能索引2
		self._cRandSkillLv2 = randSkillLv2	--随机技能等级2
		self._cRandSkillIdx3 = randSkillIdx3	--随机技能索引3
		self._cRandSkillLv3 = randSkillLv3	--随机技能等级3
		
		return self
	end
	
	--析构函数
	function RedEquip:Release()
		self._dbid = -1
		self._typeid = -1
		self._slotnum = -1
		self._attr = -1
		self._xilianCount = -1
		self._quality = -1 --品质
		self._deleteFlag = -1
		self._cUnique = -1
		self._cRandAttrIdx1 = -1	--随机属性索引1
		self._cRandAttrVal1 = -1	--随机属性值1
		self._cRandAttrIdx2 = -1	--随机属性索引2
		self._cRandAttrVal2 = -1	--随机属性值2
		self._cRandAttrIdx3 = -1	--随机属性索引3
		self._cRandAttrVal3 = -1	--随机属性值3
		self._cRandAttrIdx4 = -1	--随机属性索引4
		self._cRandAttrVal4 = -1	--随机属性值4
		self._cRandAttrIdx5 = -1	--随机属性索引5
		self._cRandAttrVal5 = -1	--随机属性值5
		self._cRandSkillIdx1 = -1	--随机技能索引1
		self._cRandSkillLv1 = -1	--随机技能等级1
		self._cRandSkillIdx2 = -1	--随机技能索引2
		self._cRandSkillLv2 = -1	--随机技能等级2
		self._cRandSkillIdx3 = -1	--随机技能索引3
		self._cRandSkillLv3 = -1	--随机技能等级3
	end
	
	------------------------------------------------------------private-------------------------------------------------------
	--获取红装dbid
	function RedEquip:_SetDBID(dbid)
		self._dbid = dbid
	end
	
	--产生道具洗练属性品质
	function RedEquip:_MakeItemXiLianAttrLv(itemLv)
		--返回属性品质
		local ret = 0
		--属性权重范围临时值
		local tmpAttrInfo = {}
		--总权值
		local sumWeight = 0
		
		--获取当前道具品质等级对应的属性权值信息
		if hVar.ITEM_XILIAN_INFO[itemLv] and hVar.ITEM_XILIAN_INFO[itemLv].attr then
			
			--属性权重信息
			local attrInfo = hVar.ITEM_XILIAN_INFO[itemLv].attr
			
			--遍历所有权重信息，记录每一个属性权重范围，计算总的权重
			for attr,weight in pairs(attrInfo) do
				--权重为0直接跳过
				if weight > 0 then
					tmpAttrInfo[attr] = {}
					tmpAttrInfo[attr].min = sumWeight
					sumWeight = sumWeight + weight
					tmpAttrInfo[attr].max = sumWeight
				end
			end
			
			--在总权重范围内随机
			if (sumWeight > 0) then
				local rWeight = math.random(1, sumWeight)
				
				--遍历权重范围临时值,看随机权值落在哪个区间
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
	
	--获取装备随机属性
	function RedEquip:_GetItemRandomAttr(attrR, excludeAttr)
		local baseAttrSet = hVar.ITEM_ATTR_QUALITY_DEF[attrR]
		
		if baseAttrSet then
			--获取属性池
			--计算，如果已经抽取的属性不再抽取
			local attrSet = {}
			for i = 1, #hVar.ITEM_ATTR_QUALITY_DEF[attrR] do
				local flag = true
				local baseAttr = hVar.ITEM_ATTR_QUALITY_DEF[attrR][i]
				for j = 1, #excludeAttr do
					local excludeAttr = excludeAttr[j]
					--排除已经抽取的属性
					if hVar.ITEM_ATTR_VAL[baseAttr].attrAdd == hVar.ITEM_ATTR_VAL[excludeAttr].attrAdd then
						flag = false
						break
					end
				end
				if flag then
					attrSet[#attrSet + 1] = baseAttr
				end
			end
			
			--一个防出错机制，如果奖池中所有的属性都已经随出来过，则奖池等于基础奖池
			if #attrSet <= 0 then
				attrSet = baseAttrSet
			end
			--local attrSet = hVar.ITEM_ATTR_QUALITY_DEF[attrR]
			if #attrSet > 0 then
				--随机属性索引
				local attrIdx = math.random(1,#attrSet)
				--随机出的属性
				local attr = attrSet[attrIdx]
				if hVar.ITEM_ATTR_VAL[attr] then
					excludeAttr[#excludeAttr+1] = attr
					return attr
				end
			end
		end
	end
	
	------------------------------------------------------------public-------------------------------------------------------
	--获取红装dbid
	function RedEquip:GetDBID()
		return self._dbid
	end
	--获取红装typeid
	function RedEquip:GetTypeID()
		return self._typeid
	end
	--获取红装孔数
	function RedEquip:GetSlotNum()
		return self._slotnum
	end
	--获取红装属性
	function RedEquip:GetAttr()
		return self._attr
	end
	--获取红装属性字符串
	function RedEquip:GetStrAttr()
		return self:_T2SAttr(self._attr)
	end
	
	--获取红装洗练次数
	function RedEquip:GetXiLianCount()
		return self._xilianCount
	end
	--获取红装品质
	function RedEquip:GetQuality()
		return self._quality --品质
	end
	
	--获取红装删除标记
	function RedEquip:GetDeleteFlag()
		return self._deleteFlag
	end
	--获取红装的客户端uniqueId
	function RedEquip:GetCUnique()
		return self._cUnique
	end
	--红装属性字符串转表
	function RedEquip:_S2TAttr(strattr)
		local attr = hApi.Split(strattr, "|")
		return attr
	end
	--红装属性表转字符串
	function RedEquip:_T2SAttr(attr)
		local strattr = ""
		if attr and type(attr) == "table" then
			for i = 1, self:GetSlotNum() do
				strattr = strattr .. attr[i].. "|"
			end
		end
		return strattr
	end
	--红装洗练次数增加
	function RedEquip:AddXiLianCount()
		self._xilianCount = self._xilianCount + 1
	end
	
	--红装设置品质
	function RedEquip:SetQuality(quality)
		self._quality = quality --品质
	end
	
	--红装属性改变
	function RedEquip:SetAttr(idx, attr)
		if idx > 0 and idx <= self:GetSlotNum() and hVar.ITEM_ATTR_VAL[attr] then
			self._attr[idx] = attr
		end
	end
	--设置红装为删除
	function RedEquip:SetDelete()
		self._deleteFlag = 1
	end
	--设置红装的客户端uniqueId
	function RedEquip:SetCUnique(cUnique)
		self._cUnique = cUnique
	end

	--红装洗练(参数:锁孔列表)
	function RedEquip:XiLian(slotLock)

		
		--xilianItemIdx: 要洗炼道具的背包索引位置
		--slotPosList: 要洗炼道具的槽的位置集
		
		--print("XiLian Item begin:----------------------------------------")
		
		--开始洗炼
		--...
		local ret = false
		
		--基础概率
		local baseRatio = 0
		--合成材料价值
		local totalItemValue = 0

		local typeId = self:GetTypeID()
		local itemTabI = hVar.tab_item[typeId]				--洗练道具tab表
		
		--如果主道具tab表存在，主道具是装备
		if itemTabI then
			--计算主道具tab基础倍率
			--local itemLv = hVar.ITEM_QUALITY.ORANGE			--主道具道具品质
			local itemLv = itemTabI.itemLv		--主道具道具品质
			local itemMaxSlot = self:GetSlotNum()
			
			--用于存放已随出的属性，下次随机时排除该属性
			local excludeAttr = {}

			--遍历洗练的属性位
			local attrList = self:GetAttr()

			--先把装备上已经有的属性丢入排除列表
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
					--根据道具等级随机一个属性等级
					local attrLv = self:_MakeItemXiLianAttrLv(itemLv)
					--print("itemLv=", itemLv, "attrLv=", attrLv)
					local newAttr = self:_GetItemRandomAttr(attrLv, excludeAttr)
					self:SetAttr(i,newAttr)
				elseif slotLock[i] then
				end
			end

			ret = true

		else
			--todo:error 主合成道具不存在
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
		--更新数据
		if dbid > 0 then
			if deleteFlag == 1 then
				sql = string.format("UPDATE t_user_redequip SET `deleteflag`=1 WHERE `id`=%d AND `uid`=%d AND `rid`=%d",dbid,uid,rid)
			else
				sql = string.format("UPDATE t_user_redequip SET `slotNum`=%d,`quality`=%d,`itemAttr`='%s',`xilian_count`=%d, `cUnique`=%d, `randIdx1` = %d, `randVal1` = %d, `randIdx2` = %d, `randVal2` = %d, `randIdx3` = %d, `randVal3` = %d, `randIdx4` = %d, `randVal4` = %d, `randIdx5` = %d, `randVal5` = %d, `randSkillIdx1` = %d, `randSkillLv1` = %d, `randSkillIdx2` = %d, `randSkillLv2` = %d, `randSkillIdx3` = %d, `randSkillLv3` = %d WHERE `id`=%d AND `uid`=%d AND `rid`=%d",slotnum,quality,strattr,xiliancount,cUnique,self._cRandAttrIdx1,self._cRandAttrVal1,self._cRandAttrIdx2,self._cRandAttrVal2,self._cRandAttrIdx3,self._cRandAttrVal3,self._cRandAttrIdx4,self._cRandAttrVal4,self._cRandAttrIdx5,self._cRandAttrVal5,self._cRandSkillIdx1,self._cRandSkillLv1,self._cRandSkillIdx2,self._cRandSkillLv2,self._cRandSkillIdx3,self._cRandSkillLv3,dbid,uid,rid)
			end
		else --新建装备
			sql = string.format("INSERT INTO t_user_redequip (`uid`,`rid`,`itypeid`,`slotNum`,`quality`,`itemAttr`,`cUnique`,`randIdx1`,`randVal1`,`randIdx2`,`randVal2`,`randIdx3`,`randVal3`,`randIdx4`,`randVal4`,`randIdx5`,`randVal5`,`randSkillIdx1`,`randSkillLv1`,`randSkillIdx2`,`randSkillLv2`,`randSkillIdx3`,`randSkillLv3`) VALUES (%d,%d,%d,%d,%d,'%s',%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d)", uid,rid,typeid,slotnum,quality,strattr,cUnique,self._cRandAttrIdx1,self._cRandAttrVal1,self._cRandAttrIdx2,self._cRandAttrVal2,self._cRandAttrIdx3,self._cRandAttrVal3,self._cRandAttrIdx4,self._cRandAttrVal4,self._cRandAttrIdx5,self._cRandAttrVal5,self._cRandSkillIdx1,self._cRandSkillLv1,self._cRandSkillIdx2,self._cRandSkillLv2,self._cRandSkillIdx3,self._cRandSkillLv3)
		end
		
		--print(sql)
		
		--执行sql
		local err = xlDb_Execute(sql)
		--print(err)
		if err == 0 then
			--更新数据
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
	
	--基本信息转化（包含品质和随机属性）
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
	
	--基本信息转化2（包含品质和随机属性）
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