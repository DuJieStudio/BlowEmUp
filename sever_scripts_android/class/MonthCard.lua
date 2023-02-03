--月卡管理类
local MonthCard = class("MonthCard")
	--月卡充值成功奖励
	MonthCard.TOUP =
	{
		type = 20031,
		title = hVar.tab_string["__TEXT_MONTHCARD_TOPUP_TITLE"],
		attachment = hVar.tab_string["__TEXT_MONTHCARD_TOPUP_CONTENT"],
		prize = hVar.tab_string["__TEXT_MONTHCARD_TOPUP_PRIZE"],
	}
	
	--月卡每日发奖-游戏币
	MonthCard.DAYREWARD_COIN =
	{
		type = 20031,
		title = hVar.tab_string["__TEXT_MONTHCARD_PRIZE_TITLE"],
		attachment = hVar.tab_string["__TEXT_MONTHCARD_PRIZE_CONTENT"],
		prize = hVar.tab_string["__TEXT_MONTHCARD_PRIZE_PRIZE"],
	}
	
	--[[
	--月卡每日发放英雄将魂(5选2)
	MonthCard.DAYREWARD_DERBIRS =
	{
		type = 20028,
		title = hVar.tab_string["__TEXT_MONTHCARD_PRIZE_TITLE"],
		heroTotalNum = 5, --奖励英雄总数量
		heroSelectNum = 2, --奖励英雄选择数量
		
		prizeType = 13, --13:服务器抽卡类奖励
		
		--英雄的列表(根据总领奖次数来决定发哪些英雄)
		prize =
		{
			{from = 0, to = 20, heroDerbirs = {10201,10202,10203,10208,10205,10210,10206,},}, --刘备,关羽,张飞,赵云,曹操,夏侯惇,太史慈
			{from = 21, to = 40, heroDerbirs = {10207,10214,10216,10215,10211,10212,10227,},}, --郭嘉,张辽,典韦,许褚,吕布,貂蝉,贾诩
			{from = 41, to = 60, heroDerbirs = {10225,10218,10219,10223,10228,10220,10221,10226,},}, --荀彧,孙策,周瑜,孙权,孙尚香,徐庶,诸葛亮,黄月英
			{from = 61, to = 99999, heroDerbirs = {10206,10216,10211,10212,10227,10225,10223,10228,10220,10221,10226,},}, --太史慈,典韦,吕布,貂蝉,贾诩,荀彧,孙权,孙尚香,徐庶,诸葛亮,黄月英,
		},
		
		debrisNum = 3, --每个英雄将魂数量
	}
	]]
	
	--构造函数
	function MonthCard:ctor()
		self._uid = -1
		
		return self
	end
	
	--初始化
	function MonthCard:Init(uid, channelId, iDays)
		self._uid = uid
		
		return self
	end
	
	--发放月卡充值成功奖励
	function MonthCard:RewardMonthCardToup()
		--[[
		local sql = string.format("insert into `prize`(`uid`, `type`, `mykey`) values (%d, %d, '%s')", self._uid, MonthCard.TOUP.type, MonthCard.TOUP.title .. MonthCard.TOUP.attachment .. MonthCard.TOUP.prize)
		xlDb_Execute(sql)
		]]
		
		--geyachao: 战车改为直接加游戏币
		local sql = string.format("UPDATE `t_user` SET `gamecoin_online` = `gamecoin_online` + 300 WHERE `uid` = %d", self._uid)
		xlDb_Execute(sql)
	end
	
	--发放月卡今日奖励
	function MonthCard:CheckTodayMonthCardReward()
		--月卡状态和月卡剩余有效天数
		local nIsMonthCard = 0
		local nLeftDay = 0
		
		--查询玩家月卡状态和领取状态
		local sql = string.format("select `month_card_overtime`, `last_month_card_prize_get_time`, `month_card_totaldays` from `t_user` where `uid` = %d", self._uid)
		local iErrorCode, strMonthCardOvetTime, strMonthCardPrizeGetTime, nMonthCardTotalDays = xlDb_Query(sql)
		--print(iErrorCode, strMonthCardOvetTime, strMonthCardPrizeGetTime, nMonthCardTotalDays)
		
		if (iErrorCode == 0) then
			local nTimestampNow = os.time() --服务器时间
			local nOverTime = hApi.GetNewDate(strMonthCardOvetTime) --月卡失效时间
			
			--在月卡有效期内
			if (nTimestampNow < nOverTime) then
				--print("在月卡有效期内")
				nIsMonthCard = 1
				
				--计算月卡剩余有效天数
				nLeftDay = math.ceil((nOverTime - nTimestampNow) / 86400)
				--print("nLeftDay=", nLeftDay)
				
				--转化为服务器上次月卡领奖时间的0点+1天的时间戳
				local nPrizeTimestamp = hApi.GetNewDate(strMonthCardPrizeGetTime) --上次月卡领奖时间
				local strPrizeDatestampYMD = hApi.Timestamp2Date(nPrizeTimestamp) --转字符串(年月日)
				local strPrizeNewdate = strPrizeDatestampYMD .. " 00:00:00"
				local nPrizeTimestampTodayZero = hApi.GetNewDate(strPrizeNewdate, "DAY", 1)
				
				--今日在有效期内
				if (nTimestampNow >= nPrizeTimestampTodayZero) then
					--print("今日在领奖有效期内")
					--发奖
					--发游戏币
					local mykey = string.format(MonthCard.DAYREWARD_COIN.title .. MonthCard.DAYREWARD_COIN.attachment .. MonthCard.DAYREWARD_COIN.prize, nLeftDay)
					local sqlInsert = string.format("insert into `prize`(`uid`, `type`, `mykey`) values (%d, %d, '%s')", self._uid, MonthCard.DAYREWARD_COIN.type, mykey)
					xlDb_Execute(sqlInsert)
					
					--geyachao: 战车不发将魂了
					--[[
					--发英雄将魂
					--消耗200游戏币奖励;13:1:10:5_10201_10_0|5_10202_10_0|5_10208_10_0|5_10207_10_0|5_10223_10_0;
					local sPrize = ""
					
					local title = MonthCard.DAYREWARD_DERBIRS.title --奖励标题
					local heroTotalNum = MonthCard.DAYREWARD_DERBIRS.heroTotalNum --奖励英雄总数量
					local heroSelectNum = MonthCard.DAYREWARD_DERBIRS.heroSelectNum --奖励英雄选择数量
					local prizeType = MonthCard.DAYREWARD_DERBIRS.prizeType --奖励的发奖类型
					local debrisNum = MonthCard.DAYREWARD_DERBIRS.debrisNum --每个英雄将魂数量
					
					sPrize = sPrize .. title .. prizeType .. ":" .. heroSelectNum .. ":" .. debrisNum .. ":"
					
					--待随机的英雄将魂表
					local heroDerbirsCopy = {}
					for i = 1, #MonthCard.DAYREWARD_DERBIRS.prize, 1 do
						local from = MonthCard.DAYREWARD_DERBIRS.prize[i].from
						local to = MonthCard.DAYREWARD_DERBIRS.prize[i].to
						if (nMonthCardTotalDays >= from) and (nMonthCardTotalDays <= to) then --找到了
							--heroDerbirsCopy = MonthCard.DAYREWARD_DERBIRS.prize[i].heroDerbirs
							--创建拷贝
							for d = 1, #MonthCard.DAYREWARD_DERBIRS.prize[i].heroDerbirs, 1 do
								heroDerbirsCopy[#heroDerbirsCopy+1] = MonthCard.DAYREWARD_DERBIRS.prize[i].heroDerbirs[d]
							end
							
							break
						end
					end
					
					--随机剔除，只剩5个
					while (#heroDerbirsCopy > heroTotalNum) do
						local randIdx = math.random(1, #heroDerbirsCopy)
						table.remove(heroDerbirsCopy, randIdx)
					end
					
					local tempStr = ""
					for d = 1, #heroDerbirsCopy, 1 do
						tempStr = tempStr .. "5_" .. heroDerbirsCopy[d] .. "_" .. debrisNum .. "_0|"
					end
					
					sPrize = sPrize .. tempStr .. ";"
					--print(sPrize)
					
					--发将魂
					local mykey = string.format(MonthCard.DAYREWARD_COIN.title .. MonthCard.DAYREWARD_COIN.attachment .. MonthCard.DAYREWARD_COIN.prize, nLeftDay)
					local sqlInsert = string.format("insert into `prize`(`uid`, `type`, `mykey`) values (%d, %d, '%s')", self._uid, MonthCard.DAYREWARD_DERBIRS.type, sPrize)
					xlDb_Execute(sqlInsert)
					]]
					
					--更新今日月卡领奖时间
					local sTimeStampNow = os.date("%Y-%m-%d %H:%M:%S", nTimestampNow)
					local sqlUpdate = string.format("update `t_user` set `last_month_card_prize_get_time` = '%s', `month_card_totaldays` = %d where `uid` = %d", sTimeStampNow, nMonthCardTotalDays + 1, self._uid)
					xlDb_Execute(sqlUpdate)
				end
			end
		end
		
		local cmd = tostring(nIsMonthCard) .. ";" .. tostring(nLeftDay) .. ";"
		return cmd
	end
	
return MonthCard