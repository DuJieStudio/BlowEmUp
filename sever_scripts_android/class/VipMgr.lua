--Vip管理类
local VipMgr = class("VipMgr")
	
	--微信充值渠道类型
	VipMgr.WX_TOPUP_IAPTYPE = 8

	VipMgr.ONEOFF_REWARD_TYPE = 
	{
		[3] = hVar.REWARD_LOG_TYPE.vip3,
		[4] = hVar.REWARD_LOG_TYPE.vip4,
		[5] = hVar.REWARD_LOG_TYPE.vip5,
		[6] = hVar.REWARD_LOG_TYPE.vip6,
		[7] = {hVar.REWARD_LOG_TYPE.vip7, hVar.REWARD_LOG_TYPE.vip7_2,},
		[8] = {hVar.REWARD_LOG_TYPE.vip8, hVar.REWARD_LOG_TYPE.vip8_2,},
	}

	--构造函数
	function VipMgr:ctor()
		--其他
		return self
	end
	--初始化函数
	function VipMgr:Init()
		return self
	end

	------------------------------------------------------------private-------------------------------------------------------
	--获得玩家充值数额
	function VipMgr:_DBGetUserTopup(udbid)

		--查找玩家充值数量
		local sql = string.format("SELECT SUM(`money`),SUM(`coin_base`),SUM(`coin_base` + `coin_ext`) FROM `iap_record` where `uid`=%d AND `flag` IN (1,4)",udbid)
		local err, money, coin_base, coin = xlDb_Query(sql)
		if err == 0 then
			return tonumber(money) or 0, tonumber(coin_base) or 0, tonumber(coin) or 0
		else
			return 0,0,0
		end
	end

	--获得玩家vip等级
	function VipMgr:_DBGetUserVip(udbid)
		local vipLv = 0
		
		local money, coin_base, coin = self:_DBGetUserTopup(udbid)
		
		local vipcfg = hVar.Vip_Conifg
		if vipcfg then
			local vipMax = vipcfg.maxVipLv
			local conditionCoin = vipcfg.condition.coin
			for i = 1, vipMax do
				--print("VipMgr:_DBGetUserVip:",coin_base,conditionCoin[i],type(coin_base),type(conditionCoin[i]))
				if coin_base >= conditionCoin[i] then
					vipLv = i
				else
					break
				end
			end
		end

		return vipLv, money, coin_base, coin
	end

	--检测一次性奖励是否发放
	function VipMgr:_DBCheckVipOneoffReward(udbid, vipLv)

		local vipcfg = hVar.Vip_Conifg
		if vipcfg then
			local oneoffReward = vipcfg.oneoffReward
			for v = 1, vipLv do
				if oneoffReward[v] then
					
					local prizeType = VipMgr.ONEOFF_REWARD_TYPE[v]
					
					if prizeType then
						if (type(prizeType) == "number") then --一次性奖励发一封邮件
							--查找玩家是否领取过一次性奖励
							local sql = string.format("SELECT count(*) FROM `prize` where `uid`=%d AND `type`=%d",udbid,prizeType)
							local err, count = xlDb_Query(sql)
							if (err == 0 and count == 0) or err == 4 then
								local reward = hClass.Reward:create():Init()
								for i = 1, #oneoffReward[v] do
									reward:Add(oneoffReward[v][i])
								end
								
								--这里不发奖,邮箱中进行领取
								local insertSql = string.format("INSERT INTO `prize` (`uid`,`type`,`mykey`) VALUES (%d,%d,'%s')", udbid,prizeType,reward:ToCmd())
								--执行sql
								xlDb_Execute(insertSql)
							else
								--有记录啥都不做
							end
						elseif (type(prizeType) == "table") then --一次性奖励发多封邮件
							for r = 1, #prizeType, 1 do
								local prizeType_r = prizeType[r]
								
								--查找玩家是否领取过一次性奖励
								local sql = string.format("SELECT count(*) FROM `prize` where `uid`=%d AND `type`=%d",udbid,prizeType_r)
								local err, count = xlDb_Query(sql)
								if (err == 0 and count == 0) or err == 4 then
									local reward = hClass.Reward:create():Init()
									if oneoffReward[v][r] then
										reward:Add(oneoffReward[v][r])
									end
									
									--这里不发奖,邮箱中进行领取
									local insertSql = string.format("INSERT INTO `prize` (`uid`,`type`,`mykey`) VALUES (%d,%d,'%s')", udbid,prizeType_r,reward:ToCmd())
									--执行sql
									xlDb_Execute(insertSql)
								else
									--有记录啥都不做
								end
							end
						end
					end

				end
			end
		end
		
	end
	
	--检测vip7玩家，每充值2000应该获得的奖励
	function VipMgr:_DBCheckVip7ExtraReward(udbid, vipLv, money)
		if vipLv >= 7 then
			local vipcfg = hVar.Vip_Conifg
			if vipcfg then
				local prizeType = hVar.REWARD_LOG_TYPE.vip7Above
				local conditionRmb = vipcfg.condition.rmb
				local vip7ExtraReward = vipcfg.vip7ExtraReward
				local rmb_base = conditionRmb[7] or 4000

				
				
				if vip7ExtraReward.rmb > 0 and vip7ExtraReward.reward and type(vip7ExtraReward.reward) == "table" then
					
					local mustCount = math.floor(math.max(money - rmb_base,0) / vip7ExtraReward.rmb)

					--print("_DBCheckVip7ExtraReward1:",udbid,money,rmb_base,mustCount)

					--查找玩家是否领取过一次性奖励
					local sql = string.format("SELECT count(*) FROM `prize` where `uid`=%d AND `type`=%d",udbid,prizeType)
					local err, count = xlDb_Query(sql)
					if err == 0 or err == 4 then
						
						local n = (mustCount - (count or 0))

						--print("_DBCheckVip7ExtraReward2:",udbid,count,n)

						local reward = hClass.Reward:create():Init()
						for i = 1, #(vip7ExtraReward.reward) do
							reward:Add(vip7ExtraReward.reward[i])
						end
						
						for i = 1, n do
							--这里不发奖,邮箱中进行领取
							local insertSql = string.format("INSERT INTO `prize` (`uid`,`type`,`mykey`) VALUES (%d,%d,'%s')", udbid,prizeType,reward:ToCmd())
							--执行sql
							xlDb_Execute(insertSql)
						end
					else
						--有记录啥都不做

						--print("_DBCheckVip7ExtraReward3:",udbid, err, count)

					end
				end
			end
		end
	end
	
	--检测是否领取过当日的奖励1,2,3
	function VipMgr:_DBCheckDailyReward(udbid)
		local ret = true
		local ret2 = true
		local ret3 = true
		
		--[[
		--判定是否已经领取过
		local sql = string.format("SELECT count(*) FROM `t_vip_prize` where `uid`=%d AND DATE(`create_time`)=CURDATE()",udbid)
		local err, count = xlDb_Query(sql)
		if (err == 0 and count == 0) or err == 4 then
			ret = false
		end
		]]
		--读取上次领奖的时间
		local sql = string.format("SELECT `last_vip_prize_get_time`, `last_vip_prize2_get_time`, `last_vip_prize3_get_time` FROM `t_user` WHERE `uid` = %d", udbid)
		local err, strDate, strDate2, strDate3 = xlDb_Query(sql)
		if (err == 0) then
			--检测奖励1是否为同一天
			local tab1 = os.date("*t", hApi.GetNewDate(strDate))
			local tab2 = os.date("*t", os.time())
			if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
				ret = false
			end
			
			--检测奖励2是否为同一天
			local tab1 = os.date("*t", hApi.GetNewDate(strDate2))
			--local tab2 = os.date("*t", os.time())
			if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
				ret2 = false
			end
			
			--检测奖励3是否为同一天
			local tab1 = os.date("*t", hApi.GetNewDate(strDate3))
			--local tab2 = os.date("*t", os.time())
			if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
				ret3 = false
			end
		end
		
		return ret, ret2, ret3
	end
	
	--获取玩家的边框、头像、称号
	function VipMgr:_DBGetRoleBorderConfig(udbid)
		local borderId = 0
		local iconId = 0
		local championId = 0
		local dragonId = 0
		local headId = 0
		local lineId = 0
		
		--获取玩家的边框、头像、称号、聊天龙王、头衔、线索
		local sql = string.format("SELECT `border`, `icon`, `champion`, `champion_expire_time`, `dragon`, `dragon_expire_time`, `head`, `line` FROM `t_user` where `uid`= %d", udbid)
		local err, border, icon, champion, champion_expire_time, dragon, dragon_expire_time, head, line = xlDb_Query(sql)
		if (err == 0) then
			borderId = border
			iconId = icon
			headId = head
			lineId = line
			
			--检测称号是否过期
			if (champion > 0) then
				local currenttime = os.time()
				local nExpireTime = hApi.GetNewDate(champion_expire_time)
				
				--未过期
				if (currenttime < nExpireTime) then
					championId = champion
				end
			end
			
			--检测聊天龙王是否过期
			if (dragon > 0) then
				local currenttime = os.time()
				local nExpireTime = hApi.GetNewDate(dragon_expire_time)
				
				--未过期
				if (currenttime < nExpireTime) then
					dragonId = dragon
				end
			end
		end
		
		return borderId, iconId, championId, dragonId, headId, lineId
	end
	
	--获得玩家已获得的全部称号
	function VipMgr:_DBGetRoleChampionList(udbid)
		
		local currenttime = os.time()
		local tChampionList = {}
		
		--检测玩家已获得的称号，是否存在此称号
		local sQueryM = string.format("SELECT `champion_id`, `expire_time` FROM `t_user_champion` WHERE `uid` = %d", udbid)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		if (errM == 0) then
			--称号信息
			for n = 1, #tTemp, 1 do
				local champion_id = tTemp[n][1] --称号id
				local expire_time = tTemp[n][2] --称号过期时间
				
				local nExpireTime = hApi.GetNewDate(expire_time)
				--未过期
				if (currenttime < nExpireTime) then
					local lefttime = nExpireTime - currenttime
					tChampionList[#tChampionList+1] = {championId = champion_id, lefttime = lefttime, expire_time = expire_time,}
				end
			end
		end
		
		return tChampionList
	end
	
	------------------------------------------------------------public-------------------------------------------------------
	
	--获得玩家vip等级
	function VipMgr:DBGetUserVip(udbid)
		return self:_DBGetUserVip(udbid)
	end
	
	--获取Vip列表
	function VipMgr:DBGetUserVipState(udbid)
		
		--获取当前vip
		local vipLv, money, coin_base, coin = self:_DBGetUserVip(udbid)
		
		--检测玩家是哪一档vip,并且检测每一档是否已经发放了奖励，如果没有发放则发放
		self:_DBCheckVipOneoffReward(udbid, vipLv)
		
		--检测vip7玩家，每充值2000应该获得的奖励
		self:_DBCheckVip7ExtraReward(udbid, vipLv, money)
		
		--每天奖励是否获取
		local dailyRewardFlag1 = 1
		local dailyRewardFlag2 = 1
		local dailyRewardFlag3 = 1
		
		local ret1, ret2, ret3 = self:_DBCheckDailyReward(udbid)
		
		if (not ret1) then
			dailyRewardFlag1 = 0
		end
		
		if (not ret2) then
			dailyRewardFlag2 = 0
		end
		
		if (not ret3) then
			dailyRewardFlag3 = 0
		end
		
		--获取玩家的边框、头像、称号
		local borderId, iconId, championId, dragonId, headId, lineId = self:_DBGetRoleBorderConfig(udbid)
		
		--返回玩家vip
		return vipLv, money, coin_base, coin, dailyRewardFlag1, dailyRewardFlag2, dailyRewardFlag3, borderId, iconId, championId, dragonId, headId, lineId
	end
	
	--玩家每日领取奖励
	function VipMgr:DBGetDailyBonus(udbid, rewardIndex)
		local ret = false
		local ret_prize_id = 0 --奖励id
		local ret_prize_type = 0 --奖励类型
		local vipcfg = hVar.Vip_Conifg
		if vipcfg then
			local dailyReward = vipcfg.dailyReward
			if dailyReward then
				--获取当前vip
				local vipLv = self:_DBGetUserVip(udbid)
				if dailyReward[vipLv] then
					if dailyReward[vipLv][rewardIndex] then
						--判定是否已经领取过
						local dailyRewardFlag1 = 1
						local dailyRewardFlag2 = 1
						local dailyRewardFlag3 = 1
						
						local ret1, ret2, ret3 = self:_DBCheckDailyReward(udbid)
						
						if (not ret1) then
							dailyRewardFlag1 = 0
						end
						
						if (not ret2) then
							dailyRewardFlag2 = 0
						end
						
						if (not ret3) then
							dailyRewardFlag3 = 0
						end
						
						local dailyRewardFlag = 0
						if (rewardIndex == 1) then
							dailyRewardFlag = dailyRewardFlag1
						elseif (rewardIndex == 2) then
							dailyRewardFlag = dailyRewardFlag2
						elseif (rewardIndex == 3) then
							dailyRewardFlag = dailyRewardFlag3
						end
						
						if (dailyRewardFlag == 0) then
							local rewardList = dailyReward[vipLv][rewardIndex]
							local description = hVar.tab_string["__TEXT_DAILY_VIP".. tostring(vipLv)] .. hApi.Timestamp2Date(hApi.GetTime())
							
							--奖励字符串
							local sLog = ""
							
							--服务器插入prize表（客户端通过邮件领取）
							for n = 1,#rewardList do
								local reward = rewardList[n] or {}
								--如果是抽n个卡牌，则要插入相应的数据
								if reward[1] == 9 then
									local num = (reward[3] or 1)
									local strReward = (reward[1] or 0)..":"..(reward[2] or 0)..":"..(1)..":"..(reward[4] or 0)..";"
									for p = 1, num do
										--local sLog = string.format("%s;%s",description,strReward)
										--local err, prizeId = hApi.InsertPrize(udbid, 0,hVar.REWARD_LOG_TYPE.activity,sLog,0)--走邮件系统这里最后一个参数state设置为0
										sLog = sLog .. strReward
									end
								else
									local strReward = (reward[1] or 0)..":"..(reward[2] or 0)..":"..(reward[3] or 0)..":"..(reward[4] or 0)..";"
									--local sLog = string.format("%s;%s",description,strReward)
									--local err, prizeId = hApi.InsertPrize(udbid, 0,hVar.REWARD_LOG_TYPE.activity,sLog,0)--走邮件系统这里最后一个参数state设置为0
									sLog = sLog .. strReward
								end
							end
							
							sLog = string.format("%s;%s",description,sLog)
							ret_prize_type = hVar.REWARD_LOG_TYPE.activity
							local err, prizeId = hApi.InsertPrize(udbid, 0,hVar.REWARD_LOG_TYPE.activity,sLog,0)--走邮件系统这里最后一个参数state设置为0
							ret_prize_id = prizeId
							
							--插入领奖记录
							local insertSql = string.format("INSERT INTO `t_vip_prize` (`uid`,`create_time`) VALUES (%d,NOW())", udbid)
							xlDb_Execute(insertSql)
							
							--更新领奖时间
							local insertSql = ""
							if (rewardIndex == 1) then
								insertSql = string.format("update `t_user` set `last_vip_prize_get_time` = NOW() where `uid` = %d", udbid)
							elseif (rewardIndex == 2) then
								insertSql = string.format("update `t_user` set `last_vip_prize2_get_time` = NOW() where `uid` = %d", udbid)
							elseif (rewardIndex == 3) then
								insertSql = string.format("update `t_user` set `last_vip_prize3_get_time` = NOW() where `uid` = %d", udbid)
							end
							xlDb_Execute(insertSql)
							
							ret = true
						end
					end
				end
			end
		end
		
		return ret, ret_prize_id, ret_prize_type
	end
	
	--微信用户充值额外奖励
	function VipMgr:DBGetWXPrize(uid,iaptype,order)
		
		--如果是微信充值渠道
		if uid and iaptype and order and uid > 0 and iaptype == VipMgr.WX_TOPUP_IAPTYPE then
			
			--如果充值在合法范围内
			if order >= 1 and order <= 7 and hVar.WX_TOPUP_EX_REWARD[order] then
				local describe = hVar.tab_string["__TEXT_WX_TOPUP"..order] .. hVar.WX_TOPUP_EX_REWARD[order]
				
				local insertSql = string.format("INSERT INTO prize (uid,`type`, mykey) VALUES (%d,20008,'%s')",uid,describe)
				
				--执行sql
				local err = xlDb_Execute(insertSql)
				if err ~= 0 then
					hApi.Log(3, "[topup] db insert invalid:".. tostring(uid) .. "," .. tostring(iaptype) .. "," .. tostring(order) .. "," .. describe)
				end
			else
				hApi.Log(3, "[topup] order invalid:".. tostring(uid) .. "," .. tostring(iaptype) .. "," .. tostring(order))
			end
		else
			hApi.Log(3, "[topup] iaptype or uid invalid:".. tostring(uid) .. "," .. tostring(iaptype) .. "," .. tostring(order))
		end
	end

	--检测开启竞技场锦囊是否不需要等待直接开
	function VipMgr:CheckOpenChestFree(udbid)
		local ret = false
		local vipcfg = hVar.Vip_Conifg
		local vipLv = 0
		if vipcfg then
			local openChestFree = vipcfg.openChestFree
			if openChestFree then
				--获取当前vip
				vipLv = self:_DBGetUserVip(udbid)
				ret = openChestFree[vipLv]
			end
		end

		return ret,vipLv
	end

	--获得vip免费刷新商城最大次数
	function VipMgr:GetNetShopRefreshCount(udbid)
		local ret = false
		local vipcfg = hVar.Vip_Conifg
		local vipLv = 0
		if vipcfg then
			local netshopRefreshCount = vipcfg.netshopRefreshCount
			if netshopRefreshCount then
				--获取当前vip
				vipLv = self:_DBGetUserVip(udbid)
				ret = netshopRefreshCount[vipLv]
			end
		end

		return ret,vipLv
	end

	--获取vip背包容量
	function VipMgr:GetInventoryCapacity(udbid)
		local ret
		local vipcfg = hVar.Vip_Conifg
		local vipLv = 0
		if vipcfg then
			local bagPageNum = vipcfg.bagPageNum
			if bagPageNum then
				--获取当前vip
				vipLv = self:_DBGetUserVip(udbid)
				ret = bagPageNum[vipLv]
			else
				--默认2页
				ret = 2
			end
		else
			--默认2页
			ret = 2
		end

		return ret,vipLv
	end

return VipMgr