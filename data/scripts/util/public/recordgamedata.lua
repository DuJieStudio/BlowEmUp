--------------------------------------------------------------------
--字符串和table的互相转换
--------------------------------------------------------------------

--字符串转table
hApi.StringToTable = function(str)
	local tTable = {}
	if type(str) == "string" then
		local sFunc = "function GetTableFromString() return " .. str .. " end"
		local f = loadstring(sFunc)
		if type(f) == "function" then
			f()
		end
		local tTemp = GetTableFromString()
		if type(tTemp) == "table" then
			tTable = tTemp
		end
		GetTableFromString = hApi.DoNothing
	end
	return tTable
end

--table转字符串
function hApi.TableToString(t)
	if "table" == type(t) then
		local sString = "{"
		for k,v in pairs(t) do
			if "number" == type(k) then
				sString = sString .. "[" .. tonumber(k) .. "]="
			else
				sString = sString .. tostring(k) .. "="
			end
    
			if "number" == type(v) then
				sString = sString .. tostring(v) .. ","
			elseif "string" == type(v) then
				sString = sString .. "\"" .. tostring(v) .. "\","
			elseif "table" == type(v) then
				sString = sString .. hApi.TableToString(v) .. ","
			end
		end
		return sString .. "}"
	else
		return "nil"
	end
end

--table转字符串(简化)
function hApi.TableToSimplifyString(t)
	if "table" == type(t) then
		local sString = "{"
		local num = #t
		--优先把顺序列表转换  减少key的无意义占比
		for i=1,num do
			local v = t[i]
			if "number" == type(v) then
				sString = sString .. tostring(v) .. ","
			elseif "string" == type(v) then
				sString = sString .. "\"" .. tostring(v) .. "\","
			elseif "table" == type(v) then
				sString = sString .. hApi.TableToSimplifyString(v) .. ","
			end
		end
		for k,v in pairs(t) do
			--剔除已转换的字符
			if "number" == type(k) and k <= num then
				--已转换
			else
				if "number" == type(k) then
					sString = sString .. "[" .. tonumber(k) .. "]="
				else
					sString = sString .. tostring(k) .. "="
				end
	    
				if "number" == type(v) then
					sString = sString .. tostring(v) .. ","
				elseif "string" == type(v) then
					sString = sString .. "\"" .. tostring(v) .. "\","
				elseif "table" == type(v) then
					sString = sString .. hApi.TableToSimplifyString(v) .. ","
				end
			end
		end
		return sString .. "}"
	else
		return "nil"
	end
end

function hApi.json2table(json)
	local t = {}
	for k,v in string.gmatch(json,'(%"%w+%"):(%"*%w+%"*)') do
		local kk = string.match(k,"%w+")
		local vv = string.match(v,"%w+")
		if(vv == v) then 
			t[kk] = tonumber(vv)
		else
			t[kk] = vv
		end
	end
	return t
end

---------------------------------------------------------------------------------------------
local _safeAddScoreWay = nil

--记录积分来源
local _Code_RecordScoreSource = function(nScore,nWay)
	local diablodata = hGlobal.LocalPlayer.data.diablodata --大菠萝数据
	if diablodata and type(diablodata.randMap) == "table" then	--记录游戏内的数据
		if nWay == hVar.GET_SCORE_WAY.ADS then	--广告
			--游戏内
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.MAPPURCHASESCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.PURCHASE then	--充值
			--游戏内
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.MAPPURCHASESCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.CK then	--连斩
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.CKSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.CLEARSTAGE then	--单关卡奖励
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.MAPGETSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.GAMESETTLEMENT then	--游戏结算
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.SETTLEMENTSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.UPGRADETACTICS then	--升级天赋
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.MAPCOSTSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.PETADHP then		--宠物加血
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.MAPCOSTSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.REVIVE then	--复活
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.MAPCOSTSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.DAILYREWARD then	--补给箱
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.BASEDAILYSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.ACHIEVEMENTSCORE then	--成就
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.ACHIEVEMENTSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.SYSTEMREWARD then
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.SYSTEMREWARDSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.GMCHEAT then
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.GMCHEAT,nScore)
		else
			--未知来源 以便统计
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.UNKOWN,nScore)
		end
	else	--记录游戏外的数据
		if nWay == hVar.GET_SCORE_WAY.ADS then	--广告
			--游戏外
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.BASEPURCHASESCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.PURCHASE then	--充值
			--游戏外
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.BASEPURCHASESCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.UNLOCKWEAPON then	--解锁武器
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.BASECOSTSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.UPGRADEITEMTACTICS then	--升级道具天赋
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.BASECOSTSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.UPGRADEPET then		--升级宠物
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.BASECOSTSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.GMCHEAT then
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.GMCHEAT,nScore)
		else
			--未知来源
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.UNKOWN,nScore)
		end
	end
