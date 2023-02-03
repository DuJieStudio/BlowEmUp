--*************************************************************
-- Copyright (c) 2016, XinLine Co.,Ltd
-- Author: Red
-- Detail: 游戏服务器相关模块
---------------------------------------------------------------
if (nil == Group_Server) then
	Group_Server = {
		_inst = nil,
		_log = true,
		_encrypt = 0,
		_callback = "Group_Server_On_Net_Msg",
		
	--	_ip = "192.168.1.30", --内网
		_ip = "47.103.51.230", --外网
		
		_port = 8035,
		
		--==网络连接状态==--
		--连接失败		-2
		--未初始化		-1
		--初始化成功		0
		--连接成功		1
		--正在连接		2
		--正在关闭		3
		_state = -1,
		_online = -1, --工会服务器登陆状态
	}
end

if (g_lua_src == 1) then --源代码模式下打开以下开关
	Group_Server._ip = "192.168.1.30" --内网
end

--*************************************************************
-- 接口定义
---------------------------------------------------------------
--输出日志
Group_Server.Log = function(self, msg)
	if true == self._log then
		xlLG("group_server",msg)
	end
end

--网络模块初始化
Group_Server.Init = function(self)
	if nil == self._inst then
		self._inst = xlTcpClient_Create(self._encrypt,self._callback)
		if self._inst then
			self:SetState(0)
		else
			self:SetState(-1)
		end
	end
end

--网络模块释放
Group_Server.Free = function(self)
	--
end

--连接网络
Group_Server.Connect = function(self)
	if (nil == self._inst) then
		--print("Group_Server.Connect", "nil == self._inst")
		return -1 
	end
	
	--如果本地被gameserver踢掉，禁止连接
	if (g_is_gameserver_kockout == 1) then
		return -2
	end
	
	local res = xlTcpClient_Connect(self._inst,self._ip,self._port)
	if (res == 0) then
		--设置连接状态
		self:SetState(2)
	elseif (53 == res) then --网络底层异常
		--hApi.addTimerOnce("__try2reconnect",5000,function()
		--	self:Connect()
		--end)
	elseif (52 == res) then --已经连接，正在连接，正在关闭
		--
	end
	
	--print("Group_Server.Connect", "设置连接状态", res)
	return res
end

--网络模块关闭
Group_Server.Close = function(self)
	--print("Close", self, self._inst)
	if nil == self._inst then
		return false 
	end
	local res = xlTcpClient_Close(self._inst)
	self:SetState(3)
	--print("xlTcpClient_Close", res)
end

--发送数据
Group_Server._Send = function(self, datatable)
	if nil == self._inst then
		return false 
	end
	local datanum = #datatable
	if 0 < datanum then
		--table.insert(datatable, 1, 66666)
		--local res = xlTcpClient_Send(self._inst,datanum + 1,datatable)
		local res = xlTcpClient_Send(self._inst,datanum,datatable)
	end
end

--角色登陆(特殊协议 4000)
Group_Server.UserLogin = function(self)
	--如果本地被gameserver踢掉，禁止登录
	if (g_is_gameserver_kockout == 1) then
		return
	end
	
	local pId = xlPlayer_GetUID()
	local rId = luaGetplayerDataID()
	if pId and rId and pId > 0 and rId > 0 then
		local send = {}
		send[1] = 4000
		send[2] = 0 --protocol or 0
		send[3] = xlPlayer_GetUID()
		send[4] = luaGetplayerDataID()
		send[5] = 0 --itag -- 0
		Group_Server:_Send(send)
	end
end

--角色重新登陆(特殊协议 4000)
Group_Server.UserReLogin = function(self)
	--如果本地被gameserver踢掉，禁止重登
	if (g_is_gameserver_kockout == 1) then
		return
	end
	
	local pId = xlPlayer_GetUID()
	local rId = luaGetplayerDataID()
	if pId and rId and pId > 0 and rId > 0 then
		local send = {}
		send[1] = 4000
		send[2] = 0 --protocol or 0
		send[3] = xlPlayer_GetUID()
		send[4] = luaGetplayerDataID()
		send[5] = 1 --itag -- 0
		Group_Server:_Send(send)
	end
end

