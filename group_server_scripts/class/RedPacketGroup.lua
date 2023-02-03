--军团红包类
local RedPacketGroup = class("RedPacketGroup")
	
	--构造函数
	function RedPacketGroup:ctor()
		self._id = -1 --军团红包唯一id
		self._send_uid = -1 --军团红包发送者uid
		self._send_name = "" --军团红包发送者名字
		self._group_id = -1 --军团红包军团id
		self._send_num = -1 --军团红包发送数量
		self._content = "" --内容
		self._coin = -1 --游戏币
		self._order_id = -1 --订单号
		self._msg_id = -1 --消息id
		self._receive_num = -1 --军团红包接收数量
		self._send_time = "" --军团红包发送时间
		self._expire_time = "" --军团红包过期时间
		
		return self
	end
	
	--初始化
	function RedPacketGroup:Init(id, send_uid, send_name, group_id, send_num, content, coin, order_id, msg_id, receive_num, send_time, expire_time)
		self._id = id --军团红包唯一id
		self._send_uid = send_uid --军团红包发送者uid
		self._send_name = send_name --军团红包发送者名字
		self._group_id = group_id --军团红包军团id
		self._send_num = send_num --军团红包发送数量
		self._content = content --内容
		self._coin = coin --游戏币
		self._order_id = order_id --订单号
		self._msg_id = msg_id --消息id
		self._receive_num = receive_num --军团红包接收数量
		self._send_time = send_time --军团红包发送时间
		self._expire_time = expire_time --军团红包过期时间
		
		return self
	end
	
	--获得军团红包唯一id
	function RedPacketGroup:GetID()
		return self._id
	end
	
	--release
	function RedPacketGroup:Release()
		self._id = -1 --军团红包唯一id
		self._send_uid = -1 --军团红包发送者uid
		self._send_name = "" --军团红包发送者名字
		self._group_id = -1 --军团红包军团id
		self._send_num = -1 --军团红包发送数量
		self._content = "" --内容
		self._coin = -1 --游戏币
		self._order_id = -1 --订单号
		self._msg_id = -1 --消息id
		self._receive_num = -1 --军团红包接收数量
		self._send_time = "" --军团红包发送时间
		self._expire_time = "" --军团红包过期时间
		
		return self
	end
	
	--转cmd
	function RedPacketGroup:ToCmd()
		local sCmd = tostring(self._id) .. "|" .. tostring(self._send_uid) .."|" .. tostring(self._send_name)
						.. "|" .. tostring(self._group_id) .. "|" .. tostring(self._send_num) .. "|" .. tostring(self._content)
						.. "|" .. tostring(self._coin) .. "|" .. tostring(self._order_id) .. "|" .. tostring(self._msg_id)
						.. "|" .. tostring(self._receive_num) .. "|" .. tostring(self._send_time)
						.. "|" .. tostring(self._expire_time) .. "|"
		
		return sCmd
	end
	
return RedPacketGroup