--����ת�̻������
local ActivityTurnTable = class("ActivityTurnTable")
	--����ת�̻id
	ActivityTurnTable.ACTIVITY_ID = 10024
	
	--����ת�̻�����б���ʾ�������
	ActivityTurnTable.ACTIVITY_PRIZELIST_MAXNUM = 200
	
	--����ת�̻ÿ�γ齱�ĸ���λ���ʱ�
	--ѭ����
	ActivityTurnTable.REWARD_PROBABLITY =
	{
	--[��n�γ齱] = {��1������, ��2������, ��3������, ��4������, ��5������, ��6������, δ���д���һ�θ��ӵ�����ֵ,},
		[1] = {30,		30,		30,		10,		0,		0,		nextLuckyPoint = 0,},
		[2] = {28,		28,		28,		16,		0,		0,		nextLuckyPoint = 0,},
		[3] = {26,		26,		26,		16,		6,		0,		nextLuckyPoint = 0,},
		[4] = {24,		24,		24,		19,		9,		0,		nextLuckyPoint = 4,},
		[5] = {22,		22,		22,		22,		12,		0,		nextLuckyPoint = 4,},
		[6] = {20,		20,		20,		25,		15,		0,		nextLuckyPoint = 4,},
		[7] = {18,		18,		18,		28,		18,		0,		nextLuckyPoint = 4,},
		[8] = {16,		16,		16,		31,		21,		0,		nextLuckyPoint = 4,},
		[9] = {14,		14,		14,		34,		24,		0,		nextLuckyPoint = 4,},
		[10] = {12,		12,		12,		37,		27,		0,		nextLuckyPoint = 4,},
	}
	
	--��6����������ֵ
	-- ��6����ÿ�γ齱�����ȡ��ҵ�ǰ������ֵ��
	--  ������γ鵽�󽱣�������ֵ����
	--  �������û�鵽�󽱣�������ֵ����ӱ�������ֵ
	
	--���캯��
	function ActivityTurnTable:ctor()
		self._uid = -1
		self._rid = -1
		self._aid = -1
		self._channelId = -1
		
		return self
	end
	
	--��ʼ��
	function ActivityTurnTable:Init(uid, rid, aid, channelId)
		self._uid = uid
		self._rid = rid
		self._aid = aid
		self._channelId = channelId
		
		return self
	end
	
	--����ָ����������Ϸ������ɶ��ٴ�ת�̴��������������Ϸ��
	function ActivityTurnTable:__GameCoin2TurnCount(gameCoins, prize)
		local turnCount = 0
		local requiereGameCoin = 0
		
		--������
		--[[
		{
			rate = 200,
			prize = 
			{
				{type="td",id=20008,detail="ת�̻-ÿ����200��Ϸ�ҽ���;1:3000:0:0;",},
			}
		},
		...
		]]
		
		--����һ�ֵ���Ϸ�Һ�
		local roundSum = 0
		for i = 1, #prize, 1 do
			roundSum = roundSum + prize[i].rate
		end
		--print("roundSum=", roundSum)
		
		--��ʼ����
		local pivot = gameCoins
		
		--�ȼ���һ�������Ľ�����Ӧ��ת�̴���
		if (pivot >= roundSum) then
			local div = math.floor(pivot / roundSum)
			pivot = pivot - roundSum * div
			turnCount = turnCount + (#prize) * div
			--print("div=", div)
			--print("(#prize)=", (#prize))
		end
		
		--�ټ��㲻��һ�������Ľ���ʣ���ת�̴���
		local ii = 1
		while true do
			if (pivot >= prize[ii].rate) then --��һ������Ϸ���㹻���
				pivot = pivot - prize[ii].rate
				turnCount = turnCount + 1
				ii = ii + 1
			else --��һ��δ���
				--����ʣ����Ҫ����Ϸ������
				requiereGameCoin = prize[ii].rate - pivot
				
				break
			end
		end
		
		return turnCount, requiereGameCoin
	end
	
	--�������ת�̳齱���
	--���� drawCount: �����ǵڼ��γ齱, ��6����������ֵ
	--����ֵ: �µ�������ֵ, ��������, ������
	function ActivityTurnTable:__TurnTableReward(gameCoins, prize, drawCount, lv06)
		--�齱���ʱ�
		local randPIdx = drawCount % (#ActivityTurnTable.REWARD_PROBABLITY)
		if (randPIdx == 0) then
			randPIdx = (#ActivityTurnTable.REWARD_PROBABLITY)
		end
		local PROBABLITYTABLE = ActivityTurnTable.REWARD_PROBABLITY[randPIdx]
		
		--������
		--[[
		{
			rate = 200,
			prize = 
			{
				{type="td",id=20008,detail="ת�̻-ÿ����200��Ϸ�ҽ���;1:3000:0:0;",},
			}
		},
		...
		]]
		
		--��������ֵ�Ĵ��ڣ����ɱ�����ʵ���ʱ�
		local probablityTable = {}
		for i = 1, #PROBABLITYTABLE, 1 do
			probablityTable[i] = PROBABLITYTABLE[i]
		end
		probablityTable[#probablityTable] = probablityTable[#probablityTable] + lv06 --���һ������������ֵ
		probablityTable.nextLuckyPoint = PROBABLITYTABLE.nextLuckyPoint
		
		--�����ܼ���
		local probablitySum = 0
		for i = 1, #prize, 1 do
			probablitySum = probablitySum + probablityTable[i]
		end
		--print("probablitySum=", probablitySum)
		
		--���������
		local rand = math.random(1, probablitySum)
		
		--����������
		local index = 0 --�������ֵ
		local pivot = rand
		for i = 1, #prize, 1 do
			if (pivot <= probablityTable[i]) then --�ҵ���
				index = i
				break
			else
				pivot = pivot - probablityTable[i]
			end
		end
		
		--�����µ�������ֵ
		local newLv06 = 0
		if (index < #probablityTable) then
			newLv06 = lv06 + probablityTable.nextLuckyPoint
		end
		
		return newLv06, index, prize[index].prize
	end
	
	--��ѯ����ת�̻���״̬
	function ActivityTurnTable:QueryFinishState()
		--�ܹ����ĵ���Ϸ�Һ�ʣ��齱����
		local nGameCoinTotalCost = 0
		local nTotalTurnCount = 0
		local nLeftTurnCount = 0
		local nRequiereGameCoin = 0 --���������Ϸ�ҿ�תת��
		
		--��ѯ���Ϣ
		local sQuery = string.format("select `type`, `channel`, `prize`, `time_begin`, `time_end` from `activity_template` where `aid`= %d", self._aid)
		local iErrorCode, pType, strChannel, szPrize, strBeginTime, strEndTime = xlDb_Query(sQuery)
		--print("��ѯ���Ϣ", iErrorCode, pType, strChannel, szPrize, strBeginTime, strEndTime)
		
		if (iErrorCode == 0) then
			--��Ч������ת�̻id
			if (pType == ActivityTurnTable.ACTIVITY_ID) then
				--����������Ƿ���Ч
				local bChannelValid = false
				
				if (strChannel == nil) or (strChannel == "") then --�δ��д�����ţ�������������Ч
					bChannelValid = true
				else --����Ƿ������������
					local pos = string.find(strChannel, ";" .. self._channelId .. ";")
					if (pos ~= nil) then
						bChannelValid = true --�ҵ���
					end
				end
				
				--print("bChannelValid=", bChannelValid)
				
				--���Ч��������
				if bChannelValid then
					--��ѯ����ڻ����ʼʱ����ڣ��ܹ������˶�����Ϸ��
					local sQuery = string.format("SELECT SUM(`coin`) FROM `order` WHERE `uid` = %d AND `time_begin` >= '%s' AND `time_begin` <= '%s'", self._uid, strBeginTime, strEndTime)
					local err, sumCoin = xlDb_Query(sQuery)
					--print("�ܹ������˶�����Ϸ��:", "err=", err, "sumCoin=", sumCoin)
					if (err == 0) then
						sumCoin = tonumber(sumCoin) or 0
					else --û�м�¼
						sumCoin = 0
					end
					
					--�洢��ڼ����ĵ���Ϸ������
					nGameCoinTotalCost = sumCoin
					
					--����ܽ���
					local prize = {}
					if (type(szPrize) == "string") then
						szPrize = "{" .. szPrize .. "}"
						local tmp = "local prize = " .. szPrize .. " return prize"
						prize = assert(loadstring(tmp))()
					end
					
					--����ת���ܴ��������������Ϸ�ҿ���תת��
					nTotalTurnCount, nRequiereGameCoin = self:__GameCoin2TurnCount(sumCoin, prize)
					
					--��ѯ��ʹ��ת�̵Ĵ���
					local sQuery = string.format("SELECT `level` from `activity_check` where `uid` = %d and `rid` = %d and `aid`= %d limit 1", self._uid, self._rid, self._aid)
					local err, level = xlDb_Query(sQuery)
					--print("��ѯ�˻��һ����ɵĽ��Ⱥ�����:", "err=", err, "level=", level)
					if (err == 0) then
						--
					else --û�м�¼
						level = 0
					end
					
					--����ת��ʣ�����
					nLeftTurnCount = nTotalTurnCount - level
				end
			end
		end
		
		local cmd = tostring(self._aid) .. ";" .. tostring(ActivityTurnTable.ACTIVITY_ID) .. ";" .. tostring(nGameCoinTotalCost) .. ";" .. tostring(nTotalTurnCount) .. ";" .. tostring(nLeftTurnCount) .. ";" .. tostring(nRequiereGameCoin) .. ";"
		return cmd
	end
	
	--ʹ������ת�̻����
	function ActivityTurnTable:UseTurnTableCount()
		--�ܹ����ĵ���Ϸ�Һ�ʣ��齱����
		local nGameCoinTotalCost = 0
		local nTotalTurnCount = 0
		local nLeftTurnCount = 0
		local nRequiereGameCoin = 0 --���������Ϸ�ҿ�תת��
		
		local ret = 0 --�������
		
		local prizeType = 0 --��������
		local prizeIdx = 0 --�鵽����������ֵ
		local strPrizeCmd = "" --���������ַ���
		
		--��ѯ���Ϣ
		local sQuery = string.format("select `type`, `channel`, `prize`, `time_begin`, `time_end` from `activity_template` where `aid`= %d", self._aid)
		local iErrorCode, pType, strChannel, szPrize, strBeginTime, strEndTime = xlDb_Query(sQuery)
		--print("��ѯ���Ϣ", iErrorCode, pType, strChannel, szPrize, strBeginTime, strEndTime)
		
		if (iErrorCode == 0) then
			--��Ч������ת�̻id
			if (pType == ActivityTurnTable.ACTIVITY_ID) then
				--����������Ƿ���Ч
				local bChannelValid = false
				
				if (strChannel == nil) or (strChannel == "") then --�δ��д�����ţ�������������Ч
					bChannelValid = true
				else --����Ƿ������������
					local pos = string.find(strChannel, ";" .. self._channelId .. ";")
					if (pos ~= nil) then
						bChannelValid = true --�ҵ���
					end
				end
				
				--print("bChannelValid=", bChannelValid)
				
				--���Ч��������
				if bChannelValid then
					--��ѯ����ڻ����ʼʱ����ڣ��ܹ������˶�����Ϸ��
					local sQuery = string.format("SELECT SUM(`coin`) FROM `order` WHERE `uid` = %d AND `time_begin` >= '%s' AND `time_begin` <= '%s'", self._uid, strBeginTime, strEndTime)
					local err, sumCoin = xlDb_Query(sQuery)
					--print("�ܹ������˶�����Ϸ��:", "err=", err, "sumCoin=", sumCoin)
					if (err == 0) then
						sumCoin = tonumber(sumCoin) or 0
					else --û�м�¼
						sumCoin = 0
					end
					
					--�洢��ڼ����ĵ���Ϸ������
					nGameCoinTotalCost = sumCoin
					
					--����ܽ���
					local prize = {}
					if (type(szPrize) == "string") then
						szPrize = "{" .. szPrize .. "}"
						local tmp = "local prize = " .. szPrize .. " return prize"
						prize = assert(loadstring(tmp))()
					end
					
					--����ת���ܴ��������������Ϸ�ҿ���תת��
					nTotalTurnCount, nRequiereGameCoin = self:__GameCoin2TurnCount(sumCoin, prize)
					
					--��ѯ��ʹ��ת�̵Ĵ�������6��������ֵ
					local sQuery = string.format("SELECT `level`, `lv06` from `activity_check` where `uid` = %d and `rid` = %d and `aid`= %d limit 1", self._uid, self._rid, self._aid)
					local errQuery, level, lv06 = xlDb_Query(sQuery)
					--print("��ѯ�˻��һ����ɵĽ��Ⱥ�����:", "errQuery=", errQuery, "level=", level)
					if (errQuery == 0) then
						--
					else --û�м�¼
						level = 0
						lv06 = 0
					end
					
					--����ת��ʣ�����
					nLeftTurnCount = nTotalTurnCount - level
					
					--��ʣ�����
					if (nLeftTurnCount > 0) then
						--���㱾���ǵڼ��γ齱
						local drawCount = level + 1
						
						--��ʼ�齱���ɽ���
						local newLv06, nPrizeIdx, tPrize = self:__TurnTableReward(sumCoin, prize, drawCount, lv06)
						
						--�洢�鵽�Ľ�������ֵ
						prizeIdx = nPrizeIdx
						
						--��ǳ齱��ʹ�ô���
						--���»����
						if (errQuery == 0) then
							--�޸Ļ����
							local sUpdate = string.format("update `activity_check` set `level` = %d, `lv06` = %d, `time` = now() where `aid` = %d and `uid` = %d and `rid` = %d",drawCount,newLv06,self._aid,self._uid,self._rid)
							xlDb_Execute(sUpdate)
						else
							--�����»����
							local sInsert = string.format("insert into `activity_check`(`aid`, `uid`, `rid`, `level`, `lv06`) values (%d, %d, %d, %d, %d)",self._aid,self._uid,self._rid,drawCount,newLv06)
							xlDb_Execute(sInsert)
						end
						
						--����
						--���뽱����ֻ����һ������
						local id = tPrize[1].id
						local detail = tPrize[1].detail
						
						--ȡ��������浽��ע��Ϣ��(�Ż����̣�ȡ�����б����ٲ����ݿ�)
						local uName = "player" .. self._uid --�û���
						local sQuery = string.format("select `name` from `t_cha` where `id`= %d", self._rid)
						local iErrorCode, nickname = xlDb_Query(sQuery)
						if (iErrorCode == 0) then
							uName = nickname
						end
						
						--����
						local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id,ext) values (%d,%d,'%s',%d,%d,'%s')",self._uid,id,detail,0,self._aid,uName..":"..prizeIdx)
						xlDb_Execute(sInsert)
						
						--20008 �Ž���ֱ�ӷ�������������������ȡ
						if (id == 20008) then
							--����id
							local err1, pid = xlDb_Query("select last_insert_id()")
							if (err1 == 0) then
								--�洢������Ϣ
								prizeType = id --��������
								
								--����������
								local fromIdx = 2
								strPrizeCmd = hApi.GetRewardInPrize(self._uid, self._rid, pid, fromIdx)
							end
						else
							--�洢������Ϣ
							prizeType = id --��������
							
							local maxRewardNum = 1
							local rewardNum = 1
							strPrizeCmd = tostring(pid).. ";" .. tostring(maxRewardNum) ..  ";" .. tostring(rewardNum) .. ";" .. detail
						end
						
						--ʣ���ת������1
						nLeftTurnCount = nLeftTurnCount - 1
						
						--�����ɹ�
						ret = 1
					end
				end
			end
		end
		
		local currenttime = os.time()
		local strHour = os.date("%H", currenttime) --ʱ(�ַ���)
		local strMinute = os.date("%M", currenttime) --��(�ַ���)
		local cmd = tostring(self._aid) .. ";" .. tostring(ActivityTurnTable.ACTIVITY_ID) .. ";" .. tostring(ret) .. ";"
				.. tostring(nGameCoinTotalCost) .. ";" .. tostring(nTotalTurnCount) .. ";" .. tostring(nLeftTurnCount) .. ";"
				.. tostring(nRequiereGameCoin) .. ";" .. tostring(prizeType) .. ";" .. tostring(prizeIdx) .. ";"
				.. tostring(strHour) .. ";" .. tostring(strMinute) .. ";" .. strPrizeCmd
		return cmd
	end
	
	--��ѯ����ת�̻���б�
	function ActivityTurnTable:GetPrizeList()
		local ret = 0 --�������
		local recordNum = 0 --��¼����
		local strRecordCmd = "" --���б��ַ��� "name:idx:HH:MM;..."
		
		--��ѯ���Ϣ
		local sQuery = string.format("select `type`, `channel`, `prize`, `time_begin`, `time_end` from `activity_template` where `aid`= %d", self._aid)
		local iErrorCode, pType, strChannel, szPrize, strBeginTime, strEndTime = xlDb_Query(sQuery)
		--print("��ѯ���Ϣ", iErrorCode, pType, strChannel, szPrize, strBeginTime, strEndTime)
		
		if (iErrorCode == 0) then
			--��Ч������ת�̻id
			if (pType == ActivityTurnTable.ACTIVITY_ID) then
				--����������Ƿ���Ч
				local bChannelValid = false
				
				if (strChannel == nil) or (strChannel == "") then --�δ��д�����ţ�������������Ч
					bChannelValid = true
				else --����Ƿ������������
					local pos = string.find(strChannel, ";" .. self._channelId .. ";")
					if (pos ~= nil) then
						bChannelValid = true --�ҵ���
					end
				end
				
				--print("bChannelValid=", bChannelValid)
				
				--���Ч��������
				if bChannelValid then
					--��ѯ�������idΪָ��ֵ���б�
					local sQuery = string.format("SELECT `uid`, `create_time`, `ext` FROM `prize` WHERE `create_id` = %d order by `id` desc limit %d", self._aid, ActivityTurnTable.ACTIVITY_PRIZELIST_MAXNUM)
					local err, tTemp = xlDb_QueryEx(sQuery)
					--print("sQuery", sQuery)
					--print("��ѯ������:", "err=", err, "tTemp=", tTemp)
					if (err == 0) then
						--���ֱ�
						--{[uid]="����xxx", ...}
						local tUserNameTable = {} 
						
						--�����ڴ�С��������
						for n = #tTemp, 1, -1 do
							local uid = tonumber(tTemp[n][1])
							local create_time = tostring(tTemp[n][2])
							local ext = tostring(tTemp[n][3]) --��ע��Ϣ "�����:����ֵ"
							
							--����ֻ����[HH:MM]��ʽ
							local nCreateTime = hApi.GetNewDate(create_time) --ʱ��
							local strHHMM = os.date("%H:%M", nCreateTime)
							
							recordNum = recordNum + 1
							strRecordCmd = strRecordCmd .. ext .. ":" .. strHHMM .. ";"
						end
						
						--�����ɹ�
						ret = 1
					end
				end
			end
		end
		
		local cmd = tostring(self._aid) .. ";" .. tostring(ActivityTurnTable.ACTIVITY_ID) .. ";" .. tostring(ret) .. ";" .. tostring(recordNum) .. ";" .. tostring(strRecordCmd) .. ";" 
		return cmd
	end
	
return ActivityTurnTable