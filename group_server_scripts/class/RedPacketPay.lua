--支付（土豪）红包类
local RedPacketPay = class("RedPacketPay")
	
	--构造函数
	function RedPacketPay:ctor()
		self._id = -1 --支付（土豪）红包唯一id
		self._send_uid = -1 --支付（土豪）红包发送者uid
		self._send_name = "" --支付（土豪）红包发送者名字
		self._send_num = -1 --支付（土豪）红包发送数量
		self._content = "" --内容
		self._money = -1 --充值金额
		self._iap_id = -1 --充值记录id
		self._channelId = -1 --发送者渠道id
		self._vip = -1 --发送者vip等级
		self._borderId = -1 --发送者边框id
		self._iconId = -1 --发送者头像id
		self._championId = -1 --发送者称号id
		self._leaderId = -1 --发送者会长权限
		self._dragonId = -1 --发送者聊天龙王id
		self._headId = -1 --发送者头衔id
		self._lineId = -1 --发送者线索id
		self._msg_id = -1 --消息id
		self._receive_num = -1 --支付（土豪）红包接收数量
		self._send_time = "" --支付（土豪）红包发送时间
		self._expire_time = "" --支付（土豪）红包过期时间
		
		return self
	end
	
	--初始化
	function RedPacketPay:Init(id, send_uid, send_name, send_num, content, money, iap_id, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, msg_id, receive_num, send_time, expire_time)
		self._id = id --支付（土豪）红包唯一id
		self._send_uid = send_uid --支付（土豪）红包发送者uid
		self._send_name = send_name --支付（土豪）红包发送者名字
		self._send_num = send_num --支付（土豪）红包发送数量
		self._content = content --内容
		self._money = money --充值金额
		self._iap_id = iap_id --充值记录id
		self._channelId = channelId --发送者渠道id
		self._vip = vip --发送者vip等级
		self._borderId = borderId --发送者边框id
		self._iconId = iconId --发送者头像id
		self._championId = championId --发送者称号id
		self._leaderId = leaderId --发送者会长权限
		self._dragonId = dragonId --发送者聊天龙王id
		self._headId = headId --发送者头衔id
		self._lineId = lineId --发送者线索id
		self._msg_id = msg_id --消息id
		self._receive_num = receive_num --支付（土豪）红包接收数量
		self._send_time = send_time --支付（土豪）红包发送时间
		self._expire_time = expire_time --支付（土豪）红包过期时间
		
		return self
	end
	
	--获得支付（土豪）红包唯一id
	function RedPacketPay:GetID()
		return self._id
	end
	
	--release
	function RedPacketPay:Release()
		self._id = -1 --支付（土豪）红包唯一id
		self._send_uid = -1 --支付（土豪）红包发送者uid
		self._send_name = "" --支付（土豪）红包发送者名字
		self._send_num = -1 --支付（土豪）红包发送数量
		self._content = "" --内容
		self._money = -1 --充值金额
		self._iap_id = -1 --充值记录id
		self._channelId = -1 --发送者渠道id
		self._vip = -1 --发送者vip等级
		self._borderId = -1 --发送者边框id
		self._iconId = -1 --发送者头像id
		self._championId = -1 --发送者称号id
		self._leaderId = -1 --发送者会长权限
		self._dragonId = -1 --发送者聊天龙王id
		self._headId = -1 --发送者头衔id
		self._lineId = -1 --发送者线索id
		self._msg_id = -1 --消息id
		self._receive_num = -1 --支付（土豪）红包接收数量
		self._send_time = "" --支付（土豪）红包发送时间
		self._expire_time = "" --支付（土豪）红包过期时间
		
		return self
	end
	
	--转cmd
	function RedPacketPay:ToCmd()
		local sCmd = tostring(self._id) .. "|" .. tostring(self._send_uid) .."|" .. tostring(self._send_name)
						.. "|" .. tostring(self._send_num) .. "|" .. tostring(self._content) .. "|" .. tostring(self._money)
						.. "|" .. tostring(self._iap_id) .. "|" .. tostring(self._channelId) .. "|" .. tostring(self._vip)
						.. "|" .. tostring(self._borderId) .. "|" .. tostring(self._iconId) .. "|" .. tostring(self._championId)
						.. "|" .. tostring(self._leaderId) .. "|" .. tostring(self._dragonId) .. "|" .. tostring(self._headId)
						.. "|" .. tostring(self._lineId) .. "|" .. tostring(self._msg_id) .. "|" .. tostring(self._receive_num)
						.. "|" .. tostring(self._send_time) .. "|" .. tostring(self._expire_time) .. "|"
		
		return sCmd
	end
	
return RedPacketPay