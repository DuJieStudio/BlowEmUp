--ս�����ܿ�������
local TacticMgr = class("TacticMgr")

	TacticMgr.DEFAULT_TACTICS = {5001,5002,5003,5004,5005,5006,5007,5008,5010,5011,5012,5013,5014,}	--�����Ĭ�ϱ��ֿ�

	--���캯��
	function TacticMgr:ctor()
		
		self._tacticNum = -1		--���Ӣ������
		self._tacticDic = -1		--�洢�������Ӣ����Ϣ

		return self
	end
	--��ʼ������
	function TacticMgr:Init(tacticInfo)
		
		--��ʼ��ս�����ܿ���Ϣ
		self._tacticDic = {}
		self._tacticNum = 0
		
		self:_InitTacticInfo(tacticInfo)
		
		return self
	end
	
	--��������
	function TacticMgr:Release()
		
		for k, t in pairs(self._tacticDic) do
			if t and type(t) == "table" and t:getCName() == "Tactic" then
				t:Release()
				t = nil
			else
				t = nil
			end
		end
		self._tacticDic = -1
		self._tacticNum = -1
		
		return self
	end
	
	------------------------------------------------------------private-------------------------------------------------------
	
	--��ʼ��ս�����ܿ���Ϣ
	function TacticMgr:_InitTacticInfo(tacticInfo)
		local tTacticInfo = hApi.Split(tacticInfo, ";")
		local tacticNum = tonumber(tTacticInfo[1]) or 0
		local infoIdx = 1
		
		--��ʼ��ս�����ܿ���Ϣ
		if self._tacticDic == -1 then
			self._tacticDic = {}
		end
		
		--��������ս����
		for i = 1, tacticNum do
			local tacticList = tTacticInfo[infoIdx + i] or ""
			local tTacticList = hApi.Split(tacticList,":")
			local id = tonumber(tTacticList[1]) or 0
			local num = tonumber(tTacticList[2]) or 0
			local totalNum = tonumber(tTacticList[3]) or 0
			local lv = tonumber(tTacticList[4]) or 0
			local addonsNum = tonumber(tTacticList[5]) or 0
			local addons = {}
			local addonsIdx = 5
			for n = 1, addonsNum do
				addons[n] = tTacticList[addonsIdx + n]
			end
			
			if id > 0 then
				self._tacticDic[id] = hClass.Tactic:create():Init(id, lv, num, totalNum,addonsNum, addons)
				self._tacticNum = self._tacticNum + 1
			end
		end

		--��������ûĬ�Ͽ��飬û�еĻ�Ҫ��
		for i = 1, #TacticMgr.DEFAULT_TACTICS do
			local id = TacticMgr.DEFAULT_TACTICS[i]
			local tactic = self:GetTactic(id)
			if not tactic then
				self._tacticDic[id] = hClass.Tactic:create():Init(id, 1, 0, 0)
				self._tacticNum = self._tacticNum + 1
			end
		end
	end

	------------------------------------------------------------public-------------------------------------------------------
	--��ȡս����
	function TacticMgr:GetTactic(tacticId)
		return self._tacticDic[tacticId]
	end
	
	--���ս������Ƭ
	function TacticMgr:AddTacticDebris(id, num)
		local ret = false
		if id > 0 and num > 0 then
			local tactic = self:GetTactic(id)
			if tactic then
				tactic:AddDebris(num)
				ret = true
			else
				self._tacticDic[id] = hClass.Tactic:create():Init(id, 0, num, num)
				self._tacticNum = self._tacticNum + 1
				ret = true
			end
		end
		return ret
	end
	
	--���ս����
	function TacticMgr:AddTactic(id, lv)
		local ret
		local lv = lv or 1
		if id > 0 and num > 0 then
			local debris = 0
			if hVar.TACTIC_LVUP_INFO and hVar.TACTIC_LVUP_INFO[lv] then
				debris = hVar.TACTIC_LVUP_INFO[lv].toDebris or 0
			end
			
			local tactic = self:GetTactic(id)
			if tactic then
				tactic:AddDebris(debris)
				ret = tactic
			else
				self._tacticDic[id] = hClass.Tactic:create():Init(id, lv or 1, 0, debris)
				self._tacticNum = self._tacticNum + 1
				ret = tactic
			end
		end
		return ret
	end
	
	--����ս����
	function TacticMgr:TacticLevelUp(uid, rid, tacticId)
		local ret = 0
		local sCmd = ""
		
		local tactic = self:GetTactic(tacticId)
		if tactic then
			local lv = tactic:GetLv()
			local debris = tactic:GetDebris()
			local totalDebris = tactic:GetTotalDebris()
			--print(lv)
			--print(debris)
			--print(totalDebris)
			if (lv < hVar.TACTIC_LVUP_INFO.maxTacticLv) then
				local tLevelUpInfo = hVar.TACTIC_LVUP_INFO[lv] or {}
				local shopItemId = tLevelUpInfo.shopItemId or 0
				local costDebris = tLevelUpInfo.costDebris or 0
				if (shopItemId > 0) then
					local tabShopItem = hVar.tab_shopitem[shopItemId]
					local itemId = tabShopItem.itemID
					local coseScore = tabShopItem.score
					local coseRmb = tabShopItem.rmb
					if (debris >= costDebris) then
						--�۳���Ϸ��
						local bSuccess, order_id = hGlobal.userCoinMgr:DBUserPurchase(uid, rid, itemId, 1, coseRmb, 0, tostring(tacticId))
						if bSuccess then
							--�ȼ���1
							tactic._lv = tactic._lv + 1
							
							--�۳���Ƭ
							tactic._debris = tactic._debris - costDebris
							
							--�����ɹ�
							ret = 1
							sCmd = tostring(tactic._lv) .. ";" .. tostring(tactic._debris) .. ";" .. tostring(coseScore) .. ";" .. tostring(costDebris) .. ";" .. tostring(coseRmb) .. ";"
						else
							ret = -4 -- -4:��Ϸ�Ҳ���
						end
					else
						ret = -1 -- -1:��Ƭ����
					end
				else
					ret = -3 -- -3:�������Ϸ�
				end
			else
				ret = -2 -- -2:�ѵ�����
			end
		else
			ret = -1 -- -1:��Ƭ����
		end
		
		sCmd = tostring(ret) .. ";" .. tostring(tacticId) .. ";" .. sCmd
		return ret, sCmd
	end
	
	function TacticMgr:InfoToCmd()
		local cmd = ""
		
		for id, tactic in pairs(self._tacticDic) do
			cmd = cmd .. (tactic:InfoToCmd())
		end

		cmd = (self._tacticNum) .. ";" .. cmd
		return cmd
	end

return TacticMgr