--���������
local Chest = class("Chest")

	Chest.TYPE = 
	{
		COPPER = 9913,			--ͭ
		SILVER = 9914,			--��
		GOLD = 9915,			--��
		ARENA = 9916,			--��̨����
		REDEQUIP = 9917,		--��������
		LUCKYREDEQUIP = 9919,		--������������
		REDEQUIP_CRYSTAL = 9941,	--�һ�������ʯ
		CANGBAOTU_NORMAL_CRYSTAL = 9943,--�ر�ͼ�һ�
		CANGBAOTU_HIGH_CRYSTAL = 9944,	--�߼��ر�ͼ�һ�
		REDEQUIP_FIVE = 9947,		--��������*5
		REDEQUIP_CRYSTAL_FIVE = 9948,	--�һ�������ʯ*5
		ORANGEEQUIP = 9951,		--��װ����
		YELLOWEQUIP = 9956,		--��װ����
		YELLOWEQUIP_FIVE = 9957,	--��װ����*5
		
		--���̵�
		REDCHEST_ONCE = 9959,		--���������һ��
		REDCHEST_TENTH = 9960,		--���������ʮ��
		TACTICCARD_ONCE = 9961,		--ս��������һ��
		TACTICCARD_TENTH = 9962,	--ս��������ʮ��
		REDCHEST_ONCE_FREE = 9963,	--����������ѳ�һ��
		REDCHEST_TENTH_FREE = 9964,	--����������ѳ�ʮ��
		TACTICCARD_ONCE_FREE = 9965,	--ս��������ѳ�һ��
		TACTICCARD_TENTH_FREE = 9966,	--ս��������ѳ�ʮ��
		
		REDEQUIP_CRYSTAL_TENTH = 9967,	--�һ�������ʯ*10
		REDEQUIP_CRYSTAL_FIFTY = 9968,	--�һ�������ʯ*50
		TACTICCEST = 9969,		--ս������
		
		FREE = 99999,		--�����ȡ������������ȡ���䣬������Զ��������̣�
		
		CHEST_TYPE_MAXNUM = 9969,	--���ֵ
	}
	
	Chest.EXP = 
	{
		COPPER = 1,		--ͭ
		SILVER = 5,		--��
		GOLD = 20,		--��
		ARENA = 1,		--��̨����
		REDEQUIP = 0,		--��װ����

		FREE = 0,		--�����ȡ������������ȡ���䣬������Զ��������̣�
	}
    
	--���캯��
	function Chest:ctor()
		self._id = -1
		self._gettime = -1

		return self
	end
	function Chest:Init(id,gettime)
		
		--�����ж����
		if (not id) or (id <= 0) then
			return
		end

		self._id = id
		self._gettime = gettime

		return self
	end
	--��ȡ����Id
	function Chest:GetID()
		return self._id
	end
	--��ȡ�����ȡʱ��
	function Chest:GetGettime()
		return self._gettime
	end
	--���ñ���ΪFREE����
	function Chest:SetTypeFree()
		self._id = Chest.TYPE.FREE
	end
	
	--��ȡ����ʣ��ʱ��
	function Chest:_RemainOpentime()
		local timeNow = hApi.GetTime()
		local id = self:GetID()

		local openDelay = 0
		local chestT = hVar.tab_chest[id]
		if chestT then
			openDelay = chestT.openDelay or 0
		end
		--ʱ���ж�
		local ret = (self:GetGettime() + openDelay*60) - timeNow

		if ret < 0 then
			ret = 0
		end
		return ret
	end
	--��ȡ����һ��۸�
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
	
	--��ⱦ���Ƿ���Կ���(ʱ���ж�ȥ���ˣ���Ϊʣ��ʱ�����ת��Ϊ��Ϸ�ң���������)
	function Chest:_CheckCanOpen()
		local ret = false
		local id = self:GetID()
		local timeNow = hApi.GetTime()

		----ʱ���ж�
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
		
		--���ж�
		ret = true
		
		return ret
	end
	
	--roll�㣬����Ȩֵ�����ĸ����䣬���ص���
	function Chest:_RollDrop(pool)
		local ret 
		if not pool then
			return ret
		end

		local value = math.random(1, pool.totalValue)
		local initialValue = 0
		--��������Ȩ�������ĸ�����
		for i = 1, #pool do
			if value > initialValue and value <= initialValue + pool[i].value then
				ret = pool[i].reward
				break
			end
			initialValue = initialValue + pool[i].value
		end
		return ret
	end

	--��һ�����������зֳ����ɸ����������������֣��еĵ���
	function Chest:_DivideInteger2Several(num, divideCount)
		
		--����  1 2 3 4 5 6 7
		--��   0 1 2 3 4 5 6 7

		local ret = {}
		local hole = num - 1
		--����п�
		--if hole > 0 then
		--����пӲ����еĵ�������0
		if hole > 0 and divideCount > 0 then
			--��Ҫ�еĵ���(�������ܴ��ڿӵ�����)
			local rCount = math.min(hole, divideCount)
			local holeposDic = {}
			local holeposList = {}
			--����У���¼���еĿӵ�λ�ã����ظ��У�
			for i = 1, rCount do
				local r = math.random(1, hole)
				
				if not holeposDic[r] then
					holeposDic[r] = true
					holeposList[#holeposList + 1] = r
				end
			end
			
			--���г���λ�ñ�Ű�����������
			table.sort(holeposList, function(a, b)
				return (a < b)
			end)
			
			--��һ���е�λ��
			local lastpos = 0
			--�����е�λ�ÿ�ʼ�ֵ���
			for i = 1, #holeposList do
				local holepos = holeposList[i]
				--��ǰ�е�λ�ü�ȥ��һ���е�λ�þ�����鵰��
				ret[#ret + 1] = holepos - lastpos
				--����һ����һ���е�λ��
				lastpos = holepos
				--����Ѿ������һ���ˣ���Ҫ�����ұߵ�һ�鵰��
				if i == #holeposList then
					ret[#ret + 1] = num - lastpos
				end
			end
		else
			--û��ֱ�ӷ���
			ret[#ret + 1] = num
		end
		
		return ret
	end
	
	--������
	function Chest:Open(mustRed)
		local ret
		local id = self:GetID()
		--print(id)
		
		--����ɴ򿪱���
		if self:_CheckCanOpen() then
			local numCritical = 1
			if hGlobal.aMgr and hGlobal.aMgr:CheckOpenChestCritical() then
				numCritical = 2
			end
			--ͨ�ý���
			local dropPool = hVar.tab_droppool
			--��ǰ��������
			local tabChest = hVar.tab_chest[id]
			
			--������غͽ������ö�����
			if tabChest and dropPool then
				
				--��ͨ���ҵ���
				if tabChest.reward then
					local rewardPool = tabChest.reward
					
					--�������ҵĵ�������
					for i = 1, #rewardPool do
						--ͨ�ý����еĽ��ؼ�ֵ
						local poolkey = rewardPool[i][1]
						--���ٵ���
						local minNum = rewardPool[i][2]
						--������
						local maxNum = math.max(rewardPool[i][3],minNum)
						--�ֶ���(��СҲ��1��)
						local section = rewardPool[i][4] - 1
						
						--���һ�����������
						local r = math.random(minNum, maxNum)
						--������������зֳ����ɷ�
						local sectionList = self:_DivideInteger2Several(r,section)
						--����ÿ�ε��������е���
						for j = 1, #sectionList do
							local rollDrop = self:_RollDrop(dropPool[poolkey])
							local dropNum = sectionList[j] * numCritical

							--print("OpenChest:",dropNum,sectionList[j],numCritical)
							--�����һ�������������������˳�
							if not rollDrop then
								ret = nil
								return ret
							end
							--���������ĵ���������������0������е��䣨todo��������Ҫ��Ҫ����ͬ�ĵ���ϲ���ò��ûɶ��Ҫ��
							if dropNum > 0 then
								if not ret then
									ret = hClass.Reward:create():Init()
								end
								if ret then
									local addOk,idx = ret:Add(rollDrop)
									--������������
									if addOk then
										ret:SetRewardNum(idx,dropNum)
									end
								end
							end
						end
					end
				
				elseif tabChest.rewardEx then --��װ���ҵ��� 
					local rewardPool = tabChest.rewardEx
					
					--�������ҵĵ�������
					for i = 1, #rewardPool do
						
						--���س�ȡ��λ����
						local rollCount = rewardPool[i].rollCount
						
						--������Ҫroll�Ĵ���
						for n = 1, rollCount do
							
							--ͨ�ý����еĽ��ؼ�ֵ
							local poolkeyInfo = self:_RollDrop(rewardPool[i].pool)
							if mustRed and string.lower(rewardPool[i].tag) == "equip" and rewardPool[i].mustDrop then
								poolkeyInfo = rewardPool[i].mustDrop
								
								--����1�κ�װ���Ͳ��ٱس�
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
											--������������
											if addOk then
												--��������������[3]�������һ������
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

	--������Ϣת��
	function Chest:InfoToCmd()
		local cmd = (self:GetID()) .. ":" .. (self:GetGettime()) .. ";"
		return cmd
	end
return Chest