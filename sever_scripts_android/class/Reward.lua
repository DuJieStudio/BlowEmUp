--���������
local Reward = class("Reward")
	
	Reward.MAXDATA = 4				--�����������ݵ�����������

	Reward.TYPE = 
	{
		--	reward = {			--�Ǽ�����:1����,2ս�����ܿ�,3����,4Ӣ��,5����,6ս�����ܿ���Ƭ,7��Ϸ��,8���籦��,9�鿨,10��װ,11��װ��ʯ
		--		{1,1000,},		--
		--		{2,1000,1,2,},		--����,ID,����,�ȼ�
		--		{3,8996,4},		--����,ID,����,���Լ�ֵ����
		--		{4,5000,1,1},		--����,ID(����id),�Ǽ���Ĭ��Ϊ1��,�ȼ���Ĭ��Ϊ1�����ã�
		--		{5,10200,1},		--����,ID(����id),����
		--		{6,10300,1},		--����,ID(����id),����
		--		{7,10,},		--����,���(���20)
		--		{8,9004,1},		--����,ID(����id,9004,9005,9006),����
		--		{9,9101},		--����,ID(����id,9101,9102)
		--		{10,8996},		--����,ID,����
		--		{11,10},		--����,��ʯ����
		--	},
		SCORE = 1,			--1:����
		TACTIC = 2,			--2:ս����
		EQUIPITEM = 3,		--3:����
		HEROCARD = 4,		--4:Ӣ��
		HERODEBRIS = 5,		--5:Ӣ�۽���
		TACTICDEBRIS = 6,	--6:ս������Ƭ
		ONLINECOIN = 7,		--7:��Ϸ��
		NETCHEST = 8,		--8:���籦��
		DRAWCARD = 9,		--9:ս��������
		REDEQUIP = 10,		--10:��ɫ����
		CRYSTAL = 11,		--11:������ʯ
		REDSCROLL = 12,		--12:��װ�һ�ȯ
		NETDRAWCARD = 13,	--13:�������·��ĳ鿨�࿨��
		HEROEXP = 14,		--14:Ӣ�۾���
		LUCKYREDCHEST = 15,	--15:������������
		IRON = 16, --geyachao: �¼ӷ���������� ���� ��
		WOOD = 17, --geyachao: �¼ӷ���������� ���� ľ��
		FOOD = 18, --geyachao: �¼ӷ���������� ���� ��ʳ
		GROUPCOIN = 20, --geyachao: �¼ӷ���������� ���� ���ű�
		TOWERADDONESFREE = 21,	 --21:ǿ�����ȯ
		TREASUREDEBRIS = 22,	 --22:������Ƭ
		CANGBAOTU_NORMAL = 23,	 --23:�ر�ͼ
		CANGBAOTU_HIGH = 24,	 --24:�߼��ر�ͼ
		PVPCOIN = 25,		--25:����
		CHOUJIANG_FREETICKET = 26,	--26:�齱���ȯ
		ZHANGONG_SCORE = 27,		--27:ս������
		ACHEVEMENT_POINT = 28,		--28:�ɾ͵�
		IKUN_SCORE = 29,		--29:�������
		
		----------------------------------------------------
		--ս���¼ӽ�������
		TASK_STONE = 100,		--100:����֮ʯ
		WEAPONGUN_DEBRIS = 101,		--101:����ǹ��Ƭ
		PET_DEBRIS = 103,		--103:������Ƭ
		SCIENTIST_DEBRIS = 104,		--104:��ѧ����Ƭ
		WEAPONGUN_CHEST = 105,		--105:����ǹ����
		TACTIC_CHEST = 106,		--106:ս��������
		PET_CHEST = 107,		--107:���ﱦ��
		EQUIP_CHEST = 108,		--108:װ������
		SCIENTIST_CHEST = 109,		--109:��ѧ�ұ���
		SCIENTIST_ACHEVEMENT1 = 110,	--110:��ѧ�ҳɾ�1
		SCIENTIST_ACHEVEMENT2 = 111,	--111:��ѧ�ҳɾ�2
		SCIENTIST_ACHEVEMENT3 = 112,	--112:��ѧ�ҳɾ�3
		SCIENTIST_ACHEVEMENT4 = 113,	--113:��ѧ�ҳɾ�4
		DISHU_COIN = 114,		--114:�����
		TANKDEEADTH_ACHEVEMENT1 = 115,	--115:�����ѳɾ�1
		TANKDEEADTH_ACHEVEMENT2 = 116,	--116:�����ѳɾ�2
		TANKDEEADTH_ACHEVEMENT3 = 117,	--117:�����ѳɾ�3
		TANKDEEADTH_ACHEVEMENT4 = 118,	--118:�����ѳɾ�4
		TANKDEEADTH_ACHEVEMENT5 = 119,	--119:�����ѳɾ�5
		TALENT_POINT = 120,		--120:�츳��
		
		
		REWARD_MAXNUM = 120,		--���影���������ֵ
	}
	
	--���캯��
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

	--��ʼ��ս�����ܿ���Ϣ
	function Reward:_InitTacticInfo(tacticInfo)
		local tTacticInfo = hApi.Split(tacticInfo, ";")
		local tacticNum = tonumber(tTacticInfo[1]) or 0
		local infoIdx = 1
		
		local tacticDic = {}
		
		--��������ս����
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

		----��������ûĬ�Ͽ��飬û�еĻ�Ҫ��
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

	--���ս������Ƭ
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

	--ս�����ܿ���Ϣ toCmd
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

	--��ʼ��Ӣ����Ϣ
	function Reward:_InitHeroInfo(heroInfo)
		local tHeroInfo = hApi.Split(heroInfo, ";")
		local heroNum = tonumber(tHeroInfo[1]) or 0
		local infoIdx = 1
		local heroDic = {}
		
		--��������Ӣ��
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
	
	--������Ӣ��
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

	--����Ӣ�۽�����Ƭ
	function Reward:_AddHeroSoulstone(heroDic,id,num)
		--print("_AddHeroSoulstone:",heroDic,id,num)
		local ret = false
		if id > 0 and num > 0 then
			local hero = heroDic[id]
			--print("���������������:",hero)
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

	--Ӣ�۽�����Ϣ toCmd
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
	--��������
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
	
	--�޸Ľ�������
	function Reward:SetRewardNum(idx,num)
		local reward = self._list[idx]
		if reward then
			local rewardType = reward[1]
			--(1:���� / 2:ս�����ܿ� / 3:���� / 4:Ӣ�� / 5:Ӣ�۽��� / 6:ս�����ܿ���Ƭ / 7:��Ϸ�� / 8:���籦�� / 9:�齱��ս�����ܿ� / 10:���� / 11:������ʯ)
			if (rewardType == Reward.TYPE.SCORE) then --1:����
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TACTIC) then --2:ս�����ܿ�
				--�ݲ�֧��
			elseif (rewardType == Reward.TYPE.EQUIPITEM) then --3:����
				--�ݲ�֧��
			elseif (rewardType == Reward.TYPE.HEROCARD) then --4:Ӣ��
				--�ݲ�֧��
			elseif (rewardType == Reward.TYPE.HERODEBRIS) then --5:Ӣ�۽���
				reward[3] = num
			elseif (rewardType == Reward.TYPE.TACTICDEBRIS) then --6:ս�����ܿ���Ƭ
				reward[3] = num
			elseif (rewardType == Reward.TYPE.ONLINECOIN) then --7:��Ϸ��
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.NETCHEST) then --8:���籦��
				reward[3] = num
			elseif (rewardType == Reward.TYPE.DRAWCARD) then --9:�齱��ս�����ܿ�
				--�ݲ�֧��
			elseif (rewardType == Reward.TYPE.REDEQUIP) then --10:��װ
				--�ݲ�֧��
			elseif (rewardType == Reward.TYPE.CRYSTAL) then --11:��װ��ʯ
				--�ݲ�֧��
			elseif (rewardType == Reward.TYPE.REDSCROLL) then --12:��װ����
				--�ݲ�֧��
			elseif (rewardType == Reward.TYPE.NETDRAWCARD) then --13:�������·��ĳ鿨�࿨��
				--�ݲ�֧��
			elseif (rewardType == Reward.TYPE.HEROEXP) then --14:Ӣ�۾���
				--�ݲ�֧��
			elseif (rewardType == Reward.TYPE.LUCKYREDCHEST) then --15:������������
				reward[3] = num
			elseif (rewardType == Reward.TYPE.IRON) then --16:�� --geyachao: �¼ӷ���������� ����
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.WOOD) then --17:ľ�� --geyachao: �¼ӷ���������� ����
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.FOOD) then --18:��ʳ --geyachao: �¼ӷ���������� ����
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.GROUPCOIN) then --20:���ű� --geyachao: �¼ӷ���������� ����
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TOWERADDONESFREE) then --21:ǿ�����ȯ
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TREASUREDEBRIS) then --22:������Ƭ
				if (reward[3] == 0) then
					reward[3] = num
				else
					reward[3] = reward[3] * num
				end
			elseif (rewardType == Reward.TYPE.CANGBAOTU_NORMAL) then --23:�ر�ͼ
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.CANGBAOTU_HIGH) then --24:�߼��ر�ͼ
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.PVPCOIN) then --25:����
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.CHOUJIANG_FREETICKET) then --26:�齱���ȯ
				--�滻
				reward[3] = num
			elseif (rewardType == Reward.TYPE.ZHANGONG_SCORE) then --27:ս������
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.ACHEVEMENT_POINT) then --28:�ɾ͵�
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.IKUN_SCORE) then --29:�������
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TASK_STONE) then --100:����֮ʯ
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.WEAPONGUN_DEBRIS) then --101:����ǹ��Ƭ
				reward[3] = reward[3] * num
			elseif (rewardType == Reward.TYPE.PET_DEBRIS) then --103:������Ƭ
				reward[3] = reward[3] * num
			elseif (rewardType == Reward.TYPE.SCIENTIST_DEBRIS) then --104:��ѧ����Ƭ
				reward[3] = reward[3] * num
			elseif (rewardType == Reward.TYPE.WEAPONGUN_CHEST) then --105:����ǹ����
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TACTIC_CHEST) then --106:ս��������
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.PET_CHEST) then --107:���ﱦ��
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.EQUIP_CHEST) then --108:װ������
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.SCIENTIST_CHEST) then --109:��ѧ�ұ���
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT1) then --110:��ѧ�ҳɾ�1
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT2) then --111:��ѧ�ҳɾ�2
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT3) then --112:��ѧ�ҳɾ�3
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT4) then --113:��ѧ�ҳɾ�4
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.DISHU_COIN) then --114:�����
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT1) then --115:�����ѳɾ�1
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT2) then --116:�����ѳɾ�2
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT3) then --117:�����ѳɾ�3
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT4) then --118:�����ѳɾ�4
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT5) then --119:�����ѳɾ�5
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.TALENT_POINT) then --120:�츳��
				reward[2] = reward[2] * num
			end
		end
	end

	--����ʵ����Ϣ(Ŀǰֻ��10��װ��ʵ����Ϣ)
	function Reward:SetEntity(idx, entity)
		local reward = self._list[idx]
		if reward then
			local rewardType = reward[1]
			if (rewardType == Reward.TYPE.REDEQUIP) then --10:��װ
				reward[3] = entity
			end
		end
	end

	--��ȡreward��Ϣ
	function Reward:GetInfo()
		return self._list
	end
	--��ȡreward����
	function Reward:GetNum()
		return self._num
	end
	--�Ƿ���ĳ���͵Ľ���
	function Reward:HaveDrop(rType)
		local ret = false

		--����������������
		local tReward = self:GetInfo()
		local rewardLength = self:GetNum()

		for i = 1, rewardLength, 1 do
			local rewardT = tReward[i]
			if rewardT then
				local rewardType = tonumber(rewardT[1] or 0) --��ȡ����
				if (rewardType ==rType) then 
					ret = true
					break
				end
			end
		end
		
		return ret
	end
	
	--ȡ�ñ����еĵ���(�û�id����ɫid����Ҫ��ȡ��id������û�иò���Ĭ��ȫ����ȡ��)
	function Reward:TakeReward(uid, rid, takeList)
		
		
		--����������������
		local tReward = self:GetInfo()
		local rewardLength = self:GetNum()
		
		local heroDic = {}
		local tacticDic = {}
		
		--��Ԥ�����£������費��Ҫ�������ݿ�
		local dbQuery = false
		for i = 1, rewardLength, 1 do
			local rewardT = tReward[i]
			if rewardT then
				local rewardType = tonumber(rewardT[1] or 0) --��ȡ����
				if (rewardType == Reward.TYPE.HERODEBRIS) or (rewardType == Reward.TYPE.TACTICDEBRIS) or (rewardType == Reward.TYPE.HEROCARD) then --5:Ӣ�۽���
					dbQuery = true
					break
				end
			end
		end
		
		--��ȡ����Ҫ����������
		if dbQuery then
			local sql = string.format("SELECT pu.uid,pu.tacticInfo,pu.heroInfo FROM t_pvp_user as pu where pu.id=%d",rid)
			local err,uuid,tacticInfo,heroInfo = xlDb_Query(sql)
			if err == 0 then
				
				--ս�����ܿ���ʼ��
				--tacticDic = self:_InitTacticInfo(tacticInfo)
				tacticDic = hClass.TacticMgr:create():Init(tacticInfo)
				
				--Ӣ�۽����ʼ��
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
		
		--ʵ�ʴ��������
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
				
				--(1:���� / 2:ս�����ܿ� / 3:���� / 4:Ӣ�� / 5:Ӣ�۽��� / 6:ս�����ܿ���Ƭ / 7:��Ϸ�� / 8:���籦�� / 9:�齱��ս�����ܿ� / 10:���� / 11:������ʯ)
				if (rewardType == Reward.TYPE.SCORE) then --1:����
					--�ݲ�֧��
				elseif (rewardType == Reward.TYPE.TACTIC) then --2:ս�����ܿ�
					--�ݲ�֧��
				elseif (rewardType == Reward.TYPE.EQUIPITEM) then --3:����
					--�ݲ�֧��
				elseif (rewardType == Reward.TYPE.HEROCARD) then --4:Ӣ��
					local heroId = tonumber(rInfo[2]) or 0
					local star = tonumber(rInfo[3]) or 1
					local lv = tonumber(rInfo[4]) or 1
					if heroId > 0 then
						self:_AddNewHero(heroDic,heroId,star)
					end
					--�ݲ�֧��
				elseif (rewardType == Reward.TYPE.HERODEBRIS) then --5:Ӣ�۽���
					local itemId = tonumber(rInfo[2]) or 0
					local itemNum = tonumber(rInfo[3]) or 1
					
					if itemId > 0 and hVar.tab_item[itemId] and itemNum > 0 then
						local heroId = hVar.tab_item[itemId].heroID or 0
						if heroId > 0 then
							--���Ӣ�۽���
							self:_AddHeroSoulstone(heroDic, heroId, itemNum)
						end
					end
				elseif (rewardType == Reward.TYPE.TACTICDEBRIS) then --6:ս�����ܿ���Ƭ
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
				elseif (rewardType == Reward.TYPE.ONLINECOIN) then --7:��Ϸ��
					local rmb = tonumber(rInfo[2] or 0)
					hGlobal.userCoinMgr:DBAddGamecoin(uid,rmb)
				elseif (rewardType == Reward.TYPE.NETCHEST) then --8:���籦��
					local itemId = tonumber(rInfo[2]) or 0
					local itemNum = tonumber(rInfo[3]) or 1
					local itemId = tonumber(rInfo[2]) or 0
					local itemNum = tonumber(rInfo[3]) or 1
					if itemId and itemId >= 9004 and itemId <= 9006 and itemNum > 0 then
						--ͭ9004,��9005,��9006
						hGlobal.userCoinMgr:DBAddChest(uid,rid,itemId,itemNum)
					end
				elseif (rewardType == Reward.TYPE.DRAWCARD) then --9:�齱��ս�����ܿ�
					--�ݲ�֧��
				elseif (rewardType == Reward.TYPE.REDEQUIP) then --10:��װ
					local itemId = tonumber(rInfo[2]) or 0
					local slotnum = tonumber(rInfo[3]) or -1
					local quality = tonumber(rInfo[4]) or 0 --Ʒ��
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
				elseif (rewardType == Reward.TYPE.NETDRAWCARD) then --13:�������·��ĳ鿨�࿨��
					--�ݲ�֧��
				elseif (rewardType == Reward.TYPE.HEROEXP) then --14:Ӣ�۾���
					--�ݲ�֧��
				elseif (rewardType == Reward.TYPE.LUCKYREDCHEST) then --15:������������
					--���ɱ����������ҵĽ��
					local itemId = tonumber(rInfo[2]) or 0
					local chest = hClass.Chest:create():Init(itemId,0)	--��װ����
					if chest and (type(chest) == "table") and (chest:getCName() == "Chest") then
						local mustRed = true
						local reward = chest:Open(mustRed)
						
						if reward then
							reward:TakeReward(uid, rid)
						end
					end
				elseif (rewardType == Reward.TYPE.IRON) then --16:�� --geyachao: �¼ӷ���������� ����
					--���ŷ���
					local itemNum = tonumber(rInfo[2]) or 0
					local groupReward = hClass.GroupReward:create("GroupReward"):Init(uid, rid)
					groupReward:TakeReward(rewardType, itemNum)
				elseif (rewardType == Reward.TYPE.WOOD) then --17:ľ�� --geyachao: �¼ӷ���������� ����
					--���ŷ���
					local itemNum = tonumber(rInfo[2]) or 0
					local groupReward = hClass.GroupReward:create("GroupReward"):Init(uid, rid)
					groupReward:TakeReward(rewardType, itemNum)
				elseif (rewardType == Reward.TYPE.FOOD) then --18:��ʳ --geyachao: �¼ӷ���������� ����
					--���ŷ���
					local itemNum = tonumber(rInfo[2]) or 0
					local groupReward = hClass.GroupReward:create("GroupReward"):Init(uid, rid)
					groupReward:TakeReward(rewardType, itemNum)
				elseif (rewardType == Reward.TYPE.GROUPCOIN) then --20:���ű� --geyachao: �¼ӷ���������� ����
					--���ŷ���
					local itemNum = tonumber(rInfo[2]) or 0
					local groupReward = hClass.GroupReward:create("GroupReward"):Init(uid, rid)
					groupReward:TakeReward(rewardType, itemNum)
				elseif (rewardType == Reward.TYPE.TOWERADDONESFREE) then --21:ǿ�����ȯ
					--
				elseif (rewardType == Reward.TYPE.TREASUREDEBRIS) then --22:������Ƭ
					local itemId = tonumber(rInfo[2]) or 0
					local itemNum = tonumber(rInfo[3]) or 1
					local treasureReward = hClass.TreasureReward:create("TreasureReward"):Init(uid, rid)
					treasureReward:TakeReward(rewardType, itemId, itemNum)
				elseif (rewardType == Reward.TYPE.CANGBAOTU_NORMAL) then --23:�ر�ͼ
					local cangbaotu = tonumber(rInfo[2]) or 0
					hGlobal.userCoinMgr:DBAddCangBaoTu(uid,cangbaotu)
				elseif (rewardType == Reward.TYPE.CANGBAOTU_HIGH) then --24:�߼��ر�ͼ
					local cangbaotu_high = tonumber(rInfo[2]) or 0
					hGlobal.userCoinMgr:DBAddCangBaoTuHigh(uid,cangbaotu_high)
				elseif (rewardType == Reward.TYPE.PVPCOIN) then --25:����
					local pvpcoin = tonumber(rInfo[2]) or 0
					hGlobal.userCoinMgr:DBAddPvpCoin(uid,pvpcoin)
				elseif (rewardType == Reward.TYPE.CHOUJIANG_FREETICKET) then --26:�齱���ȯ
					local activityId = tonumber(rInfo[2]) or 0
					local ticketNum = tonumber(rInfo[3]) or 0
					hGlobal.userCoinMgr:DBAddChouJiangFreeTicket(uid, rid, activityId, ticketNum)
				elseif (rewardType == Reward.TYPE.ZHANGONG_SCORE) then --27:ս������
					local zhangong_score = tonumber(rInfo[2]) or 0
					hGlobal.userCoinMgr:DBAddZhanGongScore(uid, rid, zhangong_score)
				elseif (rewardType == Reward.TYPE.ACHEVEMENT_POINT) then --28:�ɾ͵�
					--�ݲ�֧��
				elseif (rewardType == Reward.TYPE.IKUN_SCORE) then --29:�������
					--�ݲ�֧��
				elseif (rewardType == Reward.TYPE.TASK_STONE) then --100:����֮ʯ
					local stone = tonumber(rInfo[2]) or 0
					if (stone > 0) then
						hGlobal.userCoinMgr:DBAddTaskStone(uid, stone)
					end
				elseif (rewardType == Reward.TYPE.WEAPONGUN_DEBRIS) then --101:����ǹ��Ƭ
					local itemId = tonumber(rInfo[2]) or 0
					local debrisNum = tonumber(rInfo[3]) or 0
					local tabI = hVar.tab_item[itemId] or {}
					local weaponId = tabI.weaponId or 0
					local tankWeapon = hClass.TankWeapon:create():Init(uid,rid)
					tankWeapon:AddDebris(weaponId, debrisNum)
				elseif (rewardType == Reward.TYPE.PET_DEBRIS) then --103:������Ƭ
					local itemId = tonumber(rInfo[2]) or 0
					local debrisNum = tonumber(rInfo[3]) or 0
					local tabI = hVar.tab_item[itemId] or {}
					local petId = tabI.petId or 0
					local tankPet = hClass.TankPet:create():Init(uid,rid)
					tankPet:AddDebris(petId, debrisNum)
				elseif (rewardType == Reward.TYPE.WEAPONGUN_CHEST) then --105:����ǹ����
					local debrsNum = tonumber(rInfo[2]) or 0
					if (debrsNum > 0) then
						hGlobal.userCoinMgr:DBAddWeaponChest(uid, debrsNum)
					end
				elseif (rewardType == Reward.TYPE.TACTIC_CHEST) then --106:ս��������
					local debrsNum = tonumber(rInfo[2]) or 0
					if (debrsNum > 0) then
						hGlobal.userCoinMgr:DBAddTacticChest(uid, debrsNum)
					end
				elseif (rewardType == Reward.TYPE.PET_CHEST) then --107:���ﱦ��
					local debrsNum = tonumber(rInfo[2]) or 0
					if (debrsNum > 0) then
						hGlobal.userCoinMgr:DBAddPetChest(uid, debrsNum)
					end
				elseif (rewardType == Reward.TYPE.EQUIP_CHEST) then --108:װ������
					local debrsNum = tonumber(rInfo[2]) or 0
					if (debrsNum > 0) then
						hGlobal.userCoinMgr:DBAddEquipChest(uid, debrsNum)
					end
				elseif (rewardType == Reward.TYPE.SCIENTIST_CHEST) then --109:��ѧ�ұ���
					--
				elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT1) then --110:��ѧ�ҳɾ�1
					--
				elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT2) then --111:��ѧ�ҳɾ�2
					--
				elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT3) then --112:��ѧ�ҳɾ�3
					--
				elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT4) then --113:��ѧ�ҳɾ�4
					--
				elseif (rewardType == Reward.TYPE.DISHU_COIN) then --114:�����
					--���ӵ����
					local coin = tonumber(rInfo[2]) or 0
					hGlobal.userCoinMgr:DBAddDiShuCoin(uid, coin)
				elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT1) then --115:�����ѳɾ�1
					--
				elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT2) then --116:�����ѳɾ�2
					--
				elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT3) then --117:�����ѳɾ�3
					--
				elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT4) then --118:�����ѳɾ�4
					--
				elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT5) then --119:�����ѳɾ�5
					--
				elseif (rewardType == Reward.TYPE.TALENT_POINT) then --120:�츳��
					--����ս���츳����
					local talent = tonumber(rInfo[2]) or 0
					hGlobal.userCoinMgr:DBAddTankTalentPoint(uid, rid, talent)
				end
			end
		end
		
		--�洢�����������
		if dbQuery then
			local saveInfo = ""
			--saveInfo = string.format("tacticInfo='%s',heroInfo='%s'",self:_TacticInfoToCmd(tacticDic),self:_HeroInfoToCmd(heroDic))
			saveInfo = string.format("tacticInfo='%s',heroInfo='%s'",tacticDic:InfoToCmd(),self:_HeroInfoToCmd(heroDic))
			local sql = string.format("UPDATE t_pvp_user SET " .. saveInfo .. " WHERE id=%d",rid)
			local err = xlDb_Execute(sql)
			--print("sql:",sql, err)
		end
	end
	
	--�ϲ���������
	function Reward:Merge(rewardTemp)
		local rewardTemp_list = rewardTemp._list
		local rewardTemp_num = rewardTemp._num
		
		self._num = self._num + rewardTemp_num
		for i = 1, #rewardTemp_list, 1 do
			self._list[#self._list+1] = rewardTemp_list[i]
		end
	end
	
	--׷����ӽ���������ͬ���͵Ľ�����������ԭ����������������һ��������
	function Reward:AppendAdd(reward)
		local ret = false
		if reward and type(reward) == "table" then
			local rType = tonumber(reward[1])
			local id = tonumber(reward[2])
			
			--�������еĽ���������Ƿ������ظ��Ľ���
			for i = 1, self._num, 1 do
				local tReward = self._list[i]
				if tReward then
					local rtype = tReward[1]
					if (rtype == rType) then --�ҵ���
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
		
		--�ߵ�����˵���޷�׷�ӣ�����ͨ�������
		return self:Add(reward)
	end
	
	--��ý����������������
	function Reward:GetAppendIndex(rewardType)
		local appendIdx = 0
		
		--(1:���� / 2:ս�����ܿ� / 3:���� / 4:Ӣ�� / 5:Ӣ�۽��� / 6:ս�����ܿ���Ƭ / 7:��Ϸ�� / 8:���籦�� / 9:�齱��ս�����ܿ� / 10:���� / 11:������ʯ)
		if (rewardType == Reward.TYPE.SCORE) then --1:����
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TACTIC) then --2:ս�����ܿ�
			--�ݲ�֧��
		elseif (rewardType == Reward.TYPE.EQUIPITEM) then --3:����
			--�ݲ�֧��
		elseif (rewardType == Reward.TYPE.HEROCARD) then --4:Ӣ��
			--�ݲ�֧��
		elseif (rewardType == Reward.TYPE.HERODEBRIS) then --5:Ӣ�۽���
			--�ݲ�֧��
		elseif (rewardType == Reward.TYPE.TACTICDEBRIS) then --6:ս�����ܿ���Ƭ
			--�ݲ�֧��
		elseif (rewardType == Reward.TYPE.ONLINECOIN) then --7:��Ϸ��
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.NETCHEST) then --8:���籦��
			--�ݲ�֧��
		elseif (rewardType == Reward.TYPE.DRAWCARD) then --9:�齱��ս�����ܿ�
			--�ݲ�֧��
		elseif (rewardType == Reward.TYPE.REDEQUIP) then --10:��װ
			--�ݲ�֧��
		elseif (rewardType == Reward.TYPE.CRYSTAL) then --11:��װ��ʯ
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.REDSCROLL) then --12:��װ����
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.NETDRAWCARD) then --13:�������·��ĳ鿨�࿨��
			--�ݲ�֧��
		elseif (rewardType == Reward.TYPE.HEROEXP) then --14:Ӣ�۾���
			--�ݲ�֧��
		elseif (rewardType == Reward.TYPE.LUCKYREDCHEST) then --15:������������
			--�ݲ�֧��
		elseif (rewardType == Reward.TYPE.IRON) then --16:�� --geyachao: �¼ӷ���������� ����
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.WOOD) then --17:ľ�� --geyachao: �¼ӷ���������� ����
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.FOOD) then --18:��ʳ --geyachao: �¼ӷ���������� ����
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.GROUPCOIN) then --20:���ű� --geyachao: �¼ӷ���������� ����
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TOWERADDONESFREE) then --21:ǿ�����ȯ
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TREASUREDEBRIS) then --22:������Ƭ
			--�ݲ�֧��
		elseif (rewardType == Reward.TYPE.CANGBAOTU_NORMAL) then --23:�ر�ͼ
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.CANGBAOTU_HIGH) then --24:�߼��ر�ͼ
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.PVPCOIN) then --25:����
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.CHOUJIANG_FREETICKET) then --26:�齱���ȯ
			--�ݲ�֧��
		elseif (rewardType == Reward.TYPE.ZHANGONG_SCORE) then --27:ս������
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.ACHEVEMENT_POINT) then --28:�ɾ͵�
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.IKUN_SCORE) then --29:�������
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TASK_STONE) then --100:����֮ʯ
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.WEAPONGUN_DEBRIS) then --101:����ǹ��Ƭ
			--�ݲ�֧��
		elseif (rewardType == Reward.TYPE.PET_DEBRIS) then --103:������Ƭ
			--�ݲ�֧��
		elseif (rewardType == Reward.TYPE.SCIENTIST_DEBRIS) then --104:��ѧ����Ƭ
			--�ݲ�֧��
		elseif (rewardType == Reward.TYPE.WEAPONGUN_CHEST) then --105:����ǹ����
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TACTIC_CHEST) then --106:ս��������
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.PET_CHEST) then --107:���ﱦ��
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.EQUIP_CHEST) then --108:װ������
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.SCIENTIST_CHEST) then --109:��ѧ�ұ���
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT1) then --110:��ѧ�ҳɾ�1
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT2) then --111:��ѧ�ҳɾ�2
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT3) then --112:��ѧ�ҳɾ�3
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.SCIENTIST_ACHEVEMENT4) then --113:��ѧ�ҳɾ�4
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.DISHU_COIN) then --114:�����
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT1) then --115:�����ѳɾ�1
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT2) then --116:�����ѳɾ�2
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT3) then --117:�����ѳɾ�3
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT4) then --118:�����ѳɾ�4
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TANKDEEADTH_ACHEVEMENT5) then --119:�����ѳɾ�5
			appendIdx = 2
		elseif (rewardType == Reward.TYPE.TALENT_POINT) then --120:�츳��
			appendIdx = 2
		end
		
		return appendIdx
	end
	
	--��ȡ�����ȡʱ��
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
	
	--��ȡ�����ȡʱ��
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