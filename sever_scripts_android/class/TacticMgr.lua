--战术技能卡管理类
local TacticMgr = class("TacticMgr")

	TacticMgr.DEFAULT_TACTICS = {5001,5002,5003,5004,5005,5006,5007,5008,5010,5011,5012,5013,5014,}	--新玩家默认兵种卡

	--构造函数
	function TacticMgr:ctor()
		
		self._tacticNum = -1		--玩家英雄数量
		self._tacticDic = -1		--存储玩家所有英雄信息

		return self
	end
	--初始化函数
	function TacticMgr:Init(tacticInfo)
		
		--初始化战术技能卡信息
		self._tacticDic = {}
		self._tacticNum = 0
		
		self:_InitTacticInfo(tacticInfo)
		
		return self
	end
	
	--析构函数
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
	
	--初始化战术技能卡信息
	function TacticMgr:_InitTacticInfo(tacticInfo)
		local tTacticInfo = hApi.Split(tacticInfo, ";")
		local tacticNum = tonumber(tTacticInfo[1]) or 0
		local infoIdx = 1
		
		--初始化战术技能卡信息
		if self._tacticDic == -1 then
			self._tacticDic = {}
		end
		
		--遍历所有战术卡
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

		--检测玩家有没默认卡组，没有的话要送
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
	--获取战术卡
	function TacticMgr:GetTactic(tacticId)
		return self._tacticDic[tacticId]
	end
	
	--添加战术卡碎片
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
	
	--添加战术卡
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
	
	--升级战术卡
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
						--扣除游戏币
						local bSuccess, order_id = hGlobal.userCoinMgr:DBUserPurchase(uid, rid, itemId, 1, coseRmb, 0, tostring(tacticId))
						if bSuccess then
							--等级加1
							tactic._lv = tactic._lv + 1
							
							--扣除碎片
							tactic._debris = tactic._debris - costDebris
							
							--操作成功
							ret = 1
							sCmd = tostring(tactic._lv) .. ";" .. tostring(tactic._debris) .. ";" .. tostring(coseScore) .. ";" .. tostring(costDebris) .. ";" .. tostring(coseRmb) .. ";"
						else
							ret = -4 -- -4:游戏币不足
						end
					else
						ret = -1 -- -1:碎片不足
					end
				else
					ret = -3 -- -3:参数不合法
				end
			else
				ret = -2 -- -2:已到顶级
			end
		else
			ret = -1 -- -1:碎片不足
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