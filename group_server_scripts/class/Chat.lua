--聊天消息类
local Chat = class("Chat")
	
	--构造函数
	function Chat:ctor()
		self._id = -1 --消息唯一id
		self._chatType = -1 --消息频道
		self._msgType = -1 --发送者消息类型
		self._uid = -1 --发送者uid
		self._name = "" --发送者名字
		self._channelId = -1 --发送者渠道id
		self._vip = -1 --发送者vip等级
		self._borderId = -1 --发送者边框id
		self._iconId = -1 --发送者头像id
		self._championId = -1 --发送者称号id
		self._leaderId = -1 --发送者会长id
		self._dragonId = -1 --发送者聊天龙王id
		self._headId = -1 --发送者头衔id
		self._lineId = -1 --发送者线索id
		self._content = "" --聊天内容
		self._date = -1 --聊天时间(字符串)
		self._touid = -1 --接收者uid
		self._result = -1 --可交互类型的消息的操作结果
		self._resultParam = -1 --可交互类型的消息的参数
		self._redPacketParam = "" --红包消息的参数
		
		return self
	end
	
	--初始化
	function Chat:Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
		self._id = id --消息唯一id
		self._chatType = chatType --消息频道
		self._msgType = msgType --发送者消息类型
		self._uid = uid --发送者uid
		self._name = name --发送者名字
		self._channelId = channelId --发送者渠道id
		self._vip = vip --发送者vip等级
		self._borderId = borderId --发送者边框id
		self._iconId = iconId --发送者头像id
		self._championId = championId --发送者称号id
		self._leaderId = leaderId --发送者会长id
		self._dragonId = dragonId --发送者聊天龙王id
		self._headId = headId --发送者头衔id
		self._lineId = lineId --发送者线索id
		self._content = content --聊天内容
		self._date = date --聊天时间(字符串)
		self._touid = touid --接收者uid
		self._result = result --可交互类型的消息的操作结果
		self._resultParam = resultParam --可交互类型的消息的参数
		self._redPacketParam = "" --红包消息的参数
		
		return self
	end
	
	--获得消息唯一id
	function Chat:GetID()
		return self._id
	end
	
	--release
	function Chat:Release()
		self._id = -1 --消息唯一id
		self._chatType = chatType --消息频道
		self._msgType = -1 --发送者消息类型
		self._uid = -1 --发送者uid
		self._name = "" --发送者名字
		self._channelId = -1 --发送者渠道id
		self._vip = -1 --发送者vip等级
		self._borderId = -1 --发送者边框id
		self._iconId = -1 --发送者头像id
		self._championId = -1 --发送者称号id
		self._leaderId = -1 --发送者会长id
		self._dragonId = -1 --发送者聊天龙王id
		self._headId = -1 --发送者头衔id
		self._lineId = -1 --发送者线索id
		self._content = "" --聊天内容
		self._date = -1 --聊天时间(字符串)
		self._touid = -1 --接收者uid
		self._result = -1 --可交互类型的消息的操作结果
		self._resultParam = -1 --可交互类型的消息的参数
		self._redPacketParam = "" --红包消息的参数
		
		return self
	end
	
	--转cmd
	function Chat:ToCmd()
		if (self._msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) then --军团发红包
			local redPacketId = self._resultParam --红包id
			local redPacketGroup = hGlobal.redPacketGroupMgr:GetRedPacket(redPacketId)
			--print(redPacketId, redPacketGroup)
			if redPacketGroup then
				--军团红包信息
				local strRedPacketInfo = redPacketGroup:ToCmd()
				--print(strRedPacketInfo)
				
				--军团红包接收信息
				local tReceive = hGlobal.redPacketGroupMgr:GetRedPacketReceive(redPacketId)
				local strRedPacketReceiveInfo = ""
				for receive_uid, receiveInfo in pairs(tReceive) do
					strRedPacketReceiveInfo = strRedPacketReceiveInfo .. tostring(receive_uid) .. "_"
				end
				strRedPacketReceiveInfo = strRedPacketReceiveInfo .. "|"
				
				--军团红包消息的参数
				self._redPacketParam = strRedPacketInfo .. strRedPacketReceiveInfo
			else
				self._redPacketParam = "" --红包消息的参数
			end
		elseif (self._msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --发支付（土豪）红包
			local redPacketId = self._resultParam --红包id
			local redPacketPay = hGlobal.redPacketPayMgr:GetRedPacket(redPacketId)
			--print(redPacketId, redPacketPay)
			if redPacketPay then
				--支付（土豪）红包信息
				local strRedPacketInfo = redPacketPay:ToCmd()
				--print(strRedPacketInfo)
				
				--支付（土豪）红包接收信息
				local tReceive = hGlobal.redPacketPayMgr:GetRedPacketReceive(redPacketId)
				local strRedPacketReceiveInfo = ""
				for receive_uid, receiveInfo in pairs(tReceive) do
					strRedPacketReceiveInfo = strRedPacketReceiveInfo .. tostring(receive_uid) .. "_"
				end
				strRedPacketReceiveInfo = strRedPacketReceiveInfo .. "|"
				
				--支付（土豪）红包消息的参数
				self._redPacketParam = strRedPacketInfo .. strRedPacketReceiveInfo
			else
				self._redPacketParam = "" --红包消息的参数
			end
		elseif (self._msgType == hVar.MESSAGE_TYPE.INVITE_GROUP) then --军团邀请函消息
			local inviteGroupId = self._resultParam --军团邀请函id
			local inviteGroup = hGlobal.inviteGroupMgr:GetInviteGroup(inviteGroupId)
			--print(inviteGroupId, inviteGroup)
			if inviteGroup then
				--军团邀请函信息
				local strInviteGroupInfo = inviteGroup:ToCmd()
				--print(strInviteGroupInfo)
				
				--军团邀请函消息的参数
				self._redPacketParam = strInviteGroupInfo
			else
				self._redPacketParam = "" --红包消息的参数
			end
		else
			self._redPacketParam = "" --红包消息的参数
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