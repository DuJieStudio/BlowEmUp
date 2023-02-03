
--=======================================================英雄配置=======================================================
--英雄卡升级经验
hVar.HERO_EXP = 
{	
	--[等级] = {当前等级最低经验值 = 10, 升到下一级所需经验值 = 10,}
	[1] =	{minExp = 0,						nextExp = 10,					unlockTalentNum = 1},
	[2] =	{minExp = 10,						nextExp = 30,					unlockTalentNum = 1},
	[3] =	{minExp = 40,						nextExp = 80,					unlockTalentNum = 1},
	[4] =	{minExp = 120,						nextExp = 150,					unlockTalentNum = 1},
	[5] =	{minExp = 270,						nextExp = 240,					unlockTalentNum = 1},
	[6] =	{minExp = 510,						nextExp = 350,					unlockTalentNum = 1},
	[7] =	{minExp = 860,						nextExp = 480,					unlockTalentNum = 1},
	[8] =	{minExp = 1340,						nextExp = 630,					unlockTalentNum = 1},
	[9] =	{minExp = 1970,						nextExp = 800,					unlockTalentNum = 1},
	[10] =	{minExp = 2770,						nextExp = 990,					unlockTalentNum = 1},

	[11] =	{minExp = 3760,						nextExp = 2400,					unlockTalentNum = 1},
	[12] =	{minExp = 6160,						nextExp = 2860,					unlockTalentNum = 1},
	[13] =	{minExp = 9020,						nextExp = 3360,					unlockTalentNum = 1},
	[14] =	{minExp = 12380,					nextExp = 3900,					unlockTalentNum = 1},
	[15] =	{minExp = 16280,					nextExp = 4480,					unlockTalentNum = 2},

	[16] =	{minExp = 20760,					nextExp = 5100,					unlockTalentNum = 2},
	[17] =	{minExp = 25860,					nextExp = 5760,					unlockTalentNum = 2},
	[18] =	{minExp = 31620,					nextExp = 6460,					unlockTalentNum = 2},
	[19] =	{minExp = 38080,					nextExp = 7200,					unlockTalentNum = 2},
	[20] =	{minExp = 45280,					nextExp = 7980,					unlockTalentNum = 2},

	[21] =	{minExp = 53260,					nextExp = 8800,					unlockTalentNum = 2},
	[22] =	{minExp = 62060,					nextExp = 9660,					unlockTalentNum = 2},
	[23] =	{minExp = 71720,					nextExp = 10560,				unlockTalentNum = 2},
	[24] =	{minExp = 82280,					nextExp = 11500,				unlockTalentNum = 2},
	[25] =	{minExp = 93780,					nextExp = 12480,				unlockTalentNum = 2},

	[26] =	{minExp = 106260,					nextExp = 13500,				unlockTalentNum = 2},
	[27] =	{minExp = 119760,					nextExp = 14560,				unlockTalentNum = 2},
	[28] =	{minExp = 134320,					nextExp = 15660,				unlockTalentNum = 2},
	[29] =	{minExp = 149980,					nextExp = 16800,				unlockTalentNum = 2},
	[30] =	{minExp = 166780,					nextExp = 17980,				unlockTalentNum = 2},

	[31] =	{minExp = 184760,					nextExp = 19200,				unlockTalentNum = 2},
	[32] =	{minExp = 203960,					nextExp = 20460,				unlockTalentNum = 2},
	[33] =	{minExp = 224420,					nextExp = 21760,				unlockTalentNum = 2},
	[34] =	{minExp = 246180,					nextExp = 23100,				unlockTalentNum = 2},
	[35] =	{minExp = 269280,					nextExp = 24480,				unlockTalentNum = 2},

	[36] =	{minExp = 293760,					nextExp = 25900,				unlockTalentNum = 2},
	[37] =	{minExp = 319660,					nextExp = 27360,				unlockTalentNum = 2},
	[38] =	{minExp = 347020,					nextExp = 28860,				unlockTalentNum = 2},
	[39] =	{minExp = 375880,					nextExp = 30400,				unlockTalentNum = 2},
	[40] =	{minExp = 406280,					nextExp = nil,					unlockTalentNum = 2},		--升满级了，就不让再吃经验了。满级这里填nil
}

