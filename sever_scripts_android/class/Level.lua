--�ؿ���
local Level = class("Level")
    
	--���캯��
	function Level:ctor()
		self._uniqueID = -1			--Ψһid
		self._isFinish = -1			--�Ƿ�ͨ��
		self._normalStar = -1			--��ǰ��ͨ����
		self._challenge = -1			--��ǰ��ս����
		self._challengeStar = -1		--��ǰ��ս����
		self._finishCountNum = -1		--ͨ��ͳ����Ŀ����
		self._finishCount = -1			--ͨ�ش���ͳ��

		return self
	end
	--��ʼ������
	function Level:Init(uniqueID)

		if uniqueID then
			self._uniqueID = uniqueID		--Ψһid
			self._isFinish = false			--�Ƿ�ͨ��
			self._normalStar = 0			--��ǰ��ͨ����
			self._challenge = 0			--��ǰ��ս����
			self._challengeStar = 0			--��ǰ��ս����
			self._finishCountNum = 4		--ͨ��ͳ����Ŀ����
			self._finishCount = {0,0,0,0}		--ͨ�ش���ͳ��
			return self
		end
	end

	--��ʼ������
	function Level:InitByProtoBuf(levelInfo)

		if levelInfo then
			local tLevelInfo = hApi.Split(levelInfo or "",":")
			self._uniqueID = tonumber(tLevelInfo[1]) or 0			--Ψһid
			self._isFinish = false						--�Ƿ�ͨ��
			if (tonumber(tLevelInfo[2]) or 0) > 0 then
				self._isFinish = true
			end
			self._normalStar = tonumber(tLevelInfo[3]) or 0			--��ǰ��ͨ����
			self._challenge = tonumber(tLevelInfo[4]) or 0			--��ǰ��ս����
			self._challengeStar = tonumber(tLevelInfo[5]) or 0		--��ǰ��ս����

			self._finishCountNum = tonumber(tLevelInfo[6]) or 0		--ͨ��ͳ����Ŀ����
			self._finishCount = {}						--ͨ�ش���ͳ��
			local idx = 6
			for i = 1, self._finishCountNum do
				self._finishCount[i] = tonumber(tLevelInfo[idx + i]) or 0
			end

			return self
		end

		
	end

	--Release
	function Level:Release()

		self._uniqueID = -1			--Ψһid
		self._isFinish = -1			--�Ƿ�ͨ��
		self._normalStar = -1			--��ǰ��ͨ����
		self._challenge = -1			--��ǰ��ս����
		self._challengeStar = -1		--��ǰ��ս����
		self._finishCountNum = 4		--ͨ��ͳ����Ŀ����
		self._finishCount = -1			--ͨ�ش���ͳ��

	end

	------------------------------------------------------------private-------------------------------------------------------
	
	------------------------------------------------------------public-------------------------------------------------------
	--��ȡ�ؿ�Ψһid
	function Level:GetID()
		return self._uniqueID
	end
	--��ȡ�ؿ��Ƿ����
	function Level:GetIsFinish()
		return self._isFinish
	end
	--��ȡ�ؿ���ͨ�Ѷ��Ǽ�
	function Level:GetNormalStar()
		return self._normalStar
	end
	--��ȡ��ǰ��ս����
	function Level:GetChallenge()
		return self._challenge
	end
	--��ȡ��ǰ��ս����
	function Level:GetChallengeStar()
		return self._challengeStar
	end
	--------------------------------------
	--���ùؿ�����
	function Level:SetNormalStar(star)
		self._normalStar = star or 0
	end

	--���õ�ǰ��ս����
	function Level:SetChallenge(challenge)
		self._challenge = challenge or 0
	end

	--���õ�ǰ��ս����
	function Level:SetChallengeStar(star)
		self._challengeStar = star or 0
	end


	--������Ϣת��
	function Level:InfoToCmd()
		local cmd = ""
		
		cmd = cmd .. (self._uniqueID) .. ":"					--Ψһid
		local isFinish = 0
		if self._isFinish then
			isFinish = 1
		end
		cmd = cmd .. (isFinish) .. ":"									--�Ƿ�ͨ��
		cmd = cmd .. (self._normalStar) .. ":"								--��ǰ��ͨ����
		cmd = cmd .. (self._challenge) .. ":"								--��ǰ��ս����
		cmd = cmd .. (self._challengeStar) .. ":"							--��ǰ��ս����
		cmd = cmd .. (self._finishCountNum) .. ":"							--ͨ��ͳ����Ŀ����
		for i = 1, self._finishCountNum do								--ͨ�ش���ͳ��
			cmd = cmd .. (self._finishCount[i])
			if i < self._finishCountNum then
				cmd = cmd .. ":"
			end
		end
		cmd = cmd .. ";"

		return cmd
	end
return Level