--local iChannelId = xlGetChannelId()
--if iChannelId < 100 then
	--return
--end

--����Э���ʹ���
GluaSendNetCmd = {}
GluaSendNetCmd[hVar.ONLINECMD.PLANTFORM_ASK] = function(t_type,account)
	local send = {}
	send[1] = hVar.ONLINECMD.PLANTFORM_ASK
	send[2] = 0
	send[3] = t_type
	send[4] = account
	print("PLANTFORM_ASK".." "..send[1].." "..send[2].." "..send[3].." "..send[4])
	Game_Server.Send(send)
end
GluaSendNetCmd[hVar.ONLINECMD.NEW_LOGIN] = function(t_type,uid,pass,itag,reconnection)
		local chid = getChannelInfo()+10000
		local send = {}
		send[1] = hVar.ONLINECMD.NEW_LOGIN
		send[2] = chid
		send[3] = t_type
		send[4] = uid
		send[5] = pass
		send[6] = itag or 0
		send[7] = reconnection or 0
		send[8] = xlIsSystemBroken()
		send[9] = xlIsAppBroken()
		send[10] = xlGetMemoryInfo()
		send[11] = xlGetDeviceName() or ""
		send[12] = xlGetSystemName() or ""
		send[13] = xlGetModelName() or ""
		send[14] = xlGetBundleID() or ""
		send[15] = xlGetMacAddress() or ""
		send[16] = xlGetOpenUDID() or ""
		send[17] = xlGetIdentifierForVendor() or ""
		send[18] = xlGetAdvertisingIdentifier() or ""
		send[19] = xlGetSystemVersion() or ""

		local verPc =xlGetExeVersion()
		local verLua = hVar.CURRENT_ITEM_VERSION

		send[20] = tostring(verLua).."-"..tostring(verPc)
		send[21] = xlSystemLanguage()

		Game_Server.Send(send)
end

GluaSendNetCmd[hVar.ONLINECMD.NEW_REGISTER] = function(reg_type,other_str,name,pass)

		local chid = getChannelInfo()+10000
		local send = {}
		send[1] = hVar.ONLINECMD.NEW_REGISTER
		send[2] = chid
		send[3] = reg_type
		send[4] = other_str
		send[5] = name
		send[6] = pass
		Game_Server.Send(send)
end


--��׿��Ϸ�����µ�½
GluaSendNetCmd[hVar.ONLINECMD.NEW_RE_LOGIN] = function(t_type,uid,pass,itag,reconnection)
		local chid = getChannelInfo()+10000
		local send = {}
		send[1] = hVar.ONLINECMD.NEW_RE_LOGIN
		send[2] = chid
		send[3] = t_type
		send[4] = uid
		send[5] = pass
		send[6] = itag or 0
		send[7] = reconnection or 0
		send[8] = xlIsSystemBroken()
		send[9] = xlIsAppBroken()
		send[10] = xlGetMemoryInfo()
		send[11] = xlGetDeviceName() or ""
		send[12] = xlGetSystemName() or ""
		send[13] = xlGetModelName() or ""
		send[14] = xlGetBundleID() or ""
		send[15] = xlGetMacAddress() or ""
		send[16] = xlGetOpenUDID() or ""
		send[17] = xlGetIdentifierForVendor() or ""
		send[18] = xlGetAdvertisingIdentifier() or ""
		send[19] = xlGetSystemVersion() or ""
		
		local verPc = xlGetExeVersion()
		local verLua = hVar.CURRENT_ITEM_VERSION
		
		send[20] = tostring(verLua).."-"..tostring(verPc)
		send[21] = tostring(g_login_token)
		Game_Server.Send(send)
end

GluaSendNetCmd[hVar.ONLINECMD.BIND_PLANTFORM] = function(uid,reg_type,account,name)
	local send = {}
	send[1] = hVar.ONLINECMD.BIND_PLANTFORM
	send[2] = 0
	send[3] = uid
	send[4] = reg_type
	send[5] = account
	if name then
	send[6] = name
	end
	Game_Server.Send(send)
end

GluaSendNetCmd[hVar.ONLINECMD.BIND_PLANTFORM_OLD] = function(channelid,uid,pass)
	local send = {}
	send[1] = hVar.ONLINECMD.BIND_PLANTFORM_OLD
	send[2] = 0
	send[3] = channelid
	send[4] = uid
	send[5] = pass
	Game_Server.Send(send)
