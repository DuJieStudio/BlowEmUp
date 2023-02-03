--成就类
local Achievement = class("Achievement")
	
	--构造函数
	function Achievement:ctor()
		self._uid = -1
		self._rid = -1
		
		return self
	end
	
	--初始化
	function Achievement:Init(uid, rid)
		self._uid = uid
		self._rid = rid
		
		return self
	end
	
	--查询玩家成就和成就完成信息
	function Achievement:QueryInfo()
		local strCmd = ""
		
		--初始化成就信息
		local tAchievementDic = {}
		for i = 1, #hVar.tab_medalEx, 1 do
			local medalId = hVar.tab_medalEx[i]
			tAchievementDic[medalId] = 0
		end
		
		local tAchievementFinish = {} --成就完成表
		
		--读取成就完成信息表
		local sql = string.format("SELECT `achievement` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, achievement = xlDb_Query(sql)
		--print("sql:",sql,e,count)
		if (e == 0) then
			if (type(achievement) == "string") then
				achievement = "{" .. achievement .. "}"
				local tmp = "local prize = " .. achievement .. " return prize"
				
				--成就完成表
				tAchievementFinish = assert(loadstring(tmp))()
				
				--填充完成情况
				for m = 1, #tAchievementFinish, 1 do
					local medalId_m = tAchievementFinish[m][1]
					local state_m = tAchievementFinish[m][2]
					if (state_m == 1) then --成就已领取
						--修改成就信息表
						tAchievementDic[medalId_m] = 1
					end
				end
			end
		end
		
		--转字符串
		strCmd = strCmd .. #hVar.tab_medalEx .. ";"
		for i = 1, #hVar.tab_medalEx, 1 do
			local id = hVar.tab_medalEx[i]
			local state = tAchievementDic[id]
			local tmp = id .. ":" .. state .. ";"
			strCmd = strCmd .. tmp
		end
		
		return strCmd
	end
	
	--领取成就奖励
	function Achievement:TakeReward(medalId)
		local ret = 0
		local strCmd = ""
		local medalState = 0 --成就完成标记
		local tAchievementFinish = {} --成就完成表
		
		--读取成就完成信息表
		local sql = string.format("SELECT `achievement` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, achievement = xlDb_Query(sql)
		--print("sql:",sql,e,count)
		if (e == 0) then
			if (type(achievement) == "string") then
				achievement = "{" .. achievement .. "}"
				local tmp = "local prize = " .. achievement .. " return prize"
				
				--成就完成表
				tAchievementFinish = assert(loadstring(tmp))()
				
				--是否已完成此成就
				for m = 1, #tAchievementFinish, 1 do
					local medalId_m = tAchievementFinish[m][1]
					if (medalId_m == medalId) then --找到了
						medalState = tAchievementFinish[m][2]
						break
					end
				end
			end
		end
		
		if (medalState == 0) then --成就未领奖
			--发奖
			local tAchievement = hVar.tab_medal[medalId] or {}
			local reward = tAchievement.reward or {}
			if (#reward > 0) then
				--领取奖励
				local prizeType = 20008 --奖励类型
				local detail = ""
				detail = detail .. (hVar.tab_stringAchievement[medalId] or hVar.tab_stringAchievement[0]) .. ";"
				for r = 1, #reward, 1 do
					local tReward = reward[r]
					detail = detail .. (tReward[1] or 0) .. ":" .. (tReward[2] or 0) .. ":" .. (tReward[3] or 0) .. ":" .. (tReward[4] or 0) .. ";"
				end
				
				--发奖
				local sInsert = string.format("insert into `prize`(uid,type,mykey,used,create_id) values (%d,%d,'%s',%d,%d)",self._uid,prizeType,detail,0,0)
				xlDb_Execute(sInsert)
				
				--奖励id
				local err1, pid = xlDb_Query("select last_insert_id()")
				if (err1 == 0) then
					--存储奖励信息
					local prizeId = pid --奖励id
					
					--服务器发奖
					local fromIdx = 2
					local prizeContent = hApi.GetRewardInPrize(self._uid, self._rid, prizeId, fromIdx, nil, hVar.tab_string["__TEXT_REWARDTYPE_MAIL"], hVar.REDEQUIP_REWARDTYPE.REWARDTYPE_MAIL)
					strCmd = strCmd .. prizeContent
				end
				
				--更新成就完成表
				local bAdded = false --是否已插入
				for m = 1, #tAchievementFinish, 1 do
					local medalId_m = tAchievementFinish[m][1]
					if (medalId_m == medalId) then --找到了
						tAchievementFinish[m][2] = 1
						bAdded = true
						break
					elseif (medalId_m > medalId) then --id已经比当前大了，需要插到此处
						table.insert(tAchievementFinish, m, {medalId, 1,})
						bAdded = true
						break
					end
				end
				
				--未在中间插入成功，插入到末尾
				if (not bAdded) then
					tAchievementFinish[#tAchievementFinish+1] = {medalId, 1,}
				end
				
				--存档
				local saveData = ""
				for k = 1, #tAchievementFinish, 1 do
					local v = tAchievementFinish[k]
					
					saveData = saveData .. "{"
					for i = 1, #v, 1 do
						saveData = saveData .. v[i] .. ","
					end
					saveData = saveData .. "},\n"
				end
				
				--更新
				local sUpdate = string.format("UPDATE `t_cha` SET `achievement` = '%s' where `id` = %d", saveData, self._rid)
				--print("sUpdate1:",sUpdate)
				xlDb_Execute(sUpdate)
				
				--操作成功
				ret = 1
			else
				ret = -2 --无效的成就id
			end
		else
			ret = -1 --成就已完成
		end
		
		strCmd = ret .. ";" .. tostring(medalId) .. ";" .. strCmd
		return strCmd
	end
	
	--同步成就信息（todo：因历史原因，旧版成就是本地存储，未上传到服务器，因此这里需要上传数据）
	function Achievement:SyncAchievement(medalNum, tMedalInfo)
		local strCmd = ""
		
		--初始化成就信息
		local tAchievementDic = {}
		for i = 1, #hVar.tab_medalEx, 1 do
			local medalId = hVar.tab_medalEx[i]
			tAchievementDic[medalId] = 0
		end
		
		local tAchievementFinish = {} --成就完成表
		
		--读取成就完成信息表
		local sql = string.format("SELECT `achievement` FROM `t_cha` WHERE `id` = %d", self._rid)
		local e, achievement = xlDb_Query(sql)
		--print("sql:",sql,e,count)
		if (e == 0) then
			if (type(achievement) == "string") then
				achievement = "{" .. achievement .. "}"
				local tmp = "local prize = " .. achievement .. " return prize"
				
				--成就完成表
				tAchievementFinish = assert(loadstring(tmp))()
				
				--填充完成情况
				for m = 1, #tAchievementFinish, 1 do
					local medalId_m = tAchievementFinish[m][1]
					local state_m = tAchievementFinish[m][2]
					if (state_m == 1) then --成就已领取
						--修改成就信息表
						tAchievementDic[medalId_m] = 1
					end
				end
			end
		end
		
		--根据客户端上传的完成的成就，修改服务器成就信息
		local bIsSamed = true --数据是否一致（一致则不需要存档）
		for i = 1, medalNum, 1 do
			local medalId = tonumber(tMedalInfo[i]) or 0 --客户端已完成成就id
			if (medalId > 0) then
				--修改成就信息表
				if tAchievementDic[medalId] then
					if (tAchievementDic[medalId] ~= 1) then --服务器状态不是已领取
						tAchievementDic[medalId] = 1
						bIsSamed = false --标记数据不一致
						
						--更新成就完成表
						local bAdded = false --是否已插入
						for m = 1, #tAchievementFinish, 1 do
							local medalId_m = tAchievementFinish[m][1]
							if (medalId_m == medalId) then --找到了
								tAchievementFinish[m][2] = 1
								bAdded = true
								break
							elseif (medalId_m > medalId) then --id已经比当前大了，需要插到此处
								table.insert(tAchievementFinish, m, {medalId, 1,})
								bAdded = true
								break
							end
						end
						
						--未在中间插入成功，插入到末尾
						if (not bAdded) then
							tAchievementFinish[#tAchievementFinish+1] = {medalId, 1,}
						end
					end
				end
			end
		end
		
		if (not bIsSamed) then
			--print("saveData!", self._rid)
			
			--存档
			local saveData = ""
			for k = 1, #tAchievementFinish, 1 do
				local v = tAchievementFinish[k]
				
				saveData = saveData .. "{"
				for i = 1, #v, 1 do
					saveData = saveData .. v[i] .. ","
				end
				saveData = saveData .. "},\n"
			end
			
			--更新
			local sUpdate = string.format("UPDATE `t_cha` SET `achievement` = '%s' where `id` = %d", saveData, self._rid)
			--print("sUpdate1:",sUpdate)
			xlDb_Execute(sUpdate)
		end
		
		--转字符串
		strCmd = strCmd .. #hVar.tab_medalEx .. ";"
		for i = 1, #hVar.tab_medalEx, 1 do
			local id = hVar.tab_medalEx[i]
			local state = tAchievementDic[id]
			local tmp = id .. ":" .. state .. ";"
			strCmd = strCmd .. tmp
		end
		
		return strCmd
	end
	
return Achievement