--战术技能卡管理类
local GameGopherMgr = class("GameGopherMgr")


--炸地鼠难度配置表
hVar.GameGopherDiffDefine = {
	[1] = {
		unitid = 11109,		--地鼠id
		unitid_ds = 11111,	--双倍积分怪
		unit_ds_num = 1,	--双倍积分怪出现次数
		gametime = 90,		--游戏时间 秒
		costcoin = 0,		--消耗货币1
		refreshline = {	--刷新线程  每一条线程自己单独控制刷新时间和消失时间  和怪物类型
			[1] = {
				refreshtime = 3500,	--刷新时间 毫秒
				refreshstart = 500,	--第一个刷新时间 毫秒
				refreshend = 65000,	--结束时间 毫秒
				--mode 1参数
				disappeartime = 7000,	--消失时间 毫秒
			},
			[2] = {
				refreshtime = 2500,	--刷新时间 毫秒
				refreshstart = 63000,	--第一个刷新时间 毫秒
				--mode 1参数
				disappeartime = 6000,	--消失时间 毫秒
			},
		},
		rule = {	--总计30怪
			unit_score = 1,--普通地鼠积分
			unitds_score = 2,--特殊地鼠积分
			awards = {--从上往下只选一个
				{--达到分数的奖励
					shouldscole = 999,	--指标
					must = {	--必给
							{108,3},
						
					},
					rand = {	--随机给
						num = 1,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,3},
							{106,3},
							{107,3},
							{108,3},
						},
					},
				},
				{--达到分数的奖励
					shouldscole = 999,	--指标
					must = {	--必给
							{108,5},
						
					},
					rand = {	--随机给
						num = 1,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,5},
							{106,5},
							{107,5},
							{108,5},
						},
					},
				},
				{--达到分数的奖励
					shouldscole = 999,	--指标
					must = {	--必给
							{108,7},
						
					},
					rand = {	--随机给
						num = 1,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,7},
							{106,7},
							{107,7},
							{108,7},
						},
					},
				},
			},
		},
	},
	[2] = {
		unitid = 11109,		--地鼠id
		unitid_ds = 11111,	--双倍积分怪
		unit_ds_num = 2,	--双倍积分怪出现次数
		gametime = 90,		--游戏时间 秒
		costcoin = 1,		--消耗货币1
		refreshline = {	--刷新线程  每一条线程自己单独控制刷新时间和消失时间  和怪物类型
			[1] = {
				refreshtime = 3500,	--刷新时间 毫秒
				refreshstart = 500,	--第一个刷新时间 毫秒
				refreshend = 65000,	--结束时间 毫秒
				--mode 1参数
				disappeartime = 4000,	--消失时间 毫秒
			},
			[2] = {
				refreshtime = 2500,	--刷新时间 毫秒
				refreshstart = 63000,	--第一个刷新时间 毫秒
				--mode 1参数
				disappeartime = 4000,	--消失时间 毫秒
			},
		},
		rule = {	--总计30怪
			unit_score = 1,--普通地鼠积分
			unitds_score = 2,--特殊地鼠积分
			awards = {--从上往下只选一个
				{--达到分数的奖励
					shouldscole = 28,	--指标
					must = {	--必给
							{108,4},
						
					},
					rand = {	--随机给
						num = 2,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,4},
							{106,4},
							{107,4},
							{108,4},
						},
					},
				},
				{--达到分数的奖励
					shouldscole = 30,	--指标
					must = {	--必给
							{108,7},
						
					},
					rand = {	--随机给
						num = 2,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,7},
							{106,7},
							{107,7},
							{108,7},
						},
					},
				},
				{--达到分数的奖励
					shouldscole = 32,	--指标
					must = {	--必给
							{108,10},
						
					},
					rand = {	--随机给
						num = 2,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,10},
							{106,10},
							{107,10},
							{108,10},
						},
					},
				},
			},
		},
	},
	[3] = {
		unitid = 11109,		--地鼠id
		unitid_ds = 11111,	--双倍积分怪
		unit_ds_num = 3,	--双倍积分怪出现次数
		gametime = 90,		--游戏时间 秒
		costcoin = 1,		--消耗货币1
		refreshline = {	--刷新线程  每一条线程自己单独控制刷新时间和消失时间  和怪物类型
			[1] = {
				refreshtime = 3000,	--刷新时间 毫秒
				refreshstart = 500,	--第一个刷新时间 毫秒
				refreshend = 65000,	--结束时间 毫秒
				--mode 1参数
				disappeartime = 4000,	--消失时间 毫秒
				--mode 2参数
				movespeed = 60,	--移动速度
				movelength = 200,	--移动距离
				standtime = 500,	--移动到目的地后的等待时间 毫秒
				--actionmode 不填默认模式1
				--actionmode 可以直接填数字
				--actionmode = 2
				--actionmode 可以填表格 填权重
				actionmode = {	-- 1 原地不动 权重40 受消失时间影响   2 移动 权重 60  受移动距离 和 移动速度影响
					{1,30},
					{2,70},
				}
			},
			[2] = {
				refreshtime = 2000,	--刷新时间 毫秒
				refreshstart = 65000,	--第一个刷新时间 毫秒
				--mode 1参数
				disappeartime = 4000,	--消失时间 毫秒
				--mode 2参数
				movespeed = 60,	--移动速度
				movelength = 200,	--移动距离
				standtime = 500,	--移动到目的地后的等待时间 毫秒
				actionmode = {	-- 1 原地不动 权重40 受消失时间影响   2 移动 权重 60  受移动距离 和 移动速度影响
					{1,30},
					{2,70},
				}
			},
		},
		rule = {	--总计35怪
			unit_score = 1,--普通地鼠积分
			unitds_score = 2,--特殊地鼠积分
			awards = {--从上往下只选一个
				{--达到分数的奖励
					shouldscole = 34,	--指标
					must = {	--必给
							{108,7},
						
					},
					rand = {	--随机给
						num = 3,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,7},
							{106,7},
							{107,7},
							{108,7},
						},
					},
				},
				{--达到分数的奖励
					shouldscole = 36,	--指标
					must = {	--必给
							{108,11},
						
					},
					rand = {	--随机给
						num = 3,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,11},
							{106,11},
							{107,11},
							{108,11},
						},
					},
				},
				{--达到分数的奖励
					shouldscole = 38,	--指标
					must = {	--必给
							{108,15},
						
					},
					rand = {	--随机给
						num = 3,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,15},
							{106,15},
							{107,15},
							{108,15},
						},
					},
				},
			},
		},
	},
	[4] = {
		unitid = 11109,		--地鼠id
		unitid_ds = 11111,	--双倍积分怪
		unit_ds_num = 5,	--双倍积分怪出现次数
		gametime = 90,		--游戏时间 秒
		costcoin = 1,		--消耗货币1
		refreshline = {	--刷新线程  每一条线程自己单独控制刷新时间和消失时间  和怪物类型
			[1] = {
				refreshtime = 3000,	--刷新时间 毫秒
				refreshstart = 500,	--第一个刷新时间 毫秒
				refreshend = 62000,	--结束时间 毫秒
				--mode 1参数
				disappeartime = 4000,	--消失时间 毫秒
				--mode 2参数
				movespeed = 100,	--移动速度
				movelength = 200,	--移动距离
				standtime = 200,	--移动到目的地后的等待时间 毫秒
				--actionmode 不填默认模式1
				--actionmode 可以直接填数字
				--actionmode = 2
				--actionmode 可以填表格 填权重
				actionmode = {	-- 1 原地不动 权重40 受消失时间影响   2 移动 权重 60  受移动距离 和 移动速度影响
					{1,20},
					{2,80},
				}
			},
			[2] = {
				refreshtime = 5000,	--刷新时间 毫秒
				refreshstart = 5000,	--第一个刷新时间 毫秒
				refreshend = 62000,	--结束时间 毫秒
				--mode 1参数
				disappeartime = 4000,	--消失时间 毫秒
				--mode 2参数
				movespeed = 100,	--移动速度
				movelength = {200,350},	--移动距离
				standtime = 200,	--移动到目的地后的等待时间 毫秒
				--actionmode 不填默认模式1
				--actionmode 可以直接填数字
				--actionmode = 2
				--actionmode 可以填表格 填权重
				actionmode = 2,
			},
			[3] = {
				refreshtime = 2500,	--刷新时间 毫秒
				refreshstart = 65000,	--第一个刷新时间 毫秒
				refreshend = 89000,	--结束时间 毫秒
				--mode 1参数
				disappeartime = 4000,	--消失时间 毫秒
				--mode 2参数
				movespeed = 100,	--移动速度
				movelength = 200,	--移动距离
				standtime = 200,	--移动到目的地后的等待时间 毫秒
				--actionmode 不填默认模式1
				--actionmode 可以直接填数字
				--actionmode = 2
				--actionmode 可以填表格 填权重
				actionmode = {	-- 1 原地不动 权重40 受消失时间影响   2 移动 权重 60  受移动距离 和 移动速度影响
					{1,20},
					{2,80},
				}
			},
			[4] = {
				refreshtime = 4000,	--刷新时间 毫秒
				refreshstart = 64000,	--第一个刷新时间 毫秒
				--mode 1参数
				disappeartime = 4000,	--消失时间 毫秒
				--mode 2参数
				movespeed = 100,	--移动速度
				movelength = {200,350},	--移动距离
				standtime = 200,	--移动到目的地后的等待时间 毫秒
				--actionmode 不填默认模式1
				--actionmode 可以直接填数字
				--actionmode = 2
				--actionmode 可以填表格 填权重
				actionmode = 2,
			},
		},
		rule = {	--总计50怪
			unit_score = 1,--普通地鼠积分
			unitds_score = 2,--特殊地鼠积分
			awards = {--从上往下只选一个
				{--达到分数的奖励
					shouldscole = 53,	--指标
					must = {	--必给
							{108,10},
						
					},
					rand = {	--随机给
						num = 4,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,10},
							{106,10},
							{107,10},
							{108,10},
						},
					},
				},
				{--达到分数的奖励
					shouldscole = 54,	--指标
					must = {	--必给
							{108,15},
						
					},
					rand = {	--随机给
						num = 4,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,15},
							{106,15},
							{107,15},
							{108,15},
						},
					},
				},
				{--达到分数的奖励
					shouldscole = 55,	--指标
					must = {	--必给
							{108,20},
						
					},
					rand = {	--随机给
						num = 4,	--下方池子中选1个
						canrepeat = 1,	--可重复掉落奖励
						pool = {	--随机池子
							{105,20},
							{106,20},
							{107,20},
							{108,20},
						},
					},
				},
			},
		},
	},
}

