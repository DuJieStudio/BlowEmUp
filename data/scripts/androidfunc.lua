--local iChannelId = xlGetChannelId()
--if iChannelId < 100 then
	--return
--end

--��׿�����нӿ� ���ֿ��ܻ����س���ӿ�
local _TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()

--ע�������
xlAddRegistCount = function(val)
	local count = xlGetRegistCount()
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		xlSaveIntToKeyChain("RegistCount",count+val)
	else
		CCUserDefault:sharedUserDefault():setIntegerForKey("RegistCount",count+val)
		CCUserDefault:sharedUserDefault():flush()
	end
end

--���ؼ�������ֵ
xlGetRegistCount = function()
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		return xlGetIntFromKeyChain("RegistCount")
	else
		return CCUserDefault:sharedUserDefault():getIntegerForKey("RegistCount")
	end
end
--����Ƿ��п�λ����û���ظ�UID���򷵻�����
xlCheckUserIndex = function(UID)
	local uid = 0
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		for i = 1,3 do
			uid = xlGetIntFromKeyChain("UsedUid_"..i)
			if uid == 0 then 
				return i
			elseif uid == UID then
				return i
			end
		end
	else
		for i = 1,3 do
			uid= CCUserDefault:sharedUserDefault():getIntegerForKey("UsedUid_"..i)
			if uid == 0 then 
				return i 
			elseif uid == UID then
				return i
			end
		end
	end

	return nil
end

--��������ʹ�ù���UID ����ౣ��3�� ��keyChina��������Զ����3��UID����ĳ��λ��Ϊ0ʱд��
xlAppendUID2KeyChain = function(UID,PASSWORD,INDEX)
	--����Ƿ��п�λ���û�� �򸲸�
	local i =  xlCheckUserIndex(UID) 
	if i == nil then
		if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
			xlSaveIntToKeyChain("UsedUid_"..INDEX,UID)
			xlSaveIntToKeyChain("UsedPas_"..INDEX,PASSWORD)
		else
			CCUserDefault:sharedUserDefault():setIntegerForKey("UsedUid_"..INDEX,UID)
			CCUserDefault:sharedUserDefault():setIntegerForKey("UsedPas_"..INDEX,PASSWORD)
			CCUserDefault:sharedUserDefault():flush()
		end

		xlSetLastUserIndex(INDEX)
	else
		if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
			xlSaveIntToKeyChain("UsedUid_"..i,UID)
			xlSaveIntToKeyChain("UsedPas_"..i,PASSWORD)
		else
			CCUserDefault:sharedUserDefault():setIntegerForKey("UsedUid_"..i,UID)
			CCUserDefault:sharedUserDefault():setIntegerForKey("UsedPas_"..i,PASSWORD)
			CCUserDefault:sharedUserDefault():flush()
		end

		xlSetLastUserIndex(i)
	end
end


--��ȡ���ʹ�õ��û�λ
xlGetLastUserIndex = function()
	--��windows��
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		return xlGetIntFromKeyChain("Last_Client_uid_Index")
	--PC��
	else
		return CCUserDefault:sharedUserDefault():getIntegerForKey("Last_Client_uid_Index")
	end
end

xlSetLastUserIndex = function(index)
	--��windows��
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		xlSaveIntToKeyChain("Last_Client_uid_Index",index)
	--PC��
	else
		CCUserDefault:sharedUserDefault():setIntegerForKey("Last_Client_uid_Index",index)
		CCUserDefault:sharedUserDefault():flush()
	end
end

--�ӱ���keyChain�л�ȡ����UID������
xlGetUIDFromKeyChain = function(index)
	if index == 0 or index == nil then return end
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		return xlGetIntFromKeyChain("UsedUid_"..index),xlGetIntFromKeyChain("UsedPas_"..index)
	else
		return CCUserDefault:sharedUserDefault():getIntegerForKey("UsedUid_"..index),CCUserDefault:sharedUserDefault():getIntegerForKey("UsedPas_"..index)
		
	end
end

--if hVar.OPTIONS.GAME_MODEL == 1 then
	xlPlayer_GetUID = function()
		--��windows��
		if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
			return xlGetIntFromKeyChain("Last_Client_uid")
		--PC��
		else
			return CCUserDefault:sharedUserDefault():getIntegerForKey("Last_Client_uid")
		end
	end

	xlPlayer_SetUID = function(uid,password,index)
		--��windows��
		if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
			xlSaveIntToKeyChain("Last_Client_uid",uid)
		--PC��
		else
			CCUserDefault:sharedUserDefault():setIntegerForKey("Last_Client_uid",uid)
			CCUserDefault:sharedUserDefault():flush()
		end
		
		if type(tonumber(password)) == "number" then
			--���ʹ�õ�UID������
			xlAppendUID2KeyChain(uid,password,index)
		end

		local iChannelId = xlGetChannelId()
		if iChannelId < 100 then
			if g_tTargetPlatform.kTargetWindows == CCApplication:sharedApplication():getTargetPlatform() then
				CCUserDefault:sharedUserDefault():setIntegerForKey("UID",uid)
				CCUserDefault:sharedUserDefault():flush()
			else
				xlSaveIntToKeyChain("Client_uid",uid)
			end
			if "function" == type(xlIosSetingSetUid) then
				xlIosSetingSetUid(uid)
			end
		end
	end
