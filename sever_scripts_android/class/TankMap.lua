--战车地图类
local TankMap = class("TankMap")
	
	--构造函数
	function TankMap:ctor()
		self._uid = -1
		self._rid = -1
		
		return self
	end
	
	--初始化
	function TankMap:Init(uid, rid)
		self._uid = uid
		self._rid = rid
		
		return self
	end
	
	--查询玩家地图信息
	function TankMap:QueryInfo()
		local strCmd = ""
		
		--读取地图数据
		local tMap = {}
		local sql = string.format("SELECT `mapInfo` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, mapInfo = xlDb_Query(sql)
		--print("sql:",sql,e,mapInfo, type(mapInfo))
		if (e == 0) then
			if (type(mapInfo) == "string") and (#mapInfo > 0) then
				mapInfo = "{" .. mapInfo .. "}"
				local tmp = "local prize = " .. mapInfo .. " return prize"
				--地图信息表
				tMap = assert(loadstring(tmp))()
			end
		end
		
		strCmd = strCmd .. #tMap .. ";"
		for i = 1, #tMap, 1 do
			local mapName = tostring(tMap[i][1]) --地图名
			local star0 = tonumber(tMap[i][2]) or 0 --地图普通星星
			local star1 = tonumber(tMap[i][3]) or 0 --地图难度1星星
			local star2 = tonumber(tMap[i][4]) or 0 --地图难度2星星
			local star3 = tonumber(tMap[i][5]) or 0 --地图难度3星星
			local passcount = tonumber(tMap[i][6]) or 0 --通关次数
			local battlecount = tonumber(tMap[i][7]) or 0 --挑战次数
			local maxdifficulty = tonumber(tMap[i][8]) or 0 --最大通关难度
			local tmp = mapName .. ":" .. star0 .. ":" .. star1 .. ":" .. star2 .. ":" .. star3 .. ":" .. passcount .. ":" .. battlecount .. ":" .. maxdifficulty .. ";"
			strCmd = strCmd .. tmp
		end
		
		return strCmd, tMap
	end
	
	--增加地图通关信息和通关奖励
	function TankMap:MapFinish(tankId, mapName, mapMode, mapDifficulty, nIsWin, nExpAdd, nStar, nScientistNum, nKillEnemyNum, nKillBossNum, nTankDeadthNum, nSufferDmg, nQSZDWave, nRandomMapStage, tTacticInfo, tChestInfo)
		--获得地图信息
		local _, tMap = self:QueryInfo()
		local tMapInfo = nil
		for i = 1, #tMap, 1 do
			local tMapInfo_i = tMap[i]
			if (tMapInfo_i[1] == mapName) then --找到了
				tMapInfo = tMapInfo_i
				break
			end
		end
		--没有找到
		if (tMapInfo == nil) then
			tMapInfo = {mapName, 0, 0, 0, 0, 0, 0, 0,}
			tMap[#tMap+1] = tMapInfo
		end
		
		--通关奖励
		local tReward = hClass.Reward:create():Init()
		
		if (mapMode == hVar.MAP_TD_TYPE.ENDLESS) then
			-- 无尽模式只更新难度，不记录星星
			if nIsWin == 1 then
				local maxMapDifficulty = tMapInfo[8] or 0	--历史最高难度
				local currentMapDifficulty = mapDifficulty	--当前难度
				local tMapInfoTable = hVar.MAP_INFO[mapName]
				local reward = nil
				if currentMapDifficulty > maxMapDifficulty then
					-- 首通奖励
					reward = tMapInfoTable.DiffMode[mapDifficulty].starReward
				else
					-- 随机奖励
					reward = {}
				end
				for i = 1, #reward do
					tReward:Add(reward[i])
				end
			end
		else
			-- 非无尽模式更新难度和星星
			local tMapInfoTable = hVar.MAP_INFO[mapName]
			local reward = nil
			if (mapDifficulty == 0) then --普通难度
				reward = tMapInfoTable.starReward or {}
			elseif (mapDifficulty > 0) then --挑战模式
				reward = tMapInfoTable.DiffMode[mapDifficulty] and tMapInfoTable.DiffMode[mapDifficulty].starReward or {}
			end
			--检测应该发哪一档的奖励
			local star = 0
			if (mapDifficulty == 0) then --普通难度
				star = tMapInfo[2] --地图普通星星
			elseif (mapDifficulty == 1) then --难度1
				star = tMapInfo[3] --地图难度1星星
			elseif (mapDifficulty == 2) then --难度2
				star = tMapInfo[4] --地图难度2星星
			elseif (mapDifficulty == 3) then --难度3
				star = tMapInfo[5] --地图难度3星星
	
			end
			
			--本次获得的星星评价
			local currentStar = nStar
			
			--如果本次获得更多的星星，更新星星，并发奖
			if (currentStar > star) then
				for r = star + 1, currentStar, 1 do
					tReward:Add(reward[r])
				end
				
				if (mapDifficulty == 0) then --普通难度
					tMapInfo[2] = currentStar --地图普通星星
				elseif (mapDifficulty == 1) then --难度1
					tMapInfo[3] = currentStar --地图难度1星星
				elseif (mapDifficulty == 2) then --难度2
					tMapInfo[4] = currentStar --地图难度2星星
				elseif (mapDifficulty == 3) then --难度3
					tMapInfo[5] = currentStar --地图难度3星星
				end
			end
		end
		
		--增加通关次数
		if (nIsWin == 1) then
			tMapInfo[6] = tMapInfo[6] + 1
		end
		
		--增加挑战次数
		tMapInfo[7] = tMapInfo[7] + 1
		
		--更新最大难度
		if (nIsWin == 1) then
			local maxdifficulty = tMapInfo[8] or 0 --最大通关难度
			if (mapDifficulty > maxdifficulty) then
				tMapInfo[8] = mapDifficulty
			end
		end
		
		--存档
		local saveData = ""
		for k = 1, #tMap, 1 do
			local v = tMap[k]
			--print("v", v)
			if v then
				saveData = saveData .. "{"
				for i = 1, #v, 1 do
					if (type(v[i]) == "string") then
						saveData = saveData .. "\"" .. v[i] .. "\","
					else
						saveData = saveData .. v[i] .. ","
					end
				end
				saveData = saveData .. "},\n"
				--print("saveData", saveData)
			end
		end
		--print("TankMap saveData:\n", saveData)
		
		--更新
		local sUpdate = string.format("UPDATE `t_cha` SET `mapInfo` = '%s' where `id` = %d", saveData, self._rid)
		--print("sUpdate1:",sUpdate)
		xlDb_Execute(sUpdate)
		
		--无尽模式，玩家获得的宝箱也增加数量
		if (mapMode == hVar.MAP_TD_TYPE.ENDLESS) then
			if (#tChestInfo > 0) then
				local weapon_chest = 0 --武器枪宝箱数量
				local tactic_chest = 0 --战术卡宝箱数量
				local pet_chest = 0 --宠物宝箱枪数量
				local equip_chest = 0 --装备宝箱枪数量
				
				for c = 1, #tChestInfo, 1 do
					local tInfo = tChestInfo[c]
					local itemId = tInfo.id or 0
					local debrisNum = tInfo.num or 0
					if (itemId > 0) and (debrisNum > 0) then
						local tabI = hVar.tab_item[itemId]
						if tabI then
							local itemType = tabI.type --道具类型
							
							--增加碎片
							if (itemType == hVar.ITEM_TYPE.CHEST_WEAPON_GUN) then --武器枪宝箱
								weapon_chest = weapon_chest + debrisNum
							elseif (itemType == hVar.ITEM_TYPE.CHEST_TACTIC) then --战术宝箱
								tactic_chest = tactic_chest + debrisNum
							elseif (itemType == hVar.ITEM_TYPE.CHEST_PET) then --宠物宝箱
								pet_chest = pet_chest + debrisNum
							elseif (itemType == hVar.ITEM_TYPE.CHEST_EQUIP) then --装备宝箱
								equip_chest = equip_chest + debrisNum
							end
						end
					end
				end
				
				--更新
				local sUpdate = string.format("UPDATE `t_user` SET `weapon_chest` = `weapon_chest` + %d, `tactic_chest` = `tactic_chest` + %d, `pet_chest` = `pet_chest` + %d, `equip_chest` = `equip_chest` + %d WHERE `uid` = %d", weapon_chest, tactic_chest, pet_chest, equip_chest, self._uid)
				--print("sUpdate1:",sUpdate)
				xlDb_Execute(sUpdate)
			end
		end
		
		--无尽模式，玩家获得的战术卡也增加数量
		--print("mapMode=", mapMode, "hVar.MAP_TD_TYPE.ENDLESS=", hVar.MAP_TD_TYPE.ENDLESS)
		if (mapMode == hVar.MAP_TD_TYPE.ENDLESS) then
			if (#tTacticInfo > 0) then
				for c = 1, #tTacticInfo, 1 do
					local tInfo = tTacticInfo[c]
					local itemId = tInfo.id or 0
					local debrisNum = tInfo.num or 0
					--print("itemId=", itemId, "debrisNum=", debrisNum)
					if (itemId > 0) and (debrisNum > 0) then
						local tabI = hVar.tab_item[itemId]
						if tabI then
							local itemType = tabI.type --道具类型
							local tacticId = 0
							
							if (itemType == hVar.ITEM_TYPE.TACTICDEBRIS) then --战术卡碎片
								tacticId = tabI.tacticID or 0
							elseif (itemType == hVar.ITEM_TYPE.TACTIC_USE) then --地图内使用类战术卡道具
								tacticId = tabI.tacticId or 0
							end
							
							--print("tacticId=", tacticId)
							if (tacticId > 0) then
								--发奖
								local tacticItemId = hVar.tab_tactics[tacticId].debrisItemId
								local tt = {6, tacticItemId, debrisNum, 0,}
								--print("发奖 tacticItemId=", tacticItemId)
								--local reward = hClass.Reward:create():Init()
								--reward:Add(tt)
								--tReward:TakeReward(self._uid, self._rid)
								tReward:Add(tt)
							end
						end
					end
				end
			end
		end
		
		--增加科学家数量
		if (nExpAdd > 0) or (mapName == hVar.GuideMap) then
			if (nScientistNum > 0) then
				--更新
				local sUpdate = string.format("UPDATE `t_user` SET `scientist` = `scientist` + %d WHERE `uid` = %d", nScientistNum, self._uid)
				--print("sUpdate1:",sUpdate)
				xlDb_Execute(sUpdate)
			end
		end
		
		--增加战车死亡数量
		if (nTankDeadthNum > 0) then
			--更新
			local sUpdate = string.format("UPDATE `t_user` SET `deadth` = `deadth` + %d WHERE `uid` = %d", nTankDeadthNum, self._uid)
			--print("sUpdate1:",sUpdate)
			xlDb_Execute(sUpdate)
		end
		
		--随机迷宫地图，上传排行榜
		if (mapName == hVar.RandomMap) then
			local cBId = 1
			local sCfg = ""
			hGlobal.bbMgr:DBUpdateUserBillboardData(self._uid, self._rid, cBId, nRandomMapStage, sCfg)
		end
		
		--发奖
		tReward:TakeReward(self._uid, self._rid)
		local sCmd = tReward:ToCmd()
		
		--更新玩家的总星星
		if (nIsWin == 1) then
			local totalStar = 0
			for i = 1, #tMap, 1 do
				local tMapInfo_i = tMap[i]
				local mapName = tMapInfo_i[1] --地图名
				
				if (mapName ~= hVar.GuideMap) and (mapName ~= hVar.MainBase) and (mapName ~= hVar.LoginMap) and (mapName ~= hVar.RandomMap)
				and (mapName ~= hVar.QianShaoZhenDiMap) and (mapName ~= hVar.MuChaoZhiZhanMap) and (mapName ~= hVar.DuoBaoQiBingMap) then
					local star0 = tMapInfo_i[2] --地图普通星星
					local star1 = tMapInfo_i[3] --地图难度1星星
					local star2 = tMapInfo_i[4] --地图难度2星星
					local star3 = tMapInfo_i[5] --地图难度3星星
					
					totalStar = totalStar + star0 + star1 + star2 + star3
				end
			end
			--更新
			local sUpdate = string.format("UPDATE `t_cha` SET `mapstar` = %d WHERE `id` = %d and `uid` = %d", totalStar, self._rid, self._uid)
			--print("sUpdate1:",sUpdate)
			xlDb_Execute(sUpdate)
		end
		
		--附加关卡信息
		sCmd = tostring(tMapInfo[1]) .. ";" .. tostring(tMapInfo[2]) .. ";" .. tostring(tMapInfo[3]) .. ";" .. tostring(tMapInfo[4]) .. ";" .. 
			tostring(tMapInfo[5]) .. ";" .. tostring(tMapInfo[6]) .. ";" .. tostring(tMapInfo[7]) .. ";" .. tostring(tMapInfo[8]) .. ";" .. sCmd
		
		return sCmd
	end
	
	
return TankMap