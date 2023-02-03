--���������ǩ���������
local ActivitySignIn = class("ActivitySignIn")
	--ǩ���id
	ActivitySignIn.ACTIVITY_ID = 10022
	
	--���캯��
	function ActivitySignIn:ctor()
		self._uid = -1
		self._rid = -1
		self._aid = -1
		self._channelId = -1
		
		return self
	end
	
	--��ʼ��
	function ActivitySignIn:Init(uid, rid, aid, channelId)
		self._uid = uid
		self._rid = rid
		self._aid = aid
		self._channelId = channelId
		
		return self
	end
	
	--��ѯǩ�����״̬
	function ActivitySignIn:QueryFinishState()
		local result = 0 --�Ƿ��ǩ��
		local progress = 0 --��ǩ���Ľ���
		local progressMax = 0 --ǩ���������ֵ
		local progressFinishDay = 0 --��ǩ������
		local buyFlags = {} --�ػݹ�����
		
		--��ѯ�˻�Ƿ���������ſ���
		local sQuery = string.format("SELECT `type`, `channel`, `prize` from `activity_template` where `aid` = %d", self._aid)
		local err, pType, strChannel, szPrize = xlDb_Query(sQuery)
		--print("��ѯ�˻�Ƿ���������ſ���:","err=", err, "pType=", pType, "strChannel=", strChannel)
		
		if (err == 0) then
			if (pType == ActivitySignIn.ACTIVITY_ID) then --����ǩ���
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
					if (type(szPrize) == "string") then
						szPrize = "{" .. szPrize .. "}"
						local tmp = "local prize = " .. szPrize .. " return prize"
						local prize = assert(loadstring(tmp))()
						progressMax = #prize
					end
					--print("����ܽ���=", progressMax)
					
					--��ѯ�˻��һ����ɵĽ��Ⱥ�����
					local sQuery = string.format("SELECT `level`, `lv01`, `lv02`, `lv03`, `lv04`, `lv05`, `lv06`, `lv07`, `lv08`, `lv09`, `lv10`, `lv11`, `lv12`, `lv13`, `lv14`, `time` from `activity_check` where `uid` = %d and `aid`= %d limit 1", self._uid, self._aid)
					local err, level, lv01, lv02, lv03, lv04, lv05, lv06, lv07, lv08, lv09, lv10, lv11, lv12, lv13, lv14, strTime = xlDb_Query(sQuery)
					--print("��ѯ�˻��һ����ɵĽ��Ⱥ�����:", "err=", err, "level=", level, lv01, lv02, lv03, lv04, lv05, lv06, lv07, lv08, lv09, lv10, lv11, lv12, lv13, lv14, "time=", strTime)
					
					if (err == 0) then
						--ת��Ϊ�������ϴβ���ʱ���0�����ʱ���
						local nTimestamp = hApi.GetNewDate(strTime)
						local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --ת�ַ���(������)
						local strNewdate = strDatestampYMD .. " 00:00:00"
						local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1)
						--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
						
						--print("strNewdate=", strNewdate)
						--print("nTimestampTodayZero=", nTimestampTodayZero)
						--print("nTimestampTomorrowZero=", nTimestampTomorrowZero)
						
						--��ǩ������
						progressFinishDay = level
						
						--����ʱ���
						local nTimestampNow = os.time()
						--print("nTimestampNow=", nTimestampNow)
						
						--��������Ч����
						--if (nTimestampNow >= nTimestampTodayZero) and (nTimestampNow < nTimestampTomorrowZero) then
						if (nTimestampNow >= nTimestampTodayZero) then
							--print("��������Ч����")
							
							--����δ��ɣ���ǩ��
							if (level < progressMax) then
								result = 1
								progress = level + 1
							end
						end
						
						--�����Щ�����ѹ����ػ����
						if (lv01 > 0) then
							buyFlags[#buyFlags+1] = lv01
						end
						if (lv02 > 0) then
							buyFlags[#buyFlags+1] = lv02
						end
						if (lv03 > 0) then
							buyFlags[#buyFlags+1] = lv03
						end
						if (lv04 > 0) then
							buyFlags[#buyFlags+1] = lv04
						end
						if (lv05 > 0) then
							buyFlags[#buyFlags+1] = lv05
						end
						if (lv06 > 0) then
							buyFlags[#buyFlags+1] = lv06
						end
						if (lv07 > 0) then
							buyFlags[#buyFlags+1] = lv07
						end
						if (lv08 > 0) then
							buyFlags[#buyFlags+1] = lv08
						end
						if (lv09 > 0) then
							buyFlags[#buyFlags+1] = lv09
						end
						if (lv10 > 0) then
							buyFlags[#buyFlags+1] = lv10
						end
						if (lv11 > 0) then
							buyFlags[#buyFlags+1] = lv11
						end
						if (lv12 > 0) then
							buyFlags[#buyFlags+1] = lv12
						end
						if (lv13 > 0) then
							buyFlags[#buyFlags+1] = lv13
						end
						if (lv14 > 0) then
							buyFlags[#buyFlags+1] = lv14
						end
					elseif (err == 4) then --û�м�¼������Ϊ0
						--print("û�м�¼������Ϊ0����ǩ��")
						
						--��ǩ��
						result = 1
						progress = 1
					end
				end
			end
		end
		
		local strBuyStr = ""
		for i = 1, #buyFlags, 1 do
			strBuyStr = strBuyStr .. tostring(buyFlags[i]) .. ":"
		end
		local cmd = tostring(self._aid) .. ";" .. tostring(pType) .. ";" .. tostring(result) .. ";" .. tostring(progress) .. ";" .. tostring(progressMax) .. ";" .. tostring(progressFinishDay) .. ";" .. tostring(#buyFlags) .. ";" .. strBuyStr .. ";"
		--print(cmd)
		return cmd
	end
	
	--��ҽ���ǩ��
	function ActivitySignIn:TodaySingIn(nProgress)
		local result = 0 --�Ƿ��ǩ��
		local progress = 0 --��ǩ���Ľ���
		local progressMax = 0 --ǩ���������ֵ
		local info = "" --���������Ϣ
		local prizeId = 0 --����id
		local prizeType = 0 --��������
		local prizeContent = "" --��������
		
		--��ѯ�˻�Ƿ���������ſ���
		local sQuery = string.format("SELECT `type`, `channel`, `prize` from `activity_template` where `aid`= %d", self._aid)
		local err, pType, strChannel, szPrize = xlDb_Query(sQuery)
		
		if (err == 0) then
			if (pType == ActivitySignIn.ACTIVITY_ID) then --����ǩ���
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
				
				--���Ч��������
				if bChannelValid then
					--����ܽ���
					local prize = {}
					if (type(szPrize) == "string") then
						szPrize = "{" .. szPrize .. "}"
						local tmp = "local prize = " .. szPrize .. " return prize"
						prize = assert(loadstring(tmp))()
						progressMax = #prize
					end
					
					--��ѯ�˻��һ����ɵĽ��Ⱥ�����
					local sQuery = string.format("SELECT `level`, `time` from `activity_check` where `uid` = %d and `aid`= %d limit 1", self._uid, self._aid)
					local errQuery, level, strTime = xlDb_Query(sQuery)
					
					if (errQuery == 0) then
						--ת��Ϊ�������ϴβ���ʱ���0�����ʱ���
						local nTimestamp = hApi.GetNewDate(strTime)
						local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --ת�ַ���(������)
						local strNewdate = strDatestampYMD .. " 00:00:00"
						local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1)
						--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
						
						--����ʱ���
						local nTimestampNow = os.time()
						
						--��������Ч����
						--if (nTimestampNow >= nTimestampTodayZero) and (nTimestampNow < nTimestampTomorrowZero) then
						if (nTimestampNow >= nTimestampTodayZero) then
							--����δ��ɣ���ǩ��
							if (level < progressMax) then
								result = 1
								progress = level + 1
							end
						end
					elseif (errQuery == 4) then --û�м�¼������Ϊ0
						--��ǩ��
						result = 1
						progress = 1
					end
					
					if (result == 1) then --��ǩ��
						if (progress == nProgress) then
							--���뽱����ֻ����һ������
							local tPrize = prize[progress].prize
							local id = tPrize[1].id
							local detail = tPrize[1].detail
							local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",self._uid,id,detail,0,self._aid)
							xlDb_Execute(sInsert)
							
							--����id
							local err1, pid = xlDb_Query("select last_insert_id()")
							if (err1 == 0) then
								--�洢������Ϣ
								prizeId = pid --����id
								prizeType = id --��������
								--prizeContent = detail --��������
								
								--����������
								--Ԥ���������ֱ�ӿ����ҵĽ��������ò�ͬ�Ľӿ�
								local fromIdx = 2
								if (prizeType == 20032) then--ֱ�ӿ�����
									prizeContent = hApi.GetRewardInPrize_OpenChest(self._uid, self._rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_SINGINDRAW"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_SINGINDRAW)
								else
									prizeContent = hApi.GetRewardInPrize(self._uid, self._rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_SINGINREWARD"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_SINGINREWARD)
								end
								
								--���»����
								if (errQuery == 0) then --���ڽ���
									--�޸Ļ����
									local sUpdate = string.format("update `activity_check` set `rid` = %d, `level` = %d, `time` = now() where `aid` = %d and `uid` = %d",self._rid,progress,self._aid,self._uid)
									xlDb_Execute(sUpdate)
								elseif (errQuery == 4) then --û�м�¼������Ϊ0
									--�����»����
									local sInsert = string.format("insert into `activity_check`(`aid`, `uid`, `rid`, `level`) values (%d,%d,%d,%d)",self._aid,self._uid,self._rid,progress)
									xlDb_Execute(sInsert)
								end
								
								result = 1
								info = "�����ɹ�"
							else
								result = -6
								info = "���뽱��ʧ��"
							end
						else
							result = -5
							info = "��Ч��ǩ������"
						end
					else
						result = -4
						info = "24Сʱ�ڲ����ظ�ǩ��"
					end
				else
					result = -3
					info = "��Ч��������"
				end
			else
				result = -2
				info = "��Ч�Ļ����"
			end
		else
			result = -1
			info = "��ѯʧ��"
		end
		
		local cmd = tostring(self._aid) .. ";" .. tostring(pType) .. ";" .. tostring(result) .. ";" .. tostring(progress) .. ";" .. tostring(progressMax)
						 .. ";" .. tostring(info) .. ";" .. tostring(prizeType) .. ";" .. tostring(prizeContent)
		return cmd
	end
	
	--��ҹ����ػ����
	function ActivitySignIn:BuyGift(nProgress)
		local result = 0 --�Ƿ���ɹ�
		local progress = 0 --��ǩ���Ľ���
		local progressMax = 0 --ǩ���������ֵ
		local progressFinishDay = 0 --��ǩ������
		local info = "" --���������Ϣ
		local prizeId = 0 --����id
		local prizeType = 0 --��������
		local prizeContent = "" --��������
		local buyFlags = {} --�ػݹ�����
		local costJifen = 0 --���ĵĻ���
		local cosrRmb = 0 --���ĵ���Ϸ��
		
		--��ѯ�˻�Ƿ���������ſ���
		local sQuery = string.format("SELECT `type`, `channel`, `prize` from `activity_template` where `aid`= %d", self._aid)
		local err, pType, strChannel, szPrize = xlDb_Query(sQuery)
		
		if (err == 0) then
			if (pType == ActivitySignIn.ACTIVITY_ID) then --����ǩ���
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
				
				--���Ч��������
				if bChannelValid then
					--����ܽ���
					local prize = {}
					if (type(szPrize) == "string") then
						szPrize = "{" .. szPrize .. "}"
						local tmp = "local prize = " .. szPrize .. " return prize"
						prize = assert(loadstring(tmp))()
						progressMax = #prize
					end
					
					--��ѯ�˻��һ����ɵĽ��Ⱥ�����
					local sQuery = string.format("SELECT `level`, `lv01`, `lv02`, `lv03`, `lv04`, `lv05`, `lv06`, `lv07`, `lv08`, `lv09`, `lv10`, `lv11`, `lv12`, `lv13`, `lv14`, `time` from `activity_check` where `uid` = %d and `aid`= %d limit 1", self._uid, self._aid)
					local errQuery, level, lv01, lv02, lv03, lv04, lv05, lv06, lv07, lv08, lv09, lv10, lv11, lv12, lv13, lv14, strTime = xlDb_Query(sQuery)
					
					if (errQuery == 0) then
						--ת��Ϊ�������ϴβ���ʱ���0�����ʱ���
						local nTimestamp = hApi.GetNewDate(strTime)
						local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --ת�ַ���(������)
						local strNewdate = strDatestampYMD .. " 00:00:00"
						local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1)
						--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
						
						--����ʱ���
						local nTimestampNow = os.time()
						
						--��ǩ������
						progressFinishDay = level
						
						--��������Ч����
						--if (nTimestampNow >= nTimestampTodayZero) and (nTimestampNow < nTimestampTomorrowZero) then
						if (nTimestampNow >= nTimestampTodayZero) then
							--����δ��ɣ���ǩ��
							if (level < progressMax) then
								--result = 1
								progress = level + 1
							end
						end
						
						--�����Щ�����ѹ����ػ����
						if (lv01 > 0) then
							buyFlags[#buyFlags+1] = lv01
						end
						if (lv02 > 0) then
							buyFlags[#buyFlags+1] = lv02
						end
						if (lv03 > 0) then
							buyFlags[#buyFlags+1] = lv03
						end
						if (lv04 > 0) then
							buyFlags[#buyFlags+1] = lv04
						end
						if (lv05 > 0) then
							buyFlags[#buyFlags+1] = lv05
						end
						if (lv06 > 0) then
							buyFlags[#buyFlags+1] = lv06
						end
						if (lv07 > 0) then
							buyFlags[#buyFlags+1] = lv07
						end
						if (lv08 > 0) then
							buyFlags[#buyFlags+1] = lv08
						end
						if (lv09 > 0) then
							buyFlags[#buyFlags+1] = lv09
						end
						if (lv10 > 0) then
							buyFlags[#buyFlags+1] = lv10
						end
						if (lv11 > 0) then
							buyFlags[#buyFlags+1] = lv11
						end
						if (lv12 > 0) then
							buyFlags[#buyFlags+1] = lv12
						end
						if (lv13 > 0) then
							buyFlags[#buyFlags+1] = lv13
						end
						if (lv14 > 0) then
							buyFlags[#buyFlags+1] = lv14
						end
					elseif (errQuery == 4) then --û�м�¼������Ϊ0
						--��ǩ��
						--result = 1
						progress = 1
					end
					
					--�������������С�ڵ��ڿ�ǩ��������������ǩ������
					if (nProgress <= progress) or (nProgress <= progressFinishDay) then
						--�����ػ������
						local tBuy = prize[nProgress].buy or {}
						local shopItemId = tBuy.shop or 0 --��Ʒid
						
						--���ڿɹ�����ػ����
						if (shopItemId > 0) then
							local id = tBuy[1].id
							local detail = tBuy[1].detail
						
							--��������Ƿ��ѹ����
							local buyFlag = 0
							for i = 1, #buyFlags, 1 do
								if (buyFlags[i] == nProgress) then --�ҵ���
									buyFlag = 1
									break
								end
							end
							
							--��δ��������ػ����
							if (buyFlag == 0) then
								local tabShopItem = hVar.tab_shopitem[shopItemId] or {}
								local itemId = tabShopItem.itemID or 0
								local scoreCost = tabShopItem.score or 0
								local rmbCost = tabShopItem.rmb or 0
								
								costJifen = scoreCost
								cosrRmb = rmbCost
								
								--���Կ۳���Ϸ��
								local bSuccess, orderId = hGlobal.userCoinMgr:DBUserPurchase(self._uid, self._rid, itemId, 1, rmbCost, scoreCost, detail)
								if bSuccess then
									--����
									local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",self._uid,id,detail,0,self._aid)
									xlDb_Execute(sInsert)
									
									--����id
									local err1, pid = xlDb_Query("select last_insert_id()")
									if (err1 == 0) then
										--�洢������Ϣ
										prizeId = pid --����id
										prizeType = id --��������
										--prizeContent = detail --��������
										
										--����������
										--Ԥ���������ֱ�ӿ����ҵĽ��������ò�ͬ�Ľӿ�
										local fromIdx = 2
										if (prizeType == 20032) then--ֱ�ӿ�����
											prizeContent = hApi.GetRewardInPrize_OpenChest(self._uid, self._rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_SINGINDRAW"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_SINGINDRAW)
										else
											prizeContent = hApi.GetRewardInPrize(self._uid, self._rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_SINGINREWARD"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_SINGINREWARD)
										end
										
										--�Ҳ��빺���ǵĿ�λ
										local strLvPos = "lv01"
										if (lv01 == 0) then
											strLvPos = "lv01"
										elseif (lv02 == 0) then
											strLvPos = "lv02"
										elseif (lv03 == 0) then
											strLvPos = "lv03"
										elseif (lv04 == 0) then
											strLvPos = "lv04"
										elseif (lv05 == 0) then
											strLvPos = "lv05"
										elseif (lv06 == 0) then
											strLvPos = "lv06"
										elseif (lv07 == 0) then
											strLvPos = "lv07"
										elseif (lv08 == 0) then
											strLvPos = "lv08"
										elseif (lv09 == 0) then
											strLvPos = "lv09"
										elseif (lv10 == 0) then
											strLvPos = "lv10"
										elseif (lv11 == 0) then
											strLvPos = "lv11"
										elseif (lv12 == 0) then
											strLvPos = "lv12"
										elseif (lv13 == 0) then
											strLvPos = "lv13"
										elseif (lv14 == 0) then
											strLvPos = "lv14"
										end
										
										--���»����
										if (errQuery == 0) then --���ڽ���
											--�޸Ļ����
											local sUpdate = string.format("update `activity_check` set `rid` = %d, `%s` = %d, `time` = '%s' where `aid` = %d and `uid` = %d", self._rid, strLvPos, nProgress, strTime, self._aid, self._uid)
											xlDb_Execute(sUpdate)
										elseif (errQuery == 4) then --û�м�¼������Ϊ0
											--�����»����(�������Ϊ����)
											local nTimestampNow = os.time()
											local sTimeStampNow = os.date("%Y-%m-%d %H:%M:%S", nTimestampNow)
											local nTimestampYesterday = hApi.GetNewDate(sTimeStampNow, "DAY", -1)
											local sTimeStampYesterday = os.date("%Y-%m-%d %H:%M:%S", nTimestampYesterday)
											local sInsert = string.format("insert into `activity_check`(`aid`, `uid`, `rid`, `level`, `%s`, `time`) values (%d, %d, %d, %d, %d, '%s')", strLvPos, self._aid, self._uid, self._rid, 0, nProgress, sTimeStampYesterday)
											xlDb_Execute(sInsert)
										end
										
										--��ӹ���������
										buyFlags[#buyFlags+1] = nProgress
										
										result = 1
										info = "�����ɹ�"
									else
										result = -8
										info = "���뽱��ʧ��"
									end
								else
									result = -7
									info = "��Ϸ�Ҳ���"
								end
							else
								result = -6
								info = "���ѹ�������ػ����"
							end
						else
							result = -5
							info = "��Ч���ػ����"
						end
					else
						result = -4
						info = "��δ�����ػ����"
					end
				else
					result = -3
					info = "��Ч��������"
				end
			else
				result = -2
				info = "��Ч�Ļ����"
			end
		else
			result = -1
			info = "��ѯʧ��"
		end
		
		local strBuyStr = ""
		for i = 1, #buyFlags, 1 do
			strBuyStr = strBuyStr .. tostring(buyFlags[i]) .. ":"
		end
		local cmd = tostring(self._aid) .. ";" .. tostring(pType) .. ";" .. tostring(result) .. ";" .. tostring(progress) .. ";" .. tostring(progressMax) .. ";" .. tostring(progressFinishDay)
						  .. ";" .. tostring(nProgress) .. ";" .. tostring(costJifen) .. ";" .. tostring(cosrRmb) .. ";" .. tostring(#buyFlags)
						  .. ";".. tostring(strBuyStr) .. ";" .. tostring(info) .. ";" .. tostring(prizeType) .. ";" .. tostring(prizeContent)
		return cmd
	end
	
return ActivitySignIn