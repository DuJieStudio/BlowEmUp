--�ؿ�������
local LevelMgr = class("LevelMgr")

	--���캯��
	function LevelMgr:ctor(flag)
		
		self._lastBeginLevel = -1				--��һ�ο�ʼ�Ĺؿ�uniqueID
		self._lastBeginLevelChallenge = -1		--��һ�ο�ʼ�Ĺؿ��Ѷȼ���
		self._lastUseHeroCount = -1				--��һ��ʹ��Ӣ������
		self._lastUseHero = -1					--��һ��ʹ��Ӣ��
		self._lastUseTowerCount = -1			--��һ��ʹ��������
		self._lastUseTower = -1					--��һ��ʹ����
		self._lastUseTacticCount = -1			--��һ��ʹ��ս��������
		self._lastUseTactic = -1				--��һ��ʹ��ս����
		self._levelCount = -1					--�ؿ�����
		self._levelDic = -1						--�ؿ��洢

		--����
		return self
	end
	--��ʼ������
	function LevelMgr:Init(levelInfo)
		
		--��ʼ����Ϣ
		self._lastBeginLevel = 0		--��һ�ο�ʼ�Ĺؿ�uniqueID
		self._lastBeginLevelChallenge = 0	--��һ�ο�ʼ�Ĺؿ��Ѷȼ���
		
		self._lastUseHeroCount = 0				--��һ��ʹ��Ӣ������
		self._lastUseHero = {}					--��һ��ʹ��Ӣ��
		self._lastUseTowerCount = 0			--��һ��ʹ��������
		self._lastUseTower = {}					--��һ��ʹ����
		self._lastUseTacticCount = 0			--��һ��ʹ��ս��������
		self._lastUseTactic = {}				--��һ��ʹ��ս����
		
		self._levelCount = 0			--�ؿ�����
		self._levelDic = {}			--�ؿ��洢
		
		self:_InitLevelInfo(levelInfo)
		
		return self
	end
	
	--��������
	function LevelMgr:Release()
		
		self._lastBeginLevel = -1		--��һ�ο�ʼ�Ĺؿ�uniqueID
		self._lastBeginLevelChallenge = -1	--��һ�ο�ʼ�Ĺؿ��Ѷȼ���
		
		self._lastUseHeroCount = -1				--��һ��ʹ��Ӣ������
		self._lastUseHero = -1					--��һ��ʹ��Ӣ��
		self._lastUseTowerCount = -1			--��һ��ʹ��������
		self._lastUseTower = -1					--��һ��ʹ����
		self._lastUseTacticCount = -1			--��һ��ʹ��ս��������
		self._lastUseTactic = -1				--��һ��ʹ��ս����
		
		self._levelCount = -1			--�ؿ�����
		
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
	--��ʼ��Ӣ����Ϣ
	function LevelMgr:_InitLevelInfo(levelInfo)
		if levelInfo then
			local tLevelInfo = hApi.Split(levelInfo or "", ";")
			self._lastBeginLevel = tonumber(tLevelInfo[1]) or 0
			self._lastBeginLevelChallenge = tonumber(tLevelInfo[2]) or 0


			self._levelCount = tonumber(tLevelInfo[3]) or 0

			local infoIdx = 3
			
			--��������Ӣ��
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

	--����ͼ�Ƿ�Ϸ�
	function LevelMgr:_CheckIsInvalid(mapName,challenge)
		local ret = false
		
		--��⾲̬���Ƿ����
		if not mapName or not hVar.MAP_INFO[mapName] then
			return ret
		end
		
		--������

		--���dlc�Ƿ񿪷�

		--

		ret = true

		return ret
	end
	------------------------------------------------------------public-------------------------------------------------------
	--��õ�ͼ�浵��Ϣ
	function LevelMgr:GetLevel(uniqueID)
		return self._levelDic[uniqueID]
	end

	--�½�һ����ͼ
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
	
	--��ȡ��ǰ���ڽ��е���Ϸ
	function LevelMgr:GetLastBeginLevel()
		return self._lastBeginLevel,self._lastBeginLevelChallenge
	end
	
	--��ʼ��Ϸ
	function LevelMgr:BeginLevel(mapName, challenge)
		local ret = false
		
		--�ж���ͼ�Ƿ�Ϸ�
		if self:_CheckIsInvalid(mapName) then
			local tabM = hVar.MAP_INFO[mapName]
			
			--�ж��Ƿ��Ѿ��д浵��¼�����û�����½�
			
			local oLevel = self:GetLevel(uniqueID)
			if not oLevel then
				oLevel = self:AddNewLevel(uniqueID)
			end
			
			if oLevel then
				
				self._lastBeginLevel = tabM.uniqueID
				self._lastBeginLevelChallenge = challenge or 0
				
				--�ж���ǰ�Ƿ���Կ�ʼ��ͼ
				ret = true
			end
		end
		
		return ret
	end
	
	--������Ϸ
	function LevelMgr:FinishLevel(mapName, challenge, star)
		
	end
	
	
	function LevelMgr:InfoToCmd()
		local cmd = ""
		
		cmd = cmd .. self._lastBeginLevel .. ";" --��һ�ο�ʼ�Ĺؿ�uniqueID
		cmd = cmd .. self._lastBeginLevelChallenge .. ";" --��һ�ο�ʼ�Ĺؿ��Ѷȼ���
		
		cmd = cmd .. self._lastUseHeroCount  --��һ��ʹ��Ӣ������
		if (self._lastUseHeroCount == 0) then
			cmd = cmd .. ";"
		else
			for i = 1, self._lastUseHeroCount, 1 do
				cmd = cmd .. ":"
				cmd = cmd .. self._lastUseHero[i] --��һ��ʹ��Ӣ��
			end
			
			cmd = cmd .. ";"
		end
		
		cmd = cmd .. self._lastUseTowerCount  --��һ��ʹ��������
		if (self._lastUseTowerCount == 0) then
			cmd = cmd .. ";"
		else
			for i = 1, self._lastUseTowerCount, 1 do
				cmd = cmd .. ":"
				cmd = cmd .. self._lastUseTower[i] --��һ��ʹ����
			end
			
			cmd = cmd .. ";"
		end
		
		cmd = cmd .. self._lastUseTacticCount  --��һ��ʹ��ս��������
		if (self._lastUseTacticCount == 0) then
			cmd = cmd .. ";"
		else
			for i = 1, self._lastUseTacticCount, 1 do
				cmd = cmd .. ":"
				cmd = cmd .. self._lastUseTactic[i] --��һ��ʹ��ս����
			end
			
			cmd = cmd .. ";"
		end
		
		--�ؿ���Ϣ
		local enum = 0
		for k, level in pairs(self._levelDic) do
			cmd = cmd .. (level:InfoToCmd()) .. ";"
			enum = enum + 1
		end
		
		cmd = cmd .. enum .. ";"
		
		return cmd
	end

return LevelMgr