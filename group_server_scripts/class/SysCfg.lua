--系统配置类
local SysCfg = class("SysCfg")
    
	--构造函数
	function SysCfg:ctor()
		
		self._statisticsTime = -1	--统计计时
		self._syscfgTime = -1		--统计时间
		
		self._pvp_control = -1 --正式版 pvp版本控制
		self._debug_pvp_control = -1 --debug版 pvp版本控制
		

		self._combatStatistics = -1

		--其他
		return self
	end
	--初始化函数
	function SysCfg:Init()
		
		--默认设置为0
		self._pvp_control = 0 --正式版 pvp版本控制
		self._debug_pvp_control = 0 --debug版 pvp版本控制

		self:_DBRefreshConfig(true)

		self:_DBInitCombatStatistics()
		
		local timeNow = hApi.GetTime()
		self._statisticsTime = timeNow
		self._syscfgTime = timeNow

		return self
	end

	--刷新函数
	function SysCfg:Update()
		--输出信息
		local timeNow = hApi.GetTime()
		
		--统计信息存档
		if self._statisticsTime > -1 and timeNow - self._statisticsTime > 300 then --5分钟
			self._statisticsTime = timeNow
			self:_DBUpdateBattleInfoStatistics()
			--print("统计信息存档")
		end
		
		--读取配置
		if self._syscfgTime > -1 and timeNow - self._syscfgTime > 60 then --1分钟
			self._syscfgTime = timeNow
			self:_DBRefreshConfig(false)
			--print("读取配置")
		end
	end

	--获取正式版 pvp版本控制
	function SysCfg:GetPvpControl()
		return self._pvp_control
	end
	
	--获取debug版 pvp版本控制
	function SysCfg:GetDebugPvpControl()
		return self._debug_pvp_control
	end

	--获取玩家对应的pvp版本
	function SysCfg:GetUserPvpControl(udbid)
		local ret = self._pvp_control
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		if user then
			if user:IsTesters() then
				ret = self._debug_pvp_control
			end
		end
		return ret
	end
	
	--刷新配置 参数读取全部
	function SysCfg:_DBRefreshConfig(readAll)

		local updateId
		local sql = string.format("SELECT id,`key`,stats,content,myComment from tconfig")
		local err, tTemp = xlDb_QueryEx(sql)
		if err == 0 then
			for n = 1, #tTemp do
				local id = tTemp[n][1]
				local key = tTemp[n][2]
				local stats = tTemp[n][3]
				local content = tTemp[n][4]
				local myComment = tTemp[n][5]
				
				--如果读取全部 或者 （不读取全部，读取stats为0的）
				if readAll or ((not readAll) and stats == 0) then
					if key == "pvp_control" then
						self._pvp_control = content
					elseif key == "debug_pvp_control" then
						self._debug_pvp_control = content
					end
				end
				
				--如果装填为0
				if stats == 0 then
					if not updateId then
						updateId = tostring(id)
					else
						updateId = updateId .. ",".. tostring(id)
					end
				end
			end
		else
			--默认设置为0
			self._pvp_control = 0 --正式版 pvp版本控制
			self._debug_pvp_control = 0 --debug版 pvp版本控制
		end
		
		--如果updateId存在，则更新
		if updateId then
			sql = string.format("UPDATE tconfig SET stats=1 WHERE id in (%s)",updateId)
			xlDb_Execute(sql)
		end
	end
	
	--更新战斗信息统计数据
	function SysCfg:UpdateBattleInfoStatistics(cHero,cTower,cTactic)
		local statisticsInfo = self._combatStatistics
		if cHero and cHero ~= "" then
			local tHero = hApi.Split(cHero, ",")
			for i = 1, #tHero do
				local heroId = tonumber(tHero[i]) or 0
				if heroId > 0 then
					if statisticsInfo.herocard[heroId] then
						statisticsInfo.herocard[heroId] = statisticsInfo.herocard[heroId] + 1
					else
						statisticsInfo.herocard[heroId] = 1
					end
				end
			end
		end
		if cTower and cTower ~= ""  then
			local tTower = hApi.Split(cTower, ",")
			for i = 1, #tTower do
				local towerId = tonumber(tTower[i]) or 0
				if towerId > 0 then
					if statisticsInfo.towercard[towerId] then
						statisticsInfo.towercard[towerId] = statisticsInfo.towercard[towerId] + 1
					else
						statisticsInfo.towercard[towerId] = 1
					end
				end
			end
		end
		if cTactic and cTactic ~= ""  then
			local tTactic = hApi.Split(cTactic, ",")
			for i = 1, #tTactic do
				local tacticId = tonumber(tTactic[i]) or 0
				if tacticId > 0 then
					if statisticsInfo.tacticcard[tacticId] then
						statisticsInfo.tacticcard[tacticId] = statisticsInfo.tacticcard[tacticId] + 1
					else
						statisticsInfo.tacticcard[tacticId] = 1
					end
				end
			end
		end
	end
	
	--
	function SysCfg:AddTokenCost(token)
		self._combatStatistics.tokenCost = self._combatStatistics.tokenCost + (token or 0)
	end

	function SysCfg:AddTokenWinnerCost(token)
		self._combatStatistics.tokenWinnerCost = self._combatStatistics.tokenWinnerCost + (token or 0)
	end

	function SysCfg:AddTotalSession()
		self._combatStatistics.totalSession = self._combatStatistics.totalSession + 1
	end

	--
	function SysCfg:CombatStatisticsToCmd()
		local cmd = ""
		local strHero = ""
		local strTower = ""
		local strTactic = ""
		local tokenCost = 0
		local tokenWinnerCost = 0
		local totalSession = 0
		local statisticsInfo = self._combatStatistics
		--英雄
		local heroNum = 0
		for tabId,num in pairs(statisticsInfo.herocard) do
			strHero = strHero .. tabId .. "," .. num .. ":"
			heroNum = heroNum + 1
		end
		strHero = heroNum .. ":" .. strHero

		--塔
		local towerNum = 0
		for tabId,num in pairs(statisticsInfo.towercard) do
			strTower = strTower .. tabId .. "," .. num .. ":"
			towerNum = towerNum + 1
		end
		strTower = towerNum .. ":" ..  strTower

		--战术卡
		local tacticNum = 0
		for tabId,num in pairs(statisticsInfo.tacticcard) do
			strTactic = strTactic .. tabId .. "," .. num .. ":"
			tacticNum = tacticNum + 1
		end
		strTactic = tacticNum .. ":" ..  strTactic
		
		cmd = strHero ..  ";" .. strTower .. ";" .. strTactic

		tokenCost = self._combatStatistics.tokenCost
		tokenWinnerCost = self._combatStatistics.tokenWinnerCost
		totalSession = self._combatStatistics.totalSession

		cmd = cmd .. ";" .. tokenCost .. ";" .. tokenWinnerCost .. ";" .. totalSession

		return cmd,strHero,strTower,strTactic,tokenCost,tokenWinnerCost,totalSession
	end
	
	--初始化战斗统计数据
	function SysCfg:_DBInitCombatStatistics()
		self._combatStatistics = {}
		local sql = string.format("SELECT hero,tower,tactic,tokenCost,tokenWinnerCost,totalSession from t_pvp_combatcfg_statistics where id = 1")
		local err, strHero,strTower,strTactic,tokenCost,tokenWinnerCost,totalSession = xlDb_Query(sql)
		if err == 0 then
			local statisticsInfo = self._combatStatistics

			statisticsInfo.herocard = {}
			local tHero = hApi.Split(strHero, ":")
			if tHero then
				local heroNum = tonumber(tHero[1]) or 0
				local idx = 1
				for i = 1, heroNum do
					local tTmp = hApi.Split(tHero[idx + i], ",")
					local id = tonumber(tTmp[1]) or 0
					local num = tonumber(tTmp[2]) or 0
					if (id > 0) then
						statisticsInfo.herocard[id] = num
					end
				end
			end
			
			statisticsInfo.towercard = {}
			local tTower = hApi.Split(strTower, ":")
			if tTower then
				local towerNum = tonumber(tTower[1]) or 0
				local idx = 1
				for i = 1, towerNum do
					local tTmp = hApi.Split(tTower[idx + i], ",")
					local id = tonumber(tTmp[1]) or 0
					local num = tonumber(tTmp[2]) or 0
					if (id > 0) then
						statisticsInfo.towercard[id] = num
					end
				end
			end
			
			statisticsInfo.tacticcard = {}
			local tTactic = hApi.Split(strTactic, ":")
			if tTactic then
				local tacticNum = tonumber(tTactic[1]) or 0
				local idx = 1
				for i = 1, tacticNum do
					local tTmp = hApi.Split(tTactic[idx + i], ",")
					local id = tonumber(tTmp[1]) or 0
					local num = tonumber(tTmp[2]) or 0
					if (id > 0) then
						if (num > 0) then --只统计数量大于0的卡
							statisticsInfo.tacticcard[id] = num
						end
					end
				end
			end
			
			statisticsInfo.tokenCost = tokenCost
			statisticsInfo.tokenWinnerCost = tokenWinnerCost
			statisticsInfo.totalSession = totalSession

		else
			local statisticsInfo = self._combatStatistics
			statisticsInfo.herocard = {}
			statisticsInfo.towercard = {}
			statisticsInfo.tacticcard = {}
			statisticsInfo.tokenCost = 0
			statisticsInfo.tokenWinnerCost = 0
			statisticsInfo.totalSession = 0
		end
	end

	--更新战斗信息统计数据
	function SysCfg:_DBUpdateBattleInfoStatistics()
		local _,strHero,strTower,strTactic,tokenCost,tokenWinnerCost,totalSession = self:CombatStatisticsToCmd()
		local sql = string.format("UPDATE `t_pvp_combatcfg_statistics` SET `hero`='%s', `tower`='%s', `tactic`='%s', `tokenCost`=%d, `tokenWinnerCost`=%d, `totalSession`=%d, `time`=NOW() WHERE `id`=1", strHero,strTower,strTactic,tokenCost,tokenWinnerCost,totalSession)
		xlDb_Execute(sql)
	end

return SysCfg