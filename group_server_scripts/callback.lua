
--服务器玩家登陆回调
--参数: 玩家id, 当前使用角色id, 
--rType: 类型1in 2out 3dis, 
--iTag: 登陆类型0 正常登陆, 1游戏内重连
function xlcallback_logevent(udbid, rid, rType, iTag)
	--玩家登陆
	if rType == 1 then
		print("====user login====:", udbid, rid, "rType=" .. tostring(rType) .. ", iTag=" .. tostring(iTag))
		hApi.Log(0, string.format("====user login====:%s,%s,%s,%s", tostring(udbid), tostring(rid), tostring(rType), tostring(iTag)))
		
		local newUser = false
		--玩家登陆，查找是否已经有玩家信息
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--没有玩家，则创建新玩家
		if not user then
			user = hGlobal.uMgr:CreateUser(udbid, rid)
			newUser = true
		end
		
		--是否是新玩家
		if newUser then
			local sCmd = hGlobal.uMgr:LoginResultToCmd(1, user:GetID())
			hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_NOTICE_USER_LOGIN, sCmd) --发送登陆成功回调
			
			print("login ok:",udbid, rid)
		else
			local sCmd = hGlobal.uMgr:LoginResultToCmd(1, user:GetID())
			hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_NOTICE_USER_LOGIN, sCmd) --发送登陆成功回调
		end
	--玩家离线
	else
		print("====user logOut====:",udbid, rid, rType)
		hApi.Log(0, string.format("====user logOut====:%s,%s,%s",tostring(udbid),tostring(rid),tostring(rType)))
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--print("logOut leave room:", user, user:IsInRoom())
		--如果玩家在房间中，则释放房间中的玩家信息
		if user then
			--临时,玩家退出才会更新配置至服务器(英雄数据是实时保存的，退出时不处理)
			--user:SaveData(true,true,true,false,false)
			
			--释放玩家信息
			hGlobal.uMgr:ReleaseUserByDBID(udbid)
			
			--更新数据库玩家的最近军团离线时间
			local sUpdate = string.format("UPDATE `t_chat_user` SET `last_offline_time` = NOW() WHERE `uid` = %d", udbid)
			xlDb_Execute(sUpdate)
		else
			--print("logOut leave error:")
			
			hApi.xlNet_Send(udbid,hVar.PVP_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.NETERR.ROOM_LEAVE_FAILD))
		end
	end
end

--客户端脚本协议的入口
function xlcallback_netevent(udbid, rid, msgId, iparam1, iparam2, sCmd)
	--local time = hApi.GetClock()
	--print("====xlcallback_netevent====", udbid, rid, msgId, sCmd)
	local function __NetCmd()
		if hHandler.C2L_GROUP_OPR[msgId] then
			if 1000 < msgId then
				hHandler.C2L_GROUP_OPR[msgId](udbid, rid, msgId, sCmd)
			else
				local tCmd = hApi.Split(sCmd,";")
				hHandler.C2L_GROUP_OPR[msgId](udbid, rid, msgId, tCmd)
			end
		end
	end
	
	xpcall(__NetCmd,hGlobal.__TRACKBACK__)
	
	
	--time = hApi.GetClock() - time
	
	--print("time:", time)
end

--工会服务器update
function xlcallback_updateevent()
	--用户更新
	if hGlobal.uMgr then
		--hGlobal.uMgr:Update()
		xpcall(hGlobal.uMgr.Update, hGlobal.__TRACKBACK__)
	end
	
	--军团更新
	if hGlobal.groupMgr then
		--hGlobal.groupMgr:Update()
		xpcall(hGlobal.groupMgr.Update, hGlobal.__TRACKBACK__)
	end
	
	--聊天更新
	if hGlobal.chatMgr then
		--hGlobal.chatMgr:Update()
		xpcall(hGlobal.chatMgr.Update, hGlobal.__TRACKBACK__)
	end
	
	--军团红包更新
	if hGlobal.redPacketGroupMgr then
		--hGlobal.redPacketGroupMgr:Update()
		xpcall(hGlobal.redPacketGroupMgr.Update, hGlobal.__TRACKBACK__)
	end
	
	--支付（土豪）红包更新
	if hGlobal.redPacketPayMgr then
		--hGlobal.redPacketPayMgr:Update()
		xpcall(hGlobal.redPacketPayMgr.Update, hGlobal.__TRACKBACK__)
	end
	
	--军团邀请函更新
	if hGlobal.inviteGroupMgr then
		--hGlobal.inviteGroupMgr:Update()
		xpcall(hGlobal.inviteGroupMgr.Update, hGlobal.__TRACKBACK__)
	end
	
	--工会更新
	if NoviceCampMgr then
		--NoviceCampMgr:Update()
		xpcall(NoviceCampMgr.Update, hGlobal.__TRACKBACK__)
	end
end
