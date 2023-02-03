--����������ֵ�������
local ActivitySevenDayPay = class("ActivitySevenDayPay")
	--����������ֵ�id
	ActivitySevenDayPay.ACTIVITY_ID = 10025
	
	--����������ֵ����֧�ֵ�����
	ActivitySevenDayPay.MAX_DAY = 7
	
	--���캯��
	function ActivitySevenDayPay:ctor()
		self._uid = -1
		self._rid = -1
		self._aid = -1
		self._channelId = -1
		
		return self
	end
	
	--��ʼ��
	function ActivitySevenDayPay:Init(uid, rid, aid, channelId)
		self._uid = uid
		self._rid = rid
		self._aid = aid
		self._channelId = channelId
		
		return self
	end
	
	--��ѯ����������ֵ���״̬
	--	result:
	--		 1:�ɹ�
	--		-1:��Ч�Ļid
	--		-2:��Ч�Ļ����
	--		-3:��Ч��������
	function ActivitySevenDayPay:QueryFinishState()
		local result = 0 --�Ƿ��ѯ�ɹ�
		local progress = 0 --�������ڵڼ���Ľ���
		local progressMax = 0 --������
		local payMoney = -1 --�����ѳ�ֵ��Ԫ��
		local leftMoney = -1 --����ʣ���ֵ��Ԫ��
		local tFinishState = {} --ÿ�ճ�ֵ�Ƿ���ɵı�Ǳ�
		local tRewardState = {} --ÿ�ճ�ֵ�Ƿ���ȡ�����ı�Ǳ�
		
		local sQuery = string.format("select `type`, `channel`, `prize`, `time_begin`, `time_end` from `activity_template` where `aid`= %d", self._aid)
		local iErrorCode, pType, strChannel, szPrize, strBeginTime, strEndTime = xlDb_Query(sQuery)
		--print("��ѯ���Ϣ", iErrorCode, pType, strChannel, strBeginTime, strEndTime)
		
		if (iErrorCode == 0) then
			if (pType == ActivitySevenDayPay.ACTIVITY_ID) then --����������ֵ�
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
					--����ܽ���
					local tPrize = {} --������
					if (type(szPrize) == "string") then
						szPrize = "{" .. szPrize .. "}"
						local tmp = "local prize = " .. szPrize .. " return prize"
						
						--������
						tPrize = assert(loadstring(tmp))()
						
						--������
						progressMax = #tPrize
						if (progressMax > ActivitySevenDayPay.MAX_DAY) then
							progressMax = ActivitySevenDayPay.MAX_DAY
						end
					end
					--print("������=", progressMax)
					--[[
					{
						rate = 60,
						prize = 
						{
							{type="td",id=20008,detail="���ճ�ֵ���6�콱��;9:9102:1:0;",},
						}
					},
					...
					]]
					
					--��ʼ����ɽ��ȱ�
					for i = 1, progressMax, 1 do
						tFinishState[i] = 0
					end
					
					--��ʼ��������ȡ��
					for i = 1, progressMax, 1 do
						tRewardState[i] = 0
					end
					
					--ÿ�յ��ܳ�ֵ����
					local tTotalPayMoney = {}
					for i = 1, progressMax, 1 do
						tTotalPayMoney[i] = 0
					end
					
					--�������ʼʱ��ת��Ϊ�����0��
					local nBeginTimestamp = hApi.GetNewDate(strBeginTime)
					local strDateBeginTimestampYMD = hApi.Timestamp2Date(nBeginTimestamp) --ת�ַ���(������)
					local strNewBeginTimeZeroDate = strDateBeginTimestampYMD .. " 00:00:00"
					local nTimestampBeginTimeZero = hApi.GetNewDate(strNewBeginTimeZeroDate)
					
					--��ѯ����ڻ����ʼʱ����ڣ�ȫ���ĳ�ֵ��¼
					local sQueryM = string.format("SELECT `money`, `buytime` FROM `iap_record` WHERE `uid` = %d AND `buytime` >= '%s' AND `buytime` <= '%s'", self._uid, strBeginTime, strEndTime)
					local errM, tTemp = xlDb_QueryEx(sQueryM)
					--print("��ѯ����ڻ����ʼʱ����ڣ�ȫ���ĳ�ֵ��¼:", "errM=", errM, "tTemp=", #tTemp)
					if (errM == 0) then
						--ͳ��ÿһ����ܳ�ֵ���
						for n = 1, #tTemp, 1 do
							local money = tTemp[n][1]
							local buytime = tTemp[n][2]
							
							--����ֵʱ��ת��Ϊ�����0��
							local nBuyTimestamp = hApi.GetNewDate(buytime)
							local strDateBuyTimestampYMD = hApi.Timestamp2Date(nBuyTimestamp) --ת�ַ���(������)
							local strNewBuyTimeZeroDate = strDateBuyTimestampYMD .. " 00:00:00"
							local nTimestampBuyTimeZero = hApi.GetNewDate(strNewBuyTimeZeroDate)
							
							--��������ʼʱ����������
							local deltatime = nTimestampBuyTimeZero - nTimestampBeginTimeZero
							local day = deltatime / 86400
							local dayIdx = day + 1
							
							--ֻͳ�Ʒ���������
							if (dayIdx <= progressMax) then
								tTotalPayMoney[dayIdx] = tTotalPayMoney[dayIdx] + money
							end
						end
					elseif (errM == 4) then --û�г�ֵ��¼
						--
					end
					
					--������յ�0��
					local nTimestampNow = os.time()
					local strDateTodaystampYMD = hApi.Timestamp2Date(nTimestampNow) --ת�ַ���(������)
					local strNewTodayZeroDate = strDateTodaystampYMD .. " 00:00:00"
					local nTimestampTodayZero = hApi.GetNewDate(strNewTodayZeroDate)
					
					--��������ǻ�ĵڼ���
					local todatydeltatime = nTimestampTodayZero - nTimestampBeginTimeZero
					local today = todatydeltatime / 86400
					local todayIdx = today + 1
					
					--��ʼ���㣬ÿ�յĽ����Ƿ����ȡ
					local finishTag = 1 --��ɵĽ���ֵ
					for day = 1, progressMax, 1 do
						local prize = tPrize[finishTag]
						local rate = prize.rate
						local reqiureMoney = rate / 10 --��Ҫ�Ľ�Ԫ��
						
						--������Ӧ������һ������
						if (todayIdx == day) then
							progress = finishTag
						end
						
						--������ճ�ֵ�����ϵ�λҪ�󣬱�Ǵ��ճ�ֵ�������
						if (tTotalPayMoney[day] >= reqiureMoney) then
							tFinishState[finishTag] = 1
							finishTag = finishTag + 1
						end
					end
					
					--��ѯ������ÿ�ս�������ȡ���
					local sQuery = string.format("SELECT `lv01`, `lv02`, `lv03`, `lv04`, `lv05`, `lv06`, `lv07` from `activity_check` where `uid` = %d and `rid` = %d and `aid`= %d limit 1", self._uid, self._rid, self._aid)
					local errQuery, lv01, lv02, lv03, lv04, lv05, lv06, lv07 = xlDb_Query(sQuery)
					--print("��ѯ������ÿ�ս�������ȡ���:", "errQuery=", errQuery, "level=", lv01, lv02, lv03, lv04, lv05, lv06, lv07)
					
					if (errQuery == 0) then
						--�洢��ȡ���
						tRewardState[1] = lv01
						tRewardState[2] = lv02
						tRewardState[3] = lv03
						tRewardState[4] = lv04
						tRewardState[5] = lv05
						tRewardState[6] = lv06
						tRewardState[7] = lv07
						
						--��ǲ�ѯ�ɹ�
						result = 1
					elseif (errQuery == 4) then --û�м�¼������Ϊ0
						--print("û�м�¼������Ϊ0")
						--��ǲ�ѯ�ɹ�
						result = 1
					end
					
					--��������ѳ�ֵ��Ԫ��
					--������ջ����ֵ��Ԫ��
					if (progress > 0) then
						--��������ѳ�ֵ��Ԫ��
						--�˴���ȡ��Ȼ�յĽ��
						payMoney = tTotalPayMoney[todayIdx]
						
						--������ջ����ֵ��Ԫ��
						--�˴���ȡ�����յ���Ҫ��ֵ���
						local prizeToday = tPrize[progress]
						local rateToday = prizeToday.rate
						local reqiureMoneyToday = rateToday / 10 --��Ҫ�Ľ�Ԫ��
						leftMoney = reqiureMoneyToday - payMoney
						if (leftMoney < 0) then
							leftMoney = 0
						end
					end
				else
					--(-3:��Ч��������)
					result = -3
				end
			else
				--(-2:��Ч�Ļ����)
				result = -2
			end
		else
			--(-1:��Ч�Ļid)
			result = -1
		end
		
		local strFinishState = ""
		local strRewardState = ""
		for i = 1, progressMax, 1 do
			strFinishState = strFinishState .. tFinishState[i] .. ";"
			strRewardState = strRewardState .. tRewardState[i] .. ";"
		end
		local cmd = tostring(self._aid) .. ";" .. tostring(ActivitySevenDayPay.ACTIVITY_ID) .. ";" .. tostring(result) .. ";" .. tostring(progress) .. ";" .. tostring(progressMax)
					.. ";" .. tostring(payMoney) .. ";" .. tostring(leftMoney) .. ";" .. strFinishState .. strRewardState
		return cmd
	end
	
	--��ȡָ����λ�Ľ���
	--	result:
	--		 1:�ɹ�
	--		-1:��Ч�Ļid
	--		-2:��Ч�Ļ����
	--		-3:��Ч��������
	--		-4:��Ч���콱��λ
	--		-5:�콱��λ����δ���
	--		-6:�콱��λ��������ȡ
	function ActivitySevenDayPay:TakeActivityReward(rewardIdx)
		local result = 0 --�Ƿ��ѯ�ɹ�
		local progress = 0 --�������ڵڼ���Ľ���
		local progressMax = 0 --������
		local payMoney = -1 --�����ѳ�ֵ��Ԫ��
		local leftMoney = -1 --����ʣ���ֵ��Ԫ��
		local tFinishState = {} --ÿ�ճ�ֵ�Ƿ���ɵı�Ǳ�
		local tRewardState = {} --ÿ�ճ�ֵ�Ƿ���ȡ�����ı�Ǳ�
		
		local prizeType = 0 --��������
		local prizeIdx = 0 --�鵽����������ֵ
		local strPrizeCmd = "" --���������ַ���
		
		local sQuery = string.format("select `type`, `channel`, `prize`, `time_begin`, `time_end` from `activity_template` where `aid`= %d", self._aid)
		local iErrorCode, pType, strChannel, szPrize, strBeginTime, strEndTime = xlDb_Query(sQuery)
		--print("��ѯ���Ϣ", iErrorCode, pType, strChannel, strBeginTime, strEndTime)
		
		if (iErrorCode == 0) then
			if (pType == ActivitySevenDayPay.ACTIVITY_ID) then --����������ֵ�
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
					--����ܽ���
					local tPrize = {} --������
					if (type(szPrize) == "string") then
						szPrize = "{" .. szPrize .. "}"
						local tmp = "local prize = " .. szPrize .. " return prize"
						
						--������
						tPrize = assert(loadstring(tmp))()
						
						--������
						progressMax = #tPrize
						if (progressMax > ActivitySevenDayPay.MAX_DAY) then
							progressMax = ActivitySevenDayPay.MAX_DAY
						end
					end
					--print("������=", progressMax)
					--[[
					{
						rate = 60,
						prize = 
						{
							{type="td",id=20008,detail="���ճ�ֵ���6�콱��;9:9102:1:0;",},
						}
					},
					...
					]]
					
					--��ʼ����ɽ��ȱ�
					for i = 1, progressMax, 1 do
						tFinishState[i] = 0
					end
					
					--��ʼ��������ȡ��
					for i = 1, progressMax, 1 do
						tRewardState[i] = 0
					end
					
					--ÿ�յ��ܳ�ֵ����
					local tTotalPayMoney = {}
					for i = 1, progressMax, 1 do
						tTotalPayMoney[i] = 0
					end
					
					--�������ʼʱ��ת��Ϊ�����0��
					local nBeginTimestamp = hApi.GetNewDate(strBeginTime)
					local strDateBeginTimestampYMD = hApi.Timestamp2Date(nBeginTimestamp) --ת�ַ���(������)
					local strNewBeginTimeZeroDate = strDateBeginTimestampYMD .. " 00:00:00"
					local nTimestampBeginTimeZero = hApi.GetNewDate(strNewBeginTimeZeroDate)
					
					--��ѯ����ڻ����ʼʱ����ڣ�ȫ���ĳ�ֵ��¼
					local sQueryM = string.format("SELECT `money`, `buytime` FROM `iap_record` WHERE `uid` = %d AND `buytime` >= '%s' AND `buytime` <= '%s'", self._uid, strBeginTime, strEndTime)
					local errM, tTemp = xlDb_QueryEx(sQueryM)
					--print("��ѯ����ڻ����ʼʱ����ڣ�ȫ���ĳ�ֵ��¼:", "errM=", errM, "tTemp=", #tTemp)
					if (errM == 0) then
						--ͳ��ÿһ����ܳ�ֵ���
						for n = 1, #tTemp, 1 do
							local money = tTemp[n][1]
							local buytime = tTemp[n][2]
							
							--����ֵʱ��ת��Ϊ�����0��
							local nBuyTimestamp = hApi.GetNewDate(buytime)
							local strDateBuyTimestampYMD = hApi.Timestamp2Date(nBuyTimestamp) --ת�ַ���(������)
							local strNewBuyTimeZeroDate = strDateBuyTimestampYMD .. " 00:00:00"
							local nTimestampBuyTimeZero = hApi.GetNewDate(strNewBuyTimeZeroDate)
							
							--��������ʼʱ����������
							local deltatime = nTimestampBuyTimeZero - nTimestampBeginTimeZero
							local day = deltatime / 86400
							local dayIdx = day + 1
							
							--ֻͳ�Ʒ���������
							if (dayIdx <= progressMax) then
								tTotalPayMoney[dayIdx] = tTotalPayMoney[dayIdx] + money
							end
						end
					elseif (errM == 4) then --û�г�ֵ��¼
						--
					end
					
					--������յ�0��
					local nTimestampNow = os.time()
					local strDateTodaystampYMD = hApi.Timestamp2Date(nTimestampNow) --ת�ַ���(������)
					local strNewTodayZeroDate = strDateTodaystampYMD .. " 00:00:00"
					local nTimestampTodayZero = hApi.GetNewDate(strNewTodayZeroDate)
					
					--��������ǻ�ĵڼ���
					local todatydeltatime = nTimestampTodayZero - nTimestampBeginTimeZero
					local today = todatydeltatime / 86400
					local todayIdx = today + 1
					
					--��ʼ���㣬ÿ�յĽ����Ƿ����ȡ
					local finishTag = 1 --��ɵĽ���ֵ
					for day = 1, progressMax, 1 do
						local prize = tPrize[finishTag]
						local rate = prize.rate
						local reqiureMoney = rate / 10 --��Ҫ�Ľ�Ԫ��
						
						--������Ӧ������һ������
						if (todayIdx == day) then
							progress = finishTag
						end
						
						--������ճ�ֵ�����ϵ�λҪ�󣬱�Ǵ��ճ�ֵ�������
						if (tTotalPayMoney[day] >= reqiureMoney) then
							tFinishState[finishTag] = 1
							finishTag = finishTag + 1
						end
					end
					
					--��ѯ������ÿ�ս�������ȡ���
					local sQuery = string.format("SELECT `lv01`, `lv02`, `lv03`, `lv04`, `lv05`, `lv06`, `lv07` from `activity_check` where `uid` = %d and `rid` = %d and `aid`= %d limit 1", self._uid, self._rid, self._aid)
					local errQuery, lv01, lv02, lv03, lv04, lv05, lv06, lv07 = xlDb_Query(sQuery)
					--print("��ѯ������ÿ�ս�������ȡ���:", "errQuery=", errQuery, "level=", lv01, lv02, lv03, lv04, lv05, lv06, lv07)
					
					if (errQuery == 0) then
						--�洢��ȡ���
						tRewardState[1] = lv01
						tRewardState[2] = lv02
						tRewardState[3] = lv03
						tRewardState[4] = lv04
						tRewardState[5] = lv05
						tRewardState[6] = lv06
						tRewardState[7] = lv07
						
						--��ǲ�ѯ�ɹ�
						--result = 1
					elseif (errQuery == 4) then --û�м�¼������Ϊ0
						--print("û�м�¼������Ϊ0")
						--��ǲ�ѯ�ɹ�
						--result = 1
					end
					
					--��������ѳ�ֵ��Ԫ��
					--������ջ����ֵ��Ԫ��
					if (progress > 0) then
						--��������ѳ�ֵ��Ԫ��
						--�˴���ȡ��Ȼ�յĽ��
						payMoney = tTotalPayMoney[todayIdx]
						
						--������ջ����ֵ��Ԫ��
						--�˴���ȡ�����յ���Ҫ��ֵ���
						local prizeToday = tPrize[progress]
						local rateToday = prizeToday.rate
						local reqiureMoneyToday = rateToday / 10 --��Ҫ�Ľ�Ԫ��
						leftMoney = reqiureMoneyToday - payMoney
						if (leftMoney < 0) then
							leftMoney = 0
						end
					end
					
					---------------------------------------
					--�����콱�ĵ�λ�Ƿ���Ч
					if (rewardIdx >= 1) and (rewardIdx <= progressMax) then
						--�����콱�ĵ�λ�Ƿ���ɻ
						if (tFinishState[rewardIdx] == 1) then
							--�����콱�ĵ�λ�Ƿ���ȡ����
							if (tRewardState[rewardIdx] == 0) then
								--��Ǵ��콱�ĵ�λ����ȡ
								--���»����
								local strNewLv = "lv0" .. rewardIdx
								if (errQuery == 0) then
									--�޸Ļ����
									local sUpdate = string.format("update `activity_check` set `%s` = %d, `time` = now() where `aid` = %d and `uid` = %d and `rid` = %d",strNewLv,1,self._aid,self._uid,self._rid)
									xlDb_Execute(sUpdate)
								else
									--�����»����
									local sInsert = string.format("insert into `activity_check`(`aid`, `uid`, `rid`, `%s`) values (%d, %d, %d, %d)",strNewLv,self._aid,self._uid,self._rid,1)
									xlDb_Execute(sInsert)
								end
								
								--����
								--���뽱����ֻ����һ������
								local id = tPrize[rewardIdx].prize[1].id
								local detail = tPrize[rewardIdx].prize[1].detail
								--print(rewardIdx, id, detail)
								
								--����
								local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",self._uid,id,detail,0,self._aid)
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
								
								--�����ɹ�
								result = 1
							else
								--(-6:�콱��λ��������ȡ)
								result = -6
							end
						else
							--(-5:�콱��λ����δ���)
							result = -5
						end
					else
						--(-4:��Ч���콱��λ)
						result = -4
					end
				else
					--(-3:��Ч��������)
					result = -3
				end
			else
				--(-2:��Ч�Ļ����)
				result = -2
			end
		else
			--(-1:��Ч�Ļid)
			result = -1
		end
		
		local cmd = tostring(self._aid) .. ";" .. tostring(ActivitySevenDayPay.ACTIVITY_ID) .. ";" .. tostring(result) .. ";"
					.. tostring(rewardIdx) .. ";" .. tostring(progress) .. ";" .. tostring(prizeType) .. ";" .. tostring(prizeIdx) .. ";"
					.. strPrizeCmd
		return cmd
	end
	
return ActivitySevenDayPay