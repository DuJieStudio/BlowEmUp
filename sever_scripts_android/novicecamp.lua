NoviceCampMgr = {}
NoviceCampMgr.private = {}
local private = NoviceCampMgr.private




--config
private.Config_GetNCFee = function()
	return 100
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


--nc
private.Data_GetNcList = function(iType)
	local sSql = string.format("SELECT `id`,`name`,`descripe`,`count_member`,`max_member`,`master_uid`,`master_name`,`vitality`,`graduate`,`time_create` FROM novicecamp_list WHERE `id` IN (SELECT NM.ncid FROM novicecamp_member AS NM,t_user AS US WHERE NM.`uid` = US.`uid` AND DATEDIFF(NOW(),US.last_login_time) < 7 GROUP BY NM.ncid) AND `type` = %d AND `dissolution` = 0 ORDER BY `vitality` DESC,`id` ASC",iType)
	local iErrorCode,tQuery = xlDb_QueryEx(sSql)
	return tQuery
end
private.Data_InsertNc = function(sName,sDescripe,iType,iMasterUid,sMasterName)
	local sSql = string.format("INSERT INTO novicecamp_list (`name`,`descripe`,`type`,`max_member`,`master_uid`,`master_name`,`time_create`) VALUES (\'%s\',\'%s\',%d,10,%d,\'%s\',NOW())",sName,sDescripe,iType,iMasterUid,sMasterName)
	xlDb_Execute(sSql)
	local iErrorCode,iNcId = xlDb_Query("select last_insert_id()")
	return iNcId
end
private.Data_SetNcDissolution = function(iNcId,iUid,iDissolution)
	local sSql = string.format("UPDATE novicecamp_list SET `dissolution`=%d,`time_dissolution` = NOW() WHERE `id`=%d AND `master_uid` = %d",iDissolution,iNcId,iUid)
	xlDb_Execute(sSql)
end
private.Data_GetNcInfo = function(iNcId)
	sSql = string.format("SELECT `master_uid`,`dissolution`,`count_member`,`max_member`,`vitality`,`graduate`,`time_create` FROM novicecamp_list WHERE `id`=%d",iNcId)
	local iErrorCode,iMasterUid,iDissolution,iMemberCount,iMaxMember,iVitality,iGraduate,sTime = xlDb_Query(sSql)
	return iMasterUid,iDissolution,iMemberCount,iMaxMember,iVitality,iGraduate,sTime
end
private.Data_GetNcInfoTable = function(iNcId)
	local sSql = string.format("SELECT `name`,`descripe`,`count_member`,`max_member`,`master_uid`,`master_name`,`vitality`,`graduate`,`time_create`,`dissolution` FROM novicecamp_list WHERE `id`=%d",iNcId)
	local iErrorCode,sName,sDescripe,iMemberCount,iMaxMember,iMasterUid,sMasterName,iVitality,iGraduate,sTime,iDissolution = xlDb_Query(sSql)
	return {sName,sDescripe,iMemberCount,iMaxMember,iMasterUid,sMasterName,iVitality,iGraduate,sTime,iDissolution}
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
private.Data_SetName = function(iNcId,sName)
	local sSql = string.format("UPDATE novicecamp_list SET `name`=\'%s\' WHERE `id`=%d",sName,iNcId)
	xlDb_Execute(sSql)
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
private.Data_GetMemberList = function(iNcId,iLevel)
	local sSql = nil
	if 9999 == iLevel then
		sSql = string.format("(SELECT novicecamp_member.`uid`,`level`,`customS1`,`time_jion`,`task_count`,`task_max`,`last_login_time` FROM novicecamp_member,t_user WHERE `ncid`= %d AND novicecamp_member.uid = t_user.uid) UNION (SELECT novicecamp_graduate.`uid`,100,`customS1`,`time`,10,10,`last_login_time` FROM novicecamp_graduate,t_user WHERE `ncid`= %d AND novicecamp_graduate.uid = t_user.uid)",iNcId,iNcId)
	elseif 100 == iLevel then
		sSql = string.format("SELECT novicecamp_graduate.`uid`,100,`customS1`,`time_jion`,`task_count`,`task_max`,`last_login_time` FROM novicecamp_graduate,t_user WHERE `ncid`= %d AND novicecamp_graduate.uid = t_user.uid",iNcId)
	else
		sSql = string.format("SELECT novicecamp_member.`uid`,`level`,`customS1`,`time_jion`,`task_count`,`task_max`,`last_login_time` FROM novicecamp_member,t_user WHERE `ncid`= %d AND `level`=%d AND novicecamp_member.uid = t_user.uid",iNcId,iLevel)
	end
	local iErrorCode,tQuery = xlDb_QueryEx(sSql)
	return tQuery
