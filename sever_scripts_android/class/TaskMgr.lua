--任务（新）类
local TaskMgr = class("TaskMgr")
	
	--构造函数
	function TaskMgr:ctor()
		self._uid = -1
		self._rid = -1
		self._nDate = -1
		self._nWeek = -1
		
		return self
	end
	
	--初始化函数
	function TaskMgr:Init(uid, rid)
		--日期转年月日
		local strDateToday = os.date("%Y%m%d", os.time())
		local nDateToday = tonumber(strDateToday)
		local strWeekNow = os.date("%Y%W", os.time())
		local nWeekNow = tonumber(strWeekNow)
		
		self._uid = uid
		self._rid = rid
		self._nDate = nDateToday
		self._nWeek = nWeekNow
		
		--查询每日任务是否初始化
		local sQuery = string.format("SELECT `uid` from `t_user_task` where `uid` = %d and `date_yymmdd` = %d", self._uid, self._nDate)
		local err, _ = xlDb_Query(sQuery)
		--print("查询任务初始化:","err=", err, uid)
		if (err == 0) then
			--
		else --查询失败
			--插入新表
			local sInsert = string.format("insert into `t_user_task`(`uid`, `date_yymmdd`) values (%d, %d)", self._uid, self._nDate)
			xlDb_Execute(sInsert)
			
			--检查是否补发昨日奖励
			self:__TaskTakeYesterdayReward()
		end
		
		--查询周任务是否初始化
		local sQuery = string.format("SELECT `uid` from `t_user_task_week` where `uid` = %d and `date_week` = %d", self._uid, self._nWeek)
		local err, _ = xlDb_Query(sQuery)
		--print("查询任务初始化:","err=", err, uid)
		if (err == 0) then
			--
		else --查询失败
			--插入新表
			local sInsert = string.format("insert into `t_user_task_week`(`uid`, `date_week`) values (%d, %d)", self._uid, self._nWeek)
			xlDb_Execute(sInsert)
			
			--检查是否补发昨日奖励
			--self:__TaskTakeYesterdayReward()
		end
		
		return self
	end
	
	--查询任务和任务完成进度
	function TaskMgr:QueryTaskState(nChannelId)
		local sCmd = ""
		
		local nTaskNumUnfinish = 0
		
		--每日任务
		--查询任务和完成情况
		local tTaskInfo = {}
		--每日任务
		--任务（新）类型对应的数据库字段
		local sQuery = string.format("SELECT `task`, `task_sharecount`, `task_drawcard`, `task_redchest`, `task_refreshshop`, `task_xilian`, `task_battle_pve`, `task_endless`, `task_qszdwave`, `task_randmapstage`, `task_pvp_chest`, `task_pvp_battle`, `task_pvpcoin`, `task_weaponchest`, `task_tacticchest`, `task_petchest`, `task_equipchest`, `task_killenemy`, `task_killboss`, `task_deadth`, `task_usetactic`, `task_scientist`, `task_mapsuccess_n`, `task_mapsuccess_nohurt_n`, `task_killboss_n`, `task_usetactic_n`, `task_max_pet_follow_amount`, `task_use_chip_to_reform_equip_times`, `task_upgrade_tactical_card_times`, `task_upgrade_weapon_times`, `task_upgrade_pet_times`, `task_map_success_difficulty_n` from `t_user_task` where `uid` = %d and `date_yymmdd` = %d", self._uid, self._nDate)
		local err, task, task_sharecount, task_drawcard, task_redchest, task_refreshshop, task_xilian, task_battle_pve, task_endless, task_qszdwave, task_randmapstage, task_pvp_chest, task_pvp_battle, task_pvpcoin, task_weaponchest, task_tacticchest, task_petchest, task_equipchest, task_killenemy, task_killboss, task_deadth, task_usetactic, task_scientist, task_mapsuccess_n, task_mapsuccess_nohurt_n, task_killboss_n, task_usetactic_n, task_max_pet_follow_amount, task_use_chip_to_reform_equip_times, task_upgrade_tactical_card_times, task_upgrade_weapon_times, task_upgrade_pet_times, task_map_success_difficulty_n = xlDb_Query(sQuery)
		--print(sQuery)
		--print(err)
		if (err == 0) then
			local currenttime = os.time()
			local tCmd = hApi.Split(task, ";")
			local taskNum = tonumber(tCmd[1]) or 0 --任务数量
			if (taskNum > 0) then
				local rIdx = 1
				for i = 1, taskNum, 1 do
					local taskInfo = tCmd[rIdx+i]
					local tInfo = hApi.Split(taskInfo, ":")
					local taskId = tonumber(tInfo[1]) or 0 --任务id
					local taskFinishFlag = tonumber(tInfo[2]) or 0 --任务完成情况
					--print(i, "taskId="..taskId, "finish=", taskFinishFlag)
					
					tTaskInfo[#tTaskInfo+1] = {taskId, taskFinishFlag,}
				end
			else
				--查询地图信息
				local tankMap = hClass.TankMap:create():Init(self._uid, self._rid)
				local _, tMap = tankMap:QueryInfo()
				local tMapDic = {}
				for i = 1, #tMap, 1 do
					local tMapInfo = tMap[i]
					local mapName = tMapInfo[1]
					tMapDic[mapName] = tMapInfo
				end
				
				--玩家已通关的最大地图章节
				local chapterId = 1
				for c = #hVar.tab_chapter, 1, -1 do
					local tabC = hVar.tab_chapter[c]
					local lastmap = tabC.lastmap --本章的最后一关
					local finishFlag = tMapDic[lastmap] and tMapDic[lastmap][6] or 0
					if (finishFlag > 0) then
						chapterId = c
						break
					end
				end
				
				--[[
				--每日任务初始化（每日任务）
				for i = 1, #hVar.TASK_ILIST_DAY, 1 do
					tTaskInfo[#tTaskInfo+1] = {hVar.TASK_ILIST_DAY[i], 0,}
				end
				]]
				
				--print("chapterId=", chapterId)
				
				--随机出每日任务
				local day = hVar.TASK_ILIST_NEW[chapterId].day
				local pool = day.pool
				local taskNum = day.taskNum
				
				--随机出任务
				local taskNumNow = 0
				local tTaskIdxDic = {}
				while (taskNumNow < taskNum) do
					local randIdx = math.random(1, #pool)
					
					--不与已有的索引重复
					if (tTaskIdxDic[randIdx] == nil) then
						local poolInfo = pool[randIdx]
						if (type(poolInfo) == "number") then
							--生效
							local taskId = poolInfo
							tTaskInfo[#tTaskInfo+1] = {taskId, 0,}
							taskNumNow = taskNumNow + 1
							tTaskIdxDic[randIdx] = randIdx
							--print("taskId=", taskId)
						elseif (type(poolInfo) == "table") then
							local pool2 = poolInfo.pool
							local num = math.min(poolInfo.totalNum, taskNum - taskNumNow) --可随机的数量不超过剩余任务数量
							local tDic2 = {}
							for n = 1, num, 1 do
								local randIdx2 = math.random(1, #pool2)
								
								--不与已有的索引重复
								if (tDic2[randIdx2] == nil) then
									--生效2
									local taskId = pool2[randIdx2]
									tTaskInfo[#tTaskInfo+1] = {taskId, 0,}
									taskNumNow = taskNumNow + 1
									tTaskIdxDic[randIdx] = randIdx
									tDic2[randIdx2] = randIdx2
									--print("taskId2=", taskId)
								end
							end
						end
					end
				end
				--[[
				local TASK_ILIST_DAY = {}
				for i = 1, #pool, 1 do
					TASK_ILIST_DAY[#TASK_ILIST_DAY+1] = pool[i]
				end
				--随机剔除一定数量的任务数量
				for j = 1, #pool - taskNum, 1 do
					local randIdx = math.random(1, #TASK_ILIST_DAY)
					table.remove(TASK_ILIST_DAY, randIdx)
				end
				--每日任务初始化（每日任务）
				for i = 1, #TASK_ILIST_DAY, 1 do
					tTaskInfo[#tTaskInfo+1] = {TASK_ILIST_DAY[i], 0,}
				end
				]]
				
				--特别任务
				for i = 1, #hVar.TASKE_EXTRA_LIST, 1 do
					local tInfo = hVar.TASKE_EXTRA_LIST[i]
					local beginTime = tInfo.beginTime
					local endTime = tInfo.endTime
					local tasks = tInfo.tasks
					local nTimestampBegin = hApi.GetNewDate(beginTime)
					local nTimestampEnd = hApi.GetNewDate(endTime)
					if (currenttime >= nTimestampBegin) and (currenttime <= nTimestampEnd) then --在指定日期里
						for t = 1, #tasks, 1 do
							tTaskInfo[#tTaskInfo+1] = {tasks[t], 0,}
						end
					end
				end
				
				--指定渠道额外的固定任务
				local tChannelTask = hVar.TASK_CHANNEL_ADDONES[nChannelId]
				if (type(tChannelTask) == "table") then
					for c = 1, #tChannelTask, 1 do
						local taskId = tChannelTask[c]
						table.insert(tTaskInfo, c, {taskId, 0,})
					end
				end
				
				--更新任务信息
				local sTask = tostring(#tTaskInfo) .. ";"
				for t = 1, #tTaskInfo, 1 do
					local tTask = tTaskInfo[t]
					sTask = sTask .. tostring(tTask[1]) .. ":" .. tostring(tTask[2]) .. ";"
				end
				local sUpdate = string.format("UPDATE `t_user_task` SET `task` = '%s' where `uid` = %d and `date_yymmdd` = %d", sTask, self._uid, self._nDate)
				--print("sUpdate1:",sUpdate)
				xlDb_Execute(sUpdate)
			end
			
			--每日奖励任务，需要查询t_user
			--查询每日奖励上一次领取的日期
			local strTimeEveryDay = ""
			local sQuery = string.format("SELECT `last_every_day_prize_get_time` from `t_user` where `uid` = %d", self._uid)
			local errQuery, strTime = xlDb_Query(sQuery)
			if (errQuery == 0) then
				strTimeEveryDay = strTime
			end
			--转化为服务器上次操作时间的0点天的时间戳
			local nTimestampEveryDay = hApi.GetNewDate(strTimeEveryDay)
			local strDatestampYMD = hApi.Timestamp2Date(nTimestampEveryDay) --转字符串(年月日)
			local strNewdate = strDatestampYMD .. " 00:00:00"
			local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1)
			--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
			--今日时间戳
			local nTimestampNow = os.time()
			--今日在有效期内
			if (nTimestampNow >= nTimestampTodayZero) then
				--
			else
				tTaskInfo[1][2] = 1 --标记今日奖励任务已完成
			end
			
			--解析关卡通关
			local tMapSuccess = {}
			local tCmd = hApi.Split(task_mapsuccess_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local mapName = tInfo[1]
				local mapCount = tonumber(tInfo[2]) or 0
				tMapSuccess[#tMapSuccess+1] = {mapName, mapCount,}
				--print("解析关卡通关", mapName, mapCount)
			end
			
			--解析无损关卡通关
			local tMapSuccessNoHurt = {}
			local tCmd = hApi.Split(task_mapsuccess_nohurt_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local mapName = tInfo[1]
				local mapCount = tonumber(tInfo[2]) or 0
				tMapSuccessNoHurt[#tMapSuccessNoHurt+1] = {mapName, mapCount,}
				--print("解析无损关卡通关", mapName, mapCount)
			end
			
			--解析击杀boss
			local tKillBoss = {}
			local tCmd = hApi.Split(task_killboss_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --击杀boss数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local bossId = tonumber(tInfo[1]) or 0
				local bossCount = tonumber(tInfo[2]) or 0
				tKillBoss[#tKillBoss+1] = {bossId, bossCount,}
			end
			
			--解析使用战术卡
			local tUseTactic = {}
			local tCmd = hApi.Split(task_usetactic_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --使用战术卡数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local tacticId = tonumber(tInfo[1]) or 0
				local useCount = tonumber(tInfo[2]) or 0
				tUseTactic[#tUseTactic+1] = {tacticId, useCount,}
			end

			--解析关卡通关难度
			local tMapSuccessDifficulty = {}
			local tCmd = hApi.Split(task_map_success_difficulty_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local mapName = tInfo[1]
				local diffLevel = tonumber(tInfo[2]) or 0
				tMapSuccessDifficulty[#tMapSuccessDifficulty+1] = {mapName, diffLevel,}
				--print("解析关卡通关难度", mapName, diffLevel)
			end
			
			--只下发未完成的任务
			for t = 1, #tTaskInfo, 1 do
				local tTask = tTaskInfo[t]
				local taskId = tTask[1]
				local taskFinishFlag = tTask[2]
				local taskProgress = 0 --任务已完成的进度
				local tabTask = hVar.tab_task[taskId] or {}
				local taskType = tabTask.taskType --任务类型
				local typeId = tabTask.typeId --任务指定的参数
				local taskProgressMax = tabTask.maxProgress --任务总进度
				
				if (taskFinishFlag == 0) then --未完成的任务
					if (taskType == hVar.TASK_TYPE.TASK_DALILY_REWARD) then --每日奖励
						--taskProgress = task_daily
					elseif (taskType == hVar.TASK_TYPE.TASK_SHARE_COUINT) then --分享次数
						taskProgress = task_sharecount
					elseif (taskType == hVar.TASK_TYPE.TASK_TACTICCARD_ONCE) then --商城抽卡
						taskProgress = task_drawcard
					elseif (taskType == hVar.TASK_TYPE.TASK_REDCHEST_ONCE) then --商城抽装
						taskProgress = task_redchest
					elseif (taskType == hVar.TASK_TYPE.TASK_REFRESH_SHOP) then --刷新商店
						taskProgress = task_refreshshop
					elseif (taskType == hVar.TASK_TYPE.TASK_EQUIP_XILIAN) then --百炼成钢
						taskProgress = task_xilian
					elseif (taskType == hVar.TASK_TYPE.TASK_BASE_BATTLE_WIN) then --小试牛刀
						taskProgress = task_battle_pve
					elseif (taskType == hVar.TASK_TYPE.TASK_ENDLESS_SCORE) then --无尽使命
						taskProgress = task_endless
					elseif (taskType == hVar.TASK_TYPE.TASK_QSZD_WAVE) then --前哨阵地波次
						taskProgress = task_qszdwave
					elseif (taskType == hVar.TASK_TYPE.TASK_RANDOMMAP_STAGE) then --随机迷宫层数
						taskProgress = task_randmapstage
					elseif (taskType == hVar.TASK_TYPE.TASK_PVP_OPENCHEST) then --竞技锦囊
						taskProgress = task_pvp_chest
					elseif (taskType == hVar.TASK_TYPE.TASK_PVP_BATTLE) then --竞技切磋
						taskProgress = task_pvp_battle
					elseif (taskType == hVar.TASK_TYPE.TASK_PVPTOKEN_USE) then --兵符达人
						taskProgress = task_pvpcoin
					elseif (taskType == hVar.TASK_TYPE.TASK_OPEN_WEPONCHEST) then --武器宝箱
						taskProgress = task_weaponchest
					elseif (taskType == hVar.TASK_TYPE.TASK_OPEN_TACTICCHEST) then --战术宝箱
						taskProgress = task_tacticchest
					elseif (taskType == hVar.TASK_TYPE.TASK_OPEN_PETCHEST) then --宠物宝箱
						taskProgress = task_petchest
					elseif (taskType == hVar.TASK_TYPE.TASK_OPEN_EQUIPCHEST) then --装备宝箱
						taskProgress = task_equipchest
					elseif (taskType == hVar.TASK_TYPE.TASK_KILL_ENEMY) then --击杀敌人
						taskProgress = task_killenemy
					elseif (taskType == hVar.TASK_TYPE.TASK_KILL_BOSS) then --击杀BOSS
						taskProgress = task_killboss
					elseif (taskType == hVar.TASK_TYPE.TASK_DEADTH) then --战车死亡
						taskProgress = task_deadth
					elseif (taskType == hVar.TASK_TYPE.TASK_USE_TACTIC) then --使用战术卡
						taskProgress = task_usetactic
					elseif (taskType == hVar.TASK_TYPE.TASK_RESCUE_SCIENTIST) then --拯救科学家
						taskProgress = task_scientist
					elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_N) then --通关指定关卡
						--找到指定的关卡
						for i = 1, #tMapSuccess, 1 do
							--print("tMapSuccess[i][1]=", tMapSuccess[i][1])
							--print("typeId=", typeId)
							if (tMapSuccess[i][1] == typeId) then
								taskProgress = tMapSuccess[i][2]
								--print("find  taskProgress =", taskProgress)
							end
						end
					elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N) then --无损通关指定关卡
						--找到指定的无损关卡
						for i = 1, #tMapSuccessNoHurt, 1 do
							if (tMapSuccessNoHurt[i][1] == typeId) then
								taskProgress = tMapSuccessNoHurt[i][2]
							end
						end
					elseif (taskType == hVar.TASK_TYPE.TASK_KILL_BOSS_N) then --击杀指定BOSS
						--找到指定的boss
						for i = 1, #tKillBoss, 1 do
							if (tKillBoss[i][1] == typeId) then
								taskProgress = tKillBoss[i][2]
							end
						end
					elseif (taskType == hVar.TASK_TYPE.TASK_USE_TACTIC_N) then --使用指定战术卡
						--找到指定的战术卡
						for i = 1, #tUseTactic, 1 do
							if (tUseTactic[i][1] == typeId) then
								taskProgress = tUseTactic[i][2]
							end
						end
					elseif (taskType == hVar.TASK_TYPE.TASK_MAX_PET_FOLLOW_AMOUNT) then --最大跟随宠物数量
						taskProgress = task_max_pet_follow_amount
					elseif (taskType == hVar.TASK_TYPE.TASK_USE_CHIP_TO_REFORM_EQUIP_TIMES) then --使用芯片改造装备次数
						taskProgress = task_use_chip_to_reform_equip_times
					elseif (taskType == hVar.TASK_TYPE.TASK_UPGRADE_TACTICAL_CARD_TIMES) then --升级任意战术卡次数
						taskProgress = task_upgrade_tactical_card_times
					elseif (taskType == hVar.TASK_TYPE.TASK_UPGRADE_WEAPON_TIMES) then --升级任意枪塔武器次数
						taskProgress = task_upgrade_weapon_times
					elseif (taskType == hVar.TASK_TYPE.TASK_UPGRADE_PET_TIMES) then --升级任意宠物次数
						taskProgress = task_upgrade_pet_times
					elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_DIFFICULTY_N) then --关卡通关难度
						--找到指定的关卡
						for i = 1, #tMapSuccessDifficulty, 1 do
							if (tMapSuccessDifficulty[i][1] == typeId) then
								taskProgress = tMapSuccessDifficulty[i][2]
							end
						end
					end
					
					nTaskNumUnfinish = nTaskNumUnfinish + 1
					sCmd = sCmd .. tostring(taskId) .. ":" .. tostring(taskFinishFlag) .. ":" .. tostring(taskProgress) .. ":" .. tostring(taskProgressMax) .. ";"
				end
			end
			
			--[[
			--查询夺塔奇兵免费锦囊今日是否有免费次数
			local nFreeChestCount = 0 --免费锦囊免费次数
			local sQueryM = string.format("SELECT `pvpshop_freechest_lasttime` FROM `t_pvp_user` WHERE `id` = %d", self._rid)
			local errM, pvpshop_freechest_lasttime = xlDb_Query(sQueryM)
			if (errM == 0) then
				--解析免费锦囊今日是否可免费领取
				--转化为服务器上次操作时间的0点天的时间戳
				local nTimestamp = hApi.GetNewDate(pvpshop_freechest_lasttime)
				local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --转字符串(年月日)
				local strNewdate = strDatestampYMD .. " 00:00:00"
				local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1)
				--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
				--今日在有效期内
				if (currenttime >= nTimestampTodayZero) then
					nFreeChestCount = 1
				end
			end
			
			sCmd = tostring(nTaskNumUnfinish) .. ";" .. sCmd .. tostring(nFreeChestCount) .. ";"
			]]
		end
		
		--周任务
		--查询任务和完成情况
		local tTaskInfo = {}
		--周任务
		--任务（新）类型对应的数据库字段
		local sQuery = string.format("SELECT `task`, `taskstone_reward`, `task_sharecount`, `task_drawcard`, `task_redchest`, `task_refreshshop`, `task_xilian`, `task_battle_pve`, `task_endless`, `task_qszdwave`, `task_randmapstage`, `task_pvp_chest`, `task_pvp_battle`, `task_pvpcoin`, `task_weaponchest`, `task_tacticchest`, `task_petchest`, `task_equipchest`, `task_killenemy`, `task_killboss`, `task_deadth`, `task_usetactic`, `task_scientist`, `task_mapsuccess_n`, `task_mapsuccess_nohurt_n`, `task_killboss_n`, `task_usetactic_n`, `task_max_pet_follow_amount`, `task_use_chip_to_reform_equip_times`, `task_upgrade_tactical_card_times`, `task_upgrade_weapon_times`, `task_upgrade_pet_times`, `task_map_success_difficulty_n` from `t_user_task_week` where `uid` = %d and `date_week` = %d", self._uid, self._nWeek)
		local err, task, taskstone_reward, task_sharecount, task_drawcard, task_redchest, task_refreshshop, task_xilian, task_battle_pve, task_endless, task_qszdwave, task_randmapstage, task_pvp_chest, task_pvp_battle, task_pvpcoin, task_weaponchest, task_tacticchest, task_petchest, task_equipchest, task_killenemy, task_killboss, task_deadth, task_usetactic, task_scientist, task_mapsuccess_n, task_mapsuccess_nohurt_n, task_killboss_n, task_usetactic_n, task_max_pet_follow_amount, task_use_chip_to_reform_equip_times, task_upgrade_tactical_card_times, task_upgrade_weapon_times, task_upgrade_pet_times, task_map_success_difficulty_n = xlDb_Query(sQuery)
		--print(sQuery)
		--print(err)
		if (err == 0) then
			local currenttime = os.time()
			local tCmd = hApi.Split(task, ";")
			local taskNum = tonumber(tCmd[1]) or 0 --任务数量
			if (taskNum > 0) then
				local rIdx = 1
				for i = 1, taskNum, 1 do
					local taskInfo = tCmd[rIdx+i]
					local tInfo = hApi.Split(taskInfo, ":")
					local taskId = tonumber(tInfo[1]) or 0 --任务id
					local taskFinishFlag = tonumber(tInfo[2]) or 0 --任务完成情况
					--print(i, "taskId="..taskId, "finish=", taskFinishFlag)
					
					tTaskInfo[#tTaskInfo+1] = {taskId, taskFinishFlag,}
				end
			else
				--查询地图信息
				local tankMap = hClass.TankMap:create():Init(self._uid, self._rid)
				local _, tMap = tankMap:QueryInfo()
				local tMapDic = {}
				for i = 1, #tMap, 1 do
					local tMapInfo = tMap[i]
					local mapName = tMapInfo[1]
					tMapDic[mapName] = tMapInfo
				end
				
				--玩家已通关的最大地图章节
				local chapterId = 1
				for c = #hVar.tab_chapter, 1, -1 do
					local tabC = hVar.tab_chapter[c]
					local lastmap = tabC.lastmap --本章的最后一关
					local finishFlag = tMapDic[lastmap] and tMapDic[lastmap][6] or 0
					if (finishFlag > 0) then
						chapterId = c
						break
					end
				end
				
				--随机出每周任务
				local TASK_ILIST_WEEK = {}
				local week = hVar.TASK_ILIST_NEW[chapterId].week
				local pool = week.pool
				local taskNum = week.taskNum
				for i = 1, #pool, 1 do
					TASK_ILIST_WEEK[#TASK_ILIST_WEEK+1] = pool[i]
				end
				--随机剔除一定数量的任务数量
				for j = 1, #pool - taskNum, 1 do
					local randIdx = math.random(1, #TASK_ILIST_WEEK)
					table.remove(TASK_ILIST_WEEK, randIdx)
				end
				--每周任务初始化（每周任务）
				for i = 1, #TASK_ILIST_WEEK, 1 do
					tTaskInfo[#tTaskInfo+1] = {TASK_ILIST_WEEK[i], 0,}
				end
				
				--[[
				--周任务初始化
				for i = 1, #hVar.TASK_ILIST_WEEK, 1 do
					tTaskInfo[#tTaskInfo+1] = {hVar.TASK_ILIST_WEEK[i], 0,}
				end
				]]
				
				--[[
				--特别任务
				for i = 1, #hVar.TASKE_EXTRA_LIST, 1 do
					local tInfo = hVar.TASKE_EXTRA_LIST[i]
					local beginTime = tInfo.beginTime
					local endTime = tInfo.endTime
					local tasks = tInfo.tasks
					local nTimestampBegin = hApi.GetNewDate(beginTime)
					local nTimestampEnd = hApi.GetNewDate(endTime)
					if (currenttime >= nTimestampBegin) and (currenttime <= nTimestampEnd) then --在指定日期里
						for t = 1, #tasks, 1 do
							tTaskInfo[#tTaskInfo+1] = {tasks[t], 0,}
						end
					end
				end
				]]
				
				--更新任务信息
				local sTask = tostring(#tTaskInfo) .. ";"
				for t = 1, #tTaskInfo, 1 do
					local tTask = tTaskInfo[t]
					sTask = sTask .. tostring(tTask[1]) .. ":" .. tostring(tTask[2]) .. ";"
				end
				local sUpdate = string.format("UPDATE `t_user_task_week` SET `task` = '%s' where `uid` = %d and `date_week` = %d", sTask, self._uid, self._nWeek)
				--print("sUpdate1:",sUpdate)
				xlDb_Execute(sUpdate)
			end
			
			--[[
			--周奖励任务，需要查询t_user
			--查询每日奖励上一次领取的日期
			local strTimeEveryDay = ""
			local sQuery = string.format("SELECT `last_every_day_prize_get_time` from `t_user` where `uid` = %d", self._uid)
			local errQuery, strTime = xlDb_Query(sQuery)
			if (errQuery == 0) then
				strTimeEveryDay = strTime
			end
			--转化为服务器上次操作时间的0点天的时间戳
			local nTimestampEveryDay = hApi.GetNewDate(strTimeEveryDay)
			local strDatestampYMD = hApi.Timestamp2Date(nTimestampEveryDay) --转字符串(年月日)
			local strNewdate = strDatestampYMD .. " 00:00:00"
			local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1)
			--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
			--今日时间戳
			local nTimestampNow = os.time()
			--今日在有效期内
			if (nTimestampNow >= nTimestampTodayZero) then
				--
			else
				tTaskInfo[1][2] = 1 --标记今日奖励任务已完成
			end
			]]
			
			--解析关卡通关
			local tMapSuccess = {}
			local tCmd = hApi.Split(task_mapsuccess_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local mapName = tInfo[1]
				local mapCount = tonumber(tInfo[2]) or 0
				tMapSuccess[#tMapSuccess+1] = {mapName, mapCount,}
				--print("解析关卡通关", mapName, mapCount)
			end
			
			--解析无损关卡通关
			local tMapSuccessNoHurt = {}
			local tCmd = hApi.Split(task_mapsuccess_nohurt_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local mapName = tInfo[1]
				local mapCount = tonumber(tInfo[2]) or 0
				tMapSuccessNoHurt[#tMapSuccessNoHurt+1] = {mapName, mapCount,}
				--print("解析无损关卡通关", mapName, mapCount)
			end
			
			--解析击杀boss
			local tKillBoss = {}
			local tCmd = hApi.Split(task_killboss_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --击杀boss数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local bossId = tonumber(tInfo[1]) or 0
				local bossCount = tonumber(tInfo[2]) or 0
				tKillBoss[#tKillBoss+1] = {bossId, bossCount,}
			end
			
			--解析使用战术卡
			local tUseTactic = {}
			local tCmd = hApi.Split(task_usetactic_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --使用战术卡数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local tacticId = tonumber(tInfo[1]) or 0
				local useCount = tonumber(tInfo[2]) or 0
				tUseTactic[#tUseTactic+1] = {tacticId, useCount,}
			end

			--解析关卡通关难度
			local tMapSuccessDifficulty = {}
			local tCmd = hApi.Split(task_map_success_difficulty_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local mapName = tInfo[1]
				local diffLevel = tonumber(tInfo[2]) or 0
				tMapSuccessDifficulty[#tMapSuccessDifficulty+1] = {mapName, diffLevel,}
				--print("解析关卡通关难度", mapName, diffLevel)
			end
			
			--只下发未完成的任务
			--local nTaskNumUnfinish = 0
			for t = 1, #tTaskInfo, 1 do
				local tTask = tTaskInfo[t]
				local taskId = tTask[1]
				local taskFinishFlag = tTask[2]
				local taskProgress = 0 --任务已完成的进度
				local tabTask = hVar.tab_task[taskId] or {}
				local taskType = tabTask.taskType --任务类型
				local typeId = tabTask.typeId --任务指定的参数
				local taskProgressMax = tabTask.maxProgress --任务总进度
				
				if (taskFinishFlag == 0) then --未完成的任务
					if (taskType == hVar.TASK_TYPE.TASK_DALILY_REWARD) then --每日奖励
						--taskProgress = task_daily
					elseif (taskType == hVar.TASK_TYPE.TASK_SHARE_COUINT) then --分享次数
						taskProgress = task_sharecount
					elseif (taskType == hVar.TASK_TYPE.TASK_TACTICCARD_ONCE) then --商城抽卡
						taskProgress = task_drawcard
					elseif (taskType == hVar.TASK_TYPE.TASK_REDCHEST_ONCE) then --商城抽装
						taskProgress = task_redchest
					elseif (taskType == hVar.TASK_TYPE.TASK_REFRESH_SHOP) then --刷新商店
						taskProgress = task_refreshshop
					elseif (taskType == hVar.TASK_TYPE.TASK_EQUIP_XILIAN) then --百炼成钢
						taskProgress = task_xilian
					elseif (taskType == hVar.TASK_TYPE.TASK_BASE_BATTLE_WIN) then --小试牛刀
						taskProgress = task_battle_pve
					elseif (taskType == hVar.TASK_TYPE.TASK_ENDLESS_SCORE) then --无尽使命
						taskProgress = task_endless
					elseif (taskType == hVar.TASK_TYPE.TASK_QSZD_WAVE) then --前哨阵地波次
						taskProgress = task_qszdwave
					elseif (taskType == hVar.TASK_TYPE.TASK_RANDOMMAP_STAGE) then --随机迷宫层数
						taskProgress = task_randmapstage
					elseif (taskType == hVar.TASK_TYPE.TASK_PVP_OPENCHEST) then --竞技锦囊
						taskProgress = task_pvp_chest
					elseif (taskType == hVar.TASK_TYPE.TASK_PVP_BATTLE) then --竞技切磋
						taskProgress = task_pvp_battle
					elseif (taskType == hVar.TASK_TYPE.TASK_PVPTOKEN_USE) then --兵符达人
						taskProgress = task_pvpcoin
					elseif (taskType == hVar.TASK_TYPE.TASK_OPEN_WEPONCHEST) then --武器宝箱
						taskProgress = task_weaponchest
					elseif (taskType == hVar.TASK_TYPE.TASK_OPEN_TACTICCHEST) then --战术宝箱
						taskProgress = task_tacticchest
					elseif (taskType == hVar.TASK_TYPE.TASK_OPEN_PETCHEST) then --宠物宝箱
						taskProgress = task_petchest
					elseif (taskType == hVar.TASK_TYPE.TASK_OPEN_EQUIPCHEST) then --装备宝箱
						taskProgress = task_equipchest
					elseif (taskType == hVar.TASK_TYPE.TASK_KILL_ENEMY) then --击杀敌人
						taskProgress = task_killenemy
					elseif (taskType == hVar.TASK_TYPE.TASK_KILL_BOSS) then --击杀BOSS
						taskProgress = task_killboss
					elseif (taskType == hVar.TASK_TYPE.TASK_DEADTH) then --战车死亡
						taskProgress = task_deadth
					elseif (taskType == hVar.TASK_TYPE.TASK_USE_TACTIC) then --使用战术卡
						taskProgress = task_usetactic
					elseif (taskType == hVar.TASK_TYPE.TASK_RESCUE_SCIENTIST) then --拯救科学家
						taskProgress = task_scientist
					elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_N) then --通关指定关卡
						--找到指定的关卡
						for i = 1, #tMapSuccess, 1 do
							--print("tMapSuccess[i][1]=", tMapSuccess[i][1])
							--print("typeId=", typeId)
							if (tMapSuccess[i][1] == typeId) then
								taskProgress = tMapSuccess[i][2]
								--print("find  taskProgress =", taskProgress)
							end
						end
					elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N) then --无损通关指定关卡
						--找到指定的无损关卡
						for i = 1, #tMapSuccessNoHurt, 1 do
							if (tMapSuccessNoHurt[i][1] == typeId) then
								taskProgress = tMapSuccessNoHurt[i][2]
							end
						end
					elseif (taskType == hVar.TASK_TYPE.TASK_KILL_BOSS_N) then --击杀指定BOSS
						--找到指定的boss
						for i = 1, #tKillBoss, 1 do
							if (tKillBoss[i][1] == typeId) then
								taskProgress = tKillBoss[i][2]
							end
						end
					elseif (taskType == hVar.TASK_TYPE.TASK_USE_TACTIC_N) then --使用指定战术卡
						--找到指定的战术卡
						for i = 1, #tUseTactic, 1 do
							if (tUseTactic[i][1] == typeId) then
								taskProgress = tUseTactic[i][2]
							end
						end
					elseif (taskType == hVar.TASK_TYPE.TASK_MAX_PET_FOLLOW_AMOUNT) then --最大跟随宠物数量
						taskProgress = task_max_pet_follow_amount
					elseif (taskType == hVar.TASK_TYPE.TASK_USE_CHIP_TO_REFORM_EQUIP_TIMES) then --使用芯片改造装备次数
						taskProgress = task_use_chip_to_reform_equip_times
					elseif (taskType == hVar.TASK_TYPE.TASK_UPGRADE_TACTICAL_CARD_TIMES) then --升级任意战术卡次数
						taskProgress = task_upgrade_tactical_card_times
					elseif (taskType == hVar.TASK_TYPE.TASK_UPGRADE_WEAPON_TIMES) then --升级任意枪塔武器次数
						taskProgress = task_upgrade_weapon_times
					elseif (taskType == hVar.TASK_TYPE.TASK_UPGRADE_PET_TIMES) then --升级任意宠物次数
						taskProgress = task_upgrade_pet_times
					elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_DIFFICULTY_N) then --关卡通关难度
						--找到指定的关卡
						for i = 1, #tMapSuccessDifficulty, 1 do
							if (tMapSuccessDifficulty[i][1] == typeId) then
								taskProgress = tMapSuccessDifficulty[i][2]
							end
						end
					end
					
					nTaskNumUnfinish = nTaskNumUnfinish + 1
					sCmd = sCmd .. tostring(taskId) .. ":" .. tostring(taskFinishFlag) .. ":" .. tostring(taskProgress) .. ":" .. tostring(taskProgressMax) .. ";"
				end
			end
			
			--查询夺塔奇兵免费锦囊今日是否有免费次数
			local nFreeChestCount = 0 --免费锦囊免费次数
			local sQueryM = string.format("SELECT `pvpshop_freechest_lasttime` FROM `t_pvp_user` WHERE `id` = %d", self._rid)
			local errM, pvpshop_freechest_lasttime = xlDb_Query(sQueryM)
			if (errM == 0) then
				--解析免费锦囊今日是否可免费领取
				--转化为服务器上次操作时间的0点天的时间戳
				local nTimestamp = hApi.GetNewDate(pvpshop_freechest_lasttime)
				local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --转字符串(年月日)
				local strNewdate = strDatestampYMD .. " 00:00:00"
				local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1)
				--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
				--今日在有效期内
				if (currenttime >= nTimestampTodayZero) then
					nFreeChestCount = 1
				end
			end
			
			sCmd = tostring(nTaskNumUnfinish) .. ";" .. sCmd .. tostring(nFreeChestCount) .. ";"
		end
		
		--查询任务之石数量
		local nTaskStone = 0
		local sQuery = string.format("SELECT `stone`, `stone_lasttime` from `t_user` where `uid` = %d", self._uid)
		local err, stone, stone_lasttime = xlDb_Query(sQuery)
		--print(sQuery)
		--print(err)
		if (err == 0) then
			nTaskStone = stone
			
			--检测是否同一周
			local nTimestampWeekLast = hApi.GetNewDate(stone_lasttime)
			local strWeekLast = os.date("%Y%W", nTimestampWeekLast)
			local nWeekLast = tonumber(strWeekLast)
			if (nWeekLast ~= self._nWeek) then
				nTaskStone = 0
			end
		end
		sCmd = sCmd .. nTaskStone .. ";"
		
		--周任务领取情况
		local taskstoneNum = 0
		local strTaskStone = ""
		if (type(taskstone_reward) == "string") then
			local tCmd = hApi.Split(taskstone_reward, ";")
			taskstoneNum = tonumber(tCmd[1]) or 0 --周任务领取数量
			if (taskstoneNum > 0) then
				local taskStoneInfo = tCmd[2]
				local tInfo = hApi.Split(taskStoneInfo, ":")
				for i = 1, taskstoneNum, 1 do
					local index = tonumber(tInfo[i]) or 0 --任务id
					strTaskStone = strTaskStone .. tostring(index) .. ":"
				end
			end
		end
		sCmd = sCmd .. taskstoneNum .. ";" .. strTaskStone .. ";"
		
		return sCmd
	end
	
	--增加任务完成次数
	function TaskMgr:AddTaskFinishCount(taskType, addCount)
		--任务对应字段
		local dbkey = hVar.TASK_DBKEY[taskType]
		if dbkey then
			if (addCount > 0) then
				local increaseType = hVar.TASK_INCREASE_TYPE[taskType] --叠加规则
				
				if (increaseType == hVar.TREASURE_ATTR_INCREASE_TYPE.ADD) then --相加
					--更新每日任务
					local sUpdate = string.format("UPDATE `t_user_task` SET `%s` = `%s` + %d where `uid` = %d and `date_yymmdd` = %d", dbkey, dbkey, addCount, self._uid, self._nDate)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
					
					--更新周任务
					local sUpdate = string.format("UPDATE `t_user_task_week` SET `%s` = `%s` + %d where `uid` = %d and `date_week` = %d", dbkey, dbkey, addCount, self._uid, self._nWeek)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
				elseif (increaseType == hVar.TREASURE_ATTR_INCREASE_TYPE.COVER) then --覆盖
					--更新
					local sUpdate = string.format("UPDATE `t_user_task` SET `%s` = %d where `uid` = %d and `date_yymmdd` = %d", dbkey, addCount, self._uid, self._nDate)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
					
					--更新周任务
					local sUpdate = string.format("UPDATE `t_user_task_week` SET `%s` = %d where `uid` = %d and `date_week` = %d", dbkey, dbkey, addCount, self._uid, self._nWeek)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
				elseif (increaseType == hVar.TREASURE_ATTR_INCREASE_TYPE.MIN) then --取较小值
					--更新
					local sUpdate = string.format("UPDATE `t_user_task` SET `%s` = %d where `uid` = %d and `date_yymmdd` = %d and (`%s` > %d)", dbkey, addCount, self._uid, self._nDate, dbkey, addCount)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
					
					--更新周任务
					local sUpdate = string.format("UPDATE `t_user_task_week` SET `%s` = %d where `uid` = %d and `date_week` = %d and (`%s` > %d)", dbkey, addCount, self._uid, self._nWeek, dbkey, addCount)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
				elseif (increaseType == hVar.TREASURE_ATTR_INCREASE_TYPE.MAX) then --取较大值
					--更新
					local sUpdate = string.format("UPDATE `t_user_task` SET `%s` = %d where `uid` = %d and `date_yymmdd` = %d and (`%s` < %d)", dbkey, addCount, self._uid, self._nDate, dbkey, addCount)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
					
					--更新周任务
					local sUpdate = string.format("UPDATE `t_user_task_week` SET `%s` = %d where `uid` = %d and `date_week` = %d and (`%s` < %d)", dbkey, addCount, self._uid, self._nWeek, dbkey, addCount)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
				end
			end
		end
	end
	
	--增加战斗结束的相关任务完成次数
	function TaskMgr:AddTaskBattleResult(tankId, mapName, mapMode, mapDifficulty, nIsWin, nExpAdd, nStar, nScientistNum, nKillEnemyNum, nKillBossNum, nTankDeadthNum, nSufferDmg, nQSZDWave, nRandomMapStage, tTacticInfo, tChestInfo)
		--每日任务
		--任务（新）类型对应的数据库字段
		local sQuery = string.format("SELECT `task`, `task_sharecount`, `task_drawcard`, `task_redchest`, `task_refreshshop`, `task_xilian`, `task_battle_pve`, `task_endless`, `task_qszdwave`, `task_randmapstage`, `task_pvp_chest`, `task_pvp_battle`, `task_pvpcoin`, `task_weaponchest`, `task_tacticchest`, `task_petchest`, `task_equipchest`, `task_killenemy`, `task_killboss`, `task_deadth`, `task_usetactic`, `task_scientist`, `task_mapsuccess_n`, `task_mapsuccess_nohurt_n`, `task_killboss_n`, `task_usetactic_n`, `task_map_success_difficulty_n` from `t_user_task` where `uid` = %d and `date_yymmdd` = %d", self._uid, self._nDate)
		local err, task, task_sharecount, task_drawcard, task_redchest, task_refreshshop, task_xilian, task_battle_pve, task_endless, task_qszdwave, task_randmapstage, task_pvp_chest, task_pvp_battle, task_pvpcoin, task_weaponchest, task_tacticchest, task_petchest, task_equipchest, task_killenemy, task_killboss, task_deadth, task_usetactic, task_scientist, task_mapsuccess_n, task_mapsuccess_nohurt_n, task_killboss_n, task_usetactic_n, task_map_success_difficulty_n = xlDb_Query(sQuery)
		--print(sQuery)
		--print(err)
		if (err == 0) then
			--解析关卡通关
			local tMapSuccess = {}
			local tCmd = hApi.Split(task_mapsuccess_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local mapName = tInfo[1]
				local mapCount = tonumber(tInfo[2]) or 0
				tMapSuccess[#tMapSuccess+1] = {mapName, mapCount,}
			end
			
			--解析无损关卡通关
			local tMapSuccessNoHurt = {}
			local tCmd = hApi.Split(task_mapsuccess_nohurt_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local mapName = tInfo[1]
				local mapCount = tonumber(tInfo[2]) or 0
				tMapSuccessNoHurt[#tMapSuccessNoHurt+1] = {mapName, mapCount,}
			end
			
			--解析击杀boss
			local tKillBoss = {}
			local tCmd = hApi.Split(task_killboss_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --击杀boss数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local bossId = tonumber(tInfo[1]) or 0
				local bossCount = tonumber(tInfo[2]) or 0
				tKillBoss[#tKillBoss+1] = {bossId, bossCount,}
			end
			
			--解析使用战术卡
			local tUseTactic = {}
			local tCmd = hApi.Split(task_usetactic_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --使用战术卡数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local tacticId = tonumber(tInfo[1]) or 0
				local useCount = tonumber(tInfo[2]) or 0
				tUseTactic[#tUseTactic+1] = {tacticId, useCount,}
			end
			
			--解析关卡通关难度
			local tMapSuccessDifficulty = {}
			local tCmd = hApi.Split(task_map_success_difficulty_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local mapName = tInfo[1]
				local diffLevel = tonumber(tInfo[2]) or 0
				tMapSuccessDifficulty[#tMapSuccessDifficulty+1] = {mapName, diffLevel,}
			end
			
			--增加科学家数量
			task_scientist = task_scientist + nScientistNum
			
			--增加杀敌数量
			task_killenemy = task_killenemy + nKillEnemyNum
			
			--增加杀boss数量
			task_killboss = task_killboss + nKillBossNum
			
			--增加战车死亡数量
			task_deadth = task_deadth + nTankDeadthNum
			
			--前哨阵地波次
			if (nQSZDWave > task_qszdwave) then
				task_qszdwave = nQSZDWave
			end
			
			--随机迷宫层数
			if (nRandomMapStage > task_randmapstage) then
				task_randmapstage = nRandomMapStage
			end
			
			--增加关卡胜利次数
			if (nIsWin == 1) then
				local bFind = false
				for i = 1, #tMapSuccess, 1 do
					if (tMapSuccess[i][1] == mapName) then --找到了
						bFind = true
						tMapSuccess[i][2] = tMapSuccess[i][2] + 1
					end
				end
				
				--未找到，放到末尾
				if (not bFind) then
					tMapSuccess[#tMapSuccess+1] = {mapName, 1,}
				end
			end
			
			--增加无损关卡胜利次数
			if (nIsWin == 1) then
				--无损通关
				if (nSufferDmg == 0) then
					local bFind = false
					for i = 1, #tMapSuccessNoHurt, 1 do
						if (tMapSuccessNoHurt[i][1] == mapName) then --找到了
							bFind = true
							tMapSuccessNoHurt[i][2] = tMapSuccessNoHurt[i][2] + 1
						end
					end
					
					--未找到，放到末尾
					if (not bFind) then
						tMapSuccessNoHurt[#tMapSuccessNoHurt+1] = {mapName, 1,}
					end
				end
			end
			
			--增加使用的战术卡
			local tacticTotalNum = 0
			for t = 1, #tTacticInfo, 1 do
				local tacticId = tTacticInfo[t].id
				local tacticNum = tTacticInfo[t].num
				
				--统计总次数
				tacticTotalNum  = tacticTotalNum + tacticNum
				
				local bFind = false
				for i = 1, #tUseTactic, 1 do
					if (tUseTactic[i][1] == tacticId) then --找到了
						bFind = true
						tUseTactic[i][2] = tUseTactic[i][2] + tacticNum
					end
				end
				
				--未找到，放到末尾
				if (not bFind) then
					tUseTactic[#tUseTactic+1] = {tacticId, tacticNum,}
				end
			end
			
			--增加战术卡总次数
			task_usetactic = task_usetactic + tacticTotalNum
			
			--更新最高关卡通关难度
			if (nIsWin == 1) then
				local bFind = false
				for i = 1, #tMapSuccessDifficulty, 1 do
					if (tMapSuccessDifficulty[i][1] == mapName) then --找到了
						bFind = true
						if mapDifficulty > tMapSuccessDifficulty[i][2] then
							tMapSuccessDifficulty[i][2] = mapDifficulty
							break
						end
					end
				end
				
				--未找到，放到末尾
				if (not bFind) then
					tMapSuccessDifficulty[#tMapSuccessDifficulty+1] = {mapName, mapDifficulty,}
				end
			end
			
			--关卡信息转字符串
			local strMapSuccessInfo = ""
			strMapSuccessInfo = strMapSuccessInfo .. tostring(#tMapSuccess) .. ";"
			for i = 1, #tMapSuccess, 1 do
				strMapSuccessInfo = strMapSuccessInfo .. tostring(tMapSuccess[i][1]) .. ":" .. tostring(tMapSuccess[i][2]) .. ";"
			end
			
			--关卡无损通关信息转字符串
			local strMapSuccessNoHurtInfo = ""
			strMapSuccessNoHurtInfo = strMapSuccessNoHurtInfo .. tostring(#tMapSuccessNoHurt) .. ";"
			for i = 1, #tMapSuccessNoHurt, 1 do
				strMapSuccessNoHurtInfo = strMapSuccessNoHurtInfo .. tostring(tMapSuccessNoHurt[i][1]) .. ":" .. tostring(tMapSuccessNoHurt[i][2]) .. ";"
			end
			
			--击杀BOSS信息转字符串
			local strKillBossInfo = ""
			strKillBossInfo = strKillBossInfo .. tostring(#tKillBoss) .. ";"
			for i = 1, #tKillBoss, 1 do
				strKillBossInfo = strKillBossInfo .. tostring(tKillBoss[i][1]) .. ":" .. tostring(tKillBoss[i][2]) .. ";"
			end
			
			--使用战术卡信息转字符串
			local strUseTacticInfo = ""
			strUseTacticInfo = strUseTacticInfo .. tostring(#tUseTactic) .. ";"
			for i = 1, #tUseTactic, 1 do
				strUseTacticInfo = strUseTacticInfo .. tostring(tUseTactic[i][1]) .. ":" .. tostring(tUseTactic[i][2]) .. ";"
			end

			--关卡通关难度信息转字符串
			local strMapSuccessDifficultyInfo = ""
			strMapSuccessDifficultyInfo = strMapSuccessDifficultyInfo .. tostring(#tMapSuccessDifficulty) .. ";"
			for i = 1, #tMapSuccessDifficulty, 1 do
				strMapSuccessDifficultyInfo = strMapSuccessDifficultyInfo .. tostring(tMapSuccessDifficulty[i][1]) .. ":" .. tostring(tMapSuccessDifficulty[i][2]) .. ";"
			end
			
			--更新数据库
			local sUpdate = string.format("UPDATE `t_user_task` SET `task_usetactic` = %d, `task_killenemy` = %d, `task_killboss` = %d, `task_scientist` = %d, `task_deadth` = %d, `task_qszdwave` = %d, `task_randmapstage` = %d, `task_mapsuccess_n` = '%s', `task_mapsuccess_nohurt_n` = '%s', `task_killboss_n` = '%s', `task_usetactic_n` = '%s', `task_map_success_difficulty_n` = '%s' where `uid` = %d and `date_yymmdd` = %d", task_usetactic, task_killenemy, task_killboss, task_scientist, task_deadth, task_qszdwave, task_randmapstage, strMapSuccessInfo, strMapSuccessNoHurtInfo, strKillBossInfo, strUseTacticInfo, strMapSuccessDifficultyInfo, self._uid, self._nDate)
			--print("sUpdate1:",sUpdate)
			xlDb_Execute(sUpdate)
		end
		
		--周任务
		--任务（新）类型对应的数据库字段
		local sQuery = string.format("SELECT `task`, `task_sharecount`, `task_drawcard`, `task_redchest`, `task_refreshshop`, `task_xilian`, `task_battle_pve`, `task_endless`, `task_qszdwave`, `task_randmapstage`, `task_pvp_chest`, `task_pvp_battle`, `task_pvpcoin`, `task_weaponchest`, `task_tacticchest`, `task_petchest`, `task_equipchest`, `task_killenemy`, `task_killboss`, `task_deadth`, `task_usetactic`, `task_scientist`, `task_mapsuccess_n`, `task_mapsuccess_nohurt_n`, `task_killboss_n`, `task_usetactic_n`, `task_map_success_difficulty_n` from `t_user_task_week` where `uid` = %d and `date_week` = %d", self._uid, self._nWeek)
		local err, task, task_sharecount, task_drawcard, task_redchest, task_refreshshop, task_xilian, task_battle_pve, task_endless, task_qszdwave, task_randmapstage, task_pvp_chest, task_pvp_battle, task_pvpcoin, task_weaponchest, task_tacticchest, task_petchest, task_equipchest, task_killenemy, task_killboss, task_deadth, task_usetactic, task_scientist, task_mapsuccess_n, task_mapsuccess_nohurt_n, task_killboss_n, task_usetactic_n, task_map_success_difficulty_n = xlDb_Query(sQuery)
		--print(sQuery)
		--print(err)
		if (err == 0) then
			--解析关卡通关
			local tMapSuccess = {}
			local tCmd = hApi.Split(task_mapsuccess_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local mapName = tInfo[1]
				local mapCount = tonumber(tInfo[2]) or 0
				tMapSuccess[#tMapSuccess+1] = {mapName, mapCount,}
			end
			
			--解析无损关卡通关
			local tMapSuccessNoHurt = {}
			local tCmd = hApi.Split(task_mapsuccess_nohurt_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local mapName = tInfo[1]
				local mapCount = tonumber(tInfo[2]) or 0
				tMapSuccessNoHurt[#tMapSuccessNoHurt+1] = {mapName, mapCount,}
			end
			
			--解析击杀boss
			local tKillBoss = {}
			local tCmd = hApi.Split(task_killboss_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --击杀boss数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local bossId = tonumber(tInfo[1]) or 0
				local bossCount = tonumber(tInfo[2]) or 0
				tKillBoss[#tKillBoss+1] = {bossId, bossCount,}
			end
			
			--解析使用战术卡
			local tUseTactic = {}
			local tCmd = hApi.Split(task_usetactic_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --使用战术卡数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local tacticId = tonumber(tInfo[1]) or 0
				local useCount = tonumber(tInfo[2]) or 0
				tUseTactic[#tUseTactic+1] = {tacticId, useCount,}
			end
			
			--解析关卡通关难度
			local tMapSuccessDifficulty = {}
			local tCmd = hApi.Split(task_map_success_difficulty_n, ";")
			local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
			for i = 1, mapNum, 1 do
				local tInfo = hApi.Split(tCmd[i+1], ":")
				local mapName = tInfo[1]
				local diffLevel = tonumber(tInfo[2]) or 0
				tMapSuccessDifficulty[#tMapSuccessDifficulty+1] = {mapName, diffLevel,}
			end
			
			--增加科学家数量
			task_scientist = task_scientist + nScientistNum
			
			--增加杀敌数量
			task_killenemy = task_killenemy + nKillEnemyNum
			
			--增加杀boss数量
			task_killboss = task_killboss + nKillBossNum
			
			--增加战车死亡数量
			task_deadth = task_deadth + nTankDeadthNum
			
			--前哨阵地波次
			if (nQSZDWave > task_qszdwave) then
				task_qszdwave = nQSZDWave
			end
			
			--随机迷宫层数
			if (nRandomMapStage > task_randmapstage) then
				task_randmapstage = nRandomMapStage
			end
			
			--增加关卡胜利次数
			if (nIsWin == 1) then
				local bFind = false
				for i = 1, #tMapSuccess, 1 do
					if (tMapSuccess[i][1] == mapName) then --找到了
						bFind = true
						tMapSuccess[i][2] = tMapSuccess[i][2] + 1
					end
				end
				
				--未找到，放到末尾
				if (not bFind) then
					tMapSuccess[#tMapSuccess+1] = {mapName, 1,}
				end
			end
			
			--增加无损关卡胜利次数
			if (nIsWin == 1) then
				--无损通关
				if (nSufferDmg == 0) then
					local bFind = false
					for i = 1, #tMapSuccessNoHurt, 1 do
						if (tMapSuccessNoHurt[i][1] == mapName) then --找到了
							bFind = true
							tMapSuccessNoHurt[i][2] = tMapSuccessNoHurt[i][2] + 1
						end
					end
					
					--未找到，放到末尾
					if (not bFind) then
						tMapSuccessNoHurt[#tMapSuccessNoHurt+1] = {mapName, 1,}
					end
				end
			end
			
			--增加使用的战术卡
			local tacticTotalNum = 0
			for t = 1, #tTacticInfo, 1 do
				local tacticId = tTacticInfo[t].id
				local tacticNum = tTacticInfo[t].num
				
				--统计总次数
				tacticTotalNum  = tacticTotalNum + tacticNum
				
				local bFind = false
				for i = 1, #tUseTactic, 1 do
					if (tUseTactic[i][1] == tacticId) then --找到了
						bFind = true
						tUseTactic[i][2] = tUseTactic[i][2] + tacticNum
					end
				end
				
				--未找到，放到末尾
				if (not bFind) then
					tUseTactic[#tUseTactic+1] = {tacticId, tacticNum,}
				end
			end
			
			--增加战术卡总次数
			task_usetactic = task_usetactic + tacticTotalNum
			
			--更新最高关卡通关难度
			if (nIsWin == 1) then
				local bFind = false
				for i = 1, #tMapSuccessDifficulty, 1 do
					if (tMapSuccessDifficulty[i][1] == mapName) then --找到了
						bFind = true
						if mapDifficulty > tMapSuccessDifficulty[i][2] then
							tMapSuccessDifficulty[i][2] = mapDifficulty
							break
						end
					end
				end
				
				--未找到，放到末尾
				if (not bFind) then
					tMapSuccessDifficulty[#tMapSuccessDifficulty+1] = {mapName, mapDifficulty,}
				end
			end
			
			--关卡信息转字符串
			local strMapSuccessInfo = ""
			strMapSuccessInfo = strMapSuccessInfo .. tostring(#tMapSuccess) .. ";"
			for i = 1, #tMapSuccess, 1 do
				strMapSuccessInfo = strMapSuccessInfo .. tostring(tMapSuccess[i][1]) .. ":" .. tostring(tMapSuccess[i][2]) .. ";"
			end
			
			--关卡无损通关信息转字符串
			local strMapSuccessNoHurtInfo = ""
			strMapSuccessNoHurtInfo = strMapSuccessNoHurtInfo .. tostring(#tMapSuccessNoHurt) .. ";"
			for i = 1, #tMapSuccessNoHurt, 1 do
				strMapSuccessNoHurtInfo = strMapSuccessNoHurtInfo .. tostring(tMapSuccessNoHurt[i][1]) .. ":" .. tostring(tMapSuccessNoHurt[i][2]) .. ";"
			end
			
			--击杀BOSS信息转字符串
			local strKillBossInfo = ""
			strKillBossInfo = strKillBossInfo .. tostring(#tKillBoss) .. ";"
			for i = 1, #tKillBoss, 1 do
				strKillBossInfo = strKillBossInfo .. tostring(tKillBoss[i][1]) .. ":" .. tostring(tKillBoss[i][2]) .. ";"
			end
			
			--使用战术卡信息转字符串
			local strUseTacticInfo = ""
			strUseTacticInfo = strUseTacticInfo .. tostring(#tUseTactic) .. ";"
			for i = 1, #tUseTactic, 1 do
				strUseTacticInfo = strUseTacticInfo .. tostring(tUseTactic[i][1]) .. ":" .. tostring(tUseTactic[i][2]) .. ";"
			end

			--关卡通关难度信息转字符串
			local strMapSuccessDifficultyInfo = ""
			strMapSuccessDifficultyInfo = strMapSuccessDifficultyInfo .. tostring(#tMapSuccessDifficulty) .. ";"
			for i = 1, #tMapSuccessDifficulty, 1 do
				strMapSuccessDifficultyInfo = strMapSuccessDifficultyInfo .. tostring(tMapSuccessDifficulty[i][1]) .. ":" .. tostring(tMapSuccessDifficulty[i][2]) .. ";"
			end
			
			--更新数据库
			local sUpdate = string.format("UPDATE `t_user_task_week` SET `task_usetactic` = %d, `task_killenemy` = %d, `task_killboss` = %d, `task_scientist` = %d, `task_deadth` = %d, `task_qszdwave` = %d, `task_randmapstage` = %d, `task_mapsuccess_n` = '%s', `task_mapsuccess_nohurt_n` = '%s', `task_killboss_n` = '%s', `task_usetactic_n` = '%s', `task_map_success_difficulty_n` = '%s' where `uid` = %d and `date_week` = %d", task_usetactic, task_killenemy, task_killboss, task_scientist, task_deadth, task_qszdwave, task_randmapstage, strMapSuccessInfo, strMapSuccessNoHurtInfo, strKillBossInfo, strUseTacticInfo, strMapSuccessDifficultyInfo,  self._uid, self._nWeek)
			--print("sUpdate1:",sUpdate)
			xlDb_Execute(sUpdate)
		end
	end
	
	--领取指定的任务奖励
	function TaskMgr:TaskTakeReward(taskId)
		local ret = 0
		local sCmd = ""
		
		local tabTask = hVar.tab_task[taskId] or {}
		local taskType = tabTask.taskType --任务类型
		local taskProgressMax = tabTask.maxProgress --任务总进度
		local taskProgress = 0 --任务已完成的进度
		local reward = tabTask.reward --任务奖励
		local typeId = tabTask.typeId --任务指定的参数
		local dailyType = tabTask.dailyType --认为日期类型
		local dbkey = hVar.TASK_DBKEY[taskType]
		
		if dbkey then
			--查询任务和完成情况
			local tTaskInfo = {}
			
			--任务（新）类型对应的数据库字段
			local sQuery = ""
			if (dailyType == hVar.TASK_DAILY_TYPE.DAY) then --每日任务
				sQuery = string.format("SELECT `task`, `%s` from `t_user_task` where `uid` = %d and `date_yymmdd` = %d", dbkey, self._uid, self._nDate)
			elseif (dailyType == hVar.TASK_DAILY_TYPE.WEEK) then --周任务
				sQuery = string.format("SELECT `task`, `%s` from `t_user_task_week` where `uid` = %d and `date_week` = %d", dbkey, self._uid, self._nWeek)
			end
			local err, task, task_progress = xlDb_Query(sQuery)
			--print(sQuery)
			--print(err)
			if (err == 0) then
				local tCmd = hApi.Split(task, ";")
				local taskNum = tonumber(tCmd[1]) or 0 --任务数量
				if (taskNum > 0) then
					local rIdx = 1
					for i = 1, taskNum, 1 do
						local taskInfo = tCmd[rIdx+i]
						local tInfo = hApi.Split(taskInfo, ":")
						local taskId = tonumber(tInfo[1]) or 0 --任务id
						local taskFinishFlag = tonumber(tInfo[2]) or 0 --任务完成情况
						--print(i, "taskId="..taskId, "finish=", taskFinishFlag)
						
						tTaskInfo[#tTaskInfo+1] = {taskId, taskFinishFlag,}
					end
					
					--检测任务是否未领取
					local taskIdx = 0
					for i = 1, taskNum, 1 do
						local tTask = tTaskInfo[i]
						if (tTask[1] == taskId) then --找到了
							taskIdx = i
							break
						end
					end
					if (taskIdx > 0) then
						local tTaskI = tTaskInfo[taskIdx]
						local taskFinishFlag = tTaskI[2] --任务完成情况
						if (taskFinishFlag == 0) then
							--处理一些特殊的任务进度
							if (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_N) then --通关指定关卡
								--解析关卡通关
								local tMapSuccess = {}
								local tCmd = hApi.Split(task_progress, ";")
								local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
								--print("task_progress=", task_progress)
								for i = 1, mapNum, 1 do
									local tInfo = hApi.Split(tCmd[i+1], ":")
									local mapName = tInfo[1]
									local mapCount = tonumber(tInfo[2]) or 0
									tMapSuccess[#tMapSuccess+1] = {mapName, mapCount,}
									--print("mapName=", mapName, "mapCount=", mapCount)
								end
								
								--找到指定的关卡
								local bFind = false
								for i = 1, #tMapSuccess, 1 do
									--print(i, tMapSuccess[i][1], typeId)
									if (tMapSuccess[i][1] == typeId) then --找到了
										--print("find")
										bFind = true
										task_progress = tMapSuccess[i][2]
										--print("task_progress=", tMapSuccess[i][2])
									end
								end
								
								--未找到
								if (not bFind) then
									task_progress = 0
								end
							elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N) then --无损通关指定关卡
								--解析关卡无损通关
								local tMapSuccessNoHurt = {}
								local tCmd = hApi.Split(task_progress, ";")
								local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
								--print("task_progress=", task_progress)
								for i = 1, mapNum, 1 do
									local tInfo = hApi.Split(tCmd[i+1], ":")
									local mapName = tInfo[1]
									local mapCount = tonumber(tInfo[2]) or 0
									tMapSuccessNoHurt[#tMapSuccessNoHurt+1] = {mapName, mapCount,}
									--print("mapName=", mapName, "mapCount=", mapCount)
								end
								
								--找到指定的无损关卡
								local bFind = false
								for i = 1, #tMapSuccessNoHurt, 1 do
									--print(i, tMapSuccessNoHurt[i][1], typeId)
									if (tMapSuccessNoHurt[i][1] == typeId) then --找到了
										--print("find")
										bFind = true
										task_progress = tMapSuccessNoHurt[i][2]
										--print("task_progress=", tMapSuccessNoHurt[i][2])
									end
								end
								
								--未找到
								if (not bFind) then
									task_progress = 0
								end
							elseif (taskType == hVar.TASK_TYPE.TASK_KILL_BOSS_N) then --击杀指定BOSS
								--解析击杀boss
								local tKillBoss = {}
								local tCmd = hApi.Split(task_progress, ";")
								local mapNum = tonumber(tCmd[1]) or 0 --击杀boss数量
								for i = 1, mapNum, 1 do
									local tInfo = hApi.Split(tCmd[i+1], ":")
									local bossId = tonumber(tInfo[1]) or 0
									local bossCount = tonumber(tInfo[2]) or 0
									tKillBoss[#tKillBoss+1] = {bossId, bossCount,}
								end
								
								--找到指定的boss
								local bFind = false
								for i = 1, #tKillBoss, 1 do
									if (tKillBoss[i][1] == typeId) then --找到了
										bFind = true
										task_progress = tKillBoss[i][2]
									end
								end
								
								--未找到
								if (not bFind) then
									task_progress = 0
								end
							elseif (taskType == hVar.TASK_TYPE.TASK_USE_TACTIC_N) then --使用指定战术卡
								--解析使用战术卡
								local tUseTactic = {}
								local tCmd = hApi.Split(task_progress, ";")
								local mapNum = tonumber(tCmd[1]) or 0 --使用战术卡数量
								for i = 1, mapNum, 1 do
									local tInfo = hApi.Split(tCmd[i+1], ":")
									local tacticId = tonumber(tInfo[1]) or 0
									local useCount = tonumber(tInfo[2]) or 0
									tUseTactic[#tUseTactic+1] = {tacticId, useCount,}
								end
								
								--找到指定的战术卡
								local bFind = false
								for i = 1, #tUseTactic, 1 do
									if (tUseTactic[i][1] == typeId) then --找到了
										bFind = true
										task_progress = tUseTactic[i][2]
									end
								end
								
								--未找到
								if (not bFind) then
									task_progress = 0
								end
							elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_DIFFICULTY_N) then --通关指定关卡难度
								--解析关卡通关难度
								local tMapSuccessDifficulty = {}
								local tCmd = hApi.Split(task_progress, ";")
								local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
								--print("task_progress=", task_progress)
								for i = 1, mapNum, 1 do
									local tInfo = hApi.Split(tCmd[i+1], ":")
									local mapName = tInfo[1]
									local diffLevel = tonumber(tInfo[2]) or 0
									tMapSuccessDifficulty[#tMapSuccessDifficulty+1] = {mapName, diffLevel,}
									--print("mapName=", mapName, "mapCount=", mapCount)
								end
								
								--找到指定的关卡
								local bFind = false
								for i = 1, #tMapSuccessDifficulty, 1 do
									--print(i, tMapSuccessDifficulty[i][1], typeId)
									if (tMapSuccessDifficulty[i][1] == typeId) then --找到了
										--print("find")
										bFind = true
										task_progress = tMapSuccessDifficulty[i][2]
										break
										--print("task_progress=", tMapSuccessDifficulty[i][2])
									end
								end
								
								--未找到
								if (not bFind) then
									task_progress = 0
								end
							end
							
							if (task_progress >= taskProgressMax) then --已达成条件
								--领取奖励
								local prizeType = 20008 --奖励类型
								local detail = ""
								detail = detail .. (hVar.tab_stringTask[taskId] or hVar.tab_stringTask[0]) .. ";"
								for r = 1, #reward, 1 do
									local tReward = reward[r]
									detail = detail .. (tReward[1] or 0) .. ":" .. (tReward[2] or 0) .. ":" .. (tReward[3] or 0) .. ":" .. (tReward[4] or 0) .. ";"
								end
								
								--发奖
								local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",self._uid,prizeType,detail,0,0)
								xlDb_Execute(sInsert)
								
								--奖励id
								local err1, pid = xlDb_Query("select last_insert_id()")
								if (err1 == 0) then
									--存储奖励信息
									local prizeId = pid --奖励id
									
									--服务器发奖
									local fromIdx = 2
									local prizeContent = hApi.GetRewardInPrize(self._uid, self._rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
									sCmd = sCmd .. prizeContent
								end
								
								--处理服务器抽卡类型的奖励，再发一封邮件
								for r = 1, #reward, 1 do
									local tReward = reward[r]
									local rewardType = tReward[1] or 0
									if (rewardType == 13) then --13:服务器抽卡
										local prizeType2 = 20028 --奖励类型
										local detail2 = string.format(hVar.tab_string["__TEXT_TASK_REWARD_DRAWCARD"], hVar.tab_stringTask[taskId] or hVar.tab_stringTask[0], tostring(tReward[1] or 0) .. ":" .. tostring(tReward[2] or 0) .. ":" .. tostring(tReward[3] or 0) .. ":" .. tostring(tReward[4] or 0) .. ";")
										--发奖
										local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",self._uid,prizeType2,detail2,0,0)
										xlDb_Execute(sInsert)
									end
								end
								
								--标记任务已领取奖励
								tTaskI[2] = 1
								
								--更新任务信息
								local sTask = tostring(#tTaskInfo) .. ";"
								for t = 1, #tTaskInfo, 1 do
									local tTask = tTaskInfo[t]
									sTask = sTask .. tostring(tTask[1]) .. ":" .. tostring(tTask[2]) .. ";"
								end
								local sUpdate = ""
								if (dailyType == hVar.TASK_DAILY_TYPE.DAY) then --每日任务
									sUpdate = string.format("UPDATE `t_user_task` SET `task` = '%s' where `uid` = %d and `date_yymmdd` = %d", sTask, self._uid, self._nDate)
								elseif (dailyType == hVar.TASK_DAILY_TYPE.WEEK) then --周任务
									sUpdate = string.format("UPDATE `t_user_task_week` SET `task` = '%s' where `uid` = %d and `date_week` = %d", sTask, self._uid, self._nWeek)
								end
								--print("sUpdate1:",sUpdate)
								xlDb_Execute(sUpdate)
								
								--操作成功
								ret = 1
							else
								ret = -5 --未满足领取条件
							end
						else
							ret = -4 --任务已完成
						end
					else
						ret = -3 --无效的任务id
					end
				else
					ret = -2 --任务未完成
				end
			else
				ret = -2 --任务未完成
			end
		else
			ret = -1 --无效的参数
		end
		
		sCmd = tostring(ret) .. ";" .. tostring(taskId) .. ";" .. sCmd
		
		return sCmd
	end
	
	--一键领取全部已达成的任务奖励
	function TaskMgr:TaskTakeAllReward()
		local ret = 0
		local sCmd = ""
		local nFinishCount = 0
		
		--查询任务和完成情况
		local tTaskInfo = {}
		
		--任务（新）类型对应的数据库字段
		local sQuery = string.format("SELECT `task`, `task_sharecount`, `task_drawcard`, `task_redchest`, `task_refreshshop`, `task_xilian`, `task_battle_pve`, `task_endless`, `task_qszdwave`, `task_randmapstage`, `task_pvp_chest`, `task_pvp_battle`, `task_pvpcoin`, `task_weaponchest`, `task_tacticchest`, `task_petchest`, `task_equipchest`, `task_killenemy`, `task_killboss`, `task_deadth`, `task_usetactic`, `task_scientist`, `task_mapsuccess_n`, `task_mapsuccess_nohurt_n`, `task_killboss_n`, `task_usetactic_n`, `task_max_pet_follow_amount`, `task_use_chip_to_reform_equip_times`, `task_upgrade_tactical_card_times`, `task_upgrade_weapon_times`, `task_upgrade_pet_times`, `task_map_success_difficulty_n` from `t_user_task` where `uid` = %d and `date_yymmdd` = %d", self._uid, self._nDate)
		local err, task, task_sharecount, task_drawcard, task_redchest, task_refreshshop, task_xilian, task_battle_pve, task_endless, task_qszdwave, task_randmapstage, task_pvp_chest, task_pvp_battle, task_pvpcoin, task_weaponchest, task_tacticchest, task_petchest, task_equipchest, task_killenemy, task_killboss, task_deadth, task_usetactic, task_scientist, task_mapsuccess_n, task_mapsuccess_nohurt_n, task_killboss_n, task_usetactic_n, task_max_pet_follow_amount, task_use_chip_to_reform_equip_times, task_upgrade_tactical_card_times, task_upgrade_weapon_times, task_upgrade_pet_times, task_map_success_difficulty_n = xlDb_Query(sQuery)
		--print(sQuery)
		--print(err)
		if (err == 0) then
			local tCmd = hApi.Split(task, ";")
			local taskNum = tonumber(tCmd[1]) or 0 --任务数量
			if (taskNum > 0) then
				local rIdx = 1
				for i = 1, taskNum, 1 do
					local taskInfo = tCmd[rIdx+i]
					local tInfo = hApi.Split(taskInfo, ":")
					local taskId = tonumber(tInfo[1]) or 0 --任务id
					local taskFinishFlag = tonumber(tInfo[2]) or 0 --任务完成情况
					--print(i, "taskId="..taskId, "finish=", taskFinishFlag)
					
					tTaskInfo[#tTaskInfo+1] = {taskId, taskFinishFlag,}
				end
				
				--解析关卡通关
				local tMapSuccess = {}
				local tCmd = hApi.Split(task_mapsuccess_n, ";")
				local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
				for i = 1, mapNum, 1 do
					local tInfo = hApi.Split(tCmd[i+1], ":")
					local mapName = tInfo[1]
					local mapCount = tonumber(tInfo[2]) or 0
					tMapSuccess[#tMapSuccess+1] = {mapName, mapCount,}
				end
				
				--解析无损关卡通关
				local tMapSuccessNoHurt = {}
				local tCmd = hApi.Split(task_mapsuccess_nohurt_n, ";")
				local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
				for i = 1, mapNum, 1 do
					local tInfo = hApi.Split(tCmd[i+1], ":")
					local mapName = tInfo[1]
					local mapCount = tonumber(tInfo[2]) or 0
					tMapSuccessNoHurt[#tMapSuccessNoHurt+1] = {mapName, mapCount,}
				end
				
				--解析击杀boss
				local tKillBoss = {}
				local tCmd = hApi.Split(task_killboss_n, ";")
				local mapNum = tonumber(tCmd[1]) or 0 --击杀boss数量
				for i = 1, mapNum, 1 do
					local tInfo = hApi.Split(tCmd[i+1], ":")
					local bossId = tonumber(tInfo[1]) or 0
					local bossCount = tonumber(tInfo[2]) or 0
					tKillBoss[#tKillBoss+1] = {bossId, bossCount,}
				end
				
				--解析使用战术卡
				local tUseTactic = {}
				local tCmd = hApi.Split(task_usetactic_n, ";")
				local mapNum = tonumber(tCmd[1]) or 0 --使用战术卡数量
				for i = 1, mapNum, 1 do
					local tInfo = hApi.Split(tCmd[i+1], ":")
					local tacticId = tonumber(tInfo[1]) or 0
					local useCount = tonumber(tInfo[2]) or 0
					tUseTactic[#tUseTactic+1] = {tacticId, useCount,}
				end
				
				--解析关卡通关
				local tMapSuccessDifficulty = {}
				local tCmd = hApi.Split(task_map_success_difficulty_n, ";")
				local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
				for i = 1, mapNum, 1 do
					local tInfo = hApi.Split(tCmd[i+1], ":")
					local mapName = tInfo[1]
					local diffLevel = tonumber(tInfo[2]) or 0
					tMapSuccessDifficulty[#tMapSuccessDifficulty+1] = {mapName, diffLevel,}
				end
				
				--只处理未领取并且已达成的任务
				for t = 1, #tTaskInfo, 1 do
					local tTaskI = tTaskInfo[t]
					local taskId = tTaskI[1]
					local taskFinishFlag = tTaskI[2]
					local taskProgress = 0 --任务已完成的进度
					local tabTask = hVar.tab_task[taskId] or {}
					local taskType = tabTask.taskType --任务类型
					local taskProgressMax = tabTask.maxProgress --任务总进度
					local reward = tabTask.reward --任务奖励
					local typeId = tabTask.typeId --任务指定的参数
					
					if (taskFinishFlag == 0) then --未完成的任务
						if (taskType == hVar.TASK_TYPE.TASK_DALILY_REWARD) then --每日奖励
							--taskProgress = task_daily
						elseif (taskType == hVar.TASK_TYPE.TASK_SHARE_COUINT) then --分享次数
							taskProgress = task_sharecount
						elseif (taskType == hVar.TASK_TYPE.TASK_TACTICCARD_ONCE) then --商城抽卡
							taskProgress = task_drawcard
						elseif (taskType == hVar.TASK_TYPE.TASK_REDCHEST_ONCE) then --商城抽装
							taskProgress = task_redchest
						elseif (taskType == hVar.TASK_TYPE.TASK_REFRESH_SHOP) then --刷新商店
							taskProgress = task_refreshshop
						elseif (taskType == hVar.TASK_TYPE.TASK_EQUIP_XILIAN) then --百炼成钢
							taskProgress = task_xilian
						elseif (taskType == hVar.TASK_TYPE.TASK_BASE_BATTLE_WIN) then --小试牛刀
							taskProgress = task_battle_pve
						elseif (taskType == hVar.TASK_TYPE.TASK_ENDLESS_SCORE) then --无尽使命
							taskProgress = task_endless
						elseif (taskType == hVar.TASK_TYPE.TASK_QSZD_WAVE) then --前哨阵地波次
							taskProgress = task_qszdwave
						elseif (taskType == hVar.TASK_TYPE.TASK_RANDOMMAP_STAGE) then --随机迷宫层数
							taskProgress = task_randmapstage
						elseif (taskType == hVar.TASK_TYPE.TASK_PVP_OPENCHEST) then --竞技锦囊
							taskProgress = task_pvp_chest
						elseif (taskType == hVar.TASK_TYPE.TASK_PVP_BATTLE) then --竞技切磋
							taskProgress = task_pvp_battle
						elseif (taskType == hVar.TASK_TYPE.TASK_PVPTOKEN_USE) then --兵符达人
							taskProgress = task_pvpcoin
						elseif (taskType == hVar.TASK_TYPE.TASK_OPEN_WEPONCHEST) then --武器宝箱
							taskProgress = task_weaponchest
						elseif (taskType == hVar.TASK_TYPE.TASK_OPEN_TACTICCHEST) then --战术宝箱
							taskProgress = task_tacticchest
						elseif (taskType == hVar.TASK_TYPE.TASK_OPEN_PETCHEST) then --宠物宝箱
							taskProgress = task_petchest
						elseif (taskType == hVar.TASK_TYPE.TASK_OPEN_EQUIPCHEST) then --装备宝箱
							taskProgress = task_equipchest
						elseif (taskType == hVar.TASK_TYPE.TASK_KILL_ENEMY) then --击杀敌人
							taskProgress = task_killenemy
						elseif (taskType == hVar.TASK_TYPE.TASK_KILL_BOSS) then --击杀BOSS
							taskProgress = task_killboss
						elseif (taskType == hVar.TASK_TYPE.TASK_DEADTH) then --战车死亡
							taskProgress = task_deadth
						elseif (taskType == hVar.TASK_TYPE.TASK_USE_TACTIC) then --使用战术卡
							taskProgress = task_usetactic
						elseif (taskType == hVar.TASK_TYPE.TASK_RESCUE_SCIENTIST) then --拯救科学家
							taskProgress = task_scientist
						elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_N) then --通关指定关卡
							--找到指定的关卡
							for i = 1, #tMapSuccess, 1 do
								if (tMapSuccess[i][1] == typeId) then
									taskProgress = tMapSuccess[i][2]
								end
							end
						elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N) then --无损通关指定关卡
							--找到指定的无损关卡
							for i = 1, #tMapSuccessNoHurt, 1 do
								if (tMapSuccessNoHurt[i][1] == typeId) then
									taskProgress = tMapSuccessNoHurt[i][2]
								end
							end
						elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N) then --无损通关指定关卡
							--找到指定的无损关卡
							for i = 1, #tMapSuccessNoHurt, 1 do
								if (tMapSuccessNoHurt[i][1] == typeId) then
									taskProgress = tMapSuccessNoHurt[i][2]
								end
							end
						elseif (taskType == hVar.TASK_TYPE.TASK_KILL_BOSS_N) then --击杀指定BOSS
							--找到指定的boss
							for i = 1, #tKillBoss, 1 do
								if (tKillBoss[i][1] == typeId) then
									taskProgress = tKillBoss[i][2]
								end
							end
						elseif (taskType == hVar.TASK_TYPE.TASK_USE_TACTIC_N) then --使用指定战术卡
							--找到指定的战术卡
							for i = 1, #tUseTactic, 1 do
								if (tUseTactic[i][1] == typeId) then
									taskProgress = tUseTactic[i][2]
								end
							end
						elseif (taskType == hVar.TASK_TYPE.TASK_MAX_PET_FOLLOW_AMOUNT) then --最大跟随宠物数量
							taskProgress = task_max_pet_follow_amount
						elseif (taskType == hVar.TASK_TYPE.TASK_USE_CHIP_TO_REFORM_EQUIP_TIMES) then --使用芯片改造装备次数
							taskProgress = task_use_chip_to_reform_equip_times
						elseif (taskType == hVar.TASK_TYPE.TASK_UPGRADE_TACTICAL_CARD_TIMES) then --升级任意战术卡次数
							taskProgress = task_upgrade_tactical_card_times
						elseif (taskType == hVar.TASK_TYPE.TASK_UPGRADE_WEAPON_TIMES) then --升级任意枪塔武器次数
							taskProgress = task_upgrade_weapon_times
						elseif (taskType == hVar.TASK_TYPE.TASK_UPGRADE_PET_TIMES) then --升级任意宠物次数
							taskProgress = task_upgrade_pet_times
						elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_DIFFICULTY_N) then --关卡通关难度
							--找到指定的关卡
							for i = 1, #tMapSuccessDifficulty, 1 do
								if (tMapSuccessDifficulty[i][1] == typeId) then
									taskProgress = tMapSuccessDifficulty[i][2]
								end
							end
						end
						
						if (taskProgress >= taskProgressMax) then --已达成
							--发奖
							--领取奖励
							local prizeType = 20008 --奖励类型
							local detail = ""
							detail = detail .. (hVar.tab_stringTask[taskId] or hVar.tab_stringTask[0]) .. ";"
							for r = 1, #reward, 1 do
								local tReward = reward[r]
								detail = detail .. tostring(tReward[1] or 0) .. ":" .. tostring(tReward[2] or 0) .. ":" .. tostring(tReward[3] or 0) .. ":" .. tostring(tReward[4] or 0) .. ";"
							end
							
							--发奖
							local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",self._uid,prizeType,detail,0,0)
							xlDb_Execute(sInsert)
							
							--奖励id
							local err1, pid = xlDb_Query("select last_insert_id()")
							if (err1 == 0) then
								--存储奖励信息
								local prizeId = pid --奖励id
								
								--服务器发奖
								local fromIdx = 2
								local prizeContent = hApi.GetRewardInPrize(self._uid, self._rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
								sCmd = sCmd .. prizeContent
							end
							
							--处理服务器抽卡类型的奖励，再发一封邮件
							for r = 1, #reward, 1 do
								local tReward = reward[r]
								local rewardType = tReward[1] or 0
								if (rewardType == 13) then --13:服务器抽卡
									local prizeType2 = 20028 --奖励类型
									local detail2 = string.format(hVar.tab_string["__TEXT_TASK_REWARD_DRAWCARD"], (hVar.tab_stringTask[taskId] or hVar.tab_stringTask[0]), tostring(tReward[1] or 0) .. ":" .. tostring(tReward[2] or 0) .. ":" .. tostring(tReward[3] or 0) .. ":" .. tostring(tReward[4] or 0) .. ";")
									--发奖
									local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",self._uid,prizeType2,detail2,0,0)
									xlDb_Execute(sInsert)
								end
							end
							
							--标记任务已领取奖励
							tTaskI[2] = 1
							
							--统计数量
							nFinishCount = nFinishCount + 1
						end
					end
				end
				
				--更新任务信息
				if (nFinishCount > 0) then
					local sTask = tostring(#tTaskInfo) .. ";"
					for t = 1, #tTaskInfo, 1 do
						local tTask = tTaskInfo[t]
						sTask = sTask .. tostring(tTask[1]) .. ":" .. tostring(tTask[2]) .. ";"
					end
					local sUpdate = string.format("UPDATE `t_user_task` SET `task` = '%s' where `uid` = %d and `date_yymmdd` = %d", sTask, self._uid, self._nDate)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
					
					--操作成功
					ret = 1
				end
			end
		end
		
		sCmd = tostring(ret) .. ";" .. tostring(nFinishCount) .. ";" .. sCmd
		
		return sCmd
	end
	
	--检测是否邮件补发昨日任务奖励
	function TaskMgr:__TaskTakeYesterdayReward()
		local strDate = tostring(self._nDate)
		local strYear = string.sub(strDate, 1, 4)
		local strMonth = string.sub(strDate, 5, 6)
		local strDay = string.sub(strDate, 7, 8)
		local strToday = strYear .. "-" .. strMonth .. "-" .. strDay .. " 00:00:00"
		local nTimestampYestardayZero = hApi.GetNewDate(strToday, "DAY", -1) --昨日0点
		--日期转年月日
		local strDateYestarday = os.date("%Y%m%d", nTimestampYestardayZero)
		local nDateYestarday = tonumber(strDateYestarday)
		--print("nDateYestarday=", nDateYestarday)
		
		--查询昨日任务的完成情况
		local nFinishCountYesterday = 0
		local tTaskInfoYesterday = {}
		local rewardYesterday = hClass.Reward:create():Init()
		local rewardYesterday_Drawcard = hClass.Reward:create():Init()
		local rewardYesterday_Drawcard_taskId = 0
		
		--查询昨日任务（新）类型对应的数据库字段
		local sQuery = string.format("SELECT `task`, `task_sharecount`, `task_drawcard`, `task_redchest`, `task_refreshshop`, `task_xilian`, `task_battle_pve`, `task_endless`, `task_qszdwave`, `task_randmapstage`, `task_pvp_chest`, `task_pvp_battle`, `task_pvpcoin`, `task_weaponchest`, `task_tacticchest`, `task_petchest`, `task_equipchest`, `task_killenemy`, `task_killboss`, `task_deadth`, `task_usetactic`, `task_scientist`, `task_mapsuccess_n`, `task_mapsuccess_nohurt_n`, `task_killboss_n`, `task_usetactic_n`, `task_max_pet_follow_amount`, `task_use_chip_to_reform_equip_times`, `task_upgrade_tactical_card_times`, `task_upgrade_weapon_times`, `task_upgrade_pet_times`, `task_map_success_difficulty_n` from `t_user_task` where `uid` = %d and `date_yymmdd` = %d", self._uid, nDateYestarday)
		local err, task, task_sharecount, task_drawcard, task_redchest, task_refreshshop, task_xilian, task_battle_pve, task_endless, task_qszdwave, task_randmapstage, task_pvp_chest, task_pvp_battle, task_pvpcoin, task_weaponchest, task_tacticchest, task_petchest, task_equipchest, task_killenemy, task_killboss, task_deadth, task_usetactic, task_scientist, task_mapsuccess_n, task_mapsuccess_nohurt_n, task_killboss_n, task_usetactic_n, task_max_pet_follow_amount, task_use_chip_to_reform_equip_times, task_upgrade_tactical_card_times, task_upgrade_weapon_times, task_upgrade_pet_times, task_map_success_difficulty_n = xlDb_Query(sQuery)
		--print(sQuery)
		--print(err)
		if (err == 0) then
			local tCmd = hApi.Split(task, ";")
			local taskNum = tonumber(tCmd[1]) or 0 --任务数量
			if (taskNum > 0) then
				local rIdx = 1
				for i = 1, taskNum, 1 do
					local taskInfo = tCmd[rIdx+i]
					local tInfo = hApi.Split(taskInfo, ":")
					local taskId = tonumber(tInfo[1]) or 0 --任务id
					local taskFinishFlag = tonumber(tInfo[2]) or 0 --任务完成情况
					--print(i, "taskId="..taskId, "finish=", taskFinishFlag)
					
					tTaskInfoYesterday[#tTaskInfoYesterday+1] = {taskId, taskFinishFlag,}
				end
				
				--解析关卡通关
				local tMapSuccess = {}
				local tCmd = hApi.Split(task_mapsuccess_n, ";")
				local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
				for i = 1, mapNum, 1 do
					local tInfo = hApi.Split(tCmd[i+1], ":")
					local mapName = tInfo[1]
					local mapCount = tonumber(tInfo[2]) or 0
					tMapSuccess[#tMapSuccess+1] = {mapName, mapCount,}
				end
				
				--解析无损关卡通关
				local tMapSuccessNoHurt = {}
				local tCmd = hApi.Split(task_mapsuccess_nohurt_n, ";")
				local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
				for i = 1, mapNum, 1 do
					local tInfo = hApi.Split(tCmd[i+1], ":")
					local mapName = tInfo[1]
					local mapCount = tonumber(tInfo[2]) or 0
					tMapSuccessNoHurt[#tMapSuccessNoHurt+1] = {mapName, mapCount,}
				end
				
				--解析击杀boss
				local tKillBoss = {}
				local tCmd = hApi.Split(task_killboss_n, ";")
				local mapNum = tonumber(tCmd[1]) or 0 --击杀boss数量
				for i = 1, mapNum, 1 do
					local tInfo = hApi.Split(tCmd[i+1], ":")
					local bossId = tonumber(tInfo[1]) or 0
					local bossCount = tonumber(tInfo[2]) or 0
					tKillBoss[#tKillBoss+1] = {bossId, bossCount,}
				end
				
				--解析使用战术卡
				local tUseTactic = {}
				local tCmd = hApi.Split(task_usetactic_n, ";")
				local mapNum = tonumber(tCmd[1]) or 0 --使用战术卡数量
				for i = 1, mapNum, 1 do
					local tInfo = hApi.Split(tCmd[i+1], ":")
					local tacticId = tonumber(tInfo[1]) or 0
					local useCount = tonumber(tInfo[2]) or 0
					tUseTactic[#tUseTactic+1] = {tacticId, useCount,}
				end
				
				--解析关卡通关
				local tMapSuccessDifficulty = {}
				local tCmd = hApi.Split(task_map_success_difficulty_n, ";")
				local mapNum = tonumber(tCmd[1]) or 0 --关卡数量
				for i = 1, mapNum, 1 do
					local tInfo = hApi.Split(tCmd[i+1], ":")
					local mapName = tInfo[1]
					local diffLevel = tonumber(tInfo[2]) or 0
					tMapSuccessDifficulty[#tMapSuccessDifficulty+1] = {mapName, diffLevel,}
				end
				
				--只处理未领取并且已达成的任务
				for t = 1, #tTaskInfoYesterday, 1 do
					local tTaskI = tTaskInfoYesterday[t]
					local taskId = tTaskI[1]
					local taskFinishFlag = tTaskI[2]
					local taskProgress = 0 --任务已完成的进度
					local tabTask = hVar.tab_task[taskId] or {}
					local taskType = tabTask.taskType --任务类型
					local taskProgressMax = tabTask.maxProgress --任务总进度
					local reward = tabTask.reward --任务奖励
					local typeId = tabTask.typeId --任务指定的参数
					
					if (taskFinishFlag == 0) then --未完成的任务
						if (taskType == hVar.TASK_TYPE.TASK_DALILY_REWARD) then --每日奖励
							--taskProgress = task_daily
						elseif (taskType == hVar.TASK_TYPE.TASK_SHARE_COUINT) then --分享次数
							taskProgress = task_sharecount
						elseif (taskType == hVar.TASK_TYPE.TASK_TACTICCARD_ONCE) then --商城抽卡
							taskProgress = task_drawcard
						elseif (taskType == hVar.TASK_TYPE.TASK_REDCHEST_ONCE) then --商城抽装
							taskProgress = task_redchest
						elseif (taskType == hVar.TASK_TYPE.TASK_REFRESH_SHOP) then --刷新商店
							taskProgress = task_refreshshop
						elseif (taskType == hVar.TASK_TYPE.TASK_EQUIP_XILIAN) then --百炼成钢
							taskProgress = task_xilian
						elseif (taskType == hVar.TASK_TYPE.TASK_BASE_BATTLE_WIN) then --小试牛刀
							taskProgress = task_battle_pve
						elseif (taskType == hVar.TASK_TYPE.TASK_ENDLESS_SCORE) then --无尽使命
							taskProgress = task_endless
						elseif (taskType == hVar.TASK_TYPE.TASK_QSZD_WAVE) then --前哨阵地波次
							taskProgress = task_qszdwave
						elseif (taskType == hVar.TASK_TYPE.TASK_RANDOMMAP_STAGE) then --随机迷宫层数
							taskProgress = task_randmapstage
						elseif (taskType == hVar.TASK_TYPE.TASK_PVP_OPENCHEST) then --竞技锦囊
							taskProgress = task_pvp_chest
						elseif (taskType == hVar.TASK_TYPE.TASK_PVP_BATTLE) then --竞技切磋
							taskProgress = task_pvp_battle
						elseif (taskType == hVar.TASK_TYPE.TASK_PVPTOKEN_USE) then --兵符达人
							taskProgress = task_pvpcoin
						elseif (taskType == hVar.TASK_TYPE.TASK_OPEN_WEPONCHEST) then --武器宝箱
							taskProgress = task_weaponchest
						elseif (taskType == hVar.TASK_TYPE.TASK_OPEN_TACTICCHEST) then --战术宝箱
							taskProgress = task_tacticchest
						elseif (taskType == hVar.TASK_TYPE.TASK_OPEN_PETCHEST) then --宠物宝箱
							taskProgress = task_petchest
						elseif (taskType == hVar.TASK_TYPE.TASK_OPEN_EQUIPCHEST) then --装备宝箱
							taskProgress = task_equipchest
						elseif (taskType == hVar.TASK_TYPE.TASK_KILL_ENEMY) then --击杀敌人
							taskProgress = task_killenemy
						elseif (taskType == hVar.TASK_TYPE.TASK_KILL_BOSS) then --击杀BOSS
							taskProgress = task_killboss
						elseif (taskType == hVar.TASK_TYPE.TASK_DEADTH) then --战车死亡
							taskProgress = task_deadth
						elseif (taskType == hVar.TASK_TYPE.TASK_USE_TACTIC) then --使用战术卡
							taskProgress = task_usetactic
						elseif (taskType == hVar.TASK_TYPE.TASK_RESCUE_SCIENTIST) then --拯救科学家
							taskProgress = task_scientist
						elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_N) then --通关指定关卡
							--找到指定的关卡
							for i = 1, #tMapSuccess, 1 do
								if (tMapSuccess[i][1] == typeId) then
									taskProgress = tMapSuccess[i][2]
								end
							end
						elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N) then --无损通关指定关卡
							--找到指定的无损关卡
							for i = 1, #tMapSuccessNoHurt, 1 do
								if (tMapSuccessNoHurt[i][1] == typeId) then
									taskProgress = tMapSuccessNoHurt[i][2]
								end
							end
						elseif (taskType == hVar.TASK_TYPE.TASK_KILL_BOSS_N) then --击杀指定BOSS
							--找到指定的boss
							for i = 1, #tKillBoss, 1 do
								if (tKillBoss[i][1] == typeId) then
									taskProgress = tKillBoss[i][2]
								end
							end
						elseif (taskType == hVar.TASK_TYPE.TASK_USE_TACTIC_N) then --使用指定战术卡
							--找到指定的战术卡
							for i = 1, #tUseTactic, 1 do
								if (tUseTactic[i][1] == typeId) then
									taskProgress = tUseTactic[i][2]
								end
							end
						elseif (taskType == hVar.TASK_TYPE.TASK_MAX_PET_FOLLOW_AMOUNT) then --最大跟随宠物数量
							taskProgress = task_max_pet_follow_amount
						elseif (taskType == hVar.TASK_TYPE.TASK_USE_CHIP_TO_REFORM_EQUIP_TIMES) then --使用芯片改造装备次数
							taskProgress = task_use_chip_to_reform_equip_times
						elseif (taskType == hVar.TASK_TYPE.TASK_UPGRADE_TACTICAL_CARD_TIMES) then --升级任意战术卡次数
							taskProgress = task_upgrade_tactical_card_times
						elseif (taskType == hVar.TASK_TYPE.TASK_UPGRADE_WEAPON_TIMES) then --升级任意枪塔武器次数
							taskProgress = task_upgrade_weapon_times
						elseif (taskType == hVar.TASK_TYPE.TASK_UPGRADE_PET_TIMES) then --升级任意宠物次数
							taskProgress = task_upgrade_pet_times
						elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_DIFFICULTY_N) then --关卡通关难度
							--找到指定的关卡
							for i = 1, #tMapSuccessDifficulty, 1 do
								if (tMapSuccessDifficulty[i][1] == typeId) then
									taskProgress = tMapSuccessDifficulty[i][2]
								end
							end
						end
						
						if (taskProgress >= taskProgressMax) then --已达成
							--拼接奖励
							for r = 1, #reward, 1 do
								local tReward = reward[r]
								local rewardType = tReward[1] or 0
								--不是服务器抽卡的类型，一直叠加奖励，拼接成一条邮件奖励发奖
								if (rewardType ~= 13) then --13:服务器抽卡
									rewardYesterday:AppendAdd(tReward) --追加添加
								end
								
								--服务器抽卡的类型，单独发一封邮件
								if (rewardType == 13) then --13:服务器抽卡
									rewardYesterday_Drawcard:AppendAdd(tReward) --追加添加
									rewardYesterday_Drawcard_taskId = taskId
								end
							end
							
							--标记任务已领取奖励
							tTaskI[2] = 1
							
							--统计数量
							nFinishCountYesterday = nFinishCountYesterday + 1
						end
					end
				end
				
				--更新任务信息
				if (nFinishCountYesterday > 0) then
					local prizeType = 20031 --奖励类型
					local detail = string.format(hVar.tab_string["__TEXT_TASK_REWARD_YESTERDAY"], rewardYesterday:ToCmdNoNum())
					--发奖
					local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",self._uid,prizeType,detail,0,0)
					xlDb_Execute(sInsert)
					
					--服务器抽卡类型的奖励发奖
					if (rewardYesterday_Drawcard:GetNum() > 0) then
						local prizeType = 20028 --奖励类型
						local detail2 = string.format(hVar.tab_string["__TEXT_TASK_REWARD_YESTERDAY_DRAWCARD"], (hVar.tab_stringTask[rewardYesterday_Drawcard_taskId] or hVar.tab_stringTask[0]), rewardYesterday_Drawcard:ToCmdNoNum())
						--发奖2
						local sInsert2 = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",self._uid,prizeType,detail2,0,0)
						xlDb_Execute(sInsert2)
					end
					
					--更新昨日任务领取情况
					local sTask = tostring(#tTaskInfoYesterday) .. ";"
					for t = 1, #tTaskInfoYesterday, 1 do
						local tTask = tTaskInfoYesterday[t]
						sTask = sTask .. tostring(tTask[1]) .. ":" .. tostring(tTask[2]) .. ";"
					end
					local sUpdate = string.format("UPDATE `t_user_task` SET `task` = '%s' where `uid` = %d and `date_yymmdd` = %d", sTask, self._uid, nDateYestarday)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
				end
			end
		end
	end
	
	--领取周任务指定档位的奖励
	function TaskMgr:WeekTakeReward(index)
		local ret = 0
		local sCmd = ""
		
		--查询任务之石数量
		local nTaskStone = 0
		local sQuery = string.format("SELECT `stone`, `stone_lasttime` from `t_user` where `uid` = %d", self._uid)
		local err, stone, stone_lasttime = xlDb_Query(sQuery)
		--print(sQuery)
		--print(err)
		if (err == 0) then
			nTaskStone = stone
			
			--检测是否同一周
			local nTimestampWeekLast = hApi.GetNewDate(stone_lasttime)
			local strWeekLast = os.date("%Y%W", nTimestampWeekLast)
			local nWeekLast = tonumber(strWeekLast)
			if (nWeekLast ~= self._nWeek) then
				nTaskStone = 0
			end
		
			--此档位是否符合领取条件
			local tInfo = hVar.TASK_STONE_COST[index] or {}
			local num = tInfo.num or 0
			local reward = tInfo.reward or {}
			if (nTaskStone >= num) then
				--此档位的奖励是否已达成
				local finishFlag = 0
				
				--任务（新）类型对应的数据库字段
				local sQuery = string.format("SELECT `taskstone_reward` from `t_user_task_week` where `uid` = %d and `date_week` = %d", self._uid, self._nWeek)
				local err, taskstone_reward = xlDb_Query(sQuery)
				--print(sQuery)
				--print(err)
				if (err == 0) then
					--周任务领取情况
					local taskstoneNum = 0
					local strTaskStone = ""
					if (type(taskstone_reward) == "string") then
						local tCmd = hApi.Split(taskstone_reward, ";")
						taskstoneNum = tonumber(tCmd[1]) or 0 --周任务领取数量
						if (taskstoneNum > 0) then
							local taskStoneInfo = tCmd[2]
							local tInfo = hApi.Split(taskStoneInfo, ":")
							for i = 1, taskstoneNum, 1 do
								local index_i = tonumber(tInfo[i]) or 0 --任务id
								strTaskStone = strTaskStone .. tostring(index_i) .. ":"
								
								--已领取此档位的奖励
								if (index == index_i) then
									finishFlag = 1
								end
							end
						end
					end
					
					if (finishFlag == 0) then
						--领取奖励
						local prizeType = 20008 --奖励类型
						local detail = ""
						detail = detail .. string.format(hVar.tab_string["__TEXT_TASK_REWARD_WEEK"], index) .. ";"
						local tReward = reward
						detail = detail .. (tReward[1] or 0) .. ":" .. (tReward[2] or 0) .. ":" .. (tReward[3] or 0) .. ":" .. (tReward[4] or 0) .. ";"
						
						--发奖
						local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",self._uid,prizeType,detail,0,0)
						xlDb_Execute(sInsert)
						
						--奖励id
						local err1, pid = xlDb_Query("select last_insert_id()")
						if (err1 == 0) then
							--存储奖励信息
							local prizeId = pid --奖励id
							
							--服务器发奖
							local fromIdx = 2
							local prizeContent = hApi.GetRewardInPrize(self._uid, self._rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
							sCmd = sCmd .. prizeContent
						end
						
						--更新数据库已领取标记
						taskstoneNum = taskstoneNum + 1
						strTaskStone = strTaskStone .. tostring(index) .. ":"
						local sTaskWeek = tostring(taskstoneNum) .. ";" .. strTaskStone .. ";"
						
						local sUpdate = string.format("UPDATE `t_user_task_week` SET `taskstone_reward` = '%s' where `uid` = %d and `date_week` = %d", sTaskWeek, self._uid, self._nWeek)
						--print("sUpdate1:",sUpdate)
						xlDb_Execute(sUpdate)
						
						--操作成功
						ret = 1
					else
						ret = -3 --奖励已领取
					end
				else
					ret = -1 --无效的参数
				end
			else
				ret = -2 --未满足领取条件
			end
		else
			ret = -1 --无效的参数
		end
		
		sCmd = tostring(ret) .. ";" .. tostring(index) .. ";" .. sCmd
		
		return sCmd
	end
	
return TaskMgr