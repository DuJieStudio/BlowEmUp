--------------------------------------------
--网络数据
--------------------------------------------
--全变量:局网络存档
g_PVP_NetSaveData = {
	MyVSCount = 0,				--记录这是我的第几局对决，用于解决一些奇怪的bug
	MyVSGameID = 0,				--我当前正在进行的对决号
	MyData = {lv=0,elo=0},
	MyRoomID = 0,				--玩家状态改变的时候，这个值会被设置成当前所处的房间ID，不同的房间拥有不同对战规则
	MyExitOprTick = 0,			--玩家主动退出后，该变量会被设置为系统时间，10秒内如果收到来自服务器的断线消息会认为是正常断开连接
	PVPSetChoosed = {},
	PVPBannedHero = {},			--pvp中被禁止的英雄
	NetSaveData = "",
	PVPRewardDataI = "",
	PVPRewardDataII = "",
	PVPCoin = -1,
	PVPDeploy = 0,
	ArmyCard = {index={}},
	PVPCooldown = {},
	ArmyCardDefault = {
		101,102,103,105,104,
		113,112,110,108,107,
		106,111,109,115,114,
		116,301,302,303,304,
		305,
	},
	activity = "",					--活动列表
	PVPSwitch = {
		ver = 0,				--服务器模式
		replay = 0,				--是否能看录像
		upload_replay = 0,			--是否上传录像
		npc = 0,				--是否允许挑战npc
		automatch = 0,				--是否允许自动匹配
		cheater = 0,				--是否作弊者
		--room(%d)_enable = 0,			--允许进入指定房间--0:禁止,1:允许匹配,2:允许挑战和匹配
	},
	CheatItemVersion = {},				--只要道具的版本号为作弊版本号，就会进行处理:1.完全失去锻造属性,2.拥有的全才(32)数量大于1个，失去锻造属性
	PVPQuest = {},					--任务列表
	L2CReplay = {index={}},				--服务器发过来的录像
	L2CNpc = {index={}},				--服务器发过来的NPC
	RankKing = {index = {}},			--服务器传过来的上赛季冠军信息
}
hVar.PVP_NET_BF_SWITCH = {"hero_rd1","unit_rd1","unit_toughness"}		--创建网络战场时，需要拷贝到地图内的开关信息
hGlobal.PVP_NET_CMD_FUNC = {}				--收到特殊命令时的处理函数(@xxx@)
hVar.PVP_ARMY_CARD_EXP = 100000
local __TAB__tPVPSet					--PVP默认装备表
hApi.ResetPVPSet = function()
	if __TAB__tPVPSet==nil then
		__TAB__tPVPSet = hApi.ReadParamWithDepth(hVar.tab_pvpset,nil,{},10)
	else
		hVar.tab_pvpset = hApi.ReadParamWithDepth(__TAB__tPVPSet,nil,{},10)
	end
