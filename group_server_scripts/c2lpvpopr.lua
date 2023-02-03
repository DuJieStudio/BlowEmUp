hHandler.C2L_GROUP_OPR = {}

local __Handler = hHandler.C2L_GROUP_OPR

--GMDebug
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_DEBUG] = function(udbid, rid, msgId, tCmd)

	print("hVar.GROUP_OPR_TYPE.C2L_REQUIRE_DEBUG:",udbid, rid)

	local sql = string.format("SELECT bTester FROM t_user where uid=%d",udbid)
	local err, bTester = xlDb_Query(sql)
	if err == 0 then
		if bTester == 2 then
			dofile("scripts/test.lua")
		end
	end
	
end

--������
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_HEART] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--uid
	local cRid = tonumber(tCmd[2])					--ʹ�ý�ɫrid
	local cPingClock = tonumber(tCmd[3])				--ping���͵�ʱ��
	local cLastDelay = tonumber(tCmd[4]) or 0			--��һ����ʱ
	
	--print("hVar.GROUP_OPR_TYPE.C2L_REQUIRE_HEART:",cUDbid, cRid)

	--�����û�����
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	local matchovertime = 0
	if user then
		--
	end

	--����ping��Ϣ
	local sCmd = ""
	sCmd = sCmd .. tostring(hGlobal.uMgr:GetOnlineCount()) .. ";"
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_NOTICE_PING, sCmd)
end

--�ͻ��������ʼ������
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_INIT] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--�˺�uid
	local cRid = tonumber(tCmd[2])				--��ɫrid
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			user:InitChat()
			local sCmd = user:ChatBaseInfoToCmd()
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_INIT, sCmd)
		end
	end
end

--�ͻ��������ѯ����id�б�
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_ID_LIST] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--�˺�uid
	local cRid = tonumber(tCmd[2])				--��ɫrid
	local chatType = tonumber(tCmd[3]) or 0		--����Ƶ��
	local friendUid = tonumber(tCmd[4]) or 0	--�Է�����uid
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			local sCmd = hGlobal.chatMgr:ChatIDToCmd(user, chatType, friendUid)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ID_LIST, sCmd)
		end
	end
end

--�ͻ�������ָ��������Ϣid�б������
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_CONTENT_LIST] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--�˺�uid
	local cRid = tonumber(tCmd[2])				--��ɫrid
	local chatType = tonumber(tCmd[3]) or 0		--����Ƶ��
	local friendUid = tonumber(tCmd[4]) or 0	--�������uid
	local index = tonumber(tCmd[5])				--��ǰ����
	local totalnum = tonumber(tCmd[6])			--������
	local msgNum = tonumber(tCmd[7])			--����id����
	local msgIDList = {}
	local rIdx = 8
	for i = 1, msgNum, 1 do
		local msgId = tonumber(tCmd[rIdx]) or 0	--������Ϣid
		msgIDList[#msgIDList+1] = msgId
		rIdx = rIdx + 1
	end
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			local sCmd = hGlobal.chatMgr:QueryChatMessageByIDList(user, chatType, friendUid, msgIDList)
			sCmd = tostring(index) .. ";" ..tostring(totalnum) .. ";" .. sCmd
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_CONTENT_LIST, sCmd)
		end
	end
end

