--战车宠物类
local TankPet = class("TankPet")
	
	--加经验值的商店id
	TankPet.ADDEXP_SHOPITEM_ID = 437
	
	--派遣最小星级
	TankPet.SEND_STAR_MIN = 2
	
	--挖矿的商店id
	TankPet.WAKUANG_SHOPITEM_ID = 641
	
	--挖体力的商店id
	TankPet.WATILI_SHOPITEM_ID = 642
	
	--取消挖矿的商店id
	TankPet.CANCEL_WAKUANG_SHOPITEM_ID = 643
	
	--取消挖体力的商店id
	TankPet.CANCEL_WATILI_SHOPITEM_ID = 644
	
	--构造函数
	function TankPet:ctor()
		self._uid = -1
		self._rid = -1
		
		return self
	end
	
	--初始化
	function TankPet:Init(uid, rid)
		self._uid = uid
		self._rid = rid
		
		return self
	end
	
	--查询玩家宠物信息
	function TankPet:QueryInfo()
		local strCmd = ""
		
		--读取宠物数据
		local tPet = {}
		local sql = string.format("SELECT `inventoryInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, inventoryInfo = xlDb_Query(sql)
		--print("sql:",sql,e,inventoryInfo, type(inventoryInfo))
		if (e == 0) then
			if (type(inventoryInfo) == "string") and (#inventoryInfo > 0) then
				inventoryInfo = "{" .. inventoryInfo .. "}"
				local tmp = "local prize = " .. inventoryInfo .. " return prize"
				--宠物信息表
				tPet = assert(loadstring(tmp))()
			end
		end
		
		strCmd = strCmd .. #tPet .. ";"
		for i = 1, #tPet, 1 do
			local id = tonumber(tPet[i][1]) or 0
			local star_i = tonumber(tPet[i][2]) or 0
			local num = tonumber(tPet[i][3]) or 0
			local level = tonumber(tPet[i][4]) or 0
			local wakuang = tonumber(tPet[i][5]) or 0
			local watili = tonumber(tPet[i][6]) or 0
			local sendtime = tonumber(tPet[i][7]) or 0
			local lastexporttime_wakuang = tonumber(tPet[i][8]) or 0 --上次挖矿结算时间
			local lastexporttime_watili = tonumber(tPet[i][9]) or 0 --上次挖体力算时间
			local lastexporttime_wachest = tonumber(tPet[i][10]) or 0 --上次挖宝箱算时间
			local tmp = id .. ":" .. star_i .. ":" .. num .. ":" .. level .. ":" .. wakuang .. ":" .. watili .. ":" .. sendtime .. ":" .. lastexporttime_wakuang .. ":"
					.. lastexporttime_watili .. ":" .. lastexporttime_wachest .. ";"
			strCmd = strCmd .. tmp
		end
		
		return strCmd
	end
	
	--增加宠物碎片
	function TankPet:AddDebris(petId, debrisNum)
		--print("AddDebris", petId, debrisNum)
		--print("self._uid", self._uid)
		--print("self._rid", self._rid)
		--print(debug.traceback())
		
		--无效的宠物id
		if (petId <= 0) then
			return
		end
		
		--无效的数量
		if (debrisNum <= 0) then
			return
		end
		
		--读取武器枪数据
		local tPet = {}
		local sql = string.format("SELECT `inventoryInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, inventoryInfo = xlDb_Query(sql)
		--print("sql:",sql,e,inventoryInfo)
		if (e == 0) then
			if (type(inventoryInfo) == "string") and (#inventoryInfo > 0) then
				inventoryInfo = "{" .. inventoryInfo .. "}"
				local tmp = "local prize = " .. inventoryInfo .. " return prize"
				--宠物碎片表
				tPet = assert(loadstring(tmp))()
			end
		end
		
		--遍历是否存在该宠物碎片，叠加数量
		local bExisted = false
		for i = 1, #tPet, 1 do
			local id = tonumber(tPet[i][1]) or 0
			local star_i = tonumber(tPet[i][2]) or 0
			local num = tonumber(tPet[i][3]) or 0
			local level = tonumber(tPet[i][4]) or 0
			local wakuang = tonumber(tPet[i][5]) or 0
			local watili = tonumber(tPet[i][6]) or 0
			local sendtime = tonumber(tPet[i][7]) or 0
			local lastexporttime_wakuang = tonumber(tPet[i][8]) or 0 --上次挖矿结算时间
			local lastexporttime_watili = tonumber(tPet[i][9]) or 0 --上次挖体力算时间
			local lastexporttime_wachest = tonumber(tPet[i][10]) or 0 --上次挖宝箱算时间
			
			if (id == petId) then --找到了
				bExisted = true
				
				tPet[i][3] = num + debrisNum
				
				break
			end
		end
		
		--不存在的宠物碎片，末尾新增数据
		if (not bExisted) then
			tPet[#tPet+1] = {petId, 0, debrisNum, 0, 0, 0, 0, 0, 0, 0,}
		end
		
		--按照序号转换成字典表
		local tPetDic = {}
		for k, v in ipairs(tPet) do
			local id = tPet[k][1]
			tPetDic[id] = v
			--print("tPetDic", id)
		end
		
		--存档
		local saveData = ""
		for k = 1, #hVar.tab_pet, 1 do
			local unitId = hVar.tab_pet[k].unitId
			local v = tPetDic[unitId]
			--print("v", v)
			if v then
				saveData = saveData .. "{"
				for i = 1, #v, 1 do
					saveData = saveData .. v[i] .. ","
				end
				saveData = saveData .. "},\n"
			end
		end
		--print("TankPet saveData:\n", saveData)
		
		--更新
		local sUpdate = string.format("UPDATE `t_cha` SET `inventoryInfo` = '%s' where `id` = %d", saveData, self._rid)
		--print("sUpdate1:",sUpdate)
		xlDb_Execute(sUpdate)
	end
	
	--宠物升星
	function TankPet:StarUp(petId)
		local ret = 0
		local strCmd = ""
		local nStarRet = -1
		local nLevelRet = -1
		
		strCmd = strCmd .. petId .. ";"
		
		--读取宠物数据
		local tPet = {}
		local sql = string.format("SELECT `inventoryInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, inventoryInfo = xlDb_Query(sql)
		--print("sql:",sql,e,inventoryInfo)
		if (e == 0) then
			if (type(inventoryInfo) == "string") and (#inventoryInfo > 0) then
				inventoryInfo = "{" .. inventoryInfo .. "}"
				local tmp = "local prize = " .. inventoryInfo .. " return prize"
				--宠物碎片表
				tPet = assert(loadstring(tmp))()
			end
		end
		
		local star = 0 --星级
		local debrisNum = 0 --碎片数量
		local petLevel = 0 --宠物等级
		
		for i = 1, #tPet, 1 do
			local id = tonumber(tPet[i][1]) or 0
			local star_i = tonumber(tPet[i][2]) or 0
			local num = tonumber(tPet[i][3]) or 0
			local level = tonumber(tPet[i][4]) or 0
			local wakuang = tonumber(tPet[i][5]) or 0
			local watili = tonumber(tPet[i][6]) or 0
			local sendtime = tonumber(tPet[i][7]) or 0
			local lastexporttime_wakuang = tonumber(tPet[i][8]) or 0 --上次挖矿结算时间
			local lastexporttime_watili = tonumber(tPet[i][9]) or 0 --上次挖体力算时间
			local lastexporttime_wachest = tonumber(tPet[i][10]) or 0 --上次挖宝箱算时间
			
			if (id == petId) then --找到了
				star = star_i
				debrisNum = num
				petLevel = level
				
				break
			end
		end

		-- 升星前星级
		nStarRet = star
		-- 升星前等级
		nLevelRet = level
		
		--升星需要的宠物碎片
		local costDebris = 0 --需要的碎片数量
		local nowDebris = debrisNum --当前的碎片数量
		local costScore = 0 --需要的积分
		--local nowScore = LuaGetPlayerScore() --当前的积分
		local coseRmb = 0 --需要的游戏币
		local itemId = 0 --商品道具id
		local requireLv = 0 --需要的等级
		
		if (star < hVar.PET_STAR_INFO_NEW.maxPetStar) then
			local tStarUpInfo = hVar.PET_STAR_INFO_NEW[star]
			costDebris = tStarUpInfo.costDebris or 0 --需要的碎片数量
			local shopItemId = tStarUpInfo.shopItemId or 0
			local tabShopItem = hVar.tab_shopitem[shopItemId]
			if tabShopItem then
				--costRmb = tabShopItem.rmb or 0
				costScore = tabShopItem.score or 0 --需要的积分
				itemId = tabShopItem.itemID or 0 --商品道具id
				coseRmb = tabShopItem.rmb or 0 --需要的游戏币
				requireLv = tStarUpInfo.requireLv --需要的等级
			end
			
			--[[
			print("shopItemId=", shopItemId)
			print("costScore=", costScore)
			print("itemId=", itemId)
			print("costDebris=", costDebris)
			print("petId=", petId)
			print("nowDebris=", nowDebris)
			print("coseRmb=", coseRmb)
			print("star=", star)
			print("petLevel=", petLevel)
			print("requireLv=", requireLv)
			]]
		end
		
		if (star < hVar.PET_STAR_INFO_NEW.maxPetStar) then
			--等级足够
			if (petLevel >= requireLv) then
				if (nowDebris >= costDebris) then
					--扣除游戏币
					local bSuccess, order_id = hGlobal.userCoinMgr:DBUserPurchase(self._uid,self._rid, itemId, 1, coseRmb, 0, tostring(petId))
					if bSuccess then
						--升星
						local newStar = star + 1
						local newDebris = nowDebris - costDebris
						
						--升星时等级加1
						local newLevel = petLevel + 1
						
						--存档
						for i = 1, #tPet, 1 do
							local id = tPet[i][1]
							
							if (id == petId) then --找到了
								tPet[i][2] = newStar
								tPet[i][3] = newDebris
								tPet[i][4] = newLevel
								
								break
							end
						end
						
						--存档
						local saveData = ""
						for k = 1, #tPet, 1 do
							local v = tPet[k]
							
							saveData = saveData .. "{"
							for i = 1, #v, 1 do
								saveData = saveData .. v[i] .. ","
							end
							saveData = saveData .. "},\n"
						end
						
						--更新
						local sUpdate = string.format("UPDATE `t_cha` SET `inventoryInfo` = '%s' where `id` = %d", saveData, self._rid)
						--print("sUpdate1:",sUpdate)
						xlDb_Execute(sUpdate)
						
						--[[
						--插入订单
						local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
						
						--订单表
						--新的购买记录插入到order表
						sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,self._uid,self._rid,itemId,1,sItemName,0,costScore,tostring(petId)..";"..tostring(newStar)..";"..tostring(newDebris)..";"..tostring(costScore)..";")
						--print("sUpdate2:",sUpdate)
						xlDb_Execute(sUpdate)
						]]
						
						---------------------------------------------------------------------------------------------------------
						--[[
						--发送世界红包
						local nHintType = 0
						local strHint = ""
						local sendnum = 8
						local flag = 0
						
						--目前需要发世界红包的神器来源途径
						if (newStar == 1) then --升1星
							nHintType = hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_TREASURE_STAR1
							strHint = hVar.tab_string["__TEXT_REWARDTYPE_TREASURE_STAR1"]
						elseif (newStar == 2) then --升2星
							nHintType = hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_TREASURE_STAR2
							strHint = hVar.tab_string["__TEXT_REWARDTYPE_TREASURE_STAR2"]
						elseif (newStar == 3) then --升3星
							nHintType = hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_TREASURE_STAR3
							strHint = hVar.tab_string["__TEXT_REWARDTYPE_TREASURE_STAR3"]
						elseif (newStar == 4) then --升4星
							nHintType = hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_TREASURE_STAR4
							strHint = hVar.tab_string["__TEXT_REWARDTYPE_TREASURE_STAR4"]
						elseif (newStar == 5) then --升5星
							nHintType = hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_TREASURE_STAR5
							strHint = hVar.tab_string["__TEXT_REWARDTYPE_TREASURE_STAR5"]
						end
						
						local sTreasureName = hVar.tab_stringTR[treasureId] or hVar.tab_stringTR[0]
						local sql = string.format("INSERT INTO `chat_redpacket_pay_redequip` (`uid`, `rid`, `itemId`, `itemName`, `gettime`, `gettype`, `gethint`, `sendnum`, `flag`) VALUES (%d, %d, %d, '%s', NOW(), %d, '%s', %d, %d)", self._uid, self._rid, itemId, sTreasureName, nHintType, strHint, sendnum, flag)
						--print(sql)
						local err = xlDb_Execute(sql)
						]]
						---------------------------------------------------------------------------------------------------------
						
						ret = 1 --成功
						
						strCmd = strCmd .. newStar .. ";" .. newDebris .. ";" .. newLevel .. ";" .. costScore .. ";" .. costDebris .. ";" .. coseRmb .. ";"
						
						-- 升星后星级
						nStarRet = newStar
						-- 升星后等级
						nLevelRet = newLevel
					else
						ret = -4 --游戏币不足
					end
				else
					ret = -2 --碎片不足
				end
			else
				ret = -3 --等级不足
			end
		else
			ret = -1 --已到顶星
		end
		
		strCmd = ret .. ";" .. strCmd
		return strCmd, ret, nStarRet, nLevelRet
	end
	
	--宠物升级
	function TankPet:LevelUp(petId)
		local ret = 0
		local strCmd = ""
		
		strCmd = strCmd .. petId .. ";"
		
		--读取宠物数据
		local tPet = {}
		local sql = string.format("SELECT `inventoryInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, inventoryInfo = xlDb_Query(sql)
		--print("sql:",sql,e,inventoryInfo)
		if (e == 0) then
			if (type(inventoryInfo) == "string") and (#inventoryInfo > 0) then
				inventoryInfo = "{" .. inventoryInfo .. "}"
				local tmp = "local prize = " .. inventoryInfo .. " return prize"
				--宠物碎片表
				tPet = assert(loadstring(tmp))()
			end
		end
		
		local star = 0 --星级
		local debrisNum = 0 --碎片数量
		local petLevel = 0 --宠物等级
		
		for i = 1, #tPet, 1 do
			local id = tonumber(tPet[i][1]) or 0
			local star_i = tonumber(tPet[i][2]) or 0
			local num = tonumber(tPet[i][3]) or 0
			local level = tonumber(tPet[i][4]) or 0
			local wakuang = tonumber(tPet[i][5]) or 0
			local watili = tonumber(tPet[i][6]) or 0
			local sendtime = tonumber(tPet[i][7]) or 0
			local lastexporttime_wakuang = tonumber(tPet[i][8]) or 0 --上次挖矿结算时间
			local lastexporttime_watili = tonumber(tPet[i][9]) or 0 --上次挖体力算时间
			local lastexporttime_wachest = tonumber(tPet[i][10]) or 0 --上次挖宝箱算时间
			
			if (id == petId) then --找到了
				star = star_i
				debrisNum = num
				petLevel = level
				
				break
			end
		end
		
		--升级需要的宠物碎片
		local costDebris = 0 --需要的碎片数量
		local nowDebris = debrisNum --当前的碎片数量
		local costScore = 0 --需要的积分
		--local nowScore = LuaGetPlayerScore() --当前的积分
		local coseRmb = 0 --需要的游戏币
		local itemId = 0 --商品道具id
		local requireStar = 0 --需要的星级
		
		if (petLevel < hVar.PET_LVUP_INFO_NEW.maxPetLv) then
			local tLevelUpInfo = hVar.PET_LVUP_INFO_NEW[petLevel]
			costDebris = tLevelUpInfo.costDebris or 0 --需要的碎片数量
			local shopItemId = tLevelUpInfo.shopItemId or 0
			local tabShopItem = hVar.tab_shopitem[shopItemId]
			if tabShopItem then
				--costRmb = tabShopItem.rmb or 0
				costScore = tabShopItem.score or 0 --需要的积分
				itemId = tabShopItem.itemID or 0 --商品道具id
				coseRmb = tabShopItem.rmb or 0 --需要的游戏币
				requireStar = tLevelUpInfo.reqiureStar --需要的星级
			end
			
			--[[
			print("shopItemId=", shopItemId)
			print("costScore=", costScore)
			print("itemId=", itemId)
			print("costDebris=", costDebris)
			print("petId=", petId)
			print("nowDebris=", nowDebris)
			print("coseRmb=", coseRmb)
			print("star=", star)
			print("petLevel=", petLevel)
			print("requireStar=", requireStar)
			]]
		end
		
		if (petLevel < hVar.PET_LVUP_INFO_NEW.maxPetLv) then
			--星级足够
			if (star >= requireStar) then
				if (nowDebris >= costDebris) then
					--扣除游戏币
					local bSuccess, order_id = hGlobal.userCoinMgr:DBUserPurchase(self._uid,self._rid, itemId, 1, coseRmb, 0, tostring(petId))
					if bSuccess then
						--扣除碎片
						local newDebris = nowDebris - costDebris
						
						--等级加1
						local newStar = star
						local newLevel = petLevel + 1
						
						--存档
						for i = 1, #tPet, 1 do
							local id = tPet[i][1]
							
							if (id == petId) then --找到了
								tPet[i][2] = newStar
								tPet[i][3] = newDebris
								tPet[i][4] = newLevel
								
								break
							end
						end
						
						--存档
						local saveData = ""
						for k = 1, #tPet, 1 do
							local v = tPet[k]
							
							saveData = saveData .. "{"
							for i = 1, #v, 1 do
								saveData = saveData .. v[i] .. ","
							end
							saveData = saveData .. "},\n"
						end
						
						--更新
						local sUpdate = string.format("UPDATE `t_cha` SET `inventoryInfo` = '%s' where `id` = %d", saveData, self._rid)
						--print("sUpdate1:",sUpdate)
						xlDb_Execute(sUpdate)
						
						--[[
						--插入订单
						local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
						
						--订单表
						--新的购买记录插入到order表
						sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,self._uid,self._rid,itemId,1,sItemName,0,costScore,tostring(petId)..";"..tostring(newStar)..";"..tostring(newDebris)..";"..tostring(costScore)..";")
						--print("sUpdate2:",sUpdate)
						xlDb_Execute(sUpdate)
						]]
						
						ret = 1 --成功
						
						strCmd = strCmd .. newStar .. ";" .. newDebris .. ";" .. newLevel .. ";" .. costScore .. ";" .. costDebris .. ";" .. coseRmb .. ";"
					else
						ret = -4 --游戏币不足
					end
				else
					ret = -2 --碎片不足
				end
			else
				ret = -3 --星级不足
			end
		else
			ret = -1 --已到顶级
		end
		
		strCmd = ret .. ";" .. strCmd
		return strCmd, ret
	end
	
	--宠物派遣挖矿
	function TankPet:SendWaKuang(petId)
		local ret = 0
		local strCmd = ""
		
		strCmd = strCmd .. petId .. ";"
		
		--读取宠物数据
		local tPet = {}
		local sql = string.format("SELECT `inventoryInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, inventoryInfo = xlDb_Query(sql)
		--print("sql:",sql,e,inventoryInfo)
		if (e == 0) then
			if (type(inventoryInfo) == "string") and (#inventoryInfo > 0) then
				inventoryInfo = "{" .. inventoryInfo .. "}"
				local tmp = "local prize = " .. inventoryInfo .. " return prize"
				--宠物碎片表
				tPet = assert(loadstring(tmp))()
			end
		end
		
		local star = 0 --星级
		local petWaKuang = 0 --宠物是否挖矿
		local petWaTiLi = 0 --宠物是否挖体力
		local totalSendNum = 0 --全部宠物在挖的数量
		
		for i = 1, #tPet, 1 do
			local id = tonumber(tPet[i][1]) or 0
			local star_i = tonumber(tPet[i][2]) or 0
			local num = tonumber(tPet[i][3]) or 0
			local level = tonumber(tPet[i][4]) or 0
			local wakuang = tonumber(tPet[i][5]) or 0
			local watili = tonumber(tPet[i][6]) or 0
			local sendtime = tonumber(tPet[i][7]) or 0
			local lastexporttime_wakuang = tonumber(tPet[i][8]) or 0 --上次挖矿结算时间
			local lastexporttime_watili = tonumber(tPet[i][9]) or 0 --上次挖体力算时间
			local lastexporttime_wachest = tonumber(tPet[i][10]) or 0 --上次挖宝箱算时间
			
			if (wakuang == 1) or (watili == 1) then
				totalSendNum = totalSendNum + 1
			end
			
			if (id == petId) then --找到了
				star = star_i
				petWaKuang = wakuang
				petWaTiLi = watili
			end
		end
		
		if (petWaKuang == 0) and (petWaTiLi == 0) then --当前没在挖
			if (star >= TankPet.SEND_STAR_MIN) then --星级足够
				local vipLv = hGlobal.vipMgr:DBGetUserVip(self._uid) --玩家vip等级
				local petSendMaxCount = hVar.Vip_Conifg.petSendMaxCount[vipLv] or 0 --宠物最大开挖数量
				--print("vipLv=", vipLv)
				--print("petSendMaxCount=", petSendMaxCount)
				--print("totalSendNum=", totalSendNum)
				
				--派遣没满
				if (totalSendNum < petSendMaxCount) then
					--订单
					local tabShopItem = hVar.tab_shopitem[TankPet.WAKUANG_SHOPITEM_ID]
					local itemId = tabShopItem.itemID
					hGlobal.userCoinMgr:DBUserPurchase(self._uid,self._rid, itemId, 1, 0, 0, tostring(petId))
					
					--标记挖矿
					local newWaKuang = 1
					local currenttime = os.time()
					
					--存档
					for i = 1, #tPet, 1 do
						local id = tPet[i][1]
						
						if (id == petId) then --找到了
							tPet[i][5] = newWaKuang
							tPet[i][7] = currenttime --存储派遣时间
							
							break
						end
					end
					
					--存档
					local saveData = ""
					for k = 1, #tPet, 1 do
						local v = tPet[k]
						
						saveData = saveData .. "{"
						for i = 1, #v, 1 do
							saveData = saveData .. v[i] .. ","
						end
						saveData = saveData .. "},\n"
					end
					
					--更新
					local sUpdate = string.format("UPDATE `t_cha` SET `inventoryInfo` = '%s' where `id` = %d", saveData, self._rid)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
					
					--[[
					--插入订单
					local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
					
					--订单表
					--新的购买记录插入到order表
					sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,self._uid,self._rid,itemId,1,sItemName,0,costScore,tostring(petId)..";"..tostring(newStar)..";"..tostring(newDebris)..";"..tostring(costScore)..";")
					--print("sUpdate2:",sUpdate)
					xlDb_Execute(sUpdate)
					]]
					
					ret = 1 --成功
					
					strCmd = strCmd .. newWaKuang .. ";" .. currenttime .. ";"
				else
					ret = -4 --派遣宠物数量已达上限
				end
			else
				ret = -3 --宠物未解锁挖矿
			end
		elseif (petWaKuang == 1) then --之前已经在挖矿
			ret = -1 --已经在挖矿中
		elseif (petWaTiLi == 1) then --之前已经在挖体力
			ret = -2 --已经在挖体力中
		end
		
		strCmd = ret .. ";" .. strCmd
		return strCmd
	end
	
	--宠物取消挖矿
	function TankPet:CancelWaKuang(petId)
		local ret = 0
		local strCmd = ""
		
		strCmd = strCmd .. petId .. ";"
		
		--读取宠物数据
		local tPet = {}
		local sql = string.format("SELECT `inventoryInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, inventoryInfo = xlDb_Query(sql)
		--print("sql:",sql,e,inventoryInfo)
		if (e == 0) then
			if (type(inventoryInfo) == "string") and (#inventoryInfo > 0) then
				inventoryInfo = "{" .. inventoryInfo .. "}"
				local tmp = "local prize = " .. inventoryInfo .. " return prize"
				--宠物碎片表
				tPet = assert(loadstring(tmp))()
			end
		end
		
		local petWaKuang = 0 --宠物是否挖矿
		
		for i = 1, #tPet, 1 do
			local id = tonumber(tPet[i][1]) or 0
			local star_i = tonumber(tPet[i][2]) or 0
			local num = tonumber(tPet[i][3]) or 0
			local level = tonumber(tPet[i][4]) or 0
			local wakuang = tonumber(tPet[i][5]) or 0
			local watili = tonumber(tPet[i][6]) or 0
			local sendtime = tonumber(tPet[i][7]) or 0
			local lastexporttime_wakuang = tonumber(tPet[i][8]) or 0 --上次挖矿结算时间
			local lastexporttime_watili = tonumber(tPet[i][9]) or 0 --上次挖体力算时间
			local lastexporttime_wachest = tonumber(tPet[i][10]) or 0 --上次挖宝箱算时间
			
			if (id == petId) then --找到了
				petWaKuang = wakuang
				break
			end
		end
		
		if (petWaKuang == 1) then --当前正在挖矿
			--订单
			local tabShopItem = hVar.tab_shopitem[TankPet.CANCEL_WAKUANG_SHOPITEM_ID]
			local itemId = tabShopItem.itemID
			hGlobal.userCoinMgr:DBUserPurchase(self._uid,self._rid, itemId, 1, 0, 0, tostring(petId))
			
			
			--标记未挖矿
			local newWaKuang = 0
			
			--存档
			for i = 1, #tPet, 1 do
				local id = tPet[i][1]
				
				if (id == petId) then --找到了
					tPet[i][5] = newWaKuang
					tPet[i][7] = 0 --存储派遣时间
					
					break
				end
			end
			
			--存档
			local saveData = ""
			for k = 1, #tPet, 1 do
				local v = tPet[k]
				
				saveData = saveData .. "{"
				for i = 1, #v, 1 do
					saveData = saveData .. v[i] .. ","
				end
				saveData = saveData .. "},\n"
			end
			
			--更新
			local sUpdate = string.format("UPDATE `t_cha` SET `inventoryInfo` = '%s' where `id` = %d", saveData, self._rid)
			--print("sUpdate1:",sUpdate)
			xlDb_Execute(sUpdate)
			
			--[[
			--插入订单
			local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
			
			--订单表
			--新的购买记录插入到order表
			sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,self._uid,self._rid,itemId,1,sItemName,0,costScore,tostring(petId)..";"..tostring(newStar)..";"..tostring(newDebris)..";"..tostring(costScore)..";")
			--print("sUpdate2:",sUpdate)
			xlDb_Execute(sUpdate)
			]]
			
			ret = 1 --成功
			
			strCmd = strCmd .. newWaKuang .. ";"
		else
			ret = -1 --宠物当前未挖矿
		end
		
		strCmd = ret .. ";" .. strCmd
		return strCmd
	end
	
	--宠物派遣挖体力
	function TankPet:SendWaTiLi(petId)
		local ret = 0
		local strCmd = ""
		
		strCmd = strCmd .. petId .. ";"
		
		--读取宠物数据
		local tPet = {}
		local sql = string.format("SELECT `inventoryInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, inventoryInfo = xlDb_Query(sql)
		--print("sql:",sql,e,inventoryInfo)
		if (e == 0) then
			if (type(inventoryInfo) == "string") and (#inventoryInfo > 0) then
				inventoryInfo = "{" .. inventoryInfo .. "}"
				local tmp = "local prize = " .. inventoryInfo .. " return prize"
				--宠物碎片表
				tPet = assert(loadstring(tmp))()
			end
		end
		
		local star = 0 --星级
		local petWaKuang = 0 --宠物是否挖矿
		local petWaTiLi = 0 --宠物是否挖体力
		local totalSendNum = 0 --全部宠物在挖的数量
		
		for i = 1, #tPet, 1 do
			local id = tonumber(tPet[i][1]) or 0
			local star_i = tonumber(tPet[i][2]) or 0
			local num = tonumber(tPet[i][3]) or 0
			local level = tonumber(tPet[i][4]) or 0
			local wakuang = tonumber(tPet[i][5]) or 0
			local watili = tonumber(tPet[i][6]) or 0
			local sendtime = tonumber(tPet[i][7]) or 0
			local lastexporttime_wakuang = tonumber(tPet[i][8]) or 0 --上次挖矿结算时间
			local lastexporttime_watili = tonumber(tPet[i][9]) or 0 --上次挖体力算时间
			local lastexporttime_wachest = tonumber(tPet[i][10]) or 0 --上次挖宝箱算时间
			
			if (wakuang == 1) or (watili == 1) then
				totalSendNum = totalSendNum + 1
			end
			
			if (id == petId) then --找到了
				star = star_i
				petWaKuang = wakuang
				petWaTiLi = watili
			end
		end
		
		if (petWaKuang == 0) and (petWaTiLi == 0) then --当前没在挖
			if (star >= TankPet.SEND_STAR_MIN) then --星级足够
				local vipLv = hGlobal.vipMgr:DBGetUserVip(self._uid) --玩家vip等级
				local petSendMaxCount = hVar.Vip_Conifg.petSendMaxCount[vipLv] or 0 --宠物最大开挖数量
				--print("vipLv=", vipLv)
				--print("petSendMaxCount=", petSendMaxCount)
				--print("totalSendNum=", totalSendNum)
				
				--派遣没满
				if (totalSendNum < petSendMaxCount) then
					--订单
					local tabShopItem = hVar.tab_shopitem[TankPet.WATILI_SHOPITEM_ID]
					local itemId = tabShopItem.itemID
					hGlobal.userCoinMgr:DBUserPurchase(self._uid,self._rid, itemId, 1, 0, 0, tostring(petId))
					
					--标记挖矿
					local newWaTiLi = 1
					local currenttime = os.time()
					
					--存档
					for i = 1, #tPet, 1 do
						local id = tPet[i][1]
						
						if (id == petId) then --找到了
							tPet[i][6] = newWaTiLi
							tPet[i][7] = currenttime --存储派遣时间
							
							break
						end
					end
					
					--存档
					local saveData = ""
					for k = 1, #tPet, 1 do
						local v = tPet[k]
						
						saveData = saveData .. "{"
						for i = 1, #v, 1 do
							saveData = saveData .. v[i] .. ","
						end
						saveData = saveData .. "},\n"
					end
					
					--更新
					local sUpdate = string.format("UPDATE `t_cha` SET `inventoryInfo` = '%s' where `id` = %d", saveData, self._rid)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
					
					--[[
					--插入订单
					local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
					
					--订单表
					--新的购买记录插入到order表
					sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,self._uid,self._rid,itemId,1,sItemName,0,costScore,tostring(petId)..";"..tostring(newStar)..";"..tostring(newDebris)..";"..tostring(costScore)..";")
					--print("sUpdate2:",sUpdate)
					xlDb_Execute(sUpdate)
					]]
					
					ret = 1 --成功
					
					strCmd = strCmd .. newWaTiLi .. ";" .. currenttime .. ";"
				else
					ret = -4 --派遣宠物数量已达上限
				end
			else
				ret = -3 --宠物未解锁挖矿
			end
		elseif (petWaKuang == 1) then --之前已经在挖矿
			ret = -1 --已经在挖矿中
		elseif (petWaTiLi == 1) then --之前已经在挖体力
			ret = -2 --已经在挖体力中
		end
		
		strCmd = ret .. ";" .. strCmd
		return strCmd
	end
	
	--宠物取消挖体力
	function TankPet:CancelWaTiLi(petId)
		local ret = 0
		local strCmd = ""
		
		strCmd = strCmd .. petId .. ";"
		
		--读取宠物数据
		local tPet = {}
		local sql = string.format("SELECT `inventoryInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, inventoryInfo = xlDb_Query(sql)
		--print("sql:",sql,e,inventoryInfo)
		if (e == 0) then
			if (type(inventoryInfo) == "string") and (#inventoryInfo > 0) then
				inventoryInfo = "{" .. inventoryInfo .. "}"
				local tmp = "local prize = " .. inventoryInfo .. " return prize"
				--宠物碎片表
				tPet = assert(loadstring(tmp))()
			end
		end
		
		local petWaTiLi = 0 --宠物是否挖体力
		
		for i = 1, #tPet, 1 do
			local id = tonumber(tPet[i][1]) or 0
			local star_i = tonumber(tPet[i][2]) or 0
			local num = tonumber(tPet[i][3]) or 0
			local level = tonumber(tPet[i][4]) or 0
			local wakuang = tonumber(tPet[i][5]) or 0
			local watili = tonumber(tPet[i][6]) or 0
			local sendtime = tonumber(tPet[i][7]) or 0
			local lastexporttime_wakuang = tonumber(tPet[i][8]) or 0 --上次挖矿结算时间
			local lastexporttime_watili = tonumber(tPet[i][9]) or 0 --上次挖体力算时间
			local lastexporttime_wachest = tonumber(tPet[i][10]) or 0 --上次挖宝箱算时间
			
			if (id == petId) then --找到了
				petWaTiLi = watili
				break
			end
		end
		
		if (petWaTiLi == 1) then --当前正在挖体力
			--订单
			local tabShopItem = hVar.tab_shopitem[TankPet.CANCEL_WATILI_SHOPITEM_ID]
			local itemId = tabShopItem.itemID
			hGlobal.userCoinMgr:DBUserPurchase(self._uid,self._rid, itemId, 1, 0, 0, tostring(petId))
			
			
			--标记未挖体力
			local newWaTiLi = 0
			
			--存档
			for i = 1, #tPet, 1 do
				local id = tPet[i][1]
				
				if (id == petId) then --找到了
					tPet[i][6] = newWaTiLi
					tPet[i][7] = 0 --存储派遣时间
					
					break
				end
			end
			
			--存档
			local saveData = ""
			for k = 1, #tPet, 1 do
				local v = tPet[k]
				
				saveData = saveData .. "{"
				for i = 1, #v, 1 do
					saveData = saveData .. v[i] .. ","
				end
				saveData = saveData .. "},\n"
			end
			
			--更新
			local sUpdate = string.format("UPDATE `t_cha` SET `inventoryInfo` = '%s' where `id` = %d", saveData, self._rid)
			--print("sUpdate1:",sUpdate)
			xlDb_Execute(sUpdate)
			
			--[[
			--插入订单
			local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
			
			--订单表
			--新的购买记录插入到order表
			sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,self._uid,self._rid,itemId,1,sItemName,0,costScore,tostring(petId)..";"..tostring(newStar)..";"..tostring(newDebris)..";"..tostring(costScore)..";")
			--print("sUpdate2:",sUpdate)
			xlDb_Execute(sUpdate)
			]]
			
			ret = 1 --成功
			
			strCmd = strCmd .. newWaTiLi .. ";"
		else
			ret = -1 --宠物当前未挖体力
		end
		
		strCmd = ret .. ";" .. strCmd
		return strCmd
	end
	
return TankPet