--end


--��׿�����нӿ� ���ֿ��ܻ����س���ӿ�
--��ȡ�浵�汾��
xlPlayer_GetSnapShotID = function(uid)
	local _TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
	
	--��windows��
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		return xlGetIntFromKeyChain("Last_Client_snapshitid_" .. uid)
	--PC��
	else
		return CCUserDefault:sharedUserDefault():getIntegerForKey("Last_Client_snapshitid_" .. uid)
	end
end

--��׿�����нӿ� ���ֿ��ܻ����س���ӿ�
--���ô浵�汾��
xlPlayer_SetSnapShotID = function(uid, snapshotID)
	local _TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
	
	--��windows��
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		xlSaveIntToKeyChain("Last_Client_snapshitid_" .. uid, snapshotID)
	--PC��
	else
		CCUserDefault:sharedUserDefault():setIntegerForKey("Last_Client_snapshitid_" .. uid, snapshotID)
		CCUserDefault:sharedUserDefault():flush()
	end
end

--�Ӳ����ַ����н�ȡ��Ӧmode�� keyChainֵ�����ұ���������keyChain�� 
--mode ���� IU ( itenUniqueID ) ��ʽ����"SU:15;IU:12;US:13;"
xlGetKeyChinaVal = function(mode,keyChain)
	local tempStr = {}
	if type(keyChain) == "string" then
		for v in string.gfind(keyChain,"([^%;]+);+") do
			tempStr[string.sub(v,1,2)]= tonumber(string.sub(v,4,string.len(v)))
		end
	end

	return tempStr[mode] or 0
end

--����keyChain��Ӧ��ֵ������ keyChain��
xlSetKeyChinaVal = function(mode,keyChain)
	local val = xlGetKeyChinaVal(mode,keyChain)
	--Ŀǰֻ�е���ΨһID ��mode �Ժ����չ
	if mode == "IU" then
		--���װ��ΨһUIDֵ
		local realVal = hApi.CheckItemUniqueID(val)
		--��windows
		if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
			xlSaveIntToKeyChain("xl_"..tostring(xlPlayer_GetUID()).."_ItemUniqueID",realVal)
		--windows
		else
			CCUserDefault:sharedUserDefault():setIntegerForKey("xl_"..tostring(xlPlayer_GetUID()).."_ItemUniqueID",realVal)
			CCUserDefault:sharedUserDefault():flush()
		end
		--�����ֵ��ͬ��  �������ֵ
		if realVal ~= val then
			hApi.Update_KeyChain()
		end
	elseif mode == "MU" then
		--IOS
		if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
			xlSaveIntToKeyChain("xl_"..tostring(xlPlayer_GetUID()).."_MapUniqueID",val)
		--windows
		else
			CCUserDefault:sharedUserDefault():setIntegerForKey("xl_"..tostring(xlPlayer_GetUID()).."_MapUniqueID",val)
			CCUserDefault:sharedUserDefault():flush()
		end
	end
end

--��ȡ���ݷֶε��ϴ�״̬
xlGetDateSendState = function(mode)
	--��windows
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		return xlGetIntFromKeyChain("xl_"..tostring(xlPlayer_GetUID())..mode)

	--PC��
	else
		return CCUserDefault:sharedUserDefault():getIntegerForKey("xl_"..tostring(xlPlayer_GetUID())..mode)
	end
end

--�����ϴ�״̬ --�򷽷��䶯 �����ϴ�ʱ�� 
xlSetDateSendState = function(mode,val)
	--��windows
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		xlSaveIntToKeyChain("xl_"..tostring(xlPlayer_GetUID())..mode,val)			--״̬
	--windows
	else
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_"..tostring(xlPlayer_GetUID())..mode,val)
		CCUserDefault:sharedUserDefault():flush()
	end
end

