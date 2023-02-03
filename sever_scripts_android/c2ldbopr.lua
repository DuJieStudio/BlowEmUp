hHandler.C2L_DB_OPR = {}
local __Handler = hHandler.C2L_DB_OPR
--ˢ�·������ű�
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_HOTFIX] = function(udbid, rid, msgId, tCmd)
	
end

--�����ѯ�������� --todo protocol
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_QUEST] = function(udbid, rid, msgId, tCmd)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_QUEST 1 \n")
	--Э����
	local roleId = tonumber(tCmd[1]) or 0
	local stageSchedule = tonumber(tCmd[2]) or 0
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_QUEST 11 roleId:",roleId,type(roleId))

	--��ɫid�Ƿ���ֱ���˳�
	if roleId <= 0 then
		local info = string.format("[require_quest] roleId is invalid. uid = %s, roleId = %s", tostring(udbid), tostring(roleId))
		--xlLG(Type_Def_Log.ELL_ERROR, info)
		--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_QUEST 2")
		return
	end
	
	--��ȡ�ҵ�����
	local queryFlag,sTimeStamp,tQuestMy = hApi.GetMyDailyQuest(udbid, roleId, stageSchedule)
	if queryFlag then
		--���ݷ���
		local sL2CQuest = hApi.GetL2CQuestCmd(tQuestMy)
		if sL2CQuest ~= "" then
			local sL2CCmd = "qt:"..sTimeStamp..";"..sL2CQuest
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST,sL2CCmd)
		end
	end
end

--�����ѯ��������test --todo protocol
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_QUEST_TEST] = function(udbid, rid, msgId, tCmd)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_QUEST 1 \n")
	--Э����
	local roleId = tonumber(tCmd[1]) or 0
	local stageSchedule = tonumber(tCmd[2]) or 0
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_QUEST 11 roleId:",roleId,type(roleId))

	--��ɫid�Ƿ���ֱ���˳�
	if roleId <= 0 then
		local info = string.format("[require_quest] roleId is invalid. uid = %s, roleId = %s", tostring(udbid), tostring(roleId))
		--xlLG(Type_Def_Log.ELL_ERROR, info)
		--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_QUEST 2")
		return
	end
	
	--��ȡ�ҵ�����
	local queryFlag,sTimeStamp,tQuestMy = hApi.GetMyDailyQuest_Test(udbid, roleId, stageSchedule)
	if queryFlag then
		--���ݷ���
		local sL2CQuest = hApi.GetL2CQuestCmd(tQuestMy)
		if sL2CQuest ~= "" then
			local sL2CCmd = "qt:"..sTimeStamp..";"..sL2CQuest
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST,sL2CCmd)
		end
	end
end

--�����������״̬����
__Handler[hVar.DB_OPR_TYPE.C2L_UPDATE_QUEST] = function(udbid, rid, msgId, tCmd, sCmd)
	--Э����
	local _,_,roleId = string.find(sCmd, "rid:(%d+);")
	roleId = tonumber(roleId)
	local _,_,yy, mm, dd = string.find(sCmd, "qt:(%d+)-(%d+)-(%d+);")
	local sTimeStampC = ""
	if yy then
		sTimeStampC = tostring(yy).."-".. tostring(mm).."-".. tostring(dd)
	end
	
	local stageSchedule = string.find(sCmd, "ss:(%d+);")
	stageSchedule = tonumber(stageSchedule) or 0
	
	--��ɫid�Ƿ���ֱ���˳�
	if roleId <= 0 then
		local info = string.format("[require_quest] roleId is invalid. uid = %s, roleId = %s", tostring(udbid), tostring(roleId))
		xlLG(3, info)
		return
	end
	
	--����Э���е�����
	local tQuestClient = hApi.GetParamByCmd("qst:", sCmd)
	--��ȡ�ҵ�����
	local queryFlag,sTimeStamp,tQuestMy = hApi.GetMyDailyQuest(udbid, roleId, stageSchedule)
	if queryFlag and tQuestMy and #tQuestMy > 0 then
		--print("��ȡ�ҵ�����", queryFlag, #tQuestMy)
		local nTimeStamp = hApi.Date2Num(sTimeStamp)
		local nTimeStampC = hApi.Date2Num(sTimeStampC)
		--print("nTimeStampC", nTimeStampC, "nTimeStamp",nTimeStamp )
		if nTimeStampC ~= 0 and nTimeStampC == nTimeStamp then
			local saveFlag = false
			--��������״̬
			for i = 1,(math.min(#tQuestClient, 3)) do
				local tQC = tQuestClient[i]		--�ͻ�����������
				local idxC = tonumber(tQC[1]) or 0
				local idC = tonumber(tQC[2]) or 0
				local numC = tonumber(tQC[3]) or 0
				local paramC = tonumber(tQC[4]) or 0
				--print("idxC", idxC, "idC",idC , "numC",numC, "paramC",paramC)
				local tQM = tQuestMy[idxC]		--db�е���������
				--���db�д��ڸ����񣬲��Ҹ�����������id��ͬ
				--print("tQM[1]", tQM[1])
				if tQM and idC == tQM[1] then
					local id = tQM[1]
					local state = tQM[2]
					local tabQ = hVar.tab_quest[tQM[1]]
					--print("id", id,"state", state)
					if tabQ and tabQ.conditions and state == 0 then
						local flag = false
						local num = 1
						--Ŀǰֻ֧��һ�����������Ա���һ��ֱ��break
						for k, v in pairs(tabQ.conditions) do
							--print("k", k)
							if k == hVar.MEDAL_TYPE.map or k == hVar.MEDAL_TYPE.map then
								if numC >= 0 then
									flag = true
								end
							elseif k == hVar.MEDAL_TYPE.mapCondition or k == hVar.MEDAL_TYPE.chapterCondition then
								local tV = hApi.Split(v,"|")
								local tInfo = hApi.Split(tV[1] or "", ":")
								if numC >= (tonumber(tInfo[3]) or 1) then
									flag = true
									num = (tInfo[3] or 1)
								end
							elseif k == hVar.MEDAL_TYPE.killUT or k == hVar.MEDAL_TYPE.buildTT or k == hVar.MEDAL_TYPE.killUS or k == hVar.MEDAL_TYPE.buyItem then
								if numC >= (v[2] or 1) then
									flag = true
									num = (v[2] or 1)
								end
							else
								if numC >= (v or 1) then
									flag = true
									num = (v or 1)
								end
							end
							break
						end
						--��������������������޸�����״̬
						if flag then
							 tQM[2] = 1
							 tQM[3] = num
							 saveFlag = true
							-- print("��������������������޸�����״̬", saveFlag)
						end
					end
				end
			end
			--�����������������״̬���豣��
			if saveFlag then
				hApi.SavePlayerQuest(roleId,tQuestMy,sTimeStamp)
			end
		end
		
		--���ݷ���
		local sL2CQuest = hApi.GetL2CQuestCmd(tQuestMy)
		if sL2CQuest ~= "" then
			local sL2CCmd = "qt:"..sTimeStamp..";"..sL2CQuest
			--print("���ݷ���", sL2CCmd)
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST,sL2CCmd)
		end
	end
end

--ȷ����������ȡ --todo protocol
__Handler[hVar.DB_OPR_TYPE.C2L_CONFIRM_QUEST] = function(udbid, rid, msgId, tCmd, sCmd)
	local _,_,roleId = string.find(sCmd, "rid:(%d+);")
	local uid = udbid
	roleId = tonumber(roleId)
	
	local sTimeStampC = ""
	local _,_,yy, mm, dd = string.find(sCmd, "qt:(%d+)-(%d+)-(%d+);")
	if yy then
		sTimeStampC = tostring(yy).."-".. tostring(mm).."-".. tostring(dd)
	end

	local stageSchedule = string.find(sCmd, "ss:(%d+);")
	stageSchedule = tonumber(stageSchedule) or 0

	local _,_,idxC,idC = string.find(sCmd, "qst:(%d+):(%d+);")
	idxC = tonumber(idxC)
	idC = tonumber(idC)

	--��ɫid�Ƿ���ֱ���˳�
	if roleId <= 0 then
		local info = string.format("[require_quest] roleId is invalid. uid = %s, roleId = %s", tostring(udbid), tostring(roleId))
		xlLG(3, info)
		return
	end
	
	--��ȡ�ҵ�����
	local queryFlag,sTimeStamp,tQuestMy = hApi.GetMyDailyQuest(uid, roleId, stageSchedule)
	if queryFlag and tQuestMy and #tQuestMy > 0 then
		local nTimeStamp = hApi.Date2Num(sTimeStamp)
		local nTimeStampC = hApi.Date2Num(sTimeStampC)
		if nTimeStampC ~= 0 and nTimeStampC == nTimeStamp then
			local saveFlag = false

			local tQM = tQuestMy[idxC]		--db�е���������
			--���db�д��ڸ����񣬲��Ҹ�����������id��ͬ
			if tQM and idC == tQM[1] then
				local id = tQM[1]
				local state = tQM[2]
				local tabQ = hVar.tab_quest[tQM[1]]
				if tabQ and state == 1 then
					tQM[2] = 2
					saveFlag = true
				end
			end
			
			--�����������������״̬���豣��
			if saveFlag then
				--��������״̬
				hApi.SavePlayerQuest(roleId,tQuestMy,sTimeStamp)
				
				local reward = hClass.Reward:create():Init()
				for i = 1, 3 do
					if hVar.tab_quest[idC].reward[i] then
						reward:Add(hVar.tab_quest[idC].reward[i])
					end
				end
				
				--��������������Ŀǰֻ������Ϸ�ң�
				--hApi.RewardPreprocessing(uid, rid, reward, maxReward)
				
				--������������������Ŀǰֻ������Ϸ�ң�
				hApi.RewardPreprocessing(uid, roleId, reward,3)
				
				--��������¼������ȡ��־
				local sLog = string.format("%s;%d;%d;%s",sTimeStamp,idxC,idC,reward:ToCmdNoNum())
				local err, prizeId = hApi.InsertPrize(uid, roleId,hVar.REWARD_LOG_TYPE.dailyQuest,sLog,1)
				--print("err", err)
				--print("prizeId", prizeId)
				if err and err == 0 then
					--��ȡ�������ݷ���
					--��ȡ������
					local sQuestReward = hApi.DailyQuestReward2Cmd(hVar.tab_quest[idC])
					local sL2CCmd = string.format("pid:%d;qst:%d:%d%s;",prizeId,idxC,idC,sQuestReward)
					--print("sL2CCmd", sL2CCmd)
					--print("udbid", udbid)
					hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST_REWARD,sL2CCmd)
				end
			end
		end

		--���ݷ���
		local sL2CQuest = hApi.GetL2CQuestCmd(tQuestMy)
		if sL2CQuest ~= "" then
			local sL2CCmd = "qt:"..sTimeStamp..";"..sL2CQuest
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST,sL2CCmd)
		end
	end
end


--��ȡϵͳʱ��
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_SYSTIME] = function(udbid, rid, msgId, tCmd)
	--print("��ȡϵͳʱ��")
	local sQuery = "SELECT NOW()"
	local err,sCurTime = xlDb_Query(sQuery)
	if err == 0 then
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_SYSTIME,sCurTime)
	end
end

--�������汾������Ϣ
__Handler[hVar.DB_OPR_TYPE.C2L_GET_VER_INFO] = function(udbid, rid, msgId, tCmd)
	
	local shop_control = hVar.shop_control
	local version_control = hVar.version_control

	local sql = string.format("SELECT bTester FROM t_user where uid=%d",udbid)
	local err,bTester = xlDb_Query(sql)
	if err == 0 then
		if bTester > 0 then
			version_control = hVar.debug_version_control
		end
	else
	end

	local sCmd = tostring(shop_control) .. ";" .. tostring(version_control)
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST_VER_INFO,sCmd)
end

--��ȡ���丽��

--��ȡ���丽��
__Handler[hVar.DB_OPR_TYPE.C2L_GET_MAIL_ANNEX] = function(udbid, rid, msgId, tCmd)
	--print("��ȡ���丽��", udbid, rid, msgId, tCmd)
	local cRId = tonumber(tCmd[1])
	local prizeId = tonumber(tCmd[2])
	local prizeType = tonumber(tCmd[3])
	--print("��ȡ���丽��", udbid, rid, msgId, "tCmd=", cRId, prizeId, prizeType)
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		if prizeType == hVar.REWARD_LOG_TYPE.billboard then
			local fromIdx = 4
			local sL2CCmd
			if hGlobal.bbMgr then
				--sL2CCmd =  hGlobal.bbMgr:DBGetMailAnnex(udbid, cRId, prizeId)
				sL2CCmd =  hApi.GetRewardInPrize(udbid, rid,prizeId,fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
				hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST_MAIL_ANNEX,sL2CCmd)
			end
		elseif (prizeType == hVar.REWARD_LOG_TYPE.tier30) then --1035 �׳�198Ԫ��
			local fromIdx = 1
			local sL2CCmd = hApi.GetRewardInPrize(udbid,cRId,prizeId,fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_PURCHASE198"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_PURCHASE198)
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST_MAIL_ANNEX, sL2CCmd)
		elseif (prizeType == hVar.REWARD_LOG_TYPE.tier40) then --1036 �׳�388Ԫ��
			local fromIdx = 1
			local sL2CCmd = hApi.GetRewardInPrize(udbid,cRId,prizeId,fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_PURCHASE388"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_PURCHASE388)
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST_MAIL_ANNEX, sL2CCmd)
		elseif (prizeType == 1030) or (prizeType == 1031) or (prizeType == 1032) or (prizeType == 1033) or (prizeType == 1034) then --1030~1034 �׳�6,18,68,98Ԫ��
			local sL2CCmd = hApi.GetRewardInPrize_InAppOld(udbid,cRId,prizeId)
			--print("sL2CCmd=", sL2CCmd)
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST_MAIL_ANNEX,sL2CCmd)
		elseif (prizeType == 4) or (prizeType == 9) or (prizeType == 18) or (prizeType == 100) then --4,9,19,100 ��ҳ��������,ÿ�ս���,���۽���,�������
			local sL2CCmd = hApi.GetRewardInPrize_InAppOld(udbid,cRId,prizeId)
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST_MAIL_ANNEX,sL2CCmd)
		elseif (prizeType == 1039) or (prizeType == 1060) then --1039,1060 ��ҳ��������
			local sL2CCmd = hApi.GetRewardInPrize_ScoreOld(udbid,cRId,prizeId)
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST_MAIL_ANNEX,sL2CCmd)
		elseif (prizeType >= hVar.REWARD_LOG_TYPE.rewardMail and prizeType <= hVar.REWARD_LOG_TYPE.vip7Above) or (prizeType == hVar.REWARD_LOG_TYPE.tier40) or ((prizeType >= hVar.REWARD_LOG_TYPE.customRewardBegin and prizeType <= hVar.REWARD_LOG_TYPE.customRewardEnd)) then		--������ͨ�����̣���Ϊ���޶���ģ�飬����û��д��ĳ���߼����������
			--fromIdx:�ӵڼ���:(ð��)��ʼ�㽱��
			local fromIdx = 1
			if (prizeType >= hVar.REWARD_LOG_TYPE.customRewardBegin and prizeType <= hVar.REWARD_LOG_TYPE.customRewardEnd) then
				fromIdx = 1
			elseif prizeType == hVar.REWARD_LOG_TYPE.billboard then
				fromIdx = 4
			elseif prizeType == hVar.REWARD_LOG_TYPE.activity or prizeType == hVar.REWARD_LOG_TYPE.activityEx or (prizeType >= hVar.REWARD_LOG_TYPE.vip5 and prizeType <= hVar.REWARD_LOG_TYPE.vip7Above) then
				fromIdx = 2
			--elseif prizeType == hVar.REWARD_LOG_TYPE.activityDrawCard then --20028: �������鿨�ཱ��
			--	fromIdx = 2
			--elseif prizeType == hVar.REWARD_LOG_TYPE.billboardEndless then --20029: �޾���ͼ���н���
			--	fromIdx = 6
			--elseif prizeType == hVar.REWARD_LOG_TYPE.billboardEndless then --20030: ħ������ÿ�����ͽ�����
			--	fromIdx = 4
			--elseif prizeType == hVar.REWARD_LOG_TYPE.billboardEndless then --20031: ���б�������ĵĽ���
			--	fromIdx = 3
			--elseif prizeType == hVar.REWARD_LOG_TYPE.activitOpenChest then --20032: ֱ�ӿ����ҵĽ���
			--	fromIdx = 2
			end
			
			--print("fromIdx=", fromIdx)
			local sL2CCmd = hApi.GetRewardInPrize(udbid,cRId,prizeId,fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
			--print("sL2CCmd=", sL2CCmd)
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST_MAIL_ANNEX,sL2CCmd)
		elseif (prizeType == hVar.REWARD_LOG_TYPE.mailTitleMsgNotice) then --20033 ֻ�б�������ģ�û�н���
			local fromIdx = 3
			local sL2CCmd = hApi.GetRewardInPrize(udbid,cRId,prizeId,fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST_MAIL_ANNEX, sL2CCmd)
		elseif (prizeType == hVar.REWARD_LOG_TYPE.pvpRankTitleMsgReward) then --20034 ����������ж�λ����������ĵĽ���
			local fromIdx = 3
			local sL2CCmd = hApi.GetRewardInPrize(udbid,cRId,prizeId,fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST_MAIL_ANNEX, sL2CCmd)
		end
	end
end

--��ȡ�������鿨�����丽��
__Handler[hVar.DB_OPR_TYPE.C2L_GET_MAIL_ANNEX_DRAWCARD] = function(udbid, rid, msgId, tCmd)
	--print("��ȡ�������鿨�����丽��", udbid, rid, msgId, tCmd)
	local cRId = tonumber(tCmd[1])
	local prizeId = tonumber(tCmd[2])
	local prizeType = tonumber(tCmd[3])
	local prizeParam = tCmd[4] or ""
	--print("��ȡ���丽��", udbid, rid, msgId, "tCmd=", cRId, prizeId, prizeType)
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		if (prizeType == hVar.REWARD_LOG_TYPE.activityDrawCard) then --20028: �������鿨�ཱ��
			--print("fromIdx=", fromIdx)
			--fromIdx:�ӵڼ���:(ð��)��ʼ�㽱��
			local fromIdx = 2
			local sL2CCmd = hApi.GetRewardInPrize_DrawCard(udbid, cRId, prizeId, fromIdx, nil, prizeParam)
			--print("sL2CCmd=", sL2CCmd)
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST_MAIL_ANNEX_DRAWCARD, sL2CCmd)
		end
	end
end

--��ȡ������ֱ�ӿ����ҵ����丽��
__Handler[hVar.DB_OPR_TYPE.C2L_GET_MAIL_ANNEX_OPENCHEST] = function(udbid, rid, msgId, tCmd)
	--print("��ȡ������ֱ�ӿ����ҵ����丽��", udbid, rid, msgId, tCmd)
	local cRId = tonumber(tCmd[1])
	local prizeId = tonumber(tCmd[2])
	local prizeType = tonumber(tCmd[3])
	--print("��ȡ������ֱ�ӿ����ҵ����丽��", udbid, rid, msgId, "tCmd=", cRId, prizeId, prizeType)
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		if (prizeType == hVar.REWARD_LOG_TYPE.activitOpenChest) then --20032: ֱ�ӿ����ҽ���
			--print("fromIdx=", fromIdx)
			--fromIdx:�ӵڼ���:(ð��)��ʼ�㽱��
			local fromIdx = 2
			local sL2CCmd = hApi.GetRewardInPrize_OpenChest(udbid, cRId, prizeId, fromIdx, nil)
			--print("sL2CCmd=", sL2CCmd)
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST_MAIL_ANNEX_OPENCHEST, sL2CCmd)
		end
	end
end

--��ȡ�޾���ͼ���丽��
__Handler[hVar.DB_OPR_TYPE.C2L_GET_ENDLESS_REWARD] = function(udbid, rid, msgId, tCmd)
	--print("��ȡ�޾���ͼ���丽��", udbid, rid, msgId, tCmd)
	local cRId = tonumber(tCmd[1])
	local prizeId = tonumber(tCmd[2])
	local prizeType = tonumber(tCmd[3])
	--print("��ȡ�޾���ͼ���丽��", udbid, rid, msgId, "tCmd=", cRId, prizeId, prizeType)
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		if prizeType == hVar.REWARD_LOG_TYPE.billboardEndless then --20029: �޾���ͼ���н���
			local fromIdx = 6
			
			local sL2CCmd = hApi.GetRewardInPrize(udbid,cRId,prizeId,fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_ENDLESSRANKBOARD"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_ENDLESSRANKBOARD)
			--print("sL2CCmd=", sL2CCmd)
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST_MAIL_ANNEX_ENDLESS,sL2CCmd)
		end
	end
end

--��ȡħ������ÿ�����ͽ����丽��
__Handler[hVar.DB_OPR_TYPE.C2L_GETPVEMULTY_REWARD] = function(udbid, rid, msgId, tCmd)
	--print("��ȡħ������ÿ�����ͽ����丽��", udbid, rid, msgId, tCmd)
	local cRId = tonumber(tCmd[1])
	local prizeId = tonumber(tCmd[2])
	local prizeType = tonumber(tCmd[3])
	--print("��ȡħ������ÿ�����ͽ����丽��", udbid, rid, msgId, "tCmd=", cRId, prizeId, prizeType)
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		if prizeType == hVar.REWARD_LOG_TYPE.pveMultyHardwork then --20030: ħ������ÿ�����ͽ�
			local fromIdx = 4
			
			local sL2CCmd = hApi.GetRewardInPrize(udbid,cRId,prizeId,fromIdx)
			--print("sL2CCmd=", sL2CCmd)
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST_MAIL_ANNEX_PVEMULTY,sL2CCmd)
		end
	end
end

