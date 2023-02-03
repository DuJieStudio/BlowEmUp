--�¿�������
local MonthCard = class("MonthCard")
	--�¿���ֵ�ɹ�����
	MonthCard.TOUP =
	{
		type = 20031,
		title = hVar.tab_string["__TEXT_MONTHCARD_TOPUP_TITLE"],
		attachment = hVar.tab_string["__TEXT_MONTHCARD_TOPUP_CONTENT"],
		prize = hVar.tab_string["__TEXT_MONTHCARD_TOPUP_PRIZE"],
	}
	
	--�¿�ÿ�շ���-��Ϸ��
	MonthCard.DAYREWARD_COIN =
	{
		type = 20031,
		title = hVar.tab_string["__TEXT_MONTHCARD_PRIZE_TITLE"],
		attachment = hVar.tab_string["__TEXT_MONTHCARD_PRIZE_CONTENT"],
		prize = hVar.tab_string["__TEXT_MONTHCARD_PRIZE_PRIZE"],
	}
	
	--[[
	--�¿�ÿ�շ���Ӣ�۽���(5ѡ2)
	MonthCard.DAYREWARD_DERBIRS =
	{
		type = 20028,
		title = hVar.tab_string["__TEXT_MONTHCARD_PRIZE_TITLE"],
		heroTotalNum = 5, --����Ӣ��������
		heroSelectNum = 2, --����Ӣ��ѡ������
		
		prizeType = 13, --13:�������鿨�ཱ��
		
		--Ӣ�۵��б�(�������콱��������������ЩӢ��)
		prize =
		{
			{from = 0, to = 20, heroDerbirs = {10201,10202,10203,10208,10205,10210,10206,},}, --����,����,�ŷ�,����,�ܲ�,�ĺ,̫ʷ��
			{from = 21, to = 40, heroDerbirs = {10207,10214,10216,10215,10211,10212,10227,},}, --����,����,��Τ,����,����,����,��ڼ
			{from = 41, to = 60, heroDerbirs = {10225,10218,10219,10223,10228,10220,10221,10226,},}, --����,���,���,��Ȩ,������,����,�����,����Ӣ
			{from = 61, to = 99999, heroDerbirs = {10206,10216,10211,10212,10227,10225,10223,10228,10220,10221,10226,},}, --̫ʷ��,��Τ,����,����,��ڼ,����,��Ȩ,������,����,�����,����Ӣ,
		},
		
		debrisNum = 3, --ÿ��Ӣ�۽�������
	}
	]]
	
	--���캯��
	function MonthCard:ctor()
		self._uid = -1
		
		return self
	end
	
	--��ʼ��
	function MonthCard:Init(uid, channelId, iDays)
		self._uid = uid
		
		return self
	end
	
	--�����¿���ֵ�ɹ�����
	function MonthCard:RewardMonthCardToup()
		--[[
		local sql = string.format("insert into `prize`(`uid`, `type`, `mykey`) values (%d, %d, '%s')", self._uid, MonthCard.TOUP.type, MonthCard.TOUP.title .. MonthCard.TOUP.attachment .. MonthCard.TOUP.prize)
		xlDb_Execute(sql)
		]]
		
		--geyachao: ս����Ϊֱ�Ӽ���Ϸ��
		local sql = string.format("UPDATE `t_user` SET `gamecoin_online` = `gamecoin_online` + 300 WHERE `uid` = %d", self._uid)
		xlDb_Execute(sql)
	end
	
	--�����¿����ս���
	function MonthCard:CheckTodayMonthCardReward()
		--�¿�״̬���¿�ʣ����Ч����
		local nIsMonthCard = 0
		local nLeftDay = 0
		
		--��ѯ����¿�״̬����ȡ״̬
		local sql = string.format("select `month_card_overtime`, `last_month_card_prize_get_time`, `month_card_totaldays` from `t_user` where `uid` = %d", self._uid)
		local iErrorCode, strMonthCardOvetTime, strMonthCardPrizeGetTime, nMonthCardTotalDays = xlDb_Query(sql)
		--print(iErrorCode, strMonthCardOvetTime, strMonthCardPrizeGetTime, nMonthCardTotalDays)
		
		if (iErrorCode == 0) then
			local nTimestampNow = os.time() --������ʱ��
			local nOverTime = hApi.GetNewDate(strMonthCardOvetTime) --�¿�ʧЧʱ��
			
			--���¿���Ч����
			if (nTimestampNow < nOverTime) then
				--print("���¿���Ч����")
				nIsMonthCard = 1
				
				--�����¿�ʣ����Ч����
				nLeftDay = math.ceil((nOverTime - nTimestampNow) / 86400)
				--print("nLeftDay=", nLeftDay)
				
				--ת��Ϊ�������ϴ��¿��콱ʱ���0��+1���ʱ���
				local nPrizeTimestamp = hApi.GetNewDate(strMonthCardPrizeGetTime) --�ϴ��¿��콱ʱ��
				local strPrizeDatestampYMD = hApi.Timestamp2Date(nPrizeTimestamp) --ת�ַ���(������)
				local strPrizeNewdate = strPrizeDatestampYMD .. " 00:00:00"
				local nPrizeTimestampTodayZero = hApi.GetNewDate(strPrizeNewdate, "DAY", 1)
				
				--��������Ч����
				if (nTimestampNow >= nPrizeTimestampTodayZero) then
					--print("�������콱��Ч����")
					--����
					--����Ϸ��
					local mykey = string.format(MonthCard.DAYREWARD_COIN.title .. MonthCard.DAYREWARD_COIN.attachment .. MonthCard.DAYREWARD_COIN.prize, nLeftDay)
					local sqlInsert = string.format("insert into `prize`(`uid`, `type`, `mykey`) values (%d, %d, '%s')", self._uid, MonthCard.DAYREWARD_COIN.type, mykey)
					xlDb_Execute(sqlInsert)
					
					--geyachao: ս������������
					--[[
					--��Ӣ�۽���
					--����200��Ϸ�ҽ���;13:1:10:5_10201_10_0|5_10202_10_0|5_10208_10_0|5_10207_10_0|5_10223_10_0;
					local sPrize = ""
					
					local title = MonthCard.DAYREWARD_DERBIRS.title --��������
					local heroTotalNum = MonthCard.DAYREWARD_DERBIRS.heroTotalNum --����Ӣ��������
					local heroSelectNum = MonthCard.DAYREWARD_DERBIRS.heroSelectNum --����Ӣ��ѡ������
					local prizeType = MonthCard.DAYREWARD_DERBIRS.prizeType --�����ķ�������
					local debrisNum = MonthCard.DAYREWARD_DERBIRS.debrisNum --ÿ��Ӣ�۽�������
					
					sPrize = sPrize .. title .. prizeType .. ":" .. heroSelectNum .. ":" .. debrisNum .. ":"
					
					--�������Ӣ�۽����
					local heroDerbirsCopy = {}
					for i = 1, #MonthCard.DAYREWARD_DERBIRS.prize, 1 do
						local from = MonthCard.DAYREWARD_DERBIRS.prize[i].from
						local to = MonthCard.DAYREWARD_DERBIRS.prize[i].to
						if (nMonthCardTotalDays >= from) and (nMonthCardTotalDays <= to) then --�ҵ���
							--heroDerbirsCopy = MonthCard.DAYREWARD_DERBIRS.prize[i].heroDerbirs
							--��������
							for d = 1, #MonthCard.DAYREWARD_DERBIRS.prize[i].heroDerbirs, 1 do
								heroDerbirsCopy[#heroDerbirsCopy+1] = MonthCard.DAYREWARD_DERBIRS.prize[i].heroDerbirs[d]
							end
							
							break
						end
					end
					
					--����޳���ֻʣ5��
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
					
					--������
					local mykey = string.format(MonthCard.DAYREWARD_COIN.title .. MonthCard.DAYREWARD_COIN.attachment .. MonthCard.DAYREWARD_COIN.prize, nLeftDay)
					local sqlInsert = string.format("insert into `prize`(`uid`, `type`, `mykey`) values (%d, %d, '%s')", self._uid, MonthCard.DAYREWARD_DERBIRS.type, sPrize)
					xlDb_Execute(sqlInsert)
					]]
					
					--���½����¿��콱ʱ��
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