end
hApi.ReadPVPSetItemByCmd = function(sCmd)
	local t = hApi.Split(sCmd,",")
	local id = tonumber(t[1])
	if id and hVar.tab_item[id] then
		local ex = {0}
		for i = 2,#t do
			local eid = tonumber(t[i])
			if hVar.tab_enhance[eid] then
				ex[1] = ex[1] + 1
				ex[#ex+1] = eid
			end
		end
		return hApi.CreateItemObjectByID(id,ex,nil,-1)
	end
end
hApi.ReadPVPQuestByCmd = function(sCmd)
	g_PVP_NetSaveData.PVPQuest = {}
	if type(sCmd)~="string" then
		return
	end
	local tQuestMy = g_PVP_NetSaveData.PVPQuest
	local tQuest = hApi.GetParamByCmd("qst:",sCmd)
	for i = 1,#tQuest do
		local t = {}
		local v = tQuest[i]
		tQuestMy[#tQuestMy+1] = t
		t[hVar.PVP_QUEST_DATA.TYPE] = tonumber(v[hVar.PVP_QUEST_DATA.TYPE]) or 0
		t[hVar.PVP_QUEST_DATA.STATE] = tonumber(v[hVar.PVP_QUEST_DATA.STATE]) or 0
		t[hVar.PVP_QUEST_DATA.NAME] = hApi.FormatLobbyString(v[hVar.PVP_QUEST_DATA.NAME],"__TEXT__PVPQuest_Name_")
		t[hVar.PVP_QUEST_DATA.TIP] = hApi.FormatLobbyString(v[hVar.PVP_QUEST_DATA.TIP])
		t[hVar.PVP_QUEST_DATA.INTRO] = hApi.FormatLobbyString(v[hVar.PVP_QUEST_DATA.INTRO],"__TEXT__PVPQuest_Intro_")
		t[hVar.PVP_QUEST_DATA.REWARD] = {}
		if #v>4 then
			local tQuest = t[hVar.PVP_QUEST_DATA.REWARD]
			for n = 6,#v do
				if type(v[n])=="string" then
					tQuest[#tQuest+1] = hApi.SplitN(v[n],",")
				end
			end
		end
	end
end
---------------------------------------
--重置pvp开关
hApi.PVPSwitchReset = function()
	for k,v in pairs(g_PVP_NetSaveData.PVPSwitch) do
		g_PVP_NetSaveData.PVPSwitch[k] = 0
	end
	g_PVP_NetSaveData.CheatItemVersion = {}
	g_PVP_NetSaveData.L2CReplay = {index={}}
	g_PVP_NetSaveData.L2CNpc = {index={}}
	g_PVP_NetSaveData.PVPBannedHero = {}
end

hApi.PVPSwitchUpdate = function(sCmd)
	local tPVPSwitch = g_PVP_NetSaveData.PVPSwitch
	if type(sCmd)=="string" then
		local tTemp = hApi.GetParamByCmd("sw:",sCmd)
		if tTemp and #tTemp>=1 then
			for i = 1,#tTemp do
				local v = tTemp[i]
				if #v==2 then
					tPVPSwitch[tostring(v[1])] = tonumber(v[2])
				end
			end
		end
	end
	--如果开关中有尚未上报的消息，向服务器发送自己最后的战报
	if (tPVPSwitch.last_gameid or 0)~=0 then
		local nGameId = tPVPSwitch.last_gameid
		tPVPSwitch.last_gameid = 0
		hApi.PVPSendCmdLog(nGameId)
	end
end
---------------------------------------
--网络数据操作事件
hGlobal.event["Event_PVPNetSaveOprResult"] = function(nResult,nResultID,nUnique,sData,nPVPCoin,nMyLv,nMyElo)
	g_PVP_NetSaveData.PVPCoin = nPVPCoin
	g_PVP_NetSaveData.MyData = {
		lv = nMyLv,
		elo = nMyElo,
	}
	if nResultID==hVar.NET_SAVE_OPR_TYPE.L2C_UPDATE_ALL_ARMY_CARD then
		if type(sData)=="string" then
			g_PVP_NetSaveData.NetSaveData = sData
		else
			g_PVP_NetSaveData.NetSaveData = ""
		end
		hApi.PVPUpdateAllNetData()
	elseif nResultID==hVar.NET_SAVE_OPR_TYPE.L2C_UPDATE_ONE_ARMY_CARD then
		if type(sData)=="string" then
			hApi.PVPUpdateAllNetData(sData)
			local _,_,nCost,nMyCoin = string.find(sData,"$:(%--%d+):(%--%d+);")
			if nCost and nMyCoin then
				print("支付成功！",nCost,nMyCoin)
				local nGameCoinCur = tonumber(nMyCoin)
				if nGameCoinCur and nGameCoinCur~=-1 then
					--我的剩余游戏币
					hVar.ROLE_PLAYER_GOLD = nGameCoinCur --存储本地金币数量
					hGlobal.event:event("LocalEvent_Phone_SetCurGameCoin_Game",nGameCoinCur)
				end
			end
		end
	end
	return hGlobal.event:event("LocalEvent_PVPNetSaveOprResult",iResult,nResultID,nUnique,sData,nPVPCoin,nMyLv,nMyElo)
end

---------------------------------------
--收到战场参战数据
hGlobal.event["Event_PVPGameDataRecv"] = function(nPlayerId,sKey,sParam,vParam)
	if sKey=="@hero@" then
		print("接受来自玩家"..nPlayerId.."的英雄数据")
		local tPlayerParam = hGlobal.NET_DATA.PlayerArmyList
		if tPlayerParam==nil then
			print("没有初始化房间信息，无法开始游戏！")
		else
			local tBFData,sDeployment = hApi.ConvertCmdToNetArmyData(sParam)
			if type(tBFData)=="table" then
				for i = 1,#tPlayerParam do
					if tPlayerParam[i][hVar.NET_DATA_DEFINE.PLAYER_ID]==nPlayerId then
						tPlayerParam[i][hVar.NET_DATA_DEFINE.BF_DATA] = tBFData
						tPlayerParam[i][hVar.NET_DATA_DEFINE.DEPLOYMENT] = sParam
						tPlayerParam[i][hVar.NET_DATA_DEFINE.DEPLOYMENT_CONV] = sDeployment
						tBFData.IsReady = 1
						break
					end
				end
			else
				print("非法玩家参战数据，无法开始游戏")
			end
			local CanEnterBattle = 1
			for i = 1,#tPlayerParam do
				if tPlayerParam[i][hVar.NET_DATA_DEFINE.BF_DATA].IsReady~=1 then
					CanEnterBattle = 0
					break
				end
			end
			if CanEnterBattle==1 and hGlobal.NET_DATA.LocalPlayerId then
				print("网络战场开始")
				local nMapID = 1
				if type(vParam)=="number" then
					nMapID = vParam
				end

				--刷名字流程(等洪慧敏来了移动到服务器去)
				local tNetPlayer = hGlobal.NET_DATA.ROOM_PLAYER_LIST
				local tNetDataIndex = {}
				for i = 1,#tPlayerParam do
					tNetDataIndex[tPlayerParam[i][hVar.NET_DATA_DEFINE.PLAYER_ID]] = i
				end
				for i = 1,#tNetPlayer do
					local nPlayerNetID = tNetPlayer[i][hVar.PVP_PLAYER_DATA.ID]
					local nNetDataI = tNetDataIndex[nPlayerNetID]
					if nNetDataI then
						tPlayerParam[nNetDataI][hVar.NET_DATA_DEFINE.PLAYER_NAME] = tNetPlayer[i][hVar.PVP_PLAYER_DATA.NAME]
						tPlayerParam[nNetDataI][hVar.NET_DATA_DEFINE.ELO] = tNetPlayer[i][hVar.PVP_PLAYER_DATA.ELO]
					end
				end
				local nRoomID = hGlobal.NET_DATA.roomid
				local nGameID = hGlobal.NET_DATA.gameid
				local nLocalPlayerId = hGlobal.NET_DATA.LocalPlayerId
				local nRandomSeed = hGlobal.NET_DATA.RoomRandomSeed
				local tPlayerParam = hGlobal.NET_DATA.PlayerArmyList
				--如果我的VSGameID不等于0才能开具，否则视为出错啦
				if g_PVP_NetSaveData.MyVSGameID~=0 then
					hApi.CreateNetBattlefield(nGameID,nRoomID,nLocalPlayerId,nMapID,nRandomSeed,tPlayerParam,g_PVP_NetSaveData.PVPSwitch)	--对决
				end
			end
		end
	end
end


--------------------------------------------
--功能函数
--------------------------------------------
--兵种卡片颜色
local __TAB__ArmyCardColor = {
	[1] = {1,2,2,2,3},
	[2] = {1,2,2,2,3},
	[3] = {2,3,3,3,4},
}
hApi.PVPGetNetData = function(sType,sParam)
	if sType=="ArmyCard" then
		if type(sParam)=="number" then
			local nCardID = sParam
			local nCardI = g_PVP_NetSaveData.ArmyCard.index[nCardID]
			if nCardI then
				return g_PVP_NetSaveData.ArmyCard[nCardI]
			end
		end
	elseif sType=="ArmyCardLv" then
		if type(sParam)=="number" then
			local nCardID = sParam
			local nCardI = g_PVP_NetSaveData.ArmyCard.index[nCardID]
			if nCardI and hVar.tab_army[nCardID] then
				local nCardLv = g_PVP_NetSaveData.ArmyCard[nCardI][2]
				if nCardLv<=0 then
					return 0
				else
					local tColor = __TAB__ArmyCardColor[hVar.tab_army[nCardID].quality or 0]
					if tColor then
						return tColor[nCardLv] or tColor[#tColor]
					end
				end
			end
		end
		return 0
	end
end

hApi.PVPSendNetSaveOpr = function(nOprID,sParam)
	if type(sParam)~="string" then
		sParam = "0"
	end
	local nUnique = 0
	if g_NetManager:isConnected() then
		g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_PLAYER_NET_SAVE_UPDATE,nOprID,nUnique,sParam)
	else
		print("网络未连接")
	end
end


local __code__InsertToList = function(t,v)
	local nInsert = #t+1
	t[nInsert] = v
	t.index[v[1]] = nInsert
end
hApi.PVPUpdateAllNetData = function(sArmyCard)
	if type(sArmyCard)~="string" then
		g_PVP_NetSaveData.ArmyCard = {index={}}
		for i = 1,#g_PVP_NetSaveData.ArmyCardDefault do
			local nCardID = g_PVP_NetSaveData.ArmyCardDefault[i]
			local nCardLv,nCardExp = 0,0
			local nUnitID,nUnitNum = hApi.GetArmyCardUnit(nCardID,nCardLv,nCardExp)
			__code__InsertToList(g_PVP_NetSaveData.ArmyCard,{nCardID,nCardLv,nCardExp,nUnitID,nUnitNum})
		end
		sArmyCard = g_PVP_NetSaveData.NetSaveData
	end
	for id,lv,xp in string.gfind(sArmyCard,"ac:([%d]+):([%d]+):([%d]+);")do
		local nCardID,nCardLv,nCardExp = tonumber(id),tonumber(lv),tonumber(xp)
		local nUnitID,nUnitNum = hApi.GetArmyCardUnit(nCardID,nCardLv,nCardExp)
		local tCardA = hApi.PVPGetNetData("ArmyCard",nCardID)
		if tCardA then
			tCardA[2] = nCardLv
			tCardA[3] = nCardExp
			tCardA[4] = nUnitID
			tCardA[5] = nUnitNum
		else
			__code__InsertToList(g_PVP_NetSaveData.ArmyCard,{nCardID,nCardLv,nCardExp,nUnitID,nUnitNum})
		end
	end
	return hGlobal.event:event("Event_PVPNetSaveUpdateArmyCard")
end

local __GetArmyCardNumByLv = function(id,lv)
	local t = hVar.tab_army[id].num
	if lv<=1 then
		return t[1]
	elseif lv>=#t then
		return t[#t]
	elseif t[lv]~=0 then
		return t[lv]
	else
		local mn = math.max(1,lv)
		for i = lv,1,-1 do
			if t[i]~=0 then
				mn = i
				break
			end
		end
		local mx = mn
		for i = lv,#t,1 do
			if t[i]~=0 then
				mx = i
				break
			end
		end
		return t[mn]+math.floor((lv-mn)*(t[mx]-t[mn])/(mx-mn))
	end
end

hApi.GetArmyCardUnit = function(id,lv,xp)
	local nUnitID,nUnitNum,nCardLv = 0,0,0
	local tabA = hVar.tab_army[id]
	if tabA then
		nCardLv = (tabA.quality or 1)-1
		for i = 1,math.min(math.max(1,lv),#tabA.unit),1 do
			if tabA.unit[i]~=0 then
				nCardLv = nCardLv + 1
				nUnitID = tabA.unit[i]
			end
			if i>=lv then
				break
			end
		end
		if lv<=0 then
			nUnitNum = 0
		else
			local nMin = __GetArmyCardNumByLv(id,lv)
			local nMax = __GetArmyCardNumByLv(id,lv+1)
			if nMin==nMax then
				nUnitNum = nMin
			else
				nUnitNum = nMin + math.floor((nMax-nMin)*xp/hVar.PVP_ARMY_CARD_EXP)
			end
			
		end
	end
	return nUnitID,nUnitNum,nCardLv
end

hApi.GetArmyCardPlusAttr = function(id,lv,tPlusAttr)
	if type(tPlusAttr)~="table" then
		tPlusAttr = {}
	end
	local tabA = hVar.tab_army[id]
	if tabA and tabA.attr then
		local tAttr = tabA.attr
		for i = 1,math.min(#tAttr,lv),1 do
			if tAttr[i]~=0 then
				for k,v in pairs(tAttr[i])do
					tPlusAttr[k] = (tPlusAttr[k] or 0) + v
				end
			end
		end
	end
	return tPlusAttr
end

local __PVP__UnitScoreByID = {}
for id = 100,200 do
	local tabA = hVar.tab_army[id]
	if tabA then
		local nScore = math.floor(10000/math.max(1,tabA.num[#tabA.num]))
		for i = 1,#tabA.unit do
			local uId = tabA.unit[i]
			if uId~=0 then
				__PVP__UnitScoreByID[uId] = nScore
			end
		end
	end
end

hApi.PVPGetScoreByUnitID = function(nUnitID)
	if __PVP__UnitScoreByID[nUnitID] then
		return __PVP__UnitScoreByID[nUnitID]
	else
		return 1
	end
end


hApi.PVPGetCardUpgradeCost = function(id,lv)
	local tabA = hVar.tab_army[id]
	if tabA then
		local tCost = hVar.PVP_ARMY_CARD_UPRADE[tabA.level or 1]
		if tCost and tCost[lv] then
			if (tabA.cost_pec or 100)~=100 then
				return math.ceil(tCost[lv]*tabA.cost_pec/100)
			else
				return tCost[lv]
			end
		end
	end
	return -1
end

local __tUnlockRequireKey = {"lv","elo"}
local __CODE__CheckMyReq = function(tRequire)
	for i = 1,#__tUnlockRequireKey do
		local k = __tUnlockRequireKey[i]
		if (g_PVP_NetSaveData.MyData[k] or 0)<(tRequire[k] or 0) then
			return 0
		end
	end
	return 1
end
local __CODE__ReadMyReq = function(tRequire,r)
	r = r or {}
	for i = 1,#__tUnlockRequireKey do
		local k = __tUnlockRequireKey[i]
		local v = tRequire[k] or 0
		if v>0 then
			local req = {k,v,0}
			if (g_PVP_NetSaveData.MyData[k] or 0)>=v then
				req[3] = 1
			end
			r[#r+1] = req
		end
	end
	return r
end
hApi.PVPCheckArmyCardOpr = function(nCardID,mode)
	local tCardA = hApi.PVPGetNetData("ArmyCard",nCardID)
	if tCardA then
		local id,lv,xp = unpack(tCardA)
		local tabA = hVar.tab_army[id]
		if tabA==nil then
			return hVar.RESULT_FAIL
		end
		if mode=="unlock" then
			local sus = 0
			local tRequire
			if type(tabA.unlock)=="table" then
				if tabA.unlock[1]==0 then
					sus = 1
				elseif type(tabA.unlock[1])=="table" then
					sus = __CODE__CheckMyReq(tabA.unlock[1])
					if sus~=1 then
						tRequire = __CODE__ReadMyReq(tabA.unlock[1],{})
					end
				end
			end
			if sus==1 then
				return hVar.RESULT_SUCESS
			else
				return hVar.RESULT_FAIL,tRequire
			end
		elseif mode=="upgrade" then
			--超过最大等级直接返回，不允许升级
			if (lv+1)>tabA.level then
				return hVar.RESULT_FAIL
			end
			local IsHaveCoin = 1
			local sus = 0
			local tRequire = {}
			if xp>=hVar.PVP_ARMY_CARD_EXP then
				lv = lv + 1
			end
			local nCost = hApi.PVPGetCardUpgradeCost(id,lv)
			if nCost>=0 then
				if g_PVP_NetSaveData.PVPCoin<nCost then
					IsHaveCoin = 0
				end
				tRequire[#tRequire+1] = {"pvp_coin",nCost,IsHaveCoin}
			end
			if type(tabA.unlock)=="table" and type(tabA.unlock[lv])=="table" then
				if IsHaveCoin==0 then
					sus = 0
					__CODE__ReadMyReq(tabA.unlock[lv],tRequire)
				else
					sus = __CODE__CheckMyReq(tabA.unlock[lv])
					__CODE__ReadMyReq(tabA.unlock[lv],tRequire)
				end
			else
				if IsHaveCoin==1 then
					sus = 1
				else
					sus = 0
				end
			end
			if sus==1 then
				return hVar.RESULT_SUCESS,tRequire
			else
				return hVar.RESULT_FAIL,tRequire
			end
		end
	end
	return hVar.RESULT_FAIL
end

hApi.PVPCheckMyDeployment = function(tMyDeployment,pFunc)
	local tMyArmyCard = tMyDeployment.army
	local tMyTactics = tMyDeployment.tactics
	if type(tMyArmyCard)~="table" then
		tMyArmyCard = {}
	end
	if type(tMyTactics)~="table" then
		tMyTactics = {}
	end
	local result = hVar.RESULT_SUCESS
	--同类兵种卡不能带超过3张
	do
		local sus = 1
		local tTacticsCount = {}
		for i = 1,#tMyTactics do
			local v = tMyTactics[i]
			if v~=0 and v[1]>10 then
				local tabT = hVar.tab_tactics[v[1]]
				if tabT and tabT.type then
					tTacticsCount[tabT.type] = (tTacticsCount[tabT.type] or 0) + 1
				end
			end
		end
		for k,v in pairs(tTacticsCount)do
			if v>hVar.PVP_TACTICS_CARD_CLASS_LIMIT then
				sus = 0
				result = hVar.RESULT_FAIL
				break
			end
		end
		if type(pFunc)=="function" then
			pFunc(sus,string.gsub(hVar.tab_string["__TEXT_PVPRule01"],"#P1#",tostring(hVar.PVP_TACTICS_CARD_CLASS_LIMIT)))
		end
	end
	return result
end
--------------------------------------------
--网络消息
--------------------------------------------
hApi.PVPSendPlayerCmd = function(oPlayer,oWorld,sCmd)
	local tNetData = oWorld.data.netdata
	if type(tNetData)=="table" and hGlobal.NetBattlefield~=nil then
		if tNetData.IsPVE==1 then
			g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.P2P_GAME_CMD, "["..oPlayer.data.playerId.."]"..sCmd)
		else
			g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.P2P_GAME_CMD, sCmd)
		end
	end
end

hApi.PVPSendTimeoutCmd = function(oWorld,nPlayerId)
	local tNetData = oWorld.data.netdata
	if type(tNetData)=="table" and hGlobal.NetBattlefield~=nil then
		if tNetData.IsPVE==1 then
			g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.P2P_GAME_CMD, "["..nPlayerId.."]@TIMEOUT@0"..nPlayerId)
		else
			g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.P2P_GAME_CMD, "@TIMEOUT@0"..nPlayerId)
		end
	end
end

hApi.ClearNetBattlefield = function(pFuncBeforeClear)
	--if hGlobal.NetBattlefield==nil or hGlobal.NetBattlefield~=hGlobal.BattleField then
		--return
	--end
	if hGlobal.NetBattlefield~=nil and type(pFuncBeforeClear)=="function" then
		pFuncBeforeClear(hGlobal.NetBattlefield)
	end
	hGlobal.NetBattlefield = nil
	if hGlobal.BattleField then
		hGlobal.BattleField:del()
		hGlobal.BattleField = nil
	end
	if hGlobal.WORLD.LastWorldMap then
		hGlobal.WORLD.LastWorldMap:del()
		hGlobal.WORLD.LastWorldMap = nil
		hApi.LuaReleaseBattlefield()
	end
	local tHeroList = {}
	hClass.hero:enum(function(oHero)
		tHeroList[#tHeroList+1] = oHero
	end)
	for i = 1,#tHeroList do
		tHeroList[i]:del()
	end
end

hApi.CreateNetBattlefield = function(nGameID,nRoomID,nLocalPlayerId,nMapID,nRandomSeed,tPlayerParam,tBFSwitch)
	if tPlayerParam==nil then
		print("无网路对战数据")
		return
	end
	hApi.ClearNetBattlefield()
	for i = 1,#tPlayerParam do
		if tPlayerParam[i][hVar.NET_DATA_DEFINE.PLAYER_ID]==nLocalPlayerId then
			hGlobal.LocalPlayer:setlocalplayer(0)
			hGlobal.player[i]:setlocalplayer(1)
			hGlobal.LocalPlayer = hGlobal.player[i]
			break
		end
	end
	hGlobal.WORLD.LastWorldMap = hClass.world:new({
		map = "none",
		background = background,
		type = "none",
		IsQuickBattlefield = 1,
		ImmediateLoad = 0,
	})
	local tUnit = {}
	local tDataEx = {
		tactics = {},
		armybounce = {},
	}
	for nOwner = 1,#tPlayerParam do
		local v = tPlayerParam[nOwner][hVar.NET_DATA_DEFINE.BF_DATA]
		tDataEx.tactics[nOwner] = v.tactics
		tDataEx.armybounce[nOwner] = v.armybounce
		local nLeaderI
		tUnit[nOwner] = hApi.PVPBFInitLeaderByNetData(hGlobal.WORLD.LastWorldMap,v.army,nOwner)
		if tUnit[nOwner]~=nil then
			hApi.PVPBFInitArmyByNetData(hGlobal.WORLD.LastWorldMap,v.army,tUnit[nOwner])
		end
	end
	if not(tUnit[1] and tUnit[2]) then
		hApi.ClearNetBattlefield()
		return
	end
	--hApi.DoSomethingToNetBattleHero(tUnit)
	hGlobal.BattleField = hApi.CreateBattlefield(tUnit[1],tUnit[2],tDataEx,{typeEX=hVar.BF_WORLD_TYPE_EX.PVP},function(oWorld)
		oWorld.data.netdata = {
			PlayerParam = tPlayerParam,
			roomid = nRoomID,
			gameid = nGameID,
			timeout = 30,
			randomseed = nRandomSeed,
			randomvalue = nRandomSeed,
			randomcount = 0,
			isstarted = 0,
			framestart = 0,
			framecount = 0,
			operatecount = 0,
			netorder = {},
			netlog = {},
			sync_error = 0,
			IsPVE = 0,		--打电脑的标记
			IsTimeOut = 0,		--是否已经超时
			TimeOutParam = {},	--操作超时统计[playerId] = {opr_count,time_used,opr_count_ex,time_used_ex}
			error = 0,		--如果是异常局，那么此值会有记录(1:对手掉线，2:不同步) tNetData.error = 0
			cmdlog = {},		--每当玩家进行cmd时，便会增加一条log，并且将此log以文件方式存起来，一旦发生了闪退或掉线，将在重连时上传此log
			switch = {},		--记录下战场使用的开关数值
			--replay_sync = {},
			--netstate = {},
			--AIPlayer = {1,2},
		}
		oWorld.data.BFTeamName = {timeout = 30,my = hGlobal.LocalPlayer.data.playerId}
		for nOwner = 1,#tPlayerParam do
			oWorld.data.BFTeamName[nOwner] = tPlayerParam[nOwner][hVar.NET_DATA_DEFINE.PLAYER_NAME]
		end
		for i = 1,#hVar.PVP_NET_BF_SWITCH do
			local k = hVar.PVP_NET_BF_SWITCH[i]
			oWorld.data.netdata.switch[k] = tBFSwitch[k] or 0
		end
	end,nMapID)
	hGlobal.WORLD.LastWorldMap:pause(1,"Battlefield")
	hGlobal.NetBattlefield = hGlobal.BattleField

	local oWorldBF = hGlobal.BattleField
	for nOwner = 1,#tPlayerParam do
		local v = tPlayerParam[nOwner]
		local nRoleId = v[hVar.NET_DATA_DEFINE.PLAYER_ROLE_ID]
		local nElo = v[hVar.NET_DATA_DEFINE.ELO]
		local sPlayerName = tostring(v[hVar.NET_DATA_DEFINE.PLAYER_NAME])
		oWorldBF:netlog("PLAYER:"..nOwner..":"..nRoleId..":"..nElo..":{"..sPlayerName.."};")
		oWorldBF:netlog(tostring(tPlayerParam[nOwner][hVar.NET_DATA_DEFINE.DEPLOYMENT_CONV]))
	end
	oWorldBF:netlog("RAND:"..tostring(nRandomSeed)..";")
	oWorldBF:netlog("MAP:"..tostring(nMapID)..";")
	hApi.EnterBattlefield(hGlobal.BattleField,tUnit[1],tUnit[2])

	if hUI.FrmNetBattle then
		hUI.FrmNetBattle:show(0)
	end

	return hGlobal.BattleField
end

hApi.PVPGetArmyNumByCount = function(nUnitNum,nCount)
	return math.max(1,math.floor(nUnitNum*(100-nCount*hVar.PVP_ARMY_PUNISH)/100))
end

hApi.PVPBFInitLeaderByNetData = function(oWorld,tArmy,nOwner)
	--如果存在英雄，那么创建一个英雄
	for i = 1,#tArmy do
		local v = tArmy[i]
		if v~=0 and v[1]==hVar.NET_BF_DATA_TYPE.HERO then
			local id,xp,tEquip = v[2],v[3],v[4]
			local oUnit = oWorld:addunit(id,nOwner,nil,nil,hVar.UNIT_DEFAULT_FACING,0,0)
			if oUnit~=nil then
				oUnit.data.team = hApi.InitUnitTeam()
				oUnit.data.team[i] = {id,1}
				--local oHero = hClass.hero:new({
				--	id = id,
				--	owner = nOwner,
				--	unit = oUnit,
				--})
				--oHero:addexp(xp,0)
				----oHero.data.HeroCard = 0
				--if type(tEquip)=="table" then
				--	for n = 1,#tEquip do
				--		if type(tEquip[n])=="table" then
				--			oHero:shiftitem("netbattle",tEquip[n],"equip",n)
				--		end
				--	end
				--end
				return oUnit
			end
			break
		end
	end
	--如果没英雄，那么就创建个单位吧
	for i = 1,#tArmy do
		local v = tArmy[i]
		if v~=0 and v[1]==hVar.NET_BF_DATA_TYPE.UNIT then
			local id,num = v[2],v[3]
			local oUnit = oWorld:addunit(id,nOwner,nil,nil,hVar.UNIT_DEFAULT_FACING,0,0)
			if oUnit~=nil then
				oUnit.data.team = hApi.InitUnitTeam()
				oUnit.data.team[i] = {id,num}
				return oUnit
			end
			break
		end
	end
end

hApi.PVPBFInitArmyByNetData = function(oWorld,tArmy,oUnitL)
	local nOwner = oUnitL.data.owner
	local oHeroL = oUnitL:gethero()
	local nLeaderI = 0
	for i = 1,#oUnitL.data.team do
		if oUnitL.data.team[i]~=0 then
			nLeaderI = i
			break
		end
	end
	for i = 1,#tArmy do
		local v = tArmy[i]
		if v~=0 and nLeaderI~=i then
			if v[1]==hVar.NET_BF_DATA_TYPE.UNIT then
				local id,num = v[2],v[3]
				if hVar.tab_unit[id] and num>0 then
					oUnitL:teamaddunit({{id,num,i}})
				end
			elseif v[1]==hVar.NET_BF_DATA_TYPE.HERO then
				if oHeroL then
					local id,xp,tEquip = v[2],v[3],v[4]
					--local oHero = hClass.hero:new({
					--	id = id,
					--	owner = nOwner,
					--})
					--oHero:addexp(xp,0)
					----oHero.data.HeroCard = 0
					--if type(tEquip)=="table" then
					--	for n = 1,#tEquip do
					--		if type(tEquip[n])=="table" then
					--			oHero:shiftitem("netbattle",tEquip[n],"equip",n)
					--		end
					--	end
					--end
					--oHeroL:teamaddmember(oHero,i)
				end
			end
		end
	end
end

hApi.PVPFormatMyDeployment = function(tMyArmy,tMyTactics)
	local tArmy = {}
	local tTactics = {}
	for i = 1,#tMyTactics do
		if tMyTactics[i]~=0 and tMyTactics[i][1]>100 and hVar.tab_tactics[tMyTactics[i][1]] then
			tTactics[i] = {tMyTactics[i][1],tMyTactics[i][2]}
		else
			tTactics[i] = 0
		end
	end
	for i = 1,hVar.TEAM_UNIT_MAX do
		tArmy[i] = 0
		if (tMyArmy[i] or 0)~=0 and tMyArmy[i][1]>10 and hVar.tab_unit[tMyArmy[i][1]] then
			local id = tMyArmy[i][1]
			local nCardID = tMyArmy[i][3]
			local nCount = tMyArmy[i][4]
			local tabU = hVar.tab_unit[id]
			if tabU.type==hVar.UNIT_TYPE.HERO then
				local tHeroCard = hApi.GetHeroCardById(id)
				if tHeroCard then
					local nHeroID = id
					local nHeroExp = tHeroCard.attr.exp
					local tHeroEquip = hApi.ReadParamWithDepth(tHeroCard.equipment,nil,{},10)
					tArmy[i] = {hVar.NET_BF_DATA_TYPE.HERO,nHeroID,nHeroExp,tHeroEquip}
				end
			else
				local tCardA = hApi.PVPGetNetData("ArmyCard",nCardID)
				if tCardA and tCardA[2]>0 then
					local nCardID = tCardA[1]
					local nCardLv = tCardA[2]
					local nCardExp = tCardA[3]
					tArmy[i] = {hVar.NET_BF_DATA_TYPE.ARMYCARD,nCardID,nCardLv,nCardExp,nCount}
				end
			end
		end
	end
	return tArmy,tTactics
end

--作弊道具的锻造信息将直接被清除
local __CODE__PVPCheckEquipItem = function(oItem)
	local sVersion = tostring(oItem[hVar.ITEM_DATA_INDEX.VERSION])
	local tSlot = oItem[hVar.ITEM_DATA_INDEX.SLOT]
	local nPunish = g_PVP_NetSaveData.CheatItemVersion[sVersion]
	--作弊者检测流程
	if g_PVP_NetSaveData.PVPSwitch.cheater==1 then
		--1号处理方案，所有版本号中存在"TJ"的道具失去锻造效果
		if string.find(tostring(sVersion),"TJ") then
			oItem[hVar.ITEM_DATA_INDEX.SLOT] = {0}
		end
	elseif g_PVP_NetSaveData.PVPSwitch.cheater==2 then
		--2号处理方案，所有装备强制失去锻造效果
		oItem[hVar.ITEM_DATA_INDEX.SLOT] = {0}
	end
	--通用作弊检测流程
	if type(tSlot)=="table" and (tSlot[1] or 0)>0 then
		if nPunish==1 then
			oItem[hVar.ITEM_DATA_INDEX.SLOT] = {0}
		elseif nPunish==2 then
			local nCount = 0
			for i = 2,#tSlot do
				if tSlot[i]==32 then
					nCount = nCount + 1
				end
			end
			if nCount>1 then
				oItem[hVar.ITEM_DATA_INDEX.SLOT] = {0}
			end
		end
	end
	return oItem
end

hApi.PVPC2CSendMyArmyAndTactics = function(nMyRoomID,tMyArmy,tMyTactics,tMyHeroSet)
	local tArmy,tTactics = hApi.PVPFormatMyDeployment(tMyArmy,tMyTactics)
	local tArmyBak = hApi.ReadParam(tArmy,nil,{})
	local tTacticsBak = hApi.ReadParam(tTactics,nil,{})
	local nArmyCount = 0
	--被屏蔽的英雄不能在竞技场中使用
	for i = 1,#tArmy do
		if type(tArmy[i])=="table" then
			local nType,nId = tArmy[i][1],tArmy[i][2]
			if nType==hVar.NET_BF_DATA_TYPE.HERO and g_PVP_NetSaveData.PVPBannedHero[nId]==1 then
				tArmy[i] = 0
			end
		end
	end
	for i = 1,#tArmy do
		if tArmy[i]~=0 then
			nArmyCount = nArmyCount + 1
		end
	end
	--没有单位的话，给他1组弓手
	if nArmyCount==0 then
		tArmy[1] = {hVar.NET_BF_DATA_TYPE.ARMYCARD,102,1,0,0}
	end
	
	if nMyRoomID==2 then
		--训练场规则
		for n = 1,#tArmy do
			local v = tArmy[n]
			if type(v)=="table"then
				if v[1]==hVar.NET_BF_DATA_TYPE.HERO then
					v[3] = 9999999			--练习场经验固定
					v[4] = {0,0,0,0,0,0,0}		--装备固定配置
					local nHeroID = v[2]
					local nMyChoose = 1
					if type(tMyHeroSet)=="table" then
						nMyChoose = tMyHeroSet[nHeroID] or 1
					end
					if hVar.tab_pvpset[nHeroID] and hVar.tab_pvpset[nHeroID][nMyChoose] then
						local tSet = hVar.tab_pvpset[nHeroID][nMyChoose]
						if tSet then
							local tItemList = tSet.equipment
							for i = 1,#v[4] do
								if type(tItemList[i])=="table" then
									local nItemID = tItemList[i][hVar.ITEM_DATA_INDEX.ID]
									local tForge = hApi.ReadParamWithDepth(tItemList[i][hVar.ITEM_DATA_INDEX.SLOT],nil,{},2)
									v[4][i] = hApi.CreateItemObjectByID(nItemID,tForge,nil,-1)
								end
							end
						end
					end
				end
			end
		end
	else
		--一般pvp规则
		for n = 1,#tArmy do
			local v = tArmy[n]
			if type(v)=="table"then
				if v[1]==hVar.NET_BF_DATA_TYPE.HERO and type(v[4])=="table" then
					for i = 1,#v[4] do
						if type(v[4][i])=="table" then
							v[4][i] = __CODE__PVPCheckEquipItem(v[4][i])
						end
					end
				end
			end
		end
	end

	local sCmdData = hApi.ConvertDataToNetCmd({tTactics,tArmy})
	if sCmdData then
		print("我方英雄数据发送成功")
		local sCmd = "@hero@"..sCmdData
		local sCmdSave = hApi.PVPSavePlayerDeployment(tArmyBak,tTacticsBak)
		if sCmdSave then
			g_NetManager:sendGamePacket(hVar.PVP_DB_OPR_TYPE.C2L_UPDATE, hVar.PVP_DB_OPR_TYPE.C2L_UPDATE_DEPLOYMENT, sCmdSave)
		end
		g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.P2P_GAME_DATA, sCmd,hApi.random(1,#hVar.BATTLEFIELD_BG))
	else
		print("我方英雄数据发送失败")
	end
end

hApi.PVPSavePlayerDeployment = function(tArmy,tTactics)
	local nCount = 0
	for i = 1,#tArmy do
		if tArmy[i]~=0 then
			nCount = nCount + 1
		end
	end
	for i = 1,#tTactics do
		if tTactics[i]~=0 then
			nCount = nCount + 1
		end
	end
	if nCount>0 then
		local sCmdSave = hApi.ConvertMyDeploymentToCmd(tArmy,tTactics)
		if sCmdSave then
			g_PVP_NetSaveData.PVPDeploy = sCmdSave
			LuaSaveGameData(g_localfilepath..g_curPlayerName.."pvp.cfg",{"__g__PVPDeploy = '",sCmdSave,"'"})
			return sCmdSave
		end
	end
end

hApi.PVPLoadPlayerDeployment = function()
	__g__PVPDeploy = nil
	LuaLoadSavedGameData(g_localfilepath..g_curPlayerName.."pvp.cfg")
	if type(__g__PVPDeploy)=="string" then
		g_PVP_NetSaveData.PVPDeploy = __g__PVPDeploy
		__g__PVPDeploy = nil
	else
		g_PVP_NetSaveData.PVPDeploy = 0
	end
	return g_PVP_NetSaveData.PVPDeploy
end

--保存我的部署信息到服务器
hApi.ConvertMyDeploymentToCmd = function(tArmy,tTactics)
	local tUploadData = {}
	for i = 1,#tArmy do
		local sData = ""
		if tArmy[i]==0 then
			sData = "amy:"..i..":0:0:0;"
		elseif tArmy[i][1]==hVar.NET_BF_DATA_TYPE.HERO then
			sData = "amy:"..i..":"..hVar.NET_BF_DATA_TYPE.HERO..":"..tArmy[i][2]..":0;"
		elseif tArmy[i][1]==hVar.NET_BF_DATA_TYPE.ARMYCARD then
			sData = "amy:"..i..":"..hVar.NET_BF_DATA_TYPE.ARMYCARD..":"..tArmy[i][2]..":"..tArmy[i][5]..";"
		end
		tUploadData[#tUploadData+1] = sData
	end
	for i = 1,#tTactics do
		local sData = ""
		if tTactics[i]==0 then
			sData = "tac:"..i..":0:0;"
		else
			sData = "tac:"..i..":"..tTactics[i][1]..":"..tTactics[i][2]..";"
		end
		tUploadData[#tUploadData+1] = sData
	end
	local r = table.concat(tUploadData)
	if type(r)=="string" and string.len(r)>=1 then
		return r
	end
end

hApi.ConvertDataToNetCmd = function(tDataToSend)
	if type(tDataToSend)=="table" then
		local rTab = {}
		eClass.ConvertTableToString(nil,"v",tDataToSend,rTab,"","","",{v=0})
		if type(rTab[1])=="string" and string.len(rTab[1])>2 then
			return string.sub(rTab[1],3,string.len(rTab[1]))
		end
	end
end

local __CODE__Equip2Cmd = function(oItem,idx)
	local t = {}
	t[#t+1] = "{"..idx..","
	t[#t+1] = tostring(oItem[hVar.ITEM_DATA_INDEX.ID])
	t[#t+1] = ","
	local v = oItem[hVar.ITEM_DATA_INDEX.SLOT]
	if type(v)=="table" then
		for i = 2,(v[1] or 0)+1,1 do
			t[#t+1] = (v[i] or 0)..","
		end
	end
	t[#t+1] = "v:"..tostring(oItem[hVar.ITEM_DATA_INDEX.VERSION])
	t[#t+1] = "}"
	return table.concat(t)
end

hApi.PVPEquip2DepLog = function(tHeroEquip,tMyDep)
	if type(tHeroEquip)=="table" then
		for n = 1,#tHeroEquip do
			local v = tHeroEquip[n]
			if type(v)=="table" then
				tMyDep[#tMyDep+1] = ":"..__CODE__Equip2Cmd(v,n)
			end
		end
	end
end

hApi.PVPFormatNetDataByRoom2 = function(tMyNetData)
	for i = 1,#tMyNetData.tactics do
		local v = tMyNetData.tactics[i]
		if type(v)=="table" then
			local tabT = hVar.tab_tactics[v[1]]
			if tabT then
				if tabT.level==10 then
					v[2] = 4
				elseif tabT.level==5 then
					v[2] = 2
				elseif tabT.level==3 then
					v[2] = 2
				end
			end
		end
	end
	for i = 1,#tMyNetData.army do
		local v = tMyNetData.army[i]
		if type(v)=="table" then
			if v[1]==hVar.NET_BF_DATA_TYPE.UNIT then
				local nCardID,nCardLv,nCardExp,nCount = unpack(v[4])
				local nUnitID,nUnitNum = hApi.GetArmyCardUnit(nCardID,1,0)
				if nUnitID>0 and nUnitNum>0 then
					nUnitNum = hApi.PVPGetArmyNumByCount(nUnitNum,nCount)
					v[2] = nUnitID
					v[3] = nUnitNum
					tMyNetData.armybounce[i] = hApi.GetArmyCardPlusAttr(nCardID,1)
				else
					tMyNetData.army[i] = 0
				end
			end
		end
	end
end

hApi.ConvertCmdToNetArmyData = function(sCmd)
	if sCmd==nil then
		print("传入了空字符串！")
		return
	end
	local sCmdCheck = string.gsub(sCmd,"\"([^\"]+)\"","\"\"")
	if string.find(sCmdCheck,"%a")~=nil then
		print("发现了非法字符串！",sCmd)
		return
	end
	if hGlobal.NET_DATA.PlayerArmyList==nil then
		print("游戏局尚未开始!")
		return
	end
	local func = loadstring("hGlobal.__tempNetHeroTab="..sCmd)
	if func~=nil and xpcall(func,hGlobal.__TRACKBACK__) then
		local tTemp = hGlobal.__tempNetHeroTab
		hGlobal.__tempNetHeroTab = nil
		if type(tTemp)=="table" then
			local tMyDep = {}
			local tMyNetData = {
				army = hApi.NumTable(hVar.TEAM_UNIT_MAX),
				armybounce = hApi.NumTable(hVar.TEAM_UNIT_MAX),
				tactics = {},
			}
			local tTactics = tTemp[1]
			if type(tTactics)=="table" then
				if #tTactics>hVar.PVP_TACTICS_CARD_LIMIT then
					print("[net cmd]非法的战术卡片数据!",sCmd)
				else
					tMyNetData.tactics = tTactics
					for i = 1,#tTactics do
						if type(tTactics[i])=="table" then
							tMyDep[#tMyDep+1] = "t:"..tTactics[i][1]..":"..tTactics[i][2]..";"
						end
					end
					tMyDep[#tMyDep+1] = "\n"
				end
			end
			local tArmy = tTemp[2]
			if type(tArmy)=="table" then
				for i = 1,#tMyNetData.army do
					tMyNetData.army[i] = 0
					tMyNetData.armybounce[i] = 0
					if type(tArmy[i])=="table" then
						if tArmy[i][1]==hVar.NET_BF_DATA_TYPE.HERO then
							--英雄数据
							local nType,nHeroID,nHeroExp,tHeroEquip = unpack(tArmy[i])
							local tabU = hVar.tab_unit[nHeroID]
							if tabU and tabU.type==hVar.UNIT_TYPE.HERO and type(nHeroExp)=="number" then
								if type(tHeroEquip)~="table" then
									tHeroEquip = {0,0,0,0,0,0,0}
								end
								tMyNetData.army[i] = {nType,nHeroID,nHeroExp,tHeroEquip}
								tMyDep[#tMyDep+1] = "h:"..i..":"..nHeroID..":"..nHeroExp..":"..hApi.GetLevelByExp(nHeroExp)
								hApi.PVPEquip2DepLog(tHeroEquip,tMyDep)
								tMyDep[#tMyDep+1] = ";\n"
							else
								print("[PVP RECV]玩家网络数据异常(英雄)")
							end
						elseif tArmy[i][1]==hVar.NET_BF_DATA_TYPE.ARMYCARD then
							--兵种卡片
							local _,nCardID,nCardLv,nCardExp,nCount = unpack(tArmy[i])
							if nCardID and hVar.tab_army[nCardID] and type(nCardLv)=="number" and type(nCardExp)=="number" then
								local nUnitID,nUnitNum = hApi.GetArmyCardUnit(nCardID,nCardLv,nCardExp)
								if nUnitID>0 and nUnitNum>0 then
									nUnitNum = hApi.PVPGetArmyNumByCount(nUnitNum,nCount)
									tMyNetData.army[i] = {hVar.NET_BF_DATA_TYPE.UNIT,nUnitID,nUnitNum,{nCardID,nCardLv,nCardExp,nCount}}
									tMyNetData.armybounce[i] = hApi.GetArmyCardPlusAttr(nCardID,nCardLv)
									tMyDep[#tMyDep+1] = "u:"..i..":"..nUnitID..":"..nUnitNum..":{"..nCardID..","..nCardLv..","..nCardExp..","..(nCount+1).."};\n"
								else
									print("[PVP RECV]玩家网络数据异常(单位)")
								end
							else
								print("[PVP RECV]玩家网络数据异常(兵种卡)")
							end
						end
					end
				end
			end
			--room2特殊规则
			if g_PVP_NetSaveData.MyRoomID==2 then
				hApi.PVPFormatNetDataByRoom2(tMyNetData)
			end
			if #tMyDep==0 then
				tMyDep[1] = "0"
			end
			return tMyNetData,table.concat(tMyDep)
		end
	end
end
----------------------------
--上传战斗结果
----------------------------
local __PVP__C2LLogKey = {
	"round","star","surrender",
	"dps","dps_over","max_dps","hps","hps_over","max_hps",
	"hero_count","hero_dead_count","army_lost_pec",
	"hp_lost_pec","mp_lost_pec"
}
hApi.PVPC2LSendResult = function(oWorld,nWinnerId)
	local tNetData = oWorld.data.netdata
	if type(tNetData)~="table" then
		_DEBUG_MSG("[PVP] 非pvp战场无法上传结果")
		return
	end
	if nWinnerId==hGlobal.LocalPlayer.data.playerId then
		hApi.PVPSaveCmdLog(oWorld,"win")
	else
		hApi.PVPSaveCmdLog(oWorld,"lose")
	end
	local tSend = {}
	tSend[#tSend+1] = "winner:"..nWinnerId..";"
	for nOwner = 1,#tNetData.PlayerParam do
		local oPlayer = hGlobal.player[nOwner]
		local tData = tNetData.PlayerParam[nOwner]
		tSend[#tSend+1] = "player:"..nOwner..";"
		tSend[#tSend+1] = "roleid:"..tData[hVar.NET_DATA_DEFINE.PLAYER_ROLE_ID]..";"
		local _,tLostUnits,tKillUnits,IsSurrender,roundcount,BattlefieldType,Target,nStar,nScore = hApi.CountKillAndLost(oWorld,oPlayer)
		--需要通过战斗日志统计出 总伤害，总治疗，参战不同等级的兵的个数，死亡的个数， 参战的英雄个数， 死亡的英雄个数
		--统计出 此战斗过程中的总伤害，实际造成的伤害，总治疗，实际造成的治疗
		local dps,dps_over,max_dps,hps,hps_over,max_hps = hApi.CountDPSAndHPS(oWorld,oPlayer)
		local hero_count,hero_dead_count,army_lost_pec = hApi.CountUnitLvLost(oWorld,oPlayer,tLostUnits)
		local hp_lost_pec,mp_lost_pec = hApi.CalcHeroMaxHPAndLastHP(oWorld,oPlayer)
		local temp = {
			roundcount,nStar,IsSurrender,						--回合数，星级，投降
			dps,dps_over,max_dps,hps,hps_over,max_hps,				--总伤害，实际造成的伤害，本局造成的最大伤害，总治疗量，实际造成的治疗，本局造成的最大治疗
			hero_count,hero_dead_count,army_lost_pec,				--英雄数量，死亡英雄数量，_,
			hp_lost_pec,mp_lost_pec,						--_,_,
		}
		for i = 1,#__PVP__C2LLogKey do
			if type(temp[i])=="number" then
				if temp[i]==0 then
					temp[i] = 0
				end
				tSend[#tSend+1] = __PVP__C2LLogKey[i]..":"..temp[i]..";"
			end
		end
		tSend[#tSend+1] = hApi.GetPlayerBFDetail(oWorld,oPlayer)
	end
	g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_GAME_RESULT,1,table.concat(tSend))
end

hApi.PVPC2lSendReplay = function(oWorld,nWinnerId,sReplayType)
	local tNetData = oWorld.data.netdata
	if type(tNetData)~="table" then
		_DEBUG_MSG("[PVP] 非pvp战场无法上传录像")
		return
	end
	local tTittle = {}
	tTittle[#tTittle+1] = "room="..tNetData.roomid..";"
	tTittle[#tTittle+1] = "winner="..nWinnerId..";"
	tTittle[#tTittle+1] = "hero={"..hApi.GetBFHeroID(oWorld,nWinnerId).."};"
	tTittle[#tTittle+1] = "error="..tNetData.error..";"
	tTittle[#tTittle+1] = "round="..oWorld.data.roundcount..";"
	
	--如果是精英挑战，添加其它必要信息
	if sReplayType == "npc_rank_king" then
		local nTag = 1								--标记本地玩家或者被挑战方的战斗信息
		for nOwner = 1,#tNetData.PlayerParam do
			local oPlayer = hGlobal.player[nOwner]				--hGlobal.LocalPlayer	--本地玩家
			local _,tLostUnits,tKillUnits,IsSurrender,roundcount,BattlefieldType,Target,nStar,nScore = hApi.CountKillAndLost(oWorld,oPlayer)
			local hero_count,hero_dead_count,army_lost_pec = hApi.CountUnitLvLost(oWorld,oPlayer,tLostUnits)
			local hp_lost_pec,mp_lost_pec = hApi.CalcHeroMaxHPAndLastHP(oWorld,oPlayer)

			if oPlayer ~= hGlobal.LocalPlayer then
				nTag = 2
			else
				nTag = 1						--如果是本地玩家，战斗信息标记为1
			end

			--上传 英雄损失兵力，军队损失兵力
			tTittle[#tTittle+1] = "hp_lost_pec"..nTag.."="..hp_lost_pec..";"
			tTittle[#tTittle+1] = "army_lost_pec"..nTag.."="..army_lost_pec..";"
		end
	end

	oWorld:c2llog(sReplayType,table.concat(tTittle))
end
----------------------------
--播放录像功能
----------------------------
do
	local __CODE__Cmd2Item = function(str)
		local idx,id
		local ex = {0}
		local r = hApi.Split(str,",")
		if #r>=2 then
			idx = tonumber(r[1])
			id = tonumber(r[2])
			for i = 3,#r do
				if string.find(r[i],":") then
					break
				else
					local n = tonumber(r[i])
					if n then
						ex[1] = ex[1] + 1
						ex[#ex+1] = n
					else
						break
					end
				end
			end
		end
		if idx then
			return idx,hApi.CreateItemObjectByID(id,ex,nil,-1)
		end
	end

	local __CODE__AnalyzeBFRecordByLine = function(sLog,tTemp)
		if tTemp.switch==nil then
			tTemp.randseed = 0
			tTemp.map = 0
			tTemp.switch = 0
			tTemp.param = 0
			tTemp.player = {{},{}}
			tTemp.order = {}
			tTemp.sync = {}
		end
		if type(sLog)~="string" or string.find(sLog,";")==nil then
			return
		end
		if tTemp.switch=="order" then
			--order
			if string.find(sLog,"]proc:") then
				local t = tTemp.order
				--t[#t+1] = sLog
				local _,_,nOperateCount,nPlayerId,sCmd = string.find(sLog,"%[(%d+)%]proc:(%d+):([^;]+);")
				t[#t+1] = {tonumber(nOperateCount),tonumber(nPlayerId),sCmd}
			elseif string.find(sLog,"]sync:") then
				local _,_,nOperateCount,nSync = string.find(sLog,"%[(%d+)%]sync:(%--%d+);")
				tTemp.sync[tonumber(nOperateCount)] = tonumber(nSync)
			end
		else
			if string.sub(sLog,1,1)=="[" then
				tTemp.switch = "order"
			end
			if string.find(sLog,"PLAYER:")==1 then
				local _,_,nOwner,nRoleId,nElo,sPlayerName = string.find(sLog,"PLAYER:(%d+):(%d+):(%d+):{([^}]-)};")
				tTemp.switch = "player"
				tTemp.param = tonumber(nOwner)
				local t = tTemp.player[tTemp.param]
				if t then
					if (sPlayerName or "")=="" then
						sPlayerName = "unknown"
					end
					t.name = tostring(sPlayerName)
					t.elo = tonumber(nElo)
				end
			elseif string.find(sLog,"RAND:")==1 then
				local _,_,nRand = string.find(sLog,"RAND:(%--%d+);")
				tTemp.randseed = tonumber(nRand)
			elseif string.find(sLog,"MAP:")==1 then
				local _,_,nMap = string.find(sLog,"MAP:(%--%d+);")
				tTemp.map = tonumber(nMap)
				return 1
			elseif tTemp.switch=="player" then
				if sLog~=nil and sLog~="" then
					local t = tTemp.player[tTemp.param]
					if t~=nil then
						t[#t+1] = sLog
					end
				end
			end
		end
	end

	local __CODE__InitReplayPlayerParam = function(tTemp,nRoomId)
		local tReplayPlayerParam = {}
		for nPlayerID = 1,2 do
			local v = tTemp.player[nPlayerID]
			local tMyParam = hApi.CreateNetPlayerParam(nPlayerID,0)
			tReplayPlayerParam[nPlayerID] = tMyParam
			tMyParam[hVar.NET_DATA_DEFINE.PLAYER_NAME] = v.name
			tMyParam[hVar.NET_DATA_DEFINE.ELO] = v.elo
			tMyParam.IsReady = 1
			local tMyNetData = tMyParam[hVar.NET_DATA_DEFINE.BF_DATA]
			tMyNetData.army = hApi.NumTable(hVar.TEAM_UNIT_MAX)
			tMyNetData.armybounce = hApi.NumTable(hVar.TEAM_UNIT_MAX)
			tMyNetData.tactics = {}
			for i = 1,#v do
				local str = v[i]
				local s = string.sub(str,1,1)
				if s=="t" then
					for id,lv in string.gfind(str,"t:(%d+):(%d+);")do
						tMyNetData.tactics[#tMyNetData.tactics+1] = {tonumber(id),tonumber(lv)}
					end
				elseif s=="u" then
					local idx,nUnitID,nUnitNum,nCardID,nCardLv,nCardExp,nCount = hApi.GetNumberFromString(str,"u:(%d+):(%d+):(%d+):{(%d+),(%d+),(%d+),(%d+)};")
					tMyNetData.army[idx] = {hVar.NET_BF_DATA_TYPE.UNIT,nUnitID,nUnitNum,{nCardID,nCardLv,nCardExp,nCount-1}}
					tMyNetData.armybounce[idx] = hApi.GetArmyCardPlusAttr(nCardID,nCardLv)
				elseif s=="h" then
					local idx,nHeroId,nHeroExp = hApi.GetNumberFromString(str,"h:(%d+):(%d+):(%d+)")
					--不能观看有禁止英雄的录像
					if g_PVP_NetSaveData.PVPBannedHero[nHeroId]==1 then
						return
					end
					local tHeroEquip = {0,0,0,0,0,0,0}
					tMyNetData.army[idx] = {hVar.NET_BF_DATA_TYPE.HERO,nHeroId,nHeroExp,tHeroEquip}
					for sItem in string.gfind(str,"{([^}]-)}")do
						local idx,oItem = __CODE__Cmd2Item(sItem)
						if idx then
							tHeroEquip[idx] = oItem
						end
					end
				end
			end
			if nRoomId==2 then
				hApi.PVPFormatNetDataByRoom2(tMyNetData)
			end
		end
		return tReplayPlayerParam
	end

	local __CODE__FormatPlayerParam = function(tPlayerParam)
		for nPlayerID = 1,2 do
			local tMyNetData = tPlayerParam[nPlayerID][hVar.NET_DATA_DEFINE.BF_DATA]
			local tMyDep = {}
			local tTactics = tMyNetData.tactics
			for i = 1,#tTactics do
				if type(tTactics[i])=="table" then
					tMyDep[#tMyDep+1] = "t:"..tTactics[i][1]..":"..tTactics[i][2]..";"
				end
			end
			tMyDep[#tMyDep+1] = "\n"
			for i = 1,#tMyNetData.army do
				local v = tMyNetData.army[i]
				if type(v)=="table" then
					if v[1]==hVar.NET_BF_DATA_TYPE.HERO then
						local _,nHeroID,nHeroExp,tHeroEquip = unpack(v)
						tMyDep[#tMyDep+1] = "h:"..i..":"..nHeroID..":"..nHeroExp..":"..hApi.GetLevelByExp(nHeroExp)
						hApi.PVPEquip2DepLog(tHeroEquip,tMyDep)
						tMyDep[#tMyDep+1] = ";\n"
					elseif v[1]==hVar.NET_BF_DATA_TYPE.UNIT then
						local _,nUnitID,nUnitNum,tCardData = unpack(v)
						local nCardID,nCardLv,nCardExp,nCount = unpack(tCardData)
						tMyDep[#tMyDep+1] = "u:"..i..":"..nUnitID..":"..nUnitNum..":{"..nCardID..","..nCardLv..","..nCardExp..","..(nCount+1).."};\n"
					end
				end
			end
			tPlayerParam[nPlayerID][hVar.NET_DATA_DEFINE.DEPLOYMENT_CONV] = table.concat(tMyDep)
		end
	end

	local __CODE__ExitBF = function()
		hGlobal.event:event("LocalEvent_PlayerLeaveBattlefield",hGlobal.LocalPlayer)
		hApi.ClearNetBattlefield()
		hResource.model:releaseCache(hVar.TEMP_HANDLE_TYPE.OBJECT_BF)	--脚本清理战场显存
		hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
	end

	local __CODE__ExitFromReplay = function(self,why,tParam,pExitFunc)
		if why=="exit" then
			__CODE__ExitBF()
			if type(pExitFunc)=="function" then
				pExitFunc(why,tParam)
			end
		elseif why=="rep_sync_error" then
			local nMySum,nRepSum = unpack(tParam)
			hGlobal.UI.MsgBox("Replay Sync Error!\n rep = "..tostring(nRepSum)..",my = "..tostring(nMySum),{
				font = hVar.FONTC,
				ok = function()
					if self.ID~=0 then
						__CODE__ExitBF()
						if type(pExitFunc)=="function" then
							pExitFunc(why,tParam)
						end
					end
				end,
			})
		elseif why=="surrender" then
			self:pause(1,"pause")
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_LeaveBattlefield"].."?",{
				ok = function()
					if self.ID~=0 then
						__CODE__ExitBF()
						if type(pExitFunc)=="function" then
							pExitFunc("exit")
						end
					end
				end,
				cancel = function()
					if self.ID~=0 then
						self:pause(0)
					end
				end,
			})
			return 0
		end
	end

	local __CODE__InitMyParamByDeployment = function(tMyData,tMyArmy,tMyTactics)
		tMyData.army = hApi.NumTable(hVar.TEAM_UNIT_MAX)
		tMyData.armybounce = hApi.NumTable(hVar.TEAM_UNIT_MAX)
		tMyData.tactics = tMyTactics

		for idx = 1,hVar.TEAM_UNIT_MAX do
			local v = tMyArmy[idx]
			if type(v)=="table" then
				if v[1]==hVar.NET_BF_DATA_TYPE.HERO then
					local _,nHeroID,nHeroExp,tHeroEquip = unpack(v)
					tMyData.army[idx] = {hVar.NET_BF_DATA_TYPE.HERO,nHeroID,nHeroExp,tHeroEquip}
				elseif v[1]==hVar.NET_BF_DATA_TYPE.ARMYCARD then
					local _,nCardID,nCardLv,nCardExp,nCount = unpack(v)
					local nUnitID,nUnitNum = hApi.GetArmyCardUnit(nCardID,nCardLv,nCardExp)
					if nUnitID>0 and nUnitNum>0 then
						nUnitNum = hApi.PVPGetArmyNumByCount(nUnitNum,nCount)
						tMyData.army[idx] = {hVar.NET_BF_DATA_TYPE.UNIT,nUnitID,nUnitNum,{nCardID,nCardLv,nCardExp,nCount}}
						tMyData.armybounce[idx] = hApi.GetArmyCardPlusAttr(nCardID,nCardLv)
					end
				end
			end
		end
	end

	hApi.LoadReplay = function(sReplay,pExitFunc)
		local tTemp = {}
		local tLog = hApi.Split(sReplay,"\n")
		if #tLog>0 then
			for i = 1,#tLog do
				__CODE__AnalyzeBFRecordByLine(tLog[i],tTemp)
			end
			local _,_,nRoomId = string.find(sReplay,"room=(%d+);")
			if nRoomId~=nil then
				nRoomId = tonumber(nRoomId)
			end
			local tPlayerParam = __CODE__InitReplayPlayerParam(tTemp,nRoomId)
			if tPlayerParam==nil then
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_PVP_CannotLoadReplay"])
				return hVar.RESULT_FAIL
			end
			local tBFSwitch = {}
			--读取录像中的战场开关
			for i = 1,#hVar.PVP_NET_BF_SWITCH do
				local k = hVar.PVP_NET_BF_SWITCH[i]
				local _,_,nVal = string.find(sReplay,"sw:"..k..":(%--%d+);")
				if nVal then
					tBFSwitch[k] = tonumber(nVal)
				else
					tBFSwitch[k] = g_PVP_NetSaveData.PVPSwitch[k] or 0
				end
			end
			local oWorldBF = hApi.CreateNetBattlefield(0,0,1,tTemp.map,tTemp.randseed,tPlayerParam,tBFSwitch)	--录像
			if oWorldBF~=nil then
				hGlobal.LocalPlayer:focusworld(oWorldBF)
				hGlobal.LocalPlayer:operate(oWorldBF,hVar.OPERATE_TYPE.PLAYER_ROUND_READY)
				oWorldBF.data.IsDrawGrid = 1
				oWorldBF.data.codeOnExit = function(self,why,tParam)
					return __CODE__ExitFromReplay(self,why,tParam,pExitFunc)
				end
				oWorldBF.data.IsReplay = 1
				oWorldBF.data.netdata.replay_sync = tTemp.sync

				local tNetOrder = oWorldBF.data.netdata.netorder
				for i = 1,#tTemp.order do
					tNetOrder[#tNetOrder+1] = tTemp.order[i]
				end
				return hVar.RESULT_SUCESS
			end
		end
		return hVar.RESULT_FAIL
	end

	hApi.StartDuelByReplay = function(sReplay,nGameId,opindex,mode)                                             --mode指定了本战为：挑战前三名（1），还是进行电脑对战练习（0），它们的结算处理不同
		local tTemp = {}
		local tLog = hApi.Split(sReplay,"\n")
		local tMyArmy,tMyTactics = hApi.PVPGetMyDeployment()
		if #tLog>0 and type(tMyArmy)=="table" and type(tMyTactics)=="table" then
			for i = 1,#tLog do
				if __CODE__AnalyzeBFRecordByLine(tLog[i],tTemp)==1 then
					break
				end
			end
			local _,_,nWinner = string.find(sReplay,"winner=(%d+);")
			if nWinner=="1" or nWinner=="2" then
				local nLocalPlayerId
				if opindex~=nil then
					if opindex==1 then
						nLocalPlayerId =2
					else
						nLocalPlayerId = 1
					end
				else
					if nWinner=="1" then
						nLocalPlayerId = 2
					else
						nLocalPlayerId = 1
					end
				end
				local tPlayerParam = __CODE__InitReplayPlayerParam(tTemp,0)
				if tPlayerParam==nil then
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_PVP_CannotVSNpc"])
					return hVar.RESULT_FAIL
				end
				for i = 1,#tPlayerParam do
					local v = tPlayerParam[i]
					if i==nLocalPlayerId then
						v[hVar.NET_DATA_DEFINE.PLAYER_NAME] = tostring(g_curPlayerName)
						v[hVar.NET_DATA_DEFINE.PLAYER_ROLE_ID] = 1
						v[hVar.NET_DATA_DEFINE.ELO] = 0
					else
						v[hVar.NET_DATA_DEFINE.PLAYER_ROLE_ID] = 0
						v[hVar.NET_DATA_DEFINE.ELO] = 0
					end
				end
				__CODE__InitMyParamByDeployment(tPlayerParam[nLocalPlayerId][hVar.NET_DATA_DEFINE.BF_DATA],tMyArmy,tMyTactics)
				__CODE__FormatPlayerParam(tPlayerParam)
				if type(nGameId)~="number" then
					nGameId = 0
				end
				local oWorldBF = hApi.CreateNetBattlefield(nGameId,0,nLocalPlayerId,tTemp.map,hApi.random(1,65535),tPlayerParam,g_PVP_NetSaveData.PVPSwitch)	--打电脑
				if oWorldBF~=nil then
					hGlobal.LocalPlayer:focusworld(oWorldBF)
					hGlobal.LocalPlayer:operate(oWorldBF,hVar.OPERATE_TYPE.PLAYER_ROUND_READY)
					oWorldBF.data.IsDrawGrid = 1
					oWorldBF.data.netdata.IsPVE = 1	
					oWorldBF.data.netdata.IsRank = mode							--0：电脑练习，1：电脑挑战
					local tAIPlayer = {}
					oWorldBF.data.netdata.AIPlayer = tAIPlayer
					for i = 1,2 do
						if nLocalPlayerId~=i then
							tAIPlayer[#tAIPlayer+1] = i
						end
					end
					return hVar.RESULT_SUCESS
				end
			end
		end
		return hVar.RESULT_FAIL
	end

	--将网络上传过来的录像信息添加到玩家信息表 中
	local __CODE__GetPlayerByReplay = function(nReplayId,sReplay,nOwner,nState,vParam)
		local sPlayerIcon = "icon:5000;"
		local _,e,nRoleId,nElo,sPlayerName = string.find(sReplay,"PLAYER:"..nOwner..":(%d+):(%d+):{([^}]-)};")
		if e then
			local _,_,idx,nHeroId = string.find(sReplay,"h:(%d+):(%d+):",e+1)
			if nHeroId then
				sPlayerIcon = "icon:"..nHeroId..";"
			end
		end
		if (sPlayerName or "")=="" then
			sPlayerName = "unknown"
		end
		local tPlayer = hApi.NumTable(hVar.PVP_PLAYER_DATA.EXTRA)
		tPlayer[hVar.PVP_PLAYER_DATA.ID] = 0
		tPlayer[hVar.PVP_PLAYER_DATA.ROLE_ID] = tonumber(nRoleId)	--NPC用这个来记录roleId
		tPlayer[hVar.PVP_PLAYER_DATA.NAME] = sPlayerName
		tPlayer[hVar.PVP_PLAYER_DATA.ELO] = tonumber(nElo)		--NPC用这个来记录roleId
		tPlayer[hVar.PVP_PLAYER_DATA.PARAM] = sPlayerIcon
		tPlayer[hVar.PVP_PLAYER_DATA.STATE] = nState
		tPlayer[hVar.PVP_PLAYER_DATA.HOST] = 0
		tPlayer[hVar.PVP_PLAYER_DATA.GUEST] = 0
		tPlayer[hVar.PVP_PLAYER_DATA.CHANLLENGE] = nReplayId
		tPlayer[hVar.PVP_PLAYER_DATA.TIME] = 0
		if nState==hVar.PVP_PLAYER_STATE.REPLAY then
			tPlayer[hVar.PVP_PLAYER_DATA.LIMIT] = 0		--显示在我后面
		else
			tPlayer[hVar.PVP_PLAYER_DATA.LIMIT] = 1		--这种会显示在最前面
		end
		tPlayer[hVar.PVP_PLAYER_DATA.NPC] = nOwner
		tPlayer[hVar.PVP_PLAYER_DATA.EXTRA] = vParam or 0	--利用附加信息来识别 是精英挑战 还是 普通对战
		return tPlayer
	end


	local __CODE__GetReplayById= function(tReplayList,nReplayId)
		if #tReplayList>0 and (tReplayList.index[nReplayId] or 0)~=0 then
			return tReplayList[tReplayList.index[nReplayId]][2]
		end
	end
	hApi.PVPGetReplayById = function(nState,nReplayId)
		if nState==hVar.PVP_PLAYER_STATE.REPLAY then
			return __CODE__GetReplayById(g_PVP_NetSaveData.L2CReplay,nReplayId)
		elseif nState==hVar.PVP_PLAYER_STATE.NPC then
			return __CODE__GetReplayById(g_PVP_NetSaveData.L2CNpc,nReplayId)
		--补充竞技场季赛冠军数据
		elseif nState==hVar.PVP_PLAYER_STATE.RANK_KING then
			return __CODE__GetReplayById(g_PVP_NetSaveData.RankKing,nReplayId)
		end
	end

	hApi.AddReplayToRoomList = function(nState,tList)
		if nState==hVar.PVP_PLAYER_STATE.REPLAY then
			----添加录像
			local tReplayList = g_PVP_NetSaveData.L2CReplay
			if #tReplayList>0 then
				for i = 1,#tReplayList do
					local v = tReplayList[i]
					local nReplayId = v[1]
					local sReplay = v[2]
					if v[3]~=0 then
						v[3] = 0
						v[4] = __CODE__GetPlayerByReplay(nReplayId,sReplay,1,hVar.PVP_PLAYER_STATE.REPLAY)
						v[5] = __CODE__GetPlayerByReplay(nReplayId,sReplay,2,hVar.PVP_PLAYER_STATE.REPLAY)
					end
					tList[#tList+1] = v[4]
					tList[#tList+1] = v[5]
				end
			end
		elseif nState==hVar.PVP_PLAYER_STATE.NPC then
			----添加npc
			local tReplayList = g_PVP_NetSaveData.L2CNpc
			if #tReplayList>0 then
				for i = 1,#tReplayList do
					local v = tReplayList[i]
					local nReplayId = v[1]
					local sReplay = v[2]
					if v[3]~=0 then
						v[3] = 0
						local _,_,nWinner = string.find(sReplay,"winner=(%d+);")
						if nWinner=="1" then
							v[4] = __CODE__GetPlayerByReplay(nReplayId,sReplay,1,hVar.PVP_PLAYER_STATE.NPC)
						elseif nWinner=="2" then
							v[4] = __CODE__GetPlayerByReplay(nReplayId,sReplay,2,hVar.PVP_PLAYER_STATE.NPC)
						end
					end
					tList[#tList+1] = v[4]
				end
			end
		elseif nState==hVar.PVP_PLAYER_STATE.RANK_KING then
			----添加竞技场冠军
			local tRankKingList = g_PVP_NetSaveData.RankKing
			if #tRankKingList>0 then
				for i = 1,#tRankKingList do
					local v = tRankKingList[i]
					local nReplayId = v[1]
					local sReplay = v[2]
					local nWinner = v[3]
					local nPvpRank = v[4]
					if v[6]~=0 then
						v[6] = 0
						v[5] = __CODE__GetPlayerByReplay(nReplayId,sReplay,nWinner,hVar.PVP_PLAYER_STATE.RANK_KING,{"roomcardrank",nPvpRank})
					end
					tList[#tList+1] = v[5]
				end
			end
		end
	end
end

---------------------------
--加载战场逻辑
if g_PVP_NetSaveData~=nil then
	local _PLG_nMyTimeOut = 0
	local _PLG_tMyUnitData = nil
	local _PLG_nOppTimeOut = 0
	local _PLG_tOppUnitData = nil
	local _PLG_nRoundOprCount = 0
	local _PLG_nSkipOprCount = 0
	local _PLG_tMyOprTime = {opr_count=0,time_used=0,opr_unique_max=0}
	local _code_CheckOppTimeOut = function()
		if _PLG_nOppTimeOut>0 and hApi.gametime()>_PLG_nOppTimeOut then
			if g_NetManager:isConnected() then
				local oWorld = hGlobal.LocalPlayer:getfocusworld()
				if oWorld and oWorld.data.type=="battlefield" and oWorld.data.netdata~=0 then
					if oWorld.data.PausedByWhat=="Victory" or oWorld.data.PausedByWhat=="Defeat" then
						--战场结束就不发了
					else
						--如果成功发送，那么就不清除此timer，等待流程删除
						hApi.PVPSendTimeoutCmd(oWorld,hGlobal.LocalPlayer.data.playerId)
						return
					end
				end
			end
			hApi.clearTimer("__PVP__OppTimeOut")
		end
	end
	local _code_CheckMyTimeOut = function()
		if _PLG_nMyTimeOut>0 and hApi.gametime()>_PLG_nMyTimeOut then
			hApi.clearTimer("__PVP__OppTimeOut")	--自己超时不管怎样都直接删除，因为只有电脑会走到这个流程里
			local oWorld = hGlobal.LocalPlayer:getfocusworld()
			if oWorld and oWorld.data.type=="battlefield" and oWorld.data.netdata~=0 and oWorld.data.netdata.IsPVE==1 then
				local nOppId = 1
				if hGlobal.LocalPlayer.data.playerId==1 then
					nOppId = 2
				end
				hApi.PVPSendTimeoutCmd(oWorld,nOppId)
			end
		end
	end
	---------------------------------------
	--战场开始，重置对决参数
	hGlobal.event:listen("Event_BattlefieldStart","__NBF__ResetSkipOprCount",function(oWorld)
		_PLG_nSkipOprCount = 0
		_PLG_tMyOprTime = {tick=0,opr_count=0,time_used=0,opr_unique_max=0}
	end)
	----------------------------------------
	--成功执行网络命令的时候，清掉超时timer
	hGlobal.event:listen("LocalEvent_NetBattlefieldCmdProc","__NBF__ClearTimeOutTimer",function(oWorld,oPlayer,sCmd)
		local oRound = oWorld:getround()
		if oPlayer~=hGlobal.LocalPlayer and _PLG_nOppTimeOut>0 and (oRound~=nil and _PLG_nRoundOprCount==oRound.data.operatecount) then
			hApi.clearTimer("__PVP__OppTimeOut")
		else
			--重置 _PLG_nSkipOprCount 的逻辑 
			local tempC = {}
			for v in string.gfind(sCmd,"([^%,]+),+") do
				tempC[#tempC+1] = v
			end
			local _,cmdN = unpack(tempC)
			if cmdN ~= "27" then
				_PLG_nSkipOprCount = 0
			end
		end
	end)

	----------------------------------------
	--超时检测
	hGlobal.event:listen("Event_BattlefieldUnitActived","__NBF__AutoTimeOut",function(oWorld,oRound,oUnit)
		if oWorld.data.IsQuickBattlefield~=1 and oWorld.data.typeEX==hVar.BF_WORLD_TYPE_EX.PVP and oWorld.data.IsPaused==0 then
			--if oUnit:getowner()==hGlobal.LocalPlayer then	--每回合自动行动
				--hApi.BF_UnitRunAI(oUnit)
			--end
			_PLG_nRoundOprCount = oRound.data.operatecount
			local tNetData = oWorld.data.netdata
			local tUnitData = oRound:top(1)
			if tUnitData~=_PLG_tMyUnitData then
				_PLG_nMyTimeOut = 0
				_PLG_tMyUnitData = nil
			end
			if tUnitData~=_PLG_tOppUnitData then
				_PLG_nOppTimeOut = 0
				_PLG_tOppUnitData = nil
				hApi.clearTimer("__PVP__OppTimeOut")
			end
			if oUnit:getowner()==hGlobal.LocalPlayer then
				_PLG_nMyTimeOut = hApi.gametime() + tNetData.timeout*1000
				_PLG_tMyUnitData = tUnitData
				hApi.addTimerForever("__PVP__OppTimeOut",hVar.TIMER_MODE.GAMETIME,500,_code_CheckMyTimeOut)
			else
				_PLG_nOppTimeOut = hApi.gametime() + tNetData.timeout*1000
				_PLG_tOppUnitData = tUnitData
				hApi.addTimerForever("__PVP__OppTimeOut",hVar.TIMER_MODE.GAMETIME,500,_code_CheckOppTimeOut)
				--如果是pve战斗的话，AI会自动行动
				--陪练
				if oWorld.data.netdata.IsPVE==1 then
					local nWaitTick = 500
					--local case = hApi.random(1,5)
					--if case<=1 then
						--nWaitTick = hApi.random(3000,10000)
					--elseif case<=3 then
						--nWaitTick = hApi.random(1000,3000)
					--else
						--nWaitTick = hApi.random(1000,1500)
					--end
					hApi.addTimerOnce("__PVP__BFAIMove",nWaitTick,function()
						hApi.BF_UnitRunAI(oUnit)
					end)
				end
			end
		end
	end)

	----------------------------------------
	--对手说我超时了
	hGlobal.event:listen("LocalEvent_NetBattlefieldTimeOut","__NBF__IAmTimeOut",function(oWorld,oPlayer,sCmd)
		if oPlayer~=hGlobal.LocalPlayer and oWorld.data.IsPaused~=1 then
			local oRound = oWorld:getround()
			local self = hGlobal.LocalPlayer
			local IsBUG = 0
			if oWorld.data.actioncount>0 then
				--_DEBUG_MSG("[LOCAL TIMEOUT]回合中的技能尚未结束")
				IsBUG = 1
			elseif oRound~=nil then
				if oRound.data.LockFrameCount>0 then
					--_DEBUG_MSG("[LOCAL TIMEOUT]回合锁定中，需要等待一段时间")
					IsBUG = 2
				else
					local tUnitData = oRound:top(1)
					if tUnitData==nil then
						--_DEBUG_MSG("[LOCAL TIMEOUT]战场中没有单位了亲")
						IsBUG = 3
					elseif self==hGlobal.player[oRound.data.operator] and self.localdata.LastOperateUnique==tUnitData[hVar.ROUND_DEFINE.DATA_INDEX.nUnique] then
						--_DEBUG_MSG("玩家("..oRound.data.operator..")结束了操作")
						if oRound.data.auto~=0 then
							IsBUG = 4
							--_DEBUG_MSG("[LOCAL TIMEOUT]战场自动进行中，不处理跳过回合命令")
						end
					else
						--_DEBUG_MSG("[LOCAL TIMEOUT]目前轮次的操作者不是该玩家，不可发送跳过回合命令",self.localdata.LastOperateUnique,tUnitData[hVar.ROUND_DEFINE.DATA_INDEX.nUnique])
						IsBUG = 5
					end
				end
			end
			if IsBUG==0 then
				if _PLG_nMyTimeOut>0 and hApi.gametime()>=_PLG_nMyTimeOut then
					
					--只对人打人局进行 认输处理
					if oWorld.data.netdata.IsPVE== 0 then
						if _PLG_nSkipOprCount == 2 then
							hUI.floatNumber:new({
								x = hVar.SCREEN.w/2,
								y = hVar.SCREEN.h/2,
								align = "MC",
								text = "",
								lifetime = 1000,
								fadeout = -500,
								moveY = 32,
							}):addtext(hVar.tab_string["text_pvp_player_timeout"].." 3 "..hVar.tab_string["__TEXT_YouCanForgedCount1"],hVar.FONTC,40,"MC",32,0)
							return hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.PLAYER_SURRENDER)
						else
							_PLG_nSkipOprCount = _PLG_nSkipOprCount + 1
							hUI.floatNumber:new({
								x = hVar.SCREEN.w/2,
								y = hVar.SCREEN.h/2,
								align = "MC",
								text = "",
								lifetime = 1000,
								fadeout = -500,
								moveY = 32,
							}):addtext(hVar.tab_string["text_pvp_player_timeout"].." ".._PLG_nSkipOprCount.." "..hVar.tab_string["__TEXT_YouCanForgedCount1"],hVar.FONTC,40,"MC",32,0)
						end
					end
					local temp = _PLG_tMyUnitData
					_PLG_nMyTimeOut = 0
					_PLG_tMyUnitData = nil
					local oUnit
					if oRound~=nil then
						oUnit = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.oUnit)
					end
					if hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.PLAYER_SKIP_UNIT_OPERATE,oUnit)~=hVar.RESULT_SUCESS then
						_PLG_nMyTimeOut = 1
						_PLG_tMyUnitData = temp
					end
				end
			else
				--_DEBUG_MSG("[LOCAL TIMEOUT]我知道，但是骚等,bug="..IsBUG)
			end
		end
	end)

	--------------------------------------------
	--房间超时，耗时较多的一方自动认输
	local _plg_TimeOutUnique = 0
	local _code_PVPRoomAutoExit = function()
		local oWorld = hGlobal.NetBattlefield
		if oWorld and type(oWorld.data.netdata)=="table" and oWorld.data.netdata.IsTimeOut==1 and not(oWorld.data.PausedByWhat=="Victory" or oWorld.data.PausedByWhat=="Defeat") then
			local tNetData = oWorld.data.netdata
			local oRound = oWorld:getround()
			if oRound and oRound.data.auto==0 then
				local oUnit = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.oUnit)
				local nUnique = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.nUnique)
				if nUnique==hGlobal.LocalPlayer.localdata.LastOperateUnique and _plg_TimeOutUnique~=nUnique then
					--如果本地玩家可以操控该单位，并且战场已经超时，判断双方平均操作延时，平均耗时较长的一方立刻发送投降命令
					local sMyLog = ""
					local sOppLog = ""
					local nMyAverage = -1
					local nOppAverage = -1
					local nMyAverageEx = -1
					local nOppAverageEx = -1
					for id,data in pairs(tNetData.TimeOutParam)do
						if id==hGlobal.LocalPlayer.data.playerId then
							local o,t,ox,tx = unpack(data)
							nMyAverage = math.floor(t/math.max(1,o))
							nMyAverageEx = math.floor(tx/math.max(1,ox))
							sMyLog = "my:("..o..","..t..")"..nMyAverage..";myex("..ox..","..tx..")"..nMyAverageEx..";"
						else
							local o,t,ox,tx = unpack(data)
							nOppAverage = math.max(nOppAverage,math.floor(t/math.max(1,o)))
							nOppAverageEx = math.max(nOppAverageEx,math.floor(tx/math.max(1,ox)))
							sOppLog = "opp:("..o..","..t..")"..nOppAverage..";oppex("..ox..","..tx..")"..nOppAverageEx..";"
						end
					end
					if nMyAverage>=0 and nOppAverage>=0 then
						_plg_TimeOutUnique = nUnique
						local nIsLost = 0
						if math.abs(nMyAverage-nOppAverage)<=5000 then
							--如果双方操作耗时差异在5秒以内，那么按照最后20次操作的平均耗时判定胜负
							if nMyAverageEx>nOppAverageEx then
								nIsLost = 1
							end
						elseif nMyAverage>nOppAverage then
							--差异大于5秒的话，用时较长的一方判负
							nIsLost = 1
						end
						if nIsLost==1 then
							hApi.PVPSaveCmdLog(oWorld,"@TIMEOUT_SURRENDER@"..sMyLog..sOppLog)	--这种局必然会发cmd log!
							hApi.PVPSendCmdLog(tNetData.gameid,1)	--这次传上去的log，不属于掉线
							hGlobal.LocalPlayer:order(oWorld,hVar.OPERATE_TYPE.PLAYER_SURRENDER)
						end
					end
				end
			end
		else
			hApi.clearTimer("__PVP__PVPRoomAutoExit")
		end
	end

	-----------------------------------------
	--单位激活时，设置开始操作的最后时间
	hGlobal.event:listen("Event_BattlefieldUnitActived","__BF__HelpHint_ShowSkillFrame",function(oWorld,oRound,oUnit)
		_PLG_tMyOprTime.tick = hApi.gametime()
		local tNetData = oWorld.data.netdata
		if type(tNetData)=="table" and tNetData.IsTimeOut==1 then
			_code_PVPRoomAutoExit()
		end
	end)

	----------------------------------------
	--房间超时警告
	hGlobal.event:listen("LocalEvent_PVPRoomTimeOutWarning","__UploadMyOprAverageTime",function()
		local oWorld = hGlobal.NetBattlefield
		if oWorld and type(oWorld.data.netdata)=="table" and not(oWorld.data.PausedByWhat=="Victory" or oWorld.data.PausedByWhat=="Defeat") then
			--设置该战场为超时状态
			oWorld.data.netdata.IsTimeOut = 1	--设置这个值以后，战场就会持续检测是否超时
			local nOprCountEx = 0
			local nOprTimeEx = 0
			--统计我最后20次操作的耗时，作为平均耗时参考2(如果双方的操作平均耗时差异小于5秒，那么以这个为参考)
			for i = _PLG_tMyOprTime.opr_unique_max,1,-1 do
				local nTimeUsed = _PLG_tMyOprTime[i]
				if nTimeUsed~=nil then
					nOprCountEx = nOprCountEx + 1
					nOprTimeEx = nOprTimeEx + nTimeUsed
				end
				if nOprCountEx>=20 then
					break
				end
			end
			--发送我的操作耗时
			local sCmd = "o:".._PLG_tMyOprTime.opr_count..";t:".._PLG_tMyOprTime.time_used..";ox:"..nOprCountEx..";tx:"..nOprTimeEx..";"
			hApi.PVPSendPlayerCmd(hGlobal.LocalPlayer,oWorld,"@OPR_TIME_USED@"..sCmd)
			--重置房间超时
			_plg_TimeOutUnique = 0
			--启动自动投降计时器
			hApi.addTimerForever("__PVP__PVPRoomAutoExit",hVar.TIMER_MODE.GAMETIME,500,_code_PVPRoomAutoExit)
			--显示提示框
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_NetBattlefieldTimeOut"])
		end
	end)

	----------------------------------------
	--发送操作时，记录自己平均操作耗时
	hApi.NBFGetPlayerOrderTimeUsed = function(nOperateCount,nOrder,vOrderId,sCmd)
		local nMyTimeUsed = hApi.gametime() - _PLG_tMyOprTime.tick
		if nMyTimeUsed<=15000 and nOrder==hVar.OPERATE_TYPE.UNIT_WAIT then
			--15秒内的等待命令不参与统计(避免玩家用这个来降低自己的平均操作耗时)
		elseif _PLG_tMyOprTime[nOperateCount]==nil then
			_PLG_tMyOprTime[nOperateCount] = nMyTimeUsed
			_PLG_tMyOprTime.opr_unique_max = math.max(_PLG_tMyOprTime.opr_unique_max,nOperateCount)
			_PLG_tMyOprTime.opr_count = _PLG_tMyOprTime.opr_count + 1
			_PLG_tMyOprTime.time_used = _PLG_tMyOprTime.time_used + nMyTimeUsed
		end
		return nMyTimeUsed
	end
	----------------------------------------
	--别人要求和我战斗
	hGlobal.event:listen("LocalEvent_PVPChallangeRequire","__AutoRequire",function(iChallenge,iPlayerID)
		local sHint = "[server] Being challenged challengeID:"..iChallenge.." playerId:"..iPlayerID
		g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_BEING_CHALLANGED_RET, iPlayerID)
	end)

	local _code_PVPExitFromBF = function(nReason,nMustGo)
		local oWorld = hGlobal.NetBattlefield
		if oWorld then
			local tNetData = oWorld.data.netdata
			if type(tNetData)~="table" then
				tNetData = {}
			end
			if nMustGo==1 or oWorld.data.IsPaused~=1 then
				local nPlayerV
				--对手掉线
				if nReason==hVar.PVP_CHANLLENGE_CHANGE_REASON.OFFLINE then
					--对手离开房间，视作我方胜利
					nPlayerV = hGlobal.LocalPlayer.data.playerId
					tNetData.error = 1
					tNetData.netlog[#tNetData.netlog] = "@OPPONENT_DRPOED@"
				else
					--意外结束流程
					local tPlayerDefeat = {}
					for nOwner,nUnitNum in pairs(oWorld.data.unitcount)do
						if nOwner~=hGlobal.LocalPlayer.data.playerId and type(nOwner)=="number" and type(nUnitNum)=="number" and hGlobal.player[nOwner] then
							nPlayerV = nOwner
							break
						end
					end
				end
				if nPlayerV then
					local oRound = oWorld:getround()
					local pVictoryFunc = hApi.GetVictoryFuncBF(oWorld,nPlayerV,hVar.PVP_CHANLLENGE_CHANGE_REASON.OFFLINE)
					if oRound and oRound.data.auto==1 then
						oRound.data.codeOnRoundEnd = pVictoryFunc
					else
						hpcall(pVictoryFunc)
					end
				end
			end
			return hVar.RESULT_SUCESS
		else
			return hVar.RESULT_FAIL
		end
	end

	hGlobal.event:listen("LocalEvent_PVPRoomStateChanged","__PVP__Logic",function(nChallenge,nState,nReason,nMyRoomID)
		if nState==hVar.PVP_CHANLLENGE_STATE.INIT then
			--等待对方回应状态
		elseif nState==hVar.PVP_CHANLLENGE_STATE.WAITING then
			--奇怪的等待状态,这个是是干啥的？
			g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_READY_GAME)
		elseif nState==hVar.PVP_CHANLLENGE_STATE.ACTIVE then
			--对决正式开始
			g_PVP_NetSaveData.MyVSCount = g_PVP_NetSaveData.MyVSCount + 1
			g_PVP_NetSaveData.MyVSGameID = g_PVP_NetSaveData.MyVSCount
		elseif nState==hVar.PVP_CHANLLENGE_STATE.COMPLETE then
			--战斗结算流程
		elseif nState==hVar.PVP_CHANLLENGE_STATE.EXCEPTION then
			--首先尝试结算当前战场
			if _code_PVPExitFromBF(nReason,0)~=hVar.RESULT_SUCESS then
				g_PVP_NetSaveData.MyVSGameID = 0
				--如果失败那么弹个对话框，可能这时候还没进战场，进战场以后可以点掉
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_PVP_OpponentDropped"],{
					font = hVar.FONTC,
					ok = function()
						if _code_PVPExitFromBF(nReason,1)~=hVar.RESULT_SUCESS then
							--如果这时候还连着服务器，那么显示pvp界面
							if g_NetManager:isConnected() then
								hGlobal.event:event("LocalEvent_PVPMap",1)
							end
						end
					end,
				})
			end
		elseif nState==hVar.PVP_CHANLLENGE_STATE.END then
			--战场结束了
		end
	end)

	---------------------------------------
	--连接成功，请求网络存档
	hGlobal.event:listen("LocalEvent_PVPLoginState","__NB___PVPRequireData",function(nState)
		if nState==1 then
			--g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2LY_PLAYER_LIST)
			--清除自己的所有卡片
			--g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_PLAYER_NET_SAVE_UPDATE,hVar.NET_SAVE_OPR_TYPE.C2L_CLEAR_ALL_ARMY_CARD,0,"0")
			--请求自己的卡片
			g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_PLAYER_NET_SAVE_UPDATE,hVar.NET_SAVE_OPR_TYPE.C2L_UPDATE_ALL_ARMY_CARD,0,"0")
			hApi.PVPLoadPlayerDeployment()
			g_PVP_NetSaveData.PVPCooldown = {}
			local tTemp = {}
			hApi.GetParamByCmd("cd:",g_PVP_NetSaveData.activity,tTemp)
			for i = 1,#tTemp do
				local v = tTemp[i]
				local id = tonumber(v[1])
				if hVar.tab_unit[id] then
					local tCool = {}
					g_PVP_NetSaveData.PVPCooldown[id] = tCool
					for n = 1,math.floor((#v-1)/2),1 do
						tCool[#tCool+1] = {tonumber(v[n*2]),tonumber(v[n*2+1])}
					end
				end
			end
		else
			g_PVP_NetSaveData.NetSaveData = ""
			g_PVP_NetSaveData.PVPCooldown = {}
			hApi.PVPUpdateAllNetData()
		end
	end)

	-----------------------------------------
	--PVP特殊规则 zhenkira delete 2016.7.12
	--hGlobal.event:listen("Event_UnitBorn","__NetBattlefieldEliteDef",function(oUnit)
	--	local oWorld = oUnit:getworld()
	--	if oWorld.data.type=="battlefield" and oWorld.data.typeEX==hVar.BF_WORLD_TYPE_EX.PVP then
	--		oUnit.data.IsPVP = 1
	--		if oUnit.attr.heroic==1 then
	--			--网络战场内英雄获得25%的精英减伤
	--			oUnit.attr.eliteDef = oUnit.attr.eliteDef + 25
	--			oUnit:setbuffhint(40,1,0,{25})
	--			local nPec = oWorld.data.netdata.switch.hero_rd1
	--			if type(nPec)=="number" and nPec>0 then
	--				--英雄首回合减免一定数额的圣兽，法师和圣兽伤害(服务器控制)
	--				oUnit:setpowerex("from",{"SHOOTER","WIZARD","LEGEND"},-1*nPec,1)
	--				oUnit:setbuffhint(7502,1,1,{nPec})
	--			end
	--		else
	--			local nPec = oWorld.data.netdata.switch.unit_rd1
	--			if type(nPec)=="number" and nPec>0 then
	--				--普通单位减免一定数额的圣兽，法师和圣兽伤害(服务器控制)
	--				oUnit:setpowerex("from",{"SHOOTER","WIZARD","LEGEND"},-1*nPec,1)
	--				oUnit:setbuffhint(7502,1,1,{nPec})
	--			end
	--			local nTog = oWorld.data.netdata.switch.unit_toughness
	--			if type(nTog)=="number" and nPec>0 then
	--				--普通单位获得一定数量的韧性(服务器控制)
	--				oUnit.attr.toughness = oUnit.attr.toughness + nTog
	--				oUnit:setbuffhint(7503,1,0,{nTog})
	--			end
	--		end
	--		--部分英雄技能拥有初始冷却
	--		local tPVPCooldown = g_PVP_NetSaveData.PVPCooldown[oUnit.data.id]
	--		if tPVPCooldown then
	--			for i = 1,#tPVPCooldown do
	--				local id,cd = unpack(tPVPCooldown[i])
	--				local tSK = oUnit:getskill(id)
	--				if tSK then
	--					tSK[3] = tSK[3] + cd
	--					oUnit:setbuffhint(7501,1,cd,{id,cd})
	--				end
	--			end
	--		end
	--	end
	--end)

	-----------------------------------------
	--功能函数
	-----------------------------------------
	hApi.NBFWorldUnitLog = function(oWorld)
		local tAttr = {}
		local nCount = 0
		oWorld:enumunit(function(u)
			nCount = nCount + 1
			local d = u.data
			local s = "unit"..d.id.."("..nCount..")["
			for i = 1,#hVar.NB_UNIT_ATTR_SYNC_KEY do
				local k = hVar.NB_UNIT_ATTR_SYNC_KEY[i]
				if type(u.attr[k])=="number" then
					s = s..k.."="..u.attr[k]..","
				end
			end
			s = s.."] \n"
			tAttr[#tAttr+1] = s
		end)
		local f = io.open("BFAttr.log","w")
		if f then
			for i = 1,#tAttr do
				f:write(tAttr[i])
			end
			f:close()
		end
		local tLog = hApi.SaveTable(oWorld.__LOG)
		local f = io.open("BFLog.log","w")
		if f then
			for i = 1,#tLog do
				f:write(tLog[i])
			end
			f:close()
		end
	end

	-----------------------------------------
	--特别GAME cmd的处理
	-----------------------------------------
	--超时命令
	hGlobal.PVP_NET_CMD_FUNC["@TIMEOUT@"] = function(oWorld,oPlayer,nPlayerId,sCmd)
		return hGlobal.event:event("LocalEvent_NetBattlefieldTimeOut",oWorld,oPlayer,sCmd)
	end

	--特殊的不同步命令，要求上传log，并且退出战场
	hGlobal.PVP_NET_CMD_FUNC["@ORDER_ERROR@"] = function(oWorld,oPlayer,nPlayerId,sCmd)
		if oWorld:c2llog("sync_error","@ORDER_ERROR@")==hVar.RESULT_SUCESS then
			g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_GAME_RESULT,2,"error")
			hApi.EnterWorld()
			hGlobal.O:replace("NBFTimeOutErrMsgBox",nil)
		end
	end

	--玩家准备就绪
	hGlobal.PVP_NET_CMD_FUNC["@READY@"] = function(oWorld,oPlayer,nPlayerId,sCmd)
		print("player "..nPlayerId.." is ready")
		local tPlayerParam = oWorld.data.netdata.PlayerParam
		for i = 1,#tPlayerParam do
			if tPlayerParam[i][hVar.NET_DATA_DEFINE.IS_READY]==-1 then
				--战斗已开始，不做处理了
				print("已经开始了你在逗我")
				return
			end
		end
		for i = 1,#tPlayerParam do
			if tPlayerParam[i][hVar.NET_DATA_DEFINE.PLAYER_ID]==nPlayerId then
				tPlayerParam[i][hVar.NET_DATA_DEFINE.IS_READY] = 1
				break
			end
		end
		local IsAllPlayerReady = 1
		for i = 1,#tPlayerParam do
			if tPlayerParam[i][hVar.NET_DATA_DEFINE.IS_READY]~=1 then
				IsAllPlayerReady = 0
				break
			end
		end
		if IsAllPlayerReady==1 then
			for i = 1,#tPlayerParam do
				tPlayerParam[i][hVar.NET_DATA_DEFINE.IS_READY] = -1
			end
			print("all player ready,vs start...")
			return hGlobal.LocalPlayer:operate(oWorld,hVar.OPERATE_TYPE.PLAYER_ROUND_READY)
		end
	end

	--收到同步验证消息(支持函数)
	local _code_GetPlayerData = function(tPlayerData,nPlayerId,IsEqual)
		for i = 1,#tPlayerData do
			if IsEqual==1 then
				if tPlayerData[i][hVar.NET_DATA_DEFINE.PLAYER_ID]==nPlayerId then
					return tPlayerData[i]
				end
			else
				if tPlayerData[i][hVar.NET_DATA_DEFINE.PLAYER_ID]~=nPlayerId then
					return tPlayerData[i]
				end
			end
		end
	end
	--收到同步验证消息
	hGlobal.PVP_NET_CMD_FUNC["@SYNC_SUM@"] = function(oWorld,oPlayer,nPlayerId,sCmd)
		local tNetData = oWorld.data.netdata
		local tPlayerParam = tNetData.PlayerParam
		local _,_,nOprCount,nSum = string.find(sCmd,"@SYNC_SUM@%[(%d+)%](%--%d+)")
		local tMyData = _code_GetPlayerData(tPlayerParam,nPlayerId,1)
		local tOppData = _code_GetPlayerData(tPlayerParam,nPlayerId,2)
		--print("sCmd=",sCmd,tMyData,tOppData,nOprCount,nSum)
		if nOprCount~=nil and nSum~=nil and tMyData~=nil and tOppData~=nil then
			nOprCount = tonumber(nOprCount)
			nSum = tonumber(nSum)
			local tMySync = tMyData[hVar.NET_DATA_DEFINE.SYNC_SUM]
			local tOppSync = tOppData[hVar.NET_DATA_DEFINE.SYNC_SUM]
			local tSync = tMyData[hVar.NET_DATA_DEFINE.SYNC_SUM]
			if nOprCount~=#tMySync+1 then
				for i = 1,nOprCount do
					if tMySync[i]==nil then
						tMySync[i] = 0
					end
				end
			end
			tMySync[nOprCount] = nSum
			local SyncError = 0
			if oWorld.data.netdata.IsPVE==1 then
				--pve战斗无需同步
				tOppSync[nOprCount] = nSum
			else
				for i = 1,math.max(#tOppData,#tMyData)do
					if tMySync[i] and tOppSync[i] and tMySync[i]~=tOppSync[i] then
						SyncError = i
						break
					end
				end
			end
			if SyncError==0 then
				--一切正常，并且双方的同步验证已经收到
				local oRound = oWorld:getround()
				if oRound and (tMySync[oRound.data.operatecount] or 0)~=0 and (tOppSync[oRound.data.operatecount] or 0)~=0 then
					local oUnit = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.oUnit)
					if oUnit and oUnit.data.id~="round" then
						return hGlobal.event:event("Event_BattlefieldUnitActived",oWorld,oRound,oUnit)
					end
				end
			else
				--发生不同步
				oWorld:pause(1,"Victory")
				tNetData.error = 2
				if hGlobal.LocalPlayer.data.playerId==1 then
					--上传不同步录像
					tNetData.netlog[#tNetData.netlog] = "@SYNC_ERROR@:my="..tostring(tMySync[nOprCount])..",opp="..tostring(tOppSync[nOprCount])..","
					hApi.PVPC2lSendReplay(oWorld,1,"sync_error")
				end
				local oRound = oWorld:getround()
				--hApi.NBFWorldUnitLog(oWorld)
				local sTip = hVar.tab_string["ios_err_sync"].." \n["..tMyData[hVar.NET_DATA_DEFINE.PLAYER_ID]..":"..tostring(tMySync[SyncError]).."] \n["..tOppData[hVar.NET_DATA_DEFINE.PLAYER_ID].."="..tostring(tOppSync[SyncError]).."]\nRandCount="..oWorld.data.netdata.randomcount.."\nRandValue="..oWorld.data.netdata.randomvalue
				local _frm = hGlobal.UI.MsgBox(sTip,{
					font = hVar.FONTC,
					ok = function()
						hGlobal.event:event("LocalEvent_PlayerLeaveBattlefield",hGlobal.LocalPlayer)
						hApi.ClearNetBattlefield()
						hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
						if g_NetManager:isConnected() then
							g_NetManager:disconnectFromGameServer()
							hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
							hGlobal.event:event("LocalEvent_ShowMapAllUI",true)
						end
					end,
				})
			end
		end
	end

	--收到操作耗时指令
	hGlobal.PVP_NET_CMD_FUNC["@OPR_TIME_USED@"] = function(oWorld,oPlayer,nPlayerId,sCmd)
		local tNetData = oWorld.data.netdata
		local nOprCount,nTimeUsed,nOprCountEx,nTimeUsedEx = hApi.GetNumberFromString(sCmd,"o:(%d+);t:(%d+);ox:(%d+);tx:(%d+);")
		if nOprCount and type(tNetData)=="table" and oPlayer~=nil then
			tNetData.TimeOutParam[oPlayer.data.playerId] = {nOprCount,nTimeUsed,nOprCountEx,nTimeUsedEx}
		end
	end

	---------------------------------------
	--初始化基本数据
	g_PVP_NetSaveData.NetSaveData = ""
	hApi.PVPUpdateAllNetData()
	---------------------------------------
end