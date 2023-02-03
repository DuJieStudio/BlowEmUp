--用户类
local User = class("User")
	
	--角色状态
	User.STATEINFO = 
	{
		UNINIT = -1,		--未初始化
		INIT = 1,			--初始化
	}
	
	-------------------------------------------------------------------------------------------------
	--构造函数
	function User:ctor()
		--初始化私有变量
		self._id = -1							--内存id
		self._uid = -1							--数据库id
		self._rid = -1							--当前使用的角色Id
		
		self._state = -1						--是否初始化
		self._bGetBaseInfo = false				--是否读取基础信息
		
		self._name = ""							--用户姓名
		
		--管理员标识
		self.bTester = -1						--管理员标记
		
		--聊天相关
		self.msg_init_state = -1				--聊天相关数据是否初始化(1:初始化)
		self.msg_world_num = -1					--上次世界聊天次数
		self.msg_total_num = -1					--上次全部聊天次数
		self.msg_world_timestamp = -1			--上次世界聊天的时间戳
		self.msg_total_timestamp = -1			--上次全部聊天的时间戳
		self.forbidden = -1						--是否被禁言
		self.forbidden_timestamp = -1			--被禁言的时间戳
		self.forbidden_minute = -1				--被禁言持续时间（单位:分钟）
		self.forbidden_op_uid = -1				--禁言操作者uid
		self.msg_private_friend_count = -1		--私聊好友总数量
		self.msg_private_friend_chat_list = -1	--私聊好友聊天内容
		self.msg_private_friend_last_uid = -1	--私聊最近一次好友uid
		self.group_send_packet_num = -1			--今日军团发红包次数
		self.group_send_packet_timestamp = -1	--上次军团发红包的时间戳
		
		return self
	end
	
	--初始化函数
	function User:Init(id, uid, rid)
		self._id = id
		self._uid = uid
		self._rid = rid
		--self._name = hVar.tab_string["__TEXT_PLAYER"].. tostring(dbId)
		
		self._state = User.STATEINFO.INIT		--设置初始化
		self._bGetBaseInfo = false	--是否读取基础信息
		
		--管理员标识
		self.bTester = 0						--管理员标记
		
		--聊天相关
		self.msg_init_state = 0					--聊天相关数据是否初始化(1:初始化)
		self.msg_world_num = 0					--上次世界聊天次数
		self.msg_total_num = 0					--上次全部聊天次数
		self.msg_world_timestamp = 631123200	--上次世界聊天的时间戳(默认1990年)
		self.msg_total_timestamp = 631123200	--上次全部聊天的时间戳(默认1990年)
		self.forbidden = 0						--是否被禁言
		self.forbidden_timestamp = 631123200	--被禁言的时间戳(默认1990年)
		self.forbidden_minute = 0				--被禁言持续时间（单位:分钟）
		self.forbidden_op_uid = 0				--禁言操作者uid
		self.msg_private_friend_count = 0		--私聊好友总数量
		self.msg_private_friend_chat_list = {}	--私聊好友聊天内容
		self.msg_private_friend_last_uid = 0	--私聊最近一次好友uid
		self.group_send_packet_num = 0			--今日军团发红包次数
		self.group_send_packet_timestamp = 631123200	--上次军团发红包的时间戳(默认1990年)
		
		return self
	end
	
	--release
	function User:Release()
		self._id = -1							--内存id
		self._uid = -1							--数据库id
		self._rid = -1							--当前使用的角色Id
		
		self._state = -1						--是否初始化
		self._bGetBaseInfo = false				--是否读取基础信息
		
		self._name = ""							--用户姓名
		
		--管理员标识
		self.bTester = -1						--管理员标记
		
		--聊天相关
		self.msg_init_state = -1				--聊天相关数据是否初始化(1:初始化)
		self.msg_world_num = -1					--上次世界聊天次数
		self.msg_total_num = -1					--上次全部聊天次数
		self.msg_world_timestamp = -1			--上次世界聊天的时间戳
		self.msg_total_timestamp = -1			--上次全部聊天的时间戳
		self.forbidden = -1						--是否被禁言
		self.forbidden_timestamp = -1			--被禁言的时间戳
		self.forbidden_minute = -1				--被禁言持续时间（单位:分钟）
		self.forbidden_op_uid = -1				--禁言操作者uid
		self.msg_private_friend_count = -1		--私聊好友总数量
		self.msg_private_friend_chat_list = -1	--私聊好友聊天内容
		self.msg_private_friend_last_uid = -1	--私聊最近一次好友uid
		self.group_send_packet_num = -1			--今日军团发红包次数
		self.group_send_packet_timestamp = -1	--上次军团发红包的时间戳(默认1990年)
		
		return self
	end
	
	--获取用户内存ID
	function User:GetID()
		return self._id
	end
	
	--获取用户DBID
	function User:GetUID()
		return self._uid
	end
	
	--获取用户使用角色ID
	function User:GetRID()
		return self._rid
	end
	
	--获取用户Name
	function User:GetName()
		return self._name
	end
	
	--获取当前状态
	function User:GetState()
		return self._state
	end
	
	--获取管理员标识
	function User:GetTester()
		return self.bTester
	end
	
	--用户初始化
	function User:SetInit()
		self._state = User.STATEINFO.INIT
	end
	
	--用户是否初始化
	function User:IsInit()
		local ret = false
		if (self._state > User.STATEINFO.UNINIT) then
			ret = true
		end
		
		return ret
	end
	
	--用户聊天相关数据初始化
	function User:InitChat()
		--不重复初始化聊天数据
		if (self.msg_init_state ~= 1) then
			--查询玩家管理员标记
			local sQueryT = string.format("SELECT `bTester` FROM `t_user` WHERE `uid` = %d", self._uid)
			local errT, bTester = xlDb_Query(sQueryT)
			if (errT == 0) then --查询成功
				self.bTester = bTester
			end
			
			local sQueryCU = string.format("SELECT `uid`, `name`, `msg_world_num`, `last_msg_world_time`, `msg_total_num`, `last_msg_total_time`, `forbidden`, `last_forbidden_time`, `forbidden_minute`, `forbidden_op_uid`, `msg_private_friend_count`, `msg_private_friend_list`, `msg_private_friend_last_uid`, `send_redpacket_num`, `last_send_redpacket_time` FROM `t_chat_user` WHERE `uid` = %d", self._uid)
			local errCU, uid, name, msg_world_num, last_msg_world_time, msg_total_num, last_msg_total_time, forbidden, last_forbidden_time, forbidden_minute, forbidden_op_uid, msg_private_friend_count, msg_private_friend_list, msg_private_friend_last_uid, send_packet_num, last_send_packet_time = xlDb_Query(sQueryCU)
			--print("从数据库读取玩家聊天信息表:","errCU=" .. errCU, uid, name, msg_world_num, last_msg_world_time, msg_total_numn, last_msg_total_time, forbidden, last_forbidden_time, forbidden_minute, forbidden_op_uid, msg_private_friend_count, msg_private_friend_list, msg_private_friend_last_uid, send_packet_num, last_send_packet_time)
			
			if (errCU == 0) then --查询成功
				self.msg_world_num = msg_world_num --上次世界聊天次数
				self.msg_total_num = msg_total_num --上次全部聊天次数
				self.msg_world_timestamp = hApi.GetNewDate(last_msg_world_time) --上次世界聊天的时间戳
				self.msg_total_timestamp = hApi.GetNewDate(last_msg_total_time) --上次全部聊天的时间戳
				self.forbidden = forbidden --是否被禁言
				self.forbidden_timestamp = hApi.GetNewDate(last_forbidden_time) --被禁言的时间戳
				self.forbidden_minute = forbidden_minute --被禁言持续时间（单位:分钟）
				self.forbidden_op_uid = forbidden_op_uid --禁言操作者uid
				
				--私聊人数上限（按管理员最大好友人数截断）
				if (msg_private_friend_count > hVar.CHAT_MAX_USERNUM_PRIVATE_GM) then
					msg_private_friend_count = hVar.CHAT_MAX_USERNUM_PRIVATE_GM
				end
				self.msg_private_friend_count = msg_private_friend_count --私聊好友总数量
				
				self.msg_private_friend_chat_list = {} --私聊好友聊天内容
				
				--查询私聊好友消息
				if (msg_private_friend_count > 0) then
					local valid_friend_count = 0 --有效的好友数量
					local tFriendList = hApi.Split(msg_private_friend_list, ";")
					for i = 1, msg_private_friend_count, 1 do
						local tFriend = hApi.Split(tFriendList[i], "|")
						local touid = tonumber(tFriend[1]) or 0 --好友uid
						local inviteflag = tonumber(tFriend[2]) or 0 --好友是否通过邀请
						local toname = tostring(tFriend[3]) or "" --好友name
						local tochannelId = tonumber(tFriend[4]) or 0 --好友channelId
						local tovip = tonumber(tFriend[5]) or 0 --好友vip
						local toborderId = tonumber(tFriend[6]) or 0 --好友borderId
						local toiconId = tonumber(tFriend[7]) or 0 --好友iconId
						local tochampionId = tonumber(tFriend[8]) or 0 --好友championId
						local toleaderId = tonumber(tFriend[9]) or 0 --好友leaderId
						local todragonId = tonumber(tFriend[10]) or 0 --好友dragonId
						local toheadId = tonumber(tFriend[11]) or 0 --好友headId
						local tolineId = tonumber(tFriend[12]) or 0 --好友lineId
						if (touid > 0) then
							local chatList = {}
							
							--查询最近30条两人之间的聊天记录
							local chatType = hVar.CHAT_TYPE.PRIVATE --私聊消息
							local sQueryM = string.format("SELECT `id`, `type`, `msg_type`, `uid`, `name`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `content`, `time`, `touid`, `result` FROM `chat` WHERE `type` = %d and ((`uid` = %d and `touid` = %d) or (`uid` = %d and `touid` = %d)) and `deleteflag` = 0 order by `id` desc limit %d", chatType, self._uid, touid, touid, self._uid, hVar.CHAT_MAX_LENGTH_PRIVATE)
							local errM, tTemp = xlDb_QueryEx(sQueryM)
							--print("查询最近30条两人之间的聊天记录:", "errM=" .. errM, "tTemp=" .. tostring(tTemp and #tTemp))
							if (errM == 0) then
								--逆向初始化
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
									
									--print("聊天记录:", id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
									
									local chat = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
									chatList[#chatList+1] = chat
								end
							end
							
							self.msg_private_friend_chat_list[#self.msg_private_friend_chat_list+1] =
							{
								touid = touid, --好友uid
								inviteflag = inviteflag, --好友好友是否通过邀请
								toname = toname, --好友name
								tochannelId = tochannelId, --好友channelId
								tovip = tovip, --好友vip
								toborderId = toborderId, --好友borderId
								toiconId = toiconId, --好友iconId
								tochampionId = tochampionId, --好友championId
								toleaderId = toleaderId, --好友leaderId
								todragonId = todragonId, --好友dragonId
								toheadId = toheadId, --好友headId
								tolineId = tolineId, --好友lineId
								chatList = chatList, --聊天记录
							}
							
							--有效的好友数量加1
							valid_friend_count = valid_friend_count + 1
						end
					end
					
					--修改为有效值
					self.msg_private_friend_count = valid_friend_count
				end
				
				--私聊最近一次好友uid
				self.msg_private_friend_last_uid = msg_private_friend_last_uid
				
				--军团红包信息
				self.group_send_packet_num = send_packet_num --今日军团发红包次数
				self.group_send_packet_timestamp = hApi.GetNewDate(last_send_packet_time) --上次军团发红包的时间戳
			elseif (errCU == 4) then --没有记录
				local sInsertCU = string.format("insert into `t_chat_user`(`uid`, `name`, `msg_world_num`, `msg_total_num`, `last_msg_world_time`, `forbidden`, `last_forbidden_time`, `forbidden_minute`, `forbidden_op_uid`, `msg_private_friend_count`, `msg_private_friend_list`, `msg_private_friend_last_uid`, `send_redpacket_num`, `last_send_redpacket_time`) values(%d, '', 0, 0, '1990-01-01 00:00:00', 0, '1990-01-01 00:00:00', 0, 0, 0, '', 0, 0, '1990-01-01 00:00:00')", self._uid)
				--print(sInsertCU)
				xlDb_Execute(sInsertCU)
			end
			
			--标记聊天信息初始化完成
			self.msg_init_state = 1
		end
		
		--检测禁言时间是否到了
		if (self.forbidden == 1) then
			local forbidden_end_timestamp = self.forbidden_timestamp + self.forbidden_minute * 60
			--print(forbidden_end_timestamp, os.time())
			--禁言时间到了
			if (os.time() > forbidden_end_timestamp) then
				local sUpdateCU = string.format("update `t_chat_user` set `forbidden` = 0 where `uid` = %d", self._uid)
				--print(sUpdateCU)
				xlDb_Execute(sUpdateCU)
				
				--标记不被禁言了
				self.forbidden = 0
			end
		end
		
		--检测是否到第二天，重置世界聊天次数
		local tab1 = os.date("*t", self.msg_world_timestamp)
		local tab2 = os.date("*t", os.time())
		if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
			if (self.msg_world_num > 0) then
				local sUpdateCU = string.format("update `t_chat_user` set `msg_world_num` = 0 where `uid` = %d", self._uid)
				--print(sUpdateCU)
				xlDb_Execute(sUpdateCU)
				
				--重置世界聊天次数
				self.msg_world_num = 0
			end
		end
		
		--检测是否到第二天，重置全部聊天次数
		local tab1 = os.date("*t", self.msg_total_timestamp)
		local tab2 = os.date("*t", os.time())
		if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
			if (self.msg_total_num > 0) then
				local sUpdateCU = string.format("update `t_chat_user` set `msg_total_num` = 0 where `uid` = %d", self._uid)
				--print(sUpdateCU)
				xlDb_Execute(sUpdateCU)
				
				--重置全部聊天次数
				self.msg_total_num = 0
			end
		end
		
		--检测是否到第二天，重置军团红包次数
		local tab1 = os.date("*t", self.group_send_packet_timestamp)
		local tab2 = os.date("*t", os.time())
		if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
			if (self.group_send_packet_num > 0) then
				local sUpdateCU = string.format("update `t_chat_user` set `send_redpacket_num` = 0 where `uid` = %d", self._uid)
				--print(sUpdateCU)
				xlDb_Execute(sUpdateCU)
				
				--重置军团红包次数
				self.group_send_packet_num = 0
			end
		end
	end
	
	--生成一个临时User对象，仅用于处理私聊相关数据
	function User:CreateUserPrivateObject(uid)
		local user = hClass.User:create():Init(0, uid, 0)
		
		local sQueryCU = string.format("SELECT `uid`, `name`, `msg_world_num`, `last_msg_world_time`, `msg_total_num`, `last_msg_total_time`, `forbidden`, `last_forbidden_time`, `forbidden_minute`, `forbidden_op_uid`, `msg_private_friend_count`, `msg_private_friend_list`, `msg_private_friend_last_uid` FROM `t_chat_user` WHERE `uid` = %d", user._uid)
		local errCU, uid, name, msg_world_num, last_msg_world_time, msg_total_num, last_msg_total_time, forbidden, last_forbidden_time, forbidden_minute, forbidden_op_uid, msg_private_friend_count, msg_private_friend_list, msg_private_friend_last_uid = xlDb_Query(sQueryCU)
		--print("从数据库读取玩家聊天信息表:","errCU=" .. errCU, uid, name, msg_world_num, last_msg_world_time, msg_total_num, last_msg_total_time, forbidden, last_forbidden_time, forbidden_minute, forbidden_op_uid, msg_private_friend_count, msg_private_friend_list, msg_private_friend_last_uid)
		
		if (errCU == 0) then --查询成功
			user.msg_world_num = msg_world_num --上次世界聊天次数
			user.msg_total_num = msg_total_num --上次全部聊天次数
			user.msg_world_timestamp = hApi.GetNewDate(last_msg_world_time) --上次世界聊天的时间戳
			self.msg_total_timestamp = hApi.GetNewDate(last_msg_total_time) --上次全部聊天的时间戳
			user.forbidden = forbidden --是否被禁言
			user.forbidden_timestamp = hApi.GetNewDate(last_forbidden_time) --被禁言的时间戳
			user.forbidden_minute = forbidden_minute --被禁言持续时间（单位:分钟）
			user.forbidden_op_uid = forbidden_op_uid --禁言操作者uid
			
			--检测是否到第二天，重置User对象世界聊天次数
			local tab1 = os.date("*t", user.msg_world_timestamp)
			local tab2 = os.date("*t", os.time())
			if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
				--重置User对象世界聊天次数
				user.msg_world_num = 0
			end
			
			--检测是否到第二天，重置User对象全部聊天次数
			local tab1 = os.date("*t", user.msg_total_timestamp)
			local tab2 = os.date("*t", os.time())
			if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
				--重置User对象世界聊天次数
				user.msg_total_num = 0
			end
			
			--私聊人数上限（按管理员最大人数截断）
			if (msg_private_friend_count > hVar.CHAT_MAX_USERNUM_PRIVATE_GM) then
				msg_private_friend_count = hVar.CHAT_MAX_USERNUM_PRIVATE_GM
			end
			user.msg_private_friend_count = msg_private_friend_count --私聊好友总数量
			
			user.msg_private_friend_chat_list = {} --私聊好友聊天内容
			
			--查询私聊好友消息
			if (msg_private_friend_count > 0) then
				local valid_friend_count = 0 --有效的好友数量
				local tFriendList = hApi.Split(msg_private_friend_list, ";")
				for i = 1, msg_private_friend_count, 1 do
					local tFriend = hApi.Split(tFriendList[i], "|")
					local touid = tonumber(tFriend[1]) or 0 --好友uid
					local inviteflag = tonumber(tFriend[2]) or 0 --好友是否通过邀请
					local toname = tostring(tFriend[3]) or "" --好友name
					local tochannelId = tonumber(tFriend[4]) or 0 --好友channelId
					local tovip = tonumber(tFriend[5]) or 0 --好友vip
					local toborderId = tonumber(tFriend[6]) or 0 --好友borderId
					local toiconId = tonumber(tFriend[7]) or 0 --好友iconId
					local tochampionId = tonumber(tFriend[8]) or 0 --好友championId
					local toleaderId = tonumber(tFriend[9]) or 0 --好友leaderId
					local todragonId = tonumber(tFriend[10]) or 0 --好友dragonId
					local toheadId = tonumber(tFriend[11]) or 0 --好友headId
					local tolineId = tonumber(tFriend[12]) or 0 --好友lineId
					if (touid > 0) then
						local chatList = {}
						
						--[[
						--查询最近30条两人之间的聊天记录
						local chatType = hVar.CHAT_TYPE.PRIVATE --私聊消息
						local sQueryM = string.format("SELECT `id`, `type`, `msg_type`, `uid`, `name`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `content`, `time`, `touid`, `result` FROM `chat` WHERE `type` = %d and ((`uid` = %d and `touid` = %d) or (`uid` = %d and `touid` = %d)) and `deleteflag` = 0 order by `id` desc limit %d", chatType, user._uid, touid, touid, user._uid, hVar.CHAT_MAX_LENGTH_PRIVATE)
						local errM, tTemp = xlDb_QueryEx(sQueryM)
						--print("查询最近30条两人之间的聊天记录:", "errM=" .. errM, "tTemp=" .. tostring(tTemp and #tTemp))
						if (errM == 0) then
							--逆向初始化
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
								
								--print("聊天记录:", id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
								
								local chat = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
								chatList[#chatList+1] = chat
							end
						end
						]]
						
						user.msg_private_friend_chat_list[#user.msg_private_friend_chat_list+1] =
						{
							touid = touid, --好友uid
							inviteflag = inviteflag, --好友好友是否通过邀请
							toname = toname, --好友name
							tochannelId = tochannelId, --好友channelId
							tovip = tovip, --好友vip
							toborderId = toborderId, --好友borderId
							toiconId = toiconId, --好友iconId
							tochampionId = tochampionId, --好友championId
							toleaderId = toleaderId, --好友leaderId
							todragonId = todragonId, --好友dragonId
							toheadId = toheadId, --好友headId
							tolineId = tolineId, --好友lineId
							chatList = chatList, --聊天记录
						}
						
						--有效的好友数量加1
						valid_friend_count = valid_friend_count + 1
					end
				end
				
				--修改为有效值
				user.msg_private_friend_count = valid_friend_count
			end
			
			--私聊最近一次好友uid
			user.msg_private_friend_last_uid = msg_private_friend_last_uid
			
			return user
		end
	end
	
	--用户是否被禁言
	function User:GetForbidden()
		local forbidden = 1
		
		if (self.msg_init_state == 1) then
			--检测禁言时间是否到了
			if (self.forbidden == 1) then
				local forbidden_end_timestamp = self.forbidden_timestamp + self.forbidden_minute * 60
				--print(forbidden_end_timestamp, os.time())
				--禁言时间到了
				if (os.time() > forbidden_end_timestamp) then
					forbidden = 0
				end
			else
				forbidden = 0
			end
		end
		
		return forbidden
	end
	
	--获取用户今日发军团红包次数
	function User:GetSendRedPacketNum()
		local sendRedPacketNum = 0
		
		if (self.msg_init_state == 1) then
			sendRedPacketNum = self.group_send_packet_num
		end
		
		return sendRedPacketNum
	end
	
	--更新用户今日发军团红包次数
	function User:AddSendRedPacketNum(sendNum)
		if (self.msg_init_state == 1) then
			local currenttime = os.time()
			
			--检测是否到第二天，重置发军团红包次数
			local tab1 = os.date("*t", self.group_send_packet_timestamp)
			local tab2 = os.date("*t", currenttime)
			if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
				--重置发军团红包次数
				self.group_send_packet_num = sendNum
				self.group_send_packet_timestamp = currenttime
			else
				--更新今日次数
				self.group_send_packet_num = self.group_send_packet_num + sendNum
				self.group_send_packet_timestamp = currenttime
			end
			
			local sUpdateCU = string.format("update `t_chat_user` set `send_redpacket_num` = %d, `last_send_redpacket_time` = now() where `uid` = %d", self.group_send_packet_num, self._uid)
			--print(sUpdateCU)
			xlDb_Execute(sUpdateCU)
		end
	end
	
	--更新用户世界聊天数据
	function User:AddWorldMessageCount(name, msgNum)
		if (self.msg_init_state == 1) then
			local currenttime = os.time()
			
			--检测是否到第二天，重置世界聊天次数
			local tab1 = os.date("*t", self.msg_world_timestamp)
			local tab2 = os.date("*t", currenttime)
			if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
				--重置世界聊天次数
				self.msg_world_num = msgNum
				self.msg_world_timestamp = currenttime
			else
				--更新今日次数
				self.msg_world_num = self.msg_world_num + msgNum
				self.msg_world_timestamp = currenttime
			end
			
			local sUpdateCU = string.format("update `t_chat_user` set `name` = '%s', `msg_world_num` = %d, `last_msg_world_time` = now() where `uid` = %d", name, self.msg_world_num, self._uid)
			--print(sUpdateCU)
			xlDb_Execute(sUpdateCU)
		end
	end
	
	--更新用户全部聊天消息次数
	function User:AddTotalMessageCount(msgNum)
		if (self.msg_init_state == 1) then
			local currenttime = os.time()
			
			--检测是否到第二天，重置全部聊天次数
			local tab1 = os.date("*t", self.msg_total_timestamp)
			local tab2 = os.date("*t", currenttime)
			if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
				--重置全部聊天次数
				self.msg_total_num = msgNum
				self.msg_total_timestamp = currenttime
			else
				--更新今日次数
				self.msg_total_num = self.msg_total_num + msgNum
				self.msg_total_timestamp = currenttime
			end
			
			--写日志
			local info = "uid=" .. tostring(self._uid) .. ",msg_world_num=" .. tostring(self.msg_world_num) .. ",msg_total_num=" .. tostring(self.msg_total_num) .. ",msg_world_timestamp=" .. tostring(os.date("%Y-%m-%d %H:%M:%S", self.msg_world_timestamp))
			hGlobal.chatWriter:Write(info)
			
			local sUpdateCU = string.format("update `t_chat_user` set `msg_total_num` = %d, `last_msg_total_time` = now() where `uid` = %d", self.msg_total_num, self._uid)
			--print(sUpdateCU)
			xlDb_Execute(sUpdateCU)
		end
	end
	
	--禁言uid
	--返回值: 操作结果, 玩家名
	function User:ForbiddenUser(forbiddenUid, minute)
		--操作结果
		local ret = 0
		local forbiddenUName = nil
		if (self.msg_init_state == 1) then
			if (minute > 0) then
				--取玩家名
				local sQueryT = string.format("SELECT `name` FROM `t_chat_user` WHERE `uid` = %d", forbiddenUid)
				local errT, name = xlDb_Query(sQueryT)
				if (errT == 0) then --查询成功
					forbiddenUName = name
					
					local sUpdateCU = string.format("update `t_chat_user` set `forbidden` = %d, `last_forbidden_time` = now(), `forbidden_minute` = %d, `forbidden_op_uid` = %d where `uid` = %d", 1, minute, self:GetUID(), forbiddenUid)
					--print(sUpdateCU)
					xlDb_Execute(sUpdateCU)
					
					--更新被禁言的玩家内存数据
					local forbiddenUser = hGlobal.uMgr:FindChatUserByDBID(forbiddenUid)
					if forbiddenUser then
						forbiddenUser.forbidden = 1 --是否被禁言
						forbiddenUser.forbidden_timestamp = os.time() --被禁言的时间戳
						forbiddenUser.forbidden_minute = minute --被禁言持续时间（单位:分钟）
						forbiddenUser.forbidden_op_uid = self:GetUID() --禁言操作者uid
					end
					
					--操作成功
					ret = 1
				else
					--无效的玩家
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
				end
			else
				--参数不合法
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
			end
			
		else
			--玩家未初始化
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_USER_INIT
		end
		
		return ret, forbiddenUName
	end
	
	--设置最近一次聊天的好友uid
	function User:SetFriendLastUid(friendUid)
		if (self.msg_private_friend_last_uid ~= friendUid) then
			--更新数据库
			local sUpdateCU = string.format("update `t_chat_user` set `msg_private_friend_last_uid` = %d where `uid` = %d", friendUid, self._uid)
			--print(sUpdateCU)
			xlDb_Execute(sUpdateCU)
			
			self.msg_private_friend_last_uid = friendUid
		end
	end
	
	--查询玩家与私聊好友的指定聊天id列表的聊天内容
	function User:ChatFriendMsgByIDList(chatType, friendUid, msgIDList)
		local sCmd = ""
		local snum = 0 --有效的消息数量
		local msgIdNum = #msgIDList --消息总数量
		local tFriend = nil
		
		--print("查询玩家与私聊好友的指定聊天id列表的聊天内容", self._uid, chatType, friendUid)
		if (self.msg_init_state == 1) then
			--查询的私聊数量不超过最大值
			if (#msgIDList <= hVar.CHAT_MAX_LENGTH_WORLD) then
				--print("self.msg_private_friend_count=", self.msg_private_friend_count)
				for i = 1, self.msg_private_friend_count, 1 do
					local tFriend_i = self.msg_private_friend_chat_list[i]
					local touid = tFriend_i.touid --好友uid
					--print(i, "touid=", touid)
					if (touid == friendUid) then
						tFriend = tFriend_i --找到了
						break
					end
				end
				
				--对方是我的好友
				if tFriend then
					--依次查找id
					for c = 1, msgIdNum, 1 do
						local msgId = msgIDList[c]
						--print("查找私聊消息", msgId)
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
	
	--添加一条私聊消息
	--返回值: 操作结果
	function User:SendPrivateMessage(chat)
		--操作结果
		local ret = 0
		
		if (chat._chatType == hVar.CHAT_TYPE.PRIVATE) then --只处理私聊频道
			--local uid = chat._uid
			--local touid = chat._touid
			
			--发送者为自己，或者接收者是自己
			if (chat._uid == self._uid) or (chat._touid == self._uid) then
				--检测对方是否在自己好友列表里
				local tFriend = nil
				local tFriendIdx = 0
				for i = 1, self.msg_private_friend_count, 1 do
					local tFriend_i = self.msg_private_friend_chat_list[i]
					local touid_i = tFriend_i.touid --好友uid
					--print(i, "touid_i=", touid_i)
					if (touid_i == chat._touid) or (touid_i == chat._uid) then
						tFriend = tFriend_i --找到了
						tFriendIdx = i
						break
					end
				end
				--检测是否是好友
				--print("tFriend=", tFriend)
				if tFriend then
					--检测是否通过好友验证
					--print("tFriend.inviteflag=", tFriend.inviteflag)
					if (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.ACCEPT) then --状态为已接受
						--对方玩家对象
						local friendUser = hGlobal.uMgr:FindChatUserByDBID(chat._touid)
						if (friendUser == nil) then
							--创建一个临时的user对象，仅用于处理私聊的数据
							friendUser = hClass.User:CreateUserPrivateObject(chat._touid)
							--print("创建一个临时的user对象", chat._touid)
						end
						
						--检测对方好友里是否有我
						local tFriendMe = nil
						local tFriendIdxMe = 0
						for i = 1, friendUser.msg_private_friend_count, 1 do
							local tFriendMe_i = friendUser.msg_private_friend_chat_list[i]
							local touid_me_i = tFriendMe_i.touid --好友uid
							--print(i, "touid_i=", touid_i)
							if (self._uid == touid_me_i) then
								tFriendMe = tFriendMe_i --找到了
								tFriendIdxMe = i
								break
							end
						end
						
						--对方好友里也有我
						if tFriendMe then
							if (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.ACCEPT) then --已接受
								--可以发送私聊消息
								tFriend.chatList[#tFriend.chatList+1] = chat
								--print("添加私聊消息", chat._uid, chat._touid, chat._chatType, "chat.id=", chat._id, "#tFriend.chatList=", #tFriend.chatList)
								
								--消息数量超过私聊上限，删除第一条消息
								if (#tFriend.chatList > hVar.CHAT_MAX_LENGTH_PRIVATE) then
									--移除消息
									local msgId = tFriend.chatList[1]:GetID()
									table.remove(tFriend.chatList, 1)
									
									--通知自己: 删除玩家聊天信息
									local sCmd = tostring(msgId)
									hApi.xlNet_Send(self._uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
								end
								
								local bRequireDBUpdate = false --是否需要更新数据库
								
								--因为发送了消息，此好友在我的好友列表排第一位
								if (tFriendIdx > 1) then
									table.remove(self.msg_private_friend_chat_list, tFriendIdx)
									table.insert(self.msg_private_friend_chat_list, 1, tFriend)
									bRequireDBUpdate = true --需要更新数据库
								end
								
								--更新数据库
								if bRequireDBUpdate then
									local strFriendInfo = self:_PrivateFriendInfoToDBCmd()
									local sUpdateCU = string.format("update `t_chat_user` set `msg_private_friend_count` = %d, `msg_private_friend_list` = '%s' where `uid` = %d", self.msg_private_friend_count, strFriendInfo, self._uid)
									xlDb_Execute(sUpdateCU)
									--print("sUpdateCU")
								end
								
								--对方也添加和我的私聊信息
								--更新对方内存数据
								tFriendMe.chatList[#tFriendMe.chatList+1] = chat
								
								--消息数量超过私聊上限，删除第一条消息
								if (#tFriendMe.chatList > hVar.CHAT_MAX_LENGTH_PRIVATE) then
									--移除消息
									local msgId = tFriendMe.chatList[1]:GetID()
									table.remove(tFriendMe.chatList, 1)
									
									--通知好友: 删除玩家聊天信息
									local sCmd = tostring(msgId)
									hApi.xlNet_Send(chat._touid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
								end
								
								local bRequireDBUpdateMe = false --对方是否需要更新数据库
								
								--因为发送了消息，我在此好友列表排第一位
								if (tFriendIdxMe > 1) then
									table.remove(friendUser.msg_private_friend_chat_list, tFriendIdxMe)
									table.insert(friendUser.msg_private_friend_chat_list, 1, tFriendMe)
									bRequireDBUpdateMe = true --需要更新数据库
									--print("bRequireDBUpdateMe 1")
								end
								
								--检测对方存的我信息是否需要更新
								if (tFriendMe.toname ~= chat._name) or (tFriendMe.tochannelId ~= chat._channelId) or (tFriendMe.tovip ~= chat._vip)
									or (tFriendMe.toborderId ~= chat._borderId) or (tFriendMe.toiconId ~= chat._iconId)
									or (tFriendMe.tochampionId ~= chat._championId) or (tFriendMe.toleaderId ~= chat._leaderId)
									or (tFriendMe.todragonId ~= chat._dragonId) or (tFriendMe.toheadId ~= chat._headId)
									or (tFriendMe.tolineId ~= chat._lineId) then
									bRequireDBUpdateMe = true --需要更新数据库
									--print("bRequireDBUpdateMe 2")
									
									--更新内存数据
									--tFriendMe.touid = touid --好友uid
									--tFriendMe.inviteflag = inviteflag --好友好友是否通过邀请
									tFriendMe.toname = chat._name --好友name
									tFriendMe.tochannelId = chat._channelId --好友channelId
									tFriendMe.tovip = chat._vip --好友vip
									tFriendMe.toborderId = chat._borderId --好友borderId
									tFriendMe.toiconId = chat._iconId --好友iconId
									tFriendMe.tochampionId = chat._championId --好友championId
									tFriendMe.toleaderId = chat._leaderId --好友leaderId
									tFriendMe.todragonId = chat._dragonId --好友dragonId
									tFriendMe.toheadId = chat._headId --好友headId
									tFriendMe.tolineId = chat._lineId --好友lineId
									--tFriendMe.chatList = chatList --聊天记录
								end
								
								--更新数据库
								if bRequireDBUpdateMe then
									local strFriendInfoMe = friendUser:_PrivateFriendInfoToDBCmd()
									local sUpdateCUMe = string.format("update `t_chat_user` set `msg_private_friend_count` = %d, `msg_private_friend_list` = '%s' where `uid` = %d", friendUser.msg_private_friend_count, strFriendInfoMe, friendUser._uid)
									xlDb_Execute(sUpdateCUMe)
									--print("sUpdateCUMe")
								end
								
								--更新玩家今日聊天次数（私聊频道）
								self:AddTotalMessageCount(1)
								
								--操作成功
								ret = 1
							elseif (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.NONE) then
								--等待对方通过私聊请求
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE
							elseif (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.REFUSE) then --已拒绝
								--对方已拒绝您的私聊请求
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REFUSE
							elseif (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.REFUSEBY) then --已被拒绝
								--您已拒绝对方的私聊请求
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REFUSE_ME
							elseif (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.DELETE) then --已删除
								--对方已关闭和你的私聊
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REMOVE
							elseif (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.DELETEBY) then --被删除
								--您已将对方删除
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REMOVE_ME
							end
						else
							--您不在对方的私聊列表里
							ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_FRIEND_ME
						end
					elseif (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.NONE) then --未处理
						--等待对方通过私聊请求
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE
					elseif (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.REFUSE) then --已拒绝
						--您已拒绝对方的私聊请求
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REFUSE_ME
					elseif (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.REFUSEBY) then --已被拒绝
						--对方已拒绝您的私聊请求
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REFUSE
					elseif (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.DELETE) then --已删除
						--您已将对方删除
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REMOVE_ME
					elseif (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.DELETEBY) then --被删除
						--对方已关闭和你的私聊
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REMOVE
					end
				else
					--对方不在您的私聊列表里
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_FRIEND
				end
			else
				--无效的玩家
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
			end
		else
			--只能发送私聊消息
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_TYPE
		end
		
		return ret
	end
	
	--添加一条私聊验证消息
	function User:_AddPrivateInviteMessage(chat)
		--操作结果
		local ret = 0
		
		if (self.msg_init_state == 1) then
			if (chat._chatType == hVar.CHAT_TYPE.PRIVATE) then --只处理私聊频道
				--发送者为自己
				if (chat._uid == self._uid) then
					--检测对方是否在自己好友列表里
					local tFriend = nil
					local tFriendIdx = 0
					for i = 1, self.msg_private_friend_count, 1 do
						local tFriend_i = self.msg_private_friend_chat_list[i]
						local touid_i = tFriend_i.touid --好友uid
						--print(i, "touid_i=", touid_i)
						if (touid_i == chat._touid) or (touid_i == chat._uid) then
							tFriend = tFriend_i --找到了
							tFriendIdx = i
							break
						end
					end
					--检测是否是好友
					--print("tFriend=", tFriend)
					if tFriend then
						tFriend.chatList[#tFriend.chatList+1] = chat
						--print("添加一条私聊好友验证消息", chat._uid, chat._touid, chat._chatType, "chat.id=", chat._id, "#tFriend.chatList=", #tFriend.chatList)
						
						--消息数量超过私聊上限，删除第一条消息
						if (#tFriend.chatList > hVar.CHAT_MAX_LENGTH_PRIVATE) then
							--移除消息
							local msgId = tFriend.chatList[1]:GetID()
							table.remove(tFriend.chatList, 1)
							
							--通知自己: 删除玩家聊天信息
							local sCmd = tostring(msgId)
							hApi.xlNet_Send(self._uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
						end
						
						--对方也添加和我的私聊信息
						--更新对方内存数据
						local friendUser = hGlobal.uMgr:FindChatUserByDBID(chat._touid)
						if (friendUser == nil) then
							--创建一个临时的user对象，仅用于处理私聊的数据
							friendUser = hClass.User:CreateUserPrivateObject(chat._touid)
							--print("创建一个临时的user对象", chat._touid)
						end
						if friendUser then
							local tFriendMe = nil
							local tFriendIdxMe = 0
							for i = 1, friendUser.msg_private_friend_count, 1 do
								local tFriendMe_i = friendUser.msg_private_friend_chat_list[i]
								local touid_me_i = tFriendMe_i.touid --好友uid
								--print(i, "touid_i=", touid_i)
								if (touid_me_i == chat._touid) or (touid_me_i == chat._uid) then
									tFriendMe = tFriendMe_i --找到了
									tFriendIdxMe = i
									break
								end
							end
							if tFriendMe then
								tFriendMe.chatList[#tFriendMe.chatList+1] = chat
								
								--消息数量超过私聊上限，删除第一条消息
								if (#tFriendMe.chatList > hVar.CHAT_MAX_LENGTH_PRIVATE) then
									--移除消息
									local msgId = tFriendMe.chatList[1]:GetID()
									table.remove(tFriendMe.chatList, 1)
									
									--通知好友: 删除玩家聊天信息
									local sCmd = tostring(msgId)
									hApi.xlNet_Send(chat._touid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
								end
							end
						end
						
						--插入一条私聊邀请日志
						hGlobal.chatMgr:InsertInveteLog(self._uid, chat._name, chat._touid, tFriend.toname, tFriend.inviteflag)
						
						--操作成功
						ret = 1
					else
						--对方不在您的私聊列表里
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_FRIEND
					end
				else
					--无效的玩家
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
				end
			else
				--只能发送私聊消息
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_TYPE
			end
		else
			--玩家未初始化
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_USER_INIT
		end
		
		return ret
	end
	
	--请求和对方玩家发起私聊
	--返回值: 操作结果
	function User:PrivateInviteUser(tMsgMe, tMsgFriend)
		--操作结果
		local ret = 0
		
		if (self.msg_init_state == 1) then
			--有效的玩家uid
			if (tMsgFriend.uid > 0) then
				--不能添加自己为好友
				if (tMsgFriend.uid ~= self._uid) then
					--检测是否被禁言
					local forbidden = self:GetForbidden()
					if (forbidden == 0) then
						--检查此好友是否在我的私聊列表里
						--local touid = tMsgFriend.uid
						local tFriend = nil
						local tFriendIdx = 0
						for i = 1, self.msg_private_friend_count, 1 do
							local tFriend_i = self.msg_private_friend_chat_list[i]
							local friendUid = tFriend_i.touid --好友uid
							if (tMsgFriend.uid == friendUid) then
								tFriend = tFriend_i --找到了
								tFriendIdx = i
								break
							end
						end
						
						--好友是否在线
						local online = 1
						local friendUser = hGlobal.uMgr:FindChatUserByDBID(tMsgFriend.uid)
						if (friendUser == nil) then
							--创建一个临时的user对象，仅用于处理私聊的数据
							friendUser = hClass.User:CreateUserPrivateObject(tMsgFriend.uid)
							--print("创建一个临时的请求和对方玩家私聊user对象", tMsgFriend.uid)
							online = 0
						end
						
						--有效的私聊目标
						if friendUser then
							--不在我的私聊列表，并且玩家不在线，并且发起者不是管理员，不能发起私聊
							--if tFriend or (online == 1) or (self:GetTester() == 2) then
							--if tFriend then
								--对方不是我的好友，并且我的好友满了，不能发起私聊
								local MAX_USERNUM = hVar.CHAT_MAX_USERNUM_PRIVATE
								if (self:GetTester() == 2) then --人数满后，管理员可继续发起私聊
									MAX_USERNUM = hVar.CHAT_MAX_USERNUM_PRIVATE_GM
								end
								if tFriend or (self.msg_private_friend_count < MAX_USERNUM) then
									--对方不是我的好友，并且今日发起私聊次数超过上限，不能发起私聊
									local inveteLogCount = hGlobal.chatMgr:QueryInveteLogCount(self._uid, tMsgFriend.uid)
									if tFriend or (inveteLogCount < hVar.CHAT_MAX_COUNT_PRIVATE) then
										--检测对方好友里我的状态
										local tFriendMe = nil
										local tFriendIdxMe = 0
										for i = 1, friendUser.msg_private_friend_count, 1 do
											local tFriendMe_i = friendUser.msg_private_friend_chat_list[i]
											local touid_me_i = tFriendMe_i.touid --好友uid
											--print(i, "touid_i=", touid_i)
											if (self._uid == touid_me_i) then
												tFriendMe = tFriendMe_i --找到了
												tFriendIdxMe = i
												break
											end
										end
										
										--对方是否能通过我
										local nFriendInviteStateOK = 0
										if tFriendMe then --对方好友里有我
											--print(tFriendMe.inviteflag)
											if (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.NONE) or (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.ACCEPT) then --等待操作
												--可以添加
												nFriendInviteStateOK = 1
											elseif (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.REFUSE) then --已拒绝
												--对方已拒绝您的私聊请求
												--ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REFUSE
												if (inveteLogCount < hVar.CHAT_MAX_COUNT_PRIVATE) then
													--可以添加
													nFriendInviteStateOK = 1
												else
													--您今日请求私聊该玩家的次数达到上限
													ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_MAXCOUNT
												end
											elseif (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.REFUSEBY) then --已被拒绝
												--您已拒绝对方的私聊请求
												--ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REFUSE_ME
												if (inveteLogCount < hVar.CHAT_MAX_COUNT_PRIVATE) then
													--可以添加
													nFriendInviteStateOK = 1
												else
													--您今日请求私聊该玩家的次数达到上限
													ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_MAXCOUNT
												end
											elseif (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.DELETE) then --已删除
												--对方已关闭和你的私聊
												--ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REMOVE
												if (inveteLogCount < hVar.CHAT_MAX_COUNT_PRIVATE) then
													--可以添加
													nFriendInviteStateOK = 1
												else
													--您今日请求私聊该玩家的次数达到上限
													ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_MAXCOUNT
												end
											elseif (tFriendMe.inviteflag == hVar.PRIVATE_INVITE_TYPE.DELETEBY) then --被删除
												--您已将对方删除
												--ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REMOVE_ME
												if (inveteLogCount < hVar.CHAT_MAX_COUNT_PRIVATE) then
													--可以添加
													nFriendInviteStateOK = 1
												else
													--您今日请求私聊该玩家的次数达到上限
													ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_MAXCOUNT
												end
											end
										else --对方好友里没有我
											--我不是对方的好友，并且今日发起私聊次数超过上限，不能发起私聊
											if (inveteLogCount < hVar.CHAT_MAX_COUNT_PRIVATE) then
												--检测对方好友是否已满
												if (friendUser.msg_private_friend_count < MAX_USERNUM) then
													--可以添加
													nFriendInviteStateOK = 1
												else
													--对方私聊人数已达上限，无法发起私聊
													ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_USER_NUMMAX_ME
												end
											else
												--您今日请求私聊该玩家的次数达到上限
												ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_MAXCOUNT
											end
										end
										
										--对方可以加我
										if (nFriendInviteStateOK == 1) then
											local bRequireDBUpdate = false --我是否需要更新数据库
											local bRequireDBUpdateMe = false --对方是否需要更新数据库
											
											--新加的好友
											if (tFriend == nil) then
												local chatList = {}
												
												--查询最近29(30-1)条两人之间的聊天记录(最后一条是好友请求验证消息)
												local chatType = hVar.CHAT_TYPE.PRIVATE --私聊消息
												local sQueryM = string.format("SELECT `id`, `type`, `msg_type`, `uid`, `name`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `content`, `time`, `touid`, `result` FROM `chat` WHERE `type` = %d and ((`uid` = %d and `touid` = %d) or (`uid` = %d and `touid` = %d)) and `deleteflag` = 0 order by `id` desc limit %d", chatType, self._uid, tMsgFriend.uid, tMsgFriend.uid, self._uid, hVar.CHAT_MAX_LENGTH_PRIVATE - 1)
												local errM, tTemp = xlDb_QueryEx(sQueryM)
												--print("查询最近30条两人之间的聊天记录:", "errM=" .. errM, "tTemp=" .. tostring(tTemp and #tTemp))
												if (errM == 0) then
													--逆向初始化
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
														
														--print("聊天记录:", id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
														
														local chat = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
														chatList[#chatList+1] = chat
													end
												end
												
												tFriend =
												{
													touid = tMsgFriend.uid, --好友uid
													inviteflag = 0, --好友好友是否通过邀请
													toname = tMsgFriend.name, --好友name
													tochannelId = tMsgFriend.channelId, --好友channelId
													tovip = tMsgFriend.vip, --好友vip
													toborderId = tMsgFriend.borderId, --好友borderId
													toiconId = tMsgFriend.iconId, --好友iconId
													tochampionId = tMsgFriend.championId, --好友championId
													toleaderId = tMsgFriend.leaderId, --好友leaderId
													todragonId = tMsgFriend.dragonId, --好友dragonId
													toheadId = tMsgFriend.headId, --好友headId
													tolineId = tMsgFriend.lineId, --好友lineId
													chatList = chatList, --聊天记录
												}
												
												table.insert(self.msg_private_friend_chat_list, 1, tFriend)
												self.msg_private_friend_count = self.msg_private_friend_count + 1
												--print(tMsgFriend.uid, tMsgFriend.name, tMsgFriend.channelId, tMsgFriend.borderId, tMsgFriend.iconId, tMsgFriend.championId, tMsgFriend.leaderId, tMsgFriend.dragonId , tMsgFriend.headId , tMsgFriend.lineId)
											end
											
											--如果是首次申请加好友，或者我标记的对方状态是已删除、已拒绝等等，需要发送邀请
											if (tFriendIdx == 0)
											or (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.REFUSE)
											or (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.REFUSEBY)
											or (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.DELETE)
											or (tFriend.inviteflag == hVar.PRIVATE_INVITE_TYPE.DELETEBY) then
												--需要添加一条好友请求验证消息
												local tMsgAut = {}
												tMsgAut.chatType = hVar.CHAT_TYPE.PRIVATE
												tMsgAut.msgType = hVar.MESSAGE_TYPE.PRIVATE_INVITE --私聊好友验证消息
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
												
												--玩家添加一条私聊好友验证消息
												local chat = hGlobal.chatMgr:AddPrivateMessage(tMsgAut)
												
												--存储新聊天消息
												--消息数量超过私聊上限，删除第一条消息
												local ret = self:_AddPrivateInviteMessage(chat)
												
												--标记好友状态为待处理
												tFriend.inviteflag = hVar.PRIVATE_INVITE_TYPE.NONE
												
												--添加玩家聊天信息
												local sCmd = chat:ToCmd()
												hApi.xlNet_Send(self._uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
												
												--通知对方: 添加玩家聊天信息
												if (online == 1) then
													local sCmd = chat:ToCmd()
													hApi.xlNet_Send(tMsgFriend.uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
												end
												
												--对方也标记我的状态为待处理
												if tFriendMe then
													--对方不重复设置
													if (tFriendMe.inviteflag ~= hVar.PRIVATE_INVITE_TYPE.NONE) then
														tFriendMe.inviteflag = hVar.PRIVATE_INVITE_TYPE.NONE
														--print("bRequireDBUpdateMe 2")
													end
												end
												
												--标记需要更新数据库
												bRequireDBUpdate = true --需要更新数据库
												--print("bRequireDBUpdate 1")
											else
												--已存在的好友
												--不需要更改位置
											end
											
											--[[
											--检测对方信息是否需要更新
											if (tFriend.toname ~= tMsgFriend.name) or (tFriend.tochannelId ~= tMsgFriend.channelId) or (tFriend.tovip ~= tMsgFriend.vip)
												or (tFriend.toborderId ~= tMsgFriend.borderId) or (tFriend.toiconId ~= tMsgFriend.iconId)
												or (tFriend.tochampionId ~= tMsgFriend.championId) or (tFriend.toleaderId ~= tMsgFriend.leaderId)
												or (tFriend.todragonId ~= tMsgFriend.dragonId) or (tFriend.toheadId ~= tMsgFriend.headId)
												or (tFriend.tolineId ~= tMsgFriend.lineId) then
												bRequireDBUpdate = true --需要更新数据库
												print("bRequireDBUpdate 2")
												
												--更新内存数据
												--tFriend.touid = touid --好友uid
												--tFriend.inviteflag = inviteflag --好友好友是否通过邀请
												tFriend.toname = tMsgFriend.name --好友name
												tFriend.tochannelId = tMsgFriend.channelId --好友channelId
												tFriend.tovip = tMsgFriend.vip --好友vip
												tFriend.toborderId = tMsgFriend.borderId --好友borderId
												tFriend.toiconId = tMsgFriend.iconId --好友iconId
												tFriend.tochampionId = tMsgFriend.championId --好友championId
												tFriend.toleaderId = tMsgFriend.leaderId --好友leaderId
												tFriend.todragonId = tMsgFriend.dragonId --好友dragonId
												tFriend.toheadId = tMsgFriend.headId --好友headId
												tFriend.tolineId = tMsgFriend.lineId --lineId
												--tFriend.chatList = chatList --聊天记录
											end
											]]
											
											--检测最近一次聊天好友是否为对方
											if (self.msg_private_friend_last_uid ~= tMsgFriend.uid) then
												bRequireDBUpdate = true --需要更新数据库
												--print("bRequireDBUpdate 3")
												
												self.msg_private_friend_last_uid = tMsgFriend.uid
											end
											
											--更新数据库
											if bRequireDBUpdate then
												local strFriendInfo = self:_PrivateFriendInfoToDBCmd()
												local sUpdateCU = string.format("update `t_chat_user` set `msg_private_friend_count` = %d, `msg_private_friend_list` = '%s', `msg_private_friend_last_uid` = %d where `uid` = %d", self.msg_private_friend_count, strFriendInfo, tMsgFriend.uid, self._uid)
												xlDb_Execute(sUpdateCU)
												--print("sUpdateCU")
											end
											
											--对方也添加和我的好友关系
											--
											--local bRequireDBUpdateMe = false --对方是否需要更新数据库
											
											--新加的我
											if (tFriendMe == nil) then
												--聊天记录拷贝
												local chatListMe = {}
												for i = 1, #tFriend.chatList, 1 do
													chatListMe[#chatListMe+1] = tFriend.chatList[i]
												end
												
												tFriendMe =
												{
													touid = tMsgMe.uid, --好友uid
													inviteflag = 0, --好友好友是否通过邀请
													toname = tMsgMe.name, --好友name
													tochannelId = tMsgMe.channelId, --好友channelId
													tovip = tMsgMe.vip, --好友vip
													toborderId = tMsgMe.borderId, --好友borderId
													toiconId = tMsgMe.iconId, --好友iconId
													tochampionId = tMsgMe.championId, --好友championId
													toleaderId = tMsgMe.leaderId, --好友leaderId
													todragonId = tMsgMe.dragonId, --好友dragonId
													toheadId = tMsgMe.headId, --好友headId
													tolineId = tMsgMe.lineId, --lineId
													chatList = chatListMe, --聊天记录
												}
												
												--插入第1位
												table.insert(friendUser.msg_private_friend_chat_list, 1, tFriendMe)
												friendUser.msg_private_friend_count = friendUser.msg_private_friend_count + 1
												
												bRequireDBUpdateMe = true --需要更新数据库
												--print("bRequireDBUpdateMe 1")
											else
												--已存在的我
												--不需要更改位置
											end
											
											--[[
											--检测对方存的我信息是否需要更新
											if (tFriendMe.toname ~= tMsgMe.name) or (tFriendMe.tochannelId ~= tMsgMe.channelId) or (tFriendMe.tovip ~= tMsgMe.vip)
												or (tFriendMe.toborderId ~= tMsgMe.borderId) or (tFriendMe.toiconId ~= tMsgMe.iconId)
												or (tFriendMe.tochampionId ~= tMsgMe.championId) or (tFriendMe.toleaderId ~= tMsgMe.leaderId)
												or (tFriendMe.todragonId ~= tMsgMe.dragonId) or (tFriendMe.toheadId ~= tMsgMe.headId)
												or (tFriendMe.tolineId ~= tMsgMe.lineId) then
												bRequireDBUpdateMe = true --需要更新数据库
												print("bRequireDBUpdateMe 2")
												
												--更新内存数据
												--tFriendMe.touid = touid --好友uid
												--tFriendMe.inviteflag = inviteflag --好友好友是否通过邀请
												tFriendMe.toname = tMsgMe.name --好友name
												tFriendMe.tochannelId = tMsgMe.channelId --好友channelId
												tFriendMe.tovip = tMsgMe.vip --好友vip
												tFriendMe.toborderId = tMsgMe.borderId --好友borderId
												tFriendMe.toiconId = tMsgMe.iconId --好友iconId
												tFriendMe.tochampionId = tMsgMe.championId --好友championId
												tFriendMe.toleaderId = tMsgMe.leaderId --好友leaderId
												tFriendMe.todragonId = tMsgMe.dragonId --好友dragonId
												tFriendMe.toheadId = tMsgMe.headId --好友headId
												tFriendMe.tolineId = tMsgMe.lineId --好友lineId
												--tFriendMe.chatList = chatList --聊天记录
											end
											]]
											
											--更新好友数据库
											if bRequireDBUpdateMe then
												local strFriendInfoMe = friendUser:_PrivateFriendInfoToDBCmd()
												local sUpdateCUFriend = string.format("update `t_chat_user` set `msg_private_friend_count` = %d, `msg_private_friend_list` = '%s' where `uid` = %d", friendUser.msg_private_friend_count, strFriendInfoMe, friendUser._uid)
												xlDb_Execute(sUpdateCUFriend)
												--print("sUpdateCUFriend")
											end
											
											--操作成功
											ret = 1
										else
											--错误码已在上面处理
											--
										end
									else
										--您今日请求私聊该玩家的次数达到上限
										ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_MAXCOUNT
									end
								else
									--您的私聊人数已达上限，无法发起私聊
									ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_USER_NUMMAX
								end
							--else
							--	--对方不在线，无法发起私聊
							--	ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_USER_OFFLINE
							--end
						else
							--无效的玩家
							ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
						end
					else
						--您被禁言无法发起私聊
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PRIVATE_FOBIDDEN
					end
				else
					--不能和自己私聊
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_USER_SAMEME
				end
			else
				--无效的玩家
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
			end
		else
			--玩家未初始化
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_USER_INIT
		end
		
		return ret
	end
	
	--私聊邀请处理操作
	--返回值: 操作结果
	function User:PrivateInviteOperation(msgId, touid, inviteTag)
		--操作结果
		local ret = 0
		
		--print("PrivateInviteOperation", msgId, touid, inviteTag)
		
		if (self.msg_init_state == 1) then
			--有效的玩家uid
			if (touid > 0) then
				--有效的操作结果类型
				if (inviteTag == hVar.PRIVATE_INVITE_TYPE.ACCEPT) or (inviteTag == hVar.PRIVATE_INVITE_TYPE.REFUSE) then
					--不能添加自己为好友
					if (touid ~= self._uid) then
						--好友是否在线
						local online = 1
						local friendUser = hGlobal.uMgr:FindChatUserByDBID(touid)
						if (friendUser == nil) then
							--创建一个临时的user对象，仅用于处理私聊的数据
							friendUser = hClass.User:CreateUserPrivateObject(touid)
							--print("创建一个临时的私聊邀请操作user对象", touid)
							online = 0
						end
						
						--检查此好友是否在我的私聊列表里
						--local touid = tMsgFriend.uid
						local tFriend = nil
						local tFriendIdx = 0
						for i = 1, self.msg_private_friend_count, 1 do
							local tFriend_i = self.msg_private_friend_chat_list[i]
							local friendUid = tFriend_i.touid --好友uid
							if (touid == friendUid) then
								tFriend = tFriend_i --找到了
								tFriendIdx = i
								break
							end
						end
						
						--检查此消息的有效性
						local tChat = nil
						local tChatIdx = 0
						local chatList = tFriend.chatList --聊天记录
						for i = #chatList, 1, -1 do
							if (chatList[i]._id == msgId) then --找到了
								tChat = chatList[i]
								tChatIdx = i
								break
							end
						end
						
						--消息频道为私聊，并且消息类型为私聊验证类
						if tChat and (tChat._chatType == hVar.CHAT_TYPE.PRIVATE) and (tChat._msgType == hVar.MESSAGE_TYPE.PRIVATE_INVITE) then
							--不在我的私聊列表，不能进行操作
							if tFriend then
								--检查我是否在对方的好友列表里
								local tFriendMe = nil
								local tFriendIdxMe = 0
								if friendUser then
									for i = 1, friendUser.msg_private_friend_count, 1 do
										local tFriendMe_i = friendUser.msg_private_friend_chat_list[i]
										local touid_me_i = tFriendMe_i.touid --好友uid
										--print(i, "touid_me_i=", touid_me_i, self._uid)
										if (self._uid == touid_me_i) then
											tFriendMe = tFriendMe_i --找到了
											tFriendIdxMe = i
											break
										end
									end
								end
								--对方的好友里也有我
								if tFriendMe then
									--通过或拒绝好友验证
									if (inviteTag == hVar.PRIVATE_INVITE_TYPE.ACCEPT) then --接受
										tFriend.inviteflag = hVar.PRIVATE_INVITE_TYPE.ACCEPT
									elseif (inviteTag == hVar.PRIVATE_INVITE_TYPE.REFUSE) then --拒绝
										tFriend.inviteflag = hVar.PRIVATE_INVITE_TYPE.REFUSE
									end
									
									--因为有最新操作，所以此好友排第一位
									if (tFriendIdx > 1) then
										table.remove(self.msg_private_friend_chat_list, tFriendIdx)
										table.insert(self.msg_private_friend_chat_list, 1, tFriend)
									end
									
									--删除此条消息
									table.remove(tFriend.chatList, tChatIdx)
									hGlobal.chatMgr:RemovePrivateMessage(msgId, inviteTag)
									
									--通知自己: 删除玩家聊天信息
									local sCmd = tostring(msgId)
									hApi.xlNet_Send(self._uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
									
									--添加一条消息
									local newMsgType = 0
									local newOpStr = ""
									if (inviteTag == hVar.PRIVATE_INVITE_TYPE.ACCEPT) then --接受
										newMsgType = hVar.MESSAGE_TYPE.PRIVATE_INVITE_ACCEPT
										newOpStr = hVar.tab_string["__TEXT_ACCEPT"]
									elseif (inviteTag == hVar.PRIVATE_INVITE_TYPE.REFUSE) then --拒绝
										newMsgType = hVar.MESSAGE_TYPE.PRIVATE_INVITE_REFUSE
										newOpStr = hVar.tab_string["__TEXT_REFUSE"]
									end
									local tMsgAut = {}
									tMsgAut.chatType = hVar.CHAT_TYPE.PRIVATE
									tMsgAut.msgType = newMsgType --私聊好友验证结果
									tMsgAut.uid = tFriendMe.touid
									tMsgAut.name = tFriendMe.toname --hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
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
									
									--添加新聊天消息
									--local chatAut = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
									local chat = hGlobal.chatMgr:AddPrivateMessage(tMsgAut)
									
									--存储新聊天消息
									tFriend.chatList[#tFriend.chatList+1] = chat
									
									--通知自己: 添加玩家聊天信息
									local sCmd = chat:ToCmd()
									--print("sCmd=", sCmd)
									hApi.xlNet_Send(self._uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
									--print("_uid=", self._uid)
									
									--更新数据库
									local strFriendInfo = self:_PrivateFriendInfoToDBCmd()
									local sUpdateCU = string.format("update `t_chat_user` set `msg_private_friend_list` = '%s' where `uid` = %d", strFriendInfo, self._uid)
									xlDb_Execute(sUpdateCU)
									--print("sUpdateCU")
									
									--对方也删除此条消息
									local tChatMe = nil
									local tChatIdxMe = 0
									local chatListMe = tFriendMe.chatList --聊天记录
									for i = #chatListMe, 1, -1 do
										if (chatListMe[i]._id == msgId) then --找到了
											tChatMe = chatListMe[i]
											tChatIdxMe = i
											break
										end
									end
									if (tChatIdxMe > 0) then
										table.remove(tFriendMe.chatList, tChatIdxMe)
									end
									--hGlobal.chatMgr:RemovePrivateMessage(msgId, inviteTag)
									
									--通知对方: 删除玩家聊天信息
									if (online == 1) then
										local sCmd = tostring(msgId)
										hApi.xlNet_Send(touid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
									end
									
									--通知对方: 添加玩家聊天信息
									if (online == 1) then
										local sCmd = chat:ToCmd()
										hApi.xlNet_Send(touid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
									end
									
									--对方也通过或被拒绝好友验证
									--通过或拒绝好友验证
									if (inviteTag == hVar.PRIVATE_INVITE_TYPE.ACCEPT) then --接受
										tFriendMe.inviteflag = hVar.PRIVATE_INVITE_TYPE.ACCEPT
									elseif (inviteTag == hVar.PRIVATE_INVITE_TYPE.REFUSE) then --被拒绝
										tFriendMe.inviteflag = hVar.PRIVATE_INVITE_TYPE.REFUSEBY
									end
									
									--对方也存储新聊天消息
									tFriendMe.chatList[#tFriendMe.chatList+1] = chat
									
									--因为有最新操作，所以我排在此好友排第一位
									if (tFriendIdxMe > 1) then
										table.remove(friendUser.msg_private_friend_chat_list, tFriendIdxMe)
										table.insert(friendUser.msg_private_friend_chat_list, 1, tFriendMe)
									end
									
									--更新好友数据库
									local strFriendInfoMe = friendUser:_PrivateFriendInfoToDBCmd()
									local sUpdateCUFriend = string.format("update `t_chat_user` set `msg_private_friend_list` = '%s' where `uid` = %d", strFriendInfoMe, friendUser._uid)
									xlDb_Execute(sUpdateCUFriend)
									--print("sUpdateCUFriend")
									
									--操作成功
									ret = 1
								else
									--对方已关闭和你的私聊
									ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_INVITE_OP_REMOVE
								end
							else
								--对方不在您的私聊列表里
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_FRIEND
							end
						else
							--无效的消息
							ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_MSGID
						end
					else
						--不能和自己私聊
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_USER_SAMEME
					end
				else
					--参数不合法
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
				end
			else
				--无效的玩家
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
			end
		else
			--玩家未初始化
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_USER_INIT
		end
		
		return ret
	end
	
	--删除私聊好友
	--返回值: 操作结果
	function User:PrivateDeleteFriend(touid)
		
		--操作结果
		local ret = 0
		
		--print("PrivateDeleteFriend", touid)
		
		if (self.msg_init_state == 1) then
			--有效的玩家uid
			if (touid > 0) then
				--好友是否在线
				local online = 1
				local friendUser = hGlobal.uMgr:FindChatUserByDBID(touid)
				if (friendUser == nil) then
					--创建一个临时的user对象，仅用于处理私聊的数据
					friendUser = hClass.User:CreateUserPrivateObject(touid)
					--print("创建一个临时的私聊邀请操作user对象", touid)
					online = 0
				end
				
				--检查此好友是否在我的私聊列表里
				--local touid = tMsgFriend.uid
				local tFriend = nil
				local tFriendIdx = 0
				for i = 1, self.msg_private_friend_count, 1 do
					local tFriend_i = self.msg_private_friend_chat_list[i]
					local friendUid = tFriend_i.touid --好友uid
					if (touid == friendUid) then
						tFriend = tFriend_i --找到了
						tFriendIdx = i
						break
					end
				end
				
				--不在我的私聊列表，不能进行操作
				if tFriend then
					--检查我是否在对方的好友列表里
					local tFriendMe = nil
					local tFriendIdxMe = 0
					if friendUser then
						for i = 1, friendUser.msg_private_friend_count, 1 do
							local tFriendMe_i = friendUser.msg_private_friend_chat_list[i]
							local touid_me_i = tFriendMe_i.touid --好友uid
							--print(i, "touid_me_i=", touid_me_i, self._uid)
							if (self._uid == touid_me_i) then
								tFriendMe = tFriendMe_i --找到了
								tFriendIdxMe = i
								break
							end
						end
					end
					
					--标记已删除
					tFriend.inviteflag = hVar.PRIVATE_INVITE_TYPE.DELETE
					
					--删除此好友
					table.remove(self.msg_private_friend_chat_list, tFriendIdx)
					
					--好友数量减1
					self.msg_private_friend_count = self.msg_private_friend_count - 1
					
					--检查我们的历史聊天记录，是否有验证类消息，删除此类型的消息
					local chatListNum = #tFriend.chatList
					for i = chatListNum, 1, -1 do
						local chat_i = tFriend.chatList[i]
						--print(i, chat_i._msgType)
						if (chat_i._msgType == hVar.MESSAGE_TYPE.PRIVATE_INVITE) then
							--删除消息
							local op_uid = hVar.PRIVATE_INVITE_TYPE.DELETE --操作者uid
							--print(chat_i:GetID(), op_uid)
							hGlobal.chatMgr:RemovePrivateMessage(chat_i:GetID(), op_uid)
							
							--从我的聊天列表里移除
							table.remove(tFriend.chatList, i)
						end
					end
					
					--更新数据库
					local strFriendInfo = self:_PrivateFriendInfoToDBCmd()
					local sUpdateCU = string.format("update `t_chat_user` set `msg_private_friend_count` = %d, `msg_private_friend_list` = '%s' where `uid` = %d", self.msg_private_friend_count, strFriendInfo, self._uid)
					xlDb_Execute(sUpdateCU)
					--print("sUpdateCU")
					
					--如果对方好友列表里有我，那么给对方发送一条消息
					if tFriendMe then
						--添加一条消息
						local tMsgAut = {}
						tMsgAut.chatType = hVar.CHAT_TYPE.PRIVATE
						tMsgAut.msgType = hVar.MESSAGE_TYPE.PRIVATE_DELETE --删除私聊好友
						tMsgAut.uid = tFriendMe.touid
						tMsgAut.name = tFriendMe.toname --hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
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
						
						--添加新聊天消息
						--local chatAut = hClass.Chat:create("Chat"):Init(id, chatType, msgType, uid, name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, content, date, touid, result, resultParam)
						local chat = hGlobal.chatMgr:AddPrivateMessage(tMsgAut)
						
						--存储聊天信息
						--要删除好友，不用添加了
						
						--对方也通知删除此我
						--通知对方: 添加一条私聊信息
						if (online == 1) then
							local sCmd = chat:ToCmd()
							hApi.xlNet_Send(touid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
						end
						
						--对方标记被我删除
						tFriendMe.inviteflag = hVar.PRIVATE_INVITE_TYPE.DELETEBY
						
						--对方也存储新聊天消息
						tFriendMe.chatList[#tFriendMe.chatList+1] = chat
						
						--检查我们的历史聊天记录，是否有验证类消息，删除此类型的消息
						local chatListNum = #tFriendMe.chatList
						for i = chatListNum, 1, -1 do
							local chat_i = tFriendMe.chatList[i]
							--print(i, chat_i._msgType, hVar.MESSAGE_TYPE.PRIVATE_INVITE)
							if (chat_i._msgType == hVar.MESSAGE_TYPE.PRIVATE_INVITE) then
								--删除消息
								--local op_uid = hVar.MESSAGE_TYPE.PRIVATE_DELETE --操作者uid
								--hGlobal.chatMgr:RemovePrivateMessage(chat_i:GetID(), op_uid)
								
								--从对方的聊天列表里移除
								table.remove(tFriendMe.chatList, i)
								--print("从对方的聊天列表里移除", chat_i:GetID(), chat._touid)
								
								--通知好友: 删除玩家验证类聊天信息
								local sCmd = tostring(chat_i:GetID())
								hApi.xlNet_Send(chat._touid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
							end
						end
						
						--对方消息数量超过私聊上限，删除第一条消息
						if (#tFriendMe.chatList > hVar.CHAT_MAX_LENGTH_PRIVATE) then
							--移除消息
							local msgId = tFriendMe.chatList[1]:GetID()
							table.remove(tFriendMe.chatList, 1)
							
							--通知好友: 删除玩家聊天信息
							local sCmd = tostring(msgId)
							hApi.xlNet_Send(chat._touid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
						end
						
						--更新好友数据库
						local strFriendInfoMe = friendUser:_PrivateFriendInfoToDBCmd()
						local sUpdateCUFriend = string.format("update `t_chat_user` set `msg_private_friend_list` = '%s' where `uid` = %d", strFriendInfoMe, friendUser._uid)
						xlDb_Execute(sUpdateCUFriend)
						--print("sUpdateCUFriend")
					end
					
					--操作成功
					ret = 1
				else
					--对方不在您的私聊列表里
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_CHAT_PRIVATE_FRIEND
				end
			else
				--无效的玩家
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
			end
		else
			--玩家未初始化
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_USER_INIT
		end
		
		return ret
	end
	
	--删除私聊消息
	function User:PrivateDeleteMsg(msgId)
		--操作结果
		local ret = 0
		
		--print("PrivateDeleteMsg", msgId)
		
		if (self.msg_init_state == 1) then
			for i = 1, self.msg_private_friend_count, 1 do
				local tFriend_i = self.msg_private_friend_chat_list[i]
				local chatList = tFriend_i.chatList --与该好友的聊天列表
				--依次查找id
				for j = 1, #chatList, 1 do
					local chat = chatList[j]
					if (chat:GetID() == msgId) then --找到了
						--删除此条消息
						table.remove(chatList, j)
						
						--从数据库移除聊天消息
						--local sDelete = string.format("delete from `chat` where `id` = %d", msgId)
						local sDelete = string.format("update `chat` set `deleteflag` = 1, `delete_op_uid` = %d where `id` = %d", self:GetUID(), msgId)
						xlDb_Execute(sDelete)
						
						--操作成功
						ret = 1
						
						break
					end
				end
			end
		end
		
		return ret
	end
	
	--玩家聊天基础信息转cmd
	function User:ChatBaseInfoToCmd()
		local version = hGlobal.chatMgr:GetVersion() --获得正式版本号
		local debug_version = hGlobal.chatMgr:GetDebugVersion() --获得测试员版本号
		local world_flag = hGlobal.chatMgr:GetWorldFlag() --获得世界聊天开关状态
		local last_world_msgid = hGlobal.chatMgr:GetLastWorldMsgId() --最近一条世界消息id
		local last_group_msgid = hGlobal.chatMgr:GetLastGroupMsgId(self._uid) --最近一条军团消息id
		local sWorldTime = os.date("%Y-%m-%d %H:%M:%S", self.msg_world_timestamp)
		local sForbiddenTime = os.date("%Y-%m-%d %H:%M:%S", self.forbidden_timestamp)
		local sSendRedPacketTime = os.date("%Y-%m-%d %H:%M:%S", self.group_send_packet_timestamp)
		local groupId = hGlobal.groupMgr:GetUserGroupID(self._uid) --玩家所在的工会id
		local groupLevel = hGlobal.groupMgr:GetUserGroupLevel(self._uid) --玩家所在的工会权限
		local sCmd = tostring(version) .. ";" .. tostring(debug_version) .. ";" .. tostring(world_flag) .. ";" .. tostring(self.msg_world_num)
						.. ";" .. tostring(sWorldTime) ..";" .. tostring(last_world_msgid) .. ";" .. tostring(last_group_msgid)
						.. ";" .. tostring(self.forbidden) .. ";" .. tostring(sForbiddenTime) .. ";" .. tostring(self.forbidden_minute)
						.. ";" .. tostring(self.forbidden_op_uid) .. ";" .. tostring(groupId) .. ";" .. tostring(groupLevel)
						.. ";"
		--读取全部军团邀请函的id
		local inviteGroupList = hGlobal.inviteGroupMgr:GetInviteGroupList()
		sCmd = sCmd .. tostring(#inviteGroupList) .. ";"
		for _, inviteGroup in ipairs(inviteGroupList) do
			local msg_id = inviteGroup._msg_id
			sCmd = sCmd .. tostring(msg_id) .. ";"
		end
		
		--读取全部组队副本邀请消息
		local inviteBattleChatList = hGlobal.chatMgr._inviteBattleChatList
		sCmd = sCmd .. tostring(#inviteBattleChatList) .. ";"
		for _, chat in ipairs(inviteBattleChatList) do
			local msg_id = chat:GetID()
			--print(msg_id)
			sCmd = sCmd .. tostring(msg_id) .. ";"
		end
		
		--玩家私聊信息
		sCmd = sCmd .. tostring(self.msg_private_friend_count) .. ";"
		for i = 1, self.msg_private_friend_count, 1 do
			local tFriend = self.msg_private_friend_chat_list[i]
			local touid = tFriend.touid --好友uid
			local online = 0 --好友是否在线
			local friendUser = hGlobal.uMgr:FindChatUserByDBID(touid)
			if friendUser then
				online = 1
			end
			local lastMsgId = 0 --与玩家的最后一条消息id
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
	
	--玩家与私聊好友的聊天id转cmd
	function User:ChatFriendMsgIdToCmd(friendUid)
		local tFriend = nil
		--print("玩家与私聊好友的聊天id转cmd", friendUid, "self.msg_private_friend_count=", self.msg_private_friend_count)
		for i = 1, self.msg_private_friend_count, 1 do
			local tFriend_i = self.msg_private_friend_chat_list[i]
			local touid = tFriend_i.touid --好友uid
			--print(i, "touid=", touid)
			if (touid == friendUid) then
				tFriend = tFriend_i --找到了
				break
			end
		end
		
		--消息总数量
		local NUM = 0
		local sCmd = ""
		local snum = 0 --有效的消息数量
		if tFriend then
			NUM = #tFriend.chatList
			--print(i, "NUM=", NUM)
		end
		
		--依次拼接id
		for i = 1, NUM, 1 do
			local chat = tFriend.chatList[i]
			--print("chat", i)
			if (chat._chatType == hVar.CHAT_TYPE.PRIVATE) then --只处理私聊频道
				local tempStr = tostring(chat._id) .. ";"
				sCmd = sCmd .. tempStr
				snum = snum + 1
				--print("私聊消息" .. i, chat._id)
			end
		end
		
		sCmd = tostring(snum) .. ";" .. sCmd
		--print("sCmd=", sCmd)
		
		return sCmd
	end
	
	--将全部私聊好友信息转数据库存储的cmd
	function User:_PrivateFriendInfoToDBCmd()
		--80067930|1||三斤金嗓子|1|2|0|19|;21000002|小霸王小霸王2|0|100|7|1111111|2|;
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
	
	--将单个私聊好友信息转cmd
	function User:SingleFriendInfoToCmd(friendUid)
		--80067930|1||三斤金嗓子|1|2|0|19|;21000002|小霸王小霸王2|0|100|7|1111111|2|;
		local sCmd = ""
		local tFriend = nil
		--print("self.msg_private_friend_count=", self.msg_private_friend_count)
		for i = 1, self.msg_private_friend_count, 1 do
			local tFriend_i = self.msg_private_friend_chat_list[i]
			local touid = tFriend_i.touid --好友uid
			--print(i, "touid=", touid)
			if (touid == friendUid) then
				tFriend = tFriend_i --找到了
				break
			end
		end
		
		if tFriend then
			local online = 0 --好友是否在线
			local friendUser = hGlobal.uMgr:FindChatUserByDBID(friendUid)
			if friendUser then
				online = 1
			end
			
			local lastMsgId = 0 --与玩家的最后一条消息id
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




