--军团奖励类
local GroupReward = class("GroupReward")
	--id
	--GroupReward.ACTIVITY_ID = 1
	
	--构造函数
	function GroupReward:ctor()
		self._uid = -1
		self._rid = -1
		
		return self
	end
	
	--初始化
	function GroupReward:Init(uid, rid)
		self._uid = uid
		self._rid = rid
		
		return self
	end
	
	--军团发奖
	function GroupReward:TakeReward(resType, resNum, create_id)
		local groupId = create_id or 0
		
		if (groupId == 0) then
			--查询玩家所在的军团id
			local sQuery = string.format("SELECT `ncid` from `novicecamp_member` where `uid` = %d and `level` > 0", self._uid)
			local err, ncid = xlDb_Query(sQuery)
			
			if (err == 0) then
				groupId = ncid
			end
		end
		
		if (groupId > 0) then
			--资源类型
			local strResType = nil
			
			if (resType == 16) then --16:铁 --geyachao: 新加房间的配置项 军团
				strResType = "mat_iron"
			elseif (resType == 17) then --17:木材 --geyachao: 新加房间的配置项 军团
				strResType = "mat_wood"
			elseif (resType == 18) then --18:粮食 --geyachao: 新加房间的配置项 军团
				strResType = "mat_food"
			end
			
			--有效的资源类型
			if (strResType) then
				--更新资源
				local sUpdate = string.format("update `novicecamp_list` set `%s` = `%s` + %d where `id` = %d", strResType, strResType, resNum, groupId)
				xlDb_Execute(sUpdate)
			end
			
			--军团币资源
			local groupCoinAdd = 0
			if (resType == 20) then --20:军团币 --geyachao: 新加房间的配置项 军团
				groupCoinAdd = resNum
			end
			
			if (groupCoinAdd > 0) then
				--更新军团币
				local sUpdate = string.format("update `t_chat_user` set `group_coin` = `group_coin` + %d where `uid` = %d", groupCoinAdd, self._uid)
				xlDb_Execute(sUpdate)
				--print(sUpdate)
			end
		end
	end
	
return GroupReward