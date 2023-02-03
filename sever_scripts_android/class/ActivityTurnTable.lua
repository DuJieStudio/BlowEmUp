--消费转盘活动管理类
local ActivityTurnTable = class("ActivityTurnTable")
	--消费转盘活动id
	ActivityTurnTable.ACTIVITY_ID = 10024
	
	--消费转盘活动奖励列表显示最大数量
	ActivityTurnTable.ACTIVITY_PRIZELIST_MAXNUM = 200
	
	--消费转盘活动每次抽奖的各档位几率表
	--循环表
	ActivityTurnTable.REWARD_PROBABLITY =
	{
	--[第n次抽奖] = {第1档几率, 第2档几率, 第3档几率, 第4档几率, 第5档几率, 第6档几率, 未抽中大奖下一次附加的幸运值,},
		[1] = {30,		30,		30,		10,		0,		0,		nextLuckyPoint = 0,},
		[2] = {28,		28,		28,		16,		0,		0,		nextLuckyPoint = 0,},
		[3] = {26,		26,		26,		16,		6,		0,		nextLuckyPoint = 0,},
		[4] = {24,		24,		24,		19,		9,		0,		nextLuckyPoint = 4,},
		[5] = {22,		22,		22,		22,		12,		0,		nextLuckyPoint = 4,},
		[6] = {20,		20,		20,		25,		15,		0,		nextLuckyPoint = 4,},
		[7] = {18,		18,		18,		28,		18,		0,		nextLuckyPoint = 4,},
		[8] = {16,		16,		16,		31,		21,		0,		nextLuckyPoint = 4,},
		[9] = {14,		14,		14,		34,		24,		0,		nextLuckyPoint = 4,},
		[10] = {12,		12,		12,		37,		27,		0,		nextLuckyPoint = 4,},
	}
	
	--第6档附加幸运值
	-- 第6档，每次抽奖，会读取玩家当前总幸运值，
	--  如果本次抽到大奖，总幸运值清零
	--  如果本次没抽到大奖，总幸运值会叠加本次幸运值
	
	--构造函数
	function ActivityTurnTable:ctor()
		self._uid = -1
		self._rid = -1
		self._aid = -1
		self._channelId = -1
		
		return self
	end
	
	--初始化
	function ActivityTurnTable:Init(uid, rid, aid, channelId)
		self._uid = uid
		self._rid = rid
		self._aid = aid
		self._channelId = channelId
		
		return self
	end
	
	--计算指定数量的游戏币折算成多少次转盘次数、还需多少游戏币
	function ActivityTurnTable:__GameCoin2TurnCount(gameCoins, prize)
		local turnCount = 0
		local requiereGameCoin = 0
		
		--奖励表
		--[[
		{
			rate = 200,
			prize = 
			{
				{type="td",id=20008,detail="转盘活动-每消耗200游戏币奖励;1:3000:0:0;",},
			}
		},
		...
		]]
		
		--计算一轮的游戏币和
		local roundSum = 0
		for i = 1, #prize, 1 do
			roundSum = roundSum + prize[i].rate
		end
		--print("roundSum=", roundSum)
		
		--开始计算
		local pivot = gameCoins
		
		--先计算一轮完整的奖励对应的转盘次数
		if (pivot >= roundSum) then
			local div = math.floor(pivot / roundSum)
			pivot = pivot - roundSum * div
			turnCount = turnCount + (#prize) * div
			--print("div=", div)
			--print("(#prize)=", (#prize))
		end
		
		--再计算不足一轮完整的奖励剩余的转盘次数
		local ii = 1
		while true do
			if (pivot >= prize[ii].rate) then --这一档的游戏币足够完成
				pivot = pivot - prize[ii].rate
				turnCount = turnCount + 1
				ii = ii + 1
			else --这一档未完成
				--计算剩余需要的游戏币数量
				requiereGameCoin = prize[ii].rate - pivot
				
				break
			end
		end
		
		return turnCount, requiereGameCoin
	end
	
	--随机生成转盘抽奖结果
	--参数 drawCount: 本次是第几次抽奖, 第6档的总幸运值
	--返回值: 新的总幸运值, 奖励索引, 奖励表
	function ActivityTurnTable:__TurnTableReward(gameCoins, prize, drawCount, lv06)
		--抽奖几率表
		local randPIdx = drawCount % (#ActivityTurnTable.REWARD_PROBABLITY)
		if (randPIdx == 0) then
			randPIdx = (#ActivityTurnTable.REWARD_PROBABLITY)
		end
		local PROBABLITYTABLE = ActivityTurnTable.REWARD_PROBABLITY[randPIdx]
		
		--奖励表
		--[[
		{
			rate = 200,
			prize = 
			{
				{type="td",id=20008,detail="转盘活动-每消耗200游戏币奖励;1:3000:0:0;",},
			}
		},
		...
		]]
		
		--由于幸运值的存在，生成本次真实几率表
		local probablityTable = {}
		for i = 1, #PROBABLITYTABLE, 1 do
			probablityTable[i] = PROBABLITYTABLE[i]
		end
		probablityTable[#probablityTable] = probablityTable[#probablityTable] + lv06 --最后一档附加总幸运值
		probablityTable.nextLuckyPoint = PROBABLITYTABLE.nextLuckyPoint
		
		--计算总几率
		local probablitySum = 0
		for i = 1, #prize, 1 do
			probablitySum = probablitySum + probablityTable[i]
		end
		--print("probablitySum=", probablitySum)
		
		--生成随机数
		local rand = math.random(1, probablitySum)
		
		--计算结果区间
		local index = 0 --结果索引值
		local pivot = rand
		for i = 1, #prize, 1 do
			if (pivot <= probablityTable[i]) then --找到了
				index = i
				break
			else
				pivot = pivot - probablityTable[i]
			end
		end
		
		--计算新的总幸运值
		local newLv06 = 0
		if (index < #probablityTable) then
			newLv06 = lv06 + probablityTable.nextLuckyPoint
		end
		
		return newLv06, index, prize[index].prize
	end
	
	--查询消费转盘活动完成状态
	function ActivityTurnTable:QueryFinishState()
		--总共消耗的游戏币和剩余抽奖次数
		local nGameCoinTotalCost = 0
		local nTotalTurnCount = 0
		local nLeftTurnCount = 0
		local nRequiereGameCoin = 0 --还需多少游戏币可转转盘
		
		--查询活动信息
		local sQuery = string.format("select `type`, `channel`, `prize`, `time_begin`, `time_end` from `activity_template` where `aid`= %d", self._aid)
		local iErrorCode, pType, strChannel, szPrize, strBeginTime, strEndTime = xlDb_Query(sQuery)
		--print("查询活动信息", iErrorCode, pType, strChannel, szPrize, strBeginTime, strEndTime)
		
		if (iErrorCode == 0) then
			--有效的消费转盘活动id
			if (pType == ActivityTurnTable.ACTIVITY_ID) then
				--检测渠道号是否有效
				local bChannelValid = false
				
				if (strChannel == nil) or (strChannel == "") then --活动未填写渠道号，所有渠道都有效
					bChannelValid = true
				else --检测是否包含此渠道号
					local pos = string.find(strChannel, ";" .. self._channelId .. ";")
					if (pos ~= nil) then
						bChannelValid = true --找到了
					end
				end
				
				--print("bChannelValid=", bChannelValid)
				
				--活动有效的渠道号
				if bChannelValid then
					--查询玩家在活动的起始时间段内，总共消耗了多少游戏币
					local sQuery = string.format("SELECT SUM(`coin`) FROM `order` WHERE `uid` = %d AND `time_begin` >= '%s' AND `time_begin` <= '%s'", self._uid, strBeginTime, strEndTime)
					local err, sumCoin = xlDb_Query(sQuery)
					--print("总共消耗了多少游戏币:", "err=", err, "sumCoin=", sumCoin)
					if (err == 0) then
						sumCoin = tonumber(sumCoin) or 0
					else --没有记录
						sumCoin = 0
					end
					
					--存储活动期间消耗的游戏币数量
					nGameCoinTotalCost = sumCoin
					
					--活动的总进度
					local prize = {}
					if (type(szPrize) == "string") then
						szPrize = "{" .. szPrize .. "}"
						local tmp = "local prize = " .. szPrize .. " return prize"
						prize = assert(loadstring(tmp))()
					end
					
					--计算转盘总次数、还需多少游戏币可再转转盘
					nTotalTurnCount, nRequiereGameCoin = self:__GameCoin2TurnCount(sumCoin, prize)
					
					--查询已使用转盘的次数
					local sQuery = string.format("SELECT `level` from `activity_check` where `uid` = %d and `rid` = %d and `aid`= %d limit 1", self._uid, self._rid, self._aid)
					local err, level = xlDb_Query(sQuery)
					--print("查询此活动上一次完成的进度和日期:", "err=", err, "level=", level)
					if (err == 0) then
						--
					else --没有记录
						level = 0
					end
					
					--计算转盘剩余次数
					nLeftTurnCount = nTotalTurnCount - level
				end
			end
		end
		
		local cmd = tostring(self._aid) .. ";" .. tostring(ActivityTurnTable.ACTIVITY_ID) .. ";" .. tostring(nGameCoinTotalCost) .. ";" .. tostring(nTotalTurnCount) .. ";" .. tostring(nLeftTurnCount) .. ";" .. tostring(nRequiereGameCoin) .. ";"
		return cmd
	end
	
	--使用消费转盘活动次数
	function ActivityTurnTable:UseTurnTableCount()
		--总共消耗的游戏币和剩余抽奖次数
		local nGameCoinTotalCost = 0
		local nTotalTurnCount = 0
		local nLeftTurnCount = 0
		local nRequiereGameCoin = 0 --还需多少游戏币可转转盘
		
		local ret = 0 --操作结果
		
		local prizeType = 0 --奖励类型
		local prizeIdx = 0 --抽到奖励的索引值
		local strPrizeCmd = "" --奖励内容字符串
		
		--查询活动信息
		local sQuery = string.format("select `type`, `channel`, `prize`, `time_begin`, `time_end` from `activity_template` where `aid`= %d", self._aid)
		local iErrorCode, pType, strChannel, szPrize, strBeginTime, strEndTime = xlDb_Query(sQuery)
		--print("查询活动信息", iErrorCode, pType, strChannel, szPrize, strBeginTime, strEndTime)
		
		if (iErrorCode == 0) then
			--有效的消费转盘活动id
			if (pType == ActivityTurnTable.ACTIVITY_ID) then
				--检测渠道号是否有效
				local bChannelValid = false
				
				if (strChannel == nil) or (strChannel == "") then --活动未填写渠道号，所有渠道都有效
					bChannelValid = true
				else --检测是否包含此渠道号
					local pos = string.find(strChannel, ";" .. self._channelId .. ";")
					if (pos ~= nil) then
						bChannelValid = true --找到了
					end
				end
				
				--print("bChannelValid=", bChannelValid)
				
				--活动有效的渠道号
				if bChannelValid then
					--查询玩家在活动的起始时间段内，总共消耗了多少游戏币
					local sQuery = string.format("SELECT SUM(`coin`) FROM `order` WHERE `uid` = %d AND `time_begin` >= '%s' AND `time_begin` <= '%s'", self._uid, strBeginTime, strEndTime)
					local err, sumCoin = xlDb_Query(sQuery)
					--print("总共消耗了多少游戏币:", "err=", err, "sumCoin=", sumCoin)
					if (err == 0) then
						sumCoin = tonumber(sumCoin) or 0
					else --没有记录
						sumCoin = 0
					end
					
					--存储活动期间消耗的游戏币数量
					nGameCoinTotalCost = sumCoin
					
					--活动的总进度
					local prize = {}
					if (type(szPrize) == "string") then
						szPrize = "{" .. szPrize .. "}"
						local tmp = "local prize = " .. szPrize .. " return prize"
						prize = assert(loadstring(tmp))()
					end
					
					--计算转盘总次数、还需多少游戏币可再转转盘
					nTotalTurnCount, nRequiereGameCoin = self:__GameCoin2TurnCount(sumCoin, prize)
					
					--查询已使用转盘的次数、第6档总幸运值
					local sQuery = string.format("SELECT `level`, `lv06` from `activity_check` where `uid` = %d and `rid` = %d and `aid`= %d limit 1", self._uid, self._rid, self._aid)
					local errQuery, level, lv06 = xlDb_Query(sQuery)
					--print("查询此活动上一次完成的进度和日期:", "errQuery=", errQuery, "level=", level)
					if (errQuery == 0) then
						--
					else --没有记录
						level = 0
						lv06 = 0
					end
					
					--计算转盘剩余次数
					nLeftTurnCount = nTotalTurnCount - level
					
					--有剩余次数
					if (nLeftTurnCount > 0) then
						--计算本次是第几次抽奖
						local drawCount = level + 1
						
						--开始抽奖生成奖励
						local newLv06, nPrizeIdx, tPrize = self:__TurnTableReward(sumCoin, prize, drawCount, lv06)
						
						--存储抽到的奖励索引值
						prizeIdx = nPrizeIdx
						
						--标记抽奖已使用次数
						--更新活动进度
						if (errQuery == 0) then
							--修改活动进度
							local sUpdate = string.format("update `activity_check` set `level` = %d, `lv06` = %d, `time` = now() where `aid` = %d and `uid` = %d and `rid` = %d",drawCount,newLv06,self._aid,self._uid,self._rid)
							xlDb_Execute(sUpdate)
						else
							--插入新活动进度
							local sInsert = string.format("insert into `activity_check`(`aid`, `uid`, `rid`, `level`, `lv06`) values (%d, %d, %d, %d, %d)",self._aid,self._uid,self._rid,drawCount,newLv06)
							xlDb_Execute(sInsert)
						end
						
						--发奖
						--插入奖励表，只发第一条奖励
						local id = tPrize[1].id
						local detail = tPrize[1].detail
						
						--取玩家名，存到备注信息里(优化流程，取奖励列表不用再查数据库)
						local uName = "player" .. self._uid --用户名
						local sQuery = string.format("select `name` from `t_cha` where `id`= %d", self._rid)
						local iErrorCode, nickname = xlDb_Query(sQuery)
						if (iErrorCode == 0) then
							uName = nickname
						end
						
						--发奖
						local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id,ext) values (%d,%d,'%s',%d,%d,'%s')",self._uid,id,detail,0,self._aid,uName..":"..prizeIdx)
						xlDb_Execute(sInsert)
						
						--20008 号奖励直接发奖，其他的走邮箱领取
						if (id == 20008) then
							--奖励id
							local err1, pid = xlDb_Query("select last_insert_id()")
							if (err1 == 0) then
								--存储奖励信息
								prizeType = id --奖励类型
								
								--服务器发奖
								local fromIdx = 2
								strPrizeCmd = hApi.GetRewardInPrize(self._uid, self._rid, pid, fromIdx)
							end
						else
							--存储奖励信息
							prizeType = id --奖励类型
							
							local maxRewardNum = 1
							local rewardNum = 1
							strPrizeCmd = tostring(pid).. ";" .. tostring(maxRewardNum) ..  ";" .. tostring(rewardNum) .. ";" .. detail
						end
						
						--剩余可转次数减1
						nLeftTurnCount = nLeftTurnCount - 1
						
						--操作成功
						ret = 1
					end
				end
			end
		end
		
		local currenttime = os.time()
		local strHour = os.date("%H", currenttime) --时(字符串)
		local strMinute = os.date("%M", currenttime) --分(字符串)
		local cmd = tostring(self._aid) .. ";" .. tostring(ActivityTurnTable.ACTIVITY_ID) .. ";" .. tostring(ret) .. ";"
				.. tostring(nGameCoinTotalCost) .. ";" .. tostring(nTotalTurnCount) .. ";" .. tostring(nLeftTurnCount) .. ";"
				.. tostring(nRequiereGameCoin) .. ";" .. tostring(prizeType) .. ";" .. tostring(prizeIdx) .. ";"
				.. tostring(strHour) .. ";" .. tostring(strMinute) .. ";" .. strPrizeCmd
		return cmd
	end
	
	--查询消费转盘活动获奖列表
	function ActivityTurnTable:GetPrizeList()
		local ret = 0 --操作结果
		local recordNum = 0 --记录数量
		local strRecordCmd = "" --获奖列表字符串 "name:idx:HH:MM;..."
		
		--查询活动信息
		local sQuery = string.format("select `type`, `channel`, `prize`, `time_begin`, `time_end` from `activity_template` where `aid`= %d", self._aid)
		local iErrorCode, pType, strChannel, szPrize, strBeginTime, strEndTime = xlDb_Query(sQuery)
		--print("查询活动信息", iErrorCode, pType, strChannel, szPrize, strBeginTime, strEndTime)
		
		if (iErrorCode == 0) then
			--有效的消费转盘活动id
			if (pType == ActivityTurnTable.ACTIVITY_ID) then
				--检测渠道号是否有效
				local bChannelValid = false
				
				if (strChannel == nil) or (strChannel == "") then --活动未填写渠道号，所有渠道都有效
					bChannelValid = true
				else --检测是否包含此渠道号
					local pos = string.find(strChannel, ";" .. self._channelId .. ";")
					if (pos ~= nil) then
						bChannelValid = true --找到了
					end
				end
				
				--print("bChannelValid=", bChannelValid)
				
				--活动有效的渠道号
				if bChannelValid then
					--查询奖励表，活动id为指定值的列表
					local sQuery = string.format("SELECT `uid`, `create_time`, `ext` FROM `prize` WHERE `create_id` = %d order by `id` desc limit %d", self._aid, ActivityTurnTable.ACTIVITY_PRIZELIST_MAXNUM)
					local err, tTemp = xlDb_QueryEx(sQuery)
					--print("sQuery", sQuery)
					--print("查询奖励表:", "err=", err, "tTemp=", tTemp)
					if (err == 0) then
						--名字表
						--{[uid]="名字xxx", ...}
						local tUserNameTable = {} 
						
						--按日期从小到达排列
						for n = #tTemp, 1, -1 do
							local uid = tonumber(tTemp[n][1])
							local create_time = tostring(tTemp[n][2])
							local ext = tostring(tTemp[n][3]) --备注信息 "玩家名:索引值"
							
							--日期只保留[HH:MM]格式
							local nCreateTime = hApi.GetNewDate(create_time) --时间
							local strHHMM = os.date("%H:%M", nCreateTime)
							
							recordNum = recordNum + 1
							strRecordCmd = strRecordCmd .. ext .. ":" .. strHHMM .. ";"
						end
						
						--操作成功
						ret = 1
					end
				end
			end
		end
		
		local cmd = tostring(self._aid) .. ";" .. tostring(ActivityTurnTable.ACTIVITY_ID) .. ";" .. tostring(ret) .. ";" .. tostring(recordNum) .. ";" .. tostring(strRecordCmd) .. ";" 
		return cmd
	end
	
return ActivityTurnTable