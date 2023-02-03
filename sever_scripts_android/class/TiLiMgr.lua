--体力管理类
local TiLiMgr = class("TiLiMgr")
	
	--每日体力自动补给的时间
	TiLiMgr.DAILY_SUPPLY_TIME = "05:00:00"
	
	--每日体力自动发邮件的时间
	TiLiMgr.DAILY_SYSTEM_MAIL_TIME =
	{
		{time = "12:00:00",},
	}
	
	--宠物每小时掉落氪石数量
	--TiLiMgr.PET_HOUR_KESHI_NUM = 1
	
	--宠物氪石积攒上限（小时）
	TiLiMgr.PET_HOUR_KESHI_TAKEREWARD_MAXHOUR = 24
	
	--宠物每小时掉落体力数量
	--TiLiMgr.PET_HOUR_TILI_NUM = 1
	
	--宠物体力积攒上限（小时）
	TiLiMgr.PET_HOUR_TILI_TAKEREWARD_MAXHOUR = 24
	
	--宠物宝箱积攒上限（小时）
	TiLiMgr.PET_HOUR_CHEST_TAKEREWARD_MAXHOUR = 24
	
	--兑换体力的商品id
	TiLiMgr.EXCHANGE_TILI_SHOPITEM_ID = 645
	
	--领取挖矿氪石的商品id
	TiLiMgr.TAKEREWARD_KESHI_SHOPITEM_ID = 646
	
	--领取挖矿体力的商品id
	TiLiMgr.TAKEREWARD_TILI_SHOPITEM_ID = 647
	
	--领取挖矿宝箱的商品id
	TiLiMgr.TAKEREWARD_CHEST_SHOPITEM_ID = 650
	
	--领取挖矿宝箱的奖励宝箱id
	TiLiMgr.TAKEREWARD_CHEST_REWARD_CHEST_ID = 9926
	
	--构造函数
	function TiLiMgr:ctor()
		self._uid = -1
		self._rid = -1
		
		--其他
		self._statisticsTime = -1	--统计计时
		self._statisticsTimestamp = -1	--上次统计时间
		
		return self
	end
	
	--初始化函数
	function TiLiMgr:Init(uid, rid)
		self._uid = uid
		self._rid = rid
		
		--其他
		self._statisticsTime = hApi.GetClock()	--统计计时
		self._statisticsTimestamp = os.time()	--上次统计时间
		
		return self
	end
	
	--release
	function TiLiMgr:Release()
		self._uid = -1
		self._rid = -1
		
		--其他
		self._statisticsTime = -1	--统计计时
		self._statisticsTimestamp = -1	--上次统计时间
		
		return self
	end
	
	--查询玩家体力信息
	function TiLiMgr:QueryInfo()
		local strCmd = ""
		
		--今日时间戳
		local nTimestampNow = os.time()
		--print("nTimestampNow=", nTimestampNow)
		
		--读取体力数据
		local pvpcoin = 0
		local pvpcoin_buy_count = 0
		local vipLv = hGlobal.vipMgr:DBGetUserVip(self._uid) --玩家vip等级
		local tiliDailyBuyCount = hVar.Vip_Conifg.tiliDailyBuyCount[vipLv] or 0 --每日体力购买次数上限
		local tiliDailyMax = hVar.Vip_Conifg.tiliDailyMax[vipLv] or 0 --体力上限
		local tiliDailySupply = hVar.Vip_Conifg.tiliDailySupply[vipLv] or 0 --每日补给
		local sQuery = string.format("SELECT `pvpcoin`, `pvpcoin_buy_count`, `last_pvpcoin_buy_time`, `last_pvpcoin_supply_time` FROM `t_user` WHERE `uid` = %d", self._uid)
		local err, coin, buy_count, last_buy_time, last_pvpcoin_supply_time = xlDb_Query(sQuery)
		if (err == 0) then --查询成功
			pvpcoin = coin
			pvpcoin_buy_count = buy_count
			
			--转化为服务器上次操作时间的0点天的时间戳
			local nTimestampBuy = hApi.GetNewDate(last_buy_time)
			local strDatestampBuyYMD = hApi.Timestamp2Date(nTimestampBuy) --转字符串(年月日)
			local strNewdateBuy = strDatestampBuyYMD .. " 00:00:00"
			local nTimestampBuyTodayZero = hApi.GetNewDate(strNewdateBuy, "DAY", 1) -- +1天
			--print("strNewdateBuy=", strNewdateBuy)
			--print("nTimestampTodayZero=", nTimestampTodayZero)
			--print("nTimestampNow=", nTimestampNow)
			--到了第二天
			if (nTimestampNow >= nTimestampBuyTodayZero) then
				--print("到了第二天")
				pvpcoin_buy_count = 0
			end
			
			--检测自动补给
			local nTimestampSupply = hApi.GetNewDate(last_pvpcoin_supply_time)
			local strDatestampSppplyYMD = hApi.Timestamp2Date(nTimestampSupply) --转字符串(年月日)
			local strNewdateSupply = strDatestampSppplyYMD .. " " .. TiLiMgr.DAILY_SUPPLY_TIME
			local nTimestampSupplyTodayTime = hApi.GetNewDate(strNewdateSupply, "DAY", 1) -- +1天
			--到了第二天
			--print(nTimestampNow)
			--print(nTimestampSupplyTodayTime)
			if (nTimestampNow >= nTimestampSupplyTodayTime) then
				--补给值
				--local tiliDailySupply = hVar.Vip_Conifg.tiliDailySupply[vipLv] or 0
				if (pvpcoin < tiliDailySupply) then
					pvpcoin = tiliDailySupply
					
					--更新补给
					local sUpdate = string.format("UPDATE `t_user` SET `pvpcoin` = %d, `last_pvpcoin_supply_time` = NOW() WHERE `uid` = %d", pvpcoin, self._uid)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
				else
					--只更新补给日期
					local sUpdate = string.format("UPDATE `t_user` SET `last_pvpcoin_supply_time` = NOW() WHERE `uid` = %d", self._uid)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
				end
			end
		end
		
		--读取挖矿收益
		local wakuangNum = 0 --挖矿宠物数量
		local watiliNum = 0 --挖体力宠物数量
		local export_keshi = 0
		local export_tili = 0
		local export_chest = 0
		
		local dailyKeShiExport = 0 --每日氪石产出
		local dailyTiLiExport = 0 --每日体力产出
		local dailyChestExport = 0 --每日宝箱产出
		
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
			
			if (wakuang == 1) then --在挖矿中
				wakuangNum = wakuangNum + 1
				
				--计算当前已累计的氪石收益
				local lasttime = sendtime
				if (lastexporttime_wakuang > sendtime) then
					lasttime = lastexporttime_wakuang
				end
				local deltatime = nTimestampNow - lasttime
				local exportHour = math.floor(deltatime / 3600)
				if (exportHour > TiLiMgr.PET_HOUR_KESHI_TAKEREWARD_MAXHOUR) then
					exportHour = TiLiMgr.PET_HOUR_KESHI_TAKEREWARD_MAXHOUR
				end
				
				--该宠物挖氪石产出
				local PET_HOUR_KESHI_NUM = 1 / hVar.PET_WAKUANG_INFO[star_i].wakuangRequireHour --挖矿速度（每小时）
				local export = math.floor(exportHour * PET_HOUR_KESHI_NUM)
				export_keshi = export_keshi + export
				
				--统计每日氪石产出
				dailyKeShiExport = dailyKeShiExport + math.floor(24 * PET_HOUR_KESHI_NUM)
				
				--计算当前已累计的宝箱收益
				local lasttime = sendtime
				if (lastexporttime_wachest > sendtime) then
					lasttime = lastexporttime_wachest
				end
				local deltatime = nTimestampNow - lasttime
				local exportHour = math.floor(deltatime / 3600)
				if (exportHour > TiLiMgr.PET_HOUR_CHEST_TAKEREWARD_MAXHOUR) then
					exportHour = TiLiMgr.PET_HOUR_CHEST_TAKEREWARD_MAXHOUR
				end
				
				--该宠物挖宝箱产出
				local PET_HOUR_CHEST_NUM = 1 / hVar.PET_WAKUANG_INFO[star_i].wachestRequireHour --挖宝箱速度（每小时）
				local export = math.floor(exportHour * PET_HOUR_CHEST_NUM)
				export_chest = export_chest + export
				
				--统计每日宝箱产出
				dailyChestExport = dailyChestExport + math.floor(24 * PET_HOUR_CHEST_NUM)
				
			elseif (watili == 1) then --在挖体力中
				watiliNum = watiliNum + 1
				
				--计算当前已累计的体力收益
				local lasttime = sendtime
				if (lastexporttime_watili > sendtime) then
					lasttime = lastexporttime_watili
				end
				local deltatime = nTimestampNow - lasttime
				local exportHour = math.floor(deltatime / 3600)
				if (exportHour > TiLiMgr.PET_HOUR_TILI_TAKEREWARD_MAXHOUR) then
					exportHour = TiLiMgr.PET_HOUR_TILI_TAKEREWARD_MAXHOUR
				end
				
				--该宠物挖体力产出
				local PET_HOUR_TILI_NUM = 1 / hVar.PET_WAKUANG_INFO[star_i].watiliRequireHour --挖体力速度（每小时）
				local export = math.floor(exportHour * PET_HOUR_TILI_NUM)
				export_tili = export_tili + export
				
				--统计每日体力产出
				dailyTiLiExport = dailyTiLiExport + math.floor(24 * PET_HOUR_TILI_NUM)
				
				--计算当前已累计的宝箱收益
				local lasttime = sendtime
				if (lastexporttime_wachest > sendtime) then
					lasttime = lastexporttime_wachest
				end
				local deltatime = nTimestampNow - lasttime
				local exportHour = math.floor(deltatime / 3600)
				if (exportHour > TiLiMgr.PET_HOUR_CHEST_TAKEREWARD_MAXHOUR) then
					exportHour = TiLiMgr.PET_HOUR_CHEST_TAKEREWARD_MAXHOUR
				end
				
				--该宠物挖宝箱产出
				local PET_HOUR_CHEST_NUM = 1 / hVar.PET_WAKUANG_INFO[star_i].wachestRequireHour --挖宝箱速度（每小时）
				local export = math.floor(exportHour * PET_HOUR_CHEST_NUM)
				export_chest = export_chest + export
				
				--统计每日宝箱产出
				dailyChestExport = dailyChestExport + math.floor(24 * PET_HOUR_CHEST_NUM)
			end
		end
		
		--local dailyKeShiExport = wakuangNum * TiLiMgr.PET_HOUR_KESHI_NUM * 24 --每日氪石产出
		--local dailyTiLiExport = watiliNum * TiLiMgr.PET_HOUR_TILI_NUM * 24 --每日体力产出
		
		strCmd = tostring(tiliDailyMax) .. ";" .. tostring(pvpcoin) .. ";" .. tostring(tiliDailyBuyCount) .. ";" .. tostring(pvpcoin_buy_count) .. ";" .. tostring(tiliDailySupply) .. ";"
			 .. tostring(dailyKeShiExport) .. ";" .. tostring(dailyTiLiExport) .. ";" .. tostring(dailyChestExport) .. ";" ..tostring(export_keshi) .. ";" .. tostring(export_tili) .. ";"
			 .. tostring(export_chest) .. ";"
		
		return strCmd, tiliDailyMax, pvpcoin, tiliDailyBuyCount, pvpcoin_buy_count, tiliDailySupply, dailyKeShiExport, dailyTiLiExport, dailyChestExport, export_keshi, export_tili, export_chest
	end
	
	--兑换体力
	function TiLiMgr:ExchangeTiLi()
		local ret = 0
		local strCmd = ""
		
		--查询玩家体力信息
		local strCmd, tiliDailyMax, pvpcoin, tiliDailyBuyCount, pvpcoin_buy_count, tiliDailySupply, dailyKeShiExport, dailyTiLiExport, dailyChestExport, export_keshi, export_tili, export_chest = self:QueryInfo()
		
		local tabShopItem = hVar.tab_shopitem[TiLiMgr.EXCHANGE_TILI_SHOPITEM_ID]
		local coseRmb = tabShopItem.rmb or 0 --需要的游戏币
		local itemId = tabShopItem.itemID or 0 --商品道具id
		local tiliAdd = tabShopItem.tili or 0 --增加的体力
		
		--检测今日剩余购买是否足够
		local leftcount = tiliDailyBuyCount - pvpcoin_buy_count
		if (leftcount > 0) then
			--扣除游戏币
			local bSuccess, order_id = hGlobal.userCoinMgr:DBUserPurchase(self._uid,self._rid, itemId, 1, coseRmb, 0)
			if bSuccess then
				--更新数据
				local sUpdate = string.format("UPDATE `t_user` SET `pvpcoin` = `pvpcoin` + %d, `pvpcoin_buy_count` = %d, `last_pvpcoin_buy_time` = NOW() WHERE `uid` = %d", tiliAdd, pvpcoin_buy_count + 1, self._uid)
				--print("sUpdate1:",sUpdate)
				xlDb_Execute(sUpdate)
				
				--操作成功
				ret = 1
			else
				ret = -1 --游戏币不足
			end
		else
			ret = -2 --今日队兑换次数已用完
		end
		
		strCmd = tostring(ret) .. ";"
		return strCmd
	end
	
	--领取挖矿氪石
	function TiLiMgr:TakeRewardKeShi()
		local ret = 0
		local nTakeRewardKeShiNum = 0
		local strCmd = ""
		
		--查询玩家体力信息
		local strCmd, tiliDailyMax, pvpcoin, tiliDailyBuyCount, pvpcoin_buy_count, tiliDailySupply, dailyKeShiExport, dailyTiLiExport, dailyChestExport, export_keshi, export_tili, export_chest = self:QueryInfo()
		
		--有氪石领取
		if (export_keshi > 0) then
			local tabShopItem = hVar.tab_shopitem[TiLiMgr.TAKEREWARD_KESHI_SHOPITEM_ID]
			local itemId = tabShopItem.itemID or 0 --商品道具id
			
			nTakeRewardKeShiNum = export_keshi
			
			--插入订单
			hGlobal.userCoinMgr:DBUserPurchase(self._uid,self._rid, itemId, 1, 0, 0)
			
			--增加游戏币
			hGlobal.userCoinMgr:DBAddGamecoin(self._uid, export_keshi)
			
			--标记全部在挖矿氪石的宠物领取时间
			--今日时间戳
			local nTimestampNow = os.time()
			
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
				
				if (wakuang == 1) then --在挖矿中
					tPet[i][8] = nTimestampNow
				end
			end
			
			--存档
			local saveData = ""
			for k = 1, #tPet, 1 do
				local v = tPet[k]
				
				saveData = saveData .. "{"
				for i = 1, #v, 1 do
					saveData = saveData .. (tonumber(v[i]) or 0) .. ","
				end
				saveData = saveData .. "},\n"
			end
			--更新
			local sUpdate = string.format("UPDATE `t_cha` SET `inventoryInfo` = '%s' where `id` = %d", saveData, self._rid)
			--print("sUpdate1:",sUpdate)
			xlDb_Execute(sUpdate)
			
			--操作成功
			ret = 1
		else
			ret = -1 --无氪石可领取
		end
		
		strCmd = tostring(ret) .. ";" .. tostring(nTakeRewardKeShiNum) .. ";"
		return strCmd
	end
	
	--领取挖矿体力
	function TiLiMgr:TakeRewardTiLi()
		local ret = 0
		local nTakeRewardTiLiNum = 0
		local strCmd = ""
		
		--查询玩家体力信息
		local strCmd, tiliDailyMax, pvpcoin, tiliDailyBuyCount, pvpcoin_buy_count, tiliDailySupply, dailyKeShiExport, dailyTiLiExport, dailyChestExport, export_keshi, export_tili, export_chest = self:QueryInfo()
		
		local tabShopItem = hVar.tab_shopitem[TiLiMgr.TAKEREWARD_TILI_SHOPITEM_ID]
		local itemId = tabShopItem.itemID or 0 --商品道具id
		
		--有体力领取
		if (export_tili > 0) then
			--当前体力未超上限
			if (pvpcoin < tiliDailyMax) then
				--如果领取后体力超上限，那么多出的就浪费掉了
				if ((pvpcoin + export_tili) > tiliDailyMax) then
					export_tili = tiliDailyMax - pvpcoin
				end
				
				local tabShopItem = hVar.tab_shopitem[TiLiMgr.TAKEREWARD_KESHI_SHOPITEM_ID]
				local itemId = tabShopItem.itemID or 0 --商品道具id
				
				nTakeRewardTiLiNum = export_tili
				
				--插入订单
				hGlobal.userCoinMgr:DBUserPurchase(self._uid,self._rid, itemId, 1, 0, 0)
				
				--增加体力
				local sUpdate = string.format("UPDATE `t_user` SET `pvpcoin` = `pvpcoin` + %d where `uid` = %d", export_tili, self._uid)
				--print("sUpdate1:",sUpdate)
				xlDb_Execute(sUpdate)
				
				--标记全部在挖矿氪石的宠物领取时间
				--今日时间戳
				local nTimestampNow = os.time()
				
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
					
					if (watili == 1) then --在挖体力中
						tPet[i][9] = nTimestampNow
					end
				end
				
				--存档
				local saveData = ""
				for k = 1, #tPet, 1 do
					local v = tPet[k]
					
					saveData = saveData .. "{"
					for i = 1, #v, 1 do
						saveData = saveData .. (tonumber(v[i]) or 0) .. ","
					end
					saveData = saveData .. "},\n"
				end
				--更新
				local sUpdate = string.format("UPDATE `t_cha` SET `inventoryInfo` = '%s' where `id` = %d", saveData, self._rid)
				--print("sUpdate1:",sUpdate)
				xlDb_Execute(sUpdate)
				
				--操作成功
				ret = 1
			else
				ret = -2 --体力超上限不能领取
			end
		else
			ret = -1 --无体力可领取
		end
		
		strCmd = tostring(ret) .. ";" .. tostring(nTakeRewardTiLiNum) .. ";"
		return strCmd
	end
	
	--领取挖矿宝箱
	function TiLiMgr:TakeRewardChest()
		local ret = 0
		local nTakeRewardChestNum = 0
		local prizeId = 0
		local prizeType = 0
		local prizeContent = ""
		local strCmd = ""
		
		--查询玩家体力信息
		local strCmd, tiliDailyMax, pvpcoin, tiliDailyBuyCount, pvpcoin_buy_count, tiliDailySupply, dailyKeShiExport, dailyTiLiExport, dailyChestExport, export_keshi, export_tili, export_chest = self:QueryInfo()
		
		local tabShopItem = hVar.tab_shopitem[TiLiMgr.TAKEREWARD_CHEST_SHOPITEM_ID]
		local itemId = tabShopItem.itemID or 0 --商品道具id
		
		--有宝箱领取
		if (export_chest > 0) then
			local tabShopItem = hVar.tab_shopitem[TiLiMgr.TAKEREWARD_KESHI_SHOPITEM_ID]
			local itemId = tabShopItem.itemID or 0 --商品道具id
			
			nTakeRewardChestNum = export_chest
			
			--插入订单
			hGlobal.userCoinMgr:DBUserPurchase(self._uid,self._rid, itemId, 1, 0, 0)
			
			--发奖
			--插入奖励
			local id = 20032
			local detail = "Pet Chest Reward;15:" .. TiLiMgr.TAKEREWARD_CHEST_REWARD_CHEST_ID .. ":" .. export_chest .. ":0;"
			local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",self._uid,id,detail,0,0)
			xlDb_Execute(sInsert)
			
			--奖励id
			local err1, pid = xlDb_Query("select last_insert_id()")
			if (err1 == 0) then
				--存储奖励信息
				prizeId = pid --奖励id
				prizeType = id --奖励类型
				--prizeContent = detail --奖励内容
				
				--服务器发奖
				--预处理，如果是直接开锦囊的奖励，调用不同的接口
				local fromIdx = 2
				--prizeContent = hApi.GetRewardInPrize(self._uid, self._rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
				prizeContent = hApi.GetRewardInPrize_OpenChest(self._uid, self._rid, prizeId, fromIdx, nil)
				
				--sCmd = tostring(prizeId).. ";" .. tostring(rewardNum or maxReward) .. ";" .. sCmd
			end
			
			--标记全部在挖矿氪石的宠物领取时间
			--今日时间戳
			local nTimestampNow = os.time()
			
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
				
				if (wakuang == 1) or (watili == 1) then --在挖矿，或者挖体力中
					tPet[i][10] = nTimestampNow
				end
			end
			
			--存档
			local saveData = ""
			for k = 1, #tPet, 1 do
				local v = tPet[k]
				
				saveData = saveData .. "{"
				for i = 1, #v, 1 do
					saveData = saveData .. (tonumber(v[i]) or 0) .. ","
				end
				saveData = saveData .. "},\n"
			end
			--更新
			local sUpdate = string.format("UPDATE `t_cha` SET `inventoryInfo` = '%s' where `id` = %d", saveData, self._rid)
			--print("sUpdate1:",sUpdate)
			xlDb_Execute(sUpdate)
			
			--操作成功
			ret = 1
		else
			ret = -1 --无宝箱可领取
		end
		
		strCmd = tostring(ret) .. ";" .. tostring(nTakeRewardChestNum) .. ";" .. tostring(prizeType) .. ";" .. tostring(prizeContent)
		return strCmd
	end
	
	--聊天更新(1秒)
	function TiLiMgr:Update()
		local self = hGlobal.tiliMgr --self
		
		--输出信息
		local timeNow = hApi.GetClock()
		if (self._statisticsTime > -1) and (timeNow - self._statisticsTime > 1000) then
			local lasttimestamp = self._statisticsTimestamp
			local currenttimestamp = os.time()
			
			self._statisticsTime = timeNow
			self._statisticsTimestamp = currenttimestamp
			
			--检测是否发送系统消息（每日）
			local sDate = os.date("%Y-%m-%d", currenttimestamp)
			for i = 1, #TiLiMgr.DAILY_SYSTEM_MAIL_TIME, 1 do
				local sRefreshTime = TiLiMgr.DAILY_SYSTEM_MAIL_TIME[i].time
				local refresh_time = sDate .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					--print("ok")
					--发邮件
					--取今日的0点
					local strDatestampYMD = hApi.Timestamp2Date(currenttimestamp) --转字符串(年月日)
					local strNewdate = strDatestampYMD .. " 00:00:00"
					local nTimestampZeroB3 = hApi.GetNewDate(strNewdate, "DAY", -3) --近3日登陆过的
					local sDateZeroB3 = os.date("%Y-%m-%d %H:%M:%S", nTimestampZeroB3)
					
					local sQueryM = string.format("SELECT `uid`, `customS1` FROM `t_user` WHERE `last_login_time` >= '%s' ORDER BY `uid` ASC", sDateZeroB3)
					local errM, tTemp = xlDb_QueryEx(sQueryM)
					--print(sQueryM)
					--print("从数据库读取最近1小时内的全部组队聊天记录:", "errM=", errM, "tTemp=", #tTemp)
					if (errM == 0) then
						for n = 1, #tTemp, 1 do
							local uid = tTemp[n][1]
							local name = tTemp[n][2]
							--print(uid, name)
							local prizeType2 = 20040 --体力带有标题和正文的奖励
							local detail2 = string.format(hVar.tab_string["__TEXT_MAIL_TILI_AUTOSEND"], name)
							local sCreateTime = strDatestampYMD .. " 04:50:00"
							--发奖
							local sInsert = string.format("insert into `prize`(`uid`, `type`, `mykey`, `used`, `create_time`, `create_id`, `days`) values (%d, %d, '%s', %d, '%s', %d, %d)", uid, prizeType2, detail2, 0, sCreateTime, 0, 1)
							xlDb_Execute(sInsert)
						end
					end
				end
			end
		end
	end
	
return TiLiMgr