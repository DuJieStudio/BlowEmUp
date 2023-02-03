--ս�����а������
local TankBillboardMgr = class("TankBillboardMgr")
	
	TankBillboardMgr.MAX_RANK = 100
	
	--���״̬
	TankBillboardMgr.TYPE = 
	{
		DAY = 1,		--��
		WEEK = 2,		--��
		MONTH = 3,		--��
	}
	
	--���캯��
	function TankBillboardMgr:ctor()
		self._timestamp = -1
		self._nextchecktime = -1
		self._bollboardData = -1
		
		--����
		return self
	end
	
	--��ʼ������
	function TankBillboardMgr:Init()
		--��ʼ��ʱ���
		local timestamp = os.time()
		self._timestamp = timestamp
		
		--������һ�μ�ⷢ��ʱ��(ÿ��0����Ҫ��ⷢ��)
		local datestamp = hApi.Timestamp2Date(self._timestamp)
		--print("datestamp=", datestamp)
		self._nextchecktime = hApi.GetNewDate(datestamp .." 00:00:00", "DAY", 1) --�ڶ���0���ʱ���
		
		--����Ƿ�Ҫ��������
		self:_DBCheckReward(datestamp)
		
		return self
	end
	
	--������а��Ƿ���Ҫ��������
	function TankBillboardMgr:_DBCheckReward(checkDate)
		--��ʼ��
		self._bollboardData = {}
		
		--��ѯ�������Ƿ��м�¼
		local bId = hVar.TANK_BILLBOARD_RANK_TYPE.RANK_STAGE --��ͼ���а�
		local sql = string.format("SELECT `billboard` FROM `tank_billboard_check` where `bid` = %d and DATE(`time`)='%s'", bId, checkDate)
		local err, billboardInfo = xlDb_Query(sql)
		--print(sql)
		--print(err)
		if (err == 0) then
			--������
			local tMykey = hApi.Split(billboardInfo, ";")
			--print(billboardInfo)
			local COUNT = tonumber(tMykey[1]) or 0
			local rIdx = 1
			for i = 1 + rIdx, COUNT + rIdx, 1 do
				local tUserInfo = hApi.Split(tMykey[i], ":")
				local rank = tonumber(tUserInfo[1]) or 0 --rank
				local uid = tonumber(tUserInfo[2]) or 0 --uid
				local rid = tonumber(tUserInfo[3]) or 0 --rid
				local name = tostring(tUserInfo[4]) --name
				--print(i, rank, uid, rid, name)
				
				--�洢�������а�����
				self._bollboardData[#self._bollboardData+1] = {rank = rank, uid = uid, rid = rid, name = name,}
			end
		else
			--������
			--��ȡ�����ڵ����а�����
			local sCmdTemp = ""
			local diff = 0
			local sQueryM = string.format("select `uid`, `rid`, `name`, `stage`, `tank`, `weapon`, `gametime`, `scientist`, `gold`, `kill`, `time` from `tank_billboard` where `bid` = %d and `diff` = %d order by `stage` desc, `gametime` asc, `time` asc limit %d", bId, diff, TankBillboardMgr.MAX_RANK)
			local errM, tTemp = xlDb_QueryEx(sQueryM)
			--print(sQueryM)
			--print("��ѯ���а�:", "errM=", errM, "tTemp=", tTemp)
			if (errM == 0) then
				for n = 1, #tTemp, 1 do
					local rank = n
					local uid = tTemp[n][1]
					local rid = tTemp[n][2]
					local name = tTemp[n][3]
					local stage = tTemp[n][4]
					local tankId = tTemp[n][5]
					local weaponId = tTemp[n][6]
					local gametime = tTemp[n][7]
					local scientistNum = tTemp[n][8]
					local goldNum = tTemp[n][9]
					local killNum = tTemp[n][10]
					local time = tTemp[n][11]
					
					sCmdTemp = sCmdTemp .. tostring(rank) .. ":" .. tostring(uid) .. ":" .. tostring(rid) .. ":" .. tostring(name) .. ";"
					--print(tostring(rank) .. ":" .. tostring(uid) .. ":" .. tostring(rid) .. ":" .. tostring(name) .. ";")
					
					--�洢�������а�����
					self._bollboardData[#self._bollboardData+1] = {rank = rank, uid = uid, rid = rid, name = name,}
				end
				
				sCmdTemp = tostring(#tTemp) .. ";" .. sCmdTemp
				
				--�����¼
				local sql1 = string.format("INSERT INTO `tank_billboard_check` (`bid`, `billboard`, `time`) values (%d, '%s', '%s')", bId, sCmdTemp, checkDate)
				xlDb_Execute(sql1)
			end
		end
	end
	
	--��ѯ��ҵ�����
	function TankBillboardMgr:QueryRank(uid, rid)
		local rank = 0
		
		for i = 1, #self._bollboardData, 1 do
			if (self._bollboardData[i].uid == uid) and (self._bollboardData[i].rid == rid) then
				rank = self._bollboardData[i].rank
				break
			end
		end
		
		return rank
	end
	
	--���º���
	function TankBillboardMgr:Update()
		--local localTime = os.time() --�ͻ���ʱ�� 12:00
		local dbTime = hApi.GetTime()
		
		--�����ǰʱ����ڼ��ʱ�䣬����Ҫ���м��(ÿ��0����Ҫ��ⷢ��)
		if (dbTime >= self._nextchecktime) then
			local datestamp = hApi.Timestamp2Date(self._nextchecktime)
			
			--����Ƿ�Ҫ������
			self:_DBCheckReward(datestamp)
			
			--����������һ�μ������
			self._nextchecktime = hApi.GetNewDate(datestamp.." 00:00:00", "DAY", 1) --�ڶ���0���ʱ���
		end
		
		return self
	end
	
return TankBillboardMgr