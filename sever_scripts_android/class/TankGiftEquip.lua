--战车特惠礼包装备类
local TankGiftEquip = class("TankGiftEquip")
	
	--特惠礼包商店id
	TankGiftEquip.SHOPITEM_ID = 403
	
	--构造函数
	function TankGiftEquip:ctor()
		self._uid = -1
		self._rid = -1
		
		return self
	end
	
	--初始化
	function TankGiftEquip:Init(uid, rid)
		self._uid = uid
		self._rid = rid
		
		return self
	end
	
	--查询玩家特惠礼包装备信息
	function TankGiftEquip:QueryInfo()
		local strCmd = ""
		
		--读取玩家已购买的特惠礼包装备数据
		local tBuyCount = {}
		local totalNum = hVar.SHOP_GIFT_EQUIP_LIST.totalNum --礼包总数量
		--初始化
		for i = 1, totalNum, 1 do
			tBuyCount[i] = 0
		end
		local sql = string.format("SELECT `gift_equip` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, gift_equip = xlDb_Query(sql)
		--print("sql:",sql,e,gift_equip, type(gift_equip))
		if (e == 0) then
			local tCmd = hApi.Split(gift_equip, ";")
			for i = 1, totalNum, 1 do
				local buycount = tonumber(tCmd[i]) or 0
				tBuyCount[i] = buycount
			end
		end
		
		--转字符串
		for i = 1, totalNum, 1 do
			local tInfo = hVar.SHOP_GIFT_EQUIP_LIST[i]
			local prize = tInfo.prize --奖励
			local maxcount = tInfo.maxcount --最大购买次数
			local goldCost = tInfo.goldCost --需要的游戏币
			local buycount = tBuyCount[i]
			
			local tmp = prize .. ":" .. goldCost .. ":" .. buycount .. ":" .. maxcount .. ";"
			strCmd = strCmd .. tmp
		end
		
		strCmd = tostring(totalNum) .. ";" .. strCmd
		
		return strCmd
	end
	
	--玩家购买特惠礼包装备
	function TankGiftEquip:BuyItem(shopIdx)
		local ret = 0 --返回值
		local sCmd = ""
		
		--读取玩家已购买的特惠礼包装备数据
		local tBuyCount = {}
		local totalNum = hVar.SHOP_GIFT_EQUIP_LIST.totalNum --礼包总数量
		--初始化
		for i = 1, totalNum, 1 do
			tBuyCount[i] = 0
		end
		local sql = string.format("SELECT `gift_equip` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, gift_equip = xlDb_Query(sql)
		--print("sql:",sql,e,gift_equip, type(gift_equip))
		if (e == 0) then
			local tCmd = hApi.Split(gift_equip, ";")
			for i = 1, totalNum, 1 do
				local buycount = tonumber(tCmd[i]) or 0
				tBuyCount[i] = buycount
			end
		end
		
		--特惠礼包装备信息
		local tInfo = hVar.SHOP_GIFT_EQUIP_LIST[shopIdx]
		if tInfo then
			local prize = tInfo.prize --奖励
			local maxcount = tInfo.maxcount --最大购买次数
			local goldCost = tInfo.goldCost --需要的游戏币
			local buycount = tBuyCount[shopIdx]
			local leftcount = maxcount - buycount
			if (leftcount > 0) then
				--检测游戏币是否足够
				--订单
				local tabShopItem = hVar.tab_shopitem[TankGiftEquip.SHOPITEM_ID]
				local itemId = tabShopItem.itemID
				local bSuccess, order_id = hGlobal.userCoinMgr:DBUserPurchase(self._uid, self._rid, itemId, 1, goldCost, 0, tostring(shopIdx) .. ";" .. prize .. ";")
				if bSuccess then
					--发奖
					--领取奖励
					local prizeType = 20008 --奖励类型
					local detail = ""
					detail = detail .. string.format(hVar.tab_string["__TEXT_GIFT_EQUIP_REWARD"], shopIdx) .. ";"
					local tReward = reward
					detail = detail .. tostring(prize) .. ";"
					
					--发奖
					local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",self._uid,prizeType,detail,0,0)
					xlDb_Execute(sInsert)
					
					--奖励id
					local err1, pid = xlDb_Query("select last_insert_id()")
					if (err1 == 0) then
						--存储奖励信息
						local prizeId = pid --奖励id
						
						--服务器发奖
						local fromIdx = 2
						local prizeContent = hApi.GetRewardInPrize(self._uid, self._rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
						sCmd = sCmd .. prizeContent
					end
					
					--更新已购买次数
					tBuyCount[shopIdx] = buycount + 1
					
					--存档
					local sBuyCounts = ""
					for i = 1, totalNum, 1 do
						sBuyCounts = sBuyCounts .. tostring(tBuyCount[i]) .. ";"
					end
					local sUpdate = string.format("UPDATE `t_cha` SET `gift_equip` = '%s' where `id` = %d", sBuyCounts, self._rid)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
					
					--操作成功
					ret = 1
				else
					ret = -3 --游戏币不足
				end
			else
				ret = -2 --商品已售罄
			end
		else
			ret = -1 --无效的商品索引
		end
		
		sCmd = tostring(ret) .. ";" .. tostring(shopIdx) .. ";" .. sCmd
		
		return sCmd
	end
	
return TankGiftEquip