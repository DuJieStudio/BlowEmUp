--关卡类
local Level = class("Level")
    
	--构造函数
	function Level:ctor()
		self._uniqueID = -1			--唯一id
		self._isFinish = -1			--是否通关
		self._normalStar = -1			--当前普通星数
		self._challenge = -1			--当前挑战级别
		self._challengeStar = -1		--当前挑战星数
		self._finishCountNum = -1		--通关统计条目数量
		self._finishCount = -1			--通关次数统计

		return self
	end
	--初始化函数
	function Level:Init(uniqueID)

		if uniqueID then
			self._uniqueID = uniqueID		--唯一id
			self._isFinish = false			--是否通关
			self._normalStar = 0			--当前普通星数
			self._challenge = 0			--当前挑战级别
			self._challengeStar = 0			--当前挑战星数
			self._finishCountNum = 4		--通关统计条目数量
			self._finishCount = {0,0,0,0}		--通关次数统计
			return self
		end
	end

	--初始化函数
	function Level:InitByProtoBuf(levelInfo)

		if levelInfo then
			local tLevelInfo = hApi.Split(levelInfo or "",":")
			self._uniqueID = tonumber(tLevelInfo[1]) or 0			--唯一id
			self._isFinish = false						--是否通关
			if (tonumber(tLevelInfo[2]) or 0) > 0 then
				self._isFinish = true
			end
			self._normalStar = tonumber(tLevelInfo[3]) or 0			--当前普通星数
			self._challenge = tonumber(tLevelInfo[4]) or 0			--当前挑战级别
			self._challengeStar = tonumber(tLevelInfo[5]) or 0		--当前挑战星数

			self._finishCountNum = tonumber(tLevelInfo[6]) or 0		--通关统计条目数量
			self._finishCount = {}						--通关次数统计
			local idx = 6
			for i = 1, self._finishCountNum do
				self._finishCount[i] = tonumber(tLevelInfo[idx + i]) or 0
			end

			return self
		end

		
	end

	--Release
	function Level:Release()

		self._uniqueID = -1			--唯一id
		self._isFinish = -1			--是否通关
		self._normalStar = -1			--当前普通星数
		self._challenge = -1			--当前挑战级别
		self._challengeStar = -1		--当前挑战星数
		self._finishCountNum = 4		--通关统计条目数量
		self._finishCount = -1			--通关次数统计

	end

	------------------------------------------------------------private-------------------------------------------------------
	
	------------------------------------------------------------public-------------------------------------------------------
	--获取关卡唯一id
	function Level:GetID()
		return self._uniqueID
	end
	--获取关卡是否完成
	function Level:GetIsFinish()
		return self._isFinish
	end
	--获取关卡普通难度星级
	function Level:GetNormalStar()
		return self._normalStar
	end
	--获取当前挑战级别
	function Level:GetChallenge()
		return self._challenge
	end
	--获取当前挑战星数
	function Level:GetChallengeStar()
		return self._challengeStar
	end
	--------------------------------------
	--设置关卡星星
	function Level:SetNormalStar(star)
		self._normalStar = star or 0
	end

	--设置当前挑战级别
	function Level:SetChallenge(challenge)
		self._challenge = challenge or 0
	end

	--设置当前挑战星数
	function Level:SetChallengeStar(star)
		self._challengeStar = star or 0
	end


	--基本信息转化
	function Level:InfoToCmd()
		local cmd = ""
		
		cmd = cmd .. (self._uniqueID) .. ":"					--唯一id
		local isFinish = 0
		if self._isFinish then
			isFinish = 1
		end
		cmd = cmd .. (isFinish) .. ":"									--是否通关
		cmd = cmd .. (self._normalStar) .. ":"								--当前普通星数
		cmd = cmd .. (self._challenge) .. ":"								--当前挑战级别
		cmd = cmd .. (self._challengeStar) .. ":"							--当前挑战星数
		cmd = cmd .. (self._finishCountNum) .. ":"							--通关统计条目数量
		for i = 1, self._finishCountNum do								--通关次数统计
			cmd = cmd .. (self._finishCount[i])
			if i < self._finishCountNum then
				cmd = cmd .. ":"
			end
		end
		cmd = cmd .. ";"

		return cmd
	end
return Level