--�ͻ��������ѯָ�����ŵ�����id�б�������Ա�ɲ�����
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_ID_LIST_GROUP_GM] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])		--�˺�uid
	local cRid = tonumber(tCmd[2])			--��ɫrid
	local chatType = tonumber(tCmd[3]) or 0		--����Ƶ��
	local touid = tonumber(tCmd[4]) or 0		--����id
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			local bTester = user:GetTester()
			if (bTester == 2) then --������Ա�ɲ���
				local sCmd = hGlobal.chatMgr:ChatIDToCmd(user, chatType, touid)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ID_LIST, sCmd)
			else
				--֪ͨ��Ҳ������
				local ret = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY --"��û��Ȩ�޽��д˲���"
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--�ͻ�������ָ�����ŵ�������Ϣid�б�����ݣ�������Ա�ɲ�����
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_CONTENT_LIST_GROUP_GM] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])		--�˺�uid
	local cRid = tonumber(tCmd[2])			--��ɫrid
	local chatType = tonumber(tCmd[3]) or 0		--����Ƶ��
	local touid = tonumber(tCmd[4]) or 0		--����id
	local index = tonumber(tCmd[5])				--��ǰ����
	local totalnum = tonumber(tCmd[6])			--������
	local msgNum = tonumber(tCmd[7])		--����id����
	local msgIDList = {}
	local rIdx = 8
	for i = 1, msgNum, 1 do
		local msgId = tonumber(tCmd[rIdx]) or 0	--������Ϣid
		msgIDList[#msgIDList+1] = msgId
		rIdx = rIdx + 1
	end
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			local bTester = user:GetTester()
			if (bTester == 2) then --������Ա�ɲ���
				local sCmd = hGlobal.chatMgr:QueryChatMessageByIDList(user, chatType, touid, msgIDList)
				sCmd = tostring(index) .. ";" ..tostring(totalnum) .. ";" .. sCmd
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_CONTENT_LIST, sCmd)
			else
				--֪ͨ��Ҳ������
				local ret = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY --"��û��Ȩ�޽��д˲���"
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--�ͻ���������һ��������Ϣ
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_SEND_MESSAGE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--�˺�uid
	local cRid = tonumber(tCmd[2])				--��ɫrid
	local chatType = tonumber(tCmd[3]) or 0		--����Ƶ��
	local msgType = tonumber(tCmd[4]) or 0		--��������
	local userName = tostring(tCmd[5])			--�����
	local channelId = tonumber(tCmd[6]) or 0	--������
	local vipLv = tonumber(tCmd[7]) or 0		--vip�ȼ�
	local borderId = tonumber(tCmd[8]) or 0		--��ұ߿�id
	local iconId = tonumber(tCmd[9]) or 0		--���ͷ��id
	local championId = tonumber(tCmd[10]) or 0	--��ҳƺ�id
	local leaderId = tonumber(tCmd[11]) or 0	--��һ᳤id
	local dragonId = tonumber(tCmd[12]) or 0	--�����������id
	local headId = tonumber(tCmd[13]) or 0		--���ͷ��id
	local lineId = tonumber(tCmd[14]) or 0		--�������id
	local message = tostring(tCmd[15])		--��������
	local touid = tonumber(tCmd[16]) or 0		--������uid
	local result = tonumber(tCmd[17]) or 0		--�ɽ���������Ϣ�Ĳ������
	local resultParam = tonumber(tCmd[18]) or 0	--�ɽ���������Ϣ�Ĳ�������
	local tolist = hApi.Split(tCmd[19], "|")	--ָ�����͵�uid�б�
	
	local tMsg = {}
	tMsg.chatType = chatType
	tMsg.msgType = msgType
	tMsg.uid = cUDbid
	tMsg.name = userName
	tMsg.channelId = channelId
	tMsg.vip = vipLv
	tMsg.borderId = borderId
	tMsg.iconId = iconId
	tMsg.championId = championId
	tMsg.leaderId = leaderId
	tMsg.dragonId = dragonId
	tMsg.headId = headId
	tMsg.lineId = lineId
	tMsg.content = message
	tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
	tMsg.touid = touid
	tMsg.result = result
	tMsg.resultParam = resultParam
	
	--print(chatType, msgType, cUDbid, userName, touid)
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			local ret, chat = hGlobal.chatMgr:AddMessage(user, tMsg)
			if (ret == 1) then --�����ɹ�
				if (chatType == hVar.CHAT_TYPE.WORLD) then --��������Ƶ��
					--ȫ��֪ͨ��Ϣ: ���������Ϣ
					local alludbid = hGlobal.uMgr:GetAllUserUID()
					local sCmd = chat:ToCmd()
					hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
				elseif (chatType == hVar.CHAT_TYPE.INVITE) then --��������Ƶ��
					--ȫ��֪ͨ��Ϣ: ���������Ϣ
					local alludbid = hGlobal.uMgr:GetAllUserUID()
					local sCmd = chat:ToCmd()
					hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
				elseif (chatType == hVar.CHAT_TYPE.PRIVATE) then --˽��Ƶ��
					--��֪˽�ĵ�˫����Ϣ
					local sCmd = chat:ToCmd()
					hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
					hApi.xlNet_Send(touid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
				elseif (chatType == hVar.CHAT_TYPE.GROUP) then --����Ƶ��
					--����֪ͨ��Ϣ: ���������Ϣ
					local tUserTable = hGlobal.groupMgr:GetGroupAllUser(touid)
					local sCmd = chat:ToCmd()
					if tUserTable then
						for uid, level in pairs(tUserTable) do
							hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
						end
					end
				elseif (chatType == hVar.CHAT_TYPE.COUPLE) then --���Ƶ��
					local sCmd = chat:ToCmd()
					--����uid�б�
					for i = 1, #tolist, 1 do
						local to_uid = tonumber(tolist[i]) or 0
						if (to_uid > 0) then
							hApi.xlNet_Send(to_uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
						end
					end
				end
			else --����ʧ��
				--֪ͨ��Ҳ������
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--�ͻ���������һ����Ӹ�������������Ϣ
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_SEND_MESSAGE_BATTLE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--�˺�uid
	local cRid = tonumber(tCmd[2])				--��ɫrid
	local chatType = tonumber(tCmd[3]) or 0		--����Ƶ��
	local msgType = tonumber(tCmd[4]) or 0		--��������
	local userName = tostring(tCmd[5])			--�����
	local channelId = tonumber(tCmd[6]) or 0	--������
	local vipLv = tonumber(tCmd[7]) or 0		--vip�ȼ�
	local borderId = tonumber(tCmd[8]) or 0		--��ұ߿�id
	local iconId = tonumber(tCmd[9]) or 0		--���ͷ��id
	local championId = tonumber(tCmd[10]) or 0	--��ҳƺ�id
	local leaderId = tonumber(tCmd[11]) or 0	--��һ᳤id
	local dragonId = tonumber(tCmd[12]) or 0	--�����������id
	local headId = tonumber(tCmd[13]) or 0		--���ͷ��id
	local lineId = tonumber(tCmd[14]) or 0		--�������id
	local message = tostring(tCmd[15])		--��������
	local touid = tonumber(tCmd[16]) or 0		--������uid
	local result = tonumber(tCmd[17]) or 0		--�ɽ���������Ϣ�Ĳ������
	local resultParam = tonumber(tCmd[18]) or 0	--�ɽ���������Ϣ�Ĳ�������
	local tolist = hApi.Split(tCmd[19], "|")	--ָ�����͵�uid�б�
	
	local tMsg = {}
	tMsg.chatType = chatType
	tMsg.msgType = msgType
	tMsg.uid = cUDbid
	tMsg.name = userName
	tMsg.channelId = channelId
	tMsg.vip = vipLv
	tMsg.borderId = borderId
	tMsg.iconId = iconId
	tMsg.championId = championId
	tMsg.leaderId = leaderId
	tMsg.dragonId = dragonId
	tMsg.headId = headId
	tMsg.lineId = lineId
	tMsg.content = message
	tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
	tMsg.touid = touid
	tMsg.result = result
	tMsg.resultParam = resultParam
	
	--print(chatType, msgType, cUDbid, userName, touid)
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			local ret, chat = hGlobal.chatMgr:AddMessage(user, tMsg)
			if (ret == 1) then --�����ɹ�
				--ȫ��֪ͨ��Ϣ: ���������Ϣ
				local alludbid = hGlobal.uMgr:GetAllUserUID()
				local sCmd = chat:ToCmd()
				hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
				
				--֪ͨ�����ߣ���������Ӹ�����Ϣ�Ĳ���������ɹ���
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SEND_MESSAGE_BATTLE, tostring(ret) .. ";" .. tostring(chat:GetID()) .. ";")
			else --����ʧ��
				--֪ͨ��Ҳ������
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
				
				--֪ͨ�����ߣ���������Ӹ�����Ϣ�Ĳ��������ʧ�ܣ�
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SEND_MESSAGE_BATTLE, tostring(ret) .. ";0;")
			end
		end
	end
end

