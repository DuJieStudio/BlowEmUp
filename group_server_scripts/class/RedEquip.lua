--红装类
local RedEquip = class("RedEquip")
    
	--构造函数
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
	--初始化函数
	function RedEquip:Init(dbid,typeid,slotnum,strattr,xilianCount,cUnique)
		self._dbid = dbid
		self._typeid = typeid
		self._slotnum = slotnum or 0
		self._xilianCount = xilianCount or 0
		self._deleteFlag = 0
		self._cUnique = cUnique or 0
		if self._slotnum > 0 and strattr then
			--string类型的数据转成字符串类型
			self._attr = self:_S2TAttr(strattr)
		else
			self._attr = {}
		end
		return self
	end
	--析构函数
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
	--获取红装dbid
	function RedEquip:_SetDBID(dbid)
		self._dbid = dbid
	end

	--产生道具洗练属性品质
	function RedEquip:_MakeItemXiLianAttrLv(itemLv)
		--返回属性品质
		local ret
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
			local rWeight = math.random(1, sumWeight)
			
			--遍历权重范围临时值,看随机权值落在哪个区间
			for attr, weightInfo in pairs(tmpAttrInfo) do
				if rWeight > weightInfo.min and rWeight <= weightInfo.max then
					ret = attr
					break
				end
			end
		end

		return ret
	end

	--获取装备随机属性
	function RedEquip:_GetItemRandomAttr(attrR, excludeAttr)
		local baseAttrSet = hVar.ITEM_ATTR_QUALITY_DEF[attrR]

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
			local itemLv = hVar.ITEM_QUALITY.ORANGE			--主道具道具品质
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
				sql = string.format("UPDATE t_user_redequip SET `slotNum`=%d,`itemAttr`='%s',`xilian_count`=%d, `cUnique`=%d WHERE `id`=%d AND `uid`=%d AND `rid`=%d",slotnum,strattr,xiliancount,cUnique,dbid,uid,rid)
			end
		else --新建装备
			sql = string.format("INSERT INTO t_user_redequip (`uid`,`rid`,`itypeid`,`slotNum`,`itemAttr`,`cUnique`) VALUES (%d,%d,%d,%d,'%s',%d)", uid,rid,typeid,slotnum,strattr,cUnique)
		end

		--执行sql
		local err = xlDb_Execute(sql)
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
	
	--基本信息转化
	function RedEquip:InfoToCmd()
		local cmd = tostring(self:GetDBID()) .. ":" .. tostring(self:GetTypeID()) .. ":" .. tostring(self:GetSlotNum()) .. ":" .. tostring(self:GetStrAttr()) .. ":" .. tostring(self:GetCUnique())
		return cmd
	end

	--基本信息转化2
	function RedEquip:InfoToCmdEx()
		local cmd = tostring(self:GetDBID()) .. "|" .. tostring(self:GetTypeID()) .. "|" .. tostring(self:GetSlotNum()) .. "|" .. tostring(self:GetStrAttr()) .. "|" .. tostring(self:GetCUnique())
		return cmd
	end

return RedEquip