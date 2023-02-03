--网络协发送处理
SendPvpCmdFunc = {}
local _ncf = SendPvpCmdFunc

--更新战斗配置
_ncf["heart"] = function()
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	send[3] = math.floor(os.clock() * 1000)			--pvp当前ping时间
	send[4] = g_lastDelay_pvp				--pvp当前延时
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_HEART, send)
end

--获取房间列表
_ncf["get_roomlist"] = function(rType)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()				--我使用角色rid
	send[3] = rType or 0					--取对应地图的房间列表
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_REFRESH_ROOM_LIST, send)
end

--获取房间摘要（参数：房间id列表）
_ncf["get_rooms_abstract"] = function(roomIdList)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()				--我使用角色rid
	if type(roomIdList) == "table" then
		send[3] = #roomIdList				--房间ID数量
		for i = 1, #roomIdList do
			send[3 + i] = roomIdList[i]		--房间ID
			--print("get_rooms_abstract", 3 + i, roomIdList[i])
		end
	elseif type(roomIdList) == "number" then
		send[3] = 1					--房间ID数量
		send[4] = roomIdList				--房间ID
	end
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_ROOMS_ABSTRACT, send)
end

--创建房间（参数：房间地图类型, 房间名）
_ncf["create_room"] = function(roomType, roomName, bUseEquip, bIsArena)
	local send = {}
	send[1] = xlPlayer_GetUID()				--房主uid
	send[2] = luaGetplayerDataID()				--房主使用角色rid
	send[3] = roomType or 1					--房间类型(根据房间类型选择配置信息)
	send[4] = roomName					--房间名字
	send[5] = 0						--是否使用装备
	if bUseEquip then
		send[5] = 1
	end
	send[6] = 0						--是否擂台
	if bIsArena then
		send[6] = 1
	end
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_CREATE_ROOM, send)
	--local send = {}
	--send[1] = hVar.PVP_OPR_TYPE.C2L_REQUIRE_CREATE_ROOM	--协议
	--send[2] = xlPlayer_GetUID()..";"..luaGetplayerDataID()..";"..(roomType or 1)..";"..roomName				--房主uid
	--Pvp_Server:Send(send)
end

--进入房间
_ncf["enter_room"] = function(roomId)
	local send = {}
	send[1] = xlPlayer_GetUID()				--房主uid
	send[2] = luaGetplayerDataID()				--房主使用角色rid
	send[3] = roomId					--房间ID
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_ENTER_ROOM, send)
end

--离开房间
_ncf["leave_room"] = function(roomId)
	local send = {}
	send[1] = xlPlayer_GetUID()				--房主uid
	send[2] = luaGetplayerDataID()				--房主使用角色rid
	send[3] = roomId					--房间ID
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_LEAVE_ROOM, send)
end

--房间中准备
_ncf["prepare_game"] = function(roomId, prepare)		--0 取消准备, 1 准备
	local send = {}
	send[1] = xlPlayer_GetUID()				--房主uid
	send[2] = luaGetplayerDataID()				--房主使用角色rid
	send[3] = roomId					--房间ID
	send[4] = prepare					--是否准备
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_PREPARE_GAME, send)
end

--房主开始游戏
_ncf["begin_game"] = function(roomId)
	local send = {}
	send[1] = xlPlayer_GetUID()				--房主uid
	send[2] = luaGetplayerDataID()				--房主使用角色rid
	send[3] = roomId					--房间ID
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_BEGIN_GAME, send)
end

--房间中换位子(参数:房间Id 老势力 老位置 新势力 新位置)(位置和势力都从1开始)
_ncf["change_room_pos"] = function(roomId, oldForce, oldPos, newForce, newPos)
	local send = {}
	send[1] = xlPlayer_GetUID()				--房主uid
	send[2] = luaGetplayerDataID()				--房主使用角色rid
	send[3] = roomId					--房间ID
	send[4] = oldForce					--老势力
	send[5] = oldPos					--老位置
	send[6] = newForce					--新势力
	send[7] = newPos					--新位置
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_CHANGE_POS, send)
end

--房间中换位子(参数:房间Id 势力 位置 新的位置类型)(位置和势力都从1开始)
_ncf["change_room_pos_type"] = function(roomId, force, pos, posType)
	local send = {}
	send[1] = xlPlayer_GetUID()				--房主uid
	send[2] = luaGetplayerDataID()				--房主使用角色rid
	send[3] = roomId					--房间ID
	send[4] = force						--需要调整类型的势力方
	send[5] = pos						--需要调整类型的位置
	send[6] = posType					--需要调整成xxx
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_CHANGE_POS_TYPE, send)
end

