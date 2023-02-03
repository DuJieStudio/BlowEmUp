--用户货币管理类
local UserCoinMgr = class("UserCoinMgr")
	
	
	--构造函数
	function UserCoinMgr:ctor()
		--其他
		return self
	end
	--初始化函数
	--function UserCoinMgr:Init()
	--	return self
	--end

	--增加游戏币
	function UserCoinMgr:DBAddGamecoin(dbid, addGold)
		
		local gold = addGold
		
		--gm内部人员才能一次性加大于2500游戏币
		if (gold > hVar.ROLE_GAMECOIN_ADD_MAXNUM) then
			local IsGMInternal = hClass.User:IsGMInternal(dbid)
			if (IsGMInternal == 0) then
				gold = hVar.ROLE_GAMECOIN_ADD_MAXNUM
			end
		end 
		
		if gold > 0 then
			--
			local sUpdate = string.format("UPDATE `t_user` SET `gamecoin_online` = `gamecoin_online` + %d WHERE uid = %d",gold,dbid)
			xlDb_Execute(sUpdate)
			
			--add log
			local sLog = string.format("insert into `prize` (uid,type, mykey, used) values (%d,%d,%d,%d)",dbid,400,gold,2)
			xlDb_Execute(sLog)
		elseif gold < 0 then
			--扣除金币，不记录进prize，会在扣之前走order
			--统计游戏币累加值
			local sUpdate = string.format("UPDATE t_user SET gamecoin_online = gamecoin_online + %d, `gamecoin_totalnum` = `gamecoin_totalnum` + %d WHERE uid = %d",gold,-gold,dbid)
			xlDb_Execute(sUpdate)
		end
	end

	--增加游戏币
	function UserCoinMgr:DBAddCrystal(dbid, addCrystal)

		local crystal = math.min(2000, (addCrystal or 0))

		if crystal > 0 then
			--
			local sUpdate = string.format("UPDATE t_user SET equip_crystal = equip_crystal + %d WHERE uid = %d",crystal,dbid)
			xlDb_Execute(sUpdate)

		elseif crystal < 0 then
			--扣除金币，不记录进prize，会在扣之前走order
			local sUpdate = string.format("UPDATE t_user SET equip_crystal = equip_crystal + %d WHERE uid = %d",crystal,dbid)
			xlDb_Execute(sUpdate)
		end
	end
	
	--增加藏宝图
	function UserCoinMgr:DBAddCangBaoTu(dbid, addCangBaoTu)
		
		local cangbaotu = math.min(2000, (addCangBaoTu or 0))
		
		if cangbaotu > 0 then
			--
			local sUpdate = string.format("UPDATE `t_user` SET `cangbaotu` = `cangbaotu` + %d WHERE `uid` = %d", cangbaotu, dbid)
			xlDb_Execute(sUpdate)
			
		elseif cangbaotu < 0 then
			--扣除金币，不记录进prize，会在扣之前走order
			local sUpdate = string.format("UPDATE `t_user` SET `cangbaotu` = `cangbaotu` + %d WHERE `uid` = %d", cangbaotu, dbid)
			xlDb_Execute(sUpdate)
		end
	end
	
	--增加高级藏宝图
	function UserCoinMgr:DBAddCangBaoTuHigh(dbid, addCangBaoTuHigh)
		
		local cangbaotu_high = math.min(2000, (addCangBaoTuHigh or 0))
		
		if cangbaotu_high > 0 then
			--
			local sUpdate = string.format("UPDATE `t_user` SET `cangbaotu_high` = `cangbaotu_high` + %d WHERE `uid` = %d", cangbaotu_high, dbid)
			xlDb_Execute(sUpdate)
			
		elseif cangbaotu_high < 0 then
			--扣除金币，不记录进prize，会在扣之前走order
			local sUpdate = string.format("UPDATE `t_user` SET `cangbaotu_high` = `cangbaotu_high` + %d WHERE `uid` = %d", cangbaotu_high, dbid)
			xlDb_Execute(sUpdate)
		end
	end
	
	--增加兵符
	function UserCoinMgr:DBAddPvpCoin(dbid, addPvpCoin, strInfo)
		
		local pvpcoin = math.min(2000, (addPvpCoin or 0))
		
		if pvpcoin > 0 then
			--
			local sUpdate = string.format("UPDATE `t_user` SET `pvpcoin` = `pvpcoin` + %d WHERE `uid` = %d", pvpcoin, dbid)
			xlDb_Execute(sUpdate)
			
			--插入订单，邮件领取兵符
			local iItemId = 20035
			local sItemName = hVar.tab_stringI[iItemId]
			if (strInfo ~= nil) then
				sItemName = strInfo
			end
			local sExt01 = "" --tostring(pvpNow)
			local sSql = string.format("INSERT INTO `order` (`type`, uid, rid, itemid, itemnum, coin, itemname, ext_01) VALUES (%d, %d, %d, %d, %d, %d, '%s', '%s')",21,dbid,0,iItemId,addPvpCoin,0,sItemName,sExt01)
			--print(sSql)
			xlDb_Execute(sSql)
		elseif pvpcoin < 0 then
			--扣除金币，不记录进prize，会在扣之前走order
			local sUpdate = string.format("UPDATE `t_user` SET `pvpcoin` = `pvpcoin` + %d WHERE `uid` = %d", pvpcoin, dbid)
			xlDb_Execute(sUpdate)
		end
	end
	
	--增加红装卷轴
	function UserCoinMgr:DBAddRedScroll(dbid, addRedScroll)

		local redScroll = math.min(2000, (addRedScroll or 0))

		if redScroll > 0 then
			--
			local sUpdate = string.format("UPDATE t_user SET equip_scroll = equip_scroll + %d WHERE uid = %d",redScroll,dbid)
			xlDb_Execute(sUpdate)

		elseif redScroll < 0 then
			--扣除金币，不记录进prize，会在扣之前走order
			local sUpdate = string.format("UPDATE t_user SET equip_scroll = equip_scroll + %d WHERE uid = %d",redScroll,dbid)
			xlDb_Execute(sUpdate)
		end
	end
	
	--增加任务之石
	function UserCoinMgr:DBAddTaskStone(dbid, addStone)
		--查询任务之石是否过期（每周重置）
		local nTaskStone = 0
		local sQuery = string.format("SELECT `stone`, `stone_lasttime` from `t_user` where `uid` = %d", dbid)
		local err, stone, stone_lasttime = xlDb_Query(sQuery)
		--print(sQuery)
		--print(err)
		if (err == 0) then
			nTaskStone = stone
			
			--检测是否同一周
			local strWeekNow = os.date("%Y%W", os.time())
			local nWeekNow = tonumber(strWeekNow)
			
			local nTimestampWeekLast = hApi.GetNewDate(stone_lasttime)
			local strWeekLast = os.date("%Y%W", nTimestampWeekLast)
			local nWeekLast = tonumber(strWeekLast)
			if (nWeekLast ~= nWeekNow) then
				nTaskStone = 0
			end
		end
		
		if (addStone >= 0) then
			nTaskStone = nTaskStone + addStone
			
		elseif (addStone < 0) then
			--扣除金币，不记录进prize，会在扣之前走order
			--
		end
		
		--更新
		local sUpdate = string.format("UPDATE `t_user` SET `stone` = %d, `stone_lasttime` = NOW() WHERE uid = %d", nTaskStone, dbid)
		xlDb_Execute(sUpdate)
		--print(sUpdate)
	end
	
	--增加武器枪宝箱
	function UserCoinMgr:DBAddWeaponChest(dbid, addDebris)
		local sUpdate = string.format("UPDATE t_user SET `weapon_chest` = `weapon_chest` + %d WHERE uid = %d", addDebris, dbid)
		xlDb_Execute(sUpdate)
	end
	
	--增加战术宝箱
	function UserCoinMgr:DBAddTacticChest(dbid, addDebris)
		local sUpdate = string.format("UPDATE t_user SET `tactic_chest` = `tactic_chest` + %d WHERE uid = %d", addDebris, dbid)
		xlDb_Execute(sUpdate)
	end
	
	--增加宠物宝箱
	function UserCoinMgr:DBAddPetChest(dbid, addDebris)
		local sUpdate = string.format("UPDATE t_user SET `pet_chest` = `pet_chest` + %d WHERE uid = %d", addDebris, dbid)
		xlDb_Execute(sUpdate)
	end
	
	--增加装备宝箱
	function UserCoinMgr:DBAddEquipChest(dbid, addDebris)
		local sUpdate = string.format("UPDATE t_user SET `equip_chest` = `equip_chest` + %d WHERE uid = %d", addDebris, dbid)
		xlDb_Execute(sUpdate)
	end
	
	--增加地鼠币
	function UserCoinMgr:DBAddDiShuCoin(dbid, addNum)
		local sUpdate = string.format("UPDATE `t_user` SET `dishu_coin` = `dishu_coin` + %d WHERE `uid` = %d", addNum, dbid)
		xlDb_Execute(sUpdate)
	end
	
	--增加战车天赋点
	function UserCoinMgr:DBAddTankTalentPoint(uid, rid, addNum)
		local sUpdate = string.format("UPDATE `t_cha` SET `talentAdd` = `talentAdd` + %d WHERE `id` = %d", addNum, rid)
		xlDb_Execute(sUpdate)
	end
	
	--增加宝箱（一次加1个）
	function UserCoinMgr:DBAddChest(uid, rid, itemId, itemNum)
		-- itemId, 9004-9006宝箱 9300-9320碎片 9999红妆卷轴
		local num = itemNum or 1
		if itemId >= 9004 and itemId <= 9006 then
			--银宝箱一次最多3个（防止x3乱搞）
			if itemId == 9005 then
				num = math.min(3, num)
			--金宝箱一次最多1个（防止x3乱搞）
			elseif itemId == 9006 then
				num = math.min(1, num)
			end
			if xlPrize_AddVii then
				xlPrize_AddVii(uid,rid,itemId,num)
			end
		end
	end
	
	--购买道具预扣费
	function UserCoinMgr:DBUserPurchase(dbid, rid, itemId,itemNum,gamecoinCost,scoreCost,itemExt)
		
		local ret = false
		local ret_order_id = 0 --订单号id
		
		local nItemId = itemId
		local nItemNum = itemNum or 1
		local nGamecoinCost = gamecoinCost or 0
		local nScoreCost = scoreCost or 0
		local sItemExt = itemExt or ""
		
		if not nItemId or nItemId <= 0 then
			return ret, ret_order_id
		end
		
		local sql = string.format("SELECT gamecoin_online FROM t_user where uid=%d",dbid)
		local err,gamecoin = xlDb_Query(sql)
		if err == 0 then
			
			--如果有足够的游戏币
			if gamecoinCost <= gamecoin then
				
				local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
				
				--新的购买记录插入到order表
				local sUpdateLog = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,dbid,rid,itemId,nItemNum,sItemName,nGamecoinCost,nScoreCost,sItemExt)
				xlDb_Execute(sUpdateLog)
				
				local err1, orderId = xlDb_Query("select last_insert_id()")
				--print("err1,orderId:",err1,orderId)
				if err1 == 0 then
					ret_order_id = orderId
				end
				
				--扣钱
				--更新t_user
				self:DBAddGamecoin(dbid, -gamecoinCost)
				
				ret = true
			end
		end
		
		return ret, ret_order_id
	end
	
	--红装晶石兑换道具扣费
	function UserCoinMgr:DBUserExchange(dbid, rid, itemId,itemNum,crystalCost,scoreCost,itemExt)
		
		local ret = false
		
		local nItemId = itemId
		local nItemNum = itemNum or 1
		local nCrystalCost = crystalCost or 0
		local nScoreCost = scoreCost or 0
		local sItemExt = itemExt or ""

		if not nItemId or nItemId <= 0 then
			return ret
		end

		local sql = string.format("SELECT equip_crystal FROM t_user where uid=%d",dbid)
		local err,crystal = xlDb_Query(sql)
		if err == 0 then

			--如果有足够的游戏币
			if nCrystalCost <= crystal then

				local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]

				--新的购买记录插入到order表
				local sUpdateLog = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,dbid,rid,itemId,nItemNum,sItemName,0,nScoreCost,nCrystalCost.. ";" .. sItemExt)
				xlDb_Execute(sUpdateLog)
				
				--扣钱
				--更新t_user
				self:DBAddCrystal(dbid, -nCrystalCost)

				ret = true
			end
		end

		return ret
	end
	
	--红装卷轴选择红装扣费
	function UserCoinMgr:DBUserCostScroll(dbid, rid, itemId,itemNum,scrollCost,scoreCost,itemExt)
		
		local ret = false
		
		local nItemId = itemId
		local nItemNum = itemNum or 1
		local nScrollCost = scrollCost or 0
		local nScoreCost = scoreCost or 0
		local sItemExt = itemExt or ""

		if not nItemId or nItemId <= 0 then
			return ret
		end

		local sql = string.format("SELECT equip_scroll FROM t_user where uid=%d",dbid)
		local err,scroll = xlDb_Query(sql)
		if err == 0 then

			--如果有足够的游戏币
			if nScrollCost <= scroll then

				local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]

				--新的购买记录插入到order表
				local sUpdateLog = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,dbid,rid,itemId,nItemNum,sItemName,0,nScoreCost,nScrollCost.. ";" .. sItemExt)
				xlDb_Execute(sUpdateLog)
				
				--扣钱
				--更新t_user
				self:DBAddRedScroll(dbid, -nScrollCost)

				ret = true
			end
		end

		return ret
	end

	--获取玩家的资源信息
	function UserCoinMgr:DBUserGetMyCoin(dbid,rid)
		local sL2CCmd = ""

		local sql = string.format("SELECT u.gamecoin_online,u.pvpcoin,u.equip_crystal,equip_scroll, weapon_chest, tactic_chest, pet_chest, equip_chest, scientist,deadth,dishu_coin FROM t_user as u where u.uid=%d ",dbid)
		local err,gamecoin,pvpcoin,equip_crystal,equip_scroll, weapon_chest, tactic_chest, pet_chest, equip_chest, scientist, deadth, dishu_coin = xlDb_Query(sql)
		--print(sql)
		--print(err)
		if err == 0 then
			sL2CCmd = gamecoin .. ";" .. pvpcoin .. ";" .. equip_crystal .. ";" .. equip_scroll .. ";" .. weapon_chest .. ";" .. tactic_chest .. ";" .. pet_chest .. ";" .. equip_chest .. ";" .. scientist .. ";" .. deadth .. ";" .. dishu_coin .. ";"
		else
			sL2CCmd = "0;0;0;0;0;0;0;0;0;0;0;"
		end

		local sqlpvp = string.format("SELECT pu.evaluateE FROM t_pvp_user as pu where pu.id=%d",rid)
		local errpvp,evaluateE = xlDb_Query(sqlpvp)
		if errpvp == 0 then
			sL2CCmd = sL2CCmd .. evaluateE .. ";"
		else
			sL2CCmd = sL2CCmd .. "0;"
		end
		
		return sL2CCmd
	end
	
	--获取玩家游戏币变化纪录信息
	function UserCoinMgr:DBQueryGameCoinHistory(uid, rid)
		--游戏币变化有3部分组成: prize领奖、iap_record充值、order消耗
		--依次读取每个表，取最近100条纪录
		local tRecord = {}
		local MAXCOUNT = 100
		
		--查询prize每日领奖 9号
		local sQueryM = string.format("select `mykey`, `create_time` from `prize` where `uid` = %d and `type` = 9 order by `create_time` desc limit %d", uid, MAXCOUNT)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("查询prize每日领奖:", "errM=", errM, "tTemp=", #tTemp)
		if (errM == 0) then
			--每日领奖信息
			for n = 1, #tTemp, 1 do
				local mykey = tTemp[n][1]
				local time = tTemp[n][2]
				local rmb = string.sub(mykey, string.find(mykey, "c:") + 2, string.find(mykey, "s:") - 2)
				local coin = tonumber(rmb) or 0
				--print(coin, time)
				if (coin > 0) then
					tRecord[#tRecord+1] = {coin = coin, time = time, operation = hVar.tab_string["__TEXT_MAIL_DALIYREWARD"], tag = 1, idx = n,}
				end
			end
		end
		
		--查询prize新人礼包 100号
		local sQueryM = string.format("select `mykey`, `create_time` from `prize` where `uid` = %d and `type` = 100 order by `create_time` desc limit %d", uid, MAXCOUNT)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("查询prize新人礼包:", "errM=", errM, "tTemp=", #tTemp)
		if (errM == 0) then
			--新人礼包信息
			for n = 1, #tTemp, 1 do
				local mykey = tTemp[n][1]
				local time = tTemp[n][2]
				local rmb = string.sub(mykey, string.find(mykey, "c:") + 2, string.find(mykey, "s:") - 2)
				local coin = tonumber(rmb) or 0
				--print(coin, time)
				if (coin > 0) then
					tRecord[#tRecord+1] = {coin = coin, time = time, operation = hVar.tab_string["__TEXT_MAIL_NEWPLAYERREWARD"], tag = 2, idx = n,}
				end
			end
		end
		
		--查询prize支持游戏 18号
		local sQueryM = string.format("select `mykey`, `create_time` from `prize` where `uid` = %d and `type` = 18 order by `create_time` desc limit %d", uid, MAXCOUNT)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("查询prize支持游戏:", "errM=", errM, "tTemp=", #tTemp)
		if (errM == 0) then
			--支持游戏信息
			for n = 1, #tTemp, 1 do
				local mykey = tTemp[n][1]
				local time = tTemp[n][2]
				local rmb = string.sub(mykey, string.find(mykey, "c:") + 2, string.find(mykey, "s:") - 2)
				local coin = tonumber(rmb) or 0
				--print(coin, time)
				if (coin > 0) then
					tRecord[#tRecord+1] = {coin = coin, time = time, operation = hVar.tab_string["__TEXT_MAIL_SUPPORTGAMEREWARD"], tag = 3, idx = n,}
				end
			end
		end
		
		--查询recommend推荐奖励 3号
		local sQueryM = string.format("select `mykey`, `create_time` from `prize` where `uid` = %d and `type` = 3 order by `create_time` desc limit %d", uid, MAXCOUNT)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("查询recommend推荐奖励:", "errM=", errM, "tTemp=", #tTemp)
		if (errM == 0) then
			--推荐奖励信息
			for n = 1, #tTemp, 1 do
				local mykey = tTemp[n][1]
				local time = tTemp[n][2]
				local rmb = string.sub(mykey, string.find(mykey, "c:") + 2, string.find(mykey, ";") - 1) --只有游戏币信息
				local coin = tonumber(rmb) or 0
				--print(coin, time)
				if (coin > 0) then
					tRecord[#tRecord+1] = {coin = coin, time = time, operation = hVar.tab_string["__TEXT_MAIL_RECOMMNDREWARD"], tag = 4, idx = n,}
				end
			end
		end
		
		--查询prize充值暴击 10000号
		local sQueryM = string.format("select `mykey`, `create_time` from `prize` where `uid` = %d and `type` = 10000 order by `create_time` desc limit %d", uid, MAXCOUNT)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("查询prize充值暴击:", "errM=", errM, "tTemp=", #tTemp)
		if (errM == 0) then
			--充值暴击信息
			for n = 1, #tTemp, 1 do
				local mykey = tTemp[n][1]
				local time = tTemp[n][2]
				local rmb = string.sub(mykey, string.find(mykey, "c:") + 2, string.find(mykey, ";") - 1) --只有游戏币信息
				local coin = tonumber(rmb) or 0
				--print(coin, time)
				if (coin > 0) then
					tRecord[#tRecord+1] = {coin = coin, time = time, operation = hVar.tab_string["__TEXT_MAIL_PURCHASECRITALREWARD"], tag = 5, idx = n,}
				end
			end
		end
		
		--查询prize 400号 领奖
		local sQueryM = string.format("select `mykey`, `create_time` from `prize` where `uid` = %d and `type` = 400 and `used` = 2 order by `create_time` desc limit %d", uid, MAXCOUNT)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("查询prize领奖:", "errM=", errM, "tTemp=", #tTemp)
		if (errM == 0) then
			--领奖信息
			for n = 1, #tTemp, 1 do
				local strTitle = hVar.tab_string["__TEXT_MAIL_REWARD"]
				local mykey = tTemp[n][1]
				local coin = tonumber(mykey) or 0
				local time = tTemp[n][2]
				
				--如果mykey字段含有";",标题为分号前
				local pos = string.find(mykey, ";")
				if (pos ~= nil) then
					strTitle = string.sub(mykey, 1, pos - 1)
					coin = tonumber(string.sub(mykey, pos + 1, #mykey)) or 0
				end
				
				--print(coin, time)
				if (coin > 0) then
					tRecord[#tRecord+1] = {coin = coin, time = time, operation = strTitle, tag = 6, idx = n,}
				end
			end
		end
		
		--查询礼品码 奖励
		local sQueryM = string.format("select `mykey`, `buy_time` from `dispatch_coin` where `recipient` = %d and `used` = 2 order by `buy_time` desc limit %d", uid, MAXCOUNT)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("查询礼品码:", "errM=", errM, "tTemp=", #tTemp)
		if (errM == 0) then
			for n = 1, #tTemp, 1 do
				local mykey = tTemp[n][1]
				local time = tTemp[n][2]
				local rmb = 0 --可能只有游戏币信息，或者没有游戏币，或者游戏币和积分
				if (string.find(mykey, "c:") ~= nil) then
					rmb = string.sub(mykey, string.find(mykey, "c:") + 2, string.find(mykey, ";") - 1) --不确定是否只有游戏币信息
				end
				local coin = tonumber(rmb) or 0
				--print(coin, time)
				if (coin > 0) then
					tRecord[#tRecord+1] = {coin = coin, time = time, operation =hVar.tab_string["__TEXT_GIFT_REWARD"], tag = 7, idx = n,}
				end
			end
		end
		
		--查询iap_record充值
		local sQueryM = string.format("select `money`, `coin`, `buytime` from `iap_record` where `uid` = %d order by `buytime` desc limit %d", uid, MAXCOUNT)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("查询iap_record充值:", "errM=", errM, "tTemp=", #tTemp)
		if (errM == 0) then
			--统计每一天的总充值金额
			for n = 1, #tTemp, 1 do
				local money = tTemp[n][1]
				local coin = tTemp[n][2]
				local time = tTemp[n][3]
				--print(money, coin, time)
				if (coin > 0) then
					tRecord[#tRecord+1] = {coin = coin, time = time, operation = string.format(hVar.tab_string["__TEXT_PURCHASE_REWARD"], money), tag = 8, idx = n,}
				end
			end
		end
		
		--查询order消耗
		local sQueryM = string.format("select `itemname`, `coin`, `time_begin` from `order` where `uid` = %d and (`rid` = %d or `rid` = 0) and `coin` > 0 order by `time_begin` desc limit %d", uid, rid, MAXCOUNT)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("查询order消耗:", "errM=", errM, "tTemp=", #tTemp)
		if (errM == 0) then
			--订单信息
			for n = 1, #tTemp, 1 do
				local itemname = tostring(tTemp[n][1])
				local coin = tTemp[n][2]
				local time = tTemp[n][3]
				--print(itemname, coin, time)
				if (coin > 0) then
					tRecord[#tRecord+1] = {coin = -coin, time = time, operation = itemname, tag = 9, idx = n,}
				end
			end
		end
		
		--查询现在的游戏币
		local gamecoinNow = 0
		local sql = string.format("SELECT `gamecoin_online` FROM `t_user` where `uid` = %d", uid)
		local err, gamecoin = xlDb_Query(sql)
		if (err == 0) then
			gamecoinNow = gamecoin
		end
		
		--排序，按照日期降序排序
		table.sort(tRecord, function(ta, tb)
			--lua中table.sort中的第二个参数在相等的情况下必须要返回false，而不能返回true
			--优先按日期，大的排前面
			if (ta.time ~= tb.time) then
				return (ta.time > tb.time)
			end
			
			--其次，按类型，小的排前面
			if (ta.tag ~= tb.tag) then
				return (ta.tag < tb.tag)
			end
			
			--同一类型，索引小的排前面
			return (ta.idx < tb.idx)
		end)
		
		local recordNum = #tRecord
		if (recordNum > MAXCOUNT) then
			recordNum = MAXCOUNT
		end
		local sCmd = tostring(gamecoinNow) .. ";" .. tostring(recordNum) .. ";"
		for i = 1, recordNum, 1 do
			local temp = tostring(tRecord[i].coin) .. ";" .. tostring(tRecord[i].time) .. ";" .. tostring(tRecord[i].operation) .. ";"
			sCmd = sCmd .. temp
		end
		
		return sCmd
	end
	
return UserCoinMgr