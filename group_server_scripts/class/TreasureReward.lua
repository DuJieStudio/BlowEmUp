--宝物碎片奖励类
local TreasureReward = class("TreasureReward")
	--id
	--TreasureReward.ACTIVITY_ID = 1
	
	--构造函数
	function TreasureReward:ctor()
		self._uid = -1
		self._rid = -1
		
		return self
	end
	
	--初始化
	function TreasureReward:Init(uid, rid)
		self._uid = uid
		self._rid = rid
		
		return self
	end
	
	--宝物碎片发奖
	function TreasureReward:TakeReward(rewardType, itemId, itemNum)
		--无效的道具id
		local tabI = hVar.tab_item[itemId] or {}
		local treasureId = tabI.treasureID or 0
		if (treasureId == 0) then
			return
		end
		
		--无效的数量
		if (itemNum <= 0) then
			return
		end
		
		--先读取存档
		local tTreasure = {}
		local sql = string.format("SELECT `treasure` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, treasure = xlDb_Query(sql)
		--print("sql:",sql,e,count)
		if (e == 0) then
			if (type(treasure) == "string") then
				treasure = "{" .. treasure .. "}"
				local tmp = "local prize = " .. treasure .. " return prize"
				--防御塔属性强化表
				tTreasure = assert(loadstring(tmp))()
			end
		end
		
		--遍历是否存在该宝物碎片，叠加数量
		local bExisted = false
		for i = 1, #tTreasure, 1 do
			local id = tTreasure[i][1]
			local lv = tTreasure[i][2]
			local num = tTreasure[i][3]
			
			if (id == treasureId) then --找到了
				bExisted = true
				
				tTreasure[i][3] = num + itemNum
				
				break
			end
		end
		
		--不存在的宝物碎片，末尾新增数据
		if (not bExisted) then
			tTreasure[#tTreasure+1] = {treasureId, 0, itemNum,}
		end
		
		--按照序号转换成字典表
		local tTreasureDic = {}
		for k, v in ipairs(tTreasure) do
			local id = tTreasure[k][1]
			tTreasureDic[id] = v
		end
		
		--存档
		local saveData = ""
		for k = 1, #hVar.tab_treasure, 1 do
			local v = tTreasureDic[k]
			if v then
				saveData = saveData .. "{"
				for i = 1, #v, 1 do
					saveData = saveData .. v[i] .. ","
				end
				saveData = saveData .. "},\n"
			end
		end
		
		--更新
		local sUpdate = string.format("UPDATE `t_cha` SET `treasure` = '%s' where `id` = %d", saveData, self._rid)
		--print("sUpdate1:",sUpdate)
		xlDb_Execute(sUpdate)
	end
	
	--点击游戏讨论发奖
	function TreasureReward:ToDisgussReward()
		local ret = 0
		
		--读取上次领奖的时间
		local sql = string.format("SELECT `last_todisguss_prize_get_time` FROM `t_user` WHERE `uid` = %d", self._uid)
		local err, strDate = xlDb_Query(sql)
		if (err == 0) then
			--检测是否为同一天
			local tab1 = os.date("*t", hApi.GetNewDate(strDate))
			local tab2 = os.date("*t", os.time())
			if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
				--读取玩家宝物信息
				local tTreasure = {}
				local sql = string.format("SELECT `treasure` FROM `t_cha` WHERE `id` = %d", self._rid)
				local e, treasure = xlDb_Query(sql)
				--print("sql:",sql,e,count)
				if (e == 0) then
					if (type(treasure) == "string") then
						treasure = "{" .. treasure .. "}"
						local tmp = "local prize = " .. treasure .. " return prize"
						--防御塔属性强化表
						tTreasure = assert(loadstring(tmp))()
					end
				end
				
				--剑仙长明灯
				local treasureId = 23
				local treasureLv = 0
				for i = 1, #tTreasure, 1 do
					local id = tTreasure[i][1]
					local lv = tTreasure[i][2]
					local num = tTreasure[i][3]
					
					if (id == treasureId) then --找到了
						treasureLv = lv
						
						break
					end
				end
				
				--剑仙长明灯等级
				if (treasureLv > 0) then
					--插入领奖记录
					local mykey = hVar.tab_string["__TEXT_TODISGUSS_PRIZE"]
					local sqlInsert = string.format("insert into `prize`(`uid`, `type`, `mykey`) values (%d, %d, '%s')", self._uid, 20008, mykey)
					xlDb_Execute(sqlInsert)
					
					--更新领奖时间
					local insertSql = string.format("update `t_user` set `last_todisguss_prize_get_time` = NOW() where `uid` = %d", self._uid)
					xlDb_Execute(insertSql)
					
					ret = 1
				else
					ret = -2 --宝物剑仙长明灯等级不够
				end
			else
				ret = -1 --今日已领取
			end
		end
		
		local sL2CCmd = tostring(ret) .. ";"
		return sL2CCmd
	end
	
return TreasureReward