--修改房间游戏是否使用装备
_ncf["change_room_equip_flag"] = function(roomId, bUseEquip)
	local send = {}
	send[1] = xlPlayer_GetUID()				--房主uid
	send[2] = luaGetplayerDataID()				--房主使用角色rid
	send[3] = roomId					--房间ID
	send[4] = 0						--需要调整类型的势力方
	if bUseEquip then
		send[4] = 1
	end
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_CHANGE_EQUIP_FLAG, send)
end

--切换进游戏（这里以后会改造成先连gameserver）
_ncf["switch_game"] = function(sessionId)
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	send[3] = sessionId
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_LOAD_GAME, send)
end

--游戏加载完毕
_ncf["load_game_ok"] = function(sessionId)
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	send[3] = sessionId
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_LOAD_GAME_END, send)
end

--_ncf[hVar.PVP_OPR_TYPE.LOGIN] = function(uid,rid,mode,name)
--	local send = {}
--	send[1] = hVar.PVP_OPR_TYPE.REQUEST_SAVE
--	send[2] = 0
--	send[3] = uid
--	send[4] = rid
--	send[5] = mode		--首先获取 data
--	send[6] = name		--主公名字
--	Pvp_Server:Send(send)
--end

--发送cmd
_ncf["send_cmd"] = function(sessionId,tick,cmdType,sCmd)
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	send[3] = sessionId
	send[4] = tick
	send[5] = cmdType
	send[6] = sCmd
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_SEND_CMD, send)
end

--游戏结束(游戏局id, 游戏结果)
_ncf["game_end"] = function(sessionId, cResult)
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	send[3] = sessionId					--游戏局id
	send[4] = cResult					--游戏结果
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_GAME_END, send)
end

--玩家主动离开游戏(游戏局id, 游戏结果)
_ncf["leave_game"] = function(sessionId)
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	send[3] = sessionId					--游戏局id
	send[4] = tostring(strResult)				--游戏结果
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_LEAVE_GAME, send)
end

--更新战斗配置
_ncf["upload_battle_cfg"] = function(strCfg,cfgId)
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	send[3] = tostring(strCfg)				--战斗配置
	send[4] = cfgId or 1					--对应tab_room的typeid
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_UPLOAD_BATTLE_CFG, send)
end

--获取战斗配置
_ncf["get_battle_cfg"] = function(cfgId, udbid, rid)
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	if udbid and rid then
		send[1] = udbid					--玩家dbid
		send[2] = rid					--玩家使用角色rid
	end
	send[3] = cfgId or 1					--对应tab_room的typeid
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_GET_BATTLE_CFG, send)
end

--获取战绩信息
--_ncf["get_battle_score"] = function()
--	local send = {}
--	send[1] = xlPlayer_GetUID()				--玩家uid
--	send[2] = luaGetplayerDataID()				--玩家使用角色rid
--	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_GET_BATTLE_SCORE, send)
--end

--获取角色基本信息
_ncf["get_user_baseinfo"] = function()
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_USER_BASEINFO, send)
end

--debug
_ncf["gm_debug"] = function()
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_DEBUG, send)
end

--通知服务器确认兵符消耗
_ncf["pvpcoin_cost_ok"] = function(sessionId, tokenId)
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	send[3] = sessionId					--游戏局Id
	send[4] = tokenId					--兵符消耗token
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_PVPCOIN_COST_OK, send)
end

--每日领取兵符
_ncf["get_pvpcoin_everyday"] = function()
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_GET_PVPCOIN_EVERYDAY, send)
end

--购买兵符
_ncf["buy_pvpcoin"] = function()
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_BUY_PVPCOIN, send)
end

--上传不同步日志(游戏局, 当前第几个包, 包总长度, 包内容)
_ncf["uplade_outsync_log"] = function(session_dbId, packageTotalNum, packageNum, packageContent)
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	send[3] = session_dbId					--游戏局Id
	send[4] = packageTotalNum				--包的总数量
	send[5] = packageNum					--当前包的编号
	send[6] = packageContent				--当前包的内容
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_UPLOAD_OUTSYNC_LOG, send)
end

--上传不同步日志Ex(游戏局, 当前第几个包, 包总长度, 包内容)
_ncf["uplade_outsync_log_test"] = function(session_dbId, packageTotalNum, packageNum, packageContent)
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	send[3] = session_dbId					--游戏局Id
	send[4] = packageTotalNum				--包的总数量
	send[5] = packageNum					--当前包的编号
	send[6] = packageContent				--当前包的内容
	Pvp_Server:SendEx(hVar.PVP_OPR_TYPE.C2L_REQUIRE_UPLOAD_OUTSYNC_LOG, send)
end

--获取竞技场宝箱（免费宝箱 chestpos传0）
_ncf["reward_pvp_chest"] = function(chestpos)
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	send[3] = chestpos
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_REWARD_PVP_CHEST, send)
end

--打开竞技场宝箱（免费宝箱 chestpos传0）
_ncf["open_pvp_chest"] = function(chestpos)
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	send[3] = chestpos
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_OPEN_PVP_CHEST, send)
end

