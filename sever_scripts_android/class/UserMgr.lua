--�û�������
local UserMgr = class("UserMgr")
    
	--���캯��
	function UserMgr:ctor()
		self._pCount = -1
		self._dic = nil
		self._dicDBID = nil
		self._flStore = nil
		self._onlineCount = -1
		self._maxOnlineCount = -1
		

		--����
		self._statisticsTime = -1	--ͳ�Ƽ�ʱ
		self._lastLogDate = os.date("%Y-%m-%d") --��һ�������־������

		return self
	end
	--��ʼ������
	function UserMgr:Init(len)
		
		if len > 0 then
			self._pCount = 1
			self._onlineCount = 0
			self._maxOnlineCount = 0
			self._dic = {}
			self._dicDBID = {}
			self._flStore = hClass.CircleFixedLenthStore:create("User"):Init(len)
		end

		self._statisticsTime = hApi.GetClock()

		return self
	end
	--�����û�
	function UserMgr:CreateUser(dbId, rId)
		--print("�����û�",dbId, rId)
		--�����û�����
		local user = self._flStore:CreateObj()
		--print("�����û�����",user, self._dic)
		--����û��������
		if user then
			self._onlineCount = self._onlineCount + 1
			self._maxOnlineCount = math.max(self._maxOnlineCount,self._onlineCount)
			--todo ����cmd
			
			--�û����������쳣���
			if self._pCount <= 0 then
				self._pCount = 1
			end
			
			--��ʼ���û�����
			user:Init(self._pCount, dbId, rId)
			
			--�������洢user
			self._dic[self._pCount] = user
			self._dicDBID[dbId] = {user = user, dbId = dbId, rId = rId, id = self._pCount,}
			
			--�û��������ۼ�
			self._pCount = self._pCount + 1
			
			--�����ʼ���ɹ�,ֱ�ӷ���
			if user:IsInit() then
				--print("��ʼ���ɹ�")
				return user
			else
				--���ʧ����ɾ���´����Ľ�ɫ
				--print("ʧ����ɾ���´����Ľ�ɫ", user:GetID())
				self:ReleaseUser(user:GetID())
				return
			end
		end
		
	end
	
	--�ͷ��û�
	function UserMgr:ReleaseUser(id)
		--print("�ͷ��û�","id=" .. id)
		local user = self:FindUser(id)
		--����û��������
		if user then
			--�û������ڴ��ͷ�
			user:Release()
			--�ͷ��û��ڴ��
			self._flStore:Release(user)
			
			--ɾ���ֵ�
			self._dic[id] = nil
			local dbId = user:GetDBID()
			self._dicDBID[dbId] = nil
			
			self._onlineCount = math.max(self._onlineCount - 1,0)
		end
		return self
	end
	
	--ͨ��DBId�ͷ��û�
	function UserMgr:ReleaseUserByDBID(dbId)
		local user = self:FindUserByDBID(dbId)
		--����û��������
		if user then
			local id = user:GetID()
			--�û������ڴ��ͷ�
			user:Release()
			--�ͷ��û��ڴ��
			self._flStore:Release(user)
			
			--ɾ���ֵ�
			self._dic[id] = nil
			self._dicDBID[dbId] = nil
			
			self._onlineCount = math.max(self._onlineCount - 1,0)
		end
		return self
	end
	
	--ͨ��ID�����û�
	function UserMgr:FindUser(id)
		return self._dic[id]
	end
	
	--ͨ��DBID�����û�
	function UserMgr:FindUserByDBID(dbId)
		--print("UserMgr:FindUserByDBID", dbId, self._dic)
		--[[
		if self._dic and type(self._dic) == "table" then
			for id,p in pairs(self._dic) do
				--print("ͨ��DBID�����û�", id, p)
				if p:getCName() == "User" then
					if dbId > 0 and dbId == p:GetDBID() then
						return p
					end
				end
			end
		end
		]]
		
		if self._dicDBID and (type(self._dicDBID) == "table") then
			if self._dicDBID[dbId] then
				local p = self._dicDBID[dbId].user
				if (dbId > 0) and (dbId == p:GetDBID()) then
					return p
				end
			end
		end
	end
	
	--�û�IDת�����û�DBID
	function UserMgr:ChangeIDToDBID(uIdList)
		local uRet
		if type(uIdList) == "number" then
			local user = self._dic[uIdList]
			if user then
				uRet = user:GetDBID()
			end
		elseif type(uIdList) == "table" then
			uRet = {}
			for i = 1, #uIdList do
				local uid = uIdList[i] or 0
				local user = self._dic[uid]
				if user then
					uRet[#uRet + 1] = user:GetDBID()
				end
			end
		end
		return uRet
	end

	--��ȡ�����û�����
	function UserMgr:GetOnlineCount()
		return self._onlineCount
	end

	--��ȡ������ҵ�dbId
	function UserMgr:GetInHallUserDBID()
		local ret = {}
		for uid, user in pairs(self._dic) do
			if user and user:IsInHall() then
				ret[#ret + 1] = user:GetDBID()
			end
		end
		return ret
	end

	--��ȡ������ҵ�dbId
	function UserMgr:GetAllUserDBID()
		local ret = {}
		for uid, user in pairs(self._dic) do
			ret[#ret + 1] = user:GetDBID()
		end
		return ret
	end
	
	--
	function UserMgr:Update()
		
		--�����Ϣ
		local timeNow = hApi.GetClock()
		if self._statisticsTime > -1 and timeNow - self._statisticsTime > 60000 then
			self._statisticsTime = timeNow
			
			--�����־
			local savePath = g_serverLog .. "online_"..(self._lastLogDate)..".log"
			local file = io.open(savePath, "w+")
			local output = "Max Online Count:" .. tostring(self._maxOnlineCount)
			file:write(output)
			file:close()
			
			local dateNow = os.date("%Y-%m-%d")
			if dateNow > self._lastLogDate then
				self._lastLogDate = dateNow		--������־�������
				self._maxOnlineCount = 0		--���������0
			end
		end
	end
	
	--�û�loginResult toCmd
	function UserMgr:LoginResultToCmd(result, uid, udbid)
		--0ʧ�� 1�ɹ�
		local cmd = ""
		if result == 0 then
			cmd = cmd .. tostring(result)..";".. tostring(udbid)
		elseif result == 1 then
			local user = self:FindUser(uid)
			local bTester = user:IsTesters()
			
			cmd = cmd .. tostring(result).. ";"
			cmd = cmd .. tostring(udbid) .. ";"
			
			--�汾��
			cmd = cmd .. tostring(hGlobal.sysCfg:GetConfgByKey("version_control")) .. ";"
			cmd = cmd .. tostring(hGlobal.sysCfg:GetConfgByKey("debug_version_control")) .. ";"
			cmd = cmd .. tostring(hGlobal.sysCfg:GetConfgByKey("pvp_control")) .. ";"
			cmd = cmd .. tostring(hGlobal.sysCfg:GetConfgByKey("debug_pvp_control")) .. ";"
			cmd = cmd .. tostring(hGlobal.sysCfg:GetConfgByKey("android_control")) .. ";"
			cmd = cmd .. tostring(hGlobal.sysCfg:GetConfgByKey("debug_android_control")) .. ";"
			cmd = cmd .. tostring(hGlobal.sysCfg:GetConfgByKey("shop_control")) .. ";"
			cmd = cmd .. tostring(hApi.GetTime()) .. ";"
			
			--������Ϣ
			
			--Ӣ����Ϣ
			cmd = cmd .. tostring(user:HeroInfoToCmd()) .. ";"
			
			--������Ϣ
			cmd = cmd .. tostring(user:InventoryInfoToCmd()) .. ";"
			
			--�ؿ���Ϣ
			cmd = cmd .. tostring(user:LevelInfoToCmd()) .. ";"
		end
		return cmd
	end
    
return UserMgr