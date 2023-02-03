--宝物类
local Treasure = class("Treasure")
	
	--构造函数
	function Treasure:ctor()
		self._uid = -1
		self._rid = -1
		
		return self
	end
	
	--初始化
	function Treasure:Init(uid, rid)
		self._uid = uid
		self._rid = rid
		
		return self
	end
	
	--查询玩家宝物和宝物属性位值信息
	function Treasure:QueryInfo()
		local strCmd = ""
		
		--读取玩家的藏宝图和高级藏宝图数量、消耗游戏币总数量
		local cangbaotuNum = 0
		local cangbaotuHighNum = 0
		local gamecoinTotalNum = 0
		local sql = string.format("SELECT `cangbaotu`, `cangbaotu_high`, `gamecoin_totalnum` FROM `t_user` WHERE `uid` = %d", self._uid)
		local e, cnum, chighnum, gamecoinnum = xlDb_Query(sql)
		--print("sql:",sql,e,count)
		if (e == 0) then
			cangbaotuNum = cnum
			cangbaotuHighNum = chighnum
			gamecoinTotalNum = gamecoinnum
		end
		
		strCmd = strCmd .. cangbaotuNum .. ";" .. cangbaotuHighNum .. ";"
		
		--读取宝物表、宝物属性位值表
		local tTreasure = {}
		local tTreasureAttr = {}
		local sql = string.format("SELECT `treasure`, `treasure_attr` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, treasure, treasure_attr = xlDb_Query(sql)
		--print("sql:",sql,e,count)
		if (e == 0) then
			if (type(treasure) == "string") then
				treasure = "{" .. treasure .. "}"
				local tmp = "local prize = " .. treasure .. " return prize"
				--宝物碎片表
				tTreasure = assert(loadstring(tmp))()
			end
			
			if (type(treasure_attr) == "string") then
				treasure_attr = "{" .. treasure_attr .. "}"
				local tmp = "local prize = " .. treasure_attr .. " return prize"
				--宝物属性位表
				tTreasureAttr = assert(loadstring(tmp))()
			end
			
			--累计消耗游戏币，读取t_user表中的值
			tTreasureAttr[hVar.TREASURE_ATTR.CONSUME_GAMECOIN_TOTALNUM] = gamecoinTotalNum
		end
		
		strCmd = strCmd .. #tTreasure .. ";"
		for i = 1, #tTreasure, 1 do
			local id = tTreasure[i][1]
			local lv = tTreasure[i][2]
			local num = tTreasure[i][3]
			local tmp = id .. ":" .. lv .. ":" .. num .. ";"
			strCmd = strCmd .. tmp
		end
		
		strCmd = strCmd .. #tTreasureAttr .. ";"
		for i = 1, #tTreasureAttr, 1 do
			local attr_count = tTreasureAttr[i]
			local tmp = attr_count .. ";"
			strCmd = strCmd .. tmp
		end
		
		return strCmd
	end
	
	--宝物升星
	function Treasure:StarUp(treasureId)
		local ret = 0
		local strCmd = ""
		
		strCmd = strCmd .. treasureId .. ";"
		
		--读取宝物表
		local tTreasure = {}
		local sql = string.format("SELECT `treasure` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, treasure = xlDb_Query(sql)
		--print("sql:",sql,e,count)
		if (e == 0) then
			if (type(treasure) == "string") then
				treasure = "{" .. treasure .. "}"
				local tmp = "local prize = " .. treasure .. " return prize"
				--宝物碎片表
				tTreasure = assert(loadstring(tmp))()
			end
		end
		
		local star = 0 --星级
		local debrisNum = 0 --碎片数量
		
		for i = 1, #tTreasure, 1 do
			local id = tTreasure[i][1]
			local lv = tTreasure[i][2]
			local num = tTreasure[i][3]
			
			if (id == treasureId) then --找到了
				star = lv
				debrisNum = num
				
				break
			end
		end
		
		--升级需要的宝物碎片图标
		local costDebris = 0 --需要的碎片数量
		local nowDebris = debrisNum --当前的碎片数量
		local costScore = 0 --需要的积分
		--local nowScore = LuaGetPlayerScore() --当前的积分
		local itemId = 0 --商品道具id
		
		if (star < hVar.TREASURE_LVUP_INFO.maxTreasureLv) then
			local treasureLvUpInfo = hVar.TREASURE_LVUP_INFO[star]
			costDebris = treasureLvUpInfo.costDebris or 0 --需要的碎片数量
			local shopItemId = treasureLvUpInfo.shopItemId or 0
			local tabShopItem = hVar.tab_shopitem[shopItemId]
			if tabShopItem then
				--costRmb = tabShopItem.rmb or 0
				costScore = tabShopItem.score or 0 --需要的积分
				itemId = tabShopItem.itemID or 0 --商品道具id
			end
		end
		
		if (star < hVar.TREASURE_LVUP_INFO.maxTreasureLv) then
			if (nowDebris >= costDebris) then
				--升星
				local newStar = star + 1
				local newDebris = nowDebris - costDebris
				
				--存档
				for i = 1, #tTreasure, 1 do
					local id = tTreasure[i][1]
					local lv = tTreasure[i][2]
					local num = tTreasure[i][3]
					
					if (id == treasureId) then --找到了
						tTreasure[i][2] = newStar
						tTreasure[i][3] = newDebris
						
						break
					end
				end
				
				--存档
				local saveData = ""
				for k = 1, #tTreasure, 1 do
					local v = tTreasure[k]
					
					saveData = saveData .. "{"
					for i = 1, #v, 1 do
						saveData = saveData .. v[i] .. ","
					end
					saveData = saveData .. "},\n"
				end
				
				--更新
				local sUpdate = string.format("UPDATE `t_cha` SET `treasure` = '%s' where `id` = %d", saveData, self._rid)
				--print("sUpdate1:",sUpdate)
				xlDb_Execute(sUpdate)
				
				--插入订单
				local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
				
				--订单表
				--新的购买记录插入到order表
				sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,self._uid,self._rid,itemId,1,sItemName,0,costScore,tostring(treasureId)..";"..tostring(newStar)..";"..tostring(newDebris)..";"..tostring(costScore)..";")
				--print("sUpdate2:",sUpdate)
				xlDb_Execute(sUpdate)
				
				---------------------------------------------------------------------------------------------------------
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
				---------------------------------------------------------------------------------------------------------
				
				ret = 1 --成功
				
				strCmd = strCmd .. newStar .. ";" .. newDebris .. ";" .. costScore .. ";"
			else
				ret = -2 --碎片不足
			end
		else
			ret = -1 --已到顶星
		end
		
		strCmd = ret .. ";" .. strCmd
		return strCmd
	end
	
	--上传玩家宝物属性位值
	function Treasure:UploadAttr(sessionId, orderId, battleId, mapName, strAttr)
		local ret = 0
		local strCmd = ""
		
		if (sessionId > 0) or (orderId > 0) or (battleId > 0) then
			--检测此条记录是否已上传过
			local sql = string.format("SELECT * FROM `log_treasure_attr_log` WHERE `rid` = %d and `sessionId` = %d and `orderId` = %d and `battleId` = %d", self._rid, sessionId, orderId, battleId)
			local err = xlDb_Query(sql)
			if (err == 0) then
				--已有记录
			else
				--读取玩家的消耗游戏币总数量
				local gamecoinTotalNum = 0
				local sql = string.format("SELECT `gamecoin_totalnum` FROM `t_user` WHERE `uid` = %d", self._uid)
				local e, gamecoinnum = xlDb_Query(sql)
				if (e == 0) then
					gamecoinTotalNum = gamecoinnum
				end
				
				--读取现有属性位值
				local tTreasureAttr = {}
				local sql = string.format("SELECT `treasure_attr` FROM `t_cha` WHERE `id` = %d", self._rid)
				local e, treasure_attr = xlDb_Query(sql)
				--print("sql:",sql,e,count)
				if (e == 0) then
					if (type(treasure_attr) == "string") then
						treasure_attr = "{" .. treasure_attr .. "}"
						local tmp = "local prize = " .. treasure_attr .. " return prize"
						--宝物属性位表
						tTreasureAttr = assert(loadstring(tmp))()
					end
				end
				
				--补齐全部属性位
				for i = 1, hVar.TREASURE_ATTR.ATTR_MAXCOUNT, 1 do
					tTreasureAttr[i] = tTreasureAttr[i] or 0
				end
				
				--相加类型的属性和
				local attrSum = 0
				
				--叠加现有值
				local tAttr = hApi.Split(strAttr, ",")
				for i = 1, hVar.TREASURE_ATTR.ATTR_MAXCOUNT, 1 do
					local attrValue = tonumber(tAttr[i]) or 0 --叠加值
					local attrValueCurrent = tTreasureAttr[i] --现有值
					local increaseType = hVar.TREASURE_ATTR_INCREASE_TYPE_LIST[i] --叠加规则
					
					if (increaseType == hVar.TREASURE_ATTR_INCREASE_TYPE.ADD) then --相加
						tTreasureAttr[i] = attrValueCurrent + attrValue
						
						--相加类型的属性和
						attrSum = attrSum + attrValue
					elseif (increaseType == hVar.TREASURE_ATTR_INCREASE_TYPE.COVER) then --覆盖
						if (attrValue > 0) then
							tTreasureAttr[i] = attrValue
						end
					elseif (increaseType == hVar.TREASURE_ATTR_INCREASE_TYPE.MIN) then --取较小值
						tTreasureAttr[i] = math.min(attrValueCurrent, attrValue)
					elseif (increaseType == hVar.TREASURE_ATTR_INCREASE_TYPE.MAX) then --取较大值
						tTreasureAttr[i] = math.max(attrValueCurrent, attrValue)
					end
				end
				
				--累计消耗游戏币，读取t_user表中的值
				tTreasureAttr[hVar.TREASURE_ATTR.CONSUME_GAMECOIN_TOTALNUM] = gamecoinTotalNum
				
				--转字符串
				local strAttrFinal = ""
				for i = 1, hVar.TREASURE_ATTR.ATTR_MAXCOUNT, 1 do
					strAttrFinal = strAttrFinal .. tTreasureAttr[i] .. ","
				end
				
				--更新宝物属性位值
				local sUpdate = string.format("UPDATE `t_cha` SET `treasure_attr` = '%s' where `id` = %d", strAttrFinal, self._rid)
				--print("sUpdate1:",sUpdate)
				xlDb_Execute(sUpdate)
				
				--插入日志
				local sUpdate2 = string.format("INSERT INTO `log_treasure_attr_log` (`uid`, `rid`, `sessionId`, `orderId`, `battleId`, `mapname`, `attr_before`, `attr`, `attr_sum`, `time`) values (%d, %d, %d, %d, %d, '%s', '%s', '%s', %d, now())", self._uid, self._rid, sessionId, orderId, battleId, mapName, treasure_attr, strAttr, attrSum)
				xlDb_Execute(sUpdate2)
				
				--操作成功
				ret = 1
				
				--返回值
				strCmd = tostring(#tTreasureAttr) .. ";" .. strAttrFinal
			end
		end
		
		strCmd = ret .. ";" .. strCmd
		return strCmd
	end
	
	--叠加宝物锁孔洗炼属性值
	function Treasure:IncreaseXiLianCount(orderId, itemDbid, itemId, lockNum, lockIdDic)
		local ret = 0
		local strCmd = ""
		
		--锁孔洗炼才处理
		if (lockNum > 0) then
			local strCmd = ""
			
			--读取现有属性位值
			local tTreasureAttr = {}
			local sql = string.format("SELECT `treasure_attr` FROM `t_cha` WHERE `id` = %d", self._rid)
			local e, treasure_attr = xlDb_Query(sql)
			--print("sql:",sql,e,count)
			if (e == 0) then
				if (type(treasure_attr) == "string") then
					treasure_attr = "{" .. treasure_attr .. "}"
					local tmp = "local prize = " .. treasure_attr .. " return prize"
					--宝物属性位表
					tTreasureAttr = assert(loadstring(tmp))()
				end
			end
			
			--补齐全部属性位
			for i = 1, hVar.TREASURE_ATTR.ATTR_MAXCOUNT, 1 do
				tTreasureAttr[i] = tTreasureAttr[i] or 0
			end
			
			--叠加锁孔洗炼值
			tTreasureAttr[hVar.TREASURE_ATTR.EQUIP_XILIAN_LOCK] = tTreasureAttr[hVar.TREASURE_ATTR.EQUIP_XILIAN_LOCK] + 1
			
			--转字符串
			local strAttrFinal = ""
			for i = 1, hVar.TREASURE_ATTR.ATTR_MAXCOUNT, 1 do
				strAttrFinal = strAttrFinal .. tTreasureAttr[i] .. ","
			end
			
			--转字符串（本次值）
			local strAttr = ""
			for i = 1, hVar.TREASURE_ATTR.ATTR_MAXCOUNT, 1 do
				if (i == hVar.TREASURE_ATTR.EQUIP_XILIAN_LOCK) then
					strAttr = strAttr .. "1" .. ","
				else
					strAttr = strAttr .. "0" .. ","
				end
			end
			
			--更新宝物属性位值
			local sUpdate = string.format("UPDATE `t_cha` SET `treasure_attr` = '%s' where `id` = %d", strAttrFinal, self._rid)
			--print("sUpdate1:",sUpdate)
			xlDb_Execute(sUpdate)
			
			--插入日志
			local sessionId = 0
			local battleId = 0
			local mapName = hVar.tab_string["__TEXT_SLOT_XILIAN"] --"锁孔洗炼"
			local attrSum = 1
			local sUpdate2 = string.format("INSERT INTO `log_treasure_attr_log` (`uid`, `rid`, `sessionId`, `orderId`, `battleId`, `mapname`, `attr_before`, `attr`, `attr_sum`, `time`) values (%d, %d, %d, %d, %d, '%s', '%s', '%s', %d, now())", self._uid, self._rid, sessionId, orderId, battleId, mapName, treasure_attr, strAttr, attrSum)
			xlDb_Execute(sUpdate2)
			
			--操作成功
			ret = 1
			
			--返回值
			strCmd = tostring(#tTreasureAttr) .. ";" .. strAttrFinal
			
			--发送客户端
			--xlSendScript2Client(self._uid, hVar.DB_RECV_TYPE.L2C_UPLOAD_TREASURE_ATTR_INFO, strCmd)
		end
		
		strCmd = ret .. ";" .. strCmd
		return strCmd
	end
	
	--叠加宝物4孔坐骑属性值
	function Treasure:IncreaseMountCount(itemDbid, itemId, slotnum, strattr)
		--print(itemDbid, itemId, slotnum, strattr)
		local ret = 0
		local strCmd = ""
		
		--4孔才处理
		if (slotnum == 4) then
			local tabI = hVar.tab_item[itemId]
			if tabI then
				if (tabI.type == hVar.ITEM_TYPE.MOUNT) then --坐骑
					local strCmd = ""
					
					--读取现有属性位值
					local tTreasureAttr = {}
					local sql = string.format("SELECT `treasure_attr` FROM `t_cha` WHERE `id` = %d", self._rid)
					local e, treasure_attr = xlDb_Query(sql)
					--print("sql:",sql,e,count)
					if (e == 0) then
						if (type(treasure_attr) == "string") then
							treasure_attr = "{" .. treasure_attr .. "}"
							local tmp = "local prize = " .. treasure_attr .. " return prize"
							--宝物属性位表
							tTreasureAttr = assert(loadstring(tmp))()
						end
					end
					
					--补齐全部属性位
					for i = 1, hVar.TREASURE_ATTR.ATTR_MAXCOUNT, 1 do
						tTreasureAttr[i] = tTreasureAttr[i] or 0
					end
					
					--叠加4孔坐骑值
					tTreasureAttr[hVar.TREASURE_ATTR.EQUIP_COUNT_MOUNT_SLOT4] = tTreasureAttr[hVar.TREASURE_ATTR.EQUIP_COUNT_MOUNT_SLOT4] + 1
					
					--转字符串
					local strAttrFinal = ""
					for i = 1, hVar.TREASURE_ATTR.ATTR_MAXCOUNT, 1 do
						strAttrFinal = strAttrFinal .. tTreasureAttr[i] .. ","
					end
					
					--转字符串（本次值）
					local strAttr = ""
					for i = 1, hVar.TREASURE_ATTR.ATTR_MAXCOUNT, 1 do
						if (i == hVar.TREASURE_ATTR.EQUIP_COUNT_MOUNT_SLOT4) then
							strAttr = strAttr .. "1" .. ","
						else
							strAttr = strAttr .. "0" .. ","
						end
					end
					
					--更新宝物属性位值
					--print(strAttrFinal)
					local sUpdate = string.format("UPDATE `t_cha` SET `treasure_attr` = '%s' where `id` = %d", strAttrFinal, self._rid)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
					
					--订单表
					--新的购买记录插入到order表
					local sItemName = hVar.tab_string["__TEXT_SLOT4_MOUNT"] --"4孔坐骑"
					sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,self._uid,self._rid,9004,1,sItemName,0,0,sItemName)
					--print("sUpdate2:",sUpdate)
					xlDb_Execute(sUpdate)
					
					local orderId = 0
					local err1, oId = xlDb_Query("select last_insert_id()")
					--print("err1,orderId:",err1,oId)
					if err1 == 0 then
						orderId = oId
					end
					
					--print(orderId)
					
					--插入日志
					local sessionId = 0
					local battleId = 0
					local mapName = hVar.tab_string["__TEXT_SLOT4_MOUNT"] --"4孔坐骑"
					local attrSum = 1
					local sUpdate2 = string.format("INSERT INTO `log_treasure_attr_log` (`uid`, `rid`, `sessionId`, `orderId`, `battleId`, `mapname`, `attr_before`, `attr`, `attr_sum`, `time`) values (%d, %d, %d, %d, %d, '%s', '%s', '%s', %d, now())", self._uid, self._rid, sessionId, orderId, battleId, mapName, treasure_attr, strAttr, attrSum)
					xlDb_Execute(sUpdate2)
					
					--操作成功
					ret = 1
					
					--返回值
					strCmd = tostring(#tTreasureAttr) .. ";" .. strAttrFinal
					
					--发送客户端
					--xlSendScript2Client(self._uid, hVar.DB_RECV_TYPE.L2C_UPLOAD_TREASURE_ATTR_INFO, strCmd)
				end
			end
		end
		
		strCmd = ret .. ";" .. strCmd
		return strCmd
	end
	
	--叠加宝物合成3孔红装次数属性值
	function Treasure:IncreaseMerge3SlotCount(itemDbid, itemId, slotnum, orderId)
		--print(itemDbid, itemId, slotnum, strattr)
		local ret = 0
		local strCmd = ""
		
		--3孔及以上才处理
		if (slotnum >= 3) then
			local tabI = hVar.tab_item[itemId]
			if tabI then
				
				local strCmd = ""
				
				--读取现有属性位值
				local tTreasureAttr = {}
				local sql = string.format("SELECT `treasure_attr` FROM `t_cha` WHERE `id` = %d", self._rid)
				local e, treasure_attr = xlDb_Query(sql)
				--print("sql:",sql,e,count)
				if (e == 0) then
					if (type(treasure_attr) == "string") then
						treasure_attr = "{" .. treasure_attr .. "}"
						local tmp = "local prize = " .. treasure_attr .. " return prize"
						--宝物属性位表
						tTreasureAttr = assert(loadstring(tmp))()
					end
				end
				
				--补齐全部属性位
				for i = 1, hVar.TREASURE_ATTR.ATTR_MAXCOUNT, 1 do
					tTreasureAttr[i] = tTreasureAttr[i] or 0
				end
				
				--叠加合成3孔红装次数值
				tTreasureAttr[hVar.TREASURE_ATTR.REDEQUIP_MERGE_SLOT3_COUNT] = tTreasureAttr[hVar.TREASURE_ATTR.REDEQUIP_MERGE_SLOT3_COUNT] + 1
				
				--转字符串
				local strAttrFinal = ""
				for i = 1, hVar.TREASURE_ATTR.ATTR_MAXCOUNT, 1 do
					strAttrFinal = strAttrFinal .. tTreasureAttr[i] .. ","
				end
				
				--转字符串（本次值）
				local strAttr = ""
				for i = 1, hVar.TREASURE_ATTR.ATTR_MAXCOUNT, 1 do
					if (i == hVar.TREASURE_ATTR.REDEQUIP_MERGE_SLOT3_COUNT) then
						strAttr = strAttr .. "1" .. ","
					else
						strAttr = strAttr .. "0" .. ","
					end
				end
				
				--更新宝物属性位值
				--print(strAttrFinal)
				local sUpdate = string.format("UPDATE `t_cha` SET `treasure_attr` = '%s' where `id` = %d", strAttrFinal, self._rid)
				--print("sUpdate1:",sUpdate)
				xlDb_Execute(sUpdate)
				
				--print(orderId)
				
				--插入日志
				local sessionId = 0
				local battleId = 0
				local mapName = hVar.tab_string["__TEXT_MERGE_SLOT3"] --"献祭3孔红装"
				local attrSum = 1
				local sUpdate2 = string.format("INSERT INTO `log_treasure_attr_log` (`uid`, `rid`, `sessionId`, `orderId`, `battleId`, `mapname`, `attr_before`, `attr`, `attr_sum`, `time`) values (%d, %d, %d, %d, %d, '%s', '%s', '%s', %d, now())", self._uid, self._rid, sessionId, orderId, battleId, mapName, treasure_attr, strAttr, attrSum)
				xlDb_Execute(sUpdate2)
				
				--操作成功
				ret = 1
				
				--返回值
				strCmd = tostring(#tTreasureAttr) .. ";" .. strAttrFinal
				
				--发送客户端
				--xlSendScript2Client(self._uid, hVar.DB_RECV_TYPE.L2C_UPLOAD_TREASURE_ATTR_INFO, strCmd)
			end
		end
		
		strCmd = ret .. ";" .. strCmd
		return strCmd
	end
	
return Treasure