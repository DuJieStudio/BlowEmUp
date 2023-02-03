--添加玩家选好的英雄
local _addHeroList = function(tHeroList)
	local oWorld = hGlobal.WORLD.LastWorldMap
	if oWorld==nil then
		return
	end
	if (#tHeroList == 0) then
		return
	end
	
	local mapInfo = oWorld.data.tdMapInfo
	if not mapInfo then
		return
	end
	
	--local bornPoint = 0 --英雄的出生点
	
	----geyachao: 普通模式，出生点为地图填写的位置，PVP模式，出生点为指定位置
	--if (mapInfo.mapMode == hVar.MAP_TD_TYPE.NORMAL) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.DIFFICULT) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then --普通模式和挑战难度模式
	--	--地图填写的位置
	--	bornPoint = mapInfo.heroBornPoint
	--elseif (mapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then --PVP模式
	--	--PVP指定位置
	--	bornPoint = mapInfo.heroBirthPos[1]
	--end
	
	----非法出生点，直接返回
	--if (not bornPoint) then
	--	return
	--end
	
	--重新创建所有玩家的英雄
	local tempWorldParam = {}
	local worldScene = oWorld.handle.worldScene
	
	local targetAngleOrigin = {0, 72, 144, 216, 288} --目标的坐标偏移角度列表（用于随机位置）
	local targetAngle = {} --目标的坐标偏移角度列表
	for i = 1, #tHeroList, 1 do
		local id = tHeroList[i].id --单位类型id
		--local nOwner = tHeroList[i].owner or oWorld:GetPlayerMe():getpos()
		local nOwner = 1
		--print("nOwner=", nOwner)
		local owner = oWorld:GetPlayer(nOwner)
		--print("owner=", owner)
		local god = owner:getgod()
		--print("tHeroList[i].id=", tHeroList[i].id)
		--print("tHeroList[i].owner=", tHeroList[i].owner)
		--print("tHeroList[i].lv=", tHeroList[i].lv)
		--print("tHeroList[i].star=", tHeroList[i].id)
		
		--添加单位
		--读取单位的等级
		local HeroCard = hApi.GetHeroCardById(id)
		local cardLv = 1 --英雄的等级
		local cardStar = 1 --英雄星级
		if HeroCard then
			--zhenkira 2015.11.25
			--cardLv = HeroCard.cardLv
			if HeroCard.attr then
				cardLv = HeroCard.attr.level or 1
				cardStar = HeroCard.attr.star or 1
			end
		end
		local nLv = tHeroList[i].lv or cardLv
		local nStar = tHeroList[i].star or cardStar
		
		--创建单位
		if (#targetAngle == 0) then --避免随不到
			for i = 1, #targetAngleOrigin, 1 do
				table.insert(targetAngle, targetAngleOrigin[i])
			end
		end
		--unitId ,owner, gridX, gridY, facing, worldX, worldY, attr, data, lv
		local radius = 30
		local randAngleIdx = oWorld:random(1, #targetAngle) --随机偏移角度索引值
		local angle = targetAngle[randAngleIdx] --随机角度
		table.remove(targetAngle, randAngleIdx)
		local fangle = angle * math.pi / 180 --弧度制
		fangle = math.floor(fangle * 100) / 100 --保留2位有效数字（用于同步）
		local dx = 0 --随机偏移值x
		local dy = 0 --随机偏移值y
		if (#tHeroList > 1) then --一个英雄就不随了
			dx = math.floor(radius * math.cos(fangle)) --随机偏移值x
			dy = math.floor(radius * math.sin(fangle)) --随机偏移值y
		end
		local godX, godY = 0, 0
		if god then
			godX, godY = god:getXY()
		end
		local randPosX = godX + dx --随机x位置
		local randPosY = godY + dy --随机y位置
		if (hApi.IsPosInWater(randPosX, randPosY) == 1) then
			randPosX = godX
			randPosY = godY
		end
		randPosX, randPosY = hApi.Scene_GetSpace(randPosX, randPosY, 50)
		
		if god then
			angle = god.data.facing
		end
		
		--如果在主基地，设置单位坐标为上次在主基地的坐标
		--print("oWorld.data.map=", oWorld.data.map)
		if (oWorld.data.map == hVar.MainBase) then
			local mainbasePosX = hGlobal.LocalPlayer.data.mainbasePosX
			local mainbasePosY = hGlobal.LocalPlayer.data.mainbasePosY
			local mainbaseFacing = hGlobal.LocalPlayer.data.mainbaseFacing
			--print("mainbasePosX=", mainbasePosX)
			--print("mainbasePosY=", mainbasePosY)
			if (mainbasePosX > 0) and (mainbasePosY > 0) then
				randPosX = mainbasePosX
				randPosY = mainbasePosY
			end
			
			if mainbaseFacing then
				angle = mainbaseFacing
			end
		end
		
		--大菠萝，英雄出生角度和出生点一致
		--[[
		oWorld:enumunit(function(eu)
			if (eu.data.type == hVar.UNIT_TYPE.PLAYER_INFO) then --10:玩家信息
				--
			elseif (eu.data.type == hVar.UNIT_TYPE.WAY_POINT) then --11:路点、集合点
				angle = eu.data.facing
			end
		end)
		]]
		
		--god.data.facing
		local oUnit = oWorld:addunit(id, nOwner, nil ,nil, angle, randPosX, randPosY, nil, nil, nLv, nStar)
		--oUnit.data.defend_distance_max = 150 --英雄的默认守卫范围是150
		--print("_________________________________addHeroList:".. tostring(oUnit) .. ",".. tostring(id)..",".. tostring(nLv).. ",".. tostring(nStar))
		
		--local oHero = hClass.hero:new(
		--{
		--	name = hVar.tab_stringU[id][1],
		--	id = id,
		--	owner = nOwner,
		--	--unit = oUnit,
		--	playmode = oWorld.data.playmode,
		--	HeroCard = HeroCard,
		--})
		local oHero = owner:createhero(id, HeroCard)
		oHero:bind(oUnit)
		--oHero:LoadHeroFromCard() --读取道具附加属性
		hGlobal.event:call("Event_UnitBorn", oUnit)
		
		--战车成就相关：同时携带的宠物数量清0
		local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
		local nStage = tInfo.stage or 1 --本关id
		if tInfo.stageInfo == nil then
			tInfo.stageInfo = {}
		end
		if tInfo.stageInfo[nStage] == nil then
			tInfo.stageInfo[nStage] = {}
		end
		
		if (tInfo.stageInfo[nStage]["maxtocarry_pet"] == nil) then
			tInfo.stageInfo[nStage]["maxtocarry_pet"] = 0
		end
		
		--[[
		--添加5级瓦力卡出场
		if (mapInfo.mapMode ~= hVar.MAP_TD_TYPE.TANKCONFIG) then --不是配置界面
			local tTactics = LuaGetPlayerSkillBook()
			if tTactics then
				for i = 1, #tTactics, 1 do
					if type(tTactics[i])=="table" then
						local id, lv, num = unpack(tTactics[i])
						--print(id, lv, num)
						if (id == 5005) then --瓦利战术卡
							if (lv >= 5) then --5级瓦利出场自动跟随
								local petId = 12217 --瓦利单位id
								local petLv = lv --瓦利等级
								local petPosX = randPosX + oWorld:random(-50, 50) --随机x位置
								local petPosY = randPosY + oWorld:random(-50, 50) --随机y位置
								petPosX, petPosY = hApi.Scene_GetSpace(petPosX, petPosY, 50)
								local petSide = 1 --蜀国
								local oWalleUnit = oWorld:addunit(petId, petSide, nil ,nil, angle, petPosX, petPosY, nil, nil, petLv, 1)
								
								--存储数据
								oWorld.data.rpgunits[oWalleUnit] = oWalleUnit:getworldC() --标记是我方单位
							end
						end
					end
				end
			end
		end
		]]
		
		--添加跟随的宠物
		local petIdx = LuaGetHeroPetIdx(id)
		local petIdx2 = LuaGetHeroPetIdx2(id)
		local petIdx3 = LuaGetHeroPetIdx3(id)
		local petIdx4 = LuaGetHeroPetIdx4(id)
		local petIdList = {}
		if (petIdx > 0) then
			petIdList[#petIdList+1] = petIdx
		end
		if (petIdx2 > 0) then
			petIdList[#petIdList+1] = petIdx2
		end
		if (petIdx3 > 0) then
			petIdList[#petIdList+1] = petIdx3
		end
		if (petIdx4 > 0) then
			petIdList[#petIdList+1] = petIdx4
		end
		for i = 1, #petIdList, 1 do
			local petIdx = petIdList[i]
			--print("添加跟随的宠物", petIdx)
			if (petIdx > 0) then
				--d.follow_pet_unit = 0 --我方跟随的宠物
				local tPet = hVar.tab_unit[id].pet_unit
				if tPet then
					local petId = tPet[petIdx].summonUnit
					if (petId > 0) then
						--宠物血量百分比
						local petHpPercent = -1
						
						--大菠萝，配置界面
						if (mapInfo.mapMode == hVar.MAP_TD_TYPE.TANKCONFIG) then
							petHpPercent = 100
						else
							--[[
							--宠物继承之前关卡的血量
							local tInfo = LuaGetPlayerRandMapInfo(g_curPlayerName)
							local nStage = tInfo.stage or 1 --本关id
							if (tInfo.stageInfo == nil) then
								tInfo.stageInfo = {}
							end
							if (tInfo.stageInfo[nStage] == nil) then
								tInfo.stageInfo[nStage] = {}
							end
							
							petHpPercent = tInfo.stageInfo[nStage]["petHpPercent"] --本关地图内宠物血量百分比
							
							if (petHpPercent == nil) then --没有本关信息
								if (nStage == 0) then --引导关
									petHpPercent = 100
								elseif (nStage == 1) then --第1关
									petHpPercent = 100
								else --读前一关的值
									petHpPercent = tInfo.stageInfo[nStage - 1] and tInfo.stageInfo[nStage - 1]["petHpPercent"] or 100
								end
								
								--存储本关的宠物血量值
								tInfo.stageInfo[nStage]["petHpPercent"] = petHpPercent
							end
							]]
							petHpPercent = 100
						end
						
						--宠物有血
						if (petHpPercent > 0) then
							--print("petId=", petId)
							local petStar = LuaGetHeroPetLv(id, petIdx) --当前星级
							local petLv = LuaGetHeroPetExp(id, petIdx) --当前等级
							local petPosX = randPosX + oWorld:random(-50, 50) --随机x位置
							local petPosY = randPosY + oWorld:random(-50, 50) --随机y位置
							petPosX, petPosY = hApi.Scene_GetSpace(petPosX, petPosY, 50)
							local petSide = 1 --蜀国
							if (oWorld.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.TANKCONFIG) then --配置坦克地图
								petSide = 21
							end
							local oPetUnit = oWorld:addunit(petId, petSide, nil ,nil, angle, petPosX, petPosY, nil, nil, petLv, petStar)
							
							--更新宠物血量
							oPetUnit.attr.hp = math.ceil(oPetUnit:GetHpMax() * petHpPercent / 100)
							
							oWorld.data.rpgunits[oPetUnit] = oPetUnit:getworldC() --标记是我方单位
							oWorld.data.follow_pet_unit = oPetUnit
						end
					end
				end
			end
		end
		
		--大菠萝，调试模式，加血加速度
		if (hVar.OPTIONS.HPADD_MODE == 1) then
			local skill_id = 15997
			local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
			local gridX, gridY = oWorld:xy2grid(targetX, targetY)
			local tCastParam =
			{
				level = 1, --等级
			}
			hApi.CastSkill(oUnit, skill_id, 0, 100, oUnit, gridX, gridY, tCastParam) --战车加血技能
		end
		if (hVar.OPTIONS.SPEEDADD_MODE == 1) then
			local skill_id = 15999
			local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
			local gridX, gridY = oWorld:xy2grid(targetX, targetY)
			local tCastParam =
			{
				level = 1, --等级
			}
			hApi.CastSkill(oUnit, skill_id, 0, 100, oUnit, gridX, gridY, tCastParam) --战车加速度技能
		end
		
		--自动选中
		if (hVar.OP_LASTING_MODE == 1) then
			local gridX, gridY = oWorld:xy2grid(randPosX, randPosY)
			oWorld:GetPlayerMe().localoperate:touch(oWorld, hVar.LOCAL_OPERATE_TYPE.TOUCH_UP, gridX, gridY, randPosX, randPosY)
			
			--[[
			--镜头自动跟随
			oWorld:addtimer("__TD__Camera_Follow_", 1, function(deltaTime)
				local oHero = oWorld:GetPlayerMe().heros[1]
				if oHero then
					local oUnit = oHero:getunit()
					if oUnit then
						local px, py = hApi.chaGetPos(oUnit.handle)
						--聚焦
						hApi.setViewNodeFocus(px, py)
					end
				end
			end)
			]]
		end
		
		--添加道具技能
		--大菠萝
		--hGlobal.event:event("Event_AddTacticsActiveSkill", oWorld:GetPlayerMe(), 11024, 1, 1, 6000, true) --埋地雷
		--hGlobal.event:event("Event_AddTacticsActiveSkill", oWorld:GetPlayerMe(), 11022, 1, 1, 6000, true) --战车冲刺
		--hGlobal.event:event("Event_AddTacticsActiveSkill", oWorld:GetPlayerMe(), 11023, 1, 1, 6000, true) --扔手雷
		--hGlobal.event:event("Event_AddTacticsActiveSkill", oWorld:GetPlayerMe(), 11025, 1, 1, 6000, true) --开一枪
		
		--[[
		local rooms = oWorld.data.randomMapRooms
		--print("rooms1=", rooms)
		if (type(rooms) == "table") then
			--找到最左上角的区域
			--地图内铺地板的物件
			local pixSize = 16 * 3
			local MIN_PX = math.huge
			local MIN_PY = math.huge
			local MIN_PW = 0
			local MIN_PH = 0
			local map_offsetX = 0
			local map_offsetY = 0
			for _, RoomValue in pairs(rooms) do
				local PX = RoomValue.x + map_offsetX
				local PY = RoomValue.y + map_offsetY
				local PW = RoomValue.w
				local PH = RoomValue.h
				--print(PX, PY, PW, PH)
				
				if (PX < MIN_PX) and (PY < MIN_PY) then
					MIN_PX = PX
					MIN_PY = PY
					MIN_PW = PW
					MIN_PH = PH
				end
				--local inside = RoomValue._inside
				
			end
			--print(MIN_PX, MIN_PY)
			oUnit:setPos(MIN_PX*pixSize+MIN_PW/2*pixSize, MIN_PY*pixSize+MIN_PH/2*pixSize)
			
			--地图远景物件
			local farObjs = {}
			if (farObjs == 0) then
				farObjs = {}
			end
			oWorld:enumunit(function(eu)
				if (eu.data.type == hVar.UNIT_TYPE.NOT_USED) then
					farObjs[#farObjs+1] = eu
				end
			end)
			local camX, camY = xlGetViewNodeFocus()
			farObjs.camX = camX
			farObjs.camY = camY
			oWorld.data.randomMapFarSceneObjs = farObjs
			
			--地图远景物件
			local farObj = oWorld.data.randomMapFarSceneObj
			if (type(farObj) == "table") then
				local node = farObj.node
				for n = 1, #node, 1 do
					local nodei = node[n]
					nodei:setPosition(ccp(randPosX, -randPosY))
				end
				farObj.camX = randPosX
				farObj.camY = randPosY
			end
			--randPosX, randPosY
		end
		]]
		
		--随机迷宫地图
		if (oWorld.data.map == hVar.RandomMap) then
			local regionPoint = 1
			-- 战车区域生成点系数
			local tMultiply = hVar.RANDMAP_REGION_POINT_MULTIPLY[regionPoint]
			local avatarInfoId = tMultiply.avatarInfoId or 0 --皮肤id
			if (avatarInfoId <= 0) then
				--启动图
				avatarInfoId = oWorld:random(1, hVar.RANDMAP_ROOM_AVATAR_INFO.RandRange)
			end
			--[[
			--用指定皮肤
			if (g_avatarInfoId ~= nil) then
				avatarInfoId = g_avatarInfoId
				g_avatarInfoId = nil
			end
			]]
			local random_ObjectInfo = hVar.RANDMAP_ROOM_AVATAR_INFO[avatarInfoId]
			--清除前一层的全部物件
			hApi.ClearRandomMap(oWorld, oWorld.data.randommapIdx, true)
			--print("random_ObjectInfo.renders=", random_ObjectInfo.renders)
			-- units_list的初始化在map_xx.dat文件中，文件中的lua代码会在运行中按需动态加载，记录的是地图单位的配置信息
			hApi.CreateRandomMap(oWorld, random_ObjectInfo, units_list.random_RoomClass, 0, 0, regionPoint, avatarInfoId)
			local bGenerateNormal= true
			local bGenerateBoss = false
			hApi.CreateRandMapEnemys(oWorld, 1, bGenerateNormal, bGenerateBoss)
			
			--随机地图立即发兵
			hApi.RandomMapRoomSendArmyTimer()
			
			--更新排名（第一小关）
			local bId = 1
			local nStageValue = oWorld.data.randommapStage * 10 + oWorld.data.randommapIdx
			SendCmdFunc["update_billboard_rank"](bId, nStageValue)
			
			--触发事件：战车随机地图所在区域变化事件（启动）
			hGlobal.event:event("Event_RandomMapRegionChanged")
		end
		
		--启动画面
		if (oWorld.data.map == hVar.LoginMap) then
			local regionPoint = 5
			local tMultiply = hVar.RANDMAP_REGION_POINT_MULTIPLY[regionPoint]
			local avatarInfoId = tMultiply.avatarInfoId or 0 --皮肤id
			if (avatarInfoId <= 0) then
				--第1小关
				avatarInfoId = oWorld:random(1, hVar.RANDMAP_ROOM_AVATAR_INFO.RandRange)
			end
			local random_ObjectInfo = hVar.RANDMAP_ROOM_AVATAR_INFO[avatarInfoId]
			hApi.CreateRandomMap(oWorld, random_ObjectInfo, units_list.random_RoomClass, 0, 0, regionPoint, avatarInfoId)
			local bGenerateNormal= true
			local bGenerateBoss = true
			--hApi.CreateRandMapEnemys(oWorld, 1, bGenerateNormal, bGenerateBoss) --todo:调试效率问题先不发兵
			
			--随机地图立即发兵
			hApi.RandomMapRoomSendArmyTimer()
			--缩小view
			xlView_SetScale(0.3)
			
			--战车进入混乱状态
			local skill_id = 31080
			local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
			local gridX, gridY = oWorld:xy2grid(targetX, targetY)
			local tCastParam =
			{
				level = 1, --等级
			}
			--print(oUnit.data.name)
			hApi.CastSkill(oUnit, skill_id, 0, 100, oUnit, gridX, gridY, tCastParam) --战车加速度技能
		end
		
		--玩家自定义地图
		if (oWorld.data.map == "world/csys_random_test_userdef") then
			local regionPoint = 1001
			local tMultiply = hVar.RANDMAP_REGION_POINT_MULTIPLY[regionPoint]
			local avatarInfoId = tMultiply.avatarInfoId or 0 --皮肤id
			if (avatarInfoId <= 0) then
				--启动图
				avatarInfoId = oWorld:random(1, hVar.RANDMAP_ROOM_AVATAR_INFO.RandRange)
			end
			--[[
			--用指定皮肤
			if (g_avatarInfoId ~= nil) then
				avatarInfoId = g_avatarInfoId
				g_avatarInfoId = nil
			end
			]]
			local random_ObjectInfo = hVar.RANDMAP_ROOM_AVATAR_INFO[avatarInfoId]
			--清除前一层的全部物件
			hApi.ClearRandomMap(oWorld, oWorld.data.randommapIdx, true)
			--print("random_ObjectInfo.renders=", random_ObjectInfo.renders)
			hApi.CreateRandomMap(oWorld, random_ObjectInfo, units_list.random_RoomClass, 0, 0, regionPoint, avatarInfoId)
			local bGenerateNormal= true
			local bGenerateBoss = false
			hApi.CreateRandMapEnemys(oWorld, 1, bGenerateNormal, bGenerateBoss)
			
			--随机地图立即发兵
			hApi.RandomMapRoomSendArmyTimer()
			
			--触发事件：战车随机地图所在区域变化事件（启动）
			hGlobal.event:event("Event_RandomMapRegionChanged")
		end
		
		local tabM = hVar.MAP_INFO[oWorld.data.map]
		local roomObjId = tabM.roomObjId or 0 --宇宙背景风格id
		if (roomObjId > 0) then
			local worldLayer = oWorld.handle.worldLayer
			local tRoomObjInfo = hVar.RANDMAP_ROOM_AVATAR_INFO[roomObjId]
			if tRoomObjInfo then
				--地球远景层
				local universe_farobj = nil
				local farobj = tRoomObjInfo.farobj
				if farobj then
					--地球层中景物件
					local tImg = farobj.img
					local loopnum = farobj.num or 0
					local scale = farobj.scale or 1
					local rollRatio = farobj.rollRatio or 0.1 --卷轴速率
					if (type(tImg) == "table") then
						local tNodeFar = {}
						local IMGNUM = (#tImg)
						for loop = 1, loopnum, 1 do
							--计算图片索引
							local idx = loop % IMGNUM
							if (idx == 0) then
								idx = IMGNUM
							end
							
							--计算缩放
							local scale0 = 1
							if (type(scale) == "number") then
								scale0 = scale
							elseif (type(scale) == "table") then
								local scaleMin = scale[1] or 1
								local scaleMax = scale[2] or 1
								scale0 = math.random(math.floor(scaleMin * 100), math.floor(scaleMax * 100)) / 100
							end
							
							--宇宙层远景物件
							local imgFileName = tImg[idx]
							local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
							if (not texture) then
								texture = CCTextureCache:sharedTextureCache():addImage(imgFileName)
								print("加载宇宙层远景物件图！", imgFileName)
							end
							local tSize = texture:getContentSize()
							local spriteFar = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
							spriteFar:setAnchorPoint(ccp(0.5, 0.5))
							spriteFar:setPosition(ccp(randPosX, -randPosY))
							--spriteFar:setContentSize(CCSizeMake(d.sizeW, d.sizeH))
							--spriteFar:setScaleX(d.sizeW/tSize.width)
							--spriteFar:setScaleY(d.sizeH/tSize.height)
							spriteFar:setScale(scale0)
							worldLayer:addChild(spriteFar, 0)
							tNodeFar[#tNodeFar+1] = spriteFar
						end
						
						--存储
						--local camX, camY = xlGetViewNodeFocus()
						universe_farobj = {node = tNodeFar, camX = randPosX, camY = randPosY, rollRatio = rollRatio,}
					end
				end
				
				--星星中景层
				local universe_middleobj = nil
				local middleobj = tRoomObjInfo.middleobj
				if middleobj then
					--星星层中景物件
					local tImg = middleobj.img
					local loopnum = middleobj.num or 0
					local scale = middleobj.scale or 1
					local rollRatio = middleobj.rollRatio or 0.16 --卷轴速率
					if (type(tImg) == "table") then
						--宇宙层中景物件
						local tNodeMiddle = {}
						local IMGNUM = (#tImg)
						for loop = 1, loopnum, 1 do
							--计算图片索引
							local idx = loop % IMGNUM
							if (idx == 0) then
								idx = IMGNUM
							end
							
							--计算缩放
							local scale0 = 1
							if (type(scale) == "number") then
								scale0 = scale
							elseif (type(scale) == "table") then
								local scaleMin = scale[1] or 1
								local scaleMax = scale[2] or 1
								scale0 = math.random(math.floor(scaleMin * 100), math.floor(scaleMax * 100)) / 100
							end
							
							--星星图片
							local imgFileName = tImg[idx]
							local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
							if (not texture) then
								texture = CCTextureCache:sharedTextureCache():addImage(imgFileName)
								print("加载宇宙层中景物件图！", imgFileName)
							end
							local tSize = texture:getContentSize()
							local sprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
							local randX = math.random(math.floor(oWorld.data.sizeW*0.2), math.floor(oWorld.data.sizeW*0.8))
							local randY = math.random(math.floor(oWorld.data.sizeH*0.2), math.floor(oWorld.data.sizeH*0.8))
							local rot = math.random(0, 360)
							--local scale = math.random(20, 75) / 100
							sprite:setAnchorPoint(ccp(0.5, 0.5))
							sprite:setPosition(ccp(randX, -randY))
							sprite:setRotation(rot)
							sprite:setScale(scale0)
							--sprite:setContentSize(CCSizeMake(d.sizeW, d.sizeH))
							--sprite:setScaleX(d.sizeW/tSize.width)
							--sprite:setScaleY(d.sizeH/tSize.height)
							--sprite:setScaleX(2.5)
							--sprite:setScaleY(2.5)
							worldLayer:addChild(sprite, 1)
							tNodeMiddle[#tNodeMiddle+1] = sprite
							
							--动画
							--近景物件图标随机动画
							--local delayTime1 = math.random(800, 1600)
							--local delayTime2 = math.random(800, 1600)
							local moveTime = math.random(5000, 7500) / 1000
							local scaleTo = scale0 + math.random(10, 25) / 100
							--local act1 = CCDelayTime:create(delayTime1/1000)
							local act2A = CCScaleTo:create(moveTime/2, scaleTo)
							local act2B = CCScaleTo:create(moveTime/2, scale0)
							local act2 = CCSequence:createWithTwoActions(act2A, act2B) --同步1
							local act3 = nil
							if (math.random(1, 2) == 1) then
								act3 = CCRotateBy:create(moveTime, math.random(10, 15))
							else
								act3 = CCRotateBy:create(moveTime, -math.random(10, 15))
							end
							local act4 = CCSpawn:createWithTwoActions(act2, act3) --同步1
							local a = CCArray:create()
							--a:addObject(act1)
							--a:addObject(act2)
							--a:addObject(act3)
							a:addObject(act4)
							local sequence = CCSequence:create(a)
							--oItem.handle.s:stopAllActions() --先停掉之前的动作
							sprite:runAction(CCRepeatForever:create(sequence))
						end
						
						--存储
						universe_middleobj = {node = tNodeMiddle, camX = randPosX, camY = randPosY, rollRatio = rollRatio,}
					end
				end
				
				--陨石近景层
				local universe_nearobj = nil
				local nearobj = tRoomObjInfo.nearobj
				if nearobj then
					--陨石层近景物件
					local tImg = nearobj.img
					local loopnum = nearobj.num or 0
					local scale = nearobj.scale or 1
					local rollRatio = nearobj.rollRatio or 0.3 --卷轴速率
					if (type(tImg) == "table") then
						--陨石层近景物件
						local tNodeNear = {}
						local IMGNUM = (#tImg)
						for loop = 1, loopnum, 1 do
							--计算图片索引
							local idx = loop % IMGNUM
							if (idx == 0) then
								idx = IMGNUM
							end
							
							--计算缩放
							local scale0 = 1
							if (type(scale) == "number") then
								scale0 = scale
							elseif (type(scale) == "table") then
								local scaleMin = scale[1] or 1
								local scaleMax = scale[2] or 1
								scale0 = math.random(math.floor(scaleMin * 100), math.floor(scaleMax * 100)) / 100
							end
							--print(scale0)
							--陨石图片
							local imgFileName = tImg[idx]
							local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
							if (not texture) then
								texture = CCTextureCache:sharedTextureCache():addImage(imgFileName)
								print("加载宇宙层近景物件图！", imgFileName)
							end
							local tSize = texture:getContentSize()
							local sprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
							local randX = math.random(math.floor(oWorld.data.sizeW*0.2), math.floor(oWorld.data.sizeW*0.8))
							local randY = math.random(math.floor(oWorld.data.sizeH*0.2), math.floor(oWorld.data.sizeH*0.8))
							local rot = math.random(0, 360)
							--local scale = math.random(40, 160) / 100
							sprite:setAnchorPoint(ccp(0.5, 0.5))
							sprite:setPosition(ccp(randX, -randY))
							sprite:setRotation(rot)
							sprite:setScale(scale0)
							--sprite:setContentSize(CCSizeMake(d.sizeW, d.sizeH))
							--sprite:setScaleX(d.sizeW/tSize.width)
							--sprite:setScaleY(d.sizeH/tSize.height)
							--sprite:setScaleX(2.5)
							--sprite:setScaleY(2.5)
							worldLayer:addChild(sprite, 1)
							tNodeNear[#tNodeNear+1] = sprite
							
							--动画
							--近景物件图标随机动画
							--local delayTime1 = math.random(800, 1600)
							--local delayTime2 = math.random(800, 1600)
							local moveTime = math.random(200000, 350000) / 1000
							local moveTo = nil
							local moveRandomValue = math.random(1, 8)
							if (moveRandomValue == 1) then
								moveTo = CCMoveBy:create(moveTime/2, ccp(math.random(600, 1200), 0))
							elseif (moveRandomValue == 2) then
								moveTo = CCMoveBy:create(moveTime/2, ccp(math.random(-1200, -600), 0))
							elseif (moveRandomValue == 3) then
								moveTo = CCMoveBy:create(moveTime/2, ccp(0, math.random(600, 1200)))
							elseif (moveRandomValue == 4) then
								moveTo = CCMoveBy:create(moveTime/2, ccp(0, math.random(-1200, -600)))
							elseif (moveRandomValue == 5) then
								moveTo = CCMoveBy:create(moveTime/2, ccp(math.random(600, 1200), math.random(600, 1200)))
							elseif (moveRandomValue == 6) then
								moveTo = CCMoveBy:create(moveTime/2, ccp(math.random(600, 1200), math.random(-1200, -600)))
							elseif (moveRandomValue == 7) then
								moveTo = CCMoveBy:create(moveTime/2, ccp(math.random(-1200, -600), math.random(600, 1200)))
							elseif (moveRandomValue == 8) then
								moveTo = CCMoveBy:create(moveTime/2, ccp(math.random(-1200, -600), math.random(-1200, -600)))
							end
							
							local moveBack = moveTo:reverse()
							--local act1 = CCDelayTime:create(delayTime1/1000)
							local act2 = CCSequence:createWithTwoActions(moveTo, moveBack) --同步1
							local act3 = nil
							local rotRandomValue = math.random(1, 8)
							if (rotRandomValue == 1) then
								act3 = CCRotateBy:create(moveTime, 3600)
							elseif (rotRandomValue == 2) then
								act3 = CCRotateBy:create(moveTime, -3600)
							elseif (rotRandomValue == 3) then
								act3 = CCRotateBy:create(moveTime, 2520)
							elseif (rotRandomValue == 4) then
								act3 = CCRotateBy:create(moveTime, -2520)
							elseif (rotRandomValue == 5) then
								act3 = CCRotateBy:create(moveTime, 1800)
							elseif (rotRandomValue == 6) then
								act3 = CCRotateBy:create(moveTime, -1800)
							elseif (rotRandomValue == 7) then
								act3 = CCRotateBy:create(moveTime, 1080)
							elseif (rotRandomValue == 8) then
								act3 = CCRotateBy:create(moveTime, -1080)
							end
							local act4 = CCSpawn:createWithTwoActions(act2, act3) --同步1
							local a = CCArray:create()
							--a:addObject(act1)
							--a:addObject(act2)
							--a:addObject(act3)
							a:addObject(act4)
							local sequence = CCSequence:create(a)
							--oItem.handle.s:stopAllActions() --先停掉之前的动作
							sprite:runAction(CCRepeatForever:create(sequence))
						end
						
						--存储
						universe_nearobj = {node = tNodeNear, camX = randPosX, camY = randPosY, rollRatio = rollRatio,}
					end
				end
				
				local regionData =
				{
					universe_farobj = universe_farobj,
					universe_middleobj = universe_middleobj,
					universe_nearobj = universe_nearobj,
					blood_effects = {}, --飙血特效集
					drop_units = {}, --掉落的道具单位集
					roomgroupSendArmyList = {}, --房间组发兵表 --{[n] = {groupId = XXX, x = XXX, y = XXX, beginTick = XXX, currentWave = XXX, unitperWave = {[1] = {...}, [2] = {...}, ...}, ...}
				}
				
				local regionId = 1
				oWorld.data.randommapInfo[regionId] = regionData --随机地图信息
				oWorld.data.randommapIdx = regionId --当前所在随机地图索引
				
				--释放资源
				--释放远景层资源
				local farobj = tRoomObjInfo.farobj
				if farobj then
					local tImg = farobj.img
					for i = 1, #tImg, 1 do
						local imgFileName = tImg[i]
						local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
						if (texture) then
							CCTextureCache:sharedTextureCache():removeTexture(texture)
							print("释放宇宙层远景物件图！", imgFileName)
						end
					end
				end
				
				--释放中景层资源
				local middleobj = tRoomObjInfo.middleobj
				if middleobj then
					local tImg = middleobj.img
					for i = 1, #tImg, 1 do
						local imgFileName = tImg[i]
						local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
						if (texture) then
							CCTextureCache:sharedTextureCache():removeTexture(texture)
							print("释放宇宙层中景物件图！", imgFileName)
						end
					end
				end
				
				--释放近景层资源
				local nearobj = tRoomObjInfo.nearobj
				if nearobj then
					local tImg = nearobj.img
					for i = 1, #tImg, 1 do
						local imgFileName = tImg[i]
						local texture = CCTextureCache:sharedTextureCache():textureForKey(imgFileName)
						if (texture) then
							CCTextureCache:sharedTextureCache():removeTexture(texture)
							print("释放宇宙层近景物件图！", imgFileName)
						end
					end
				end
			end
		end
	end
	
	--select_end()
end

--进入战斗函数
function select_panel_begin_game()
	--print("select_panel_begin_game()")
	local SelectParam_heroList =
	{
		--{id = 6000}, --狂战士
		--{id = 6012}, --狂战士
		{id = hVar.MY_TANK_ID,},
	}
	
	--检测存档中是否有英雄
	for i = 1, #SelectParam_heroList, 1 do
		local typeId = SelectParam_heroList[i].id
		local HeroCard = hApi.GetHeroCardById(typeId)
		--print("HeroCard", HeroCard)
		if (HeroCard == nil) then
			hGlobal.event:event("LocalEvent_BuyHeroCardSucceed",typeId, 1, 1)
			LuaSaveHeroCard()
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
			--print("添加存档", typeId)
		end
	end
	
	local tHeroList = {}
	local tTacticAllList = {} --本局战斗可以带的所有战术技能卡列表
	
	--显示不超过最大等级
	local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
	
	--统计英雄自带的战术技能卡
	local oWorld = hGlobal.WORLD.LastWorldMap
	local playerGod
	local playerMe
	if oWorld then
		playerGod = oWorld:GetPlayerGod()
		playerMe = oWorld:GetPlayerMe()
	end
	for i = 1, #SelectParam_heroList, 1 do
		local heroInfo = SelectParam_heroList[i]
		
		table.insert(tHeroList, {id = heroInfo.id})
		local tactics = hApi.GetHeroTactic(heroInfo.id)
		for i = 1, #tactics, 1 do
			local tactic = tactics[i]
			if tactic then
				local tacticId = tactic.id or 0
				local tacticLv = tactic.lv or 1
				--显示不超过最大等级
				--if (tacticLv > maxLv) then
				--	tacticLv = maxLv
				--end
				if (tacticId > 0) and (tacticLv > 0) then
					tTacticAllList[#tTacticAllList + 1] = {tacticId, tacticLv, heroInfo.id} --geyachao:标识此战术卡属于哪个英雄
					--print("tacticId, tacticLv",tacticId, tacticLv)
				end
			end
		end
		
		--加入统计本局使用的英雄
		if oWorld then
			oWorld.data.statistics.hero[heroInfo.id] = true --geyachao: 本局对战中使用的英雄
		end
	end
	
	--[[
	--geyachao: 战车这里没有界面了，就不用清理cache
	--删除英雄例会资源
	--hUI.SYSAutoReleaseUI:addModel("portrait",tabU.portrait)
	--hResource.model:releaseCache(hVar.TEMP_HANDLE_TYPE.UI_GRID_AUTO_RELEASE)
	local tRelease = {}
	local tPng = hUI.SYSAutoReleaseUI.png
	for i = 1, #tPng, 1 do
		local path = tPng[i]
		tRelease[path] = 1
	end
	hResource.model:releasePng(tRelease)
	hUI.SYSAutoReleaseUI.png = {idx = {}}
	
	--释放png, plist的纹理缓存
	hApi.ReleasePngTextureCache()
	
	--回收lua内存
	collectgarbage()
	]]
	
	hApi.clearTimer("__SELECT_HERO_UPDATE__")
	hApi.clearTimer("__SELECT_TOWER_UPDATE__")
	hApi.clearTimer("__SELECT_TACTIC_UPDATE__")
	
	--local oWorld = hGlobal.WORLD.LastWorldMap
	if oWorld then
		local mapInfo = oWorld.data.tdMapInfo
		
		if mapInfo then
			--[[
			]]
			
			--zhenkira
			--无尽模式，统计塔类战术技能卡
			--所有的塔类战术技能卡都带上
			if (mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then
				local towerList = {}
				local tTactics = LuaGetPlayerSkillBook()
				if tTactics then
					for i = 1,#tTactics do
						if type(tTactics[i])=="table" then
							local id, lv, num = unpack(tTactics[i])
							
							--存在表项
							if hVar.tab_tactics[id] then
								local type = hVar.tab_tactics[id].type --战术技能卡类型
								if ((type == hVar.TACTICS_TYPE.TOWER) or (type == hVar.TACTICS_TYPE.SPECIAL)) and (lv > 0) then --此类专属于塔、特殊塔战术技能卡，放在此处，等级大于0才是完整的卡牌
									--检测是否重复
									local bFind = false --是否找到重复的
									for j = 1, #towerList, 1 do
										if (towerList[j].skillID == id) then --已存在
											--如果等级更大，用大等级的
											if (lv > towerList[j].skillLV) then
												towerList[j].skillLV = lv
												towerList[j].num = num
											end
											
											bFind = true --找到了
											break
										end
									end
									
									if (not bFind) then --不存在
										table.insert(towerList, {skillID = id, skillLV = lv, num = num})
									end
								end
							end
						end
					end
				end
				for i = 1, #towerList, 1 do
					local towerInfo = towerList[i]
					local towerId = towerInfo.skillID --无尽模式已有的塔id
					local towerLv = towerInfo.skillLV--无尽模式已有的塔等级
					
					--显示不超过最大等级
					if (towerLv > maxLv) then
						towerLv = maxLv
					end
					
					--如果有排行榜一般战术卡牌的最大等级，那么也不能超过此最大等级
					if oWorld then
						local mapInfo = oWorld.data.tdMapInfo
						if mapInfo then
							local banLimitTable = mapInfo.banLimitTable --排行榜模式禁用相关的表
							if banLimitTable and (banLimitTable.lv_tower) then
								if(banLimitTable.lv_tower > 0) then --填小于等于0，表示不受限制
									if (towerLv > banLimitTable.lv_tower) then
										towerLv = banLimitTable.lv_tower
									end
								end
							end
						end
					end
					
					--无尽模式，检测是否在排行榜禁用的塔列表里
					local ban_tower = {} --禁用塔的列表
					if oWorld then
						local mapInfo = oWorld.data.tdMapInfo
						if mapInfo then
							local banLimitTable = mapInfo.banLimitTable --排行榜模式禁用相关的表
							if banLimitTable and (banLimitTable.ban_tower) then
								ban_tower = banLimitTable.ban_tower --读配置
							end
						end
					end
					local bBannedTower = false --是否禁用该塔
					for j = 1, #ban_tower, 1 do
						if (ban_tower[j] == towerId) then
							bBannedTower = true
						end
					end
					if (not bBannedTower) then
						--table.insert(tTacticAllList, {towerId, towerLv, 0}) --所有的塔类战术技能卡都带上
						tTacticAllList[#tTacticAllList + 1] = {towerId, towerLv, 0}
					end
				end
			end
			
			--难度控制战术技能卡
			if (mapInfo.mapMode == hVar.MAP_TD_TYPE.DIFFICULT) or (mapInfo.mapMode == hVar.MAP_TD_TYPE.ENDLESS) then
				local diffTactic = mapInfo.diffTactic or {}
				for i = 1, #diffTactic, 1 do
					local add = diffTactic[i] or {}
					if add and (type(add) == "table") then
						local id = add[1] or 0
						local lv = add[2] or 1
						if (id > 0) then
							--战术技能卡对话结束后跟选择的一起出
							--table.insert(tTacticAllList, {id, lv, 0})
							tTacticAllList[#tTacticAllList + 1] = {id, lv, 0}
							
							--加入统计本局难度剧情带的战术技能卡
							oWorld.data.statistics.mapTactic[id] = true --geyachao: 本局对战中难度剧情带的战术技能卡
						end
					end
				end
			end
			
			--geyachao: 排行榜带上附加的怪物buff战术卡
			if (mapInfo.banLimitTable) and (mapInfo.banLimitTable.diff_tactic) then
				for i = 1, #mapInfo.banLimitTable.diff_tactic, 1 do
					local id = mapInfo.banLimitTable.diff_tactic[i][1] or 0
					local lv = mapInfo.banLimitTable.diff_tactic[i][2] or 1
					if (id > 0) then
						--排行榜带上附加的怪物buff战术卡
						--table.insert(tTacticAllList, {id, lv, 0})
						tTacticAllList[#tTacticAllList + 1] = {id, lv, 0}
						
						--加入统计本局难度剧情带的战术技能卡
						oWorld.data.statistics.mapTactic[id] = true --geyachao: 本局对战中难度剧情带的战术技能卡
					end
				end
			end
			
			local tStoryHeroList = {}
			local _func = function()
				
				local isFinish = LuaGetPlayerMapAchi(oWorld.data.map,hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
				if isFinish == 0 then
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
							if (id > 0) then
								if (nType == 1) then --战术技能卡
									--战术技能卡对话结束后跟选择的一起出
									table.insert(tTacticAllList, {id, lv, 0})
									print("____________________________before Event_TacticsInit add tactics:".. tostring(id))
								elseif (nType == 2) then --英雄
									--英雄对话前直接出
									--_addHeroList({{id = id, lv = lv, owner = owner}})
									
									--英雄对话结束后出
									table.insert(tStoryHeroList, {id = id, lv = lv, owner = owner, star = star,})
									print("____________________________before Event_TacticsInit add hero:".. tostring(id))
									local tactics = hApi.GetHeroTactic(id)
									for i = 1, #tactics do
										local tactic = tactics[i]
										if tactic then
											local tacticId = tactic.id or 0
											local tacticLv = tactic.lv or 1
											if tacticId > 0 and tacticLv > 0 then
												table.insert(tTacticAllList, {tacticId, tacticLv, id})
											end
										end
									end
								end
							end
						end
					end
				end
				--本局选择的英雄
				local selectedHeroList = oWorld.data.selectedHeroList
				
				--先创建选人界面选择的英雄
				--_addHeroList(tHeroList)
				local addTotalHeroList = {}
				for i = 1, #tHeroList, 1 do
					table.insert(addTotalHeroList, tHeroList[i])
				end
				
				--再添加剧情英雄
				--_addHeroList(tStoryHeroList)
				for i = 1, #tStoryHeroList, 1 do
					table.insert(addTotalHeroList, tStoryHeroList[i])
				end
				_addHeroList(addTotalHeroList)
				
				--统计: 本局所选的英雄（剧情）
				for i = 1, #tStoryHeroList, 1 do
					local typeId_Story = tStoryHeroList[i].id
					local HeroCard = hApi.GetHeroCardById(typeId_Story)
					if (HeroCard) then
						table.insert(selectedHeroList, typeId_Story) --剧情添加的英雄，如果存在战术技能卡，那么最后也加经验
					end
				end
				
				--统计: 本局所选的英雄
				for i = 1, #tHeroList, 1 do
					table.insert(selectedHeroList, tHeroList[i].id)
				end
				
				local diablodata = hGlobal.LocalPlayer.data.diablodata
				
				--[[
				--大菠萝，附加英雄的天赋点技能
				--不是配置坦克地图
				if (oWorld.data.tdMapInfo.mapMode ~= hVar.MAP_TD_TYPE.TANKCONFIG) then --配置坦克地图
					for i = 1, #addTotalHeroList, 1 do
						local id = addTotalHeroList[i].id
						--print("大菠萝，附加英雄的天赋点技能", i, id)
						local tabU = hVar.tab_unit[id] or {}
						local talent_tree = tabU.talent_tree or {} --单位天赋技能表
						for i = 1, #talent_tree, 1 do
							local ttree = talent_tree[i] or {}
							local tacticId = ttree.tacticId or 0 --战术技能id
							local attrPointMaxLv = ttree.attrPointMaxLv or 0 --天赋等级上限
							local attrPointLv = 0
							if diablodata and type(diablodata.randMap) == "table" and LuaGetHeroMapTalentSkillLv then
								attrPointLv = LuaGetHeroMapTalentSkillLv(i)
							else
								attrPointLv = LuaGetHeroTalentSkillLv(id, i) --技能当前等级
							end
							--print(tacticId, attrPointMaxLv, attrPointNum)
							
							if (tacticId > 0) then
								if (attrPointLv > 0) then --已获得
									table.insert(tTacticAllList, {tacticId, attrPointLv, 0,})
								end
							end
						end
					end
				end
				]]
				
				--[[
				--大菠萝，附加游戏内可捡取战术技能卡
				--不是配置坦克地图
				if (oWorld.data.tdMapInfo.mapMode ~= hVar.MAP_TD_TYPE.TANKCONFIG) then --配置坦克地图
					for t = 1, #hVar.tab_tacticsEx, 1 do
						local tacticId = hVar.tab_tacticsEx[t] --可捡取战术卡id
						local tacticLv = 1 --可捡取战术卡lv
						
						--读取存档的等级
						local tTactics = LuaGetPlayerSkillBook()
						if tTactics then
							for i = 1, #tTactics, 1 do
								local id, lv, num = unpack(tTactics[i])
								if (id == tacticId) then --找到了
									tacticLv = lv
									break
								end
							end
						end
						
						table.insert(tTacticAllList, {tacticId, tacticLv, 0,})
					end
				end
				]]
				
				--增加随机地图附加战术卡
				if diablodata and type(diablodata.randMap) == "table" then
					local randmapId = diablodata.randMap.randmapId or 0
					local stage = diablodata.randMap.stage or 0
					local tRandMap = hVar.tab_randmap[randmapId] or {}
					local tStageInfo = tRandMap[stage] or {}
					if tStageInfo and type(tStageInfo.extra_settings) == "table" and type(tStageInfo.extra_settings.tacticsInfo) == "table" then
						local tTacticsInfo = tStageInfo.extra_settings.tacticsInfo
						for i = 1,#tTacticsInfo do
							local tacticId = tTacticsInfo[i][1] or 0
							local tacticLv = tTacticsInfo[i][2] or 0
							if (tacticId > 0) and (tacticLv > 0) then
								table.insert(tTacticAllList, {tacticId, tacticLv, 0,})
							end
						end
					end
				end
				
				--创建战术技能卡（由选人界面发起的绘制）
				--oWorld:settactics(1, tTacticAllList)
				--大菠萝
				--table.insert(tTacticAllList, {1104, 1, tHeroList[1].id})
				oWorld:settactics(oWorld:GetPlayerMe(), tTacticAllList)
				
				--战术技能卡资源生效
				oWorld:tacticsTakeEffect(nil)
				--战术技能卡对地图已有角色生效
				oWorld:enumunit(function(u)
					oWorld:tacticsTakeEffect(u)
				end)
				
				if (oWorld.data.map == hVar.RandomMap) then
					--随机地图的障碍是自动添加时就生成好的
				else
					--可破坏物件四周加物件
					oWorld:enumunit(function(eu)
						if (eu.data.id == hVar.UNITBROKEN_STONE_ORINGIN_ID) or (eu.data.id == hVar.UNITBROKEN_STONE_CHANGETO_ID) or (eu.data.id == hVar.UNITBROKEN_STONE_GOLD_ID) then
							eu:_addBlockArount()
						end
					end)
					
					--刷新动态障碍
					oWorld:enumunit(function(eu)
						eu:_addblock()
					end)
				end
				
				hGlobal.event:event("Event_TacticsInit")
				
				hGlobal.event:event("Event_UpdateTankNum")
				
				hGlobal.event:event("Event_InitRescuedPerson",oWorld)
				
				--触发引导
				hGlobal.event:event("LocalEvent_EnterGuideProgress", oWorld.data.map, oWorld, "world", 2)
				
				--触发游戏开始
				hGlobal.event:call("LocalEvent_TDGameBegin", oWorld.data.map, oWorld)
				
				--是否有铁人雕像道具卡
				--print("banLimitTable.ironman=", banLimitTable and banLimitTable.ironman)
				local banLimitTable = mapInfo.banLimitTable --排行榜模式禁用相关的表
				if banLimitTable and (banLimitTable.ironman) then
					local itemId = banLimitTable.ironman.itemId
					local itemLv = banLimitTable.ironman.itemLv
					local itemNum = banLimitTable.ironman.itemNum
					if (itemId > 0) and (itemLv > 0) then
						hGlobal.event:event("Event_AddTacticsActiveSkill", oWorld:GetPlayerMe(), itemId, itemLv, itemNum, hVar.MY_TANK_ID)
					end
				end
				
				--大菠萝，带入上一局的临时数据
				if diablodata then
					--带入上一局的道具技能
					local activeskill = diablodata.activeskill --坦克的上一局主动技能
					if (type(activeskill) == "table") then
						for i = 1, #activeskill, 1 do
							local itemId = activeskill[i].id
							local itemLv = activeskill[i].lv
							local itemNum = activeskill[i].num
							--print("大菠萝，带入上一局的道具技能", itemId, itemLv, itemNum)
							hGlobal.event:event("Event_AddTacticsActiveSkill", oWorld:GetPlayerMe(), itemId, itemLv, itemNum, hVar.MY_TANK_ID)
						end
					end
					
					--带入上一局的雕像buff
					local tInfo = GameManager.GetGameInfo("auraInfo")
					if tInfo then
						local oUnit = oWorld:GetPlayerMe().heros[1]:getunit() --玩家的第一个英雄
						local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
						local gridX, gridY = oWorld:xy2grid(targetX, targetY)
						
						for nIndex, auraInfo in pairs(tInfo) do
							--local tData = {_nIndex, {id = aura_id, lv = lv,}}
							local aura_id = auraInfo.id
							local lv = auraInfo.lv
							print("auraInfo:", "nIndex=", nIndex, "aura_id=", aura_id, "lv=", lv)
							local tabAura = hVar.tab_aura[aura_id]
							if tabAura then
								local skillAttrbuteType = tabAura.skillAttrbuteType
								local skill_id = tabAura.skill
								
								--只添加被动类技能
								if (skillAttrbuteType == hVar.AI_ATTRIBUTE_TYPE.POSITIVE) then
									local tCastParam =
									{
										level = lv, --等级
									}
									hApi.CastSkill(oUnit, skill_id, 0, 100, oUnit, gridX, gridY, tCastParam) --战车雕像技能
									--print("CastSkill:", skill_id)
								end
							end
						end
					end
				end
				
				--为大菠萝游戏，直接发兵
				if (hVar.IS_DIABOLO_APP == 1) then
					--开始发兵
					--hGlobal.event:event("LocalEvent_TD_NextWave", true)
					
					--测试模式，或者第一关未通关，有开场动画，并且当前是第一关第一次玩
					--local chapterId = 1
					--local tabCh = hVar.tab_chapter[chapterId]
					--local firstmap = tabCh.firstmap --第一关
					local firstmap = hVar.GuideMap --第0关
					local isFinishFirstMap = LuaGetPlayerMapAchi(oWorld.data.map, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --是否通关第一关
					local battleCount = LuaGetPlayerMapAchi(oWorld.data.map,hVar.ACHIEVEMENT_TYPE.BATTLECOUNT) or 0 --挑战的次数
					--print("oWorld.data.map=", oWorld.data.map, "battleCount=", battleCount)
					if ((hVar.OPTIONS.TEST_MODE == 1) or (isFinishFirstMap == 0)) and (oWorld.data.map == firstmap) and (battleCount == 0) then
						--开场动画
						local oUnit = oWorld:GetPlayerMe().heros[1]:getunit() --玩家的第一个英雄
						
						--释放技能
						local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
						local gridX, gridY = oWorld:xy2grid(targetX, targetY)
						local skillId = 16004 --开场动画技能
						local skillLv = 1
						local tCastParam = {level = skillLv,}
						hApi.CastSkill(oUnit, skillId, 0, nil, nil, gridX, gridY, tCastParam)
					else
						if (oWorld.data.map == firstmap) then
							if (g_lua_src == 1) then
								--镜头自动跟随
								hApi.TD__Camera_Follow(oWorld)
								--oWorld:addtimer("__TD__Camera_Follow_", 1, function(deltaTime)
									--if (oWorld.data.keypadEnabled == true) or (oWorld.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.TANKCONFIG) then --允许响应事件
										--local oHero = oWorld:GetPlayerMe().heros[1]
										--if oHero then
											--local oUnit = oHero:getunit()
											--if oUnit then
												--local px, py = hApi.chaGetPos(oUnit.handle)
												----聚焦
												--hApi.setViewNodeFocus(px, py)
											--end
										--end
									--end
								--end)
								
								--开始发兵
								hGlobal.event:event("LocalEvent_TD_NextWave", true)
							else
								--误入此地图
								hApi.addTimerOnce("__GuideEnterTankConfigWorld_Timer", 1000, function()
									--进入坦克配置界面
									local mapname = hVar.MainBase
									local MapDifficulty = 0
									local MapMode = hVar.MAP_TD_TYPE.TANKCONFIG --配置坦克模式
									xlScene_LoadMap(g_world, mapname,MapDifficulty,MapMode)
								end)
							end
						else
							--镜头自动跟随
							hApi.TD__Camera_Follow(oWorld)
							--oWorld:addtimer("__TD__Camera_Follow_", 1, function(deltaTime)
								--if (oWorld.data.keypadEnabled == true) or (oWorld.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.TANKCONFIG) then --允许响应事件
									--local oHero = oWorld:GetPlayerMe().heros[1]
									--if oHero then
										--local oUnit = oHero:getunit()
										--if oUnit then
											--local px, py = hApi.chaGetPos(oUnit.handle)
											----聚焦
											--hApi.setViewNodeFocus(px, py)
										--end
									--end
								--end
							--end)
							
							--开始发兵
							hGlobal.event:event("LocalEvent_TD_NextWave", true)
						end
					end
					
					--大菠萝，四周一圈加障碍
					--gx gy 是地图格子坐标
					--xlScene_SetMapBlock(gx, gy, 0/1)
					local oWorld = hGlobal.WORLD.LastWorldMap
					if oWorld then
						local mapInfo = oWorld.data.tdMapInfo
						if mapInfo then
							--print("四周一圈加障碍四周一圈加障碍四周一圈加障碍四周一圈加障碍四周一圈加障碍四周一圈加障碍四周一圈加障碍")
							--local tParam = hVar.DEVICE_PARAM[g_phone_mode] or {}
							
							local world_scale = 1.0
							local W, H = oWorld.data.sizeW,oWorld.data.sizeH
							local viewRange = mapInfo.viewRange or {}
							local viewOffset = mapInfo.viewOffset or {}
							local viewOffsetPhone = mapInfo.viewOffsetPhone
							local right = (viewRange[1] or 0)
							local left = (viewRange[2] or 0)
							local up = (viewRange[3] or 0)
							local down = (viewRange[4] or 0)
							
							local x1 = left
							local x2 = W - right
							local y1 = down
							local y2 = H - up
							
							local X_COUNT = math.ceil((x2 - x1) / 24)
							local Y_COUNT = math.ceil((y2 - 21) / 24)
							--[[
							--x方向
							for gx = 1, X_COUNT, 1 do
								xlScene_SetMapBlock(x1/24+gx, 6, 1) --最上横线
								xlScene_SetMapBlock(x1/24+gx, Y_COUNT + 1, 1) --最下横线
							end
							
							--y方向
							for gy = 1, Y_COUNT, 1 do
								xlScene_SetMapBlock(4, y1/24+gy, 1) --最左竖线
								xlScene_SetMapBlock(X_COUNT, y1/24+gy, 1) --最右竖线
							end
							]]
							--可到达边界
							oWorld.data.rangeL = 3*24
							oWorld.data.rangeR = X_COUNT*24 + 2*24
							oWorld.data.rangeU = 4*24
							oWorld.data.rangeD = (Y_COUNT + 0)*24
							
							if (g_phone_mode ~= 0) then --手机模式
								oWorld.data.rangeL = 3*24
								oWorld.data.rangeR = X_COUNT*24 + 2*24
								oWorld.data.rangeU = 4*24
								oWorld.data.rangeD = (Y_COUNT + 0)*24
							end
						end
					end
				end
			end
			
			--创建对话
			--local vTalk = hApi.InitUnitTalk(mapInfo.godUnit,mapInfo.godUnit,nil,"mapBegin")
			local vTalk = hApi.InitUnitTalk(oWorld:GetPlayerGod():getgod(), oWorld:GetPlayerGod():getgod(), nil, "mapBegin")
			
			local isFinish = LuaGetPlayerMapAchi(oWorld.data.map,hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
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
			
			--记录挑战次数
			local battleCount = LuaGetPlayerMapAchi(oWorld.data.map,hVar.ACHIEVEMENT_TYPE.BATTLECOUNT) or 0
			LuaSetPlayerMapAchi(oWorld.data.map,hVar.ACHIEVEMENT_TYPE.BATTLECOUNT,battleCount+1)
		end
	end
end

--监听进入地图事件
hGlobal.event:listen("localEvent_Phone_ShowSelectedHeroFrm", "__SelectConfigFrm", function(cardList, heroNum, unselecthero, legion)
	--print(debug.traceback())
	--进入战斗
	select_panel_begin_game()
end)