--�ͻ���������һ�����Ž���ϵͳ������Ϣ
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_SEND_GROUP_SYSTEM_MESSAGE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--�˺�uid
	local cRid = tonumber(tCmd[2])				--��ɫrid
	local message = tostring(tCmd[3])			--��������
	local nInteractType = tonumber(tCmd[4]) or 0	--�ɽ���ʽ�¼�������
	
	--print(cUDbid, cRid, message)
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			local groupId = hGlobal.groupMgr:GetUserGroupID(udbid) --������ڵĹ���id
			--print(groupId)
			if (groupId > 0) then
				--���;�����Ϣ
				local tMsg = {}
				tMsg.chatType = hVar.CHAT_TYPE.GROUP
				tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_TODAY --����ϵͳ������ʾ��Ϣ
				tMsg.uid = 0
				tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"ϵͳ"
				tMsg.channelId = 0
				tMsg.vip = 0
				tMsg.borderId = 1000
				tMsg.iconId = 1000
				tMsg.championId = 0
				tMsg.leaderId = 0
				tMsg.dragonId = 0
				tMsg.headId = 0
				tMsg.lineId = 0
				tMsg.content = message
				tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
				tMsg.touid = groupId
				tMsg.result = nInteractType --�ɽ���ʽ�¼�������
				tMsg.resultParam = cUDbid --�ɽ����¼��Ĳ���Ϊ������uid
				--���;�����Ϣ
				hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
			end
		end
	end
end

--�ͻ���������һ������ؿ�ͨ��ϵͳ������Ϣ
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_SEND_WORLD_BATTLE_SYSTEM_MESSAGE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--�˺�uid
	local cRid = tonumber(tCmd[2])				--��ɫrid
	local message = tostring(tCmd[3])			--��������
	
	--print(cUDbid, cRid, message)
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--����������Ϣ
			local tMsg = {}
			tMsg.chatType = hVar.CHAT_TYPE.WORLD --��������Ƶ��
			tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_USER_BATTLE --ϵͳ�ı���ҹؿ�ͨ����Ϣ
			tMsg.uid = 0
			tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"ϵͳ"
			tMsg.channelId = 0
			tMsg.vip = 0
			tMsg.borderId = 1000
			tMsg.iconId = 1000
			tMsg.championId = 0
			tMsg.leaderId = 0
			tMsg.dragonId = 0
			tMsg.headId = 0
			tMsg.lineId = 0
			tMsg.content = message
			tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
			tMsg.touid = 0
			tMsg.result = 0 --�ɽ���ʽ�¼�������
			tMsg.resultParam = 0 --�ɽ����¼��Ĳ���Ϊ������uid
			
			--����������Ϣ
			local ret, chat = hGlobal.chatMgr:AddMessage(nil, tMsg)
			if (ret == 1) then --�����ɹ�
				--ȫ��֪ͨ��Ϣ: ���������Ϣ
				local alludbid = hGlobal.uMgr:GetAllUserUID()
				local sCmd = chat:ToCmd()
				hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
			end
		end
	end
end

--�ͻ����������һ��������Ϣ
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_UPDATE_MESSAGE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--�˺�uid
	local cRid = tonumber(tCmd[2])				--��ɫrid
	local chatType = tonumber(tCmd[3]) or 0		--����Ƶ��
	local msgId = tonumber(tCmd[4]) or 0		--��Ϣid
	local touid = tonumber(tCmd[5]) or 0		--������uid
	--print(chatType, msgId, touid)
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--��Ϣ����
			local chat = nil
			
			if (chatType == hVar.CHAT_TYPE.WORLD) then --��������Ƶ��
				--��ȡ������Ϣ
				chat = hGlobal.chatMgr:GetWorldMsg(msgId)
			elseif (chatType == hVar.CHAT_TYPE.INVITE) then --����Ƶ��
				--��ȡ������Ϣ
				chat = hGlobal.chatMgr:GetInviteMsg(msgId)
			elseif (chatType == hVar.CHAT_TYPE.PRIVATE) then --˽��Ƶ��
				--
			elseif (chatType == hVar.CHAT_TYPE.GROUP) then --����Ƶ��
				--��ȡ������Ϣ
				chat = hGlobal.chatMgr:GetGroupMsg(touid, msgId)
				--print("chat=", chat)
			end
			
			if chat then
				--֪ͨ��Ҵ���Ϣ��������
				local sCmd = chat:ToCmd()
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_UPDATE_MESSAGE, sCmd)
			end
		end
	end
end

--�ͻ�������ɾ��һ��������Ϣ��ֻ�й���Ա����Ȩ�޲�����
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_REMOVE_MESSGAE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--�˺�uid
	local cRid = tonumber(tCmd[2])				--��ɫrid
	local msgId = tonumber(tCmd[3]) or 0		--��ϢΨһid
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			local ret = hGlobal.chatMgr:RemoveMessage(user, msgId)
			
			if (ret == 1) then --�����ɹ�
				--ȫ��֪ͨ��Ϣ: ɾ�����������Ϣ
				local alludbid = hGlobal.uMgr:GetAllUserUID()
				local sCmd = tostring(msgId)
				hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
			else --����ʧ��
				--֪ͨ��Ҳ������
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--�ͻ�������ɾ��һ����Ӹ�������������Ϣ
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_REMOVE_MESSGAE_BATTLE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--�˺�uid
	local cRid = tonumber(tCmd[2])				--��ɫrid
	local msgId = tonumber(tCmd[3]) or 0		--��ϢΨһid
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			local ret = hGlobal.chatMgr:RemoveBattleCoupleMessage(user, msgId)
			
			if (ret == 1) then --�����ɹ�
				--ȫ��֪ͨ��Ϣ: ɾ�����������Ϣ
				local alludbid = hGlobal.uMgr:GetAllUserUID()
				local sCmd = tostring(msgId)
				hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
			else --����ʧ��
				--geyachao: ��Ϣ������Ҳ������ʾ������Ϣ
				--[[
				--֪ͨ��Ҳ������
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
				]]
			end
		end
	end
end