--��ȡ�������Ľ������丽��
__Handler[hVar.DB_OPR_TYPE.C2L_GETTITIEMSG_REWARD] = function(udbid, rid, msgId, tCmd)
	--print("��ȡ�������Ľ������丽��", udbid, rid, msgId, tCmd)
	local cRId = tonumber(tCmd[1])
	local prizeId = tonumber(tCmd[2])
	local prizeType = tonumber(tCmd[3])
	--print("��ȡ�������Ľ������丽��", udbid, rid, msgId, "tCmd=", cRId, prizeId, prizeType)
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		--20031: �������Ľ���
		--20037: ���ű���������������
		--20038: ���ű���������һ������
		--20039: ����ά�����б�������ĵĽ���
		--20040: �������б�������ĵĽ���
		--20041: ��л�Ŵ��б�������ĵĽ���
		--20042: �����Ŵ��б�������ĵĽ���
		if (prizeType == hVar.REWARD_LOG_TYPE.mailTitleMsgReward) or (prizeType == hVar.REWARD_LOG_TYPE.groupWeekDonateRank)
		or (prizeType == hVar.REWARD_LOG_TYPE.groupWeekDonateMax) or (prizeType == hVar.REWARD_LOG_TYPE.updateTitleMsgReward)
		or (prizeType == hVar.REWARD_LOG_TYPE.tiliTitleMsgReward) or (prizeType == hVar.REWARD_LOG_TYPE.thankTitleMsgReward)
		or (prizeType == hVar.REWARD_LOG_TYPE.shareTitleMsgReward) then
			local fromIdx = 3
			
			local sL2CCmd = hApi.GetRewardInPrize(udbid,cRId,prizeId,fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAILREAD"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAILREAD)
			--print("sL2CCmd=", sL2CCmd)
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_QUEST_MAIL_ANNEX_TITIEMSG,sL2CCmd)
			
			--�������͵Ľ����������������
			if (prizeType == hVar.REWARD_LOG_TYPE.shareTitleMsgReward) then
				--����ÿ�������£�
				--�������
				local taskType = hVar.TASK_TYPE.TASK_SHARE_COUINT --��������
				local addCount = 1
				local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(udbid, cRId)
				taskMgr:AddTaskFinishCount(taskType, addCount)
			end
		end
	end
end

--��ȡ�������������丽��
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_CHATDRAGON_REWARD] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cRId = tonumber(tCmd[1])
	local prizeId = tonumber(tCmd[2])
	local prizeType = tonumber(tCmd[3])
	--print("��ȡ�������������丽��", udbid, rid, msgId, "tCmd=", cRId, prizeId, prizeType)
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		if prizeType == hVar.REWARD_LOG_TYPE.chatDragonReward then --20035: ����������
			local fromIdx = 4
			
			local sL2CCmd = hApi.GetRewardInPrize(udbid,cRId,prizeId,fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_CHATDRAGON"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_CHATDRAGON)
			--print("sL2CCmd=", sL2CCmd)
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_MAIL_ANNEX_CHATDRAGON_RET,sL2CCmd)
		end
	end
end

--�����ѯ��ҵĵ�ǰ�ƺ�
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_USER_CHAMPION_INFO] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--��ȡ��ҵı߿�ͷ�񡢳ƺ�
		local borderId, iconId, championId, dragonId, headId, lineId = hGlobal.vipMgr:_DBGetRoleBorderConfig(cUId)
		local sL2CCmd = tostring(borderId) .. ";" .. tostring(iconId) .. ";" .. tostring(championId) .. ";" .. tostring(dragonId) .. ";" .. tostring(headId) .. ";" .. tostring(lineId) .. ";"
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_USER_CHAMPION_INFO_RET, sL2CCmd)
	end
end

--��ȡ�¿����¿�ÿ���콱
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_MONTH_CARD] = function(udbid, rid, msgId, tCmd)
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		--����¿����ս�������
		if hClass.MonthCard then
			local montCard = hClass.MonthCard:create("MonthCard"):Init(udbid)
			local sL2CCmd = montCard:CheckTodayMonthCardReward()
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_MONTH_CARD, sL2CCmd)
		end
	end
end

--��ȡָ��logid���޾���ͼǰ10�����
__Handler[hVar.DB_OPR_TYPE.C2L_GET_ENDLESS_RANK_NAME] = function(udbid, rid, msgId, tCmd)
	local cRId = tonumber(tCmd[1])
	local rankId = tonumber(tCmd[2]) or 0
	local logId = tonumber(tCmd[3]) or 0
	
	local result = 0
	local info = ""
	
	--print("hVar.DB_OPR_TYPE.C2L_GET_ENDLESS_RANK_NAME", cRId, prizeId, prizeType, prizeParam)
	local sql = string.format("SELECT `leaderboards_id`, `broadcast_name` FROM `leaderboards_check` WHERE `id` = '%d'",logId)
	local e, rid, broadcastName = xlDb_Query(sql)
	--print("sql:",sql,e,rid,broadcastName)
	if (e == 0) then
		if (rankId == rid) then --��һ��У�飬���а�idһ��
			result = 1
			info = broadcastName
		else
			result = -2 --rid��һ��
		end
	else
		result = -1 --��ѯʧ��
	end
	
	local sL2CCmd = tostring(result) .. ";" .. tostring(rankId) .. ";" .. tostring(logId) .. ";" .. tostring(info)
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_BOARD_ENDLESS_RANK_NAME, sL2CCmd)
end

--�����콱��־ --todo protocol
__Handler[hVar.DB_OPR_TYPE.C2L_UPDATE_REWARD_LOG] = function(udbid, rid, msgId, tCmd, sCmd)
	--Э����
	local _,_,prizeId = string.find(sCmd, "pid:(%d+);")
	prizeId = tonumber(prizeId)
	--local _,_,tag = string.find(sCmd, "rwd:(%s*)")
	hApi.UpdatePrize(prizeId, 2)
end

--������PVP��Ʒ��Ϣ��
--__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_PVP_SHOP_ITEM] = function(connid,roleid,nOpr,sCmd)
--	hApi.xlNet_Send(connid,hVar.PVP_DB_RECV_TYPE.L2C_PVP_SHOP_ITEM, hVar.PVP_SHOPITEM_L2C_TEMP)
--end

--��ȡ���а�ģ�壨��̬tab������������Ϣ��
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_BOARD_TEMPLATE] = function(udbid, rid, msgId, tCmd)
	local cBId = tonumber(tCmd[1])
	local sL2CCmd
	if hGlobal.bbMgr then
		sL2CCmd =  hGlobal.bbMgr:GetBillboardTemplate2Cmd(cBId)
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_BOARD_TEMPLATE,sL2CCmd)
	end
end

--��ȡ���а���Ϣ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_BILLBOARD] = function(udbid, rid, msgId, tCmd)

	local cUId = tonumber(tCmd[1])
	local cRId = tonumber(tCmd[2])
	local cBId = tonumber(tCmd[3])
	
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_BILLBOARD:", sCmd, cUId, cRId, cBId)

	local sL2CCmd
	if hGlobal.bbMgr then
		sL2CCmd =  hGlobal.bbMgr:DBGetBillboard2Cmd(udbid,cRId,cBId)
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_BILLBOARD_INFO,sL2CCmd)
	end
end

--����������а���Ϣ
__Handler[hVar.DB_OPR_TYPE.C2L_UPDATE_BILLBOARD_RANK] = function(udbid, rid, msgId, tCmd)
	
	local cUId = tonumber(tCmd[1])
	local cRId = tonumber(tCmd[2])
	local cBId = tonumber(tCmd[3])
	local cRank = tonumber(tCmd[4])
	local cTimestamp = tCmd[5]
	local sCfg = tCmd[6] --�俨��Ϣ
	
	--print("hVar.DB_OPR_TYPE.C2L_UPDATE_BILLBOARD_RANK:", cUId, cRId, cBId, cRank,cTimestamp, sCfg)
	
	local sL2CCmd
	if hGlobal.bbMgr then
		local localTime = os.time()
		local dbTime = localTime - hVar.DELT_TIME
		local datestamp = hApi.Timestamp2Date(dbTime)
		local cTime = hApi.GetNewDate(cTimestamp)
		--����У��ֵ
		--local ranksum = math.mod(cRank + hApi.GetNewDate(cTimestamp), 9973)
		
		local cDatestamp = hApi.Timestamp2Date(cTime)
		
		--���ʱ��һ�²Ÿ���
		if cDatestamp == datestamp then
			sL2CCmd = hGlobal.bbMgr:DBUpdateUserBillboardData(udbid,cRId,cBId,cRank, sCfg)
			
			--����Թ����а�ͬʱҲ���������������Թ�����
			if (cBId == 1) then
				--����ÿ�������£�
				--����Թ�����
				local taskType = hVar.TASK_TYPE.TASK_RANDOMMAP_STAGE --����Թ�����
				local addCount = cRank
				local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(udbid, cRId)
				taskMgr:AddTaskFinishCount(taskType, addCount)
			elseif (cBId == 2) then
				--����ÿ�������£�
				--ǰ����ز���
				local taskType = hVar.TASK_TYPE.TASK_QSZD_WAVE --ǰ����ز���
				local addCount = cRank
				local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(udbid, cRId)
				taskMgr:AddTaskFinishCount(taskType, addCount)
			end
			
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_BILLBOARD_INFO,sL2CCmd)
		else
			--hApi.xlNet_Send(udbid,hVar.PVP_DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.UPDATE_BILLBOARD_RANK_FAILED))
		end
	end
end

--�޾���ͼ��ʼս������̬tab������������Ϣ��
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_ENDLESS_BEGIN_GAME] = function(udbid, rid, msgId, tCmd)
	local cBId = tonumber(tCmd[1])
	local sL2CCmd
	if hGlobal.bbMgr then
		sL2CCmd =  hGlobal.bbMgr:GetBillboardTemplate2Cmd(cBId)
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_BOARD_ENDLESS_BEGIN_GAME,sL2CCmd)
	end
end

--�ͻ��˲�ѯ���������ǩ����������Ƿ������ȡ����
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_ACTIVITY_TODAY_STATE] = function(udbid, rid, msgId, tCmd)
	local cUId = tonumber(tCmd[1])
	local cRId = tonumber(tCmd[2])
	local cAId = tonumber(tCmd[3]) --�id
	local nChannelId = tonumber(tCmd[4]) --������
	
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		--��ѯ�������ǩ���״̬
		if hClass.ActivitySignIn then
			local signIn = hClass.ActivitySignIn:create("ActivitySignIn"):Init(udbid, rid, cAId, nChannelId)
			local sL2CCmd = signIn:QueryFinishState()
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ACTIVITY_TODAY_STATE, sL2CCmd)
		end
	end
end

--���������ǩ���������ǩ��
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_ACTIVITY_TODAY_SIGNIN] = function(udbid, rid, msgId, tCmd)
	local cUId = tonumber(tCmd[1])
	local cRId = tonumber(tCmd[2])
	local cAId = tonumber(tCmd[3]) --�id
	local nChannelId = tonumber(tCmd[4]) --������
	local nProgress = tonumber(tCmd[5]) --ǩ���Ľ���
	
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		--��ҽ���ǩ��
		if hClass.ActivitySignIn then
			local signIn = hClass.ActivitySignIn:create("ActivitySignIn"):Init(udbid, rid, cAId, nChannelId)
			local sL2CCmd = signIn:TodaySingIn(nProgress)
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ACTIVITY_TODAY_SIGNIN, sL2CCmd)
		end
	end
end

--�޸�����
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_CHANGE_NAME] = function(udbid, rid, msgId, tCmd)
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local cName = tCmd[3]
	local cNameOld = tostring(tCmd[4])
	
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_CHANGE_NAME:",cUId,cRId,cName)
	
	--��Ҹ�������id������
	local itemId = 9922
	local itemCost = 200
	
	local result = 0
	local info = -3
	
	--��ѯ����Ƿ��㹻
	local sQuery = string.format("SELECT gamecoin_online FROM t_user WHERE uid=%d",udbid)
	local err,nMyGameCoin = xlDb_Query(sQuery)
	--print("sQuery:",sQuery,err)
	if err == 0 then
		if nMyGameCoin >= itemCost then
			--��ѯ�����Ƿ��ظ�
			local sql = string.format("SELECT count(*) FROM t_cha WHERE name='%s'",cName)
			local e,count = xlDb_Query(sql)
			--print("sql:",sql,e,count)
			if e == 0 then
				if count <= 0 then
					
					local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
					
					--��Ǯ
					local sUpdate = string.format("UPDATE t_user SET gamecoin_online = gamecoin_online + %d WHERE uid = %d",-itemCost,udbid)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
					
					--������
					--�µĹ����¼���뵽order��
					sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,udbid,cRId,itemId,1,sItemName,itemCost,0,cNameOld .. " -> " .. cName)
					--print("sUpdate2:",sUpdate)
					xlDb_Execute(sUpdate)
					
					--����
					sUpdate = string.format("UPDATE t_cha SET name='%s', nickname='%s' WHERE id = %d",cName,cName,cRId)
					--print("sUpdate3:",sUpdate)
					xlDb_Execute(sUpdate)
					
					sUpdate = string.format("UPDATE cha_dictionary SET name='%s' WHERE id = %d",cName,cRId)
					--print("sUpdate4:",sUpdate)
					xlDb_Execute(sUpdate)
					
					sUpdate = string.format("UPDATE t_pvp_user SET name='%s' WHERE id = %d",cName,cRId)
					--print("sUpdate5:",sUpdate)
					xlDb_Execute(sUpdate)
					
					sUpdate = string.format("UPDATE t_user SET customS1='%s' WHERE uid = %d",cName,udbid)
					--print("sUpdate6:",sUpdate)
					xlDb_Execute(sUpdate)
					
					sUpdate = string.format("UPDATE t_chat_user SET name='%s' WHERE uid = %d",cName,udbid)
					--print("sUpdate7:",sUpdate)
					xlDb_Execute(sUpdate)
					
					--����᳤����
					sUpdate = string.format("UPDATE `novicecamp_list` SET `master_name` = '%s' WHERE `master_uid` = %d", cName, udbid)
					xlDb_Execute(sUpdate)
					
					result = 1
					info = orderId
					
					local err1, orderId = xlDb_Query("select last_insert_id()")
					--print("err1,orderId:",err1,orderId)
					if err1 == 0 then
						info = orderId
					else
					
					end
					
				else
					info = -2 --����
				end
			else
				info = -2 --����
			end
		else
			info = -1 --Ǯ����
		end
	else
		info = -1 --Ǯ����
	end
	
	local sL2CCmd = tostring(result) .. ";" .. tostring(info)
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_CHANGE_NAME,sL2CCmd)
	--print("hApi.xlNet_Send:",sL2CCmd)
end


--��������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_SET_NAME] = function(udbid, rid, msgId, tCmd)
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local cName = tCmd[3]
	local index = tonumber(tCmd[4]) or 1 --�浵������
	local cNameOld = tostring(tCmd[5])
	
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_CHANGE_NAME:",cUId,cRId,cName)
	
	--��Ҹ�������id������
	local itemId = 9926
	local itemCost = 0
	
	local result = 0
	local info = -3
	
	--��ѯ�����Ƿ��ظ�
	local sql = string.format("SELECT count(*) FROM t_cha WHERE name='%s'",cName)
	local e,count = xlDb_Query(sql)
	--print("sql:",sql,e,count)
	if e == 0 then
		if count <= 0 then
			
			local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
			
			--������
			--�µĹ����¼���뵽order��
			sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,udbid,cRId,itemId,1,sItemName,itemCost,0,cNameOld .. " -> " .. cName)
			--print("sUpdate2:",sUpdate)
			xlDb_Execute(sUpdate)
			
			--����
			sUpdate = string.format("UPDATE t_cha SET name='%s', nickname='%s' WHERE id = %d",cName,cName,cRId)
			--print("sUpdate3:",sUpdate)
			xlDb_Execute(sUpdate)
			
			sUpdate = string.format("UPDATE cha_dictionary SET name='%s' WHERE id = %d",cName,cRId)
			--print("sUpdate4:",sUpdate)
			xlDb_Execute(sUpdate)
			
			sUpdate = string.format("UPDATE t_pvp_user SET name='%s' WHERE id = %d",cName,cRId)
			--print("sUpdate5:",sUpdate)
			xlDb_Execute(sUpdate)
			
			sUpdate = string.format("UPDATE t_user SET customS1='%s' WHERE uid = %d",cName,udbid)
			--print("sUpdate6:",sUpdate)
			xlDb_Execute(sUpdate)
			
			sUpdate = string.format("UPDATE t_chat_user SET name='%s' WHERE uid = %d",cName,udbid)
			--print("sUpdate7:",sUpdate)
			xlDb_Execute(sUpdate)
			
			--����᳤����
			sUpdate = string.format("UPDATE `novicecamp_list` SET `master_name` = '%s' WHERE `master_uid` = %d", cName, udbid)
			--print("sUpdate8:",sUpdate)
			xlDb_Execute(sUpdate)
			
			result = 1
			info = orderId
			
			local err1, orderId = xlDb_Query("select last_insert_id()")
			--print("err1,orderId:",err1,orderId)
			if err1 == 0 then
				info = orderId
			else
			
			end
			
		else
			info = -2 --����
		end
	else
		info = -2 --����
	end
	
	local sL2CCmd = tostring(result) .. ";" .. tostring(info) .. ";" .. tostring(index) .. ";" .. tostring(cName)
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_SET_NAME,sL2CCmd)
	--print("hApi.xlNet_Send:",sL2CCmd)
end
--���µ�ͼ�״�ͨ�ؼ�¼
__Handler[hVar.DB_OPR_TYPE.C2L_UPLOAD_MAP_RECORD] = function(udbid, rid, msgId, tCmd)
	--todo:��д
	local cRId = tonumber(tCmd[1]) or 0
	local cMapId = tonumber(tCmd[2]) or 0
	local cUId = tonumber(tCmd[3]) or 0
	local mapName = tCmd[4]
	
	--print("hVar.DB_OPR_TYPE.C2L_UPLOAD_MAP_RECORD:",cRId,cMapId,cUId, mapName)
	
	--��������
	local sUpdate = string.format("INSERT INTO `t_map_finish_record` (`rid`, `mapId`, `uid`, `mapName`) values (%d, %d, %d, '%s')",cRId,cMapId,cUId,mapName)
	--print("sUpdate:",sUpdate)
	xlDb_Execute(sUpdate)
	
	--local sL2CCmd = tostring(result) .. ";" .. tostring(info)
	--hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.C2L_UPLOAD_MAP_RECORD,sL2CCmd)
	--print("hApi.xlNet_Send:",sL2CCmd)
end

--���̳�
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_OPEN_SHOP] = function(udbid, rid, msgId, tCmd)
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local cShopId = tonumber(tCmd[3]) or 0
	local iTag = tonumber(tCmd[4]) or 0			--�ͻ����ϴ���tag��ԭ�ⲻ������
	
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_OPEN_SHOP:",cUId,cRId,cShopId)
	local sL2CCmd = hGlobal.shopMgr:OpenShop(cUId,cRId,cShopId)
	if sL2CCmd then
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_SHOP_INFO, "1;"  .. tostring(iTag) .. ";" .. sL2CCmd)
	else
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_SHOP_INFO, "0;" .. tostring(iTag) .. ";")
	end
end

--ˢ���̳�(ʹ��rmbˢ��)
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_REFRESH_SHOP] = function(udbid, rid, msgId, tCmd)
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local cShopId = tonumber(tCmd[3]) or 0
	local iTag = tonumber(tCmd[4]) or 0			--�ͻ����ϴ���tag��ԭ�ⲻ������
	
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_REFRESH_SHOP:",cUId,cRId,cShopId)
	
	local sL2CCmd,refreshShopItem,result = hGlobal.shopMgr:RefreshShop(cUId,cRId,cShopId)
	if sL2CCmd then
		if refreshShopItem then
			--����ˢ�³ɹ���Ϣ
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_REFRESH_SHOP, "1;" .. tostring(iTag) .. ";" .. refreshShopItem)
		end

		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_SHOP_INFO, "1;" .. tostring(iTag) .. ";" .. sL2CCmd)
	else
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_SHOP_INFO, tostring(result) .. ";" .. tostring(iTag) .. ";")
	end
	
end

--������Ʒ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_BUYITEM] = function(udbid, rid, msgId, tCmd)
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local cShopId = tonumber(tCmd[3]) or 0
	local cItemIdx = tonumber(tCmd[4]) or 0
	local cRedequipCrystal = tonumber(tCmd[5]) or 0		--�Ƿ�ֻ���ĺ�װ��ʯ
	if cRedequipCrystal > 0 then
		cRedequipCrystal = true
	else
		cRedequipCrystal = false
	end
	local iTag = tonumber(tCmd[6]) or 0			--�ͻ����ϴ���tag��ԭ�ⲻ������
	
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_BUYITEM:",cUId,cRId,cShopId,cItemIdx)
	
	local sL2CCmd,goods = hGlobal.shopMgr:BuyItem(cUId,cRId,cShopId,cItemIdx,cRedequipCrystal)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_BUYITEM:",sL2CCmd,goods)
	if sL2CCmd then
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_BUYITEM, tostring(iTag) .. ";" ..  sL2CCmd)
		--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_BUYITEM 1")
		if goods then
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_SHOP_INFO, "1;" .. tostring(iTag) .. ";" .. goods)
			--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_BUYITEM 2")
		end
	else
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_SHOP_INFO, "0;" .. tostring(iTag) .. ";")
	end
end

--��ȡ�ҵ�������Դ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_MYCOIN] = function(udbid, rid, msgId, tCmd)
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	--print("C2L_REQUIRE_MYCOIN", cUId, cRId)
	local sL2CCmd = hGlobal.userCoinMgr:DBUserGetMyCoin(cUId,cRId)
	
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_MYCOIN,sL2CCmd)
end

--��װ�ϳ�
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_MERGE_ORANGEEQUIP] = function(udbid, rid, msgId, tCmd)
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local strMergeInfo = tostring(tCmd[3]) or "" --����id�б��ַ���
	local cMainDbid = tonumber(tCmd[4]) or 0
	local cMaterialNum = tonumber(tCmd[5]) or 0
	local idx = 5
	local cMaterialDbidList = {}
	for i = 1, cMaterialNum, 1 do
		cMaterialDbidList[#cMaterialDbidList + 1] = tonumber(tCmd[idx+i]) or 0
	end
	
	local shopItemId = hClass.RedEquipMgr.MERGE_ORANGE_SHOPITEMID --��װ�̵����
	local tShopItem = hVar.tab_shopitem[shopItemId]
	local rmbCost = tShopItem.rmb --��װ�ϳ�������Ϸ��
	local itemId = tShopItem.itemID
	
	local purchaseInfo = tostring(cMainDbid) .. ";" .. tostring(cMaterialNum) .. ";"
	for i = 1, cMaterialNum, 1 do
		purchaseInfo = purchaseInfo .. tostring(cMaterialDbidList[i]) .. ";"
	end
	
	local ret = ""
	
	--�۳���Ϸ��
	local bSuccess, order_id = hGlobal.userCoinMgr:DBUserPurchase(cUId, cRId, itemId, 1, rmbCost, 0, strMergeInfo)
	if bSuccess then
		ret = "1;" --�ɹ�
	else
		ret = "-3;" --�ϳɵ���ʧ��:��Ϸ�Ҳ���
	end
	
	local sL2CCmd = ret .. order_id .. ";" .. purchaseInfo
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_MERGE_ORANGEEQUIP,sL2CCmd)
end

