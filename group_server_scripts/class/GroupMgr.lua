--���������
local GroupMgr = class("GroupMgr")
	
	--����ϵͳ�������������ʱ�̱�
	GroupMgr.SYSTEM_CHECK_CHAT_DRAGON_TIME =
	{
		{time = "23:59:40", },
	}
	
	--����ϵͳ��������������ʱ�̱�ÿ��һ��
	GroupMgr.SYSTEM_CHECK_RANK_TIME =
	{
		{time = "00:00:05", weekId = 1,},
	}
	
	--����ϵͳ���������������ߵ�����ʱ�̱�
	GroupMgr.SYSTEM_CHECK_TIME =
	{
		{time = "00:01:00", },
	}
	
	--����ϵͳ�������Զ����������ʱ�̱�
	GroupMgr.SYSTEM_CHECK_GROUP_AUTOFIRE_TIME =
	{
		{time = "00:02:00", },
	}
	
	--����ϵͳ�������ߵ�������ң�ϵͳ���š���ͨ���ţ�ʱ�̱�
	GroupMgr.SYSTEM_CHECK_GROUP_KICK_SYSTEM_PLAYER_TIME =
	{
		{time = "00:03:00", },
	}
	
	--����ϵͳ������ת�á����Ž�ɢʱ�̱�
	GroupMgr.SYSTEM_CHECK_GROUP_TRANSFER_TIME =
	{
		{time = "00:04:00", },
	}
	
	--����ϵͳ�����Ż�Ծ�ʱ�̱�
	GroupMgr.SYSTEM_CHECK_GROUP_ACTIVITY_TIME =
	{
		{time = "00:05:00", },
	}
	
	--���Ż�Ծ�id
	GroupMgr.ACTIVITY_ID = 10027
	
	--�������а�����
	GroupMgr.RANKBOARD_ID = 100
	GroupMgr.RANKBOARD_TYPE = 2
	
	--������������
	GroupMgr.RANKBOARD_PRIZE_TYPE = hVar.REWARD_LOG_TYPE.groupWeekDonateRank --20037: ���ű���������������
	GroupMgr.RANKBOARD_PRIZE_LIST =
	{
		{from = 1, to = 1, reward = {
				prize_admin = "1:75000:0:0;20:1500:0:0;10:12406:0:0;10:12406:0:0;10:12406:0:0;", --���Ż᳤�Ľ���
				prize_assistant = "1:50000:0:0;20:1000:0:0;10:12406:0:0;10:12406:0:0;", --��������Ľ���
				prize_member = "1:50000:0:0;20:1000:0:0;10:12406:0:0;10:12406:0:0;", --���ų�Ա�Ľ���
			},
		},
		{from = 2, to = 3, reward = {
				prize_admin = "1:60000:0:0;20:1200:0:0;", --���Ż᳤�Ľ���
				prize_assistant = "1:40000:0:0;20:800:0:0;", --��������Ľ���
				prize_member = "1:40000:0:0;20:800:0:0;", --���ų�Ա�Ľ���
			},
		},
		{from = 4, to = 10, reward = {
				prize_admin = "1:45000:0:0;20:900:0:0;", --���Ż᳤�Ľ���
				prize_assistant = "1:30000:0:0;20:600:0:0;", --��������Ľ���
				prize_member = "1:30000:0:0;20:600:0:0;", --���ų�Ա�Ľ���
			},
		},
		{from = 11, to = 20, reward = {
				prize_admin = "1:30000:0:0;20:600:0:0;", --���Ż᳤�Ľ���
				prize_assistant = "1:20000:0:0;20:400:0:0;", --��������Ľ���
				prize_member = "1:20000:0:0;20:400:0:0;", --���ų�Ա�Ľ���
			},
		},
		{from = 21, to = 50, reward = {
				prize_admin = "1:15000:0:0;20:300:0:0;", --���Ż᳤�Ľ���
				prize_assistant = "1:10000:0:0;20:200:0:0;", --��������Ľ���
				prize_member = "1:10000:0:0;20:200:0:0;", --���ų�Ա�Ľ���
			},
		},
		{from = 51, to = 100, reward = {
				prize_admin = "1:7500:0:0;20:150:0:0;", --���Ż᳤�Ľ���
				prize_assistant = "1:5000:0:0;20:100:0:0;", --��������Ľ���
				prize_member = "1:5000:0:0;20:100:0:0;", --���ų�Ա�Ľ���
			},
		},
	}
	
	--���Ÿ��˱��ܾ��׽���
	GroupMgr.RANKBOARD_PRIZE_TYPE_SINGLE = hVar.REWARD_LOG_TYPE.groupWeekDonateMax --20038: ���ű���������һ������
	GroupMgr.RANKBOARD_SHENGWANGWEEK_MIN_SINGLE = 500 --��Ҫ����С��������
	
	--���캯��
	function GroupMgr:ctor()
		self._groupList = -1 --�����
		self._groupUserList = -1 --������ұ�
		self._groupSystemList = -1 --ϵͳ�����
		
		--����
		self._statisticsTime = -1	--ͳ�Ƽ�ʱ
		self._statisticsTimestamp = -1	--�ϴ�ͳ��ʱ��
		
		return self
	end
	
	--��ʼ��
	function GroupMgr:Init()
		--��ʼ��
		self._groupList = {}
		self._groupUserList = {}
		self._groupSystemList = {} --ϵͳ�����
		
		--�����ݿ��ȡȫ��������Ϣ
		local sQueryM = string.format("SELECT `id`, `is_system` FROM `novicecamp_list` WHERE `dissolution` = %d", 0)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print("�����ݿ��ȡȫ��������Ϣ:", "errM=", errM, "tTemp=", #tTemp)
		if (errM == 0) then
			--�����ʼ��
			for n = #tTemp, 1, -1 do
				local id = tTemp[n][1] --����id
				local is_system = tTemp[n][2] --�Ƿ�Ϊϵͳ����
				--print(id)
				
				self._groupList[id] = {}
				
				--ϵͳ����
				if (is_system == 1) then
					self._groupSystemList[id] = 1
				else
					self._groupSystemList[id] = 0
				end
			end
		end
		
		--�����ݿ��ȡȫ�����������Ϣ
		local sQueryM = string.format("SELECT `uid`, `ncid`, `level` FROM `novicecamp_member` WHERE `level` >  %d", 0)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print("�����ݿ��ȡȫ�����������Ϣ:", "errM=", errM, "tTemp=", #tTemp)
		if (errM == 0) then
			--�����ʼ��
			for n = #tTemp, 1, -1 do
				local uid = tTemp[n][1] --���uid
				local ncid = tTemp[n][2] --����id
				local level = tTemp[n][3] --Ȩ��
				--print(uid, ncid, level)
				
				if self._groupList[ncid] then
					self._groupList[ncid][uid] = level
					self._groupUserList[uid] = ncid
				end
			end
		end
		
		--����
		self._statisticsTime = hApi.GetClock()	--ͳ�Ƽ�ʱ
		self._statisticsTimestamp = os.time()	--�ϴ�ͳ��ʱ��
		
		return self
	end
	
	--release
	function GroupMgr:Release()
		self._groupList = -1 --�����
		self._groupUserList = -1 --������ұ�
		self._groupSystemList = -1 --ϵͳ�����
		
		--����
		self._statisticsTime = -1	--ͳ�Ƽ�ʱ
		self._statisticsTimestamp = -1	--�ϴ�ͳ��ʱ��
		
		return self
	end
	
	--��ȡȫ�������б�
	function GroupMgr:GetGroupList()
		return self._groupList
	end
	
	--[[
	--��ȡȫ����������б�
	function GroupMgr:GetGroupUserList()
		return self._groupUserList
	end
	]]
	
	--��ȡ������ڵĹ���id
	function GroupMgr:GetUserGroupID(uid)
		local groupId = 0
		
		if self._groupUserList[uid] then
			groupId = self._groupUserList[uid]
		end
		
		return groupId
	end
	
	--��ȡ������ڵĹ���ȼ�
	function GroupMgr:GetUserGroupLevel(uid)
		local groupLevel = 0
		
		if self._groupUserList[uid] then
			local groupId = self._groupUserList[uid]
			if (groupId > 0) then
				groupLevel = self._groupList[groupId][uid]
			end
		end
		
		return groupLevel
	end
	
	--���ָ�����������б�
	function GroupMgr:GetGroupAllUser(groupId)
		if self._groupList[groupId] then
			return self._groupList[groupId]
		end
	end
	
	--��������
	function GroupMgr:_CreateGroup(groupId, is_system)
		if (self._groupList[groupId] == nil) then
			self._groupList[groupId] = {}
			
			--ϵͳ����
			if (is_system == 1) then
				self._groupSystemList[groupId] = 1
			else
				self._groupSystemList[groupId] = 0
			end
		end
	end
	
	--��ɢ����
	function GroupMgr:_RemoveGroup(groupId)
		if self._groupList[groupId] then
			--������������Ϣ
			for uid, level in pairs(self._groupList[groupId]) do
				self._groupUserList[uid] = nil
			end
			
			self._groupList[groupId] = nil
			self._groupSystemList[groupId] = nil
		end
	end
	
	--���������Ա
	function GroupMgr:_AddGroupUser(groupId, uid, level)
		if self._groupList[groupId] then
			self._groupList[groupId][uid] = level
			self._groupUserList[uid] = groupId
		end
	end
	
	--�ߵ������Ա
	function GroupMgr:RemoveGroupUser(groupId, uid)
		if self._groupList[groupId] then
			self._groupList[groupId][uid] = nil
			self._groupUserList[uid] = nil
		end
	end
	
	--���¹����Ա
	function GroupMgr:UpdateGroupUser(groupId, uid, level)
		if self._groupList[groupId] then
			self._groupList[groupId][uid] = level
			self._groupUserList[uid] = groupId
		end
	end
	
	--���͹�����Ϣ
	function GroupMgr:SendGroupMessage(groupId, masterUId)
	end
	
	--��������
	function GroupMgr:_GetUserName(uid)
		local name = ""
		local sQueryM = string.format("SELECT `customS1` FROM `t_user` WHERE `uid` = %d", uid)
		local errM, customS1 = xlDb_Query(sQueryM)
		if (errM == 0) then
			name = customS1
		end
		
		return name
	end
	
	--���������������ŵ�ʱ��
	function GroupMgr:_SetUserEnterGroupTime(iNcId, uid)
		local sSql = string.format("UPDATE `t_chat_user` SET `last_group_enter_time` = NOW() WHERE `uid` = %d", uid)
		xlDb_Execute(sSql)
	end
	
	--����������뿪���ŵ�ʱ��
	function GroupMgr:_SetUserLeaveGroupTime(iNcId, uid)
		--�����ϵͳ���ţ��뿪���Ų��޸�ʱ��
		local is_system = self._groupSystemList[iNcId]
		if (is_system == 1) then --ϵͳ����
			--
		else
			local sSql = string.format("UPDATE `t_chat_user` SET `last_group_leave_time` = NOW() WHERE `uid` = %d", uid)
			xlDb_Execute(sSql)
		end
	end
	
	--������������ʱ��
	function GroupMgr:_SetAssistantTime(iNcId)
		local sSql = string.format("UPDATE `novicecamp_list` SET `last_assistant_time` = NOW() WHERE `id` = %d", iNcId)
		xlDb_Execute(sSql)
	end
	
	--���ȡ������������ʱ��
	function GroupMgr:_SetAssistantCancelTime(iNcId)
		local sSql = string.format("UPDATE `novicecamp_list` SET `last_cancel_assistant_time` = NOW() WHERE `id` = %d", iNcId)
		xlDb_Execute(sSql)
	end
	
	--����������ղ������˵Ĵ���
	function GroupMgr:AddAssistantOpNum(iNcId, uid)
		local opNum = 0
		
		local sQueryCU = string.format("SELECT `last_op_num`, `last_op_time` FROM `novicecamp_member` WHERE `uid` = %d and `ncid` = %d", uid, iNcId)
		local errCU, last_op_num, last_op_time = xlDb_Query(sQueryCU)
		if (errCU == 0) then --��ѯ�ɹ�
			opNum = last_op_num
			
			--ת��Ϊ�������ϴβ���ʱ���0�����ʱ���
			local nTimestamp = hApi.GetNewDate(last_op_time)
			local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --ת�ַ���(������)
			local strNewdate = strDatestampYMD .. " 00:00:00"
			local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1) -- +1��
			--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
			
			--print("strNewdate=", strNewdate)
			--print("nTimestampTodayZero=", nTimestampTodayZero)
			--print("nTimestampTomorrowZero=", nTimestampTomorrowZero)
			
			--����ʱ���
			local nTimestampNow = os.time()
			--print("nTimestampNow=", nTimestampNow)
			
			--���˵ڶ���
			--if (nTimestampNow >= nTimestampTodayZero) and (nTimestampNow < nTimestampTomorrowZero) then
			if (nTimestampNow >= nTimestampTodayZero) then
				--print("���˵ڶ���")
				opNum = 0
			end
		end
		
		local newOpNum = opNum + 1
		
		local sSql = string.format("UPDATE `novicecamp_member` SET `last_op_num` = %d, `last_op_time` = NOW() WHERE `uid` = %d and `ncid` = %d", newOpNum, uid, iNcId)
		xlDb_Execute(sSql)
	end
	
	--����������ղ������˵Ĵ���
	function GroupMgr:AddAssistantKickNum(iNcId, uid)
		local kickNum = 0
		
		local sQueryCU = string.format("SELECT `last_kick_num`, `last_kick_time` FROM `novicecamp_member` WHERE `uid` = %d and `ncid` = %d", uid, iNcId)
		local errCU, last_kick_num, last_kick_time = xlDb_Query(sQueryCU)
		if (errCU == 0) then --��ѯ�ɹ�
			kickNum = last_kick_num
			
			--ת��Ϊ�������ϴβ���ʱ���0�����ʱ���
			local nTimestamp = hApi.GetNewDate(last_kick_time)
			local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --ת�ַ���(������)
			local strNewdate = strDatestampYMD .. " 00:00:00"
			local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1) -- +1��
			--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
			
			--print("strNewdate=", strNewdate)
			--print("nTimestampTodayZero=", nTimestampTodayZero)
			--print("nTimestampTomorrowZero=", nTimestampTomorrowZero)
			
			--����ʱ���
			local nTimestampNow = os.time()
			--print("nTimestampNow=", nTimestampNow)
			
			--���˵ڶ���
			--if (nTimestampNow >= nTimestampTodayZero) and (nTimestampNow < nTimestampTomorrowZero) then
			if (nTimestampNow >= nTimestampTodayZero) then
				--print("���˵ڶ���")
				kickNum = 0
			end
		end
		
		local newKickNum = kickNum + 1
		
		local sSql = string.format("UPDATE `novicecamp_member` SET `last_kick_num` = %d, `last_kick_time` = NOW() WHERE `uid` = %d and `ncid` = %d", newKickNum, uid, iNcId)
		xlDb_Execute(sSql)
	end
	
	--��ȡ��Ҽ�����ŵ�ʱ�䣨��λ: �룩
	function GroupMgr:GetUserEnterTime(iNcId, uid)
		local enterLastTime = 0
		
		local sQueryCU = string.format("SELECT `last_group_enter_time` FROM `t_chat_user` WHERE `uid` = %d", uid)
		local errCU, last_group_enter_time = xlDb_Query(sQueryCU)
		if (errCU == 0) then --��ѯ�ɹ�
			local entertime = hApi.GetNewDate(last_group_enter_time)
			local currenttimestamp = os.time()
			enterLastTime = currenttimestamp - entertime
		end
		
		return enterLastTime
	end
	
	--��ȡ����뿪���ŵ�ʱ�䣨��λ: �룩
	function GroupMgr:GetUserLeaveTime(iNcId, uid)
		local leaveLastTime = 0
		
		local sQueryCU = string.format("SELECT `last_group_leave_time` FROM `t_chat_user` WHERE `uid` = %d", uid)
		--print(sQueryCU)
		local errCU, last_group_leave_time = xlDb_Query(sQueryCU)
		if (errCU == 0) then --��ѯ�ɹ�
			local leavetime = hApi.GetNewDate(last_group_leave_time)
			local currenttimestamp = os.time()
			leaveLastTime = currenttimestamp - leavetime
		end
		
		return leaveLastTime
	end
	
	--��þ�����������ȡ����ʱ�䣨��λ: �룩
	function GroupMgr:GetAssistantCancelTime(iNcId)
		local assistantLastTime = 0
		
		local sQueryCU = string.format("SELECT `last_cancel_assistant_time` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", iNcId)
		local errCU, last_cancel_assistant_time = xlDb_Query(sQueryCU)
		if (errCU == 0) then --��ѯ�ɹ�
			local assisttime = hApi.GetNewDate(last_cancel_assistant_time)
			local currenttimestamp = os.time()
			assistantLastTime = currenttimestamp - assisttime
		end
		
		return assistantLastTime
	end
	
	--��ȡ������ղ������˵Ĵ���
	function GroupMgr:GetAssistantOpNum(iNcId, uid)
		local opNum = 0
		
		local sQueryCU = string.format("SELECT `last_op_num`, `last_op_time` FROM `novicecamp_member` WHERE `uid` = %d and `ncid` = %d", uid, iNcId)
		local errCU, last_op_num, last_op_time = xlDb_Query(sQueryCU)
		if (errCU == 0) then --��ѯ�ɹ�
			opNum = last_op_num
			
			--ת��Ϊ�������ϴβ���ʱ���0�����ʱ���
			local nTimestamp = hApi.GetNewDate(last_op_time)
			local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --ת�ַ���(������)
			local strNewdate = strDatestampYMD .. " 00:00:00"
			local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1) -- +1��
			--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
			
			--print("strNewdate=", strNewdate)
			--print("nTimestampTodayZero=", nTimestampTodayZero)
			--print("nTimestampTomorrowZero=", nTimestampTomorrowZero)
			
			--����ʱ���
			local nTimestampNow = os.time()
			--print("nTimestampNow=", nTimestampNow)
			
			--���˵ڶ���
			--if (nTimestampNow >= nTimestampTodayZero) and (nTimestampNow < nTimestampTomorrowZero) then
			if (nTimestampNow >= nTimestampTodayZero) then
				opNum = 0
			end
		end
		
		return opNum
	end
	
	--��ȡ������ղ������˵Ĵ���
	function GroupMgr:GetAssistantKickNum(iNcId, uid)
		local kickNum = 0
		
		local sQueryCU = string.format("SELECT `last_kick_num`, `last_kick_time` FROM `novicecamp_member` WHERE `uid` = %d and `ncid` = %d", uid, iNcId)
		local errCU, last_kick_num, last_kick_time = xlDb_Query(sQueryCU)
		if (errCU == 0) then --��ѯ�ɹ�
			kickNum = last_kick_num
			
			--ת��Ϊ�������ϴβ���ʱ���0�����ʱ���
			local nTimestamp = hApi.GetNewDate(last_kick_time)
			local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --ת�ַ���(������)
			local strNewdate = strDatestampYMD .. " 00:00:00"
			local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1) -- +1��
			--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
			
			--print("strNewdate=", strNewdate)
			--print("nTimestampTodayZero=", nTimestampTodayZero)
			--print("nTimestampTomorrowZero=", nTimestampTomorrowZero)
			
			--����ʱ���
			local nTimestampNow = os.time()
			--print("nTimestampNow=", nTimestampNow)
			
			--���˵ڶ���
			--if (nTimestampNow >= nTimestampTodayZero) and (nTimestampNow < nTimestampTomorrowZero) then
			if (nTimestampNow >= nTimestampTodayZero) then
				kickNum = 0
			end
		end
		
		return kickNum
	end
	
	--�¼�: ��������
	function GroupMgr:OnCreateGroup(groupId, masterUId, level)
		--��ӹ���ͳ�Ա��Ϣ
		self:_CreateGroup(groupId)
		self:_AddGroupUser(groupId, masterUId, level)
		
		--���������������ŵ�ʱ��
		self:_SetUserEnterGroupTime(groupId, masterUId)
		
		--���;�����Ϣ
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --����ϵͳ��ʾ��Ϣ
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
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_CREATE"], self:_GetUserName(masterUId))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--����������Ϣ
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE --��ʾ��ϵͳ��Ϣ
		local content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_CREATE_WORLD"], self:_GetUserName(masterUId), groupName)
		local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
		hGlobal.chatMgr:SendSystemMessage(sysMsgtype, content, strDate)
	end
	
	--�¼�: ��ɢ����
	function GroupMgr:OnRemoveGroup(groupId, masterUId)
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		--���ԭ����ȫ����Ա���뿪ʱ��
		for uid, level in pairs(self._groupList[groupId]) do
			--����������뿪���ŵ�ʱ��
			self:_SetUserLeaveGroupTime(groupId, uid)
			
			--�����ʼ�֪ͨ
			if (masterUId ~= uid) then --�᳤���������Ľ�ɢ���ᣬ���᳤��֪ͨ������
				local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_DISOLUTE"], groupName)
				NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
			end
		end
		
		--�Ƴ�����ͳ�Ա��Ϣ
		self:_RemoveGroup(groupId)
		
		--���;�����Ϣ
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_WARNING --����ϵͳ������Ϣ
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
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_REMOVE"], self:_GetUserName(masterUId))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--����������Ϣ
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_WARNING --������ϵͳ��Ϣ
		local content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_REMOVE_WORLD"], groupName, self:_GetUserName(masterUId))
		local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
		hGlobal.chatMgr:SendSystemMessage(sysMsgtype, content, strDate)
	end
	
	--�¼�: ��ɢ���ᣨ����Ա��
	function GroupMgr:OnRemoveGroup_Admin(groupId, masterUId)
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		--���ԭ����ȫ����Ա���뿪ʱ��
		for uid, level in pairs(self._groupList[groupId]) do
			--����������뿪���ŵ�ʱ��
			self:_SetUserLeaveGroupTime(groupId, uid)
			
			--�����ʼ�֪ͨ��ֻʣ�᳤1�ˣ�
			local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_DISOLUTE_OFFLINE"], groupName)
			NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
		end
		
		--�Ƴ�����ͳ�Ա��Ϣ
		self:_RemoveGroup(groupId)
		
		--���;�����Ϣ
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_WARNING --����ϵͳ������Ϣ
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
		tMsg.content = hVar.tab_string["__TEXT_CHAT_GROUP_REMOVE_ADMIN"]
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--����������Ϣ
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_WARNING --������ϵͳ��Ϣ
		local content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_REMOVE_ADMIN_WORLD"], groupName, self:_GetUserName(masterUId))
		local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
		hGlobal.chatMgr:SendSystemMessage(sysMsgtype, content, strDate)
	end
	
	--�¼�: ��ӹ����Ա
	function GroupMgr:OnAddGroupMember(groupId, masterUId, uid, level, iLevelOp)
		--��ӹ���ͳ�Ա��Ϣ
		self:_AddGroupUser(groupId, uid, level)
		
		--���������������ŵ�ʱ��
		self:_SetUserEnterGroupTime(groupId, uid)
		
		--���;�����Ϣ
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --����ϵͳ��ʾ��Ϣ
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
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ADD_MEMBER"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--�����ʼ�֪ͨ
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		local strAythen = ""
		if(iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --�᳤
			strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_ADMIN"]
		elseif(iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) then --����
			strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_ASSIST"]
		elseif(iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --����ϵͳ��
			strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_ASSIST"]
		else --��Ա
			--
		end
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_APPLY_ACCEPT"], groupName, strAythen)
		local is_system = self._groupSystemList[groupId]
		if (is_system == 1) then --ϵͳ����
			sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_APPLY_ACCEPT_SYSTEM"], groupName)
		end
		NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
	end
	
	--�¼�: ͨ���������뺯���˹����Ա
	function GroupMgr:OnAddGroupInviteMember(groupId, masterUId, uid, level)
		--��ӹ���ͳ�Ա��Ϣ
		self:_AddGroupUser(groupId, uid, level)
		
		--���������������ŵ�ʱ��
		self:_SetUserEnterGroupTime(groupId, uid)
		
		--���;�����Ϣ
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --����ϵͳ��ʾ��Ϣ
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
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_INBITE_ADD_MEMBER"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--�����ʼ�֪ͨ
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_APPLY_INVITE_ACCEPT"], groupName)
		NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
	end
	
	--�¼�: �ߵ������Ա
	function GroupMgr:OnRemoveGroupMember(groupId, masterUId, uid, iLevelOp)
		--�Ƴ�����ͳ�Ա��Ϣ
		self:RemoveGroupUser(groupId, uid)
		
		--����������뿪���ŵ�ʱ��
		self:_SetUserLeaveGroupTime(groupId, uid)
		
		--print("OnRemoveGroupMember", groupId, masterUId, uid)
		--���;�����Ϣ
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_WARNING --����ϵͳ������Ϣ
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
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_REMOVE_MEMBER_ADMIN"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		
		--���������ʾ
		if (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --����
			tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_REMOVE_MEMBER_ASSIST"], self:_GetUserName(uid))
		end
		
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--�����ʼ�֪ͨ
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		local strAythen = ""
		if(iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --�᳤
			strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_ADMIN"]
		elseif(iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) then --����
			strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_ASSIST"]
		elseif(iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --����ϵͳ��
			strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_ASSIST"]
		else --��Ա
			--
		end
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_KICK"], strAythen, groupName)
		NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
	end
	
	--�¼�: ��Ա�˳�����
	function GroupMgr:OnLeaveGroupMember(groupId, uid)
		--�Ƴ�����ͳ�Ա��Ϣ
		self:RemoveGroupUser(groupId, uid)
		
		--����������뿪���ŵ�ʱ��
		self:_SetUserLeaveGroupTime(groupId, uid)
		
		--���;�����Ϣ
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_WARNING --����ϵͳ������Ϣ
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
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_LEAVE_MEMBER"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
	end
	
	--�¼�: �߳�����δ��¼�Ĺ����Ա��������Ա�ɲ�����
	function GroupMgr:OnKickOfflineGroupMember(groupId, adminUid, uid)
		--�Ƴ�����ͳ�Ա��Ϣ
		self:RemoveGroupUser(groupId, uid)
		
		--����������뿪���ŵ�ʱ��
		self:_SetUserLeaveGroupTime(groupId, uid)
		
		--print("OnKickOfflineGroupMember", groupId, masterUId, uid)
		--���;�����Ϣ
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_WARNING --����ϵͳ������Ϣ
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
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_REMOVE_MEMBER_OFFLINE"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--�����ʼ�֪ͨ
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_KICK_OFFLINE"], groupName)
		NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
	end
	
	--�¼�: �������Ϊ�᳤��������Ա�ɲ�����
	function GroupMgr:OnAssetAdminGroupMember(groupId, adminUid, assistUid)
		--���³�Ա��Ϣ
		self:UpdateGroupUser(groupId, adminUid, hVar.GROUP_MEMBER_AUTORITY.NORMAL)
		
		--���³�Ա��Ϣ
		self:UpdateGroupUser(groupId, assistUid, hVar.GROUP_MEMBER_AUTORITY.ADMIN)
		
		--print("OnAssetAdminGroupMember", groupId, masterUId, uid)
		--���;�����Ϣ
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --����ϵͳ��ʾ��Ϣ
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
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ASSET_ADMIN"], self:_GetUserName(assistUid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--����������Ϣ
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE --��ʾ��ϵͳ��Ϣ
		local content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ASSET_ADMIN_WORLD"], self:_GetUserName(assistUid), groupName)
		local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
		hGlobal.chatMgr:SendSystemMessage(sysMsgtype, content, strDate)
		
		--�����ʼ�֪ͨ
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_ASSISTANT_TRANSFER_SYSTEM"], groupName)
		NoviceCampMgr.private.Data_InsertMyNcPrize(assistUid, 20033, sKey, groupId)
	end
	
	--�¼�: ���Ż᳤ת�ø�����
	function GroupMgr:OnTranfserGroupMember(groupId, adminUid, assistUid)
		--���³�Ա��Ϣ
		self:UpdateGroupUser(groupId, adminUid, hVar.GROUP_MEMBER_AUTORITY.NORMAL)
		
		--���³�Ա��Ϣ
		self:UpdateGroupUser(groupId, assistUid, hVar.GROUP_MEMBER_AUTORITY.ADMIN)
		
		--print("OnTranfserGroupMember", groupId, masterUId, uid)
		--���;�����Ϣ
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --����ϵͳ��ʾ��Ϣ
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
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_TRANSFER"], self:_GetUserName(assistUid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--����������Ϣ
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE --��ʾ��ϵͳ��Ϣ
		local content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_TRANSFER_WORLD"], groupName, self:_GetUserName(assistUid))
		local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
		hGlobal.chatMgr:SendSystemMessage(sysMsgtype, content, strDate)
		
		--�����ʼ�֪ͨ
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_ASSISTANT_TRANSFER"], groupName)
		NoviceCampMgr.private.Data_InsertMyNcPrize(assistUid, 20033, sKey, groupId)
	end
	
	--�¼�: �᳤��������
	function GroupMgr:OnAssistantGroupMember(groupId, masterUId, uid, iLevel)
		--print("OnAssistantGroupMember", groupId, masterUId, uid)
		--���³�Ա��Ϣ
		self:UpdateGroupUser(groupId, uid, iLevel)
		
		--��Ǿ������������ʱ��
		self:_SetAssistantTime(groupId)
		
		--���;�����Ϣ
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --����ϵͳ��ʾ��Ϣ
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
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ASSISTANT_MEMBER"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--�����ʼ�֪ͨ
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_ASSISTANT"], groupName)
		NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
	end
	
	--�¼�: ϵͳ��������ϵͳ��
	function GroupMgr:OnSystemAssistantGroupMember(groupId, masterUId, uid, iLevel)
		--print("OnSystemAssistantGroupMember", groupId, masterUId, uid)
		--���³�Ա��Ϣ
		self:UpdateGroupUser(groupId, uid, iLevel)
		
		--��Ǿ�����������ϵͳ����ʱ��
		self:_SetAssistantTime(groupId)
		
		--���;�����Ϣ
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --����ϵͳ��ʾ��Ϣ
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
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ASSISTANT_SYSTEN_MEMBER"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--[[
		--����������Ϣ
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE --��ʾ��ϵͳ��Ϣ
		local content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ASSISTANT_SYSTEN_MEMBER_WORLD"], self:_GetUserName(uid), groupName)
		local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
		hGlobal.chatMgr:SendSystemMessage(sysMsgtype, content, strDate)
		]]
		
		--�����ʼ�֪ͨ
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_ASSISTANT_SYSTEM"], groupName)
		NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
	end
	
	--�¼�: �᳤ȡ����������
	function GroupMgr:OnAssistantCancelGroupMember(groupId, masterUId, uid, iLevel)
		--print("OnAssistantGroupMember", groupId, masterUId, uid)
		
		--���³�Ա��Ϣ
		self:UpdateGroupUser(groupId, uid, iLevel)
		
		--���ȡ���������������ʱ��
		self:_SetAssistantCancelTime(groupId)
		
		--���;�����Ϣ
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_WARNING --����ϵͳ������Ϣ
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
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ASSISTANT_CANCEL_MEMBER"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--�����ʼ�֪ͨ
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_ASSISTANT_CANCEL"], groupName)
		NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
	end
	
	--�¼�: �˳�����ȡ����������
	function GroupMgr:OnAssistantLeaveGroupMember(groupId, uid, iLevel)
		--print("OnAssistantLeaveGroupMember", groupId, uid)
		
		--���³�Ա��Ϣ
		self:UpdateGroupUser(groupId, uid, iLevel)
		
		--���ȡ���������������ʱ��
		self:_SetAssistantCancelTime(groupId)
		
		--���;�����Ϣ
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_WARNING --����ϵͳ������Ϣ
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
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ASSISTANT_LEAVE_MEMBER"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
	end
	
	--�¼�: ϵͳȡ����������
	function GroupMgr:OnAssistantSystenCancelGroupMember(groupId, masterUId, uid, iLevel)
		--print("OnAssistantGroupMember", groupId, masterUId, uid)
		
		--���³�Ա��Ϣ
		self:UpdateGroupUser(groupId, uid, iLevel)
		
		--���ȡ��������������ϵͳ����ʱ��
		self:_SetAssistantCancelTime(groupId)
		
		--���;�����Ϣ
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_WARNING --����ϵͳ������Ϣ
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
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ASSISTANT_SYSTEM_CANCEL_MEMBER"], self:_GetUserName(uid))
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--[[
		--����������Ϣ
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_WARNING --������ϵͳ��Ϣ
		local content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ASSISTANT_SYSTEN_CANCEL_MEMBER_WORLD"], self:_GetUserName(uid), groupName)
		local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
		hGlobal.chatMgr:SendSystemMessage(sysMsgtype, content, strDate)
		]]
		
		--�����ʼ�֪ͨ
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		local sKey = string.format(hVar.tab_string["__TEXT_GROUP__MAIL_ASSISTANT_SYSTEM_CANCEL"], groupName)
		NoviceCampMgr.private.Data_InsertMyNcPrize(uid, 20033, sKey, groupId)
	end
	
	--�¼�: �޸Ĺ�����
	function GroupMgr:OnModifyGroupName(groupId, masterUId, newName)
		--���;�����Ϣ
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --����ϵͳ��ʾ��Ϣ
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
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_MODIFY_NAME"], newName)
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
	end
	
	--�¼�: �޸Ĺ�����
	function GroupMgr:OnModifyGroupIntroduce(groupId, masterUId, userAuthen, newIntroduce)
		--print("OnModifyGroupIntroduce",groupId, masterUId, newIntroduce)
		--���;�����Ϣ
		local strText = ""
		if (userAuthen == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --�᳤
			strText = hVar.tab_string["__TEXT_CHAT_GROUP_MODIFY_INTRODUCE_ADMIN"]
		elseif (userAuthen == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (userAuthen == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --����
			strText = hVar.tab_string["__TEXT_CHAT_GROUP_MODIFY_INTRODUCE_ASSIST"]
		end
		
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --����ϵͳ��ʾ��Ϣ
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
		tMsg.content = strText
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
	end
	
	--�¼�: ���Ὠ������
	function GroupMgr:OnGroupBuildingLevelUp(groupId, buildId, newLevel)
		--���;�����Ϣ
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --����ϵͳ��ʾ��Ϣ
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
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_BUILDING_LEVELUP"], hVar.tab_stringU[buildId] or hVar.tab_stringU[0], newLevel)
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
	end
	
	--�¼�: �᳤���򸱱�����
	function GroupMgr:OnGroupBuyBattleCount(groupId, masterUId, userAuthen, count)
		--���;�����Ϣ
		local strText = ""
		if (userAuthen == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --�᳤
			strText = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_BUY_BATTLE_COUNT_ADMIN"], count)
		elseif (userAuthen == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (userAuthen == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --����
			strText = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_BUY_BATTLE_COUNT_ASSIST"], count)
		end
		
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_TODAY --����ϵͳ������Ϣ
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
		tMsg.content = strText
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
		
		--geyachao: ���ٷ�������Ϣ��
		--[[
		--����������Ϣ
		local groupName = ""
		local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
		local errM, strName = xlDb_Query(sQueryM)
		if (errM == 0) then
			groupName = strName
		end
		
		local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE --��ʾ��ϵͳ��Ϣ
		local content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_BUY_BATTLE_COUNT_WORLD"], groupName)
		local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
		hGlobal.chatMgr:SendSystemMessage(sysMsgtype, content, strDate)
		]]
	end
	
	--�¼������ž���ÿ����������
	function GroupMgr:OnGroupWeekDonateSend(groupId, groupName, shengwangWeekSum, rank)
		--���;�����Ϣ
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --����ϵͳ��ʾ��Ϣ
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
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_SHENGWANG_WEEK_DONATE"], shengwangWeekSum, rank)
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
	end
	
	--�¼������ž��Ÿ��˱����������������
	function GroupMgr:OnGroupWeekDonateSumSingle(groupId, uid, maxShengwangWeek)
		--���;�����Ϣ
		local tMsg = {}
		tMsg.chatType = hVar.CHAT_TYPE.GROUP
		tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --����ϵͳ��ʾ��Ϣ
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
		tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_SHENGWANGWEEK_DOTAME_MAX"], self:_GetUserName(uid), maxShengwangWeek)
		tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
		tMsg.touid = groupId
		tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
		tMsg.resultParam = 0
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
	end
	
	--�¼�: ���ŷ����
	function GroupMgr:OnGroupSendRedPacket(groupId, uid, tMsg)
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
	end
	
	--�¼�: �����պ��
	function GroupMgr:OnGroupReceiveRedPacket(groupId, uid, tMsg)
		--���;�����Ϣ
		hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
	end
	
	--�������(10��)
	function GroupMgr:Update()
		local self = hGlobal.groupMgr --self
		
		--�����Ϣ
		local timeNow = hApi.GetClock()
		if (self._statisticsTime > -1) and (timeNow - self._statisticsTime > 10000) then --10��
			local lasttimestamp = self._statisticsTimestamp
			local currenttimestamp = os.time()
			
			self._statisticsTime = timeNow
			self._statisticsTimestamp = currenttimestamp
			
			--����Ƿ��Զ����������Զ��ߵ�����
			local sDate = os.date("%Y-%m-%d", currenttimestamp)
			for i = 1, #GroupMgr.SYSTEM_CHECK_TIME, 1 do
				local sRefreshTime = GroupMgr.SYSTEM_CHECK_TIME[i].time
				local refresh_time = sDate .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					
					print("����Ƿ��Զ�����Э������: " .. sDate)
					hGlobal.fileWriter:Write("����Ƿ��Զ�����Э������: " .. sDate)
					
					--����Ƿ��Զ���������
					for groupId, tv in pairs(self._groupList) do
						--����ϵͳ����
						local is_system = self._groupSystemList[groupId]
						if (is_system ~= 1) then
							local adminUID = 0 --�᳤uid
							local assistantUID = 0 --����uid
							
							for uid, level in pairs(tv) do
								if(level == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --�᳤
									adminUID = uid
								elseif(level == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) then --����
									assistantUID = uid
								elseif(level == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --����ϵͳ��
									assistantUID = uid
								end
							end
							
							--��������������Ҫ���
							--print("groupId=" .. groupId, "adminUID=" .. adminUID, "assistantUID=" .. assistantUID)
							if (assistantUID == 0) then
								--print("    ����������")
								--�᳤�����߲���Ҫ���
								local userAdmin = hGlobal.uMgr:FindChatUserByDBID(adminUID)
								if (not userAdmin) then
									--��ѯ�᳤�ϴε�¼ʱ��
									--local strLastLoginTime = ""
									local sQueryM = string.format("SELECT `last_login_time` FROM `t_user` WHERE `uid` = %d", adminUID)
									local errM, strLastLoginTime = xlDb_Query(sQueryM)
									--print("��ѯ�᳤�ϴε�¼ʱ��:", "errM=", errM, "strLastLoginTime=", strLastLoginTime)
									if (errM == 0) then
										local lastlogintime = hApi.GetNewDate(strLastLoginTime)
										--local currenttimestamp = os.time()
										local loginLastTime = currenttimestamp - lastlogintime
										if (loginLastTime > 604800) then --�᳤7��δ��¼
											--print("    �᳤7��δ��¼")
											--��ѯ�˾��Ŵ�����ʱ��
											local sQueryM = string.format("SELECT `time_create`, `buildinfo` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
											local errM, strLastCreateTime, buildinfo = xlDb_Query(sQueryM)
											if (errM == 0) then
												local lastcreatetime = hApi.GetNewDate(strLastCreateTime)
												--local currenttimestamp = os.time()
												local createLastTime = currenttimestamp - lastcreatetime
												if (createLastTime > 2592000) then --�������Ŵﵽ30��
													--print("    �������Ŵ���30��")
													local townId = 80068 --����id
													local townLv = 0 --���ǵȼ�
													local tmp = "local strCfg = ".. tostring(buildinfo) .. " return strCfg"
													local tBuildInfo = assert(loadstring(tmp))()
													if (type(tBuildInfo) == "table") then
														local buildlist = tBuildInfo.buildlist
														if buildlist then
															for i = 1, #buildlist, 1 do
																if (buildlist[i].id == townId) then --�ҵ���
																	townLv = buildlist[i].lv
																	break
																end
															end
														end
													end
													if (townLv >= 3) then --���Ǵﵽ3��
														--print("    ���Ǵﵽ3��")
														
														--ͳ��ÿ����Ա�Ĺ���ֵ
														local tDonation = {}
														for uid, level in pairs(tv) do
															if(level == hVar.GROUP_MEMBER_AUTORITY.NORMAL) then --��ͨ��Ա
																--��ʼ��
																local donationSum = 0
																
																local sQueryM = string.format("SELECT `mat_iron_donate_sum`, `mat_wood_donate_sum`, `mat_food_donate_sum` FROM `novicecamp_member` WHERE `ncid`= %d AND `level` = %d AND `uid` = %d", groupId, level, uid)
																--print(sQueryM)
																local errM, mat_iron_donate_sum, mat_wood_donate_sum, mat_food_donate_sum = xlDb_Query(sQueryM)
																--print(errM)
																if (errM == 0) then
																	donationSum = mat_iron_donate_sum * 2 + mat_wood_donate_sum + mat_food_donate_sum
																end
																
																--print("        ��ҹ��� [" .. uid .. "]=" .. donationSum)
																
																--����ֵ�ﵽ3000
																if (donationSum >= 3000) then
																	tDonation[uid] = donationSum
																end
															end
														end
														
														--�ҳ���7�չ���ֵ��ߵ����
														local nDonationSevenDayValue = 0
														local nDonationSevenDayUID = 0
														for uid, donationSum in pairs(tDonation) do
															local donationSumSevenDay = 0
															
															--ת��Ϊ�������ϴβ���ʱ���0�����ʱ���
															local strDatestampYMD = hApi.Timestamp2Date(currenttimestamp) --ת�ַ���(������)
															local strNewdate = strDatestampYMD .. " 00:00:00"
															local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", -7) -- -7��
															local strTimestampTodayZero = os.date("%Y-%m-%d %H:%M:%S", nTimestampTodayZero)
															--print(strTimestampTodayZero)
															local sQueryM = string.format("SELECT `mat_iron_donate`, `mat_wood_donate`, `mat_food_donate` FROM `novicecamp_member_donate_log` WHERE `ncid`= %d AND `uid` = %d and `time` >= '%s'", groupId, uid, strTimestampTodayZero)
															local errM, tTemp = xlDb_QueryEx(sQueryM)
															--print("�����ݿ��ȡ�����б�:", "errM=", errM, "tTemp=", #tTemp)
															if (errM == 0) then
																for n = 1, #tTemp, 1 do
																	local mat_iron_donate = tTemp[n][1] --��
																	local mat_wood_donate = tTemp[n][2] --ľ��
																	local mat_food_donate = tTemp[n][3] --��ʳ
																	--print(id)
																	
																	local donation = mat_iron_donate * 2 + mat_wood_donate + mat_food_donate
																	donationSumSevenDay = donationSumSevenDay + donation
																end
															end
															
															--print("        ������չ��� [" .. uid .. "]=" .. donationSumSevenDay)
															
															--�ҵ�����7�չ��׵����
															if (donationSumSevenDay > nDonationSevenDayValue) then
																nDonationSevenDayValue = donationSumSevenDay
																nDonationSevenDayUID = uid
															end
														end
														
														--print("    ��7�չ���ֵ��ߵ����="..nDonationSevenDayUID .. ", ��7�չ���ֵ=" .. nDonationSevenDayValue)
														
														--�ҳ��˽�7�չ���ֵ��ߵ����
														if (nDonationSevenDayUID > 0) then
															local sQueryM = string.format("SELECT `last_login_time` FROM `t_user` WHERE `uid` = %d", nDonationSevenDayUID)
															local errM, strLastLoginTime = xlDb_Query(sQueryM)
															--print("    ��ѯ��Ա�ϴε�¼ʱ��:", "errM=", errM, "strLastLoginTime=", strLastLoginTime)
															if (errM == 0) then
																local lastlogintime = hApi.GetNewDate(strLastLoginTime)
																--local currenttimestamp = os.time()
																local loginLastTime = currenttimestamp - lastlogintime
																if (loginLastTime <= 172800) then --��Ա48Сʱ�ڵ�¼��
																	--print("    ��48Сʱ�ڵ�¼��")
																	
																	--��ϲ��Ա����Ϊ����ϵͳ��
																	--���Ϊ����ϵͳ��
																	local sSql = string.format("UPDATE `novicecamp_member` SET `level` = %d WHERE `uid` = %d", hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM, nDonationSevenDayUID)
																	xlDb_Query(sSql)
																	
																	--֪ͨ�¼�
																	hGlobal.groupMgr:OnSystemAssistantGroupMember(groupId, 0, nDonationSevenDayUID, hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM)
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
							
							--������������Ƿ񱻰����ʸ�
							if (assistantUID > 0) then
								--�������߲���Ҫ���
								local userAssistant = hGlobal.uMgr:FindChatUserByDBID(assistantUID)
								if (not userAssistant) then
									--��ѯ�����ϴε�¼ʱ��
									--local strLastLoginTime = ""
									local sQueryM = string.format("SELECT `last_login_time` FROM `t_user` WHERE `uid` = %d", assistantUID)
									local errM, strLastLoginTime = xlDb_Query(sQueryM)
									--print("��ѯ�����ϴε�¼ʱ��:", "errM=", errM, "strLastLoginTime=", strLastLoginTime)
									if (errM == 0) then
										local lastlogintime = hApi.GetNewDate(strLastLoginTime)
										--local currenttimestamp = os.time()
										local loginLastTime = currenttimestamp - lastlogintime
										--print(assistantUID, loginLastTime)
										if (loginLastTime > 604800) then --����7��δ��¼
											--print("    ����7��δ��¼")
											
											--�����Ա��ȡ������ϵͳ��
											--ȡ�����Ϊ����ϵͳ��
											local sSql = string.format("UPDATE `novicecamp_member` SET `level` = %d WHERE `uid` = %d", hVar.GROUP_MEMBER_AUTORITY.NORMAL, assistantUID)
											xlDb_Query(sSql)
											
											--֪ͨ�¼�
											hGlobal.groupMgr:OnAssistantSystenCancelGroupMember(groupId, 0, assistantUID, hVar.GROUP_MEMBER_AUTORITY.NORMAL)
										end
									end
								end
							end
						end
					end
				end
			end
			
			--����Ƿ���������
			--local sDate = os.date("%Y-%m-%d", currenttimestamp)
			for i = 1, #GroupMgr.SYSTEM_CHECK_GROUP_AUTOFIRE_TIME, 1 do
				local sRefreshTime = GroupMgr.SYSTEM_CHECK_GROUP_AUTOFIRE_TIME[i].time
				local refresh_time = sDate .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					
					print("����Ƿ��Զ����������: " .. sDate)
					hGlobal.fileWriter:Write("����Ƿ��Զ����������: " .. sDate)
					
					--�����ݿ��ȡȫ����������Ϣ
					local sQueryM = string.format("SELECT `uid`, `ncid`, `time_jion` FROM `novicecamp_member` WHERE `level` = %d", 0)
					local errM, tTemp = xlDb_QueryEx(sQueryM)
					--print("�����ݿ��ȡȫ����������Ϣ:", "errM=", errM, "tTemp=", #tTemp)
					if (errM == 0) then
						--�����ʼ��
						for n = #tTemp, 1, -1 do
							local uid = tTemp[n][1] --���uid
							local ncid = tTemp[n][2] --����id
							local time_jion = tTemp[n][3] --����ʱ��
							--print(uid, ncid, time_jion)
							
							local nTimeJoin = hApi.GetNewDate(time_jion)
							local deltatime = currenttimestamp - nTimeJoin
							if (deltatime > hVar.GROUP_APPY_AUTOFIRE_TIME) then
								print("  ɾ��������[" .. uid .. "]: " .. " time_jion=" .. time_jion)
								hGlobal.fileWriter:Write("  ɾ��������[" .. uid .. "]: " .. " time_jion=" .. time_jion)
								
								local sDelete = string.format("DELETE FROM `novicecamp_member` WHERE `uid` = %d", uid)
								xlDb_Execute(sDelete)
							end
						end
					end
				end
			end
			
			--����Ƿ��ߵ����ŵ���ң�ϵͳ���š���ͨ���ţ�
			--local sDate = os.date("%Y-%m-%d", currenttimestamp)
			for i = 1, #GroupMgr.SYSTEM_CHECK_GROUP_KICK_SYSTEM_PLAYER_TIME, 1 do
				local sRefreshTime = GroupMgr.SYSTEM_CHECK_GROUP_KICK_SYSTEM_PLAYER_TIME[i].time
				local refresh_time = sDate .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					
					print("����Ƿ��ߵ����ŵ����: " .. sDate)
					hGlobal.fileWriter:Write("����Ƿ��ߵ����ŵ����: " .. sDate)
					
					--����Ƿ��ߵ����ŵ���ң�ϵͳ���š���ͨ���ţ�
					for groupId, tv in pairs(self._groupList) do
						--��ϵͳ����
						local is_system = self._groupSystemList[groupId]
						if (is_system == 1) then
							--���������߳��ĳ�Ա�б�ϵͳ���ţ�
							local tKickUIDList = {}
							local adminUID = 0
							for uid, level in pairs(tv) do
								if(level == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --�᳤
									adminUID = uid
								elseif(level == hVar.GROUP_MEMBER_AUTORITY.NORMAL) then --��Ա
									--��Ա�����߲���Ҫ���
									local userMember = hGlobal.uMgr:FindChatUserByDBID(uid)
									if (not userMember) then
										--��ѯ��Ա�ϴε�¼ʱ��
										--local strLastLoginTime = ""
										local sQueryM = string.format("SELECT `last_login_time` FROM `t_user` WHERE `uid` = %d", uid)
										local errM, strLastLoginTime = xlDb_Query(sQueryM)
										--print("��ѯ��Ա�ϴε�¼ʱ��:", "errM=", errM, "strLastLoginTime=", strLastLoginTime)
										if (errM == 0) then
											local lastlogintime = hApi.GetNewDate(strLastLoginTime)
											--local currenttimestamp = os.time()
											local loginLastTime = currenttimestamp - lastlogintime
											if (loginLastTime > 604800) then --ϵͳ���ų�Ա7��δ��¼
												--��Ҫ�ߵ�
												tKickUIDList[#tKickUIDList+1] = uid
											end
										end
									end
								end
							end
							
							--�����߳�7��δ��¼����ң�ϵͳ���ţ�
							for k, uid in ipairs(tKickUIDList) do
								--�᳤����
								local tCmd = {ncid=groupId, uid=adminUID, uid_member=uid,}
								NoviceCampMgr.PowerFire(tCmd)
								
								print("  �ߵ���ң�ϵͳ���ţ�: " .. uid)
								hGlobal.fileWriter:Write("  �ߵ���ң�ϵͳ���ţ�: " .. uid)
							end
						else --����ͨ����
							--���������߳��ĳ�Ա�б���ͨ���ţ�
							local tKickUIDList = {}
							local adminUID = 0
							for uid, level in pairs(tv) do
								if(level == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --�᳤
									adminUID = uid
								elseif(level == hVar.GROUP_MEMBER_AUTORITY.NORMAL) then --��Ա
									--��Ա�����߲���Ҫ���
									local userMember = hGlobal.uMgr:FindChatUserByDBID(uid)
									if (not userMember) then
										--��ѯ��Ա�ϴε�¼ʱ��
										--local strLastLoginTime = ""
										local sQueryM = string.format("SELECT `last_login_time` FROM `t_user` WHERE `uid` = %d", uid)
										local errM, strLastLoginTime = xlDb_Query(sQueryM)
										--print("��ѯ��Ա�ϴε�¼ʱ��:", "errM=", errM, "strLastLoginTime=", strLastLoginTime)
										if (errM == 0) then
											local lastlogintime = hApi.GetNewDate(strLastLoginTime)
											--local currenttimestamp = os.time()
											local loginLastTime = currenttimestamp - lastlogintime
											if (loginLastTime > 2592000) then --��ͨ���ų�Ա30��δ��¼
												--��Ҫ�ߵ�
												tKickUIDList[#tKickUIDList+1] = uid
											end
										end
									end
								end
							end
							
							--�����߳�30��δ��¼����ң���ͨ���ţ�
							for k, uid in ipairs(tKickUIDList) do
								--�᳤����
								NoviceCampMgr.KickGroupOfflinePlayer(1000, 0, groupId, uid)
								
								print("  �ߵ���ң���ͨ���ţ�: " .. uid)
								hGlobal.fileWriter:Write("  �ߵ���ң���ͨ���ţ�: " .. uid)
							end
						end
					end
				end
			end
			
			--����Ƿ��Զ�ת�þ��ţ��Ƿ��Զ���ɢ����
			--local sDate = os.date("%Y-%m-%d", currenttimestamp)
			for i = 1, #GroupMgr.SYSTEM_CHECK_GROUP_TRANSFER_TIME, 1 do
				local sRefreshTime = GroupMgr.SYSTEM_CHECK_GROUP_TRANSFER_TIME[i].time
				local refresh_time = sDate .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					
					print("����Ƿ�ת�þ��ţ��Ƿ��Զ���ɢ����: " .. sDate)
					hGlobal.fileWriter:Write("����Ƿ�ת�þ��ţ��Ƿ��Զ���ɢ����: " .. sDate)
					
					--����Ƿ��Զ�ת�þ��ţ��Ƿ��Զ���ɢ����
					for groupId, tv in pairs(self._groupList) do
						--����ϵͳ����
						local is_system = self._groupSystemList[groupId]
						if (is_system ~= 1) then
							local adminUID = 0 --�᳤uid
							local assistantUID = 0 --����uid
							local totalNum = 0 --�ܳ�Ա����
							
							for uid, level in pairs(tv) do
								--�ܳ�Ա������1
								totalNum = totalNum + 1
								
								if(level == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --�᳤
									adminUID = uid
								elseif(level == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) then --����
									assistantUID = uid
								elseif(level == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --����ϵͳ��
									assistantUID = uid
								end
							end
							
							--�᳤�����߲���Ҫ���
							local userAdmin = hGlobal.uMgr:FindChatUserByDBID(adminUID)
							if (not userAdmin) then
								--����Ƿ��Զ���ɢ����
								if (totalNum == 1) then --ֻʣ�᳤1��
									--��ѯ�᳤�ϴε�¼ʱ��
									--local strLastLoginTime = ""
									local sQueryM = string.format("SELECT `last_login_time` FROM `t_user` WHERE `uid` = %d", adminUID)
									local errM, strLastLoginTime = xlDb_Query(sQueryM)
									--print("��ѯ�᳤�ϴε�¼ʱ��:", "errM=", errM, "strLastLoginTime=", strLastLoginTime)
									if (errM == 0) then
										local lastlogintime = hApi.GetNewDate(strLastLoginTime)
										--local currenttimestamp = os.time()
										local loginLastTime = currenttimestamp - lastlogintime
										if (loginLastTime > 2592000) then --�᳤30��δ��¼
											--��ɢ���ţ�������Ա�ɲ�����
											NoviceCampMgr.AssetGroupDisolute(1000, 0, groupId)
											
											print("  ��ɢ����: groupId=" .. groupId)
											hGlobal.fileWriter:Write("  ��ɢ����: groupId=" .. groupId)
										end
									end
								end
								
								--������Զ���ת�þ���
								--print("groupId=" .. groupId, "adminUID=" .. adminUID, "assistantUID=" .. assistantUID)
								if (assistantUID > 0) then --��������
									--print("    ��������")
									--��ѯ�᳤�ϴε�¼ʱ��
									--local strLastLoginTime = ""
									local sQueryM = string.format("SELECT `last_login_time` FROM `t_user` WHERE `uid` = %d", adminUID)
									local errM, strLastLoginTime = xlDb_Query(sQueryM)
									--print("��ѯ�᳤�ϴε�¼ʱ��:", "errM=", errM, "strLastLoginTime=", strLastLoginTime)
									if (errM == 0) then
										local lastlogintime = hApi.GetNewDate(strLastLoginTime)
										--local currenttimestamp = os.time()
										local loginLastTime = currenttimestamp - lastlogintime
										if (loginLastTime > 2592000) then --�᳤30��δ��¼
											--print("    �᳤30��δ��¼")
											--��ѯ�˾��Ŵ�����ʱ��
											local sQueryM = string.format("SELECT `time_create`, `buildinfo`, `last_transfer_time` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
											local errM, strLastCreateTime, buildinfo, sLastTransfertTime = xlDb_Query(sQueryM)
											if (errM == 0) then
												local lastcreatetime = hApi.GetNewDate(strLastCreateTime)
												--local currenttimestamp = os.time()
												local createLastTime = currenttimestamp - lastcreatetime
												if (createLastTime > 2592000) then --�������Ŵﵽ30��
													--print("    �������Ŵ���30��")
													local townId = 80068 --����id
													local townLv = 0 --���ǵȼ�
													local tmp = "local strCfg = ".. tostring(buildinfo) .. " return strCfg"
													local tBuildInfo = assert(loadstring(tmp))()
													if (type(tBuildInfo) == "table") then
														local buildlist = tBuildInfo.buildlist
														if buildlist then
															for i = 1, #buildlist, 1 do
																if (buildlist[i].id == townId) then --�ҵ���
																	townLv = buildlist[i].lv
																	break
																end
															end
														end
													end
													if (townLv >= 3) then --���Ǵﵽ3��
														--print("    ���Ǵﵽ3��")
														
														--�������ϴ�ת��ʱ���Ƿ�ﵽ30��
														local lasttransferttime = hApi.GetNewDate(sLastTransfertTime)
														--local currenttimestamp = os.time()
														local transferLastTime = currenttimestamp - lasttransferttime
														if (transferLastTime > 2592000) then --�ϴ�ת�þ��Ŵﵽ30��
															--�������vip�ȼ��Ƿ���Ȩ�޴�������
															local vipLv = hGlobal.vipMgr:DBGetUserVip(assistantUID) --���vip�ȼ�
															local bCreateGroup = hVar.Vip_Conifg.createGroup[vipLv] --�Ƿ�ɴ�������Ȩ��
															if bCreateGroup then
																--����ת��
																--������������Ϊ�᳤��������Ա�ɲ�����
																NoviceCampMgr.AssetAdminPlayer(1000, 0, groupId, assistantUID)
																
																print("  ת�û᳤: groupId=" .. groupId .. ",assistantUID=" .. assistantUID)
																hGlobal.fileWriter:Write("  ת�û᳤: groupId=" .. groupId .. ",assistantUID=" .. assistantUID)
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
					end
				end
			end
			
			--����Ƿ񷢷ž��Ż�Ծ����
			--local sDate = os.date("%Y-%m-%d", currenttimestamp)
			for i = 1, #GroupMgr.SYSTEM_CHECK_GROUP_ACTIVITY_TIME, 1 do
				local sRefreshTime = GroupMgr.SYSTEM_CHECK_GROUP_ACTIVITY_TIME[i].time
				local refresh_time = sDate .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					
					print("check group activity prize: " .. sDate)
					hGlobal.fileWriter:Write("check group activity prize: ", sDate)
					
					--����ȫ������ҳ�ȫ���ľ��Ż�Ծ�
					--��ѯ���Ϣ
					local sQuery = string.format("select `aid`, `channel`, `prize`, `time_begin`, `time_end` from `activity_template` where `type`= %d", GroupMgr.ACTIVITY_ID)
					local iErrorCode, tTemp = xlDb_QueryEx(sQuery)
					--print("��ѯ���Ϣ", iErrorCode, tTemp)
					
					if (iErrorCode == 0) then
						for n = 1, #tTemp, 1 do
							local aid = tTemp[n][1] --�id
							local strChannel = tTemp[n][2] --��Ч��������
							local szPrize = tTemp[n][3] --�����ַ�����
							local strBeginTime = tTemp[n][4] --���ʼʱ��
							local strEndTime = tTemp[n][5] --�����ʱ��
							print("  �ҵ��[" .. n .. "]:")
							print("    aid=" .. aid)
							print("    channel=" .. tostring(strChannel))
							print("    time_begin=" .. strBeginTime)
							print("    time_end=" .. strEndTime)
							hGlobal.fileWriter:Write("  �ҵ��[" .. n .. "]:")
							hGlobal.fileWriter:Write("    aid=" .. aid)
							hGlobal.fileWriter:Write("    channel=" .. tostring(strChannel))
							hGlobal.fileWriter:Write("    time_begin=" .. strBeginTime)
							hGlobal.fileWriter:Write("    time_end=" .. strEndTime)
							
							--��ѽ����Ž��м��
							print("    ������ѷ����")
							hGlobal.fileWriter:Write("    ������ѷ����")
							local nEndTimestamp = hApi.GetNewDate(strEndTime)
							if (currenttimestamp > nEndTimestamp) then
								--����Ƿ��ѷ�����
								local sQueryC = string.format("select `level` from `activity_check` where `aid`= %d", aid)
								local nGetRewardFlag = 0 --�Ƿ������
								local iErrorCodeC, level = xlDb_Query(sQueryC)
								print("    ��ѯ��������콱: iErrorCodeC=" .. tostring(iErrorCodeC) .. ",level=" .. tostring(level))
								hGlobal.fileWriter:Write("    ��ѯ��������콱: iErrorCodeC=" .. tostring(iErrorCodeC) .. ",level=" .. tostring(level))
								if (iErrorCodeC == 0) then --�м�¼
									nGetRewardFlag = level
								elseif (iErrorCodeC == 4) then --û��¼
									nGetRewardFlag = 0
								end
								
								--δ�콱�Żᴦ��
								if (nGetRewardFlag == 0) then
									print("    δ�콱�Żᴦ��")
									hGlobal.fileWriter:Write("    δ�콱�Żᴦ��")
									
									--�������
									local prize = {}
									if (type(szPrize) == "string") then
										szPrize = "{" .. szPrize .. "}"
										local tmp = "local prize = " .. szPrize .. " return prize"
										prize = assert(loadstring(tmp))()
									end
									
									--������������Ҫ��ɵ�����
									local tPrize = prize[1]
									local nMaxDay = tPrize.totalday --�������
									local nRequiereDay = tPrize.rate --���Ҫ��ɵ�����
									local nRequiereActiveNum = tPrize.activenum --���Ҫ��ɵ�ÿ�ջ�Ծ����
									local prize_admin = tPrize.prize_admin --���Ż᳤�Ľ���
									local prize_assistant = tPrize.prize_assistant --��������Ľ���
									local prize_member = tPrize.prize_member --���ų�Ա�Ľ���
									
									--�������ʼʱ��ת��Ϊ�����0��
									local nBeginTimestamp = hApi.GetNewDate(strBeginTime)
									local strDateBeginTimestampYMD = hApi.Timestamp2Date(nBeginTimestamp) --ת�ַ���(������)
									local strNewBeginTimeZeroDate = strDateBeginTimestampYMD .. " 00:00:00"
									local nTimestampBeginTimeZero = hApi.GetNewDate(strNewBeginTimeZeroDate)
									
									--ͳ������
									local nTotalGroupNum = 0 --��ɻ���ܾ�������
									local nTotalPlayerNum = 0 --���������������
									
									--���α���ÿ�����ţ�����Ƿ�����˻
									for groupId, tv in pairs(self._groupList) do
										--��ѯ�ʱ����ڣ������ŵ�ȫ�����׼�¼
										if (groupId > 0) then
											--��ʼ������ÿ�ջ�Ծ���������
											local tActiveNumList = {} --����ÿ�ջ�Ծ���������
											local tActiveUIDDictionary = {} --����ÿ�ջ�Ծ����б�
											for i = 1, nMaxDay, 1 do
												tActiveNumList[i] = 0
												tActiveUIDDictionary[i] = {}
											end
											
											--print("    �������: " .. groupId)
											hGlobal.fileWriter:Write("    �������: " .. groupId)
											
											local sQueryM = string.format("SELECT `uid`, `channelId`, `mat_iron_donate`, `mat_wood_donate`, `mat_food_donate`, `group_coin`, `time` FROM `novicecamp_member_donate_log` WHERE `ncid`= %d AND `time` >= '%s' AND `time` <= '%s'", groupId, strBeginTime, strEndTime)
											local errM, tTemp = xlDb_QueryEx(sQueryM)
											--print("�����ݿ��ȡ�����б�:", "errM=", errM, "tTemp=", #tTemp)
											if (errM == 0) then
												for n = 1, #tTemp, 1 do
													local mat_uid = tTemp[n][1] --�������id
													local mat_channelId = tTemp[n][2] --�������������
													local mat_iron_donate = tTemp[n][3] --��
													local mat_wood_donate = tTemp[n][4] --ľ��
													local mat_food_donate = tTemp[n][5] --��ʳ
													local mat_group_coin = tTemp[n][6] --���ű�
													local mat_time = tTemp[n][7] --����
													--print(mat_uid, mat_channelId, mat_iron_donate, mat_wood_donate, mat_food_donate, mat_group_coin, mat_time)
													--print("            [����]: uid=" .. tostring(mat_uid) .. ",channelId=" .. tostring(mat_channelId) .. ",iron=" .. tostring(mat_iron_donate) .. ",mat_wood_donate=" .. tostring(mat_wood_donate) .. ",food=" .. tostring(mat_food_donate) .. ",group_coin=" .. tostring(mat_group_coin) .. ",time=" .. tostring(mat_time))
													hGlobal.fileWriter:Write("                [����]: uid=" .. tostring(mat_uid) .. ",channelId=" .. tostring(mat_channelId) .. ",iron=" .. tostring(mat_iron_donate) .. ",mat_wood_donate=" .. tostring(mat_wood_donate) .. ",food=" .. tostring(mat_food_donate) .. ",group_coin=" .. tostring(mat_group_coin) .. ",time=" .. tostring(mat_time))
													
													--��Ч�ľ���
													if (mat_iron_donate > 0) or (mat_wood_donate > 0) or(mat_food_donate > 0) or(mat_group_coin > 0) then
														--������׵�0��
														local nTimestampDonate = hApi.GetNewDate(mat_time)
														local strDateDonatestampYMD = hApi.Timestamp2Date(nTimestampDonate) --ת�ַ���(������)
														local strNewDonateZeroDate = strDateDonatestampYMD .. " 00:00:00"
														local nTimestampDonateZero = hApi.GetNewDate(strNewDonateZeroDate)
														
														--����������ڵڼ���
														local donatedeltatime = nTimestampDonateZero - nTimestampBeginTimeZero
														local donateDay = donatedeltatime / 86400
														local donateDayIdx = donateDay + 1
														--print("donateDayIdx=", donateDayIdx)
														
														--��������֮�ڵľ���
														if (donateDayIdx <= nMaxDay) then
															--�������ҵ���δ��ͳ�ƣ���ô���ջ�Ծ���������1
															if (tActiveUIDDictionary[donateDayIdx][mat_uid] == nil) then
																--��������ҵ��������Ƿ���Ч
																local bChannelValid_i = false
																if (strChannel == nil) or (strChannel == "") then --�δ��д�����ţ�������������Ч
																	bChannelValid_i = true
																else --����Ƿ������������
																	local pos = string.find(strChannel, ";" .. mat_channelId .. ";")
																	if (pos ~= nil) then
																		bChannelValid_i = true --�ҵ���
																	end
																end
																
																--��Ч�������ŵ����
																if bChannelValid_i then
																	tActiveUIDDictionary[donateDayIdx][mat_uid] = true
																	tActiveNumList[donateDayIdx] = tActiveNumList[donateDayIdx] + 1
																	
																	
																	--print("            ���[" .. mat_uid .. "]�ڵ�" .. donateDayIdx .. "���Ծ")
																	hGlobal.fileWriter:Write("            ���[" .. mat_uid .. "]�ڵ�" .. donateDayIdx .. "���Ծ")
																end
															end
														end
													end
												end
											end
											
											--ͳ�Ʊ����ŵ��ۼƻ�Ծ����
											local groupActiveDay = 0
											for i = 1, nMaxDay, 1 do
												--ÿ����20�˻�Ծ����Ծ������1
												if (tActiveNumList[i] >= nRequiereActiveNum) then
													groupActiveDay = groupActiveDay + 1
												end
												
												--print("        ��" .. i .. "���Ծ����: " .. tActiveNumList[i])
												hGlobal.fileWriter:Write("        ��" .. i .. "���Ծ����: " .. tActiveNumList[i])
											end
											--print("        �ܻ�Ծ����: " .. groupActiveDay)
											hGlobal.fileWriter:Write("        �ܻ�Ծ����: " .. groupActiveDay)
											
											--�����Ż�Ծ�����ﵽ7�죬��Ϊ��ɻ����
											if (groupActiveDay >= nRequiereDay) then
												print("        ��ɻ�����������ŷ��� " .. groupId)
												hGlobal.fileWriter:Write("        ��ɻ�����������ŷ��� " .. groupId)
												
												--ͳ�ƴ�ɻ���ܾ�������
												nTotalGroupNum = nTotalGroupNum + 1
												
												--���α��������ŵ����г�Ա
												for uid, level in pairs(tv) do
													local prize_list = nil
													if(level == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --�᳤
														prize_list = prize_admin
													elseif(level == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) then --����
														prize_list = prize_assistant
													elseif(level == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --����ϵͳ��
														prize_list = prize_assistant
													else --��Ա
														prize_list = prize_member
													end
													
													--ͳ�Ʒ��������������
													nTotalPlayerNum = nTotalPlayerNum + 1
													
													--����
													for p = 1, #prize_list, 1 do
														--���뽱����
														local id = prize_list[p].id
														local detail = prize_list[p].detail
														--print(rewardIdx, id, detail)
														
														--����
														local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",uid,id,detail,0,aid)
														xlDb_Execute(sInsert)
													end
												end
												
												--���;�����Ϣ
												--������
												local groupName = ""
												local sQueryM = string.format("SELECT `name` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
												local errM, strName = xlDb_Query(sQueryM)
												if (errM == 0) then
													groupName = strName
												end
												local tMsg = {}
												tMsg.chatType = hVar.CHAT_TYPE.GROUP
												tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE --����ϵͳ��ʾ��Ϣ
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
												tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ACTIVITY_TAKE_REWARD"], groupName)
												tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
												tMsg.touid = groupId
												tMsg.result = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE
												tMsg.resultParam = 0
												--���;�����Ϣ
												hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
												
												--[[
												--����������Ϣ
												local sysMsgtype = hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE --��ʾ��ϵͳ��Ϣ
												local content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_ACTIVITY_TAKE_REWARD_WORLD"], groupName)
												local strDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
												hGlobal.chatMgr:SendSystemMessage(sysMsgtype, content, strDate)
												]]
											end
										end
									end
									
									print("    ��������ܾ�����: " .. nTotalGroupNum)
									hGlobal.fileWriter:Write("    ��������ܾ�����: " .. nTotalGroupNum)
									print("    ������񷢽��������: " .. nTotalPlayerNum)
									hGlobal.fileWriter:Write("    ������񷢽��������: " .. nTotalPlayerNum)
									
									--��ǻ���콱
									if (iErrorCodeC == 0) then --�м�¼
										--�޸Ļ����
										local sSql = string.format("UPDATE `activity_check` SET `level` = %d, `lv01` = %d, `lv02` = %d WHERE `aid` = %d", 1, nTotalGroupNum, nTotalPlayerNum, aid)
										xlDb_Query(sSql)
										print("    �����콱��¼, aid=" .. aid)
										hGlobal.fileWriter:Write("    �����콱��¼, aid=" .. aid)
									elseif (iErrorCodeC == 4) then --û��¼
										--�����»����
										local sInsert = string.format("insert into `activity_check`(`aid`, `uid`, `rid`, `level`, `lv01`, `lv02`) values (%d, %d, %d, %d, %d, %d)", aid, 0, 0, 1, nTotalGroupNum, nTotalPlayerNum)
										xlDb_Execute(sInsert)
										print("    �����콱��¼, aid=" .. aid)
										hGlobal.fileWriter:Write("    �����콱��¼, aid=" .. aid)
									end
								end
							end
						end
					end
				end
			end
			
			--����Ƿ񷢷ž�������������ÿ��һ��
			--local sDate = os.date("%Y-%m-%d", currenttimestamp)
			for i = 1, #GroupMgr.SYSTEM_CHECK_RANK_TIME, 1 do
				local sRefreshTime = GroupMgr.SYSTEM_CHECK_RANK_TIME[i].time
				local weekId = GroupMgr.SYSTEM_CHECK_RANK_TIME[i].weekId --�ܼ����
				local refresh_time = sDate .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					
					print("����Ƿ񷢷ž�����������: " .. sDate)
					hGlobal.fileWriter:Write("����Ƿ񷢷ž�����������: ", sDate)
					
					--�������ܼ�
					local weekNum = os.date("*t", nRefreshTime).wday - 1
					if (weekNum == 0) then
						weekNum = 7
					end
					print("  weekNum=" .. weekNum)
					hGlobal.fileWriter:Write("  weekNum=" .. weekNum)
					
					--��ȡ��һ�η��ž�������������ʱ��
					local last_check_time = ""
					local sQuery = string.format("select IFNULL(MAX(`check_time`), '') from `leaderboards_check` where `leaderboards_id`= %d and `tType` = %d", GroupMgr.RANKBOARD_ID, GroupMgr.RANKBOARD_TYPE)
					local iErrorCode, check_time = xlDb_Query(sQuery)
					--print("��ѯ��һ�η��ž�������������ʱ��", iErrorCode, check_time)
					if (iErrorCode == 0) then
						last_check_time = check_time
					end
					print("  last_check_time=" .. last_check_time)
					hGlobal.fileWriter:Write("  last_check_time=" .. last_check_time)
					
					--�Ƿ���Ҫ���н���
					local bNeedCheck = false
					
					--���ݿ���������Ҫ����
					if (last_check_time == "") then
						print("  ���ݿ���������Ҫ����")
						hGlobal.fileWriter:Write("  ���ݿ���������Ҫ����")
						bNeedCheck = true
					end
					
					--�����ϴη�������7����Ҫ����
					local nTimestamp7Day = hApi.GetNewDate(last_check_time, "DAY", 7)
					if (currenttimestamp >= nTimestamp7Day) then
						print("  �����ϴη�������7����Ҫ����")
						hGlobal.fileWriter:Write("  �����ϴη�������7����Ҫ����")
						bNeedCheck = true
					end
					
					--��һ��Ҫ����
					if (weekNum == weekId) then
						print("  ��һ��Ҫ����")
						hGlobal.fileWriter:Write("  ��һ��Ҫ����")
						bNeedCheck = true
					end
					
					print("  bNeedCheck=" .. tostring(bNeedCheck))
					hGlobal.fileWriter:Write("  bNeedCheck=" .. tostring(bNeedCheck))
					
					--��Ҫ����
					if bNeedCheck then
						--��ȡ������������
						local sCmd = ""
						local nTotalPlayerNum = 0 --ͳ�ƹ��������������
						local private = NoviceCampMgr.private
						local tList = private.Data_GetNcList(1)
						if (type(tList) == "table") then
							--���ž��Ÿ��˱��ܾ��׵�һ������
							local maxUID = 0
							local maxNcid = 0
							local maxShengwangWeek = 0
							local sQuery = string.format("SELECT `uid`, `ncid`, `shengwang_week` FROM `novicecamp_member` WHERE `shengwang_week` >= %d ORDER BY `shengwang_week` DESC, `ncid` DESC, `uid` DESC LIMIT 1", GroupMgr.RANKBOARD_SHENGWANGWEEK_MIN_SINGLE)
							local err, uid, ncid, shengwang_week = xlDb_Query(sQuery)
							if (err == 0) then
								maxUID = uid
								maxNcid = ncid
								maxShengwangWeek = shengwang_week
							end
							print("  maxUID=" .. maxUID)
							print("  maxNcid=" .. maxNcid)
							print("  maxShengwangWeek=" .. maxShengwangWeek)
							hGlobal.fileWriter:Write("  maxUID=" .. maxUID)
							hGlobal.fileWriter:Write("  maxNcid=" .. maxNcid)
							hGlobal.fileWriter:Write("  maxShengwangWeek=" .. maxShengwangWeek)
							--���뽱��
							local mkey = string.format(hVar.tab_string["__TEXT_GROUP_SHENGWANGWEEK_SINGLE_CONTENT"], maxShengwangWeek)
							local insertSql = string.format("INSERT INTO `prize`(`uid`, `rid`, `type`, `used`, `mykey`) values(%d, 0, %d, '0', '%s')", maxUID, GroupMgr.RANKBOARD_PRIZE_TYPE_SINGLE, mkey)
							local err = xlDb_Execute(insertSql)
							--֪ͨ�¼������ž��Ÿ��˱����������������
							if (maxNcid > 0) then
								hGlobal.groupMgr:OnGroupWeekDonateSumSingle(maxNcid, maxUID, maxShengwangWeek)
							end
							
							--ֻ��ǰ100��������������
							for i = 1, 100, 1 do
								local groupId = 0
								local groupName = ""
								local shengwang_week_sum = 0
								local uids = ""
								local tListInfo = tList[i]
								if tListInfo then
									--ȫ����ų�Ա���ŵ�i������
									groupId = tListInfo[1]
									groupName = tListInfo[2]
									shengwang_week_sum = tListInfo[16]
									
									if (groupId > 0) then
										--�ҵ���Ӧ���εĽ�����
										local reward = nil
										for r = 1, #GroupMgr.RANKBOARD_PRIZE_LIST, 1 do
											local tPrizeList = GroupMgr.RANKBOARD_PRIZE_LIST[r]
											local from = tPrizeList.from
											local to = tPrizeList.to
											if (from <= i) and (i <= to) then --�ҵ���
												reward = tPrizeList.reward
												break
											end
										end
										if reward then
											if self._groupList[groupId] then
												for uid, level in pairs(self._groupList[groupId]) do
													--ֻ�����ų�Ա����
													if (level > 0) then
														--print("    ", i, uid, level)
														--����
														local prize_list = ""
														local strAythen = ""
														if(level == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then --�᳤
															prize_list = reward.prize_admin
															strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_ADMIN"]
														elseif(level == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) then --����
															prize_list = reward.prize_assistant
															strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_ASSIST"]
														elseif(level == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --����ϵͳ��
															prize_list = reward.prize_assistant
															strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_ASSIST"]
														else --��Ա
															prize_list = reward.prize_member
															strAythen = hVar.tab_string["__TEXT_GROUP_AUTHEN_MEMBER"]
														end
														
														--���뽱����
														local id = GroupMgr.RANKBOARD_PRIZE_TYPE
														local detail = string.format(hVar.tab_string["__TEXT_GROUP_RANKBOARD_CONTENT"], strAythen, groupName, shengwang_week_sum, i, prize_list)
														--print(rewardIdx, id, detail)
														
														--����
														local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",uid,id,detail,0,groupId)
														xlDb_Execute(sInsert)
														
														--��¼��ұ��ܾ��ž����ܺͣ�ÿ�ܷ�������գ�
														--�����ҵ���������
														local sUpdate = string.format("update `novicecamp_member` set `shengwang_week` = %d where `uid` = %d", 0, uid)
														xlDb_Execute(sUpdate)
														
														--��־
														uids = uids .. tostring(uid) .. "|" .. tostring(level) .. ","
														
														--ͳ�Ʒ������������
														nTotalPlayerNum = nTotalPlayerNum + 1
													end
												end
												
												--������ŵ���������
												local sSql = string.format("UPDATE `novicecamp_list` SET `shengwang_week_sum` = %d WHERE `id`= %d", 0, groupId)
												xlDb_Execute(sSql)
											end
										end
										
										--֪ͨ�¼������ž���ÿ����������
										hGlobal.groupMgr:OnGroupWeekDonateSend(groupId, groupName, shengwang_week_sum, i)
									end
								end
								
								sCmd = sCmd .. "rank=" .. tostring(i) .. ",groupId=" .. tostring(groupId) .. ",groupName=" .. tostring(groupName) .. ",shengwang_week_sum=" .. tostring(shengwang_week_sum) .. ",uids=\n" .. uids .. "\n"
							end
						end
						print("  nTotalPlayerNum=" .. nTotalPlayerNum)
						hGlobal.fileWriter:Write("  nTotalPlayerNum=" .. nTotalPlayerNum)
						
						sCmd = "totalnum=" .. tostring(nTotalPlayerNum) .. "\n" .. sCmd
						
						hGlobal.fileWriter:Write(sCmd)
						
						--���·���ʱ��
						local sInsert = string.format("insert into `leaderboards_check`(`leaderboards_id`, `tType`, `result`, `check_time`) values (%d, %d, '%s', '%s')", GroupMgr.RANKBOARD_ID, GroupMgr.RANKBOARD_TYPE, sCmd, refresh_time)
						--print(sInsert)
						xlDb_Execute(sInsert)
					end
				end
			end
			
			--����Ƿ񷢷ž���������������
			--local sDate = os.date("%Y-%m-%d", currenttimestamp)
			for i = 1, #GroupMgr.SYSTEM_CHECK_CHAT_DRAGON_TIME, 1 do
				local sRefreshTime = GroupMgr.SYSTEM_CHECK_CHAT_DRAGON_TIME[i].time
				local refresh_time = sDate .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					
					print("����Ƿ񷢷ž���������������: " .. sDate)
					hGlobal.fileWriter:Write("����Ƿ񷢷ž���������������: " .. sDate)
					
					--�������Ƿ��ѷ���
					local sql = string.format("SELECT * FROM `prize` WHERE `type`= %d and `create_time` >= '%s' AND `create_time` <= '%s'", hVar.REWARD_LOG_TYPE.chatDragonReward, sDate .." 00:00:00", sDate .." 23:59:59")
					local err, roomid,tactic_cfg = xlDb_Query(sql)
					--print("_CheckPvePlayerPrize:",err,sql)
					if (err == 0) then
						--����Ҫ�ٷ���
						print("    ����Ҫ�ٷ���")
						hGlobal.fileWriter:Write("    ����Ҫ�ٷ���")
					elseif (err == 4) then
						--��ⷢ��
						print("    ��ⷢ��")
						hGlobal.fileWriter:Write("    ��ⷢ��")
						
						local maxUID = 0
						local maxCount = 0
						local sql = string.format("SELECT `uid`, `msg_total_num` FROM `t_chat_user` WHERE `msg_total_num` >= 30 AND `last_msg_total_time` >= '%s' ORDER BY `msg_total_num` DESC LIMIT 1", sDate .." 00:00:00")
						local err, uid, count = xlDb_Query(sql)
						--print(sql)
						--print(err)
						if (err == 0) then
							maxUID = uid
							maxCount = count
						end
						
						--���뽱��
						local mkey = hVar.tab_string["__TEXT_CHATDRAGON_REWARD_TITLE"] .. ";" .. sDate .. ";" .. tostring(maxCount) .. ";" .. hVar.tab_string["__TEXT_CHATDRAGON_REWARD"]
						local insertSql = string.format("INSERT INTO `prize`(`uid`, `rid`, `type`, `used`, `mykey`) values(%d, 0, %d, '0', '%s')", maxUID, hVar.REWARD_LOG_TYPE.chatDragonReward, mkey)
						local err = xlDb_Execute(insertSql)
						--print("insertSql=", insertSql, err)
						print("    maxUID="..maxUID)
						print("    maxCount="..maxCount)
						hGlobal.fileWriter:Write("    maxUID="..maxUID)
						hGlobal.fileWriter:Write("    maxCount="..maxCount)
						
						--������ҵ���������ͷ��
						if (maxUID > 0) then
							local nExpireTime = hApi.GetNewDate(refresh_time, "DAY", 1) -- +1��
							local sExpireTime = os.date("%Y-%m-%d %H:%M:%S", nExpireTime)
							local sUpdate = string.format("UPDATE `t_user` SET `dragon` = %d, `dragon_expire_time` = '%s' WHERE `uid` = %d", 1, sExpireTime, maxUID)
							xlDb_Execute(sUpdate)
						end
					end
				end
			end
		end
	end
	
return GroupMgr