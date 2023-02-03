--新玩家七日签到活动管理类
local ActivitySignIn = class("ActivitySignIn")
	--签到活动id
	ActivitySignIn.ACTIVITY_ID = 10022
	
	--构造函数
	function ActivitySignIn:ctor()
		self._uid = -1
		self._rid = -1
		self._aid = -1
		self._channelId = -1
		
		return self
	end
	
	--初始化
	function ActivitySignIn:Init(uid, rid, aid, channelId)
		self._uid = uid
		self._rid = rid
		self._aid = aid
		self._channelId = channelId
		
		return self
	end
	
	--查询签到完成状态
	function ActivitySignIn:QueryFinishState()
		local result = 0 --是否可签到
		local progress = 0 --可签到的进度
		local progressMax = 0 --签到进度最大值
		local progressFinishDay = 0 --已签到天数
		local buyFlags = {} --特惠购买标记
		
		--查询此活动是否针对渠道号开放
		local sQuery = string.format("SELECT `type`, `channel`, `prize` from `activity_template` where `aid` = %d", self._aid)
		local err, pType, strChannel, szPrize = xlDb_Query(sQuery)
		--print("查询此活动是否针对渠道号开放:","err=", err, "pType=", pType, "strChannel=", strChannel)
		
		if (err == 0) then
			if (pType == ActivitySignIn.ACTIVITY_ID) then --七日签到活动
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
					if (type(szPrize) == "string") then
						szPrize = "{" .. szPrize .. "}"
						local tmp = "local prize = " .. szPrize .. " return prize"
						local prize = assert(loadstring(tmp))()
						progressMax = #prize
					end
					--print("活动的总进度=", progressMax)
					
					--查询此活动上一次完成的进度和日期
					local sQuery = string.format("SELECT `level`, `lv01`, `lv02`, `lv03`, `lv04`, `lv05`, `lv06`, `lv07`, `lv08`, `lv09`, `lv10`, `lv11`, `lv12`, `lv13`, `lv14`, `time` from `activity_check` where `uid` = %d and `aid`= %d limit 1", self._uid, self._aid)
					local err, level, lv01, lv02, lv03, lv04, lv05, lv06, lv07, lv08, lv09, lv10, lv11, lv12, lv13, lv14, strTime = xlDb_Query(sQuery)
					--print("查询此活动上一次完成的进度和日期:", "err=", err, "level=", level, lv01, lv02, lv03, lv04, lv05, lv06, lv07, lv08, lv09, lv10, lv11, lv12, lv13, lv14, "time=", strTime)
					
					if (err == 0) then
						--转化为服务器上次操作时间的0点天的时间戳
						local nTimestamp = hApi.GetNewDate(strTime)
						local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --转字符串(年月日)
						local strNewdate = strDatestampYMD .. " 00:00:00"
						local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1)
						--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
						
						--print("strNewdate=", strNewdate)
						--print("nTimestampTodayZero=", nTimestampTodayZero)
						--print("nTimestampTomorrowZero=", nTimestampTomorrowZero)
						
						--已签到天数
						progressFinishDay = level
						
						--今日时间戳
						local nTimestampNow = os.time()
						--print("nTimestampNow=", nTimestampNow)
						
						--今日在有效期内
						--if (nTimestampNow >= nTimestampTodayZero) and (nTimestampNow < nTimestampTomorrowZero) then
						if (nTimestampNow >= nTimestampTodayZero) then
							--print("今日在有效期内")
							
							--进度未完成，可签到
							if (level < progressMax) then
								result = 1
								progress = level + 1
							end
						end
						
						--检测哪些天数已购买特惠礼包
						if (lv01 > 0) then
							buyFlags[#buyFlags+1] = lv01
						end
						if (lv02 > 0) then
							buyFlags[#buyFlags+1] = lv02
						end
						if (lv03 > 0) then
							buyFlags[#buyFlags+1] = lv03
						end
						if (lv04 > 0) then
							buyFlags[#buyFlags+1] = lv04
						end
						if (lv05 > 0) then
							buyFlags[#buyFlags+1] = lv05
						end
						if (lv06 > 0) then
							buyFlags[#buyFlags+1] = lv06
						end
						if (lv07 > 0) then
							buyFlags[#buyFlags+1] = lv07
						end
						if (lv08 > 0) then
							buyFlags[#buyFlags+1] = lv08
						end
						if (lv09 > 0) then
							buyFlags[#buyFlags+1] = lv09
						end
						if (lv10 > 0) then
							buyFlags[#buyFlags+1] = lv10
						end
						if (lv11 > 0) then
							buyFlags[#buyFlags+1] = lv11
						end
						if (lv12 > 0) then
							buyFlags[#buyFlags+1] = lv12
						end
						if (lv13 > 0) then
							buyFlags[#buyFlags+1] = lv13
						end
						if (lv14 > 0) then
							buyFlags[#buyFlags+1] = lv14
						end
					elseif (err == 4) then --没有记录，进度为0
						--print("没有记录，进度为0，可签到")
						
						--可签到
						result = 1
						progress = 1
					end
				end
			end
		end
		
		local strBuyStr = ""
		for i = 1, #buyFlags, 1 do
			strBuyStr = strBuyStr .. tostring(buyFlags[i]) .. ":"
		end
		local cmd = tostring(self._aid) .. ";" .. tostring(pType) .. ";" .. tostring(result) .. ";" .. tostring(progress) .. ";" .. tostring(progressMax) .. ";" .. tostring(progressFinishDay) .. ";" .. tostring(#buyFlags) .. ";" .. strBuyStr .. ";"
		--print(cmd)
		return cmd
	end
	
	--玩家今日签到
	function ActivitySignIn:TodaySingIn(nProgress)
		local result = 0 --是否可签到
		local progress = 0 --可签到的进度
		local progressMax = 0 --签到进度最大值
		local info = "" --结果描述信息
		local prizeId = 0 --奖励id
		local prizeType = 0 --奖励类型
		local prizeContent = "" --奖励内容
		
		--查询此活动是否针对渠道号开放
		local sQuery = string.format("SELECT `type`, `channel`, `prize` from `activity_template` where `aid`= %d", self._aid)
		local err, pType, strChannel, szPrize = xlDb_Query(sQuery)
		
		if (err == 0) then
			if (pType == ActivitySignIn.ACTIVITY_ID) then --七日签到活动
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
				
				--活动有效的渠道号
				if bChannelValid then
					--活动的总进度
					local prize = {}
					if (type(szPrize) == "string") then
						szPrize = "{" .. szPrize .. "}"
						local tmp = "local prize = " .. szPrize .. " return prize"
						prize = assert(loadstring(tmp))()
						progressMax = #prize
					end
					
					--查询此活动上一次完成的进度和日期
					local sQuery = string.format("SELECT `level`, `time` from `activity_check` where `uid` = %d and `aid`= %d limit 1", self._uid, self._aid)
					local errQuery, level, strTime = xlDb_Query(sQuery)
					
					if (errQuery == 0) then
						--转化为服务器上次操作时间的0点天的时间戳
						local nTimestamp = hApi.GetNewDate(strTime)
						local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --转字符串(年月日)
						local strNewdate = strDatestampYMD .. " 00:00:00"
						local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1)
						--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
						
						--今日时间戳
						local nTimestampNow = os.time()
						
						--今日在有效期内
						--if (nTimestampNow >= nTimestampTodayZero) and (nTimestampNow < nTimestampTomorrowZero) then
						if (nTimestampNow >= nTimestampTodayZero) then
							--进度未完成，可签到
							if (level < progressMax) then
								result = 1
								progress = level + 1
							end
						end
					elseif (errQuery == 4) then --没有记录，进度为0
						--可签到
						result = 1
						progress = 1
					end
					
					if (result == 1) then --可签到
						if (progress == nProgress) then
							--插入奖励表，只发第一条奖励
							local tPrize = prize[progress].prize
							local id = tPrize[1].id
							local detail = tPrize[1].detail
							local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",self._uid,id,detail,0,self._aid)
							xlDb_Execute(sInsert)
							
							--奖励id
							local err1, pid = xlDb_Query("select last_insert_id()")
							if (err1 == 0) then
								--存储奖励信息
								prizeId = pid --奖励id
								prizeType = id --奖励类型
								--prizeContent = detail --奖励内容
								
								--服务器发奖
								--预处理，如果是直接开锦囊的奖励，调用不同的接口
								local fromIdx = 2
								if (prizeType == 20032) then--直接开锦囊
									prizeContent = hApi.GetRewardInPrize_OpenChest(self._uid, self._rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_SINGINDRAW"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_SINGINDRAW)
								else
									prizeContent = hApi.GetRewardInPrize(self._uid, self._rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_SINGINREWARD"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_SINGINREWARD)
								end
								
								--更新活动进度
								if (errQuery == 0) then --存在进度
									--修改活动进度
									local sUpdate = string.format("update `activity_check` set `rid` = %d, `level` = %d, `time` = now() where `aid` = %d and `uid` = %d",self._rid,progress,self._aid,self._uid)
									xlDb_Execute(sUpdate)
								elseif (errQuery == 4) then --没有记录，进度为0
									--插入新活动进度
									local sInsert = string.format("insert into `activity_check`(`aid`, `uid`, `rid`, `level`) values (%d,%d,%d,%d)",self._aid,self._uid,self._rid,progress)
									xlDb_Execute(sInsert)
								end
								
								result = 1
								info = "操作成功"
							else
								result = -6
								info = "插入奖励失败"
							end
						else
							result = -5
							info = "无效的签到进度"
						end
					else
						result = -4
						info = "24小时内不能重复签到"
					end
				else
					result = -3
					info = "无效的渠道号"
				end
			else
				result = -2
				info = "无效的活动类型"
			end
		else
			result = -1
			info = "查询失败"
		end
		
		local cmd = tostring(self._aid) .. ";" .. tostring(pType) .. ";" .. tostring(result) .. ";" .. tostring(progress) .. ";" .. tostring(progressMax)
						 .. ";" .. tostring(info) .. ";" .. tostring(prizeType) .. ";" .. tostring(prizeContent)
		return cmd
	end
	
	--玩家购买特惠礼包
	function ActivitySignIn:BuyGift(nProgress)
		local result = 0 --是否购买成功
		local progress = 0 --可签到的进度
		local progressMax = 0 --签到进度最大值
		local progressFinishDay = 0 --已签到天数
		local info = "" --结果描述信息
		local prizeId = 0 --奖励id
		local prizeType = 0 --奖励类型
		local prizeContent = "" --奖励内容
		local buyFlags = {} --特惠购买标记
		local costJifen = 0 --消耗的积分
		local cosrRmb = 0 --消耗的游戏币
		
		--查询此活动是否针对渠道号开放
		local sQuery = string.format("SELECT `type`, `channel`, `prize` from `activity_template` where `aid`= %d", self._aid)
		local err, pType, strChannel, szPrize = xlDb_Query(sQuery)
		
		if (err == 0) then
			if (pType == ActivitySignIn.ACTIVITY_ID) then --七日签到活动
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
				
				--活动有效的渠道号
				if bChannelValid then
					--活动的总进度
					local prize = {}
					if (type(szPrize) == "string") then
						szPrize = "{" .. szPrize .. "}"
						local tmp = "local prize = " .. szPrize .. " return prize"
						prize = assert(loadstring(tmp))()
						progressMax = #prize
					end
					
					--查询此活动上一次完成的进度和日期
					local sQuery = string.format("SELECT `level`, `lv01`, `lv02`, `lv03`, `lv04`, `lv05`, `lv06`, `lv07`, `lv08`, `lv09`, `lv10`, `lv11`, `lv12`, `lv13`, `lv14`, `time` from `activity_check` where `uid` = %d and `aid`= %d limit 1", self._uid, self._aid)
					local errQuery, level, lv01, lv02, lv03, lv04, lv05, lv06, lv07, lv08, lv09, lv10, lv11, lv12, lv13, lv14, strTime = xlDb_Query(sQuery)
					
					if (errQuery == 0) then
						--转化为服务器上次操作时间的0点天的时间戳
						local nTimestamp = hApi.GetNewDate(strTime)
						local strDatestampYMD = hApi.Timestamp2Date(nTimestamp) --转字符串(年月日)
						local strNewdate = strDatestampYMD .. " 00:00:00"
						local nTimestampTodayZero = hApi.GetNewDate(strNewdate, "DAY", 1)
						--local nTimestampTomorrowZero = hApi.GetNewDate(strNewdate, "DAY", 2)
						
						--今日时间戳
						local nTimestampNow = os.time()
						
						--已签到天数
						progressFinishDay = level
						
						--今日在有效期内
						--if (nTimestampNow >= nTimestampTodayZero) and (nTimestampNow < nTimestampTomorrowZero) then
						if (nTimestampNow >= nTimestampTodayZero) then
							--进度未完成，可签到
							if (level < progressMax) then
								--result = 1
								progress = level + 1
							end
						end
						
						--检测哪些天数已购买特惠礼包
						if (lv01 > 0) then
							buyFlags[#buyFlags+1] = lv01
						end
						if (lv02 > 0) then
							buyFlags[#buyFlags+1] = lv02
						end
						if (lv03 > 0) then
							buyFlags[#buyFlags+1] = lv03
						end
						if (lv04 > 0) then
							buyFlags[#buyFlags+1] = lv04
						end
						if (lv05 > 0) then
							buyFlags[#buyFlags+1] = lv05
						end
						if (lv06 > 0) then
							buyFlags[#buyFlags+1] = lv06
						end
						if (lv07 > 0) then
							buyFlags[#buyFlags+1] = lv07
						end
						if (lv08 > 0) then
							buyFlags[#buyFlags+1] = lv08
						end
						if (lv09 > 0) then
							buyFlags[#buyFlags+1] = lv09
						end
						if (lv10 > 0) then
							buyFlags[#buyFlags+1] = lv10
						end
						if (lv11 > 0) then
							buyFlags[#buyFlags+1] = lv11
						end
						if (lv12 > 0) then
							buyFlags[#buyFlags+1] = lv12
						end
						if (lv13 > 0) then
							buyFlags[#buyFlags+1] = lv13
						end
						if (lv14 > 0) then
							buyFlags[#buyFlags+1] = lv14
						end
					elseif (errQuery == 4) then --没有记录，进度为0
						--可签到
						--result = 1
						progress = 1
					end
					
					--购买礼包的天数小于等于可签到的天数，或已签到天数
					if (nProgress <= progress) or (nProgress <= progressFinishDay) then
						--解析特惠礼包表
						local tBuy = prize[nProgress].buy or {}
						local shopItemId = tBuy.shop or 0 --商品id
						
						--存在可购买的特惠礼包
						if (shopItemId > 0) then
							local id = tBuy[1].id
							local detail = tBuy[1].detail
						
							--检测此礼包是否已购买过
							local buyFlag = 0
							for i = 1, #buyFlags, 1 do
								if (buyFlags[i] == nProgress) then --找到了
									buyFlag = 1
									break
								end
							end
							
							--还未购买过此特惠礼包
							if (buyFlag == 0) then
								local tabShopItem = hVar.tab_shopitem[shopItemId] or {}
								local itemId = tabShopItem.itemID or 0
								local scoreCost = tabShopItem.score or 0
								local rmbCost = tabShopItem.rmb or 0
								
								costJifen = scoreCost
								cosrRmb = rmbCost
								
								--尝试扣除游戏币
								local bSuccess, orderId = hGlobal.userCoinMgr:DBUserPurchase(self._uid, self._rid, itemId, 1, rmbCost, scoreCost, detail)
								if bSuccess then
									--发奖
									local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",self._uid,id,detail,0,self._aid)
									xlDb_Execute(sInsert)
									
									--奖励id
									local err1, pid = xlDb_Query("select last_insert_id()")
									if (err1 == 0) then
										--存储奖励信息
										prizeId = pid --奖励id
										prizeType = id --奖励类型
										--prizeContent = detail --奖励内容
										
										--服务器发奖
										--预处理，如果是直接开锦囊的奖励，调用不同的接口
										local fromIdx = 2
										if (prizeType == 20032) then--直接开锦囊
											prizeContent = hApi.GetRewardInPrize_OpenChest(self._uid, self._rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_SINGINDRAW"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_SINGINDRAW)
										else
											prizeContent = hApi.GetRewardInPrize(self._uid, self._rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_SINGINREWARD"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_SINGINREWARD)
										end
										
										--找插入购买标记的空位
										local strLvPos = "lv01"
										if (lv01 == 0) then
											strLvPos = "lv01"
										elseif (lv02 == 0) then
											strLvPos = "lv02"
										elseif (lv03 == 0) then
											strLvPos = "lv03"
										elseif (lv04 == 0) then
											strLvPos = "lv04"
										elseif (lv05 == 0) then
											strLvPos = "lv05"
										elseif (lv06 == 0) then
											strLvPos = "lv06"
										elseif (lv07 == 0) then
											strLvPos = "lv07"
										elseif (lv08 == 0) then
											strLvPos = "lv08"
										elseif (lv09 == 0) then
											strLvPos = "lv09"
										elseif (lv10 == 0) then
											strLvPos = "lv10"
										elseif (lv11 == 0) then
											strLvPos = "lv11"
										elseif (lv12 == 0) then
											strLvPos = "lv12"
										elseif (lv13 == 0) then
											strLvPos = "lv13"
										elseif (lv14 == 0) then
											strLvPos = "lv14"
										end
										
										--更新活动进度
										if (errQuery == 0) then --存在进度
											--修改活动进度
											local sUpdate = string.format("update `activity_check` set `rid` = %d, `%s` = %d, `time` = '%s' where `aid` = %d and `uid` = %d", self._rid, strLvPos, nProgress, strTime, self._aid, self._uid)
											xlDb_Execute(sUpdate)
										elseif (errQuery == 4) then --没有记录，进度为0
											--插入新活动进度(标记日期为昨天)
											local nTimestampNow = os.time()
											local sTimeStampNow = os.date("%Y-%m-%d %H:%M:%S", nTimestampNow)
											local nTimestampYesterday = hApi.GetNewDate(sTimeStampNow, "DAY", -1)
											local sTimeStampYesterday = os.date("%Y-%m-%d %H:%M:%S", nTimestampYesterday)
											local sInsert = string.format("insert into `activity_check`(`aid`, `uid`, `rid`, `level`, `%s`, `time`) values (%d, %d, %d, %d, %d, '%s')", strLvPos, self._aid, self._uid, self._rid, 0, nProgress, sTimeStampYesterday)
											xlDb_Execute(sInsert)
										end
										
										--添加购买礼包标记
										buyFlags[#buyFlags+1] = nProgress
										
										result = 1
										info = "操作成功"
									else
										result = -8
										info = "插入奖励失败"
									end
								else
									result = -7
									info = "游戏币不足"
								end
							else
								result = -6
								info = "您已购买过此特惠礼包"
							end
						else
							result = -5
							info = "无效的特惠礼包"
						end
					else
						result = -4
						info = "还未解锁特惠礼包"
					end
				else
					result = -3
					info = "无效的渠道号"
				end
			else
				result = -2
				info = "无效的活动类型"
			end
		else
			result = -1
			info = "查询失败"
		end
		
		local strBuyStr = ""
		for i = 1, #buyFlags, 1 do
			strBuyStr = strBuyStr .. tostring(buyFlags[i]) .. ":"
		end
		local cmd = tostring(self._aid) .. ";" .. tostring(pType) .. ";" .. tostring(result) .. ";" .. tostring(progress) .. ";" .. tostring(progressMax) .. ";" .. tostring(progressFinishDay)
						  .. ";" .. tostring(nProgress) .. ";" .. tostring(costJifen) .. ";" .. tostring(cosrRmb) .. ";" .. tostring(#buyFlags)
						  .. ";".. tostring(strBuyStr) .. ";" .. tostring(info) .. ";" .. tostring(prizeType) .. ";" .. tostring(prizeContent)
		return cmd
	end
	
return ActivitySignIn