--local iChannelId = xlGetChannelId()
--if iChannelId < 100 then
	--return
--end

g_guest_uid = ""
g_guest_pw = ""
g_guest_name = ""
g_guest_head = ""
g_guest_bind = 0
g_lastPid = 0
g_lastPtable = {}
--新登录方式
--g_guest_key = ""

local loadGuestInfo_IOS = function()
	--IOS
	if hApi.FileExists(g_localfilepath.."new_guest.cfg","full") then
		xlLoadGameData(g_localfilepath.."new_guest.cfg")
		hApi.SaveGuestInfo_IOS()
	else
		local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
		if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
			g_guest_uid = xlGetIntFromKeyChain("xl_guest_uid")
			g_guest_pw = xlGetStringFromKeyChain("xl_guest_pw")
			g_guest_name = xlGetStringFromKeyChain("xl_guest_name")
		end
	end
end

hGlobal.event:listen("LocalEvent_getANewGuestRes","getANewGuestRes",function(uid,name,password)
	local str = "g_guest_uid = "..uid.." g_guest_name = ".."\""..name.."\" g_guest_pw = ".."\""..password.."\" g_guest_head = \"def\" g_guest_bind = 0"
	xlSaveGameData(g_localfilepath.."new_guest.cfg",str)
	g_guest_uid = uid
	g_guest_pw = password
	g_guest_name = name
	g_guest_head = "def"
	g_guest_bind = 0
	g_lastPid = hVar.ONLINECMD.NEW_LOGIN
	g_lastPtable = {0,g_guest_uid,g_guest_pw,nil,g_isReconnection}

	hApi.SaveGuestInfo_IOS()

	GluaSendNetCmd[hVar.ONLINECMD.NEW_LOGIN](0,g_guest_uid,g_guest_pw,nil,g_isReconnection)
end)

hGlobal.event:listen("LocalEvent_SaveGuestCfg","savecfg",function()
	if hApi.FileExists(g_localfilepath.."new_guest.cfg","full") then
	
	else
		local uid = xlPlayer_GetUID()
		local str = "g_guest_uid = "..uid.." g_guest_name = ".."\""..g_guest_name.."\" g_guest_pw = ".."\""..g_guest_pw.."\" g_guest_head = \"def\" g_guest_bind = 0"
		xlSaveGameData(g_localfilepath.."new_guest.cfg",str)
	end
end)

hGlobal.event:listen("LocalEvent_autologin","_autologin",function()
	--判断安卓和ios
	local iChannelId = xlGetChannelId()
	if iChannelId < 100 then
		loadGuestInfo_IOS()
	else
		--安卓存文件
		if hApi.FileExists(g_localfilepath.."new_guest.cfg","full") then
			xlLoadGameData(g_localfilepath.."new_guest.cfg")
			--print(g_guest_uid)
			--print(g_guest_pw)
			print("g_guest_name",g_guest_name)
			--print(g_guest_head)
			--print(g_guest_bind)
		end
	end

	hApi.RecordLastLoginType("guest")

	print("LocalEvent_autologin",g_guest_name)
	if g_guest_name == nil or g_guest_name == "" or g_guest_name == 0 then
		print("111111111111111111")
		GluaSendNetCmd[hVar.ONLINECMD.NEW_REGISTER](0," "," "," ")
	else
		print("2222222222222222222",g_guest_uid,g_guest_pw)
		g_lastPid = hVar.ONLINECMD.NEW_LOGIN
		g_lastPtable = {0,g_guest_uid,g_guest_pw,nil,g_isReconnection}
		GluaSendNetCmd[hVar.ONLINECMD.NEW_LOGIN](0,g_guest_uid,g_guest_pw,nil,g_isReconnection)
	end
end)

--------------------------------------------
--------新版登录

