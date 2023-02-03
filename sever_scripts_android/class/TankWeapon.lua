--宝物类
local TankWeapon = class("TankWeapon")
	
	--加经验值的商店id
	TankWeapon.ADDEXP_SHOPITEM_ID = 434
	
	--构造函数
	function TankWeapon:ctor()
		self._uid = -1
		self._rid = -1
		
		return self
	end
	
	--初始化
	function TankWeapon:Init(uid, rid)
		self._uid = uid
		self._rid = rid
		
		return self
	end
	
	--查询玩家武器枪信息
	function TankWeapon:QueryInfo()
		local strCmd = ""
		
		--读取武器枪数据
		local tWeapon = {{6013,1,0,1,},}
		local sql = string.format("SELECT `heroInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, heroInfo = xlDb_Query(sql)
		--print("sql:",sql,e,heroInfo, type(heroInfo))
		if (e == 0) then
			if (type(heroInfo) == "string") and (#heroInfo > 0) then
				heroInfo = "{" .. heroInfo .. "}"
				local tmp = "local prize = " .. heroInfo .. " return prize"
				--宝物碎片表
				tWeapon = assert(loadstring(tmp))()
			end
		end
		
		strCmd = strCmd .. #tWeapon .. ";"
		for i = 1, #tWeapon, 1 do
			local id = tWeapon[i][1]
			local star = tWeapon[i][2]
			local num = tWeapon[i][3]
			local exp = tWeapon[i][4]
			local tmp = id .. ":" .. star .. ":" .. num .. ":" .. exp .. ";"
			strCmd = strCmd .. tmp
		end
		
		return strCmd
	end
	
	--增加武器枪碎片
	function TankWeapon:AddDebris(weaponId, debrisNum)
		--print("AddDebris", weaponId, debrisNum)
		--print("self._uid", self._uid)
		--print("self._rid", self._rid)
		--print(debug.traceback())
		
		--无效的武器id
		if (weaponId <= 0) then
			return
		end
		
		--无效的数量
		if (debrisNum <= 0) then
			return
		end
		
		--读取武器枪数据
		local tWeapon = {{6013,1,0,1,},}
		local sql = string.format("SELECT `heroInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, heroInfo = xlDb_Query(sql)
		--print("sql:",sql,e,heroInfo)
		if (e == 0) then
			if (type(heroInfo) == "string") and (#heroInfo > 0) then
				heroInfo = "{" .. heroInfo .. "}"
				local tmp = "local prize = " .. heroInfo .. " return prize"
				--宝物碎片表
				tWeapon = assert(loadstring(tmp))()
			end
		end
		
		--遍历是否存在该武器枪碎片，叠加数量
		local bExisted = false
		for i = 1, #tWeapon, 1 do
			local id = tWeapon[i][1]
			local lv = tWeapon[i][2]
			local num = tWeapon[i][3]
			local exp = tWeapon[i][4]
			
			if (id == weaponId) then --找到了
				bExisted = true
				
				tWeapon[i][3] = num + debrisNum
				
				break
			end
		end
		
		--不存在的宝物碎片，末尾新增数据
		if (not bExisted) then
			tWeapon[#tWeapon+1] = {weaponId, 0, debrisNum, 0,}
		end
		
		--按照序号转换成字典表
		local tWeaponDic = {}
		for k, v in ipairs(tWeapon) do
			local id = tWeapon[k][1]
			tWeaponDic[id] = v
			--print("tWeaponDic", id)
		end
		
		--存档
		local saveData = ""
		for k = 1, #hVar.tab_weapon, 1 do
			local unitId = hVar.tab_weapon[k].unitId
			local v = tWeaponDic[unitId]
			--print("v", v)
			if v then
				saveData = saveData .. "{"
				for i = 1, #v, 1 do
					saveData = saveData .. v[i] .. ","
				end
				saveData = saveData .. "},\n"
			end
		end
		--print("TankWeapon saveData:\n", saveData)
		
		--更新
		local sUpdate = string.format("UPDATE `t_cha` SET `heroInfo` = '%s' where `id` = %d", saveData, self._rid)
		--print("sUpdate1:",sUpdate)
		xlDb_Execute(sUpdate)
	end
	
	--武器枪升星
	function TankWeapon:StarUp(weaponId)
		local ret = 0
		local strCmd = ""
		local nStarRet = -1
		local nLevelRet = -1
		
		strCmd = strCmd .. weaponId .. ";"
		
		--读取武器枪数据
		local tWeapon = {{6013,1,0,1,},}
		local sql = string.format("SELECT `heroInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, heroInfo = xlDb_Query(sql)
		--print("sql:",sql,e,heroInfo)
		if (e == 0) then
			if (type(heroInfo) == "string") and (#heroInfo > 0) then
				heroInfo = "{" .. heroInfo .. "}"
				local tmp = "local prize = " .. heroInfo .. " return prize"
				--宝物碎片表
				tWeapon = assert(loadstring(tmp))()
			end
		end
		
		local star = 0 --星级
		local debrisNum = 0 --碎片数量
		local level = 0 --等级
		
		for i = 1, #tWeapon, 1 do
			local id = tWeapon[i][1]
			local star_i = tWeapon[i][2]
			local num = tWeapon[i][3]
			local lv = tWeapon[i][4]
			
			if (id == weaponId) then --找到了
				star = star_i
				debrisNum = num
				level = lv
				
				break
			end
		end

		-- 升星前星级
		nStarRet = star
		-- 升星前等级
		nLevelRet = level
		
		--升星需要的碎片数量
		local costDebris = 0 --需要的碎片数量
		local nowDebris = debrisNum --当前的碎片数量
		local costScore = 0 --需要的积分
		local coseRmb = 0 --需要的游戏币
		local requireLv = 0 --需要的等级
		--local nowScore = LuaGetPlayerScore() --当前的积分
		local itemId = 0 --商品道具id
		
		--print("weaponId=", weaponId)
		--print("nowDebris=", nowDebris)
		--print("star=", star)
		
		if (star < hVar.WEAPON_STARUP_INFO.maxWeaponStar) then
			local tStarUpInfo = hVar.WEAPON_STARUP_INFO[star]
			costDebris = tStarUpInfo.costDebris or 0 --需要的碎片数量
			requireLv = tStarUpInfo.requireLv --需要的等级
			local shopItemId = tStarUpInfo.shopItemId or 0
			local tabShopItem = hVar.tab_shopitem[shopItemId]
			if tabShopItem then
				--costRmb = tabShopItem.rmb or 0
				costScore = tabShopItem.score or 0 --需要的积分
				coseRmb = tabShopItem.rmb or 0 --需要的游戏币
				itemId = tabShopItem.itemID or 0 --商品道具id
			end
			
			--print("shopItemId=", shopItemId)
			--print("costScore=", costScore)
			--print("itemId=", itemId)
		end
		
		--未到顶星
		if (star < hVar.WEAPON_STARUP_INFO.maxWeaponStar) then
			--等级足够
			if (level >= requireLv) then
				--碎片足够
				if (nowDebris >= costDebris) then
					--扣除游戏币
					local bSuccess, order_id = hGlobal.userCoinMgr:DBUserPurchase(self._uid,self._rid, itemId, 1, coseRmb, 0, tostring(weaponId))
					if bSuccess then
						--升星
						local newStar = star + 1
						local newDebris = nowDebris - costDebris
						local newLevel = level
						
						--升星的同时，等级加1
						newLevel = level + 1
						if (newLevel > hVar.WEAPON_LVUP_INFO.maxWeaponLv) then
							newLevel = hVar.WEAPON_LVUP_INFO.maxWeaponLv
						end
						
						--存档
						for i = 1, #tWeapon, 1 do
							local id = tWeapon[i][1]
							local star_i = tWeapon[i][2]
							local num = tWeapon[i][3]
							local lv = tWeapon[i][4]
							
							if (id == weaponId) then --找到了
								tWeapon[i][2] = newStar
								tWeapon[i][3] = newDebris
								tWeapon[i][4] = newLevel
								
								break
							end
						end
						
						--存档
						local saveData = ""
						for k = 1, #tWeapon, 1 do
							local v = tWeapon[k]
							
							saveData = saveData .. "{"
							for i = 1, #v, 1 do
								saveData = saveData .. v[i] .. ","
							end
							saveData = saveData .. "},\n"
						end
						
						--更新
						local sUpdate = string.format("UPDATE `t_cha` SET `heroInfo` = '%s' where `id` = %d", saveData, self._rid)
						--print("sUpdate1:",sUpdate)
						xlDb_Execute(sUpdate)
						
						--[[
						--插入订单
						local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
						
						--订单表
						--新的购买记录插入到order表
						sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,self._uid,self._rid,itemId,1,sItemName,0,costScore,tostring(weaponId)..";"..tostring(newStar)..";"..tostring(newDebris)..";"..tostring(costScore)..";")
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
	
	--[[
	--武器枪加经验值
	function TankWeapon:AddExp(weaponId, expAdd)
		local ret = 0
		local strCmd = ""
		
		strCmd = strCmd .. weaponId .. ";"
		
		--读取武器枪数据
		local tWeapon = {{6013,1,0,1,},}
		local sql = string.format("SELECT `heroInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, heroInfo = xlDb_Query(sql)
		--print("sql:",sql,e,heroInfo)
		if (e == 0) then
			if (type(heroInfo) == "string") and (#heroInfo > 0) then
				heroInfo = "{" .. heroInfo .. "}"
				local tmp = "local prize = " .. heroInfo .. " return prize"
				--宝物碎片表
				tWeapon = assert(loadstring(tmp))()
			end
		end
		
		local star = -1 --星级
		local expNow = 0 --经验值
		
		for i = 1, #tWeapon, 1 do
			local id = tWeapon[i][1]
			local star_i = tWeapon[i][2]
			local num = tWeapon[i][3]
			local exp = tWeapon[i][4]
			
			if (id == weaponId) then --找到了
				star = star_i
				expNow = exp
				
				break
			end
		end
		
		--存在武器枪
		if (star >= 0) then
			--加经验值
			local newExp = expNow + expAdd
			
			--存档
			for i = 1, #tWeapon, 1 do
				local id = tWeapon[i][1]
				local star_i = tWeapon[i][2]
				local num = tWeapon[i][3]
				local exp = tWeapon[i][4]
				
				if (id == weaponId) then --找到了
					tWeapon[i][4] = newExp
					
					break
				end
			end
			
			--存档
			local saveData = ""
			for k = 1, #tWeapon, 1 do
				local v = tWeapon[k]
				
				saveData = saveData .. "{"
				for i = 1, #v, 1 do
					saveData = saveData .. v[i] .. ","
				end
				saveData = saveData .. "},\n"
			end
			
			--更新
			local sUpdate = string.format("UPDATE `t_cha` SET `heroInfo` = '%s' where `id` = %d", saveData, self._rid)
			--print("sUpdate1:",sUpdate)
			xlDb_Execute(sUpdate)
			
			--插入订单
			local shopItemId = TankWeapon.ADDEXP_SHOPITEM_ID
			local tabShopItem = hVar.tab_shopitem[shopItemId]
			local itemId = tabShopItem.itemID or 0 --商品道具id
			local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
			
			--订单表
			--新的购买记录插入到order表
			sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,self._uid,self._rid,itemId,1,sItemName,0,0,tostring(weaponId)..";"..tostring(newExp)..";"..tostring(expAdd)..";")
			--print("sUpdate2:",sUpdate)
			xlDb_Execute(sUpdate)
			
			ret = 1 --成功
			
			strCmd = strCmd .. newExp .. ";" .. expAdd .. ";"
		else
			ret = -1 --无效的武器枪
		end
		
		strCmd = ret .. ";" .. strCmd
		return strCmd
	end
	]]
	
	--武器枪升级
	function TankWeapon:LevelUp(weaponId)
		local ret = 0
		local strCmd = ""
		
		strCmd = strCmd .. weaponId .. ";"
		
		--读取武器枪数据
		local tWeapon = {{6013,1,0,1,},}
		local sql = string.format("SELECT `heroInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, heroInfo = xlDb_Query(sql)
		--print("sql:",sql,e,heroInfo)
		if (e == 0) then
			if (type(heroInfo) == "string") and (#heroInfo > 0) then
				heroInfo = "{" .. heroInfo .. "}"
				local tmp = "local prize = " .. heroInfo .. " return prize"
				--宝物碎片表
				tWeapon = assert(loadstring(tmp))()
			end
		end
		
		local star = 0 --星级
		local debrisNum = 0 --碎片数量
		local level = 0 --等级
		
		for i = 1, #tWeapon, 1 do
			local id = tWeapon[i][1]
			local star_i = tWeapon[i][2]
			local num = tWeapon[i][3]
			local lv = tWeapon[i][4]
			
			if (id == weaponId) then --找到了
				star = star_i
				debrisNum = num
				level = lv
				
				break
			end
		end
		
		--升级需要的碎片数量
		local costDebris = 0 --需要的碎片数量
		local nowDebris = debrisNum --当前的碎片数量
		local costScore = 0 --需要的积分
		local coseRmb = 0 --需要的游戏币
		local reqiureStar = 0 --需要的星级
		--local nowScore = LuaGetPlayerScore() --当前的积分
		local itemId = 0 --商品道具id
		
		--print("weaponId=", weaponId)
		--print("nowDebris=", nowDebris)
		--print("star=", star)
		
		if (level < hVar.WEAPON_LVUP_INFO.maxWeaponLv) then
			local tLevelUpInfo = hVar.WEAPON_LVUP_INFO[level]
			costDebris = tLevelUpInfo.costDebris or 0 --需要的碎片数量
			reqiureStar = tLevelUpInfo.reqiureStar --需要的星级
			local shopItemId = tLevelUpInfo.shopItemId or 0
			local tabShopItem = hVar.tab_shopitem[shopItemId]
			if tabShopItem then
				--costRmb = tabShopItem.rmb or 0
				costScore = tabShopItem.score or 0 --需要的积分
				coseRmb = tabShopItem.rmb or 0 --需要的游戏币
				itemId = tabShopItem.itemID or 0 --商品道具id
			end
			
			--print("shopItemId=", shopItemId)
			--print("costScore=", costScore)
			--print("itemId=", itemId)
		end
		
		--未到顶级
		if (level < hVar.WEAPON_LVUP_INFO.maxWeaponLv) then
			--星级足够
			if (star >= reqiureStar) then
				--碎片足够
				if (nowDebris >= costDebris) then
					--扣除游戏币
					local bSuccess, order_id = hGlobal.userCoinMgr:DBUserPurchase(self._uid,self._rid, itemId, 1, coseRmb, 0, tostring(weaponId))
					if bSuccess then
						--升级
						local newStar = star
						local newDebris = nowDebris - costDebris
						local newLevel = level + 1
						
						--存档
						for i = 1, #tWeapon, 1 do
							local id = tWeapon[i][1]
							local star_i = tWeapon[i][2]
							local num = tWeapon[i][3]
							local lv = tWeapon[i][4]
							
							if (id == weaponId) then --找到了
								tWeapon[i][2] = newStar
								tWeapon[i][3] = newDebris
								tWeapon[i][4] = newLevel
								
								break
							end
						end
						
						--存档
						local saveData = ""
						for k = 1, #tWeapon, 1 do
							local v = tWeapon[k]
							
							saveData = saveData .. "{"
							for i = 1, #v, 1 do
								saveData = saveData .. v[i] .. ","
							end
							saveData = saveData .. "},\n"
						end
						
						--更新
						local sUpdate = string.format("UPDATE `t_cha` SET `heroInfo` = '%s' where `id` = %d", saveData, self._rid)
						--print("sUpdate1:",sUpdate)
						xlDb_Execute(sUpdate)
						
						--[[
						--插入订单
						local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
						
						--订单表
						--新的购买记录插入到order表
						sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,self._uid,self._rid,itemId,1,sItemName,0,costScore,tostring(weaponId)..";"..tostring(newStar)..";"..tostring(newDebris)..";"..tostring(costScore)..";")
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
	
return TankWeapon