end
private.Data_GetMemberLevel = function(iUid,iNcId)
	local sSql = nil
	if iNcId then
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
private.Data_GetMemberInfo = function(iUid)
	local sSql = string.format("SELECT `ncid`,`level`,`task_count`,`task_max` FROM novicecamp_member WHERE `uid` = %d",iUid)
	local iErrorCode,iNcId,iLevel,iTaskCount,iTaskMax = xlDb_Query(sSql)
	return iNcId,iLevel,iTaskCount,iTaskMax
end
private.Data_InsertMember = function(iUid,iNcId,iLevel)
	local sSql = string.format("INSERT INTO novicecamp_member (`uid`,`ncid`,`level`,`time_jion`) VALUES (%d,%d,%d,NOW())",iUid,iNcId,iLevel)
	xlDb_Execute(sSql)
end
private.Data_DeleteMember = function(iUid)
	local sSql = string.format("DELETE FROM novicecamp_member WHERE `uid` = %d",iUid)
	xlDb_Execute(sSql)
end
private.Data_IncreaseMemberTask = function(iUid)
	local sSql = string.format("UPDATE novicecamp_member SET `task_count`=`task_count`+1 WHERE `uid`=%d",iUid)
	xlDb_Execute(sSql)
end




--vitality
private.Data_InsertVitality = function(iNcId,iUid,iTaskId,iVitality)
	local sSql = string.format("INSERT INTO novicecamp_vitality (`ncid`,`uid`,`taskid`,`vitality`) VALUES (%d,%d,%d,%d)",iNcId,iUid,iTaskId,iVitality)
	xlDb_Execute(sSql)
end
private.Data_UpdateVitalityStatistics = function(iNcId,iAddVitality)
	local sSql = string.format("UPDATE novicecamp_vitality_statistics SET `vitality`=`vitality`+%d WHERE `ncid` = %d AND DATEDIFF(CURDATE(),DATE(`time`)) = 0",iAddVitality,iNcId)
	xlDb_Execute(sSql)
end
private.Data_InitVitality = function()
	local sSql = "DELETE FROM novicecamp_vitality_temp"
	xlDb_Execute(sSql)
	--sSql = "INSERT INTO novicecamp_vitality_temp(ncid,vitality) SELECT ncid,SUM(vitality) AS vitality FROM novicecamp_vitality_statistics WHERE DATEDIFF(CURDATE(),DATE(`time`)) <= 6 GROUP BY ncid"
	--xlDb_Execute(sSql)
	--sSql = "UPDATE novicecamp_list AS ncl,novicecamp_vitality_temp AS t SET ncl.`vitality` = t.`vitality` WHERE ncl.`id` = t.`ncid`"
	--xlDb_Execute(sSql)
	
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
	local sSql = string.format("UPDATE t_user SET gamecoin_online = gamecoin_online + %d WHERE uid = %d",iCoin,iUid)
	xlDb_Execute(sSql)
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
NoviceCampMgr.GetNcList = function(tCmd)
	local tRes = {err=0,data={}}
	local iNcId,iLevel = private.Data_GetMemberInfo(tCmd.uid)
	local tList = private.Data_GetNcList(tCmd.type)
	if tList then tRes.data = tList end
	if nil == iNcId then
		iNcId = 0
		iLevel = -1
	end
	tRes.data.ncid = iNcId
	tRes.data.level = iLevel
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