--构造函数
function GameGopherMgr:ctor()
	self._uid = -1
	self._rid = -1
	
	return self
end
	
--初始化函数
function GameGopherMgr:Init(uid, rid)
	self._uid = uid
	self._rid = rid

	return self
end

--进游戏  扣地鼠币
function GameGopherMgr:EnterGame(diff)
	local ret = 0
	local sCmd = ""

	local tDiffDefine = hVar.GameGopherDiffDefine[diff]
	if type(tDiffDefine) == "table" then
		local costcoin = tDiffDefine.costcoin or 0

		if costcoin > 0 then
			--查询地鼠币数量
			local nDiShuCoin = 0
			local sQuery = string.format("SELECT `dishu_coin` from `t_user` where `uid` = %d", self._uid)
			local err, nDiShuCoin = xlDb_Query(sQuery)

			if err ~= 0 then
				ret = -2
			elseif nDiShuCoin < costcoin then
				ret = -3
			else
				ret = 1
			end
		else
			ret = 1
		end
	else
		ret = -1
	end

	sCmd = tostring(ret) .. ";" .. tostring(diff) .. ";" .. sCmd
		
	return sCmd
end

local _GetReward = function(diff,score)
	local tReward = {}

	local tDiffDefine = hVar.GameGopherDiffDefine[diff]
	if type(tDiffDefine) == "table" then
		local tRule = tDiffDefine.rule
		if type(tRule) == "table" then
			local tAward = tRule.awards
			local bestScore = 0
			local bestAwardIdx = 0
			for i = 1,#tAward do
				local t = tAward[i]
				if type(t) == "table" then
					local shouldscole = t.shouldscole
					if score >= shouldscole and (shouldscole > bestScore or bestAwardIdx == 0) then
						bestAwardIdx = i
						bestScore = shouldscole
					end
				end
			end
			local tGetAward = tAward[bestAwardIdx]
			if tGetAward then
				local tMust = tGetAward.must
				local tRand = tGetAward.rand
				for i = 1,#tMust do
					local t = tMust[i]
					tReward[#tReward + 1] = {t[1],t[2],t[3],t[4]}
				end
				local tIndex = {}
				local num = tRand.num
				local bCanRepeat = (tRand.canrepeat == 1)
				if bCanRepeat then
					for i = 1,num do
						local r = math.random(1,#tRand.pool)
						local t = tRand.pool[r]
						tReward[#tReward + 1] = {t[1],t[2],t[3],t[4]}
					end
				else
					for i = 1,#tRand.pool do
						tIndex[i] = i
					end
					for i = 1,num do
						local r = math.random(1,#tIndex)
						local t = tRand.pool[tIndex[r]]
						tReward[#tReward + 1] = {t[1],t[2],t[3],t[4]}
						table.remove(tIndex,r)
					end
				end
			end
		end
	end
	return tReward
end

function GameGopherMgr:GetReward(diff,score)
	local ret = 0
	local sCmd = ""

	local tDiffDefine = hVar.GameGopherDiffDefine[diff]
	if type(tDiffDefine) == "table" then
		local costcoin = tDiffDefine.costcoin or 0

		local canGetAward = 1
		if costcoin > 0 then
			--查询地鼠币数量
			local nDiShuCoin = 0
			local sQuery = string.format("SELECT `dishu_coin` from `t_user` where `uid` = %d", self._uid)
			local err, nDiShuCoin = xlDb_Query(sQuery)

			if err == 0 then
				if nDiShuCoin >= costcoin then
					local sUpdate = string.format("UPDATE `t_user` SET `dishu_coin` = `dishu_coin` + %d WHERE `uid` = %d", -costcoin, self._uid)
					xlDb_Execute(sUpdate)
				else
					canGetAward = 0
					ret = -3
				end
			else
				canGetAward = 0
				ret = -2
			end
		end
		
		if canGetAward == 1 then
			local reward = _GetReward(diff,score)

			--发奖
			--领取奖励
			local prizeType = 20008 --奖励类型
			local detail = ""
			detail = detail .. "diff".. tostring(diff) .. ";"
			for r = 1, #reward, 1 do
				local tReward = reward[r]
				detail = detail .. tostring(tReward[1] or 0) .. ":" .. tostring(tReward[2] or 0) .. ":" .. tostring(tReward[3] or 0) .. ":" .. tostring(tReward[4] or 0) .. ";"
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
				sCmd = sCmd .. prizeContent

				
			end

			ret = 1
		end
	else
		ret = -1
	end

	sCmd = tostring(ret) .. ";" .. sCmd
		
	return sCmd
end

return GameGopherMgr