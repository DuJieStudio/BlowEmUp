hClass.connect = eClass:new()
hClass.connect.__static = {}
hClass.connect.__static.param = {
	encrypt = 0,		--�����red��ɶ�ģ��Ҳ�֪��
	callback = 0,		--����ǻص�����(msg,paramA,paramB,paramS)
	heartbeat = 0,		--����յ���������ʱ��
	connectparam = 0,	--����ʱʹ�õ�param,����onconnect(1)��ʱ�򴫸�onconnect����
	reconnectparam = 0,	--������ʹ�ô�param��ԭconnectparam
	connectcount = 0,	--���Ӽ�����
	onconnect = 0,		--���ӳɹ��ĺ���
	autodrop = 0,		--��������ղ������������Զ�����
	autodropcode = 0,	--�Զ����ߺ���������еĻ������������ֱ�Ӷ���
	whydrop = 0,		--Ϊ�ε���
	droptime = 0,		--�������ߵ�ʱ��
	connecttip = 0,		--������ͣʱ�ı�ǩ
	uid = 0,
	rid = 0,		--���ӳɹ�ʱʹ�õ�roleid
	ip = 0,
	port = 0,
	cmdid = 66665,		--��Ҫ�����Э��id
	uidisable = 0,		--���Ӽ�����(ui��)
	IsConnected = 0,	--�Ƿ��Ѿ�����
	IsLogin = 0,		--�Ƿ��Ѿ���¼
	IsReconnect = 0,	--�Ƿ�������ͬ����
	handler = 0,		--��Ϣ������
	netcount = 0,		--����Ļغϼ�����
	recvlog = 0,		--�洢�κ�(����)nMsgCount~=0����Ϣ���(���洢�����֤���ͻ����Ѿ��յ���Ϣ)
	sendcount = 0,		--���ͼ�����
	sendexlimit = 40000,	--ճ��������෢��40k����
	sendexcount = 0,	--���ͼ�����ex(ճ��ר��)
	sendexlock = 0,		--����ճ��Э���ÿ��һ��ʱ����ܷ�����һ��ճ��Э��
	sendextemp = 0,		--��������Ҫ�첽���͵�Э��ʱ,����˶�ջ(�ӳ��첽����)
	recvextemp = 0,		--������������ճ������
	syncmsg = 0,		--��Ҫͬ����¼�ķ�����Ϣ����
	sendlog = 0,		--�洢�κ�(����)nMsgCount~=0����Ϣ���(���洢�����֤���ͻ����Ѿ�������Ϣ)
	sendtemp = 0,		--�洢�ѷ��͵���Ϣ
	connectfail = 0,	--���һ������ʧ�ܵĻص�
}

local _hcn = hClass.connect
_hcn.init = function(self,param)
	rawset(self,"data",{})
	rawset(self,"handle",{})
	hApi.ReadParamWithDepth(hClass.connect.__static.param,param,rawget(self,"data"),3)
	hClass.connect.__static.__addtcp(self)
	local d = self.data
	rawset(self,"del",hClass.connect.__static.__del)
	if type(d.ip)~="string" then
		d.ip = g_lrc_Ip
	end
	if type(d.port)~="number" then
		d.port = 9032
	end
	d.handler = {}		--��Ϣ����[nMsgId] = (function)
	--��ʼ�������
	d.sendcount = 0
	d.sendexcount = 0
	d.sendextemp = {}
	d.recvextemp = {}
	if type(d.syncmsg)=="table" and d.syncmsg.idx==nil then
		d.syncmsg.idx = {}
		for i = 1,#d.syncmsg do
			d.syncmsg.idx[d.syncmsg[i]] = 1
		end
	end
	self:resetdata()
end

