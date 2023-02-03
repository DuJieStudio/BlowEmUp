local __Cha2NetKey = function(oUnit)
	if type(oUnit)=="table" then
		return oUnit.data.worldI..","
	else
		return ","
	end
end
local __Num2NetKey = function(nNum)
	if type(nNum)=="number" then
		return nNum..","
	else
		return ","
	end
end
local __CmdParamType = {0,0,1,0,1,0,0,0,0}
local __CmdParamKey = {"nOperateCount","nOrder","oOrderUnit","vOrderId","oOrderTarget","gridX","gridY","worldX","worldY"}
local __Cmd2Param = function(oWorld,sCmd)
	local tCmd = {}
	local nIndex = 1
	for i = 1,#__CmdParamKey do
		local k = __CmdParamKey[i]
		local n = string.find(sCmd,",",nIndex)
		if n then
			if n>nIndex then
				local v = tonumber(string.sub(sCmd,nIndex,n-1))
				if __CmdParamType[i]==1 then
					local oUnit = hApi.getObjectFromBind(hClass.unit,"units","worldI",oWorld,v)
					if oUnit and oUnit:getworld()==oWorld then
						tCmd[k] = oUnit
					end
				else
					tCmd[k] = v
				end
			end
			nIndex = n+1
		else
			return
		end
	end
	return tCmd
end

