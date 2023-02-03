--七日连续充值活动管理类
local ActivitySevenDayPay = class("ActivitySevenDayPay")
	--七日连续充值活动id
	ActivitySevenDayPay.ACTIVITY_ID = 10025
	
	--七日连续充值活动最大支持的天数
	ActivitySevenDayPay.MAX_DAY = 7
	
	--构造函数
	function ActivitySevenDayPay:ctor()
		self._uid = -1
		self._rid = -1
		self._aid = -1
		self._channelId = -1
		
		return self
	end
	
	--初始化
	function ActivitySevenDayPay:Init(uid, rid, aid, channelId)
		self._uid = uid
		self._rid = rid
		self._aid = aid
		self._channelId = channelId
		
		return self
	end
	
	--查询七日连续充值完成状态
	--	result:
	--		 1:成功
	--		-1:无效的活动id
	--		-2:无效的活动类型
	--		-3:无效的渠道号
	function ActivitySevenDayPay:QueryFinishState()
		local result = 0 --是否查询成功
		local progress = 0 --今日属于第几天的进度
		local progressMax = 0 --总天数
		local payMoney = -1 --今日已充值金额（元）
		local leftMoney = -1 --今日剩余充值金额（元）
		local tFinishState = {} --每日充值是否完成的标记表
		local tRewardState = {} --每日充值是否领取奖励的标记表
		
		local sQuery = string.format("select `type`, `channel`, `prize`, `time_begin`, `time_end` from `activity_template` where `aid`= %d", self._aid)
		local iErrorCode, pType, strChannel, szPrize, strBeginTime, strEndTime = xlDb_Query(sQuery)
		--print("查询活动信息", iErrorCode, pType, strChannel, strBeginTime, strEndTime)
		
		if (iErrorCode == 0) then
			if (pType == ActivitySevenDayPay.ACTIVITY_ID) then --七日连续充值活动
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
					--活动的总进度
					local tPrize = {} --奖励表
					if (type(szPrize) == "string") then
						szPrize = "{" .. szPrize .. "}"
						local tmp = "local prize = " .. szPrize .. " return prize"
						
						--奖励表
						tPrize = assert(loadstring(tmp))()
						
						--总天数
						progressMax = #tPrize
						if (progressMax > ActivitySevenDayPay.MAX_DAY) then
							progressMax = ActivitySevenDayPay.MAX_DAY
						end
					end
					--print("总天数=", progressMax)
					--[[
					{
						rate = 60,
						prize = 
						{
							{type="td",id=20008,detail="七日充值活动第6天奖励;9:9102:1:0;",},
						}
					},
					...
					]]
					
					--初始化完成进度表
					for i = 1, progressMax, 1 do
						tFinishState[i] = 0
					end
					
					--初始化奖励领取表
					for i = 1, progressMax, 1 do
						tRewardState[i] = 0
					end
					
					--每日的总充值金额表
					local tTotalPayMoney = {}
					for i = 1, progressMax, 1 do
						tTotalPayMoney[i] = 0
					end
					
					--将活动的起始时间转化为当天的0点
					local nBeginTimestamp = hApi.GetNewDate(strBeginTime)
					local strDateBeginTimestampYMD = hApi.Timestamp2Date(nBeginTimestamp) --转字符串(年月日)
					local strNewBeginTimeZeroDate = strDateBeginTimestampYMD .. " 00:00:00"
					local nTimestampBeginTimeZero = hApi.GetNewDate(strNewBeginTimeZeroDate)
					
					--查询玩家在活动的起始时间段内，全部的充值记录
					local sQueryM = string.format("SELECT `money`, `buytime` FROM `iap_record` WHERE `uid` = %d AND `buytime` >= '%s' AND `buytime` <= '%s'", self._uid, strBeginTime, strEndTime)
					local errM, tTemp = xlDb_QueryEx(sQueryM)
					--print("查询玩家在活动的起始时间段内，全部的充值记录:", "errM=", errM, "tTemp=", #tTemp)
					if (errM == 0) then
						--统计每一天的总充值金额
						for n = 1, #tTemp, 1 do
							local money = tTemp[n][1]
							local buytime = tTemp[n][2]
							
							--将充值时间转化为当天的0点
							local nBuyTimestamp = hApi.GetNewDate(buytime)
							local strDateBuyTimestampYMD = hApi.Timestamp2Date(nBuyTimestamp) --转字符串(年月日)
							local strNewBuyTimeZeroDate = strDateBuyTimestampYMD .. " 00:00:00"
							local nTimestampBuyTimeZero = hApi.GetNewDate(strNewBuyTimeZeroDate)
							
							--计算与起始时间的相差天数
							local deltatime = nTimestampBuyTimeZero - nTimestampBeginTimeZero
							local day = deltatime / 86400
							local dayIdx = day + 1
							
							--只统计发奖的天数
							if (dayIdx <= progressMax) then
								tTotalPayMoney[dayIdx] = tTotalPayMoney[dayIdx] + money
							end
						end
					elseif (errM == 4) then --没有充值记录
						--
					end
					
					--计算今日的0点
					local nTimestampNow = os.time()
					local strDateTodaystampYMD = hApi.Timestamp2Date(nTimestampNow) --转字符串(年月日)
					local strNewTodayZeroDate = strDateTodaystampYMD .. " 00:00:00"
					local nTimestampTodayZero = hApi.GetNewDate(strNewTodayZeroDate)
					
					--计算今日是活动的第几天
					local todatydeltatime = nTimestampTodayZero - nTimestampBeginTimeZero
					local today = todatydeltatime / 86400
					local todayIdx = today + 1
					
					--开始结算，每日的奖励是否可领取
					local finishTag = 1 --完成的进度值
					for day = 1, progressMax, 1 do
						local prize = tPrize[finishTag]
						local rate = prize.rate
						local reqiureMoney = rate / 10 --需要的金额（元）
						
						--检测今日应该算哪一档奖励
						if (todayIdx == day) then
							progress = finishTag
						end
						
						--如果此日充值金额符合档位要求，标记此日充值任务完成
						if (tTotalPayMoney[day] >= reqiureMoney) then
							tFinishState[finishTag] = 1
							finishTag = finishTag + 1
						end
					end
					
					--查询服务器每日奖励的领取情况
					local sQuery = string.format("SELECT `lv01`, `lv02`, `lv03`, `lv04`, `lv05`, `lv06`, `lv07` from `activity_check` where `uid` = %d and `rid` = %d and `aid`= %d limit 1", self._uid, self._rid, self._aid)
					local errQuery, lv01, lv02, lv03, lv04, lv05, lv06, lv07 = xlDb_Query(sQuery)
					--print("查询服务器每日奖励的领取情况:", "errQuery=", errQuery, "level=", lv01, lv02, lv03, lv04, lv05, lv06, lv07)
					
					if (errQuery == 0) then
						--存储领取情况
						tRewardState[1] = lv01
						tRewardState[2] = lv02
						tRewardState[3] = lv03
						tRewardState[4] = lv04
						tRewardState[5] = lv05
						tRewardState[6] = lv06
						tRewardState[7] = lv07
						
						--标记查询成功
						result = 1
					elseif (errQuery == 4) then --没有记录，进度为0
						--print("没有记录，进度为0")
						--标记查询成功
						result = 1
					end
					
					--计算今日已充值（元）
					--计算今日还需充值金额（元）
					if (progress > 0) then
						--计算今日已充值（元）
						--此处读取自然日的金额
						payMoney = tTotalPayMoney[todayIdx]
						
						--计算今日还需充值金额（元）
						--此处读取奖励日的需要充值金额
						local prizeToday = tPrize[progress]
						local rateToday = prizeToday.rate
						local reqiureMoneyToday = rateToday / 10 --需要的金额（元）
						leftMoney = reqiureMoneyToday - payMoney
						if (leftMoney < 0) then
							leftMoney = 0
						end
					end
				else
					--(-3:无效的渠道号)
					result = -3
				end
			else
				--(-2:无效的活动类型)
				result = -2
			end
		else
			--(-1:无效的活动id)
			result = -1
		end
		
		local strFinishState = ""
		local strRewardState = ""
		for i = 1, progressMax, 1 do
			strFinishState = strFinishState .. tFinishState[i] .. ";"
			strRewardState = strRewardState .. tRewardState[i] .. ";"
		end
		local cmd = tostring(self._aid) .. ";" .. tostring(ActivitySevenDayPay.ACTIVITY_ID) .. ";" .. tostring(result) .. ";" .. tostring(progress) .. ";" .. tostring(progressMax)
					.. ";" .. tostring(payMoney) .. ";" .. tostring(leftMoney) .. ";" .. strFinishState .. strRewardState
		return cmd
	end
	
	--领取指定档位的奖励
	--	result:
	--		 1:成功
	--		-1:无效的活动id
	--		-2:无效的活动类型
	--		-3:无效的渠道号
	--		-4:无效的领奖档位
	--		-5:领奖档位进度未完成
	--		-6:领奖档位奖励已领取
	function ActivitySevenDayPay:TakeActivityReward(rewardIdx)
		local result = 0 --是否查询成功
		local progress = 0 --今日属于第几天的进度
		local progressMax = 0 --总天数
		local payMoney = -1 --今日已充值金额（元）
		local leftMoney = -1 --今日剩余充值金额（元）
		local tFinishState = {} --每日充值是否完成的标记表
		local tRewardState = {} --每日充值是否领取奖励的标记表
		
		local prizeType = 0 --奖励类型
		local prizeIdx = 0 --抽到奖励的索引值
		local strPrizeCmd = "" --奖励内容字符串
		
		local sQuery = string.format("select `type`, `channel`, `prize`, `time_begin`, `time_end` from `activity_template` where `aid`= %d", self._aid)
		local iErrorCode, pType, strChannel, szPrize, strBeginTime, strEndTime = xlDb_Query(sQuery)
		--print("查询活动信息", iErrorCode, pType, strChannel, strBeginTime, strEndTime)
		
		if (iErrorCode == 0) then
			if (pType == ActivitySevenDayPay.ACTIVITY_ID) then --七日连续充值活动
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
					--活动的总进度
					local tPrize = {} --奖励表
					if (type(szPrize) == "string") then
						szPrize = "{" .. szPrize .. "}"
						local tmp = "local prize = " .. szPrize .. " return prize"
						
						--奖励表
						tPrize = assert(loadstring(tmp))()
						
						--总天数
						progressMax = #tPrize
						if (progressMax > ActivitySevenDayPay.MAX_DAY) then
							progressMax = ActivitySevenDayPay.MAX_DAY
						end
					end
					--print("总天数=", progressMax)
					--[[
					{
						rate = 60,
						prize = 
						{
							{type="td",id=20008,detail="七日充值活动第6天奖励;9:9102:1:0;",},
						}
					},
					...
					]]
					
					--初始化完成进度表
					for i = 1, progressMax, 1 do
						tFinishState[i] = 0
					end
					
					--初始化奖励领取表
					for i = 1, progressMax, 1 do
						tRewardState[i] = 0
					end
					
					--每日的总充值金额表
					local tTotalPayMoney = {}
					for i = 1, progressMax, 1 do
						tTotalPayMoney[i] = 0
					end
					
					--将活动的起始时间转化为当天的0点
					local nBeginTimestamp = hApi.GetNewDate(strBeginTime)
					local strDateBeginTimestampYMD = hApi.Timestamp2Date(nBeginTimestamp) --转字符串(年月日)
					local strNewBeginTimeZeroDate = strDateBeginTimestampYMD .. " 00:00:00"
					local nTimestampBeginTimeZero = hApi.GetNewDate(strNewBeginTimeZeroDate)
					
					--查询玩家在活动的起始时间段内，全部的充值记录
					local sQueryM = string.format("SELECT `money`, `buytime` FROM `iap_record` WHERE `uid` = %d AND `buytime` >= '%s' AND `buytime` <= '%s'", self._uid, strBeginTime, strEndTime)
					local errM, tTemp = xlDb_QueryEx(sQueryM)
					--print("查询玩家在活动的起始时间段内，全部的充值记录:", "errM=", errM, "tTemp=", #tTemp)
					if (errM == 0) then
						--统计每一天的总充值金额
						for n = 1, #tTemp, 1 do
							local money = tTemp[n][1]
							local buytime = tTemp[n][2]
							
							--将充值时间转化为当天的0点
							local nBuyTimestamp = hApi.GetNewDate(buytime)
							local strDateBuyTimestampYMD = hApi.Timestamp2Date(nBuyTimestamp) --转字符串(年月日)
							local strNewBuyTimeZeroDate = strDateBuyTimestampYMD .. " 00:00:00"
							local nTimestampBuyTimeZero = hApi.GetNewDate(strNewBuyTimeZeroDate)
							
							--计算与起始时间的相差天数
							local deltatime = nTimestampBuyTimeZero - nTimestampBeginTimeZero
							local day = deltatime / 86400
							local dayIdx = day + 1
							
							--只统计发奖的天数
							if (dayIdx <= progressMax) then
								tTotalPayMoney[dayIdx] = tTotalPayMoney[dayIdx] + money
							end
						end
					elseif (errM == 4) then --没有充值记录
						--
					end
					
					--计算今日的0点
					local nTimestampNow = os.time()
					local strDateTodaystampYMD = hApi.Timestamp2Date(nTimestampNow) --转字符串(年月日)
					local strNewTodayZeroDate = strDateTodaystampYMD .. " 00:00:00"
					local nTimestampTodayZero = hApi.GetNewDate(strNewTodayZeroDate)
					
					--计算今日是活动的第几天
					local todatydeltatime = nTimestampTodayZero - nTimestampBeginTimeZero
					local today = todatydeltatime / 86400
					local todayIdx = today + 1
					
					--开始结算，每日的奖励是否可领取
					local finishTag = 1 --完成的进度值
					for day = 1, progressMax, 1 do
						local prize = tPrize[finishTag]
						local rate = prize.rate
						local reqiureMoney = rate / 10 --需要的金额（元）
						
						--检测今日应该算哪一档奖励
						if (todayIdx == day) then
							progress = finishTag
						end
						
						--如果此日充值金额符合档位要求，标记此日充值任务完成
						if (tTotalPayMoney[day] >= reqiureMoney) then
							tFinishState[finishTag] = 1
							finishTag = finishTag + 1
						end
					end
					
					--查询服务器每日奖励的领取情况
					local sQuery = string.format("SELECT `lv01`, `lv02`, `lv03`, `lv04`, `lv05`, `lv06`, `lv07` from `activity_check` where `uid` = %d and `rid` = %d and `aid`= %d limit 1", self._uid, self._rid, self._aid)
					local errQuery, lv01, lv02, lv03, lv04, lv05, lv06, lv07 = xlDb_Query(sQuery)
					--print("查询服务器每日奖励的领取情况:", "errQuery=", errQuery, "level=", lv01, lv02, lv03, lv04, lv05, lv06, lv07)
					
					if (errQuery == 0) then
						--存储领取情况
						tRewardState[1] = lv01
						tRewardState[2] = lv02
						tRewardState[3] = lv03
						tRewardState[4] = lv04
						tRewardState[5] = lv05
						tRewardState[6] = lv06
						tRewardState[7] = lv07
						
						--标记查询成功
						--result = 1
					elseif (errQuery == 4) then --没有记录，进度为0
						--print("没有记录，进度为0")
						--标记查询成功
						--result = 1
					end
					
					--计算今日已充值（元）
					--计算今日还需充值金额（元）
					if (progress > 0) then
						--计算今日已充值（元）
						--此处读取自然日的金额
						payMoney = tTotalPayMoney[todayIdx]
						
						--计算今日还需充值金额（元）
						--此处读取奖励日的需要充值金额
						local prizeToday = tPrize[progress]
						local rateToday = prizeToday.rate
						local reqiureMoneyToday = rateToday / 10 --需要的金额（元）
						leftMoney = reqiureMoneyToday - payMoney
						if (leftMoney < 0) then
							leftMoney = 0
						end
					end
					
					---------------------------------------
					--检测待领奖的档位是否有效
					if (rewardIdx >= 1) and (rewardIdx <= progressMax) then
						--检测待领奖的档位是否完成活动
						if (tFinishState[rewardIdx] == 1) then
							--检测待领奖的档位是否领取奖励
							if (tRewardState[rewardIdx] == 0) then
								--标记待领奖的档位已领取
								--更新活动进度
								local strNewLv = "lv0" .. rewardIdx
								if (errQuery == 0) then
									--修改活动进度
									local sUpdate = string.format("update `activity_check` set `%s` = %d, `time` = now() where `aid` = %d and `uid` = %d and `rid` = %d",strNewLv,1,self._aid,self._uid,self._rid)
									xlDb_Execute(sUpdate)
								else
									--插入新活动进度
									local sInsert = string.format("insert into `activity_check`(`aid`, `uid`, `rid`, `%s`) values (%d, %d, %d, %d)",strNewLv,self._aid,self._uid,self._rid,1)
									xlDb_Execute(sInsert)
								end
								
								--发奖
								--插入奖励表，只发第一条奖励
								local id = tPrize[rewardIdx].prize[1].id
								local detail = tPrize[rewardIdx].prize[1].detail
								--print(rewardIdx, id, detail)
								
								--发奖
								local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",self._uid,id,detail,0,self._aid)
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
								
								--操作成功
								result = 1
							else
								--(-6:领奖档位奖励已领取)
								result = -6
							end
						else
							--(-5:领奖档位进度未完成)
							result = -5
						end
					else
						--(-4:无效的领奖档位)
						result = -4
					end
				else
					--(-3:无效的渠道号)
					result = -3
				end
			else
				--(-2:无效的活动类型)
				result = -2
			end
		else
			--(-1:无效的活动id)
			result = -1
		end
		
		local cmd = tostring(self._aid) .. ";" .. tostring(ActivitySevenDayPay.ACTIVITY_ID) .. ";" .. tostring(result) .. ";"
					.. tostring(rewardIdx) .. ";" .. tostring(progress) .. ";" .. tostring(prizeType) .. ";" .. tostring(prizeIdx) .. ";"
					.. strPrizeCmd
		return cmd
	end
	
return ActivitySevenDayPay