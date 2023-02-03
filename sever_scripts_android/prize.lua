--[[
g_sNameAward = {
	{type="sc",num=500,},
	{type="it",num=5,id=31},
}
--]]
--if nil == loadstring then
--	loadstring = load
--	xlDb_Execute = red.xlDb_Execute
--	xlDb_Query = red.xlDb_Query
--end

function callback_user_logevent(iUid, iRid, iType, iTag)
	if 1 == iType then
		-- 02 获取每日初始化时间变量
		local iErrorCode,iDays = xlDb_Query(string.format("SELECT DATEDIFF(NOW(),time_daily_init) FROM t_user WHERE uid = %d",iUid))
		if 0 == iErrorCode and 0 < iDays then
			local sql = string.format("UPDATE t_user SET online_today = 0,time_daily_init = NOW() WHERE uid = %d",iUid)
			xlDb_Execute(sql)
		end
	else
		local sql = string.format("UPDATE t_user SET online_total = online_total + TIMESTAMPDIFF(MINUTE,last_login_time,NOW()),online_today = online_today + TIMESTAMPDIFF(MINUTE,last_login_time,NOW()) WHERE uid = %d",iUid)
		xlDb_Execute(sql)
	end
end

function callback_apple_pid_2_index(appleid)
	printf("callback_apple_pid_2_index",appleid)
	if "tier01.yellowstone.aliensmash" == appleid then return 10001 end --6
	--if "tier05.yellowstone.aliensmash" == appleid then return 10002 end --30
	if "tier05.yellowstone.aliensmash" == appleid then return 10101 end --30 --苹果30元改为月卡
	if "tier10.yellowstone.aliensmash" == appleid then return 10003 end --68
	if "tier20.yellowstone.aliensmash" == appleid then return 10004 end --128
	if "tier50.yellowstone.aliensmash" == appleid then return 10005 end --328
	if "tier60.yellowstone.aliensmash" == appleid then return 10006 end --648
	
	if "tier01.giftpack.aliensmash" == appleid then return 22201 end --6
	if "tier02.giftpack.aliensmash" == appleid then return 22202 end --12
	if "tier04.giftpack.aliensmash" == appleid then return 22203 end --25
	if "tier07.giftpack.aliensmash" == appleid then return 22204 end --45
	if "tier15.giftpack.aliensmash" == appleid then return 22205 end --98
	if "tier30.giftpack.aliensmash" == appleid then return 22206 end --198
	
	return 0
end

