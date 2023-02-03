--自动匹配管理类
local RedEquipMgr = class("RedEquipMgr")
	
	RedEquipMgr.MERGE_BASE_VALUE = 27	--红装合成基础价值
	RedEquipMgr.MERGE_SUCCESS_VALUE = 54	--红装合成百分百成功总价值
	
	RedEquipMgr.MERGE_ORANGE_SHOPITEMID = 338	--橙装合成对应的商品id
	
	RedEquipMgr.MERGE_SHOPITEMID = 340	--红装合成对应的商品id

	RedEquipMgr.DESCOMPOS_SHOPITEMID = 507	--红装出售对应的商品id

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
				local quality = tonumber(tTemp[n][7]) or 0 --品质
				local randIdx1 = tonumber(tTemp[n][8]) or 0 --随机属性索引1
				local randVal1 = tonumber(tTemp[n][9]) or 0 --随机属性值1
				local randIdx2 = tonumber(tTemp[n][10]) or 0 --随机属性索引2
				local randVal2 = tonumber(tTemp[n][11]) or 0 --随机属性值2
				local randIdx3 = tonumber(tTemp[n][12]) or 0 --随机属性索引3
				local randVal3 = tonumber(tTemp[n][13]) or 0 --随机属性值3
				local randIdx4 = tonumber(tTemp[n][14]) or 0 --随机属性索引4
				local randVal4 = tonumber(tTemp[n][15]) or 0 --随机属性值4
				local randIdx5 = tonumber(tTemp[n][16]) or 0 --随机属性索引5
				local randVal5 = tonumber(tTemp[n][17]) or 0 --随机属性值5
				local randSkillIdx1 = tonumber(tTemp[n][18]) or 0 --随机技能索引1
				local randSkillLv1 = tonumber(tTemp[n][19]) or 0 --随机技能等级1
				local randSkillIdx2 = tonumber(tTemp[n][20]) or 0 --随机技能索引2
				local randSkillLv2 = tonumber(tTemp[n][21]) or 0 --随机技能等级2
				local randSkillIdx3 = tonumber(tTemp[n][22]) or 0 --随机技能索引3
				local randSkillLv3 = tonumber(tTemp[n][23]) or 0 --随机技能等级3
				
				local equip = hClass.RedEquip:create():Init(dbid,typeid,slotnum,quality,strattr,xilianCount,cUnique,randIdx1,randVal1,randIdx2,randVal2,randIdx3,randVal3,randIdx4,randVal4,randIdx5,randVal5,randSkillIdx1,randSkillLv1,randSkillIdx2,randSkillLv2,randSkillIdx3,randSkillLv3)
				
				--更新内存
				self._edic[dbid] = equip
			end
		end
	end
	
	--获取玩家单件装备信息
	function RedEquipMgr:_DBGetRedEquipByDBID(itemdbid)
		
		local uid = self._uid
		local rid = self._rid
		
		--优先读取内存值
		local equip = self._edic[itemdbid]
		if (equip == nil) then
			local sql = string.format("SELECT `id`,`itypeid`,`slotNum`,`itemAttr`,`xilian_count`,`cUnique`, `quality`,`randIdx1`,`randVal1`,`randIdx2`,`randVal2`,`randIdx3`,`randVal3`,`randIdx4`,`randVal4`,`randIdx5`,`randVal5`,`randSkillIdx1`,`randSkillLv1`,`randSkillIdx2`,`randSkillLv2`,`randSkillIdx3`,`randSkillLv3` FROM t_user_redequip where `id`=%d AND `uid`=%d AND `rid`=%d AND deleteflag=0",itemdbid,uid,rid)
			local err, dbid, typeid, slotnum, strattr, xilian_count,cUnique,quality,randIdx1,randVal1,randIdx2,randVal2,randIdx3,randVal3,randIdx4,randVal4,randIdx5,randVal5,randSkillIdx1,randSkillLv1,randSkillIdx2,randSkillLv2,randSkillIdx3,randSkillLv3 = xlDb_Query(sql)
			--print("sql:",err,sql)
			if err == 0 then
				equip = hClass.RedEquip:create():Init(dbid,typeid,slotnum,quality,strattr,xilian_count,cUnique,randIdx1,randVal1,randIdx2,randVal2,randIdx3,randVal3,randIdx4,randVal4,randIdx5,randVal5,randSkillIdx1,randSkillLv1,randSkillIdx2,randSkillLv2,randSkillIdx3,randSkillLv3)
				--更新内存
				self._edic[dbid] = equip
			end
			--print("_DBGetRedEquipByDBID, load sql:", uid, rid, itemdbid)
		end
		
		return equip
	end
	
	--获取玩家多件装备信息
	function RedEquipMgr:_DBGetRedEquipsByDBIDList(itemDbidList)
		
		local uid = self._uid
		local rid = self._rid
		
		local equipDic = {}
		
		local strIds = ""
		
		--优先读取内存值
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
					local quality = tonumber(tTemp[n][7]) or 0 --品质
					local randIdx1 = tonumber(tTemp[n][8]) or 0 --随机属性索引1
					local randVal1 = tonumber(tTemp[n][9]) or 0 --随机属性值1
					local randIdx2 = tonumber(tTemp[n][10]) or 0 --随机属性索引2
					local randVal2 = tonumber(tTemp[n][11]) or 0 --随机属性值2
					local randIdx3 = tonumber(tTemp[n][12]) or 0 --随机属性索引3
					local randVal3 = tonumber(tTemp[n][13]) or 0 --随机属性值3
					local randIdx4 = tonumber(tTemp[n][14]) or 0 --随机属性索引4
					local randVal4 = tonumber(tTemp[n][15]) or 0 --随机属性值4
					local randIdx5 = tonumber(tTemp[n][16]) or 0 --随机属性索引5
					local randVal5 = tonumber(tTemp[n][17]) or 0 --随机属性值5
					local randSkillIdx1 = tonumber(tTemp[n][18]) or 0 --随机技能索引1
					local randSkillLv1 = tonumber(tTemp[n][19]) or 0 --随机技能等级1
					local randSkillIdx2 = tonumber(tTemp[n][20]) or 0 --随机技能索引2
					local randSkillLv2 = tonumber(tTemp[n][21]) or 0 --随机技能等级2
					local randSkillIdx3 = tonumber(tTemp[n][22]) or 0 --随机技能索引3
					local randSkillLv3 = tonumber(tTemp[n][23]) or 0 --随机技能等级3
					
					local equip = hClass.RedEquip:create():Init(dbid,typeid,slotnum,quality,strattr,xilianCount,cUnique,randIdx1,randVal1,randIdx2,randVal2,randIdx3,randVal3,randIdx4,randVal4,randIdx5,randVal5,randSkillIdx1,randSkillLv1,randSkillIdx2,randSkillLv2,randSkillIdx3,randSkillLv3)
					
					--更新内存
					if equip then
						self._edic[dbid] = equip
					end
				end
			end
			--print("_DBGetRedEquipsByDBIDList load sql:", uid, rid, strIds)
		end
		
		return equipDic
	end
	
	--生成新红装数据
	function RedEquipMgr:_NewEquip(typeid,slotnum,quality,cRedequipCrystal,strHint, nHintType)
		local uid = self._uid
		local rid = self._rid
		
		local ret = false
		local tabI = hVar.tab_item[typeid]
		local slotnum = slotnum or -1
		if slotnum > 0 then
			slotnum = math.min(slotnum,4)
		else
			--非红装，孔数为0
			--local tabI = hVar.tab_item[typeid]
			if tabI then
				local itemLv = tabI.itemLv or 0
				
				--随机孔数池子
				local tPool = hVar.ITEM_CHEST_SLOT_PROB[itemLv] --神器锦囊池子
				if cRedequipCrystal then
					tPool = hVar.ITEM_DEBRIS_EXCHANGE_SLOT_PROB --神器晶石池子
				end
				
				
				--输出池子
				--for i = 1, #tPool, 1 do
				--	print(tPool[i].value, tPool[i].reward)
				--end
				
				
				--随机孔数60% 2孔, 35% 3孔, 5% 4孔
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
		
		--已经随出的属性
		local excludeAttr = {}
		--遍历每一个孔，随机属性
		for i = 1, slotnum do
			--随机属性品质
			--local attrR = math.random(1,5) --随机属性的品质
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
		
		--随机品质
		if (quality <= 0) then
			--随机品质池子
			local tPool = hVar.ITEM_QUALITY_PROB --神器锦囊池子
			--local tabI = hVar.tab_item[typeid] or {}
			local tabI_quality = tabI.maxQuality or 1
			local maxQuality = math.min(tPool.maxQuality, tabI_quality)
			
			--随机一个奖励
			--计算总几率
			--生成随机数
			local totalValue = 0
			for i = 1, maxQuality, 1 do
				totalValue = totalValue + tPool[i].value
			end
			--local rand = math.random(1, tPool.totalValue)
			local rand = math.random(1, totalValue)
			--计算结果区间
			local pivot = rand
			for i = 1, #tPool, 1 do
				if (pivot <= tPool[i].value) then --找到了
					quality = i
					break
				else
					pivot = pivot - tPool[i].value
				end
			end
		end
		
		--print("DBAddEquip:",uid,rid,typeid, slotnum, quality, strattr)
		
		--插入记录
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
		
		--生成随机属性
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
				--先随机n个属性
				local tAttrDic = {}
				for j = 1, randAttrNum, 1 do
					while true do
						local ranIdx = math.random(1, #randreward)
						
						--未随到
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
				
				--转数组表
				local tAttrList = {}
				for k = 1, 5, 1 do
					if tAttrDic[k] then
						tAttrList[#tAttrList+1] = {k, tAttrDic[k],}
					end
				end
				--排序
				table.sort(tAttrList, function(ta, tb)
					if (ta[1] == tb[1]) then
						return false
					else
						return (ta[1] < tb[1])
					end
				end)
				
				--随机属性1
				if (randAttrNum >= 1) then
					randIdx1 = tAttrList[1][1]
					randVal1 = tAttrList[1][2]
				end
				--随机属性2
				if (randAttrNum >= 2) then
					randIdx2 = tAttrList[2][1]
					randVal2 = tAttrList[2][2]
				end
				--随机属性3
				if (randAttrNum >= 3) then
					randIdx3 = tAttrList[3][1]
					randVal3 = tAttrList[3][2]
				end
				--随机属性4
				if (randAttrNum >= 4) then
					randIdx4 = tAttrList[4][1]
					randVal4 = tAttrList[4][2]
				end
				--随机属性5
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
		
		--更新内存
		--self._edic[dbid] = equip
		
		--[[
		--geyachao: todo 战车暂时不处理
		--4孔神器日志
		if (slotnum == 4) then
		--if (slotnum > 0) then
			local sendnum = 0
			local flag = 99
			
			--目前需要发世界红包的神器来源途径
			if (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_PURCHASE388) then --首充388元奖励
				sendnum = 10
				flag = 0
			elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_PURCHASE198) then --首充198元奖励
				sendnum = 10
				flag = 0
			elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDCHEST) then --神器锦囊抽到
				sendnum = 6
				flag = 0
			elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDDEBRIS) then --神器晶石兑换
				sendnum = 6
				flag = 0
			elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_CANGBAOTU_HIGH) then --高级藏宝图抽到
				sendnum = 6
				flag = 0
			elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_GROUPCHEST) then --军团宝箱抽到
				sendnum = 6
				flag = 0
			elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAILDRAWCARD) then --邮件n选1领取
				sendnum = 10
				flag = 0
			elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MERGE) then --合成
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
		--geyachao: todo 战车暂时不处理
		--统计宝物4孔坐骑次数
		if (slotnum == 4) then
			local treasure = hClass.Treasure:create():Init(uid, rid)
			treasure:IncreaseMountCount(equip:GetCUnique(), typeid, slotnum, strattr)
		end
		]]
		
		return equip
	end
	
	--获得道具洗练需要的积分（芯片）
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
		--[[
		--geyachao: 战车不用转化老装备
		for i = 1, cOldRedEquipNum do
			local old = oldList[i]
			if old then
				local typeId = tonumber(old.typeId) or 0
				local uniqueId = tonumber(old.uniqueId) or 0
				local slotNum = tonumber(old.slotNum) or 0
				local strAttr = old.strAttr
				
				--老版 神鹰令、月神护甲
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
							--更新内存
							self._edic[equip:GetDBID()] = equip
						end
					end
				end
			end
		end
		]]
	end
	
	--[[
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
	]]
	
	--DB新增道具
	function RedEquipMgr:DBAddEquip(typeid,slotnum,quality,cRedequipCrystal,strHint, nHintType)
		
		local uid = self._uid
		local rid = self._rid
		
		local equip = self:_NewEquip(typeid,slotnum,quality,cRedequipCrystal,strHint, nHintType)
		
		--print("RedEquipMgr:DBAddEquip equip=", typeid, equip)
		if equip then
			local saveOk = equip:DBSave(uid,rid)
			if saveOk then
				--更新内存
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
		--		local equip = hClass.RedEquip:create():Init(dbid,typeid,slotnum,quality,strattr)
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
				
				--消耗积分（芯片）
				local costScore = self:_GetItemXiLianScore(equip, itemLv)
				local rmb, sendItemId = self:_GetItemLockInfo(lockNum)
				
				--print("rmb:",lockNum,rmb,sendItemId,costScore)
				
				--芯片是否足够
				local debrisNum = 0
				local sql = string.format("SELECT `equip_crystal` FROM `t_user` where  `uid`= %d", uid)
				local err, equip_crystal = xlDb_Query(sql)
				--print("sql:",err,sql)
				if err == 0 then
					debrisNum = equip_crystal
				end
				
				if (debrisNum >= costScore) then
					--道具洗练
					local xilianOk = equip:XiLian(lockIdDic)
					
					if xilianOk then
						local newInfo = equip:InfoToCmd()
						--判断游戏币是否足够
						local bSuccess, orderId = hGlobal.userCoinMgr:DBUserPurchase(uid,rid,sendItemId,1,rmb,costScore,oldInfo .. ";" .. newInfo)
						if bSuccess then
							equip:AddXiLianCount()
							local saveOk = equip:DBSave(uid,rid)
							if saveOk then
								--更新内存
								self._edic[equip:GetDBID()] = equip
								
								--[[
								--geyachao: todo 战车暂时不处理
								--统计宝物锁孔洗炼次数
								if (lockNum > 0) then
									local treasure = hClass.Treasure:create():Init(uid, rid)
									treasure:IncreaseXiLianCount(orderId, itemDbid, itemId, lockNum, lockIdDic)
								end
								]]
								
								--[[
								--geyachao: todo 战车暂时不处理
								--更新每日任务（新）
								--百炼成钢（红装）
								local taskType = hVar.TASK_TYPE.TASK_EQUIP_XILIAN --百炼成钢（红装）
								local addCount = 1
								local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(uid, rid)
								taskMgr:AddTaskFinishCount(taskType, addCount)
								]]
								
								--更新芯片
								--更新
								local sUpdate = string.format("UPDATE `t_user` SET `equip_crystal` = `equip_crystal` - %d where `uid` = %d", costScore, uid)
								--print("sUpdate1:",sUpdate)
								xlDb_Execute(sUpdate)
								
								--保存成功
								ret = "1;" .. ret
								ret = ret .. tostring(0) .. ":" .. tostring(sendItemId) .. ":" .. tostring(1) .. ":".. tostring(costScore) .. ":" .. tostring(rmb) .. ":" .. tostring(1) .. ":" .. tostring(1) .. ";"
								ret = ret .. newInfo

								bRet = true
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
					ret = "-6;" .. ret	--芯片不足
				end
			else
				ret = "-2;" .. ret	--装备类型不存在
			end
		else
			ret = "-1;" .. ret	--装备不存在
		end
		
		return ret, bRet
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
				--[[
				--输出池子
				for i = 1, #hVar.ITEM_MERGE_SLOT_PROB, 1 do
					print(hVar.ITEM_MERGE_SLOT_PROB[i].value, hVar.ITEM_MERGE_SLOT_PROB[i].reward)
				end
				]]
				slotnum = self:_RollDrop(hVar.ITEM_MERGE_SLOT_PROB) --祭坛池子
			end
			local newEquip = self:_NewEquip(newInfo[2],slotnum,0,nil,hVar.tab_string["__TEXT_REWARDTYPE_MERGE"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MERGE)
			
			local purchaseInfo = tostring(okFlag) .. ";"
			if okFlag == 1 then
				purchaseInfo = purchaseInfo .. oldInfo .. newEquip:InfoToCmd()
			else
				purchaseInfo = purchaseInfo .. oldInfo
			end
			
			--判断游戏币是否足够
			local rmbCost = math.ceil(shopItem:GetRmbCost() * (math.max(materialNum,1)))
			local bSuccess, orderId = hGlobal.userCoinMgr:DBUserPurchase(uid,rid,shopItem:GetItemID(),1,rmbCost,0,purchaseInfo)
			if bSuccess then
				for i = 1, materialNum do
					local material = equipDic[materialDbidList[i]]
					material:DBSave(uid,rid)
					
					--更新内存
					self._edic[material:GetDBID()] = nil
				end
				ret = "1;" .. ret .. tostring(okFlag) ..";"
				if okFlag == 1 then
					mergeItem:DBSave(uid,rid)
					newEquip:DBSave(uid,rid)
					
					--更新内存
					self._edic[mergeItem:GetDBID()] = nil
					
					--更新内存
					self._edic[newEquip:GetDBID()] = newEquip
					
					--统计宝物合成3孔红装次数次数
					if (slotnum >= 3) then
						local treasure = hClass.Treasure:create():Init(uid, rid)
						treasure:IncreaseMerge3SlotCount(newEquip:GetCUnique(), newEquip:GetTypeID(), slotnum, orderId)
					end
					
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

	--分解红装
	function RedEquipMgr:DBDescomposRedEquip(materialNum, materialDbidList)
		local ret =  tostring(materialNum) .. ";"
		
		
		local uid = self._uid
		local rid = self._rid

		--将主装备及材料装备的dbid整理到列表中
		local itemDBidList = {}
		for i = 1, materialNum do
			itemDBidList[#itemDBidList + 1] = materialDbidList[i]
			ret = ret .. materialDbidList[i] .. ";"
		end

		local equipDic = self:_DBGetRedEquipsByDBIDList(itemDBidList)
		local oldInfo = ""
		--判定分解装备是否存在
		for i = 1, #itemDBidList do
			local equip = equipDic[itemDBidList[i]]
			if not equip then
				ret = "-1;"..ret
				return ret
			else
				oldInfo = oldInfo .. equip:InfoToCmd() .. ";"
			end
		end

		--定价价钱
		local shopItem = hClass.ShopItem:create():Init(RedEquipMgr.DESCOMPOS_SHOPITEMID)
		local purchaseInfo = "1;".. oldInfo

		--判断游戏币是否足够
		local rmbCost = 0
		local bSuccess, orderId = hGlobal.userCoinMgr:DBUserPurchase(uid,rid,shopItem:GetItemID(),1,rmbCost,0,purchaseInfo)
		if bSuccess then
			
			local crystalSum = 0
			
			for i = 1, materialNum do
				local material = equipDic[materialDbidList[i]]
				--需分解的装备设置为删除
				material:SetDelete()
				material:DBSave(uid,rid)
				
				--更新内存
				self._edic[material:GetDBID()] = nil
				
				--获得神器晶石
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
	
	--红装卷轴兑换红装
	function RedEquipMgr:DBScroll2RedEquip(idx)
		local cmd = ""
		local result = 0
		local prizeId = 0 --邮箱奖励id
		
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
						--奖励id
						local err1, pid = xlDb_Query("select last_insert_id()")
						if (err1 == 0) then
							prizeId = pid
						end
						
						--操作成功
						result = 1
						
						--领取邮箱奖励
						local fromIdx = 2
						cmd = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_REDSCROLL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDSCROLL)
					end
					
				end
			end
		end
		
		local sL2CCmd = result .. ";" .. cmd
		return sL2CCmd
	end
	
	--（包含品质和随机属性）
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