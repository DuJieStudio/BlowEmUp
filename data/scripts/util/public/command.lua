--指令操作表
hVar.CommandList = {} --指令列表
hVar.CheckSumList = {} --客户端校验值缓存表

hVar.Operation =
{
	Move = 1, --移动指令
	CacheMove = 1, --缓存移动指令（此刻正被晕或僵直，不能移动）
	UseTacticCard = 2, --使用战术(道具)技能卡
	BuildTower = 3, --建造塔
	UpgrateTowerSkill = 4, --升级塔技能
	SellTower = 5, --卖塔
	CastBuildingSkill = 6, --使用建筑的技能
	PlayerLeave = 7, --玩家离线(--客户端收到后处理玩家状态)
	GameStart = 8, --游戏开始(--pvp收到后开始发兵，添加英雄等)
	BeginTurn = 9, --回合开始(--服务器不会返回该命令)
	--ClientTurnFinish = 10, --客户端完成了此轮turn的指令
	GameOutSync = 11, --游戏发生不同步(--pvp服务器检测到不同步，通知客户端)
	ReloginFrame = 12, --重连补帧日志
	HeroRebirth = 13, --英雄复活
	PickUpItem = 14, --拾取道具
	DropOutItem = 15, --丢掉道具
	AdaptNetDelay = 16,
	UpgrateTowerCount = 19, --联机升级塔使用次数
	SelectDrawCardRet = 20, --联机选择抽卡结果
}

--hVar.InProcessingUpgrateTowerSkill = 0 --是否正在处理升级塔的技能中
--hVar.InProcessingCastBuildingSkill = 0 --是否正在处理使用建筑的技能中


