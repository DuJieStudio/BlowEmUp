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
			
			--创建系统玩家（系统管理员）
			local sysUser = self:CreateUser(1000, 0)
			sysUser.bTester = 2
		end
		
		self._statisticsTime = hApi.GetClock()
		
		return self
	end
	
	--创建用户
	function UserMgr:CreateUser(dbId, rId)
		--申请用户对象
		local user = self._flStore:CreateObj()
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
			--print("创建用户 dbId=", dbId)
			
			--用户计数器累加
			self._pCount = self._pCount + 1
			
			--如果初始化成功,直接返回
			if user:IsInit() then
				return user
			else
				--如果失败则删除新创建的角色
				self:ReleaseUser(user:GetID())
				return
			end
		end
		
	end
	
	--释放用户
	function UserMgr:ReleaseUser(id)
		local user = self:FindUser(id)
		
		--如果用户对象存在
		if user then
			--用户对象内存释放
			user:Release()
			
			--释放用户内存池
			self._flStore:Release(user)
			
			--删除字典
			self._dic[id] = nil
			local dbId = user:GetUID()
			self._dicDBID[dbId] = nil
			
			self._onlineCount = math.max(self._onlineCount - 1, 0)
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
			
			self._onlineCount = math.max(self._onlineCount - 1, 0)
		end
		
		return self
	end
	
	--通过内存ID查找用户
	function UserMgr:FindUser(id)
		return self._dic[id]
	end
	
	--通过DBID查找用户
	function UserMgr:FindUserByDBID(dbId)
		--[[
		if self._dic and type(self._dic) == "table" then
			for id,p in pairs(self._dic) do
				if p:getCName() == "User" then
					if dbId > 0 and dbId == p:GetUID() then
						return p
					end
				end
			end
		end
		]]
		
		if self._dicDBID and (self._dicDBID ~= -1) then
			if self._dicDBID[dbId] then
				local p = self._dicDBID[dbId].user
				if (dbId > 0) and (dbId == p:GetUID()) then
					return p
				end
			end
		end
	end
	
	--通过DBID查找聊天用户(初始化聊天了才算)
	function UserMgr:FindChatUserByDBID(dbId)
		if self._dicDBID and (self._dicDBID ~= -1) then
			if self._dicDBID[dbId] then
				local p = self._dicDBID[dbId].user
				if (dbId > 0) and (dbId == p:GetUID()) then
					if (p.msg_init_state == 1) then --聊天初始化了
						return p
					end
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
				uRet = user:GetUID()
			end
		elseif type(uIdList) == "table" then
			uRet = {}
			for i = 1, #uIdList do
				local uid = uIdList[i] or 0
				local user = self._dic[uid]
				if user then
					uRet[#uRet + 1] = user:GetUID()
				end
			end
		end
		return uRet
	end

	--获取在线用户数量
	function UserMgr:GetOnlineCount()
		return self._onlineCount
	end
	
	--获取全体在线玩家的dbId
	function UserMgr:GetAllUserUID()
		local ret = {}
		for uid, user in pairs(self._dic) do
			ret[#ret + 1] = user:GetUID()
		end
		
		return ret
	end
	
	--游戏局更新
	function UserMgr:Update()
		local self = hGlobal.uMgr --self
		
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
	function UserMgr:LoginResultToCmd(result, id)
		--0失败 1成功
		local cmd = ""
		if result == 0 then
			cmd = cmd .. tostring(result)..";".. tostring(id)
		elseif result == 1 then
			local user = self:FindUser(id)
			cmd = cmd .. tostring(result).. ";"
			cmd = cmd .. tostring(id) .. ";"
		end
		return cmd
	end
    
return UserMgr