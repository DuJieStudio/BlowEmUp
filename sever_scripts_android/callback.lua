--local __pLogFunc = function(msg)
--	xlLG("DBOprError",msg)
--end

--（老的接口，安卓已废弃）
--客户端发送3002协议的入口
function callback_c2ldbopr(connid,uid,nOpr,sCmd)
	
	local function __NetCmd()
		if hHandler.C2L_DB_OPR[nOpr] then
			--xpcall(function()
			--return hHandler.C2L_DB_OPR[nOpr](connid,uid,nOpr,sCmd)
			--end,__pLogFunc)
			hHandler.C2L_DB_OPR[nOpr](connid,uid,nOpr,sCmd)
		end
	end

	xpcall(__NetCmd,hGlobal.__TRACKBACK__)
end

--（老的接口，安卓已废弃）
--程序循环调用,1分钟/次
function callback_c2lloop()
	--如果时间偏差值异常则设置时间偏差值
	if not hVar.DELT_TIME or hVar.DELT_TIME == -1 then
		local err,sTick = xlDb_Query("SELECT NOW()")
		if err == 0 then
			hVar.DELT_TIME = os.time() - hApi.GetNewDate(sTick)	--deltaTime = Local - Host
		end
	end

	--设置版本号控制信息 todo:以后要整理成一个类去处理系统配置
	-------------------------------------------------------------------------------------------
	local sql = string.format("SELECT content from tconfig where `key` = '%s'", "shop_control")
	local nErr,content = xlDb_Query(sql)
	if nErr == 0 then
		hVar.shop_control = content
	end
	
	sql = string.format("SELECT content from tconfig where `key` = '%s'", "version_control")
	nErr,content = xlDb_Query(sql)
	if nErr == 0 then
		hVar.version_control = content
	end

	sql = string.format("SELECT content from tconfig where `key` = '%s'", "debug_version_control")
	nErr,content = xlDb_Query(sql)
	if nErr == 0 then
		hVar.debug_version_control = content
	end
	-------------------------------------------------------------------------------------------

	if hGlobal.bbMgr then
		hGlobal.bbMgr:Update()
	end
end

---------------------------------------------------------------------------------------
-------------------------------------------------------------------以上是老db的回调，废弃-------------------------------------------------------------------
---------------------------------------------------------------------------------------


--玩家充值成功回调
function callback_ontopup(uid,iaptype,order)
	--print("hellored111:",uid,iaptype,order)
	if hGlobal.vipMgr then
	--print("hellored:",uid,iaptype,order)
		--获取微信充值额外奖励
		--hGlobal.vipMgr:DBGetWXPrize(uid,iaptype,order)
		
		--更新玩家Vip状态
		hGlobal.vipMgr:DBGetUserVipState(uid)
		
		--[[
		--大菠萝，插入邮箱奖励
		local describe = hVar.TANK_TOPUP_REWARD[order]
		if describe then
			local insertSql = string.format("INSERT INTO prize (uid,`type`, mykey) VALUES (%d, 11000, '%s')",uid,describe)
			--执行sql
			local err = xlDb_Execute(insertSql)
		end
		]]
		
	
		--[[
		--战车，充值30元认为是充值月卡
		if (gamecoin == 300) then
			--读取原月卡剩余有效天数
			local iMonthcardDaysNow = -1
			local sql = string.format("SELECT DATEDIFF(`month_card_overtime`, NOW()) FROM `t_user` WHERE `uid` = %d AND `month_card_overtime` > '1990-01-01 00:00:00'", uid);
			print(sql)
			local err, days = xlDb_Query(sql)
			print("err=", err, "days=", days)
			if (err == 0) then
				iMonthcardDaysNow = days
			end
			
			--月卡叠加30天
			local iDays = 30
			if (iMonthcardDaysNow > 0) then
				iDays = iDays + iMonthcardDaysNow
			end
			print("iDays=", iDays)
			
			--更新月卡结束时间
			local sql = string.format("UPDATE `t_user` SET `month_card_overtime` = (ADDDATE(CURDATE(), %d)) WHERE `uid` = %d", iDays, uid)
			xlDb_Execute(sql)
			print(sql)
		end
		]]
	end
end


