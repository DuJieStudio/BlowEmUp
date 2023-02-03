--宝箱管理类
local Reward = class("Reward")
	
	Reward.MAXDATA = 4				--单个奖励数据的最大参数长度

	Reward.TYPE = 
	{
		--	reward = {			--星级奖励:1积分,2战术技能卡,3道具,4英雄,5将魂,6战术技能卡碎片,7游戏币,8网络宝箱,9抽卡,10神装,11神装晶石
		--		{1,1000,},		--
		--		{2,1000,1,2,},		--类型,ID,数量,等级
		--		{3,8996,4},		--类型,ID,道具,属性价值倍率
		--		{4,5000,1,1},		--类型,ID(道具id),星级（默认为1）,等级（默认为1，慎用）
		--		{5,10200,1},		--类型,ID(道具id),数量
		--		{6,10300,1},		--类型,ID(道具id),数量
		--		{7,10,},		--类型,金额(最大20)
		--		{8,9004,1},		--类型,ID(道具id,9004,9005,9006),数量
		--		{9,9101},		--类型,ID(道具id,9101,9102)
		--		{10,8996},		--类型,ID,道具
		--		{11,10},		--类型,晶石数量
		--	},
		SCORE = 1,			--1:积分
		TACTIC = 2,			--2:战术卡
		EQUIPITEM = 3,		--3:道具
		HEROCARD = 4,		--4:英雄
		HERODEBRIS = 5,		--5:英雄将魂
		TACTICDEBRIS = 6,	--6:战术卡碎片
		ONLINECOIN = 7,		--7:游戏币
		NETCHEST = 8,		--8:网络宝箱
		DRAWCARD = 9,		--9:战术卡卡包
		REDEQUIP = 10,		--10:红色神器
		CRYSTAL = 11,		--11:神器晶石
		REDSCROLL = 12,		--12:红装兑换券
		NETDRAWCARD = 13,	--13:服务器下发的抽卡类卡包
		HEROEXP = 14,		--14:英雄经验
		LUCKYREDCHEST = 15,	--15:幸运神器锦囊
		IRON = 16, --geyachao: 新加房间的配置项 军团 铁
		WOOD = 17, --geyachao: 新加房间的配置项 军团 木材
		FOOD = 18, --geyachao: 新加房间的配置项 军团 粮食
		GROUPCOIN = 20, --geyachao: 新加房间的配置项 军团 军团币
		TOWERADDONESFREE = 21,	 --21:强化免费券
		TREASUREDEBRIS = 22,	 --22:宝物碎片
		CANGBAOTU_NORMAL = 23,	 --23:藏宝图
		CANGBAOTU_HIGH = 24,	 --24:高级藏宝图
		PVPCOIN = 25,		--25:兵符
		CHOUJIANG_FREETICKET = 26,	--26:抽奖免费券
		ZHANGONG_SCORE = 27,		--27:战功积分
		ACHEVEMENT_POINT = 28,		--28:成就点
		IKUN_SCORE = 29,		--29:爱鲲积分
		
		----------------------------------------------------
		--战车新加奖励类型
		TASK_STONE = 100,		--100:任务之石
		WEAPONGUN_DEBRIS = 101,		--101:武器枪碎片
		PET_DEBRIS = 103,		--103:宠物碎片
		SCIENTIST_DEBRIS = 104,		--104:科学家碎片
		WEAPONGUN_CHEST = 105,		--105:武器枪宝箱
		TACTIC_CHEST = 106,		--106:战术卡宝箱
		PET_CHEST = 107,		--107:宠物宝箱
		EQUIP_CHEST = 108,		--108:装备宝箱
		SCIENTIST_CHEST = 109,		--109:科学家宝箱
		SCIENTIST_ACHEVEMENT1 = 110,	--110:科学家成就1
		SCIENTIST_ACHEVEMENT2 = 111,	--111:科学家成就2
		SCIENTIST_ACHEVEMENT3 = 112,	--112:科学家成就3
		SCIENTIST_ACHEVEMENT4 = 113,	--113:科学家成就4
		DISHU_COIN = 114,		--114:地鼠币
		TANKDEEADTH_ACHEVEMENT1 = 115,	--115:垃圾堆成就1
		TANKDEEADTH_ACHEVEMENT2 = 116,	--116:垃圾堆成就2
		TANKDEEADTH_ACHEVEMENT3 = 117,	--117:垃圾堆成就3
		TANKDEEADTH_ACHEVEMENT4 = 118,	--118:垃圾堆成就4
		TANKDEEADTH_ACHEVEMENT5 = 119,	--119:垃圾堆成就5
		TALENT_POINT = 120,		--120:天赋点
		
		
		REWARD_MAXNUM = 120,		--定义奖励类型最大值
	}
	
	--构造函数
	function Reward:ctor()
		self._list = -1
		self._num = -1
		
		return self
	end
	function Reward:Init(id,gettime)
		
		self._list = {}
		self._num = 0

		return self
	end

	------------------------------------------------------private------------------------------------------------------

	--初始化战术技能卡信息
	function Reward:_InitTacticInfo(tacticInfo)
		local tTacticInfo = hApi.Split(tacticInfo, ";")
		local tacticNum = tonumber(tTacticInfo[1]) or 0
		local infoIdx = 1
		
		local tacticDic = {}
		
		--遍历所有战术卡
		for i = 1, tacticNum do
			local tacticList = tTacticInfo[infoIdx + i] or ""
			local tTacticList = hApi.Split(tacticList,":")
			local id = tonumber(tTacticList[1]) or 0
			local num = tonumber(tTacticList[2]) or 0
			local totalNum = tonumber(tTacticList[3]) or 0
			local lv = tonumber(tTacticList[4]) or 0
			local addonsNum = tonumber(tTacticList[5]) or 0
			local addons = {}
			local addonsIdx = 5
			for n = 1, addonsNum do
				addons[n] = tTacticList[addonsIdx + n]
			end
			
			if id > 0 then
				tacticDic[id] = hClass.Tactic:create():Init(id, lv, num, totalNum, addonsNum, addons)
			end
		end

		----检测玩家有没默认卡组，没有的话要送
		--for i = 1, #User.DEFAULT_TACTICS do
		--	local id = User.DEFAULT_TACTICS[i]
		--	local tactic = tacticDic(id)
		--	if not tactic then
		--		tacticDic[id] = hClass.Tactic:create():Init(id, 1, 0, 0)
		--	else
		--		local lv = tactic:GetLv()
		--		local debris = tactic:GetDebris()
		--		if lv == 0 and debris > 0 then
		--			tacticDic[id] = nil
		--			tacticDic[id] = hClass.Tactic:create():Init(id, 1, 0, 0)
		--		end
		--	end
		--end

		return tacticDic
	end

	--添加战术卡碎片
	function Reward:_AddTactic(tacticDic,id,num)
		local ret = false
		if id > 0 and num > 0 then
			local tactic = tacticDic[id]
			if tactic then
				tactic:AddDebris(num)
				ret = true
			else
				tacticDic[id] = hClass.Tactic:create():Init(id, 0, num, num)
				ret = true
			end
		end
		return ret
	end

	--战术技能卡信息 toCmd
	function Reward:_TacticInfoToCmd(tacticDic)
		local cmd = ""
		local tacticNum = 0
		
		--for id, num in pairs(self._tacticDic) do
		--	cmd = cmd .. id .. ":" .. num .. ";"
		--	tacticNum = tacticNum + 1
		--end
		for id, tactic in pairs(tacticDic) do
			cmd = cmd .. (tactic:InfoToCmd())
			tacticNum = tacticNum + 1
		end

		cmd = (tacticNum) .. ";" .. cmd
		return cmd
	end

	--初始化英雄信息
	function Reward:_InitHeroInfo(heroInfo)
		local tHeroInfo = hApi.Split(heroInfo, ";")
		local heroNum = tonumber(tHeroInfo[1]) or 0
		local infoIdx = 1
		local heroDic = {}
		
		--遍历所有英雄
		for i = 1, heroNum do
			local heroList = tHeroInfo[infoIdx + i] or ""
			local tHeroList = hApi.Split(heroList,":")
			local id = tonumber(tHeroList[1]) or 0
			local star = tonumber(tHeroList[2]) or 1
			local num = tonumber(tHeroList[3]) or 0
			local totalNum = tonumber(tHeroList[4]) or 0
			
			if id > 0 and totalNum > 0 then
				heroDic[id] = hClass.Hero:create():Init(id, star, num, totalNum)
			end
		end

		return heroDic
	end
	
	--增加新英雄
	function Reward:_AddNewHero(heroDic,id,star)
		local ret = false
		if id > 0 then
			local hero = heroDic[id]
			if hero then
				hero:SetStar(star)
			else
				local totalSoulStone = 1
				if hVar.tab_hero[id] and hVar.tab_hero[id].starInfo and hVar.tab_hero[id].starInfo[star] then
					totalSoulStone = hVar.tab_hero[id].starInfo[star].toSoulStone
				end
				heroDic[id] = hClass.Hero:create():Init(id, (star or 1), 0, totalSoulStone)
				ret = true
			end
		end
		return ret
	end

	--增加英雄将魂碎片
	function Reward:_AddHeroSoulstone(heroDic,id,num)
		--print("_AddHeroSoulstone:",heroDic,id,num)
		local ret = false
		if id > 0 and num > 0 then
			local hero = heroDic[id]
			--print("看看哪里出的问题:",hero)
			if hero then
				hero:AddSoulstone(num)
				ret = true
			else
				local star = 1
				local tabH = hVar.tab_hero[id]
				if tabH and tabH.unlock and tabH.unlock.arenaUnlock then
					star = 0
				end
				heroDic[id] = hClass.Hero:create():Init(id, star, num, num)
				ret = true
			end
		end
		return ret
	end

	--英雄将魂信息 toCmd
	function Reward:_HeroInfoToCmd(heroDic)
		local cmd = ""
		local heroNum = 0
		
		for id, hero in pairs(heroDic) do
			cmd = cmd .. (hero:InfoToCmd())
			heroNum = heroNum + 1
		end
		
		cmd = (heroNum) .. ";" .. cmd
		return cmd
	end
	
	------------------------------------------------------public------------------------------------------------------
	--新增奖励
	function Reward:Add(reward)
		local ret = false
		if reward and type(reward) == "table" then
			local rType = tonumber(reward[1])
			local id = tonumber(reward[2])
			if rType and id and rType >= Reward.TYPE.SCORE and rType <= Reward.TYPE.REWARD_MAXNUM and id > 0 then
				self._list[#self._list + 1] = {}
				for i = 1, Reward.MAXDATA do
					self._list[#self._list][i] = tonumber(reward[i]) or 0
					if i == 3 and rType == Reward.TYPE.EQUIPITEM then
						if reward[i] and (not tonumber(reward[i])) then
							self._list[#self._list][i] = reward[i]
						end
					end
				end
				self._num = self._num + 1
				
				ret = true
			end
		end
		return ret, #self._list
	end
	
	--修改奖励数量
	function Reward:SetRewardNum(idx,num)
		local reward = self._list[idx]
		if reward then
			local rewardType = reward[1]
			--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
			if (rewardType == Reward.TYPE.SCORE) then --1:积分
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TACTIC) then --2:战术技能卡
				--暂不支持
			elseif (rewardType == Reward.TYPE.EQUIPITEM) then --3:道具
				--暂不支持
			elseif (rewardType == Reward.TYPE.HEROCARD) then --4:英雄
				--暂不支持
			elseif (rewardType == Reward.TYPE.HERODEBRIS) then --5:英雄将魂
				reward[3] = num
			elseif (rewardType == Reward.TYPE.TACTICDEBRIS) then --6:战术技能卡碎片
				reward[3] = num
			elseif (rewardType == Reward.TYPE.ONLINECOIN) then --7:游戏币
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.NETCHEST) then --8:网络宝箱
				reward[3] = num
			elseif (rewardType == Reward.TYPE.DRAWCARD) then --9:抽奖类战术技能卡
				--暂不支持
			elseif (rewardType == Reward.TYPE.REDEQUIP) then --10:红装
				--暂不支持
			elseif (rewardType == Reward.TYPE.CRYSTAL) then --11:神装晶石
				--暂不支持
			elseif (rewardType == Reward.TYPE.REDSCROLL) then --12:红装卷轴
				--暂不支持
			elseif (rewardType == Reward.TYPE.NETDRAWCARD) then --13:服务器下发的抽卡类卡包
				--暂不支持
			elseif (rewardType == Reward.TYPE.HEROEXP) then --14:英雄经验
				--暂不支持
			elseif (rewardType == Reward.TYPE.LUCKYREDCHEST) then --15:幸运神器锦囊
				reward[3] = num
			elseif (rewardType == Reward.TYPE.IRON) then --16:铁 --geyachao: 新加房间的配置项 军团
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.WOOD) then --17:木材 --geyachao: 新加房间的配置项 军团
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.FOOD) then --18:粮食 --geyachao: 新加房间的配置项 军团
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.GROUPCOIN) then --20:军团币 --geyachao: 新加房间的配置项 军团
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TOWERADDONESFREE) then --21:强化免费券
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TREASUREDEBRIS) then --22:宝物碎片
				if (reward[3] == 0) then
					reward[3] = num
				else
					reward[3] = reward[3] * num
				end
			elseif (rewardType == Reward.TYPE.CANGBAOTU_NORMAL) then --23:藏宝图
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.CANGBAOTU_HIGH) then --24:高级藏宝图
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.PVPCOIN) then --25:兵符
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.CHOUJIANG_FREETICKET) then --26:抽奖免费券
				--替换
				reward[3] = num
			elseif (rewardType == Reward.TYPE.ZHANGONG_SCORE) then --27:战功积分
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.ACHEVEMENT_POINT) then --28:成就点
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.IKUN_SCORE) then --29:爱鲲积分
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TASK_STONE) then --100:任务之石
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.WEAPONGUN_DEBRIS) then --101:武器枪碎片
				reward[3] = reward[3] * num
			elseif (rewardType == Reward.TYPE.PET_DEBRIS) then --103:宠物碎片
				reward[3] = reward[3] * num
			elseif (rewardType == Reward.TYPE.SCIENTIST_DEBRIS) then --104:科学家碎片
				reward[3] = reward[3] * num
			elseif (rewardType == Reward.TYPE.WEAPONGUN_CHEST) then --105:武器枪宝箱
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TACTIC_CHEST) then --106:战术卡宝箱
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.PET_CHEST) then --107:宠物宝箱
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.EQUIP_CHEST) then --108:装备宝箱
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.SCIENTIST_CHEST) then --109:科学家宝箱
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT1) then --110:科学家成就1
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT2) then --111:科学家成就2
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT3) then --112:科学家成就3
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT4) then --113:科学家成就4
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.DISHU_COIN) then --114:地鼠币
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT1) then --115:垃圾堆成就1
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT2) then --116:垃圾堆成就2
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT3) then --117:垃圾堆成就3
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT4) then --118:垃圾堆成就4
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT5) then --119:垃圾堆成就5
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TALENT_POINT) then --120:天赋点
				reward[2] = reward[2] * num
			end
		end
	end

	--关联实体信息(目前只有10红装有实体信息)
	function Reward:SetEntity(idx, entity)
		local reward = self._list[idx]
		if reward then
			local rewardType = reward[1]
			if (rewardType == Reward.TYPE.REDEQUIP) then --10:红装
				reward[3] = entity
			end
		end
	end

	--获取reward信息
	function Reward:GetInfo()
		return self._list
	end
	--获取reward数量
	function Reward:GetNum()
		return self._num
	end
	--是否有某类型的奖励
	function Reward:HaveDrop(rType)
		local ret = false

		--服务器处理宝箱数据
		local tReward = self:GetInfo()
		local rewardLength = self:GetNum()

		for i = 1, rewardLength, 1 do
			local rewardT = tReward[i]
			if rewardT then
				local rewardType = tonumber(rewardT[1] or 0) --获取类型
				if (rewardType ==rType) then 
					ret = true
					break
				end
			end
		end
		
		return ret
	end
	
	--取得宝箱中的道具(用户id，角色id，需要获取的id索引（没有该参数默认全部获取）)
	function Reward:TakeReward(uid, rid, takeList)
		
		
		--服务器处理宝箱数据
		local tReward = self:GetInfo()
		local rewardLength = self:GetNum()
		
		local heroDic = {}
		local tacticDic = {}
		
		--先预处理下，看看需不需要操作数据库
		local dbQuery = false
		for i = 1, rewardLength, 1 do
			local rewardT = tReward[i]
			if rewardT then
				local rewardType = tonumber(rewardT[1] or 0) --获取类型
				if (rewardType == Reward.TYPE.HERODEBRIS) or (rewardType == Reward.TYPE.TACTICDEBRIS) or (rewardType == Reward.TYPE.HEROCARD) then --5:英雄将魂
					dbQuery = true
					break
				end
			end
		end
		
		--先取出需要操作的数据
		if dbQuery then
			local sql = string.format("SELECT pu.uid,pu.tacticInfo,pu.heroInfo FROM t_pvp_user as pu where pu.id=%d",rid)
			local err,uuid,tacticInfo,heroInfo = xlDb_Query(sql)
			if err == 0 then
				
				--战术技能卡初始化
				--tacticDic = self:_InitTacticInfo(tacticInfo)
				tacticDic = hClass.TacticMgr:create():Init(tacticInfo)
				
				--英雄将魂初始化
				heroDic = self:_InitHeroInfo(heroInfo)
				
			elseif err == 4 then
				local sql1= string.format("SELECT c.name FROM t_cha AS c WHERE c.id=%d",rid)
				local err1, name= xlDb_Query(sql1)
				if err1 then
					local sql2 = string.format("INSERT INTO t_pvp_user (id,uid,`name`) values (%d,%d,'%s')",rid,uid,tostring(name))
					local err2 = xlDb_Execute(sql2)
					if err2 == 0 then
					end
				end
				
			end
		end
		
		--实际处理宝箱掉落
		for i = 1, rewardLength do
			
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
				if (rewardType == Reward.TYPE.SCORE) then --1:积分
					--暂不支持
				elseif (rewardType == Reward.TYPE.TACTIC) then --2:战术技能卡
					--暂不支持
				elseif (rewardType == Reward.TYPE.EQUIPITEM) then --3:道具
					--暂不支持
				elseif (rewardType == Reward.TYPE.HEROCARD) then --4:英雄
					local heroId = tonumber(rInfo[2]) or 0
					local star = tonumber(rInfo[3]) or 1
					local lv = tonumber(rInfo[4]) or 1
					if heroId > 0 then
						self:_AddNewHero(heroDic,heroId,star)
					end
					--暂不支持
				elseif (rewardType == Reward.TYPE.HERODEBRIS) then --5:英雄将魂
					local itemId = tonumber(rInfo[2]) or 0
					local itemNum = tonumber(rInfo[3]) or 1
					
					if itemId > 0 and hVar.tab_item[itemId] and itemNum > 0 then
						local heroId = hVar.tab_item[itemId].heroID or 0
						if heroId > 0 then
							--添加英雄将魂
							self:_AddHeroSoulstone(heroDic, heroId, itemNum)
						end
					end
				elseif (rewardType == Reward.TYPE.TACTICDEBRIS) then --6:战术技能卡碎片
					local itemId = tonumber(rInfo[2]) or 0
					local itemNum = tonumber(rInfo[3]) or 1
					
					if itemId > 0 and hVar.tab_item[itemId] and itemNum > 0 then
						local tacticId = hVar.tab_item[itemId].tacticID or 0
						if tacticId > 0 then
							--self:_AddTactic(tacticDic, tacticId, itemNum)
							--print("self:_AddTactic:",tacticId, itemNum)
							tacticDic:AddTacticDebris(tacticId, itemNum)
						end
					end
				elseif (rewardType == Reward.TYPE.ONLINECOIN) then --7:游戏币
					local rmb = tonumber(rInfo[2] or 0)
					hGlobal.userCoinMgr:DBAddGamecoin(uid,rmb)
				elseif (rewardType == Reward.TYPE.NETCHEST) then --8:网络宝箱
					local itemId = tonumber(rInfo[2]) or 0
					local itemNum = tonumber(rInfo[3]) or 1
					local itemId = tonumber(rInfo[2]) or 0
					local itemNum = tonumber(rInfo[3]) or 1
					if itemId and itemId >= 9004 and itemId <= 9006 and itemNum > 0 then
						--铜9004,银9005,金9006
						hGlobal.userCoinMgr:DBAddChest(uid,rid,itemId,itemNum)
					end
				elseif (rewardType == Reward.TYPE.DRAWCARD) then --9:抽奖类战术技能卡
					--暂不支持
				elseif (rewardType == Reward.TYPE.REDEQUIP) then --10:红装
					local itemId = tonumber(rInfo[2]) or 0
					local slotnum = tonumber(rInfo[3]) or -1
					local quality = tonumber(rInfo[4]) or 0 --品质
					--local redequipMgr = hClass.RedEquipMgr:create():Init(uid, rid)
					local redequipMgr = hGlobal.redEquipUserCacheMgr:GetRedEquipMgr(uid, rid)
					if redequipMgr then
						local equip = redequipMgr:DBAddEquip(itemId,slotnum,quality)
						self:SetEntity(i, equip)
					end
				elseif (rewardType == Reward.TYPE.CRYSTAL) then
					local crystal = tonumber(rInfo[2]) or 0
					hGlobal.userCoinMgr:DBAddCrystal(uid,crystal)
				elseif (rewardType == Reward.TYPE.REDSCROLL) then
					local redscroll = tonumber(rInfo[2]) or 0
					hGlobal.userCoinMgr:DBAddRedScroll(uid,redscroll)
				elseif (rewardType == Reward.TYPE.NETDRAWCARD) then --13:服务器下发的抽卡类卡包
					--暂不支持
				elseif (rewardType == Reward.TYPE.HEROEXP) then --14:英雄经验
					--暂不支持
				elseif (rewardType == Reward.TYPE.LUCKYREDCHEST) then --15:幸运神器锦囊
					--生成本次神器锦囊的结果
					local itemId = tonumber(rInfo[2]) or 0
					local chest = hClass.Chest:create():Init(itemId,0)	--红装锦囊
					if chest and (type(chest) == "table") and (chest:getCName() == "Chest") then
						local mustRed = true
						local reward = chest:Open(mustRed)
						
						if reward then
							reward:TakeReward(uid, rid)
						end
					end
				elseif (rewardType == Reward.TYPE.IRON) then --16:铁 --geyachao: 新加房间的配置项 军团
					--军团发奖
					local itemNum = tonumber(rInfo[2]) or 0
					local groupReward = hClass.GroupReward:create("GroupReward"):Init(uid, rid)
					groupReward:TakeReward(rewardType, itemNum)
				elseif (rewardType == Reward.TYPE.WOOD) then --17:木材 --geyachao: 新加房间的配置项 军团
					--军团发奖
					local itemNum = tonumber(rInfo[2]) or 0
					local groupReward = hClass.GroupReward:create("GroupReward"):Init(uid, rid)
					groupReward:TakeReward(rewardType, itemNum)
				elseif (rewardType == Reward.TYPE.FOOD) then --18:粮食 --geyachao: 新加房间的配置项 军团
					--军团发奖
					local itemNum = tonumber(rInfo[2]) or 0
					local groupReward = hClass.GroupReward:create("GroupReward"):Init(uid, rid)
					groupReward:TakeReward(rewardType, itemNum)
				elseif (rewardType == Reward.TYPE.GROUPCOIN) then --20:军团币 --geyachao: 新加房间的配置项 军团
					--军团发奖
					local itemNum = tonumber(rInfo[2]) or 0
					local groupReward = hClass.GroupReward:create("GroupReward"):Init(uid, rid)
					groupReward:TakeReward(rewardType, itemNum)
				elseif (rewardType == Reward.TYPE.TOWERADDONESFREE) then --21:强化免费券
					--
				elseif (rewardType == Reward.TYPE.TREASUREDEBRIS) then --22:宝物碎片
					local itemId = tonumber(rInfo[2]) or 0
					local itemNum = tonumber(rInfo[3]) or 1
					local treasureReward = hClass.TreasureReward:create("TreasureReward"):Init(uid, rid)
					treasureReward:TakeReward(rewardType, itemId, itemNum)
				elseif (rewardType == Reward.TYPE.CANGBAOTU_NORMAL) then --23:藏宝图
					local cangbaotu = tonumber(rInfo[2]) or 0
					hGlobal.userCoinMgr:DBAddCangBaoTu(uid,cangbaotu)
				elseif (rewardType == Reward.TYPE.CANGBAOTU_HIGH) then --24:高级藏宝图
					local cangbaotu_high = tonumber(rInfo[2]) or 0
					hGlobal.userCoinMgr:DBAddCangBaoTuHigh(uid,cangbaotu_high)
				elseif (rewardType == Reward.TYPE.PVPCOIN) then --25:兵符
					local pvpcoin = tonumber(rInfo[2]) or 0
					hGlobal.userCoinMgr:DBAddPvpCoin(uid,pvpcoin)
				elseif (rewardType == Reward.TYPE.CHOUJIANG_FREETICKET) then --26:抽奖免费券
					local activityId = tonumber(rInfo[2]) or 0
					local ticketNum = tonumber(rInfo[3]) or 0
					hGlobal.userCoinMgr:DBAddChouJiangFreeTicket(uid, rid, activityId, ticketNum)
				elseif (rewardType == Reward.TYPE.ZHANGONG_SCORE) then --27:战功积分
					local zhangong_score = tonumber(rInfo[2]) or 0
					hGlobal.userCoinMgr:DBAddZhanGongScore(uid, rid, zhangong_score)
				elseif (rewardType == Reward.TYPE.ACHEVEMENT_POINT) then --28:成就点
					--暂不支持
				elseif (rewardType == Reward.TYPE.IKUN_SCORE) then --29:爱鲲积分
					--暂不支持
				elseif (rewardType == Reward.TYPE.TASK_STONE) then --100:任务之石
					local stone = tonumber(rInfo[2]) or 0
					if (stone > 0) then
						hGlobal.userCoinMgr:DBAddTaskStone(uid, stone)
					end
				elseif (rewardType == Reward.TYPE.WEAPONGUN_DEBRIS) then --101:武器枪碎片
					local itemId = tonumber(rInfo[2]) or 0
					local debrisNum = tonumber(rInfo[3]) or 0
					local tabI = hVar.tab_item[itemId] or {}
					local weaponId = tabI.weaponId or 0
					local tankWeapon = hClass.TankWeapon:create():Init(uid,rid)
					tankWeapon:AddDebris(weaponId, debrisNum)
				elseif (rewardType == Reward.TYPE.PET_DEBRIS) then --103:宠物碎片
					local itemId = tonumber(rInfo[2]) or 0
					local debrisNum = tonumber(rInfo[3]) or 0
					local tabI = hVar.tab_item[itemId] or {}
					local petId = tabI.petId or 0
					local tankPet = hClass.TankPet:create():Init(uid,rid)
					tankPet:AddDebris(petId, debrisNum)
				elseif (rewardType == Reward.TYPE.WEAPONGUN_CHEST) then --105:武器枪宝箱
					local debrsNum = tonumber(rInfo[2]) or 0
					if (debrsNum > 0) then
						hGlobal.userCoinMgr:DBAddWeaponChest(uid, debrsNum)
					end
				elseif (rewardType == Reward.TYPE.TACTIC_CHEST) then --106:战术卡宝箱
					local debrsNum = tonumber(rInfo[2]) or 0
					if (debrsNum > 0) then
						hGlobal.userCoinMgr:DBAddTacticChest(uid, debrsNum)
					end
				elseif (rewardType == Reward.TYPE.PET_CHEST) then --107:宠物宝箱
					local debrsNum = tonumber(rInfo[2]) or 0
					if (debrsNum > 0) then
						hGlobal.userCoinMgr:DBAddPetChest(uid, debrsNum)
					end
				elseif (rewardType == Reward.TYPE.EQUIP_CHEST) then --108:装备宝箱
					local debrsNum = tonumber(rInfo[2]) or 0
					if (debrsNum > 0) then
						hGlobal.userCoinMgr:DBAddEquipChest(uid, debrsNum)
					end
				elseif (rewardType == Reward.TYPE.SCIENTIST_CHEST) then --109:科学家宝箱
					--
				elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT1) then --110:科学家成就1
					--
				elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT2) then --111:科学家成就2
					--
				elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT3) then --112:科学家成就3
					--
				elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT4) then --113:科学家成就4
					--
				elseif (rewardType == Reward.TYPE.DISHU_COIN) then --114:地鼠币
					--增加地鼠币
					local coin = tonumber(rInfo[2]) or 0
					hGlobal.userCoinMgr:DBAddDiShuCoin(uid, coin)
				elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT1) then --115:垃圾堆成就1
					--
				elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT2) then --116:垃圾堆成就2
					--
				elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT3) then --117:垃圾堆成就3
					--
				elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT4) then --118:垃圾堆成就4
					--
				elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT5) then --119:垃圾堆成就5
					--
				elseif (rewardType == Reward.TYPE.TALENT_POINT) then --120:天赋点
					--增加战车天赋点数
					local talent = tonumber(rInfo[2]) or 0
					hGlobal.userCoinMgr:DBAddTankTalentPoint(uid, rid, talent)
				end
			end
		end
		
		--存储操作后的数据
		if dbQuery then
			local saveInfo = ""
			--saveInfo = string.format("tacticInfo='%s',heroInfo='%s'",self:_TacticInfoToCmd(tacticDic),self:_HeroInfoToCmd(heroDic))
			saveInfo = string.format("tacticInfo='%s',heroInfo='%s'",tacticDic:InfoToCmd(),self:_HeroInfoToCmd(heroDic))
			local sql = string.format("UPDATE t_pvp_user SET " .. saveInfo .. " WHERE id=%d",rid)
			local err = xlDb_Execute(sql)
			--print("sql:",sql, err)
		end
	end
	
	--合并其他奖励
	function Reward:Merge(rewardTemp)
		local rewardTemp_list = rewardTemp._list
		local rewardTemp_num = rewardTemp._num
		
		self._num = self._num + rewardTemp_num
		for i = 1, #rewardTemp_list, 1 do
			self._list[#self._list+1] = rewardTemp_list[i]
		end
	end
	
	--追加添加奖励（已有同类型的奖励，将叠加原数量而不用再新增一个奖励）
	function Reward:AppendAdd(reward)
		local ret = false
		if reward and type(reward) == "table" then
			local rType = tonumber(reward[1])
			local id = tonumber(reward[2])
			
			--遍历已有的奖励，检测是否已有重复的奖励
			for i = 1, self._num, 1 do
				local tReward = self._list[i]
				if tReward then
					local rtype = tReward[1]
					if (rtype == rType) then --找到了
						local appendIdx = self:GetAppendIndex(rType)
						if (appendIdx > 0) then
							tReward[appendIdx] = tReward[appendIdx] + tonumber(reward[appendIdx])
							return
						end
						
						break
					end
				end
			end
		end
		
		--走到这里说明无法追加，走普通添加流程
		return self:Add(reward)
	end
	
	--获得奖励数量的添加索引
	function Reward:GetAppendIndex(rewardType)
		local appendIdx = 0
		
		--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
		if (rewardType == Reward.TYPE.SCORE) then --1:积分
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TACTIC) then --2:战术技能卡
			--暂不支持
		elseif (rewardType == Reward.TYPE.EQUIPITEM) then --3:道具
			--暂不支持
		elseif (rewardType == Reward.TYPE.HEROCARD) then --4:英雄
			--暂不支持
		elseif (rewardType == Reward.TYPE.HERODEBRIS) then --5:英雄将魂
			--暂不支持
		elseif (rewardType == Reward.TYPE.TACTICDEBRIS) then --6:战术技能卡碎片
			--暂不支持
		elseif (rewardType == Reward.TYPE.ONLINECOIN) then --7:游戏币
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.NETCHEST) then --8:网络宝箱
			--暂不支持
		elseif (rewardType == Reward.TYPE.DRAWCARD) then --9:抽奖类战术技能卡
			--暂不支持
		elseif (rewardType == Reward.TYPE.REDEQUIP) then --10:红装
			--暂不支持
		elseif (rewardType == Reward.TYPE.CRYSTAL) then --11:神装晶石
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.REDSCROLL) then --12:红装卷轴
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.NETDRAWCARD) then --13:服务器下发的抽卡类卡包
			--暂不支持
		elseif (rewardType == Reward.TYPE.HEROEXP) then --14:英雄经验
			--暂不支持
		elseif (rewardType == Reward.TYPE.LUCKYREDCHEST) then --15:幸运神器锦囊
			--暂不支持
		elseif (rewardType == Reward.TYPE.IRON) then --16:铁 --geyachao: 新加房间的配置项 军团
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.WOOD) then --17:木材 --geyachao: 新加房间的配置项 军团
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.FOOD) then --18:粮食 --geyachao: 新加房间的配置项 军团
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.GROUPCOIN) then --20:军团币 --geyachao: 新加房间的配置项 军团
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TOWERADDONESFREE) then --21:强化免费券
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TREASUREDEBRIS) then --22:宝物碎片
			--暂不支持
		elseif (rewardType == Reward.TYPE.CANGBAOTU_NORMAL) then --23:藏宝图
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.CANGBAOTU_HIGH) then --24:高级藏宝图
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.PVPCOIN) then --25:兵符
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.CHOUJIANG_FREETICKET) then --26:抽奖免费券
			--暂不支持
		elseif (rewardType == Reward.TYPE.ZHANGONG_SCORE) then --27:战功积分
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.ACHEVEMENT_POINT) then --28:成就点
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.IKUN_SCORE) then --29:爱鲲积分
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TASK_STONE) then --100:任务之石
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.WEAPONGUN_DEBRIS) then --101:武器枪碎片
			--暂不支持
		elseif (rewardType == Reward.TYPE.PET_DEBRIS) then --103:宠物碎片
			--暂不支持
		elseif (rewardType == Reward.TYPE.SCIENTIST_DEBRIS) then --104:科学家碎片
			--暂不支持
		elseif (rewardType == Reward.TYPE.WEAPONGUN_CHEST) then --105:武器枪宝箱
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TACTIC_CHEST) then --106:战术卡宝箱
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.PET_CHEST) then --107:宠物宝箱
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.EQUIP_CHEST) then --108:装备宝箱
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.SCIENTIST_CHEST) then --109:科学家宝箱
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT1) then --110:科学家成就1
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT2) then --111:科学家成就2
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT3) then --112:科学家成就3
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT4) then --113:科学家成就4
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.DISHU_COIN) then --114:地鼠币
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT1) then --115:垃圾堆成就1
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT2) then --116:垃圾堆成就2
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT3) then --117:垃圾堆成就3
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT4) then --118:垃圾堆成就4
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT5) then --119:垃圾堆成就5
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TALENT_POINT) then --120:天赋点
			appendIdx = 2
		end
		
		return appendIdx
	end
	
	--获取宝箱获取时间
	function Reward:ToCmd()
		local ret = ""
		local retDic = {}
		
		if type(self._list) == "table" then
			for i = 1,self._num do
				local v = self._list[i] or {}
				if v[1] and v[1] == Reward.TYPE.REDEQUIP and type(v[3]) == "table" then
					ret = ret .. (v[1] or 0)..":"..(v[2] or 0)..":"..(v[3]:InfoToCmdEx())..":"..(v[4] or 0)..";"
				else
					ret = ret .. (v[1] or 0)..":"..(v[2] or 0)..":"..(v[3] or 0)..":"..(v[4] or 0)..";"
				end
			end

			ret = self._num .. ";" .. ret
		else
			ret = "0;"
		end

		return ret
	end
	
	--获取宝箱获取时间
	function Reward:ToCmdNoNum()
		local ret = ""
		local retDic = {}
		
		if type(self._list) == "table" then
			for i = 1,self._num do
				local v = self._list[i] or {}
				if v[1] and v[1] == Reward.TYPE.REDEQUIP and type(v[3]) == "table" then
					ret = ret .. (v[1] or 0)..":"..(v[2] or 0)..":"..(v[3]:InfoToCmdEx())..":"..(v[4] or 0)..";"
				else
					ret = ret .. (v[1] or 0)..":"..(v[2] or 0)..":"..(v[3] or 0)..":"..(v[4] or 0)..";"
				end
			end

			--ret = self._num .. ";" .. ret
		else
			--ret = "0;"
		end

		return ret
	end
    
return Reward