--信息发送模板:连接服务器的密码校验
local senders = GameSession.sendCmdHandlers
local handlers = GameSession.recCmdHandlers
----------------------------------------------------------
-- senders
----------------------------------------------------------
senders[hVar.PVP_OPERATE_TYPE.CMSG_AUTH] = function(self)
	local packet = self.handle._packet
	packet:writeByte(4)
	packet:writeUInt(12345)
	packet:writeByte(0)
	packet:writeInt(self.data.roleid) --传roleid
end

senders[hVar.PVP_OPERATE_TYPE.C2LY_PLAYER_LIST] = function(self, channel)
	local packet = self.handle._packet
	packet:writeUInt(0)
end

senders[hVar.PVP_OPERATE_TYPE.C2L_REQ_CHALLANGE] = function(self, playerId, mapName)
	local packet = self.handle._packet
	packet:writeByte(hVar.PVP_FIGHT_MODE.PVP)
	packet:writeInt(tonumber(playerId))
	packet:writeString(mapName or "")
end


senders[hVar.PVP_OPERATE_TYPE.C2L_BEING_CHALLANGED_RET] = function(self)
	local packet = self.handle._packet
	packet:writeInt(0)  -- challenge id, not used currently
	packet:writeByte(1) -- whether accept challenge
end

senders[hVar.PVP_OPERATE_TYPE.P2P_GAME_CMD] = function(self, cmd)
	local packet = self.handle._packet
	local sCmd = cmd
	if type(sCmd)~="string" then
		sCmd = " "
	end
	packet:writeString(sCmd)
	if hVar.OPTIONS.PVP_CMD_LOG==1 then
		xlLG("pvp_cmd"," s - "..tostring(sCmd).."\n")
	end
end

senders[hVar.PVP_OPERATE_TYPE.P2P_GAME_DATA] = function(self, cmd , Battlefield_BG_id)
	local packet = self.handle._packet
	packet:writeString(cmd or "")
	packet:writeInt(Battlefield_BG_id or 1)
end

senders[hVar.PVP_OPERATE_TYPE.C2L_GAME_RESULT] = function(self, isVictory,data_s)
	local packet = self.handle._packet
	packet:writeUInt(isVictory)
	packet:writeString(data_s or "")
	
end


--hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE_ROLE_INFO
senders[hVar.NET_ROLE_INFO_TYPE.MSG_ID_C2L_ROLEINFO_QUERY] = function(self,role_id,mode,strTag)
	local packet = self.handle._packet
	packet:writeUInt(mode or 0)
	packet:writeString(tostring(strTag) or "")
	packet:writeString("t_pvp")
	packet:writeString("power,pvp_coin,pvp_sum,pvp_win,pvp_fail,pvp_giveup,unit_hot,pvp_exp,id,pvp_name")
	packet:writeUInt(1)
	packet:writeString("id")
	packet:writeUInt(role_id)

end

--玩家做好准备后的状态发送接口
senders[hVar.PVP_OPERATE_TYPE.C2L_PLAYER_STATE] = function(self, cmd)
	local packet = self.handle._packet
	packet:writeUInt(cmd)
end

senders[hVar.PVP_OPERATE_TYPE.C2L_PLAYER_PARAM] = function(self,cmd)
	local packet = self.handle._packet
	if type(cmd)=="string" and string.len(cmd)<128 then
		packet:writeString(cmd)
	else
		print("[NET ERROR]C2L_PLAYER_PARAM  参数错误，请检查",cmd)
		packet:writeString("")
	end
end

senders[hVar.PVP_OPERATE_TYPE.C2L_PLAYER_NET_SAVE_UPDATE] = function(self,id,unique,cmd)
	local packet = self.handle._packet
	packet:writeUInt(id)
	packet:writeUInt(xlPlayer_GetUID())
	packet:writeString(cmd)
end

senders[hVar.PVP_OPERATE_TYPE.C2L_PLAYER_SWITCH_ROOM] = function(self,nRoomID)
	local packet = self.handle._packet
	packet:writeUInt(nRoomID)
end