local __CmdUpdate = function(tNetData,nOprCount)
	local tTemp = tNetData.netorder
	local tOrder = {}
	if nOprCount~=nil then
		tNetData.operatecount = nOprCount
	end
	tNetData.netorder = tOrder
	--保证每回合只能有1个命令被执行
	for i = 2,#tTemp do
		if tTemp[i][1]~=nOprCount then
			tOrder[#tOrder+1] = tTemp[i]
		end
	end
end

hApi.PVPNetCall = function(oPlayer,oWorld,sCmd)
	local tNetData = oWorld.data.netdata
	local e = string.find(sCmd,",")
	--print("recv cmd",sCmd)
	if e and e>1 then
		local nOperateCount = tonumber(string.sub(sCmd,1,e-1))
		if type(nOperateCount)=="number" then
			local nCurOprCount = tNetData.operatecount
			local nPlayerId = oPlayer.data.playerId
			if nCurOprCount<nOperateCount then
				tNetData.netorder[#tNetData.netorder+1] = {nOperateCount,nPlayerId,sCmd}
				oWorld:netlog("["..nCurOprCount.."]recv:"..nPlayerId..":"..sCmd..";")
			else
				oWorld:netlog("["..nCurOprCount.."]over:"..nPlayerId..":"..sCmd..";")
			end
			return
		end
	end
end

hApi.PVPNetGo = function(oWorld)
	local tNetData = oWorld.data.netdata
	local oRound = oWorld:getround()
	if oRound==nil then
		return
	end
	if oWorld:operateable()~=hVar.RESULT_SUCESS then
		return
	end
	if not(type(tNetData)=="table" and type(tNetData.netorder[1])=="table") then
		return
	end
	local tParam = tNetData.netorder[1]
	local nOprCount = tParam[1]
	local nCurOprCount = oRound.data.operatecount
	if nOprCount<=nCurOprCount then
		--__CmdUpdate(tNetData,nOprCount)
		local oPlayer = hGlobal.player[tParam[2]]
		local sCmd = tParam[3]
		local tCmd = __Cmd2Param(oWorld,sCmd)
		if tCmd~=nil and oPlayer~=nil then
			local nMySum = hApi.GetBFUnitAttrSum(oWorld)
			oWorld:netlog("["..nCurOprCount.."]sync:"..nMySum..";")
			--如果是看录像，那么进行合法性检测
			if oWorld.data.IsReplay==1 and tNetData.replay_sync then
				local nRepSum = tNetData.replay_sync[nCurOprCount]
				if nRepSum~=nMySum then
					oWorld:pause(1,"rep_sync_error")
					oWorld:exit("rep_sync_error",{nMySum,nRepSum})
					return
				end
			end
			local nPlayerId = oPlayer.data.playerId
			if oPlayer:operate(oWorld,tCmd.nOrder,tCmd.oOrderUnit,tCmd.vOrderId,tCmd.oOrderTarget,tCmd.gridX,tCmd.gridY,tCmd.worldX,tCmd.worldY)==hVar.RESULT_SUCESS then
				hGlobal.event:event("LocalEvent_NetBattlefieldCmdProc",oWorld,oPlayer,sCmd)
				oWorld:netlog("["..nCurOprCount.."]proc:"..nPlayerId..":"..sCmd..";")
				__CmdUpdate(tNetData,nOprCount)
			else
				oWorld:netlog("["..nCurOprCount.."]skip:"..nPlayerId..":"..sCmd..";")
				__CmdUpdate(tNetData,nil)
			end
		else
			hGlobal.UI.MsgBox("vs cmd error",{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end
	end
end

hApi.PVPNetCmd = function(oPlayer,oWorld,nOrder,oOrderUnit,vOrderId,oOrderTarget,gridX,gridY,worldX,worldY)
	local sCmd
	local nOperateCount = -1
	if nOrder==hVar.OPERATE_TYPE.PLAYER_ROUND_READY then
		sCmd = "@READY@"
	else
		local oRound = oWorld:getround()
		if oRound then
			nOperateCount = oRound.data.operatecount
		end
		local tCmd = {}
		tCmd[#tCmd+1] = __Num2NetKey(nOperateCount)
		tCmd[#tCmd+1] = __Num2NetKey(nOrder)
		tCmd[#tCmd+1] = __Cha2NetKey(oOrderUnit)
		tCmd[#tCmd+1] = __Num2NetKey(vOrderId)
		tCmd[#tCmd+1] = __Cha2NetKey(oOrderTarget)
		tCmd[#tCmd+1] = __Num2NetKey(gridX)
		tCmd[#tCmd+1] = __Num2NetKey(gridY)
		tCmd[#tCmd+1] = __Num2NetKey(worldX)
		tCmd[#tCmd+1] = __Num2NetKey(worldY)
		sCmd = table.concat(tCmd)
		local nDelay = hApi.NBFGetPlayerOrderTimeUsed(nOperateCount,nOrder,vOrderId,sCmd)
		if nDelay~=nil then
			sCmd = sCmd.."#"..nDelay
		end
	end
	--print("sendCmd!",sCmd)
	hApi.PVPSaveCmdLog(oWorld,sCmd)
	hApi.PVPSendPlayerCmd(oPlayer,oWorld,sCmd)
end

hApi.PVPSaveCmdLog = function(oWorld,sCmd)
	if g_curPlayerName and type(oWorld.data.netdata)=="table" then
		if sCmd==-1 then
			--清空cmdlog
			--然而实际上根本不会用到这个功能吗
		else
			--存log
			local tCmdLog = oWorld.data.netdata.cmdlog
			local all,free,used = xlGetMemoryInfo()
			if sCmd=="disconnect" then
				--掉线啦
				tCmdLog.disconnect = 1
			end
			tCmdLog[#tCmdLog+1] = "cmd="..tostring(sCmd)..";mem="..tostring(all)..","..tostring(free)..","..tostring(used)..";"
			local tTemp = {"__g__PVPCmdTemp={gameid="..oWorld.data.netdata.gameid..",memory="..used..",disconnect="..(tCmdLog.disconnect or 0)..","}
			for i = 1,#tCmdLog do
				tTemp[#tTemp+1] = "\""..tCmdLog[i].."\","
			end
			tTemp[#tTemp+1] = "}"
			LuaSaveGameData(g_localfilepath..g_curPlayerName.."pvpcmd.tmp",tTemp)
		end
	end
end

hApi.PVPSendCmdLog = function(nGameId,IAmAlive)
	local sCmd = "0"
	if g_curPlayerName then
		__g__PVPCmdTemp = nil
		LuaLoadSavedGameData(g_localfilepath..g_curPlayerName.."pvpcmd.tmp")
		local tLog = __g__PVPCmdTemp
		__g__PVPCmdTemp = nil
		if type(tLog)=="table" and (nGameId==0 or tLog.gameid==nGameId) then
			local tCmd = {}
			--如果客户端仍然存活，那么不会有这些东西
			if IAmAlive~=1 then
				--如果掉线了，那么第一个字符串会变成这个
				if tLog.disconnect==1 then
					tCmd[#tCmd+1] = "!DISCONNECT;\n"
				end
				--如果最后一次记录cmd时候的内存消耗大于170m，那么把这个报告写进去
				if (tLog.memory or 0)>170000 then
					tCmd[#tCmd+1] = "!MEM="..string.format("%.2f",tLog.memory/1000).."mb;\n"
				end
			end
			tCmd[#tCmd+1] = "gameid="..tostring(tLog.gameid)..";\n"
			for i = 1,#tLog,1 do
				local v = tLog[i]
				tCmd[#tCmd+1] = tostring(tLog[i])
				tCmd[#tCmd+1] = "\n"
			end
			sCmd = table.concat(tCmd)
		end
	end
	if g_NetManager:isConnected() then
		g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_LOG,hVar.PVP_LOG_TYPE.CMD_LOG,sCmd)
	end
end