--local iChannelId = xlGetChannelId()
--if iChannelId < 100 then
	--return
--end

--安卓版特有接口 部分可能会重载程序接口
local _TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()

--注册计数器
xlAddRegistCount = function(val)
	local count = xlGetRegistCount()
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		xlSaveIntToKeyChain("RegistCount",count+val)
	else
		CCUserDefault:sharedUserDefault():setIntegerForKey("RegistCount",count+val)
		CCUserDefault:sharedUserDefault():flush()
	end
end

--返回计数器的值
xlGetRegistCount = function()
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		return xlGetIntFromKeyChain("RegistCount")
	else
		return CCUserDefault:sharedUserDefault():getIntegerForKey("RegistCount")
	end
end
--检测是否有空位，且没有重复UID有则返回索引
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

--保存曾经使用过的UID ，最多保留3个 在keyChina环境中永远保留3个UID，当某个位置为0时写入
xlAppendUID2KeyChain = function(UID,PASSWORD,INDEX)
	--检测是否有空位如果没有 则覆盖
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


--获取最后使用的用户位
xlGetLastUserIndex = function()
	--非windows版
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		return xlGetIntFromKeyChain("Last_Client_uid_Index")
	--PC版
	else
		return CCUserDefault:sharedUserDefault():getIntegerForKey("Last_Client_uid_Index")
	end
end

xlSetLastUserIndex = function(index)
	--非windows版
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		xlSaveIntToKeyChain("Last_Client_uid_Index",index)
	--PC版
	else
		CCUserDefault:sharedUserDefault():setIntegerForKey("Last_Client_uid_Index",index)
		CCUserDefault:sharedUserDefault():flush()
	end
end

--从本地keyChain中获取索引UID和密码
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
		--非windows版
		if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
			return xlGetIntFromKeyChain("Last_Client_uid")
		--PC版
		else
			return CCUserDefault:sharedUserDefault():getIntegerForKey("Last_Client_uid")
		end
	end

	xlPlayer_SetUID = function(uid,password,index)
		--非windows版
		if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
			xlSaveIntToKeyChain("Last_Client_uid",uid)
		--PC版
		else
			CCUserDefault:sharedUserDefault():setIntegerForKey("Last_Client_uid",uid)
			CCUserDefault:sharedUserDefault():flush()
		end
		
		if type(tonumber(password)) == "number" then
			--添加使用的UID至缓存
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


--安卓版特有接口 部分可能会重载程序接口
--读取存档版本号
xlPlayer_GetSnapShotID = function(uid)
	local _TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
	
	--非windows版
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		return xlGetIntFromKeyChain("Last_Client_snapshitid_" .. uid)
	--PC版
	else
		return CCUserDefault:sharedUserDefault():getIntegerForKey("Last_Client_snapshitid_" .. uid)
	end
end

--安卓版特有接口 部分可能会重载程序接口
--设置存档版本号
xlPlayer_SetSnapShotID = function(uid, snapshotID)
	local _TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
	
	--非windows版
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		xlSaveIntToKeyChain("Last_Client_snapshitid_" .. uid, snapshotID)
	--PC版
	else
		CCUserDefault:sharedUserDefault():setIntegerForKey("Last_Client_snapshitid_" .. uid, snapshotID)
		CCUserDefault:sharedUserDefault():flush()
	end
end

--从参数字符串中截取相应mode的 keyChain值，并且保存至本地keyChain中 
--mode 类型 IU ( itenUniqueID ) 格式如下"SU:15;IU:12;US:13;"
xlGetKeyChinaVal = function(mode,keyChain)
	local tempStr = {}
	if type(keyChain) == "string" then
		for v in string.gfind(keyChain,"([^%;]+);+") do
			tempStr[string.sub(v,1,2)]= tonumber(string.sub(v,4,string.len(v)))
		end
	end

	return tempStr[mode] or 0
end

--设置keyChain相应的值至本地 keyChain中
xlSetKeyChinaVal = function(mode,keyChain)
	local val = xlGetKeyChinaVal(mode,keyChain)
	--目前只有道具唯一ID 此mode 以后会扩展
	if mode == "IU" then
		--检查装备唯一UID值
		local realVal = hApi.CheckItemUniqueID(val)
		--非windows
		if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
			xlSaveIntToKeyChain("xl_"..tostring(xlPlayer_GetUID()).."_ItemUniqueID",realVal)
		--windows
		else
			CCUserDefault:sharedUserDefault():setIntegerForKey("xl_"..tostring(xlPlayer_GetUID()).."_ItemUniqueID",realVal)
			CCUserDefault:sharedUserDefault():flush()
		end
		--如果数值不同步  则更新数值
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

--获取数据分段的上传状态
xlGetDateSendState = function(mode)
	--非windows
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		return xlGetIntFromKeyChain("xl_"..tostring(xlPlayer_GetUID())..mode)

	--PC版
	else
		return CCUserDefault:sharedUserDefault():getIntegerForKey("xl_"..tostring(xlPlayer_GetUID())..mode)
	end
end