--�ϴ��浵��ʱ���� �ݶ� 10�� 10000
G_SendDataInterval = 10
xlGetLastSendInterval = function()
	local LastTime = 0
	--��׿
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		LastTime = xlGetIntFromKeyChain("xl_"..tostring(xlPlayer_GetUID()).."_LastSendInterval".."_time")
	--window
	else
		LastTime = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_"..tostring(xlPlayer_GetUID()).."_LastSendInterval".."_time")
	end
	local CurTime = tonumber(os.date("%m%d%H%M%S"))
	--��ǰʱ�����һ���ϴ�ʱ�� �����Ƿ���ڼ��

	if (CurTime - LastTime) > G_SendDataInterval then
		return 1
	else
		return 0
	end
end

--�ɹ��ϴ��� �����ϴ���ʱ��
xlSetLastSendInterval = function(Time)
	Time = (Time or tonumber(os.date("%m%d%H%M%S")))
	--��׿
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		xlSaveIntToKeyChain("xl_"..tostring(xlPlayer_GetUID()).."_LastSendInterval".."_time",Time)
	--windows
	else
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_"..tostring(xlPlayer_GetUID()).."_LastSendInterval".."_time",Time)
		CCUserDefault:sharedUserDefault():flush()
	end
end

--��ȡ��½UID�ڱ����豸�еĴ浵�����ۼ���
xlGetUIDSaveCount = function()
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		return xlGetIntFromKeyChain("xl_"..tostring(xlPlayer_GetUID()).."_save_count")
	--PC��
	else
		return CCUserDefault:sharedUserDefault():getIntegerForKey("xl_"..tostring(xlPlayer_GetUID()).."_save_count")
	end
end

--���浵����ʱ���浵����������
xlAddUIDSaveCount = function()
	local cur_count = xlGetUIDSaveCount()
	cur_count = cur_count + 1

	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		xlSaveIntToKeyChain("xl_"..tostring(xlPlayer_GetUID()).."_save_count",cur_count)
	--windows
	else
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_"..tostring(xlPlayer_GetUID()).."_save_count",cur_count)
		CCUserDefault:sharedUserDefault():flush()
	end

	return cur_count
end

--���ÿ���ID(���豸��������ԭ��  ����ID����)
xlSetUIDSaveCount = function(nCount)
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		xlSaveIntToKeyChain("xl_"..tostring(xlPlayer_GetUID()).."_save_count",nCount)
	--windows
	else
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_"..tostring(xlPlayer_GetUID()).."_save_count",nCount)
		CCUserDefault:sharedUserDefault():flush()
	end
end

xlSaveTempData = function(mode,data_str)
	LuaSaveGameData(g_localfilepath..tostring(xlPlayer_GetUID()).."_"..mode,data_str)
end

--[��ʱ���������ѷ���]
--��׿���ϴ��浵�ļ�ʱ�� �ݶ�5��һ�μ�⣬������ֱ����ϴ����ݱ��Ϊ1���Ҵ������� �Ϳ����ϴ� 
--hApi.addTimerForever("__AndroidDataUpdateTimer",hVar.TIMER_MODE.GAMETIME,5000,function(tick)
	--if g_curPlayerName == nil then return end

	--GluaSendNetCmd[hVar.ONLINECMD.CMD_SEND_GAME_DATA](xlGetUIDSaveCount())

	--GluaSendNetCmd[hVar.ONLINECMD.CMD_HEART_BEAT]()
--end)

xlRealNameCheckMode = function()
	--���ݿ����ÿ���
	if g_OBSwitch and g_OBSwitch.channelavoidRealname == 1 then
		return false
	end
	--����������
	if g_lua_src == 1 and hVar.RealNameMode == 1 then
		return true
	end

	local channel_id= getChannelInfo()
	if channel_id == 999 then
		return true
	elseif channel_id == 100 then
		return true
	end

	return false
end

