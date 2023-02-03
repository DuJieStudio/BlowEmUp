--用户类
local User = class("User")
	
	--角色状态
	User.STATEINFO = 
	{
		UNINIT = -1,			--未初始化
		INIT = 1,			--初始化
		INHALL = 2,			--在大厅
		INROOM = 3,			--在房间
		INGAME = 4,			--在游戏
		INMATCH = 5,			--正在匹配中
	}

	User.DELAY_ARRAY_LEN = 60		--记录最近延时的数组的容量
	
	User.EVALUATE_MAX = 200			--竞技场积分的上限
	User.PVPCOIN_EVERYDAY_MAX = 100		--玩家每日领取兵符的上限
	User.CHEST_AMOUNT = 6			--玩家宝箱总数
	User.CHEST_REWARD_COST = 20		--获得宝箱需要的评价星星（目前现在这里进行配置）
	User.FREE_CHEST_REWARD_INTERVAL = 8	--免费宝箱获取间隔(单位小时)
	User.ARENA_CHEST_MAXNUM = 10		--擂台赛宝箱最大数量

	User.INVENTORY_SLOT_PAGE = 24		--每页多少道具格
	
	--用户初始化
	function User:SetInit()
		self._state = User.STATEINFO.INIT
	end
	--用户在大厅
	function User:SetInHall()
		self._state = User.STATEINFO.INHALL
		self._roomId = -1
		self._sessionId = -1
		self._matchId = -1
	end
	--用户在房间
	function User:SetInRoom(roomId)
		self._roomId = roomId
		self._state = User.STATEINFO.INROOM
		self._sessionId = -1
		self._matchId = -1
	end
	--用户在游戏
	function User:SetInGame(sessionId)
		self._state = User.STATEINFO.INGAME
		self._sessionId = sessionId
		self._matchId = -1
	end
	--用户正在匹配
	function User:SetInMatch(matchId)
		self._state = User.STATEINFO.INMATCH
		self._roomId = -1
		self._sessionId = -1
		self._matchId = matchId
	end
	--用户是否初始化
	function User:IsInit()
		local ret = false
		if self._state > User.STATEINFO.UNINIT then
			ret = true
		end
		return ret
	end
	--用户是否在大厅
	function User:IsInHall()
		local ret = false
		if self._state == User.STATEINFO.INHALL then
			ret = true
		end
		return ret
	end
	--用户是否在房间
	function User:IsInRoom()
		local ret = false
		if self._state == User.STATEINFO.INROOM then
			ret = true
		end
		return ret
	end
	--用户是否在游戏
	function User:IsInGame()
		local ret = false
		if self._state == User.STATEINFO.INGAME then
			ret = true
		end
		return ret
	end
	--用户是否正在匹配
	function User:IsInMatch()
		local ret = false
		if self._state == User.STATEINFO.INMATCH then
			ret = true
		end
		return ret
	end
	
	-------------------------------------------------------------------------------------------------
	--构造函数
	function User:ctor()
		--初始化私有变量
		self._id = -1				--内存id
		self._dbId = -1				--数据库id
		self._rId = -1				--当前使用的角色Id
		self._name = nil			--用户姓名
		self._gamecoin = -1			--用户游戏币
		self._gamescore = -1			--用户积分
		self._pvpcoin = -1			--用户兵符
		self._pvpcoin_last_gettime = -1		--兵符每日领取上一次领取时间
		self._evaluateE = -1			--娱乐模式累计星星评价
		self._evaluateELog = -1			--历史上获得的所有星星
		self._state = User.STATEINFO.UNINIT	--状态当前状态 -1未初始化
		self._roomId = -1			--进入房间id
		self._sessionId = -1			--进入游戏局id
		self._matchId = -1			--所在匹配房间id
		self._lastHeart = -1			--上一次心跳包时间
		self._delay = -1			--延时
		self._recentlyDelay = -1		--最近的延时
		self._delayIndex = -1			--最近的延时的偏移
		self._bTester = false
		self._bGM = false

		self._coppercount = -1			--开过的铜宝箱总量
		self._silvercount = -1			--开过的银宝箱总量
		self._goldcount = -1			--开过的金宝箱总量
		self._chestexp = -1			--开过的宝箱的总经验
		self._arenachest = 0			--擂台赛锦囊的当前数量
		self._arenachestOpen = 0		--擂台赛锦囊的历史上总数量
		self._freechest = -1			--免费箱子
		self._chestList = -1			--箱子列表
		
		self._itemMgr = -1			--道具管理
		self._heroMgr = -1			--英雄将魂管理
		self._tacticMgr = -1			--战术技能卡管理
		self._inventoryMgr = -1			--背包管理
		self._levelMgr = -1			--关卡管理

		--其他
		return self
	end
	--初始化函数
	function User:Init(id, dbId, rId)
		self._id = id
		self._dbId = dbId
		self._rId = rId
		--self._name = hVar.tab_string["__TEXT_PLAYER"].. tostring(dbId)
		--数据库获取用户数据
		if self:_DBGetUserInfo() then
			self._lastHeart = hApi.GetClock()
			self._delay = 0
			self._recentlyDelay = {}		--最近的延时
			self._delayIndex = 0			--最近的延时的偏移
			
			--多服务器结构，这里需要清除红装缓存
			hGlobal.redEquipUserCacheMgr:ClearRedEquipMgr(dbId, rId)
			
			self:SetInit()
		end
		return self
	end
	--release
	function User:Release()
		self._id = -1				--内存id
		self._dbId = -1				--数据库id
		self._rId = -1				--当前使用的角色Id
		self._name = nil			--用户姓名
		self._gamecoin = -1			--用户游戏币
		self._gamescore = -1			--用户积分
		self._pvpcoin = -1			--用户兵符
		self._pvpcoin_last_gettime = -1		--兵符每日领取上一次领取时间
		self._sBattlecfg = nil			--用户夺塔奇兵战斗配置
		self._sBattlecfg1 = nil			--用户铜雀台战斗配置
		self._evaluateE = -1			--娱乐模式累计星星评价
		self._evaluateELog = -1			--历史上获得的所有星星
		self._state = User.STATEINFO.UNINIT	--状态当前状态 -1未初始化
		self._roomId = -1			--进入房间id
		self._sessionId = -1			--进入游戏局id
		self._matchId = -1			--所在匹配房间id
		self._lastHeart = -1			--上一次心跳包时间
		self._delay = -1			--延时
		self._recentlyDelay = -1		--最近的延时
		self._delayIndex = -1			--最近的延时的偏移
		self._bTester = false
		self._bGM = false
		self._coppercount = -1			--开过的铜宝箱总量
		self._silvercount = -1			--开过的银宝箱总量
		self._goldcount = -1			--开过的金宝箱总量
		self._chestexp = -1			--开过的宝箱的总经验
		self._arenachest = 0			--擂台赛锦囊的当前数量
		self._arenachestOpen = 0		--擂台赛锦囊的历史上总数量
		self._freechest = -1			--免费箱子
		self._chestList = -1			--箱子列表

		--英雄将魂信息Release
		if self._tacticMgr and type(self._tacticMgr) == "table" and self._tacticMgr:getCName() == "TacticMgr" then
			self._tacticMgr:Release()
		end
		self._tacticMgr = -1			--战术技能卡管理
		
		--英雄将魂信息Release
		if self._heroMgr and type(self._heroMgr) == "table" and self._heroMgr:getCName() == "HeroMgr" then
			self._heroMgr:Release()
		end
		self._heroMgr = -1
		
		--道具管理Release
		if self._itemMgr and type(self._itemMgr) == "table" and self._itemMgr:getCName() == "RedEquipMgr" then
			self._itemMgr:Release()
		end
		self._itemMgr = -1
		
		self._inventoryMgr = -1			--背包管理
		self._levelMgr = -1			--关卡管理
		--todo

		return self
	end
	--获取是否是测试员
	function User:IsTesters()
		return self._bTester
	end
	--获取是否是管理员
	function User:IsGM()
		return self._bGM
	end
	
	--获取是否是管理员内部账号
	function User:IsGMInternal(dbId)
		local nIsGMInternal = 0
		
		local sql = string.format("SELECT `id` FROM `t_uid_internal` where `uid` = %d", dbId)
		local err, id = xlDb_Query(sql)
		if err == 0 then
			nIsGMInternal = 1
		end
		
		return nIsGMInternal
	end
	
	--获取当前状态
	function User:GetState()
		return self._state
	end
	--设置当前状态
	--function User:SetState(state)
	--	if state >= User.STATEINFO.UNINIT and state <= User.STATEINFO.INIT then
	--		self._state = state
	--	end
	--	return self
	--end
	--获取用户DBID
	function User:GetDBID()
		return self._dbId
	end
	--获取用户ID
	function User:GetID()
		return self._id
	end
	--获取用户使用角色ID
	function User:GetRID()
		return self._rId
	end
	--获取用户当前所在房间ID
	function User:GetInRoomID()
		return self._roomId
	end
	--获取用户当前所在游戏局ID
	function User:GetInGameID()
		return self._sessionId
	end
	--获取用户当前所在匹配房间
	function User:GetInMatchID()
		return self._matchId
	end

	--获取用户Name
	function User:GetName()
		return self._name
	end

	--获取用户娱乐模式累计星星评价
	function User:GetEvaluateE()
		return self._evaluateE
	end
	--获取用户历史上获得的所有星星
	function User:GetEvaluateELog()
		return self._evaluateELog
	end

	--开过的铜宝箱总量
	function User:GetCopperCount()
		return self._coppercount
	end
	--开过的银宝箱总量
	function User:GetSilverCount()
		return self._silvercount
	end
	--开过的金宝箱总量
	function User:GetGoldCount()
		return self._goldcount
	end
	--开过的宝箱的总经验
	function User:GetChestexp()
		return self._chestexp
	end
	--获取擂台赛锦囊
	function User:GetArenaChest()
		return self._arenachest
	end
	--增加擂台赛宝箱
	function User:AddArenaChest(num)
		self._arenachest = math.max(math.min(self._arenachest + num,10),0)	--擂台赛锦囊的当前数量
	end

	--设置用户战斗配置信息
	function User:SetBattleConfig(strCfg,cfgId)
		
	end
	--获得用户战斗配置信息
	function User:GetBattleConfig(cfgId)
		
		
	end
	--设置延时
	function User:SetDelay(delay)
		local timeNow = hApi.GetClock()
		self._delay = delay or 0
		self._lastHeart = timeNow
		
		--记录最近一段时间的延时
		self._recentlyDelay[self._delayIndex] = delay
		self._delayIndex = self._delayIndex + 1
		if self._delayIndex > User.DELAY_ARRAY_LEN then
			self._delayIndex = 0
		end
	end
	--获得延时
	function User:GetDelay()
		return self._delay
	end
	--获得最近的平均延时
	function User:GetRecentlyDelay()
		local delaySum = 0
		local delayNum = #self._recentlyDelay
		for i = 1, delayNum do
			delaySum = delaySum + self._recentlyDelay[i]
		end
		if delayNum == 0 then
			return 0
		end
		return math.ceil(delaySum / delayNum)
	end
	--获得上一次响应事件
	function User:GetLastHeart()
		return self._lastHeart
	end
	
	--增加评价星星
	function User:AddEvaluatePoint(evaluatePoint)
		if evaluatePoint >= 0 then
			self._evaluateELog = self._evaluateELog + evaluatePoint
			--如果大于最大值保持原状
			if self._evaluateE < User.EVALUATE_MAX then
				self._evaluateE = math.min(self._evaluateE + evaluatePoint,User.EVALUATE_MAX)
			end
		else
			self._evaluateE = self._evaluateE + evaluatePoint
		end
	end
	
	--购买匹配擂台赛入场券
	function User:BuyArenaEntrance(itemId, cost, ext)
		return self:_DBUserPurchase(itemId,1,cost,0,ext)
	end

	--返还匹配擂台赛入场券
	function User:ReturnArenaEntrance(itemId, cost, ext)
		--因为是扣钱，所以传进来正的cost要改成-cost
		return self:_DBUserPurchase(itemId,1,-cost,0,ext)
	end
	
	
	--------------------------------------------------------宝箱操作--------------------------------------------------------
	--领取宝箱
	function User:RewardChest(chestPos)
		local ret = false
		local chestId = hClass.Chest.TYPE.COPPER
		local chestGettime = hApi.GetTime()
		local dbid = self:GetDBID()
		local rid = self:GetRID()

		--免费宝箱
		if chestPos == 0 then
			local chest = self._freechest
			
			if chest and type(chest) == "table" and chest:getCName() == "Chest" then
				--User.FREE_CHEST_REWARD_INTERVAL*60
				--如果上一次获得宝箱时间已经经过了1天，并且已经领取过奖励变成free状态则重新发
				if (chestGettime >= chest:GetGettime() + User.FREE_CHEST_REWARD_INTERVAL*60*60 and chest:GetID() == hClass.Chest.TYPE.FREE) then
					self._freechest = hClass.Chest:create():Init(chestId,chestGettime)
					ret = true
				end
			else
				--如果不存在免费宝箱则重新发
				self._freechest = hClass.Chest:create():Init(chestId,chestGettime)
				ret = true
			end
		elseif chestPos > 0 and chestPos < User.CHEST_AMOUNT then
			local chest = self._chestList[chestPos]
			--如果箱子不存在
			if not chest or chest == 0 then

				local evaluateE = self:GetEvaluateE()
				if evaluateE >= User.CHEST_REWARD_COST then

					--预发箱子，未保存成功需要回退
					local r = math.random(1, 10000)
					if r >= 1 and r < 8000 then
						chestId = hClass.Chest.TYPE.SILVER
					elseif r >= 8000 and r <= 10000 then
						chestId = hClass.Chest.TYPE.GOLD
					end
					self._chestList[chestPos] = hClass.Chest:create():Init(chestId,chestGettime)	--箱子列表
					--扣星星评价
					self:AddEvaluatePoint(-User.CHEST_REWARD_COST)

					ret = self:SaveData(false, true, true, false, false)
					if not ret then
						--未保存成功需要回退
						self:AddEvaluatePoint(User.CHEST_REWARD_COST)
						self._chestList[chestPos] = nil
						self._chestList[chestPos] = 0
					end
				end
			end
		end

		return ret
	end
	
	--开锦囊
	function User:OpenChest(chestPos)
		local ret

		if chestPos == -1 then
			ret = self:_OpenArenaChest()
		else
			ret = self:_OpenNormalChest(chestPos)
		end
		return ret
	end

	--开普通的时间锦囊
	function User:_OpenNormalChest(chestPos)
		local ret
		local chest
		local dbid = self:GetDBID()

		--免费宝箱
		if chestPos == 0 then
			chest = self._freechest
		elseif chestPos > 0 and chestPos < User.CHEST_AMOUNT then
			chest = self._chestList[chestPos]
		end
		
		if chest and type(chest) == "table" and chest:getCName() == "Chest" then
			local chestid = chest:GetID()
			local reward = chest:Open()
			--如果正常开出了道具，则丢给user处理
			if reward then
				local ext = reward:ToCmd()
				local gamecoinCost = chest:GetOpenCost()
				
				--检测是否vip免费开宝箱
				if hGlobal.vipMgr:CheckOpenChestFree(dbid) then
					gamecoinCost = 0
					ext = ext.. ";vip"
				end

				--剩余开启时间 * 每秒消耗的游戏币
				--插入宝箱购买记录
				if self:_DBUserPurchase(chestid,1,gamecoinCost,0,ext) then

					--服务器处理宝箱数据
					self:_TakeReward(reward)
					
					--如果是免费宝箱，则设置宝箱为free
					if chestPos == 0 then
						self._freechest:SetTypeFree()
						self._coppercount = self._coppercount + 1				--开过的铜宝箱总量
						self._chestexp = self._chestexp + hClass.Chest.EXP.COPPER		--开宝箱得到的经验
						ret = chestid.. ";" .. reward:ToCmd()
					elseif chestPos > 0 and chestPos < User.CHEST_AMOUNT then
						--普通宝箱直接free掉
						self._chestList[chestPos] = nil
						self._chestList[chestPos] = 0
						
						if chestid == hClass.Chest.TYPE.SILVER then
							self._silvercount = self._silvercount + 1			--开过的银宝箱总量
							self._chestexp = self._chestexp + hClass.Chest.EXP.SILVER	--开宝箱得到的经验
						elseif chestid == hClass.Chest.TYPE.GOLD then
							self._goldcount = self._goldcount + 1				--开过的金宝箱总量
							self._chestexp = self._chestexp + hClass.Chest.EXP.GOLD		--开宝箱得到的经验
						end

						ret = chestid.. ";" .. reward:ToCmd()
					end
				
					----如果存档失败有可能会导致客户端的数据不一致
					local saveOk = self:SaveData(false, false, true, true, true)
					if saveOk then
						--self:_LogOpenChest(chestid,reward,1,0)
					else
						--self:_LogOpenChest(chestid,reward,0,0)
					end
				end
			end
		end

		return ret
	end
	
	--开擂台锦囊
	function User:_OpenArenaChest()
		local ret

		local arenaChestCount = self:GetArenaChest()

		if arenaChestCount > 0 then
			local arenaChestId = hClass.Chest.TYPE.ARENA
			local chest = hClass.Chest:create():Init(arenaChestId,0)	--箱子列表
			
			if chest and type(chest) == "table" and chest:getCName() == "Chest" then
				local chestid = chest:GetID()
				local reward = chest:Open()
				--如果正常开出了道具，则丢给user处理
				if reward then
					local gamecoinCost = chest:GetOpenCost()
					--剩余开启时间 * 每秒消耗的游戏币
					--插入宝箱购买记录
					if self:_DBUserPurchase(chestid,1,gamecoinCost,0,reward:ToCmd()) then

						--服务器处理宝箱数据
						self:_TakeReward(reward)
						
						self._arenachestOpen = self._arenachestOpen + 1			--擂台赛锦囊的历史上总数量
						self._chestexp = self._chestexp + hClass.Chest.EXP.ARENA	--开宝箱得到的经验
						ret = chestid.. ";" .. reward:ToCmd()

						self:AddArenaChest(-1)
					
						----如果存档失败有可能会导致客户端的数据不一致
						local saveOk = self:SaveData(false, false, true, true, true)
						if saveOk then
							--self:_LogOpenChest(chestid,reward,1,0)
						else
							--self:_LogOpenChest(chestid,reward,0,0)
						end
					end
				end
			end
		end

		return ret
	end
	
	--取得宝箱中的道具
	function User:_TakeReward(reward,takeList)

		local udbid = self:GetDBID()
		local rid = self:GetRID()

		--服务器处理宝箱数据
		local tReward = reward:GetInfo()
		for i = 1, reward:GetNum() do

			local canTake = false
			if takeList then
				for n = 1, #takeList do
					if takeList[n] == i then
						canTake = true
						break
					end
				end
			else
				canTake = true
			end
			
			if canTake then
				local rInfo = tReward[i] or {}
				local rewardType = tonumber(rInfo[1])
				
				--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
				if (rewardType == hClass.Reward.TYPE.SCORE) then --1:积分
					
					local rewardID = tonumber(rewardT[2]) or 0
					local addScore = rewardID --奖励的积分
					
					--新写法：读取奖励道具里面的奖励的积分
					if hVar.tab_item[rewardID] and (hVar.tab_item[rewardID].type == hVar.ITEM_TYPE.RESOURCES) then
						local resT = hVar.tab_item[rewardID].resource
						if resT and (type(resT) == "table") and (resT[1] == "score") then
							addScore = resT[2] or 0
						else
							addScore = 0
						end
					end
					
					--获得积分奖励
					if (addScore > 0) then
						self._gamescore = self._gamescore + addScore
					end

				elseif (rewardType == hClass.Reward.TYPE.TACTIC) then --2:战术技能卡
					--暂不支持
				elseif (rewardType == hClass.Reward.TYPE.EQUIPITEM) then --3:道具
					--暂不支持
				elseif (rewardType == hClass.Reward.TYPE.HEROCARD) then --4:英雄
					local heroId = tonumber(rewardT[2]) or 0
					local star = tonumber(rewardT[3]) or 1
					local lv = tonumber(rewardT[4]) or 1

					local hero = self._heroMgr:AddNewHero(heroId)
					if hero then
						hero:SetStar(star)
						hero:SetLv(lv)
					end

				elseif (rewardType == hClass.Reward.TYPE.HERODEBRIS) then --5:英雄将魂
					local itemId = tonumber(rInfo[2]) or 0
					local itemNum = tonumber(rInfo[3]) or 1
					if itemId > 0 and hVar.tab_item[itemId] and itemNum > 0 then
						local heroId = hVar.tab_item[itemId].heroID or 0
						if heroId > 0 then
							--添加英雄将魂
							self._heroMgr:AddHeroSoulstone(heroId,itemNum)
						end
					end
				elseif (rewardType == hClass.Reward.TYPE.TACTICDEBRIS) then --6:战术技能卡碎片
					local itemId = tonumber(rInfo[2]) or 0
					local itemNum = tonumber(rInfo[3]) or 1
					if itemId > 0 and hVar.tab_item[itemId] and itemNum > 0 then
						local tacticId = hVar.tab_item[itemId].tacticID or 0
						if tacticId > 0 then
							self:AddTactic(tacticId,itemNum)
						end
					end
				elseif (rewardType == hClass.Reward.TYPE.ONLINECOIN) then --7:游戏币
					local rmb = tonumber(rInfo[2] or 0)
					--内存
					self._gamecoin = self._gamecoin + rmb
					hGlobal.userCoinMgr:DBAddGamecoin(udbid,rmb)
				elseif (rewardType == hClass.Reward.TYPE.NETCHEST) then --8:网络宝箱
					local itemId = tonumber(rInfo[2] or 0)
					local itemNum = tonumber(rInfo[3] or 1)
					if itemId and itemId >= 9004 and itemId <= 9006 and itemNum > 0 then
						--铜9004,银9005,金9006
						self:_DBAddVii(itemId,itemNum)
					end
				elseif (rewardType == hClass.Reward.TYPE.DRAWCARD) then --9:抽奖类战术技能卡
					--暂不支持
				elseif (rewardType == hClass.Reward.TYPE.REDEQUIP) then --10:红装
					local itemId = tonumber(rInfo[2]) or 0
					local slotnum = tonumber(rInfo[3]) or -1
					local quality = tonumber(rInfo[4]) or 0 --品质
					--local redequipMgr = hClass.RedEquipMgr:create():Init(udbid, rid)
					local redequipMgr = hGlobal.redEquipUserCacheMgr:GetRedEquipMgr(udbid, rid)
					if redequipMgr then
						local equip = redequipMgr:DBAddEquip(itemId,slotnum,quality)
						reward:SetEntity(i, equip)
					end
				elseif (rewardType == hClass.Reward.TYPE.CRYSTAL) then --11:神装晶石
					local crystal = tonumber(rInfo[2] or 0)
					hGlobal.userCoinMgr:DBAddCrystal(udbid,crystal)
				end
			end
		end
	end
	
	--初始化宝箱信息
	function User:_InitChestInfo(chestInfo)

		local tChestInfo = hApi.Split(chestInfo, ";")
		local chestNum = tonumber(tChestInfo[1]) or User.CHEST_AMOUNT
		local infoIdx = 1
		
		--初始化宝箱表
		if self._chestList == -1 then
			self._chestList = {}
		end
		
		--遍历所有箱子
		for i = 1, chestNum do
			local chestList = tChestInfo[infoIdx + i] or ""
			local tChestList = hApi.Split(chestList,":")

			--第一个箱子是免费宝箱
			if i == 1 then
				local chestId = tonumber(tChestList[1]) or hClass.Chest.TYPE.FREE
				local chestGettime = tonumber(tChestList[2]) or 0

				self._freechest = hClass.Chest:create():Init(chestId,chestGettime)		--免费箱子
				
				--如果没有箱子，会自动给箱子
				self:RewardChest(0)
			else
				local chestId = tonumber(tChestList[1])
				local chestGettime = tonumber(tChestList[2])
				
				if chestId and chestId >= 0 and chestGettime and chestGettime > 0 then
					--如果没有箱子，会自动给箱子
					self._chestList[i - 1] = hClass.Chest:create():Init(chestId,chestGettime)	--箱子列表
					if not self._chestList[i - 1] then
						self._chestList[i - 1] = 0
					end
				else
					self._chestList[i - 1] = 0							--没有箱子初始化为0，否则无法用#遍历
				end
			end
		end
	end
	--------------------------------------------------------宝箱操作--------------------------------------------------------
	
	
	
	
	--------------------------------------------------------道具操作--------------------------------------------------------
	--初始化道具信息
	function User:_InitItemInfo(bFlag)
					
		--如果已经存在则先释放掉之前的数据
		if self._itemMgr and type(self._itemMgr) == "table" and self._itemMgr:getCName() == "RedEquipMgr" then
			self._itemMgr:Release()
		--else
		--	self._itemMgr = hClass.RedEquipMgr:create()
		end
		
		--初始化战术技能卡信息
		self._itemMgr = hClass.RedEquipMgr:create(bFlag):Init(self._dbId, self._rId)
	end
	--------------------------------------------------------道具操作--------------------------------------------------------
	
	
	
	
	
	--------------------------------------------------------战术卡操作--------------------------------------------------------
	--刷新战术卡附加属性
	function User:TacticRefreshAddOnes(id, idx)
		local ret

		local tactic = self._tacticMgr:GetTactic(id)

		if tactic and tactic:CheckCanRefreshAddOnes(idx) then
			--获取兵种卡升级所需的材料
			local itemId, materialList, gamecoin, score = tactic:GetRefreshAddOnesCost()

			--判定是否有足够的材料
			local materialEnough = true
			for i = 1, #materialList do
				local material = materialList[i]
				if material then
					if material.id > 0 then
						if material.num > 0 then
							local t = self._tacticMgr:GetTactic(material.id)
							if t then
								if t:GetDebris() < material.num then
									materialEnough = false
									break
								end
							end
						end
					end
				end
			end

			if materialEnough then

				--扣除游戏币
				if itemId > 0 and self:_DBUserPurchase(itemId,1,gamecoin,score,tactic:InfoToCmd()) then
					--扣除材料
					for i = 1, #materialList do
						local material = materialList[i]
						if material and material.id > 0 then
							if material.num > 0 then
								local t = self._tacticMgr:GetTactic(material.id)
								if t then
									t:AddDebris(-material.num)
								end
							end
						end
					end

					--刷新战术卡附加属性
					tactic:RefreshAddOnes(idx)
					
					--返回数据(商品id, 升级道具id, 金币消耗, 积分消耗)
					ret = itemId .. ";" .. gamecoin .. ";" .. score .. ";" .. idx .. ";" .. tactic:InfoToCmd()
					--如果存档失败有可能会导致客户端的数据不一致
					local saveOk = self:SaveData(false, false, false, true, false)
					if saveOk then
						--self:_LogOpenChest(chestid,reward,1,0)
					else
						--self:_LogOpenChest(chestid,reward,0,0)
					end
				end
			end
		end

		return ret
	end

	--新增一组战术卡附加属性
	function User:TacticNewAddOnes(id)
		local ret

		local tactic = self._tacticMgr:GetTactic(id)

		if tactic and tactic:CheckCanNewAddOnes() then
			--获取兵种卡升级所需的材料
			local itemId, materialList, gamecoin, score = tactic:GetNewAddOnesCost()

			----判定是否有足够的材料
			local materialEnough = true
			--for i = 1, #materialList do
			--	local material = materialList[i]
			--	if material then
			--		if material.id > 0 then
			--			if material.num > 0 then
			--				local t = self:_GetTactic(material.id)
			--				if t then
			--					if t:GetDebris() < material.num then
			--						materialEnough = false
			--						break
			--					end
			--				end
			--			end
			--		end
			--	end
			--end

			if materialEnough then

				--扣除游戏币
				if itemId > 0 and self:_DBUserPurchase(itemId,1,gamecoin,score,tactic:InfoToCmd()) then
					----扣除材料
					--for i = 1, #materialList do
					--	local material = materialList[i]
					--	if material and material.id > 0 then
					--		if material.num > 0 then
					--			local t = self:_GetTactic(material.id)
					--			if t then
					--				t:AddDebris(-material.num)
					--			end
					--		end
					--	end
					--end

					--新增一组战术卡附加属性
					tactic:NewAddOnes()
					
					--返回数据(商品id, 升级道具id, 金币消耗, 积分消耗)
					ret = itemId .. ";" .. gamecoin .. ";" .. score .. ";" .. tactic:GetAddOnsNum() .. ";" .. tactic:InfoToCmd()

					--如果存档失败有可能会导致客户端的数据不一致
					local saveOk = self:SaveData(false, false, false, true, false)
					if saveOk then
						--self:_LogOpenChest(chestid,reward,1,0)
					else
						--self:_LogOpenChest(chestid,reward,0,0)
					end
				end
			end
		end

		return ret
	end

	--还原一组战术卡附加属性
	function User:TacticRestoreAddOnes(id, idx)
		local ret

		local tactic = self._tacticMgr:GetTactic(id)
		--print("TacticRestoreAddOnes1:",tactic,tactic:CheckCanRestoreAddOnes(idx))
		if tactic and tactic:CheckCanRestoreAddOnes(idx) then
			--获取兵种卡升级所需的材料
			local itemId, materialList, gamecoin, score = tactic:GetRestoreAddOnesCost()

			----判定是否有足够的材料
			local materialEnough = true
			--for i = 1, #materialList do
			--	local material = materialList[i]
			--	if material then
			--		if material.id > 0 then
			--			if material.num > 0 then
			--				local t = self:_GetTactic(material.id)
			--				if t then
			--					if t:GetDebris() < material.num then
			--						materialEnough = false
			--						break
			--					end
			--				end
			--			end
			--		end
			--	end
			--end
			--print("TacticRestoreAddOnes2:",materialEnough)
			if materialEnough then
				--print("TacticRestoreAddOnes3:",itemId)
				--扣除游戏币
				if itemId > 0 and self:_DBUserPurchase(itemId,1,gamecoin,score,tactic:InfoToCmd()) then
					--print("TacticRestoreAddOnes4:",itemId)
					----扣除材料
					--for i = 1, #materialList do
					--	local material = materialList[i]
					--	if material and material.id > 0 then
					--		if material.num > 0 then
					--			local t = self:_GetTactic(material.id)
					--			if t then
					--				t:AddDebris(-material.num)
					--			end
					--		end
					--	end
					--end

					--新增一组战术卡附加属性
					tactic:RestoreAddOnes(idx)
					
					--返回数据(商品id, 升级道具id, 金币消耗, 积分消耗)
					ret = itemId .. ";" .. gamecoin .. ";" .. score .. ";" .. idx .. ";" .. tactic:InfoToCmd()

					--如果存档失败有可能会导致客户端的数据不一致
					local saveOk = self:SaveData(false, false, false, true, false)
					if saveOk then
						--self:_LogOpenChest(chestid,reward,1,0)
					else
						--self:_LogOpenChest(chestid,reward,0,0)
					end
				end
			end
		end

		return ret
	end

	--战术卡升级
	function User:TacticLvUp(id)
		
		local ret

		--判断星级
		local tactic = self._tacticMgr:GetTactic(id)
		
		--如果没有卡则需要创建一个
		if not tactic then
			if self._tacticMgr:AddTactic(id,0) then
				tactic = self._tacticMgr:GetTactic(id)
			end
		end
		
		--与判定角色将魂是否足够，英雄是否已经达到最大星级
		if tactic and tactic:CheckCanLvUp() then
			
			--获取兵种卡升级所需的材料
			local itemId, materialList, gamecoin, score = tactic:GetLvUpCost()

			--判定是否有足够的材料
			local materialEnough = true
			for i = 1, hVar.TACTIC_LVUP_INFO.maxMaterialType do
				local material = materialList[i]
				if material then
					if material.id > 0 then
						if material.num > 0 then
							local t = self._tacticMgr:GetTactic(material.id)
							if t then
								if t:GetDebris() < material.num then
									materialEnough = false
									break
								end
							end
						end
					end
				end
			end
			if materialEnough then

				--扣除游戏币
				if itemId > 0 and self:_DBUserPurchase(itemId,1,gamecoin,score,tactic:InfoToCmd()) then
					--扣除材料
					for i = 1, hVar.TACTIC_LVUP_INFO.maxMaterialType do
						local material = materialList[i]
						if material and material.id > 0 then
							if material.num > 0 then
								local t = self._tacticMgr:GetTactic(material.id)
								if t then
									t:AddDebris(-material.num)
								end
							end
						end
					end

					--兵种卡升级
					tactic:LvUp()
					
					--返回数据(商品id, 升级道具id, 金币消耗, 积分消耗)
					ret = itemId .. ";" .. gamecoin .. ";" .. score .. ";" .. tactic:InfoToCmd()
					--如果存档失败有可能会导致客户端的数据不一致
					local saveOk = self:SaveData(false, false, false, true, false)
					if saveOk then
						--self:_LogOpenChest(chestid,reward,1,0)
					else
						--self:_LogOpenChest(chestid,reward,0,0)
					end
				end
			end
		end
		
		return ret
	end

	--初始化战术技能卡信息
	function User:_InitTacticInfo(tacticInfo)

		--如果已经存在则先释放掉之前的数据
		if self._tacticMgr and type(self._tacticMgr) == "table" and self._tacticMgr:getCName() == "TacticMgr" then
			self._tacticMgr:Release()
		else
			self._tacticMgr = hClass.TacticMgr:create()
		end
		
		--初始化战术技能卡信息
		self._tacticMgr:Init(tacticInfo)
	end
	--------------------------------------------------------战术卡操作--------------------------------------------------------
	
	--------------------------------------------------------英雄操作--------------------------------------------------------
	
	--获取装备管理器
	function User:GetHeroMgr()
		return self._heroMgr
	end
	--英雄解锁
	function User:HeroUnlock(heroId)
		local ret

		--判断星级
		local hero = self._heroMgr:GetHero(heroId)
		--print("HeroUnlock:",hero,hero:CheckCanUnlock())
		
		--与判定角色将魂是否足够，英雄是否已经达到最大星级
		if hero and hero:CheckCanUnlock() then

			local shopItemId, itemId, gamecoinCost, score = hero:GetUnlockCost()

			--print("itemId:",itemId)
			--扣除游戏币
			if itemId > 0 and self:_DBUserPurchase(itemId,1,gamecoinCost,0,hero:InfoToCmd()) then
				
				--英雄升星
				hero:Unlock()
				
				--返回数据(商品id, 升级道具id, 金币消耗, 积分消耗)
				ret = shopItemId .. ";" .. itemId .. ";" .. gamecoinCost .. ";" .. score .. ";" .. hero:InfoToCmd()

				--如果存档失败有可能会导致客户端的数据不一致
				local saveOk = self:SaveData(false, false, false, false, true)
				if saveOk then
					--self:_LogOpenChest(chestid,reward,1,0)
				else
					--self:_LogOpenChest(chestid,reward,0,0)
				end
			end
		end
		
		return ret
	end
	
	--英雄升星
	function User:HeroStarLvUp(heroId)
		
		local ret

		--判断星级
		local hero = self._heroMgr:GetHero(heroId)
		
		--与判定角色将魂是否足够，英雄是否已经达到最大星级
		if hero and hero:CheckCanStarLvUp() then

			local shopItemId, itemId, gamecoinCost, score = hero:GetStarLvUpCost()
			--扣除游戏币
			if itemId > 0 and self:_DBUserPurchase(itemId,1,gamecoinCost,0,hero:InfoToCmd()) then
				
				--英雄升星
				hero:StarLvUp()
				
				--返回数据(商品id, 升级道具id, 金币消耗, 积分消耗)
				ret = shopItemId .. ";" .. itemId .. ";" .. gamecoinCost .. ";" .. score .. ";" .. hero:InfoToCmd()

				--如果存档失败有可能会导致客户端的数据不一致
				local saveOk = self:SaveData(false, false, false, false, true)
				if saveOk then
					--self:_LogOpenChest(chestid,reward,1,0)
				else
					--self:_LogOpenChest(chestid,reward,0,0)
				end
			end
		end
		
		return ret
	end
	
	--初始化英雄信息
	function User:_InitHeroInfo(heroInfo)
		
		--如果已经存在则先释放掉之前的数据
		if self._heroMgr and type(self._heroMgr) == "table" and self._heroMgr:getCName() == "HeroMgr" then
			self._heroMgr:Release()
		else
			self._heroMgr = hClass.HeroMgr:create()
		end
		
		--初始化战术技能卡信息
		self._heroMgr:Init(heroInfo)
	end

	--------------------------------------------------------英雄操作--------------------------------------------------------

	--------------------------------------------------------背包操作--------------------------------------------------------
	function User:_InitInventoryInfo(inventoryInfo)
		--如果已经存在则先释放掉之前的数据
		if self._inventoryMgr and type(self._inventoryMgr) == "table" and self._inventoryMgr:getCName() == "InventoryMgr" then
			self._inventoryMgr:Release()
		else
			self._inventoryMgr = hClass.InventoryMgr:create()
		end
		
		--获取当前Vip等级,根据vip等级获取背包最大上限
		local inventoryPage = hGlobal.vipMgr:GetInventoryCapacity(self:GetDBID())
		local capacity = inventoryPage * User.INVENTORY_SLOT_PAGE
		self._inventoryMgr:Init(capacity,inventoryInfo)
	end
	--------------------------------------------------------背包操作--------------------------------------------------------
	




	
	--------------------------------------------------------关卡操作--------------------------------------------------------
	function User:_InitLevelInfo(levelInfo)
		--如果已经存在则先释放掉之前的数据
		if self._levelMgr and type(self._levelMgr) == "table" and self._levelMgr:getCName() == "LevelMgr" then
			self._levelMgr:Release()
		else
			self._levelMgr = hClass.LevelMgr:create()
		end
		
		--初始化战术技能卡信息
		self._levelMgr:Init(levelInfo)
	end
	--------------------------------------------------------关卡操作--------------------------------------------------------
	





	--------------------------------------------------------数据库操作--------------------------------------------------------
	--每日领取兵符
	function User:DBGetPvpCoinEveryDay()
		local ret = true

		--如果玩家游戏币小于
		if self._pvpcoin < User.PVPCOIN_EVERYDAY_MAX then
			local pvpNow = math.min(self._pvpcoin + User.PVPCOIN_EVERYDAY_MAX, User.PVPCOIN_EVERYDAY_MAX)
			local pvpAdd = math.max(pvpNow - self._pvpcoin, 0)

			local err,dateNow = xlDb_Query("SELECT CURDATE()")
			if err == 0 then
				local timeNow = dateNow.. " 00:00:00"
				if self._pvpcoin_last_gettime < dateNow .. " 00:00:00" then
					--更新玩家金币
					--local sql = string.format("UPDATE t_user SET pvpcoin=pvpcoin+%d,last_every_day_pvpcoin_get_time=NOW() WHERE uid=%d and Date(last_every_day_pvpcoin_get_time) < CURDATE()", pvpAdd, self:GetDBID())
					local sql1 = string.format("UPDATE t_user SET pvpcoin=pvpcoin+%d,last_every_day_pvpcoin_get_time=NOW() WHERE uid=%d", pvpAdd, self:GetDBID())
					local err1 = xlDb_Execute(sql1)
					if err1 == 0 then
						local sql2 = string.format("SELECT u.gamecoin_online,u.pvpcoin,u.last_every_day_pvpcoin_get_time FROM t_user AS u where u.uid=%d",self._dbId)
						local err2, gamecoin,pvpcoin,pvpcoinLastTime = xlDb_Query(sql2)
						if err2 then
							self._pvpcoin = pvpcoin
							self._pvpcoin_last_gettime = pvpcoinLastTime
						end
					else
						--error
						ret = false
					end
				else
					ret = false
				end
			else
				ret = false
			end
		else
			ret = false
		end
		return ret
	end

	--购买兵符
	function User:DBBuyPvpCoin()
		local ret = true

		local udbid = self:GetDBID()

		local itemId = 9923
		local gamecoinCost = 20
		local pvpAdd = 30

		--print("DBBuyPvpCoin:",1)

		if self:_DBUserPurchase(itemId,1,gamecoinCost,0,""..(self._pvpcoin)) then
			--更新竞技场积分
			local sql = string.format("UPDATE t_user SET pvpcoin=pvpcoin+%d WHERE uid=%d", pvpAdd, udbid)
			local err = xlDb_Execute(sql)
			--print("DBBuyPvpCoin:",err,sql)
			if err == 0 then
				local sql1 = string.format("SELECT u.gamecoin_online,u.pvpcoin FROM t_user AS u where u.uid=%d",udbid)
				local err1, gamecoin,pvpcoin = xlDb_Query(sql1)
				if err1 then
					self._pvpcoin = pvpcoin
				end
			else
				--error
				ret = false
			end
		else
			ret = false
		end

		return ret
	end

	--获取用户数据
	function User:_DBGetUserInfo()
		local ret = false
		if self._dbId > 0 and self._rId > 0 then
			--print("获取用户数据", self._dbId, self._rId)
			local sql= string.format("SELECT c.name,u.gamecoin_online,u.gamescore_online,u.pvpcoin,u.last_every_day_pvpcoin_get_time,u.bTester,u.challengeMaxCount,u.challengeMaxCount1,DATE(u.challengeRefreshTime) FROM t_cha AS c, t_user AS u WHERE u.uid=%d AND c.id=%d",self._dbId,self._rId)
			
			local err,name,gamecoin,gamescore,pvpcoin,pvpcoinLastTime,bTester,challengeMaxCount,challengeMaxCount1,challengeRefreshTime = xlDb_Query(sql)
			--print("err=", err)
			if err == 0 then
				
				------------------------------------------------------------铜雀台和魔龙的信息刷新------------------------------------------------------------
				--首先看看是否要刷新次数
				--[[
				--改为t_pvp_user刷新挑战次数
				local timeNow = hApi.GetTime()
				local datestamp = hApi.Timestamp2Date(timeNow)
				if datestamp > challengeRefreshTime then
					local cMaxCount = (hVar.MULTI_PVE_CONFIG.challengeMaxCount or 3)
					local cMaxCount1 = (hVar.tab_roomcfg[3].challengeMaxCount or 3)
					
					local sqlUpdate = string.format("UPDATE `t_user` SET `challengeMaxCount`=%d,`challengeMaxCount1`=%d,`challengeRefreshTime`=NOW() where `uid`=%d",cMaxCount,cMaxCount1,self._dbId)
					xlDb_Execute(sqlUpdate)
					challengeMaxCount = cMaxCount
					challengeMaxCount1 = cMaxCount1
					challengeRefreshTime = datestamp
				end
				]]
				
				------------------------------------------------------------基本信息t_user,t_cha------------------------------------------------------------
				self._name = name or hVar.tab_string["__TEXT_PLAYER"].. tostring(self._dbId)
				self._gamecoin = gamecoin			--用户游戏币
				self._gamescore = gamescore			--用户积分
				self._pvpcoin = pvpcoin				--用户兵符
				self._pvpcoin_last_gettime = pvpcoinLastTime	--兵符每日领取上一次领取时间
				--是否测试员
				if bTester > 0 then
					self._bTester = true
					if tonumber(bTester) == 2 then
						self._bGM = true
					end
				else
					self._bTester = false
					self._bGM = false
				end
				
				------------------------------------------------------------pvpser中的信息------------------------------------------------------------
				local sqlpvp = string.format("SELECT pu.uid,pu.evaluateE,pu.evaluateE_log,pu.coppercount,pu.silvercount,pu.goldcount,pu.chestexp,pu.arenachest,pu.arenachest_open,pu.chestInfo,pu.tacticInfo,pu.heroInfo,pu.inventoryInfo,pu.levelInfo FROM t_pvp_user as pu where pu.id=%d",self._rId)
				local errpvp,uidpvp,evaluateE,evaluateELog,coppercount,silvercount,goldcount,chestexp,arenachest,arenachestOpen,chestInfo,tacticInfo,heroInfo,inventoryInfo,levelInfo = xlDb_Query(sqlpvp)
				if errpvp == 0 then
					
					self._evaluateE = evaluateE			--夺塔奇兵娱乐模式（匹配模式）累计星星评价
					self._evaluateELog = evaluateELog		--历史上获得的所有星星
					self._coppercount = coppercount			--开过的铜宝箱总量
					self._silvercount = silvercount			--开过的银宝箱总量
					self._goldcount = goldcount			--开过的金宝箱总量
					self._chestexp = chestexp			--开过的宝箱的总经验
					self._arenachest = arenachest			--擂台赛锦囊的当前数量
					self._arenachestOpen = arenachestOpen		--擂台赛锦囊的历史上总数量
					
					--初始化玩家道具信息
					self:_InitItemInfo(true)
					--self._itemMgr = hClass.RedEquipMgr:creat(true):Init(self._dbId,self._rId)
					
					--宝箱信息初始化
					self:_InitChestInfo(chestInfo)
					
					--战术技能卡初始化
					self:_InitTacticInfo(tacticInfo)

					--英雄初始化
					self:_InitHeroInfo(heroInfo)


					--背包道具初始化
					self:_InitInventoryInfo(inventoryInfo)

					--关卡信息初始化
					self:_InitLevelInfo(levelInfo)

					--如果t_pvp_user中的uid和当前登录的uid不一致，则更新t_pvp_user中的uid
					if uidpvp ~= self._dbId then
						local sUpdate = string.format("UPDATE t_pvp_user SET uid=%d, `name`='%s' WHERE id=%d",self._dbId,name,self._rId)
						--print("sUpdate",sUpdate)
						xlDb_Execute(sUpdate)
					end
					
					ret = true
				else
					--新竞技场玩家
					--插入记录
					local sql2 = string.format("INSERT INTO t_pvp_user (id,uid,`name`) values (%d,%d,'%s')",self._rId,self._dbId,tostring(name))
					local err2 = xlDb_Execute(sql2)
					--print("sql2:",sql2,err2)
					if err2 == 0 then
						self._evaluateE = 0			--娱乐模式累计星星评价
						self._evaluateELog = 0			--历史上获得的所有星星
						self._coppercount = 0			--开过的铜宝箱总量
						self._silvercount = 0			--开过的银宝箱总量
						self._goldcount = 0			--开过的金宝箱总量
						self._chestexp = 0			--开过的宝箱的总经验
						self._arenachest = 0			--擂台赛锦囊的当前数量
						self._arenachestOpen = 0		--擂台赛锦囊的历史上总数量
						
						--初始化玩家道具信息
						self:_InitItemInfo(false)
						
						--宝箱信息初始化
						self:_InitChestInfo(User.CHEST_AMOUNT.. ";")

						--战术技能卡初始化
						self:_InitTacticInfo("0;")

						--英雄将魂初始化
						self:_InitHeroInfo("0;")

						--背包道具初始化
						self:_InitInventoryInfo("0;")

						--关卡信息初始化
						self:_InitLevelInfo("0;")

						ret = true
					else
						--error
						print("User:_DBGetUserInfo:1")
					end
				end
			else
				--error
				--print("User:_DBGetUserInfo:2")
			end
		else
			--error
			--print("User:_DBGetUserInfo:3")
		end
		
		return ret
	end

	--保存用户数据(保存配置，保存战绩，保存宝箱，保存卡)
	function User:SaveData(saveBattleCfg, saveEvaluate, saveChest, saveTactic, saveHeroInfo)
		--self:_DBUpdateBattleConfig()
		local ret = false
		local dbid = self:GetDBID()
		local rid = self:GetRID()
		
		local saveList = {}
		if saveBattleCfg then
			saveList[#saveList + 1] = string.format("battle_cfg='%s',battle_cfg1='%s'",self._sBattlecfg,self._sBattlecfg1)
		end
		if saveEvaluate then
			saveList[#saveList + 1] = string.format("evaluateE=%d,evaluateE_log=%d",self:GetEvaluateE(),self:GetEvaluateELog())
		end
		if saveChest then
			saveList[#saveList + 1] = string.format("coppercount=%d,silvercount=%d,goldcount=%d,chestexp=%d,arenachest=%d,arenachest_open=%d,chestInfo='%s'",self._coppercount,self._silvercount,self._goldcount,self._chestexp,self._arenachest,self._arenachestOpen,self:_ChestInfoToCmd_NoDBID())
		end
		if saveTactic then
			saveList[#saveList + 1] = string.format("tacticInfo='%s'",self._tacticMgr:InfoToCmd())
		end
		if saveHeroInfo then
			saveList[#saveList + 1] = string.format("heroInfo='%s'",self._heroMgr:InfoToCmd())
		end
		
		--如果有需要保存的列,则进行保存
		if #saveList > 0 then
			local saveInfo = ""
			for i = 1, #saveList do
				saveInfo = saveInfo .. saveList[i]
				if i < #saveList then
					saveInfo = saveInfo .. ","
				end
			end
			local sql = string.format("UPDATE t_pvp_user SET " .. saveInfo .. " WHERE id=%d",self._rId)
			local err = xlDb_Execute(sql)
			if err == 0 then
				ret = true
			else
			end
		end

		return ret
	end
	
	--玩家购买道具
	function User:_DBUserPurchase(itemId,itemNum,gamecoinCost,scoreCost,itemExt)
		
		local ret = false

		local dbid = self:GetDBID()
		local rid = self:GetRID()
		
		local nItemId = itemId
		local nItemNum = itemNum or 1
		local nGamecoinCost = gamecoinCost or 0
		local nScoreCost = scoreCost or 0
		local sItemExt = itemExt or ""

		if not nItemId or nItemId <= 0 then
			return ret
		end

		local sql = string.format("SELECT gamecoin_online FROM t_user where uid=%d",self._dbId)
		local err,gamecoin = xlDb_Query(sql)
		if err == 0 then
			
			self._gamecoin = gamecoin

			--如果有足够的游戏币
			if gamecoinCost <= self._gamecoin then

				local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]

				--新的购买记录插入到order表
				local sUpdateLog = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,dbid,rid,itemId,nItemNum,sItemName,nGamecoinCost,nScoreCost,sItemExt)
				xlDb_Execute(sUpdateLog)
				
				--扣钱
				--更新t_user
				self._gamecoin = self._gamecoin + (-gamecoinCost)
				self:_DBAddGamecoin(-gamecoinCost)

				ret = true
			end
		end

		return ret
	end
	
	--增加游戏币
	function User:_DBAddGamecoin(addGold)

		local gold = math.min(300, (addGold or 0))
		local dbid = self:GetDBID()
			
		--内存
		self._gamecoin = self._gamecoin + gold

		if gold > 0 then
			--
			local sUpdate = string.format("UPDATE t_user SET gamecoin_online = gamecoin_online + %d WHERE uid = %d",gold,dbid)
			xlDb_Execute(sUpdate)

			--add log
			local sLog = string.format("insert into prize (uid,type, mykey, used) values (%d,%d,%d,%d)",dbid,400,gold,2)
			xlDb_Execute(sLog)
		elseif gold < 0 then
			--扣除金币，不记录进prize，会在扣之前走order
			local sUpdate = string.format("UPDATE t_user SET gamecoin_online = gamecoin_online + %d WHERE uid = %d",gold,dbid)
			xlDb_Execute(sUpdate)
		end
	end

	--增加宝箱(策马宝箱)（一次加1个）
	function User:_DBAddVii(itemId, itemNum)
		-- itemId, 9004-9006宝箱 9300-9320碎片 9999红妆卷轴
		local num = itemNum or 1
		local dbid = self:GetDBID()
		local rid = self:GetRID()
		local rpKey = ""

		--银宝箱一次最多3个（防止x3乱搞）
		if itemId == 9004 then
			rpKey = "chest_cuprum"
		elseif itemId == 9005 then
			num = math.min(3, num)
			rpKey = "chest_silver"
		--金宝箱一次最多1个（防止x3乱搞）
		elseif itemId == 9006 then
			num = math.min(1, num)
			rpKey = "chest_gold"
		else
			return
		end
		
		--add vii
		local sUpdate = string.format("update t_cha set %s = %s + %d where id = %d",rpKey,rpKey,num,rid)
		xlDb_Execute(sUpdate)

		--add log
		--local sLog = string.format("insert into log_vii (uid,rid,type,num,string_id) values (%d,%d,%d,%d,\'%s\')",dbid,rid,itemId,num,"server_script")
		--xlDb_Execute(sLog)
	end
	--------------------------------------------------------数据库操作--------------------------------------------------------

	--------------------------------------------------------InfoToCmd操作--------------------------------------------------------
	--用户loginResult toCmd
	function User:BaseInfoToCmd()
		
		--基础信息
		local cmd = ""
		cmd = cmd .. tostring(self._id) .. ";"				--内存id
		cmd = cmd .. tostring(self._dbId) .. ";"			--数据库id
		cmd = cmd .. tostring(self._rId) .. ";"				--当前使用的角色Id
		cmd = cmd .. tostring(self._name) .. ";"			--用户姓名
		cmd = cmd .. tostring(self._gamecoin) .. ";"			--用户游戏币
		cmd = cmd .. tostring(self._gamescore) .. ";"			--用户积分
		cmd = cmd .. tostring(self._pvpcoin) .. ";"			--用户兵符
		cmd = cmd .. tostring(self._pvpcoin_last_gettime) .. ";"	--兵符每日领取上一次领取时间
		cmd = cmd .. tostring(self._evaluateE) .. ";"			--娱乐模式累计星星评价
		cmd = cmd .. tostring(self._evaluateELog) .. ";"		--历史上获得的所有星星
		cmd = cmd .. tostring(self._arenachest) .. ";"			--擂台赛锦囊的当前数量

		cmd = cmd .. tostring(self._coppercount) .. ";"			--开过的铜宝箱总量
		cmd = cmd .. tostring(self._silvercount) .. ";"			--开过的银宝箱总量
		cmd = cmd .. tostring(self._goldcount) .. ";"			--开过的金宝箱总量
		cmd = cmd .. tostring(self._arenachestOpen) .. ";"		--擂台赛锦囊的历史上总数量
		cmd = cmd .. tostring(self._chestexp) .. ";"			--开过的宝箱的总经验

		return cmd
	end
	
	--宝箱信息 toCmd（不传dbid, rid）
	function User:_ChestInfoToCmd_NoDBID()
		
		local cmd = ""
		if self._freechest and type(self._freechest) == "table" and self._freechest:getCName() == "Chest" then
			cmd = self._freechest:InfoToCmd()
		else
			cmd = "0:0;"
		end

		for i = 1, User.CHEST_AMOUNT - 1 do
			local chest = self._chestList[i]
			if chest and type(chest) == "table" and chest:getCName() == "Chest" then
				cmd = cmd .. chest:InfoToCmd()
			else
				cmd = cmd .. "0:0;"
			end
		end
		
		cmd = tostring(User.CHEST_AMOUNT) .. ";" .. cmd
		return cmd
	end
	
	--宝箱信息 toCmd
	function User:_ChestInfoToCmd()
		
		local cmd = ""
		if self._freechest and type(self._freechest) == "table" and self._freechest:getCName() == "Chest" then
			cmd = self._freechest:InfoToCmd()
		else
			cmd = "0:0;"
		end

		for i = 1, User.CHEST_AMOUNT - 1 do
			local chest = self._chestList[i]
			if chest and type(chest) == "table" and chest:getCName() == "Chest" then
				cmd = cmd .. chest:InfoToCmd()
			else
				cmd = cmd .. "0:0;"
			end
		end
		
		cmd = tostring(self._dbId) .. ";" .. tostring(self._rId) .. ";" .. tostring(User.CHEST_AMOUNT) .. ";" .. cmd
		return cmd
	end
	
	--战术技能卡信息 toCmd
	function User:TacticInfoToCmd()
		
		local cmd = ""
		--英雄信息
		if self._tacticMgr and type(self._tacticMgr) == "table" and self._tacticMgr:getCName() == "TacticMgr" then
			cmd = self._tacticMgr:InfoToCmd() or ""
		end

		cmd = tostring(self._dbId) .. ";" .. tostring(self._rId) .. ";" .. cmd
		return cmd
	end

	--英雄信息 toCmd
	function User:HeroInfoToCmd()

		local cmd = ""
		--英雄信息
		if self._heroMgr and type(self._heroMgr) == "table" and self._heroMgr:getCName() == "HeroMgr" then
			cmd = self._heroMgr:InfoToCmd() or ""
		end

		cmd = tostring(self._dbId) .. ";" .. tostring(self._rId) .. ";" .. cmd
		return cmd
	end

	--道具信息 toCmd
	function User:ItemInfoToCmd()
		
		local cmd = ""
		--道具信息
		if self._itemMgr and type(self._itemMgr) == "table" and self._itemMgr:getCName() == "ItemMgr" then
			cmd = self._itemMgr:InfoToCmd() or ""
		end
		
		cmd = tostring(self._dbId) .. ";" .. tostring(self._rId) .. ";" .. cmd
		return cmd
	end

	--背包索引信息
	function User:InventoryInfoToCmd()
		--todo
		local cmd = ""
		return cmd
	end

	--关卡信息
	function User:LevelInfoToCmd()
		local cmd = ""
		--道具信息
		if self._levelMgr and type(self._levelMgr) == "table" and self._levelMgr:getCName() == "LevelMgr" then
			cmd = self._levelMgr:InfoToCmd() or ""
		end

		cmd = tostring(self._dbId) .. ";" .. tostring(self._rId) .. ";" .. cmd
		return cmd
	end
	--------------------------------------------------------InfoToCmd操作--------------------------------------------------------
return User