end

local _lastRecordScore = ""

--检查积分作弊
local _Code_CheckScoreCheat = function()
	if _lastRecordScore == nil or _lastRecordScore == "" then
		return
	end
	local nCurScore = LuaGetPlayerScore()
	local nLastScore = tonumber(_lastRecordScore)
	print(nCurScore,nLastScore)
	if nCurScore - nLastScore > 5000 then
		local str = "Score Anomaly:".." last:"..nLastScore.." new:"..nCurScore
		LuaAddCheatLog(hVar.CHEATTYPE.SCORECHEAT,str)
	end
end

--检查积分来源作弊
local _Code_CheckScoreSourceCheat = function(nScore,nWay)
	local sLimit = hVar.ScoreSourceLimit[nWay]
	if type(sLimit) == "string" then
		local nLimit = tonumber(sLimit)
		if nScore > nLimit then
			local str = "ScoreSource Anomaly:".." way:"..nWay.." score:"..nScore.." limit:"..nLimit
			print("str",str)
			LuaAddCheatLog(hVar.CHEATTYPE.SCORECHEAT,str)
		end
	end
end

--在原有函数基础上添加数据统计以及来源检查
LuaAddPlayerScoreByWay = function(nScore,nWay,notSaveFlag)
	if type(nScore) ~= "number" then
		return
	end
	_Code_CheckScoreCheat()
	if type(_safeAddScoreWay) ~= "table" then
		_safeAddScoreWay = {}
		for way,value in pairs(hVar.GET_SCORE_WAY) do
			_safeAddScoreWay[value] = 1
		end
	end
	--table_print(_safeAddScoreWay)
	if nWay == hVar.GET_SCORE_WAY.SRC or nWay == nil then
		--非源代码模式下不得通关此方法
		if g_lua_src ~= 1 then
			return
		end
	elseif _safeAddScoreWay[nWay] == 1 then
		--小于此值 为添加积分
		if nWay < hVar.GET_SCORE_WAY.DIVIDINGLINE then
			if nScore < 0 then
				print("function:LuaAddPlayerScoreByWay param:nWay Error",tostring(nWay))
				return
			end
		--大于此值 为消耗积分
		elseif nWay > hVar.GET_SCORE_WAY.DIVIDINGLINE then
			if nScore > 0 then
				print("function:LuaAddPlayerScoreByWay param:nWay Error",tostring(nWay))
				return
			end
		--分割线本身不属于有效方法
		else
			return
		end
		--记录积分来源
		_Code_RecordScoreSource(math.abs(nScore),nWay)
	elseif nScore < 0 then
		--未知扣除方式 但是依然给扣
		print("function:LuaAddPlayerScoreByWay param:nWay Unknown",tostring(nWay))
	else
		--非有效方法 不增加积分
		return
	end
	--检查金币来源作弊
	_Code_CheckScoreSourceCheat(nScore,nWay)
	--记录积分来源
	LuaRecordScoreSource(math.abs(nScore),nWay)
	--添加玩家积分
	LuaAddPlayerScore(nScore,notSaveFlag)
	--记录积分
	_lastRecordScore = tostring(LuaGetPlayerScore())
end

LuaUploadPlayerScoreInfo = function()
	if Save_PlayerLog then
		if type(Save_PlayerLog.scoresource) == "table" then
			local strScoreInfo = hApi.TableToString(Save_PlayerLog.scoresource)
			SendCmdFunc["upload_score_info"](strScoreInfo)
		end
	end
end

--上传玩家游戏log
LuaUploadPlayerGameLog = function()
	if Save_PlayerLog then
		if type(Save_PlayerLog.gamelog) == "table" then
			for id,tab in pairs(Save_PlayerLog.gamelog) do
				if type(id) == "number" then
					if (tab.upload or 0 ) == 0 then
						local str = hApi.TableToSimplifyString(tab)
						SendCmdFunc["upload_stage_log"](id, tab.protrol, str)
					end
				end
			end
		end
	end
end

local protrol = 0
--统计玩家游戏log
LuaRecordPlayerGameLog = function()
	if Save_PlayerLog then
		if type(Save_PlayerLog.gamelog) ~= "table" or Save_PlayerLog.gamelog.curIndex == nil then
			Save_PlayerLog.gamelog = {}
		end

		--检查积分是否正常 (与上一次游戏log中积分相比较)
		--看需求
		
		--检查是否需要上传数据
		LuaUploadPlayerGameLog()
		
		local gamelog = Save_PlayerLog.gamelog
		local nIndex = (gamelog.curIndex or table.maxn(Save_PlayerLog.gamelog)) + 1
		gamelog.curIndex = nIndex
		gamelog[nIndex] = {}
		gamelog[nIndex].upload = 0
		gamelog[nIndex].protrol = protrol
		--初始开局积分
		LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.INITIALSCORE,LuaGetPlayerScore())
		--开局时间 (日_分_秒 8位)
		local curtime = os.time()
		local timeStr = os.date("%m_%d_%H_%M",curtime)
		LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.INITIALTIME,timeStr)
		
		--保存
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