_hcn.resetdata = function(self,IsKeepLastRecv)
	local d = self.data
	local nLastRecv = nil
	if IsKeepLastRecv==1 and d.recvlog~=0 and #d.recvlog>0 then
		nLastRecv = d.recvlog[#d.recvlog]
		d.recvlog = {nLastRecv}
	else
		d.recvlog = {}
	end
	d.sendlog = {}
	d.sendtemp = {}
end

_hcn.send = function(self,nMsgId,nParamA,nParamB,nParamC,sCmd)
	local d = self.data
	local h = self.handle
	if type(nMsgId)~="number" then
		print("[connect]msg error(1)",tostring(nMsgId))
		return
	end
	nParamA = type(nParamA)=="number" and nParamA or 0
	nParamB = type(nParamB)=="number" and nParamB or 0
	nParamC = type(nParamC)=="number" and nParamC or 0
	sCmd = type(sCmd)=="string" and sCmd or ""
	local nMsgCount = 0
	if type(d.syncmsg)=="table" and d.syncmsg.idx and d.syncmsg.idx[nMsgId]==1 then
		d.sendcount = d.sendcount + 1
		nMsgCount = d.sendcount
	end
	local tTemp = {d.cmdid,nMsgId,nMsgCount,nParamA,nParamB,nParamC,sCmd}
	if nMsgCount>0 then
		local n = #d.sendlog+1
		d.sendlog[n] = nMsgCount
		d.sendtemp[n] = tTemp
	end
	if d.IsConnected~=1 then
		print("[connect]no connect(1)",tostring(nMsgId))
		return
	end
	local err = xlTcpClient_Send(h._tcp,7,tTemp)
	if err~=0 then
		print("[connect]Send Msg Fail(101)",err,nMsgId)
	end
end

_hcn.__send = function(self,nMsgId,nMsgCount,nParamA,nParamB,nParamC,sCmd)
	local d = self.data
	local h = self.handle
	nMsgId = type(nMsgId)=="number" and nMsgId or 0
	nMsgCount = type(nMsgCount)=="number" and nMsgCount or 0
	nParamA = type(nParamA)=="number" and nParamA or 0
	nParamB = type(nParamB)=="number" and nParamB or 0
	nParamC = type(nParamC)=="number" and nParamC or 0
	sCmd = type(sCmd)=="string" and sCmd or ""
	local tTemp = {d.cmdid,nMsgId,nMsgCount,nParamA,nParamB,nParamC,sCmd}
	local err = xlTcpClient_Send(h._tcp,7,tTemp)
	if err~=0 then
		print("[connect]Send Msg Fail(201)",err,nMsgId)
	end
end

_hcn.__c2lpacket = function(self,tSend)
	local d = self.data
	local h = self.handle
	if not(type(tSend)=="table" and type(tSend[1])=="number") then
		print("[connect]msg error(3)",tostring(nMsgId))
		return
	end
	local err = xlTcpClient_Send(h._tcp,#tSend,tSend)
	if err~=0 then
		print("[connect]Send Msg Fail(301)",err,tSend[1])
	end
end

--����ǳ��ַ�������Ҫʹ�ô˽ӿڣ��첽����(nParamB��nParamC��Ч����λ�ñ�����У��ֵ)
_hcn.sendex = function(self,nMsgId,nParamA,nParamB,nParamC,sCmd)
	local d = self.data
	local h = self.handle
	if type(nMsgId)~="number" then
		print("[connect]msg error(2)",tostring(nMsgId))
		return
	end
	nParamA = type(nParamA)=="number" and nParamA or 0
	--nParamB = type(nParamB)=="number" and nParamB or 0
	--nParamC = type(nParamC)=="number" and nParamC or 0
	if not(type(sCmd)=="string" and sCmd~="") then
		sCmd = "#"
	end
	d.sendexcount = d.sendexcount + 1	--ճ��������nMsgCount
	local nMsgCount = d.sendexcount
	local nMsgIdEx = nMsgId+10000		--ճ��Э��10000~19999�ţ���Ӧ����Э��+10000����ӦЭ��20000~29999����Ӧ����Э��+20000
	local nCmdLen = string.len(sCmd)
	local tSendExTemp = {d.sendexcount,{sCmd,0,0,nCmdLen},{d.cmdid,nMsgIdEx,nMsgCount,nParamA,nCmdLen,0,""}}
	d.sendextemp[#d.sendextemp+1] = tSendExTemp
	self:__c2lpacket(tSendExTemp[3])
end

_hcn.__sendex = function(self)
	local d = self.data
	local h = self.handle
	if d.IsConnected~=1 then
		return
	end
	if (d.sendextemp[1] or 0)==0 then
		return
	end
	if d.sendexlock>=hApi.gametime() then
		return
	end
	d.sendexlock = hApi.gametime() + 1000
	local IsComplete = 0
	local tSendExTemp = d.sendextemp[1]
	local nSendA = 0
	local nSendB = tSendExTemp[2][4]
	local sSendCmd = ""
	if tSendExTemp[2][3]<tSendExTemp[2][4] then
		nSendA = tSendExTemp[2][3] + 1
		nSendB = tSendExTemp[2][3] + d.sendexlimit
		if nSendB>=tSendExTemp[2][4] then
			IsComplete = 1
			nSendB = tSendExTemp[2][4]
		end
		tSendExTemp[2][3] = nSendB
		sSendCmd = string.sub(tSendExTemp[2][1],nSendA,nSendB)
	end
	tSendExTemp[3][5] = nSendA
	tSendExTemp[3][6] = nSendB
	tSendExTemp[3][7] = sSendCmd
	self:__c2lpacket(tSendExTemp[3])
	if IsComplete==1 then
		--����Ѿ���������Ϣ����ô����ճ���ر�Э��
		tSendExTemp[3][5] = 0
		tSendExTemp[3][6] = tSendExTemp[2][4]
		tSendExTemp[3][7] = ""
		self:__c2lpacket(tSendExTemp[3])
	end
end

_hcn.__sendexconfirm = function(self,nMsgId,nMsgCount,nBreakReason,nRecvSum)
	local d = self.data
	d.sendexlock = 0
	local nFindI = 0
	for i = 1,#d.sendextemp do
		if d.sendextemp[i][1]==nMsgCount then
			nFindI = i
			break
		end
	end
	if nFindI>0 then
		if nBreakReason>0 then
			d.sendextemp[nFindI] = 0
			hApi.SortTableI(d.sendextemp,1)
		else
			d.sendextemp[nFindI][2][2] = math.max(d.sendextemp[nFindI][2][2],nRecvSum)
		end
	end
end

_hcn.recvex = function(self,nMsgId,nMsgCount,nParamA,nRecvA,nRecvB,sCmd)
	local d = self.data
	local nFindI = 0
	for i = 1,#d.recvextemp do
		if d.recvextemp[i][4]==nMsgCount then
			nFindI = i
			if d.recvextemp[i][5]~=nMsgId then
				d.recvextemp[nFindI] = {hApi.gametime(),0,0,nMsgCount,nMsgId}
			end
			break
		end
	end
	if nFindI==0 then
		nFindI = #d.recvextemp + 1
		d.recvextemp[nFindI] = {hApi.gametime(),0,0,nMsgCount,nMsgId}
	end
	if nFindI==0 then
		self:__send(nMsgId+20000,nMsgCount,1,0)
	else
		local tRecvExTemp = d.recvextemp[nFindI]
		if nRecvB<=0 then
			--�յ�ճ��ͷ�����û�������ܳ���
			tRecvExTemp[3] = nRecvA
		elseif nRecvA>0 then
			--�յ�ճ������
			if (tRecvExTemp[2]+1)==nRecvA then
				tRecvExTemp[2] = nRecvB
				tRecvExTemp[#tRecvExTemp+1] = sCmd
			end
		elseif nRecvA==0 and tRecvExTemp[2]==nRecvB then
			--�յ�ճ��β������ȷ��ok
			d.recvextemp[nFindI] = 0
			hApi.SortTableI(d.recvextemp,1)
			tRecvExTemp[1] = ""
			tRecvExTemp[2] = ""
			tRecvExTemp[3] = ""
			tRecvExTemp[4] = ""
			tRecvExTemp[5] = ""
			self:__send(nMsgId+20000,nMsgCount,2,0)
			return table.concat(tRecvExTemp)
		end
		--���ͷ���������ֵ
		self:__send(nMsgId+20000,nMsgCount,0,tRecvExTemp[2])
	end
end

do
	local _enum_NetConnectMsgEx = function(oConn)
		if not(oConn.data.IsConnected==1 and oConn.data.IsLogin==1) then
			return
		end
		oConn:__sendex()
	end
	hApi.addTimerForever("NetConnectSendEx",hVar.TIMER_MODE.GAMETIME,1,function()
		hClass.connect:enum(_enum_NetConnectMsgEx)
	end)
end

_hcn.sendsync = function(self,nMsgCount)
	local d = self.data
	local h = self.handle
	local tTemp = nil
	for i = 1,#d.sendtemp do
		if d.sendtemp[i][3]==nMsgCount then
			tTemp = d.sendtemp[i]
			break
		end
	end
	if tTemp==nil then
		return -1
	end
	local nMsgId = tTemp[2]
	--for k,id in pairs(hVar.PVP_MSG)do
		--if id==nMsgId then
			--print("send by count",k)
		--end
	--end
	local tTempSend = {}
	for i = 1,#tTemp do
		tTempSend[i] = tTemp[i]
	end
	local sSyncCmd = self:getsynccmd()
	tTempSend[2] = tTemp[2] + 30000		--ͬ��Э��30000~39999�ţ���Ӧ����Э��+30000
	tTempSend[7] = sSyncCmd.."#CMD#"..tTemp[7]
	local err = xlTcpClient_Send(h._tcp,7,tTempSend)
	if err~=0 then
		print("[connect]Send Msg Fail(401)",err,nMsgId)
		return err
	end
	return 0
end

_hcn.__connect = function(self,nTryCount,pFailCode)
	local d = self.data
	local h = self.handle
	d.uidisable = hUI.NetDisable(5500,"ArenaConnect")
	local err = xlTcpClient_Connect(h._tcp,d.ip,d.port)
	if err==0 then
		--���ӳɹ�
		d.connectfail = 0
		hUI.NetDisable(0,d.uidisable)
	--elseif err==52 then
		----�Ѿ�����/���ڶϿ�
		--d.connectfail = 52
		--hUI.NetDisable(0,d.uidisable)
		--err = 0
	else
		--����ʧ��
		print("[Arena]Connect Error("..tostring(err)..")")
		d.connectfail = err
		if err==53 then
			xlTcpClient_Close(h._tcp)	--53�Ŵ��������Ҫ�ȴ��رգ���������ùرսӿ�
		end
		if nTryCount>0 then
			local oConn = self
			hApi.addTimerOnce("ArenaReconnectTimer"..oConn.ID,5000,function()
				hUI.NetDisable(0,oConn.data.uidisable)
				oConn:__connect(nTryCount-1,pFailCode)
			end)
		else
			hUI.NetDisable(0,d.uidisable)
			if type(pFailCode)=="function" then
				pFailCode(self,err)
			end
		end
	end
	return err
end

_hcn.connect = function(self,tParam,nTryCount,pFailCode)
	local d = self.data
	local h = self.handle
	if type(tParam)=="table" then
		d.connectparam = tParam
	else
		d.connectparam = 0
	end
	if type(nTryCount)~="number" then
		nTryCount = 0
	end
	return self:__connect(nTryCount,pFailCode)
end

_hcn.disconnect = function(self,nWhyDrop)
	local d = self.data
	local h = self.handle
	d.IsConnected = 0
	d.whydrop = nWhyDrop or 0
	d.droptime = hApi.gametime()
	local err = xlTcpClient_Close(h._tcp)
	return err
end

_hcn.logout = function(self)
	local d = self.data
	if d.IsConnected==1 then
		self:__c2lpacket({3997,0,d.uid})
	end
end

_hcn.isConnected = function(self)
	local d = self.data
	if d.IsConnected~=1 then
		return false
	else
		return true
	end
end

_hcn.isOnline = function(self)
	local d = self.data
	if d.IsConnected~=1 then
		return false
	elseif d.IsLogin~=1 then
		return false
	elseif d.IsReconnect~=0 then
		return false
	else
		return true
	end
end

_hcn.getsynccmd = function(self)
	local d = self.data
	local tSyncCmd = {"r:",d.netcount,";"}
	if d.sendlog~=0 then
		for i = 1,#d.sendlog do
			tSyncCmd[#tSyncCmd+1] = "c:"
			tSyncCmd[#tSyncCmd+1] = d.sendlog[i]
			tSyncCmd[#tSyncCmd+1] = ";"
		end
	end
	if d.recvlog~=0 then
		for i = 1,#d.recvlog do
			tSyncCmd[#tSyncCmd+1] = "s:"
			tSyncCmd[#tSyncCmd+1] = d.recvlog[i]
			tSyncCmd[#tSyncCmd+1] = ";"
		end
	end
	return table.concat(tSyncCmd)
end

_hcn.autodrop = function(self,nLockTick)
	local tTemp = {
		lock = 0,
		release = 0,
		pause = 0,
	}
	if type(nLockTick)=="number" then
		tTemp.lock = hApi.gametime() + nLockTick
	end
	local sTimerName = "NetConnectAutoDrop_"..self.ID
	hApi.addTimerForever(sTimerName,hVar.TIMER_MODE.GAMETIME,1000,function()
		local d = self.data
		local nCurTick = hApi.gametime()
		if tTemp.release==1 then
			return hApi.clearTimer(sTimerName)
		elseif tTemp.lock>nCurTick then
			return
		elseif tTemp.pause==1 then
			return
		end
		if d.autodrop<=0 then
			return
		end
		if (self.ID or 0)>0 and d.IsConnected==1 then
			if (nCurTick-d.heartbeat)>d.autodrop then
				if type(d.autodropcode)=="function" then
					if (d.autodropcode(self) or 0)==0 then
						hApi.clearTimer(sTimerName)
					end
				else
					hApi.clearTimer(sTimerName)
					self:disconnect("pvp_err_OnHeartBeat")
				end
			end
		else
			hApi.clearTimer(sTimerName)
		end
	end)
	return tTemp
end

-------------------------
--���ܺ���
-------------------------
hClass.connect.__static.__callback = function(self,tRecv)
	print("recv["..self.ID.."]",tRecv[2],tRecv[3],tRecv[4],tRecv[5],tRecv[6],tRecv[7])
end
hClass.connect.__static.__del = function(self)
	print("try del ["..self.ID.."]connect!")
end
hClass.connect.__static.__addtcp = function(self)
	local sCallbackFuncName = "g_callback_ConnectRecvMsg_"..self.__ID
	_G[sCallbackFuncName] = function(tRecv)
		local d = self.data
		d.heartbeat = hApi.gametime()	--�յ��κ�Э�鶼���ӳ�����ʱ��
		if tRecv[1]==44444 then		--������
			return
		elseif tRecv[1]==66665 then	--�Զ���Э��
			if tRecv[2]<=9999 then
				--��ͨЭ��
				local nMsgId = tRecv[2]
				local nMsgCount = tRecv[3]
				if nMsgCount~=0 then	--��¼�Լ��յ�����Ϣ(ֻҪ��¼nMsgCount����,����Ҫ��¼������Ϣ,��֤��)
					d.recvlog[#d.recvlog+1] = nMsgCount
				end
				if type(d.callback)=="function" then
					return d.callback(self,nMsgId,nMsgCount,tRecv[4],tRecv[5],tRecv[6],tRecv[7])
				else
					return hClass.connect.__static.__callback(self,tRecv)
				end
			elseif tRecv[2]<=19999 then
				--ճ��Э��(10000~19999)
				local nMsgId = tRecv[2] - 10000
				local nMsgCount = tRecv[3]
				local sRecvCmd = self:recvex(nMsgId,nMsgCount,tRecv[4],tRecv[5],tRecv[6],tRecv[7])
				if sRecvCmd then
					if type(d.callback)=="function" then
						return d.callback(self,nMsgId,nMsgCount,tRecv[4],0,0,sRecvCmd)
					else
						local tRecvNB = {tRecv[1],nMsgId,0,tRecv[4],0,0,sRecvCmd}
						return hClass.connect.__static.__callback(self,tRecvNB)
					end
				end
			elseif tRecv[2]<=29999 then
				--ճ��Э��ȷ��(20000~29999)
				local nMsgId = tRecv[2] - 20000
				local nMsgCount = tRecv[3]
				local nBreakReason = tRecv[4]
				local nRecvSum = tRecv[5]
				return self:__sendexconfirm(nMsgId,nMsgCount,nBreakReason,nRecvSum)
			end
		elseif hClass.connect.__static.syscallback[tRecv[1]] then
			return hClass.connect.__static.syscallback[tRecv[1]](self,tRecv)
		end
	end
	self.handle._tcp = xlTcpClient_Create(self.data.encrypt,sCallbackFuncName)
end

--------------------
--�����ص�
--------------------
hClass.connect.__static.syscallback = {}
local _Handler = hClass.connect.__static.syscallback

--���ӻص� 1:�ɹ� 2:�쳣 3:����
_Handler[99] = function(self,tRecv)
	local d = self.data
	if tRecv[2]==1 then
		d.IsConnected = 1
		d.IsLogin = 0
		d.uidisable = hUI.NetDisable(1500,d.connecttip)
		d.uid = xlPlayer_GetUID() or 0
		d.rid = luaGetplayerDataID() or 0
		if d.uid~=0 and d.rid~=0 then
			self:__c2lpacket({4000,0,d.uid,d.rid,0})
			d.heartbeat = hApi.gametime()
			self:autodrop()
			if type(d.onconnect)=="function" then
				return d.onconnect(self,0)
			end
		else
			print("[connect]no uid, can not login!",uid,rid)
			hUI.NetDisable(0,d.uidisable)
			return self:disconnect("pvp_err_NoUID")
		end
	else
		--print("[connect]fail",tRecv[2])
		--�������Ѿ�֪����Ҫ�Ͽ���
		if tRecv[2]==3 then
			--�����Ͽ����Ȼỹ���յ�2
			self:disconnect(0)
		else
			--������������2,���Ǿʹ���
			hUI.NetDisable(0,d.uidisable)
			d.IsConnected = 0
			d.IsLogin = 0
			local sTimerName = "NetConnectAutoDrop_"..self.ID
			hApi.clearTimer(sTimerName)
			if type(d.onconnect)=="function" then
				return d.onconnect(self,tRecv[2])
			end
		end
	end
end

--��¼�ɹ�
_Handler[4001] = function(self,tRecv)
	local d = self.data
	--if tRecv[3]==99 then
		--d.uidisable = hUI.NetDisable(1500,d.connecttip)
		--hApi.addTimerOnce("TryLoginForConnect"..self.ID,1000,function()
			--if self.data.IsConnected==1 and self.data.IsLogin==0 then
				--self:__c2lpacket({4000,0,d.uid,d.rid,0})
			--end
		--end)
	--else
		--hApi.clearTimer("TryLoginForConnect"..self.ID)
		--hUI.NetDisable(0,d.uidisable)
		--d.IsLogin = 1
		--if type(d.onconnect)=="function" then
			--return d.onconnect(self,1)
		--end
	--end
	--��������
	if tRecv[3] == 0 then
		hUI.NetDisable(0,d.uidisable)
		d.IsLogin = 1
		if type(d.onconnect)=="function" then
			return d.onconnect(self,1)
		end
	--���ش���
	else
		local oWorld = hGlobal.NetBattlefield
		--����Ѿ���¼  �����������ս
		if tRecv[3] == 99 and oWorld and oWorld.data.netdata~=0 and oWorld.data.netdata.version==2 then
			if oWorld.data.IsReplay==1 then
				--��¼���ʱ�����Ҳ���ᷢ���κ�����
			else
				--���緢������ ����ֶ����߳����Զ��Ͽ����Ӻ��ص�  ������������
				d.uidisable = hUI.NetDisable(1500,d.connecttip)
				hApi.addTimerOnce("TryLoginForConnect"..self.ID,1000,function()
					if self.data.IsConnected==1 and self.data.IsLogin==0 then
						self:__c2lpacket({4000,0,d.uid,d.rid,0})
					end
				end)
			end
		else
			--table_print(self.data)
			--���������ֱ�ӵ���
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_NoNetNoOpen"].."("..tRecv[3]..")",{
				ok = function()
					--���ش���
					if hApi.IsPVPConnected() then
						g_PVP_NetSaveData.MyExitOprTick = hApi.gametime()
						hGlobal.ArenaConnect:disconnect()
						--hGlobal.ArenaConnect:logout()
					else
						hGlobal.event:event("LocalEvent_ShowArenaFrm",0)		--���߹ر����
					end
					hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
				end,
			})
		end
	end
end