end

--UID  ��¼����  �˺�key
GluaSendNetCmd[hVar.ONLINECMD.UNBIND_PLANTFORM] = function(uid,reg_type,account)
	local send = {}
	send[1] = hVar.ONLINECMD.UNBIND_PLANTFORM
	send[2] = 0
	send[3] = uid
	send[4] = reg_type
	send[5] = account
	Game_Server.Send(send)
end

GluaSendNetCmd[hVar.ONLINECMD.GET_INFO_AFTER_LOGIN] = function(protocol)
	local send = {}
	send[1] = hVar.ONLINECMD.GET_INFO_AFTER_LOGIN
	send[2] = protocol or 0		--protocol
	Game_Server.Send(send)
end

--��½�ɹ����ȡ�浵�ӿ� 4001
GluaSendNetCmd[hVar.ONLINECMD.REQUEST_SAVE] = function(uid,rid,mode,name)
	local send = {}
	send[1] = hVar.ONLINECMD.REQUEST_SAVE
	send[2] = 0
	send[3] = uid
	send[4] = rid
	send[5] = mode		--���Ȼ�ȡ data
	send[6] = name		--��������
	Game_Server.Send(send)
end

--�ͻ��� �ϴ��浵 4004
GluaSendNetCmd[hVar.ONLINECMD.SEND_SAVE_FILE] = function(protocol,uid,rid,type,data)
	local send = {}
	send[1] = hVar.ONLINECMD.SEND_SAVE_FILE
	send[2] = protocol		--protocol
	send[3] = uid		--uid
	send[4] = rid		--rid
	send[5] = type		--0 / 1  ��Ӧ data/log
	send[6] = data
	Game_Server.Send(send)
end

--4007 ֪ͨ��������ȡӢ���� hero
GluaSendNetCmd[hVar.ONLINECMD.CMD_OBTAINHERO] = function(uid,rid,heroid)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_OBTAINHERO
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	send[5] = heroid or 0
	Game_Server.Send(send)
end

--4009 ֪ͨ������������ͼ map
GluaSendNetCmd[hVar.ONLINECMD.CMD_OBTAINMAP] = function(uid,rid,mapid)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_OBTAINMAP
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	send[5] = mapid
	Game_Server.Send(send)
end

--4011 ��ȡhero�� field�ֶ� �� t_cha��bag�ֶ�
GluaSendNetCmd[hVar.ONLINECMD.CMD_LOADBAG] = function(uid,rid,type,heroid)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_LOADBAG
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	send[5] = type
	send[6] = heroid
	Game_Server.Send(send)
end

--4013 ����hero�� field�ֶ� �� t_cha��bag�ֶ�
GluaSendNetCmd[hVar.ONLINECMD.CMD_UPDATEBAG] = function(uid,rid,type,heroid,field,bag)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_UPDATEBAG
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	send[5] = type
	send[6] = heroid
	send[7] = field
	send[8] = bag
	Game_Server.Send(send)
end

--4015 ��ȡt_cha card��Ϣ
GluaSendNetCmd[hVar.ONLINECMD.CMD_LOADCARD] = function(uid,rid)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_LOADCARD
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	Game_Server.Send(send)
end

--4017 ����t_cha card��Ϣ
GluaSendNetCmd[hVar.ONLINECMD.CMD_UPDATECARD] = function(uid,rid,card)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_UPDATECARD
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	send[5] = card
	Game_Server.Send(send)
end

--4102 ��ȡmap info��Ϣ
GluaSendNetCmd[hVar.ONLINECMD.CMD_LOADMAP] = function(uid,rid)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_LOADMAP
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	Game_Server.Send(send)
end

--4021 ����map info��Ϣ
GluaSendNetCmd[hVar.ONLINECMD.CMD_UPDATEMAP] = function(uid,rid,mapid,info)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_UPDATEMAP
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	send[5] = mapid
	send[6] = info
	Game_Server.Send(send)
end

--4023 ��ȡroleid ��heroid list��Ϣ
GluaSendNetCmd[hVar.ONLINECMD.CMD_GETHEROLIST] = function(uid,rid)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_GETHEROLIST
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	Game_Server.Send(send)
end