--��װ�ϳɽ��
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_MERGE_ORANGEEQUIP_RESULT] = function(udbid, rid, msgId, tCmd)
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local strMergeInfo = tostring(tCmd[3]) or "" --����id�б��ַ���
	local cOrderId = tonumber(tCmd[4]) or 0 --������id
	
	--���¶�����Ϣ
	local sUpdate = string.format("UPDATE `order` SET `ext_01` = '%s' WHERE `id` = %d", strMergeInfo, cOrderId)
	--print("sUpdate1:",sUpdate)
	xlDb_Execute(sUpdate)
end

--��װ�ϳ�
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_MERGE_REDEQUIP] = function(udbid, rid, msgId, tCmd)
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local cMainDbid = tonumber(tCmd[3]) or 0
	local cMaterialNum = tonumber(tCmd[4]) or 0
	local idx = 4
	local cMaterialDbidList = {}
	for i = 1, cMaterialNum do
		cMaterialDbidList[#cMaterialDbidList + 1] = tonumber(tCmd[idx+i]) or 0
	end
	
	local redequipMgr = hGlobal.redEquipUserCacheMgr:GetRedEquipMgr(cUId, cRId)
	--local redequipMgr = hClass.RedEquipMgr:create():Init(cUId,cRId)
	if redequipMgr then
		
		local sL2CCmd = redequipMgr:DBMerge(cMainDbid, cMaterialNum, cMaterialDbidList)
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_MERGE_REDEQUIP,sL2CCmd)
	end
end

--�ֽ��װ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_DESCOMPOS_REDEQUIP] = function(udbid, uid, nOpr, tCmd)	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local cMaterialNum = tonumber(tCmd[3]) or 0
	local idx = 3
	local cMaterialDbidList = {}
	for i = 1, cMaterialNum do
		cMaterialDbidList[#cMaterialDbidList + 1] = tonumber(tCmd[idx+i]) or 0
	end

	local redequipMgr = hGlobal.redEquipUserCacheMgr:GetRedEquipMgr(cUId, cRId)
	if redequipMgr then
		local sL2CCmd = redequipMgr:DBDescomposRedEquip(cMaterialNum, cMaterialDbidList)
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_DESCOMPOS_REDEQUIP,sL2CCmd)
	end
end

--������ս��ͨ�����ͼ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_BATTLE_NORMAL] = function(udbid, uid, nOpr, tCmd)
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local mapName = tostring(tCmd[3])
	local mapDiff = tonumber(tCmd[4]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local pvpcoin_num = 0
		local battlecfg_id = 0
		local ret = 0
		
		--����ͼ��ǰ�Ѷ��Ƿ����ս
		--��ѯ��ͼ��Ϣ
		local tankMap = hClass.TankMap:create():Init(cUId,cRId)
		local _, tMap = tankMap:QueryInfo()
		local nextLevel = 0 --����ս������Ѷ�
		for i = 1, #tMap, 1 do
			local tMapInfo = tMap[i]
			if (tMapInfo[1] == mapName) then --�ҵ���
				local star0 = tMapInfo[2] --��ͼ��ͨ����
				local star1 = tMapInfo[3] --��ͼ�Ѷ�1����
				local star2 = tMapInfo[4] --��ͼ�Ѷ�2����
				local star3 = tMapInfo[5] --��ͼ�Ѷ�3����
				
				if (star3 > 0) then
					nextLevel = 3
				elseif (star2 > 0) then
					nextLevel = 3
				elseif (star1 > 0) then
					nextLevel = 2
				elseif (star0 > 0) then
					nextLevel = 1
				else
					nextLevel = 0
				end
				
				break
			end
		end
		
		if (mapDiff <= nextLevel) then
			--��ѯ��ұ�������
			local sql = string.format("SELECT `pvpcoin` FROM `t_user` WHERE `uid` = %d", udbid)
			local errM, coin = xlDb_Query(sql)
			--print("sql:",sql,e,count)
			if (errM == 0) then
				pvpcoin_num = coin
			end
			
			--��Ʒ��Ϣ
			local shopItemId = 637 --��ս�����ͼ
			local tShopItem = hVar.tab_shopitem[shopItemId]
			local rmbCost = tShopItem.rmb --������Ϸ��
			local scoreCost = tShopItem.score --���Ļ���
			local pvpcoinCost = tShopItem.pvpcoin
			
			--�۳�����
			if (pvpcoin_num >= pvpcoinCost) then
				local sql = string.format("UPDATE `t_user` SET `pvpcoin` = `pvpcoin` - %d WHERE uid= %d", pvpcoinCost, udbid)
				local err = xlDb_Execute(sql)
				--print("DBBuyPvpCoin:",err,sql)
				
				--������
				--�µĹ����¼���뵽order��
				
				--���±�������
				pvpcoin_num = pvpcoin_num - pvpcoinCost
				
				local itemId = tShopItem.itemID
				local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
				local strInfo = tostring(mapName) .. ";" .. tostring(mapDiff) .. ";"
				sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,udbid,cRId,itemId,1,sItemName,rmbCost,scoreCost,strInfo)
				--print("sUpdate2:",sUpdate)
				xlDb_Execute(sUpdate)
				
				--������һ��ȺӢ����ս��¼�������ؼ�¼id
				--����һ��������
				local sInsertM = string.format("insert into `log_qunyingge_battleconfig`(`uid`, `rid`, `mapname`, `difficulty`, `game_time`, `time_begin`) values(%d, %d, '%s', %d, '', now())", udbid, cRId, mapName, mapDiff)
				xlDb_Execute(sInsertM)
				--print(sInsertM)
				
				--ȡ��ս��¼id
				local err1, oId = xlDb_Query("select last_insert_id()")
				--print("err1,orderId:",err1,orderId)
				if (err1 == 0) then
					battlecfg_id = oId
				else
					
				end
				
				--[[
				--����ÿ�������£�
				--�������ˣ�ȺӢ��
				local taskType = hVar.TASK_TYPE.TASK_PVPTOKEN_USE --�������ˣ�ȺӢ��
				local addCount = hVar.ENDLESS_BATTLE_COST_PVPCOIN
				local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(udbid, cRId)
				taskMgr:AddTaskFinishCount(taskType, addCount)
				]]
				
				ret = 1 --�ɹ�
			else
				ret = -2 --��������
			end
		else
			ret = -3 --ͨ��ǰһ���ѶȲ�����ս
		end
		
		local sL2CCmd = tostring(ret) .. ";" .. tostring(pvpcoin_num) .. ";"  .. tostring(mapName) .. ";" .. tostring(mapDiff) .. ";" .. tostring(battlecfg_id) .. ";"
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_BATTLE_NORMAL_RET,sL2CCmd)
	end
end

--������ս���ֵ�ͼ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_BATTLE_ENTERTAMENT] = function(udbid, uid, nOpr, tCmd)
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local mapName = tostring(tCmd[3])
	local mapDiff = tonumber(tCmd[4]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local pvpcoin_num = 0
		local battlecfg_id = 0
		local ret = 0
		
		--��ѯ��ұ�������
		local sql = string.format("SELECT `pvpcoin` FROM `t_user` WHERE `uid` = %d", udbid)
		local errM, coin = xlDb_Query(sql)
		--print("sql:",sql,e,count)
		if (errM == 0) then
			pvpcoin_num = coin
		end
		
		--��Ʒ��Ϣ
		local shopItemId = 638 --��ս���ֵ�ͼ
		local tShopItem = hVar.tab_shopitem[shopItemId]
		local rmbCost = tShopItem.rmb --������Ϸ��
		local scoreCost = tShopItem.score --���Ļ���
		local pvpcoinCost = tShopItem.pvpcoin
		
		--�۳�����
		if (pvpcoin_num >= pvpcoinCost) then
			local sql = string.format("UPDATE `t_user` SET `pvpcoin` = `pvpcoin` - %d WHERE uid= %d", pvpcoinCost, udbid)
			local err = xlDb_Execute(sql)
			--print("DBBuyPvpCoin:",err,sql)
			
			--������
			--�µĹ����¼���뵽order��
			
			--���±�������
			pvpcoin_num = pvpcoin_num - pvpcoinCost
			
			local itemId = tShopItem.itemID
			local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
			local strInfo = tostring(mapName) .. ";" .. tostring(mapDiff) .. ";"
			sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,udbid,cRId,itemId,1,sItemName,rmbCost,scoreCost,strInfo)
			--print("sUpdate2:",sUpdate)
			xlDb_Execute(sUpdate)
			
			--������һ��ȺӢ����ս��¼�������ؼ�¼id
			--����һ��������
			local sInsertM = string.format("insert into `log_qunyingge_battleconfig`(`uid`, `rid`, `mapname`, `difficulty`, `game_time`, `time_begin`) values(%d, %d, '%s', %d, '', now())", udbid, cRId, mapName, mapDiff)
			xlDb_Execute(sInsertM)
			--print(sInsertM)
			
			--ȡ��ս��¼id
			local err1, oId = xlDb_Query("select last_insert_id()")
			--print("err1,orderId:",err1,orderId)
			if (err1 == 0) then
				battlecfg_id = oId
			else
				
			end
			
			--[[
			--����ÿ�������£�
			--�������ˣ�ȺӢ��
			local taskType = hVar.TASK_TYPE.TASK_PVPTOKEN_USE --�������ˣ�ȺӢ��
			local addCount = hVar.ENDLESS_BATTLE_COST_PVPCOIN
			local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(udbid, cRId)
			taskMgr:AddTaskFinishCount(taskType, addCount)
			]]
			
			ret = 1 --�ɹ�
		else
			ret = -2 --��������
		end
		
		local sL2CCmd = tostring(ret) .. ";" .. tostring(pvpcoin_num) .. ";"  .. tostring(mapName) .. ";" .. tostring(mapDiff) .. ";" .. tostring(battlecfg_id) .. ";"
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_BATTLE_ENTETAMENT_RET,sL2CCmd)
	end
end

--����������ֵ�ͼ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_RESUME_ENTERTAMENT] = function(udbid, uid, nOpr, tCmd)
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local mapName = tostring(tCmd[3])
	local mapDiff = tonumber(tCmd[4]) or 0
	local battleId = tonumber(tCmd[5]) or 0 --ս��id
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local pvpcoin_num = 0
		local battlecfg_id = 0
		local ret = 0
		
		--��ѯ����Ƿ���ڴ�ս����Ϣ
		local sql = string.format("SELECT `mapname`, `difficulty` FROM `log_qunyingge_battleconfig` WHERE `id` = %d and `uid` = %d and `rid` = %d", battleId, cUId, cRId)
		local errM, mapname, difficulty = xlDb_Query(sql)
		--print("sql:",sql,errM,mapname, difficulty)
		if (errM == 0) then
			if (mapname == mapName) and (difficulty == mapDiff) then
				ret = 1 --�ɹ�
			else
				ret = -2 --ս����Ϣ��һ��
			end
		else
			ret = -1 --ս��������
		end
		
		local sL2CCmd = tostring(ret) .. ";" .. tostring(mapName) .. ";" .. tostring(mapDiff) .. ";" .. tostring(battleId) .. ";"
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_RESUME_ENTETAMENT_RET,sL2CCmd)
	end
end

--GMָ��-����Դ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_GM_ADD_RESOURCE] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local nChannelId = tonumber(tCmd[3]) --������
	local rewardType = tonumber(tCmd[4]) --��������
	local param2 = tonumber(tCmd[5]) --����2
	local param3 = tonumber(tCmd[6]) --����3
	local param4 = tonumber(tCmd[7]) --����4
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local ret = 0
		local prizeId = 0
		local prizeType = 0
		local prizeContent = ""
		local IsGMInternal = 1 --hClass.User:IsGMInternal(cUId)
		if (IsGMInternal == 1) then
			ret = 1
			
			--����������
			local strRewardType = ""
			if (rewardType == 1) then --����
				strRewardType = hVar.tab_string["__TEXT_SCORE"]
			elseif (rewardType == 7) then --��Ϸ��
				strRewardType = hVar.tab_string["__TEXT_GAMESCORE"]
			elseif (rewardType == 4) then --Ӣ��
				strRewardType = hVar.tab_string["__TEXT_HERO"]
			elseif (rewardType == 5) then --Ӣ�۽���
				strRewardType = hVar.tab_string["__TEXT_HERODEBRIS"]
			elseif (rewardType == 6) then --ս������Ƭ
				strRewardType = hVar.tab_string["__TEXT_TACTICDEBRIS"]
			end
			
			--���뽱��
			local id = 20008
			local detail = string.format(hVar.tab_string["__TEXT_GMTOOL_PRIZE"], strRewardType, rewardType, param2, param3, param4) --"GM����-%s;%d:%d:%d:%d;"
			local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",cUId,id,detail,0,0)
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
				prizeContent = hApi.GetRewardInPrize(cUId, cRId, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
			end
		else
			ret = -1 --û��Ȩ��
		end
		local sL2CCmd = tostring(ret) .. ";" .. tostring(rewardType) .. ";" .. tostring(prizeType) .. ";" .. tostring(prizeContent)
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_GM_ADD_RESOURCE_RET, sL2CCmd)
	end
end

--GMָ��-��ͼȫͨ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_GM_MAP_FINISH] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local nChannelId = tonumber(tCmd[3]) --������
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local ret = 0
		local IsGMInternal = 1 --hClass.User:IsGMInternal(cUId)
		if (IsGMInternal == 1) then
			ret = 1
		else
			ret = -1 --û��Ȩ��
		end
		local sL2CCmd = tostring(ret) .. ";"
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_GM_MAP_FINISH_RET,sL2CCmd)
	end
end

--GMָ��-��ȫ��Ӣ�۾���
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_GM_ADD_HEROEXP_ALL] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local nChannelId = tonumber(tCmd[3]) --������
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local ret = 0
		local IsGMInternal = 1 --hClass.User:IsGMInternal(cUId)
		if (IsGMInternal == 1) then
			ret = 1
		else
			ret = -1 --û��Ȩ��
		end
		local sL2CCmd = tostring(ret) .. ";"
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_GM_ADD_HEROEXP_ALL,sL2CCmd)
	end
end

--��������ͼ-��Ӻ�װ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_GUIDE_ADD_REDEQUOP] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local nChannelId = tonumber(tCmd[3]) --������
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--����һ��prize����
		--���뽱��
		local prizeContent = ""
		local prizeId = 0
		local prizeType = 0
		
		local id = 20008
		local detail = hVar.tab_string["__TEXT_GUIDE_PRIZE"]
		local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",cUId,id,detail,0,0)
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
			prizeContent = hApi.GetRewardInPrize(cUId, cRId, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
		end
		
		local sL2CCmd = tostring(prizeContent)
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_GUIDE_ADD_REDEQUOP_RET,sL2CCmd)
	end
end

--��װϴ��
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_XILIAN_REDEQUIP] = function(udbid, rid, msgId, tCmd)
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local cItemDbid = tonumber(tCmd[3]) or 0
	local cLockNum = tonumber(tCmd[4]) or 0
	local idx = 4
	local cLockIdxDic = {}
	for i = 1, cLockNum do
		local idxx = tonumber(tCmd[idx+i]) or 0
		cLockIdxDic[idxx] = true
	end

	--local redequipMgr = hClass.RedEquipMgr:create():Init(cUId,cRId)
	local redequipMgr = hGlobal.redEquipUserCacheMgr:GetRedEquipMgr(cUId, cRId)
	if redequipMgr then

		local sL2CCmd, bRet = redequipMgr:DBXiLian(cItemDbid, cLockNum, cLockIdxDic)
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_XILIAN_REDEQUIP,sL2CCmd)

		-- �ɹ�
		if bRet then
			-- ����оƬ����װ���������
			local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(cUId, cRId)
			local addCount = 1
			taskMgr:AddTaskFinishCount(hVar.TASK_TYPE.TASK_USE_CHIP_TO_REFORM_EQUIP_TIMES, addCount)
		end
	end
end

--��װͬ��
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_SYNC_REDEQUIP] = function(udbid, rid, msgId, tCmd)
	
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_SYNC_REDEQUIP:",uid,nOpr,sCmd)
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0

	local cOldRedEquipNum = tonumber(tCmd[3]) or 0
	local oldIdx = 3
	local oldList = {}
	for i = 1, cOldRedEquipNum do
		local strOldRedEquip = tCmd[oldIdx + i]
		local tOldRedEquip = hApi.Split(strOldRedEquip,"|")
		oldList[#oldList + 1] = {}
		oldList[#oldList].typeId = tonumber(tOldRedEquip[1]) or 0
		oldList[#oldList].uniqueId = tonumber(tOldRedEquip[2]) or 0
		oldList[#oldList].slotNum = tonumber(tOldRedEquip[3]) or 0
		oldList[#oldList].strAttr = tOldRedEquip[4]
		--print("oldList[#oldList].typeId:",oldList[#oldList].typeId,tOldRedEquip[1])
		--print("oldList[#oldList].uniqueId:",oldList[#oldList].uniqueId)
		--print("oldList[#oldList].slotNum:",oldList[#oldList].slotNum)
		--print("oldList[#oldList].strAttr:",oldList[#oldList].strAttr)
	end

	--local redequipMgr = hClass.RedEquipMgr:create(true):Init(cUId,cRId)
	local redequipMgr = hGlobal.redEquipUserCacheMgr:GetRedEquipMgr(cUId, cRId)
	if redequipMgr then
		if cOldRedEquipNum > 0 then
			redequipMgr:DBChangeOld(cUId,cRId,cOldRedEquipNum,oldList)
		end
		
		--ȡ������к�װ����
		--redequipMgr:DBGetRedEquip(cUId,cRId)
		local sL2CCmd = redequipMgr:InfoToCmd()
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_SYNC_REDEQUIP,sL2CCmd)
	end

end

--��ȡ���к�װ��Ϣ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_GET_ALLREDEQUIP] = function(udbid, rid, msgId, tCmd)

	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_GET_ALLREDEQUIP:",udbid,nOpr,sCmd)
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	--local redequipMgr = hClass.RedEquipMgr:create():Init(cUId,cRId)
	local redequipMgr = hGlobal.redEquipUserCacheMgr:GetRedEquipMgr(cUId, cRId)
	if redequipMgr then
		local sL2CCmd = redequipMgr:GetAllScrollEquip()
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_GET_ALLREDEQUIP,sL2CCmd)
		--print("sL2CCmd:",sL2CCmd)
	end
end

--��װ����һ���װ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_REDSCROLL_EXCHANGE] = function(udbid, rid, msgId, tCmd)

	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_REDSCROLL_EXCHANGE:",uid,nOpr,sCmd)
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local cIdx = tonumber(tCmd[3]) or 0
	
	--local redequipMgr = hClass.RedEquipMgr:create():Init(cUId,cRId)
	local redequipMgr = hGlobal.redEquipUserCacheMgr:GetRedEquipMgr(cUId, cRId)
	if redequipMgr then
		local sL2CCmd = redequipMgr:DBScroll2RedEquip(cIdx)
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_REDSCROLL_EXCHANGE,sL2CCmd)
		--print("sL2CCmd:",sL2CCmd)
		
		local tL2CCmd = hApi.Split(sL2CCmd,";")
		local result = tonumber(tL2CCmd[1]) or 0
		if result > 0 then
			sL2CCmd = hGlobal.userCoinMgr:DBUserGetMyCoin(cUId,cRId)
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_MYCOIN,sL2CCmd)
		end
	end
end


--��׿��ͬ����־�浵
local _file = nil
local _err = nil
local _strdateFile = nil
__Handler[hVar.DB_OPR_TYPE.C2L_ANDROID_SAVE_LOG] = function(udbid, rid, msgId, tCmd)
	
	--print("hVar.DB_OPR_TYPE.C2L_ANDROID_SAVE_LOG:",uid,nOpr,sCmd)
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local block = tostring(tCmd[3])
	local notice = tostring(tCmd[4])
	
	local strdate = os.date("%Y-%m-%d %H:%M:%S", os.time())
	local sL2CCmd = strdate .. "\t" .. cUId .. "\t" .. cRId .. "\t\t" .. block .. "\t\t\t" .. notice
	
	local strdateFile = os.date("%Y%m%d", os.time())
	local filename = "log/SaveDateRecord_" .. strdateFile .. ".log"
	
	if (_file == nil) then --�״δ����ļ�
		_file, _err = io.open(filename,"a+")
		_strdateFile = strdateFile
	else
		if (strdateFile == _strdateFile) then --����һ��
			--
		else --�µ�һ��
			_file:close()
			
			_file, _err = io.open(filename,"a+")
			_strdateFile = strdateFile
		end
		
	end
	
	if _file then
		_file:write(sL2CCmd)
		_file:write("\n")
		_file:flush()
	else
		print(("[error] %s open fail! %s"):format(filename, _err))
	end
	
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_ANDROID_SAVE_LOG, sL2CCmd)
	
	--���������͵�����Ϣ
	--hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_ANDROID_NOTICE_MSG, sL2CCmd)
end


--��ȡvip��Ϣ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_VIP_INFO] = function(udbid, rid, msgId, tCmd)
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0

	local vipLv, money, coin_base, coin, dailyRewardFlag1, dailyRewardFlag2, dailyRewardFlag3, borderId, iconId, championId, dragonId, headId, lineId = hGlobal.vipMgr:DBGetUserVipState(cUId)

	local sL2CCmd = vipLv .. ";" .. money .. ";" .. coin_base .. ";" .. coin .. ";" .. dailyRewardFlag1 .. ";" .. dailyRewardFlag2 .. ";" .. dailyRewardFlag3 .. ";"
			.. borderId .. ";" .. iconId .. ";" .. championId .. ";" .. dragonId .. ";" .. headId .. ";" .. lineId .. ";"

	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_VIP_INFO,sL2CCmd)

end

--��ȡvipÿ�ս���1
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_VIP_DAILY_REWARD] = function(udbid, rid, msgId, tCmd)
	
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	local result = 0
	local rewardIndex = 1 --ÿ�ս���1
	local ret, ret_prize_id, ret_prize_type = hGlobal.vipMgr:DBGetDailyBonus(cUId, rewardIndex)
	if ret then
		result = 1
	end
	
	local sL2CCmd = tostring(result) .. ";" ..  tostring(rewardIndex) .. ";" ..  tostring(ret_prize_id) .. ";" ..  tostring(ret_prize_type) .. ";"
	
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_VIP_DAILY_REWARD,sL2CCmd)
	
end

--��ȡvipÿ�ս���2
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_VIP_DAILY_REWARD2] = function(udbid, rid, msgId, tCmd)
	
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	local result = 0
	local rewardIndex = 2 --ÿ�ս���2
	local ret, ret_prize_id, ret_prize_type = hGlobal.vipMgr:DBGetDailyBonus(cUId, rewardIndex)
	if ret then
		result = 1
	end
	
	local sL2CCmd = tostring(result) .. ";" ..  tostring(rewardIndex) .. ";" ..  tostring(ret_prize_id) .. ";" ..  tostring(ret_prize_type) .. ";"
	
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_VIP_DAILY_REWARD,sL2CCmd)
	