--英雄升星
_ncf["hero_star_lvup"] = function(heroId)
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	send[3] = heroId					--英雄id
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_HERO_STAR_LVUP, send)
end

--英雄解锁
_ncf["hero_unlock"] = function(heroId)
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	send[3] = heroId					--英雄id
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_HERO_UNLOCK, send)
end

--提交我自己的战斗英雄，塔，兵种卡使用情况
_ncf["upload_my_battle_info"] = function(battlecfg,tHero,tTower,tTactic)
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	
	send[3] = ""
	if battlecfg.herocard and type(battlecfg.herocard) == "table" then
		for i = 1, #battlecfg.herocard do
			local tHeroCard = battlecfg.herocard[i]
			local heroId = tHeroCard.id
			send[3] = send[3] .. heroId
			if i < #battlecfg.herocard then
				send[3] = send[3] .. ","
			end
		end
	end
	
	send[4] = ""
	if battlecfg.towercard and type(battlecfg.towercard) == "table" then
		for i = 1, #battlecfg.towercard do
			local tTower = battlecfg.towercard[i]
			local id = tTower[1]
			
			send[4] = send[4] .. id
			if i < #battlecfg.towercard then
				send[4] = send[4] .. ","
			end
		end
	end
	send[5] = ""
	if battlecfg.tacticcard and type(battlecfg.tacticcard) == "table" then
		for i = 1, #battlecfg.tacticcard do
			local tTactic = battlecfg.tacticcard[i]
			local id = tTactic[1]
			
			send[5] = send[5] .. id
			if i < #battlecfg.tacticcard then
				send[5] = send[5] .. ","
			end
		end
	end
	
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_UPLOAD_BATTLE_INFO, send)
end

--获取热门卡牌
_ncf["get_battle_statistics"] = function()
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_GET_BATTLE_STATISTICS, send)
end

--兵种卡升级
_ncf["army_lvup"] = function(tacticId)
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	send[3] = tacticId					--英雄id
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_ARMY_LVUP, send)
end

--刷新战术卡附加属性
_ncf["refresh_tactic_addones"] = function(tacticId,addonesIdx)
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	send[3] = tacticId					--英雄id
	send[4] = addonesIdx
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_ARMY_REFRESH_ADDONES, send)
end

--新增战术卡附加属性
_ncf["new_tactic_addones"] = function(tacticId)
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	send[3] = tacticId					--英雄id
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_ARMY_NEW_ADDONES, send)
end

--还原战术卡附加属性
_ncf["restore_tactic_addones"] = function(tacticId,addonesIdx)
	local send = {}
	send[1] = xlPlayer_GetUID()				--玩家uid
	send[2] = luaGetplayerDataID()				--玩家使用角色rid
	send[3] = tacticId					--英雄id
	send[4] = addonesIdx
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_ARMY_RESTORE_ADDONES, send)
end

--获取匹配房间列表
_ncf["get_matchlist"] = function()
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()				--我使用角色rid
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_REFRESH_MATCH_LIST, send)
end

--开始匹配
_ncf["begin_match"] = function(matchId)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()				--我使用角色rid
	send[3] = matchId					--匹配房间id
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_BEGIN_MATCH, send)
end

--取消匹配
_ncf["cancel_match"] = function(matchId)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()				--我使用角色rid
	send[3] = matchId					--匹配房间id
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_CANCEL_MATCH, send)
end

--告诉服务器需要刷新数据
_ncf["refresh_userinfo_fromdb"] = function()
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()				--我使用角色rid
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_REFRESH_DBINFO, send)
end

--获取当前房间开放时间段
_ncf["get_room_open_time"] = function(roomCfgId)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()				--我使用角色rid
	send[3] = roomCfgId or 0
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_ROOM_OPEN_TIME, send)
end

--获取铜雀台配置信息(参数:是否刷新次数)
_ncf["get_pve_multi_cfg"] = function(refreshFlag)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()				--我使用角色rid
	send[3] = 0
	if refreshFlag then
		send[3] = 1
	end
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_GET_PVE_MULTI_CFG, send)
end

--获取铜雀台的排行榜
--firstIdx: 初始条目索引（第一个索引是0）
--num: 从初始索引开始显示几个条目（最大支持一次取20条）
_ncf["get_pve_multi_log"] = function(firstIdx, num)
	local send = {}
	send[1] = xlPlayer_GetUID()				--我的uid
	send[2] = luaGetplayerDataID()				--我使用角色rid
	send[3] = firstIdx or 0					--初始条目索引（第一个索引是0）
	send[4] = num or 20					--从初始索引开始显示几个条目
	Pvp_Server:Send(hVar.PVP_OPR_TYPE.C2L_REQUIRE_GET_PVE_MULTI_LOG, send)
end