--������Ϣ��
local Chat = class("Chat")
	
	--���캯��
	function Chat:ctor()
		self._id = -1 --��ϢΨһid
		self._chatType = -1 --��ϢƵ��
		self._msgType = -1 --��������Ϣ����
		self._uid = -1 --������uid
		self._name = "" --����������
		self._channelId = -1 --����������id
		self._vip = -1 --������vip�ȼ�
		self._borderId = -1 --�����߱߿�id
		self._iconId = -1 --������ͷ��id
		self._championId = -1 --�����߳ƺ�id
		self._leaderId = -1 --�����߻᳤id
		self._dragonId = -1 --��������������id
		self._headId = -1 --������ͷ��id
		self._lineId = -1 --����������id
		self._content = "" --��������
		self._date = -1 --����ʱ��(�ַ���)
		self._touid = -1 --������uid
		self._result = -1 --�ɽ������͵���Ϣ�Ĳ������
		self._resultParam = -1 --�ɽ������͵���Ϣ�Ĳ���
		self._redPacketParam = "" --�����Ϣ�Ĳ���
		
		return self
	end
	
	--��ʼ��
	function Chat:Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
		self._id = id --��ϢΨһid
		self._chatType = chatType --��ϢƵ��
		self._msgType = msgType --��������Ϣ����
		self._uid = uid --������uid
		self._name = name --����������
		self._channelId = channelId --����������id
		self._vip = vip --������vip�ȼ�
		self._borderId = borderId --�����߱߿�id
		self._iconId = iconId --������ͷ��id
		self._championId = championId --�����߳ƺ�id
		self._leaderId = leaderId --�����߻᳤id
		self._dragonId = dragonId --��������������id
		self._headId = headId --������ͷ��id
		self._lineId = lineId --����������id
		self._content = content --��������
		self._date = date --����ʱ��(�ַ���)
		self._touid = touid --������uid
		self._result = result --�ɽ������͵���Ϣ�Ĳ������
		self._resultParam = resultParam --�ɽ������͵���Ϣ�Ĳ���
		self._redPacketParam = "" --�����Ϣ�Ĳ���
		
		return self
	end
	
	--�����ϢΨһid
	function Chat:GetID()
		return self._id
	end
	
	--release
	function Chat:Release()
		self._id = -1 --��ϢΨһid
		self._chatType = chatType --��ϢƵ��
		self._msgType = -1 --��������Ϣ����
		self._uid = -1 --������uid
		self._name = "" --����������
		self._channelId = -1 --����������id
		self._vip = -1 --������vip�ȼ�
		self._borderId = -1 --�����߱߿�id
		self._iconId = -1 --������ͷ��id
		self._championId = -1 --�����߳ƺ�id
		self._leaderId = -1 --�����߻᳤id
		self._dragonId = -1 --��������������id
		self._headId = -1 --������ͷ��id
		self._lineId = -1 --����������id
		self._content = "" --��������
		self._date = -1 --����ʱ��(�ַ���)
		self._touid = -1 --������uid
		self._result = -1 --�ɽ������͵���Ϣ�Ĳ������
		self._resultParam = -1 --�ɽ������͵���Ϣ�Ĳ���
		self._redPacketParam = "" --�����Ϣ�Ĳ���
		
		return self
	end
	
	--תcmd
	function Chat:ToCmd()
		if (self._msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) then --���ŷ����
			local redPacketId = self._resultParam --���id
			local redPacketGroup = hGlobal.redPacketGroupMgr:GetRedPacket(redPacketId)
			--print(redPacketId, redPacketGroup)
			if redPacketGroup then
				--���ź����Ϣ
				local strRedPacketInfo = redPacketGroup:ToCmd()
				--print(strRedPacketInfo)
				
				--���ź��������Ϣ
				local tReceive = hGlobal.redPacketGroupMgr:GetRedPacketReceive(redPacketId)
				local strRedPacketReceiveInfo = ""
				for receive_uid, receiveInfo in pairs(tReceive) do
					strRedPacketReceiveInfo = strRedPacketReceiveInfo .. tostring(receive_uid) .. "_"
				end
				strRedPacketReceiveInfo = strRedPacketReceiveInfo .. "|"
				
				--���ź����Ϣ�Ĳ���
				self._redPacketParam = strRedPacketInfo .. strRedPacketReceiveInfo
			else
				self._redPacketParam = "" --�����Ϣ�Ĳ���
			end
		elseif (self._msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --��֧�������������
			local redPacketId = self._resultParam --���id
			local redPacketPay = hGlobal.redPacketPayMgr:GetRedPacket(redPacketId)
			--print(redPacketId, redPacketPay)
			if redPacketPay then
				--֧���������������Ϣ
				local strRedPacketInfo = redPacketPay:ToCmd()
				--print(strRedPacketInfo)
				
				--֧�������������������Ϣ
				local tReceive = hGlobal.redPacketPayMgr:GetRedPacketReceive(redPacketId)
				local strRedPacketReceiveInfo = ""
				for receive_uid, receiveInfo in pairs(tReceive) do
					strRedPacketReceiveInfo = strRedPacketReceiveInfo .. tostring(receive_uid) .. "_"
				end
				strRedPacketReceiveInfo = strRedPacketReceiveInfo .. "|"
				
				--֧���������������Ϣ�Ĳ���
				self._redPacketParam = strRedPacketInfo .. strRedPacketReceiveInfo
			else
				self._redPacketParam = "" --�����Ϣ�Ĳ���
			end
		elseif (self._msgType == hVar.MESSAGE_TYPE.INVITE_GROUP) then --�������뺯��Ϣ
			local inviteGroupId = self._resultParam --�������뺯id
			local inviteGroup = hGlobal.inviteGroupMgr:GetInviteGroup(inviteGroupId)
			--print(inviteGroupId, inviteGroup)
			if inviteGroup then
				--�������뺯��Ϣ
				local strInviteGroupInfo = inviteGroup:ToCmd()
				--print(strInviteGroupInfo)
				
				--�������뺯��Ϣ�Ĳ���
				self._redPacketParam = strInviteGroupInfo
			else
				self._redPacketParam = "" --�����Ϣ�Ĳ���
			end
		else
			self._redPacketParam = "" --�����Ϣ�Ĳ���
		end
		
		local sCmd = tostring(self._id) .. ";" .. tostring(self._chatType) ..";" .. tostring(self._msgType) .. ";" .. tostring(self._uid)
						.. ";" .. tostring(self._name) .. ";" .. tostring(self._channelId) .. ";" .. tostring(self._vip)
						.. ";" .. tostring(self._borderId) .. ";" .. tostring(self._iconId) .. ";" .. tostring(self._championId)
						.. ";" .. tostring(self._leaderId) .. ";" .. tostring(self._dragonId) .. ";" .. tostring(self._headId)
						.. ";" .. tostring(self._lineId) .. ";" .. tostring(self._content) .. ";" .. tostring(self._date)
						.. ";" .. tostring(self._touid) .. ";" .. tostring(self._result) .. ";" .. tostring(self._resultParam)
						.. ";" .. tostring(self._redPacketParam) .. ";"
		
		return sCmd
	end
	
return Chat