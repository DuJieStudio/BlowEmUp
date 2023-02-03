--------------------------------------------
--网络管理器
--------------------------------------------
MakePacket = function(opCode)
	local packet = CCWritePacket:create()
	packet:writeInt(opCode)
	return packet
end


g_NetManager = {}
g_NetManager.data = {ip=0,port=0,roldid=0}
g_NetManager.handle = {}
local _hn = g_NetManager

_hn.init = function(self)
	local d = self.data
	if d.InitFlag==1 then
		return
	end
	d.InitFlag = 1
	local __CODE__NetCall = function(pConnection)
		if pConnection:getConnType()~=hVar.NET_CONNECTION_TYPE.CT_GAME then
			return
		end
		local scriptPacketHandler = function(pPacket)
			local nOpType = pPacket:readUInt()
			if nOpType~=nil and type(GameSession.recCmdHandlers[nOpType])=="function" then
				if hVar.OPTIONS.PVP_CMD_LOG==1 then
					xlLG("pvp_cmd","r:"..tostring(nOpType).."\n")
				end
				return GameSession.recCmdHandlers[nOpType](self,pPacket)
			else
				return self:onPacket(nOpType,pPacket)
			end
		end
		local scriptEventHandler = function(nEventId,vParam)
			return self:onEvent(nEventId,vParam)
		end
		pConnection:registerScriptPacketHandler(scriptPacketHandler)
		pConnection:registerScriptEventHandler(scriptEventHandler)
		print("[NET]连接成功:"..self.data.ip..":"..self.data.port)
	end
	CNetSystem:sharedNetSystem():registerScriptSessionHandler(__CODE__NetCall)
end

_hn.connectToGameServer = function(self, ip, port,roleid)
	if hVar.PVP_CONSOLE_SWITCH==1 then
		local line = "connectToGameServer:"..ip.." port:"..port
		CConsole:sharedConsole():writeLine(line)
	end
	if not(type(ip)=="string" and type(port)=="number") then
		
		return
	end
	local d = self.data
	local h = self.handle
	d.ip = ip
	d.port = port
	d.roleid = roleid
	self:init()
	self:disconnectFromGameServer()

	local pGameConnection = CConnection:new()
	h._GameConnection = pGameConnection
	pGameConnection:setConnType(hVar.NET_CONNECTION_TYPE.CT_GAME)
	pGameConnection:connect(ip, port)
end
_hn.disconnectFromGameServer = function(self)
	local h = self.handle
	if h._GameConnection~=nil then
		--self:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_OFFLINE)
		h._GameConnection:disconnect()
		h._GameConnection = nil
	end
end
_hn.isConnected = function(self)
	local h = self.handle
	if h._GameConnection~=nil then
		return hVar.RESULT_SUCESS
	else
		return hVar.RESULT_FAIL
	end
end
_hn.onEvent = function(self,nEventId,vParam)
	if nEventId==1 then
		if vParam==1 then
			print("[NET]连接成功")
			self:sendGamePacket(hVar.PVP_OPERATE_TYPE.CMSG_AUTH)
		else
			print("[NET]连接失败",vParam)
		end
	elseif nEventId==2 then
		print("[NET]结束连接")
		self.handle._GameConnection = nil
		hGlobal.event:event("LocalEvent_PVPLoginState",0)
	else
		print("[NET]接收到未知event参数",nEventId,vParam)
	end
end
_hn.onPacket = function(self,nOpType,pPacket)
	print("[NET]接收到未知数据包",nOpType)
end
_hn.sendGamePacket = function(self,nOpType,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)
	local h = self.handle
	if h._GameConnection~=nil then
		if not(type(nOpType)=="number" and math.floor(nOpType)==nOpType) then
			print("[g_NetManager]发送非法的命令！",nOpType)
			return
		end
		local pPacket = CCWritePacket:create()
		if pPacket~=nil then
			if hVar.OPTIONS.PVP_CMD_LOG==1 then
				xlLG("pvp_cmd","s:"..tostring(nOpType).."\n")
			end
			pPacket:writeUInt(nOpType)
			if type(GameSession.sendCmdHandlers[nOpType])=="function" then
				h._packet = pPacket
				GameSession.sendCmdHandlers[nOpType](self,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)	--将需要的命令信息写入到数据包中
				h._packet = nil
			elseif GameSession.sendCmdHandlers[nOpType]==nil then
				--print("[g_NetManager]发送未定义sender的命令！",nOpType)
			end
			h._GameConnection:sendPacket(pPacket)
		end
	end
end