--4025 ��ȡroleid ��map list��Ϣ
GluaSendNetCmd[hVar.ONLINECMD.CMD_GETMAPLIST] = function(uid,rid)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_GETMAPLIST
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	Game_Server.Send(send)
end

--��ȡroleid �� ����mapinfo��Ϣ
GluaSendNetCmd[hVar.ONLINECMD.CMD_LOADMAPLIST] = function(uid,rid)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_LOADMAPLIST
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	Game_Server.Send(send)
end

--�ϴ�����
GluaSendNetCmd[hVar.ONLINECMD.CMD_USER_SAVESCORE] = function(uid,rid,score)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_USER_SAVESCORE
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	send[5] = score
	Game_Server.Send(send)
end

--���͵ǳ�Э��
GluaSendNetCmd[hVar.ONLINECMD.CMD_LOGIN_OUT] = function(uid)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_LOGIN_OUT
	send[2] = protocol or 0
	send[3] = uid
	Game_Server.Send(send)
end

--��ȡս�����ܿ�����	
GluaSendNetCmd[hVar.ONLINECMD.CMD_LOADSKILL] = function(uid,rid)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_LOADSKILL
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	Game_Server.Send(send)
end

--����ս�����ܿ�����
GluaSendNetCmd[hVar.ONLINECMD.CMD_UPDATESKILL] = function(uid,rid,skill)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_UPDATESKILL
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	send[5] = skill
	Game_Server.Send(send)
end

--��ȡ�����������
GluaSendNetCmd[hVar.ONLINECMD.CMD_LOADMATERIAL] = function(uid,rid)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_LOADMATERIAL
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	Game_Server.Send(send)
end

--���¶����������
GluaSendNetCmd[hVar.ONLINECMD.CMD_UPDATEMATERIAL] = function(uid,rid,material)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_UPDATEMATERIAL
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	send[5] = material
	Game_Server.Send(send)
end

--�����ȡ�������ϵ�keyChain
GluaSendNetCmd[hVar.ONLINECMD.CMD_LOAD_KEYCHAIN] = function(uid,rid)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_LOAD_KEYCHAIN
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	Game_Server.Send(send)
end

--���·������ϵ�keyChain
GluaSendNetCmd[hVar.ONLINECMD.CMD_UPDATE_KEY_CHAIN] = function(uid,rid,keychain)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_UPDATE_KEY_CHAIN
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	send[5]	= keychain
	Game_Server.Send(send)
end

--�����б�
GluaSendNetCmd[hVar.ONLINECMD.CMD_ACTIVITY_INFO] = function(uid,rid)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_ACTIVITY_INFO
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	Game_Server.Send(send)
end

--������Ϣ
GluaSendNetCmd[hVar.ONLINECMD.CMD_GET_GIFT_REWARD] = function(uid,rid,key)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_GET_GIFT_REWARD
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	send[5] = key
	Game_Server.Send(send)
end

--������Ʒ���־
GluaSendNetCmd[hVar.ONLINECMD.CMD_GET_GIFT_CONFIRM] = function(uid,rid,key,flag)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_GET_GIFT_CONFIRM
	send[2] = protocol or 0
	send[3] = uid
	send[4] = rid
	send[5] = key
	send[6] = flag or 2
	Game_Server.Send(send)
end