--添加玩家游戏log
LuaAddPlayerGameLog = function(nType,data)
	if Save_PlayerLog then
		local nIndex = 0
		if type(Save_PlayerLog.gamelog) ~= "table" or Save_PlayerLog.gamelog.curIndex == nil then
			--初始化
			LuaRecordPlayerGameLog()
		else
			nIndex = table.maxn(Save_PlayerLog.gamelog)
			if nIndex == 0 then
				--表为空
				LuaRecordPlayerGameLog()
			else
				--版本更新
				local nProtrol = Save_PlayerLog.gamelog[nIndex].protrol or 0
				if nProtrol ~= protrol then
					LuaRecordPlayerGameLog()
				end
			end
		end
		local gamelog = Save_PlayerLog.gamelog
		local nIndex = table.maxn(Save_PlayerLog.gamelog)
		if type(data) == "number" then
			gamelog[nIndex][nType] = (gamelog[nIndex][nType] or 0) + data
		elseif type(data) == "string" then
			gamelog[nIndex][nType] = data
		end
		--保存
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

LuaClearPlayerGameLog = function(nId)
	if Save_PlayerLog and type(Save_PlayerLog.gamelog) == "table" then
		Save_PlayerLog.gamelog[nId] = nil
		--保存
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

--记录积分来源
LuaRecordScoreSource = function(nScore,nWay)
	if Save_PlayerLog then
		if type(Save_PlayerLog.scoresource) ~= "table" then
			Save_PlayerLog.scoresource = {}
		end
		nWay = nWay or 0
		Save_PlayerLog.scoresource[nWay] = (Save_PlayerLog.scoresource[nWay] or 0) + nScore
		--保存
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

hGlobal.event:listen("localEvent_upload_tank_stage","clearlog",function(result, uid, rid, logId)
	print(result, uid, rid, logId)
	if result == 1 then
		LuaClearPlayerGameLog(logId)
	end
end)


--更新单项最佳记录
LuaUpdateRandMapSingleBestRecord = function(sType,data, notSaveFlag)
	if Save_PlayerLog then
		if type(Save_PlayerLog.rand_map_singlerecord) ~= "table" then
			Save_PlayerLog.rand_map_singlerecord = {}
		end
		if type(data) == "table" then
			if sType == "bestCK" then
				local oldData = Save_PlayerLog.rand_map_singlerecord[sType]
				if type(oldData) ~= "table" then
					oldData = {0,0}
				end
				--主判断连击数 次判断关数
				if data[1] > oldData[1] or (data[1] == oldData[1] and data[2] > oldData[2]) then
					Save_PlayerLog.rand_map_singlerecord[sType] = data
					if (not notSaveFlag) then
						LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
					end
				end
			end
		elseif type(data) == "number" then
			local oldNum = Save_PlayerLog.rand_map_singlerecord[sType] or 0
			if data > oldNum then
				Save_PlayerLog.rand_map_singlerecord[sType] = data
				if (not notSaveFlag) then
					LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
				end
			end
		end
	end
end

LuaGetRandMapSingleBestRecord = function(sType)
	if Save_PlayerLog then
		if type(Save_PlayerLog.rand_map_singlerecord) ~= "table" then
			Save_PlayerLog.rand_map_singlerecord = {}
		end
		return Save_PlayerLog.rand_map_singlerecord[sType] or 0
	end
end

LuaSetAchievementState = function(nType,nIndex,nState)
	if Save_PlayerData then
		if type(Save_PlayerData.AchievementState) ~= "table" then
			Save_PlayerData.AchievementState = {}
		end
		if type(Save_PlayerData.AchievementState[nType]) ~= "table" then
			Save_PlayerData.AchievementState[nType] = {}
		end
		Save_PlayerData.AchievementState[nType][nIndex] = nState
	end
end

LuaGetAchievementState = function(nType,nIndex)
	if Save_PlayerData then
		if type(Save_PlayerData.AchievementState) ~= "table" then
			Save_PlayerData.AchievementState = {}
		end
		if type(Save_PlayerData.AchievementState[nType]) == "table" then
			return Save_PlayerData.AchievementState[nType][nIndex] or 0
		end
	end
	return 0
end

