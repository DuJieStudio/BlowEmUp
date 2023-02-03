--商品类
local ShopItem = class("ShopItem")
	
	--构造函数
	function ShopItem:ctor()

		self._id = -1				--商品ID
		self._itemID = -1			--商品对应道具ID
		self._num = -1				--商品对应道具的数量(比如碎片20个)
		self._score = -1			--商品的售价(积分)
		self._rmb = -1				--商品的售价(rmb)
		self._crystal = -1			--商品的售价(红装晶石)，只有红装锦囊兑换会消耗红装晶石
		self._cangbaotu = -1			--商品的售价(藏宝图)，只有藏宝图商店兑换会消耗藏宝图
		self._cangbaotu_high = -1		--商品的售价(高级藏宝图)，只有高级藏宝图商店兑换会消耗藏宝图
		
		self._quota = -1			--可售卖次数(-1标示无数量限制)
		self._saleCount = -1			--可售卖次数(-1标示无数量限制)
		
		return self
	end
	
	--初始化函数
	function ShopItem:Init(id,quota,itemId,num,score,rmb,saledCount)
		
		local tShopItem = hVar.tab_shopitem[id]
		if tShopItem then
			
			self._id = id						--商品ID
			self._itemID = itemId or tShopItem.itemID		--商品对应道具ID
			self._num = num or tShopItem.num or 1			--商品对应道具的数量(比如碎片20个)
			self._score = score or tShopItem.score or 0		--商品的售价(积分)
			self._rmb = rmb or tShopItem.rmb or 0			--商品的售价(rmb)
			self._crystal = tShopItem.crystal or 0			--商品的售价(红装晶石)，只有红装锦囊兑换会消耗红装晶石
			self._cangbaotu = tShopItem.cangbaotu or 0		--商品的售价(藏宝图)，只有藏宝图商店兑换会消耗藏宝图
			self._cangbaotu_high = tShopItem.cangbaotu_high or 0	--商品的售价(高级藏宝图)，只有高级藏宝图商店兑换会消耗藏宝图
			
			self._quota = quota or -1				--可售卖次数(-1标示无数量限制)
			self._saledCount = saledCount or 0			--已售卖次数
			
			return self
		end
	end
	
	--------------------------------------------------------------------------------------------------------------
	--获取商品ID
	function ShopItem:GetID()
		return self._id
	end
	--获取商品对应道具ID
	function ShopItem:GetItemID()
		return self._itemID
	end
	--获取商品对应道具的数量
	function ShopItem:GetItemNum()
		return self._num
	end
	--获取商品的售价(积分)
	function ShopItem:GetScoreCost()
		return self._score
	end
	--获取商品的售价(rmb)
	function ShopItem:GetRmbCost()
		return self._rmb
	end
	--获取商品的售价(crystal)
	function ShopItem:GetCrystalCost()
		return self._crystal
	end
	--获取商品的售价(cangbaotu)
	function ShopItem:GetCangBaoTuCost()
		return self._cangbaotu
	end
	--获取商品的售价(cangbaotu_high)
	function ShopItem:GetCangBaoTuHighCost()
		return self._cangbaotu_high
	end
	--获取可售卖件数
	function ShopItem:GetQuota()
		return self._quota
	end
	--获取当前已经售卖件数
	function ShopItem:GetSaledCount()
		return self._saledCount
	end
	--增加当前已经售卖件数
	function ShopItem:AddSaledCount()
		self._saledCount = self._saledCount + 1
	end
	
	--获得未掉落红装次数
	function ShopItem:_DBGetNotGainRedEquipCount(uid)
		
		local sql = string.format("SELECT u.notgain_redequip FROM t_user as u where u.uid=%d",uid)
		local err,notgain_redequip = xlDb_Query(sql)
		if err == 0 then
			
		end
		
		return (notgain_redequip or 0)
	end
	
	--获得未掉落神器晶石兑换红装次数
	function ShopItem:_DBGetNotGainRedCrystalCount(uid)
		
		local sql = string.format("SELECT u.notgain_redcrystal FROM t_user as u where u.uid=%d",uid)
		local err,notgain_redcrystal = xlDb_Query(sql)
		if err == 0 then
			
		end
		
		return (notgain_redcrystal or 0)
	end
	
	--增加未掉落红装次数
	function ShopItem:_DBSetNotGainRedEquipCount(uid)
		
		local sql = string.format("UPDATE t_user SET `notgain_redequip` = `notgain_redequip` + 1 where uid=%d",uid)
		local err = xlDb_Execute(sql)
	end
	
	--增加未掉落红装次数*5
	function ShopItem:_DBSetNotGainRedEquipCount5(uid)
		
		local sql = string.format("UPDATE t_user SET `notgain_redequip` = `notgain_redequip` + 5 where uid=%d",uid)
		local err = xlDb_Execute(sql)
	end
	
	--增加未掉落红装次数*10
	function ShopItem:_DBSetNotGainRedEquipCount10(uid)
		
		local sql = string.format("UPDATE t_user SET `notgain_redequip` = `notgain_redequip` + 10 where uid=%d",uid)
		local err = xlDb_Execute(sql)
	end
	
	--清空未掉落红装次数
	function ShopItem:_DBClearNotGainRedEquipCount(uid)
		local sql = string.format("UPDATE t_user SET `notgain_redequip` = 0 where uid=%d",uid)
		local err = xlDb_Execute(sql)
	end
	
	--增加未掉落兑换神器晶石红装次数
	function ShopItem:_DBSetNotGainRedCrystalCount(uid)
		
		local sql = string.format("UPDATE t_user SET `notgain_redcrystal` = `notgain_redcrystal` + 1 where uid=%d",uid)
		local err = xlDb_Execute(sql)
	end
	
	--增加未掉落兑换神器晶石红装次数*5
	function ShopItem:_DBSetNotGainRedCrystalCount5(uid)
		
		local sql = string.format("UPDATE t_user SET `notgain_redcrystal` = `notgain_redcrystal` + 5 where uid=%d",uid)
		local err = xlDb_Execute(sql)
	end
	
	--增加未掉落兑换神器晶石红装次数*10
	function ShopItem:_DBSetNotGainRedCrystalCount10(uid)
		
		local sql = string.format("UPDATE t_user SET `notgain_redcrystal` = `notgain_redcrystal` + 10 where uid=%d",uid)
		local err = xlDb_Execute(sql)
	end
	
	--清空未掉落兑换神器晶石红装次数
	function ShopItem:_DBClearNotGainRedCrystalCount(uid)
		local sql = string.format("UPDATE t_user SET `notgain_redcrystal` = 0 where uid=%d",uid)
		local err = xlDb_Execute(sql)
	end
	
	--玩家获取道具
	--处理流程todo
	--根据不同商品产生不同reward
	--user:takereward
	--根据不同商品刷新不同的数据
	function ShopItem:DBGetItem(udbid, rid, cRedequipCrystal)
		
		local ret = false
		local itemId = self:GetItemID()
		local itemNum = self:GetItemNum()
		--print(itemId,itemNum)
		--如果道具id合法，并且道具数量大于0
		if itemId > 0 and hVar.tab_item[itemId] and itemNum > 0 then
			
			--锦囊道具
			if itemId >= hClass.Chest.TYPE.COPPER and itemId <= hClass.Chest.TYPE.CHEST_TYPE_MAXNUM then
				
				if itemId >= hClass.Chest.TYPE.COPPER and itemId <= hClass.Chest.TYPE.GOLD then --普通锦囊
					--todo
				elseif itemId == hClass.Chest.TYPE.ARENA then --擂台锦囊
					--todo
				elseif (itemId == hClass.Chest.TYPE.REDEQUIP) or (itemId == hClass.Chest.TYPE.REDEQUIP_CRYSTAL) then --红装锦囊、神器晶石兑换
					
					local chest = hClass.Chest:create():Init(itemId,0)	--红装锦囊
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local notgain_redequip = 0
						local NOTGAIN_MAX = 0
						if cRedequipCrystal then
							--神器晶石兑换
							notgain_redequip = self:_DBGetNotGainRedCrystalCount(udbid)
							NOTGAIN_MAX = hVar.NOTGAIN_REDCRYSTAL_MAX
						else
							--神器锦囊
							notgain_redequip = self:_DBGetNotGainRedEquipCount(udbid)
							NOTGAIN_MAX = hVar.NOTGAIN_REDEQUIP_MAX
						end
						local chestid = chest:GetID()
						local mustRed = false
						
						if notgain_redequip >= NOTGAIN_MAX then
							mustRed = true
						end
						
						local reward = chest:Open(mustRed)
						--如果正常开出了道具，则丢给user处理
						if reward then
							--剩余开启时间 * 每秒消耗的游戏币
							
							--服务器处理宝箱数据
							if cRedequipCrystal then
								reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_REDDEBRIS"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDDEBRIS)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							else
								reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_REDCHEST"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDCHEST)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							end
							self:AddSaledCount()
							--如果未获得红装则需要增加统计值,否则清空该值
							if not reward:HaveDrop(hClass.Reward.TYPE.REDEQUIP) then
								if cRedequipCrystal then
									--神器晶石兑换
									self:_DBSetNotGainRedCrystalCount(udbid)
								else
									--神器锦囊
									self:_DBSetNotGainRedEquipCount(udbid)
								end
							else
								if cRedequipCrystal then
									--神器晶石兑换
									self:_DBClearNotGainRedCrystalCount(udbid)
								else
									--神器锦囊
									self:_DBClearNotGainRedEquipCount(udbid)
								end
							end
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.REDEQUIP_FIVE) or (itemId == hClass.Chest.TYPE.REDEQUIP_CRYSTAL_FIVE) then --红装锦囊*5、神器晶石兑换*5
					
					local chest = hClass.Chest:create():Init(itemId,0)	--红装锦囊
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local notgain_redequip = 0
						local NOTGAIN_MAX = 0
						if cRedequipCrystal then
							--神器晶石兑换
							notgain_redequip = self:_DBGetNotGainRedCrystalCount(udbid)
							NOTGAIN_MAX = hVar.NOTGAIN_REDCRYSTAL_MAX
						else
							--神器锦囊
							notgain_redequip = self:_DBGetNotGainRedEquipCount(udbid)
							NOTGAIN_MAX = hVar.NOTGAIN_REDEQUIP_MAX
						end
						local chestid = chest:GetID()
						local mustRed = false
						
						if notgain_redequip >= NOTGAIN_MAX then
							mustRed = true
						end
						
						local reward = chest:Open(mustRed)
						--如果正常开出了道具，则丢给user处理
						if reward then
							--剩余开启时间 * 每秒消耗的游戏币
							
							--服务器处理宝箱数据
							if cRedequipCrystal then
								reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_REDDEBRIS"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDDEBRIS)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							else
								reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_REDCHEST"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDCHEST)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							end
							self:AddSaledCount()
							--如果未获得红装则需要增加统计值,否则清空该值
							if not reward:HaveDrop(hClass.Reward.TYPE.REDEQUIP) then
								if cRedequipCrystal then
									--神器晶石兑换
									self:_DBSetNotGainRedCrystalCount5(udbid)
								else
									--神器锦囊
									self:_DBSetNotGainRedEquipCount5(udbid)
								end
							else
								if cRedequipCrystal then
									--神器晶石兑换
									self:_DBClearNotGainRedCrystalCount(udbid)
								else
									--神器锦囊
									self:_DBClearNotGainRedEquipCount(udbid)
								end
							end
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.CANGBAOTU_NORMAL_CRYSTAL) then --藏宝图兑换
					
					local chest = hClass.Chest:create():Init(itemId,0)	--藏宝图
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local chestid = chest:GetID()
						local reward = chest:Open()
						--如果正常开出了道具，则丢给user处理
						if reward then
							--剩余开启时间 * 每秒消耗的游戏币
							
							--服务器处理宝箱数据
							reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_CANGBAOTU"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_CANGBAOTU)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							self:AddSaledCount()
							
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.CANGBAOTU_HIGH_CRYSTAL) then --高级藏宝图兑换
					
					local chest = hClass.Chest:create():Init(itemId,0)	--高级藏宝图
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local chestid = chest:GetID()
						local reward = chest:Open()
						--如果正常开出了道具，则丢给user处理
						if reward then
							--剩余开启时间 * 每秒消耗的游戏币
							
							--服务器处理宝箱数据
							reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_CANGBAOTU_HIGH"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_CANGBAOTU_HIGH)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							self:AddSaledCount()
							
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.YELLOWEQUIP) or (itemId == hClass.Chest.TYPE.YELLOWEQUIP_FIVE) then --黄装锦囊、黄装锦囊*5
					
					local chest = hClass.Chest:create():Init(itemId,0)	--黄装锦囊
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local chestid = chest:GetID()
						local reward = chest:Open()
						--如果正常开出了道具，则丢给user处理
						if reward then
							--剩余开启时间 * 每秒消耗的游戏币
							
							--服务器处理宝箱数据
							reward:TakeReward(udbid, rid, nil, cRedequipCrystal)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							self:AddSaledCount()
							
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.REDCHEST_ONCE) or (itemId == hClass.Chest.TYPE.REDCHEST_ONCE_FREE) then --神器宝箱抽一次、神器宝箱免费抽一次
					
					local chest = hClass.Chest:create():Init(itemId,0)	--红装锦囊
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local notgain_redequip = self:_DBGetNotGainRedEquipCount(udbid)
						local NOTGAIN_MAX = hVar.NOTGAIN_REDEQUIP_MAX
						local chestid = chest:GetID()
						local mustRed = false
						
						if notgain_redequip >= NOTGAIN_MAX then
							mustRed = true
						end
						
						local reward = chest:Open(mustRed)
						--如果正常开出了道具，则丢给user处理
						if reward then
							--剩余开启时间 * 每秒消耗的游戏币
							
							--服务器处理宝箱数据
							reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_REDCHEST"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDCHEST)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							
							self:AddSaledCount()
							--如果未获得红装则需要增加统计值,否则清空该值
							if not reward:HaveDrop(hClass.Reward.TYPE.REDEQUIP) then
								self:_DBSetNotGainRedEquipCount(udbid)
							else
								self:_DBClearNotGainRedEquipCount(udbid)
							end
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.REDCHEST_TENTH) or (itemId == hClass.Chest.TYPE.REDCHEST_TENTH_FREE) then --神器宝箱抽十次、神器宝箱免费抽十次
					
					local chest = hClass.Chest:create():Init(itemId,0)	--红装锦囊
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local notgain_redequip = self:_DBGetNotGainRedEquipCount(udbid)
						local NOTGAIN_MAX = hVar.NOTGAIN_REDEQUIP_MAX - 9 --抽十次，这十次也算作次数(N-1)
						local chestid = chest:GetID()
						local mustRed = false
						
						if notgain_redequip >= NOTGAIN_MAX then
							mustRed = true
						end
						
						local reward = chest:Open(mustRed)
						--如果正常开出了道具，则丢给user处理
						if reward then
							--剩余开启时间 * 每秒消耗的游戏币
							
							--服务器处理宝箱数据
							reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_REDCHEST"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDCHEST)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							
							self:AddSaledCount()
							--如果未获得红装则需要增加统计值,否则清空该值
							if not reward:HaveDrop(hClass.Reward.TYPE.REDEQUIP) then
								self:_DBSetNotGainRedEquipCount10(udbid)
							else
								self:_DBClearNotGainRedEquipCount(udbid)
							end
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.TACTICCARD_ONCE) or (itemId == hClass.Chest.TYPE.TACTICCARD_ONCE_FREE)
				or (itemId == hClass.Chest.TYPE.TACTICCARD_TENTH) or (itemId == hClass.Chest.TYPE.TACTICCARD_TENTH_FREE) then --战术卡包抽一次、战术卡包免费抽一次、战术卡包抽十次、战术卡包免费抽十次
					
					local chest = hClass.Chest:create():Init(itemId,0)	--红装锦囊
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local chestid = chest:GetID()
						local reward = chest:Open()
						--如果正常开出了道具，则丢给user处理
						if reward then
							--剩余开启时间 * 每秒消耗的游戏币
							
							--服务器处理宝箱数据
							reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_REDCHEST"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDCHEST)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							
							self:AddSaledCount()
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.REDEQUIP_CRYSTAL_TENTH) then --神器晶石兑换十次
					local chest = hClass.Chest:create():Init(itemId,0)	--红装锦囊
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local notgain_redequip = self:_DBGetNotGainRedCrystalCount(udbid)
						local NOTGAIN_MAX = hVar.NOTGAIN_REDCRYSTAL_MAX - 9 --抽十次，这十次也算作次数(N-1)
						local chestid = chest:GetID()
						local mustRed = false
						
						if notgain_redequip >= NOTGAIN_MAX then
							mustRed = true
						end
						
						local reward = chest:Open(mustRed)
						--如果正常开出了道具，则丢给user处理
						if reward then
							--剩余开启时间 * 每秒消耗的游戏币
							
							--服务器处理宝箱数据
							reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_REDDEBRIS"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDDEBRIS)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							
							self:AddSaledCount()
							--如果未获得红装则需要增加统计值,否则清空该值
							if not reward:HaveDrop(hClass.Reward.TYPE.REDEQUIP) then
								self:_DBSetNotGainRedCrystalCount10(udbid)
							else
								self:_DBClearNotGainRedCrystalCount(udbid)
							end
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.REDEQUIP_CRYSTAL_FIFTY) then --神器晶石兑换50次
					local chest = hClass.Chest:create():Init(itemId,0)	--红装锦囊
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						--local notgain_redequip = self:_DBGetNotGainRedCrystalCount(udbid)
						local NOTGAIN_MAX = 0 --抽50次，必出红装
						local chestid = chest:GetID()
						local mustRed = true
						
						--if notgain_redequip >= NOTGAIN_MAX then
						--	mustRed = true
						--end
						
						local reward = chest:Open(mustRed)
						--如果正常开出了道具，则丢给user处理
						if reward then
							--剩余开启时间 * 每秒消耗的游戏币
							
							--服务器处理宝箱数据
							reward:TakeReward(udbid, rid, nil, cRedequipCrystal, hVar.tab_string["__TEXT_REWARDTYPE_REDDEBRIS"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDDEBRIS)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							
							self:AddSaledCount()
							--如果未获得红装则需要增加统计值,否则清空该值
							--if not reward:HaveDrop(hClass.Reward.TYPE.REDEQUIP) then
							--	self:_DBSetNotGainRedCrystalCount10(udbid)
							--else
								self:_DBClearNotGainRedCrystalCount(udbid)
							--end
							ret = reward:ToCmd()
						end
					end
				elseif (itemId == hClass.Chest.TYPE.TACTICCEST) then --战术锦囊
					
					local chest = hClass.Chest:create():Init(itemId,0)	--战术锦囊
					
					if chest and type(chest) == "table" and chest:getCName() == "Chest" then
						local chestid = chest:GetID()
						local reward = chest:Open()
						--如果正常开出了道具，则丢给user处理
						if reward then
							--剩余开启时间 * 每秒消耗的游戏币
							
							--服务器处理宝箱数据
							reward:TakeReward(udbid, rid, nil, cRedequipCrystal)--self:_TakeReward(udbid, rid, reward, cRedequipCrystal)
							self:AddSaledCount()
							
							ret = reward:ToCmd()
						end
					end
				end
			--一般道具
			else
				local itemType = hVar.tab_item[itemId].type
				
				local rollDrop = {}
				if itemType == hVar.ITEM_TYPE.TACTICDEBRIS then --战术卡碎片
					rollDrop[1] = hClass.Reward.TYPE.TACTICDEBRIS
					rollDrop[2] = itemId
					rollDrop[3] = itemNum
				elseif itemType == hVar.ITEM_TYPE.SOULSTONE then --英雄将魂
					rollDrop[1] = hClass.Reward.TYPE.HERODEBRIS
					rollDrop[2] = itemId
					rollDrop[3] = itemNum
				elseif itemType == hVar.ITEM_TYPE.CANGBAOTU_NORMAL then --藏宝图
					rollDrop[1] = hClass.Reward.TYPE.CANGBAOTU_NORMAL
					rollDrop[2] = itemNum
					rollDrop[3] = 0
				elseif itemType == hVar.ITEM_TYPE.CANGBAOTU_HIGH then --高级藏宝图
					rollDrop[1] = hClass.Reward.TYPE.CANGBAOTU_HIGH
					rollDrop[2] = itemNum
					rollDrop[3] = 0
				elseif itemType == hVar.ITEM_TYPE.WEAPONGUNDEBRIS then --武器枪碎片
					rollDrop[1] = hClass.Reward.TYPE.WEAPONGUN_DEBRIS
					rollDrop[2] = itemId
					rollDrop[3] = itemNum
				elseif itemType == hVar.ITEM_TYPE.PETDEBRIS then --宠物碎片
					rollDrop[1] = hClass.Reward.TYPE.PET_DEBRIS
					rollDrop[2] = itemId
					rollDrop[3] = itemNum
				elseif (itemType == hVar.ITEM_TYPE.WEAPON) or (itemType == hVar.ITEM_TYPE.BODY) or (itemType == hVar.ITEM_TYPE.ORNAMENTS) or (itemType == hVar.ITEM_TYPE.MOUNT) then --道具
					--rollDrop[1] = hClass.Reward.TYPE.EQUIPITEM
					rollDrop[1] = hClass.Reward.TYPE.REDEQUIP
					rollDrop[2] = itemId
					rollDrop[3] = 0
					rollDrop[4] = 0
				end
				
				local reward = hClass.Reward:create():Init()
				reward:Add(rollDrop)
				
				if reward then
					reward:TakeReward(udbid, rid)--self:_TakeReward(udbid, rid, reward)
					self:AddSaledCount()
					ret = reward:ToCmd()
				end
			end
		end
		
		return ret
		
	end
	
	--基本信息转化
	function ShopItem:InfoToCmd()
		local cmd = tostring(self:GetID()) .. ":" .. tostring(self:GetItemID()) .. ":" .. tostring(self:GetItemNum()) .. ":".. tostring(self:GetScoreCost()) .. ":" .. tostring(self:GetRmbCost()) .. ":" .. tostring(self:GetQuota()) .. ":" .. tostring(self:GetSaledCount()) .. ";"
		return cmd
	end
return ShopItem