--英雄技能升级消耗
hVar.SKILL_LVUP_COST = 
{
	[1] =	101, --商品id
	[2] =	102,
	[3] =	103,
	[4] =	104,
	[5] =	105,
	[6] =	106,
	[7] =	107,
	[8] =	108,
	[9] =	109,
	[10] =	110,
	[11] =	111,
	[12] =	112,
	[13] =	113,
	[14] =	114,
	[15] =	115,
	[16] =	116,
	[17] =	117,
	[18] =	118,
	[19] =	119,
	[20] =	120,
	[21] =	121,
	[22] =	122,
	[23] =	123,
	[24] =	124,
	[25] =	125,
	[26] =	126,
	[27] =	127,
	[28] =	128,
	[29] =	129,
	[30] =	130,
	[31] =	131,
	[32] =	132,
	[33] =	133,
	[34] =	134,
	[35] =	135,
	[36] =	136,
	[37] =	137,
	[38] =	138,
	[39] =	139,
	[40] =	140,
}

--玩家英雄管理类
local Hero = class("Hero")
	
	--英雄解锁商品id
	Hero.HERO_UNLOCK_SHOPITEMID = 290
	--当前开放的星级上限
	Hero.MAX_STAR_LV = 2
	--当前开放的最大英雄技能数量
	Hero.TALENT_SIZE = 4
	--当前开放的最大英雄战术技能数量
	Hero.TACTIC_SIZE = 1
	--当前英雄装备部位数量
	Hero.EQUIP_SLOT_NUM = 4

	--构造函数
	function Hero:ctor()
		--英雄id
		self._id = -1
		--英雄星级
		self._star = -1
		--英雄当前灵魂石
		self._soulstone = -1
		--英雄所有灵魂石
		self._totalSoulstone = -1
		
		
		--英雄等级
		self._level = -1
		--英雄当前经验
		self._exp = -1

		--英雄天赋技能数量
		self._talentNum = -1
		--英雄天赋技能（列表存储当前等级，与tab表中对应的等级一致）
		self._talentList = -1

		--英雄战术技能数量
		self._tacticNum = -1
		--英雄战术技能（列表存储当前等级，与tab表中对应的等级一致）
		self._tacticList = -1

		--英雄装备背包
		--self._equipSlotNum = -1
		self._equipInventory = -1

		return self
	end
	--初始化函数
	function Hero:Init(id,star,soulstone,totalSoulstone,level,exp)

		if id and hVar.tab_hero[id] then

			local tabH = hVar.tab_hero[id]

			self._id = id
			self._star = star or 1
			self._soulstone = soulstone or 0
			self._totalSoulstone = totalSoulstone or 0
			self._level = level or 1
			self._exp = exp or 0
			
			--天赋技能
			self._talentNum = 0
			self._talentList = {}
			local unlockNum = self:_GetUnlockTalentNum(self:GetLv())
			if tabH.talent and type(tabH.talent) == "table" then
				local tabTalent = tabH.talent
				for i = 1, Hero.TALENT_SIZE do
					local skillId = 0
					local skillLv = 0
					if tabTalent[i] then
						skillId = tabTalent[i][1] or 0
					end
					if skillId > 0 and i <= unlockNum then
						skillLv = 1
					end
					self._talentList[i] = {id = skillId, lv = skillLv}
					self._talentNum = self._talentNum + 1
				end
			end

			--战术技能
			self._tacticNum = 0
			self._tacticList = {}
			if tabH.tactics and type(tabH.tactics) == "table" then
				local tabTactic = tabH.tactics
				for i = 1, Hero.TACTIC_SIZE do
					local tacticId = 0
					local tacticLv = 0
					if tabTactic[i] then
						tacticId = tabTactic[i] or 0
					end
					--目前逻辑写死
					if tacticId > 0 then
						tacticLv = 1
					end
					self._tacticList[i] = {id = tacticId, lv = tacticLv}
					self._tacticNum = self._tacticNum + 1
				end
			end

			--英雄装备背包
			--self._equipSlotNum = Hero.EQUIP_SLOT_NUM
			self._equipInventory = hClass.InventoryMgr:create():Init(Hero.EQUIP_SLOT_NUM)

			return self
		else
			return
		end
	end
	
	--初始化函数2 (参数 数据库存储的英雄数据)（格式 Id:星:当前灵魂石:历史上灵魂石数量:等级:当前经验值:天赋数量x:天赋1等级:...:天赋x等级:战术数量y:战术1等级:...:战术y等级:装备栏数量z:装备1的DBID:...:装备z的DBID;）
	function Hero:InitByProtoBuf(protoBuf)
		--print("初始化函数2", protoBuf)
		local ret = false

		local tHeroList = hApi.Split(protoBuf,":")
		
		--英雄id
		local id = tonumber(tHeroList[1]) or 0
		--print("英雄id=",id, hVar.tab_hero[id])
		if id and hVar.tab_hero[id] then
			local tabH = hVar.tab_hero[id]
			local maxLv = 10
			
			----------------------------------------------解析protobuf----------------------------------------------
			--基本信息
			local star = tonumber(tHeroList[2]) or 1
			local soulstone = tonumber(tHeroList[3]) or 0
			local totalSoulstone = tonumber(tHeroList[4]) or 0
			local level = tonumber(tHeroList[5]) or 1
			local exp = tonumber(tHeroList[6]) or 0
			--print("基本信息")
			--天赋技能
			local talentNum = tonumber(tHeroList[7]) or 0
			local talentIdx = 7
			local talentLv = {}
			for i = 1, talentNum do
				talentLv[i] = tonumber(tHeroList[talentIdx + i]) or 1
			end
			--print("天赋技能")
			--战术技能卡碎片
			local tacticIdx = talentIdx + talentNum + 1
			local tacticNum = tonumber(tHeroList[tacticIdx]) or 0
			local tacticLv = {}
			for i = 1, tacticNum do
				tacticLv[i] = tonumber(tHeroList[tacticIdx + i]) or 0
			end
			--print("战术技能卡碎片")
			--装备背包
			local equipIdx = tacticIdx + tacticNum + 1
			local equipSlotNum = tonumber(tHeroList[equipIdx]) or 0
			local equipInventory = {}
			for i = 1, equipSlotNum do
				equipInventory[i] = tonumber(tHeroList[equipIdx + i]) or 0
			end
			--print("装备背包")
			----------------------------------------------基本信息赋值----------------------------------------------
			--根据基本信息判定最大等级
			local starInfo = tabH.starInfo
			if starInfo and starInfo[star] then
				maxLv = starInfo[star].maxLv
			end
			--print("根据基本信息判定最大等级")
			--基本信息复制
			self._id = id
			self._star = star
			self._soulstone = soulstone
			self._totalSoulstone = totalSoulstone
			self._level = level
			self._exp = exp
			
			--print("基本信息复制")
			--print("self._id", id)
			--print("self._star", star)
			--print("self._soulstone", soulstone)
			--print("self._totalSoulstone", totalSoulstone)
			--print("self._exp", exp)
			
			--天赋技能
			self._talentNum = 0
			self._talentList = {}
			local unlockNum = self:_GetUnlockTalentNum(self:GetLv())
			--print("unlockNum=", unlockNum)
			if tabH.talent and type(tabH.talent) == "table" then
				--print("tabH.talent and type(tabH.talent) == table")
				for i = 1, Hero.TALENT_SIZE do
					local talent = tabH.talent[i] or {}
					if i > unlockNum then
						self._talentList[#self._talentList + 1] = {id = talent[1] or 0, lv = 0}
					else
						self._talentList[#self._talentList + 1] = {id = talent[1] or 0, lv = math.min(talentLv[i] or talent[2] or 1, maxLv)}
					end
					self._talentNum = self._talentNum + 1
				end
			end
			--print("天赋技能")
			--战术技能
			self._tacticNum = 0
			self._tacticList = {}
			if tabH.tactics and type(tabH.tactics) == "table" then
				for i = 1, Hero.TACTIC_SIZE do
					local tacticId = tabH.tactics[i]
					self._tacticList[#self._tacticList + 1] = {id = tacticId or 0, lv = math.min(tacticLv[i] or 1, maxLv)}
					self._tacticNum = self._tacticNum + 1
				end
			end
			--print("战术技能")
			--英雄装备背包
			--self._equipSlotNum = Hero.EQUIP_SLOT_NUM
			self._equipInventory = hClass.InventoryMgr:create():Init(Hero.EQUIP_SLOT_NUM)
			for i = 1, Hero.EQUIP_SLOT_NUM do
				self._equipInventory:SetItem(i,equipInventory[i] or 0)
			end
			--print("英雄装备背包")
			ret = true
			
			return ret
		else
			return ret
		end
	end
	
	--释放英雄资源
	function Hero:Release()
		--英雄id
		self._id = -1
		--英雄星级
		self._star = -1
		--英雄当前灵魂石
		self._soulstone = -1
		--英雄所有灵魂石
		self._totalSoulstone = -1
		
		
		--英雄等级
		self._level = -1
		--英雄当前经验
		self._exp = -1

		--英雄天赋技能数量
		self._talentNum = -1
		--英雄天赋技能（列表存储当前等级，与tab表中对应的等级一致）
		self._talentList = -1

		--英雄战术技能数量
		self._tacticNum = -1
		--英雄战术技能（列表存储当前等级，与tab表中对应的等级一致）
		self._tacticList = -1

		--英雄装备背包
		--self._equipSlotNum = -1
		self._equipInventory = -1
	end

	------------------------------------------------------------private-------------------------------------------------------
	--获取当前等级解锁的战术技能的数量
	function Hero:_GetUnlockTalentNum(lv)
		local ret = 0

		local expInfo = hVar.HERO_EXP[lv]
		if expInfo then
			ret = expInfo.unlockTalentNum
		end
		
		return ret
	end

	------------------------------------------------------------public-------------------------------------------------------
	--=====================get=====================
	--获取英雄Id
	function Hero:GetID()
		return self._id
	end
	--获取英雄星级
	function Hero:GetStar()
		return self._star
	end
	--获取英雄剩余将魂
	function Hero:GetSoulstone()
		return self._soulstone
	end
	--获取英雄历史上获得的所有将魂
	function Hero:GetTotalSoulstone()
		return self._totalSoulstone
	end
	--获取英雄等级
	function Hero:GetLv()
		return self._level
	end
	--根据等级算出经验
	function Hero:GetLvByExp(exp)
		local lv = 1

		for i = 2, #hVar.HERO_EXP do
			local expInfo = hVar.HERO_EXP[i]
			if exp < expInfo.minExp then
				break
			end
			lv = i
		end

		return lv
	end
	--根据等级取得当前等级初始的经验
	function Hero:GetLevelMinExp(lv)
		if lv then
			local expInfo = hVar.HERO_EXP[lv]
			if expInfo then
				return expInfo.minExp
			end
		end
	end
	--获取英雄当前经验
	function Hero:GetExp()
		return self._exp
	end
	--获取天赋技能数量
	function Hero:GetTalentNum()
		return self._talentNum
	end
	--获取天赋技能
	function Hero:GetTalent(idx)
		return self._talentList[idx]
	end
	--获取战术技能数量
	function Hero:GetTacticNum()
		return self._tacticNum
	end
	--获取战术技能
	function Hero:GetTactic(idx)
		return self._tacticList[idx]
	end
	--获取装备槽数量
	function Hero:GetEquipSlotNum()
		return self._equipInventory:GetCapacity()
	end
	--获取装备
	function Hero:GetEquip(slotIdx)
		return self._equipInventory:GetItem(slotIdx)
	end

	--=====================operate=====================
	--设置英雄星级
	function Hero:SetStar(star)
		self._star = math.min(star or 1,Hero.MAX_STAR_LV)
	end
	--设置英雄等级(等级，是否刷根据重刷exp)
	function Hero:SetLv(lv)

		local star = self:GetStar()				--当前星级
		local tabH = hVar.tab_hero[self:GetID()]
		local starInfo = tabH.starInfo
		
		--人物可升级到当前星级所限定的最大等级。（如果未达到版本最大等级，升级经验可以超出，但不能升至下一级）
		local maxLv = starInfo[star].maxLv

		self._level = math.min(lv,maxLv)

		--根据等级解锁技能
		local unlockNum = self:_GetUnlockTalentNum(self._level)
		for idx = 1, Hero.TALENT_SIZE do
			local talent = self:GetTalent(idx)
			if talent and idx <= unlockNum and talent.lv <= 0 then
				self:SetTalentLv(1)
			elseif talent and idx > unlockNum then
				self:SetTalentLv(0)
			end
		end
		--刷新经验值
		self._exp = self:GetLevelMinExp(self._level)
	end

	--英雄将魂增加
	function Hero:AddSoulstone(num)
		local addNum = num or 0
		self._soulstone = self._soulstone + addNum
		self._totalSoulstone = self._totalSoulstone + addNum
	end

	--检测英雄是否可以升星
	function Hero:CheckCanStarLvUp()
		local ret = false
		
		local star = self:GetStar()
		local soulstone = self:GetSoulstone()
		local heroId = self:GetID()
		local tabH = hVar.tab_hero[heroId]
		
		--星级已经大于当前设定的最大等级，返回失败
		if tabH and star < Hero.MAX_STAR_LV then
			local heroStarInfo = tabH.starInfo
			if heroStarInfo then
				local starInfo = heroStarInfo[star]
				local costSoulStone = starInfo.costSoulStone			--升至下一级需要将魂数量
				
				--如果当前将魂小于需要消耗的将魂，返回失败
				if soulstone >= costSoulStone then
					ret = true
				end
			end
		end

		return ret
	end
	--英雄升星
	function Hero:StarLvUp()
		local ret = false
		if self:CheckCanStarLvUp() then
			local star = self:GetStar()
			local heroId = self:GetID()
			local tabH = hVar.tab_hero[heroId]
			if tabH then
				local heroStarInfo = tabH.starInfo
				if heroStarInfo then
					local starInfo = heroStarInfo[star]
					local costSoulStone = starInfo.costSoulStone			--升至下一级需要将魂数量
					self._star = self._star + 1
					self._soulstone = self._soulstone - costSoulStone
					ret = true
				end
			end
		end
		return ret
	end
	--获取升星所需消耗(返回: 对应商品id,对应道具id,游戏币消耗,积分消耗)
	function Hero:GetStarLvUpCost()
		local star = self:GetStar()
		local shopItemId = 0
		local itemId = 0
		local gamecoin = 0
		local score = 0
		local heroId = self:GetID()
		local tabH = hVar.tab_hero[heroId]
		if tabH then
			local heroStarInfo = tabH.starInfo
			if heroStarInfo then
				local starInfo = heroStarInfo[star]
				shopItemId = starInfo.shopItemId or 0
				local tabShopItem = hVar.tab_shopitem[shopItemId]
				if tabShopItem then
					itemId = tabShopItem.itemID or 0
					gamecoin = tabShopItem.rmb
					score = tabShopItem.score
				end
			end
		end
		return shopItemId,itemId,gamecoin,score
	end

	--检测英雄是否可以解锁
	function Hero:CheckCanUnlock()
		local ret = false
		
		local star = self:GetStar()
		local soulstone = self:GetSoulstone()
		local heroId = self:GetID()
		local tabH = hVar.tab_hero[heroId]
		
		--星级已经大于当前设定的最大等级，返回失败
		if tabH and star <= 0 then
			local unlockInfo = tabH.unlock
			if unlockInfo and unlockInfo.arenaUnlock then
				local costSoulStone = unlockInfo.costSoulStone			--升至下一级需要将魂数量
				
				--如果当前将魂小于需要消耗的将魂，返回失败
				if soulstone >= costSoulStone then
					ret = true
				end
			end
		end

		return ret
	end
	--英雄解锁
	function Hero:Unlock()
		local ret = false
		if self:CheckCanUnlock() then
			local star = self:GetStar()
			local heroId = self:GetID()
			local tabH = hVar.tab_hero[heroId]
			if tabH then
				local unlockInfo = tabH.unlock
				if unlockInfo then
					local costSoulStone = unlockInfo.costSoulStone			--升至下一级需要将魂数量
					self._star = 1
					self._soulstone = self._soulstone - costSoulStone
					ret = true
				end
			end
		end
		return ret
	end
	--获取解锁所需消耗(返回: 对应商品id,对应道具id,游戏币消耗,积分消耗)
	function Hero:GetUnlockCost()
		local shopItemId = 0
		local itemId = 0
		local gamecoin = 0
		local score = 0

		shopItemId = Hero.HERO_UNLOCK_SHOPITEMID or 0
		local tabShopItem = hVar.tab_shopitem[shopItemId]
		if tabShopItem then
			itemId = tabShopItem.itemID or 0
			gamecoin = tabShopItem.rmb
			score = tabShopItem.score
		end

		return shopItemId,itemId,gamecoin,score
	end

	--英雄增加经验(自动升级流程)
	function Hero:AddExp(exp)
		
		local ret = false

		local expNow = self:GetExp()				--当前经验值
		local lvNow = self:GetLvByExp(expNow)			--当前等级
		local star = self:GetStar()				--当前星级
		local maxStar = Hero.MAX_STAR_LV			--版本最大星级
		
		local tabH = hVar.tab_hero[self:GetID()]
		local starInfo = tabH.starInfo
		
		--人物可升级到当前星级所限定的最大等级。（如果未达到版本最大等级，升级经验可以超出，但不能升至下一级）
		local maxLvByStar = starInfo[star].maxLv
		local maxLv = starInfo[maxStar].maxLv
		
		--初步计算增加经验可提升的等级
		local tmpExp = expNow + exp
		local tmpLv = self:GetLvByExp(tmpExp)
		
		if tmpLv <= maxLvByStar then
			--如果小于等于星级所对应的最大等级，则直接修改经验及等级
			self._exp = tmpExp
			self._level = tmpLv
		elseif tmpLv > maxLvByStar then
			--如果大于星级所对应的最大等级，但小于版本等级，等级为为星级对应最大等级，经验设置为下一等级-1
			local expInfo = hVar.HERO_EXP[maxLvByStar]
			self._exp = expInfo.minExp + expInfo.nextExp - 1
			self._level = maxLvByStar
		end
		
		--如果升级了(lvNow升钱等级,tHeroCard.attr.level升后等级)
		if lvNow < self:GetLv() then
			local unlockNum = self:_GetUnlockTalentNum(self:GetLv())

			for idx = 1, unlockNum do
				local talent = self:GetTalent(idx)
				if talent and talent.lv <= 0 then
					self:SetTalentLv(1)
				end
			end
		end

		ret = true

		return ret

	end

	--设置天赋技能等级
	function Hero:SetTalentLv(idx, lv)
		local ret = false
		if self._talentList[idx] then
			self._talentList[idx].lv = lv
			ret = true
		end
		return ret
	end

	--设置战术技能等级
	function Hero:SetTacticLv(idx, lv)
		local ret = false
		if self._tacticList[idx] then
			self._tacticList[idx].lv = lv
			ret = true
		end
		return ret
	end

	--检测是否可以升级技能
	function Hero:CheckCanLevelUpTalent(idx)

		local ret = false
		local level = self:GetLv()
		local heroId = self:GetID()
		local tabH = hVar.tab_hero[heroId]
		local starInfo = tabH.starInfo
		local maxLv = starInfo.maxLv					--等级上限
		local talent = self:GetTalent(idx)

		if idx > self:_GetUnlockTalentNum(level) or idx > Hero.TALENT_SIZE then
			return ret
		end

		if talent.id <= 0 then
			return ret
		end
		
		if talent.lv >= math.min(maxLv, level) then
			return ret
		end

		ret = true

		return ret
	end

	--英雄技能升级
	function Hero:TalentLevelUp(idx)

		local ret = self:CheckCanLevelUpTalent(idx)

		if ret then
			local talent = self:GetTalent(idx)
			local lv = talent.lv + 1
			self:SetTalentLv(idx, lv)

			--统计技能升级次数 todo
			--LuaAddPlayerCountVal(hVar.MEDAL_TYPE.sLvUp)
			--LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.sLvUp)
		end

		return ret
	end

	--检测是否可以升级技能
	function Hero:CheckCanLevelUpTactic(idx)

		local ret = false

		local level = self:GetLv()
		local heroId = self:GetID()
		local tabH = hVar.tab_hero[heroId]
		local starInfo = tabH.starInfo
		local maxLv = starInfo.maxLv					--等级上限
		local tactic = self:GetTactic(idx)

		if tactic.id <= 0 then
			return ret
		end
		
		if tactic.lv >= math.min(maxLv, level) then
			return ret
		end

		ret = true

		return ret
	end

	--英雄战术技能升级
	function Hero:TacticLevelUp(idx)

		local ret = self:CheckCanLevelUpTactic(idx)

		if ret then
			local tactic = self:GetTactic(idx)
			local lv = tactic.lv + 1
			self:SetTacticLv(idx, lv)

			--统计技能升级次数 todo
			--LuaAddPlayerCountVal(hVar.MEDAL_TYPE.sLvUp)
			--LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.sLvUp)
		end

		return ret
	end
	
	--=====================infotocmd=====================
	--基本信息转化
	function Hero:InfoToCmd()
		
		local cmd = ""
		
		--基本信息
		cmd = cmd .. tostring(self:GetID()) .. ":"
		cmd = cmd .. tostring(self:GetStar()) .. ":"
		cmd = cmd .. tostring(self:GetSoulstone()) .. ":"
		cmd = cmd .. tostring(self:GetTotalSoulstone()) .. ":"
		cmd = cmd .. tostring(self:GetLv()) .. ":"
		cmd = cmd .. tostring(self:GetExp()) .. ":"
		
		--天赋技能
		local talentNum = self:GetTalentNum()
		cmd = cmd .. tostring(talentNum) .. ":"
		for i = 1, talentNum do
			local talent = self:GetTalent(i)
			cmd = cmd .. tostring(talent.lv or 0) .. ":"
		end
		
		--战术技能
		local tacticNum = self:GetTacticNum()
		cmd = cmd .. tostring(tacticNum) .. ":"
		for i = 1, tacticNum do
			local tactic = self:GetTactic(i)
			cmd = cmd .. tostring(tactic.lv or 0) .. ":"
		end
		
		--装备槽
		local equipSlotNum = self:GetEquipSlotNum()
		cmd = cmd .. tostring(equipSlotNum)
		for i = 1, equipSlotNum do
			local equipDBID = self:GetEquip(i)
			cmd = cmd .. tostring(equipDBID or 0)
			if i < equipSlotNum then
				cmd = cmd .. ":"
			end
		end
		
		cmd = cmd .. ";"
		
		return cmd
	end
return Hero