end

--��ȡvipÿ�ս���3
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_VIP_DAILY_REWARD3] = function(udbid, rid, msgId, tCmd)
	
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	local result = 0
	local rewardIndex = 3 --ÿ�ս���3
	local ret, ret_prize_id, ret_prize_type = hGlobal.vipMgr:DBGetDailyBonus(cUId, rewardIndex)
	if ret then
		result = 1
	end
	
	local sL2CCmd = tostring(result) .. ";" ..  tostring(rewardIndex) .. ";" ..  tostring(ret_prize_id) .. ";" ..  tostring(ret_prize_type) .. ";"
	
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_VIP_DAILY_REWARD,sL2CCmd)
	
end

--��ȡ����ת�̻״̬
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_ACTIVITY_TURNRABLE] = function(udbid, rid, msgId, tCmd)
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local cAId = tonumber(tCmd[3]) or 0 --�id
	local nChannelId = tonumber(tCmd[4]) --������
	
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		--��ѯ�������ת�̻״̬
		if hClass.ActivityTurnTable then
			local turnTable = hClass.ActivityTurnTable:create("ActivityTurnTable"):Init(udbid, rid, cAId, nChannelId)
			local sL2CCmd = turnTable:QueryFinishState()
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ACTIVITY_TURNTABLE, sL2CCmd)
		end
	end
end

--ת�̻ʹ��ת�̴���
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_ACTIVITY_TURNRABLE_USE] = function(udbid, rid, msgId, tCmd)
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local cAId = tonumber(tCmd[3]) or 0 --�id
	local nChannelId = tonumber(tCmd[4]) --������
	
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		--ʹ��ת��
		if hClass.ActivityTurnTable then
			local turnTable = hClass.ActivityTurnTable:create("ActivityTurnTable"):Init(udbid, rid, cAId, nChannelId)
			local sL2CCmd = turnTable:UseTurnTableCount()
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ACTIVITY_TURNTABLE_USE, sL2CCmd)
		end
	end
end

--ת�̻��ѯ���б�
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_ACTIVITY_TURNRABLE_PRIZELIST] = function(udbid, rid, msgId, tCmd)
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local cAId = tonumber(tCmd[3]) or 0 --�id
	local nChannelId = tonumber(tCmd[4]) --������
	
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		--ʹ��ת��
		if hClass.ActivityTurnTable then
			local turnTable = hClass.ActivityTurnTable:create("ActivityTurnTable"):Init(udbid, rid, cAId, nChannelId)
			local sL2CCmd = turnTable:GetPrizeList()
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ACTIVITY_TURNTABLE_PRIZELIST, sL2CCmd)
		end
	end
end

--��ѯ�������������ֵ�״̬
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_ACTIVITY_SEVENDAY_PAY_STATE] = function(udbid, rid, msgId, tCmd)
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local cAId = tonumber(tCmd[3]) or 0 --�id
	local nChannelId = tonumber(tCmd[4]) --������
	
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		--��ѯ�������������ֵ�״̬
		if hClass.ActivitySevenDayPay then
			local sevendayPay = hClass.ActivitySevenDayPay:create("ActivitySevenDayPay"):Init(udbid, rid, cAId, nChannelId)
			local sL2CCmd = sevendayPay:QueryFinishState()
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ACTIVITY_SEVENDAY_PAY_STATE, sL2CCmd)
		end
	end
end

--�������������ֵ�������ȡ����
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_ACTIVITY_SEVENDAY_PAY_USE] = function(udbid, rid, msgId, tCmd)
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local cAId = tonumber(tCmd[3]) or 0 --�id
	local nChannelId = tonumber(tCmd[4]) --������
	local rewardIdx = tonumber(tCmd[5]) --��ȡ�ĵ�λ����ֵ
	
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		--�����ȡ����������ֵ�����
		if hClass.ActivitySevenDayPay then
			local sevendayPay = hClass.ActivitySevenDayPay:create("ActivitySevenDayPay"):Init(udbid, rid, cAId, nChannelId)
			local sL2CCmd = sevendayPay:TakeActivityReward(rewardIdx)
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ACTIVITY_SEVENDAY_PAY_USE, sL2CCmd)
		end
	end
end

--������ñ߿��ͷ��
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_SET_ROLE_BOEDER_ICON] = function(udbid, rid, msgId, tCmd)
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local borderId = tonumber(tCmd[3]) or 0 --�߿�id
	local iconId = tonumber(tCmd[4]) or 0 --ͷ��id
	
	local ret = 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--print("user=", user)
		if user then
			--����
			local sUpdate = string.format("UPDATE `t_user` SET `border` = %d, `icon` = %d WHERE `uid` = %d", borderId, iconId, udbid)
			--print("sUpdate1:",sUpdate)
			xlDb_Execute(sUpdate)
			
			--�ɹ�
			ret = 1
		end
	end
	
	local sCmd = tostring(ret) .. ";" .. tostring(borderId) .. ";" .. tostring(iconId)
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ROLE_SET_BORDER_ICON, sCmd)
end

--��ѯ�����Ϸ�ұ仯��ʷ��¼
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_GAMECOIN_CHAGE_HOSTORY] = function(udbid, rid, msgId, tCmd)
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	local ret = 0
	local sL2CCmd = ""
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--��ѯ��Ϸ�ұ仯��ʷ��¼
		sL2CCmd = hGlobal.userCoinMgr:DBQueryGameCoinHistory(cUId, cRId)
		
		--�ɹ�
		ret = 1
	end
	
	local sCmd = tostring(ret) .. ";" .. tostring(sL2CCmd)
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_GAMECOIN_CHAGE_HOSTORY, sCmd)
end



















--����ս���÷�
__Handler[hVar.DB_OPR_TYPE.C2L_UPDATE_TANK_SCORE] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local bId = tonumber(tCmd[3]) or 0
	local diff = tonumber(tCmd[4]) or 0
	local name = tostring(tCmd[5])
	local stage = tonumber(tCmd[6]) or 0
	local tankId = tonumber(tCmd[7]) or 0
	local weaponId = tonumber(tCmd[8]) or 0
	local gametime = tonumber(tCmd[9]) or 0
	local scientistNum = tonumber(tCmd[10]) or 0
	local goldNum = tonumber(tCmd[11]) or 0
	local killNum = tonumber(tCmd[12]) or 0
	
	local ret = 0
	local sL2CCmd = ""
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--��ѯ��ҵ����а�ɼ�
		local sQueryM = string.format("select `stage`, `gametime`, `gold`, `kill` from `tank_billboard` where `uid` = %d and `rid` = %d and `bid` = %d and `diff` = %d", udbid, cRId, bId, diff)
		local errM, stageM, gametimeM, goldNumM, killNumM = xlDb_Query(sQueryM)
		--print(sQueryM)
		--print("��ѯ��ҵ����а�ɼ�:", "errM=", errM, "stageM=", stageM, "gametimeM=", gametimeM, "goldNumM=", goldNumM, "killNumM=", killNumM)
		--print("gametime=", gametime)
		if (errM == 0) then
			if (bId == hVar.TANK_BILLBOARD_RANK_TYPE.RANK_STAGE) then --ս����ͼ���а�
				--���ν��ȸ��ߣ����߽���һ�¡�ʱ�����
				if (stage > stageM) or ((stage == stageM) and (gametime < gametimeM)) then
					--��������
					local sUpdateM = string.format("update `tank_billboard` set `name` = '%s', `stage` = %d, `tank` = %d, `weapon` = %d, `gametime` = %d, `scientist` = %d, `gold` = %d, `kill` = %d, `time` = now() where `uid` = %d and `rid` = %d and `bid` = %d and `diff` = %d", name, stage, tankId, weaponId, gametime, scientistNum, goldNum, killNum, udbid, cRId, bId, diff)
					xlDb_Execute(sUpdateM)
					--print(sUpdateM)
				end
			elseif (bId == hVar.TANK_BILLBOARD_RANK_TYPE.RANK_CONTINOUSKILL) then --ս����ɱ���а�
				--������ɱ���ߣ�������ɱһ�¡����ȸ���
				if (killNum > killNumM) or ((killNum == killNumM) and (stage > stageM)) then
					--��������
					local sUpdateM = string.format("update `tank_billboard` set `name` = '%s', `stage` = %d, `tank` = %d, `weapon` = %d, `gametime` = %d, `scientist` = %d, `gold` = %d, `kill` = %d, `time` = now() where `uid` = %d and `rid` = %d and `bid` = %d and `diff` = %d", name, stage, tankId, weaponId, gametime, scientistNum, goldNum, killNum, udbid, cRId, bId, diff)
					xlDb_Execute(sUpdateM)
				end
			end
		else
			--����һ��������
			local sInsertM = string.format("insert into `tank_billboard`(`uid`, `rid`, `bid`, `diff`, `name`, `stage`, `tank`, `weapon`, `gametime`, `scientist`, `gold`, `kill`, `time`) values(%d, %d, %d, %d, '%s', %d, %d, %d, %d, %d, %d, %d, now())", udbid, cRId, bId, diff, name, stage, tankId, weaponId, gametime, scientistNum, goldNum, killNum)
			xlDb_Execute(sInsertM)
		end
		
		--�ɹ�
		ret = 1
	end
	
	--local sCmd = tostring(ret) .. ";" .. tostring(sL2CCmd)
	--hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_GAMECOIN_CHAGE_HOSTORY, sCmd)
end



--��ѯս�����а�
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_BILLBOARD] = function(udbid, rid, msgId, tCmd)
	--print("��ѯս�����а�", udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local bId = tonumber(tCmd[3]) or 0 --���а�����
	local diff = tonumber(tCmd[4]) or 0 --�Ѷ�
	
	local ret = 0
	local sCmdTemp = ""
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--��ѯ���а�
		local MAXCOUNT = 100
		local sQueryM = nil
		if (bId == hVar.TANK_BILLBOARD_RANK_TYPE.RANK_STAGE) then --ս����ͼ���а�
			sQueryM = string.format("select `uid`, `rid`, `name`, `stage`, `tank`, `weapon`, `gametime`, `scientist`, `gold`, `kill`, `time` from `tank_billboard` where `bid` = %d and `diff` = %d order by `stage` desc, `gametime` asc, `time` asc limit %d", bId, diff, MAXCOUNT)
		elseif (bId == hVar.TANK_BILLBOARD_RANK_TYPE.RANK_CONTINOUSKILL) then --ս����ɱ���а�
			sQueryM = string.format("select `uid`, `rid`, `name`, `stage`, `tank`, `weapon`, `gametime`, `scientist`, `gold`, `kill`, `time` from `tank_billboard` where `bid` = %d and `diff` = %d order by `kill` desc, `stage` desc, `time` asc limit %d", bId, diff, MAXCOUNT)
		end
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("��ѯ���а�:", "errM=", errM, "tTemp=", tTemp)
		if (errM == 0) then
			for n = 1, #tTemp, 1 do
				local rank = n
				local uid = tTemp[n][1]
				local rid = tTemp[n][2]
				local name = tTemp[n][3]
				local stage = tTemp[n][4]
				local tankId = tTemp[n][5]
				local weaponId = tTemp[n][6]
				local gametime = tTemp[n][7]
				local scientistNum = tTemp[n][8]
				local goldNum = tTemp[n][9]
				local killNum = tTemp[n][10]
				local time = tTemp[n][11]
				
				sCmdTemp = sCmdTemp .. tostring(rank) .. ";" .. tostring(uid) .. ";" .. tostring(rid) .. ";" .. tostring(name)
							.. ";" .. tostring(stage) .. ";" .. tostring(tankId) .. ";" .. tostring(weaponId)
							.. ";"  .. tostring(gametime) .. ";" .. tostring(scientistNum) .. ";" .. tostring(goldNum)
							.. ";" .. tostring(killNum) .. ";" .. tostring(time) .. ";"
			end
			
			
			sCmdTemp = tostring(#tTemp) .. ";" .. sCmdTemp
			
			--��ѯ�ҵ�����
			local nameMe = ""
			local stageMe = 0
			local tankMe = 0
			local weaponMe = 0
			local gametimeMe = 0
			local scientistMe = 0
			local goldMe = 0
			local killMe = 0
			local timeMe = ""
			local sQueryM = string.format("select `name`, `stage`, `tank`, `weapon`, `gametime`, `scientist`, `gold`, `kill`, `time` from `tank_billboard` where `uid` = %d and `rid` = %d and `bid` = %d and `diff` = %d", cUId, cRId, bId, diff)
			local errM, name_Me, stage_Me, tank_Me, weapon_Me, gametime_Me, scientist_Me, gold_Me, kill_Me, time_Me = xlDb_Query(sQueryM)
			if (errM == 0) then
				nameMe = name_Me   
				stageMe = stage_Me
				tankMe = tank_Me
				weaponMe = weapon_Me
				gametimeMe = gametime_Me
				scientistMe = scientist_Me
				goldMe = gold_Me
				killMe = kill_Me
				timeMe = time_Me
			end
			
			sCmdTemp = sCmdTemp .. tostring(nameMe) .. ";" .. tostring(stageMe) .. ";" .. tostring(tankMe) .. ";"
								.. tostring(weaponMe) .. ";" .. tostring(gametimeMe) .. ";" .. tostring(scientistMe) .. ";"
								.. tostring(goldMe) .. ";" .. tostring(killMe) .. ";" .. tostring(timeMe) .. ";"
			
			--�ɹ�
			ret = 1
		end
	end
	
	local sCmd = tostring(ret) .. ";" .. tostring(bId) .. ";" .. tostring(diff) .. ";" .. tostring(sCmdTemp)
	--print(sCmd)
	--print(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_TANK_BILLBOARD)
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_TANK_BILLBOARD, sCmd)
end



--�޸�ս�������
__Handler[hVar.DB_OPR_TYPE.C2L_MODIFY_TANK_USERNAME] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local cName = tostring(tCmd[3]) --�����
	local cNameOld = tostring(tCmd[4]) --�ɵ������
	local gameCoin = tonumber(tCmd[5]) or 0 --���ĵ��ʯ
	
	local result = 0
	local info = -3
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--��Ҹ�������id������
		local itemId = 9926
		local itemCost = gameCoin --ս����������Ϸ��
		
		--��ѯ����Ƿ��㹻
		local sQuery = string.format("SELECT gamecoin_online FROM t_user WHERE uid=%d",udbid)
		local err,nMyGameCoin = xlDb_Query(sQuery)
		--print("sQuery:",sQuery,err)
		if err == 0 then
			if nMyGameCoin >= itemCost then
				--��ѯ�����Ƿ��ظ�
				local sql = string.format("SELECT count(*) FROM t_cha WHERE name='%s'",cName)
				local e,count = xlDb_Query(sql)
				--print("sql:",sql,e,count)
				if e == 0 then
					if count <= 0 then
						local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
						
						--�۳���Ϸ��
						local strInfo = tostring(cNameOld) .. " -> " .. tostring(cName)
						local bSuccess, order_id = hGlobal.userCoinMgr:DBUserPurchase(udbid, cRId, itemId, 1, itemCost, 0, strInfo)
						if bSuccess then
							--[[
							--������
							--�µĹ����¼���뵽order��
							local sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,udbid,cRId,itemId,1,sItemName,itemCost,0,cNameOld .. " -> " .. cName)
							--print("sUpdate2:",sUpdate)
							xlDb_Execute(sUpdate)
							]]
							
							--����
							sUpdate = string.format("UPDATE t_cha SET name='%s', nickname='%s' WHERE id = %d",cName,cName,cRId)
							--print("sUpdate3:",sUpdate)
							xlDb_Execute(sUpdate)
							
							sUpdate = string.format("UPDATE cha_dictionary SET name='%s' WHERE id = %d",cName,cRId)
							--print("sUpdate4:",sUpdate)
							xlDb_Execute(sUpdate)
							
							sUpdate = string.format("UPDATE t_user SET customS1='%s' WHERE uid = %d",cName,udbid)
							--print("sUpdate6:",sUpdate)
							xlDb_Execute(sUpdate)
							
							--���а����
							sUpdate = string.format("UPDATE `tank_billboard` SET name = '%s' WHERE uid = %d and rid = %d",cName, udbid, cRId)
							--print("sUpdate7:",sUpdate)
							xlDb_Execute(sUpdate)
							
							result = 1
							
							local err1, orderId = xlDb_Query("select last_insert_id()")
							--print("err1,orderId:",err1,orderId)
							if err1 == 0 then
								info = orderId
							else
							
							end
						else
							info = -1 --Ǯ����
						end
						
					else
						info = -2 --����
					end
				else
					info = -2 --����
				end
			else
				info = -1 --Ǯ����
			end
		else
			info = -1 --Ǯ����
		end
	end
	
	local sL2CCmd = tostring(result) .. ";" .. tostring(info) .. ";" .. tostring(cName) .. ";" .. tostring(gameCoin)
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_TANK_MODIFYNAME, sL2CCmd)
	--print("xlSendScript2Client:",sL2CCmd)
end



--�ϴ�ս���ؿ���־
__Handler[hVar.DB_OPR_TYPE.C2L_UPLOAD_TANK_STAGELOG] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local cName = tostring(tCmd[3]) --�����
	local logId = tonumber(tCmd[4]) or 0 --��־id
	local strVersion = tostring(tCmd[5]) --�汾��
	local strLog = tostring(tCmd[6]) --��־����
	
	local result = 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--����һ���ؿ���¼
		local sUpdate = string.format("INSERT INTO `tank_stagelog`(`uid`, `rid`, `name`, `logId`, `version`, `stageInfo`, `time`) values (%d, %d, '%s', %d, '%s', '%s', now())", cUId, cRId, cName, logId, strVersion, strLog)
		--print("sUpdate2:",sUpdate)
		xlDb_Execute(sUpdate)
		
		--�ɹ�
		result = 1
	end
	
	local sL2CCmd = tostring(result) .. ";" .. tostring(cUId) .. ";" .. tostring(cRId) .. ";" .. tostring(logId)
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_TANK_UPLOAD_STAGELOG, sL2CCmd)
end



--�ϴ�ս��������Ϣ
__Handler[hVar.DB_OPR_TYPE.C2L_UPLOAD_TANK_SCOREINFO] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local cName = tostring(tCmd[3]) --�����
	local strScoreInfo = tostring(tCmd[4]) --������Ϣ
	
	local result = 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--��ѯ��¼�Ƿ����
		local sql = string.format("select * from `tank_user_score` WHERE `uid` = %d and `rid` = %d", cUId, cRId)
		local err = xlDb_Query(sql)
		if (err == 0) then
			--���¼�¼
			local sUpdate = string.format("update `tank_user_score` set `name` = '%s', `scoreInfo` = '%s', `time` = now() where `uid` = %d and `rid` = %d", cName, strScoreInfo, cUId, cRId)
			--print("sUpdate2:",sUpdate)
			xlDb_Execute(sUpdate)
		else
			--����һ���ؿ���¼
			local sUpdate = string.format("INSERT INTO `tank_user_score` (`uid`, `rid`, `name`, `scoreInfo`, `time`) values (%d, %d, '%s', '%s', now())", cUId, cRId, cName, strScoreInfo)
			--print("sUpdate2:",sUpdate)
			xlDb_Execute(sUpdate)
		end
		
		--�ɹ�
		result = 1
	end
	
	--local sL2CCmd = tostring(result) .. ";" .. tostring(cUId) .. ";" .. tostring(cRId) .. ";" .. tostring(logId)
	--hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_TANK_UPLOAD_STAGELOG, sL2CCmd)
end


--��ѯս����������
__Handler[hVar.DB_OPR_TYPE.C2L_QUERY_TANK_YESTERDAY_RANK] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		rank = hGlobal.tankbbMgr:QueryRank(cUId, cRId)
	end
	
	local sL2CCmd = tostring(cUId) .. ";" .. tostring(cRId) .. ";" .. tostring(rank)
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_TANK_YESTERDAY_RANK, sL2CCmd)
end

--��ȡս��������������
__Handler[hVar.DB_OPR_TYPE.C2L_REWARD_TANK_YESTERDAY_RANK] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local cName = tostring(tCmd[3]) --�����
	local strScoreInfo = tostring(tCmd[4]) --������Ϣ
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		rank = hGlobal.tankbbMgr:QueryRank(cUId, cRId)
	end
	
	local sL2CCmd = tostring(cUId) .. ";" .. tostring(cRId) .. ";" .. tostring(rank)
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_RECEIVE_TANK_YESTERDAY_RANK, sL2CCmd)
end

--��ѯս������ǹͬ����Ϣ
__Handler[hVar.DB_OPR_TYPE.C2L_QUERY_TANK_WEAPON_INFO] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--��ѯ����ǹ��Ϣ
		local tankWeapon = hClass.TankWeapon:create():Init(cUId,cRId)
		local sL2CCmd = tankWeapon:QueryInfo()
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_WEAPON_INFO_RET, sL2CCmd)
	end
end

--����ս������ǹ����
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_WEAPON_STARUP] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local weaponId = tonumber(tCmd[3]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--��ѯ����ǹ��Ϣ
		local tankWeapon = hClass.TankWeapon:create():Init(cUId,cRId)
		local sL2CCmd, ret, nNewStar, nNewLevel = tankWeapon:StarUp(weaponId)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_WEAPON_STARUP_RET, sL2CCmd)

		-- ���ǳɹ�
		if ret == 1 then
			local starNum = nNewStar-1
			-- ֪ͨ�����ð��
			local strUserName = "" -- �����
			local nChannelId = 0 -- ����id
			local strNoticeInfo = tostring(starNum) -- �Ǽ�
			local sql = string.format("SELECT `name` FROM `t_cha` where `id` = %d", cRId)
			local err, name = xlDb_Query(sql)
			if (err == 0) then
				if type(name) == "string" and #name > 0 then
					strUserName = name

					local sL2CCmd = hGlobal.bubblleNoticeMgr:AddBubbleNotice(cUId, cRId, hVar.BUBBLE_NOTICE_TYPE.WEAPON_STARUP,
						strUserName, nChannelId, strNoticeInfo, weaponId)
				end

				-- ��������ǹ�����������������
				local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(cUId, cRId)
				local addCount = 1
				taskMgr:AddTaskFinishCount(hVar.TASK_TYPE.TASK_UPGRADE_WEAPON_TIMES, addCount)
			end
		end
	end
end

--[[
--����ս������ǹ�Ӿ���ֵ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_WEAPON_ADDEXP] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local weaponId = tonumber(tCmd[3]) or 0
	local expAdd = tonumber(tCmd[4]) or 0
	
	local rank = 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--��ѯ����ǹ��Ϣ
		local tankWeapon = hClass.TankWeapon:create():Init(cUId,cRId)
		local sL2CCmd = tankWeapon:AddExp(weaponId, expAdd)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_WEAPON_ADDEXP_RET, sL2CCmd)
	end