NoviceCampMgr.CreateNc = function(tCmd)
	local tRes = {err=0}
	--01校验参数
	if "number" == type(tCmd.type) and "string" == type(tCmd.name) and 0 < string.len(tCmd.name) and "string" == type(tCmd.descripe) and 0 < string.len(tCmd.descripe) and "number" == type(tCmd.master_uid) and "string" == type(tCmd.master_name) then
		--02创建啥 新手营还是工会（暂不支持）
		if 1 == tCmd.type then
			--03判断该uid是否已有所属
			local iLevel = private.Data_GetMemberLevel(tCmd.master_uid)
			if nil == iLevel then
				--04判断游戏币
				local iCoin = private.Data_GetCoin(tCmd.master_uid)
				local iNcFee = private.Config_GetNCFee()
				if "number" == type(iCoin) and iNcFee <= iCoin then
					--05插入nc表
					local iNcId = private.Data_InsertNc(tCmd.name,tCmd.descripe,tCmd.type,tCmd.master_uid,tCmd.master_name)
					--06插入member表
					if iNcId then 
						private.Data_InsertMember(tCmd.master_uid,iNcId,99)
						private.Data_AddCoin(tCmd.master_uid,-iNcFee)
						tRes.data = {ncid=iNcId}
					else
						tRes.err = 104
					end
				else
					tRes.err = 103
				end
			else
				tRes.err = 102
			end
		else
			tRes.err = 101
		end
	else
		tRes.err = 100
	end
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

NoviceCampMgr.RemoveNc = function(tCmd)
	local tRes = {err=0}
	local iMasterUid,iDissolution = private.Data_GetNcInfo(tCmd.ncid)
	if nil == iMasterUid then
		tRes.err = 100
	else
		if iMasterUid == tCmd.uid then
			if 0 == iDissolution then
				private.Data_SetNcDissolution(tCmd.ncid,tCmd.uid,1)
				private.Data_DeleteMember(tCmd.uid)
			else
				tRes.err = 102
			end
		else
			tRes.err = 101
		end
	end
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

NoviceCampMgr.GetMemberList = function(tCmd)
	local tRes = {err=0}
	tRes.data = private.Data_GetMemberList(tCmd.ncid,tCmd.level)
	if nil == tRes.data then tRes.data = {} end
	tRes.data.ncinfo = private.Data_GetNcInfoTable(tCmd.ncid)
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

NoviceCampMgr.PowerJionAccept = function(tCmd)
	local tRes = {err=0}
	local iMasterUid,iDissolution,iMemberCount,iMaxMember = private.Data_GetNcInfo(tCmd.ncid)
	if nil == iMasterUid then
		tRes.err = 100
	else
		if iMasterUid == tCmd.uid then
			if 0 == iDissolution then
				if iMemberCount >= iMaxMember then
					tRes.err = 105
				else
					local iLevel = private.Data_GetMemberLevel(tCmd.uid_member,tCmd.ncid)
					if iLevel and 0 == iLevel then
						private.Data_SetMemberLevel(tCmd.uid_member,1)
						private.Data_IncreaseMemberCount(tCmd.ncid)
					else
						tRes.err = 104
					end
				end
			else
				tRes.err = 102
			end
		else
			tRes.err = 101
		end
	end
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

NoviceCampMgr.PowerJionReject = function(tCmd)
	local tRes = {err=0}
	local iMasterUid,iDissolution = private.Data_GetNcInfo(tCmd.ncid)
	if nil == iMasterUid then
		tRes.err = 100
	else
		if iMasterUid == tCmd.uid then
			if 0 == iDissolution then
				local iLevel = private.Data_GetMemberLevel(tCmd.uid_member,tCmd.ncid)
				if iLevel and 0 == iLevel then
					private.Data_DeleteMember(tCmd.uid_member)
				else
					tRes.err = 103
				end
			else
				tRes.err = 102
			end
		else
			tRes.err = 101
		end
	end
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

NoviceCampMgr.PowerJionRequest = function(tCmd)
	local tRes = {err=0}
	--01 如果是2017年1月1号之前的UID不给申请加入新手营
	if false == private.Data_IsNovice(tCmd.uid) then
		tRes.err = 104
		return NoviceCampMgr.Helper_Table2Cmd(tRes)
	end
	--02 检查工会是否有效
	local iMasterUid,iDissolution,iMemberCount,iMaxMember = private.Data_GetNcInfo(tCmd.ncid)
	if nil == iDissolution then tRes.err = 100
	elseif 1 == iDissolution then tRes.err = 101
	else
		if iMemberCount >= iMaxMember then
			tRes.err = 105
		else
			--02自己是否已经有所属了
			local iLevel = private.Data_GetMemberLevel(tCmd.uid)
			if iLevel then tRes.err = 102
			else
				local iGraduateNcId = private.Data_GetGraduateNcId(tCmd.uid)
				if iGraduateNcId then tRes.err = 103
				else
					private.Data_InsertMember(tCmd.uid,tCmd.ncid,0)
				end
			end
		end
	end
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