--�ͻ����������������죨ֻ�й���Ա����Ȩ�޲�����
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_FORBIDDEN_USER] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--�˺�uid
	local cRid = tonumber(tCmd[2])				--��ɫrid
	local forbiddenUid = tonumber(tCmd[3]) or 0	--���Ե����id
	local minute = tonumber(tCmd[4]) or 0		--���Ե�ʱ������λ: ���ӣ�
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--�������
			local ret, forbiddenUName = hGlobal.chatMgr:ForbiddenUser(user, forbiddenUid, minute)
			
			if (ret == 1) then --�����ɹ�
				--����ȫ�����һ��������Ϣ
				local sysMsgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_FORBIDDEN --������ϵͳ��Ϣ
				local content = string.format(hVar.tab_string["__TEXT_CHAT_FORBIDDEN"], forbiddenUName, minute)
				--�������1�죬��Ϊ��ʾ����n��
				local day = math.floor(minute / 1440)
				local minuteMod = minute - day * 1440
				--if (day > 0) and (minuteMod == 0) then
				if (day > 0) then
					content = string.format(hVar.tab_string["__TEXT_CHAT_FORBIDDEN_DAY"], forbiddenUName, day)
				end
				local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
				hGlobal.chatMgr:SendSystemMessage(sysMsgType, content, strDate)
				
				--��������Ե�������ߣ��������ͱ����Ե�֪ͨ
				local forbiddenUser = hGlobal.uMgr:FindChatUserByDBID(forbiddenUid)
				if forbiddenUser then
					local sCmd = forbiddenUser:ChatBaseInfoToCmd()
					hApi.xlNet_Send(forbiddenUser:GetUID(), hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_USER_FORBIDDEN, sCmd)
				end
			else --����ʧ��
				--֪ͨ��Ҳ������
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--�ͻ�������ͶԷ���ҷ���˽��
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_PRIVATE_INVITE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--�˺�uid
	local cRid = tonumber(tCmd[2])					--��ɫrid
	local userName = tostring(tCmd[3])				--�ҵ������
	local channelId = tonumber(tCmd[4]) or 0		--�ҵ�������
	local vipLv = tonumber(tCmd[5]) or 0			--�ҵ�vip�ȼ�
	local borderId = tonumber(tCmd[6]) or 0			--�ҵ���ұ߿�id
	local iconId = tonumber(tCmd[7]) or 0			--�ҵ����ͷ��id
	local championId = tonumber(tCmd[8]) or 0		--�ҵ���ҳƺ�id
	local leaderId = tonumber(tCmd[9]) or 0			--��һ᳤id
	local dragonId = tonumber(tCmd[10]) or 0		--�����������id
	local headId = tonumber(tCmd[11]) or 0			--���ͷ��id
	local lineId = tonumber(tCmd[12]) or 0			--�������id
	local friendUid = tonumber(tCmd[13]) or 0		--�Է��˺�uid
	local friendUserName = tostring(tCmd[14])		--�Է������
	local friendChannelId = tonumber(tCmd[15]) or 0		--�Է�������
	local friendVipLv = tonumber(tCmd[16]) or 0		--�Է�vip�ȼ�
	local friendBorderId = tonumber(tCmd[17]) or 0		--�Է���ұ߿�id
	local friendIconId = tonumber(tCmd[18]) or 0		--�Է����ͷ��id
	local friendChampionId = tonumber(tCmd[19]) or 0	--�Է���ҳƺ�id
	local friendLeaderId = tonumber(tCmd[20]) or 0		--�Է���һ᳤id
	local friendDragonId = tonumber(tCmd[21]) or 0		--�Է������������id
	local friendHeadId = tonumber(tCmd[22]) or 0		--�Է����ͷ��id
	local friendLineId = tonumber(tCmd[23]) or 0		--�Է��������id
	
	--print(friendIconId, friendChampionId, friendLeaderId)
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			local tMsgMe = {}
			tMsgMe.uid = udbid
			tMsgMe.name = userName
			tMsgMe.channelId = channelId
			tMsgMe.vip = vipLv
			tMsgMe.borderId = borderId
			tMsgMe.iconId = iconId
			tMsgMe.championId = championId
			tMsgMe.leaderId = leaderId
			tMsgMe.dragonId = dragonId
			tMsgMe.headId = headId
			tMsgMe.lineId = lineId
			
			local tMsgFriend = {}
			tMsgFriend.uid = friendUid
			tMsgFriend.name = friendUserName
			tMsgFriend.channelId = friendChannelId
			tMsgFriend.vip = friendVipLv
			tMsgFriend.borderId = friendBorderId
			tMsgFriend.iconId = friendIconId
			tMsgFriend.championId = friendChampionId
			tMsgFriend.leaderId = friendLeaderId
			tMsgFriend.dragonId = friendDragonId
			tMsgFriend.headId = friendHeadId
			tMsgFriend.lineId = friendLineId
			
			--��������˽��
			local ret = user:PrivateInviteUser(tMsgMe, tMsgFriend)
			
			if (ret == 1) then --�����ɹ�
				--֪ͨ������ӵ���˽�ĺ���
				local sCmdFriendInfo = user:SingleFriendInfoToCmd(friendUid)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_PRIVATE_USER, sCmdFriendInfo)
				
				--֪ͨ�Է����ӵ���˽�ĺ���
				local friendUser = hGlobal.uMgr:FindChatUserByDBID(friendUid)
				--����Է���Ҵ���
				if friendUser then
					local sCmdFriendInfo = friendUser:SingleFriendInfoToCmd(udbid)
					hApi.xlNet_Send(friendUid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_PRIVATE_USER, sCmdFriendInfo)
				end
				
				--֪ͨ��ҷ���˽�Ľ�����ɹ���
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_PRIVATE_INVITE, sCmd)
			else --����ʧ��
				--֪ͨ��Ҳ������
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
				
				--֪ͨ��ҷ���˽�Ľ����ʧ�ܣ�
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_PRIVATE_INVITE, sCmd)
			end
		end
	end
end