end
]]

--����ս������ǹ����
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_WEAPON_LEVELUP] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local weaponId = tonumber(tCmd[3]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--��ѯ����ǹ��Ϣ
		local tankWeapon = hClass.TankWeapon:create():Init(cUId,cRId)
		local sL2CCmd, ret = tankWeapon:LevelUp(weaponId)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_WEAPON_LEVELUP_RET, sL2CCmd)

		-- �ɹ�
		if ret == 1 then
			-- ��������ǹ�������������
			local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(cUId, cRId)
			local addCount = 1
			taskMgr:AddTaskFinishCount(hVar.TASK_TYPE.TASK_UPGRADE_WEAPON_TIMES, addCount)
		end
	end
end

--��ѯս�����ܵ���ͬ����Ϣ
__Handler[hVar.DB_OPR_TYPE.C2L_QUERY_TANK_TALENTPOINT_INFO] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--��ѯ����ǹ��Ϣ
		local tanktalentPoint = hClass.TankTalentPoint:create():Init(cUId,cRId)
		local sL2CCmd = tanktalentPoint:QueryInfo()
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_TALENTPOINT_INFO_RET, sL2CCmd)
	end
end

--����ս���Ӿ���ֵ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_TALENTPOINT_ADDEXP] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local tankId = tonumber(tCmd[3]) or 0
	local expAdd = tonumber(tCmd[4]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--��ѯս����Ϣ
		local tanktalentPoint = hClass.TankTalentPoint:create():Init(cUId,cRId)
		local sL2CCmd = tanktalentPoint:AddExp(tankId, expAdd)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_TALENTPOINT_ADDEXP_RET, sL2CCmd)
	end
end

--����ս���������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_TALENTPOINT_ADDPOINT] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local tankId = tonumber(tCmd[3]) or 0
	local talentId = tonumber(tCmd[4]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--��ѯս����Ϣ
		local tanktalentPoint = hClass.TankTalentPoint:create():Init(cUId,cRId)
		local sL2CCmd = tanktalentPoint:AddPoint(tankId, talentId)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_TALENTPOINT_ADDPOINT_RET, sL2CCmd)
	end
end

--����ս�������츳����
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_TALENTPOINT_RESTORE] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local tankId = tonumber(tCmd[3]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--��ѯս����Ϣ
		local tanktalentPoint = hClass.TankTalentPoint:create():Init(cUId,cRId)
		local sL2CCmd = tanktalentPoint:Restore(tankId)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_TALENTPOINT_RESTORE_RET, sL2CCmd)
	end
end

--��ѯս������ͬ����Ϣ
__Handler[hVar.DB_OPR_TYPE.C2L_QUERY_TANK_PET_INFO] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--��ѯ������Ϣ
		local tankPet = hClass.TankPet:create():Init(cUId,cRId)
		local sL2CCmd = tankPet:QueryInfo()
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_PET_INFO_RET, sL2CCmd)
	end
end

--����ս����������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_PET_STARUP] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local petId = tonumber(tCmd[3]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--��ѯ������Ϣ
		local tankPet = hClass.TankPet:create():Init(cUId,cRId)
		local sL2CCmd, ret, nNewStar, nNewLevel = tankPet:StarUp(petId)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_PET_STARUP_RET, sL2CCmd)
		
		-- ���ǳɹ�
		if ret == 1 then
			local starNum = nNewStar-1
			-- ֪ͨ�����ð��
			local strUserName = "" -- �����
			local nChannelId = 0 -- ����id
			local strNoticeInfo = tostring(starNum) -- �Ǽ�
			local sql = string.format("SELECT `name` FROM `t_cha` where `id` = %d", cRId)
			local err, name = xlDb_Query(sql)
			if (err == 0) then
				if type(name) == "string" and #name > 0 then
					strUserName = name

					local sL2CCmd = hGlobal.bubblleNoticeMgr:AddBubbleNotice(cUId, cRId, hVar.BUBBLE_NOTICE_TYPE.PET_STARUP,
						strUserName, nChannelId, strNoticeInfo, petId)
				end

				-- ����������������������
				local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(cUId, cRId)
				local addCount = 1
				taskMgr:AddTaskFinishCount(hVar.TASK_TYPE.TASK_UPGRADE_PET_TIMES, addCount)
			end
		end
	end
end

--[[
--����ս������Ӿ���ֵ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_PET_ADDEXP] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local petId = tonumber(tCmd[3]) or 0
	local expAdd = tonumber(tCmd[4]) or 0
	
	local rank = 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--��ѯ������Ϣ
		local tankPet = hClass.TankPet:create():Init(cUId,cRId)
		local sL2CCmd = tankPet:AddExp(petId, expAdd)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_PET_ADDEXP_RET, sL2CCmd)
	end
end
]]

--����ս����������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_PET_LEVELUP] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local petId = tonumber(tCmd[3]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--��ѯ������Ϣ
		local tankPet = hClass.TankPet:create():Init(cUId,cRId)
		local sL2CCmd, ret = tankPet:LevelUp(petId)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_PET_LEVELUP_RET, sL2CCmd)

		-- �ɹ�
		if ret then
			-- �������������������
			local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(cUId, cRId)
			local addCount = 1
			taskMgr:AddTaskFinishCount(hVar.TASK_TYPE.TASK_UPGRADE_PET_TIMES, addCount)
		end
	end
end

--��ѯս����ͬ����Ϣ
__Handler[hVar.DB_OPR_TYPE.C2L_QUERY_TANK_TACTIC_INFO] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sql = string.format("SELECT `tacticInfo` FROM `t_pvp_user` where id = %d", rid)
		local err, tacticInfo = xlDb_Query(sql)
		if (err == 0) then
			--
		elseif (err == 4) then
			tacticInfo = ""
			local sql1= string.format("SELECT `name` FROM `t_cha` WHERE id = %d", rid)
			local err1, name = xlDb_Query(sql1)
			if err1 then
				local sql2 = string.format("INSERT INTO t_pvp_user (id, uid,`name`) values (%d, %d, '%s')", rid, udbid, tostring(name))
				local err2 = xlDb_Execute(sql2)
				if err2 == 0 then
				end
			end
		end
		
		--��ѯս������Ϣ
		local tacticMgr = hClass.TacticMgr:create():Init(tacticInfo)
		local sL2CCmd = tacticMgr:InfoToCmd()
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_TACTIC_INFO_RET, sL2CCmd)
	end
end

--����ս��������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_TACTIC_LEVELUP] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local tacticId = tonumber(tCmd[3]) or 0 --ս����id
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sql = string.format("SELECT `tacticInfo` FROM `t_pvp_user` where id = %d", rid)
		local err, tacticInfo = xlDb_Query(sql)
		if (err == 0) then
			--
		elseif (err == 4) then
			tacticInfo = ""
			local sql1= string.format("SELECT `name` FROM `t_cha` WHERE id = %d", rid)
			local err1, name = xlDb_Query(sql1)
			if err1 then
				local sql2 = string.format("INSERT INTO t_pvp_user (id, uid,`name`) values (%d, %d, '%s')", rid, udbid, tostring(name))
				local err2 = xlDb_Execute(sql2)
				if err2 == 0 then
				end
			end
		end
		
		--��ѯս������Ϣ
		local tacticMgr = hClass.TacticMgr:create():Init(tacticInfo)
		local ret, sL2CCmd = tacticMgr:TacticLevelUp(cUId, cRId, tacticId)
		if (ret == 1) then
			--����
			local tacticCmd = tacticMgr:InfoToCmd()
			local sUpdate = string.format("UPDATE `t_pvp_user` SET `tacticInfo` = '%s' where `id` = %d", tacticCmd, rid)
			--print("sUpdate1:",sUpdate)
			xlDb_Execute(sUpdate)

			-- ��������ս�����������
			local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(cUId, cRId)
			local addCount = 1
			taskMgr:AddTaskFinishCount(hVar.TASK_TYPE.TASK_UPGRADE_TACTICAL_CARD_TIMES, addCount)
		end
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_TACTIC_LEVELUP_RET, sL2CCmd)
	end
end

--�����������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_CLEARDATA] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local tacticId = tonumber(tCmd[3]) or 0 --ս����id
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--�������
		local sL2CCmd = hGlobal.sysCfg:ClearData(cUId, cRId)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_CLEARDATA_RET, sL2CCmd)
	end
end

--����ս�������ڿ�
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_PET_WAKUANG] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local petId = tonumber(tCmd[3]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--�����ڿ�
		local tankPet = hClass.TankPet:create():Init(cUId,cRId)
		local sL2CCmd = tankPet:SendWaKuang(petId)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_PET_WAKUANG_RET, sL2CCmd)
	end
end

--����ս������������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_PET_WATILI] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local petId = tonumber(tCmd[3]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--����������
		local tankPet = hClass.TankPet:create():Init(cUId,cRId)
		local sL2CCmd = tankPet:SendWaTiLi(petId)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_PET_WATILI_RET, sL2CCmd)
	end
end

--����ս������ȡ���ڿ�
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_PET_CANCEL_WAKUANG] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local petId = tonumber(tCmd[3]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--����ȡ���ڿ�
		local tankPet = hClass.TankPet:create():Init(cUId,cRId)
		local sL2CCmd = tankPet:CancelWaKuang(petId)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_PET_CANCEL_WAKUANG_RET, sL2CCmd)
	end
end

--����ս������ȡ��������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_PET_CANCEL_WATILI] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local petId = tonumber(tCmd[3]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--�����ڿ�
		local tankPet = hClass.TankPet:create():Init(cUId,cRId)
		local sL2CCmd = tankPet:CancelWaTiLi(petId)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_PET_CANCEL_WATILI_RET, sL2CCmd)
	end
end

--�����ѯ����������Ϣ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_TILI_INFO] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--��ѯ����������Ϣ
		local tiliMgr = hClass.TiLiMgr:create():Init(cUId,cRId)
		local sL2CCmd = tiliMgr:QueryInfo()
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_TILI_INFO_RET, sL2CCmd)
	end
end

--����һ�����
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_TILI_EXCHANGE] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--�����ڿ�
		local tiliMgr = hClass.TiLiMgr:create():Init(cUId,cRId)
		local sL2CCmd = tiliMgr:ExchangeTiLi()
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_TILI_EXCHANGE_RET, sL2CCmd)
	end
end

--������ȡ�ڿ��ʯ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_ADDONES_KESHI] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--�����ڿ�
		local tiliMgr = hClass.TiLiMgr:create():Init(cUId,cRId)
		local sL2CCmd = tiliMgr:TakeRewardKeShi()
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_ADDONES_KESHI_RET, sL2CCmd)
	end
end

--������ȡ�ڿ�����
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_ADDONES_TILI] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--�����ڿ�
		local tiliMgr = hClass.TiLiMgr:create():Init(cUId,cRId)
		local sL2CCmd = tiliMgr:TakeRewardTiLi()
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_ADDONES_TILI_RET, sL2CCmd)
	end
end

--������ȡ�ڿ���
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_ADDONES_CHEST] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--�����ڱ���
		local tiliMgr = hClass.TiLiMgr:create():Init(cUId,cRId)
		local sL2CCmd = tiliMgr:TakeRewardChest()
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_ADDONES_CHEST_RET, sL2CCmd)
	end
end

--�����ѯ�����£��Ľ���
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TASK_QUERY_STATE] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local nChannelId = tonumber(tCmd[3]) --������
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--��ѯÿ�������£�
		local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(cUId, cRId)
		local sL2CCmd = taskMgr:QueryTaskState(nChannelId)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_TASK_QUERY_RET, sL2CCmd)
	end
end

--�������������£�����
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TASK_TYPE_FINISH] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local taskType = tonumber(tCmd[3]) or 0 --��������
	local addCount = tonumber(tCmd[4]) or 0 --��ɴ���
	
	local ret = 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--����ÿ�������£�
		--�ɿͻ����ϴ�
		--local taskType = hVar.TASK_TYPE.TASK_REFRESH_SHOP --�ɿͻ����ϴ�
		--local addCount = 1
		local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(cUId, cRId)
		taskMgr:AddTaskFinishCount(taskType, addCount)
		
		--�ɹ�
		ret = 1
	end
	
	--local sCmd = tostring(ret) .. ";" .. tostring(sL2CCmd)
	--hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_PVPCOIN_CHAGE_HOSTORY, sCmd)
end

--������ȡ��������£��Ľ���
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TASK_TAKEREWARD] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local taskId = tonumber(tCmd[3]) or 0 --����id
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--��ѯÿ�������£�
		local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(cUId, cRId)
		local sL2CCmd = taskMgr:TaskTakeReward(taskId)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_TASK_TAKEREWARD_RET, sL2CCmd)
	end
end

--����һ����ȡȫ���Ѵ�������£��Ľ���
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TASK_TAKEREWARD_ALL] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--��ѯÿ�������£�
		local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(cUId, cRId)
		local sL2CCmd = taskMgr:TaskTakeAllReward()
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_TASK_TAKEREWARD_ALL_RET, sL2CCmd)
	end
end

--������ȡ�������£����Ƚ���
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TASK_WEEK_REWARD] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local index = tonumber(tCmd[3]) or 0 --����������λ
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--��ȡ�������£����Ƚ���
		local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(cUId, cRId)
		local sL2CCmd = taskMgr:WeekTakeReward(index)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_TASK_WEEK_REWARD_RET, sL2CCmd)
	end
end

--������ȡ���۽������£�
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_TAKEREWAED] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		if (udbid == cUId) then
			local commentId = 18
			local ret = 0
			
			--��ȡ����Ƿ�����ȡ������
			local sql = string.format("SELECT `id` FROM `prize` WHERE `uid` = %d and `type` = %d", udbid, commentId)
			local errM, id = xlDb_Query(sql)
			--print("sql:",sql, errM, id)
			if (errM == 0) then --�м�¼
				ret = -1 --��������ȡ
			elseif (errM == 4) then --�޼�¼
				local sql = string.format("SELECT `content_in` FROM `actionconfig` WHERE `type` = %d", commentId)
				local err, detail = xlDb_Query(sql)
				if (err == 0) then
					--���뽱��������ȡ��
					local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",udbid,commentId,detail,2,0)
					--print(sInsert)
					xlDb_Execute(sInsert)
					
					--�����ʼ�����������ʱ����30���Ӻ�
					local sTimeNow = os.date("%Y-%m-%d %H:%M:%S", os.time())
					local nCreateTime = hApi.GetNewDate(sTimeNow, "MINUTE", 30)
					local sCreateTime = os.date("%Y-%m-%d %H:%M:%S", nCreateTime)
					local prizeType2 = 20041 --��л�Ŵ��б�������ĵĽ���
					local detail2 = hVar.tab_string["__TEXT_MAIL_COMMENT_PRIZE"]
					local sInsert = string.format("insert into `prize`(uid,type,mykey,used,`create_time`, create_id) values (%d,%d,'%s',%d,'%s',%d)",udbid,prizeType2,detail2,0,sCreateTime,0)
					--print(sInsert)
					xlDb_Execute(sInsert)
					
					--�����ɹ�
					ret = 1
				else
					ret = -2 --��Ч�Ĳ���
				end
			end
			
			local sL2CCmd = tostring(ret) .. ";"
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_COMMENT_REWARD_RET, sL2CCmd)
		end
	end
end

--GM�����͵���ָ��
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_DEBUG] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		if (udbid == cUId) then
			local sql = string.format("SELECT bTester FROM t_user where uid=%d",udbid)
			local err, bTester = xlDb_Query(sql)
			--print("bTester=", bTester)
			if err == 0 then
				if bTester == 2 then
					print("hVar.DB_OPR_TYPE.C2L_REQUIRE_DEBUG:", udbid, rid)
					dofile("scripts/test.lua")
				end
			end
		end
	end
end

--�ͻ��˲�ѯ�����14��ǩ����������Ƿ������ȡ����
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_ACTIVITY_TODAY_STATE] = function(udbid, rid, msgId, tCmd)
	local cUId = tonumber(tCmd[1])
	local cRId = tonumber(tCmd[2])
	local cAId = tonumber(tCmd[3]) --�id
	local nChannelId = tonumber(tCmd[4]) --������
	
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		if (udbid == cUId) then
			--��ѯ�������ǩ���״̬
			if hClass.ActivitySignIn then
				local signIn = hClass.ActivitySignIn:create("ActivitySignIn"):Init(udbid, rid, cAId, nChannelId)
				local sL2CCmd = signIn:QueryFinishState()
				hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ACTIVITY_TODAY_STATE, sL2CCmd)
			end
		end
	end
end

--�����14��ǩ���������ǩ��
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_ACTIVITY_TODAY_SIGNIN] = function(udbid, rid, msgId, tCmd)
	local cUId = tonumber(tCmd[1])
	local cRId = tonumber(tCmd[2])
	local cAId = tonumber(tCmd[3]) --�id
	local nChannelId = tonumber(tCmd[4]) --������
	local nProgress = tonumber(tCmd[5]) --ǩ���Ľ���
	
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		if (udbid == cUId) then
			--��ҽ���ǩ��
			if hClass.ActivitySignIn then
				local signIn = hClass.ActivitySignIn:create("ActivitySignIn"):Init(udbid, rid, cAId, nChannelId)
				local sL2CCmd = signIn:TodaySingIn(nProgress)
				hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ACTIVITY_TODAY_SIGNIN, sL2CCmd)
			end
		end
	end
end

--�����14��ǩ����������ػ����
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_ACTIVITY_SIGNIN_BUYGIFT] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1])
	local cRId = tonumber(tCmd[2])
	local cAId = tonumber(tCmd[3]) --�id
	local nChannelId = tonumber(tCmd[4]) --������
	local nProgress = tonumber(tCmd[5]) --����Ľ���
	
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print("user=", user)
	if user then
		if (udbid == cUId) then
			--��ҹ����ػ����
			if hClass.ActivitySignIn then
				local signIn = hClass.ActivitySignIn:create("ActivitySignIn"):Init(udbid, rid, cAId, nChannelId)
				local sL2CCmd = signIn:BuyGift(nProgress)
				hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ACTIVITY_SIGNIN_BUYGIFT, sL2CCmd)
			end
		end
	end
end

--��ȡϵͳ�ʼ��б��£�
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_SYSTEM_MAIL_LIST] = function(udbid, rid, msgId, tCmd)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_SYSTEM_MAIL_LIST:",uid,nOpr,sCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local nChannelId = tonumber(tCmd[3]) --������
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		local NUM = 0
		
		--��ѯ��ҽ�50��δ��Ľ�������ʣ����ȡ�������ƣ�
		local sQueryM = string.format("select `id`, `type`, `mykey` from `prize` where `uid` = %d and (`rid` = %d or `rid` = 0) and `used` = 0 and `days` < 0 order by `id` desc limit 50", cUId, cRId)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("��ѯ��ҽ�50��δ��Ľ�������ʣ����ȡ�������ƣ�", "errM=", errM, "tTemp=", tTemp)
		if (errM == 0) then
			--�洢����
			NUM = NUM + #tTemp
			
			for n = 1, #tTemp, 1 do
				local id = tTemp[n][1]
				local nType = tTemp[n][2]
				local mykey = tTemp[n][3]
				
				sL2CCmd = sL2CCmd .. tostring(id) .. "#" .. tostring(nType) .. "#" .. tostring(mykey) .. "#" .. tostring(-1) .. "#"
			end
		end
		
		--��ѯ���ȫ��δ��Ľ�������ʣ����ȡ�����ڣ�
		local nTimeStampNow = os.time()
		local sQueryM = string.format("select `id`, `type`, `mykey`, `create_time`, `days` from `prize` where `uid` = %d and (`rid` = %d or `rid` = 0) and `used` = 0 and `days` > 0 and (NOW() <= DATE_ADD(`create_time`, INTERVAL + `days` DAY)) and `create_time` < NOW() order by `id` desc", cUId, cRId)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("��ѯ���ȫ��δ��Ľ�������ʣ����ȡ�����ڣ�", "errM=", errM, "tTemp=", tTemp)
		if (errM == 0) then
			--�洢����
			NUM = NUM + #tTemp
			
			for n = 1, #tTemp, 1 do
				local id = tTemp[n][1]
				local nType = tTemp[n][2]
				local mykey = tTemp[n][3]
				local create_time = tTemp[n][4]
				local days = tTemp[n][5]
				--local nTimestampCreate = hApi.GetNewDate(create_time)
				local nTimestampEnd = hApi.GetNewDate(create_time, "DAY", days)
				local deltatime = nTimestampEnd - nTimeStampNow
				
				sL2CCmd = sL2CCmd .. tostring(id) .. "#" .. tostring(nType) .. "#" .. tostring(mykey) .. "#" .. tostring(deltatime) .. "#"
			end
		end
		
		--��ѯϵͳ����
		local NUM_NOTICE = 0
		local sL2CCmdNotice = ""
		local sQueryM = string.format("select `id`, `mailid`, `mailinfo`, `time_begin`, `days` from `system_mail` where `valid` = 1 and (`channelid` = %d or `channelid` = 0) order by `id` asc limit 100", nChannelId)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("��ѯϵͳ����:", "errM=", errM, "tTemp=", tTemp)
		if (errM == 0) then
			--���ʱ����Ч��
			for n = 1, #tTemp, 1 do
				local id = tTemp[n][1]
				local mailid = tTemp[n][2]
				local mailinfo = tTemp[n][3]
				local time_begin = tTemp[n][4]
				local days = tTemp[n][5]
				
				local nTimestampBegin = hApi.GetNewDate(time_begin)
				local nTimestampEnd = hApi.GetNewDate(time_begin, "DAY", days)
				--print("n", n)
				--print("nTimestampBegin", nTimestampBegin)
				--print("nTimestampEnd", nTimestampEnd)
				--print("nTimeStampNow", nTimeStampNow)
				if (nTimeStampNow >= nTimestampBegin) and (nTimeStampNow <= nTimestampEnd) then --��Ч
					NUM_NOTICE = NUM_NOTICE + 1
					sL2CCmdNotice = sL2CCmdNotice .. tostring(id) .. "#" .. tostring(mailid) .. "#" .. tostring(mailinfo) .. "#" .. tostring(-1) .. "#"
				end
			end
		end
		
		sL2CCmd = tostring(NUM+NUM_NOTICE) .. "#" .. sL2CCmdNotice .. sL2CCmd
		
		--print(sL2CCmd)
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_SYSTEM_MAIL_LIST_RET, sL2CCmd)
	end
end

