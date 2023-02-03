--自动匹配管理类
local RedEquipMgr = class("RedEquipMgr")
	
	RedEquipMgr.MERGE_BASE_VALUE = 27	--红装合成基础价值
	RedEquipMgr.MERGE_SUCCESS_VALUE = 54	--红装合成百分百成功总价值
	
	RedEquipMgr.MERGE_ORANGE_SHOPITEMID = 338	--橙装合成对应的商品id
	
	RedEquipMgr.MERGE_SHOPITEMID = 340	--红装合成对应的商品id
	RedEquipMgr.REDEQUIP_SCROLL_ITEM = 9918	--红装卷轴id
	RedEquipMgr.SCROLL_TO_EQUIP_SLOTNUM = 4	--红装卷轴兑换红装的孔数
	
	--老红装转化为新红装
	RedEquipMgr.OLD_TYPEID_CHANGE = 
	{
		[11007] = 12405,
		[11082] = 12205,
	}

	--构造函数
	function RedEquipMgr:ctor(flag)
		
		self._uid = -1			--玩家id
		self._rid = -1			--角色id
		self._edic = -1			--红装存储
		self._autoGetDB = flag		--初始化时是否自动从db初始化玩家的红装数据

		--获得道具
		--购买
		--洗练
		--合成
		
		--其他
		return self
	end
	--初始化函数
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
	--析构函数
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
	--获取玩家所有装备信息
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
	
	--获取玩家单件装备信息
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
	
	--获取玩家多件装备信息
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
			--随机孔数45% 2孔,40% 3孔,15% 4孔
			local r = math.random(1, 100)
			if r > 0 and r <= 45 then
				slotnum = 2
			elseif r > 45 and r <= 85 then
				slotnum = 3
			elseif r > 85 and r <= 100 then
				slotnum = 4
			end
			]]
			
			--随机孔数60% 2孔, 35% 3孔, 5% 4孔
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
		
		--已经随出的属性
		local excludeAttr = {}
		--遍历每一个孔，随机属性
		for i = 1, slotnum do
			--随机属性品质
			local attrR = math.random(1,5) --随机属性的品质
			local attr = self:_GetItemRandomAttr(attrR, excludeAttr)
			if attr then
				strattr = strattr .. attr
				if i < slotnum then
					strattr = strattr .. "|"
				end
			end
		end
		
		--print("DBAddEquip:",uid,rid,typeid, slotnum, strattr)

		--插入记录
		local equip = hClass.RedEquip:create():Init(0,typeid,slotnum,strattr)

		return equip
	end

	--获得道具洗练需要的积分
	function RedEquipMgr:_GetItemXiLianScore(equip, qualityLv)
		local ret = 0
		
		--[[
		--获取当前道具品质等级对应的属性权值信息
		if hVar.ITEM_XILIAN_INFO[qualityLv] and hVar.ITEM_XILIAN_INFO[qualityLv].cost then
			ret = hVar.ITEM_XILIAN_INFO[qualityLv].cost
		end
		]]
		--获取神器当前道具品质等级对应的属性权值信息
		if hVar.ITEM_XILIAN_INFO[qualityLv] and hVar.ITEM_XILIAN_INFO[qualityLv].cost then
			local cost = hVar.ITEM_XILIAN_INFO[qualityLv].cost
			local slotNum = equip:GetSlotNum()
			ret = cost[slotNum]
		end
		
		return ret
	end
	
	--获得洗练道具锁孔需要的金币和对应的道具id
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
	
	--roll点，根据权值落在哪个区间，返回掉落
	function RedEquipMgr:_RollDrop(pool)
		local ret 
		if not pool then
			return ret
		end

		local value = math.random(1, pool.totalValue)
		local initialValue = 0
		--遍历，看权重落在哪个区段
		for i = 1, #pool do
			if value > initialValue and value <= initialValue + pool[i].value then
				ret = pool[i].reward
				break
			end
			initialValue = initialValue + pool[i].value
		end
		return ret
	end
	
	--获取装备随机属性(属性品质，已经有的属性)
	function RedEquipMgr:_GetItemRandomAttr(attrR, excludeAttr)
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
	--获取所有红装(卷轴可兑换)信息
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

	--将老的红装转化为新的
	function RedEquipMgr:DBChangeOld(uid,rid,cOldRedEquipNum,oldList)
		--如果客户端传了需要同步的数据,则检测是否已经同步过相关的数据了,todo
		
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

	--手动从db获取所有数据
	function RedEquipMgr:DBGetRedEquip(uid,rid)
		
		--先删除之前的存储数据
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

	--DB新增道具
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

		----插入记录
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
	
	--洗练
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

				--消耗积分
				local costScore = self:_GetItemXiLianScore(equip, itemLv)
				local rmb, sendItemId = self:_GetItemLockInfo(lockNum)

				--print("rmb:",lockNum,rmb,sendItemId,costScore)
				
				--道具洗练
				local xilianOk = equip:XiLian(lockIdDic)
				
				if xilianOk then
					local newInfo = equip:InfoToCmd()
					--判断游戏币是否足够
					if hGlobal.userCoinMgr:DBUserPurchase(uid,rid,sendItemId,1,rmb,costScore,oldInfo .. ";" .. newInfo) then
						equip:AddXiLianCount()
						local saveOk = equip:DBSave(uid,rid)
						if saveOk then
							--保存成功
							ret = "1;" .. ret
							ret = ret .. tostring(0) .. ":" .. tostring(sendItemId) .. ":" .. tostring(1) .. ":".. tostring(costScore) .. ":" .. tostring(rmb) .. ":" .. tostring(1) .. ":" .. tostring(1) .. ";"
							ret = ret .. newInfo
						else
							--保存失败
							hGlobal.userCoinMgr:DBAddGamecoin(uid,rmb)
							ret = "-4;" .. ret	--更新装备信息失败
						end
					else
						ret = "-3;" .. ret	--游戏币不足
					end
				else
					ret = "-5;" .. ret	--属性洗练失败

				end
			else
				ret = "-2;" .. ret	--装备类型不存在
			end
		else
			ret = "-1;" .. ret	--装备不存在
		end

		return ret
	end

	--合成
	function RedEquipMgr:DBMerge(mainDbid, materialNum, materialDbidList)

		local ret =  tostring(mainDbid) .. ";" .. materialNum .. ";"


		local uid = self._uid
		local rid = self._rid

		--todo
		--定价价钱
		local shopItem = hClass.ShopItem:create():Init(RedEquipMgr.MERGE_SHOPITEMID)
		
		--将主装备及材料装备的dbid整理到列表中
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
		--判定主装备和材料装备是否存在
		for i = 1, #itemDBidList do
			local equip = equipDic[itemDBidList[i]]
			if not equip then
				ret = "-1;"..ret
				return ret
			else
				oldInfo = oldInfo .. equip:InfoToCmd() .. ";"
			end
		end
		
		--获取合成主道具
		local mergeItem = equipDic[mainDbid]
			
		--基础概率
		local baseRatio = 0
		
		local mergeItemId = mergeItem:GetTypeID()		--主道具id
		local mergeItemTabI = hVar.tab_item[mergeItemId]	--主道具tab表
		
		--如果主道具tab表存在，主道具是装备
		if mergeItemTabI then

			itemTypeIdList[mergeItemId] = true
			
			--计算主道具tab基础倍率
			local mergeItemItemLv = mergeItemTabI.itemLv or hVar.ITEM_QUALITY.WHITE			--主道具道具品质
			--当前品质的主道具是否可以参与合成
			baseRatio = math.min(baseRatio + RedEquipMgr.MERGE_BASE_VALUE,100)			--主道具概率权值
			
			--获取材料道具
			for i = 1, materialNum do
				local material = equipDic[materialDbidList[i]]
				if material and type(material) == "table" then
					
					local materialId = material:GetTypeID()			--材料道具id
					local materialTabI = hVar.tab_item[materialId]		--材料道具tab表
					--如果材料道具tab表存在，材料道具是装备
					if materialTabI then

						itemTypeIdList[materialId] = true

						baseRatio = math.min(baseRatio + RedEquipMgr.MERGE_BASE_VALUE,100)				--材料道具概率权值
					end

					--材料装备设置为删除
					material:SetDelete()
				end
			end
			
			--
			local rRatio = math.random(1, RedEquipMgr.MERGE_SUCCESS_VALUE)
			local okFlag = 0
			--成功
			if rRatio <= baseRatio then
				okFlag = 1
				--主道具是设置为删除
				mergeItem:SetDelete()
			end

			--从池中筛选掉所有材料
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

			--产生新道具
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
			
			--判断游戏币是否足够
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
				ret = "-3;"..ret	--合成道具失败:游戏币不足
			end
		else
			ret = "-2;"..ret	--合成道具失败:主道具类型不存在
		end

		return ret
	end

	--红装卷轴兑换红装
	function RedEquipMgr:DBScroll2RedEquip(idx)
		local cmd = ""
		local result = 0

		local uid = self._uid
		local rid = self._rid

		if hVar.SCROLL_TO_EQUIP_POOL and type(hVar.SCROLL_TO_EQUIP_POOL) == "table" then
			if idx and hVar.SCROLL_TO_EQUIP_POOL[idx] then
				local itemId = hVar.SCROLL_TO_EQUIP_POOL[idx]
				--判断游戏币是否足够
				if hGlobal.userCoinMgr:DBUserCostScroll(uid,rid,RedEquipMgr.REDEQUIP_SCROLL_ITEM,1,1,0,itemId..";") then
					local mykey = ""
					mykey = mykey .. hVar.tab_string["__TEXT_REWARD_REDEQUIP"] .. ";" .. "10:" .. itemId .. ":" .. RedEquipMgr.SCROLL_TO_EQUIP_SLOTNUM .. ":0;"

					local insertSql = string.format("INSERT INTO prize (uid,`type`, mykey) VALUES (%d,20008,'%s')",uid,mykey)
				
					--执行sql
					local err = xlDb_Execute(insertSql)
					if err == 0 then
						--插入邮箱
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