hApi.FormatSaveDataByStr = function(uid,num,dataList,imaccmp,useDic,snapshotID) 
	local cur_savecount = xlGetUIDSaveCount()
	--�������� ���������û���·����ݣ����߿���ID��0 ����Ϊ����ң��Ȳ��������ļ�
	if type(dataList) ~= "table" or snapshotID == 0 then 
		--�����ļ���������
		hApi.CreateNewPlayerData()

		if hApi.FileExists(g_localfilepath..tostring(uid).."_"..g_curPlayerName..hVar.SAVE_DATA_PATH.MAP_SAVE,"full") == true then
			xlDeleteFileWithFullPath(g_localfilepath..tostring(uid).."_"..g_curPlayerName..hVar.SAVE_DATA_PATH.MAP_SAVE)
			
		end
		if hApi.FileExists(g_localfilepath..tostring(uid).."_"..g_curPlayerName..hVar.SAVE_DATA_PATH.FOG,"full") == true then
			xlDeleteFileWithFullPath(g_localfilepath..tostring(uid).."_"..g_curPlayerName..hVar.SAVE_DATA_PATH.FOG)
		end
		return "NewPlayer"
	end
	
	local keyList = {}
	local rs = ""
	--��������ҵ������ �ֱ��ж�N������
	for i = 1,num * 2,2 do
		local key,data = dataList[i],dataList[i+1]
		local f = loadstring(data)
		--�쳣����
		if f == nil then
			hGlobal.event:event("LocalEvent_showLuaAndroidtErrorFrm",data,key,1)
			return "ERROR:"..key..";"
		end
		--����б����ļ�
		if hApi.FileExists(g_localfilepath..tostring(uid).."_"..hVar.SAVE_DATA_PATH[hVar.CONST_KEY2PATH[key]],"full") == true then
			--�Ƿ�����豸���Ƿ�ǿ��ˢ�£��Ƿ��������С�ڷ������� ����1 ���ȡ����������
			if imaccmp ~= 0 or useDic == 1 or snapshotID > cur_savecount then
				rs = rs..key..":1:1;"
				f()
				keyList[#keyList+1] = key
				--hApi.OnSaveData(hVar.CONST_KEY2PATH[key])
			else
				rs = rs..key..":1:0;"
				local fill_uid = hApi.GetTitleInfoByFile(hVar.SAVE_DATA_PATH[hVar.CONST_KEY2PATH[key]])
				if uid == fill_uid then
					LuaLoadSavedGameData(hApi.LinkString(g_localfilepath,tostring(uid),"_",hVar.SAVE_DATA_PATH[hVar.CONST_KEY2PATH[key]]))
					if key == "bag" then
						if Save_PlayerData and Save_PlayerData.bag == nil then
							--��ȡ����ʧ��
							rs = rs..":fail;"
							f()
						end
					end
					--ֻ�б��ش浵�µ�ʱ����ϴ��浵
					keyList[#keyList+1] = key
					--hApi.OnSaveData(hVar.CONST_KEY2PATH[key])
				elseif fill_uid == -1 then
					--�浵��  �ӷ�������ȡ
					rs = rs..":noUID;"
					f()
					--hApi.OnSaveData(hVar.CONST_KEY2PATH[key])
				else
					--����ʹ�ñ��˵Ĵ浵
					hGlobal.UI.MsgBox(hApi.LinkString(hVar.tab_string["__TEXT_Can'tOpenOtherPlayerList"],"\n1-[",uid,"]-","\n1-[",fill_uid,"]-"),{
						font = hVar.FONTC,
						ok = function()
							xlExit()
						end,
					})
					break
					rs = "cheat_player:"..uid.."|"..fill_uid..";"
				end
			end
		--û�д浵���ȡ������
		else
			rs = rs..key..":0:1;"
			f()
			xlSetUIDSaveCount(snapshotID)
			--hApi.OnSaveData(hVar.CONST_KEY2PATH[key])
		end
	end

	rs = rs .. "shotID:"..snapshotID..":"..cur_savecount..";"

	--ͳһһ�����ϴ��浵
	hApi.OnSaveDataWithList(keyList,1,snapshotID)
	--for i = 1,#keyList do
		--local key = keyList[i]
		--hApi.OnSaveData(hVar.CONST_KEY2PATH[key],1)
	--end

	return rs
end


--if type(xlRotateScreen) ~= "function" then
	local iChannelId = xlGetChannelId()
	if iChannelId >= 100 then
		xlRotateScreen = function(orientation, lock_flag)
			--������5   
			local mode = 5
			if lock_flag == 1 then
				if orientation == 1 then
					mode = 1
				elseif orientation == 2 then
					if g_CurScreenMode == 1 then
						mode = 4
					else
						mode = 3
					end
				end
			end
			if type(xlSetOrientation) == "function" then
				xlSetOrientation(mode)
			end
		end
	end
--end

--if type(xlGetScreenRotation) ~= "function" then
	local iChannelId = xlGetChannelId()
	if iChannelId >= 100 then
		xlGetScreenRotation = function()
			--1 = ����		2 = ����
			local orientation,mode = xlGetOrientation()
			local lock_flag = 1
			if mode == 5 then
				lock_flag = 0
			end
			return orientation,lock_flag
		end
	end
	
--end

--��׿�涨���̵���ߵĵط�
--hVar.NET_SHOP_ITEM["Page_Hot"] =
--{
	----{5},{9},{6},
	--{92},{96},{103},
	--{10},{34},{35},
	--{44},
--}
--hVar.NET_SHOP_ITEM["Page_Item"] =
--{
	----{1},{3},{5},
	----[[{7},{9},]]{2},
	--{4},{6},{8},
--}