--����һ����ȡȫ���ʼ�
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_SYSTEM_MAIL_REWAR_ALL] = function(udbid, rid, msgId, tCmd)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_SYSTEM_MAIL_REWAR_ALL:",uid,nOpr,sCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local nChannelId = tonumber(tCmd[3]) --������
	local nTotalNum = tonumber(tCmd[4]) --�ʼ�������
	local strIdList = tostring(tCmd[5]) --�ʼ�id�б�
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local tCmdList = hApi.Split(strIdList,":")
		local tPrizeIdList = {}
		for i = 1, nTotalNum, 1 do
			tPrizeIdList[#tPrizeIdList+1] = tonumber(tCmdList[i]) or 0
		end
		
		local sL2CCmd = hApi.GetRewardInPrize_Multy(udbid, cRId, tPrizeIdList)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_SYSTEM_MAIL_REWARD_ALL_RET, sL2CCmd)
	end
end

--�����ѯ���ػ�װ����Ϣ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_GIFT_EQUIP_INFO] = function(udbid, rid, msgId, tCmd)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_GIFT_EQUIP_INFO:",uid,nOpr,sCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local nChannelId = tonumber(tCmd[3]) --������
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--��ѯ�ػ�װ����Ϣ
		local tankGiftEquip = hClass.TankGiftEquip:create():Init(cUId,cRId)
		local sL2CCmd = tankGiftEquip:QueryInfo()
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_GIFT_EQUIP_INFO_RET, sL2CCmd)
	end
end

--�������ػ�װ��
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_GIFT_EQUIP_BUYITEM] = function(udbid, rid, msgId, tCmd)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_GIFT_EQUIP_BUYITEM:",uid,nOpr,sCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local nChannelId = tonumber(tCmd[3]) --������
	local shopIdx = tonumber(tCmd[4]) --��Ʒ����
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--�����ػ�װ��
		local tankGiftEquip = hClass.TankGiftEquip:create():Init(cUId,cRId)
		local sL2CCmd = tankGiftEquip:BuyItem(shopIdx)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_GIFT_EQUIP_BUYITEM_RET, sL2CCmd)
	end
end

--������ȡ������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_SHARE_REWARD] = function(udbid, rid, msgId, tCmd)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_SHARE_REWARD:",uid,nOpr,sCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local nChannelId = tonumber(tCmd[3]) --������
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local ret = 0
		local shareCount = 0
		
		--��ȡ��ҽ�����ȡ�������Ĵ���
		local sql = string.format("SELECT `share_reward_count`, `share_reward_lasttime` FROM `t_user` WHERE `uid` = %d", cUId)
		local errM, share_reward_count, share_reward_lasttime = xlDb_Query(sql)
		--print("sql:",sql, errM, id)
		if (errM == 0) then --�м�¼
			shareCount = share_reward_count
			
			--����Ƿ񵽵ڶ��죬���ô���
			local tab1 = os.date("*t", hApi.GetNewDate(share_reward_lasttime))
			local tab2 = os.date("*t", os.time())
			if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --���˵ڶ���
				shareCount = 0
			end
			
			--[[
			--����ÿ�������£�
			--��������
			local taskType = hVar.TASK_TYPE.TASK_SHARE_COUINT --��������
			local addCount = 1
			local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(udbid, cRId)
			taskMgr:AddTaskFinishCount(taskType, addCount)
			]]
			
			--δ��������
			if (shareCount < hVar.ROLE_DAILY_SHAREREWARD_MAXCOUNT) then
				--�����ʼ�����������ʱ����10���Ӻ�
				local sTimeNow = os.date("%Y-%m-%d %H:%M:%S", os.time())
				local nCreateTime = hApi.GetNewDate(sTimeNow, "MINUTE", 10)
				local sCreateTime = os.date("%Y-%m-%d %H:%M:%S", nCreateTime)
				local prizeType2 = 20042 --�����Ŵ��б�������ĵĽ���
				local detail2 = hVar.tab_string["__TEXT_MAIL_SHARE_PRIZE"]
				local sInsert = string.format("insert into `prize`(uid,type,mykey,used,`create_time`, create_id) values (%d,%d,'%s',%d,'%s',%d)",cUId,prizeType2,detail2,0,sCreateTime,0)
				--print(sInsert)
				xlDb_Execute(sInsert)
				
				--�콱������1
				shareCount = shareCount + 1
				
				--������ҵĽ�����ȡ�������Ĵ���
				local sUpdate = string.format("UPDATE `t_user` SET `share_reward_count` = %d, `share_reward_lasttime` = NOW() WHERE `uid` = %d", shareCount, cUId)
				--print("sUpdate1:",sUpdate)
				xlDb_Execute(sUpdate)
				
				--�����ɹ�
				ret = 1
			else
				ret = -2 --�����콱�����ﵽ����
			end
		else
			ret = -1 --��Ч�Ĳ���
		end
		
		local sL2CCmd = tostring(ret) .. ";" .. tostring(shareCount) .. ";"
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_SHARE_REWARD_RET, sL2CCmd)
	end
end

--���������Ƭ��������Ա���ã�
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_GM_ADDDEBRIS] = function(udbid, rid, msgId, tCmd)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_GM_ADDDEBRIS:",uid,nOpr,sCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local addDebris = tonumber(tCmd[3]) or 0 --���ӵ���Ƭ����
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--print("user=", user)
		if user then
			local result = 0
			--if user:IsTesters() then
			if true then
				--����
				local sUpdate = string.format("UPDATE `t_user` SET `gamecoin_online` = `gamecoin_online` + %d, `weapon_chest` = `weapon_chest` + %d, `tactic_chest` = `tactic_chest` + %d, `pet_chest` = `pet_chest` + %d, `equip_chest` = `equip_chest` + %d, `equip_crystal` = `equip_crystal` + %d, `pvpcoin` = `pvpcoin` + %d, `dishu_coin` = `dishu_coin` + %d WHERE `uid` = %d", addDebris, addDebris, addDebris, addDebris, addDebris, addDebris, addDebris, addDebris, cUId)
				--print("sUpdate1:",sUpdate)
				xlDb_Execute(sUpdate)
				
				--�����ɹ�
				result = 1
			else
				result = -1 --��û��Ȩ�޽��д˲���
			end
			
			local sL2CCmd = tostring(result) .. ";" .. tostring(addDebris) .. ";" .. tostring(addDebris) .. ";" .. tostring(addDebris) .. ";" .. tostring(addDebris) .. ";" .. tostring(addDebris) .. ";" .. tostring(addDebris) .. ";" .. tostring(addDebris) .. ";" .. tostring(addDebris) .. ";"
			
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_GM_ADDDEBRIS_RET, sL2CCmd)
		end
	end
end

--��ѯս����ͼͬ����Ϣ
__Handler[hVar.DB_OPR_TYPE.C2L_QUERY_TANK_MAP_INFO] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local sL2CCmd = ""
		
		--��ѯ��ͼ��Ϣ
		local tankMap = hClass.TankMap:create():Init(cUId,cRId)
		local sL2CCmd = tankMap:QueryInfo()
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_MAP_INFO_RET, sL2CCmd)
	end
end

--������Ϸ��ս������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_REBIRTH] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local battlecfg_id = tonumber(tCmd[3]) or 0 --ս��id
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local pvpcoin_num = 0
		local ret = 0
		
		--��ѯ��ұ�������
		local sql = string.format("SELECT `pvpcoin` FROM `t_user` WHERE `uid` = %d", udbid)
		local errM, coin = xlDb_Query(sql)
		--print("sql:",sql,e,count)
		if (errM == 0) then
			pvpcoin_num = coin
		end
		
		--��Ʒ��Ϣ
		local shopItemId = 648 --ս������
		local tShopItem = hVar.tab_shopitem[shopItemId]
		local rmbCost = tShopItem.rmb --������Ϸ��
		local scoreCost = tShopItem.score --���Ļ���
		local pvpcoinCost = tShopItem.pvpcoin
		
		--�۳�����
		if (pvpcoin_num >= pvpcoinCost) then
			local sql = string.format("UPDATE `t_user` SET `pvpcoin` = `pvpcoin` - %d WHERE uid= %d", pvpcoinCost, udbid)
			local err = xlDb_Execute(sql)
			--print("DBBuyPvpCoin:",err,sql)
			
			--������
			--�µĹ����¼���뵽order��
			
			--���±�������
			pvpcoin_num = pvpcoin_num - pvpcoinCost
			
			local itemId = tShopItem.itemID
			local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
			local strInfo = tostring(mapName) .. ";" .. tostring(mapDiff) .. ";"
			sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,udbid,cRId,itemId,1,sItemName,rmbCost,scoreCost,strInfo)
			--print("sUpdate2:",sUpdate)
			xlDb_Execute(sUpdate)
			
			--[[
			--����ÿ�������£�
			--�������ˣ�ȺӢ��
			local taskType = hVar.TASK_TYPE.TASK_PVPTOKEN_USE --�������ˣ�ȺӢ��
			local addCount = hVar.ENDLESS_BATTLE_COST_PVPCOIN
			local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(udbid, cRId)
			taskMgr:AddTaskFinishCount(taskType, addCount)
			]]
			
			ret = 1 --�ɹ�
		else
			ret = -1 --��������
		end
		
		local sL2CCmd = tostring(ret) .. ";" .. tostring(pvpcoin_num) .. ";"  .. tostring(battlecfg_id) .. ";" .. tostring(scoreCost) .. ";" .. tostring(pvpcoinCost) .. ";"
		
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_REBIRTH_RET, sL2CCmd)
	end
end

--�����ѯ�ɾ�������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_ACHIEVEMENT_QUERY] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--��ѯ�ɾ�
		local achievementMgr = hClass.Achievement:create("Achievement"):Init(cUId, cRId)
		local sL2CCmd = achievementMgr:QueryInfo()
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ACHIEVEMENT_QUERY_RET, sL2CCmd)
	end
end

--������ȡ�ɾͽ���
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_ACHIEVEMENT_TAKEREWARD] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local medalId = tonumber(tCmd[3]) or 0 --�ɾ�id
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--��ȡ�ɾ�
		local achievementMgr = hClass.Achievement:create("Achievement"):Init(cUId, cRId)
		local sL2CCmd = achievementMgr:TakeReward(medalId)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ACHIEVEMENT_TAKEREWARD_RET, sL2CCmd)
	end
end

--[[
--�����ѯ����Թ����а�
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_RANDOMMAP_BOLLBOARD] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--��ȡ�ɾ�
		local achievementMgr = hClass.Achievement:create("Achievement"):Init(cUId, cRId)
		local sL2CCmd = achievementMgr:TakeReward(medalId)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ACHIEVEMENT_TAKEREWARD_RET, sL2CCmd)
	end
end
]]

--����״̬����
__Handler[hVar.DB_OPR_TYPE.C2L_ORDER_UPDATE] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local cOrderId = tonumber(tCmd[3])
	local flag = tonumber(tCmd[4])
	--local strTag = tCmd[5] --�����ж���ֺ�;
	local strTag = ""
	for i = 5, 100, 1 do
		if tCmd[i] and (tCmd[i] ~= "") then
			strTag = strTag .. tostring(tCmd[i]) .. ";"
		end
	end
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--���¶�����Ϣ
		local sUpdate = string.format("UPDATE `order` SET `flag` = %d, `ext_01` = CONCAT(IFNULL(`ext_01`, ''), '%s') WHERE `id` = %d and `uid` = %d", flag, strTag, cOrderId, cUId)
		--print("sUpdate1:",sUpdate)
		xlDb_Execute(sUpdate)
	end
end

--�����޵��س鿨Ƭ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_RENZUWUDI_REDRAWCARD] = function(udbid, rid, msgId, tCmd)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_RENZUWUDI_REDRAWCARD:",uid,nOpr,sCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local unitId = tonumber(tCmd[3]) or 0 --��λid
	local wave = tonumber(tCmd[4]) or 0 --����
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local ret = 0 --����ֵ
		
		local shopItemId = 649 --�����޵��س鿨Ƭ����
		
		local tShopItem = hVar.tab_shopitem[shopItemId]
		local rmbCost = tShopItem.rmb --��װ�ϳ�������Ϸ��
		local itemId = tShopItem.itemID
		
		local strInfo = ""
		
		--�۳���Ϸ��
		local bSuccess, order_id = hGlobal.userCoinMgr:DBUserPurchase(cUId, cRId, itemId, 1, rmbCost, 0, strInfo)
		if bSuccess then
			ret = "1;" --�ɹ�
		else
			ret = "-3;" --��Ϸ�Ҳ���
		end
		
		local sL2CCmd = ret .. order_id .. ";" .. unitId .. ";" .. wave .. ";"
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUEST_QUNYINGGE_REDRAWCARD,sL2CCmd)
	end
end

--�����ϴ�ս�����
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_SEND_GAMEEND_INFO] = function(udbid, rid, msgId, tCmd)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_SEND_GAMEEND_INFO:",uid,nOpr,sCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local battleId = tonumber(tCmd[3]) or 0 --ս��id
	local tankId = tonumber(tCmd[4]) or 0 --ս��id
	local mapName = tCmd[5] --��ͼ��
	local mapMode = tonumber(tCmd[6]) or 0 --��ͼģʽ
	local mapDifficulty = tonumber(tCmd[7]) or 0 --��ͼ�Ѷ�
	local nIsWin = tonumber(tCmd[8]) or 0 --�Ƿ�ʤ��
	local nStar = tonumber(tCmd[9]) or 0 --��������
	local nGameTime = tonumber(tCmd[10]) or 0 --��Ϸʱ�䣨�룩
	local nExpAdd = tonumber(tCmd[11]) or 0 --���ӵľ���ֵ
	local nScientistNum = tonumber(tCmd[12]) or 0 --Ӫ�ȵĿ�ѧ������
	local nKillEnemyNum = tonumber(tCmd[13]) or 0 --��ɱ���˵�����
	local nKillBossNum = tonumber(tCmd[14]) or 0 --��ɱ��boss����
	local nTankDeadthNum = tonumber(tCmd[15]) or 0 --ս������������
	local nSufferDmg = tonumber(tCmd[16]) or 0 --�ܵ������˺�ֵ
	local data1 = tonumber(tCmd[17]) or 0 --�����ֶ�1
	local data2 = tonumber(tCmd[18]) or 0 --�����ֶ�2
	local data3 = tonumber(tCmd[19]) or 0 --�����ֶ�3
	local data4 = tonumber(tCmd[20]) or 0 --�����ֶ�4
	local data5 = tonumber(tCmd[21]) or 0 --�����ֶ�5
	local data6 = tonumber(tCmd[22]) or 0 --�����ֶ�6
	local nQSZDWave = tonumber(tCmd[23]) or 0 --ǰ����ز���
	local nRandomMapStage = tonumber(tCmd[24]) or 0 --����Թ�����
	
	print("cUId=", cUId)
	print("cRId=", cRId)
	print("battleId=", battleId)
	print("tankId=", tankId)
	print("mapName=", mapName)
	print("mapMode=", mapMode)
	print("mapDifficulty=", mapDifficulty)
	print("nIsWin=", nIsWin)
	print("nStar=", nStar)
	print("nGameTime=", nGameTime)
	print("nExpAdd=", nExpAdd)
	print("nScientistNum=", nScientistNum)
	print("nKillEnemyNum=", nKillEnemyNum)
	print("nKillBossNum=", nKillBossNum)
	print("nTankDeadthNum=", nTankDeadthNum)
	print("nSufferDmg=", nSufferDmg)
	print("nQSZDWave=", nQSZDWave)
	print("nRandomMapStage=", nRandomMapStage)
	
	local nTacticNum = tonumber(tCmd[25]) or 0 --ʹ�õ�ս��������
	print("nTacticNum=", nTacticNum)
	
	local rIdx = 25
	local tTacticInfo = {}
	for i = 1, nTacticNum, 1 do
		local tInfo = hApi.Split(tCmd[rIdx+i],":")
		local tacticId = tonumber(tInfo[1]) or 0 --ս����id
		local tacticNum = tonumber(tInfo[2]) or 0 --ս��������
		tTacticInfo[#tTacticInfo+1] = {id = tacticId, num = tacticNum,}
		print("    tacticId=", tacticId, "tacticNum=", tacticNum)
	end
	
	local nChestNum = tonumber(tCmd[rIdx+nTacticNum+1]) or 0 --�鵽�ı�������
	print("nChestNum=", nChestNum)
	
	local tChestInfo = {}
	local rIdx = rIdx+nTacticNum + 1
	for i = 1, nChestNum, 1 do
		local tInfo = hApi.Split(tCmd[rIdx+i],":")
		local chestId = tonumber(tInfo[1]) or 0 --����id
		local chestNum = tonumber(tInfo[2]) or 0 --��������
		tChestInfo[#tChestInfo+1] = {id = chestId, num = chestNum,}
		print("    chestId=", chestId, "chestNum=", chestNum)
	end
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--print("user=", user)
		if user then
			local result = 0
			
			--ս����־
			--����
			local sCmd = ""
			sCmd = sCmd .. tostring(battleId) .. ";"		--ս��id
			sCmd = sCmd .. tostring(tankId) .. ";"			--ս��id
			sCmd = sCmd .. tostring(mapName) .. ";"			--��ͼ��
			sCmd = sCmd .. tostring(mapMode) .. ";"			--��ͼģʽ
			sCmd = sCmd .. tostring(mapDifficulty) .. ";"		--��ͼ�Ѷ�
			sCmd = sCmd .. tostring(nIsWin) .. ";"			--�Ƿ�ʤ��
			sCmd = sCmd .. tostring(nStar) .. ";"			--��������
			sCmd = sCmd .. tostring(nGameTime) .. ";"		--��Ϸʱ�䣨�룩
			sCmd = sCmd .. tostring(nExpAdd) .. ";"			--���ӵľ���ֵ
			sCmd = sCmd .. tostring(nScientistNum) .. ";"		--Ӫ�ȵĿ�ѧ������
			sCmd = sCmd .. tostring(nKillEnemyNum) .. ";"		--��ɱ�ĵ�������
			sCmd = sCmd .. tostring(nKillBossNum) .. ";"		--��ɱ��boss����
			sCmd = sCmd .. tostring(nTankDeadthNum) .. ";"		--ս������������
			sCmd = sCmd .. tostring(nSufferDmg) .. ";"		--�ܵ������˺�ֵ
			sCmd = sCmd .. tostring(nQSZDWave) .. ";"		--ǰ����ز���
			sCmd = sCmd .. tostring(nRandomMapStage) .. ";"		--����Թ�����
			
			local sTacticCmd = ""
			for _,value in ipairs(tTacticInfo) do
				sTacticCmd = sTacticCmd .. tostring(value.id) .. ":" .. tostring(value.num) .. ";"
			end
			sCmd = sCmd .. tostring(nTacticNum) .. ";"		--ʹ�õ�ս��������
			sCmd = sCmd .. tostring(sTacticCmd) .. ""		--ʹ�õ�ս������Ϣ
			
			local sChestCmd = ""
			for _,value in ipairs(tChestInfo) do
				sChestCmd = sChestCmd .. tostring(value.id) .. ":" .. tostring(value.num) .. ";"
			end
			sCmd = sCmd .. tostring(nChestNum) .. ";"		--�鵽�ı�������
			sCmd = sCmd .. tostring(sChestCmd) .. ""		--�鵽�ı�����Ϣ
			
			--��־
			local sUpdate = string.format("UPDATE `log_qunyingge_battleconfig` SET `result` = %d, `battleconfig` = CONCAT(IFNULL(`battleconfig`, ''), '\n', '%s'), `time_end` = NOW() where `id` = %d", nIsWin, sCmd, battleId)
			--print("sUpdate1:",sUpdate)
			xlDb_Execute(sUpdate)
			
			--����̹�˾���ֵ
			if (nExpAdd > 0) then
				--����vip����ľ���ֵ
				local vipLv = hGlobal.vipMgr:DBGetUserVipState(cUId)
				local tankExpAddRate = hVar.Vip_Conifg.tankExpAddRate[vipLv] or 0
				nExpAdd = math.floor(nExpAdd * (1 + tankExpAddRate))
				
				local tanktalentPoint = hClass.TankTalentPoint:create():Init(cUId, cRId)
				local sL2CCmd = tanktalentPoint:AddExp(tankId, nExpAdd)
			end
			
			--[����]
			--���ӹؿ�����ͳ�ƴ���
			local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(cUId, cRId)
			taskMgr:AddTaskBattleResult(tankId, mapName, mapMode, mapDifficulty, nIsWin, nExpAdd, nStar, nScientistNum, nKillEnemyNum, nKillBossNum, nTankDeadthNum, nSufferDmg, nQSZDWave, nRandomMapStage, tTacticInfo, tChestInfo)
			
			--���ӵ�ͼͨ����Ϣ��ͨ�ؽ���
			local tankMap = hClass.TankMap:create():Init(cUId,cRId)
			local sL2CCmd = tankMap:MapFinish(tankId, mapName, mapMode, mapDifficulty, nIsWin, nExpAdd, nStar, nScientistNum, nKillEnemyNum, nKillBossNum, nTankDeadthNum, nSufferDmg, nQSZDWave, nRandomMapStage, tTacticInfo, tChestInfo)
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_MAP_FINISH_REWARD_RET, sL2CCmd)
			
			result = 1
			local sL2CCmd = tostring(result) .. ";" .. tostring(tankId) .. ";" .. tostring(mapName) .. ";" .. tostring(nExpAdd) .. ";" .. tostring(nScientistNum) .. ";" .. tostring(nTankDeadthNum) .. ";"
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_SEND_GAMEEND_INFO_RET, sL2CCmd)
		end
	end
end


































---------------------------------------------------------------------------------------------------------------------------------------
--��ѯ��ұ���ͱ�������λ��Ϣ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TRESTURE_INFO] = function(udbid, rid, msgId, tCmd)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_TRESTURE_INFO:",uid,nOpr,sCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local result = 0 --�������
		local sL2CCmd = ""
		
		--��ѯ����ͱ�������λ��Ϣ
		local treasure = hClass.Treasure:create():Init(cUId,cRId)
		local sL2CCmd = treasure:QueryInfo()
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TREASURE_INFO,sL2CCmd)
	end
end

--�������������
__Handler[hVar.DB_OPR_TYPE.C2L_UPDATE_TRESTURE_STARUP] = function(udbid, rid, msgId, tCmd)
	--print("hVar.DB_OPR_TYPE.C2L_UPDATE_TRESTURE_STARUP:",uid,nOpr,sCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local treasureId = tonumber(tCmd[3]) or 0
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local result = 0 --�������
		local sL2CCmd = ""
		
		--��������
		local treasure = hClass.Treasure:create():Init(cUId, cRId)
		local sL2CCmd = treasure:StarUp(treasureId)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_UPDATE_TREASURE_STARUP,sL2CCmd)
	end
end

