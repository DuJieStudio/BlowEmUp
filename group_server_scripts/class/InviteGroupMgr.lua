--军团邀请函管理类
local InviteGroupMgr = class("InviteGroupMgr")
	--军团系统红包发放时间（每个军团都发）
	InviteGroupMgr.SYSTEM_REDPACKET_TIME_GROUP =
	{
		--[[
		{
			date = "2021-02-12 00:00:00", --日期
			num = 20, --红包数量
			title = "  新年快乐，牛年大吉", --string.format(hVar.tab_string["__TEXT_CHAT_GROUP_SEND_REDPACKET"], hVar.tab_string["__TEXT_CHAT_SYSTEM"])
		},
		]]
	}
	
	--军团邀请函商品id
	InviteGroupMgr.SHOPITEMID = 512
	
	--构造函数
	function InviteGroupMgr:ctor()
		self._groupInviteDBID = -1 --军团邀请函表数据库id
		self._inviteGroupDictionary = -1 --军团邀请函表dic
		self._inviteGroupList = -1 --军团邀请函表array
		
		--其他
		self._statisticsTime = -1	--统计计时
		self._statisticsTimestamp = -1	--上次统计时间
		
		return self
	end
	
	--初始化
	function InviteGroupMgr:Init()
		--初始表
		self._inviteGroupDictionary = {} --军团邀请函表dic
		self._inviteGroupList = {} --军团邀请函表array
		
		--读取军团邀请函数据库id
		local err1, pid = xlDb_Query("SELECT IFNULL(MAX(id), 0) FROM `chat_invite_group`;")
		--print("max(id)", err1, pid)
		if (err1 == 0) then
			self._groupInviteDBID = pid
		else
			self._groupInviteDBID = 0
		end
		
		--从数据库读取全部未过期的军团邀请函信息
		local sDateNow = os.date("%Y-%m-%d %H:%M:%S", os.time())
		local sQueryM = string.format("SELECT `id`, `groupId`, `day_min`, `vip_min`, `msg_id`, `create_time`, `expire_time` FROM `chat_invite_group` WHERE `expire_time` > '%s' ORDER BY `id` DESC", sDateNow)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print("从数据库读取全部未过期的军团邀请函信息:", "errM=", errM, "tTemp=", #tTemp)
		if (errM == 0) then
			--逆向初始化
			for n = #tTemp, 1, -1 do
				local id = tTemp[n][1] --军团邀请函唯一id
				local groupId = tTemp[n][2] --军团id
				local dayMin = tTemp[n][3] --需要的最小注册时间
				local vipMin = tTemp[n][4] --需要的最小vip等级
				local msg_id = tTemp[n][5] --消息id
				local create_time = tTemp[n][6] --军团邀请函发起时间
				local expire_time = tTemp[n][7] --军团邀请函过期时间
				
				--根据军团id读取此军团的一些信息
				local groupName = ""
				local groupLevel = 0
				local groupForce = 0
				local groupMember = 0
				local groupMemberMax = 0
				local groupIntroduce = ""
				local sSql = string.format("SELECT `name`, `descripe`, `count_member`, `max_member`, `country`, `buildinfo` FROM novicecamp_list WHERE `id` = %d", groupId)
				local iErrorCode, name, descripe, count_member, max_member, country, buildInfo = xlDb_Query(sSql)
				if (iErrorCode == 0) then
					groupName = name
					groupForce = country
					groupMember = count_member
					groupMemberMax = max_member
					groupIntroduce = descripe
					
					local townId = 80068 --主城id
					if (type(buildInfo) == "string") then
						if (buildInfo ~= "") then
							local tmp = "local strCfg = ".. tostring(buildInfo) .. " return strCfg"
							local tBuildInfo = assert(loadstring(tmp))()
							if (type(tBuildInfo) == "table") then
								local buildlist = tBuildInfo.buildlist
								if buildlist then
									for i = 1, #buildlist, 1 do
										if (buildlist[i].id == townId) then --找到了
											groupLevel = buildlist[i].lv
											break
										end
									end
								end
							end
						end
					end
				end
				
				--添加军团邀请函信息
				local inviteGroup = hClass.InviteGroup:create("InviteGroup"):Init(id, groupId, groupName, groupLevel, groupForce, groupMember, groupMemberMax, groupIntroduce, dayMin, vipMin, msg_id, create_time, expire_time)
				self._inviteGroupDictionary[id] = inviteGroup
				self._inviteGroupList[#self._inviteGroupList+1] = inviteGroup
			end
		end
		
		--其他
		self._statisticsTime = hApi.GetClock()	--统计计时
		self._statisticsTimestamp = os.time()	--上次统计时间
		
		return self
	end
	
	--release
	function InviteGroupMgr:Release()
		self._groupInviteDBID = -1 --军团邀请函表数据库id
		self._inviteGroupDictionary = -1 --军团邀请函表dic
		self._inviteGroupList = -1 --军团邀请函表array
		
		--其他
		self._statisticsTime = -1	--统计计时
		self._statisticsTimestamp = -1	--上次统计时间
		
		return self
	end
	
	--获取军团邀请函据库id
	function InviteGroupMgr:GetDBID()
		return self._groupInviteDBID
	end
	
	--获取军团邀请函信息表
	function InviteGroupMgr:GetInviteGroupList()
		return self._inviteGroupList
	end
	
	--获取军团指定id的邀军团请函信息
	function InviteGroupMgr:GetInviteGroup(inviteGroupId)
		return self._inviteGroupDictionary[inviteGroupId]
	end
	
	--请求创建军团邀请函
	function InviteGroupMgr:AddGroupInvite(user, rid, groupId, dayMin, vipMin, tMsg)
		local ret = 0
		local sRetCmd = ""
		
		--玩家所在的工会id
		local uid = user:GetUID()
		local groupId_uid = hGlobal.groupMgr:GetUserGroupID(uid) --玩家所在的工会id
		if (groupId_uid > 0) then
			--发送的是同一个军团
			if (groupId == groupId_uid) then
				--会长才能创建邀请函
				local groupLevel = hGlobal.groupMgr:GetUserGroupLevel(uid) --玩家所在的工会权限
				if (groupLevel == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then
					--检测当前邀请函数量是否太多
					if (#self._inviteGroupList < hVar.CHAT_MAX_LENGTH_INVITE) then
						--检测参数的合法性
						if (dayMin >= 0) and (vipMin >= 0) then
							--检测内存里是否已存在此军团的邀请函
							local bExisted = false
							for _, inviteGroup_i in pairs(self._inviteGroupDictionary) do
								if (inviteGroup_i._groupId == groupId) then --找到了
									bExisted = true
									break
								end
							end
							if (not bExisted) then
								local shopItemId = InviteGroupMgr.SHOPITEMID or 0
								local tShop = hVar.tab_shopitem[shopItemId] or {}
								local itemId = tShop.itemID or 0 --道具id
								local requireCoin = tShop.rmb or 0 --游戏币
								if (requireCoin > 0) then
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
										
										--军团邀请函id自增
										self._groupInviteDBID = self._groupInviteDBID + 1
										
										--可交互事件的参数
										tMsg.resultParam = self._groupInviteDBID
										
										--军团邀请函失效时间
										local sDateNow = os.date("%Y-%m-%d %H:%M:%S", os.time())
										local nExpireTime = hApi.GetNewDate(sDateNow, "HOUR", hVar.CHAT_GROUP_INVITE_EXPIRETIME)
										local sExpireTime = os.date("%Y-%m-%d %H:%M:%S", nExpireTime)
										
										--消息id
										local msgId = hGlobal.chatMgr:GetMsgDBID() + 1
										
										--插入军团邀请函
										local sqlUpdate = string.format("insert into `chat_invite_group`(`id`, `groupId`, `day_min`, `vip_min`, `msg_id`, `create_time`, `expire_time`) values (%d, %d, %d, %d, %d, NOW(), '%s')", self._groupInviteDBID, groupId, dayMin, vipMin, msgId, sExpireTime)
										xlDb_Execute(sqlUpdate)
										--print(sqlUpdate)
										
										--内存增加军团邀请函
										--根据军团id读取此军团的一些信息
										local groupName = ""
										local groupLevel = 0
										local groupForce = 0
										local groupMember = 0
										local groupMemberMax = 0
										local groupIntroduce = ""
										local sSql = string.format("SELECT `name`, `descripe`, `count_member`, `max_member`, `country`, `buildinfo` FROM novicecamp_list WHERE `id` = %d", groupId)
										local iErrorCode, name, descripe, count_member, max_member, country, buildInfo = xlDb_Query(sSql)
										if (iErrorCode == 0) then
											groupName = name
											groupForce = country
											groupMember = count_member
											groupMemberMax = max_member
											groupIntroduce = descripe
											
											local townId = 80068 --主城id
											if (type(buildInfo) == "string") then
												if (buildInfo ~= "") then
													local tmp = "local strCfg = ".. tostring(buildInfo) .. " return strCfg"
													local tBuildInfo = assert(loadstring(tmp))()
													if (type(tBuildInfo) == "table") then
														local buildlist = tBuildInfo.buildlist
														if buildlist then
															for i = 1, #buildlist, 1 do
																if (buildlist[i].id == townId) then --找到了
																	groupLevel = buildlist[i].lv
																	break
																end
															end
														end
													end
												end
											end
										end
										--print(self._groupInviteDBID, groupId, groupName, groupLevel, groupForce, groupMember, groupMemberMax, groupIntroduce, dayMin, vipMin, msgId, sDateNow, sExpireTime)
										local inviteGroup = hClass.InviteGroup:create("InviteGroup"):Init(self._groupInviteDBID, groupId, groupName, groupLevel, groupForce, groupMember, groupMemberMax, groupIntroduce, dayMin, vipMin, msgId, sDateNow, sExpireTime)
										self._inviteGroupDictionary[self._groupInviteDBID] = inviteGroup
										self._inviteGroupList[#self._inviteGroupList+1] = inviteGroup
										
										--添加一条军团邀请消息（放在军团邀请函内存增加数据之后）
										local ret2, chat = hGlobal.chatMgr:AddMessage(nil, tMsg)
										
										--全服通知消息: 玩家聊天信息
										local alludbid = hGlobal.uMgr:GetAllUserUID()
										local sCmd = chat:ToCmd()
										--print(sCmd)
										hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_SINGLE_MESSAGE, sCmd)
										
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
								--"您的军团邀请函已存在"
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_INVITE_EXISTED
							end
						else
							--"参数不合法"
							ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
						end
					else
						--"当前已有军团邀请函数量达到上限"
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_INVITE_TOOMAYN
					end
				else
					--"只有会长才能发送军团邀请函"
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_INVITE_ADMIN
				end
				
			else
				--"您不在此军团里"
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
	
	--请求申请通过军团邀请函加入军团
	function InviteGroupMgr:GroupInviteJoin(user, rid, groupInviteId)
		local ret = 0
		local sRetCmd = ""
		local msgId = 0
		local groupId = 0
		local groupLv = 0
		
		--玩家所在的工会id
		local uid = user:GetUID()
		local groupId_uid = hGlobal.groupMgr:GetUserGroupID(uid) --玩家所在的工会id
		if (groupId_uid == 0) then
			--玩家离开军团的时间(秒)
			local leavesecounds = hGlobal.groupMgr:GetUserLeaveTime(0, uid)
			if (leavesecounds > 86400) then
				--找到军团邀请函
				local inviteGroup = self._inviteGroupDictionary[groupInviteId]
				if inviteGroup then
					groupId = inviteGroup._groupId
					local dayMin = inviteGroup._dayMin --需要的最小注册天数
					local vipMin = inviteGroup._vipMin --需要的最小vip等级
					msgId = inviteGroup._msg_id --消息id
					if (groupId > 0) then
						--检测军团人数是否已满
						local iMasterUid, iDissolution, iMemberCount, iMaxMember = NoviceCampMgr.private.Data_GetNcInfo(groupId)
						if (iDissolution == 0) then
							--检测军团人数是否未满
							if (iMemberCount < iMaxMember) then
								--检测vip等级
								local vipLv = hGlobal.vipMgr:DBGetUserVip(uid) --玩家vip等级
								if (vipLv >= vipMin) then
									--可以加入军团
									--检测玩家之前是否已申请了别的军团
									local iNcId, iLevel = NoviceCampMgr.private.Data_GetMemberInfo(uid)
									if iLevel then
										NoviceCampMgr.private.Data_UpdateMemberNcid(uid, groupId)
										
									else
										NoviceCampMgr.private.Data_InsertMember(uid, groupId, 0)
									end
									
									NoviceCampMgr.private.Data_SetMemberLevel(uid, 1)
									NoviceCampMgr.private.Data_IncreaseMemberCount(groupId)
									
									--触发事件，玩家通过军团邀请函加入了军团
									groupLv = 1
									hGlobal.groupMgr:OnAddGroupInviteMember(groupId, iMasterUid, uid, 1)
									
									--操作成功
									ret = 1
								else
									--"您的VIP等级不符合军团邀请函条件"
									ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_INVITE_VIP
								end
							else
								--"军团人数已满"
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_MENBER_NUM_MAX
							end
						else
							--该军团不存在或已解散
							ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISSOLUTION_GROUP
						end
					else
						--"参数不合法"
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
					end
				else
					--"军团邀请函不存在或已过期"
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_INVITE_EXPIRED
				end
			else
				--"退出军团24小时以上才能申请"
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_JOIN_24HOUR
			end
		else
			--"您已加入了军团"
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_JOIN_GROUP
		end
		
		--字符串拼接
		sRetCmd = tostring(ret) .. ";" .. tostring(groupInviteId) .. ";" .. tostring(msgId) .. ";" .. tostring(groupId) .. ";" .. tostring(groupLv) .. ";"
		
		return ret, sRetCmd
	end
	
	--军团邀请函更新(60秒)
	function InviteGroupMgr:Update()
		local self = hGlobal.inviteGroupMgr --self
		
		--输出信息
		local timeNow = hApi.GetClock()
		if (self._statisticsTime > -1) and (timeNow - self._statisticsTime > 60000) then
			local lasttimestamp = self._statisticsTimestamp
			local currenttimestamp = os.time()
			
			self._statisticsTime = timeNow
			self._statisticsTimestamp = currenttimestamp
			
			--检测是否有过期的军团邀请函
			--print(#self._inviteGroupList)
			for i = 1, #self._inviteGroupList, 1 do
				local inviteGroup = self._inviteGroupList[i]
				local inviteGroupId = inviteGroup:GetID()
				local expire_time = inviteGroup._expire_time --红包过期时间
				local nExpireTime = hApi.GetNewDate(expire_time)
				--print(currenttimestamp, redPacketId, expire_time, nExpireTime)
				if (currenttimestamp > nExpireTime) then
					--print("inviteGroup Expire:", inviteGroupId)
					
					--移除此军团邀请函信息
					self._inviteGroupDictionary[inviteGroupId] = nil
					
					--移除此红包的接收信息
					table.remove(self._inviteGroupList, i)
					
					--删除聊天表里的内存数据
					local inviteChatList = hGlobal.chatMgr._inviteChatList
					for j = 1, #inviteChatList, 1 do
						local chat_j = inviteChatList[j]
						if (chat_j:GetID() == inviteGroup._msg_id) then --找到了
							table.remove(inviteChatList, j)
							break
						end
					end
					
					--通知删除消息
					local alludbid = hGlobal.uMgr:GetAllUserUID()
					local sCmd = tostring(inviteGroup._msg_id)
					hApi.xlNet_Send(alludbid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_REMOVE_MESSAGE, sCmd)
					
					--一次循环只删除一个
					break
				end
			end
			
			--更新军团邀请函的军团信息
			for i = 1, #self._inviteGroupList, 1 do
				local inviteGroup = self._inviteGroupList[i]
				local groupId = inviteGroup._groupId --军团id
				local sSql = string.format("SELECT `name`, `descripe`, `count_member`, `max_member`, `country`, `buildinfo` FROM novicecamp_list WHERE `id` = %d", groupId)
				local iErrorCode, name, descripe, count_member, max_member, country, buildInfo = xlDb_Query(sSql)
				if (iErrorCode == 0) then
					local groupName = name
					local groupLevel = 0
					local groupForce = country
					local groupMember = count_member
					local groupMemberMax = max_member
					local groupIntroduce = descripe
					
					local townId = 80068 --主城id
					if (type(buildInfo) == "string") then
						if (buildInfo ~= "") then
							local tmp = "local strCfg = ".. tostring(buildInfo) .. " return strCfg"
							local tBuildInfo = assert(loadstring(tmp))()
							if (type(tBuildInfo) == "table") then
								local buildlist = tBuildInfo.buildlist
								if buildlist then
									for i = 1, #buildlist, 1 do
										if (buildlist[i].id == townId) then --找到了
											groupLevel = buildlist[i].lv
											break
										end
									end
								end
							end
						end
					end
					
					inviteGroup._groupName = groupName --军团名
					inviteGroup._groupLevel = groupLevel --军团等级
					inviteGroup._groupForce = groupForce --军团阵营
					inviteGroup._groupMember = groupMember --军团当前人数
					inviteGroup._groupMemberMax = groupMemberMax --军团总人数
					inviteGroup._groupIntroduce = groupIntroduce --军团介绍
				end
			end
		end
	end
	
return InviteGroupMgr