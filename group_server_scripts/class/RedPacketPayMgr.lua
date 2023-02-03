--支付（土豪）红包管理类
local RedPacketPayMgr = class("RedPacketPayMgr")
	--支付（土豪）系统红包发放时间（每日）
	RedPacketPayMgr.SYSTEM_REDPACKET_TIME_EVERYDAY =
	{
		--[[
		{
			time = "12:00:00",
			num = 30,
			title = hVar.tab_string["__TEXT_CHAT_PAY_REDPACKET_12"], --"  午间红包福利",
		},
		{
			time = "18:00:00",
			num = 30,
			title = hVar.tab_string["__TEXT_CHAT_PAY_REDPACKET_18"], --"  晚间红包福利",
		},
		{
			time = "21:00:00",
			num = 30,
			title = hVar.tab_string["__TEXT_CHAT_PAY_REDPACKET_21"], --"  夜间红包福利",
		},
		]]
	}
	
	--支付（土豪）系统红包发放时间（指定日期）
	RedPacketPayMgr.SYSTEM_REDPACKET_TIME =
	{
		{
			date = "2022-01-30 00:00:00", --日期
			num = 88, --红包数量
			title = "  新年快乐，虎年大吉",
		},
		{
			date = "2022-01-31 00:00:00", --日期
			num = 88, --红包数量
			title = "  新年快乐，虎年大吉",
		},
		{
			date = "2022-02-01 00:00:00", --日期
			num = 88, --红包数量
			title = "  新年快乐，虎年大吉",
		},
		{
			date = "2022-02-02 00:00:00", --日期
			num = 88, --红包数量
			title = "  新年快乐，虎年大吉",
		},
		{
			date = "2022-02-03 00:00:00", --日期
			num = 88, --红包数量
			title = "  新年快乐，虎年大吉",
		},
		{
			date = "2022-02-04 00:00:00", --日期
			num = 88, --红包数量
			title = "  新年快乐，虎年大吉",
		},
		{
			date = "2022-02-05 00:00:00", --日期
			num = 88, --红包数量
			title = "  新年快乐，虎年大吉",
		},
		{
			date = "2022-02-06 00:00:00", --日期
			num = 88, --红包数量
			title = "  新年快乐，虎年大吉",
		},
	}
	
	--构造函数
	function RedPacketPayMgr:ctor()
		self._redpacketpayDBID = -1 --支付（土豪）发红包数据库id
		
		self._redpacketreceivepayDBID = -1 --支付（土豪）收红包数据库id
		
		self._redPacketPayDictionary = -1 --支付（土豪）红包表
		self._redPacketReceivePayDictionary = -1 --支付（土豪）红包接收表
		
		--其他
		self._statisticsTime = -1	--统计计时
		self._statisticsTimestamp = -1	--上次统计时间
		self._statisticsTimeWorldSend = -1	--统计计时
		self._statisticsTimestampWorldSend = -1	--上次统计时间
		
		return self
	end
	
	--初始化
	function RedPacketPayMgr:Init()
		--初始表
		self._redPacketPayDictionary = {}
		self._redPacketReceivePayDictionary = {}
		
		--读取支付（土豪）发红包数据库id
		local err1, pid = xlDb_Query("SELECT IFNULL(MAX(id), 0) FROM `chat_redpacket_pay`;")
		--print("max(id)", err1, pid)
		if (err1 == 0) then
			self._redpacketpayDBID = pid
		else
			self._redpacketpayDBID = 0
		end
		
		--读取支付（土豪）收红包数据库id
		local err1, pid = xlDb_Query("SELECT IFNULL(MAX(id), 0) FROM `chat_redpacket_receive_pay`;")
		--print("max(id)", err1, pid)
		if (err1 == 0) then
			self._redpacketreceivepayDBID = pid
		else
			self._redpacketreceivepayDBID = 0
		end
		
		--从数据库读取全部未过期的支付（土豪）红包信息
		local sDateNow = os.date("%Y-%m-%d %H:%M:%S", os.time())
		local sQueryM = string.format("SELECT `id`, `send_uid`, `send_name`, `send_num`, `content`, `money`, `iap_id`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `msg_id`, `receive_num`, `send_time`, `expire_time` FROM `chat_redpacket_pay` WHERE `expire_time` > '%s'", sDateNow)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print("从数据库读取全部未过期的支付（土豪）红包信息:", "errM=", errM, "tTemp=", #tTemp)
		if (errM == 0) then
			--逆向初始化
			for n = #tTemp, 1, -1 do
				local id = tTemp[n][1] --红包唯一id
				local send_uid = tTemp[n][2] --红包发送者uid
				local send_name = tTemp[n][3] --红包发送者名字
				local send_num = tTemp[n][4] --红包发送数量
				local content = tTemp[n][5] --内容
				local money = tTemp[n][6] --充值金额
				local iap_id = tTemp[n][7] --充值记录id
				local channelId = tTemp[n][8] --渠道号
				local vip = tTemp[n][9] --vip等级
				local borderId = tTemp[n][10] --边框id
				local iconId = tTemp[n][11] --头像id
				local championId = tTemp[n][12] --称号id
				local leaderId = tTemp[n][13] --会长权限
				local dragonId = tTemp[n][14] --聊天龙王id
				local headId = tTemp[n][15] --头衔id
				local lineId = tTemp[n][16] --线索id
				local msg_id = tTemp[n][17] --消息id
				local receive_num = tTemp[n][18] --红包接收数量
				local send_time = tTemp[n][19] --红包发送时间
				local expire_time = tTemp[n][20] --红包过期时间
				
				--添加支付（土豪）红包信息
				local redPacketPay = hClass.RedPacketPay:create("RedPacketPay"):Init(id, send_uid, send_name, send_num, content, money, iap_id, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, msg_id, receive_num, send_time, expire_time)
				self._redPacketPayDictionary[id] = redPacketPay
				
				--支付（土豪）红包领取信息表定义
				self._redPacketReceivePayDictionary[id] = {}
			end
		end
		
		--从数据库读取全部未过期的支付（土豪）红包领取信息
		local sQueryM = string.format("SELECT `id`, `redpacket_id`, `receive_uid`, `receive_name`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `msg_id`, `receive_num`, `prize`, `receive_time` FROM `chat_redpacket_receive_pay` WHERE `redpacket_id` in (select `id` from `chat_redpacket_pay` where `expire_time` > '%s')", sDateNow)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("从数据库读取全部未过期的支付（土豪）红包领取信息:", "errM=", errM, "tTemp=", tTemp and #tTemp)
		if (errM == 0) then
			--逆向初始化
			for n = #tTemp, 1, -1 do
				local id = tTemp[n][1] --领取id
				local redpacket_id = tTemp[n][2] --红包唯一id
				local receive_uid = tTemp[n][3] --接收者uid
				local receive_name = tTemp[n][4] --接收者名字
				local channelId = tTemp[n][5] --渠道号
				local vip = tTemp[n][6] --vip等级
				local borderId = tTemp[n][7] --边框id
				local iconId = tTemp[n][8] --头像id
				local championId = tTemp[n][9] --称号id
				local leaderId = tTemp[n][10] --会长权限
				local dragonId = tTemp[n][11] --聊天龙王id
				local headId = tTemp[n][12] --头衔id
				local lineId = tTemp[n][13] --线索id
				local msg_id = tTemp[n][14] --消息id
				local receive_num = tTemp[n][15] --接收数量
				local prize = tTemp[n][16] --奖励
				local receive_time = tTemp[n][17] --接收时间
				--print(id, redpacket_id, receive_uid, receive_name, channelId, vip, borderId, iconId, championId, leaderId, dragonId, headId, lineId, msg_id, receive_num, prize, receive_time)
				
				--支付（土豪）红包领取信息
				self._redPacketReceivePayDictionary[redpacket_id][receive_uid] = {id = id, redpacket_id = redpacket_id, receive_uid = receive_uid, receive_name = receive_name, channelId = channelId, vip = vip, borderId = borderId, iconId = iconId, championId = championId, leaderId = leaderId, dragonId = dragonId, headId = headId, lineId = lineId, msg_id = msg_id, receive_num = receive_num, prize = prize, receive_time = receive_time,}
			end
		end
		
		--其他
		self._statisticsTime = hApi.GetClock()	--统计计时
		self._statisticsTimestamp = os.time()	--上次统计时间
		self._statisticsTimeWorldSend = hApi.GetClock()	--统计计时
		self._statisticsTimestampWorldSend = os.time()	--上次统计时间
		
		return self
	end
	
	--release
	function RedPacketPayMgr:Release()
		self._redpacketpayDBID = -1 --支付（土豪）发红包数据库id
		
		self._redpacketreceivepayDBID = -1 --支付（土豪）收红包数据库id
		
		self._redPacketPayDictionary = -1 --支付（土豪）红包表
		self._redPacketReceivePayDictionary = -1 --支付（土豪）红包接收表
		
		--其他
		self._statisticsTime = -1	--统计计时
		self._statisticsTimestamp = -1	--上次统计时间
		self._statisticsTimeWorldSend = -1	--统计计时
		self._statisticsTimestampWorldSend = -1	--上次统计时间
		
		return self
	end
	
	--获取支付（土豪）发红包数据库id
	function RedPacketPayMgr:GetSendDBID()
		return self._redpacketpayDBID
	end
	
	--获取支付（土豪）收红包数据库id
	function RedPacketPayMgr:GetReceiveDBID()
		return self._redpacketreceivepayDBID
	end
	
	--获取支付（土豪）红包信息表
	function RedPacketPayMgr:GetRedPacketList()
		return self._redPacketPayDictionary
	end
	
	--获取支付（土豪）指定id的红包信息
	function RedPacketPayMgr:GetRedPacket(redPacketId)
		return self._redPacketPayDictionary[redPacketId]
	end
	
	--获取支付（土豪）红包接收信息表
	function RedPacketPayMgr:GetRedPacketReceiveList()
		return self._redPacketReceivePayDictionary
	end
	
	--获取指定id支付（土豪）红包的接收信息
	function RedPacketPayMgr:GetRedPacketReceive(redPacketId)
		return self._redPacketReceivePayDictionary[redPacketId]
	end
	
	--请求发送支付（土豪）红包
	function RedPacketPayMgr:SendRedPacket(uid, money, sendNum, content)
		local ret = 0
		local sRetCmd = ""
		
		--红包数量大于0
		if (sendNum > 0) then
			--查询玩家的相关信息
			local vipLv = hGlobal.vipMgr:DBGetUserVip(uid) --玩家vip等级
			local groupLevel = hGlobal.groupMgr:GetUserGroupLevel(uid) --玩家所在的工会权限
			local sQueryM = string.format("SELECT `customS1`, `channel_id`, `border`, `icon`, `champion`, `champion_expire_time`, `dragon`, `dragon_expire_time`, `head`, `line` FROM `t_user` WHERE `uid` = %d", uid)
			local errM, customS1, channelId, borderId, iconId, champion, champion_expire_time, dragon, dragon_expire_time, headId, lineId = xlDb_Query(sQueryM)
			local championId = 0
			local dragonId = 0
			if (errM == 0) then
				--检测称号是否过期
				if (champion > 0) then
					local currenttime = os.time()
					local nExpireTime = hApi.GetNewDate(champion_expire_time)
					
					--未过期
					if (currenttime < nExpireTime) then
						championId = champion
					end
				end
				
				--检测聊天龙王是否过期
				if (dragon > 0) then
					local currenttime = os.time()
					local nExpireTime = hApi.GetNewDate(dragon_expire_time)
					
					--未过期
					if (currenttime < nExpireTime) then
						dragonId = dragon
					end
				end
				
				--发送世界消息
				local tMsg = {}
				tMsg.chatType = hVar.CHAT_TYPE.WORLD --世界聊天频道
				tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND --发支付（土豪）红包
				tMsg.uid = uid
				tMsg.name = customS1
				tMsg.channelId = channelId
				tMsg.vip = vipLv
				tMsg.borderId = borderId
				tMsg.iconId = iconId
				tMsg.championId = championId
				tMsg.leaderId = groupLevel
				tMsg.dragonId = dragonId
				tMsg.headId = headId
				tMsg.lineId = lineId
				tMsg.content = content
				tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
				tMsg.touid = 0
				tMsg.result = hVar.RED_PACKET_TYPE.PAY_SEND --可交互事件的交互类型
				tMsg.resultParam = 0
				
				--支付（土豪）红包发送id自增
				self._redpacketpayDBID = self._redpacketpayDBID + 1
				
				--可交互事件的参数
				tMsg.resultParam = self._redpacketpayDBID
				
				--支付（土豪）红包失效时间
				local sDateNow = os.date("%Y-%m-%d %H:%M:%S", os.time())
				local nExpireTime = hApi.GetNewDate(sDateNow, "HOUR", hVar.CHAT_PAY_RED_PACKET_EXPIRETIME)
				local sExpireTime = os.date("%Y-%m-%d %H:%M:%S", nExpireTime)
				
				--充值记录id
				local iap_id = 0
				if (money > 0) then
					local sQueryI = string.format("SELECT `id` FROM `iap_record` WHERE `uid` = %d and `money` = %d order by `id` desc limit 1", uid, money)
					local errI, i_id = xlDb_Query(sQueryM)
					if (errI == 0) then
						iap_id = i_id
					end
				end
				
				--消息id
				local msgId = hGlobal.chatMgr:GetMsgDBID() + 1
				--local content = string.format(hVar.tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET"], customS1, money)
				
				--插入支付（土豪）红包
				local sqlUpdate = string.format("insert into `chat_redpacket_pay`(`id`, `send_uid`, `send_name`, `send_num`, `content`, `money`, `iap_id`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `msg_id`, `receive_num`, `send_time`, `expire_time`) values (%d, %d, '%s', %d, '%s', %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, NOW(), '%s')", self._redpacketpayDBID, uid, customS1, sendNum, content, money, iap_id, channelId, vipLv, borderId, iconId, championId, groupLevel, dragonId, headId, lineId, msgId, 0, sExpireTime)
				xlDb_Execute(sqlUpdate)
				--print(sqlUpdate)
				
				--内存增加支付（土豪）红包信息
				local redPacketPay = hClass.RedPacketPay:create("RedPacketPay"):Init(self._redpacketpayDBID, uid, customS1, sendNum, content, money, iap_id, channelId, vipLv, borderId, iconId, championId, groupLevel, dragonId, headId, lineId, msgId, 0, sDateNow, sExpireTime)
				self._redPacketPayDictionary[self._redpacketpayDBID] = redPacketPay
				
				--支付（土豪）红包领取信息表定义
				self._redPacketReceivePayDictionary[self._redpacketpayDBID] = {}
				
				--发送世界消息
				local ret_send, chat = hGlobal.chatMgr:AddMessage(nil, tMsg)
				if (ret_send == 1) then --操作成功
					--全服通知消息: 玩家聊天信息
					local alludbid = hGlobal.uMgr:GetAllUserUID()
					local sCmd = chat:ToCmd()
					hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
				end
				
				--操作成功
				ret = 1
			else
				--"无效的玩家"
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
			end
		else
			--"参数不合法"
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
		end
		
		--字符串拼接
		sRetCmd = tostring(ret) .. ";" .. sRetCmd
		
		return ret, sRetCmd
	end
	
	--请求领取支付（土豪）红包
	function RedPacketPayMgr:ReceiveRedPacket(user, rid, redPacketId, tMsg)
		local ret = 0
		local sRetCmd = ""
		
		--检测玩家是否为禁言状态
		local forbidden = 0
		if user then
			forbidden = user:GetForbidden()
		end
		local uid = user:GetUID()
		if (forbidden == 0) then
			--红包信息
			local redPacketPay = self:GetRedPacket(redPacketId)
			if redPacketPay then
				local send_num = redPacketPay._send_num --红包发送数量
				local receive_num = redPacketPay._receive_num --红包接收数量
				
				--未全部领完
				if (receive_num < send_num) then
					--玩家未领取此支付（土豪）红包
					if (not self._redPacketReceivePayDictionary[redPacketId][uid]) then
						--生成此支付（土豪）红包的随机奖励
						local tReward = {}
						
						--计算每个奖励的区间
						local rewardList = hVar.PAY_RED_PACKET_REWARDLIST
						local rewardRange = {}
						local r = 0
						for i = 1, #rewardList, 1 do
							local probablity = rewardList[i].probablity --本档几率
							rewardRange[i] = {min = r, max = r + probablity - 1,}
							r = r + probablity
							--print("i=" .. i, "min=" .. rewardRange[i].min, "max=" .. rewardRange[i].max)
						end
						
						--随机数的最大值
						local RANDMAX = r - 1
						--print("RANDMAX=", RANDMAX)
						
						--生成随机数
						local rand = math.random(0, RANDMAX)
						--print("rand=", rand)
						
						--找出奖励表
						local rewardIdx = 0
						for i = 1, #rewardRange, 1 do
							local tRange = rewardRange[i]
							if (rand >= tRange.min) and (rand <= tRange.max) then --找到了
								rewardIdx = i
								break
							end
						end
						
						--奖励表
						local rewardTable = rewardList[rewardIdx].reward
						tReward[#tReward+1] = rewardTable.param1 --奖励参数1
						tReward[#tReward+1] = rewardTable.param2 --奖励参数2
						tReward[#tReward+1] = rewardTable.param3 --奖励参数3
						tReward[#tReward+1] = rewardTable.param4 --奖励参数4
						
						--GM测试
						--if (user:GetTester() == 2) then
						--	tReward = {10, 12406, 0, 0,}
						--end
						
						--处理表类型的参数，转为整数值
						for t = 1, #tReward, 1 do
							local param = tReward[t]
							if (type(param) == "table") then
								--{probablity = 1, value = 10,},
								--{probablity = 2, value = 20,},
								--...
								local paramRange = {}
								local r = 0
								for i = 1, #param, 1 do
									local probablity = param[i].probablity --本档几率
									paramRange[i] = {min = r, max = r + probablity - 1,}
									r = r + probablity
									--print("i=" .. i, "min=" .. paramRange[i].min, "max=" .. paramRange[i].max)
								end
								
								--随机数的最大值
								local PARAMMAX = r - 1
								--print("PARAMMAX=", PARAMMAX)
								
								--生成随机数
								local rand = math.random(0, PARAMMAX)
								--print("rand=", rand)
								
								--找出参数表
								local paramIdx = 0
								for i = 1, #paramRange, 1 do
									local tRange = paramRange[i]
									if (rand >= tRange.min) and (rand <= tRange.max) then --找到了
										paramIdx = i
										break
									end
								end
								
								--转为整数
								tReward[t] = param[paramIdx].value
								--print(t, tReward[t])
							else
								--print(t, tReward[t])
							end
						end
						
						--发奖
						local reward = hClass.Reward:create():Init()
						reward:Add(tReward)
						reward:TakeReward(uid, rid, nil, hVar.tab_string["__TEXT_WORLD_REDPACKET"])
						
						--支付（土豪）资源类型，插入日志
						local rewardType = tReward[1]
						if (rewardType == 16) or (rewardType == 17) or (rewardType == 18) or (rewardType == 20) then --geyachao: 新加房间的配置项 支付（土豪）
							local iron_donate_num = 0 --增加的铁
							local wood_donate_num = 0 --增加的木材
							local food_donate_num = 0 --增加的粮食
							local group_coin_num = 0 --增加的支付（土豪）币
						
							local rewardNum = tReward[2]
								
							if (rewardType == 16) then --16:铁 --geyachao: 新加房间的配置项 支付（土豪）
								iron_donate_num = iron_donate_num + rewardNum
							elseif (rewardType == 17) then --17:木材 --geyachao: 新加房间的配置项 支付（土豪）
								wood_donate_num = wood_donate_num + rewardNum
							elseif (rewardType == 18) then --18:粮食 --geyachao: 新加房间的配置项 支付（土豪）
								food_donate_num = food_donate_num + rewardNum
							elseif (rewardType == 20) then --20:支付（土豪）币 --geyachao: 新加房间的配置项 支付（土豪）
								group_coin_num = group_coin_num + rewardNum
							end
							
							--更新资源日志
							local groupId = hGlobal.groupMgr:GetUserGroupID(uid) --玩家所在的工会id
							if (groupId > 0) then
								local sSql = string.format("INSERT INTO `novicecamp_member_donate_log` (`uid`, `ncid`, `itemname`, `channelId`, `redpacket_id`, `mat_iron_donate`, `mat_wood_donate`, `mat_food_donate`, `group_coin`, `time`) VALUES (%d, %d, '%s', %d, %d, %d, %d, %d, %d, NOW())", uid, groupId, hVar.tab_string["__TEXT_WORLD_REDPACKET"], tMsg.channelId, redPacketId, iron_donate_num, wood_donate_num, food_donate_num, group_coin_num)
								--print(sSql)
								xlDb_Execute(sSql)
							end
							
							--更新资源个人表
							if (groupId > 0) then
								if (iron_donate_num > 0) or (wood_donate_num > 0) or (food_donate_num > 0) then
									local sUpdate = string.format("update `novicecamp_member` set `mat_iron_donate_sum` = `mat_iron_donate_sum` + %d, `mat_wood_donate_sum` = `mat_wood_donate_sum` + %d, `mat_food_donate_sum` = `mat_food_donate_sum` + %d where `uid` = %d", iron_donate_num, wood_donate_num, food_donate_num, uid)
									xlDb_Execute(sUpdate)
								end
							end
							
							--记录玩家本周军团捐献总和（世界领红包）
							if (groupId > 0) then
								if (iron_donate_num > 0) or (wood_donate_num > 0) or (food_donate_num > 0) then
									--本次声望
									local shengwang = iron_donate_num * 2 + wood_donate_num + food_donate_num
									
									--更新个人表
									if (shengwang > 0) then
										local sUpdate = string.format("update `novicecamp_member` set `shengwang_week` = `shengwang_week` + %d where `uid` = %d", shengwang, uid)
										xlDb_Execute(sUpdate)
									end
									
									--更新军团表
									if (shengwang > 0) then
										local sUpdate = string.format("update `novicecamp_list` set `shengwang_week_sum` = `shengwang_week_sum` + %d where `id` = %d", shengwang, groupId)
										xlDb_Execute(sUpdate)
									end
								end
							end
						end
						
						--奖励信息
						local strReward = reward:ToCmd()
						
						--支付（土豪）红包领取id自增
						self._redpacketreceivepayDBID = self._redpacketreceivepayDBID + 1
						
						--可交互事件的参数
						tMsg.resultParam = self._redpacketreceivepayDBID
						
						--[[
						--消息id
						local msgId = hGlobal.chatMgr:GetMsgDBID() + 1
						]]
						--geyachao: 不发消息了，id为0
						local msgId = 0
						
						--更新内存支付（土豪）红包领取数量
						redPacketPay._receive_num = redPacketPay._receive_num + 1
						
						--更新数据库支付（土豪）红包领取数量
						local sDateNow = os.date("%Y-%m-%d %H:%M:%S", os.time())
						if (redPacketPay._receive_num >= send_num) then
							--红包全部领完，同时更新红包的失效时间
							local nExpireTime = hApi.GetNewDate(sDateNow, "HOUR", hVar.CHAT_PAY_RED_PACKET_EMPTY_EXPIRETIME)
							local sExpireTime = os.date("%Y-%m-%d %H:%M:%S", nExpireTime)
							
							--更新内存值
							redPacketPay._expire_time = sExpireTime
							
							--更新红包失效时间
							local sqlUpdate = string.format("update `chat_redpacket_pay` set `receive_num` = `receive_num` + 1, `expire_time`  = '%s' where `id` = %d", sExpireTime, redPacketId)
							xlDb_Execute(sqlUpdate)
						else
							--红包未领完
							local sqlUpdate = string.format("update `chat_redpacket_pay` set `receive_num` = `receive_num` + 1 where `id` = %d", redPacketId)
							xlDb_Execute(sqlUpdate)
						end
						
						--插入红包领取表
						local sqlUpdate = string.format("insert into `chat_redpacket_receive_pay`(`id`, `redpacket_id`, `receive_uid`, `receive_name`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `msg_id`, `receive_num`, `prize`, `receive_time`) values (%d, %d, %d, '%s', %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, '%s', NOW())", self._redpacketreceivepayDBID, redPacketId, uid, tMsg.name, tMsg.channelId, tMsg.vip, tMsg.borderId, tMsg.iconId, tMsg.championId, tMsg.leaderId, tMsg.dragonId, tMsg.headId, tMsg.lineId, msgId, 1, strReward)
						xlDb_Execute(sqlUpdate)
						--print(sqlUpdate)
						
						--内存增加红包领取信息
						local tReceive =
						{
							id = self._redpacketreceivepayDBID,
							redpacket_id = redPacketId,
							receive_uid = uid,
							receive_name = tMsg.name,
							channelId = tMsg.channelId,
							vip =  tMsg.vip,
							borderId = tMsg.borderId,
							iconId = tMsg.iconId,
							championId = tMsg.championId,
							leaderId = tMsg.leaderId,
							dragonId = tMsg.dragonId,
							headId = tMsg.headId,
							lineId = tMsg.lineId,
							msg_id = msgId,
							receive_num = 1,
							prize = strReward,
							receive_time = sDateNow,
						}
						--红包领取信息表
						self._redPacketReceivePayDictionary[redPacketId][uid] = tReceive
						
						--插入订单信息
						--新的购买记录插入到order表
						local itemId = 9945
						local sItemName = hVar.tab_stringI[itemId]
						local sUpdateOrder = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,uid,rid,itemId,1,sItemName,0,0,strReward)
						--print("sUpdateOrder:",sUpdate)
						xlDb_Execute(sUpdateOrder)
						
						local orderId = 0 --订单id
						local err1, oId = xlDb_Query("select last_insert_id()")
						--print("err1,orderId:",err1,orderId)
						if err1 == 0 then
							orderId = oId
						else
							--
						end
						
						--[[
						--更新消息的支付（土豪）红包领取字符串
						local strItemRewardInfo = hApi.GetRewardInfo(tReward)
						if (redPacketPay._receive_num >= send_num) then --已被领完
							tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_RECEIVE_EMPTY_REDPACKET"], tMsg.name, redPacketPay._send_name, strItemRewardInfo)
						else
							tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_RECEIVE_REDPACKET"], tMsg.name, redPacketPay._send_name, strItemRewardInfo)
						end
						tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
						tMsg.uid = 0
						tMsg.channelId = 0 --channelId
						tMsg.vip = 0 --vipLv
						tMsg.borderId = 1000 --borderId
						tMsg.iconId = 1000 --iconId
						tMsg.championId = 0 --championId
						tMsg.leaderId = 0 --leaderId
						tMsg.dragonId = 0 --dragonId
						tMsg.headId = 0 --headId
						tMsg.lineId = 0 --lineId
						
						--发送世界消息
						local ret_send, chat = hGlobal.chatMgr:AddMessage(nil, tMsg)
						if (ret_send == 1) then --操作成功
							--全服通知消息: 玩家聊天信息
							local alludbid = hGlobal.uMgr:GetAllUserUID()
							local sCmd = chat:ToCmd()
							hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
						end
						]]
						--geyachao: 不发消息了，不用更新
						--...
						
						--支付（土豪）红包领取记录
						sRetCmd = orderId .. ";" .. strReward
						
						--操作成功
						ret = 1
					else
						--"您已领取过该红包"
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_PAY_RED_PACKET_RECEIVE_MAXCOUNT
					end
				else
					--"该红包已全部领完"
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_PAY_RECEIVE_RED_PACKET_EMYPT
				end
			else
				--"该红包不存在或已过期"
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_PAY_RED_PACKET_INVALID
			end
		else
			--"您被禁言无法领取红包"
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_PAY_RED_PACKET_RECEIVE_FORBIDDEN
		end
		
		--字符串拼接
		sRetCmd = tostring(ret) .. ";" .. sRetCmd
		
		--返回值
		return ret, sRetCmd
	end
	
	--请求查看支付（土豪）的领取详情
	function RedPacketPayMgr:ViewDetailRedPacket(user, rid, redPacketId)
		local ret = 0
		local sRetCmd = ""
		
		--红包信息
		local redPacketPay = self:GetRedPacket(redPacketId)
		if redPacketPay then
			--支付（土豪）红包信息
			local strRedPacketInfo = redPacketPay:ToCmd()
			--print(strRedPacketInfo)
			
			--支付（土豪）红包接收信息
			local tReceive = self:GetRedPacketReceive(redPacketId)
			local tReceiveArray = {}
			for receive_uid, receiveInfo in pairs(tReceive) do
				tReceiveArray[#tReceiveArray+1] = receiveInfo
			end
			
			--按领取id从大到小排序
			table.sort(tReceiveArray, function(ta, tb)
				return (ta.id > tb.id)
			end)
			
			--依次输出领取信息
			local strRedPacketReceiveInfo = ""
			for i = 1, #tReceiveArray, 1 do
				local tInfo = tReceiveArray[i]
				strRedPacketReceiveInfo = strRedPacketReceiveInfo .. tInfo.id .. ";" .. tInfo.redpacket_id .. ";" .. tInfo.receive_uid .. ";" .. tInfo.receive_name
							.. ";" .. tInfo.channelId .. ";" .. tInfo.vip .. ";" .. tInfo.borderId .. ";" .. tInfo.iconId .. ";" .. tInfo.championId
							.. ";" .. tInfo.leaderId .. ";" .. tInfo.dragonId .. ";" .. tInfo.headId .. ";" .. tInfo.lineId
							.. ";" .. tInfo.msg_id .. ";" .. tInfo.prize .. tInfo.receive_time .. ";"
			end
			
			--操作成功
			ret = 1
			
			--返回值
			sRetCmd = tostring(ret) .. ";" .. strRedPacketInfo .. ";" .. strRedPacketReceiveInfo
		else
			--"该红包不存在或已过期"
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_PAY_RED_PACKET_INVALID
		end
		
		--返回值
		--print(sRetCmd)
		return ret, sRetCmd
	end
	
	--支付（土豪）红包更新(1秒)
	function RedPacketPayMgr:Update()
		local self = hGlobal.redPacketPayMgr --self
		
		--输出信息
		local timeNow = hApi.GetClock()
		if (self._statisticsTime > -1) and (timeNow - self._statisticsTime > 1000) then
			local lasttimestamp = self._statisticsTimestamp
			local currenttimestamp = os.time()
			
			self._statisticsTime = timeNow
			self._statisticsTimestamp = currenttimestamp
			
			--检测是否有过期的红包
			local currenttime = os.time()
			for _, redPacketPay in pairs(self._redPacketPayDictionary) do
				--local redPacketPay = self._redPacketPayDictionary[i]
				local redPacketId = redPacketPay:GetID()
				local expire_time = redPacketPay._expire_time --红包过期时间
				local nExpireTime = hApi.GetNewDate(expire_time)
				--print(currenttime, redPacketId, expire_time, nExpireTime)
				if (currenttime > nExpireTime) then
					--print("redPacketPay Expire:", redPacketId)
					--此红包接收信息
					local redPacketReceive = self._redPacketReceivePayDictionary[redPacketId]
					
					--移除此发送红包信息
					self._redPacketPayDictionary[redPacketId] = nil
					
					--移除此红包的接收信息
					self._redPacketReceivePayDictionary[redPacketId] = nil
					
					--全服通知，移除消息
					local alludbid = hGlobal.uMgr:GetAllUserUID()
					
					--删除红包发送消息
					--删除消息
					hGlobal.chatMgr:InnerRemoveMessage(redPacketPay._msg_id, 0)
					--print(redPacketPay._msg_id, 0)
					
					--通知
					local sCmd = tostring(redPacketPay._msg_id)
					hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
					
					--删除红包接收消息
					for _, tRedpacketReceive in pairs(redPacketReceive) do
						--删除消息
						hGlobal.chatMgr:InnerRemoveMessage(tRedpacketReceive.msg_id, 0)
						--print(tRedpacketReceive.msg_id, 0)
						
						--通知
						local sCmd = tostring(tRedpacketReceive.msg_id)
						hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
					end
				end
			end
			
			--检测是否发放系统红包（每日）
			local sDateToday = os.date("%Y-%m-%d", currenttimestamp)
			for i = 1, #RedPacketPayMgr.SYSTEM_REDPACKET_TIME_EVERYDAY, 1 do
				local tSendParam = RedPacketPayMgr.SYSTEM_REDPACKET_TIME_EVERYDAY[i]
				local sRefreshTime = tSendParam.time --红包日期
				local nSendNum = tSendParam.num --红包数量
				local strSendTitle = tSendParam.title --红包标题
				local refresh_time = sDateToday .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					--print("发系统红包（每日）", refresh_time)
					--发系统红包
					local tMsg = {}
					tMsg.chatType = hVar.CHAT_TYPE.WORLD --世界聊天频道
					tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND --发支付（土豪）红包
					tMsg.uid = 0
					tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
					tMsg.channelId = 0
					tMsg.vip = 0
					tMsg.borderId = 1000
					tMsg.iconId = 1000
					tMsg.championId = 0
					tMsg.leaderId = 0
					tMsg.dragonId = 0
					tMsg.headId = 0
					tMsg.lineId = 0
					tMsg.content = strSendTitle --string.format(hVar.tab_string["__TEXT_CHAT_GROUP_SEND_REDPACKET"], tMsg.name)
					tMsg.date = refresh_time
					tMsg.touid = 0
					tMsg.result = hVar.RED_PACKET_TYPE.PAY_SEND --可交互事件的交互类型
					tMsg.resultParam = 0
					
					--红包发送id自增
					self._redpacketpayDBID = self._redpacketpayDBID + 1
					
					--可交互事件的参数
					tMsg.resultParam = self._redpacketpayDBID
					
					--红包失效时间
					local sDateNow = refresh_time
					local nExpireTime = hApi.GetNewDate(sDateNow, "HOUR", hVar.CHAT_PAY_RED_PACKET_EXPIRETIME)
					local sExpireTime = os.date("%Y-%m-%d %H:%M:%S", nExpireTime)
					
					--消息id
					local msgId = hGlobal.chatMgr:GetMsgDBID() + 1
					
					--插入红包
					local sendNum = nSendNum
					--[[
					local sendNum = 10
					if (max_member > 20) then
						sendNum = max_member / 2
					end
					if (sendNum > 50) then
						sendNum = 50
					end
					]]
					
					local money = 0
					local iap_id = 0
					local sqlUpdate = string.format("insert into `chat_redpacket_pay`(`id`, `send_uid`, `send_name`, `send_num`, `content`, `money`, `iap_id`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `msg_id`, `receive_num`, `send_time`, `expire_time`) values (%d, %d, '%s', %d, '%s', %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, NOW(), '%s')", self._redpacketpayDBID, 0, tMsg.name, sendNum, tMsg.content, money, iap_id, tMsg.channelId, tMsg.vip, tMsg.borderId, tMsg.iconId, tMsg.championId, tMsg.leaderId, tMsg.dragonId, tMsg.headId, tMsg.lineId, msgId, 0, sExpireTime)
					xlDb_Execute(sqlUpdate)
					--print(sqlUpdate)
					
					--内存增加红包信息
					local redPacketPay = hClass.RedPacketPay:create("RedPacketPay"):Init(self._redpacketpayDBID, 0, tMsg.name, sendNum, tMsg.content, money, iap_id, tMsg.channelId, tMsg.vip, tMsg.borderId, tMsg.iconId, tMsg.championId, tMsg.leaderId, tMsg.dragonId, tMsg.headId, tMsg.lineId, msgId, 0, sDateNow, sExpireTime)
					self._redPacketPayDictionary[self._redpacketpayDBID] = redPacketPay
					
					--红包领取信息表定义
					self._redPacketReceivePayDictionary[self._redpacketpayDBID] = {}
					
					--发送世界消息
					local ret_send, chat = hGlobal.chatMgr:AddMessage(nil, tMsg)
					if (ret_send == 1) then --操作成功
						--全服通知消息: 玩家聊天信息
						local alludbid = hGlobal.uMgr:GetAllUserUID()
						local sCmd = chat:ToCmd()
						hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
					end
				end
			end
			
			--检测是否发放系统红包（指定日期）
			for i = 1, #RedPacketPayMgr.SYSTEM_REDPACKET_TIME, 1 do
				local tSendParam = RedPacketPayMgr.SYSTEM_REDPACKET_TIME[i]
				local strSendTime = tSendParam.date --红包日期
				local nSendNum = tSendParam.num --红包数量
				local strSendTitle = tSendParam.title --红包标题
				local nSendTime = hApi.GetNewDate(strSendTime)
				if (nSendTime > lasttimestamp) and (nSendTime <= currenttimestamp) then
					--发系统红包
					local tMsg = {}
					tMsg.chatType = hVar.CHAT_TYPE.WORLD --世界聊天频道
					tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND --发支付（土豪）红包
					tMsg.uid = 0
					tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
					tMsg.channelId = 0
					tMsg.vip = 0
					tMsg.borderId = 1000
					tMsg.iconId = 1000
					tMsg.championId = 0
					tMsg.leaderId = 0
					tMsg.dragonId = 0
					tMsg.headId = 0
					tMsg.lineId = 0
					tMsg.content = strSendTitle --string.format(hVar.tab_string["__TEXT_CHAT_GROUP_SEND_REDPACKET"], tMsg.name)
					tMsg.date = strSendTime
					tMsg.touid = 0
					tMsg.result = hVar.RED_PACKET_TYPE.PAY_SEND --可交互事件的交互类型
					tMsg.resultParam = 0
					
					--红包发送id自增
					self._redpacketpayDBID = self._redpacketpayDBID + 1
					
					--可交互事件的参数
					tMsg.resultParam = self._redpacketpayDBID
					
					--红包失效时间
					local sDateNow = strSendTime
					local nExpireTime = hApi.GetNewDate(sDateNow, "HOUR", hVar.CHAT_PAY_RED_PACKET_EXPIRETIME)
					local sExpireTime = os.date("%Y-%m-%d %H:%M:%S", nExpireTime)
					
					--消息id
					local msgId = hGlobal.chatMgr:GetMsgDBID() + 1
					
					--插入红包
					local sendNum = nSendNum
					--[[
					local sendNum = 10
					if (max_member > 20) then
						sendNum = max_member / 2
					end
					if (sendNum > 50) then
						sendNum = 50
					end
					]]
					
					local money = 0
					local iap_id = 0
					local sqlUpdate = string.format("insert into `chat_redpacket_pay`(`id`, `send_uid`, `send_name`, `send_num`, `content`, `money`, `iap_id`, `channel`, `vip`, `border`, `icon`, `champion`, `leader`, `dragon`, `head`, `line`, `msg_id`, `receive_num`, `send_time`, `expire_time`) values (%d, %d, '%s', %d, '%s', %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, NOW(), '%s')", self._redpacketpayDBID, 0, tMsg.name, sendNum, tMsg.content, money, iap_id, tMsg.channelId, tMsg.vip, tMsg.borderId, tMsg.iconId, tMsg.championId, tMsg.leaderId, tMsg.dragonId, tMsg.headId, tMsg.lineId, msgId, 0, sExpireTime)
					xlDb_Execute(sqlUpdate)
					--print(sqlUpdate)
					
					--内存增加红包信息
					local redPacketPay = hClass.RedPacketPay:create("RedPacketPay"):Init(self._redpacketpayDBID, 0, tMsg.name, sendNum, tMsg.content, money, iap_id, tMsg.channelId, tMsg.vip, tMsg.borderId, tMsg.iconId, tMsg.championId, tMsg.leaderId, tMsg.dragonId, tMsg.headId, tMsg.lineId, msgId, 0, sDateNow, sExpireTime)
					self._redPacketPayDictionary[self._redpacketpayDBID] = redPacketPay
					
					--红包领取信息表定义
					self._redPacketReceivePayDictionary[self._redpacketpayDBID] = {}
					
					--发送世界消息
					local ret_send, chat = hGlobal.chatMgr:AddMessage(nil, tMsg)
					if (ret_send == 1) then --操作成功
						--全服通知消息: 玩家聊天信息
						local alludbid = hGlobal.uMgr:GetAllUserUID()
						local sCmd = chat:ToCmd()
						hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
					end
				end
			end
		end
		
		--每30秒检测一次是否发放支付（土豪红包）
		if (self._statisticsTimeWorldSend > -1) and (timeNow - self._statisticsTimeWorldSend > 30000) then --30秒
			local lasttimestamp = self._statisticsTimestampWorldSend
			local currenttimestamp = os.time()
			
			self._statisticsTimeWorldSend = timeNow
			self._statisticsTimestampWorldSend = currenttimestamp
			
			--查询是否有待发送的红包
			local sQueryM = string.format("SELECT `id`, `uid`, `itemName`, `gettype`, `sendnum` FROM `chat_redpacket_pay_redequip` WHERE `flag` =  %d order by `id` asc limit 1", 0)
			local errM, id, uid, strItemName, nHintType, sendNum = xlDb_Query(sQueryM)
			--print("查询是否有待发送的红包:", "errM=", errM, id, uid, nHintType, sendNum)
			if (errM == 0) then
				--发送红包
				local money = 0
				local content = ""
				
				--目前需要发世界红包的神器来源途径
				if (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_PURCHASE388) then --首充388元奖励
					content = string.format(hVar.tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_PURCHASE388"], strItemName)
				elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_PURCHASE198) then --首充198元奖励
					content = string.format(hVar.tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_PURCHASE198"], strItemName)
				elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDCHEST) then --神器锦囊抽到
					content = string.format(hVar.tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_REDCHEST"], strItemName)
				elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_REDDEBRIS) then --神器晶石兑换
					content = string.format(hVar.tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_REDDEBRIS"], strItemName)
				elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_GROUPCHEST) then --军团宝箱抽到
					content = string.format(hVar.tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_GROUPCHEST"], strItemName)
				elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_CANGBAOTU_HIGH) then --高级藏宝图抽到
					content = string.format(hVar.tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_CANGBAOTU_HIGH"], strItemName)
				elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAILDRAWCARD) then --邮件n选1领取
					content = string.format(hVar.tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_MAILDRAWCARD"], strItemName)
				elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MERGE) then --合成
					content = string.format(hVar.tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_MERGE"], strItemName)
				elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_PVPSHOP) then --夺塔奇兵积分商城抽到
					content = string.format(hVar.tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_PVPSHOP"], strItemName)
				elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAILBATTLESUCCESS_MLBK) then --邮件通关魔龙宝库抽到
					content = string.format(hVar.tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_MAILBATTLESUCCESS_MLBK"], strItemName)
				elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAILBATTLESUCCESS_JTMJSL) then --邮件通关军团秘境试炼抽到
					content = string.format(hVar.tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_MAILBATTLESUCCESS_JTMJSL"], strItemName)
				elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_TREASURE_STAR1) then --宝物升1星
					content = string.format(hVar.tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_TREASURE_STAR1"], strItemName)
				elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_TREASURE_STAR2) then --宝物升2星
					content = string.format(hVar.tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_TREASURE_STAR2"], strItemName)
				elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_TREASURE_STAR3) then --宝物升3星
					content = string.format(hVar.tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_TREASURE_STAR3"], strItemName)
				elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_TREASURE_STAR4) then --宝物升4星
					content = string.format(hVar.tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_TREASURE_STAR4"], strItemName)
				elseif (nHintType == hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_TREASURE_STAR5) then --宝物升5星
					content = string.format(hVar.tab_string["__TEXT_CHAT_PAY_SEND_REDPACKET_TREASURE_STAR5"], strItemName)
				end
				
				--发送红包
				self:SendRedPacket(uid, money, sendNum, content)
				
				--标记此红包已发放
				local sQueryU = string.format("update `chat_redpacket_pay_redequip` set `flag` =  %d where `id` = %d", 1, id)
				xlDb_Execute(sQueryU)
			end
		end
	end
	
return RedPacketPayMgr