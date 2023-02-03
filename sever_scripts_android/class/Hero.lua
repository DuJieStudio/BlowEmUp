
--=======================================================Ӣ������=======================================================
--Ӣ�ۿ���������
hVar.HERO_EXP = 
{	
	--[�ȼ�] = {��ǰ�ȼ���;���ֵ = 10, ������һ�����辭��ֵ = 10,}
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
	[40] =	{minExp = 406280,					nextExp = nil,					unlockTalentNum = 2},		--�������ˣ��Ͳ����ٳԾ����ˡ�����������nil
}

--Ӣ�ۼ�����������
hVar.SKILL_LVUP_COST = 
{
	[1] =	101, --��Ʒid
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

--���Ӣ�۹�����
local Hero = class("Hero")
	
	--Ӣ�۽�����Ʒid
	Hero.HERO_UNLOCK_SHOPITEMID = 290
	--��ǰ���ŵ��Ǽ�����
	Hero.MAX_STAR_LV = 2
	--��ǰ���ŵ����Ӣ�ۼ�������
	Hero.TALENT_SIZE = 4
	--��ǰ���ŵ����Ӣ��ս����������
	Hero.TACTIC_SIZE = 1
	--��ǰӢ��װ����λ����
	Hero.EQUIP_SLOT_NUM = 4

	--���캯��
	function Hero:ctor()
		--Ӣ��id
		self._id = -1
		--Ӣ���Ǽ�
		self._star = -1
		--Ӣ�۵�ǰ���ʯ
		self._soulstone = -1
		--Ӣ���������ʯ
		self._totalSoulstone = -1
		
		
		--Ӣ�۵ȼ�
		self._level = -1
		--Ӣ�۵�ǰ����
		self._exp = -1

		--Ӣ���츳��������
		self._talentNum = -1
		--Ӣ���츳���ܣ��б�洢��ǰ�ȼ�����tab���ж�Ӧ�ĵȼ�һ�£�
		self._talentList = -1

		--Ӣ��ս����������
		self._tacticNum = -1
		--Ӣ��ս�����ܣ��б�洢��ǰ�ȼ�����tab���ж�Ӧ�ĵȼ�һ�£�
		self._tacticList = -1

		--Ӣ��װ������
		--self._equipSlotNum = -1
		self._equipInventory = -1

		return self
	end
	--��ʼ������
	function Hero:Init(id,star,soulstone,totalSoulstone,level,exp)

		if id and hVar.tab_hero[id] then

			local tabH = hVar.tab_hero[id]

			self._id = id
			self._star = star or 1
			self._soulstone = soulstone or 0
			self._totalSoulstone = totalSoulstone or 0
			self._level = level or 1
			self._exp = exp or 0
			
			--�츳����
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

			--ս������
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
					--Ŀǰ�߼�д��
					if tacticId > 0 then
						tacticLv = 1
					end
					self._tacticList[i] = {id = tacticId, lv = tacticLv}
					self._tacticNum = self._tacticNum + 1
				end
			end

			--Ӣ��װ������
			--self._equipSlotNum = Hero.EQUIP_SLOT_NUM
			self._equipInventory = hClass.InventoryMgr:create():Init(Hero.EQUIP_SLOT_NUM)

			return self
		else
			return
		end
	end
	
	--��ʼ������2 (���� ���ݿ�洢��Ӣ������)����ʽ Id:��:��ǰ���ʯ:��ʷ�����ʯ����:�ȼ�:��ǰ����ֵ:�츳����x:�츳1�ȼ�:...:�츳x�ȼ�:ս������y:ս��1�ȼ�:...:ս��y�ȼ�:װ��������z:װ��1��DBID:...:װ��z��DBID;��
	function Hero:InitByProtoBuf(protoBuf)
		--print("��ʼ������2", protoBuf)
		local ret = false

		local tHeroList = hApi.Split(protoBuf,":")
		
		--Ӣ��id
		local id = tonumber(tHeroList[1]) or 0
		--print("Ӣ��id=",id, hVar.tab_hero[id])
		if id and hVar.tab_hero[id] then
			local tabH = hVar.tab_hero[id]
			local maxLv = 10
			
			----------------------------------------------����protobuf----------------------------------------------
			--������Ϣ
			local star = tonumber(tHeroList[2]) or 1
			local soulstone = tonumber(tHeroList[3]) or 0
			local totalSoulstone = tonumber(tHeroList[4]) or 0
			local level = tonumber(tHeroList[5]) or 1
			local exp = tonumber(tHeroList[6]) or 0
			--print("������Ϣ")
			--�츳����
			local talentNum = tonumber(tHeroList[7]) or 0
			local talentIdx = 7
			local talentLv = {}
			for i = 1, talentNum do
				talentLv[i] = tonumber(tHeroList[talentIdx + i]) or 1
			end
			--print("�츳����")
			--ս�����ܿ���Ƭ
			local tacticIdx = talentIdx + talentNum + 1
			local tacticNum = tonumber(tHeroList[tacticIdx]) or 0
			local tacticLv = {}
			for i = 1, tacticNum do
				tacticLv[i] = tonumber(tHeroList[tacticIdx + i]) or 0
			end
			--print("ս�����ܿ���Ƭ")
			--װ������
			local equipIdx = tacticIdx + tacticNum + 1
			local equipSlotNum = tonumber(tHeroList[equipIdx]) or 0
			local equipInventory = {}
			for i = 1, equipSlotNum do
				equipInventory[i] = tonumber(tHeroList[equipIdx + i]) or 0
			end
			--print("װ������")
			----------------------------------------------������Ϣ��ֵ----------------------------------------------
			--���ݻ�����Ϣ�ж����ȼ�
			local starInfo = tabH.starInfo
			if starInfo and starInfo[star] then
				maxLv = starInfo[star].maxLv
			end
			--print("���ݻ�����Ϣ�ж����ȼ�")
			--������Ϣ����
			self._id = id
			self._star = star
			self._soulstone = soulstone
			self._totalSoulstone = totalSoulstone
			self._level = level
			self._exp = exp
			
			--print("������Ϣ����")
			--print("self._id", id)
			--print("self._star", star)
			--print("self._soulstone", soulstone)
			--print("self._totalSoulstone", totalSoulstone)
			--print("self._exp", exp)
			
			--�츳����
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
			--print("�츳����")
			--ս������
			self._tacticNum = 0
			self._tacticList = {}
			if tabH.tactics and type(tabH.tactics) == "table" then
				for i = 1, Hero.TACTIC_SIZE do
					local tacticId = tabH.tactics[i]
					self._tacticList[#self._tacticList + 1] = {id = tacticId or 0, lv = math.min(tacticLv[i] or 1, maxLv)}
					self._tacticNum = self._tacticNum + 1
				end
			end
			--print("ս������")
			--Ӣ��װ������
			--self._equipSlotNum = Hero.EQUIP_SLOT_NUM
			self._equipInventory = hClass.InventoryMgr:create():Init(Hero.EQUIP_SLOT_NUM)
			for i = 1, Hero.EQUIP_SLOT_NUM do
				self._equipInventory:SetItem(i,equipInventory[i] or 0)
			end
			--print("Ӣ��װ������")
			ret = true
			
			return ret
		else
			return ret
		end
	end
	
	--�ͷ�Ӣ����Դ
	function Hero:Release()
		--Ӣ��id
		self._id = -1
		--Ӣ���Ǽ�
		self._star = -1
		--Ӣ�۵�ǰ���ʯ
		self._soulstone = -1
		--Ӣ���������ʯ
		self._totalSoulstone = -1
		
		
		--Ӣ�۵ȼ�
		self._level = -1
		--Ӣ�۵�ǰ����
		self._exp = -1

		--Ӣ���츳��������
		self._talentNum = -1
		--Ӣ���츳���ܣ��б�洢��ǰ�ȼ�����tab���ж�Ӧ�ĵȼ�һ�£�
		self._talentList = -1

		--Ӣ��ս����������
		self._tacticNum = -1
		--Ӣ��ս�����ܣ��б�洢��ǰ�ȼ�����tab���ж�Ӧ�ĵȼ�һ�£�
		self._tacticList = -1

		--Ӣ��װ������
		--self._equipSlotNum = -1
		self._equipInventory = -1
	end

	------------------------------------------------------------private-------------------------------------------------------
	--��ȡ��ǰ�ȼ�������ս�����ܵ�����
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
	--��ȡӢ��Id
	function Hero:GetID()
		return self._id
	end
	--��ȡӢ���Ǽ�
	function Hero:GetStar()
		return self._star
	end
	--��ȡӢ��ʣ�ཫ��
	function Hero:GetSoulstone()
		return self._soulstone
	end
	--��ȡӢ����ʷ�ϻ�õ����н���
	function Hero:GetTotalSoulstone()
		return self._totalSoulstone
	end
	--��ȡӢ�۵ȼ�
	function Hero:GetLv()
		return self._level
	end
	--���ݵȼ��������
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
	--���ݵȼ�ȡ�õ�ǰ�ȼ���ʼ�ľ���
	function Hero:GetLevelMinExp(lv)
		if lv then
			local expInfo = hVar.HERO_EXP[lv]
			if expInfo then
				return expInfo.minExp
			end
		end
	end
	--��ȡӢ�۵�ǰ����
	function Hero:GetExp()
		return self._exp
	end
	--��ȡ�츳��������
	function Hero:GetTalentNum()
		return self._talentNum
	end
	--��ȡ�츳����
	function Hero:GetTalent(idx)
		return self._talentList[idx]
	end
	--��ȡս����������
	function Hero:GetTacticNum()
		return self._tacticNum
	end
	--��ȡս������
	function Hero:GetTactic(idx)
		return self._tacticList[idx]
	end
	--��ȡװ��������
	function Hero:GetEquipSlotNum()
		return self._equipInventory:GetCapacity()
	end
	--��ȡװ��
	function Hero:GetEquip(slotIdx)
		return self._equipInventory:GetItem(slotIdx)
	end

	--=====================operate=====================
	--����Ӣ���Ǽ�
	function Hero:SetStar(star)
		self._star = math.min(star or 1,Hero.MAX_STAR_LV)
	end
	--����Ӣ�۵ȼ�(�ȼ����Ƿ�ˢ������ˢexp)
	function Hero:SetLv(lv)

		local star = self:GetStar()				--��ǰ�Ǽ�
		local tabH = hVar.tab_hero[self:GetID()]
		local starInfo = tabH.starInfo
		
		--�������������ǰ�Ǽ����޶������ȼ��������δ�ﵽ�汾���ȼ�������������Գ�����������������һ����
		local maxLv = starInfo[star].maxLv

		self._level = math.min(lv,maxLv)

		--���ݵȼ���������
		local unlockNum = self:_GetUnlockTalentNum(self._level)
		for idx = 1, Hero.TALENT_SIZE do
			local talent = self:GetTalent(idx)
			if talent and idx <= unlockNum and talent.lv <= 0 then
				self:SetTalentLv(1)
			elseif talent and idx > unlockNum then
				self:SetTalentLv(0)
			end
		end
		--ˢ�¾���ֵ
		self._exp = self:GetLevelMinExp(self._level)
	end

	--Ӣ�۽�������
	function Hero:AddSoulstone(num)
		local addNum = num or 0
		self._soulstone = self._soulstone + addNum
		self._totalSoulstone = self._totalSoulstone + addNum
	end

	--���Ӣ���Ƿ��������
	function Hero:CheckCanStarLvUp()
		local ret = false
		
		local star = self:GetStar()
		local soulstone = self:GetSoulstone()
		local heroId = self:GetID()
		local tabH = hVar.tab_hero[heroId]
		
		--�Ǽ��Ѿ����ڵ�ǰ�趨�����ȼ�������ʧ��
		if tabH and star < Hero.MAX_STAR_LV then
			local heroStarInfo = tabH.starInfo
			if heroStarInfo then
				local starInfo = heroStarInfo[star]
				local costSoulStone = starInfo.costSoulStone			--������һ����Ҫ��������
				
				--�����ǰ����С����Ҫ���ĵĽ��꣬����ʧ��
				if soulstone >= costSoulStone then
					ret = true
				end
			end
		end

		return ret
	end
	--Ӣ������
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
					local costSoulStone = starInfo.costSoulStone			--������һ����Ҫ��������
					self._star = self._star + 1
					self._soulstone = self._soulstone - costSoulStone
					ret = true
				end
			end
		end
		return ret
	end
	--��ȡ������������(����: ��Ӧ��Ʒid,��Ӧ����id,��Ϸ������,��������)
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

	--���Ӣ���Ƿ���Խ���
	function Hero:CheckCanUnlock()
		local ret = false
		
		local star = self:GetStar()
		local soulstone = self:GetSoulstone()
		local heroId = self:GetID()
		local tabH = hVar.tab_hero[heroId]
		
		--�Ǽ��Ѿ����ڵ�ǰ�趨�����ȼ�������ʧ��
		if tabH and star <= 0 then
			local unlockInfo = tabH.unlock
			if unlockInfo and unlockInfo.arenaUnlock then
				local costSoulStone = unlockInfo.costSoulStone			--������һ����Ҫ��������
				
				--�����ǰ����С����Ҫ���ĵĽ��꣬����ʧ��
				if soulstone >= costSoulStone then
					ret = true
				end
			end
		end

		return ret
	end
	--Ӣ�۽���
	function Hero:Unlock()
		local ret = false
		if self:CheckCanUnlock() then
			local star = self:GetStar()
			local heroId = self:GetID()
			local tabH = hVar.tab_hero[heroId]
			if tabH then
				local unlockInfo = tabH.unlock
				if unlockInfo then
					local costSoulStone = unlockInfo.costSoulStone			--������һ����Ҫ��������
					self._star = 1
					self._soulstone = self._soulstone - costSoulStone
					ret = true
				end
			end
		end
		return ret
	end
	--��ȡ������������(����: ��Ӧ��Ʒid,��Ӧ����id,��Ϸ������,��������)
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

	--Ӣ�����Ӿ���(�Զ���������)
	function Hero:AddExp(exp)
		
		local ret = false

		local expNow = self:GetExp()				--��ǰ����ֵ
		local lvNow = self:GetLvByExp(expNow)			--��ǰ�ȼ�
		local star = self:GetStar()				--��ǰ�Ǽ�
		local maxStar = Hero.MAX_STAR_LV			--�汾����Ǽ�
		
		local tabH = hVar.tab_hero[self:GetID()]
		local starInfo = tabH.starInfo
		
		--�������������ǰ�Ǽ����޶������ȼ��������δ�ﵽ�汾���ȼ�������������Գ�����������������һ����
		local maxLvByStar = starInfo[star].maxLv
		local maxLv = starInfo[maxStar].maxLv
		
		--�����������Ӿ���������ĵȼ�
		local tmpExp = expNow + exp
		local tmpLv = self:GetLvByExp(tmpExp)
		
		if tmpLv <= maxLvByStar then
			--���С�ڵ����Ǽ�����Ӧ�����ȼ�����ֱ���޸ľ��鼰�ȼ�
			self._exp = tmpExp
			self._level = tmpLv
		elseif tmpLv > maxLvByStar then
			--��������Ǽ�����Ӧ�����ȼ�����С�ڰ汾�ȼ����ȼ�ΪΪ�Ǽ���Ӧ���ȼ�����������Ϊ��һ�ȼ�-1
			local expInfo = hVar.HERO_EXP[maxLvByStar]
			self._exp = expInfo.minExp + expInfo.nextExp - 1
			self._level = maxLvByStar
		end
		
		--���������(lvNow��Ǯ�ȼ�,tHeroCard.attr.level����ȼ�)
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

	--�����츳���ܵȼ�
	function Hero:SetTalentLv(idx, lv)
		local ret = false
		if self._talentList[idx] then
			self._talentList[idx].lv = lv
			ret = true
		end
		return ret
	end

	--����ս�����ܵȼ�
	function Hero:SetTacticLv(idx, lv)
		local ret = false
		if self._tacticList[idx] then
			self._tacticList[idx].lv = lv
			ret = true
		end
		return ret
	end

	--����Ƿ������������
	function Hero:CheckCanLevelUpTalent(idx)

		local ret = false
		local level = self:GetLv()
		local heroId = self:GetID()
		local tabH = hVar.tab_hero[heroId]
		local starInfo = tabH.starInfo
		local maxLv = starInfo.maxLv					--�ȼ�����
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

	--Ӣ�ۼ�������
	function Hero:TalentLevelUp(idx)

		local ret = self:CheckCanLevelUpTalent(idx)

		if ret then
			local talent = self:GetTalent(idx)
			local lv = talent.lv + 1
			self:SetTalentLv(idx, lv)

			--ͳ�Ƽ����������� todo
			--LuaAddPlayerCountVal(hVar.MEDAL_TYPE.sLvUp)
			--LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.sLvUp)
		end

		return ret
	end

	--����Ƿ������������
	function Hero:CheckCanLevelUpTactic(idx)

		local ret = false

		local level = self:GetLv()
		local heroId = self:GetID()
		local tabH = hVar.tab_hero[heroId]
		local starInfo = tabH.starInfo
		local maxLv = starInfo.maxLv					--�ȼ�����
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

	--Ӣ��ս����������
	function Hero:TacticLevelUp(idx)

		local ret = self:CheckCanLevelUpTactic(idx)

		if ret then
			local tactic = self:GetTactic(idx)
			local lv = tactic.lv + 1
			self:SetTacticLv(idx, lv)

			--ͳ�Ƽ����������� todo
			--LuaAddPlayerCountVal(hVar.MEDAL_TYPE.sLvUp)
			--LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.sLvUp)
		end

		return ret
	end
	
	--=====================infotocmd=====================
	--������Ϣת��
	function Hero:InfoToCmd()
		
		local cmd = ""
		
		--������Ϣ
		cmd = cmd .. tostring(self:GetID()) .. ":"
		cmd = cmd .. tostring(self:GetStar()) .. ":"
		cmd = cmd .. tostring(self:GetSoulstone()) .. ":"
		cmd = cmd .. tostring(self:GetTotalSoulstone()) .. ":"
		cmd = cmd .. tostring(self:GetLv()) .. ":"
		cmd = cmd .. tostring(self:GetExp()) .. ":"
		
		--�츳����
		local talentNum = self:GetTalentNum()
		cmd = cmd .. tostring(talentNum) .. ":"
		for i = 1, talentNum do
			local talent = self:GetTalent(i)
			cmd = cmd .. tostring(talent.lv or 0) .. ":"
		end
		
		--ս������
		local tacticNum = self:GetTacticNum()
		cmd = cmd .. tostring(tacticNum) .. ":"
		for i = 1, tacticNum do
			local tactic = self:GetTactic(i)
			cmd = cmd .. tostring(tactic.lv or 0) .. ":"
		end
		
		--װ����
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