--�ͻ���˽����֤��Ϣ�Ĳ���
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_PRIVATE_INVITE_OP] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--�˺�uid
	local cRid = tonumber(tCmd[2])					--��ɫrid
	local msgId = tonumber(tCmd[3]) or 0			--��ϢΨһid
	local touid = tonumber(tCmd[4]) or 0			--��Ϣ������uid
	local inviteFlag = tonumber(tCmd[5]) or 0		--�������
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--˽���������
			local ret = user:PrivateInviteOperation(msgId, touid, inviteFlag)
			
			if (ret == 1) then --�����ɹ�
				--������
				--...
			else --����ʧ��
				--֪ͨ��Ҳ������
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--�ͻ�������ɾ��˽�ĺ���
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_CHAT_PRIVATE_DELETE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--�˺�uid
	local cRid = tonumber(tCmd[2])					--��ɫrid
	local touid = tonumber(tCmd[3]) or 0			--��Ϣ������uid
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--˽���������
			local ret = user:PrivateDeleteFriend(touid)
			
			if (ret == 1) then --�����ɹ�
				--֪ͨ���ɾ������
				local sCmd = tostring(touid)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_PRIVATE_USER, sCmd)
			else --����ʧ��
				--֪ͨ��Ҳ������
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--�ͻ�������һ�ս������Ƭ
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_EXCHAGE_TACTIC_DEBRIS] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--�˺�uid
	local cRid = tonumber(tCmd[2])					--��ɫrid
	local cardNum = tonumber(tCmd[3]) or 0			--ѡ��Ŀ�Ƭ����������
	local tCardList = {}
	local rIdx = 3
	for i = 1, cardNum, 1 do
		local tTacticInfo = hApi.Split(tCmd[rIdx+i], ":")
		local tacticId = tonumber(tTacticInfo[1]) or 0 --ս����id
		local tacticNum = tonumber(tTacticInfo[2]) or 0 --ս��������
		--print(tacticId, tacticNum)
		tCardList[#tCardList+1] = {id = tacticId, num = tacticNum,}
	end
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--����һ�ս������Ƭ
			local sCmd = NoviceCampMgr.ExchangeTacticDebris(udbid, rid, tCardList)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_EXCHAGE_TACTIC_DEBRIS, sCmd)
		end
	end
end

--�ͻ��������ѯӢ�۽�����Ϣ
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_HERO_DEBRIS_INFO] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--�˺�uid
	local cRid = tonumber(tCmd[2])					--��ɫrid
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--����һ�ս������Ƭ
			local tHeroInfo, sCmd = hGlobal.heroDebrisMgr:DBGetUserHeroDebris(udbid, rid)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_QUERY_HERO_DEBRIS_INFO, sCmd)
		end
	end
end

--�ͻ�������һ�Ӣ�۽���
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_EXCHAGE_HERO_DEBRIS] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--�˺�uid
	local cRid = tonumber(tCmd[2])					--��ɫrid
	local cardNum = tonumber(tCmd[3]) or 0			--ѡ��Ŀ�Ƭ����������
	local tCardList = {}
	local rIdx = 3
	for i = 1, cardNum, 1 do
		local tTacticInfo = hApi.Split(tCmd[rIdx+i], ":")
		local heroId = tonumber(tTacticInfo[1]) or 0 --Ӣ��id
		local heroNum = tonumber(tTacticInfo[2]) or 0 --Ӣ������
		--print(heroId, heroNum)
		tCardList[#tCardList+1] = {id = heroId, num = heroNum,}
	end
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--����һ�Ӣ�۽���
			local sCmd = NoviceCampMgr.ExchangeHeroDebris(udbid, rid, tCardList)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_EXCHAGE_HERO_DEBRIS, sCmd)
		end
	end
end

--�ͻ�����������Ÿ�������
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_BUY_BATTLE_COUNT] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--�˺�uid
	local cRid = tonumber(tCmd[2])					--��ɫrid
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--��������Ÿ�������
			local sCmd = NoviceCampMgr.BuyGroupBattleCount(udbid, rid)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_BUY_BATTLE_COUNT, sCmd)
		end
	end
end

