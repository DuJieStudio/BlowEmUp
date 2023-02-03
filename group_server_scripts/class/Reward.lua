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
		GROUPCOIN = 20,	--geyachao: �¼ӷ���������� ���� ���ű�
		TOWERADDONESFREE = 21,	 --21:ǿ�����ȯ
		TREASUREDEBRIS = 22,	 --22:������Ƭ
		CANGBAOTU_NORMAL = 23,	 --23:�ر�ͼ
		CANGBAOTU_HIGH = 24,	 --24:�߼��ر�ͼ
		PVPCOIN = 25,		--25:����
		CHOUJIANG_FREETICKET = 26,	--26:�齱���ȯ
		ZHANGONG_SCORE = 27,		--27:ս������
		ACHEVEMENT_POINT = 28,		--28:�ɾ͵�
		
		REWARD_MAXNUM = 28,	--���影���������ֵ
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
	
	--����ս������Ƭ
	function Reward:_RemoveTactic(tacticDic,id,num)
		local ret = false
		if id > 0 then
			local tactic = tacticDic[id]
			if tactic then
				tactic:AddDebris(num)
				ret = true
			else
				--tacticDic[id] = hClass.Tactic:create():Init(id, 0, num, num)
				--ret = true
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
				if tabH and tabH.initStarLv then --Ӣ�۵ĳ�ʼ�Ǽ���С�ǳ�ʼ����2�ǣ�
					star = tabH.initStarLv
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
			local param3 = tonumber(reward[3]) or 0
			--print("rType=", rType)
			--print("id=", id)
			if rType and id and rType >= Reward.TYPE.SCORE and rType <= Reward.TYPE.REWARD_MAXNUM then
				--����һ����������0
				if (id > 0) or (param3 > 0) then
					self._list[#self._list + 1] = {}
					for i = 1, Reward.MAXDATA do
						self._list[#self._list][i] = tonumber(reward[i]) or 0
						if i == 3 and rType == Reward.TYPE.REDEQUIP then
							if reward[i] and (not tonumber(reward[i])) then
								self._list[#self._list][i] = reward[i]
							end
						end
						
						--�������鿨���͵Ľ������Ե�4����������������������ʾ�ã�
						if i == 4 and rType == Reward.TYPE.NETDRAWCARD then
							if reward[i] and (not tonumber(reward[i])) then
								self._list[#self._list][i] = reward[i]
							end
						end
					end
					self._num = self._num + 1
					--print("self._num=", self._num)
					
					ret = true
				end
			end
		end
		return ret, #self._list
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
		end
		
		return appendIdx
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
				reward[3] = reward[3] * num
			elseif (rewardType == Reward.TYPE.EQUIPITEM) then --3:����
				--�ݲ�֧��
			elseif (rewardType == Reward.TYPE.HEROCARD) then --4:Ӣ��
				--�ݲ�֧��
			elseif (rewardType == Reward.TYPE.HERODEBRIS) then --5:Ӣ�۽���
				if (reward[3] == 0) then
					reward[3] = num
				else
					reward[3] = reward[3] * num
				end
			elseif (rewardType == Reward.TYPE.TACTICDEBRIS) then --6:ս�����ܿ���Ƭ
				if (reward[3] == 0) then
					reward[3] = num
				else
					reward[3] = reward[3] * num
				end
			elseif (rewardType == Reward.TYPE.ONLINECOIN) then --7:��Ϸ��
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.NETCHEST) then --8:���籦��
				reward[3] = reward[3] * num
			elseif (rewardType == Reward.TYPE.DRAWCARD) then --9:�齱��ս�����ܿ�
				--�ݲ�֧��
			elseif (rewardType == Reward.TYPE.REDEQUIP) then --10:��װ
				--�ݲ�֧��
			elseif (rewardType == Reward.TYPE.CRYSTAL) then --11:��װ��ʯ
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.REDSCROLL) then --12:��װ����
				reward[2] = reward[2] * num
			elseif (rewardType == Reward.TYPE.NETDRAWCARD) then --13:�������·��ĳ鿨�࿨��
				--�ݲ�֧��
			elseif (rewardType == Reward.TYPE.HEROEXP) then --14:Ӣ�۾���
				--�滻
				reward[3] = num
			elseif (rewardType == Reward.TYPE.LUCKYREDCHEST) then --15:������������
				--�滻
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
	function Reward:TakeReward(uid, rid, takeList, strInfo)
		
		
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
				tacticDic = self:_InitTacticInfo(tacticInfo)
				
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
					
					--if itemId > 0 and hVar.tab_item[itemId] and itemNum > 0 then
					if itemId > 0 and hVar.tab_item[itemId] then --���ž��׻�۳�ս������Ƭ
						local tacticId = hVar.tab_item[itemId].tacticID or 0
						if tacticId > 0 then
							if (itemNum >= 0) then
								self:_AddTactic(tacticDic, tacticId, itemNum)
							else
								self:_RemoveTactic(tacticDic, tacticId, itemNum)
							end
							--print("self:_AddTactic:",tacticId, itemNum)
						end
					end
				elseif (rewardType == Reward.TYPE.ONLINECOIN) then --7:��Ϸ��
					local rmb = tonumber(rInfo[2] or 0)
					hGlobal.userCoinMgr:DBAddGamecoin(uid,rmb, strInfo)
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
					local redequipMgr = hClass.RedEquipMgr:create():Init(uid, rid)
					if redequipMgr then
						local equip = redequipMgr:DBAddEquip(itemId,slotnum)
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
					hGlobal.userCoinMgr:DBAddPvpCoin(uid,pvpcoin, strInfo)
				elseif (rewardType == Reward.TYPE.CHOUJIANG_FREETICKET) then --26:�齱���ȯ
					local activityId = tonumber(rInfo[2]) or 0
					local ticketNum = tonumber(rInfo[3]) or 0
					hGlobal.userCoinMgr:DBAddChouJiangFreeTicket(uid, rid, activityId, ticketNum)
				elseif (rewardType == Reward.TYPE.ZHANGONG_SCORE) then --27:ս������
					local zhangong_score = tonumber(rInfo[2]) or 0
					hGlobal.userCoinMgr:DBAddZhanGongScore(uid, rid, zhangong_score)
				elseif (rewardType == Reward.TYPE.ACHEVEMENT_POINT) then --28:�ɾ͵�
					--�ݲ�֧��
				end
			end
		end
		
		--�洢�����������
		if dbQuery then
			local saveInfo = ""
			saveInfo = string.format("tacticInfo='%s',heroInfo='%s'",self:_TacticInfoToCmd(tacticDic),self:_HeroInfoToCmd(heroDic))
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
	
	--���丽�ӹ������
	function Reward:AddGroupDonation(uid, strItemName, sessionId, cfgId, gameDiff, sMykey)
		--local tReward = self:GetInfo()
		--local rewardLength = self:GetNum()
		local rewardTemp = hClass.Reward:create():Init()
		local tMykey = hApi.Split(sMykey, ";")
		for i = 1, #tMykey, 1 do
			local tmp = hApi.Split(tMykey[i],":")
			rewardTemp:Add(tmp)
		end
		
		local tReward = rewardTemp:GetInfo()
		local rewardLength = rewardTemp:GetNum()
		
		local iron_donate_sum = 0 --���ܾ���ֵ
		local wood_donate_sum = 0 --ľ���ܾ���ֵ
		local food_donate_sum = 0 --��ʳ�ܾ���ֵ
		local group_coin = 0 --���ӵľ��ű�
		
		for i = 1, rewardLength, 1 do
			local rewardT = tReward[i]
			if rewardT then
				local rewardType = tonumber(rewardT[1] or 0) --��ȡ����
				local rewardNum = tonumber(rewardT[2] or 0) --��ȡ����
				
				if (rewardType == Reward.TYPE.IRON) then --16:�� --geyachao: �¼ӷ���������� ����
					iron_donate_sum = iron_donate_sum + rewardNum
				elseif (rewardType == Reward.TYPE.WOOD) then --17:ľ�� --geyachao: �¼ӷ���������� ����
					wood_donate_sum = wood_donate_sum + rewardNum
				elseif (rewardType == Reward.TYPE.FOOD) then --18:��ʳ --geyachao: �¼ӷ���������� ����
					food_donate_sum = food_donate_sum + rewardNum
				elseif (rewardType == Reward.TYPE.GROUPCOIN) then --20:���ű� --geyachao: �¼ӷ���������� ����
					group_coin = group_coin + rewardNum
				end
			end
		end
		
		--������־
		--��ѯ������ڵľ���id
		local groupId = 0
		local sQuery = string.format("SELECT `ncid` from `novicecamp_member` where `uid` = %d and `level` > 0", uid)
		local err, ncid = xlDb_Query(sQuery)
		--print(sQuery, err, ncid)
		
		if (err == 0) then
			groupId = ncid
		end
		
		--��ѯ��ҵ�������
		local channelId = 0
		local sQuery = string.format("SELECT `channel_id` FROM `t_user` WHERE `uid`= %d", uid)
		local err, channel_id = xlDb_Query(sQuery)
		--print("sQuery:",sQuery,err)
		if (err == 0) then
			channelId = channel_id
		end
		
		--���빱����־
		if (groupId > 0) then
			local sInsert = string.format("INSERT INTO `novicecamp_member_donate_log`(`uid`, `ncid`, `itemname`, `channelId`, `sessionId`, `cfgId`, `game_diff`, `mat_iron_donate`, `mat_wood_donate`, `mat_food_donate`, `group_coin`, `time`) VALUES (%d, %d, '%s', %d, %d, %d, %d, %d, %d, %d, %d, NOW())", uid, groupId, strItemName, channelId, sessionId, cfgId, gameDiff, iron_donate_sum, wood_donate_sum, food_donate_sum, group_coin)
			xlDb_Execute(sInsert)
			--print(sInsert)
		end
		
		--��¼��ұ��ܾ��ž����ܺͣ����Ÿ���ʿ�����������ʼ�������
		if (groupId > 0) then
			--��������
			local shengwang = iron_donate_sum * 2 + wood_donate_sum + food_donate_sum
			
			--���¸��˱�
			if (shengwang > 0) then
				local sUpdate = string.format("update `novicecamp_member` set `shengwang_week` = `shengwang_week` + %d where `uid` = %d", shengwang, uid)
				xlDb_Execute(sUpdate)
			end
			
			--���¾��ű�
			if (shengwang > 0) then
				local sUpdate = string.format("update `novicecamp_list` set `shengwang_week_sum` = `shengwang_week_sum` + %d where `id` = %d", shengwang, groupId)
				xlDb_Execute(sUpdate)
			end
		end
		
		--������Դ
		if (groupId > 0) then
			local sUpdate = string.format("update `novicecamp_member` set `mat_iron_donate_sum` = `mat_iron_donate_sum` + %d, `mat_wood_donate_sum` = `mat_wood_donate_sum` + %d, `mat_food_donate_sum` = `mat_food_donate_sum` + %d where `uid` = %d", iron_donate_sum, wood_donate_sum, food_donate_sum, uid)
			xlDb_Execute(sUpdate)
			--print(sUpdate)
		end
	end
    
return Reward