--军团邀请函类
local InviteGroup = class("InviteGroup")
	
	--构造函数
	function InviteGroup:ctor()
		self._id = -1 --军团邀请函类唯一id
		self._groupId = -1 --军团id
		self._groupName = "" --军团名
		self._groupLevel = -1 --军团等级
		self._groupForce = -1 --军团阵营
		self._groupMember = -1 --军团当前人数
		self._groupMemberMax = -1 --军团总人数
		self._groupIntroduce = "" --军团介绍
		self._dayMin = -1 --需要的最小注册时间
		self._vipMin = -1 --需要的vip等级
		self._msg_id = msg_id --消息id
		self._create_time = "" --军团邀请函发起时间
		self._expire_time = "" --军团邀请函过期时间
		
		return self
	end
	
	--初始化
	function InviteGroup:Init(id, groupId, groupName, groupLevel, groupForce, groupMember, groupMemberMax, groupIntroduce, dayMin, vipMin, msg_id, create_time, expire_time)
		self._id = id --军团邀请函类唯一id
		self._groupId = groupId --军团id
		self._groupName = groupName --军团名
		self._groupLevel = groupLevel --军团等级
		self._groupForce = groupForce --军团阵营
		self._groupMember = groupMember --军团当前人数
		self._groupMemberMax = groupMemberMax --军团总人数
		self._groupIntroduce = groupIntroduce --军团介绍
		self._dayMin = dayMin --需要的最小注册时间
		self._vipMin = vipMin --需要的vip等级
		self._msg_id = msg_id --消息id
		self._create_time = create_time --军团邀请函发起时间
		self._expire_time = expire_time --军团邀请函过期时间
		
		return self
	end
	
	--获得军团邀请函唯一id
	function InviteGroup:GetID()
		return self._id
	end
	
	--release
	function InviteGroup:Release()
		self._id = -1 --军团邀请函类唯一id
		self._groupId = -1 --军团id
		self._groupName = "" --军团名
		self._groupLevel = -1 --军团等级
		self._groupForce = -1 --军团阵营
		self._groupMember = -1 --军团当前人数
		self._groupMemberMax = -1 --军团总人数
		self._groupIntroduce = "" --军团介绍
		self._dayMin = -1 --需要的最小注册时间
		self._vipMin = -1 --需要的vip等级
		self._msg_id = msg_id --消息id
		self._create_time = "" --军团邀请函发起时间
		self._expire_time = "" --军团邀请函过期时间
		
		return self
	end
	
	--转cmd
	function InviteGroup:ToCmd()
		local sCmd = tostring(self._id) .. "|" .. tostring(self._groupId) .."|" .. tostring(self._groupName)
						.. "|" .. tostring(self._groupLevel) .. "|" .. tostring(self._groupForce) .. "|" .. tostring(self._groupMember)
						.. "|" .. tostring(self._groupMemberMax) .. "|" .. tostring(self._groupIntroduce) .. "|" .. tostring(self._dayMin)
						.. "|" .. tostring(self._vipMin) .. "|" .. tostring(self._msg_id) .. "|" .. tostring(self._create_time)
						.. "|" .. tostring(self._expire_time) .. "|"
		
		return sCmd
	end
	
return InviteGroup