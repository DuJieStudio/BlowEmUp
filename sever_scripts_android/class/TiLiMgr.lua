--����������
local TiLiMgr = class("TiLiMgr")
	
	--ÿ�������Զ�������ʱ��
	TiLiMgr.DAILY_SUPPLY_TIME = "05:00:00"
	
	--ÿ�������Զ����ʼ���ʱ��
	TiLiMgr.DAILY_SYSTEM_MAIL_TIME =
	{
		{time = "12:00:00",},
	}
	
	--����ÿСʱ�����ʯ����
	--TiLiMgr.PET_HOUR_KESHI_NUM = 1
	
	--�����ʯ�������ޣ�Сʱ��
	TiLiMgr.PET_HOUR_KESHI_TAKEREWARD_MAXHOUR = 24
	
	--����ÿСʱ������������
	--TiLiMgr.PET_HOUR_TILI_NUM = 1
	
	--���������������ޣ�Сʱ��
	TiLiMgr.PET_HOUR_TILI_TAKEREWARD_MAXHOUR = 24
	
	--���ﱦ��������ޣ�Сʱ��
	TiLiMgr.PET_HOUR_CHEST_TAKEREWARD_MAXHOUR = 24
	
	--�һ���������Ʒid
	TiLiMgr.EXCHANGE_TILI_SHOPITEM_ID = 645
	
	--��ȡ�ڿ��ʯ����Ʒid
	TiLiMgr.TAKEREWARD_KESHI_SHOPITEM_ID = 646
	
	--��ȡ�ڿ���������Ʒid
	TiLiMgr.TAKEREWARD_TILI_SHOPITEM_ID = 647
	
	--��ȡ�ڿ������Ʒid
	TiLiMgr.TAKEREWARD_CHEST_SHOPITEM_ID = 650
	
	--��ȡ�ڿ���Ľ�������id
	TiLiMgr.TAKEREWARD_CHEST_REWARD_CHEST_ID = 9926
	
	--���캯��
	function TiLiMgr:ctor()
		self._uid = -1
		self._rid = -1
		
		--����
		self._statisticsTime = -1	--ͳ�Ƽ�ʱ
		self._statisticsTimestamp = -1	--�ϴ�ͳ��ʱ��
		
		return self
	end
	
	--��ʼ������
	function TiLiMgr:Init(uid, rid)
		self._uid = uid
		self._rid = rid
		
		--����
		self._statisticsTime = hApi.GetClock()	--ͳ�Ƽ�ʱ
		self._statisticsTimestamp = os.time()	--�ϴ�ͳ��ʱ��
		
		return self
	end
	
	--release
	function TiLiMgr:Release()
		self._uid = -1
		self._rid = -1
		
		--����
		self._statisticsTime = -1	--ͳ�Ƽ�ʱ
		self._statisticsTimestamp = -1	--�ϴ�ͳ��ʱ��
		
		return self
	end
	
	--��ѯ���������Ϣ
	function TiLiMgr:QueryInfo()
		local strCmd = ""
		
		--����ʱ���
		local nTimestampNow = os.time()
		--print("nTimestampNow=", nTimestampNow)
		
		--��ȡ��������
		local pvpcoin = 0
		local pvpcoin_buy_count = 0
		local vipLv = hGlobal.vipMgr:DBGetUserVip(self._uid) --���vip�ȼ�
		local tiliDailyBuyCount = hVar.Vip_Conifg.tiliDailyBuyCount[vipLv] or 0 --ÿ�����������������
		local tiliDailyMax = hVar.Vip_Conifg.tiliDailyMax[vipLv] or 0 --��������
		local tiliDailySupply = hVar.Vip_Conifg.tiliDailySupply[vipLv] or 0 --ÿ�ղ���
		local sQuery = string.format("SELECT `pvpcoin`, `pvpcoin_buy_count`, `last_pvpcoin_buy_time`, `last_pvpcoin_supply_time` FROM `t_user` WHERE `uid` = %d", self._uid)
		local err, coin, buy_count, last_buy_time, last_pvpcoin_supply_time = xlDb_Query(sQuery)
		if (err == 0) then --��ѯ�ɹ�
			pvpcoin = coin
			pvpcoin_buy_count = buy_count
			
			--ת��Ϊ�������ϴβ���ʱ���0�����ʱ���
			local nTimestampBuy = hApi.GetNewDate(last_buy_time)
			local strDatestampBuyYMD = hApi.Timestamp2Date(nTimestampBuy) --ת�ַ���(������)
			local strNewdateBuy = strDatestampBuyYMD .. " 00:00:00"
			local nTimestampBuyTodayZero = hApi.GetNewDate(strNewdateBuy, "DAY", 1) -- +1��
			--print("strNewdateBuy=", strNewdateBuy)
			--print("nTimestampTodayZero=", nTimestampTodayZero)
			--print("nTimestampNow=", nTimestampNow)
			--���˵ڶ���
			if (nTimestampNow >= nTimestampBuyTodayZero) then
				--print("���˵ڶ���")
				pvpcoin_buy_count = 0
			end
			
			--����Զ�����
			local nTimestampSupply = hApi.GetNewDate(last_pvpcoin_supply_time)
			local strDatestampSppplyYMD = hApi.Timestamp2Date(nTimestampSupply) --ת�ַ���(������)
			local strNewdateSupply = strDatestampSppplyYMD .. " " .. TiLiMgr.DAILY_SUPPLY_TIME
			local nTimestampSupplyTodayTime = hApi.GetNewDate(strNewdateSupply, "DAY", 1) -- +1��
			--���˵ڶ���
			--print(nTimestampNow)
			--print(nTimestampSupplyTodayTime)
			if (nTimestampNow >= nTimestampSupplyTodayTime) then
				--����ֵ
				--local tiliDailySupply = hVar.Vip_Conifg.tiliDailySupply[vipLv] or 0
				if (pvpcoin < tiliDailySupply) then
					pvpcoin = tiliDailySupply
					
					--���²���
					local sUpdate = string.format("UPDATE `t_user` SET `pvpcoin` = %d, `last_pvpcoin_supply_time` = NOW() WHERE `uid` = %d", pvpcoin, self._uid)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
				else
					--ֻ���²�������
					local sUpdate = string.format("UPDATE `t_user` SET `last_pvpcoin_supply_time` = NOW() WHERE `uid` = %d", self._uid)
					--print("sUpdate1:",sUpdate)
					xlDb_Execute(sUpdate)
				end
			end
		end
		
		--��ȡ�ڿ�����
		local wakuangNum = 0 --�ڿ��������
		local watiliNum = 0 --��������������
		local export_keshi = 0
		local export_tili = 0
		local export_chest = 0
		
		local dailyKeShiExport = 0 --ÿ���ʯ����
		local dailyTiLiExport = 0 --ÿ����������
		local dailyChestExport = 0 --ÿ�ձ������
		
		--��ȡ��������
		local tPet = {}
		local sql = string.format("SELECT `inventoryInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, inventoryInfo = xlDb_Query(sql)
		--print("sql:",sql,e,inventoryInfo, type(inventoryInfo))
		if (e == 0) then
			if (type(inventoryInfo) == "string") and (#inventoryInfo > 0) then
				inventoryInfo = "{" .. inventoryInfo .. "}"
				local tmp = "local prize = " .. inventoryInfo .. " return prize"
				--������Ϣ��
				tPet = assert(loadstring(tmp))()
			end
		end
		for i = 1, #tPet, 1 do
			local id = tonumber(tPet[i][1]) or 0
			local star_i = tonumber(tPet[i][2]) or 0
			local num = tonumber(tPet[i][3]) or 0
			local level = tonumber(tPet[i][4]) or 0
			local wakuang = tonumber(tPet[i][5]) or 0
			local watili = tonumber(tPet[i][6]) or 0
			local sendtime = tonumber(tPet[i][7]) or 0
			local lastexporttime_wakuang = tonumber(tPet[i][8]) or 0 --�ϴ��ڿ����ʱ��
			local lastexporttime_watili = tonumber(tPet[i][9]) or 0 --�ϴ���������ʱ��
			local lastexporttime_wachest = tonumber(tPet[i][10]) or 0 --�ϴ��ڱ�����ʱ��
			
			if (wakuang == 1) then --���ڿ���
				wakuangNum = wakuangNum + 1
				
				--���㵱ǰ���ۼƵ��ʯ����
				local lasttime = sendtime
				if (lastexporttime_wakuang > sendtime) then
					lasttime = lastexporttime_wakuang
				end
				local deltatime = nTimestampNow - lasttime
				local exportHour = math.floor(deltatime / 3600)
				if (exportHour > TiLiMgr.PET_HOUR_KESHI_TAKEREWARD_MAXHOUR) then
					exportHour = TiLiMgr.PET_HOUR_KESHI_TAKEREWARD_MAXHOUR
				end
				
				--�ó������ʯ����
				local PET_HOUR_KESHI_NUM = 1 / hVar.PET_WAKUANG_INFO[star_i].wakuangRequireHour --�ڿ��ٶȣ�ÿСʱ��
				local export = math.floor(exportHour * PET_HOUR_KESHI_NUM)
				export_keshi = export_keshi + export
				
				--ͳ��ÿ���ʯ����
				dailyKeShiExport = dailyKeShiExport + math.floor(24 * PET_HOUR_KESHI_NUM)
				
				--���㵱ǰ���ۼƵı�������
				local lasttime = sendtime
				if (lastexporttime_wachest > sendtime) then
					lasttime = lastexporttime_wachest
				end
				local deltatime = nTimestampNow - lasttime
				local exportHour = math.floor(deltatime / 3600)
				if (exportHour > TiLiMgr.PET_HOUR_CHEST_TAKEREWARD_MAXHOUR) then
					exportHour = TiLiMgr.PET_HOUR_CHEST_TAKEREWARD_MAXHOUR
				end
				
				--�ó����ڱ������
				local PET_HOUR_CHEST_NUM = 1 / hVar.PET_WAKUANG_INFO[star_i].wachestRequireHour --�ڱ����ٶȣ�ÿСʱ��
				local export = math.floor(exportHour * PET_HOUR_CHEST_NUM)
				export_chest = export_chest + export
				
				--ͳ��ÿ�ձ������
				dailyChestExport = dailyChestExport + math.floor(24 * PET_HOUR_CHEST_NUM)
				
			elseif (watili == 1) then --����������
				watiliNum = watiliNum + 1
				
				--���㵱ǰ���ۼƵ���������
				local lasttime = sendtime
				if (lastexporttime_watili > sendtime) then
					lasttime = lastexporttime_watili
				end
				local deltatime = nTimestampNow - lasttime
				local exportHour = math.floor(deltatime / 3600)
				if (exportHour > TiLiMgr.PET_HOUR_TILI_TAKEREWARD_MAXHOUR) then
					exportHour = TiLiMgr.PET_HOUR_TILI_TAKEREWARD_MAXHOUR
				end
				
				--�ó�������������
				local PET_HOUR_TILI_NUM = 1 / hVar.PET_WAKUANG_INFO[star_i].watiliRequireHour --�������ٶȣ�ÿСʱ��
				local export = math.floor(exportHour * PET_HOUR_TILI_NUM)
				export_tili = export_tili + export
				
				--ͳ��ÿ����������
				dailyTiLiExport = dailyTiLiExport + math.floor(24 * PET_HOUR_TILI_NUM)
				
				--���㵱ǰ���ۼƵı�������
				local lasttime = sendtime
				if (lastexporttime_wachest > sendtime) then
					lasttime = lastexporttime_wachest
				end
				local deltatime = nTimestampNow - lasttime
				local exportHour = math.floor(deltatime / 3600)
				if (exportHour > TiLiMgr.PET_HOUR_CHEST_TAKEREWARD_MAXHOUR) then
					exportHour = TiLiMgr.PET_HOUR_CHEST_TAKEREWARD_MAXHOUR
				end
				
				--�ó����ڱ������
				local PET_HOUR_CHEST_NUM = 1 / hVar.PET_WAKUANG_INFO[star_i].wachestRequireHour --�ڱ����ٶȣ�ÿСʱ��
				local export = math.floor(exportHour * PET_HOUR_CHEST_NUM)
				export_chest = export_chest + export
				
				--ͳ��ÿ�ձ������
				dailyChestExport = dailyChestExport + math.floor(24 * PET_HOUR_CHEST_NUM)
			end
		end
		
		--local dailyKeShiExport = wakuangNum * TiLiMgr.PET_HOUR_KESHI_NUM * 24 --ÿ���ʯ����
		--local dailyTiLiExport = watiliNum * TiLiMgr.PET_HOUR_TILI_NUM * 24 --ÿ����������
		
		strCmd = tostring(tiliDailyMax) .. ";" .. tostring(pvpcoin) .. ";" .. tostring(tiliDailyBuyCount) .. ";" .. tostring(pvpcoin_buy_count) .. ";" .. tostring(tiliDailySupply) .. ";"
			 .. tostring(dailyKeShiExport) .. ";" .. tostring(dailyTiLiExport) .. ";" .. tostring(dailyChestExport) .. ";" ..tostring(export_keshi) .. ";" .. tostring(export_tili) .. ";"
			 .. tostring(export_chest) .. ";"
		
		return strCmd, tiliDailyMax, pvpcoin, tiliDailyBuyCount, pvpcoin_buy_count, tiliDailySupply, dailyKeShiExport, dailyTiLiExport, dailyChestExport, export_keshi, export_tili, export_chest
	end
	
	--�һ�����
	function TiLiMgr:ExchangeTiLi()
		local ret = 0
		local strCmd = ""
		
		--��ѯ���������Ϣ
		local strCmd, tiliDailyMax, pvpcoin, tiliDailyBuyCount, pvpcoin_buy_count, tiliDailySupply, dailyKeShiExport, dailyTiLiExport, dailyChestExport, export_keshi, export_tili, export_chest = self:QueryInfo()
		
		local tabShopItem = hVar.tab_shopitem[TiLiMgr.EXCHANGE_TILI_SHOPITEM_ID]
		local coseRmb = tabShopItem.rmb or 0 --��Ҫ����Ϸ��
		local itemId = tabShopItem.itemID or 0 --��Ʒ����id
		local tiliAdd = tabShopItem.tili or 0 --���ӵ�����
		
		--������ʣ�๺���Ƿ��㹻
		local leftcount = tiliDailyBuyCount - pvpcoin_buy_count
		if (leftcount > 0) then
			--�۳���Ϸ��
			local bSuccess, order_id = hGlobal.userCoinMgr:DBUserPurchase(self._uid,self._rid, itemId, 1, coseRmb, 0)
			if bSuccess then
				--��������
				local sUpdate = string.format("UPDATE `t_user` SET `pvpcoin` = `pvpcoin` + %d, `pvpcoin_buy_count` = %d, `last_pvpcoin_buy_time` = NOW() WHERE `uid` = %d", tiliAdd, pvpcoin_buy_count + 1, self._uid)
				--print("sUpdate1:",sUpdate)
				xlDb_Execute(sUpdate)
				
				--�����ɹ�
				ret = 1
			else
				ret = -1 --��Ϸ�Ҳ���
			end
		else
			ret = -2 --���նӶһ�����������
		end
		
		strCmd = tostring(ret) .. ";"
		return strCmd
	end
	
	--��ȡ�ڿ��ʯ
	function TiLiMgr:TakeRewardKeShi()
		local ret = 0
		local nTakeRewardKeShiNum = 0
		local strCmd = ""
		
		--��ѯ���������Ϣ
		local strCmd, tiliDailyMax, pvpcoin, tiliDailyBuyCount, pvpcoin_buy_count, tiliDailySupply, dailyKeShiExport, dailyTiLiExport, dailyChestExport, export_keshi, export_tili, export_chest = self:QueryInfo()
		
		--���ʯ��ȡ
		if (export_keshi > 0) then
			local tabShopItem = hVar.tab_shopitem[TiLiMgr.TAKEREWARD_KESHI_SHOPITEM_ID]
			local itemId = tabShopItem.itemID or 0 --��Ʒ����id
			
			nTakeRewardKeShiNum = export_keshi
			
			--���붩��
			hGlobal.userCoinMgr:DBUserPurchase(self._uid,self._rid, itemId, 1, 0, 0)
			
			--������Ϸ��
			hGlobal.userCoinMgr:DBAddGamecoin(self._uid, export_keshi)
			
			--���ȫ�����ڿ��ʯ�ĳ�����ȡʱ��
			--����ʱ���
			local nTimestampNow = os.time()
			
			--��ȡ��������
			local tPet = {}
			local sql = string.format("SELECT `inventoryInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
			local e, inventoryInfo = xlDb_Query(sql)
			--print("sql:",sql,e,inventoryInfo, type(inventoryInfo))
			if (e == 0) then
				if (type(inventoryInfo) == "string") and (#inventoryInfo > 0) then
					inventoryInfo = "{" .. inventoryInfo .. "}"
					local tmp = "local prize = " .. inventoryInfo .. " return prize"
					--������Ϣ��
					tPet = assert(loadstring(tmp))()
				end
			end
			for i = 1, #tPet, 1 do
				local id = tonumber(tPet[i][1]) or 0
				local star_i = tonumber(tPet[i][2]) or 0
				local num = tonumber(tPet[i][3]) or 0
				local level = tonumber(tPet[i][4]) or 0
				local wakuang = tonumber(tPet[i][5]) or 0
				local watili = tonumber(tPet[i][6]) or 0
				local sendtime = tonumber(tPet[i][7]) or 0
				local lastexporttime_wakuang = tonumber(tPet[i][8]) or 0 --�ϴ��ڿ����ʱ��
				local lastexporttime_watili = tonumber(tPet[i][9]) or 0 --�ϴ���������ʱ��
				local lastexporttime_wachest = tonumber(tPet[i][10]) or 0 --�ϴ��ڱ�����ʱ��
				
				if (wakuang == 1) then --���ڿ���
					tPet[i][8] = nTimestampNow
				end
			end
			
			--�浵
			local saveData = ""
			for k = 1, #tPet, 1 do
				local v = tPet[k]
				
				saveData = saveData .. "{"
				for i = 1, #v, 1 do
					saveData = saveData .. (tonumber(v[i]) or 0) .. ","
				end
				saveData = saveData .. "},\n"
			end
			--����
			local sUpdate = string.format("UPDATE `t_cha` SET `inventoryInfo` = '%s' where `id` = %d", saveData, self._rid)
			--print("sUpdate1:",sUpdate)
			xlDb_Execute(sUpdate)
			
			--�����ɹ�
			ret = 1
		else
			ret = -1 --���ʯ����ȡ
		end
		
		strCmd = tostring(ret) .. ";" .. tostring(nTakeRewardKeShiNum) .. ";"
		return strCmd
	end
	
	--��ȡ�ڿ�����
	function TiLiMgr:TakeRewardTiLi()
		local ret = 0
		local nTakeRewardTiLiNum = 0
		local strCmd = ""
		
		--��ѯ���������Ϣ
		local strCmd, tiliDailyMax, pvpcoin, tiliDailyBuyCount, pvpcoin_buy_count, tiliDailySupply, dailyKeShiExport, dailyTiLiExport, dailyChestExport, export_keshi, export_tili, export_chest = self:QueryInfo()
		
		local tabShopItem = hVar.tab_shopitem[TiLiMgr.TAKEREWARD_TILI_SHOPITEM_ID]
		local itemId = tabShopItem.itemID or 0 --��Ʒ����id
		
		--��������ȡ
		if (export_tili > 0) then
			--��ǰ����δ������
			if (pvpcoin < tiliDailyMax) then
				--�����ȡ�����������ޣ���ô����ľ��˷ѵ���
				if ((pvpcoin + export_tili) > tiliDailyMax) then
					export_tili = tiliDailyMax - pvpcoin
				end
				
				local tabShopItem = hVar.tab_shopitem[TiLiMgr.TAKEREWARD_KESHI_SHOPITEM_ID]
				local itemId = tabShopItem.itemID or 0 --��Ʒ����id
				
				nTakeRewardTiLiNum = export_tili
				
				--���붩��
				hGlobal.userCoinMgr:DBUserPurchase(self._uid,self._rid, itemId, 1, 0, 0)
				
				--��������
				local sUpdate = string.format("UPDATE `t_user` SET `pvpcoin` = `pvpcoin` + %d where `uid` = %d", export_tili, self._uid)
				--print("sUpdate1:",sUpdate)
				xlDb_Execute(sUpdate)
				
				--���ȫ�����ڿ��ʯ�ĳ�����ȡʱ��
				--����ʱ���
				local nTimestampNow = os.time()
				
				--��ȡ��������
				local tPet = {}
				local sql = string.format("SELECT `inventoryInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
				local e, inventoryInfo = xlDb_Query(sql)
				--print("sql:",sql,e,inventoryInfo, type(inventoryInfo))
				if (e == 0) then
					if (type(inventoryInfo) == "string") and (#inventoryInfo > 0) then
						inventoryInfo = "{" .. inventoryInfo .. "}"
						local tmp = "local prize = " .. inventoryInfo .. " return prize"
						--������Ϣ��
						tPet = assert(loadstring(tmp))()
					end
				end
				for i = 1, #tPet, 1 do
					local id = tonumber(tPet[i][1]) or 0
					local star_i = tonumber(tPet[i][2]) or 0
					local num = tonumber(tPet[i][3]) or 0
					local level = tonumber(tPet[i][4]) or 0
					local wakuang = tonumber(tPet[i][5]) or 0
					local watili = tonumber(tPet[i][6]) or 0
					local sendtime = tonumber(tPet[i][7]) or 0
					local lastexporttime_wakuang = tonumber(tPet[i][8]) or 0 --�ϴ��ڿ����ʱ��
					local lastexporttime_watili = tonumber(tPet[i][9]) or 0 --�ϴ���������ʱ��
					local lastexporttime_wachest = tonumber(tPet[i][10]) or 0 --�ϴ��ڱ�����ʱ��
					
					if (watili == 1) then --����������
						tPet[i][9] = nTimestampNow
					end
				end
				
				--�浵
				local saveData = ""
				for k = 1, #tPet, 1 do
					local v = tPet[k]
					
					saveData = saveData .. "{"
					for i = 1, #v, 1 do
						saveData = saveData .. (tonumber(v[i]) or 0) .. ","
					end
					saveData = saveData .. "},\n"
				end
				--����
				local sUpdate = string.format("UPDATE `t_cha` SET `inventoryInfo` = '%s' where `id` = %d", saveData, self._rid)
				--print("sUpdate1:",sUpdate)
				xlDb_Execute(sUpdate)
				
				--�����ɹ�
				ret = 1
			else
				ret = -2 --���������޲�����ȡ
			end
		else
			ret = -1 --����������ȡ
		end
		
		strCmd = tostring(ret) .. ";" .. tostring(nTakeRewardTiLiNum) .. ";"
		return strCmd
	end
	
	--��ȡ�ڿ���
	function TiLiMgr:TakeRewardChest()
		local ret = 0
		local nTakeRewardChestNum = 0
		local prizeId = 0
		local prizeType = 0
		local prizeContent = ""
		local strCmd = ""
		
		--��ѯ���������Ϣ
		local strCmd, tiliDailyMax, pvpcoin, tiliDailyBuyCount, pvpcoin_buy_count, tiliDailySupply, dailyKeShiExport, dailyTiLiExport, dailyChestExport, export_keshi, export_tili, export_chest = self:QueryInfo()
		
		local tabShopItem = hVar.tab_shopitem[TiLiMgr.TAKEREWARD_CHEST_SHOPITEM_ID]
		local itemId = tabShopItem.itemID or 0 --��Ʒ����id
		
		--�б�����ȡ
		if (export_chest > 0) then
			local tabShopItem = hVar.tab_shopitem[TiLiMgr.TAKEREWARD_KESHI_SHOPITEM_ID]
			local itemId = tabShopItem.itemID or 0 --��Ʒ����id
			
			nTakeRewardChestNum = export_chest
			
			--���붩��
			hGlobal.userCoinMgr:DBUserPurchase(self._uid,self._rid, itemId, 1, 0, 0)
			
			--����
			--���뽱��
			local id = 20032
			local detail = "Pet Chest Reward;15:" .. TiLiMgr.TAKEREWARD_CHEST_REWARD_CHEST_ID .. ":" .. export_chest .. ":0;"
			local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",self._uid,id,detail,0,0)
			xlDb_Execute(sInsert)
			
			--����id
			local err1, pid = xlDb_Query("select last_insert_id()")
			if (err1 == 0) then
				--�洢������Ϣ
				prizeId = pid --����id
				prizeType = id --��������
				--prizeContent = detail --��������
				
				--����������
				--Ԥ���������ֱ�ӿ����ҵĽ��������ò�ͬ�Ľӿ�
				local fromIdx = 2
				--prizeContent = hApi.GetRewardInPrize(self._uid, self._rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
				prizeContent = hApi.GetRewardInPrize_OpenChest(self._uid, self._rid, prizeId, fromIdx, nil)
				
				--sCmd = tostring(prizeId).. ";" .. tostring(rewardNum or maxReward) .. ";" .. sCmd
			end
			
			--���ȫ�����ڿ��ʯ�ĳ�����ȡʱ��
			--����ʱ���
			local nTimestampNow = os.time()
			
			--��ȡ��������
			local tPet = {}
			local sql = string.format("SELECT `inventoryInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
			local e, inventoryInfo = xlDb_Query(sql)
			--print("sql:",sql,e,inventoryInfo, type(inventoryInfo))
			if (e == 0) then
				if (type(inventoryInfo) == "string") and (#inventoryInfo > 0) then
					inventoryInfo = "{" .. inventoryInfo .. "}"
					local tmp = "local prize = " .. inventoryInfo .. " return prize"
					--������Ϣ��
					tPet = assert(loadstring(tmp))()
				end
			end
			for i = 1, #tPet, 1 do
				local id = tonumber(tPet[i][1]) or 0
				local star_i = tonumber(tPet[i][2]) or 0
				local num = tonumber(tPet[i][3]) or 0
				local level = tonumber(tPet[i][4]) or 0
				local wakuang = tonumber(tPet[i][5]) or 0
				local watili = tonumber(tPet[i][6]) or 0
				local sendtime = tonumber(tPet[i][7]) or 0
				local lastexporttime_wakuang = tonumber(tPet[i][8]) or 0 --�ϴ��ڿ����ʱ��
				local lastexporttime_watili = tonumber(tPet[i][9]) or 0 --�ϴ���������ʱ��
				local lastexporttime_wachest = tonumber(tPet[i][10]) or 0 --�ϴ��ڱ�����ʱ��
				
				if (wakuang == 1) or (watili == 1) then --���ڿ󣬻�����������
					tPet[i][10] = nTimestampNow
				end
			end
			
			--�浵
			local saveData = ""
			for k = 1, #tPet, 1 do
				local v = tPet[k]
				
				saveData = saveData .. "{"
				for i = 1, #v, 1 do
					saveData = saveData .. (tonumber(v[i]) or 0) .. ","
				end
				saveData = saveData .. "},\n"
			end
			--����
			local sUpdate = string.format("UPDATE `t_cha` SET `inventoryInfo` = '%s' where `id` = %d", saveData, self._rid)
			--print("sUpdate1:",sUpdate)
			xlDb_Execute(sUpdate)
			
			--�����ɹ�
			ret = 1
		else
			ret = -1 --�ޱ������ȡ
		end
		
		strCmd = tostring(ret) .. ";" .. tostring(nTakeRewardChestNum) .. ";" .. tostring(prizeType) .. ";" .. tostring(prizeContent)
		return strCmd
	end
	
	--�������(1��)
	function TiLiMgr:Update()
		local self = hGlobal.tiliMgr --self
		
		--�����Ϣ
		local timeNow = hApi.GetClock()
		if (self._statisticsTime > -1) and (timeNow - self._statisticsTime > 1000) then
			local lasttimestamp = self._statisticsTimestamp
			local currenttimestamp = os.time()
			
			self._statisticsTime = timeNow
			self._statisticsTimestamp = currenttimestamp
			
			--����Ƿ���ϵͳ��Ϣ��ÿ�գ�
			local sDate = os.date("%Y-%m-%d", currenttimestamp)
			for i = 1, #TiLiMgr.DAILY_SYSTEM_MAIL_TIME, 1 do
				local sRefreshTime = TiLiMgr.DAILY_SYSTEM_MAIL_TIME[i].time
				local refresh_time = sDate .. " " .. sRefreshTime
				local nRefreshTime = hApi.GetNewDate(refresh_time)
				--print(lasttimestamp, currenttimestamp, nRefreshTime > lasttimestamp, nRefreshTime <= currenttimestamp)
				--print(nRefreshTime)
				if (nRefreshTime > lasttimestamp) and (nRefreshTime <= currenttimestamp) then
					--print("ok")
					--���ʼ�
					--ȡ���յ�0��
					local strDatestampYMD = hApi.Timestamp2Date(currenttimestamp) --ת�ַ���(������)
					local strNewdate = strDatestampYMD .. " 00:00:00"
					local nTimestampZeroB3 = hApi.GetNewDate(strNewdate, "DAY", -3) --��3�յ�½����
					local sDateZeroB3 = os.date("%Y-%m-%d %H:%M:%S", nTimestampZeroB3)
					
					local sQueryM = string.format("SELECT `uid`, `customS1` FROM `t_user` WHERE `last_login_time` >= '%s' ORDER BY `uid` ASC", sDateZeroB3)
					local errM, tTemp = xlDb_QueryEx(sQueryM)
					--print(sQueryM)
					--print("�����ݿ��ȡ���1Сʱ�ڵ�ȫ����������¼:", "errM=", errM, "tTemp=", #tTemp)
					if (errM == 0) then
						for n = 1, #tTemp, 1 do
							local uid = tTemp[n][1]
							local name = tTemp[n][2]
							--print(uid, name)
							local prizeType2 = 20040 --�������б�������ĵĽ���
							local detail2 = string.format(hVar.tab_string["__TEXT_MAIL_TILI_AUTOSEND"], name)
							local sCreateTime = strDatestampYMD .. " 04:50:00"
							--����
							local sInsert = string.format("insert into `prize`(`uid`, `type`, `mykey`, `used`, `create_time`, `create_id`, `days`) values (%d, %d, '%s', %d, '%s', %d, %d)", uid, prizeType2, detail2, 0, sCreateTime, 0, 1)
							xlDb_Execute(sInsert)
						end
					end
				end
			end
		end
	end
	
return TiLiMgr