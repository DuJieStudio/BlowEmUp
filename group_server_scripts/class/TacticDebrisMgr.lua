--战术卡碎片管理类
local TacticDebrisMgr = class("TacticDebrisMgr")
	
	--构造函数
	function TacticDebrisMgr:ctor()
		--其他
		return self
	end
	
	--初始化函数
	function TacticDebrisMgr:Init()
		return self
	end
	
	------------------------------------------------------------private-------------------------------------------------------
	--
	
	------------------------------------------------------------public-------------------------------------------------------
	
	--扣除玩家战术卡碎片数量
	function TacticDebrisMgr:DBDecreaseUserTacticDebris(uid, rid, tCardList)
		local reward = hClass.Reward:create():Init()
		
		for t = 1, #tCardList, 1 do
			local tacticId = tCardList[t].id
			local tacticNum = tCardList[t].num
			local tabT = hVar.tab_tactics[tacticId]
			local itemId = tabT.debrisItemId
			
			local rewardT = {6, itemId, -tacticNum, 0,}
			reward:Add(rewardT)
		end
		
		--发奖
		reward:TakeReward(uid, rid)
		
		--[[
		--服务器处理任务奖励
		--hApi.RewardPreprocessing(uid, rid, reward, #tCardList)
		--服务器处理宝箱数据
		local tReward = reward:GetInfo()
		local rewardLength = reward:GetNum()
		
		local tacticDic = {}
		
		--先预处理下，看看需不需要操作数据库
		local sql = string.format("SELECT pu.uid,pu.tacticInfo FROM t_pvp_user as pu where pu.id=%d",rid)
		local err,uuid,tacticInfo = xlDb_Query(sql)
		if err == 0 then
			--战术技能卡初始化
			tacticDic = hApi.InitTacticInfo(tacticInfo)
			
			--只奖励前n个东西
			for i = 1, rewardLength, 1 do
				local rewardT = tReward[i]
				if rewardT then
					local itemId = tonumber(rewardT[2]) or 0
					local itemNum = tonumber(rewardT[3]) or 1
					if itemId > 0 and hVar.tab_item[itemId] and itemNum > 0 then
						local tacticId = hVar.tab_item[itemId].tacticID or 0
						if tacticId > 0 then
							hApi.AddTactic(tacticDic, tacticId, itemNum)
						end
					end
				end
			end
			
			--存档
			local saveInfo = ""
			saveInfo = string.format("tacticInfo='%s'",hApi.TacticInfoToCmd(tacticDic))
			local sql = string.format("UPDATE t_pvp_user SET " .. saveInfo .. " WHERE id=%d",rid)
			local err = xlDb_Execute(sql)
		end
		]]
	end
	
return TacticDebrisMgr