--�ͻ��������;��ź��
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_SEND_GROUP_REDPACKET] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--�˺�uid
	local cRid = tonumber(tCmd[2])				--��ɫrid
	local userName = tostring(tCmd[3])			--�����
	local channelId = tonumber(tCmd[4]) or 0	--������
	local vipLv = tonumber(tCmd[5]) or 0		--vip�ȼ�
	local borderId = tonumber(tCmd[6]) or 0		--��ұ߿�id
	local iconId = tonumber(tCmd[7]) or 0		--���ͷ��id
	local championId = tonumber(tCmd[8]) or 0	--��ҳƺ�id
	local leaderId = tonumber(tCmd[9]) or 0		--��һ᳤id
	local dragonId = tonumber(tCmd[10]) or 0	--�����������id
	local headId = tonumber(tCmd[11]) or 0		--���ͷ��id
	local lineId = tonumber(tCmd[12]) or 0		--�������id
	local groupId = tonumber(tCmd[13])		--����id
	local sendIndex = tonumber(tCmd[14])		--�������
	
	local tMsg = {}
	tMsg.chatType = hVar.CHAT_TYPE.GROUP
	tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND --���ŷ����
	tMsg.uid = cUDbid
	tMsg.name = userName
	tMsg.channelId = channelId
	tMsg.vip = vipLv
	tMsg.borderId = borderId
	tMsg.iconId = iconId
	tMsg.championId = championId
	tMsg.leaderId = leaderId
	tMsg.dragonId = dragonId
	tMsg.headId = headId
	tMsg.lineId = lineId
	tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_SEND_REDPACKET"], userName)
	tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
	tMsg.touid = groupId
	tMsg.result = hVar.RED_PACKET_TYPE.GROUP_SEND --�ɽ����¼��Ľ�������
	tMsg.resultParam = 0
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--�����;��ź��
			local ret, sRetCmd = hGlobal.redPacketGroupMgr:SendRedPacket(user, rid, groupId, sendIndex, tMsg)
			
			if (ret == 1) then --�����ɹ�
				--֪ͨ��ҷ�������
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_SEND_REDPACKET, sRetCmd)
			else --����ʧ��
				--֪ͨ��ҷ�������
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_SEND_REDPACKET, sRetCmd)
				
				--֪ͨ��Ҳ������
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--�ͻ���������ȡ���ź��
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_RECEIVE_GROUP_REDPACKET] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--�˺�uid
	local cRid = tonumber(tCmd[2])				--��ɫrid
	local userName = tostring(tCmd[3])			--�����
	local channelId = tonumber(tCmd[4]) or 0	--������
	local vipLv = tonumber(tCmd[5]) or 0		--vip�ȼ�
	local borderId = tonumber(tCmd[6]) or 0		--��ұ߿�id
	local iconId = tonumber(tCmd[7]) or 0		--���ͷ��id
	local championId = tonumber(tCmd[8]) or 0	--��ҳƺ�id
	local leaderId = tonumber(tCmd[9]) or 0		--��һ᳤id
	local dragonId = tonumber(tCmd[10]) or 0	--�����������id
	local headId = tonumber(tCmd[11]) or 0		--���ͷ��id
	local lineId = tonumber(tCmd[12]) or 0		--�������id
	local groupId = tonumber(tCmd[13])		--����id
	local redPacketId = tonumber(tCmd[14])		--���id
	
	--�������������
	--local redPacketSendName = ""
	local redPacketGroup = hGlobal.redPacketGroupMgr:GetRedPacket(redPacketId)
	--if redPacketGroup then
	--	redPacketSendName = redPacketGroup._send_name
	--end
	
	local tMsg = {}
	tMsg.chatType = hVar.CHAT_TYPE.GROUP
	tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_RECEIVE
	tMsg.uid = 0
	tMsg.name = userName
	tMsg.channelId = 0 --channelId
	tMsg.vip = 0 --vipLv
	tMsg.borderId = 1000 --borderId
	tMsg.iconId = 1000 --iconId
	tMsg.championId = 0 --championId
	tMsg.leaderId = 0 --leaderId
	tMsg.dragonId = 0 --dragonId
	tMsg.headId = 0 --headId
	tMsg.lineId = 0 --lineId
	tMsg.content = "" --string.format(hVar.tab_string["__TEXT_CHAT_GROUP_RECEIVE_REDPACKET"], userName, redPacketSendName)
	tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
	tMsg.touid = groupId
	tMsg.result = hVar.RED_PACKET_TYPE.GROUP_RECEIVE --�ɽ����¼��Ľ�������
	tMsg.resultParam = 0
	
	--�����ȡ�����֣�Ԥ����Ƿ񱾴�������
	--if ((redPacketGroup._send_num - redPacketGroup._receive_num - 1) <= 0) then
	--	tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_RECEIVE_EMPTY_REDPACKET"], userName, redPacketSendName)
	--end
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--������ȡ���ź��
			local ret, sRetCmd = hGlobal.redPacketGroupMgr:ReceiveRedPacket(user, rid, groupId, redPacketId, tMsg)
			
			if (ret == 1) then --�����ɹ�
				--֪ͨ����������
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_RECEIVE_REDPACKET, sRetCmd)
				
				--����֪ͨ��Ϣ: ����������Ϣ
				local msgIdRedPacket = redPacketGroup._msg_id
				--print("msgIdRedPacket=", msgIdRedPacket)
				local chatRedPacket = hGlobal.chatMgr:GetGroupMsg(groupId, msgIdRedPacket)
				--print("chatRedPacket=", chatRedPacket)
				if chatRedPacket then
					local sCmdRedPacket = chatRedPacket:ToCmd()
					--print("sCmdRedPacket=", sCmdRedPacket)
					local tUserTable = hGlobal.groupMgr:GetGroupAllUser(groupId)
					if tUserTable then
						for uid, level in pairs(tUserTable) do
							--print("uid=", uid, "level=", level)
							hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_UPDATE_MESSAGE, sCmdRedPacket)
						end
					end
				end
			else --����ʧ��
				--֪ͨ����������
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_RECEIVE_REDPACKET, sRetCmd)
				
				--֪ͨ��Ҳ������
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--�ͻ���������ȡ֧�������������
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_RECEIVE_PAY_REDPACKET] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--�˺�uid
	local cRid = tonumber(tCmd[2])				--��ɫrid
	local userName = tostring(tCmd[3])			--�����
	local channelId = tonumber(tCmd[4]) or 0	--������
	local vipLv = tonumber(tCmd[5]) or 0		--vip�ȼ�
	local borderId = tonumber(tCmd[6]) or 0		--��ұ߿�id
	local iconId = tonumber(tCmd[7]) or 0		--���ͷ��id
	local championId = tonumber(tCmd[8]) or 0	--��ҳƺ�id
	local leaderId = tonumber(tCmd[9]) or 0		--��һ᳤id
	local dragonId = tonumber(tCmd[10]) or 0	--�����������id
	local headId = tonumber(tCmd[11]) or 0		--���ͷ��id
	local lineId = tonumber(tCmd[12]) or 0		--�������id
	local redPacketId = tonumber(tCmd[13])		--���id
	
	--�������������
	--local redPacketSendName = ""
	local redPacketPay = hGlobal.redPacketPayMgr:GetRedPacket(redPacketId)
	--if redPacketPay then
	--	redPacketSendName = redPacketPay._send_name
	--end
	
	local tMsg = {}
	tMsg.chatType = hVar.CHAT_TYPE.WORLD --������Ϣ
	tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_RECEIVE
	tMsg.uid = udbid
	tMsg.name = userName
	tMsg.channelId = channelId
	tMsg.vip = vipLv
	tMsg.borderId = borderId
	tMsg.iconId = iconId
	tMsg.championId = championId
	tMsg.leaderId = leaderId
	tMsg.dragonId = dragonId
	tMsg.headId = headId
	tMsg.lineId = lineId
	tMsg.content = "" --string.format(hVar.tab_string["__TEXT_CHAT_GROUP_RECEIVE_REDPACKET"], userName, redPacketSendName)
	tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
	tMsg.touid = 0
	tMsg.result = hVar.RED_PACKET_TYPE.PAY_RECEIVE --�ɽ����¼��Ľ�������
	tMsg.resultParam = 0
	
	--�����ȡ�����֣�Ԥ����Ƿ񱾴�������
	--if ((redPacketPay._send_num - redPacketPay._receive_num - 1) <= 0) then
	--	tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_RECEIVE_EMPTY_REDPACKET"], userName, redPacketSendName)
	--end
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--������ȡ֧�������������
			local ret, sRetCmd = hGlobal.redPacketPayMgr:ReceiveRedPacket(user, rid, redPacketId, tMsg)
			
			if (ret == 1) then --�����ɹ�
				--֪ͨ����������
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_PAY_RECEIVE_REDPACKET, sRetCmd)
				
				--֪ͨȫ����ң�����������Ϣ
				local msgIdRedPacket = redPacketPay._msg_id
				--print("msgIdRedPacket=", msgIdRedPacket)
				local chatRedPacket = hGlobal.chatMgr:GetWorldMsg(msgIdRedPacket)
				--print("chatRedPacket=", chatRedPacket)
				if chatRedPacket then
					local sCmdRedPacket = chatRedPacket:ToCmd()
					--print("sCmdRedPacket=", sCmdRedPacket)
					local alludbid = hGlobal.uMgr:GetAllUserUID()
					hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_UPDATE_MESSAGE, sCmdRedPacket)
				end
			else --����ʧ��
				--֪ͨ����������
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_PAY_RECEIVE_REDPACKET, sRetCmd)
				
				--֪ͨ��Ҳ������
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--�ͻ�������鿴֧�����������������ȡ����
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_VIEWDETAIL_PAY_REDPACKET] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--�˺�uid
	local cRid = tonumber(tCmd[2])				--��ɫrid
	local redPacketId = tonumber(tCmd[3])		--���id
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--����鿴֧��������������ĵ���ȡ����
			local ret, sRetCmd = hGlobal.redPacketPayMgr:ViewDetailRedPacket(user, rid, redPacketId)
			
			if (ret == 1) then --�����ɹ�
				--֪ͨ��Ҳ鿴�������ȡ������
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_PAY_VIEWDETAIL_REDPACKET, sRetCmd)
			else --����ʧ��
				--֪ͨ��Ҳ鿴�������ȡ������
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_PAY_VIEWDETAIL_REDPACKET, sRetCmd)
				
				--֪ͨ��Ҳ������
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--�ͻ��������ѯ���ž�������������
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_MILITARY_TASK_INFO] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--�˺�uid
	local cRid = tonumber(tCmd[2])					--��ɫrid
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--�����ѯ���ž�������������
			local sCmd = NoviceCampMgr.QueryGroupMilitaryTaskState(udbid, rid)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_MILITARY_TASK_QUERY, sCmd)
		end
	end
