NoviceCampMgr = {}
NoviceCampMgr.private = {}

NoviceCampMgr._statisticsTime = hApi.GetClock()	--统计计时
NoviceCampMgr._statisticsTimestamp = os.time()	--上次统计时间

NoviceCampMgr.SYSTEM_CHECK_TIME = {time = "00:00:00", } --系统检测时间

local private = NoviceCampMgr.private




--config
private.Config_GetNCFee = function()
	return 200
end
private.Config_GetVitality = function()
	return 10
end
private.Config_GetMaxMember = function(iGraduate)
	if iGraduate < 20 then return 10
	elseif iGraduate < 50 then return 30
	else return 50
	end
end
-----毕业人数一次性奖励
private.Config_PrizeGraduate = 
{
	{
		rate=10,
		prize={{type="ix",num=10,id=9006},}
	},

	{
		rate=20,
		prize={{type="ix",num=20,id=9006},}
	},

	{
		rate=30,
		prize={{type="ix",num=30,id=9006},}
	},
	
	{
		rate=50,
		prize={{type="ix",num=50,id=9006},}
	},

	--给毕业成员的奖励
	prize_member = {{type="ix",num=10,id=9006},{type="cn",num=50,}},
}

------每日活跃度的排名奖励
private.Config_PrizeVitality =
{
	{
		rate=1,
		prize={{type="ir",id=9802},{type="ix",num=200,id=9006},}
	},

	{
		rate=2,
		prize={{type="ir",id=9801},{type="ix",num=160,id=9006},}
	},

	{
		rate=3,
		prize={{type="ir",id=9800},{type="ix",num=130,id=9006},}
	},

	{
		rate=10,
		prize={{type="ix",num=100,id=9006},}
	},
}


private.Config_PrizeVitality[1].ext = [[{type="ir",id=9802}]]
private.Config_PrizeVitality[1].describe_cn = "新手营排名第一奖励;\n恭喜您获得了新手营排名第一奖励200元话费，请联系管理员，并且提供手机号码，官方会再7个工作日内发放奖励。\n官方QQ群：274108227"

private.Config_PrizeVitality[2].ext = [[{type="ir",id=9801}]]
private.Config_PrizeVitality[2].describe_cn = "新手营排名第二奖励;\n恭喜您获得了新手营排名第一奖励100元话费，请联系管理员，并且提供手机号码，官方会再7个工作日内发放奖励。\n官方QQ群：274108227"

private.Config_PrizeVitality[3].ext = [[{type="ir",id=9800}]]
private.Config_PrizeVitality[3].describe_cn = "新手营排名第三奖励;\n恭喜您获得了新手营排名第一奖励50元话费，请联系管理员，并且提供手机号码，官方会再7个工作日内发放奖励。\n官方QQ群：274108227"

private.Config_PrizeVitality["describe_cn"] = {"玩家加入新手营之后，可以通过完成一系列的新手营任务来获得奖励，在新手营里成员可以互相聊天交流，营长也可以为新手提供帮助，赠送宝箱。当玩家完成所有任务，从新手营毕业时，玩家和营长都会获得额外的奖励。新手营毕业人数越多，活跃度越高，它的级别就会提升，在活跃榜的位置也会越靠前，营长会因此获得排行奖励。除排名奖励外，只要有成员毕业，营长即可获得10个黄金宝箱.","\n\n新手营排名奖励：\n每月1号结算，毕业1个玩家活跃度+10，活跃度必须大于200点，才会发放排名奖励。 \n1"}
private.Config_PrizeVitality["describe_tc"] = {"玩家加入新手营之后，可以通过完成一系列的新手营任务来获得奖励，在新手营里成员可以互相聊天交流，营长也可以为新手提供帮助，赠送宝箱。当玩家完成所有任务，从新手营毕业时，玩家和营长都会获得额外的奖励。新手营毕业人数越多，活跃度越高，它的级别就会提升，在活跃榜的位置也会越靠前，营长会因此获得排行奖励。除排名奖励外，只要有成员毕业，营长即可获得10个黄金宝箱.","\n\n新手营排名奖励：\n每月1号结算，毕业1个玩家活跃度+10，活跃度必须大于200点，才会发放排名奖励。 \n1"}
private.Config_PrizeVitality["describe_en"] = {"玩家加入新手营之后，可以通过完成一系列的新手营任务来获得奖励，在新手营里成员可以互相聊天交流，营长也可以为新手提供帮助，赠送宝箱。当玩家完成所有任务，从新手营毕业时，玩家和营长都会获得额外的奖励。新手营毕业人数越多，活跃度越高，它的级别就会提升，在活跃榜的位置也会越靠前，营长会因此获得排行奖励。除排名奖励外，只要有成员毕业，营长即可获得10个黄金宝箱.","\n\n新手营排名奖励：\n每月1号结算，毕业1个玩家活跃度+10，活跃度必须大于200点，才会发放排名奖励。 \n1"}

--军团组队副本挑战成功增加的随机军团资源数量
private.GROUP_BATTLE_REWARD =
{
	{16, 10,}, --16:铁
	{17, 20,}, --17:木材
	{18, 20,}, --18:粮食
}

--军团副本挑战成功增加的军团币数量
private.GROUPCOIN_REWARD = 10












private.Config_GetPrizeVitality = function(iLevel)
	local tPrize = private.Config_PrizeVitality
	for i=1,#tPrize do
		if iLevel <= tPrize[i].rate then return tPrize[i].prize end
	end
