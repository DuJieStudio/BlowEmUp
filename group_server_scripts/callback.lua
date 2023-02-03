
--��������ҵ�½�ص�
--����: ���id, ��ǰʹ�ý�ɫid, 
--rType: ����1in 2out 3dis, 
--iTag: ��½����0 ������½, 1��Ϸ������
function xlcallback_logevent(udbid, rid, rType, iTag)
	--��ҵ�½
	if rType == 1 then
		print("====user login====:", udbid, rid, "rType=" .. tostring(rType) .. ", iTag=" .. tostring(iTag))
		hApi.Log(0, string.format("====user login====:%s,%s,%s,%s", tostring(udbid), tostring(rid), tostring(rType), tostring(iTag)))
		
		local newUser = false
		--��ҵ�½�������Ƿ��Ѿ��������Ϣ
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--û����ң��򴴽������
		if not user then
			user = hGlobal.uMgr:CreateUser(udbid, rid)
			newUser = true
		end
		
		--�Ƿ��������
		if newUser then
			local sCmd = hGlobal.uMgr:LoginResultToCmd(1, user:GetID())
			hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_NOTICE_USER_LOGIN, sCmd) --���͵�½�ɹ��ص�
			
			print("login ok:",udbid, rid)
		else
			local sCmd = hGlobal.uMgr:LoginResultToCmd(1, user:GetID())
			hApi.xlNet_Send(udbid,hVar.GROUP_RECV_TYPE.L2C_NOTICE_USER_LOGIN, sCmd) --���͵�½�ɹ��ص�
		end
	--�������
	else
		print("====user logOut====:",udbid, rid, rType)
		hApi.Log(0, string.format("====user logOut====:%s,%s,%s",tostring(udbid),tostring(rid),tostring(rType)))
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--print("logOut leave room:", user, user:IsInRoom())
		--�������ڷ����У����ͷŷ����е������Ϣ
		if user then
			--��ʱ,����˳��Ż����������������(Ӣ��������ʵʱ����ģ��˳�ʱ������)
			--user:SaveData(true,true,true,false,false)
			
			--�ͷ������Ϣ
			hGlobal.uMgr:ReleaseUserByDBID(udbid)
			
			--�������ݿ���ҵ������������ʱ��
			local sUpdate = string.format("UPDATE `t_chat_user` SET `last_offline_time` = NOW() WHERE `uid` = %d", udbid)
			xlDb_Execute(sUpdate)
		else
			--print("logOut leave error:")
			
			hApi.xlNet_Send(udbid,hVar.PVP_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.NETERR.ROOM_LEAVE_FAILD))
		end
	end
end

--�ͻ��˽ű�Э������
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

--���������update
function xlcallback_updateevent()
	--�û�����
	if hGlobal.uMgr then
		--hGlobal.uMgr:Update()
		xpcall(hGlobal.uMgr.Update, hGlobal.__TRACKBACK__)
	end
	
	--���Ÿ���
	if hGlobal.groupMgr then
		--hGlobal.groupMgr:Update()
		xpcall(hGlobal.groupMgr.Update, hGlobal.__TRACKBACK__)
	end
	
	--�������
	if hGlobal.chatMgr then
		--hGlobal.chatMgr:Update()
		xpcall(hGlobal.chatMgr.Update, hGlobal.__TRACKBACK__)
	end
	
	--���ź������
	if hGlobal.redPacketGroupMgr then
		--hGlobal.redPacketGroupMgr:Update()
		xpcall(hGlobal.redPacketGroupMgr.Update, hGlobal.__TRACKBACK__)
	end
	
	--֧�����������������
	if hGlobal.redPacketPayMgr then
		--hGlobal.redPacketPayMgr:Update()
		xpcall(hGlobal.redPacketPayMgr.Update, hGlobal.__TRACKBACK__)
	end
	
	--�������뺯����
	if hGlobal.inviteGroupMgr then
		--hGlobal.inviteGroupMgr:Update()
		xpcall(hGlobal.inviteGroupMgr.Update, hGlobal.__TRACKBACK__)
	end
	
	--�������
	if NoviceCampMgr then
		--NoviceCampMgr:Update()
		xpcall(NoviceCampMgr.Update, hGlobal.__TRACKBACK__)
	end
end
