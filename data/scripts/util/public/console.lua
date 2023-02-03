if g_phone_mode ~= 0 then return end
local resetUID = function()
	CCUserDefault:sharedUserDefault():setIntegerForKey("UID",0)
	CCUserDefault:sharedUserDefault():flush()
	xlNet_Disconnect()
end

login = function()
	--已废弃
	--g_netMgr:connectToGameServer("127.0.0.1", 9023)
end

playerlist = function()
  g_netMgr:sendGamePacket(opCodes.C2LY_PLAYER_LIST)
end

challenge = function(playerId)
  g_netMgr:sendGamePacket(opCodes.C2L_REQ_CHALLANGE, playerId, "testMap")
end

--TODO protocol change to accept_challenge
accept = function(playerId)
	g_netMgr:sendGamePacket(opCodes.C2L_BEING_CHALLANGED_RET, playerId)
end

ready = function()
  g_netMgr:sendGamePacket(opCodes.C2L_READY_GAME)
end

complete = function()
  g_netMgr:sendGamePacket(opCodes.C2L_COMPLETE_GAME)
end

restart = function()
  g_netMgr:sendGamePacket(opCodes.C2L_REQ_RESTAR)
end

cmd = function(data)
  g_netMgr:sendGamePacket(opCodes.P2P_GAME_CMD, data)
end

data = function(data)
  g_netMgr:sendGamePacket(opCodes.P2P_GAME_DATA, data)
end

leave = function()
  g_netMgr:sendGamePacket(opCodes.C2L_LEAVE_GAME)
end

logout = function()
  g_netMgr:disconnectGameServer()
end

mycb = function(func, param1, ...)
	print("pvp cmd", func)
	local isOk = false;
	
	if func == "do" and param1 ~= nil then
		local fnLua = _G[param1];
		if fnLua ~= nil then
			fnLua(...)
			isOk = true
		end
	elseif func == "resetUID" then
		resetUID()
		isOk = true
	end
	
	if isOk then
		return func .. " ok"
	else
		return func .. " failed"
	end
end

pvpcb = function(func, ...)
	print("pvp cmd", func)
	
	if hVar.OPTIONS.PVP_ENABLE == 0 then
		return "please enable pvp and try again."
	end
	
	if g_netMgr == nil then
		g_netMgr   = NetManager:new()
	end

	local isOk
	local fn = _G[func];
	if fn ~= nil then
		fn(...)
		isOk = true
	end
	
	if isOk == nil then
		return "error " .. func .. " not found!"
	end
	
	return func .. " ok!"
end


CConsole:sharedConsole():registerListener("script stuff", mycb)
CConsole:sharedConsole():addParam("do", "execute script")
CConsole:sharedConsole():addParam("resetUID", "reset uid")

CConsole:sharedConsole():registerListener("pvp commands", pvpcb)
CConsole:sharedConsole():addParam("login", 			"login to pvp server")
CConsole:sharedConsole():addParam("playerlist", 	"show online player list")
CConsole:sharedConsole():addParam("challenge", 		"request challenge, param: playerId")
CConsole:sharedConsole():addParam("accept",			"whether accept challenge param: 0 or 1")
CConsole:sharedConsole():addParam("ready", 			"ready")
CConsole:sharedConsole():addParam("cmd", 			"send battle cmd param: string")
CConsole:sharedConsole():addParam("data", 			"send data to peer")
CConsole:sharedConsole():addParam("complete", 		"game request complete")
CConsole:sharedConsole():addParam("restart", 		"restart game")
CConsole:sharedConsole():addParam("leave", 			"give up")
CConsole:sharedConsole():addParam("logout", 		"disconnect with pvp server")