NoviceCampMgr.PowerJionCancel = function(tCmd)
	local tRes = {err=0}
	--01自己是否已经有所属了
	local iLevel = private.Data_GetMemberLevel(tCmd.uid,tCmd.ncid)
	if iLevel and 0 == iLevel then
		private.Data_DeleteMember(tCmd.uid)
	else
		tRes.err = 100
	end
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

NoviceCampMgr.PowerFire = function(tCmd)
	local tRes = {err=0}
	local iMasterUid,iDissolution,iMemberCount,iMaxMember = private.Data_GetNcInfo(tCmd.ncid)
	if nil == iMasterUid then
		tRes.err = 100
	else
		if iMasterUid == tCmd.uid then
			if 0 == iDissolution then
				local iLevel = private.Data_GetMemberLevel(tCmd.uid_member,tCmd.ncid)
				if iLevel and 1 == iLevel then
					--判断活跃度
					local iDays = private.Data_GetOffLineDays(tCmd.uid_member)
					if "number" == type(iDays) and 6 < iDays then
						private.Data_DeleteMember(tCmd.uid_member)
						private.Data_DecreaseMemberCount(tCmd.ncid)
					else
						tRes.err = 105
					end
				else
					tRes.err = 104
				end
			else
				tRes.err = 102
			end
		else
			tRes.err = 101
		end
	end
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

NoviceCampMgr.UpdateNc = function(tCmd)
	local tRes = {err=0,data={}}
	local iMasterUid,iDissolution = private.Data_GetNcInfo(tCmd.ncid)
	tRes.data.descripe = tCmd.descripe
	if nil == iMasterUid then
		tRes.err = 100
	else
		if iMasterUid == tCmd.uid then
			if 0 == iDissolution then
				private.Data_SetDescripe(tCmd.ncid,tCmd.descripe)
			else
				tRes.err = 102
			end
		else
			tRes.err = 101
		end
	end
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

NoviceCampMgr.ReNameNc = function(tCmd)
	local tRes = {err=0,data={}}
	local iMasterUid,iDissolution = private.Data_GetNcInfo(tCmd.ncid)
	tRes.data.name = tCmd.name
	if nil == iMasterUid then
		tRes.err = 100
	else
		if iMasterUid == tCmd.uid then
			if 0 == iDissolution then
				local iCoin = private.Data_GetCoin(iMasterUid)
				local iFee = 20
				if "number" == type(iCoin) and iFee <= iCoin then
					private.Data_SetName(tCmd.ncid,tCmd.name)
					private.Data_AddCoin(iMasterUid,-iFee)
				else
					tRes.err = 103
				end
			else
				tRes.err = 102
			end
		else
			tRes.err = 101
		end
	end
	return NoviceCampMgr.Helper_Table2Cmd(tRes)
end

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

NoviceCampMgr.OnTaskFinish = function(iUid,iRid,iTaskId)
	--01自己是否已经有所属了
	local iNcId,iLevel,iTaskCount,iTaskMax = private.Data_GetMemberInfo(iUid)
	if "number" == type(iNcId) and (1 == iLevel or 99 == iLevel) and iTaskCount < iTaskMax then
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

NoviceCampMgr.OnLoop = function()
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
		private.Data_InitVitalityStatistics()
		--02 更新检测时间
		private.Data_SetDailyVitalityTime()
	end

	if 1 == iDispatchPrize then
		--01 派发奖励
		NoviceCampMgr.OnPrizeVitality(50)
		--02 初始化临时活跃度
		private.Data_InitVitality()
	end
end

NoviceCampMgr.OnPrizeVitality = function(iCount)
	local tList = private.Data_VitalityTopList(iCount)
	local iLastRank = private.Config_GetLastRank()
	local iLastVitality = 0
	--print(string.format("OnPrizeVitality lastrank:%d",iLastRank))
	if "table" == type(tList) then
		for i=1,#tList do
			print(string.format("OnPrizeVitality i:%d uid:%d v:%d iLastVitality:%d",i,tList[i][1],tList[i][2],iLastVitality))
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

NoviceCampMgr.OnLoop()