--发送Group脚本协议(特殊协议 66666)
Group_Server.Send = function(self, cmd, datatable)
	local datanum = #datatable
	if cmd then
		if cmd < 1000 then
			local sendcmd = {}
			sendcmd[#sendcmd + 1] = 66666
			sendcmd[#sendcmd + 1] = cmd
			sendcmd[#sendcmd + 1] = 0
			sendcmd[#sendcmd + 1] = 0
			local cmdstr = ""
			for i = 1, #datatable, 1 do
				if (i < #datatable) then
					cmdstr = cmdstr..tostring(datatable[i])..";"
				elseif (i == #datatable) then
					cmdstr = cmdstr..tostring(datatable[i])
				end
			end
			
			sendcmd[#sendcmd + 1] = cmdstr
			--print("cmdstr:", cmdstr)
			local res = self:_Send(sendcmd)
		else
			--新手营
			local sendcmd = {}
			sendcmd[#sendcmd + 1] = 66666
			sendcmd[#sendcmd + 1] = cmd
			sendcmd[#sendcmd + 1] = 0
			sendcmd[#sendcmd + 1] = 0
			sendcmd[#sendcmd + 1] = datatable
			local res = self:_Send(sendcmd)
		end
	end
end

--新的发送pvp脚本协议（测试 66666）
Group_Server.SendEx = function(self, cmd, datatable)
	local datanum = #datatable
	
	if cmd then
		if (nil == self._inst) then
			return false 
		end
		
		local cmdstr = ""
		for i = 1, #datatable, 1 do
			if (i < #datatable) then
				cmdstr = cmdstr..tostring(datatable[i])..";"
			elseif (i == #datatable) then
				cmdstr = cmdstr..tostring(datatable[i])
			end
		end
		
		xlTcpClient_Begin(self._inst)
		xlTcpClient_WriteInt(self._inst,66666)
		xlTcpClient_WriteInt(self._inst,cmd)
		xlTcpClient_WriteInt(self._inst,0)
		xlTcpClient_WriteInt(self._inst,0)
		xlTcpClient_WriteBuffer(self._inst,cmdstr,#cmdstr)
		xlTcpClient_End(self._inst)
	end
end

--设置网络模块状态
Group_Server.SetState = function(self, state)
	if state >= -2 and state <= 3 then
		self._state = state
		hGlobal.event:event("LocalEvent_Set_GroupServer_activity_refresh",self._state)
	end
end

--获得工会服务器网络模块状态
Group_Server.GetState = function(self)
	return self._state
end

--获得工会服务器登陆状态
Group_Server.getonline = function(self)
	return self._online
end

--*************************************************************
-- 消息回调
---------------------------------------------------------------
Group_Server_On_Net_Msg = function(datatable)
	local protocol = datatable[1]
	local info = string.format("redredonnetmsg id:%d \n",protocol)
	--Group_Server:Log(info)
	if 99 == protocol then -- 系统消息
		--Group_Server:Log(info)
		local msgid = datatable[2]
		--print("99 protocol state:", msgid)
		if 1 == msgid then -- connected
			Group_Server:SetState(1)
			--发送登陆请求
			--Group_Server:UserLogin()
		elseif 2 == msgid then
			Group_Server:SetState(-2)
			
			--hGlobal.LocalPlayer:setoffline()
			Group_Server._online = -2
			--hGlobal.event:event("LocalEvent_Group_LogEvent", 3) --1in 2out 3dis
			--print("hGlobal.LocalPlayer:setoffline()")
			--local res = Group_Server:Connect()
		elseif 3 == msgid then
			local iProtocol = datatable[3]
			local iReason = datatable[4] -- 0 kickout 1 logout
			local ret = 0
			if iReason > 0 then
				ret = iReason + 1
			end
			
			hGlobal.event:event("LocalEvent_Group_LogEvent",ret) --0 kickout 1in 2out 3dis
			
			--如果被踢掉线则断开连接
			Group_Server:Close()
			
			--hGlobal.LocalPlayer:setoffline()
			Group_Server._online = -3
			
			
			
			--发送登陆请求
			--Group_Server:UserLogin()
			--print("hGlobal.LocalPlayer:setoffline()")
		end
		--print("Group_Server_On_Net_Msg state LocalEvent_Set_activity_refresh:" .. tostring(g_cur_net_state))
		hGlobal.event:event("LocalEvent_Group_NetEvent", Group_Server:GetState())
	elseif 4001 == protocol then
		Group_Server:Log(info)
		--登陆成功回调
		--hGlobal.LocalPlayer:setonline()
		Group_Server._online = 1
		hGlobal.event:event("LocalEvent_Group_LogEvent",1) --1in 2out 3dis
		--print("hGlobal.LocalPlayer:setonline()")
	elseif 66666 == protocol then
		--[[
		Group_Server:Log(info)
		--脚本通道
		for i = 1,#datatable do
			info = string.format("param[%d]: %s \n",i-1,tostring(datatable[i]))
			Group_Server:Log(info)
		end
		]]
		
		--脚本处理收到的命令
		GroupLuaOnNetPack(datatable)
		
	elseif (44444 == protocol) then
		--心跳包
		--Group_Server:Log(info)
		SendGroupCmdFunc["heart"]()
		--print("SendGroupCmdFunc[heart]()")
		
		--[[
		--记录上次收到pvp心跳包的时间
		local world = hGlobal.WORLD.LastWorldMap
		if world then
			if world and world.data.tdMapInfo and (world.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
				if (hGlobal.LocalPlayer:getonline()) then --登入
					local clienttime = os.time()
					local hosttime = clienttime - g_localDeltaTime_pvp --(Local = Host + deltaTime)
					--print("心跳包 Group_Server:GetState()=" .. Group_Server:GetState(), hosttime)
					world.data.heartTime = hosttime --心跳包上次收到的时间
				end
			end
		end
		]]
	end
end

Group_Server:Init()

hGlobal.event:listen("LocalEvent_Group_LogEvent","__test",function(logState)
	 --1in 2out 3dis
	print("LocalEvent_Group_LogEvent:", logState)
end)