end
private.Config_GetLastRank = function()
	local iRank = 0
	local tPrize = private.Config_PrizeVitality
	if tPrize and tPrize[#tPrize] then
		iRank = tPrize[#tPrize].rate
	end
	return iRank
end


--nclist
private.Data_GetNcList = function(iType)
	--local sSql = string.format("SELECT `id`,`name`,`descripe`,`count_member`,`max_member`,`master_uid`,`master_name`,`vitality`,`graduate`,`time_create`,`country`,`mat_iron`,`mat_wood`,`mat_food`,`buildinfo` FROM novicecamp_list WHERE `id` IN (SELECT NM.ncid FROM novicecamp_member AS NM,t_user AS US WHERE NM.`uid` = US.`uid` AND DATEDIFF(NOW(),US.last_login_time) < 2 GROUP BY NM.ncid) AND `type` = %d AND `dissolution` = 0 ORDER BY `vitality` DESC,`id` ASC",iType)
	local sSql = string.format("SELECT `id`,`name`,`descripe`,`count_member`,`max_member`,`master_uid`,`master_name`,`vitality`,`graduate`,`time_create`,`country`,`mat_iron`,`mat_wood`,`mat_food`,`buildinfo`, `shengwang_week_sum`, `is_system` FROM novicecamp_list WHERE `type` = %d AND `dissolution` = 0 ORDER BY `shengwang_week_sum` DESC, `count_member` DESC, `id` ASC LIMIT 100", iType)
	local iErrorCode,tQuery = xlDb_QueryEx(sSql)
	return tQuery
end

--新玩家申请军团需要返回的军团列表
private.Data_GetNcList_Join = function(iType)
	--优先按本周声望排序，取100个军团的数据（本周声望大于0，或者系统军团，或者刚创建3天之内的军团）
	local sSql = string.format("SELECT `id`,`name`,`descripe`,`count_member`,`max_member`,`master_uid`,`master_name`,`vitality`,`graduate`,`time_create`,`country`,`mat_iron`,`mat_wood`,`mat_food`,`buildinfo`, `shengwang_week_sum`, `is_system` FROM novicecamp_list WHERE `type` = %d AND `dissolution` = 0 and ((`is_system` = 0 and `shengwang_week_sum` > 0) or (`is_system` = 1 and `count_member` < `max_member`) or (`is_system` = 0 and (DATEDIFF(CURDATE(),DATE(`time_create`)) <= 3))) ORDER BY `count_member` ASC, `shengwang_week_sum` DESC, `max_member` ASC, `id` DESC LIMIT 100",iType)
	local iErrorCode,tQuery = xlDb_QueryEx(sSql)
	--print(iErrorCode,tQuery)
	if (iErrorCode == 0) then
		if ((type(tQuery)) == "table") then
			--print(#tQuery)
			if (#tQuery >= 10) then
				return tQuery
			end
		end
	end
	
	--走到这里说明按本周声望排序查到的军团数量不足
	local sSql = string.format("SELECT `id`,`name`,`descripe`,`count_member`,`max_member`,`master_uid`,`master_name`,`vitality`,`graduate`,`time_create`,`country`,`mat_iron`,`mat_wood`,`mat_food`,`buildinfo`, `shengwang_week_sum`, `is_system` FROM novicecamp_list WHERE `type` = %d AND `dissolution` = 0 and ((`is_system` = 0 and (`mat_iron`+`mat_wood`+`mat_food`) >= 100) or (`is_system` = 1 and `count_member` < `max_member`) or (`is_system` = 0 and (DATEDIFF(CURDATE(),DATE(`time_create`)) <= 3))) ORDER BY `count_member` ASC, `shengwang_week_sum` DESC, `max_member` ASC, `id` DESC LIMIT 100",iType)
	local iErrorCode,tQuery = xlDb_QueryEx(sSql)
	
	return tQuery
end

--查找军团（军团名、会长名模糊匹配）
private.Data_GetNcList_Join_Seach = function(iType, searchName)
	local sSql = string.format("SELECT `id`,`name`,`descripe`,`count_member`,`max_member`,`master_uid`,`master_name`,`vitality`,`graduate`,`time_create`,`country`,`mat_iron`,`mat_wood`,`mat_food`,`buildinfo`, `shengwang_week_sum`, `is_system` FROM novicecamp_list WHERE `type` = %d AND `dissolution` = 0 AND ((`name` LIKE '%%%s%%') OR (`master_name` LIKE '%%%s%%')) ORDER BY `count_member` ASC, `shengwang_week_sum` DESC, `max_member` ASC, `id` DESC LIMIT 100",iType,searchName,searchName)
	local iErrorCode,tQuery = xlDb_QueryEx(sSql)
	--print(iErrorCode,tQuery)
	if (iErrorCode == 0) then
		if ((type(tQuery)) == "table") then
			--print(#tQuery)
			return tQuery
		end
	end
	
	return tQuery
end

private.Data_InsertNc = function(sName,sDescripe,iType,iMasterUid,sMasterName,iCountry)
	--检测是否公会名重名
	local sSql = string.format("SELECT `id` FROM novicecamp_list WHERE `name` = '%s' and `dissolution` = 0", sName)
	local iErrorCode,tQuery = xlDb_QueryEx(sSql)
	if (iErrorCode == 0) then
		return
	end
	
	local tBuild = private.Data_DefaultBuild(iCountry)
	local sBuild = private.Helper_Table2String(tBuild)
	local sSql = string.format("INSERT INTO novicecamp_list (`name`,`descripe`,`type`,`master_uid`,`master_name`,`time_create`,`country`,`buildinfo`) VALUES (\'%s\',\'%s\',%d,%d,\'%s\',NOW(),%d,\'%s\')",sName,sDescripe,iType,iMasterUid,sMasterName,iCountry,sBuild)
	xlDb_Execute(sSql)
	local iErrorCode,iNcId = xlDb_Query("select last_insert_id()")
	return iNcId
end
private.Data_SetNcDissolution = function(iNcId,iUid,iDissolution)
	local sSql = string.format("UPDATE novicecamp_list SET `dissolution`=%d,`time_dissolution` = NOW() WHERE `id`=%d AND `master_uid` = %d",iDissolution,iNcId,iUid)
	xlDb_Execute(sSql)
end
private.Data_GetNcInfo = function(iNcId)
	local sSql = string.format("SELECT `master_uid`,`dissolution`,`count_member`,`max_member`,`vitality`,`graduate`,`time_create`,`country`,`mat_iron`,`mat_wood`,`mat_food`,`buildinfo`,`buy_battle_count`,`last_buy_battle_count_time`, `last_transfer_time`, `is_system` FROM novicecamp_list WHERE `id`=%d",iNcId)
	local iErrorCode,iMasterUid,iDissolution,iMemberCount,iMaxMember,iVitality,iGraduate,sTime,iCountry,iIron,iWood,iFood,sBuild,iBuyBattleCount,sLastBuyBattleCountTime, sLastTransfertTime, is_system = xlDb_Query(sSql)
	return iMasterUid,iDissolution,iMemberCount,iMaxMember,iVitality,iGraduate,sTime,iCountry,iIron,iWood,iFood,sBuild,iBuyBattleCount,sLastBuyBattleCountTime,sLastTransfertTime,is_system
end

--用于军团成员列表的军团信息部分
private.Data_GetNcInfoTable = function(iNcId)
	local sSql = string.format("SELECT `name`,`descripe`,`count_member`,`max_member`,`master_uid`,`master_name`,`vitality`,`graduate`,`time_create`,`dissolution`,`country`,`mat_iron`,`mat_wood`,`mat_food`,`buildinfo`,`is_system` FROM novicecamp_list WHERE `id`=%d",iNcId)
	local iErrorCode,sName,sDescripe,iMemberCount,iMaxMember,iMasterUid,sMasterName,iVitality,iGraduate,sTime,iDissolution,iCountry,iMatIron,iMatWood,iMatFood,sBuild,is_system = xlDb_Query(sSql)
	return {sName,sDescripe,iMemberCount,iMaxMember,iMasterUid,sMasterName,iVitality,iGraduate,sTime,iDissolution,iCountry,iMatIron,iMatWood,iMatFood,sBuild,is_system,}
end
private.Data_UpdateNc = function(iNcid,iFood,iWood,iIron,sBuild,iMaxMember)
	local sSql = string.format("UPDATE novicecamp_list SET `mat_food`=`mat_food`-%d,`mat_wood`=`mat_wood`-%d,`mat_iron`=`mat_iron`-%d,`max_member`=%d,`buildinfo`=\'%s\' WHERE `id`=%d",iFood,iWood,iIron,iMaxMember,sBuild,iNcid)
	xlDb_Execute(sSql)
end

private.Data_UpdateNcRes = function(iNcid,iFood,iWood,iIron)
	local sSql = string.format("UPDATE novicecamp_list SET `mat_food`=`mat_food`-%d,`mat_wood`=`mat_wood`-%d,`mat_iron`=`mat_iron`-%d WHERE `id`=%d",iFood,iWood,iIron,iNcid)
	xlDb_Execute(sSql)
end

private.Data_IncreaseMemberCount = function(iNcId)
	local sSql = string.format("UPDATE novicecamp_list SET `count_member`=`count_member`+1 WHERE `id`=%d",iNcId)
	xlDb_Execute(sSql)
end
private.Data_DecreaseMemberCount = function(iNcId)
	local sSql = string.format("UPDATE novicecamp_list SET `count_member`=`count_member`-1 WHERE `id`=%d",iNcId)
	xlDb_Execute(sSql)
end
private.Data_SetDescripe = function(iNcId,sDescripe)
	local sSql = string.format("UPDATE novicecamp_list SET `descripe`=\'%s\' WHERE `id`=%d",sDescripe,iNcId)
	xlDb_Execute(sSql)
end

--查询玩家今日已兑换战术卡碎片的次数
private.Data_GetExchangeTacticDebirsNum = function(uid)
	local exchange_tactic_num = 0
	
	local sQuery = string.format("SELECT `exchange_tactic_num`, `last_exchange_tactic_time` from `t_chat_user` where `uid` = %d", uid)
	local err, tactic_num, last_exchange_tactic_time = xlDb_Query(sQuery)
	--print(sQuery, err, tactic_num, last_exchange_tactic_time)
	if (err == 0) then
		exchange_tactic_num = tactic_num
		
		--检测是否到第二天，重置今日兑换的战术卡次数
		local tab1 = os.date("*t", hApi.GetNewDate(last_exchange_tactic_time))
		local tab2 = os.date("*t", os.time())
		if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
			exchange_tactic_num = 0
		end
	end
	
	return exchange_tactic_num
end

--查询玩家今日已兑换英雄将魂的次数
private.Data_GetExchangeHeroDebirsNum = function(uid)
	local exchange_hero_num = 0
	
	local sQuery = string.format("SELECT `exchange_hero_num`, `last_exchange_hero_time` from `t_chat_user` where `uid` = %d", uid)
	local err, hero_num, last_exchange_hero_time = xlDb_Query(sQuery)
	--print(sQuery, err, hero_num, last_exchange_hero_time)
	if (err == 0) then
		exchange_hero_num = hero_num
		
		--检测是否到第二天，重置今日兑换的英雄将魂次数
		local tab1 = os.date("*t", hApi.GetNewDate(last_exchange_hero_time))
		local tab2 = os.date("*t", os.time())
		if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
			exchange_hero_num = 0
		end
	end
	
	return exchange_hero_num
end

--查询军团今日踢掉活跃玩家的次数
private.Data_GetKickActivePlayerNum = function(ncid)
	local kick_active_player_num = 0
	
	local sQuery = string.format("SELECT `kick_active_player_num`, `last_kick_active_player_time` from `novicecamp_list` where `id` = %d", ncid)
	local err, kick_num, last_kick_active_player_time = xlDb_Query(sQuery)
	--print(sQuery, err, kick_num, last_kick_active_player_time)
	if (err == 0) then
		kick_active_player_num = kick_num
		
		--检测是否到第二天，重置今日踢掉活跃玩家的次数
		local tab1 = os.date("*t", hApi.GetNewDate(last_kick_active_player_time))
		local tab2 = os.date("*t", os.time())
		if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
			kick_active_player_num = 0
		end
	end
	
	return kick_active_player_num
end

--更新玩家今日已兑换战术卡碎片的次数
private.Data_UpdateExchangeTacticDebirsNum = function(uid, num)
	local sUpdate = string.format("update `t_chat_user` set `exchange_tactic_num` = %d, `last_exchange_tactic_time` = NOW() where `uid` = %d", num, uid)
	xlDb_Execute(sUpdate)
end

--更新玩家今日已兑换英雄将魂的次数
private.Data_UpdateExchangeHeroDebirsNum = function(uid, num)
	local sUpdate = string.format("update `t_chat_user` set `exchange_hero_num` = %d, `last_exchange_hero_time` = NOW() where `uid` = %d", num, uid)
	xlDb_Execute(sUpdate)
end

--更新军团今日踢掉活跃玩家的次数
private.Data_UpdateKickActivePlayerNum = function(ncid, num)
	local sUpdate = string.format("update `novicecamp_list` set `kick_active_player_num` = %d, `last_kick_active_player_time` = NOW() where `id` = %d", num, ncid)
	xlDb_Execute(sUpdate)
end

--修改工会名
private.Data_SetName = function(iNcId,sName)
	--检测是否公会名重名
	local sSql = string.format("SELECT `id` FROM `novicecamp_list` WHERE `name` = '%s' and `dissolution` = 0", sName)
	local iErrorCode,tQuery = xlDb_QueryEx(sSql)
	if (iErrorCode == 0) then
		return
	end
	
	local sSql = string.format("UPDATE novicecamp_list SET `name`=\'%s\' WHERE `id`=%d",sName,iNcId)
	xlDb_Execute(sSql)
	
	return iNcId
end

private.Data_AddVitality = function(iNcId,iVitality)
	local sSql = string.format("UPDATE novicecamp_list SET `vitality`=`vitality` + %d WHERE `id`=%d",iVitality,iNcId)
	xlDb_Execute(sSql)
end
private.Data_IncreaseGraduate = function(iNcId,iMaxMember)
	local sSql = string.format("UPDATE novicecamp_list SET `count_member`=`count_member`-1,`graduate`=`graduate`+1,`max_member`=%d WHERE `id`=%d",iMaxMember,iNcId)
	xlDb_Execute(sSql)
end




--member
private.Data_GetMemberList = function(iNcId)
	local sSql = string.format("SELECT novicecamp_member.`uid`,`level`,`customS1`,`time_jion`,`task_count`,`task_max`,`last_login_time`,`mat_iron_donate_sum`,`mat_wood_donate_sum`,`mat_food_donate_sum`,`border`,`icon`,`shengwang_week` FROM novicecamp_member,t_user WHERE `ncid`= %d AND novicecamp_member.uid = t_user.uid  order by `level` DESC",iNcId)
	local iErrorCode,tQuery = xlDb_QueryEx(sSql)
	
	--处理最后登录时间
	if (iErrorCode == 0) then
		if ("table" == type(tQuery)) then
			for i = 1, #tQuery, 1 do
				local uid = tQuery[i][1]
				local last_login_time = tQuery[i][7]
				
				local strLastLoginTime = ""
				
				--查找用户对象
				local user = hGlobal.uMgr:FindUserByDBID(uid)
				--如果玩家存在
				if user then
					strLastLoginTime = hVar.tab_string["__TEXT_LOGINTIME_ONLINE"] --"在线"
				else
					--查询玩家军团上次离线时间，比较哪个时间更大
					local sQuery = string.format("SELECT `last_offline_time` FROM `t_chat_user` WHERE `uid`= %d", uid)
					local err, last_offline_time = xlDb_Query(sQuery)
					if (err == 0) then
						if (last_offline_time > last_login_time) then
							last_login_time = last_offline_time
						end
					end
					
					local currenttimestamp = os.time()
					local nLastLoginTime = hApi.GetNewDate(last_login_time)
					local deltaSeconds = currenttimestamp - nLastLoginTime --秒数
					local hour = math.floor(deltaSeconds / 3600) --时
					local minute = math.floor((deltaSeconds - hour * 3600)/ 60) --分
					local second = deltaSeconds - hour * 3600 - minute * 60 --秒
					if (hour >= 24) then --大于1天
						local day = math.floor(hour / 24)
						strLastLoginTime = string.format(hVar.tab_string["__TEXT_LOGINTIME_DAY"], day)
					elseif (hour >= 1) then --大于1小时
						strLastLoginTime = string.format(hVar.tab_string["__TEXT_LOGINTIME_HOUR"], hour)
					elseif (minute >= 1) then --大于1分钟
						strLastLoginTime = string.format(hVar.tab_string["__TEXT_LOGINTIME_MINUTE"], minute)
					else --0分钟
						strLastLoginTime = string.format(hVar.tab_string["__TEXT_LOGINTIME_SECOND"], second)
					end
					
					--如果会长是系统，永远在线
					if (uid < 10000) then
						strLastLoginTime = hVar.tab_string["__TEXT_LOGINTIME_ONLINE"] --"在线"
					end
				end
				
				tQuery[i][7] = strLastLoginTime
				tQuery[i][14] = last_login_time --原上次登录时间
			end
		end
	end
	
	return tQuery
end

--获得申请某个军团的人数
private.Data_GetPowerJoinMemberNum = function(iNcId)
	local sSql = string.format("SELECT count(*) FROM `novicecamp_member` WHERE `ncid` = %d and `level` = %d", iNcId, 0)
	local iErrorCode, iCount = xlDb_Query(sSql)
	return iCount
end

--获得某个军团助理的数量
private.Data_GetAssistantMemberNum = function(iNcId)
	local sSql = string.format("SELECT count(*) FROM `novicecamp_member` WHERE `ncid` = %d and (`level` = %d or `level` = %d)", iNcId, hVar.GROUP_MEMBER_AUTORITY.ASSISTANT, hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM)
	local iErrorCode, iCount = xlDb_Query(sSql)
	return iCount
end

--会长设置/取消设置某个军团助理
private.Data_SetAssistantMember = function(iUid, iLevel)
	local sSql = string.format("UPDATE `novicecamp_member` SET `level` = %d WHERE `uid` = %d", iLevel, iUid)
	local iErrorCode, iCount = xlDb_Query(sSql)
	return iCount
end

private.Data_GetMemberLevel = function(iUid,iNcId)
	local sSql = nil
	if "number" == type(iNcId) then
		sSql = string.format("SELECT `level` FROM novicecamp_member WHERE `uid` = %d AND `ncid`=%d",iUid,iNcId)
	else
		sSql = string.format("SELECT `level` FROM novicecamp_member WHERE `uid` = %d",iUid)
	end
	local iErrorCode,iLevel = xlDb_Query(sSql)
	return iLevel
end
private.Data_SetMemberLevel = function(iUid,iLevel)
	local sSql = nil
	if 1 == iLevel then
		sSql = string.format("UPDATE novicecamp_member SET `level`=%d,`time_jion` = NOW() WHERE `uid`=%d",iLevel,iUid)
	elseif 100 == iLevel then
		sSql = string.format("UPDATE novicecamp_member SET `level`=%d,`time_quit` = NOW() WHERE `uid`=%d",iLevel,iUid)
	else
		sSql = string.format("UPDATE novicecamp_member SET `level`=%d WHERE `uid`=%d",iLevel,iUid)
	end
	xlDb_Execute(sSql)
end

--修改玩家的ncid
private.Data_UpdateMemberNcid = function(iUid,iNcId)
	local sSql = string.format("UPDATE novicecamp_member SET `ncid`=%d WHERE `uid`=%d",iNcId,iUid)
	xlDb_Execute(sSql)
end

private.Data_GetMemberInfo = function(iUid)
	--无效uid
	if (iUid == 0) then
		return
	end
	
	local sSql = string.format("SELECT `ncid`,`level`,`task_count`,`task_max` FROM novicecamp_member WHERE `uid` = %d",iUid)
	local iErrorCode,iNcId,iLevel,iTaskCount,iTaskMax = xlDb_Query(sSql)
	return iNcId,iLevel,iTaskCount,iTaskMax
end
private.Data_InsertMember = function(iUid,iNcId,iLevel)
	local sSql = string.format("INSERT INTO novicecamp_member (`uid`,`ncid`,`level`,`time_jion`) VALUES (%d,%d,%d,NOW())",iUid,iNcId,iLevel)
	xlDb_Execute(sSql)
end

--删除军团成员
private.Data_DeleteMember = function(iUid)
	--记录玩家本周军团捐献总和（删除军团成员）
	--删除前，减去该成员的本周声望
	local sSql = string.format("SELECT `level`, `ncid`, `shengwang_week` FROM `novicecamp_member` WHERE `uid` = %d",iUid)
	local iErrorCode,iLevel,iNcId,shengwang_week = xlDb_Query(sSql)
	if (iErrorCode == 0) then
		--是军团成员
		if (iLevel > 0) then
			--本周有声望
			if (shengwang_week > 0) then
				local sSql = string.format("UPDATE `novicecamp_list` SET `shengwang_week_sum`=`shengwang_week_sum` - %d WHERE `id`=%d",shengwang_week,iNcId)
				xlDb_Execute(sSql)
			end
		end
	end
	
	local sSql = string.format("DELETE FROM novicecamp_member WHERE `uid` = %d",iUid)
	xlDb_Execute(sSql)
end

private.Data_DeleteAllMember = function(iNcid)
	local sSql = string.format("DELETE FROM novicecamp_member WHERE `ncid` = %d",iNcid)
	xlDb_Execute(sSql)
end
private.Data_IncreaseMemberTask = function(iUid)
	local sSql = string.format("UPDATE novicecamp_member SET `task_count`=`task_count`+1 WHERE `uid`=%d",iUid)
	xlDb_Execute(sSql)
end

--获得玩家所在的军团
private.Data_GetNcId = function(iUid)
	local iNcId = 0
	local sSql = string.format("SELECT `ncid` FROM `novicecamp_member` WHERE `uid` = %d and `level` > 0", iUid)
	local iErrorCode, ncid = xlDb_Query(sSql)
	if (iErrorCode == 0) then
		iNcId = ncid
	end
	
	return iNcId
end



--vitality
private.Data_GetVitalityTime = function(iUid)
	local sSql = string.format("SELECT DATEDIFF(CURDATE(),DATE(time_vitality)) FROM t_user WHERE uid = %d",iUid)
	local iErrorCode,iDays = xlDb_Query(sSql)
	return iDays
end
private.Data_SetVitalityTime = function(iUid)
	local sSql = string.format("UPDATE t_user SET time_vitality = NOW() WHERE uid = %d",iUid)
	xlDb_Execute(sSql)
end
private.Data_InsertVitality = function(iNcId,iUid,iTaskId,iVitality)
	local sSql = string.format("INSERT INTO novicecamp_vitality (`ncid`,`uid`,`taskid`,`vitality`) VALUES (%d,%d,%d,%d)",iNcId,iUid,iTaskId,iVitality)
	xlDb_Execute(sSql)
end
private.Data_UpdateVitalityStatistics = function(iNcId,iAddVitality)
	local sSql = string.format("UPDATE novicecamp_vitality_statistics SET `vitality`=`vitality`+%d WHERE `ncid` = %d AND DATEDIFF(CURDATE(),DATE(`time`)) = 0",iAddVitality,iNcId)
	xlDb_Execute(sSql)
end
private.Data_InitVitality = function()
	local sSql = "TRUNCATE novicecamp_vitality_temp"
	xlDb_Execute(sSql)
	
	sSql = "INSERT INTO novicecamp_vitality_temp(ncid,vitality) SELECT `id`,`vitality` FROM novicecamp_list"
	xlDb_Execute(sSql)
	sSql = "UPDATE novicecamp_list SET `vitality`=0"
	xlDb_Execute(sSql)
end
private.Data_InitVitalityStatistics = function()
	local sSql = "SELECT `id` FROM novicecamp_list WHERE dissolution = 0"
	local iErrorCode,tQuery = xlDb_QueryEx(sSql)
	if "table" == type(tQuery) then
		sSql = "INSERT INTO novicecamp_vitality_statistics (`ncid`) VALUES "
		for i=1,#tQuery do
			if #tQuery == i then
				local sTemp = string.format("(%d)",tQuery[i][1])
				sSql = sSql .. sTemp
			else
				local sTemp = string.format("(%d),",tQuery[i][1])
				sSql = sSql .. sTemp
			end
		end
		xlDb_Execute(sSql)
	end
end
private.Data_VitalityTopList = function(iCount)
	local sSql = string.format("SELECT `master_uid`,`vitality` FROM novicecamp_list WHERE dissolution = 0 AND `vitality` >= 200 ORDER BY vitality DESC,`id` ASC LIMIT %d",iCount)
	local iErrorCode,tQuery = xlDb_QueryEx(sSql)
	return tQuery
end


private.Data_Date = function()
	local iErrorCode,sDate = xlDb_Query("SELECT DATE_FORMAT(NOW(),\'%Y-%m-%d\')")
	return sDate
end
private.Data_Order = function(iType,iUid,iRid,iItemId,iCoin,sItemName,sExt01)
	sItemName = sItemName or ""
	sExt01 = sExt01 or ""
	local sSql = string.format("INSERT INTO `order` (`type`, uid, rid, itemid, itemnum, coin, itemname, ext_01) VALUES (%d, %d, %d, %d, 1, %d, '%s', '%s')",iType,iUid,iRid,iItemId,iCoin,sItemName,sExt01)
	--print(sSql)
	xlDb_Execute(sSql)
end

--插入一条捐献记录
private.Data_Donate = function(uid, groupId, strItemName, channelId, sessionId, cfgId, gameDiff, iron, wood, food, strTactic, strHero, groupCoin)
	sItemName = sItemName or ""
	sExt01 = sExt01 or ""
	local sSql = string.format("INSERT INTO `novicecamp_member_donate_log` (`uid`, `ncid`, `itemname`, `channelId`, `sessionId`, `cfgId`, `game_diff`, `mat_iron_donate`, `mat_wood_donate`, `mat_food_donate`, `tactic_donate`, `hero_donate`, `group_coin`, `time`) VALUES (%d, %d, '%s', %d, %d, %d, %d, %d, %d, %d, '%s', '%s', %d, NOW())", uid, groupId, strItemName, channelId, sessionId, cfgId, gameDiff, iron, wood, food, strTactic, strHero, groupCoin)
	--print(sSql)
	xlDb_Execute(sSql)
	
	--记录玩家本周军团捐献总和（军团市场捐献）
	if (groupId > 0) then
		--本次声望
		local shengwang = iron * 2 + wood + food
		
		--更新个人表
		if (shengwang > 0) then
			local sUpdate = string.format("update `novicecamp_member` set `shengwang_week` = `shengwang_week` + %d where `uid` = %d", shengwang, uid)
			xlDb_Execute(sUpdate)
		end
		
		--更新军团表
		if (shengwang > 0) then
			local sUpdate = string.format("update `novicecamp_list` set `shengwang_week_sum` = `shengwang_week_sum` + %d where `id` = %d", shengwang, groupId)
			xlDb_Execute(sUpdate)
		end
	end
end

--增加军团币
private.Data_IncreaseGroupCoin = function(uid, groupCoin)
	local sUpdate = string.format("update `t_chat_user` set `group_coin` = `group_coin` + %d where `uid` = %d", groupCoin, uid)
	xlDb_Execute(sUpdate)
end

--graduate
private.Data_InsertGraduate = function(iNcId,iUid)
	local sSql = string.format("INSERT INTO novicecamp_graduate (`ncid`,`uid`) VALUES (%d,%d)",iNcId,iUid)
	xlDb_Execute(sSql)
end
private.Data_GetGraduateNcId = function(iUid)
	local sSql = string.format("SELECT ncid FROM novicecamp_graduate WHERE uid = %d",iUid)
	local iErrorCode,iNcId = xlDb_Query(sSql)
	return iNcId
end

--user info
private.Data_GetCoin = function(iUid)
	local sSql = string.format("SELECT gamecoin_online FROM t_user WHERE uid = %d",iUid)
	local iErrorCode,iCoin = xlDb_Query(sSql)
	return iCoin
end
private.Data_AddCoin = function(iUid,iCoin)
	if (iCoin >= 0) then
		local sSql = string.format("UPDATE t_user SET gamecoin_online = gamecoin_online + %d WHERE uid = %d",iCoin,iUid)
		xlDb_Execute(sSql)
	else
		--统计游戏币累加值
		local sSql = string.format("UPDATE t_user SET gamecoin_online = gamecoin_online + %d, `gamecoin_totalnum` = `gamecoin_totalnum` + %d WHERE uid = %d",iCoin,-iCoin,iUid)
		xlDb_Execute(sSql)
	end
end
private.Data_GetOffLineDays = function(iUid)
	local sSql = string.format("SELECT DATEDIFF(CURDATE(),DATE(last_login_time)) FROM t_user WHERE uid = %d",iUid)
	local iErrorCode,iDays = xlDb_Query(sSql)
	return iDays
end
private.Data_IsNovice = function(iUid)
	local sSql = string.format("SELECT uid FROM t_user WHERE uid = %d AND create_time >= '2017-03-28 00:00:00'",iUid)
	local iErrorCode,iIsNovice = xlDb_Query(sSql)
	if "number" == type(iIsNovice) then
		return true
	else
		return false
	end
end
private.Data_GetMyNcPrize = function(iUid)
	local sSql = string.format("SELECT build_prize FROM t_user WHERE uid = %d",iUid)
	local iErrorCode,sBuildPrize = xlDb_Query(sSql)
	return sBuildPrize
end
private.Data_UpdateMyNcPrize = function(iUid,sBuildPrize)
	local sSql = string.format("UPDATE t_user SET build_prize = \'%s\' WHERE uid = %d",sBuildPrize,iUid)
	xlDb_Execute(sSql)
end
private.Data_InsertMyNcPrize = function(iUid,iType,sKey,iNcId)
	local sSql = string.format("INSERT INTO prize (`uid`,`type`,`mykey`,`group_id`) VALUES (%d,%d,\'%s\',%d)",iUid,iType,sKey,iNcId)
	xlDb_Execute(sSql)
end

--检测是否有昨日补发的军饷
private.Data_CheckYesterdayMilitaryReward = function(iUid, iNcId, iCoin)
	local single_count_yesterday = 0 --昨日军团单人副本挑战次数
	local couple_count_yesterday = 0 --昨日军团组队副本挑战次数
	local reward_state_yesterday = 0 --昨日领取状态
	
	--查询今日军团副本已挑战次数
	local sQuery = string.format("SELECT `battle_single_count`, `last_battle_single_time`, `battle_couple_count`, `last_battle_couple_time`, `last_military_reward_time` from `t_chat_user` where `uid` = %d", iUid)
	local err1, battle_single_count, last_battle_single_time, battle_couple_count, last_battle_couple_time, last_military_reward_time = xlDb_Query(sQuery)
	--print(err1)
	if (err1 == 0) then
		--今日时间戳
		local nTimestampNow = os.time()
		local strDatestampNowYMD = hApi.Timestamp2Date(nTimestampNow) --转字符串(年月日)
		local strNewdateZeroNow = strDatestampNowYMD .. " 00:00:00" --今日0点
		local nTimestampZeroNow = hApi.GetNewDate(strNewdateZeroNow) --今日0点
		
		local nTimestampZeroYesterday = hApi.GetNewDate(strNewdateZeroNow, "DAY", -1) --昨日0点
		local nTimestampBattleSingleTime = hApi.GetNewDate(last_battle_single_time) --最近一次单人副本挑战时间
		local nTimestampBattleCoupleTime = hApi.GetNewDate(last_battle_couple_time) --最近一次组队副本挑战时间
		local nTimestampMilitaryRewardTime = hApi.GetNewDate(last_military_reward_time) --最近一次领取时间
		
		--如果最近一次领取时间比昨天更早，才处理
		if (nTimestampMilitaryRewardTime < nTimestampZeroYesterday) then
			--print("process")
			
			--检测昨日单人副本的挑战次数
			if (nTimestampBattleSingleTime >= nTimestampZeroYesterday) and (nTimestampBattleSingleTime < nTimestampZeroNow) then
				single_count_yesterday = battle_single_count
			end
			
			--检测昨日组队副本的挑战次数
			if (nTimestampBattleCoupleTime >= nTimestampZeroYesterday) and (nTimestampBattleCoupleTime < nTimestampZeroNow) then
				couple_count_yesterday = battle_couple_count
			end
			
			--昨日符合领取军饷的条件
			if (single_count_yesterday >= hVar.GROUP_DAYEWARD_SINGLE_BATTLE_COUNT) and (couple_count_yesterday >= hVar.GROUP_DAYEWARD_COUPLE_BATTLE_COUNT) then
				--print("okokokokokokok")
				--补发奖励
				local sKey = string.format(hVar.tab_string["__TEXT_GROUP_DALIYREWARD_MAIL"], iCoin)
				private.Data_InsertMyNcPrize(iUid,20031,sKey,iNcId)
				
				--更新领取军饷时间
				local sUpdate = string.format("UPDATE `t_chat_user` SET `last_military_reward_time` = '%s' WHERE uid = %d", os.date("%Y-%m-%d %H:%M:%S", nTimestampZeroYesterday), iUid)
				--print("sUpdate1:",sUpdate)
				xlDb_Execute(sUpdate)
			end
		end
		
		--print("today zero=", os.date("%Y-%m-%d %H:%M:%S", nTimestampZeroNow))
		--print("yesterday zero=", os.date("%Y-%m-%d %H:%M:%S", nTimestampZeroYesterday))
		--print("single_count_yesterday=", single_count_yesterday)
		--print("couple_count_yesterday=", couple_count_yesterday)
	end
end

private.Data_UpgradeBuild = function(tMyBuild,iBuildId)
	local bInsert = true
	local tBuilds = nil
	if "number" == type(iBuildId) and "table" == type(tMyBuild) and "table" == type(tMyBuild.buildlist) then
		tBuilds = tMyBuild.buildlist
		for i=1,#tBuilds do
			if tBuilds[i].id == iBuildId then
				tBuilds[i].lv = tBuilds[i].lv + 1
				bInsert = false
				break
			end
		end
	end
	if bInsert then 
		tBuilds[#tBuilds + 1] = {}
		tBuilds[#tBuilds].id = iBuildId
		tBuilds[#tBuilds].lv = 1
	end
end
private.Data_DefaultBuild = function(iMyCountry)
	local t = {mainlv = 1,technologylv = 0,randlv = 0,food = 0,wood = 0,iron = 0,buildlist={}}
	t.buildlist[1] = {id = 80068,lv = 1}
	return t
end
private.Data_GetLevel = function(tMyBuild,iBuildId)
	local iLevel = 0
	if "number" == type(iBuildId) and "table" == type(tMyBuild) and "table" == type(tMyBuild.buildlist) then
		local tBuilds = tMyBuild.buildlist
		for i=1,#tBuilds do
			--print("Data_GetLevel",i,#tBuilds,tBuilds[i].id,iBuildId)
			if tBuilds[i].id == iBuildId then
				iLevel = tBuilds[i].lv
				break
			end
		end
	end
	return iLevel
end
private.Data_IsMyCountry = function(iMyCountry,iBuildCountry)
	--iMyCountry (1,2,3)魏蜀吴
	--iBuildCountry(1,2,4)魏蜀吴

	if "number" ~= type(iMyCountry) or "number" ~= type(iBuildCountry) then return false end

	if 1 == iMyCountry then
		if 1 == iBuildCountry or 3 == iBuildCountry or 5 == iBuildCountry or 7 == iBuildCountry or 255 == iBuildCountry then
			return true
		else
			return false
		end
	elseif 2 == iMyCountry then
		if 2 == iBuildCountry or 3 == iBuildCountry or 6 == iBuildCountry or 7 == iBuildCountry or 255 == iBuildCountry then
			return true
		else
			return false
		end
	elseif 3 == iMyCountry then
		if 4 == iBuildCountry or 5 == iBuildCountry or 6 == iBuildCountry or 7 == iBuildCountry or 255 == iBuildCountry then
			return true
		else
			return false
		end
	else
		return false
	end
end
private.Data_IsPrizeOver = function(tMyBuildPrize,sBuildType,iPrizeId)
	if "table" == type(tMyBuildPrize) and "string" == type(sBuildType) and "number" == type(iPrizeId) then
		if "table" ~= type(tMyBuildPrize[sBuildType]) then
			tMyBuildPrize[sBuildType] = {}
			return false
		else
			local tPrize = tMyBuildPrize[sBuildType]
			for i=1,#tPrize do
				if iPrizeId == tPrize[i] then
					return true
				end
			end
			return false
		end
	else
		return true
	end
end
private.Data_DailyProvide = function()
	local sSql = "SELECT `id`,`mat_iron`,`mat_wood`,`mat_food`,`buildinfo` FROM novicecamp_list WHERE `dissolution` = 0"
	local iErrorCode,tNcList = xlDb_QueryEx(sSql)
	if 0 == iErrorCode and "table" == type(tNcList) and 0 < #tNcList then
		local sSqlIron = ""
		local sSqlWood = ""
		local sSqlFood = ""
		local sSqlNcid = ""
		local sSqlVitality = ""
		local sSqlUpdate = 0
		for i=1,#tNcList do
			local ncid = tNcList[i][1]
			local iIron = tNcList[i][2]
			local iWood = tNcList[i][3]
			local iFood = tNcList[i][4]
			local sBuild = tNcList[i][5]
			local tMyBuild = private.Helper_String2Table(sBuild)
			if "table" == type(tMyBuild) and (0 < tMyBuild.food or 0 < tMyBuild.wood or 0 < tMyBuild.iron) then
				sSqlIron = string.format("%s WHEN %d THEN %d",sSqlIron,ncid,(tMyBuild.iron + iIron))
				sSqlWood = string.format("%s WHEN %d THEN %d",sSqlWood,ncid,(tMyBuild.wood + iWood))
				sSqlFood = string.format("%s WHEN %d THEN %d",sSqlFood,ncid,(tMyBuild.food + iFood))
				sSqlVitality = string.format("%s WHEN %d THEN %d",sSqlVitality,ncid,((tMyBuild.mainlv + tMyBuild.technologylv)*30))
				if 0 == sSqlUpdate then
					sSqlNcid = string.format("%d",ncid)
				else
					sSqlNcid = string.format("%s,%d",sSqlNcid,ncid)
				end
				sSqlUpdate = 1
			end
		end
		if 1 == sSqlUpdate then
			--sSqlUpdate = string.format("UPDATE novicecamp_list SET mat_iron = (CASE id %s END),mat_food = (CASE id %s END),mat_wood = (CASE id %s END),vitality = (CASE id %s END) WHERE `id` IN(%s)",sSqlIron,sSqlFood,sSqlWood,sSqlVitality,sSqlNcid)
			sSqlUpdate = string.format("UPDATE novicecamp_list SET vitality = (CASE id %s END) WHERE `id` IN(%s)",sSqlVitality,sSqlNcid)
			--print("Data_DailyProvide",sSqlUpdate)
			hGlobal.fileWriter:Write(sSqlUpdate)
			xlDb_Execute(sSqlUpdate)
		end
		if 0 < #sSqlNcid then
			sSqlUpdate = string.format("UPDATE novicecamp_list SET vitality = 0 WHERE `id` NOT IN(%s)",sSqlNcid)
		else
			sSqlUpdate = "UPDATE novicecamp_list SET vitality = 0"
		end
		hGlobal.fileWriter:Write(sSqlUpdate)
		xlDb_Execute(sSqlUpdate)
	end
end

--private mail
private.Data_InsertPrivateMail = function(iUid,sInfo,sExt)
	local sSql = string.format("INSERT INTO private_mail(`uid`,`mailinfo`,`mailext`,`time_begin`) VALUES(%d,\'%s\',\'%s\',NOW())",iUid,sInfo,sExt)
	xlDb_Execute(sSql)
end

--activity
private.Data_IsActiviting = function()
	local sSql = string.format("SELECT aid FROM activity_template WHERE `type` = 351 AND time_begin <= NOW() AND NOW() <= time_end LIMIT 1")
	local iErrorCode,IsActiviting = xlDb_Query(sSql)
	return IsActiviting
end

--loopcheck
private.Data_GetDailyVitalityTime = function()
	local sSql = "SELECT DATEDIFF(CURDATE(),DATE(time_check)),DAYOFMONTH(NOW()) FROM novicecamp_dailycheck ORDER BY id DESC LIMIT 1"
	local iErrorCode,iDays,iWeek = xlDb_Query(sSql)
	return iDays,iWeek
end
private.Data_SetDailyVitalityTime = function()
	local sSql = "INSERT INTO novicecamp_dailycheck() VALUES()"
	xlDb_Execute(sSql)
end


--helper functions
private.Helper_String2Table = function(s)
	local t = nil
	if "string" == type(s) then
		if s == "" then return t end
		local sss = string.format("g_temple_cmd = %s",s)
		--print(sss)
		loadstring(sss)()
		t = g_temple_cmd
		g_temple_cmd = nil
	end
	return t
end

--计算抽宝箱的结果
--返回值: 字符串
--发奖数量;发奖序号1;发奖序号2;发奖序号3;总展示奖励数量;展示奖励1;展示奖励2;展示奖励3;展示奖励4;展示奖励5;
--366021;20008;3;4;1;2;5;1:2000:0:0;1:1600:0:0;11:20:0:0;11:25:0:0;5:10226:6:0;
--private:CalculateChestResult(sessionCfgId, diff, nTime)
private.CalculateChestResult = function(sessionCfgId, diff, nTime)
	--奖励对象
	local allReward = hClass.Reward:create():Init()
	
	--返回值
	local sCmd = ""
	
	local tabR = hVar.tab_roomcfg[sessionCfgId]
	
	--通用奖池
	local dropPool = hVar.tab_droppool
	
	if tabR.reward and tabR.reward[diff] then
		local rewardPool = tabR.reward[diff]
		
		--遍历的掉落配置
		for i = 1, #rewardPool do
			--通用奖池中的奖池键值
			local poolkey = rewardPool[i][1]
			
			--最少掉落
			local minNum = rewardPool[i][2]
			
			--最多掉落
			local maxNum = math.max(rewardPool[i][3], minNum)
			
			local rollDrop = hApi.RollDrop(dropPool[poolkey])
			
			--随机一个掉落的数量
			local dropNum = math.random(minNum, maxNum)
			--如果随机出的掉落区间数量大于0，则进行掉落（todo：考虑下要不要把相同的掉落合并，貌似没啥必要）
			if dropNum > 0 then
				local addOk,idx = allReward:Add(rollDrop)
				--重新设置数量
				if addOk then
					allReward:SetRewardNum(idx,dropNum)
				end
			end
		end
	end
	
	local rewardPerWeekNum = 0
	--遍历每周掉落配置
	if tabR.rewardPerWeek and tabR.rewardPerWeek[diff] and type(tabR.rewardPerWeek[diff]) == "table" then
		local rewardPerWeek = tabR.rewardPerWeek[diff]
		local minNum = rewardPerWeek.min or 1
		local maxNum = rewardPerWeek.max or 1
		local dropNum = math.random(minNum, maxNum)
		
		local generateTime
		local weekNow = tonumber(os.date("%W", nTime))
		local yearNow = tonumber(os.date("%Y", nTime))
		if weekNow and yearNow and weekNow >= 0 and yearNow > 0 then
			generateTime = yearNow * 100 + weekNow
		end
		
		if #rewardPerWeek > 0 then
			local index = (math.mod(generateTime, #rewardPerWeek) + 1) or 0
			
			local rollDrop = rewardPerWeek[index] or {}
			if rollDrop[1] > 0 and rollDrop[2] > 0 and dropNum > 0 then
				local addOk,idx = allReward:Add(rollDrop)
				--重新设置数量
				if addOk then
					allReward:SetRewardNum(idx,dropNum)
				end
				rewardPerWeekNum = rewardPerWeekNum + 1
			end
		end
	end
	
	local tmpIdxList = {}
	for i = 1, allReward:GetNum() do
		tmpIdxList[#tmpIdxList + 1] = i
	end
	
	--发奖序号表
	local rewardIdxList = {}
	local num = 0
	if tabR.reward and tabR.reward[diff] then
		num = tabR.reward[diff].rewardNum
	end
	local getNum = math.min(num + rewardPerWeekNum,allReward:GetNum())
	for n = 1, getNum do
		local idx = math.random(1,#tmpIdxList)
		rewardIdxList[#rewardIdxList + 1] = tmpIdxList[idx]
		table.remove(tmpIdxList,idx)
		
		sCmd = sCmd .. rewardIdxList[#rewardIdxList] .. ";"
	end
	sCmd = getNum .. ";" .. sCmd
	sCmd = sCmd .. allReward:ToCmd()
	
	return allReward, rewardIdxList, sCmd
end

--[[
private.Helper_Table2String = function(t)
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
                sString = sString .. "[==[" .. tostring(v) .. "]==],"
            elseif "table" == type(v) then
                sString = sString .. private.Helper_Table2String(v) .. ","
            end
        end
        return sString .. "}"
    else
        return "nil"
    end
end
]]


--序列化 表->字符串(无回车符)
local serialize_noline_short = nil
serialize_noline_short = function(obj)
	local lua = ""
	local t = type(obj)
	if (t == "number") then
		lua = lua .. tostring(obj)
	elseif (t == "boolean") then
		lua = lua .. tostring(obj)
	elseif (t == "string") then
		lua = lua .. string.format("%q", obj)
	elseif (t == "table") then
		--检测是否为纯数组表
		local bNumber = true
		local nMin = 9999
		local nMax = -9999
		local nCount = 0
		for k, v in pairs(obj) do  
			if (type(k) ~= "number") then
				bNumber = false --不是数组表
				break
			else
				nCount = nCount + 1
				
				if (k < nMin) then
					nMin = k
				end
				
				if (k > nMax) then
					nMax = k
				end
			end
		end
		if bNumber and (nMin == 1) and (nMax == nCount) then
			lua = lua .. "{"
			for i = 1, nCount, 1 do
				lua = lua .. serialize_noline_short(obj[i]) .. ","
			end
			lua = lua .. "}"
		else
			lua = lua .. "{"
			for k, v in pairs(obj) do
				lua = lua .. "[" .. serialize_noline_short(k) .. "]=" .. serialize_noline_short(v) .. ","
			end
			lua = lua .. "}"
		end
	elseif (t == "function") then
		lua = lua .. "\"" .. tostring(obj) .. "\""
	elseif (t == "nil") then
		return nil
	else
		error("can not serialize_noline_short a " .. tostring(t) .. " type.")
	end 
	
	return lua
end


private.Helper_Table2String = function(obj)
	local lua = ""
	local t = type(obj)  
	
	if (t == "number") then
		lua = lua .. obj
	elseif (t == "boolean") then
		lua = lua .. tostring(obj)
	elseif (t == "string") then
		lua = lua .. string.format("%q", obj)
	elseif (t == "table") then
		lua = lua .. "{\n"
		
		--检测是否为纯数组表
		local bNumber = true
		local nMin = 9999
		local nMax = -9999
		local nCount = 0
		for k, v in pairs(obj) do  
			if (type(k) ~= "number") then
				bNumber = false --不是数组表
				break
			else
				nCount = nCount + 1
				
				if (k < nMin) then
					nMin = k
				end
				
				if (k > nMax) then
					nMax = k
				end
			end
		end
		if bNumber and (nMin == 1) and (nMax == nCount) then
			for i = 1, nCount, 1 do
				lua = lua .. serialize_noline_short(obj[i]) .. ",\n"
			end
		else
			for k, v in pairs(obj) do
				lua = lua .. "[" .. serialize_noline_short(k) .. "]=" .. serialize_noline_short(v) .. ",\n"
			end
		end
		
		lua = lua .. "}"
	elseif (t == "function") then
		lua = lua .. "\"" .. tostring(obj) .. "\""
	end
	
	return lua
end

NoviceCampMgr.Helper_Table2Cmd = function(t)
    --01 转成LUA表定义字符串 或者把01换成你自己的：分割的格式定义
    local sCmd = "g_temple_cmd=" .. private.Helper_Table2String(t)
    --02 TODO 加密(暂时没)
    --sCmd = EncryptString(sCmd)
    
    return sCmd
end
NoviceCampMgr.Helper_Cmd2Table = function(sCmd)
    --01 TODO 解密(暂时没)
    --sCmd = DecryptString(sCmd)
    --02 字符串转成lua表
    loadstring(sCmd)()
    local t = g_temple_cmd
    g_temple_cmd = nil
    
    return t
end




--public interface
local GROUP_RANKBOARD_LASTTIMESTAMP = 0 --军团排行榜上次查询的时间戳
local GROUP_RANKBOARD_DELTATIME = 60 --军团排行榜查询时间间隔（单位：秒）
local GROUP_RANKBOARD_TCMD = {} --上次军团排行榜信息（用于查询优化）
NoviceCampMgr.GetNcList = function(tCmd)
	--今日时间戳
	local nTimestampNow = os.time()
	local deltatime = nTimestampNow - GROUP_RANKBOARD_LASTTIMESTAMP
	local tRes = nil
	
	--print("deltatime=", deltatime)
	if (deltatime <= GROUP_RANKBOARD_DELTATIME) then --距离上次查询时间较短，取上次的数据
		tRes = GROUP_RANKBOARD_TCMD
		
		--需要实时查询玩家此刻所在的军团信息
		local iNcId,iLevel = private.Data_GetMemberInfo(tCmd.uid)
		if nil == iNcId then
			iNcId = 0
			iLevel = -1
		end
		tRes.data.ncid = iNcId
		tRes.data.level = iLevel
	else
		tRes = {err=0,data={}}
		local iNcId,iLevel = private.Data_GetMemberInfo(tCmd.uid)
		local tList = private.Data_GetNcList(tCmd.type)
		local sPrize = "" --private.Data_GetMyNcPrize(tCmd.uid) --不需要查prize了
		if tList then tRes.data = tList end
		if nil == iNcId then
			iNcId = 0
			iLevel = -1
		end
		tRes.data.ncid = iNcId
		tRes.data.level = iLevel
		tRes.data.prize = sPrize
		
		--存储本次的
		GROUP_RANKBOARD_LASTTIMESTAMP = nTimestampNow
		GROUP_RANKBOARD_TCMD = tRes
		--print("查询军团的排行榜")
	end
	
	local sL2CCmd = NoviceCampMgr.Helper_Table2Cmd(tRes)
	return sL2CCmd
end

--新玩家申请军团查询军团列表
local GROUPJOIN_RANKBOARD_LASTTIMESTAMP = 0 --军团排行榜上次查询的时间戳
local GROUPJOIN_RANKBOARD_DELTATIME = 60 --军团排行榜查询时间间隔（单位：秒）
local GROUPJOIN_RANKBOARD_TCMD = {} --上次军团排行榜信息（用于查询优化）
NoviceCampMgr.Data_GetNcList_Join = function(tCmd)
	--今日时间戳
	local nTimestampNow = os.time()
	local deltatime = nTimestampNow - GROUPJOIN_RANKBOARD_LASTTIMESTAMP
	local tRes = nil
	
	--print("deltatime=", deltatime)
	if (deltatime <= GROUPJOIN_RANKBOARD_DELTATIME) then --距离上次查询时间较短，取上次的数据
		tRes = GROUPJOIN_RANKBOARD_TCMD
		
		--需要实时查询玩家此刻所在的军团申请信息
		local iNcId,iLevel = private.Data_GetMemberInfo(tCmd.uid)
		if nil == iNcId then
			iNcId = 0
			iLevel = -1
		end
		tRes.data.ncid = iNcId
		tRes.data.level = iLevel
	else
		tRes = {err=0,data={}}
		local iNcId,iLevel = private.Data_GetMemberInfo(tCmd.uid)
		local tList = private.Data_GetNcList_Join(tCmd.type)
		--local sPrize = private.Data_GetMyNcPrize(tCmd.uid)
		if tList then tRes.data = tList end
		if nil == iNcId then
			iNcId = 0
			iLevel = -1
		end
		tRes.data.ncid = iNcId
		tRes.data.level = iLevel
		--tRes.data.prize = sPrize
		
		--存储本次的
		GROUPJOIN_RANKBOARD_LASTTIMESTAMP = nTimestampNow
		GROUPJOIN_RANKBOARD_TCMD = tRes
		--print("查询军团申请的排行榜")
	end
	
	local sL2CCmd = NoviceCampMgr.Helper_Table2Cmd(tRes)
	return sL2CCmd
end

--查找军团列表
local GROUPSEARCH_RANKBOARD_LASTTIMESTAMP = 0 --查找军团上次查询的时间戳
local GROUPSEARCH_RANKBOARD_DELTATIME = 60 --查找军团查询时间间隔（单位：秒）
local GROUPSEARCH_RANKBOARD_TCMD = {} --上次查找军团信息（用于查询优化）
local GROUPSEARCH_RANKBOARD_KEYWORD = ""
NoviceCampMgr.Data_GetNcList_Join_Seach = function(tCmd)
	--今日时间戳
	local nTimestampNow = os.time()
	local deltatime = nTimestampNow - GROUPSEARCH_RANKBOARD_LASTTIMESTAMP
	local tRes = nil
	
	--print("deltatime=", deltatime)
	if (deltatime <= GROUPSEARCH_RANKBOARD_DELTATIME) and (tCmd.searchName == GROUPSEARCH_RANKBOARD_KEYWORD) then --距离上次查询时间较短并且关键字相同，取上次的数据
		tRes = GROUPSEARCH_RANKBOARD_TCMD
		
		--需要实时查找军团列表
		local iNcId,iLevel = private.Data_GetMemberInfo(tCmd.uid)
		if nil == iNcId then
			iNcId = 0
			iLevel = -1
		end
		tRes.data.ncid = iNcId
		tRes.data.level = iLevel
	else
		tRes = {err=0,data={}}
		local iNcId,iLevel = private.Data_GetMemberInfo(tCmd.uid)
		local tList = private.Data_GetNcList_Join_Seach(tCmd.type, tCmd.searchName)
		--local sPrize = private.Data_GetMyNcPrize(tCmd.uid)
		if tList then tRes.data = tList end
		if nil == iNcId then
			iNcId = 0
			iLevel = -1
		end
		tRes.data.ncid = iNcId
		tRes.data.level = iLevel
		--tRes.data.prize = sPrize
		
		--存储本次的
		GROUPSEARCH_RANKBOARD_LASTTIMESTAMP = nTimestampNow
		GROUPSEARCH_RANKBOARD_TCMD = tRes
		GROUPSEARCH_RANKBOARD_KEYWORD = tCmd.searchName
		--print("查找军团列表", tCmd.searchName)
	end
	
	local sL2CCmd = NoviceCampMgr.Helper_Table2Cmd(tRes)
	return sL2CCmd
end

--创建工会
NoviceCampMgr.CreateNc = function(tCmd)
	local tRes = {err=0}
	--01校验参数
	if "number" == type(tCmd.type) and "string" == type(tCmd.name) and 0 < string.len(tCmd.name) and "string" == type(tCmd.descripe) and 0 < string.len(tCmd.descripe) and "number" == type(tCmd.master_uid) and "string" == type(tCmd.master_name) and "number" == type(tCmd.country) then
		--02创建啥 新手营还是工会（暂不支持）
		if 1 == tCmd.type then
			--玩家离开军团的时间(秒)
			local leavesecounds = hGlobal.groupMgr:GetUserLeaveTime(0, tCmd.master_uid)
			if (leavesecounds > 86400) then
				--检测vip等级是否有权限创建军团
				local vipLv = hGlobal.vipMgr:DBGetUserVip(tCmd.master_uid) --玩家vip等级
				local bCreateGroup = hVar.Vip_Conifg.createGroup[vipLv] --是否可创建军团权限
				if bCreateGroup then
					--检测操作者是否禁言状态
					local forbidden = 0
					local user = hGlobal.uMgr:FindUserByDBID(tCmd.master_uid)
					if user then
						forbidden = user:GetForbidden()
					end
					if (forbidden == 0) then
						--02判断游戏币
						local iCoin = private.Data_GetCoin(tCmd.master_uid)
						local iNcFee = private.Config_GetNCFee()
						if "number" == type(iCoin) and iNcFee <= iCoin then
							--03判断该uid是否已有所属
							local iLevel = private.Data_GetMemberLevel(tCmd.master_uid)
							--ext 新需求如果只是申请中可以直接创建
							if "number" == type(iLevel) and 0 == iLevel then
								private.Data_DeleteMember(tCmd.master_uid)
								iLevel = nil
							end
							
							if nil == iLevel then
								--05插入nc表
								local iNcId = private.Data_InsertNc(tCmd.name,tCmd.descripe,tCmd.type,tCmd.master_uid,tCmd.master_name,tCmd.country)
								--06插入member表
								if iNcId then 
									private.Data_InsertMember(tCmd.master_uid,iNcId,hVar.GROUP_MEMBER_AUTORITY.ADMIN)
									private.Data_AddCoin(tCmd.master_uid,-iNcFee)
									local itemId = 101
									private.Data_Order(22,tCmd.master_uid,0,itemId,iNcFee,hVar.tab_stringI[itemId])
									
									tRes.data = {ncid=iNcId}
									
									hGlobal.groupMgr:OnCreateGroup(iNcId, tCmd.master_uid, hVar.GROUP_MEMBER_AUTORITY.ADMIN)
								else
									--您输入的军团名已存在
									tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_GROUPNAME_SAME
								end
							else
								--您已加入或申请军团
								tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_JOIN_OR_SUBMIT_GROUP
							end
						else
							--您没有足够的游戏币
							tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_NOT_ENOUGH_GAMECOIN
						end
					else
						--您被禁言无法创建军团
						tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_CREATE_GROUP_FORBIDDEN
					end
				else
					--VIP2及以上才能创建军团
					tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_CREATE_VIP_LEVEL
				end
			else
				--退出军团24小时以上才能创建
				tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_CREATE_24HOUR
			end
		else
			--参数不合法
			tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
		end
	else
		--参数不合法
		tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
	end
	
	--操作失败通知客户度错误信息
	if (tRes.err > 1) then
		--通知玩家操作结果
		local sCmd = tostring(tRes.err)
		hApi.xlNet_Send(tCmd.master_uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

--解散工会
NoviceCampMgr.RemoveNc = function(tCmd)
	local tRes = {err=0}
	local iMasterUid,iDissolution = private.Data_GetNcInfo(tCmd.ncid)
	if nil == iMasterUid then
		--参数不合法
		tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
	else
		if iMasterUid == tCmd.uid then
			if 0 == iDissolution then
				--玩家加入军团的时间(秒)
				local entersecounds = hGlobal.groupMgr:GetUserEnterTime(tCmd.ncid, tCmd.uid)
				if (entersecounds > 86400) then
					private.Data_DeleteAllMember(tCmd.ncid)
					
					--通知事件
					hGlobal.groupMgr:OnRemoveGroup(tCmd.ncid, tCmd.uid)
					
					private.Data_SetNcDissolution(tCmd.ncid,tCmd.uid,1)
				else
					--加入军团24小时以上才能解散
					tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISSOLUTION_24HOUR
				end
			else
				--该军团不存在或已解散
				tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISSOLUTION_GROUP
			end
		else
			--您没有权限进行此操作
			tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY
		end
	end
	
	--操作失败通知客户度错误信息
	if (tRes.err > 1) then
		--通知玩家操作结果
		local sCmd = tostring(tRes.err)
		hApi.xlNet_Send(tCmd.uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

--获得工会成员列表
NoviceCampMgr.GetMemberList = function(tCmd)
	local tRes = {err=0}
	tRes.data = private.Data_GetMemberList(tCmd.ncid,tCmd.level)
	if nil == tRes.data then tRes.data = {} end
	tRes.data.ncinfo = private.Data_GetNcInfoTable(tCmd.ncid)
	--print("success 1", tCmd.ncid, tCmd.level)
	tRes.data.ncid = tCmd.ncid
	if "number" == type(tCmd.uid) and "number" == type(tCmd.ncid) then
	else
		tRes.err = 99
	end
	local iLevel = nil
	if 0 == tRes.err then		
		iLevel = private.Data_GetMemberLevel(tCmd.uid,tCmd.ncid)
	end
	--print("success 2")
	if "number" == type(iLevel) and 0 < iLevel then
		local days = private.Data_GetVitalityTime(tCmd.uid)
		if "number" == type(days) and 0 < days then
			if "table" == type(tRes.data.ncinfo) and "string" == type(tRes.data.ncinfo[15]) then
				local sBuild = tRes.data.ncinfo[15]
				local tBuild = private.Helper_String2Table(sBuild)
				if "table" == type(tBuild) then
					--[[
					--军团成员每日发游戏币
					local iCoin = hVar.tab_build[80068].legioninfo.provide["COIN"][tBuild.mainlv] or 0
					if 0 < iCoin then
						local sKey = string.format("军团每日游戏币奖励;7:%d:0:0;",iCoin)
						private.Data_InsertMyNcPrize(tCmd.uid,20008,sKey,tCmd.ncid)
					end
					]]
					--检测是否补发昨日未领取的军饷
					local iCoin = hVar.tab_build[80068].legioninfo.provide["COIN"][tBuild.mainlv] or 0
					private.Data_CheckYesterdayMilitaryReward(tCmd.uid, tCmd.ncid, iCoin)
					
					--会长发邮件，今日军团奖励
					if hVar.GROUP_MEMBER_AUTORITY.ADMIN == iLevel then
						local iFood = tBuild.food
						local iWood = tBuild.wood
						local iIron = tBuild.iron
						local iType = math.random(3)
						if 1 == iType then
							local iRand = hVar.tab_build[80207].legioninfo.provide["FOOD"][tBuild.randlv] or 0
							iFood = iFood + iRand
						elseif 2 == iType then
							local iRand = hVar.tab_build[80207].legioninfo.provide["WOOD"][tBuild.randlv] or 0
							iWood = iWood + iRand
						elseif 3 == iType then
							local iRand = hVar.tab_build[80207].legioninfo.provide["IRON"][tBuild.randlv] or 0
							iIron = iIron + iRand
						end
						if 0 < iFood or 0 < iWood or 0 < iIron then
							local sDate = private.Data_Date()
							local sKey = string.format(hVar.tab_string["__TEXT_GROUP_EVENYDAY_REWARD"],tRes.data.ncinfo[1],sDate,iIron,iWood,iFood)
							private.Data_InsertMyNcPrize(tCmd.uid,20031,sKey,tCmd.ncid)
						end
					end
				end
			end
			private.Data_AddVitality(tCmd.ncid,30)
			private.Data_SetVitalityTime(tCmd.uid)
			local info = string.format("AddVitality ncid:%d uid:%d",tCmd.ncid,tCmd.uid)
			hGlobal.fileWriter:Write(info)
		end
	else
		--tRes.err = 99--运行查看别的军团信息
	end
	
	--我在此军团里的权限
	tRes.data.iLevelMe = (iLevel or -1)
	
	--print("success 3", tRes, tostring(tRes))
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

--通过加工会请求
NoviceCampMgr.PowerJionAccept = function(tCmd)
	local tRes = {err=0}
	local iMasterUid,iDissolution,iMemberCount,iMaxMember = private.Data_GetNcInfo(tCmd.ncid)
	if nil == iMasterUid then
		--参数不合法
		tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
	else
		--操作者的权限
		local iLevelOp = private.Data_GetMemberLevel(tCmd.uid,tCmd.ncid)
		--会长、助理都可以操作
		if (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ADMIN) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then
		--if iMasterUid == tCmd.uid then
			--如果是助理，检测今日已操作加人的次数
			local opNum = 0
			if (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --助理
				opNum = hGlobal.groupMgr:GetAssistantOpNum(tCmd.ncid, tCmd.uid)
			end
			--助理未超过每日操作最大次数
			if (opNum < hVar.CHAT_GROUP_ASSITANT_OP_COUNT_MAX) then
				if 0 == iDissolution then
					if iMemberCount >= iMaxMember then
						--军团人数已满
						tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_MENBER_NUM_MAX
					else
						local iLevel = private.Data_GetMemberLevel(tCmd.uid_member,tCmd.ncid)
						if iLevel and 0 == iLevel then
							private.Data_SetMemberLevel(tCmd.uid_member,1)
							private.Data_IncreaseMemberCount(tCmd.ncid)
							
							hGlobal.groupMgr:OnAddGroupMember(tCmd.ncid, tCmd.uid, tCmd.uid_member, 1, iLevelOp)
							
							--助理统计今日操作次数
							if (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --助理
								hGlobal.groupMgr:AddAssistantOpNum(tCmd.ncid, tCmd.uid)
							end
						else
							--无效的玩家
							tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
						end
					end
				else
					--该军团不存在或已解散
					tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISSOLUTION_GROUP
				end
			else
				--军团助理每日只能操作2名玩家的申请
				tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_ACCEPT_ASSISTANT_DAY_MAX
			end
		else
			--您没有权限进行此操作
			tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY
		end
	end
	
	--操作失败通知客户度错误信息
	if (tRes.err > 1) then
		--通知玩家操作结果
		local sCmd = tostring(tRes.err)
		hApi.xlNet_Send(tCmd.uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

--拒绝加工会请求
NoviceCampMgr.PowerJionReject = function(tCmd)
	local tRes = {err=0}
	local iMasterUid,iDissolution = private.Data_GetNcInfo(tCmd.ncid)
	if nil == iMasterUid then
		--参数不合法
		tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
	else
		--if iMasterUid == tCmd.uid then
		--操作者的权限
		local iLevelOp = private.Data_GetMemberLevel(tCmd.uid,tCmd.ncid)
		--会长、助理都可以操作
		if (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ADMIN) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then
			--如果是助理，检测今日已操作加人的次数
			local opNum = 0
			if (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --助理
				opNum = hGlobal.groupMgr:GetAssistantOpNum(tCmd.ncid, tCmd.uid)
			end
			--助理未超过每日操作最大次数
			if (opNum < hVar.CHAT_GROUP_ASSITANT_OP_COUNT_MAX) then
				if 0 == iDissolution then
					local iLevel = private.Data_GetMemberLevel(tCmd.uid_member,tCmd.ncid)
					if iLevel and 0 == iLevel then
						private.Data_DeleteMember(tCmd.uid_member)
						
						--助理统计今日操作次数
						if (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --助理
							hGlobal.groupMgr:AddAssistantOpNum(tCmd.ncid, tCmd.uid)
						end
					else
						--无效的玩家
						tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
					end
				else
					--该军团不存在或已解散
					tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISSOLUTION_GROUP
				end
			else
				--军团助理每日只能操作2名玩家的申请
				tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_ACCEPT_ASSISTANT_DAY_MAX
			end
		else
			--您没有权限进行此操作
			tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY
		end
	end
	
	--操作失败通知客户度错误信息
	if (tRes.err > 1) then
		--通知玩家操作结果
		local sCmd = tostring(tRes.err)
		hApi.xlNet_Send(tCmd.uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

--申请加工会
NoviceCampMgr.PowerJionRequest = function(tCmd)
	local tRes = {err=0, ncid=tCmd.ncid,last_ncid=0,}
	--02 检查工会是否有效
	local iMasterUid,iDissolution,iMemberCount,iMaxMember,iVitality,iGraduate,sTime,iCountry,iIron,iWood,iFood,sBuild,iBuyBattleCount,sLastBuyBattleCountTime,sLastTransfertTime,is_system = private.Data_GetNcInfo(tCmd.ncid)
	if nil == iDissolution then
		--参数不合法
		tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
	elseif 1 == iDissolution then
		--该军团不存在或已解散
		tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISSOLUTION_GROUP
	else
		if iMemberCount >= iMaxMember then
			--军团人数已满
			tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_MENBER_NUM_MAX
		else
			--02自己是否已经有所属了
			--local iLevel = private.Data_GetMemberLevel(tCmd.uid)
			local iNcId,iLevel = private.Data_GetMemberInfo(tCmd.uid)
			if iLevel then
				if (iNcId == tCmd.ncid) then --重复申请同一个军团
					--您已加入或申请军团
					tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_JOIN_OR_SUBMIT_GROUP
				else --不重复的军团
					if (iLevel > 0) then --已经加入别的军团
						--您已加入或申请军团
						tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_JOIN_OR_SUBMIT_GROUP
					else --申请了别的军团，还未通过
						--玩家离开军团的时间(秒)
						local leavesecounds = hGlobal.groupMgr:GetUserLeaveTime(0, tCmd.uid)
						if (leavesecounds > 86400) then
							--检测军团申请人数是否超过上限
							local iPowerJoinCount = private.Data_GetPowerJoinMemberNum(tCmd.ncid)
							local JOIN_MAX = hVar.CHAT_GROUP_REQUEST_NUM_MAX
							if (iPowerJoinCount < JOIN_MAX) then
								--修改玩家的军团申请ncid
								tRes.last_ncid = iNcId
								private.Data_UpdateMemberNcid(tCmd.uid,tCmd.ncid)
								
								--如果是系统军团，直接通过申请（申请别的再申请本军团）
								if (is_system == 1) then
									private.Data_SetMemberLevel(tCmd.uid,1)
									private.Data_IncreaseMemberCount(tCmd.ncid)
									
									hGlobal.groupMgr:OnAddGroupMember(tCmd.ncid, iMasterUid, tCmd.uid, 1, hVar.GROUP_MEMBER_AUTORITY.ADMIN)
								end
							else
								--该军团目前已有太多申请人数
								tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_JOIN_POWER_NUM_MAX
							end
						else
							--退出军团24小时以上才能申请
							tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_JOIN_24HOUR
						end
					end
				end
			else
				--local days = private.Data_GetVitalityTime(tCmd.uid)
				--if "number" == type(days) and 0 < days then
				--玩家离开军团的时间(秒)
				local leavesecounds = hGlobal.groupMgr:GetUserLeaveTime(0, tCmd.uid)
				if (leavesecounds > 86400) then
					--检测军团申请人数是否超过上限
					local iPowerJoinCount = private.Data_GetPowerJoinMemberNum(tCmd.ncid)
					local JOIN_MAX = hVar.CHAT_GROUP_REQUEST_NUM_MAX
					if (iPowerJoinCount < JOIN_MAX) then
						private.Data_InsertMember(tCmd.uid,tCmd.ncid,0)
						
						--如果是系统军团，直接通过申请（直接申请本军团）
						if (is_system == 1) then
							private.Data_SetMemberLevel(tCmd.uid,1)
							private.Data_IncreaseMemberCount(tCmd.ncid)
							
							hGlobal.groupMgr:OnAddGroupMember(tCmd.ncid, iMasterUid, tCmd.uid, 1, hVar.GROUP_MEMBER_AUTORITY.ADMIN)
						end
					else
						--该军团目前已有太多申请人数
						tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_JOIN_POWER_NUM_MAX
					end
				else
					--退出军团24小时以上才能申请
					tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_JOIN_24HOUR
				end
			end
		end
	end
	
	--操作失败通知客户度错误信息
	if (tRes.err > 1) then
		--通知玩家操作结果
		local sCmd = tostring(tRes.err)
		hApi.xlNet_Send(tCmd.uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

--取消申请工会
NoviceCampMgr.PowerJionCancel = function(tCmd)
	local tRes = {err=0, ncid=tCmd.ncid,last_ncid=0,}
	--01自己是否已经有所属了
	local iLevel = private.Data_GetMemberLevel(tCmd.uid,tCmd.ncid)
	if iLevel and 0 == iLevel then
		private.Data_DeleteMember(tCmd.uid)
	else
		--您已加入或申请军团
		tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_JOIN_OR_SUBMIT_GROUP
	end
	
	--操作失败通知客户度错误信息
	if (tRes.err > 1) then
		--通知玩家操作结果
		local sCmd = tostring(tRes.err)
		hApi.xlNet_Send(tCmd.uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

--会长踢人
NoviceCampMgr.PowerFire = function(tCmd)
	--print("NoviceCampMgr.PowerFire")
	local tRes = {err=0,noticeActive=0,ncid=tCmd.ncid,uid_member=tCmd.uid_member,}
	local iMasterUid,iDissolution,iMemberCount,iMaxMember = private.Data_GetNcInfo(tCmd.ncid)
	if nil == iMasterUid then
		--参数不合法
		tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
	else
		--print(iMasterUid, tCmd.uid)
		--if iMasterUid == tCmd.uid then
		--操作者的权限
		local iLevelOp = private.Data_GetMemberLevel(tCmd.uid,tCmd.ncid)
		--会长、助理都可以操作
		if (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ADMIN) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then
			--如果是助理，检测今日已操作踢人的次数
			local kickNum = 0
			if (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --助理
				kickNum = hGlobal.groupMgr:GetAssistantKickNum(tCmd.ncid, tCmd.uid)
			end
			--助理未超过每日踢人最大次数
			if (kickNum < hVar.CHAT_GROUP_ASSITANT_KICK_COUNT_MAX) then
				if 0 == iDissolution then
					local iLevel = private.Data_GetMemberLevel(tCmd.uid_member,tCmd.ncid)
					if iLevel and (iLevel > 0) then
						--不能踢会长
						if (iLevel ~= hVar.GROUP_MEMBER_AUTORITY.ADMIN) then
							--踢出助理前先解除职务
							if (iLevel ~= hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) and (iLevel ~= hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then
								--玩家加入军团的时间(秒)
								--local entersecounds = hGlobal.groupMgr:GetUserEnterTime(tCmd.ncid, tCmd.uid_member)
								--print(entersecounds)
								--if (entersecounds > 86400) then --大于24小时
									--玩家在近24小时内的贡献值为0
									local bPlayerRecentNoDonate = true --是否无贡献
									
									--查找玩家的捐献日志
									local nLogNum = 0
									local strCurrentDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
									local n48HourBeforeTime = hApi.GetNewDate(strCurrentDate, "HOUR", -24) --24小时
									local str48HourBeforeTime = os.date("%Y-%m-%d %H:%M:%S", n48HourBeforeTime)
									local sSql = string.format("SELECT count(*) FROM `novicecamp_member_donate_log` WHERE `uid` = %d and `ncid` = %d and `time` >= '%s'", tCmd.uid_member, tCmd.ncid, str48HourBeforeTime)
									local iErrorCode, count = xlDb_Query(sSql)
									--print(sSql)
									--print(iErrorCode, count)
									if (iErrorCode == 0) then
										nLogNum = count
									end
									if (nLogNum > 0) then
										bPlayerRecentNoDonate = false
									end
									
									--24小时内无贡献才能踢掉
									if bPlayerRecentNoDonate then
										private.Data_DeleteMember(tCmd.uid_member)
										private.Data_DecreaseMemberCount(tCmd.ncid)
										local sMyBuildPrize = private.Data_GetMyNcPrize(tCmd.uid_member)
										local tMyBuildPrize = private.Helper_String2Table(sMyBuildPrize)
										if "table" == type(tMyBuildPrize) then
											tMyBuildPrize["UNIQUETACTICS"] = nil
											sMyBuildPrize = private.Helper_Table2String(tMyBuildPrize)
											private.Data_UpdateMyNcPrize(tCmd.uid_member,sMyBuildPrize)
										end
										local days = private.Data_GetVitalityTime(tCmd.uid_member)
										if "number" == type(days) and 0 == days then
											--会长踢人（24小时内无贡献）
											private.Data_AddVitality(tCmd.ncid,-30)
											local info = string.format("MinusVitalityFire ncid:%d uid:%d",tCmd.ncid,tCmd.uid_member)
											hGlobal.fileWriter:Write(info)
										end
										hGlobal.groupMgr:OnRemoveGroupMember(tCmd.ncid, tCmd.uid, tCmd.uid_member, iLevelOp)
										
										--助理统计今日踢人次数
										if (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --助理
											hGlobal.groupMgr:AddAssistantKickNum(tCmd.ncid, tCmd.uid)
										end
									else
										--踢掉活跃玩家，需要提示操作者此玩家是活跃玩家
										local kickActive = tCmd.kickActive or 0
										if (kickActive == 1) then --踢掉活跃玩家操作
											--查询军团今日已踢掉活跃玩家的次数
											local count = private.Data_GetKickActivePlayerNum(tCmd.ncid)
											if (count < hVar.CHAT_GROUP_KICK_ACTIVE_PLAYER_MAX) then
												private.Data_DeleteMember(tCmd.uid_member)
												private.Data_DecreaseMemberCount(tCmd.ncid)
												local sMyBuildPrize = private.Data_GetMyNcPrize(tCmd.uid_member)
												local tMyBuildPrize = private.Helper_String2Table(sMyBuildPrize)
												if "table" == type(tMyBuildPrize) then
													tMyBuildPrize["UNIQUETACTICS"] = nil
													sMyBuildPrize = private.Helper_Table2String(tMyBuildPrize)
													private.Data_UpdateMyNcPrize(tCmd.uid_member,sMyBuildPrize)
												end
												local days = private.Data_GetVitalityTime(tCmd.uid_member)
												if "number" == type(days) and 0 == days then
													--会长踢人（24小时内有贡献）
													private.Data_AddVitality(tCmd.ncid,-30)
													local info = string.format("MinusVitalityFire ncid:%d uid:%d",tCmd.ncid,tCmd.uid_member)
													hGlobal.fileWriter:Write(info)
												end
												hGlobal.groupMgr:OnRemoveGroupMember(tCmd.ncid, tCmd.uid, tCmd.uid_member, iLevelOp)
												
												--助理统计今日踢人次数
												if (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --助理
													hGlobal.groupMgr:AddAssistantKickNum(tCmd.ncid, tCmd.uid)
												end
												
												--更新军团今日踢掉活跃玩家的次数
												local newcount = count  + 1
												private.Data_UpdateKickActivePlayerNum(tCmd.ncid, newcount)
											else
												--军团每日只能移除2名活跃玩家
												tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_KICK_ACTIVE_PLAYER_NUM_MAX
											end
										else
											--需要进一步提示操作者
											tRes.noticeActive = 1
										end
										
										----玩家最近24小时内无贡献度才能移除
										--tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_KICK_24HOUR_NODONATE
									end
								--else
								--	--玩家加入军团24小时以上才能移除
								--	tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_KICK_24HOUR
								--end
							else
								--移除军团助理前请先解除其职务
								tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_KICK_ASSISTANT
							end
						else
							--会长不能被移除
							tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_KICK_ADMIN
						end
					else
						--玩家未加入军团
						tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_USER_NOT_JOIN
					end
				else
					--该军团不存在或已解散
					tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISSOLUTION_GROUP
				end
			else
				--军团助理每日只能移除2名玩家
				tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_KICK_ASSISTANT_DAY_MAX
			end
		else
			--您没有权限进行此操作
			tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY
		end
	end
	
	--操作失败通知客户度错误信息
	if (tRes.err > 1) then
		--通知玩家操作结果
		local sCmd = tostring(tRes.err)
		hApi.xlNet_Send(tCmd.uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

--会长任命助理
NoviceCampMgr.AssistantAppoint = function(tCmd)
	--print("NoviceCampMgr.PowerFire")
	local tRes = {err=0}
	local iMasterUid,iDissolution,iMemberCount,iMaxMember = private.Data_GetNcInfo(tCmd.ncid)
	if nil == iMasterUid then
		--参数不合法
		tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
	else
		--print(iMasterUid, tCmd.uid)
		if iMasterUid == tCmd.uid then
			if 0 == iDissolution then
				local iLevel = private.Data_GetMemberLevel(tCmd.uid_member,tCmd.ncid)
				if iLevel and (iLevel > 0) then
					--军团是否已产生助理
					local assisNum = private.Data_GetAssistantMemberNum(tCmd.ncid)
					if (assisNum == 0) then
						--军团上次取消任命助理的时间(秒)
						local assistcounds = hGlobal.groupMgr:GetAssistantCancelTime(tCmd.ncid)
						if (assistcounds > 86400) then --24小时以上
							--标记为助理
							private.Data_SetAssistantMember(tCmd.uid_member, hVar.GROUP_MEMBER_AUTORITY.ASSISTANT)
							
							hGlobal.groupMgr:OnAssistantGroupMember(tCmd.ncid, tCmd.uid, tCmd.uid_member, hVar.GROUP_MEMBER_AUTORITY.ASSISTANT)
						else
							--取消军团助理24小时以上才能再次任命
							tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_ASSISTANT_24HOUR
						end
					else
						--军团助理已被任命
						tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_ASSISTANT_EXIST
					end
				else
					--玩家未加入军团
					tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_USER_NOT_JOIN
				end
			else
				--该军团不存在或已解散
				tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISSOLUTION_GROUP
			end
		else
			--您没有权限进行此操作
			tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY
		end
	end
	
	--操作失败通知客户度错误信息
	if (tRes.err > 1) then
		--通知玩家操作结果
		local sCmd = tostring(tRes.err)
		hApi.xlNet_Send(tCmd.uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

--会长取消任命助理
NoviceCampMgr.AssistantAppointCancel = function(tCmd)
	--print("NoviceCampMgr.PowerFire")
	local tRes = {err=0}
	local iMasterUid,iDissolution,iMemberCount,iMaxMember = private.Data_GetNcInfo(tCmd.ncid)
	if nil == iMasterUid then
		--参数不合法
		tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
	else
		--print(iMasterUid, tCmd.uid)
		if iMasterUid == tCmd.uid then
			if 0 == iDissolution then
				local iLevel = private.Data_GetMemberLevel(tCmd.uid_member,tCmd.ncid)
				if iLevel and (iLevel > 0) then
					--军团是否已产生助理
					if (hVar.GROUP_MEMBER_AUTORITY.ASSISTANT == iLevel) or (hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM == iLevel) then
						--取消标记助理
						private.Data_SetAssistantMember(tCmd.uid_member, hVar.GROUP_MEMBER_AUTORITY.NORMAL)
						
						hGlobal.groupMgr:OnAssistantCancelGroupMember(tCmd.ncid, tCmd.uid, tCmd.uid_member, hVar.GROUP_MEMBER_AUTORITY.NORMAL)
					else
						--玩家不是军团助理
						tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_ASSISTANT_CANCEL_NOVALID
					end
				else
					--玩家未加入军团
					tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_USER_NOT_JOIN
				end
			else
				--该军团不存在或已解散
				tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISSOLUTION_GROUP
			end
		else
			--您没有权限进行此操作
			tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY
		end
	end
	
	--操作失败通知客户度错误信息
	if (tRes.err > 1) then
		--通知玩家操作结果
		local sCmd = tostring(tRes.err)
		hApi.xlNet_Send(tCmd.uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

--玩家退出工会
NoviceCampMgr.PowerQuit = function(tCmd)
	local tRes = {err=0}
	local iMasterUid,iDissolution,iMemberCount,iMaxMember = private.Data_GetNcInfo(tCmd.ncid)
	if nil == iMasterUid then
		--参数不合法
		tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
	else
		if iMasterUid == tCmd.uid then
			--会长不能对自己操作
			tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_OPERATION_SELF_INVALID
		else
			if 0 == iDissolution then
				local iLevel = private.Data_GetMemberLevel(tCmd.uid,tCmd.ncid)
				if iLevel and (iLevel > 0) then
					--玩家加入军团的时间(秒)
					local entersecounds = hGlobal.groupMgr:GetUserEnterTime(tCmd.ncid, tCmd.uid)
					if (entersecounds > 86400) then
						--退出的玩家是军团助理
						if (iLevel == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevel == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then
							--取消标记助理
							--private.Data_SetAssistantMember(tCmd.uid_member, hVar.GROUP_MEMBER_AUTORITY.NORMAL)
							
							--退出军团取消任命军团助理
							hGlobal.groupMgr:OnAssistantLeaveGroupMember(tCmd.ncid, tCmd.uid, hVar.GROUP_MEMBER_AUTORITY.NORMAL)
						end
						
						private.Data_DeleteMember(tCmd.uid)
						private.Data_DecreaseMemberCount(tCmd.ncid)
						local sMyBuildPrize = private.Data_GetMyNcPrize(tCmd.uid)
						local tMyBuildPrize = private.Helper_String2Table(sMyBuildPrize)
						if "table" == type(tMyBuildPrize) then
							tMyBuildPrize["UNIQUETACTICS"] = nil
							sMyBuildPrize = private.Helper_Table2String(tMyBuildPrize)
							private.Data_UpdateMyNcPrize(tCmd.uid,sMyBuildPrize)
						end
						local days = private.Data_GetVitalityTime(tCmd.uid)
						if "number" == type(days) and 0 == days then
							--玩家退出（加入24小时以上）
							private.Data_AddVitality(tCmd.ncid,-30)
							local info = string.format("MinusVitalityQuit ncid:%d uid:%d",tCmd.ncid,tCmd.uid)
							hGlobal.fileWriter:Write(info)
						end
						hGlobal.groupMgr:OnLeaveGroupMember(tCmd.ncid, tCmd.uid)
					else --玩家加入不足24小时
						--玩家在近24小时内的贡献值为0
						local bPlayerRecentNoDonate = true --是否无贡献
						
						--查找玩家的捐献日志
						local nLogNum = 0
						local strCurrentDate = os.date("%Y-%m-%d %H:%M:%S", os.time())
						local n48HourBeforeTime = hApi.GetNewDate(strCurrentDate, "HOUR", -24) --24小时
						local str48HourBeforeTime = os.date("%Y-%m-%d %H:%M:%S", n48HourBeforeTime)
						local sSql = string.format("SELECT count(*) FROM `novicecamp_member_donate_log` WHERE `uid` = %d and `ncid` = %d and `time` >= '%s'", tCmd.uid, tCmd.ncid, str48HourBeforeTime)
						local iErrorCode, count = xlDb_Query(sSql)
						--print(sSql)
						--print(iErrorCode, count)
						if (iErrorCode == 0) then
							nLogNum = count
						end
						if (nLogNum > 0) then
							bPlayerRecentNoDonate = false
						end
						
						--玩家加入不足24小时，24小时内无贡献才能离开
						if bPlayerRecentNoDonate then
							--退出的玩家是军团助理
							if (iLevel == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevel == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then
								--取消标记助理
								--private.Data_SetAssistantMember(tCmd.uid_member, hVar.GROUP_MEMBER_AUTORITY.NORMAL)
								
								--退出军团取消任命军团助理
								hGlobal.groupMgr:OnAssistantLeaveGroupMember(tCmd.ncid, tCmd.uid, hVar.GROUP_MEMBER_AUTORITY.NORMAL)
							end
							
							private.Data_DeleteMember(tCmd.uid)
							private.Data_DecreaseMemberCount(tCmd.ncid)
							local sMyBuildPrize = private.Data_GetMyNcPrize(tCmd.uid)
							local tMyBuildPrize = private.Helper_String2Table(sMyBuildPrize)
							if "table" == type(tMyBuildPrize) then
								tMyBuildPrize["UNIQUETACTICS"] = nil
								sMyBuildPrize = private.Helper_Table2String(tMyBuildPrize)
								private.Data_UpdateMyNcPrize(tCmd.uid,sMyBuildPrize)
							end
							local days = private.Data_GetVitalityTime(tCmd.uid)
							if "number" == type(days) and 0 == days then
								--玩家退出（加入24小时以内）
								private.Data_AddVitality(tCmd.ncid,-30)
								local info = string.format("MinusVitalityQuit ncid:%d uid:%d",tCmd.ncid,tCmd.uid)
								hGlobal.fileWriter:Write(info)
							end
							hGlobal.groupMgr:OnLeaveGroupMember(tCmd.ncid, tCmd.uid)
						else
							--加入军团24小时以上才能退出
							tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_LEAVE_24HOUR
						end
					end
				else
					--玩家未加入军团
					tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_USER_NOT_JOIN
				end
			else
				--该军团不存在或已解散
				tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISSOLUTION_GROUP
			end
		end
	end
	
	--操作失败通知客户度错误信息
	if (tRes.err > 1) then
		--通知玩家操作结果
		local sCmd = tostring(tRes.err)
		hApi.xlNet_Send(tCmd.uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

--修改军团介绍
NoviceCampMgr.UpdateNc = function(tCmd)
	local tRes = {err=0,data={}}
	local iMasterUid,iDissolution = private.Data_GetNcInfo(tCmd.ncid)
	tRes.data.descripe = tCmd.descripe
	tRes.data.ncid = tCmd.ncid
	if nil == iMasterUid then
		--参数不合法
		tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
	else
		--操作者的权限
		local iLevelOp = private.Data_GetMemberLevel(tCmd.uid,tCmd.ncid)
		--会长、助理都可以修改军团介绍
		if (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ADMIN) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then
		--if iMasterUid == tCmd.uid then
			if 0 == iDissolution then
				--检测操作者是否禁言状态
				local forbidden = 0
				local user = hGlobal.uMgr:FindUserByDBID(tCmd.uid)
				if user then
					forbidden = user:GetForbidden()
				end
				if (forbidden == 0) then
					private.Data_SetDescripe(tCmd.ncid,tCmd.descripe)
					hGlobal.groupMgr:OnModifyGroupIntroduce(tCmd.ncid, iMasterUid, iLevelOp, tCmd.descripe)
				else
					--您被禁言无法修改军团公告
					tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_MODIFY_NOTICE_FORBIDDEN
				end
			else
				--该军团不存在或已解散
				tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISSOLUTION_GROUP
			end
		else
			--您没有权限进行此操作
			tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY
		end
	end
	
	--操作失败通知客户度错误信息
	if (tRes.err > 1) then
		--通知玩家操作结果
		local sCmd = tostring(tRes.err)
		hApi.xlNet_Send(tCmd.uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

--修改军团名
NoviceCampMgr.ReNameNc = function(tCmd)
	local tRes = {err=0,data={}}
	local iMasterUid,iDissolution = private.Data_GetNcInfo(tCmd.ncid)
	tRes.data.name = tCmd.name
	tRes.data.ncid = tCmd.ncid
	if nil == iMasterUid then
		--参数不合法
		tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
	else
		if iMasterUid == tCmd.uid then
			if 0 == iDissolution then
				--检测操作者是否禁言状态
				local forbidden = 0
				local user = hGlobal.uMgr:FindUserByDBID(tCmd.uid)
				if user then
					forbidden = user:GetForbidden()
				end
				if (forbidden == 0) then
					local iCoin = private.Data_GetCoin(iMasterUid)
					local iFee = 200
					if "number" == type(iCoin) and iFee <= iCoin then
						local iNcId = private.Data_SetName(tCmd.ncid,tCmd.name)
						if iNcId then
							private.Data_AddCoin(iMasterUid,-iFee)
							local itemId = 102
							private.Data_Order(22,iMasterUid,0,itemId,iFee,hVar.tab_stringI[itemId])
							hGlobal.groupMgr:OnModifyGroupName(tCmd.ncid, iMasterUid, tCmd.name)
						else
							--您输入的军团名已存在
							tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_GROUPNAME_SAME
						end
					else
						--您没有足够的游戏币
						tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_NOT_ENOUGH_GAMECOIN
					end
				else
					--您被禁言无法修改军团名
					tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_MODIFY_NAME_FORBIDDEN
				end
			else
				--该军团不存在或已解散
				tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISSOLUTION_GROUP
			end
		else
			--您没有权限进行此操作
			tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY
		end
	end
	
	--操作失败通知客户度错误信息
	if (tRes.err > 1) then
		--通知玩家操作结果
		local sCmd = tostring(tRes.err)
		hApi.xlNet_Send(tCmd.uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

--升级军团建筑
NoviceCampMgr.BuildUpgrade = function(tCmd)
	local tRes = {err=0,bid=0,blv=0,food=0,wood=0,iron=0}
	
	--00 校验参数
	if "number" == type(tCmd.uid) and "number" == type(tCmd.bid) and 80000 <= tCmd.bid and tCmd.bid <= 80500 and "number" == type(tCmd.ncid) then
		--01 检查工会是否有效
		local iMasterUid,iDissolution,iMemberCount,iMaxMember,iVitality,iGraduate,sTime,iCountry,iIron,iWood,iFood,sBuild = private.Data_GetNcInfo(tCmd.ncid)
		if nil == iDissolution then tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISSOLUTION_GROUP --该军团不存在或已解散
		elseif 1 == iDissolution then tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISSOLUTION_GROUP --该军团不存在或已解散
		elseif nil == hVar.tab_build[tCmd.bid] then tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM --参数不合法
		else
			--elseif tCmd.uid ~= iMasterUid then tRes.err = 103
			--操作者的权限
			local iLevelOp = private.Data_GetMemberLevel(tCmd.uid,tCmd.ncid)
			--会长、助理都可以升级军团建筑
			if (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ADMIN) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then
				--02 是否同一个国家
				local b = hVar.tab_build[tCmd.bid].legioninfo
				if false == private.Data_IsMyCountry(iCountry,b.country) then tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM --参数不合法
				else
					--03 读取自己的建筑数据
					local mybuild = private.Helper_String2Table(sBuild)
					if "table" ~= type(mybuild) then mybuild = private.Data_DefaultBuild(iCountry) end
					local iLevel = private.Data_GetLevel(mybuild,tCmd.bid)
					if b.maxlv <= iLevel or "table" ~= type(b.upgrade[iLevel + 1]) then
						--参数不合法
						tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
					else
						local up = b.upgrade[iLevel + 1]
						up.FOOD = up.FOOD or 0
						up.WOOD = up.WOOD or 0
						up.IRON = up.IRON or 0
						up.LEGIONLV = up.LEGIONLV or 0
						up.TECHNOLOGY = up.TECHNOLOGY or 0
						--print(up.FOOD,up.WOOD,up.IRON,up.LEGIONLV,up.TECHNOLOGY,iIron,iWood,iFood,mybuild.mainlv,mybuild.technologylv)
						if up.FOOD <= iFood and up.WOOD <= iWood and up.IRON <= iIron and up.LEGIONLV <= mybuild.mainlv and up.TECHNOLOGY <= mybuild.technologylv then
							if hVar.LEGION_BUILDIND_TYPE.MAIN == b.build_type then mybuild.mainlv = mybuild.mainlv + 1 end
							if hVar.LEGION_BUILDIND_TYPE.TECHNOLOGY == b.build_type then mybuild.technologylv = mybuild.technologylv + 1 end
							
							if hVar.LEGION_BUILDIND_TYPE.RESIDENCE == b.build_type and "table" == type(b.provide) and "table" == type(b.provide["MEMBERS"]) and "number" == type(b.provide["MEMBERS"][iLevel+1]) then
								local iBuildMaxMember = b.provide["MEMBERS"][iLevel+1]
								if iMaxMember < iBuildMaxMember then iMaxMember = iBuildMaxMember end
							elseif hVar.LEGION_BUILDIND_TYPE.PRODUCE == b.build_type and "table" == type(b.provide) then
								if 2 == b.providemode then
									mybuild.randlv = mybuild.randlv + 1
								else
									local tp = b.provide
									if "table" == type(tp["FOOD"]) and "number" == type(tp["FOOD"][iLevel + 1]) then
										local iBefore = 0
										if "number" == type(tp["FOOD"][iLevel]) then iBefore = tp["FOOD"][iLevel] end
										mybuild.food = mybuild.food + tp["FOOD"][iLevel + 1] - iBefore
									end
									if "table" == type(tp["WOOD"]) and "number" == type(tp["WOOD"][iLevel + 1]) then
										local iBefore = 0
										if "number" == type(tp["WOOD"][iLevel]) then iBefore = tp["WOOD"][iLevel] end
										mybuild.wood = mybuild.wood + tp["WOOD"][iLevel + 1] - iBefore
									end
									if "table" == type(tp["IRON"]) and "number" == type(tp["IRON"][iLevel + 1]) then
										local iBefore = 0
										if "number" == type(tp["IRON"][iLevel]) then iBefore = tp["IRON"][iLevel] end
										mybuild.iron = mybuild.iron + tp["IRON"][iLevel + 1] - iBefore
									end
								end
							end
							private.Data_UpgradeBuild(mybuild,tCmd.bid)
							sBuild = private.Helper_Table2String(mybuild)
							private.Data_UpdateNc(tCmd.ncid,up.FOOD,up.WOOD,up.IRON,sBuild,iMaxMember)
							tRes = {err = 0,bid = tCmd.bid,blv = (iLevel+1),food=(iFood-up.FOOD),wood=(iWood-up.WOOD),iron=(iIron-up.IRON)}
							
							--通知事件
							hGlobal.groupMgr:OnGroupBuildingLevelUp(tCmd.ncid, tCmd.bid, (iLevel + 1))
						else
							--需要的资源不足
							tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_RESOURCE_NOT_ENOUTH
						end
					end
				end
			else
				--您没有权限进行此操作
				tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY
			end
		end
	else
		--参数不合法
		tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
	end
	
	--操作失败通知客户度错误信息
	if (tRes.err > 1) then
		--通知玩家操作结果
		local sCmd = tostring(tRes.err)
		hApi.xlNet_Send(tCmd.uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

--升级军团卡
NoviceCampMgr.CardUpgrade = function(tCmd)
	local tRes = {err=0,bid=tCmd.bid,blv=tCmd.blv,clv=0,food=0,wood=0,iron=0}
	
	--00 校验参数
	if "number" == type(tCmd.uid) and "number" == type(tCmd.bid) and 80000 <= tCmd.bid and tCmd.bid <= 80500 and "number" == type(tCmd.ncid) and "number" == type(tCmd.blv) and 0 < tCmd.blv then
		--01 检查工会是否有效
		local iMasterUid,iDissolution,iMemberCount,iMaxMember,iVitality,iGraduate,sTime,iCountry,iIron,iWood,iFood,sBuild = private.Data_GetNcInfo(tCmd.ncid)
		local b = hVar.tab_build[tCmd.bid].legioninfo
		if nil == iDissolution then tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISSOLUTION_GROUP --该军团不存在或已解散
		elseif 1 == iDissolution then tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISSOLUTION_GROUP --该军团不存在或已解散
		elseif nil == hVar.tab_build[tCmd.bid] then tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM --参数不合法
		elseif "table" ~= type(b) then tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM --参数不合法
		else
			--elseif tCmd.uid ~= iMasterUid then tRes.err = 103
			--操作者的权限
			local iLevelOp = private.Data_GetMemberLevel(tCmd.uid,tCmd.ncid)
			--会长、助理都可以升级军团卡
			if (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ADMIN) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then
				--02 读取自己的建筑数据
				local tMyBuild = private.Helper_String2Table(sBuild)
				if "table" ~= type(tMyBuild) then
					--参数不合法
					tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
				else
					local iLevel = private.Data_GetLevel(tMyBuild,tCmd.bid)
					if iLevel < tCmd.blv then
						--参数不合法
						tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
					else
						local iCardId = 0
						local iCardLv = 0
						local tCard = nil
						if hVar.LEGION_BUILDIND_TYPE.UNIQUETACTICS == b.build_type then
							iCardId = b.provide["UNIQUETACTICS"][tCmd.blv] or 0
							if "table" ~= type(tMyBuild.uniquetactics) then tMyBuild.uniquetactics = {} end
							iCardLv = tMyBuild.uniquetactics[iCardId] or 0
							tCard = tMyBuild.uniquetactics
						elseif hVar.LEGION_BUILDIND_TYPE.TACTICS == b.build_type then
							iCardId = b.provide["TACTICS"][tCmd.blv] or 0
							if "table" ~= type(tMyBuild.tactics) then tMyBuild.tactics = {} end
							iCardLv = tMyBuild.tactics[iCardId] or 0
							tCard = tMyBuild.tactics
						else
							--参数不合法
							tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
						end
						local cul = hVar.LegionTacticsUpgradeList[iCardId]
						if "number" == type(iCardId) and 0 < iCardId and "table" == type(cul) and "table" == type(cul[iCardLv+1]) then
							local up = cul[iCardLv+1]
							local food = up.FOOD or 0
							local wood = up.WOOD or 0
							local iron = up.IRON or 0
							if food <= iFood and wood <= iWood and iron <= iIron then
								tCard[iCardId] = iCardLv+1
								sBuild = private.Helper_Table2String(tMyBuild)
								private.Data_UpdateNc(tCmd.ncid,food,wood,iron,sBuild,iMaxMember)
								tRes.clv = iCardLv+1
								tRes.food = iFood - food
								tRes.wood = iWood - wood
								tRes.iron = iIron - iron
							else
								--需要的资源不足
								tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_RESOURCE_NOT_ENOUTH
							end
						else
							--参数不合法
							tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
						end
					end
				end
			else
				--您没有权限进行此操作
				tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY
			end
		end
	else
		--参数不合法
		tRes.err = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
	end
	
	--操作失败通知客户度错误信息
	if (tRes.err > 1) then
		--通知玩家操作结果
		local sCmd = tostring(tRes.err)
		hApi.xlNet_Send(tCmd.uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

--[[
NoviceCampMgr.BuildPrize = function(tCmd)
	local tRes = {err=0,bid=tCmd.bid,blv=tCmd.blv}

	--00 校验参数
	if "number" == type(tCmd.uid) and "number" == type(tCmd.bid) and 80000 <= tCmd.bid and tCmd.bid <= 80500 and "number" == type(tCmd.ncid) and "number" == type(tCmd.blv) then
		--01 检查工会是否有效
		local iMasterUid,iDissolution,iMemberCount,iMaxMember,iVitality,iGraduate,sTime,iCountry,iIron,iWood,iFood,sBuild = private.Data_GetNcInfo(tCmd.ncid)
		local iNcId = private.Data_GetMemberInfo(tCmd.uid)
		local sMyBuildPrize = private.Data_GetMyNcPrize(tCmd.uid)
		if nil == iDissolution then tRes.err = 101
		elseif 1 == iDissolution then tRes.err = 102
		elseif tCmd.ncid ~= iNcId then tRes.err = 103
		elseif nil == hVar.tab_build[tCmd.bid] then tRes.err = 100
		else
			--02 读取工会的建筑数据
			local b = hVar.tab_build[tCmd.bid].legioninfo
			local mybuild = private.Helper_String2Table(sBuild)
			if "table" ~= type(mybuild) then mybuild = private.Data_DefaultBuild(iCountry) end
			local tMyBuildPrize = private.Helper_String2Table(sMyBuildPrize)
			if "table" ~= type(tMyBuildPrize) then tMyBuildPrize = {} end
			local iLevel = private.Data_GetLevel(mybuild,tCmd.bid)
			if iLevel < tCmd.blv or "table" ~= type(b.provide) then tRes.err = 104
			else
				if hVar.LEGION_BUILDIND_TYPE.TACTICS == b.build_type then
					if "table" == type(b.provide["TACTICS"]) and "number" == type(b.provide["TACTICS"][tCmd.blv]) then
						local iPrizeId = b.provide["TACTICS"][tCmd.blv]
						local isPrizeOver = private.Data_IsPrizeOver(tMyBuildPrize,"TACTICS",iPrizeId)
						if false == isPrizeOver then
							local tPrize = tMyBuildPrize["TACTICS"]
							tPrize[#tPrize + 1] = iPrizeId
							sMyBuildPrize = private.Helper_Table2String(tMyBuildPrize)
							private.Data_UpdateMyNcPrize(tCmd.uid,sMyBuildPrize)
							---todo insert prize
							--private.Data_InsertMyNcPrize(tCmd.uid,10000,'c:100;',iPrizeId)
						else
							tRes.err = 110	
						end
					else
						tRes.err = 105
					end
				elseif hVar.LEGION_BUILDIND_TYPE.UNIQUETACTICS == b.build_type then
					if "table" == type(b.provide["UNIQUETACTICS"]) and "number" == type(b.provide["UNIQUETACTICS"][tCmd.blv]) then
						local iPrizeId = b.provide["UNIQUETACTICS"][tCmd.blv]
						local isPrizeOver = private.Data_IsPrizeOver(tMyBuildPrize,"UNIQUETACTICS",iPrizeId)
						if false == isPrizeOver then
							local tPrize = tMyBuildPrize["UNIQUETACTICS"]
							tPrize[#tPrize + 1] = iPrizeId
							sMyBuildPrize = private.Helper_Table2String(tMyBuildPrize)
							private.Data_UpdateMyNcPrize(tCmd.uid,sMyBuildPrize)
							---todo insert prize
							--private.Data_InsertMyNcPrize(tCmd.uid,10000,'c:100;',iPrizeId)
						else
							tRes.err = 110		
						end
					else
						tRes.err = 105
					end
				else
					tRes.err = 106
				end
			end
		end
	else
		tRes.err = 100
	end
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end
--]]

NoviceCampMgr.PrizeInfo = function(tCmd)
	local tRes = {err=0,data={}}
	tRes.data.prize_graduate = private.Config_PrizeGraduate
	tRes.data.prize_vitality = private.Config_PrizeVitality
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

function helper_prize_prize2mailstring(prizetype,uid,createid,prize)
	--print(string.format("prize.type:%s\n",prize.type))
	local sMailString = nil
	if "cn" == prize.type then
		sMailString = string.format("(%d,%d,\'c:%d;\',%d)",uid,prizetype,prize.num,createid)
	elseif "sc" == prize.type then
		sMailString = string.format("(%d,%d,\'s:%d;\',%d)",uid,prizetype,prize.num,createid)
	elseif "ix" == prize.type then
		if 9108 == prize.id then
			--sMailString = string.format("(%d,%d,\'%s\',%d)",uid,7000,prize.detail,aid)
		else
			sMailString = string.format("(%d,%d,\'i:%dn:%d;\',%d)",uid,prizetype,prize.id,prize.num,createid)
		end
	elseif "tc" == prize.type then
	--[[
		local sMyKey = string.format("bfs:%dlv:%dn:%d",prize.id,prize.level,prize.num)
		sMailString = string.format("(%d,%d,\'%s\',%d)",uid,7,sMyKey,aid)
	--]]
	elseif "it" == prize.type then
	--[[
		if 29 == prize.id or 30 == prize.id or 31 == prize.id then
			local sMyKey = string.format("i:%dn:%d",prize.id,prize.num)
			sMailString = string.format("(%d,%d,\'%s\',%d)",uid,6,sMyKey,aid)
		elseif 9004 == prize.id or 9005 == prize.id or 9006 == prize.id then
			sMailString = string.format("(%d,%d,\'%d\',%d)",uid,prize.id,prize.num,aid)
		else
			local hole = prize.hole or 1
			local sMyKey = string.format("i:%dn:%dh:%d",prize.id,prize.num,hole)
			sMailString = string.format("(%d,%d,\'%s\',%d)",uid,4,sMyKey,aid)
		end
	--]]
	end
	return sMailString
end
NoviceCampMgr.DispatchPrize = function(iType,tPrize,iUid,iCreateId)
	if 0 < #tPrize then
		local bFirst = true
		local sql = "insert into prize (uid,type,mykey,create_id) values "
		for i=1,#tPrize do
			local tmp = helper_prize_prize2mailstring(iType,iUid,iCreateId,tPrize[i])
			if tmp then
				if true == bFirst then
					bFirst = false
					sql = sql .. tmp
				else
					sql = sql .. "," .. tmp
				end
			end
		end
		--print(string.format("sql_prize:%s\n",sql))
		xlDb_Execute(sql)
	end
end

--[[
NoviceCampMgr.OnTaskFinish = function(iUid,iRid,iTaskId)
	--01自己是否已经有所属了
	local iNcId,iLevel,iTaskCount,iTaskMax = private.Data_GetMemberInfo(iUid)
	if "number" == type(iNcId) and (1 == iLevel or hVar.GROUP_MEMBER_AUTORITY.ADMIN == iLevel) and iTaskCount < iTaskMax then
		--02获取公会信息
		local iMasterUid,iDissolution,iMemberCount,iMaxMember,iVitality,iGraduate = private.Data_GetNcInfo(iNcId)
		if "number" == type(iDissolution) and 0 == iDissolution then
			local iAddVitality = private.Config_GetVitality()
			--05 判断是否毕业 只有成员
			if iMasterUid ~= iUid then
				if iTaskCount + 1 == iTaskMax then
					--03 插入活力日志表
					private.Data_InsertVitality(iNcId,iUid,iTaskId,iAddVitality)
					private.Data_UpdateVitalityStatistics(iNcId,iAddVitality)
					--04 更新公会最新活力
					private.Data_AddVitality(iNcId,iAddVitality)
					NoviceCampMgr.OnGraduate(iUid,iNcId,iGraduate,iMasterUid)
				end
			end
			--06 更新任务计数
			private.Data_IncreaseMemberTask(iUid)
		end
	end
end
--]]
NoviceCampMgr.OnGraduate = function(iUid,iNcId,iGraduate,iMasterUid)
	--01 检测奖励
	local iCount = iGraduate + 1
	local tPrize = private.Config_PrizeGraduate
	local ix = {}
	
	for i=1,#tPrize do
		if tPrize[i].rate == iCount then
			ix = tPrize[i].prize
		end
	end
	--02 派送奖励 会长
	local iMasterUid = private.Data_GetNcInfo(iNcId)
	NoviceCampMgr.DispatchPrize(10005,ix,iMasterUid,iCount)
	NoviceCampMgr.OnPrizeGraduate(iMasterUid,iUid)
	-- 毕业成员奖励
	if "table" == type(private.Config_PrizeGraduate.prize_member) then
		NoviceCampMgr.DispatchPrize(10007,private.Config_PrizeGraduate.prize_member,iUid,iNcId)
	end

	--03 更新成员状态
	private.Data_InsertGraduate(iNcId,iUid)
	if iMasterUid ~= iUid then private.Data_DeleteMember(iUid) end
	
	--04 更新毕业人数
	local iMaxMemberNew = private.Config_GetMaxMember(iGraduate + 1)
	private.Data_IncreaseGraduate(iNcId,iMaxMemberNew)
end

NoviceCampMgr.OnPrizeGraduate = function(iMasterUid,iCreateId)
	--local iActId = private.Data_IsActiviting()
	--if "number" == type(iActId) then
		local ix = {{type="ix",num=10,id=9006},}
		NoviceCampMgr.DispatchPrize(10006,ix,iMasterUid,iCreateId)
	--end
end

--更新(1秒)
NoviceCampMgr.Update = function(self)
	local self = NoviceCampMgr --self
	
	local timeNow = hApi.GetClock()
	if (self._statisticsTime > -1) and (timeNow - self._statisticsTime > 1000) then
		local lasttimestamp = self._statisticsTimestamp
		local currenttimestamp = os.time()
		
		self._statisticsTime = timeNow
		self._statisticsTimestamp = currenttimestamp
		
		--检测更新
		--print("Update")
		local sDate = os.date("%Y-%m-%d", currenttimestamp)
		local sRefreshTime = NoviceCampMgr.SYSTEM_CHECK_TIME.time
		local refresh_time = sDate .. " " .. sRefreshTime
		local nRefreshTime = hApi.GetNewDate(refresh_time)
		--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
		--print(nRefreshTime)
		if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
			--print("ok")
			NoviceCampMgr.OnLoop()
		end
	end
end

NoviceCampMgr.OnLoop = function()
	--print(OnLoop)
	local iDays,iMonth = private.Data_GetDailyVitalityTime()
	--包含两个功能 每日统计表插入新记录及周一清算派奖
	local iDispatchPrize,iDailyCheck = 0,0
	if "number" == type(iDays) then
		if 0 < iDays then
			iDailyCheck = 1
			if 1 == iMonth then
				iDispatchPrize = 1
			end
		end
	else
		iDailyCheck = 1
	end
	
	if 1 == iDailyCheck then
		--01 插入每日统计记录
		--private.Data_InitVitalityStatistics()
		private.Data_DailyProvide()
		--02 更新检测时间
		private.Data_SetDailyVitalityTime()
	end

	if 1 == iDispatchPrize then
		--01 派发奖励
		--NoviceCampMgr.OnPrizeVitality(50)
		--02 初始化临时活跃度
		--private.Data_InitVitality()
	end
end

NoviceCampMgr.OnPrizeVitality = function(iCount)
	local tList = private.Data_VitalityTopList(iCount)
	local iLastRank = private.Config_GetLastRank()
	local iLastVitality = 0
	--print(string.format("OnPrizeVitality lastrank:%d",iLastRank))
	if "table" == type(tList) then
		for i=1,#tList do
			--print(string.format("OnPrizeVitality i:%d uid:%d v:%d iLastVitality:%d",i,tList[i][1],tList[i][2],iLastVitality))
			if iLastRank < i and tList[i][2] < iLastVitality then return end
			local iLevel = i
			if iLastRank < i then iLevel = iLastRank end
			local ix = private.Config_GetPrizeVitality(iLevel)
			if "table" == type(ix) then
				NoviceCampMgr.DispatchPrize(10004,ix,tList[i][1],i)
				iLastVitality = tList[i][2]
				if 1<= i and i<=3 and "table" == type(private.Config_PrizeVitality[i]) and 200 <= iLastVitality then
					local sInfo = private.Config_PrizeVitality[i].describe_cn
					local sExt = private.Config_PrizeVitality[i].ext
					if sExt and sInfo then
						private.Data_InsertPrivateMail(tList[i][1],sInfo,sExt)
					end
				end
			end
		end
	end
end

--请求兑换战术卡碎片
NoviceCampMgr.ExchangeTacticDebris = function(uid, rid, tCardList)
	local ret = 0
	local strSelectCardInfo = "" --字符串描述卡牌信息
	local strRewardInfo = "" --字符串描述奖励信息
	
	--玩家所在的工会id
	local groupId = private.Data_GetNcId(uid)
	if (groupId > 0) then
		--今日已兑换次数
		local count = private.Data_GetExchangeTacticDebirsNum(uid)
		local vipLv = hGlobal.vipMgr:DBGetUserVip(uid) --玩家vip等级
		local maxcount = hVar.Vip_Conifg.groupExchageDebrisCount[vipLv] or 1 --最大次数
		if (count < maxcount) then --今日兑换次数未满
			--依次检测战术卡的有效性
			local bCheckValid = true
			local select_debris_num = 0 --已选择的战术卡碎片总数量
			
			for t = 1, #tCardList, 1 do
				local tacticId = tCardList[t].id
				local tacticNum = tCardList[t].num
				if (tacticNum > 0) then
					if (tacticId > 0) then
						local tabT = hVar.tab_tactics[tacticId]
						if tabT then
							--统计碎片数量
							select_debris_num = select_debris_num + tacticNum
						else
							--无效
							bCheckValid = false
							break
						end
					else
						--无效
						bCheckValid = false
						break
					end
				else
					--无效
					bCheckValid = false
					break
				end
			end
			
			if bCheckValid then --有效
				--数量是否至少能兑换一次
				if (select_debris_num >= hVar.GROUP_ECHANGE_TACTICCARD_NUM) then
					--数量是否为兑换的整数倍
					if (select_debris_num % hVar.GROUP_ECHANGE_TACTICCARD_NUM == 0) then
						--计算本次兑换的倍数
						local exchangeCount = select_debris_num / hVar.GROUP_ECHANGE_TACTICCARD_NUM
						if (exchangeCount <= (maxcount - count)) then
							--检测游戏币是否足够
							local iCoin = private.Data_GetCoin(uid)
							local requireCoin = hVar.GROUP_ECHANGE_TACTICCARD_COST_GAMECOIN * exchangeCount
							if (iCoin >= requireCoin) then
								--扣除游戏币
								private.Data_AddCoin(uid, -requireCoin)
								
								--扣除战术卡碎片数量
								hGlobal.tacticDebrisMgr:DBDecreaseUserTacticDebris(uid, rid, tCardList)
								
								--更新今日兑换战术卡碎片次数
								local newcount = count + 1 * exchangeCount
								private.Data_UpdateExchangeTacticDebirsNum(uid, newcount)
								
								--拼接字符串
								for t = 1, #tCardList, 1 do
									local tacticId = tCardList[t].id
									local tacticNum = tCardList[t].num
									strSelectCardInfo = strSelectCardInfo .. tostring(tacticId) .. ":" .. tostring(tacticNum) .. ";"
								end
								strSelectCardInfo = tostring(#tCardList) .. ";" .. strSelectCardInfo
								
								--获得军团币
								private.Data_IncreaseGroupCoin(uid, hVar.GROUP_ECHANGE_TACTICCARD_COIN * exchangeCount)
								
								--获得随机的军团资源
								local rand = math.random(1, #hVar.GROUP_ECHANGE_REWARD)
								local addResType = hVar.GROUP_ECHANGE_REWARD[rand][1]
								local addResValue = hVar.GROUP_ECHANGE_REWARD[rand][2]
								local iron = 0
								local wood = 0
								local food = 0
								local strMemberDotateRes = nil
								local strGroupDotateRes = nil
								if (addResType == 16) then --16:铁
									iron = iron + addResValue * exchangeCount
									strMemberDotateRes = "mat_iron_donate_sum"
									strGroupDotateRes = "mat_iron"
								elseif (addResType == 17) then --17:木材
									wood = wood + addResValue * exchangeCount
									strMemberDotateRes = "mat_wood_donate_sum"
									strGroupDotateRes = "mat_wood"
								elseif (addResType == 18) then --18:粮食
									food = food + addResValue * exchangeCount
									strMemberDotateRes = "mat_food_donate_sum"
									strGroupDotateRes = "mat_food"
								end
								
								--查询玩家的渠道号
								local channelId = 0
								local sQuery = string.format("SELECT `channel_id` FROM `t_user` WHERE `uid`= %d", uid)
								local err, channel_id = xlDb_Query(sQuery)
								--print("sQuery:",sQuery,err)
								if (err == 0) then
									channelId = channel_id
								end
								
								--插入订单
								local itemId = 9928
								private.Data_Order(22, uid, rid, itemId, requireCoin, hVar.tab_stringI[itemId], strSelectCardInfo)
								
								--插入日志
								private.Data_Donate(uid, groupId, hVar.tab_stringI[itemId], channelId, 0, 0, 0, iron, wood, food, strSelectCardInfo, "", hVar.GROUP_ECHANGE_TACTICCARD_COIN * exchangeCount)
								
								--更新军团个人表
								local sSql = string.format("UPDATE `novicecamp_member` SET `%s` = `%s` + %d WHERE `uid`= %d", strMemberDotateRes, strMemberDotateRes, addResValue * exchangeCount, uid)
								xlDb_Execute(sSql)
								
								--更新军团表
								local sSql = string.format("UPDATE `novicecamp_list` SET `%s` = `%s` + %d WHERE `id`= %d", strGroupDotateRes, strGroupDotateRes, addResValue * exchangeCount, groupId)
								--print(sSql)
								xlDb_Execute(sSql)
								
								--通知本工会全体玩家，资源变化
								local iMasterUid,iDissolution,iMemberCount,iMaxMember,iVitality,iGraduate,sTime,iCountry,iIron,iWood,iFood,sBuild = private.Data_GetNcInfo(groupId)
								--军团通知消息: 资源变化
								local tUserTable = hGlobal.groupMgr:GetGroupAllUser(groupId)
								local sCmd = tostring(groupId) .. ";" .. tostring(iIron) .. ";" .. tostring(iWood) .. ";" .. tostring(iFood) .. ";"
								if tUserTable then
									for uid, level in pairs(tUserTable) do
										hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_RESOURCE_INFO, sCmd)
									end
								end
								
								--奖励信息
								local rewardNum = 2
								strRewardInfo = tostring(rewardNum) .. ";" .. tostring(addResType) .. ":" .. tostring(addResValue * exchangeCount) .. ":0:0;20:" .. tostring(hVar.GROUP_ECHANGE_TACTICCARD_COIN * exchangeCount) .. ":0:0;"
								
								--操作成功
								ret = 1
							else
								--"您没有足够的游戏币"
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_NOT_ENOUGH_GAMECOIN
							end
						else
							--"今日可捐献次数已用完"
							ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_EXCHANGE_TACTIC_DEBIRS_MAXCOUNT
						end
					else
						--"选择的碎片数量需为N的整数倍"
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_TACTICCARD_INTEGER
					end
				else
					--"战术卡碎片不足"
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_EXCHANGE_TACTIC_DEBIRS_NUMERROR
				end
			else
				--"无效的战术卡碎片"
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_EXCHANGE_TACTIC_DEBIRS_INVALID
			end
		else
			--"今日可捐献次数已用完"
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_EXCHANGE_TACTIC_DEBIRS_MAXCOUNT
		end
	else
		--"您还未加入军团"
		ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_NOT_IN_GROUP
	end
	
	--操作失败通知客户度错误信息
	if (ret > 1) then
		--通知玩家操作结果
		local sCmd = tostring(ret)
		hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	--返回值
	local sCmd = tostring(ret) .. ";" .. strSelectCardInfo .. strRewardInfo
	return sCmd
end

--请求兑换英雄将魂
NoviceCampMgr.ExchangeHeroDebris = function(uid, rid, tCardList)
	local ret = 0
	local strSelectCardInfo = "" --字符串描述卡牌信息
	local strRewardInfo = "" --字符串描述奖励信息
	
	--玩家所在的工会id
	local groupId = private.Data_GetNcId(uid)
	if (groupId > 0) then
		--今日已兑换次数
		local count = private.Data_GetExchangeHeroDebirsNum(uid)
		local vipLv = hGlobal.vipMgr:DBGetUserVip(uid) --玩家vip等级
		local maxcount = hVar.Vip_Conifg.groupExchageDebrisCount[vipLv] or 1 --最大次数
		if (count < maxcount) then --今日兑换次数未满
			--依次检测战术卡的有效性
			local bCheckValid = true
			local select_debris_num = 0 --已选择的英雄将魂总数量
			
			--玩家存档里的英雄将魂信息
			local tHeroInfo, sCmd = hGlobal.heroDebrisMgr:DBGetUserHeroDebris(uid, rid)
			--tHeroInfo[#tHeroInfo+1] = {heroId = heroId, star = star, debrisNum = debrisNum, debrisTotalNum = debrisTotalNum,}
			
			for t = 1, #tCardList, 1 do
				local heroId = tCardList[t].id
				local heroNum = tCardList[t].num
				if (heroNum > 0) then
					if (heroId > 0) then
						--检测玩家存档是否有足够的英雄碎片数量
						local bFindDebrisNumValid = false
						for h = 1, #tHeroInfo, 1 do
							local tHero = tHeroInfo[h]
							local id = tHero.heroId
							local star = tHero.star
							local debrisNum = tHero.debrisNum
							local debrisTotalNum = tHero.debrisTotalNum
							
							if (id == heroId) then --找到了
								if (heroNum <= debrisNum) then --选择的英雄碎片小于存档里的总碎片数量
									bFindDebrisNumValid = true
								end
								
								break
							end
						end
						
						if bFindDebrisNumValid then
							--统计碎片数量
							select_debris_num = select_debris_num + heroNum
						else
							--无效
							bCheckValid = false
							break
						end
					else
						--无效
						bCheckValid = false
						break
					end
				else
					--无效
					bCheckValid = false
					break
				end
			end
			
			if bCheckValid then --有效
				--数量是否至少能兑换一次
				if (select_debris_num >= hVar.GROUP_ECHANGE_HERODEBRIS_NUM) then
					--数量是否为兑换的整数倍
					if (select_debris_num % hVar.GROUP_ECHANGE_HERODEBRIS_NUM == 0) then
						--计算本次兑换的倍数
						local exchangeCount = select_debris_num / hVar.GROUP_ECHANGE_HERODEBRIS_NUM
						if (exchangeCount <= (maxcount - count)) then
							--检测游戏币是否足够
							local iCoin = private.Data_GetCoin(uid)
							local requireCoin = hVar.GROUP_ECHANGE_HERODEBRIS_COST_GAMECOIN * exchangeCount
							if (iCoin >= requireCoin) then
								--扣除游戏币
								private.Data_AddCoin(uid, -requireCoin)
								
								--扣除英雄将魂数量
								hGlobal.heroDebrisMgr:DBDecreaseUserHeroDebris(uid, rid, tCardList)
								
								--更新今日兑换英雄将魂次数
								local newcount = count + 1 * exchangeCount
								private.Data_UpdateExchangeHeroDebirsNum(uid, newcount)
								
								--拼接字符串
								for t = 1, #tCardList, 1 do
									local heroId = tCardList[t].id
									local heroNum = tCardList[t].num
									strSelectCardInfo = strSelectCardInfo .. tostring(heroId) .. ":" .. tostring(heroNum) .. ";"
								end
								strSelectCardInfo = tostring(#tCardList) .. ";" .. strSelectCardInfo
								
								--获得军团币
								private.Data_IncreaseGroupCoin(uid, hVar.GROUP_ECHANGE_HERODEBRIS_COIN * exchangeCount)
								
								--获得随机的军团资源
								local rand = math.random(1, #hVar.GROUP_ECHANGE_REWARD)
								local addResType = hVar.GROUP_ECHANGE_REWARD[rand][1]
								local addResValue = hVar.GROUP_ECHANGE_REWARD[rand][2]
								local iron = 0
								local wood = 0
								local food = 0
								local strMemberDotateRes = nil
								local strGroupDotateRes = nil
								if (addResType == 16) then --16:铁
									iron = iron + addResValue * exchangeCount
									strMemberDotateRes = "mat_iron_donate_sum"
									strGroupDotateRes = "mat_iron"
								elseif (addResType == 17) then --17:木材
									wood = wood + addResValue * exchangeCount
									strMemberDotateRes = "mat_wood_donate_sum"
									strGroupDotateRes = "mat_wood"
								elseif (addResType == 18) then --18:粮食
									food = food + addResValue * exchangeCount
									strMemberDotateRes = "mat_food_donate_sum"
									strGroupDotateRes = "mat_food"
								end
								
								--查询玩家的渠道号
								local channelId = 0
								local sQuery = string.format("SELECT `channel_id` FROM `t_user` WHERE `uid`= %d", uid)
								local err, channel_id = xlDb_Query(sQuery)
								--print("sQuery:",sQuery,err)
								if (err == 0) then
									channelId = channel_id
								end
								
								--插入订单
								local itemId = 9929
								private.Data_Order(22, uid, rid, itemId, requireCoin, hVar.tab_stringI[itemId], strSelectCardInfo)
								
								--插入日志
								private.Data_Donate(uid, groupId, hVar.tab_stringI[itemId], channelId, 0, 0, 0, iron, wood, food, "", strSelectCardInfo, hVar.GROUP_ECHANGE_HERODEBRIS_COIN * exchangeCount)
								
								--更新军团个人表
								local sSql = string.format("UPDATE `novicecamp_member` SET `%s` = `%s` + %d WHERE `uid`= %d", strMemberDotateRes, strMemberDotateRes, addResValue * exchangeCount, uid)
								xlDb_Execute(sSql)
								
								--更新军团表
								local sSql = string.format("UPDATE `novicecamp_list` SET `%s` = `%s` + %d WHERE `id`= %d", strGroupDotateRes, strGroupDotateRes, addResValue * exchangeCount, groupId)
								xlDb_Execute(sSql)
								
								--通知本工会全体玩家，资源变化
								local iMasterUid,iDissolution,iMemberCount,iMaxMember,iVitality,iGraduate,sTime,iCountry,iIron,iWood,iFood,sBuild = private.Data_GetNcInfo(groupId)
								--军团通知消息: 资源变化
								local tUserTable = hGlobal.groupMgr:GetGroupAllUser(groupId)
								local sCmd = tostring(groupId) .. ";" .. tostring(iIron) .. ";" .. tostring(iWood) .. ";" .. tostring(iFood) .. ";"
								if tUserTable then
									for uid, level in pairs(tUserTable) do
										hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_RESOURCE_INFO, sCmd)
									end
								end
								
								--奖励信息
								local rewardNum = 2
								strRewardInfo = tostring(rewardNum) .. ";" .. tostring(addResType) .. ":" .. tostring(addResValue * exchangeCount) .. ":0:0;20:" .. tostring(hVar.GROUP_ECHANGE_HERODEBRIS_COIN * exchangeCount) .. ":0:0;"
								
								--操作成功
								ret = 1
							else
								--"您没有足够的游戏币"
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_NOT_ENOUGH_GAMECOIN
							end
						else
							--"今日可捐献次数已用完"
							ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_EXCHANGE_TACTIC_DEBIRS_MAXCOUNT
						end
					else
						--"选择的英雄将魂数量需为N的整数倍"
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_HEROCARD_INTEGER
					end
				else
					--"英雄将魂不足"
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_EXCHANGE_HERO_DEBIRS_NUMERROR
				end
			else
				--"无效的英雄将魂"
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_EXCHANGE_HERO_DEBIRS_INVALID
			end
		else
			--"今日可捐献次数已用完"
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_EXCHANGE_TACTIC_DEBIRS_MAXCOUNT
		end
	else
		--"您还未加入军团"
		ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_NOT_IN_GROUP
	end
	
	--操作失败通知客户度错误信息
	if (ret > 1) then
		--通知玩家操作结果
		local sCmd = tostring(ret)
		hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	--返回值
	local sCmd = tostring(ret) .. ";" .. strSelectCardInfo .. strRewardInfo
	return sCmd
end

--请求购买军团副本次数
--士气提升
NoviceCampMgr.BuyGroupBattleCount = function(uid, rid)
	local ret = 0
	local strSelectCardInfo = "" --字符串描述卡牌信息
	local strRewardInfo = "" --字符串描述奖励信息
	
	--玩家所在的工会id
	local groupId = private.Data_GetNcId(uid)
	if (groupId > 0) then
		--操作者的权限
		local iLevelOp = private.Data_GetMemberLevel(uid)
		--会长、助理都可以操作
		if (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ADMIN) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevelOp == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then
			local iMasterUid,iDissolution,iMemberCount,iMaxMember,iVitality,iGraduate,sTime,iCountry,iIron,iWood,iFood,sBuild,iBuyBattleCount,sLastBuyBattleCountTime = private.Data_GetNcInfo(groupId)
			
			--今日已购买副本次数
			local count = iBuyBattleCount
			--检测是否到第二天，重置购买副本次数
			local tab1 = os.date("*t", hApi.GetNewDate(sLastBuyBattleCountTime))
			local tab2 = os.date("*t", os.time())
			if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
				count = 0
			end
			local maxcount = hVar.GROUP_BUY_BATTLE_MAXCOUNT --最大次数
			if (count < maxcount) then --今日兑换次数未满
				--检测军团资源是否足够
				local requireIron = iMaxMember * hVar.GROUP_BUY_BATTLE_MULTYPLICATE_IRON --需要的铁
				local requireWood = iMaxMember * hVar.GROUP_BUY_BATTLE_MULTYPLICATE_WOOD --需要的木材
				local requireFood = iMaxMember * hVar.GROUP_BUY_BATTLE_MULTYPLICATE_FOOD --需要的粮食
				
				if (iIron < requireIron) then
					--"军团铁资源不足"
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_RESOURCE_ENOUGH_IRON
				elseif (iWood < requireWood) then
					--"军团木材资源不足"
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_RESOURCE_ENOUGH_WOOD
				elseif (iFood < requireFood) then
					--"军团粮食资源不足"
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_RESOURCE_ENOUGH_FOOD
				else
					--[[
					--统计总人数
					local tUserTable = hGlobal.groupMgr:GetGroupAllUser(groupId)
					local totalUserNum = 0
					for uid_group, level in pairs(tUserTable) do
						totalUserNum = totalUserNum + 1
					end
					]]
					
					--扣除军团资源
					private.Data_UpdateNcRes(groupId, requireFood, requireWood, requireIron)
					
					--更新工会信息
					local sqlUpdate = string.format("UPDATE `novicecamp_list` SET `buy_battle_count` = %d, `last_buy_battle_count_time` = NOW() where `id` = %d", count + 1, groupId)
					xlDb_Execute(sqlUpdate)
					
					--插入订单
					local itemId = 9930
					strSelectCardInfo = "groupId:" .. groupId .. ",iMaxMember=" .. iMaxMember .. ",Iron:" .. requireIron .. ",Wood=" .. requireWood .. ",Food=" .. requireFood
					private.Data_Order(22, uid, rid, itemId, 0, hVar.tab_stringI[itemId], strSelectCardInfo)
					
					--军团通知消息: 资源变化
					local tUserTable = hGlobal.groupMgr:GetGroupAllUser(groupId)
					local sCmd = tostring(groupId) .. ";" .. tostring(iIron-requireIron) .. ";" .. tostring(iWood-requireWood) .. ";" .. tostring(iFood-requireFood) .. ";"
					if tUserTable then
						for uid, level in pairs(tUserTable) do
							hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_GROUP_RESOURCE_INFO, sCmd)
						end
					end
					
					--触发事件，士气提升
					hGlobal.groupMgr:OnGroupBuyBattleCount(groupId, uid, iLevelOp, 1)
					
					--依次检测本军团的全体成员，如果今日已挑战过军团副本，补发邮件奖励
					--今日的0点
					local nTimestampNow = os.time()
					local strDatestampYMD = hApi.Timestamp2Date(nTimestampNow) --转字符串(年月日)
					local strNewdate = strDatestampYMD .. " 00:00:00"
					--军团全部成员
					local tUserTable = hGlobal.groupMgr:GetGroupAllUser(groupId)
					if tUserTable then
						for uid, level in pairs(tUserTable) do
							if (level > 0) then
								--print("玩家", uid)
								--此副本今日可挑战的最大次数
								local challengeCountTotal = 0
								local cMaxCount = (hVar.tab_roomcfg[2].challengeMaxCount or 2)
								local cMaxCount1 = (hVar.tab_roomcfg[3].challengeMaxCount or 2)
								local cMaxCount5 = (hVar.tab_roomcfg[5].challengeMaxCount or 2) --铁 --geyachao: 新加房间的配置项 军团
								local cMaxCount6 = (hVar.tab_roomcfg[6].challengeMaxCount or 2) --木材 --geyachao: 新加房间的配置项 军团
								local cMaxCount7 = (hVar.tab_roomcfg[7].challengeMaxCount or 2) --粮食 --geyachao: 新加房间的配置项 军团
								local cMaxCount8 = (hVar.tab_roomcfg[8].challengeMaxCount or 2) --军团组队 --geyachao: 新加房间的配置项 军团
								local cMaxCount9 = (hVar.tab_roomcfg[9].challengeMaxCount or 2) --军团组队驻守模式 --geyachao: 新加房间的配置项 军团
								local cMaxCount10 = (hVar.tab_roomcfg[10].challengeMaxCount or 2) --人族无敌
								local cMaxCount11 = (hVar.tab_roomcfg[11].challengeMaxCount or 2) --魔塔杀阵
								local cMaxCount12 = (hVar.tab_roomcfg[12].challengeMaxCount or 2) --守卫剑阁
								local cMaxCount13 = (hVar.tab_roomcfg[13].challengeMaxCount or 2) --双人守卫剑阁
								local cMaxCount14 = (hVar.tab_roomcfg[14].challengeMaxCount or 2) --仙之侠道
								local cMaxCount15 = (hVar.tab_roomcfg[15].challengeMaxCount or 2) --霸王大陆
								
								--副本今日已挑战次数
								local sql= string.format("SELECT `customS1`, `challengeMaxCount`, `challengeMaxCount1`, `challengeMaxCount5`, `challengeMaxCount6`, `challengeMaxCount7`, `challengeMaxCount8`, `challengeMaxCount9`, `challengeMaxCount10`, `challengeMaxCount11`, `challengeMaxCount12`, `challengeMaxCount13`, `challengeMaxCount14`, `challengeMaxCount15`, DATE(`challengeRefreshTime`), `challenge_buy_count`, `last_challenge_buy_count_time` FROM t_user WHERE  `uid` = %d", uid) --geyachao: 新加房间的配置项 军团
								local err, customS1, challengeMaxCount, challengeMaxCount1, challengeMaxCount5, challengeMaxCount6, challengeMaxCount7, challengeMaxCount8, challengeMaxCount9, challengeMaxCount10, challengeMaxCount11, challengeMaxCount12, challengeMaxCount13, challengeMaxCount14, challengeMaxCount15, challengeRefreshTime, buy_count, last_challenge_buy_count_time = xlDb_Query(sql) --geyachao: 新加房间的配置项 军团
								--print(err, customS1, challengeMaxCount, challengeMaxCount1, challengeMaxCount5, challengeMaxCount6, challengeMaxCount7, challengeMaxCount8, challengeMaxCount9, challengeMaxCount10, challengeMaxCount11, challengeMaxCount12, challengeMaxCount13, challengeMaxCount14, challengeMaxCount15, challengeRefreshTime, buy_count, last_challenge_buy_count_time)
								if (err == 0) then
									--是否要刷新次数
									local timeNow = hApi.GetTime()
									local datestamp = hApi.Timestamp2Date(timeNow)
									if (datestamp <= challengeRefreshTime) then
										--魔龙宝库副本，附加今日玩家已购买的额外次数
										local challenge_buy_count = buy_count
										--检测是否到第二天，重置今日已购买领奖次数
										local tab1 = os.date("*t", hApi.GetNewDate(last_challenge_buy_count_time))
										local tab2 = os.date("*t", os.time())
										if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
											challenge_buy_count = 0
										end
										if (challenge_buy_count > 0) then
											cMaxCount = cMaxCount + challenge_buy_count
											challengeMaxCount = challengeMaxCount + challenge_buy_count
										end
										
										--只统计军团副本
										--if (sessionCfgId == 2) or (sessionCfgId == 5) or (sessionCfgId == 6) or (sessionCfgId == 7) or (sessionCfgId == 8) or (sessionCfgId == 9) then --geyachao: 新加房间的配置项 军团
										local tBattleCount = {}
										tBattleCount[2] = cMaxCount - challengeMaxCount
										tBattleCount[5] = cMaxCount5 - challengeMaxCount5
										tBattleCount[6] = cMaxCount6 - challengeMaxCount6
										tBattleCount[7] = cMaxCount7 - challengeMaxCount7
										tBattleCount[8] = cMaxCount8 - challengeMaxCount8
										tBattleCount[9] = cMaxCount9 - challengeMaxCount9
										for r = 1, 13, 1 do
											local cfgId = r
											local tBattleCountValue = tBattleCount[r] or 0
											--今日已经挑战过了
											if (tBattleCountValue > 0) then
												--print("今日已经挑战过了", cfgId)
												
												--读取地图难度
												--查询玩家今日成功挑战该副本的最后一次记录
												local sQuery = string.format("SELECT `id`, `sid`, `game_diff`, `reward`, `reward_count` FROM `t_pvp_user_session` WHERE `game_cfgId` = %d AND `uid` = %d AND `resultType` = %d AND `time` >= '%s' ORDER BY `sid` DESC LIMIT 1", cfgId, uid, 0, strNewdate)
												local err1, us_id, sessionId, game_diff, reward, reward_count = xlDb_Query(sQuery)
												if (err1 == 0) then --今日有通关记录
													--查询玩家今日是否已经免费领取过
													local freeCount = 0
													local sQuery = string.format("SELECT COUNT(*) FROM `order` WHERE `itemid` = 10456 AND `ext_01` = '%d' AND `uid` = %d AND `time_begin` >= '%s'", cfgId, uid, strNewdate)
													local err, count = xlDb_Query(sQuery)
													if (err == 0) then
														freeCount = count
													end
													if (freeCount == 0) then
														--计算奖励
														local allReward, rewardIdxList, retCmd = private.CalculateChestResult(cfgId, game_diff, nTimestampNow)
														local sCmd = retCmd
														
														local strTitle = "" --地图奖励名字
														if (cfgId == 2) then --魔龙宝库
															strTitle = hVar.tab_string["__TEXT_PVE_MULTI_REWARD"] .. "-" .. hVar.tab_string["__TEXT_GROUP_BATTLE_BUYCOUNT"] --"士气提升"
														elseif (cfgId == 3) then --铜雀台
															strTitle = hVar.tab_string["__TEXT_PVE_MULTI_REWARD2"] .. "-" .. hVar.tab_string["__TEXT_GROUP_BATTLE_BUYCOUNT"] --"士气提升"
														elseif (cfgId == 5) then --铁 --geyachao: 新加房间的配置项 军团
															strTitle = hVar.tab_string["__TEXT_PVE_MULTI_REWARD5"] .. "-" .. hVar.tab_string["__TEXT_GROUP_BATTLE_BUYCOUNT"] --"士气提升"
														elseif (cfgId == 6) then --木材 --geyachao: 新加房间的配置项 军团
															strTitle = hVar.tab_string["__TEXT_PVE_MULTI_REWARD6"] .. "-" .. hVar.tab_string["__TEXT_GROUP_BATTLE_BUYCOUNT"] --"士气提升"
														elseif (cfgId == 7) then --粮食 --geyachao: 新加房间的配置项 军团
															strTitle = hVar.tab_string["__TEXT_PVE_MULTI_REWARD7"] .. "-" .. hVar.tab_string["__TEXT_GROUP_BATTLE_BUYCOUNT"] --"士气提升"
														elseif (cfgId == 8) then --军团组队 --geyachao: 新加房间的配置项 军团
															strTitle = hVar.tab_string["__TEXT_PVE_MULTI_REWARD8"] .. "-" .. hVar.tab_string["__TEXT_GROUP_BATTLE_BUYCOUNT"] --"士气提升"
														elseif (cfgId == 9) then --军团组队驻守模式 --geyachao: 新加房间的配置项 军团
															strTitle = hVar.tab_string["__TEXT_PVE_MULTI_REWARD9"] .. "-" .. hVar.tab_string["__TEXT_GROUP_BATTLE_BUYCOUNT"] --"士气提升"
														elseif (cfgId == 10) then --人族无敌
															strTitle = hVar.tab_string["__TEXT_PVE_MULTI_REWARD10"] .. "-" .. hVar.tab_string["__TEXT_GROUP_BATTLE_BUYCOUNT"] --"士气提升"
														elseif (cfgId == 11) then --魔塔杀阵
															strTitle = hVar.tab_string["__TEXT_PVE_MULTI_REWARD11"] .. "-" .. hVar.tab_string["__TEXT_GROUP_BATTLE_BUYCOUNT"] --"士气提升"
														elseif (cfgId == 12) then --守卫剑阁
															strTitle = hVar.tab_string["__TEXT_PVE_MULTI_REWARD12"] .. "-" .. hVar.tab_string["__TEXT_GROUP_BATTLE_BUYCOUNT"] --"士气提升"
														elseif (cfgId == 13) then --双人守卫剑阁
															strTitle = hVar.tab_string["__TEXT_PVE_MULTI_REWARD13"] .. "-" .. hVar.tab_string["__TEXT_GROUP_BATTLE_BUYCOUNT"] --"士气提升"
														elseif (cfgId == 14) then --仙之侠道
															strTitle = hVar.tab_string["__TEXT_PVE_MULTI_REWARD14"] .. "-" .. hVar.tab_string["__TEXT_GROUP_BATTLE_BUYCOUNT"] --"士气提升"
														elseif (cfgId == 15) then --霸王大陆
															strTitle = hVar.tab_string["__TEXT_PVE_MULTI_REWARD15"] .. "-" .. hVar.tab_string["__TEXT_GROUP_BATTLE_BUYCOUNT"] --"士气提升"
														end
														
														--给奖励
														local allRInfo = allReward:GetInfo()
														local ret = "" --奖励拼接字符串
														for i = 1, #rewardIdxList do
															local idx = rewardIdxList[i]
															if allRInfo[idx] and type(allRInfo[idx]) == "table" then
																--插入邮箱通知
																local v = allRInfo[idx]
																local tmp = (v[1] or 0)..":"..(v[2] or 0)..":"..(v[3] or 0)..":"..(v[4] or 0)..";"
																ret = ret .. tmp
															end
														end
														
														--魔龙宝库、军团宝库，挑战成功加随机数量的军团资源
														if (cfgId == 2) or (cfgId == 8) or (cfgId == 9) then --geyachao: 新加房间的配置项 军团
															--获得随机的军团资源
															local rand = math.random(1, #private.GROUP_BATTLE_REWARD)
															local addResType = private.GROUP_BATTLE_REWARD[rand][1]
															local addResValue = private.GROUP_BATTLE_REWARD[rand][2]
															ret = ret .. tostring(addResType) .. ":" .. tostring(addResValue) .. ":0:0;"
														end
														
														--军团副本，挑战成功加军团币
														--魔龙宝库也加军团币
														if (cfgId == 2) or (cfgId == 5) or (cfgId == 6) or (cfgId == 7) or (cfgId == 8) or (cfgId == 9) then --geyachao: 新加房间的配置项 军团
															ret = ret .. "20:" .. private.GROUPCOIN_REWARD .. ":0:0;"
														end
														
														--奖励
														ret = strTitle .. ";" .. hVar.tab_string["__TEXT_GROUP_BATTLE_REWARD_AUTO"] .. ";" .. ret
														local prizeType = 20031
														local sLog = string.format("insert into prize (`uid`, `rid`, `type`, `mykey`, `group_id`) values (%d, %d, %d, '%s', %d)", uid, 0, prizeType, ret, groupId)
														xlDb_Execute(sLog)
														
														--获得奖励id
														local prizeId = 0
														local err1, pid = xlDb_Query("select last_insert_id()")
														if (err1 == 0) then
															prizeId = pid
														end
														
														--士气提升，已无法花游戏币再抽一次
														local regetFreeCount = 0
														local regetPayCount = 0
														sCmd = tostring(regetFreeCount) .. ";" .. tostring(regetPayCount) .. ";" .. tostring(prizeId) .. ";" .. tostring(prizeType) .. ";" .. sCmd
														
														--geyachao: 新加房间的配置项 军团
														--军团副本，记录本次的贡献值
														--魔龙宝库也记录本次的贡献值
														if (cfgId == 2) or (cfgId == 5) or (cfgId == 6) or (cfgId == 7) or (cfgId == 8) or (cfgId == 9) then --geyachao: 新加房间的配置项 军团
															--记录贡献值
															allReward:AddGroupDonation(uid, strTitle, sessionId, cfgId, game_diff, ret)
														end
														
														--更新玩家游戏局信息
														local new_reward = tostring(reward) .. "\n" .. sCmd
														local new_reward_count = reward_count + 1
														local sUpdate = string.format("update `t_pvp_user_session` set `reward` = '%s', `reward_count` = %d WHERE `id` = %d and `sid` = %d", new_reward, new_reward_count, us_id, sessionId)
														xlDb_Execute(sUpdate)
														--print(sUpdate)
														
														--更新玩家此副本今天已挑战次数
														local strchallengeMaxCount = ""
														if (cfgId == 2) then
															strchallengeMaxCount = "challengeMaxCount"
														elseif (cfgId == 3) then
															strchallengeMaxCount = "challengeMaxCount1"
														elseif (cfgId == 5) then --geyachao: 新加房间的配置项 军团
															strchallengeMaxCount = "challengeMaxCount5"
														elseif (cfgId == 6) then --geyachao: 新加房间的配置项 军团
															strchallengeMaxCount = "challengeMaxCount6"
														elseif (cfgId == 7) then --geyachao: 新加房间的配置项 军团
															strchallengeMaxCount = "challengeMaxCount7"
														elseif (cfgId == 8) then --geyachao: 新加房间的配置项 军团
															strchallengeMaxCount = "challengeMaxCount8"
														elseif (cfgId == 9) then --测试地图
															strchallengeMaxCount = "challengeMaxCount9"
														elseif (cfgId == 10) then --人族无敌
															strchallengeMaxCount = "challengeMaxCount10"
														elseif (cfgId == 11) then --魔塔杀阵
															strchallengeMaxCount = "challengeMaxCount11"
														elseif (cfgId == 12) then --守卫剑阁
															strchallengeMaxCount = "challengeMaxCount12"
														elseif (cfgId == 13) then --双人守卫剑阁
															strchallengeMaxCount = "challengeMaxCount13"
														elseif (cfgId == 14) then --仙之侠道
															strchallengeMaxCount = "challengeMaxCount14"
														elseif (cfgId == 15) then --霸王大陆
															strchallengeMaxCount = "challengeMaxCount15"
														end
														
														--插入订单，新插入一条今日免费再领一次记录
														local shopitemId = 506
														local tabShopItem = hVar.tab_shopitem[shopitemId]
														local itemId = tabShopItem.itemID
														local rmbCost = tabShopItem.rmb
														local strInfo = tostring(cfgId)
														--iType,iUid,iRid,iItemId,iCoin,sItemName,sExt01
														hGlobal.userCoinMgr:DBUserPurchase(uid, rid, itemId, 1, rmbCost, 0, strInfo)
														
														--更新今日挑战次数
														local sUpdate = string.format("UPDATE `t_user` SET `%s` = `%s` - 1 WHERE `uid` = %d", strchallengeMaxCount, strchallengeMaxCount, uid)
														--print("sUpdate1:",sUpdate)
														xlDb_Execute(sUpdate)
														
														--军团单人副本，共享每日可挑战次数
														if (cfgId == 5) then --铁
															local sqlUpdate = string.format("UPDATE `t_user` SET `challengeMaxCount6` = `challengeMaxCount6` -1, `challengeMaxCount7` = `challengeMaxCount7` -1 where `uid` = %d", uid)
															xlDb_Execute(sqlUpdate)
															
															--插入订单，其他单人副本免费再领一次的记录
															hGlobal.userCoinMgr:DBUserPurchase(uid, rid, itemId, 0, rmbCost, 0, "6")
															hGlobal.userCoinMgr:DBUserPurchase(uid, rid, itemId, 0, rmbCost, 0, "7")
														elseif (cfgId == 6) then --木材
															local sqlUpdate = string.format("UPDATE `t_user` SET `challengeMaxCount5` = `challengeMaxCount5` -1, `challengeMaxCount7` = `challengeMaxCount7` -1 where `uid` = %d", uid)
															xlDb_Execute(sqlUpdate)
															
															--插入订单，其他单人副本免费再领一次的记录
															hGlobal.userCoinMgr:DBUserPurchase(uid, rid, itemId, 0, rmbCost, 0, "5")
															hGlobal.userCoinMgr:DBUserPurchase(uid, rid, itemId, 0, rmbCost, 0, "7")
														elseif (cfgId == 7) then --粮食
															local sqlUpdate = string.format("UPDATE `t_user` SET `challengeMaxCount5` = `challengeMaxCount5` -1, `challengeMaxCount6` = `challengeMaxCount6` -1 where `uid` = %d", uid)
															xlDb_Execute(sqlUpdate)
															
															--插入订单，其他单人副本免费再领一次的记录
															hGlobal.userCoinMgr:DBUserPurchase(uid, rid, itemId, 0, rmbCost, 0, "5")
															hGlobal.userCoinMgr:DBUserPurchase(uid, rid, itemId, 0, rmbCost, 0, "6")
														end
														
														--军团消息，可交互事件的次数
														--目前只发送铁、木材、粮食的任务通知
														if (cfgId == 5) or (cfgId == 6) or (cfgId == 7) then --geyachao: 新加房间的配置项 军团
															local nInteractType = hVar.GROUP_MESSAGE_TODAY_TYPE.NONE --可交互事件的类型
															if (cfgId == 5) then --铁
																strMapName = hVar.tab_string["__TEXT_GROUP_MAP_NAME5"] --"矿洞争夺战"
																nInteractType = hVar.GROUP_MESSAGE_TODAY_TYPE.BATTLE_IRON
															elseif (cfgId == 6) then --木材
																strMapName = hVar.tab_string["__TEXT_GROUP_MAP_NAME6"] --"守护伐木场"
																nInteractType = hVar.GROUP_MESSAGE_TODAY_TYPE.BATTLE_WOOD
															elseif (cfgId == 7) then --粮食
																strMapName = hVar.tab_string["__TEXT_GROUP_MAP_NAME7"] --"运粮"
																nInteractType = hVar.GROUP_MESSAGE_TODAY_TYPE.BATTLE_FOOD
															end
															--local message = "【" .. myName .. "】成功挑战" .. strMapName .. "，今日累计挑战" .. battleCount .. "次！"
															local message = string.format(hVar.tab_string["__TEXT_GROUP_MAP_BATTLE_SUCCESS_COUNT"], customS1, strMapName, tBattleCountValue+1) --加1是加上本次士气提升的次数
															
															--发送军团消息
															local tMsg = {}
															tMsg.chatType = hVar.CHAT_TYPE.GROUP
															tMsg.msgType = hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_TODAY --军团系统当日提示消息
															tMsg.uid = 0
															tMsg.name = hVar.tab_string["__TEXT_CHAT_SYSTEM"] --"系统"
															tMsg.channelId = 0
															tMsg.vip = 0
															tMsg.borderId = 1000
															tMsg.iconId = 1000
															tMsg.championId = 0
															tMsg.leaderId = 0
															tMsg.dragonId = 0
															tMsg.headId = 0
															tMsg.lineId = 0
															tMsg.content = message
															tMsg.date = os.date("%Y-%m-%d %H:%M:%S", os.time())
															tMsg.touid = groupId
															tMsg.result = nInteractType --可交互式事件的类型
															tMsg.resultParam = uid --可交互事件的参数为发送者uid
															--发送军团消息
															hGlobal.chatMgr:SendGroupSystemMessage(tMsg)
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end 
					
					--操作成功
					ret = 1
				end
			else
				--"今日购买次数已达上限"
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_BUY_BATTLE_MAXCOUNT
			end
		else
			--您没有权限进行此操作
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY
		end
	else
		--"您还未加入军团"
		ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_NOT_IN_GROUP
	end
	
	--操作失败通知客户度错误信息
	if (ret > 1) then
		--通知玩家操作结果
		local sCmd = tostring(ret)
		hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	--返回值
	local sCmd = tostring(ret) .. ";"
	return sCmd
end

--请求查询军团军饷任务完成情况
NoviceCampMgr.QueryGroupMilitaryTaskState = function(uid, rid)
	local single_count = 0 --今日军团单人副本挑战次数
	local couple_count = 0 --今日军团组队副本挑战次数
	local reward_state = 0 --今日领取状态
	
	--查询今日军团副本已挑战次数
	local sQuery = string.format("SELECT `battle_single_count`, `last_battle_single_time`, `battle_couple_count`, `last_battle_couple_time`, `last_military_reward_time` from `t_chat_user` where `uid` = %d", uid)
	local err1, battle_single_count, last_battle_single_time, battle_couple_count, last_battle_couple_time, last_military_reward_time = xlDb_Query(sQuery)
	if (err1 == 0) then
		single_count = battle_single_count
		couple_count = battle_couple_count
		
		--今日时间戳
		local nTimestampNow = os.time()
		local tab2 = os.date("*t", nTimestampNow)
		
		--检测是否到第二天，重置今日军团单人副本次数
		local tab1_single = os.date("*t", hApi.GetNewDate(last_battle_single_time))
		--local tab2 = os.date("*t", nTimestampNow)
		if (tab1_single.year ~= tab2.year) or (tab1_single.month ~= tab2.month) or (tab1_single.day ~= tab2.day) then --到了第二天
			single_count = 0
		end
		
		--检测是否到第二天，重置今日军团组队副本次数
		local tab1_couple = os.date("*t", hApi.GetNewDate(last_battle_couple_time))
		--local tab2 = os.date("*t", nTimestampNow)
		if (tab1_couple.year ~= tab2.year) or (tab1_couple.month ~= tab2.month) or (tab1_couple.day ~= tab2.day) then --到了第二天
			couple_count = 0
		end
		
		--检测是否到第二天，重置今日军团军饷是否已领取
		local tab1_military = os.date("*t", hApi.GetNewDate(last_military_reward_time))
		--local tab2 = os.date("*t", nTimestampNow)
		if (tab1_military.year == tab2.year) and (tab1_military.month == tab2.month) and (tab1_military.day == tab2.day) then --还是今天
			reward_state = 1
		end
	end
	
	--返回值
	local sCmd = tostring(single_count) .. ";" .. tostring(couple_count) .. ";" .. tostring(reward_state) .. ";"
	return sCmd
end

--请求领取军团军饷任务
NoviceCampMgr.TakeRewardGroupMilitaryTask = function(uid, rid)
	local single_count = 0 --今日军团单人副本挑战次数
	local couple_count = 0 --今日军团组队副本挑战次数
	local reward_state = 0 --今日领取状态
	local iCoin = 0 --领取的游戏币数量
	local ret = 0 --返回值
	
	--查询今日军团副本已挑战次数
	local sQuery = string.format("SELECT `battle_single_count`, `last_battle_single_time`, `battle_couple_count`, `last_battle_couple_time`, `last_military_reward_time` from `t_chat_user` where `uid` = %d", uid)
	local err1, battle_single_count, last_battle_single_time, battle_couple_count, last_battle_couple_time, last_military_reward_time = xlDb_Query(sQuery)
	if (err1 == 0) then
		single_count = battle_single_count
		couple_count = battle_couple_count
		
		--今日时间戳
		local nTimestampNow = os.time()
		local tab2 = os.date("*t", nTimestampNow)
		
		--检测是否到第二天，重置今日军团单人副本次数
		local tab1_single = os.date("*t", hApi.GetNewDate(last_battle_single_time))
		--local tab2 = os.date("*t", nTimestampNow)
		if (tab1_single.year ~= tab2.year) or (tab1_single.month ~= tab2.month) or (tab1_single.day ~= tab2.day) then --到了第二天
			single_count = 0
		end
		
		--检测是否到第二天，重置今日军团组队副本次数
		local tab1_couple = os.date("*t", hApi.GetNewDate(last_battle_couple_time))
		--local tab2 = os.date("*t", nTimestampNow)
		if (tab1_couple.year ~= tab2.year) or (tab1_couple.month ~= tab2.month) or (tab1_couple.day ~= tab2.day) then --到了第二天
			couple_count = 0
		end
		
		--检测是否到第二天，重置今日军团军饷是否已领取
		local tab1_military = os.date("*t", hApi.GetNewDate(last_military_reward_time))
		--local tab2 = os.date("*t", nTimestampNow)
		if (tab1_military.year == tab2.year) and (tab1_military.month == tab2.month) and (tab1_military.day == tab2.day) then --还是今天
			reward_state = 1
		end
	end
	
	if (reward_state == 0) then --今日还未领取军饷
		if (single_count >= hVar.GROUP_DAYEWARD_SINGLE_BATTLE_COUNT) and (couple_count >= hVar.GROUP_DAYEWARD_COUPLE_BATTLE_COUNT) then --符合领取军饷的条件
			--玩家所在的工会id
			local groupId = private.Data_GetNcId(uid)
			if (groupId > 0) then
				local iMasterUid,iDissolution,iMemberCount,iMaxMember,iVitality,iGraduate,sTime,iCountry,iIron,iWood,iFood,sBuild,iBuyBattleCount,sLastBuyBattleCountTime = private.Data_GetNcInfo(groupId)
				local tBuild = private.Helper_String2Table(sBuild)
				
				--直接发游戏币
				iCoin = hVar.tab_build[80068].legioninfo.provide["COIN"][tBuild.mainlv] or 0
				if (iCoin > 0) then
					--更新领取军饷时间
					local sUpdate = string.format("UPDATE `t_chat_user` SET `last_military_reward_time` = now() WHERE uid = %d", uid)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
					
					--加钱
					local sUpdate = string.format("UPDATE `t_user` SET `gamecoin_online` = `gamecoin_online` + %d WHERE uid = %d", iCoin, uid)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
					
					--插入奖励记录
					local sKey = string.format(hVar.tab_string["__TEXT_GROUP_DALIYREWARD"],iCoin) --"领取军团军饷;%d"
					local sSql = string.format("INSERT INTO prize (`uid`,`rid`,`type`,`used`,`mykey`,`group_id`) VALUES (%d, %d, %d, %d, '%s', %d)",uid,rid,400,2,sKey,groupId)
					xlDb_Execute(sSql)
					
					--标记已领取
					reward_state = 1
					
					--操作成功
					ret = 1
				end
			else
				--"您还未加入军团"
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_NOT_IN_GROUP
			end
		else
			--"未满足领取军饷条件"
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_MILITARY_TAKEREWARD_FAIL
		end
	else
		--"今日已领取过军饷"
		ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_MILITARY_TAKEREWARD_ONCE
	end
	
	--操作失败通知客户度错误信息
	if (ret > 1) then
		--通知玩家操作结果
		local sCmd = tostring(ret)
		hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	--返回值
	local sCmd = tostring(ret) .. ";" .. tostring(single_count) .. ";" .. tostring(couple_count) .. ";" .. tostring(reward_state) .. ";" .. tostring(iCoin) .. ";"
	return sCmd
end

--请求踢出长期不在线的其他军团的玩家（仅管理员可操作）
NoviceCampMgr.KickGroupOfflinePlayer = function(uid, rid, groupId, kickUid)
	local ret = 0 --返回值
	
	--查找用户对象
	local user = hGlobal.uMgr:FindUserByDBID(uid)
	--如果玩家存在
	if user then
		local bTester = user:GetTester()
		if (bTester == 2) then --仅管理员可操作
			--检测待踢出的玩家是否在指定军团里
			local iLevel = private.Data_GetMemberLevel(kickUid, groupId)
			if iLevel and (iLevel > 0) then
				--超过30天未登录才能被清理踢出军团（仅管理员可操作）
				--查询玩家上次登录时间
				--local strLastLoginTime = ""
				local sQueryM = string.format("SELECT `last_login_time` FROM `t_user` WHERE `uid` = %d", kickUid)
				local errM, strLastLoginTime = xlDb_Query(sQueryM)
				--print("查询会长上次登录时间:", "errM=", errM, "strLastLoginTime=", strLastLoginTime)
				if (errM == 0) then
					local lastlogintime = hApi.GetNewDate(strLastLoginTime)
					local currenttimestamp = os.time()
					local loginLastTime = currenttimestamp - lastlogintime
					if (loginLastTime > 2592000) then --30天未登录
						--踢出的玩家不能是会长
						if (iLevel ~= hVar.GROUP_MEMBER_AUTORITY.ADMIN) then
							--踢出的玩家是军团助理
							if (iLevel == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevel == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then
								--取消标记助理
								--private.Data_SetAssistantMember(kickUid, hVar.GROUP_MEMBER_AUTORITY.NORMAL)
								
								--退出军团取消任命军团助理
								hGlobal.groupMgr:OnAssistantLeaveGroupMember(groupId, kickUid, hVar.GROUP_MEMBER_AUTORITY.NORMAL)
							end
							
							private.Data_DeleteMember(kickUid)
							private.Data_DecreaseMemberCount(groupId)
							local sMyBuildPrize = private.Data_GetMyNcPrize(kickUid)
							local tMyBuildPrize = private.Helper_String2Table(sMyBuildPrize)
							if "table" == type(tMyBuildPrize) then
								tMyBuildPrize["UNIQUETACTICS"] = nil
								sMyBuildPrize = private.Helper_Table2String(tMyBuildPrize)
								private.Data_UpdateMyNcPrize(kickUid,sMyBuildPrize)
							end
							local days = private.Data_GetVitalityTime(kickUid)
							if "number" == type(days) and 0 == days then
								--踢出长期不在线的玩家（仅管理员可操作）
								private.Data_AddVitality(groupId,-30)
								local info = string.format("MinusVitalityFire ncid:%d uid:%d", groupId, kickUid)
								hGlobal.fileWriter:Write(info)
							end
							hGlobal.groupMgr:OnKickOfflineGroupMember(groupId, uid, kickUid)
							
							--操作成功
							ret = 1
						else
							--会长不能被移除
							ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_KICK_ADMIN
						end
					else
						--玩家30天未登录才能移除
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_KICK_30DADS_OFFLINE
					end
				else
					--无效的玩家
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
				end
			else
				--"玩家未加入军团"
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_USER_NOT_JOIN
			end
		else
			--"您没有权限进行此操作"
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY
		end
	else
		--"玩家未初始化"
		ret = hVar.GROUPSERVER_ERROR_TYPE.NO_USER_INIT
	end
	
	--操作失败通知客户度错误信息
	if (ret > 1) then
		--通知玩家操作结果
		local sCmd = tostring(ret)
		hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	--返回值
	local sCmd = tostring(ret) .. ";"
	return sCmd
end

--请求任命玩家为会长（仅管理员可操作）
NoviceCampMgr.AssetAdminPlayer = function(uid, rid, groupId, kickUid)
	local ret = 0 --返回值
	
	--查找用户对象
	local user = hGlobal.uMgr:FindUserByDBID(uid)
	--如果玩家存在
	if user then
		local bTester = user:GetTester()
		if (bTester == 2) then --仅管理员可操作
			--检测待任命的玩家是否在指定军团里
			local iLevel = private.Data_GetMemberLevel(kickUid, groupId)
			if iLevel and (iLevel > 0) then
				--助理才能被任命会长
				if (iLevel == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevel == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then
					--会长超过30天未登录才能卸任会长（仅管理员可操作）
					--local iMasterUid, iDissolution, iMemberCount, iMaxMember = private.Data_GetNcInfo(groupId)
					local iMasterUid,iDissolution,iMemberCount,iMaxMember,iVitality,iGraduate,sTime,iCountry,iIron,iWood,iFood,sBuild,iBuyBattleCount,sLastBuyBattleCountTime,sLastTransfertTime = private.Data_GetNcInfo(groupId)
					--查询会长上次登录时间
					--local strLastLoginTime = ""
					local sQueryM = string.format("SELECT `last_login_time` FROM `t_user` WHERE `uid` = %d", iMasterUid)
					local errM, strLastLoginTime = xlDb_Query(sQueryM)
					--print("查询会长上次登录时间:", "errM=", errM, "strLastLoginTime=", strLastLoginTime)
					if (errM == 0) then
						local lastlogintime = hApi.GetNewDate(strLastLoginTime)
						local currenttimestamp = os.time()
						local loginLastTime = currenttimestamp - lastlogintime
						if (loginLastTime > 2592000) then --30天未登录
							--检测军团创建时间是否达到30天
							local lastcreatetime = hApi.GetNewDate(sTime)
							--local currenttimestamp = os.time()
							local createLastTime = currenttimestamp - lastcreatetime
							if (createLastTime > 2592000) then --创建军团达到30天
								--检测军团上次转让时间是否达到30天
								local lasttransferttime = hApi.GetNewDate(sLastTransfertTime)
								--local currenttimestamp = os.time()
								local transferLastTime = currenttimestamp - lasttransferttime
								if (transferLastTime > 2592000) then --上次转让军团达到30天
									--检测助理vip等级是否有权限创建军团
									local vipLv = hGlobal.vipMgr:DBGetUserVip(kickUid) --玩家vip等级
									local bCreateGroup = hVar.Vip_Conifg.createGroup[vipLv] --是否可创建军团权限
									if bCreateGroup then
										local townId = 80068 --主城id
										local townLv = 0 --主城等级
										local tmp = "local strCfg = ".. tostring(sBuild) .. " return strCfg"
										local tBuildInfo = assert(loadstring(tmp))()
										if (type(tBuildInfo) == "table") then
											local buildlist = tBuildInfo.buildlist
											if buildlist then
												for i = 1, #buildlist, 1 do
													if (buildlist[i].id == townId) then --找到了
														townLv = buildlist[i].lv
														break
													end
												end
											end
										end
										if (townLv >= 3) then --主城达到3级
											--会长标记为普通成员
											private.Data_SetAssistantMember(iMasterUid, hVar.GROUP_MEMBER_AUTORITY.NORMAL)
											
											--助理标记为会长
											private.Data_SetAssistantMember(kickUid, hVar.GROUP_MEMBER_AUTORITY.ADMIN)
											
											--更新军团的会长名称
											local assistname = ""
											local sQueryM = string.format("SELECT `customS1` FROM `t_user` WHERE `uid` = %d", kickUid)
											local errM, customS1 = xlDb_Query(sQueryM)
											if (errM == 0) then
												assistname = customS1
											end
											local sSql = string.format("UPDATE `novicecamp_list` SET `master_uid` = %d, `master_name` = '%s', `last_transfer_time` = NOW() where `id` = %d", kickUid, assistname, groupId)
											xlDb_Execute(sSql)
											
											--通知事件
											hGlobal.groupMgr:OnAssetAdminGroupMember(groupId, iMasterUid, kickUid)
											
											--操作成功
											ret = 1
										else
											--主城达到3级才能转让
											ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_TRANSFER_MAINTOWN_LV3
										end
									else
										--助理VIP2及以上才能任命为会长
										ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_ASSET_ADMIN_VIP_LEVEL
									end
								else
									--军团近30天内已经转让过
									ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_TRANSFER_HAVE_TRANSFERD_30_DAYS
								end
							else
								--军团创建时间达到30天才能转让
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_TRANSFER_CREATE_30_DAYS
							end
						else
							--会长30天未登录才能卸任
							ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_ASSET_ADMIN_30DADS_OFFLINE
						end
					else
						--无效的玩家
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
					end
				else
					--"待任命的玩家必须是助理"
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_ASSET_ADMIN_NOTASSITANT
				end
			else
				--"玩家未加入军团"
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_USER_NOT_JOIN
			end
		else
			--"您没有权限进行此操作"
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY
		end
	else
		--"玩家未初始化"
		ret = hVar.GROUPSERVER_ERROR_TYPE.NO_USER_INIT
	end
	
	--操作失败通知客户度错误信息
	if (ret > 1) then
		--通知玩家操作结果
		local sCmd = tostring(ret)
		hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	--返回值
	local sCmd = tostring(ret) .. ";"
	return sCmd
end

--会长请求转让军团给助理
NoviceCampMgr.AssetGroupTransfer = function(uid, rid, groupId, kickUid)
	local ret = 0 --返回值
	local newAdminName = "" --新会长名字
	
	--查找用户对象
	local user = hGlobal.uMgr:FindUserByDBID(uid)
	--如果玩家存在
	if user then
		--存在助理才能转让
		if (kickUid > 0) then
			--检测待任命的玩家是否在指定军团里
			local iLevel = private.Data_GetMemberLevel(kickUid, groupId)
			if iLevel and (iLevel > 0) then
				--助理才能转让为会长
				if (iLevel == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (iLevel == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then
					--操作者必须是会长
					local iMasterUid,iDissolution,iMemberCount,iMaxMember,iVitality,iGraduate,sTime,iCountry,iIron,iWood,iFood,sBuild,iBuyBattleCount,sLastBuyBattleCountTime,sLastTransfertTime = private.Data_GetNcInfo(groupId)
					if (iMasterUid == uid) then
						--检测军团创建时间是否达到30天
						local lastcreatetime = hApi.GetNewDate(sTime)
						local currenttimestamp = os.time()
						local createLastTime = currenttimestamp - lastcreatetime
						if (createLastTime > 2592000) then --创建军团达到30天
							--检测军团上次转让时间是否达到30天
							local lasttransferttime = hApi.GetNewDate(sLastTransfertTime)
							--local currenttimestamp = os.time()
							local transferLastTime = currenttimestamp - lasttransferttime
							if (transferLastTime > 2592000) then --上次转让军团达到30天
								--检测助理vip等级是否有权限创建军团
								local vipLv = hGlobal.vipMgr:DBGetUserVip(kickUid) --玩家vip等级
								local bCreateGroup = hVar.Vip_Conifg.createGroup[vipLv] --是否可创建军团权限
								if bCreateGroup then
									local townId = 80068 --主城id
									local townLv = 0 --主城等级
									local tmp = "local strCfg = ".. tostring(sBuild) .. " return strCfg"
									local tBuildInfo = assert(loadstring(tmp))()
									if (type(tBuildInfo) == "table") then
										local buildlist = tBuildInfo.buildlist
										if buildlist then
											for i = 1, #buildlist, 1 do
												if (buildlist[i].id == townId) then --找到了
													townLv = buildlist[i].lv
													break
												end
											end
										end
									end
									if (townLv >= 3) then --主城达到3级
										--会长标记为普通成员
										private.Data_SetAssistantMember(iMasterUid, hVar.GROUP_MEMBER_AUTORITY.NORMAL)
										
										--助理标记为会长
										private.Data_SetAssistantMember(kickUid, hVar.GROUP_MEMBER_AUTORITY.ADMIN)
										
										--更新军团的会长名称
										local assistname = ""
										local sQueryM = string.format("SELECT `customS1` FROM `t_user` WHERE `uid` = %d", kickUid)
										local errM, customS1 = xlDb_Query(sQueryM)
										if (errM == 0) then
											assistname = customS1
										end
										local sSql = string.format("UPDATE `novicecamp_list` SET `master_uid` = %d, `master_name` = '%s', `last_transfer_time` = NOW() where `id` = %d", kickUid, assistname, groupId)
										xlDb_Execute(sSql)
										
										--通知事件
										hGlobal.groupMgr:OnTranfserGroupMember(groupId, iMasterUid, kickUid)
										
										--标记新会长名字
										newAdminName = assistname
										
										--操作成功
										ret = 1
									else
										--主城达到3级才能转让
										ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_TRANSFER_MAINTOWN_LV3
									end
								else
									--助理达到VIP2才能转让
									ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_TRANSFER_ASSIST_VIP2
								end
							else
								--军团近30天内已经转让过
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_TRANSFER_HAVE_TRANSFERD_30_DAYS
							end
						else
							--军团创建时间达到30天才能转让
							ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_TRANSFER_CREATE_30_DAYS
						end
					else
						--您没有权限进行此操作
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY
					end
				else
					--"待转让的玩家必须是助理"
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_TRANSFER_NOTASSITANT
				end
			else
				--"玩家未加入军团"
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_USER_NOT_JOIN
			end
		else
			--"军团助理尚未任命，无法转让"
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_TRANSFER_NO_ASSIST
		end
	else
		--"玩家未初始化"
		ret = hVar.GROUPSERVER_ERROR_TYPE.NO_USER_INIT
	end
	
	--操作失败通知客户度错误信息
	if (ret > 1) then
		--通知玩家操作结果
		local sCmd = tostring(ret)
		hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	--返回值
	local sCmd = tostring(ret) .. ";" .. tostring(groupId) .. ";" .. tostring(uid) .. ";" .. tostring(kickUid) .. ";" .. tostring(newAdminName) .. ";"
	return sCmd
end

--解散工会（仅管理员可操作）
NoviceCampMgr.AssetGroupDisolute = function(uid, rid, groupId)
	local ret = 0 --返回值
	
	--查找用户对象
	local user = hGlobal.uMgr:FindUserByDBID(uid)
	--如果玩家存在
	if user then
		local bTester = user:GetTester()
		if (bTester == 2) then --仅管理员可操作
			local iMasterUid,iDissolution,iMemberCount,iMaxMember,iVitality,iGraduate,sTime,iCountry,iIron,iWood,iFood,sBuild = private.Data_GetNcInfo(groupId)
			if nil == iMasterUid then
				--参数不合法
				ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_PARAM
			else
				if 0 == iDissolution then
					--此军团只剩会长一个人才能解散（管理员）
					if (iMemberCount <= 1) then
						--会长近30天未登陆才能解散（管理员）
						local sQueryM = string.format("SELECT `last_login_time` FROM `t_user` WHERE `uid` = %d", iMasterUid)
						local errM, strLastLoginTime = xlDb_Query(sQueryM)
						--print("查询会长上次登录时间:", "errM=", errM, "strLastLoginTime=", strLastLoginTime)
						if (errM == 0) then
							local lastlogintime = hApi.GetNewDate(strLastLoginTime)
							local currenttimestamp = os.time()
							local loginLastTime = currenttimestamp - lastlogintime
							
							--如果会长是系统，永远在线
							if (iMasterUid < 10000) then
								loginLastTime = 0
							end
							
							if (loginLastTime > 2592000) then --30天未登录
								--可以解散（管理员）
								private.Data_DeleteAllMember(groupId)
								
								--通知事件
								hGlobal.groupMgr:OnRemoveGroup_Admin(groupId, iMasterUid)
								
								private.Data_SetNcDissolution(groupId,iMasterUid,1)
								
								--操作成功
								ret = 1
							else
								--会长30天未登录才能解散
								ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISOLUTE_30DADS_OFFLINE
							end
						else
							--无效的玩家
							ret = hVar.GROUPSERVER_ERROR_TYPE.NO_VALID_UID
						end
					else
						--军团只剩1人才能解散
						ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISOLUTE_MEMBER1
					end
				else
					--该军团不存在或已解散
					ret = hVar.GROUPSERVER_ERROR_TYPE.NO_GROUP_DISSOLUTION_GROUP
				end
			end
		else
			--您没有权限进行此操作
			ret = hVar.GROUPSERVER_ERROR_TYPE.NO_AUTHORITY
		end
	else
		--"玩家未初始化"
		ret = hVar.GROUPSERVER_ERROR_TYPE.NO_USER_INIT
	end
	
	--操作失败通知客户度错误信息
	if (ret > 1) then
		--通知玩家操作结果
		local sCmd = tostring(ret)
		hApi.xlNet_Send(uid, hVar.GROUP_RECV_TYPE.L2C_NOTICE_CHAT_ORPEATION_RESULT, sCmd)
	end
	
	local sCmd = tostring(ret) .. ";"
	return sCmd
end

--NoviceCampMgr.OnLoop()