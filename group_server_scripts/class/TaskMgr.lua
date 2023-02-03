--任务（新）类
local TaskMgr = class("TaskMgr")
	
	--任务列表
	--TaskMgr.TASK_ILIST = {1,2,3,4,5,6,7,8,9,10,}
	TaskMgr.TASK_ILIST = {1,2,3,4,5,6,11,12,7,9,10,}
	
	--指定日期内的额外任务
	TaskMgr.TASKE_EXTRA_LIST =
	{
		{
			beginTime = "2022-01-31 00:00:00",
			endTime = "2022-02-06 23:59:59",
			tasks = {11,12,},
		},
	}
	
	--构造函数
	function TaskMgr:ctor()
		self._uid = -1
		self._rid = -1
		self._nDate = -1
		
		return self
	end
	
	--初始化函数
	function TaskMgr:Init(uid, rid)
		--日期转年月日
		local strDateToday = os.date("%Y%m%d", os.time())
		local nDateToday = tonumber(strDateToday)
		
		self._uid = uid
		self._rid = rid
		self._nDate = nDateToday
		
		--查询任务是否初始化
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
		
		return self
	end
	
	--查询任务和任务完成进度
	function TaskMgr:QueryTaskState(nChannelId)
		local sCmd = ""
		
		--查询任务和完成情况
		local tTaskInfo = {}
		
		--任务（新）类型对应的数据库字段
		local sQuery = string.format("SELECT `task`, `task_drawcard`, `task_redchest`, `task_refreshshop`, `task_xilian`, `task_battle_pve`, `task_endless`, `task_pvp_chest`, `task_pvp_battle`, `task_pvpcoin`, `task_killenemy`, `task_buildtower` from `t_user_task` where `uid` = %d and `date_yymmdd` = %d", self._uid, self._nDate)
		local err, task, task_drawcard, task_redchest, task_refreshshop, task_xilian, task_battle_pve, task_endless, task_pvp_chest, task_pvp_battle, task_pvpcoin, task_killenemy, task_buildtower = xlDb_Query(sQuery)
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
				--任务初始化
				for i = 1, #TaskMgr.TASK_ILIST, 1 do
					tTaskInfo[#tTaskInfo+1] = {TaskMgr.TASK_ILIST[i], 0,}
				end
				
				--特别任务
				for i = 1, #TaskMgr.TASKE_EXTRA_LIST, 1 do
					local tInfo = TaskMgr.TASKE_EXTRA_LIST[i]
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
			
			--只下发未完成的任务
			local nTaskNumUnfinish = 0
			for t = 1, #tTaskInfo, 1 do
				local tTask = tTaskInfo[t]
				local taskId = tTask[1]
				local taskFinishFlag = tTask[2]
				local taskProgress = 0 --任务已完成的进度
				local tabTask = hVar.tab_task[taskId] or {}
				local taskType = tabTask.taskType --任务类型
				local taskProgressMax = tabTask.maxProgress --任务总进度
				
				if (taskFinishFlag == 0) then --未完成的任务
					if (taskType == hVar.TASK_TYPE.TASK_DALILY_REWARD) then --每日奖励
						--taskProgress = task_daily
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
					elseif (taskType == hVar.TASK_TYPE.TASK_PVP_OPENCHEST) then --竞技锦囊
						taskProgress = task_pvp_chest
					elseif (taskType == hVar.TASK_TYPE.TASK_PVP_BATTLE) then --竞技切磋
						taskProgress = task_pvp_battle
					elseif (taskType == hVar.TASK_TYPE.TASK_PVPTOKEN_USE) then --兵符达人
						taskProgress = task_pvpcoin
					elseif (taskType == hVar.TASK_TYPE.TASK_KILL_ENEMY) then --击杀小兵
						taskProgress = task_killenemy
					elseif (taskType == hVar.TASK_TYPE.TASK_BUILD_TOWER) then --建造防御塔
						taskProgress = task_buildtower
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
					--更新
					local sUpdate = string.format("UPDATE `t_user_task` SET `%s` = `%s` + %d where `uid` = %d and `date_yymmdd` = %d", dbkey, dbkey, addCount, self._uid, self._nDate)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
				elseif (increaseType == hVar.TREASURE_ATTR_INCREASE_TYPE.COVER) then --覆盖
					--更新
					local sUpdate = string.format("UPDATE `t_user_task` SET `%s` = %d where `uid` = %d and `date_yymmdd` = %d", dbkey, addCount, self._uid, self._nDate)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
				elseif (increaseType == hVar.TREASURE_ATTR_INCREASE_TYPE.MIN) then --取较小值
					--更新
					local sUpdate = string.format("UPDATE `t_user_task` SET `%s` = %d where `uid` = %d and `date_yymmdd` = %d and (`%s` > %d)", dbkey, addCount, self._uid, self._nDate, dbkey, addCount)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
				elseif (increaseType == hVar.TREASURE_ATTR_INCREASE_TYPE.MAX) then --取较大值
					--更新
					local sUpdate = string.format("UPDATE `t_user_task` SET `%s` = %d where `uid` = %d and `date_yymmdd` = %d and (`%s` < %d)", dbkey, addCount, self._uid, self._nDate, dbkey, addCount)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
				end
			end
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
		local dbkey = hVar.TASK_DBKEY[taskType]
		
		if dbkey then
			--查询任务和完成情况
			local tTaskInfo = {}
			
			--任务（新）类型对应的数据库字段
			local sQuery = string.format("SELECT `task`, `%s` from `t_user_task` where `uid` = %d and `date_yymmdd` = %d", dbkey, self._uid, self._nDate)
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
								local sUpdate = string.format("UPDATE `t_user_task` SET `task` = '%s' where `uid` = %d and `date_yymmdd` = %d", sTask, self._uid, self._nDate)
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
		local sQuery = string.format("SELECT `task`, `task_drawcard`, `task_redchest`, `task_refreshshop`, `task_xilian`, `task_battle_pve`, `task_endless`, `task_pvp_chest`, `task_pvp_battle`, `task_pvpcoin`, `task_killenemy`, `task_buildtower` from `t_user_task` where `uid` = %d and `date_yymmdd` = %d", self._uid, self._nDate)
		local err, task, task_drawcard, task_redchest, task_refreshshop, task_xilian, task_battle_pve, task_endless, task_pvp_chest, task_pvp_battle, task_pvpcoin, task_killenemy, task_buildtower = xlDb_Query(sQuery)
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
					
					if (taskFinishFlag == 0) then --未完成的任务
						if (taskType == hVar.TASK_TYPE.TASK_DALILY_REWARD) then --每日奖励
							--taskProgress = task_daily
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
						elseif (taskType == hVar.TASK_TYPE.TASK_PVP_OPENCHEST) then --竞技锦囊
							taskProgress = task_pvp_chest
						elseif (taskType == hVar.TASK_TYPE.TASK_PVP_BATTLE) then --竞技切磋
							taskProgress = task_pvp_battle
						elseif (taskType == hVar.TASK_TYPE.TASK_PVPTOKEN_USE) then --兵符达人
							taskProgress = task_pvpcoin
						elseif (taskType == hVar.TASK_TYPE.TASK_KILL_ENEMY) then --击杀小兵
							taskProgress = task_killenemy
						elseif (taskType == hVar.TASK_TYPE.TASK_BUILD_TOWER) then --建造防御塔
							taskProgress = task_buildtower
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
		local sQuery = string.format("SELECT `task`, `task_drawcard`, `task_redchest`, `task_refreshshop`, `task_xilian`, `task_battle_pve`, `task_endless`, `task_pvp_chest`, `task_pvp_battle`, `task_pvpcoin`, `task_killenemy`, `task_buildtower` from `t_user_task` where `uid` = %d and `date_yymmdd` = %d", self._uid, nDateYestarday)
		local err, task, task_drawcard, task_redchest, task_refreshshop, task_xilian, task_battle_pve, task_endless, task_pvp_chest, task_pvp_battle, task_pvpcoin, task_killenemy, task_buildtower = xlDb_Query(sQuery)
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
					
					if (taskFinishFlag == 0) then --未完成的任务
						if (taskType == hVar.TASK_TYPE.TASK_DALILY_REWARD) then --每日奖励
							--taskProgress = task_daily
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
						elseif (taskType == hVar.TASK_TYPE.TASK_PVP_OPENCHEST) then --竞技锦囊
							taskProgress = task_pvp_chest
						elseif (taskType == hVar.TASK_TYPE.TASK_PVP_BATTLE) then --竞技切磋
							taskProgress = task_pvp_battle
						elseif (taskType == hVar.TASK_TYPE.TASK_PVPTOKEN_USE) then --兵符达人
							taskProgress = task_pvpcoin
						elseif (taskType == hVar.TASK_TYPE.TASK_KILL_ENEMY) then --击杀小兵
							taskProgress = task_killenemy
						elseif (taskType == hVar.TASK_TYPE.TASK_BUILD_TOWER) then --建造防御塔
							taskProgress = task_buildtower
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
	
return TaskMgr