--设置上传状态 --因方法变动 废弃上传时间 
xlSetDateSendState = function(mode,val)
	--非windows
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		xlSaveIntToKeyChain("xl_"..tostring(xlPlayer_GetUID())..mode,val)			--状态
	--windows
	else
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_"..tostring(xlPlayer_GetUID())..mode,val)
		CCUserDefault:sharedUserDefault():flush()
	end
end

--上传存档的时间间隔 暂定 10秒 10000
G_SendDataInterval = 10
xlGetLastSendInterval = function()
	local LastTime = 0
	--安卓
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		LastTime = xlGetIntFromKeyChain("xl_"..tostring(xlPlayer_GetUID()).."_LastSendInterval".."_time")
	--window
	else
		LastTime = CCUserDefault:sharedUserDefault():getIntegerForKey("xl_"..tostring(xlPlayer_GetUID()).."_LastSendInterval".."_time")
	end
	local CurTime = tonumber(os.date("%m%d%H%M%S"))
	--当前时间减上一次上传时间 计算是否大于间隔

	if (CurTime - LastTime) > G_SendDataInterval then
		return 1
	else
		return 0
	end
end

--成功上传后 设置上传的时间
xlSetLastSendInterval = function(Time)
	Time = (Time or tonumber(os.date("%m%d%H%M%S")))
	--安卓
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		xlSaveIntToKeyChain("xl_"..tostring(xlPlayer_GetUID()).."_LastSendInterval".."_time",Time)
	--windows
	else
		CCUserDefault:sharedUserDefault():setIntegerForKey("xl_"..tostring(xlPlayer_GetUID()).."_LastSendInterval".."_time",Time)
		CCUserDefault:sharedUserDefault():flush()
	end
end

--获取登陆UID在本地设备中的存档次数累加器
xlGetUIDSaveCount = function()
	if g_tTargetPlatform.kTargetWindows ~= _TargetPlatform then
		return xlGetIntFromKeyChain("xl_"..tostring(xlPlayer_GetUID()).."_save_count")
	--PC版
	else
		return CCUserDefault:sharedUserDefault():getIntegerForKey("xl_"..tostring(xlPlayer_GetUID()).."_save_count")
	end
end

--当存档发生时，存档计数器自增
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

--设置快照ID(切设备或者其他原因  快照ID混乱)
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

--[定时器方法，已废弃]
--安卓版上传存档的计时器 暂定5秒一次检测，如果发现本地上传数据标记为1，且存在数据 就开启上传 
--hApi.addTimerForever("__AndroidDataUpdateTimer",hVar.TIMER_MODE.GAMETIME,5000,function(tick)
	--if g_curPlayerName == nil then return end

	--GluaSendNetCmd[hVar.ONLINECMD.CMD_SEND_GAME_DATA](xlGetUIDSaveCount())

	--GluaSendNetCmd[hVar.ONLINECMD.CMD_HEART_BEAT]()
--end)

xlRealNameCheckMode = function()
	--数据库配置开关
	if g_OBSwitch and g_OBSwitch.channelavoidRealname == 1 then
		return false
	end
	--内网测试用
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
	--解析数据 如果服务器没有下发数据，或者快照ID是0 则视为新玩家，先产生本地文件
	if type(dataList) ~= "table" or snapshotID == 0 then 
		--本地文件产生过程
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
	--不是新玩家的情况下 分别判断N块数据
	for i = 1,num * 2,2 do
		local key,data = dataList[i],dataList[i+1]
		local f = loadstring(data)
		--异常处理
		if f == nil then
			hGlobal.event:event("LocalEvent_showLuaAndroidtErrorFrm",data,key,1)
			return "ERROR:"..key..";"
		end
		--如果有本地文件
		if hApi.FileExists(g_localfilepath..tostring(uid).."_"..hVar.SAVE_DATA_PATH[hVar.CONST_KEY2PATH[key]],"full") == true then
			--是否更换设备，是否强制刷新，是否快照数据小于服务器， 满足1 则读取服务器数据
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
							--读取背包失败
							rs = rs..":fail;"
							f()
						end
					end
					--只有本地存档新的时候才上传存档
					keyList[#keyList+1] = key
					--hApi.OnSaveData(hVar.CONST_KEY2PATH[key])
				elseif fill_uid == -1 then
					--存档损坏  从服务器读取
					rs = rs..":noUID;"
					f()
					--hApi.OnSaveData(hVar.CONST_KEY2PATH[key])
				else
					--不能使用别人的存档
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
		--没有存档则读取服务器
		else
			rs = rs..key..":0:1;"
			f()
			xlSetUIDSaveCount(snapshotID)
			--hApi.OnSaveData(hVar.CONST_KEY2PATH[key])
		end
	end

	rs = rs .. "shotID:"..snapshotID..":"..cur_savecount..";"

	--统一一次性上传存档
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
			--不锁定5   
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
			--1 = 竖屏		2 = 横屏
			local orientation,mode = xlGetOrientation()
			local lock_flag = 1
			if mode == 5 then
				lock_flag = 0
			end
			return orientation,lock_flag
		end
	end
	
--end

--安卓版定义商店道具的地方
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