--新玩家注册回调
function callback_user_new(uid,channelid)
	--local describe = "卓玩家们，让你们久等了，特奉上100游戏币！;7:100:0:0;"
	--local insertSql = string.format("INSERT INTO prize (uid,`type`, mykey) VALUES (%d,20008,'%s')",uid,describe)
	--local err = xlDb_Execute(insertSql)
	
	--print("callback_user_new",uid,channelid)
	--[[
	--测试
	if (channelid == 1019) then --1019 应用宝测试(海南希萌互娱)
		local insertSql = string.format("update `t_user` set `gamecoin_online` = '999999' where `uid` = '%d'", uid)
		local err = xlDb_Execute(insertSql)
		
		local describe = "应用宝测试发放红装-武器;10:12003:4:0:0;10:12004:3:0:0;10:12009:4:0:0;10:12002:3:0:0;10:12005:3:0:0;10:12006:3:0:0;10:12008:4:0:0;10:12010:4:0:0;10:12006:3:0:0;10:12001:3:0:0;"
		local insertSql = string.format("INSERT INTO prize (uid,`type`, mykey) VALUES (%d, 20008,'%s')",uid,describe)
		local err = xlDb_Execute(insertSql)
		
		local describe = "应用宝测试发放红装-防具;10:12205:4:0:0;10:12209:4:0:0;10:12206:3:0:0;10:12207:3:0:0;10:12201:3:0:0;10:12202:3:0:0;10:12203:3:0:0;10:12208:3:0:0;10:12204:3:0:0;"
		local insertSql = string.format("INSERT INTO prize (uid,`type`, mykey) VALUES (%d, 20008,'%s')",uid,describe)
		local err = xlDb_Execute(insertSql)
		
		local describe = "应用宝测试发放红装-宝物;10:12405:3:0:0;10:12402:3:0:0;10:12409:4:0:0;10:12401:3:0:0;10:12404:3:0:0;10:12407:3:0:0;10:12408:3:0:0;10:12410:3:0:0;10:12403:3:0:0;"
		local insertSql = string.format("INSERT INTO prize (uid,`type`, mykey) VALUES (%d, 20008,'%s')",uid,describe)
		local err = xlDb_Execute(insertSql)
		
		local describe = "应用宝测试发放红装-坐骑;10:12605:3:0:0;10:12610:4:0:0;10:12601:3:0:0;10:12603:3:0:0;10:12604:3:0:0;10:12606:3:0:0;10:12608:3:0:0;10:12602:3:0:0;10:12607:3:0:0;10:12609:3:0:0;"
		local insertSql = string.format("INSERT INTO prize (uid,`type`, mykey) VALUES (%d, 20008,'%s')",uid,describe)
		local err = xlDb_Execute(insertSql)
	end
	]]
	
	--[[
	local describe = "内测期间赠送1000氪石;尊敬的玩家，感谢您测试“异星要塞”，以下为您的奖励，请查收。;7:1000:0:0;"
	local insertSql = string.format("INSERT INTO prize (uid,`type`, mykey) VALUES (%d, 20031,'%s')",uid,describe)
	local err = xlDb_Execute(insertSql)
	]]
end


--NEWLOGIN 回调
--服务器玩家登陆回调
--参数: 玩家id, 当前使用角色id, 类型1in 2out 3dis, 登陆类型0 正常登陆, 1游戏内重连
function xlcallback_logevent(udbid, rid, rType, iTag)
	--玩家登陆
	if rType == 1 then
		print("====user login====:", udbid, rid, rType, iTag)
		--hApi.Log(0, string.format("====user login====:%d,%d,%d",tostring(udbid),tostring(rid),tostring(rType),tostring(iTag)))
		
		local newUser = false
		--玩家登陆，查找是否已经有玩家信息
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--print("服务器玩家登陆回调 user=",user)
		--没有玩家，则创建新玩家
		if not user then
			user = hGlobal.uMgr:CreateUser(udbid, rid)
			newUser = true
		end
		
		--print("服务器玩家登陆回调 user2=",user)
		--
		if not user then
			--返回登录失败提示
			--hApi.xlNet_Send(udbid,hVar.PVP_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.NETERR.LOGIN_PLAYER_FULL))	--发送错误信息，服务器人数已满
		else
			--返回客户端，玩家登陆成功
			
			--如果是重连
			if iTag == 1 then
			else
			end
			user:SetInHall()
			--print("服务器玩家登陆回调 before")
			local sCmd = hGlobal.uMgr:LoginResultToCmd(1, user:GetID(), user:GetDBID())
			hApi.xlNet_Send(udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_PLAYER_LOGIN,sCmd)	--发送登陆成功回调
			--sCmd = user:BaseInfoToCmd()
			--hApi.xlNet_Send(udbid,hVar.PVP_RECV_TYPE.L2C_NOTICE_USER_BASEINFO,sCmd)	--发送用户基本信息
			--sCmd = hGlobal.sysCfg:CombatStatisticsToCmd()
			--hApi.xlNet_Send(udbid,hVar.PVP_RECV_TYPE.L2C_NOTICE_BATTLE_STATISTICS,sCmd)--发送战斗信息统计数据
			--print("服务器玩家登陆回调 hApi.xlNet_Send", udbid,hVar.DB_RECV_TYPE.L2C_NOTICE_PLAYER_LOGIN,sCmd)
		end
	--玩家离线
	else
		print("====user logOut====:",udbid, rid, rType, iTag)
		--hApi.Log(0, string.format("====user logOut====:%d,%d,%d,%d",tostring(udbid),tostring(rid),tostring(rType),tostring(iTag)))
		local user = hGlobal.uMgr:FindUserByDBID(udbid)
		--print("logOut leave room:", user, user:IsInRoom())
		--如果玩家在房间中，则释放房间中的玩家信息
		if user then
			--print("logOut leave all:")
			
			--临时,玩家退出才会更新配置至服务器
			--旧流程：(英雄数据是实时保存的，退出时不处理)
			--user:SaveData(true,true,true,true,true)
			
			--释放玩家信息
			hGlobal.uMgr:ReleaseUserByDBID(udbid)
			
		else
			--print("logOut leave error:")
			
			--hApi.xlNet_Send(udbid,hVar.PVP_RECV_TYPE.L2C_NOTICE_ERROR,tostring(hVar.NETERR.ROOM_LEAVE_FAILD))
		end
	end
	callback_user_logevent(udbid, rid, rType, iTag)
