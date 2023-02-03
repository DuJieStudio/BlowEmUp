--�û���
local User = class("User")
	
	--��ɫ״̬
	User.STATEINFO = 
	{
		UNINIT = -1,		--δ��ʼ��
		INIT = 1,			--��ʼ��
	}
	
	-------------------------------------------------------------------------------------------------
	--���캯��
	function User:ctor()
		--��ʼ��˽�б���
		self._id = -1							--�ڴ�id
		self._uid = -1							--���ݿ�id
		self._rid = -1							--��ǰʹ�õĽ�ɫId
		
		self._state = -1						--�Ƿ��ʼ��
		self._bGetBaseInfo = false				--�Ƿ��ȡ������Ϣ
		
		self._name = ""							--�û�����
		
		--����Ա��ʶ
		self.bTester = -1						--����Ա���
		
		--�������
		self.msg_init_state = -1				--������������Ƿ��ʼ��(1:��ʼ��)
		self.msg_world_num = -1					--�ϴ������������
		self.msg_total_num = -1					--�ϴ�ȫ���������
		self.msg_world_timestamp = -1			--�ϴ����������ʱ���
		self.msg_total_timestamp = -1			--�ϴ�ȫ�������ʱ���
		self.forbidden = -1						--�Ƿ񱻽���
		self.forbidden_timestamp = -1			--�����Ե�ʱ���
		self.forbidden_minute = -1				--�����Գ���ʱ�䣨��λ:���ӣ�
		self.forbidden_op_uid = -1				--���Բ�����uid
		self.msg_private_friend_count = -1		--˽�ĺ���������
		self.msg_private_friend_chat_list = -1	--˽�ĺ�����������
		self.msg_private_friend_last_uid = -1	--˽�����һ�κ���uid
		self.group_send_packet_num = -1			--���վ��ŷ��������
		self.group_send_packet_timestamp = -1	--�ϴξ��ŷ������ʱ���
		
		return self
	end
	
	--��ʼ������
	function User:Init(id, uid, rid)
		self._id = id
		self._uid = uid
		self._rid = rid
		--self._name = hVar.tab_string["__TEXT_PLAYER"].. tostring(dbId)
		
		self._state = User.STATEINFO.INIT		--���ó�ʼ��
		self._bGetBaseInfo = false	--�Ƿ��ȡ������Ϣ
		
		--����Ա��ʶ
		self.bTester = 0						--����Ա���
		
		--�������
		self.msg_init_state = 0					--������������Ƿ��ʼ��(1:��ʼ��)
		self.msg_world_num = 0					--�ϴ������������
		self.msg_total_num = 0					--�ϴ�ȫ���������
		self.msg_world_timestamp = 631123200	--�ϴ����������ʱ���(Ĭ��1990��)
		self.msg_total_timestamp = 631123200	--�ϴ�ȫ�������ʱ���(Ĭ��1990��)
		self.forbidden = 0						--�Ƿ񱻽���
		self.forbidden_timestamp = 631123200	--�����Ե�ʱ���(Ĭ��1990��)
		self.forbidden_minute = 0				--�����Գ���ʱ�䣨��λ:���ӣ�
		self.forbidden_op_uid = 0				--���Բ�����uid
		self.msg_private_friend_count = 0		--˽�ĺ���������
		self.msg_private_friend_chat_list = {}	--˽�ĺ�����������
		self.msg_private_friend_last_uid = 0	--˽�����һ�κ���uid
		self.group_send_packet_num = 0			--���վ��ŷ��������
		self.group_send_packet_timestamp = 631123200	--�ϴξ��ŷ������ʱ���(Ĭ��1990��)
		
		return self
	end
	
	--release
	function User:Release()
		self._id = -1							--�ڴ�id
		self._uid = -1							--���ݿ�id
		self._rid = -1							--��ǰʹ�õĽ�ɫId
		
		self._state = -1						--�Ƿ��ʼ��
		self._bGetBaseInfo = false				--�Ƿ��ȡ������Ϣ
		
		self._name = ""							--�û�����
		
		--����Ա��ʶ
		self.bTester = -1						--����Ա���
		
		--�������
		self.msg_init_state = -1				--������������Ƿ��ʼ��(1:��ʼ��)
		self.msg_world_num = -1					--�ϴ������������
		self.msg_total_num = -1					--�ϴ�ȫ���������
		self.msg_world_timestamp = -1			--�ϴ����������ʱ���
		self.msg_total_timestamp = -1			--�ϴ�ȫ�������ʱ���
		self.forbidden = -1						--�Ƿ񱻽���
		self.forbidden_timestamp = -1			--�����Ե�ʱ���
		self.forbidden_minute = -1				--�����Գ���ʱ�䣨��λ:���ӣ�
		self.forbidden_op_uid = -1				--���Բ�����uid
		self.msg_private_friend_count = -1		--˽�ĺ���������
		self.msg_private_friend_chat_list = -1	--˽�ĺ�����������
		self.msg_private_friend_last_uid = -1	--˽�����һ�κ���uid
		self.group_send_packet_num = -1			--���վ��ŷ��������
		self.group_send_packet_timestamp = -1	--�ϴξ��ŷ������ʱ���(Ĭ��1990��)
		
		return self
	end
	
	--��ȡ�û��ڴ�ID
	function User:GetID()
		return self._id
	end
	
	--��ȡ�û�DBID
	function User:GetUID()
		return self._uid
	end
	
	--��ȡ�û�ʹ�ý�ɫID
	function User:GetRID()
		return self._rid
	end
	
	--��ȡ�û�Name
	function User:GetName()
		return self._name
	end
	
	--��ȡ��ǰ״̬
	function User:GetState()
		return self._state
	end
	
	--��ȡ����Ա��ʶ
	function User:GetTester()
		return self.bTester
	end
	
	--�û���ʼ��
	function User:SetInit()
		self._state = User.STATEINFO.INIT
	end
	
	--�û��Ƿ��ʼ��
	function User:IsInit()
		local ret = false
		if (self._state > User.STATEINFO.UNINIT) then
			ret = true
		end
		
		return ret
	end
	
	--�û�����������ݳ�ʼ��
	function User:InitChat()
		--���ظ���ʼ����������
		if (self.msg_init_state ~= 1) then
			--��ѯ��ҹ���Ա���
			local sQueryT = string.format("SELECT `bTester` FROM `t_user` WHERE `uid` = %d", self._uid)
			local errT, bTester = xlDb_Query(sQueryT)
			if (errT == 0) then --��ѯ�ɹ�
				self.bTester = bTester
			end
			
			local sQueryCU = string.format("SELECT `uid`, `name`, `msg_world_num`, `last_msg_world_time`, `msg_total_num`, `last_msg_total_time`, `forbidden`, `last_forbidden_time`, `forbidden_minute`, `forbidden_op_uid`, `msg_private_friend_count`, `msg_private_friend_list`, `msg_private_friend_last_uid`, `send_redpacket_num`, `last_send_redpacket_time` FROM `t_chat_user` WHERE `uid` = %d", self._uid)
			local errCU, uid, name, msg_world_num, last_msg_world_time, msg_total_num, last_msg_total_time, forbidden, last_forbidden_time, forbidden_minute, forbidden_op_uid, msg_private_friend_count, msg_private_friend_list, msg_private_friend_last_uid, send_packet_num, last_send_packet_time = xlDb_Query(sQueryCU)
			--print("�����ݿ��ȡ���������Ϣ��:","errCU=" .. errCU, uid, name, msg_world_num, last_msg_world_time, msg_total_numn, last_msg_total_time, forbidden, last_forbidden_time, forbidden_minute, forbidden_op_uid, msg_private_friend_count, msg_private_friend_list, msg_private_friend_last_uid, send_packet_num, last_send_packet_time)
			
			if (errCU == 0) then --��ѯ�ɹ�
				self.msg_world_num = msg_world_num --�ϴ������������
				self.msg_total_num = msg_total_num --�ϴ�ȫ���������
				self.msg_world_timestamp = hApi.GetNewDate(last_msg_world_time) --�ϴ����������ʱ���
				self.msg_total_timestamp = hApi.GetNewDate(last_msg_total_time) --�ϴ�ȫ�������ʱ���
				self.forbidden = forbidden --�Ƿ񱻽���
				self.forbidden_timestamp = hApi.GetNewDate(last_forbidden_time) --�����Ե�ʱ���
				self.forbidden_minute = forbidden_minute --�����Գ���ʱ�䣨��λ:���ӣ�
				self.forbidden_op_uid = forbidden_op_uid --���Բ�����uid
				
				--˽���������ޣ�������Ա�����������ضϣ�
				if (msg_private_friend_count > hVar.CHAT_MAX_USERNUM_PRIVATE_GM) then
					msg_private_friend_count = hVar.CHAT_MAX_USERNUM_PRIVATE_GM
				end
				self.msg_private_friend_count = msg_private_friend_count --˽�ĺ���������
				
				self.msg_private_friend_chat_list = {} --˽�ĺ�����������
				
				--��ѯ˽�ĺ�����Ϣ
				if (msg_private_friend_count > 0) then
					local valid_friend_count = 0 --��Ч�ĺ�������
					local tFriendList = hApi.Split(msg_private_friend_list, ";")
					for i = 1, msg_private_friend_count, 1 do
						local tFriend = hApi.Split(tFriendList[i], "|")
						local touid = tonumber(tFriend[1]) or 0 --����uid
						local inviteflag = tonumber(tFriend[2]) or 0 --�����Ƿ�ͨ������
						local toname = tostring(tFriend[3]) or "" --����name
						local tochannelId = tonumber(tFriend[4]) or 0 --����channelId
						local tovip = tonumber(tFriend[5]) or 0 --����vip
						local toborderId = tonumber(tFriend[6]) or 0 --����borderId
						local toiconId = tonumber(tFriend[7]) or 0 --����iconId
						local tochampionId = tonumber(tFriend[8]) or 0 --����championId
						local toleaderId = tonumber(tFriend[9]) or 0 --����leaderId
						local todragonId = tonumber(tFriend[10]) or 0 --����dragonId
						local toheadId = tonumber(tFriend[11]) or 0 --����headId
						local tolineId = tonumber(tFriend[12]) or 0 --����lineId
						if (touid > 0) then
							local chatList = {}
							
							--��ѯ���30������֮��������¼
							local chatType = hVar.CHAT_TYPE.PRIVATE --˽����Ϣ
							local sQueryM = string.format("SELECT `id`, `type`, `msg_type`, `uid`, `name`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `content`, `time`, `touid`, `result` FROM `chat` WHERE `type` = %d and ((`uid` = %d and `touid` = %d) or (`uid` = %d and `touid` = %d)) and `deleteflag` = 0 order by `id` desc limit %d", chatType, self._uid, touid, touid, self._uid, hVar.CHAT_MAX_LENGTH_PRIVATE)
							local errM, tTemp = xlDb_QueryEx(sQueryM)
							--print("��ѯ���30������֮��������¼:", "errM=" .. errM, "tTemp=" .. tostring(tTemp and #tTemp))
							if (errM == 0) then
								--�����ʼ��
								for n = #tTemp, 1, -1 do
									local id = tTemp[n][1]
									local chatType = tTemp[n][2]
									local msgType = tTemp[n][3]
									local uid = tTemp[n][4]
									local name = tTemp[n][5]
									local channelId = tTemp[n][6]
									local vip = tTemp[n][7]
									local borderId = tTemp[n][8]
									local iconId = tTemp[n][9]
									local championId = tTemp[n][10]
									local leaderId = tTemp[n][11]
									local dragonId = tTemp[n][12]
									local headId = tTemp[n][13]
									local lineId = tTemp[n][14]
									local content = tTemp[n][15]
									local date = tTemp[n][16]
									local touid = tTemp[n][17]
									local result = tTemp[n][18]
									local resultParam = tTemp[n][19]
									
									--print("�����¼:", id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
									
									local chat = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
									chatList[#chatList+1] = chat
								end
							end
							
							self.msg_private_friend_chat_list[#self.msg_private_friend_chat_list+1] =
							{
								touid = touid, --����uid
								inviteflag = inviteflag, --���Ѻ����Ƿ�ͨ������
								toname = toname, --����name
								tochannelId = tochannelId, --����channelId
								tovip = tovip, --����vip
								toborderId = toborderId, --����borderId
								toiconId = toiconId, --����iconId
								tochampionId = tochampionId, --����championId
								toleaderId = toleaderId, --����leaderId
								todragonId = todragonId, --����dragonId
								toheadId = toheadId, --����headId
								tolineId = tolineId, --����lineId
								chatList = chatList, --�����¼
							}
							
							--��Ч�ĺ���������1
							valid_friend_count = valid_friend_count + 1
						end
					end
					
					--�޸�Ϊ��Чֵ
					self.msg_private_friend_count = valid_friend_count
				end
				
				--˽�����һ�κ���uid
				self.msg_private_friend_last_uid = msg_private_friend_last_uid
				
				--���ź����Ϣ
				self.group_send_packet_num = send_packet_num --���վ��ŷ��������
				self.group_send_packet_timestamp = hApi.GetNewDate(last_send_packet_time) --�ϴξ��ŷ������ʱ���
			elseif (errCU == 4) then --û�м�¼
				local sInsertCU = string.format("insert into `t_chat_user`(`uid`, `name`, `msg_world_num`, `msg_total_num`, `last_msg_world_time`, `forbidden`, `last_forbidden_time`, `forbidden_minute`, `forbidden_op_uid`, `msg_private_friend_count`, `msg_private_friend_list`, `msg_private_friend_last_uid`, `send_redpacket_num`, `last_send_redpacket_time`) values(%d, '', 0, 0, '1990-01-01 00:00:00', 0, '1990-01-01 00:00:00', 0, 0, 0, '', 0, 0, '1990-01-01 00:00:00')", self._uid)
				--print(sInsertCU)
				xlDb_Execute(sInsertCU)
			end
			
			--���������Ϣ��ʼ�����
			self.msg_init_state = 1
		end
		
		--������ʱ���Ƿ���
		if (self.forbidden == 1) then
			local forbidden_end_timestamp = self.forbidden_timestamp + self.forbidden_minute * 60
			--print(forbidden_end_timestamp, os.time())
			--����ʱ�䵽��
			if (os.time() > forbidden_end_timestamp) then
				local sUpdateCU = string.format("update `t_chat_user` set `forbidden` = 0 where `uid` = %d", self._uid)
				--print(sUpdateCU)
				xlDb_Execute(sUpdateCU)
				
				--��ǲ���������
				self.forbidden = 0
			end
		end
		
		--����Ƿ񵽵ڶ��죬���������������
		local tab1 = os.date("*t", self.msg_world_timestamp)
		local tab2 = os.date("*t", os.time())
		if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --���˵ڶ���
			if (self.msg_world_num > 0) then
				local sUpdateCU = string.format("update `t_chat_user` set `msg_world_num` = 0 where `uid` = %d", self._uid)
				--print(sUpdateCU)
				xlDb_Execute(sUpdateCU)
				
				--���������������
				self.msg_world_num = 0
			end
		end
		
		--����Ƿ񵽵ڶ��죬����ȫ���������
		local tab1 = os.date("*t", self.msg_total_timestamp)
		local tab2 = os.date("*t", os.time())
		if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --���˵ڶ���
			if (self.msg_total_num > 0) then
				local sUpdateCU = string.format("update `t_chat_user` set `msg_total_num` = 0 where `uid` = %d", self._uid)
				--print(sUpdateCU)
				xlDb_Execute(sUpdateCU)
				
				--����ȫ���������
				self.msg_total_num = 0
			end
		end
		
		--����Ƿ񵽵ڶ��죬���þ��ź������
		local tab1 = os.date("*t", self.group_send_packet_timestamp)
		local tab2 = os.date("*t", os.time())
		if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --���˵ڶ���
			if (self.group_send_packet_num > 0) then
				local sUpdateCU = string.format("update `t_chat_user` set `send_redpacket_num` = 0 where `uid` = %d", self._uid)
				--print(sUpdateCU)
				xlDb_Execute(sUpdateCU)
				
				--���þ��ź������
				self.group_send_packet_num = 0
			end
		end
	end
	
	--����һ����ʱUser���󣬽����ڴ���˽���������
	function User:CreateUserPrivateObject(uid)
		local user = hClass.User:create():Init(0, uid, 0)
		
		local sQueryCU = string.format("SELECT `uid`, `name`, `msg_world_num`, `last_msg_world_time`, `msg_total_num`, `last_msg_total_time`, `forbidden`, `last_forbidden_time`, `forbidden_minute`, `forbidden_op_uid`, `msg_private_friend_count`, `msg_private_friend_list`, `msg_private_friend_last_uid` FROM `t_chat_user` WHERE `uid` = %d", user._uid)
		local errCU, uid, name, msg_world_num, last_msg_world_time, msg_total_num, last_msg_total_time, forbidden, last_forbidden_time, forbidden_minute, forbidden_op_uid, msg_private_friend_count, msg_private_friend_list, msg_private_friend_last_uid = xlDb_Query(sQueryCU)
		--print("�����ݿ��ȡ���������Ϣ��:","errCU=" .. errCU, uid, name, msg_world_num, last_msg_world_time, msg_total_num, last_msg_total_time, forbidden, last_forbidden_time, forbidden_minute, forbidden_op_uid, msg_private_friend_count, msg_private_friend_list, msg_private_friend_last_uid)
		
		if (errCU == 0) then --��ѯ�ɹ�
			user.msg_world_num = msg_world_num --�ϴ������������
			user.msg_total_num = msg_total_num --�ϴ�ȫ���������
			user.msg_world_timestamp = hApi.GetNewDate(last_msg_world_time) --�ϴ����������ʱ���
			self.msg_total_timestamp = hApi.GetNewDate(last_msg_total_time) --�ϴ�ȫ�������ʱ���
			user.forbidden = forbidden --�Ƿ񱻽���
			user.forbidden_timestamp = hApi.GetNewDate(last_forbidden_time) --�����Ե�ʱ���
			user.forbidden_minute = forbidden_minute --�����Գ���ʱ�䣨��λ:���ӣ�
			user.forbidden_op_uid = forbidden_op_uid --���Բ�����uid
			
			--����Ƿ񵽵ڶ��죬����User���������������
			local tab1 = os.date("*t", user.msg_world_timestamp)
			local tab2 = os.date("*t", os.time())
			if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --���˵ڶ���
				--����User���������������
				user.msg_world_num = 0
			end
			
			--����Ƿ񵽵ڶ��죬����User����ȫ���������
			local tab1 = os.date("*t", user.msg_total_timestamp)
			local tab2 = os.date("*t", os.time())
			if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --���˵ڶ���
				--����User���������������
				user.msg_total_num = 0
			end
			
			--˽���������ޣ�������Ա��������ضϣ�
			if (msg_private_friend_count > hVar.CHAT_MAX_USERNUM_PRIVATE_GM) then
				msg_private_friend_count = hVar.CHAT_MAX_USERNUM_PRIVATE_GM
			end
			user.msg_private_friend_count = msg_private_friend_count --˽�ĺ���������
			
			user.msg_private_friend_chat_list = {} --˽�ĺ�����������
			
			--��ѯ˽�ĺ�����Ϣ
			if (msg_private_friend_count > 0) then
				local valid_friend_count = 0 --��Ч�ĺ�������
				local tFriendList = hApi.Split(msg_private_friend_list, ";")
				for i = 1, msg_private_friend_count, 1 do
					local tFriend = hApi.Split(tFriendList[i], "|")
					local touid = tonumber(tFriend[1]) or 0 --����uid
					local inviteflag = tonumber(tFriend[2]) or 0 --�����Ƿ�ͨ������
					local toname = tostring(tFriend[3]) or "" --����name
					local tochannelId = tonumber(tFriend[4]) or 0 --����channelId
					local tovip = tonumber(tFriend[5]) or 0 --����vip
					local toborderId = tonumber(tFriend[6]) or 0 --����borderId
					local toiconId = tonumber(tFriend[7]) or 0 --����iconId
					local tochampionId = tonumber(tFriend[8]) or 0 --����championId
					local toleaderId = tonumber(tFriend[9]) or 0 --����leaderId
					local todragonId = tonumber(tFriend[10]) or 0 --����dragonId
					local toheadId = tonumber(tFriend[11]) or 0 --����headId
					local tolineId = tonumber(tFriend[12]) or 0 --����lineId
					if (touid > 0) then
						local chatList = {}
						
						--[[
						--��ѯ���30������֮��������¼
						local chatType = hVar.CHAT_TYPE.PRIVATE --˽����Ϣ
						local sQueryM = string.format("SELECT `id`, `type`, `msg_type`, `uid`, `name`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `content`, `time`, `touid`, `result` FROM `chat` WHERE `type` = %d and ((`uid` = %d and `touid` = %d) or (`uid` = %d and `touid` = %d)) and `deleteflag` = 0 order by `id` desc limit %d", chatType, user._uid, touid, touid, user._uid, hVar.CHAT_MAX_LENGTH_PRIVATE)
						local errM, tTemp = xlDb_QueryEx(sQueryM)
						--print("��ѯ���30������֮��������¼:", "errM=" .. errM, "tTemp=" .. tostring(tTemp and #tTemp))
						if (errM == 0) then
							--�����ʼ��
							for n = #tTemp, 1, -1 do
								local id = tTemp[n][1]
								local chatType = tTemp[n][2]
								local msgType = tTemp[n][3]
								local uid = tTemp[n][4]
								local name = tTemp[n][5]
								local channelId = tTemp[n][6]
								local vip = tTemp[n][7]
								local borderId = tTemp[n][8]
								local iconId = tTemp[n][9]
								local championId = tTemp[n][10]
								local leaderId = tTemp[n][11]
								local dragonId = tTemp[n][12]
								local headId = tTemp[n][13]
								local lineId = tTemp[n][14]
								local content = tTemp[n][15]
								local date = tTemp[n][16]
								local touid = tTemp[n][17]
								local result = tTemp[n][18]
								local resultParam = tTemp[n][19]
								
								--print("�����¼:", id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
								
								local chat = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
								chatList[#chatList+1] = chat
							end
						end
						]]
						
						user.msg_private_friend_chat_list[#user.msg_private_friend_chat_list+1] =
						{
							touid = touid, --����uid
							inviteflag = inviteflag, --���Ѻ����Ƿ�ͨ������
							toname = toname, --����name
							tochannelId = tochannelId, --����channelId
							tovip = tovip, --����vip
							toborderId = toborderId, --����borderId
							toiconId = toiconId, --����iconId
							tochampionId = tochampionId, --����championId
							toleaderId = toleaderId, --����leaderId
							todragonId = todragonId, --����dragonId
							toheadId = toheadId, --����headId
							tolineId = tolineId, --����lineId
							chatList = chatList, --�����¼
						}
						
						--��Ч�ĺ���������1
						valid_friend_count = valid_friend_count + 1
					end
				end
				
				--�޸�Ϊ��Чֵ
				user.msg_private_friend_count = valid_friend_count
			end
			
			--˽�����һ�κ���uid
			user.msg_private_friend_last_uid = msg_private_friend_last_uid
			
			return user
		end
	end
	
	--�û��Ƿ񱻽���
	function User:GetForbidden()
		local forbidden = 1
		
		if (self.msg_init_state == 1) then
			--������ʱ���Ƿ���
			if (self.forbidden == 1) then
				local forbidden_end_timestamp = self.forbidden_timestamp + self.forbidden_minute * 60
				--print(forbidden_end_timestamp, os.time())
				--����ʱ�䵽��
				if (os.time() > forbidden_end_timestamp) then
					forbidden = 0
				end
			else
				forbidden = 0
			end
		end
		
		return forbidden
	end
	
	--��ȡ�û����շ����ź������
	function User:GetSendRedPacketNum()
		local sendRedPacketNum = 0
		
		if (self.msg_init_state == 1) then
			sendRedPacketNum = self.group_send_packet_num
		end
		
		return sendRedPacketNum
	end
	
	--�����û����շ����ź������
	function User:AddSendRedPacketNum(sendNum)
		if (self.msg_init_state == 1) then
			local currenttime = os.time()
			
			--����Ƿ񵽵ڶ��죬���÷����ź������
			local tab1 = os.date("*t", self.group_send_packet_timestamp)
			local tab2 = os.date("*t", currenttime)
			if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --���˵ڶ���
				--���÷����ź������
				self.group_send_packet_num = sendNum
				self.group_send_packet_timestamp = currenttime
			else
				--���½��մ���
				self.group_send_packet_num = self.group_send_packet_num + sendNum
				self.group_send_packet_timestamp = currenttime
			end
			
			local sUpdateCU = string.format("update `t_chat_user` set `send_redpacket_num` = %d, `last_send_redpacket_time` = now() where `uid` = %d", self.group_send_packet_num, self._uid)
			--print(sUpdateCU)
			xlDb_Execute(sUpdateCU)
		end
	end
	
	--�����û�������������
	function User:AddWorldMessageCount(name, msgNum)
		if (self.msg_init_state == 1) then
			local currenttime = os.time()
			
			--����Ƿ񵽵ڶ��죬���������������
			local tab1 = os.date("*t", self.msg_world_timestamp)
			local tab2 = os.date("*t", currenttime)
			if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --���˵ڶ���
				--���������������
				self.msg_world_num = msgNum
				self.msg_world_timestamp = currenttime
			else
				--���½��մ���
				self.msg_world_num = self.msg_world_num + msgNum
				self.msg_world_timestamp = currenttime
			end
			
			local sUpdateCU = string.format("update `t_chat_user` set `name` = '%s', `msg_world_num` = %d, `last_msg_world_time` = now() where `uid` = %d", name, self.msg_world_num, self._uid)
			--print(sUpdateCU)
			xlDb_Execute(sUpdateCU)
		end
	end
	
	--�����û�ȫ��������Ϣ����
	function User:AddTotalMessageCount(msgNum)
		if (self.msg_init_state == 1) then
			local currenttime = os.time()
			
			--����Ƿ񵽵ڶ��죬����ȫ���������
			local tab1 = os.date("*t", self.msg_total_timestamp)
			local tab2 = os.date("*t", currenttime)
			if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --���˵ڶ���
				--����ȫ���������
				self.msg_total_num = msgNum
				self.msg_total_timestamp = currenttime
			else
				--���½��մ���
				self.msg_total_num = self.msg_total_num + msgNum
				self.msg_total_timestamp = currenttime
			end
			
			--д��־
			local info = "uid=" .. tostring(self._uid) .. ",msg_world_num=" .. tostring(self.msg_world_num) .. ",msg_total_num=" .. tostring(self.msg_total_num) .. ",msg_world_timestamp=" .. tostring(os.date("%Y-%m-%d %H:%M:%S", self.msg_world_timestamp))
			hGlobal.chatWriter:Write(info)
			
			local sUpdateCU = string.format("update `t_chat_user` set `msg_total_num` = %d, `last_msg_total_time` = now() where `uid` = %d", self.msg_total_num, self._uid)
			--print(sUpdateCU)
			xlDb_Execute(sUpdateCU)
		end
	end
	
	--����uid
	--����ֵ: �������, �����
	function User:ForbiddenUser(forbiddenUid, minute)
		--�������
		local ret = 0
		local forbiddenUName = nil
		if (self.msg_init_state == 1) then
			if (minute > 0) then
				--ȡ�����
				local sQueryT = string.format("SELECT `name` FROM `t_chat_user` WHERE `uid` = %d", forbiddenUid)
				local errT, name = xlDb_Query(sQueryT)
				if (errT == 0) then --��ѯ�ɹ�
					forbiddenUName = name
					
					local sUpdateCU = string.format("update `t_chat_user` set `forbidden` = %d, `last_forbidden_time` = now(), `forbidden_minute` = %d, `forbidden_op_uid` = %d where `uid` = %d", 1, minute, self:GetUID(), forbiddenUid)
					--print(sUpdateCU)
					xlDb_Execute(sUpdateCU)
					
					--���±����Ե�����ڴ�����
					local forbiddenUser = hGlobal.uMgr:FindChatUserByDBID(forbiddenUid)
					if forbiddenUser then
						forbiddenUser.forbidden = 1 --�Ƿ񱻽���
						forbiddenUser.forbidden_timestamp = os.time() --�����Ե�ʱ���
						forbiddenUser.forbidden_minute = minute --�����Գ���ʱ�䣨��λ:���ӣ�
						forbiddenUser.forbidden_op_uid = self:GetUID() --���Բ�����uid
					end
					
					--�����ɹ�
					ret = 1
				else
					--��Ч�����
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
				end
			else
				--�������Ϸ�
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
			end
			
		else
			--���δ��ʼ��
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_USER_INIT
		end
		
		return ret, forbiddenUName
	end
	
	--�������һ������ĺ���uid
	function User:SetFriendLastUid(friendUid)
		if (self.msg_private_friend_last_uid ~= friendUid) then
			--�������ݿ�
			local sUpdateCU = string.format("update `t_chat_user` set `msg_private_friend_last_uid` = %d where `uid` = %d", friendUid, self._uid)
			--print(sUpdateCU)
			xlDb_Execute(sUpdateCU)
			
			self.msg_private_friend_last_uid = friendUid
		end
	end
	
	--��ѯ�����˽�ĺ��ѵ�ָ������id�б����������
	function User:ChatFriendMsgByIDList(chatType, friendUid, msgIDList)
		local sCmd = ""
		local snum = 0 --��Ч����Ϣ����
		local msgIdNum = #msgIDList --��Ϣ������
		local tFriend = nil
		
		--print("��ѯ�����˽�ĺ��ѵ�ָ������id�б����������", self._uid, chatType, friendUid)
		if (self.msg_init_state == 1) then
			--��ѯ��˽���������������ֵ
			if (#msgIDList <= hVar.CHAT_MAX_LENGTH_WORLD) then
				--print("self.msg_private_friend_count=", self.msg_private_friend_count)
				for i = 1, self.msg_private_friend_count, 1 do
					local tFriend_i = self.msg_private_friend_chat_list[i]
					local touid = tFriend_i.touid --����uid
					--print(i, "touid=", touid)
					if (touid == friendUid) then
						tFriend = tFriend_i --�ҵ���
						break
					end
				end
				
				--�Է����ҵĺ���
				if tFriend then
					--���β���id
					for c = 1, msgIdNum, 1 do
						local msgId = msgIDList[c]
						--print("����˽����Ϣ", msgId)
						local NUM = #tFriend.chatList
						for i = 1, NUM, 1 do
							local chat = tFriend.chatList[i]
							if (chat._id == msgId) then
								if (chatType == chat._chatType) then
									local tempStr = chat:ToCmd()
									sCmd = sCmd .. tempStr
									snum = snum + 1
								end
							end
						end
					end
				end
			end
		end
		
		sCmd = tostring(snum) .. ";" .. sCmd
		--print("sCmd=", sCmd)
		
		return sCmd
	end
	
	--���һ��˽����Ϣ
	--����ֵ: �������
	function User:SendPrivateMessage(chat)
		--�������
		local ret = 0
		
		if (chat._chatType == hVar.CHAT_TYPE.PRIVATE) then --ֻ����˽��Ƶ��
			--local uid = chat._uid
			--local touid = chat._touid
			
			--������Ϊ�Լ������߽��������Լ�
			if (chat._uid == self._uid) or (chat._touid == self._uid) then
				--���Է��Ƿ����Լ������б���
				local tFriend = nil
				local tFriendIdx = 0
				for i = 1, self.msg_private_friend_count, 1 do
					local tFriend_i = self.msg_private_friend_chat_list[i]
					local touid_i = tFriend_i.touid --����uid
					--print(i, "touid_i=", touid_i)
					if (touid_i == chat._touid) or (touid_i == chat._uid) then
						tFriend = tFriend_i --�ҵ���
						tFriendIdx = i
						break
					end
				end
				--����Ƿ��Ǻ���
				--print("tFriend=", tFriend)
				if tFriend then
					--����Ƿ�ͨ��������֤
					--print("tFriend.inviteflag=", tFriend.inviteflag)
					if (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.ACCEPT) then --״̬Ϊ�ѽ���
						--�Է���Ҷ���
						local friendUser = hGlobal.uMgr:FindChatUserByDBID(chat._touid)
						if (friendUser == nil) then
							--����һ����ʱ��user���󣬽����ڴ���˽�ĵ�����
							friendUser = hClass.User:CreateUserPrivateObject(chat._touid)
							--print("����һ����ʱ��user����", chat._touid)
						end
						
						--���Է��������Ƿ�����
						local tFriendMe = nil
						local tFriendIdxMe = 0
						for i = 1, friendUser.msg_private_friend_count, 1 do
							local tFriendMe_i = friendUser.msg_private_friend_chat_list[i]
							local touid_me_i = tFriendMe_i.touid --����uid
							--print(i, "touid_i=", touid_i)
							if (self._uid == touid_me_i) then
								tFriendMe = tFriendMe_i --�ҵ���
								tFriendIdxMe = i
								break
							end
						end
						
						--�Է�������Ҳ����
						if tFriendMe then
							if (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.ACCEPT) then --�ѽ���
								--���Է���˽����Ϣ
								tFriend.chatList[#tFriend.chatList+1] = chat
								--print("���˽����Ϣ", chat._uid, chat._touid, chat._chatType, "chat.id=", chat._id, "#tFriend.chatList=", #tFriend.chatList)
								
								--��Ϣ��������˽�����ޣ�ɾ����һ����Ϣ
								if (#tFriend.chatList > hVar.CHAT_MAX_LENGTH_PRIVATE) then
									--�Ƴ���Ϣ
									local msgId = tFriend.chatList[1]:GetID()
									table.remove(tFriend.chatList, 1)
									
									--֪ͨ�Լ�: ɾ�����������Ϣ
									local sCmd = tostring(msgId)
									hApi.xlNet_Send(self._uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
								end
								
								local bRequireDBUpdate = false --�Ƿ���Ҫ�������ݿ�
								
								--��Ϊ��������Ϣ���˺������ҵĺ����б��ŵ�һλ
								if (tFriendIdx > 1) then
									table.remove(self.msg_private_friend_chat_list, tFriendIdx)
									table.insert(self.msg_private_friend_chat_list, 1, tFriend)
									bRequireDBUpdate = true --��Ҫ�������ݿ�
								end
								
								--�������ݿ�
								if bRequireDBUpdate then
									local strFriendInfo = self:_PrivateFriendInfoToDBCmd()
									local sUpdateCU = string.format("update `t_chat_user` set `msg_private_friend_count` = %d, `msg_private_friend_list` = '%s' where `uid` = %d", self.msg_private_friend_count, strFriendInfo, self._uid)
									xlDb_Execute(sUpdateCU)
									--print("sUpdateCU")
								end
								
								--�Է�Ҳ��Ӻ��ҵ�˽����Ϣ
								--���¶Է��ڴ�����
								tFriendMe.chatList[#tFriendMe.chatList+1] = chat
								
								--��Ϣ��������˽�����ޣ�ɾ����һ����Ϣ
								if (#tFriendMe.chatList > hVar.CHAT_MAX_LENGTH_PRIVATE) then
									--�Ƴ���Ϣ
									local msgId = tFriendMe.chatList[1]:GetID()
									table.remove(tFriendMe.chatList, 1)
									
									--֪ͨ����: ɾ�����������Ϣ
									local sCmd = tostring(msgId)
									hApi.xlNet_Send(chat._touid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
								end
								
								local bRequireDBUpdateMe = false --�Է��Ƿ���Ҫ�������ݿ�
								
								--��Ϊ��������Ϣ�����ڴ˺����б��ŵ�һλ
								if (tFriendIdxMe > 1) then
									table.remove(friendUser.msg_private_friend_chat_list, tFriendIdxMe)
									table.insert(friendUser.msg_private_friend_chat_list, 1, tFriendMe)
									bRequireDBUpdateMe = true --��Ҫ�������ݿ�
									--print("bRequireDBUpdateMe 1")
								end
								
								--���Է��������Ϣ�Ƿ���Ҫ����
								if (tFriendMe.toname ~= chat._name) or (tFriendMe.tochannelId ~= chat._channelId) or (tFriendMe.tovip ~= chat._vip)
									or (tFriendMe.toborderId ~= chat._borderId) or (tFriendMe.toiconId ~= chat._iconId)
									or (tFriendMe.tochampionId ~= chat._championId) or (tFriendMe.toleaderId ~= chat._leaderId)
									or (tFriendMe.todragonId ~= chat._dragonId) or (tFriendMe.toheadId ~= chat._headId)
									or (tFriendMe.tolineId ~= chat._lineId) then
									bRequireDBUpdateMe = true --��Ҫ�������ݿ�
									--print("bRequireDBUpdateMe 2")
									
									--�����ڴ�����
									--tFriendMe.touid = touid --����uid
									--tFriendMe.inviteflag = inviteflag --���Ѻ����Ƿ�ͨ������
									tFriendMe.toname = chat._name --����name
									tFriendMe.tochannelId = chat._channelId --����channelId
									tFriendMe.tovip = chat._vip --����vip
									tFriendMe.toborderId = chat._borderId --����borderId
									tFriendMe.toiconId = chat._iconId --����iconId
									tFriendMe.tochampionId = chat._championId --����championId
									tFriendMe.toleaderId = chat._leaderId --����leaderId
									tFriendMe.todragonId = chat._dragonId --����dragonId
									tFriendMe.toheadId = chat._headId --����headId
									tFriendMe.tolineId = chat._lineId --����lineId
									--tFriendMe.chatList = chatList --�����¼
								end
								
								--�������ݿ�
								if bRequireDBUpdateMe then
									local strFriendInfoMe = friendUser:_PrivateFriendInfoToDBCmd()
									local sUpdateCUMe = string.format("update `t_chat_user` set `msg_private_friend_count` = %d, `msg_private_friend_list` = '%s' where `uid` = %d", friendUser.msg_private_friend_count, strFriendInfoMe, friendUser._uid)
									xlDb_Execute(sUpdateCUMe)
									--print("sUpdateCUMe")
								end
								
								--������ҽ������������˽��Ƶ����
								self:AddTotalMessageCount(1)
								
								--�����ɹ�
								ret = 1
							elseif (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.NONE) then
								--�ȴ��Է�ͨ��˽������
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE
							elseif (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.REFUSE) then --�Ѿܾ�
								--�Է��Ѿܾ�����˽������
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REFUSE
							elseif (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.REFUSEBY) then --�ѱ��ܾ�
								--���Ѿܾ��Է���˽������
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REFUSE_ME
							elseif (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.DELETE) then --��ɾ��
								--�Է��ѹرպ����˽��
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REMOVE
							elseif (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.DELETEBY) then --��ɾ��
								--���ѽ��Է�ɾ��
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REMOVE_ME
							end
						else
							--�����ڶԷ���˽���б���
							ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_FRIEND_ME
						end
					elseif (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.NONE) then --δ����
						--�ȴ��Է�ͨ��˽������
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE
					elseif (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.REFUSE) then --�Ѿܾ�
						--���Ѿܾ��Է���˽������
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REFUSE_ME
					elseif (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.REFUSEBY) then --�ѱ��ܾ�
						--�Է��Ѿܾ�����˽������
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REFUSE
					elseif (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.DELETE) then --��ɾ��
						--���ѽ��Է�ɾ��
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REMOVE_ME
					elseif (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.DELETEBY) then --��ɾ��
						--�Է��ѹرպ����˽��
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REMOVE
					end
				else
					--�Է���������˽���б���
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_FRIEND
				end
			else
				--��Ч�����
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
			end
		else
			--ֻ�ܷ���˽����Ϣ
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_TYPE
		end
		
		return ret
	end
	
	--���һ��˽����֤��Ϣ
	function User:_AddPrivateInviteMessage(chat)
		--�������
		local ret = 0
		
		if (self.msg_init_state == 1) then
			if (chat._chatType == hVar.CHAT_TYPE.PRIVATE) then --ֻ����˽��Ƶ��
				--������Ϊ�Լ�
				if (chat._uid == self._uid) then
					--���Է��Ƿ����Լ������б���
					local tFriend = nil
					local tFriendIdx = 0
					for i = 1, self.msg_private_friend_count, 1 do
						local tFriend_i = self.msg_private_friend_chat_list[i]
						local touid_i = tFriend_i.touid --����uid
						--print(i, "touid_i=", touid_i)
						if (touid_i == chat._touid) or (touid_i == chat._uid) then
							tFriend = tFriend_i --�ҵ���
							tFriendIdx = i
							break
						end
					end
					--����Ƿ��Ǻ���
					--print("tFriend=", tFriend)
					if tFriend then
						tFriend.chatList[#tFriend.chatList+1] = chat
						--print("���һ��˽�ĺ�����֤��Ϣ", chat._uid, chat._touid, chat._chatType, "chat.id=", chat._id, "#tFriend.chatList=", #tFriend.chatList)
						
						--��Ϣ��������˽�����ޣ�ɾ����һ����Ϣ
						if (#tFriend.chatList > hVar.CHAT_MAX_LENGTH_PRIVATE) then
							--�Ƴ���Ϣ
							local msgId = tFriend.chatList[1]:GetID()
							table.remove(tFriend.chatList, 1)
							
							--֪ͨ�Լ�: ɾ�����������Ϣ
							local sCmd = tostring(msgId)
							hApi.xlNet_Send(self._uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
						end
						
						--�Է�Ҳ��Ӻ��ҵ�˽����Ϣ
						--���¶Է��ڴ�����
						local friendUser = hGlobal.uMgr:FindChatUserByDBID(chat._touid)
						if (friendUser == nil) then
							--����һ����ʱ��user���󣬽����ڴ���˽�ĵ�����
							friendUser = hClass.User:CreateUserPrivateObject(chat._touid)
							--print("����һ����ʱ��user����", chat._touid)
						end
						if friendUser then
							local tFriendMe = nil
							local tFriendIdxMe = 0
							for i = 1, friendUser.msg_private_friend_count, 1 do
								local tFriendMe_i = friendUser.msg_private_friend_chat_list[i]
								local touid_me_i = tFriendMe_i.touid --����uid
								--print(i, "touid_i=", touid_i)
								if (touid_me_i == chat._touid) or (touid_me_i == chat._uid) then
									tFriendMe = tFriendMe_i --�ҵ���
									tFriendIdxMe = i
									break
								end
							end
							if tFriendMe then
								tFriendMe.chatList[#tFriendMe.chatList+1] = chat
								
								--��Ϣ��������˽�����ޣ�ɾ����һ����Ϣ
								if (#tFriendMe.chatList > hVar.CHAT_MAX_LENGTH_PRIVATE) then
									--�Ƴ���Ϣ
									local msgId = tFriendMe.chatList[1]:GetID()
									table.remove(tFriendMe.chatList, 1)
									
									--֪ͨ����: ɾ�����������Ϣ
									local sCmd = tostring(msgId)
									hApi.xlNet_Send(chat._touid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
								end
							end
						end
						
						--����һ��˽��������־
						hGlobal.chatMgr:InsertInveteLog(self._uid, chat._name, chat._touid, tFriend.toname, tFriend.inviteflag)
						
						--�����ɹ�
						ret = 1
					else
						--�Է���������˽���б���
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_FRIEND
					end
				else
					--��Ч�����
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
				end
			else
				--ֻ�ܷ���˽����Ϣ
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_TYPE
			end
		else
			--���δ��ʼ��
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_USER_INIT
		end
		
		return ret
	end
	
	--����ͶԷ���ҷ���˽��
	--����ֵ: �������
	function User:PrivateInviteUser(tMsgMe, tMsgFriend)
		--�������
		local ret = 0
		
		if (self.msg_init_state == 1) then
			--��Ч�����uid
			if (tMsgFriend.uid > 0) then
				--��������Լ�Ϊ����
				if (tMsgFriend.uid ~= self._uid) then
					--����Ƿ񱻽���
					local forbidden = self:GetForbidden()
					if (forbidden == 0) then
						--���˺����Ƿ����ҵ�˽���б���
						--local touid = tMsgFriend.uid
						local tFriend = nil
						local tFriendIdx = 0
						for i = 1, self.msg_private_friend_count, 1 do
							local tFriend_i = self.msg_private_friend_chat_list[i]
							local friendUid = tFriend_i.touid --����uid
							if (tMsgFriend.uid == friendUid) then
								tFriend = tFriend_i --�ҵ���
								tFriendIdx = i
								break
							end
						end
						
						--�����Ƿ�����
						local online = 1
						local friendUser = hGlobal.uMgr:FindChatUserByDBID(tMsgFriend.uid)
						if (friendUser == nil) then
							--����һ����ʱ��user���󣬽����ڴ���˽�ĵ�����
							friendUser = hClass.User:CreateUserPrivateObject(tMsgFriend.uid)
							--print("����һ����ʱ������ͶԷ����˽��user����", tMsgFriend.uid)
							online = 0
						end
						
						--��Ч��˽��Ŀ��
						if friendUser then
							--�����ҵ�˽���б�������Ҳ����ߣ����ҷ����߲��ǹ���Ա�����ܷ���˽��
							--if tFriend or (online == 1) or (self:GetTester() == 2) then
							--if tFriend then
								--�Է������ҵĺ��ѣ������ҵĺ������ˣ����ܷ���˽��
								local MAX_USERNUM = hVar.CHAT_MAX_USERNUM_PRIVATE
								if (self:GetTester() == 2) then --�������󣬹���Ա�ɼ�������˽��
									MAX_USERNUM = hVar.CHAT_MAX_USERNUM_PRIVATE_GM
								end
								if tFriend or (self.msg_private_friend_count < MAX_USERNUM) then
									--�Է������ҵĺ��ѣ����ҽ��շ���˽�Ĵ����������ޣ����ܷ���˽��
									local inveteLogCount = hGlobal.chatMgr:QueryInveteLogCount(self._uid, tMsgFriend.uid)
									if tFriend or (inveteLogCount < hVar.CHAT_MAX_COUNT_PRIVATE) then
										--���Է��������ҵ�״̬
										local tFriendMe = nil
										local tFriendIdxMe = 0
										for i = 1, friendUser.msg_private_friend_count, 1 do
											local tFriendMe_i = friendUser.msg_private_friend_chat_list[i]
											local touid_me_i = tFriendMe_i.touid --����uid
											--print(i, "touid_i=", touid_i)
											if (self._uid == touid_me_i) then
												tFriendMe = tFriendMe_i --�ҵ���
												tFriendIdxMe = i
												break
											end
										end
										
										--�Է��Ƿ���ͨ����
										local nFriendInviteStateOK = 0
										if tFriendMe then --�Է�����������
											--print(tFriendMe.inviteflag)
											if (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.NONE) or (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.ACCEPT) then --�ȴ�����
												--�������
												nFriendInviteStateOK = 1
											elseif (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.REFUSE) then --�Ѿܾ�
												--�Է��Ѿܾ�����˽������
												--ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REFUSE
												if (inveteLogCount < hVar.CHAT_MAX_COUNT_PRIVATE) then
													--�������
													nFriendInviteStateOK = 1
												else
													--����������˽�ĸ���ҵĴ����ﵽ����
													ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_MAXCOUNT
												end
											elseif (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.REFUSEBY) then --�ѱ��ܾ�
												--���Ѿܾ��Է���˽������
												--ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REFUSE_ME
												if (inveteLogCount < hVar.CHAT_MAX_COUNT_PRIVATE) then
													--�������
													nFriendInviteStateOK = 1
												else
													--����������˽�ĸ���ҵĴ����ﵽ����
													ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_MAXCOUNT
												end
											elseif (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.DELETE) then --��ɾ��
												--�Է��ѹرպ����˽��
												--ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REMOVE
												if (inveteLogCount < hVar.CHAT_MAX_COUNT_PRIVATE) then
													--�������
													nFriendInviteStateOK = 1
												else
													--����������˽�ĸ���ҵĴ����ﵽ����
													ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_MAXCOUNT
												end
											elseif (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.DELETEBY) then --��ɾ��
												--���ѽ��Է�ɾ��
												--ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REMOVE_ME
												if (inveteLogCount < hVar.CHAT_MAX_COUNT_PRIVATE) then
													--�������
													nFriendInviteStateOK = 1
												else
													--����������˽�ĸ���ҵĴ����ﵽ����
													ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_MAXCOUNT
												end
											end
										else --�Է�������û����
											--�Ҳ��ǶԷ��ĺ��ѣ����ҽ��շ���˽�Ĵ����������ޣ����ܷ���˽��
											if (inveteLogCount < hVar.CHAT_MAX_COUNT_PRIVATE) then
												--���Է������Ƿ�����
												if (friendUser.msg_private_friend_count < MAX_USERNUM) then
													--�������
													nFriendInviteStateOK = 1
												else
													--�Է�˽�������Ѵ����ޣ��޷�����˽��
													ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_USER_NUMMAX_ME
												end
											else
												--����������˽�ĸ���ҵĴ����ﵽ����
												ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_MAXCOUNT
											end
										end
										
										--�Է����Լ���
										if (nFriendInviteStateOK == 1) then
											local bRequireDBUpdate = false --���Ƿ���Ҫ�������ݿ�
											local bRequireDBUpdateMe = false --�Է��Ƿ���Ҫ�������ݿ�
											
											--�¼ӵĺ���
											if (tFriend == nil) then
												local chatList = {}
												
												--��ѯ���29(30-1)������֮��������¼(���һ���Ǻ���������֤��Ϣ)
												local chatType = hVar.CHAT_TYPE.PRIVATE --˽����Ϣ
												local sQueryM = string.format("SELECT `id`, `type`, `msg_type`, `uid`, `name`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `content`, `time`, `touid`, `result` FROM `chat` WHERE `type` = %d and ((`uid` = %d and `touid` = %d) or (`uid` = %d and `touid` = %d)) and `deleteflag` = 0 order by `id` desc limit %d", chatType, self._uid, tMsgFriend.uid, tMsgFriend.uid, self._uid, hVar.CHAT_MAX_LENGTH_PRIVATE - 1)
												local errM, tTemp = xlDb_QueryEx(sQueryM)
												--print("��ѯ���30������֮��������¼:", "errM=" .. errM, "tTemp=" .. tostring(tTemp and #tTemp))
												if (errM == 0) then
													--�����ʼ��
													for n = #tTemp, 1, -1 do
														local id = tTemp[n][1]
														local chatType = tTemp[n][2]
														local msgType = tTemp[n][3]
														local uid = tTemp[n][4]
														local name = tTemp[n][5]
														local channelId = tTemp[n][6]
														local vip = tTemp[n][7]
														local borderId = tTemp[n][8]
														local iconId = tTemp[n][9]
														local championId = tTemp[n][10]
														local leaderId = tTemp[n][11]
														local dragonId = tTemp[n][12]
														local headId = tTemp[n][13]
														local lineId = tTemp[n][14]
														local content = tTemp[n][15]
														local date = tTemp[n][16]
														local touid = tTemp[n][17]
														local result = tTemp[n][18]
														local resultParam = tTemp[n][19]
														
														--print("�����¼:", id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
														
														local chat = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
														chatList[#chatList+1] = chat
													end
												end
												
												tFriend =
												{
													touid = tMsgFriend.uid, --����uid
													inviteflag = 0, --���Ѻ����Ƿ�ͨ������
													toname = tMsgFriend.name, --����name
													tochannelId = tMsgFriend.channelId, --����channelId
													tovip = tMsgFriend.vip, --����vip
													toborderId = tMsgFriend.borderId, --����borderId
													toiconId = tMsgFriend.iconId, --����iconId
													tochampionId = tMsgFriend.championId, --����championId
													toleaderId = tMsgFriend.leaderId, --����leaderId
													todragonId = tMsgFriend.dragonId, --����dragonId
													toheadId = tMsgFriend.headId, --����headId
													tolineId = tMsgFriend.lineId, --����lineId
													chatList = chatList, --�����¼
												}
												
												table.insert(self.msg_private_friend_chat_list, 1, tFriend)
												self.msg_private_friend_count = self.msg_private_friend_count + 1
												--print(tMsgFriend.uid, tMsgFriend.name, tMsgFriend.channelId, tMsgFriend.borderId, tMsgFriend.iconId, tMsgFriend.championId, tMsgFriend.leaderId, tMsgFriend.dragonId , tMsgFriend.headId , tMsgFriend.lineId)
											end
											
											--������״�����Ӻ��ѣ������ұ�ǵĶԷ�״̬����ɾ�����Ѿܾ��ȵȣ���Ҫ��������
											if (tFriendIdx == 0)
											or (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.REFUSE)
											or (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.REFUSEBY)
											or (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.DELETE)
											or (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.DELETEBY) then
												--��Ҫ���һ������������֤��Ϣ
												local tMsgAut = {}
												tMsgAut.chatType = hVar.CHAT_TYPE.PRIVATE
												tMsgAut.msgType = hVar.MESSAGE_TYPE.PRIVATE_INVITE --˽�ĺ�����֤��Ϣ
												tMsgAut.uid = tMsgMe.uid
												tMsgAut.name = tMsgMe.name
												tMsgAut.channelId = tMsgMe.channelId
												tMsgAut.vip = tMsgMe.vip
												tMsgAut.borderId = tMsgMe.borderId
												tMsgAut.iconId = tMsgMe.iconId
												tMsgAut.championId = tMsgMe.championId
												tMsgAut.leaderId = tMsgMe.leaderId
												tMsgAut.dragonId = tMsgMe.dragonId
												tMsgAut.headId = tMsgMe.headId
												tMsgAut.lineId = tMsgMe.lineId
												tMsgAut.content = string.format(hVar.tab_string["__TEXT_CHAT_PRIVATE_INVITE"], tMsgMe.name, tMsgFriend.name)
												tMsgAut.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
												tMsgAut.touid = tMsgFriend.uid
												tMsgAut.result = 0
												tMsgAut.resultParam = 0
												
												--������һ��˽�ĺ�����֤��Ϣ
												local chat = hGlobal.chatMgr:AddPrivateMessage(tMsgAut)
												
												--�洢��������Ϣ
												--��Ϣ��������˽�����ޣ�ɾ����һ����Ϣ
												local ret = self:_AddPrivateInviteMessage(chat)
												
												--��Ǻ���״̬Ϊ������
												tFriend.inviteflag = hVar.PRIVATE_INVITE_TYPE.NONE
												
												--������������Ϣ
												local sCmd = chat:ToCmd()
												hApi.xlNet_Send(self._uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
												
												--֪ͨ�Է�: ������������Ϣ
												if (online == 1) then
													local sCmd = chat:ToCmd()
													hApi.xlNet_Send(tMsgFriend.uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
												end
												
												--�Է�Ҳ����ҵ�״̬Ϊ������
												if tFriendMe then
													--�Է����ظ�����
													if (tFriendMe.inviteflag ~= hVar.PRIVATE_INVITE_TYPE.NONE) then
														tFriendMe.inviteflag = hVar.PRIVATE_INVITE_TYPE.NONE
														--print("bRequireDBUpdateMe 2")
													end
												end
												
												--�����Ҫ�������ݿ�
												bRequireDBUpdate = true --��Ҫ�������ݿ�
												--print("bRequireDBUpdate 1")
											else
												--�Ѵ��ڵĺ���
												--����Ҫ����λ��
											end
											
											--[[
											--���Է���Ϣ�Ƿ���Ҫ����
											if (tFriend.toname ~= tMsgFriend.name) or (tFriend.tochannelId ~= tMsgFriend.channelId) or (tFriend.tovip ~= tMsgFriend.vip)
												or (tFriend.toborderId ~= tMsgFriend.borderId) or (tFriend.toiconId ~= tMsgFriend.iconId)
												or (tFriend.tochampionId ~= tMsgFriend.championId) or (tFriend.toleaderId ~= tMsgFriend.leaderId)
												or (tFriend.todragonId ~= tMsgFriend.dragonId) or (tFriend.toheadId ~= tMsgFriend.headId)
												or (tFriend.tolineId ~= tMsgFriend.lineId) then
												bRequireDBUpdate = true --��Ҫ�������ݿ�
												print("bRequireDBUpdate 2")
												
												--�����ڴ�����
												--tFriend.touid = touid --����uid
												--tFriend.inviteflag = inviteflag --���Ѻ����Ƿ�ͨ������
												tFriend.toname = tMsgFriend.name --����name
												tFriend.tochannelId = tMsgFriend.channelId --����channelId
												tFriend.tovip = tMsgFriend.vip --����vip
												tFriend.toborderId = tMsgFriend.borderId --����borderId
												tFriend.toiconId = tMsgFriend.iconId --����iconId
												tFriend.tochampionId = tMsgFriend.championId --����championId
												tFriend.toleaderId = tMsgFriend.leaderId --����leaderId
												tFriend.todragonId = tMsgFriend.dragonId --����dragonId
												tFriend.toheadId = tMsgFriend.headId --����headId
												tFriend.tolineId = tMsgFriend.lineId --lineId
												--tFriend.chatList = chatList --�����¼
											end
											]]
											
											--������һ����������Ƿ�Ϊ�Է�
											if (self.msg_private_friend_last_uid ~= tMsgFriend.uid) then
												bRequireDBUpdate = true --��Ҫ�������ݿ�
												--print("bRequireDBUpdate 3")
												
												self.msg_private_friend_last_uid = tMsgFriend.uid
											end
											
											--�������ݿ�
											if bRequireDBUpdate then
												local strFriendInfo = self:_PrivateFriendInfoToDBCmd()
												local sUpdateCU = string.format("update `t_chat_user` set `msg_private_friend_count` = %d, `msg_private_friend_list` = '%s', `msg_private_friend_last_uid` = %d where `uid` = %d", self.msg_private_friend_count, strFriendInfo, tMsgFriend.uid, self._uid)
												xlDb_Execute(sUpdateCU)
												--print("sUpdateCU")
											end
											
											--�Է�Ҳ��Ӻ��ҵĺ��ѹ�ϵ
											--
											--local bRequireDBUpdateMe = false --�Է��Ƿ���Ҫ�������ݿ�
											
											--�¼ӵ���
											if (tFriendMe == nil) then
												--�����¼����
												local chatListMe = {}
												for i = 1, #tFriend.chatList, 1 do
													chatListMe[#chatListMe+1] = tFriend.chatList[i]
												end
												
												tFriendMe =
												{
													touid = tMsgMe.uid, --����uid
													inviteflag = 0, --���Ѻ����Ƿ�ͨ������
													toname = tMsgMe.name, --����name
													tochannelId = tMsgMe.channelId, --����channelId
													tovip = tMsgMe.vip, --����vip
													toborderId = tMsgMe.borderId, --����borderId
													toiconId = tMsgMe.iconId, --����iconId
													tochampionId = tMsgMe.championId, --����championId
													toleaderId = tMsgMe.leaderId, --����leaderId
													todragonId = tMsgMe.dragonId, --����dragonId
													toheadId = tMsgMe.headId, --����headId
													tolineId = tMsgMe.lineId, --lineId
													chatList = chatListMe, --�����¼
												}
												
												--�����1λ
												table.insert(friendUser.msg_private_friend_chat_list, 1, tFriendMe)
												friendUser.msg_private_friend_count = friendUser.msg_private_friend_count + 1
												
												bRequireDBUpdateMe = true --��Ҫ�������ݿ�
												--print("bRequireDBUpdateMe 1")
											else
												--�Ѵ��ڵ���
												--����Ҫ����λ��
											end
											
											--[[
											--���Է��������Ϣ�Ƿ���Ҫ����
											if (tFriendMe.toname ~= tMsgMe.name) or (tFriendMe.tochannelId ~= tMsgMe.channelId) or (tFriendMe.tovip ~= tMsgMe.vip)
												or (tFriendMe.toborderId ~= tMsgMe.borderId) or (tFriendMe.toiconId ~= tMsgMe.iconId)
												or (tFriendMe.tochampionId ~= tMsgMe.championId) or (tFriendMe.toleaderId ~= tMsgMe.leaderId)
												or (tFriendMe.todragonId ~= tMsgMe.dragonId) or (tFriendMe.toheadId ~= tMsgMe.headId)
												or (tFriendMe.tolineId ~= tMsgMe.lineId) then
												bRequireDBUpdateMe = true --��Ҫ�������ݿ�
												print("bRequireDBUpdateMe 2")
												
												--�����ڴ�����
												--tFriendMe.touid = touid --����uid
												--tFriendMe.inviteflag = inviteflag --���Ѻ����Ƿ�ͨ������
												tFriendMe.toname = tMsgMe.name --����name
												tFriendMe.tochannelId = tMsgMe.channelId --����channelId
												tFriendMe.tovip = tMsgMe.vip --����vip
												tFriendMe.toborderId = tMsgMe.borderId --����borderId
												tFriendMe.toiconId = tMsgMe.iconId --����iconId
												tFriendMe.tochampionId = tMsgMe.championId --����championId
												tFriendMe.toleaderId = tMsgMe.leaderId --����leaderId
												tFriendMe.todragonId = tMsgMe.dragonId --����dragonId
												tFriendMe.toheadId = tMsgMe.headId --����headId
												tFriendMe.tolineId = tMsgMe.lineId --����lineId
												--tFriendMe.chatList = chatList --�����¼
											end
											]]
											
											--���º������ݿ�
											if bRequireDBUpdateMe then
												local strFriendInfoMe = friendUser:_PrivateFriendInfoToDBCmd()
												local sUpdateCUFriend = string.format("update `t_chat_user` set `msg_private_friend_count` = %d, `msg_private_friend_list` = '%s' where `uid` = %d", friendUser.msg_private_friend_count, strFriendInfoMe, friendUser._uid)
												xlDb_Execute(sUpdateCUFriend)
												--print("sUpdateCUFriend")
											end
											
											--�����ɹ�
											ret = 1
										else
											--�������������洦��
											--
										end
									else
										--����������˽�ĸ���ҵĴ����ﵽ����
										ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_MAXCOUNT
									end
								else
									--����˽�������Ѵ����ޣ��޷�����˽��
									ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_USER_NUMMAX
								end
							--else
							--	--�Է������ߣ��޷�����˽��
							--	ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_USER_OFFLINE
							--end
						else
							--��Ч�����
							ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
						end
					else
						--���������޷�����˽��
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PRIVATE_FOBIDDEN
					end
				else
					--���ܺ��Լ�˽��
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_USER_SAMEME
				end
			else
				--��Ч�����
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
			end
		else
			--���δ��ʼ��
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_USER_INIT
		end
		
		return ret
	end
	
	--˽�����봦�����
	--����ֵ: �������
	function User:PrivateInviteOperation(msgId, touid, inviteTag)
		--�������
		local ret = 0
		
		--print("PrivateInviteOperation", msgId, touid, inviteTag)
		
		if (self.msg_init_state == 1) then
			--��Ч�����uid
			if (touid > 0) then
				--��Ч�Ĳ����������
				if (inviteTag == hVar.PRIVATE_INVITE_TYPE.ACCEPT) or (inviteTag == hVar.PRIVATE_INVITE_TYPE.REFUSE) then
					--��������Լ�Ϊ����
					if (touid ~= self._uid) then
						--�����Ƿ�����
						local online = 1
						local friendUser = hGlobal.uMgr:FindChatUserByDBID(touid)
						if (friendUser == nil) then
							--����һ����ʱ��user���󣬽����ڴ���˽�ĵ�����
							friendUser = hClass.User:CreateUserPrivateObject(touid)
							--print("����һ����ʱ��˽���������user����", touid)
							online = 0
						end
						
						--���˺����Ƿ����ҵ�˽���б���
						--local touid = tMsgFriend.uid
						local tFriend = nil
						local tFriendIdx = 0
						for i = 1, self.msg_private_friend_count, 1 do
							local tFriend_i = self.msg_private_friend_chat_list[i]
							local friendUid = tFriend_i.touid --����uid
							if (touid == friendUid) then
								tFriend = tFriend_i --�ҵ���
								tFriendIdx = i
								break
							end
						end
						
						--������Ϣ����Ч��
						local tChat = nil
						local tChatIdx = 0
						local chatList = tFriend.chatList --�����¼
						for i = #chatList, 1, -1 do
							if (chatList[i]._id == msgId) then --�ҵ���
								tChat = chatList[i]
								tChatIdx = i
								break
							end
						end
						
						--��ϢƵ��Ϊ˽�ģ�������Ϣ����Ϊ˽����֤��
						if tChat and (tChat._chatType == hVar.CHAT_TYPE.PRIVATE) and (tChat._msgType == hVar.MESSAGE_TYPE.PRIVATE_INVITE) then
							--�����ҵ�˽���б����ܽ��в���
							if tFriend then
								--������Ƿ��ڶԷ��ĺ����б���
								local tFriendMe = nil
								local tFriendIdxMe = 0
								if friendUser then
									for i = 1, friendUser.msg_private_friend_count, 1 do
										local tFriendMe_i = friendUser.msg_private_friend_chat_list[i]
										local touid_me_i = tFriendMe_i.touid --����uid
										--print(i, "touid_me_i=", touid_me_i, self._uid)
										if (self._uid == touid_me_i) then
											tFriendMe = tFriendMe_i --�ҵ���
											tFriendIdxMe = i
											break
										end
									end
								end
								--�Է��ĺ�����Ҳ����
								if tFriendMe then
									--ͨ����ܾ�������֤
									if (inviteTag == hVar.PRIVATE_INVITE_TYPE.ACCEPT) then --����
										tFriend.inviteflag = hVar.PRIVATE_INVITE_TYPE.ACCEPT
									elseif (inviteTag == hVar.PRIVATE_INVITE_TYPE.REFUSE) then --�ܾ�
										tFriend.inviteflag = hVar.PRIVATE_INVITE_TYPE.REFUSE
									end
									
									--��Ϊ�����²��������Դ˺����ŵ�һλ
									if (tFriendIdx > 1) then
										table.remove(self.msg_private_friend_chat_list, tFriendIdx)
										table.insert(self.msg_private_friend_chat_list, 1, tFriend)
									end
									
									--ɾ��������Ϣ
									table.remove(tFriend.chatList, tChatIdx)
									hGlobal.chatMgr:RemovePrivateMessage(msgId, inviteTag)
									
									--֪ͨ�Լ�: ɾ�����������Ϣ
									local sCmd = tostring(msgId)
									hApi.xlNet_Send(self._uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
									
									--���һ����Ϣ
									local newMsgType = 0
									local newOpStr = ""
									if (inviteTag == hVar.PRIVATE_INVITE_TYPE.ACCEPT) then --����
										newMsgType = hVar.MESSAGE_TYPE.PRIVATE_INVITE_ACCEPT
										newOpStr = hVar.tab_string["__TEXT_ACCEPT"]
									elseif (inviteTag == hVar.PRIVATE_INVITE_TYPE.REFUSE) then --�ܾ�
										newMsgType = hVar.MESSAGE_TYPE.PRIVATE_INVITE_REFUSE
										newOpStr = hVar.tab_string["__TEXT_REFUSE"]
									end
									local tMsgAut = {}
									tMsgAut.chatType = hVar.CHAT_TYPE.PRIVATE
									tMsgAut.msgType = newMsgType --˽�ĺ�����֤���
									tMsgAut.uid = tFriendMe.touid
									tMsgAut.name = tFriendMe.toname --hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"ϵͳ"
									tMsgAut.channelId = tFriendMe.tochannelId
									tMsgAut.vip = tFriendMe.tovip
									tMsgAut.borderId = tFriendMe.toborderId
									tMsgAut.iconId = tFriendMe.toiconId
									tMsgAut.championId = tFriendMe.tochampionId
									tMsgAut.leaderId = tFriendMe.toleaderId
									tMsgAut.dragonId = tFriendMe.todragonId
									tMsgAut.headId = tFriendMe.toheadId
									tMsgAut.lineId = tFriendMe.tolineId
									tMsgAut.content = string.format(hVar.tab_string["__TEXT_CHAT_PRIVATE_INVITE_OP"], tFriendMe.toname, newOpStr, tFriend.toname)
									tMsgAut.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
									tMsgAut.touid = tFriend.touid
									tMsgAut.result = inviteTag
									tMsgAut.resultParam = 0
									
									--�����������Ϣ
									--local chatAut = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
									local chat = hGlobal.chatMgr:AddPrivateMessage(tMsgAut)
									
									--�洢��������Ϣ
									tFriend.chatList[#tFriend.chatList+1] = chat
									
									--֪ͨ�Լ�: ������������Ϣ
									local sCmd = chat:ToCmd()
									--print("sCmd=", sCmd)
									hApi.xlNet_Send(self._uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
									--print("_uid=", self._uid)
									
									--�������ݿ�
									local strFriendInfo = self:_PrivateFriendInfoToDBCmd()
									local sUpdateCU = string.format("update `t_chat_user` set `msg_private_friend_list` = '%s' where `uid` = %d", strFriendInfo, self._uid)
									xlDb_Execute(sUpdateCU)
									--print("sUpdateCU")
									
									--�Է�Ҳɾ��������Ϣ
									local tChatMe = nil
									local tChatIdxMe = 0
									local chatListMe = tFriendMe.chatList --�����¼
									for i = #chatListMe, 1, -1 do
										if (chatListMe[i]._id == msgId) then --�ҵ���
											tChatMe = chatListMe[i]
											tChatIdxMe = i
											break
										end
									end
									if (tChatIdxMe > 0) then
										table.remove(tFriendMe.chatList, tChatIdxMe)
									end
									--hGlobal.chatMgr:RemovePrivateMessage(msgId, inviteTag)
									
									--֪ͨ�Է�: ɾ�����������Ϣ
									if (online == 1) then
										local sCmd = tostring(msgId)
										hApi.xlNet_Send(touid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
									end
									
									--֪ͨ�Է�: ������������Ϣ
									if (online == 1) then
										local sCmd = chat:ToCmd()
										hApi.xlNet_Send(touid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
									end
									
									--�Է�Ҳͨ���򱻾ܾ�������֤
									--ͨ����ܾ�������֤
									if (inviteTag == hVar.PRIVATE_INVITE_TYPE.ACCEPT) then --����
										tFriendMe.inviteflag = hVar.PRIVATE_INVITE_TYPE.ACCEPT
									elseif (inviteTag == hVar.PRIVATE_INVITE_TYPE.REFUSE) then --���ܾ�
										tFriendMe.inviteflag = hVar.PRIVATE_INVITE_TYPE.REFUSEBY
									end
									
									--�Է�Ҳ�洢��������Ϣ
									tFriendMe.chatList[#tFriendMe.chatList+1] = chat
									
									--��Ϊ�����²��������������ڴ˺����ŵ�һλ
									if (tFriendIdxMe > 1) then
										table.remove(friendUser.msg_private_friend_chat_list, tFriendIdxMe)
										table.insert(friendUser.msg_private_friend_chat_list, 1, tFriendMe)
									end
									
									--���º������ݿ�
									local strFriendInfoMe = friendUser:_PrivateFriendInfoToDBCmd()
									local sUpdateCUFriend = string.format("update `t_chat_user` set `msg_private_friend_list` = '%s' where `uid` = %d", strFriendInfoMe, friendUser._uid)
									xlDb_Execute(sUpdateCUFriend)
									--print("sUpdateCUFriend")
									
									--�����ɹ�
									ret = 1
								else
									--�Է��ѹرպ����˽��
									ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REMOVE
								end
							else
								--�Է���������˽���б���
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_FRIEND
							end
						else
							--��Ч����Ϣ
							ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_MSGID
						end
					else
						--���ܺ��Լ�˽��
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_USER_SAMEME
					end
				else
					--�������Ϸ�
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
				end
			else
				--��Ч�����
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
			end
		else
			--���δ��ʼ��
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_USER_INIT
		end
		
		return ret
	end
	
	--ɾ��˽�ĺ���
	--����ֵ: �������
	function User:PrivateDeleteFriend(touid)
		
		--�������
		local ret = 0
		
		--print("PrivateDeleteFriend", touid)
		
		if (self.msg_init_state == 1) then
			--��Ч�����uid
			if (touid > 0) then
				--�����Ƿ�����
				local online = 1
				local friendUser = hGlobal.uMgr:FindChatUserByDBID(touid)
				if (friendUser == nil) then
					--����һ����ʱ��user���󣬽����ڴ���˽�ĵ�����
					friendUser = hClass.User:CreateUserPrivateObject(touid)
					--print("����һ����ʱ��˽���������user����", touid)
					online = 0
				end
				
				--���˺����Ƿ����ҵ�˽���б���
				--local touid = tMsgFriend.uid
				local tFriend = nil
				local tFriendIdx = 0
				for i = 1, self.msg_private_friend_count, 1 do
					local tFriend_i = self.msg_private_friend_chat_list[i]
					local friendUid = tFriend_i.touid --����uid
					if (touid == friendUid) then
						tFriend = tFriend_i --�ҵ���
						tFriendIdx = i
						break
					end
				end
				
				--�����ҵ�˽���б����ܽ��в���
				if tFriend then
					--������Ƿ��ڶԷ��ĺ����б���
					local tFriendMe = nil
					local tFriendIdxMe = 0
					if friendUser then
						for i = 1, friendUser.msg_private_friend_count, 1 do
							local tFriendMe_i = friendUser.msg_private_friend_chat_list[i]
							local touid_me_i = tFriendMe_i.touid --����uid
							--print(i, "touid_me_i=", touid_me_i, self._uid)
							if (self._uid == touid_me_i) then
								tFriendMe = tFriendMe_i --�ҵ���
								tFriendIdxMe = i
								break
							end
						end
					end
					
					--�����ɾ��
					tFriend.inviteflag = hVar.PRIVATE_INVITE_TYPE.DELETE
					
					--ɾ���˺���
					table.remove(self.msg_private_friend_chat_list, tFriendIdx)
					
					--����������1
					self.msg_private_friend_count = self.msg_private_friend_count - 1
					
					--������ǵ���ʷ�����¼���Ƿ�����֤����Ϣ��ɾ�������͵���Ϣ
					local chatListNum = #tFriend.chatList
					for i = chatListNum, 1, -1 do
						local chat_i = tFriend.chatList[i]
						--print(i, chat_i._msgType)
						if (chat_i._msgType == hVar.MESSAGE_TYPE.PRIVATE_INVITE) then
							--ɾ����Ϣ
							local op_uid = hVar.PRIVATE_INVITE_TYPE.DELETE --������uid
							--print(chat_i:GetID(), op_uid)
							hGlobal.chatMgr:RemovePrivateMessage(chat_i:GetID(), op_uid)
							
							--���ҵ������б����Ƴ�
							table.remove(tFriend.chatList, i)
						end
					end
					
					--�������ݿ�
					local strFriendInfo = self:_PrivateFriendInfoToDBCmd()
					local sUpdateCU = string.format("update `t_chat_user` set `msg_private_friend_count` = %d, `msg_private_friend_list` = '%s' where `uid` = %d", self.msg_private_friend_count, strFriendInfo, self._uid)
					xlDb_Execute(sUpdateCU)
					--print("sUpdateCU")
					
					--����Է������б������ң���ô���Է�����һ����Ϣ
					if tFriendMe then
						--���һ����Ϣ
						local tMsgAut = {}
						tMsgAut.chatType = hVar.CHAT_TYPE.PRIVATE
						tMsgAut.msgType = hVar.MESSAGE_TYPE.PRIVATE_DELETE --ɾ��˽�ĺ���
						tMsgAut.uid = tFriendMe.touid
						tMsgAut.name = tFriendMe.toname --hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"ϵͳ"
						tMsgAut.channelId = tFriendMe.tochannelId
						tMsgAut.vip = tFriendMe.tovip
						tMsgAut.borderId = tFriendMe.toborderId
						tMsgAut.iconId = tFriendMe.toiconId
						tMsgAut.championId = tFriendMe.tochampionId
						tMsgAut.leaderId = tFriendMe.toleaderId
						tMsgAut.dragonId = tFriendMe.todragonId
						tMsgAut.headId = tFriendMe.toheadId
						tMsgAut.lineId = tFriendMe.tolineId
						tMsgAut.content = string.format(hVar.tab_string["__TEXT_CHAT_PRIVATE_DELETE"], tFriendMe.toname, tFriend.toname)
						tMsgAut.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
						tMsgAut.touid = tFriend.touid
						tMsgAut.result = hVar.PRIVATE_INVITE_TYPE.DELETE
						tMsgAut.resultParam = 0
						
						--print(tMsgAut.chatType)
						--print(tMsgAut.msgType)
						--print(tMsgAut.uid)
						--print(tMsgAut.name)
						--print(tMsgAut.channelId)
						--print(tMsgAut.vip)
						--print(tMsgAut.borderId)
						--print(tMsgAut.iconId)
						--print(tMsgAut.championId)
						--print(tMsgAut.leaderId)
						--print(tMsgAut.dragonId)
						--print(tMsgAut.headId)
						--print(tMsgAut.lineId)
						--print(tMsgAut.content)
						--print(tMsgAut.date)
						--print(tMsgAut.touid)
						--print(tMsgAut.result)
						--print(tMsgAut.resultParam)
						
						--�����������Ϣ
						--local chatAut = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
						local chat = hGlobal.chatMgr:AddPrivateMessage(tMsgAut)
						
						--�洢������Ϣ
						--Ҫɾ�����ѣ����������
						
						--�Է�Ҳ֪ͨɾ������
						--֪ͨ�Է�: ���һ��˽����Ϣ
						if (online == 1) then
							local sCmd = chat:ToCmd()
							hApi.xlNet_Send(touid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
						end
						
						--�Է���Ǳ���ɾ��
						tFriendMe.inviteflag = hVar.PRIVATE_INVITE_TYPE.DELETEBY
						
						--�Է�Ҳ�洢��������Ϣ
						tFriendMe.chatList[#tFriendMe.chatList+1] = chat
						
						--������ǵ���ʷ�����¼���Ƿ�����֤����Ϣ��ɾ�������͵���Ϣ
						local chatListNum = #tFriendMe.chatList
						for i = chatListNum, 1, -1 do
							local chat_i = tFriendMe.chatList[i]
							--print(i, chat_i._msgType, hVar.MESSAGE_TYPE.PRIVATE_INVITE)
							if (chat_i._msgType == hVar.MESSAGE_TYPE.PRIVATE_INVITE) then
								--ɾ����Ϣ
								--local op_uid = hVar.MESSAGE_TYPE.PRIVATE_DELETE --������uid
								--hGlobal.chatMgr:RemovePrivateMessage(chat_i:GetID(), op_uid)
								
								--�ӶԷ��������б����Ƴ�
								table.remove(tFriendMe.chatList, i)
								--print("�ӶԷ��������б����Ƴ�", chat_i:GetID(), chat._touid)
								
								--֪ͨ����: ɾ�������֤��������Ϣ
								local sCmd = tostring(chat_i:GetID())
								hApi.xlNet_Send(chat._touid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
							end
						end
						
						--�Է���Ϣ��������˽�����ޣ�ɾ����һ����Ϣ
						if (#tFriendMe.chatList > hVar.CHAT_MAX_LENGTH_PRIVATE) then
							--�Ƴ���Ϣ
							local msgId = tFriendMe.chatList[1]:GetID()
							table.remove(tFriendMe.chatList, 1)
							
							--֪ͨ����: ɾ�����������Ϣ
							local sCmd = tostring(msgId)
							hApi.xlNet_Send(chat._touid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
						end
						
						--���º������ݿ�
						local strFriendInfoMe = friendUser:_PrivateFriendInfoToDBCmd()
						local sUpdateCUFriend = string.format("update `t_chat_user` set `msg_private_friend_list` = '%s' where `uid` = %d", strFriendInfoMe, friendUser._uid)
						xlDb_Execute(sUpdateCUFriend)
						--print("sUpdateCUFriend")
					end
					
					--�����ɹ�
					ret = 1
				else
					--�Է���������˽���б���
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_FRIEND
				end
			else
				--��Ч�����
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
			end
		else
			--���δ��ʼ��
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_USER_INIT
		end
		
		return ret
	end
	
	--ɾ��˽����Ϣ
	function User:PrivateDeleteMsg(msgId)
		--�������
		local ret = 0
		
		--print("PrivateDeleteMsg", msgId)
		
		if (self.msg_init_state == 1) then
			for i = 1, self.msg_private_friend_count, 1 do
				local tFriend_i = self.msg_private_friend_chat_list[i]
				local chatList = tFriend_i.chatList --��ú��ѵ������б�
				--���β���id
				for j = 1, #chatList, 1 do
					local chat = chatList[j]
					if (chat:GetID() == msgId) then --�ҵ���
						--ɾ��������Ϣ
						table.remove(chatList, j)
						
						--�����ݿ��Ƴ�������Ϣ
						--local sDelete = string.format("delete from `chat` where `id` = %d", msgId)
						local sDelete = string.format("update `chat` set `deleteflag` = 1, `delete_op_uid` = %d where `id` = %d", self:GetUID(), msgId)
						xlDb_Execute(sDelete)
						
						--�����ɹ�
						ret = 1
						
						break
					end
				end
			end
		end
		
		return ret
	end
	
	--������������Ϣתcmd
	function User:ChatBaseInfoToCmd()
		local version = hGlobal.chatMgr:GetVersion() --�����ʽ�汾��
		local debug_version = hGlobal.chatMgr:GetDebugVersion() --��ò���Ա�汾��
		local world_flag = hGlobal.chatMgr:GetWorldFlag() --����������쿪��״̬
		local last_world_msgid = hGlobal.chatMgr:GetLastWorldMsgId() --���һ��������Ϣid
		local last_group_msgid = hGlobal.chatMgr:GetLastGroupMsgId(self._uid) --���һ��������Ϣid
		local sWorldTime = os.date("%Y-%m-%d %H:%M:%S", self.msg_world_timestamp)
		local sForbiddenTime = os.date("%Y-%m-%d %H:%M:%S", self.forbidden_timestamp)
		local sSendRedPacketTime = os.date("%Y-%m-%d %H:%M:%S", self.group_send_packet_timestamp)
		local groupId = hGlobal.groupMgr:GetUserGroupID(self._uid) --������ڵĹ���id
		local groupLevel = hGlobal.groupMgr:GetUserGroupLevel(self._uid) --������ڵĹ���Ȩ��
		local sCmd = tostring(version) .. ";" .. tostring(debug_version) .. ";" .. tostring(world_flag) .. ";" .. tostring(self.msg_world_num)
						.. ";" .. tostring(sWorldTime) ..";" .. tostring(last_world_msgid) .. ";" .. tostring(last_group_msgid)
						.. ";" .. tostring(self.forbidden) .. ";" .. tostring(sForbiddenTime) .. ";" .. tostring(self.forbidden_minute)
						.. ";" .. tostring(self.forbidden_op_uid) .. ";" .. tostring(groupId) .. ";" .. tostring(groupLevel)
						.. ";"
		--��ȡȫ���������뺯��id
		local inviteGroupList = hGlobal.inviteGroupMgr:GetInviteGroupList()
		sCmd = sCmd .. tostring(#inviteGroupList) .. ";"
		for _, inviteGroup in ipairs(inviteGroupList) do
			local msg_id = inviteGroup._msg_id
			sCmd = sCmd .. tostring(msg_id) .. ";"
		end
		
		--��ȡȫ����Ӹ���������Ϣ
		local inviteBattleChatList = hGlobal.chatMgr._inviteBattleChatList
		sCmd = sCmd .. tostring(#inviteBattleChatList) .. ";"
		for _, chat in ipairs(inviteBattleChatList) do
			local msg_id = chat:GetID()
			--print(msg_id)
			sCmd = sCmd .. tostring(msg_id) .. ";"
		end
		
		--���˽����Ϣ
		sCmd = sCmd .. tostring(self.msg_private_friend_count) .. ";"
		for i = 1, self.msg_private_friend_count, 1 do
			local tFriend = self.msg_private_friend_chat_list[i]
			local touid = tFriend.touid --����uid
			local online = 0 --�����Ƿ�����
			local friendUser = hGlobal.uMgr:FindChatUserByDBID(touid)
			if friendUser then
				online = 1
			end
			local lastMsgId = 0 --����ҵ����һ����Ϣid
			if (#tFriend.chatList > 0) then
				lastMsgId = tFriend.chatList[#tFriend.chatList]:GetID()
			end
			local sCmdFriend = tostring(touid) .. ";" .. tostring(tFriend.inviteflag) .. ";" .. tostring(online)
							.. ";" .. tostring(tFriend.toname) .. ";" .. tostring(tFriend.tochannelId)
							.. ";" .. tostring(tFriend.tovip) .. ";" .. tostring(tFriend.toborderId)
							.. ";" .. tostring(tFriend.toiconId) .. ";" .. tostring(tFriend.tochampionId)
							.. ";" .. tostring(tFriend.toleaderId) .. ";" .. tostring(tFriend.todragonId)
							.. ";" .. tostring(tFriend.toheadId) .. ";" .. tostring(tFriend.tolineId)
							.. ";" .. tostring(lastMsgId) .. ";"
						
			sCmd = sCmd .. sCmdFriend
		end
		
		sCmd = sCmd .. tostring(self.msg_private_friend_last_uid) .. ";" .. tostring(self.group_send_packet_num)
					.. ";" .. tostring(sSendRedPacketTime) .. ";"
		--print(sCmd)
		return sCmd
	end
	
	--�����˽�ĺ��ѵ�����idתcmd
	function User:ChatFriendMsgIdToCmd(friendUid)
		local tFriend = nil
		--print("�����˽�ĺ��ѵ�����idתcmd", friendUid, "self.msg_private_friend_count=", self.msg_private_friend_count)
		for i = 1, self.msg_private_friend_count, 1 do
			local tFriend_i = self.msg_private_friend_chat_list[i]
			local touid = tFriend_i.touid --����uid
			--print(i, "touid=", touid)
			if (touid == friendUid) then
				tFriend = tFriend_i --�ҵ���
				break
			end
		end
		
		--��Ϣ������
		local NUM = 0
		local sCmd = ""
		local snum = 0 --��Ч����Ϣ����
		if tFriend then
			NUM = #tFriend.chatList
			--print(i, "NUM=", NUM)
		end
		
		--����ƴ��id
		for i = 1, NUM, 1 do
			local chat = tFriend.chatList[i]
			--print("chat", i)
			if (chat._chatType == hVar.CHAT_TYPE.PRIVATE) then --ֻ����˽��Ƶ��
				local tempStr = tostring(chat._id) .. ";"
				sCmd = sCmd .. tempStr
				snum = snum + 1
				--print("˽����Ϣ" .. i, chat._id)
			end
		end
		
		sCmd = tostring(snum) .. ";" .. sCmd
		--print("sCmd=", sCmd)
		
		return sCmd
	end
	
	--��ȫ��˽�ĺ�����Ϣת���ݿ�洢��cmd
	function User:_PrivateFriendInfoToDBCmd()
		--80067930|1||�����ɤ��|1|2|0|19|;21000002|С����С����2|0|100|7|1111111|2|;
		local sCmd = ""
		
		for i = 1, self.msg_private_friend_count, 1 do
			local tFriend = self.msg_private_friend_chat_list[i]
			local tempStr = tostring(tFriend.touid) .. "|" .. tostring(tFriend.inviteflag) .. "|" .. tostring(tFriend.toname)
							.. "|" .. tostring(tFriend.tochannelId) .. "|" .. tostring(tFriend.tovip)
							.. "|" .. tostring(tFriend.toborderId) .. "|" .. tostring(tFriend.toiconId)
							.. "|" .. tostring(tFriend.tochampionId) .. "|" .. tostring(tFriend.toleaderId)
							.. "|" .. tostring(tFriend.todragonId) .. "|" .. tostring(tFriend.toheadId)
							.. "|" .. tostring(tFriend.tolineId) .. "|"
			sCmd = sCmd .. tempStr .. ";\n"
		end
		
		return sCmd
	end
	
	--������˽�ĺ�����Ϣתcmd
	function User:SingleFriendInfoToCmd(friendUid)
		--80067930|1||�����ɤ��|1|2|0|19|;21000002|С����С����2|0|100|7|1111111|2|;
		local sCmd = ""
		local tFriend = nil
		--print("self.msg_private_friend_count=", self.msg_private_friend_count)
		for i = 1, self.msg_private_friend_count, 1 do
			local tFriend_i = self.msg_private_friend_chat_list[i]
			local touid = tFriend_i.touid --����uid
			--print(i, "touid=", touid)
			if (touid == friendUid) then
				tFriend = tFriend_i --�ҵ���
				break
			end
		end
		
		if tFriend then
			local online = 0 --�����Ƿ�����
			local friendUser = hGlobal.uMgr:FindChatUserByDBID(friendUid)
			if friendUser then
				online = 1
			end
			
			local lastMsgId = 0 --����ҵ����һ����Ϣid
			if (#tFriend.chatList > 0) then
				lastMsgId = tFriend.chatList[#tFriend.chatList]:GetID()
			end
			sCmd = tostring(friendUid) .. ";" .. tostring(tFriend.inviteflag) .. ";" .. tostring(online)
							.. ";" .. tostring(tFriend.toname) .. ";" .. tostring(tFriend.tochannelId)
							.. ";" .. tostring(tFriend.tovip) .. ";" .. tostring(tFriend.toborderId)
							.. ";" .. tostring(tFriend.toiconId) .. ";".. tostring(tFriend.tochampionId)
							.. ";" .. tostring(tFriend.toleaderId) .. ";" .. tostring(tFriend.todragonId)
							.. ";" .. tostring(tFriend.toheadId) .. ";" .. tostring(tFriend.tolineId)
							.. ";" .. tostring(lastMsgId) .. ";"
		end
		
		return sCmd
	end
	
return User




