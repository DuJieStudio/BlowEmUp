--*************************************************************
-- Copyright (c) 2016, XinLine Co.,Ltd
-- Author: Red
-- Detail: 游戏服务器相关模块
---------------------------------------------------------------
--local iChannelId = xlGetChannelId()
--if iChannelId < 100 then
	--return
--end


if nil == Game_Server then
	Game_Server = {}
	Game_Server.Data = {}
end

local gs = Game_Server
local gsd = gs.Data
gsd.log = true
gsd.encrypt = 0
gsd.callback = "Game_Server_On_Net_Msg"

gsd.ip = g_game_Ip

if g_lua_src == 1 then
	gsd.ip = g_lrc_Ip
end
--gsd.ip = "192.168.1.29"
gsd.port = IAPServerPort

--在gameup.ss里面已获取服务器下发的服务器ip
if (g_gameserver_host ~= nil) then
	gsd.ip = g_gameserver_host
end

--自动连接
g_antologin = 0
--读取服务器存档
g_loadServerSaveData = 0


gs.funcbak={}
--*************************************************************
-- 接口定义
---------------------------------------------------------------
gs.Log			=					function(msg)
	if true == gsd.log then
		xlLG("game_server",msg)
	end
end

gs.Init = function()
	if nil == gsd.inst then
		gsd.inst = xlTcpClient_Create(gsd.encrypt,gsd.callback)
	end

	--重载CCWritePacket
	local __CODE__PacketPushVal = function(self,v)
		if v==nil then
			v = 0
		end
		rawset(self,#self+1,v)
	end
	local __PACKET__META = {
		__index = function(self,t,k)
			return __CODE__PacketPushVal
		end,
	}

	Game_Server.funcbak.CCWritePacket = CCWritePacket
	CCWritePacket = {
		create = function()
			local t = {}
			setmetatable(t,__PACKET__META)
			return t
		end,
	}

	Game_Server.funcbak.xlNet_SendPacket = xlNet_SendPacket
	xlNet_SendPacket = function(t)
		for i = 1,#t do
			info = string.format("param[%d]: %s \n",i,tostring(t[i]))
		end
		return Game_Server.Send(t)
	end

	local __CODE__PacketPopVal = function(self,v)
		self[0] = self[0] + 1
		return rawget(self,self[0],v)
	end

	local __PACKET__RecvMeta = {
		__index = function(self,t,k)
			return __CODE__PacketPopVal
		end,
	}

	xlNet_RecvPacket = function(t,n)
		t[0] = n-1
		setmetatable(t,__PACKET__RecvMeta)
		return xlOnNetPacket(t)
	end
end

gs.Free = function()
end

gs.Connect = function()
	if nil == gsd.inst then
		return false 
	end
	local res = xlTcpClient_Connect(gsd.inst,gsd.ip,gsd.port)
	if 53 == res then
		hApi.addTimerOnce("__try2reconnect",5000,function()
			gs.Connect()
		end)
	end
	return res
end

gs.Close = function()
	if nil == gsd.inst then
		return false 
	end
	local res = xlTcpClient_Close(gsd.inst)
end

gs.Send = function(datatable)
	if nil == gsd.inst then
		return false 
	end
	local datanum = #datatable
	if 0 < datanum then
		local res = xlTcpClient_Send(gsd.inst,datanum,datatable)
	end
end
--*************************************************************
-- 消息回调
---------------------------------------------------------------
Game_Server_On_Net_Msg = function(datatable)
	--print("=================================================")
	--print("Game_Server_On_Net_Msg")
	local protocol = datatable[1]
	local info = string.format("onnetmsg id:%d \n",protocol)
	--gs.Log(info)
	
	--table_print(datatable)
	if 99 == protocol then -- 系统消息
		local msgid = datatable[2]
		if 1 == msgid then -- connected
			g_cur_net_state = 1
			
			if g_antologin == 1 then
				--hGlobal.event:event("LocalEvent_autologin")
				hGlobal.event:event("LocalEvent_CheckShouldReLogin")
			end
			
			--geyachao: 检测是否需要游戏内重连
			if (g_cur_net_state == 1) then --连接状态
				if (g_cur_login_state ~= 1) then --不是登陆状态
					if (g_isReconnection == 1) then --重连状态
						local t_type,uid,pass,itag,reconnection = unpack(g_lastPtable)
						--print(g_lastPid,t_type,uid,pass,itag,reconnection)
						GluaSendNetCmd[hVar.ONLINECMD.NEW_RE_LOGIN](t_type,uid,pass,itag,g_isReconnection) --游戏内重连
					end
				end
			end
		elseif 2 == msgid then
			--首次断开时触发
			g_cur_net_state = -1
			g_cur_login_state = -1 --标记不是登陆状态
			local res = Game_Server.Connect()
			hGlobal.event:event("LocalEvent_showAndroidNetAlreadyFrm",1)
		elseif 3 == msgid then
			local iProtocol = datatable[3]
			local iReason = datatable[4] -- 0 kickout 1 logout
			--关闭自动登录
			g_antologin = 0
			LuaOnNetPack_android({3998,iProtocol,iReason})
		end
		--print("Game_Server_On_Net_Msg state LocalEvent_Set_activity_refresh:" .. tostring(g_cur_net_state))
		hGlobal.event:event("LocalEvent_Set_activity_refresh",g_cur_net_state)
	else
		for i = 1,#datatable do
			info = string.format("param[%d]: %s \n",i-1,tostring(datatable[i]))
			--gs.Log(info)
		end
		--脚本处理收到的命令
		if datatable[1] >= 3000 and datatable[1] <= 5000 then
			LuaOnNetPack_android(datatable)
		elseif datatable[1] == 66666 then --安卓
			DBLuaOnNetPack(datatable)
		else
			xlNet_RecvPacket(datatable,1)
		end
	end

	--print("Game_Server_On_Net_Msg LocalEvent_SetCurAccountState state:" .. tostring(g_cur_net_state))
	hGlobal.event:event("LocalEvent_SetCurAccountState")
end

Game_Server.Init()