function callback_task_obtain_prize(iUid,iRid,iTaskId,iPower,sPrize,iGroup)
	--解析奖励物品
	g_sNameAward = {}
	local sAwards = "g_sNameAward = {"..sPrize.."}"
	loadstring(sAwards)()
	local ix = {}
	for i=1,#g_sNameAward do
		if g_sNameAward[i].type == "cn" then -- coin
			local num = g_sNameAward[i].num * iPower
			-- t_user
			local sql = string.format("update t_user set gamecoin_online = gamecoin_online + %d where uid = %d",num,iUid)
			local log = string.format("insert into prize (uid,type,mykey,used,create_id) values (%d,%d,%d,%d,%d)",iUid,400,num,2,iTaskId)
			xlDb_Execute(sql)
			xlDb_Execute(log)
		elseif g_sNameAward[i].type == "ix" then -- t_cha
			if g_sNameAward[i].id == 30 or g_sNameAward[i].id == 9004 or g_sNameAward[i].id == 9005 or g_sNameAward[i].id == 9006 or (9300 <= g_sNameAward[i].id and g_sNameAward[i].id <= 9320) or g_sNameAward[i].id == 9999 then
				ix[#ix+1] = {}
				ix[#ix].id = g_sNameAward[i].id
				ix[#ix].num = g_sNameAward[i].num * iPower
			end
		end
	end
	-- t_cha
	if 0 < #ix then
		local sql = "update t_cha set "
		local logvii = "insert  into log_vii(uid,rid,type,num,traceid) values "
		for i=1,#ix do
			local name = ""
            if 30 == ix[i].id then name = "material_red" end
			if 9004 == ix[i].id then name = "chest_cuprum" end
			if 9005 == ix[i].id then name = "chest_silver" end
			if 9006 == ix[i].id then name = "chest_gold" end
			if 9999 == ix[i].id then name = "prize_code" end
			if 9300 <= ix[i].id and ix[i].id <= 9320 then
				name = "ext_op" .. tostring(ix[i].id)
			end
			local tmp = string.format("%s=%s+%d",name,name,ix[i].num)
			if 1 == i then
				sql = sql .. tmp
			else
				sql = sql .. "," .. tmp
				logvii = logvii .. ","
			end
			logvii = logvii .. string.format("(%d,%d,%d,%d,%d)",iUid,iRid,ix[i].id,ix[i].num,iTaskId)
		end
		sql = sql .. string.format(" where uid = %d and id = %d",iUid,iRid)
		logvii = logvii .. ";"
		xlDb_Execute(sql)
		xlDb_Execute(logvii)
	end

    if "number" == type(iGroup) and 3 == iGroup then
        if "table" == type(NoviceCampMgr) and "function" == type(NoviceCampMgr.OnTaskFinish) then
            NoviceCampMgr.OnTaskFinish(iUid,iRid,iTaskId)
        end
    end

	-- update flag
	local sql = string.format("update task_dispatch set flag=1 where id = %d",iTaskId)
	xlDb_Execute(sql)

	g_sNameAward = nil
end

function callback_task_rand_prize(iRand,sPrize)
	--解析奖励物品
	g_sNameAward = {}
	local sAwards = "g_sNameAward = {"..sPrize.."}"
	loadstring(sAwards)()
	if 0 == iRand or #g_sNameAward == iRand then return sPrize end
	
	local randres = randprize(iRand,#g_sNameAward)
	if nil == randres then return sPrize end
	
	local tPrize = {}
	for i=1,#g_sNameAward do
		if randres[i] then
			tPrize[#tPrize + 1] = g_sNameAward[i]
			--print(string.format("newprize index:%d\n",i))
		end
	end

	local sNewPrize = getprize(tPrize)
	--print(string.format("newprize:%s\n",sNewPrize))
	g_sNameAward = nil
	return sNewPrize
end
math.randomseed(os.time())
function randprize(iRand,iMax)
	--print(string.format("randprize rand:%d,max:%d\n",iRand,iMax))
	if iMax <= iRand then return nil end
	local res = {}
	local count = 0
	while(1) do
		-- 01 获取一个随机数
		local i = math.random(iMax)
		-- 02 判断是否已经存在
		if nil == res[i] then
			res[i] = i
			count = count + 1
		end
		-- 03 判断是否已经随机够了
		if count == iRand then return res end
	end
end
function getprize(t_prize)
	local info = ""
	for i=1,#t_prize do
		if "table" == type(t_prize[i]) then
			info = info .. "{"
			for k,v in pairs(t_prize[i]) do
				if "string" == type(v) then
					info = info .. string.format("%s=\"%s\",",tostring(k),v)
				else
					info = info .. string.format("%s=%d,",tostring(k),v)
				end
			end
			info = info .. "},"
		end
	end
	return info
end




--[[
g_sNameAward = {
	/*lv01*/		{
						rate=5,
						prize={
									{type="sc",num=500,},
									{type="it",num=5,id=31},
							}
					},
	/*lv02*/		{},
	/*lv03*/		{},
}
--]]

--活动奖励表转为发邮箱奖励
function helper_activity_prize2mailstring(uid,aid,prize)
	--print("helper_activity_prize2mailstring", uid, aid, string.format("prize.type:%s\n",prize.type))
	local sMailString = nil
	if "cn" == prize.type then
		sMailString = string.format("(%d,%d,\'c:%d;\',%d)",uid,10000,prize.num,aid)
	elseif "sc" == prize.type then
		sMailString = string.format("(%d,%d,\'%d\',%d)",uid,1039,prize.num,aid)
	elseif "ix" == prize.type then
		if 9108 == prize.id then
			sMailString = string.format("(%d,%d,\'%s\',%d)",uid,7000,prize.detail,aid)
        elseif 9997 == prize.id then
            sMailString = string.format("(%d,%d,\'%s\',%d)",uid,9997,prize.detail,aid)
		else
			sMailString = string.format("(%d,%d,\'%d\',%d)",uid,prize.id,prize.num,aid)
		end
	elseif "tc" == prize.type then
		local sMyKey = string.format("bfs:%dlv:%dn:%d",prize.id,prize.level,prize.num)
		sMailString = string.format("(%d,%d,\'%s\',%d)",uid,7,sMyKey,aid)
	elseif "it" == prize.type then
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
	elseif "td" == prize.type then
		local tDetail = hApi.Split(prize.detail,";")
		local tmp
		local idx = 1
		--print("sMailString:1",sMailString,tDetail)
		for i = 2, #tDetail do
			local reward =  hApi.Split(tDetail[i] or "", ":")
			--print("sMailString:11",reward[1])
			if tonumber(reward[1]) and tonumber(reward[1]) > 0 then
				--如果是抽n个卡牌，则要插入相应的数据
				--print("sMailString:12",sMailString,tDetail)
				if tonumber(reward[1]) == 9 then
					--[[
					--print("sMailString:13",sMailString,tDetail)
					local num = (reward[3] or 1)
					local strReward = (reward[1] or 0)..":"..(reward[2] or 0)..":"..(1)..":"..(reward[4] or 0)..";"
					--print("sMailString:14",sMailString,tDetail)
					for p = 1, num do
						local sLog = string.format("%s;%s",tDetail[1] or "",strReward)
						local tmptmp = string.format("(%d,%d,\'%s\',%d)",uid,prize.id,sLog,aid)
						if not sMailString then
							sMailString = tmptmp
						else
							-sMailString = sMailString .. "," .. tmptmp
						end
					end
					--print("sMailString:15",sMailString,tDetail)
					]]
					--geyachao: 抽卡现在客户端直接打开了
					if not tmp then
						tmp = ""
					end
					tmp = tmp .. tDetail[i] .. ";"
				else
					--print("sMailString:16",sMailString,tDetail)
					if not tmp then
						tmp = ""
					end
					tmp = tmp .. tDetail[i] .. ";"
					--print("sMailString:17",sMailString,tDetail)
				end
			end
			--print("sMailString:18")
		end
		--print("sMailString:2",sMailString)
		if tmp then
			tmp = (tDetail[1] or "") .. ";" .. tmp
			local tmptmp = string.format("(%d,%d,\'%s\',%d)",uid,prize.id,tmp,aid)
			if not sMailString then
				sMailString = tmptmp
			else
				sMailString = sMailString .. "," .. tmptmp
			end
		end

		--print("sMailString:3",sMailString)
	end
	return sMailString
end

--服务器脚本回调函数
--普通类型的活动发奖
function callback_activity_obtain_prize(iUid,iRid,iActivityType,iActivityId,iProgress,sPrize)
	--解析奖励物品
	g_sNameAward = {}
	local sAwards = "g_sNameAward = {"..sPrize.."}"
	loadstring(sAwards)()
	-- 01 获取当前的完成等级
	local iCurrentLevel = 0
	for i=1,#g_sNameAward do
		if g_sNameAward[i].rate <= iProgress then
			iCurrentLevel = i
		end
	end
	
	--print(string.format("uid:%d,rid:%d,at:%d,aid:%d,progress:%d,currentlevel:%d\n",iUid,iRid,iActivityType,iActivityId,iProgress,iCurrentLevel))
	
	if 0 < iCurrentLevel then
		-- 02 获取老的完成等级
		local iErrorCode,iLastLevel = xlDb_Query(string.format("select `level` from activity_check where uid=%d and aid=%d limit 1",iUid,iActivityId))
		if 0 == iErrorCode or 4 == iErrorCode then
			if nil == iLastLevel then iLastLevel = 0 end
			--print(string.format("errorcode:%d lastlevel:%d\n",iErrorCode,iLastLevel))
			-- 03 获取需要派送的所有奖励
			local ix = {}
			for i=(iLastLevel + 1),iCurrentLevel do
				local pt = g_sNameAward[i].prize
				for j=1,#pt do
					if "table" == type(pt[j]) then
						ix[#ix+1] = pt[j]
						--print(string.format("prizeid:%d\n",pt[j].id))
					end
				end
			end
			--print(string.format("#ix:%d\n",#ix))
			-- 04 派奖到邮件系统
			if 0 < #ix then
				local bFirst = true
				local sql = "insert into prize (uid,type,mykey,create_id) values "
				for i=1,#ix do
					local tmp = helper_activity_prize2mailstring(iUid,iActivityId,ix[i])
					--print("prize:%s\n",tmp)
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
				-- 05 更新level
				if 4 == iErrorCode then
					xlDb_Execute(string.format("insert into activity_check (rid,aid,uid,`level`) values (%d,%d,%d,%d)",iRid,iActivityId,iUid,iCurrentLevel))
				else
					xlDb_Execute(string.format("update activity_check set `level`=%d where uid=%d and aid=%d",iCurrentLevel,iUid,iActivityId))
				end
			end
		end
	end

	g_sNameAward = nil
end

--服务器脚本回调函数
--99号类型的活动发奖
--(按档位充值xx次，如充值98元档1次)
function callback_activity_obtain_prize_ex(iUid,iRid,iActivityId,sPrize,iProgress6,iProgress18,iProgress68,iProgress98,iProgress198,iProgress388)
	--解析奖励物品
	g_sNameAward = {}
	local sAwards = "g_sNameAward = {"..sPrize.."}"
	loadstring(sAwards)()
	
	--print(string.format("prize_99 uid:%d,rid:%d,aid:%d,p6:%d,p18:%d,p45:%d,p68:%d,p98:%d,p198:%d\n",iUid,iRid,iActivityId,iProgress6,iProgress18,iProgress68,iProgress98,iProgress198,iProgress388))

	-- 01 进度表
	local tProgress = {iProgress6,iProgress18,iProgress68,iProgress98,iProgress198,iProgress388}

	-- 02 奖励完成表
	local tPrize = {0,0,0,0,0,0}
	local tPrizeKey = {}
	local bNeedCheck = false
	local tRes = {}
	for i=1,#g_sNameAward do
		if 6 == g_sNameAward[i].money then
			if g_sNameAward[i].rate <= tProgress[1] then tPrize[1] = 1 tPrizeKey[1] = i bNeedCheck = true end
			tRes[#tRes + 1] = tProgress[1]
		elseif 18 == g_sNameAward[i].money then
			if g_sNameAward[i].rate <= tProgress[2] then tPrize[2] = 1 tPrizeKey[2] = i bNeedCheck = true end
			tRes[#tRes + 1] = tProgress[2]
		elseif 68 == g_sNameAward[i].money then
			if g_sNameAward[i].rate <= tProgress[3] then tPrize[3] = 1 tPrizeKey[3] = i bNeedCheck = true end
			tRes[#tRes + 1] = tProgress[3]
		elseif 98 == g_sNameAward[i].money then
			if g_sNameAward[i].rate <= tProgress[4] then tPrize[4] = 1 tPrizeKey[4] = i bNeedCheck = true end
			tRes[#tRes + 1] = tProgress[4]
		elseif 198 == g_sNameAward[i].money then
			if g_sNameAward[i].rate <= tProgress[5] then tPrize[5] = 1 tPrizeKey[5] = i bNeedCheck = true end
			tRes[#tRes + 1] = tProgress[5]
		elseif 388 == g_sNameAward[i].money then
			if g_sNameAward[i].rate <= tProgress[6] then tPrize[6] = 1 tPrizeKey[6] = i bNeedCheck = true end
			tRes[#tRes + 1] = tProgress[6]
		end
	end
	
	-- 获取老的完成表
	local tPrizeOld = {0,0,0,0,0,0}
	local tUpdate = {0,0,0,0,0,0}
	if true == bNeedCheck then
		local iErrorCode = 0
		iErrorCode,tPrizeOld[1],tPrizeOld[2],tPrizeOld[3],tPrizeOld[4],tPrizeOld[5],tPrizeOld[6] = xlDb_Query(string.format("select `lv01`,`lv02`,`lv03`,`lv04`,`lv05`,`lv06` from activity_check where uid=%d and aid=%d limit 1",iUid,iActivityId))
		if 0 == iErrorCode or 4 == iErrorCode then
			-- 获取需要派送的所有奖励
			local ix = {}
			for i=1,6 do
				if 1 == tPrize[i] then
					if 1 ~= tPrizeOld[i] then
						tUpdate[i] = 1
						local pt = g_sNameAward[tPrizeKey[i]].prize
						for j=1,#pt do
							if "table" == type(pt[j]) then
								ix[#ix+1] = pt[j]
							end
						end
					end
				end
			end

			-- 派奖到邮件系统
			if 0 < #ix then
				local bFirst = true
				local sql = "insert into prize (uid,type,mykey,create_id) values "
				for i=1,#ix do
					local tmp = helper_activity_prize2mailstring(iUid,iActivityId,ix[i])
					if tmp then
						if true == bFirst then
							bFirst = false
							sql = sql .. tmp
						else
							sql = sql .. "," .. tmp
						end
					end
				end
				xlDb_Execute(sql)
				-- 05 更新lv
				if 4 == iErrorCode then
					sql = string.format("insert into activity_check (rid,aid,uid,lv01,lv02,lv03,lv04,lv05,lv06) values (%d,%d,%d,%d,%d,%d,%d,%d,%d)",iRid,iActivityId,iUid,tPrize[1],tPrize[2],tPrize[3],tPrize[4],tPrize[5],tPrize[6])
					xlDb_Execute(sql)
				else
					sql = string.format("update activity_check set lv01=%d,lv02=%d,lv03=%d,lv04=%d,lv05=%d,lv06=%d where uid=%d and aid=%d",tPrize[1],tPrize[2],tPrize[3],tPrize[4],tPrize[5],tPrize[6],iUid,iActivityId)
					xlDb_Execute(sql)
				end
			end
		end
	end

	g_sNameAward = nil

	return tRes
end

--服务器脚本回调函数
--101号类型的活动发奖
--(充值暴击)
function callback_activity_obtain_prize_101(iUid,iRid,iActivityId,sPrize,iProgress6,iProgress18,iProgress68,iProgress98,iProgress198,iProgress388)
    --解析奖励物品
	g_sNameAward = {}
	local sAwards = "g_sNameAward = {"..sPrize.."}"
	loadstring(sAwards)()
	
	--print(string.format("prize_101 uid:%d,rid:%d,aid:%d,p6:%d,p18:%d,p45:%d,p68:%d,p98:%d,p198:%d\n",iUid,iRid,iActivityId,iProgress6,iProgress18,iProgress68,iProgress98,iProgress198,iProgress388))

	-- 01 进度表
	local tProgress = {iProgress6,iProgress18,iProgress68,iProgress98,iProgress198,iProgress388}

	-- 02 奖励完成表
	local tPrize = {0,0,0,0,0,0}
	local tPrizeKey = 0
	local bNeedCheck = false
	local tRes = {}
	for i=1,#g_sNameAward do
		if 6 == g_sNameAward[i].money then
			if g_sNameAward[i].rate <= tProgress[1] then tPrize[1] = 1 tPrizeKey = i bNeedCheck = true end
			tRes[#tRes + 1] = tProgress[1]
		elseif 18 == g_sNameAward[i].money then
			if g_sNameAward[i].rate <= tProgress[2] then tPrize[2] = 1 tPrizeKey = i bNeedCheck = true end
			tRes[#tRes + 1] = tProgress[2]
		elseif 68 == g_sNameAward[i].money then
			if g_sNameAward[i].rate <= tProgress[3] then tPrize[3] = 1 tPrizeKey = i bNeedCheck = true end
			tRes[#tRes + 1] = tProgress[3]
		elseif 98 == g_sNameAward[i].money then
			if g_sNameAward[i].rate <= tProgress[4] then tPrize[4] = 1 tPrizeKey = i bNeedCheck = true end
			tRes[#tRes + 1] = tProgress[4]
		elseif 198 == g_sNameAward[i].money then
			if g_sNameAward[i].rate <= tProgress[5] then tPrize[5] = 1 tPrizeKey = i bNeedCheck = true end
			tRes[#tRes + 1] = tProgress[5]
		elseif 388 == g_sNameAward[i].money then
			if g_sNameAward[i].rate <= tProgress[6] then tPrize[6] = 1 tPrizeKey = i bNeedCheck = true end
			tRes[#tRes + 1] = tProgress[6]
		end
	end
	
	-- 获取老的完成表
	if true == bNeedCheck then
        local tPrizeOld = {0,0,0,0,0,0}
        local iErrorCode = 0
        iErrorCode,tPrizeOld[1],tPrizeOld[2],tPrizeOld[3],tPrizeOld[4],tPrizeOld[5],tPrizeOld[6] = xlDb_Query(string.format("select `lv01`,`lv02`,`lv03`,`lv04`,`lv05`,`lv06` from activity_check where uid=%d and aid=%d limit 1",iUid,iActivityId))
        if 0 == iErrorCode or 4 == iErrorCode then
            if 1 == tPrizeOld[1] or 1 == tPrizeOld[2] or 1 == tPrizeOld[3] or 1 == tPrizeOld[4] or 1 == tPrizeOld[5] or 1 == tPrizeOld[6] then return tPrizeOld end

            for i=1,6 do
                if 1 == tRes[i] then
			local pt = g_sNameAward[tPrizeKey].prize
			local ix = {}
			for j=1,#pt do
				if "table" == type(pt[j]) then
					ix[#ix+1] = pt[j]
				end
			end

			if 0 < #ix then
				local bFirst = true
				local sql = "insert into prize (uid,type,mykey,create_id) values "
				for i=1,#ix do
					local tmp = helper_activity_prize2mailstring(iUid,iActivityId,ix[i])
					if tmp then
					if true == bFirst then
						bFirst = false
						sql = sql .. tmp
					else
						sql = sql .. "," .. tmp
					end
				end
				xlDb_Execute(sql)
			end
		end
		-- 05 更新lv
		if 4 == iErrorCode then
			xlDb_Execute(string.format("insert into activity_check (rid,aid,uid,lv01,lv02,lv03,lv04,lv05,lv06) values (%d,%d,%d,%d,%d,%d,%d,%d,%d)",iRid,iActivityId,iUid,tRes[1],tRes[2],tRes[3],tRes[4],tRes[5],tRes[6]))
		else
			xlDb_Execute(string.format("update activity_check set lv01=%d,lv02=%d,lv03=%d,lv04=%d,lv05=%d,lv06=%d where uid=%d and aid=%d",tRes[1],tRes[2],tRes[3],tRes[4],tRes[5],tRes[6],iUid,iActivityId))
		end
		
		return tRes
		
		end
            end
        end
	end

	g_sNameAward = nil

	return tRes
end

--服务器脚本回调函数
--102号类型的活动发奖
function callback_activity_obtain_prize_102(iUid,iRid,iActivityId,iOrder,sPrize)
    --解析奖励物品
    g_sNameAward = {}
    local sAwards = "g_sNameAward = {"..sPrize.."}"
    loadstring(sAwards)()

    local pt = g_sNameAward[1].prize
    local ix = {}
    for j=1,#pt do
        if "table" == type(pt[j]) then
            ix[#ix+1] = pt[j]
        end
    end

    if 0 < #ix then
        local bFirst = true
        local sql = "insert into prize (uid,type,mykey,create_id) values "
        for i=1,#ix do
            local tmp = helper_activity_prize2mailstring(iUid,iActivityId,ix[i])
            if tmp then
                if true == bFirst then
                    bFirst = false
                    sql = sql .. tmp
                else
                    sql = sql .. "," .. tmp
                end
            end
        end
        xlDb_Execute(sql)
    end
end

function callback_special_obtain_prize(iUid,iRid,iTaskId,iPower,iProgress,iPrizeId,sPrize)
    -- iPrizeId 表示第几天奖励
    if iPrizeId <= iProgress then
        --加载奖励物品
        g_sNameAward = {}
        local sAwards = "g_sNameAward = {"..sPrize.."}"
        loadstring(sAwards)()

        --直接拿iPrizeId为索引的奖励信息并且给奖励
        local pt = g_sNameAward[iPrizeId].prize
        local ix = {}
        for j=1,#pt do
            if "table" == type(pt[j]) then
                -- cn
                if pt[j].type == "cn" then
                    local num = pt[j].num * iPower
                    -- t_user
                    local sql = string.format("update t_user set gamecoin_online = gamecoin_online + %d where uid = %d",num,iUid)
                    local log = string.format("insert into prize (uid,type,mykey,used,create_id) values (%d,%d,%d,%d,%d)",iUid,400,num,2,iTaskId)
                    xlDb_Execute(sql)
                    xlDb_Execute(log)
                elseif pt[j].type == "ix" then -- t_cha
                    if pt[j].id == 30 or pt[j].id == 9004 or pt[j].id == 9005 or pt[j].id == 9006 or (9300 <= pt[j].id and pt[j].id <= 9320) or pt[j].id == 9999 then
                        ix[#ix+1] = {}
                        ix[#ix].id = pt[j].id
                        ix[#ix].num = pt[j].num * iPower
                    end
                end
            end
		end

        -- t_cha
        if 0 < #ix then
            local sql = "update t_cha set "
            local logvii = "insert  into log_vii(uid,rid,type,num,traceid) values "
            for i=1,#ix do
                local name = ""
                if 30 == ix[i].id then name = "material_red" end
                if 9004 == ix[i].id then name = "chest_cuprum" end
                if 9005 == ix[i].id then name = "chest_silver" end
                if 9006 == ix[i].id then name = "chest_gold" end
                if 9999 == ix[i].id then name = "prize_code" end
                if 9300 <= ix[i].id and ix[i].id <= 9320 then
                    name = "ext_op" .. tostring(ix[i].id)
                end
                local tmp = string.format("%s=%s+%d",name,name,ix[i].num)
                if 1 == i then
                    sql = sql .. tmp
                else
                    sql = sql .. "," .. tmp
                    logvii = logvii .. ","
                end
                logvii = logvii .. string.format("(%d,%d,%d,%d,%d)",iUid,iRid,ix[i].id,ix[i].num,iTaskId)
            end
            sql = sql .. string.format(" where uid = %d and id = %d",iUid,iRid)
            logvii = logvii .. ";"
            xlDb_Execute(sql)
            xlDb_Execute(logvii)
        end

        -- update flag
        local sql = string.format("update activity_dispatch set prize_%02d=1 where id = %d",iPrizeId,iTaskId)
        xlDb_Execute(sql)

        g_sNameAward = nil
    end
end

function helper_adv_prize2mailstring(uid,rid,advid,prize)
    local sMailString = nil
	if "cn" == prize.type then
		sMailString = string.format("(%d,%d,%d,\'c:%d;\',%d)",uid,rid,10000,prize.num,advid)
	elseif "sc" == prize.type then
		sMailString = string.format("(%d,%d,%d,\'s:%d;\',%d)",uid,rid,10000,prize.num,advid)
	elseif "ix" == prize.type then
		if 9108 == prize.id then
			sMailString = string.format("(%d,%d,%d,\'%s\',%d)",uid,rid,7000,prize.detail,advid)
        elseif 9997 == prize.id then
            sMailString = string.format("(%d,%d,\'%s\',%d)",uid,9997,prize.detail,aid)
		else
			sMailString = string.format("(%d,%d,%d,\'%d\',%d)",uid,rid,prize.id,prize.num,advid)
		end
	elseif "tc" == prize.type then
		local sMyKey = string.format("bfs:%dlv:%dn:%d",prize.id,prize.level,prize.num)
		sMailString = string.format("(%d,%d,%d,\'%s\',%d)",uid,rid,7,sMyKey,advid)
	elseif "it" == prize.type then
		if 29 == prize.id or 30 == prize.id or 31 == prize.id then
			local sMyKey = string.format("i:%dn:%d",prize.id,prize.num)
			sMailString = string.format("(%d,%d,%d,\'%s\',%d)",uid,rid,6,sMyKey,advid)
		elseif 9004 == prize.id or 9005 == prize.id or 9006 == prize.id then
			sMailString = string.format("(%d,%d,%d,\'%d\',%d)",uid,rid,prize.id,prize.num,advid)
		else
			local hole = prize.hole or 1
			local sMyKey = string.format("i:%dn:%dh:%d",prize.id,prize.num,hole)
			sMailString = string.format("(%d,%d,%d,\'%s\',%d)",uid,rid,4,sMyKey,advid)
		end
    end
    return sMailString
end

function callback_adv_obtain_prize(iAdvId)
    local res = "0"
    local iErrorCode,iRid,iUid,iType,iCount,iLevel,sPrize = xlDb_Query(string.format("select `rid`,`uid`,`type`,`count`,`level`,`prize` from adv_dispatch where id = %d",iAdvId))
    if 0 == iErrorCode then
        --00 add count
        iCount = iCount + 1
        --01 load prize
        g_sNameAward = {}
        local sAwards = "g_sNameAward = {"..sPrize.."}"
        loadstring(sAwards)()
        --02 按照type给奖励
        if 1 == iType then
            local idx = 0
            for i=iLevel + 1,#g_sNameAward do
                if g_sNameAward[i].rate <= iCount then idx = i end
            end
            if 0 < idx then
                res = "1"
                local pt = g_sNameAward[idx].prize
                local ix = {}
                for j=1,#pt do
                    if "table" == type(pt[j]) then ix[#ix+1] = pt[j] end
                end
                local bFirst = true
                local sql = "insert into prize (uid,rid,type,mykey,create_id) values "
                for i=1,#ix do
                    local tmp = helper_adv_prize2mailstring(iUid,iRid,iAdvId,ix[i])
					if tmp then
					    if true == bFirst then bFirst = false sql = sql .. tmp end
					else
						sql = sql .. "," .. tmp
					end
                end
                xlDb_Execute(sql)
            end
            if iLevel < idx then iLevel = idx end
            sql = string.format("update adv_dispatch set `count`=%d,`level`=%d,`time_watching`= NOW() where id = %d",iCount,iLevel,iAdvId)
            xlDb_Execute(sql)
        end
    end

    return res
end

function callback_vip_dayly_prize(iUid,iRid,iVipLevel)
    local iErrorCode,sPrize = xlDb_Query(string.format("select dalyprize from t_vip_config where vip_level = %d",iVipLevel))
    if 0 == iErrorCode then
        -- 01 laodprize
        g_sNameAward = {}
        local sAwards = "g_sNameAward = {"..sPrize.."}"
        loadstring(sAwards)()
        -- 02
        local ix = {}
        for i=1,#g_sNameAward do
            if g_sNameAward[i].type == "cn" then -- coin
                local num = g_sNameAward[i].num
                -- t_user
                local sql = string.format("update t_user set gamecoin_online = gamecoin_online + %d where uid = %d",num,iUid)
                --local log = string.format("insert into prize (uid,type,mykey,used,create_id) values (%d,%d,%d,%d,%d)",iUid,400,num,2,iTaskId)
                xlDb_Execute(sql)
                --xlDb_Execute(log)
            elseif g_sNameAward[i].type == "ix" then -- t_cha
                if g_sNameAward[i].id == 30 or g_sNameAward[i].id == 9004 or g_sNameAward[i].id == 9005 or g_sNameAward[i].id == 9006 or (9300 <= g_sNameAward[i].id and g_sNameAward[i].id <= 9320) or g_sNameAward[i].id == 9999 then
                    ix[#ix+1] = {}
                    ix[#ix].id = g_sNameAward[i].id
                    ix[#ix].num = g_sNameAward[i].num
                end
            end
        end
        -- t_cha
        if 0 < #ix then
            local sql = "update t_cha set "
            --local logvii = "insert  into log_vii(uid,rid,type,num,traceid) values "
            for i=1,#ix do
                local name = ""
                if 30 == ix[i].id then name = "material_red" end
                if 9004 == ix[i].id then name = "chest_cuprum" end
                if 9005 == ix[i].id then name = "chest_silver" end
                if 9006 == ix[i].id then name = "chest_gold" end
                if 9999 == ix[i].id then name = "prize_code" end
                if 9300 <= ix[i].id and ix[i].id <= 9320 then
                    name = "ext_op" .. tostring(ix[i].id)
                end
                local tmp = string.format("%s=%s+%d",name,name,ix[i].num)
                if 1 == i then
                    sql = sql .. tmp
                else
                    sql = sql .. "," .. tmp
                    --logvii = logvii .. ","
                end
                --logvii = logvii .. string.format("(%d,%d,%d,%d,%d)",iUid,iRid,ix[i].id,ix[i].num,iTaskId)
            end
            sql = sql .. string.format(" where uid = %d and id = %d",iUid,iRid)
            --logvii = logvii .. ";"
            xlDb_Execute(sql)
            --xlDb_Execute(logvii)
        end

        -- update flag
        --local sql = string.format("insert into t_vip_prize (uid) values (%d)",iUid)
        --xlDb_Execute(sql)

        g_sNameAward = nil
    end
end

--服务器脚本回调函数
--10000+号类型的活动发奖
function callback_activity_obtain_prize_custom(iUid,iRid,iActivityType,iActivityId,sPrize)
	-- 必须返回一个数字表示进度
	local iProgress = 0

	local sql
	local progress = 0
	
	
	if iActivityType == 10000 then --10000显示夺塔奇兵开放时间
		--
	elseif iActivityType == 10001 then --10001夺塔奇兵所有正常局
		sql = string.format("SELECT COUNT(*) FROM t_pvp_user_session AS us INNER JOIN t_pvp_session AS s ON us.sid = s.id INNER JOIN activity_template AS a ON s.create_time>=a.time_begin AND s.create_time<=a.time_end WHERE us.uid=%d AND us.id=%d AND a.aid=%d AND s.game_cfgId=1 AND s.game_result >= 0 AND us.resultType>=0",iUid,iRid,iActivityId)
	elseif iActivityType == 10002 then --10002夺塔奇兵所有胜局
		sql = string.format("SELECT COUNT(*) FROM t_pvp_user_session AS us INNER JOIN t_pvp_session AS s ON us.sid = s.id INNER JOIN activity_template AS a ON s.create_time>=a.time_begin AND s.create_time<=a.time_end WHERE us.uid=%d AND us.id=%d AND a.aid=%d AND s.game_cfgId=1 AND s.game_result >= 0 AND us.resultType=0",iUid,iRid,iActivityId)
	elseif iActivityType == 10003 then --10003夺塔奇兵电脑正常局
		sql = string.format("SELECT COUNT(*) FROM t_pvp_user_session AS us INNER JOIN t_pvp_session AS s ON us.sid = s.id INNER JOIN activity_template AS a ON s.create_time>=a.time_begin AND s.create_time<=a.time_end WHERE us.uid=%d AND us.id=%d AND a.aid=%d AND s.game_cfgId=1 AND s.game_result >= 0 AND us.resultType>=0 AND s.game_type=2",iUid,iRid,iActivityId)
	elseif iActivityType == 10004 then --10004夺塔奇兵对人正常局
		sql = string.format("SELECT COUNT(*) FROM t_pvp_user_session AS us INNER JOIN t_pvp_session AS s ON us.sid = s.id INNER JOIN activity_template AS a ON s.create_time>=a.time_begin AND s.create_time<=a.time_end WHERE us.uid=%d AND us.id=%d AND a.aid=%d AND s.game_cfgId=1 AND s.game_result >= 0 AND us.resultType>=0 AND s.game_type=1",iUid,iRid,iActivityId)
	elseif iActivityType == 10005 then --10005夺塔奇兵对人胜局
		sql = string.format("SELECT COUNT(*) FROM t_pvp_user_session AS us INNER JOIN t_pvp_session AS s ON us.sid = s.id INNER JOIN activity_template AS a ON s.create_time>=a.time_begin AND s.create_time<=a.time_end WHERE us.uid=%d AND us.id=%d AND a.aid=%d AND s.game_cfgId=1 AND s.game_result >= 0 AND us.resultType=0 AND s.game_type=1",iUid,iRid,iActivityId)
	elseif iActivityType == 10006 then --10006夺塔奇兵对困难电脑胜局
		sql = string.format("SELECT COUNT(*) FROM t_pvp_user_session AS us INNER JOIN t_pvp_session AS s ON us.sid = s.id INNER JOIN activity_template AS a ON s.create_time>=a.time_begin AND s.create_time<=a.time_end WHERE us.uid=%d AND us.id=%d AND a.aid=%d AND s.game_cfgId=1 AND s.game_result >= 0 AND us.resultType>=0 AND s.game_type=2 AND s.player_info LIKE \'%%computer_4%%\'",iUid,iRid,iActivityId)
	elseif iActivityType == 10007 then --10007夺塔奇兵对人局累计获得星星评价
		sql = string.format("SELECT SUM(us.evaluate_point) FROM t_pvp_user_session AS us INNER JOIN t_pvp_session AS s ON us.sid = s.id INNER JOIN activity_template AS a ON s.create_time>=a.time_begin AND s.create_time<=a.time_end WHERE us.uid=%d AND us.id=%d AND a.aid=%d AND s.game_cfgId=1 AND s.game_result >= 0 AND us.resultType>=0 AND s.game_type=1",iUid,iRid,iActivityId)
	elseif iActivityType == 10008 then --10008夺塔奇兵新人特别奖
		--sql = string.format("SELECT COUNT(*) FROM `order` AS o INNER JOIN activity_template AS a ON o.time_begin>=a.time_begin AND o.time_begin<=a.time_end AND o.uid = %d AND o.itemid >= 9914 AND o.itemid <= 9915 AND a.aid=%d",iUid,iActivityId)
		sql = string.format("SELECT `silvercount` + `goldcount` FROM `t_pvp_user` where `id` = %d", iRid)
	elseif iActivityType == 10009 then --10009夺塔奇兵锦囊掉落数量双倍
	elseif iActivityType == 10010 then --10010夺塔奇兵匹配房所有正常局
		sql = string.format("SELECT COUNT(*) FROM t_pvp_user_session AS us INNER JOIN t_pvp_session AS s ON us.sid = s.id INNER JOIN activity_template AS a ON s.create_time>=a.time_begin AND s.create_time<=a.time_end WHERE us.uid=%d AND us.id=%d AND a.aid=%d AND s.game_cfgId=4 AND s.game_result >= 0 AND us.resultType>=0",iUid,iRid,iActivityId)
	elseif iActivityType == 10011 then --10011夺塔奇兵匹配房每日所有正常局ex
		--修正activity_check表中的数据
		local err0,level,lv01 = xlDb_Query(string.format("SELECT `level`,`lv01` FROM activity_check WHERE uid=%d AND aid=%d LIMIT 1",iUid,iActivityId))
		if 0 == err0 or 4 == err0 then
			level = level or 0
			lv01 = lv01 or 0
			
			local err1,day1,day2 = xlDb_Query(string.format("SELECT (SELECT TO_DAYS(NOW()) - TO_DAYS(`time_begin`)) AS day1, (TO_DAYS(`time_end`) - TO_DAYS(NOW())) AS day2 FROM activity_template WHERE `aid`=%d AND NOW()>=`time_begin` AND NOW()<=`time_end`",iActivityId)) 
			--查询当前时间与时间的间隔天数
			if err1 == 0 then
				
				if lv01 < day1 then
					lv01 = day1
					level = 0
				end
				
				-- 更新level
				if 4 == err0 then
					xlDb_Execute(string.format("insert into activity_check (rid,aid,uid) values (%d,%d,%d)",iRid,iActivityId,iUid))
				else
					xlDb_Execute(string.format("update activity_check set `level`=%d, `lv01`=%d where uid=%d and aid=%d",level,lv01,iUid,iActivityId))
				end
				
				sql = string.format("SELECT COUNT(*) FROM t_pvp_user_session AS us INNER JOIN t_pvp_session AS s ON us.sid = s.id INNER JOIN activity_template AS a ON s.create_time>=a.time_begin AND s.create_time<=a.time_end WHERE us.uid=%d AND us.id=%d AND a.aid=%d AND s.game_cfgId=4 AND s.game_result >= 0 AND us.resultType>=0 AND DATE(s.create_time)=CURDATE()",iUid,iRid,iActivityId)
			end
		end
	elseif iActivityType == 10012 then --10012魔龙宝库每日正常局胜利ex
		--修正activity_check表中的数据
		local err0,level,lv01 = xlDb_Query(string.format("SELECT `level`,`lv01` FROM activity_check WHERE uid=%d AND aid=%d LIMIT 1",iUid,iActivityId))
		if 0 == err0 or 4 == err0 then
			level = level or 0
			lv01 = lv01 or 0
			
			local err1,day1,day2 = xlDb_Query(string.format("SELECT (SELECT TO_DAYS(NOW()) - TO_DAYS(`time_begin`)) AS day1, (TO_DAYS(`time_end`) - TO_DAYS(NOW())) AS day2 FROM activity_template WHERE `aid`=%d AND NOW()>=`time_begin` AND NOW()<=`time_end`",iActivityId)) 
			--查询当前时间与时间的间隔天数
			if err1 == 0 then
				
				if lv01 < day1 then
					lv01 = day1
					level = 0
				end
				
				-- 更新level
				if 4 == err0 then
					xlDb_Execute(string.format("insert into activity_check (rid,aid,uid) values (%d,%d,%d)",iRid,iActivityId,iUid))
				else
					xlDb_Execute(string.format("update activity_check set `level`=%d, `lv01`=%d where uid=%d and aid=%d",level,lv01,iUid,iActivityId))
				end
				
				sql = string.format("SELECT COUNT(*) FROM t_pvp_user_session AS us INNER JOIN t_pvp_session AS s ON us.sid = s.id INNER JOIN activity_template AS a ON s.create_time>=a.time_begin AND s.create_time<=a.time_end WHERE us.uid=%d AND us.id=%d AND a.aid=%d AND s.game_cfgId=2 AND s.game_result = 1 AND us.resultType>=0 AND DATE(s.create_time)=CURDATE()",iUid,iRid,iActivityId)
			end
		end
	elseif iActivityType == 10013 then --10013铜雀台每日正常局胜利ex
		--修正activity_check表中的数据
		local err0,level,lv01 = xlDb_Query(string.format("SELECT `level`,`lv01` FROM activity_check WHERE uid=%d AND aid=%d LIMIT 1",iUid,iActivityId))
		if 0 == err0 or 4 == err0 then
			level = level or 0
			lv01 = lv01 or 0
			
			local err1,day1,day2 = xlDb_Query(string.format("SELECT (SELECT TO_DAYS(NOW()) - TO_DAYS(`time_begin`)) AS day1, (TO_DAYS(`time_end`) - TO_DAYS(NOW())) AS day2 FROM activity_template WHERE `aid`=%d AND NOW()>=`time_begin` AND NOW()<=`time_end`",iActivityId)) 
			--查询当前时间与时间的间隔天数
			if err1 == 0 then
				
				if lv01 < day1 then
					lv01 = day1
					level = 0
				end
				
				-- 更新level
				if 4 == err0 then
					xlDb_Execute(string.format("insert into activity_check (rid,aid,uid) values (%d,%d,%d)",iRid,iActivityId,iUid))
				else
					xlDb_Execute(string.format("update activity_check set `level`=%d, `lv01`=%d where uid=%d and aid=%d",level,lv01,iUid,iActivityId))
				end
				
				sql = string.format("SELECT COUNT(*) FROM t_pvp_user_session AS us INNER JOIN t_pvp_session AS s ON us.sid = s.id INNER JOIN activity_template AS a ON s.create_time>=a.time_begin AND s.create_time<=a.time_end WHERE us.uid=%d AND us.id=%d AND a.aid=%d AND s.game_cfgId=3 AND s.game_result = 1 AND us.resultType>=0 AND DATE(s.create_time)=CURDATE()",iUid,iRid,iActivityId)
			end
		end
	elseif iActivityType == 10014 then --10014军团宝库每日正常局胜利ex
		--修正activity_check表中的数据
		local err0,level,lv01 = xlDb_Query(string.format("SELECT `level`,`lv01` FROM activity_check WHERE uid=%d AND aid=%d LIMIT 1",iUid,iActivityId))
		if 0 == err0 or 4 == err0 then
			level = level or 0
			lv01 = lv01 or 0
			
			local err1,day1,day2 = xlDb_Query(string.format("SELECT (SELECT TO_DAYS(NOW()) - TO_DAYS(`time_begin`)) AS day1, (TO_DAYS(`time_end`) - TO_DAYS(NOW())) AS day2 FROM activity_template WHERE `aid`=%d AND NOW()>=`time_begin` AND NOW()<=`time_end`",iActivityId)) 
			--查询当前时间与时间的间隔天数
			if err1 == 0 then
				
				if lv01 < day1 then
					lv01 = day1
					level = 0
				end
				
				-- 更新level
				if 4 == err0 then
					xlDb_Execute(string.format("insert into activity_check (rid,aid,uid) values (%d,%d,%d)",iRid,iActivityId,iUid))
				else
					xlDb_Execute(string.format("update activity_check set `level`=%d, `lv01`=%d where uid=%d and aid=%d",level,lv01,iUid,iActivityId))
				end
				
				sql = string.format("SELECT COUNT(*) FROM t_pvp_user_session AS us INNER JOIN t_pvp_session AS s ON us.sid = s.id INNER JOIN activity_template AS a ON s.create_time>=a.time_begin AND s.create_time<=a.time_end WHERE us.uid=%d AND us.id=%d AND a.aid=%d AND s.game_cfgId=8 AND s.game_result = 1 AND us.resultType>=0 AND DATE(s.create_time)=CURDATE()",iUid,iRid,iActivityId)
			end
		end
	elseif iActivityType == 10020 then --10020仅苹果玩家可见的文字展示类活动
		--
	elseif iActivityType == 10021 then --10021仅安卓玩家可见的文字展示类活动
		--
	elseif iActivityType == 10022 then --10022新用户七日签到活动
		sql = string.format("SELECT `level` from `activity_check` where `uid` = %d and `rid` = %d and `aid`= %d limit 1", iUid, iRid, iActivityId)
	elseif iActivityType == 10023 then --10023 1元档活动开关标记
		--
	elseif iActivityType == 10024 then --10024 消费转盘活动
		--
	elseif iActivityType == 10025 then --10025 连续七天充值活动
		--
	elseif iActivityType == 10026 then --10026 taptap留言活动
		--
	elseif iActivityType == 10027 then --10027 军团连续活跃活动
		--
	elseif iActivityType == 10028 then --10028 人族无敌挑战活动ex
		--修正activity_check表中的数据
		local err0,level,lv01 = xlDb_Query(string.format("SELECT `level`,`lv01` FROM activity_check WHERE uid=%d AND aid=%d LIMIT 1",iUid,iActivityId))
		if 0 == err0 or 4 == err0 then
			level = level or 0
			lv01 = lv01 or 0
			
			local err1,day1,day2 = xlDb_Query(string.format("SELECT (SELECT TO_DAYS(NOW()) - TO_DAYS(`time_begin`)) AS day1, (TO_DAYS(`time_end`) - TO_DAYS(NOW())) AS day2 FROM activity_template WHERE `aid`=%d AND NOW()>=`time_begin` AND NOW()<=`time_end`",iActivityId)) 
			--查询当前时间与时间的间隔天数
			if err1 == 0 then
				
				if lv01 < day1 then
					lv01 = day1
					level = 0
				end
				
				-- 更新level
				if 4 == err0 then
					xlDb_Execute(string.format("insert into activity_check (rid,aid,uid) values (%d,%d,%d)",iRid,iActivityId,iUid))
				else
					xlDb_Execute(string.format("update activity_check set `level`=%d, `lv01`=%d where uid=%d and aid=%d",level,lv01,iUid,iActivityId))
				end
				
				sql = string.format("SELECT MAX(`wave`) FROM `t_pvp_session` AS s INNER JOIN `t_pvp_user_session` AS us ON us.sid = s.id INNER JOIN activity_template AS a ON s.create_time>=a.time_begin AND s.create_time<=a.time_end WHERE us.uid=%d AND us.id=%d AND a.aid=%d AND s.game_cfgId = 10 AND s.game_result >= 0 AND us.resultType>=0 AND DATE(s.create_time)=CURDATE()",iUid,iRid,iActivityId)
				--print(sql)
			end
		end
	elseif iActivityType == 10029 then --10029 守卫剑阁挑战活动ex
		--修正activity_check表中的数据
		local err0,level,lv01 = xlDb_Query(string.format("SELECT `level`,`lv01` FROM activity_check WHERE uid=%d AND aid=%d LIMIT 1",iUid,iActivityId))
		if 0 == err0 or 4 == err0 then
			level = level or 0
			lv01 = lv01 or 0
			
			local err1,day1,day2 = xlDb_Query(string.format("SELECT (SELECT TO_DAYS(NOW()) - TO_DAYS(`time_begin`)) AS day1, (TO_DAYS(`time_end`) - TO_DAYS(NOW())) AS day2 FROM activity_template WHERE `aid`=%d AND NOW()>=`time_begin` AND NOW()<=`time_end`",iActivityId)) 
			--查询当前时间与时间的间隔天数
			if err1 == 0 then
				
				if lv01 < day1 then
					lv01 = day1
					level = 0
				end
				
				-- 更新level
				if 4 == err0 then
					xlDb_Execute(string.format("insert into activity_check (rid,aid,uid) values (%d,%d,%d)",iRid,iActivityId,iUid))
				else
					xlDb_Execute(string.format("update activity_check set `level`=%d, `lv01`=%d where uid=%d and aid=%d",level,lv01,iUid,iActivityId))
				end
				
				sql = string.format("SELECT MAX(`wave`) FROM `t_pvp_session` AS s INNER JOIN `t_pvp_user_session` AS us ON us.sid = s.id INNER JOIN activity_template AS a ON s.create_time>=a.time_begin AND s.create_time<=a.time_end WHERE us.uid=%d AND us.id=%d AND a.aid=%d AND (s.game_cfgId = 12 or s.game_cfgId = 13) AND s.game_result >= 0 AND us.resultType>=0 AND DATE(s.create_time)=CURDATE()",iUid,iRid,iActivityId)
				--print(sql)
			end
		end
	elseif iActivityType == 10030 then --10030 消费抽奖活动
		--
	elseif iActivityType == 10031 then --10031 双人守卫剑阁挑战活动ex
		--修正activity_check表中的数据
		local err0,level,lv01 = xlDb_Query(string.format("SELECT `level`,`lv01` FROM activity_check WHERE uid=%d AND aid=%d LIMIT 1",iUid,iActivityId))
		if 0 == err0 or 4 == err0 then
			level = level or 0
			lv01 = lv01 or 0
			
			local err1,day1,day2 = xlDb_Query(string.format("SELECT (SELECT TO_DAYS(NOW()) - TO_DAYS(`time_begin`)) AS day1, (TO_DAYS(`time_end`) - TO_DAYS(NOW())) AS day2 FROM activity_template WHERE `aid`=%d AND NOW()>=`time_begin` AND NOW()<=`time_end`",iActivityId)) 
			--查询当前时间与时间的间隔天数
			if err1 == 0 then
				
				if lv01 < day1 then
					lv01 = day1
					level = 0
				end
				
				-- 更新level
				if 4 == err0 then
					xlDb_Execute(string.format("insert into activity_check (rid,aid,uid) values (%d,%d,%d)",iRid,iActivityId,iUid))
				else
					xlDb_Execute(string.format("update activity_check set `level`=%d, `lv01`=%d where uid=%d and aid=%d",level,lv01,iUid,iActivityId))
				end
				
				sql = string.format("SELECT MAX(`wave`) FROM `t_pvp_session` AS s INNER JOIN `t_pvp_user_session` AS us ON us.sid = s.id INNER JOIN activity_template AS a ON s.create_time>=a.time_begin AND s.create_time<=a.time_end WHERE us.uid=%d AND us.id=%d AND a.aid=%d AND s.game_cfgId = 13 AND s.game_result >= 0 AND us.resultType>=0 AND DATE(s.create_time)=CURDATE()",iUid,iRid,iActivityId)
				--print(sql)
			end
		end
	elseif iActivityType == 10032 then --10032 新用户任意充值活动
		--
	elseif iActivityType == 10033 then --10033群英阁每日正常局胜利ex
		--修正activity_check表中的数据
		local err0,level,lv01 = xlDb_Query(string.format("SELECT `level`,`lv01` FROM activity_check WHERE uid=%d AND aid=%d LIMIT 1",iUid,iActivityId))
		if 0 == err0 or 4 == err0 then
			level = level or 0
			lv01 = lv01 or 0
			
			local err1,day1,day2 = xlDb_Query(string.format("SELECT (SELECT TO_DAYS(NOW()) - TO_DAYS(`time_begin`)) AS day1, (TO_DAYS(`time_end`) - TO_DAYS(NOW())) AS day2 FROM activity_template WHERE `aid`=%d AND NOW()>=`time_begin` AND NOW()<=`time_end`",iActivityId)) 
			--查询当前时间与时间的间隔天数
			if err1 == 0 then
				
				if lv01 < day1 then
					lv01 = day1
					level = 0
				end
				
				-- 更新level
				if 4 == err0 then
					xlDb_Execute(string.format("insert into activity_check (rid,aid,uid) values (%d,%d,%d)",iRid,iActivityId,iUid))
				else
					xlDb_Execute(string.format("update activity_check set `level`=%d, `lv01`=%d where uid=%d and aid=%d",level,lv01,iUid,iActivityId))
				end
				
				sql = string.format("SELECT COUNT(*) FROM `log_qunyingge_battleconfig` AS ql, `activity_template` AS a WHERE ql.time_begin>=a.time_begin AND ql.time_begin<=a.time_end AND ql.uid=%d AND ql.rid=%d AND a.aid=%d AND ql.result = 1 AND DATE(ql.time_begin)=CURDATE()",iUid,iRid,iActivityId)
			end
		end
	elseif iActivityType == 10034 then --10034魔塔杀阵每日正常局胜利ex
		--修正activity_check表中的数据
		local err0,level,lv01 = xlDb_Query(string.format("SELECT `level`,`lv01` FROM activity_check WHERE uid=%d AND aid=%d LIMIT 1",iUid,iActivityId))
		if 0 == err0 or 4 == err0 then
			level = level or 0
			lv01 = lv01 or 0
			
			local err1,day1,day2 = xlDb_Query(string.format("SELECT (SELECT TO_DAYS(NOW()) - TO_DAYS(`time_begin`)) AS day1, (TO_DAYS(`time_end`) - TO_DAYS(NOW())) AS day2 FROM activity_template WHERE `aid`=%d AND NOW()>=`time_begin` AND NOW()<=`time_end`",iActivityId)) 
			--查询当前时间与时间的间隔天数
			if err1 == 0 then
				
				if lv01 < day1 then
					lv01 = day1
					level = 0
				end
				
				-- 更新level
				if 4 == err0 then
					xlDb_Execute(string.format("insert into activity_check (rid,aid,uid) values (%d,%d,%d)",iRid,iActivityId,iUid))
				else
					xlDb_Execute(string.format("update activity_check set `level`=%d, `lv01`=%d where uid=%d and aid=%d",level,lv01,iUid,iActivityId))
				end
				
				sql = string.format("SELECT COUNT(*) FROM t_pvp_user_session AS us INNER JOIN t_pvp_session AS s ON us.sid = s.id INNER JOIN activity_template AS a ON s.create_time>=a.time_begin AND s.create_time<=a.time_end WHERE us.uid=%d AND us.id=%d AND a.aid=%d AND s.game_cfgId=11 AND s.game_result = 1 AND us.resultType>=0 AND DATE(s.create_time)=CURDATE()",iUid,iRid,iActivityId)
			end
		end
	elseif iActivityType == 10035 then --10035 决战虚鲲挑战活动ex
		--修正activity_check表中的数据
		local err0,level,lv01 = xlDb_Query(string.format("SELECT `level`,`lv01` FROM activity_check WHERE uid=%d AND aid=%d LIMIT 1",iUid,iActivityId))
		if 0 == err0 or 4 == err0 then
			level = level or 0
			lv01 = lv01 or 0
			
			local err1,day1,day2 = xlDb_Query(string.format("SELECT (SELECT TO_DAYS(NOW()) - TO_DAYS(`time_begin`)) AS day1, (TO_DAYS(`time_end`) - TO_DAYS(NOW())) AS day2 FROM activity_template WHERE `aid`=%d AND NOW()>=`time_begin` AND NOW()<=`time_end`",iActivityId)) 
			--查询当前时间与时间的间隔天数
			if err1 == 0 then
				
				if lv01 < day1 then
					lv01 = day1
					level = 0
				end
				
				-- 更新level
				if 4 == err0 then
					xlDb_Execute(string.format("insert into activity_check (rid,aid,uid) values (%d,%d,%d)",iRid,iActivityId,iUid))
				else
					xlDb_Execute(string.format("update activity_check set `level`=%d, `lv01`=%d where uid=%d and aid=%d",level,lv01,iUid,iActivityId))
				end
				
				sql = string.format("SELECT MAX(`wave`) FROM `t_pvp_session` AS s INNER JOIN `t_pvp_user_session` AS us ON us.sid = s.id INNER JOIN activity_template AS a ON s.create_time>=a.time_begin AND s.create_time<=a.time_end WHERE us.uid=%d AND us.id=%d AND a.aid=%d AND s.game_cfgId = 15 AND s.game_result >= 0 AND us.resultType>=0 AND DATE(s.create_time)=CURDATE()",iUid,iRid,iActivityId)
				--print(sql)
			end
		end
	elseif iActivityType == 20001 then --20001 随机迷宫层数
		sql = string.format("SELECT  IFNULL(MAX(`task_randmapstage`), 0) FROM `t_user_task` AS ut INNER JOIN `activity_template` AS a ON ut.`time` >= a.`time_begin` AND ut.`time` <= a.`time_end` WHERE ut.`uid` = %d AND a.`aid`= %d",iUid, iActivityId)
	elseif iActivityType == 20002 then --20002 前哨阵地波次
		sql = string.format("SELECT  IFNULL(MAX(`task_qszdwave`), 0) FROM `t_user_task` AS ut INNER JOIN `activity_template` AS a ON ut.`time` >= a.`time_begin` AND ut.`time` <= a.`time_end` WHERE ut.`uid` = %d AND a.`aid`= %d",iUid, iActivityId)
	elseif iActivityType == 20003 then --20003 武器枪解锁次数
		sql = string.format("SELECT  COUNT(*) FROM `order` AS o INNER JOIN `activity_template` AS a ON o.`itemid` = 10161 AND o.`time_begin` >= a.`time_begin` AND o.`time_begin` <= a.`time_end` WHERE o.`uid` = %d AND  a.`aid`= %d",iUid, iActivityId)
	elseif iActivityType == 20004 then --20004 宠物解锁次数
		sql = string.format("SELECT  COUNT(*) FROM `order` AS o INNER JOIN `activity_template` AS a ON o.`itemid` = 10175 AND o.`time_begin` >= a.`time_begin` AND o.`time_begin` <= a.`time_end` WHERE o.`uid` = %d AND  a.`aid`= %d",iUid, iActivityId)
	elseif iActivityType == 20005 then --20005 累计获得星星数量
		sql = string.format("SELECT `mapstar` FROM `t_cha` WHERE `id` = %d", iRid)
	end
	
	--查询并返回
	if sql then
		local err,count = xlDb_Query(sql)
		--print(sql)
		--print(err,count)
		if err == 0 then
			progress = count
			
			if callback_activity_obtain_prize then
				callback_activity_obtain_prize(iUid,iRid,iActivityType,iActivityId,progress,sPrize)
			end
		end
	end
	
	return progress
end

function shop_buyitems_coin(iUid,iRid,iTotalCoin)
	local iLeftCoin = iTotalCoin - g_sDetail.coin
	local iCostCoin = -g_sDetail.coin
    local ix = {}
    local itemlist = g_sDetail.item
	for i=1,#itemlist do
		if itemlist[i].type == "cn" then -- coin
			local num = itemlist[i].num
			iLeftCoin = iLeftCoin + num
			iCostCoin = num - g_sDetail.coin
			-- t_user
		elseif itemlist[i].type == "ix" then -- t_cha
			if itemlist[i].id == 30 or itemlist[i].id == 9004 or itemlist[i].id == 9005 or itemlist[i].id == 9006 or (9300 <= itemlist[i].id and itemlist[i].id <= 9320) or itemlist[i].id == 9999 then
                ix[#ix+1] = {}
				ix[#ix].id = itemlist[i].id
				ix[#ix].num = itemlist[i].num
			end
		end
	end
	-- t_cha
	if 0 < #ix then
		local sql = "update t_cha set "
		for i=1,#ix do
			local name = ""
            if 30 == ix[i].id then name = "material_red" end
			if 9004 == ix[i].id then name = "chest_cuprum" end
			if 9005 == ix[i].id then name = "chest_silver" end
			if 9006 == ix[i].id then name = "chest_gold" end
			if 9999 == ix[i].id then name = "prize_code" end
			if 9300 <= ix[i].id and ix[i].id <= 9320 then
				name = "ext_op" .. tostring(ix[i].id)
			end
			local tmp = string.format("%s=%s+%d",name,name,ix[i].num)
			if 1 == i then
				sql = sql .. tmp
			else
				sql = sql .. "," .. tmp
			end
		end
		sql = sql .. string.format(" where uid = %d and id = %d",iUid,iRid)
		xlDb_Execute(sql)
	end
    if 0 == iCostCoin then
    else
	    xlDb_Execute(string.format("update t_user set gamecoin_online = gamecoin_online + %d where uid = %d",iCostCoin,iUid))
    end
    return iLeftCoin
end
function callback_shop1_buy(iUid,iRid,iShopId)
    local iLeftCoin = 0
    local iErrorCode,sDetail = xlDb_Query(string.format("SELECT shop_detail FROM shop_online WHERE shop_id = %d",iShopId))
    if 0 == iErrorCode then
        --01 get coin
        local iTotalCoin = 0
        iErrorCode,iTotalCoin = xlDb_Query(string.format("SELECT gamecoin_online FROM t_user WHERE uid = %d",iUid))
        if 0 == iErrorCode then
            --02 loaddetail
            g_sDetail = {}
            local sString = "g_sDetail = " .. sDetail
            loadstring(sString)()
            --03 判断是否够钱
            if g_sDetail.coin <= iTotalCoin then
                iLeftCoin = shop_buyitems_coin(iUid,iRid,iTotalCoin)
            else
                iErrorCode = 188
            end
            g_sDetail = nil
        else
            iErrorCode = 60 --uid or rid
        end
    else
        iErrorCode = 20 --没记录
    end
    return {iErrorCode,iLeftCoin}
end
function shopid2shopid(iShopId)
    for i=1,9 do
        if i*100000 > iShopId and 100000 < iShopId and iShopId < 700000 then
            return (i-1),(iShopId - (i-1)*100000)
        end
    end
    return 0,0
end
function callback_shop2_buy(iUid,iRid,iShopId)
    local iLeftCoin = 0
    local iErrorCode = 0
    --01 获取物品ID和位置
    local iPos,iItemId = shopid2shopid(iShopId)
    if 0 < iPos and iPos < 7 and 0 < iItemId then
        local iDbRecordId = 0
        local iDbShopId = 0
        local iDbSold = 1
        local sDbDetail = ""
	    iErrorCode,iDbRecordId,iDbShopId,iDbSold,sDbDetail = xlDb_Query(string.format("SELECT id,shop%02d_id,shop%02d_sold,shop%02d_detail FROM shop_dispatch WHERE uid = %d ORDER BY id DESC LIMIT 1",iPos,iPos,iPos,iUid))
        if 0 == iErrorCode and iItemId == iDbShopId then
            --02 是否已经购买
            if 0 == iDbSold then
                --03 get coin
                local iTotalCoin = 0
                iErrorCode,iTotalCoin = xlDb_Query(string.format("SELECT gamecoin_online FROM t_user WHERE uid = %d",iUid))
                if 0 == iErrorCode then
                    --04 loaddetail
                    g_sDetail = {}
                    local sString = "g_sDetail = " .. sDbDetail
                    loadstring(sString)()
                    --05 判断是否够钱
                    if g_sDetail.coin <= iTotalCoin then
                        xlDb_Execute(string.format("UPDATE shop_dispatch SET shop%02d_sold = 1 WHERE id = %d",iPos,iDbRecordId))
                        iLeftCoin = shop_buyitems_coin(iUid,iRid,iTotalCoin)
                    else
                        iErrorCode = 188
                    end
                    g_sDetail = nil
                else
                    iErrorCode = 60 --uid or rid
                end
            else
                iErrorCode = 166 --已经购买过了
            end
        else
            iErrorCode = 22
        end
    else
        iErrorCode = 21 --错误的物品ID
    end
    return {iErrorCode,iLeftCoin}
end
function callback_shop3_buy(iUid,iRid,iShopId)
    local iLeftCoin = 0
    local iErrorCode,iCircle,sDetail,iPassTime = xlDb_Query(string.format("SELECT time_day,shop_detail,(SELECT DATEDIFF(CURDATE(),DATE(buytime)) FROM shop_buy WHERE uid = %d AND shopid = shop_id) AS time_buy FROM shop_online WHERE time_begin <= NOW() AND NOW() <= time_end AND shop_page = 3 AND 0 < time_day AND shop_id = %d",iUid,iShopId))
    if 0 == iErrorCode then
       --01 判断是否已经购买过
        if iCircle <= iPassTime then
            --02 get coin
            local iTotalCoin = 0
            iErrorCode,iTotalCoin = xlDb_Query(string.format("SELECT gamecoin_online FROM t_user WHERE uid = %d",iUid))
            if 0 == iErrorCode then
                --03 loaddetail
                g_sDetail = {}
                local sString = "g_sDetail = " .. sDetail
                loadstring(sString)()
                --04 判断是否够钱
                if g_sDetail.coin <= iTotalCoin then
                    xlDb_Execute(string.format("UPDATE shop_buy SET buytime = NOW() WHERE uid=%d AND shopid=%d",iUid,iShopId))
                    iLeftCoin = shop_buyitems_coin(iUid,iRid,iTotalCoin)
                else
                    iErrorCode = 188
                end
                g_sDetail = nil
            else
                iErrorCode = 60 --uid or rid
            end
        else
            iErrorCode = 166 --已经购买过了
        end
    else
       iErrorCode = 20 --没记录
    end
    return {iErrorCode,iLeftCoin}
end
function callback_shop_red(iUid,iRid,iNum)
    local iLeftCoin = 0
    local iErrorCode,iPrice,iCount = xlDb_Query("SELECT price_normal,price_count FROM t_shop WHERE id = 9998")
    if 0 == iErrorCode then
        --02 get coin
        local iTotalCoin = 0
        iErrorCode,iTotalCoin = xlDb_Query(string.format("SELECT gamecoin_online FROM t_user WHERE uid = %d",iUid))
        if 0 == iErrorCode then
            --03 判断是否够钱
            local iCost = iPrice * iNum
            iCount = iCount * iNum
            if iCost <= iTotalCoin then
                --04 update coin_online
                xlDb_Execute(string.format("update t_user set gamecoin_online = gamecoin_online - %d where uid = %d",iCost,iUid))
                --02 update coin_red
                xlDb_Execute(string.format("update t_cha set coin_red = coin_red + %d where id = %d",iCount,iRid))
            else
                iErrorCode = 188
            end
        else
            iErrorCode = 60 --uid or rid
        end
    else
        iErrorCode = 20 --没记录
    end
    return {iErrorCode,iLeftCoin}
end

function callback_shop_buy(iType,iUid,iRid,iShopId)
    if 11 == iType then
        return callback_shop1_buy(iUid,iRid,iShopId)
    elseif 12 == iType then
        return callback_shop2_buy(iUid,iRid,iShopId)
    elseif 13 == iType then
        return callback_shop3_buy(iUid,iRid,iShopId)
    elseif 16 == iType then
        return callback_shop_red(iUid,iRid,iShopId)
    end 
end
function callback_shop4_buy(iUid,iRid,iShopId)
    local iLeftCoin = 0
    local iLeftRed = 0
    local iErrorCode,sDetail = xlDb_Query(string.format("SELECT shop_detail FROM shop_online WHERE shop_id = %d",iShopId))
    if 0 == iErrorCode then
        --01 get coin_red
        local iTotalRed = 0
        iErrorCode,iTotalRed = xlDb_Query(string.format("SELECT coin_red FROM t_cha WHERE id = %d",iRid))
        if 0 == iErrorCode then
            iErrorCode,iTotalCoin = xlDb_Query(string.format("SELECT gamecoin_online FROM t_user WHERE uid = %d",iUid))
            --02 loaddetail
            g_sDetail = {}
            local sString = "g_sDetail = " .. sDetail
            loadstring(sString)()
            --03 判断是否够钱
            if g_sDetail.coin_red <= iTotalRed then
                iLeftCoin = shop_buyitems_coin(iUid,iRid,iTotalCoin)
                iLeftRed = iTotalRed - g_sDetail.coin_red
                xlDb_Execute(string.format("update t_cha set coin_red = coin_red - %d where id = %d",g_sDetail.coin_red,iRid))
            else
                iErrorCode = 189
            end
            g_sDetail = nil
        else
            iErrorCode = 60 --uid or rid
        end
    else
        iErrorCode = 20 --没记录
    end
    return {iErrorCode,iLeftCoin,iLeftRed}
end


function prizecode2table(prizecode)
    --01
    local iStringLen = string.len(prizecode)
    local res = {}
    local sKey = ""
    local sVal = ""
    local iStatus = 0   --0init 1key 2value
    for i=1,iStringLen do
        local sCurString = string.sub(prizecode,i,i)
        if "0" == sCurString or "1" == sCurString or "2" == sCurString or "3" == sCurString or "4" == sCurString or "5" == sCurString or "6" == sCurString or "7" == sCurString or "8" == sCurString or "9" == sCurString then
            if 0 == iStatus then
                return nil
            elseif 1 == iStatus then
                return nil
            else
                sVal = sVal .. sCurString
                if i == iStringLen then
                    local tTable = res[#res]
                    tTable[sKey] = sVal
                    iStatus = 0
                end
            end
        elseif ";" == sCurString then
            if 2 ~= iStatus then return nil end
            local tTable = res[#res]
            tTable[sKey] = sVal
            iStatus = 0
        elseif ":" == sCurString then
            if 1 ~= iStatus then return nil end
            iStatus = 2
        else
            if 0 == iStatus then
                res[#res + 1] = {}
                iStatus = 1
                sKey = sCurString
                sVal = ""
            elseif 1 == iStatus then
                sKey = sKey .. sCurString
            else
                local tTable = res[#res]
                tTable[sKey] = sVal
                iStatus = 1
                sKey = sCurString
                sVal = ""
            end
        end
    end

    return res
end

function callback_prize(iUid,iRid,iPrizeId,sPrizeCode)
    if type(sPrizeCode) == "string" and string.len(sPrizeCode) > 0 then
        local res = prizecode2table(sPrizeCode)
        if res then
            for i=1,#res do
                if res[i].i then
                    local num = res[i].n or 0
                    if "9004" == res[i].i then
                        local sql = string.format("update t_cha set chest_cuprum=chest_cuprum + %d where id=%d",num,iRid)
                        xlDb_Execute(sql)
                        local logvii = string.format("insert  into log_vii(uid,rid,type,num,traceid) values(%d,%d,9004,%d,%d)",iUid,iRid,num,iPrizeId)
                        xlDb_Execute(logvii)
                    elseif "9005" == res[i].i then
                        local sql = string.format("update t_cha set chest_silver=chest_silver + %d where id=%d",num,iRid)
                        xlDb_Execute(sql)
                        local logvii = string.format("insert  into log_vii(uid,rid,type,num,traceid) values(%d,%d,9005,%d,%d)",iUid,iRid,num,iPrizeId)
                        xlDb_Execute(logvii)
                    elseif "9006" == res[i].i then
                        local sql = string.format("update t_cha set chest_gold=chest_gold + %d where id=%d",num,iRid)
                        xlDb_Execute(sql)
                        local logvii = string.format("insert  into log_vii(uid,rid,type,num,traceid) values(%d,%d,9006,%d,%d)",iUid,iRid,num,iPrizeId)
                        xlDb_Execute(logvii)
                    elseif "9999" == res[i].i then
                        local sql = string.format("update t_cha set prize_code=prize_code + %d where id=%d",num,iRid)
                        xlDb_Execute(sql)
                        local logvii = string.format("insert  into log_vii(uid,rid,type,num,traceid) values(%d,%d,9999,%d,%d)",iUid,iRid,num,iPrizeId)
                        xlDb_Execute(logvii)
                    end
                end
            end
        end
    end
end

--1元档
--限时礼包充值成功回调
function xlcallback_ontopup_gift(uid, channelId, giftid, money, count, prizeinfo)
	--print("xlcallback_ontopup_gift", uid, channelId, giftid, money, count, prizeinfo)
	
	local sCfg = "local tmp = {" .. prizeinfo .. "} return tmp"
	local tGiftPrizeList = assert(loadstring(sCfg))()
	local first_buy = tGiftPrizeList.first_buy --首次充值的奖励列表
	local not_first_buy = tGiftPrizeList.not_first_buy --非首充的奖励列表
	
	--奖励表
	local tPrizeList = nil
	if (count == 1) then
		tPrizeList = first_buy
	else
		tPrizeList = not_first_buy
	end
	
	--依次遍历插入奖励语句
	local reward = {}
	for p = 1, #tPrizeList, 1 do
		local tGiftPrize = tPrizeList[p]
		local id = tGiftPrize.id
		local detail = tGiftPrize.detail
		
		--插入语句
		local insertSql = string.format("INSERT INTO `prize`(`uid`, `type`, `mykey`, `from`) VALUES (%d, %d, '%s', %d)", uid, id, detail, giftid)
		local err = xlDb_Execute(insertSql)
	end
end

--月卡
--月卡充值成功回调
function xlcallback_ontopup_monthcard(uid, channelId, iDays)
	--print("xlcallback_ontopup_monthcard", uid, channelId, iDays)
	
	--发放月卡充值奖励
	if hClass.MonthCard then
		local montCard = hClass.MonthCard:create("MonthCard"):Init(uid)
		
		--发放月卡充值奖励
		montCard:RewardMonthCardToup()
		
		--检测是否发放今日奖励
		local sL2CCmd = montCard:CheckTodayMonthCardReward()
		
		--如果玩家在线，下发月卡状态
		local user = hGlobal.uMgr:FindUserByDBID(uid)
		--print("user=", user)
		if user then
			--注意，触发回调时程序还未存t_user表，所以这里以传入的值作为参数发给客户端
			local nIsMonthCard = 1
			local nLeftDay = iDays
			local sL2CCmd = tostring(nIsMonthCard) .. ";" .. tostring(nLeftDay) .. ";"
			hApi.xlNet_Send(uid, hVar.DB_RECV_TYPE.L2C_NOTICE_MONTH_CARD, sL2CCmd)
		end
	end
end

--礼品码
--礼包兑换成功回调
function xlcallback_onget_giftreward(uid, iType, channelId, sMyKey)
	--print("xlcallback_onget_giftreward", uid, iType, channelId, sMyKey)
	
	--插入日志，发奖
	local insertSql = string.format("INSERT INTO `prize`(`uid`, `type`, `mykey`, `used`) VALUES (%d, %d, '%s', %d)", uid, 402, sMyKey, 2)
	xlDb_Execute(insertSql)
	
	--解析是否要发放神器晶石奖励
	--eqcrystal:100;
	local key = "eqcrystal:"
	local eqcrystal_pos = string.find(sMyKey, key)
	--print("eqcrystal_pos=", eqcrystal_pos)
	if eqcrystal_pos then
		local rpos = string.find(sMyKey, ";", eqcrystal_pos + 1)
		--print("rpos=", rpos)
		if rpos then
			local strNum = string.sub(sMyKey, eqcrystal_pos + #key, rpos - 1)
			--print("strNum=", strNum)
			local nNum = tonumber(strNum) or 0
			--print("nNum=", nNum)
			if (nNum > 0) then
				--加神器晶石
				local sql = string.format("update `t_user` set `equip_crystal` = `equip_crystal` + %d where `uid` = %d", nNum, uid)
				--print(sql)
				xlDb_Execute(sql)
			end
		end
	end
	
	--解析是否发放高级战术卡包奖励
	--tacticalcardpack:2;
	local key = "tacticalcardpack:"
	local tacticalcardpack_pos = string.find(sMyKey, key)
	--print("tacticalcardpack_pos=", tacticalcardpack_pos)
	if tacticalcardpack_pos then
		local rpos = string.find(sMyKey, ";", tacticalcardpack_pos + 1)
		--print("rpos=", rpos)
		if rpos then
			local strNum = string.sub(sMyKey, tacticalcardpack_pos + #key, rpos - 1)
			--print("strNum=", strNum)
			local nNum = tonumber(strNum) or 0
			--print("nNum=", nNum)
			if (nNum > 0) then
				--插入邮件奖励
				local sMyKey = hVar.tab_string["__TEXT_GIFT_REWARD"] .. ";" .. "9:9102:" .. nNum .. ":0;"
				local sql = string.format("insert into `prize` (`uid`, `type`, `mykey`, `used`) values (%d, %d, '%s',%d)", uid, 20008, sMyKey, 0)
				--print(sql)
				xlDb_Execute(sql)
			end
		end
	end
	
	--解析是否发放幸运神器锦囊奖励
	--redeqchest:3;
	local key = "redeqchest:"
	local redeqchest_pos = string.find(sMyKey, key)
	--print("redeqchest_pos=", redeqchest_pos)
	if redeqchest_pos then
		local rpos = string.find(sMyKey, ";", redeqchest_pos + 1)
		--print("rpos=", rpos)
		if rpos then
			local strNum = string.sub(sMyKey, redeqchest_pos + #key, rpos - 1)
			--print("strNum=", strNum)
			local nNum = tonumber(strNum) or 0
			--print("nNum=", nNum)
			if (nNum > 0) then
				--插入邮件奖励
				local sMyKey = hVar.tab_string["__TEXT_GIFT_REWARD"] .. ";" .. "15:9919:" .. nNum .. ":0;"
				local sql = string.format("insert into `prize` (`uid`, `type`, `mykey`, `used`) values (%d, %d, '%s',%d)", uid, 20008, sMyKey, 0)
				--print(sql)
				xlDb_Execute(sql)
			end
		end
	end
	
	--解析是否发放红装兑换券奖励
	--redeqexchangebf:1;
	local key = "redeqexchangebf:"
	local redeqexchangebf_pos = string.find(sMyKey, key)
	--print("redeqexchangebf_pos=", redeqexchangebf_pos)
	if redeqexchangebf_pos then
		local rpos = string.find(sMyKey, ";", redeqexchangebf_pos + 1)
		--print("rpos=", rpos)
		if rpos then
			local strNum = string.sub(sMyKey, redeqexchangebf_pos + #key, rpos - 1)
			--print("strNum=", strNum)
			local nNum = tonumber(strNum) or 0
			--print("nNum=", nNum)
			if (nNum > 0) then
				--加神器晶石
				local sql = string.format("update `t_user` set `equip_scroll` = `equip_scroll` + %d where `uid` = %d", nNum, uid)
				--print(sql)
				xlDb_Execute(sql)
			end
		end
	end
	
	--解析是否发放战术技能卡碎片奖励
	--tacticcarddebris:10301:20;
	local key = "tacticcarddebris:"
	local tacticdebris_pos = string.find(sMyKey, key)
	--print("tacticdebris_pos=", tacticdebris_pos)
	if tacticdebris_pos then
		while tacticdebris_pos do
			--s:2000;tacticcarddebris:10301:20;tacticcarddebris:10302:20;tacticcarddebris:10303:20;
			local maohao_pos = string.find(sMyKey, ":", tacticdebris_pos + #key + 1)
			local fenhao_pos = string.find(sMyKey, ";", tacticdebris_pos + #key + 1)
			local itemId = tonumber(string.sub(sMyKey, tacticdebris_pos + #key, maohao_pos - 1)) or 0
			local itemNum = tonumber(string.sub(sMyKey, maohao_pos + 1, fenhao_pos - 1)) or 0
			--print("itemId=", itemId)
			--print("itemNum=", itemNum)
			if (itemId > 0) and (itemNum > 0) then
				--插入邮件奖励
				local sMyKey = hVar.tab_string["__TEXT_GIFT_REWARD"] .. ";" .. "6:" .. itemId .. ":" .. itemNum .. ":0;"
				local sql = string.format("insert into `prize` (`uid`, `type`, `mykey`, `used`) values (%d, %d, '%s',%d)", uid, 20008, sMyKey, 0)
				--print(sql)
				xlDb_Execute(sql)
			end
			
			--继续遍历
			tacticdebris_pos = string.find(sMyKey, key, fenhao_pos)
		end
	end
end

--订单
--订单成功回调
function xlcallback_onget_order_update(iType, uid, rid, itemId, itemNum, gamecoin, score)
	--print("xlcallback_onget_order_update", iType, uid, rid, itemId, itemNum, gamecoin, score)
	
	--统计游戏币累加值
	if (gamecoin > 0) then
		local sql = string.format("update `t_user` set `gamecoin_totalnum` = `gamecoin_totalnum` + %d where `uid` = %d", gamecoin, uid)
		xlDb_Execute(sql)
	end
end

--活动补发
--活动展示时间结束后，7天内补发用户自定义活动的奖励
function callback_activity_reissue_prize_custom(uid, rid)
	--print("callback_activity_reissue_prize_custom", uid, rid)
end