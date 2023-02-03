--用户管理类
local UserMgr = class("UserMgr")
    
	--构造函数
	function UserMgr:ctor()
		self._pCount = -1
		self._dic = nil
		self._dicDBID = nil
		self._flStore = nil
		self._onlineCount = -1
		self._maxOnlineCount = -1
		

		--其他
		self._statisticsTime = -1	--统计计时
		self._lastLogDate = os.date("%Y-%m-%d") --上一次输出日志的日期

		return self
	end
	--初始化函数
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
	--创建用户
	function UserMgr:CreateUser(dbId, rId)
		--print("创建用户",dbId, rId)
		--申请用户对象
		local user = self._flStore:CreateObj()
		--print("申请用户对象",user, self._dic)
		--如果用户对象存在
		if user then
			self._onlineCount = self._onlineCount + 1
			self._maxOnlineCount = math.max(self._maxOnlineCount,self._onlineCount)
			--todo 解析cmd
			
			--用户计数器的异常检测
			if self._pCount <= 0 then
				self._pCount = 1
			end
			
			--初始化用户对象
			user:Init(self._pCount, dbId, rId)
			
			--管理器存储user
			self._dic[self._pCount] = user
			self._dicDBID[dbId] = {user = user, dbId = dbId, rId = rId, id = self._pCount,}
			
			--用户计数器累加
			self._pCount = self._pCount + 1
			
			--如果初始化成功,直接返回
			if user:IsInit() then
				--print("初始化成功")
				return user
			else
				--如果失败则删除新创建的角色
				--print("失败则删除新创建的角色", user:GetID())
				self:ReleaseUser(user:GetID())
				return
			end
		end
		
	end
	
	--释放用户
	function UserMgr:ReleaseUser(id)
		--print("释放用户","id=" .. id)
		local user = self:FindUser(id)
		--如果用户对象存在
		if user then
			--用户对象内存释放
			user:Release()
			--释放用户内存池
			self._flStore:Release(user)
			
			--删除字典
			self._dic[id] = nil
			local dbId = user:GetDBID()
			self._dicDBID[dbId] = nil
			
			self._onlineCount = math.max(self._onlineCount - 1,0)
		end
		return self
	end
	
	--通过DBId释放用户
	function UserMgr:ReleaseUserByDBID(dbId)
		local user = self:FindUserByDBID(dbId)
		--如果用户对象存在
		if user then
			local id = user:GetID()
			--用户对象内存释放
			user:Release()
			--释放用户内存池
			self._flStore:Release(user)
			
			--删除字典
			self._dic[id] = nil
			self._dicDBID[dbId] = nil
			
			self._onlineCount = math.max(self._onlineCount - 1,0)
		end
		return self
	end
	
	--通过ID查找用户
	function UserMgr:FindUser(id)
		return self._dic[id]
	end
	
	--通过DBID查找用户
	function UserMgr:FindUserByDBID(dbId)
		--print("UserMgr:FindUserByDBID", dbId, self._dic)
		--[[
		if self._dic and type(self._dic) == "table" then
			for id,p in pairs(self._dic) do
				--print("通过DBID查找用户", id, p)
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
	
	--用户ID转化成用户DBID
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

	--获取在线用户数量
	function UserMgr:GetOnlineCount()
		return self._onlineCount
	end

	--获取大厅玩家的dbId
	function UserMgr:GetInHallUserDBID()
		local ret = {}
		for uid, user in pairs(self._dic) do
			if user and user:IsInHall() then
				ret[#ret + 1] = user:GetDBID()
			end
		end
		return ret
	end

	--获取大厅玩家的dbId
	function UserMgr:GetAllUserDBID()
		local ret = {}
		for uid, user in pairs(self._dic) do
			ret[#ret + 1] = user:GetDBID()
		end
		return ret
	end
	
	--
	function UserMgr:Update()
		
		--输出信息
		local timeNow = hApi.GetClock()
		if self._statisticsTime > -1 and timeNow - self._statisticsTime > 60000 then
			self._statisticsTime = timeNow
			
			--输出日志
			local savePath = g_serverLog .. "online_"..(self._lastLogDate)..".log"
			local file = io.open(savePath, "w+")
			local output = "Max Online Count:" .. tostring(self._maxOnlineCount)
			file:write(output)
			file:close()
			
			local dateNow = os.date("%Y-%m-%d")
			if dateNow > self._lastLogDate then
				self._lastLogDate = dateNow		--重设日志输出日期
				self._maxOnlineCount = 0		--最高在线清0
			end
		end
	end
	
	--用户loginResult toCmd
	function UserMgr:LoginResultToCmd(result, uid, udbid)
		--0失败 1成功
		local cmd = ""
		if result == 0 then
			cmd = cmd .. tostring(result)..";".. tostring(udbid)
		elseif result == 1 then
			local user = self:FindUser(uid)
			local bTester = user:IsTesters()
			
			cmd = cmd .. tostring(result).. ";"
			cmd = cmd .. tostring(udbid) .. ";"
			
			--版本号
			cmd = cmd .. tostring(hGlobal.sysCfg:GetConfgByKey("version_control")) .. ";"
			cmd = cmd .. tostring(hGlobal.sysCfg:GetConfgByKey("debug_version_control")) .. ";"
			cmd = cmd .. tostring(hGlobal.sysCfg:GetConfgByKey("pvp_control")) .. ";"
			cmd = cmd .. tostring(hGlobal.sysCfg:GetConfgByKey("debug_pvp_control")) .. ";"
			cmd = cmd .. tostring(hGlobal.sysCfg:GetConfgByKey("android_control")) .. ";"
			cmd = cmd .. tostring(hGlobal.sysCfg:GetConfgByKey("debug_android_control")) .. ";"
			cmd = cmd .. tostring(hGlobal.sysCfg:GetConfgByKey("shop_control")) .. ";"
			cmd = cmd .. tostring(hApi.GetTime()) .. ";"
			
			--基础信息
			
			--英雄信息
			cmd = cmd .. tostring(user:HeroInfoToCmd()) .. ";"
			
			--背包信息
			cmd = cmd .. tostring(user:InventoryInfoToCmd()) .. ";"
			
			--关卡信息
			cmd = cmd .. tostring(user:LevelInfoToCmd()) .. ";"
		end
		return cmd
	end
    
return UserMgr