senders[hVar.PVP_DB_OPR_TYPE.C2L_UPDATE] = function(self, nOpr, sCmd)	--hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE
	local packet = self.handle._packet
	if type(sCmd)~="string" then
		sCmd = "0"
	end
	if hVar.OPTIONS.PVP_CMD_LOG==1 then
		xlLG("pvp_cmd"," rq - "..tostring(nOpr).."\n")
	end
	packet:writeInt(nOpr)
	if nOpr==hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE_REPLAY then
		if sCmd=="my:" then
			local tCmd = {"my:"}
			local tReplayList = g_PVP_NetSaveData.L2CReplay
			if #tReplayList>0 then
				for i = 1,#tReplayList do
					local v = tReplayList[i]
					local nReplayId = v[1]
					local sReplay = v[2]
					tCmd[#tCmd+1] = tostring(nReplayId)..","
				end
			end
			sCmd = table.concat(tCmd)
		end
	end
	packet:writeString(sCmd)
end

senders[hVar.PVP_OPERATE_TYPE.C2L_LOG] = function(self,nType,sCmd)
	local packet = self.handle._packet
	if type(sCmd)~="string" then
		sCmd = "0"
	end
	packet:writeInt(nType)
	packet:writeString(sCmd)
end


--senders[hVar.PVP_OPERATE_TYPE.C2L_READY_GAME] = function(self)
--end

--senders[hVar.PVP_OPERATE_TYPE.C2L_REQ_RESTAR] = function(self)
--end

--senders[hVar.PVP_OPERATE_TYPE.C2L_LEAVE_GAME] = function(self, cmd)
--end

--senders[hVar.PVP_OPERATE_TYPE.C2L_COMPLETE_GAME] = function(self)
--end

----------------------------------------------------------
-- handlers
----------------------------------------------------------

--自定义脚本接口
handlers[hVar.PVP_DB_RECV_TYPE.L2C_RECV] = function(self, packet)
	local nRecvID = packet:readUInt()
	if hVar.OPTIONS.PVP_CMD_LOG==1 then
		xlLG("pvp_cmd"," rv - "..tostring(nRecvID).."\n")
	end
	--print("L2C_RECV",nRecvID,"---------------")
	if nRecvID==hVar.PVP_DB_RECV_TYPE.L2C_MSG then
		--公告弹窗
		local sCmd = tostring(packet:readString())
		local sTip
		if string.sub(sCmd,1,1)=="$" and string.len(sCmd)>1 then
			sTip = hVar.tab_string[string.sub(sCmd,2,string.len(sCmd))]
		else
			sTip = sCmd
		end
		hGlobal.UI.MsgBox(sTip)
	elseif nRecvID == hVar.PVP_DB_RECV_TYPE.L2C_RANK_DATA then
		--刷新天梯数据
		local rank_pama = packet:readString()
		local self_pama = packet:readString()

		if self_pama == nil or self_pama == "" then return end
		local rank_data = {}
		local i,j = 0,1
		for str in string.gfind(rank_pama,"([^%;]+);+") do
			i = i + 1
			j = 1
			rank_data[i] = {}
			rank_data[i][j] = i
			for str_ditile in string.gfind(str..":","([^%:]+):+") do
				j = j + 1
				rank_data[i][j] = str_ditile
			end
		end
		
		local self_data = {}
		for str in string.gfind(self_pama,"([^%;]+);+") do
			for str_ditile in string.gfind(str..":","([^%:]+):+") do
				if #self_data == 0 and string.find(str_ditile,"%[") then
					--截取排名
					self_data[#self_data+1] = string.sub(str_ditile,string.find(str_ditile,'%[')+1,string.find(str_ditile,'%]')-1)
					self_data[#self_data+1] = string.sub(str_ditile,string.find(str_ditile,'%]')+1,string.len(str_ditile))
				else
					self_data[#self_data+1] = str_ditile
				end
			end
		end

		return hGlobal.event:event("LocalEvent_PVPNetRankUpdata",rank_data,self_data)
	elseif nRecvID == hVar.PVP_DB_RECV_TYPE.L2C_ROLE_INFO then
		--查询角色信息
		local power = packet:readUInt()
		local pvp_coin = packet:readUInt()
		local pvp_sum = packet:readUInt()
		local pvp_win = packet:readUInt()
		local pvp_fail = packet:readUInt()
		local pvp_giveup = packet:readUInt()
		local unit_hot = packet:readString()
		local pvp_exp = packet:readUInt()
		local role_id = packet:readUInt()
		local pvp_name = packet:readString()
		local pvp_rank = packet:readUInt()	--非数据库数据
		local nHeroID = packet:readUInt()	--英雄头像ID

		local playerInfo = {
			heroID = nHeroID,
			power = power,
			pvp_coin = pvp_coin,
			pvp_sun = pvp_sum,
			pvp_win = pvp_win,
			pvp_fail = pvp_fail,
			pvp_giveup = pvp_giveup,
			unit_hot = unit_hot or "",
			pvp_exp = pvp_exp,
			role_id = role_id,
			pvp_name = pvp_name,
			pvp_rank = pvp_rank,
		}
		hGlobal.event:event("LocalEvent_ShowNetBattlefieldPlayerInfoFrm",1,playerInfo)
	elseif nRecvID ==  hVar.PVP_DB_RECV_TYPE.L2C_BF_RESULT then
		--服务器下发战斗结算分数
		local cmdStr = packet:readString()
		hGlobal.event:event("LocalEvent_RecvNetBattlefieldResult",cmdStr)
	elseif nRecvID == hVar.PVP_DB_RECV_TYPE.L2C_QUEST then
		--服务器刷新竞技场任务
		local sCmd = packet:readString()
		hApi.ReadPVPQuestByCmd(sCmd)
		hGlobal.event:event("LocalEvent_PVPQuestUpdate")
	elseif nRecvID == hVar.PVP_DB_RECV_TYPE.L2C_QUEST_REWARD then
		--服务器下发竞技场奖励
		local sCmd = packet:readString()
		local nQuestIndex = hApi.GetNumByPatten(sCmd,"idx:(%d+);")
		local nQuestID = hApi.GetNumByPatten(sCmd,"qst:(%d+);")
		if nQuestIndex~=0 then
			g_NetManager:sendGamePacket(hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE, hVar.PVP_DB_OPR_TYPE.C2L_CONFIRM_QUEST,"qst:"..nQuestIndex..";")
		end
		if nQuestID~=0 then
			hGlobal.event:event("NetEvent_L2CReward",nQuestID,hVar.tab_string["__GetReward__"],"",sCmd)
		end
	elseif nRecvID==hVar.PVP_DB_RECV_TYPE.L2C_REPLAY then
		--服务器下发录像数据
		local sReplay = packet:readString()
		local nReplayID = packet:readInt()
		local tReplayList = g_PVP_NetSaveData.L2CReplay
		if sReplay=="0" then
			--请求replay失败
		else
			--合法录像
			if tReplayList.index[nReplayID]==nil then
				local idx = #tReplayList+1
				tReplayList.index[nReplayID] = idx
				tReplayList[idx] = {nReplayID,sReplay}
			end
			tReplayList.id = nReplayID
		end
		hGlobal.event:event("NetEvent_L2CReplay",sReplay,nReplayID)
	elseif nRecvID==hVar.PVP_DB_RECV_TYPE.L2C_NPC then
		--服务器下发npc数据
		local sReplay = packet:readString()
		local nReplayID = packet:readInt()
		local tReplayList = g_PVP_NetSaveData.L2CNpc
		if tReplayList.index[nReplayID]==nil then
			local idx = #tReplayList+1
			tReplayList.index[nReplayID] = idx
			tReplayList[idx] = {nReplayID,sReplay}
		end
		hGlobal.event:event("NetEvent_L2CNpc",sReplay,nReplayID)
	elseif nRecvID==hVar.PVP_DB_RECV_TYPE.L2C_SWITCH then
		--服务器下发pvp开关数据
		local sCmd = packet:readString()
		if string.sub(sCmd,1,1)=="@" then
			hApi.PVPSwitchReset()
		end
		hApi.PVPSwitchUpdate(sCmd)
		hGlobal.event:event("LocalEvent_PVPEnable",1)
	elseif nRecvID==hVar.PVP_DB_RECV_TYPE.L2C_REQUIRE_CMD_LOG then
		--服务器要求上报客户端本地log
		local nGameId = packet:readInt()
		hApi.PVPSendCmdLog(nGameId)
	elseif nRecvID==hVar.PVP_DB_RECV_TYPE.L2C_STRART_PVE_GAME then
		--服务器消息:启动PVE游戏
		local nGameId = packet:readInt()
		local nMsgId = packet:readInt()
		local nReplayId = packet:readInt()
		if hUI.NetDisable(0,nil,nMsgId)==1 then
			local sReplay = hApi.PVPGetReplayById(hVar.PVP_PLAYER_STATE.NPC,nReplayId)
			if sReplay~=nil then
				if hApi.StartDuelByReplay(sReplay,nGameId,nil,0)==hVar.RESULT_SUCESS then
					hApi.PVPSwitchMyState("notready")
					hGlobal.event:event("LocalEvent_ShowPVPFrm",0)
				end
			end
		end
	elseif nRecvID==hVar.PVP_DB_RECV_TYPE.L2C_STRART_RANK_KING then
		--服务器消息:启动游戏
		local nGameId = packet:readInt()
		local nMsgId = packet:readInt()
		local nReplayId = packet:readInt()
		if hUI.NetDisable(0,nil,nMsgId)==1 then
			local sReplay = hApi.PVPGetReplayById(hVar.PVP_PLAYER_STATE.RANK_KING,nReplayId)
			if sReplay~=nil then
				if hApi.StartDuelByReplay(sReplay,nGameId,nil,1)==hVar.RESULT_SUCESS then
					hApi.PVPSwitchMyState("notready")
					hGlobal.event:event("LocalEvent_ShowPVPFrm",0)
				end
			end
		end
	elseif nRecvID==hVar.PVP_DB_RECV_TYPE.L2C_RANK_KING then
		--服务器下发季赛冠军数据
		local sReplay = packet:readString()
		local nReplayID = packet:readInt()
		local opindex = packet:readInt()
		local Pvprank = packet:readInt()					--此玩家排名
		local tRankKing = g_PVP_NetSaveData.RankKing
		if tRankKing.index[nReplayID]==nil then
			local idx = #tRankKing+1
			tRankKing.index[nReplayID] = idx
			tRankKing[idx] = {nReplayID,sReplay,opindex,Pvprank}
		end
	end
end

handlers[hVar.PVP_OPERATE_TYPE.L2C_PLAYER_ID] = function(self, packet)
	local nPlayerId = packet:readUInt()
	local sCmd = packet:readString()
	if type(sCmd)=="string" then
		local PVPEnable = 1
		if string.find(sCmd,"!")==1 then
			PVPEnable = 0
		end
		--判断版本号是否一致
		local tVer = hApi.GetParamByCmd("ver:",sCmd)
		if tVer and #tVer>=1 then
			local sVer = tostring(tVer[1][1])
			local sVerCur = tostring(hVar.PVP_VERSION)
			if sVer~=sVerCur then
				if g_lua_src~=1 then
					PVPEnable = 0
				end
				sCmd = sCmd.."act:VERSION:0:"..sVer..":"..sVerCur..";"
			end
		end
		g_PVP_NetSaveData.PVPEnable = PVPEnable
		g_PVP_NetSaveData.activity = sCmd
		g_PVP_NetSaveData.PVPRewardDataI = ""
		g_PVP_NetSaveData.PVPRewardDataII = ""
		--奖励--EFF
		local tRewardI = hApi.GetParamByCmdII("rw1:",sCmd)
		if tRewardI and #tRewardI>=1 then
			g_PVP_NetSaveData.PVPRewardDataI = table.concat(tRewardI)
		end
		local tRewardII = hApi.GetParamByCmdII("rw2:",sCmd)
		if tRewardII and #tRewardII>=1 then
			g_PVP_NetSaveData.PVPRewardDataII = table.concat(tRewardII)
		end
		--服务器开关
		hApi.PVPSwitchReset()
		hApi.PVPSwitchUpdate(sCmd)
		--pvp中禁止使用的英雄
		local tHeroId = hApi.GetParamByCmd("ban:",sCmd)
		if tHeroId and #tHeroId>=1 then
			for i = 1,#tHeroId do
				local v = tHeroId[i]
				for j = 1,#v do
					g_PVP_NetSaveData.PVPBannedHero[tonumber(v[j])] = 1
				end
			end
		end
		--作弊的道具版本号
		local tCheatVer = hApi.GetParamByCmd("ct:",sCmd)
		if tCheatVer and #tCheatVer>=1 then
			for i = 1,#tCheatVer do
				local v = tCheatVer[i]
				if #v==2 then
					g_PVP_NetSaveData.CheatItemVersion[tostring(v[1])] = tonumber(v[2])
				end
			end
		end
		--服务器任务
		hApi.ReadPVPQuestByCmd(sCmd)
		--pvp配置
		hApi.ResetPVPSet()
		local tPVPSet = hApi.GetParamByCmd("set:",sCmd)
		if tPVPSet and #tPVPSet>=1 then
			for i = 1,#tPVPSet do
				local v = tPVPSet[i]
				local id = tonumber(v[1])
				local nIndex = tonumber(v[2])
				local sIcon = tostring(v[3])
				if sIcon=="0" then
					sIcon = nil
				end
				if hVar.tab_pvpset[id]==nil then
					hVar.tab_pvpset[id] = {}
				end
				local tSet = {
					id = id,
					icon = sIcon,
					equipment = {},
				}
				for j = 4,#v do
					tSet.equipment[#tSet.equipment+1] = hApi.ReadPVPSetItemByCmd(v[j])
				end
				if type(nIndex)=="number" and nIndex>=1 and nIndex<=#hVar.tab_pvpset[id] then
					hVar.tab_pvpset[id][nIndex] = tSet
				else
					hVar.tab_pvpset[id][#hVar.tab_pvpset[id]+1] = tSet
				end
			end
		end
		if PVPEnable==1 then
			hGlobal.event:event("LocalEvent_ShowPVPActivityFrm",sCmd)
			hGlobal.event:event("LocalEvent_PVPEnable",1)
		else
			hGlobal.event:event("LocalEvent_ShowPVPActivityFrm",sCmd)
			hGlobal.event:event("LocalEvent_PVPEnable",0)
		end
	else
		g_PVP_NetSaveData.activity = ""
	end
	hGlobal.NET_DATA.LocalPlayerId = nPlayerId
	--print("发送请求角色数据")
	--self:sendGamePacket(hVar.NET_ROLE_INFO_TYPE.MSG_ID_C2L_ROLEINFO_QUERY)
	return hGlobal.event:event("LocalEvent_PVPLoginState",1)
end

handlers[hVar.PVP_OPERATE_TYPE.LY2C_PLAYER_LIST] = function(self, packet)
	local count = packet:readUShort()
	local tList = {}
	hGlobal.NET_DATA.ROOM_PLAYER_LIST = tList
	for i = 1, count do
		local tPlayer = hApi.NumTable(hVar.PVP_PLAYER_DATA.EXTRA)
		tPlayer[hVar.PVP_PLAYER_DATA.ID] = packet:readUInt()
		tPlayer[hVar.PVP_PLAYER_DATA.ROLE_ID] = packet:readUInt()
		tPlayer[hVar.PVP_PLAYER_DATA.NAME] = packet:readString()
		tPlayer[hVar.PVP_PLAYER_DATA.ELO] = packet:readUInt()
		tPlayer[hVar.PVP_PLAYER_DATA.PARAM] = packet:readString()
		tPlayer[hVar.PVP_PLAYER_DATA.STATE] = packet:readUInt()
		tPlayer[hVar.PVP_PLAYER_DATA.HOST] = packet:readUInt()
		tPlayer[hVar.PVP_PLAYER_DATA.GUEST] = packet:readUInt()
		tPlayer[hVar.PVP_PLAYER_DATA.CHANLLENGE] = packet:readInt()
		tPlayer[hVar.PVP_PLAYER_DATA.TIME] = packet:readUInt()
		tPlayer[hVar.PVP_PLAYER_DATA.LIMIT] = packet:readUInt()
		tList[#tList+1] = tPlayer
	end
	return hGlobal.event:event("LocalEvent_PVPRoomPlayerListUpdate",tList)
end

handlers[hVar.PVP_OPERATE_TYPE.L2C_BEING_CHALLANGED] = function(self, packet)
	local iChallenge = packet:readUInt()
	local iPlayerID  = packet:readUInt()
	return hGlobal.event:event("LocalEvent_PVPChallangeRequire",iChallenge,iPlayerID)
end

handlers[hVar.PVP_OPERATE_TYPE.L2C_REQ_CHALLANGE_RET] = function(self, packet)
	local nResult = packet:readInt()


	if nResult==hVar.PVP_CHANLLENGE_ERRCODE.OK then
		--挑战成功
		print("[server] Req challenge sucess!")
	else
		for k,v in pairs(hVar.PVP_CHANLLENGE_ERRCODE)do
			if nResult==v then
				print("[server] Req challenge fail:"..k.." - "..v)
			end
		end
	end
end

--返回角色信息
handlers[hVar.NET_ROLE_INFO_TYPE.MSG_ID_L2C_ROLEINFO_QUERY_RET] = function(self, packet)
	print("收到角色数据")
	
	local result = packet:readInt()
	if result == 0 then
		local tag = packet:readUInt()
		local strTag = packet:readString()
		local power = packet:readUInt()
		local pvp_coin = packet:readUInt()
		local pvp_sum = packet:readUInt()
		local pvp_win = packet:readUInt()
		local pvp_fail = packet:readUInt()
		local pvp_giveup = packet:readUInt()
		local unit_hot = packet:readString()
		local pvp_exp = packet:readUInt()
		local role_id = packet:readUInt()
		local pvp_name = packet:readString()

		--如果 tag 为1 则视为 查询玩家信息，打开UI 面板
		if tag == 1 then
			local playerInfo = {
				heroID = tonumber(strTag),
				power = power,
				pvp_coin = pvp_coin,
				pvp_sun = pvp_sum,
				pvp_win = pvp_win,
				pvp_fail = pvp_fail,
				pvp_giveup = pvp_giveup,
				unit_hot = unit_hot,
				pvp_exp = pvp_exp,
				role_id = role_id,
				pvp_name = pvp_name,
			}
			hGlobal.event:event("LocalEvent_ShowNetBattlefieldPlayerInfoFrm",1,playerInfo)
		else

		end
	else
		print("角色数据接收失败...")
	end
end

--更新角色信息
handlers[hVar.NET_ROLE_INFO_TYPE.MSG_ID_L2C_ROLEINFO_UPDATE_RET] = function(self, packet)
	print("更新角色数据")
	print(2)
end

handlers[hVar.PVP_OPERATE_TYPE.P2P_GAME_DATA] = function(self, packet)
	local nPlayerId = packet:readUInt()
	local sCmd = packet:readString()
	local nMapID = packet:readInt()
	local oWorld = hGlobal.NetBattlefield
	
	if sCmd==nil then
		return
	end
	if oWorld~=nil then
		return
	end
	if string.sub(sCmd,1,1)~="@" then
		return
	end
	local s,e = string.find(sCmd,"@(.-)@")
	if not(s==1 and string.len(sCmd)>e) then
		return
	end
	local sKey = string.sub(sCmd,s,e)
	local sParam = string.sub(sCmd,e+1,string.len(sCmd))
	return hGlobal.event:call("Event_PVPGameDataRecv",nPlayerId,sKey,sParam,nMapID)
end

hApi.PVPRecvGameCmd = function(nPlayerId,sCmd)
	local oWorld = hGlobal.NetBattlefield

	if sCmd==nil then
		return
	end
	if not(oWorld and oWorld.ID~=0 and type(oWorld.data.netdata)=="table") then
		return
	end
	local tNetData = oWorld.data.netdata
	--PVE战斗的话,读取发送者id
	if tNetData.IsPVE==1 then
		local s,e,p = string.find(sCmd,"%[(%--%d+)%]")
		if s==1 then
			local nLen = string.len(sCmd)
			if e<nLen then
				nPlayerId = tonumber(p)
				sCmd = string.sub(sCmd,e+1,nLen)
			end
		end
	end
	local tPlayerParam = oWorld.data.netdata.PlayerParam
	local oPlayer
	for i = 1,#tPlayerParam do
		if tPlayerParam[i][1]==nPlayerId then
			oPlayer = hGlobal.player[i]
			break
		end
	end
	if string.sub(sCmd,1,1)=="@" then
		local sHead
		local e = string.find(sCmd,"@",2)
		if e and e>2 then
			sHead = string.sub(sCmd,1,e)
		end
		if sHead==nil then
			--非法的命令
			print("[NET ERROR]unknown net cmd: ",sCmd)
		elseif hGlobal.PVP_NET_CMD_FUNC[sHead] then
			hGlobal.PVP_NET_CMD_FUNC[sHead](oWorld,oPlayer,nPlayerId,sCmd)
		else
			print("[NET ERROR]unknown net cmd: ",sCmd)
		end
	else
		--print("收到网络命令",oPlayer.data.playerId,sCmd)
		hGlobal.event:event("LocalEvent_NetBattlefieldCmd",oWorld,oPlayer,sCmd)
		return hApi.PVPNetCall(oPlayer,oWorld,sCmd)
	end
end
handlers[hVar.PVP_OPERATE_TYPE.P2P_GAME_CMD] = function(self, packet)
	local nPlayerId = packet:readUInt()
	local sCmd = packet:readString()
	local nCount = packet:readInt()
	if hVar.OPTIONS.PVP_CMD_LOG==1 then
		xlLG("pvp_cmd"," r - "..tostring(sCmd).."\n")
	end
	--print("recv cmd,",nPlayerId,nCount,sCmd)
	if type(nCount)=="number" then
		g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_GAME_CMD_CONFIRM,nCount)
	end
	return hApi.PVPRecvGameCmd(nPlayerId,sCmd)
end
----------------------------------------
local __Sum = 0
local __ENUM__SumUnitAttr = function(u)
	for i = 1,#hVar.NB_UNIT_ATTR_SYNC_KEY do
		local k = hVar.NB_UNIT_ATTR_SYNC_KEY[i]
		if type(u.attr[k])=="number" then
			__Sum = __Sum + u.attr[k]
		end
	end
end
local __ENUM__SumUnitAttrWithCmd = function(u,tCmd)
	local t = {"unit["..u.data.worldI.."]"}
	for i = 1,#hVar.NB_UNIT_ATTR_SYNC_KEY do
		local k = hVar.NB_UNIT_ATTR_SYNC_KEY[i]
		if type(u.attr[k])=="number" then
			__Sum = __Sum + u.attr[k]
			t[#t+1] = i.."#"..u.attr[k]..","
		end
	end
	tCmd[#tCmd+1] = table.concat(t)
end
hApi.GetBFUnitAttrSum = function(oWorld,tCmd)
	__Sum = 0
	if type(tCmd)=="table" then
		oWorld:enumunit(__ENUM__SumUnitAttrWithCmd,tCmd)
	else
		oWorld:enumunit(__ENUM__SumUnitAttr)
	end
	return __Sum
end
hApi.NBUnitActived = function(oWorld,oRound,oUnit)
	if type(oWorld.data.netdata)~="table" then
		return hGlobal.event:event("Event_BattlefieldUnitActived",oWorld,oRound,oUnit)
	end
	local tTemp = {}
	local sCmd = "@SYNC_SUM@["..oRound.data.operatecount.."]"..hApi.GetBFUnitAttrSum(oWorld,tTemp)
	oWorld.data.netdata.synctemp = tTemp
	hApi.PVPSendPlayerCmd(hGlobal.LocalPlayer,oWorld,sCmd)
end
----------------------------------------

handlers[hVar.PVP_OPERATE_TYPE.L2C_OP_TIMEOUT] = function(self, packet)
	print("time out!!!!")
end

hApi.CreateNetPlayerParam = function(connid,roleid)
	local tNetData = {}
	tNetData[hVar.NET_DATA_DEFINE.PLAYER_ID] = connid
	tNetData[hVar.NET_DATA_DEFINE.PLAYER_ROLE_ID] = roleid
	tNetData[hVar.NET_DATA_DEFINE.PLAYER_NAME] = 0
	tNetData[hVar.NET_DATA_DEFINE.BF_DATA] = {}
	tNetData[hVar.NET_DATA_DEFINE.IS_READY] = 0
	tNetData[hVar.NET_DATA_DEFINE.SYNC_SUM] = {}
	tNetData[hVar.NET_DATA_DEFINE.DEPLOYMENT] = 0
	tNetData[hVar.NET_DATA_DEFINE.DEPLOYMENT_CONV] = 0
	tNetData[hVar.NET_DATA_DEFINE.ELO] = 0
	return tNetData
end

--从房间字符串中读取以下信息
local __tRoomDataFromCmd = {
	{"roomid","roomid"},
	{"gameid","gameid"},
}

handlers[hVar.PVP_OPERATE_TYPE.L2C_BATTLE_INFO] = function(self, packet)
	local randSeed = packet:readUInt()
	local sExtraRule
	if g_PVP_NetSaveData.PVPSwitch.ver==1 then
		sExtraRule = packet:readString()
	end
	local tTemp = __tRoomDataFromCmd
	for i = 1,#tTemp do
		local k,s = tTemp[i][1],tTemp[i][2]
		hGlobal.NET_DATA[k] = 0
		if sExtraRule then
			local _,_,v = string.find(sExtraRule,s.."=(%--%d+);")
			if v then
				hGlobal.NET_DATA[k] = tonumber(v)
			end
		end
	end
	hGlobal.NET_DATA.PlayerArmyList = {}
	hGlobal.NET_DATA.RoomRandomSeed = randSeed
	local count = packet:readUShort()
	for i = 1,count do
		local connid = packet:readUInt()
		local roleid = packet:readUInt()
		hGlobal.NET_DATA.PlayerArmyList[i] = hApi.CreateNetPlayerParam(connid,roleid)
	end
end

handlers[hVar.PVP_OPERATE_TYPE.L2C_CHALLANGE_STATE_CHANGED] = function(self, packet)
	local iChallenge = packet:readUInt()
	local iState = packet:readByte()
	local iReason = packet:readInt()
	local nMyRoomID = packet:readInt()
	g_PVP_NetSaveData.MyRoomID = nMyRoomID
	return hGlobal.event:event("LocalEvent_PVPRoomStateChanged",iChallenge,iState,iReason,nMyRoomID)
end

handlers[hVar.PVP_OPERATE_TYPE.L2C_GAME_RESULT_RET] = function(self, packet)
	local iErrCode = packet:readUInt()
	local result = packet:readString()
	
	g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_LEAVE_GAME)

	print("L2C_GAME_RESULT_RET errcode:"..iErrCode.." result:"..(result or "nil"))
end

handlers[hVar.PVP_OPERATE_TYPE.L2C_PLAYER_NET_SAVE_UPDATE] = function(self, packet)
	local iResult = packet:readUInt()
	local nResultID = packet:readUInt()
	local nUnique = packet:readUInt()
	local sData = packet:readString()
	local nPVPCoin = packet:readUInt()
	local nMyElo = packet:readUInt()
	local nMyLv = packet:readUInt()
	return hGlobal.event:call("Event_PVPNetSaveOprResult",iResult,nResultID,nUnique,sData,nPVPCoin,nMyLv,nMyElo)
end

--收到心跳包，避免掉线
handlers[hVar.PVP_OPERATE_TYPE.L2C_ONLINE] = function(self,packet)
	local iType = packet:readUInt()
	if iType==1 and g_lua_src==1 then
		local oWorld = hGlobal.LocalPlayer:getfocusworld()
		if oWorld and type(oWorld.data.netdata)=="table" and oWorld==hGlobal.NetBattlefield then
			local tState = {}
			oWorld.data.netdata.netstate = tState
			--战场心跳包
			for i = 1,2 do
				local nState = packet:readUInt()
				local nDelayMx = packet:readUInt()
				local nDelayMn = packet:readUInt()
				local nDelayAv = packet:readUInt()
				local nDelayCr = packet:readUInt()
				tState[#tState+1] = {nState,nDelayMx,nDelayMn,nDelayAv,nDelayCr}
			end
		end
	end
	g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_ONLINE)	--传一个心跳包还给服务器
	return hGlobal.event:event("LocalEvent_PVPClientOnline")
end

--收到游戏局超时警告(游戏即将结束)
handlers[1525] = function(self,packet)
	return hGlobal.event:event("LocalEvent_PVPRoomTimeOutWarning")
end