local _GetGuestKey = function()
	local key = ""
	local platfrom = ""
	local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
	if g_tTargetPlatform.kTargetWindows == TargetPlatform then
		platfrom = "PC"
	else
		local channelId = xlGetChannelId()
		if channelId < 100 then
			platfrom = "Ios"
		else
			platfrom = "Android"
		end
	end
	local tabNow = os.date("*t", os.time())
	--table_print(tabNow)
	local yearNow = tabNow.year
	local monthNow = tabNow.month
	local dayNow = tabNow.day
	local hourNow = tabNow.hour
	local minNow = tabNow.min
	local secNow = tabNow.sec

	local n1 = math.random(100000,999999)
	--print(os.clock())
	math.randomseed(os.clock())
	local n2 = math.random(1000,9999)
	local n3 = n1 * n2
	math.randomseed(n3)
	--print(n1,n2,n3)

	local randkey = ""
	for i = 1,12 do
		--26 + 26 +10
		local r = math.random(1,62)
		local s = ""
		if r <= 26 then
			--97 a - z
			s = string.char(97 + r - 1)
		elseif r <= 52 then
			--65 A - Z
			s = string.char(65 + r - 26 - 1)
		else
			--48 0 - 9
			s = string.char(48 + r - 52 - 1)
		end
		--print(r,s)
		randkey = randkey .. tostring(s)
	end
	--print("randkey",randkey)
	
	key = string.format("guest%s%4d%02d%02d%02d%02d%02d%s",platfrom,yearNow,monthNow,dayNow,hourNow,minNow,secNow,randkey)
	--print("key",key)
	math.randomseed(os.time())
	return key
end

local _ReadGuestInfo = function()
	print("_ReadGuestInfo")
	local iChannelId = xlGetChannelId()
	local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
	if g_tTargetPlatform.kTargetWindows ~= TargetPlatform then
		--非PC平台 且为ios平台读取keychain
		if iChannelId < 100 then
			g_guest_key = xlGetStringFromKeyChain("xl_guest_key")
			return
		end
	end
	if hApi.FileExists(g_localfilepath.."new_guest55.cfg","full") then
		print("aaaaaaaaaaaaaaaa")
		xlLoadGameData(g_localfilepath.."new_guest55.cfg")
	end
	print("g_guest_key",g_guest_key)
end

local _DoNewGuestLogin = function()
	if g_guest_key == "" or g_guest_key == nil or g_guest_key == 0 then
		g_guest_key = _GetGuestKey()
		
	end
	print("g_guest_key",g_guest_key)
	hGlobal.event:event("LocalEvent_getAnswerFromOtherPlantform","guest","uid",g_guest_key)
end

hGlobal.event:listen("LocalEvent_InitNewGuestLoginInfo","NewGuestLogin",function()
	_ReadGuestInfo()
end)

hGlobal.event:listen("LocalEvent_SaveNewGuestCfg","NewGuestLogin",function()
	if g_guest_key == nil then
		return
	end
	local iChannelId = xlGetChannelId()
	if iChannelId < 100 then
		xlSaveStringToKeyChain("xl_guest_key",g_guest_key)
	else
		print(g_guest_key,g_guest_uid)
		local uid = xlPlayer_GetUID()
		local str = "g_guest_key = \""..g_guest_key.."\""
		print("LocalEvent_SaveNewGuestCfg",str)
		xlSaveGameData(g_localfilepath.."new_guest55.cfg",str)
	end
end)

hGlobal.event:listen("LocalEvent_NewGuestLoginError","NewGuestLogin",function(errorcode)
	g_guest_key = ""
	local strText = hVar.tab_string["try_again_later"].."/n"..hVar.tab_string["request_errcode"]..errorcode
	hGlobal.UI.MsgBox(strText, {
		font = hVar.FONTC,
		ok = function()
			--self:setstate(1)
		end,
	})
end)

hGlobal.event:listen("LocalEvent_NewGuestLogin","NewGuestLoginInfo",function()
	_DoNewGuestLogin()
end)