LuaRecordGameGopherLog = function(level,num,hitcount)
	print(level,num,hitcount)
	if Save_PlayerLog then
		if type(Save_PlayerLog.GameGopher) ~= "table" then
			Save_PlayerLog.GameGopher = {}
		end
		local havechange = 0
		if type(Save_PlayerLog.GameGopher[level]) ~= "table" then
			Save_PlayerLog.GameGopher[level] = {}
		end
		local bestnum = Save_PlayerLog.GameGopher[level][1] or 0
		local hitnum = Save_PlayerLog.GameGopher[level][2] or 0
		local maxnum = Save_PlayerLog.GameGopher[level][3] or 0
		print(bestnum,hitnum,maxnum)

		local curmaxnum = LuaGetGameGopherUnitMaxNum(level)

		if curmaxnum ~= maxnum then
			Save_PlayerLog.GameGopher[level]={num,hitcount,curmaxnum}
			havechange = 1
		elseif num >= bestnum then
			if num > bestnum then
				Save_PlayerLog.GameGopher[level]={num,hitcount,curmaxnum}
				havechange = 1
			elseif hitcount < hitnum then
				Save_PlayerLog.GameGopher[level]={num,hitcount,curmaxnum}
				havechange = 1
			end
		end

		if havechange == 1 then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerLog,Save_PlayerLog)
			local keyList = {"log",}
			LuaSavePlayerData_Android_Upload(keyList, "炸地雷记录")
		end
	end
end

LuaGetGameGopherLog = function(level)
	local tlog = {}
	if Save_PlayerLog then
		if type(Save_PlayerLog.GameGopher) == "table" and type(Save_PlayerLog.GameGopher[level]) == "table" then
			tlog = Save_PlayerLog.GameGopher[level]
		end
	end
	return tlog
end

LuaRecordGameGopherLog2 = function(level,score)
	if Save_PlayerLog then
		if type(Save_PlayerLog.GameGopher2) ~= "table" then
			Save_PlayerLog.GameGopher2 = {}
		end
		if type(Save_PlayerLog.GameGopher2[level]) ~= "table" then
			Save_PlayerLog.GameGopher2[level] = {}
		end
		local havechange = 0
		local bestscore = Save_PlayerLog.GameGopher2[level][1] or 0
		local oldversion = Save_PlayerLog.GameGopher2[level][2] or ""

		if oldversion ~= hVar.GameGopherVersion then
			bestscore = 0
		end

		if score > bestscore then
			Save_PlayerLog.GameGopher2[level] = {score,hVar.GameGopherVersion}
			havechange = 1
		end

		if havechange == 1 then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerLog,Save_PlayerLog)
			local keyList = {"log",}
			LuaSavePlayerData_Android_Upload(keyList, "炸地鼠积分记录")
		end
	end
end

LuaGetGameGopherLog2 = function(level)
	local tlog = {}
	if Save_PlayerLog then
		if type(Save_PlayerLog.GameGopher2) == "table" and type(Save_PlayerLog.GameGopher2[level]) == "table" then
			tlog = Save_PlayerLog.GameGopher2[level]
			local oldversion = tlog[2] or ""
			if oldversion ~= hVar.GameGopherVersion then
				tlog = {}
			end
		end
	end
	return tlog
end

LuaGetGameGopherUnitMaxNum = function(level)
	local totalnum = 0
	local totalscore = 0
	local diffDefine = hVar.GameGopherDiffDefine[level]
	local str = string.format("Level %d MaxNum: ",level)
	if type(diffDefine) == "table" and type(diffDefine.refreshline) == "table" then
		for i = 1,#diffDefine.refreshline do
			local tLine = diffDefine.refreshline[i]
			local totaltime = math.min(diffDefine.gametime * 1000 - tLine.refreshstart,(tLine.refreshend or diffDefine.gametime * 1000) - tLine.refreshstart)
			local num = math.floor(totaltime/tLine.refreshtime)+1
			totalnum = totalnum + num
			str = str..tostring(num)
			if i ~= #diffDefine.refreshline then
				str = str .. " + "
			end
		end
		str = str.." = " ..tostring(totalnum)
		local unit_score = 1
		local unitds_score = 2
		local dsnum = diffDefine.unit_ds_num or 1
		if diffDefine.rule then
			unit_score = diffDefine.rule.unit_score
			unitds_score = diffDefine.rule.unitds_score
		end
		totalscore = (totalnum - dsnum) * unit_score + dsnum * unitds_score
		str = str.. string.format("  totalscore: (%d - %d) * %d + %d * %d = %d",totalnum,dsnum,unit_score,dsnum,unitds_score,totalscore)
		print(str)
	end
	return totalnum,totalscore
end