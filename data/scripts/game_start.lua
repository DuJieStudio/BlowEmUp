--@hGlobal.WORLD.LastWorldMap	每次游戏局只有一个的大地图
--@hGlobal.LocalPlayer		本地玩家，必须有

hGlobal.WORLD_INIT_SUCESS = 1 --世界初始化开始
------------------
-- 脚本开始工作了(main)

--创造一个空白的世界，关闭UI用


if xlAddAppleProductIdentifier then
	local iChannelId = xlGetChannelId()
	if iChannelId < 100 then
		--ios 连接安卓服务器 才需要赋值g_ios_receipt_server  不然绝对不要赋值
		g_ios_receipt_server = "http://139.196.204.222/ad/index.php/tk_ios/click"
		--xlAddAppleProductIdentifier("tier01.ab.xingames.com")
		--xlAddAppleProductIdentifier("tier02.ab.xingames.com")
		--xlAddAppleProductIdentifier("tier01.ab_gift01.xingames.com")
		xlAddAppleProductIdentifier("tier01.yellowstone.aliensmash") --6
		xlAddAppleProductIdentifier("tier05.yellowstone.aliensmash") --30
		xlAddAppleProductIdentifier("tier10.yellowstone.aliensmash") --68
		xlAddAppleProductIdentifier("tier20.yellowstone.aliensmash") --128
		xlAddAppleProductIdentifier("tier50.yellowstone.aliensmash") --328
		xlAddAppleProductIdentifier("tier60.yellowstone.aliensmash") --648
		--
		xlAddAppleProductIdentifier("tier01.giftpack.aliensmash") --6
		xlAddAppleProductIdentifier("tier02.giftpack.aliensmash") --12
		xlAddAppleProductIdentifier("tier04.giftpack.aliensmash") --25
		xlAddAppleProductIdentifier("tier07.giftpack.aliensmash") --45
		xlAddAppleProductIdentifier("tier15.giftpack.aliensmash") --98
		xlAddAppleProductIdentifier("tier30.giftpack.aliensmash") --198
	end
end

function map_setting(map_name)
	--在创建世界之前调用此函数，初始化玩家资源，结盟信息
	hClass.player:enum(function(p)
		p:cleardata()
	end)
	--hGlobal.NeutralPlayer = hGlobal.player[0]
	hGlobal.player[0].data.IsAIPlayer = 0				--玩家0野怪
	hGlobal.LocalPlayer = hGlobal.player[1]
	hGlobal.player[1].data.IsAIPlayer = 0				--玩家1是本地玩家，不是AI
	hGlobal.player[1]:setlocalplayer(1)
	for i = 2,hVar.MAX_PLAYER_NUM do
		hGlobal.player[i]:setlocalplayer(0)			--恢复ai玩家的状态
	end
	--设置基本的盟友关系
	hGlobal.player[1]:setally(hGlobal.player[8])			--玩家1和8结盟(AI)，这样可以对话
	for i = 1,8 do
		hGlobal.player[9]:setally(hGlobal.player[i])		--玩家9和所有玩家结盟(傻子)，这样可以对话
	end
	for i = 2,8 do
		hGlobal.player[i].data.IsAIPlayer = 1			--2~8号玩家是AI，会自主行动
	end
	hGlobal.player[9].data.IsAIPlayer = 0				--不是AI
end

--新开地图或者读取地图时加载新手提示
hGlobal.event:listen("Event_WorldCreated","__WM_InitNoobHint",function(oWorld,IsCreatedFromLoad)
	if oWorld.data.type ~= "worldmap" then
		--初始化新手提示
		hApi.InitNoobTip(oWorld.data.map,IsCreatedFromLoad)
	end
	
	--如果是大厅主界面
	if oWorld.data.map == hVar.PHONE_MAINMENU then
		local nIndex = 1 --是否点击过选择关卡
		if LuaGetPlayerGuideState(g_curPlayerName,hVar.PHONE_MAINMENU,nIndex)~=1 then
			oWorld:enumunit(function(eu)
				--选择关卡的建筑
				if hVar.tab_unit[eu.data.id].interaction[1] == hVar.INTERACTION_TYPE.PHONE_SELECTLEVEL then
					if eu.chaUI["UDaction"] == nil then
						eu.chaUI["UDaction"] = hUI.thumbImage:new({
							parent = eu.handle._n,
							y = 10,
							model = "Action:updown",
							animation = "updown",
						})
					end
				end
			end)
		end
	end
end)

--{木头,粮食,石头,钢铁,水晶,金钱}
local MAP_DEFAULT_RESOURCE_TYPE = {
	hVar.RESOURCE_TYPE.WOOD,
	hVar.RESOURCE_TYPE.FOOD,
	hVar.RESOURCE_TYPE.STONE,
	hVar.RESOURCE_TYPE.LIFE,
	hVar.RESOURCE_TYPE.CRYSTAL,
	hVar.RESOURCE_TYPE.GOLD,
}
local MAP_DEFAULT_RESOURCE = {
	["__DEFAULT__"] = {20,1000,20,10,0,10000},
	["world/level_tyjy"] = {0,0,40,0,0,0},
	["world/level_ccjq"] = {0,0,0,0,0,0},
	["world/level_swbh"] = {50,1000,50,10,0,10000},
	["world/level_bhzw"] = {50,2000,50,15,0,20000},
	["world/level_hmzl"] = {40,1500,40,20,0,15000},
	["world/level_hj12g"] = {300,3000,0,0,0,20000},
	["world/level_acsj"] = {20,2000,20,10,0,20000},
	["world/level_mrxj"] = {0,0,0,0,0,0},
}

local GiveResource = function(oPlayer,tResource)
	if type(tResource)=="table" then
		for i = 1,#tResource do
			if MAP_DEFAULT_RESOURCE_TYPE[i] and tResource[i]~=0 and type(tResource[i])=="number" then
				oPlayer:addresource(MAP_DEFAULT_RESOURCE_TYPE[i],tResource[i])
			end
		end
	end
end

--检测地图是否名字存在 返回1 存在 返回0 不存在
local _checkMapName = function(mapName,tab)
	for i = 1,#tab do
		if tab[i] == mapName then
			return 1
		end
	end
	return 0
end

--td第一关创建剧情对话
function _tdFirstMapStory()
	local oWorld = hGlobal.WORLD.LastWorldMap
	local mapInfo = oWorld.data.tdMapInfo
	local tHeroAllList = {}
	local tTacticAllList = {}
	
	if mapInfo then
		--难度控制战术技能卡
		if mapInfo.mapMode == hVar.MAP_TD_TYPE.DIFFICULT or mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS then
			local diffTactic = mapInfo.diffTactic or {}
			for i = 1, #diffTactic do
				local add = diffTactic[i] or {}
				if add and type(add) == "table" then
					local id = add[1] or 0
					local lv = add[2] or 1
					if id > 0 then
						--战术技能卡对话结束后跟选择的一起出
						tTacticAllList[#tTacticAllList + 1] = {id, lv, 0}
					end
				end
			end
		end
	end
	
	--添加玩家选好的英雄
	local _addHeroList = function(tHeroList)
		if #tHeroList==0 then
			return
		end
		
		--local bornPoint = mapInfo.heroBornPoint
		--if not bornPoint then
		--	return
		--end
		
		--重新创建所有玩家的英雄
		local tempWorldParam = {}
		local worldScene = oWorld.handle.worldScene
		
		for i = 1,#tHeroList do
			local id = tHeroList[i].id --单位类型id
			local nOwner = tHeroList[i].owner or oWorld:GetPlayerMe():getpos()
			local owner = oWorld:GetPlayer(nOwner)
			local god = owner:getgod()
			
			--添加单位
			--读取单位的等级
			local HeroCard = hApi.GetHeroCardById(id)
			local cardLv = 1 --英雄的等级
			local cardStar = 1 --英雄星级
			if HeroCard then
				if HeroCard.attr then
					cardLv = HeroCard.attr.level or 1
					cardStar = HeroCard.attr.star or 1
				end
			end
			local nLv = tHeroList[i].lv or cardLv
			local nStar = tHeroList[i].star or cardStar
			
			--创建单位
			local radius = 60
			local dx = oWorld:random(-radius, radius) --随机偏移值
			local dy = oWorld:random(-radius, radius)
			local randPosX, randPosY = god:getXY()
			randPosX = randPosX + dx --随机x位置
			randPosY = randPosY + dy --随机y位置
			--god.data.facing
			local oUnit = oWorld:addunit(id, nOwner, nil ,nil, god.data.facing, randPosX, randPosY, nil, nil, nLv, nStar)
			
			if oUnit then
				local oHero = owner:createhero(id, HeroCard)
				oHero:bind(oUnit)
				hGlobal.event:call("Event_UnitBorn", oUnit)
			end
		end
		
		--select_end()
	end
	
	local _func = function()
		
		--剧情出英雄和战术技能卡
		local firstBeginAdd = mapInfo.firstBeginAdd or {}
		for i = 1, #firstBeginAdd do
			local add = firstBeginAdd[i] or {}
			if add and type(add) == "table" then
				local nType = add[1] or 0
				local id = add[2] or 0
				local lv = add[3] or 1
				local owner = add[4] or 1
				local star = add[5] or 1
				if id > 0 then
					if (nType == 1) then --战术技能卡
						--战术技能卡对话结束后跟选择的一起出
						tTacticAllList[#tTacticAllList + 1] = {id, lv, 0}
					elseif (nType == 2) then --英雄
						--英雄对话前直接出
						--_addHeroList({{id = id, lv = lv, owner = owner}})
						
						--英雄对话结束后出
						tHeroAllList[#tHeroAllList + 1] = {id = id, lv = lv, owner = owner, star = star}
						
						--英雄战术技能
						local tactics = hApi.GetHeroTactic(id)
						for i = 1, #tactics do
							local tactic = tactics[i]
							if tactic then
								local tacticId = tactic.id or 0
								local tacticLv = tactic.lv or 1
								if tacticId > 0 and tacticLv > 0 then
									tTacticAllList[#tTacticAllList + 1] = {tacticId, tacticLv, id} --geyachao:标识此战术卡属于哪个英雄
									--print("tacticId, tacticLv",tacticId, tacticLv)
								end
							end
						end
					end
				end
			end
		end
		
		local selectedHeroList = oWorld.data.selectedHeroList
		
		--先添加剧情英雄
		_addHeroList(tHeroAllList)
		
		--统计: 本局所选的英雄（剧情）
		for i = 1, #tHeroAllList, 1 do
			local typeId_Story = tHeroAllList[i].id
			local HeroCard = hApi.GetHeroCardById(typeId_Story)
			if (HeroCard) then
				table.insert(selectedHeroList, typeId_Story) --剧情添加的英雄，如果存在战术技能卡，那么最后也加经验
			end
		end
		
		--创建战术技能卡
		--oWorld:settactics(1, tTacticAllList)
		if oWorld then
			--剧情英雄战术技能由上帝来处理
			if oWorld:GetPlayerMe() then
				oWorld:settactics(oWorld:GetPlayerMe(), tTacticAllList)
			end
			
			--战术技能卡资源生效
			oWorld:tacticsTakeEffect(nil)
			--战术技能卡对地图已有角色生效
			oWorld:enumunit(function(u)
				oWorld:tacticsTakeEffect(u)
			end)
		end
		
		
		--创建引导第一关的界面
		--CreateGuideFrame_Map001()
		
		--呼出战术技能卡界面
		--hGlobal.event:event("Event_TacticsInit")
		
		--触发引导
		hGlobal.event:event("LocalEvent_EnterGuideProgress", oWorld.data.map, oWorld, "world", 1)
		
		--触发游戏开始
		hGlobal.event:call("LocalEvent_TDGameBegin", oWorld.data.map, oWorld)
		
	end
	
	--local vTalk = hApi.InitUnitTalk(mapInfo.godUnit,mapInfo.godUnit,nil,"mapBegin")
	local vTalk = hApi.InitUnitTalk(oWorld:GetPlayerGod():getgod(), oWorld:GetPlayerGod():getgod(), nil, "mapBegin")
	if vTalk then
		
		hApi.CreateUnitTalk(vTalk,function()
			if _func and type(_func) == "function" then
				_func()
			end
		end)
	else
		if _func and type(_func) == "function" then
			_func()
		end
	end
end

--wdldHeroId = {}--我的领地里的英雄
function map_start()
	--hVar.SCEOBJ_MAX_NUM = 0
	if hGlobal.WORLD.LastWorldMap==nil then
		print("世界地图没有被加载，所以什么都没有")
		return
	end
	
	
	local oWorld = hGlobal.WORLD.LastWorldMap
	local map_name = oWorld.data.map
	
	--g_Game_Agent.init(g_Game_Core.Mode_TypeDef.Local)
	oWorld:getplayerlog(hGlobal.LocalPlayer.data.playerId,"Init")	--允许本地玩家战斗结束后计算积分
	
	--如果是TD地图数据初始化
	--if  g_editor ~= 1 and hVar.MAP_INFO[oWorld.data.map] and hVar.MAP_INFO[oWorld.data.map].mapType and hVar.MAP_INFO[oWorld.data.map].mapType == 4 then
	if  g_editor ~= 1 then
		
		--zhenkira 2016.3.24
		--hGlobal.event:listen("LocalEvent_TDGameBegin", "TD", function(mapName, w)
		--	local mapInfo = w.data.tdMapInfo
		--	
		--	if mapInfo.mapMode == hVar.MAP_TD_TYPE.NORMAL then
		--	elseif mapInfo.mapMode == hVar.MAP_TD_TYPE.DIFFICULT then
		--	elseif mapInfo.mapMpde == hVar.MAP_TD_TYPE.ENDLESS then
		--	elseif mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP then
		--		
		--		--随机造塔--
		--			
		--		--随机一组塔信息
		--		local rt = hApi.random(1, #mapInfo.towerSet)
		--		local towerInfo = mapInfo.towerSet[rt]
		--		--遍历塔信息，进行添加
		--		for i = 1, #towerInfo do
		--			local unitId = towerInfo[i]
		--			--添加角色
		--			local oUnit = w:addunit(unitId,22,nil,nil,0,mapInfo.towerPos[i].x,mapInfo.towerPos[i].y,nil,nil)
		--			if oUnit then
		--				--设置角色AI状态
		--				oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
		--				--zhenkira 角色出生事件，会在这里面做邪恶的事情（游戏局角色会对该角色使用战术技能卡）
		--				hGlobal.event:call("Event_UnitBorn",oUnit)
		--			end
		--		end
		--		
		--		--zhenkira pvpui pvp倒计时
		--		--初始化游戏开始时间
		--		mapInfo.gameTimeLimit = 180000 + w:gametime()
		--		
		--		--开始出兵
		--		--出兵事件
		--		hGlobal.event:event("LocalEvent_TD_NextWave", true)
		--		
		--		--5秒后出兵
		--		hApi.addTimerOnce("PVPBegin", 5000, function()
		--			
		--			--随机出英雄--
		--			
		--			--随机一组英雄信息
		--			local rh = hApi.random(1, #mapInfo.heroSet)
		--			local heroInfo = mapInfo.heroSet[rh]
		--			
		--			local targetAngleOrigin = {0, 72, 144, 216, 288} --目标的坐标偏移角度列表（用于随机位置）
		--			local targetAngle = {} --目标的坐标偏移角度列表
		--			
		--			for i = 1, #heroInfo do
		--				local unitId = heroInfo[i]
		--				
		--				--添加角色
		--				local birthPos = mapInfo.heroBirthPos[2]
		--				
		--				--创建单位
		--				if (#targetAngle == 0) then --避免随不到
		--					for i = 1, #targetAngleOrigin, 1 do
		--						table.insert(targetAngle, targetAngleOrigin[i])
		--					end
		--				end
		--				--unitId ,owner, gridX, gridY, facing, worldX, worldY, attr, data, lv
		--				local radius = 30
		--				local randAngleIdx = w:random(1, #targetAngle) --随机偏移角度索引值
		--				local angle = targetAngle[randAngleIdx] --随机角度
		--				table.remove(targetAngle, randAngleIdx)
		--				local fangle = angle * math.pi / 180 --弧度制
		--				local dx = radius * math.cos(fangle) --随机偏移值x
		--				local dy = radius * math.sin(fangle) --随机偏移值y
		--				local randPosX = birthPos.x + dx --随机x位置
		--				local randPosY = birthPos.y + dy --随机y位置
		--				randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 30)
		--				
		--				local oUnit = w:addunit(unitId,22,nil,nil,0,randPosX,randPosY,nil,nil)
		--				if oUnit then
		--					--设置敌方角色AI状态
		--					oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
		--					
		--					--随机的路点
		--					local randIdx = hApi.random(1, #mapInfo.heroRandomRoad)
		--					local rR = mapInfo.heroRandomRoad[randIdx]
		--					local rd = {}
		--					for i = 1, #rR, 1 do
		--						table.insert(rd , {x = rR[i].x, y = rR[i].y, isHide = rR[i].isHide})
		--					end
		--					
		--					--设置敌方角色的路点
		--					oUnit:setRoadPoint(rd)
		--					
		--					--geyachao: 临时处理，为了能让敌方英雄复活，为敌方英雄单位添加oHero对象
		--					local oHero = hClass.hero:new(
		--					{
		--						name = hVar.tab_stringU[unitId][1],
		--						id = unitId,
		--						owner = 2,
		--						unit = oUnit,
		--						playmode = oWorld.data.playmode,
		--						--HeroCard = 0, --geyachao: 是英雄，这里要标记为0
		--					})
		--					
		--					--oHero:LoadHeroFromCard() --读取道具附加属性
		--					
		--					--zhenkira 角色出生事件，会在这里面做邪恶的事情（游戏局角色会对该角色使用战术技能卡）
		--					hGlobal.event:call("Event_UnitBorn", oUnit)
		--				end
		--			end
		--		end)
		--	end
		--end)
		
		--注册程序进程隐藏时的处理
		hGlobal.event:listen("LocalEvent_AppEnterBackground", "TD", function(flag)
			--print("注册程序进程隐藏时的处理", flag)
			--进入后台
			if (flag == 1) then
				--地图胜利/失败的状态下点不到这些按钮
				local w = hGlobal.WORLD.LastWorldMap
				--if w and (w.data.PausedByWhat=="Victory" or w.data.PausedByWhat=="Defeat") then
				--	return
				--end
				
				if w then
					local mapInfo = w.data.tdMapInfo
					if mapInfo then
						--游戏结束或者已经暂停(结束)则不处理后续流程
						if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
							return
						end
						
						--PVP模式，不处理
						if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
							return
						end
						
						--新手地图模式，不处理
						if (mapInfo.mapMode == hVar.MAP_TD_TYPE.NEWGUIDE) then
							return
						end
						
						--大菠萝，配置界面
						if (mapInfo.mapMode == hVar.MAP_TD_TYPE.TANKCONFIG) then
							--hGlobal.event:event("LocalEvent_ShowMainBaseSetFrm")
							if mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE then
								--w:pause(0)
								--mapInfo.mapState = mapInfo.mapLastState
								--mapInfo.mapLastState = hVar.MAP_TD_STATE.IDLE
							else
								--暂停
								hGlobal.event:event("Event_StartPauseSwitch", true)
							end
							
							--重置虚拟按钮
							hGlobal.event:event("Event_ResetVitrualController")
							
							return
						end
						
						if (hVar.IS_IN_GUIDE_STATE == 1) then --在引导过程中恢复，直接继续
							hApi.clearTimer("showsetfrmlater")
							hGlobal.event:event("Event_StartPauseSwitch", false)
						else --正常游戏中，恢复时，弹暂停界面
							--if g_canSpinScreen == 1 then
							--	hApi.addTimerOnce("showsetfrmlater",500,function()
							--		hGlobal.event:event("LocalEvent_ShowSystemMenuIntegrateFrm")
							--	end)
							--end
							
							hGlobal.event:event("Event_StartPauseSwitch", true)
							--重置虚拟按钮
							hGlobal.event:event("Event_ResetVitrualController")
						end
					end
				end
			end
			
			--恢复游戏
			if (flag == 0) then
				--地图胜利/失败的状态下点不到这些按钮
				local w = hGlobal.WORLD.LastWorldMap
				--if w and (w.data.PausedByWhat=="Victory" or w.data.PausedByWhat=="Defeat") then
				--	return
				--end
				
				if w then
					local mapInfo = w.data.tdMapInfo
					if mapInfo then
						--大菠萝，配置界面
						if (mapInfo.mapMode == hVar.MAP_TD_TYPE.TANKCONFIG) then
							--hGlobal.event:event("LocalEvent_ShowMainBaseSetFrm")
							if mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE then
								--恢复
								hGlobal.event:event("Event_StartPauseSwitch", false)
								hGlobal.event:event("CloseSystemMenuIntegrateFrm")
							else
								--暂停
							end
						elseif (w.data.map == hVar.LoginMap) then --启动地图
							--hGlobal.event:event("LocalEvent_ShowMainBaseSetFrm")
							if mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE then
								--恢复
								hGlobal.event:event("Event_StartPauseSwitch", false)
								hGlobal.event:event("CloseSystemMenuIntegrateFrm")
							else
								--暂停
							end
						else
							if mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE then
								if g_canSpinScreen == 1 then
									--等于1时不用设置界面卡玩家 如有需要在这些情况下赋值
									if g_DisableShowOption == 0 then
										hApi.addTimerOnce("PAUSEtoshowSetfrm",100,function()
											hGlobal.event:event("LocalEvent_ShowSystemMenuIntegrateFrm")
										end)
									else
										--购买复活的时候有界面控制游戏是否暂停 不能恢复
										if g_BuyLifeState == 0 then
											hGlobal.event:event("Event_StartPauseSwitch", false)
										end
										hGlobal.event:event("CloseSystemMenuIntegrateFrm")
									end
								end
							else
								
							end
						end
					end
				end
			end
		end)
		
		--监听：重置虚拟按钮
		hGlobal.event:listen("Event_ResetVitrualController","TD",function()
			local w = hGlobal.WORLD.LastWorldMap
			if w then
				local vc = hGlobal.WORLD.VitrualController
				if vc then
					vc:_rightdeactive()
					vc:_deactive()
				end
			end
		end)
		
		--监听：角色受到伤害事件，更新血条、数字血量、大菠萝箱子特效
		hGlobal.event:listen("Event_UnitDamaged", "TD_Unit_Damged_HpBar", function(oDmgUnit, skillId, mode, dmg, nLost, oAttacker, nAbsorb, oAttackerSide, oAttackerPos)
			--print(oDmgUnit.data.name, oDmgUnit.attr.hp, oDmgUnit:GetHpMax(), oAttacker.data.name)
			--更新血条
			if oDmgUnit.chaUI["hpBar"] then
				local hpMax = oDmgUnit:GetHpMax()
				if (hpMax <= 0) then
					hpMax = 1
				end
				oDmgUnit.chaUI["hpBar"]:setV(oDmgUnit.attr.hp, hpMax)
				--print("oDmgUnit.chaUI1()", oDmgUnit.attr.hp, hpMax)
				
				--飞机第2关障碍物，显示倒计时
				if (oDmgUnit.data.id == 5209) then
					if oDmgUnit.chaUI["hpBar_cdvalue"] then
						local progress = math.ceil(oDmgUnit.attr.hp /hpMax * 100)
						oDmgUnit.chaUI["hpBar_cdvalue"]:setText(progress)
					end
				end
			end
			
			--更新数字血量
			if oDmgUnit.chaUI["numberBar"] then
				local hpMax = oDmgUnit:GetHpMax()
				if (hpMax <= 0) then
					hpMax = 1
				end
				oDmgUnit.chaUI["numberBar"]:setText(oDmgUnit.attr.hp .. "/" .. hpMax)
			end
			
			--播放特效
			if (oDmgUnit.data.id == 11009) then --箱子
				local ex, ey = hApi.chaGetPos(oDmgUnit.handle) --攻击者的坐标
				local ebx, eby, ebw, ebh = oDmgUnit:getbox() --攻击者的包围盒
				local ecenter_x = ex + (ebx + ebw / 2) --攻击者的中心点x位置
				local ecenter_y = ey + (eby + ebh / 2) --攻击者的中心点y位置
				local eff = oDmgUnit:getworld():addeffect(3038, 1.0 ,nil, ecenter_x, ecenter_y) --56
				
				--重置z值
				eff.handle._n:getParent():reorderChild(eff.handle._n, 10000)
			end
			
			--战车变红再变回
			--[[
			if (oDmgUnit.data.id == hVar.MY_TANK_ID) then
				if (dmg > 0) then
					--停掉之前的动画
					local color = oDmgUnit.data.color
					if color and (type(color) == "table") then
						if (color[1] ~= 254) and (color[2] ~= 254) and (color[3] ~= 254) then
							oDmgUnit.handle.s:setColor(ccc3(254, 254, 254))
							oDmgUnit.handle.s:stopAllActions()
							print("停掉动作")
						end
						
						color[1] = 0
						color[2] = 0
						color[3] = 0
						
						--颜色渐变
						local act1 = CCEaseSineOut:create(CCTintTo:create(0.15, 255, 0, 0)) --参数: t, radius, deltaRadius, angleZ, deltaAngleZ, angleX, deltaAngleX
						local act2 = CCEaseSineIn:create(CCTintTo:create(0.15, 254, 254, 254)) --参数: t, radius, deltaRadius, angleZ, deltaAngleZ, angleX, deltaAngleX
						local act3 = CCCallFunc:create(function()
							local color = oDmgUnit.data.color
							if color and (type(color) == "table") then
								color[1] = 254
								color[2] = 254
								color[3] = 254
								print("完成动作")
							end
						end)
						local a = CCArray:create()
						a:addObject(act1)
						a:addObject(act2)
						a:addObject(act3)
						local sequence = CCSequence:create(a)
						oDmgUnit.handle.s:runAction(sequence)
						print("开始动作")
					end
				end
			end
			]]
			
			--单位受击变色
			if (dmg > 0) then
				--标记正向变色
				oDmgUnit.data.colorInRender = 1
			end
			
			--可破坏物件、可破坏房子，不变色
			if (oDmgUnit.data.type == hVar.UNIT_TYPE.UNITBROKEN) or (oDmgUnit.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE) or (oDmgUnit.data.type == hVar.UNIT_TYPE.UNITDOOR) then
				oDmgUnit.data.colorInRender = 0
			end
			
			--可破坏物件、可破坏房子变模型
			if (oDmgUnit.data.type == hVar.UNIT_TYPE.UNITBROKEN) or (oDmgUnit.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE) or (oDmgUnit.data.type == hVar.UNIT_TYPE.UNITDOOR) then
				if (dmg > 0) then
					--[[
					local hp = oDmgUnit.attr.hp --当前血量
					local hp_before = hp + dmg
					local hp_max = oDmgUnit:GetHpMax() --最大血量
					if (hp < hp_max/2) and (hp_before >= hp_max/2) then
						--变模型
						local tabU = hVar.tab_unit[oDmgUnit.data.id]
						oDmgUnit.handle.__UnitModelName = tabU.model2
						oDmgUnit:initmodel()
					end
					]]
					local hp = oDmgUnit.attr.hp --当前血量
					local hp_max = oDmgUnit:GetHpMax() --最大血量
					if (hp > 0) then
						local percent = hp / hp_max * hVar.UNITBROKEN_DEADCOUNT --?/N
						local idx = math.ceil(hVar.UNITBROKEN_DEADCOUNT - percent)
						local tabU = hVar.tab_unit[oDmgUnit.data.id]
						local model2 = tabU.model2
						local lastmodel = oDmgUnit.handle.__UnitModelName
						local currentmodel = nil
						if (type(model2) == "string") then
							currentmodel = model2
						elseif (type(model2) == "table") then
							currentmodel = model2[idx] or model2[#model2]
						end
						if currentmodel then
							if (currentmodel ~= lastmodel) then
								--变模型
								--print("变模型")
								oDmgUnit.handle.__UnitModelName = currentmodel
								oDmgUnit:initmodel()
							end
						end
					end
				end
			end
			
			--更新存储的宠物血量
			if (oDmgUnit == oDmgUnit:getworld().data.follow_pet_unit) then
				local hp = oDmgUnit.attr.hp --当前血量
				local hp_max = oDmgUnit:GetHpMax() --最大血量
				local percent = math.ceil(hp / hp_max * 100)
				
				--宠物继承之前关卡的血量
				local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
				local nStage = tInfo.stage or 1 --本关id
				if (tInfo.stageInfo == nil) then
					tInfo.stageInfo = {}
				end
				if (tInfo.stageInfo[nStage] == nil) then
					tInfo.stageInfo[nStage] = {}
				end
				
				--本关地图内宠物血量百分比
				tInfo.stageInfo[nStage]["petHpPercent"] = percent
			end
			
			--我的战车，记录本局受到的伤害
			if (oDmgUnit.data.id == hVar.MY_TANK_ID) then
				if (dmg > 0) then
					local oWorld = hGlobal.WORLD.LastWorldMap
					oWorld.data.statistics_dmg_hurt = oWorld.data.statistics_dmg_hurt + dmg
				end
			end
		end)
		
		--监听：角色受到伤害事件，攻击者吸血
		hGlobal.event:listen("Event_UnitDamaged", "TD_Unit_Damged_SuckBlood", function(oDmgUnit, skillId, mode, dmg, nLost, oAttacker, nAbsorb, oAttackerSide, oAttackerPos)
			--受伤的人存在，攻击者存在并且活着
			if oDmgUnit and oAttacker and (oAttacker.data.IsDead ~= 1) then
				--存在技能
				if skillId and (skillId > 0) then
					--伤害大于0
					if (dmg > 0) then
						--受伤的人是英雄或小兵
						if (oDmgUnit.data.type == hVar.UNIT_TYPE.UNIT) or (oDmgUnit.data.type == hVar.UNIT_TYPE.HERO) then
							--检测本技能是否是攻击者的普通攻击
							local normalAtkSkillId = oAttacker.attr.attack[1]
							if (normalAtkSkillId == skillId) then
								local suckBolldRate = oAttacker:GetSuckBloodRate() --吸血率
								if (suckBolldRate > 0) then
									--计算本次的吸血值
									local addHp = math.floor(suckBolldRate * dmg / 100)
									if (addHp > 0) then
										--给攻击者回血
										--如果攻击者当前不是满血状态
										local hp = oAttacker.attr.hp --当前血量
										local hp_max = oAttacker:GetHpMax() --最大血量
										
										if (hp < hp_max) then --血未回满
											--检测是否回满血
											local new_hp = hp + addHp
											if (new_hp > hp_max) then
												--当前血量为最大血量
												new_hp = hp_max
											end
											
											--标记新的血量
											oAttacker.attr.hp = new_hp
											
											--更新英雄头像的血条(+)
											local oHero = oAttacker:gethero()
											if oHero and oHero.heroUI and oHero.heroUI["hpBar_green"] then
												local curP = oUnit.attr.hp
												local maxP = oUnit:GetHpMax()
												local precent = math.ceil(curP / maxP * 100)
												--print("precent=", precent)
												
												--设置大菠萝的血条
												SetHeroHpBarPercent(oHero, curP, maxP, true)
											end
											
											--更新血条控件
											if oAttacker.chaUI["hpBar"] then
												oAttacker.chaUI["hpBar"]:setV(new_hp, hp_max)
											end
											if oAttacker.chaUI["numberBar"] then
												oAttacker.chaUI["numberBar"]:setText(new_hp .. "/" .. hp_max)
											end
										end
										
										--冒字本次吸血
										--显示动画
										local cx, cy, cw, ch = oAttacker:getbox()
										local offsetX = math.floor(cx + cw / 2)
										local offsetY = math.floor(cy + ch)
										local ctrl = hUI.floatNumber:new(
										{
											parent = oAttacker.handle._n,
											font = "numWhite",
											text = "+" .. addHp, --hp_restore_show
											size = 10,
											x = offsetX,
											y = offsetY + 75,
											align = "MB",
											moveY = 16,
											lifetime = 800,
											fadeout = 600,
										})
										ctrl.handle.s:setColor(ccc3(0, 255, 64))
									end
								end
							end
						end
					end
				end
			end
		end)
		
		--监听：角色受到伤害事件，检测金钱怪每次被攻击，加钱
		hGlobal.event:listen("Event_UnitDamaged", "TD_Unit_Damged_GoldUnitAddGold", function(oDmgUnit, skillId, mode, dmg, nLost, oAttacker, nAbsorb, oAttackerSide, oAttackerPos)
			--print(oDmgUnit.data.name, oAttacker and oAttacker.data.name, oAttackerSide, oAttackerPos)
			--攻击金钱每次加的钱大于0
			--if (hVar.GOLDUNIT_ATK_ADDGOLD > 0) then
				--受伤的人存在，攻击者存在
				if oDmgUnit and oAttacker then
					--存在技能
					if skillId and (skillId > 0) then
						--伤害大于0
						if (dmg > 0) then
							--检测本技能是否是攻击者的普通攻击
							--local normalAtkSkillId = oAttacker.attr.attack[1]
							--if (normalAtkSkillId == skillId) then --不是普通攻击也可以加钱
								--目标是否是金钱怪
								--print(oDmgUnit.data.id, hVar.tab_unit[oDmgUnit.data.id])
								local bIsGoldUnit = (hVar.tab_unit[oDmgUnit.data.id].tag and hVar.tab_unit[oDmgUnit.data.id].tag[hVar.UNIT_TAG_TYPE.OTHER.TAG_GOLDUNIT])
								if bIsGoldUnit then
									--加钱
									local w = hGlobal.WORLD.LastWorldMap
									local mapInfo = w.data.tdMapInfo
									--local gold = hVar.GOLDUNIT_ATK_ADDGOLD
									
									local gold = dmg
									oDmgUnit.data.gotGoldTotal = (oDmgUnit.data.gotGoldTotal or 0) + gold
									gold = gold - math.max((oDmgUnit.data.gotGoldTotal - oDmgUnit:GetHpMax()),0)
									
									gold = math.max(1, math.floor(gold * 0.1))
									
									--mapInfo.gold = (mapInfo.gold or 0) + gold
									--hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD, gold)
									--local owner = oAttacker:getowner()
									--if owner then
									--	owner:addresource(hVar.RESOURCE_TYPE.GOLD, gold)
									--end
									if oAttacker and oAttacker.getowner then
										local aOwner = oAttacker:getowner()
										if aOwner then
											local aforce = aOwner:getforce()
											--如果是蜀国或魏国势力的单位进行了击杀，则钱平分给玩家本势力的玩家
											if aOwner == w:GetForce(hVar.FORCE_DEF.SHU) or aOwner == w:GetForce(hVar.FORCE_DEF.WEI) then
												local pList = w:GetAllPlayerInForce(aforce)
												local pNum = #pList
												if pNum > 0 then
													local goldDiv = math.floor(gold / pNum)
													for i = 1, pNum do
														pList[i]:addresource(hVar.RESOURCE_TYPE.GOLD, goldDiv)
													end
													
													--冒字跳金币动画
													hApi.ShowGoldBubble(oDmgUnit, goldDiv, false)
													
													--更新界面
													hGlobal.event:event("Event_TdGoldCostRefresh")
												end
												aOwner:addresource(hVar.RESOURCE_TYPE.GOLD, gold)
											else
												aOwner:addresource(hVar.RESOURCE_TYPE.GOLD, gold)
												
												if w:GetPlayerMe() and aOwner == w:GetPlayerMe() then
													--冒字跳金币动画
													hApi.ShowGoldBubble(oDmgUnit, gold, false)
													
													--更新界面
													hGlobal.event:event("Event_TdGoldCostRefresh")
												end
											end
										end
									end
								end
							--end
						end
					end
				end
			--end
		end)
		
		--监听：角色受到伤害事件，沉睡的单位被唤醒
		hGlobal.event:listen("Event_UnitDamaged", "TD_Unit_Damged_SleepWakeUp", function(oDmgUnit, skillId, mode, dmg, nLost, oAttacker, nAbsorb, oAttackerSide, oAttackerPos)
			--检测角色是否有沉睡状态
			if (oDmgUnit.attr.suffer_sleep_stack > 0) then
				--遍历该单位身上存在的所有buff，移除沉睡标记
				local tt = oDmgUnit.data["buffs"]
				if tt.index then
					for buff_key, n in pairs(tt.index) do
						if n and (n ~= 0) then
							local oID = tt[n]
							local oBuff = hClass.action:find(oID)
							if oBuff then --目标身上已有此buff
								--local buffId = oBuff.data.skillId --buff的技能id
								--print("目标身上已有此buff", oUnit.data.name, buffId)
								if (oBuff.data.buffState_SufferSleep == 1) then
									--删除buff
									oBuff:del_buff()
								end
							end
						end
					end
				end
			end
		end)
		
		--监听：收到网络cmd指令
		hGlobal.event:listen("LocalEvent_Pvp_Sync_CMD", "TD_PVP_CMD_EVENT", hApi.OnReceiveNetCmd)
		
		--监听：pvp服务器断网事件
		local OnNetStateEvent = function(net_state)
			local oWorld = hGlobal.WORLD.LastWorldMap
			local mapInfo = oWorld.data.tdMapInfo
			if mapInfo then
				--只处理pvp模式
				if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
					--断网
					if (net_state ~= 1) then
						--取消监听事件，避免重复弹框
						hGlobal.event:listen("LocalEvent_Pvp_NetEvent", "TD_Pvp_NetEvent", nil) --1online 其它offline
						hGlobal.event:listen("LocalEvent_Pvp_LogEvent", "TD_Pvp_LogEvent", nil) --0:kick 1:in 2:out 3:dis
						
						--弹框，断网
						local strText = hVar.tab_string["__TEXT_Net_ERRO_1"] --language
						
						if (net_state == 0) then --被踢掉
							strText = hVar.tab_string["__TEXT_Net_ERRO_4"] --language
						end
						
						--geyachao: 只处理被踢掉
						if (net_state ~= 0) then --非被踢掉
							return
						end
						
						hGlobal.UI.MsgBox(strText, {
							font = hVar.FONTC,
							ok = function()
								--删除可能的投降对话框界面
								if hGlobal.UI.PhonePlayerTouXiangFrm then
									hGlobal.UI.PhonePlayerTouXiangFrm:del()
									hGlobal.UI.PhonePlayerTouXiangFrm = nil
								end
								
								--删除可能的pvp等待玩家的界面
								if hGlobal.UI.PhoneDelayPlayerFrm then
									hGlobal.UI.PhoneDelayPlayerFrm:del()
									hGlobal.UI.PhoneDelayPlayerFrm = nil
								end
								
								--删除可能的pvp结束界面
								if hGlobal.UI.__GameOverPanel_pvp then
									hGlobal.UI.__GameOverPanel_pvp:del()
									hGlobal.UI.__GameOverPanel_pvp = nil
								end
								
								--删除可能的响应时间过长框界面
								if hGlobal.UI.PhonePlayerNoHeartFrm then
									hGlobal.UI.PhonePlayerNoHeartFrm:del()
									hGlobal.UI.PhonePlayerNoHeartFrm = nil
									
									hApi.clearTimer("__Reconnect_PVP_5__")
									hApi.clearTimer("__Reconnect_PVP_4__")
									hApi.clearTimer("__Reconnect_PVP_3__")
									hApi.clearTimer("__Reconnect_PVP_2__")
									hApi.clearTimer("__Reconnect_PVP_1__")
								end
								
								--返回大厅
								--geyachao: 先存档
								--存档
								LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
								
								--关闭同步日志文件
								hApi.SyncLogClose()
								--关闭非同步日志文件
								hApi.AsyncLogClose()
								
								--隐藏可能的选人界面
								if hGlobal.UI.PhoneSelectedHeroFrm2 then
									hGlobal.UI.PhoneSelectedHeroFrm2:show(0)
									hGlobal.UI.PhoneSelectedHeroFrmBG.handle.s:setVisible(false) --隐藏背景框挡板
									hApi.clearTimer("__SELECT_HERO_UPDATE__")
									hApi.clearTimer("__SELECT_TOWER_UPDATE__")
									hApi.clearTimer("__SELECT_TACTIC_UPDATE__")
								end
								
								
								--todo zhenkira 这里以后要读取当前地图所在章节进行切换
								
								--zhenkira 注释
								--if g_vs_number > 4 and g_lua_src == 1 then
								--	local mapname = hGlobal.WORLD.LastWorldMap.data.map
								--	if hApi.Is_WDLD_Map(mapname) ~= -1 then
								--		Game_Zone_OnGameEvent(GZone_Event_TypeDef.Leave,luaGetplayerDataID())
								--	end
								--end
								
								--if hGlobal.WORLD.LastTown~=nil then
								--	hGlobal.WORLD.LastTown:del()
								--end
								
								--zhenkira 注释
								if (hGlobal.WORLD.LastWorldMap ~= nil) then
									local mapname = hGlobal.WORLD.LastWorldMap.data.map
									--if hApi.Is_RSYZ_Map(mapname) ~= -1 then
									--	print(".."..nil)
									--	Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleEnd_Fire,luaGetplayerDataID(),g_RSDYZ_BattleID})
									--end
									
									--------------------------------------------------------
									--geyachao: pvp模式，为了防止玩家恶意刷游戏局
									--在掉线的时候，记录一下本局游戏对战的对手
									--找到对手
									local userId_Enemy = 0 --对手的uid
									local userName_Enemy = "" --对手的名字
									local forceMe = hGlobal.WORLD.LastWorldMap:GetPlayerMe():getforce()
									for i = 1, 20, 1 do
										local player_i = hGlobal.WORLD.LastWorldMap.data.PlayerList[i]
										if player_i then
											local force_i = player_i:getforce()
											if(force_i ~= forceMe) then
												if (player_i:gettype() == 1) then --0空 1玩家 2简单电脑 3中等电脑 4困难电脑 5大师电脑 6专家电脑
													userId_Enemy = player_i.data.dbid --找到了
													userName_Enemy = player_i.data.name
													break
												end
											end
										end
									end
									if (userId_Enemy > 0) then
										local session_dbId = hGlobal.WORLD.LastWorldMap.data.session_dbId --本局的游戏局唯一id
										local userId = userId_Enemy --本局的对手id
										local userName = userName_Enemy --本局的对手名字
										local bUseEquip = hGlobal.WORLD.LastWorldMap.data.bUseEquip --本局是否携带状态
										local pvpcoinCost = hGlobal.WORLD.LastWorldMap:GetPlayerMe():getuserdata(1) or 0 --用户自定义数据[1] 本局消耗的兵符
										local gametime = math.floor(hGlobal.WORLD.LastWorldMap:gametime() / 1000) --本局的游戏时长(秒)
										LuaAddPVPUserInfo(g_curPlayerName, session_dbId, userId, userName, bUseEquip, pvpcoinCost, gametime)
									end
									--------------------------------------------------------
									
									hGlobal.WORLD.LastWorldMap:del()
									
									local tabM = hVar.MAP_INFO[mapname]
									local chapterId = 1
									if tabM then
										chapterId = tabM.chapter or 1
									end
									
									hGlobal.LocalPlayer:setfocusworld(nil)
									hApi.clearCurrentWorldScene()
									
									hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", chapterId)
								end
								
								--zhenkira 注释
								--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
								--zhenkira 新增
								--hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", chapterId)
								--hGlobal.event:event("LocalEvent_Phone_ShowReturnContinue",1)
								--hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
							end,
						})
					end
				end
			end
		end
		hGlobal.event:listen("LocalEvent_Pvp_NetEvent", "TD_Pvp_NetEvent", OnNetStateEvent) --1online 其它offline
		hGlobal.event:listen("LocalEvent_Pvp_LogEvent", "TD_Pvp_LogEvent", OnNetStateEvent) --0:kick 1:in 2:out 3:dis
		
		--[[
		--监听：pvp服务器玩家被踢出事件
		local OnPlayerKickEvent = function(net_state)
			local oWorld = hGlobal.WORLD.LastWorldMap
			local mapInfo = oWorld.data.tdMapInfo
			--print("监听：pvp服务器玩家被踢出事件", net_state)
			if mapInfo then
				--只处理pvp模式
				if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
					--玩家被踢出
					if (net_state == 0) then
						--弹框，被提出
						local strText = hVar.tab_string["__TEXT_Net_ERRO_4"] --language
						hGlobal.UI.MsgBox(strText, {
							font = hVar.FONTC,
							ok = function()
								--返回大厅
								--geyachao: 先存档
								--存档
								LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
								
								--关闭同步日志文件
								hApi.SyncLogClose()
								--关闭非同步日志文件
								hApi.AsyncLogClose()
								
								--隐藏可能的选人界面
								if hGlobal.UI.PhoneSelectedHeroFrm2 then
									hGlobal.UI.PhoneSelectedHeroFrm2:show(0)
									hGlobal.UI.PhoneSelectedHeroFrmBG.handle.s:setVisible(false) --隐藏背景框挡板
									hApi.clearTimer("__SELECT_HERO_UPDATE__")
									hApi.clearTimer("__SELECT_TOWER_UPDATE__")
									hApi.clearTimer("__SELECT_TACTIC_UPDATE__")
								end
								
								
								--todo zhenkira 这里以后要读取当前地图所在章节进行切换
								
								--zhenkira 注释
								--if g_vs_number > 4 and g_lua_src == 1 then
								--	local mapname = hGlobal.WORLD.LastWorldMap.data.map
								--	if hApi.Is_WDLD_Map(mapname) ~= -1 then
								--		Game_Zone_OnGameEvent(GZone_Event_TypeDef.Leave,luaGetplayerDataID())
								--	end
								--end
								
								--if hGlobal.WORLD.LastTown~=nil then
								--	hGlobal.WORLD.LastTown:del()
								--end
								
								--zhenkira 注释
								if (hGlobal.WORLD.LastWorldMap ~= nil) then
									local mapname = hGlobal.WORLD.LastWorldMap.data.map
									--if hApi.Is_RSYZ_Map(mapname) ~= -1 then
									--	print(".."..nil)
									--	Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleEnd_Fire,luaGetplayerDataID(),g_RSDYZ_BattleID})
									--end
									hGlobal.WORLD.LastWorldMap:del()
									
									local tabM = hVar.MAP_INFO[mapname]
									local chapterId = 1
									if tabM then
										chapterId = tabM.chapter or 1
									end
									
									hGlobal.LocalPlayer:setfocusworld(nil)
									hApi.clearCurrentWorldScene()
									
									hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", chapterId)
								end
								
								--zhenkira 注释
								--hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
								--zhenkira 新增
								--hGlobal.event:event("LocalEvent_Phone_ShowPhone_SelecteMap", chapterId)
								--hGlobal.event:event("LocalEvent_Phone_ShowReturnContinue",1)
								--hApi.setViewNodeFocus(hVar.SCREEN.w/2,hVar.SCREEN.h/2)
							end,
						})
					end
				end
			end
		end
		--hGlobal.event:listen("LocalEvent_Pvp_PlayerLoginEvent", "PlayerKickEvent", OnPlayerKickEvent) --0:kick 1:in 2:out 3:dis
		]]
		
		--监听pvp游戏结果为无效局的描述信息
		hGlobal.event:listen("LocalEvent_Pvp_GameResult_Invalid", "TD_Pvp_GameResult_Invalid", function(errorStr)
			--print("监听pvp游戏结果为无效局的描述信息", errorStr)
			local world = hGlobal.WORLD.LastWorldMap
			if world then
				--pvp无效局的原因描述
				world.data.result_invalid_str = errorStr
			end
		end)
		
		--监听pvp战绩结果下发
		hGlobal.event:listen("LocalEvent_Pvp_GameResult_RewardStar", "TD_Pvp_GameResult_RewardStar", function(t)
			--print("监听pvp战绩结果下发", t)
			local world = hGlobal.WORLD.LastWorldMap
			if world then
				if (t.session_dbId == world.data.session_dbId) then
					--pvp战绩结果
					world.data.result_envaluate_table = t
				end
			end
		end)
		
		--监听pvp等待玩家事件
		hGlobal.event:listen("LocalEvent_Pvp_Delay_Player", "TD_Pvp_DelayPlayerEvent", hApi.ShowDelayPlayerFrm)
		
		--监听pvp英雄升级pvp等级事件
		hGlobal.event:listen("Event_HeroPvpLvUp", "TD_HeroPvpLvUp", function(oHero, lastLv, nowLv)
			--print("监听pvp英雄升级pvp等级事件", "Event_HeroPvpLvUp", oHero.data.name, nowLv)
			local unitLv = nowLv --单位等级
			local skillLv = nowLv --技能等级
			
			--如果是魔龙宝库地图（world.data.tdMapInfo.pveHeroMode == 1），那么显示pve的等级
			local world = hGlobal.WORLD.LastWorldMap
			if world then
				if world and world.data.tdMapInfo and (world.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
					if (world.data.tdMapInfo.pveHeroMode == 1) then --读pve的数据
						unitLv = oHero.attr.level --单位等级
						
						--只处理我的英雄
						--print(oHero:getowner(), world:GetPlayerMe(), (oHero:getowner() == world:GetPlayerMe()))
						if (oHero:getowner() == world:GetPlayerMe()) then
							local tTactics = world:gettactics(world:GetPlayerMe():getpos()) --本局所有的战术技能卡
							for i = 1, #tTactics, 1 do
								--print(i, "tTactics[i]=", tTactics[i])
								if tTactics[i]~=0 then
									local id, lv, typeId = tTactics[i][1], tTactics[i][2], tTactics[i][3] --geyachao: 该战术技能卡是哪个英雄的
									--print( id, lv, typeId, oHero.data.id)
									if (typeId == oHero.data.id) then --找到了
										skillLv = lv --技能等级
										--print("技能等级", lv)
										break
									end
								end
							end
						end
					end
				end
			end
			
			--设置我方英雄左上角英雄头像的pvp等级
			if oHero.heroUI["btnIcon"] and oHero.heroUI["btnIcon"].childUI["pvp_label"] then
				local scale = 1.0
				if (g_phone_mode == 0) then --平板模式
					scale = 0.8
					if (unitLv >= 10) then
						scale = 0.55
					end
				else --手机模式
					scale = 1.0
					if (unitLv >= 10) then
						scale = 0.75
					end
				end
				oHero.heroUI["btnIcon"].childUI["pvp_label"]:setText(unitLv)
				oHero.heroUI["btnIcon"].childUI["pvp_label"].handle._n:setScale(scale)
				--print("设置我方英雄左上角英雄头像的pvp等级", unitLv)
			end
			
			--设置单位的pvp等级
			local oUnit = oHero:getunit()
			if oUnit then
				if oUnit.chaUI["pvp_label_unit"] then
					local scale = 0.68
					if (unitLv >= 10) then
						scale = 0.5
					end
					--local strText = unitLv .. "级" --language
					local strText = unitLv
					oUnit.chaUI["pvp_label_unit"]:setText(strText)
					oUnit.chaUI["pvp_label_unit"].handle._n:setScale(scale)
				end
			end
			
			--设置主动战术卡的pvp等级
			local world = hGlobal.WORLD.LastWorldMap
			local tacticCardCtrls = world.data.tacticCardCtrls --战术技能卡控件集
			for i = 1, #tacticCardCtrls, 1 do
				local btni = tacticCardCtrls[i]
				if btni and (btni ~= 0) then
					--print(btni, i, btni.data.bindHero, oHero, (btni.data.bindHero == oHero))
					if (btni.data.bindHero == oHero) then --此战术技能卡绑定的英雄对象
						--print(i, btni, btni.childUI["pvp_label"])
						if btni.childUI["pvp_label"] then
							local scale = 1.0
							if (g_phone_mode == 0) then --平板模式
								scale = 0.7
								if (skillLv >= 10) then
									scale = 0.48
								end
							else --手机模式
								scale = 0.88
								if (skillLv >= 10) then
									scale = 0.58
								end
							end
							--print("设置主动战术卡的pvp等级", skillLv)
							btni.childUI["pvp_label"]:setText(skillLv)
							btni.childUI["pvp_label"].handle._n:setScale(scale)
						end
					end
				end
			end
			
			--英雄升级的特效和音效表现
			local cx, cy, cw, ch = oUnit:getbox()
			local offsetX = math.floor(cx + cw/2)
			local offsetY = -math.floor(cy + ch)
			local offsetZ = 0
			local effectId = 194
			local loop = 1
			local skillId = -1
			world:addeffect(effectId, loop, {hVar.EFFECT_TYPE.UNIT, skillId, oUnit, offsetZ}, offsetX, offsetY)
			
			--播放音效
			local oPlayerMe = world:GetPlayerMe()
			local oPlayer = oHero:getowner()
			if (oPlayer == oPlayerMe) then
				if (unitLv > 1) then --第1级不播放声音
					hApi.PlaySound("level_up")
				end
			end
			
			--刷新英雄头像的装备可用状态
			hApi.UpdateHeroEquipStateUI_PVP()
			
			--刷新pvp某个英雄的装备获得冒泡
			hApi.UpdateHeroEquipBubble_PVP(oHero)
		end)
		
		--监听pvp英雄增加经验事件
		hGlobal.event:listen("Event_HeroPvpAddExp", "TD_HeroPvpAddExp", function(oHero, lastExp, addExp, nowExp)
			--设置单位的pvp等级
			local oUnit = oHero:getunit()
			if oUnit then
				local pvp_lv = oUnit.attr.pvp_lv --单位的当前pvp等级
				local minExp = hVar.HERO_PVP_EXP[pvp_lv].minExp --当前等级最低经验值
				local nextExp = hVar.HERO_PVP_EXP[pvp_lv].nextExp --升到下一级所需经验值
				--print(oUnit.data.name, lastExp, addExp, nowExp)
				
				--[[
				if oUnit.chaUI["pvp_exp"] then
					if (pvp_lv >= hVar.HEOR_PVP_LV_MAX) then --到顶级
						--更新进度
						oUnit.chaUI["pvp_exp"]:setV(100, 100)
					else --未到顶级
						local maxV = nextExp
						local V = nowExp - minExp
						oUnit.chaUI["pvp_exp"]:setV(V, maxV)
					end
				end
				]]
			end
		end)
		
		--监听pvp魔龙宝库、铜雀台游戏结束抽奖结果
		hGlobal.event:listen("localEvent_ShowChoiceAwardFrm", "TD_PVP_ShowChoiceAward", function(rewardInfo)
			local world = hGlobal.WORLD.LastWorldMap
			if world then
				--存储pvp铜雀台游戏结束抽奖结果
				world.data.pvp_rewardInfo = rewardInfo
			end
		end)
		
		--监听角色死亡事件
		hGlobal.event:listen("Event_UnitDead", "TD_WildCheckDead", function(oDeadTarget, operate, oKillerUnit, id, param, oKillerSide, oKillerPos)
			
			if TD_WildCheckDead then
				TD_WildCheckDead(oDeadTarget, operate, oKillerUnit, id, param, oKillerSide, oKillerPos)
			end
		end)
		
		--监听虚拟摇杆双击事件
		hGlobal.event:listen("LocalEvent_VitrualControllerTouchDoubleClick", "TD_VCTouchDoubleClick", function()
			--竖屏模式
			if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL) then --竖屏模式
				local world = hGlobal.WORLD.LastWorldMap
				if world then
					--print(world.data.map)
					if (world.data.map ~= hVar.MainBase) and (world.data.map ~= hVar.LoginMap) then
						local tacticId = 0
						local itemId = hVar.tab_unit[hVar.MY_TANK_ID].skillItemlId
						local iTag = 0
						
						local rpgunit_last_x = world.data.rpgunit_last_x
						local rpgunit_last_y = world.data.rpgunit_last_y
						local heros = world:GetPlayerMe().heros
						if heros then
							local oHero = heros[1]
							if oHero then
								local oUnit = oHero:getunit()
								if oUnit then
									local ux, uy = hApi.chaGetPos(oUnit.handle) --角色当前的位置
									local dx = ux - rpgunit_last_x
									local dy = uy - rpgunit_last_y
									
									if (dx ~= 0) or (dy ~= 0) then --有位移，当前为运动状态
										iTag = 1
									else
										iTag = 0
									end
								end
							end
						end
						hApi.AddCommand(hVar.Operation.UseTacticCard, tacticId, itemId, 0, 0, 0, 0, iTag)
					end
				end
			end
			
		end)
		
		--监听虚拟摇杆单击事件
		hGlobal.event:listen("LocalEvent_VitrualControllerTouchClick", "TD_VCTouchClick", function()
			--竖屏模式
			if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL) then --竖屏模式
				local world = hGlobal.WORLD.LastWorldMap
				if world then
					--print(world.data.map)
					if (world.data.map ~= hVar.MainBase) and (world.data.map ~= hVar.LoginMap) then
						local tacticId = 0
						local itemId = hVar.tab_unit[hVar.MY_TANK_ID].skillItemlId
						local iTag = 0
						
						local rpgunit_last_x = world.data.rpgunit_last_x
						local rpgunit_last_y = world.data.rpgunit_last_y
						local heros = world:GetPlayerMe().heros
						if heros then
							local oHero = heros[1]
							if oHero then
								local oUnit = oHero:getunit()
								if oUnit then
									local ux, uy = hApi.chaGetPos(oUnit.handle) --角色当前的位置
									local dx = ux - rpgunit_last_x
									local dy = uy - rpgunit_last_y
									
									if (dx ~= 0) or (dy ~= 0) then --有位移，当前为运动状态
										iTag = 1
									else
										iTag = 0
									end
								end
							end
						end
						
						--geyachao: 王总说暂时不要抬起扔手雷
						--hApi.AddCommand(hVar.Operation.UseTacticCard, tacticId, itemId, 0, 0, 0, 0, iTag)
					end
				end
			end
		end)
		
		--====================================
		--timer
		--加载最基本的timer
		oWorld:addtimer("__SYS__ObjectAutoUpdate", 1, function(deltaTime)
			hApi.AutoReleaseWorldUnit(hGlobal.WORLD.LastWorldMap)
			hApi.UpdateGameEffect(deltaTime) --geyachao: 添加参数时间间隔，用于更新追踪类飞行特效的位置
			hApi.UpdateGameUnit()
		end)
		
		--技能物体循环timer(action)
		--hApi.addTimerForever("__TD__SkillObjLoop", hVar.TIMER_MODE.GAMETIME, 1, function(currentTime, deltaTime, tickTime)
		oWorld:addtimer("__TD__SkillObjLoop", 1, function(deltaTime)
			--print(deltaTime)
			--geyachao:大地图也走技能循环
			if oWorld then
				--oWorld:frameloopBF(deltaTime + tickTime)
				oWorld:frameloopBF(deltaTime)
				
				--[[
				--选人界面：刷新选择英雄界面
				if refresh_select_hero_UI_loop then
					refresh_select_hero_UI_loop()
				end
				
				--选人界面：刷新战术技能卡界面
				if refresh_select_tactic_UI_loop then
					refresh_select_tactic_UI_loop()
				end
				
				--选人界面：刷新战术技能卡的塔牌界面
				if refresh_select_town_UI_loop then
					refresh_select_town_UI_loop()
				end
				]]
				
				--geyachao: test专用
				if test_auto_attack_loop then
					test_auto_attack_loop(deltaTime)
				end
			end
		end)
		
		--更新碰撞特效和追踪飞行特效timer
		oWorld:addtimer("__TD__CollEffectLoop", 1, function(deltaTime)
		--hApi.addTimerForever("__TD__CollEffectLoop", hVar.TIMER_MODE.GAMETIME, 1, function(currentTime, deltaTime, tickTime)
			hApi.UpdateCollEffect(deltaTime)
		end)
		
		--更新单位的颜色
		oWorld:addtimer("__TD__UnitColorChangeLoop", 1, function(deltaTime)
			UnitColorChangeLoop(deltaTime)
		end)
		
		--无路点单位AI
		--hApi.addTimerForever("__TD__AICommonOperate", hVar.TIMER_MODE.GAMETIME, 100, function()
		oWorld:addtimer("__TD__AICommonOperate", 120, function()
			--地图上无路点单位的AI
			NoRoad_Unit_NormalAttackLoop()
		end)
		
		--有路点单位AI
		--hApi.addTimerForever("__TD__AICommonOperate", hVar.TIMER_MODE.GAMETIME, 100, function()
		oWorld:addtimer("__TD__AICommonOperate2", 220, function()
			--地图上有路点单位的AI
			Road_Unit_NormalAttackLoop()
		end)
		
		--坦克武器自动攻击AI
		--hApi.addTimerForever("__TD__AICommonOperate", hVar.TIMER_MODE.GAMETIME, 100, function()
		oWorld:addtimer("__TD__AICommonOperate3", 150, function()
			--地图上建筑、箭塔自动攻击 loop
			--building_town_attack_loop()
			
			--坦克武器的自动攻击
			tank_weapon_attack_loop()
		end)
		
		
		--英雄自动吸取
		--hApi.addTimerForever("__TD__AICommonOperate", hVar.TIMER_MODE.GAMETIME, 100, function()
		oWorld:addtimer("__TD__AICommonOperate4", 200, function()
			--英雄自动吸取附近的道具
			hero_auto_seek_oitem()
			
			--英雄自动吸附附近的人质
			hero_auto_seek_hostage()
		end)
		
		--连接特效更新timer
		oWorld:addtimer("__TD__LINKEFFECT_Timer", 50, oWorld.__update_linkeffect_timer)
		
		--钩子特效更新timer
		oWorld:addtimer("__TD__HOOKEFFECT_Timer", 1, oWorld.__update_hookeffect_timer)
		
		--AI优化行为
		--hApi.addTimerForever("__TD__AI_Timer", hVar.TIMER_MODE.GAMETIME, 300, function()
		oWorld:addtimer("__TD__AI_Timer", 300, function()
			--刷新单位的血条
			--if (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 1) then --数字显血模式
				unit_hpbar_loop()
			--end
			
			--AI优化loop
			AI_LockTargetCheckLoop() --检测锁定的目标，是否也要锁定单位
			--AI_AttackOptmiseLoop() --优化攻击目标 --大菠萝，去掉此优化
			--AI_EnemyAttackCollapse() --检测敌人是否重叠 --大菠萝，去掉此优化
		end)
		
		oWorld:addtimer("__TD__AI_Timer4", 1500, function()
			--AI优化loop
			AI_EnemyAttackCollapse() --检测敌人是否重叠
		end)
		
		--范围搜敌优化处理
		oWorld:addtimer("__TD__PROCESS_DAMAGEAREA_PERF_timer", 200, function()
			--print("   ------------- process begin -------------")
			oWorld:processDamageAreaPerf()
			--print("   ------------- process end -------------")
		end)
		
		--绘制地图上AI的UI
		--hApi.addTimerForever("__TD__PAINT_AI_timer", hVar.TIMER_MODE.GAMETIME, 300, function()
		oWorld:addtimer("__TD__PAINT_AI_timer", 300, function()
			--绘制UI
			PaintAIStateUILoop()
		end)
		
		--[[
		--自动存档
		oWorld:addtimer("__TD__AutoSave__", 10* 1000, function(deltaTime)
			--存档
			LuaSavePlayerList()
			LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
		end)
		]]
		
		--检测坦克冒烟特效
		--hApi.addTimerForever("__TD__TANK_SMOKE_EFF_Timer", hVar.TIMER_MODE.GAMETIME, 100, function()
		--local SMOKE_EFF_COUNTER = 0
		oWorld:addtimer("__TD__TANK_SMOKE_EFF_Timer", 1000, function()
			--SMOKE_EFF_COUNTER = SMOKE_EFF_COUNTER + 1
			--if (SMOKE_EFF_COUNTER >= 4) then
			--	SMOKE_EFF_COUNTER = 0
			--end
			--不是loading图，不在基地里
			if (oWorld.data.map ~= hVar.LoginMap) and (oWorld.data.map ~= hVar.MainBase) then
				--我的战车宠物回血、近战反伤、近战弹开、子弹攻击
				local pet_hp_restore = 0
				local melee_fight = 0
				--local melee_stone = 0
				local melee_bounce = 0
				local bullet_atk = 0
				local me = oWorld:GetPlayerMe()
				local heros = me.heros
				local oHero = heros[1]
				if oHero then
					local u = oHero:getunit()
					if u then
						pet_hp_restore = u:GetPetHpRestore()
						melee_fight = u:GetMeleeFight()
						--melee_stone = u:GetMeleeStone()
						melee_bounce = u:GetMeleeBounce()
						bullet_atk = u:GetBulletAtk()
					end
				end
				--print("pet_hp_restore=", pet_hp_restore)
				
				--local me = oWorld:GetPlayerMe()
				--local heros = me.heros
				--local oHero = heros[1]
				local rpgunits = oWorld.data.rpgunits
				for u, u_worldC in pairs(rpgunits) do
					--local oUnit = oHero:getunit()
					local oUnit = u
					--if oUnit and (oUnit ~= 0) then
					--if (oUnit.data.id == hVar.MY_TANK_FOLLOW_ID) then
					for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
						if (oUnit.data.id == walle_id) then
							oUnit.data.IsEncountered = oUnit.data.IsEncountered + 1
							if (oUnit.data.IsEncountered >= 4) then
								oUnit.data.IsEncountered = 0
							end
							
							local hp = oUnit.attr.hp
							local hpMax = oUnit:GetHpMax()
							local rate = math.floor(hp / hpMax * 100)
							
							if (rate <= 25) then
								hApi.ShowTankSmokeEff(oUnit, 0.5)
							elseif (rate <= 50) then
								if (oUnit.data.IsEncountered == 0) or (oUnit.data.IsEncountered == 2) then
									hApi.ShowTankSmokeEff(oUnit, 0.5)
								end
							elseif (rate <= 75) then
								if (oUnit.data.IsEncountered == 0) then
									hApi.ShowTankSmokeEff(oUnit, 0.5)
								end
							end
							
							--宠物回血
							if (pet_hp_restore > 0) then
								if (hp < hpMax) then --未满血
									--检测是否回满血
									local new_hp = hp + pet_hp_restore
									if (new_hp > hpMax) then
										--当前血量为最大血量
										new_hp = hpMax
									end
									
									--标记新的血量
									oUnit.attr.hp = new_hp
									
									--更新血条控件
									if oUnit.chaUI["hpBar"] then
										if (hpMax <= 0) then
											hpMax = 1
										end
										oUnit.chaUI["hpBar"]:setV(new_hp, hpMax)
										--print("oUnit.chaUI5()", new_hp, hpMax)
									end
									if oUnit.chaUI["numberBar"] then
										if (hpMax <= 0) then
											hpMax = 1
										end
										oUnit.chaUI["numberBar"]:setText(new_hp .. "/" .. hpMax)
									end
									
									--显示动画
									--显示在角色的头顶
									local cx, cy, cw, ch = oUnit:getbox()
									local offsetX = math.floor(cx + cw / 2)
									--local offsetY = math.floor(cy + ch)
									local offsetY = 0
									if (oUnit.data.type == hVar.UNIT_TYPE.HERO) then
										offsetY = 50
									end
									hUI.floatNumber:new(
									{
										parent = oUnit.handle._n,
										font = "numGreen",
										text = "+" .. pet_hp_restore, --pet_hp_restore
										size = 18,
										x = offsetX,
										y = offsetY + 60,
										align = "MB",
										moveY = 20,
										lifetime = 800,
										fadeout = 600,
									})
								end
							end
						end
					end
				end
				
				--近战反伤
				if (melee_fight > 0) then
					local unitSide = me:getforce()
					local rMax = 100
					local u = oHero:getunit()
					local selfX, selfY = hApi.chaGetPos(u.handle) --当前坐标
					local skillId = 0
					local nDmgMode = 0
					local nDmg = melee_fight
					local caster_pos = me:getpos()
					oWorld:enumunitAreaEnemy(unitSide, selfX + 0, selfY + 0, rMax, function(eu)
						if (eu.data.type == hVar.UNIT_TYPE.UNIT) or (eu.data.type == hVar.UNIT_TYPE.HERO) then
							if (eu:GetSpaceType() == hVar.UNIT_SPACE_TYPE.SPACE_GROUND) then --目标的空间类型
								local t_x, t_y = hApi.chaGetPos(eu.handle)
								
								--特效
								local facing = GetFaceAngle(selfX, selfY, t_x, t_y) --角色的朝向(角度制)
								local oEffect = oWorld:addeffect(3184, 1, nil, t_x, t_y) --56
								oEffect.handle.s:setRotation(facing)
								
								--冒字
								hApi.ShowLabelBubble(eu, "-" .. melee_fight, ccc3(255, 0, 0), 0, 0, 20, nil, nil)
								
								--造成伤害
								hGlobal.event:call("Event_UnitDamaged", eu, skillId, nDmgMode,nDmg, 0, u, nil, unitSide, caster_pos)
							end
						end
					end)
				end
				
				--近战弹开
				--print("melee_bounce=", melee_bounce)
				if (melee_bounce > 0) then
					local u = oHero:getunit()
					local aiState = u:getAIState() --角色的AI状态
					if (aiState ~= hVar.UNIT_AI_STATE.IDLE) then --原来不是闲置状态
						local selfX, selfY = hApi.chaGetPos(u.handle) --当前坐标
						local gridX, gridY = oWorld:xy2grid(selfX, selfY)
						--释放技能(普通攻击)
						local tCastParam =
						{
							level = melee_bounce, --技能等级
						}
						hApi.CastSkill(u, 31093, 0, 100, u, gridX, gridY, tCastParam)
					end
				end
				
				--子弹攻击
				if (bullet_atk > 0) then
					local u = oHero:getunit()
					local selfX, selfY = hApi.chaGetPos(u.handle) --当前坐标
					local gridX, gridY = oWorld:xy2grid(selfX, selfY)
					--释放技能(普通攻击)
					local tCastParam =
					{
						level = bullet_atk, --技能等级
					}
					hApi.CastSkill(u, 31096, 0, 100, u, gridX, gridY, tCastParam)
				end
			end
		end)
		
		--检测坦克近战碎石
		oWorld:addtimer("__TD__TANK_MELEE_STONE_Timer", 500, function()
			--SMOKE_EFF_COUNTER = SMOKE_EFF_COUNTER + 1
			--if (SMOKE_EFF_COUNTER >= 4) then
			--	SMOKE_EFF_COUNTER = 0
			--end
			--不是loading图，不在基地里
			if (oWorld.data.map ~= hVar.LoginMap) and (oWorld.data.map ~= hVar.MainBase) then
				--我的战车近战碎石
				local melee_stone = 0
				
				local me = oWorld:GetPlayerMe()
				local heros = me.heros
				local oHero = heros[1]
				if oHero then
					local u = oHero:getunit()
					if u then
						melee_stone = u:GetMeleeStone()
					end
				end
				
				--近战碎石
				--print("melee_stone=", melee_stone)
				if (melee_stone > 0) then
					local unitSide = me:getforce()
					local rMax = 100
					local u = oHero:getunit()
					local selfX, selfY = hApi.chaGetPos(u.handle) --当前坐标
					local skillId = 0
					local nDmgMode = 0
					local nDmg = melee_stone
					local caster_pos = me:getpos()
					oWorld:enumunitArea(unitSide, selfX + 0, selfY + 0, rMax, function(eu)
						if (eu.data.type == hVar.UNIT_TYPE.UNITBROKEN) then
							local t_x, t_y = hApi.chaGetPos(eu.handle)
							
							--特效
							local facing = GetFaceAngle(selfX, selfY, t_x, t_y) --角色的朝向(角度制)
							local oEffect = oWorld:addeffect(3157, 1, nil, t_x, t_y) --56
							oEffect.handle.s:setRotation(facing)
							
							--[[
							--冒字
							hApi.ShowLabelBubble(eu, "-" .. melee_stone, ccc3(255, 0, 0), 0, 0, 20, nil, nil)
							]]
							
							--造成伤害
							hGlobal.event:call("Event_UnitDamaged", eu, skillId, nDmgMode,nDmg, 0, u, nil, unitSide, caster_pos)
						end
					end)
				end
			end
		end)
		
		--检测坦克陷阱、天网、迷惑
		oWorld:addtimer("__TD__TANK_TRAP_EFF_Timer", 1000, function()
			--基地不处理
			if (oWorld.data.map == hVar.MainBase) then
				return
			end
			
			--loading不处理
			if (oWorld.data.map == hVar.LoginMap) then
				return
			end
			
			local trap_ground = 0 --陷阱持续时间（单位：毫秒）
			local trap_groundcd = 0 --陷阱施法间隔（单位：毫秒）
			local trap_groundenemy = 0 --陷阱困敌时间（单位：毫秒）
			local trap_fly = 0 --天网持续时间（单位：毫秒）
			local trap_flycd = 0 --天网施法间隔（单位：毫秒）
			local trap_flyenemy = 0 --天网困敌时间（单位：毫秒）
			local puzzle = 0 --迷惑几率（去百分号后的值）
			
			local me = oWorld:GetPlayerMe()
			local heros = me.heros
			local oHero = heros[1]
			if oHero then
				local u = oHero:getunit()
				if u then
					trap_ground = u:GetTrapGround()
					trap_groundcd = u:GetTrapGroundCD()
					trap_groundenemy = u:GetTrapGroundEnemy()
					trap_fly = u:GetTrapFly()
					trap_flycd = u:GetTrapFlyCD()
					trap_flyenemy = u:GetTrapFlyEnemy()
					puzzle = u:GetPuzzle()
				end
			end
			
			--陷阱
			--print("trap_ground=", trap_ground)
			if (trap_ground > 0) then
				local u = oHero:getunit()
				local cd = hVar.TRAP_GROUND_CASTCD + trap_groundcd
				if (cd < 0) then
					cd = 0
				end
				local lasttime = u.attr.trap_ground_lasttime --陷阱上次施法的时间
				local deltatime = oWorld:gametime() - lasttime
				--print("deltatime=", deltatime, "cd=", cd)
				if (deltatime >= cd) then --cd到了
					--单位不在眩晕(滑行)中、不在隐身中、不在混乱中、不在沉睡中、不在沉默中
					if (u.attr.stun_stack == 0) and (u:GetYinShenState() ~= 1) and (u.attr.suffer_chaos_stack == 0) and (u.attr.suffer_sleep_stack == 0) and (u.attr.suffer_chenmo_stack == 0) then
						--释放技能
						local selfX, selfY = hApi.chaGetPos(u.handle) --当前坐标
						local gridX, gridY = oWorld:xy2grid(selfX, selfY)
						--释放技能(陷阱)
						local tCastParam =
						{
							level = trap_ground, --陷阱持续时间
							skillTimes = trap_groundenemy, --陷阱困敌时间
						}
						hApi.CastSkill(u, 31115, 0, 100, u, gridX, gridY, tCastParam)
						--print("释放技能(陷阱)", trap_ground, trap_groundenemy)
						
						--更新施法时间
						u.attr.trap_ground_lasttime = oWorld:gametime()
					end
				end
			end
			
			--天网
			--print("trap_fly=", trap_fly)
			if (trap_fly > 0) then
				local u = oHero:getunit()
				local cd = hVar.TRAP_FLY_CASTCD + trap_flycd
				if (cd < 0) then
					cd = 0
				end
				local lasttime = u.attr.trap_fly_lasttime --天网上次施法的时间
				local deltatime = oWorld:gametime() - lasttime
				if (deltatime >= cd) then --cd到了
					--单位不在眩晕(滑行)中、不在隐身中、不在混乱中、不在沉睡中、不在沉默中
					if (u.attr.stun_stack == 0) and (u:GetYinShenState() ~= 1) and (u.attr.suffer_chaos_stack == 0) and (u.attr.suffer_sleep_stack == 0) and (u.attr.suffer_chenmo_stack == 0) then
						--释放技能
						local selfX, selfY = hApi.chaGetPos(u.handle) --当前坐标
						local gridX, gridY = oWorld:xy2grid(selfX, selfY)
						--释放技能(陷阱)
						local tCastParam =
						{
							level = trap_fly, --天网持续时间
							skillTimes = trap_flyenemy, --天网困敌时间
						}
						hApi.CastSkill(u, 31116, 0, 100, u, gridX, gridY, tCastParam)
						
						--更新施法时间
						u.attr.trap_fly_lasttime = oWorld:gametime()
					end
				end
			end
			
			--迷惑
			--print("puzzle=", puzzle)
			if (puzzle > 0) then
				local u = oHero:getunit()
				local cd = hVar.PUZZLE_CDTIME
				local lasttime = u.attr.puzzle_lasttime --迷惑上次施法的时间
				local deltatime = oWorld:gametime() - lasttime
				if (deltatime >= cd) then --cd到了
					--单位不在眩晕(滑行)中、不在隐身中、不在混乱中、不在沉睡中、不在沉默中
					if (u.attr.stun_stack == 0) and (u:GetYinShenState() ~= 1) and (u.attr.suffer_chaos_stack == 0) and (u.attr.suffer_sleep_stack == 0) and (u.attr.suffer_chenmo_stack == 0) then
						--几率触发
						local randValue = oWorld:random(1, 100)
						if (randValue <= puzzle) then
							local selfX, selfY = hApi.chaGetPos(u.handle) --当前坐标
							local gridX, gridY = oWorld:xy2grid(selfX, selfY)
							--释放技能(普通攻击)
							local tCastParam =
							{
								level = 1, --技能等级
							}
							hApi.CastSkill(u, 31135, 0, 100, u, gridX, gridY, tCastParam)
							
							--更新施法时间
							u.attr.puzzle_lasttime = oWorld:gametime()
						end
					end
				end
			end
		end)
		
		--检测坦克
		--存储坦克的上一帧的坐标（用于手雷扔更远）
		oWorld:addtimer("__TD__TANK_CHECK_POSITION_Timer", 1, function()
			local me = oWorld:GetPlayerMe()
			local heros = me.heros
			local oHero = heros[1]
			if oHero then
				local u = oHero:getunit()
				if u then
					local t_x, t_y = hApi.chaGetPos(u.handle) --当前坐标
					--print(t_x, t_y)
					--主角坦克上一帧坐标（用于扔手雷更远）
					oWorld.data.rpgunit_last_x = t_x
					oWorld.data.rpgunit_last_y = t_y
				end
			end
		end)
		
		--战车区域组发兵timer
		oWorld:addtimer("__TD__TANK_RANDOMMAP_SENDARMY_Timer", 1000, hApi.RandomMapRoomSendArmyTimer)
		
		--游戏局中定时检测ui.plist图的spriteframe是否被释放，如果被释放就恢复
		oWorld:addtimer("__TD__RESTORE_UI_PVP_PLIST_timer", 30 * 1000, hApi.Restore_UI_PVP_PLIST)
		
		--战车单位死亡后触发的事件检测（用于追查问题，有时boss死后未触发技能）
		oWorld:addtimer("__TD__TANK_CHECK_DEADSKILLCAST_Timer", 5000, function()
			local Trigger_OnUnitDead_UnitList = oWorld.data.Trigger_OnUnitDead_UnitList
			
			--拷贝
			local tList = {}
			for k, v in pairs(Trigger_OnUnitDead_UnitList) do
				tList[k] = v
			end
			
			local me = oWorld:GetPlayerMe()
			local heros = me.heros
			local oHero = heros[1]
			if oHero then
				local u = oHero:getunit()
				if u then
					--依次遍历全地图角色，是否有未触发死亡技能就消失的单位？
					oWorld:enumunit(function(eu)
						local eu_worldC = eu:getworldC()
						if Trigger_OnUnitDead_UnitList[eu_worldC] then --存在
							tList[eu_worldC] = nil
						end
					end)
					
					--不存在的单位
					for cha_worldC, Trigger_OnUnitDead_SkillId in pairs(tList) do
						print("[检测到未释放的死亡技能]:", Trigger_OnUnitDead_SkillId, u.data.name)
						
						--删除此技能
						Trigger_OnUnitDead_UnitList[cha_worldC] = nil
						
						--战车对战车施法
						local tCastParam =
						{
							level = 1, --技能的等级
						}
						local rebirthX, rebirthY = hApi.chaGetPos(u.handle)
						local gridX, gridY = oWorld:xy2grid(rebirthX, rebirthY)
						hApi.CastSkill(u, Trigger_OnUnitDead_SkillId, 0, 100, u, gridX, gridY, tCastParam) --固定时间的眩晕（避免滑行提前到达）
					end
				end
			end
		end)
		
		--pvp模式，刷新游戏时间的timer
		if (oWorld.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
			--pvp的游戏时间、ping值
			local _frm = hGlobal.UI.TDSystemMenuBar
			if _frm.childUI["PVP_GameTime"] then
				_frm.childUI["PVP_GameTime"]:setText("00:00")
			end
			if _frm.childUI["PVP_PingPrefixLabel"] then
				--_frm.childUI["PVP_PingPrefixLabel"]:setText("网络延时:") --language
				_frm.childUI["PVP_PingPrefixLabel"]:setText(hVar.tab_string["__TEXT_NetDelayTime"] .. ":") --language
			end
			if _frm.childUI["PVP_PingLabel"] then
				_frm.childUI["PVP_PingLabel"]:setText("0")
			end
			
			--无尽地图的得分
			--if _frm.childUI["Endless_ScorePrefixLabel"] then
			--	_frm.childUI["Endless_ScorePrefixLabel"]:setText("死亡: 0")
			--end
			--if _frm.childUI["Endless_ScoreLabel"] then
			--	_frm.childUI["Endless_ScoreLabel"]:setText("")
			--end
			
			--英雄头像栏，下移
			local _frm = hGlobal.UI.HeroFrame
			_frm:setXY(0, 0)
			
			--每秒更新pvp游戏进行的时间
			oWorld:addtimer("__TD__PVP_GAMETIME_timer", 1000, function()
				local _frm = hGlobal.UI.TDSystemMenuBar
				if _frm.childUI["PVP_GameTime"] then
					local gametimeS = math.floor(oWorld:gametime() / 1000)
					local deltaMinutes = math.floor(gametimeS / 60) --分
					local deltaSeconds = gametimeS - deltaMinutes * 60
					
					--转字符串
					local strdeltaMinutes = tostring(deltaMinutes)
					if (deltaMinutes < 10) then
						strdeltaMinutes = "0" .. deltaMinutes
					end
					local strdeltaSeconds = tostring(deltaSeconds)
					if (deltaSeconds < 10) then
						strdeltaSeconds = "0" .. strdeltaSeconds
					end
					local strGameTime = strdeltaMinutes .. ":" .. strdeltaSeconds
					_frm.childUI["PVP_GameTime"]:setText(strGameTime)
				end
			end)
			
			--监听pvp本地的ping事件，刷新本地的ping值
			hGlobal.event:listen("LocalEvent_Pvp_Ping", "GamePvpPing", function(ping)
				--刷新本地的ping值
				local _frm = hGlobal.UI.TDSystemMenuBar
				if _frm.childUI["PVP_PingLabel"] then
					_frm.childUI["PVP_PingLabel"]:setText(ping)
				end
				
				--记录上次收到pvp心跳包的时间
				local world = hGlobal.WORLD.LastWorldMap
				if world then
					if world and world.data.tdMapInfo and (world.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
						if (hGlobal.LocalPlayer:getonline()) then --登入
							local clienttime = os.time()
							local hosttime = clienttime - g_localDeltaTime_pvp --(Local = Host + deltaTime)
							--print("心跳包 Pvp_Server:GetState()=" .. Pvp_Server:GetState(), hosttime)
							world.data.heartTime = hosttime --心跳包上次收到的时间
						end
					end
				end
			end)
			
			--每秒检测是否持续连接（收到心跳报）的timer
			--oWorld:addtimer("__TD__PVP_HEART_timer", 1000, function()
			local sys_gametime = hApi.gametime() --外部系统时间
			hApi.addTimerForever("__TD__PVP_HEART_timer", hVar.TIMER_MODE.GAMETIME, 1000, function()
				local timeNow = hApi.gametime()
				local delta_systime = timeNow - sys_gametime --时间间隔（毫秒）
				local ts = hApi.GetTimeScale()
				if (ts > 0) then
					delta_systime = delta_systime / ts
				end
				sys_gametime = timeNow
				
				--游戏未结束状态
				if (oWorld.data.tdMapInfo.mapState <= hVar.MAP_TD_STATE.PAUSE) then
					local clienttime = os.time()
					local hosttime = clienttime - g_localDeltaTime_pvp --(Local = Host + deltaTime)
					local heartTime = oWorld.data.heartTime --心跳包上次收到的时间
					local deltatime = hosttime - heartTime
					--print("__TD__PVP_HEART_timer", hosttime, heartTime, deltatime)
					
					--print(delta_systime)
					
					if (deltatime >= 5) then --大于5秒，认为可能断了
						--更新心跳包剩余等待时间（秒）
						oWorld.data.leftHeartTime = math.max(oWorld.data.leftHeartTime - delta_systime, 0)
						
						--显示本地长时间未响应的界面
						hApi.ShowPlayerNoHeartFrm(1)
					else
						--隐藏本地长时间未响应的界面
						hApi.ShowPlayerNoHeartFrm(0)
					end
				end
			end)
			
			--监听重练失败事件
			hGlobal.event:listen("LocalEvent_Pvp_ReLogin_Fail", "_Pvp_ReLogin_Fail_EVENT_", function(errorStr)
				--断开pvp连接
				Pvp_Server:Close()
				
				local world = hGlobal.WORLD.LastWorldMap
				if world then
					--重置心跳包剩余等待时间（毫秒）
					world.data.leftHeartTime = 0
					
					--重置心跳包上次收到的时间
					world.data.heartTime = 0
				end
			end)
		else --其他模式
			--pvp的游戏时间、ping值
			local _frm = hGlobal.UI.TDSystemMenuBar
			if _frm.childUI["PVP_GameTime"] then
				_frm.childUI["PVP_GameTime"]:setText("")
			end
			if _frm.childUI["PVP_PingPrefixLabel"] then
				_frm.childUI["PVP_PingPrefixLabel"]:setText("")
			end
			if _frm.childUI["PVP_PingLabel"] then
				_frm.childUI["PVP_PingLabel"]:setText("")
			end
			
			--低配模式文字提示
			if _frm.childUI["LowConfigModeLabel"] then
				if (oWorld.data.client_fps == 60) then
					_frm.childUI["LowConfigModeLabel"]:setText("")
				else
					_frm.childUI["LowConfigModeLabel"]:setText(hVar.tab_string["lowconfig"])
				end
			end
			
			--无尽地图的得分
			--大菠萝都显示
			local diablodata = hGlobal.LocalPlayer.data.diablodata --大菠萝数据
			if (diablodata ~= 0) then
				--if _frm.childUI["Endless_ScorePrefixLabel"] then
				--	if (diablodata.deathcount == 0) then
				--		_frm.childUI["Endless_ScorePrefixLabel"]:setText("死亡: 0")
				--	else
				--		--_frm.childUI["Endless_ScorePrefixLabel"]:setText("死亡:" .. diablodata.deathcount .. "      首局得分:" .. diablodata.deathscore .. " ")
				--		_frm.childUI["Endless_ScorePrefixLabel"]:setText("死亡: " .. diablodata.deathcount)
				--	end
				--	--_frm.childUI["Endless_ScorePrefixLabel"]:setText("") --"得分" "得分:"
				--end
				--if _frm.childUI["Endless_ScoreLabel"] then
				--	_frm.childUI["Endless_ScoreLabel"]:setText(diablodata.score)
				--end
			end
			
			--英雄头像栏，上移
			local _frm = hGlobal.UI.HeroFrame
			_frm:setXY(40, hVar.SCREEN.h - 105)
			
			--删除左下角操作框
			if (_frm.childUI["hero_bg_img_btn1"]) then
				_frm.childUI["hero_bg_img_btn1"]:del()
				_frm.childUI["hero_bg_img_btn1"] = nil
			end
		end
		
		--正常模式，刷新小BOSS倒计时timer
		if (oWorld.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.NORMAL) then
			local _frm = hGlobal.UI.TDSystemMenuBar
			if _frm.childUI["TINYBOSS_ScorePrefixImage"] then
				_frm.childUI["TINYBOSS_ScorePrefixImage"].handle._n:setVisible(false)
			end
			if _frm.childUI["TINYBOSS_ScorePrefixBoss"] then
				_frm.childUI["TINYBOSS_ScorePrefixBoss"].handle._n:setVisible(false)
			end
			if _frm.childUI["TINYBOSS_ScorePrefixLabel"] then
				_frm.childUI["TINYBOSS_ScorePrefixLabel"].handle._n:setVisible(false)
			end
			
			--更新小BOSS出现倒计时
			oWorld:addtimer("__TD__TINYBOSS_GAMETIME_timer", 100, function()
				local _frm = hGlobal.UI.TDSystemMenuBar
				local tinyboss_occurtime = oWorld.data.tinyboss_occurtime --小BOSS倒计时
				--print(tinyboss_occurtime)
				if (tinyboss_occurtime > 0) then --正在倒计时
					local lefttime = oWorld.data.tinyboss_occurtime - oWorld:gametime()
					if (lefttime >= 0) then
						if _frm.childUI["TINYBOSS_ScorePrefixLabel"] then
							--更新时间
							local gametime = lefttime
							local seconds = math.ceil(gametime / 1000)
							local minute = math.floor(seconds / 60)
							local second = seconds - minute * 60
							local strSecond = tostring(second)
							if (second < 10) then
								strSecond = "0" .. strSecond
							end
							local strMinute = tostring(minute)
							if (minute < 10) then
								strMinute = "0" .. strMinute
							end
							_frm.childUI["TINYBOSS_ScorePrefixLabel"]:setText(strMinute .. ":" .. strSecond)
						end
					else
						--已出现小BOSS
						--隐藏界面
						if _frm.childUI["TINYBOSS_ScorePrefixImage"] then
							_frm.childUI["TINYBOSS_ScorePrefixImage"].handle._n:setVisible(false)
						end
						if _frm.childUI["TINYBOSS_ScorePrefixBoss"] then
							_frm.childUI["TINYBOSS_ScorePrefixBoss"].handle._n:setVisible(false)
						end
						if _frm.childUI["TINYBOSS_ScorePrefixLabel"] then
							_frm.childUI["TINYBOSS_ScorePrefixLabel"].handle._n:setVisible(false)
						end
						--print("隐藏界面")
						
						--标记为0
						tinyboss_occurtime = 0
						oWorld.data.tinyboss_occurtime = 0
					end
				elseif (tinyboss_occurtime < 0) then --还未倒计时
					local round = oWorld.data.pvp_round --游戏层数
					if (round > 1) then
						--显示界面
						if _frm.childUI["TINYBOSS_ScorePrefixImage"] then
							_frm.childUI["TINYBOSS_ScorePrefixImage"].handle._n:setVisible(true)
						end
						if _frm.childUI["TINYBOSS_ScorePrefixBoss"] then
							_frm.childUI["TINYBOSS_ScorePrefixBoss"].handle._n:setVisible(true)
						end
						if _frm.childUI["TINYBOSS_ScorePrefixLabel"] then
							_frm.childUI["TINYBOSS_ScorePrefixLabel"].handle._n:setVisible(true)
						end
						
						--计算倒计时
						local w = oWorld
						local mapInfo = w.data.tdMapInfo
						--遍历所有的出兵点
						for bpTgrId,bpInfo in pairs(mapInfo.beginPointList) do
							--开始波次小于等于总波次，才执行出兵逻辑
							if mapInfo.totalWave >= bpInfo.beginWave then
								--计算当前波次和出兵波次相差几个波次
								local maxWave = mapInfo.wave - bpInfo.beginWave + 1
								
								--循环该起点每个波次的出兵列表
								for i = 1, mapInfo.totalWave, 1 do
									local waveInfo = bpInfo.unitPerWave[i]
									local waveNow = bpInfo.beginWave - 1 + i
									local beginStage = bpInfo.beginStage --发兵开始的层数
									local stageNow = w.data.pvp_round --当前层数
									--小地图发兵信息
									if (beginStage > 1) then
										
										--print("waveNow=", waveNow, i)
										--print("maxWave=", maxWave)
										
										--判断是否存在波次信息
										if waveInfo then
											for j = #waveInfo.unitInfoList, 1, -1 do
												local unitSetInfo = waveInfo.unitInfoList[j]
												local nextDelay = unitSetInfo.nextDelay
												local formation = unitSetInfo.formation
												local beginTime = waveInfo.beginTime
												--print(i, "beginTime=", beginTime, waveInfo.delay)
												--print("w:gametime()=", w:gametime())
												--print("nextDelay=", nextDelay)
												--出兵
												--print(unitSetInfo.beginTime,w:gametime(),beginStage)
												--print("nextDelay=", nextDelay)
												for k = #unitSetInfo.unitList, 1, -1 do
													--出单个怪
													
													--beginPos = {x = beginPosInfo.x, y = beginPosInfo.y,faceTo = beginPosInfo.faceTo,isHide = beginPosInfo.isHide}
													--mapInfo.pathList[unitSetInfo.path]
													local unit = unitSetInfo.unitList[k]
													local id = unit.id
													--print(j,k, id,nextDelay)
													
													--小地图BOSS
													--if (id == 13029) or (id == 13030) or (id == 13024) or (id == 13025) or (id == 13027) or (id == 11217) then
													if hVar.tab_unit[id].tag and hVar.tab_unit[id].tag[hVar.UNIT_TAG_TYPE.OTHER.TAG_BOSS] then
														local delayTimeSum = 0
														--for t = 1, i, 1 do
														--	delayTimeSum = delayTimeSum + nextDelay
														--end
														--print("delayTimeSum=", delayTimeSum)
														tinyboss_occurtime = w:gametime() + mapInfo.beginTimeDelayPerWave[i]
														oWorld.data.tinyboss_occurtime = tinyboss_occurtime
														
														--更新小BOSS图标
														local ctrli = _frm.childUI["TINYBOSS_ScorePrefixBoss"]
														if ctrli then
															ctrli:setmodel(hVar.tab_unit[id].icon, nil, ctrli.data.w, ctrli.data.h)
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
				end
			end)
		else
			local _frm = hGlobal.UI.TDSystemMenuBar
			if _frm.childUI["TINYBOSS_ScorePrefixImage"] then
				_frm.childUI["TINYBOSS_ScorePrefixImage"].handle._n:setVisible(false)
			end
			if _frm.childUI["TINYBOSS_ScorePrefixBoss"] then
				_frm.childUI["TINYBOSS_ScorePrefixBoss"].handle._n:setVisible(false)
			end
			if _frm.childUI["TINYBOSS_ScorePrefixLabel"] then
				_frm.childUI["TINYBOSS_ScorePrefixLabel"].handle._n:setVisible(false)
			end
		end
		
		--单独初始化刷新游戏的层数
		local round = oWorld.data.pvp_round --游戏层数
		if (round == 0) then
			round = 1
		end
		hGlobal.event:event("Event_UpdateGameRound", round)
		
		--------------------------------------------------------
		--geyachao: pvp模式，为了防止玩家恶意刷游戏局
		--在游戏局开始的时候，记录一下本局游戏对战的对手
		if (oWorld.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
			--找到对手
			local userId_Enemy = 0 --对手的uid
			local userName_Enemy = "" --对手的名字
			local forceMe = oWorld:GetPlayerMe():getforce()
			for i = 1, 20, 1 do
				local player_i = oWorld.data.PlayerList[i]
				if player_i then
					local force_i = player_i:getforce()
					if(force_i ~= forceMe) then
						if (player_i:gettype() == 1) then --0空 1玩家 2简单电脑 3中等电脑 4困难电脑 5大师电脑 6专家电脑
							userId_Enemy = player_i.data.dbid --找到了
							userName_Enemy = player_i.data.name
							break
						end
					end
				end
			end
			if (userId_Enemy > 0) then
				local session_dbId = oWorld.data.session_dbId --本局的游戏局唯一id
				local userId = userId_Enemy --本局的对手id
				local userName = userName_Enemy --本局的对手名字
				local bUseEquip = oWorld.data.bUseEquip --本局是否携带状态
				local pvpcoinCost = 0 --本局消耗的兵符
				local gametime = 0 --本局的游戏时长(秒)
				LuaAddPVPUserInfo(g_curPlayerName, session_dbId, userId, userName, bUseEquip, pvpcoinCost, gametime)
			end
		end
		--------------------------------------------------------
		
		--collectgarbage timer
		--hApi.addTimerForever("__TD__COLLECTGARBAGE_Timer", hVar.TIMER_MODE.GAMETIME, 60000, function()
		--	collectgarbage()
		--end)
		
		--监听内存警告事件，回收内存
		--geyachao: 暂时注释掉
		--hGlobal.event:listen("LocalEvent_MemoryWarning", "__COLLECTGARBAGE_",function(nCount)
		--	collectgarbage()
		--end)
		
		--地图上的单位自动放技能的timer
		--hApi.addTimerForever("__TD__CAST_SKILL_Timer", hVar.TIMER_MODE.GAMETIME, 100, function()
		oWorld:addtimer("__TD__CAST_SKILL_Timer", 100, function()
			--地图上的角色自动释放技能timer
			AI_CastSkill_Loop_Timer()
			
			--检测中立无敌意单位自动进入沉睡状态
			Check_auto_sleep()
		end)
		
		--地图上的单位自动检测生存时间的timer
		--hApi.addTimerForever("__TD__UNIT_LIVETIME__Timer", hVar.TIMER_MODE.GAMETIME, 100, function()
		oWorld:addtimer("__TD__UNIT_LIVETIME__Timer1", 140, function()
			--地图上的角色生存时间timer
			AI_Unit_LiveTime_Loop_Timer()
		end)
		
		--地图上的单位检测复活的timer
		--hApi.addTimerForever("__TD__UNIT_LIVETIME__Timer", hVar.TIMER_MODE.GAMETIME, 100, function()
		oWorld:addtimer("__TD__UNIT_LIVETIME__Timer2", 100, function()
			--检测复活
			Check_Hero_Rebirth_loop()
		end)
		
		--绘制地图上所有角色包围盒的timer
		--hApi.addTimerForever("__TD__PAINT_BOX_TIMER_", hVar.TIMER_MODE.GAMETIME, 100, function()
		oWorld:addtimer("__TD__PAINT_BOX_TIMER_", 1, function()
			TD_Paint_Box_Timer()
			TD_Paint_EffBox_Timer()
			TD_Paint_WaterBox_Timer()
			TD_Paint_DynamicBlock_Timer()
			TD_Paint_Box_Dynamic_Timer()
			
			TD_Paint_RandommapRoom_Timer()
			TD_Paint_RandommapGroup_Timer()
		end)
		
		--TD角色移动timer
		--hApi.addTimerForever("__TD__UnitArriveNew", hVar.TIMER_MODE.GAMETIME, 1, function(currentTime, deltaTime, tickTime)
		oWorld:addtimer("__TD__UnitArriveNew", 1, function(deltaTime)
			if TD_UnitArriveNew_Loop then
				--TD_UnitArriveNew_Loop(deltaTime + tickTime)
				--print(deltaTime)
				TD_UnitArriveNew_Loop(deltaTime)
			end
		end)
		
		--TD执行指令序列
		--hApi.addTimerForever("__TD__CommandSequence", hVar.TIMER_MODE.GAMETIME, 1, function()
		oWorld:addtimer("__TD__CommandSequence", 1, function()
			--执行指令序列
			hApi.RunCommandSequence()
		end)
		
		--TD角色自动回血timer
		--hApi.addTimerForever("__TD__UnitHpRecover", hVar.TIMER_MODE.GAMETIME, 1000, function()
		oWorld:addtimer("__TD__UnitHpRecover", 1000, function()
			--自动回血处理
			TD_Unit_Hp_Restore()
			
			--每秒刷新界面
			TD_RefreshUIOneSec()
		end)
		
		--hApi.addTimerForever("__TD__MainLogic", hVar.TIMER_MODE.GAMETIME, 200, function()
		oWorld:addtimer("__TD__MainLogic", 200, function()
			--关卡的定时器对话loop
			if TD_TalkScript_Loop then
				TD_TalkScript_Loop()
			end
			
			--TD发兵
			if (hVar.OPTIONS.INVASION_FLAG == 1) then --发兵开关
				if TD_Invasion_Loop then
					TD_Invasion_Loop()
				end
			end
			
			--TD野怪
			if (hVar.OPTIONS.INVASION_FLAG == 1) then --发兵开关
				if TD_WildBirth_Loop then
					TD_WildBirth_Loop()
				end
			end
			
			--TD传送门
			if TD_Portal_Loop then
				TD_Portal_Loop()
			end
			
			--大菠萝穿越区域
			if TD_PassThrough_Loop then
				TD_PassThrough_Loop()
			end
			
			--大菠萝区域触发
			if TD_AreaTrigger_Loop then
				TD_AreaTrigger_Loop()
			end
			
			--检查
			if CheckUnitEventLoop then
				CheckUnitEventLoop()
			end
			
			--每波怪物死亡后固定清除指定显存
			if TD_CollectGarbage_PerWave then
				TD_CollectGarbage_PerWave()
			end
			
			if TD_CheckGameEnd_Loop then
				TD_CheckGameEnd_Loop()
			end
		end)
		
		--zhenkira,地图AI初始化
		TD_MapAIInit()
		
		--zhenkira,地图AIloop
		oWorld:addtimer("__TD__MapAI", 200, function()
			if TD_MapAILoop then
				TD_MapAILoop()
			end
		end)
		
		--zhenkira,注册地图AI事件
		TD_MapAIEventListen()
		
		--启用world的timer
		oWorld:enableTimer()
		
		local vc = VitrualController:create()
		local scene = xlGetScene() --设置基本scene
		--scene:addChild(vc.layer, 40000)
		scene:addChild(vc, 40000)
		
		--存储虚拟摇杆控件
		oWorld.data.__virtualController = vc
		
		--不滑屏
		xlScene_SetViewMovable(g_world, 0)
		
		
		--====================================
		
		--TD有路点单位移动到达事件回调
		--TD有路点单位移动到达回调事件
		hGlobal.event:listen("Event_UnitArrive_TD", "TD_RoadUnitMove_TD", function(oUnit, nIsSuccess, callbackSkillId)
			--有路点单位
			--if (oUnit:getowner() == hGlobal.EnemyPlayer) or (oUnit:getowner() == hGlobal.NeutralPlayer) then --中立或者敌方阵营
			
			if (oUnit:getRoadPointType() ~= hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_NONE) then --有路点
			--if  (roadPoint ~= 0) then
				
				local aiState = oUnit:getAIState() --角色的AI状态
				--print("move_callback", "nIsSuccess=" .. nIsSuccess, oUnit.__ID)
				if (aiState == hVar.UNIT_AI_STATE.MOVE) or (aiState == hVar.UNIT_AI_STATE.MOVE_TANK) or (aiState == hVar.UNIT_AI_STATE.MOVE_TANK_NEARBY) then --原来为移动AI状态
					local roadPoint = oUnit:getRoadPoint() --角色路点
					
					if roadPoint and type(roadPoint) == "table" then
						--删除路点第一项
						local currentRoad = roadPoint
						
						--设置是否隐身
						if currentRoad.isHide and (currentRoad.isHide > 0) then
							oUnit:SetYinShenState(1)
							
							--绑定的单位也隐身
							local bind_unit = oUnit.data.bind_unit
							if bind_unit and (bind_unit ~= 0) then
								bind_unit:SetYinShenState(1)
							end
							
							--绑定的武器也隐身
							local bind_weapon = oUnit.data.bind_weapon
							if bind_weapon and (bind_weapon ~= 0) then
								bind_weapon:SetYinShenState(1)
							end
						else
							oUnit:SetYinShenState(0)
							
							--绑定的单位也取消隐身
							local bind_unit = oUnit.data.bind_unit
							if bind_unit and (bind_unit ~= 0) then
								bind_unit:SetYinShenState(0)
							end
							
							--绑定的武器也取消隐身
							local bind_weapon = oUnit.data.bind_weapon
							if bind_weapon and (bind_weapon ~= 0) then
								bind_weapon:SetYinShenState(0)
							end
						end
						
						--设置敌方、中立单位状态为闲置
						oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
						
						oUnit:setRoadPointNext()
						
					elseif roadPoint == -1 then
						oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
					end
					
					
					--xlLG("RoadPoint", "小兵到达路点, unit=" .. tostring(oUnit.data.name) .. "_" .. tostring(oUnit.__ID) .. ", 剩余路点_num=" .. #(oUnit:getRoadPoint()) .. "\n")
				elseif (aiState == hVar.UNIT_AI_STATE.FOLLOW) then --原来为跟随状态
					if (nIsSuccess == 1) then --成功到达目标（点）位置
						--设置状态为攻击
						oUnit:setAIState(hVar.UNIT_AI_STATE.ATTACK)
					else --寻路失败（可能原地不动）
						--取消锁定的目标
						local lockTarget = oUnit.data.lockTarget
						
						--距离太远，取消锁定
						--oUnit.data.lockTarget = 0 --锁定攻击的目标
						--print("lockTarget = 0 57", oUnit.__ID)
						--oUnit.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
						hApi.UnitTryToLockTarget(oUnit, 0, 0)
						--print("lockType 49", oUnit.data.name, 0)
						
						--目标不需要解除对它的锁定（因为它自己是寻路失败取消的）
						--检测目标是否也解除对敌方小兵的锁定
						--[[
						if (lockTarget.data.lockTarget == oUnit) then
							if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
								lockTarget.data.lockTarget = 0
								--print("lockTarget = 0 56", lockTarget.__ID)
								lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
								--print("lockType 53", lockTarget.data.name, 0)
							end
						end
						]]
						
						--设置为闲置状态
						oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
					end
				elseif (aiState == hVar.UNIT_AI_STATE.MOVE_TO_POINT) then --有路点单位原来为移动到达目标点后释放战术技能状态
					--设置为闲置状态
					oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
					
					--尝试再放战术技能
					local oPlayer = oUnit:getowner()
					local worldX = oUnit.data.op_point_x --等待操作的移动到达的目标点x
					local worldY = oUnit.data.op_point_y --等待操作的移动到达的目标点y
					local tacticId = oUnit.data.op_tacticId --等待操作的移动到达目标点后释放的战术技能id
					local itemId = oUnit.data.op_itemId --等待操作的移动到达目标点后释放的道具技能id
					local tacticX = oUnit.data.op_tacticX --等待操作的移动到达目标点后战术技能x坐标
					local tacticY = oUnit.data.op_tacticY --等待操作的移动到达目标点后战术技能y坐标
					local t_worldI = oUnit.data.op_t_worldI --等待操作的移动到达目标点后战术技能目标worldI
					local t_worldC = oUnit.data.op_t_worldC --等待操作的移动到达目标点后战术技能目标worldC
					if oPlayer and ((tacticId and (tacticId ~= 0)) or (itemId and (itemId ~= 0))) then
						hApi.UsePlayerTacticCard(oPlayer, tacticId, itemId, tacticX, tacticY, t_worldI, t_worldC)
					end
				elseif (aiState == hVar.UNIT_AI_STATE.MOVE_TO_POINT_CASTSKILL) then --有路点单位原来为移动到达目标点后继续释放技能
					--设置为闲置状态
					oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
					
					--继续释放技能
					local oAction = oUnit.data.op_skillAction --等待操作的移动到达目标点后释放的技能action
					if oAction and (oAction ~= 0) then
						oAction.data.tick = 1
					end
				elseif (aiState == hVar.UNIT_AI_STATE.FOLLOW_TO_TARGET) then --有路点单位原来为移动到达目标后释放战术技能状态
					--设置为闲置状态
					oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
					
					--尝试再放战术技能
					local oPlayer = oUnit:getowner()
					local worldX = oUnit.data.op_point_x --等待操作的移动到达的目标点x
					local worldY = oUnit.data.op_point_y --等待操作的移动到达的目标点y
					local tacticId = oUnit.data.op_tacticId --等待操作的移动到达目标点后释放的战术技能id
					local itemId = oUnit.data.op_itemId --等待操作的移动到达目标点后释放的道具技能id
					local tacticX = oUnit.data.op_tacticX --等待操作的移动到达目标点后战术技能x坐标
					local tacticY = oUnit.data.op_tacticY --等待操作的移动到达目标点后战术技能y坐标
					local t_worldI = oUnit.data.op_t_worldI --等待操作的移动到达目标点后战术技能目标worldI
					local t_worldC = oUnit.data.op_t_worldC --等待操作的移动到达目标点后战术技能目标worldC
					if oPlayer and ((tacticId and (tacticId ~= 0)) or (itemId and (itemId ~= 0))) then
						hApi.UsePlayerTacticCard(oPlayer, tacticId, itemId, tacticX, tacticY, t_worldI, t_worldC)
					end
				elseif (aiState == hVar.UNIT_AI_STATE.MOVE_ADJUST) then --原来为移动调整状态
					--设置状态为攻击
					oUnit:setAIState(hVar.UNIT_AI_STATE.ATTACK)
				elseif (aiState == hVar.UNIT_AI_STATE.MOVE_CHAOS) then --移动混乱状态（单位无目的乱走）
					--标记守卫点
					local t_x, t_y = hApi.chaGetPos(oUnit.handle) --当前坐标
					oUnit.data.defend_x = t_x
					oUnit.data.defend_y = t_y
					
					--单位开始进入混乱状态，随机移动到附近的某个坐标点
					hApi.UnitBeginChaos(oUnit)
				elseif (aiState == hVar.UNIT_AI_STATE.MOVE_HOSTAGE_ChAOS) then --人质移动混乱状态（单位无目的乱走）
					--标记守卫点
					local t_x, t_y = hApi.chaGetPos(oUnit.handle) --当前坐标
					oUnit.data.defend_x = t_x
					oUnit.data.defend_y = t_y
					
					--单位开始进入混乱状态，人质随机移动到附近的某个坐标点，或者移动到坦克身边
					hApi.UnitBeginHostageChaos(oUnit)
				elseif (aiState == hVar.UNIT_AI_STATE.MOVE_HOSTAGE_TANK) then --人质移动混乱状态（单位无目的乱走）
					--标记守卫点
					local t_x, t_y = hApi.chaGetPos(oUnit.handle) --当前坐标
					oUnit.data.defend_x = t_x
					oUnit.data.defend_y = t_y
					
					--单位开始进入混乱状态，人质随机移动到附近的某个坐标点，或者移动到坦克身边
					hApi.UnitBeginHostageChaos(oUnit)
				elseif (aiState == hVar.UNIT_AI_STATE.MOVE_BY_TRACK) then --原来为滑行状态
					--设置当前集合点是此刻坐标
					
					--取消滑行状态
					hApi.RemoveStunState(oUnit)
				end
			end
		end)
		
		--TD无路点单位移动到达事件回调
		--TD无路点单位移动到达事件事件
		hGlobal.event:listen("Event_UnitArrive_TD", "TD_NoRoadUnitMove_TD", function(oUnit, nIsSuccess, callbackSkillId)
			--local roadPoint = oUnit:getRoadPoint() --角色路点
			--if (roadPoint == 0) then --无路点
			if (oUnit:getRoadPointType() == hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_NONE) then
				--print("我方无路点单位移动到达", oUnit.data.name .. "_" .. oUnit.__ID, nIsSuccess)
				local aiState = oUnit:getAIState() --角色的AI状态
				--print(aiState, nIsSuccess)
				
				if (aiState == hVar.UNIT_AI_STATE.MOVE) or (aiState == hVar.UNIT_AI_STATE.MOVE_TANK) or (aiState == hVar.UNIT_AI_STATE.MOVE_TANK_NEARBY) then --原来为移动AI状态
					if (nIsSuccess == 1) then --成功到达目标（点）位置
						--设置状态为攻击
						oUnit:setAIState(hVar.UNIT_AI_STATE.ATTACK)
					else --寻路失败（可能原地不动）
						--设置为闲置状态
						oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
					end
					--xlLG("RoadPoint", "小兵到达路点, unit=" .. tostring(oUnit.data.name) .. "_" .. tostring(oUnit.__ID) .. ", 剩余路点_num=" .. #(oUnit:getRoadPoint()) .. "\n")
				elseif (aiState == hVar.UNIT_AI_STATE.FOLLOW) then --原来为跟随状态
					if (nIsSuccess == 1) then --成功到达目标（点）位置
						--如果是主动锁定的类型，那么标记单位的新守卫点是当前点
						if (oUnit.data.lockType == 1) then
							--重置英雄的守卫点(目标的当前坐标)
							local t_x, t_y = hApi.chaGetPos(oUnit.handle) --当前坐标
							oUnit.data.defend_x = t_x
							oUnit.data.defend_y = t_y
						end
						
						--拾取道具
						local lockTarget = oUnit.data.lockTarget
						if lockTarget and (lockTarget ~= 0) and (lockTarget.data.type == hVar.UNIT_TYPE.ITEM) then
							--锁定空角色
							hApi.UnitTryToLockTarget(oUnit, 0, 0)
							
							--本地拾取道具
							--if (oUnit:getowner() == oUnit:getworld():GetPlayerMe()) then
							--	--发送指令-拾取道具
							--	hApi.AddCommand(hVar.Operation.PickUpItem, oUnit:getworldI(), oUnit:getworldC(), lockTarget:getworldI(), lockTarget:getworldC())
							--end
							--拾取道具
							hVar.CmdMgr[hVar.Operation.PickUpItem](oUnit:getworld().data.sessionId, oUnit:getowner(), oUnit:getworldI(), oUnit:getworldC(), lockTarget:getworldI(), lockTarget:getworldC())
							
							--设置为闲置状态
							oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
						else
							--设置状态为攻击
							oUnit:setAIState(hVar.UNIT_AI_STATE.ATTACK)
						end
					else --寻路失败（可能原地不动）
						--取消锁定的目标
						local lockTarget = oUnit.data.lockTarget
						
						--距离太远，取消锁定
						--oUnit.data.lockTarget = 0 --锁定攻击的目标
						--print("lockTarget = 0 55", oUnit.__ID)
						--oUnit.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
						hApi.UnitTryToLockTarget(oUnit, 0, 0)
						--print("lockType 49", oUnit.data.name, 0)
						
						--目标不需要解除对它的锁定（因为它自己是寻路失败取消的）
						--检测目标是否也解除对敌方小兵的锁定
						--[[
						if (lockTarget.data.lockTarget == oUnit) then
							if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
								lockTarget.data.lockTarget = 0
								--print("lockTarget = 0 54", lockTarget.__ID)
								lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
								--print("lockType 50", lockTarget.data.name, 0)
							end
						end
						]]
						
						--设置为闲置状态
						oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
					end
				elseif (aiState == hVar.UNIT_AI_STATE.MOVE_TO_POINT) then --无路点单位原来为移动到达目标点后释放战术技能状态
					--设置为闲置状态
					oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
					
					--尝试再放战术技能
					local oPlayer = oUnit:getowner()
					local worldX = oUnit.data.op_point_x --等待操作的移动到达的目标点x
					local worldY = oUnit.data.op_point_y --等待操作的移动到达的目标点y
					local tacticId = oUnit.data.op_tacticId --等待操作的移动到达目标点后释放的战术技能id
					local itemId = oUnit.data.op_itemId --等待操作的移动到达目标点后释放的道具技能id
					local tacticX = oUnit.data.op_tacticX --等待操作的移动到达目标点后战术技能x坐标
					local tacticY = oUnit.data.op_tacticY --等待操作的移动到达目标点后战术技能y坐标
					local t_worldI = oUnit.data.op_t_worldI --等待操作的移动到达目标点后战术技能目标worldI
					local t_worldC = oUnit.data.op_t_worldC --等待操作的移动到达目标点后战术技能目标worldC
					if oPlayer and ((tacticId and (tacticId ~= 0)) or (itemId and (itemId ~= 0))) then
						hApi.UsePlayerTacticCard(oPlayer, tacticId, itemId, tacticX, tacticY, t_worldI, t_worldC)
					end
				elseif (aiState == hVar.UNIT_AI_STATE.MOVE_TO_POINT_CASTSKILL) then --无路点单位原来为移动到达目标点后继续释放技能
					--print("无路点单位原来为移动到达目标点后继续释放技能", oUnit.data.name)
					
					--设置为闲置状态
					oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
					
					--继续释放技能
					local oAction = oUnit.data.op_skillAction --等待操作的移动到达目标点后释放的技能action
					--print("oAction=", oAction)
					if oAction and (oAction ~= 0) then
						oUnit.data.op_skillAction = 0
						oAction.data.tick = 1
					end
				elseif (aiState == hVar.UNIT_AI_STATE.FOLLOW_TO_TARGET) then --无路点单位原来为移动到达目标后释放战术技能状态
					--设置为闲置状态
					oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
					
					--尝试再放战术技能
					local oPlayer = oUnit:getowner()
					local worldX = oUnit.data.op_point_x --等待操作的移动到达的目标点x
					local worldY = oUnit.data.op_point_y --等待操作的移动到达的目标点y
					local tacticId = oUnit.data.op_tacticId --等待操作的移动到达目标点后释放的战术技能id
					local itemId = oUnit.data.op_itemId --等待操作的移动到达目标点后释放的道具技能id
					local tacticX = oUnit.data.op_tacticX --等待操作的移动到达目标点后战术技能x坐标
					local tacticY = oUnit.data.op_tacticY --等待操作的移动到达目标点后战术技能y坐标
					local t_worldI = oUnit.data.op_t_worldI --等待操作的移动到达目标点后战术技能目标worldI
					local t_worldC = oUnit.data.op_t_worldC --等待操作的移动到达目标点后战术技能目标worldC
					if oPlayer and ((tacticId and (tacticId ~= 0)) or (itemId and (itemId ~= 0))) then
						hApi.UsePlayerTacticCard(oPlayer, tacticId, itemId, tacticX, tacticY, t_worldI, t_worldC)
					end
				elseif (aiState == hVar.UNIT_AI_STATE.MOVE_ADJUST) then --无路点单位原来为移动调整状态
					--设置状态为攻击
					oUnit:setAIState(hVar.UNIT_AI_STATE.ATTACK)
				elseif (aiState == hVar.UNIT_AI_STATE.MOVE_CHAOS) then --移动混乱状态（单位无目的乱走）
					--标记守卫点
					local t_x, t_y = hApi.chaGetPos(oUnit.handle) --当前坐标
					oUnit.data.defend_x = t_x
					oUnit.data.defend_y = t_y
					
					--单位开始进入混乱状态，随机移动到附近的某个坐标点
					hApi.UnitBeginChaos(oUnit)
				elseif (aiState == hVar.UNIT_AI_STATE.MOVE_HOSTAGE_ChAOS) then --人质移动混乱状态（单位无目的乱走）
					--标记守卫点
					local t_x, t_y = hApi.chaGetPos(oUnit.handle) --当前坐标
					oUnit.data.defend_x = t_x
					oUnit.data.defend_y = t_y
					
					--单位开始进入混乱状态，人质随机移动到附近的某个坐标点，或者移动到坦克身边
					hApi.UnitBeginHostageChaos(oUnit)
				elseif (aiState == hVar.UNIT_AI_STATE.MOVE_HOSTAGE_TANK) then --人质移动混乱状态（单位无目的乱走）
					--标记守卫点
					local t_x, t_y = hApi.chaGetPos(oUnit.handle) --当前坐标
					oUnit.data.defend_x = t_x
					oUnit.data.defend_y = t_y
					
					--单位开始进入混乱状态，人质随机移动到附近的某个坐标点，或者移动到坦克身边
					hApi.UnitBeginHostageChaos(oUnit)
				elseif (aiState == hVar.UNIT_AI_STATE.MOVE_BY_TRACK) then --原来为滑行状态
					--取消滑行状态
					hApi.RemoveStunState(oUnit)
				end
				
				--我方第1个英雄，继续移动
				if (nIsSuccess == 1) then
					local world = hGlobal.WORLD.LastWorldMap
					local me = world:GetPlayerMe()
					if me then
						local heros = me.heros
						if heros then
							local oHero = heros[1]
							if oHero then
								local u = oHero:getunit()
								if (u == oUnit) then
									--print("我方第1个英雄")
									if (world.data.keypadWASD ~= "----") then
										--触发按键事件
										hGlobal.event:event("LocalEvent_KeypadEvent", world.data.keypadWASD)
									else
										--触发事件
										local self = world.data.__virtualController
										if self and (self ~= 0) then
											hGlobal.event:event("LocalEvent_VitrualControllerUpdate", "move", self, self._directioX, self._directioY, distance)
										end
									end
								end
							end
						end
					end
				end
			end
		end)
		
		--TD角色眩晕、僵直、混乱、沉睡状态发生变化事件
		hGlobal.event:listen("Event_UnitStunStaticState", "TD_UnitSunStatic_TD", function(oUnit, stun, static, chaos, sleep)
		--print("角色眩晕或僵直状态发生变化事件", oUnit.data.name, stun, static, chaos)
			--检测角色是否有缓存操作去执行
			--角色不能在眩晕(滑行)、不在僵直中、不在混乱中、不在沉睡中
			if (oUnit.attr.stun_stack == 0) and (oUnit:getAIState() ~= hVar.UNIT_AI_STATE.CAST_STATIC) and (oUnit.attr.suffer_chaos_stack == 0) and (oUnit.attr.suffer_sleep_stack == 0) then
				--角色有缓存操作
				if (oUnit.data.op_state == 1) then
					local w = hGlobal.WORLD.LastWorldMap
					
					--检测是需要移动到目标点，还是跟随目标
					local op_target = oUnit.data.op_target --等待操作的移动到达的目标
					local op_target_worldC = oUnit.data.op_target_worldC --等待操作的移动到达的目标唯一id
					local worldX = oUnit.data.op_point_x --等待操作的移动到达的目标点x
					local worldY = oUnit.data.op_point_y --等待操作的移动到达的目标点y
					local tacticId = oUnit.data.op_tacticId --等待操作的移动到达目标点后释放的战术技能id
					local itemId = oUnit.data.op_itemId --等待操作的移动到达目标点后释放的道具技能id
					local tacticX = oUnit.data.op_tacticX --等待操作的移动到达目标点后战术技能x坐标
					local tacticY = oUnit.data.op_tacticY --等待操作的移动到达目标点后战术技能y坐标
					local t_worldI = oUnit.data.op_t_worldI --等待操作的移动到达目标点后战术技能目标worldI
					local t_worldC = oUnit.data.op_t_worldC --等待操作的移动到达目标点后战术技能目标worldC
					
					--存在目标，并且目标活着，并且目标没被复用，才算有效的目标
					if (op_target ~= 0) and (op_target.data.IsDead ~= 1) and (op_target_worldC == op_target:getworldC()) then
						--有效的目标，角色跟随目标
						--清除缓存操作
						oUnit.data.op_state = 0 --清除缓存操作
						
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
						
						--标记AI状态为跟随
						oUnit:setAIState(hVar.UNIT_AI_STATE.FOLLOW)
						
						--如果存在要释放的战术技能
						if ((tacticId and (tacticId ~= 0)) or (itemId and (itemId ~= 0))) then
							--标记AI状态为移动到达目标点后释放战术技能
							oUnit:setAIState(hVar.UNIT_AI_STATE.FOLLOW_TO_TARGET)
						end
						
						--先停掉角色原先的技能释放
						hApi.StopSkillCast(oUnit)
						
						--重置英雄的守卫点(目标的当前坐标)
						local t_x, t_y = hApi.chaGetPos(op_target.handle) --英雄的坐标
						oUnit.data.defend_x = t_x
						oUnit.data.defend_y = t_y
						
						--发起移动(锁定目标）(英雄计算障碍)
						hApi.UnitMoveToTarget_TD(oUnit, op_target, oUnit:GetAtkRange() - hVar.MOVE_EXTRA_DISTANCE, true) --24距离的缓冲
						
						--锁定攻击的目标
						--因为发起了移动，锁定新目标
						local old_lockTarget = oUnit.data.lockTarget --原先锁定的目标
						--如果原目标也锁定的是角色，那么取消原目标锁定攻击英雄
						if (old_lockTarget ~= 0) and (old_lockTarget.data.lockTarget == oUnit) then
							if (old_lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
								--old_lockTarget.data.lockTarget = 0
								--print("lockTarget = 0 53", old_lockTarget.__ID)
								--old_lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
								hApi.UnitTryToLockTarget(old_lockTarget, 0, 0)
								--print("lockType -6", old_lockTarget.data.name, 0)
							end
						end
						
						--英雄锁定新目标
						hApi.UnitTryToLockTarget(oUnit, op_target, 1)
						--oUnit.data.lockTarget = op_target
						--oUnit.data.lockType = 1 --锁定攻击的类型(0:被动锁定 / 1:主动锁定) --主动攻击
						--print("lockType -5", oUnit.data.name, 1)
						
						--新目标锁定攻击角色
						if (op_target.data.lockTarget == 0) then --不重复锁定不同的目标
							hApi.UnitTryToLockTarget(op_target, oUnit, 0)
							--op_target.data.lockTarget = oUnit
							--op_target.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
							--print("lockType -4", op_target.data.name, 0)
						end
						
						--[[
						--geyachao: 操作优化，点击小兵，取消对之前选中英雄的选中
						hGlobal.WORLD.LastWorldMap:GetPlayerMe():focusunit(nil, "worldmap")
						hGlobal.event:event("LocalEvent_HitOnTarget", w, nil, worldX, worldY)
						hGlobal.event:event("Event_TDUnitActived", w, 1, nil)
						hGlobal.O:replace("__WM__TargetOperatePanel",nil)
						hGlobal.O:replace("__WM__MoveOperatePanel",nil)
						--刷新英雄头像
						hGlobal.event:event("LocalEvent_PlayerChooseHero", nil)
						]]
					else --无效的目标或者点击目标点模式
						--清除缓存操作
						oUnit.data.op_state = 0 --清除缓存操作
						
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
						
						--标记AI状态为移动
						oUnit:setAIState(hVar.UNIT_AI_STATE.MOVE)
						
						--如果存在要释放的战术技能
						if ((tacticId and (tacticId ~= 0)) or (itemId and (itemId ~= 0))) then
							--标记AI状态为移动到达目标点后释放战术技能
							oUnit:setAIState(hVar.UNIT_AI_STATE.MOVE_TO_POINT)
						end
						
						--先停掉角色原先的技能释放
						hApi.StopSkillCast(oUnit)
						
						--重置英雄的守卫点(目标点的坐标)
						oUnit.data.defend_x = worldX
						oUnit.data.defend_y = worldY
						
						--发起移动(到指定地点)(英雄计算障碍)
						hApi.UnitMoveToPoint_TD(oUnit, worldX, worldY, true)
						
						--因为发起了移动，锁定的目标为空
						local old_lockTarget = oUnit.data.lockTarget --原先锁定的目标
						--print("old_lockTarget=", old_lockTarget)
						--如果原目标也锁定的是角色，那么取消原目标锁定攻击英雄
						if (old_lockTarget ~= 0) and (old_lockTarget.data.lockTarget == oUnit) then
							if (old_lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
								--old_lockTarget.data.lockTarget = 0
								--print("lockTarget = 0 52", old_lockTarget.__ID)
								--old_lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
								hApi.UnitTryToLockTarget(old_lockTarget, 0, 0)
								--print("lockType -3", old_lockTarget.data.name, 0)
							end
						end
						
						--取消角色锁定目标
						--oUnit.data.lockTarget = 0
						--print("lockTarget = 0 51", oUnit.__ID)
						--oUnit.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
						hApi.UnitTryToLockTarget(oUnit, 0, 0)
						--print("lockType -2", oUnit.data.name, 0)
						
						--[[
						--geyachao: 操作优化，点击完地面，取消对之前选中英雄的选中
						hGlobal.WORLD.LastWorldMap:GetPlayerMe():focusunit(nil, "worldmap")
						hGlobal.event:event("LocalEvent_HitOnTarget", w, nil, worldX, worldY)
						hGlobal.event:event("Event_TDUnitActived", w, 1, nil)
						hGlobal.O:replace("__WM__TargetOperatePanel",nil)
						hGlobal.O:replace("__WM__MoveOperatePanel",nil)
						--刷新英雄头像
						hGlobal.event:event("LocalEvent_PlayerChooseHero", nil)
						]]
					end
				end
			end
			
			--处理进入混乱状态的时候，角色在眩晕，僵直、沉睡解除后，发起移动操作
			--角色不能在眩晕(滑行)、不在僵直中、不在沉睡中
			if (oUnit.attr.stun_stack == 0) and (oUnit:getAIState() ~= hVar.UNIT_AI_STATE.CAST_STATIC) and (oUnit.attr.suffer_sleep_stack == 0) then
				--在混乱中
				if (oUnit.attr.suffer_chaos_stack > 0) then
					--不在移动混乱状态（单位无目的乱走）
					if (oUnit:getAIState() ~= hVar.UNIT_AI_STATE.MOVE_CHAOS) then
						--单位开始进入混乱状态，随机移动到附近的某个坐标点
						hApi.UnitBeginChaos(oUnit)
					end
				end
			end
		end)
		--[[
		--TD敌方小兵受到普通攻击事件
		hGlobal.event:listen("Event_UnitAttack_TD", "__Event_UnitAttacked_TD", function(oAttacker, oUnit)
			local subType = oUnit.data.type --角色子类型
			local isTower = hVar.tab_unit[oUnit.data.id].isTower or 0 --是否为塔
			
			--敌方小兵
			if (subType == hVar.UNIT_TYPE.UNIT) and (isTower ~= 1) and (oUnit:getowner() ~= hGlobal.LocalPlayer) then --普通类型、非箭塔、非本方控制的
				if (oUnit.data.IsDead ~= 1) and (oAttacker:getowner() == hGlobal.LocalPlayer) and (oAttacker.data.IsDead ~= 1) then --活着的小兵、攻击者为本方活着的单位
					if (oUnit.data.lockTarget == 0) then --小兵原先未锁定目标
						--攻击者必须在小兵的射程内，小兵才能锁定攻击者
						--取小兵的中心点位置
						--取英雄的中心位置
						local unit_x, unit_y = hApi.chaGetPos(oUnit.handle) --小兵的坐标
						local unit_bx, unit_by,  unit_bw,  unit_bh = oUnit:getbox() --小兵的包围盒
						local unit_center_x = unit_x + (unit_bx + unit_bw / 2) --小兵的中心点x位置
						local unit_center_y = unit_y + (unit_by + unit_bh / 2) --小兵的中心点y位置
						--local unit_extra_radius = math.sqrt(unit_bw / 2 * unit_bw / 2 + unit_bh / 2 * unit_bh / 2) --小兵额外的攻击距离
						
						--取攻击者的中心点位置
						local enemy_x, enemy_y = hApi.chaGetPos(oAttacker.handle) --攻击者的坐标
						local enemy_bx, enemy_by, enemy_bw, enemy_bh = oAttacker:getbox() --攻击者的包围盒
						local enemy_center_x = enemy_x + (enemy_bx + enemy_bw / 2) --攻击者的中心点x位置
						local enemy_center_y = enemy_y + (enemy_by + enemy_bh / 2) --攻击者的中心点y位置
						
						--英雄在最近的目标的射程内，才会锁定英雄
						--判断矩形和圆是否相交
						--攻击者在小兵射程内，才会锁定攻击者
						if hApi.CircleIntersectRect(unit_center_x, unit_center_y, oUnit:GetAtkRange(), enemy_center_x, enemy_center_y, enemy_bw, enemy_bh) then --在射程内
							oUnit.data.lockTarget = oAttacker --锁定攻击者
							oUnit.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
							--print("lockType 48", oUnit.data.name, 0)
							--print("锁定攻击者")
						end
					end
				end
			end
		end)
		]]
		--监听单位死亡，取消所有单位对它的锁定，有正在朝他移动的单位改为移动到死之前的目标点
		hGlobal.event:listen("Event_UnitDead", "__TD_EnemyDead_TD", function(oDeadTarget, operate, oKillerUnit, id, param, oKillerSide, oKillerPos)
			--print("单位死亡", oKillerUnit and oKillerUnit.data.name, oDeadTarget.data.name, oKillerSide, oKillerPos)
			
			local world = hGlobal.WORLD.LastWorldMap
			
			--取消所有单位对它的锁定
			--world:enumunit(function(oUnit)
			local ux, uy = hApi.chaGetPos(oDeadTarget.handle) --单位的坐标
			--world:enumunitArea(ux, uy, 300, function(oUnit)
			world:enumunitAreaEnemy(oDeadTarget:getowner():getforce(), ux, uy, 300, function(oUnit)
				local lockTarget = oUnit.data.lockTarget --锁定攻击的单位
				if (lockTarget == oDeadTarget) then
					--oUnit.data.lockTarget = 0 --锁定攻击的单位为空
					--print("lockTarget = 0 50", oUnit.__ID)
					--oUnit.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
					hApi.UnitTryToLockTarget(oUnit, 0, 0)
					--print("lockType 47", oUnit.data.name, 0)
				end
			end)
			
			--[[
			--有正在朝他移动的单位改为移动到死之前的目标点
			local deadX, deadY = hApi.chaGetPos(oDeadTarget.handle) --死亡的位置
			for oUnit, tMoveParam in pairs(world.data.UnitArriving) do
				if (tMoveParam.target == oDeadTarget) then --锁定死亡的目标模式
					--改为到达目标点模式
					tMoveParam.pos_x = deadX
					tMoveParam.pos_y = deadY
					tMoveParam.target = nil
					print("有正在朝他移动的单位改为移动到死之前的目标点", oDeadTarget.data.name, deadX, deadY)
				end
			end
			]]
		end)
		
		--监听单位死亡，检测是否有成就变化
		hGlobal.event:listen("Event_UnitDead", "__TD_AchievementCheck", function(oDeadTarget, operate, oKillerUnit, id, param, oKillerSide, oKillerPos)
			local world = hGlobal.WORLD.LastWorldMap
			
			local tOwner = oDeadTarget:getowner() --死亡的单位的玩家对象
			
			--死亡的是敌人势力，击杀者是我方势力
			if (tOwner:getforce() ~= world:GetPlayerMe():getforce()) and (oKillerSide == world:GetPlayerMe():getforce()) then
				--成就：累计击杀N个敌人
				--LuaAddPlayerCountVal(hVar.MEDAL_TYPE.killU, 1)
				--任务：累计击杀N个敌人
				--LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.killU, 1)
				
				--[[
				--成就：累计击杀N个BOSS
				--检测该单位是否是BOSS
				local bIsBoss = false --是否为boss
				local tTypeId = oDeadTarget.data.id --死亡者的类型id
				local tag = hVar.tab_unit[tTypeId].tag
				if tag and (type(tag) == "table") then
					if (tag[hVar.UNIT_TAG_TYPE.OTHER.TAG_BOSS]) then
						bIsBoss = true
					end
				end
					
				if bIsBoss then
					LuaAddPlayerCountVal(hVar.MEDAL_TYPE.killUB, 1)
					LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.killUB, 1)
				end
				
				--成就：累计击杀N个指定敌人
				LuaAddPlayerCountVal(hVar.MEDAL_TYPE.killUT, tTypeId, 1)
				--任务：累计击杀N个指定敌人
				LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.killUT, tTypeId, 1)
				]]
			end
		end)
		
		--监听死亡事件，标记是哪个战术技能杀死了敌方单位
		hGlobal.event:listen("Event_UnitDead", "__TD_TacticSkillCheck", function(oDeadTarget, operate, oKillerUnit, id, param, oKillerSide, oKillerPos)
			--[[
			--print("单位死亡=" .. oDeadTarget.data.name, "击杀者=" .. (oKillerUnit and oKillerUnit.data.name or "无"), "id=" .. tostring(id))
			local world = hGlobal.WORLD.LastWorldMap
			
			local tOwner = oDeadTarget:getowner() --死亡的单位的玩家对象
			
			
			--死亡的是敌人，击杀者是我方或中立单位
			if (tOwner:getforce() ~= world:GetPlayerMe():getforce()) and (oKillerSide == world:GetPlayerMe():getforce()) then
				--该技能是战术技能
				if id and (id > 0) then
					local tacticId = 0 --战术技能
					local tag = hVar.tab_skill[id].tag
					if tag and (type(tag) == "table") then
						tacticId = tag[hVar.UNIT_TAG_TYPE.TAG_TACTIC_SKILL] or 0 --战术技能id
					end
						
					if (tacticId > 0) then
						--成就：用指定战术技能杀死敌人
						--LuaAddPlayerCountVal(hVar.MEDAL_TYPE.killUS, tacticId, 1)
						--任务：用指定战术技能杀死敌人
						--LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.killUS, tacticId, 1)
						--print("用指定战术技能杀死敌人")
					end
				end
			end
			]]
		end)
		
		--监听铜雀台、新手地图，英雄敌人BOSS死了，层数加1
		hGlobal.event:listen("Event_UnitDead", "__TD_TongQueTaiRound", function(oDeadTarget, operate, oKillerUnit, id, param, oKillerSide, oKillerPos)
			local world = hGlobal.WORLD.LastWorldMap
			
			--铜雀台地图
			--if (((world.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) and (world.data.tdMapInfo.isWheelWar == true)) --PVP模式、英雄车轮战模式
			--或者新手地图
			--	or (world.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.NEWGUIDE)) then
				--是英雄
				if (oDeadTarget.data.type == hVar.UNIT_TYPE.HERO) then
					--死亡的是敌人势力
					local tOwner = oDeadTarget:getowner() --死亡的单位的玩家对象
					if (tOwner:getforce() ~= world:GetPlayerMe():getforce()) then
						--检测该单位是否是BOSS
						local bIsBoss = false --是否为boss
						local tTypeId = oDeadTarget.data.id --死亡者的类型id
						local tag = oDeadTarget.attr.tag
						if tag and (type(tag) == "table") then
							if (tag[hVar.UNIT_TAG_TYPE.OTHER.TAG_BOSS]) then
								bIsBoss = true
							end
						end
						
						--是boss
						if bIsBoss then
							if (tTypeId ~= 15354) and (tTypeId ~= 15355) then --邪灵守将不算一层
								local round_ahead = world.data.pvp_round_ahead --铜雀台、新手地图前置层数（打完boss就可以加1）
								world.data.pvp_round_ahead = world.data.pvp_round_ahead + 1
								--hGlobal.event:event("Event_UpdateGameRound", round + 1)
							end
							
							--播放进入下一层音效
							hApi.PlaySound("magic11")
						end
					end
				end
			--end
		end)
		
		--如果是td塔，那么把它变成塔基
		local Tower2Base = function(oDeadTarget)
			--判断是否是tower
			local world = hGlobal.WORLD.LastWorldMap
			local bIsTower = false --单位是否是塔
			local uId = oDeadTarget.data.id
			local tabU = hVar.tab_unit[uId]
			if tabU then
				local tagT = tabU.tag
				if tagT then
					for k, v in pairs (hVar.UNIT_TAG_TYPE.TOWER) do
						if tagT[v] then
							bIsTower = true --是塔
							break
						end
					end
				end
			end
			
			--是td塔
			if (bIsTower) then
				--local baseTowerId = 69997
				--if world and world.data.tdMapInfo and world.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP then
				--	baseTowerId = 11007
				--end
				local unitData = oDeadTarget.data
				
				local baseTowerId = 69997
				if unitData.baseTower == 69997 or unitData.baseTower == 11007 or unitData.baseTower == 14393 then
					baseTowerId = unitData.baseTower
				end
				
				--unitData.facing
				local owner = unitData.baseTOwner or unitData.owner
				local nu = world:addunit(baseTowerId,owner,nil,nil, -45, unitData.worldX,unitData.worldY,nil,{triggerID=oDeadTarget.data.triggerID})
				
				if nu then
					--[[
					--拷贝路点
					local dType = hVar.TD_DEPLOY_TYPE
					local formation = dType.ONE_SAME_DISTANCE
					local tPathInfo = oDeadTarget:copyRoadPointInfo()
					nu:setRoadPoint(tPathInfo[1], formation, 1)
					]]
					--拷贝路点
					nu:copyRoadPoint(oDeadTarget)

					--绑定triggerID
					if worldScene then
						hApi.chaSetUniqueID(nu.handle,oDeadTarget.data.triggerID,worldScene)
					end
					
					--zhenkira 角色出生事件
					hGlobal.event:call("Event_UnitBorn", nu)
					
					--播放特效及音效
					world:addeffect(96, 1, nil, unitData.worldX, unitData.worldY)
					hApi.PlaySound("burning1")
				end
			end
		end
		--监听死亡事件，如果是td塔，那么把它变成塔基
		hGlobal.event:listen("Event_UnitDead", "__TD_TowerDeadCheck", Tower2Base)
		--监听单位生存时间到了消失事件，如果是td塔，那么把它变成塔基
		hGlobal.event:listen("Event_UnitLiveTime_Disappear", "__TD_TowerLiveTimeCheck", Tower2Base)
		
		--[[
		--小兵漏掉后，有正在朝他移动的单位改为移动到漏掉前的目标点
		hGlobal.event:listen("LocalEvent_TD_UnitReached", "__TD_EnemyReached", function(oMissedTarget)
			--有正在朝他移动的单位改为移动到漏掉前的目标点
			local world = hGlobal.WORLD.LastWorldMap
			local missedX, missedY = hApi.chaGetPos(oMissedTarget.handle) --死亡的位置
			for oUnit, tMoveParam in pairs(world.data.UnitArriving) do
				if (tMoveParam.target == oMissedTarget) then --锁定漏怪的目标模式
					--不锁定目标（目标已死亡）
					oUnit.data.lockTarget = 0
					oUnit.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
					
					--改为到达目标点模式
					tMoveParam.pos_x = missedX
					tMoveParam.pos_y = missedY
					tMoveParam.target = nil
					print("有正在朝他移动的单位改为移动到漏掉前的目标点", oMissedTarget.data.name, missedX, missedY)
				end
			end
		end)
		]]
		
		--提前发兵，重刷英雄复活时间（提前复活）
		hGlobal.event:listen("Event_ClickNextWaveButtonInAdvance", "__TD_NEXTWAVE_COME_TD", function(timeEarly)
			--geyachao: 复活相关 刷新cd
			--复活存储数据 {[index] = {deadoUint = xx, beginTick = 0, rebithTime = 10000, progressUI = xx, labelUI = xx,}, ...}
			local world = hGlobal.WORLD.LastWorldMap
			for k, v in ipairs(world.data.rebirthT) do
				v.beginTick = v.beginTick - timeEarly --复活时间减去提前发兵的时间
			end
		end)
		--
		--todo:游戏结束时删除定时器
		--hApi.clearTimer("__TD__AICommonOperate")
		
		--hGlobal.event:event("Event_TDBattlefieldStart",oWorld)
		
		--取消缩放
		--xlScene_EnableScale(g_current_scene, 0)
		
		--加载pvp资源
		--xlLoadResourceFromPList("data/image/misc/pvp.plist")
		
		--TD_ViewSet()
		
		--开始换英雄面板(pve版本才有的界面)

		if oWorld.data.map ~= hVar.MainBase then
			--添加连斩系统统计
			hGlobal.event:event("OpenContinuousKillingSystem",true)
			--行为统计初始化
			BehaviorStatistics.Init()
		end
		
		local mapInfo = oWorld.data.tdMapInfo
		if mapInfo then
			if mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP then
				--加载当前玩家pvp相关操作界面
				--todo: 压灭跌
				--hGlobal.event:event("LocalEvent_TD_NextWave", true)
			else
				if g_curPlayerName and hApi.FileExists(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.PLAYER_DATA,"full") then
					LuaLoadSavedGameData(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.PLAYER_DATA)
					LuaLoadSavedGameData(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.PLAYER_LOG)
					
					LuaDeleteIllegalItem()
					LuaDeleteIllegalItemEx()
					LuaCheckPlayerChestLegal()
					hApi.CheckBFSCardIllegal(g_curPlayerName)
					if Save_PlayerData and Save_PlayerData.herocard then
						local num = hGlobal.WORLD.LastWorldMap.data.tdMapInfo.maxHero or 0
						local noselectedlist = (hVar.MAP_INFO[map_name].nohero or {})
						local legion = hVar.MAP_LEGION[map_name]
						local save_heroNum = 0
						local tempNoheroNum = 0
						if Save_PlayerData.herocard then
							save_heroNum = #Save_PlayerData.herocard
							for i = 1,save_heroNum do
								for j = 1,#noselectedlist do
									if Save_PlayerData.herocard[i].id == noselectedlist[j] then
										tempNoheroNum = tempNoheroNum +1
									end
								end
							end
						end
						oWorld.data.SelectHeroNum = num
						--zhenkira 加入剧情流程
						--判断是不是第一关
						if mapInfo and hVar.tab_chapter and hVar.tab_chapter[1] and hVar.tab_chapter[1].firstmap and (hVar.tab_chapter[1].firstmap == map_name) then
							--创建对话
							local isFinish = LuaGetPlayerMapAchi(map_name,hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
							--如果第一关未完成则创建对话
							if (isFinish == 0) and (hVar.IS_DIABOLO_APP ~= 1) then
								_tdFirstMapStory()
							else
								hGlobal.event:event("localEvent_Phone_ShowSelectedHeroFrm",Save_PlayerData.herocard,num,noselectedlist,legion)
								hGlobal.event:event("LocalEvent_EnterGuideProgress", oWorld.data.map, oWorld, "world", 1)
							end
						else
							hGlobal.event:event("localEvent_Phone_ShowSelectedHeroFrm",Save_PlayerData.herocard,num,noselectedlist,legion)
							hGlobal.event:event("LocalEvent_EnterGuideProgress", oWorld.data.map, oWorld, "world", 1)
						end
						return
					end
				end
			end
		end
	end
	
	local tMapData = oWorld:getmapdata(1)
	if tMapData then
		--若非已通关，强制清除对话转换字符串
		if tMapData.TalkConvert then
			tMapData.TalkConvert = nil
		end
	end
end
if (xlPrintMem == nil) then
	function xlPrintMem()
	end
end

--local iChannelId = xlGetChannelId()
--if iChannelId < 100 then
	--function xlPlayer_SetUID(iNewUid)
		--if "number" ~= type(iNewUid) then
			--return 
		--end
		
		--local iOldUid = xlPlayer_GetUID() or 0
		--local sLogInfo = string.format("xlPlayer_SetUID olduid:%d,newuid:%d,%s",iOldUid,iNewUid,tostring(debug.traceback()))
		--SendCmdFunc["C2S_LOG"](sLogInfo)
		
		--if g_tTargetPlatform.kTargetWindows == CCApplication:sharedApplication():getTargetPlatform() then
			--CCUserDefault:sharedUserDefault():setIntegerForKey("UID",iNewUid)
			--CCUserDefault:sharedUserDefault():flush()
		--else
			--xlSaveIntToKeyChain("Client_uid",iNewUid)
		--end
		--if "function" == type(xlIosSetingSetUid) then
			--xlIosSetingSetUid(iNewUid)
		--end
		
		----[[
		--Save_PlayerData.userID = iNewUid
		--Save_PlayerLog.userID = iNewUid
		
		----存档
		--LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		--LuaSavePlayerList()
		--]]
	--end
--end
--[[
function xlPlayer_SetDeviceId(sNewDeviceId)
	if "string" ~= type(sNewDeviceId) then return end
	if g_tTargetPlatform.kTargetWindows == CCApplication:sharedApplication():getTargetPlatform() then
		CCUserDefault:sharedUserDefault():setStringForKey("DeviceID",sNewDeviceId)
		CCUserDefault:sharedUserDefault():flush()
	else
		xlSaveStringToKeyChain("DeviceId",sNewDeviceId)
	end
end
]]
function xlPlayer_SetDeviceId(sNewDeviceId)
	if "string" ~= type(sNewDeviceId) then return end
	local sOldDid = xlPlayer_GetDeviceId() or "null"
	local sLogInfo = string.format("xlPlayer_SetDeviceId olddid:%s,newdid:%s,%s",sOldDid,sNewDeviceId,tostring(debug.traceback()))
	SendCmdFunc["C2S_LOG"](sLogInfo)
	if g_tTargetPlatform.kTargetWindows == CCApplication:sharedApplication():getTargetPlatform() then
		CCUserDefault:sharedUserDefault():setStringForKey("DeviceID",sNewDeviceId)
		CCUserDefault:sharedUserDefault():flush()
	else
		xlSaveStringToKeyChain("DeviceId",sNewDeviceId)
	end
end


function xlPlayer_GetDeviceId()
	if g_tTargetPlatform.kTargetWindows == CCApplication:sharedApplication():getTargetPlatform() then
		return CCUserDefault:sharedUserDefault():getStringForKey("DeviceID")
	else
		return xlGetStringFromKeyChain("DeviceId")
	end
end

--geyachao: 普攻转向
function atttack_faceto(oUnit, oTarget)
	--print("atttack_faceto", oUnit.data.name)
	local skill_id = oUnit.attr.attack[1] --普攻技能id
	local tabS = hVar.tab_skill[skill_id]
	--print(tostring(oUnit), oUnit.data.name, "skill_id=" .. skill_id)
	local unitX, unitY = hApi.chaGetPos(oUnit.handle) --角色的位置
	local targetX, targetY = hApi.chaGetPos(oTarget.handle) --目标的位置
	local world = oUnit:getworld() --world
	local gridX, gridY = world:xy2grid(targetX, targetY)
	
	--配置坦克地图不能攻击
	local mapInfo = world.data.tdMapInfo
	if (mapInfo.mapMode == hVar.MAP_TD_TYPE.TANKCONFIG) then --配置坦克地图
		--todo: 暂时恢复
		return
	end
	
	--禁止响应事件，不处理
	if (world.data.keypadEnabled ~= true) then
		return
	end
	
	--单位已死亡，不处理
	if (oUnit.data.IsDead == 1) or (oUnit.attr.hp <= 0) then
		return
	end
	
	--转向
	if (oUnit.data.id ~= 6000) and (oUnit.data.id ~= 6012) and (oUnit.data.id ~= hVar.MY_TANK_ID) then
		if (oUnit.data.type ~= hVar.UNIT_TYPE.BUILDING) then --建筑、图腾，攻击不转向
			local ox, oy = hApi.chaGetPos(oUnit.handle)
			local tx, ty = hApi.chaGetPos(oTarget.handle)
			
			--读取技能表，是否有命中目标碰撞类飞行特效，那么改为目标的中心点
			local bMissileToTargetColl = false
			for i = 1, #tabS.action, 1 do
				local v = tabS.action[i]
				if (v[1] == "MissileToTarget_Collision")then --找到了
					bMissileToTargetColl = true
					break
				end
			end
			if bMissileToTargetColl then
				local t_bx, t_by, t_bw, t_bh = oTarget:getbox() --小兵的包围盒
				tx = tx + (t_bx + t_bw / 2) --中心点x位置
				ty = ty + (t_by + t_bh / 2) --中心点y位置
			end
			
			local facing = GetFaceAngle(ox, oy, tx, ty) --角色的朝向(角度制)
			--print("转向", oUnit.data.name, facing, "oldface=" .. oUnit.data.facing)
			
			--子弹的偏移
			--local tabU = hVar.tab_unit[oUnit.data.id]
			local bullet = oUnit.attr.bullet
			if bullet and (bullet ~= 0) then
				local b0 = bullet["0"]
				local b90 = bullet["90"]
				local b180 = bullet["180"]
				local b270 = bullet["270"]
				if b0 and b90 and b180 and b270 then
					local x1 = b0.offsetX
					local y1 = b0.offsetY
					local x2 = b180.offsetX
					local y2 = b180.offsetY
					local x3 = b90.offsetX
					local y3 = b90.offsetY
					local x4 = b270.offsetX
					local y4 = b270.offsetY
					
					local x0 = ((y2-y1)*(x4-x3)*x1-(y4-y3)*(x2-x1)*x3)/((y2-y1)*(x4-x3)-(y4-y3)*(x2-x1))
					local y0 = ((x2-x1)*(y4-y3)*y1-(x4-x3)*(y2-y1)*y3)/((x2-x1)*(y4-y3)-(x4-x3)*(y2-y1))
					--print(x0, y0)
					
					facing = GetFaceAngle(ox + x0, oy - y0, tx, ty) --角色的朝向(角度制)
				end
			end
			
			hApi.ChaSetFacing(oUnit.handle, facing) --转向
			oUnit.data.facing = facing
			--print(oUnit.data.name, "转向1", facing)
			
			--标记单位普攻的时间
			oUnit.attr.last_attack_time = world:gametime()
		end
	end
	
	return hVar.RESULT_SUCESS
end

--geyachao: 普攻流程
--atttack = function(oUnit, oTarget)
function atttack(oUnit, oTarget)
	--print("atttack", oUnit.data.name)
	local skill_id = oUnit.attr.attack[1] --普攻技能id
	local world = oUnit:getworld() --world
	
	--禁止响应事件，不处理
	if (world.data.keypadEnabled ~= true) then
		return
	end
	
	--单位已死亡，不处理
	if (oUnit.data.IsDead == 1) or (oUnit.attr.hp <= 0) then
		return
	end
	
	--大菠萝的武器攻击
	if (oUnit.data.bind_weapon_owner ~= 0) then --枪
		--print("大菠萝的武器攻击")
		local oHero = world:GetPlayerMe().heros[1]
		local oTank = oHero:getunit()
		if (oUnit.data.bind_weapon_owner == oTank) then --我方坦克绑定单位
			if (oUnit == oTarget) or (oTarget == 0) or (oTarget == nil) then
				skill_id = skill_id + 10000
			end
		end
		
		local tabS = hVar.tab_skill[skill_id]
		local cast_type = tabS.cast_type
		if (cast_type == hVar.CAST_TYPE.SKILL_TO_UNIT) then --闪电链
			if (oTarget == nil) or (oTarget == 0) then
				return hVar.RESULT_FAIL
			end
		elseif (cast_type == hVar.CAST_TYPE.IMMEDIATE) then
			oTarget = oUnit
		end
	end
	
	--无效的目标
	if (oTarget == nil) or (oTarget == 0) then
		return
	end
	
	local tabS = hVar.tab_skill[skill_id]
	
	--检测技能id的合法性
	if (not tabS) then
		_DEBUG_MSG("atttack() 无此技能！skill_id = " .. tostring(skill_id))
		return hVar.RESULT_FAIL
	end
	
	--print(tostring(oUnit), oUnit.data.name, "skill_id=" .. skill_id)
	local unitX, unitY = hApi.chaGetPos(oUnit.handle) --角色的位置
	local targetX, targetY = hApi.chaGetPos(oTarget.handle) --目标的位置
	--local world = oUnit:getworld() --world
	local gridX, gridY = world:xy2grid(targetX, targetY)
	
	--配置坦克地图不能攻击
	local mapInfo = world.data.tdMapInfo
	if (mapInfo.mapMode == hVar.MAP_TD_TYPE.TANKCONFIG) then --配置坦克地图
		--todo: 暂时恢复
		return
	end
	
	--geyachao: 同步日志: 普通攻击
	if (hVar.IS_SYNC_LOG == 1) then
		local msg = "atttack: oUnit=" .. oUnit.data.id .. ",u_ID=" .. oUnit:getworldC() .. ",u_x=" .. unitX .. ",u_y=" .. unitY .. ",oTarget=" .. oTarget.data.id .. ",t_ID=" .. oTarget:getworldC() .. ",t_x=" .. targetX .. ",t_y=" .. targetY
		hApi.SyncLog(msg)
	end
	
	--检测普通攻击额外触发的技能
	local BeforeAttackID = oUnit.attr.BeforeAttackID
	--print("BeforeAttackID=", BeforeAttackID, #BeforeAttackID)
	if (type(BeforeAttackID) == "table") then
		if (oUnit.attr.suffer_chenmo_stack == 0) then --不在沉默状态
			local tCastParam =
			{
				IsAttack=0,
				IsCast=0,
				damageType = nDamageType,
				IsShowPlus = -1,
				targetC = oTarget,
				tempValue = {["@aid"] = skill_id},
				level = 1, --普通攻击的等级
			}
			for i = 1, #oUnit.attr.BeforeAttackID, 1 do
				local v = oUnit.attr.BeforeAttackID[i]
				if type(v)=="table" then
					local id = v[1]
					local ex = v[2]
					local CanCast = 0
					if v[2]==0 then
						--非反击类有效
						if nCastOrder~=hVar.ORDER_TYPE.COUNTER then
							CanCast = 1
						end
					elseif v[2]==1 then
						--仅普通命令有效
						if nCastOrder==hVar.ORDER_TYPE.NORMAL then
							CanCast = 1
						end
					elseif v[2]==2 then
						--仅反击命令有效
						if nCastOrder==hVar.ORDER_TYPE.COUNTER then
							CanCast = 1
						end
					end
					if CanCast==1 then
						hApi.CastSkill(oUnit, id, 0, nil, oTarget, gridX, gridY, tCastParam)
					end
				end
			end
		end
	end
	
	--本次普通攻击是否替换为释放别的技能
	--尝试进行技能转换
	local replaceNormalAtkID = oUnit.attr.replaceNormalAtkID
	if (#replaceNormalAtkID > 0) then
		--检测是否需要替换本次普通攻击的技能
		for i = 1, #replaceNormalAtkID, 1 do
			local content = replaceNormalAtkID[i]
			local skillIdi = content.skill_id
			local probabilityi = content.probability
			local randInt = world:random(0, 100)
			--print(probabilityi, randInt)
			if (randInt < probabilityi) then
				skill_id = skillIdi --替换本次普通攻击id
				break
			end
		end
	end
	
	--大菠萝的武器攻击
	if (oUnit.data.bind_weapon_owner ~= 0) then --枪
		--print("大菠萝的武器攻击")
		local oHero = world:GetPlayerMe().heros[1]
		local oTank = oHero:getunit()
		if (oUnit.data.bind_weapon_owner == oTank) then --我方坦克绑定单位
			--读取坦克身上+自身身上是否有攻击暴击的技能
			local weapon_crit_shoot = oTank:GetWeaponCritShoot() + oUnit:GetWeaponCritShoot() --射击暴击
			local weapon_crit_frozen = oTank:GetWeaponCritFrozen() + oUnit:GetWeaponCritFrozen() --冰冻暴击
			local weapon_crit_fire = oTank:GetWeaponCritFire() + oUnit:GetWeaponCritFire() --火焰暴击
			local weapon_crit_hit = oTank:GetWeaponCritHit() + oUnit:GetWeaponCritHit() --击退暴击
			local weapon_crit_blow = oTank:GetWeaponCritBlow() + oUnit:GetWeaponCritBlow() --吹风暴击
			local weapon_crit_posion = oTank:GetWeaponCritPoison() + oUnit:GetWeaponCritPoison() --毒液暴击
			local weapon_crit_equip = oTank:GetWeaponCritEquip() + oUnit:GetWeaponCritEquip() --装备暴击
			--print("攻击暴击:", "shoot="..weapon_crit_shoot, "frozen="..weapon_crit_frozen, "fire="..weapon_crit_fire, "hit="..weapon_crit_hit, "blow="..weapon_crit_blow, "posion="..weapon_crit_posion, "equip="..weapon_crit_equip)
			
			--射击暴击
			if (weapon_crit_shoot > 0) then
				--几率触发
				local randValue = world:random(1, 100)
				if (randValue <= weapon_crit_shoot) then
					local selfX, selfY = hApi.chaGetPos(oUnit.handle) --当前坐标
					local gridX, gridY = world:xy2grid(selfX, selfY)
					--释放技能
					local tCastParam =
					{
						level = 1, --技能等级
					}
					hApi.CastSkill(oUnit, 31098, 0, 100, oUnit, gridX, gridY, tCastParam)
				end
			end
			
			--冰冻暴击
			if (weapon_crit_frozen > 0) then
				--几率触发
				local randValue = world:random(1, 100)
				if (randValue <= weapon_crit_frozen) then
					local selfX, selfY = hApi.chaGetPos(oUnit.handle) --当前坐标
					local gridX, gridY = world:xy2grid(selfX, selfY)
					--释放技能
					local tCastParam =
					{
						level = 1, --技能等级
					}
					hApi.CastSkill(oUnit, 31099, 0, 100, oUnit, gridX, gridY, tCastParam)
				end
			end
			
			--火焰暴击
			if (weapon_crit_fire > 0) then
				--几率触发
				local randValue = world:random(1, 100)
				if (randValue <= weapon_crit_fire) then
					local selfX, selfY = hApi.chaGetPos(oUnit.handle) --当前坐标
					local gridX, gridY = world:xy2grid(selfX, selfY)
					--释放技能
					local tCastParam =
					{
						level = 1, --技能等级
					}
					hApi.CastSkill(oUnit, 31102, 0, 100, oUnit, gridX, gridY, tCastParam)
				end
			end
			
			--击退暴击
			if (weapon_crit_hit > 0) then
				--几率触发
				local randValue = world:random(1, 100)
				if (randValue <= weapon_crit_hit) then
					local selfX, selfY = hApi.chaGetPos(oUnit.handle) --当前坐标
					local gridX, gridY = world:xy2grid(selfX, selfY)
					--释放技能
					local tCastParam =
					{
						level = 1, --技能等级
					}
					hApi.CastSkill(oUnit, 31106, 0, 100, oUnit, gridX, gridY, tCastParam)
				end
			end
			
			--吹风暴击
			if (weapon_crit_blow > 0) then
				--几率触发
				local randValue = world:random(1, 100)
				if (randValue <= weapon_crit_blow) then
					local selfX, selfY = hApi.chaGetPos(oUnit.handle) --当前坐标
					local gridX, gridY = world:xy2grid(selfX, selfY)
					--释放技能
					local tCastParam =
					{
						level = 1, --技能等级
					}
					hApi.CastSkill(oUnit, 31109, 0, 100, oUnit, gridX, gridY, tCastParam)
				end
			end
			
			--毒液暴击
			if (weapon_crit_posion > 0) then
				--几率触发
				local randValue = world:random(1, 100)
				if (randValue <= weapon_crit_posion) then
					local selfX, selfY = hApi.chaGetPos(oUnit.handle) --当前坐标
					local gridX, gridY = world:xy2grid(selfX, selfY)
					--释放技能
					local tCastParam =
					{
						level = 1, --技能等级
					}
					hApi.CastSkill(oUnit, 31112, 0, 100, oUnit, gridX, gridY, tCastParam)
				end
			end
		end
	end
	
	--转向
	if (oUnit.data.id ~= 6000) and (oUnit.data.id ~= 6012) and (oUnit.data.id ~= hVar.MY_TANK_ID) and (oUnit.data.bind_weapon_owner == 0) then
		--geyachao: 大菠萝，建筑也转向
		if (oUnit.data.type ~= hVar.UNIT_TYPE.BUILDING) then --建筑、图腾，攻击不转向
			local ox, oy = hApi.chaGetPos(oUnit.handle)
			local tx, ty = hApi.chaGetPos(oTarget.handle)
			
			--读取技能表，是否有命中目标碰撞类飞行特效，那么改为目标的中心点
			local bMissileToTargetColl = false
			if tabS.action then
				for i = 1, #tabS.action, 1 do
					local v = tabS.action[i]
					if (v[1] == "MissileToTarget_Collision")then --找到了
						bMissileToTargetColl = true
						break
					end
				end
			end
			if bMissileToTargetColl then
				local t_bx, t_by, t_bw, t_bh = oTarget:getbox() --小兵的包围盒
				tx = tx + (t_bx + t_bw / 2) --中心点x位置
				ty = ty + (t_by + t_bh / 2) --中心点y位置
			end
			
			local facing = GetFaceAngle(ox, oy, tx, ty) --角色的朝向(角度制)
			--print("转向", oUnit.data.name, facing, "oldface=" .. oUnit.data.facing)
			
			--子弹的偏移
			--local tabU = hVar.tab_unit[oUnit.data.id]
			local bullet = oUnit.attr.bullet
			if bullet and (bullet ~= 0) then
				local b0 = bullet["0"]
				local b90 = bullet["90"]
				local b180 = bullet["180"]
				local b270 = bullet["270"]
				if b0 and b90 and b180 and b270 then
					local x1 = b0.offsetX
					local y1 = b0.offsetY
					local x2 = b180.offsetX
					local y2 = b180.offsetY
					local x3 = b90.offsetX
					local y3 = b90.offsetY
					local x4 = b270.offsetX
					local y4 = b270.offsetY
					
					local x0 = ((y2-y1)*(x4-x3)*x1-(y4-y3)*(x2-x1)*x3)/((y2-y1)*(x4-x3)-(y4-y3)*(x2-x1))
					local y0 = ((x2-x1)*(y4-y3)*y1-(x4-x3)*(y2-y1)*y3)/((x2-x1)*(y4-y3)-(x4-x3)*(y2-y1))
					--print(x0, y0)
					
					facing = GetFaceAngle(ox + x0, oy - y0, tx, ty) --角色的朝向(角度制)
				end
			end
			
			hApi.ChaSetFacing(oUnit.handle, facing) --转向
			oUnit.data.facing = facing
			
			--绑定的武器也转向
			if oUnit.data.bind_weapon and (oUnit.data.bind_weapon ~= 0) then
				hApi.ChaSetFacing(oUnit.data.bind_weapon.handle, facing) --转向
				oUnit.data.bind_weapon.data.facing = facing
			end
			--print(oUnit.data.name, "转向1", facing)
		end
	end
	
	--标记释放普通攻击的次数加1
	oUnit.data.atkTimes = oUnit.data.atkTimes + 1 --geyachao: 新加数据 普通攻击的次数
	
	--释放技能(普通攻击)
	local tCastParam =
	{
		level = oUnit.attr.attack[6], --普通攻击的等级
		skillTimes = oUnit.data.atkTimes, --普通攻击的次数
	}
	hApi.CastSkill(oUnit, skill_id, 0, 100, oTarget, gridX, gridY, tCastParam) --普通攻击
	--print("普通攻击", gridX, gridY)
	
	--标记单位普攻的时间
	if (oUnit ~= oTarget) then
		oUnit.attr.last_attack_time = world:gametime()
	end
	
	--触发普通攻击事件
	hGlobal.event:event("Event_UnitAttack_TD", oUnit, oTarget)
	
	return hVar.RESULT_SUCESS
end

--普通野怪创建 zhenkira delete 2016.7.12
--hGlobal.event:listen("Event_UnitBorn", "__AddArmyForWeakUnit",function(oUnit)
--	local w = oUnit:getworld()
--	local d = oUnit.data
--	if w~=nil then
--		if w.data.type=="worldmap" then
--			local tabU = oUnit:gettab()
--			if d.owner==0 and d.type==hVar.UNIT_TYPE.UNIT and d.team==0 then
--				if type(d.team)~="table" then
--					d.team = {}
--					plusN = 0
--				end
--				
--				local count = 0
--				for i = 1,hVar.TEAM_UNIT_MAX do
--					local n = i+plusN
--					if n>hVar.TEAM_UNIT_MAX then
--						break
--					end
--					if i<=6 and ((i==6 and count==0) or hApi.random(1,2)==1) then
--						d.team[n] = {d.id,w:random(10,30)}
--					else
--						d.team[n] = 0
--					end
--				end
--			end
--		end
--	end
--end)

hGlobal.event:listen("Event_HeroEnterMap","__ShowHeroLv",function(oHero,oUnit)
	if oUnit.handle._c==nil then
		return
	end
	local owner = oUnit:getowner()
	local aln = hGlobal.LocalPlayer:allience(owner)
	if aln==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
		local x,y = oUnit:getbox()
		if oUnit.chaUI["__HERO_LEVEL__"] == nil then
			oUnit.chaUI["__HERO_LEVEL__"] = hUI.label:new({
				parent = oUnit.handle._tn,
				font = "numGreen",
				text = "", --geyachao: 不显示等级 "lv"..oHero.attr.level,
				size = 12,
				align = "MB",
				y = -1*y-6,
			})
		end
	elseif aln==hVar.PLAYER_ALLIENCE_TYPE.ENEMY then
		local x,y = oUnit:getbox()
		if oUnit.chaUI["__HERO_LEVEL__"] == nil then
			oUnit.chaUI["__HERO_LEVEL__"] = hUI.label:new({
				parent = oUnit.handle._tn,
				font = "numRed",
				text = "", --geyachao: 不显示等级 "lv"..oHero.attr.level,
				size = 12,
				align = "MB",
				y = -1*y-6,
			})

		end
	elseif aln==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
		local x,y,cw,ch = oUnit:getbox()
		local HaveJoinTalk = 0
		local tData = oUnit:gettriggerdata()
		if tData and type(tData.talk)=="table" then
			local sMatchKey = "@func:join"
			local nMatchKeyLen = string.len(sMatchKey)
			for i = 1,#tData.talk do
				if tData.talk[i][1]=="talk" then
					for j = 2,#tData.talk[i] do
						if string.sub(tData.talk[i][j],1,nMatchKeyLen)==sMatchKey then
							HaveJoinTalk = 1
							break
						end
					end
					if HaveJoinTalk==1 then
						break
					end
				end
			end
		end
		if HaveJoinTalk==1 then
			oUnit.chaUI["__JOIN_HINT__"] = hUI.image:new({
				--parent = oUnit.handle._tn,
				--model = "MODEL_EFFECT:chat",
				--y = -1*y+5,
				parent = oUnit.handle._n,
				model = "misc/circle.png",
				z = -1,
				y = 0,
				w = math.min(72,cw+8),
			})
			return
		end
		--创建一个选择提示
		if oUnit.chaUI["__HERO_LEVEL__"] == nil then
			oUnit.chaUI["__HERO_LEVEL__"] = hUI.label:new({
				parent = oUnit.handle._tn,
				font = "numBlue",
				text = "", --geyachao: 不显示等级 "lv"..oHero.attr.level,
				size = 12,
				align = "MB",
				y = -1*y-6,
			})
		end
	elseif aln==hVar.PLAYER_ALLIENCE_TYPE.NEUTRAL then
		local x,y = oUnit:getbox()
		if oUnit.chaUI["__HERO_LEVEL__"] == nil then
			oUnit.chaUI["__HERO_LEVEL__"] = hUI.label:new({
				parent = oUnit.handle._tn,
				font = "numWhite",
				text = "", --geyachao: 不显示等级 "lv"..oHero.attr.level,
				size = 12,
				align = "MB",
				y = -1*y-6,
			})
		end
	end
end)

--英雄转换控制权时，移除选择圈
hGlobal.event:listen("Event_HeroChangeOwner","__UI__ClearJoinUI",function(oHero,oPlayer,oPlayerOld)
	local oUnit = oHero:getunit()
	if oUnit then
		local w = hGlobal.WORLD.LastWorldMap
		if w then
			local me = w:GetPlayerMe()
			if me and oPlayer == me then
				hApi.safeRemoveT(oUnit.chaUI,"__JOIN_HINT__")
			end
		end
	end
end)

hGlobal.event:listen("Event_HeroLevelUp","__UpdateHeroLv",function(oHero,nLastLevel)
	local u = oHero:getunit("worldmap")
	if u~=nil and u.chaUI["__HERO_LEVEL__"]~=nil then
		--geyachao: 不显示英雄等级
		--u.chaUI["__HERO_LEVEL__"]:setText("lv"..tostring(oHero.attr.level))
	end
end)

--城里建筑创建后脑袋上顶的名字
hGlobal.event:listen("Event_BuildingCreated","__TestCreateBuilding",function(oUnit)
	local w = oUnit:getworld()
	local d = oUnit.data
	if w~=nil then
		local u = oUnit
		local scale = 1
		local tabU = u:gettab()
		if tabU and type(tabU.scale)=="number" then
			scale = tabU.scale
			u.handle.s:setScale(scale)
		end
		if w.data.type=="town" then
			--城内建筑在创建时 如果有升级列表 切第一个参数 为0时，设置其为透明 陶晶 2013-4-12 
			local obuilding = w:getlordU("building")
			if obuilding then
				local m_town = obuilding:gettown()
				for i = 1, #m_town.data.upgrade do
					if m_town.data.upgrade[i].indexOfCreate == d.indexOfCreate then
						if m_town.data.upgrade[i].upgradelist[1] == 0 then
							oUnit.handle.s:setOpacity(150)
						end
					end
				end
			end
		end

		------------------
		--为地图加名字和框
		------------------
		if oUnit~=nil then
			--娱乐地图加皇冠和别的
			if w.data.map == hVar.PHONE_VIPMAP then
				oUnit.chaUI["Crown"..oUnit.data.id] = hUI.image:new({
					parent = oUnit.handle._tn,
					model = "UI:ach_king",
					x = 40,
					y = -47,
					scale = 0.8,
				})
				if oUnit.data.id then
					if hVar.tab_unit[oUnit.data.id].mapkey == "world/level_xlslc" or hVar.tab_unit[oUnit.data.id].mapkey == "world/level_lcfj" or hVar.tab_unit[oUnit.data.id].mapkey == "world/level_lcfj2" then
						oUnit.chaUI["diffimage"..oUnit.data.id] = hUI.image:new({
							parent = oUnit.handle._tn,
							model = "UI:difficulty",
							x = -20,
							y = -47,
							scale = 0.8,
						})

						oUnit.chaUI["difflab"..oUnit.data.id] = hUI.label:new({
							parent = oUnit.handle._tn,
							x = -5,
							y = -37,
							text = "0",
							font = "numWhite",
							size = 20,
							align = "LT",
							border = 1,
						})

						oUnit.chaUI["enemy_image"..oUnit.data.id] = hUI.image:new({
							parent = oUnit.handle._tn,
							model = "ICON:action_attack",
							x = 30,
							y = -50,
							scale = 0.4,
						})

						oUnit.chaUI["enemy_num"..oUnit.data.id] = hUI.label:new({
							parent = oUnit.handle._tn,
							x = 45,
							y = -37,
							font = "numWhite",
							text = "0",
							size = 20,
							align = "LT",
							border = 1,
						})
					end
				end
			end
		end
	end
end)

--Ax4.nearNode = {
		----这里表示是四方向搜索格子，如果需要多方向寻路请扩展
		----{x偏移，y偏移，移动权值G}
		--{0,-1,10},
		--{0,1,10},
		--{1,0,10},
		--{-1,0,10},
		--{-1,-1,14},
		--{-1,1,14},
		--{1,-1,14},
		--{1,1,14},
	--}

local _hp = hClass.player

--------------------------------
-- 加载底部资源条
--------------------------------
function UI_InitShopFrame(parent,x,y)
end

-----------------------------
--根据战报计算经验值
hApi.CalculateBattleExp = function(oWorld,oHero)
	local ExpGet = 0
	local oPlayer = oHero:getowner()
	for i = 1,oWorld.__LOG.i do
		local v = oWorld.__LOG[i]
		if v.key=="unit_killed" and v.target.indexOfTeam~=0 then
			local a = oPlayer:allience(hGlobal.player[v.target.owner])
			if a==hVar.PLAYER_ALLIENCE_TYPE.ENEMY and hVar.tab_unit[v.target.id] then
				local tabU = hVar.tab_unit[v.target.id]
				if tabU then
					if v.target.level>0 then
						--是英雄
						ExpGet = ExpGet + 40 + v.target.level*10
					else
						local uLv = hVar.tab_unit[v.target.id].unitlevel or 1
						local expOfLv = hVar.UNIT_EXP[uLv] or hVar.UNIT_EXP[#hVar.UNIT_EXP]
						ExpGet = ExpGet + expOfLv*v.target.stack
					end
				end
			end
		end
	end
	return ExpGet
end

-----------------------------
--获得战场内的敌人
hApi.GetEnemyInBattlefield = function(oWorld,oPlayer)
	for k in pairs(oWorld.data.lords)do
		local u = oWorld:getlordU(k)
		if oPlayer:allience(u:getowner())~=hVar.PLAYER_ALLIENCE_TYPE.OWNER then
			return u
		end
	end
end

-----------------------------
--读取单位的奖励
hApi.ReadUnitLoot = function(oUnit,tRet)
	local tgrData = oUnit:gettriggerdata()
	if tgrData~=nil and type(tgrData.loot)=="table" then
		local loot = tgrData.loot
		for i = 1,#loot do
			tRet[#tRet+1] = {unpack(loot)}
		end
	end
	return tRet
end

-----------------------------
--读取单位奖励内容
hApi.LoadEventReward = function(rewardList,rewardTab)
	if type(rewardList)=="table" then
		for i = 1,#rewardList do
			local typ,ex,num = unpack(rewardList[i])
			if typ=="res" then
				local rType = hVar.RESOURCE_TYPE[ex]
				if rType~=nil and hVar.RESOURCE_ART[rType]~=nil then
					rewardTab[#rewardTab+1] = {
						model = hVar.RESOURCE_ART[rType].icon,
						num = math.max(1,num),
						index = i,
					}
				end
			elseif typ=="attr" then
				if ex=="exp" then
					rewardTab[#rewardTab+1] = {
						model = "ICON:ATTR_exp",
						num = math.max(1,num),
						index = i,
					}
				end
			end
		end
	end
	return rewardTab
end

--将参数 传入的表产生成随机的
hApi.RandomIndex = function(tabNum,indexNum,rTab)
	indexNum = indexNum or tabNum
	local t = {}
	for i = 1,indexNum do
		local ri = hApi.random(1,tabNum + 1 - i)
		local v = ri
		for j = 1,tabNum do
			if not t[j] then
				ri = ri - 1
				if ri == 0 then
					table.insert(rTab,j)
					t[j] = true
				end
			end
		end
	end
end

local __ShareAttrLoopKey = {
	hp = 1,
	mp = 1,
	hp_pec = 1,
	mp_pec = 1,
}
hApi.UnitGetLoot = function(oUnit,typ,ex,num,fromUnit,paramA,paramB,paramC,paramD,paramE,paramF)
	--print("hApi.UnitGetLoot", oUnit,typ,ex,num,fromUnit,paramA,paramB,paramC,paramD,paramE,paramF)
	if typ =="res" then
		local rType = hVar.RESOURCE_TYPE[ex]
		if rType~=nil and hVar.RESOURCE_ART[rType]~=nil then
			if fromUnit~=nil then
				oUnit:getowner():addresource(hVar.RESOURCE_TYPE[ex],num,hVar.RESOURCE_GET_TYPE.LOOT,fromUnit,oUnit)
			else
				oUnit:getowner():addresource(hVar.RESOURCE_TYPE[ex],num)
			end
		end
	elseif typ =="attr" then
		local oHero = oUnit:gethero()
		if oHero then
			oHero:addattr(ex,num,nil,fromUnit)
			if oHero.data.HeroTeam~=0 and oHero.data.HeroTeam.n>0 then
				local IsShareWithTeam = 0
				local nPlayMode
				if __ShareAttrLoopKey[ex] then
					IsShareWithTeam = 1
				elseif ex=="exp" then
					if oHero.data.playmode==hVar.PLAY_MODE.NO_HERO_CARD then
						IsShareWithTeam = 1
						nPlayMode = hVar.PLAY_MODE.NO_HERO_CARD
					end
				end
				if IsShareWithTeam==1 then
					local team = oHero.data.HeroTeam
					for i = 1,#team do
						if type(team[i])=="table" then
							local cHero = hClass.hero:find(team[i][1])
							if cHero.__ID==team[i][2] and (nPlayMode or cHero.data.playmode)==cHero.data.playmode then
								cHero:addattr(ex,num,1,fromUnit)
							end
						end
					end
				end
			end
		end
	elseif typ == "attrW" then
		local oHero = oUnit:gethero()
		if oHero then
			oHero:addattrW(ex,num)
		end
	elseif typ == "treasure" and type(num) == "table" then
		local ResetCount = paramA
		local fromBag = paramB
		local fromBagIndex = paramC
		local fromItem = paramD
		local rewardlist = {}
		local tempDrop
		if type(num[1])=="table" then
			tempDrop = num[1]
		else
			if hVar.tab_drop[num[1]] then
				tempDrop = hVar.tab_drop[num[1]]
			else
				local dI = hVar.tab_drop.index[num[1]]
				if dI then
					tempDrop = hVar.tab_drop[dI]
				end
			end
		end
		
		local tempItem = {}
		
		if #num == 9 then
			for i = 2,#num do
				local id = hApi.RandomItemId(tempDrop,num[i][1],num[i][2])
				if hVar.tab_item[id] then
					--掉出东西了！
					tempItem[#tempItem+1] = id
				else
					--如果啥都没掉出来的话，掉个等级0的东西给他
					tempItem[#tempItem+1] = hVar.TokenRandomItem[hApi.random(1,#hVar.TokenRandomItem)]
				end
			end
		end
		local temp = {}
		hApi.RandomIndex(#tempItem,8,temp)
		for i = 1,8 do
			local itemID = tempItem[temp[i]]
			rewardlist[i] = {ex,itemID,hVar.tab_stringI[itemID][1],0,0,0,0} --类型，道具ID，道具名字，道具出现的几率，3个可选参数
		end
		
		hGlobal.event:event("localEvent_ShowRewardFrm",oUnit,rewardlist,ResetCount,10,fromBag,fromBagIndex,fromItem,nil,paramF)
	elseif typ == "item" then
		local oHero = oUnit:gethero()
		if oHero then
			local fromBag,fromBagIndex = paramA,paramB
			local fw = {}

			--如果是从宝箱得到的道具，paramC 代表重转次数 paramD 代表道具信息
			if paramC and paramD and paramD[9] then
				fw[1] = paramD[9]
				fw[2] = {hVar.ITEM_FROMWHAT_TYPE.TREASURE,paramD[1],paramC,0}
			end

			if paramE then
				fw[#fw+1] = paramE
			end
			
			local rewardEx = -1
			local oWorld = hGlobal.WORLD.LastWorldMap
			if oWorld and oWorld.ID>0 and type(oWorld.data.mapbag)=="table" then
				rewardEx = {0}
			end
			
			if type(fromBag)=="string" and type(fromBagIndex)=="number" then
				
				oHero:additembyID(ex,rewardEx,"Loot",fromBag,fromBagIndex,fw)
			else
				oHero:additembyID(ex,rewardEx,"Loot",nil,nil,fw)
			end
		end
	elseif typ == "score" then
		--只给当前玩家,或者友军增加积分
		local nAlly = hGlobal.LocalPlayer:allience(oUnit:getowner())
		if nAlly==hVar.PLAYER_ALLIENCE_TYPE.OWNER or nAlly==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
			LuaAddPlayerScore(tonumber(num))
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	elseif typ == "battlefieldskill" then
		--只给当前玩家,或者友军获得战术技能卡
		local nAlly = hGlobal.LocalPlayer:allience(oUnit:getowner())
		if nAlly==hVar.PLAYER_ALLIENCE_TYPE.OWNER or nAlly==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
			if hVar.tab_tactics[ex]~=nil and num>0 then
				num = math.min((hVar.tab_tactics[ex].level or 1),num)
				
				hGlobal.event:event("localEvent_ShowBattlefieldSkillFrm",{{ex,num}},nil,nil,1)
			end
		end
	elseif typ == "treasure_score" then
		local ResetCount = paramA
		--积分宝箱
		local rewardlist = {}
		for i = 1,8 do
			rewardlist[i] = {ex,"random",{num[i][1],num[i][2]}}
		end
		hGlobal.event:event("localEvent_ShowRewardFrm",oUnit,rewardlist,ResetCount,10,nil,nil,nil,nil,paramF)
	elseif typ == "treasure_bfskillcard" then
		local tempList = hApi.RandomTacticsIdFromPack(ex)
		hGlobal.event:event("localEvent_ShowReverseCardFrm",tempList,num,paramD[1])
	elseif typ == "skill" then
		local oHero = oUnit:gethero()
		if oHero then
			if hVar.tab_skill[ex] then
				oHero.data.academySkill[1] = {ex,1}
			end
		end
	end
end

--hApi.LocalPlayerGetQuestReward = function(tLoot,sFromQuestType,UniqueQuestID)
--	local NeedSave = 1
--	local tItemList = {}
--	for i = 1,#tLoot do
--		local v = tLoot[i]
--		if v[1]=="item" then
--			local id,_,nTgrID = v[2],v[3],v[4]
--			local tabI = hVar.tab_item[id]
--			if tabI then
--				if tabI.type==hVar.ITEM_TYPE.RESOURCES then
--					local resType = tabI.resource[1]
--					local resVal = tabI.resource[2]
--					if resType == "score" then
--						LuaAddPlayerScore(resVal)
--						NeedSave = 1
--					end
--				else
--					local nSlotNum = hApi.GetQuestRewardItemSlotNum(id)
--					local tSlot = hApi.NumTable(nSlotNum+1)
--					tSlot[1] = nSlotNum
--					tItemList[#tItemList+1] = {id,tSlot,nTgrID}
--				end
--			end
--		elseif v[1]=="battlefieldskill" then
--			local id,lv,nTgrID = v[2],v[3],v[4]
--			if hVar.tab_tactics[id] and lv>0 then
--				--判断战术技能卡计数器 是否正常
--				--if hApi.CheckBFSCardIllegal(g_curPlayerName) == 1 then
--					--return
--				--end
--				lv = math.min((hVar.tab_tactics[id].level or 1),lv)
--				if LuaAddPlayerSkillBook(id,lv) == 1 then
--					NeedSave = 1
--				else
--					print("get bfskillCard fail")
--				end
--			end
--		end
--	end
--	if #tItemList>0 then
--		local oHeroCur
--		local oUnit = hGlobal.LocalPlayer:getfocusunit("worldmap")
--		if oUnit then
--			local oHero = oUnit:gethero()
--			if oHero and oHero.data.HeroCard==1 then
--				oHeroCur = oHero
--			end
--		end
--		if oHeroCur==nil then
--			for i = 1,#hGlobal.LocalPlayer.heros do
--				local oHero = hGlobal.LocalPlayer.heros[i]
--				if type(oHero)=="table" and oHero.data.HeroCard==1 then
--					oHeroCur = oHero
--					break
--				end
--			end
--		end
--		if oHeroCur~=nil then
--			for i = 1,#tItemList do
--				local nItemID,tSlot,nTgrID = tItemList[i][1],tItemList[i][2],tItemList[i][3]
--				oHeroCur:additembyID(nItemID,tSlot,sFromQuestType,nil,nil,{{hVar.ITEM_FROMWHAT_TYPE.MISSION,hVar.MAP_INFO[hGlobal.WORLD.LastWorldMap.data.map].uniqueID,nTgrID,0}})
--			end
--		else
--			oHeroCur = hClass.hero:new({
--				id = 5000,		--为什么是5000呢?因为是玩家就有刘备啊！
--				owner = 9,
--			})
--			--oHeroCur.data.HeroCard = 1
--			for i = 1,#tItemList do
--				local nItemID,tSlot,nTgrID = tItemList[i][1],tItemList[i][2],tItemList[i][3]
--				oHeroCur:additembyID(nItemID,tSlot,sFromQuestType,"playerbag",nil,{{hVar.ITEM_FROMWHAT_TYPE.MISSION,hVar.MAP_INFO[hGlobal.WORLD.LastWorldMap.data.map].uniqueID,nTgrID,0}})
--			end
--			oHeroCur:del()
--		end
--	end
--	if NeedSave==1 and Save_PlayerData then
--		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
--	end
--	
--	--如果是地图唯一任务则发送一条友盟统计
--	if sFromQuestType == "uquest" then
--		local mapName = hGlobal.WORLD.LastWorldMap.data.map
--		local mapUid = hVar.MAP_INFO[mapName].uniqueID
--		xlAppAnalysis("map_uquest",0,1,"info-","uID:"..tostring(xlPlayer_GetUID()).."-PN:"..tostring(g_curPlayerName).."-T:"..os.date("%m%d%H%M").."-mapID:"..tostring(mapUid).."-QID:"..tostring(UniqueQuestID))
--	end
--end

hApi.HeroHireUnit = function(oWorld,oUnit,oTarget,tData,tBuyList)
	--tBuyList:{[0]=shopNum,[1]={tDataPos,tDataNum},...}
	--tData:{[1]={id,num,max},...}
	local ttBuyList = tBuyList
	local buyTab = {}
	local resourceCost = {}
	local hireIndexByID = {}
	local hireList = tData.hireList
	if hireList==nil or hireList==0 then
		_DEBUG_MSG("该单位无雇佣列表")
		return hVar.RESULT_FAIL
	end
	local _ID,_CNUM,_MNUM,_PRICE = 1,2,3,4
	local _ptLen = #hVar.UNIT_PRICE_DEFINE
	for i = 1,_ptLen do
		resourceCost[i] = 0
	end
	for i = 1,#hireList do
		hireIndexByID[hireList[i][_ID]] = i
	end

	for i = 1,#ttBuyList do
		local id = ttBuyList[i][1]
		local indexOfData = hireIndexByID[id]
		if indexOfData~=nil then
			local v = hireList[indexOfData]
			local _numMax = 0
			for j = 1,#hireList do
				_numMax = _numMax + hireList[j][2]
			end
			local num = ttBuyList[i][2]
			
			if v and _numMax>=num then
				local id = v[_ID]
				buyTab[#buyTab+1] = {id,num}

				local price = hApi.GetTableValue(hVar.tab_unit,id).price
				if price~=nil then
					for k = 1,_ptLen do
						resourceCost[k] = resourceCost[k] + (price[k] or 0)*num
					end
				end
			end
		end
	end
	local p = oUnit:getowner()
	if p and #buyTab>0 then
		local IsPlayerHaveEnoughResource = 1
		for i = 1,_ptLen do
			if p:getresource(hVar.UNIT_PRICE_DEFINE[i])<resourceCost[i] then
				IsPlayerHaveEnoughResource = 0
				print("[HINT]购买部队所需的资源:"..(hVar.RESOURCE_KEY_DEFINE[hVar.UNIT_PRICE_DEFINE[i]] or "NONE").."不足！购买失败！")
				return hVar.RESULT_FAIL
			end
		end
		if IsPlayerHaveEnoughResource==1 then
			if oUnit:teamaddunit(buyTab)==hVar.RESULT_SUCESS then
				--扣掉商店里面的兵
				for i = 1,#buyTab do
					local indexOfData = hireIndexByID[buyTab[i][1]]
					if indexOfData~=nil then
						local _numMax = 0
						for j = 1,#hireList do
							_numMax = _numMax + hireList[j][2]
							hireList[j][2] = 0
						end
						hireList[indexOfData][_CNUM] = _numMax - buyTab[i][2]
						if oUnit.data.IsAi ~= 1 then
							hGlobal.event:call("Event_HireConfirm",oUnit,oTarget,tBuyList)
						end
					end
				end
				for i = 1,_ptLen do
					p:addresource(hVar.UNIT_PRICE_DEFINE[i],-1*resourceCost[i])
				end
				return hVar.RESULT_SUCESS
			else
				return hVar.RESULT_FAIL
			end
		end
		return hVar.RESULT_FAIL
	end
	return hVar.RESULT_FAIL
end

hApi.HeroBuyItem = function(oWorld,oUnit,oTarget,tData,tBuyList)
	print("购买物品！")
end

local __IsUnitInRange = function(w,u,t,rMin,rMax)
	local sus
	local ux,uy = u.data.gridX,u.data.gridY
	hApi.enumNearGrid(t.data.gridX,t.data.gridY,t:getblock(),function(gridX,gridY)
		local r = w:distanceG(ux,uy,gridX,gridY,1)
		if r and r>=rMin and r<=rMax then
			sus = true
		end
	end)
	return sus
end

local __CalTargetHarm = function(u)
	local a = u.attr
	if a.mxhp>0 then
		return math.floor((a.attack[4]+a.attack[5])*100/a.mxhp)
	else
		return math.floor((a.attack[4]+a.attack[5])*100)
	end
end


-----------------------------------
--小战场单位AI
hApi.BF_UnitRunAI = function(oUnit)
--	if not(oUnit and oUnit.ID>0) then
--		return
--	end
--	local oWorld = oUnit:getworld()
--	if not(oWorld and oWorld.ID>0) or oWorld.data.IsPaused==1 then
--		return
--	end
--	local oRound = oWorld:getround()
--	if not(oRound and oRound.ID>0) then
--		return
--	end
--	local nUnique = oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.nUnique)
--	if type(nUnique)~="number" then
--		_DEBUG_MSG("无法运行单位AI，请检查")
--		return
--	end
--	local tAIPlayerMemory,tAIUnitMemory = hApi.UpdateAIMemory(oUnit)
--	local AIPlayer = oUnit:getowner()
--	local IsThinking = 6
--	local tabU = oUnit:gettab()
--	local AIGrid,nSkillId
--	local oTarget,tGrid
--	local AIProcessCode = function()
--		if oRound.ID~=0 and oRound:getworld()==oWorld and oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.nUnique)==nUnique and IsThinking>0 then
--			if oWorld.data.IsPaused==1 then
--				if oWorld.data.PausedByWhat=="Victory" then
--					AIGrid = nil
--					hApi.clearTimer("__BF__AICommonOperate")
--					_DEBUG_MSG("战场已经结束,AI计时器关闭")
--				else
--					_DEBUG_MSG("战场暂停，AI不做操作")
--				end
--				return
--			end
--			if oWorld:operateable()~=hVar.RESULT_SUCESS then
--				--_DEBUG_MSG("战场禁止操作中")
--				return
--			end
--			if IsThinking>2 then
--				--AI激活后停滞一段时间
--				IsThinking = math.max(2,IsThinking - 1) 
--			else
--				if IsThinking==2 then
--					AIGrid = oUnit:calculate("AiTarget",tAIPlayerMemory.mode)
--				elseif IsThinking==1 then
--					hApi.AIMove(oUnit,AIGrid,tAIUnitMemory)
--				end
--				IsThinking = IsThinking - 1
--			end
--		else
--			if oRound.ID==0 or oWorld.data.unitcountM<=0 then
--				AIGrid = nil
--				hApi.clearTimer("__BF__AICommonOperate")
--				if oRound.ID~=0 and oRound.data.auto==0 then
--					if oRound:top(1,hVar.ROUND_DEFINE.DATA_INDEX.nUnique)==nUnique then
--						--print("AI:略过操作2")
--						return AIPlayer:order(oWorld,hVar.OPERATE_TYPE.PLAYER_SKIP_UNIT_OPERATE,oUnit)
--					else
--						_DEBUG_MSG("已经移交了操控权,AI不发送跳过命令")
--					end
--				end
--			else
--				--print("AI:仍有单位移动中，等待移动完成跳过操作")
--			end
--		end
--	end
--	hApi.addTimerForever("__BF__AICommonOperate",hVar.TIMER_MODE.GAMETIME,100,function()
--		AIProcessCode()
--	end)
end

--小战场AI移动和攻击
local __ClearMemoryCount = 0
hGlobal.event:listen("Event_BattlefieldUnitActived","__BF__AICommonOperate",function(oWorld,oRound,oUnit)
	if oWorld.data.IsQuickBattlefield~=1 then
		__ClearMemoryCount = __ClearMemoryCount + 1
		if __ClearMemoryCount>5 then
			__ClearMemoryCount = 0
			--collectgarbage()
		end
	end
	if oWorld.data.PausedByWhat=="Victory" then
		return
	end
	if oWorld.data.netdata~=0 then
		--网络战斗
		local IsAI = 0
		local IsPlayer = 0
		local IsHost = 0
		local tNetData = oWorld.data.netdata.PlayerParam
		for i = 1,#tNetData do
			if i==oUnit.data.control then
				IsPlayer = 1
				break
			end
		end
		local tAIData = oWorld.data.netdata.AIPlayer
		if type(tAIData)=="table" then
			for i = 1,#tAIData do
				if tAIData[i]==oUnit.data.control then
					IsAI = 1
					break
				end
			end
		end
		if hGlobal.LocalPlayer.data.playerId==1 then
			IsHost = 1
		end
		if IsPlayer==1 then
			--如果是玩家的话，只能由本地玩家发送命令
			if oWorld.data.autoBF==1 and oUnit:getcontroller()==hGlobal.LocalPlayer then
				hApi.BF_UnitRunAI(oUnit)
			end
		else
			--如果不是玩家的，只能由host发送命令
			if IsAI==1 and IsHost==1 then
				hApi.BF_UnitRunAI(oUnit)
			end
		end
	else
		--本地战斗
		if oUnit:getcontroller()==hGlobal.LocalPlayer then
			if oWorld.data.autoBF==1 then
				hApi.BF_UnitRunAI(oUnit)
			end
		else
			hApi.BF_UnitRunAI(oUnit)
		end
	end
end)

local __ENUM__UnitAnimationPreload = function(oUnit)
	if oUnit.handle._c and oUnit.handle.__IsTemp~=0 and (oUnit.data.type==hVar.UNIT_TYPE.UNIT or oUnit.data.type==hVar.UNIT_TYPE.HERO) and type(oUnit.handle.modelIndex)=="number" then
		local modelData = hVar.tab_model[oUnit.handle.modelIndex]
		if type(modelData)=="table" and type(modelData.animation)=="table" then
			for i = 1,#modelData.animation do
				local aniKey = modelData.animation[i]
				if modelData[aniKey] then
					hResource.model:loadModel(modelData.image,modelData,aniKey,oUnit.handle,g_frame_CCArray)
					g_frame_CCArray:removeAllObjects()
				end
			end
		end
	end
end
hGlobal.event:listen("Event_BattlefieldCreated","__BF__ResourcePreload",function(oWorld)
	--小战场单位动作预加载
	oWorld:enumunit(__ENUM__UnitAnimationPreload)
	--预加载近战攻击打击特效
	hResource.model:loadTexture("effect/burst_3.png",nil,hVar.TEMP_HANDLE_TYPE.OBJECT_BF)
end)

--hGlobal.event:listen("LocalEvent_CreateHeroOnMap","Griffin_wdld",function(oWorld,hid,index,replaceTable)
--	if g_editor ~= 1 then
--		local mx = 0
--		local my = 0
--		local maxTriggerID = 0
--		oWorld:enumunit(function(oUnit)
--			if oUnit.data.triggerID > maxTriggerID then
--				maxTriggerID = oUnit.data.triggerID
--			end
--		end)
--		if replaceTable ~= nil then
--			if replaceTable[1] ~= 0 then
--				mx = replaceTable[2]
--				my = replaceTable[3]
--			end
--		else
--			for i = 1,#oWorld.data.waypoint do
--				if oWorld.data.waypoint[i][1] == "myHero"..index then
--					mx = oWorld.data.waypoint[i][2]
--					my = oWorld.data.waypoint[i][3]
--				end
--			end
--			
--			mx, my = hApi.Scene_GetSpace(mx, my, 20)
--		end
--		local c,u
--		c = hApi.addChaByID(hGlobal.WORLD.LastWorldMap,hGlobal.LocalPlayer.data.playerId,hid,mx,my,225,nil)
--		u = hApi.findUnitByCha(c)
--		u.data.triggerID = maxTriggerID + 1
--		local oHero = hClass.hero:new({
--			name = hVar.tab_stringU[hid][1],
--			id = hid,
--			unit = u,
--			owner = hGlobal.LocalPlayer.data.playerId,
--			HeroCard = 1,
--		})
--		oHero.data.playmode = hVar.PLAY_MODE.NORMAL
--		oHero:LoadHeroFromCard("newgame")
--		oHero.data.triggerID = maxTriggerID + 1
--
--		local tgrIndex = oWorld.data.triggerIndex
--		local tgrDataN = {uniqueID = oHero.data.triggerID}
--		tgrIndex[#tgrIndex + 1] = {u.ID,u.__ID,tgrDataN}
--		print("new        u.ID",u.ID)
--		if replaceTable ~= nil then
--			local reid = 0
--			local wx = 0
--			local wy = 0
--
--			if replaceTable[1] ~= 0 then
--				reid = replaceTable[1]
--				wx = replaceTable[2]
--				wy = replaceTable[3]
--			end
--
--
--			if reid ~= 0 then
--				u:settriggerdata(nil,reid)
--				local gx,gy = oWorld:xy2grid(wx,wy)
--				u:setgrid(gx,gy)
--				u:movetogrid(gx,gy,nil,hVar.OPERATE_TYPE.UNIT_MOVE)
--			end
--		end
--	end
--end)

--hGlobal.event:listen("LocalEvent_CreateHeroAndTeamOnMap","Griffin_wdld",function(oWorld,hid,team,index)
--	local mx = 0
--	local my = 0
--	local maxTriggerID = 0
--	oWorld:enumunit(function(oUnit)
--		if oUnit.data.triggerID > maxTriggerID then
--			maxTriggerID = oUnit.data.triggerID
--		end
--	end)
--	for i = 1,#oWorld.data.waypoint do
--		if oWorld.data.waypoint[i][1] == "atkHero"..index then
--			mx = oWorld.data.waypoint[i][2]
--			my = oWorld.data.waypoint[i][3]
--		end
--	end
--	
--	mx, my = hApi.Scene_GetSpace(mx, my, 20)
--	local c,u
--	c = hApi.addChaByID(hGlobal.WORLD.LastWorldMap,hGlobal.LocalPlayer.data.playerId,hid,mx,my,45,nil)
--	u = hApi.findUnitByCha(c)
--	u.data.triggerID = maxTriggerID + 1
--	local oHero = hClass.hero:new({
--		name = hVar.tab_stringU[hid][1],
--		id = hid,
--		unit = u,
--		owner = hGlobal.LocalPlayer.data.playerId,
--		HeroCard = 1,
--	})
--	oHero.data.playmode = hVar.PLAY_MODE.NORMAL
--	oHero:LoadHeroFromCard("newgame")
--	oHero.data.triggerID = maxTriggerID + 1
--	u:teamaddunit(team)
--
--	--oWorld:enumunit(function(oUnit)
--		--print(oUnit.data.triggerID)
--		--if oUnit.data.triggerID > maxTriggerID then
--			--maxTriggerID = oUnit.data.triggerID
--		--end
--	--end)
--	--oHero:addexp(ht.attr.exp)
--	--oHero:addattrbyitem({8007})
--end)
--检测本地玩家是否有剩余的行动点数以及建造次数 陶晶 2013-4-22
CheckPlayerEndDay = function()
	local BuildingResult = 0
	local MovePointResult = 0
	local TownUnit = 0
	local temppoint = 0

	--城镇建造判断
	for i = 1 ,#hGlobal.LocalPlayer.data.ownTown do
		TownUnit = hApi.GetObjectUnit(hGlobal.LocalPlayer.data.ownTown[i])
		--只有自己的主城才做判断
		if TownUnit and TownUnit.data.owner == 1 then
			local oTown = TownUnit:gettown()
			if oTown and oTown:checkBuilding() == 0 and oTown.data.buildingCount == 0 then
				BuildingResult = 1
			end
		end
	end

	--英雄行动力判断
	for i = 1 ,#hGlobal.LocalPlayer.heros do
		local oHero = hGlobal.LocalPlayer.heros[i]
		if oHero and oHero.data.IsDefeated == 0 then
			local oUnit = oHero:getunit()
			if oUnit then
				temppoint = hApi.chaGetMovePoint(oUnit.handle)
				if temppoint> 0 and oUnit:isTownGuard() == 0 then
					MovePointResult = 1
				end
			end
		end
	end

	return BuildingResult,MovePointResult
end

hApi.GetNextMapNameEx = function(mapName)
	for k,v in pairs(hVar.MAP_INFO) do
		if k == mapName then
			return v.nextmap
		end
	end
	return nil
end

hApi.GetLastMapNameEx = function(mapName)
	for k,v in pairs(hVar.MAP_INFO) do
		if k == mapName then
			return v.unLock
		end
	end
	return nil
end

hApi.CheckUnlockMap = function(mapName)
	if mapName == hVar.tab_chapter[1].firstmap then return 1 end

	for k,v in pairs(hVar.MAP_INFO) do
		if k == mapName then
			if type(v.unLock) == "table" then
				for i = 1 , #v.unLock do
					if LuaGetPlayerMapAchi(v.unLock[i],hVar.ACHIEVEMENT_TYPE.LEVEL) == 0 then
						return 0
					end
				end
				return 1
			end
			return 0
		end
	end

	return 2
end

hApi.GetCurMapLevel = function(cur_mapName)
	for k,v in pairs(hVar.MAP_INFO) do
		if k == cur_mapName then
			return v.level or -1
		end
	end
end

hApi.GetMapNameLabInfo = function(mapName)
	--找剧情地图
	for i = 1,#hVar.STORYMAP do
		for j = 1,#hVar.STORYMAP[i] do
			if hVar.STORYMAP[i][j][1] == mapName then
				local nameInfo = hVar.STORYMAP[i][j][4]
				return nameInfo
			end
		end
	end

	--找娱乐地图
	for i = 1,#hVar.AMUSEMENTMAP do
		for j = 1,#hVar.AMUSEMENTMAP[i] do
			if hVar.AMUSEMENTMAP[i][j][1] == mapName then
				local nameInfo = hVar.AMUSEMENTMAP[i][j][4]
				return nameInfo
			end
		end
	end

	for k,v in pairs(hVar.MAP_INFO) do
		if k == mapName then
			local nameInfo = v.childMapName
			return nameInfo
		end
	end
	return nil
end
-------------------------------------------------------------地图数据相关 已经废弃 ---------------------------------------------

--获取下一张地图名字，测试用代码
hApi.GetNextMapName = function(cur_mapName)
	local curLevel = hApi.GetCurMapLevel(cur_mapName)
	if curLevel == -1 then 
		if hVar.MAP_INFO[cur_mapName].nextmap then
			return hVar.MAP_INFO[cur_mapName].nextmap
		end
		return -1 
	end
	local nextLevel = curLevel+1
	for k,v in pairs(hVar.MAP_INFO) do
		if v.level == nextLevel then
			return k
		end
	end
	return 0
end

--获取上一张地图名字，测试用代码
hApi.GetLastMapName = function(cur_mapName)
	local curLevel = hApi.GetCurMapLevel(cur_mapName)
	local lastLevel = curLevel-1
	if lastLevel == 0 then return 0 end

	for k,v in pairs(hVar.MAP_INFO) do
		if v.level == lastLevel then
			return k
		end
	end
	return 0
end

--------------------------------------------------------------------------------------------------------------------------------------
function hApi.LuaReleaseBattlefield(IsFlush)
	--hClass.unit:clear_static()
	hClass.action:clear_static()
	--hClass.world:clear_static()
	hClass.round:clear_static()
	--hClass.effect:clear_static()
	if IsFlush~=0 then
		collectgarbage()
		xlLG("init","collectgarbage() - 退出战场\n")
	end
end
----------------------------------------
-- 下面都是调试代码
--hClass.world.drawgrid = function()
--end

--hClass.world.log = function()
--end

--排错用函数
--local __EFF__count = 0
--hApi.SaveEffectTab = function(key)
	--__EFF__count = __EFF__count + 1
	--local tab = hApi.SaveTableEx(hClass.effect,{"OBJ_TAB"},{meta=1,__static=1,sync_tab=1,handle=1,chaUI=1,localdata=1})
	--local f = io.open("ClassErrorLOG["..__EFF__count.."]["..tostring(key).."].lua","w")
	--for i = 1,#tab do
		--f:write(tab[i])
	--end
	--f:close()
--end

hApi.TD__Camera_Follow = function(oWorld)
	local n = 1
	local count = 0
	--镜头自动跟随
	oWorld:addtimer("__TD__Camera_Follow_", 1, function(deltaTime)
		if (oWorld.data.keypadEnabled == true) or (oWorld.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.TANKCONFIG) then --允许响应事件
			local oHero = oWorld:GetPlayerMe().heros[1]
			if oHero then
				local oUnit = oHero:getunit()
				if oUnit then
					--geyachao: 怀疑震动导致crash，先注释掉
					--[[
					local px, py = hApi.chaGetPos(oUnit.handle)
					local range = oWorld.data.shakerange or 10
					if oWorld.data.lockscreen>0 then
						if oWorld.data.shaketick > 0 then
							if oWorld.data.shakestarttime == 0 then
								oWorld.data.shakestarttime = os.clock()
							end
							if count == 0 then
								local curtime = os.clock()
								if curtime - oWorld.data.shakestarttime < oWorld.data.shaketick then
									if n == 1 then
										n = -1
									else
										n = 1
									end
									local randx = math.random(0,range)
									local randy = math.random(0,range) * (math.random(0,2)-1)
									local px1 = (oWorld.data.lockscreenX or px) + randx * n
									local py1 = (oWorld.data.lockscreenY or py) + randy
									hApi.setViewNodeFocus(px1, py1)
								else
									oWorld.data.shaketick = 0
									oWorld.data.shakestarttime = 0
									oWorld.data.shakerange = nil
									count = 0
									if oWorld.data.lockscreenX and oWorld.data.lockscreenY then
										hApi.setViewNodeFocus(oWorld.data.lockscreenX, oWorld.data.lockscreenY)
									end
								end
							else
								count = (count + 1)% 5
							end
						end
					--震动
					elseif oWorld.data.shaketick > 0 then
						if oWorld.data.shakestarttime == 0 then
							oWorld.data.shakestarttime = os.clock()
						end
						if count == 0 then
							local curtime = os.clock()
							if curtime - oWorld.data.shakestarttime < oWorld.data.shaketick then
								if n == 1 then
									n = -1
								else
									n = 1
								end
								local randx = math.random(0,range)
								local randy = math.random(0,range) * (math.random(0,2)-1)
								px = px + randx * n
								py = py + randy
								hApi.setViewNodeFocus(px, py)
							else
								oWorld.data.shaketick = 0
								oWorld.data.shakestarttime = 0
								oWorld.data.shakerange = nil
								count = 0
								if oWorld.data.lockscreen>0 then
									if oWorld.data.lockscreenX and oWorld.data.lockscreenY then
										hApi.setViewNodeFocus(oWorld.data.lockscreenX, oWorld.data.lockscreenY)
									end
								end
							end
						else
							count = (count + 1)% 5
						end
					else
						--print("启动图，镜头对准战车偏下方", oWorld.data.map)
						--启动图，镜头对准战车偏下方
						if (oWorld.data.map == hVar.LoginMap) then
							py = py + 650
						end
						
						--聚焦
						hApi.setViewNodeFocus(px, py)
					end
					]]
					local px, py = hApi.chaGetPos(oUnit.handle)
					--print("启动图，镜头对准战车偏下方", oWorld.data.map)
					--启动图，镜头对准战车偏下方
					if (oWorld.data.map == hVar.LoginMap) then
						py = py + 650
					end
					
					--聚焦
					hApi.setViewNodeFocus(px, py)
				end
			end
		end
	end)
end

hApi.addTimerOnce("__CloseEventX",1,function()
	--hVar.OPTIONS.IS_NO_AI = 1
	--hVar.OPTIONS.AUTO_BATTLEFIELD = 1
	--hGlobal.event:listen("LocalEvent_UnitListCreated","__BF__UnitList_Show",nil)
	--hGlobal.event:listen("Event_BattlefieldUnitActived","__BF__UnitList_NumChange",nil)
	--hGlobal.event:listen("LocalEvent_RoundChanged","__BF__UnitList_Update",nil)
	
	--hGlobal.event:listen("Event_BattlefieldRoundStart","__BF__ShowRoundCount",nil)
	
	--hGlobal.event:listen("Event_BattlefieldUnitActived","__BF__AICommonOperate",nil)
	
	--hGlobal.event:listen("LocalEvent_UnitAddAttrByAction","__BF__ShowAttrValue",nil)
	
	--hGlobal.event:listen("Event_BattlefieldUnitActived","__BF__ShowSkillPanel",nil)
	--hGlobal.event:listen("Event_UnitBorn","__BF__InitUnitHpUI",nil)
	--hGlobal.event:listen("Event_UnitDamaged","__BF__ShowChaDamaged",nil)
	--hGlobal.event:listen("Event_UnitHealed","__BF__ShowChaHealed",nil)
	--没有碎块特效
	--xlAddPhyBrokenEffect = hApi.DoNothing
	--不播放blink
	--xlAddGroundEffect = hApi.DoNothing
	--无震屏
	--xlView_Shake = hApi.DoNothing

	--hGlobal.event:listen("LocalEvent_BattlefieldResult","__BF_Result",function(oWorld,oUnitV,oUnitD,tLoot)
		----无战损统计
		--if oWorld.data.IsQuickBattlefield==1 then
			--return
		--end
		--local oUnitC,oUnitE,isVictory
		--if oUnitV:getowner():allience(hGlobal.LocalPlayer)==hVar.PLAYER_ALLIENCE_TYPE.ENEMY then
			----失败
			--oUnitC = oUnitD
			--oUnitE = oUnitV
			--isVictory = 0
		--else
			----胜利
			--oUnitC = oUnitV
			--oUnitE = oUnitD
			--isVictory = 1
		--end
		--hApi.addTimerOnce("__BF__HeroShowBattleLogFrame",750,function()
			--local _frm
			--_frm = hGlobal.UI.MsgBox("exit BF",{
				--ok=function()
					--hApi.ClearLocalDeadIllusion()
					--hApi.EnterWorld()
					--return hGlobal.event:event("Event_HeroAttackConfirm",nil,oUnitE,oUnitV==oUnitE)
				--end
			--})
		--end)
	--end)

	--hGlobal.event:listen("Event_NewDay","__TEST__AddArmy",function(nDayCount)
		--hClass.hero:enum(function(oHero)
			--if oHero.data.owner==1 then
				--local u = oHero:getunit()
				--if u then
					--u.data.team[7] = {10140,20}
				--end
			--end
		--end)
	--end)

	--首回合播放动作
	--hGlobal.event:listen("Event_BattlefieldRoundStart","__TEST__PlayPose",function(oWorld,oRound)
		--if oWorld.data.roundcount==1 then
			--oWorld:enumunit(function(u)
				--if u.data.type==hVar.UNIT_TYPE.UNIT or u.data.type==hVar.UNIT_TYPE.HERO then
					--u:setanimation({"attack","stand"})
				--end
			--end)
		--end
	--end)

	--hApi.SpriteSetAnimationByList = function(handleTable,animationList)
		--if animationList then
			----if ReadAnimationFromList(handleTable,handleTable.animationList, hVar.tab_model[handleTable.modelIndex], animationList)~=0 then
				----if handleTable.animationList[2]==1 then
					----hApi.SpritePlayAnimation(handleTable, handleTable.animationList[1],nil,1)
				----else
					----handleTable.animationList[1] = hApi.gametime() + hApi.SpritePlayAnimation(handleTable, handleTable.animationList[1],1,1)
				----end
			----end
		--end
		--return handleTable.animationList[1]
	--end

	--hClass.unit.setanimation = function(self,aniKey,forceToPlay)
		----(优化)不稳定代码
		--if self.handle.__appear==0 then
			--return
		--end
		--if self.handle.__manager=="lua" then
			--if type(aniKey)=="table" then
				--hApi.SpriteSetAnimationByList(self.handle,aniKey)
				--return self.handle.animationtime
			--else
				--if self.handle.__IsTemp==1 then
					--forceToPlay = 0
					--if aniKey~="stand" then
						--return self.handle.animationtime
					--end
				--end
				--hApi.SpriteSetAnimation(self.handle,aniKey,nil,forceToPlay)
				--return self.handle.animationtime
			--end
		--else
			--return -1
		--end
	--end

	--hApi.CreateEffect = function(effectMode,handleTable,scene,modelKey,scale,worldX,worldY,height,facing,animation,playCount)
		--handleTable.removetime = 0
		--handleTable.animationtime = 1
	--end

	---- 创建随身特效需要传入两个object，坑爹
	--hApi.CreateEffectU = function(oEffect,oUnit,bindKey,modelKey,scale,offsetX,offsetY,height,facing,animation,playCount)
		--local handleTable = oEffect.handle
		--local handleTableU = oUnit.handle
		--handleTable.animationtime = 1
		--handleTable.removetime = 0
	--end
	--可以重复打怪
	--hApi.CalculateBattleUnit = function(oWorld,oUnitV,oUnitD,mode)
		--if oWorld.data.IsQuickBattlefield==1 then
			--return
		--end
		--if mode=="Victory" then
			--return hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_LeaveBattlefield"].."?",{
				--ok = function()
					--hApi.EnterWorld()
				--end,
				--cancel = 1,
			--})
		--end
	--end
	--打完不扣兵
	--hApi.CalculateBattle = hApi.DoNothing
	--没有对话
	--hGlobal.UI.CreateUnitTalk = function(talkTable)
		--if #talkTable>1 then
			--for i = 1,#talkTable-1 do
				--if type(talkTable[i])=="function" then
					--talkTable[i]()
				--end
			--end
		--end
		--if #talkTable>=1 and type(talkTable[#talkTable])=="function" then
			--return talkTable[#talkTable]()
		--end
	--end
end)

--hGlobal.event:listen("Event_NewDay","__WM__CollectGarbage",function(nDayCount)
	--collectgarbage()
	--xlLG("init","collectgarbage() - 每天\n")
--end)

----------------------------------------------
----------------------------------------------
----@单位操作函数
--hApi.CreateUnit = function(handleTable,scene,modelKey,scale,worldX,worldY,height,facing,animation,IsHide)
	--if hGlobal.WORLD_LAYER["battlefield"]==xlScene_ToLayer(scene) then
		--modelKey = "MODEL:Default"
		--handleTable.__manager = "DEBUG"
		--handleTable.modelmode = 0
		--handleTable.animationlink = 0
		--handleTable.animationList = {0}
		--handleTable.removetime = 0
		--return
	--end
	--local zOffset = (height or 0) + hVar.ObjectZ.UNIT
	----初始化sprite
	--handleTable.s = hApi.ObjectInitSpriteCha(handleTable,scene,"cha",worldX,worldY,facing,zOffset)
	--if IsHide==1 then
		--handleTable._n:setVisible(false)
	--end
	----存在时间设置
	--handleTable.removetime = 0
	----初始化动作
	--local modelData = hApi.ObjectInitModel(handleTable,modelKey,scale,animation)
	--if modelData.modelmode=="DIRECTIONx8" then
		----8方向单位模型
		--handleTable.modelmode = "DIRECTIONx8"
		--handleTable.animationlink = "DIRECTION:"..tostring(hApi.calAngleD("DIRECTIONx8",facing or 180)).."_"
	--elseif modelData.modelmode=="DIRECTIONx4" then
		----4方向单位模型
		--handleTable.modelmode = "DIRECTIONx4"
		--handleTable.animationlink = "DIRECTION:"..tostring(hApi.calAngleD("DIRECTIONx4",facing or 180)).."_"
	--else
		--handleTable.modelmode = 0
		--handleTable.animationlink = 0
	--end
	--if handleTable._sce then
		----这里是dat储存的角度，无需转换
		--xlCha_FaceTo(handleTable._c,hApi.LeeAngleToRyanAngle(facing or 0))
	--end
	--hApi.ObjectPlayAnimation(handleTable,modelData,animation)
	--return handleTable._c
--end

----------------------------------------------
----------------------------------------------
--@特效操作函数
--hApi.CreateEffect = function(effectMode,handleTable,scene,modelKey,scale,worldX,worldY,height,facing,animation,playCount)
	--modelKey = "MODEL:Default"
	--local zOffset = (height or 0) + hVar.ObjectZ.EFFECT
	----初始化sprite
	--handleTable.s = hApi.ObjectInitSprite(handleTable,scene,effectMode,worldX,worldY,facing,zOffset)
	----存在时间设置
	--handleTable.removetime = 0
	----初始化动作
	--local modelData = hApi.ObjectInitModel(handleTable,modelKey,scale,animation)
	----if effectMode=="effectA" then
		----handleTable.roll = facing
	----end
	--if type(animation)~="table" and playCount>0 then
		--hApi.SpriteSetAnimationCount(handleTable,animation,playCount)
	--else
		--hApi.ObjectPlayAnimation(handleTable,modelData,animation)
	--end
	--return handleTable._c
--end

---- 创建随身特效需要传入两个object，坑爹
--hApi.CreateEffectU = function(oEffect,oUnit,bindKey,modelKey,scale,offsetX,offsetY,height,facing,animation,playCount)
	--modelKey = "MODEL:Default"
	--local handleTable = oEffect.handle
	--local handleTableU = oUnit.handle
	--handleTable.s = hApi.ObjectInitSprite(handleTable,nil,"effectU",offsetX,offsetY,facing,0)
	----存在时间设置
	--handleTable.removetime = 0
	----初始化动作
	--local modelData = hApi.ObjectInitModel(handleTable,modelKey,scale,animation)
	--if handleTableU._n then
		--handleTableU._n:addChild(handleTable._n)
		--handleTableU._n:reorderChild(handleTable._n,(height or 0))-- + hVar.ObjectZ.EFFECT)
		--if type(animation)=="string" and playCount>0 then
			--hApi.SpriteSetAnimationCount(handleTable,animation,playCount)
		--else
			--hApi.ObjectPlayAnimation(handleTable,modelData,animation)
		--end
	--end
--end

------------------------------------
--战场自动AI
hGlobal.event:listen("Event_BattlefieldStart","__EFF__AutoBF",function(oWorld)
	if hVar.OPTIONS.AUTO_BATTLEFIELD==1 then
		oWorld.data.autoBF = 1
	end
end)

--xlAddGroundEffect = hApi.DoNothing
xlLuaEvent_Snapshot = hApi.DoNothing

--gyachao: TD测试角色移动到达事件
--hGlobal.event:listen("Event_UnitArrive_TD", "__Event_UnitArrive_TD", function(oUnit)
	--local lockTarget = oUnit.data.lockTarget --锁定攻击的目标
	--删除移动的箭头特效
	--if (oUnit.data.JianTouEffect ~= 0) then
	--	oUnit.data.JianTouEffect:del()
	--	oUnit.data.JianTouEffect = 0
	--end
	
	--删除攻击箭头的特效
	--if (oUnit.data.AttackEffect ~= 0) then
	--	oUnit.data.AttackEffect:del()
	--	oUnit.data.AttackEffect = 0
	--end
--end)

--绘制血条
function unit_hpbar_loop()
	local world = hGlobal.WORLD.LastWorldMap
	local mapInfo = world.data.tdMapInfo
	
	--当前时间
	local currenttime = world:gametime()
	
	--如果游戏暂停，直接跳出循环
	if world.data.IsPaused==1 then
		return
	end

	if world.data.map == hVar.LoginMap then
		return
	end
	
	local oPlayerMe = world:GetPlayerMe() --我的玩家对象
	local nForceMe = oPlayerMe:getforce() --我的势力
	local oNeutralPlayer = world:GetForce(nForceMe) --中立阵营玩家对象（蜀国/魏国）
	
	--遍历所有单位，绘制头顶血条
	world:enumunit(function(eu)
		local dx = -17
		local dy = 65
		
		--local tabU = hVar.tab_unit[eu.data.id]
		
		--配置单位不显示血条
		if (eu.attr.hideHpBar == 1) then
			return
		end
		
		local euOwner = eu:getowner() --角色的玩家对象
		local euForce = euOwner and euOwner:getforce() --角色的玩家对象
		local subType = eu.data.type --角色子类型
		--local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
		--local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox()
		
		local eu_x, eu_y = hApi.chaGetPos(eu.handle)
		local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --单位的包围盒
		--local eu_center_y = (eu_by / 2 + eu_bh / 2) + eu_bh --单位的中心点y位置
		local eu_center_y = (-eu_by) + 15--单位的中心点y位置
		
		--大菠萝，不显示我的战车血条和名字
		--我方英雄的血条
		if (subType == hVar.UNIT_TYPE.HERO) and (euOwner == oPlayerMe) then --英雄单位、本方控制的
			if (hVar.OPTIONS.SHOW_TANK_HP_FLAG == 1) and (eu.data.id == hVar.MY_TANK_ID) then
				--添加血条
				if (not eu.chaUI["hpBar"]) then
					--eu.data.block = 0
					--我方英雄血条
					local px = dx - 20
					local py = eu_center_y + 26
					local pw = 80
					local bolderX = -2
					local bolderW = 84
					local bolderH = 12
					eu.chaUI["hpBar"] = hUI.valbar:new({
						parent = eu.handle._n,
						--x = dx,
						--y = dy,
						x = px,
						y = py,
						w = pw,
						h = 8,
						align = "LC",
						back = {model = "UI:BAR_ValueBar_BG_NEW",x = bolderX, y = -0, w = bolderW, h = bolderH},
						model = "UI:IMG_ValueBar_NEW",
						animation = "green",
						v = eu.attr.hp,
						max = eu:GetHpMax(),
					})
					eu.chaUI["hpBar"].childUI["img"] = hUI.image:new({ --英雄显示名字的子控件
						parent = eu.chaUI["hpBar"].handle._n,
						x = 26, --英雄略大
						y = 17, --英雄略大
						w = 80, --英雄略大
						h = 20, --英雄略大
						model = "UI:SoulStoneBarBg1",
						align = "MC",
					})
					eu.chaUI["hpBar"].childUI["img"].handle.s:setOpacity(0)
					
					--显示我方英雄名文本
					eu.chaUI["label"] = hUI.label:new({
						parent = eu.handle._n,
						x = dx + 15, --英雄略大
						y = eu_center_y + 18, --英雄略大
						w = 300, --英雄略大
						font = hVar.FONTC,
						size = 18,
						align = "MC",
						text = eu.data.name,
						border = 1,
					})
					eu.chaUI["label"].handle.s:setColor(ccc3(0, 255, 0))
					
					if (eu:GetYinShenState() == 1) then --隐身的单位不显示血条
						eu.chaUI["hpBar"].handle._n:setVisible(false)
					end
					
					--仓库隐藏血条
					if (world.data.map == hVar.MainBase) then
						eu.chaUI["hpBar"].handle._n:setVisible(false)
					end
				end
			end
			if (hVar.OPTIONS.SHOW_TANK_HP_FLAG == 0) and (eu.data.id == hVar.MY_TANK_ID) then
				if (eu.chaUI["hpBar"]) then
					hApi.safeRemoveT(eu.chaUI, "hpBar")
				end
			end
			
			--我方英雄显示血量值的文字
			if (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 1) then --数字显血模式
				if (not eu.chaUI["numberBar"]) then
					eu.chaUI["numberBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = "numGreen",
						text = eu.attr.hp .. "/" .. eu:GetHpMax(),
						size = 10,
						align = "MC",
						--x = dx + 15,
						--y = dy + 8,
						x = dx + 15,
						y = eu_bh + 3 + 12, --英雄略大
					})
				end
			elseif (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 0) then --不数字显血模式
				if eu.chaUI["numberBar"] then
					hApi.safeRemoveT(eu.chaUI, "numberBar")
				end
			end
			
			--我方英雄显示当前锁定的单位
			if (hVar.OPTIONS.SHOW_AI_UI_FLAG == 1) then
				if (not eu.chaUI["lockBar"]) then
					eu.chaUI["lockBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = hVar.DEFAULT_FONT, --默认字体
						text = "",
						size = 14,
						align = "MC",
						--x = dx + 15,
						--y = dy + 28,
						x = dx + 15,
						y = eu_bh + 3 + 40, --英雄略大
						--border = 0, --不显示边框
					})
					eu.chaUI["lockBar"].handle.s:setColor(ccc3(0, 255, 0))
				end
			elseif (hVar.OPTIONS.SHOW_AI_UI_FLAG == 0) then --不数字AI文字模式
				if eu.chaUI["lockBar"] then
					hApi.safeRemoveT(eu.chaUI, "lockBar")
				end
			end
		end
		
		--我方小兵的血条
		if ((subType == hVar.UNIT_TYPE.UNIT) or (subType == hVar.UNIT_TYPE.NPC_TALK)) and (euOwner == oPlayerMe) then --普通单位、本方控制的
			--添加血条
			if (not eu.chaUI["hpBar"]) then
				--eu.data.block = 0
				--我方小兵血条
				local px = dx - 15
				local py = eu_center_y + 17
				local pw = 60
				local bolderX = -2
				local bolderW = 64
				local bolderH = 10
				eu.chaUI["hpBar"] = hUI.valbar:new({
					parent = eu.handle._n,
					--x = dx,
					--y = dy,
					x = px,
					y = py,
					w = pw,
					h = 7,
					align = "LC",
					back = {model = "UI:BAR_ValueBar_BG",x = bolderX, w = bolderW, h = bolderH},
					model = "UI:IMG_ValueBar",
					animation = "blue",
					v = eu.attr.hp,
					max = eu:GetHpMax(),
				})
				if (eu:GetYinShenState() == 1) then --隐身的单位不显示血条
					eu.chaUI["hpBar"].handle._n:setVisible(false)
				end
				
				--geyachao: 优化效率，存储是否显示
				eu.chaUI["hpBar"].data.visible = 1 --geyachao: 优化效率，存储是否显示
			end
			
			--[[
			--满血，不显示血条
			if (eu.attr.hp == eu:GetHpMax()) then --满血，不显示血条
				--不重复隐藏
				if (eu.chaUI["hpBar"].data.visible == 1) then
					eu.chaUI["hpBar"].data.visible = 0
					eu.chaUI["hpBar"].handle._n:setVisible(false)
					--print("满血，不显示血条")
				end
			else --不满血，显示血条
				--不重复显示
				if (eu.chaUI["hpBar"].data.visible == 0) then
					eu.chaUI["hpBar"].data.visible = 1
					eu.chaUI["hpBar"].handle._n:setVisible(true)
					--print("不满血，显示血条")
				end
			end
			]]
			
			--[[
			--我方小兵生存时间
			if (not eu.chaUI["liveTime"]) then
				eu.chaUI["liveTime"] = hUI.valbar:new({
					parent = eu.handle._n,
					--x = dx,
					--y = dy - 6,
					x = dx,
					y = eu_center_y - 5,
					w = 34,
					h = 2,
					align = "LC",
					--back = {model = "UI:BAR_ValueBar_BG",x = -1},
					model = "UI:IMG_ValueBar",
					animation = "blue",
					v = eu.attr.hp,
					max = eu:GetHpMax(),
					show = 1,
				})
				eu.chaUI["liveTime"].handle._n:setVisible(false)
			end
			]]
			
			--我方小兵显示血量值的文字
			if (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 1) then --数字显血模式
				if (not eu.chaUI["numberBar"]) then
					eu.chaUI["numberBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = "numGreen",
						text = eu.attr.hp .. "/" .. eu:GetHpMax(),
						size = 10,
						align = "MC",
						--x = dx + 15,
						--y = dy + 8,
						x = dx + 15,
						y = eu_bh + 3 + 8,
					})
				end
			elseif (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 0) then --不数字显血模式
				if eu.chaUI["numberBar"] then
					hApi.safeRemoveT(eu.chaUI, "numberBar")
				end
			end
			
			--我方小兵显示当前锁定的单位
			if (hVar.OPTIONS.SHOW_AI_UI_FLAG == 1) then
				if (not eu.chaUI["lockBar"]) then
					eu.chaUI["lockBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = hVar.DEFAULT_FONT, --默认字体
						text = "",
						size = 14,
						align = "MC",
						--x = dx + 15,
						--y = dy + 28,
						x = dx + 15,
						y = eu_bh + 3 + 28,
						--border = 0, --不显示边框
					})
					eu.chaUI["lockBar"].handle.s:setColor(ccc3(0, 255, 0))
				end
			elseif (hVar.OPTIONS.SHOW_AI_UI_FLAG == 0) then --不数字AI文字模式
				if eu.chaUI["lockBar"] then
					hApi.safeRemoveT(eu.chaUI, "lockBar")
				end
			end
			
			--优化：我方英雄，满血，不显示血条
			if (eu.attr.hp == eu:GetHpMax()) then --满血，不显示血条
				--不重复隐藏
				if (eu.chaUI["hpBar"].data.visible == 1) then
					eu.chaUI["hpBar"].data.visible = 0
					eu.chaUI["hpBar"].handle._n:setVisible(false)
					--print("满血，不显示血条")
				end
			else --不满血，显示血条
				--不重复显示
				if (eu.chaUI["hpBar"].data.visible == 0) then
					eu.chaUI["hpBar"].data.visible = 1
					eu.chaUI["hpBar"].handle._n:setVisible(true)
					--print("不满血，显示血条")
				end
			end
		end
		
		--我方小兵替换物（图腾）血条
		if (subType == hVar.UNIT_TYPE.HERO_TOKEN) and (euOwner == oPlayerMe) then --普通类型、本方控制的
			--print("eu.data.name:".. tostring(eu.data.name).. ", IsTower:".. tostring(isTower))
			--[[
			--我方小兵替换物（图腾）生存时间
			if (not eu.chaUI["liveTime"]) then
				--eu.data.block = 0
				--友方小兵替换物生存时间
				eu.chaUI["liveTime"] = hUI.valbar:new({
					parent = eu.handle._n,
					--x = dx,
					--y = dy - 6,
					x = dx,
					y = eu_center_y - 5,
					w = 34,
					h = 4,
					align = "LC",
					--back = {model = "UI:BAR_ValueBar_BG",x = -1},
					model = "UI:IMG_ValueBar",
					animation = "blue",
					v = eu.attr.hp,
					max = eu:GetHpMax(),
					show = 1,
				})
				eu.chaUI["liveTime"].handle._n:setVisible(false)
			end
			]]
			
			--友方小兵替换物显示当前锁定的单位
			if (hVar.OPTIONS.SHOW_AI_UI_FLAG == 1) then
				if (not eu.chaUI["lockBar"]) then
					eu.chaUI["lockBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = hVar.DEFAULT_FONT, --默认字体
						text = "",
						size = 14,
						align = "MC",
						--x = dx + 15,
						--y = dy + 28,
						x = dx + 15,
						y = eu_bh + 3 + 28,
						--border = 0, --不显示边框
					})
					eu.chaUI["lockBar"].handle.s:setColor(ccc3(0, 255, 0))
				end
			elseif (hVar.OPTIONS.SHOW_AI_UI_FLAG == 0) then --不数字AI文字模式
				if eu.chaUI["lockBar"] then
					hApi.safeRemoveT(eu.chaUI, "lockBar")
				end
			end
		end
		
		--[[
		--大菠萝，不显示战车血条
		--中立英雄的血条
		if (subType == hVar.UNIT_TYPE.HERO) and ((euOwner == oNeutralPlayer) or (euForce == nForceMe)) then --英雄单位、中立的
			local bIsBoss = (hVar.tab_unit[eu.data.id].tag and hVar.tab_unit[eu.data.id].tag[hVar.UNIT_TAG_TYPE.OTHER.TAG_BOSS])
			--添加血条
			if (not eu.chaUI["hpBar"]) then
				--eu.data.block = 0
				if bIsBoss then --BOSS血条
					--eu.data.block = 0
					--如果是BOSS
					eu.chaUI["hpBar"] = hUI.valbar:new({
						parent = eu.handle._n,
						--x = dx,
						--y = dy,
						x = dx - 27, --BOSS更大
						y = eu_center_y + 10, --BOSS更大（敌人再加一点）
						w = 86, --BOSS更大
						h = 8, --BOSS更大
						align = "LC",
						back = {model = "UI:BAR_ValueBarBoss_BG", x = -15, y = 0 ,w = 116, h = 22}, --BOSS更大
						model = "UI:IMG_ValueBarBoss",
						animation = "yellow",
						v = eu.attr.hp,
						max = eu:GetHpMax(),
					})
					--显示中立英雄名文本
					eu.chaUI["label"] = hUI.label:new({
						parent = eu.handle._n,
						x = dx + 15, --英雄略大
						y = eu_center_y + 28, --英雄略大
						w = 300, --英雄略大
						font = hVar.FONTC,
						size = 18,
						align = "MC",
						text = eu.data.name,
						border = 1,
					})
					eu.chaUI["label"].handle.s:setColor(ccc3(255, 255, 0))
				else --普通血条
					--中立英雄血条
					eu.chaUI["hpBar"] = hUI.valbar:new({
						parent = eu.handle._n,
						--x = dx,
						--y = dy,
						x = dx - 12, --英雄略大
						y = eu_center_y, --英雄略大
						w = 56, --英雄略大
						h = 5, --英雄略大
						align = "LC",
						back = {model = "UI:BAR_ValueBar_BG", x = -3, y = 0 ,w = 62, h = 10}, --英雄略大
						model = "UI:IMG_ValueBar",
						animation = "yellow",
						v = eu.attr.hp,
						max = eu:GetHpMax(),
					})
					
					--显示中立英雄名文本
					eu.chaUI["label"] = hUI.label:new({
						parent = eu.handle._n,
						x = dx + 15, --英雄略大
						y = eu_center_y + 18, --英雄略大
						w = 300, --英雄略大
						font = hVar.FONTC,
						size = 18,
						align = "MC",
						text = eu.data.name,
						border = 1,
					})
					eu.chaUI["label"].handle.s:setColor(ccc3(255, 255, 0))
				end
				
				if (eu:GetYinShenState() == 1) then --隐身的单位不显示血条
					eu.chaUI["hpBar"].handle._n:setVisible(false)
				end
			end
			
			--中立英雄显示血量值的文字
			if (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 1) then --数字显血模式
				if (not eu.chaUI["numberBar"]) then
					eu.chaUI["numberBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = "numWhite", --中立为白色
						text = eu.attr.hp .. "/" .. eu:GetHpMax(),
						size = 10,
						align = "MC",
						--x = dx + 15,
						--y = dy + 8,
						x = dx + 15,
						y = eu_bh + 3 + 12, --英雄略大
					})
				end
			elseif (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 0) then --不数字显血模式
				if eu.chaUI["numberBar"] then
					hApi.safeRemoveT(eu.chaUI, "numberBar")
				end
			end
			
			--中立英雄显示当前锁定的单位
			if (hVar.OPTIONS.SHOW_AI_UI_FLAG == 1) then
				if (not eu.chaUI["lockBar"]) then
					eu.chaUI["lockBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = hVar.DEFAULT_FONT, --默认字体
						text = "",
						size = 14,
						align = "MC",
						--x = dx + 15,
						--y = dy + 28,
						x = dx + 15,
						y = eu_bh + 3 + 40, --英雄略大
						--border = 0, --不显示边框
					})
					eu.chaUI["lockBar"].handle.s:setColor(ccc3(255, 255, 255))
				end
			elseif (hVar.OPTIONS.SHOW_AI_UI_FLAG == 0) then --不数字AI文字模式
				if eu.chaUI["lockBar"] then
					hApi.safeRemoveT(eu.chaUI, "lockBar")
				end
			end
		end
		]]
		
		--中立小兵血条
		--if (subType == hVar.UNIT_TYPE.UNIT) and (eu:getowner() == hGlobal.NeutralPlayer) then --普通类型、非箭塔、中立阵营
		if ((subType == hVar.UNIT_TYPE.UNIT) or (subType == hVar.UNIT_TYPE.NPC_TALK)) and ((euOwner == oNeutralPlayer) or (euForce == nForceMe)) then --普通类型、非箭塔、中立阵营
			--print("eu.data.name:".. tostring(eu.data.name).. ", IsTower:".. tostring(isTower))
			--添加血条
			if (not eu.chaUI["hpBar"]) then
				--eu.data.block = 0
				--中立小兵血条
				local px = dx - 15
				local py = eu_center_y + 17
				local pw = 60
				local bolderX = -2
				local bolderW = 64
				local bolderH = 10
				eu.chaUI["hpBar"] = hUI.valbar:new({
					parent = eu.handle._n,
					--x = dx,
					--y = dy,
					x = px,
					y = py,
					w = pw,
					h = 7,
					align = "LC",
					back = {model = "UI:BAR_ValueBar_BG",x = bolderX, w = bolderW, h = bolderH},
					model = "UI:IMG_ValueBar",
					animation = "yellow",
					v = eu.attr.hp,
					max = eu:GetHpMax(),
				})
				if (eu:GetYinShenState() == 1) then --隐身的单位不显示血条
					eu.chaUI["hpBar"].handle._n:setVisible(false)
				end
				
				--仓库隐藏血条
				if (world.data.map == hVar.MainBase) then
					eu.chaUI["hpBar"].handle._n:setVisible(false)
				end
				
				--geyachao: 优化效率，存储是否显示
				eu.chaUI["hpBar"].data.visible = 1 --geyachao: 优化效率，存储是否显示
			end
			
			--[[
			--满血，不显示血条
			if (eu.attr.hp == eu:GetHpMax()) then --满血，不显示血条
				--不重复隐藏
				if (eu.chaUI["hpBar"].data.visible == 1) then
					eu.chaUI["hpBar"].data.visible = 0
					eu.chaUI["hpBar"].handle._n:setVisible(false)
					--print("满血，不显示血条")
				end
			else --不满血，显示血条
				--不重复显示
				if (eu.chaUI["hpBar"].data.visible == 0) then
					eu.chaUI["hpBar"].data.visible = 1
					eu.chaUI["hpBar"].handle._n:setVisible(true)
					--print("不满血，显示血条")
				end
			end
			]]
			
			--[[
			--中立英雄、中立小兵生存时间
			if (not eu.chaUI["liveTime"]) then
				eu.chaUI["liveTime"] = hUI.valbar:new({
					parent = eu.handle._n,
					--x = dx,
					--y = dy - 6,
					x = dx,
					y = eu_center_y - 5,
					w = 34,
					h = 2,
					align = "LC",
					--back = {model = "UI:BAR_ValueBar_BG",x = -1},
					model = "UI:IMG_ValueBar",
					animation = "blue",
					v = eu.attr.hp,
					max = eu:GetHpMax(),
					show = 1,
				})
				eu.chaUI["liveTime"].handle._n:setVisible(false)
			end
			]]
			
			--中立英雄、中立小兵文字血条
			if (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 1) then --数字显血模式
				if (not eu.chaUI["numberBar"]) then
					eu.chaUI["numberBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = "numWhite", --中立为白色
						text = eu.attr.hp .. "/" .. eu:GetHpMax(),
						size = 10,
						align = "MC",
						--x = dx + 15,
						--y = dy + 8,
						x = dx + 15,
						y = eu_bh + 3 + 8,
					})
				end
			elseif (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 0) then --不数字显血模式
				if eu.chaUI["numberBar"] then
					hApi.safeRemoveT(eu.chaUI, "numberBar")
				end
			end
			
			--中立英雄、中立小兵显示当前锁定的单位
			if (hVar.OPTIONS.SHOW_AI_UI_FLAG == 1) then
				if (not eu.chaUI["lockBar"]) then
					eu.chaUI["lockBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = hVar.DEFAULT_FONT, --默认字体
						text = "",
						size = 14,
						align = "MC",
						--x = dx + 15,
						--y = dy + 28,
						x = dx + 15,
						y = eu_bh + 3 + 28,
						--border = 0, --不显示边框
					})
					eu.chaUI["lockBar"].handle.s:setColor(ccc3(255, 255, 255))
				end
			elseif (hVar.OPTIONS.SHOW_AI_UI_FLAG == 0) then --不数字AI文字模式
				if eu.chaUI["lockBar"] then
					hApi.safeRemoveT(eu.chaUI, "lockBar")
				end
			end
		end
		
		--敌方英雄的血条
		if (subType == hVar.UNIT_TYPE.HERO) and ((euOwner ~= oPlayerMe) and (euOwner ~= oNeutralPlayer) and (euForce ~= nForceMe)) then --英雄单位、敌方阵营
			--是否为boss
			local bIsBoss = eu.attr.tag[hVar.UNIT_TAG_TYPE.OTHER.TAG_BOSS]
			
			--是否为金钱怪
			local bIsGoldUnit = eu.attr.tag[hVar.UNIT_TAG_TYPE.OTHER.TAG_GOLDUNIT]
			
			--添加血条
			if (not eu.chaUI["hpBar"]) then
				if bIsBoss then --BOSS血条
					--eu.data.block = 0
					--如果是BOSS
					--eu.chaUI["hpBar"] = hUI.valbar:new({
						--parent = eu.handle._n,
						----x = dx,
						----y = dy,
						--x = dx - 27, --BOSS更大
						--y = eu_center_y + 10, --BOSS更大（敌人再加一点）
						--w = 86, --BOSS更大
						--h = 8, --BOSS更大
						--align = "LC",
						--back = {model = "UI:BAR_ValueBarBoss_BG", x = -15, y = 0 ,w = 116, h = 22}, --BOSS更大
						--model = "UI:IMG_ValueBarBoss",
						--animation = "red",
						--v = eu.attr.hp,
						--max = eu:GetHpMax(),
					--})
					local posx = hVar.SCREEN.w/2 - 215
					local posy = hVar.SCREEN.h - 100
					local w,h = -1,-1
					local barw,barh = -1,-1
					local barx = - 41
					if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
						w = 360
						h = 100
						barw = 360 + 72
						barh = -1
						barx = - 37
						posx = hVar.SCREEN.vw/2 - w/2
						posy = hVar.SCREEN.h - 160
						
					end
					eu.chaUI["hpBar"] = hUI.valbar:new({
						x = posx,
						y = posy,
						w = w, --BOSS更大
						h = h, --BOSS更大
						align = "LC",
						back = {model = "misc/hpbar/hpbar_back.png", x = barx, y = 0 ,w = barw, h = barh}, --BOSS更大
						model = "UI:hpbar_red",
						--animation = "red",
						v = eu.attr.hp,
						max = eu:GetHpMax(),
					})
				elseif bIsGoldUnit then --金钱怪血条
					--eu.data.block = 0
					--如果是金钱怪
					eu.chaUI["hpBar"] = hUI.valbar:new({
						parent = eu.handle._n,
						--x = dx,
						--y = dy,
						x = dx - 20, --BOSS更大
						y = eu_center_y + 10, --BOSS更大（敌人再加一点）
						w = 71, --BOSS更大
						h = 8, --BOSS更大
						align = "LC",
						back = {model = "UI:BAR_ValueBarBoss_BG", x = -13, y = 0 ,w = 96, h = 22}, --BOSS更大
						model = "UI:IMG_ValueBarBoss",
						animation = "yellow",
						v = eu.attr.hp,
						max = eu:GetHpMax(),
					})
				else --普通血条
					--敌方英雄血条
					eu.chaUI["hpBar"] = hUI.valbar:new({
						parent = eu.handle._n,
						--x = dx,
						--y = dy,
						x = dx - 12, --英雄略大
						y = eu_center_y, --英雄略大（敌人再加一点）
						w = 56, --英雄略大
						h = 6, --英雄略大
						align = "LC",
						back = {model = "UI:BAR_ValueBar_BG", x = -3, y = 0 ,w = 62, h = 10}, --英雄略大
						model = "UI:IMG_ValueBar",
						animation = "red",
						v = eu.attr.hp,
						max = eu:GetHpMax(),
					})
				end
				
				--geyachao: 优化效率，存储是否显示
				eu.chaUI["hpBar"].data.visible = 1 --geyachao: 优化效率，存储是否显示
				
				--[[
				eu.chaUI["hpBar"].childUI["img"] = hUI.image:new({ --英雄显示名字的子控件
					parent = eu.chaUI["hpBar"].handle._n,
					x = 26, --英雄略大
					y = 17, --英雄略大
					w = 80, --英雄略大
					h = 20, --英雄略大
					model = "UI:SoulStoneBarBg1",
					align = "MC",
				})
				eu.chaUI["hpBar"].childUI["img"].handle.s:setOpacity(0)
				]]
				
				--[[
				--geychao: 大菠萝不显示敌方英雄血条
				--显示敌方英雄名文本
				local showText = eu.data.name
				if hVar.tab_unit[eu.data.id].tag and hVar.tab_unit[eu.data.id].tag[hVar.UNIT_TAG_TYPE.OTHER.TAG_BOSS] then
					--showText = "BOSS-" .. showText
					showText = showText
				end
				local newY = eu_center_y + 18
				if bIsBoss or bIsGoldUnit then
					newY = eu_center_y + 32
				end
				eu.chaUI["label"] = hUI.label:new({
					parent = eu.handle._n,
					x = dx + 15, --英雄略大
					y = newY, --英雄略大（敌人再加一点）
					w = 300, --英雄略大
					font = hVar.FONTC,
					size = 18,
					align = "MC",
					text = showText,
					border = 1,
				})
				eu.chaUI["label"].handle.s:setColor(ccc3(255, 0, 0))
				
				if (eu:GetYinShenState() == 1) then --隐身的单位不显示血条
					eu.chaUI["hpBar"].handle._n:setVisible(false)
				end
				
				--敌方英雄pvp等级文字
				if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
					if (not bIsGoldUnit) then --不是金钱怪
						--pvp单位的等级背景图
						eu.chaUI["pvp_circle_unit"] = hUI.image:new({
							parent = eu.handle._n,
							model = "ui/pvp/pvpselect.png",
							x = dx + 15 - 63, --英雄略大
							y = newY - 22 + 1, --英雄略大（敌人再加一点）
							w = 26,
							h = 26,
						})
						
						--pvp单位的等级
						eu.chaUI["pvp_label_unit"] = hUI.label:new({
							parent = eu.handle._n,
							x = dx + 15 - 63, --英雄略大
							y = newY - 22, --英雄略大（敌人再加一点）
							w = 300, --英雄略大
							font = "numWhite",
							size = 18,
							align = "MC",
							--text = eu.attr.pvp_lv .. "级", --language
							text = eu.attr.pvp_lv, --language
							border = 1,
						})
						eu.chaUI["pvp_label_unit"].handle.s:setColor(ccc3(255, 0, 0))
					end
				end
				]]
				
				--显示BOSS的标识
				--是boss
				if eu.attr.tag[hVar.UNIT_TAG_TYPE.OTHER.TAG_BOSS] then
					local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox()
					--[[
					eu.chaUI["BossImage"] = hUI.image:new({
						parent = eu.handle._n,
						model = "UI:ach_lightning",
						z = 100,
						--w = 22,
						--h = 22,
						scale = 0.6,
						x = dx - 45, --英雄略大
						y = eu_bh + 41, --英雄略大
					})
					eu.chaUI["BossImage"].handle.s:setColor(ccc3(255, 0, 0))
					]]
					
					--[[
					--显示BOSS的标识文字
					eu.chaUI["BossLabel"] = hUI.label:new({
						parent = eu.handle._n,
						x = dx + 15, --英雄略大
						y = eu_bh + 66, --英雄略大
						z = 101,
						w = 300, --英雄略大
						font = hVar.FONTC,
						size = 18,
						align = "MC",
						text = " BOSS ",
						border = 1,
					})
					eu.chaUI["BossLabel"].handle.s:setColor(ccc3(255, 0, 0))
					]]
				end
			end
			
			--[[
			--敌方英雄生存时间
			if (not eu.chaUI["liveTime"]) then
				eu.chaUI["liveTime"] = hUI.valbar:new({
					parent = eu.handle._n,
					--x = dx,
					--y = dy - 6,
					x = dx - 12, --英雄略大
					y = eu_center_y - 5, --（敌人再加一点）
					w = 56, --英雄略大
					h = 3,
					align = "LC",
					--back = {model = "UI:BAR_ValueBar_BG",x = -1},
					model = "UI:IMG_ValueBar",
					animation = "blue",
					v = eu.attr.hp,
					max = eu:GetHpMax(),
					show = 1,
				})
				eu.chaUI["liveTime"].handle._n:setVisible(false)
			end
			]]
			
			--敌方英雄显示血量值的文字
			if (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 1) then --数字显血模式
				if (not eu.chaUI["numberBar"]) then
					eu.chaUI["numberBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = "numRed",
						text = eu.attr.hp .. "/" .. eu:GetHpMax(),
						size = 10,
						align = "MC",
						--x = dx + 15,
						--y = dy + 8,
						x = dx + 15,
						y = eu_bh + 3 + 12 + 20, --英雄略大（敌人再加一点）
					})
				end
			elseif (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 0) then --不数字显血模式
				if eu.chaUI["numberBar"] then
					hApi.safeRemoveT(eu.chaUI, "numberBar")
				end
			end
			
			--敌方英雄显示当前锁定的单位
			if (hVar.OPTIONS.SHOW_AI_UI_FLAG == 1) then
				if (not eu.chaUI["lockBar"]) then
					eu.chaUI["lockBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = hVar.DEFAULT_FONT, --默认字体
						text = "",
						size = 14,
						align = "MC",
						--x = dx + 15,
						--y = dy + 28,
						x = dx + 15,
						y = eu_bh + 3 + 40 + 20, --英雄略大（敌人再加一点）
						--border = 0, --不显示边框
					})
					eu.chaUI["lockBar"].handle.s:setColor(ccc3(255, 192, 192))
				end
			elseif (hVar.OPTIONS.SHOW_AI_UI_FLAG == 0) then --不数字AI文字模式
				if eu.chaUI["lockBar"] then
					hApi.safeRemoveT(eu.chaUI, "lockBar")
				end
			end
			
			--优化：敌方英雄，满血，不显示血条
			if (eu.attr.hp == eu:GetHpMax()) then --满血，不显示血条
				--不重复隐藏
				if (eu.chaUI["hpBar"].data.visible == 1 and bIsBoss == false) then
					eu.chaUI["hpBar"].data.visible = 0
					eu.chaUI["hpBar"].handle._n:setVisible(false)
					--print("满血，不显示血条")
				end
			else --不满血，显示血条
				--不重复显示
				if (eu.chaUI["hpBar"].data.visible == 0) then
					eu.chaUI["hpBar"].data.visible = 1
					eu.chaUI["hpBar"].handle._n:setVisible(true)
					--print("不满血，显示血条")
				end
			end
		end
		
		--敌方小兵血条
		if ((subType == hVar.UNIT_TYPE.UNIT) or (subType == hVar.UNIT_TYPE.NPC_TALK) or (subType == hVar.UNIT_TYPE.UNITBROKEN)
		or (subType == hVar.UNIT_TYPE.UNITCAN) or (subType == hVar.UNIT_TYPE.UNITBROKEN_HOUSE) or (subType == hVar.UNIT_TYPE.UNITDOOR)) and ((euOwner ~= oPlayerMe) and (euOwner ~= oNeutralPlayer) and (euForce ~= nForceMe)) then --普通类型、敌方阵营
			--print("eu.data.name:".. tostring(eu.data.name).. ", IsTower:".. tostring(isTower))
			--添加血条
			if (not eu.chaUI["hpBar"]) then
				--敌方小兵血条
				local px = dx - 15
				local py = eu_center_y + 17
				local pw = 60
				local bolderX = -2
				local bolderW = 64
				local bolderH = 10
				
				--特殊单位的血条
				--飞机第2关障碍物
				if (eu.data.id == 5209) then
					px = dx - 58
					py = eu_center_y + 70
					pw = 144
					bolderX = -3
					bolderW = 150
					bolderH = 12
				end
				
				eu.chaUI["hpBar"] = hUI.valbar:new({
					parent = eu.handle._n,
					--x = dx,
					--y = dy,
					x = px,
					y = py,
					w = pw,
					h = 7,
					align = "LC",
					back = {model = "UI:BAR_ValueBar_BG",x = bolderX, w = bolderW, h = bolderH},
					model = "UI:IMG_ValueBar",
					animation = "red",
					v = eu.attr.hp,
					max = eu:GetHpMax(),
				})
				if (eu:GetYinShenState() == 1) then --隐身的单位不显示血条
					eu.chaUI["hpBar"].handle._n:setVisible(false)
				end
				
				--geyachao: 优化效率，存储是否显示
				eu.chaUI["hpBar"].data.visible = 1 --geyachao: 优化效率，存储是否显示
				
				--飞机第2关障碍物，显示倒计时
				if (eu.data.id == 5209) then
					--立即显示血条
					eu.chaUI["hpBar"].data.visible = 0
					eu.chaUI["hpBar"].handle._n:setVisible(true)
					
					--倒计时图标
					eu.chaUI["hpBar_cd"] = hUI.image:new({
						parent = eu.handle._n,
						model = "misc/tactics/tac02.png",
						x = px + 44,
						y = py + 32,
						w = 46,
						h = 46,
					})
					
					--倒计时进度
					eu.chaUI["hpBar_cdvalue"] = hUI.label:new({
						parent = eu.handle._n,
						x = px + 44 + 52,
						y = py + 32 - 2,
						width = 300,
						align = "MC",
						fnot = hVar.FONTC,
						size = 32,
						border = 1,
						text = "100",
					})
				end
				
				--[[
				--满血，不显示血条
				if (not bIsGoldUnit) then --非金钱怪血条
					if (eu.attr.hp == eu:GetHpMax()) then --满血，不显示血条
						--不重复隐藏
						if (eu.chaUI["hpBar"].data.visible == 1) then
							eu.chaUI["hpBar"].data.visible = 0
							eu.chaUI["hpBar"].handle._n:setVisible(false)
							--print("满血，不显示血条")
						end
					else --不满血，显示血条
						--不重复显示
						if (eu.chaUI["hpBar"].data.visible == 0) then
							eu.chaUI["hpBar"].data.visible = 1
							eu.chaUI["hpBar"].handle._n:setVisible(true)
							--print("不满血，显示血条")
						end
					end
				end
				]]
			end
			
			--[[
			--敌方小兵生存时间
			if (not eu.chaUI["liveTime"]) then
				eu.chaUI["liveTime"] = hUI.valbar:new({
					parent = eu.handle._n,
					--x = dx,
					--y = dy - 6,
					x = dx,
					y = eu_center_y - 5,
					w = 34,
					h = 2,
					align = "LC",
					--back = {model = "UI:BAR_ValueBar_BG",x = -1},
					model = "UI:IMG_ValueBar",
					animation = "blue",
					v = eu.attr.hp,
					max = eu:GetHpMax(),
					show = 1,
				})
				eu.chaUI["liveTime"].handle._n:setVisible(false)
			end
			]]
			
			--敌方小兵文字血条
			if (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 1) then --数字显血模式
				if (not eu.chaUI["numberBar"]) then
					eu.chaUI["numberBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = "numRed", --红色
						text = eu.attr.hp .. "/" .. eu:GetHpMax(),
						size = 10,
						align = "MC",
						--x = dx + 15,
						--y = dy + 8,
						x = dx + 15,
						y = eu_bh + 3 + 8,
					})
				end
			elseif (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 0) then --不数字显血模式
				if eu.chaUI["numberBar"] then
					hApi.safeRemoveT(eu.chaUI, "numberBar")
				end
			end
			
			--敌方小兵显示当前锁定的单位
			if (hVar.OPTIONS.SHOW_AI_UI_FLAG == 1) then
				if (not eu.chaUI["lockBar"]) then
					eu.chaUI["lockBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = hVar.DEFAULT_FONT, --默认字体
						text = "",
						size = 14,
						align = "MC",
						--x = dx + 15,
						--y = dy + 28,
						x = dx + 15,
						y = eu_bh + 3 + 28,
						--border = 0, --不显示边框
					})
					eu.chaUI["lockBar"].handle.s:setColor(ccc3(255, 192, 192))
				end
			elseif (hVar.OPTIONS.SHOW_AI_UI_FLAG == 0) then --不数字AI文字模式
				if eu.chaUI["lockBar"] then
					hApi.safeRemoveT(eu.chaUI, "lockBar")
				end
			end
			
			--优化：敌方小兵，满血，不显示血条
			if (eu.attr.hp == eu:GetHpMax()) then --满血，不显示血条
				--不重复隐藏
				if (eu.chaUI["hpBar"].data.visible == 1) then
					eu.chaUI["hpBar"].data.visible = 0
					eu.chaUI["hpBar"].handle._n:setVisible(false)
					--print("满血，不显示血条")
				end
			elseif (eu.attr.suffer_touming_stack > 0) then --敌人透明状态，不显示血条
				--不重复隐藏
				if (eu.chaUI["hpBar"].data.visible == 1) then
					eu.chaUI["hpBar"].data.visible = 0
					eu.chaUI["hpBar"].handle._n:setVisible(false)
					--print("透明，不显示血条")
				end
			else --不满血，显示血条
				--不重复显示
				if (eu.chaUI["hpBar"].data.visible == 0) then
					eu.chaUI["hpBar"].data.visible = 1
					eu.chaUI["hpBar"].handle._n:setVisible(true)
					--print("不满血，显示血条")
				end
			end
		end
		
		--敌方小兵替换物（图腾）血条
		if (subType == hVar.UNIT_TYPE.HERO_TOKEN) and ((euOwner ~= oPlayerMe) and (euOwner ~= oNeutralPlayer) and (euForce ~= nForceMe)) then --图腾类型、敌方控制的
			--print("eu.data.name:".. tostring(eu.data.name).. ", IsTower:".. tostring(isTower))
			--[[
			--我方小兵替换物（图腾）生存时间
			if (not eu.chaUI["liveTime"]) then
				--eu.data.block = 0
				--友方小兵替换物生存时间
				eu.chaUI["liveTime"] = hUI.valbar:new({
					parent = eu.handle._n,
					--x = dx,
					--y = dy - 6,
					x = dx,
					y = eu_center_y - 5,
					w = 34,
					h = 4,
					align = "LC",
					--back = {model = "UI:BAR_ValueBar_BG",x = -1},
					model = "UI:IMG_ValueBar",
					animation = "blue",
					v = eu.attr.hp,
					max = eu:GetHpMax(),
					show = 1,
				})
				eu.chaUI["liveTime"].handle._n:setVisible(false)
			end
			]]
			
			--友方小兵替换物显示当前锁定的单位
			if (hVar.OPTIONS.SHOW_AI_UI_FLAG == 1) then
				if (not eu.chaUI["lockBar"]) then
					eu.chaUI["lockBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = hVar.DEFAULT_FONT, --默认字体
						text = "",
						size = 14,
						align = "MC",
						--x = dx + 15,
						--y = dy + 28,
						x = dx + 15,
						y = eu_bh + 3 + 28,
						--border = 0, --不显示边框
					})
					eu.chaUI["lockBar"].handle.s:setColor(ccc3(255, 0, 0))
				end
			elseif (hVar.OPTIONS.SHOW_AI_UI_FLAG == 0) then --不数字AI文字模式
				if eu.chaUI["lockBar"] then
					hApi.safeRemoveT(eu.chaUI, "lockBar")
				end
			end
			
			
		end
		
		--所有塔的血条（我方的塔、中立的塔、敌方的塔）
		if (subType == hVar.UNIT_TYPE.TOWER) then --是塔
			--所有塔显示血量值的文字
			if (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 1) then --数字显血模式
				if (not eu.chaUI["numberBar"]) then
					eu.chaUI["numberBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = "numWhite", --统一为白色
						text = eu.attr.hp .. "/" .. eu:GetHpMax(),
						size = 10,
						align = "MC",
						--x = dx + 15,
						--y = dy + 8,
						x = dx + 15,
						y = eu_bh + 3 + 12, --英雄略大
					})
				end
			elseif (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 0) then --不数字显血模式
				if eu.chaUI["numberBar"] then
					hApi.safeRemoveT(eu.chaUI, "numberBar")
				end
			end
			
			--所有塔显示当前锁定的单位
			if (hVar.OPTIONS.SHOW_AI_UI_FLAG == 1) then
				if (not eu.chaUI["lockBar"]) then
					eu.chaUI["lockBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = hVar.DEFAULT_FONT, --默认字体
						text = "",
						size = 14,
						align = "MC",
						x = dx + 15,
						y = dy + 28,
						--border = 0, --不显示边框
					})
					if (euOwner ~= oPlayerMe) and (euOwner ~= oNeutralPlayer) then
						eu.chaUI["lockBar"].handle.s:setColor(ccc3(255, 0, 0)) --敌方塔显示红色文字
					else
						eu.chaUI["lockBar"].handle.s:setColor(ccc3(255, 255, 0)) --非敌方塔显示黄色文字
					end
				end
			elseif (hVar.OPTIONS.SHOW_AI_UI_FLAG == 0) then --不数字AI文字模式
				if eu.chaUI["lockBar"] then
					hApi.safeRemoveT(eu.chaUI, "lockBar")
				end
			end
			
			--显示td塔的血条
			--如果是TD塔
			--if (eu:getowner():getforce() == world:GetPlayerMe():getforce()) then
			if (eu.data.id ~= 69996) and (eu.data.id ~= 69997) and (eu.data.id ~= 11007) and (eu.data.id ~= 14393) then --荒废的塔基、塔基、超级塔基不显示血条
				--local mapInfo = world.data.tdMapInfo
				--if (mapInfo) and (mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then --无尽模式
				--td塔的血条
				if (not eu.chaUI["hpBar"]) then
					--绘制塔的血条
					local colorAnum = nil
					if (euOwner == oPlayerMe) then --我方阵营
						colorAnum = "green"
					elseif (euOwner == oNeutralPlayer) or (nForceMe == euForce) then --中立阵营、友军其它玩家
						colorAnum = "yellow"
					else --敌方阵营
						colorAnum = "red"
					end
					eu.chaUI["hpBar"] = hUI.valbar:new({
						parent = eu.handle._n,
						--x = dx,
						--y = dy,
						x = dx - 12, --英雄略大
						y = eu_center_y, --英雄略大
						w = 56, --英雄略大
						h = 5, --英雄略大
						align = "LC",
						back = {model = "UI:BAR_ValueBar_BG", x = -3, y = 0 ,w = 62, h = 10}, --英雄略大
						model = "UI:IMG_ValueBar",
						animation = colorAnum, --"green",
						v = eu.attr.hp,
						max = eu:GetHpMax(),
					})
					eu.chaUI["hpBar"].data.visible = 1 --geyachao: 优化效率，存储是否显示
				end
				
				--[[
				--geyachao: 大菠萝，一直显示塔血条
				if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) and (mapInfo.pveHeroMode ~= 1) then --PVP模式，pvp英雄
					--pvp模式，一直显示血条
					--...
				elseif (mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then --无尽模式
					--无尽模式，一直显示血条
					--...
				else
					--满血，不显示血条
					if (eu.attr.hp == eu:GetHpMax()) then --满血，不显示血条
						--不重复隐藏
						if (eu.chaUI["hpBar"].data.visible == 1) then
							eu.chaUI["hpBar"].data.visible = 0
							eu.chaUI["hpBar"].handle._n:setVisible(false)
							--print("满血，不显示血条")
						end
					else --不满血，显示血条
						--不重复显示
						if (eu.chaUI["hpBar"].data.visible == 0) then
							eu.chaUI["hpBar"].data.visible = 1
							eu.chaUI["hpBar"].handle._n:setVisible(true)
							--print("不满血，显示血条")
						end
					end
				end
				]]
				--优化：所有塔，满血，不显示血条
				if (eu.attr.hp == eu:GetHpMax()) then --满血，不显示血条
					--不重复隐藏
					if (eu.chaUI["hpBar"].data.visible == 1) then
						eu.chaUI["hpBar"].data.visible = 0
						eu.chaUI["hpBar"].handle._n:setVisible(false)
						--print("满血，不显示血条")
					end
				else --不满血，显示血条
					--不重复显示
					if (eu.chaUI["hpBar"].data.visible == 0) then
						eu.chaUI["hpBar"].data.visible = 1
						eu.chaUI["hpBar"].handle._n:setVisible(true)
						--print("不满血，显示血条")
					end
				end
			end
		end
		
		--我方建筑的血条
		if (subType == hVar.UNIT_TYPE.BUILDING) and (euOwner == oPlayerMe) then --是建筑、我方阵营
			--print("eu.data.name:".. tostring(eu.data.name).. ", IsTower:".. tostring(isTower))
			--添加血条
			if (not eu.chaUI["hpBar"]) then
				--eu.data.block = 0
				--我方建筑血条
				local px = dx - 15
				local py = eu_center_y + 17 - 5
				local pw = 60
				local bolderX = -2
				local bolderW = 64
				local bolderH = 10
				eu.chaUI["hpBar"] = hUI.valbar:new({
					parent = eu.handle._n,
					--x = dx,
					--y = dy,
					x = px,
					y = py,
					w = pw,
					h = 7,
					align = "LC",
					back = {model = "UI:BAR_ValueBar_BG",x = bolderX, w = bolderW, h = bolderH},
					model = "UI:IMG_ValueBar",
					animation = "blue",
					v = eu.attr.hp,
					max = eu:GetHpMax(),
				})
				if (eu:GetYinShenState() == 1) then --隐身的单位不显示血条
					eu.chaUI["hpBar"].handle._n:setVisible(false)
				end
			end
			
			--[[
			--我方建筑生存时间
			if (not eu.chaUI["liveTime"]) then
				eu.chaUI["liveTime"] = hUI.valbar:new({
					parent = eu.handle._n,
					--x = dx,
					--y = dy - 6,
					x = dx,
					y = eu_center_y - 5,
					w = 34,
					h = 2,
					align = "LC",
					--back = {model = "UI:BAR_ValueBar_BG",x = -1},
					model = "UI:IMG_ValueBar",
					animation = "blue",
					v = eu.attr.hp,
					max = eu:GetHpMax(),
					show = 1,
				})
				eu.chaUI["liveTime"].handle._n:setVisible(false)
			end
			]]
			
			--我方建筑文字血条
			if (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 1) then --数字显血模式
				if (not eu.chaUI["numberBar"]) then
					eu.chaUI["numberBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = "numGreen", --我方为绿色
						text = eu.attr.hp .. "/" .. eu:GetHpMax(),
						size = 10,
						align = "MC",
						--x = dx + 15,
						--y = dy + 8,
						x = dx + 15,
						y = eu_bh + 3 + 8,
					})
				end
			elseif (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 0) then --不数字显血模式
				if eu.chaUI["numberBar"] then
					hApi.safeRemoveT(eu.chaUI, "numberBar")
				end
			end
			
			--我方建筑显示当前锁定的单位
			if (hVar.OPTIONS.SHOW_AI_UI_FLAG == 1) then
				if (not eu.chaUI["lockBar"]) then
					eu.chaUI["lockBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = hVar.DEFAULT_FONT, --默认字体
						text = "",
						size = 14,
						align = "MC",
						--x = dx + 15,
						--y = dy + 28,
						x = dx + 15,
						y = eu_bh + 3 + 28,
						--border = 0, --不显示边框
					})
					eu.chaUI["lockBar"].handle.s:setColor(ccc3(0, 255, 0))
				end
			elseif (hVar.OPTIONS.SHOW_AI_UI_FLAG == 0) then --不数字AI文字模式
				if eu.chaUI["lockBar"] then
					hApi.safeRemoveT(eu.chaUI, "lockBar")
				end
			end
		end
		
		--中立建筑的血条
		if (subType == hVar.UNIT_TYPE.BUILDING) and ((euOwner == oNeutralPlayer) or (nForceMe == euForce)) then --是建筑、中立阵营、友军其它玩家阵营
			--print("eu.data.name:".. tostring(eu.data.name).. ", IsTower:".. tostring(isTower))
			--添加血条
			if (not eu.chaUI["hpBar"]) then
				--eu.data.block = 0
				--中立建筑血条
				local px = dx - 15
				local py = eu_center_y + 17 - 5
				local pw = 60
				local bolderX = -2
				local bolderW = 64
				local bolderH = 10
				if (eu.data.id == 17000) or (eu.data.id == 17200) then --塔防图主城/-塔防图主城2
					px = dx - 15-64 - 10
					py = eu_center_y + 17 - 5 + 22
					pw = 60+64*2
					bolderX = -3
					bolderW = 64+64*2+2
					bolderH = 12
				end
				eu.chaUI["hpBar"] = hUI.valbar:new({
					parent = eu.handle._n,
					--x = dx,
					--y = dy,
					x = px,
					y = py,
					w = pw,
					h = bolderH-3,
					align = "LC",
					back = {model = "UI:BAR_ValueBar_BG",x = bolderX, w = bolderW, h = bolderH},
					model = "UI:IMG_ValueBar",
					animation = "yellow",
					v = eu.attr.hp,
					max = eu:GetHpMax(),
				})
				if (eu:GetYinShenState() == 1) then --隐身的单位不显示血条
					eu.chaUI["hpBar"].handle._n:setVisible(false)
				end
			end
			
			--[[
			--中立建筑生存时间
			if (not eu.chaUI["liveTime"]) then
				eu.chaUI["liveTime"] = hUI.valbar:new({
					parent = eu.handle._n,
					--x = dx,
					--y = dy - 6,
					x = dx,
					y = eu_center_y - 5,
					w = 34,
					h = 2,
					align = "LC",
					--back = {model = "UI:BAR_ValueBar_BG",x = -1},
					model = "UI:IMG_ValueBar",
					animation = "blue",
					v = eu.attr.hp,
					max = eu:GetHpMax(),
					show = 1,
				})
				eu.chaUI["liveTime"].handle._n:setVisible(false)
			end
			]]
			
			--中立建筑文字血条
			if (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 1) then --数字显血模式
				if (not eu.chaUI["numberBar"]) then
					eu.chaUI["numberBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = "numWhite", --中立为白色
						text = eu.attr.hp .. "/" .. eu:GetHpMax(),
						size = 10,
						align = "MC",
						--x = dx + 15,
						--y = dy + 8,
						x = dx + 15,
						y = eu_bh + 3 + 8,
					})
				end
			elseif (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 0) then --不数字显血模式
				if eu.chaUI["numberBar"] then
					hApi.safeRemoveT(eu.chaUI, "numberBar")
				end
			end
			
			--中立建筑显示当前锁定的单位
			if (hVar.OPTIONS.SHOW_AI_UI_FLAG == 1) then
				if (not eu.chaUI["lockBar"]) then
					eu.chaUI["lockBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = hVar.DEFAULT_FONT, --默认字体
						text = "",
						size = 14,
						align = "MC",
						--x = dx + 15,
						--y = dy + 28,
						x = dx + 15,
						y = eu_bh + 3 + 28,
						--border = 0, --不显示边框
					})
					eu.chaUI["lockBar"].handle.s:setColor(ccc3(255, 255, 255))
				end
			elseif (hVar.OPTIONS.SHOW_AI_UI_FLAG == 0) then --不数字AI文字模式
				if eu.chaUI["lockBar"] then
					hApi.safeRemoveT(eu.chaUI, "lockBar")
				end
			end
			
			--添加中立建筑文字
			if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
				if (eu.data.id == 11005) or (eu.data.id == 11000) then
					local showText = ""
					if (not eu.chaUI["label"]) then
						eu.chaUI["label"] = hUI.label:new({
							parent = eu.handle._n,
							x = dx + 25, --英雄略大
							y = 70 - 1, --英雄略大（敌人再加一点）
							w = 300, --英雄略大
							font = hVar.FONTC,
							size = 22,
							align = "MC",
							text = showText,
							border = 1,
						})
						eu.chaUI["label"].handle.s:setColor(ccc3(0, 255, 0))
					end
					
					local player = eu:getowner()
					if player then
						local playerName = player.data.name
						eu.chaUI["label"]:setText(showText .. "" .. playerName .. "")
					end
				end
			end
		end
		
		--敌方建筑的血条
		if (subType == hVar.UNIT_TYPE.BUILDING) and ((euOwner ~= oPlayerMe) and (euOwner ~= oNeutralPlayer) and (nForceMe ~= euForce)) then --是建筑、敌方阵营
			--print("eu.data.name:".. tostring(eu.data.name).. ", IsTower:".. tostring(isTower))
			--添加血条
			if (not eu.chaUI["hpBar"]) then
				--eu.data.block = 0
				--敌方建筑血条
				local px = dx - 15
				local py = eu_center_y + 17 - 5
				local pw = 60
				local bolderX = -2
				local bolderW = 64
				local bolderH = 10
				eu.chaUI["hpBar"] = hUI.valbar:new({
					parent = eu.handle._n,
					--x = dx,
					--y = dy,
					x = px,
					y = py,
					w = pw,
					h = 7,
					align = "LC",
					back = {model = "UI:BAR_ValueBar_BG",x = bolderX, w = bolderW, h = bolderH},
					model = "UI:IMG_ValueBar",
					animation = "red",
					v = eu.attr.hp,
					max = eu:GetHpMax(),
				})
				if (eu:GetYinShenState() == 1) then --隐身的单位不显示血条
					eu.chaUI["hpBar"].handle._n:setVisible(false)
				end
				
				--geyachao: 优化效率，存储是否显示
				eu.chaUI["hpBar"].data.visible = 1 --geyachao: 优化效率，存储是否显示
			end
			
			--添加敌方建筑文字
			if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
				if (eu.data.id == 11005) or (eu.data.id == 11000) then
					local showText = ""
					if (not eu.chaUI["label"]) then
						eu.chaUI["label"] = hUI.label:new({
							parent = eu.handle._n,
							x = dx + 25, --英雄略大
							y = 70 - 1, --英雄略大（敌人再加一点）
							w = 300, --英雄略大
							font = hVar.FONTC,
							size = 22,
							align = "MC",
							text = showText,
							border = 1,
						})
						eu.chaUI["label"].handle.s:setColor(ccc3(255, 0, 0))
					end
					
					local player = eu:getowner()
					if player then
						local playerName = player.data.name
						eu.chaUI["label"]:setText(showText .. "" .. playerName .. "")
						
						--[[
						local playerType = player:gettype()
						if (playerType == 2) then --2:简单电脑
							--eu.chaUI["label"]:setText(showText .. " [" .. "简单电脑" .. "]") --language
							eu.chaUI["label"]:setText(showText .. "" .. hVar.tab_string["__TEXT_PVP_VS_Computer1"] .. "") --language
						elseif (playerType == 3) then --3:中等电脑
							--eu.chaUI["label"]:setText(showText .. " [" .. "中等电脑" .. "]") --language
							eu.chaUI["label"]:setText(showText .. "" .. hVar.tab_string["__TEXT_PVP_VS_Computer2"] .. "") --language
						elseif (playerType == 4) then --4:困难电脑
							--eu.chaUI["label"]:setText(showText .. " [" .. "困难电脑" .. "]") --language
							eu.chaUI["label"]:setText(showText .. "" .. hVar.tab_string["__TEXT_PVP_VS_Computer3"] .. "") --language
						elseif (playerType == 5) then --5:大师电脑
							--eu.chaUI["label"]:setText(showText .. " [" .. "大师电脑" .. "]") --language
							eu.chaUI["label"]:setText(showText .. "" .. hVar.tab_string["__TEXT_PVP_VS_Computer3"] .. "") --language
						elseif (playerType == 6) then --6:专家电脑
							--eu.chaUI["label"]:setText(showText .. " [" .. "专家电脑" .. "]") --language
							eu.chaUI["label"]:setText(showText .. "" .. hVar.tab_string["__TEXT_PVP_VS_Computer3"] .. "") --language
						end
						]]
					end
				end
			end
			
			--[[
			--敌方建筑生存时间
			if (not eu.chaUI["liveTime"]) then
				eu.chaUI["liveTime"] = hUI.valbar:new({
					parent = eu.handle._n,
					--x = dx,
					--y = dy - 6,
					x = dx,
					y = eu_center_y - 5,
					w = 34,
					h = 2,
					align = "LC",
					--back = {model = "UI:BAR_ValueBar_BG",x = -1},
					model = "UI:IMG_ValueBar",
					animation = "blue",
					v = eu.attr.hp,
					max = eu:GetHpMax(),
					show = 1,
				})
				eu.chaUI["liveTime"].handle._n:setVisible(false)
			end
			]]
			
			--敌方建筑文字血条
			if (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 1) then --数字显血模式
				if (not eu.chaUI["numberBar"]) then
					eu.chaUI["numberBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = "numRed", --敌人为红色
						text = eu.attr.hp .. "/" .. eu:GetHpMax(),
						size = 10,
						align = "MC",
						--x = dx + 15,
						--y = dy + 8,
						x = dx + 15,
						y = eu_bh + 3 + 8,
					})
				end
			elseif (hVar.OPTIONS.SHOW_HP_BAR_FLAG == 0) then --不数字显血模式
				if eu.chaUI["numberBar"] then
					hApi.safeRemoveT(eu.chaUI, "numberBar")
				end
			end
			
			--敌方建筑显示当前锁定的单位
			if (hVar.OPTIONS.SHOW_AI_UI_FLAG == 1) then
				if (not eu.chaUI["lockBar"]) then
					eu.chaUI["lockBar"] = hUI.label:new({
						parent = eu.handle._n,
						font = hVar.DEFAULT_FONT, --默认字体
						text = "",
						size = 14,
						align = "MC",
						--x = dx + 15,
						--y = dy + 28,
						x = dx + 15,
						y = eu_bh + 3 + 28,
						--border = 0, --不显示边框
					})
					eu.chaUI["lockBar"].handle.s:setColor(ccc3(255, 0, 0))
				end
			elseif (hVar.OPTIONS.SHOW_AI_UI_FLAG == 0) then --不数字AI文字模式
				if eu.chaUI["lockBar"] then
					hApi.safeRemoveT(eu.chaUI, "lockBar")
				end
			end
			
			--优化：敌方建筑，满血，不显示血条
			if (eu.attr.hp == eu:GetHpMax()) then --满血，不显示血条
				--不重复隐藏
				if (eu.chaUI["hpBar"].data.visible == 1) then
					eu.chaUI["hpBar"].data.visible = 0
					eu.chaUI["hpBar"].handle._n:setVisible(false)
					--print("满血，不显示血条")
				end
			else --不满血，显示血条
				--不重复显示
				if (eu.chaUI["hpBar"].data.visible == 0) then
					eu.chaUI["hpBar"].data.visible = 1
					eu.chaUI["hpBar"].handle._n:setVisible(true)
					--print("不满血，显示血条")
				end
			end
		end
		
		--所有道具的名字
		if (subType == hVar.UNIT_TYPE.ITEM) or (subType == hVar.UNIT_TYPE.RESOURCE) then --道具单位
			--添加名字
			if (not eu.chaUI["label"]) then
				--显示道具名文本
				local itemId = hVar.tab_unit[eu.data.id].itemId
				eu.chaUI["label"] = hUI.label:new({
					parent = eu.handle._n,
					x = dx + 15,
					y = eu_center_y - 15,
					w = 300, --英雄略大
					font = hVar.FONTC,
					size = 18,
					align = "MC",
					text = hVar.tab_stringI[itemId] and hVar.tab_stringI[itemId][1],
					border = 1,
				})
				eu.chaUI["label"].handle.s:setColor(ccc3(255, 255, 0))
			end
		end
		
		--显示塔、可交互NPC的升级提示
		if (subType == hVar.UNIT_TYPE.TOWER) or (subType == hVar.UNIT_TYPE.NPC_TALK) then
			if (g_editor ~= 1) then --编辑器模式下不处理
				if (eu.data.id ~= 69996) and (eu.data.id ~= 69997) and (eu.data.id ~= 11007) then --荒废的塔基、塔基不提示升级
					--刷新塔是否可以升级
					--如果是TD塔，我方控制的、本势力阵营控制的
					if (euOwner == oPlayerMe) or (euOwner == oNeutralPlayer) then
						if (not eu.chaUI["skillUpTip"]) then
							--local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox()
							if (eu.data.id == 69996) then --废弃的塔基
								eu.chaUI["skillUpTip"] = hUI.button:new({
									parent = eu.handle._n,
									model = "UI:TaskTanHao",
									x = eu_bw * 0.5 - 8,
									y = -eu_bh * 0.5 + 32,
									z = 100,
									scale = 0.5,
								})
								local act1 = CCMoveBy:create(0.2, ccp(0, 6))
								local act2 = CCMoveBy:create(0.2, ccp(0, -6))
								local act3 = CCMoveBy:create(0.2, ccp(0, 6))
								local act4 = CCMoveBy:create(0.2, ccp(0, -6))
								local act5 = CCDelayTime:create(0.6)
								local act6 = CCRotateBy:create(0.1, 10)
								local act7 = CCRotateBy:create(0.1 * 1, -10 * 2)
								local act8 = CCRotateBy:create(0.1 * 1, 10 * 2)
								local act9 = CCRotateBy:create(0.1, -10)
								local act10 = CCDelayTime:create(0.8)
								local a = CCArray:create()
								a:addObject(act1)
								a:addObject(act2)
								a:addObject(act3)
								a:addObject(act4)
								a:addObject(act5)
								a:addObject(act6)
								a:addObject(act7)
								a:addObject(act8)
								a:addObject(act9)
								a:addObject(act10)
								local sequence = CCSequence:create(a)
								eu.chaUI["skillUpTip"].handle.s:runAction(CCRepeatForever:create(sequence))
							else --其他单位
								local hintScale = 0.5
								local hintDx = 0
								local hintDy = 0
								local edId = eu.data.id
								if (edId == 14393) then --超级塔基
									hintScale = 0.8
									hintDx = 0
									hintDy = -70
								elseif (edId == 14384) or (edId == 14385) or (edId == 14386) --超级单塔
									or (edId == 14387) or (edId == 14388) or (edId == 14389)
									or (edId == 14390) or (edId == 14391) or (edId == 14392) then
									hintScale = 0.8
									hintDx = 15
									hintDy = -25
								end
								
								eu.chaUI["skillUpTip"] = hUI.button:new({
									parent = eu.handle._n,
									model = "ICON:image_update",
									x = eu_bw * 0.5 - 8 + hintDx,
									y = -eu_bh * 0.5 + 32 + hintDy,
									z = 100,
									scale = hintScale,
								})
							end
						end
						
						--zhenkira 优化时注意：以下部分可以转移至频率较低的定时器中
						local isShow = false
						local mapInfo = world.data.tdMapInfo
						if mapInfo then
							local td_upgrade = eu.td_upgrade --zhenkira 2015.9.25 修改为角色身上的属性,并且使用kv形式存储表结构
							if td_upgrade and type(td_upgrade) == "table" then
								local remould = td_upgrade.remould
								local upgradeSkill = td_upgrade.upgradeSkill
								local goldnow = 0
								local owner = eu:getowner()
								local me = world:GetPlayerMe()
								if owner and me then
									--如果塔是自己的或者是奔放势力的，才显示箭头
									if owner == world:GetForce(me:getforce()) or owner == me then
										goldnow = me:getresource(hVar.RESOURCE_TYPE.GOLD)
									end
								end
								if remould then
									for buildId, buildInfo in pairs(remould) do
										if buildId ~= "order" then
											--如果没有解锁则不创建按钮
											if buildInfo.isUnlock then
												--local cost = (buildInfo.cost or 0) + (buildInfo.costAdd or 0)
												--if mapInfo.gold >= cost then
												--	isShow = true
												--	break
												--end
												local cost = (buildInfo.cost or 0) + (buildInfo.costAdd or 0)
												if goldnow >= cost then
													isShow = true
												end
											end
											
											local unlockCondition = buildInfo.unlockCondition
											--print("opr:",opr, unlockCondition)
											if unlockCondition then
												local tacticId = unlockCondition[1]
												local buildNum = unlockCondition[2]
												local buildIdList = unlockCondition[3] or {}
												--取当前造了多少个指定的塔
												local buildNumNow = hApi.GetBuildTowerNum(world, eu:getowner():getpos(), buildIdList)
												
												--print("buildNumNow:",tacticId,buildNum,buildIdList[1],buildNumNow)
												
												if (buildNumNow < buildNum) then
													isShow = false
												end
											end
											
											if isShow then
												break
											end
										end
									end
									
								elseif upgradeSkill then
									
									local createFlag = false
									--检测是否所有技能已经升满级，升满级不创建
									for skillId, skillInfo in pairs(upgradeSkill) do
										if skillId ~= "order" then
											--如果没有解锁则不创建按钮
											if skillInfo.isUnlock then
												--local maxSkillLv = skillInfo.maxLv or 1
												local maxSkillLv = hApi.GetTowerSkillMaxLv(world,eu:getowner(),skillInfo)
												local skillLv = 0
												local skillObj = eu:getskill(skillId)
												if skillObj then
													skillLv = skillObj[2] or 0
												end
												if skillLv < maxSkillLv then
													--资金消耗需要加上战术技能卡的修改值
													local cost = 0
													if not skillInfo.costAdd or type(skillInfo.costAdd) ~= "table" then
														skillInfo.costAdd = {}
													end
													for i = 1, #skillInfo.cost do
														if i == skillLv + 1 then
															cost = (skillInfo.cost[i] or 0) + (skillInfo.costAdd[i] or 0)
														end
													end
													
													--if mapInfo.gold >= cost then
													--	isShow = true
													--	break
													--end
													if goldnow >= cost then
														isShow = true
														break
													end
												end
											end
										end
									end
								end
							end
						end
						
						if isShow then
							eu.chaUI["skillUpTip"]:setstate(1)
						else
							eu.chaUI["skillUpTip"]:setstate(-1)
						end
					end
				end
			end
		end
	end)
end

--我方小兵自动普通攻击 loop
--[[
function ally_unit_AI_loop()
	local world = hGlobal.WORLD.LastWorldMap
	
	--如果游戏暂停，直接跳出循环
	if (world.data.IsPaused == 1) then
		return
	end
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end

	--游戏暂停或结束，直接退出
	if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
		return
	end
	
	--当前时间
	local currenttime = world:gametime()
	
	--依次遍历
	world:enumunit(function(oUnit)
		local subType = oUnit.data.type --角色子类型
		local isTower = hVar.tab_unit[oUnit.data.id].isTower or 0 --是否为塔
		
		if ((subType == hVar.UNIT_TYPE.UNIT) or (subType == hVar.UNIT_TYPE.HERO_TOKEN))and (oUnit:getowner() == hGlobal.LocalPlayer) then --我方的普通单位、替换单位
			--检测自动攻击的部分
			local attack = oUnit.attr.attack --我方小兵攻击表
			local attackRange = oUnit:GetAtkRange() --我方小兵攻击范围
			
			--我方小兵是否在技能释放中
			local currenttime = world:gametime() --当前时间
			local pastskilltime = currenttime - oUnit.data.castskillLastTime --经过的时间
			if (pastskilltime >= oUnit.data.castskillStaticTime) then --过了技能僵直时间
				--检测我方小兵是否可以攻击（过了CD）
				local lasttime = oUnit.attr.lastAttackTime --上次攻击的时间
				local deltatime = currenttime - lasttime --距离上次攻击间隔的时间
				local atk_interval = oUnit:GetAtkInterval() --攻击间隔
				
				--过了攻击间隔、我方小兵有攻击力、不在移动中
				if (deltatime >= atk_interval) and (attack[5] > 0) and (oUnit.handle.UnitInMove ~= 1) then
					local lockTarget = oUnit.data.lockTarget --锁定攻击的目标
					
					--取我方小兵的中心位置
					local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --我方小兵的坐标
					local hero_bx, hero_by, hero_bw, hero_bh = oUnit:getbox() --我方小兵的包围盒
					local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --我方小兵的中心点x位置
					local hero_center_y = hero_y + (hero_by + hero_bh / 2) --我方小兵的中心点y位置
					--local hero_extra_radius = math.sqrt(hero_bw / 2 * hero_bw / 2 + hero_bh / 2 * hero_bh / 2) --我方小兵额外的攻击距离
					
					--local node = oUnit.handle._n
					--local ox, oy = hApi.chaGetPos(oUnit.handle) --角色的位置
					--local ox, oy = node:getPosition() --特效的位置
					--oy = -oy --屏幕坐标系。。。
					
					--print("锁定的目标=" .. (lockTarget and lockTarget.data.name or tostring(lockTarget)))
					--寻在锁定的目标、活着的目标
					if (lockTarget ~= 0) and (lockTarget.data.IsDead ~= 1) then
						--检测目标是否在攻击范围内
						--取目标的中心点位置
						local enemy_x, enemy_y = hApi.chaGetPos(lockTarget.handle)
						local enemy_bx, enemy_by, enemy_bw, enemy_bh = lockTarget:getbox() --小兵的包围盒
						local enemy_center_x = enemy_x + (enemy_bx + enemy_bw / 2) --小兵的中心点x位置
						local enemy_center_y = enemy_y + (enemy_by + enemy_bh / 2) --小兵的中心点y位置
						
						--实际判定在攻击范围的距离
						--原先锁定的目标在攻击范围内
						--判断矩形和圆是否相交
						if hApi.CircleIntersectRect(hero_center_x, hero_center_y, attackRange, enemy_center_x, enemy_center_y, enemy_bw, enemy_bh) then --在射程内
							--我方小兵发起普通攻击
							atttack(oUnit, lockTarget)
							--print("lockTarget.data.IsDead=" .. lockTarget.data.IsDead , "lockTarget.attr.hp=" .. lockTarget.attr.hp)
							
							--标记新的攻击时间点
							oUnit.attr.lastAttackTime = currenttime
						else
							--我方小兵移动到达目标点(英雄计算障碍)
							hApi.UnitMoveToTarget_TD(oUnit, lockTarget, attackRange - hVar.MOVE_EXTRA_DISTANCE, true) --24距离的缓冲
						end
					else --我方小兵未锁定目标、或者目标已死亡
						local skill_id = attack[1] --普通攻击id
						local search_radius = oUnit:GetAtkSearchRange() --我方小兵的搜敌半径
						
						--搜敌
						local world = hGlobal.WORLD.LastWorldMap
						local nearestUnit = 0 --最近的目标
						local nearestAttackDistance = math.huge --最近的实际判定在攻击范围的距离
						world:enumunit(function(eu)
							local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
							if (eu.data.type == hVar.UNIT_TYPE.UNIT) and (isTower ~= 1) and (eu:getowner() ~= hGlobal.LocalPlayer) then --普通单位类型、非塔、非己方
								if (eu.data.IsDead ~= 1) then --活着的目标
									--取小兵的中心点位置
									local eu_x, eu_y = hApi.chaGetPos(eu.handle)
									local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --小兵的包围盒
									local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --小兵的中心点x位置
									local eu_center_y = eu_y + (eu_by + eu_bh / 2) --小兵的中心点y位置
									--local eu_extra_radius = math.sqrt(eu_bw / 2 * eu_bw / 2 + eu_bh / 2 *eu_bh / 2) --小兵额外的攻击距离
									--local hero_extra_radius = math.sqrt(hero_bw / 2 * hero_bw / 2 + hero_bh / 2 * hero_bh / 2) --英雄额外的攻击距离
									
									--小兵和我方小兵的距离
									local dx = hero_center_x - eu_center_x
									local dy = hero_center_y - eu_center_y
									local eu_distance = math.sqrt(dx * dx + dy * dy) --搜敌的目标的距离
									
									--实际判定在攻击范围的距离
									--在自动搜敌范围内
									--判断矩形和圆是否相交
									if hApi.CircleIntersectRect(hero_center_x, hero_center_y, search_radius, eu_center_x, eu_center_y, eu_bw, eu_bh) then --在射程内
										--找到更新的目标
										if (eu_distance < nearestAttackDistance) then
											--标记新的目标
											nearestUnit = eu
											nearestAttackDistance = eu_distance
										end
									end
								end
							end
						end)
						
						--取消原锁定的小兵，对英雄的锁定
						local old_lockTarget = oUnit.data.lockTarget
						if (old_lockTarget ~= 0) then
							if (old_lockTarget.data.lockTarget == oUnit) then --如果原小兵锁定别人了，那么不处理
								old_lockTarget.data.lockTarget = 0
								old_lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
								--print("lockType 44", old_lockTarget.data.name, 0)
							end
						end
						
						--标记我方小兵锁定新目标
						oUnit.data.lockTarget = nearestUnit
						oUnit.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
						--print("lockType 43", oUnit.data.name, 0)
						
						--标记新目标也锁定我方小兵
						if (nearestUnit ~= 0) then --存在目标
							if (nearestUnit.data.lockTarget == 0) then --不重复锁定不同的目标
								--我方小兵需要在新小兵的射程内，新目标才能锁定我方小兵
								--在小兵射程内
								--取小兵的中心点位置
								local unit_x, unit_y = hApi.chaGetPos(nearestUnit.handle)
								local unit_bx, unit_by, unit_bw, unit_bh = nearestUnit:getbox() --小兵的包围盒
								local unit_center_x = unit_x + (unit_bx + unit_bw / 2) --小兵的中心点x位置
								local unit_center_y = unit_y + (unit_by + unit_bh / 2) --小兵的中心点y位置
								--print("标记新目标也锁定我方小兵", subType, hVar.UNIT_TYPE.HERO_TOKEN)
								--实际判定在攻击范围的距离
								--判断矩形和圆是否相交
								--我方小兵在最近的目标的射程内，才会锁定我方小兵
								if hApi.CircleIntersectRect(unit_center_x, unit_center_y, nearestUnit:GetAtkRange(), hero_center_x, hero_center_y, hero_bw, hero_bh) then --在射程内
									if (subType ~= hVar.UNIT_TYPE.HERO_TOKEN) then --替代物单位不能被锁定
										nearestUnit.data.lockTarget = oUnit
										nearestUnit.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
										--print("lockType 42", nearestUnit.data.name, 0)
										--print("标记新目标也锁定我方小兵", subType, hVar.UNIT_TYPE.HERO_TOKEN)
									end
								end
							end
						end
						--print("搜敌的目标=" .. (nearestUnit and nearestUnit.data.name or tostring(nearestUnit)), oUnit.handle.UnitInMove)
						
						--我方小兵攻击AI
						if (nearestUnit ~= 0) then --存在目标
							--在射程内直接攻击，否则移动到达
							if (nearestAttackDistance <= attackRange) then
								--攻击
								atttack(oUnit, nearestUnit) --普通攻击
								
								--标记新的攻击时间点
								oUnit.attr.lastAttackTime = currenttime
							else
								--我方小兵移动到目标点(我方小兵计算障碍)
								hApi.UnitMoveToTarget_TD(oUnit, nearestUnit, attackRange - hVar.MOVE_EXTRA_DISTANCE, true) --24距离的缓冲
							end
						else --不存在目标
							--
						end
					end
				end
			end
		end
	end)
end
]]

--[[
--我方英雄自动普通攻击敌人AI
function TD_Hero_Aaatck_Loop()
	local world = hGlobal.WORLD.LastWorldMap
	
	--如果游戏暂停，直接跳出循环
	if (world.data.IsPaused == 1) then
		return
	end
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end

	--游戏暂停或结束，直接退出
	if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
		return
	end
	
	local heros =  hGlobal.LocalPlayer.heros
	for i = 1, #heros, 1 do
		local hero = heros[i]
		
		--存在英雄
		if hero then
			local oUnit = hero:getunit()
			
			--存在角色
			if oUnit then
				--print(oUnit.data.name, oUnit.data.IsDead, oUnit.attr.hp)
				if (oUnit.data.IsDead ~= 1) then--活着的角色
					--检测自动攻击的部分
					local attack = oUnit.attr.attack --英雄攻击表
					local attackRange = oUnit:GetAtkRange() --英雄攻击范围
					
					--英雄是否在技能释放中
					local currenttime = hApi.gametime() --当前时间
					local pastskilltime = currenttime - oUnit.data.castskillLastTime --经过的时间
					if (pastskilltime >= oUnit.data.castskillStaticTime) then --过了技能僵直时间
						--检测英雄是否可以攻击（过了CD）
						local lasttime = oUnit.attr.lastAttackTime --上次攻击的时间
						local deltatime = currenttime - lasttime --距离上次攻击间隔的时间
						local atk_interval = oUnit:GetAtkInterval() --攻击间隔
						
						--过了攻击间隔、英雄有攻击力、不在移动中
						if (deltatime >= atk_interval) and (attack[5] > 0) and (oUnit.handle.UnitInMove ~= 1) then
							local lockTarget = oUnit.data.lockTarget --锁定攻击的目标
							--print(lockTarget)
							--取英雄的中心位置
							local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --英雄的坐标
							local hero_bx, hero_by, hero_bw, hero_bh = oUnit:getbox() --英雄的包围盒
							local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --英雄的中心点x位置
							local hero_center_y = hero_y + (hero_by + hero_bh / 2) --英雄的中心点y位置
							--local hero_extra_radius = math.sqrt(hero_bw / 2 * hero_bw / 2 + hero_bh / 2 * hero_bh / 2) --英雄额外的攻击距离
							
							--local node = oUnit.handle._n
							--local ox, oy = hApi.chaGetPos(oUnit.handle) --角色的位置
							--local ox, oy = node:getPosition() --特效的位置
							--oy = -oy --屏幕坐标系。。。
							
							--print("锁定的目标=" .. (lockTarget and lockTarget.data.name or tostring(lockTarget)))
							--寻在锁定的目标、活着的目标
							if (lockTarget ~= 0) and (lockTarget.data.IsDead ~= 1) then
								--检测目标是否在攻击范围内
								--取目标的中心点位置
								local enemy_x, enemy_y = hApi.chaGetPos(lockTarget.handle)
								local enemy_bx, enemy_by, enemy_bw, enemy_bh = lockTarget:getbox() --小兵的包围盒
								local enemy_center_x = enemy_x + (enemy_bx + enemy_bw / 2) --小兵的中心点x位置
								local enemy_center_y = enemy_y + (enemy_by + enemy_bh / 2) --小兵的中心点y位置
								
								local search_radius = oUnit:GetAtkSearchRange() --英雄的搜敌半径
								
								--原先锁定的目标在攻击范围内
								--判断矩形和圆是否相交
								if hApi.CircleIntersectRect(hero_center_x, hero_center_y, attackRange, enemy_center_x, enemy_center_y, enemy_bw, enemy_bh) then --在射程内
									--英雄发起普通攻击
									atttack(oUnit, lockTarget)
									--print("lockTarget.data.IsDead=" .. lockTarget.data.IsDead , "lockTarget.attr.hp=" .. lockTarget.attr.hp)
									
									--标记新的攻击时间点
									oUnit.attr.lastAttackTime = currenttime
								elseif hApi.CircleIntersectRect(hero_center_x, hero_center_y, search_radius, enemy_center_x, enemy_center_y, enemy_bw, enemy_bh) then --在射程内
									--在英雄的搜敌范围内
									hApi.UnitMoveToTarget_TD(oUnit, lockTarget, attackRange - hVar.MOVE_EXTRA_DISTANCE, true) --24距离的缓冲
								else
									--距离太远，取消锁定
									oUnit.data.lockTarget = 0 --锁定攻击的目标
									oUnit.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
									--print("lockType 41", oUnit.data.name, 0)
									
									--检测目标是否也解除对小兵的锁定
									if (lockTarget.data.lockTarget == oUnit) then
										if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
											lockTarget.data.lockTarget = 0
											--print("lockTarget = 0 49", lockTarget.__ID)
											lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
											--print("lockType 40", lockTarget.data.name, 0)
										end
									end
								end
							else --英雄未锁定目标、或者目标已死亡
								local skill_id = attack[1] --普通攻击id
								local search_radius = oUnit:GetAtkSearchRange() --英雄的搜敌半径
								
								--搜敌
								local nearestUnit = 0 --最近的目标
								local nearestAttackDistance = math.huge --最近的实际判定在攻击范围的距离
								world:enumunit(function(eu)
									local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
									if (eu.data.type == hVar.UNIT_TYPE.UNIT) and (isTower ~= 1) and (eu:getowner() ~= hGlobal.LocalPlayer) then --普通单位类型、非塔、非己方
										if (eu.data.IsDead ~= 1) then --活着的目标
											--取小兵的中心点位置
											local eu_x, eu_y = hApi.chaGetPos(eu.handle)
											local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --小兵的包围盒
											local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --小兵的中心点x位置
											local eu_center_y = eu_y + (eu_by + eu_bh / 2) --小兵的中心点y位置
											--local eu_extra_radius = math.sqrt(eu_bw / 2 * eu_bw / 2 + eu_bh / 2 *eu_bh / 2) --小兵额外的攻击距离
											--local hero_extra_radius = math.sqrt(hero_bw / 2 * hero_bw / 2 + hero_bh / 2 * hero_bh / 2) --英雄额外的攻击距离
											
											--小兵和英雄的距离
											local dx = hero_center_x - eu_center_x
											local dy = hero_center_y - eu_center_y
											local eu_distance = math.sqrt(dx * dx + dy * dy) --搜敌的目标的距离
											
											--在自动搜敌范围内
											--判断矩形和圆是否相交
											if hApi.CircleIntersectRect(hero_center_x, hero_center_y, search_radius, eu_center_x, eu_center_y, eu_bw, eu_bh) then --在射程内
												--找到更新的目标
												if (eu_distance < nearestAttackDistance) then
													--标记新的目标
													nearestUnit = eu
													nearestAttackDistance = eu_distance
													--print("nearestAttackDistance=" .. tostring(nearestAttackDistance))
												end
											end
										end
									end
								end)
								
								--取消原锁定的小兵，对英雄的锁定
								local old_lockTarget = oUnit.data.lockTarget
								if (old_lockTarget ~= 0) then
									if (old_lockTarget.data.lockTarget == oUnit) then --如果原小兵锁定别人了，那么不处理
										old_lockTarget.data.lockTarget = 0
										--print("lockTarget = 0 48", old_lockTarget.__ID)
										old_lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
										--print("lockType 39", old_lockTarget.data.name, 0)
									end
								end
								
								--标记英雄锁定新目标
								oUnit.data.lockTarget = nearestUnit
								oUnit.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
								--print("lockType 38", oUnit.data.name, 0)
								
								--标记新目标也锁定英雄
								if (nearestUnit ~= 0) then --存在目标
									if (nearestUnit.data.lockTarget == 0) then --不重复锁定不同的目标
										nearestUnit.data.lockTarget = oUnit
										nearestUnit.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
										--print("lockType 37", nearestUnit.data.name, 0)
									end
								end
								--print("搜敌的目标=" .. (nearestUnit and nearestUnit.data.name or tostring(nearestUnit)), oUnit.handle.UnitInMove)
								
								--英雄攻击AI
								if (nearestUnit ~= 0) then --存在目标
									--在射程内直接攻击，否则移动到达
									if (nearestAttackDistance <= attackRange) then
										--攻击
										atttack(oUnit, nearestUnit) --普通攻击
										
										--标记新的攻击时间点
										oUnit.attr.lastAttackTime = currenttime
									else
										--英雄移动到目标点(英雄计算障碍)
										hApi.UnitMoveToTarget_TD(oUnit, nearestUnit, attackRange - hVar.MOVE_EXTRA_DISTANCE, true) --24距离的缓冲
									end
								else --不存在目标
									--
								end
							end
						end
					end
				end
			end
		end
	end
end
]]

--单位检测释放技能
function UnitAutoCastSkill(eu)
	--遍历大地图上的每个角色
	local world = hGlobal.WORLD.LastWorldMap
	local regionId = world.data.randommapIdx --地图当前所在小关数
	
	--当前时间
	local currenttime = world:gametime()
	
	--大菠萝效率优化
	--随机地图模式，如果当前单位不是本层的，不处理AI
	local regionIdBelong = eu.attr.regionIdBelong
	if (regionIdBelong == 0) or (regionIdBelong == regionId) then
		--单位不在眩晕(滑行)中、不在隐身中、不在混乱中、不在沉睡中、不在沉默中
		if (eu.attr.stun_stack == 0) and (eu:GetYinShenState() ~= 1) and (eu.attr.suffer_chaos_stack == 0) and (eu.attr.suffer_sleep_stack == 0) and (eu.attr.suffer_chenmo_stack == 0) then
			if (eu.data.IsDead ~= 1) then
				--print(eu.data.name)
				local skill = eu.attr.skill
				--print(eu.data.name, "skill.num=" .. skill.num)
				if (skill.num > 0) then --存在技能才会自动释放
					local pastskilltime = currenttime - eu.data.castskillLastTime --经过的时间
					if (pastskilltime >= eu.data.castskillStaticTime) then --过了技能僵直时间
						if (pastskilltime >= eu.data.castskillWaitTime) then --过了下次技能允许释放的间隔时间
							--应该释放的技能id
							local skill_id = 0
							
							--检测应该随机释放哪一个技能
							local AI_SKILL_SEQUENCE_LIST = eu.data.AI_SKILL_SEQUENCE_LIST --geyachao: 新加数据 角色在释放的技能的序列
							if (AI_SKILL_SEQUENCE_LIST ~= 0) then --上次执行了存在技能释放序列
								local AI_SKILL_SEQUENCE_INDEX = eu.data.AI_SKILL_SEQUENCE_INDEX --geyachao: 新加数据 角色在释放的技能的序列id
								
								--获得技能释放序列的技能id
								skill_id = AI_SKILL_SEQUENCE_LIST[AI_SKILL_SEQUENCE_INDEX]
								--print(eu.data.name, "释放原先的技能序列", skill_id)
								--geyachao: 非同步日志: 释放技能
								if (hVar.IS_ASYNC_LOG == 1) then
									local msg = "AutoCastSkill: eu=" .. eu.data.name .. ",u_ID=" .. eu:getworldC() .. ", 释放原先的技能序列" .. ", skill_id=" .. tostring(skill_id)
									hApi.AsyncLog(msg)
								end
								
								--序号id自增1
								AI_SKILL_SEQUENCE_INDEX = AI_SKILL_SEQUENCE_INDEX + 1
								eu.data.AI_SKILL_SEQUENCE_INDEX = AI_SKILL_SEQUENCE_INDEX
								
								--如果本次序列都已放完，那么请空序列
								if (AI_SKILL_SEQUENCE_INDEX > #AI_SKILL_SEQUENCE_LIST) then
									eu.data.AI_SKILL_SEQUENCE_LIST = 0 --geyachao: 新加数据 角色在释放的技能的序列
									eu.data.AI_SKILL_SEQUENCE_INDEX = 0 --geyachao: 新加数据 角色在释放的技能的序列id
									--print(eu.data.name,"原先的技能序列释放完毕，清空序列")
									--geyachao: 非同步日志: 释放技能
									if (hVar.IS_ASYNC_LOG == 1) then
										local msg = "AutoCastSkill: eu=" .. eu.data.name .. ",u_ID=" .. eu:getworldC() .. ", 原先的技能序列释放完毕，清空序列"
										hApi.AsyncLog(msg)
									end
								end
							else --上次没有执行技能释放序列
								local tabUnit = hVar.tab_unit[eu.data.id]
								local skill_AI_sequence = eu.attr.skill_AI_sequence --角色自定义AI技能释放规则
								--print(eu.data.name)
								if  (skill_AI_sequence ~= 0) and (#skill_AI_sequence > 0) then
									--存在角色自定义AI技能释放规则，随机一个规则，作为当前技能施放的序列
									
									--随机一个序列
									local sequence_idx = 0 --序列索引值
									local weightSum = 0 --权重之和
									for i = 1, #skill_AI_sequence, 1 do
										--[[
										--geyachao: 同步日志: 释放技能权重
										if (hVar.IS_SYNC_LOG == 1) then
											local msg = "AutoCastSkillWeight: eu=" .. eu.data.id .. ",u_ID=" .. eu:getworldC() .. ", i=" .. i .. ", weight=" .. skill_AI_sequence[i].weight
											hApi.SyncLog(msg)
										end
										]]
										
										weightSum = weightSum + skill_AI_sequence[i].weight
									end
									
									--随机数
									local randValue = world:random(1, weightSum)
									
									--geyachao: 非同步日志: 释放技能
									if (hVar.IS_ASYNC_LOG == 1) then
										local msg = "AutoCastSkill: eu=" .. eu.data.name .. ",u_ID=" .. eu:getworldC() .. ",typeId=" .. eu.data.id .. ", weightSum=" .. weightSum
										hApi.AsyncLog(msg)
									end
									
									--找出属于哪个索引值的区间
									for i = 1, #skill_AI_sequence, 1 do
										if (randValue <= skill_AI_sequence[i].weight) then
											sequence_idx = i
											break
										else
											randValue = randValue - skill_AI_sequence[i].weight
										end
									end
									
									--获得技能释放序列的第一个技能id
									skill_id = skill_AI_sequence[sequence_idx].skills[1]
									--print(eu.data.name,"释放新的技能序列", skill_id, "idx=" .. sequence_idx)
									--geyachao: 非同步日志: 释放技能
									if (hVar.IS_ASYNC_LOG == 1) then
										local msg = "AutoCastSkill: eu=" .. eu.data.name .. ",u_ID=" .. eu:getworldC() .. ", 释放新的技能序列" .. ", skill_id=" .. tostring(skill_id) .. ", sequence_idx=" .. tostring(sequence_idx)
										hApi.AsyncLog(msg)
									end
									
									--标记角色的释放技能的序列和序列id
									eu.data.AI_SKILL_SEQUENCE_LIST = skill_AI_sequence[sequence_idx].skills --geyachao: 新加数据 角色在释放的技能的序列
									eu.data.AI_SKILL_SEQUENCE_INDEX = 2 --下次放第2个技能 --geyachao: 新加数据 角色在释放的技能的序列id
									
									--如果本次序列都已放完，那么请空序列
									if (eu.data.AI_SKILL_SEQUENCE_INDEX > #eu.data.AI_SKILL_SEQUENCE_LIST) then
										eu.data.AI_SKILL_SEQUENCE_LIST = 0 --geyachao: 新加数据 角色在释放的技能的序列
										eu.data.AI_SKILL_SEQUENCE_INDEX = 0 --geyachao: 新加数据 角色在释放的技能的序列id
										--print(eu.data.name,"新的技能序列释放完毕，清空序列")
										--geyachao: 非同步日志: 释放技能
										if (hVar.IS_ASYNC_LOG == 1) then
											local msg = "AutoCastSkill: eu=" .. eu.data.name .. ",u_ID=" .. eu:getworldC() .. ", 新的技能序列释放完毕，清空序列"
											hApi.AsyncLog(msg)
										end
									end
								else
									--不存在角色自定义AI技能释放规则
									--随机一个技能索引值
									local randValue = world:random(1, skill.num)
									
									--随机的技能id
									skill_id = skill[randValue][1]
									--print(eu.data.name, "释放随机的技能ID", skill_id)
									--geyachao: 非同步日志: 释放技能
									if (hVar.IS_ASYNC_LOG == 1) then
										local msg = "AutoCastSkill: eu=" .. eu.data.name .. ",u_ID=" .. eu:getworldC() .. ", 释放随机的技能ID" .. ", skill_id=" .. tostring(skill_id)
										hApi.AsyncLog(msg)
									end
								end
							end
							
							--技能是否释放成功
							local bSkillCastSuccess = false --默认为无效
							
							--检测单位是否存在要释放的技能
							local skilllIdx = 0
							for i = 1, skill.num, 1 do
								if (skill[i][1] == skill_id) then
									skilllIdx = i
									bSkillCastSuccess = true --标记有效
									break
								end
							end
							
							--技能静态表
							local tabS = hVar.tab_skill[skill_id]
							
							--有效才能继续
							if bSkillCastSuccess then
								--检测技能是否在cd中
								local _, skill_lv, _, _, cooldown, lastskilltime, equipPos = unpack(skill[skilllIdx])
								--print(skill_id,cooldown,lastskilltime)
								--第一波前，不自动释放装备的技能
								if (equipPos > 0) then --装备技能
									local mapInfo = world.data.tdMapInfo
									if (mapInfo.wave < 1) then
										bSkillCastSuccess = false --标记无效
									end
								end
								
								--在大厅，战车不自动释放技能
								if (world.data.map == hVar.MainBase) or (world.data.map == hVar.LoginMap) then
									if (eu.data.id == hVar.MY_TANK_ID) then
										bSkillCastSuccess = false --标记无效
									end
								end
								
								if (equipPos == 0) then --geyachao: 属于装备的技能不会改变cd
									if (cooldown ~= math.huge) then --geyachao: cd不能为无限大（无限大进行数学运算，会变成无限小。。。）
										local passive_skill_cd_delta = eu:GetPassiveSkillCDDelta() --geyachao: cd附加改变值
										local passive_skill_cd_delta_rate = eu:GetPassiveSkillCDDeltaRate() --geyachao: cd附加改变比例值
										local delta = passive_skill_cd_delta + cooldown * passive_skill_cd_delta_rate / 100
										delta = math.ceil(delta) --被动改变cd精确到1毫秒
										cooldown = cooldown + delta
									end
								end
								
								local pasttime = currenttime - lastskilltime --经过的时间
								--print(skill_id,cooldown,pasttime,(pasttime < cooldown))
								if (pasttime < cooldown) then --过了cd
									bSkillCastSuccess = false --标记无效
									--print(eu.data.name, "技能未CD完毕", skill_id)
									--geyachao: 非同步日志: 释放技能
									if (hVar.IS_ASYNC_LOG == 1) then
										local msg = "AutoCastSkill: eu=" .. eu.data.name .. ",u_ID=" .. eu:getworldC() .. ", 技能未CD完毕" .. ", skill_id=" .. tostring(skill_id)
										hApi.AsyncLog(msg)
									end
								end
							else
								--print(eu.data.name, "单位不存在该技能", skill_id)
								--geyachao: 非同步日志: 释放技能
								if (hVar.IS_ASYNC_LOG == 1) then
									local msg = "AutoCastSkill: eu=" .. eu.data.name .. ",u_ID=" .. eu:getworldC() .. ", 单位不存在该技能" .. ", skill_id=" .. tostring(skill_id)
									hApi.AsyncLog(msg)
								end
							end
							
							--有效才能继续
							if bSkillCastSuccess then
								--施法是否不打断当前状态（不打断移动）
								if (tabS.IsInterrupt ~= 0) then
									--如果是玩家操控的英雄，在移动过程中不能释放技能
									if (eu.data.type == hVar.UNIT_TYPE.HERO) then
										local oHero = eu:gethero()
										if (oHero) and (eu.handle.UnitInMove == 1) then --如果是玩家操控的，不能在移动中
											bSkillCastSuccess = false --标记无效
											--geyachao: 非同步日志: 释放技能
											if (hVar.IS_ASYNC_LOG == 1) then
												local msg = "AutoCastSkill: eu=" .. eu.data.name .. ",u_ID=" .. eu:getworldC() .. ", 玩家操控的英雄移动过程中不能释放技能" .. ", skill_id=" .. tostring(skill_id)
												hApi.AsyncLog(msg)
											end
										end
									end
								end
							end
							
							--有效才能继续
							if bSkillCastSuccess then
								local validTarget = nil --有效的施法目标
								
								--判断施法类型
								--local tabS = hVar.tab_skill[skill_id]
								local castType = tabS.cast_type
								if (castType == hVar.CAST_TYPE.NONE) then --无
									--无是无效的
									--
								elseif (castType == hVar.CAST_TYPE.AUTO) then --被动技能
									--被动技能不能通过AI主动释放
									--
								elseif (castType == hVar.CAST_TYPE.IMMEDIATE) then --立即释放
									--对自己施法
									validTarget = eu
								elseif (castType == hVar.CAST_TYPE.SKILL_TO_UNIT) then --对单位释放
									--AI自己找到一个技能合适的目标
									validTarget = AI_search_skill_target(eu, skill_id)
								elseif (castType == hVar.CAST_TYPE.SKILL_TO_UNIT_IMMEDIATE) then --对自身周围的随机单位释放
									--AI自己找到一个技能合适的目标
									validTarget = AI_search_skill_target(eu, skill_id)
								elseif (castType == hVar.CAST_TYPE.SKILL_TO_GROUND) then --对地面释放
									--AI自己找到一个技能合适的目标
									validTarget = AI_search_skill_target(eu, skill_id)
								elseif (castType == hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK) then --对有效的地面释放
									--AI自己找到一个技能合适的目标
									validTarget = AI_search_skill_target(eu, skill_id)
								elseif (castType == hVar.CAST_TYPE.SKILL_TO_GROUND_MOVE_TO_POINT) then --对移动到达射程后再对地面释放
									--AI自己找到一个技能合适的目标
									validTarget = AI_search_skill_target(eu, skill_id)
								elseif (castType == hVar.CAST_TYPE.SKILL_TO_GROUND_MOVE_TO_POINT_BLOCK) then --对移动到达射程后再对有效地面释放
									--AI自己找到一个技能合适的目标
									validTarget = AI_search_skill_target(eu, skill_id)
								elseif (castType == hVar.CAST_TYPE.SKILL_TO_UNIT_MOVE_TO_POINT) then --对移动到达射程后再对施法点周围随机目标释放
									--AI自己找到一个技能合适的目标
									validTarget = AI_search_skill_target(eu, skill_id)
								elseif (castType == hVar.CAST_TYPE.SKILL_TO_GROUND_BLOCK_ENERGY) then --TD对地面有效的非障碍点地方，靠近能量圈附近
									--AI自己找到一个技能合适的目标
									validTarget = AI_search_skill_target(eu, skill_id)
								end
								
								--存在有效的目标才会释放技能
								if validTarget and (validTarget ~= 0) then
									--释放技能
									
									--print("存在有效的目标才会释放技能", eu.data.name .. "_" .. eu:getworldC(), "hApi.UnitStop_TD")
									--geyachao: 非同步日志: 释放技能
									if (hVar.IS_ASYNC_LOG == 1) then
										local msg = "AutoCastSkill: eu=" .. eu.data.name .. ",u_ID=" .. eu:getworldC() .. ", 存在有效的目标才会释放技能" .. ", hApi.UnitStop_TD"
										hApi.AsyncLog(msg)
									end
									
									--施法是否不打断当前状态（不打断移动）
									if (tabS.IsInterrupt ~= 0) then
										--单位先停下来，再施法
										--print("->hApi.UnitStop_TD------ 13")
										hApi.UnitStop_TD(eu)
										
										--标记ai状态为技能释放僵直
										eu:setAIState(hVar.UNIT_AI_STATE.CAST_STATIC)
									end
									
									--对目标施法
									local tCastParam =
									{
										level = skill[skilllIdx][2], --技能的等级
									}
									hApi.CastSkill(eu, skill_id, 0, nil, validTarget, nil, nil, tCastParam)
									
									--标记技能释放
									skill[skilllIdx][6] = currenttime
									
									--读取本次释放技能的僵直时间
									local waittime = 0 --技能僵直的时间
									for i = 1, #tabS.action, 1 do
										local v = tabS.action[i]
										if (v[1] == "StaticTime")then --等待时间标识
											waittime = waittime + v[2]
											break
										end
									end
									--标记等待时间
									eu.data.castskillLastTime = currenttime --geyachao: 新加数据 上一次塔释放技能的时间
									eu.data.castskillStaticTime = waittime --geyachao: 新加数据 塔技能释放完后僵直的时间
									
									--读取本次释放技能的下次施法允许间隔时间
									local skillwaittime = 0 --技能下次允许的时间
									for i = 1, #tabS.action, 1 do
										local v = tabS.action[i]
										if (v[1] == "SkillWaitTime")then --下次施法允许间隔时间标识
											skillwaittime = skillwaittime + v[2]
											break
										end
									end
									--标记允许下次释放技能的间隔时间
									eu.data.castskillWaitTime = skillwaittime --geyachao: 新加数据 技能释放完后允许下次释放技能的间隔时间
									
									--print(eu.data.name,"技能释放成功", skill_id)
									--geyachao: 非同步日志: 释放技能
									if (hVar.IS_ASYNC_LOG == 1) then
										local msg = "AutoCastSkill: eu=" .. eu.data.name .. ",u_ID=" .. eu:getworldC() .. ", 技能释放成功"
										hApi.AsyncLog(msg)
									end
									
									--print(eu.data.name, "currenttime=" .. currenttime , "skill_id=" .. skill_id)
								else --无目标，技能释放失败
									bSkillCastSuccess = false --标记无效
									--print(eu.data.name .. "_" .. eu:getworldC(), "找不到目标")
									--geyachao: 非同步日志: 释放技能
									if (hVar.IS_ASYNC_LOG == 1) then
										local msg = "AutoCastSkill: eu=" .. eu.data.name .. ",u_ID=" .. eu:getworldC() .. ", 找不到目标"
										hApi.AsyncLog(msg)
									end
								end
							end
							
							--如果技能释放失败，那么请空序列
							if (not bSkillCastSuccess) then
								eu.data.AI_SKILL_SEQUENCE_LIST = 0 --geyachao: 新加数据 角色在释放的技能的序列
								eu.data.AI_SKILL_SEQUENCE_INDEX = 0 --geyachao: 新加数据 角色在释放的技能的序列id
								--print(eu.data.name,"技能释放失败，请空序列")
							end
							
							--print(eu.data.name, "")
						end
					end
				end
			end
		end
	end
end

--游戏内的所有的角色检测生存时间
function AI_Unit_LiveTime_Loop_Timer()
	--遍历大地图上的每个角色
	local world = hGlobal.WORLD.LastWorldMap
	
	--如果游戏暂停，直接跳出循环
	if (world.data.IsPaused == 1) then
		return
	end
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end
	
	--游戏暂停或结束，直接退出
	if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
		return
	end
	
	--当前时间
	local currenttime = world:gametime()
	
	--如果游戏暂停，直接跳出循环
	if (world.data.IsPaused == 1) then
		return
	end
	
	--[[
	--第一波及以后才能自动释放技能
	if (mapInfo.wave < 1) then
		return
	end
	]]
	
	--遍历所有单位，检测生存时间
	world:enumunit(function(eu)
		if (eu.data.IsDead ~= 1) and (eu.attr.hp > 0) then --活着的单位
			
			if (eu.data.livetimeMax > 0) then --geyachao: 新加数据 生存时间最大值（毫秒）
				--创建生存时间
				if (not eu.chaUI["liveTime"]) then
					if (eu.attr.hideLiveTimeBar ~= 1) then --不显示倒计时进度条
						local eu_x, eu_y = hApi.chaGetPos(eu.handle)
						local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --单位的包围盒
						--local eu_center_y = (eu_by / 2 + eu_bh / 2) + eu_bh --单位的中心点y位置
						local eu_center_y = (-eu_by) + 17 --单位的中心点y位置
						local dx = -32
						local dy = eu_center_y + 5
						local dw = 62
						local dh = 6
						if (eu.data.type == hVar.UNIT_TYPE.TOWER) or (eu.data.type == hVar.UNIT_TYPE.BUILDING) then --是塔或，建筑，生存时间血条长一点
							dx = -32
							dy = eu_center_y + 5
							dw = 62
							dh = 6
						end
						
						if (eu.data.type == hVar.UNIT_TYPE.HERO) then --是英雄，生存时间血条长一点
							dx = -32
							dy = eu_center_y + 5
							dw = 62
							dh = 6
						end
						
						eu.chaUI["liveTime"] = hUI.valbar:new({
							parent = eu.handle._n,
							x = dx,
							y = dy,
							w = dw,
							h = dh,
							align = "LC",
							--back = {model = "UI:BAR_ValueBar_BG",x = -1},
							model = "UI:IMG_ValueBar",
							animation = "blue",
							v = eu.attr.hp,
							max = eu:GetHpMax(),
							show = 1,
						})
						--eu.chaUI["liveTime"].handle._n:setVisible(false)
					end
				end
				
				--显示控件
				if (eu.chaUI["liveTime"]) and (eu.chaUI["liveTime"] ~= 0) then
					--[[
					if (eu.chaUI["liveTime"].show == 0) then
						eu.chaUI["liveTime"].show = 1
						eu.chaUI["liveTime"].handle._n:setVisible(true)
					end
					]]
					
					--显示状态
					if (eu.chaUI["liveTime"].handle._n:isVisible()) then
						--更新进度
						local maxV = eu.data.livetimeMax - eu.data.livetimeBegin --（毫秒）
						local V = eu.data.livetimeMax - currenttime --（毫秒）
						eu.chaUI["liveTime"]:setV(V, maxV)
					end
				end
				
				--如果生命到了，那么死亡（毫秒）
				if (currenttime >= eu.data.livetimeMax) then
					--geyachao: 召唤单位到时间消失特殊处理函数
					if OnChaLiveTimeEnd_Special_Event then
						--安全执行
						hpcall(OnChaLiveTimeEnd_Special_Event, eu)
						--OnChaLiveTimeEnd_Special_Event(eu)
					end
					
					--获得单位所属波次(目前只有发兵需要检测)
					local wave = eu:getWaveBelong()
					--设置波次角色被消灭或漏怪
					hApi.SetUnitInWaveKilled(wave)
					
					--删除原角色
					eu.attr.hp = 0
					eu.data.IsDead = 1
					eu:del()
					
					--触发事件：生存时间到了消失事件
					hGlobal.event:event("Event_UnitLiveTime_Disappear", eu)
				end
			end
		end
	end)
end

--游戏内的所有的角色自动释放技能
function AI_CastSkill_Loop_Timer()
	--遍历大地图上的每个角色
	local world = hGlobal.WORLD.LastWorldMap
	
	--如果游戏暂停，直接跳出循环
	if (world.data.IsPaused == 1) then
		return
	end
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end

	--游戏暂停或结束，直接退出
	if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
		return
	end
	
	--波次小于1，不处理
	if (mapInfo.wave < 1) then
		return
	end
	
	--禁止响应事件，不处理
	if (world.data.keypadEnabled ~= true) then
		return
	end
	
	--当前时间
	local currenttime = world:gametime()
	
	--如果游戏暂停，直接跳出循环
	if (world.data.IsPaused == 1) then
		return
	end
	
	--[[
	--第一波及以后才能自动释放技能
	if (mapInfo.wave < 1) then
		return
	end
	]]
	
	--[[
	--geyachao: 会出现怪卡住不攻击的问题，先注释掉看是否还会卡住？
	--首先，对我方单位进行自动放技能管理
	--world:enumunit(enumunit_callback)
	local rpgunits = world.data.rpgunits
	for u, u_worldC in pairs(rpgunits) do
		if (u:getworldC() == u_worldC) then
			--todo: 暂时恢复
			--if (mapInfo.mapMode ~= hVar.MAP_TD_TYPE.TANKCONFIG) then --不在仓库
				--print("我方单位进行自动放技能管理", u.data.name, u.data.id)
				UnitAutoCastSkill(u)
			--end
		end
	end
	
	--对我方主角坦克周围的敌人进行自动放技能管理
	local rpgunit_tank = world.data.rpgunit_tank
	if rpgunit_tank and (rpgunit_tank ~= 0) then
		local hero_x, hero_y = hApi.chaGetPos(rpgunit_tank.handle) --坐标
		world:enumunitScreenEnemy(rpgunit_tank:getowner():getforce(), UnitAutoCastSkill)
	end

	--对我方主角坦克远处的BOSS敌人进行自动放技能管理
	local rpgunit_tank = world.data.rpgunit_tank
	if rpgunit_tank and (rpgunit_tank ~= 0) then
		local hero_x, hero_y = hApi.chaGetPos(rpgunit_tank.handle) --坐标
		world:enumunitScreenOutEnemy(rpgunit_tank:getowner():getforce(), function(eu)
			if (eu.data.type == hVar.UNIT_TYPE.HERO) then
				UnitAutoCastSkill(eu)
			end
		end)
	end
	]]
	
	--遍历地图上的所有单位，检测施放技能
	world:enumunit(function(eu)
		UnitAutoCastSkill(eu)
	end)
	
	--[[
	--遍历地图上所有的单位，检测是否需要返回守卫点
	world:enumunit(function(eu)
		--如果状态是闲置
		if (eu:getAIState() == hVar.UNIT_AI_STATE.IDLE) then
			if (eu.data.type ~= hVar.UNIT_TYPE.BUILDING) and (eu.data.type ~= hVar.UNIT_TYPE.HERO_TOKEN) and (eu.data.type ~= hVar.UNIT_TYPE.PLAYER_INFO) and (eu.data.type ~= hVar.UNIT_TYPE.WAY_POINT) then --非建筑、替换物、出生点、路点
				local defend_distance_max = eu.data.defend_distance_max --最远能到达的距离
				if (defend_distance_max > 0) then --这种情况下需要检测
					local ex, ey = hApi.chaGetPos(eu.handle) --单位的坐标
					local defend_x, defend_y = eu.data.defend_x, eu.data.defend_y --守卫点坐标
					local dx, dy = ex - defend_x, ey - defend_y
					local diatance = math.sqrt(dx * dx + dy * dy)
					
					--距离过近，认为不需要返回守卫点
					if (diatance > hVar.MY_TANK_FOLLOW_RADIUS) then
						--print(eu.data.name, "返回守卫点")
						--停下来
						hApi.UnitStop_TD(eu)
						
						--取消锁定的目标
						local lockTarget = eu.data.lockTarget
						--eu.data.lockTarget = 0
						--print("lockTarget = 0 46", eu.__ID)
						--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
						hApi.UnitTryToLockTarget(eu, 0, 0)
						--print("lockType 51", eu.data.name, 0)
						
						--检测目标是否也解除对其的锁定
						if (lockTarget ~= 0) then
							if (lockTarget.data.lockTarget == eu) then
								if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
									--lockTarget.data.lockTarget = 0
									--print("lockTarget = 0 45", lockTarget.__ID)
									--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
									hApi.UnitTryToLockTarget(lockTarget, 0, 0)
									--print("lockType 52", lockTarget.data.name, 0)
								end
							end
						end
						
						--设置状态为移动
						eu:setAIState(hVar.UNIT_AI_STATE.MOVE)
						
						--移动到起始点
						hApi.UnitMoveToPoint_TD(eu, defend_x, defend_y, true)
					end
				end
			end
		end
	end)
	]]
end

--检测复活的英雄 loop
function Check_Hero_Rebirth_loop()
	--如果游戏暂停，直接跳出循环
	local world = hGlobal.WORLD.LastWorldMap
	if (world.data.IsPaused == 1) then
		return
	end
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end
	
	--游戏暂停或结束，直接退出
	if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
		return
	end
	
	local currenttime = world:gametime() --当前时间
	
	--依次遍历待复活的表（倒序）
	for i = #world.data.rebirthT, 1 , -1 do --复活表
		local t = world.data.rebirthT[i]
		
		local beginTick = t.beginTick --开始的时间
		local pasttime = currenttime - beginTick --经过的时间
		local rebithTime = t.rebithTime --复活总共需要的时间（单位: 毫秒）
		local rebirth_wudi_time = t.rebirth_wudi_time --复活总共需要的时间（单位: 毫秒）
		local basic_weapon_id = t.basic_weapon_id --基础武器id
		local basic_weapon_level = t.basic_weapon_level --基础武器等级
		local basic_skill_level = t.basic_skill_level --基础技能等级
		local basic_skill_usecount = t.basic_skill_usecount --基础技能使用次数
		if (pasttime > rebithTime) then
			pasttime = rebithTime
		end
		local progressUI = t.progressUI --进度条
		local labelUI = t.labelUI --文字
		local oDeadHero = t.oDeadHero --死亡的英雄
		local deadoUint = t.deadoUint --倒计时的单位
		--local CDLabel = t.CDLabel --头像栏显示复活数字倒计时
		
		--geyachao: 复活英雄存储的表
		--{[index] = {beginTick = 0, rebithTime = 10000, progressUI = xx, labelUI = xx,}, ...}
			
		--更新进度
		progressUI:setV(rebithTime - pasttime, rebithTime)
		
		--更新文字
		local seconds = math.ceil((rebithTime - pasttime) / 1000)
		--labelUI:setText(seconds .. "秒后复活") --language
		--labelUI:setText(seconds .. hVar.tab_string["__SecondToRelive"]) --language
		labelUI:setText(seconds)
		
		--更新头像栏显示复活数字倒计时
		if oDeadHero and (oDeadHero ~= 0) then
			if oDeadHero.heroUI["btnIcon"] and oDeadHero.heroUI["btnIcon"].childUI["rebirth_time"] then
				oDeadHero.heroUI["btnIcon"].childUI["rebirth_time"]:setText(seconds)
			end
		end
		
		--如果到了复活时间，复活英雄
		if (pasttime >= rebithTime) then
			--删除复活倒计时的角色
			hApi.safeRemoveT(deadoUint.chaUI, "rebirthProgress")
			hApi.safeRemoveT(deadoUint.chaUI, "numberBar")
			--if CDLabel then
			--	CDLabel:del() --头像栏显示复活数字倒计时
			--end
			
			deadoUint:dead()
			
			--清空对应的复活表
			table.remove(world.data.rebirthT, i)
			--print("清空对应的复活表", i)
			
			--复活单位
			if oDeadHero and (oDeadHero ~= 0) then
				--geyachao: 普通模式，敌方英雄死前路点存下来，复活后继续沿路点走，PVP模式，敌方英雄路点随机
				local roadPoint = 0
				
				if (mapInfo.mapMode == hVar.MAP_TD_TYPE.NORMAL) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.DIFFICULT) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then --普通模式和挑战难度模式
					if (oDeadHero:getowner():getforce() ~= world:GetPlayerMe():getforce()) then --敌方阵营
						--死之前的路点
						roadPoint = t.roadPoint
					end
				elseif (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
					--[[
					--随机一个路点
					local heroRandomRoad = mapInfo.heroRandomRoad --路点表
					local randInt = world:random(1, #heroRandomRoad)
					local randomRoadPoint = heroRandomRoad[randInt] --随机路点
					local rd = {}
					for i = 1, #randomRoadPoint, 1 do
						table.insert(rd , {x = randomRoadPoint[i].x, y = randomRoadPoint[i].y, isHide = randomRoadPoint[i].isHide})
					end
					roadPoint = rd
					]]
					roadPoint = 0
				end
				
				--geyachao: 普通模式，英雄死后原地复活，PVP模式，英雄死后读表复活位置
				local rebirthX, rebirthY = 0, 0 --复活的位置
				--if (mapInfo.mapMode == hVar.MAP_TD_TYPE.NORMAL) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.DIFFICULT) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then --普通模式和挑战难度模式
				--	--原地复活
				--	rebirthX, rebirthY = oDeadHero.data.deadX, oDeadHero.data.deadY --英雄死亡时的位置
				--elseif (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
				--如果在出生点复活
				if mapInfo.rebirthOnBirthPoint > 0 then
					--读表位置复活
					local tOwner = oDeadHero:getowner() --阵营
					
					--if (tOwner:getforce() == w:GetPlayerMe():getforce()) then --我方或中立的
					--	rebirthX, rebirthY = mapInfo.heroBirthPos[1].x, mapInfo.heroBirthPos[1].y
					--else --敌方
					--	rebirthX, rebirthY = mapInfo.heroBirthPos[2].x, mapInfo.heroBirthPos[2].y
					--end
					
					rebirthX, rebirthY = tOwner:getgod():getXY()
					local rx = world:random(-30, 30)
					local ry = world:random(-30, 30)
					rebirthX = rebirthX + rx
					rebirthY = rebirthY + rx
					rebirthX, rebirthY = hApi.Scene_GetSpace(rebirthX, rebirthY, 30)
				--end
				else
					--原地复活
					rebirthX, rebirthY = oDeadHero.data.deadX, oDeadHero.data.deadY --英雄死亡时的位置
				end
				
				--复活英雄
				oDeadHero.data.IsDefeated = 0
				local angle = world:random(0, 360)
				local gridX, gridY = world:xy2grid(rebirthX, rebirthY)
				local oUnit = oDeadHero:enterworld(world, gridX, gridY, angle) --复活英雄
				oUnit:getowner().data.reviveCount = oUnit:getowner().data.reviveCount + 1
				
				--自动选中
				if (hVar.OP_LASTING_MODE == 1) then
					world:GetPlayerMe().localoperate:touch(world, hVar.LOCAL_OPERATE_TYPE.TOUCH_UP, gridX, gridY, rebirthX, rebirthY)
				end
				
				--geyachao: todo
				--todo: 普通模式，英雄死前路点存下来，复活后继续沿路点走
				--todo: PVP模式，英雄出生位置读表，复活位置读表，有路点（读表、随机）
				--mapInfo.heroRandomRoad
				--...
				
				--复活的英雄设置路点
				if type(roadPoint) == "table" then
					oUnit:setRoadPointByT(roadPoint)
				else
					oUnit:setRoadPoint(roadPoint)
				end
				
				--复活的英雄头像正常
				if oDeadHero.heroUI and oDeadHero.heroUI["btnIcon"] then
					hApi.AddShader(oDeadHero.heroUI["btnIcon"].handle.s, "normal")
				end
				
				--复活时间清除
				if oDeadHero.heroUI["btnIcon"] and oDeadHero.heroUI["btnIcon"].childUI["rebirth_time"] then
					oDeadHero.heroUI["btnIcon"].childUI["rebirth_time"]:setText("")
				end
				
				--pvp模式下，隐藏立即复活的控件
				if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
					if oDeadHero.heroUI and oDeadHero.heroUI["btnIcon"] and oDeadHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"] then
						oDeadHero.heroUI["btnIcon"].childUI["pvp_rebirth_label"].handle._n:setVisible(false) --不显示
					end
					if oDeadHero.heroUI and oDeadHero.heroUI["btnIcon"] and oDeadHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"] then
						oDeadHero.heroUI["btnIcon"].childUI["pvp_rebirth_count"].handle._n:setVisible(false) --不显示
					end
					
					--if oDeadHero.heroUI["pvp_is_rebirth_hero_label"] then
					--	oDeadHero.heroUI["pvp_is_rebirth_hero_label"].handle._n:setVisible(false) --不显示
					--end
					if oDeadHero.heroUI["pvp_rebirth_btn_yes"] then
						oDeadHero.heroUI["pvp_rebirth_btn_yes"]:setstate(-1) --不显示
					end
					--if oDeadHero.heroUI["pvp_rebirth_btn_no"] then
					--	oDeadHero.heroUI["pvp_rebirth_btn_no"]:setstate(-1) --不显示
					--end
				end
				
				--geyachao: 我方英雄死亡时，检测是否有绑定的死亡后禁用的战术技能卡
				local tOwner = oDeadHero:getowner() --阵营
				if (tOwner == world:GetPlayerMe()) then
					local tacticCardCtrls = world.data.tacticCardCtrls --战术技能卡控件集
					for i = 1, #tacticCardCtrls, 1 do
						local cardi = tacticCardCtrls[i]
						if cardi and (cardi ~= 0) then
							if (cardi.data.deadUnUse == 1) and (cardi.data.bindHero == oDeadHero) then --死亡后禁用状态，并且是绑定的该英雄
								--可用该战术卡
								cardi.childUI["ban"].handle.s:setVisible(false) --隐藏禁用的图标
								
								--取消该战术卡的选中状态
								if (cardi.data.selected == 1) then
									hApi.safeRemoveT(cardi.childUI, "selectbox") --删除选中特效
									cardi.data.selected = 0
								end
							end
						end
					end
				end
				
				--刷新英雄头像
				--hGlobal.event:event("LocalEvent_UpdateAllHeroIcon") --geyachao: 不能调用这个，会刷两次头像
				hGlobal.event:event("Event_HeroRevive", world, oDeadHero, oUnit) --geyachao: 触发事件
				
				--大菠萝，重置魔法值
				local manamax = hGlobal.LocalPlayer:getmanamax()
				hGlobal.LocalPlayer:setmana(manamax)
				
				--大菠萝，重置武器
				local weaponItemId = hVar.tab_unit[basic_weapon_id].skillItemlId --hGlobal.LocalPlayer:getweaponitem()
				print("weaponItemId", weaponItemId)
				hGlobal.LocalPlayer:setweaponitem(weaponItemId)
				
				--大菠萝，复活后无敌
				if (rebirth_wudi_time > 0) then
					--print("rebirth_wudi_time=", rebirth_wudi_time)
					--释放技能
					local skillId = 16044 --无敌技能id
					local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
					local gridX, gridY = world:xy2grid(targetX, targetY)
					local tCastParam =
					{
						level = rebirth_wudi_time, --等级
						--skillTimes = oUnit.data.atkTimes, --普通攻击的次数
					}
					hApi.CastSkill(oUnit, skillId, 0, 100, oUnit, gridX, gridY, tCastParam) --无敌技能
					
					--头顶冒字
					--绿色
					local nTime = math.floor(rebirth_wudi_time / 100) / 10 --保留1位有效数字
					--hApi.ShowLabelBubble(oUnit, "无敌" .. nTime .. "秒", ccc3(0, 255, 0), 0, 0, 24, 2000)
				end
				
				--大菠萝，设置单位基础武器等级
				if (oUnit.data.bind_weapon ~= 0) then
					oUnit.data.bind_weapon.attr.attack[6] = basic_weapon_level
				end
				
				--[[
				--大菠萝，技能不重置了
				--大菠萝，设置单位技能等级
				--设置技能等级为1级
				local itemSkillT = oDeadHero.data.itemSkillT
				if (itemSkillT) then
					local k = 1
					local activeItemId = itemSkillT[k].activeItemId --主动技能的id
					local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
					local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
					local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:秒）
					--print(activeItemId)
					
					--存储
					itemSkillT[k].activeItemLv = basic_skill_level
				end
				]]
				
				--大菠萝，设置技能使用次数
				if (oUnit.data.bind_weapon ~= 0) then
					local tacticCardCtrls = world.data.tacticCardCtrls --战术技能卡控件集
					local btn2 = tacticCardCtrls[hVar.TANKSKILL_IDX]
					btn2.data.useCountMax = basic_skill_usecount
					btn2.data.useCount = basic_skill_usecount
					btn2.childUI["labSkillUseCount"]:setText(basic_skill_usecount)
				end
				
				--大菠萝，调试模式，加血加速度
				if (hVar.OPTIONS.HPADD_MODE == 1) then
					local skill_id = 15997
					local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
					local gridX, gridY = world:xy2grid(targetX, targetY)
					local tCastParam =
					{
						level = 1, --等级
					}
					hApi.CastSkill(oUnit, skill_id, 0, 100, oUnit, gridX, gridY, tCastParam) --战车加血技能
				end
				if (hVar.OPTIONS.SPEEDADD_MODE == 1) then
					local skill_id = 15999
					local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
					local gridX, gridY = world:xy2grid(targetX, targetY)
					local tCastParam =
					{
						level = 1, --等级
					}
					hApi.CastSkill(oUnit, skill_id, 0, 100, oUnit, gridX, gridY, tCastParam) --战车加速度技能
				end
			end
		end
	end
end

--检测中立无敌意单位自动进入沉睡状态
function Check_auto_sleep()
	--如果游戏暂停，直接跳出循环
	local world = hGlobal.WORLD.LastWorldMap
	if (world.data.IsPaused == 1) then
		return
	end
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end
	
	--游戏暂停或结束，直接退出
	if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
		return
	end
	
	local currenttime = world:gametime() --当前时间
	
	--依次遍历所有的单位
	world:enumunit(function(eu)
		if (eu.data.type == hVar.UNIT_TYPE.NOT_USED) then
			return
		end
		if (eu.data.type == hVar.UNIT_TYPE.UNITBROKEN) then
			return
		end
		if (eu.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE) then
			return
		end
		if (eu.data.type == hVar.UNIT_TYPE.UNITDOOR) then
			return
		end
		--print(eu.data.id)
		if (eu:getowner() == nil) then
			print("ERROR!" .. tostring(eu.data.id) .. "未设置出生点！")
		end
		local euForce = eu:getowner():getforce()
		--if (euForce == hVar.FORCE_DEF.SHU) then --中立无敌意
		if (euForce == hVar.FORCE_DEF.NEUTRAL) then --中立无敌意
			if (eu.data.type == hVar.UNIT_TYPE.UNIT) or (eu.data.type == hVar.UNIT_TYPE.HERO) then
				if (eu:getAIState() == hVar.UNIT_AI_STATE.IDLE) then --空闲状态
					local lastIdleTime = eu.data.lastIdleTime
					local deltatime = currenttime - lastIdleTime
					--print(eu.data.name, deltatime)
					if (deltatime > hVar.ROLE_AUTO_SLEEP_TIME) then
						local skillId = 16045 --中立无敌意专用的沉睡技能id
						local targetX, targetY = hApi.chaGetPos(eu.handle) --目标的位置
						local gridX, gridY = world:xy2grid(targetX, targetY)
						--释放技能
						local tCastParam =
						{
							--level = oUnit.attr.attack[6], --普通攻击的等级
							--skillTimes = oUnit.data.atkTimes, --普通攻击的次数
						}
						hApi.CastSkill(eu, skillId, 0, 100, eu, gridX, gridY, tCastParam) --沉睡技能
						--print("沉睡技能", eu.data.name, deltatime)
					end
				end
			end
		end
	end)
end

--TD每秒刷新界面
function TD_RefreshUIOneSec()
	--如果游戏暂停，直接跳出循环
	local world = hGlobal.WORLD.LastWorldMap
	if (world.data.IsPaused == 1) then
		return
	end
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end

	--游戏暂停或结束，直接退出
	if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
		return
	end

	--检测场景互动塔基，点击释放技能后，状态刷新
	hGlobal.event:event("LocalEvent_TD_CHECK_TOWER_CAST_SKILL")
end

--根据当前权值从奖池获得道具
local GetRewardChestPool = function(tabM, weight, mapDifficulty)
	
	local num = 0
	local basePool = {}
	if tabM.DiffMode and tabM.DiffMode[mapDifficulty] and tabM.DiffMode[mapDifficulty].basePool then
		local poolIdList = tabM.DiffMode[mapDifficulty].basePool or {}
		for i = 1, #poolIdList do
			local poolId = poolIdList[i]
			local tmpPool = hVar.MAP_DIFF_BASE_CHEST_POOL[poolId]
			
			for n = 1, #tmpPool do
				basePool[#basePool + 1] = tmpPool[n]
			end
		end
	end



	local bluePool = {}
	local yellowPool = {}
	local redPool = {}
	local goldPool = {}
	if tabM.DiffMode and tabM.DiffMode.chestPool then
		bluePool = tabM.DiffMode.chestPool[hVar.ITEM_QUALITY.BLUE] or {}
		yellowPool = tabM.DiffMode.chestPool[hVar.ITEM_QUALITY.GOLD] or {}
		redPool = tabM.DiffMode.chestPool[hVar.ITEM_QUALITY.RED] or {}
		goldPool = tabM.DiffMode.chestPool[hVar.ITEM_QUALITY.ORANGE] or {}
	end
	

	num = num + #basePool

	--print("num:",num,weight,mapDifficulty)

	if weight >= 7 then
		if redPool then
			num = num + #redPool
		end
		if goldPool then
			num = num + #goldPool
		end

		if num > 0 then
			local idx = hApi.random(1,num)
			--print("idx:",idx)
			if idx <= #basePool then
				--print("#basePool:")
				return basePool[idx], 0
			elseif idx > #basePool and idx <= #redPool + #basePool then
				--print("#redPool:")
				return redPool[idx - #basePool], hVar.ITEM_QUALITY.RED - 1
			elseif idx > #redPool + #basePool then
				--print("#goldPool:")
				return goldPool[idx - (#redPool+#basePool)], hVar.ITEM_QUALITY.ORANGE - 1
			end
		end
	elseif weight >= 5 and weight < 7 then
		if yellowPool then
			num = num + #yellowPool
		end
		if redPool then
			num = num + #redPool
		end
		if num > 0 then
			local idx = hApi.random(1,num)
			if idx <= #basePool then
				return basePool[idx], 0
			elseif idx > #basePool and idx <= #basePool + #yellowPool then
				return yellowPool[idx - #basePool], hVar.ITEM_QUALITY.GOLD - 1
			elseif idx > #basePool + #yellowPool then
				return redPool[idx - (#basePool+#yellowPool)], hVar.ITEM_QUALITY.RED - 1
			end
		end
	elseif weight >= 3 and weight < 5 then
		if bluePool then
			num = num + #bluePool
		end
		if yellowPool then
			num = num + #yellowPool
		end
		if num > 0 then
			local idx = hApi.random(1,num)
			if idx <= #basePool then
				return basePool[idx], 0
			elseif idx > #basePool and idx <= #basePool + #bluePool then
				return bluePool[idx - #basePool], hVar.ITEM_QUALITY.BLUE - 1
			elseif idx > #basePool + #bluePool then
				return yellowPool[idx - (#basePool + #bluePool)], hVar.ITEM_QUALITY.GOLD - 1
			end
		end
	elseif weight >= 1 and weight < 3 then
		--num = num + #basePool
		if bluePool then
			num = num + #bluePool
		end
		if num > 0 then
			local idx = hApi.random(1,num)
			if idx <= #basePool then
				return basePool[idx], 0
			else
				return bluePool[idx - #basePool], hVar.ITEM_QUALITY.BLUE - 1
			end
		end
	else
		--num = num + #basePool
		if num > 0 then
			local idx = hApi.random(1,num)
			return basePool[idx], 0
		end
	end
end

local TD_GetRewardInDiffModeChestPool = function(mapname, mapDifficulty, star)
	local itemList, itemReward = {}, {}
	local tabM = hVar.MAP_INFO[mapname]
	if tabM then
		--获取本次游戏结果对应的奖励价值
		local weight = 0
		if hVar.MAP_DIFF_STAR_CONFIG[mapDifficulty] and hVar.MAP_DIFF_STAR_CONFIG[mapDifficulty][star] then
			weight = hVar.MAP_DIFF_STAR_CONFIG[mapDifficulty][star]
		end
		--print("TD_GetRewardInDiffModeChestPool:",mapname, mapDifficulty, star)
		local i = 5
		while(i > 0) do
			--根据奖励价值从奖池中抽取道具
			
			local tItem, lastWeight = GetRewardChestPool(tabM, weight,mapDifficulty)
			
			--print("while weight:".. tostring(weight).. ", lastWeight:" ..tostring(lastWeight))
			
			--道具生成失败，则减少一个级别继续循环
			if tItem then
				--重算奖励价值
				weight = weight - lastWeight
				if weight <= 0 then
					weight = 0
				end
				i = i - 1
				itemList[#itemList + 1] = tItem
			else
				--降一个级别的奖励价值
				if weight >= 7 then
					weight = 5
				elseif weight >=5 and weight < 7 then
					weight = 3
				elseif weight >=3 and weight < 5 then
					weight = 1
				elseif weight >= 1 and weight < 3 then
					weight = 0
				else
					--出错，在所有奖池都没有道具，直接return
					print("error: there is no chest pool")
					return
				end
			end
		end
		
		--建一个随机序列
		local tmp = {1,2,3,4,5}
		for k = 1, 5 do
			local itemIdx = hApi.random(1, #tmp)
			itemReward[#itemReward + 1] = tmp[itemIdx]
			table.remove(tmp,itemIdx)
		end
		
		return itemList, itemReward
	end
end

--游戏结束结算(普通局）
function TD_OnGameOver(bWin)
	
	--试炼地图相关信息保存 记录挑战难度 只记录最高值
	local oWorld = hGlobal.WORLD.LastWorldMap
	if not oWorld then
		return
	end
	
	local mapInfo = oWorld.data.tdMapInfo
	if not mapInfo then
		return
	end
	
	--地图名称
	local mapname = oWorld.data.map
	--根据游戏模式分别处理
	local mapMode = mapInfo.mapMode --当前游戏模式
	local mapDifficulty = mapInfo.mapDifficulty --当前游戏难度
	
	--关卡胜利
	if bWin then
		--记录通关次数
		local finish_count = 0 
		finish_count = (LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.FINISH_COUNT) or 0)
		
		--首次通关，发送服务器记录
		if (finish_count == 0) then
			local mapId = hVar.MAP_INFO[mapname].uniqueID
			SendCmdFunc["upload_map_record"](mapId, mapname)
		end
		
		LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.FINISH_COUNT,finish_count+1,true)
		
		--胜利统计
		LuaAddPlayerCountVal(hVar.MEDAL_TYPE.gameTimes)
		LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.gameTimes)
		--日常任务地图胜利是否满足特定条件
		LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.mapCondition ,mapname)
		LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.chapterCondition ,mapname)
		
		--local isBoss = hApi.CheckMapIsBoss(mapname)
		
		local pLog = oWorld:getplayerlog(hGlobal.LocalPlayer.data.playerId)
		if pLog then
			local getReward = false
			
			--设置玩家通关的评价 只保存最高星星数
			local star = 0
			--boss关卡
			--if isBoss then
			--	star = 0
			--	getReward = true
			--	pLog.starV = 3
			--else --普通关卡
				
				--计算星级
				local maxStar = 1
				local totalLife = mapInfo.totalLife
				--local life = mapInfo.life
				local life = 0
				local me = oWorld:GetPlayerMe()
				if me then
					local force = me:getforce()
					local forcePlayer = oWorld:GetForce(force)
					if forcePlayer then
						life = forcePlayer:getresource(hVar.RESOURCE_TYPE.LIFE) or 0
					end
				end
				
				--if life >= math.ceil(totalLife * 0.9) then
				--	maxStar = 3
				--elseif life >= math.ceil(totalLife * 0.5) then
				--	maxStar = 2
				--end
				if life >= 9 then
					maxStar = 3
				elseif life >= 5 and life <= 8 then
					maxStar = 2
				end
				pLog.starV = maxStar
				
				local diffMax = (LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.Map_Difficult) or 0)
				
				--print("TD_OnGameOver:".. tostring(maxStar)..",".. tostring(star))
				
				--更新通关信息及星级信息
				if mapMode == hVar.MAP_TD_TYPE.NORMAL then
					star = (LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.MAPSTAR) or 0)
					
					--如果存档中的星级小于当前获得的星级，则需要刷新数据
					if star < pLog.starV then
						LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.MAPSTAR,pLog.starV,true)
						getReward = true
						
						if pLog.starV >= 3 then
							LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.Map_Difficult,1,true)
							LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.IMPERIAL,0,true)
						end
						
						--统计普通关卡得星
						LuaAddPlayerCountVal(hVar.MEDAL_TYPE.starCount, pLog.starV - star)
						LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.starCount, pLog.starV - star)
					end
					
					--统计开始
					if pLog.starV >= 3 then
						--统计关卡满星通关次数
						LuaAddPlayerCountVal(hVar.MEDAL_TYPE.allStar)
						LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.allStar)
						
						--统计普通关卡满星通关次数
						LuaAddPlayerCountVal(hVar.MEDAL_TYPE.allStarNormal)
						LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.allStarNormal)
					end
					
					--通关统计
					LuaAddPlayerCountVal(hVar.MEDAL_TYPE.gameTimesNormal)
					LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.gameTimesNormal)
					
				elseif mapMode == hVar.MAP_TD_TYPE.DIFFICULT then
					--如果选择难度小于已达到的最大难度，则直接跳过，不需要给星级奖励，但会给积分
					if mapDifficulty < diffMax then
						--star = 3
					else
						--获取挑战模式当前难度历史所得星数
						star = (LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.IMPERIAL) or 0)
						--如果当前获得星数大于历史星数
						if star < pLog.starV then
							--更新星数,获取奖励
							LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.IMPERIAL,pLog.starV,true)
							getReward = true
							
							--如果当前获得三星，则开启下一难度
							if pLog.starV >= 3 then
								local diff = diffMax + 1
								--未达到最大难度则开启下一难度，否则停留在当前难度
								if diff <= mapInfo.mapMaxDiff then
									LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.Map_Difficult,diff,true)
									LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.IMPERIAL,0,true)
								end
								
							end
							
							--统计挑战难度关卡得星
							LuaAddPlayerCountVal(hVar.MEDAL_TYPE.starCount, pLog.starV - star)
							LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.starCount, pLog.starV - star)
						end
					end
					
					local itemList, itemRewardList = TD_GetRewardInDiffModeChestPool(mapname, mapDifficulty, pLog.starV)
					if itemList then
						--重新随机
						mapInfo.chestPool = {}
						for i = 1, 5 do
							local idx = itemRewardList[i]
							mapInfo.chestPool[i] = itemList[idx]
						end
						--for i = 1, #itemList do
							--print("ChestPool reward item["..i.."]:",itemList[i][1],itemList[i][2],itemList[i][3],itemList[i][4])
						--end
					else
						print("ChestPool is null")
					end
					
					--统计开始
					if pLog.starV >= 3 then
						--统计关卡满星通关次数
						LuaAddPlayerCountVal(hVar.MEDAL_TYPE.allStar)
						LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.allStar)
						
						--统计挑战关卡满星通关次数
						LuaAddPlayerCountVal(hVar.MEDAL_TYPE.allStarDiff)
						LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.allStarDiff)
						
						for i = 1, (math.min(mapDifficulty, mapInfo.mapMaxDiff)) do
							--分别统计挑战关卡不同难度满星通关次数
							LuaAddPlayerCountVal((hVar.MEDAL_TYPE.allStarDiff)..i)
							LuaAddDailyQuestCountVal((hVar.MEDAL_TYPE.allStarDiff)..i)
						end
					end
					
					--过关统计
					LuaAddPlayerCountVal(hVar.MEDAL_TYPE.gameTimesDiff)
					LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.gameTimesDiff)
					for i = 1, (math.min(mapDifficulty, mapInfo.mapMaxDiff)) do
						--分别统计挑战关卡不同难度通关次数
						LuaAddPlayerCountVal((hVar.MEDAL_TYPE.gameTimesDiff)..i)
						LuaAddDailyQuestCountVal((hVar.MEDAL_TYPE.gameTimesDiff)..i)
					end
					
					
				
				elseif mapMode == hVar.MAP_TD_TYPE.ENDLESS then
					
				end
				
			--end
			
			--print("star=", star)
			--print("maxStar=", pLog.starV)
			
			if getReward and mapInfo.starReward then
				for i = star + 1, pLog.starV do
					local starReward = mapInfo.starReward[i]
					if starReward then
						local rewardType = starReward[1] or 0		--获取类型
						--print("TD_OnGameOver rewardType[".. tostring(i) .."]:".. tostring(rewardType))
						if rewardType == 1 then				--1积分
							local addScore = starReward[2] or 0
							if addScore>0 then
								LuaAddPlayerScore(addScore,true)
								local map_get_score = LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.Map_GetScore) or 0
								map_get_score = map_get_score + addScore
								LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.Map_GetScore,map_get_score,true)
								--print("TD_OnGameOver add score:".. tostring(addScore))
								table.insert(mapInfo.getStarReward,{rewardType, addScore})
							end
						elseif rewardType == 2 then			--2战术技能卡
							local tacticId = starReward[2] or 0
							local tacticNum = starReward[3] or 1
							local tacticLv = starReward[4] or 1
							if tacticId > 0 and tacticNum > 0 and hVar.tab_tactics[tacticId] then
								local maxLv = hVar.tab_tactics[tacticId].level or 1
								if tacticLv > maxLv then
									tacticLv = maxLv
								end
								LuaAddPlayerSkillBook(tacticId, tacticLv, tacticNum)
								
								--留给界面刷新用的
								table.insert(mapInfo.getStarReward,{rewardType, tacticId, tacticNum, tacticLv})
								--print("TD_OnGameOver add tactic:".. tostring(tacticId)..",".. tostring(tacticLv)..",".. tostring(tacticNum))
							end
						elseif rewardType == 3 then			--3道具
							local itemId = starReward[2] or 0
							local exValueRatio = starReward[3] or 0
							if itemId > 0 and hVar.tab_item[itemId] then
								LuaAddItemToPlayerBag(itemId,nil,nil,exValueRatio)
								table.insert(mapInfo.getStarReward,{rewardType, itemId})
								--print("TD_OnGameOver add item:".. tostring(itemId))
							end
						elseif rewardType == 4 then			--4英雄
							local heroId = starReward[2] or 0
							local star = starReward[3] or 1
							local lv = starReward[4] or 1
							if heroId > 0 and hVar.tab_unit[heroId] then
								hGlobal.event:event("LocalEvent_BuyHeroCardSucceed",heroId, star, lv)
								table.insert(mapInfo.getStarReward,{rewardType, heroId, star, lv})
								--print("TD_OnGameOver add hero:".. tostring(heroId))
							end
						elseif rewardType == 5 then			--5将魂
							local itemId = starReward[2] or 0
							local itemNum = starReward[3] or 1
							if itemId > 0 and hVar.tab_item[itemId] and itemNum > 0 then
								local heroId = hVar.tab_item[itemId].heroID or 0
								if heroId > 0 and hVar.tab_unit[heroId] then
									--添加英雄将魂
									LuaAddHeroCardSoulStone(heroId, itemNum)
									table.insert(mapInfo.getStarReward,{rewardType, itemId, itemNum})
									--print("TD_OnGameOver add soulstone:".. tostring(itemId)..","..tostring(itemNum))
								end
							end
						elseif rewardType == 6 then			--6战术技能卡碎片
							local itemId = starReward[2] or 0
							local itemNum = starReward[3] or 1
							--print("skkjdjgoidjoihj:",itemId, itemNum)
							if itemId > 0 and hVar.tab_item[itemId] and itemNum > 0 then
								local tacticId = hVar.tab_item[itemId].tacticID or 0
								if tacticId > 0 and hVar.tab_tactics[tacticId] then
									--添加战术技能卡碎片
									local ret = LuaAddPlayerTacticDebris(tacticId, itemNum)
									--print("aksjfklsajfk:"..tostring(tacticId)..","..tostring(itemNum).. ",".. tostring(ret))
									--print(""..nil)
									table.insert(mapInfo.getStarReward,{rewardType, itemId, itemNum})
									--print("TD_OnGameOver add tacticdebris:".. tostring(itemId)..","..tostring(itemNum))
								end
							end
						end
					end
				end
			end
			
			--每关必定产出积分 --zhenkira 2016.1.7
			pLog.scoreV = (mapInfo.scoreV or 0) + ((oWorld:GetPlayerMe():getScoreAdd() or 0))
			if pLog.scoreV > 0 then
				mapInfo.getScoreV = pLog.scoreV
				LuaAddPlayerScore(pLog.scoreV,true)
				local map_get_score = LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.Map_GetScore) or 0
				map_get_score = map_get_score + pLog.scoreV
				LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.Map_GetScore,map_get_score,true)
			end

			--遍历所有出场英雄，给英雄加经验
			local allHero = oWorld:GetSelectedHeroList()
			mapInfo.getStarReward["heroLastLv"] = {}
			for i = 1, #allHero do
				local heroId = allHero[i]
				mapInfo.getStarReward["heroLastLv"][heroId] = LuaGetHeroLevel(heroId)
				--local exp = (mapInfo.exp or 0) + (mapInfo.expAdd or 0)
				local exp = (mapInfo.exp or 0) + (oWorld:GetPlayerMe():getExpAdd() or 0)
				LuaAddHeroExp(heroId, exp)
			end
			
			--保存玩家通关信息 并保存通关积分
			local haveLevel = (LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.LEVEL) or 0)
			if haveLevel == 0 then
				LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.LEVEL,1,true)
				oWorld.fristScore = 1
			end
			
			--友盟统计,地图完成情况统计
			if xlAppAnalysis then
				local tmp = hApi.Split(mapname, "/")
				if mapMode == hVar.MAP_TD_TYPE.NORMAL then
					xlAppAnalysis("normalMapStatistics",0,1,"info", tmp[#tmp].."_0"..(pLog.starV))
				elseif mapMode == hVar.MAP_TD_TYPE.DIFFICULT then
					xlAppAnalysis("normalMapStatistics",0,1,"info", tmp[#tmp].."_"..(mapDifficulty or 1)..(pLog.starV))
				end
			end
		end
		
		--作弊检测，很重要的接口，上线时需要开放
		--hApi.AddMapUniqueID(g_curPlayerName,g_localfilepath) --地图唯一标识自+1
	else
		--失败产出积分每关必定产出积分 --zhenkira 2016.1.7
		local scoreV = (mapInfo.scoreV or 0) + ((oWorld:GetPlayerMe():getScoreAdd() or 0))
		local waveNow = mapInfo.wave
		local maxWave = mapInfo.totalWave
		if maxWave > 3 then
			--积分
			local pLog = oWorld:getplayerlog(hGlobal.LocalPlayer.data.playerId)
			if pLog then
				if waveNow == maxWave then
					pLog.scoreV = math.floor(scoreV * 0.3) or 0
				elseif waveNow == maxWave - 1 then
					pLog.scoreV = math.floor(scoreV * 0.2) or 0
				elseif waveNow == maxWave - 2 then
					pLog.scoreV = math.floor(scoreV * 0.1) or 0
				end
				
				if pLog.scoreV > 0 then
					mapInfo.getScoreV = pLog.scoreV
					LuaAddPlayerScore(pLog.scoreV,true)
					local map_get_score = LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.Map_GetScore) or 0
					map_get_score = map_get_score + pLog.scoreV
					LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.Map_GetScore,map_get_score,true)
				end
			end
			
			--英雄经验值
			--local expAdd = (mapInfo.exp or 0) + (mapInfo.expAdd or 0)
			local expAdd = (mapInfo.exp or 0) + (oWorld:GetPlayerMe():getExpAdd() or 0)
			if waveNow == maxWave then
				expAdd = math.floor(expAdd * 0.3) or 0
			elseif waveNow == maxWave - 1 then
				expAdd = math.floor(expAdd * 0.2) or 0
			elseif waveNow == maxWave - 2 then
				expAdd = math.floor(expAdd * 0.1) or 0
			else
				expAdd = 0
			end
			
			if expAdd > 0 then
				--遍历所有出场英雄，给英雄加经验
				local allHero = oWorld:GetSelectedHeroList()
				mapInfo.getStarReward["heroLastLv"] = {}
				for i = 1, #allHero do
					local heroId = allHero[i]
					mapInfo.getStarReward["heroLastLv"][heroId] = LuaGetHeroLevel(heroId)
					local exp = expAdd
					LuaAddHeroExp(heroId, exp)
				end
			end
		end
		
		--统计游戏失败次数
		LuaAddPlayerCountVal(hVar.MEDAL_TYPE.gameFailed)
		LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.gameFailed)
		
		--友盟统计,地图完成情况统计
		if xlAppAnalysis then
			local tmp = hApi.Split(mapname, "/")
			if mapMode == hVar.MAP_TD_TYPE.NORMAL then
				xlAppAnalysis("normalMapStatistics",0,1,"info", tmp[#tmp].."_00")
			elseif mapMode == hVar.MAP_TD_TYPE.DIFFICULT then
				xlAppAnalysis("normalMapStatistics",0,1,"info", tmp[#tmp].."_"..(mapDifficulty or 1).."0")
			end
		end
		
	end
	
	--如果地图为无尽模式，记录并更新战绩信息
	if (mapMode == hVar.MAP_TD_TYPE.ENDLESS) then
		local combatEva = mapInfo.combatEva
		local combatHistory = LuaGetPlayerGamecenter_Challenge(mapname) --历史最高值
		
		local pLog = oWorld:getplayerlog(hGlobal.LocalPlayer.data.playerId)
		if pLog then
			pLog.endlessLastScore = combatHistory --无尽模式历史最高值
			pLog.endlessCurrentScore = combatEva --无尽模式本次值
		end
		local tmp = hApi.Split(mapname, "/")
		local sMap = tmp[#tmp]
		
		--成就
		LuaSetPlayerGamecenter_Challenge(mapname, combatEva)
		--日常任务
		LuaAddDailyQuestCountVal(sMap, combatEva)
		
		--存储本地，今天的无尽地图的排行榜的本地数据
		--检测本地图是属于哪一个排行榜id
		local bId = 0
		local bUpload = false
		for i = 1, #hVar.BILL_BOARD_MAP, 1 do
			if (hVar.BILL_BOARD_MAP[i].mapName == mapname) then
				bId = hVar.BILL_BOARD_MAP[i].bid
				bUpload = hVar.BILL_BOARD_MAP[i].bUpload
				break
			end
		end
		if (bId > 0) and (bUpload) then
			--本地保存
			LuaSetPlayerBillBoard(g_curPlayerName, bId, combatEva)
			
			--上传得分
			local scoreValid = LuaGetPlayerBillBoard(g_curPlayerName, bId)
			if (scoreValid > 0) then
				local intTimeNow =  hApi.GetNewDate(g_endlessBeginTime) --北京时区
				local strDateTimeNow = g_endlessBeginTime --北京时区
				
				--与北京时间的时差
				local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
				local delteZone = localTimeZone - 8 --与北京时间的时差
				
				local checkSum = (scoreValid + intTimeNow + delteZone * 3600) % 9973 --校验值
				SendCmdFunc["update_billboard_rank"](bId, scoreValid, strDateTimeNow, checkSum)
			end
		end
		
		--上传成就到排行榜
		if (xlGameCenter_isAuthenticated and xlGameCenter_isAuthenticated() == 1) then
			hApi.xlGameCenter_reportScore(LuaGetPlayerGamecenter_Challenge(mapname), "td.p."..sMap)
		end
	end
	
	LuaSaveHeroCard(true)
	xlDeleteFileWithFullPath(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.MAP_SAVE)
	xlDeleteFileWithFullPath(g_localfilepath..g_curPlayerName..hVar.SAVE_DATA_PATH.FOG)
	--删除最近3天的存档
	LuaDeletePlayerAutoSave(g_curPlayerName)
	--LuaClearLootFromUnit(g_curPlayerName)
	
	LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	
	--[[
	--播放音乐
	if (mapMode == hVar.MAP_TD_TYPE.PVP) then --pvp模式
		--geyachao: pvp不会走进来的。。。
		if bWin then
			--胜利
			hApi.PlaySoundBG(g_channel_battle,0)
			--hApi.PlaySound("battle_win")
			hApi.PlaySound("battle_win")
		else
			--失败
			hApi.PlaySoundBG(g_channel_battle,0)
			--hApi.PlaySound("battle_lose")
			hApi.PlaySound("battle_lose")
		end
	elseif (mapMode == hVar.MAP_TD_TYPE.ENDLESS) then --无尽地图
		--胜利
		hApi.PlaySoundBG(g_channel_battle,0)
		--hApi.PlaySound("battle_win")
		hApi.PlaySound("win_sound")
	else --一般地图
		if bWin then
			--胜利
			hApi.PlaySoundBG(g_channel_battle,0)
			--hApi.PlaySound("battle_win")
			hApi.PlaySound("win_sound")
		else
			--失败
			hApi.PlaySoundBG(g_channel_battle,0)
			--hApi.PlaySound("battle_lose")
			hApi.PlaySound("game_lose")
		end
	end
	]]
end

--游戏结束结算(pvp局）
function TD_OnGameOver_PVP(bWin)
	local oWorld = hGlobal.WORLD.LastWorldMap
	if not oWorld then
		return
	end
	
	local mapInfo = oWorld.data.tdMapInfo
	if not mapInfo then
		return
	end
	
	--地图名称
	local mapname = oWorld.data.map
	--根据游戏模式分别处理
	local mapMode = mapInfo.mapMode --当前游戏模式
	local mapDifficulty = mapInfo.mapDifficulty --当前游戏难度
	--print("TD_OnGameOver", mapMode, bWin)
	
	--播放音乐
	if (mapMode == hVar.MAP_TD_TYPE.PVP) then --pvp模式
		if bWin then
			--胜利
			hApi.PlaySoundBG(g_channel_battle,0)
			--hApi.PlaySound("battle_win")
			hApi.PlaySound("battle_win")
		else
			--失败
			hApi.PlaySoundBG(g_channel_battle,0)
			--hApi.PlaySound("battle_lose")
			hApi.PlaySound("battle_lose")
		end
	end
end

--游戏结束结算(大菠萝）
function TD_OnGameOver_Diablo(bWin)
	--print("TD_OnGameOver_Diablo", bWin)
	local oWorld = hGlobal.WORLD.LastWorldMap
	if not oWorld then
		return
	end
	
	local mapInfo = oWorld.data.tdMapInfo
	if not mapInfo then
		return
	end
	
	--地图名称
	local mapname = oWorld.data.map
	--根据游戏模式分别处理
	local mapMode = mapInfo.mapMode --当前游戏模式
	local mapDifficulty = mapInfo.mapDifficulty --当前游戏难度
	--print("TD_OnGameOver", mapMode, bWin)
	
	--播放音乐
	if (bWin == 1) or (bWin == true) then
		--胜利
		--print("TD_Portal_Loop11")
		--保存玩家通关信息 并保存通关积分
		--大菠萝，存档
		local haveLevel = (LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.LEVEL) or 0)
		if haveLevel == 0 then
			LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.LEVEL,1,true)
		end
		
		--大菠萝，记录通关次数
		local finish_count = 0 
		finish_count = (LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.FINISH_COUNT) or 0)
		
		LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.FINISH_COUNT,finish_count+1,true)
		
		--[[
		--游戏胜利上传本局的经验值
		local me = oWorld:GetPlayerMe()
		local exp = me:getresource(hVar.RESOURCE_TYPE.EXP) or 0 --经验值
		if (exp > 0) then
			SendCmdFunc["tank_talentpoint_addexp"](6000, exp)
			print("GameEnd AddExp:", exp)
		end
		]]
		
		--播放音效
		hApi.PlaySoundBG(g_channel_battle,0)
		--hApi.PlaySound("battle_win")
		hApi.PlaySound("battle_win")
	else
		--失败
		hApi.PlaySoundBG(g_channel_battle,0)
		--hApi.PlaySound("battle_lose")
		hApi.PlaySound("battle_lose")
	end
end

--TD野怪出生
function TD_WildBirth_Loop()
	local w = hGlobal.WORLD.LastWorldMap
	
	if (not w) then
		return
	end
	
	local mapInfo = w.data.tdMapInfo
	
	if not w or not mapInfo then
		return
	end
	
	--游戏暂停或结束，直接退出
	if mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE then
		return
	end
	
	--如果回合还没开始，退出
	if mapInfo.wave <= 0 then
		return
	end
	
	local mapInfo = w.data.tdMapInfo
	if mapInfo.wildPoint then
		for i = 1, #mapInfo.wildPoint do
			local wildPoint = mapInfo.wildPoint[i]
			wildPoint:WildBirthUpdate()
		end
	end
end

--TD野怪死亡检测
function TD_WildCheckDead(oDeadTarget, operate, oKillerUnit, id, param, oKillerSide, oKillerPos)
	local w = hGlobal.WORLD.LastWorldMap
	if (not w) then
		return
	end
	
	local mapInfo = w.data.tdMapInfo
	
	if not w or not mapInfo then
		return
	end
	
	--游戏暂停或结束，直接退出
	if mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE then
		return
	end
	
	--如果回合还没开始，退出
	if mapInfo.wave <= 0 then
		return
	end

	if mapInfo.wildPoint then
		for i = 1, #mapInfo.wildPoint do
			local wildPoint = mapInfo.wildPoint[i]
			wildPoint:WildDeathCheck(oDeadTarget, operate, oKillerUnit, id, param, oKillerSide, oKillerPos)
		end
	end
end

--TD传送门
function TD_Portal_Loop()
	local w = hGlobal.WORLD.LastWorldMap
	if (not w) then
		return
	end
	
	local mapInfo = w.data.tdMapInfo
	
	if not w or not mapInfo then
		return
	end
	
	--游戏暂停或结束，直接退出
	if mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE then
		return
	end
	
	--如果回合还没开始，退出
	if mapInfo.wave <= 0 then
		return
	end

	--print("TD_Portal_Loop:1",mapInfo.portal)

	local d = w.data
	local gametime = w:gametime()
	
	--传送门逻辑
	if mapInfo.portal then
		--print("TD_Portal_Loop:2")
		for i = 1, #mapInfo.portal do
			local portal = mapInfo.portal[i]
			if portal then
				local x = portal.x
				local y = portal.y
				local owner = portal.owner
				local portalPlayer = w:GetPlayer(owner)
				local force = portalPlayer:getforce()
				local searchRadius = portal.searchRadius
				local startConditionType = portal.startConditionType
				local startCondition = portal.startCondition or {}
				local portalType = portal.portalType
				local toX = portal.toX
				local toY = portal.toY
				local toMap = portal.toMap
				local eu = portal.eu
				local viewReset = portal.viewReset
				local flag = portal.flag or 0 --是否传送过
				local enterMusic = portal.enterMusic --进入的背景音乐
				local bBeginInside = portal.bBeginInside --初始是否已经在传送门里（如果初始已经在，需要先出来再进去才能触发传送）
				if not portal.isShow then
					local meetAll
					if startConditionType == 0 then
						if #startCondition > 0 then
							local cNum = 0
							for j = 1, #startCondition do
								local c = startCondition[j]
								if string.upper(c[1]) == "KILL" then
									if (d.unitdeathcounts[c[2]][c[3]]) or 0 >= c[4] then
										cNum = cNum + 1
									end
								elseif string.upper(c[1]) == "WAVE" then
									if mapInfo.wave > c[2] then
										cNum = cNum + 1
									end
								elseif string.upper(c[1]) == "GAMETIME" then
									if gametime > c[2] then
										cNum = cNum + 1
									end
								elseif string.upper(c[1]) == "COMBATEVA" then
									--print("mapInfo.combatEva:",mapInfo.combatEva,c[2])
									if mapInfo.combatEva >= c[2] then
										cNum = cNum + 1
									end
								end
							end
							--print("cNum >= #startCondition:",cNum,#startCondition)
							--print(""..abc)
							if cNum >= #startCondition then
								meetAll = true
							end
						else
							meetAll = true
						end
					elseif startConditionType == 1 then
						if #startCondition > 0 then
							for j = 1, #startCondition do
								local c = startCondition[j]
								if string.upper(c[1]) == "KILL" then
									if (d.unitdeathcounts[c[2]][c[3]]) or 0 >= c[4] then
										meetAll = true
										break
									end
								elseif string.upper(c[1]) == "WAVE" then
									if mapInfo.wave > c[2] then
										meetAll = true
										break
									end
								elseif string.upper(c[1]) == "GAMETIME" then
									if gametime > c[2] then
										meetAll = true
										break
									end
								elseif string.upper(c[1]) == "COMBATEVA" then
									if mapInfo.combatEva >= c[2] then
										meetAll = true
										break
									end
								else
									meetAll = true
									break
								end
							end
						else
							meetAll = true
						end
					elseif startConditionType == 2 then --区域传送
						if (eu.data.IsHide == 1) then
							meetAll = false
						elseif (eu.data.IsHide == 0) then
							meetAll = true
						end
					elseif startConditionType == 3 then --区域传送返回
						if (eu.data.IsHide == 1) then
							meetAll = false
						elseif (eu.data.IsHide == 0) then
							meetAll = true
						end
					elseif startConditionType == 4 then --区域传送（最后一关）
						if (eu.data.IsHide == 1) then
							meetAll = false
						elseif (eu.data.IsHide == 0) then
							meetAll = true
						end
					end
					
					if meetAll then
						portal.isShow = true
						--显示传送门模型
						if eu then
							eu:sethide(0)
							--print("显示传送门模型", eu.data.id, eu.data.worldX, eu.data.worldY)
						end
					else
						--
					end
				end
				
				if portal.isShow then
					
					--print("TD_Portal_Loop:3")
					--w:enumunitArea(x, y, searchRadius, function(oUnit)
					local bFindUnit = false --是否找到了传送的英雄
					w:enumunitAreaAlly(hVar.FORCE_DEF.GOD, x, y, searchRadius, function(oUnit)
						
						--print("TD_Portal_Loop:4")
						
						--如果角色存在,并且没有死亡
						if oUnit and (oUnit.data.IsDead ~= 1) and (oUnit.attr.hp > 0) then
							
							--print("TD_Portal_Loop:5")
							if (oUnit.ID > 0) then
								local oUnitPlayer = oUnit:getowner()
								if oUnitPlayer then
									
									local oUnitForce = oUnitPlayer:getforce()
									local d = oUnit.data
									--print("TD_Portal_Loop6:",d.type,hVar.UNIT_TYPE.HERO,owner,d.owner,force,oUnitForce)
									--如果角色是英雄，并且是角色对应的玩家或属方，不是召唤单位
									if (d.type == hVar.UNIT_TYPE.HERO) and (owner == d.owner or force == oUnitForce) and(d.is_summon == 0) and (d.is_fenshen == 0) then
										--标记找打了可传送的单位
										bFindUnit = true
										--print("TD_Portal_Loop:7")
										
										--print("TD_Portal_Loop:8:",portalType)
										
										--如果初始已经在传送门里，不允许传送
										if (bBeginInside ~= true) then
											--地图内传送
											if tonumber(portalType) == 0 then
												--是否层数加1
												--大菠萝，第一次传送才加1
												if (flag == 0) then
													portal.flag = 1
													
													local round = w.data.pvp_round --铜雀台、新手地图层数
													hGlobal.event:event("Event_UpdateGameRound", round + 1)
												end
												local round_ahead = w.data.pvp_round
												--local round_ahead = w.data.pvp_round_ahead --铜雀台、新手地图前置层数（打完boss就可以加1）
												--local round = w.data.pvp_round --铜雀台、新手地图层数
												--if (round < round_ahead) then
												--	hGlobal.event:event("Event_UpdateGameRound", round_ahead)
												--end
												
												--如果在出生点复活，将本位置的上帝也传送过去
												if (mapInfo.rebirthOnBirthPoint > 0) then
													oUnitPlayer:getgod():setPos(toX, toY)
												end
												
												--本位置玩家的所有英雄传送
												for n = 1, #oUnitPlayer.heros do
													local oHero = oUnitPlayer.heros[n]
													if oHero and (type(oHero) == "table") then
														local ou = oHero:getunit()
														if ou and (type(ou) == "table") then
															--print("TD_Portal_Loop:9",toX, toY)
															--设置位置
															local randPosX = toX-- + w:random(-3, 3)
															local randPosY = toY-- + w:random(-3, 3)
															--randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 6)
															ou:setPos(randPosX, randPosY)
															
															--将单位身上的眩晕、僵直等状态清空
															local a = ou.attr
															a.stun_stack = 0 --眩晕的堆叠层数
															a.suffer_chaos_stack = 0 --混乱的堆叠层数
															a.suffer_blow_stack = 0 --吹风的堆叠层数
															a.suffer_chuanci_stack = 0 --穿刺的堆叠层数
															a.suffer_sleep_stack = 0 --沉睡的堆叠层数
															a.suffer_chenmo_stack = 0 --沉默的堆叠层数
															a.suffer_jinyan_stack = 0 --禁言的堆叠层数（不能普通攻击）
															a.suffer_touming_stack = 0  --透明的堆叠层数（不能碰撞）
															
															--设置ai状态为闲置
															ou:setAIState(hVar.UNIT_AI_STATE.IDLE)
															
															--地图内单位传送之后回调函数
															if On_UnitTransport_Special_Event then
																--安全执行
																hpcall(On_UnitTransport_Special_Event, w, round_ahead, ou, randPosX, randPosY)
																--On_UnitTransport_Special_Event(w, round_ahead, ou, randPosX, randPosY)
															end
														end
														
													end
												end
												
												--本位置玩家的所有复活地上插的棍子传送
												for i = 1, #w.data.rebirthT, 1 do --复活表
													local t = w.data.rebirthT[i]
													
													--local beginTick = t.beginTick --开始的时间
													--local rebithTime = t.rebithTime --复活总共需要的时间
													--local progressUI = t.progressUI --进度条
													--local labelUI = t.labelUI --文字
													local oDeadHero = t.oDeadHero --死亡的英雄
													local deadoUint = t.deadoUint --倒计时的棍子单位
													
													if (oDeadHero:getowner() == oUnitPlayer) then
														--设置棍子的坐标
														deadoUint:setPos(toX, toY)
														
														--标记死亡的英雄的复活坐标
														oDeadHero.data.deadX = toX --死亡时的x坐标 --geyachao: 新加大地图复活流程，记录死亡的位置
														oDeadHero.data.deadY = toY --死亡时的y坐标 --geyachao: 新加大地图复活流程，记录死亡的位置
														
														--地图内单位传送之后回调函数
														if On_UnitTransport_Special_Event then
															--安全执行
															hpcall(On_UnitTransport_Special_Event, w, round_ahead, deadoUint, toX, toY)
															--On_UnitTransport_Special_Event(w, round_ahead, deadoUint, toX, toY)
														end
													end
												end
												
												--geyachao: 大菠萝瓦力传送
												local rpgunits = w.data.rpgunits
												for u, u_worldC in pairs(rpgunits) do
												--w:enumunit(function(u)
													--if (u.data.id == hVar.MY_TANK_FOLLOW_ID) then
													for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
														if (u.data.id == walle_id) then
															--print("TD_Portal_Loop:9",toX, toY)
															--设置位置
															local randPosX = toX-- + w:random(-3, 3)
															local randPosY = toY-- + w:random(-3, 3)
															--randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 6)
															u:setPos(randPosX, randPosY)
															
															--将单位身上的眩晕、僵直等状态清空
															local a = u.attr
															a.stun_stack = 0 --眩晕的堆叠层数
															a.suffer_chaos_stack = 0 --混乱的堆叠层数
															a.suffer_blow_stack = 0 --吹风的堆叠层数
															a.suffer_chuanci_stack = 0 --穿刺的堆叠层数
															a.suffer_sleep_stack = 0 --沉睡的堆叠层数
															a.suffer_chenmo_stack = 0 --沉默的堆叠层数
															a.suffer_jinyan_stack = 0 --禁言的堆叠层数（不能普通攻击）
															a.suffer_touming_stack = 0  --透明的堆叠层数（不能碰撞）
															
															--设置ai状态为闲置
															u:setAIState(hVar.UNIT_AI_STATE.IDLE)
															
															--地图内单位传送之后回调函数
															if On_UnitTransport_Special_Event then
																--安全执行
																hpcall(On_UnitTransport_Special_Event, w, round_ahead, u, randPosX, randPosY)
																--On_UnitTransport_Special_Event(w, round_ahead, u, randPosX, randPosY)
															end
														end
													end
												end
												
												--标记本传送门已传送过
												mapInfo.portalFinishState[i] = true
												
												--刷新动态障碍
												--w:enumunit(function(eu)
												--	eu:_addblock()
												--end)
												
												--镜头设置
												TD_ViewSet(viewReset)
												hApi.setViewNodeFocus(toX,toY)
												
												--播放背景音乐
												--背景音乐
												if (enterMusic ~= "") then
													if (hApi.GetPlaySoundBG(g_channel_world) ~= enterMusic) then
														hApi.PlaySoundBG(g_channel_world, enterMusic)
													end
												end
												
												talktype_last = 0
											--地图间传送
											elseif tonumber(portalType) == 1 then
												local switchFlag
												--判定是不是玩家的英雄
												for n = 1, #oUnitPlayer.heros do
													if oUnitPlayer.heros[n] == oUnit:gethero() then
														switchFlag = true
														break
													end
												end
												--print("TD_Portal_Loop:10")
												if switchFlag and toMap and (toMap ~= "") then
													--是否层数加1
													--大菠萝，第一次传送才加1
													if (flag == 0) then
														portal.flag = 1
														
														local round = w.data.pvp_round --铜雀台、新手地图层数
														hGlobal.event:event("Event_UpdateGameRound", round + 1)
													end
													local round_ahead = w.data.pvp_round
													--local round_ahead = w.data.pvp_round_ahead --铜雀台、新手地图前置层数（打完boss就可以加1）
													--local round = w.data.pvp_round --铜雀台、新手地图层数
													--if (round < round_ahead) then
													--	hGlobal.event:event("Event_UpdateGameRound", round_ahead)
													--end
													
													--print("TD_Portal_Loop11")
													local mapname = w.data.map
													
													--保存玩家通关信息 并保存通关积分
													local haveLevel = (LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.LEVEL) or 0)
													if haveLevel == 0 then
														LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.LEVEL,1,true)
													end
													
													--记录通关次数
													local finish_count = 0 
													finish_count = (LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.FINISH_COUNT) or 0)
													
													LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.FINISH_COUNT,finish_count+1,true)
													
													--存储大菠萝的垮地图
													LuaSaveDiaboData(oUnit)
													
													--进行一次存档更新
													LuaSaveHeroCard(true)
													LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
													
													--切换前的数据读取
													local session = w.data.session --上一局的session
													local sessionId = w.data.sessionId --上一局的游戏局id
													local timeNow = w:gametime() --当前游戏时长
													local pvp_round = w.data.pvp_round --铜雀台、新手地图层数
													local pos = oUnitPlayer:getpos() --玩家位置
													--local hero_queue_list = w.data.pvp_wheel_hero_queue_list[pos] or {} --玩家铜雀台配置信息表
													local forcePlayer = w:GetForce(force)
													local life = forcePlayer:getresource(hVar.RESOURCE_TYPE.LIFE) or 0 --剩余生命
													local gold = oUnitPlayer:getresource(hVar.RESOURCE_TYPE.GOLD) or 0 --剩余金币
													
													--print("timeNow=", timeNow)
													--print("pos=", pos)
													--print("hero_queue_list=", hero_queue_list)
													--print("force=", force)
													--print("life=", life)
													
													mapInfo.mapState = hVar.MAP_TD_STATE.END
													
													hApi.addTimerOnce("switch_map", 1, function()
														--普通模式、挑战难度模式、无尽模式
														if (mapInfo.mapMode == hVar.MAP_TD_TYPE.NORMAL) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.DIFFICULT) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then
															if hGlobal.WORLD.LastWorldMap then
																hGlobal.WORLD.LastWorldMap:del()
																hGlobal.WORLD.LastWorldMap = nil
																--hApi.debug_floatNumber("hGlobal.WORLD.LastWorldMap = nil 24")
															end
															
															xlScene_LoadMap(g_world, toMap, mapInfo.mapDifficulty, mapInfo.mapMode)
															
															
														elseif (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
															--[[
															--xlScene_LoadMap(scene, name, mapDiff, mapMode, session, banLimitTable)
															xlScene_LoadMap(g_world, toMap, mapInfo.mapDifficulty, mapInfo.mapMode, session)
															]]
															
															--切换前，存储数据
															local tData = {}
															tData.timeNow = timeNow --游戏时间
															tData.pvp_round = pvp_round --轮
															tData.life = life --当前生命
															tData.gold = gold --当前金币
															tData.pos = pos --玩家位置
															tData.hero_queue_list = hero_queue_list --英雄列表
															
															local strData = hApi.serialize(tData)
															
															--发送pvp指令，切换竞技场地图
															SendPvpCmdFunc["switch_pvp_map"](sessionId, toMap, mapInfo.mapDifficulty, mapInfo.mapMode, strData)
														end
													end)
												end
											--战车区域传送
											elseif tonumber(portalType) == 2 then
												local toX, toY = 0, 0
												local regionId = w.data.randommapIdx --当前所在随机地图索引
												local regionDataNext = w.data.randommapInfo[regionId + 1]
												if regionDataNext then
													--传送到已存在的区域id
													toX, toY = hApi.TransportRandomMap(w, regionId + 1)
													
													--触发事件：战车随机地图所在区域变化事件（下一层已存在）
													hGlobal.event:event("Event_RandomMapRegionChanged")
												else
													--[[
													local regionData = w.data.randommapInfo[regionId] --随机地图信息
													local regoin_xl = regionData.regoin_xl --左上角x坐标
													local regoin_yt = regionData.regoin_yt --左上角y坐标
													local regoin_xr = regionData.regoin_xr --右下角x坐标
													local regoin_yb = regionData.regoin_yb --右下角y坐标
													]]
													local tMultiply = hVar.RANDMAP_REGION_POINT_MULTIPLY[regionId + 1]
													if tMultiply then
														local tLink = tMultiply.link
														local regionIdMulty = tLink.regionId --参考区域id
														local regoin_xl = 0 --参考左上角x坐标
														local regoin_yt = 0 --参考左上角y坐标
														local regoin_xr = 0 --参考右下角x坐标
														local regoin_yb = 0 --参考右下角y坐标
														if (regionIdMulty > 0) then
															local regionDataMulty = w.data.randommapInfo[regionIdMulty] --参考随机地图信息
															regoin_xl = regionDataMulty.regoin_xl --参考左上角x坐标
															regoin_yt = regionDataMulty.regoin_yt --参考左上角y坐标
															regoin_xr = regionDataMulty.regoin_xr --参考右下角x坐标
															regoin_yb = regionDataMulty.regoin_yb --参考右下角y坐标
														end
														local fx = tLink.fx --系数x
														local fy = tLink.fy --系数y
														local avatarInfoId = tMultiply.avatarInfoId or 0 --皮肤id
														if (avatarInfoId <= 0) then
															--如果存在上一小关，优先取上一小关的皮肤
															if (regionId > 0) then
																local regionData = w.data.randommapInfo[regionId] --随机地图信息
																avatarInfoId = regionData.avatarInfoId
															else
																avatarInfoId = w:random(1, hVar.RANDMAP_ROOM_AVATAR_INFO.RandRange)
															end
														end
														local random_ObjectInfo = hVar.RANDMAP_ROOM_AVATAR_INFO[avatarInfoId]
														local regionIdNew = hApi.CreateRandomMap(w, random_ObjectInfo, units_list.random_RoomClass, regoin_xr * fx, regoin_yb * fy, regionId + 1, avatarInfoId)
														local bGenerateNormal= true
														local bGenerateBoss = false
														toX, toY = hApi.CreateRandMapEnemys(w, regionIdNew, bGenerateNormal, bGenerateBoss)
														
														--随机地图立即发兵
														hApi.RandomMapRoomSendArmyTimer()
														
														--播放背景音乐
														--背景音乐
														if (enterMusic ~= "") then
															if (hApi.GetPlaySoundBG(g_channel_world) ~= enterMusic) then
																hApi.PlaySoundBG(g_channel_world, enterMusic)
															end
														end
														
														--更新排名（下一小关）
														local bId = 1
														local nStageValue = w.data.randommapStage * 10 + w.data.randommapIdx
														SendCmdFunc["update_billboard_rank"](bId, nStageValue)
														
														--触发事件：战车随机地图所在区域变化事件（下一小关）
														hGlobal.event:event("Event_RandomMapRegionChanged")
													end
												end
												
												--geyachao: 大菠萝瓦力传送
												local rpgunits = w.data.rpgunits
												for u, u_worldC in pairs(rpgunits) do
												--w:enumunit(function(u)
													--print("大菠萝瓦力传送", u.data.name, u.data.id)
													--if (u.data.id == hVar.MY_TANK_FOLLOW_ID) then
													for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
														if (u.data.id == walle_id) then
															--print("TD_Portal_Loop:9",toX, toY)
															--设置位置
															local randPosX = toX + w:random(-12, 12)
															local randPosY = toY + w:random(-12, 12)
															randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 24)
															local bForceSetPos = true
															u:setPos(randPosX, randPosY, nil, bForceSetPos)
															print("大菠萝瓦力传送:", u.data.name, walle_id, randPosX, randPosY)
															
															--将单位身上的眩晕、僵直等状态清空
															local a = u.attr
															a.stun_stack = 0 --眩晕的堆叠层数
															a.suffer_chaos_stack = 0 --混乱的堆叠层数
															a.suffer_blow_stack = 0 --吹风的堆叠层数
															a.suffer_chuanci_stack = 0 --穿刺的堆叠层数
															a.suffer_sleep_stack = 0 --沉睡的堆叠层数
															a.suffer_chenmo_stack = 0 --沉默的堆叠层数
															a.suffer_jinyan_stack = 0 --禁言的堆叠层数（不能普通攻击）
															a.suffer_touming_stack = 0  --透明的堆叠层数（不能碰撞）
															
															--设置ai状态为闲置
															u:setAIState(hVar.UNIT_AI_STATE.IDLE)
															
															--地图内单位传送之后回调函数
															if On_UnitTransport_Special_Event then
																--安全执行
																hpcall(On_UnitTransport_Special_Event, w, round_ahead, u, randPosX, randPosY)
																--On_UnitTransport_Special_Event(w, round_ahead, u, randPosX, randPosY)
															end
														end
													end
												end
											--战车区域传送返回
											elseif tonumber(portalType) == 3 then
												local regionId = w.data.randommapIdx --当前所在随机地图索引
												local regionIdBack = regionId - 1
												if (regionIdBack > 0) then
													local toX, toY = hApi.TransportRandomMap(w, regionIdBack)
													
													--播放背景音乐
													--背景音乐
													if (enterMusic ~= "") then
														if (hApi.GetPlaySoundBG(g_channel_world) ~= enterMusic) then
															hApi.PlaySoundBG(g_channel_world, enterMusic)
														end
													end
													
													--geyachao: 大菠萝瓦力传送
													local rpgunits = w.data.rpgunits
													for u, u_worldC in pairs(rpgunits) do
													--w:enumunit(function(u)
														--if (u.data.id == hVar.MY_TANK_FOLLOW_ID) then
														for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
															if (u.data.id == walle_id) then
																--print("TD_Portal_Loop:9",toX, toY)
																--设置位置
																local randPosX = toX + w:random(-12, 12)
																local randPosY = toY + w:random(-12, 12)
																randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 24)
																local bForceSetPos = true
																u:setPos(randPosX, randPosY, nil, bForceSetPos)
																print("大菠萝瓦力传送返回:", u.data.name, walle_id, randPosX, randPosY)
																
																--将单位身上的眩晕、僵直等状态清空
																local a = u.attr
																a.stun_stack = 0 --眩晕的堆叠层数
																a.suffer_chaos_stack = 0 --混乱的堆叠层数
																a.suffer_blow_stack = 0 --吹风的堆叠层数
																a.suffer_chuanci_stack = 0 --穿刺的堆叠层数
																a.suffer_sleep_stack = 0 --沉睡的堆叠层数
																a.suffer_chenmo_stack = 0 --沉默的堆叠层数
																a.suffer_jinyan_stack = 0 --禁言的堆叠层数（不能普通攻击）
																a.suffer_touming_stack = 0  --透明的堆叠层数（不能碰撞）
																
																--设置ai状态为闲置
																u:setAIState(hVar.UNIT_AI_STATE.IDLE)
																
																--地图内单位传送之后回调函数
																if On_UnitTransport_Special_Event then
																	--安全执行
																	hpcall(On_UnitTransport_Special_Event, w, round_ahead, u, randPosX, randPosY)
																	--On_UnitTransport_Special_Event(w, round_ahead, u, randPosX, randPosY)
																end
															end
														end
													end
													
													--触发事件：战车随机地图所在区域变化事件（上一层）
													hGlobal.event:event("Event_RandomMapRegionChanged")
												end
											--战车区域传送（最后一关）
											elseif tonumber(portalType) == 4 then
												--geyachao: 特别的处理，为了不让玩家不存档就进入下一层，这里检测存档建筑是否存在
												local bEnablePortalNext = true
												
												--检测存档建筑是否存在
												w:enumunit(function(eu)
													if (eu.data.id == 11008) then --找到了
														bEnablePortalNext = false
													end
												end)
												
												--有存档建筑
												if (not bEnablePortalNext) then
													--标记初始是否已经在传送门里（如果初始已经在，需要先出来再进去才能触发传送）
													--避免一直冒字
													portal.bBeginInside = true
													
													--冒字
													--local strText = "请使用运输机送回营救的工程师和战利品" --language
													local strText = hVar.tab_string["__TEXT_RANDOMMAP_PLEASESAVEDATA"] --language
													hUI.floatNumber:new({
														x = hVar.SCREEN.w / 2,
														y = hVar.SCREEN.h / 2,
														align = "MC",
														text = "",
														lifetime = 2000,
														fadeout = -550,
														moveY = 32,
													}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
													
													return
												end
												
												--[[
												local mapnamelist =
												{
													"world/csys_001", "world/csys_001a", "world/csys_001b", "world/csys_001c",
													"world/csys_002", "world/csys_002a", "world/csys_002b",
													"world/csys_003", "world/csys_003a", "world/csys_003b",
													"world/csys_004", "world/csys_004a", "world/csys_004b",
													"world/csys_005", "world/csys_005a", "world/csys_005b",
													"world/csys_006", "world/csys_006a", "world/csys_006b",
												}
												local mapnameIdx = w:random(1, #mapnamelist)
												local mapname = mapnamelist[mapnameIdx]
												local MapDifficulty = 0
												local MapMode = hVar.MAP_TD_TYPE.NORMAL
												--记录本局还未使用的道具技能
												
												local activeskill = {}
												local me = w:GetPlayerMe()
												local oHero = me.heros[1]
												--local typeId = oHero.data.id --英雄类型id
												local itemSkillT = oHero.data.itemSkillT
												if (itemSkillT) then
													for k = hVar.TANKSKILL_EMPTY + 1, #itemSkillT, 1 do
														local activeItemId = itemSkillT[k].activeItemId --主动技能的CD
														local activeItemLv = itemSkillT[k].activeItemLv --主动技能的等级
														local activeItemNum = itemSkillT[k].activeItemNum --主动技能的使用次数
														local activeItemCD = itemSkillT[k].activeItemCD --主动技能的CD
														local activeItemLastCastTime = itemSkillT[k].activeItemLastCastTime --主动技能的上次释放的时间（单位:秒）
														
														--存储
														activeskill[#activeskill+1] = {id = activeItemId, lv = activeItemLv, num = activeItemNum,}
													end
												end
												
												--记录本局武器等级
												local basic_weapon_level = 1
												local oUnit = oHero:getunit()
												if oUnit then
													if (oUnit.data.bind_weapon ~= 0) then
														basic_weapon_level = oUnit.data.bind_weapon.attr.attack[6]
													end
												end
												--print("（非随机地图） basic_weapon_level=", basic_weapon_level)
												
												--记录本局还存在的宠物
												local follow_pet_units = {}
												--geyachao: 大菠萝瓦力传送
												local rpgunits = w.data.rpgunits
												for u, u_worldC in pairs(rpgunits) do
													for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
														if (u.data.id == walle_id) then
															follow_pet_units[#follow_pet_units+1] = {id = u.data.id, lv = u.attr.lv, star = u.attr.star,}
														end
													end
												end
												
												--记录本局营救科学家的数据
												local statistics_rescue_count = w.data.statistics_rescue_count --大菠萝营救的科学家数量(随机关单局数据)
												local statistics_rescue_num = w.data.statistics_rescue_num --大菠萝营救的科学家数量(随机关累加数据)
												local statistics_rescue_costnum = w.data.statistics_rescue_costnum --大菠萝营救的科学家消耗数量
												
												w:del()
												w = nil
												
												--大菠萝数据初始化
												--geyachao: 进入下一关，复用上一局的大菠萝数据（randmap4小关完成后跳转）
												--hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
												hGlobal.LocalPlayer.data.diablodata.activeskill = activeskill --坦克的上一局主动技能
												hGlobal.LocalPlayer.data.diablodata.basic_weapon_level = basic_weapon_level --坦克的上一局的武器等级
												hGlobal.LocalPlayer.data.diablodata.follow_pet_units = follow_pet_units --坦克的上一局的宠物
												hGlobal.LocalPlayer.data.diablodata.statistics_rescue_count = statistics_rescue_count --营救的科学家数量(随机关单局数据)
												hGlobal.LocalPlayer.data.diablodata.statistics_rescue_num = statistics_rescue_num --营救的科学家数量(随机关累加数据)
												hGlobal.LocalPlayer.data.diablodata.statistics_rescue_costnum = statistics_rescue_costnum --营救的科学家消耗数量
												--战术卡信息
												hGlobal.LocalPlayer.data.diablodata.tTacticInfo = nil
												--宝箱信息
												hGlobal.LocalPlayer.data.diablodata.tChestInfo = nil
												--战车生命百分比
												hGlobal.LocalPlayer.data.diablodata.hpRate = nil
												--随机迷宫层数和小关数
												hGlobal.LocalPlayer.data.diablodata.randommapStage = nil
												hGlobal.LocalPlayer.data.diablodata.randommapIdx = nil
												
												xlScene_LoadMap(g_world, mapname, MapDifficulty, MapMode)
												]]
												
												--重新传送至1-1
												local toX, toY = 0, 0
												--[[
												local regionData = w.data.randommapInfo[regionId] --随机地图信息
												local regoin_xl = regionData.regoin_xl --左上角x坐标
												local regoin_yt = regionData.regoin_yt --左上角y坐标
												local regoin_xr = regionData.regoin_xr --右下角x坐标
												local regoin_yb = regionData.regoin_yb --右下角y坐标
												]]
												local tMultiply = hVar.RANDMAP_REGION_POINT_MULTIPLY[1]
												if tMultiply then
													local tLink = tMultiply.link
													local regionIdMulty = tLink.regionId --参考区域id
													local regoin_xl = 0 --参考左上角x坐标
													local regoin_yt = 0 --参考左上角y坐标
													local regoin_xr = 0 --参考右下角x坐标
													local regoin_yb = 0 --参考右下角y坐标
													if (regionIdMulty > 0) then
														local regionDataMulty = w.data.randommapInfo[regionIdMulty] --参考随机地图信息
														regoin_xl = regionDataMulty.regoin_xl --参考左上角x坐标
														regoin_yt = regionDataMulty.regoin_yt --参考左上角y坐标
														regoin_xr = regionDataMulty.regoin_xr --参考右下角x坐标
														regoin_yb = regionDataMulty.regoin_yb --参考右下角y坐标
													end
													local fx = tLink.fx --系数x
													local fy = tLink.fy --系数y
													local avatarInfoId = tMultiply.avatarInfoId or 0 --皮肤id
													if (avatarInfoId <= 0) then
														--新一层
														avatarInfoId = w:random(1, hVar.RANDMAP_ROOM_AVATAR_INFO.RandRange)
													end
													local random_ObjectInfo = hVar.RANDMAP_ROOM_AVATAR_INFO[avatarInfoId]
													--清除前一层的全部物件
													hApi.ClearRandomMap(w, w.data.randommapIdx)
													
													--geyachao: 防止闪退，过会再生成随机迷宫
													hApi.addTimerOnce("__Timer_PortalRandomMap__", 100, function()
														local regionIdNew = hApi.CreateRandomMap(w, random_ObjectInfo, units_list.random_RoomClass, regoin_xr * fx, regoin_yb * fy, 1, avatarInfoId)
														local bGenerateNormal= true
														local bGenerateBoss = false
														toX, toY = hApi.CreateRandMapEnemys(w, regionIdNew, bGenerateNormal, bGenerateBoss)
														
														--随机地图立即发兵
														hApi.RandomMapRoomSendArmyTimer()
														
														--播放背景音乐
														--背景音乐
														if (enterMusic ~= "") then
															if (hApi.GetPlaySoundBG(g_channel_world) ~= enterMusic) then
																hApi.PlaySoundBG(g_channel_world, enterMusic)
															end
														end
														
														--更新排名（下一层）
														local bId = 1
														local nStageValue = w.data.randommapStage * 10 + w.data.randommapIdx
														SendCmdFunc["update_billboard_rank"](bId, nStageValue)
														
														--触发事件：战车随机地图所在区域变化事件（下一层）
														hGlobal.event:event("Event_RandomMapRegionChanged")
													
														--geyachao: 大菠萝瓦力传送
														local rpgunits = w.data.rpgunits
														for u, u_worldC in pairs(rpgunits) do
														--w:enumunit(function(u)
															--print("大菠萝瓦力传送", u.data.name, u.data.id)
															--if (u.data.id == hVar.MY_TANK_FOLLOW_ID) then
															for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
																if (u.data.id == walle_id) then
																	--print("TD_Portal_Loop:9",toX, toY)
																	--设置位置
																	local randPosX = toX + w:random(-12, 12)
																	local randPosY = toY + w:random(-12, 12)
																	randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 24)
																	local bForceSetPos = true
																	u:setPos(randPosX, randPosY, nil, bForceSetPos)
																	print("大菠萝瓦力传送下一层:", u.data.name, walle_id, randPosX, randPosY)
																	
																	--将单位身上的眩晕、僵直等状态清空
																	local a = u.attr
																	a.stun_stack = 0 --眩晕的堆叠层数
																	a.suffer_chaos_stack = 0 --混乱的堆叠层数
																	a.suffer_blow_stack = 0 --吹风的堆叠层数
																	a.suffer_chuanci_stack = 0 --穿刺的堆叠层数
																	a.suffer_sleep_stack = 0 --沉睡的堆叠层数
																	a.suffer_chenmo_stack = 0 --沉默的堆叠层数
																	a.suffer_jinyan_stack = 0 --禁言的堆叠层数（不能普通攻击）
																	a.suffer_touming_stack = 0  --透明的堆叠层数（不能碰撞）
																	
																	--设置ai状态为闲置
																	u:setAIState(hVar.UNIT_AI_STATE.IDLE)
																	
																	--地图内单位传送之后回调函数
																	if On_UnitTransport_Special_Event then
																		--安全执行
																		hpcall(On_UnitTransport_Special_Event, w, round_ahead, u, randPosX, randPosY)
																		--On_UnitTransport_Special_Event(w, round_ahead, u, randPosX, randPosY)
																	end
																end
															end
														end
													end)
												end
											end
										end
									end
								end
							end
						end
					end)
					
					--初始在传送门里，未找到英雄，认为英雄出来了
					if bBeginInside then
						if (not bFindUnit) then
							portal.bBeginInside = false
						end
					end
				end
			end
		end
	end
end

--大菠萝穿越区域
function TD_PassThrough_Loop()
	local w = hGlobal.WORLD.LastWorldMap
	if (not w) then
		return
	end
	
	local mapInfo = w.data.tdMapInfo
	
	if not w or not mapInfo then
		return
	end
	
	--游戏暂停或结束，直接退出
	if mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE then
		return
	end
	
	--如果回合还没开始，退出
	if mapInfo.wave <= 0 then
		return
	end
	
	--print("TD_PassThrough_Loop:1",mapInfo.passthrough)
	
	local d = w.data
	local currenttime = w:gametime()
	
	--传送门逻辑
	if mapInfo.passthrough then
		--print("TD_PassThrough_Loop:2")
		for i = #mapInfo.passthrough, 1, -1 do
			local passthrough = mapInfo.passthrough[i]
			if passthrough then
				local passthroughRadius = passthrough.passthroughRadius --穿越触发半径
				local passthroughWorldX = passthrough.passthroughWorldX --穿越点坐标x
				local passthroughWorldY = passthrough.passthroughWorldY --穿越点坐标y
				local passthroughEffect = passthrough.passthroughEffect --穿越点特效
				local passthroughBeginTime = passthrough.passthroughBeginTime --穿越点开始时间
				local passthroughLastTime = passthrough.passthroughLastTime --穿越点持续时间
				local passthroughToX = passthrough.passthroughToX --穿越点到达坐标x
				local passthroughToY = passthrough.passthroughToY --穿越点到达坐标y
				local passthroughFinishState = passthrough.passthroughFinishState --当前状态(true:在区域里 /false:不在区域里)
				
				--检测生存时间是否到了
				local pasttime = currenttime - passthroughBeginTime
				if (pasttime > passthroughLastTime) then
					--删除特效
					passthroughEffect:del()
					
					--删除此穿越点
					table.remove(mapInfo.passthrough, i)
				end
				
				--检测是否有我方英雄进入穿越区域
				--依次遍历我的英雄
				local me = w:GetPlayerMe()
				if me then
					local heros = me.heros
					if heros then
						for i = 1, #heros, 1 do
							local hero = heros[i]
							local oUnit = hero:getunit()
							if oUnit and (oUnit ~= 0) then
								local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --塔的坐标
								local hero_bx, hero_by, hero_bw, hero_bh = oUnit:getbox() --塔的包围盒
								local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --塔的中心点x位置
								local hero_center_y = hero_y + (hero_by + hero_bh / 2) --塔的中心点y位置
								
								local bInside = hApi.CircleIntersectRect(passthroughWorldX, passthroughWorldY, passthroughRadius, hero_center_x, hero_center_y, hero_bx, hero_by)
								if (bInside ~= passthroughFinishState) then --状态不一致才处理
									--存储
									passthroughFinishState = bInside
									passthrough.passthroughFinishState = bInside
									
									if bInside then --进入区域事件
										--如果目标点可到达，才会穿越（有可能进入boss区域，触发关门出不去）
										local waypoint = xlCha_MoveToGrid(oUnit.handle._c, passthroughToX / 24, passthroughToY / 24, 0, nil)
										if (waypoint[0] > 0) then --寻路成功
											--穿越到目标点周围
											--生成随机坐标
											local randPosX = 0
											local randPosY = 0
											local beginAngle = w:random(1, 360)
											while true do
												local fangle = beginAngle * math.pi / 180 --弧度制
												fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
												--local dx = (passthroughRadius + 100) * math.cos(fangle) --随机偏移值x
												--local dy = (passthroughRadius + 100) * math.sin(fangle) --随机偏移值y
												local dx = (passthroughRadius + 100) * hApi.Math.Cos(beginAngle) --随机偏移值x
												local dy = (passthroughRadius + 100) * hApi.Math.Sin(beginAngle) --随机偏移值y
												dx = math.floor(dx * 100) / 100  --保留2位有效数字，用于同步
												dy = math.floor(dy * 100) / 100  --保留2位有效数字，用于同步
												randPosX = passthroughToX + dx --随机x位置
												randPosY = passthroughToY + dy --随机y位置
												
												--如果此点非障碍，并且可直线到达，那么可生成此穿越点
												local result = xlScene_IsGridBlock(g_world, randPosX / 24, randPosY / 24) --某个坐标是否是障碍
												if (result == 0) then
													local waypoint = xlCha_MoveToGrid(oUnit.handle._c, randPosX / 24, randPosY / 24, 0, nil)
													if (waypoint[0] > 0) then --寻路成功
														--生成完成
														break
													end
												end
												
												--角度自增
												beginAngle = beginAngle + 1
											end
											
											--设置坐标
											oUnit:setPos(randPosX, randPosY)
											
											--将单位身上的眩晕、僵直等状态清空
											local a = oUnit.attr
											a.stun_stack = 0 --眩晕的堆叠层数
											a.suffer_chaos_stack = 0 --混乱的堆叠层数
											a.suffer_blow_stack = 0 --吹风的堆叠层数
											a.suffer_chuanci_stack = 0 --穿刺的堆叠层数
											a.suffer_sleep_stack = 0 --沉睡的堆叠层数
											a.suffer_chenmo_stack = 0 --沉默的堆叠层数
											a.suffer_jinyan_stack = 0 --禁言的堆叠层数（不能普通攻击）
											a.suffer_touming_stack = 0  --透明的堆叠层数（不能碰撞）
											
											--设置ai状态为闲置
											oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
											
											--释放技能
											local wudi_time = 1000 --1秒无敌
											local skillId = 16044 --无敌技能id
											local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
											local gridX, gridY = w:xy2grid(targetX, targetY)
											local tCastParam =
											{
												level = wudi_time, --等级
												--skillTimes = oUnit.data.atkTimes, --普通攻击的次数
											}
											hApi.CastSkill(oUnit, skillId, 0, 100, oUnit, gridX, gridY, tCastParam) --无敌技能
											
											--加个传送特效
											local effect_id = 49 --特效id 402 414 442
											local eff = w:addeffect(effect_id, 1.0 ,nil, randPosX, randPosY + 40) --56
											
											--播放音效
											hApi.PlaySound("recover_hp")
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
end

--大菠萝区域触发
function TD_AreaTrigger_Loop()
	local w = hGlobal.WORLD.LastWorldMap
	
	if (not w) then
		return
	end
	
	local mapInfo = w.data.tdMapInfo
	
	if not w or not mapInfo then
		return
	end
	
	--游戏暂停或结束，直接退出
	if mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE then
		return
	end
	
	--如果回合还没开始，退出
	if mapInfo.wave <= 0 then
		return
	end

	--print("TD_AreaTrigger_Loop:1",mapInfo.areatrigger)

	local d = w.data
	local gametime = w:gametime()
	
	--传送门逻辑
	if mapInfo.areatrigger then
		--print("TD_AreaTrigger_Loop:2")
		for i = 1, #mapInfo.areatrigger do
			local areatrigger = mapInfo.areatrigger[i]
			if areatrigger then
				local areaTriggerRadius = areatrigger.areaTriggerRadius --区域触发半径
				local areaTriggerWorldX = areatrigger.areaTriggerWorldX --区域点坐标x
				local areaTriggerWorldY = areatrigger.areaTriggerWorldY --区域点坐标y
				local areaTriggerEnterCount = areatrigger.areaTriggerEnterCount --进入区域触发次数
				local areaTriggerEnterSkillId = areatrigger.areaTriggerEnterSkillId --进入区域触发技能id
				local areaTriggerEnterMusic = areatrigger.areaTriggerEnterMusic --进入区域触发背景音乐
				local areaTriggerEnterIsBoss = areatrigger.areaTriggerEnterIsBoss --进入区域是否是BOSS
				local areaTriggerLeaveCount = areatrigger.areaTriggerLeaveCount --离开区域触发次数
				local areaTriggerLeaveSkillId = areatrigger.areaTriggerLeaveSkillId --离开区域触发技能id
				local areaTriggerLeaveMusic = areatrigger.areaTriggerLeaveMusic --离开区域触发背景音乐
				
				local areaTriggerFinishState = areatrigger.areaTriggerFinishState --区域触发当前状态(true:在区域里 /false:不在区域里)
				
				local areaTriggerEnterFinishCount = areatrigger.areaTriggerEnterFinishCount --进入区域触发完成的次数
				local areaTriggerLeaveFinishCount = areatrigger.areaTriggerLeaveFinishCount --离开区域触发完成的次数
				
				--print("radius=" .. areaTriggerRadius,"count=" .. areaTriggerCount,"skillId=" .. areaTriggerSkillId, "music=" .. areaTriggerMisic)
				
				--只处理次数未满的
				if (areaTriggerEnterFinishCount < areaTriggerEnterCount) or (areaTriggerLeaveFinishCount < areaTriggerLeaveCount) then
					--依次遍历我的英雄
					local me = w:GetPlayerMe()
					if me then
						local heros = me.heros
						if heros then
							for i = 1, #heros, 1 do
								local hero = heros[i]
								local oUnit = hero:getunit()
								if oUnit and (oUnit ~= 0) then
									local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --塔的坐标
									local hero_bx, hero_by, hero_bw, hero_bh = oUnit:getbox() --塔的包围盒
									local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --塔的中心点x位置
									local hero_center_y = hero_y + (hero_by + hero_bh / 2) --塔的中心点y位置
									
									local bInside = hApi.CircleIntersectRect(areaTriggerWorldX, areaTriggerWorldY, areaTriggerRadius, hero_center_x, hero_center_y, hero_bx, hero_by)
									if (bInside ~= areaTriggerFinishState) then --状态不一致才处理
										--存储
										areaTriggerFinishState = bInside
										areatrigger.areaTriggerFinishState = bInside
										
										if bInside then --进入区域事件
											--标记进入次数
											areaTriggerEnterFinishCount = areaTriggerEnterFinishCount + 1
											areatrigger.areaTriggerEnterFinishCount = areatrigger.areaTriggerEnterFinishCount + 1
											
											--释放进入技能
											if (areaTriggerEnterSkillId > 0) then
												local tCastParam =
												{
													--level = eu.attr.attack[6], --普通攻击的等级
													--skillTimes = eu.data.atkTimes, --普通攻击的次数
												}
												local targetX, targetY = hApi.chaGetPos(oUnit.handle) --位置
												local gridX, gridY = w:xy2grid(areaTriggerWorldX, areaTriggerWorldY)
												hApi.CastSkill(oUnit, areaTriggerEnterSkillId, 0, 100, oUnit, gridX, gridY, tCastParam) --释放技能
											end
											
											--背景音乐
											if (areaTriggerEnterMusic ~= "") then
												if areaTriggerEnterIsBoss == 1 then
													if GameManager.CheckIsGameType(hVar.GameType.SIXBR) == 1 or GameManager.CheckIsGameType(hVar.GameType.RANDBATTLE) == 1 then
														if (hApi.GetPlaySoundBG(g_channel_world) ~= areaTriggerEnterMusic) then
															hGlobal.event:event("LocalEvent_ShowBossWarningFrm")
															hApi.PlaySoundBG(g_channel_world,0)
															hApi.addTimerOnce("playbosssound",4500,function()
																hApi.PlaySoundBG(g_channel_world, areaTriggerEnterMusic)
															end)
														end
													else
														hApi.PlaySoundBG(g_channel_world, areaTriggerEnterMusic)
													end
												else
													hApi.PlaySoundBG(g_channel_world, areaTriggerEnterMusic)
												end
											end
										else --离开区域事件
											--标记离开次数
											areaTriggerLeaveFinishCount = areaTriggerLeaveFinishCount + 1
											areatrigger.areaTriggerLeaveFinishCount = areatrigger.areaTriggerLeaveFinishCount + 1
											
											--释放离开技能
											if (areaTriggerLeaveSkillId > 0) then
												local tCastParam =
												{
													--level = eu.attr.attack[6], --普通攻击的等级
													--skillTimes = eu.data.atkTimes, --普通攻击的次数
												}
												local targetX, targetY = hApi.chaGetPos(oUnit.handle) --位置
												local gridX, gridY = w:xy2grid(areaTriggerWorldX, areaTriggerWorldY)
												hApi.CastSkill(oUnit, areaTriggerLeaveSkillId, 0, 100, oUnit, gridX, gridY, tCastParam) --释放技能
											end
											
											--背景音乐
											if (areaTriggerLeaveMusic ~= "") then
												if (hApi.GetPlaySoundBG(g_channel_world) ~= areaTriggerLeaveMusic) then
													hApi.PlaySoundBG(g_channel_world, areaTriggerLeaveMusic)
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
		end
	end
end

--创建对话
local function __createTalk(talkType, _func, ...)
	local arg = {...}
	local world = hGlobal.WORLD.LastWorldMap
	local mapInfo = world.data.tdMapInfo
	--local vTalk = hApi.InitUnitTalk(mapInfo.godUnit,mapInfo.godUnit,nil,talkType)
	local vTalk = hApi.InitUnitTalk(world:GetPlayerGod():getgod(), world:GetPlayerGod():getgod(), nil, talkType)
	if vTalk then
		hApi.CreateUnitTalk(vTalk,function()
			if _func and type(_func) == "function" then
				_func(unpack(arg))
			end
		end)
	else
		if _func and type(_func) == "function" then
			_func(unpack(arg))
		end
	end
end

--对话结束恢复暂停
local _CancelTalkScript = function()
	hGlobal.event:event("Event_StartPauseSwitch", false)
end

--TD剧情
function TD_TalkScript_Loop()
	local w = hGlobal.WORLD.LastWorldMap
	
	if (not w) then
		return
	end
	
	local mapInfo = w.data.tdMapInfo
	
	if not w or not mapInfo then
		return
	end
	
	--游戏暂停或结束，直接退出
	if mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE then
		return
	end
	
	--如果回合还没开始，退出
	if mapInfo.wave <= 0 then
		return
	end
	
	--已通关本关，不再提示
	local mapname = w.data.map
	local isFinishMap = LuaGetPlayerMapAchi(mapname, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --是否通本关
	if (isFinishMap == 1) then
		return
	end
	
	local talkScript = mapInfo.talkScript
	local talkScriptIdx = mapInfo.talkScriptIdx
	local timeNow = w:gametime()
	if talkScript and talkScriptIdx <= #talkScript and talkScript[talkScriptIdx] then
		local talk = talkScript[talkScriptIdx]
		local beginTime = tonumber(talk[1]) or 0
		local talkKey = talk[2] or ""
		if beginTime > 0 and timeNow >= beginTime and #talkKey > 0 then
			hGlobal.event:event("Event_StartPauseSwitch", true)
			__createTalk(talkKey,_CancelTalkScript)
			mapInfo.talkScriptIdx =  mapInfo.talkScriptIdx + 1
		end
	end
end

--每波怪物死亡后固定清除指定显存
function TD_CollectGarbage_PerWave()
	local w = hGlobal.WORLD.LastWorldMap
	
	if (not w) then
		return
	end
	
	local mapInfo = w.data.tdMapInfo
	
	if not w or not mapInfo then
		return
	end
	
	--游戏暂停或结束，直接退出
	if mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE then
		return
	end
	
	--如果回合还没开始，退出
	if mapInfo.wave <= 0 then
		return
	end
	
	local totalWave = mapInfo.totalWave
	
	for wave = 1, mapInfo.totalWave do
		if (not mapInfo.colectGarbageState[wave]) then
			--print(wave, hApi.IsAllUnitInWaveKilled(wave))
			if hApi.IsAllUnitInWaveKilled(wave) then
				local collectInfo = hVar.MAP_COLLECT_GARBAGE_PERWAVE[w.data.map]
				if collectInfo then
					local cPerWave = collectInfo[wave]
					if cPerWave and type(cPerWave) == "table" then
						for i = 1, #cPerWave do
							--print("cPerWave[".. wave .."]:", cPerWave[i])
							hResource.model:releasePngByKey(cPerWave[i])
							hResource.model:releasePlistByKey(nil,cPerWave[i])
						end
					end
				end
				mapInfo.colectGarbageState[wave] = true
				
				--释放png, plist的纹理缓存
				hApi.ReleasePngTextureCache()
			end
		end
	end
	
end

--TD发兵
function TD_Invasion_Loop()
	local w = hGlobal.WORLD.LastWorldMap
	
	if (not w) then
		return
	end
	
	local mapInfo = w.data.tdMapInfo
	
	if not w or not mapInfo then
		return
	end
	
	--游戏暂停或结束，直接退出
	if mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE then
		return
	end
	
	--如果回合还没开始，退出
	if mapInfo.wave <= 0 then
		return
	end
	
	if mapInfo.mapState == hVar.MAP_TD_STATE.BEGIN then
		--设置当前状态为出兵状态
		mapInfo.mapState = hVar.MAP_TD_STATE.SENDARMY
	end
	
	local oPlayerMe = w:GetPlayerMe()
	local lv = 1
	local diff = w.data.MapDifficulty
	if mapInfo.isMapDiffEnemyLv then
		lv = mapInfo.mapDiffEnemyLv[diff] or 1
		--print("TD_Invasion_Loop lv:",diff,lv)
	end
	
	--遍历所有的出兵点
	for bpTgrId,bpInfo in pairs(mapInfo.beginPointList) do
		--开始波次小于等于总波次，才执行出兵逻辑
		if mapInfo.totalWave >= bpInfo.beginWave then
			--计算当前波次和出兵波次相差几个波次
			local maxWave = mapInfo.wave - bpInfo.beginWave + 1
			
			--循环该起点每个波次的出兵列表
			for i = 1, maxWave do
				local waveInfo = bpInfo.unitPerWave[i]
				local waveNow = bpInfo.beginWave - 1 + i
				local beginStage = bpInfo.beginStage --发兵开始的层数
				local stageNow = w.data.pvp_round --当前层数
				
				--判断是否存在波次信息
				if waveInfo then
					if (waveInfo.beginTime == 0) then
						waveInfo.beginTime = w:gametime()
						
						--第一波出兵特殊判断，如果有延时则直接记录触发时间。否则直接进行出兵
						if (waveInfo.delay > 0) then
							waveInfo.beginTime = w:gametime() + waveInfo.delay
						end
					end
					
					--如果层数未到，重置下一波出兵的时间
					if (stageNow < beginStage) then
						--计算下一波出兵的时间
						local beginTimeDelay = mapInfo.beginTimeDelayPerWave or {}
						mapInfo.nextBeginTime = w:gametime() + (beginTimeDelay[mapInfo.wave + 1] or 0)
					end
					
					--时间到了，层数到了
					if (w:gametime() >= waveInfo.beginTime) and (stageNow >= beginStage) then
						if not waveInfo.unitInfoList or #waveInfo.unitInfoList == 0 then
							mapInfo.sendArmyState[bpTgrId][waveNow] = hVar.MAP_TD_WAVE_STATE.END
						end
						for j = #waveInfo.unitInfoList, 1, -1 do
							local unitSetInfo = waveInfo.unitInfoList[j]
							local nextDelay = unitSetInfo.nextDelay
							local unitSetAllAdd = false
							
							--local wayPoint = mapInfo.pathList[unitSetInfo.path]
							--如果路点不存在，直接删除该出兵组
							--if wayPoint then
								--如果该出兵组初始时间0，则设置时间为当前时间
								if unitSetInfo.beginTime == 0 then
									unitSetInfo.beginTime = w:gametime()
									
									--geyachao: 一个不知道原因的bug。。。。第一次进第一0关，小地图BOSS跟小兵一起出来
									--print(w.data.map)
									if (w.data.map == "world/csys_000") and (i == 3) and (LuaGetPlayerMapAchi(w.data.map, hVar.ACHIEVEMENT_TYPE.BATTLECOUNT) <= 1) then
										unitSetInfo.beginTime = w:gametime() + mapInfo.beginTimeDelayPerWave[i]
									end
								end
								
								--出兵
								if w:gametime() >= unitSetInfo.beginTime then
									local formation = unitSetInfo.formation
									local dType = hVar.TD_DEPLOY_TYPE
									if formation == dType.ONE_POINT_CENTER or formation == dType.ONE_SAME_DISTANCE or formation == dType.ONE_RANDOM_DISTANCE then
										for k = #unitSetInfo.unitList, 1, -1 do
											--出单个怪
											
											--beginPos = {x = beginPosInfo.x, y = beginPosInfo.y,faceTo = beginPosInfo.faceTo,isHide = beginPosInfo.isHide}
											--mapInfo.pathList[unitSetInfo.path]
											local unit = unitSetInfo.unitList[k]
											
											--计算小兵起始点及路点
											--local beginPoint, movePoint = mapInfo.CalculateMovePoint(unitSetInfo.beginPos, wayPoint, formation)
											local beginPoint = hApi.calculateBeginPos(w, unitSetInfo.beginPos, formation, unitSetInfo.path, 1)
											
											--添加角色
											local oUnit = w:addunit(unit.id,unit.owner,nil,nil,beginPoint.faceTo,beginPoint.x,beginPoint.y,nil,nil)
											
											if oUnit then
												--是否为rpgunits
												if oUnit:getowner() and ((oUnit:getowner():getforce() == hVar.FORCE_DEF.SHU) or (oUnit:getowner():getforce() == hVar.FORCE_DEF.NEUTRAL) or (oUnit:getowner():getforce() == hVar.FORCE_DEF.NEUTRAL_ENEMY)) then
													if (oUnit.data.type ~= hVar.UNIT_TYPE.NOT_USED) and (oUnit.data.type ~= hVar.UNIT_TYPE.SCEOBJ) then
														w.data.rpgunits[oUnit] = oUnit:getworldC() --标记是我方单位
													end
												end
												
												--设置隐身
												if beginPoint.isHide and beginPoint.isHide > 0 then
													oUnit:SetYinShenState(1)
												end
												
												--设置角色AI状态
												oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
												--设置角色的路点
												oUnit:setRoadPoint(unitSetInfo.path, formation, 1)
												--设置角色所属波次
												oUnit:setWaveBelong(waveNow)
												
												--如果是我方单位，标记到我方单位表里
												--标记是我方单位
												if (oUnit.data.type == hVar.UNIT_TYPE.HERO) or (oUnit.data.type == hVar.UNIT_TYPE.UNIT) then --只处理英雄和小兵
													local nForceMe = oPlayerMe:getforce() --我的势力
													local oPlayer = oUnit:getowner()
													if (nForceMe == oPlayer:getforce()) or (oPlayer:getforce() == hVar.FORCE_DEF.NEUTRAL) or (oPlayer:getforce() == hVar.FORCE_DEF.NEUTRAL_ENEMY) then
														w.data.rpgunits[oUnit] = oUnit:getworldC() --标记是我方单位
														--print("标记是我方单位1", oUnit.data.id, oUnit.data.name)
													end
												end
												
												--zhenkira 角色出生事件，会在这里面做邪恶的事情（游戏局角色会对该角色使用战术技能卡）
												hGlobal.event:call("Event_UnitBorn",oUnit)
												
												unit.num = unit.num - 1
												if unit.num <= 0 then
													--如果该类型的小兵已经出完，则删除小兵
													table.remove(unitSetInfo.unitList, k)
												end
												
												unitSetInfo.beginTime = unitSetInfo.beginTime + (unitSetInfo.perUnitDelay or 0)
												--print("小兵出生： " .. w:gametime())
												break
											else
												--如果创建角色失败，则直接删除该角色
												table.remove(unitSetInfo.unitList, j)
											end
										end
									elseif formation == dType.THREE_POINT_CENTER or formation == dType.THREE_AVERAGE_CENTER or formation == dType.THREE_SAME_DISTANCE or formation == dType.THREE_RANDOM_DISTANCE then
										
										local enemyNum = 0
										--计算小兵起始点及路点
										--local beginPoint, movePoint = mapInfo.CalculateMovePoint(unitSetInfo.beginPos, wayPoint, formation)
										
										
										while(true) do
											
											local len = #unitSetInfo.unitList
											if #unitSetInfo.unitList <= 0 or enemyNum == 3 then
												unitSetInfo.beginTime = unitSetInfo.beginTime + (unitSetInfo.perUnitDelay or 0)
												break
											end
											
											local unit = unitSetInfo.unitList[#unitSetInfo.unitList]
											enemyNum = enemyNum + 1
											
											local beginPoint = hApi.calculateBeginPos(w, unitSetInfo.beginPos, formation, unitSetInfo.path, enemyNum)
											
											--添加角色
											local oUnit = w:addunit(unit.id,unit.owner,nil,nil,beginPoint.faceTo,beginPoint.x,beginPoint.y,nil,nil)
											
											if oUnit then
												--设置隐身
												if beginPoint.isHide and beginPoint.isHide > 0 then
													oUnit:SetYinShenState(1)
												end
												--设置角色AI状态
												oUnit:setAIState(hVar.UNIT_AI_STATE.IDLE)
												--设置角色的路点
												oUnit:setRoadPoint(unitSetInfo.path, formation, enemyNum)
												--设置角色所属波次
												oUnit:setWaveBelong(waveNow)
												
												--如果是我方单位，标记到我方单位表里
												--标记是我方单位
												if (oUnit.data.type == hVar.UNIT_TYPE.HERO) or (oUnit.data.type == hVar.UNIT_TYPE.UNIT) then --只处理英雄和小兵
													local nForceMe = oPlayerMe:getforce() --我的势力
													local oPlayer = oUnit:getowner()
													if (nForceMe == oPlayer:getforce()) or (oPlayer:getforce() == hVar.FORCE_DEF.NEUTRAL) or (oPlayer:getforce() == hVar.FORCE_DEF.NEUTRAL_ENEMY) then
														w.data.rpgunits[oUnit] = oUnit:getworldC() --标记是我方单位
														--print("标记是我方单位2", oUnit.data.id, oUnit.data.name)
													end
												end
												
												--zhenkira 角色出生事件，会在这里面做邪恶的事情（游戏局角色会对该角色使用战术技能卡）
												hGlobal.event:call("Event_UnitBorn",oUnit)
												
												unit.num = unit.num - 1
												if unit.num <= 0 then
													--如果该类型的小兵已经出完，则删除小兵
													table.remove(unitSetInfo.unitList, k)
												end
											else
												--如果创建角色失败，则直接删除该角色
												enemyNum = enemyNum - 1 --如果添加失败了，数量退一个
												table.remove(unitSetInfo.unitList, j)
											end
										end
									end
									
									if #unitSetInfo.unitList <= 0 then
										table.remove(waveInfo.unitInfoList, j)
										unitSetAllAdd = true
									end
								end
							
							
							if not unitSetAllAdd then
								break
							else
								if (nextDelay > 0) and #waveInfo.unitInfoList > 0 then
									waveInfo.beginTime = waveInfo.beginTime + nextDelay
									break
								elseif #waveInfo.unitInfoList <= 0 then --and mapInfo.wave == waveNow then
									--hGlobal.event:event("LocalEvent_TD_NextWave", false)
									mapInfo.sendArmyState[bpTgrId][waveNow] = hVar.MAP_TD_WAVE_STATE.END
								end
							end
						end
					end
				else
					mapInfo.sendArmyState[bpTgrId][waveNow] = hVar.MAP_TD_WAVE_STATE.END
				end
			end
		end
	end
	
	--如果总时间为0，说明第一波刚开始
	local timeNow = w:gametime()
	if mapInfo.nextBeginTime == 0 then
		local totalWave = mapInfo.totalWave
		local wave = mapInfo.wave
		if (wave < totalWave) then
			
			--计算下一波出兵的时间
			local beginTimeDelay = mapInfo.beginTimeDelayPerWave or {}
			mapInfo.nextBeginTime = timeNow + (beginTimeDelay[wave + 1] or 0)
			print("___________________________________loop["..(wave).."]:".. tostring(mapInfo.nextBeginTime)..",".. tostring(timeNow))
		end
	elseif mapInfo.nextBeginTime > 0 and timeNow >= mapInfo.nextBeginTime then
		local wave = mapInfo.wave
		local totalWave = mapInfo.totalWave
		hGlobal.event:event("LocalEvent_TD_NextWave", false)
	elseif mapInfo.nextBeginTime > 0 and timeNow >= mapInfo.nextBeginTime - mapInfo.nextwaveBtnAppearDelay then --如果大于显示按钮的时间，则显示按钮
		local wave = mapInfo.wave
		local totalWave = mapInfo.totalWave
		if wave < totalWave then
			hGlobal.event:event("LocalEvent_TD_ShowNextWave", mapInfo.nextwaveBtnAppearDelay)
		end
	elseif mapInfo.nextBeginTime > 0 and timeNow < mapInfo.nextBeginTime then
		--如果还没到下一波发兵时间，检测当前波次发兵是否已经全部消灭
		if mapInfo.deathAutoNextWave then
			local wave = mapInfo.wave
			local totalWave = mapInfo.totalWave
			if hApi.IsAllUnitInWaveKilled(wave) then
				hGlobal.event:event("LocalEvent_TD_NextWave", false)
			end
		end
	end
	
	--检测是否全部结束
	local isEnd = true
	for bpTgrId, bpSendArmyState in pairs(mapInfo.sendArmyState) do
		for i = 1, #bpSendArmyState do
			local waveState = bpSendArmyState[i]
			if waveState and waveState == hVar.MAP_TD_WAVE_STATE.BEGIN then
				isEnd = false
				break
			end
		end
	end

	if isEnd then
		mapInfo.mapState = hVar.MAP_TD_STATE.SENDARMYEND
	end
end

local TD_CheckVictoryOrDefeat = function ()
	local ret = false
	
	local w = hGlobal.WORLD.LastWorldMap
	local mapInfo = w.data.tdMapInfo
	
	if not w or not mapInfo then
		return ret
	end
	
	if mapInfo.mapState == hVar.MAP_TD_STATE.END or mapInfo.mapState == hVar.MAP_TD_STATE.PAUSE then
		return ret
	end
	
	--普通塔防模式结算
	if (hVar.IS_DIABOLO_APP == 0) then
		--普通模式、挑战难度模式、无尽模式
		if (mapInfo.mapMode == hVar.MAP_TD_TYPE.NORMAL) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.DIFFICULT) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then
			--检测游戏是否失败
			local life = 0
			local me = w:GetPlayerMe()
			if me then
				local force = me:getforce()
				local forcePlayer = w:GetForce(force)
				if forcePlayer then
					life = forcePlayer:getresource(hVar.RESOURCE_TYPE.LIFE) or 0
				end
			end
			--if (mapInfo.life <= 0) then
			if (life <= 0) then
				mapInfo.mapState = hVar.MAP_TD_STATE.FAILED
				ret = true
			else
				--判定主营是否被击毁
				if mapInfo.gameCamp then
					--检测主营
					local myCamp = mapInfo.gameCamp[1] or {}
					local myCamp1 = mapInfo.gameCamp[0] or {}
					local defeatMe = true
					local defeatMe1 = true
					local enemyCamp = mapInfo.gameCamp[2] or {}
					local defeatEnemy = true
					
					--判断己方主营是否全部被打掉
					for i = 1, #myCamp1 do
						local camp = myCamp1[i]
						if not camp.defeat then
							defeatMe1 = false
							break
						end
					end
					
					--判断己方主营是否全部被打掉
					for i = 1, #myCamp do
						local camp = myCamp[i]
						if not camp.defeat then
							defeatMe = false
							break
						end
					end
					
					--判断敌方主营是否全部被打掉
					for i = 1, #enemyCamp do
						local camp = enemyCamp[i]
						if not camp.defeat then
							defeatEnemy = false
							break
						end
					end
					
					--如果我方被打败了，则游戏失败
					if defeatMe or defeatMe1 then
						mapInfo.mapState = hVar.MAP_TD_STATE.FAILED
						ret = true
					else
						--如果我方没有被打败，则需判定敌方是否被打败
						if defeatEnemy then
							mapInfo.mapState = hVar.MAP_TD_STATE.SUCCESS
							ret = true
						end
					end
				end
				
				--判断逃脱即胜利
				if mapInfo.escapeWin then
					--检测主营
					local myCamp = mapInfo.escapeWin[1] or {}
					local myCamp1 = mapInfo.escapeWin[0] or {}
					local escapeMe = true
					local escapeMe1 = true
					local enemyCamp = mapInfo.escapeWin[2] or {}
					local escapeEnemy = true
					
					--判断己方是否全部逃脱
					for i = 1, #myCamp1 do
						local camp = myCamp1[i]
						if not camp.escape then
							escapeMe1 = false
							break
						end
					end
					
					--判断己方是否全部逃脱
					for i = 1, #myCamp do
						local camp = myCamp[i]
						if not camp.escape then
							escapeMe = false
							break
						end
					end
					
					--判断敌方是否全部逃脱
					for i = 1, #enemyCamp do
						local camp = enemyCamp[i]
						if not camp.escape then
							escapeEnemy = false
							break
						end
					end
					
					--如果我方逃脱了，游戏胜利
					if escapeMe or escapeMe1 then
						mapInfo.mapState = hVar.MAP_TD_STATE.SUCCESS
						ret = true
					else
						--如果我方没有逃脱了，游戏失败
						if escapeEnemy then
							mapInfo.mapState = hVar.MAP_TD_STATE.FAILED
							ret = true
						end
					end
				end
				
				--print("ret:",tostring(ret),mapInfo.mapState)
				
				if not ret and (mapInfo.mapState == hVar.MAP_TD_STATE.SENDARMYEND) then
					--遍历所有敌方角色，如果全部消灭，则游戏胜利
					local isWin = true
					local me = w:GetPlayerMe()
					local myForce = me:getforce()
					w:enumunit(function(eu)
						local euForce = eu:getowner():getforce()
						if (euForce > 0) and (myForce ~= euForce) and (eu.data.IsDead ~= 1) and (eu.attr.hp > 0) then --存在敌方活着的单位
							if (eu.data.type == hVar.UNIT_TYPE.HERO) or (eu.data.type == hVar.UNIT_TYPE.UNIT) then --只处理敌方英雄和敌方小兵
								--print("哪个角色坑爹了，日:name = ".. tostring(eu.data.name)..",uId = "..tostring(eu.__ID)..",xy="..tostring(eu.data.worldX)..","..tostring(eu.data.worldY)..",hp = "..tostring(eu.attr.hp).. ",".. tostring(eu.data.IsDead))
								isWin = false
								--if (eu.data.worldX == -1) then
								--	print(""..aaa)
								--end
							end
						end
					end)
					if isWin then
						mapInfo.mapState = hVar.MAP_TD_STATE.SUCCESS
						ret = true
					end
				end
			end
		--pvp模式
		elseif (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
			
			local me = w:GetPlayerMe()
			local myForce = me:getforce()
			local gameOver = false
			local strResult = ""
			local myEvaluate = ""
			local userdatanum
			
			--初始化游戏结束条件
			local forceLose = {}
			for i = 1, 2 do
				forceLose[i] = 0
			end
			
			local allComputerForce = -1

			--遍历势力方，判定胜负关系情况
			for i = 1, 2 do
				
				--战斗结果数据
				strResult = strResult..i..":"

				--判定1
				--判定是否本方玩家已经全部掉线
				local alloffline = true
				local pList = w:GetAllPlayerInForce(i)
				local allComputer = true
				for n = 1, #pList do
					local p = pList[n]
					if (p:gettype() == 1) then --0空 1玩家 2简单电脑 3中等电脑 4困难电脑 5大师电脑 6专家电脑
						--计算某一势力是否全部是电脑
						allComputer = false
						if not p:getoffline() then
							alloffline = false
							break
						end
					end
				end
				
				
				if allComputer then
					allComputerForce = i
					alloffline = false
				end
				strResult = strResult..(tonumber(alloffline and 1) or 0)..":"
				
				
				--判定2
				--判定生命是否为没了
				local life = 0
				local lifeLower = false
				local forcePlayer = w:GetForce(i)
				if forcePlayer then
					life = forcePlayer:getresource(hVar.RESOURCE_TYPE.LIFE) or 0
				end
				if life <= 0 then
					lifeLower = true
				end

				if allComputer then
					lifeLower = false
				end
				strResult = strResult..(tonumber(lifeLower and 1) or 0)..":"
				
				--判定3
				--判断势力方主营是不是被打掉了
				local defeat = false
				if mapInfo.gameCamp and mapInfo.gameCamp[i] then
					local camp = mapInfo.gameCamp[i]
					defeat = true
					if camp and type(camp) == "table" then
						for i = 1, #camp do
							if not camp[i].defeat then
								defeat = false
								break
							end
						end
					end
					strResult = strResult..(tonumber(defeat and 1) or 0)..":"
				else
					strResult = strResult..(-1)..":"	--标示不是胜利条件
				end
				
				
				local strEvaluate = ""
				local num = 0
				for n = 1, #pList do
					local p = pList[n]
					if p then
						if not userdatanum then
							userdatanum = p:getuserdatalength()
						end
						for i = 1, userdatanum do
							local userData = (p:getuserdata(i) or 0)
							strEvaluate = strEvaluate .. ":" .. userData
							if p == me then
								myEvaluate = myEvaluate .. ":" .. userData
							end
						end
					else
						--长度改了的话，这里也要改
						strEvaluate = "0:0:0:0:0:0:0:0:0:0"
					end
					num = num + 1
				end
				if not userdatanum then
					userdatanum = 10
				end
				strEvaluate = num .. ":" .. userdatanum .. strEvaluate .. ","
				strResult = strResult .. strEvaluate
				
				--print("strEvaluate:",strEvaluate)
				
				
				forceLose[i] = alloffline or lifeLower or defeat
				
				--如果有势力方失败了，则判定为游戏结束
				if forceLose[i] then
					gameOver = true
					if i == myForce then
						mapInfo.mapState = hVar.MAP_TD_STATE.FAILED
					else
						mapInfo.mapState = hVar.MAP_TD_STATE.SUCCESS
					end
				end
			end
			
			--print("gameover:",gameOver,strResult)
			--平局
			local draw = false
			if not gameOver and (mapInfo.mapState == hVar.MAP_TD_STATE.SENDARMYEND) then
				
				if allComputerForce == -1 then
					--夺塔奇兵
					gameOver = true
					--遍历所有敌方角色，如果全部消灭，则游戏胜利
					w:enumunit(function(eu)
						local euPos = eu:getowner():getpos()
						--print("euPos:",euPos,eu.data.IsDead,eu.attr.hp,eu.data.type,eu.data.name)
						if (euPos == 21 or euPos == 22) and (eu.data.IsDead ~= 1) and (eu.attr.hp > 0) then --存在双方势力的活着的单位
							if (eu.data.type == hVar.UNIT_TYPE.HERO) or (eu.data.type == hVar.UNIT_TYPE.UNIT) then --只处理敌方英雄和敌方小兵
								gameOver = false
							end
						end
					end)
					
					if gameOver then
						draw = true
					end
				else
					--魔龙
					--遍历所有敌方角色，如果全部消灭，则游戏胜利
					local isWin = true
					w:enumunit(function(eu)
						local euForce = eu:getowner():getforce()
						--print("euPos:",euPos,eu.data.IsDead,eu.attr.hp,eu.data.type,eu.data.name)
						if (euForce == allComputerForce) and (eu.data.IsDead ~= 1) and (eu.attr.hp > 0) then --存在双方势力的活着的单位
							if (eu.data.type == hVar.UNIT_TYPE.HERO) or (eu.data.type == hVar.UNIT_TYPE.UNIT) then --只处理敌方英雄和敌方小兵
								isWin = false
							end
						end
					end)
					if isWin then
						local me = w:GetPlayerMe()
						local myForce = me:getforce()
						if myForce ~= allComputerForce then
							mapInfo.mapState = hVar.MAP_TD_STATE.SUCCESS
							gameOver = true
						end
					end
				end
			end
			
			--如果有势力已经失败，则游戏结束，需要判定是不是平局(如果都失败了则是平局)
			if gameOver then
				--local draw = true
				----如果有某方是胜利的，则说明有胜负关系
				--for i = 1, #forceLose do
				--	if not forceLose[i] then
				--		draw = false
				--		break
				--	end
				--end
				if draw then
					mapInfo.mapState = hVar.MAP_TD_STATE.DRAW
				end
				
				--隐藏可能的等待玩家的界面
				hApi.ShowDelayPlayerFrm(0, nil)

				if myEvaluate == "" then
					myEvaluate = userdatanum..":0:0:0:0:0:0:0:0:0:0"
				end
				
				--0赢 1败 2平
				strResult = (mapInfo.mapState - hVar.MAP_TD_STATE.SUCCESS).."|".. (userdatanum..myEvaluate) .. "|"..strResult
				SendPvpCmdFunc["game_end"](w.data.sessionId, strResult)
				
				print("strResult:",strResult)
			end
			
			--如果已经初始化完毕
			--if mapInfo.gameTimeLimit > 0 then
			--	--当前时间
			--	local gameTime = w:gametime()
			--	
			--	--检测游戏时间，若游戏时间到，则直接失败
			--	if gameTime >= mapInfo.gameTimeLimit then
			--		mapInfo.mapState = hVar.MAP_TD_STATE.FAILED
			--		ret = true
			--	else
			--		--检测主营
			--		local myCamp = mapInfo.gameCamp[1]
			--		local myCamp1 = mapInfo.gameCamp[0]
			--		local defeatMe = true
			--		local defeatMe1 = true
			--		local enemyCamp = mapInfo.gameCamp[2]
			--		local defeatEnemy = true
			--		
			--		--判断己方主营是否全部被打掉
			--		for i = 1, #myCamp1 do
			--			local camp = myCamp1[i]
			--			if not camp.defeat then
			--				defeatMe1 = false
			--				break
			--			end
			--		end
			--		
			--		--判断己方主营是否全部被打掉
			--		for i = 1, #myCamp do
			--			local camp = myCamp[i]
			--			if not camp.defeat then
			--				defeatMe = false
			--				break
			--			end
			--		end
			--		
			--		--判断敌方主营是否全部被打掉
			--		for i = 1, #enemyCamp do
			--			local camp = enemyCamp[i]
			--			if not camp.defeat then
			--				defeatEnemy = false
			--				break
			--			end
			--		end
			--		
			--		--如果我方被打败了，则游戏失败
			--		if defeatMe or defeatMe1 then
			--			mapInfo.mapState = hVar.MAP_TD_STATE.FAILED
			--			ret = true
			--		else
			--			--如果我方没有被打败，则需判定敌方是否被打败
			--			if defeatEnemy then
			--				mapInfo.mapState = hVar.MAP_TD_STATE.SUCCESS
			--				ret = true
			--			end
			--		end
			--	end
			--end
		end

	elseif (hVar.IS_DIABOLO_APP == 1) then --大菠萝模式结算
		if (mapInfo.mapMode == hVar.MAP_TD_TYPE.TANKCONFIG) then --配置坦克地图
			ret = false
		else
			--[[
			if not ret and (mapInfo.mapState == hVar.MAP_TD_STATE.SENDARMYEND) then
				--遍历所有敌方角色，如果全部消灭，则游戏胜利
				local isWin = true
				local me = w:GetPlayerMe()
				local myForce = me:getforce()
				w:enumunit(function(eu)
					local euForce = eu:getowner():getforce()
					if (euForce > 0) and (myForce ~= euForce) and (eu.data.IsDead ~= 1) and (eu.attr.hp > 0) then --存在敌方活着的单位
						if (eu.data.type == hVar.UNIT_TYPE.HERO) or (eu.data.type == hVar.UNIT_TYPE.UNIT) then --只处理敌方英雄和敌方小兵
							--print("哪个角色坑爹了，日:name = ".. tostring(eu.data.name)..",uId = "..tostring(eu.__ID)..",xy="..tostring(eu.data.worldX)..","..tostring(eu.data.worldY)..",hp = "..tostring(eu.attr.hp).. ",".. tostring(eu.data.IsDead))
							isWin = false
							--if (eu.data.worldX == -1) then
							--	print(""..aaa)
							--end
						end
					end
				end)
				if isWin then
					mapInfo.mapState = hVar.MAP_TD_STATE.SUCCESS
					ret = true
				end
			end
			]]
			--geyachao: 大菠萝模式改为打赢boss设置胜利
			ret = false
		end
	end
	
	return ret
end

--TD检测游戏是否结束
function TD_CheckGameEnd_Loop()
	local w = hGlobal.WORLD.LastWorldMap
	
	if (not w) then
		return
	end
	
	local mapInfo = w.data.tdMapInfo
	
	if not w or not mapInfo then
		return
	end
	
	--检测游戏胜负
	TD_CheckVictoryOrDefeat()
	
	--普通塔防模式结算
	if (hVar.IS_DIABOLO_APP == 0) then
		local mapState = mapInfo.mapState
		if (mapState == hVar.MAP_TD_STATE.SUCCESS) or (mapState == hVar.MAP_TD_STATE.FAILED) or (mapState == hVar.MAP_TD_STATE.DRAW) then
			--更新游戏状态
			mapInfo.mapState = hVar.MAP_TD_STATE.END
			local bResult = false
			local nResult = 0
			local strResult = "mapFaild"
			if mapState == hVar.MAP_TD_STATE.SUCCESS then
				bResult = true
				nResult = 1
				strResult = "mapSuccess"
			elseif mapState == hVar.MAP_TD_STATE.FAILED then
				bResult = false
				nResult = 0
				strResult = "mapFaild"
			elseif mapState == hVar.MAP_TD_STATE.DRAW then
				bResult = false
				nResult = 2
				strResult = "mapDraw"
			end
			
			if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
				print("pvp游戏结束——————pvp游戏结束———————pvp游戏结束")
				--pvp更新结算数据
				if TD_OnGameOver_PVP then
					TD_OnGameOver_PVP(bResult)
				end
			else
				print("游戏结束——————游戏结束———————游戏结束")
				--更新结算数据
				
				if hVar.MAP_TEST and hVar.MAP_TEST[w.data.map] then
				else
					TD_OnGameOver(bResult)
				end
			end
			local _func = function()
				
				if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
					--print("pvp游戏结束——————pvp游戏结束———————pvp游戏结束")
					--pvp更新结算数据
					--if TD_OnGameOver_PVP then
					--	TD_OnGameOver_PVP(bResult)
					--end
					
					--如果是铜雀台地图
					if (mapInfo.pveHeroMode == 1) then
						--pvp铜雀台刷新界面
						hGlobal.event:event("LocalEvent_GameOver_PVP_Endless", nResult)
					else
						--pvp刷新界面
						hGlobal.event:event("LocalEvent_GameOver_PVP", nResult)
					end
				else
					--print("游戏结束——————游戏结束———————游戏结束")
					----更新结算数据
					
					--if hVar.MAP_TEST and hVar.MAP_TEST[w.data.map] then
					--else
					--	TD_OnGameOver(bResult)
					--end
					
					--播放音乐
					if (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --pvp模式
						--geyachao: pvp不会走进来的。。。
						if bResult then
							--胜利
							hApi.PlaySoundBG(g_channel_battle,0)
							--hApi.PlaySound("battle_win")
							hApi.PlaySound("battle_win")
						else
							--失败
							hApi.PlaySoundBG(g_channel_battle,0)
							--hApi.PlaySound("battle_lose")
							hApi.PlaySound("battle_lose")
						end
					elseif (mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then --无尽地图
						--胜利
						hApi.PlaySoundBG(g_channel_battle,0)
						--hApi.PlaySound("battle_win")
						hApi.PlaySound("win_sound")
					else --一般地图
						if bResult then
							--胜利
							hApi.PlaySoundBG(g_channel_battle,0)
							--hApi.PlaySound("battle_win")
							hApi.PlaySound("win_sound")
						else
							--失败
							hApi.PlaySoundBG(g_channel_battle,0)
							--hApi.PlaySound("battle_lose")
							hApi.PlaySound("game_lose")
						end
					end
					
					--刷新界面
					hGlobal.event:event("LocalEvent_GameOver", nResult)
					
					--触发引导
					hGlobal.event:event("LocalEvent_EnterGuideProgress", w.data.map, w, "world", 3, nResult)
				end
			end
			
			if (mapState == hVar.MAP_TD_STATE.SUCCESS) then --游戏胜利，延时显示界面
				hApi.addTimerOnce("ShowGameOverFrm", 2000, function()
					local w = hGlobal.WORLD.LastWorldMap
					if w then
						--创建对话
						--local vTalk = hApi.InitUnitTalk(mapInfo.godUnit,mapInfo.godUnit,nil,strResult)
						local vTalk = hApi.InitUnitTalk(w:GetPlayerGod():getgod(), w:GetPlayerGod():getgod(), nil, strResult)
						local isFinish = LuaGetPlayerMapAchi(w.data.map,hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
						if vTalk and isFinish == 0 then
							hApi.CreateUnitTalk(vTalk,function()
								if _func and type(_func) == "function" then
									_func()
								end
							end)
						else
							if _func and type(_func) == "function" then
								_func()
							end
						end
					end
				end)
			elseif (mapState == hVar.MAP_TD_STATE.FAILED) or (mapState == hVar.MAP_TD_STATE.DRAW) then --游戏失败，立刻显示界面
				--创建对话
				--local vTalk = hApi.InitUnitTalk(mapInfo.godUnit,mapInfo.godUnit,nil,strResult)
				local vTalk = hApi.InitUnitTalk(w:GetPlayerMe():getgod(),w:GetPlayerMe():getgod(),nil,strResult)
				local isFinish = LuaGetPlayerMapAchi(w.data.map,hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
				if vTalk and isFinish == 0 then
					hApi.CreateUnitTalk(vTalk,function()
						if _func and type(_func) == "function" then
							_func()
						end
					end)
				else
					if _func and type(_func) == "function" then
						_func()
					end
				end
			end
		end
	elseif (hVar.IS_DIABOLO_APP == 1) then --大菠萝模式结算
		local mapState = mapInfo.mapState
		if (mapState == hVar.MAP_TD_STATE.SUCCESS) or (mapState == hVar.MAP_TD_STATE.FAILED) or (mapState == hVar.MAP_TD_STATE.DRAW) then
			--更新游戏状态
			mapInfo.mapState = hVar.MAP_TD_STATE.END
			local bResult = false
			local nResult = 0
			local strResult = "mapFaild"
			if mapState == hVar.MAP_TD_STATE.SUCCESS then
				bResult = true
				nResult = 1
				strResult = "mapSuccess"
			elseif mapState == hVar.MAP_TD_STATE.FAILED then
				bResult = false
				nResult = 0
				strResult = "mapFaild"
			elseif mapState == hVar.MAP_TD_STATE.DRAW then
				bResult = false
				nResult = 2
				strResult = "mapDraw"
			end
			
			--大菠萝游戏结束结算
			GameManager.GameEnd(bResult,nResult,strResult)
			--TD_OnGameOver_Diablo(bResult)
			
			--local bIsSysName = false
			--if (g_curPlayerName ~= nil) then
				----显示名
				--local curMyName = ""
				--local playerInfo = LuaGetPlayerByName(g_curPlayerName)
				--if playerInfo and (playerInfo.showName) then
					--curMyName = playerInfo.showName
				--end
				--if (curMyName == hVar.tab_string["guest"]) or (curMyName == "GUEST") or (curMyName == rgNameSystem) or (curMyName == "") then
					--bIsSysName = true
				--end
			--end
			--local nStage = 0
			--local diablodata = hGlobal.LocalPlayer.data.diablodata --大菠萝数据
			--if diablodata and type(diablodata.randMap) == "table" then
				--local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
				--nStage = tInfo.stage or 1
			--end
			--if bIsSysName and nStage >= 1 then
				--local gameOver_Func = function()
					--hGlobal.event:event("LocalEvent_GameOver_Diablo", nResult)
				--end
				--hApi.CreateModifyInputBox_Diablo(1,2,gameOver_Func)
			--else
				--hGlobal.event:event("LocalEvent_GameOver_Diablo", nResult)
			--end
			--大菠萝游戏结束,刷新界面
			--hGlobal.event:event("LocalEvent_GameOver_Diablo", nResult)
			
			--[[
			hGlobal.UI.MsgBox("You Win",{
				ok = function()
					hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
				end,
				cancel = function()
					hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
				end,
			})
			]]
		end
	end
end

--地图AI初始化
function TD_MapAIInit()
	local w = hGlobal.WORLD.LastWorldMap
	
	if (not w) then
		return
	end
	
	local mapInfo = w.data.tdMapInfo
	
	if not w or not mapInfo then
		return
	end
	
	local mapName = w.data.map
	
	if hVar.MAP_AI[mapName] then
		local func = hVar.MAP_AI[mapName].init
		if func then
			func(w)
		end
	end
end

--TD地图AI
function TD_MapAILoop()
	local w = hGlobal.WORLD.LastWorldMap
	
	if (not w) then
		return
	end
	
	local mapInfo = w.data.tdMapInfo
	
	if not w or not mapInfo then
		return
	end
	
	local mapName = w.data.map
	
	if hVar.MAP_AI[mapName] then
		local func = hVar.MAP_AI[mapName].aiLoop
		if func then
			for i = 1, 20 do
				local player = w.data.PlayerList[i]
				--如果玩家存在并且玩家是电脑
				if player and (player:gettype() >= 2) and (player:gettype() <= 6) then --0空 1玩家 2简单电脑 3中等电脑 4困难电脑 5大师电脑 6专家电脑
					func(w, player)
				end
			end
			
		end
	end
end

--TD地图AI事件监听
function TD_MapAIEventListen()
	local w = hGlobal.WORLD.LastWorldMap
	
	if (not w) then
		return
	end
	
	local mapInfo = w.data.tdMapInfo
	
	if not w or not mapInfo then
		return
	end
	
	local mapName = w.data.map
	
	if hVar.MAP_AI[mapName] then
		local events = hVar.MAP_AI[mapName].events
		for eventName, eventFunc in pairs(events) do
			hGlobal.event:listen(eventName, mapName.."_"..eventName, eventFunc)
		end
	end
end

--TD地图AI事件取消监听
function TD_MapAIEventRemoveListen()
	local w = hGlobal.WORLD.LastWorldMap
	
	if (not w) then
		return
	end
	
	local mapInfo = w.data.tdMapInfo
	
	if not w or not mapInfo then
		return
	end
	
	local mapName = w.data.map
	
	if hVar.MAP_AI[mapName] then
		local events = hVar.MAP_AI[mapName].events
		for eventName, eventFunc in pairs(events) do
			hGlobal.event:listen(eventName, mapName.."_"..eventName, nil)
		end
	end
end

--计算一个目标的权值 {攻击者, 目标, 优先级类型, ...}
local CalculateWeight = function(oUnit, eu, priorityT, worldX, worldY)
	local priorityType = priorityT[1]
	local priorityKey = priorityT[2]
	
	local value = 0 --本次优先级值
	if (priorityType == hVar.AI_PRIORITY.PRI_LOCKED_TARGET) then --优先选择锁定的目标
		if (eu == oUnit.data.lockTarget) then
			value = 1
		end
		--print("PRI_LOCKED_TARGET", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_HERO) then --优先选择英雄
		if (eu.data.type == hVar.UNIT_TYPE.HERO) then
			value = 1
		end
		--print("PRI_HERO", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_UNIT) then --优先选择普通单位
		if (eu.data.type == hVar.UNIT_TYPE.UNIT) then
			value = 1
		end
		--print("PRI_UNIT", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_HERO_UNIT) then --优先选择英雄和普通单位
		if (eu.data.type == hVar.UNIT_TYPE.HERO) or (eu.data.type == hVar.UNIT_TYPE.UNIT) then
			value = 1
		end
	elseif (priorityType == hVar.AI_PRIORITY.PRI_BUILDING) then --优先选择建筑单位
		if (eu.data.type == hVar.UNIT_TYPE.BUILDING) then
			value = 1
		end
		--print("PRI_BUILDING", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_TOWER) then --优先选择塔单位
		if (eu.data.type == hVar.UNIT_TYPE.TOWER) then
			value = 1
		end
		--print("PRI_TOWER", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_UNITBOX) then --优先选择箱子单位
		if (eu.data.type == hVar.UNIT_TYPE.UNITBOX) then
			value = 1
		end
		--print("PRI_UNITBOX", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_UNITCAN) then --优先选择汽油桶单位
		if (eu.data.type == hVar.UNIT_TYPE.UNITCAN) then
			value = 1
		end
		--print("PRI_UNITCAN", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_UNITGUN) then --优先选择武器单位
		if (eu.data.type == hVar.UNIT_TYPE.UNITGUN) then
			value = 1
		end
		--print("PRI_UNITGUN", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_UNITBROKEN) then --优先选择可破坏物件单位
		if (eu.data.type == hVar.UNIT_TYPE.UNITBROKEN) then
			value = 1
		end
		--print("PRI_UNITBROKEN", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_UNITBROKEN_HOUSE) then --优先选择可破坏房子单位
		if (eu.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE) then
			value = 1
		end
		--print("UNITBROKEN_HOUSE", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_UNITDOOR) then --优先选择可破坏门单位
		if (eu.data.type == hVar.UNIT_TYPE.UNITDOOR) then
			value = 1
		end
		--print("UNITDOOR", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_NEAREST) then --优先选择最近的单位
		local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --英雄的坐标
		if (worldX ~= nil) and (worldY ~= nil) then --如果传入指定的坐标点，那么以此点为施法计算点
			hero_x = worldX
			hero_y = worldY
		end
		local eu_x, eu_y = hApi.chaGetPos(eu.handle) --小兵的坐标
		local dx = hero_x - eu_x
		local dy = hero_y - eu_y
		local target_distance = math.floor(math.sqrt(dx * dx + dy * dy) * 100) / 100 --距离，保留2位有效数字，用于同步
		
		value = -target_distance
		--print("PRI_NEAREST", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_HIGH_HP) then --优先选择血量最多的
		value = eu.attr.hp
		--print("PRI_HIGH_HP", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_LOW_HP) then --优先选择血量最少的
		value = -eu.attr.hp
		--print("hp low", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_HIGH_HP_RATE) then --优先选择血量百分比最多的
		local hp = eu.attr.hp
		local hpMax = eu:GetHpMax()
		local rate = hp / hpMax * 100
		rate = math.floor(rate * 100) / 100 --保留2位有效数字，用于同步
		value = rate
		--print("PRI_HIGH_HP_RATE", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_LOW_HP_RATE) then --优先选择血量百分比最少的
		local hp = eu.attr.hp
		local hpMax = eu:GetHpMax()
		local rate = hp / hpMax * 100
		rate = math.floor(rate * 100) / 100 --保留2位有效数字，用于同步
		value = -rate
		--print("PRI_LOW_HP_RATE", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_FAST_SPEED) then --优先选择速度最快的
		value = eu:GetMoveSpeed()
		--print("speed max", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_SLOW_SPEED) then --先选择速度最慢的
		value = -eu:GetMoveSpeed()
		--print("speed min", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_BUFF) then --先选择有某种buff的
		--buff的类型
		local buffType = priorityKey
		
		--[[
		--依次遍历目标是否有此buff
		local tt = eu.data["buffs"]
		if tt.index then
			for buff_key, n in pairs(tt.index) do
				if n and (n ~= 0) then
					local oID = tt[n]
					local oBuff = hClass.action:find(oID)
					if oBuff then --目标身上已有此buff
						local buffId = oBuff.data.skillId --buff的技能id
						local tabS = hVar.tab_skill[buffId] --技能表
						local action1 = tabS.action[1] --第一个动作（标识buff类型的）
						if (buffType == action1[1]) then
							value = value + 1 --有一个buff，叠加1
						end
					end
				end
			end
		end
		]]
		local buff_tags = eu.data.buff_tags
		if buff_tags[buffType] then
			value = value + buff_tags[buffType]
		end
		
		--print("buff " .. buffType, eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_NOBUFF) then --先选择没有某种buff的
		--buff的类型
		local buffType = priorityKey
		
		--[[
		--依次遍历目标是否有此buff
		local tt = eu.data["buffs"]
		if tt.index then
			for buff_key, n in pairs(tt.index) do
				if n and (n ~= 0) then
					local oID = tt[n]
					local oBuff = hClass.action:find(oID)
					if oBuff then --目标身上已有此buff
						--local buffId = oBuff.data.skillId --buff的技能id
						--local tabS = hVar.tab_skill[buffId] --技能表
						--local action1 = tabS.action[1] --第一个动作（标识buff类型的）
						--if (buffType == action1[1]) then
						--	value = value - 1 --有一个buff，自减1
						--end
						local _ac = oBuff.data.action
						if _ac and (_ac ~= 0) then
							local action1 = _ac[1]
							if (buffType == action1[1]) then
								value = value - 1 --有一个buff，自减1
							end
						end
					end
				end
			end
		end
		]]
		local buff_tags = eu.data.buff_tags
		if buff_tags[buffType] then
			value = value - buff_tags[buffType]
		end
		
		--print("nobuff " .. buffType, eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_FLY_UNIT) then --优先选择飞行单位
		value = eu:GetSpaceType() --单位的空间类型（0:地面单位 / 1:空中单位）
		--print("fly unit", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_GROUND_UNIT) then --优先选择地面单位
		value = -eu:GetSpaceType() --单位的空间类型（0:地面单位 / 1:空中单位）
		--print("ground unit", eu.data.name .. "_" .. eu.__ID, value)
	elseif (priorityType == hVar.AI_PRIORITY.PRI_NO_BLOCK) then --优先选择两者之间没有障碍的单位
		local ex, ey = hApi.chaGetPos(eu.handle)
		local ebx, eby, ebw, ebh = eu:getbox()
		local ecenter_x = ex + (ebx + ebw / 2)
		local ecenter_y = ey + (eby + ebh / 2)
		local ux, uy = hApi.chaGetPos(oUnit.handle)
		local ubx, uby, ubw, ubh = oUnit:getbox() --英雄的坐标
		local ucenter_x = ux + (ubx + ubw / 2)
		local ucenter_y = uy + (uby + ubh / 2)
		local eu_x, eu_y = hApi.chaGetPos(eu.handle) --小兵的坐标
		local IsBolck = hApi.IsPathBlock(ucenter_x, ucenter_y, ecenter_x, ecenter_y)
		
		value = -IsBolck --是否有障碍
		--print("ground unit", eu.data.name .. "_" .. eu.__ID, value)
	end
	
	--[[
	--geyachao: 同步日志: 权重
	if (hVar.IS_SYNC_LOG == 1) then
		local msg = "CalculateWeight: oUnit=" .. oUnit.data.id .. ",u_ID=" .. oUnit:getworldC() .. ",oTarget=" .. eu.data.id .. ",t_ID=" .. eu:getworldC() .. ",priorityType=" .. priorityType .. ",value=" .. value
		hApi.SyncLog(msg)
	end
	]]
	
	return value
end

--塔和建筑的普通攻击搜敌函数（以目标的box来检测是否相交）
local SearchFunc_AttackTower = function(eu, oUnit)
	local skill_id = oUnit.attr.attack[1] --普通攻击id
	local type_id = oUnit.data.id --单位类型id
	--local tabU = hVar.tab_unit[type_id]
	--local tabS = hVar.tab_skill[skill_id]
	
	--不存在AI表，默认攻击最近的敌人
	local AI_priorityList_ex = oUnit.attr.AI_priorityList_ex
	
	local validTargetList = oUnit.handle.validTargetList  --所有符合条件的目标列表 --geyachao: 优化内存
	
	--如果目标死亡，直接返回
	if (eu.attr.hp <= 0) then
		return
	end
	
	--检测技能是否能对目标施法
	if (hApi.IsSkillTargetValid(oUnit, eu, skill_id) ~= hVar.RESULT_SUCESS) then
		return
	end
	
	--目标物理免疫，物理技能不能搜到目标
	if (eu.attr.immue_physic_stack > 0) and (oUnit.attr.DamageType == 1) then
		return
	end
	
	--目标法术免疫，法术技能不能搜到目标
	if (eu.attr.immue_magic_stack > 0) and (oUnit.attr.DamageType == 2) then
		return
	end
	
	--目标无敌，任何技能不能搜到目标
	if (eu.attr.immue_wudi_stack > 0) then
		return
	end
	
	--目标沉睡，任何技能不能搜到目标
	if (eu.attr.suffer_sleep_stack > 0) then
		return
	end
	
	--目标隐身，指向性技能不能搜到目标
	local yinshen_state = eu:GetYinShenState() --是否在隐身状态
	if (yinshen_state == 1) then
		return
	end
	
	--检测攻击者可攻击的空间的类型和目标的空间类型
	local unit_atk_space_type = oUnit.attr.atk_space_type --攻击者可攻击的空间的类型
	if (unit_atk_space_type ~= hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL) then --如果攻击者可攻击目标的空间的类型不是全部类型都可以的话，再进一步检测
		local target_space_type = eu:GetSpaceType() --目标的空间类型
		
		--攻击者只能攻击地面单位，而目标是空中单位，那么直接返回
		if (unit_atk_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_GROUND) and (target_space_type == hVar.UNIT_SPACE_TYPE.SPACE_FLY) then
			return
		end
		
		--攻击者只能攻击空中单位，而目标是地面单位，那么直接返回
		if (unit_atk_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_FLY) and (target_space_type == hVar.UNIT_SPACE_TYPE.SPACE_GROUND) then
			return
		end
	end
	
	--判断距离
	--取施法者的中心位置
	local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --塔的坐标
	--[[
	local hero_bx, hero_by, hero_bw, hero_bh = oUnit:getbox() --塔的包围盒
	local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --塔的中心点x位置
	local hero_center_y = hero_y + (hero_by + hero_bh / 2) --塔的中心点y位置
	]]
	local hero_center_x = hero_x --塔的中心点x位置 --geyachao: 塔也改成脚底板算
	local hero_center_y = hero_y --塔的中心点y位置 --geyachao: 塔也改成脚底板算
	--取目标的中心点位置
	local eu_x, eu_y = hApi.chaGetPos(eu.handle)
	--local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --目标的包围盒
	--local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --目标的中心点x位置
	--local eu_center_y = eu_y + (eu_by + eu_bh / 2) --目标的中心点y位置
	local eu_center_x = eu_x --目标的中心点x位置 --geyachao: 塔也改成脚底板算
	local eu_center_y = eu_y --目标的中心点y位置 --geyachao: 塔也改成脚底板算
	
	--[[
	--判断矩形和圆是否相交
	--超出搜敌范围，直接返回失败
	local atk_radius = oUnit:GetAtkRange() --搜敌半径
	if (not hApi.CircleIntersectRect(hero_center_x, hero_center_y, atk_radius, eu_center_x, eu_center_y, eu_bw, eu_bh)) then --在射程内
		return
	end
	]]
	local atk_radius = oUnit:GetAtkRange() --搜敌半径
	local eu_bw, eu_bh = hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE
	--目标在塔的射程外，返回失败
	if (not hApi.CircleIntersectRect(hero_center_x, hero_center_y, atk_radius, eu_center_x, eu_center_y, eu_bw, eu_bh)) then --在射程内
		return
	end
	
	--判断是否有最小攻击范围
	local atk_radius_min = oUnit:GetAtkRangeMin() --搜敌半径最小值
	if (atk_radius_min > 0) then
		--目标和塔的距离
		local dx = hero_center_x - eu_center_x
		local dy = hero_center_y - eu_center_y
		local eu_distance = math.floor(math.sqrt(dx * dx + dy * dy) * 100) / 100 --搜敌的目标的距离，保留2位有效数字，用于同步
		if (eu_distance < atk_radius_min) then
			return
		end
	end
	
	--符合所有的判断
	--计算优先级
	local newIdx = validTargetList.num + 1
	
	--如果当前的索引值已经超过了最大搜敌数量限制，直接返回
	if (newIdx > hVar.ROLE_SEARCH_MAX) then
		return
	end
	
	local priority = validTargetList[newIdx].priority --优先级值
	if (not AI_priorityList_ex) or (#AI_priorityList_ex == 0) then
		--优先级列表没有填写，说明任何单位都是一样的优先级
		priority[1] = 0
		priority.num = 1
	else
		for i = 1, #AI_priorityList_ex, 1 do
			local priorityType = AI_priorityList_ex[i] --优先级类型
			local value = CalculateWeight(oUnit, eu, priorityType) --本次优先级值
			
			--每个优先级的值
			priority[i] = value
		end
		priority.num = #AI_priorityList_ex
	end
	
	--t.unit: 单位, t.priority:优先级表, t.rand:索引值，用于排序优先级列表都一致的情况
	--table.insert(validTargetList, {unit = eu, priority = priority, rand = world:random(1, 1000)})
	--local newIdx = validTargetList.num + 1
	validTargetList[newIdx].unit = eu
	--validTargetList[newIdx].priority = priority
	validTargetList[newIdx].rand = eu:getworldC()
	
	validTargetList.num = newIdx
end

--AI塔和建筑普通攻击寻找一个有效的目标（塔是按角色的box大小判定的，比角色的判定要大一些）
function AI_tower_search_attack_target(oUnit)
	--如果单位死亡，直接返回
	if (oUnit.attr.hp <= 0) then
		return 0, {num = 0,}
	end
	
	local world = hGlobal.WORLD.LastWorldMap
	local type_id = oUnit.data.id --单位类型id
	
	--local tabU = hVar.tab_unit[type_id]
	
	--不存在tab表项
	--if (not tabU) then
	--	return 0, {num = 0,}
	--end
	
	--不存在tab表项的attr属性
	--if (not tabU.attr) then
	--	return 0, {num = 0,}
	--end
	
	--参数
	--local search_radius = oUnit:GetAtkSearchRange() --搜敌半径
	
	--不存在普通攻击的tab表项
	local skill_id = oUnit.attr.attack[1] --普通攻击id
	if (skill_id == 0) then
		return 0, {num = 0,}
	end
	
	--local tabS = hVar.tab_skill[skill_id]
	--if (not tabS) then
	--	return 0, {num = 0,}
	--end
	
	--所有符合条件的目标列表
	local validTargetList = oUnit.handle.validTargetList --geyachao: 优化内存
	
	--使用前先初始化长度为0
	validTargetList.num = 0
	
	--遍历(validTargetList 表已被改变)
	--world:enumunit(SearchFunc_AttackTower, oUnit)
	--取施法者的中心位置
	local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --塔的坐标
	--local hero_bx, hero_by, hero_bw, hero_bh = oUnit:getbox() --塔的包围盒
	--local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --塔的中心点x位置
	--local hero_center_y = hero_y + (hero_by + hero_bh / 2) --塔的中心点y位置
	local hero_center_x = hero_x --塔的中心点x位置 --geyachao: 塔也改成脚底板算
	local hero_center_y = hero_y --塔的中心点y位置 --geyachao: 塔也改成脚底板算
	local atk_radius = oUnit:GetAtkRange() --搜敌半径
	--world:enumunitArea(hero_center_x, hero_center_y, atk_radius + hVar.AREA_EDGE, SearchFunc_AttackTower, oUnit)
	
	--[[
	--geyachao: 会出现怪卡住不攻击的问题，先注释掉看是否还会卡住？
	--大菠萝搜敌优化; 如果是敌人，那么只搜我方单位
	local unitForce = oUnit:getowner():getforce()
	if (unitForce == hVar.FORCE_DEF.WEI) then
		--遍历我方单位
		local rpgunits = world.data.rpgunits
		for u, u_worldC in pairs(rpgunits) do
			if (u:getworldC() == u_worldC) then
				SearchFunc_AttackTower(u, oUnit)
				--print("塔搜敌优化", oUnit.data.name, u.data.name)
			end
		end
	else
		world:enumunitAreaEnemy(oUnit:getowner():getforce(), hero_center_x, hero_center_y, atk_radius + hVar.AREA_EDGE, SearchFunc_AttackTower, oUnit)
	end
	]]
	world:enumunitAreaEnemy(oUnit:getowner():getforce(), hero_center_x, hero_center_y, atk_radius + hVar.AREA_EDGE, SearchFunc_AttackTower, oUnit)
	
	--排序
	--print()
	--print("sort")
	if (validTargetList.num > 0) then
		--后面的填满
		local priorityNum = validTargetList[1].priority.num
		for i = validTargetList.num + 1, hVar.ROLE_SEARCH_MAX, 1 do
			validTargetList[i].priority.num = priorityNum
			for j = 1, priorityNum, 1 do
				validTargetList[i].priority[j] = -(1000000 + 100 * i + j) --极小值
			end
		end
		
		table.sort(validTargetList, function(ta, tb)
			--lua中table.sort中的第二个参数在相等的情况下必须要返回false，而不能返回true
			
			--依次遍历每个优先级
			for i = 1, ta.priority.num, 1 do
				--print(i, "ta.priority[i] = " .. ta.priority[i])
				--print(i, "tb.priority[i] = " .. tb.priority[i])
				--print(ta.priority.num, tb.priority.num)
				if (ta.priority[i]~= tb.priority[i]) then
					return (ta.priority[i]> tb.priority[i])
				end
			end
			
			--如果所有的优先级都相等，随机排序
			return (ta.rand < tb.rand)
		end)
	end
	
	--print()
	--print("sort result")
	--for i = 1, #validTargetList, 1 do
	--	print("   ", i, validTargetList[i].unit.data.name)
	--end
	
	--print("AI_search_attack_target", oUnit.data.name, (validTargetList.num > 0) and validTargetList[1].unit.data.name .. "_" .. validTargetList[1].unit.__ID or "0")
	--返回第一个角色, 所有有效的角色列表
	return (validTargetList.num > 0) and validTargetList[1].unit or 0, validTargetList
end

--普通攻击搜敌函数（以目标脚底板位置检测）（射程+守卫）
local SearchFunc_Attack = function(eu, oUnit)
	local skill_id = oUnit.attr.attack[1] --普通攻击id
	local type_id = oUnit.data.id --单位类型id
	--local tabU = hVar.tab_unit[type_id]
	--local tabS = hVar.tab_skill[skill_id]
	
	--不存在AI表，默认攻击最近的敌人
	local AI_priorityList_ex = oUnit.attr.AI_priorityList_ex
	--if (not AI_priorityList_ex) then
	--	AI_priorityList_ex = hVar.AI_PRIORITY_DEFAULT --{"PRI_LOCKED_TARGET", "PRI_NEAREST"}
	--end
	
	local validTargetList = oUnit.handle.validTargetList  --所有符合条件的目标列表 --geyachao: 优化内存
	
	--如果目标死亡，直接返回
	if (eu.attr.hp <= 0) then
		return
	end
	
	--不会搜可破坏物件(中立无敌意)(蜀国攻击者)
	if (eu.data.type == hVar.UNIT_TYPE.UNITBROKEN) then
		--[[
		if (eu:getowner():getforce() == hVar.FORCE_DEF.NEUTRAL) then
			return
		end
		if (oUnit:getowner():getforce() == hVar.FORCE_DEF.SHU) then
			return
		end
		]]
		return
	end
	
	--不会搜可破坏房子(中立无敌意)(蜀国攻击者)
	if (eu.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE) then
		--[[
		if (eu:getowner():getforce() == hVar.FORCE_DEF.NEUTRAL) then
			return
		end
		if (oUnit:getowner():getforce() == hVar.FORCE_DEF.SHU) then
			return
		end
		]]
		return
	end
	
	--不会搜汽油桶
	if (eu.data.type == hVar.UNIT_TYPE.UNITCAN) then
		return
	end
	
	--一些特定的单位不会被搜到
	if (eu.data.id == 12220) or (eu.data.id == 12227) then
		return
	end
	
	--检测技能是否能对目标施法
	if (hApi.IsSkillTargetValid(oUnit, eu, skill_id) ~= hVar.RESULT_SUCESS) then
		return
	end
	
	--目标无敌，普通攻击不能搜到目标
	if (eu.attr.immue_wudi_stack > 0) then
		return
	end
	
	--目标沉睡，任何技能不能搜到目标
	if (eu.attr.suffer_sleep_stack > 0) then
		return
	end
	
	--目标隐身，指向性技能不能搜到目标
	local yinshen_state = eu:GetYinShenState() --是否在隐身状态
	if (yinshen_state == 1) then
		return
	end
	
	--检测攻击者可攻击的空间的类型和目标的空间类型
	local unit_atk_space_type = oUnit.attr.atk_space_type --攻击者可攻击的空间的类型
	if (unit_atk_space_type ~= hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL) then --如果攻击者可攻击目标的空间的类型不是全部类型都可以的话，再进一步检测
		local target_space_type = eu:GetSpaceType() --目标的空间类型
		
		--攻击者只能攻击地面单位，而目标是空中单位，那么直接返回
		if (unit_atk_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_GROUND) and (target_space_type == hVar.UNIT_SPACE_TYPE.SPACE_FLY) then
			return
		end
		
		--攻击者只能攻击空中单位，而目标是地面单位，那么直接返回
		if (unit_atk_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_FLY) and (target_space_type == hVar.UNIT_SPACE_TYPE.SPACE_GROUND) then
			return
		end
	end
	
	--判断距离
	--取施法者的中心位置
	--[[
	local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --英雄的坐标
	local hero_bx, hero_by, hero_bw, hero_bh = oUnit:getbox() --英雄的包围盒
	local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --英雄的中心点x位置
	local hero_center_y = hero_y + (hero_by + hero_bh / 2) --英雄的中心点y位置
	]]
	--geyachao: 改为守卫点坐标
	local defend_x, defend_y = oUnit.data.defend_x, oUnit.data.defend_y --守卫初始位置
	local defend_distance_max = oUnit.data.defend_distance_max --最远能到达的距离
	local atk_radius = oUnit:GetAtkRange() --攻击半径
	
	--取目标的中心点位置
	--[[
	local eu_x, eu_y = hApi.chaGetPos(eu.handle)
	local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --目标的包围盒
	local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --目标的中心点x位置
	local eu_center_y = eu_y + (eu_by + eu_bh / 2) --目标的中心点y位置
	--local eu_extra_radius = math.sqrt(eu_bw / 2 * eu_bw / 2 + eu_bh / 2 *eu_bh / 2) --目标额外的攻击距离
	]]
	--geyachao: 改为取脚底板坐标
	local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle)
	local eu_bw, eu_bh = hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE
	--print(defend_x, defend_y, eu_center_x, eu_center_y, defend_distance_max + atk_radius)
	--目标在(守卫半径+攻击半径)外，返回失败
	if (not hApi.CircleIntersectRect(defend_x, defend_y, defend_distance_max + atk_radius, eu_center_x, eu_center_y, eu_bw, eu_bh)) then --在射程内
		return
	end
	
	--如果有最小射程，在最小射程内，不能打到目标
	local atk_radius_min = oUnit:GetAtkRangeMin() --搜敌半径最小值
	if (atk_radius_min > 0) then
		--目标和角色的距离
		local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --英雄的坐标
		local dx = hero_x - eu_center_x
		local dy = hero_y - eu_center_y
		local eu_distance = math.floor(math.sqrt(dx * dx + dy * dy) * 100) / 100 --搜敌的目标的距离，保留2位有效数字，用于同步
		if (eu_distance < atk_radius_min) then
			return
		end
	end
	
	--符合所有的判断
	--计算优先级
	local newIdx = validTargetList.num + 1
	
	--如果当前的索引值已经超过了最大搜敌数量限制，直接返回
	if (newIdx > hVar.ROLE_SEARCH_MAX) then
		return
	end
	
	local priority = validTargetList[newIdx].priority --优先级值
	if (not AI_priorityList_ex) or (#AI_priorityList_ex == 0) then
		--优先级列表没有填写，说明任何单位都是一样的优先级
		priority[1] = 0
		priority.num = 1
	else
		for i = 1, #AI_priorityList_ex, 1 do
			local priorityType = AI_priorityList_ex[i] --优先级类型
			local value = CalculateWeight(oUnit, eu, priorityType) --本次优先级值
			
			--每个优先级的值
			priority[i] = value
		end
		priority.num = #AI_priorityList_ex
	end
	
	--t.unit: 单位, t.priority:优先级表, t.rand:索引值，用于排序优先级列表都一致的情况
	--table.insert(validTargetList, {unit = eu, priority = priority, rand = world:random(1, 1000)})
	--local newIdx = validTargetList.num + 1
	validTargetList[newIdx].unit = eu
	--validTargetList[newIdx].priority = priority
	validTargetList[newIdx].rand = eu:getworldC()
	
	validTargetList.num = newIdx
end

--AI单位（英雄）普通攻击寻找一个有效的目标（射程+守卫）
function AI_search_attack_target(oUnit)
	--如果单位死亡，直接返回
	if (oUnit.attr.hp <= 0) then
		return 0, {num = 0,}
	end
	
	local world = hGlobal.WORLD.LastWorldMap
	local type_id = oUnit.data.id --单位类型id
	--local tabU = hVar.tab_unit[type_id]
	
	--不存在tab表项
	--if (not tabU) then
	--	return 0, {num = 0,}
	--end
	
	--不存在tab表项的attr属性
	--if (not tabU.attr) then
	--	return 0, {num = 0,}
	--end
	
	--参数
	--local search_radius = oUnit:GetAtkSearchRange() --搜敌半径
	
	--不存在普通攻击的tab表项
	local skill_id = oUnit.attr.attack[1] --普通攻击id
	--local tabS = hVar.tab_skill[skill_id]
	--if (not tabS) then
	--	return 0, {num = 0,}
	--end
	if (skill_id == 0) then
		return 0, {num = 0,}
	end
	
	--所有符合条件的目标列表
	local validTargetList = oUnit.handle.validTargetList --geyachao: 优化内存
	
	--使用前先初始化长度为0
	validTargetList.num = 0
	
	--遍历(validTargetList 表已被改变)
	--world:enumunit(SearchFunc_Attack, oUnit)
	local defend_x, defend_y = oUnit.data.defend_x, oUnit.data.defend_y --守卫初始位置
	local defend_distance_max = oUnit.data.defend_distance_max --最远能到达的距离
	local atk_radius = oUnit:GetAtkRange() --攻击半径
	--world:enumunitArea(defend_x, defend_y, defend_distance_max + atk_radius, SearchFunc_Attack, oUnit)
	
	--[[
	--geyachao: 会出现怪卡住不攻击的问题，先注释掉看是否还会卡住？
	--大菠萝搜敌优化; 如果是敌人，那么只搜我方单位
	local unitForce = oUnit:getowner():getforce()
	if (unitForce == hVar.FORCE_DEF.WEI) then
		--遍历我方单位
		local rpgunits = world.data.rpgunits
		for u, u_worldC in pairs(rpgunits) do
			if (u:getworldC() == u_worldC) then
				SearchFunc_Attack(u, oUnit)
				--print("攻击搜敌优化", oUnit.data.name, u.data.name)
			end
		end
	else
		world:enumunitAreaEnemy(oUnit:getowner():getforce(), defend_x, defend_y, defend_distance_max + atk_radius, SearchFunc_Attack, oUnit)
	end
	]]
	world:enumunitAreaEnemy(oUnit:getowner():getforce(), defend_x, defend_y, defend_distance_max + atk_radius, SearchFunc_Attack, oUnit)
	
	--排序
	--print()
	--print("sort")
	if (validTargetList.num > 0) then
		--后面的填满
		local priorityNum = validTargetList[1].priority.num
		for i = validTargetList.num + 1, hVar.ROLE_SEARCH_MAX, 1 do
			validTargetList[i].priority.num = priorityNum
			for j = 1, priorityNum, 1 do
				validTargetList[i].priority[j] = -(1000000 + 100 * i + j) --极小值
			end
		end
		
		table.sort(validTargetList, function(ta, tb)
			--lua中table.sort中的第二个参数在相等的情况下必须要返回false，而不能返回true
			
			--依次遍历每个优先级
			for i = 1, ta.priority.num, 1 do
				--print(i, "ta.priority[i] = " .. ta.priority[i])
				--print(i, "tb.priority[i] = " .. tb.priority[i])
				--print(ta.priority.num, tb.priority.num)
				if (ta.priority[i]~= tb.priority[i]) then
					return (ta.priority[i]> tb.priority[i])
				end
			end
			
			--如果所有的优先级都相等，随机排序
			return (ta.rand < tb.rand)
		end)
	end
	
	--print()
	--print("sort result")
	--for i = 1, #validTargetList, 1 do
	--	print("   ", i, validTargetList[i].unit.data.name)
	--end
	
	--print("AI_search_attack_target", oUnit.data.name, (validTargetList.num > 0) and validTargetList[1].unit.data.name .. "_" .. validTargetList[1].unit.__ID or "0")
	--返回第一个角色, 所有有效的角色列表
	return (validTargetList.num > 0) and validTargetList[1].unit or 0, validTargetList
end

--普通攻击精确搜敌函数（以目标脚底板位置检测）（指定射程）
local SearchFunc_ShootAttack = function(eu, oUnit, radius)
	local skill_id = oUnit.attr.attack[1] --普通攻击id
	local type_id = oUnit.data.id --单位类型id
	--local tabU = hVar.tab_unit[type_id]
	--local tabS = hVar.tab_skill[skill_id]
	
	--不存在AI表，默认攻击最近的敌人
	local AI_priorityList_ex = oUnit.attr.AI_priorityList_ex
	--if (not AI_priorityList_ex) then
	--	AI_priorityList_ex = hVar.AI_PRIORITY_DEFAULT --{"PRI_LOCKED_TARGET", "PRI_NEAREST"}
	--end
	
	local validTargetList = oUnit.handle.validTargetList  --所有符合条件的目标列表 --geyachao: 优化内存
	
	--如果目标死亡，直接返回
	if (eu.attr.hp <= 0) then
		return
	end
	
	--检测技能是否能对目标施法
	if (hApi.IsSkillTargetValid(oUnit, eu, skill_id) ~= hVar.RESULT_SUCESS) then
		return
	end
	
	--目标无敌，普通攻击不能搜到目标
	if (eu.attr.immue_wudi_stack > 0) then
		return
	end
	
	--目标沉睡，任何技能不能搜到目标
	if (eu.attr.suffer_sleep_stack > 0) then
		return
	end
	
	--目标隐身，指向性技能不能搜到目标
	local yinshen_state = eu:GetYinShenState() --是否在隐身状态
	if (yinshen_state == 1) then
		return
	end
	
	--检测攻击者可攻击的空间的类型和目标的空间类型
	local unit_atk_space_type = oUnit.attr.atk_space_type --攻击者可攻击的空间的类型
	if (unit_atk_space_type ~= hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL) then --如果攻击者可攻击目标的空间的类型不是全部类型都可以的话，再进一步检测
		local target_space_type = eu:GetSpaceType() --目标的空间类型
		
		--攻击者只能攻击地面单位，而目标是空中单位，那么直接返回
		if (unit_atk_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_GROUND) and (target_space_type == hVar.UNIT_SPACE_TYPE.SPACE_FLY) then
			return
		end
		
		--攻击者只能攻击空中单位，而目标是地面单位，那么直接返回
		if (unit_atk_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_FLY) and (target_space_type == hVar.UNIT_SPACE_TYPE.SPACE_GROUND) then
			return
		end
	end
	
	--判断距离
	--取施法者的中心位置
	--[[
	local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --英雄的坐标
	local hero_bx, hero_by, hero_bw, hero_bh = oUnit:getbox() --英雄的包围盒
	local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --英雄的中心点x位置
	local hero_center_y = hero_y + (hero_by + hero_bh / 2) --英雄的中心点y位置
	]]
	--geyachao: 改为守卫点坐标
	--local defend_x, defend_y = oUnit.data.defend_x, oUnit.data.defend_y --守卫初始位置
	local defend_x, defend_y = hApi.chaGetPos(oUnit.handle) --英雄的坐标
	--local defend_distance_max = oUnit.data.defend_distance_max --最远能到达的距离
	--local atk_radius = oUnit:GetAtkRange() --攻击半径
	
	--取目标的中心点位置
	--[[
	local eu_x, eu_y = hApi.chaGetPos(eu.handle)
	local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --目标的包围盒
	local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --目标的中心点x位置
	local eu_center_y = eu_y + (eu_by + eu_bh / 2) --目标的中心点y位置
	--local eu_extra_radius = math.sqrt(eu_bw / 2 * eu_bw / 2 + eu_bh / 2 *eu_bh / 2) --目标额外的攻击距离
	]]
	--geyachao: 改为取脚底板坐标
	local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle)
	local eu_bw, eu_bh = hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE
	--print(defend_x, defend_y, eu_center_x, eu_center_y, defend_distance_max + atk_radius)
	--目标在(守卫半径+攻击半径)外，返回失败
	if (not hApi.CircleIntersectRect(defend_x, defend_y, radius, eu_center_x, eu_center_y, eu_bw, eu_bh)) then --在射程内
		return
	end
	
	--符合所有的判断
	--计算优先级
	local newIdx = validTargetList.num + 1
	
	--如果当前的索引值已经超过了最大搜敌数量限制，直接返回
	if (newIdx > hVar.ROLE_SEARCH_MAX) then
		return
	end
	
	local priority = validTargetList[newIdx].priority --优先级值
	if (not AI_priorityList_ex) or (#AI_priorityList_ex == 0) then
		--优先级列表没有填写，说明任何单位都是一样的优先级
		priority[1] = 0
		priority.num = 1
	else
		for i = 1, #AI_priorityList_ex, 1 do
			local priorityType = AI_priorityList_ex[i] --优先级类型
			local value = CalculateWeight(oUnit, eu, priorityType) --本次优先级值
			
			--每个优先级的值
			priority[i] = value
		end
		priority.num = #AI_priorityList_ex
	end
	
	--t.unit: 单位, t.priority:优先级表, t.rand:索引值，用于排序优先级列表都一致的情况
	--table.insert(validTargetList, {unit = eu, priority = priority, rand = world:random(1, 1000)})
	--local newIdx = validTargetList.num + 1
	validTargetList[newIdx].unit = eu
	--validTargetList[newIdx].priority = priority
	validTargetList[newIdx].rand = eu:getworldC()
	
	validTargetList.num = newIdx
end

--AI单位（英雄）普通攻击寻找一个精确的目标（指定射程）
function AI_search_attack_shoot_target(oUnit, radius)
	--如果单位死亡，直接返回
	if (oUnit.attr.hp <= 0) then
		return 0, {num = 0,}
	end
	
	local world = hGlobal.WORLD.LastWorldMap
	local type_id = oUnit.data.id --单位类型id
	--local tabU = hVar.tab_unit[type_id]
	
	--不存在tab表项
	--if (not tabU) then
	--	return 0, {num = 0,}
	--end
	
	--不存在tab表项的attr属性
	--if (not tabU.attr) then
	--	return 0, {num = 0,}
	--end
	
	--参数
	--local search_radius = oUnit:GetAtkSearchRange() --搜敌半径
	
	--不存在普通攻击的tab表项
	local skill_id = oUnit.attr.attack[1] --普通攻击id
	--local tabS = hVar.tab_skill[skill_id]
	--if (not tabS) then
	--	return 0, {num = 0,}
	--end
	if (skill_id == 0) then
		return 0, {num = 0,}
	end
	
	--所有符合条件的目标列表
	local validTargetList = oUnit.handle.validTargetList --geyachao: 优化内存
	
	--使用前先初始化长度为0
	validTargetList.num = 0
	
	--遍历(validTargetList 表已被改变)
	--world:enumunit(SearchFunc_ShootAttack, oUnit, radius)
	local ux, uy = hApi.chaGetPos(oUnit.handle) --单位的坐标
	--world:enumunitArea(ux, uy, radius, SearchFunc_ShootAttack, oUnit, radius)
	
	--[[
	--geyachao: 会出现怪卡住不攻击的问题，先注释掉看是否还会卡住？
	--大菠萝搜敌优化; 如果是敌人，那么只搜我方单位
	local unitForce = oUnit:getowner():getforce()
	if (unitForce == hVar.FORCE_DEF.WEI) then
		--遍历我方单位
		local rpgunits = world.data.rpgunits
		for u, u_worldC in pairs(rpgunits) do
			if (u:getworldC() == u_worldC) then
				SearchFunc_ShootAttack(u, oUnit, radius)
				--print("精准攻击搜敌优化", oUnit.data.name, u.data.name)
			end
		end
	else
		world:enumunitAreaEnemy(oUnit:getowner():getforce(), ux, uy, radius, SearchFunc_ShootAttack, oUnit, radius)
	end
	]]
	world:enumunitAreaEnemy(oUnit:getowner():getforce(), ux, uy, radius, SearchFunc_ShootAttack, oUnit, radius)
	
	--排序
	--print()
	--print("sort")
	if (validTargetList.num > 0) then
		--后面的填满
		local priorityNum = validTargetList[1].priority.num
		for i = validTargetList.num + 1, hVar.ROLE_SEARCH_MAX, 1 do
			validTargetList[i].priority.num = priorityNum
			for j = 1, priorityNum, 1 do
				validTargetList[i].priority[j] = -(1000000 + 100 * i + j) --极小值
			end
		end
		
		table.sort(validTargetList, function(ta, tb)
			--lua中table.sort中的第二个参数在相等的情况下必须要返回false，而不能返回true
			
			--依次遍历每个优先级
			for i = 1, ta.priority.num, 1 do
				--print(i, "ta.priority[i] = " .. ta.priority[i])
				--print(i, "tb.priority[i] = " .. tb.priority[i])
				--print(ta.priority.num, tb.priority.num)
				if (ta.priority[i]~= tb.priority[i]) then
					return (ta.priority[i]> tb.priority[i])
				end
			end
			
			--如果所有的优先级都相等，随机排序
			return (ta.rand < tb.rand)
		end)
	end
	
	--print()
	--print("sort result")
	--for i = 1, #validTargetList, 1 do
	--	print("   ", i, validTargetList[i].unit.data.name)
	--end
	
	--print("AI_search_attack_target", oUnit.data.name, (validTargetList.num > 0) and validTargetList[1].unit.data.name .. "_" .. validTargetList[1].unit.__ID or "0")
	--返回第一个角色, 所有有效的角色列表
	return ((validTargetList.num > 0) and validTargetList[1].unit or 0), validTargetList
end

--单位（英雄）普通攻击寻找嘲讽目标搜敌函数
local SearchFunc_AttackTaunt = function(eu, oUnit)
	--如果不是嘲讽单位，那么直接返回
	if (eu.attr.is_taunt ~= 1) then
		return
	end
	
	local skill_id = oUnit.attr.attack[1] --普通攻击id
	local type_id = oUnit.data.id --单位类型id
	--local tabU = hVar.tab_unit[type_id]
	--local tabS = hVar.tab_skill[skill_id]
	
	--不存在AI表，默认攻击最近的敌人
	local AI_priorityList_ex = oUnit.attr.AI_priorityList_ex
	--if (not AI_priorityList_ex) then
	--	AI_priorityList_ex = hVar.AI_PRIORITY_DEFAULT --{"PRI_LOCKED_TARGET", "PRI_NEAREST"}
	--end
	
	local validTauntTargetList = oUnit.handle.validTauntTargetList --所有符合条件的目标列表 --geyachao: 优化内存
	
	--如果目标死亡，直接返回
	if (eu.attr.hp <= 0) then
		return
	end
	
	--检测技能是否能对目标施法
	if (hApi.IsSkillTargetValid(oUnit, eu, skill_id) ~= hVar.RESULT_SUCESS) then
		return
	end
	
	--目标无敌，普通攻击不能搜到目标
	if (eu.attr.immue_wudi_stack > 0) then
		return
	end
	
	--目标沉睡，任何技能不能搜到目标
	if (eu.attr.suffer_sleep_stack > 0) then
		return
	end
	
	--目标隐身，指向性技能不能搜到目标
	local yinshen_state = eu:GetYinShenState() --是否在隐身状态
	if (yinshen_state == 1) then
		return
	end
	
	--检测攻击者可攻击的空间的类型和目标的空间类型
	local unit_atk_space_type = oUnit.attr.atk_space_type --攻击者可攻击的空间的类型
	if (unit_atk_space_type ~= hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL) then --如果攻击者可攻击目标的空间的类型不是全部类型都可以的话，再进一步检测
		local target_space_type = eu:GetSpaceType() --目标的空间类型
		
		--攻击者只能攻击地面单位，而目标是空中单位，那么直接返回
		if (unit_atk_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_GROUND) and (target_space_type == hVar.UNIT_SPACE_TYPE.SPACE_FLY) then
			return
		end
		
		--攻击者只能攻击空中单位，而目标是地面单位，那么直接返回
		if (unit_atk_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_FLY) and (target_space_type == hVar.UNIT_SPACE_TYPE.SPACE_GROUND) then
			return
		end
	end
	
	--判断距离
	--取施法者的中心位置
	--[[
	local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --英雄的坐标
	local hero_bx, hero_by, hero_bw, hero_bh = oUnit:getbox() --英雄的包围盒
	local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --英雄的中心点x位置
	local hero_center_y = hero_y + (hero_by + hero_bh / 2) --英雄的中心点y位置
	]]
	--geyachao: 施法者取脚底板坐标
	local hero_center_x, hero_center_y = hApi.chaGetPos(oUnit.handle) --英雄的坐标
	
	--取嘲讽目标的中心点位置
	local eu_x, eu_y = hApi.chaGetPos(eu.handle)
	local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --目标的包围盒
	local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --目标的中心点x位置
	local eu_center_y = eu_y + (eu_by + eu_bh / 2) --目标的中心点y位置
	--local eu_extra_radius = math.sqrt(eu_bw / 2 * eu_bw / 2 + eu_bh / 2 *eu_bh / 2) --目标额外的攻击距离
	
	--判断矩形和圆是否相交
	--超出(搜敌+守卫)范围，直接返回失败
	local atk_radius = oUnit:GetAtkRange() --攻击半径
	local defend_distance_max = oUnit.data.defend_distance_max --最远能到达的距离
	if (not hApi.CircleIntersectRect(hero_center_x, hero_center_y, atk_radius + defend_distance_max, eu_center_x, eu_center_y, eu.attr.taunt_radius * 2, eu.attr.taunt_radius * 2)) then --在射程内
		return
	end
	
	--符合所有的判断
	--计算优先级
	local newIdx = validTauntTargetList.num + 1
	
	--如果当前的索引值已经超过了最大搜敌数量限制，直接返回
	if (newIdx > hVar.ROLE_SEARCH_MAX) then
		return
	end
	
	local priority = validTauntTargetList[newIdx].priority --优先级值
	if (not AI_priorityList_ex) or (#AI_priorityList_ex == 0) then
		--优先级列表没有填写，说明任何单位都是一样的优先级
		priority[1] = 0
		priority.num = 1
	else
		for i = 1, #AI_priorityList_ex, 1 do
			local priorityType = AI_priorityList_ex[i] --优先级类型
			local value = CalculateWeight(oUnit, eu, priorityType) --本次优先级值
			
			--每个优先级的值
			priority[i] = value
		end
		priority.num = #AI_priorityList_ex
	end
	
	--t.unit: 单位, t.priority:优先级表, t.rand:索引值，用于排序优先级列表都一致的情况
	--table.insert(validTauntTargetList, {unit = eu, priority = priority, rand = world:random(1, 1000)})
	--local newIdx = validTauntTargetList.num + 1
	validTauntTargetList[newIdx].unit = eu
	--validTauntTargetList[newIdx].priority = priority
	validTauntTargetList[newIdx].rand = eu:getworldC()
	
	validTauntTargetList.num = newIdx
end

--AI单位（英雄）普通攻击寻找一个嘲讽的角色
function AI_search_attack_taunt_target(oUnit)
	--如果单位死亡，直接返回
	if (oUnit.attr.hp <= 0) then
		return 0, {num = 0,}
	end
	
	local world = hGlobal.WORLD.LastWorldMap
	local type_id = oUnit.data.id --单位类型id
	--local tabU = hVar.tab_unit[type_id]
	
	--不存在tab表项
	--if (not tabU) then
	--	return 0, {num = 0,}
	--end
	
	--不存在tab表项的attr属性
	--if (not tabU.attr) then
	--	return 0, {num = 0,}
	--end
	
	--不存在普通攻击的tab表项
	local skill_id = oUnit.attr.attack[1] --普通攻击id
	--local tabS = hVar.tab_skill[skill_id]
	--if (not tabS) then
	--	return 0, {num = 0,}
	--end
	if (skill_id == 0) then
		return 0, {num = 0,}
	end
	
	--所有符合条件的嘲讽目标列表
	local validTauntTargetList = oUnit.handle.validTauntTargetList --geyachao: 优化内存
	
	--使用前先初始化长度为0
	validTauntTargetList.num = 0
	
	--遍历(validTauntTargetList 表已被改变)
	--world:enumunit(SearchFunc_AttackTaunt, oUnit)
	local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --单位的坐标
	local atk_radius = oUnit:GetAtkRange() --搜敌半径
	local defend_distance_max = oUnit.data.defend_distance_max --最远能到达的距离
	--world:enumunitArea(hero_x, hero_y, atk_radius + defend_distance_max + hVar.AREA_EDGE, SearchFunc_AttackTaunt, oUnit)
	
	--[[
	--geyachao: 会出现怪卡住不攻击的问题，先注释掉看是否还会卡住？
	--大菠萝搜敌优化; 如果是敌人，那么只搜我方单位
	local unitForce = oUnit:getowner():getforce()
	if (unitForce == hVar.FORCE_DEF.WEI) then
		--遍历我方单位
		local rpgunits = world.data.rpgunits
		for u, u_worldC in pairs(rpgunits) do
			if (u:getworldC() == u_worldC) then
				SearchFunc_AttackTaunt(u, oUnit)
				--print("嘲讽搜敌优化", oUnit.data.name, u.data.name)
			end
		end
	else
		world:enumunitAreaEnemy(oUnit:getowner():getforce(), hero_x, hero_y, atk_radius + defend_distance_max + hVar.AREA_EDGE, SearchFunc_AttackTaunt, oUnit)
	end
	]]
	world:enumunitAreaEnemy(oUnit:getowner():getforce(), hero_x, hero_y, atk_radius + defend_distance_max + hVar.AREA_EDGE, SearchFunc_AttackTaunt, oUnit)
	
	--排序
	--print()
	--print("sort")
	if (validTauntTargetList.num > 0) then
		--后面的填满
		local priorityNum = validTauntTargetList[1].priority.num
		for i = validTauntTargetList.num + 1, hVar.ROLE_SEARCH_MAX, 1 do
			validTauntTargetList[i].priority.num = priorityNum
			for j = 1, priorityNum, 1 do
				validTauntTargetList[i].priority[j] = -(1000000 + 100 * i + j) --极小值
			end
		end
		
		table.sort(validTauntTargetList, function(ta, tb)
			--lua中table.sort中的第二个参数在相等的情况下必须要返回false，而不能返回true
			
			--依次遍历每个优先级
			for i = 1, ta.priority.num, 1 do
				--print(i, "ta.priority[i] = " .. ta.priority[i])
				--print(i, "tb.priority[i] = " .. tb.priority[i])
				--print(ta.priority.num, tb.priority.num)
				if (ta.priority[i]~= tb.priority[i]) then
					return (ta.priority[i]> tb.priority[i])
				end
			end
			
			--如果所有的优先级都相等，随机排序
			return (ta.rand < tb.rand)
		end)
	end
	
	--print()
	--print("sort result")
	--for i = 1, #validTargetList, 1 do
	--	print("   ", i, validTauntTargetList[i].unit.data.name)
	--end
	
	--返回第一个角色, 所有有效的角色列表
	--print("返回第一个角色", validTargetList[1] and (validTargetList[1].unit.data.name .. "_" .. validTargetList[1].unit.__ID) or "nil")
	return (validTauntTargetList.num > 0) and validTauntTargetList[1].unit or 0, validTauntTargetList
end

--单位（英雄）技能搜敌函数
local SearchFunc_Skill = function(eu, oUnit, skill_id, worldX, worldY)
	local tabS = hVar.tab_skill[skill_id]
	--local aiParam = tabS.aiParam --AI表
	
	--不存在AI表，默认攻击最近的敌人
	local AI_priorityList_ex = tabS.AI_priorityList_ex
	if (not AI_priorityList_ex) then
		AI_priorityList_ex = hVar.AI_PRIORITY_DEFAULT --{"PRI_LOCKED_TARGET", "PRI_NEAREST"}
	end
	
	--参数
	--local sideList = aiParam.sideList --阵营列表
	--local subTypeList = aiParam.subTypeList --子类型列表
	local search_radius = tabS.AI_search_radius or 100 --自动释放技能的搜敌半径
	--local AI_priorityList_ex = aiParam.AI_priorityList_ex --单位选择优先级列表
	
	--如果目标死亡，直接返回
	if (eu.attr.hp <= 0) then
		return
	end
	
	--技能不能对目标施法，直接返回
	if (hApi.IsSkillTargetValid(oUnit, eu, skill_id) == hVar.RESULT_FAIL) then
		return
	end
	
	--目标无敌，技不能搜到目标
	if (eu.attr.immue_wudi_stack > 0) then
		return
	end
	
	--目标沉睡，任何技能不能搜到目标
	if (eu.attr.suffer_sleep_stack > 0) then
		return
	end
	
	--目标隐身，指向性技能不能搜到目标
	local yinshen_state = eu:GetYinShenState() --是否在隐身状态
	if (yinshen_state == 1) then
		return
	end
	
	--不会搜可破坏物件
	if (eu.data.type == hVar.UNIT_TYPE.UNITBROKEN) then
		--尤达*剧情帮手2
		if (oUnit.data.id ~= 12526) then --剧情图特殊单位可以打可破坏物件
			return
		end
	end
	
	--一些特定的单位不会被搜到
	if (eu.data.id == 12220) or (eu.data.id == 12227) then
		return
	end
	
	--检测施法者的技能可生效的空间的类型和目标的空间类型
	local cast_target_space_type = tabS.cast_target_space_type or hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL --技能可生效的目标的空间类型
	if (cast_target_space_type ~= hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL) then --如果技能可生效目标的空间的类型不是全部类型都可以的话，再进一步检测
		local target_space_type = eu:GetSpaceType() --目标的空间类型
		
		--技能只能生效地面单位，而目标是空中单位，那么直接返回
		if (cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_GROUND) and (target_space_type == hVar.UNIT_SPACE_TYPE.SPACE_FLY) then
			return
		end
		
		--技能只能生效空中单位，而目标是地面单位，那么直接返回
		if (cast_target_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_FLY) and (target_space_type == hVar.UNIT_SPACE_TYPE.SPACE_GROUND) then
			return
		end
	end
	
	local validSkillTargetList = oUnit.handle.validSkillTargetList  --所有符合条件的技能目标列表 --geyachao: 优化内存
	
	--判断距离
	--取施法者的中心位置
	--[[
	local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --英雄的坐标
	local hero_bx, hero_by, hero_bw, hero_bh = oUnit:getbox() --英雄的包围盒
	local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --英雄的中心点x位置
	local hero_center_y = hero_y + (hero_by + hero_bh / 2) --英雄的中心点y位置
	]]
	--geyachao: 改为取脚底板坐标
	local hero_center_x, hero_center_y = hApi.chaGetPos(oUnit.handle) --英雄的坐标
	
	--如果传入了指定的以worldX, wordY为起点，那么用传入的值
	if (worldX ~= nil) and (worldY ~= nil) then
		hero_center_x = worldX
		hero_center_y = worldY
	end
	
	--取目标的中心点位置
	--[[
	local eu_x, eu_y = hApi.chaGetPos(eu.handle)
	local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --目标的包围盒
	local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --目标的中心点x位置
	local eu_center_y = eu_y + (eu_by + eu_bh / 2) --目标的中心点y位置
	--local eu_extra_radius = math.sqrt(eu_bw / 2 * eu_bw / 2 + eu_bh / 2 *eu_bh / 2) --目标额外的攻击距离
	]]
	--geyachao: 改为取脚底板坐标
	local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle)
	local eu_bw, eu_bh = hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE
	
	--判断矩形和圆是否相交
	--超出搜敌范围，直接返回失败
	if (not hApi.CircleIntersectRect(hero_center_x, hero_center_y, search_radius, eu_center_x, eu_center_y, eu_bw, eu_bh)) then --在射程内
		--print("出搜敌范围，直接返回失败", oUnit.data.name .. "_" .. oUnit.__ID, eu.data.name .. "_" .. eu.__ID, skill_id, hero_center_x, hero_center_y, search_radius, eu_center_x, eu_center_y, eu_bw, eu_bh)
		return
	end
	--print("符合所有的判断", oUnit.data.name .. "_" .. oUnit.__ID, eu.data.name .. "_" .. eu.__ID, skill_id, hero_center_x, hero_center_y, search_radius, eu_center_x, eu_center_y, eu_bw, eu_bh)
	
	--符合所有的判断
	--计算优先级
	local newIdx = validSkillTargetList.num + 1
	
	--如果当前的索引值已经超过了最大搜敌数量限制，直接返回
	if (newIdx > hVar.ROLE_SEARCH_MAX) then
		return
	end
	
	local priority = validSkillTargetList[newIdx].priority --优先级值
	if (not AI_priorityList_ex) or (#AI_priorityList_ex == 0) then
		--优先级列表没有填写，说明任何单位都是一样的优先级
		priority[1] = 0
		priority.num = 1
	else
		for i = 1, #AI_priorityList_ex, 1 do
			local priorityType = AI_priorityList_ex[i] --优先级类型
			local value = CalculateWeight(oUnit, eu, priorityType, worldX, worldY) --本次优先级值
			
			--每个优先级的值
			priority[i] = value
		end
		priority.num = #AI_priorityList_ex
	end
	
	--t.unit: 单位, t.priority:优先级表, t.rand:索引值，用于排序优先级列表都一致的情况
	--table.insert(validSkillTargetList, {unit = eu, priority = priority, rand = world:random(1, 1000)})
	--local newIdx = validSkillTargetList.num + 1
	validSkillTargetList[newIdx].unit = eu
	--validSkillTargetList[newIdx].priority = priority
	validSkillTargetList[newIdx].rand = eu:getworldC()
	
	validSkillTargetList.num = newIdx
end

--AI单位（或英雄）释放技能寻找一个有效的目标
--参数(可选): worldX, worldY 技能的施法点
function AI_search_skill_target(oUnit, skill_id, worldX, worldY)
	--如果单位死亡，直接返回
	if (oUnit.attr.hp <= 0) then
		return 0, {num = 0,}
	end
	
	local world = hGlobal.WORLD.LastWorldMap
	local tabS = hVar.tab_skill[skill_id]
	
	--不存在tab表项
	if (not tabS) then
		return 0, {num = 0,}
	end
	
	--不存在AI表
	--local aiParam = tabS.aiParam
	--if (not aiParam) then
	--	return 0, {num = 0,}
	--end
	
	--所有符合条件的技能目标列表
	local validSkillTargetList = oUnit.handle.validSkillTargetList --geyachao: 优化内存
	
	--使用前先初始化长度为0
	validSkillTargetList.num = 0
	
	--遍历(validSkillTargetList 表已被改变)
	--world:enumunit(SearchFunc_Skill, oUnit, skill_id)
	local ux, uy = hApi.chaGetPos(oUnit.handle) --英雄的坐标
	local search_radius = tabS.AI_search_radius or 100 --自动释放技能的搜敌半径
	--world:enumunitArea(ux, uy, search_radius, SearchFunc_Skill, oUnit, skill_id)
	
	--调用的搜敌函数(用于优化)
	local targetType = tabS.target and tabS.target[1]
	local enumunitAreaFunc = nil
	if (targetType == "ALL") then --全部
		enumunitAreaFunc = world.enumunitArea
	elseif (targetType == "SELF") then --自己
		enumunitAreaFunc = world.enumunitAreaAlly
	elseif (targetType == "OTHER") then --非自己
		enumunitAreaFunc = world.enumunitArea
	elseif (targetType == "ALLY_OTHER") or (targetType == "OTHER_ALLY") then --非自己
		enumunitAreaFunc = world.enumunitArea
	elseif (targetType == "ENEMY") then --敌人
		enumunitAreaFunc = world.enumunitAreaEnemy
	elseif (targetType == "ALLY") then --友方
		enumunitAreaFunc = world.enumunitAreaAlly
	elseif (type(targetType) == "number") then --指定id的角色
		enumunitAreaFunc = world.enumunitArea
	else
		--不合法的参数
	end
	
	--[[
	--geyachao: 会出现怪卡住不攻击的问题，先注释掉看是否还会卡住？
	--大菠萝搜敌优化; 如果是敌人，那么只搜我方单位
	local unitForce = oUnit:getowner():getforce()
	if (unitForce == hVar.FORCE_DEF.WEI) and (targetType == "ENEMY") then
		--遍历我方单位
		local rpgunits = world.data.rpgunits
		for u, u_worldC in pairs(rpgunits) do
			if (u:getworldC() == u_worldC) then
				SearchFunc_Skill(u, oUnit, skill_id, worldX, worldY)
				--print("敌人技能搜敌优化", oUnit.data.name, u.data.name)
			end
		end
	elseif (unitForce == hVar.FORCE_DEF.SHU) and (targetType == "ALLY") then
		--遍历我方单位
		local rpgunits = world.data.rpgunits
		for u, u_worldC in pairs(rpgunits) do
			if (u:getworldC() == u_worldC) then
				SearchFunc_Skill(u, oUnit, skill_id, worldX, worldY)
				--print("我方技能搜敌优化", oUnit.data.name, u.data.name)
			end
		end
	else
		if enumunitAreaFunc then
			enumunitAreaFunc(world, oUnit:getowner():getforce(), ux, uy, search_radius, SearchFunc_Skill, oUnit, skill_id, worldX, worldY)
		end
	end
	]]
	if enumunitAreaFunc then
		enumunitAreaFunc(world, oUnit:getowner():getforce(), ux, uy, search_radius, SearchFunc_Skill, oUnit, skill_id, worldX, worldY)
	end
	--world:enumunitAreaEnemy(oUnit:getowner():getforce(), ux, uy, search_radius, SearchFunc_Skill, oUnit, skill_id, worldX, worldY)
	
	--排序
	--print()
	--print("sort")
	if (validSkillTargetList.num > 0) then
		--后面的填满
		local priorityNum = validSkillTargetList[1].priority.num
		for i = validSkillTargetList.num + 1, hVar.ROLE_SEARCH_MAX, 1 do
			validSkillTargetList[i].priority.num = priorityNum
			for j = 1, priorityNum, 1 do
				validSkillTargetList[i].priority[j] = -(1000000 + 100 * i + j) --极小值
			end
		end
		
		table.sort(validSkillTargetList, function(ta, tb)
			--lua中table.sort中的第二个参数在相等的情况下必须要返回false，而不能返回true
			
			--依次遍历每个优先级
			for i = 1, ta.priority.num, 1 do
				--print(i, "ta.priority[i] = " .. ta.priority[i])
				--print(i, "tb.priority[i] = " .. tb.priority[i])
				--print(ta.priority.num, tb.priority.num)
				if (ta.priority[i]~= tb.priority[i]) then
					return (ta.priority[i]> tb.priority[i])
				end
			end
			
			--如果所有的优先级都相等，随机排序
			return (ta.rand < tb.rand)
		end)
	end
	
	--print()
	--print("sort result")
	--for i = 1, #validTargetList, 1 do
	--	print("   ", i, validSkillTargetList[i].unit.data.name)
	--end
	
	--返回第一个角色, 所有有效的角色列表
	--print("返回第一个角色", validTargetList[1] and (validTargetList[1].unit.data.name .. "_" .. validTargetList[1].unit.__ID) or "nil")
	return (validSkillTargetList.num > 0) and validSkillTargetList[1].unit or 0, validSkillTargetList
end

--依次遍历地图上的单位（有路点单位）
--world:enumunit(function(eu)
local enumunit_callback_RoadPoiunt = function(eu)
	local world = hGlobal.WORLD.LastWorldMap
	local regionId = world.data.randommapIdx --地图当前所在小关数
	local subType = eu.data.type --角色子类型
	local currenttime = world:gametime()
	
	--local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
	local aiState = eu:getAIState() --角色的AI状态
	local unitSide = eu:getowner() --角色的控制方
	
	--非上帝
	--if (eu ~= mapInfo.godUnit) then --不是上帝
	if (eu.data.IsDead ~= 1) and (eu.attr.hp > 0) then --活着的单位
		--普通单位、英雄、图腾、武器、塔、建筑
		if (eu.data.type == hVar.UNIT_TYPE.UNIT) or (eu.data.type == hVar.UNIT_TYPE.HERO) or (eu.data.type == hVar.UNIT_TYPE.HERO_TOKEN)
		or (eu.data.type == hVar.UNIT_TYPE.UNITGUN) or (eu.data.type == hVar.UNIT_TYPE.NPC_TALK) or (eu.data.type == hVar.UNIT_TYPE.UNITBOX)
		or (eu.data.type == hVar.UNIT_TYPE.UNITCAN) or (eu.data.type == hVar.UNIT_TYPE.TOWER) or (eu.data.type == hVar.UNIT_TYPE.BUILDING) then
			--大菠萝效率优化
			--随机地图模式，如果当前单位不是本层的，不处理AI
			local regionIdBelong = eu.attr.regionIdBelong
			if (regionIdBelong == 0) or (regionIdBelong == regionId) then
				--if (roadPoint ~= 0) then --有路点
				if (eu:getRoadPointType() ~= hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_NONE) then --有路点
					local aiAttribute = eu:GetAIAttribute() --角色的AI行为
					--print("eu=" .. eu.data.name .. ", aiAttribute=" .. aiAttribute .. ", target=" .. tostring(eu.data.lockTarget))
					if (aiState == hVar.UNIT_AI_STATE.IDLE) then --有路点角色为空闲状态
						local roadPoint = eu:getRoadPoint() --角色的路点
						--检测是否走向下一个路点
						local nextRoad = roadPoint
						--if nextRoad then --还有未走完的路点
						if nextRoad and type(nextRoad) == "table" then --还有未走完的路点
							--设置角色移动状态
							eu:setAIState(hVar.UNIT_AI_STATE.MOVE)
							
							--移动角色（直接移动）
							--hApi.chaMoveTo(eu.handle, nextRoad.x, nextRoad.y)
							--eu:setanimation("walk")
							--大菠萝
							--[[
							--主角是否活着
							local oUnitMe = world:GetPlayerMe().heros[1]:getunit()
							if oUnitMe then
								hApi.UnitMoveToPoint_TD(eu, nextRoad.x, nextRoad.y, false)
							else
								hApi.UnitMoveToPoint_TD(eu, nextRoad.x, nextRoad.y, true)
							end
							]]
							hApi.UnitMoveToPoint_TD(eu, nextRoad.x, nextRoad.y, false)
							--local gridX,gridY = world:xy2grid(nextRoad.x, nextRoad.y)
							--eu:movetogrid(gridX, gridY)
							
							--if eu.sssssssss == nil then
							--	print(eu.data.name .. " move: " .. currenttime)
							--	eu.sssssssss = 1
							--end
							--print("移动 " .. eu.data.name)
						elseif (nextRoad == -1) then --所有的路点都已走完
							--设置角色到达终点状态
							eu:setAIState(hVar.UNIT_AI_STATE.REACHED)
							--print("设置角色到达终点状态", eu.data.name)
						end
					elseif(aiState == hVar.UNIT_AI_STATE.MOVE_ADJUST) then --有路点角色为移动调整状态
						--等待移动到达回调
						--...
					elseif (aiState == hVar.UNIT_AI_STATE.MOVE_CHAOS) then --有路点角色为移动混乱状态（单位无目的乱走）
						--等待移动到达回调
						--...
					elseif (aiState == hVar.UNIT_AI_STATE.MOVE_HOSTAGE_TANK) then --有路点角色为人质移动跟随坦克状态
						--等待移动到达回调
						--...
						elseif (aiState == hVar.UNIT_AI_STATE.MOVE_HOSTAGE_ChAOS) then --有路点角色为人质移动混乱状态（单位无目的乱走）
						--等待移动到达回调
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.MOVE) then --有路点角色为移动状态
						--等移动到达回调
						--...
						
						--隐身单位只会移动，不会攻击别人
						local yinshen_state = eu:GetYinShenState() --是否在隐身状态
						if (yinshen_state == 1) then --隐身单位
							--
						elseif (eu.attr.suffer_touming_stack > 0) then --单位透明，不用主动搜敌攻击
							--
						else --非隐身单位
							if (aiAttribute == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪，检测是否有锁定的目标
								--检测是否有锁定攻击的角色
								local lockTarget = eu.data.lockTarget --小兵锁定攻击的角色
								if (lockTarget == 0) then --如果没有锁定的角色，那么再检查一遍，有没有嘲讽的敌人
									local tauntEnemy = AI_search_attack_taunt_target(eu)
									if (tauntEnemy) and (tauntEnemy ~= 0) then
										hApi.UnitTryToLockTarget(eu, tauntEnemy, 0)
										--eu.data.lockTarget = tauntEnemy --锁定嘲讽的敌人
										lockTarget = tauntEnemy --锁定嘲讽的敌人
										
										--检测嘲讽的目标是否也锁定它
										if (tauntEnemy.data.lockTarget == 0) then
											hApi.UnitTryToLockTarget(tauntEnemy, eu, 0)
											--tauntEnemy.data.lockTarget = eu
											--tauntEnemy.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
											--print("lockType 31", tauntEnemy.data.name, 0)
										end
									end
								end
								
								--存在锁定的目标
								if (lockTarget ~= 0) then
									local attack = eu.attr.attack --小兵攻击力表
									
									--有路点角色有攻击力（这里不用判断是否cd到了）
									if (eu.attr.attack[5] > 0) then
										--检测锁定的英雄在小兵攻击范围内
										--取敌方单位的中心点位置
										--[[
										local eu_x, eu_y = hApi.chaGetPos(eu.handle)
										local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --小兵的包围盒
										local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --小兵的中心点x位置
										local eu_center_y = eu_y + (eu_by + eu_bh / 2) --小兵的中心点y位置
										--local eu_extra_radius = math.sqrt(eu_bw / 2 * eu_bw / 2 + eu_bh / 2 *eu_bh / 2) --小兵额外的攻击距离
										]]
										--geyachao: 改为敌方单位脚底板坐标
										local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle) --有路点角色坐标
										local attackRange = eu:GetAtkRange() --有路点角色攻击范围
										local defendRange = eu.data.defend_distance_max --有路点角色守卫范围
										
										--取锁定的英雄的中心位置
										--[[
										local hero_x, hero_y = hApi.chaGetPos(lockTarget.handle) --英雄的坐标
										local hero_bx, hero_by, hero_bw, hero_bh = lockTarget:getbox() --英雄的包围盒
										local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --英雄的中心点x位置
										local hero_center_y = hero_y + (hero_by + hero_bh / 2) --英雄的中心点y位置
										]]
										--geyachao: 改为脚底板坐标
										local hero_center_x, hero_center_y = hApi.chaGetPos(lockTarget.handle) --英雄的坐标
										local hero_bx, hero_by, hero_bw, hero_bh = 0, 0, hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE
										--如果目标是嘲讽的单位，取目标的中心位置
										if (lockTarget.attr.is_taunt == 1) then
											hero_bx, hero_by, hero_bw, hero_bh = lockTarget:getbox() --嘲讽目标的包围盒
											hero_center_x = hero_center_x + (hero_bx + hero_bw / 2) --嘲讽目标的中心点x位置
											hero_center_y = hero_center_y + (hero_by + hero_bh / 2) --嘲讽目标的中心点y位置
											
											hero_bw, hero_bh = lockTarget.attr.taunt_radius * 2, lockTarget.attr.taunt_radius * 2
										end
										
										--判断矩形和圆是否相交
										--是否直接在小兵的射程内
										if hApi.CircleIntersectRect(eu_center_x, eu_center_y, attackRange, hero_center_x, hero_center_y, hero_bw, hero_bh) then --在射程内
											--标记有路点角色正式发起攻击
											--有路点角色停下来
											--print("->hApi.UnitStop_TD------ 12")
											hApi.UnitStop_TD(eu)
											
											--设置ai状态为攻击
											eu:setAIState(hVar.UNIT_AI_STATE.ATTACK)
											
											--print("move: 标记小兵正式发起攻击")
										elseif hApi.CircleIntersectRect(eu_center_x, eu_center_y, defendRange + attackRange, hero_center_x, hero_center_y, hero_bw, hero_bh) then --在射程内
											--未在小兵的射程内，但是在小兵的攻击范围+守卫范围内
											--小兵朝目标移动
											--设置ai状态为跟随
											eu:setAIState(hVar.UNIT_AI_STATE.FOLLOW)
											
											--敌方小兵移动到达目标点(这里计算障碍)
											hApi.UnitMoveToTarget_TD(eu, lockTarget, attackRange - hVar.MOVE_EXTRA_DISTANCE, true) --24距离的缓冲
											--print("move: 未在小兵的射程内，但是在小兵的攻击范围+守卫范围内", eu.__ID, eu.data.lockTarget)
										else
											--不在小兵的射程内
											--不锁定目标
											--eu.data.lockTarget = 0 --取消小兵锁定攻击的角色
											--print("lockTarget = 0 44", eu.__ID)
											--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
											hApi.UnitTryToLockTarget(eu, 0, 0)
											--print("lockType 34", eu.data.name, 0)
											--print("move: 不在小兵的射程内+守卫范围内 eu.data.lockTarget = 0")
											
											--检测目标是否也解除对小兵的锁定
											if (lockTarget.data.lockTarget == eu) then
												if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
													if (eu.attr.is_taunt ~= 1) then --敌方单位不是嘲讽单位
														--lockTarget.data.lockTarget = 0
														--print("lockTarget = 0 43", lockTarget.__ID)
														--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
														hApi.UnitTryToLockTarget(lockTarget, 0, 0)
														--print("lockType 33", lockTarget.data.name, 0)
													end
												end
											end
										end
									end
								else --被动怪小兵无锁定的目标，在一直走着
									--
								end
							elseif (aiAttribute == hVar.AI_ATTRIBUTE_TYPE.ACTIVE) then --主动怪，主动寻找附近的敌人
								local findEnemy = AI_search_attack_target(eu) --找敌人
								
								--有路点角色锁定攻击的角色
								if findEnemy and (findEnemy ~= 0) then
									hApi.UnitTryToLockTarget(eu, findEnemy, 0)
									--eu.data.lockTarget = findEnemy
									--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
									--print("lockType 32", eu.data.name, 0)
									
									--检测目标是否也锁定有路点角色
									if (findEnemy.data.lockTarget == 0) then
										hApi.UnitTryToLockTarget(findEnemy, eu, 0)
										--findEnemy.data.lockTarget = eu
										--findEnemy.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
										--print("lockType 31", findEnemy.data.name, 0)
									end
									
									local attack = eu.attr.attack --小兵攻击力表
									
									--有路点角色有攻击力（这里不用判断是否cd到了）
									if (eu.attr.attack[5] > 0) then
										--检测锁定的英雄在小兵攻击范围内
										--取小兵的中心点位置
										--[[
										local eu_x, eu_y = hApi.chaGetPos(eu.handle)
										local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --小兵的包围盒
										local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --小兵的中心点x位置
										local eu_center_y = eu_y + (eu_by + eu_bh / 2) --小兵的中心点y位置
										--local eu_extra_radius = math.sqrt(eu_bw / 2 * eu_bw / 2 + eu_bh / 2 *eu_bh / 2) --小兵额外的攻击距离
										]]
										--geyachao: 改为脚底板坐标
										local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle) --敌方小兵坐标
										local attackRange = eu:GetAtkRange() --敌方小兵攻击范围
										local defendRange = eu.data.defend_distance_max --敌方小兵守卫范围
										
										--取找到的目标的中心位置
										--[[
										local hero_x, hero_y = hApi.chaGetPos(findEnemy.handle) --找到的目标的坐标
										local hero_bx, hero_by, hero_bw, hero_bh = findEnemy:getbox() --找到的目标的包围盒
										local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --找到的目标的中心点x位置
										local hero_center_y = hero_y + (hero_by + hero_bh / 2) --找到的目标的中心点y位置
										]]
										--geyachao: 改为脚底板坐标
										local hero_center_x, hero_center_y = hApi.chaGetPos(findEnemy.handle) --找到的目标的坐标
										local hero_bx, hero_by, hero_bw, hero_bh = 0, 0, hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE
										--如果目标是嘲讽的单位，取目标的中心位置
										if (findEnemy.attr.is_taunt == 1) then
											hero_bx, hero_by, hero_bw, hero_bh = findEnemy:getbox() --找到的嘲讽目标的包围盒
											hero_center_x = hero_center_x + (hero_bx + hero_bw / 2) --找到的嘲讽目标的中心点x位置
											hero_center_y = hero_center_y + (hero_by + hero_bh / 2) --找到的嘲讽目标的中心点y位置
											
											hero_bw, hero_bh = findEnemy.attr.taunt_radius * 2, findEnemy.attr.taunt_radius * 2
										end
										
										--判断矩形和圆是否相交
										--是否直接在小兵的射程内
										if hApi.CircleIntersectRect(eu_center_x, eu_center_y, attackRange, hero_center_x, hero_center_y, hero_bw, hero_bh) then --在射程内
											--标记小兵正式发起攻击
											--小兵停下来
											--print("->hApi.UnitStop_TD------ 11")
											hApi.UnitStop_TD(eu)
											
											--设置ai状态为攻击
											eu:setAIState(hVar.UNIT_AI_STATE.ATTACK)
										else --肯定在(搜敌范围+守卫范围)内
											--未在小兵的射程内，但是在小兵的攻击搜敌范围内
											--设置ai状态为跟随
											eu:setAIState(hVar.UNIT_AI_STATE.FOLLOW)
											
											--小兵朝目标移动
											local dx = hero_center_x - eu_center_x
											local dy = hero_center_y - eu_center_y
											local distance = math.sqrt(dx * dx + dy * dy)
											if (distance < hVar.ENEMY_AI_RADIUS) then --大菠萝太远的单位移动到坦克身边
												--敌方小兵移动到达目标(这里计算障碍)
												--print("敌方小兵移动到达目标", eu.data.name, findEnemy.data.name, attackRange)
												hApi.UnitMoveToTarget_TD(eu, findEnemy, attackRange - hVar.MOVE_EXTRA_DISTANCE, true) --24距离的缓冲
											else
												--设置ai状态为移动到坦克身边
												eu:setAIState(hVar.UNIT_AI_STATE.MOVE_TANK_NEARBY)
												
												--移动到坦克身边
												hApi.UnitMoveToPoint_TD(eu, hero_center_x, hero_center_y, true)
											end
										end
									end
								else --主动怪小兵找不到敌人，在一直走着
									--
								end
							end
						end
					elseif(aiState == hVar.UNIT_AI_STATE.MOVE_TO_POINT) then --有路点单位为移动到达目标点后释放战术技能
						--等移动到达回调
						--...
					elseif (aiState == hVar.UNIT_AI_STATE.MOVE_TO_POINT_CASTSKILL) then --有路点单位为移动到达目标点后继续释放技能
						--等移动到达回调
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.FOLLOW_TO_TARGET) then --有路点单位为移动到达目标后释放战术技能
						--等移动到达回调
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.MOVE_TANK_NEARBY) then --有路点单位为移动到坦克身边
						--等移动到达回调
						--...
						
						--隐身有路点角色如果正在跟随敌人，那么停下来，继续按路点走路
						local yinshen_state = eu:GetYinShenState() --是否在隐身状态
						if (yinshen_state == 1) then --隐身小兵
							--有路点角色停下来
							--print("->hApi.UnitStop_TD------ 10")
							hApi.UnitStop_TD(eu)
							
							--设置ai状态为闲置
							eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
						else --非隐身有路点角色
							local lockTarget = eu.data.lockTarget --小兵锁定攻击的角色
							
							if (lockTarget == 0) then --如果小兵已经没锁定目标了，那么不需要再跟随
								--小兵停下来
								--print("->hApi.UnitStop_TD------ 9")
								hApi.UnitStop_TD(eu)
								
								--设置ai状态为闲置
								eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
								--设置ai状态为移动
								--eu:setAIState(hVar.UNIT_AI_STATE.MOVE)
								--print("follow: 小兵已经没锁定目标了，那么不需要再跟随", eu.__ID)
							elseif (lockTarget.data.IsDead == 1) then --如果此时跟随（锁定）的目标已经死亡，那么取消跟随状态
								--小兵停下来
								--print("->hApi.UnitStop_TD------ 8")
								hApi.UnitStop_TD(eu)
								
								--不锁定目标（目标已死亡）
								--eu.data.lockTarget = 0
								--print("lockTarget = 0 42", eu.__ID)
								--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
								hApi.UnitTryToLockTarget(eu, 0, 0)
								--print("lockType 30", eu.data.name, 0)
								
								--设置ai状态为闲置
								eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
								--设置ai状态为移动
								--eu:setAIState(hVar.UNIT_AI_STATE.MOVE)
								--print("follow: 不锁定目标（目标已死亡）")
							else
								--时刻检测小兵和跟随的目标的距离，是否在小兵的搜敌范围内
								--取小兵的中心点位置
								--[[
								local eu_x, eu_y = hApi.chaGetPos(eu.handle)
								local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --小兵的包围盒
								local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --小兵的中心点x位置
								local eu_center_y = eu_y + (eu_by + eu_bh / 2) --小兵的中心点y位置
								--local eu_extra_radius = math.sqrt(eu_bw / 2 * eu_bw / 2 + eu_bh / 2 *eu_bh / 2) --小兵额外的攻击距离
								]]
								--geyachao: 改为脚底板坐标
								local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle) --敌方小兵坐标
								local attackRange = eu:GetAtkRange() --敌方小兵攻击范围
								local defendRange = eu.data.defend_distance_max --敌方小兵守卫范围
								
								--取锁定的英雄的中心位置
								--[[
								local hero_x, hero_y = hApi.chaGetPos(lockTarget.handle) --英雄的坐标
								local hero_bx, hero_by, hero_bw, hero_bh = lockTarget:getbox() --英雄的包围盒
								local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --英雄的中心点x位置
								local hero_center_y = hero_y + (hero_by + hero_bh / 2) --英雄的中心点y位置
								]]
								--geyachao: 改为脚底板坐标
								local hero_center_x, hero_center_y = hApi.chaGetPos(lockTarget.handle) --英雄的坐标
								local hero_bx, hero_by, hero_bw, hero_bh = 0, 0, hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE
								--如果目标是嘲讽的单位，取目标的中心位置
								if (lockTarget.attr.is_taunt == 1) then
									hero_bx, hero_by, hero_bw, hero_bh = lockTarget:getbox() --找到的嘲讽目标的包围盒
									hero_center_x = hero_center_x + (hero_bx + hero_bw / 2) --找到的嘲讽目标的中心点x位置
									hero_center_y = hero_center_y + (hero_by + hero_bh / 2) --找到的嘲讽目标的中心点y位置
									
									hero_bw, hero_bh = lockTarget.attr.taunt_radius * 2, lockTarget.attr.taunt_radius * 2
								end
								
								--小兵朝目标移动
								local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle)
								local dx = hero_center_x - eu_center_x
								local dy = hero_center_y - eu_center_y
								local distance = math.sqrt(dx * dx + dy * dy)
								if (distance < hVar.ENEMY_AI_RADIUS) then --大菠萝太远的单位移动到坦克身边
									--设置ai状态为移动到坦克
									eu:setAIState(hVar.UNIT_AI_STATE.MOVE_TANK)
									
									--敌方小兵移动到达目标(这里计算障碍)
									--print("敌方小兵移动到达目标", eu.data.name, findEnemy.data.name, attackRange)
									hApi.UnitMoveToTarget_TD(eu, lockTarget, attackRange - hVar.MOVE_EXTRA_DISTANCE, true) --24距离的缓冲
								end
							end
						end
					elseif(aiState == hVar.UNIT_AI_STATE.MOVE_TANK) then --有路点单位为移动到坦克
						--等移动到达回调
						--...
						
						--隐身有路点角色如果正在跟随敌人，那么停下来，继续按路点走路
						local yinshen_state = eu:GetYinShenState() --是否在隐身状态
						if (yinshen_state == 1) then --隐身小兵
							--有路点角色停下来
							--print("->hApi.UnitStop_TD------ 10")
							hApi.UnitStop_TD(eu)
							
							--设置ai状态为闲置
							eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
						else --非隐身有路点角色
							local lockTarget = eu.data.lockTarget --小兵锁定攻击的角色
							
							if (lockTarget == 0) then --如果小兵已经没锁定目标了，那么不需要再跟随
								--小兵停下来
								--print("->hApi.UnitStop_TD------ 9")
								hApi.UnitStop_TD(eu)
								
								--设置ai状态为闲置
								eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
								--设置ai状态为移动
								--eu:setAIState(hVar.UNIT_AI_STATE.MOVE)
								--print("follow: 小兵已经没锁定目标了，那么不需要再跟随", eu.__ID)
							elseif (lockTarget.data.IsDead == 1) then --如果此时跟随（锁定）的目标已经死亡，那么取消跟随状态
								--小兵停下来
								--print("->hApi.UnitStop_TD------ 8")
								hApi.UnitStop_TD(eu)
								
								--不锁定目标（目标已死亡）
								--eu.data.lockTarget = 0
								--print("lockTarget = 0 42", eu.__ID)
								--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
								hApi.UnitTryToLockTarget(eu, 0, 0)
								--print("lockType 30", eu.data.name, 0)
								
								--设置ai状态为闲置
								eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
								--设置ai状态为移动
								--eu:setAIState(hVar.UNIT_AI_STATE.MOVE)
								--print("follow: 不锁定目标（目标已死亡）")
							else
								--时刻检测小兵和跟随的目标的距离，是否在小兵的搜敌范围内
								--取小兵的中心点位置
								--[[
								local eu_x, eu_y = hApi.chaGetPos(eu.handle)
								local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --小兵的包围盒
								local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --小兵的中心点x位置
								local eu_center_y = eu_y + (eu_by + eu_bh / 2) --小兵的中心点y位置
								--local eu_extra_radius = math.sqrt(eu_bw / 2 * eu_bw / 2 + eu_bh / 2 *eu_bh / 2) --小兵额外的攻击距离
								]]
								--geyachao: 改为脚底板坐标
								local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle) --敌方小兵坐标
								local attackRange = eu:GetAtkRange() --敌方小兵攻击范围
								local defendRange = eu.data.defend_distance_max --敌方小兵守卫范围
								
								--取锁定的英雄的中心位置
								--[[
								local hero_x, hero_y = hApi.chaGetPos(lockTarget.handle) --英雄的坐标
								local hero_bx, hero_by, hero_bw, hero_bh = lockTarget:getbox() --英雄的包围盒
								local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --英雄的中心点x位置
								local hero_center_y = hero_y + (hero_by + hero_bh / 2) --英雄的中心点y位置
								]]
								--geyachao: 改为脚底板坐标
								local hero_center_x, hero_center_y = hApi.chaGetPos(lockTarget.handle) --英雄的坐标
								local hero_bx, hero_by, hero_bw, hero_bh = 0, 0, hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE
								--如果目标是嘲讽的单位，取目标的中心位置
								if (lockTarget.attr.is_taunt == 1) then
									hero_bx, hero_by, hero_bw, hero_bh = lockTarget:getbox() --找到的嘲讽目标的包围盒
									hero_center_x = hero_center_x + (hero_bx + hero_bw / 2) --找到的嘲讽目标的中心点x位置
									hero_center_y = hero_center_y + (hero_by + hero_bh / 2) --找到的嘲讽目标的中心点y位置
									
									hero_bw, hero_bh = lockTarget.attr.taunt_radius * 2, lockTarget.attr.taunt_radius * 2
								end
								
								--小兵朝目标移动
								local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle)
								local dx = hero_center_x - eu_center_x
								local dy = hero_center_y - eu_center_y
								local distance = math.sqrt(dx * dx + dy * dy)
								if (distance < hVar.ENEMY_AI_RADIUS) then --大菠萝太远的单位移动到坦克身边
									--
								else
									--设置ai状态为移动到坦克身边
									eu:setAIState(hVar.UNIT_AI_STATE.MOVE_TANK_NEARBY)
									
									--移动到坦克身边
									hApi.UnitMoveToPoint_TD(eu, hero_center_x, hero_center_y, true)
								end
							end
						end
					elseif(aiState == hVar.UNIT_AI_STATE.FOLLOW) then --有路点角色为跟随某个单位状态
						--等移动到达回调
						--...
						
						--隐身有路点角色如果正在跟随敌人，那么停下来，继续按路点走路
						local yinshen_state = eu:GetYinShenState() --是否在隐身状态
						if (yinshen_state == 1) then --隐身小兵
							--有路点角色停下来
							--print("->hApi.UnitStop_TD------ 10")
							hApi.UnitStop_TD(eu)
							
							--设置ai状态为闲置
							eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
						elseif (eu.attr.suffer_touming_stack > 0) then --单位透明，不能跟随别人了
							--有路点角色停下来
							--print("->hApi.UnitStop_TD------ 10")
							hApi.UnitStop_TD(eu)
							
							--设置ai状态为闲置
							eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
						else --非隐身有路点角色
							local lockTarget = eu.data.lockTarget --小兵锁定攻击的角色
							
							if (lockTarget == 0) then --如果小兵已经没锁定目标了，那么不需要再跟随
								--小兵停下来
								--print("->hApi.UnitStop_TD------ 9")
								hApi.UnitStop_TD(eu)
								
								--设置ai状态为闲置
								eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
								--设置ai状态为移动
								--eu:setAIState(hVar.UNIT_AI_STATE.MOVE)
								--print("follow: 小兵已经没锁定目标了，那么不需要再跟随", eu.__ID)
							elseif (lockTarget.data.IsDead == 1) then --如果此时跟随（锁定）的目标已经死亡，那么取消跟随状态
								--小兵停下来
								--print("->hApi.UnitStop_TD------ 8")
								hApi.UnitStop_TD(eu)
								
								--不锁定目标（目标已死亡）
								--eu.data.lockTarget = 0
								--print("lockTarget = 0 42", eu.__ID)
								--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
								hApi.UnitTryToLockTarget(eu, 0, 0)
								--print("lockType 30", eu.data.name, 0)
								
								--设置ai状态为闲置
								eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
								--设置ai状态为移动
								--eu:setAIState(hVar.UNIT_AI_STATE.MOVE)
								--print("follow: 不锁定目标（目标已死亡）")
							else
								--时刻检测小兵和跟随的目标的距离，是否在小兵的搜敌范围内
								--取小兵的中心点位置
								--[[
								local eu_x, eu_y = hApi.chaGetPos(eu.handle)
								local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --小兵的包围盒
								local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --小兵的中心点x位置
								local eu_center_y = eu_y + (eu_by + eu_bh / 2) --小兵的中心点y位置
								--local eu_extra_radius = math.sqrt(eu_bw / 2 * eu_bw / 2 + eu_bh / 2 *eu_bh / 2) --小兵额外的攻击距离
								]]
								--geyachao: 改为脚底板坐标
								local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle) --敌方小兵坐标
								local attackRange = eu:GetAtkRange() --敌方小兵攻击范围
								local defendRange = eu.data.defend_distance_max --敌方小兵守卫范围
								
								--取锁定的英雄的中心位置
								--[[
								local hero_x, hero_y = hApi.chaGetPos(lockTarget.handle) --英雄的坐标
								local hero_bx, hero_by, hero_bw, hero_bh = lockTarget:getbox() --英雄的包围盒
								local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --英雄的中心点x位置
								local hero_center_y = hero_y + (hero_by + hero_bh / 2) --英雄的中心点y位置
								]]
								--geyachao: 改为脚底板坐标
								local hero_center_x, hero_center_y = hApi.chaGetPos(lockTarget.handle) --英雄的坐标
								local hero_bx, hero_by, hero_bw, hero_bh = 0, 0, hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE
								--如果目标是嘲讽的单位，取目标的中心位置
								if (lockTarget.attr.is_taunt == 1) then
									hero_bx, hero_by, hero_bw, hero_bh = lockTarget:getbox() --找到的嘲讽目标的包围盒
									hero_center_x = hero_center_x + (hero_bx + hero_bw / 2) --找到的嘲讽目标的中心点x位置
									hero_center_y = hero_center_y + (hero_by + hero_bh / 2) --找到的嘲讽目标的中心点y位置
									
									hero_bw, hero_bh = lockTarget.attr.taunt_radius * 2, lockTarget.attr.taunt_radius * 2
								end
								
								--如果超出射程+守卫半径，那么取消锁定
								if (not hApi.CircleIntersectRect(eu_center_x, eu_center_y, attackRange + defendRange, hero_center_x, hero_center_y, hero_bw, hero_bh)) then --不在射程内
									--不锁定目标（目标已出射程）
									--eu.data.lockTarget = 0 --取消小兵锁定攻击的角色
									--print("lockTarget = 0 41", eu.__ID)
									--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
									hApi.UnitTryToLockTarget(eu, 0, 0)
									--print("lockType 29", eu.data.name, 0)
									
									--print("follow: 如果超出射程+守卫半径，那么取消锁定")
									
									--检测目标是否也解除对小兵的锁定
									if (lockTarget.data.lockTarget == eu) then
										if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
											if (eu.attr.is_taunt ~= 1) then --敌方单位不是嘲讽单位
												--lockTarget.data.lockTarget = 0
												--print("lockTarget = 0 40", lockTarget.__ID)
												--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
												hApi.UnitTryToLockTarget(lockTarget, 0, 0)
												--print("lockType 28", lockTarget.data.name, 0)
											end
										end
									end
									
									--小兵停下来
									--print("->hApi.UnitStop_TD------ 7")
									hApi.UnitStop_TD(eu)
									
									--设置ai状态为闲置
									eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
								end
							end
						end
					elseif(aiState == hVar.UNIT_AI_STATE.CAST) then --有路点角色为释放技能状态
						--标记状态为施法后僵直状态
						eu:setAIState(hVar.UNIT_AI_STATE.CAST_STATIC)
						
						--触发角色眩晕或僵直或混乱状态变化事件
						hGlobal.event:event("Event_UnitStunStaticState", eu, 0, 1, eu.attr.suffer_chaos_stack, eu.attr.suffer_sleep_stack, eu.attr.suffer_chenmo_stack)
					elseif(aiState == hVar.UNIT_AI_STATE.CAST_STATIC) then --有路点角色为释放技能后的僵直状态
						local pasttime = currenttime - eu.data.castskillLastTime --距离上次施法的时间
						--print("pasttime=", pasttime)
						--检查是否已过僵直时间
						if (pasttime >= eu.data.castskillStaticTime) then --过了僵直时间
							--标记ai状态为攻击
							eu:setAIState(hVar.UNIT_AI_STATE.ATTACK)
							
							--角色尝试释放AI技能
							UnitAutoCastSkill(eu)
							
							--触发角色眩晕或僵直或混乱状态变化事件
							hGlobal.event:event("Event_UnitStunStaticState", eu, 0, 0, eu.attr.suffer_chaos_stack, eu.attr.suffer_sleep_stack, eu.attr.suffer_chenmo_stack)
						end
					elseif(aiState == hVar.UNIT_AI_STATE.ATTACK) then --有路点角色为攻击状态
						--敌方隐身单如果正在攻击敌人，那么继续按路点走路
						local yinshen_state = eu:GetYinShenState() --是否在隐身状态
						if (yinshen_state == 1) then --隐身有路点角色
							--设置ai状态为闲置
							eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
						elseif (eu.attr.suffer_touming_stack > 0) then --单位透明，不能攻击了
							--设置ai状态为闲置
							eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
						else --非隐身有路点角色
							--检测是否有锁定攻击的角色
							local attack = eu.attr.attack --小兵攻击力表
							local lasttime = eu.attr.lastAttackTime --上次攻击的时间
							local deltatime = currenttime - lasttime --距离上次攻击间隔的时间
							local atk_interval = eu:GetAtkInterval() --小兵的攻击间隔
							
							--过了攻击间隔
							if (deltatime >= atk_interval) then
								local lockTarget = eu.data.lockTarget --小兵锁定攻击的角色
								if (lockTarget ~= 0) and (eu.attr.attack[5] > 0) and (eu.attr.suffer_touming_stack <= 0) and (eu.attr.suffer_jinyan_stack <= 0) then --有锁定的目标、并且小兵有攻击力、不是透明状态（不能碰撞）、不是禁言状态（不能普通攻击）
									--检测锁定的英雄在小兵攻击范围内
									--取小兵的中心点位置
									--[[
									local eu_x, eu_y = hApi.chaGetPos(eu.handle)
									local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --小兵的包围盒
									local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --小兵的中心点x位置
									local eu_center_y = eu_y + (eu_by + eu_bh / 2) --小兵的中心点y位置
									--local eu_extra_radius = math.sqrt(eu_bw / 2 * eu_bw / 2 + eu_bh / 2 *eu_bh / 2) --小兵额外的攻击距离
									]]
									--geyachao: 改为脚底板坐标
									local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle) --敌方小兵坐标
									local attackRange = eu:GetAtkRange() --敌方小兵攻击范围
									local defendRange = eu.data.defend_distance_max --敌方小兵守卫范围
									
									--取英雄的中心位置
									--[[
									local hero_x, hero_y = hApi.chaGetPos(lockTarget.handle) --英雄的坐标
									local hero_bx, hero_by, hero_bw, hero_bh = lockTarget:getbox() --英雄的包围盒
									local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --英雄的中心点x位置
									local hero_center_y = hero_y + (hero_by + hero_bh / 2) --英雄的中心点y位置
									]]
									--geyachao: 改为脚底板坐标
									local hero_center_x, hero_center_y = hApi.chaGetPos(lockTarget.handle) --英雄的坐标
									local hero_bx, hero_by, hero_bw, hero_bh = 0, 0, hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE
									--如果目标是嘲讽的单位，取目标的中心位置
									if (lockTarget.attr.is_taunt == 1) then
										hero_bx, hero_by, hero_bw, hero_bh = lockTarget:getbox() --找到的嘲讽目标的包围盒
										hero_center_x = hero_center_x + (hero_bx + hero_bw / 2) --找到的嘲讽目标的中心点x位置
										hero_center_y = hero_center_y + (hero_by + hero_bh / 2) --找到的嘲讽目标的中心点y位置
										
										hero_bw, hero_bh = lockTarget.attr.taunt_radius * 2 , lockTarget.attr.taunt_radius * 2 
										--print("如果目标是嘲讽的单位，取目标的中心位置", eu_center_x, eu_center_y, attackRange, hero_center_x, hero_center_y, hero_bw, hero_bh)
									end
									
									--判断矩形和圆是否相交
									--是否直接在射程内
									if hApi.CircleIntersectRect(eu_center_x, eu_center_y, attackRange, hero_center_x, hero_center_y, hero_bw, hero_bh) then --在射程内
										--xlLG("attack", eu.data.name .. "_" .. eu.__ID .. " attack " .. lockTarget.data.name .. "_" .. lockTarget.__ID .. ", 在射程内，直接攻击.\n")
										local atk_radius_min = eu:GetAtkRangeMin() --搜敌半径最小值
										local bEnableAtkMin = true --最小攻击范围是否可以打
										if (atk_radius_min > 0) then
											--目标和塔的距离
											local dx = eu_center_x - hero_center_x
											local dy = eu_center_y - hero_center_y
											local eu_distance = math.floor(math.sqrt(dx * dx + dy * dy) * 100) / 100 --搜敌的目标的距离，保留2位有效数字，用于同步
											if (eu_distance < atk_radius_min) then
												bEnableAtkMin = false
											end
										end
										
										if bEnableAtkMin then --最小攻击范围可以打
											--小兵发起普通攻击
											atttack(eu, lockTarget)
											
											--标记小兵新的攻击时间点
											eu.attr.lastAttackTime = currenttime
											--print("attack: 小兵发起普通攻击")
											--本次攻击完毕，继续找目标
											--如果是被动怪，那么一直锁定目标
											if (eu:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then
												--...
											else
												local findEnemy = AI_search_attack_target(eu) --重新找敌人
												
												--先取消原先的锁定
												--eu.data.lockTarget = 0
												--print("lockTarget = 0 39", eu.__ID)
												--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
												hApi.UnitTryToLockTarget(eu, 0, 0)
												--print("lockType 27", eu.data.name, 0)
												
												--检测原先锁定敌人的，是否取消对英雄的锁定
												if (lockTarget.data.lockTarget == eu) then
													if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
														if (eu.attr.is_taunt ~= 1) then --敌方单位不是嘲讽单位
															--lockTarget.data.lockTarget = 0
															--print("lockTarget = 0 38", lockTarget.__ID)
															--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
															hApi.UnitTryToLockTarget(lockTarget, 0, 0)
															--print("lockType 26", lockTarget.data.name, 0)
														end
													end
												end
												
												if findEnemy and (findEnemy ~= 0) then
													hApi.UnitTryToLockTarget(eu, findEnemy, 0)
													--eu.data.lockTarget = findEnemy --锁定新目标
													--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
													--print("lockType 25", eu.data.name, 0)
													
													--检测目标是否也锁定小兵
													if (findEnemy.data.lockTarget == 0) then
														hApi.UnitTryToLockTarget(findEnemy, eu, 0)
														--findEnemy.data.lockTarget = eu
														--findEnemy.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
														--print("lockType 24", findEnemy.data.name, 0)
													end
												end
											end
										else --最小供给范围以外
											--锁定的单位已出射程，那么有路点单位闲置
											--eu.data.lockTarget = 0
											--print("lockTarget = 0 37", eu.__ID)
											--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
											hApi.UnitTryToLockTarget(eu, 0, 0)
											--print("lockType 23", eu.data.name, 0)
											
											--检测敌方目标是否也解除对我方英雄的锁定
											if (lockTarget.data.lockTarget == eu) then
												if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
													if (eu.attr.is_taunt ~= 1) then --敌方单位不是嘲讽单位
														--lockTarget.data.lockTarget = 0
														--print("lockTarget = 0 36", lockTarget.__ID)
														--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
														hApi.UnitTryToLockTarget(lockTarget, 0, 0)
														--print("lockType 22", lockTarget.data.name, 0)
													end
												end
											end
											--print("attack: 标记ai状态为闲置")
											--标记ai状态为闲置
											eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
										end
									elseif hApi.CircleIntersectRect(eu_center_x, eu_center_y, attackRange + defendRange, hero_center_x, hero_center_y, hero_bw, hero_bh) then --在射程内
										--xlLG("attack", eu.data.name .. "_" .. eu.__ID .. " attack " .. lockTarget.data.name .. "_" .. lockTarget.__ID .. ", 在搜索范围内，发起移动. u_x=" .. eu_center_x .. ", u_y=" .. eu_center_y .. ", t_x=" .. hero_center_x .. ", t_y=" .. hero_center_y .. ".\n")
										--不在直接攻击的范围内，但是在搜敌范围+守卫范围内
										--小兵朝目标移动
										--设置ai状态为跟随
										eu:setAIState(hVar.UNIT_AI_STATE.FOLLOW)
										--print("attack: 不在直接攻击的范围内，但是在搜敌范围+守卫范围内")
										--敌方小兵移动到达目标(这里计算障碍)
										hApi.UnitMoveToTarget_TD(eu, lockTarget, attackRange - hVar.MOVE_EXTRA_DISTANCE, true) --24距离的缓冲
									else
										--xlLG("attack", eu.data.name .. "_" .. eu.__ID .. " attack " .. lockTarget.data.name .. "_" .. lockTarget.__ID .. ", 已出射程，取消锁定.\n")
										--锁定的单位已出射程，那么有路点单位闲置
										--eu.data.lockTarget = 0
										--print("lockTarget = 0 37", eu.__ID)
										--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
										hApi.UnitTryToLockTarget(eu, 0, 0)
										--print("lockType 23", eu.data.name, 0)
										
										--检测敌方目标是否也解除对我方英雄的锁定
										if (lockTarget.data.lockTarget == eu) then
											if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
												if (eu.attr.is_taunt ~= 1) then --敌方单位不是嘲讽单位
													--lockTarget.data.lockTarget = 0
													--print("lockTarget = 0 36", lockTarget.__ID)
													--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
													hApi.UnitTryToLockTarget(lockTarget, 0, 0)
													--print("lockType 22", lockTarget.data.name, 0)
												end
											end
										end
										--print("attack: 标记ai状态为闲置")
										--标记ai状态为闲置
										eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
									end
								else --无锁定的目标
									--标记ai状态为闲置
									eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
								end
							end
						end
					elseif(aiState == hVar.UNIT_AI_STATE.STUN) then --有路点角色为眩晕状态
						--等到眩晕结束
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.MOVE_BY_TRACK) then --有路点角色为滑行状态
						--等到滑行结束
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.SLEEP) then --有路点单位为沉睡状态
						--等到沉睡结束
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.REACHED) then --有路点角色为到达终点状态
						if (eu.data.IsReachedRoad == 0) then --是否到过终点（防止重复调用事件）
							--标记处理过了
							eu.data.IsReachedRoad = 1
							
							if (eu:getRoadPointType() == hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_LINE) then --按路点走直线，走完消失
								--删除敌方有路点单位
								--print("删除 " .. eu.data.name)
								
								--触发事件
								--local skillId = hVar.tab_unit[eu.data.id].attr.onReachedCastSkillId or 0
								local skillId = eu.attr.onReachedCastSkillId
								if (skillId > 0) then
									local targetX, targetY = hApi.chaGetPos(eu.handle) --目标的位置
									local gridX, gridY = world:xy2grid(targetX, targetY)
									local validTarget = AI_search_skill_target(eu, skillId)
									if validTarget and (validTarget ~= 0) then
										--释放技能
										local tCastParam =
										{
											--level = eu.attr.attack[6], --普通攻击的等级
											--skillTimes = eu.data.atkTimes, --普通攻击的次数
										}
										local ret = hApi.CastSkill(eu, skillId, 0, 100, validTarget, gridX, gridY, tCastParam) --释放技能
										if (ret == nil) then
											--施法失败
											--触发到达事件
											hGlobal.event:call("LocalEvent_TD_UnitReached", eu)
										end
									else
										--触发到达事件
										hGlobal.event:call("LocalEvent_TD_UnitReached", eu)
									end
								else
									--触发到达事件
									hGlobal.event:call("LocalEvent_TD_UnitReached", eu)
								end
								
								--print("删除角色")
								--xlLG("RoadPoint", "到达终点, unit=" .. tostring(eu.data.name) .. "_" .. tostring(eu.__ID) .. ", 剩余路点_num=" .. #(eu:getRoadPoint()) .. "\n")
							elseif (eu:getRoadPointType() == hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_LINE_EVENT) then --按路点走直线，走完触发事件
								--触发事件
								--local skillId = hVar.tab_unit[eu.data.id].attr.onReachedCastSkillId or 0
								local skillId = eu.attr.onReachedCastSkillId
								if (skillId > 0) then
									local targetX, targetY = hApi.chaGetPos(eu.handle) --目标的位置
									local gridX, gridY = world:xy2grid(targetX, targetY)
									local validTarget = AI_search_skill_target(eu, skillId)
									if validTarget and (validTarget ~= 0) then
										--释放技能
										local tCastParam =
										{
											--level = eu.attr.attack[6], --普通攻击的等级
											--skillTimes = eu.data.atkTimes, --普通攻击的次数
										}
										hApi.CastSkill(eu, skillId, 0, 100, validTarget, gridX, gridY, tCastParam) --释放技能
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

--依次遍历地图上的单位（有路点单位）（简易AI）
--world:enumunit(function(eu)
local enumunit_callback_RoadPoiunt_Simple = function(eu)
	local world = hGlobal.WORLD.LastWorldMap
	local regionId = world.data.randommapIdx --地图当前所在小关数
	local currenttime = world:gametime()
	
	local subType = eu.data.type --角色子类型
	--local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
	local aiState = eu:getAIState() --角色的AI状态
	local unitSide = eu:getowner() --角色的控制方
	
	--非上帝
	--if (eu ~= mapInfo.godUnit) then --不是上帝
	if (eu.data.IsDead ~= 1) and (eu.attr.hp > 0) then --活着的单位
		--普通单位、英雄、图腾、、武器、塔、建筑
		if (eu.data.type == hVar.UNIT_TYPE.UNIT) or (eu.data.type == hVar.UNIT_TYPE.HERO) or (eu.data.type == hVar.UNIT_TYPE.HERO_TOKEN)
		or (eu.data.type == hVar.UNIT_TYPE.UNITGUN) or (eu.data.type == hVar.UNIT_TYPE.NPC_TALK) or (eu.data.type == hVar.UNIT_TYPE.UNITBOX)
		or (eu.data.type == hVar.UNIT_TYPE.UNITCAN) or (eu.data.type == hVar.UNIT_TYPE.TOWER) or (eu.data.type == hVar.UNIT_TYPE.BUILDING) then
			--大菠萝效率优化
			--随机地图模式，如果当前单位不是本层的，不处理AI
			local regionIdBelong = eu.attr.regionIdBelong
			if (regionIdBelong == 0) or (regionIdBelong == regionId) then
				--if (roadPoint ~= 0) then --有路点
				if (eu:getRoadPointType() ~= hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_NONE) then --有路点
					local aiAttribute = eu:GetAIAttribute() --角色的AI行为
					--print("eu=" .. eu.data.name .. ", aiAttribute=" .. aiAttribute .. ", target=" .. tostring(eu.data.lockTarget))
					if (aiState == hVar.UNIT_AI_STATE.IDLE) then --有路点角色为空闲状态
						local roadPoint = eu:getRoadPoint() --角色的路点
						--检测是否走向下一个路点
						local nextRoad = roadPoint
						--if nextRoad then --还有未走完的路点
						if nextRoad and type(nextRoad) == "table" then --还有未走完的路点
							--设置角色移动状态
							eu:setAIState(hVar.UNIT_AI_STATE.MOVE)
							
							--移动角色（直接移动）
							--hApi.chaMoveTo(eu.handle, nextRoad.x, nextRoad.y)
							--eu:setanimation("walk")
							--大菠萝
							--[[
							--主角是否活着
							local oUnitMe = world:GetPlayerMe().heros[1]:getunit()
							if oUnitMe then
								hApi.UnitMoveToPoint_TD(eu, nextRoad.x, nextRoad.y, false)
							else
								hApi.UnitMoveToPoint_TD(eu, nextRoad.x, nextRoad.y, true)
							end
							]]
							hApi.UnitMoveToPoint_TD(eu, nextRoad.x, nextRoad.y, false)
							--local gridX,gridY = world:xy2grid(nextRoad.x, nextRoad.y)
							--eu:movetogrid(gridX, gridY)
							
							--if eu.sssssssss == nil then
							--	print(eu.data.name .. " move: " .. currenttime)
							--	eu.sssssssss = 1
							--end
							--print("移动 " .. eu.data.name)
						elseif (nextRoad == -1) then --所有的路点都已走完
							--设置角色到达终点状态
							eu:setAIState(hVar.UNIT_AI_STATE.REACHED)
							--print("设置角色到达终点状态", eu.data.name)
						end
					elseif(aiState == hVar.UNIT_AI_STATE.MOVE_ADJUST) then --有路点角色为移动调整状态
						--等待移动到达回调
						--...
					elseif (aiState == hVar.UNIT_AI_STATE.MOVE_CHAOS) then --有路点角色为移动混乱状态（单位无目的乱走）
						--等待移动到达回调
						--...
					elseif (aiState == hVar.UNIT_AI_STATE.MOVE_HOSTAGE_TANK) then --有路点角色为人质移动跟随坦克状态
						--等待移动到达回调
						--...
						elseif (aiState == hVar.UNIT_AI_STATE.MOVE_HOSTAGE_ChAOS) then --有路点角色为人质移动混乱状态（单位无目的乱走）
						--等待移动到达回调
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.MOVE) then --有路点角色为移动状态
						--等移动到达回调
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.MOVE_TO_POINT) then --有路点单位为移动到达目标点后释放战术技能
						--等移动到达回调
						--...
					elseif (aiState == hVar.UNIT_AI_STATE.MOVE_TO_POINT_CASTSKILL) then --有路点单位为移动到达目标点后继续释放技能
						--等移动到达回调
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.FOLLOW_TO_TARGET) then --有路点单位为移动到达目标后释放战术技能
						--等移动到达回调
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.MOVE_TANK_NEARBY) then --有路点单位为移动到坦克身边
						--等移动到达回调
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.MOVE_TANK) then --有路点单位为移动到坦克
						--等移动到达回调
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.FOLLOW) then --有路点角色为跟随某个单位状态
						--等移动到达回调
						--...
						
						--隐身有路点角色如果正在跟随敌人，那么停下来，继续按路点走路
						local yinshen_state = eu:GetYinShenState() --是否在隐身状态
						if (yinshen_state == 1) then --隐身小兵
							--有路点角色停下来
							--print("->hApi.UnitStop_TD------ 10")
							hApi.UnitStop_TD(eu)
							
							--设置ai状态为闲置
							eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
						elseif (eu.attr.suffer_touming_stack > 0) then --单位透明，不用跟随敌人
							hApi.UnitStop_TD(eu)
							
							--设置ai状态为闲置
							eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
						else --非隐身有路点角色
							local lockTarget = eu.data.lockTarget --小兵锁定攻击的角色
							
							if (lockTarget == 0) then --如果小兵已经没锁定目标了，那么不需要再跟随
								--小兵停下来
								--print("->hApi.UnitStop_TD------ 9")
								hApi.UnitStop_TD(eu)
								
								--设置ai状态为闲置
								eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
								--设置ai状态为移动
								--eu:setAIState(hVar.UNIT_AI_STATE.MOVE)
								--print("follow: 小兵已经没锁定目标了，那么不需要再跟随", eu.__ID)
							elseif (lockTarget.data.IsDead == 1) then --如果此时跟随（锁定）的目标已经死亡，那么取消跟随状态
								--小兵停下来
								--print("->hApi.UnitStop_TD------ 8")
								hApi.UnitStop_TD(eu)
								
								--不锁定目标（目标已死亡）
								--eu.data.lockTarget = 0
								--print("lockTarget = 0 42", eu.__ID)
								--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
								hApi.UnitTryToLockTarget(eu, 0, 0)
								--print("lockType 30", eu.data.name, 0)
								
								--设置ai状态为闲置
								eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
								--设置ai状态为移动
								--eu:setAIState(hVar.UNIT_AI_STATE.MOVE)
								--print("follow: 不锁定目标（目标已死亡）")
							else
								--时刻检测小兵和跟随的目标的距离，是否在小兵的搜敌范围内
								--取小兵的中心点位置
								--[[
								local eu_x, eu_y = hApi.chaGetPos(eu.handle)
								local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --小兵的包围盒
								local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --小兵的中心点x位置
								local eu_center_y = eu_y + (eu_by + eu_bh / 2) --小兵的中心点y位置
								--local eu_extra_radius = math.sqrt(eu_bw / 2 * eu_bw / 2 + eu_bh / 2 *eu_bh / 2) --小兵额外的攻击距离
								]]
								--geyachao: 改为脚底板坐标
								local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle) --敌方小兵坐标
								local attackRange = eu:GetAtkRange() --敌方小兵攻击范围
								local defendRange = eu.data.defend_distance_max --敌方小兵守卫范围
								
								--取锁定的英雄的中心位置
								--[[
								local hero_x, hero_y = hApi.chaGetPos(lockTarget.handle) --英雄的坐标
								local hero_bx, hero_by, hero_bw, hero_bh = lockTarget:getbox() --英雄的包围盒
								local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --英雄的中心点x位置
								local hero_center_y = hero_y + (hero_by + hero_bh / 2) --英雄的中心点y位置
								]]
								--geyachao: 改为脚底板坐标
								local hero_center_x, hero_center_y = hApi.chaGetPos(lockTarget.handle) --英雄的坐标
								local hero_bx, hero_by, hero_bw, hero_bh = 0, 0, hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE
								--如果目标是嘲讽的单位，取目标的中心位置
								if (lockTarget.attr.is_taunt == 1) then
									hero_bx, hero_by, hero_bw, hero_bh = lockTarget:getbox() --找到的嘲讽目标的包围盒
									hero_center_x = hero_center_x + (hero_bx + hero_bw / 2) --找到的嘲讽目标的中心点x位置
									hero_center_y = hero_center_y + (hero_by + hero_bh / 2) --找到的嘲讽目标的中心点y位置
									
									hero_bw, hero_bh = lockTarget.attr.taunt_radius * 2, lockTarget.attr.taunt_radius * 2
								end
								
								--如果超出射程+守卫半径，那么取消锁定
								if (not hApi.CircleIntersectRect(eu_center_x, eu_center_y, attackRange + defendRange, hero_center_x, hero_center_y, hero_bw, hero_bh)) then --不在射程内
									--不锁定目标（目标已出射程）
									--eu.data.lockTarget = 0 --取消小兵锁定攻击的角色
									--print("lockTarget = 0 41", eu.__ID)
									--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
									hApi.UnitTryToLockTarget(eu, 0, 0)
									--print("lockType 29", eu.data.name, 0)
									
									--print("follow: 如果超出射程+守卫半径，那么取消锁定")
									
									--检测目标是否也解除对小兵的锁定
									if (lockTarget.data.lockTarget == eu) then
										if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
											if (eu.attr.is_taunt ~= 1) then --敌方单位不是嘲讽单位
												--lockTarget.data.lockTarget = 0
												--print("lockTarget = 0 40", lockTarget.__ID)
												--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
												hApi.UnitTryToLockTarget(lockTarget, 0, 0)
												--print("lockType 28", lockTarget.data.name, 0)
											end
										end
									end
									
									--小兵停下来
									--print("->hApi.UnitStop_TD------ 7")
									hApi.UnitStop_TD(eu)
									
									--设置ai状态为闲置
									eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
								end
							end
						end
					elseif(aiState == hVar.UNIT_AI_STATE.CAST) then --有路点角色为释放技能状态
						--标记状态为施法后僵直状态
						eu:setAIState(hVar.UNIT_AI_STATE.CAST_STATIC)
						
						--触发角色眩晕或僵直或混乱状态变化事件
						hGlobal.event:event("Event_UnitStunStaticState", eu, 0, 1, eu.attr.suffer_chaos_stack, eu.attr.suffer_sleep_stack, eu.attr.suffer_chenmo_stack)
					elseif(aiState == hVar.UNIT_AI_STATE.CAST_STATIC) then --有路点角色为释放技能后的僵直状态
						local pasttime = currenttime - eu.data.castskillLastTime --距离上次施法的时间
						--print("pasttime=", pasttime)
						--检查是否已过僵直时间
						if (pasttime >= eu.data.castskillStaticTime) then --过了僵直时间
							--标记ai状态为攻击
							eu:setAIState(hVar.UNIT_AI_STATE.ATTACK)
							
							--角色尝试释放AI技能
							UnitAutoCastSkill(eu)
							
							--触发角色眩晕或僵直或混乱状态变化事件
							hGlobal.event:event("Event_UnitStunStaticState", eu, 0, 0, eu.attr.suffer_chaos_stack, eu.attr.suffer_sleep_stack, eu.attr.suffer_chenmo_stack)
						end
					elseif(aiState == hVar.UNIT_AI_STATE.ATTACK) then --有路点角色为攻击状态
						--
					elseif(aiState == hVar.UNIT_AI_STATE.STUN) then --有路点角色为眩晕状态
						--等到眩晕结束
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.MOVE_BY_TRACK) then --有路点角色为滑行状态
						--等到滑行结束
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.SLEEP) then --有路点单位为沉睡状态
						--等到沉睡结束
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.REACHED) then --有路点角色为到达终点状态
						if (eu.data.IsReachedRoad == 0) then --是否到过终点（防止重复调用事件）
							--标记处理过了
							eu.data.IsReachedRoad = 1
							
							if (eu:getRoadPointType() == hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_LINE) then --按路点走直线，走完消失
								--删除敌方有路点单位
								--print("删除 " .. eu.data.name)
								
								--触发事件
								--local skillId = hVar.tab_unit[eu.data.id].attr.onReachedCastSkillId or 0
								local skillId = eu.attr.onReachedCastSkillId
								if (skillId > 0) then
									local targetX, targetY = hApi.chaGetPos(eu.handle) --目标的位置
									local gridX, gridY = world:xy2grid(targetX, targetY)
									local validTarget = AI_search_skill_target(eu, skillId)
									if validTarget and (validTarget ~= 0) then
										--释放技能
										local tCastParam =
										{
											--level = eu.attr.attack[6], --普通攻击的等级
											--skillTimes = eu.data.atkTimes, --普通攻击的次数
										}
										local ret = hApi.CastSkill(eu, skillId, 0, 100, validTarget, gridX, gridY, tCastParam) --释放技能
										if (ret == nil) then
											--施法失败
											--触发到达事件
											hGlobal.event:call("LocalEvent_TD_UnitReached", eu)
										end
									else
										--触发到达事件
										hGlobal.event:call("LocalEvent_TD_UnitReached", eu)
									end
								else
									--触发到达事件
									hGlobal.event:call("LocalEvent_TD_UnitReached", eu)
								end
								
								--print("删除角色")
								--xlLG("RoadPoint", "到达终点, unit=" .. tostring(eu.data.name) .. "_" .. tostring(eu.__ID) .. ", 剩余路点_num=" .. #(eu:getRoadPoint()) .. "\n")
							elseif (eu:getRoadPointType() == hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_LINE_EVENT) then --按路点走直线，走完触发事件
								--触发事件
								--local skillId = hVar.tab_unit[eu.data.id].attr.onReachedCastSkillId or 0
								local skillId = eu.attr.onReachedCastSkillId
								if (skillId > 0) then
									local targetX, targetY = hApi.chaGetPos(eu.handle) --目标的位置
									local gridX, gridY = world:xy2grid(targetX, targetY)
									local validTarget = AI_search_skill_target(eu, skillId)
									if validTarget and (validTarget ~= 0) then
										--释放技能
										local tCastParam =
										{
											--level = eu.attr.attack[6], --普通攻击的等级
											--skillTimes = eu.data.atkTimes, --普通攻击的次数
										}
										hApi.CastSkill(eu, skillId, 0, 100, validTarget, gridX, gridY, tCastParam) --释放技能
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

--地图上的有路点单位的AI流程（有路点英雄、有路点小兵、有路点图腾、有路点箱子、有路点汽油桶）
function Road_Unit_NormalAttackLoop()
	local world = hGlobal.WORLD.LastWorldMap
	
	--如果游戏暂停，直接跳出循环
	if (world.data.IsPaused == 1) then
		return
	end
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end
	
	--游戏暂停或结束，直接退出
	if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
		return
	end
	
	--禁止响应事件，不处理
	--if (world.data.keypadEnabled ~= true) then
	--	return
	--end
	
	--当前时间
	local currenttime = world:gametime()
	--local oPlayerMe = world:GetPlayerMe() --我的玩家对象
	--local nForceMe = oPlayerMe:getforce() --我的势力
	--local oNeutralPlayer = world:GetForce(nForceMe) --中立阵营玩家对象（蜀国/魏国）
	
	
	
	--[[
	--geyachao: 会出现怪卡住不攻击的问题，先注释掉看是否还会卡住？
	--首先，对我方单位进行AI管理（有路点单位）
	local rpgunits = world.data.rpgunits
	for u, u_worldC in pairs(rpgunits) do
		if (u:getworldC() == u_worldC) then
			enumunit_callback_RoadPoiunt(u)
		end
	end
	
	--其次，对我方主角坦克周围的敌人进行AI管理（有路点单位）
	local rpgunit_tank = world.data.rpgunit_tank
	if rpgunit_tank and (rpgunit_tank ~= 0) then
		local hero_x, hero_y = hApi.chaGetPos(rpgunit_tank.handle) --坐标
		world:enumunitScreenEnemy(rpgunit_tank:getowner():getforce(), enumunit_callback_RoadPoiunt)
	end
	
	--再对不在我方主角坦克周围的敌人进行AI管理（有路点单位）（简易AI）
	local rpgunit_tank = world.data.rpgunit_tank
	if rpgunit_tank and (rpgunit_tank ~= 0) then
		local hero_x, hero_y = hApi.chaGetPos(rpgunit_tank.handle) --坐标
		world:enumunitScreenOutEnemy(rpgunit_tank:getowner():getforce(), enumunit_callback_RoadPoiunt_Simple)
	end
	]]
	
	world:enumunit(enumunit_callback_RoadPoiunt)
end

--依次遍历地图上的所有单位（无路点单位）
--world:enumunit(function(eu)
--检测到的单位的回调函数
local enumunit_callback_NoRoad_Unit = function(eu)
	local world = hGlobal.WORLD.LastWorldMap
	local regionId = world.data.randommapIdx --地图当前所在小关数
	local currenttime = world:gametime()
	
	local subType = eu.data.type --角色子类型
	--local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
	local aiState = eu:getAIState() --角色的AI状态
	--local roadPoint = eu:getRoadPoint() --角色的路点
	--local unitSide = eu:getowner() --角色的控制方
	
	--无路点单位
	if (eu:getRoadPointType() == hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_NONE) then --无路点
		--非上帝
		if (eu.data.IsDead ~= 1) and (eu.attr.hp > 0) then --活着的单位
			--普通单位、英雄、图腾、箱子、汽油桶、塔、建筑
			if (eu.data.type == hVar.UNIT_TYPE.UNIT) or (eu.data.type == hVar.UNIT_TYPE.HERO) or (eu.data.type == hVar.UNIT_TYPE.HERO_TOKEN)
			or (eu.data.type == hVar.UNIT_TYPE.UNITGUN) or (eu.data.type == hVar.UNIT_TYPE.NPC_TALK) or (eu.data.type == hVar.UNIT_TYPE.UNITBOX)
			or (eu.data.type == hVar.UNIT_TYPE.UNITCAN) or (eu.data.type == hVar.UNIT_TYPE.TOWER) or (eu.data.type == hVar.UNIT_TYPE.BUILDING) then
				--大菠萝效率优化
				--随机地图模式，如果当前单位不是本层的，不处理AI
				local regionIdBelong = eu.attr.regionIdBelong
				if (regionIdBelong == 0) or (regionIdBelong == regionId) then
					local aiAttribute = eu:GetAIAttribute() --角色的AI行为
					--print("eu=" .. eu.data.name .. ", aiAttribute=" .. aiAttribute .. ", target=" .. tostring(eu.data.lockTarget))
					if (aiState == hVar.UNIT_AI_STATE.IDLE) then --无路点单位为空闲状态
						--闲着无事
						--...
						
						--隐身的单位只会闲着，不会检测攻击
						local yinshen_state = eu:GetYinShenState() --是否在隐身状态
						if (yinshen_state == 1) then --隐身单位
							--
						elseif (eu.attr.suffer_touming_stack > 0) then --单位透明，不用检测攻击
							--
						elseif (eu.data.id == hVar.MY_TANK_SCIENTST_ID) or (eu.data.id == hVar.MY_TANK_SCIENTST2_ID) then --人质单位，可能由于之前被卡障碍里，这里设置乱走状态
							--人质进入混乱
							hApi.UnitBeginHostageChaos(eu)
						else --非隐身单位
							if (aiAttribute == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪，检测是否有锁定的目标
								--检测是否有锁定攻击的角色
								local lockTarget = eu.data.lockTarget --小兵锁定攻击的角色
								if (lockTarget ~= 0) then
									local attack = eu.attr.attack --小兵攻击力表
									
									--英雄有攻击力（这里不用判断是否cd到了）
									if (eu.attr.attack[5] > 0) then
										--检测锁定的单位是否在英雄的攻击范围内
										--取英雄的中心点位置
										--[[
										local eu_x, eu_y = hApi.chaGetPos(eu.handle)
										local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --小兵的包围盒
										local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --小兵的中心点x位置
										local eu_center_y = eu_y + (eu_by + eu_bh / 2) --小兵的中心点y位置
										--local eu_extra_radius = math.sqrt(eu_bw / 2 * eu_bw / 2 + eu_bh / 2 *eu_bh / 2) --小兵额外的攻击距离
										]]
										--geyachao: 改为脚底板坐标
										local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle)
										local attackRange = eu:GetAtkRange() --英雄攻击范围
										local defend_x, defend_y = eu.data.defend_x, eu.data.defend_y --英雄的守卫坐标
										local defendRange = eu.data.defend_distance_max --英雄守卫范围
										
										--取锁定的单位的中心位置
										--[[
										local lock_x, lock_y = hApi.chaGetPos(lockTarget.handle) --锁定单位的坐标
										local lock_bx, lock_by, lock_bw, lock_bh = lockTarget:getbox() --锁定单位的包围盒
										local lock_center_x = lock_x + (lock_bx + lock_bw / 2) --锁定单位的中心点x位置
										local lock_center_y = lock_y + (lock_by + lock_bh / 2) --锁定单位的中心点y位置
										]]
										--geyachao: 改为脚底板坐标
										local lock_center_x, lock_center_y = hApi.chaGetPos(lockTarget.handle) --锁定单位的坐标
										local lock_bx, lock_by, lock_bw, lock_bh = 0, 0, hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE
										--如果目标是嘲讽的单位，取目标的中心位置
										if (lockTarget.attr.is_taunt == 1) then
											lock_bx, lock_by, lock_bw, lock_bh = lockTarget:getbox() --嘲讽目标的包围盒
											lock_center_x = lock_center_x + (lock_bx + lock_bw / 2) --嘲讽目标的中心点x位置
											lock_center_y = lock_center_y + (lock_by + lock_bh / 2) --嘲讽目标的中心点y位置
											
											lock_bw, lock_bh = lockTarget.attr.taunt_radius * 2, lockTarget.attr.taunt_radius * 2
										end
										
										--判断矩形和圆是否相交
										--是否直接在英雄的射程内
										if hApi.CircleIntersectRect(eu_center_x, eu_center_y, attackRange, lock_center_x, lock_center_y, lock_bw, lock_bh) then --在射程内
											--标记英雄正式发起攻击
											--英雄停下来
											--print("->hApi.UnitStop_TD------ 6")
											hApi.UnitStop_TD(eu)
											--print("标记英雄正式发起攻击", eu.data.name, "被动怪，检测是否有锁定的目标", "hApi.UnitStop_TD")
											
											--设置ai状态为攻击
											eu:setAIState(hVar.UNIT_AI_STATE.ATTACK)
										elseif hApi.CircleIntersectRect(defend_x, defend_y, attackRange + defendRange, lock_center_x, lock_center_y, lock_bw, lock_bh) then --在射程内
											--未在小兵的射程内，但是在小兵的攻击搜敌范围+守卫范围内
											--小兵朝目标移动
											--设置ai状态为跟随
											eu:setAIState(hVar.UNIT_AI_STATE.FOLLOW)
											
											--敌方小兵移动到达目标点(这里计算障碍)
											hApi.UnitMoveToTarget_TD(eu, lockTarget, attackRange - hVar.MOVE_EXTRA_DISTANCE, true) --24距离的缓冲
										else
											--不在英雄的射程内
											--不锁定目标
											--eu.data.lockTarget = 0 --取消小兵锁定攻击的角色
											--print("lockTarget = 0 14", eu.__ID)
											--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
											hApi.UnitTryToLockTarget(eu, 0, 0)
											--print("lockType 20", eu.data.name, 0)
											
											--检测目标是否也解除对英雄的锁定
											if (lockTarget.data.lockTarget == eu) then
												if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
													if (eu.attr.is_taunt ~= 1) then --我方单位不是嘲讽单位
														--lockTarget.data.lockTarget = 0
														--print("lockTarget = 0 13", lockTarget.__ID)
														--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
														hApi.UnitTryToLockTarget(lockTarget, 0, 0)
														--print("lockType 19", lockTarget.data.name, 0)
													end
												end
											end
										end
									end
								else --被动怪英雄或小兵无锁定的目标，在一直闲置状态
									--闲着的时候，检测是否要回到守卫点
									local defend_distance_max = eu.data.defend_distance_max --最远能到达的距离
									if (defend_distance_max > 0) then --这种情况下需要检测
										local ex, ey = hApi.chaGetPos(eu.handle) --单位的坐标
										local defend_x, defend_y = eu.data.defend_x, eu.data.defend_y --守卫点坐标
										
										--geyachao: 瓦力守卫点是战车
										--if (eu.data.id == hVar.MY_TANK_FOLLOW_ID) then
										for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
											if (eu.data.id == walle_id) then
												--print("瓦力守卫点是战车")
												local oHero = world:GetPlayerMe().heros[1]
												if oHero then
													local oTank = oHero:getunit()
													if oTank then
														defend_x = oTank.data.defend_x + eu.data.defend_x_walle
														defend_y = oTank.data.defend_y + eu.data.defend_y_walle
													end
												end
											end
										end
										
										local dx, dy = ex - defend_x, ey - defend_y
										local diatance = math.floor(math.sqrt(dx * dx + dy * dy) * 100) / 100 --保留2位有效数字，用于同步
										
										--距离过近，认为不需要返回守卫点
										if (diatance > hVar.MY_TANK_FOLLOW_RADIUS) then
											--print(eu.data.name, "返回守卫点")
											--停下来
											hApi.UnitStop_TD(eu)
											
											--取消锁定的目标
											local lockTarget = eu.data.lockTarget
											--eu.data.lockTarget = 0
											--print("lockTarget = 0 12", eu.__ID)
											--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
											hApi.UnitTryToLockTarget(eu, 0, 0)
											--print("lockType 51", eu.data.name, 0)
											
											--检测目标是否也解除对其的锁定
											if (lockTarget ~= 0) then
												if (lockTarget.data.lockTarget == eu) then
													if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
														if (eu.attr.is_taunt ~= 1) then --我方单位不是嘲讽单位
															--lockTarget.data.lockTarget = 0
															--print("lockTarget = 0 11", lockTarget.__ID)
															--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
															hApi.UnitTryToLockTarget(lockTarget, 0, 0)
															--print("lockType 52", lockTarget.data.name, 0)
														end
													end
												end
											end
											
											--设置状态为移动
											eu:setAIState(hVar.UNIT_AI_STATE.MOVE)
											
											--移动到起始点
											hApi.UnitMoveToPoint_TD(eu, defend_x, defend_y, true)
										end
									end
								end
							elseif (aiAttribute == hVar.AI_ATTRIBUTE_TYPE.ACTIVE) then --主动怪，主动寻找附近的敌人
								local findEnemy = AI_search_attack_target(eu) --找敌人
								--print("-主动怪，主动寻找附近的敌人 findEnemy=" .. tostring(findEnemy))
								--英雄或小兵锁定攻击的角色
								if findEnemy and (findEnemy ~= 0) and (eu.data.lockType == 0) then --是被动锁定的类型
									hApi.UnitTryToLockTarget(eu, findEnemy, 0)
									--eu.data.lockTarget = findEnemy
									--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
									--print("lockType 18", eu.data.name, 0)
									
									--检测目标是否也锁定英雄
									if (findEnemy.data.lockTarget == 0) then
										hApi.UnitTryToLockTarget(findEnemy, eu, 0)
										--findEnemy.data.lockTarget = eu
										--findEnemy.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
										--print("lockType 17", findEnemy.data.name, 0)
									end
									
									local attack = eu.attr.attack --英雄攻击力表
									
									--英雄有攻击力（这里不用判断是否cd到了）
									if (eu.attr.attack[5] > 0) then
										--检测锁定的单位是否在英雄攻击范围内
										--取英雄的中心点位置
										--[[
										local eu_x, eu_y = hApi.chaGetPos(eu.handle)
										local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --英雄的包围盒
										local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --英雄的中心点x位置
										local eu_center_y = eu_y + (eu_by + eu_bh / 2) --英雄的中心点y位置
										--local eu_extra_radius = math.sqrt(eu_bw / 2 * eu_bw / 2 + eu_bh / 2 *eu_bh / 2) --英雄额外的攻击距离
										]]
										--geyachao: 改为脚底板坐标
										local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle)
										local attackRange = eu:GetAtkRange() --英雄攻击范围
										--local defend_x, defend_y = eu.data.defend_x, eu.data.defend_y --英雄的守卫坐标
										--local defendRange = eu.data.defend_distance_max --英雄守卫范围
										
										--取找到的单位的中心位置
										--[[
										local lock_x, lock_y = hApi.chaGetPos(findEnemy.handle) --找到的单位的坐标
										local lock_bx, lock_by, lock_bw, lock_bh = findEnemy:getbox() --找到的单位的包围盒
										local lock_center_x = lock_x + (lock_bx + lock_bw / 2) --找到的单位的中心点x位置
										local lock_center_y = lock_y + (lock_by + lock_bh / 2) --找到的单位位的中心点y位置
										]]
										--geyachao: 改为脚底板坐标
										local lock_center_x, lock_center_y = hApi.chaGetPos(findEnemy.handle) --找到的单位的坐标
										local lock_bx, lock_by, lock_bw, lock_bh = 0 ,0, hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE
										--如果目标是嘲讽的单位，取目标的中心位置
										if (findEnemy.attr.is_taunt == 1) then
											lock_bx, lock_by, lock_bw, lock_bh = findEnemy:getbox() --嘲讽目标的包围盒
											lock_center_x = lock_center_x + (lock_bx + lock_bw / 2) --嘲讽目标的中心点x位置
											lock_center_y = lock_center_y + (lock_by + lock_bh / 2) --嘲讽目标的中心点y位置
											
											lock_bw, lock_bh = findEnemy.attr.taunt_radius * 2, findEnemy.attr.taunt_radius * 2
										end
										
										--判断矩形和圆是否相交
										--是否直接在小兵的射程内
										if hApi.CircleIntersectRect(eu_center_x, eu_center_y, attackRange, lock_center_x, lock_center_y, lock_bw, lock_bh) then --在射程内
											--标记英雄正式发起攻击
											--英雄停下来
											--print("->hApi.UnitStop_TD------ 5")
											hApi.UnitStop_TD(eu)
											--print("标记英雄正式发起攻击", eu.data.name, "主动怪，主动寻找附近的敌人", "hApi.UnitStop_TD")
											
											--设置ai状态为攻击
											eu:setAIState(hVar.UNIT_AI_STATE.ATTACK)
										else --肯定在搜敌范围内
											--未在英雄的射程内，但是在英雄的攻击搜敌范围内
											--英雄朝目标移动
											--设置ai状态为跟随
											eu:setAIState(hVar.UNIT_AI_STATE.FOLLOW)
											
											local dx = lock_center_x - eu_center_x
											local dy = lock_center_y - eu_center_y
											local distance = math.sqrt(dx * dx + dy * dy)
											if (distance < hVar.ENEMY_AI_RADIUS) then --大菠萝太远的单位移动到坦克身边
												--敌方小兵移动到达目标(这里计算障碍)
												--英雄移动到达目标点(这里计算障碍)
												hApi.UnitMoveToTarget_TD(eu, findEnemy, attackRange - hVar.MOVE_EXTRA_DISTANCE, true) --24距离的缓冲
											else
												--设置ai状态为移动到坦克身边
												eu:setAIState(hVar.UNIT_AI_STATE.MOVE_TANK_NEARBY)
												
												--移动到身边
												hApi.UnitMoveToPoint_TD(eu, lock_center_x, lock_center_y, true)
											end
										end
									end
								else --我方英雄或小兵找不到敌人，一直闲置状态
									--[[
									--如果是我方英雄，那么如果有锁定的人，那么（追着）打它
									if (subType == hVar.UNIT_TYPE.HERO) and (eu.data.lockTarget ~= 0) then
										--移动到达
										--英雄朝目标移动
										--设置ai状态为跟随
										eu:setAIState(hVar.UNIT_AI_STATE.FOLLOW)
										
										--英雄移动到达目标点(这里计算障碍)
										hApi.UnitMoveToTarget_TD(eu, eu.data.lockTarget, eu:GetAtkRange() - hVar.MOVE_EXTRA_DISTANCE, true) --24距离的缓冲
									]]
									--else --没有敌人的我方英雄，或者我方小兵单位
										--如果此时有锁定的单位，那么取消锁定
										if (eu.data.lockTarget ~= 0) then
											--eu.data.lockTarget = 0
											--print("lockTarget = 0 10", eu.__ID)
											--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
											hApi.UnitTryToLockTarget(eu, 0, 0)
											--print("lockType 16", eu.data.name, 0)
										end
										
										--目标不需要取消锁定
										--...
										--闲着的时候，检测是否要回到守卫点
										local defend_distance_max = eu.data.defend_distance_max --最远能到达的距离
										if (defend_distance_max > 0) then --这种情况下需要检测
											local ex, ey = hApi.chaGetPos(eu.handle) --单位的坐标
											local defend_x, defend_y = eu.data.defend_x, eu.data.defend_y --守卫点坐标
											
											--geyachao: 瓦力守卫点是战车
											--if (eu.data.id == hVar.MY_TANK_FOLLOW_ID) then
											for _, walle_id in ipairs(hVar.MY_TANK_FOLLOW_ID) do
												if (eu.data.id == walle_id) then
													--print("瓦力守卫点是战车")
													local oHero = world:GetPlayerMe().heros[1]
													if oHero then
														local oTank = oHero:getunit()
														if oTank then
															defend_x = oTank.data.defend_x + eu.data.defend_x_walle
															defend_y = oTank.data.defend_y + eu.data.defend_y_walle
														end
													end
												end
											end
											
											local dx, dy = ex - defend_x, ey - defend_y
											local diatance = math.floor(math.sqrt(dx * dx + dy * dy) * 100) / 100 --保留2位有效数字，用于同步
											
											--距离过近，认为不需要返回守卫点
											if (diatance > hVar.MY_TANK_FOLLOW_RADIUS) then
												--print(eu.data.name, "返回守卫点")
												--停下来
												hApi.UnitStop_TD(eu)
												
												--取消锁定的目标
												local lockTarget = eu.data.lockTarget
												--eu.data.lockTarget = 0
												--print("lockTarget = 0 9", eu.__ID)
												--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
												hApi.UnitTryToLockTarget(eu, 0, 0)
												--print("lockType 51", eu.data.name, 0)
												
												--检测目标是否也解除对其的锁定
												if (lockTarget ~= 0) then
													if (lockTarget.data.lockTarget == eu) then
														if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
															if (eu.attr.is_taunt ~= 1) then --我方单位不是嘲讽单位
																--lockTarget.data.lockTarget = 0
																--print("lockTarget = 0 8", lockTarget.__ID)
																--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
																hApi.UnitTryToLockTarget(lockTarget, 0, 0)
																--print("lockType 52", lockTarget.data.name, 0)
															end
														end
													end
												end
												
												--设置状态为移动
												eu:setAIState(hVar.UNIT_AI_STATE.MOVE)
												
												--移动到起始点
												hApi.UnitMoveToPoint_TD(eu, defend_x, defend_y, true)
											end
										end
									--end
								end
							end
						end
					elseif(aiState == hVar.UNIT_AI_STATE.MOVE_ADJUST) then --无路点角色为移动调整状态
						--等待移动到达回调
						--...
					elseif (aiState == hVar.UNIT_AI_STATE.MOVE_CHAOS) then --无路点角色为移动混乱状态（单位无目的乱走）
						--等待移动到达回调
						--...
					elseif (aiState == hVar.UNIT_AI_STATE.MOVE_HOSTAGE_TANK) then --无路点角色为人质移动跟随坦克状态
						--等待移动到达回调
						--...
						elseif (aiState == hVar.UNIT_AI_STATE.MOVE_HOSTAGE_ChAOS) then --无路点角色为人质移动混乱状态（单位无目的乱走）
						--等待移动到达回调
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.MOVE) then --无路点单位为移动状态
						--等移动到达回调
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.MOVE_TO_POINT) then --无路点单位为移动到达目标点后释放战术技能
						--等移动到达回调
						--...
					elseif (aiState == hVar.UNIT_AI_STATE.MOVE_TO_POINT_CASTSKILL) then --无路点单位为移动到达目标点后继续释放技能
						--等移动到达回调
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.FOLLOW_TO_TARGET) then --无路点单位为移动到达目标后释放战术技能
						--等移动到达回调
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.MOVE_TANK_NEARBY) then --无路点单位为移动到坦克身边
						--等移动到达回调
						--...
						
						--隐身单位如果正在移动到敌人身边，那么停下来，继续闲置
						local yinshen_state = eu:GetYinShenState() --是否在隐身状态
						if (yinshen_state == 1) then --隐身单位
							--单位停下来
							--print("->hApi.UnitStop_TD------ 4")
							hApi.UnitStop_TD(eu)
							
							--设置ai状态为闲置
							eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
						else --非隐身单位
							--时刻检查跟随的目标是否还存在
							local lockTarget = eu.data.lockTarget --角色锁定攻击的单位
							
							if (lockTarget == 0) then --如果角色已经没锁定目标了，那么不需要再跟随到身边
								--单位停下来
								--print("->hApi.UnitStop_TD------ 3")
								hApi.UnitStop_TD(eu)
							
								--设置ai状态为闲置
								eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
								--设置ai状态为移动
								--eu:setAIState(hVar.UNIT_AI_STATE.MOVE)
							elseif (lockTarget.data.IsDead == 1) then --如果此时跟随（锁定）的目标已经死亡，那么取消跟随到身边状态
								--单位停下来
								--print("->hApi.UnitStop_TD------ 2")
								hApi.UnitStop_TD(eu)
								
								--不锁定目标（目标已死亡）
								--eu.data.lockTarget = 0
								--print("lockTarget = 0 7", eu.__ID, "不锁定目标（目标已死亡）")
								--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
								hApi.UnitTryToLockTarget(eu, 0, 0)
								--print("lockType 15", eu.data.name, 0)
								
								--设置ai状态为闲置
								eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
								--设置ai状态为移动
								--eu:setAIState(hVar.UNIT_AI_STATE.MOVE)
							else
								--一直跟随
								--时刻检测英雄和跟随的目标的距离，是否在英雄的搜敌范围内
								--[[
								--取英雄的中心点位置
								local eu_x, eu_y = hApi.chaGetPos(eu.handle)
								local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --英雄的包围盒
								local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --英雄的中心点x位置
								local eu_center_y = eu_y + (eu_by + eu_bh / 2) --英雄的中心点y位置
								--local eu_extra_radius = math.sqrt(eu_bw / 2 * eu_bw / 2 + eu_bh / 2 *eu_bh / 2) --英雄额外的攻击距离
								]]
								--geyachao: 英雄改为脚底板坐标
								--local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle)
								local defend_x, defend_y = eu.data.defend_x, eu.data.defend_y --英雄的守卫坐标
								local attackRange = eu:GetAtkRange() --英雄攻击范围
								local defendRange = eu.data.defend_distance_max --英雄守卫范围
								
								--取锁定的单位的中心位置
								--[[
								local lock_x, lock_y = hApi.chaGetPos(lockTarget.handle) --锁定单位的坐标
								local lock_bx, lock_by, lock_bw, lock_bh = lockTarget:getbox() --锁定单位的包围盒
								local lock_center_x = lock_x + (lock_bx + lock_bw / 2) --锁定单位的中心点x位置
								local lock_center_y = lock_y + (lock_by + lock_bh / 2) --锁定单位的中心点y位置
								]]
								local lock_center_x, lock_center_y = hApi.chaGetPos(lockTarget.handle) --锁定单位的坐标
								local lock_bx, lock_by, lock_bw, lock_bh = 0, 0, hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE
								--如果目标是嘲讽的单位，取目标的中心位置
								if (lockTarget.attr.is_taunt == 1) then
									lock_bx, lock_by, lock_bw, lock_bh = lockTarget:getbox() --嘲讽目标的包围盒
									lock_center_x = lock_center_x + (lock_bx + lock_bw / 2) --嘲讽目标的中心点x位置
									lock_center_y = lock_center_y + (lock_by + lock_bh / 2) --嘲讽目标的中心点y位置
									
									lock_bw, lock_bh = lockTarget.attr.taunt_radius * 2, lockTarget.attr.taunt_radius * 2
								end
								
								--小兵朝目标移动
								local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle)
								local dx = lock_center_x - eu_center_x
								local dy = lock_center_y - eu_center_y
								local distance = math.sqrt(dx * dx + dy * dy)
								if (distance < hVar.ENEMY_AI_RADIUS) then --大菠萝太远的单位移动到坦克身边
									--设置ai状态为移动到坦克
									eu:setAIState(hVar.UNIT_AI_STATE.MOVE_TANK)
									
									--敌方小兵移动到达目标(这里计算障碍)
									--print("敌方小兵移动到达目标", eu.data.name, findEnemy.data.name, attackRange)
									hApi.UnitMoveToTarget_TD(eu, lockTarget, attackRange - hVar.MOVE_EXTRA_DISTANCE, true) --24距离的缓冲
								end
							end
						end
					elseif(aiState == hVar.UNIT_AI_STATE.MOVE_TANK) then --无路点单位为移动到坦克
						--等移动到达回调
						--...
						
						--隐身单位如果正在移动到敌人身边，那么停下来，继续闲置
						local yinshen_state = eu:GetYinShenState() --是否在隐身状态
						if (yinshen_state == 1) then --隐身单位
							--单位停下来
							--print("->hApi.UnitStop_TD------ 4")
							hApi.UnitStop_TD(eu)
							
							--设置ai状态为闲置
							eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
						else --非隐身单位
							--时刻检查跟随的目标是否还存在
							local lockTarget = eu.data.lockTarget --角色锁定攻击的单位
							
							if (lockTarget == 0) then --如果角色已经没锁定目标了，那么不需要再跟随到身边
								--单位停下来
								--print("->hApi.UnitStop_TD------ 3")
								hApi.UnitStop_TD(eu)
							
								--设置ai状态为闲置
								eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
								--设置ai状态为移动
								--eu:setAIState(hVar.UNIT_AI_STATE.MOVE)
							elseif (lockTarget.data.IsDead == 1) then --如果此时跟随（锁定）的目标已经死亡，那么取消跟随到身边状态
								--单位停下来
								--print("->hApi.UnitStop_TD------ 2")
								hApi.UnitStop_TD(eu)
								
								--不锁定目标（目标已死亡）
								--eu.data.lockTarget = 0
								--print("lockTarget = 0 7", eu.__ID, "不锁定目标（目标已死亡）")
								--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
								hApi.UnitTryToLockTarget(eu, 0, 0)
								--print("lockType 15", eu.data.name, 0)
								
								--设置ai状态为闲置
								eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
								--设置ai状态为移动
								--eu:setAIState(hVar.UNIT_AI_STATE.MOVE)
							else
								--一直跟随
								--时刻检测英雄和跟随的目标的距离，是否在英雄的搜敌范围内
								--[[
								--取英雄的中心点位置
								local eu_x, eu_y = hApi.chaGetPos(eu.handle)
								local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --英雄的包围盒
								local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --英雄的中心点x位置
								local eu_center_y = eu_y + (eu_by + eu_bh / 2) --英雄的中心点y位置
								--local eu_extra_radius = math.sqrt(eu_bw / 2 * eu_bw / 2 + eu_bh / 2 *eu_bh / 2) --英雄额外的攻击距离
								]]
								--geyachao: 英雄改为脚底板坐标
								--local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle)
								local defend_x, defend_y = eu.data.defend_x, eu.data.defend_y --英雄的守卫坐标
								local attackRange = eu:GetAtkRange() --英雄攻击范围
								local defendRange = eu.data.defend_distance_max --英雄守卫范围
								
								--取锁定的单位的中心位置
								--[[
								local lock_x, lock_y = hApi.chaGetPos(lockTarget.handle) --锁定单位的坐标
								local lock_bx, lock_by, lock_bw, lock_bh = lockTarget:getbox() --锁定单位的包围盒
								local lock_center_x = lock_x + (lock_bx + lock_bw / 2) --锁定单位的中心点x位置
								local lock_center_y = lock_y + (lock_by + lock_bh / 2) --锁定单位的中心点y位置
								]]
								local lock_center_x, lock_center_y = hApi.chaGetPos(lockTarget.handle) --锁定单位的坐标
								local lock_bx, lock_by, lock_bw, lock_bh = 0, 0, hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE
								--如果目标是嘲讽的单位，取目标的中心位置
								if (lockTarget.attr.is_taunt == 1) then
									lock_bx, lock_by, lock_bw, lock_bh = lockTarget:getbox() --嘲讽目标的包围盒
									lock_center_x = lock_center_x + (lock_bx + lock_bw / 2) --嘲讽目标的中心点x位置
									lock_center_y = lock_center_y + (lock_by + lock_bh / 2) --嘲讽目标的中心点y位置
									
									lock_bw, lock_bh = lockTarget.attr.taunt_radius * 2, lockTarget.attr.taunt_radius * 2
								end
								
								--小兵朝目标移动
								local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle)
								local dx = lock_center_x - eu_center_x
								local dy = lock_center_y - eu_center_y
								local distance = math.sqrt(dx * dx + dy * dy)
								if (distance < hVar.ENEMY_AI_RADIUS) then --大菠萝太远的单位移动到坦克身边
									--
								else
									--设置ai状态为移动到坦克身边
									eu:setAIState(hVar.UNIT_AI_STATE.MOVE_TANK_NEARBY)
									
									--移动到坦克身边
									hApi.UnitMoveToPoint_TD(eu, lock_center_x, lock_center_y, true)
								end
							end
						end
					elseif(aiState == hVar.UNIT_AI_STATE.FOLLOW) then --无路点单位为跟随某个单位状态
						--等移动到达回调
						--...
						
						--隐身单位如果正在跟随敌人，那么停下来，继续闲置
						local yinshen_state = eu:GetYinShenState() --是否在隐身状态
						if (yinshen_state == 1) then --隐身单位
							--单位停下来
							--print("->hApi.UnitStop_TD------ 4")
							hApi.UnitStop_TD(eu)
							
							--设置ai状态为闲置
							eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
						elseif (eu.attr.suffer_touming_stack > 0) then --单位透明，不用跟随敌人
							--单位停下来
							--print("->hApi.UnitStop_TD------ 4")
							hApi.UnitStop_TD(eu)
							
							--设置ai状态为闲置
							eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
						else --非隐身单位
							--时刻检查跟随的目标是否还存在
							local lockTarget = eu.data.lockTarget --角色锁定攻击的单位
							
							if (lockTarget == 0) then --如果角色已经没锁定目标了，那么不需要再跟随
								--单位停下来
								--print("->hApi.UnitStop_TD------ 3")
								hApi.UnitStop_TD(eu)
							
								--设置ai状态为闲置
								eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
								--设置ai状态为移动
								--eu:setAIState(hVar.UNIT_AI_STATE.MOVE)
							elseif (lockTarget.data.IsDead == 1) then --如果此时跟随（锁定）的目标已经死亡，那么取消跟随状态
								--单位停下来
								--print("->hApi.UnitStop_TD------ 2")
								hApi.UnitStop_TD(eu)
								
								--不锁定目标（目标已死亡）
								--eu.data.lockTarget = 0
								--print("lockTarget = 0 7", eu.__ID, "不锁定目标（目标已死亡）")
								--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
								hApi.UnitTryToLockTarget(eu, 0, 0)
								--print("lockType 15", eu.data.name, 0)
								
								--设置ai状态为闲置
								eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
								--设置ai状态为移动
								--eu:setAIState(hVar.UNIT_AI_STATE.MOVE)
							else
								--一直跟随
								--时刻检测英雄和跟随的目标的距离，是否在英雄的搜敌范围内
								--[[
								--取英雄的中心点位置
								local eu_x, eu_y = hApi.chaGetPos(eu.handle)
								local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --英雄的包围盒
								local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --英雄的中心点x位置
								local eu_center_y = eu_y + (eu_by + eu_bh / 2) --英雄的中心点y位置
								--local eu_extra_radius = math.sqrt(eu_bw / 2 * eu_bw / 2 + eu_bh / 2 *eu_bh / 2) --英雄额外的攻击距离
								]]
								--geyachao: 英雄改为脚底板坐标
								--local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle)
								local defend_x, defend_y = eu.data.defend_x, eu.data.defend_y --英雄的守卫坐标
								local attackRange = eu:GetAtkRange() --英雄攻击范围
								local defendRange = eu.data.defend_distance_max --英雄守卫范围
								
								--取锁定的单位的中心位置
								--[[
								local lock_x, lock_y = hApi.chaGetPos(lockTarget.handle) --锁定单位的坐标
								local lock_bx, lock_by, lock_bw, lock_bh = lockTarget:getbox() --锁定单位的包围盒
								local lock_center_x = lock_x + (lock_bx + lock_bw / 2) --锁定单位的中心点x位置
								local lock_center_y = lock_y + (lock_by + lock_bh / 2) --锁定单位的中心点y位置
								]]
								local lock_center_x, lock_center_y = hApi.chaGetPos(lockTarget.handle) --锁定单位的坐标
								local lock_bx, lock_by, lock_bw, lock_bh = 0, 0, hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE
								--如果目标是嘲讽的单位，取目标的中心位置
								if (lockTarget.attr.is_taunt == 1) then
									lock_bx, lock_by, lock_bw, lock_bh = lockTarget:getbox() --嘲讽目标的包围盒
									lock_center_x = lock_center_x + (lock_bx + lock_bw / 2) --嘲讽目标的中心点x位置
									lock_center_y = lock_center_y + (lock_by + lock_bh / 2) --嘲讽目标的中心点y位置
									
									lock_bw, lock_bh = lockTarget.attr.taunt_radius * 2, lockTarget.attr.taunt_radius * 2
								end
								
								--如果是主动锁定的，会一直跟下去，不会检测
								--如果不在射程+守卫范围
								--eu.data.lockType == 1
								if (eu.data.lockType ~= 1) then --如果是主动锁定的，会一直跟下去
									--判断矩形和圆是否相交
									if (not hApi.CircleIntersectRect(defend_x, defend_y, attackRange + defendRange, lock_center_x, lock_center_y, lock_bw, lock_bh)) then --不在射程内
										--不锁定目标（目标已出射程）
										--print("不锁定目标（目标已出射程）")
										--eu.data.lockTarget = 0 --取消小兵锁定攻击的角色
										--print("lockTarget = 0 6", eu.__ID)
										--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
										hApi.UnitTryToLockTarget(eu, 0, 0)
										--print("lockType 14", eu.data.name, 0)
										
										--检测目标是否也解除对英雄的锁定
										if (lockTarget.data.lockTarget == eu) then
											if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
												if (eu.attr.is_taunt ~= 1) then --我方单位不是嘲讽单位
													--lockTarget.data.lockTarget = 0
													--print("lockTarget = 0 5", lockTarget.__ID)
													--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
													hApi.UnitTryToLockTarget(lockTarget, 0, 0)
													--print("lockType 13", lockTarget.data.name, 0)
												end
											end
										end
										
										--设置ai状态为闲置
										eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
									end
								end
							end
						end
					elseif(aiState == hVar.UNIT_AI_STATE.CAST) then --无路点单位为释放技能后的等待状态
						--标记状态为施法后僵直状态
						eu:setAIState(hVar.UNIT_AI_STATE.CAST_STATIC)
						
						--触发角色眩晕或僵直或混乱状态变化事件
						hGlobal.event:event("Event_UnitStunStaticState", eu, 0, 1, eu.attr.suffer_chaos_stack, eu.attr.suffer_sleep_stack, eu.attr.suffer_chenmo_stack)
					elseif(aiState == hVar.UNIT_AI_STATE.CAST_STATIC) then --无路点单位为释放技能后的僵直状态
						local pasttime = currenttime - eu.data.castskillLastTime --距离上次施法的时间
						--print("pasttime=", pasttime)
						--检查是否已过僵直时间
						if (pasttime >= eu.data.castskillStaticTime) then --过了僵直时间
							--标记ai状态为攻击
							eu:setAIState(hVar.UNIT_AI_STATE.ATTACK)
							
							--角色尝试释放AI技能
							UnitAutoCastSkill(eu)
							
							--触发角色眩晕或僵直或混乱状态变化事件
							hGlobal.event:event("Event_UnitStunStaticState", eu, 0, 0, eu.attr.suffer_chaos_stack, eu.attr.suffer_sleep_stack, eu.attr.suffer_chenmo_stack)
						end
					elseif(aiState == hVar.UNIT_AI_STATE.ATTACK) then --无路点单位为攻击状态
						--我方隐身单位如果正在攻击敌人，那么闲置
						local yinshen_state = eu:GetYinShenState() --是否在隐身状态
						if (yinshen_state == 1) then --隐身单位
							--设置ai状态为闲置
							eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
						elseif (eu.attr.suffer_touming_stack > 0) then --单位透明，不用攻击敌人
							--设置ai状态为闲置
							eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
						else --非隐身单位
							local attack = eu.attr.attack --英雄攻击力表
							local lasttime = eu.attr.lastAttackTime --上次攻击的时间
							local deltatime = currenttime - lasttime --距离上次攻击间隔的时间
							local atk_interval = eu:GetAtkInterval() --小兵的攻击间隔
								
							--过了攻击间隔
							if (deltatime >= atk_interval) then
								--检测是否有锁定攻击的敌方小兵
								local lockTarget = eu.data.lockTarget --英雄锁定攻击的角色
								if (lockTarget ~= 0) and (eu.attr.attack[5] > 0) and (eu.attr.suffer_touming_stack <= 0) and (eu.attr.suffer_jinyan_stack <= 0) then --有锁定的目标、并且小兵有攻击力、不是透明状态（不能碰撞）、不是禁言状态（不能普通攻击）
									--检测锁定的小兵是否在英雄的攻击范围内
									--取英雄的中心点位置
									--[[
									local eu_x, eu_y = hApi.chaGetPos(eu.handle)
									local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --英雄的包围盒
									local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --英雄的中心点x位置
									local eu_center_y = eu_y + (eu_by + eu_bh / 2) --英雄的中心点y位置
									--local eu_extra_radius = math.sqrt(eu_bw / 2 * eu_bw / 2 + eu_bh / 2 *eu_bh / 2) --英雄额外的攻击距离
									]]
									--geyachao: 英雄改为脚底板坐标
									local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle)
									local defend_x, defend_y = eu.data.defend_x, eu.data.defend_y --英雄的守卫坐标
									local attackRange = eu:GetAtkRange() --英雄攻击范围
									local defendRange = eu.data.defend_distance_max --英雄守卫范围
									
									--取锁定的敌方小兵的中心位置
									--[[
									local lock_x, lock_y = hApi.chaGetPos(lockTarget.handle) --锁定单位的坐标
									local lock_bx, lock_by, lock_bw, lock_bh = lockTarget:getbox() --锁定单位的包围盒
									local lock_center_x = lock_x + (lock_bx + lock_bw / 2) --锁定单位的中心点x位置
									local lock_center_y = lock_y + (lock_by + lock_bh / 2) --锁定单位的中心点y位置
									]]
									--geyachao: 小兵改为脚底板坐标
									local lock_center_x, lock_center_y = hApi.chaGetPos(lockTarget.handle) --锁定单位的坐标
									local  lock_bx, lock_by, lock_bw, lock_bh = 0, 0, hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE
									--如果目标是嘲讽的单位，取目标的中心位置
									if (lockTarget.attr.is_taunt == 1) then
										lock_bx, lock_by, lock_bw, lock_bh = lockTarget:getbox() --嘲讽目标的包围盒
										lock_center_x = lock_center_x + (lock_bx + lock_bw / 2) --嘲讽目标的中心点x位置
										lock_center_y = lock_center_y + (lock_by + lock_bh / 2) --嘲讽目标的中心点y位置
										
										lock_bw, lock_bh = lockTarget.attr.taunt_radius * 2, lockTarget.attr.taunt_radius * 2
									end
									
									--判断矩形和圆是否相交
									--是否直接在射程内
									--geychao: 如果是主动锁定的目标(目标不是傻走)，能走到攻击流程里，那肯定允许攻击(x3的需求) --geyachao: 已改掉
									if (hApi.CircleIntersectRect(eu_center_x, eu_center_y, attackRange, lock_center_x, lock_center_y, lock_bw, lock_bh)) then --在射程内
										--xlLG("attack", eu.data.name .. "_" .. eu.__ID .. " attack " .. lockTarget.data.name .. "_" .. lockTarget.__ID .. ", 在射程内，直接攻击.\n")
										local atk_radius_min = eu:GetAtkRangeMin() --搜敌半径最小值
										local bEnableAtkMin = true --最小攻击范围是否可以打
										if (atk_radius_min > 0) then
											--目标和塔的距离
											--print(eu.data.name, eu.data.id)
											local dx = eu_center_x - lock_center_x
											local dy = eu_center_y - lock_center_y
											local eu_distance = math.floor(math.sqrt(dx * dx + dy * dy) * 100) / 100 --搜敌的目标的距离，保留2位有效数字，用于同步
											if (eu_distance < atk_radius_min) then
												bEnableAtkMin = false
											end
										end
										
										if bEnableAtkMin then --最小攻击范围可以打
											--英雄发起普通攻击
											if (eu ~= lockTarget)
											and (eu.data.bind_unit ~= lockTarget) and (eu ~= lockTarget.data.bind_unit)
											and (eu.data.bind_weapon ~= lockTarget) and (eu ~= lockTarget.data.bind_weapon)
											and (eu.data.bind_lamp ~= lockTarget) and (eu ~= lockTarget.data.bind_lamp)
											and (eu.data.bind_light ~= lockTarget) and (eu ~= lockTarget.data.bind_light)
											and (eu.data.bind_wheel ~= lockTarget) and (eu ~= lockTarget.data.bind_wheel)
											and (eu.data.bind_shadow ~= lockTarget) and (eu ~= lockTarget.data.bind_shadow)
											and (eu.data.bind_energy ~= lockTarget) and (eu ~= lockTarget.data.bind_energy) then
												--print(eu.data.name, lockTarget.data.name)
												--我方的绑定单位
												if (eu.data.bind_weapon_owner ~= 0) then --枪
													local oHero = world:GetPlayerMe().heros[1]
													local oTank = oHero:getunit()
													if (eu.data.bind_weapon_owner == oTank) then --我方坦克绑定单位
														--print("我方坦克绑定单位", world.data.weapon_attack_state)
														if (world.data.weapon_attack_state > 0) then
															atttack_faceto(eu, lockTarget)
														end
													else
														--atttack_faceto(eu, lockTarget)
														atttack(eu, lockTarget)
													end
												else
													atttack(eu, lockTarget)
												end
											end
											
											--标记我方单位新的攻击时间点
											if (eu.data.bind_weapon_owner ~= 0) then --枪
												local oHero = world:GetPlayerMe().heros[1]
												local oTank = oHero:getunit()
												if (eu.data.bind_weapon_owner == oTank) then --我方坦克绑定单位
													--eu.attr.lastAttackTime = currenttime
												else
													eu.attr.lastAttackTime = currenttime
												end
											else
												eu.attr.lastAttackTime = currenttime
											end
											
											--本次攻击完毕，继续找目标
											--如果是主动攻击敌方单位（手动点敌人身上），敌人也没死，那么不需要重新寻找目标
											if (eu.data.lockType == 1) and (lockTarget.data.IsDead ~= 1) then
												--...
											else
												local findEnemy = AI_search_attack_target(eu) --重新找敌人
												
												--先取消原先的锁定
												--eu.data.lockTarget = 0
												--print("lockTarget = 0 4", eu.__ID)
												--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
												hApi.UnitTryToLockTarget(eu, 0, 0)
												--print("lockType 12", eu.data.name, 0)
												
												--检测原先锁定的，是否取消对小兵的锁定
												--检测目标是否也解除对小兵的锁定
												if (lockTarget.data.lockTarget == eu) then
													if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
														if (eu.attr.is_taunt ~= 1) then --我方单位不是嘲讽单位
															--lockTarget.data.lockTarget = 0
															--print("lockTarget = 0 3", lockTarget.__ID)
															--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
															hApi.UnitTryToLockTarget(lockTarget, 0, 0)
															--print("lockType 11", lockTarget.data.name, 0)
														end
													end
												end
												
												if findEnemy and (findEnemy ~= 0) then
													hApi.UnitTryToLockTarget(eu, findEnemy, 0)
													--eu.data.lockTarget = findEnemy --锁定新目标
													--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
													--print("lockType 10", eu.data.name, 0)
													
													--检测目标是否也锁定英雄
													if (findEnemy.data.lockTarget == 0) then
														hApi.UnitTryToLockTarget(findEnemy, eu, 0)
														--findEnemy.data.lockTarget = eu
														--findEnemy.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
														--print("lockType 9", findEnemy.data.name, 0)
													end
												end
											end
										else --最小攻击范围不能打
											--锁定的单位已出射程，那么该英雄设置为闲置
											if (eu.data.lockType == 1) then
												--如果是主动锁定了一个单位，这个单位在最小射程内，那么什么都不做
												--...
											else --锁定的单位已出射程，那么该英雄设置为闲置
												--eu.data.lockTarget = 0
												--print("lockTarget = 0 2", eu.__ID)
												--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
												hApi.UnitTryToLockTarget(eu, 0, 0)
												--print("lockType 8", eu.data.name, 0)
												
												--检测目标是否也解除对英雄的锁定
												if (lockTarget.data.lockTarget == eu) then
													if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
														if (eu.attr.is_taunt ~= 1) then --我方单位不是嘲讽单位
															--lockTarget.data.lockTarget = 0
															--print("lockTarget = 0 1", lockTarget.__ID)
															--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
															hApi.UnitTryToLockTarget(lockTarget, 0, 0)
															--print("lockType 7", lockTarget.data.name, 0)
														end
													end
												end
												
												--标记ai状态为闲置
												eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
											end
										end
									elseif hApi.CircleIntersectRect(defend_x, defend_y, defendRange + attackRange, lock_center_x, lock_center_y, lock_bw, lock_bh) then --在射程内
										--xlLG("attack", eu.data.name .. "_" .. eu.__ID .. " attack " .. lockTarget.data.name .. "_" .. lockTarget.__ID .. ", 在搜索范围内，发起移动. u_x=" .. eu_center_x .. ", u_y=" .. eu_center_y .. ", t_x=" .. lock_center_x .. ", t_y=" .. lock_center_y .. ".\n")
										--不在直接攻击的范围内，但是在搜敌范围内
										--英雄朝目标移动
										--设置ai状态为跟随
										eu:setAIState(hVar.UNIT_AI_STATE.FOLLOW)
										
										--英雄移动到达目标点(这里计算障碍)
										hApi.UnitMoveToTarget_TD(eu, lockTarget, attackRange - hVar.MOVE_EXTRA_DISTANCE, true) --24距离的缓冲
									else
										--xlLG("attack", eu.data.name .. "_" .. eu.__ID .. " attack " .. lockTarget.data.name .. "_" .. lockTarget.__ID .. ", 已出射程，取消锁定.\n")
										--锁定的单位已出射程，那么该英雄设置为闲置
										if (eu.data.lockType == 1) then
											--如果是主动锁定了一个单位，这个单位不在射程+守卫范围内，那么再次发起追踪
											--设置ai状态为跟随
											eu:setAIState(hVar.UNIT_AI_STATE.FOLLOW)
											
											--英雄移动到达目标点(这里计算障碍)
											hApi.UnitMoveToTarget_TD(eu, lockTarget, attackRange - hVar.MOVE_EXTRA_DISTANCE, true) --24距离的缓冲
										else --锁定的单位已出射程，那么该英雄设置为闲置
											--eu.data.lockTarget = 0
											--print("lockTarget = 0 2", eu.__ID)
											--eu.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
											hApi.UnitTryToLockTarget(eu, 0, 0)
											--print("lockType 8", eu.data.name, 0)
											
											--检测目标是否也解除对英雄的锁定
											if (lockTarget.data.lockTarget == eu) then
												if (lockTarget:GetAIAttribute() == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then --被动怪
													if (eu.attr.is_taunt ~= 1) then --我方单位不是嘲讽单位
														--lockTarget.data.lockTarget = 0
														--print("lockTarget = 0 1", lockTarget.__ID)
														--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
														hApi.UnitTryToLockTarget(lockTarget, 0, 0)
														--print("lockType 7", lockTarget.data.name, 0)
													end
												end
											end
											
											--标记ai状态为闲置
											eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
										end
									end
								else --无锁定的目标
									--标记ai状态为闲置
									eu:setAIState(hVar.UNIT_AI_STATE.IDLE)
								end
							end
						end
					elseif(aiState == hVar.UNIT_AI_STATE.STUN) then --无路点单位为眩晕状态
						--等到眩晕结束
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.MOVE_BY_TRACK) then --无路点单位为滑行状态
						--等到滑行结束
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.SLEEP) then --无路点单位为沉睡状态
						--等到沉睡结束
						--...
					elseif(aiState == hVar.UNIT_AI_STATE.REACHED) then --无路点单位为到达终点状态
						--无路点单位不会走到此AI状态里
						--...
					end
				end
			end
		end
	end
end

--依次遍历地图上的所有单位（无路点单位）（简易AI）
--world:enumunit(function(eu)
--检测到的单位的回调函数
local enumunit_callback_NoRoad_Unit_Simple = function(eu)
	local world = hGlobal.WORLD.LastWorldMap
	local regionId = world.data.randommapIdx --地图当前所在小关数
	local currenttime = world:gametime()
	
	local subType = eu.data.type --角色子类型
	--local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
	local aiState = eu:getAIState() --角色的AI状态
	--local roadPoint = eu:getRoadPoint() --角色的路点
	--local unitSide = eu:getowner() --角色的控制方
	
	--无路点单位
	if (eu:getRoadPointType() == hVar.ROLE_ROAD_POINT_TYPE.ROAD_POINT_NONE) then --无路点
		--非上帝
		if (eu.data.IsDead ~= 1) and (eu.attr.hp > 0) then --活着的单位
			--大菠萝效率优化
			--随机地图模式，如果当前单位不是本层的，不处理AI
			local regionIdBelong = eu.attr.regionIdBelong
			if (regionIdBelong == 0) or (regionIdBelong == regionId) then
				--敌方的英雄、塔单位
				if (eu.data.type == hVar.UNIT_TYPE.HERO) or (eu.data.type == hVar.UNIT_TYPE.TOWER) then
					enumunit_callback_NoRoad_Unit(eu)
				end
			end
		end
	end
end

--地图上的无路点单位的AI流程（无路点英雄、无路点小兵、无路点图腾）
function NoRoad_Unit_NormalAttackLoop()
	local world = hGlobal.WORLD.LastWorldMap
	
	--如果游戏暂停，直接跳出循环
	if (world.data.IsPaused == 1) then
		return
	end
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end
	
	--游戏暂停或结束，直接退出
	if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
		return
	end
	
	--禁止响应事件，不处理
	if (world.data.keypadEnabled ~= true) then
		return
	end
	
	--当前时间
	local currenttime = world:gametime()
	--local oPlayerMe = world:GetPlayerMe() --我的玩家对象
	--local nForceMe = oPlayerMe:getforce() --我的势力
	--local oNeutralPlayer = world:GetForce(nForceMe) --中立阵营玩家对象（蜀国/魏国）
	
	
	--[[
	--geyachao: 会出现怪卡住不攻击的问题，先注释掉看是否还会卡住？
	--首先，对我方单位进行AI管理（无路点单位）
	local rpgunits = world.data.rpgunits
	for u, u_worldC in pairs(rpgunits) do
		if (u:getworldC() == u_worldC) then
			enumunit_callback_NoRoad_Unit(u)
			
			--单位身上绑定的武器
			local euw = u.data.bind_weapon
			if euw and (euw ~= 0) then
				enumunit_callback_NoRoad_Unit(euw)
			end
		end
	end
	
	--其次，对我方主角坦克周围的敌人进行AI管理（无路点单位）
	local rpgunit_tank = world.data.rpgunit_tank
	if rpgunit_tank and (rpgunit_tank ~= 0) then
		--local hero_x, hero_y = hApi.chaGetPos(rpgunit_tank.handle) --坐标
		world:enumunitScreenEnemy(rpgunit_tank:getowner():getforce(), enumunit_callback_NoRoad_Unit)
	end
	
	--再对不在我方主角坦克周围的敌人进行AI管理（无路点单位）（简易AI）
	local rpgunit_tank = world.data.rpgunit_tank
	if rpgunit_tank and (rpgunit_tank ~= 0) then
		--local hero_x, hero_y = hApi.chaGetPos(rpgunit_tank.handle) --坐标
		world:enumunitScreenOutEnemy(rpgunit_tank:getowner():getforce(), enumunit_callback_NoRoad_Unit_Simple)
	end
	]]
	world:enumunit(enumunit_callback_NoRoad_Unit)
end

--地图上坦克武器的自动攻击
function tank_weapon_attack_loop()
	local world = hGlobal.WORLD.LastWorldMap
	
	--如果游戏暂停，直接跳出循环
	if (world.data.IsPaused == 1) then
		return
	end
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end
	
	--游戏暂停或结束，直接退出
	if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
		return
	end
	
	--禁止响应事件，不处理
	if (world.data.keypadEnabled ~= true) then
		return
	end
	
	--当前时间
	local currenttime = world:gametime()
	--local oPlayerMe = world:GetPlayerMe() --我的玩家对象
	--local nForceMe = oPlayerMe:getforce() --我的势力
	--local oNeutralPlayer = world:GetForce(nForceMe) --中立阵营玩家对象（蜀国/魏国）
	
	--在攻击状态
	if (world.data.weapon_attack_state > 0) then
		--遍历我方单位
		local rpgunits = world.data.rpgunits
		for u, u_worldC in pairs(rpgunits) do
			if (u:getworldC() == u_worldC) then
				local eu = u.data.bind_weapon
				if eu and (eu ~= 0) then
					local lasttime = eu.attr.lastAttackTime --上次攻击的时间
					local deltatime = currenttime - lasttime --距离上次攻击间隔的时间
					local atk_interval = eu:GetAtkInterval() --小兵的攻击间隔
						
					--过了攻击间隔
					if (deltatime >= atk_interval) then
						--施法前检测魔法是否够
						local mana = hGlobal.LocalPlayer:getmana()
						local weaponItemid = hGlobal.LocalPlayer:getweaponitem()
						local manaCost = hVar.tab_item[weaponItemid].mana or 0
						if (manaCost <= mana) then --魔法够
							local lockTarget = eu.data.lockTarget
							local result = atttack(eu, lockTarget)
							--print("result=", result)
							if (result == hVar.RESULT_SUCESS) then
								hGlobal.LocalPlayer:setmana(mana - manaCost)
								
								--标记攻击时间
								eu.attr.lastAttackTime = currenttime
							end
						end
					end
				elseif (u.data.is_fenshen == 1) then --正在变身期间
					local lasttime = u.attr.lastAttackTime --上次攻击的时间
					local deltatime = currenttime - lasttime --距离上次攻击间隔的时间
					local atk_interval = u:GetAtkInterval() --小兵的攻击间隔
						
					--过了攻击间隔
					if (deltatime >= atk_interval) then
						--local lockTarget = u.data.lockTarget
						local result = atttack(u, u)
						--print("result=", result)
						if (result == hVar.RESULT_SUCESS) then
							--标记攻击时间
							u.attr.lastAttackTime = currenttime
						end
					end
				end
			end
		end
	end
end

--地图上的塔、建筑自动攻击
local _towns = {} --优化
function building_town_attack_loop()
	--遍历大地图上的每个角色
	local world = hGlobal.WORLD.LastWorldMap
	
	--如果游戏暂停，直接跳出循环
	if (world.data.IsPaused == 1) then
		return
	end
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end

	--游戏暂停或结束，直接退出
	if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
		return
	end
	
	--禁止响应事件，不处理
	if (world.data.keypadEnabled ~= true) then
		return
	end
	
	--当前时间
	local currenttime = world:gametime()
	--local oPlayerMe = world:GetPlayerMe() --我的玩家对象
	--local nForceMe = oPlayerMe:getforce() --我的势力
	--local oNeutralPlayer = world:GetForce(nForceMe) --中立阵营玩家对象（蜀国/魏国）
	
	--可攻击的塔和建筑
	--local _towns = {}
	for i = #_towns, 1, -1 do
		_towns[i] = nil
	end
	
	--只处理坦克周围的塔的自动攻击
	local rpgunit_tank = world.data.rpgunit_tank
	if rpgunit_tank and (rpgunit_tank ~= 0) then
		local hero_x, hero_y = hApi.chaGetPos(rpgunit_tank.handle) --坐标
		world:enumunit(function(eu)
		--world:enumunitAreaEnemy(rpgunit_tank:getowner():getforce(), hero_x, hero_y, hVar.ENEMY_AI_RADIUS, function(eu)
			--local subType = eu.data.type --角色子类型
			--if (subType == hVar.UNIT_TYPE.BUILDING) then --建筑类型
			--local isTower = hVar.tab_unit[eu.data.id].isTower or 0 --是否为塔
			if (eu.data.type == hVar.UNIT_TYPE.TOWER) or (eu.data.type == hVar.UNIT_TYPE.BUILDING) then --塔类型
				--local unitSide = eu:getowner() --角色的控制方
				
				--非上帝
				--if (eu ~= mapInfo.godUnit) then --不是上帝
					--if hVar.tab_unit[eu.data.id].attr then
					--	eu.attr.attack = hVar.tab_unit[eu.data.id].attr.attack
					--end
					
					local lasttime = eu.attr.lastAttackTime --上次攻击的时间
					local lasttime_adjust = eu.attr.lastAttackTime_adjust --上次攻击的时间修正值
					local deltatime = currenttime - lasttime - lasttime_adjust --距离上次攻击间隔的时间
					local atk_interval = eu:GetAtkInterval() --塔的攻击间隔
					
					--过了攻击间隔、并且塔有攻击力、塔没被眩晕、塔没透明（不能普碰撞）
					if (deltatime >= atk_interval) and (eu.attr.attack[5] > 0) and (eu.attr.stun_stack <= 0) and (eu.attr.suffer_touming_stack <= 0) then
						--table.insert(_towns, eu)
						_towns[#_towns+1] = eu
					end
				--end
			end
		end)
		
		--遍历所有可攻击的塔，依次检测攻击
		--for k, oTown in ipairs(_towns) do
		for i = 1, #_towns, 1 do
			local oTown = _towns[i]
			--print(i, oTown.data.name)
			local findEnemy = AI_tower_search_attack_target(oTown) --找敌人
			
			--在攻击范围内
			if findEnemy and (findEnemy ~= 0) then
				--塔发起普通攻击
				atttack(oTown, findEnemy) --普通攻击
				
				--锁定目标
				hApi.UnitTryToLockTarget(oTown, findEnemy, 0)
				--oTown.data.lockTarget = findEnemy
				--oTown.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
				--print("lockType 36", oTown.data.name, 0)
				
				--目标不用处理锁定，因为攻击者是塔
				--...
				
				local lasttime = oTown.attr.lastAttackTime --上次攻击的时间
				local lasttime_adjust = oTown.attr.lastAttackTime_adjust --上次攻击的时间修正值
				local deltatime = currenttime - lasttime - lasttime_adjust --距离上次攻击间隔的时间
				local atk_interval = oTown:GetAtkInterval() --塔的攻击间隔
				
				--标记新的攻击时间
				oTown.attr.lastAttackTime = currenttime
				
				--标记新的攻击时间修正值
				local adjust = deltatime - atk_interval
				--if (adjust > atk_interval) then
				if (adjust > world.data.tick_time) then --误差最多为16毫秒
					adjust = 0
				end
				oTown.attr.lastAttackTime_adjust = -adjust
			else
				--锁定目标为空
				--oTown.data.lockTarget = 0
				--print("lockTarget = 0 47", oTown.__ID)
				--oTown.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
				hApi.UnitTryToLockTarget(oTown, 0, 0)
				--print("lockType 35", oTown.data.name, 0)
				
				--目标也不用解除锁定塔
				--...
				
				--标记新的攻击时间修正值
				oTown.attr.lastAttackTime_adjust = 0
			end
		end
	end
end

--英雄自动吸取附近的道具
function hero_auto_seek_oitem()
	--遍历大地图上的每个角色
	local world = hGlobal.WORLD.LastWorldMap
	
	--如果游戏暂停，直接跳出循环
	if (world.data.IsPaused == 1) then
		return
	end
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end
	
	--游戏暂停或结束，直接退出
	if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
		return
	end
	
	--禁止响应事件，不处理
	if (world.data.keypadEnabled ~= true) then
		return
	end
	
	--当前时间
	local currenttime = world:gametime()
	--local oPlayerMe = world:GetPlayerMe() --我的玩家对象
	--local nForceMe = oPlayerMe:getforce() --我的势力
	--local oNeutralPlayer = world:GetForce(nForceMe) --中立阵营玩家对象（蜀国/魏国）
	
	--是否提示拾取道具
	local bNoticeWeapon = false
	
	--我方的英雄
	local heros = world:GetPlayerMe().heros
	--print("hero=", hero)
	if heros then
		local oHero = heros[1]
		if oHero then
			local oUnit = oHero:getunit()
			if oUnit then
				if (oUnit.data.IsDead ~= 1) then
					local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --坐标
					local hero_bx, hero_by, hero_bw, hero_bh = oUnit:getbox() --包围盒
					local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --中心点x位置
					local hero_center_y = hero_y + (hero_by + hero_bh / 2) --中心点y位置
					
					local rMax = 70
					world:enumunitArea(nil, hero_center_x, hero_center_y, rMax, function(eu)
						if (eu.data.type == hVar.UNIT_TYPE.ITEM) then --道具
							local itemId = eu:getitemid()
							local isWeapon = 0 --是否是武器道具（武器需要手动拾取）
							if (itemId > 0) then
								isWeapon = hVar.tab_item[itemId].isWeapon
							end
							
							--geyachao: 大菠萝，新版本不换武器了
							--[[
							if (isWeapon == 1) then
								--提示拾取
								hGlobal.LocalPlayer:noticeweapon(eu)
								bNoticeWeapon = true
							else
								--拾取道具
								hVar.CmdMgr[hVar.Operation.PickUpItem](world.data.sessionId, oUnit:getowner(), oUnit:getworldI(), oUnit:getworldC(), eu:getworldI(), eu:getworldC())
							end
							]]
							--wangcheng: 连斩奖励
							if type(hVar.ContinuousKillingItemAward[itemId]) == "table" then
								hApi.PlaySound("ShootSelect")
								hGlobal.event:event("GetContinuousKillingAward", eu, oUnit)
							end
							--拾取道具
							hVar.CmdMgr[hVar.Operation.PickUpItem](world.data.sessionId, oUnit:getowner(), oUnit:getworldI(), oUnit:getworldC(), eu:getworldI(), eu:getworldC())
						end
					end)
				end
			end
		end
	end
	
	if (not bNoticeWeapon) then
		hGlobal.LocalPlayer:noticeweapon(nil)
	end
end

--英雄自动吸取附近的人质
function hero_auto_seek_hostage()
	--遍历大地图上的每个角色
	local world = hGlobal.WORLD.LastWorldMap
	
	--如果游戏暂停，直接跳出循环
	if (world.data.IsPaused == 1) then
		return
	end
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end
	
	--游戏暂停或结束，直接退出
	if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
		return
	end
	
	--禁止响应事件，不处理
	if (world.data.keypadEnabled ~= true) then
		return
	end
	
	--当前时间
	local currenttime = world:gametime()
	--local oPlayerMe = world:GetPlayerMe() --我的玩家对象
	--local nForceMe = oPlayerMe:getforce() --我的势力
	--local oNeutralPlayer = world:GetForce(nForceMe) --中立阵营玩家对象（蜀国/魏国）
	
	--我方的英雄
	local heros = world:GetPlayerMe().heros
	--print("hero=", hero)
	if heros then
		local oHero = heros[1]
		if oHero then
			local oUnit = oHero:getunit()
			if oUnit then
				if (oUnit.data.IsDead ~= 1) then
					local hero_x, hero_y = hApi.chaGetPos(oUnit.handle) --坐标
					local hero_bx, hero_by, hero_bw, hero_bh = oUnit:getbox() --包围盒
					local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --中心点x位置
					local hero_center_y = hero_y + (hero_by + hero_bh / 2) --中心点y位置
					
					local rMax = 100
					local rpgunits = world.data.rpgunits
					for eu, u_worldC in pairs(rpgunits) do
						if (eu:getworldC() == u_worldC) then
							if (((eu.data.type == hVar.UNIT_TYPE.HERO) or (eu.data.type == hVar.UNIT_TYPE.UNIT)) and eu.data.IsDead ~= 1) then --小兵
								if (eu.data.id ~= hVar.MY_TANK_ID) and (eu.data.id ~= hVar.MY_TANK_FOLLOW_ID[1]) and (eu.data.id ~= hVar.MY_TANK_FOLLOW_ID[2]) and (eu.data.id ~= hVar.MY_TANK_FOLLOW_ID[3])
								and (eu.data.id ~= hVar.MY_TANK_FOLLOW_ID[4]) and (eu.data.id ~= hVar.MY_TANK_FOLLOW_ID[5]) and (eu.data.id ~= hVar.MY_TANK_FOLLOW_ID[6]) and (eu.data.id ~= hVar.MY_TANK_FOLLOW_ID[7])
								and (eu.data.id ~= hVar.MY_TANK_FOLLOW_ID[8]) and (eu.data.id ~= hVar.MY_TANK_FOLLOW_ID[9]) and (eu.data.id ~= hVar.MY_TANK_FOLLOW_ID[10]) then
									if (eu.data.id == 11209) then --geyachao: 只吸科学家
										--print("检测人质", eu.data.name)
										local ex, ey = hApi.chaGetPos(eu.handle) --坐标
										local dx = hero_center_x - ex
										local dy = hero_center_y - ey
										local dd = math.sqrt(dx * dx + dy * dy)
										
										if (dd <= rMax) then
											local screenX, screenY = hApi.world2view(ex, ey)
											hGlobal.event:event("Event_UpdateRescuedPerson",screenX, screenY)
											--冒字
											--hApi.ShowLabelBubble(oUnit, "RESCUE SUCCESS!", ccc3(0, 255, 0), 0, 36, nil, 1000)
											
											--播放营救音效
											hApi.PlaySound("Button2")
											
											eu.data.IsDead = 1
											
											eu.handle.s:runAction(CCFadeIn:create(0.2))
											hApi.addTimerOnce("delrpgunit"..world.data.statistics_rescue_num + 1,300,function()
												--删除人质
												eu:del()
											end)
											
											
											--统计大菠萝营救的科学家数量（累计数据）
											world.data.statistics_rescue_num = world.data.statistics_rescue_num + 1
											--单局数据
											world.data.statistics_rescue_count = world.data.statistics_rescue_count + 1

											hGlobal.event:event("Event_GetSource","scientist",1,{oUnit = eu})
											
											--[[
											--添加道具
											local id = 12010 --掉落的道具id
											local tabI = hVar.tab_item[id]
											local uId = tabI.dropUnit or 20001
											
											local deadUnitX, deadUnitY = ex, ey --死亡的单位的坐标
											--local gridX, gridY = oWorld:xy2grid(deadUnitX, deadUnitY)
											local gridX, gridY = deadUnitX, deadUnitY
											
											local radius = 120
											
											local r = world:random(12, radius) --随机偏移半径
											
											local face = world:random(0, 360)
											local fangle = face * math.pi / 180 --弧度制
											fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
											local dx = r * math.cos(fangle) --随机偏移值x
											local dy = r * math.sin(fangle) --随机偏移值y
											dx = math.floor(dx * 100) / 100  --保留2位有效数字，用于同步
											dy = math.floor(dy * 100) / 100  --保留2位有效数字，用于同步
											
											gridX = gridX + dx --随机x位置
											gridY = gridY + dy --随机y位置
											gridX, gridY = hApi.Scene_GetSpace(gridX, gridY, 60)
											
											--local forcePlayer = world:GetForce(oKillerSide)
											--local owner = forcePlayer:getpos()
											
											--print("world:dropunit:",id,oKillerPos,face,gridX,gridY)
											local oItem = world:addunit(uId, 1,nil,nil,face,gridX,gridY,nil,nil)
											oItem:setitemid(id)
											mapInfo.dropNum = mapInfo.dropNum + 1
											--local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(1.0, 1.1), CCScaleTo:create(1.0, 1.0))
											--oItem.handle._n:runAction(CCRepeatForever:create(towAction))
											--print(oItem, oItem.data.name)
											
											--设置生存时间
											local livetime = hVar.tab_item[id].dropUnitLivetime
											if livetime and (livetime > 0) then
												oItem:setLiveTime(livetime)
											end
											
											--淡入动画效果
											if livetime and (livetime > 0) then
												if oItem.handle.s then
													local act1 = CCEaseSineOut:create(CCFadeIn:create(1.0)) --淡入
													local actDelay = CCDelayTime:create(livetime/1000-5)
													local act2 = CCFadeOut:create(0.5)
													local act3 = CCFadeIn:create(0.5)
													local act4 = CCFadeOut:create(0.5)
													local act5 = CCFadeIn:create(0.5)
													local act6 = CCFadeOut:create(0.5)
													local act7 = CCFadeIn:create(0.5)
													local act8 = CCFadeOut:create(0.5)
													local act9 = CCFadeIn:create(0.5)
													local a = CCArray:create()
													a:addObject(act1)
													a:addObject(actDelay)
													a:addObject(act2)
													a:addObject(act3)
													a:addObject(act4)
													a:addObject(act5)
													a:addObject(act6)
													a:addObject(act7)
													a:addObject(act8)
													a:addObject(act9)
													local sequence = CCSequence:create(a)
													oItem.handle.s:runAction(CCRepeatForever:create(sequence))
												end
											end
											]]
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
end

--地图上的单位自动变色
function UnitColorChangeLoop(deltaTime)
	--遍历大地图上的每个角色
	local world = hGlobal.WORLD.LastWorldMap
	
	if (hVar.IS_SHOW_HIT_EFFECT_FLAG ~= 1) then --开关控制
		return
	end
	
	--如果游戏暂停，直接跳出循环
	if (world.data.IsPaused == 1) then
		return
	end
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end
	
	--游戏暂停或结束，直接退出
	if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
		return
	end
	
	--禁止响应事件，不处理
	if (world.data.keypadEnabled ~= true) then
		return
	end
	
	--当前时间
	local currenttime = world:gametime()
	--依次遍历所有单位，检测：如果该单位锁定的目标，是否锁定的目标是否也要锁定该单位
	world:enumunit(function(eu)
		local d = eu.data
		local colorInRender = d.colorInRender --是否变色中
		local color = d.color --RGB值
		local red = color[1]
		local green = color[2]
		local blue = color[3]
		local interval = deltaTime * 2 --变化速率
		
		if (colorInRender == 1) then --正向变色中
			local redTo = math.min(red + interval, 254)
			local greenTo = math.max(green - interval, 0)
			local blueTo = math.max(blue - interval, 0)
			
			color[1] = redTo
			color[2] = greenTo
			color[3] = blueTo
			
			eu.handle.s:setColor(ccc3(redTo, greenTo, blueTo))
			
			if (redTo == 254) and (greenTo == 0) and (blueTo == 0) then
				d.colorInRender = -1
			end
		elseif (colorInRender == -1) then --反向变色中
			local redTo = math.min(red + interval, 254)
			local greenTo = math.min(green + interval, 254)
			local blueTo = math.min(blue + interval, 254)
			
			color[1] = redTo
			color[2] = greenTo
			color[3] = blueTo
			
			eu.handle.s:setColor(ccc3(redTo, greenTo, blueTo))
			
			if (redTo == 254) and (greenTo == 254) and (blueTo == 254) then
				d.colorInRender = 0
				
				--[[
				local tabU = hVar.tab_unit[eu.data.id]
				if (type(tabU.color) == "table") then
					d.color = {tabU.color[1], tabU.color[2], tabU.color[3]}
				else
					d.color = {254,254,254}
				end
				]]
				d.color = {d.color_origin[1], d.color_origin[2], d.color_origin[3]}
				
				eu.handle.s:setColor(ccc3((d.color[1] or 254),(d.color[2] or 254),(d.color[3] or 254)))
			end
		else --不变色
			--
		end
	end)
end

--检测锁定的目标，是否也要锁定单位
function AI_LockTargetCheckLoop()
	local world = hGlobal.WORLD.LastWorldMap
	
	--如果游戏暂停，直接跳出循环
	if (world.data.IsPaused == 1) then
		return
	end
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end
	
	--游戏暂停或结束，直接退出
	if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
		return
	end
	
	--依次遍历所有单位，检测：如果该单位锁定的目标，是否锁定的目标是否也要锁定该单位
	world:enumunit(function(eu)
		local lockTarget = eu.data.lockTarget --锁定的目标
		if (lockTarget ~= 0) then
			local t_aiAttribute = lockTarget:GetAIAttribute() --目标的AI行为
			
			--单位不是隐身（隐身的单位不能被敌人看到）
			if (eu:GetYinShenState() == 0) then
				--只处理被动怪目标
				if (t_aiAttribute == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then
					if (lockTarget.data.lockTarget == 0) then --目标没锁定的对象
						if (lockTarget.attr.attack[5] > 0) then --目标是否有攻击力
							if (hApi.IsSkillTargetValid(lockTarget, eu, lockTarget.attr.attack[1]) == hVar.RESULT_SUCESS) then --目标是否可以攻击到单位
								--检测是否角色在目标的搜敌范围内
								--取锁定的目标的中心位置
								--[[
								local hero_x, hero_y = hApi.chaGetPos(lockTarget.handle) --锁定的目标的坐标
								local hero_bx, hero_by, hero_bw, hero_bh = lockTarget:getbox() --锁定的目标的包围盒
								local hero_center_x = hero_x + (hero_bx + hero_bw / 2) --锁定的目标的中心点x位置
								local hero_center_y = hero_y + (hero_by + hero_bh / 2) --锁定的目标的中心点y位置
								]]
								--geyachao: 改为脚底板的坐标
								--local hero_center_x, hero_center_y = hApi.chaGetPos(lockTarget.handle) --锁定的目标的坐标
								--geyachao: 改为守卫坐标
								local defend_x, defend_y = lockTarget.data.defend_x, lockTarget.data.defend_y --锁定的目标的坐标
								local defendRange = lockTarget.data.defend_distance_max --锁定目标的守卫范围
								local attackRange = lockTarget:GetAtkRange() --锁定目标的攻击范围
								
								--取角色的中心点位置
								--[[
								local eu_x, eu_y = hApi.chaGetPos(eu.handle)
								local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --角色的包围盒
								local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --角色的中心点x位置
								local eu_center_y = eu_y + (eu_by + eu_bh / 2) --角色的中心点y位置
								]]
								--geyachao: 改为脚底板的坐标
								local eu_center_x, eu_center_y = hApi.chaGetPos(eu.handle)
								local eu_bw, eu_bh = hVar.ROLE_COLLISION_EDGE, hVar.ROLE_COLLISION_EDGE
								
								--判断矩形和圆是否相交
								--是否直接在小兵的守卫范围内
								if hApi.CircleIntersectRect(defend_x, defend_y, attackRange + defendRange, eu_center_x, eu_center_y, eu_bw, eu_bh) then --在射程内
									local bEnableSpaceAtk = true --空间上是否可以攻击
									
									--检测攻击者可攻击的空间的类型和目标的空间类型
									local unit_atk_space_type = lockTarget.attr.atk_space_type --攻击者可攻击的空间的类型
									if (unit_atk_space_type ~= hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL) then --如果攻击者可攻击目标的空间的类型不是全部类型都可以的话，再进一步检测
										local target_space_type = eu:GetSpaceType() --目标的空间类型
										
										--攻击者只能攻击地面单位，而目标是空中单位，那么直接返回
										if (unit_atk_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_GROUND) and (target_space_type == hVar.UNIT_SPACE_TYPE.SPACE_FLY) then
											bEnableSpaceAtk = false
										end
										
										--攻击者只能攻击空中单位，而目标是地面单位，那么直接返回
										if (unit_atk_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_FLY) and (target_space_type == hVar.UNIT_SPACE_TYPE.SPACE_GROUND) then
											bEnableSpaceAtk = false
										end
									end
									
									--在空间上可以攻击到
									if bEnableSpaceAtk then
										--标记锁定
										hApi.UnitTryToLockTarget(lockTarget, eu, 0)
										--lockTarget.data.lockTarget = eu
										--lockTarget.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
										--print("lockType 21", lockTarget.data.name, 0)
										
										--目标也锁定它（已经锁定它了，不要写额外的代码）
										--...
									end
								end
							end
						end
					end
				end
			end
		end
	end)
end

--AI自动攻击优化：我方的单位，尽可能的平摊攻击的敌人目标
function AI_AttackOptmiseLoop()
	local world = hGlobal.WORLD.LastWorldMap
	
	--如果游戏暂停，直接跳出循环
	if (world.data.IsPaused == 1) then
		return
	end
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end
	
	--游戏暂停或结束，直接退出
	if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
		return
	end
	
	--local oPlayerMe = world:GetPlayerMe() --我的玩家对象
	--local nForceMe = oPlayerMe:getforce() --我的势力
	--local oNeutralPlayer = world:GetForce(nForceMe) --中立阵营玩家对象（蜀国/魏国）
	
	--依次遍历所有单位，检测我方单位（英雄或小兵）是否有空闲的敌方单位来攻击
	world:enumunit(function(eu)
		--if (eu:getowner() == oPlayerMe) or (eu:getowner() == oNeutralPlayer) then --我方、中立单位
			local aiState = eu:getAIState() --角色的AI状态
			
			if (aiState == hVar.UNIT_AI_STATE.ATTACK) or (aiState == hVar.UNIT_AI_STATE.FOLLOW) then --跟随或者攻击中
				local subType = eu.data.type --角色子类型
				
				if (subType == hVar.UNIT_TYPE.UNIT) or (subType == hVar.UNIT_TYPE.HERO) then --英雄或者小兵
					local lockTarget = eu.data.lockTarget --锁定的目标
					local lockType = eu.data.lockType --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
					
					if (lockTarget ~= 0) and (lockType == 0) then --有锁定的目标，并且是被动锁定
						if (lockTarget.data.lockTarget ~= 0) and (lockTarget.data.lockTarget ~= eu) then --锁定的目标，也锁定了人，并且不是锁定自己
							--开始寻找，是否存在空闲的敌方单位
							local emptyEnemy = 0 --空闲的敌方单位
							
							--同样按照优先级，找敌人
							local _, targetTable = AI_search_attack_target(eu)
							for i = 1, targetTable.num, 1 do
								local ui = targetTable[i].unit --单位i
								if ui and (ui ~= 0) and (ui ~= lockTarget) then --不同的锁定单位
									if (ui.data.lockTarget == 0) or (ui.data.lockTarget.data.lockTarget ~= ui) then --该单位i当前不是和它锁定的人对打
										--当前也没有单位锁定这个单位i
										local bHaveLockThis = false
										--world:enumunit(function(eeu)
										local ui_x, ui_y = hApi.chaGetPos(ui.handle) --位置
										world:enumunitArea(nil, ui_x, ui_y, 300, function(eeu)
											--非建筑、塔、图腾、武器单位
											if (eeu.data.type ~= hVar.UNIT_TYPE.BUILDING) and (eeu.data.type ~= hVar.UNIT_TYPE.TOWER) and (eeu.data.type ~= hVar.UNIT_TYPE.NPC)
											and (eeu.data.type ~= hVar.UNIT_TYPE.NPC_TALK) and (eeu.data.type ~= hVar.UNIT_TYPE.HERO_TOKEN) and (eeu.data.type ~= hVar.UNIT_TYPE.UNITGUN) then --建筑、塔、图腾锁定的不算
												if (eeu.data.lockTarget == ui) then
													bHaveLockThis = true --有单位锁定该单位i
												end
											end
										end)
										
										--当前也没有单位锁定这个单位i
										if (not bHaveLockThis) then
											emptyEnemy = ui
											break
										end
									end
								end
							end
							
							--找到了
							if emptyEnemy and (emptyEnemy ~= 0) then
								--找到的空闲不是，和当前锁定的不是同一个目标
								if (emptyEnemy ~= lockTarget) then
									--角色停下来
									--print("->hApi.UnitStop_TD------ 1")
									--hApi.UnitStop_TD(eu)
									
									--设置ai状态为跟随
									--eu:setAIState(hVar.UNIT_AI_STATE.FOLLOW)
									
									--锁定新目标
									--eu.data.lockTarget = emptyEnemy
									hApi.UnitTryToLockTarget(eu, emptyEnemy, 0)
									--原目标不需要解除对他的锁定
									--...
									
									--目标也锁定角色
									--这里为了优化，强制敌人目标也锁定它，那么可以行成一一对应
									if (emptyEnemy.data.lockType ~= 1) then --非主动锁定
										hApi.UnitTryToLockTarget(emptyEnemy, eu, 0)
										--emptyEnemy.data.lockTarget = eu
										--emptyEnemy.data.lockType = 0 --锁定攻击的类型(0:被动锁定 / 1:主动锁定)
										--print("lockType 49", emptyEnemy.data.name, 0)
									end
									
									--标记角色状态为跟随
									--动到达目标点(这里计算障碍)
									--local attackRange = eu:GetAtkRange() --我方单位的攻击范围
									--hApi.UnitMoveToTarget_TD(eu, emptyEnemy, attackRange - hVar.MOVE_EXTRA_DISTANCE, true) --24距离的缓冲
								end
							end
						end
					end
				end
			end
		--end
	end)
end

--AI自动攻击优化：敌方单位，如果在攻击同一个目标，检测是否重叠在一起（散开）
local tTargetLockingEnemys = {} --geyachao: 内存优化
local _sortt = {}
function AI_EnemyAttackCollapse()
	local world = hGlobal.WORLD.LastWorldMap
	
	--如果游戏暂停，直接跳出循环
	if (world.data.IsPaused == 1) then
		return
	end
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end
	
	--游戏暂停或结束，直接退出
	if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
		return
	end
	
	--local oPlayerMe = world:GetPlayerMe() --我的玩家对象
	--local nForceMe = oPlayerMe:getforce() --我的势力
	--local oNeutralPlayer = world:GetForce(nForceMe) --中立阵营玩家对象（蜀国/魏国）
	
	--先检测一遍，将所有敌人正在攻击的嘲讽目标组成表
	for k in pairs(tTargetLockingEnemys) do
		tTargetLockingEnemys[k] = nil
	end
	world:enumunit(function(eu)
		--if (eu:getowner() ~= oPlayerMe) and (eu:getowner() ~= oNeutralPlayer) then --敌方阵营
			if (eu:getAIState() == hVar.UNIT_AI_STATE.ATTACK) then --角色的AI状态：正在攻击
				if (eu.data.type ~= hVar.UNIT_TYPE.BUILDING) and (eu.data.type ~= hVar.UNIT_TYPE.TOWER) and (eu.data.type ~= hVar.UNIT_TYPE.NPC) and (eu.data.type ~= hVar.UNIT_TYPE.NPC_TALK)
				and (eu.data.type ~= hVar.UNIT_TYPE.HERO_TOKEN) and (eu.data.type ~= hVar.UNIT_TYPE.UNITGUN) and (eu.data.type ~= hVar.UNIT_TYPE.PLAYER_INFO)
				and (eu.data.type ~= hVar.UNIT_TYPE.WAY_POINT) then --非建筑、塔、替换物、武器、出生点、路点
					--有效的敌人
					local lockTarget = eu.data.lockTarget --敌人正在锁定们的目标
					if (lockTarget ~= 0) then
						if (lockTarget.attr.is_taunt == 1) and (lockTarget.attr.taunt_need_collapse == 1) then --只处理嘲讽类型，需要围成一圈的单位
							if tTargetLockingEnemys[lockTarget] then
								tTargetLockingEnemys[lockTarget][#tTargetLockingEnemys[lockTarget] + 1] = eu
								--table.insert(tTargetLockingEnemys[lockTarget], eu)
							else
								tTargetLockingEnemys[lockTarget] = {eu}
							end
						end
					end
				end
			end
		--end
	end)
	
	--local _sortt = {}
	for i = #_sortt, 1, -1 do
		_sortt[i] = nil
	end
	for lockTarget, enemyList in pairs(tTargetLockingEnemys) do
		_sortt[#_sortt + 1] = {lockTarget, enemyList}
	end
	
	--排序
	table.sort(_sortt, function(ca, cb)
		return (ca[1].__ID < cb[1].__ID)
	end)
	
	local COLL_DIST = 48 --判定重合的距离
	--检查有多个敌人攻击同一个目标的情况
	for i = 1, #_sortt, 1 do
	--for lockTarget, enemyList in ipairs(_sortt) do
		local lockTarget = _sortt[i][1]
		local enemyList = _sortt[i][2]
		if (#enemyList > 1) then
			local target_x, target_y = hApi.chaGetPos(lockTarget.handle) --目标的位置
			
			for j = 2, #enemyList, 1 do
				local enemyj = enemyList[j] --敌人j
				local enemy_xj, enemy_yj = hApi.chaGetPos(enemyj.handle)
				
				--j依次和前面的敌人i比，是否有重合的
				for i = 1, j - 1, 1 do
					local enemyi = enemyList[i] --敌人i
					local enemy_xi, enemy_yi = hApi.chaGetPos(enemyi.handle)
					
					--敌人i和敌人j的距离
					local dx_ij = enemy_xi - enemy_xj
					local dy_ij = enemy_yi - enemy_yj
					local distance_ij = math.floor(math.sqrt(dx_ij * dx_ij + dy_ij * dy_ij) * 100) / 100 --敌人i和敌人j的距离，保留2位有效数字，用于同步
					if (distance_ij <= COLL_DIST) then --重叠了
						--j沿着当前位置旋转，到一个不重合的位置（如果一圈下来还是找不到，那么j往里转一圈继续该循环）
						--print("j沿着当前位置旋转，到一个不重合的位置", j, i)
						local dx_t = enemy_xj - target_x --敌人j和目标的x距离
						local dy_t = enemy_yj - target_y --敌人j和目标的y距离
						local dis_t = math.floor(math.sqrt(dx_t * dx_t + dy_t * dy_t) * 100) / 100 --敌人j和目标的距离（如果一圈下来还是找不到，那么j往里走一点），保留2位有效数字，用于同步
						local angle = GetLineAngle(target_x, target_y, enemy_xj, enemy_yj)
						
						--j寻找一个新的不重叠i的位置
						local no_collpase_jx = 0
						local no_collpase_jy = 0
						
						--随机顺时针或者逆时针
						local adjust_direction = enemyj.data.adjust_direction
						local angle_end = 0
						local angle_delta = math.floor(360 / (2 * math.pi * dis_t / COLL_DIST) * 100) / 100 --圆周按照COLL_DIST的步长，平均分成多块，保留2位有效数字，用于同步
						--print("angle_delta=" .. angle_delta)
						if (adjust_direction == 1) then
							angle_end = angle + 360
							angle_delta = angle_delta
						else
							angle_end = angle - 360
							angle_delta = -angle_delta
						end
						
						--一直循环
						while true do
							for a = angle, angle_end, angle_delta do
								local fa = math.floor(a * math.pi / 180 * 100) / 100 --弧度制，保留2位有效数字，用于同步
								--local tdx = math.floor(dis_t * math.cos(fa) * 100) / 100  --保留2位有效数字，用于同步
								--local tdy = math.floor(dis_t * math.sin(fa) * 100) / 100  --保留2位有效数字，用于同步
								local tdx = math.floor(dis_t * hApi.Math.Cos(a) * 100) / 100  --保留2位有效数字，用于同步
								local tdy = math.floor(dis_t * hApi.Math.Sin(a) * 100) / 100  --保留2位有效数字，用于同步
								local to_xj = target_x + tdx
								local to_yj = target_y + tdy
								
								--检测该位置是否可以达
								local waypoint = nil
								if (to_xj > 0) and (to_yj > 0) then
									waypoint = xlCha_MoveToGrid(enemyj.handle._c, to_xj / 24, to_yj / 24, 0, nil)
								end
								--print(enemy_xj, enemy_yj, to_xj, to_yj, waypoint[0])
								if waypoint and (waypoint[0] > 0) then --寻路成功
									--和前面所有的敌人(1~j-1)们是否重叠
									for k = 1, j - 1, 1 do
										local enemyk = enemyList[k] --敌人k
										local enemy_xk, enemy_yk = hApi.chaGetPos(enemyk.handle)
										local dx_to_ik = enemy_xk - to_xj
										local dy_to_ik = enemy_yk - to_yj
										local distance_to_jk = math.floor(math.sqrt(dx_to_ik * dx_to_ik + dy_to_ik * dy_to_ik) * 100) / 100 --敌人i和敌人j新的距离，保留2位有效数字，用于同步
										if (distance_to_jk > COLL_DIST) then
											no_collpase_jx = to_xj
											no_collpase_jy = to_yj
											--print("和前面所有的敌人(1~j-1)们是否重叠", j, i, k)
											break
										end
									end
									
									if (no_collpase_jx ~= 0) and (no_collpase_jy ~= 0) then --找到了
										break
									end
								end
							end
							
							if (no_collpase_jx ~= 0) and (no_collpase_jy ~= 0) then --找到了
								--敌人j挪动位置
								--标记AI状态为移动调整
								enemyj:setAIState(hVar.UNIT_AI_STATE.MOVE_ADJUST)
								
								--发起移动(锁定目标）(单位计算障碍)
								hApi.UnitMoveToPoint_TD(enemyj, no_collpase_jx, no_collpase_jy, true)
								
								break
							else
								--代码走到这里说明这一圈都没位置了
								--敌人j往里走一格
								dis_t = dis_t - COLL_DIST * 2 --敌人j和目标的距离（一圈下来没找到，所以j往里走一点）
								if (dis_t < COLL_DIST) then
									--敌人j没法再往里走了
									break
								end
								
								--继续while的循环
							end
						end
						
						--代码走到这里，是因为发现重叠，并且处理的敌人j，不需要再和后面的敌人做检测
						break
					end
				end
			end
		end
	end
end

--绘制地图上所有角色的包围盒
hGlobal.UI.PaintBoxList = {} -- {[unnit] = {box = xxx, valid = false,}, ...}
function TD_Paint_Box_Timer()
	--开关控制
	if (hVar.OPTIONS.SHOW_BOX_FLAG == 0) then
		for oUnit, v in pairs(hGlobal.UI.PaintBoxList) do
			v.box:del()
			v.point:del()
			hGlobal.UI.PaintBoxList[oUnit] = nil
		end
		
		return
	end
	
	--如果游戏暂停，直接跳出循环
	local world = hGlobal.WORLD.LastWorldMap
	if (world.data.IsPaused == 1) then
		return
	end
	
	--首先将所有控件设置为无效
	for oUnit, v in pairs(hGlobal.UI.PaintBoxList) do
		v.valid = false
	end
	
	--遍历地图上的所有单位
	world:enumunit(function(eu)
		if (eu.data.type ~= hVar.UNIT_TYPE.NOT_USED) then --不是障碍排除物
			local eu_x, eu_y = hApi.chaGetPos(eu.handle)
			local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --单位的包围盒
			local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --单位的中心点x位置
			local eu_center_y = eu_y + (eu_by + eu_bh / 2) --单位的中心点y位置
			local csx, csy = hApi.world2view(eu_center_x, eu_center_y) --中心点的屏幕坐标
			local lsx, lsy = hApi.world2view(eu_x, eu_y) --脚底板的屏幕坐标
			
			if hGlobal.UI.PaintBoxList[eu] then --存在控件
				--标记有效
				hGlobal.UI.PaintBoxList[eu].valid = true
				
				--修改位置
				hGlobal.UI.PaintBoxList[eu].box:setXY(csx, csy)
				hGlobal.UI.PaintBoxList[eu].point:setXY(lsx, lsy)
			else --不存在控件
				--创建包围盒
				local model = "batchImage"
				if (eu.data.type == hVar.UNIT_TYPE.PLAYER_INFO) then --10:玩家信息
					model = "misc/r_mask_16.png" --"misc/weekstar.png"
				elseif (eu.data.type == hVar.UNIT_TYPE.WAY_POINT) then --11:路点、集合点
					model = "misc/y_mask_16.png" --"misc/weekstar.png"
				end
				
				local box = hUI.image:new(
				{
					parent = nil,
					model = model, --"Action:updown" --"BTN:PANEL_CLOSE"
					x = csx,
					y = csy,
					w = eu_bw,
					h = eu_bh,
					scale = 1.0, --缩放比例
					align = "MC",
				})
				
				--创建脚底板点
				local point = hUI.image:new(
				{
					parent = nil,
					model = "ICON:Back_gold", --"Action:updown" --"BTN:PANEL_CLOSE"
					x = lsx,
					y = lsy,
					w = 10,
					h = 10,
					scale = 1.0, --缩放比例
					align = "MC",
				})
				
				--填充表
				hGlobal.UI.PaintBoxList[eu] = {box = box, point = point, valid = true,}
			end
		end
	end)
	
	--删除无效的表
	local delList = {}
	for oUnit, v in pairs(hGlobal.UI.PaintBoxList) do
		if (v.valid == false) then
			delList[oUnit] = true
		end
	end
	for oUnit, v in pairs(delList) do
		hGlobal.UI.PaintBoxList[oUnit].box:del()
		hGlobal.UI.PaintBoxList[oUnit].point:del()
		hGlobal.UI.PaintBoxList[oUnit] = nil
	end
end

--绘制地图上所有碰撞飞行特效的包围盒
hGlobal.UI.EffPaintBoxList = {} -- {[oEffect] = {box = xxx, valid = false,}, ...} --碰撞飞行特效
function TD_Paint_EffBox_Timer()
	--开关控制
	if (hVar.OPTIONS.SHOW_BOX_FLAG == 0) then
		for oEffect, vv in pairs(hGlobal.UI.EffPaintBoxList) do
			for i = 1, #vv, 1 do
				local v = vv[i]
				v.box:del()
				v.point:del()
				hGlobal.UI.EffPaintBoxList[oEffect] = nil
			end
		end
		
		return
	end
	
	--如果游戏暂停，直接跳出循环
	local world = hGlobal.WORLD.LastWorldMap
	if (world.data.IsPaused == 1) then
		return
	end
	
	--首先将所有控件设置为无效
	for oEffect, vv in pairs(hGlobal.UI.EffPaintBoxList) do
		for i = 1, #vv, 1 do
			local v = vv[i]
			v.valid = false
		end
	end
	
	--绘制碰撞特效的包围盒
	hClass.effect:enum(function(oEffect)
		local handleTable = oEffect.handle
		local collision = handleTable.collision --碰撞类型飞行特效的标记
		
		if (collision == 1) then
			hGlobal.UI.EffPaintBoxList[oEffect] = hGlobal.UI.EffPaintBoxList[oEffect] or {}
			--[[
			local node_x, node_y = handleTable._n:getPosition()
			node_y = -node_y
			local eff_x, eff_y = handleTable.s:getPosition()
			eff_y = -eff_y
			local sprite_x = node_x + eff_x --特效碰撞的x坐标
			local sprite_y = node_y + eff_y --特效碰撞的y坐标
			]]
			local sprite_x, sprite_y = handleTable.x, handleTable.y --特效的位置
			local tabE = hVar.tab_effect[oEffect.data.id]
			local box = tabE.box --碰撞盒子
			local LOOPNUM = 1
			if (type(box[1]) == "table") then
				LOOPNUM = #box
			end
			
			for loopNum = 1, LOOPNUM, 1 do
				local bx, by, bw, bh = box[1], box[2], box[3], box[4] --碰撞的x、 y、宽、高
				if (type(box[1]) == "table") then
					bx, by, bw, bh = box[loopNum][1], box[loopNum][2], box[loopNum][3], box[loopNum][4] --碰撞的x、 y、宽、高
				end
				local isRotEff = handleTable.collision_isRotEff --碰撞类型飞行特效碰撞是否旋转特效
				local angle = 0 --碰撞类型飞行特效碰撞旋转的角度
				local cosX = 1 --碰撞类型飞行特效碰撞旋转的角度cos值（用于效率优化）
				local sinX = 0 --碰撞类型飞行特效碰撞旋转的角度sin值（用于效率优化）
				if (isRotEff == true) or (isRotEff == 1) then
					angle = handleTable.collision_angle --碰撞类型飞行特效碰撞旋转的角度
					cosX = handleTable.collision_angle_cosX --碰撞类型飞行特效碰撞旋转的角度cos值（用于效率优化）
					sinX = handleTable.collision_angle_sinX --碰撞类型飞行特效碰撞旋转的角度sin值（用于效率优化）
				end
				--print("angle=" .. angle, "isRotEff=" .. isRotEff)
				local fangle = angle * math.pi / 180 --弧度制
				fangle = math.floor(fangle * 100) / 100  --保留2位有效数字，用于同步
				local coll_x = sprite_x + (bx)* cosX + (-by) * sinX --特效碰撞的中心点x位置
				local coll_y = sprite_y + (bx)* sinX + (by) * cosX --特效碰撞的中心点y位置
				coll_x = math.floor(coll_x * 100) / 100  --保留2位有效数字，用于同步
				coll_y = math.floor(coll_y * 100) / 100  --保留2位有效数字，用于同步
				local dx = bw / 2
				local dy = bh / 2
				local cz = math.sqrt(dx * dx + dy * dy)
				cz = math.floor(cz * 100) / 100  --保留2位有效数字，用于同步
				local theta = math.atan(bh / bw) --原始角度
				local tdx = cz * math.cos(fangle + theta) --本地移动的x距离
				local tdy = cz * math.sin(fangle + theta) --本地移动的y距离
				tdx = math.floor(tdx * 100) / 100  --保留2位有效数字，用于同步
				tdy = math.floor(tdy * 100) / 100  --保留2位有效数字，用于同步
				--local lu_x, lu_y = coll_x - tdx, coll_y - tdy --左上角坐标
				--local ru_x, ru_y = coll_x + tdx, coll_y - tdy --右上角坐标
				--local ld_x, ld_y = coll_x - tdx, coll_y + tdy --左下角坐标
				--local rd_x, rd_y = coll_x + tdx, coll_y + tdy --右下角坐标
				local csx, csy = hApi.world2view(coll_x, coll_y) --碰撞中心点的屏幕坐标
				
				--if (oEffect.handle.collision_caster_side == 1) then
				--	print("Paint:", oEffect.data.id, angle,bx, by, bw, bh)
				--end
				
				if hGlobal.UI.EffPaintBoxList[oEffect][loopNum] then --存在控件
					--标记有效
					hGlobal.UI.EffPaintBoxList[oEffect][loopNum].valid = true
					
					--修改位置
					hGlobal.UI.EffPaintBoxList[oEffect][loopNum].box:setXY(csx, csy)
					hGlobal.UI.EffPaintBoxList[oEffect][loopNum].point:setXY(csx, csy)
				else --不存在控件
					--创建包围盒
					local model = "misc/mask_16.png"
					local box = hUI.button:new(
					{
						parent = nil,
						model = model, --"Action:updown" --"BTN:PANEL_CLOSE"
						x = csx,
						y = csy,
						z = 100000,
						w = bw,
						h = bh,
						scale = 1.0, --缩放比例
						align = "MC",
					})
					--box.handle.s:setColor(ccc3(0, 255, 0))
					box.handle.s:setRotation(angle)
					--文字
					box.childUI["side"] = hUI.label:new(
					{
						parent = box.handle._n,
						x = 0,
						y = 0,
						z = 1,
						width = 500,
						align = "MC",
						border = 0,
						size = 16,
						text = "[s:" .. oEffect.handle.collision_caster_side .. "], [e:" .. math.floor(oEffect.data.id) .. "]",
					})
					if (oEffect.handle.collision_caster_side == 1) then
						box.childUI["side"].handle.s:setColor(ccc3(255, 255, 0))
					else
						box.childUI["side"].handle.s:setColor(ccc3(255, 0, 0))
					end
					--box.childUI["side"].handle.s:setRotation(angle)
					
					--创建脚底板点
					local point = hUI.image:new(
					{
						parent = nil,
						model = "ICON:Back_red", --"Action:updown" --"BTN:PANEL_CLOSE"
						x = csx,
						y = csy,
						w = 10,
						h = 10,
						scale = 1.0, --缩放比例
						align = "MC",
					})
					
					--填充表
					hGlobal.UI.EffPaintBoxList[oEffect][loopNum] = {box = box, point = point, valid = true,}
				end
			end
		end
	end)
	
	--删除无效的表
	local delList = {}
	for oEffect, vv in pairs(hGlobal.UI.EffPaintBoxList) do
		for i = 1, #vv, 1 do
			local v = vv[i]
			if (v.valid == false) then
				delList[oEffect] = true
			end
		end
	end
	for oEffect, _ in pairs(delList) do
		local vv = hGlobal.UI.EffPaintBoxList[oEffect]
		for i = 1, #vv, 1 do
			local v = vv[i]
			v.box:del()
			v.point:del()
			v = nil
		end
		hGlobal.UI.EffPaintBoxList[oEffect] = nil
	end
end

--绘制地图上所有水的障碍区域的包围盒
hGlobal.UI.WaterPaintBoxList = {}
function TD_Paint_WaterBox_Timer()
	--开关控制
	if (hVar.OPTIONS.SHOW_BOX_FLAG == 0) then
		for k, v in pairs(hGlobal.UI.WaterPaintBoxList) do
			v.box:del()
			v.label:del()
			hGlobal.UI.WaterPaintBoxList[k] = nil
		end
		
		return
	end
	
	--如果游戏暂停，直接跳出循环
	local world = hGlobal.WORLD.LastWorldMap
	if (world.data.IsPaused == 1) then
		return
	end
	
	--首先将所有控件设置为无效
	for k, v in pairs(hGlobal.UI.WaterPaintBoxList) do
		v.valid = false
	end
	
	--绘制水区域包围盒
	for i = 1, #world.data.__waterRegionT, 1 do
		local region = world.data.__waterRegionT[i]
		local x = region.x
		local y = region.y
		local w = region.w
		local h = region.h
		local regionModel = region.model
			
		local csx, csy = hApi.world2view(x, y) --水的中心点的屏幕坐标
			
		if hGlobal.UI.WaterPaintBoxList[i] then --存在控件
			--标记有效
			hGlobal.UI.WaterPaintBoxList[i].valid = true
			
			--修改位置
			hGlobal.UI.WaterPaintBoxList[i].box:setXY(csx, csy)
			hGlobal.UI.WaterPaintBoxList[i].label:setXY(csx, csy)
		else --不存在控件
			--创建包围盒
			local model = "misc/progress.png"
			local box = hUI.image:new(
			{
				parent = nil,
				model = model, --"Action:updown" --"BTN:PANEL_CLOSE"
				x = csx,
				y = csy,
				w = w,
				h = h,
				scale = 1.0, --缩放比例
				align = "MC",
			})
			box.handle.s:setOpacity(128)
			
			local label = hUI.label:new(
			{
				parent = nil,
				size = 22,
				x = csx,
				y = csy,
				text = regionModel,
				font = hVar.DEFAULT_FONT, --默认字体
				align = "MC",
				border = 1,
			})
			label.handle.s:setColor(ccc3(0, 255, 255))
			
			--填充表
			hGlobal.UI.WaterPaintBoxList[i] = {box = box, label = label, valid = true,}
		end
	end
	
	--删除无效的表
	local delList = {}
	for k, v in pairs(hGlobal.UI.EffPaintBoxList) do
		if (v.valid == false) then
			delList[k] = true
		end
	end
	for k, v in pairs(delList) do
		hGlobal.UI.EffPaintBoxList[k].box:del()
		hGlobal.UI.EffPaintBoxList[k].label:del()
		hGlobal.UI.EffPaintBoxList[k] = nil
	end
end

--绘制地图上所有的动态障碍
hGlobal.UI.DynamicBlockPaintBoxList = {}
function TD_Paint_DynamicBlock_Timer()
	--开关控制
	if (hVar.OPTIONS.SHOW_BOX_FLAG == 0) then
		for k, v in pairs(hGlobal.UI.DynamicBlockPaintBoxList) do
			v.box:del()
			--v.label:del()
			hGlobal.UI.DynamicBlockPaintBoxList[k] = nil
		end
		
		return
	end
	
	--如果游戏暂停，直接跳出循环
	local world = hGlobal.WORLD.LastWorldMap
	if (world.data.IsPaused == 1) then
		return
	end
	
	--首先将所有控件设置为无效
	for k, v in pairs(hGlobal.UI.DynamicBlockPaintBoxList) do
		v.valid = false
	end
	
	--遍历地图上的所有单位
	world:enumunit(function(eu)
		if (eu.data.type == hVar.UNIT_TYPE.UNITBROKEN) or (eu.data.type == hVar.UNIT_TYPE.UNITBROKEN_HOUSE) or (eu.data.type == hVar.UNIT_TYPE.UNITDOOR) then --可破坏物件、可破坏房子
			local eu_x, eu_y = hApi.chaGetPos(eu.handle)
			local tabU = hVar.tab_unit[eu.data.id]
			local box = tabU.box2 or tabU.box
			--local eu_bx, eu_by, eu_bw, eu_bh = eu:getbox() --单位的包围盒
			local eu_bx, eu_by, eu_bw, eu_bh = box[1], box[2], box[3], box[4] --单位的包围盒
			local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --单位的中心点x位置
			local eu_center_y = eu_y + (eu_by + eu_bh / 2) --单位的中心点y位置
			local eu_xl = eu_center_x - eu_bw / 2
			local eu_xr = eu_center_x + eu_bw / 2
			local eu_yl = eu_center_y - eu_bh / 2
			local eu_yr = eu_center_y + eu_bh / 2
			for xi = eu_xl + hVar.ROLE_COLLISION_EDGE, eu_xr, hVar.ROLE_COLLISION_EDGE / 2 do
				for yi = eu_yl + hVar.ROLE_COLLISION_EDGE, eu_yr, hVar.ROLE_COLLISION_EDGE / 2 do
					local gx = math.floor(xi / hVar.ROLE_COLLISION_EDGE) - 1
					local gy = math.floor(yi / hVar.ROLE_COLLISION_EDGE) - 1
					local key = tostring(gx) .. "_" .. tostring(gy)
					--print("key=", key)
					
					local csx, csy = hApi.world2view(gx *  hVar.ROLE_COLLISION_EDGE + hVar.ROLE_COLLISION_EDGE / 2, gy *  hVar.ROLE_COLLISION_EDGE + hVar.ROLE_COLLISION_EDGE / 2) --中心点的屏幕坐标
					
					if hGlobal.UI.DynamicBlockPaintBoxList[key] then --存在控件
						--标记有效
						hGlobal.UI.DynamicBlockPaintBoxList[key].valid = true
						
						--修改位置
						hGlobal.UI.DynamicBlockPaintBoxList[key].box:setXY(csx, csy)
						--hGlobal.UI.DynamicBlockPaintBoxList[i].label:setXY(csx, csy)
					else --不存在控件
						--创建包围盒
						local model = "misc/mask_white.png"
						local box = hUI.image:new(
						{
							parent = nil,
							model = model, --"Action:updown" --"BTN:PANEL_CLOSE"
							x = csx,
							y = csy,
							w =  hVar.ROLE_COLLISION_EDGE,
							h =  hVar.ROLE_COLLISION_EDGE,
							--scale = 1.0, --缩放比例
							align = "MC",
						})
						box.handle.s:setOpacity(128)
						
						--[[
						local label = hUI.label:new(
						{
							parent = nil,
							size = 22,
							x = csx,
							y = csy,
							text = regionModel,
							font = hVar.DEFAULT_FONT, --默认字体
							align = "MC",
							border = 1,
						})
						label.handle.s:setColor(ccc3(0, 255, 255))
						]]
						
						--填充表
						hGlobal.UI.DynamicBlockPaintBoxList[key] = {box = box, label = label, valid = true,}
					end
				end
			end
		end
	end)
	
	--删除无效的表
	local delList = {}
	for k, v in pairs(hGlobal.UI.DynamicBlockPaintBoxList) do
		if (v.valid == false) then
			delList[k] = true
		end
	end
	for k, v in pairs(delList) do
		hGlobal.UI.DynamicBlockPaintBoxList[k].box:del()
		--hGlobal.UI.DynamicBlockPaintBoxList[k].label:del()
		hGlobal.UI.DynamicBlockPaintBoxList[k] = nil
	end
end

--绘制地图上所有的随机房间包围盒
hGlobal.UI.RandommapGroupPaintRoomList = {}
function TD_Paint_RandommapRoom_Timer()
	--开关控制
	if (hVar.OPTIONS.SHOW_BOX_FLAG == 0) then
		for k, v in pairs(hGlobal.UI.RandommapGroupPaintRoomList) do
			if v.point1 then
				v.point1:del()
			end
			v.box1:del()
			v.box2:del()
			v.box3:del()
			v.box4:del()
			hGlobal.UI.RandommapGroupPaintRoomList[k] = nil
		end
		
		return
	end
	
	--如果游戏暂停，直接跳出循环
	local world = hGlobal.WORLD.LastWorldMap
	if (world.data.IsPaused == 1) then
		return
	end
	
	--首先将所有控件设置为无效
	for k, v in pairs(hGlobal.UI.RandommapGroupPaintRoomList) do
		v.valid = false
	end
	
	local tParam = hVar.DEVICE_PARAM[g_phone_mode] or {}
	local world_scale = tParam.world_scale or 1.0
	
	--遍历地图上的所有区域组
	local regionId = world.data.randommapIdx
	local randommapInfo = world.data.randommapInfo
	if (regionId > 0) then
		local regionData = randommapInfo[regionId]
		if regionData then
			local PIX_SIZE = 16 * 3
			local rooms = regionData.rooms_new --房间信息
			local offsetX = regionData.regoin_xl --左上角x坐标
			local offsetY = regionData.regoin_yt --左上角y坐标
			local regoin_xr = regionData.max_px --右下角x坐标
			local regoin_yb = regionData.max_py --右下角y坐标
			
			if rooms then
				for i = 1, #rooms, 1 do
					local tRegion = rooms[i]
					local roomType = 0
					local strRoomType = tRegion.Roomtype --区域类型
					local roomPosX = tRegion.x + offsetX / PIX_SIZE
					local roomPosY = tRegion.y + offsetY / PIX_SIZE
					local roomWidth = tRegion.w
					local roomHeight = tRegion.h
					local tTerminalPos = tRegion.TerminalPos --终点坐标集
					
					--区域四个角
					local xl = roomPosX * PIX_SIZE
					local yt = roomPosY * PIX_SIZE
					local xr = xl + roomWidth * PIX_SIZE
					local yb = yt + roomHeight * PIX_SIZE
					local tx, ty = 0, 0
					if tTerminalPos then
						tx = tTerminalPos[1].x * PIX_SIZE + offsetX / PIX_SIZE
						ty = tTerminalPos[1].y * PIX_SIZE + offsetY / PIX_SIZE
					end
					
					local key = tostring(i) .. "_" .. tostring(xl) .. "_" .. tostring(yt)
					--print("key=", key)
					local csx1, csy1 = hApi.world2view(xl, yt)
					local csx2, csy2 = hApi.world2view(xr, yb)
					local cstx, csty = hApi.world2view(tx, ty)
						
					if hGlobal.UI.RandommapGroupPaintRoomList[key] then --存在控件
						--标记有效
						hGlobal.UI.RandommapGroupPaintRoomList[key].valid = true
						
						--修改位置
						if tTerminalPos then
							hGlobal.UI.RandommapGroupPaintRoomList[key].point1:setXY(cstx, csty)
						end
						hGlobal.UI.RandommapGroupPaintRoomList[key].box1:setXY(csx1/2+csx2/2, csy1)
						hGlobal.UI.RandommapGroupPaintRoomList[key].box2:setXY(csx1/2+csx2/2, csy2)
						hGlobal.UI.RandommapGroupPaintRoomList[key].box3:setXY(csx1, csy1/2+csy2/2)
						hGlobal.UI.RandommapGroupPaintRoomList[key].box4:setXY(csx2, csy1/2+csy2/2)
					else --不存在控件
						--创建断头点
						local point1 = nil
						if tTerminalPos then
							point1 = hUI.image:new(
							{
								parent = nil,
								model = "misc/update.png",
								x = cstx,
								y = csty,
								w = 46,
								h =  46,
								--scale = 1.0, --缩放比例
								align = "MC",
							})
							--point1.handle.s:setColor(ccc3(0, 255, 0))
						end
						
						--创建包围盒1
						local box1 = hUI.image:new(
						{
							parent = nil,
							model = "misc/mask_white.png",
							x = csx1/2+csx2/2,
							y = csy1,
							w = (csx2-csx1) * 1,
							h =  1,
							--scale = 1.0, --缩放比例
							align = "MC",
						})
						box1.handle.s:setColor(ccc3(255, 255, 0))
						
						--创建包围盒2
						local box2 = hUI.image:new(
						{
							parent = nil,
							model = "misc/mask_white.png",
							x = csx1/2+csx2/2,
							y = csy2,
							w = (csx2-csx1) * 1,
							h =  1,
							--scale = 1.0, --缩放比例
							align = "MC",
						})
						box2.handle.s:setColor(ccc3(255, 255, 0))
						
						--创建包围盒3
						local box3 = hUI.image:new(
						{
							parent = nil,
							model = "misc/mask_white.png",
							x = csx1,
							y = csy1/2+csy2/2,
							w = 1,
							h = (csy1-csy2) * 1,
							--scale = 1.0, --缩放比例
							align = "MC",
						})
						box3.handle.s:setColor(ccc3(255, 255, 0))
						
						--创建包围盒4
						local box4 = hUI.image:new(
						{
							parent = nil,
							model = "misc/mask_white.png",
							x = csx2,
							y = csy1/2+csy2/2,
							w = 1,
							h = (csy1-csy2) * 1,
							--scale = 1.0, --缩放比例
							align = "MC",
						})
						box4.handle.s:setColor(ccc3(255, 255, 0))
						
						--填充表
						hGlobal.UI.RandommapGroupPaintRoomList[key] = {point1 = point1, box1 = box1, box2 = box2, box3 = box3, box4 = box4, valid = true,}
					end
				end
			end
		end
	end
	
	--删除无效的表
	local delList = {}
	for k, v in pairs(hGlobal.UI.RandommapGroupPaintRoomList) do
		if (v.valid == false) then
			delList[k] = true
		end
	end
	for k, v in pairs(delList) do
		if hGlobal.UI.RandommapGroupPaintRoomList[k].point1 then
			hGlobal.UI.RandommapGroupPaintRoomList[k].point1:del()
		end
		hGlobal.UI.RandommapGroupPaintRoomList[k].box1:del()
		hGlobal.UI.RandommapGroupPaintRoomList[k].box2:del()
		hGlobal.UI.RandommapGroupPaintRoomList[k].box3:del()
		hGlobal.UI.RandommapGroupPaintRoomList[k].box4:del()
		hGlobal.UI.RandommapGroupPaintRoomList[k] = nil
	end
end

--绘制地图上所有的随机地图区域包围盒
hGlobal.UI.RandommapGroupPaintBoxList = {}
function TD_Paint_RandommapGroup_Timer()
	--开关控制
	if (hVar.OPTIONS.SHOW_BOX_FLAG == 0) then
		for k, v in pairs(hGlobal.UI.RandommapGroupPaintBoxList) do
			v.box:del()
			v.box2:del()
			v.label:del()
			hGlobal.UI.RandommapGroupPaintBoxList[k] = nil
		end
		
		return
	end
	
	--如果游戏暂停，直接跳出循环
	local world = hGlobal.WORLD.LastWorldMap
	if (world.data.IsPaused == 1) then
		return
	end
	
	--首先将所有控件设置为无效
	for k, v in pairs(hGlobal.UI.RandommapGroupPaintBoxList) do
		v.valid = false
	end
	
	local tParam = hVar.DEVICE_PARAM[g_phone_mode] or {}
	local world_scale = tParam.world_scale or 1.0
	
	--遍历地图上的所有区域组
	local regionId = world.data.randommapIdx
	local randommapInfo = world.data.randommapInfo
	if (regionId > 0) then
		local regionData = randommapInfo[regionId]
		if regionData then
			local roomgroupSendArmyList = regionData.roomgroupSendArmyList
			if roomgroupSendArmyList then
				for i = 1, #roomgroupSendArmyList, 1 do
					local groupId = roomgroupSendArmyList[i].groupId
					local gx = roomgroupSendArmyList[i].x
					local gy = roomgroupSendArmyList[i].y
					local tGroup = hVar.RANDMAP_ROOM_ENEMY_GROUP[groupId]
					local box = tGroup.box
					local box_x = box[1]
					local box_y = box[2]
					local box_w = box[3]
					local box_h = box[4]
					local box_width = box_w - box_x
					local box_height = box_h - box_y
					local cx = gx + box_x + box_width / 2
					local cy = gy + box_y + box_height / 2
					
					local key = tostring(groupId) .. "_" .. tostring(gx) .. "_" .. tostring(gy)
					--print("key=", key)
					local csx, csy = hApi.world2view(cx, cy) --中心点的屏幕坐标
					local csx2, csy2 = hApi.world2view(gx, gy)
						
					if hGlobal.UI.RandommapGroupPaintBoxList[key] then --存在控件
						--标记有效
						hGlobal.UI.RandommapGroupPaintBoxList[key].valid = true
						
						--修改位置
						hGlobal.UI.RandommapGroupPaintBoxList[key].box:setXY(csx, csy)
						hGlobal.UI.RandommapGroupPaintBoxList[key].box2:setXY(csx2, csy2)
						hGlobal.UI.RandommapGroupPaintBoxList[key].label:setXY(csx, csy)
					else --不存在控件
						--创建包围盒
						local model = "misc/mask_white.png"
						local box = hUI.image:new(
						{
							parent = nil,
							model = model, --"Action:updown" --"BTN:PANEL_CLOSE"
							x = csx,
							y = csy,
							w =  box_width * world_scale,
							h =  box_height * world_scale,
							--scale = 1.0, --缩放比例
							align = "MC",
						})
						box.handle.s:setColor(ccc3(255, 128, 128))
						box.handle.s:setOpacity(128)
						
						--创建包围盒2
						local box2 = hUI.image:new(
						{
							parent = nil,
							model = "misc/jdt.png", --"Action:updown" --"BTN:PANEL_CLOSE"
							x = csx2,
							y = csy2,
							w =  8,
							h =  8,
							--scale = 1.0, --缩放比例
							align = "MC",
						})
						
						local label = hUI.label:new(
						{
							parent = nil,
							size = 24,
							x = csx,
							y = csy,
							text = groupId,
							font = hVar.FONTC, --默认字体
							align = "MC",
							border = 1,
						})
						label.handle.s:setColor(ccc3(0, 255, 255))
						
						--填充表
						hGlobal.UI.RandommapGroupPaintBoxList[key] = {box = box, box2 = box2, label = label, valid = true,}
					end
				end
			end
		end
	end
	
	--删除无效的表
	local delList = {}
	for k, v in pairs(hGlobal.UI.RandommapGroupPaintBoxList) do
		if (v.valid == false) then
			delList[k] = true
		end
	end
	for k, v in pairs(delList) do
		hGlobal.UI.RandommapGroupPaintBoxList[k].box:del()
		hGlobal.UI.RandommapGroupPaintBoxList[k].box2:del()
		hGlobal.UI.RandommapGroupPaintBoxList[k].label:del()
		hGlobal.UI.RandommapGroupPaintBoxList[k] = nil
	end
end

--绘制地图上所有角色的动态障碍
hGlobal.UI.PaintBoxDynamicList = {} -- {[unnit] = {box = xxx, valid = false,}, ...}
function TD_Paint_Box_Dynamic_Timer()
	--开关控制
	if (hVar.OPTIONS.SHOW_BOX_FLAG == 0) then
		for oUnit, v in pairs(hGlobal.UI.PaintBoxDynamicList) do
			for bx = 1, #v.box, 1 do
				v.box[bx]:del()
			end
			hGlobal.UI.PaintBoxDynamicList[oUnit] = nil
		end
		
		return
	end
	
	--如果游戏暂停，直接跳出循环
	local world = hGlobal.WORLD.LastWorldMap
	if (world.data.IsPaused == 1) then
		return
	end
	
	--首先将所有控件设置为无效
	for oUnit, v in pairs(hGlobal.UI.PaintBoxDynamicList) do
		v.valid = false
	end
	
	--遍历地图上的所有单位
	world:enumunit(function(eu)
		local tabU = hVar.tab_unit[eu.data.id]
		local box_dynamic = tabU.box_dynamic
		if box_dynamic then
			--初始化
			if (hGlobal.UI.PaintBoxDynamicList[eu] == nil) then
				hGlobal.UI.PaintBoxDynamicList[eu] = {}
				hGlobal.UI.PaintBoxDynamicList[eu].valid = true
				hGlobal.UI.PaintBoxDynamicList[eu].box = {}
			end
			
			--标记有效
			hGlobal.UI.PaintBoxDynamicList[eu].valid = true
			
			for bx = 1, #box_dynamic, 1 do
				local box = box_dynamic[bx]
				local eu_x, eu_y = hApi.chaGetPos(eu.handle)
				local eu_bx, eu_by, eu_bw, eu_bh = box[1], box[2], box[3], box[4] --单位的动态障碍
				local eu_center_x = eu_x + (eu_bx + eu_bw / 2) --单位的中心点x位置
				local eu_center_y = eu_y + (eu_by + eu_bh / 2) --单位的中心点y位置
				local csx, csy = hApi.world2view(eu_center_x, eu_center_y) --中心点的屏幕坐标
				local lsx, lsy = hApi.world2view(eu_x, eu_y) --脚底板的屏幕坐标
				
				if hGlobal.UI.PaintBoxDynamicList[eu].box[bx] then --存在控件
					--修改位置
					hGlobal.UI.PaintBoxDynamicList[eu].box[bx]:setXY(csx, csy)
				else --不存在控件
					--创建包围盒
					local model = "misc/mask_white.png" --"misc/weekstar.png"
					
					local box = hUI.image:new(
					{
						parent = nil,
						model = model, --"Action:updown" --"BTN:PANEL_CLOSE"
						x = csx,
						y = csy,
						w = eu_bw,
						h = eu_bh,
						scale = 1.0, --缩放比例
						align = "MC",
					})
					
					--填充表
					hGlobal.UI.PaintBoxDynamicList[eu].box[bx] = box
				end
			end
		end
	end)
	
	--删除无效的表
	local delList = {}
	for oUnit, v in pairs(hGlobal.UI.PaintBoxDynamicList) do
		if (v.valid == false) then
			delList[oUnit] = true
		end
	end
	for oUnit, _ in pairs(delList) do
		local v = hGlobal.UI.PaintBoxDynamicList[oUnit]
		for bx = 1, #v.box, 1 do
			v.box[bx]:del()
		end
		
		hGlobal.UI.PaintBoxDynamicList[oUnit] = nil
	end
end

--绘制地图上所有角色的AI状态
function PaintAIStateUILoop()
	local world = hGlobal.WORLD.LastWorldMap
	
	--如果游戏暂停，直接跳出循环
	if (world.data.IsPaused == 1) then
		return
	end
	
	--非TD地图，直接跳出循环
	local mapInfo = world.data.tdMapInfo
	if (not mapInfo) then
		return
	end
	
	--游戏暂停或结束，直接退出
	if (mapInfo.mapState >= hVar.MAP_TD_STATE.PAUSE) then
		return
	end
	
	--界面显示单位锁定的目标
	if (hVar.OPTIONS.SHOW_AI_UI_FLAG == 1) then
		--依次遍历所有单位，绘制文字
		world:enumunit(function(eu)
			local aiState = eu:getAIState() --角色的AI状态
			local szAIState = "" --字符串
			if (aiState == hVar.UNIT_AI_STATE.IDLE) then --空闲状态
				szAIState = "IDLE"
			elseif (aiState == hVar.UNIT_AI_STATE.MOVE) then --移动状态
				szAIState = "MOVE"
			elseif (aiState == hVar.UNIT_AI_STATE.MOVE_TANK_NEARBY) then --移动到坦克附近状态
				szAIState = "MOVE_TANK_NEARBY"
			elseif (aiState == hVar.UNIT_AI_STATE.MOVE_TANK) then --移动到坦克状态
				szAIState = "MOVE_TANK"
			elseif (aiState == hVar.UNIT_AI_STATE.MOVE_ADJUST) then --移动调整状态
				szAIState = "MOVE_ADJUST"
			elseif (aiState == hVar.UNIT_AI_STATE.MOVE_CHAOS) then --移动混乱状态（单位无目的乱走）
				szAIState = "MOVE_CHAOS"
			elseif (aiState == hVar.UNIT_AI_STATE.MOVE_HOSTAGE_TANK) then --人质移动跟随坦克状态
				szAIState = "MOVE_HOSTAGE_TANK"
			elseif (aiState == hVar.UNIT_AI_STATE.MOVE_HOSTAGE_ChAOS) then --人质移动混乱状态（单位无目的乱走）
				szAIState = "MOVE_HOSTAGE_ChAOS"
			elseif (aiState == hVar.UNIT_AI_STATE.ATTACK) then --攻击状态
				szAIState = "ATTACK"
			elseif (aiState == hVar.UNIT_AI_STATE.FOLLOW) then --跟随单位状态
				szAIState = "FOLLOW"
			elseif (aiState == hVar.UNIT_AI_STATE.MOVE_TO_POINT) then --移动到达目标点后释放战术技能
				szAIState = "MOVE_TO_POINT"
			elseif (aiState == hVar.UNIT_AI_STATE.MOVE_TO_POINT_CASTSKILL) then --移动到达目标点后继续释放技能
				szAIState = "MOVE_TO_POINT_CASTSKILL"
			elseif (aiState == hVar.UNIT_AI_STATE.FOLLOW_TO_TARGET) then --移动到达目标后释放战术技能
				szAIState = "FOLLOW_TO_TARGET"
			elseif (aiState == hVar.UNIT_AI_STATE.SEARCH) then --搜敌状态
				szAIState = "SEARCH"
			elseif (aiState == hVar.UNIT_AI_STATE.CAST) then --施法状态
				szAIState = "CAST"
			elseif (aiState == hVar.UNIT_AI_STATE.CAST_STATIC) then --施法后僵直状态
				szAIState = "STATIC"
			elseif (aiState == hVar.UNIT_AI_STATE.STUN) then --眩晕状态
				szAIState = "STUN"
			elseif (aiState == hVar.UNIT_AI_STATE.MOVE_BY_TRACK) then --滑行状态
				szAIState = "MOVE_BY_TRACK"
			elseif (aiState == hVar.UNIT_AI_STATE.SLEEP) then --沉睡状态
				szAIState = "SLEEP"
			elseif (aiState == hVar.UNIT_AI_STATE.REACHED) then --到达终点
				szAIState = "REACHED"
			end
			
			local szString = szAIState --最终的显示字符串
			local lockTarget = eu.data.lockTarget --锁定的目标
			local lockType = eu.data.lockType --锁定的类型
			local szTarget = "" --字符串
			if (lockTarget ~= 0) then
				--szString = szString .. ", " .. lockTarget.data.name .. "[" .. lockTarget.__ID .. "]"
				szString = szString .. ", " .. lockTarget.data.name .. "[" .. eu.data.id .. "]"
			end
			
			if (eu.attr.immue_physic_stack > 0) then
				szString = szString .. "(WUMIAN)"
			end
			if (eu.attr.immue_magic_stack > 0) then
				szString = szString .. "(MOMIAN)"
			end
			if (eu.attr.immue_wudi_stack > 0) then
				szString = szString .. "(WUDI)"
			end
			if (eu.attr.immue_damage_stack > 0) then
				szString = szString .. "(NODMG)"
			end
			if (eu.attr.immue_damage_ice_stack > 0) then
				szString = szString .. "(NODMG_ICE)"
			end
			if (eu.attr.immue_damage_thunder_stack > 0) then
				szString = szString .. "(NODMG_THUNDER)"
			end
			if (eu.attr.immue_damage_fire_stack > 0) then
				szString = szString .. "(NODMG_FIRE)"
			end
			if (eu.attr.immue_damage_poison_stack > 0) then
				szString = szString .. "(NODMG_POISON)"
			end
			if (eu.attr.immue_damage_bullet_stack > 0) then
				szString = szString .. "(NODMG_BULLET)"
			end
			if (eu.attr.immue_damage_boom_stack > 0) then
				szString = szString .. "(NODMG_BOMB)"
			end
			if (eu.attr.immue_damage_chuanci_stack > 0) then
				szString = szString .. "(NODMG_CHUANCI)"
			end
			
			--[[
			------------------------------------
			--调试
			local ex, ey = hApi.chaGetPos(eu.handle)
			local ebx, eby, ebw, ebh = eu:getbox()
			local ecenter_x = ex + (ebx + ebw / 2)
			local ecenter_y = ey + (eby + ebh / 2)
			local ux, uy = hApi.chaGetPos(world.data.rpgunit_tank.handle)
			local ubx, uby, ubw, ubh = world.data.rpgunit_tank:getbox()
			local ucenter_x = ux + (ubx + ubw / 2)
			local ucenter_y = uy + (uby + ubh / 2)
			local IsBolck = hApi.IsPathBlock(ucenter_x, ucenter_y, ecenter_x, ecenter_y)
			szString = IsBolck
			------------------------------------
			]]
			
			--设置文字
			if eu.chaUI["lockBar"] then
				eu.chaUI["lockBar"]:setText(szString)
			end
		end)
	end
end

--geyachao: 新手引导流程
--mapName: "town/town_mainmenu" / "town/select_map" / "world/td_001_lsc"/ "world/td_002_zjtj"
--nStep: 选择关卡的步骤(0:进入界面 / 1:点击新开启的关卡按钮)
--nStep: 游戏场景里的步骤(1:刚进游戏 / 2:选人结束 / 3:游戏结束 / nil:其他场景无此值)
--nIsSuccess:在战斗中是否胜利
hGlobal.event:listen("LocalEvent_EnterGuideProgress", "Guide", function(mapName, tPointer, szType, nStep, nIsSuccess)
	--编辑器模式不处理
	if (g_editor == 1) then
		return
	end
	
	--[[
	--大菠萝不需要此逻辑
	--TD不显示新手引导模式，直接返回
	if (hVar.OPTIONS.IS_SHOW_GUIDE == 0) then
		--geyachao: 特殊处理：第一关如果跳过引导，那么第一次玩，应该弹出战术技能卡界面
		local isFinishMap1 = LuaGetPlayerMapAchi("world/td_001_lsc", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第一关是否解锁
		if (isFinishMap1 == 0) then
			hGlobal.event:event("Event_TacticsInit") --呼出战术技能卡界面
		end
		
		return
	end
	]]
	
	--检测存档里是否需要新手引导的标记
	local playlist = LuaGetPlayerData()
	--local playlist = LuaGetPlayerByName(g_curPlayerName)
	--print("--->--->--->--->--->--->--->--->--->--->---> 存档表(playlist)=" .. tostring(playlist) .. "_" .. tostring(g_curPlayerName) .. ", playlist.guideFlag=" .. tostring(playlist and playlist.guideFlag))
	--if playlist then
	--	for k, v in pairs(playlist) do
	--		print("      playlist[" .. tostring(k) .. "] = " .. tostring(v))
	--	end
	--end
	
	if playlist and playlist.guideFlag then
		if (playlist.guideFlag == -1) then --是否需要引导的标记（0:未设置 / -1:不需要引导 /1:需要引导）
			--geyachao: 特殊处理：第一关如果跳过引导，那么第一次玩，应该弹出战术技能卡界面
			local isFinishMap1 = LuaGetPlayerMapAchi("world/td_001_lsc", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第一关是否解锁
			if (isFinishMap1 == 0) then
				hGlobal.event:event("Event_TacticsInit") --呼出战术技能卡界面
			end
			
			return
		else --其它情况都需要引导
			--
		end
	else --不存在这一项也需要引导
		--
	end
	
	--print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
	--print("引导流程(), mapName=" .. mapName, tPointer, "szType=" .. szType, "nStep=" .. tostring(nStep))
	--print(debug.traceback())
	--[[
	--nStep: 选择关卡的步骤(0:进入界面 / 1:点击新开启的关卡按钮)
	--nStep: 游戏场景里的步骤(1:刚进游戏 / 2:选人结束 / 3:游戏结束 / nil:其他场景无此值)
	if (mapName == "town/town_mainmenu") then --主城界面
		local townGuideFirstEnter = LuaGetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 1) --玩家第一次进入主城
		local townGuideSecondEnter = LuaGetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 2) --玩家引导查看英雄界面
		local townGuideThirdEnter = LuaGetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 3) --玩家引导查看任务成就界面
		local townGuideForthEnter = LuaGetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 4) --玩家引导点第二关
		local townGuideFifthEnter = LuaGetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 5) --玩家引导开商店界面
		local townGuideSixthEnter = LuaGetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 6) --玩家引导战术技能卡界面
		
		local isFinishMap1 = LuaGetPlayerMapAchi("world/td_001_lsc", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第一关是否解锁
		local isFinishMap2 = LuaGetPlayerMapAchi("world/td_002_zjtj", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第二关是否解锁
		
		if (townGuideFirstEnter == 0) then --玩家第一次进入主城
			CreateGuideFrame_MapMain()
		elseif (townGuideSecondEnter == 0) then --玩家引导查看英雄界面
			--解锁了第一关才能引导点将台
			if (isFinishMap1 == 1) then
				CreateGuideFrame_HeroFrm()
			end
		elseif (townGuideThirdEnter == 0) then --玩家引导查看任务成就界面
			--解锁了第一关才能引导任务成就
			if (isFinishMap1 == 1) then
				CreateGuideFrame_TaskFrm()
			end
		elseif (townGuideForthEnter == 0) then --玩家引导点第二关
			--解锁了第一关才能引导挑战第二关
			if (isFinishMap1 == 1) then
				CreateGuideMap002_Frm()
			end
		elseif (townGuideFifthEnter == 0) then --玩家引导开商店界面
			--解锁了第二关才能引导挑战第二关
			if (isFinishMap2 == 1) then
				CreateGuideFrame_ShopBuy()
			end
		elseif (townGuideSixthEnter == 0) then --玩家引导战术技能卡界面
			--解锁了第二关才能引导挑战第二关
			if (isFinishMap2 == 1) then
				CreateGuideFrame_TacticFrm()
			end
		end
		--LuaGetPlayerGuideState(playName,map_name,key)
	elseif (mapName == "town/select_map") then --选择关卡界面
		--
	elseif (mapName == "world/td_001_lsc") then --第一关
		--检测引导第一关第一次进游戏
		if (nStep == 1) then
			local map01FirstEnter = LuaGetPlayerGuideState(g_curPlayerName, "world/td_001_lsc", 1) --玩家第一次玩第一关
			if (map01FirstEnter == 0) then
				CreateGuideFrame_Map001()
			end
		end
		
		--检测引导第一关第一次结束
		if (nStep == 3) then
			local map01FirstLeave = LuaGetPlayerGuideState(g_curPlayerName, "world/td_001_lsc", 2) --玩家第一次玩第一关胜利
			if (map01FirstLeave == 0) then
				--登入引导、第一关开始引导、第一关结束引导完成
				LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 1)
				LuaSetPlayerGuideState(g_curPlayerName, "world/td_001_lsc", 1)
				LuaSetPlayerGuideState(g_curPlayerName, "world/td_001_lsc", 2)
				
				CreateGuideFrame_Map001End()
			end
		end
	elseif (mapName == "world/td_002_zjtj") then --第二关
		--检测引导第二关第一次进游戏选人界面
		if (nStep == 1) then
			local guide4_state = LuaGetPlayerGuideState(g_curPlayerName, "world/td_002_zjtj", 1)
			if (guide4_state == 0) then
				CreateGuideFrame_Map002SelectHero()
			end
		end
		
		--检测引导第二关造高级塔
		if (nStep == 2) then
			local guide5_state = LuaGetPlayerGuideState(g_curPlayerName, "world/td_002_zjtj", 2)
			if (guide5_state == 0) then
				CreateGuideFrame_Map002TowerSkill()
			end
		end
		
		--检测引导第二关第一次结束
		if (nStep == 3) then
			local map02FirstLeave = LuaGetPlayerGuideState(g_curPlayerName, "world/td_002_zjtj", 3) --玩家第一次玩第二关胜利
			if (map02FirstLeave == 0) then
				--引导打第二关、第二关开始前引导选人界面、第二关开始引导造高级塔、第二关结束引导
				LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 3) --玩家引导点第二关
				LuaSetPlayerGuideState(g_curPlayerName, "world/td_002_zjtj", 1)
				LuaSetPlayerGuideState(g_curPlayerName, "world/td_002_zjtj", 2)
				LuaSetPlayerGuideState(g_curPlayerName, "world/td_002_zjtj", 3)
				
				CreateGuideFrame_Map002End()
			end
		end
	end
	]]
	--nStep: 游戏场景里的步骤(1:刚进游戏 / 2:选人结束 / 3:游戏结束 / nil:其他场景无此值)
	if (mapName == "town/town_maindota") then --新主界面
		local townGuideFifthEnter = LuaGetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 5) --玩家引导开商店界面
		--print("townGuideFifthEnter=", townGuideFifthEnter)
		
		local isFinishMap1 = LuaGetPlayerMapAchi("world/td_001_lsc", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第一关是否解锁
		local isFinishMap2 = LuaGetPlayerMapAchi("world/td_002_zjtj", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第二关是否解锁
		local isFinishMap3 = LuaGetPlayerMapAchi("world/td_003_tflw", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第三关是否解锁
		--print("isFinishMap1=", isFinishMap1)
		--print("isFinishMap2=", isFinishMap2)
		--print("isFinishMap3=", isFinishMap3)
		
		if (isFinishMap3 == 1) then --解锁了第三关，所有的引导都标记已完成
			townGuideFifthEnter = 1 --玩家引导开商店界面
		end
		
		if (townGuideFifthEnter == 0) then --玩家引导商店界面
			--解锁了第二关才能引导商店界面
			if (isFinishMap2 == 1) then
				CreateGuideFrame_ShopBuy() --geyachao: 待完善此引导 todo
			end
		end
	elseif (mapName == "town/town_mainmenu") then --旧版主城界面
		--
	elseif (mapName == "town/select_map") then --选择关卡界面
		if (hVar.OPTIONS.IS_SHOW_GUIDE == 0) then
			return
		end
		
		--nStep: 选择关卡的步骤(0:进入界面 / 1:点击新开启的关卡按钮)
		if (nStep == 0) then
			--[[
			--geyachao: 王总说都不要了
			if (nStep == 0) then --选择关卡表示是刚进入
				local townGuideFirstEnter = LuaGetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 1) --玩家第一次进入主城
				local townGuideSecondEnter = LuaGetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 2) --玩家引导查看英雄界面
				local townGuideThirdEnter = LuaGetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 3) --玩家引导查看任务成就界面
				local townGuideForthEnter = LuaGetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 4) --玩家引导点第二关
				local townGuideFifthEnter = LuaGetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 5) --玩家引导开商店界面
				local townGuideSixthEnter = LuaGetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 6) --玩家引导战术技能卡界面
				
				local isFinishMap1 = LuaGetPlayerMapAchi("world/td_001_lsc", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第一关是否解锁
				local isFinishMap2 = LuaGetPlayerMapAchi("world/td_002_zjtj", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第二关是否解锁
				local isFinishMap3 = LuaGetPlayerMapAchi("world/td_003_tflw", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第三关是否解锁
				
				--解锁了第三关，所有的引导都标记已完成
				if (isFinishMap3 == 1) then
					--标记所有的引导都完成
					LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 1) --玩家第一次进入主城
					LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 2) --玩家引导查看英雄界面
					LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 3) --玩家引导查看任务成就界面
					LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 4) --玩家引导点第二关
					LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 5) --玩家引导开商店界面
					LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 6) --玩家引导战术技能卡界面
					LuaSetPlayerGuideState(g_curPlayerName, "world/td_001_lsc", 1) --第一关引导游戏基本操作
					LuaSetPlayerGuideState(g_curPlayerName, "world/td_001_lsc", 2) --第一关第一次结束
					LuaSetPlayerGuideState(g_curPlayerName, "world/td_002_zjtj", 1)
					LuaSetPlayerGuideState(g_curPlayerName, "world/td_002_zjtj", 2)
					LuaSetPlayerGuideState(g_curPlayerName, "world/td_002_zjtj", 3)
				else
					if (townGuideFirstEnter == 0) then --玩家第一次进入主城
						CreateGuideFrame_MapMain()
					elseif (townGuideSecondEnter == 0) then --玩家引导查看英雄界面
						--解锁了第一关才能引导点将台
						if (isFinishMap1 == 1) then
							CreateGuideFrame_HeroFrm()
						end
					elseif (townGuideThirdEnter == 0) then --玩家引导点第二关
						--解锁了第一关才能引导挑战第二关
						if (isFinishMap1 == 1) then
							CreateGuideMap002_Frm()
						end
					elseif (townGuideForthEnter == 0) then --玩家引导开商店界面
						--解锁了第二关才能引导挑战第二关
						if (isFinishMap2 == 1) then
							CreateGuideFrame_ShopBuy()
						end
					elseif (townGuideFifthEnter == 0) then --玩家引导战术技能卡界面
						--解锁了第二关才能引导挑战第二关
						if (isFinishMap2 == 1) then
							CreateGuideFrame_TacticFrm()
						end
					end
				end
			end
			]]
			
			local townGuideFirstEnter = LuaGetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 1) --玩家第一次进入主城
			local townGuideSecondEnter = LuaGetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 2) --玩家引导查看英雄界面
			local townGuideThirdEnter = LuaGetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 3) --玩家引导查看任务成就界面
			local townGuideForthEnter = LuaGetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 4) --玩家引导点第二关
			--local townGuideFifthEnter = LuaGetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 5) --玩家引导开商店界面
			local townGuideSixthEnter = LuaGetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 6) --玩家引导战术技能卡界面
			
			local isFinishMap1 = LuaGetPlayerMapAchi("world/td_001_lsc", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第一关是否解锁
			local isFinishMap2 = LuaGetPlayerMapAchi("world/td_002_zjtj", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第二关是否解锁
			local isFinishMap3 = LuaGetPlayerMapAchi("world/td_003_tflw", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第三关是否解锁
			
			if (isFinishMap3 == 1) then --解锁了第三关，所有的引导都标记已完成
				townGuideFirstEnter = 1 --玩家第一次进入主城
				townGuideSecondEnter = 1 --玩家引导查看英雄界面
				townGuideThirdEnter = 1 --玩家引导查看任务成就界面
				townGuideForthEnter = 1 --玩家引导点第二关
				--townGuideFifthEnter = 1 --玩家引导开商店界面
				townGuideSixthEnter = 1 --玩家引导战术技能卡界面
			elseif (isFinishMap2 == 1) then --解锁了第二关，关于第一关、第二关的引导已完成
				townGuideFirstEnter = 1 --玩家第一次进入主城
				townGuideForthEnter = 1 --玩家引导点第二关
			elseif (isFinishMap1 == 1) then --解锁了第一关，关于第一关的引导已完成
				townGuideFirstEnter = 1 --玩家第一次进入主城
			end
			
			if (townGuideFirstEnter == 0) then --玩家第一次进入主城
				CreateGuideFrame_MapMain()
			elseif (townGuideSecondEnter == 0) then --玩家引导查看英雄界面
				--解锁了第一关才能引导点将台
				if (isFinishMap1 == 1) then
					--CreateGuideFrame_HeroFrm() --geyachao: 待完善此引导 todo
				end
			elseif (townGuideThirdEnter == 0) then --玩家引导查看任务成就界面
				--解锁了第一关才能引导任务成就
				if (isFinishMap1 == 1) then
					--CreateGuideFrame_TaskFrm() --geyachao: 待完善此引导 todo
				end
			elseif (townGuideForthEnter == 0) then --玩家引导点第二关
				--解锁了第一关才能引导挑战第二关
				if (isFinishMap1 == 1) then
					CreateGuideMap002_Frm()
				end
			--[[
			elseif (townGuideFifthEnter == 0) then --玩家引导商店界面
				--解锁了第二关才能引导商店界面
				if (isFinishMap2 == 1) then
					--CreateGuideFrame_ShopBuy() --geyachao: 待完善此引导 todo
				end
			]]
			elseif (townGuideSixthEnter == 0) then --玩家引导战术技能卡界面
				--解锁了第二关才能引导战术技能卡界面
				if (isFinishMap2 == 1) then
					--CreateGuideFrame_TacticFrm() --geyachao: 待完善此引导 todo
				end
			end
		end
	elseif (mapName == "world/td_001_lsc") then --第一关
		local isFinish = LuaGetPlayerMapAchi(mapName,hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
		--isFinish = 0
		--print("isFinish", isFinish, nStep,LuaGetPlayerGuideState(g_curPlayerName, "world/td_001_lsc", 2))
		if (isFinish == 0) then
			--检测引导第一关第一次进游戏
			if (nStep == 1) then
				local map01FirstEnter = LuaGetPlayerGuideState(g_curPlayerName, "world/td_001_lsc", 1) --第一关引导游戏基本操作
				if (map01FirstEnter == 0) then
					CreateGuideFrame_Map001()
				end
			end
		end
		
		--检测引导第一关第一次结束
		if (nStep == 3) then
			local isFinish = LuaGetPlayerMapAchi(mapName,hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
			local fightCount = (LuaGetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.FINISH_COUNT) or 0) --第一关通关的次数
			--print("检测引导第一关第一次结束", fightCount)
			--isFinish = 0
			if (fightCount == 1) then --第一关第一次通关，才会走到这里
				local map01FirstLeave = LuaGetPlayerGuideState(g_curPlayerName, "world/td_001_lsc", 2) --第一关第一次结束
				if (map01FirstLeave == 0) then
					--登入引导、第一关开始引导、第一关结束引导完成
					LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 1)
					LuaSetPlayerGuideState(g_curPlayerName, "world/td_001_lsc", 1) --第一关引导游戏基本操作
					LuaSetPlayerGuideState(g_curPlayerName, "world/td_001_lsc", 2) --第一关第一次结束
					
					--引导第一关结束之后点 确定 按钮
					CreateGuideFrame_Map001End()
				end
			end
		end
	elseif (mapName == "world/td_002_zjtj") then --第二关
		local isFinish = LuaGetPlayerMapAchi(mapName,hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
		--isFinish = 0
		if (isFinish == 0) then
			--检测引导第二关第一次进游戏选人界面
			if (nStep == 1) then
				local guide4_state = LuaGetPlayerGuideState(g_curPlayerName, "world/td_002_zjtj", 1)
				if (guide4_state == 0) then
					CreateGuideFrame_Map002SelectHero()
				end
			end
			
			--检测引导第二关造高级塔
			if (nStep == 2) then
				local guide5_state = LuaGetPlayerGuideState(g_curPlayerName, "world/td_002_zjtj", 2)
				if (guide5_state == 0) then
					CreateGuideFrame_Map002TowerSkill()
				end
			end
		end
		
		--检测引导第二关第一次结束
		if (nStep == 3) then
			--local isFinish = LuaGetPlayerMapAchi(mapName,hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
			local fightCount = (LuaGetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.FINISH_COUNT) or 0) --第二关通关的次数
			--print("检测引导第二关第一次结束", fightCount)
			--isFinish = 0
			if (fightCount == 1) then --第二关第一次通关，才会走到这里
				local map02FirstLeave = LuaGetPlayerGuideState(g_curPlayerName, "world/td_002_zjtj", 3) --玩家第一次玩第二关胜利
				if (map02FirstLeave == 0) then
					--引导打第二关、第二关开始前引导选人界面、第二关开始引导造高级塔、第二关结束引导
					LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 4) --玩家引导点第二关
					LuaSetPlayerGuideState(g_curPlayerName, "world/td_002_zjtj", 1)
					LuaSetPlayerGuideState(g_curPlayerName, "world/td_002_zjtj", 2)
					LuaSetPlayerGuideState(g_curPlayerName, "world/td_002_zjtj", 3)
					
					--引导第二关结束
					CreateGuideFrame_Map002End()
				end
			end
		end
	end
end)