end

--�ͻ���������ȡ���ž�������
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_MILITARY_TASK_TAKEREWARD] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--�˺�uid
	local cRid = tonumber(tCmd[2])					--��ɫrid
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--������ȡ���ž�������
			local sCmd = NoviceCampMgr.TakeRewardGroupMilitaryTask(udbid, rid)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_MILITARY_TASK_TAKEREWARD, sCmd)
		end
	end
end

--�ͻ��������߳����ڲ����ߵ��������ŵ���ң�������Ա�ɲ�����
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_KICK_OFFLINE_PLAYER] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--�˺�uid
	local cRid = tonumber(tCmd[2])					--��ɫrid
	local groupId = tonumber(tCmd[3])				--����id
	local kickUid = tonumber(tCmd[4])				--�߳������id
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--�����߳����ڲ����ߵ��������ŵ���ң�������Ա�ɲ�����
			local sCmd = NoviceCampMgr.KickGroupOfflinePlayer(udbid, rid, groupId, kickUid)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_KICK_OFFLINE_PLAYER, sCmd)
		end
	end
end

--�ͻ��������������Ϊ�᳤��������Ա�ɲ�����
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_ASSET_ADMIN_PLAYER] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--�˺�uid
	local cRid = tonumber(tCmd[2])					--��ɫrid
	local groupId = tonumber(tCmd[3])				--����id
	local kickUid = tonumber(tCmd[4])				--���������id
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--�����������Ϊ�᳤��������Ա�ɲ�����
			local sCmd = NoviceCampMgr.AssetAdminPlayer(udbid, rid, groupId, kickUid)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_ASSET_ADMIN_PLAYER, sCmd)
		end
	end
end

--�᳤����ת�þ��Ÿ�����
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_TRANSFER] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--�˺�uid
	local cRid = tonumber(tCmd[2])					--��ɫrid
	local groupId = tonumber(tCmd[3])				--����id
	local kickUid = tonumber(tCmd[4])				--ת�õ����id
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--�᳤����ת�þ��Ÿ�����
			local sCmd = NoviceCampMgr.AssetGroupTransfer(udbid, rid, groupId, kickUid)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_TRANSFER, sCmd)
		end
	end
end

--�ͻ��������ɢ���ţ�������Ա�ɲ�����
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_DISOLUTE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--�˺�uid
	local cRid = tonumber(tCmd[2])					--��ɫrid
	local groupId = tonumber(tCmd[3])				--����id
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--�����ɢ���ţ�������Ա�ɲ�����
			local sCmd = NoviceCampMgr.AssetGroupDisolute(udbid, rid, groupId)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_DISOLUTE, sCmd)
		end
	end
end

--�ͻ������󴴽��������뺯
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_INVITE_CREATE] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])			--�˺�uid
	local cRid = tonumber(tCmd[2])				--��ɫrid
	local userName = tostring(tCmd[3])			--�����
	local channelId = tonumber(tCmd[4]) or 0	--������
	local vipLv = tonumber(tCmd[5]) or 0		--vip�ȼ�
	local borderId = tonumber(tCmd[6]) or 0		--��ұ߿�id
	local iconId = tonumber(tCmd[7]) or 0		--���ͷ��id
	local championId = tonumber(tCmd[8]) or 0	--��ҳƺ�id
	local leaderId = tonumber(tCmd[9]) or 0		--��һ᳤id
	local dragonId = tonumber(tCmd[10]) or 0	--�����������id
	local headId = tonumber(tCmd[11]) or 0		--���ͷ��id
	local lineId = tonumber(tCmd[12]) or 0		--�������id
	local groupId = tonumber(tCmd[13])		--����id
	local dayMin = tonumber(tCmd[14])		--��Ҫ����Сע������
	local vipMin = tonumber(tCmd[15])		--��Ҫ����Сvip�ȼ�
	
	local tMsg = {}
	tMsg.chatType = hVar.CHAT_TYPE.INVITE
	tMsg.msgType = hVar.MESSAGE_TYPE.INVITE_GROUP --�������뺯
	tMsg.uid = cUDbid
	tMsg.name = userName
	tMsg.channelId = channelId
	tMsg.vip = vipLv
	tMsg.borderId = borderId
	tMsg.iconId = iconId
	tMsg.championId = championId
	tMsg.leaderId = leaderId
	tMsg.dragonId = dragonId
	tMsg.headId = headId
	tMsg.lineId = lineId
	tMsg.content = hVar.tab_string["__TEXT_CHAT_GROUP_INVITE_SEND"]
	tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
	tMsg.touid = groupId
	tMsg.result = hVar.GROUP_INVITE_TYPE.GROUP_INVITE_SEND --�ɽ����¼��Ľ�������
	tMsg.resultParam = 0
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--�����������뺯
			local ret, sCmd = hGlobal.inviteGroupMgr:AddGroupInvite(user, rid, groupId, dayMin, vipMin, tMsg)
			if (ret == 1) then
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_INVITE_CREATE, sCmd)
			else --����ʧ��
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_INVITE_CREATE, sCmd)
				
				--֪ͨ��Ҳ������
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

