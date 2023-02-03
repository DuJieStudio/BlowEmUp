--Vip������
local VipMgr = class("VipMgr")
	
	--΢�ų�ֵ��������
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

	--���캯��
	function VipMgr:ctor()
		--����
		return self
	end
	--��ʼ������
	function VipMgr:Init()
		return self
	end

	------------------------------------------------------------private-------------------------------------------------------
	--�����ҳ�ֵ����
	function VipMgr:_DBGetUserTopup(udbid)

		--������ҳ�ֵ����
		local sql = string.format("SELECT SUM(`money`),SUM(`coin_base`),SUM(`coin_base` + `coin_ext`) FROM `iap_record` where `uid`=%d AND `flag` IN (1,4)",udbid)
		local err, money, coin_base, coin = xlDb_Query(sql)
		if err == 0 then
			return tonumber(money) or 0, tonumber(coin_base) or 0, tonumber(coin) or 0
		else
			return 0,0,0
		end
	end

	--������vip�ȼ�
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

	--���һ���Խ����Ƿ񷢷�
	function VipMgr:_DBCheckVipOneoffReward(udbid, vipLv)

		local vipcfg = hVar.Vip_Conifg
		if vipcfg then
			local oneoffReward = vipcfg.oneoffReward
			for v = 1, vipLv do
				if oneoffReward[v] then
					
					local prizeType = VipMgr.ONEOFF_REWARD_TYPE[v]
					
					if prizeType then
						if (type(prizeType) == "number") then --һ���Խ�����һ���ʼ�
							--��������Ƿ���ȡ��һ���Խ���
							local sql = string.format("SELECT count(*) FROM `prize` where `uid`=%d AND `type`=%d",udbid,prizeType)
							local err, count = xlDb_Query(sql)
							if (err == 0 and count == 0) or err == 4 then
								local reward = hClass.Reward:create():Init()
								for i = 1, #oneoffReward[v] do
									reward:Add(oneoffReward[v][i])
								end
								
								--���ﲻ����,�����н�����ȡ
								local insertSql = string.format("INSERT INTO `prize` (`uid`,`type`,`mykey`) VALUES (%d,%d,'%s')", udbid,prizeType,reward:ToCmd())
								--ִ��sql
								xlDb_Execute(insertSql)
							else
								--�м�¼ɶ������
							end
						elseif (type(prizeType) == "table") then --һ���Խ���������ʼ�
							for r = 1, #prizeType, 1 do
								local prizeType_r = prizeType[r]
								
								--��������Ƿ���ȡ��һ���Խ���
								local sql = string.format("SELECT count(*) FROM `prize` where `uid`=%d AND `type`=%d",udbid,prizeType_r)
								local err, count = xlDb_Query(sql)
								if (err == 0 and count == 0) or err == 4 then
									local reward = hClass.Reward:create():Init()
									if oneoffReward[v][r] then
										reward:Add(oneoffReward[v][r])
									end
									
									--���ﲻ����,�����н�����ȡ
									local insertSql = string.format("INSERT INTO `prize` (`uid`,`type`,`mykey`) VALUES (%d,%d,'%s')", udbid,prizeType_r,reward:ToCmd())
									--ִ��sql
									xlDb_Execute(insertSql)
								else
									--�м�¼ɶ������
								end
							end
						end
					end

				end
			end
		end
		
	end
	
	--���vip7��ң�ÿ��ֵ2000Ӧ�û�õĽ���
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

					--��������Ƿ���ȡ��һ���Խ���
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
							--���ﲻ����,�����н�����ȡ
							local insertSql = string.format("INSERT INTO `prize` (`uid`,`type`,`mykey`) VALUES (%d,%d,'%s')", udbid,prizeType,reward:ToCmd())
							--ִ��sql
							xlDb_Execute(insertSql)
						end
					else
						--�м�¼ɶ������

						--print("_DBCheckVip7ExtraReward3:",udbid, err, count)

					end
				end
			end
		end
	end
	
	--����Ƿ���ȡ�����յĽ���1,2,3
	function VipMgr:_DBCheckDailyReward(udbid)
		local ret = true
		local ret2 = true
		local ret3 = true
		
		--[[
		--�ж��Ƿ��Ѿ���ȡ��
		local sql = string.format("SELECT count(*) FROM `t_vip_prize` where `uid`=%d AND DATE(`create_time`)=CURDATE()",udbid)
		local err, count = xlDb_Query(sql)
		if (err == 0 and count == 0) or err == 4 then
			ret = false
		end
		]]
		--��ȡ�ϴ��콱��ʱ��
		local sql = string.format("SELECT `last_vip_prize_get_time`, `last_vip_prize2_get_time`, `last_vip_prize3_get_time` FROM `t_user` WHERE `uid` = %d", udbid)
		local err, strDate, strDate2, strDate3 = xlDb_Query(sql)
		if (err == 0) then
			--��⽱��1�Ƿ�Ϊͬһ��
			local tab1 = os.date("*t", hApi.GetNewDate(strDate))
			local tab2 = os.date("*t", os.time())
			if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --���˵ڶ���
				ret = false
			end
			
			--��⽱��2�Ƿ�Ϊͬһ��
			local tab1 = os.date("*t", hApi.GetNewDate(strDate2))
			--local tab2 = os.date("*t", os.time())
			if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --���˵ڶ���
				ret2 = false
			end
			
			--��⽱��3�Ƿ�Ϊͬһ��
			local tab1 = os.date("*t", hApi.GetNewDate(strDate3))
			--local tab2 = os.date("*t", os.time())
			if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --���˵ڶ���
				ret3 = false
			end
		end
		
		return ret, ret2, ret3
	end
	
	--��ȡ��ҵı߿�ͷ�񡢳ƺ�
	function VipMgr:_DBGetRoleBorderConfig(udbid)
		local borderId = 0
		local iconId = 0
		local championId = 0
		local dragonId = 0
		local headId = 0
		local lineId = 0
		
		--��ȡ��ҵı߿�ͷ�񡢳ƺš�����������ͷ�Ρ�����
		local sql = string.format("SELECT `border`, `icon`, `champion`, `champion_expire_time`, `dragon`, `dragon_expire_time`, `head`, `line` FROM `t_user` where `uid`= %d", udbid)
		local err, border, icon, champion, champion_expire_time, dragon, dragon_expire_time, head, line = xlDb_Query(sql)
		if (err == 0) then
			borderId = border
			iconId = icon
			headId = head
			lineId = line
			
			--���ƺ��Ƿ����
			if (champion > 0) then
				local currenttime = os.time()
				local nExpireTime = hApi.GetNewDate(champion_expire_time)
				
				--δ����
				if (currenttime < nExpireTime) then
					championId = champion
				end
			end
			
			--������������Ƿ����
			if (dragon > 0) then
				local currenttime = os.time()
				local nExpireTime = hApi.GetNewDate(dragon_expire_time)
				
				--δ����
				if (currenttime < nExpireTime) then
					dragonId = dragon
				end
			end
		end
		
		return borderId, iconId, championId, dragonId, headId, lineId
	end
	
	--�������ѻ�õ�ȫ���ƺ�
	function VipMgr:_DBGetRoleChampionList(udbid)
		
		local currenttime = os.time()
		local tChampionList = {}
		
		--�������ѻ�õĳƺţ��Ƿ���ڴ˳ƺ�
		local sQueryM = string.format("SELECT `champion_id`, `expire_time` FROM `t_user_champion` WHERE `uid` = %d", udbid)
		local errM, tTemp = xlDb_QueryEx(sQueryM)
		--print(sQueryM)
		if (errM == 0) then
			--�ƺ���Ϣ
			for n = 1, #tTemp, 1 do
				local champion_id = tTemp[n][1] --�ƺ�id
				local expire_time = tTemp[n][2] --�ƺŹ���ʱ��
				
				local nExpireTime = hApi.GetNewDate(expire_time)
				--δ����
				if (currenttime < nExpireTime) then
					local lefttime = nExpireTime - currenttime
					tChampionList[#tChampionList+1] = {championId = champion_id, lefttime = lefttime, expire_time = expire_time,}
				end
			end
		end
		
		return tChampionList
	end
	
	------------------------------------------------------------public-------------------------------------------------------
	
	--������vip�ȼ�
	function VipMgr:DBGetUserVip(udbid)
		return self:_DBGetUserVip(udbid)
	end
	
	--��ȡVip�б�
	function VipMgr:DBGetUserVipState(udbid)
		
		--��ȡ��ǰvip
		local vipLv, money, coin_base, coin = self:_DBGetUserVip(udbid)
		
		--����������һ��vip,���Ҽ��ÿһ���Ƿ��Ѿ������˽��������û�з����򷢷�
		self:_DBCheckVipOneoffReward(udbid, vipLv)
		
		--���vip7��ң�ÿ��ֵ2000Ӧ�û�õĽ���
		self:_DBCheckVip7ExtraReward(udbid, vipLv, money)
		
		--ÿ�콱���Ƿ��ȡ
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
		
		--��ȡ��ҵı߿�ͷ�񡢳ƺ�
		local borderId, iconId, championId, dragonId, headId, lineId = self:_DBGetRoleBorderConfig(udbid)
		
		--�������vip
		return vipLv, money, coin_base, coin, dailyRewardFlag1, dailyRewardFlag2, dailyRewardFlag3, borderId, iconId, championId, dragonId, headId, lineId
	end
	
	--���ÿ����ȡ����
	function VipMgr:DBGetDailyBonus(udbid, rewardIndex)
		local ret = false
		local ret_prize_id = 0 --����id
		local ret_prize_type = 0 --��������
		local vipcfg = hVar.Vip_Conifg
		if vipcfg then
			local dailyReward = vipcfg.dailyReward
			if dailyReward then
				--��ȡ��ǰvip
				local vipLv = self:_DBGetUserVip(udbid)
				if dailyReward[vipLv] then
					if dailyReward[vipLv][rewardIndex] then
						--�ж��Ƿ��Ѿ���ȡ��
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
							
							--�����ַ���
							local sLog = ""
							
							--����������prize�����ͻ���ͨ���ʼ���ȡ��
							for n = 1,#rewardList do
								local reward = rewardList[n] or {}
								--����ǳ�n�����ƣ���Ҫ������Ӧ������
								if reward[1] == 9 then
									local num = (reward[3] or 1)
									local strReward = (reward[1] or 0)..":"..(reward[2] or 0)..":"..(1)..":"..(reward[4] or 0)..";"
									for p = 1, num do
										--local sLog = string.format("%s;%s",description,strReward)
										--local err, prizeId = hApi.InsertPrize(udbid, 0,hVar.REWARD_LOG_TYPE.activity,sLog,0)--���ʼ�ϵͳ�������һ������state����Ϊ0
										sLog = sLog .. strReward
									end
								else
									local strReward = (reward[1] or 0)..":"..(reward[2] or 0)..":"..(reward[3] or 0)..":"..(reward[4] or 0)..";"
									--local sLog = string.format("%s;%s",description,strReward)
									--local err, prizeId = hApi.InsertPrize(udbid, 0,hVar.REWARD_LOG_TYPE.activity,sLog,0)--���ʼ�ϵͳ�������һ������state����Ϊ0
									sLog = sLog .. strReward
								end
							end
							
							sLog = string.format("%s;%s",description,sLog)
							ret_prize_type = hVar.REWARD_LOG_TYPE.activity
							local err, prizeId = hApi.InsertPrize(udbid, 0,hVar.REWARD_LOG_TYPE.activity,sLog,0)--���ʼ�ϵͳ�������һ������state����Ϊ0
							ret_prize_id = prizeId
							
							--�����콱��¼
							local insertSql = string.format("INSERT INTO `t_vip_prize` (`uid`,`create_time`) VALUES (%d,NOW())", udbid)
							xlDb_Execute(insertSql)
							
							--�����콱ʱ��
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
	
	--΢���û���ֵ���⽱��
	function VipMgr:DBGetWXPrize(uid,iaptype,order)
		
		--�����΢�ų�ֵ����
		if uid and iaptype and order and uid > 0 and iaptype == VipMgr.WX_TOPUP_IAPTYPE then
			
			--�����ֵ�ںϷ���Χ��
			if order >= 1 and order <= 7 and hVar.WX_TOPUP_EX_REWARD[order] then
				local describe = hVar.tab_string["__TEXT_WX_TOPUP"..order] .. hVar.WX_TOPUP_EX_REWARD[order]
				
				local insertSql = string.format("INSERT INTO prize (uid,`type`, mykey) VALUES (%d,20008,'%s')",uid,describe)
				
				--ִ��sql
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

	--��⿪�������������Ƿ���Ҫ�ȴ�ֱ�ӿ�
	function VipMgr:CheckOpenChestFree(udbid)
		local ret = false
		local vipcfg = hVar.Vip_Conifg
		local vipLv = 0
		if vipcfg then
			local openChestFree = vipcfg.openChestFree
			if openChestFree then
				--��ȡ��ǰvip
				vipLv = self:_DBGetUserVip(udbid)
				ret = openChestFree[vipLv]
			end
		end

		return ret,vipLv
	end

	--���vip���ˢ���̳�������
	function VipMgr:GetNetShopRefreshCount(udbid)
		local ret = false
		local vipcfg = hVar.Vip_Conifg
		local vipLv = 0
		if vipcfg then
			local netshopRefreshCount = vipcfg.netshopRefreshCount
			if netshopRefreshCount then
				--��ȡ��ǰvip
				vipLv = self:_DBGetUserVip(udbid)
				ret = netshopRefreshCount[vipLv]
			end
		end

		return ret,vipLv
	end

	--��ȡvip��������
	function VipMgr:GetInventoryCapacity(udbid)
		local ret
		local vipcfg = hVar.Vip_Conifg
		local vipLv = 0
		if vipcfg then
			local bagPageNum = vipcfg.bagPageNum
			if bagPageNum then
				--��ȡ��ǰvip
				vipLv = self:_DBGetUserVip(udbid)
				ret = bagPageNum[vipLv]
			else
				--Ĭ��2ҳ
				ret = 2
			end
		else
			--Ĭ��2ҳ
			ret = 2
		end

		return ret,vipLv
	end

return VipMgr