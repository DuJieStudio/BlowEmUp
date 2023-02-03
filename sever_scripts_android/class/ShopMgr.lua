--商城管理类
local ShopMgr = class("ShopMgr")
	
	--商店类型
	ShopMgr.TYPE = {
		NORMAL = 0,			--普通商店
		AUTO_REFRESH = 1,		--自动刷新商店（每个玩家刷新3个商品，每个商品有购买次数上限，每天固定时间刷新，每天可用金币刷新n次）
		SHOP_CANGBAOTU_NORMAL = 23,	--藏宝图商店
		SHOP_CANGBAOTU_HIGH = 24,	--高级藏宝图商店
	}
	
	ShopMgr.RefreshSID = 349		--刷新商城 商品id
	
	--新商店抽奖
	ShopMgr.CHOUJIANG_SHOP_ID = 2				--新商店的商店id
	
	ShopMgr.CHOUJIANG_REDCHEST_ONCE_SHOPINDEX = 7		--神器宝箱抽一次商品索引
	ShopMgr.CHOUJIANG_REDCHEST_TENTH_SHOPINDEX = 8		--神器宝箱抽十次商品索引
	ShopMgr.CHOUJIANG_TACTICCARD_ONCE_SHOPINDEX = 9		--战术卡抽一次商品索引
	ShopMgr.CHOUJIANG_TACTICCARD_TENTH_SHOPINDEX = 10	--战术卡抽十次商品索引
	
	ShopMgr.CHOUJIANG_REDCHEST_ONCE_FREE_SHOPINDEX = 11	--神器宝箱免费抽一次商品索引
	ShopMgr.CHOUJIANG_REDCHEST_TENTH_FREE_SHOPINDEX = 12	--神器宝箱免费抽十次商品索引
	ShopMgr.CHOUJIANG_TACTICCARD_ONCE_FREE_SHOPINDEX = 13	--战术卡免费抽一次商品索引
	ShopMgr.CHOUJIANG_TACTICCARD_TENTH_FREE_SHOPINDEX = 14	--战术卡免费抽十次商品索引
	
	--神器宝箱每天免费抽一次的次数
	ShopMgr.CHOUJIANG_REDCHEST_ONCE_FREE_COUNT_DAILY = 1
	
	--战术卡包每天免费抽一次的次数
	ShopMgr.CHOUJIANG_TACTICCARD_ONCE_FREE_COUNT_DAILY = 1
	
	ShopMgr.RED_CRYSTAL_EXCHANGE_ONCE_SHOPINDEX = 2		--神器晶石兑换一次的商品索引
	ShopMgr.RED_CRYSTAL_EXCHANGE_TENTH_SHOPINDEX = 15	--神器晶石兑换十次的商品索引
	ShopMgr.RED_CRYSTAL_EXCHANGE_FIFTY_SHOPINDEX = 16	--神器晶石兑换50次的商品索引
	
	--构造函数
	function ShopMgr:ctor()
		--其他
		return self
	end
	--初始化函数
	function ShopMgr:Init()
		return self
	end
	
	--刷新商城道具
	function ShopMgr:_refreshShopItem(shopId, vipLv)
		local ret
		local tShop = hVar.tab_shop[shopId]
		--商店配置表存在
		if tShop then
			local shopType = tShop.type
			--并且商店是自动刷新商店
			if shopType == ShopMgr.TYPE.NORMAL then
				local goods = tShop.goods
				if goods then
					local goodsNum = 0
					ret = ""
					for i = 1, #goods do
						local shopItemId = goods[i]
						local shopItem = hClass.ShopItem:create():Init(shopItemId)
						if shopItem then
							goodsNum = goodsNum + 1
							ret = ret..(shopItem:InfoToCmd())
						end
					end
					ret = goodsNum .. ";" .. ret
				end
			elseif shopType == ShopMgr.TYPE.AUTO_REFRESH then
				--print("shopType1")
				--最大售卖数量
				--local quota = tShop.quota
				--出售商品最大种类
				local goodsNumMax = tShop.goodsNumMax
				--商品列表
				local goods = tShop.goods
				--print("shopType2",goods)
				if goods then
					--print("shopType3")
					local goodsNum = 0
					ret = ""
					--print("shopType4:",goodsNumMax)
					--商品最大种类是多少就随机多少次
					for g = 1, #goods, 1 do
						if (goodsNum < goodsNumMax) then --未填满
							local totalValue = goods[g].totalValue
							local good = {} --拷贝表
							for n = 1, #goods[g], 1 do
								good[#good+1] = goods[g][n]
							end
							local rollCount = goods[g].rollCount --随机次数
							local loopCount = math.min(rollCount, goodsNumMax - goodsNum) --随机次数不能超过剩余次数
							--print("shopType5:",value)
							
							--附加vip专属商城的随机列表
							local vipShop = goods[g].vipShop
							if vipShop and vipShop[vipLv] then
								totalValue = totalValue + vipShop[vipLv].totalValue
								for n = 1, #vipShop[vipLv], 1 do
									good[#good+1] = vipShop[vipLv][n]
								end
							end
							--print("totalValue=", totalValue, "vipLv=", vipLv)
							--随机n次
							for n = 1, loopCount, 1 do
								local value = math.random(1, totalValue)
								local initialValue = 0
								--遍历，看权重落在哪个区段
								for i = 1, #good, 1 do
									if (value > initialValue) and (value <= (initialValue + good[i].value)) then
										--print("shopType6:")
										local shopItemId = good[i].shopItemId
										local quota = good[i].quota or 1
										local shopItem = hClass.ShopItem:create():Init(shopItemId,quota)
										--print("shopType7:",shopItem,shopItemId,quota)
										if shopItem then
											--print("shopType8:")
											goodsNum = goodsNum + 1
											ret = ret..(shopItem:InfoToCmd())
										end
										break
									end
									initialValue = initialValue + good[i].value
								end
							end
						end
					end
					ret = goodsNum .. ";" .. ret
				end
			end
		end

		return ret
	end

	--获取刷新时间(商店每日刷新时刻)
	--返回值: 字符串时间
	function ShopMgr:_GetRefreshTime(sRefreshTime)
		--获取当前时间
		local dbTime = hApi.GetTime()
		
		--计算是否过了刷新时刻
		local sDate = os.date("%Y-%m-%d", dbTime)
		
		--当天
		local last_refresh_time = sDate .. " " .. sRefreshTime
		local nRefreshTime = hApi.GetNewDate(last_refresh_time)
		if dbTime <= nRefreshTime then
			--前一天
			local yesterday = hApi.GetNewDate(last_refresh_time, "DAY", -1)
			last_refresh_time = os.date("%Y-%m-%d",yesterday) .. " " .. sRefreshTime
			--print("last_refresh_time:",last_refresh_time,yesterday)
		end
		
		return last_refresh_time
	end
	
	--商品字符串转表
	function ShopMgr:_ConvertGoodsStr2Tab(goodsInfo)
		
		local ret = {}
		
		local tGoods = hApi.Split(goodsInfo, ";")
		local goodsNum = tonumber(tGoods[1]) or 0
		local infoIdx = 1
		
		--遍历所有英雄
		for i = 1, goodsNum do
			local goodsList = tGoods[infoIdx + i] or ""
			local tGoodsList = hApi.Split(goodsList,":")
			
			--商品数据
			local id = tonumber(tGoodsList[1]) or 0
			local itemId = tonumber(tGoodsList[2]) or 0
			local num = tonumber(tGoodsList[3]) or 1
			local score = tonumber(tGoodsList[4]) or 0
			local rmb = tonumber(tGoodsList[5]) or 0
			local quota = tonumber(tGoodsList[6]) or 1
			local saledCount = tonumber(tGoodsList[7]) or 0
			
			if id > 0 and itemId > 0 then
				ret[#ret + 1] = hClass.ShopItem:create():Init(id,quota,itemId,num,score,rmb,saledCount)
			end
		end

		return ret
	end
	--商品列表表转字符串
	function ShopMgr:_ConvertGoodsTab2Str(goodsList)
		local ret = ""

		local goodsNum = 0
		for i = 1, #goodsList do
			local shopItem = goodsList[i]
			if shopItem and type(shopItem) == "table" and shopItem:getCName() == "ShopItem" then
				goodsNum = goodsNum + 1
				ret = ret..(shopItem:InfoToCmd())
			end
		end
		ret = goodsNum .. ";" .. ret
		
		return ret
	end
	
	
	--获取商城列表
	function ShopMgr:OpenShop(udbid, rid, shopId)

		local ret
		local tShop = hVar.tab_shop[shopId]
		
		--商城静态表
		if tShop then
			local shopType = tShop.type
			
			--如果是普通商店直接返回商品道具列表
			if shopType == ShopMgr.TYPE.NORMAL then
				
				local rmb_refresh_count = 0
				local vipLv = hGlobal.vipMgr:DBGetUserVip(udbid) --玩家vip等级
				--print("udbid1=", udbid, "vipLv=", vipLv)
				local goods = self:_refreshShopItem(shopId, vipLv) or "0;"
				ret = shopId .. ";" .. rmb_refresh_count .. ";" .. goods
				
			--如果是自动刷新商店
			elseif shopType == ShopMgr.TYPE.AUTO_REFRESH then
				
				--商店每日刷新时刻
				local sRefreshTime = tShop.refreshTime
				local last_refresh_time = self:_GetRefreshTime(sRefreshTime)
				local refresh_timestamp = hApi.GetNewDate(last_refresh_time) --整数时间戳
				
				local strGoods = ""
				local rmb_refresh_count = 0
				--local sql = string.format("SELECT `id`,`uid`,`shopid`,`goods`,`goods1`,`goods2`,`goods3`,`goods4`,`goods5`,`goods6`,`goods7`,`rmb_refresh_count` FROM t_user_shop_product WHERE `uid`=%d AND `shopid`=%d AND `last_refresh_time`='%s' ORDER BY `time` LIMIT 1",udbid,shopId,last_refresh_time)
				local sql = string.format("SELECT `id`,`uid`,`shopid`,`goods`,`goods1`,`goods2`,`goods3`,`goods4`,`goods5`,`goods6`,`goods7`,`goods8`,`goods9`,`goods10`,`rmb_refresh_count` FROM t_user_shop_product WHERE `uid`=%d AND `shopid`=%d AND `refresh_timestamp`=%d",udbid,shopId,refresh_timestamp)
				local err, id,uid,shopid,goods,goods1,goods2,goods3,goods4,goods5,goods6,goods7,goods8,goods9,goods10,rmbRefreshCount = xlDb_Query(sql)
				--print("OpenShop:",err,sql)
				if err == 0 then
					rmb_refresh_count = rmbRefreshCount
					if rmb_refresh_count == 0 then
						strGoods = goods
					elseif rmb_refresh_count == 1 then
						strGoods = goods1
					elseif rmb_refresh_count == 2 then
						strGoods = goods2
					elseif rmb_refresh_count == 3 then
						strGoods = goods3
					elseif rmb_refresh_count == 4 then
						strGoods = goods4
					elseif rmb_refresh_count == 5 then
						strGoods = goods5
					elseif rmb_refresh_count == 6 then
						strGoods = goods6
					elseif rmb_refresh_count == 7 then
						strGoods = goods7
					elseif rmb_refresh_count == 8 then
						strGoods = goods8
					elseif rmb_refresh_count == 9 then
						strGoods = goods9
					elseif rmb_refresh_count == 10 then
						strGoods = goods10
					else
						strGoods = goods
					end
				elseif err == 4 then
					local vipLv = hGlobal.vipMgr:DBGetUserVip(udbid) --玩家vip等级
					--print("udbid2=", udbid, "vipLv=", vipLv)
					local goods = self:_refreshShopItem(shopId, vipLv) or "0;"
					strGoods = goods
					local insertSql = string.format("INSERT INTO t_user_shop_product (`uid`,`shopid`,`goods`,`last_refresh_time`,`refresh_timestamp`) values (%d,%d,'%s','%s',%d)",udbid,shopId,goods,last_refresh_time,refresh_timestamp)
					xlDb_Execute(insertSql)
				end
				ret = shopId .. ";" .. rmb_refresh_count .. ";" .. strGoods
			end
		end
		
		return ret
	end
	
	--刷新商店
	function ShopMgr:RefreshShop(udbid, rid, shopId)
		
		print("RefreshShop1:",udbid, rid, shopId)
		local ret,strShopItem
		local result = 0 --操作结果
		local tShop = hVar.tab_shop[shopId]
		print("RefreshShop2:",tShop)
		--商城静态表
		if tShop then
			
			
			
			local shopType = tShop.type
			
			--如果是普通商店直接返回商品道具列表（普通商店不需要刷新）
			if shopType == ShopMgr.TYPE.NORMAL then
			
			--如果是自动刷新商店
			elseif shopType == ShopMgr.TYPE.AUTO_REFRESH then
				
				print("RefreshShop3:",shopType)
				
				--rmb最大刷新次数
				local rmbRefreshCountMax = tShop.rmbRefreshCount
				--商店每日刷新时刻
				local sRefreshTime = tShop.refreshTime
				local last_refresh_time = self:_GetRefreshTime(sRefreshTime)
				local refresh_timestamp = hApi.GetNewDate(last_refresh_time) --整数时间戳
				
				print("RefreshShop4:",rmbRefreshCountMax,sRefreshTime,last_refresh_time)
				
				--local sql = string.format("SELECT `id`,`rmb_refresh_count` FROM t_user_shop_product WHERE `uid`=%d AND `shopid`=%d AND `last_refresh_time`='%s' ORDER BY `time` LIMIT 1",udbid,shopId,last_refresh_time)
				local sql = string.format("SELECT `id`,`rmb_refresh_count` FROM t_user_shop_product WHERE `uid`=%d AND `shopid`=%d AND `refresh_timestamp`=%d",udbid,shopId,refresh_timestamp)
				local err, id, rmb_refresh_count = xlDb_Query(sql)
				--print("RefreshShop5:",err, rmb_refresh_count, sql)
				if err == 0 then
					
					local vipFreeRefreshCount, vipLv = hGlobal.vipMgr:GetNetShopRefreshCount(udbid)
					
					print("RefreshShop6:",vipFreeRefreshCount, vipLv)
					
					--如果有足够的刷新次数，则进行刷新
					if rmb_refresh_count < math.max(rmbRefreshCountMax,vipFreeRefreshCount) then
						
						--print("RefreshShop7:",ShopMgr.RefreshSID)
						
						--扣费处理
						local shopItem = hClass.ShopItem:create():Init(ShopMgr.RefreshSID)
						
						print("RefreshShop8:",shopItem)
						
						--如果存在刷新商城道具
						if shopItem then
							--刷新一次商品列表
							--local vipLv = hGlobal.vipMgr:DBGetUserVip(udbid) --玩家vip等级
							--print("udbid3=", udbid, "vipLv=", vipLv)
							local goods = self:_refreshShopItem(shopId, vipLv) or "0;"
							local goodsCol = "goods"
							rmb_refresh_count = rmb_refresh_count + 1
							goodsCol = goodsCol..(rmb_refresh_count)
							local rmbCost = shopItem:GetRmbCost()
							local itemExt = shopId .. ";" .. rmb_refresh_count .. ";" .. goods
							
							if vipFreeRefreshCount > 0 then
								--rmbCost = 0
								itemExt = itemExt..";vip"
							end
							
							print("RefreshShop9:",itemExt)
							
							--尝试扣费，成功的话更新数据
							if hGlobal.userCoinMgr:DBUserPurchase(udbid,rid,shopItem:GetItemID(),1,rmbCost,0,itemExt) then
								local updateSql = string.format("UPDATE t_user_shop_product SET `%s`='%s',`rmb_refresh_count`=`rmb_refresh_count`+1 WHERE `id`=%d AND `uid`=%d AND `shopid`=%d AND `refresh_timestamp`=%d", goodsCol,goods,id,udbid,shopId,refresh_timestamp)
								local abc = xlDb_Execute(updateSql)
								
								print("RefreshShop10:",abc,_DBUserPurchase)
								strShopItem = shopItem:InfoToCmd()
								ret = itemExt
								
								--更新每日任务（新）
								--刷新商店
								local taskType = hVar.TASK_TYPE.TASK_REFRESH_SHOP --刷新商店
								local addCount = 1
								local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(udbid, rid)
								taskMgr:AddTaskFinishCount(taskType, addCount)
								
								--操作成功
								result = 1
							else
								result = -1 --游戏币不足
							end
						else
							result = -2 --商品不存在
						end
					else
						result = -3 --刷新次数用完
					end
				else
					result = -4 --数据异常
				end
			end
		end
		
		return ret,strShopItem, result
	end
	
	--购买物品
	function ShopMgr:BuyItem(udbid, rid, shopId, itemIdx, cRedequipCrystal)
		local nRedequipCrystal = 0
		local ret, goodsInfo
		local nIsSuccess = 0 --是否成功
		local tShop = hVar.tab_shop[shopId]
		
		--如果使用红装晶石兑换
		if cRedequipCrystal then
			nRedequipCrystal = 1
		else
			nRedequipCrystal = 0
		end
		
		--商城静态表
		if tShop then
			local shopType = tShop.type
			
			--如果是普通商店直接返回商品道具列表（普通商店不需要刷新）
			if shopType == ShopMgr.TYPE.NORMAL then
				local shopgoods = tShop.goods
				local shopItemId = shopgoods[itemIdx]
				local shopItem = hClass.ShopItem:create():Init(shopItemId)
				if shopItem then
					local buySucess = false
					local ret_order_id = 0
					
					--如果使用红装晶石兑换
					if cRedequipCrystal then
						buySucess, ret_order_id = hGlobal.userCoinMgr:DBUserExchange(udbid,rid,shopItem:GetItemID(),1,shopItem:GetCrystalCost(),shopItem:GetScoreCost(),shopItem:InfoToCmd())
						--if hGlobal.userCoinMgr:DBUserExchange(udbid,rid,shopItem:GetItemID(),1,shopItem:GetCrystalCost(),shopItem:GetScoreCost(),shopItem:InfoToCmd()) then
						--	buySucess = true
						--end
					else
						buySucess, ret_order_id = hGlobal.userCoinMgr:DBUserPurchase(udbid,rid,shopItem:GetItemID(),1,shopItem:GetRmbCost(),shopItem:GetScoreCost(),shopItem:InfoToCmd())
						--if hGlobal.userCoinMgr:DBUserPurchase(udbid,rid,shopItem:GetItemID(),1,shopItem:GetRmbCost(),shopItem:GetScoreCost(),shopItem:InfoToCmd()) then
						--	buySucess = true
						--end
					end
					
					--尝试扣费，成功的话更新数据
					if buySucess then
						--增加当前已经售卖件数
						local result = shopItem:DBGetItem(udbid, rid, cRedequipCrystal)
						--如果丢包失败需要回退金币或红装晶石
						if not result then
							if cRedequipCrystal then
								hGlobal.userCoinMgr:DBAddCrystal(udbid,shopItem:GetCrystalCost())
							else
								hGlobal.userCoinMgr:DBAddGamecoin(udbid,shopItem:GetRmbCost())
							end
							ret = "-5;"
							nIsSuccess = -5
						else
							--ret = "1;"..shopItem:InfoToCmd()
							ret = "1;"..shopItem:InfoToCmd()..result
							nIsSuccess = 1
							
							--更新订单信息
							local sUpdate = string.format("UPDATE `order` SET `ext_01` = '%s' WHERE `id` = %d", shopItem:InfoToCmd()..result, ret_order_id)
							--print("sUpdate1:",sUpdate)
							xlDb_Execute(sUpdate)
						end
					else
						if cRedequipCrystal then
							--err:神器晶石不足-6
							ret = "-6;"
							nIsSuccess = -6
						else
							--err:游戏币不足-2
							ret = "-2;"
							nIsSuccess = -2
						end
					end
				else
					--err:商品不存在-1
					ret = "-1;"
					nIsSuccess = -1
				end
			elseif (shopType == ShopMgr.TYPE.SHOP_CANGBAOTU_NORMAL) then --藏宝图商店
				local shopgoods = tShop.goods
				local shopItemId = shopgoods[itemIdx]
				local shopItem = hClass.ShopItem:create():Init(shopItemId)
				if shopItem then
					local buySucess = false
					local ret_order_id = 0
					
					--藏宝图兑换
					buySucess, ret_order_id = hGlobal.userCoinMgr:DBUserExchangeCangBaoTu(udbid,rid,shopItem:GetItemID(),1,shopItem:GetCangBaoTuCost(),0,shopItem:InfoToCmd())
					--if hGlobal.userCoinMgr:DBUserExchangeCangBaoTu(udbid,rid,shopItem:GetItemID(),1,shopItem:GetCangBaoTuCost(),0,shopItem:InfoToCmd()) then
					--	buySucess = true
					--end
					
					--尝试扣费，成功的话更新数据
					if buySucess then
						--增加当前已经售卖件数
						local result = shopItem:DBGetItem(udbid, rid, cRedequipCrystal)
						--如果丢包失败需要回退藏宝图
						if not result then
							hGlobal.userCoinMgr:DBAddCangBaoTu(udbid,shopItem:GetCangBaoTuCost())
							ret = "-5;"
						else
							--ret = "1;"..shopItem:InfoToCmd()
							ret = "1;"..shopItem:InfoToCmd()..result
							nIsSuccess = 1
							
							--更新订单信息
							local sUpdate = string.format("UPDATE `order` SET `ext_01` = '%s' WHERE `id` = %d", shopItem:InfoToCmd()..result, ret_order_id)
							--print("sUpdate1:",sUpdate)
							xlDb_Execute(sUpdate)
						end
					else
						--err:藏宝图不足-7
						ret = "-7;"
					end
				else
					--err:商品不存在-1
					ret = "-1;"
				end
			elseif (shopType == ShopMgr.TYPE.SHOP_CANGBAOTU_HIGH) then --高级藏宝图商店
				local shopgoods = tShop.goods
				local shopItemId = shopgoods[itemIdx]
				local shopItem = hClass.ShopItem:create():Init(shopItemId)
				if shopItem then
					local buySucess = false
					local ret_order_id = 0
					
					--高级藏宝图兑换
					buySucess, ret_order_id = hGlobal.userCoinMgr:DBUserExchangeCangBaoTuHigh(udbid,rid,shopItem:GetItemID(),1,shopItem:GetCangBaoTuHighCost(),0,shopItem:InfoToCmd())
					--if hGlobal.userCoinMgr:DBUserExchangeCangBaoTuHigh(udbid,rid,shopItem:GetItemID(),1,shopItem:GetCangBaoTuHighCost(),0,shopItem:InfoToCmd()) then
					--	buySucess = true
					--end
					
					--尝试扣费，成功的话更新数据
					if buySucess then
						--增加当前已经售卖件数
						local result = shopItem:DBGetItem(udbid, rid, cRedequipCrystal)
						--如果丢包失败需要回退高级藏宝图
						if not result then
							hGlobal.userCoinMgr:DBAddCangBaoTuHigh(udbid,shopItem:GetCangBaoTuHighCost())
							ret = "-5;"
						else
							--ret = "1;"..shopItem:InfoToCmd()
							ret = "1;"..shopItem:InfoToCmd()..result
							nIsSuccess = 1
							
							--更新订单信息
							local sUpdate = string.format("UPDATE `order` SET `ext_01` = '%s' WHERE `id` = %d", shopItem:InfoToCmd()..result, ret_order_id)
							--print("sUpdate1:",sUpdate)
							xlDb_Execute(sUpdate)
						end
					else
						--err:高级藏宝图不足-8
						ret = "-8;"
					end
				else
					--err:商品不存在-1
					ret = "-1;"
				end
			--如果是自动刷新商店
			elseif shopType == ShopMgr.TYPE.AUTO_REFRESH then
				
				--商店每日刷新时刻
				local sRefreshTime = tShop.refreshTime
				local last_refresh_time = self:_GetRefreshTime(sRefreshTime)
				local refresh_timestamp = hApi.GetNewDate(last_refresh_time) --整数时间戳
				
				--local sql = string.format("SELECT `id`,`rmb_refresh_count`, CASE `rmb_refresh_count` WHEN 0 THEN `goods` WHEN 1 THEN `goods1` WHEN 2 THEN `goods2` WHEN 3 THEN `goods3` WHEN 4 THEN `goods4` WHEN 5 THEN `goods5` WHEN 6 THEN `goods6` WHEN 7 THEN `goods7` ELSE `goods` END AS `shopgoods` FROM t_user_shop_product WHERE `uid`=%d AND `shopid`=%d AND `last_refresh_time`='%s' ORDER BY `time` LIMIT 1",udbid,shopId,last_refresh_time)
				local sql = string.format("SELECT `id`,`rmb_refresh_count`, CASE `rmb_refresh_count` WHEN 0 THEN `goods` WHEN 1 THEN `goods1` WHEN 2 THEN `goods2` WHEN 3 THEN `goods3` WHEN 4 THEN `goods4` WHEN 5 THEN `goods5` WHEN 6 THEN `goods6` WHEN 7 THEN `goods7` WHEN 8 THEN `goods8` WHEN 9 THEN `goods9` WHEN 9 THEN `goods9` ELSE `goods` END AS `shopgoods` FROM t_user_shop_product WHERE `uid`=%d AND `shopid`=%d AND `refresh_timestamp`=%d",udbid,shopId,refresh_timestamp)
				local err, id, rmb_refresh_count, strShopgoods = xlDb_Query(sql)
				if err == 0 then
					local shopgoods = self:_ConvertGoodsStr2Tab(strShopgoods)
					local shopItem = shopgoods[itemIdx]
					if shopItem then
						--最大购买数量
						local quota = shopItem:GetQuota()
						--当前已购买次数
						local saledCount = shopItem:GetSaledCount()
						--如果是无限购买次数，或者当前已购次数小于购买次数上限
						if (quota == -1) or (quota > 0 and quota > saledCount) then
							local buySucess = false
							local ret_order_id = 0
							
							--尝试扣费，成功的话更新数据
							buySucess, ret_order_id = hGlobal.userCoinMgr:DBUserPurchase(udbid,rid,shopItem:GetItemID(),1,shopItem:GetRmbCost(),0,shopItem:InfoToCmd())
							--if hGlobal.userCoinMgr:DBUserPurchase(udbid,rid,shopItem:GetItemID(),1,shopItem:GetRmbCost(),0,shopItem:InfoToCmd()) then
							if buySucess then	
								--增加当前已经售卖件数
								local result = shopItem:DBGetItem(udbid,rid)
								--如果丢包成功需要记录日志
								if result then
									--todo
									local goods = self:_ConvertGoodsTab2Str(shopgoods)
									local goodsCol = "goods"
									if rmb_refresh_count > 0 then
										goodsCol = goodsCol..rmb_refresh_count
									end
									local updateSql = string.format("UPDATE t_user_shop_product SET `%s`='%s' WHERE `id`=%d AND `uid`=%d AND `shopid`=%d AND `refresh_timestamp`=%d", goodsCol,goods,id,udbid,shopId,refresh_timestamp)
									xlDb_Execute(updateSql)
									--ret = "1;"..shopItem:InfoToCmd()
									ret = "1;"..shopItem:InfoToCmd()..result
									nIsSuccess = 1
									
									--更新订单信息
									local sUpdate = string.format("UPDATE `order` SET `ext_01` = '%s' WHERE `id` = %d", shopItem:InfoToCmd()..result, ret_order_id)
									--print("sUpdate1:",sUpdate)
									xlDb_Execute(sUpdate)
									
									goodsInfo = shopId .. ";" .. rmb_refresh_count .. ";" .. goods
								else
									hGlobal.userCoinMgr:DBAddGamecoin(udbid,shopItem:GetRmbCost())
									ret = "-5;"
								end
								
								
							else
								--err:游戏币不足-2
								ret = "-2;"
							end
						else
							if quota > 0 and quota <= saledCount then
								--err:购买次数已达上限-3
								ret = "-3;"
							end
						end
					else
						--err:商品不存在-1
						ret = "-1;"	
					end
				else
					--err:商品信息不存在-4
					ret = "-4;"
				end
			end
		else
			--err:商店不存在
			ret = "-5;"
			nIsSuccess = -5
		end
		
		ret = tostring(nRedequipCrystal) .. ";" .. ret
		
		return ret, goodsInfo, nIsSuccess
	end
	
	--新商店查询抽奖信息
	function ShopMgr:_QueryChouJiangInfo(uid, rid, channelId)
		local nRedChestFree1Count = 0 --神器宝箱免费抽一次次数
		local strRedChestFree1LastTime = "1990-01-01 00:00:00" --神器宝箱免费抽一次上次免费使用时间
		local nRedChestFree10Count = 0 --神器宝箱免费抽十次次数
		local nTacticcardFree1Count = 0 --战术卡免费抽一次次数
		local strTacticcardFree1LastTime = "1990-01-01 00:00:00" --战术卡免费抽一次上次免费使用时间
		local nTacticcardFree10Count = 0 --战术卡免费抽十次次数
		local nRedChest1RmbCost = 0 --神器宝箱抽一次需要游戏币
		local nRedChest10RmbCost = 0 --神器宝箱抽十次需要游戏币
		local nTacticcard1RmbCost = 0 --神战术卡抽一次需要游戏币
		local nTacticcard10RmbCost = 0 --战术卡抽十次需要游戏币
		local nRedChest1ItemId = 0 --神器宝箱抽一次的商品id
		local nRedChest10ItemId = 0 --神器宝箱抽十次的商品id
		local nTacticcard1ItemId = 0 --神战术卡抽一次的商品id
		local nTacticcard10ItemId = 0 --战术卡抽十次的商品id
		
		--查询免费券数量
		local sql = string.format("SELECT `redchest_freeticket1_num`, `redchest_freeticket1_lasttime`, `redchest_freeticket10_num`, `tacticcard_freeticket1_num`, `tacticcard_freeticket1_lasttime`, `tacticcard_freeticket10_num` FROM `t_cha` WHERE `id`=%d ", rid)
		local err, redchest_freeticket1_num, redchest_freeticket1_lasttime, redchest_freeticket10_num, tacticcard_freeticket1_num, tacticcard_freeticket1_lasttime, tacticcard_freeticket10_num = xlDb_Query(sql)
		--print("QueryChouJiangInfo:",err,sql)
		if err == 0 then
			nRedChestFree1Count = redchest_freeticket1_num
			strRedChestFree1LastTime = redchest_freeticket1_lasttime
			nRedChestFree10Count = redchest_freeticket10_num
			nTacticcardFree1Count = tacticcard_freeticket1_num
			strTacticcardFree1LastTime = tacticcard_freeticket1_lasttime
			nTacticcardFree10Count = tacticcard_freeticket10_num
			
			--今日时间戳
			local nTimestampNow = os.time()
			
			--神器宝箱抽一次
			--转化为服务器上次操作时间的0点天的时间戳
			local nTimestamp = hApi.GetNewDate(strRedChestFree1LastTime)
			local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --转字符串(年月日)
			local strNewdate = strDatestampYMD .. " 00:00:00"
			local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1)
			--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
			--到了第二天
			if (nTimestampNow >= nTimestampTodayZero) then
				--重置次数
				nRedChestFree1Count = ShopMgr.CHOUJIANG_REDCHEST_ONCE_FREE_COUNT_DAILY
			end
			
			--战术卡包抽一次
			--转化为服务器上次操作时间的0点天的时间戳
			local nTimestamp = hApi.GetNewDate(strTacticcardFree1LastTime)
			local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --转字符串(年月日)
			local strNewdate = strDatestampYMD .. " 00:00:00"
			local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1)
			--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
			--到了第二天
			if (nTimestampNow >= nTimestampTodayZero) then
				--重置次数
				nTacticcardFree1Count = ShopMgr.CHOUJIANG_TACTICCARD_ONCE_FREE_COUNT_DAILY
			end
		end
		
		--神器宝箱抽一次需要的游戏币
		local cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_ONCE_SHOPINDEX
		if (nRedChestFree1Count > 0) then
			cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_ONCE_FREE_SHOPINDEX
		end
		local shopItemId = hVar.tab_shop[ShopMgr.CHOUJIANG_SHOP_ID].goods[cItemIdx]
		local tabShopItem = hVar.tab_shopitem[shopItemId]
		nRedChest1RmbCost = tabShopItem.rmb
		nRedChest1ItemId = tabShopItem.itemID
		
		
		--神器宝箱抽十次需要的游戏币
		local cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_TENTH_SHOPINDEX
		if (nRedChestFree10Count > 0) then
			cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_TENTH_FREE_SHOPINDEX
		end
		local shopItemId = hVar.tab_shop[ShopMgr.CHOUJIANG_SHOP_ID].goods[cItemIdx]
		local tabShopItem = hVar.tab_shopitem[shopItemId]
		nRedChest10RmbCost = tabShopItem.rmb
		nRedChest10ItemId = tabShopItem.itemID
		
		--战术卡抽一次需要游戏币
		local cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_ONCE_SHOPINDEX
		if (nTacticcardFree1Count > 0) then
			cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_ONCE_FREE_SHOPINDEX
		end
		local shopItemId = hVar.tab_shop[ShopMgr.CHOUJIANG_SHOP_ID].goods[cItemIdx]
		local tabShopItem = hVar.tab_shopitem[shopItemId]
		nTacticcard1RmbCost = tabShopItem.rmb
		nTacticcard1ItemId = tabShopItem.itemID
		
		--战术卡抽十次需要游戏币
		local cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_TENTH_SHOPINDEX
		if (nTacticcardFree10Count > 0) then
			cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_TENTH_FREE_SHOPINDEX
		end
		local shopItemId = hVar.tab_shop[ShopMgr.CHOUJIANG_SHOP_ID].goods[cItemIdx]
		local tabShopItem = hVar.tab_shopitem[shopItemId]
		nTacticcard10RmbCost = tabShopItem.rmb
		nTacticcard10ItemId = tabShopItem.itemID
		
		return nRedChestFree1Count, nRedChestFree10Count, nTacticcardFree1Count, nTacticcardFree10Count,
			nRedChest1RmbCost, nRedChest10RmbCost, nTacticcard1RmbCost, nTacticcard10RmbCost,
			nRedChest1ItemId, nRedChest10ItemId, nTacticcard1ItemId, nTacticcard10ItemId
	end
	
	--新商店查询抽奖信息
	function ShopMgr:ShopQueryChouJiangInfo(uid, rid, channelId)
		local nRedChestFree1Count, nRedChestFree10Count, nTacticcardFree1Count, nTacticcardFree10Count,
			nRedChest1RmbCost, nRedChest10RmbCost, nTacticcard1RmbCost, nTacticcard10RmbCost,
			nRedChest1ItemId, nRedChest10ItemId, nTacticcard1ItemId, nTacticcard10ItemId = self:_QueryChouJiangInfo(uid, rid, channelId)
		
		local sCmd = tostring(nRedChestFree1Count) .. ";" .. tostring(nRedChestFree10Count) .. ";" .. tostring(nTacticcardFree1Count).. ";" .. tostring(nTacticcardFree10Count) .. ";"
			.. tostring(nRedChest1RmbCost) .. ";" .. tostring(nRedChest10RmbCost) .. ";" .. tostring(nTacticcard1RmbCost) .. ";" .. tostring(nTacticcard10RmbCost) .. ";"
		
		return sCmd
	end
	
	--新商店使用抽奖-神器宝箱抽一次
	function ShopMgr:ShopUseChouJiangRedChestOnce(uid, rid, channelId, iTag)
		local nRedChestFree1Count, nRedChestFree10Count, nTacticcardFree1Count, nTacticcardFree10Count,
			nRedChest1RmbCost, nRedChest10RmbCost, nTacticcard1RmbCost, nTacticcard10RmbCost,
			nRedChest1ItemId, nRedChest10ItemId, nTacticcard1ItemId, nTacticcard10ItemId = self:_QueryChouJiangInfo(uid, rid, channelId)
		
		local cShopId = ShopMgr.CHOUJIANG_SHOP_ID
		local cRedequipCrystal = false
		local cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_ONCE_SHOPINDEX
		if (nRedChestFree1Count > 0) then
			cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_ONCE_FREE_SHOPINDEX
		end
		local sL2CCmd,goods,nIsSuccess = self:BuyItem(uid, rid, cShopId, cItemIdx, cRedequipCrystal)
		
		--扣除免费次数
		if (nIsSuccess == 1) then
			if (nRedChestFree1Count > 0) then
				nRedChestFree1Count = nRedChestFree1Count - 1
				
				--恢复原价
				if (nRedChestFree1Count == 0) then
					cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_ONCE_SHOPINDEX
					local shopItemId = hVar.tab_shop[ShopMgr.CHOUJIANG_SHOP_ID].goods[cItemIdx]
					local tabShopItem = hVar.tab_shopitem[shopItemId]
					nRedChest1RmbCost = tabShopItem.rmb
					nRedChest1ItemId = tabShopItem.itemID
				end
				
				--这里以nRedChestFree1Count的值为准，因为每日次数会重置
				--更新
				local sUpdate = string.format("UPDATE `t_cha` SET `redchest_freeticket1_num` = %d, `redchest_freeticket1_lasttime` = now() WHERE `id`= %d", nRedChestFree1Count, rid)
				xlDb_Execute(sUpdate)
			end
		end
		
		local sCmd = tostring(nIsSuccess) .. ";" .. tostring(iTag) .. ";" .. tostring(nRedChestFree1Count) .. ";" .. tostring(nRedChestFree10Count) .. ";" .. tostring(nTacticcardFree1Count).. ";"
			.. tostring(nTacticcardFree10Count) .. ";" .. tostring(nRedChest1RmbCost) .. ";" .. tostring(nRedChest10RmbCost) .. ";" .. tostring(nTacticcard1RmbCost) .. ";"
			.. tostring(nTacticcard10RmbCost) .. ";" .. sL2CCmd
		
		return sCmd
	end
	
	--新商店使用抽奖-神器宝箱抽十次
	function ShopMgr:ShopUseChouJiangRedChestTenth(uid, rid, channelId, iTag)
		local nRedChestFree1Count, nRedChestFree10Count, nTacticcardFree1Count, nTacticcardFree10Count,
			nRedChest1RmbCost, nRedChest10RmbCost, nTacticcard1RmbCost, nTacticcard10RmbCost,
			nRedChest1ItemId, nRedChest10ItemId, nTacticcard1ItemId, nTacticcard10ItemId = self:_QueryChouJiangInfo(uid, rid, channelId)
		
		local cShopId = ShopMgr.CHOUJIANG_SHOP_ID
		local cRedequipCrystal = false
		local cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_TENTH_SHOPINDEX
		if (nRedChestFree10Count > 0) then
			cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_TENTH_FREE_SHOPINDEX
		end
		local sL2CCmd,goods,nIsSuccess = self:BuyItem(uid, rid, cShopId, cItemIdx, cRedequipCrystal)
		
		--扣除免费次数
		if (nIsSuccess == 1) then
			if (nRedChestFree10Count > 0) then
				nRedChestFree10Count = nRedChestFree10Count - 1
				
				--恢复原价
				if (nRedChestFree10Count == 0) then
					cItemIdx = ShopMgr.CHOUJIANG_REDCHEST_TENTH_SHOPINDEX
					local shopItemId = hVar.tab_shop[ShopMgr.CHOUJIANG_SHOP_ID].goods[cItemIdx]
					local tabShopItem = hVar.tab_shopitem[shopItemId]
					nRedChest10RmbCost = tabShopItem.rmb
					nRedChest10ItemId = tabShopItem.itemID
				end
				
				--更新
				local sUpdate = string.format("UPDATE `t_cha` SET `redchest_freeticket10_num` = `redchest_freeticket10_num` - 1 WHERE `id`= %d", rid)
				xlDb_Execute(sUpdate)
			end
		end
		
		local sCmd = tostring(nIsSuccess) .. ";" .. tostring(iTag) .. ";" .. tostring(nRedChestFree1Count) .. ";" .. tostring(nRedChestFree10Count) .. ";" .. tostring(nTacticcardFree1Count).. ";"
			.. tostring(nTacticcardFree10Count) .. ";" .. tostring(nRedChest1RmbCost) .. ";" .. tostring(nRedChest10RmbCost) .. ";" .. tostring(nTacticcard1RmbCost) .. ";"
			.. tostring(nTacticcard10RmbCost) .. ";" .. sL2CCmd
		
		return sCmd
	end
	
	--新商店使用抽奖-战术卡包抽一次
	function ShopMgr:ShopUseChouJiangTacticCardOnce(uid, rid, channelId, iTag)
		local nRedChestFree1Count, nRedChestFree10Count, nTacticcardFree1Count, nTacticcardFree10Count,
			nRedChest1RmbCost, nRedChest10RmbCost, nTacticcard1RmbCost, nTacticcard10RmbCost,
			nRedChest1ItemId, nRedChest10ItemId, nTacticcard1ItemId, nTacticcard10ItemId = self:_QueryChouJiangInfo(uid, rid, channelId)
		
		local cShopId = ShopMgr.CHOUJIANG_SHOP_ID
		local cRedequipCrystal = false
		local cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_ONCE_SHOPINDEX
		if (nTacticcardFree1Count > 0) then
			cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_ONCE_FREE_SHOPINDEX
		end
		local sL2CCmd,goods,nIsSuccess = self:BuyItem(uid, rid, cShopId, cItemIdx, cRedequipCrystal)
		
		--扣除免费次数
		if (nIsSuccess == 1) then
			if (nTacticcardFree1Count > 0) then
				nTacticcardFree1Count = nTacticcardFree1Count - 1
				
				--恢复原价
				if (nTacticcardFree1Count == 0) then
					cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_ONCE_SHOPINDEX
					local shopItemId = hVar.tab_shop[ShopMgr.CHOUJIANG_SHOP_ID].goods[cItemIdx]
					local tabShopItem = hVar.tab_shopitem[shopItemId]
					nTacticcard1RmbCost = tabShopItem.rmb
					nTacticcard1ItemId = tabShopItem.itemID
				end
				
				--这里以nTacticcardFree1Count的值为准，因为每日次数会重置
				--更新
				local sUpdate = string.format("UPDATE `t_cha` SET `tacticcard_freeticket1_num` = %d, `tacticcard_freeticket1_lasttime` = now() WHERE `id`= %d", nTacticcardFree1Count, rid)
				xlDb_Execute(sUpdate)
			end
		end
		
		local sCmd = tostring(nIsSuccess) .. ";" .. tostring(iTag) .. ";" .. tostring(nRedChestFree1Count) .. ";" .. tostring(nRedChestFree10Count) .. ";" .. tostring(nTacticcardFree1Count).. ";"
			.. tostring(nTacticcardFree10Count) .. ";" .. tostring(nRedChest1RmbCost) .. ";" .. tostring(nRedChest10RmbCost) .. ";" .. tostring(nTacticcard1RmbCost) .. ";"
			.. tostring(nTacticcard10RmbCost) .. ";" .. sL2CCmd
		
		return sCmd
	end
	
	--新商店使用抽奖-战术卡包抽十次
	function ShopMgr:ShopUseChouJiangTacticCardTenth(uid, rid, channelId, iTag)
		local nRedChestFree1Count, nRedChestFree10Count, nTacticcardFree1Count, nTacticcardFree10Count,
			nRedChest1RmbCost, nRedChest10RmbCost, nTacticcard1RmbCost, nTacticcard10RmbCost,
			nRedChest1ItemId, nRedChest10ItemId, nTacticcard1ItemId, nTacticcard10ItemId = self:_QueryChouJiangInfo(uid, rid, channelId)
		
		local cShopId = ShopMgr.CHOUJIANG_SHOP_ID
		local cRedequipCrystal = false
		local cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_TENTH_SHOPINDEX
		if (nTacticcardFree10Count > 0) then
			cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_TENTH_FREE_SHOPINDEX
		end
		local sL2CCmd,goods,nIsSuccess = self:BuyItem(uid, rid, cShopId, cItemIdx, cRedequipCrystal)
		
		--扣除免费次数
		if (nIsSuccess == 1) then
			if (nTacticcardFree10Count > 0) then
				nTacticcardFree10Count = nTacticcardFree10Count - 1
				
				--恢复原价
				if (nTacticcardFree10Count == 0) then
					cItemIdx = ShopMgr.CHOUJIANG_TACTICCARD_TENTH_SHOPINDEX
					local shopItemId = hVar.tab_shop[ShopMgr.CHOUJIANG_SHOP_ID].goods[cItemIdx]
					local tabShopItem = hVar.tab_shopitem[shopItemId]
					nTacticcard10RmbCost = tabShopItem.rmb
					nTacticcard10ItemId = tabShopItem.itemID
				end
				
				--更新
				local sUpdate = string.format("UPDATE `t_cha` SET `tacticcard_freeticket10_num` = `tacticcard_freeticket10_num` - 1 WHERE `id`= %d", rid)
				xlDb_Execute(sUpdate)
			end
		end
		
		local sCmd = tostring(nIsSuccess) .. ";" .. tostring(iTag) .. ";" .. tostring(nRedChestFree1Count) .. ";" .. tostring(nRedChestFree10Count) .. ";" .. tostring(nTacticcardFree1Count).. ";"
			.. tostring(nTacticcardFree10Count) .. ";" .. tostring(nRedChest1RmbCost) .. ";" .. tostring(nRedChest10RmbCost) .. ";" .. tostring(nTacticcard1RmbCost) .. ";"
			.. tostring(nTacticcard10RmbCost) .. ";" .. sL2CCmd
		
		return sCmd
	end
	
	--使用神器晶石兑换一次
	function ShopMgr:ShopUseRedCrystalExchangeOnce(uid, rid, channelId, iTag)
		local cShopId = ShopMgr.CHOUJIANG_SHOP_ID
		local cRedequipCrystal = true
		local cItemIdx = ShopMgr.RED_CRYSTAL_EXCHANGE_ONCE_SHOPINDEX
		local sL2CCmd,goods,nIsSuccess = self:BuyItem(uid, rid, cShopId, cItemIdx, cRedequipCrystal)
		
		local sCmd = tostring(nIsSuccess) .. ";" .. tostring(iTag) .. ";" .. sL2CCmd
		
		return sCmd
	end
	
	--使用神器晶石兑换十次
	function ShopMgr:ShopUseRedCrystalExchangeTenth(uid, rid, channelId, iTag)
		local cShopId = ShopMgr.CHOUJIANG_SHOP_ID
		local cRedequipCrystal = true
		local cItemIdx = ShopMgr.RED_CRYSTAL_EXCHANGE_TENTH_SHOPINDEX
		local sL2CCmd,goods,nIsSuccess = self:BuyItem(uid, rid, cShopId, cItemIdx, cRedequipCrystal)
		
		local sCmd = tostring(nIsSuccess) .. ";" .. tostring(iTag) .. ";" .. sL2CCmd
		
		return sCmd
	end
	
	--使用神器晶石兑换50次
	function ShopMgr:ShopUseRedCrystalExchangeFifty(uid, rid, channelId, iTag)
		local cShopId = ShopMgr.CHOUJIANG_SHOP_ID
		local cRedequipCrystal = true
		local cItemIdx = ShopMgr.RED_CRYSTAL_EXCHANGE_FIFTY_SHOPINDEX
		local sL2CCmd,goods,nIsSuccess = self:BuyItem(uid, rid, cShopId, cItemIdx, cRedequipCrystal)
		
		local sCmd = tostring(nIsSuccess) .. ";" .. tostring(iTag) .. ";" .. sL2CCmd
		
		return sCmd
	end
	
	--商店查询今日看广告次数信息
	function ShopMgr:ShopQueryAdvViewInfo(uid, rid, channelId, iTag)
		local strAdvView1LastTime = "1990-01-01 00:00:00" --上次看广告时间
		local tAdvViewCount = {}
		for i = 1, #hVar.tab_advertise, 1 do
			tAdvViewCount[i] = 0
		end
		
		--查询看广告次数
		local sql = string.format("SELECT `adv_view_lasttime`, `adv_view` FROM `t_cha` WHERE `id`=%d ", rid)
		local err, adv_view_lasttime, adv_view = xlDb_Query(sql)
		--print("QueryChouJiangInfo:",err,sql)
		if err == 0 then
			strAdvView1LastTime = adv_view_lasttime
			
			--今日时间戳
			local nTimestampNow = os.time()
			
			--看广告
			--转化为服务器上次操作时间的0点天的时间戳
			local nTimestamp = hApi.GetNewDate(strAdvView1LastTime)
			local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --转字符串(年月日)
			local strNewdate = strDatestampYMD .. " 00:00:00"
			local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1)
			--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
			--未到了第二天
			if (nTimestampNow < nTimestampTodayZero) then
				--解析看广告次数
				local tCount = hApi.Split(adv_view, ":")
				for i = 1, #tAdvViewCount, 1 do
					local count = tonumber(tCount[i]) or 0
					tAdvViewCount[i] = count
				end
			end
		end
		
		local szCount = ""
		for i = 1, #tAdvViewCount, 1 do
			szCount = szCount .. tostring(tAdvViewCount[i]) .. ":"
		end
		
		local sCmd = tostring(iTag) .. ";" .. tostring(#tAdvViewCount) .. ";" .. szCount .. ";"
		
		return sCmd
	end
	
	--商店今日看广告领取奖励
	function ShopMgr:ShopAdvViewTakeReward(uid, rid, channelId, nIndex, iTag)
		local ret = 0 --返回值
		local prizeId = 0 --奖励id
		local prizeContent = "" --奖励内容
		
		local strAdvView1LastTime = "1990-01-01 00:00:00" --上次看广告时间
		local tAdvViewCount = {}
		for i = 1, #hVar.tab_advertise, 1 do
			tAdvViewCount[i] = 0
		end
		
		--查询看广告次数
		local sql = string.format("SELECT `adv_view_lasttime`, `adv_view` FROM `t_cha` WHERE `id`=%d ", rid)
		local err, adv_view_lasttime, adv_view = xlDb_Query(sql)
		--print("QueryChouJiangInfo:",err,sql)
		if err == 0 then
			strAdvView1LastTime = adv_view_lasttime
			
			--今日时间戳
			local nTimestampNow = os.time()
			
			--看广告
			--转化为服务器上次操作时间的0点天的时间戳
			local nTimestamp = hApi.GetNewDate(strAdvView1LastTime)
			local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --转字符串(年月日)
			local strNewdate = strDatestampYMD .. " 00:00:00"
			local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1)
			--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
			--未到了第二天
			if (nTimestampNow < nTimestampTodayZero) then
				--解析看广告次数
				local tCount = hApi.Split(adv_view, ":")
				for i = 1, #tAdvViewCount, 1 do
					local count = tonumber(tCount[i]) or 0
					tAdvViewCount[i] = count
				end
			end
		end
		
		local tabAdv = hVar.tab_advertise[nIndex]
		if tabAdv then
			local count = tAdvViewCount[nIndex] or 0
			local reward = tabAdv.reward
			local reward1 = tabAdv.reward[1]
			local maxcount = tabAdv.maxcount or 0
			local leftcount = maxcount - count
			if (leftcount > 0) then
				--发奖
				local id = 20008
				local detail = string.format(hVar.tab_string["__TEXT_ADVVIEW_PRIZE"], reward1[1] or 0, reward1[2] or 0, reward1[3] or 0, reward1[4] or 0)
				local sInsert = string.format("insert into `prize`(uid,type,mykey,used) values (%d,%d,'%s',%d)",uid,id,detail,0)
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
					prizeContent = hApi.GetRewardInPrize(uid, rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
					
					--更新广告领奖次数
					tAdvViewCount[nIndex] = tAdvViewCount[nIndex] + 1
					
					--更新数据库
					local szCount = ""
					for i = 1, #tAdvViewCount, 1 do
						szCount = szCount .. tostring(tAdvViewCount[i]) .. ":"
					end
					local updateSql = string.format("UPDATE `t_cha` SET `adv_view`= '%s',`adv_view_lasttime` = now() WHERE `id`=%d", szCount, rid)
					xlDb_Execute(updateSql)
					
					--操作成功
					ret = 1
				end
			else
				ret = -1 --今日领奖次数用完
			end
		end
		
		local szCount = ""
		for i = 1, #tAdvViewCount, 1 do
			szCount = szCount .. tostring(tAdvViewCount[i]) .. ":"
		end
		
		local sCmd = tostring(ret) .. ";" .. tostring(nIndex) .. ";" .. tostring(iTag) .. ";" .. tostring(#tAdvViewCount) .. ";" .. szCount .. ";" .. tostring(prizeContent)
		
		return sCmd
	end
	
return ShopMgr