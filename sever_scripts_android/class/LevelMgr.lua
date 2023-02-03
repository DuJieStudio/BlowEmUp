--关卡管理类
local LevelMgr = class("LevelMgr")

	--构造函数
	function LevelMgr:ctor(flag)
		
		self._lastBeginLevel = -1				--上一次开始的关卡uniqueID
		self._lastBeginLevelChallenge = -1		--上一次开始的关卡难度级别
		self._lastUseHeroCount = -1				--上一次使用英雄数量
		self._lastUseHero = -1					--上一次使用英雄
		self._lastUseTowerCount = -1			--上一次使用塔数量
		self._lastUseTower = -1					--上一次使用塔
		self._lastUseTacticCount = -1			--上一次使用战术卡数量
		self._lastUseTactic = -1				--上一次使用战术卡
		self._levelCount = -1					--关卡数量
		self._levelDic = -1						--关卡存储

		--其他
		return self
	end
	--初始化函数
	function LevelMgr:Init(levelInfo)
		
		--初始化信息
		self._lastBeginLevel = 0		--上一次开始的关卡uniqueID
		self._lastBeginLevelChallenge = 0	--上一次开始的关卡难度级别
		
		self._lastUseHeroCount = 0				--上一次使用英雄数量
		self._lastUseHero = {}					--上一次使用英雄
		self._lastUseTowerCount = 0			--上一次使用塔数量
		self._lastUseTower = {}					--上一次使用塔
		self._lastUseTacticCount = 0			--上一次使用战术卡数量
		self._lastUseTactic = {}				--上一次使用战术卡
		
		self._levelCount = 0			--关卡数量
		self._levelDic = {}			--关卡存储
		
		self:_InitLevelInfo(levelInfo)
		
		return self
	end
	
	--析构函数
	function LevelMgr:Release()
		
		self._lastBeginLevel = -1		--上一次开始的关卡uniqueID
		self._lastBeginLevelChallenge = -1	--上一次开始的关卡难度级别
		
		self._lastUseHeroCount = -1				--上一次使用英雄数量
		self._lastUseHero = -1					--上一次使用英雄
		self._lastUseTowerCount = -1			--上一次使用塔数量
		self._lastUseTower = -1					--上一次使用塔
		self._lastUseTacticCount = -1			--上一次使用战术卡数量
		self._lastUseTactic = -1				--上一次使用战术卡
		
		self._levelCount = -1			--关卡数量
		
		for k, l in pairs(self._levelDic) do
			if l and type(l) == "table" and l:getCName() == "Level" then
				l:Release()
				l = nil
			else
				l = nil
			end
		end
		self._levelDic = -1
		
		return self
	end
	
	------------------------------------------------------------private-------------------------------------------------------
	--初始化英雄信息
	function LevelMgr:_InitLevelInfo(levelInfo)
		if levelInfo then
			local tLevelInfo = hApi.Split(levelInfo or "", ";")
			self._lastBeginLevel = tonumber(tLevelInfo[1]) or 0
			self._lastBeginLevelChallenge = tonumber(tLevelInfo[2]) or 0


			self._levelCount = tonumber(tLevelInfo[3]) or 0

			local infoIdx = 3
			
			--遍历所有英雄
			for i = 1, self._levelCount do
				local strLevelInfo = tHeroInfo[infoIdx + i] or ""
				--local tHeroList = hApi.Split(heroList,":")
				--local id = tonumber(tHeroList[1]) or 0
				--local star = tonumber(tHeroList[2]) or 1
				--local num = tonumber(tHeroList[3]) or 0
				--local totalNum = tonumber(tHeroList[4]) or 0
				
				--if id > 0 then
				--	self._heroDic[id] = hClass.Hero:create():Init(id, star, num, totalNum)
				--end

				local oLevel = hClass.Level:create()
				if oLevel:InitByProtoBuf(strLevelInfo) then
					self._levelDic[oLevel:GetID()] = oLevel
				else
					oLevel = nil
				end
			end
		end
	end

	--检测地图是否合法
	function LevelMgr:_CheckIsInvalid(mapName,challenge)
		local ret = false
		
		--检测静态表是否存在
		if not mapName or not hVar.MAP_INFO[mapName] then
			return ret
		end
		
		--检测进度

		--检测dlc是否开放

		--

		ret = true

		return ret
	end
	------------------------------------------------------------public-------------------------------------------------------
	--获得地图存档信息
	function LevelMgr:GetLevel(uniqueID)
		return self._levelDic[uniqueID]
	end

	--新建一个地图
	function LevelMgr:AddNewLevel(uniqueID)
		local oLevel = hClass.Level:create()
		if oLevel:Init(uniqueID) then
			self._levelDic[oLevel:GetID()] = oLevel
			self._levelCount = self._levelCount + 1
		else
			oLevel = nil
		end
		
		return oLevel
	end
	
	--获取当前正在进行的游戏
	function LevelMgr:GetLastBeginLevel()
		return self._lastBeginLevel,self._lastBeginLevelChallenge
	end
	
	--开始游戏
	function LevelMgr:BeginLevel(mapName, challenge)
		local ret = false
		
		--判定地图是否合法
		if self:_CheckIsInvalid(mapName) then
			local tabM = hVar.MAP_INFO[mapName]
			
			--判定是否已经有存档记录，如果没有则新建
			
			local oLevel = self:GetLevel(uniqueID)
			if not oLevel then
				oLevel = self:AddNewLevel(uniqueID)
			end
			
			if oLevel then
				
				self._lastBeginLevel = tabM.uniqueID
				self._lastBeginLevelChallenge = challenge or 0
				
				--判定当前是否可以开始地图
				ret = true
			end
		end
		
		return ret
	end
	
	--结束游戏
	function LevelMgr:FinishLevel(mapName, challenge, star)
		
	end
	
	
	function LevelMgr:InfoToCmd()
		local cmd = ""
		
		cmd = cmd .. self._lastBeginLevel .. ";" --上一次开始的关卡uniqueID
		cmd = cmd .. self._lastBeginLevelChallenge .. ";" --上一次开始的关卡难度级别
		
		cmd = cmd .. self._lastUseHeroCount  --上一次使用英雄数量
		if (self._lastUseHeroCount == 0) then
			cmd = cmd .. ";"
		else
			for i = 1, self._lastUseHeroCount, 1 do
				cmd = cmd .. ":"
				cmd = cmd .. self._lastUseHero[i] --上一次使用英雄
			end
			
			cmd = cmd .. ";"
		end
		
		cmd = cmd .. self._lastUseTowerCount  --上一次使用塔数量
		if (self._lastUseTowerCount == 0) then
			cmd = cmd .. ";"
		else
			for i = 1, self._lastUseTowerCount, 1 do
				cmd = cmd .. ":"
				cmd = cmd .. self._lastUseTower[i] --上一次使用塔
			end
			
			cmd = cmd .. ";"
		end
		
		cmd = cmd .. self._lastUseTacticCount  --上一次使用战术卡数量
		if (self._lastUseTacticCount == 0) then
			cmd = cmd .. ";"
		else
			for i = 1, self._lastUseTacticCount, 1 do
				cmd = cmd .. ":"
				cmd = cmd .. self._lastUseTactic[i] --上一次使用战术卡
			end
			
			cmd = cmd .. ";"
		end
		
		--关卡信息
		local enum = 0
		for k, level in pairs(self._levelDic) do
			cmd = cmd .. (level:InfoToCmd()) .. ";"
			enum = enum + 1
		end
		
		cmd = cmd .. enum .. ";"
		
		return cmd
	end

return LevelMgr