--�ͻ����������������뺯
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_INVITE_JOIN] = function(udbid, rid, msgId, tCmd)
	local cUDbid = tonumber(tCmd[1])				--�˺�uid
	local cRid = tonumber(tCmd[2])					--��ɫrid
	local groupInviteId = tonumber(tCmd[3])				--�������뺯id
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--�������������뺯
			local ret, sCmd = hGlobal.inviteGroupMgr:GroupInviteJoin(user, rid, groupInviteId)
			if (ret == 1) then
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_INVITE_JOIN, sCmd)
			else --����ʧ��
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_INVITE_JOIN, sCmd)
				
				--֪ͨ��Ҳ������
				local sCmd = tostring(ret)
				hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
			end
		end
	end
end

































------------------------------------------------------------------------------------------------------------
--���ŵ�һ��ָ��
--��������Ӫ�б�
__Handler[hVar.GROUP_OPR_TYPE.C2L_NOVICECAMP_LIST] = function(udbid, rid, msgId, sCmd)
	--�����û�����
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print(udbid, user)
	--�����Ҵ���
	if user then
		--��ҳ�ʼ��
		user:InitChat()
		local sInitCmd = user:ChatBaseInfoToCmd()
		hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_INIT, sInitCmd)
		
		--���󷵻�
		local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
		local resCmd = NoviceCampMgr.GetNcList(tCmd)
		hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_LIST,resCmd)
	end
end

--�������������������б�
__Handler[hVar.GROUP_OPR_TYPE.C2L_NOVICECAMP_LIST_JOIN] = function(udbid, rid, msgId, sCmd)
	--�����û�����
	local user = hGlobal.uMgr:FindUserByDBID(udbid)
	--print(udbid, user)
	--�����Ҵ���
	if user then
		local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
		local resCmd = NoviceCampMgr.Data_GetNcList_Join(tCmd)
		hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_LIST_JOIN,resCmd)
	end
end

--��������Ӫ
__Handler[hVar.GROUP_OPR_TYPE.C2L_NOVICECAMP_CREATE] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.CreateNc(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_CREATE,resCmd)
end

--��ɢ����Ӫ
__Handler[hVar.GROUP_OPR_TYPE.C2L_NOVICECAMP_REMOVE] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.RemoveNc(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_REMOVE,resCmd)
end

--�鿴��Ա�б�
__Handler[hVar.GROUP_OPR_TYPE.C2L_MEMBER_LIST] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.GetMemberList(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_MEMBER_LIST,resCmd)
end

--Ӫ��ͨ����������
__Handler[hVar.GROUP_OPR_TYPE.C2L_POWER_JION_ACCEPT] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.PowerJionAccept(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_POWER_JION_ACCEPT,resCmd)
end

--Ӫ��������������
__Handler[hVar.GROUP_OPR_TYPE.C2L_POWER_JION_REJECT] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.PowerJionReject(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_POWER_JION_REJECT,resCmd)
end

--���������Ӫ
__Handler[hVar.GROUP_OPR_TYPE.C2L_POWER_JION_REQUEST] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.PowerJionRequest(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_POWER_JION_REQUEST,resCmd)
end

--����ȡ������
__Handler[hVar.GROUP_OPR_TYPE.C2L_POWER_JION_CANCEL] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.PowerJionCancel(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_POWER_JION_CANCEL,resCmd)
end

--��������Ӫ��Ϣ
__Handler[hVar.GROUP_OPR_TYPE.C2L_NOVICECAMP_UPDATE] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.UpdateNc(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_UPDATE,resCmd)
end

--����Ӫ����
__Handler[hVar.GROUP_OPR_TYPE.C2L_NOVICECAMP_RENAME] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.ReNameNc(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_NOVICECAMP_RENAME,resCmd)
end

--����
__Handler[hVar.GROUP_OPR_TYPE.C2L_POWER_FIRE] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.PowerFire(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_POWER_FIRE,resCmd)
end

--�᳤��������
__Handler[hVar.GROUP_OPR_TYPE.C2L_POWER_ASSISTANT_APPOINT] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.AssistantAppoint(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_POWER_ASSISTANT_APPOINT,resCmd)
end

--�᳤ȡ����������
__Handler[hVar.GROUP_OPR_TYPE.C2L_POWER_ASSISTANT_DISAPPOINT] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.AssistantAppointCancel(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_POWER_ASSISTANT_DISAPPOINT,resCmd)
end

--��������Ϣ
__Handler[hVar.GROUP_OPR_TYPE.C2L_CONFIG_PRIZE] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.PrizeInfo(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_CONFIG_PRIZE,resCmd)
end

--��������
__Handler[hVar.GROUP_OPR_TYPE.C2L_BUILDING_UPGRADE] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.BuildUpgrade(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_BUILDING_UPGRADE,resCmd)
end

--��ȡ��������
__Handler[hVar.GROUP_OPR_TYPE.C2L_BUILDING_PRIZE] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.BuildPrize(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_BUILDING_PRIZE,resCmd)
end

--�˳�
__Handler[hVar.GROUP_OPR_TYPE.C2L_POWER_QUIT] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.PowerQuit(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_POWER_QUIT,resCmd)
end

--ս��������
__Handler[hVar.GROUP_OPR_TYPE.C2L_CARD_UPGRADE] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local resCmd = NoviceCampMgr.CardUpgrade(tCmd)
	hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_CARD_UPGRADE,resCmd)
end

--�ͻ���������Ҿ���
__Handler[hVar.GROUP_OPR_TYPE.C2L_REQUIRE_GROUP_SEARCH] = function(udbid, rid, msgId, sCmd)
	local tCmd = NoviceCampMgr.Helper_Cmd2Table(sCmd)
	local cUDbid = tCmd.uid					--�˺�uid
	local cRid = tCmd.rid					--��ɫrid
	local searchName = tCmd.searchName			--����������
	
	--������Ϣ��Դ����Ч��
	if (cUDbid == udbid) and (cRid == rid) then
		--�����û�����
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--�����Ҵ���
		if user then
			--������Ҿ���
			local sCmd = NoviceCampMgr.Data_GetNcList_Join_Seach(tCmd)
			hApi.xlNet_Send(udbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_SEARCH_RET, sCmd)
		end
	end
end