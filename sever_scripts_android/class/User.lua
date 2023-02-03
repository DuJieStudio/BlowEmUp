--�û���
local User = class("User")
	
	--��ɫ״̬
	User.STATEINFO = 
	{
		UNINIT = -1,			--δ��ʼ��
		INIT = 1,			--��ʼ��
		INHALL = 2,			--�ڴ���
		INROOM = 3,			--�ڷ���
		INGAME = 4,			--����Ϸ
		INMATCH = 5,			--����ƥ����
	}

	User.DELAY_ARRAY_LEN = 60		--��¼�����ʱ�����������
	
	User.EVALUATE_MAX = 200			--���������ֵ�����
	User.PVPCOIN_EVERYDAY_MAX = 100		--���ÿ����ȡ����������
	User.CHEST_AMOUNT = 6			--��ұ�������
	User.CHEST_REWARD_COST = 20		--��ñ�����Ҫ���������ǣ�Ŀǰ��������������ã�
	User.FREE_CHEST_REWARD_INTERVAL = 8	--��ѱ����ȡ���(��λСʱ)
	User.ARENA_CHEST_MAXNUM = 10		--��̨�������������

	User.INVENTORY_SLOT_PAGE = 24		--ÿҳ���ٵ��߸�
	
	--�û���ʼ��
	function User:SetInit()
		self._state = User.STATEINFO.INIT
	end
	--�û��ڴ���
	function User:SetInHall()
		self._state = User.STATEINFO.INHALL
		self._roomId = -1
		self._sessionId = -1
		self._matchId = -1
	end
	--�û��ڷ���
	function User:SetInRoom(roomId)
		self._roomId = roomId
		self._state = User.STATEINFO.INROOM
		self._sessionId = -1
		self._matchId = -1
	end
	--�û�����Ϸ
	function User:SetInGame(sessionId)
		self._state = User.STATEINFO.INGAME
		self._sessionId = sessionId
		self._matchId = -1
	end
	--�û�����ƥ��
	function User:SetInMatch(matchId)
		self._state = User.STATEINFO.INMATCH
		self._roomId = -1
		self._sessionId = -1
		self._matchId = matchId
	end
	--�û��Ƿ��ʼ��
	function User:IsInit()
		local ret = false
		if self._state > User.STATEINFO.UNINIT then
			ret = true
		end
		return ret
	end
	--�û��Ƿ��ڴ���
	function User:IsInHall()
		local ret = false
		if self._state == User.STATEINFO.INHALL then
			ret = true
		end
		return ret
	end
	--�û��Ƿ��ڷ���
	function User:IsInRoom()
		local ret = false
		if self._state == User.STATEINFO.INROOM then
			ret = true
		end
		return ret
	end
	--�û��Ƿ�����Ϸ
	function User:IsInGame()
		local ret = false
		if self._state == User.STATEINFO.INGAME then
			ret = true
		end
		return ret
	end
	--�û��Ƿ�����ƥ��
	function User:IsInMatch()
		local ret = false
		if self._state == User.STATEINFO.INMATCH then
			ret = true
		end
		return ret
	end
	
	-------------------------------------------------------------------------------------------------
	--���캯��
	function User:ctor()
		--��ʼ��˽�б���
		self._id = -1				--�ڴ�id
		self._dbId = -1				--���ݿ�id
		self._rId = -1				--��ǰʹ�õĽ�ɫId
		self._name = nil			--�û�����
		self._gamecoin = -1			--�û���Ϸ��
		self._gamescore = -1			--�û�����
		self._pvpcoin = -1			--�û�����
		self._pvpcoin_last_gettime = -1		--����ÿ����ȡ��һ����ȡʱ��
		self._evaluateE = -1			--����ģʽ�ۼ���������
		self._evaluateELog = -1			--��ʷ�ϻ�õ���������
		self._state = User.STATEINFO.UNINIT	--״̬��ǰ״̬ -1δ��ʼ��
		self._roomId = -1			--���뷿��id
		self._sessionId = -1			--������Ϸ��id
		self._matchId = -1			--����ƥ�䷿��id
		self._lastHeart = -1			--��һ��������ʱ��
		self._delay = -1			--��ʱ
		self._recentlyDelay = -1		--�������ʱ
		self._delayIndex = -1			--�������ʱ��ƫ��
		self._bTester = false
		self._bGM = false

		self._coppercount = -1			--������ͭ��������
		self._silvercount = -1			--����������������
		self._goldcount = -1			--�����Ľ�������
		self._chestexp = -1			--�����ı�����ܾ���
		self._arenachest = 0			--��̨�����ҵĵ�ǰ����
		self._arenachestOpen = 0		--��̨�����ҵ���ʷ��������
		self._freechest = -1			--�������
		self._chestList = -1			--�����б�
		
		self._itemMgr = -1			--���߹���
		self._heroMgr = -1			--Ӣ�۽������
		self._tacticMgr = -1			--ս�����ܿ�����
		self._inventoryMgr = -1			--��������
		self._levelMgr = -1			--�ؿ�����

		--����
		return self
	end
	--��ʼ������
	function User:Init(id, dbId, rId)
		self._id = id
		self._dbId = dbId
		self._rId = rId
		--self._name = hVar.tab_string["__TEXT_PLAYER"].. tostring(dbId)
		--���ݿ��ȡ�û�����
		if self:_DBGetUserInfo() then
			self._lastHeart = hApi.GetClock()
			self._delay = 0
			self._recentlyDelay = {}		--�������ʱ
			self._delayIndex = 0			--�������ʱ��ƫ��
			
			--��������ṹ��������Ҫ�����װ����
			hGlobal.redEquipUserCacheMgr:ClearRedEquipMgr(dbId, rId)
			
			self:SetInit()
		end
		return self
	end
	--release
	function User:Release()
		self._id = -1				--�ڴ�id
		self._dbId = -1				--���ݿ�id
		self._rId = -1				--��ǰʹ�õĽ�ɫId
		self._name = nil			--�û�����
		self._gamecoin = -1			--�û���Ϸ��
		self._gamescore = -1			--�û�����
		self._pvpcoin = -1			--�û�����
		self._pvpcoin_last_gettime = -1		--����ÿ����ȡ��һ����ȡʱ��
		self._sBattlecfg = nil			--�û��������ս������
		self._sBattlecfg1 = nil			--�û�ͭȸ̨ս������
		self._evaluateE = -1			--����ģʽ�ۼ���������
		self._evaluateELog = -1			--��ʷ�ϻ�õ���������
		self._state = User.STATEINFO.UNINIT	--״̬��ǰ״̬ -1δ��ʼ��
		self._roomId = -1			--���뷿��id
		self._sessionId = -1			--������Ϸ��id
		self._matchId = -1			--����ƥ�䷿��id
		self._lastHeart = -1			--��һ��������ʱ��
		self._delay = -1			--��ʱ
		self._recentlyDelay = -1		--�������ʱ
		self._delayIndex = -1			--�������ʱ��ƫ��
		self._bTester = false
		self._bGM = false
		self._coppercount = -1			--������ͭ��������
		self._silvercount = -1			--����������������
		self._goldcount = -1			--�����Ľ�������
		self._chestexp = -1			--�����ı�����ܾ���
		self._arenachest = 0			--��̨�����ҵĵ�ǰ����
		self._arenachestOpen = 0		--��̨�����ҵ���ʷ��������
		self._freechest = -1			--�������
		self._chestList = -1			--�����б�

		--Ӣ�۽�����ϢRelease
		if self._tacticMgr and type(self._tacticMgr) == "table" and self._tacticMgr:getCName() == "TacticMgr" then
			self._tacticMgr:Release()
		end
		self._tacticMgr = -1			--ս�����ܿ�����
		
		--Ӣ�۽�����ϢRelease
		if self._heroMgr and type(self._heroMgr) == "table" and self._heroMgr:getCName() == "HeroMgr" then
			self._heroMgr:Release()
		end
		self._heroMgr = -1
		
		--���߹���Release
		if self._itemMgr and type(self._itemMgr) == "table" and self._itemMgr:getCName() == "RedEquipMgr" then
			self._itemMgr:Release()
		end
		self._itemMgr = -1
		
		self._inventoryMgr = -1			--��������
		self._levelMgr = -1			--�ؿ�����
		--todo

		return self
	end
	--��ȡ�Ƿ��ǲ���Ա
	function User:IsTesters()
		return self._bTester
	end
	--��ȡ�Ƿ��ǹ���Ա
	function User:IsGM()
		return self._bGM
	end
	
	--��ȡ�Ƿ��ǹ���Ա�ڲ��˺�
	function User:IsGMInternal(dbId)
		local nIsGMInternal = 0
		
		local sql = string.format("SELECT `id` FROM `t_uid_internal` where `uid` = %d", dbId)
		local err, id = xlDb_Query(sql)
		if err == 0 then
			nIsGMInternal = 1
		end
		
		return nIsGMInternal
	end
	
	--��ȡ��ǰ״̬
	function User:GetState()
		return self._state
	end
	--���õ�ǰ״̬
	--function User:SetState(state)
	--	if state >= User.STATEINFO.UNINIT and state <= User.STATEINFO.INIT then
	--		self._state = state
	--	end
	--	return self
	--end
	--��ȡ�û�DBID
	function User:GetDBID()
		return self._dbId
	end
	--��ȡ�û�ID
	function User:GetID()
		return self._id
	end
	--��ȡ�û�ʹ�ý�ɫID
	function User:GetRID()
		return self._rId
	end
	--��ȡ�û���ǰ���ڷ���ID
	function User:GetInRoomID()
		return self._roomId
	end
	--��ȡ�û���ǰ������Ϸ��ID
	function User:GetInGameID()
		return self._sessionId
	end
	--��ȡ�û���ǰ����ƥ�䷿��
	function User:GetInMatchID()
		return self._matchId
	end

	--��ȡ�û�Name
	function User:GetName()
		return self._name
	end

	--��ȡ�û�����ģʽ�ۼ���������
	function User:GetEvaluateE()
		return self._evaluateE
	end
	--��ȡ�û���ʷ�ϻ�õ���������
	function User:GetEvaluateELog()
		return self._evaluateELog
	end

	--������ͭ��������
	function User:GetCopperCount()
		return self._coppercount
	end
	--����������������
	function User:GetSilverCount()
		return self._silvercount
	end
	--�����Ľ�������
	function User:GetGoldCount()
		return self._goldcount
	end
	--�����ı�����ܾ���
	function User:GetChestexp()
		return self._chestexp
	end
	--��ȡ��̨������
	function User:GetArenaChest()
		return self._arenachest
	end
	--������̨������
	function User:AddArenaChest(num)
		self._arenachest = math.max(math.min(self._arenachest + num,10),0)	--��̨�����ҵĵ�ǰ����
	end

	--�����û�ս��������Ϣ
	function User:SetBattleConfig(strCfg,cfgId)
		
	end
	--����û�ս��������Ϣ
	function User:GetBattleConfig(cfgId)
		
		
	end
	--������ʱ
	function User:SetDelay(delay)
		local timeNow = hApi.GetClock()
		self._delay = delay or 0
		self._lastHeart = timeNow
		
		--��¼���һ��ʱ�����ʱ
		self._recentlyDelay[self._delayIndex] = delay
		self._delayIndex = self._delayIndex + 1
		if self._delayIndex > User.DELAY_ARRAY_LEN then
			self._delayIndex = 0
		end
	end
	--�����ʱ
	function User:GetDelay()
		return self._delay
	end
	--��������ƽ����ʱ
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
	--�����һ����Ӧ�¼�
	function User:GetLastHeart()
		return self._lastHeart
	end
	
	--������������
	function User:AddEvaluatePoint(evaluatePoint)
		if evaluatePoint >= 0 then
			self._evaluateELog = self._evaluateELog + evaluatePoint
			--����������ֵ����ԭ״
			if self._evaluateE < User.EVALUATE_MAX then
				self._evaluateE = math.min(self._evaluateE + evaluatePoint,User.EVALUATE_MAX)
			end
		else
			self._evaluateE = self._evaluateE + evaluatePoint
		end
	end
	
	--����ƥ����̨���볡ȯ
	function User:BuyArenaEntrance(itemId, cost, ext)
		return self:_DBUserPurchase(itemId,1,cost,0,ext)
	end

	--����ƥ����̨���볡ȯ
	function User:ReturnArenaEntrance(itemId, cost, ext)
		--��Ϊ�ǿ�Ǯ�����Դ���������costҪ�ĳ�-cost
		return self:_DBUserPurchase(itemId,1,-cost,0,ext)
	end
	
	
	--------------------------------------------------------�������--------------------------------------------------------
	--��ȡ����
	function User:RewardChest(chestPos)
		local ret = false
		local chestId = hClass.Chest.TYPE.COPPER
		local chestGettime = hApi.GetTime()
		local dbid = self:GetDBID()
		local rid = self:GetRID()

		--��ѱ���
		if chestPos == 0 then
			local chest = self._freechest
			
			if chest and type(chest) == "table" and chest:getCName() == "Chest" then
				--User.FREE_CHEST_REWARD_INTERVAL*60
				--�����һ�λ�ñ���ʱ���Ѿ�������1�죬�����Ѿ���ȡ���������free״̬�����·�
				if (chestGettime >= chest:GetGettime() + User.FREE_CHEST_REWARD_INTERVAL*60*60 and chest:GetID() == hClass.Chest.TYPE.FREE) then
					self._freechest = hClass.Chest:create():Init(chestId,chestGettime)
					ret = true
				end
			else
				--�����������ѱ��������·�
				self._freechest = hClass.Chest:create():Init(chestId,chestGettime)
				ret = true
			end
		elseif chestPos > 0 and chestPos < User.CHEST_AMOUNT then
			local chest = self._chestList[chestPos]
			--������Ӳ�����
			if not chest or chest == 0 then

				local evaluateE = self:GetEvaluateE()
				if evaluateE >= User.CHEST_REWARD_COST then

					--Ԥ�����ӣ�δ����ɹ���Ҫ����
					local r = math.random(1, 10000)
					if r >= 1 and r < 8000 then
						chestId = hClass.Chest.TYPE.SILVER
					elseif r >= 8000 and r <= 10000 then
						chestId = hClass.Chest.TYPE.GOLD
					end
					self._chestList[chestPos] = hClass.Chest:create():Init(chestId,chestGettime)	--�����б�
					--����������
					self:AddEvaluatePoint(-User.CHEST_REWARD_COST)

					ret = self:SaveData(false, true, true, false, false)
					if not ret then
						--δ����ɹ���Ҫ����
						self:AddEvaluatePoint(User.CHEST_REWARD_COST)
						self._chestList[chestPos] = nil
						self._chestList[chestPos] = 0
					end
				end
			end
		end

		return ret
	end
	
	--������
	function User:OpenChest(chestPos)
		local ret

		if chestPos == -1 then
			ret = self:_OpenArenaChest()
		else
			ret = self:_OpenNormalChest(chestPos)
		end
		return ret
	end

	--����ͨ��ʱ�����
	function User:_OpenNormalChest(chestPos)
		local ret
		local chest
		local dbid = self:GetDBID()

		--��ѱ���
		if chestPos == 0 then
			chest = self._freechest
		elseif chestPos > 0 and chestPos < User.CHEST_AMOUNT then
			chest = self._chestList[chestPos]
		end
		
		if chest and type(chest) == "table" and chest:getCName() == "Chest" then
			local chestid = chest:GetID()
			local reward = chest:Open()
			--������������˵��ߣ��򶪸�user����
			if reward then
				local ext = reward:ToCmd()
				local gamecoinCost = chest:GetOpenCost()
				
				--����Ƿ�vip��ѿ�����
				if hGlobal.vipMgr:CheckOpenChestFree(dbid) then
					gamecoinCost = 0
					ext = ext.. ";vip"
				end

				--ʣ�࿪��ʱ�� * ÿ�����ĵ���Ϸ��
				--���뱦�乺���¼
				if self:_DBUserPurchase(chestid,1,gamecoinCost,0,ext) then

					--����������������
					self:_TakeReward(reward)
					
					--�������ѱ��䣬�����ñ���Ϊfree
					if chestPos == 0 then
						self._freechest:SetTypeFree()
						self._coppercount = self._coppercount + 1				--������ͭ��������
						self._chestexp = self._chestexp + hClass.Chest.EXP.COPPER		--������õ��ľ���
						ret = chestid.. ";" .. reward:ToCmd()
					elseif chestPos > 0 and chestPos < User.CHEST_AMOUNT then
						--��ͨ����ֱ��free��
						self._chestList[chestPos] = nil
						self._chestList[chestPos] = 0
						
						if chestid == hClass.Chest.TYPE.SILVER then
							self._silvercount = self._silvercount + 1			--����������������
							self._chestexp = self._chestexp + hClass.Chest.EXP.SILVER	--������õ��ľ���
						elseif chestid == hClass.Chest.TYPE.GOLD then
							self._goldcount = self._goldcount + 1				--�����Ľ�������
							self._chestexp = self._chestexp + hClass.Chest.EXP.GOLD		--������õ��ľ���
						end

						ret = chestid.. ";" .. reward:ToCmd()
					end
				
					----����浵ʧ���п��ܻᵼ�¿ͻ��˵����ݲ�һ��
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
	
	--����̨����
	function User:_OpenArenaChest()
		local ret

		local arenaChestCount = self:GetArenaChest()

		if arenaChestCount > 0 then
			local arenaChestId = hClass.Chest.TYPE.ARENA
			local chest = hClass.Chest:create():Init(arenaChestId,0)	--�����б�
			
			if chest and type(chest) == "table" and chest:getCName() == "Chest" then
				local chestid = chest:GetID()
				local reward = chest:Open()
				--������������˵��ߣ��򶪸�user����
				if reward then
					local gamecoinCost = chest:GetOpenCost()
					--ʣ�࿪��ʱ�� * ÿ�����ĵ���Ϸ��
					--���뱦�乺���¼
					if self:_DBUserPurchase(chestid,1,gamecoinCost,0,reward:ToCmd()) then

						--����������������
						self:_TakeReward(reward)
						
						self._arenachestOpen = self._arenachestOpen + 1			--��̨�����ҵ���ʷ��������
						self._chestexp = self._chestexp + hClass.Chest.EXP.ARENA	--������õ��ľ���
						ret = chestid.. ";" .. reward:ToCmd()

						self:AddArenaChest(-1)
					
						----����浵ʧ���п��ܻᵼ�¿ͻ��˵����ݲ�һ��
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
	
	--ȡ�ñ����еĵ���
	function User:_TakeReward(reward,takeList)

		local udbid = self:GetDBID()
		local rid = self:GetRID()

		--����������������
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
				
				--(1:���� / 2:ս�����ܿ� / 3:���� / 4:Ӣ�� / 5:Ӣ�۽��� / 6:ս�����ܿ���Ƭ / 7:��Ϸ�� / 8:���籦�� / 9:�齱��ս�����ܿ� / 10:���� / 11:������ʯ)
				if (rewardType == hClass.Reward.TYPE.SCORE) then --1:����
					
					local rewardID = tonumber(rewardT[2]) or 0
					local addScore = rewardID --�����Ļ���
					
					--��д������ȡ������������Ľ����Ļ���
					if hVar.tab_item[rewardID] and (hVar.tab_item[rewardID].type == hVar.ITEM_TYPE.RESOURCES) then
						local resT = hVar.tab_item[rewardID].resource
						if resT and (type(resT) == "table") and (resT[1] == "score") then
							addScore = resT[2] or 0
						else
							addScore = 0
						end
					end
					
					--��û��ֽ���
					if (addScore > 0) then
						self._gamescore = self._gamescore + addScore
					end

				elseif (rewardType == hClass.Reward.TYPE.TACTIC) then --2:ս�����ܿ�
					--�ݲ�֧��
				elseif (rewardType == hClass.Reward.TYPE.EQUIPITEM) then --3:����
					--�ݲ�֧��
				elseif (rewardType == hClass.Reward.TYPE.HEROCARD) then --4:Ӣ��
					local heroId = tonumber(rewardT[2]) or 0
					local star = tonumber(rewardT[3]) or 1
					local lv = tonumber(rewardT[4]) or 1

					local hero = self._heroMgr:AddNewHero(heroId)
					if hero then
						hero:SetStar(star)
						hero:SetLv(lv)
					end

				elseif (rewardType == hClass.Reward.TYPE.HERODEBRIS) then --5:Ӣ�۽���
					local itemId = tonumber(rInfo[2]) or 0
					local itemNum = tonumber(rInfo[3]) or 1
					if itemId > 0 and hVar.tab_item[itemId] and itemNum > 0 then
						local heroId = hVar.tab_item[itemId].heroID or 0
						if heroId > 0 then
							--���Ӣ�۽���
							self._heroMgr:AddHeroSoulstone(heroId,itemNum)
						end
					end
				elseif (rewardType == hClass.Reward.TYPE.TACTICDEBRIS) then --6:ս�����ܿ���Ƭ
					local itemId = tonumber(rInfo[2]) or 0
					local itemNum = tonumber(rInfo[3]) or 1
					if itemId > 0 and hVar.tab_item[itemId] and itemNum > 0 then
						local tacticId = hVar.tab_item[itemId].tacticID or 0
						if tacticId > 0 then
							self:AddTactic(tacticId,itemNum)
						end
					end
				elseif (rewardType == hClass.Reward.TYPE.ONLINECOIN) then --7:��Ϸ��
					local rmb = tonumber(rInfo[2] or 0)
					--�ڴ�
					self._gamecoin = self._gamecoin + rmb
					hGlobal.userCoinMgr:DBAddGamecoin(udbid,rmb)
				elseif (rewardType == hClass.Reward.TYPE.NETCHEST) then --8:���籦��
					local itemId = tonumber(rInfo[2] or 0)
					local itemNum = tonumber(rInfo[3] or 1)
					if itemId and itemId >= 9004 and itemId <= 9006 and itemNum > 0 then
						--ͭ9004,��9005,��9006
						self:_DBAddVii(itemId,itemNum)
					end
				elseif (rewardType == hClass.Reward.TYPE.DRAWCARD) then --9:�齱��ս�����ܿ�
					--�ݲ�֧��
				elseif (rewardType == hClass.Reward.TYPE.REDEQUIP) then --10:��װ
					local itemId = tonumber(rInfo[2]) or 0
					local slotnum = tonumber(rInfo[3]) or -1
					local quality = tonumber(rInfo[4]) or 0 --Ʒ��
					--local redequipMgr = hClass.RedEquipMgr:create():Init(udbid, rid)
					local redequipMgr = hGlobal.redEquipUserCacheMgr:GetRedEquipMgr(udbid, rid)
					if redequipMgr then
						local equip = redequipMgr:DBAddEquip(itemId,slotnum,quality)
						reward:SetEntity(i, equip)
					end
				elseif (rewardType == hClass.Reward.TYPE.CRYSTAL) then --11:��װ��ʯ
					local crystal = tonumber(rInfo[2] or 0)
					hGlobal.userCoinMgr:DBAddCrystal(udbid,crystal)
				end
			end
		end
	end
	
	--��ʼ��������Ϣ
	function User:_InitChestInfo(chestInfo)

		local tChestInfo = hApi.Split(chestInfo, ";")
		local chestNum = tonumber(tChestInfo[1]) or User.CHEST_AMOUNT
		local infoIdx = 1
		
		--��ʼ�������
		if self._chestList == -1 then
			self._chestList = {}
		end
		
		--������������
		for i = 1, chestNum do
			local chestList = tChestInfo[infoIdx + i] or ""
			local tChestList = hApi.Split(chestList,":")

			--��һ����������ѱ���
			if i == 1 then
				local chestId = tonumber(tChestList[1]) or hClass.Chest.TYPE.FREE
				local chestGettime = tonumber(tChestList[2]) or 0

				self._freechest = hClass.Chest:create():Init(chestId,chestGettime)		--�������
				
				--���û�����ӣ����Զ�������
				self:RewardChest(0)
			else
				local chestId = tonumber(tChestList[1])
				local chestGettime = tonumber(tChestList[2])
				
				if chestId and chestId >= 0 and chestGettime and chestGettime > 0 then
					--���û�����ӣ����Զ�������
					self._chestList[i - 1] = hClass.Chest:create():Init(chestId,chestGettime)	--�����б�
					if not self._chestList[i - 1] then
						self._chestList[i - 1] = 0
					end
				else
					self._chestList[i - 1] = 0							--û�����ӳ�ʼ��Ϊ0�������޷���#����
				end
			end
		end
	end
	--------------------------------------------------------�������--------------------------------------------------------
	
	
	
	
	--------------------------------------------------------���߲���--------------------------------------------------------
	--��ʼ��������Ϣ
	function User:_InitItemInfo(bFlag)
					
		--����Ѿ����������ͷŵ�֮ǰ������
		if self._itemMgr and type(self._itemMgr) == "table" and self._itemMgr:getCName() == "RedEquipMgr" then
			self._itemMgr:Release()
		--else
		--	self._itemMgr = hClass.RedEquipMgr:create()
		end
		
		--��ʼ��ս�����ܿ���Ϣ
		self._itemMgr = hClass.RedEquipMgr:create(bFlag):Init(self._dbId, self._rId)
	end
	--------------------------------------------------------���߲���--------------------------------------------------------
	
	
	
	
	
	--------------------------------------------------------ս��������--------------------------------------------------------
	--ˢ��ս������������
	function User:TacticRefreshAddOnes(id, idx)
		local ret

		local tactic = self._tacticMgr:GetTactic(id)

		if tactic and tactic:CheckCanRefreshAddOnes(idx) then
			--��ȡ���ֿ���������Ĳ���
			local itemId, materialList, gamecoin, score = tactic:GetRefreshAddOnesCost()

			--�ж��Ƿ����㹻�Ĳ���
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

				--�۳���Ϸ��
				if itemId > 0 and self:_DBUserPurchase(itemId,1,gamecoin,score,tactic:InfoToCmd()) then
					--�۳�����
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

					--ˢ��ս������������
					tactic:RefreshAddOnes(idx)
					
					--��������(��Ʒid, ��������id, �������, ��������)
					ret = itemId .. ";" .. gamecoin .. ";" .. score .. ";" .. idx .. ";" .. tactic:InfoToCmd()
					--����浵ʧ���п��ܻᵼ�¿ͻ��˵����ݲ�һ��
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

	--����һ��ս������������
	function User:TacticNewAddOnes(id)
		local ret

		local tactic = self._tacticMgr:GetTactic(id)

		if tactic and tactic:CheckCanNewAddOnes() then
			--��ȡ���ֿ���������Ĳ���
			local itemId, materialList, gamecoin, score = tactic:GetNewAddOnesCost()

			----�ж��Ƿ����㹻�Ĳ���
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

				--�۳���Ϸ��
				if itemId > 0 and self:_DBUserPurchase(itemId,1,gamecoin,score,tactic:InfoToCmd()) then
					----�۳�����
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

					--����һ��ս������������
					tactic:NewAddOnes()
					
					--��������(��Ʒid, ��������id, �������, ��������)
					ret = itemId .. ";" .. gamecoin .. ";" .. score .. ";" .. tactic:GetAddOnsNum() .. ";" .. tactic:InfoToCmd()

					--����浵ʧ���п��ܻᵼ�¿ͻ��˵����ݲ�һ��
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

	--��ԭһ��ս������������
	function User:TacticRestoreAddOnes(id, idx)
		local ret

		local tactic = self._tacticMgr:GetTactic(id)
		--print("TacticRestoreAddOnes1:",tactic,tactic:CheckCanRestoreAddOnes(idx))
		if tactic and tactic:CheckCanRestoreAddOnes(idx) then
			--��ȡ���ֿ���������Ĳ���
			local itemId, materialList, gamecoin, score = tactic:GetRestoreAddOnesCost()

			----�ж��Ƿ����㹻�Ĳ���
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
				--�۳���Ϸ��
				if itemId > 0 and self:_DBUserPurchase(itemId,1,gamecoin,score,tactic:InfoToCmd()) then
					--print("TacticRestoreAddOnes4:",itemId)
					----�۳�����
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

					--����һ��ս������������
					tactic:RestoreAddOnes(idx)
					
					--��������(��Ʒid, ��������id, �������, ��������)
					ret = itemId .. ";" .. gamecoin .. ";" .. score .. ";" .. idx .. ";" .. tactic:InfoToCmd()

					--����浵ʧ���п��ܻᵼ�¿ͻ��˵����ݲ�һ��
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

	--ս��������
	function User:TacticLvUp(id)
		
		local ret

		--�ж��Ǽ�
		local tactic = self._tacticMgr:GetTactic(id)
		
		--���û�п�����Ҫ����һ��
		if not tactic then
			if self._tacticMgr:AddTactic(id,0) then
				tactic = self._tacticMgr:GetTactic(id)
			end
		end
		
		--���ж���ɫ�����Ƿ��㹻��Ӣ���Ƿ��Ѿ��ﵽ����Ǽ�
		if tactic and tactic:CheckCanLvUp() then
			
			--��ȡ���ֿ���������Ĳ���
			local itemId, materialList, gamecoin, score = tactic:GetLvUpCost()

			--�ж��Ƿ����㹻�Ĳ���
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

				--�۳���Ϸ��
				if itemId > 0 and self:_DBUserPurchase(itemId,1,gamecoin,score,tactic:InfoToCmd()) then
					--�۳�����
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

					--���ֿ�����
					tactic:LvUp()
					
					--��������(��Ʒid, ��������id, �������, ��������)
					ret = itemId .. ";" .. gamecoin .. ";" .. score .. ";" .. tactic:InfoToCmd()
					--����浵ʧ���п��ܻᵼ�¿ͻ��˵����ݲ�һ��
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

	--��ʼ��ս�����ܿ���Ϣ
	function User:_InitTacticInfo(tacticInfo)

		--����Ѿ����������ͷŵ�֮ǰ������
		if self._tacticMgr and type(self._tacticMgr) == "table" and self._tacticMgr:getCName() == "TacticMgr" then
			self._tacticMgr:Release()
		else
			self._tacticMgr = hClass.TacticMgr:create()
		end
		
		--��ʼ��ս�����ܿ���Ϣ
		self._tacticMgr:Init(tacticInfo)
	end
	--------------------------------------------------------ս��������--------------------------------------------------------
	
	--------------------------------------------------------Ӣ�۲���--------------------------------------------------------
	
	--��ȡװ��������
	function User:GetHeroMgr()
		return self._heroMgr
	end
	--Ӣ�۽���
	function User:HeroUnlock(heroId)
		local ret

		--�ж��Ǽ�
		local hero = self._heroMgr:GetHero(heroId)
		--print("HeroUnlock:",hero,hero:CheckCanUnlock())
		
		--���ж���ɫ�����Ƿ��㹻��Ӣ���Ƿ��Ѿ��ﵽ����Ǽ�
		if hero and hero:CheckCanUnlock() then

			local shopItemId, itemId, gamecoinCost, score = hero:GetUnlockCost()

			--print("itemId:",itemId)
			--�۳���Ϸ��
			if itemId > 0 and self:_DBUserPurchase(itemId,1,gamecoinCost,0,hero:InfoToCmd()) then
				
				--Ӣ������
				hero:Unlock()
				
				--��������(��Ʒid, ��������id, �������, ��������)
				ret = shopItemId .. ";" .. itemId .. ";" .. gamecoinCost .. ";" .. score .. ";" .. hero:InfoToCmd()

				--����浵ʧ���п��ܻᵼ�¿ͻ��˵����ݲ�һ��
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
	
	--Ӣ������
	function User:HeroStarLvUp(heroId)
		
		local ret

		--�ж��Ǽ�
		local hero = self._heroMgr:GetHero(heroId)
		
		--���ж���ɫ�����Ƿ��㹻��Ӣ���Ƿ��Ѿ��ﵽ����Ǽ�
		if hero and hero:CheckCanStarLvUp() then

			local shopItemId, itemId, gamecoinCost, score = hero:GetStarLvUpCost()
			--�۳���Ϸ��
			if itemId > 0 and self:_DBUserPurchase(itemId,1,gamecoinCost,0,hero:InfoToCmd()) then
				
				--Ӣ������
				hero:StarLvUp()
				
				--��������(��Ʒid, ��������id, �������, ��������)
				ret = shopItemId .. ";" .. itemId .. ";" .. gamecoinCost .. ";" .. score .. ";" .. hero:InfoToCmd()

				--����浵ʧ���п��ܻᵼ�¿ͻ��˵����ݲ�һ��
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
	
	--��ʼ��Ӣ����Ϣ
	function User:_InitHeroInfo(heroInfo)
		
		--����Ѿ����������ͷŵ�֮ǰ������
		if self._heroMgr and type(self._heroMgr) == "table" and self._heroMgr:getCName() == "HeroMgr" then
			self._heroMgr:Release()
		else
			self._heroMgr = hClass.HeroMgr:create()
		end
		
		--��ʼ��ս�����ܿ���Ϣ
		self._heroMgr:Init(heroInfo)
	end

	--------------------------------------------------------Ӣ�۲���--------------------------------------------------------

	--------------------------------------------------------��������--------------------------------------------------------
	function User:_InitInventoryInfo(inventoryInfo)
		--����Ѿ����������ͷŵ�֮ǰ������
		if self._inventoryMgr and type(self._inventoryMgr) == "table" and self._inventoryMgr:getCName() == "InventoryMgr" then
			self._inventoryMgr:Release()
		else
			self._inventoryMgr = hClass.InventoryMgr:create()
		end
		
		--��ȡ��ǰVip�ȼ�,����vip�ȼ���ȡ�����������
		local inventoryPage = hGlobal.vipMgr:GetInventoryCapacity(self:GetDBID())
		local capacity = inventoryPage * User.INVENTORY_SLOT_PAGE
		self._inventoryMgr:Init(capacity,inventoryInfo)
	end
	--------------------------------------------------------��������--------------------------------------------------------
	




	
	--------------------------------------------------------�ؿ�����--------------------------------------------------------
	function User:_InitLevelInfo(levelInfo)
		--����Ѿ����������ͷŵ�֮ǰ������
		if self._levelMgr and type(self._levelMgr) == "table" and self._levelMgr:getCName() == "LevelMgr" then
			self._levelMgr:Release()
		else
			self._levelMgr = hClass.LevelMgr:create()
		end
		
		--��ʼ��ս�����ܿ���Ϣ
		self._levelMgr:Init(levelInfo)
	end
	--------------------------------------------------------�ؿ�����--------------------------------------------------------
	





	--------------------------------------------------------���ݿ����--------------------------------------------------------
	--ÿ����ȡ����
	function User:DBGetPvpCoinEveryDay()
		local ret = true

		--��������Ϸ��С��
		if self._pvpcoin < User.PVPCOIN_EVERYDAY_MAX then
			local pvpNow = math.min(self._pvpcoin + User.PVPCOIN_EVERYDAY_MAX, User.PVPCOIN_EVERYDAY_MAX)
			local pvpAdd = math.max(pvpNow - self._pvpcoin, 0)

			local err,dateNow = xlDb_Query("SELECT CURDATE()")
			if err == 0 then
				local timeNow = dateNow.. " 00:00:00"
				if self._pvpcoin_last_gettime < dateNow .. " 00:00:00" then
					--������ҽ��
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

	--�������
	function User:DBBuyPvpCoin()
		local ret = true

		local udbid = self:GetDBID()

		local itemId = 9923
		local gamecoinCost = 20
		local pvpAdd = 30

		--print("DBBuyPvpCoin:",1)

		if self:_DBUserPurchase(itemId,1,gamecoinCost,0,""..(self._pvpcoin)) then
			--���¾���������
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

	--��ȡ�û�����
	function User:_DBGetUserInfo()
		local ret = false
		if self._dbId > 0 and self._rId > 0 then
			--print("��ȡ�û�����", self._dbId, self._rId)
			local sql= string.format("SELECT c.name,u.gamecoin_online,u.gamescore_online,u.pvpcoin,u.last_every_day_pvpcoin_get_time,u.bTester,u.challengeMaxCount,u.challengeMaxCount1,DATE(u.challengeRefreshTime) FROM t_cha AS c, t_user AS u WHERE u.uid=%d AND c.id=%d",self._dbId,self._rId)
			
			local err,name,gamecoin,gamescore,pvpcoin,pvpcoinLastTime,bTester,challengeMaxCount,challengeMaxCount1,challengeRefreshTime = xlDb_Query(sql)
			--print("err=", err)
			if err == 0 then
				
				------------------------------------------------------------ͭȸ̨��ħ������Ϣˢ��------------------------------------------------------------
				--���ȿ����Ƿ�Ҫˢ�´���
				--[[
				--��Ϊt_pvp_userˢ����ս����
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
				
				------------------------------------------------------------������Ϣt_user,t_cha------------------------------------------------------------
				self._name = name or hVar.tab_string["__TEXT_PLAYER"].. tostring(self._dbId)
				self._gamecoin = gamecoin			--�û���Ϸ��
				self._gamescore = gamescore			--�û�����
				self._pvpcoin = pvpcoin				--�û�����
				self._pvpcoin_last_gettime = pvpcoinLastTime	--����ÿ����ȡ��һ����ȡʱ��
				--�Ƿ����Ա
				if bTester > 0 then
					self._bTester = true
					if tonumber(bTester) == 2 then
						self._bGM = true
					end
				else
					self._bTester = false
					self._bGM = false
				end
				
				------------------------------------------------------------pvpser�е���Ϣ------------------------------------------------------------
				local sqlpvp = string.format("SELECT pu.uid,pu.evaluateE,pu.evaluateE_log,pu.coppercount,pu.silvercount,pu.goldcount,pu.chestexp,pu.arenachest,pu.arenachest_open,pu.chestInfo,pu.tacticInfo,pu.heroInfo,pu.inventoryInfo,pu.levelInfo FROM t_pvp_user as pu where pu.id=%d",self._rId)
				local errpvp,uidpvp,evaluateE,evaluateELog,coppercount,silvercount,goldcount,chestexp,arenachest,arenachestOpen,chestInfo,tacticInfo,heroInfo,inventoryInfo,levelInfo = xlDb_Query(sqlpvp)
				if errpvp == 0 then
					
					self._evaluateE = evaluateE			--�����������ģʽ��ƥ��ģʽ���ۼ���������
					self._evaluateELog = evaluateELog		--��ʷ�ϻ�õ���������
					self._coppercount = coppercount			--������ͭ��������
					self._silvercount = silvercount			--����������������
					self._goldcount = goldcount			--�����Ľ�������
					self._chestexp = chestexp			--�����ı�����ܾ���
					self._arenachest = arenachest			--��̨�����ҵĵ�ǰ����
					self._arenachestOpen = arenachestOpen		--��̨�����ҵ���ʷ��������
					
					--��ʼ����ҵ�����Ϣ
					self:_InitItemInfo(true)
					--self._itemMgr = hClass.RedEquipMgr:creat(true):Init(self._dbId,self._rId)
					
					--������Ϣ��ʼ��
					self:_InitChestInfo(chestInfo)
					
					--ս�����ܿ���ʼ��
					self:_InitTacticInfo(tacticInfo)

					--Ӣ�۳�ʼ��
					self:_InitHeroInfo(heroInfo)


					--�������߳�ʼ��
					self:_InitInventoryInfo(inventoryInfo)

					--�ؿ���Ϣ��ʼ��
					self:_InitLevelInfo(levelInfo)

					--���t_pvp_user�е�uid�͵�ǰ��¼��uid��һ�£������t_pvp_user�е�uid
					if uidpvp ~= self._dbId then
						local sUpdate = string.format("UPDATE t_pvp_user SET uid=%d, `name`='%s' WHERE id=%d",self._dbId,name,self._rId)
						--print("sUpdate",sUpdate)
						xlDb_Execute(sUpdate)
					end
					
					ret = true
				else
					--�¾��������
					--�����¼
					local sql2 = string.format("INSERT INTO t_pvp_user (id,uid,`name`) values (%d,%d,'%s')",self._rId,self._dbId,tostring(name))
					local err2 = xlDb_Execute(sql2)
					--print("sql2:",sql2,err2)
					if err2 == 0 then
						self._evaluateE = 0			--����ģʽ�ۼ���������
						self._evaluateELog = 0			--��ʷ�ϻ�õ���������
						self._coppercount = 0			--������ͭ��������
						self._silvercount = 0			--����������������
						self._goldcount = 0			--�����Ľ�������
						self._chestexp = 0			--�����ı�����ܾ���
						self._arenachest = 0			--��̨�����ҵĵ�ǰ����
						self._arenachestOpen = 0		--��̨�����ҵ���ʷ��������
						
						--��ʼ����ҵ�����Ϣ
						self:_InitItemInfo(false)
						
						--������Ϣ��ʼ��
						self:_InitChestInfo(User.CHEST_AMOUNT.. ";")

						--ս�����ܿ���ʼ��
						self:_InitTacticInfo("0;")

						--Ӣ�۽����ʼ��
						self:_InitHeroInfo("0;")

						--�������߳�ʼ��
						self:_InitInventoryInfo("0;")

						--�ؿ���Ϣ��ʼ��
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

	--�����û�����(�������ã�����ս�������汦�䣬���濨)
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
		
		--�������Ҫ�������,����б���
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
	
	--��ҹ������
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

			--������㹻����Ϸ��
			if gamecoinCost <= self._gamecoin then

				local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]

				--�µĹ����¼���뵽order��
				local sUpdateLog = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,dbid,rid,itemId,nItemNum,sItemName,nGamecoinCost,nScoreCost,sItemExt)
				xlDb_Execute(sUpdateLog)
				
				--��Ǯ
				--����t_user
				self._gamecoin = self._gamecoin + (-gamecoinCost)
				self:_DBAddGamecoin(-gamecoinCost)

				ret = true
			end
		end

		return ret
	end
	
	--������Ϸ��
	function User:_DBAddGamecoin(addGold)

		local gold = math.min(300, (addGold or 0))
		local dbid = self:GetDBID()
			
		--�ڴ�
		self._gamecoin = self._gamecoin + gold

		if gold > 0 then
			--
			local sUpdate = string.format("UPDATE t_user SET gamecoin_online = gamecoin_online + %d WHERE uid = %d",gold,dbid)
			xlDb_Execute(sUpdate)

			--add log
			local sLog = string.format("insert into prize (uid,type, mykey, used) values (%d,%d,%d,%d)",dbid,400,gold,2)
			xlDb_Execute(sLog)
		elseif gold < 0 then
			--�۳���ң�����¼��prize�����ڿ�֮ǰ��order
			local sUpdate = string.format("UPDATE t_user SET gamecoin_online = gamecoin_online + %d WHERE uid = %d",gold,dbid)
			xlDb_Execute(sUpdate)
		end
	end

	--���ӱ���(������)��һ�μ�1����
	function User:_DBAddVii(itemId, itemNum)
		-- itemId, 9004-9006���� 9300-9320��Ƭ 9999��ױ����
		local num = itemNum or 1
		local dbid = self:GetDBID()
		local rid = self:GetRID()
		local rpKey = ""

		--������һ�����3������ֹx3�Ҹ㣩
		if itemId == 9004 then
			rpKey = "chest_cuprum"
		elseif itemId == 9005 then
			num = math.min(3, num)
			rpKey = "chest_silver"
		--����һ�����1������ֹx3�Ҹ㣩
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
	--------------------------------------------------------���ݿ����--------------------------------------------------------

	--------------------------------------------------------InfoToCmd����--------------------------------------------------------
	--�û�loginResult toCmd
	function User:BaseInfoToCmd()
		
		--������Ϣ
		local cmd = ""
		cmd = cmd .. tostring(self._id) .. ";"				--�ڴ�id
		cmd = cmd .. tostring(self._dbId) .. ";"			--���ݿ�id
		cmd = cmd .. tostring(self._rId) .. ";"				--��ǰʹ�õĽ�ɫId
		cmd = cmd .. tostring(self._name) .. ";"			--�û�����
		cmd = cmd .. tostring(self._gamecoin) .. ";"			--�û���Ϸ��
		cmd = cmd .. tostring(self._gamescore) .. ";"			--�û�����
		cmd = cmd .. tostring(self._pvpcoin) .. ";"			--�û�����
		cmd = cmd .. tostring(self._pvpcoin_last_gettime) .. ";"	--����ÿ����ȡ��һ����ȡʱ��
		cmd = cmd .. tostring(self._evaluateE) .. ";"			--����ģʽ�ۼ���������
		cmd = cmd .. tostring(self._evaluateELog) .. ";"		--��ʷ�ϻ�õ���������
		cmd = cmd .. tostring(self._arenachest) .. ";"			--��̨�����ҵĵ�ǰ����

		cmd = cmd .. tostring(self._coppercount) .. ";"			--������ͭ��������
		cmd = cmd .. tostring(self._silvercount) .. ";"			--����������������
		cmd = cmd .. tostring(self._goldcount) .. ";"			--�����Ľ�������
		cmd = cmd .. tostring(self._arenachestOpen) .. ";"		--��̨�����ҵ���ʷ��������
		cmd = cmd .. tostring(self._chestexp) .. ";"			--�����ı�����ܾ���

		return cmd
	end
	
	--������Ϣ toCmd������dbid, rid��
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
	
	--������Ϣ toCmd
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
	
	--ս�����ܿ���Ϣ toCmd
	function User:TacticInfoToCmd()
		
		local cmd = ""
		--Ӣ����Ϣ
		if self._tacticMgr and type(self._tacticMgr) == "table" and self._tacticMgr:getCName() == "TacticMgr" then
			cmd = self._tacticMgr:InfoToCmd() or ""
		end

		cmd = tostring(self._dbId) .. ";" .. tostring(self._rId) .. ";" .. cmd
		return cmd
	end

	--Ӣ����Ϣ toCmd
	function User:HeroInfoToCmd()

		local cmd = ""
		--Ӣ����Ϣ
		if self._heroMgr and type(self._heroMgr) == "table" and self._heroMgr:getCName() == "HeroMgr" then
			cmd = self._heroMgr:InfoToCmd() or ""
		end

		cmd = tostring(self._dbId) .. ";" .. tostring(self._rId) .. ";" .. cmd
		return cmd
	end

	--������Ϣ toCmd
	function User:ItemInfoToCmd()
		
		local cmd = ""
		--������Ϣ
		if self._itemMgr and type(self._itemMgr) == "table" and self._itemMgr:getCName() == "ItemMgr" then
			cmd = self._itemMgr:InfoToCmd() or ""
		end
		
		cmd = tostring(self._dbId) .. ";" .. tostring(self._rId) .. ";" .. cmd
		return cmd
	end

	--����������Ϣ
	function User:InventoryInfoToCmd()
		--todo
		local cmd = ""
		return cmd
	end

	--�ؿ���Ϣ
	function User:LevelInfoToCmd()
		local cmd = ""
		--������Ϣ
		if self._levelMgr and type(self._levelMgr) == "table" and self._levelMgr:getCName() == "LevelMgr" then
			cmd = self._levelMgr:InfoToCmd() or ""
		end

		cmd = tostring(self._dbId) .. ";" .. tostring(self._rId) .. ";" .. cmd
		return cmd
	end
	--------------------------------------------------------InfoToCmd����--------------------------------------------------------
return User