--����ϴ���������λֵ��Ϣ
__Handler[hVar.DB_OPR_TYPE.C2L_UPLOAD_TRESTURE_ATTR_INFO] = function(udbid, rid, msgId, tCmd)
	--print("hVar.DB_OPR_TYPE.C2L_UPLOAD_TRESTURE_ATTR_INFO:",uid,nOpr,sCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local sessionId = tonumber(tCmd[3]) or 0 --��Ϸ��id
	local orderId = tonumber(tCmd[4]) or 0 --����id
	local battleId = tonumber(tCmd[5]) or 0 --ս��id������ͼ��
	local mapName = tostring(tCmd[6]) --��ͼ��
	local strAttr = tostring(tCmd[7]) --����λֵ
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local result = 0 --�������
		local sL2CCmd = ""
		
		--��ѯ����ͱ�������λ��Ϣ
		local treasure = hClass.Treasure:create():Init(cUId, cRId)
		local sL2CCmd = treasure:UploadAttr(sessionId, orderId, battleId, mapName, strAttr)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_UPLOAD_TREASURE_ATTR_INFO,sL2CCmd)
	end
end

--ս�����󿪱���
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_OPEN_CHEST] = function(udbid, rid, msgId, tCmd)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_TANK_OPEN_CHEST:",uid,nOpr,sCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local shopItemId = tonumber(tCmd[3]) or 0 --��Ʒ����id
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local tShopItem = hVar.tab_shopitem[shopItemId] or {}
		local itemId = tShopItem.itemID or 0 --����id
		local chestId = tShopItem.chestId or 0 --����id
		--print("chestId=", chestId)
		local tabChest = hVar.tab_chest[chestId]
		local itemType = tabChest.itemType
		local debrisNum = tShopItem.debrisNum or 0 --��Ҫ����Ƭ����
		local costGameCoin = tShopItem.rmb or 0 --���ĵ���Ϸ��
		local result = 0 --�������
		local sL2CCmd = ""
		local strReward = ""
		
		--�����Ƭ�����Ƿ��㹻
		local sql = string.format("SELECT `weapon_chest`, `tactic_chest`, `pet_chest`, `equip_chest`, `gamecoin_online` FROM `t_user` where `uid` = %d ", cUId)
		local err, weapon_chest, tactic_chest, pet_chest, equip_chest, gamecoin_online = xlDb_Query(sql)
		if err == 0 then
			--
		else
			weapon_chest = 0
			tactic_chest = 0
			pet_chest = 0
			equip_chest = 0
			gamecoin_online = 0
		end
		
		if (itemType == hVar.ITEM_TYPE.CHEST_REDEQUIP) then --��������
			debrisNum = costGameCoin
		end
		
		if (itemType == hVar.ITEM_TYPE.CHEST_WEAPON_GUN) then --����ǹ����
			if (weapon_chest < debrisNum) then
				result = -1
			end
		elseif (itemType == hVar.ITEM_TYPE.CHEST_TACTIC) then --ս������
			if (tactic_chest < debrisNum) then
				result = -2
			end
		elseif (itemType == hVar.ITEM_TYPE.CHEST_PET) then --���ﱦ��
			if (pet_chest < debrisNum) then
				result = -3
			end
		elseif (itemType == hVar.ITEM_TYPE.CHEST_EQUIP) then --װ������
			if (equip_chest < debrisNum) then
				result = -4
			end
		elseif (itemType == hVar.ITEM_TYPE.CHEST_REDEQUIP) then --��������
			--��Ϸ���Ƿ��㹻
			if (gamecoin_online < debrisNum) then
				result = -5
			end
		end
		
		if (result >= 0) then
			local chest = hClass.Chest:create():Init(itemId,0) --����
			--print("chest=", chest)
			if chest and (type(chest) == "table") and (chest:getCName() == "Chest") then
				local reward = chest:Open()
				--print("reward=", reward)
				if reward then
					reward:TakeReward(udbid, cRId)
					strReward = reward:ToCmd()
					result = 1
				end
			end
			
			--������
			--�µĹ����¼���뵽order��
			if (costGameCoin > 0) then
				hGlobal.userCoinMgr:DBUserPurchase(udbid,cRId, itemId, 1, costGameCoin, 0, tostring(chestId))
			else
				local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
				local itemCost = 0
				local strNotice = tostring(chestId) .. ";" .. tostring(debrisNum) .. ";" .. strReward
				local sUpdate = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,udbid,cRId,itemId,1,sItemName,itemCost,0,strNotice)
				--print("sUpdate2:",sUpdate)
				xlDb_Execute(sUpdate)
			end
			
			--�۳���Ƭ
			if (itemType == hVar.ITEM_TYPE.CHEST_WEAPON_GUN) then --����ǹ����
				weapon_chest = weapon_chest - debrisNum
			elseif (itemType == hVar.ITEM_TYPE.CHEST_TACTIC) then --ս������
				tactic_chest = tactic_chest - debrisNum
			elseif (itemType == hVar.ITEM_TYPE.CHEST_PET) then --���ﱦ��
				pet_chest = pet_chest - debrisNum
			elseif (itemType == hVar.ITEM_TYPE.CHEST_EQUIP) then --װ������
				equip_chest = equip_chest - debrisNum
			end
			
			--����
			local sUpdate = string.format("UPDATE `t_user` SET `weapon_chest` = %d, `tactic_chest` = %d, `pet_chest` = %d, `equip_chest` = %d WHERE `uid` = %d", weapon_chest, tactic_chest, pet_chest, equip_chest, cUId)
			--print("sUpdate1:",sUpdate)
			xlDb_Execute(sUpdate)
			
			--����ͳ��
			if (itemType == hVar.ITEM_TYPE.CHEST_WEAPON_GUN) then --����ǹ����
				--����ÿ�������£�
				--��������
				local taskType = hVar.TASK_TYPE.TASK_OPEN_WEPONCHEST --��������
				local addCount = 1
				local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(udbid, cRId)
				taskMgr:AddTaskFinishCount(taskType, addCount)
			elseif (itemType == hVar.ITEM_TYPE.CHEST_TACTIC) then --ս������
				--����ÿ�������£�
				--ս������
				local taskType = hVar.TASK_TYPE.TASK_OPEN_TACTICCHEST --ս������
				local addCount = 1
				local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(udbid, cRId)
				taskMgr:AddTaskFinishCount(taskType, addCount)
			elseif (itemType == hVar.ITEM_TYPE.CHEST_PET) then --���ﱦ��
				--����ÿ�������£�
				--���ﱦ��
				local taskType = hVar.TASK_TYPE.TASK_OPEN_PETCHEST --���ﱦ��
				local addCount = 1
				local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(udbid, cRId)
				taskMgr:AddTaskFinishCount(taskType, addCount)
			elseif (itemType == hVar.ITEM_TYPE.CHEST_EQUIP) then --װ������
				--����ÿ�������£�
				--װ������
				local taskType = hVar.TASK_TYPE.TASK_OPEN_EQUIPCHEST --װ������
				local addCount = 1
				local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(udbid, cRId)
				taskMgr:AddTaskFinishCount(taskType, addCount)
			end
		end
		
		sL2CCmd = tostring(result) .. ";" .. tostring(chestId) .. ";" .. tostring(debrisNum) .. ";" .. tostring(weapon_chest) .. ";" .. tostring(tactic_chest) .. ";" .. tostring(pet_chest) .. ";" .. tostring(equip_chest) .. ";" .. tostring(gamecoin_online-costGameCoin) .. ";" .. strReward
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_TANK_OPEN_CHEST,sL2CCmd)
	end
end

--�ϴ��ͻ��˴�����־
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_ERROR_LOG] = function(udbid, rid, msgId, tCmd)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_ERROR_LOG:",uid,nOpr,sCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local strInfo = tostring(tCmd[3]) --������Ϣ
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local ret = 0 --����ֵ
		local sL2CCmd = ""
		
		--������־
		local sUpdate = string.format("INSERT INTO `log_server_error`(`uid`, `info`) values (%d, '%s')", cUId, strInfo)
		--print("sUpdate2:",sUpdate)
		xlDb_Execute(sUpdate)
		
		--sL2CCmd = tostring(ret) .. ";" .. sL2CCmd
		--xlSendScript2Client(connid,hVar.DB_RECV_TYPE.L2C_REQUEST_HERO_BATTLE_BEGIN,sL2CCmd)
	end
end












------------------------------------------------------------------------------------------------------------------
--pvp_server������Ĺ���
--ÿ����ȡ����
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_GET_PVPCOIN_EVERYDAY] = function(udbid, rid, msgId, tCmd)
	
	local cUDbid = tonumber(tCmd[1])				--uid
	local cRid = tonumber(tCmd[2])					--ʹ�ý�ɫrid
	
	--print("hVar.PVP_OPR_TYPE.C2L_REQUIRE_GET_PVPCOIN_EVERYDAY:",cUDbid, cRid)
	--�����û�����
	local user = hGlobal.uMgr:CreateUser(udbid, cRid)
	--�����Ҵ��ڣ�������Ҳ�����Ϸ��
	if user then
		user:SetInHall()
		local ret = user:DBGetPvpCoinEveryDay()
		if ret then
			local sCmd = user:BaseInfoToCmd()
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_USER_BASEINFO,sCmd)	--������һ�����Ϣ
		else
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.GET_PVPCOIN_EVERYDAY_FAILD)) --ÿ����ȡ����ʧ��
		end

		--��ʱ,����˳�
		
		--�ͷ������Ϣ
		hGlobal.uMgr:ReleaseUserByDBID(udbid)
	else
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.GET_PVPCOIN_EVERYDAY_FAILD)) --ÿ����ȡ����ʧ��
	end
end

--�������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_BUY_PVPCOIN] = function(udbid, rid, msgId, tCmd)

	local cUDbid = tonumber(tCmd[1])				--uid
	local cRid = tonumber(tCmd[2])					--ʹ�ý�ɫrid
	
	--print("hVar.PVP_OPR_TYPE.C2L_REQUIRE_BUY_PVPCOIN:",cUDbid, cRid)
	--�����û�����
	local user = hGlobal.uMgr:CreateUser(udbid, cRid)
	--�����Ҵ��ڣ�������Ҳ�����Ϸ��
	if user then
		user:SetInHall()
		local ret = user:DBBuyPvpCoin()
		if ret then
			local sCmd = user:BaseInfoToCmd()
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_USER_BASEINFO,sCmd)	--������һ�����Ϣ
		else
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.GET_BUY_PVPCOIN_FAILD)) --�������ʧ��
		end

		--��ʱ����˳�
		
		--�ͷ������Ϣ
		hGlobal.uMgr:ReleaseUserByDBID(udbid)
	else
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.GET_BUY_PVPCOIN_FAILD)) --�������ʧ��
	end
end

--��ȡ���������䣨��ѱ��� chestpos��0��
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_REWARD_PVP_CHEST] = function(udbid, rid, msgId, tCmd)

	local cUDbid = tonumber(tCmd[1])				--uid
	local cRid = tonumber(tCmd[2])					--ʹ�ý�ɫrid
	local cChestpos = tonumber(tCmd[3])				--����λ��
	
	--print("hVar.PVP_OPR_TYPE.C2L_REQUIRE_REWARD_PVP_CHEST:",cUDbid, cRid)
	--�����û�����
	local user = hGlobal.uMgr:CreateUser(udbid, cRid)
	--�����Ҵ��ڣ���������ڴ�����
	if user then
		user:SetInHall()
		local ret = user:RewardChest(cChestpos)
		if ret then
			local sCmd = user:BaseInfoToCmd()
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_USER_BASEINFO,sCmd)	--������һ�����Ϣ
		else
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.HALL_REWARD_PVPCHEST_FAILD))	--�һ�����������ʧ��
		end

		--�ͷ������Ϣ
		hGlobal.uMgr:ReleaseUserByDBID(udbid)
	else
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.HALL_REWARD_PVPCHEST_FAILD))	--�һ�����������ʧ��
	end
end

--�򿪾��������䣨��ѱ��� chestpos��0��
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_OPEN_PVP_CHEST] = function(udbid, rid, msgId, tCmd)

	local cUDbid = tonumber(tCmd[1])				--uid
	local cRid = tonumber(tCmd[2])					--ʹ�ý�ɫrid
	local cChestpos = tonumber(tCmd[3])				--����λ��
	
	--print("hVar.PVP_OPR_TYPE.C2L_REQUIRE_OPEN_PVP_CHEST:",cUDbid, cRid)
	--�����û�����
	local user = hGlobal.uMgr:CreateUser(udbid, cRid)
	--�����Ҵ��ڣ���������ڴ�����
	if user then

		user:SetInHall()

		local ret = user:OpenChest(cChestpos)
		if ret then
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_REWARD_FROM_PVPCHEST,ret)	--���ر��λ�õĽ���

			local sCmd = user:BaseInfoToCmd()
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_USER_BASEINFO,sCmd)	--������һ�����Ϣ
		else
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.HALL_OPEN_PVPCHEST_FAILD))	--�򿪾���������ʧ��
		end

		
		--�ͷ������Ϣ
		hGlobal.uMgr:ReleaseUserByDBID(udbid)

	else
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.HALL_OPEN_PVPCHEST_FAILD))	--�򿪾���������ʧ��
	end
end

--Ӣ������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_HERO_STAR_LVUP] = function(udbid, rid, msgId, tCmd)

	local cUDbid = tonumber(tCmd[1])				--uid
	local cRid = tonumber(tCmd[2])					--ʹ�ý�ɫrid
	local cHeroId = tonumber(tCmd[3])				--Ӣ��id
	
	--print("hVar.PVP_OPR_TYPE.C2L_REQUIRE_HERO_STAR_LVUP:",cUDbid, cRid, cHeroId)
	--�����û�����
	local user = hGlobal.uMgr:CreateUser(udbid, cRid)
	--�����Ҵ��ڣ���������ڴ�����
	if user then
		
		user:SetInHall()

		local ret = user:HeroStarLvUp(cHeroId)
		if ret then
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_HERO_STAR_LVUP,ret)	--���ر��λ�õĽ���

			local sCmd = user:BaseInfoToCmd()
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_USER_BASEINFO,sCmd)	--������һ�����Ϣ
		else
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.HALL_HERO_STARLVUP_FAILD))	--Ӣ������ʧ��
		end

		--�ͷ������Ϣ
		hGlobal.uMgr:ReleaseUserByDBID(udbid)
	else
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.HALL_HERO_STARLVUP_FAILD))	--Ӣ������ʧ��
	end
end

--Ӣ�۽���
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_HERO_UNLOCK] = function(udbid, rid, msgId, tCmd)

	local cUDbid = tonumber(tCmd[1])				--uid
	local cRid = tonumber(tCmd[2])					--ʹ�ý�ɫrid
	local cHeroId = tonumber(tCmd[3])				--Ӣ��id
	
	--print("hVar.PVP_OPR_TYPE.C2L_REQUIRE_HERO_STAR_LVUP:",cUDbid, cRid, cHeroId)
	--�����û�����
	local user = hGlobal.uMgr:CreateUser(udbid, cRid)
	--�����Ҵ��ڣ���������ڴ�����
	if user then

		user:SetInHall()

		local ret = user:HeroUnlock(cHeroId)
		if ret then
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_HERO_UNLOCK,ret)	--���ر��ν������

			local sCmd = user:BaseInfoToCmd()
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_USER_BASEINFO,sCmd)	--������һ�����Ϣ
		else
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.HALL_HERO_UNLOCK_FAILD))	--Ӣ�۽���ʧ��
		end

		--�ͷ������Ϣ
		hGlobal.uMgr:ReleaseUserByDBID(udbid)
	else
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.HALL_HERO_UNLOCK_FAILD))	--Ӣ�۽���ʧ��
	end
end

--���ֿ�����
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_ARMY_LVUP] = function(udbid, rid, msgId, tCmd)

	local cUDbid = tonumber(tCmd[1])				--uid
	local cRid = tonumber(tCmd[2])					--ʹ�ý�ɫrid
	local cTacticId = tonumber(tCmd[3])				--���ֿ�id
	
	--print("hVar.PVP_OPR_TYPE.C2L_REQUIRE_ARMY_LVUP:",cUDbid, cRid, cTacticId)
	--�����û�����
	local user = hGlobal.uMgr:CreateUser(udbid, cRid)
	--�����Ҵ��ڣ���������ڴ�����
	if user then
		
		user:SetInHall()

		local ret = user:TacticLvUp(cTacticId)
		if ret then
			local sCmd = user:BaseInfoToCmd()
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_USER_BASEINFO, sCmd)	--������һ�����Ϣ
			
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ARMY_LVUP, ret)	--���ر��λ�õĽ���
		else
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.HALL_ARMY_LVUP_FAILD))	--���ֿ�����
		end

		--�ͷ������Ϣ
		hGlobal.uMgr:ReleaseUserByDBID(udbid)
	else
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.HALL_ARMY_LVUP_FAILD))	--���ֿ�����
	end
end

--ˢ��ս������������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_ARMY_REFRESH_ADDONES] = function(udbid, rid, msgId, tCmd)

	local cUDbid = tonumber(tCmd[1])				--uid
	local cRid = tonumber(tCmd[2])					--ʹ�ý�ɫrid
	local cTacticId = tonumber(tCmd[3])				--���ֿ�id
	local cAddonesIdx = tonumber(tCmd[4])				--��������λ��
	
	--print("hVar.PVP_OPR_TYPE.C2L_REQUIRE_ARMY_REFRESH_ADDONES:",cUDbid, cRid, cTacticId)
	--�����û�����
	local user = hGlobal.uMgr:CreateUser(udbid, cRid)
	--�����Ҵ��ڣ���������ڴ�����
	if user then
		
		user:SetInHall()

		local ret = user:TacticRefreshAddOnes(cTacticId,cAddonesIdx)
		if ret then
			local sCmd = user:BaseInfoToCmd()
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_USER_BASEINFO, sCmd)	--������һ�����Ϣ
			
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ARMY_REFRESH_ADDONES, ret)	--���ر��λ�õĽ���
		else
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.HALL_ARMY_REFRESH_ADDONES_FAILD))	--ˢ��ս������������ʧ��
		end

		--�ͷ������Ϣ
		hGlobal.uMgr:ReleaseUserByDBID(udbid)
	else
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.HALL_ARMY_REFRESH_ADDONES_FAILD))	--ˢ��ս������������ʧ��
	end
end

--����ս������������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_ARMY_NEW_ADDONES] = function(udbid, rid, msgId, tCmd)

	local cUDbid = tonumber(tCmd[1])				--uid
	local cRid = tonumber(tCmd[2])					--ʹ�ý�ɫrid
	local cTacticId = tonumber(tCmd[3])				--���ֿ�id
	
	--print("hVar.PVP_OPR_TYPE.C2L_REQUIRE_ARMY_NEW_ADDONES:",cUDbid, cRid, cTacticId)
	--�����û�����
	local user = hGlobal.uMgr:CreateUser(udbid, cRid)
	--�����Ҵ��ڣ���������ڴ�����
	if user and user:IsInHall() then

		user:SetInHall()

		local ret = user:TacticNewAddOnes(cTacticId)
		if ret then
			local sCmd = user:BaseInfoToCmd()
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_USER_BASEINFO, sCmd)	--������һ�����Ϣ
			
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ARMY_NEW_ADDONES, ret)	--���ر��λ�õĽ���
		else
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.HALL_ARMY_NEW_ADDONES_FAILD))	--����ս������������ʧ��
		end

		--�ͷ������Ϣ
		hGlobal.uMgr:ReleaseUserByDBID(udbid)
	else
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.HALL_ARMY_NEW_ADDONES_FAILD))	--����ս������������ʧ��
	end
end

--��ԭս������������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_ARMY_RESTORE_ADDONES] = function(udbid, rid, msgId, tCmd)
	
	local cUDbid = tonumber(tCmd[1])				--uid
	local cRid = tonumber(tCmd[2])					--ʹ�ý�ɫrid
	local cTacticId = tonumber(tCmd[3])				--���ֿ�id
	local cAddonesIdx = tonumber(tCmd[4])				--��������λ��
	
	--print("hVar.PVP_OPR_TYPE.C2L_REQUIRE_ARMY_REFRESH_ADDONES:",cUDbid, cRid, cTacticId)
	--�����û�����
	local user = hGlobal.uMgr:CreateUser(udbid, cRid)
	--�����Ҵ��ڣ���������ڴ�����
	if user and user:IsInHall() then

		user:SetInHall()

		local ret = user:TacticRestoreAddOnes(cTacticId,cAddonesIdx)
		if ret then
			local sCmd = user:BaseInfoToCmd()
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_USER_BASEINFO, sCmd)	--������һ�����Ϣ
			
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ARMY_RESTORE_ADDONES, ret)	--���ر��λ�õĽ���
		else
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.HALL_ARMY_RESTORE_ADDONES_FAILD))	--ˢ��ս������������ʧ��
		end

		--�ͷ������Ϣ
		hGlobal.uMgr:ReleaseUserByDBID(udbid)
	else
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.DBNETERR.HALL_ARMY_RESTORE_ADDONES_FAILD))	--ˢ��ս������������ʧ��
	end
end

--���۵�Ļϵͳ����������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_ADD] = function(udbid, rid, msgId, tCmd)
	
	local cUDbid = tonumber(tCmd[1])				--uid
	local cRid = tonumber(tCmd[2])					--ʹ�ý�ɫrid
	local commentType = tonumber(tCmd[3])			--��������ö��
	local typeID = tonumber(tCmd[4])				--��������ID
	local isBarrage = tonumber(tCmd[5])				--�Ƿ�����Ϊ��Ļ
	local commentStr = tCmd[6]						--��������

	local allowBarrage = 0
	if isBarrage == 2 then
		allowBarrage = 2
	end

	local sUpdate = string.format("insert into user_comment (`uid`,`rid`,`comment_type`,`type_id`,`content`,`apply_barrage`,`allow_barrage`) values (%d,%d,%d,%d,'%s',%d,%d);",cUDbid,cRid,commentType,typeID,commentStr,isBarrage,allowBarrage)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_ADD " , sUpdate)
	local ret = xlDb_Execute(sUpdate)
	--print('hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_ADD ' , ret)
	local err1, orderId = xlDb_Query("select last_insert_id()")
	--print('hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_ADD ' ,err1 , orderId)

	local sL2CCmd = ""
	
	sL2CCmd = sL2CCmd .. tostring(ret) .. ";"
	sL2CCmd = sL2CCmd .. tostring(orderId or 0) .. ";"
	sL2CCmd = sL2CCmd .. tostring(commentType) .. ";"
	sL2CCmd = sL2CCmd .. tostring(typeID) .. ";"
 
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_COMMENT_ADD_RET,sL2CCmd)
end