end

--客户端脚本协议的入口
function xlcallback_netevent(udbid, rid, msgId, iparam1, iparam2, sCmd)
	
	--local time = hApi.GetClock()
	
	--print("====xlcallback_netevent====", udbid, rid, msgId, sCmd)
	local function __NetCmd()
		if hHandler.C2L_DB_OPR[msgId] then
			local tCmd = hApi.Split(sCmd,";")
			hHandler.C2L_DB_OPR[msgId](udbid, rid, msgId, tCmd, sCmd)
		end
	end
	
	xpcall(__NetCmd,hGlobal.__TRACKBACK__)
	
	
	--time = hApi.GetClock() - time
	
	--print("time:", time)
	
	--local function __NetCmd()
	--	if hHandler.C2L_DB_OPR[nOpr] then
	--		--xpcall(function()
	--		--return hHandler.C2L_DB_OPR[nOpr](connid,uid,nOpr,sCmd)
	--		--end,__pLogFunc)
	--		hHandler.C2L_DB_OPR[nOpr](connid,uid,nOpr,sCmd)
	--	end
	--end

	--xpcall(__NetCmd,hGlobal.__TRACKBACK__)
end

--服务器update（每帧调1次）（60帧）
function xlcallback_updateevent()
	--print("xlcallback_updateevent")
	--[[
	--如果时间偏差值异常则设置时间偏差值
	if not hVar.DELT_TIME or hVar.DELT_TIME == -1 then
		local err,sTick = xlDb_Query("SELECT NOW()")
		if err == 0 then
			hVar.DELT_TIME = os.time() - hApi.GetNewDate(sTick)	--deltaTime = Local - Host
		end
	end
	
	--设置版本号控制信息 todo:以后要整理成一个类去处理系统配置
	-------------------------------------------------------------------------------------------
	local sql = string.format("SELECT content from tconfig where `key` = '%s'", "shop_control")
	local nErr,content = xlDb_Query(sql)
	if nErr == 0 then
		hVar.shop_control = content
	end
	
	sql = string.format("SELECT content from tconfig where `key` = '%s'", "version_control")
	nErr,content = xlDb_Query(sql)
	if nErr == 0 then
		hVar.version_control = content
	end

	sql = string.format("SELECT content from tconfig where `key` = '%s'", "debug_version_control")
	nErr,content = xlDb_Query(sql)
	if nErr == 0 then
		hVar.debug_version_control = content
	end
	-------------------------------------------------------------------------------------------
	--]]
	
	if hGlobal.sysCfg then
		hGlobal.sysCfg:Update()
	end
	
	--geyachao: 排行榜每日发奖在ios服务器，安卓的就不重复发奖了
	--geyachao: 战车只有安卓服务器了，所以这里需要发奖了
	if hGlobal.bbMgr then
		hGlobal.bbMgr:Update()
	end
	
	--新增
	if hGlobal.uMgr then
		hGlobal.uMgr:Update()
	end
	
	--大菠萝，战车每日排行榜统计
	if hGlobal.tankbbMgr then
		--print("hGlobal.tankbbMgr:Update()")
		hGlobal.tankbbMgr:Update()
	end
	
	--用户走马灯冒字
	if hGlobal.bubblleNoticeMgr then
		hGlobal.bubblleNoticeMgr:Update()
	end
	
	--体力更新
	--这里改为安卓主服务器发奖
	if (hVar.IS_MAIN_SERVER == 1) then
		if hGlobal.tiliMgr then
			--hGlobal.tiliMgr:Update()
			xpcall(hGlobal.tiliMgr.Update, hGlobal.__TRACKBACK__)
		end
	end
end