local _const_State2Key= {
	[hVar.DATA_SEND_STATE.TEMP_PLAYER_MAP] = "map",
	[hVar.DATA_SEND_STATE.TEMP_PLAYER_HERO] = "card",
	[hVar.DATA_SEND_STATE.TEMP_PLAYER_CARD] = "skill",
	[hVar.DATA_SEND_STATE.TEMP_PLAYER_MAT] = "material",
	[hVar.DATA_SEND_STATE.TEMP_PLAYER_BAG] = "bag",
	[hVar.DATA_SEND_STATE.TEMP_PLAYER_LOG] = "log",
}
--
--local g_item_cheat = 0
----�ϴ����ݵ������
--GluaSendNetCmd[hVar.ONLINECMD.CMD_SEND_GAME_DATA] = function(saveCount)
--	local uid = xlPlayer_GetUID()
--	local send = {}
--	send[1] = hVar.ONLINECMD.CMD_SEND_GAME_DATA
--	send[2] = protocol or 0		--��������
--	send[3] = uid	--UID
--	send[4] = luaGetplayerDataID()	--RID
--	send[5] = saveCount or 0	--1005 �浵���´���
--	
--	--���������Ƿ��Ѳ������µ�������򼸲��뷢�Ͱ�
--	local num = 0
--	local sendData = {}
--	local errorList = {}
--	for k,v in pairs(hVar.DATA_SEND_STATE) do
--		local state = xlGetDateSendState(v)
--		--Ϊ1���������Ѿ�����д
--		if state == 1 then
--			local rTab,data_s = hApi.GetSnapshotData(v)
--			local f = loadstring(data_s)
--			--�쳣����
--			if f == nil then
--				xlSetDateSendState(v,0)
--				hGlobal.event:event("LocalEvent_showLuaAndroidtErrorFrm",data_s,_const_State2Key[v],2)
--				errorList[#errorList + 1] = v
--			else
--				local isCheat = 0
--				local cheatStr = ""
--				-- ��ʼ����UID��������
--				if (k == "TEMP_PLAYER_HERO" or k == "TEMP_PLAYER_BAG") and g_CanCheckItemCheat == 1 then
--					--�Ѿ������������ټ��
--					if g_item_cheat == 0 then
--						isCheat,cheatStr = hApi.CheckItemIsCheat(k)
--						if isCheat == 1 then
--							g_item_cheat = 1
--							LuaAddCheatLog(cheatStr,"item")
--						end
--					end
--					--������������ϴ��浵
--					if g_item_cheat == 1 then
--						xlSetDateSendState("_bag",0)
--						xlSetDateSendState("_hero",0)
--					end
--				end
--				if isCheat == 0 and hApi.CheckTabIsNotEmpty(rTab) then
--					num = num+1	--��¼�ж��ٸ����ݿ���Ҫ����
--					sendData[#sendData+1] = _const_State2Key[v]
--					sendData[#sendData+1] = data_s
--					xlSetDateSendState(v,0)
--					print("v",v)
--				end
--			end
--		end
--	end
--	local cheatStr = "SaveDate Error:"
--	if #errorList > 0 then
--		for i = 1,#errorList do
--			cheatStr = cheatStr .. errorList[i] .. " "
--		end
--		SendCmdFunc["send_CheatLog"](99,44,cheatStr)
--	end
--
--	if num == 0 then
--		return 
--	end
--
--	send[6] = num
--	for i = 1,#sendData do
--		send[#send+1] = sendData[i]
--	end
--	Game_Server.Send(send)
--	xlSetLastSendInterval()
--	if hVar.OPTIONS.GAME_MODEL == 1 then
--		GluaSendNetCmd[hVar.ONLINECMD.CMD_HEART_BEAT](1)
--	end
--	print("sendData",num,hVar.ONLINECMD.CMD_SEND_GAME_DATA)
--end



--��׿���ϴ��浵�ӿ�
--�ϴ����ݵ������
GluaSendNetCmd[hVar.ONLINECMD.CMD_SAVE_NEWDIC] = function(keyList, saveDataList, snapshotID)
	local uid = xlPlayer_GetUID()
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_SAVE_NEWDIC
	send[2] = protocol or 0		--��������
	send[3] = uid	--UID
	send[4] = luaGetplayerDataID()	--RID
	send[5] = snapshotID or 1 --1005 �浵���´���
	
	--���������Ƿ��Ѳ������µ�������򼸲��뷢�Ͱ�
	local num = #keyList
	send[6] = num
	
	for i = 1, num, 1 do
		send[#send+1] = keyList[i]
		send[#send+1] = saveDataList[i]
	end
	
	Game_Server.Send(send)
	--[[
	for i = 1, #send, 1 do
		print("send[" .. i .. "]=" .. send[i])
	end
	]]
	
	--[[
	local strText = keyList[1] .. (keyList[2] and ("," .. keyList[2]) or ("")) .. (keyList[3] and ("," .. keyList[3]) or ("")) .. (keyList[4] and ("," .. keyList[4]) or ("")) .. (keyList[5] and ("," .. keyList[5]) or (""))
	hUI.floatNumber:new({
		x = hVar.SCREEN.w / 2,
		y = hVar.SCREEN.h / 2,
		align = "MC",
		text = "",
		lifetime = 2500,
		fadeout = -550,
		moveY = 32,
	}):addtext("�浵: " .. strText, hVar.FONTC, 40, "MC", 0, 0)
	print("sendData", hVar.ONLINECMD.CMD_SAVE_NEWDIC, num, strText)
	]]
end



--��ȡdic info��Ϣ
GluaSendNetCmd[hVar.ONLINECMD.CMD_LOAD_DICINFO] = function(keyList)
	local num = #keyList
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_LOAD_DICINFO
	send[2] = protocol or 0		--��������
	send[3] = xlPlayer_GetUID()	--UID
	send[4] = luaGetplayerDataID()	--RID
	send[5] = 0			--tag ��������
	send[6] = num

	for i = 1,num do
		send[#send+1] = keyList[i]
	end

	Game_Server.Send(send)
	hUI.NetDisable(99999)
	print("LoadData",hVar.ONLINECMD.CMD_LOAD_DICINFO)
end

--�ϴ������ַ���
GluaSendNetCmd[hVar.ONLINECMD.CMD_SEND_LOADSTRING_ERROR] = function(errStr)
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_SEND_LOADSTRING_ERROR
	send[2] = xlPlayer_GetUID()
	send[3] = errStr
	Game_Server.Send(send)
end


--�ϴ���½�ɹ���Ϣ
GluaSendNetCmd[hVar.ONLINECMD.CMD_LOGIN_CONFIRM] = function()
	local macAddress = xlGetMacAddress()
	local send = {}
	send[1] = hVar.ONLINECMD.CMD_LOGIN_CONFIRM
	send[2] = protocol or 0
	send[3] = xlPlayer_GetUID()
	send[4] = luaGetplayerDataID()
	send[5] = itag or 0
	send[6] = macAddress or ""
	Game_Server.Send(send)
end

--������
GluaSendNetCmd[hVar.ONLINECMD.CMD_HEART_BEAT] = function(itag)
	local send = {}
	itag = itag or 0
	send[1] = hVar.ONLINECMD.CMD_HEART_BEAT
	send[2] = protocol or 0
	send[3] = xlPlayer_GetUID()
	send[4] = itag

	if itag ~= 0 then
		--5����û�н��յ�������  ����ʾת�ջ�
		hApi.addTimerOnce("__Android_HEART_BEAT",5000,function()
			hUI.NetDisable(20000)
			g_HEART_slow = 1
			
			--��ǲ��ǵ�½״̬
			g_cur_login_state = -1
			
			hGlobal.event:event("LocalEvent_showAndroidNetAlreadyFrm",1)
		end)
	end
	Game_Server.Send(send)
end
--��׿���ϴ��浵�ļ�ʱ�� �ݶ�10��һ�μ�⣬������ֱ����ϴ����ݱ��Ϊ1���Ҵ������� �Ϳ����ϴ� 
hApi.addTimerForever("__AndroidDataUpdateTimer",hVar.TIMER_MODE.GAMETIME,15000,function(tick)
	if g_curPlayerName == nil then return end
	
	GluaSendNetCmd[hVar.ONLINECMD.CMD_HEART_BEAT](1)
end)

--��ʵ����Ϣ
GluaSendNetCmd[hVar.ONLINECMD.BIND_REALNAMEINFO] = function(nbirthday,sidcard,sname,spi)
	local send = {}
	send[1] = hVar.ONLINECMD.BIND_REALNAMEINFO
	send[2] = protocol or 0
	send[3] = xlPlayer_GetUID()
	send[4] = nbirthday or 0
	send[5] = sidcard or ""
	send[6] = sname or ""
	send[7] = spi or ""
	Game_Server.Send(send)
end

--������Ϸʱ�䣨δ�����û���
GluaSendNetCmd[hVar.ONLINECMD.REQUEST_PLAYTIME] = function()
	local send = {}
	send[1] = hVar.ONLINECMD.REQUEST_PLAYTIME
	send[2] = protocol or 0
	send[3] = xlPlayer_GetUID()
	Game_Server.Send(send)
end