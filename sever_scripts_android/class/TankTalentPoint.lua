--战车天赋技能点类
local TankTalentPoint = class("TankTalentPoint")
	
	--加经验值的商店id
	TankTalentPoint.ADDEXP_SHOPITEM_ID = 435
	
	--天赋点分配的商店id
	TankTalentPoint.ADDTALENT_SHOPITEM_ID = 436
	
	--天赋点重置的商店id
	TankTalentPoint.RESTORETALENT_SHOPITEM_ID = 448
	
	--构造函数
	function TankTalentPoint:ctor()
		self._uid = -1
		self._rid = -1
		
		return self
	end
	
	--初始化
	function TankTalentPoint:Init(uid, rid)
		self._uid = uid
		self._rid = rid
		
		return self
	end
	
	--查询玩家战车天赋点信息
	function TankTalentPoint:QueryInfo()
		local strCmd = ""
		
		--读取战车天赋点数据
		local talentAdd = 0 --额外获得的天赋点数
		local tLevelInfo = {}
		local sql = string.format("SELECT `talentAdd`, `levelInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, talent, levelInfo = xlDb_Query(sql)
		--print("sql:",sql,e,levelInfo, type(levelInfo))
		if (e == 0) then
			if (type(levelInfo) == "string") and (#levelInfo > 0) then
				levelInfo = "{" .. levelInfo .. "}"
				local tmp = "local prize = " .. levelInfo .. " return prize"
				--战车天赋点表
				tLevelInfo = assert(loadstring(tmp))()
				
				--战车额外的天赋点数
				talentAdd = talent
			end
		end
		
		local nLevelInfoNum = #tLevelInfo
		local sLevelInfo = ""
		for i = 1, #tLevelInfo, 1 do
			local tInfo = tLevelInfo[i]
			local id = tInfo.id or 0 --战车id
			local level = tInfo.level or 1 --等级
			local star = tInfo.star or 1 --星级
			local exp = tInfo.exp or 0 --经验值
			local talentPointUsed = tInfo.talentPointUsed or 0 --已使用的天赋点数
			local talentPointSum = hVar.TANK_LEVELUP_EXP[level].talentNum + talentAdd --总天赋点数
			local talentPoint = talentPointSum - talentPointUsed --剩余天赋点数
			local talentPointAdd = tInfo.talentPointAdd or {} --天赋加点表
			
			local strtalentadd = ""
			for i = 1, #hVar.talent_tree, 1 do
				local talentId = hVar.talent_tree[i] --天赋id
				local attrPointAddValue = talentPointAdd[talentId] or 0 --天赋等级
				strtalentadd = strtalentadd .. tostring(talentId) .. "_" .. tostring(attrPointAddValue) .. ":"
			end
			sLevelInfo = sLevelInfo .. tostring(id) .. ":" .. tostring(level) .. ":" .. tostring(star) .. ":" .. tostring(exp) .. ":"
					.. tostring(talentPointSum).. ":" .. tostring(talentPointUsed) .. ":" .. tostring(talentPoint) .. ":"
					.. tostring(#hVar.talent_tree) .. ":" .. strtalentadd .. ";"
		end
		
		--未解锁的战车也下发数据
		for t = 1, #hVar.tank_unit, 1 do
			local tankId = hVar.tank_unit[t]
			local bExisted = false
			for i = 1, #tLevelInfo, 1 do
				local tInfo_i = tLevelInfo[i]
				local id = tInfo_i.id or 0 --战车id
				
				if (id == tankId) then --找到了
					bExisted = true
					break
				end
			end
			
			--未解锁的战车
			if (not bExisted) then
				local id = tankId --战车id
				local level = 1 --等级
				local star = 1 --星级
				local exp = 0 --经验值
				local talentPointUsed = 0 --已使用的天赋点数
				local talentPointSum = hVar.TANK_LEVELUP_EXP[level].talentNum + talentAdd --总天赋点数
				local talentPoint = talentPointSum - talentPointUsed --剩余天赋点数
				--local talentPointAdd = {} --天赋加点表
				
				local strtalentadd = ""
				for i = 1, #hVar.talent_tree, 1 do
					local talentId = hVar.talent_tree[i] --天赋id
					local attrPointAddValue = 0 --天赋等级
					strtalentadd = strtalentadd .. tostring(talentId) .. "_" .. tostring(attrPointAddValue) .. ":"
				end
				sLevelInfo = sLevelInfo .. tostring(id) .. ":" .. tostring(level) .. ":" .. tostring(star) .. ":" .. tostring(exp) .. ":"
						.. tostring(talentPointSum).. ":" .. tostring(talentPointUsed) .. ":" .. tostring(talentPoint) .. ":"
						.. tostring(#hVar.talent_tree) .. ":" .. strtalentadd .. ";"
				
				--总数量加1
				nLevelInfoNum = nLevelInfoNum + 1
			end
		end
		
		strCmd = strCmd .. tostring(nLevelInfoNum) .. ";" .. sLevelInfo
		return strCmd
	end
	
	--战车加经验值
	function TankTalentPoint:AddExp(tankId, expAdd)
		local ret = 0
		local strCmd = ""
		
		--读取战车天赋点数据
		local talentAdd = 0 --额外获得的天赋点数
		local tLevelInfo = {}
		local sql = string.format("SELECT `talentAdd`, `levelInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, talent, levelInfo = xlDb_Query(sql)
		--print("sql:",sql,e,levelInfo, type(levelInfo))
		if (e == 0) then
			if (type(levelInfo) == "string") and (#levelInfo > 0) then
				levelInfo = "{" .. levelInfo .. "}"
				local tmp = "local prize = " .. levelInfo .. " return prize"
				--战车天赋点表
				tLevelInfo = assert(loadstring(tmp))()
				
				--战车额外的天赋点数
				talentAdd = talent
			end
		end
		
		--遍历是否存在该战车天赋点
		local tInfo = {}
		local bExisted = false
		for i = 1, #tLevelInfo, 1 do
			local tInfo_i = tLevelInfo[i]
			local id = tInfo_i.id or 0 --战车id
			
			if (id == tankId) then --找到了
				bExisted = true
				
				tInfo = tInfo_i
				
				break
			end
		end
		
		--不存在的战车天赋点，末尾新增数据
		if (not bExisted) then
			tInfo = {id = tankId,}
			tLevelInfo[#tLevelInfo+1] = tInfo
		end
		
		local level = tInfo.level or 1 --等级
		local star = tInfo.star or 1 --星级
		local exp = tInfo.exp or 0 --经验值
		local talentPointUsed = tInfo.talentPointUsed or 0 --已使用的天赋点数
		local talentPointSum = hVar.TANK_LEVELUP_EXP[level].talentNum + talentAdd --总天赋点数
		local talentPoint = talentPointSum - talentPointUsed --剩余天赋点数
		local talentPointAdd = tInfo.talentPointAdd or {} --天赋加点表
		
		--增加经验
		local expNew = exp + expAdd
		
		--计算新等级
		local levelNew = level
		local maxLv = hVar.TANK_LEVELUP_EXP.maxLv
		for i = levelNew + 1, maxLv, 1 do
			local tExpInfo = hVar.TANK_LEVELUP_EXP[i]
			local minExp = tExpInfo.minExp
			if (expNew >= minExp) then --经验值达到此等级
				levelNew = i
			end
		end
		
		--计算新剩余天赋点数
		local talentPointSumNew = hVar.TANK_LEVELUP_EXP[levelNew].talentNum + talentAdd --新总天赋点数
		local talentPointNew = talentPointSumNew - talentPointUsed
		
		--存储
		tInfo.exp = expNew
		tInfo.level = levelNew
		
		--存档
		local saveData = ""
		--saveData = saveData .. "{"
		for k = 1, #tLevelInfo, 1 do
			local tInfo = tLevelInfo[k]
			saveData = saveData .. serialize(tInfo) .. ",\n"
		end
		--saveData = saveData .. "},\n"
		--print("saveData", saveData)
		
		--更新
		local sUpdate = string.format("UPDATE `t_cha` SET `levelInfo` = '%s' where `id` = %d", saveData, self._rid)
		--print("sUpdate1:",sUpdate)
		xlDb_Execute(sUpdate)
		
		--插入订单
		local shopItemId = TankTalentPoint.ADDEXP_SHOPITEM_ID
		local tabShopItem = hVar.tab_shopitem[shopItemId]
		local itemId = tabShopItem.itemID or 0 --商品道具id
		local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
		
		--订单表
		--新的购买记录插入到order表
		sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,self._uid,self._rid,itemId,1,sItemName,0,0,tostring(expNew)..";"..tostring(expAdd)..";")
		--print("sUpdate2:",sUpdate)
		xlDb_Execute(sUpdate)
		
		ret = 1 --成功
		
		strCmd = strCmd .. tankId .. ";" .. expNew .. ";" .. expAdd .. ";" .. levelNew .. ";" .. talentPointNew .. ";"
		
		strCmd = ret .. ";" .. strCmd
		return strCmd
	end
	
	--战车分配点数
	function TankTalentPoint:AddPoint(tankId, talentId)
		local ret = 0
		local strCmd = ""
		
		--读取战车天赋点数据
		local talentAdd = 0 --额外获得的天赋点数
		local tLevelInfo = {}
		local sql = string.format("SELECT `talentAdd`, `levelInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, talent, levelInfo = xlDb_Query(sql)
		--print("sql:",sql,e,levelInfo, type(levelInfo))
		if (e == 0) then
			if (type(levelInfo) == "string") and (#levelInfo > 0) then
				levelInfo = "{" .. levelInfo .. "}"
				local tmp = "local prize = " .. levelInfo .. " return prize"
				--战车天赋点表
				tLevelInfo = assert(loadstring(tmp))()
				
				--战车额外的天赋点数
				talentAdd = talent
			end
		end
		
		--遍历是否存在该战车天赋点
		local tInfo = {}
		local bExisted = false
		for i = 1, #tLevelInfo, 1 do
			local tInfo_i = tLevelInfo[i]
			local id = tInfo_i.id or 0 --战车id
			
			if (id == tankId) then --找到了
				bExisted = true
				
				tInfo = tInfo_i
				
				break
			end
		end
		
		--不存在的战车天赋点，末尾新增数据
		if (not bExisted) then
			tInfo = {id = tankId,}
			tLevelInfo[#tLevelInfo+1] = tInfo
		end
		
		local level = tInfo.level or 1 --等级
		local star = tInfo.star or 1 --星级
		local exp = tInfo.exp or 0 --经验值
		local talentPointUsed = tInfo.talentPointUsed or 0 --已使用的天赋点数
		local talentPointSum = hVar.TANK_LEVELUP_EXP[level].talentNum + talentAdd --总天赋点数
		local talentPoint = talentPointSum - talentPointUsed --剩余天赋点数
		local talentPointAdd = tInfo.talentPointAdd or {} --天赋加点表
		
		--找到索引值
		local talentIdx = 0
		for i = 1, #hVar.talent_tree, 1 do
			if (hVar.talent_tree[i] == talentId) then --找到了
				talentIdx = i
				break
			end
		end
		
		--检测索引的有效性
		if (talentIdx > 0) then
			--天赋树表
			local tTalent = hVar.tab_chariottalent[talentId]
			local attrPointMaxLv = tTalent.attrPointMaxLv --天赋等级上限
			local attrPointUpgrade = tTalent.attrPointUpgrade
			local requireAttrPoint = attrPointUpgrade.requireAttrPoint  --需要的天赋点数
			local requireScore = attrPointUpgrade.requireScore  --需要的积分
			local talentLvNow = talentPointAdd[talentId] or 0 --天赋点当前等级
			
			--检测天赋技能等级是否还未满
			if (talentLvNow < attrPointMaxLv) then
				--检测剩余天赋点数是否够
				if (talentPoint >= requireAttrPoint) then
					--增加天赋技能等级
					local talentLvNew = talentLvNow + 1
					talentPointAdd[talentId] = talentLvNew
					
					--扣除天赋点数
					local talentPointUsedNew = talentPointUsed + requireAttrPoint
					local talentPointNew = talentPoint - requireAttrPoint
					
					--存储
					tInfo.talentPointUsed = talentPointUsedNew
					tInfo.talentPointAdd = talentPointAdd
					
					--存档
					local saveData = ""
					--saveData = saveData .. "{"
					for k = 1, #tLevelInfo, 1 do
						local tInfo = tLevelInfo[k]
						saveData = saveData .. serialize(tInfo) .. ",\n"
					end
					--saveData = saveData .. "},\n"
					--print("saveData", saveData)
					
					--更新
					local sUpdate = string.format("UPDATE `t_cha` SET `levelInfo` = '%s' where `id` = %d", saveData, self._rid)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
					
					--插入订单
					local shopItemId = TankTalentPoint.ADDTALENT_SHOPITEM_ID
					local tabShopItem = hVar.tab_shopitem[shopItemId]
					local itemId = tabShopItem.itemID or 0 --商品道具id
					local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
					
					--订单表
					--新的购买记录插入到order表
					sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,self._uid,self._rid,itemId,1,sItemName,0,0,tostring(talentIdx)..";"..tostring(requireAttrPoint)..";")
					--print("sUpdate2:",sUpdate)
					xlDb_Execute(sUpdate)
					
					ret = 1 --成功
					
					strCmd = strCmd .. tankId .. ";" .. talentId .. ";" .. requireAttrPoint .. ";" .. requireScore .. ";" .. talentPointNew .. ";" .. talentLvNew .. ";"
				else
					ret = -3 --天赋点数不足
				end
			else
				ret = -2 --天赋技能已满级
			end
		else
			ret = -1 --无效的天赋id
		end
		
		strCmd = ret .. ";" .. strCmd
		return strCmd
	end
	
	--战车天赋点数重置
	function TankTalentPoint:Restore(tankId)
		local ret = 0
		local strCmd = ""
		
		--读取战车天赋点数据
		local talentAdd = 0 --额外获得的天赋点数
		local tLevelInfo = {}
		local sql = string.format("SELECT `talentAdd`, `levelInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, talent, levelInfo = xlDb_Query(sql)
		--print("sql:",sql,e,levelInfo, type(levelInfo))
		if (e == 0) then
			if (type(levelInfo) == "string") and (#levelInfo > 0) then
				levelInfo = "{" .. levelInfo .. "}"
				local tmp = "local prize = " .. levelInfo .. " return prize"
				--战车天赋点表
				tLevelInfo = assert(loadstring(tmp))()
				
				--战车额外的天赋点数
				talentAdd = talent
			end
		end
		
		--遍历是否存在该战车天赋点
		local tInfo = {}
		local bExisted = false
		for i = 1, #tLevelInfo, 1 do
			local tInfo_i = tLevelInfo[i]
			local id = tInfo_i.id or 0 --战车id
			
			if (id == tankId) then --找到了
				bExisted = true
				
				tInfo = tInfo_i
				
				break
			end
		end
		
		--不存在的战车天赋点，末尾新增数据
		if (not bExisted) then
			tInfo = {id = tankId,}
			tLevelInfo[#tLevelInfo+1] = tInfo
		end
		
		local level = tInfo.level or 1 --等级
		local star = tInfo.star or 1 --星级
		local exp = tInfo.exp or 0 --经验值
		local talentPointUsed = tInfo.talentPointUsed or 0 --已使用的天赋点数
		local talentPointSum = hVar.TANK_LEVELUP_EXP[level].talentNum + talentAdd --总天赋点数
		local talentPoint = talentPointSum - talentPointUsed --剩余天赋点数
		local talentPointAdd = tInfo.talentPointAdd or {} --天赋加点表
		
		--剩余天赋点数
		local talentPointNew = talentPoint
		
		--还原需要的总积分
		local requireScoreSum = 0
		
		--插入订单
		local shopItemId = TankTalentPoint.RESTORETALENT_SHOPITEM_ID
		local tabShopItem = hVar.tab_shopitem[shopItemId]
		local coseRmb = tabShopItem.rmb or 0 --需要的游戏币
		local itemId = tabShopItem.itemID or 0 --商品道具id
		--local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
		
		--还原需要的游戏币
		local requireRmb = coseRmb
		
		--扣除游戏币
		local bSuccess, order_id = hGlobal.userCoinMgr:DBUserPurchase(self._uid,self._rid, itemId, 1, coseRmb, 0, tostring(talentPointSum))
		if bSuccess then
			--新的已使用的天赋点数
			local talentPointUsedNew = talentPointUsed
			
			--依次遍历全部天赋点
			for i = 1, #hVar.talent_tree, 1 do
				local talentId = hVar.talent_tree[i]
				--天赋树表
				local tTalent = hVar.tab_chariottalent[talentId]
				local attrPointMaxLv = tTalent.attrPointMaxLv --天赋等级上限
				local attrPointUpgrade = tTalent.attrPointUpgrade
				local requireAttrPoint = attrPointUpgrade.requireAttrPoint  --每级需要的天赋点数
				--local requireScore = attrPointUpgrade.requireScore  --需要的积分
				local attrPointRestore = tTalent.attrPointRestore
				local requireScore = attrPointRestore.requireScore  --重置需要的积分
				local talentLvNow = talentPointAdd[talentId] or 0 --天赋点当前等级
				
				--已经升过天赋点
				if (talentLvNow > 0) then
					--重置天赋技能等级
					local talentLvNew = 0
					talentPointAdd[talentId] = talentLvNew
					
					--还原天赋点数
					talentPointUsedNew = talentPointUsedNew - requireAttrPoint * talentLvNow
					
					--需要的积分
					requireScoreSum = requireScore * talentLvNow
				end
			end
			
			--存储
			tInfo.talentPointUsed = talentPointUsedNew
			tInfo.talentPointAdd = talentPointAdd
			
			--剩余天赋点数
			talentPointNew = talentPointSum - talentPointUsedNew
			
			--存档
			local saveData = ""
			--saveData = saveData .. "{"
			for k = 1, #tLevelInfo, 1 do
				local tInfo = tLevelInfo[k]
				saveData = saveData .. serialize(tInfo) .. ",\n"
			end
			--saveData = saveData .. "},\n"
			--print("saveData", saveData)
			
			--更新
			local sUpdate = string.format("UPDATE `t_cha` SET `levelInfo` = '%s' where `id` = %d", saveData, self._rid)
			--print("sUpdate1:",sUpdate)
			xlDb_Execute(sUpdate)
			
			ret = 1 --成功
		else
			ret = -1 --游戏币不足
		end
		
		strCmd = strCmd .. tankId .. ";" .. talentPointNew .. ";" .. requireScoreSum .. ";" .. requireRmb .. ";"
		
		strCmd = ret .. ";" .. strCmd
		return strCmd
	end
	
return TankTalentPoint