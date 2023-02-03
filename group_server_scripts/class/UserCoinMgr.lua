--�û����ҹ�����
local UserCoinMgr = class("UserCoinMgr")
	
	
	--���캯��
	function UserCoinMgr:ctor()
		--����
		return self
	end
	--��ʼ������
	--function UserCoinMgr:Init()
	--	return self
	--end
	
	--������Ϸ��
	function UserCoinMgr:DBAddGamecoin(dbid, addGold)
		
		local gold = math.min(2500, (addGold or 0))
		
		if gold > 0 then
			--
			local sUpdate = string.format("UPDATE `t_user` SET `gamecoin_online` = `gamecoin_online` + %d WHERE uid = %d",gold,dbid)
			xlDb_Execute(sUpdate)
			
			--add log
			local sLog = string.format("insert into `prize` (uid,type, mykey, used) values (%d,%d,%d,%d)",dbid,400,gold,2)
			xlDb_Execute(sLog)
		elseif gold < 0 then
			--�۳���ң�����¼��prize�����ڿ�֮ǰ��order
			--ͳ����Ϸ���ۼ�ֵ
			local sUpdate = string.format("UPDATE t_user SET gamecoin_online = gamecoin_online + %d, `gamecoin_totalnum` = `gamecoin_totalnum` + %d WHERE uid = %d",gold,-gold,dbid)
			xlDb_Execute(sUpdate)
		end
	end
	
	--����������ʯ
	function UserCoinMgr:DBAddCrystal(dbid, addCrystal)
		
		local crystal = math.min(2000, (addCrystal or 0))
		
		if crystal > 0 then
			--
			local sUpdate = string.format("UPDATE t_user SET equip_crystal = equip_crystal + %d WHERE uid = %d",crystal,dbid)
			xlDb_Execute(sUpdate)
			
		elseif crystal < 0 then
			--�۳���ң�����¼��prize�����ڿ�֮ǰ��order
			local sUpdate = string.format("UPDATE t_user SET equip_crystal = equip_crystal + %d WHERE uid = %d",crystal,dbid)
			xlDb_Execute(sUpdate)
		end
	end
	
	--���Ӳر�ͼ
	function UserCoinMgr:DBAddCangBaoTu(dbid, addCangBaoTu)
		
		local cangbaotu = math.min(2000, (addCangBaoTu or 0))
		
		if cangbaotu > 0 then
			--
			local sUpdate = string.format("UPDATE `t_user` SET `cangbaotu` = `cangbaotu` + %d WHERE `uid` = %d", cangbaotu, dbid)
			xlDb_Execute(sUpdate)
			
		elseif cangbaotu < 0 then
			--�۳���ң�����¼��prize�����ڿ�֮ǰ��order
			local sUpdate = string.format("UPDATE `t_user` SET `cangbaotu` = `cangbaotu` + %d WHERE `uid` = %d", cangbaotu, dbid)
			xlDb_Execute(sUpdate)
		end
	end
	
	--���Ӹ߼��ر�ͼ
	function UserCoinMgr:DBAddCangBaoTuHigh(dbid, addCangBaoTuHigh)
		
		local cangbaotu_high = math.min(2000, (addCangBaoTuHigh or 0))
		
		if cangbaotu_high > 0 then
			--
			local sUpdate = string.format("UPDATE `t_user` SET `cangbaotu_high` = `cangbaotu_high` + %d WHERE `uid` = %d", cangbaotu_high, dbid)
			xlDb_Execute(sUpdate)
			
		elseif cangbaotu_high < 0 then
			--�۳���ң�����¼��prize�����ڿ�֮ǰ��order
			local sUpdate = string.format("UPDATE `t_user` SET `cangbaotu_high` = `cangbaotu_high` + %d WHERE `uid` = %d", cangbaotu_high, dbid)
			xlDb_Execute(sUpdate)
		end
	end
	
	--���ӱ���
	function UserCoinMgr:DBAddPvpCoin(dbid, addPvpCoin, strInfo)
		
		local pvpcoin = math.min(2000, (addPvpCoin or 0))
		
		if pvpcoin > 0 then
			--
			local sUpdate = string.format("UPDATE `t_user` SET `pvpcoin` = `pvpcoin` + %d WHERE `uid` = %d", pvpcoin, dbid)
			xlDb_Execute(sUpdate)
			
			--���붩�����ʼ���ȡ����
			local iItemId = 20035
			local sItemName = hVar.tab_stringI[iItemId]
			if (strInfo ~= nil) then
				sItemName = strInfo
			end
			local sExt01 = "" --tostring(pvpNow)
			local sSql = string.format("INSERT INTO `order` (`type`, uid, rid, itemid, itemnum, coin, itemname, ext_01) VALUES (%d, %d, %d, %d, %d, %d, '%s', '%s')",21,dbid,0,iItemId,addPvpCoin,0,sItemName,sExt01)
			--print(sSql)
			xlDb_Execute(sSql)
		elseif pvpcoin < 0 then
			--�۳���ң�����¼��prize�����ڿ�֮ǰ��order
			local sUpdate = string.format("UPDATE `t_user` SET `pvpcoin` = `pvpcoin` + %d WHERE `uid` = %d", pvpcoin, dbid)
			xlDb_Execute(sUpdate)
		end
	end
	
	--���ӳ齱���ȯ
	function UserCoinMgr:DBAddChouJiangFreeTicket(dbid, rid, activityId, ticketNum)
		if (activityId > 0) and (activityId > 0) then
			--�ȼ�����ָ���id�Ƿ����
			--��ѯ����ѳ齱�Ĵ���
			local sQuery = string.format("SELECT `lv01` from `activity_check` where `uid` = %d and `rid` = %d and `aid`= %d limit 1", dbid, rid, activityId)
			local err, lv01 = xlDb_Query(sQuery)
			--print("��ѯ�˻��һ����ɵĽ��Ⱥ�����:", "err=", err, "lv01=", lv01)
			if (err == 0) then
				--�޸Ļ����
				local sUpdate = string.format("update `activity_check` set `lv01` = `lv01` + %d where `aid` = %d and `uid` = %d and `rid` = %d", ticketNum, activityId, dbid, rid)
				xlDb_Execute(sUpdate)
			else --û�м�¼
				--�����»����
				local sInsert = string.format("insert into `activity_check`(`aid`, `uid`, `rid`, `level`, `lv01`) values (%d, %d, %d, %d, %d)", activityId, dbid, rid, 0, ticketNum)
				xlDb_Execute(sInsert)
			end
		end
	end
	
	--����ս������
	function UserCoinMgr:DBAddZhanGongScore(dbid, rid, addScore)
		local sUpdate = string.format("UPDATE `t_pvp_user` SET `evaluateE` = `evaluateE` + %d WHERE `id` = %d", addScore, rid)
		xlDb_Execute(sUpdate)
	end
	
	--���Ӻ�װ����
	function UserCoinMgr:DBAddRedScroll(dbid, addRedScroll)
		
		local redScroll = math.min(2000, (addRedScroll or 0))
		
		if redScroll > 0 then
			--
			local sUpdate = string.format("UPDATE t_user SET equip_scroll = equip_scroll + %d WHERE uid = %d",redScroll,dbid)
			xlDb_Execute(sUpdate)
			
		elseif redScroll < 0 then
			--�۳���ң�����¼��prize�����ڿ�֮ǰ��order
			local sUpdate = string.format("UPDATE t_user SET equip_scroll = equip_scroll + %d WHERE uid = %d",redScroll,dbid)
			xlDb_Execute(sUpdate)
		end
	end
	
	--���ӱ��䣨һ�μ�1����
	function UserCoinMgr:DBAddChest(uid, rid, itemId, itemNum)
		-- itemId, 9004-9006���� 9300-9320��Ƭ 9999��ױ����
		local num = itemNum or 1
		if itemId >= 9004 and itemId <= 9006 then
			--������һ�����3������ֹx3�Ҹ㣩
			if itemId == 9005 then
				num = math.min(3, num)
			--����һ�����1������ֹx3�Ҹ㣩
			elseif itemId == 9006 then
				num = math.min(1, num)
			end
			if xlPrize_AddVii then
				xlPrize_AddVii(uid,rid,itemId,num)
			end
		end
	end
	
	--�������Ԥ�۷�
	function UserCoinMgr:DBUserPurchase(dbid, rid, itemId,itemNum,gamecoinCost,scoreCost,itemExt)
		
		local ret = false
		local ret_order_id = 0 --������id
		
		local nItemId = itemId
		local nItemNum = itemNum or 1
		local nGamecoinCost = gamecoinCost or 0
		local nScoreCost = scoreCost or 0
		local sItemExt = itemExt or ""
		
		if not nItemId or nItemId <= 0 then
			return ret, ret_order_id
		end
		
		local sql = string.format("SELECT gamecoin_online FROM t_user where uid=%d",dbid)
		local err,gamecoin = xlDb_Query(sql)
		if err == 0 then
			
			--������㹻����Ϸ��
			if gamecoinCost <= gamecoin then
				
				local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
				
				--�µĹ����¼���뵽order��
				local sUpdateLog = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,1,dbid,rid,itemId,nItemNum,sItemName,nGamecoinCost,nScoreCost,sItemExt)
				xlDb_Execute(sUpdateLog)
				
				local err1, orderId = xlDb_Query("select last_insert_id()")
				--print("err1,orderId:",err1,orderId)
				if err1 == 0 then
					ret_order_id = orderId
				end
				
				--��Ǯ
				--����t_user
				self:DBAddGamecoin(dbid, -gamecoinCost)
				
				ret = true
			end
		end
		
		return ret, ret_order_id
	end
	
	--��װ��ʯ�һ����߿۷�
	function UserCoinMgr:DBUserExchange(dbid, rid, itemId,itemNum,crystalCost,scoreCost,itemExt)
		
		local ret = false
		
		local nItemId = itemId
		local nItemNum = itemNum or 1
		local nCrystalCost = crystalCost or 0
		local nScoreCost = scoreCost or 0
		local sItemExt = itemExt or ""
		
		if not nItemId or nItemId <= 0 then
			return ret
		end
		
		local sql = string.format("SELECT equip_crystal FROM t_user where uid=%d",dbid)
		local err,crystal = xlDb_Query(sql)
		if err == 0 then
			
			--������㹻��������ʯ
			if nCrystalCost <= crystal then
				
				local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
				
				--�µĹ����¼���뵽order��
				local sUpdateLog = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,dbid,rid,itemId,nItemNum,sItemName,0,nScoreCost,nCrystalCost.. ";" .. sItemExt)
				xlDb_Execute(sUpdateLog)
				
				--��Ǯ
				--����t_user
				self:DBAddCrystal(dbid, -nCrystalCost)
				
				ret = true
			end
		end
		
		return ret
	end
	
	--�ر�ͼ�һ����߿۷�
	function UserCoinMgr:DBUserExchangeCangBaoTu(dbid, rid, itemId,itemNum,cangbaotuCost,scoreCost,itemExt)
		
		local ret = false
		
		local nItemId = itemId
		local nItemNum = itemNum or 1
		local nCangBaoTuCost = cangbaotuCost or 0
		local nScoreCost = scoreCost or 0
		local sItemExt = itemExt or ""
		
		if not nItemId or nItemId <= 0 then
			return ret
		end
		
		local sql = string.format("SELECT `cangbaotu` FROM `t_user` where uid = %d",dbid)
		local err,cangbaotu = xlDb_Query(sql)
		if err == 0 then
			
			--������㹻�Ĳر�ͼ
			if nCangBaoTuCost <= cangbaotu then
				
				local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
				
				--�µĹ����¼���뵽order��
				local sUpdateLog = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,dbid,rid,itemId,nItemNum,sItemName,0,nScoreCost,nCangBaoTuCost.. ";" .. sItemExt)
				xlDb_Execute(sUpdateLog)
				
				--��Ǯ
				--����t_user
				self:DBAddCangBaoTu(dbid, -nCangBaoTuCost)
				
				ret = true
			end
		end
		
		return ret
	end
	
	--�߼��ر�ͼ�һ����߿۷�
	function UserCoinMgr:DBUserExchangeCangBaoTuHigh(dbid, rid, itemId,itemNum,cangbaotuHighCost,scoreCost,itemExt)
		
		local ret = false
		
		local nItemId = itemId
		local nItemNum = itemNum or 1
		local nCangBaoTuHighCost = cangbaotuHighCost or 0
		local nScoreCost = scoreCost or 0
		local sItemExt = itemExt or ""
		
		if not nItemId or nItemId <= 0 then
			return ret
		end
		
		local sql = string.format("SELECT `cangbaotu_high` FROM `t_user` where uid = %d",dbid)
		local err,cangbaotu_high = xlDb_Query(sql)
		if err == 0 then
			
			--������㹻�ĸ߼��ر�ͼ
			if nCangBaoTuHighCost <= cangbaotu_high then
				
				local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
				
				--�µĹ����¼���뵽order��
				local sUpdateLog = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,dbid,rid,itemId,nItemNum,sItemName,0,nScoreCost,nCangBaoTuHighCost.. ";" .. sItemExt)
				xlDb_Execute(sUpdateLog)
				
				--��Ǯ
				--����t_user
				self:DBAddCangBaoTuHigh(dbid, -nCangBaoTuHighCost)
				
				ret = true
			end
		end
		
		return ret
	end
	
	--��װ����ѡ���װ�۷�
	function UserCoinMgr:DBUserCostScroll(dbid, rid, itemId,itemNum,scrollCost,scoreCost,itemExt)
		
		local ret = false
		
		local nItemId = itemId
		local nItemNum = itemNum or 1
		local nScrollCost = scrollCost or 0
		local nScoreCost = scoreCost or 0
		local sItemExt = itemExt or ""
		
		if not nItemId or nItemId <= 0 then
			return ret
		end
		
		local sql = string.format("SELECT equip_scroll FROM t_user where uid=%d",dbid)
		local err,scroll = xlDb_Query(sql)
		if err == 0 then
			
			--������㹻����Ϸ��
			if nScrollCost <= scroll then
				
				local sItemName = hVar.tab_stringI[itemId] or hVar.tab_stringI[0]
				
				--�µĹ����¼���뵽order��
				local sUpdateLog = string.format("INSERT INTO `order` (type, flag, uid, rid, itemid, itemnum, itemname, coin, score, time_begin, time_end, ext_01) values (%d, %d, %d, %d, %d, %d, '%s', %d, %d, now(), now(), '%s')",21,2,dbid,rid,itemId,nItemNum,sItemName,0,nScoreCost,nScrollCost.. ";" .. sItemExt)
				xlDb_Execute(sUpdateLog)
				
				--��Ǯ
				--����t_user
				self:DBAddRedScroll(dbid, -nScrollCost)
				
				ret = true
			end
		end
		
		return ret
	end
	
	--��ȡ��ҵ���Դ��Ϣ
	function UserCoinMgr:DBUserGetMyCoin(dbid,rid)
		local sL2CCmd = ""
		
		local sql = string.format("SELECT u.gamecoin_online,u.pvpcoin,u.equip_crystal,equip_scroll FROM t_user as u where u.uid=%d ",dbid)
		local err,gamecoin,pvpcoin,equip_crystal,equip_scroll = xlDb_Query(sql)
		if err == 0 then
			sL2CCmd = gamecoin .. ";" .. pvpcoin .. ";" .. equip_crystal .. ";" .. equip_scroll .. ";"
		else
			sL2CCmd = "0;0;0;0;"
		end
		
		local sqlpvp = string.format("SELECT pu.evaluateE FROM t_pvp_user as pu where pu.id=%d",rid)
		local errpvp,evaluateE = xlDb_Query(sqlpvp)
		if errpvp == 0 then
			sL2CCmd = sL2CCmd .. evaluateE
		else
			sL2CCmd = sL2CCmd .. "0"
		end
		
		return sL2CCmd
	end
	
	--��ȡ�����Ϸ�ұ仯��¼��Ϣ
	function UserCoinMgr:DBQueryGameCoinHistory(uid, rid)
		--��Ϸ�ұ仯��3�������: prize�콱��iap_record��ֵ��order����
		--���ζ�ȡÿ������ȡ���100����¼
		local tRecord = {}
		local MAXCOUNT = 100
		
		--��ΪЧ���Ż����᲻��������order����prize����һЩ���ɵ����ݶ�ʧ������ֻȡ2�����ڵļ�¼
		--������յ�0��
		local nTimestampNow = os.time()
		local strDateTodaystampYMD = hApi.Timestamp2Date(nTimestampNow) --ת�ַ���(������)
		local strNewTodayZeroDate = strDateTodaystampYMD .. " 00:00:00"
		--local nTimestampTodayZero = hApi.GetNewDate(strNewTodayZeroDate)
		--ǰ60��
		local day60time = hApi.GetNewDate(strNewTodayZeroDate, "DAY", -60)
		local strDay60time = os.date("%Y-%m-%d 00:00:00", day60time)
		--print("ǰ30�� 9��:", "strDay60time=", strDay60time)
		
		--��ѯprizeÿ���콱 9��
		local sQueryM = string.format("select `mykey`, `create_time` from `prize` where `uid` = %d and `type` = 9 and `create_time` > '%s' order by `create_time` desc limit %d", uid, strDay60time, MAXCOUNT)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("��ѯprizeÿ���콱 9��:", "errM=", errM, "tTemp=", tTemp and #tTemp)
		if (errM == 0) then
			--ÿ���콱��Ϣ
			for n = 1, #tTemp, 1 do
				local mykey = tTemp[n][1]
				local time = tTemp[n][2]
				local rmb = string.sub(mykey, string.find(mykey, "c:") + 2, string.find(mykey, "s:") - 2)
				local coin = tonumber(rmb) or 0
				--print(coin, time)
				if (coin > 0) then
					tRecord[#tRecord+1] = {coin = coin, time = time, operation = hVar.tab_string["__TEXT_MAIL_DALIYREWARD"], tag = 1, idx = n,}
				end
			end
		end
		
		--��ѯprize������� 100��
		local sQueryM = string.format("select `mykey`, `create_time` from `prize` where `uid` = %d and `type` = 100 and `create_time` > '%s' order by `create_time` desc limit %d", uid, strDay60time, MAXCOUNT)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("��ѯprize������� 100��:", "errM=", errM, "tTemp=", tTemp and #tTemp)
		if (errM == 0) then
			--���������Ϣ
			for n = 1, #tTemp, 1 do
				local mykey = tTemp[n][1]
				local time = tTemp[n][2]
				local rmb = string.sub(mykey, string.find(mykey, "c:") + 2, string.find(mykey, "s:") - 2)
				local coin = tonumber(rmb) or 0
				--print(coin, time)
				if (coin > 0) then
					tRecord[#tRecord+1] = {coin = coin, time = time, operation = hVar.tab_string["__TEXT_MAIL_NEWPLAYERREWARD"], tag = 2, idx = n,}
				end
			end
		end
		
		--��ѯprize֧����Ϸ 18��
		local sQueryM = string.format("select `mykey`, `create_time` from `prize` where `uid` = %d and `type` = 18 and `create_time` > '%s' order by `create_time` desc limit %d", uid, strDay60time, MAXCOUNT)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("��ѯprize֧����Ϸ 18��:", "errM=", errM, "tTemp=", tTemp and #tTemp)
		if (errM == 0) then
			--֧����Ϸ��Ϣ
			for n = 1, #tTemp, 1 do
				local mykey = tTemp[n][1]
				local time = tTemp[n][2]
				local rmb = string.sub(mykey, string.find(mykey, "c:") + 2, string.find(mykey, "s:") - 2)
				local coin = tonumber(rmb) or 0
				--print(coin, time)
				if (coin > 0) then
					tRecord[#tRecord+1] = {coin = coin, time = time, operation = hVar.tab_string["__TEXT_MAIL_SUPPORTGAMEREWARD"], tag = 3, idx = n,}
				end
			end
		end
		
		--��ѯrecommend�Ƽ����� 3��
		local sQueryM = string.format("select `mykey`, `create_time` from `prize` where `uid` = %d and `type` = 3 and `create_time` > '%s' order by `create_time` desc limit %d", uid, strDay60time, MAXCOUNT)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("��ѯrecommend�Ƽ����� 3��:", "errM=", errM, "tTemp=", tTemp and #tTemp)
		if (errM == 0) then
			--�Ƽ�������Ϣ
			for n = 1, #tTemp, 1 do
				local mykey = tTemp[n][1]
				local time = tTemp[n][2]
				local rmb = string.sub(mykey, string.find(mykey, "c:") + 2, string.find(mykey, ";") - 1) --ֻ����Ϸ����Ϣ
				local coin = tonumber(rmb) or 0
				--print(coin, time)
				if (coin > 0) then
					tRecord[#tRecord+1] = {coin = coin, time = time, operation = hVar.tab_string["__TEXT_MAIL_RECOMMNDREWARD"], tag = 4, idx = n,}
				end
			end
		end
		
		--��ѯprize��ֵ���� 10000��
		local sQueryM = string.format("select `mykey`, `create_time` from `prize` where `uid` = %d and `type` = 10000 and `create_time` > '%s' order by `create_time` desc limit %d", uid, strDay60time, MAXCOUNT)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("��ѯprize��ֵ���� 10000��:", "errM=", errM, "tTemp=", tTemp and #tTemp)
		if (errM == 0) then
			--��ֵ������Ϣ
			for n = 1, #tTemp, 1 do
				local mykey = tTemp[n][1]
				local time = tTemp[n][2]
				local rmb = string.sub(mykey, string.find(mykey, "c:") + 2, string.find(mykey, ";") - 1) --ֻ����Ϸ����Ϣ
				local coin = tonumber(rmb) or 0
				--print(coin, time)
				if (coin > 0) then
					tRecord[#tRecord+1] = {coin = coin, time = time, operation = hVar.tab_string["__TEXT_MAIL_PURCHASECRITALREWARD"], tag = 5, idx = n,}
				end
			end
		end
		
		--��ѯprize 400�� �콱
		local sQueryM = string.format("select `mykey`, `create_time` from `prize` where `uid` = %d and `type` = 400 and `create_time` > '%s' and `used` = 2 order by `create_time` desc limit %d", uid, strDay60time, MAXCOUNT)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("��ѯprize 400�� �콱:", "errM=", errM, "tTemp=", tTemp and #tTemp)
		if (errM == 0) then
			--�콱��Ϣ
			for n = 1, #tTemp, 1 do
				local strTitle = hVar.tab_string["__TEXT_MAIL_REWARD"]
				local mykey = tTemp[n][1]
				local coin = tonumber(mykey) or 0
				local time = tTemp[n][2]
				
				--���mykey�ֶκ���";",����Ϊ�ֺ�ǰ
				local pos = string.find(mykey, ";")
				if (pos ~= nil) then
					strTitle = string.sub(mykey, 1, pos - 1)
					coin = tonumber(string.sub(mykey, pos + 1, #mykey)) or 0
				end
				
				--print(coin, time)
				if (coin > 0) then
					tRecord[#tRecord+1] = {coin = coin, time = time, operation = strTitle, tag = 6, idx = n,}
				end
			end
		end
		
		--��ѯ��Ʒ�� ����
		local sQueryM = string.format("select `mykey`, `buy_time` from `dispatch_coin` where `recipient` = %d and `buy_time` > '%s' and `used` = 2 order by `buy_time` desc limit %d", uid, strDay60time, MAXCOUNT)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("��ѯ��Ʒ�� ����:", "errM=", errM, "tTemp=", tTemp and #tTemp)
		if (errM == 0) then
			for n = 1, #tTemp, 1 do
				local mykey = tTemp[n][1]
				local time = tTemp[n][2]
				local rmb = 0 --����ֻ����Ϸ����Ϣ������û����Ϸ�ң�������Ϸ�Һͻ���
				if (string.find(mykey, "c:") ~= nil) then
					rmb = string.sub(mykey, string.find(mykey, "c:") + 2, string.find(mykey, ";") - 1) --��ȷ���Ƿ�ֻ����Ϸ����Ϣ
				end
				local coin = tonumber(rmb) or 0
				--print(coin, time)
				if (coin > 0) then
					tRecord[#tRecord+1] = {coin = coin, time = time, operation =hVar.tab_string["__TEXT_GIFT_REWARD"], tag = 7, idx = n,}
				end
			end
		end
		
		--��ѯiap_record��ֵ
		local sQueryM = string.format("select `money`, `coin`, `buytime` from `iap_record` where `uid` = %d and `buytime` > '%s' order by `buytime` desc limit %d", uid, strDay60time, MAXCOUNT)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("��ѯiap_record��ֵ:", "errM=", errM, "tTemp=", tTemp and #tTemp)
		if (errM == 0) then
			--ͳ��ÿһ����ܳ�ֵ���
			for n = 1, #tTemp, 1 do
				local money = tTemp[n][1]
				local coin = tTemp[n][2]
				local time = tTemp[n][3]
				--print(money, coin, time)
				if (coin > 0) then
					if (money ~= 30) then --geyachao: 30Ԫ�����¿�������������
						tRecord[#tRecord+1] = {coin = coin, time = time, operation = string.format(hVar.tab_string["__TEXT_PURCHASE_REWARD"], money), tag = 8, idx = n,}
					end
				end
			end
		end
		
		--��ѯorder����
		local sQueryM = string.format("select `itemname`, `coin`, `time_begin` from `order` where `uid` = %d and (`rid` = %d or `rid` = 0) and `coin` > 0 and `time_begin` > '%s' order by `time_begin` desc limit %d", uid, rid, strDay60time, MAXCOUNT)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		--print("��ѯorder����:", "errM=", errM, "tTemp=", tTemp and #tTemp)
		if (errM == 0) then
			--������Ϣ
			for n = 1, #tTemp, 1 do
				local itemname = tostring(tTemp[n][1])
				local coin = tTemp[n][2]
				local time = tTemp[n][3]
				--print(itemname, coin, time)
				if (coin > 0) then
					tRecord[#tRecord+1] = {coin = -coin, time = time, operation = itemname, tag = 9, idx = n,}
				end
			end
		end
		
		--��ѯ���ڵ���Ϸ��
		local gamecoinNow = 0
		local sql = string.format("SELECT `gamecoin_online` FROM `t_user` where `uid` = %d", uid)
		local err, gamecoin = xlDb_Query(sql)
		--print("��ѯ���ڵ���Ϸ��:", "err=", err, "gamecoin=", gamecoin)
		if (err == 0) then
			gamecoinNow = gamecoin
		end
		
		--���򣬰������ڽ�������
		table.sort(tRecord, function(ta, tb)
			--lua��table.sort�еĵڶ�����������ȵ�����±���Ҫ����false�������ܷ���true
			--���Ȱ����ڣ������ǰ��
			if (ta.time ~= tb.time) then
				return (ta.time > tb.time)
			end
			
			--��Σ������ͣ�С����ǰ��
			if (ta.tag ~= tb.tag) then
				return (ta.tag < tb.tag)
			end
			
			--ͬһ���ͣ�����С����ǰ��
			return (ta.idx < tb.idx)
		end)
		
		local recordNum = #tRecord
		if (recordNum > MAXCOUNT) then
			recordNum = MAXCOUNT
		end
		local sCmd = tostring(gamecoinNow) .. ";" .. tostring(recordNum) .. ";"
		for i = 1, recordNum, 1 do
			local temp = tostring(tRecord[i].coin) .. ";" .. tostring(tRecord[i].time) .. ";" .. tostring(tRecord[i].operation) .. ";"
			sCmd = sCmd .. temp
		end
		
		return sCmd
	end
	
return UserCoinMgr