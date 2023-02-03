--------------------------------------------------------------------
--�ַ�����table�Ļ���ת��
--------------------------------------------------------------------

--�ַ���תtable
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

--tableת�ַ���
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

--tableת�ַ���(��)
function hApi.TableToSimplifyString(t)
	if "table" == type(t) then
		local sString = "{"
		local num = #t
		--���Ȱ�˳���б�ת��  ����key��������ռ��
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
			--�޳���ת�����ַ�
			if "number" == type(k) and k <= num then
				--��ת��
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

--��¼������Դ
local _Code_RecordScoreSource = function(nScore,nWay)
	local diablodata = hGlobal.LocalPlayer.data.diablodata --��������
	if diablodata and type(diablodata.randMap) == "table" then	--��¼��Ϸ�ڵ�����
		if nWay == hVar.GET_SCORE_WAY.ADS then	--���
			--��Ϸ��
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.MAPPURCHASESCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.PURCHASE then	--��ֵ
			--��Ϸ��
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.MAPPURCHASESCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.CK then	--��ն
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.CKSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.CLEARSTAGE then	--���ؿ�����
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.MAPGETSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.GAMESETTLEMENT then	--��Ϸ����
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.SETTLEMENTSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.UPGRADETACTICS then	--�����츳
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.MAPCOSTSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.PETADHP then		--�����Ѫ
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.MAPCOSTSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.REVIVE then	--����
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.MAPCOSTSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.DAILYREWARD then	--������
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.BASEDAILYSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.ACHIEVEMENTSCORE then	--�ɾ�
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.ACHIEVEMENTSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.SYSTEMREWARD then
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.SYSTEMREWARDSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.GMCHEAT then
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.GMCHEAT,nScore)
		else
			--δ֪��Դ �Ա�ͳ��
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.UNKOWN,nScore)
		end
	else	--��¼��Ϸ�������
		if nWay == hVar.GET_SCORE_WAY.ADS then	--���
			--��Ϸ��
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.BASEPURCHASESCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.PURCHASE then	--��ֵ
			--��Ϸ��
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.BASEPURCHASESCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.UNLOCKWEAPON then	--��������
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.BASECOSTSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.UPGRADEITEMTACTICS then	--���������츳
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.BASECOSTSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.UPGRADEPET then		--��������
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.BASECOSTSCORE,nScore)
		elseif nWay == hVar.GET_SCORE_WAY.GMCHEAT then
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.GMCHEAT,nScore)
		else
			--δ֪��Դ
			LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.UNKOWN,nScore)
		end
	end
end

local _lastRecordScore = ""

--����������
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

--��������Դ����
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

--��ԭ�к����������������ͳ���Լ���Դ���
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
		--��Դ����ģʽ�²���ͨ�ش˷���
		if g_lua_src ~= 1 then
			return
		end
	elseif _safeAddScoreWay[nWay] == 1 then
		--С�ڴ�ֵ Ϊ��ӻ���
		if nWay < hVar.GET_SCORE_WAY.DIVIDINGLINE then
			if nScore < 0 then
				print("function:LuaAddPlayerScoreByWay param:nWay Error",tostring(nWay))
				return
			end
		--���ڴ�ֵ Ϊ���Ļ���
		elseif nWay > hVar.GET_SCORE_WAY.DIVIDINGLINE then
			if nScore > 0 then
				print("function:LuaAddPlayerScoreByWay param:nWay Error",tostring(nWay))
				return
			end
		--�ָ��߱���������Ч����
		else
			return
		end
		--��¼������Դ
		_Code_RecordScoreSource(math.abs(nScore),nWay)
	elseif nScore < 0 then
		--δ֪�۳���ʽ ������Ȼ����
		print("function:LuaAddPlayerScoreByWay param:nWay Unknown",tostring(nWay))
	else
		--����Ч���� �����ӻ���
		return
	end
	--�������Դ����
	_Code_CheckScoreSourceCheat(nScore,nWay)
	--��¼������Դ
	LuaRecordScoreSource(math.abs(nScore),nWay)
	--�����һ���
	LuaAddPlayerScore(nScore,notSaveFlag)
	--��¼����
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

--�ϴ������Ϸlog
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
--ͳ�������Ϸlog
LuaRecordPlayerGameLog = function()
	if Save_PlayerLog then
		if type(Save_PlayerLog.gamelog) ~= "table" or Save_PlayerLog.gamelog.curIndex == nil then
			Save_PlayerLog.gamelog = {}
		end

		--�������Ƿ����� (����һ����Ϸlog�л�����Ƚ�)
		--������
		
		--����Ƿ���Ҫ�ϴ�����
		LuaUploadPlayerGameLog()
		
		local gamelog = Save_PlayerLog.gamelog
		local nIndex = (gamelog.curIndex or table.maxn(Save_PlayerLog.gamelog)) + 1
		gamelog.curIndex = nIndex
		gamelog[nIndex] = {}
		gamelog[nIndex].upload = 0
		gamelog[nIndex].protrol = protrol
		--��ʼ���ֻ���
		LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.INITIALSCORE,LuaGetPlayerScore())
		--����ʱ�� (��_��_�� 8λ)
		local curtime = os.time()
		local timeStr = os.date("%m_%d_%H_%M",curtime)
		LuaAddPlayerGameLog(hVar.STATISTICAL_GAMEDATA.INITIALTIME,timeStr)
		
		--����
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

--��������Ϸlog
LuaAddPlayerGameLog = function(nType,data)
	if Save_PlayerLog then
		local nIndex = 0
		if type(Save_PlayerLog.gamelog) ~= "table" or Save_PlayerLog.gamelog.curIndex == nil then
			--��ʼ��
			LuaRecordPlayerGameLog()
		else
			nIndex = table.maxn(Save_PlayerLog.gamelog)
			if nIndex == 0 then
				--��Ϊ��
				LuaRecordPlayerGameLog()
			else
				--�汾����
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
		--����
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

LuaClearPlayerGameLog = function(nId)
	if Save_PlayerLog and type(Save_PlayerLog.gamelog) == "table" then
		Save_PlayerLog.gamelog[nId] = nil
		--����
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

--��¼������Դ
LuaRecordScoreSource = function(nScore,nWay)
	if Save_PlayerLog then
		if type(Save_PlayerLog.scoresource) ~= "table" then
			Save_PlayerLog.scoresource = {}
		end
		nWay = nWay or 0
		Save_PlayerLog.scoresource[nWay] = (Save_PlayerLog.scoresource[nWay] or 0) + nScore
		--����
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

hGlobal.event:listen("localEvent_upload_tank_stage","clearlog",function(result, uid, rid, logId)
	print(result, uid, rid, logId)
	if result == 1 then
		LuaClearPlayerGameLog(logId)
	end
end)


--���µ�����Ѽ�¼
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
				--���ж������� ���жϹ���
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
			LuaSavePlayerData_Android_Upload(keyList, "ը���׼�¼")
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
			LuaSavePlayerData_Android_Upload(keyList, "ը������ּ�¼")
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