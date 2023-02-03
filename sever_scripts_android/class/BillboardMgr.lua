--���а������
local BillboardMgr = class("BillboardMgr")
	
	BillboardMgr.__maxReward = 5
	
	BillboardMgr.RANKBOARD_DELTATIME = 60 --��ѯ���а�ļ��ʱ�䣨��λ���룩�����ڲ�ѯ���а��Ż���
	
	--���а�����״̬
	BillboardMgr.TYPE = 
	{
		DAY = 1,		--��
		WEEK = 2,		--��
		MONTH = 3,		--��
	}
	
	--���а�ʱ����bid
	--BillboardMgr.UPDATE_BID_LIST = {1, 2, 11, 12, 21, 22, 4,} --���а�id
	BillboardMgr.UPDATE_BID_LIST = {1, 2,} --���а�id
	
	--���а��������ֵ
	BillboardMgr.MAX_RANK = 9999
	
	--���캯��
	function BillboardMgr:ctor()
		self._timestamp = -1
		self._nextchecktime = -1
		self._template = {}
		
		--���а����ݱ�
		self._billboardData = {}
		
		--����
		self._statisticsTime = -1	--ͳ�����а��ʱ
		self._statisticsTimestamp = -1	--�ϴ�ͳ�����а�ʱ��
		
		return self
	end
	
	--��ʼ������
	function BillboardMgr:Init(timestamp)
		
		--��ʼ��ʱ���
		self._timestamp = timestamp
		
		--������һ�μ�ⷢ��ʱ��(ÿ��0����Ҫ��ⷢ��)
		local datestamp = hApi.Timestamp2Date(hApi.GetNewDate(self._timestamp))
		self._nextchecktime = hApi.GetNewDate(datestamp.." 00:00:00", "DAY", 1) --�ڶ���0���ʱ���
		
		--��ȡģ��
		self:_DBGetBillboardTemplate()
		
		--����Ƿ�Ҫ��������
		--�����Ϊ��׿������������
		if (hVar.IS_MAIN_SERVER == 1) then
			self:_DBCheckReward(datestamp)
		end
		
		--���а����ݱ�
		self._billboardData = {}
		
		--����
		self._statisticsTime = hApi.GetClock()	--ͳ�����а��ʱ
		self._statisticsTimestamp = os.time()	--�ϴ�ͳ�����а�ʱ��
		--print("��ʼ�����а�", os.date("%Y-%m-%d %H:%M:%S", os.time()))
		
		--ȡ���а���������
		for i = 1, #BillboardMgr.UPDATE_BID_LIST, 1 do
			--��ȡָ��bId����������
			local bId = BillboardMgr.UPDATE_BID_LIST[i]
			self:_QueryBillbaordByBID(bId)
		end
		
		return self
	end
	
	--���º���(1����/��)
	function BillboardMgr:Update()
		--local localTime = os.time() --�ͻ���ʱ�� 12:00
		local dbTime = hApi.GetTime()
		
		--�����ǰʱ����ڼ��ʱ�䣬����Ҫ���м��(ÿ��0����Ҫ��ⷢ��)
		if dbTime >= self._nextchecktime then
			local datestamp = hApi.Timestamp2Date(self._nextchecktime)
			
			--����Ƿ�Ҫ������
			--�����Ϊ��׿������������
			if (hVar.IS_MAIN_SERVER == 1) then
				self:_DBCheckReward(datestamp)
			end
			
			--����������һ�μ������
			self._nextchecktime = hApi.GetNewDate(datestamp.." 00:00:00", "DAY", 1) --�ڶ���0���ʱ���
		end
		
		--�������а�
		local timeNow = hApi.GetClock()
		if (self._statisticsTime > -1) and (timeNow - self._statisticsTime > 60000) then
			local lasttimestamp = self._statisticsTimestamp
			local currenttimestamp = os.time()
			
			self._statisticsTime = timeNow
			self._statisticsTimestamp = currenttimestamp
			--print("�������а�", os.date("%Y-%m-%d %H:%M:%S", os.time()))
			
			--��ʱȡ���а���������
			for bId = 1, #BillboardMgr.UPDATE_BID_LIST, 1 do
				--��ȡָ��bId����������
				--self:_QueryBillbaordByBID(bId)
			end
		end
		
		return self
	end
	
	--��ȡָ��bId����������
	function BillboardMgr:_QueryBillbaordByBID(bId)
		--print("BillboardMgr:_QueryBillbaordByBID", bId)
		if bId and self._template[bId] then
			local bbTemplate = self._template[bId]
			local tType = bbTemplate.tType
			local condition = bbTemplate.condition
			--local prize = bbTemplate.prize
			
			local sql = ""
			if (tType == BillboardMgr.TYPE.DAY) then --�հ�
				sql = string.format("SELECT t1.uid,t1.rid,t2.name,t1.%s, t1.cfg FROM leaderboards AS t1 LEFT JOIN t_cha AS t2 ON t1.rid=t2.id where DATE(t1.check_time)=CURDATE() AND t1.leaderboards_id=%d AND t1.%s >= 0 ORDER BY t1.%s DESC, t1.time ASC LIMIT %d",condition,bId,condition,condition,BillboardMgr.MAX_RANK)
			elseif (tType == BillboardMgr.TYPE.MONTH) then --�°�
				local dbTime = hApi.GetTime()
				local tDbtime = os.date("*t",dbTime)
				local day = tonumber(tDbtime.day) or 1
				if (day < 16) then
					condition = bbTemplate.condition1
				end
				
				sql = string.format("SELECT t1.uid,t1.rid,t2.name,t1.%s FROM leaderboards AS t1 LEFT JOIN t_cha AS t2 ON t1.rid=t2.id where DATE_FORMAT(t1.check_time,'%%Y-%%m')=DATE_FORMAT(NOW(),'%%Y-%%m') AND t1.leaderboards_id=%d AND t1.%s >= 0 ORDER BY t1.%s DESC, t1.time ASC LIMIT %d",condition,bId,condition,condition,BillboardMgr.MAX_RANK)
			end
			
			local err, tTemp = xlDb_QueryEx(sql)
			--print("sql:",err,sql)
			
			--�洢��������
			self._billboardData[bId] = {}
			self._billboardData[bId].time = os.time() --�洢���а�Ĳ�ѯʱ�䣨���ڲ�ѯ���а��Ż���
			
			if (err == 0) then
				for n = 1, #tTemp, 1 do
					local uid = tTemp[n][1]
					local rid = tTemp[n][2]
					local name = tTemp[n][3]
					local rank = tTemp[n][4]
					local cfg = tTemp[n][5] or ""
					
					self._billboardData[bId][n] = {uid = uid, rid = rid, name = name, rank = rank, cfg = cfg,}
				end
			end
		end
		
		return self
	end
	
	--������а�ģ������(cmd��ʽ)
	function BillboardMgr:GetBillboardTemplate2Cmd(bId)
		local sCmd = ""
		local billboardNum = 0
		
		if (bId <= 0) then --bIdС�ڵ���0����ʾȡȫ�����а�ľ�̬����
			for bId, template in pairs(self._template) do
				local tType = template.tType
				local openFlag = 1 --�����Ƿ񿪷�
				
				--������а��п�����������Ȿ�ܴ����а��Ƿ񿪷�
				local open_condition = template.prize.open_condition --��������
				if (type(open_condition) == "table") then
					--��ǰΪ��n�ܣ�n���Գ������ó���������������ָ����ֵ�����ܲſ���
					local week_begin = open_condition.week_begin --�Դ�������Ϊ��1��
					local week_divisor = open_condition.week_divisor --����
					local week_module = open_condition.week_module --ģ��
					
					local begintime = hApi.GetNewDate(week_begin) --��1�ܵ�ʱ���
					local timenow = os.time() --���ڵ�ʱ���
					local deltasecond = timenow - begintime
					local deltaweek = math.floor(deltasecond / (3600 * 24 * 7)) + 1 --���������
					
					local modValue = deltaweek % week_divisor --����
					if (modValue == week_module) then
						openFlag = 1 --����
					else
						openFlag = 0 --������
					end
				end
				
				sCmd = sCmd .. tostring(template.id) .. ":"				--���а�id
				sCmd = sCmd .. tostring(template.tType) .. ":"			--���а�����
				sCmd = sCmd .. tostring(openFlag) .. ":"				--�����Ƿ񿪷�
				sCmd = sCmd .. tostring(template.prize.max_rank) .. ":"	--������
				
				--local prize = "{".. template.sPrize .. "}"
				local prize = template.sPrize --geyachao: ��Ϊ��tab�����Դ�����
				--���������DAY���򰴵�ǰ���ڻ�ȡ����
				if (tType == BillboardMgr.TYPE.DAY) then
					--�ͻ���ʱ�� 12:00
					local dbTime = hApi.GetTime()
					local weekDay = hApi.Time2Weekdate(dbTime) or 1
					prize = serialize(template.prize[weekDay] or template.prize[1])
				--���������MONTH���򰴵�ǰ�·ݻ�ȡ����
				elseif (tType == BillboardMgr.TYPE.MONTH) then
					local dbTime = hApi.GetTime()
					local tDbtime = os.date("*t",dbTime)
					local month = tonumber(tDbtime.month) or 1
					prize = serialize(template.prize[month] or template.prize[1])
				end
				
				sCmd = sCmd .. tostring(prize) .. ";"
				
				billboardNum = billboardNum + 1
			end
		else --ȡָ��bId�����а�ľ�̬����
			if self._template[bId] then
				local template = self._template[bId]
				
				local tType = template.tType
				local openFlag = 1 --�����Ƿ񿪷�
				
				--������а��п�����������Ȿ�ܴ����а��Ƿ񿪷�
				local open_condition = template.prize.open_condition --��������
				if (type(open_condition) == "table") then
					--��ǰΪ��n�ܣ�n���Գ������ó���������������ָ����ֵ�����ܲſ���
					local week_begin = open_condition.week_begin --�Դ�������Ϊ��1��
					local week_divisor = open_condition.week_divisor --����
					local week_module = open_condition.week_module --ģ��
					
					local begintime = hApi.GetNewDate(week_begin) --��1�ܵ�ʱ���
					local timenow = os.time() --���ڵ�ʱ���
					local deltasecond = timenow - begintime
					local deltaweek = math.floor(deltasecond / (3600 * 24 * 7)) + 1 --���������
					--print("bId=", bId, "deltaweek=", deltaweek)
					local modValue = deltaweek % week_divisor --����
					--print("modValue=", modValue, "week_module=", week_module)
					if (modValue == week_module) then
						openFlag = 1 --����
					else
						openFlag = 0 --������
					end
				end
				
				sCmd = sCmd .. tostring(template.id) .. ":"				--���а�id
				sCmd = sCmd .. tostring(template.tType) .. ":"			--���а�����
				sCmd = sCmd .. tostring(openFlag) .. ":"				--�����Ƿ񿪷�
				sCmd = sCmd .. tostring(template.prize.max_rank) .. ":"	--������
				
				--local prize = "{".. template.sPrize .. "}"
				local prize = template.sPrize --geyachao: ��Ϊ��tab�����Դ�����
				--���������DAY���򰴵�ǰ���ڻ�ȡ����
				if (tType == BillboardMgr.TYPE.DAY) then
					local dbTime = hApi.GetTime()
					local weekDay = hApi.Time2Weekdate(dbTime) or 1
					prize = serialize(template.prize[weekDay] or template.prize[1])
				--���������MONTH���򰴵�ǰ�·ݻ�ȡ����
				elseif (tType == BillboardMgr.TYPE.MONTH) then
					local dbTime = hApi.GetTime()
					local tDbtime = os.date("*t",dbTime)
					local month = tonumber(tDbtime.month) or 1
					prize = serialize(template.prize[month] or template.prize[1])
				end
				
				sCmd = sCmd .. tostring(prize) .. ";"
				
				billboardNum = billboardNum + 1
			end
		end
		
		sCmd = tostring(bId) .. ";" .. tostring(billboardNum) .. ";" .. sCmd
		
		return sCmd
	end
	
	--������а�(cmd��ʽ)
	function BillboardMgr:DBGetBillboard2Cmd(uId, rId, bId)
		--print("DBGetBillboard2Cmd", uId, rId, bId)
		
		--����ϴβ�ѯ��bId���а����ݵ�ʱ��̫�ã���Ҫ���»�ȡ���а�����
		local lasttime = self._billboardData[bId].time
		local currenetime = os.time()
		local deltatime = currenetime - lasttime
		--print("bId=", bId)
		--print("deltatime=", deltatime)
		if (deltatime > BillboardMgr.RANKBOARD_DELTATIME) then
			self:_QueryBillbaordByBID(bId)
			--print("self:_QueryBillbaordByBID("..bId..")")
		end
		
		local sCmd = ""
		local sCmdMe = ";"
		local num = 0
		
		if bId and self._template[bId] then
			local bbTemplate = self._template[bId]
			local tType = bbTemplate.tType
			local condition = bbTemplate.condition
			local prize = bbTemplate.prize
			
			local max_rank = prize.max_rank or 20
			
			--�ҵ�����
			local rankingMe = 0
			local nameMe = ""
			local rankMe = 0
			for n = 1, #self._billboardData[bId], 1 do
				local billInfo = self._billboardData[bId][n]
				if (billInfo.rid == rId) then --�ҵ���
					rankingMe = n
					nameMe = billInfo.name
					rankMe = billInfo.rank
				end
			end
			
			--�ҵ���������
			sCmdMe = tostring(rankingMe) .. ":" .. tostring(nameMe or "") ..":".. tostring(rankMe or 0) .. sCmdMe
			
			--���а���·�����
			local count = math.min(max_rank, #self._billboardData[bId])
			for n = 1, count, 1 do
				local billInfo = self._billboardData[bId][n]
				local uid = billInfo.uid
				local rid = billInfo.rid
				local name = billInfo.name
				local rank = billInfo.rank
				local cfg = billInfo.cfg
				
				sCmd = sCmd .. tostring(uid)..":" .. tostring(name)..":"..tostring(rank)..";"..tostring(cfg)..";"
				
				num = num + 1
			end
		end
		
		sCmd = tostring(bId).. ";" .. sCmdMe .. tostring(num) .. ";" .. sCmd
		
		return sCmd
	end
	
	--�޾���ͼ������ս��¼id
	function BillboardMgr:GetBillboardBattleCfgId(uId, rId, bId)
		local battlecfg_id = 0
		
		--������һ���޾���ս��¼�������ؼ�¼id
		--����һ��������
		local difficulty = 0
		local batteleCfg = "bId=" .. bId
		local sInsertM = string.format("insert into `log_qunyingge_battleconfig`(`uid`, `rid`, `difficulty`, `battleconfig`, `game_time`, `time_begin`) values(%d, %d, %d, '%s', '', now())", uId, rId, difficulty, batteleCfg)
		xlDb_Execute(sInsertM)
		--print(sInsertM)
		
		--ȡ��ս��¼id
		local err1, oId = xlDb_Query("select last_insert_id()")
		--print("err1,orderId:",err1,orderId)
		if (err1 == 0) then
			battlecfg_id = oId
		else
			
		end
		
		return battlecfg_id
	end
	
	--������ҵ�ǰ�����а�����
	function BillboardMgr:DBUpdateUserBillboardData(uId,rId,bId,rank,cfg)
		
		--����Թ���Ҫ�ﵽ��С���������ϰ�
		if (bId == 1) then --����Թ�
			if (rank >= hVar.RANDOMMAP_RANDBOARD_SCORE_MIN) then
				--�����������
				self:_DBUpdateUserBillboardData(uId,rId,bId,rank,cfg)
			end
		elseif (bId == 2) then --ǰ�����
			if (rank >= hVar.QIANSHAOZHHENDI_RANDBOARD_SCORE_MIN) then
				--�����������
				self:_DBUpdateUserBillboardData(uId,rId,bId,rank,cfg)
			end
		else
			--�����������
			self:_DBUpdateUserBillboardData(uId,rId,bId,rank,cfg)
		end
		
		--ˢ��ָ��bId����������
		--self:_QueryBillbaordByBID(bId)
		
		--ȡ���µ����а�����
		local sCmd = self:DBGetBillboard2Cmd(uId,rId,bId)
		
		return sCmd
	end
	
	--��ý������ѷ�����
	function BillboardMgr:DBGetMailAnnex(uid, rid, prizeId)
		
		--local sCmd = ""
		--local rewardN = 0
		--local sql = string.format("SELECT mykey FROM prize where id=%d AND uid=%d AND rid=%d",prizeId,uid,rid)
		--
		--local err, sMykey = xlDb_Query(sql)
		--if err == 0 then
		--	local tMykey = hApi.Split(sMykey,";")
		--	local n = tonumber(tMykey[1])
		--	local bId = tonumber(tMykey[2])
		--
		--	if bId > 0 and self._template[bId] then
		--		local bbTemplate = self._template[bId]
		--		local prize = bbTemplate.prize
		--		
		--		--������Ʒ�б���ҵ�ǰ��Ҫ���Ľ���
		--		if prize.reward and type(prize.reward) == "table" then
		--			for j = 1, #prize.reward do
		--				local reward = prize.reward[j]
		--				--�����ǰ�����������У��򷢽������
		--				if n >= reward.from and n <= reward.to then
		--					
		--					--�������������а�����Ŀǰֻ������Ϸ�ң�
		--					hApi.RewardPreprocessing(uid, rid, reward, BillboardMgr.__maxReward)
		--					
		--					sCmd = sCmd .. (self:_Reward2Log(reward))
		--					
		--					rewardN = BillboardMgr.__maxReward or #reward
		--					
		--					--�����������ʼ���
		--					hApi.UpdatePrize(prizeId, 1)
		--					
		--					break
		--				end
		--			end
		--		end
		--	end
		--end
		--
		--sCmd = tostring(prizeId).. ";" .. tostring(BillboardMgr.__maxReward) .. ";" .. tostring(rewardN) .. ";" .. sCmd
		--
		--return sCmd
		
		return hApi.GetRewardInPrize(uid, rid, prizeId, 4)
	end
	
	--��ȡ���а�������Ϣ
	function BillboardMgr:_DBGetBillboardTemplate()
		--local sql = string.format("SELECT id, type, condition, prize FROM leaderboards_template")
		local sql = "SELECT id,`type`,`condition`,`condition1`,prize,DATE(last_check_time) FROM leaderboards_template"
		local err,tQuery = xlDb_QueryEx(sql)
		if err==0 then
			for n = 1,#tQuery do
				local id = tQuery[n][1]
				local tType = tQuery[n][2]
				local condition = tQuery[n][3]
				local condition1 = tQuery[n][4]
				--local prize = tQuery[n][5] --geyachao: �Ѹ�Ϊ��tab���ȡ
				local prize = hVar.tab_rankboard_prize[id] --geyachao: �Ѹ�Ϊ��tab���ȡ
				local sPrize = serialize(prize) --geyachao: �Ѹ�Ϊ��tab���ȡ
				local lastCheckTime = tQuery[n][6]
				self._template[id] = 
				{
					id = id,
					tType = tType,
					condition = condition,
					condition1 = condition1,
					--sPrize = prize, --geyachao: �Ѹ�Ϊ��tab���ȡ
					--prize = prize,		--���渳ֵ
					sPrize = sPrize, --geyachao: �Ѹ�Ϊ��tab���ȡ
					prize = prize, --geyachao: �Ѹ�Ϊ��tab���ȡ
					lastCheckTime = lastCheckTime,
				}
				--geyachao: �Ѹ�Ϊ��tab���ȡ
				--[[
				local tmpPrize = {}
				local sAwards = "local tmpPrize = {"..prize.."} return tmpPrize"
				self._template[id].prize = assert(loadstring(sAwards))()
				]]
			end
		end
		return self
	end
	
	--������Ҫ����ļ���¼
	function BillboardMgr:_CaculateCheckTable(checkDate)
		local tQueryCheck = {}
		
		--ɾ��������ҵ�����
		local sqlDelete = string.format("DELETE FROM `leaderboards` WHERE `uid` IN (SELECT `uid` FROM `t_user` WHERE `isCheat` = %d)", 1)
		xlDb_Execute(sqlDelete)
		
		--���check��
		for bId,bbTemplate in pairs(self._template) do
			
			local tType = bbTemplate.tType
			
			--�洢��ѯ������Ϣ
			tQueryCheck[bId] = {}
			
			if tType == BillboardMgr.TYPE.DAY then
				
				--��һ�μ�����а���ʱ��
				local lastCheckDate = bbTemplate.lastCheckTime
				--��Ҫ����ʱ�䷶Χ���ַ�����
				local sFTime = lastCheckDate.." 00:00:00"
				local sTTime = checkDate.." 00:00:00"
				--��Ҫ����ʱ�䷶Χת��Ϊ��ֵ
				local nFTime = hApi.GetNewDate(sFTime)
				local nTTime = hApi.GetNewDate(sTTime)
				--��Ҫ����ʱ�������
				local sTimeStamp = sFTime
				local nTimeStamp = nFTime
				local tTimeStamp = {}
				--ѭ�����������ʱ�������ڵ���������
				while (nTimeStamp < nTTime) do
					local sDate = os.date("%Y-%m-%d", nTimeStamp)
					--�����һ�η���������ʱ���
					tTimeStamp[sDate] = true
					
					--ʱ���+1day
					nTimeStamp = hApi.GetNewDate(sTimeStamp, "DAY", 1)
					sTimeStamp = os.date("%Y-%m-%d %H:%M:%S", nTimeStamp)
				end
				
				--��һ���⣬���ҳ�ʱ�����û�м�¼����Ŀ
				local sql = string.format("SELECT id,leaderboards_id,DATE(check_time),result FROM leaderboards_check where DATE(check_time)>='%s' AND DATE(check_time)<'%s' AND leaderboards_id=%d and `tType` = %d",sFTime,sTTime,bId, tType)
				local err,tTemp = xlDb_QueryEx(sql)
				if err == 0 then
					for n = 1,#tTemp do
						--��ѯ���ļ�¼��ӵ���¼��
						tQueryCheck[bId][#tQueryCheck[bId] + 1] = tTemp[n]
						local date = tTemp[n][3]
						--ʱ����д��ڼ�¼�����ʱ���
						if tTimeStamp[date] then
							tTimeStamp[date] = nil
						end
					end
				end
				
				--����ʱ���������û�м�¼����Ŀ
				for date, _ in pairs(tTimeStamp) do
					--�����¼
					local sql1 = string.format("INSERT INTO leaderboards_check (leaderboards_id,check_time, `tType`, result) values (%d,'%s', %d, '%s')",bId, date, tType, "flag=0,")--.." 00:00:00")
					xlDb_Execute(sql1)
					
					--���Ҹղ���ļ�¼
					local sql2 = string.format("SELECT id,leaderboards_id,DATE(check_time),result FROM leaderboards_check where DATE(check_time)='%s' AND leaderboards_id=%d and `tType` = %d",date,bId, tType)
					local err1,id,leaderboards_id,dateNew,result = xlDb_Query(sql2)
					if err1 == 0 then
						--��ѯ���ļ�¼��ӵ���¼��
						tQueryCheck[bId][#tQueryCheck[bId] + 1] = {id,leaderboards_id,dateNew,result}
					end
				end
			elseif tType == BillboardMgr.TYPE.MONTH then
				--��һ�μ�����а���ʱ��
				local lastCheckDate = bbTemplate.lastCheckTime
				--��Ҫ����ʱ�䷶Χ���ַ�����
				local sFTime = lastCheckDate.." 00:00:00"
				local sTTime = checkDate.." 00:00:00"
				local nFTime = hApi.GetNewDate(sFTime)
				local nTTime = hApi.GetNewDate(sTTime)
				
				local tFTime = os.date("*t", nFTime)
				local tTTime = os.date("*t", nTTime)
				
				--print("BillboardMgr.TYPE.MONTH:",sFTime,nFTime,tFTime)
				--print("BillboardMgr.TYPE.MONTH:",sTTime,nTTime,tTTime)
				
				local tmpTime = {}
				tmpTime.year = tFTime.year
				tmpTime.month = tFTime.month
				tmpTime.day = tFTime.day
				tmpTime.hour = 0--tFTime.hour
				tmpTime.min = 0--tFTime.min
				tmpTime.sec = 0--tFTime.sec
				
				local tTimeStamp = {}
				
				--������Ҫ����ʱ���
				while not ((tmpTime.year > tTTime.year) or (tmpTime.year == tTTime.year and tmpTime.month > tTTime.month)) do
					
					--ÿ��1��00:00:00����ϸ��µ�
					tmpTime.day = 1
					local nTmpDate = os.time(tmpTime)
					local sTmpDate = os.date("%Y-%m-%d", nTmpDate)
					if nTmpDate > nFTime and nTmpDate <= nTTime then
						--�����һ�η���������ʱ���
						tTimeStamp[sTmpDate] = true
					end
					
					--ÿ��16��00:00:00��Ȿ�µ�
					tmpTime.day = 16
					nTmpDate = os.time(tmpTime)
					sTmpDate = os.date("%Y-%m-%d", nTmpDate)
					if nTmpDate > nFTime and nTmpDate <= nTTime then
						--�����һ�η���������ʱ���
						tTimeStamp[sTmpDate] = true
					end
					
					--������һ����
					tmpTime.month = tmpTime.month + 1
					if tmpTime.month > 12 then
						tmpTime.month = 1
						tmpTime.year = tmpTime.year + 1
					end
				end
				
				--��һ���⣬���ҳ�ʱ�����û�м�¼����Ŀ
				local sql = string.format("SELECT id,leaderboards_id,DATE(check_time),result FROM leaderboards_check where DATE(check_time)>'%s' AND DATE(check_time)<='%s' AND leaderboards_id=%d and `tType` = %d",sFTime,sTTime,bId, tType)
				local err,tTemp = xlDb_QueryEx(sql)
				if err == 0 then
					for n = 1,#tTemp do
						--��ѯ���ļ�¼��ӵ���¼��
						tQueryCheck[bId][#tQueryCheck[bId] + 1] = tTemp[n]
						local date = tTemp[n][3]
						
						--print("date:",date)
						--ʱ����д��ڼ�¼�����ʱ���
						if tTimeStamp[date] then
							tTimeStamp[date] = nil
						end
					end
				end
				
				--����ʱ���������û�м�¼����Ŀ
				for date, _ in pairs(tTimeStamp) do
					--�����¼
					local sql1 = string.format("INSERT INTO leaderboards_check (leaderboards_id,check_time, `tType`, result) values (%d,'%s', %d, '%s')",bId, date, tType, "flag=0,")--.." 00:00:00")
					xlDb_Execute(sql1)
					--print("sql1:",sql1)
					
					--���Ҹղ���ļ�¼
					local sql2 = string.format("SELECT id,leaderboards_id,DATE(check_time),result FROM leaderboards_check where DATE(check_time)='%s' AND leaderboards_id=%d and `tType` = %d",date,bId, tType)
					local err1,id,leaderboards_id,dateNew,result = xlDb_Query(sql2)
					--print("sql2:",sql2,err1)
					if err1 == 0 then
						--��ѯ���ļ�¼��ӵ���¼��
						tQueryCheck[bId][#tQueryCheck[bId] + 1] = {id,leaderboards_id,dateNew,result}
					end
				end
			end
		end
		
		return tQueryCheck
	end
	
	--������а��Ƿ���Ҫ��������
	function BillboardMgr:_DBCheckReward(checkDate)
		
		local tQueryCheck = self:_CaculateCheckTable(checkDate)
		
		--����check���в�ѯ���ļ�¼
		for bId, checkList in pairs(tQueryCheck) do
			
			local bbTemplate = self._template[bId]
			local tType = bbTemplate.tType
			local prize = bbTemplate.prize
			
			for i = 1, #checkList do
				local id = checkList[i][1]
				local date = checkList[i][3]
				local sTmp = "local tmp = {"..checkList[i][4].."} return tmp"
				local result = assert(loadstring(sTmp))()
				
				--�����û�з���������Ҫ����(Ŀǰδ����result.flag = 1�Ĳ�������)
				if not result.flag or result.flag == 0 then
					local sql = ""
					local condition = bbTemplate.condition
					--���������1�����а�ÿ�յ����ò�һ��
					if tType == BillboardMgr.TYPE.DAY then
						local weekDay = hApi.Time2Weekdate(date.." 00:00:00") or 1
						prize = bbTemplate.prize[weekDay] or bbTemplate.prize[1]
						--sql = string.format("SELECT uid,rid FROM leaderboards where DATE(check_time)='%s' AND leaderboards_id=%d AND %s>0 ORDER BY %s DESC LIMIT %d",date,bId,condition,condition,(bbTemplate.prize.max_rank or 20))
						--�޾�
						--ÿ�����а�ֻҪ������˶��н���
						sql = string.format("SELECT uid,rid FROM leaderboards where DATE(check_time)='%s' AND leaderboards_id=%d AND %s>=0 ORDER BY %s DESC, time ASC",date,bId,condition,condition)
					elseif tType == BillboardMgr.TYPE.MONTH then
						
						
						
						local nDate = hApi.GetNewDate(date.." 00:00:00")
						local tDate = os.date("*t", nDate)
						local prizeType = "mom"
						
						
						
						--�����1�գ���Ҫȡ�ϸ��µ�����
						if tonumber(tDate.day) == 1 then
							tDate.month = tDate.month - 1
							if tDate.month < 1 then
								tDate.month = 12
								tDate.year = tDate.year - 1
							end
							prizeType = "eom"
						else
							--����ǰ��£�����������
							condition = bbTemplate.condition1
						end
						
						print("date:",date,tDate.day,condition,bbTemplate.condition1,bbTemplate.condition)
						
						local checkmonth = os.date("%Y-%m", os.time(tDate))
						prize = bbTemplate.prize[tDate.month][prizeType] or bbTemplate.prize[1][prizeType]
						sql = string.format("SELECT uid,rid FROM leaderboards where DATE_FORMAT(check_time,'%%Y-%%m')='%s' AND leaderboards_id=%d AND %s >= 0 ORDER BY %s DESC, time ASC LIMIT %d",checkmonth,bId,condition,condition,(bbTemplate.prize.max_rank or 20))
					end
					
					local err, tTemp = xlDb_QueryEx(sql)
					--print("sql:",sql, err)
					local pListLog = ""
					local broadcastName = nil --ǰ10���������
					if err == 0 then
						--����
						if (tType == BillboardMgr.TYPE.DAY) then --ÿ�հ�
							--�޾�
							--ÿ�����а�ֻҪ������ˣ����н���
							for n = 1, #tTemp, 1 do
								local uid = tTemp[n][1]
								local rid = tTemp[n][2]
								
								pListLog = pListLog.. "{" .. tostring(uid)..","..tostring(rid).."},"
								
								--������Ʒ�б���ҵ�ǰ��Ҫ���Ľ���
								if prize.reward and type(prize.reward) == "table" then
									--�����н������������
									local maxRank = bbTemplate.prize.max_rank or 20
									--print("n=", n, "maxRank=", maxRank)
									if (n <= maxRank) then
										--ǰ10�������������
										if (n <= 10) then
											--��ʼ��
											if (broadcastName == nil) then
												broadcastName = ""
											end
											
											local sql = string.format("SELECT `name` FROM `t_cha` where `id`= %d", rid)
											local err, name = xlDb_Query(sql)
											--print("err=", err, "name=", name)
											if (err == 0) then
												broadcastName = broadcastName .. name .. ";"
											else
												--��ѯ����ʧ�ܣ���ʾuid
												broadcastName = broadcastName .. tostring(uid) .. ";"
											end
										end
										
										--���Ҫ���ڼ����Ľ���
										for j = 1, #prize.reward, 1 do
											local reward = prize.reward[j]
											--�����ǰ�����������У��򷢽������
											if (n >= reward.from) and (n <= reward.to) then
												--�������������а�����Ŀǰֻ������Ϸ�ң�
												--hApi.RewardPreprocessing(uid, rid, reward, BillboardMgr.__maxReward)
												
												--����
												local strReward = ""
												
												--����������prize���ͻ���ͨ���ʼ���ȡ��
												for p = 1,BillboardMgr.__maxReward do
													local v = reward[p]
													if v then
														--����ǳ�n�����ƣ���Ҫ������Ӧ������
														if v[1] == 9 then
															--[[
															local num = (v[3] or 1)
															local reward = (v[1] or 0)..":"..(v[2] or 0)..":"..(1)..":"..(v[4] or 0)..";"
															for p = 1, num do
																--local sLog = string.format("%d;%d;%s;%s",n,bId,date,reward)
																--local err, prizeId = hApi.InsertPrize(uid, rid,hVar.REWARD_LOG_TYPE.billboard,sLog,0)--���ʼ�ϵͳ�������һ������state����Ϊ0
																strReward = strReward .. reward
															end
															]]
															--geyachao: ���ڳ鿨Ҳ֧��һ�γ�����
															local reward = (v[1] or 0)..":"..(v[2] or 0)..":"..(v[3] or 0)..":"..(v[4] or 0)..";"
															--local sLog = string.format("%d;%d;%s;%s",n,bId,date,reward)
															--local err, prizeId = hApi.InsertPrize(uid, rid,hVar.REWARD_LOG_TYPE.billboard,sLog,0)--���ʼ�ϵͳ�������һ������state����Ϊ0
															strReward = strReward .. reward
														else
															local reward = (v[1] or 0)..":"..(v[2] or 0)..":"..(v[3] or 0)..":"..(v[4] or 0)..";"
															--local sLog = string.format("%d;%d;%s;%s",n,bId,date,reward)
															--local err, prizeId = hApi.InsertPrize(uid, rid,hVar.REWARD_LOG_TYPE.billboard,sLog,0)--���ʼ�ϵͳ�������һ������state����Ϊ0
															strReward = strReward .. reward
														end
													end
												end
												
												--��ʽ: "ÿ�����е�ͼ����;2018-10-15;rid;rank;logId;����1;����2;����3;"
												local sLog = string.format("%s;%s;%d;%d;%d;%s",hVar.tab_string["__TEXT_ENDLESS_RANKBOARD"],date,bId,n,id,strReward)
												local err, prizeId = hApi.InsertPrize(uid, rid,hVar.REWARD_LOG_TYPE.billboardEndless,sLog,0)--���ʼ�ϵͳ�������һ������state����Ϊ0
												
												--����check��״̬
												self:_DBUpdateCheck(id,1,pListLog)
												
												break
											end
										end
									else
										--������ÿ�����е�ͼ������δ�ϰ񣬷�100������ΪС����
										
										--����������prize���ͻ���ͨ���ʼ���ȡ��
										--��ʽ: "ÿ�����е�ͼ����;2018-10-15;rid;rank;logId;����;"
										local strReward = "7:2:0:0;"
										local sLog = string.format("%s;%s;%d;%d;%d;%s",hVar.tab_string["__TEXT_ENDLESS_RANKBOARD"],date,bId,n,id,strReward)
										local err, prizeId = hApi.InsertPrize(uid, rid,hVar.REWARD_LOG_TYPE.billboardEndless,sLog,0)--���ʼ�ϵͳ�������һ������state����Ϊ0
										
										--����check��״̬
										self:_DBUpdateCheck(id,1,pListLog)
									end
								end
							end
						else --�°���������͵İ�
							--����
							for n = 1, #tTemp do
								local uid = tTemp[n][1]
								local rid = tTemp[n][2]
								
								pListLog = pListLog.. "{" .. tostring(uid)..","..tostring(rid).."},"
								
								--������Ʒ�б���ҵ�ǰ��Ҫ���Ľ���
								if prize.reward and type(prize.reward) == "table" then
									for j = 1, #prize.reward do
										local reward = prize.reward[j]
										--�����ǰ�����������У��򷢽������
										if n >= reward.from and n <= reward.to then
											--�������������а�����Ŀǰֻ������Ϸ�ң�
											--hApi.RewardPreprocessing(uid, rid, reward, BillboardMgr.__maxReward)
											
											--�����ַ���
											local strReward = ""
											
											--����������prize���ͻ���ͨ���ʼ���ȡ��
											for p = 1,BillboardMgr.__maxReward do
												local v = reward[p] or {}
												--����ǳ�n�����ƣ���Ҫ������Ӧ������
												if v[1] == 9 then
													--[[
													local num = (v[3] or 1)
													local strRewardTemp = (v[1] or 0)..":"..(v[2] or 0)..":"..(1)..":"..(v[4] or 0)..";"
													for p = 1, num do
														--local sLog = string.format("%d;%d;%s;%s",n,bId,date,strReward)
														--local err, prizeId = hApi.InsertPrize(uid, rid,hVar.REWARD_LOG_TYPE.billboard,sLog,0)--���ʼ�ϵͳ�������һ������state����Ϊ0
														strReward = strReward .. strRewardTemp
													end
													]]
													--geyachao: ���ڳ鿨Ҳ֧��һ�γ�����
													local strRewardTemp = (v[1] or 0)..":"..(v[2] or 0)..":"..(v[3] or 0)..":"..(v[4] or 0)..";"
													strReward = strReward .. strRewardTemp
												else
													local strRewardTemp = (v[1] or 0)..":"..(v[2] or 0)..":"..(v[3] or 0)..":"..(v[4] or 0)..";"
													--local sLog = string.format("%d;%d;%s;%s",n,bId,date,strReward)
													--local err, prizeId = hApi.InsertPrize(uid, rid,hVar.REWARD_LOG_TYPE.billboard,sLog,0)--���ʼ�ϵͳ�������һ������state����Ϊ0
													strReward = strReward .. strRewardTemp
												end
											end
											
											--����
											local sLog = string.format("%d;%d;%s;%s",n,bId,date,strReward)
											local err, prizeId = hApi.InsertPrize(uid, rid,hVar.REWARD_LOG_TYPE.billboard,sLog,0)--���ʼ�ϵͳ�������һ������state����Ϊ0
											
											--����check��״̬
											self:_DBUpdateCheck(id,1,pListLog)
											
											break
										end
									end
								end
							end
						end
					end
					--print("broadcastName=", broadcastName)
					--����check��״̬
					self:_DBUpdateCheck(id,2,pListLog,broadcastName)
					
					--����ģ���״̬
					self:_DBUpdateTemplate(bId,date)
					self._template[bId].lastCheckTime = date
				end
			end
		end
	end
	
	--����ת��Ϊ��־
	function BillboardMgr:_Reward2Log(reward)
		if type(reward)=="table" then
			local tTemp = {}
			for i = 1,BillboardMgr.__maxReward do
				local v = reward[i] or {}
				tTemp[#tTemp+1] = (v[1] or 0)..":"..(v[2] or 0)..":"..(v[3] or 0)..":"..(v[4] or 0)..";"
			end
			if #tTemp>0 then
				return table.concat(tTemp)
			end
		end
		return ""
	end
	
	--����check��
	function BillboardMgr:_DBUpdateCheck(id,state,pListLog,broadcastName)
		local result = "flag=" .. tostring(state).. "," .. tostring(pListLog)
		local sql = string.format("UPDATE leaderboards_check SET result='%s' WHERE id=%d",result,id)
		
		--����ǰ10�������֣�Ҳһ������
		if (type(broadcastName) == "string") then
			sql = string.format("UPDATE leaderboards_check SET result='%s',broadcast_name='%s' WHERE id=%d",result,broadcastName,id)
		end
		
		xlDb_Execute(sql)
	end
	
	--����ģ�������������
	function BillboardMgr:_DBUpdateTemplate(id,date)
		local sql = string.format("UPDATE leaderboards_template SET last_check_time='%s' WHERE id=%d AND '%s' > DATE(last_check_time)",date,id,date)
		xlDb_Execute(sql)
	end
	
	--������ҵ����а�����
	function BillboardMgr:_DBUpdateUserBillboardData(uId,rId,bId,rank,cfg)
		if bId and self._template[bId] then
			local bbTemplate = self._template[bId]
			local condition = bbTemplate.condition
			
			local sql, id = string.format("SELECT `id` FROM leaderboards where uid=%d AND DATE(check_time)=CURDATE() AND leaderboards_id=%d",uId,bId)
			local err, id = xlDb_Query(sql)
			if err == 0 then --�м�¼
				sql = string.format("UPDATE leaderboards SET %s=%d,rid=%d, `cfg` = '%s' WHERE `id` = %d AND `%s` < %d",condition,rank,rId,cfg,id,condition,rank)
				xlDb_Execute(sql)
			else
				--�����¼
				sql = string.format("INSERT INTO leaderboards (uid,rid,check_time,%s,leaderboards_id, `cfg`) values (%d,%d,CURDATE(),%d,%d, '%s')",condition,uId,rId,rank,bId, cfg)
				xlDb_Execute(sql)
			end
			
			--[[
			--����ÿ�������£�
			--�޾���ͼ
			if (bId == 1) or (bId == 11) or (bId == 21) then
				local taskType = hVar.TASK_TYPE.TASK_ENDLESS_SCORE --�޾�ʹ��
				local taskMgr = hClass.TaskMgr:create("TaskMgr"):Init(uId, rId)
				taskMgr:AddTaskFinishCount(taskType, rank)
			end
			]]
		end
	end
	
return BillboardMgr