--���۵�Ļϵͳ���޸�����
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_EDIT] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--uid
	local cRid = tonumber(tCmd[2])					--ʹ�ý�ɫrid
	local commentID = tonumber(tCmd[3])				--����ID
	local isBarrage = tonumber(tCmd[4])				--�Ƿ�Ļ
	local commentStr = tCmd[5]						--��������	

	local sUpdate = string.format("UPDATE user_comment SET `content` = '%s', `apply_barrage` = %d,`update_date` = NOW() WHERE `comment_id` = %d;",commentStr,isBarrage,commentID)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_EDIT " , sUpdate)
	local ret = xlDb_Execute(sUpdate)
	--print('hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_EDIT ' , ret)

	local sL2CCmd = ""
	
	sL2CCmd = sL2CCmd .. tostring(ret) .. ";"
 
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_COMMENT_EDIT_RET,sL2CCmd)

end

--���۵�Ļϵͳ��ɾ������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_DEL] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--uid
	local cRid = tonumber(tCmd[2])					--ʹ�ý�ɫrid
	local commentID = tonumber(tCmd[3])				--����ID

	local sUpdate = string.format("UPDATE user_comment SET `del_flag` = %d WHERE `comment_id` = %d;",1,commentID)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_DEL " , sUpdate)
	local ret = xlDb_Execute(sUpdate)
	--print('hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_DEL ' , ret)
	
	local sL2CCmd = ""
	
	sL2CCmd = sL2CCmd .. tostring(ret) .. ";"
 
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_COMMENT_DEL_RET,sL2CCmd)

end

--���۵�Ļϵͳ����ѯ����
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_LOOK] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--uid
	local cRid = tonumber(tCmd[2])					--ʹ�ý�ɫrid
	local commentType = tonumber(tCmd[3])			--��������ö��
	local typeID = tonumber(tCmd[4])				--��������ID
	local beginIndex = tonumber(tCmd[5])			--��������
	local getNum = tonumber(tCmd[6])			--��ȡ����
	local orderType = tonumber(tCmd[7])			--�������� 0 ��ʱ�併�� 1 ��ʱ������ 2 ���ȶȽ���
	

	local function QueryComment(commentType,typeID,beginIndex,cUDbid,cRid)
		-- SELECT a.`comment_id`,a.`uid`,a.`rid`,a.`content`,a.`show`,a.`star`,a.`update_date` FROM user_comment AS a WHERE a.`del_flag` = 0 AND a.`comment_type` = %d AND a.`type_id` = %d ORDER BY a.`update_date` DESC LIMIT %d,10;
		local sQuery = string.format("SELECT c.`comment_id`,c.`uid`,c.`rid`,c.`content`,c.`show`,c.`star`,c.`key`,c.`update_date`,IFNULL(b.`icon`,0),IFNULL(b.`customS1`,'unkown'),IFNULL(d.`is_like`,0) FROM (SELECT a.`comment_id`,a.`uid`,a.`rid`,a.`content`,a.`show`,a.`star`,a.`key`,a.`update_date` FROM user_comment AS a WHERE a.`del_flag` = 0 AND a.`comment_type` = %d AND a.`type_id` = %d ORDER BY a.`comment_id` DESC LIMIT %d,20)AS c LEFT JOIN t_user AS b ON c.`uid` = b.`uid` LEFT JOIN user_comment_likes AS d ON c.`comment_id` = d.`comment_id` AND c.`uid` = d.`uid` AND c.`rid` = d.`rid` AND c.`uid` = %d AND c.`rid` = %d;",commentType,typeID,beginIndex,cUDbid,cRid)
		--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_LOOK " , sQuery)
		local err,ret = xlDb_QueryEx(sQuery)
		--print('hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_LOOK' , err)
		
		sQuery = string.format("SELECT COUNT(*) FROM user_comment AS a WHERE a.`del_flag` = 0 AND a.`comment_type` = %d AND a.`type_id` = %d;",commentType,typeID)
		local err1,count = xlDb_Query(sQuery)
		return err == 0 and err1 == 0 ,count,ret
	end

	local isQueryOk,count,ret = QueryComment(commentType,typeID,beginIndex,cUDbid,cRid)

	local sL2CCmd = ""


	if isQueryOk then
		sL2CCmd = sL2CCmd .. "0" .. ";"

		sL2CCmd = sL2CCmd .. tostring(commentType) .. ";"
		sL2CCmd = sL2CCmd .. tostring(typeID) .. ";"
		
		sL2CCmd = sL2CCmd .. tostring(count) .. ";"
		sL2CCmd = sL2CCmd .. tostring(beginIndex) .. ";"
		sL2CCmd = sL2CCmd .. tostring(orderType) .. ";"
	else
		sL2CCmd = sL2CCmd .. "1" .. ";"

		sL2CCmd = sL2CCmd .. tostring(commentType) .. ";"
		sL2CCmd = sL2CCmd .. tostring(typeID) .. ";"

		sL2CCmd = sL2CCmd .. "0" .. ";"
		sL2CCmd = sL2CCmd .. "0" .. ";"
		sL2CCmd = sL2CCmd .. tostring(orderType) .. ";"
	end

	
	if isQueryOk then
		local data = tostring(#ret) ..";"
		for _,v in ipairs(ret) do
			for _,col in ipairs(v) do
				if type(col) == "string" then
					data = data .. col .. ";"
				else
					data = data .. tostring(col) .. ";"
				end
			end
			local subOk,subCount,subRet = QueryComment(2,v[1],0,v[2],v[3])
			if subOk then
				data = data .. tostring(subCount) .. ";"
				data = data .. tostring(#subRet) .. ";"
				for _,v in ipairs(subRet) do
					for _,col in ipairs(v) do
						if type(col) == "string" then
							data = data .. col .. ";"
						else
							data = data .. tostring(col) .. ";"
						end
					end				
				end
			else
				data = data .. "0" .. ";"
				data = data .. "0" .. ";"
			end
		end
		sL2CCmd = sL2CCmd .. data
	end

	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_COMMENT_LOOK_RET,sL2CCmd)

end

--���۵�Ļϵͳ����������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_LIKES] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--uid
	local cRid = tonumber(tCmd[2])					--ʹ�ý�ɫrid
	local commentID = tonumber(tCmd[3])				--����ID

	local starCount = 0

	local sQuery = string.format("SELECT `is_like` FROM user_comment_likes WHERE comment_id = %d AND uid = %d AND rid = %d;",commentID,cUDbid,cRid)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_LIKES " , sQuery)
	local err,ret = xlDb_Query(sQuery)
	if (err == 0 and ret == 0) or (err == 4 or ret == nil) then
		local sUpdate = string.format("INSERT INTO user_comment_likes (`comment_id`,`uid`,`rid`,`is_like`) VALUES (%d,%d,%d,TRUE) ON DUPLICATE KEY UPDATE `is_like` = TRUE,`update_time` = NOW();",commentID,cUDbid,cRid)
		--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_LIKES " , sUpdate)
		ret = xlDb_Execute(sUpdate)

		sQuery = string.format("SELECT COUNT(`is_like`) FROM user_comment_likes WHERE comment_id = %d and `is_like` <> 0;",commentID)
		--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_LIKES " , sQuery)
		err,ret = xlDb_Query(sQuery)

		if err == 0 then
			starCount = ret
			sUpdate = string.format("UPDATE user_comment AS a SET a.`star` = %d where a.`comment_id` = %d;",ret,commentID)
			--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_LIKES " , sUpdate)
			ret = xlDb_Execute(sUpdate)
		end
	else
		sQuery = string.format("SELECT COUNT(`is_like`) FROM user_comment_likes WHERE comment_id = %d and `is_like` <> 0 ;",commentID)
		err,ret = xlDb_Query(sQuery)
		starCount = ret
	end

	local sL2CCmd = ""
	
	sL2CCmd = sL2CCmd .. tostring(err) .. ";"
	sL2CCmd = sL2CCmd .. tostring(commentID) .. ";"
	sL2CCmd = sL2CCmd .. tostring(starCount) .. ";"

 
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_COMMENT_LIKES_RET,sL2CCmd)
	

end

--���۵�Ļϵͳ��ȡ����������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_CANNEL_LIKES] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--uid
	local cRid = tonumber(tCmd[2])					--ʹ�ý�ɫrid
	local commentID = tonumber(tCmd[3])				--����ID

	local starCount = 0
	local isLike = "0"

	local sQuery = string.format("SELECT `is_like` FROM user_comment_likes WHERE comment_id = %d AND uid = %d AND rid = %d;",commentID,cUDbid,cRid)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_LIKES " , sQuery)
	local err,ret = xlDb_Query(sQuery)
	if (err == 0 and ret == 0) or (err == 4 or ret == nil) then
		sQuery = string.format("SELECT COUNT(`is_like`) FROM user_comment_likes WHERE comment_id = %d and `is_like` <> 0 ;",commentID)
		err,ret = xlDb_Query(sQuery)
		starCount = ret
		isLike = "1"
	else
		local sUpdate = string.format("UPDATE user_comment_likes SET `is_like` = FALSE,`update_time` = NOW() WHERE `comment_id` = %d AND `uid` = %d AND `rid` = %d;",commentID,cUDbid,cRid)
		--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_CANNEL_LIKES " , sUpdate)
		local ret = xlDb_Execute(sUpdate)
		--print('hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_CANNEL_LIKES ' , ret)
		
		sQuery = string.format("SELECT COUNT(`is_like`) FROM user_comment_likes WHERE comment_id = %d and `is_like` <> 0 ;",commentID)
		--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_LIKES " , sQuery)
		err,ret = xlDb_Query(sQuery)

		if err == 0 then
			starCount = ret
			sUpdate = string.format("UPDATE user_comment AS a SET a.`star` = %d where a.`comment_id` = %d;",ret,commentID)
			--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_LIKES " , sUpdate)
			ret = xlDb_Execute(sUpdate)
		end
		isLike = "0"
	end

	local sL2CCmd = ""
	
	sL2CCmd = sL2CCmd .. isLike .. ";"
	sL2CCmd = sL2CCmd .. tostring(commentID) .. ";"
	sL2CCmd = sL2CCmd .. tostring(starCount) .. ";"
 
	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_COMMENT_CANNEL_LIKES_RET,sL2CCmd)


end

--���۵�Ļϵͳ���鿴���۵�����
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_LIKES_COUNT] = function(udbid, rid, msgId, tCmd)
	local commentID = tonumber(tCmd[1])				--����ID

	local sQuery = string.format("SELECT COUNT(*) FROM user_comment_likes AS a WHERE a.`comment_id` = %d;",commentID)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_LIKES_COUNT " , sQuery)
	local err,ret = xlDb_Query(sQuery)
	--print('hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_LIKES_COUNT' , err,ret)

	local sL2CCmd = ""
	
	sL2CCmd = sL2CCmd .. tostring(err) .. ";"
	sL2CCmd = sL2CCmd .. tostring(commentID) .. ";"

	if err == 0 then
		sL2CCmd = sL2CCmd .. tostring(ret) .. ";"
	else
		sL2CCmd = sL2CCmd .. "0" .. ";"
	end

	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_COMMENT_LIKES_COUNT_RET,sL2CCmd)

end

--���۵�Ļϵͳ���鿴����Ƿ�����۵���
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_USER_LIKES] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--uid
	local cRid = tonumber(tCmd[2])					--ʹ�ý�ɫrid
	local commentID = tonumber(tCmd[3])				--����ID

	local sQuery = string.format("SELECT a.`is_like` FROM user_comment_likes AS a WHERE a.`comment_id` = %d AND a.`uid` = %d AND a.`rid` = %d;",commentID,cUDbid,cRid)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_USER_LIKES " , sQuery)
	local err,ret = xlDb_Query(sQuery)
	--print('hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_USER_LIKES' , err,ret)

	local sL2CCmd = ""
	
	if err == 0 then
		sL2CCmd = sL2CCmd .. tostring(ret) .. ";"
	else
		sL2CCmd = sL2CCmd ..  "0;"
	end

	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_COMMENT_USER_LIKES_RET,sL2CCmd)

end


--���۵�Ļϵͳ������/�޸����������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_EDIT_TITLE] = function(udbid, rid, msgId, tCmd)
	local commentType = tonumber(tCmd[1])			--��������ö��
	local typeID = tonumber(tCmd[2])				--��������ID
	local title = tCmd[3]				--��������

	local sUpdate = string.format("INSERT INTO user_comment_title (`comment_type`,`type_id`,`title`) VALUES (%d,%d,'%s') ON DUPLICATE KEY UPDATE `title` = '%s',`update_time` = NOW();",commentType,typeID,title,title)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_EDIT_TITLE " , sUpdate)
	local ret = xlDb_Execute(sUpdate)

	local sL2CCmd = ""
	
	sL2CCmd = sL2CCmd .. tostring(ret) .. ";"

	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_COMMENT_EDIT_TITLE,sL2CCmd)

end


--���۵�Ļϵͳ����ѯ���������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_QUERY_TITLE] = function(udbid, rid, msgId, tCmd)
	local commentType = tonumber(tCmd[1])			--��������ö��
	local typeID = tonumber(tCmd[2])				--��������ID

	local sQuery = string.format("SELECT `title`, `flag` FROM user_comment_title WHERE comment_type = %d AND type_id = %d;",commentType,typeID)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_QUERY_TITLE " , sQuery)
	local err,stitle,nflag = xlDb_Query(sQuery)

	local sL2CCmd = ""
	
	sL2CCmd = sL2CCmd .. tostring(err) .. ";"

	if err == 0 then
		sL2CCmd = sL2CCmd .. tostring(stitle) .. ";"
		sL2CCmd = sL2CCmd .. tostring(nflag) .. ";"
		sL2CCmd = sL2CCmd .. tostring(commentType) .. ";"
		sL2CCmd = sL2CCmd .. tostring(typeID) .. ";"
	end

	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_COMMENT_QUERY_TITLE,sL2CCmd)

end

--���۵�Ļϵͳ����õ�Ļ
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_BARRAGE_LOOK] = function(udbid, rid, msgId, tCmd)
	local commentType = tonumber(tCmd[1])			--��������ö��
	local typeID = tonumber(tCmd[2])				--��������ID
	local beginIndex = tonumber(tCmd[3])			--��������

	local sL2CCmd = ""

	if commentType == nil or typeID == nil or beginIndex == nil then
		sL2CCmd = sL2CCmd .. "-1" .. ";"
		sL2CCmd = sL2CCmd .. tostring(commentType) .. ";"
		sL2CCmd = sL2CCmd .. tostring(typeID) .. ";"
		print("C2L_REQUIRE_COMMENT_BARRAGE_LOOK ",commentType or -1,typeID or -1,beginIndex or -1)
	else
		local sQuery = string.format("SELECT a.`comment_id`,a.`uid`,a.`rid`,a.`content`,a.`star`,a.`key`,a.`update_date` FROM user_comment AS a WHERE a.`comment_type` = %d AND a.`type_id` = %d AND a.`show` = 1 AND a.`allow_barrage` = 2 AND a.`del_flag` = 0 ORDER BY a.`update_date` DESC LIMIT %d ,30;",commentType,typeID,beginIndex)
		--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_BARRAGE_LOOK " , sQuery)
		local err,ret = xlDb_QueryEx(sQuery)
		--print('hVar.DB_OPR_TYPE.C2L_REQUIRE_COMMENT_BARRAGE_LOOK' , err)

		sQuery = string.format("SELECT COUNT(*) FROM user_comment AS a WHERE a.`comment_type` = %d AND a.`type_id` = %d AND a.`show` = 1 AND a.`allow_barrage` = 2 AND a.`del_flag` = 0;",commentType,typeID)
		local err1,count = xlDb_Query(sQuery)


		
		sL2CCmd = sL2CCmd .. tostring(err) .. ";"
		sL2CCmd = sL2CCmd .. tostring(commentType) .. ";"
		sL2CCmd = sL2CCmd .. tostring(typeID) .. ";"
		sL2CCmd = sL2CCmd .. tostring(beginIndex) .. ";"
		if err ==0 and err1 == 0 then
			sL2CCmd = sL2CCmd .. tostring(count) .. ";"
			sL2CCmd = sL2CCmd .. tostring(beginIndex) .. ";"
		end
		
		if err == 0 then
			local data = tostring(#ret) ..";"
			for _,v in ipairs(ret) do
				for _,col in ipairs(v) do
					if type(col) == "string" then
						data = data .. col .. ";"
					else
						data = data .. tostring(col) .. ";"
					end
				end
			end
			sL2CCmd = sL2CCmd .. data
		end

	end



	hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_COMMENT_BARRAGE_LOOK_RET,sL2CCmd)

end

--����������
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_PLAYGOPHER] = function(udbid, rid, msgId, tCmd)
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local diff = tonumber(tCmd[3]) or 0

	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--��ȡ�������£����Ƚ���
		local GameGopherMgr = hClass.GameGopherMgr:create("GameGopherMgr"):Init(cUId, cRId)
		local sL2CCmd = GameGopherMgr:EnterGame(diff)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_PLAYGOPHER_RESULT, sL2CCmd)
	end
end

--��ȡ������Ϸ����
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_GAMEGOPHER_REWARD] = function(udbid, rid, msgId, tCmd)
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local diff = tonumber(tCmd[3]) or 0
	local score = tonumber(tCmd[4]) or 0

	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--��ȡ�������£����Ƚ���
		local GameGopherMgr = hClass.GameGopherMgr:create("GameGopherMgr"):Init(cUId, cRId)
		local sL2CCmd = GameGopherMgr:GetReward(diff,score)
		
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_GAMEGOPHER_REWARD, sL2CCmd)
	end
end

-------------------------------------------------------
--add by mj 2022.11.21
--������Ϣidͬ��
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_SYNC_CHAT_MSG_ID] = function(udbid, rid, msgId, tCmd)
	--print("hVar.DB_OPR_TYPE.C2L_REQUIRE_SYNC_REDEQUIP:",uid,nOpr,sCmd)
	--local tCmd = hApi.Split(sCmd,";")
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	
	local groupcardNum = 0 --���ſ�����
	local sL2CCmd = ""
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		--��ѯ������ڵĹ���
		local sQueryM = string.format("select `ncid` from `novicecamp_member` where `uid` = %d and `level` > 0", cUId)
		local errM, groupId = xlDb_Query(sQueryM)
		--print(sQueryM)
		--print("��ѯ������ڵĹ���:", "errM=", errM, "groupId=", groupId)
		if (errM == 0) then
			--��ѯ������Դ��Ϣ
			local sQueryG = string.format("select `buildinfo` from `novicecamp_list` where `id` = %d and `dissolution` = 0", groupId)
			local errG, strBuildInfo = xlDb_Query(sQueryG)
			--print(sQueryG)
			--print("��ѯ������ڵĹ���:", "errG=", errG, "strBuildInfo=", strBuildInfo)
			if (errG == 0) then
				strBuildInfo = strBuildInfo or ""
				local tmp = "local tBuildInfo = " .. strBuildInfo .. " return tBuildInfo"
				local tBuildInfo = assert(loadstring(tmp))()
				if tBuildInfo then
					local uniquetactics = tBuildInfo.uniquetactics
					if uniquetactics then
						for groupcardId, groupcardLv in pairs(uniquetactics) do
							groupcardNum = groupcardNum + 1
							sL2CCmd = sL2CCmd .. tostring(groupcardId) .. "|" .. tostring(groupcardLv) .. ";"
						end
					end
				end
			end
		else
			groupId = 0
		end
		
		--��ѯ������Ϣ�����һ����Ϣid
		--��ȡ������Ϣ���ݿ�id
		local lastWorldMsgId = 0
		local err1, pid = xlDb_Query("SELECT IFNULL(MAX(id), 0) FROM `chat` where `type` = 0 and `deleteflag` = 0")
		--print("max(id)", err1, pid)
		if (err1 == 0) then
			lastWorldMsgId = pid
		end
		
		--��ѯ������Ϣ�����һ����Ϣid
		--��ȡ������Ϣ���ݿ�id
		local lastInviteMsgId = 0
		--[[
		local err1, pid = xlDb_Query("SELECT IFNULL(MAX(id), 0) FROM `chat` where `type` = 1 and `deleteflag` = 0")
		--print("max(id)", err1, pid)
		if (err1 == 0) then
			lastInviteMsgId = pid
		end
		]]
		local sDateNow = os.date("%Y-%m-%d %H:%M:%S", os.time())
		local sql = string.format("SELECT IFNULL(MAX(msg_id), 0) FROM `chat_invite_group` where `expire_time` > '%s'", sDateNow)
		local err1, pid = xlDb_Query(sql)
		if (err1 == 0) then
			lastInviteMsgId = pid
		end
		
		--��ѯ������Ϣ�����һ����Ϣid
		--��ȡ������Ϣ���ݿ�id
		local lastGroupMsgId = 0
		if (groupId > 0) then
			local sql = string.format("SELECT IFNULL(MAX(id), 0) FROM `chat` where `type` = 3 and `touid` = %d and `deleteflag` = 0", groupId)
			local err1, pid = xlDb_Query(sql)
			--print("max(id)", err1, pid)
			if (err1 == 0) then
				lastGroupMsgId = pid
			end
		end
		
		--���ſ���Ϣ�ַ���
		sL2CCmd = tostring(lastWorldMsgId) .. ";" .. tostring(lastInviteMsgId) .. ";" .. tostring(lastGroupMsgId) .. ";" .. tostring(groupcardNum) .. ";" .. sL2CCmd
		hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_SYNC_CHAT_MSG_ID, sL2CCmd)
	end
end
--add end
-------------------------------------------------------

--���������ð��
__Handler[hVar.DB_OPR_TYPE.C2L_REQUIRE_BUBBLE_NOTICE] = function(udbid, rid, msgId, tCmd)
	--local tCmd = hApi.Split(sCmd,";")
	
	local cUId = tonumber(tCmd[1]) or 0
	local cRId = tonumber(tCmd[2]) or 0
	local nChannelId = tonumber(tCmd[3])		--������
	local nNoticeType = tonumber(tCmd[4]) or 0	--֪ͨ����
	local strUserName = tostring(tCmd[5])		--�����
	local strNoticeInfo = tostring(tCmd[6])		--֪ͨ��Ϣ
	local nItemId = tonumber(tCmd[7]) or 0		--����id
	
	--���uid�Ƿ�һ��
	if (udbid == cUId) then
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--print("user=", user)
		if user then
			--����һ�������ð��
			--uid, rid, noticeType, useName, channelId, noticeInfo, itemId
			local sL2CCmd = hGlobal.bubblleNoticeMgr:AddBubbleNotice(cUId,cRId,nNoticeType,strUserName,nChannelId,strNoticeInfo,nItemId)
			--hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_REQUIRE_BUBBLE_NOTICE_RET, sL2CCmd)
		end
	end
end