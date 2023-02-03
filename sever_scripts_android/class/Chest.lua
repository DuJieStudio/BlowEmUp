--宝箱管理类
local Chest = class("Chest")

	Chest.TYPE = 
	{
		COPPER = 9913,			--铜
		SILVER = 9914,			--银
		GOLD = 9915,			--金
		ARENA = 9916,			--擂台锦囊
		REDEQUIP = 9917,		--神器锦囊
		LUCKYREDEQUIP = 9919,		--幸运神器锦囊
		REDEQUIP_CRYSTAL = 9941,	--兑换神器晶石
		CANGBAOTU_NORMAL_CRYSTAL = 9943,--藏宝图兑换
		CANGBAOTU_HIGH_CRYSTAL = 9944,	--高级藏宝图兑换
		REDEQUIP_FIVE = 9947,		--神器锦囊*5
		REDEQUIP_CRYSTAL_FIVE = 9948,	--兑换神器晶石*5
		ORANGEEQUIP = 9951,		--橙装锦囊
		YELLOWEQUIP = 9956,		--黄装锦囊
		YELLOWEQUIP_FIVE = 9957,	--黄装锦囊*5
		
		--新商店
		REDCHEST_ONCE = 9959,		--神器宝箱抽一次
		REDCHEST_TENTH = 9960,		--神器宝箱抽十次
		TACTICCARD_ONCE = 9961,		--战术卡包抽一次
		TACTICCARD_TENTH = 9962,	--战术卡包抽十次
		REDCHEST_ONCE_FREE = 9963,	--神器宝箱免费抽一次
		REDCHEST_TENTH_FREE = 9964,	--神器宝箱免费抽十次
		TACTICCARD_ONCE_FREE = 9965,	--战术卡包免费抽一次
		TACTICCARD_TENTH_FREE = 9966,	--战术卡包免费抽十次
		
		REDEQUIP_CRYSTAL_TENTH = 9967,	--兑换神器晶石*10
		REDEQUIP_CRYSTAL_FIFTY = 9968,	--兑换神器晶石*50
		TACTICCEST = 9969,		--战术锦囊
		
		FREE = 99999,		--免费领取（如果是免费领取宝箱，会进入自动发放流程）
		
		CHEST_TYPE_MAXNUM = 9969,	--最大值
	}
	
	Chest.EXP = 
	{
		COPPER = 1,		--铜
		SILVER = 5,		--银
		GOLD = 20,		--金
		ARENA = 1,		--擂台锦囊
		REDEQUIP = 0,		--红装锦囊

		FREE = 0,		--免费领取（如果是免费领取宝箱，会进入自动发放流程）
	}
    
	--构造函数
	function Chest:ctor()
		self._id = -1
		self._gettime = -1

		return self
	end
	function Chest:Init(id,gettime)
		
		--参数判定检测
		if (not id) or (id <= 0) then
			return
		end

		self._id = id
		self._gettime = gettime

		return self
	end
	--获取宝箱Id
	function Chest:GetID()
		return self._id
	end
	--获取宝箱获取时间
	function Chest:GetGettime()
		return self._gettime
	end
	--设置宝箱为FREE类型
	function Chest:SetTypeFree()
		self._id = Chest.TYPE.FREE
	end
	
	--获取开启剩余时间
	function Chest:_RemainOpentime()
		local timeNow = hApi.GetTime()
		local id = self:GetID()

		local openDelay = 0
		local chestT = hVar.tab_chest[id]
		if chestT then
			openDelay = chestT.openDelay or 0
		end
		--时间判定
		local ret = (self:GetGettime() + openDelay*60) - timeNow

		if ret < 0 then
			ret = 0
		end
		return ret
	end
	--获取宝箱兑换价格
	function Chest:GetOpenCost()
		
		local cost = 0
		local openCost = 0
		local openDelay = 0
		local id = self:GetID()
		local chestT = hVar.tab_chest[id]
		if chestT then
			openCost = chestT.openCost or 0
			openDelay = chestT.openDelay or 0
		end
		local remainOpentime = self:_RemainOpentime()
		
		local rate = 0
		if openDelay > 0 then
			rate = remainOpentime / (openDelay * 60)
		end
		
		cost = math.ceil(openCost * rate)

		return cost
	end
	
	--检测宝箱是否可以开启(时间判定去掉了，因为剩余时间可以转化为游戏币，开启宝箱)
	function Chest:_CheckCanOpen()
		local ret = false
		local id = self:GetID()
		local timeNow = hApi.GetTime()

		----时间判定
		--if id == Chest.TYPE.FREE then
		--else
		--	local openDelay = 0
		--	local chestT = hVar.tab_chest[id]
		--	if chestT then
		--		openDelay = chestT.openDelay or 0
		--		if timeNow >= self:GetGettime() + openDelay*60 then
		--			ret = true
		--		end
		--	end
		--end
		
		--不判定
		ret = true
		
		return ret
	end
	
	--roll点，根据权值落在哪个区间，返回掉落
	function Chest:_RollDrop(pool)
		local ret 
		if not pool then
			return ret
		end

		local value = math.random(1, pool.totalValue)
		local initialValue = 0
		--遍历，看权重落在哪个区段
		for i = 1, #pool do
			if value > initialValue and value <= initialValue + pool[i].value then
				ret = pool[i].reward
				break
			end
			initialValue = initialValue + pool[i].value
		end
		return ret
	end

	--将一个整数数字切分成若干个。参数：待切数字，切的刀数
	function Chest:_DivideInteger2Several(num, divideCount)
		
		--数字  1 2 3 4 5 6 7
		--坑   0 1 2 3 4 5 6 7

		local ret = {}
		local hole = num - 1
		--如果有坑
		--if hole > 0 then
		--如果有坑并且切的刀数大于0
		if hole > 0 and divideCount > 0 then
			--需要切的刀数(刀数不能大于坑的数量)
			local rCount = math.min(hole, divideCount)
			local holeposDic = {}
			local holeposList = {}
			--随机切，记录下切的坑的位置（不重复切）
			for i = 1, rCount do
				local r = math.random(1, hole)
				
				if not holeposDic[r] then
					holeposDic[r] = true
					holeposList[#holeposList + 1] = r
				end
			end
			
			--将切出的位置编号按照升序排序
			table.sort(holeposList, function(a, b)
				return (a < b)
			end)
			
			--上一次切的位置
			local lastpos = 0
			--根据切的位置开始分蛋糕
			for i = 1, #holeposList do
				local holepos = holeposList[i]
				--当前切的位置减去上一次切的位置就是这块蛋糕
				ret[#ret + 1] = holepos - lastpos
				--重设一下上一次切的位置
				lastpos = holepos
				--如果已经是最后一刀了，需要补上右边的一块蛋糕
				if i == #holeposList then
					ret[#ret + 1] = num - lastpos
				end
			end
		else
			--没坑直接返回
			ret[#ret + 1] = num
		end
		
		return ret
	end
	
	--开宝箱
	function Chest:Open(mustRed)
		local ret
		local id = self:GetID()
		--print(id)
		
		--如果可打开宝箱
		if self:_CheckCanOpen() then
			local numCritical = 1
			if hGlobal.aMgr and hGlobal.aMgr:CheckOpenChestCritical() then
				numCritical = 2
			end
			--通用奖池
			local dropPool = hVar.tab_droppool
			--当前锦囊配置
			local tabChest = hVar.tab_chest[id]
			
			--如果奖池和锦囊配置都存在
			if tabChest and dropPool then
				
				--普通锦囊掉落
				if tabChest.reward then
					local rewardPool = tabChest.reward
					
					--遍历锦囊的掉落配置
					for i = 1, #rewardPool do
						--通用奖池中的奖池键值
						local poolkey = rewardPool[i][1]
						--最少掉落
						local minNum = rewardPool[i][2]
						--最多掉落
						local maxNum = math.max(rewardPool[i][3],minNum)
						--分段数(最小也有1段)
						local section = rewardPool[i][4] - 1
						
						--随机一个掉落的数量
						local r = math.random(minNum, maxNum)
						--将随机的数量切分成若干份
						local sectionList = self:_DivideInteger2Several(r,section)
						--根据每段的数量进行掉落
						for j = 1, #sectionList do
							local rollDrop = self:_RollDrop(dropPool[poolkey])
							local dropNum = sectionList[j] * numCritical

							--print("OpenChest:",dropNum,sectionList[j],numCritical)
							--如果有一个宝箱掉落池有问题则退出
							if not rollDrop then
								ret = nil
								return ret
							end
							--如果随机出的掉落区间数量大于0，则进行掉落（todo：考虑下要不要把相同的掉落合并，貌似没啥必要）
							if dropNum > 0 then
								if not ret then
									ret = hClass.Reward:create():Init()
								end
								if ret then
									local addOk,idx = ret:Add(rollDrop)
									--重新设置数量
									if addOk then
										ret:SetRewardNum(idx,dropNum)
									end
								end
							end
						end
					end
				
				elseif tabChest.rewardEx then --红装锦囊掉落 
					local rewardPool = tabChest.rewardEx
					
					--遍历锦囊的掉落配置
					for i = 1, #rewardPool do
						
						--奖池抽取单位数量
						local rollCount = rewardPool[i].rollCount
						
						--遍历需要roll的次数
						for n = 1, rollCount do
							
							--通用奖池中的奖池键值
							local poolkeyInfo = self:_RollDrop(rewardPool[i].pool)
							if mustRed and string.lower(rewardPool[i].tag) == "equip" and rewardPool[i].mustDrop then
								poolkeyInfo = rewardPool[i].mustDrop
								
								--出过1次红装，就不再必出
								mustRed = false
							end
							if poolkeyInfo then
								local poolkey = poolkeyInfo
								local dropNum = 1
								if type(poolkeyInfo) == "table" then
									poolkey = poolkeyInfo[1]
									dropNum = poolkeyInfo[2] or 1
								end
								if poolkey then
									local rollDrop = self:_RollDrop(dropPool[poolkey])
									
									if rollDrop and dropNum > 0 then
										if not ret then
											ret = hClass.Reward:create():Init()
										end
										if ret then
											local addOk,idx = ret:Add(rollDrop)
											--print("i,n:",i,n,addOk,rollDrop[1],rollDrop[2],rollDrop[3],rollDrop[4])
											--重新设置数量
											if addOk then
												--如果填了随机数量[3]，再随机一次数量
												if poolkeyInfo[3] and (poolkeyInfo[3] > 0) then
													dropNum = math.random(dropNum, poolkeyInfo[3])
												end
												ret:SetRewardNum(idx,dropNum)
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end

		return ret
	end

	--基本信息转化
	function Chest:InfoToCmd()
		local cmd = (self:GetID()) .. ":" .. (self:GetGettime()) .. ";"
		return cmd
	end
return Chest