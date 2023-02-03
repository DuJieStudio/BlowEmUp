--军团红包管理类
local RedPacketGroupMgr = class("RedPacketGroupMgr")
	--军团系统红包发放时间（每个军团都发）
	RedPacketGroupMgr.SYSTEM_REDPACKET_TIME_GROUP =
	{
		--[[
		{
			date = "2021-02-12 00:00:00", --日期
			num = 20, --红包数量
			title = "  新年快乐，牛年大吉", --string.format(hVar.tab_string["__TEXT_CHAT_GROUP_SEND_REDPACKET"], hVar.tab_string["__TEXT_CHAT_SYSTEM"])
		},
		]]
	}
	
	--构造函数
	function RedPacketGroupMgr:ctor()
		self._redpacketgroupDBID = -1 --军团发红包数据库id
		
		self._redpacketreceivegroupDBID = -1 --军团收红包数据库id
		
		self._redPacketGroupDictionary = -1 --军团红包表
		self._redPacketGroupReceiveDictionary = -1 --军团红包接收表
		
		--其他
		self._statisticsTime = -1	--统计计时
		self._statisticsTimestamp = -1	--上次统计时间
		
		return self
	end
	
	--初始化
	function RedPacketGroupMgr:Init()
		--初始表
		self._redPacketGroupDictionary = {}
		self._redPacketGroupReceiveDictionary = {}
		
		--读取军团发红包数据库id
		local err1, pid = xlDb_Query("SELECT IFNULL(MAX(id), 0) FROM `chat_redpacket_group`;")
		--print("max(id)", err1, pid)
		if (err1 == 0) then
			self._redpacketgroupDBID = pid
		else
			self._redpacketgroupDBID = 0
		end
		
		--读取军团收红包数据库id
		local err1, pid = xlDb_Query("SELECT IFNULL(MAX(id), 0) FROM `chat_redpacket_receive_group`;")
		--print("max(id)", err1, pid)
		if (err1 == 0) then
			self._redpacketreceivegroupDBID = pid
		else
			self._redpacketreceivegroupDBID = 0
		end
		
		--从数据库读取全部未过期的军团红包信息
		local sDateNow = os.date("%Y-%m-%d %H:%M:%S", os.time())
		local sQueryM = string.format("SELECT `id`, `send_uid`, `send_name`, `group_id`, `send_num`, `content`, `coin`, `order_id`, `msg_id`, `receive_num`, `send_time`, `expire_time` FROM `chat_redpacket_group` WHERE `expire_time` > '%s'", sDateNow)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print("从数据库读取全部未过期的军团红包信息:", "errM=", errM, "tTemp=", #tTemp)
		if (errM == 0) then
			--逆向初始化
			for n = #tTemp, 1, -1 do
				local id = tTemp[n][1] --红包唯一id
				local send_uid = tTemp[n][2] --红包发送者uid
				local send_name = tTemp[n][3] --红包发送者名字
				local group_id = tTemp[n][4] --红包军团id
				local send_num = tTemp[n][5] --红包发送数量
				local content = tTemp[n][6] --内容
				local coin = tTemp[n][7] --游戏币
				local order_id = tTemp[n][8] --订单号
				local msg_id = tTemp[n][9] --消息id
				local receive_num = tTemp[n][10] --红包接收数量
				local send_time = tTemp[n][11] --红包发送时间
				local expire_time = tTemp[n][12] --红包过期时间
				
				--添加军团红包信息
				local redPacketGroup = hClass.RedPacketGroup:create("RedPacketGroup"):Init(id, send_uid, send_name, group_id, send_num, content, coin, order_id, msg_id, receive_num, send_time, expire_time)
				self._redPacketGroupDictionary[id] = redPacketGroup
				
				--军团红包领取信息表定义
				self._redPacketGroupReceiveDictionary[id] = {}
			end
		end
		
		--从数据库读取全部未过期的军团红包领取信息
		local sQueryM = string.format("SELECT `id`, `redpacket_id`, `receive_uid`, `receive_name`, `receive_group_id`, `msg_id`, `receive_num`, `prize`, `receive_time` FROM `chat_redpacket_receive_group` WHERE `redpacket_id` in (select `id` from `chat_redpacket_group` where `expire_time` > '%s')", sDateNow)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("从数据库读取全部未过期的军团红包领取信息:", "errM=", errM, "tTemp=", tTemp and #tTemp)
		if (errM == 0) then
			--逆向初始化
			for n = #tTemp, 1, -1 do
				local id = tTemp[n][1] --领取id
				local redpacket_id = tTemp[n][2] --红包唯一id
				local receive_uid = tTemp[n][3] --接收者uid
				local receive_name = tTemp[n][4] --接收者名字
				local receive_group_id = tTemp[n][5] --接收者工会id
				local msg_id = tTemp[n][6] --消息id
				local receive_num = tTemp[n][7] --接收数量
				local prize = tTemp[n][8] --奖励
				local receive_time = tTemp[n][9] --接收时间
				--print(id, redpacket_id, receive_uid, receive_name, receive_group_id, msg_id, receive_num, prize, receive_time)
				
				--军团红包领取信息
				self._redPacketGroupReceiveDictionary[redpacket_id][receive_uid] = {id = id, redpacket_id = redpacket_id, receive_uid = receive_uid, receive_name = receive_name, receive_group_id = receive_group_id, msg_id = msg_id, receive_num = receive_num, prize = prize, receive_time = receive_time,}
			end
		end
		
		--其他
		self._statisticsTime = hApi.GetClock()	--统计计时
		self._statisticsTimestamp = os.time()	--上次统计时间
		
		return self
	end
	
	--release
	function RedPacketGroupMgr:Release()
		self._redpacketgroupDBID = -1 --军团发红包数据库id
		
		self._redpacketreceivegroupDBID = -1 --军团收红包数据库id
		
		self._redPacketGroupDictionary = -1 --军团红包表
		self._redPacketGroupReceiveDictionary = -1 --军团红包接收表
		
		--其他
		self._statisticsTime = -1	--统计计时
		self._statisticsTimestamp = -1	--上次统计时间
		
		return self
	end
	
	--获取军团发红包数据库id
	function RedPacketGroupMgr:GetSendDBID()
		return self._redpacketgroupDBID
	end
	
	--获取军团收红包数据库id
	function RedPacketGroupMgr:GetReceiveDBID()
		return self._redpacketreceivegroupDBID
	end
	
	--获取军团红包信息表
	function RedPacketGroupMgr:GetRedPacketList()
		return self._redPacketGroupDictionary
	end
	
	--获取军团指定id的红包信息
	function RedPacketGroupMgr:GetRedPacket(redPacketId)
		return self._redPacketGroupDictionary[redPacketId]
	end
	
	--获取军团红包接收信息表
	function RedPacketGroupMgr:GetRedPacketReceiveList()
		return self._redPacketGroupReceiveDictionary
	end
	
	--获取指定id军团红包的接收信息
	function RedPacketGroupMgr:GetRedPacketReceive(redPacketId)
		return self._redPacketGroupReceiveDictionary[redPacketId]
	end
	
	--请求发送军团红包
	function RedPacketGroupMgr:SendRedPacket(user, rid, groupId, sendIndex, tMsg)
		local ret = 0
		local sRetCmd = ""
		
		--玩家所在的工会id
		local uid = user:GetUID()
		local groupId_uid = hGlobal.groupMgr:GetUserGroupID(uid) --玩家所在的工会id
		if (groupId_uid > 0) then
			--发送的是同一个军团
			if (groupId == groupId_uid) then
				--加入军团24小时才能发红包
				--玩家加入军团的时间(秒)
				local entersecounds = hGlobal.groupMgr:GetUserEnterTime(groupId, uid)
				--if (entersecounds > 86400) then
				--geyachao: 规则调整不需要限制时间了
				if (entersecounds > 0) then
					local count = user:GetSendRedPacketNum() --今日已发军团红包次数
					local vipLv = hGlobal.vipMgr:DBGetUserVip(uid) --玩家vip等级
					local maxcount = hVar.Vip_Conifg.groupSendRedpacketCount[vipLv] or 1 --最大次数
					if (count < maxcount) then --今日发红包次数未满
						--计算需要的游戏币
						local shopItemId = hVar.CHAT_GROUP_RED_PACKET_SHOPITEM[sendIndex] or 0
						local tShop = hVar.tab_shopitem[shopItemId] or {}
						local itemId = tShop.itemID or 0 --道具id
						local requireCoin = tShop.rmb or 0 --游戏币
						local sendNum = tShop.num or 0 --红包个数
						if (requireCoin > 0) and (sendNum > 0) then
							--检测游戏币是否足够
							local iCoin = 0
							local sSql = string.format("SELECT gamecoin_online FROM t_user WHERE uid = %d", uid)
							local iErrorCode, coin = xlDb_Query(sSql)
							if (iErrorCode == 0) then
								iCoin = coin
							end
							
							if (iCoin >= requireCoin) then
								--扣除游戏币
								--统计游戏币累加值
								local sSql = string.format("UPDATE `t_user` SET `gamecoin_online` = `gamecoin_online` + %d, `gamecoin_totalnum` = `gamecoin_totalnum` + %d WHERE `uid` = %d", -requireCoin, requireCoin, uid)
								xlDb_Execute(sSql)
								
								--更新玩家今日发送军团红包的次数
								user:AddSendRedPacketNum(1)
								
								--插入订单
								local orderId = 0
								local strOderInfo = "c:" .. tostring(iCoin - requireCoin)
								local sSql = string.format("INSERT INTO `order` (`type`, uid, rid, itemid, itemnum, coin, itemname, ext_01) VALUES (%d, %d, %d, %d, 1, %d, '%s', '%s')", 22, uid, rid, itemId, requireCoin, hVar.tab_stringI[itemId], strOderInfo)
								--print(sSql)
								xlDb_Execute(sSql)
								
								local err1, orderId1 = xlDb_Query("select last_insert_id()")
								if (err1 == 0) then
									orderId = orderId1
								end
								
								--军团红包发送id自增
								self._redpacketgroupDBID = self._redpacketgroupDBID + 1
								
								--可交互事件的参数
								tMsg.resultParam = self._redpacketgroupDBID
								
								--军团红包失效时间
								local sDateNow = os.date("%Y-%m-%d %H:%M:%S", os.time())
								local nExpireTime = hApi.GetNewDate(sDateNow, "HOUR", hVar.CHAT_GROUP_RED_PACKET_EXPIRETIME)
								local sExpireTime = os.date("%Y-%m-%d %H:%M:%S", nExpireTime)
								
								--消息id
								local msgId = hGlobal.chatMgr:GetMsgDBID() + 1
								
								--插入军团红包
								local sqlUpdate = string.format("insert into `chat_redpacket_group`(`id`, `send_uid`, `send_name`, `group_id`, `send_num`, `content`, `coin`, `order_id`, `msg_id`, `receive_num`, `send_time`, `expire_time`) values (%d, %d, '%s', %d, %d, '%s', %d, %d, %d, %d, NOW(), '%s')", self._redpacketgroupDBID, uid, tMsg.name, groupId, sendNum, tMsg.content, requireCoin, orderId, msgId, 0, sExpireTime)
								xlDb_Execute(sqlUpdate)
								--print(sqlUpdate)
								
								--内存增加军团红包信息
								local redPacketGroup = hClass.RedPacketGroup:create("RedPacketGroup"):Init(self._redpacketgroupDBID, uid, tMsg.name, groupId, sendNum, tMsg.content, requireCoin, orderId, msgId, 0, sDateNow, sExpireTime)
								self._redPacketGroupDictionary[self._redpacketgroupDBID] = redPacketGroup
								
								--军团红包领取信息表定义
								self._redPacketGroupReceiveDictionary[self._redpacketgroupDBID] = {}
								
								--军团发红包者给予随机奖励
								local tRewardSenderList = hVar.GROUP_RED_PACKET_SENDER_REWARDLIST[sendIndex]
								local rand = math.random(1, #tRewardSenderList)
								local tRewardSender = tRewardSenderList[rand]
								
								--发奖
								local reward = hClass.Reward:create():Init()
								reward:Add(tRewardSender)
								reward:TakeReward(uid, rid, nil, hVar.tab_string["__TEXT_GROUP_REDPACKET"])
								
								--奖励信息
								local strReward = reward:ToCmd()
								
								--军团资源类型，插入日志
								local rewardType = tRewardSender[1]
								if (rewardType == 16) or (rewardType == 17) or (rewardType == 18) or (rewardType == 20) then --geyachao: 新加房间的配置项 军团
									local iron_donate_num = 0 --增加的铁
									local wood_donate_num = 0 --增加的木材
									local food_donate_num = 0 --增加的粮食
									local group_coin_num = 0 --增加的军团币
								
									local rewardNum = tRewardSender[2]
										
									if (rewardType == 16) then --16:铁 --geyachao: 新加房间的配置项 军团
										iron_donate_num = iron_donate_num + rewardNum
									elseif (rewardType == 17) then --17:木材 --geyachao: 新加房间的配置项 军团
										wood_donate_num = wood_donate_num + rewardNum
									elseif (rewardType == 18) then --18:粮食 --geyachao: 新加房间的配置项 军团
										food_donate_num = food_donate_num + rewardNum
									elseif (rewardType == 20) then --20:军团币 --geyachao: 新加房间的配置项 军团
										group_coin_num = group_coin_num + rewardNum
									end
									
									--查询玩家的渠道号
									local channelId = 0
									local sQuery = string.format("SELECT `channel_id` FROM `t_user` WHERE `uid`= %d", uid)
									local err, channel_id = xlDb_Query(sQuery)
									--print("sQuery:",sQuery,err)
									if (err == 0) then
										channelId = channel_id
									end
									
									--更新资源日志
									local sSql = string.format("INSERT INTO `novicecamp_member_donate_log` (`uid`, `ncid`, `itemname`, `channelId`, `redpacket_id`, `mat_iron_donate`, `mat_wood_donate`, `mat_food_donate`, `group_coin`, `time`) VALUES (%d, %d, '%s', %d, %d, %d, %d, %d, %d, NOW())", uid, groupId, hVar.tab_stringI[itemId], channelId, self._redpacketgroupDBID, iron_donate_num, wood_donate_num, food_donate_num, group_coin_num)
									--print(sSql)
									xlDb_Execute(sSql)
									
									--更新资源个人表
									if (iron_donate_num > 0) or (wood_donate_num > 0) or (food_donate_num > 0) then
										local sUpdate = string.format("update `novicecamp_member` set `mat_iron_donate_sum` = `mat_iron_donate_sum` + %d, `mat_wood_donate_sum` = `mat_wood_donate_sum` + %d, `mat_food_donate_sum` = `mat_food_donate_sum` + %d where `uid` = %d", iron_donate_num, wood_donate_num, food_donate_num, uid)
										xlDb_Execute(sUpdate)
									end
									
									--记录玩家本周军团捐献总和（军团发红包）
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
								
								--奖励信息
								local strReward = reward:ToCmd()
								
								--触发事件，发军团红包，发送军团消息
								hGlobal.groupMgr:OnGroupSendRedPacket(groupId, uid, tMsg)
								
								--军团红包发送者奖励
								sRetCmd = strReward
								
								--操作成功
								ret = 1
							else
								--您没有足够的游戏币
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_NOT_ENOUGH_GAMECOIN
							end
						else
							--"参数不合法"
							ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
						end
					else
						--"今日发红包次数已达上限"
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_SEND_RED_PACKET_MAXCOUNT
					end
				else
					--加入军团24小时以上才能发红包
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_RED_PACKET_SEND_24HOUR
				end
				
			else
				--您不在此军团里
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_INVALID_GROUP
			end
		else
			--"您还未加入军团"
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_NOT_IN_GROUP
		end
		
		--字符串拼接
		sRetCmd = tostring(ret) .. ";" .. sRetCmd
		
		return ret, sRetCmd
	end
	
	--请求领取军团红包
	function RedPacketGroupMgr:ReceiveRedPacket(user, rid, groupId, redPacketId, tMsg)
		local ret = 0
		local sRetCmd = ""
		
		--玩家所在的工会id
		local uid = user:GetUID()
		local groupId_uid = hGlobal.groupMgr:GetUserGroupID(uid) --玩家所在的工会id
		--print(groupId_uid,groupId)
		if (groupId_uid > 0) then
			--发送的是同一个军团
			if (groupId == groupId_uid) then
				--加入军团24小时才能领红包
				--玩家加入军团的时间(秒)
				local entersecounds = hGlobal.groupMgr:GetUserEnterTime(groupId, uid)
				--if (entersecounds > 86400) then
				--geyachao: 规则调整不需要限制时间了
				if (entersecounds > 0) then
					--红包信息
					local redPacketGroup = self:GetRedPacket(redPacketId)
					if redPacketGroup then
						local send_num = redPacketGroup._send_num --红包发送数量
						local receive_num = redPacketGroup._receive_num --红包接收数量
						
						--未全部领完
						if (receive_num < send_num) then
							--玩家未领取此军团红包
							if (not self._redPacketGroupReceiveDictionary[redPacketId][uid]) then
								--生成此军团红包的随机奖励
								local tReward = {}
								
								--计算每个奖励的区间
								local rewardList = hVar.GROUP_RED_PACKET_REWARDLIST
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
								reward:TakeReward(uid, rid, nil, hVar.tab_string["__TEXT_GROUP_REDPACKET"])
								
								--军团资源类型，插入日志
								local rewardType = tReward[1]
								if (rewardType == 16) or (rewardType == 17) or (rewardType == 18) or (rewardType == 20) then --geyachao: 新加房间的配置项 军团
									local iron_donate_num = 0 --增加的铁
									local wood_donate_num = 0 --增加的木材
									local food_donate_num = 0 --增加的粮食
									local group_coin_num = 0 --增加的军团币
								
									local rewardNum = tReward[2]
										
									if (rewardType == 16) then --16:铁 --geyachao: 新加房间的配置项 军团
										iron_donate_num = iron_donate_num + rewardNum
									elseif (rewardType == 17) then --17:木材 --geyachao: 新加房间的配置项 军团
										wood_donate_num = wood_donate_num + rewardNum
									elseif (rewardType == 18) then --18:粮食 --geyachao: 新加房间的配置项 军团
										food_donate_num = food_donate_num + rewardNum
									elseif (rewardType == 20) then --20:军团币 --geyachao: 新加房间的配置项 军团
										group_coin_num = group_coin_num + rewardNum
									end
									
									--更新资源日志
									local sSql = string.format("INSERT INTO `novicecamp_member_donate_log` (`uid`, `ncid`, `itemname`, `channelId`, `redpacket_id`, `mat_iron_donate`, `mat_wood_donate`, `mat_food_donate`, `group_coin`, `time`) VALUES (%d, %d, '%s', %d, %d, %d, %d, %d, %d, NOW())", uid, groupId, hVar.tab_string["__TEXT_GROUP_REDPACKET"], tMsg.channelId, redPacketId, iron_donate_num, wood_donate_num, food_donate_num, group_coin_num)
									--print(sSql)
									xlDb_Execute(sSql)
									
									--更新资源个人表
									if (iron_donate_num > 0) or (wood_donate_num > 0) or (food_donate_num > 0) then
										local sUpdate = string.format("update `novicecamp_member` set `mat_iron_donate_sum` = `mat_iron_donate_sum` + %d, `mat_wood_donate_sum` = `mat_wood_donate_sum` + %d, `mat_food_donate_sum` = `mat_food_donate_sum` + %d where `uid` = %d", iron_donate_num, wood_donate_num, food_donate_num, uid)
										xlDb_Execute(sUpdate)
									end
									
									--记录玩家本周军团捐献总和（军团领红包）
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
								
								--奖励信息
								local strReward = reward:ToCmd()
								
								--军团红包领取id自增
								self._redpacketreceivegroupDBID = self._redpacketreceivegroupDBID + 1
								
								--可交互事件的参数
								tMsg.resultParam = self._redpacketreceivegroupDBID
								
								--消息id
								local msgId = hGlobal.chatMgr:GetMsgDBID() + 1
								
								--更新内存军团红包领取数量
								redPacketGroup._receive_num = redPacketGroup._receive_num + 1
								
								--更新数据库军团红包领取数量
								local sDateNow = os.date("%Y-%m-%d %H:%M:%S", os.time())
								if (redPacketGroup._receive_num >= send_num) then
									--红包全部领完，同时更新红包的失效时间
									local nExpireTime = hApi.GetNewDate(sDateNow, "HOUR", hVar.CHAT_GROUP_RED_PACKET_EMPTY_EXPIRETIME)
									local sExpireTime = os.date("%Y-%m-%d %H:%M:%S", nExpireTime)
									
									--更新内存值
									redPacketGroup._expire_time = sExpireTime
									
									--更新红包失效时间
									local sqlUpdate = string.format("update `chat_redpacket_group` set `receive_num` = `receive_num` + 1, `expire_time`  = '%s' where `id` = %d", sExpireTime, redPacketId)
									xlDb_Execute(sqlUpdate)
								else
									--红包未领完
									local sqlUpdate = string.format("update `chat_redpacket_group` set `receive_num` = `receive_num` + 1 where `id` = %d", redPacketId)
									xlDb_Execute(sqlUpdate)
								end
								
								--插入红包领取表
								local sqlUpdate = string.format("insert into `chat_redpacket_receive_group`(`id`, `redpacket_id`, `receive_uid`, `receive_name`, `receive_group_id`, `msg_id`, `receive_num`, `prize`, `receive_time`) values (%d, %d, %d, '%s', %d, %d, %d, '%s', NOW())", self._redpacketreceivegroupDBID, redPacketId, uid, tMsg.name, groupId, msgId, 1, strReward)
								xlDb_Execute(sqlUpdate)
								--print(sqlUpdate)
								
								--内存增加红包领取信息
								local tReceive =
								{
									id = self._redpacketreceivegroupDBID,
									redpacket_id = redPacketId,
									receive_uid = uid,
									receive_name = tMsg.name,
									receive_group_id = groupId,
									msg_id = msgId,
									receive_num = 1,
									prize = strReward,
									receive_time = sDateNow,
								}
								--红包领取信息表
								self._redPacketGroupReceiveDictionary[redPacketId][uid] = tReceive
								
								--插入订单信息
								--新的购买记录插入到order表
								local itemId = 9946
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
								
								--更新消息的军团红包领取字符串
								local strItemRewardInfo = hApi.GetRewardInfo(tReward)
								if (redPacketGroup._receive_num >= send_num) then --已被领完
									tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_RECEIVE_EMPTY_REDPACKET"], tMsg.name, redPacketGroup._send_name, strItemRewardInfo)
								else
									tMsg.content = string.format(hVar.tab_string["__TEXT_CHAT_GROUP_RECEIVE_REDPACKET"], tMsg.name, redPacketGroup._send_name, strItemRewardInfo)
								end
								tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
								
								--触发事件，收军团红包，发送军团消息
								hGlobal.groupMgr:OnGroupReceiveRedPacket(groupId, uid, tMsg)
								
								--军团红包领取记录
								sRetCmd = orderId .. ";" .. strReward
								
								--操作成功
								ret = 1
							else
								--"您已领取过该红包"
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_RED_PACKET_RECEIVE_MAXCOUNT
							end
						else
							--"该红包已全部领完"
							ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_RECEIVE_RED_PACKET_EMYPT
						end
					else
						--"该红包不存在或已过期"
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_RED_PACKET_INVALID
					end
				else
					--加入军团24小时以上才能领红包
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_RED_PACKET_RECEIVE_24HOUR
				end
			else
				--您不在此军团里
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_INVALID_GROUP
			end
		else
			--"您还未加入军团"
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_NOT_IN_GROUP
		end
		
		--字符串拼接
		sRetCmd = tostring(ret) .. ";" .. sRetCmd
		
		--返回值
		return ret, sRetCmd
	end
	
	--军团红包更新(1秒)
	function RedPacketGroupMgr:Update()
		local self = hGlobal.redPacketGroupMgr --self
		
		--输出信息
		local timeNow = hApi.GetClock()
		if (self._statisticsTime > -1) and (timeNow - self._statisticsTime > 1000) then
			local lasttimestamp = self._statisticsTimestamp
			local currenttimestamp = os.time()
			
			self._statisticsTime = timeNow
			self._statisticsTimestamp = currenttimestamp
			
			--检测是否有过期的红包
			local currenttime = os.time()
			for _, redPacketGroup in pairs(self._redPacketGroupDictionary) do
				--local redPacketGroup = self._redPacketGroupDictionary[i]
				local redPacketId = redPacketGroup:GetID()
				local expire_time = redPacketGroup._expire_time --红包过期时间
				local nExpireTime = hApi.GetNewDate(expire_time)
				--print(currenttime, redPacketId, expire_time, nExpireTime)
				if (currenttime > nExpireTime) then
					--print("RedPacketGroup Expire:", redPacketId)
					--此红包接收信息
					local redPacketReceive = self._redPacketGroupReceiveDictionary[redPacketId]
					
					--移除此发送红包信息
					self._redPacketGroupDictionary[redPacketId] = nil
					
					--移除此红包的接收信息
					self._redPacketGroupReceiveDictionary[redPacketId] = nil
					
					--通知工会全部成员，移除消息
					local groupId = redPacketGroup._group_id
					local tUserTable = hGlobal.groupMgr:GetGroupAllUser(groupId)
					if tUserTable then
						for uid, level in pairs(tUserTable) do
							--删除红包发送消息
							--删除消息
							hGlobal.chatMgr:InnerRemoveMessage(redPacketGroup._msg_id, groupId)
							--print(redPacketGroup._msg_id, groupId)
							
							--通知
							local sCmd = tostring(redPacketGroup._msg_id)
							hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
							
							--删除红包接收消息
							for _, tRedpacketReceive in pairs(redPacketReceive) do
								--删除消息
								hGlobal.chatMgr:InnerRemoveMessage(tRedpacketReceive.msg_id, groupId)
								--print(tRedpacketReceive.msg_id, groupId)
								
								--通知
								local sCmd = tostring(tRedpacketReceive.msg_id)
								hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
							end
						end
					end
				end
			end
			
			--检测是否发放军团系统红包（每个军团都发）
			for i = 1, #RedPacketGroupMgr.SYSTEM_REDPACKET_TIME_GROUP, 1 do
				local tSendParam = RedPacketGroupMgr.SYSTEM_REDPACKET_TIME_GROUP[i]
				local strSendTime = tSendParam.date --红包日期
				local nSendNum = tSendParam.num --红包数量
				local strSendTitle = tSendParam.title --红包标题
				local nSendTime = hApi.GetNewDate(strSendTime)
				if (nSendTime > lasttimestamp) and (nSendTime <= currenttimestamp) then
					--依次遍历每个军团
					local groupList = hGlobal.groupMgr:GetGroupList()
					for groupId, v in pairs(groupList) do
						--查询军团的最大人数
						local max_member = 0
						local sQueryM = string.format("SELECT `max_member` FROM `novicecamp_list` WHERE `id` = %d and `dissolution` = 0", groupId)
						local errM, maxnum = xlDb_Query(sQueryM)
						if (errM == 0) then
							max_member = maxnum
							--print(groupId, max_member)
						end
						
						--发系统红包
						local tMsg = {}
						tMsg.chatType = hVar.CHAT_TYPE.GROUP
						tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND
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
						tMsg.touid = groupId
						tMsg.result = hVar.RED_PACKET_TYPE.GROUP_SEND --可交互事件的交互类型
						tMsg.resultParam = 0
						
						--红包发送id自增
						self._redpacketgroupDBID = self._redpacketgroupDBID + 1
						
						--可交互事件的参数
						tMsg.resultParam = self._redpacketgroupDBID
						
						--红包失效时间
						local sDateNow = strSendTime
						local nExpireTime = hApi.GetNewDate(sDateNow, "HOUR", hVar.CHAT_GROUP_RED_PACKET_EXPIRETIME)
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
						
						local requireCoin = 0
						local orderId = 0
						local sqlUpdate = string.format("insert into `chat_redpacket_group`(`id`, `send_uid`, `send_name`, `group_id`, `send_num`, `content`, `coin`, `order_id`, `msg_id`, `receive_num`, `send_time`, `expire_time`) values (%d, %d, '%s', %d, %d, '%s', %d, %d, %d, %d, NOW(), '%s')", self._redpacketgroupDBID, 0, tMsg.name, groupId, sendNum, tMsg.content, requireCoin, orderId, msgId, 0, sExpireTime)
						xlDb_Execute(sqlUpdate)
						--print(sqlUpdate)
						
						--内存增加红包信息
						local redPacketGroup = hClass.RedPacketGroup:create("RedPacketGroup"):Init(self._redpacketgroupDBID, 0, tMsg.name, groupId, sendNum, tMsg.content, requireCoin, orderId, msgId, 0, sDateNow, sExpireTime)
						self._redPacketGroupDictionary[self._redpacketgroupDBID] = redPacketGroup
						
						--红包领取信息表定义
						self._redPacketGroupReceiveDictionary[self._redpacketgroupDBID] = {}
						
						--触发事件，发红包，发送军团消息
						hGlobal.groupMgr:OnGroupSendRedPacket(groupId, 0, tMsg)
					end
				end
			end
		end
	end
	
return RedPacketGroupMgr