--将一维数组表转化为字符串
-- 参数:
--  array: 一维数组
hApi.Array2String = function(array)
	local sz = ""
	
	if (#array == 0) then
		return sz
	else
		for k, v in ipairs(array) do
			sz = ("%s|%s"):format(sz, tostring(v))
		end
		
		return string.sub(sz, 2, #sz)
	end
end

--字符串转化为一维表
-- 参数:
-- 	strings: 字符串
-- 	separateType: 分隔符号
-- 	bInteger: 一维表的每个元素是否为整数值(默认值: false)
local String2Type = function(strings, separateType, bInteger)
	local ret = {} --返回值
	
	if (#strings > 0) then
		--如果第一个字符是分隔符, 那么删掉该分隔符
		if (strings[1] == separateType) then
			strings = string.sub(strings, 2, #strings)
		end
		
		--如果最后一个字符不是分隔符, 那么添加该分隔符
		if (strings[#strings] ~= separateType) then
			strings = ("%s%s"):format(strings, separateType)
		end
		
		--开始循环处理
		local buff = strings
		while true do
			local pos = string.find(buff, separateType)
			if pos and (pos > 0) then
				--找到分隔符
				local szValue = string.sub(buff, 1, pos - 1) --元素
				local value = szValue
				if bInteger then
					value = tonumber(szValue) or 0
				end
				
				table.insert(ret, value)
				buff = string.sub(buff, pos + 1, #buff)
			else
				--找不到分隔符了
				break
			end
		end
	end
	
	return ret
end

--将字符串转化为一维数组表
hApi.String2Array = function(strings)
	return String2Type(strings, "|", true)
end

--将字符串转化为一维结构体表
hApi.String2Struct = function(strings)
	return String2Type(strings, "_", true)
end

--将字符串转化为一维结构体数组表
hApi.String2ArrayStruct = function(strings)
	local ret = {}
	local array = String2Type(strings, "|", false)
	
	for i = 1, #array, 1 do
		local struct = String2Type(array[i], "_", true)
		table.insert(ret, struct)
	end
	
	return ret
end

--添加到指令序列
hApi.AddCommand = function(cmd_type, ...)
	local world = hGlobal.WORLD.LastWorldMap
	local mapInfo = world.data.tdMapInfo
	if (mapInfo) then
		local sessionId = world.data.sessionId
		local currenttick = world:gametick() --当前游戏帧数
		local oPlayerMe = world:GetPlayerMe()
		local arg = {...}
		local sCmd = hApi.Array2String(arg)
		
		if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
			--发送cmd
			SendPvpCmdFunc["send_cmd"](sessionId, currenttick, cmd_type, sCmd)
		else --其他模式(客户端版本)
			--geyachao: 收到同步日志: 收到单机版指令（查问题才加的，这里不是同步日志）
			--if (hVar.IS_SYNC_LOG == 1) then
			--	local msg = "[ignore]CMD_RECEIVED_LOCAL: sessionId=" .. sessionId .. ",hTick=" .. currenttick .. ",cmd_type=" .. cmd_type .. ",cliensendttick=" .. currenttick .. ",sCmd=" .. sCmd
			--	hApi.SyncLog(msg)
			--end
			
			table.insert(hVar.CommandList, {sessionId, -1, currenttick, cmd_type, oPlayerMe, currenttick, sCmd})
		end
	end
end

--收到网络消息cmd指令事件
hApi.OnReceiveNetCmd = function(opInfo)
	local world = hGlobal.WORLD.LastWorldMap
	local mapInfo = world.data.tdMapInfo
	
	local sessionId = opInfo.sessionId
	
	--print("收到网络消息cmd指令事件", sessionId, world.data.sessionId)
	if (sessionId > 0) and (sessionId == world.data.sessionId) then
		local endTurnInterval = opInfo.endTurnInterval --每回合客户端提前多少帧发送结束回合 1frame
		local framePerTurn = opInfo.framePerTurn
		local OpExecuteInterval = opInfo.OpExecuteInterval
		local hTurn = opInfo.hTurn --服务器的turn
		local hTick = opInfo.hTick --服务器按60帧跑，客户端按60帧跑
		local opNum = opInfo.opNum
		local cTurn = world.data.cTurn --客户端的cTurn
		
		--print("hTurn=", hTurn, "cTurn=", cTurn)
		
		--如果hTurn小于cTurn，说明是断线后的补发消息
		if (hTurn <= cTurn) then
			--补发客户端校验值缓存表，该帧的同步帧校验值
			if (hTurn > 0) then
				local checksumList = hVar.CheckSumList[hTurn]
				local checkSum_RandomNum = checksumList[1]
				local checkSum_UnitNum = checksumList[2]
				local checkSum_Pos = checksumList[3]
				local checkSum_Attr = checksumList[4]
				
				--geyachao: 同步日志: 重连补帧发送同步帧（只有一边有）
				if (hVar.IS_SYNC_LOG == 1) then
					local msg = "[ignore]hTurn < cTurn: sessionId=" .. sessionId .. ",uid=" .. tostring(xlPlayer_GetUID()) .. ",hTurn=" .. tostring(hTurn) .. ",hTick=" .. tostring(hTick) .. ",cTurn=" .. tostring(cTurn) .. ",opNum=" .. tostring(opNum)
					hApi.SyncLog(msg)
					
					--test
					--print("执行", msg)
				end
				
				--客户端本帧是否发送新的turn
				hApi.AddCommand(hVar.Operation.BeginTurn, hTurn, checkSum_RandomNum, checkSum_UnitNum, checkSum_Pos, checkSum_Attr)
			end
			
			return
		end
		
		world.data.hTurn = hTurn --服务器的turn
		--d.cTurn = 0 --客户端的turn
		
		--test
		--local msg = "xxx-OnReceiveNetCmd: sessionId=" .. sessionId .. ", hTick=" .. hTick .. ", clienttick=" .. world:gametick() .. ", hTurn=" .. hTurn .. ", cTurn=" .. world.data.cTurn
		--print(msg)
		
		--[[
		--test
		--geyachao: 同步日志: 发送同步帧（查问题才加的，这里不是同步日志）
		if (hVar.IS_SYNC_LOG == 1) then
			local msg = "[ignore]OnReceiveNetCmd: sessionId=" .. sessionId .. ",uid=" .. tostring(xlPlayer_GetUID()) .. ",hTurn=" .. tostring(hTurn) .. ",hTick=" .. tostring(hTick) .. ",cTurn=" .. tostring(cTurn) .. ",opNum=" .. tostring(opNum)
			hApi.SyncLog(msg)
			--print("执行", msg)
		end
		]]
		
		--geyachao: 此数为非同步日志: OnReceiveNetCmd
		if (hVar.IS_ASYNC_LOG == 1) then
			local msg = "xxx-OnReceiveNetCmd: sessionId=" .. sessionId .. ", hTick=" .. hTick .. ", clienttick=" .. world:gametick() .. ", hTurn=" .. hTurn .. ", cTurn=" .. world.data.cTurn .. ",opNum=" .. tostring(opNum)
			hApi.AsyncLog(msg)
			--print(msg)
		end
		
		--如果之前因为客户端turn比服务器过快而游戏暂停，如果服务器turn已一致，可以恢复
		if (mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE)  then
			if (world.data.cTurn >= (hTurn - hVar.TURN_TRACE_OK_NET)) then
				--恢复
				world:pause(0)
				mapInfo.mapState = mapInfo.mapLastState
				mapInfo.mapLastState = hVar.MAP_TD_STATE.IDLE
				
				--[[
				--冒字服务器已响应
				if (hVar.IS_CLIENT_NET_UI == 1) then --geyachao: 是否显示客户端网络状态界面（等待服务器、追帧）
					local strText = "服务器已响应！"
					hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "",
						lifetime = 1000,
						fadeout = -550,
						moveY = 32,
					}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
				end
				]]
			end
		end
		
		--如果客户端的turn比服务器过慢，并且大于指定域值，那么加速动画
		local deltaTurn = hTurn - cTurn
		local speed = hApi.GetTimeScale()
		if (deltaTurn >= hVar.TURN_TRACE_DELTA_NET) then
			--加速
			if (speed == 1) then
				world:speedUp(true)
				
				--冒字追帧
				if (hVar.IS_CLIENT_NET_UI == 1) then --geyachao: 是否显示客户端网络状态界面（等待服务器、追帧）
					local strText = "追帧中..."
					hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "",
						lifetime = 1000,
						fadeout = -550,
						moveY = 32,
					}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
				end
			end
		elseif (deltaTurn <= hVar.TURN_TRACE_OK_NET) then
			--恢复速度
			if (speed > 1) then
				world:speedUp(false)
				
				--冒字追帧完成
				if (hVar.IS_CLIENT_NET_UI == 1) then --geyachao: 是否显示客户端网络状态界面（等待服务器、追帧）
					local strText = "追帧完成！"
					hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "",
						lifetime = 1000,
						fadeout = -550,
						moveY = 32,
					}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
				end
			end
		end
		
		--遍历全部指令
		for i = 1, opNum, 1 do
			local tmpOpInfo = opInfo.opList[i]
			local pId = tmpOpInfo.pId
			local oPlayer
			if pId > 0 then
				oPlayer = world:GetPlayerByID(pId)
			elseif pId <= 0 then
				oPlayer = world:GetPlayerGod()
			end
			local clienttick = tmpOpInfo.tick
			local cmd_type = tmpOpInfo.opType
			local sCmd = tmpOpInfo.sOp
			
			--local msg = "收到网络消息cmd指令事件: clienttick=" .. tostring(clienttick) .. ", cmd_type=" .. tostring(cmd_type) .. ", sCmd=" .. tostring(sCmd)
			--print(msg)
			
			--[[
			--test
			--geyachao: 收到同步日志: 收到指令（查问题才加的，这里不是同步日志）
			if (hVar.IS_SYNC_LOG == 1) then
				local msg = "[ignore]opNum[" .. i .. "]" .. ": sessionId=" .. sessionId .. ",hTick=" .. hTick .. ",cmd_type=" .. cmd_type .. ",cliensendttick=" .. clienttick .. ",sCmd=" .. sCmd
				hApi.SyncLog(msg)
			end
			]]
			
			--[[
			--hTurn不和已存在的指令重复
			local bExistedhTurn = false
			for i = 1, #hVar.CommandList, 1 do
				if (hVar.CommandList[i][2] == hTurn) then
					bExistedhTurn = true --找到了
					break
				end
			end
			--hTurn不和已存在的指令重复
			]]
			if (not bExistedhTurn) then
				table.insert(hVar.CommandList, {sessionId, hTurn, hTick, cmd_type, oPlayer, clienttick, sCmd})
			end
		end
		
		--最后加一个标记客户端完成turn的指令
		--table.insert(hVar.CommandList, {sessionId, hTurn, hTick, hVar.Operation.ClientTurnFinish, world:GetPlayerMe(), hTurn})
	else
		--geyachao: 此数为非同步日志: OnReceiveNetCmdFake
		if (hVar.IS_ASYNC_LOG == 1) then
			local msg = "xxx-OnReceiveNetCmdFake: sessionId=" .. sessionId .. ", hTick=" .. hTick .. ", clienttick=" .. world:gametick() .. ", hTurn=" .. hTurn .. ", cTurn=" .. world.data.cTurn
			hApi.AsyncLog(msg)
		end
	end
end

--执行指令序列
hApi.RunCommandSequence = function()
	local cmdNum = #hVar.CommandList
	--print("hApi.RunCommandSequence,cmdNum=",cmdNum)
	
	if (cmdNum > 0) then
		local world = hGlobal.WORLD.LastWorldMap
		local currenttick = world:gametick() --当前游戏帧数
		
		local index = 1
		while true do
			if (index > cmdNum) then
				break
			end
			
			local sessionId = hVar.CommandList[index][1] --游戏局id
			local hTurn = hVar.CommandList[index][2] --hTurn
			local hTick = hVar.CommandList[index][3] --执行的tick
			local cmd_type = hVar.CommandList[index][4] --指令类型
			local oPlayer = hVar.CommandList[index][5] --指令发送的玩家对象
			local clienttick = hVar.CommandList[index][6] --指令发送的玩家客户端的tick
			local sCmd = hVar.CommandList[index][7] --指令参数列表字符串
			
			--到了触发的帧数
			if (currenttick >= hTick) then
				if (sessionId == world.data.sessionId) then
					if hVar.CmdMgr[cmd_type] then
						local arg = hApi.String2Array(sCmd)
						--print(sCmd)
						--geyachao: 同步日志: 执行指令
						if (hVar.IS_SYNC_LOG == 1) then
							local msg = "CMD: sessionId=" .. sessionId .. ",hTurn=" .. hTurn .. ",hTick=" .. hTick .. ",cmd_type=" .. cmd_type .. ",cliensendttick=" .. clienttick .. ",sCmd=" .. sCmd
							hApi.SyncLog(msg)
							--print("执行", msg)
						end
						
						--安全执行
						hpcall(hVar.CmdMgr[cmd_type], sessionId, oPlayer, select(1, unpack(arg)))
					end
				end
				
				--删除此操作
				table.remove(hVar.CommandList, index)
				cmdNum = cmdNum - 1
			else
				--本条未到触发时间，跳到下一条指令
				index = index + 1
			end
		end
	end
end

--执行单个指令
hVar.CmdMgr = {}

--移动指令
hVar.CmdMgr[hVar.Operation.Move] = function(sessionId, oPlayer, cha_worldI, cha_worldC, worldX, worldY, t_worldI, t_worldC, tacticId, itemId, tacticX, tacticY)
	--print("移动指令", sessionId, oPlayer, cha_worldI, cha_worldC, worldX, worldY, t_worldI, t_worldC, tacticId, tacticX, tacticY)
	local oUnit = hClass.unit:getChaByWorldI(cha_worldI)
	if (oUnit) and (oUnit:getworldC() ~= cha_worldC) then
		oUnit = nil
	end
	
	--角色是否存在
	if (not oUnit) or (oUnit == 0) then
		return
	end
	
	--角色是否活着
	if (oUnit.data.IsDead == 1) then
		return
	end
	
	--目标
	local t = hClass.unit:getChaByWorldI(t_worldI)
	if (t) and (t:getworldC() ~= t_worldC) then
		t = nil
	end
	
	--目标是否活着
	if t and (t.data.IsDead == 1) then
		t = nil
	end
	
	local w = oUnit:getworld()
	local oPlayerMe = w:GetPlayerMe()
	
	if (t == nil) then --移动到目标点模式
		--角色不能在眩晕(滑行)、不在僵直中、不在混乱中
		if (oUnit.attr.stun_stack == 0) and (oUnit:getAIState() ~= hVar.UNIT_AI_STATE.CAST_STATIC) and (oUnit.attr.suffer_chaos_stack == 0) and (oUnit.attr.suffer_sleep_stack == 0) then
			--清除缓存操作
			oUnit.data.op_state = 0 --清除缓存操作
			
			--本地才执行
			if (oPlayerMe == oPlayer) then
				--[[
				--删除移动的箭头特效
				if (oUnit.data.JianTouEffect ~= 0) then
					oUnit.data.JianTouEffect:del()
					oUnit.data.JianTouEffect = 0
				end
				
				--删除攻击箭头的特效
				if (oUnit.data.AttackEffect ~= 0) then
					oUnit.data.AttackEffect:del()
					oUnit.data.AttackEffect = 0
				end
				
				--创建箭头特效
				oUnit.data.JianTouEffect = w:addeffect(1, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y
				--0.5秒后删除自身
				local delay = CCDelayTime:create(0.5)
				local node = oUnit.data.JianTouEffect.handle._n --cocos对象
				local actCall = CCCallFunc:create(function(ctrl)
					oUnit.data.JianTouEffect:del()
					oUnit.data.JianTouEffect = 0
				end)
				local actSeq = CCSequence:createWithTwoActions(delay, actCall)
				node:runAction(actSeq)
				]]
			end
			
			--标记AI状态为移动
			oUnit:setAIState(hVar.UNIT_AI_STATE.MOVE)
			
			--如果有要释放的战术卡技能，此AI状态为移动到达释放技能
			if (tacticId and (tacticId ~= 0)) or (itemId and (itemId ~= 0)) then
				--标记AI状态为移动到达目标点后释放战术技能
				oUnit:setAIState(hVar.UNIT_AI_STATE.MOVE_TO_POINT)
				
				--标记战术技能相关参数
				oUnit.data.op_state = 0 --是否有缓存的操作
				oUnit.data.op_target = 0 --等待操作的移动到达的目标
				oUnit.data.op_target_worldC = 0 --等待操作的移动到达的目标唯一id
				oUnit.data.op_point_x = worldX --等待操作的移动到达的目标点x
				oUnit.data.op_point_y = worldY --等待操作的移动到达的目标点y
				oUnit.data.op_tacticId = tacticId --等待操作的移动到达目标点后释放的战术技能id
				oUnit.data.op_itemId = itemId --等待操作的移动到达目标点后释放的道具技能id
				oUnit.data.op_tacticX = tacticX --等待操作的移动到达目标点后战术技能x坐标
				oUnit.data.op_tacticY = tacticY --等待操作的移动到达目标点后战术技能y坐标
				oUnit.data.op_t_worldI = t_worldI --等待操作的移动到达目标点后战术技能目标worldI
				oUnit.data.op_t_worldC = t_worldC --等待操作的移动到达目标点后战术技能目标worldC
				oUnit.data.op_skillAction = 0 --等待操作的移动到达目标点后释放的技能action
			end
			
			--先停掉角色原先的技能释放
			hApi.StopSkillCast(oUnit)
			
			--重置英雄的守卫点(目标点的坐标)
			--oUnit.data.defend_x = worldX
			--oUnit.data.defend_y = worldY
			
			--发起移动(到指定地点)(英雄计算障碍)
			local defX, defY = hApi.UnitMoveToPoint_TD(oUnit, worldX, worldY, true)
			
			--重设守卫点 (守备点设置为可移动的最终位置) zhenkira 2016.2.15
			oUnit.data.defend_x = defX
			oUnit.data.defend_y = defY
			
			--因为发起了移动，锁定的目标为空
			local old_lockTarget = oUnit.data.lockTarget --原先锁定的目标
			--print("old_lockTarget=", old_lockTarget)
			--如果原目标也锁定的是角色，那么取消原目标锁定攻击英雄
			if (old_lockTarget ~= 0) and (old_lockTarget.data.lockTarget == oUnit) then
				if (old_lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
					--old_lockTarget.data.lockTarget = 0
					--old_lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
					hApi.UnitTryToLockTarget(old_lockTarget, 0, 0)
					--print("lockType 3", old_lockTarget.data.name, 0)
				end
			end
			
			--取消角色锁定目标
			--oUnit.data.lockTarget = 0
			--oUnit.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
			hApi.UnitTryToLockTarget(oUnit, 0, 0)
			--print("lockType 2", oUnit.data.name, 0)
			
			--本地才执行
			if (oPlayerMe == oPlayer) then
				--[[
				--geyachao: 客户端已经提前操作，这里不用取消选中了
				--geyachao: 操作优化，点击完地面，取消对之前选中英雄的选中
				if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
					oPlayerMe:focusunit(nil, "worldmap")
					hGlobal.event:event("LocalEvent_HitOnTarget", w, nil, worldX, worldY)
					hGlobal.event:event("Event_TDUnitActived", w, 1, nil)
					hGlobal.O:replace("__WM__TargetOperatePanel",nil)
					hGlobal.O:replace("__WM__MoveOperatePanel",nil)
					
					--刷新英雄头像
					hGlobal.event:event("LocalEvent_PlayerChooseHero", nil)
				end
				]]
			end
		else --角色当前不能进行操作（僵直、眩晕，等）
			--缓存当前的操作
			--print("缓存当前的操作", 1)
			oUnit.data.op_state = 1 --是否有缓存的操作
			oUnit.data.op_target = 0 --等待操作的移动到达的目标
			oUnit.data.op_target_worldC = 0 --等待操作的移动到达的目标唯一id
			oUnit.data.op_point_x = worldX --等待操作的移动到达的目标点x
			oUnit.data.op_point_y = worldY --等待操作的移动到达的目标点y
			oUnit.data.op_tacticId = tacticId --等待操作的移动到达目标点后释放的战术技能id
			oUnit.data.op_itemId = itemId --等待操作的移动到达目标点后释放的道具技能id
			oUnit.data.op_tacticX = tacticX --等待操作的移动到达目标点后战术技能x坐标
			oUnit.data.op_tacticY = tacticY --等待操作的移动到达目标点后战术技能y坐标
			oUnit.data.op_t_worldI = t_worldI --等待操作的移动到达目标点后战术技能目标worldI
			oUnit.data.op_t_worldC = t_worldC --等待操作的移动到达目标点后战术技能目标worldC
			oUnit.data.op_skillAction = 0 --等待操作的移动到达目标点后释放的技能action
			
			--本地才执行
			if (oPlayerMe == oPlayer) then
				--[[
				--删除移动的箭头特效
				if (oUnit.data.JianTouEffect ~= 0) then
					oUnit.data.JianTouEffect:del()
					oUnit.data.JianTouEffect = 0
				end
				
				--删除攻击箭头的特效
				if (oUnit.data.AttackEffect ~= 0) then
					oUnit.data.AttackEffect:del()
					oUnit.data.AttackEffect = 0
				end
				
				--创建不能操作的转圈圈特效
				oUnit.data.JianTouEffect = w:addeffect(420, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y
				oUnit.data.JianTouEffect.handle.s:setColor(ccc3(255, 0, 0))
				--0.5秒后删除自身
				local delay = CCDelayTime:create(0.5)
				local node = oUnit.data.JianTouEffect.handle._n --cocos对象
				local actCall = CCCallFunc:create(function(ctrl)
					oUnit.data.JianTouEffect:del()
					oUnit.data.JianTouEffect = 0
				end)
				local actSeq = CCSequence:createWithTwoActions(delay, actCall)
				node:runAction(actSeq)
				]]
				
				--[[
				--删除移动的箭头特效
				if (oUnit.data.JianTouEffect ~= 0) then
					oUnit.data.JianTouEffect:del()
					oUnit.data.JianTouEffect = 0
				end
				
				--删除攻击箭头的特效
				if (oUnit.data.AttackEffect ~= 0) then
					oUnit.data.AttackEffect:del()
					oUnit.data.AttackEffect = 0
				end
				
				--创建箭头特效
				oUnit.data.JianTouEffect = w:addeffect(1, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y
				--0.5秒后删除自身
				local delay = CCDelayTime:create(0.5)
				local node = oUnit.data.JianTouEffect.handle._n --cocos对象
				local actCall = CCCallFunc:create(function(ctrl)
					oUnit.data.JianTouEffect:del()
					oUnit.data.JianTouEffect = 0
				end)
				local actSeq = CCSequence:createWithTwoActions(delay, actCall)
				node:runAction(actSeq)
				]]
				
				--[[
				--geyachao: 客户端已经提前操作，这里不用取消选中了
				--geyachao: 操作优化，点击完地面，取消对之前选中英雄的选中
				if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
					oPlayerMe:focusunit(nil, "worldmap")
					hGlobal.event:event("LocalEvent_HitOnTarget", w, nil, worldX, worldY)
					hGlobal.event:event("Event_TDUnitActived", w, 1, nil)
					hGlobal.O:replace("__WM__TargetOperatePanel",nil)
					hGlobal.O:replace("__WM__MoveOperatePanel",nil)
					
					--刷新英雄头像
					hGlobal.event:event("LocalEvent_PlayerChooseHero", nil)
				end
				]]
			end
		end
	else --移动到目标模式
		--角色不能在眩晕(滑行)、不在僵直中、不在混乱中、不在沉睡中
		if (oUnit.attr.stun_stack == 0) and (oUnit:getAIState() ~= hVar.UNIT_AI_STATE.CAST_STATIC) and (oUnit.attr.suffer_chaos_stack == 0) and (oUnit.attr.suffer_sleep_stack == 0) then
			--清除缓存操作
			oUnit.data.op_state = 0 --清除缓存操作
			
			--本地才执行
			if (oPlayerMe == oPlayer) then
				
				
				--[[
				--删除移动的箭头特效
				if (oUnit.data.JianTouEffect ~= 0) then
					oUnit.data.JianTouEffect:del()
					oUnit.data.JianTouEffect = 0
				end
				
				--删除攻击箭头的特效
				if (oUnit.data.AttackEffect ~= 0) then
					oUnit.data.AttackEffect:del()
					oUnit.data.AttackEffect = 0
				end
				
				--创建攻击箭头特效
				oUnit.data.AttackEffect = w:addeffect(5, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y, facing, scale
				--0.5秒后删除自身
				local delay = CCDelayTime:create(0.5)
				local node = oUnit.data.AttackEffect.handle._n --cocos对象
				local actCall = CCCallFunc:create(function(ctrl)
					oUnit.data.AttackEffect:del()
					oUnit.data.AttackEffect = 0
				end)
				local actSeq = CCSequence:createWithTwoActions(delay, actCall)
				node:runAction(actSeq)
				]]
			end
			
			--标记AI状态为跟随
			oUnit:setAIState(hVar.UNIT_AI_STATE.FOLLOW)
			
			--如果有要释放的战术卡技能，此AI状态为移动到达释放技能
			if (tacticId and (tacticId ~= 0)) or (itemId and (itemId ~= 0)) then
				--标记AI状态为移动到达目标后释放战术技能
				oUnit:setAIState(hVar.UNIT_AI_STATE.FOLLOW_TO_TARGET)
				
				--标记战术技能相关参数
				oUnit.data.op_state = 0 --是否有缓存的操作
				oUnit.data.op_target = 0 --等待操作的移动到达的目标
				oUnit.data.op_target_worldC = 0 --等待操作的移动到达的目标唯一id
				oUnit.data.op_point_x = worldX --等待操作的移动到达的目标点x
				oUnit.data.op_point_y = worldY --等待操作的移动到达的目标点y
				oUnit.data.op_tacticId = tacticId --等待操作的移动到达目标点后释放的战术技能id
				oUnit.data.op_itemId = itemId --等待操作的移动到达目标点后释放的道具技能id
				oUnit.data.op_tacticX = tacticX --等待操作的移动到达目标点后战术技能x坐标
				oUnit.data.op_tacticY = tacticY --等待操作的移动到达目标点后战术技能y坐标
				oUnit.data.op_t_worldI = t_worldI --等待操作的移动到达目标点后战术技能目标worldI
				oUnit.data.op_t_worldC = t_worldC --等待操作的移动到达目标点后战术技能目标worldC
				oUnit.data.op_skillAction = 0 --等待操作的移动到达目标点后释放的技能action
			end
			
			--先停掉角色原先的技能释放
			hApi.StopSkillCast(oUnit)
			
			--重置英雄的守卫点(目标的当前坐标)
			local t_x, t_y = hApi.chaGetPos(t.handle) --目标的坐标
			oUnit.data.defend_x = t_x
			oUnit.data.defend_y = t_y
			
			--发起移动(锁定目标）(英雄计算障碍)
			hApi.UnitMoveToTarget_TD(oUnit, t, oUnit:GetAtkRange() - hVar.MOVE_EXTRA_DISTANCE, true) --24距离的缓冲
			--print("发起移动(锁定目标）(英雄计算障碍)", oUnit.data.name, t.data.name)
			
			--锁定攻击的目标
			--因为发起了移动，锁定新目标
			local old_lockTarget = oUnit.data.lockTarget --原先锁定的目标
			--如果原目标也锁定的是角色，那么取消原目标锁定攻击英雄
			if (old_lockTarget ~= 0) and (old_lockTarget.data.lockTarget == oUnit) then
				if (old_lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
					--old_lockTarget.data.lockTarget = 0
					--old_lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
					hApi.UnitTryToLockTarget(old_lockTarget, 0, 0)
					--print("lockType 6", old_lockTarget.data.name, 0)
				end
			end
			
			--英雄锁定新目标
			hApi.UnitTryToLockTarget(oUnit, t, 1)
			--oUnit.data.lockTarget = t
			--oUnit.data.lockType = 1 --锁定攻击的类型(0:被动锁定 / 1:主动锁定) --主动攻击
			--print("lockType 5", oUnit.data.name, 1)
			
			--新目标锁定攻击角色
			if (t.data.lockTarget == 0) then --不重复锁定不同的目标
				hApi.UnitTryToLockTarget(t, oUnit, 0)
				--t.data.lockTarget = oUnit
				--t.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
				--print("lockType 4", t.data.name, 0)
			end
			
			--本地才执行
			if (oPlayerMe == oPlayer) then
				--[[
				--geyachao: 客户端已经提前操作，这里不用取消选中了
				--geyachao: 操作优化，点击小兵，取消对之前选中英雄的选中
				if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
					oPlayerMe:focusunit(nil, "worldmap")
					hGlobal.event:event("LocalEvent_HitOnTarget", w, nil, worldX, worldY)
					hGlobal.event:event("Event_TDUnitActived", w, 1, nil)
					hGlobal.O:replace("__WM__TargetOperatePanel",nil)
					hGlobal.O:replace("__WM__MoveOperatePanel",nil)
					
					--刷新英雄头像
					hGlobal.event:event("LocalEvent_PlayerChooseHero", nil)
				end
				]]
			end
		else --角色在眩晕或者僵直中，提前播放攻击剑的效果，但是实际攻击操作是放入缓存的
			--角色当前不能进行操作（僵直、眩晕，等）
			--缓存当前的操作
			--print("缓存当前的操作", 2)
			oUnit.data.op_state = 1 --是否有缓存的操作
			oUnit.data.op_target = t --等待操作的移动到达的目标
			oUnit.data.op_target_worldC = t:getworldC() --等待操作的移动到达的目标唯一id
			oUnit.data.op_point_x = worldX --等待操作的移动到达的目标点x
			oUnit.data.op_point_y = worldY --等待操作的移动到达的目标点y
			oUnit.data.op_tacticId = tacticId --等待操作的移动到达目标点后释放的战术技能id
			oUnit.data.op_itemId = itemId --等待操作的移动到达目标点后释放的道具技能id
			oUnit.data.op_tacticX = tacticX --等待操作的移动到达目标点后战术技能x坐标
			oUnit.data.op_tacticY = tacticY --等待操作的移动到达目标点后战术技能y坐标
			oUnit.data.op_t_worldI = t_worldI --等待操作的移动到达目标点后战术技能目标worldI
			oUnit.data.op_t_worldC = t_worldC --等待操作的移动到达目标点后战术技能目标worldC
			oUnit.data.op_skillAction = 0 --等待操作的移动到达目标点后释放的技能action
			
			--本地才执行
			if (oPlayerMe == oPlayer) then
				
				--[[
				--删除移动的箭头特效
				if (oUnit.data.JianTouEffect ~= 0) then
					oUnit.data.JianTouEffect:del()
					oUnit.data.JianTouEffect = 0
				end
				
				--删除攻击箭头的特效
				if (oUnit.data.AttackEffect ~= 0) then
					oUnit.data.AttackEffect:del()
					oUnit.data.AttackEffect = 0
				end
				
				--创建不能操作的转圈圈特效
				oUnit.data.JianTouEffect = w:addeffect(420, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y
				oUnit.data.JianTouEffect.handle.s:setColor(ccc3(255, 0, 0))
				--0.5秒后删除自身
				local delay = CCDelayTime:create(0.5)
				local node = oUnit.data.JianTouEffect.handle._n --cocos对象
				local actCall = CCCallFunc:create(function(ctrl)
					oUnit.data.JianTouEffect:del()
					oUnit.data.JianTouEffect = 0
				end)
				local actSeq = CCSequence:createWithTwoActions(delay, actCall)
				node:runAction(actSeq)
				]]
				
				--[[
				--删除移动的箭头特效
				if (oUnit.data.JianTouEffect ~= 0) then
					oUnit.data.JianTouEffect:del()
					oUnit.data.JianTouEffect = 0
				end
				
				--删除攻击箭头的特效
				if (oUnit.data.AttackEffect ~= 0) then
					oUnit.data.AttackEffect:del()
					oUnit.data.AttackEffect = 0
				end
				
				--创建攻击箭头特效
				oUnit.data.AttackEffect = w:addeffect(5, -1, nil, worldX, worldY) --effectId, time(单位:秒), ???, pos_x, pos_y, facing, scale
				--0.5秒后删除自身
				local delay = CCDelayTime:create(0.5)
				local node = oUnit.data.AttackEffect.handle._n --cocos对象
				local actCall = CCCallFunc:create(function(ctrl)
					oUnit.data.AttackEffect:del()
					oUnit.data.AttackEffect = 0
				end)
				local actSeq = CCSequence:createWithTwoActions(delay, actCall)
				node:runAction(actSeq)
				]]
				
				--[[
				--geyachao: 客户端已经提前操作，这里不用取消选中了
				--geyachao: 操作优化，点击小兵，取消对之前选中英雄的选中
				if (hVar.OP_LASTING_MODE == 0) then --非持续选中模式
					oPlayerMe:focusunit(nil, "worldmap")
					hGlobal.event:event("LocalEvent_HitOnTarget", w, nil, worldX, worldY)
					hGlobal.event:event("Event_TDUnitActived", w, 1, nil)
					hGlobal.O:replace("__WM__TargetOperatePanel",nil)
					hGlobal.O:replace("__WM__MoveOperatePanel",nil)
					
					--刷新英雄头像
					hGlobal.event:event("LocalEvent_PlayerChooseHero", nil)
				end
				]]
			end
		end
	end
end

--使用战术(道具)卡指令
hVar.CmdMgr[hVar.Operation.UseTacticCard] = function(sessionId, oPlayer, tacticId, itemId, worldX, worldY, t_worldI, t_worldC, iFlag)
	--print("使用战术(道具)卡指令", sessionId, oPlayer, tacticId, itemId, worldX, worldY)
	local w = hGlobal.WORLD.LastWorldMap
	
	--战术(道具)卡片是否存在
	if ((not tacticId) or (tacticId == 0)) and ((not itemId) or (itemId == 0)) then
		return
	end
	--LuaAddItemToPlayerBag(itemId,nil,nil,0)
	--使用战术(道具)技能卡
	hApi.UsePlayerTacticCard(oPlayer, tacticId, itemId, worldX, worldY, t_worldI, t_worldC, iFlag)
end

--建造塔指令
hVar.CmdMgr[hVar.Operation.BuildTower] = function(sessionId, oPlayer, t_worldI, t_worldC, buildId, goldCost)
	--print("建造塔指令", "sessionId=" .. sessionId, "oPlayer=" .. tostring(oPlayer), "t_worldI=" .. t_worldI, "t_worldC=" .. t_worldC, "buildId=" .. buildId, "goldCost=" .. goldCost)
	local _oTarget = hClass.unit:getChaByWorldI(t_worldI)
	--print(_oTarget, _oTarget.data.name, _oTarget.data.id, t_typeId)
	if (_oTarget) and (_oTarget:getworldC() ~= t_worldC) then
		_oTarget = nil
	end
	
	--塔基是否存在
	if (not _oTarget) or (_oTarget == 0) then
		--print("塔基是否存在, false")
		
		return
	end
	
	--塔基是否活着
	if (_oTarget.data.IsDead == 1) then
		--print("塔基是否活着, false")
		
		return
	end
	
	--建造单位
	--添加新角色
	local w = hGlobal.WORLD.LastWorldMap
	local oPlayerMe = w:GetPlayerMe()
	local mapInfo = w.data.tdMapInfo
	
	--本地才执行
	--print("本地才执行", tostring(oPlayerMe), tostring(oPlayer))
	--if (oPlayerMe == oPlayer) then
	--	local goldNow = mapInfo.gold
	--	--local goldCost = customTab.build[opr].cost
	--	
	--	if (goldNow >= goldCost) then
	--		--扣钱
	--		mapInfo.gold = mapInfo.gold - goldCost
	--		hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -goldCost)
	--		hGlobal.event:event("Event_TowerUpgradeCostRefresh")
	--	end
	--end
	
	--todo zhenkira -goldCost 要从每个角色身上取，而不是传过来
	if oPlayer and oPlayer.getresource then
		local td_upgrade = _oTarget.td_upgrade --zhenkira 2015.9.25 修改为角色身上的属性,并且使用kv形式存储表结构
		local td_upgrade_me
		local targetPos = _oTarget:getowner():getpos()
		local playerMe = w:GetPlayerMe()
		if playerMe and playerMe:getgod() and playerMe:getgod().td_upgrade then
			td_upgrade_me = playerMe:getgod().td_upgrade[_oTarget.data.id]
		end
		--print("塔防中的塔单位，显示建造按钮", td_upgrade)
		
		--如果是蜀国或者魏国的塔基，并且我的属方和当前塔基属方相同
		local changeTdUpgrade = hApi.CheckChangeTDUpgrade(w, _oTarget)
		
		--print("_oTarget.data.type == hVar.UNIT_TYPE.TOWER" ,td_upgrade,type(td_upgrade))
		if td_upgrade and type(td_upgrade) == "table" then
			local remould = td_upgrade.remould
			if changeTdUpgrade and td_upgrade_me then
				remould = td_upgrade_me.remould
			end
			
			local unlockCondition = remould[buildId].unlockCondition
			if unlockCondition then
				local buildNum = unlockCondition[2]
				local buildIdList = unlockCondition[3] or {}
				--取当前造了多少个指定的塔
				local buildNumNow = hApi.GetBuildTowerNum(w, targetPos, buildIdList)
				--print("buildNumNow:",buildNumNow,buildNum)
				if (buildNumNow < buildNum) then
					--[[
					--本地才执行
					if (oPlayerMe == oPlayer) then
						--本地关掉界面
						local panel = hGlobal.O["__WM__TargetOperatePanel"]
						--print("panel=", panel)
						if _oTarget and panel and (panel.data.bindU == _oTarget.ID) then --当前是选中此单位的操作面板
							local _childUI = panel.childUI
							if _childUI and _childUI["actions"] then
								local self = _childUI["actions"]
								print(self)
								--self:settick(250)
								
								--取消对之前选中单位的选中
								hGlobal.WORLD.LastWorldMap:GetPlayerMe():focusunit(nil, "worldmap")
								hGlobal.event:event("LocalEvent_HitOnTarget", world, nil, 0, 0)
								hGlobal.event:event("Event_TDUnitActived", world, 1, nil)
								hGlobal.O:replace("__WM__TargetOperatePanel", nil)
								hGlobal.O:replace("__WM__MoveOperatePanel", nil)
								
								--触发事件: 操作面板关闭
								hGlobal.event:event("LocalEvent_OperationPanelClosed", "build_num_less")
							end
						end
						
						--冒字
						--oUnit, text, color, offsetX, offsetY, fontSize, showTime, modelTable
						hApi.ShowLabelBubble(_oTarget, "拥有3个火焰塔才能建造", ccc3(255, 255, 0), 0, 20, nil, 2500, {model = "UI:AttrBg", x = 1, y = 1, z = -1, w = 240, h = 32,})
					end
					]]
					
					return
				end
			end
		end
		
		local goldNow = oPlayer:getresource(hVar.RESOURCE_TYPE.GOLD)
		if (goldNow >= goldCost) then
			oPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -goldCost)
			
			--本地刷新界面
			if (oPlayer == oPlayerMe) then
				hGlobal.event:event("Event_TowerUpgradeCostRefresh")
			end
			
			--取要建造的塔是否有生长动画
			--如果塔有生长动画，播放生长动画
			local growUnitID = 0
			local tGrowUnitID = hVar.tab_unit[buildId].growUnitID
			if (type(tGrowUnitID) == "table") then
				growUnitID = tGrowUnitID.id or 0
			end
			 --无生长动画，直接造塔
			if (growUnitID == 0) then
				local unitData = _oTarget.data
				
				--历史上所有建造的价格
				local allBuildCost = _oTarget.data.allBuildCost or 0
				
				local owner = unitData.owner
				if mapInfo.buildTogether and oPlayer.getpos then
					--如果操作的单位和自己是同一个势力并且是势力方单位,那么造出来的塔变成操作方的
					local targetPlayer = _oTarget:getowner()
					local targetPos = targetPlayer:getpos()
					if oPlayer:getforce() == targetPlayer:getforce() and (targetPos == 21 or targetPos == 22) then
						owner = oPlayer:getpos()
					end
				end
				--unitData.facing
				local nu = w:addunit(buildId, owner, nil, nil, -45, unitData.worldX,unitData.worldY,nil, {triggerID=_oTarget.data.triggerID})
				
				if nu then
					--累加建造花费
					nu.data.allBuildCost = allBuildCost + goldCost
					if (_oTarget.data.id == 69997) or (_oTarget.data.id == 11007) or (_oTarget.data.id == 14393) or (_oTarget.data.id == 39067) or (_oTarget.data.id == 39068) or (_oTarget.data.id == 39069) or (_oTarget.data.id == 39070) or (_oTarget.data.id == 39096) then
						nu.data.baseTower = _oTarget.data.id
					end
					
					--记录塔基所属的pos
					nu.data.baseTOwner = unitData.owner
					
					--拷贝路点
					nu:copyRoadPoint(_oTarget)
					
					--绑定triggerID
					if worldScene then
						hApi.chaSetUniqueID(nu.handle,_oTarget.data.triggerID,worldScene)
					end
					
					--zhenkira 角色出生事件
					hGlobal.event:call("Event_UnitBorn", nu)
					
					--hGlobal.WORLD.LastWorldMap:GetPlayerMe():focusunit(nu,"worldmap")
					
					--塔随机转一个角度
					local randAngle = w:random(0, 16) * 22.5
					hApi.ChaSetFacing(nu.handle, randAngle) --转向
					nu.data.facing = randAngle
					
					if _oTarget~=nil then
						--删除原角色
						_oTarget:del()
					end
					
					--clickIndex = -1
					--self:settick(250)
					--print(">>>>>>>> self:settick(250) 12")
					
					--播放特效及音效
					w:addeffect(96, 1, nil, unitData.worldX, unitData.worldY)
					if (oPlayer == oPlayerMe) then
						hApi.PlaySound("button")
					end
					
					--刷新技能范围
					--hGlobal.event:event("Event_TDUnitActived", w, 1, nu)
					
					--本地才执行
					if (oPlayerMe == oPlayer) then
						--统计建造塔
						LuaAddPlayerCountVal(hVar.MEDAL_TYPE.buildT)
						LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.buildT)
						--统计建造塔的总数
						local tabBuild = hVar.tab_unit[buildId]
						--print("buildId", buildId)
						for tagK,v in pairs(hVar.UNIT_TAG_TYPE.TOWER) do
							if tabBuild.tag and tabBuild.tag[v] then
								LuaAddPlayerCountVal(hVar.MEDAL_TYPE.buildTT, v)
								LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.buildTT, v)
							end
						end
						
						--存档
						--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
					end
					
					--pvp模式，塔有生存时间、血量翻倍、所有塔技能自动升满
					if (mapInfo) then
						if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
							--设置生存时间
							--[[
							local currenttime = w:gametime()
							nu.data.livetimeBegin = currenttime --生存时间开始值（毫秒）
							nu.data.livetime = 60000 * 10 --生存时间（毫秒）
							nu.data.livetimeMax = currenttime + 60000 * 10 --生存时间（毫秒）
							]]
							
							--[[
							--血量翻倍
							nu.attr.hp_max_basic = nu.attr.hp_max_basic * 20 --pvp模式血量超高
							local hp_max = nu:GetHpMax() --最大血量
							nu.attr.hp = hp_max --当前血量
							]]
							
							--[[
							--更新血条控件
							if nu.chaUI["hpBar"] then
								nu.chaUI["hpBar"]:setV(hp_max, hp_max)
								--print("oUnit.chaUI5()", new_hp, hp_max)
							end
							if nu.chaUI["numberBar"] then
								nu.chaUI["numberBar"]:setText(hp_max .. "/" .. hp_max)
							end
							]]
							
							--[[
							--所有塔的技能自动升满
							local td_upgrade = nu.td_upgrade
							if td_upgrade and type(td_upgrade) == "table" then
								local upgradeSkill = td_upgrade.upgradeSkill
								if upgradeSkill then
									if upgradeSkill.order and type(upgradeSkill.order) == "table" then
										for i = 1, #upgradeSkill.order do
											local skillId = upgradeSkill.order[i]
											local skillInfo = upgradeSkill[skillId]
											--如果没有解锁则不创建按钮
											if skillInfo and skillInfo.isUnlock then
												local maxSkillLv = skillInfo.maxLv or 1
												nu:learnSkill(skillId, maxSkillLv)
											end
										end
									else
										for skillId, skillInfo in pairs(upgradeSkill) do
											if skillId ~= "order" then
												--如果没有解锁则不创建按钮
												if skillInfo.isUnlock then
													local maxSkillLv = skillInfo.maxLv or 1
													nu:learnSkill(skillId, maxSkillLv)
												end
											end
										end
									end
								end
							end
							]]
						end
					end
					
					--触发事件: 造塔完成
					--安全执行
					if On_BuildTower_Special_Event then
						hpcall(On_BuildTower_Special_Event, oPlayer, nu)
					end
				end
			else --有生长动画，创建生长动画单位
				local unitData = _oTarget.data
				local growUnitDx = tGrowUnitID.dx or 0
				local growUnitDy = tGrowUnitID.dy or 0
				local growFacing = tGrowUnitID.facing or nil
				
				local owner = unitData.owner
				if mapInfo.buildTogether and oPlayer.getpos then
					--如果操作的单位和自己是同一个势力并且是势力方单位,那么造出来的塔变成操作方的
					local targetPlayer = _oTarget:getowner()
					local targetPos = targetPlayer:getpos()
					if oPlayer:getforce() == targetPlayer:getforce() and (targetPos == 21 or targetPos == 22) then
						owner = oPlayer:getpos()
					end
				end
				
				local gu = w:addunit(growUnitID, owner, nil, nil, -45, unitData.worldX+growUnitDx,unitData.worldY+growUnitDy)
				gu.handle._n:setPosition(ccp(unitData.worldX+growUnitDx,-(unitData.worldY+growUnitDy))) --精准位置
				
				--历史上所有建造的价格
				local allBuildCost = _oTarget.data.allBuildCost or 0
				allBuildCost = allBuildCost + goldCost
				
				local baseTower = 0
				if (_oTarget.data.id == 69997) or (_oTarget.data.id == 69995) or (_oTarget.data.id == 11007) or (_oTarget.data.id == 14393) or (_oTarget.data.id == 39067) or (_oTarget.data.id == 39068) or (_oTarget.data.id == 39069) or (_oTarget.data.id == 39070) or (_oTarget.data.id == 39096) then
					baseTower = _oTarget.data.id
				end
				
				gu.data.growParam = {buildId = buildId, oPlayer = oPlayer, allBuildCost = allBuildCost, baseTower = baseTower, owner = owner, worldX = unitData.worldX, worldY = unitData.worldY, triggerID = _oTarget.data.triggerID, growFacing = growFacing,} --生长动画参数
				
				--zhenkira 角色出生事件
				hGlobal.event:call("Event_UnitBorn", gu)
				
				if _oTarget~=nil then
					--删除原角色
					_oTarget:del()
				end
				
				--播放特效及音效
				w:addeffect(96, 1, nil, unitData.worldX, unitData.worldY)
				if (oPlayer == oPlayerMe) then
					hApi.PlaySound("button")
				end
			end
		end
	end
end

--升级塔科技指令
hVar.CmdMgr[hVar.Operation.UpgrateTowerSkill] = function(sessionId, oPlayer, t_worldI, t_worldC, skillId, skillLvNow, goldCost)
	--hVar.InProcessingUpgrateTowerSkill = 0 --是否正在处理升级塔的技能中
	
	local _oTarget = hClass.unit:getChaByWorldI(t_worldI)
	if (_oTarget) and (_oTarget:getworldC() ~= t_worldC) then
		_oTarget = nil
	end
	
	--塔是否存在
	if (not _oTarget) or (_oTarget == 0) then
		return
	end
	
	--塔是否活着
	if (_oTarget.data.IsDead == 1) then
		return
	end
	
	--检测，如果单位身上的技能当前等级大于等于要升的等级，说明是重复操作，挡掉
	local skillObj = _oTarget:getskill(skillId)
	local skillLvCurrent = 0 --单位身上本技能当前的等级
	if skillObj then
		skillLvCurrent = skillObj[2]
	end
	if (skillLvCurrent >= skillLvNow) then
		--print("如果单位身上的技能当前等级大于等于要升的等级，说明是重复操作，挡掉")
		return
	end
	
	--升级科技
	local w = _oTarget:getworld()
	local oPlayerMe = w:GetPlayerMe()
	local mapInfo = w.data.tdMapInfo
	
	--本地才执行
	--if (oPlayerMe == oPlayer) then
	--	local goldNow = mapInfo.gold
	--
	--	--角色技能升级
	--	--local skillLvNow = skillObj[2] + 1
	--	
	--	--local goldCost = customTab.skill[opr].costs[skillLvNow] or 0
	--	if (goldNow >= goldCost) then
	--		--累加建造花费
	--		_oTarget.data.allBuildCost = (_oTarget.data.allBuildCost or 0) + goldCost
	--		
	--		--扣钱
	--		mapInfo.gold = mapInfo.gold - goldCost
	--		hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -goldCost)
	--		hGlobal.event:event("Event_TowerUpgradeCostRefresh")
	--	end
	--end
	
	--zhenkira -goldCost 要从每个角色身上取，而不是传过来
	if oPlayer and oPlayer.getresource then
		local goldNow = oPlayer:getresource(hVar.RESOURCE_TYPE.GOLD)
		if (goldNow >= goldCost) then
			--geyachao: 这里先学习技能再扣钱，是因为本地监听了金钱改变事件，刷新界面。如果先扣钱，技能不是满级，会让技能按钮又亮了的
			--学习技能
			_oTarget:learnSkill(skillId, skillLvNow)
			
			--角色技能升级
			_oTarget.data.allBuildCost = (_oTarget.data.allBuildCost or 0) + goldCost
			
			--扣钱
			oPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -goldCost)
			
			--本地刷新金钱界面
			if (oPlayer == oPlayerMe) then
				hGlobal.event:event("Event_TowerUpgradeCostRefresh")
			end
		
			--本地播放音效
			if (oPlayer == oPlayerMe) then
				hApi.PlaySound("level_up")
			end
			--播放特效
			local unitData = _oTarget.data
			w:addeffect(194, 1, nil ,unitData.worldX, unitData.worldY)
			
			--[[
			if btn.childUI then
				if btn.childUI["cost"] then
					if skillLvNow  < maxSkillLv then
						local nextCost = customTab.skill[opr].costs[skillLvNow + 1] or "-"
						btn.childUI["cost"]:setText(tostring(nextCost))
					else
						btn.childUI["cost"]:setText(tostring("N/A"))
					end
				end
				
				--此处是塔拥有某个技能，更新技能界面的地方
				local _btnChildUI = btn.childUI
				if (_btnChildUI["skillLv"] ~= nil) then
					_btnChildUI["skillLv"]:del()
					_btnChildUI["skillLv"] = nil
				end
				
				--geyachao: 显示技能等级的小点点
				local point_y = 34
				if (g_phone_mode ~= 0) then --非电脑、平板模式
					point_y = 42
				end
				_btnChildUI["skillLv"] = hUI.button:new({
					parent = btn.handle._n,
					model = "UI:skill_point",
					x = 0,
					y = point_y,
					w = 1,
					h = 1,
				})
				_btnChildUI["skillLv"].handle.s:setOpacity(0)
				local ch = _btnChildUI["skillLv"] --子父控件
				--绘制每一个小点点
				local edge = 14 --边长
				local offset_x = 3 --x间距
				if (maxSkillLv == 4) then --数量过多，只能压缩间距
					offset_x = -1 --x间距
				elseif (maxSkillLv == 5) then --数量过多，只能压缩间距
					offset_x = -3 --x间距
				end
				if (g_phone_mode ~= 0) then --非电脑、平板模式
					edge = 16
					offset_x = 3
					if (maxSkillLv == 4) then --数量过多，只能压缩间距
						offset_x = -1 --x间距
					elseif (maxSkillLv == 5) then --数量过多，只能压缩间距
						offset_x = -3 --x间距
					end
				end
				local left_x = -math.floor(maxSkillLv / 2) * (edge + offset_x)
				if ((maxSkillLv % 2) == 0) then --偶数往右移半格
					left_x = left_x + (edge + offset_x) / 2
				end
				--skillLvNow) .. "/" .. tostring(maxSkillLv
				--底纹
				for i = 1, maxSkillLv, 1 do
					ch.childUI["point_bg" .. i] = hUI.image:new({
						parent = ch.handle._n,
						model = "UI:skill_point_slot",
						x = left_x + (i - 1) * (edge + offset_x),
						y = 0,
						w = edge,
						h = edge,
					})
				end
				--已获得的技能等级
				for i = 1, skillLvNow, 1 do
					ch.childUI["point" .. i] = hUI.image:new({
						parent = ch.handle._n,
						model = "UI:skill_point",
						x = left_x + (i - 1) * (edge + offset_x),
						y = 0,
						w = edge,
						h = edge,
					})
				end
				
				--zhenkira: 2015.11.20 不显示等级文字了
				--[=[
				if btn.childUI["skillLv"] then
					btn.childUI["skillLv"]:setText(tostring(skillLvNow) .. "/" .. tostring(maxSkillLv))
				end
				--]=]
			end
			
			--如果已经满级，则设置按钮不可用
			if (skillLvNow >= maxSkillLv) then
				btn:setstate(0)
			else
				--计算下一级消耗，如果当前的钱不足则设置为不可用
				local nextCost = customTab.skill[opr].costs[skillLvNow + 1]
				if (type(nextCost) ~= "number") or (mapInfo.gold < nextCost) then
					btn:setstate(0)
				end
			end
			]]
			
			--刷新技能范围
			local oUnit = oPlayerMe:getfocusunit() --上次旋中的角色
			if (oUnit == _oTarget) then
				hGlobal.event:event("Event_TDUnitActived", w, 1, _oTarget)
			end
			
			--本地才执行
			if (oPlayerMe == oPlayer) then
				--统计科技升级
				LuaAddPlayerCountVal(hVar.MEDAL_TYPE.buildS)
				LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.buildS)
				
				--存档
				--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			end
			
			--本地刷新界面
			--print("本地刷新界面", oPlayerMe, oPlayer)
			if (oPlayerMe == oPlayer) then
				local panel = hGlobal.O["__WM__TargetOperatePanel"]
				--print("panel=", panel)
				if _oTarget and panel and (panel.data.bindU == _oTarget.ID) then --当前是选中此单位的操作面板
					local _childUI = panel.childUI
					if _childUI and _childUI["actions"] then
						local self = _childUI["actions"]
						for i = 1, 10, 1 do
							local buttonNum = i
							local btnName = "btn_" .. buttonNum
							local btn = self.childUI[btnName]
							if btn and (btn.data.userdata == skillId) then --找到这个按钮
								--print("找到了", i)
								local opr = skillId
								local customTab = self.data.customTab
								local maxSkillLv = customTab.skill[opr].maxSkillLv or 1
								--print(btnName, btn, maxSkillLv)
								
								if btn.childUI then
									if btn.childUI["cost"] then 
										if (skillLvNow < maxSkillLv) then
											local nextCost = customTab.skill[opr].costs[skillLvNow + 1] or "-"
											--print("nextCost", nextCost)
											btn.childUI["cost"]:setText(tostring(nextCost))
										else
											btn.childUI["cost"]:setText(tostring("N/A"))
										end
									end
									
									--此处是塔还没某个技能，更新技能界面的地方
									local _btnChildUI = btn.childUI
									if (_btnChildUI["skillLv"] ~= nil) then
										_btnChildUI["skillLv"]:del()
										_btnChildUI["skillLv"] = nil
									end
									
									--geyachao: 显示技能等级的小点点
									local point_y = 34
									if (g_phone_mode ~= 0) then --非电脑、平板模式
										point_y = 42
									end
									_btnChildUI["skillLv"] = hUI.button:new({
										parent = btn.handle._n,
										model = "UI:skill_point",
										x = 0,
										y = point_y,
										w = 1,
										h = 1,
									})
									_btnChildUI["skillLv"].handle.s:setOpacity(0)
									local ch = _btnChildUI["skillLv"] --子父控件
									
									--角色学习技能
									--if (mapInfo.mapMode ~= hVar.MAP_TD_TYPE.PVP) then
									--print("mapInfo.skillLvupToMax:",mapInfo.skillLvupToMax)
									if not mapInfo.skillLvupToMax then
										--绘制每一个小点点
										local edge = 14 --边长
										local offset_x = 3 --x间距
										if (maxSkillLv == 4) then --数量过多，只能压缩间距
											offset_x = -1 --x间距
										elseif (maxSkillLv == 5) then --数量过多，只能压缩间距
											offset_x = -3 --x间距
										end
										if (g_phone_mode ~= 0) then --非电脑、平板模式
											edge = 16
											offset_x = 3
											if (maxSkillLv == 4) then --数量过多，只能压缩间距
												offset_x = -1 --x间距
											elseif (maxSkillLv == 5) then --数量过多，只能压缩间距
												offset_x = -3 --x间距
											end
										end
										local left_x = -math.floor(maxSkillLv / 2) * (edge + offset_x)
										if ((maxSkillLv % 2) == 0) then --偶数往右移半格
											left_x = left_x + (edge + offset_x) / 2
										end
										
										--skillLvNow) .. "/" .. tostring(maxSkillLv
										--底纹
										for i = 1, maxSkillLv, 1 do
											ch.childUI["point_bg" .. i] = hUI.image:new({
												parent = ch.handle._n,
												model = "UI:skill_point_slot",
												x = left_x + (i - 1) * (edge + offset_x),
												y = 0,
												w = edge,
												h = edge,
											})
										end
										--已获得的技能等级
										for i = 1, skillLvNow, 1 do
											ch.childUI["point" .. i] = hUI.image:new({
												parent = ch.handle._n,
												model = "UI:skill_point",
												x = left_x + (i - 1) * (edge + offset_x),
												y = 0,
												w = edge,
												h = edge,
											})
										end
									end
									--zhenkira: 2015.11.20 不显示等级文字了
									--[[
									if btn.childUI["skillLv"] then
										btn.childUI["skillLv"]:setText(tostring(skillLvNow) .. "/" .. tostring(maxSkillLv))
									end
									]]
								end
								
								--如果已经满级，则设置按钮不可用
								if (skillLvNow >= maxSkillLv) then
									--print("btn:setstate(0)     3")
									btn:setstate(0)
								else
									--计算下一级消耗，如果当前的钱不足则设置为不可用
									local nextCost = customTab.skill[opr].costs[skillLvNow + 1]
									
									--if (type(nextCost) ~= "number") or (mapInfo.gold < nextCost) then
									local targetP = w:GetPlayerMe()
									if (type(nextCost) ~= "number") or (targetP:getresource(hVar.RESOURCE_TYPE.GOLD) < nextCost) then
										--print("btn:setstate(0)     4")
										btn:setstate(0)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

--卖塔指令
hVar.CmdMgr[hVar.Operation.SellTower] = function(sessionId, oPlayer, t_worldI, t_worldC)
	local _oTarget = hClass.unit:getChaByWorldI(t_worldI)
	if (_oTarget) and (_oTarget:getworldC() ~= t_worldC) then
		_oTarget = nil
	end
	
	--塔是否存在
	if (not _oTarget) or (_oTarget == 0) then
		return
	end
	
	--塔是否活着
	if (_oTarget.data.IsDead == 1) then
		return
	end
	
	local w = _oTarget:getworld()
	local oPlayerMe = w:GetPlayerMe()
	local unitData = _oTarget.data
	
	--累加建造花费
	local allBuildCost = _oTarget.data.allBuildCost or 0
	
	--unitData.facing
	--local baseTowerId = 69997
	local mapInfo = w.data.tdMapInfo
	--if w and mapInfo and (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
	--	baseTowerId = 11007
	--end

	local baseTowerId = 69997
	if unitData.baseTower == 69997 or unitData.baseTower == 11007 or unitData.baseTower == 14393 then
		baseTowerId = unitData.baseTower
	end
	
	local owner = unitData.baseTOwner or unitData.owner
	local nu = w:addunit(baseTowerId, owner,nil,nil, -45, unitData.worldX,unitData.worldY,nil,{triggerID=_oTarget.data.triggerID})
	
	if nu then
		--本地才执行
		--if (oPlayerMe == oPlayer) then
		--	local mapInfo = w.data.tdMapInfo
		--	--拆塔返钱
		--	--拆除返还一半的建造费用
		--	if mapInfo then
		--		local goldAdd = math.floor(allBuildCost * 0.5)
		--		mapInfo.gold = mapInfo.gold + goldAdd
		--		hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, goldAdd)
		--		hGlobal.event:event("Event_TowerUpgradeCostRefresh")
		--		hApi.ShowGoldBubble(nu, goldAdd, false)
		--	end
		--	
		--	nu.data.allBuildCost = 0
		--end
		
		if oPlayer then
			--拆塔返钱
			--拆除返还一半的建造费用
			local goldAdd = math.floor(allBuildCost * 0.5)
			
			--pvp模式，卖的钱和塔的血量挂钩
			if w and w.data.tdMapInfo and (w.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
				local hpPercent = math.floor(_oTarget.attr.hp / _oTarget:GetHpMax() * 100) / 100 --保留2位有效数字，用于同步
				goldAdd = math.floor(goldAdd * hpPercent)
			end
			
			oPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, goldAdd)
			if oPlayer == oPlayerMe then
				hGlobal.event:event("Event_TowerUpgradeCostRefresh")
				hApi.ShowGoldBubble(nu, goldAdd, false)
			end
		end
		
		--拷贝路点
		nu:copyRoadPoint(_oTarget)
		
		--绑定triggerID
		if worldScene then
			hApi.chaSetUniqueID(nu.handle,_oTarget.data.triggerID,worldScene)
		end
		
		--zhenkira 角色出生事件
		hGlobal.event:call("Event_UnitBorn", nu)
		
		--w:GetPlayerMe():focusunit(nu,"worldmap")
		
		if _oTarget~=nil then
			--删除原角色
			_oTarget:del()
		end
		
		--clickIndex = -1
		--self:settick(250)
		--print(">>>>>>>> self:settick(250) 12")
		
		--播放特效及音效
		w:addeffect(96, 1, nil, unitData.worldX, unitData.worldY)
		if (oPlayer == oPlayerMe) then
			hApi.PlaySound("burning1")
		end
	end
end

--使用建筑的技能指令
hVar.CmdMgr[hVar.Operation.CastBuildingSkill] = function(sessionId, oPlayer, t_worldI, t_worldC, skillId, casttype, goldCost, tokenId)
	--hVar.InProcessingCastBuildingSkill = 0 --是否正在处理使用建筑的技能中
	
	local _oTarget = hClass.unit:getChaByWorldI(t_worldI)
	if (_oTarget) and (_oTarget:getworldC() ~= t_worldC) then
		_oTarget = nil
	end
	
	--塔是否存在
	if (not _oTarget) or (_oTarget == 0) then
		return
	end
	
	--塔是否活着
	if (_oTarget.data.IsDead == 1) then
		return
	end
	
	--使用建筑的技能
	local w = _oTarget:getworld()
	local oPlayerMe = w:GetPlayerMe()
	local mapInfo = w.data.tdMapInfo
	--local goldNow = mapInfo.gold
	local goldNow = 0
	if oPlayer and oPlayer.getresource then
		goldNow = oPlayer:getresource(hVar.RESOURCE_TYPE.GOLD)
	end
	
	--角色技能升级
	--local skillLvNow = skillObj[2] + 1
	
	--local goldCost = customTab.skill[opr].costs[skillLvNow] or 0
	local skillObj = _oTarget:getskill(skillId)
	if skillObj then
		local lv = skillObj[2]
		local count = skillObj[4]
		local cd = skillObj[5]
		local lasttime = skillObj[6]
		local timenow = hGlobal.WORLD.LastWorldMap:gametime()
		--local casttype = customTab.cskill[opr].casttype
		if ((lasttime > 0 and lasttime + cd <= timenow) or lasttime <= 0) and (lv > 0) then
			--不限次数和有次数限制
			if (count < 0) or (count > 0) then
				if (goldNow >= goldCost) then
					if oPlayer then
						oPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, -goldCost)
						
						--本地才执行
						if (oPlayerMe == oPlayer) then
							hGlobal.event:event("Event_TowerUpgradeCostRefresh")
						end
					
						--释放技能
						--_oTarget:learnSkill(skillId, skillLvNow)
						local tCastParam = {level = lv,}
						local worldX, worldY = _oTarget.data.defend_x, _oTarget.data.defend_y --以后会使用守备点的坐标
						local gridX, gridY = w:xy2grid(worldX, worldY)
						if (casttype == hVar.CAST_TYPE.SKILL_TO_GROUND) then
							hApi.CastSkill(_oTarget, skillId, 0, nil, nil, gridX, gridY, tCastParam)
						elseif (casttype == hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK) then --对有效的地面坐标
							hApi.CastSkill(_oTarget, skillId, 0, nil, nil, gridX, gridY, tCastParam)
						elseif (casttype == hVar.CAST_TYPE.SKILL_TO_GROUND_MOVE_TO_POINT) then --移动到达目标点后再地面释放（建筑直接释放技能）
							hApi.CastSkill(_oTarget, skillId, 0, nil, nil, gridX, gridY, tCastParam)
						elseif (casttype == hVar.CAST_TYPE.SKILL_TO_GROUND_MOVE_TO_POINT_BLOCK) then --移动到达有效目标点后再地面释放（建筑直接释放技能）
							hApi.CastSkill(_oTarget, skillId, 0, nil, nil, gridX, gridY, tCastParam)
						elseif (casttype == hVar.CAST_TYPE.IMMEDIATE) then --点击直接生效类型
							hApi.CastSkill(_oTarget, skillId, 0, nil, _oTarget, nil, nil, tCastParam)
						end
						
						--重新设置技能属性
						if (count > 0) then
							skillObj[4] = skillObj[4] - 1		--次数
						end
						skillObj[6] = w:gametime() --施法时间
						
						--检测本单位是否有共享cd的技能
						local td_upgrade = _oTarget.td_upgrade
						if td_upgrade and (type(td_upgrade) == "table") then
							if td_upgrade.castSkill then
								local shareCD = td_upgrade.castSkill.shareCD
								if shareCD then
									for i = 1, #shareCD, 1 do
										if (shareCD[i] == skillId) then --存在共享cd
											--print("存在共享cd", skillId)
											for j = 1, #shareCD, 1 do
												local sObj = _oTarget:getskill(shareCD[j])
												--print("sObj", shareCD[j], sObj)
												if sObj then
													sObj[6] = w:gametime() --施法时间
												end
											end
											
											break
										end
									end
								end
							end
						end
						
						--[[
						--刷新界面
						if btn.childUI then
							if btn.childUI["cost"] then
								btn.childUI["cost"]:setText(tostring(skillObj[4]))
							end
						end
						
						--如果已经满级，则设置按钮不可用
						if (count == 0) or ((cd >= 0) and (skillObj[6] + cd > hApi.gametime())) or (lv <= 0) then
							btn:setstate(0)
						end
						
						self:settick(250)
						
						--print(">>>>>>>> self:settick(250) 10")
						]]
						
						--触发事件: 使用建筑的技能
						hGlobal.event:event("Event_CastBuildingSkill", oPlayer, _oTarget, skillId, goldCost, tokenId)
						
						--本地才执行
						if (oPlayerMe == oPlayer) then
							--通知服务器确认兵符消耗（不走同步协议）
							if tokenId and (tonumber(tokenId) > 0) then
								--检测是否有电脑
								local bHaveComputer = false
								if (w.data.session_cfgId == 1) then --pvp配置id(1:娱乐房 / 4:匹配房)
									for i = 1, 20, 1 do
										local player = w.data.PlayerList[i]
										--如果玩家存在并且玩家是电脑
										if player and (player:gettype() >= 2) and (player:gettype() <= 6) then
											bHaveComputer = true --有电脑
										end
									end
								end
								
								--冒字，扣除兵符
								if (bHaveComputer) then
									hApi.ShowLabelBubble(_oTarget, "-0", ccc3(255, 255, 255), 15, 20, nil, 1500, {model = "UI:pvptoken", x = -25, y = 2, w = 20, h = 24,})
								else
									hApi.ShowLabelBubble(_oTarget, "-1", ccc3(255, 255, 255), 15, 20, nil, 1500, {model = "UI:pvptoken", x = -25, y = 2, w = 20, h = 24,})
								end
								
								SendPvpCmdFunc["pvpcoin_cost_ok"](sessionId, tokenId)
							end
						end
					end
				end
			end
		end
	end
end

--游戏局开始
hVar.CmdMgr[hVar.Operation.GameStart] = function(sessionId, oPlayer)
	--print("游戏局开始 hVar.CmdMgr[hVar.Operation.GameStart]:", sessionId, oPlayer, oPlayer:getforce())
	
	--添加英雄等
	local w = hGlobal.WORLD.LastWorldMap
	
	--添加游戏信息文本
	hApi.AppendGameInfo("hVar.Operation.GameStart, w=" .. tostring(w))
	
	if w then
		--pvp
		--geyachao: 同步日志: 地图信息
		if (hVar.IS_SYNC_LOG == 1) then
			local mapName = w.data.map
			local mapWidth = w.data.sizeW
			local mapHeight = w.data.sizeH
			local msg = "MapInfo: mapName=" .. tostring(mapName) .. ",mapWidth=" .. mapWidth .. ",mapWidth=" .. mapHeight
			hApi.SyncLog(msg)
		end
		
		--geyachao: 同步日志: 地图障碍数
		if (hVar.IS_SYNC_LOG == 1) then
			local count = xlScene_GetBlockCount(g_world) --获得大地图上的所有障碍的累加值
			local msg = "BlockCount: count=" .. tostring(count)
			hApi.SyncLog(msg)
		end
		
		local mapInfo = w.data.tdMapInfo
		--如果游戏局处于初始化完毕但还未开始游戏状态
		if mapInfo and (mapInfo.mapState >= hVar.MAP_TD_STATE.BEGIN) and (mapInfo.mapState < hVar.MAP_TD_STATE.PAUSE) then
			
			--添加英雄单位
			w:addPlayerAllHeroUnit_PVP()
			
			--战术技能卡资源生效
			w:tacticsTakeEffect(nil)
			
			--战术技能卡对地图已有角色生效
			--print("游戏局开始，战术技能卡对地图已有角色生效")
			w:enumunit(function(u)
				w:tacticsTakeEffect(u)
			end)
			
			hGlobal.event:event("Event_TacticsInit")
			
			--pvp模式，触发游戏开始
			hGlobal.event:call("LocalEvent_TDGameBegin", w.data.map, w)
		end
	end
	
	--开始发兵
	hGlobal.event:event("LocalEvent_TD_NextWave", true)
end

--玩家离线
hVar.CmdMgr[hVar.Operation.PlayerLeave] = function(sessionId, oPlayer, leaveType)
	--print("hVar.CmdMgr[hVar.Operation.PlayerLeave]:", sessionId, oPlayer, oPlayer:getforce())
	
	--print("leaveType=", leaveType)
	
	-- -7 投降（有效局的主动离开算投降）
	-- -6 主动离开游戏（无效局的主动离开算无效）
	-- -5 掉线
	local nleaveType = tonumber(leaveType) or 0
	
	--玩家名
	local playerName = oPlayer.data.name
	
	--显示的文字
	 local strText = nil
	 if (nleaveType == -5) then --掉线
		--strText = playerName .. "掉线了！" --language
		strText = playerName .. hVar.tab_string["PVP_Event_Offline"] --language
	 elseif (nleaveType == -6) then --逃跑
		--strText = playerName .. "逃跑了！" --language
		strText = playerName .. hVar.tab_string["PVP_Event_Escape"] --language
	 elseif (nleaveType == -7) then --投降
		--strText = playerName .. "投降了！" --language
		strText = playerName .. hVar.tab_string["PVP_Event_Surrand"] --language
	 else --其它
		--strText = playerName .. "离开了游戏！" --language
		strText = playerName .. hVar.tab_string["PVP_Event_Leave"] --language
	 end
	
	--冒字显示
	hUI.floatNumber:new({
		x = hVar.SCREEN.w / 2,
		y = hVar.SCREEN.h / 2,
		align = "MC",
		text = "",
		lifetime = 3000,
		fadeout = -550,
		moveY = 32,
	}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
	
	--设置玩家离线
	oPlayer:setoffline()
end

--回合开始
hVar.CmdMgr[hVar.Operation.BeginTurn] = function(sessionId, cTurn, checkSum1, checkSum2, checkSum3, checkSum4)
	--客户端不处理
	--...
end

--[[
--客户端完成了此turn的指令
hVar.CmdMgr[hVar.Operation.ClientTurnFinish] = function(sessionId, oPlayer, hTurn)
	print("hVar.CmdMgr[hVar.Operation.ClientTurnFinish]:", sessionId, oPlayer, hTurn)
	
	local w = hGlobal.WORLD.LastWorldMap
	w.data.cTurnFinish = hTurn
	
	--如果之前因为客户端turn比服务器过快而游戏暂停，如果服务器turn已一致，可以恢复
	if (mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE)  then
		if (w.data.hTurn >= w.data.cTurnFinish) then
			--恢复
			world:pause(0)
			mapInfo.mapState = mapInfo.mapLastState
			mapInfo.mapLastState = hVar.MAP_TD_STATE.IDLE
		end
	end
end
]]

--发生不同步
hVar.CmdMgr[hVar.Operation.GameOutSync] = function(sessionId, oPlayer, syncInfo)
	--标记本地状态为end
	if (hGlobal.WORLD.LastWorldMap ~= nil) then
		local mapInfo = hGlobal.WORLD.LastWorldMap.data.tdMapInfo
		if mapInfo then
			mapInfo.mapState = hVar.MAP_TD_STATE.END
		end
	end
	
	--异常结束(-3是给服务器记录玩家状态的)
	SendPvpCmdFunc["game_end"](sessionId, "-3|")
	
	--[[
	--geyachao: 同步日志: 不同步的描述
	if (hVar.IS_SYNC_LOG == 1) then
		local msg = "GameOutSync: sessionId=" .. sessionId .. ",uid=" .. tostring(xlPlayer_GetUID()) .. ",syncInfo=" .. tostring(syncInfo)
		hApi.SyncLog(msg)
		--print("执行", msg)
	end
	]]
	
	--弹框，不同步
	hApi.MessageBoxAsync()
end

--重连补帧日志
hVar.CmdMgr[hVar.Operation.ReloginFrame] = function(sessionId, oPlayer, reloginDbid,fromTurn,EndTurn)
	--print("hVar.Operation.ReloginFrame:",sessionId, oPlayer, reloginDbid,fromTurn,EndTurn)
	
	--geyachao: 同步日志: 重连补帧日志（只有一边有）
	if (hVar.IS_SYNC_LOG == 1) then
		local msg = "[ignore]ReloginFrame: sessionId=" .. sessionId .. ",reloginDbid=" .. tostring(reloginDbid) .. ",fromTurn=" .. tostring(fromTurn) .. ",EndTurn=" .. tostring(EndTurn)
		hApi.SyncLog(msg)
		--print("执行", msg)
	end
end

--英雄复活
hVar.CmdMgr[hVar.Operation.HeroRebirth] = function(sessionId, oPlayer, heroId, t_worldI, t_worldC, result, tokenId)
	--print("英雄复活", sessionId, oPlayer, heroId, t_worldI, t_worldC, result, tokenId)
	
	local _oTarget = hClass.unit:getChaByWorldI(t_worldI)
	if (_oTarget) and (_oTarget:getworldC() ~= t_worldC) then
		_oTarget = nil
	end
	
	--单位是否存在
	if (not _oTarget) or (_oTarget == 0) then
		return
	end
	
	local ret = tonumber(result)
	
	--成功
	if (ret == 1) then
		--复活英雄
		local world = hGlobal.WORLD.LastWorldMap
		local oPlayerMe = world:GetPlayerMe()
		local mapInfo = world.data.tdMapInfo
		local currenttime = world:gametime() --当前时间
		
		for i = #world.data.rebirthT, 1 , -1 do --复活表
			local t = world.data.rebirthT[i]
			local beginTick = t.beginTick --开始的时间
			local rebithTime = t.rebithTime --复活总共需要的时间
			local oDeadHero = t.oDeadHero --死亡的英雄
			local deadoUint = t.deadoUint --倒计时的单位
			if (_oTarget == deadoUint) then --找到了
				t.rebithTime = 0
				
				break
			end
		end
		
		--更新pvp购买复活的次数
		local pos = oPlayer:getpos()
		world.data.pvp_buy_rebirth_count[pos] = world.data.pvp_buy_rebirth_count[pos] - 1
		if (world.data.pvp_buy_rebirth_count[pos] < 0) then
			world.data.pvp_buy_rebirth_count[pos] = 0
		end
		
		--本地更新英雄头像栏的复活次数
		if (oPlayerMe == oPlayer) then
			for i = 1, #(oPlayerMe.heros), 1 do
				local oHero = oPlayerMe.heros[i]
				if oHero then
					if oHero.heroUI and oHero.heroUI["btnIcon"] and oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"] then
						--oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"].handle._n:setVisible(true) --显示
						oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"]:setText("x" .. world.data.pvp_buy_rebirth_count[pos])
					end
					
					--设置复活次数颜色
					if (world.data.pvp_buy_rebirth_count[pos] > 0) then
						if oHero.heroUI and oHero.heroUI["btnIcon"] and oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"] then
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"].handle.s:setColor(ccc3(255, 255, 255))
						end
						if oHero.heroUI and oHero.heroUI["btnIcon"] and oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"] then
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"].handle.s:setColor(ccc3(255, 255, 255))
						end
					else
						if oHero.heroUI and oHero.heroUI["btnIcon"] and oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"] then
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"].handle.s:setColor(ccc3(168, 168, 168))
						end
						if oHero.heroUI and oHero.heroUI["btnIcon"] and oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"] then
							oHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"].handle.s:setColor(ccc3(168, 168, 168))
						end
					end
				end
			end
		end
		
		--本地才执行
		if (oPlayerMe == oPlayer) then
			--通知服务器确认兵符消耗（不走同步协议）
			if tokenId and (tonumber(tokenId) > 0) then
				--冒字，扣除兵符
				hApi.ShowLabelBubble(_oTarget, "-5", ccc3(255, 255, 255), 15, 20, nil, 1500, {model = "UI:pvptoken", x = -25, y = 2, w = 20, h = 24,})
				
				SendPvpCmdFunc["pvpcoin_cost_ok"](sessionId, tokenId)
			end
		end
	else
		--复活次数超上限
	end
end

--拾取道具
hVar.CmdMgr[hVar.Operation.PickUpItem] = function(sessionId, oPlayer, u_worldI, u_worldC, t_worldI, t_worldC)
	local oUnit = hClass.unit:getChaByWorldI(u_worldI)
	if (oUnit) and (oUnit:getworldC() ~= u_worldC) then
		oUnit = nil
	end
	
	--单位是否存在
	if (not oUnit) or (oUnit == 0) then
		return
	end
	
	--召唤、分身单位不能捡道具
	if (oUnit.data.is_summon == 1) or (oUnit.data.is_fenshen == 1) then
		--变身的坦克可以
		if (oUnit.data.id ~= hVar.MY_TANK_ID) then
			return
		end
	end
	
	local oItem = hClass.unit:getChaByWorldI(t_worldI)
	if (oItem) and (oItem:getworldC() ~= t_worldC) then
		oItem = nil
	end
	
	--道具是否存在
	if (not oItem) or (oItem == 0) then
		return
	end
	
	local world = hGlobal.WORLD.LastWorldMap
	local oPlayerMe = world:GetPlayerMe()
	--local itemId = hVar.tab_unit[oItem.data.id].itemId
	local itemId = oItem:getitemid()
	local itemLv = 1 --道具技能等级
	local itemPosX, itemPosY = hApi.chaGetPos(oItem.handle)
	
	--读取存档，此道具是否有对应的战术卡，读取战术卡的等级
	if (itemId) and (itemId ~= 0) then
		local tabI = hVar.tab_item[itemId]
		if tabI then
			local tacticId = tabI.tacticId --道具对应的战术卡
			if tacticId and (tacticId > 0) then
				local tTactics = LuaGetPlayerSkillBook()
				if tTactics then
					for i = 1, #tTactics, 1 do
						local id, lv, num = unpack(tTactics[i])
						if (id == tacticId) then --找到了
							if (lv > 0) then
								itemLv = lv
							end
							
							break
						end
					end
				end
			end
		end
	end
	
	--遍历该玩家的全部英雄，找到此道具是否已经在某个英雄身上
	if (itemId) and (itemId ~= 0) then
		for j = 1, #oPlayer.heros, 1 do
			local oHero = oPlayer.heros[j]
			local itemSkillT = oHero.data.itemSkillT
			if (itemSkillT) then
				for k = 1, #itemSkillT, 1 do
					local activeItemId = itemSkillT[k].activeItemId --主动技能的CD
					local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
					local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
					local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:秒）
					
					if (activeItemId == itemId) then --找到了
						--[[
						if (oPlayerMe == oPlayer) then
							--本地冒字
							local strText = "已获得该道具，不能重复获得！" --language
							--local strText = hVar.tab_string["__TEXT_PVP_WaitingHint"] --language
							hUI.floatNumber:new({
								x = hVar.SCREEN.w / 2,
								y = hVar.SCREEN.h / 2,
								align = "MC",
								text = "",
								lifetime = 1000,
								fadeout = -550,
								moveY = 32,
							}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
						end
						
						return
						]]
					end
				end
			end
		end
	end
	
	--如果是随机地图，那么将此特效存储起来，切换关卡时待删除
	local regionId = world.data.randommapIdx
	if (regionId > 0) then
		local regionData = world.data.randommapInfo[regionId]
		if regionData then
			local drop_units = regionData.drop_units --掉落道具集
			if drop_units then
				drop_units[oItem] = nil
				--print("删除 drop_units", oItem.data.name, oItem:getworldC())
			end
		end
	end
	
	--删除道具
	oItem:del()
	
	--添加道具技能
	local itemNum = -1
	if (itemId) and (itemId ~= 0) then
		itemNum = hVar.tab_item[itemId].activeSkill and hVar.tab_item[itemId].activeSkill.count or -1
	end
	hGlobal.event:event("Event_AddTacticsActiveSkill", oPlayer, itemId, itemLv, itemNum, oUnit.data.id)
	
	--[[
	--如果此道具绑定了战术卡，加战术卡碎片
	local tabI = hVar.tab_item[itemId]
	local itemTacticId = tabI.tacticId
	if itemTacticId and (itemTacticId > 0) then
		--LuaAddPlayerTacticDebris(itemTacticId, 1) --加战术卡碎片
		local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
		local nStage = tInfo.stage or 1 --本关id
		if (tInfo.stageInfo == nil) then
			tInfo.stageInfo = {}
		end
		if (tInfo.stageInfo[nStage] == nil) then
			tInfo.stageInfo[nStage] = {}
		end
		local tacticInfo = tInfo.stageInfo[nStage]["tacticInfo"] or {} --本关地图内捡取的战术卡碎片信息
		local debrisNum = tacticInfo[itemTacticId] or 0
		debrisNum = debrisNum + 1
		
		--存储
		tacticInfo[itemTacticId] = debrisNum
		tInfo.stageInfo[nStage]["tacticInfo"] = tacticInfo --本关地图内捡取的战术卡碎片信息
		LuaSavePlayerList()
	end
	]]
	if (itemId) and (itemId ~= 0) then
		local tabI = hVar.tab_item[itemId]
		if tabI then
			local itemType = tabI.type
			--local itemTacticId = tabI.tacticId
			
			--统计使用的战术卡
			if (itemType == hVar.ITEM_TYPE.TACTIC_USE) then
				local tInfo = GameManager.GetGameInfo("tacticInfo")
				local debrisNum = 0
				if tInfo[itemId] then
					debrisNum = tInfo[itemId]
				end
				
				--数量加1
				debrisNum = debrisNum + 1
				print("@@@@@@@@ 统计使用的战术卡", itemId, debrisNum)
				
				--存储
				local tData = {itemId, debrisNum}
				GameManager.SetGameInfo("tacticInfo", {tData,})
				hGlobal.event:event("LocalEvent_ShowTempBagBtn")
			end
			
			--统计武器枪宝箱
			if (itemType == hVar.ITEM_TYPE.CHEST_WEAPON_GUN) then
				local tInfo = GameManager.GetGameInfo("chestInfo")
				local weapongunChestNum = 0
				if tInfo[itemId] then
					weapongunChestNum = tInfo[itemId]
				end
				
				--数量加1
				weapongunChestNum = weapongunChestNum + 1
				print("@@@@@@@@ 统计武器枪宝箱", weapongunChestNum)
				
				--存储
				local tData = {itemId, weapongunChestNum}
				GameManager.SetGameInfo("chestInfo", {tData,})
			end
			
			--统计战术卡宝箱
			if (itemType == hVar.ITEM_TYPE.CHEST_TACTIC) then
				local tInfo = GameManager.GetGameInfo("chestInfo")
				local tacticChestNum = 0
				if tInfo[itemId] then
					tacticChestNum = tInfo[itemId]
				end
				
				--数量加1
				tacticChestNum = tacticChestNum + 1
				print("@@@@@@@@ 统计战术卡宝箱", tacticChestNum)
				
				--存储
				local tData = {itemId, tacticChestNum}
				GameManager.SetGameInfo("chestInfo", {tData,})
				hGlobal.event:event("LocalEvent_ShowTempBagBtn")
			end
			
			--统计宠物宝箱
			if (itemType == hVar.ITEM_TYPE.CHEST_PET) then
				local tInfo = GameManager.GetGameInfo("chestInfo")
				local petChestNum = 0
				if tInfo[itemId] then
					petChestNum = tInfo[itemId]
				end
				
				--数量加1
				petChestNum = petChestNum + 1
				print("@@@@@@@@ 统计宠物宝箱", petChestNum)
				
				--存储
				local tData = {itemId, petChestNum}
				GameManager.SetGameInfo("chestInfo", {tData,})
				hGlobal.event:event("LocalEvent_ShowTempBagBtn")
			end
			
			--统计装备宝箱
			if (itemType == hVar.ITEM_TYPE.CHEST_EQUIP) then
				local tInfo = GameManager.GetGameInfo("chestInfo")
				local equipChestNum = 0
				if tInfo[itemId] then
					equipChestNum = tInfo[itemId]
				end
				
				--数量加1
				equipChestNum = equipChestNum + 1
				print("@@@@@@@@ 统计装备宝箱", equipChestNum)
				
				--存储
				local tData = {itemId, equipChestNum}
				GameManager.SetGameInfo("chestInfo", {tData,})
				hGlobal.event:event("LocalEvent_ShowTempBagBtn")
			end
			
			if world.data.map == hVar.MainBase then
				--播放音效
				hApi.PlaySound("Cursor1")
			else
				--宝箱，做一个动画
				if (itemType == hVar.ITEM_TYPE.CHEST_WEAPON_GUN) or (itemType == hVar.ITEM_TYPE.CHEST_TACTIC)
				or (itemType == hVar.ITEM_TYPE.CHEST_PET) or (itemType == hVar.ITEM_TYPE.CHEST_EQUIP) then
					local screenX, screenY = hApi.world2view(itemPosX, itemPosY) --屏幕坐标
					local _frm2 = hGlobal.UI.TDSystemMenuBar
					local _parent = _frm2.handle._n
					local btn2 = _frm2.childUI["bag"]
					local fromX = screenX
					local fromY = screenY
					local toX = _frm2.data.x + btn2.data.x
					local toY = _frm2.data.y + btn2.data.y
					
					--print(fromX, fromY, toX, toY)
					
					--local angle1 = GetLineAngle(fromX, fromY, toX, toY) --角度制
					local ctrl1 = hUI.image:new({
						parent = nil,
						x = fromX,
						y = fromY,
						z = 10000,
						model = tabI.icon,
						align = "MC",
						scale = 1.0,
					})
					--ctrl1.handle.s:setRotation(angle1)
					--地上的buff动画
					local ACTTIME = 0.6
					local config = ccBezierConfig:new()
					config.controlPoint_1 = ccp(fromX, fromY)     
					config.controlPoint_2 = ccp(fromX - (fromX - toX) / 1.5, fromY + (fromY - toY) / 2)
					config.endPosition = ccp(toX, toY)
					local moveto = CCEaseSineOut:create(CCBezierTo:create(ACTTIME, config))
					
					local scaleToSmall = CCScaleTo:create(ACTTIME, 0.2) --变小
					local rot = CCRotateBy:create(ACTTIME, 720) --旋转
					local spawn1 = CCSpawn:createWithTwoActions(scaleToSmall, rot) --同步1
					local spawn2 = CCSpawn:createWithTwoActions(moveto, spawn1) --同步1
					--local moveto = CCEaseSineIn:create(CCMoveTo:create(ACTTIME, ccp(toX, toY)))
					local callback = CCCallFunc:create(function()
						ctrl1:del()
					end)
					ctrl1.handle._n:runAction(CCSequence:createWithTwoActions(spawn2, callback))
					
					--按钮的动画
					local ACTTIME2 = 0.52
					local delay = CCDelayTime:create(ACTTIME2)
					local scaleBig = CCEaseSineOut:create(CCScaleTo:create(ACTTIME - ACTTIME2, 1.2))
					local scaleSmall = CCEaseSineIn:create(CCScaleTo:create(ACTTIME - ACTTIME2, 1.0))
					local a = CCArray:create()
					a:addObject(delay)
					a:addObject(scaleBig)
					a:addObject(scaleSmall)
					local sequence = CCSequence:create(a)
					btn2.handle._n:runAction(sequence)
					
					--播放音效
					hApi.PlaySound("Cursor1")
				end
			end
		end
	end
end

--丢掉道具
hVar.CmdMgr[hVar.Operation.DropOutItem] = function(sessionId, oPlayer, tacticId, itemId)
	hGlobal.event:event("Event_RemoveTacticsActiveSkill", oPlayer, tacticId, itemId)
end

hVar.CmdMgr[hVar.Operation.AdaptNetDelay] = function(sessionId, oPlayer, endTurnInterval, framePerTurn, opExecuteInterval)
	
	--print("hVar.Operation.AdaptNetDelay:",endTurnInterval, framePerTurn, opExecuteInterval)
	
	local w = hGlobal.WORLD.LastWorldMap
	if w then
		local d = w.data
		d.framePerTurn = framePerTurn--余数
		d.endTurnInterval = endTurnInterval--客户端下次发送同步消息的帧数
	end
end

--联机升级塔科技次数
hVar.CmdMgr[hVar.Operation.UpgrateTowerCount] = function(sessionId, oPlayer, t_worldI, t_worldC, skillId, skillCountNow)
	--hVar.InProcessingUpgrateTowerSkill = 0 --是否正在处理升级塔的技能中
	--print("联机升级塔科技次数", sessionId, oPlayer, t_worldI, t_worldC, skillId, skillCountNow)
	
	local _oTarget = hClass.unit:getChaByWorldI(t_worldI)
	if (_oTarget) and (_oTarget:getworldC() ~= t_worldC) then
		_oTarget = nil
	end
	
	--塔是否存在
	if (not _oTarget) or (_oTarget == 0) then
		--todo
		--geyachao: 同步日志: 测试查不同步
		if (hVar.IS_SYNC_LOG == 1) then
			local msg = "UpgrateTowerCount: _oTarget=" .. tostring(_oTarget)
			hApi.SyncLog(msg)
		end
		
		return
	end
	
	--塔是否活着
	if (_oTarget.data.IsDead == 1) then
		--todo
		--geyachao: 同步日志: 测试查不同步
		if (hVar.IS_SYNC_LOG == 1) then
			local msg = "UpgrateTowerCount: _oTarget.data.IsDead=" .. tostring(_oTarget.data.IsDead)
			hApi.SyncLog(msg)
		end
		
		return
	end
	
	--检测，如果单位身上的技能当前次数不等于要升的等级，说明是重复操作，挡掉
	local skillObj = _oTarget:getskill(skillId)
	--print("skillObj", skillObj)
	local skillCountCurrent = 0 --单位身上本技能当前的次数
	if skillObj then
		skillCountCurrent = skillObj[4]
	end
	--print("skillCountCurrent", skillCountCurrent)
	if (skillCountCurrent ~= skillCountNow) then
		--print("检测，如果单位身上的技能当前次数不等于要升的等级，说明是重复操作，挡掉")
		--todo
		--geyachao: 同步日志: 测试查不同步
		if (hVar.IS_SYNC_LOG == 1) then
			local msg = "UpgrateTowerCount: skillCountCurrent=" .. tostring(skillCountCurrent) .. ",skillCountNow=" .. tostring(skillCountNow)
			hApi.SyncLog(msg)
		end
		
		return
	end
	
	--升级科技次数
	local w = _oTarget:getworld()
	local oPlayerMe = w:GetPlayerMe()
	local mapInfo = w.data.tdMapInfo
	
	--zhenkira -goldCost 要从每个角色身上取，而不是传过来
	if oPlayer and oPlayer.getresource then
		--geyachao: 同步日志: 测试查不同步
		if (hVar.IS_SYNC_LOG == 1) then
			local msg = "UpgrateTowerCount: goldNow=" .. tostring(goldNow)
			hApi.SyncLog(msg)
		end
		
		--加技能次数
		skillObj[4] = skillCountNow + 1
		
		--战车的流程，加交互事件次数
		for i = 1,#mapInfo.eventUnit do
			local tInfo = mapInfo.eventUnit[i]
			local nId = tInfo[1]		--单位ID
			local oUnit = tInfo[2]		--单位
			local nCount = tInfo[3]		--剩余触发次数
			if (oUnit == _oTarget) then --找到了
				tInfo[3] = nCount + 1
				break
			end
		end
		
		--改变建筑的使用次数的特殊处理事件
		if On_BuildingSkillCountChanged_Special_Event then
			--安全执行
			hpcall(On_BuildingSkillCountChanged_Special_Event, oPlayer, _oTarget, skillId)
			--On_BuildingSkillCountChanged_Special_Event(oPlayer, _oTarget, skillId)
		end
	end
end

--联机选择抽卡结果
hVar.CmdMgr[hVar.Operation.SelectDrawCardRet] = function(sessionId, oPlayer, auraId, auraLv, tacticNum, index, u_worldI)
	print("联机选择抽卡结果", sessionId, oPlayer, auraId, auraLv, tacticNum, index, u_worldI)
	local w = hGlobal.WORLD.LastWorldMap
	if w then
		local tabA = hVar.tab_aura[auraId]
		if tabA then
			local skill_id = tabA.skill
			local requireGold = tabA.crystal or 0
			--print(_nCurrentSelect,skill_id,lv,requireGold)
			local me = w:GetPlayerMe()
			if me then
				local goldNow = me:getresource(hVar.RESOURCE_TYPE.GOLD)
				if (goldNow >= requireGold) then
					local heros = me.heros
					local oHero = heros[1]
					if oHero then
						local oUnit = oHero:getunit()
						if oUnit then
							if (oUnit.data.IsDead ~= 1) then --活着的单位
								--扣除金币
								me:addresource(hVar.RESOURCE_TYPE.GOLD, -requireGold)
								--本地刷新界面
								hGlobal.event:event("Event_TacticCastCostRefresh")
								
								local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
								local gridX, gridY = w:xy2grid(targetX, targetY)
								local tCastParam =
								{
									level = auraLv, --等级
								}
								hApi.CastSkill(oUnit, skill_id, 0, 100, oUnit, gridX, gridY, tCastParam) --战车加血技能
								
								--统计雕像buff
								local tInfo = GameManager.GetGameInfo("auraInfo")
								
								--存储
								--local tData = {_nIndex, {id = auraId, lv = auraLv,}}
								--GameManager.SetGameInfo("auraInfo", {tData,})
								
								local tData = {id = auraId, lv = auraLv,}
								--table_print(tData)
								GameManager.AddGameInfo("auraInfo",tData) 
								hGlobal.event:event("LocalEvent_RefreshTacticsBuffIcon")
								
								--增加选卡次数
								local playerPos = oPlayer:getpos()
								if (w.data.endless_build_tactics[playerPos] == nil) then
									w.data.endless_build_tactics[playerPos] = {}
								end
								local tPlayerInfo = w.data.endless_build_tactics[playerPos]
								
								if tPlayerInfo[auraId] then
									tPlayerInfo[auraId] = tPlayerInfo[auraId] + 1
								else
									tPlayerInfo[auraId] = 1
								end
								--统计每波选的卡片
								if (tPlayerInfo.perWave == nil) then
									tPlayerInfo.perWave = {}
								end
								tPlayerInfo.perWave[#tPlayerInfo.perWave+1] = {id = auraId, lv = auraLv,}
								--print("统计每波选的卡片", #tPlayerInfo.perWave+1, auraId, auraLv)
								
								print("@@@@@@@@ 统计雕像buff", "playerPos="..playerPos, "wave="..(#tPlayerInfo.perWave), "id="..auraId, "lv="..auraLv)
								
								--触发事件
								local oUnit = hClass.unit:getChaByWorldI(u_worldI)
								local tParam = {index, oUnit,}
								hGlobal.event:event("LocalEvent_UseAuraBack", tParam)
								--return true
							end
						end
					end
				else --金币不足
					--[[
					local strText = hVar.tab_string["__TEXT_NoPlayerDisabelEnter"] --language
					hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "",
						lifetime = 1000,
						fadeout = -550,
						moveY = 32,
					}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
					]]
					hApi.NotEnoughResource("coin")
					
					--触发事件
					local oUnit = hClass.unit:getChaByWorldI(u_worldI)
					local tParam = {index, oUnit,}
					hGlobal.event:event("LocalEvent_CloseAuraBack", tParam)
					--return false
				end
			end
		end
	end
end
