--window下调试用， 键盘按键定义
VK_TAB           =0x09


VK_CLEAR         =0x0C
VK_RETURN        =0x0D

VK_SHIFT         =0x10
VK_CONTROL       =0x11
VK_MENU          =0x12
VK_PAUSE         =0x13
VK_CAPITAL       =0x14


VK_ESCAPE        =0x1B

VK_CONVERT       =0x1C
VK_NONCONVERT    =0x1D
VK_ACCEPT        =0x1E
VK_MODECHANGE    =0x1F

VK_SPACE         =0x20
VK_PRIOR         =0x21
VK_NEXT          =0x22
VK_END           =0x23
VK_HOME          =0x24
VK_LEFT          =0x25
VK_UP            =0x26
VK_RIGHT         =0x27
VK_DOWN          =0x28
VK_SELECT        =0x29
VK_PRINT         =0x2A
VK_EXECUTE       =0x2B
VK_SNAPSHOT      =0x2C
VK_INSERT        =0x2D
VK_DELETE        =0x2E
VK_HELP          =0x2F


 -- VK_0 - VK_9 are the same as ASCII '0' - '9' (0x30 -=0x39)
 --=0x40 : unassigned
 -- VK_A - VK_Z are the same as ASCII 'A' - 'Z' (0x41 -=0x5A)
 --

VK_LWIN          =0x5B
VK_RWIN          =0x5C
VK_APPS          =0x5D



 VK_SLEEP         =0x5F

 VK_NUMPAD0       =0x60
 VK_NUMPAD1       =0x61
 VK_NUMPAD2       =0x62
 VK_NUMPAD3       =0x63
 VK_NUMPAD4       =0x64
 VK_NUMPAD5       =0x65
 VK_NUMPAD6       =0x66
 VK_NUMPAD7       =0x67
 VK_NUMPAD8       =0x68
 VK_NUMPAD9       =0x69
 VK_MULTIPLY      =0x6A
 VK_ADD           =0x6B
 VK_SEPARATOR     =0x6C
 VK_SUBTRACT      =0x6D
 VK_DECIMAL       =0x6E
 VK_DIVIDE        =0x6F
 VK_F1            =0x70
 VK_F2            =0x71
 VK_F3            =0x72
 VK_F4            =0x73
 VK_F5            =0x74
 VK_F6            =0x75
 VK_F7            =0x76
 VK_F8            =0x77
 VK_F9            =0x78
 VK_F10           =0x79
 VK_F11           =0x7A
 VK_F12           =0x7B
 VK_F13           =0x7C
 VK_F14           =0x7D
 VK_F15           =0x7E
 VK_F16           =0x7F
 VK_F17           =0x80
 VK_F18           =0x81
 VK_F19           =0x82
 VK_F20           =0x83
 VK_F21           =0x84
 VK_F22           =0x85
 VK_F23           =0x86
 VK_F24           =0x87

   VK_0         =0x30   
   VK_1         =0x31   
   VK_2         =0x32   
   VK_3         =0x33   
   VK_4         =0x34   
   VK_5         =0x35   
   VK_6         =0x36   
   VK_7         =0x37   
   VK_8         =0x38   
   VK_9         =0x39  
  
--定义数据字符A~Z  
   VK_A = 0x41   
   VK_B = 0x42   
   VK_C  =0x43   
   VK_D  =0x44   
   VK_E  =0x45   
   VK_F  =0x46   
   VK_G  =0x47   
   VK_H  =0x48   
   VK_I  =0x49   
   VK_J  =0x4A   
   VK_K  =0x4B   
   VK_L  =0x4C   
   VK_M  =0x4D   
   VK_N  =0x4E   
   VK_O  =0x4F   
   VK_P  =0x50   
   VK_Q  =0x51   
   VK_R  =0x52   
   VK_S  =0x53   
   VK_T  =0x54   
   VK_U  =0x55   
   VK_V  =0x56   
   VK_W  =0x57   
   VK_X  =0x58   
   VK_Y  =0x59   
   VK_Z  =0x5A   


hApi.ExchangeResource = function(offerType,value,toType)
	local v1 = math.max(hVar.RESOURCE_VALUE[offerType] or 1,1)
	local v2 = math.max(hVar.RESOURCE_VALUE[toType] or 1,1)
	return hApi.floor(value*v1/v2)
end

hApi.GetMapByType = function(wType)
	local map = hGlobal.mapData[#hGlobal.mapData] or {}	--加载的地图数据
	for k,v in pairs(hGlobal.mapData)do
		--print("----------------------------------")
		--print("地图加载！",k)
		if v.type==wType then
			map = v
		end
		--for k,v in pairs(v)do
			--print(k,v)
		--end
		--print("----------------------------------")
	end
	return map
end

--如果在战场上创建了单位，则使用英雄的数据初始化基本强度
hApi.LoadUnitBounceBF = function(oWorld,oUnit)
	local tLeader = oWorld.data.HeroLeader[oUnit.data.owner]
	if type(tLeader)=="table" then
		oUnit.attr.lea = tLeader.attr.lea
		oUnit.attr.led = tLeader.attr.led
	end
end

------------------------------------------
--单位获得额外属性加成
local __CODE__LoadArmyBounce = function(oUnit,tArmyBounce)
	if type(tArmyBounce)=="table" then
		local tAttrB = tArmyBounce[oUnit.data.indexOfTeam]
		if type(tAttrB)=="table" then
			for k,v in pairs(tAttrB)do
				if type(v)~="number" then
					--不是数字你搞毛
				elseif k=="atk" then
					--增加攻击力
					oUnit.attr.attack[4] = oUnit.attr.attack[4] + v
					oUnit.attr.attack[5] = oUnit.attr.attack[5] + v
				elseif k=="hp" then
					--增加血量
					oUnit.attr.hp = oUnit.attr.hp + v
					oUnit.attr.mxhp = oUnit.attr.mxhp + v
					oUnit.attr.__mxhp = oUnit.attr.__mxhp + v
				elseif type(oUnit.attr[k])=="number" then
					--增加其他看得到的属性
					oUnit.attr[k] = oUnit.attr[k] + v
				end
			end
		end
	end
end

hApi.GetBFLeader = function(oUnit)
	local oWorld = oUnit:getworld()
	if oWorld and type(oWorld.data.HeroLeader)=="table" then
		local tList = oWorld.data.HeroLeader[oUnit.data.owner]
		return hApi.GetObjectEx(hClass.unit,tList.unitWM),tList.hero
	end
end

hApi.GetBFDeployPos = function(nTeamId,sStyle)
	if sStyle and hVar.BATTLEFIELD_DEPLOY_POS[sStyle] then
		return hVar.BATTLEFIELD_DEPLOY_POS[sStyle][nTeamId]
	else
		return hVar.BATTLEFIELD_DEPLOY_POS[0][nTeamId]
	end
end

local __TowerPos = {0,0,0,0}
local __tokenT = {}
hApi.CreateArmyOnBattlefield = function(w,u,teamId,nDeployMode,tArmyEx,tSiegeEx)
	local tTactics
	local tArmyBounce
	local ownerId = u.data.owner
	if type(w.data.tactics)=="table" then
		tTactics = w.data.tactics[ownerId]
	end
	if type(w.data.armybounce)=="table" then
		tArmyBounce = w.data.armybounce[ownerId]
	end
	if ownerId==0 then
		ownerId = -1	--中立敌人将被调整成中立敌对
		--转移战术技能
		if type(w.data.tactics)=="table" then
			w.data.tactics[ownerId] = w.data.tactics[0]
			w.data.tactics[0] = nil
		end
	end
	local oLeader
	local oHero
	local oGuard
	local team
	local oTown = u:gettown()
	local nTowerLevel = 0
	local nTowerMax = 0
	local Towndef = 0
	for i=1,4 do
		__TowerPos[i] = 0
	end
	if oTown then
		oGuard = oTown:getunit("guard")
		nTowerLevel,nTowerMax = oTown:gettech("towerlevel")
		Towndef = oTown:gettech("deflevel")
		if nTowerLevel==1 then
			__TowerPos[1] = 1
		elseif nTowerLevel==2 then
			__TowerPos[1] = 1
			__TowerPos[4] = 1
		elseif nTowerLevel==3 then
			__TowerPos[1] = 1
			__TowerPos[2] = 1
			__TowerPos[4] = 1
		elseif nTowerLevel==4 then
			__TowerPos[1] = 1
			__TowerPos[2] = 1
			__TowerPos[3] = 1
			__TowerPos[4] = 1
		end
	end
	if oGuard~=nil then
		oLeader = oGuard
		oHero = oGuard:gethero()
		team = oGuard.data.team
	else
		oLeader = u
		oHero = u:gethero()
		team = u.data.team
	end
	if teamId==1 then
		w.data.attackPlayerId = ownerId
	end
	--设置领队英雄信息，战场中的任何单位将受到此属性的加成
	w.data.HeroLeader[ownerId] = {hero={},unitWM=hApi.SetObjectEx({},oLeader),attr={lea=0,led=0}}
	local tLeaderData = w.data.HeroLeader[ownerId]
	if oHero then
		local tAttr = tLeaderData.attr
		local tHero = tLeaderData.hero
		local LeaderMode = 1
		if w.data.typeEX==hVar.BF_WORLD_TYPE_EX.PVP then
			--PVP战场中英雄的统帅和防御取平均值
			LeaderMode = 2
		elseif ownerId==hGlobal.LocalPlayer.data.playerId then
			--本地玩家部队的统帅和防御取平均值
			LeaderMode = 2
		else
			LeaderMode = 1
		end
		if LeaderMode==1 then
			--取主帅属性
			tAttr.lea = tAttr.lea + oHero.attr.lea
			tAttr.led = tAttr.led + oHero.attr.led
			tHero[#tHero+1] = hApi.SetObjectEx({},oHero)
			oHero:enumteam(function(oHeroC)
				tHero[#tHero+1] = hApi.SetObjectEx({},oHeroC)
			end)
		elseif LeaderMode==2 then
			--取平均属性
			tAttr.lea = tAttr.lea + oHero.attr.lea
			tAttr.led = tAttr.led + oHero.attr.led
			tHero[#tHero+1] = hApi.SetObjectEx({},oHero)
			oHero:enumteam(function(oHeroC)
				tAttr.lea = tAttr.lea + oHeroC.attr.lea
				tAttr.led = tAttr.led + oHeroC.attr.led
				tHero[#tHero+1] = hApi.SetObjectEx({},oHeroC)
			end)
			for k,v in pairs(tAttr)do
				tAttr[k] = math.floor(tAttr[k]/#tHero)
			end
		end
		if nDeployMode==nil then
			nDeployMode = oHero.data.deploymode
		end
	end
	w:setlordU(ownerId,u)
	local logTeam = {}
	local logTactics = {}
	if type(team)=="table" then
		local teamI = 1
		local oUnitH,oUnitC
		local tDeployPos = hApi.GetBFDeployPos(teamId,nDeployMode)
		for i = 1,#tDeployPos do
			local id,stack
			if team~=0 and team[teamI]~=nil and team[teamI]~=0 then
				id,stack = team[teamI][1],team[teamI][2]
			end
			teamI = teamI + 1
			if id~=nil and hVar.tab_unit[id]~=nil then
				local tabU = hVar.tab_unit[id]
				local x,y,facing = tDeployPos[i][1],tDeployPos[i][2],tDeployPos[i][3]
				--战场中使用scaleB这个参数，不填就是0.1
				local scale = math.floor((tabU.scaleB or 1)*100)
				local bossID = 0
				--如果填死该单位会出现在战场上的位置
				if type(tabU.grid)=="table" then
					x,y = tabU.grid[1],tabU.grid[2]
				end
				--拥有部件的生物
				if type(tabU.part)=="table" then
					bossID = -1
				end
				local controlId = ownerId
				local oHeroX
				if oHero~=nil then
					if id==oHero.data.id then
						oHeroX = oHero
					elseif oHero~=nil and tabU.type==hVar.UNIT_TYPE.HERO then
						oHeroX = oHero:getteammemberbyid(id)
					end
					if oHeroX then
						local nType = hGlobal.LocalPlayer:allience(oHeroX:getowner())
						--拥有者或者友军的情况下
						if nType==hVar.PLAYER_ALLIENCE_TYPE.OWNER or nType==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
							--检测是否允许该单位被本地玩家控制
							--注意快速战场上是不能有其他控制者的，否则因为AI行动失败会弹框(现在已经移动到快速战场生成的流程里面处理了)
							if oHeroX:getGameVar("_ALLY")>0 then
								controlId = hGlobal.LocalPlayer.data.playerId
							end
						end
					end
				end
				local oUnit = w:addunit(id,ownerId,x,y,facing,nil,nil,{stack = stack},{control = controlId,bossID = bossID,GridSelectMode = "startpos",indexOfTeam = i,scale = scale})
				if oUnit then
					if oUnitC==nil then
						oUnitC = oUnit
					end
					if oHeroX~=nil then
						--如果是英雄的话
						oHeroX:bindBF(oUnit)
						oUnit.attr.lea = oHeroX.attr.lea
						oUnit.attr.led = oHeroX.attr.led
					elseif tabU.type==hVar.UNIT_TYPE.UNIT then
						--如果是普通单位
						__CODE__LoadArmyBounce(oUnit,tArmyBounce)
					end
					hGlobal.event:call("Event_UnitBorn",oUnit)
					--创建boss part单位
					if type(tabU.part)=="table" then
						local tPartUnit = tabU.part
						for i = 1,#tPartUnit do
							local id,num,gx,gy = unpack(tPartUnit[i])
							local tabU = hVar.tab_unit[id]
							if tabU then
								local scale = math.floor((tabU.scaleB or 1)*100)
								local attrR = {stack = num,passive = 1}
								local dataR = {scale = scale,bossID = oUnit.ID,partID = i}
								local c = w:addunit(id,oUnit.data.owner,gx,gy,facing,nil,nil,attrR,dataR)
								if c then
									hGlobal.event:call("Event_UnitBorn",c)
								end
							end
						end
					end
				end
			end
		end
		--如果拥有任何英雄单位,添加战术技能
		if tTactics then
			local u = oUnitH or oUnitC
			if u then
				for i = 1,#tTactics do
					local v = tTactics[i]
					if type(v)=="table" and hVar.tab_tactics[v[1]] then
						local tabT = hVar.tab_tactics[v[1]]
						local id = tabT.skillId
						local lv = math.min(tabT.level or 1,v[2])
						if id and id~=0 then
							local tabS = hVar.tab_skill[id]
							if tabS and not(tabS.heroonly==1 and u~=oUnitH) then
								u:addskill(id,lv)
							end
						end
					end
				end
			end
			hApi.ReadParamWithDepth(tTactics,nil,logTactics,2)
		end
		hApi.ReadParamWithDepth(team,nil,logTeam,2)
	end
	local nCombatScore,nCombatScoreBasic = oLeader:calculate("CombatScore","All")
	w:log({
		key = "EnterBattle",
		unit = {
			name = u.handle.name,
			id = u.data.id,
			objectID = u.ID,
			owner = u.data.owner,
			leader_name = oLeader.handle.name,
			leader_id = oLeader.data.id,
			leader_ObjectID = oLeader.ID,
		},
		team = logTeam,
		teamId = teamId,
		tactics = logTactics,
		CombatScore = nCombatScore,
		CombatScoreBasic = nCombatScoreBasic,
	})
	--创建战场额外单位
	if type(tArmyEx)=="table" then
		for i = 1,#tArmyEx do
			--{nTeam,id,num,gridX,gridY}
			local nTeam,id,num,gridX,gridY,facing = unpack(tArmyEx[i])
			if teamId==nTeam then
				local tabU = hVar.tab_unit[id]
				if tabU then
					local scale = math.floor((tabU.scaleB or 1)*100)
					local attrR = {stack = num}
					local dataR = {scale = scale}
					local c = w:addunit(id,ownerId,gridX,gridY,facing,nil,nil,attrR,dataR)
					if c then
						hGlobal.event:call("Event_UnitBorn",c)
					end
				end
			end
		end
	end
	--创建城墙
	if type(tSiegeEx)=="table" then
		local towerCount = 0
		--if nTowerLevel>0 then
			--towerCount = math.min(nTowerLevel,4)
		--end
		local tLevel = nTowerLevel
		local oPlayer = u:getowner()
		local ReplaceStyle = hVar.SIEGE_STYLE[w.data.background]
		if ReplaceStyle~=nil then
			ReplaceStyle = tostring(ReplaceStyle)
		end
		for i = 1,#tSiegeEx do
			--{team,id,gridX,gridY,facing}
			local nTeam,id,gridX,gridY,facing = unpack(tSiegeEx[i])
			if nTeam==teamId then
				local tabU = hVar.tab_unit[id]
				if tabU then
					--判断是否需要替换模型
					local dataR
					if ReplaceStyle~=nil and tabU.modelReplaceable~=nil and type(tabU.modelReplaceable)=="string" then
						local model = string.gsub(tabU.modelReplaceable,"@STYLE@",ReplaceStyle)
						if hVar.tab_model.index[model] then
							dataR = {model = model}
						end
					end
					local c = w:addunit(id,ownerId,gridX,gridY,facing,nil,nil,nil,dataR)
					if c then
						local pX,pY = 0,0
						if tabU.position and w.map.position and w.map.position[tabU.position] then
							pX,pY = unpack(w.map.position[tabU.position])
						end
						local cX,cY = c:getXY()
						if c.handle._c~=nil then
							c.handle.s:setPosition(pX-cX,cY-pY)
						end
						local type_ex = type(tabU.type_ex)=="table" and tabU.type_ex[1] or nil
						if type_ex=="TOWER" then
							towerCount = towerCount + 1
							if __TowerPos[towerCount]==1 then
								c:setanimation("TOWER_stand")
								c:addskill(13,1)
								c.attr.attack[4] = c.attr.attack[4] + 20--(nTowerLevel-1)*10
								c.attr.attack[5] = c.attr.attack[5] + 20--(nTowerLevel-1)*10
							end
						elseif type_ex =="WALL" or type_ex =="GATE" then
							c.attr.hp = c.attr.hp + 50 * Towndef
							c.attr.mxhp = c.attr.hp
						end
						hGlobal.event:call("Event_UnitBorn",c)
					end
				end
			end
		end
	end
	return ownerId
end

hApi.CreateEnvironmentOnBattlefied = function(oWorld,tArmyEx,nIndex)
	if tArmyEx==nil then
		if nIndex==nil and hGlobal.WORLD.LastWorldMap~=nil then
			local tMapData = hGlobal.WORLD.LastWorldMap:getmapdata(1)
			if tMapData and tMapData.BFEnvironment==1 then
				nIndex = 1
			end
		end
		if type(nIndex)~="number" then
			--未指定
		elseif nIndex==1 then
			--允许
			local tEnv = hVar.BATTLEFIELD_ENVIRONMENT[oWorld.data.background]
			if tEnv and #tEnv>0 then
				tArmyEx = hVar.tab_bfenv[tEnv[hApi.random(1,#tEnv)]]
			end
		elseif nIndex>0 then
			--指定的地形物件
			tArmyEx = hVar.tab_bfenv[nIndex]
		end
	end
	if type(tArmyEx)=="table" then
		for i = 1,#tArmyEx do
			local nTeam,id,num,gridX,gridY,facing = unpack(tArmyEx[i])
			if nTeam==0 then
				--创建中立的物件
				local tabU = hVar.tab_unit[id]
				if tabU then
					local scale = math.floor((tabU.scaleB or 1)*100)
					local attrR = {stack = num,passive = 1}
					local dataR = {scale = scale}
					local oUnit = oWorld:addunit(id,0,gridX,gridY,facing,nil,nil,attrR,dataR)
					if oUnit then
						hGlobal.event:call("Event_UnitBorn",oUnit)
					end
				end
			end
		end
	end
end

hApi.GetTacticsByPlayerId = function(nPlayerId)
	local tTactics = {}
	if hGlobal.player[nPlayerId] then
		if hGlobal.player[nPlayerId]==hGlobal.LocalPlayer then
			--本地玩家每次都读取存档里面的战术技能
			local t = LuaGetActiveBattlefieldSkill()
			if type(t)=="table" then
				for i = 1,#t do
					if t[i]~=0 then
						tTactics[#tTactics+1] = {t[i][1],t[i][2]}
					end
				end
			end
		end
		--if 1 then
			--读取地图存档里面的战术技能
			local t = hGlobal.player[nPlayerId].data.tactics
			if type(t)=="table" then
				for i = 1,#t do
					if t[i]~=0 then
						tTactics[#tTactics+1] = {t[i][1],t[i][2]}
					end
				end
			end
		--end
	end
	return tTactics
end

hApi.BFGetLordUnit = function(oUnit)
	local oTown = oUnit:gettown()
	if oTown~=nil then
		local oGuardUnit = oTown:getunit("guard")
		if oGuardUnit then
			return oGuardUnit
		end
	end
	return oUnit
end

hApi.IsUnitLocalAlly = function(oUnit)
	if oUnit.data.owner==hGlobal.LocalPlayer.data.playerId then
		return hVar.RESULT_SUCESS
	end
	local oHero = oUnit:gethero()
	if oHero then
		if oHero:getGameVar("_ALLY")>0 then
			return hVar.RESULT_SUCESS
		else
			local sus = 0
			oHero:enumteam(function(oHeroC)
				if oHeroC:getGameVar("_ALLY")>0 then
					sus = 1
				end
			end)
			if sus==1 then
				return hVar.RESULT_SUCESS
			end
		end
	end
	return hVar.RESULT_FAIL
end

local __TokenParam = {}
hApi.CreateBattlefield = function(u,t,tDataEx,tParam,codeOnCreate,bf_bg_id)
	local tArmySide = {1,2}		--攻击者站在哪里
	local tDeployMode = {}
	local background = nil
	local bgm = nil
	local tabU = hVar.tab_unit[u.data.id]
	if tabU and type(tabU.part)=="table" then
		--Boss!始终使用攻击者的设置
		tArmySide = {2,1}
		local tgrData = u:gettriggerdata()
		if tgrData~=nil then
			background = tgrData.battlefield
			bgm = tgrData.bgm
		end
	else
		--一般单位进攻
		local tgrData = t:gettriggerdata()
		if tgrData~=nil then
			background = tgrData.battlefield
			bgm = tgrData.bgm
		end
	end
	if background==nil and hVar.tab_unit[t.data.id] then
		background = hVar.tab_unit[t.data.id].battlefield
	end
	if type(tParam)~="table" then
		tParam = __TokenParam
	end
	local oTargetX = t
	local tArmyEx
	local tArmyBounce
	local tTactics
	local IsQuickBattlefield = 0
	local oTown = t:gettown()
	if oTown~=nil then
		local oGuard = oTown:getunit("guard")
		if oGuard then
			oTargetX = oGuard
		end
	end
	--存在自定义战斗参数
	if type(tDataEx)=="table" then
		tArmyBounce = tDataEx.armybounce
		tTactics = tDataEx.tactics
	else
		--读取默认的战斗卡片
		tTactics = {}
		tTactics[u.data.owner] = hApi.GetTacticsByPlayerId(u.data.owner)
		tTactics[t.data.owner] = hApi.GetTacticsByPlayerId(t.data.owner)
		local tUnitBF = {}
		tUnitBF[1] = hApi.BFGetLordUnit(u)
		tUnitBF[2] = hApi.BFGetLordUnit(t)
		for i = 1,#tUnitBF do
			local oUnitBF = tUnitBF[i]
			local tgrData = oUnitBF:gettriggerdata()
			if tgrData then
				if i==2 and type(tgrData.BFUnit)=="table" then
					tArmyEx = tgrData.BFUnit
				end
				if type(tgrData.tactics)=="table" and tTactics[oUnitBF.data.owner] then
					local tMyTactics = tTactics[oUnitBF.data.owner]
					for i = 1,#tgrData.tactics do
						local v = tgrData.tactics[i]
						if type(v)=="table" then
							tMyTactics[#tMyTactics+1] = {v[1],v[2]}
						end
					end
				end
				if type(tgrData.deploymode)=="number" then
					tDeployMode[i] = tgrData.deploymode
				end
			end
			local oHero = oUnitBF:gethero()
			--如果是水战的话，替换成水战地形
			if background==nil and oHero~=nil and oHero:getGameVar("_MOUNT")>0 then
				background = "battlefield/battlefield_water_c"
			end
		end
	end
	if type(tTactics)~="table" then
		tTactics = {}
	end
	if oTown~=nil then
		--攻城战
		--默认攻城背景音乐
		if bgm==nil then
			bgm = "fight_town"
		end
		--默认平原城造型
		if background==nil then
			background = "battlefield/battlefield_plain_t"
		end
	else
		--如果指定了战斗背景
		if (bf_bg_id or 0)~=0 then
			background = hVar.BATTLEFIELD_BG[bf_bg_id] --hApi.GetRandomBattlefieldBG()
		end
	end
	local oWorldBF = hClass.world:new(hApi.ReadParam(tParam,nil,{
		map = "BATTLEFIELD",
		background = background,
		type = "battlefield",
		movespeed = hVar.BATTLEFIELD_MOVE_SPEED,
		speed = hVar.BATTLEFIELD_ACTION_SPEED,
		bgm = bgm,
		tactics = tTactics,
		armybounce = tArmyBounce,
	}))
	--初始化bfData
	oWorldBF.data.bfdata = {
		EnableQuest = 0,		--当前战场是否可以完成任务
		LocalTeamId = 0,		--显示为绿色的队伍
	}
	--判断显示血条颜色(谁是战场主控队伍？)
	local nAllyU = hGlobal.LocalPlayer:allience(hGlobal.player[u.data.owner])
	local nAllyT = hGlobal.LocalPlayer:allience(hGlobal.player[oTargetX.data.owner])
	if nAllyU==hVar.PLAYER_ALLIENCE_TYPE.OWNER or nAllyT==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
		oWorldBF.data.bfdata.LocalTeamId = hGlobal.LocalPlayer.data.playerId
	elseif nAllyU==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
		if hApi.IsUnitLocalAlly(u)==hVar.RESULT_SUCESS then
			oWorldBF.data.bfdata.LocalTeamId = hGlobal.LocalPlayer.data.playerId
		else
			oWorldBF.data.bfdata.LocalTeamId = u.data.owner
		end
	elseif nAllyT==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
		if hApi.IsUnitLocalAlly(oTargetX)==hVar.RESULT_SUCESS then
			oWorldBF.data.bfdata.LocalTeamId = hGlobal.LocalPlayer.data.playerId
		else
			oWorldBF.data.bfdata.LocalTeamId = oTargetX.data.owner
		end
	else
		oWorldBF.data.bfdata.LocalTeamId = u.data.owner
	end
	--创建额外函数
	if type(codeOnCreate)=="function" then
		codeOnCreate(oWorldBF)
	end
	if oWorldBF.map==nil then
		--啥子情况?未知地图？
		return oWorldBF
	elseif oTown~=nil then
		--攻城战,默认就是平原城造型
		hApi.CreateArmyOnBattlefield(oWorldBF,u,tArmySide[1],tDeployMode[1],tArmyEx,hVar.SIEGE_GATE_UNIT)
		hApi.CreateArmyOnBattlefield(oWorldBF,t,tArmySide[2],tDeployMode[2],tArmyEx,hVar.SIEGE_GATE_UNIT)
		--如果是攻城战，那么必须有城墙，并且队伍2为守城方
		--战场必须被劈成两半
		--此时将守城方获得50%的伤害减免,每摧毁一面城墙减免效果降低15%
		local cover = oWorldBF.data.cover
		local oGuardPlayer = t:getowner()
		local wallNum = 0
		oWorldBF:enumunit(function(oUnit)
			if oUnit.data.type==hVar.UNIT_TYPE.BUILDING and oUnit.attr.hp>0 then
				oWorldBF.data.cover[oUnit.ID] = oUnit.__ID
				wallNum = wallNum + 1
			end
		end)
		if wallNum>0 then
			local rpec = hApi.getint(50/wallNum)
			local pec = 100-rpec*wallNum
			local v = hApi.GetBFDeployPos(2,0)[1]
			local g = {}
			if oWorldBF:_gridfunc().gridinreach(oWorldBF,g,v[1],v[2],9999,255)>0 then
				oWorldBF:addcover(g,pec,rpec)
			end
		end
		if oWorldBF.data.IsQuickBattlefield~=1 then
			hGlobal.event:event("Event_BattlefieldCreated",oWorldBF)
		end
		oWorldBF:log({
			key = "Town",
			Town = {
				ID = oTown.ID,
			},
		})
		return oWorldBF
	else
		--非攻城战
		hApi.CreateArmyOnBattlefield(oWorldBF,u,tArmySide[1],tDeployMode[1],tArmyEx)
		hApi.CreateArmyOnBattlefield(oWorldBF,t,tArmySide[2],tDeployMode[2],tArmyEx)
		--非攻城战产生随机障碍
		if not(type(tArmyEx)=="table" and #tArmyEx>0) then
			local tgrData = t:gettriggerdata()
			if tgrData and tgrData.BFEnvironment~=nil then
				hApi.CreateEnvironmentOnBattlefied(oWorldBF,nil,tgrData.BFEnvironment)
			else
				hApi.CreateEnvironmentOnBattlefied(oWorldBF,nil,nil)
			end
		end
		if oWorldBF.data.IsQuickBattlefield~=1 then
			hGlobal.event:event("Event_BattlefieldCreated",oWorldBF)
		end
		return oWorldBF
	end
end

hApi.BFGetUnitControlType = function(oUnit)
	local oWorld = oUnit:getworld()
	--if oWorld and oWorld.data.type=="battlefield" and hGlobal.player[oUnit.data.control] then --zhenkira remove battlefiled condition
	if oWorld and hGlobal.player[oUnit.data.control] then
		local nAlly = hGlobal.LocalPlayer:allience(hGlobal.player[oUnit.data.control])
		if nAlly==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
			--我控制的
			return 1
		elseif nAlly==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
			if oUnit.data.control==oWorld.data.bfdata.LocalTeamId then
				--是主控方
				return 1
			else
				--友军
				return 2
			end
		else
			--敌人
			return 0
		end
	end
	return 0
end

hApi.EnterBattlefield = function(oWorld,oUnit,oTarget)
	if oWorld.ID~=0 then
		hGlobal.LocalPlayer:focusworld(oWorld)
		hGlobal.event:event("LocalEvent_PlayerEnterBattlefield",oWorld,oUnit,oTarget)
		CloseWorldMapUI()
		oWorld:log({	--进入战场
			key = "AtkTarget",
			unit = {
				name=oUnit.handle.name,
				id=oUnit.data.id,
				objectID = oUnit.ID,
				owner = oUnit.data.owner,
			},
			target = {
				name=oTarget.handle.name,
				id=oTarget.data.id,
				objectID = oTarget.ID,
				owner = oTarget.data.owner,
			},
		})
	else
		_DEBUG_MSG("战场已经被删掉了。。。")
	end
end

--内存表，记录最后杀死的x个怪物，防止不停刷一只怪获得积分(10个应该够用了)
local __LastKillNPC = {0,0,0,0,0,0,0,0,0,0}
local __GetCheatKillCount = function(oWorld,oUnit,nSecend)
	--防止刷积分（内存表）
	local tTemp = __LastKillNPC
	local nCheatKillCount = 0
	local tick = xlGetTickCount()
	local mapName = oWorld.data.map
	local mapUnique = tostring(oWorld).."_"..oWorld.__ID
	local unitUnique = oUnit.data.indexOfCreate
	local tRecord = {tick,unitUnique,mapName,mapUnique}
	for i = 1,#tTemp,1 do
		if tTemp[i]~=0 then
			local _tick,_unitUnique,_mapName,_mapUnique = unpack(tTemp[i])
			if tick-_tick<=nSecend*1000 and _unitUnique==unitUnique and _mapName==mapName and _mapUnique~=mapUnique then
				nCheatKillCount = nCheatKillCount + 1
			end
		end
	end
	for i = 1,#tTemp-1 do
		tTemp[i] = tTemp[i+1]
	end
	tTemp[#tTemp] = tRecord
	return nCheatKillCount
end
--获取目标单位被击杀的次数(反刷分)
local __GetUnitScoreByKill = function(oWorld,oUnit,nScore)
	--获取最近300秒内对该单位的击杀计数
	local nCheatKillCount = __GetCheatKillCount(oWorld,oUnit,300)
	--尝试添加积分获取记录
	local r = LuaAddLootRecordFromUnit(g_curPlayerName,oUnit,"scoreI")
	if r==1 then
		--作弊来回刷积分，禁止！
		if nCheatKillCount==1 then
			nScore = hApi.floor(nScore/2)	--刷1次减半
		elseif nCheatKillCount>=2 then
			nScore = 1			--速刷两次以上就变1分了！
		end
	elseif r==0 then
		--如果已经获取过一次积分，第二次获得的积分会减半
		nScore = hApi.floor(nScore/2)
		r = LuaAddLootRecordFromUnit(g_curPlayerName,oUnit,"scoreII")
		if nCheatKillCount>=2 then
			nScore = 1			--速刷两次以上就变1分了！
		end
	end
	if r==1 then
		--如果添加积分成功，给积分
		return nScore
	else
		--认为玩家刷太多了，给1分
		return 1
	end
end

--离开战场时扣除双方部队中的单位数量
--扣除英雄的魔法值
--统计击杀数量
local __GetHeroLog = function(t,ID)
	if t[ID]==nil then
		local oHero = hClass.hero:find(ID)
		if oHero then
			t[ID] = {mp=0,hp=0,base_hp=oHero.attr.hp}
		else
			t[ID] = {mp=0,hp=0,base_hp=0}
		end
	end
	return t[ID]
end
hApi.CalculateBattle = function(oWorld,oUnitV,oUnitD)
	local tDeadHeroID = {}
	local HeroLog = {}
	local UnitLost = {}
	local UnitSave = {}
	local oUnitVx = hApi.GetBattleUnit(oUnitV)		--获得真正的战斗(胜利)单位
	local oUnitDx = hApi.GetBattleUnit(oUnitD)		--获得真正的战斗(失败)单位
	local oHeroVx = oUnitVx:gethero()
	local oHeroDx = oUnitDx:gethero()
	local nHpDx = 0
	if oHeroDx then
		nHpDx = oHeroDx.attr.hp				--敌人死前的血量
	end
	local IsHeroDeadV = 0
	local IsHeroDeadD = 0
	local nCombatScoreV = 0
	local nCombatScoreD = 0
	for i = 1,oWorld.__LOG.i do
		local v = oWorld.__LOG[i]
		if v.key=="EnterBattle" then
			if v.unit.objectID==oUnitVx.ID then
				nCombatScoreV = v.CombatScore
			elseif v.unit.objectID==oUnitDx.ID then
				nCombatScoreD = v.CombatScore
			end
		elseif v.key=="hero_damaged" then
			local nID = v.target.hero_objectID
			local tLog = __GetHeroLog(HeroLog,nID)
			if tDeadHeroID[nID]~=1 then
				tLog.hp = tLog.hp - v.dhp
				if tLog.hp+tLog.base_hp<=0 then
					--挂了
					tDeadHeroID[nID] = 1
				end
			end
		elseif v.key=="hero_mxhp" then
			local nID = v.target.hero_objectID
			local tLog = __GetHeroLog(HeroLog,nID)
			if tDeadHeroID[nID]~=1 then
				tLog.hp = tLog.hp + v.mxhp
			end
		elseif v.key=="hero_healed" then
			local nID = v.target.hero_objectID
			local tLog = __GetHeroLog(HeroLog,nID)
			if tDeadHeroID[nID]~=1 then
				tLog.hp = tLog.hp - v.dhp
			end
		elseif v.key=="hero_mana" then
			local nID = v.unit.hero_objectID
			local tLog = __GetHeroLog(HeroLog,nID)
			if tDeadHeroID[nID]~=1 then
				tLog.mp = tLog.mp - v.manacost
			end
		elseif v.key=="unit_damaged" then
			if v.target.indexOfTeam~=0 and v.lost>0 then
				local i = v.target.indexOfTeam
				local o = v.target.owner
				UnitLost[o] = UnitLost[o] or {}
				UnitLost[o][i] = (UnitLost[o][i] or 0) + v.lost
			end
		elseif v.key=="unit_healed" then
			if v.target.indexOfTeam~=0 and v.revive>0 then
				local i = v.target.indexOfTeam
				local o = v.target.owner
				UnitLost[o] = UnitLost[o] or {}
				UnitLost[o][i] = (UnitLost[o][i] or 0) - v.revive
			end
		elseif v.key=="unit_save" then
			if v.target.indexOfTeam~=0 and v.save>0 then
				local i = v.target.indexOfTeam
				local o = v.target.owner
				UnitSave[o] = UnitSave[o] or {}
				UnitSave[o][i] = math.max(UnitSave[o][i] or 0,v.save)
			end
		end
	end
	for nID,tLog in pairs(HeroLog)do
		local oHero = hClass.hero:find(nID)
		if oHero then
			if tDeadHeroID[nID]==1 then
				--嗝屁了，血扣掉，蓝扣光
				oHero:setHp(1)
				oHero:setMp(0)
				local oUnitH = oHero:getunit()
				if oUnitH==oUnitVx then
					IsHeroDeadV = 1
				elseif oUnitH==oUnitDx then
					IsHeroDeadD = 1
				end
			else
				oHero:setHp(nil,tLog.hp,1)
				oHero:setMp(nil,tLog.mp)
			end
		end
	end
	--副将战败检测
	if hGlobal.WORLD.LastWorldMap then
		local tMapData = hGlobal.WORLD.LastWorldMap:getmapdata(1)
		if tMapData and tMapData.ExHeroDefeatMode==1 then
			if oHeroVx then
				oHeroVx:teamdefeat(oHeroDx,tDeadHeroID)
			end
			if oHeroDx then
				oHeroDx:teamdefeat(oHeroVx,tDeadHeroID)
			end
		end
	end
	--如果不是快速战场，则需要计算积分
	if oWorld.data.IsQuickBattleField~=1 then
		--记录最后的战报
		hGlobal.LastBattleLog = oWorld.__LOG
		_DEBUG_MSG("--------------------------------------")
		_DEBUG_MSG("BFLog,round = ",oWorld.data.roundcount)
		local oWorldWM = oUnitVx:getworld()
		--非AI的胜利者才会计算星星
		local nStar = 0		--0星
		local nScore = 0	--0积分
		local nRewardLv = 0	--0积分等级(根据星星和战斗时间计算)
		local nRewardLvMax = 4	--最高积分等级
		--我方击杀，或友军击杀的情况下计算星星和积分(只有本地玩家参与的战场才会看到此界面，所以不会有啥问题啦)
		if oUnitVx:getowner()==hGlobal.LocalPlayer or hGlobal.LocalPlayer:allience(oUnitVx:getowner())==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
			--本地玩家是胜利者
			--统计玩家积分
			--请自行阅读下面代码以了解积分规则
			local cUnitLost = UnitLost[oUnitVx.data.owner]
			local cUnitSave = UnitSave[oUnitVx.data.owner]
			local eUnitLost = UnitLost[oUnitDx.data.owner]
			--判断我方英雄是否阵亡
			if IsHeroDeadV==1 then
				--
			end
			--统计我方所有阵亡生物战斗力
			local nScoreOfLostArmy = 0
			local nLostPec = 0
			local nBaseScoreOfEnemy = 0
			if oHeroDx then
				oHeroDx.attr.hp = nHpDx
				nBaseScoreOfEnemy = oUnitDx:calculate("CombatScore","Basic")
				oHeroDx.attr.hp = 0
			else
				nBaseScoreOfEnemy = oUnitDx:calculate("CombatScore","Basic")
			end
			if nBaseScoreOfEnemy<=0 then
				nBaseScoreOfEnemy = 1
			end
			if cUnitLost~=nil then
				local TokenUnitLost = {data={team={},id=-1}}
				local team = oUnitVx.data.team
				local teamX = TokenUnitLost.data.team
				for i = 1,hVar.TEAM_UNIT_MAX do
					if type(team[i])=="table" then
						local id = team[i][1]
						local nLost = (cUnitLost[i] or 0) - (cUnitSave and cUnitSave[i] or 0)
						if nLost>0 then
							teamX[#teamX+1] = {id,nLost}
						end
					end
				end
				nScoreOfLostArmy = hClass.unit.calculate(TokenUnitLost,"CombatScore","Basic")
				if nScoreOfLostArmy>0 then
					nLostPec = hApi.getint(100*nScoreOfLostArmy/nBaseScoreOfEnemy)
				end
			end
			--判断损失,并给予积分加成
			if IsHeroDeadV==0 then
				--英雄没有死的话，走2~6星的判断流程
				if nScoreOfLostArmy==0 then
					--无损任何单位:5~6星评价
					if oWorld.data.roundcount<=7 then
						--7回合内结束战斗,6星,积分+4
						nRewardLv = 4
						nStar = 6
					elseif oWorld.data.roundcount<=14 then
						--14回合内结束战斗,6星,积分+3
						nRewardLv = 3
						nStar = 6
					else
						--14回合内以上结束战斗,5星,积分+2
						nRewardLv = 2
						nStar = 5
					end
				elseif nLostPec<=20 then
					--损失的部队小于敌方单位战斗的20%:4~5星评价
					if oWorld.data.roundcount<=7 then
						--7回合内结束战斗,5星，积分+3
						nRewardLv = 3
						nStar = 5
					elseif oWorld.data.roundcount<=14 then
						--14回合内结束战斗,4星，积分+2
						nRewardLv = 2
						nStar = 4
					else
						--14回合以上结束战斗,4星，积分+1
						nRewardLv = 1
						nStar = 4
					end
				else
					if oWorld.data.roundcount<=7 then
						--7回合内结束战斗
						nStar = 4
					elseif oWorld.data.roundcount<=14 then
						--14回合内结束战斗
						nStar = 3
					else
						nStar = 2
					end
				end
			else
				--英雄死了的话，走1~5星的判断流程
				if nScoreOfLostArmy==0 then
					--未损失任何单位,5星,积分+2
					nRewardLv = 2
					nStar = 5
				elseif nLostPec<=20 then
					--总损失小于敌方战斗力的20%,4星,积分+1
					nRewardLv = 1
					nStar = 4
				elseif oWorld.data.roundcount<=7 then
					--7回合内结束战斗,3星
					nStar = 3
				elseif oWorld.data.roundcount<=14 then
					--14回合内结束战斗,2星
					nStar = 2
				else
					--14回合以上结束战斗,1星
					nStar = 1
				end
			end
			--local pLog = oWorldWM:getplayerlog(oUnitVx.data.owner)
			local pLog = oWorldWM:getplayerlog(hGlobal.LocalPlayer.data.playerId)	--其实只有本地玩家可以看到这个界面的说
			if pLog~=nil then
				--获得积分流程
				if pLog.star[nStar] then
					pLog.star[nStar] = pLog.star[nStar] + 1
				end
				local mapname = oWorldWM.data.map
				local tMapScore = hVar.MAP_SCORE[mapname]
				if oWorldWM.data.playmode==hVar.PLAY_MODE.KUMA_GAME then
					--KUMA模式没有积分
					nScore = 0
				elseif type(g_curPlayerName)=="string" and tMapScore~=nil then
					local nScorePec = oUnitDx.data.mapScorePec
					local tScoreDetail = tMapScore[8]-- or {6,400,2400,5,77}
					local oHeroOpp = oUnitDx:gethero()
					if oHeroOpp and nScorePec==0 then
						nScorePec = 100
					end
					if nScorePec>0 and tScoreDetail then
						--计算积分
						nScorePec = math.floor(nScorePec*tMapScore[1]/100)	--获得积分的百分比
						local bossLv = 1
						local bossLvMax = math.max(1,tScoreDetail[1])
						local nCombatMin = tScoreDetail[2]
						local nCombatMax = tScoreDetail[3]
						local nScoreMin = tScoreDetail[4]
						local nScoreMax = tScoreDetail[5]
						local nScoreBase = nScoreMax - nScoreMin
						if nBaseScoreOfEnemy>=nCombatMin then
							bossLv = math.ceil((math.min(nBaseScoreOfEnemy,nCombatMax) - nCombatMin)/math.ceil((nCombatMax-nCombatMin)/bossLvMax))
						elseif oHeroOpp==nil then
							--非英雄的话，并且战斗力不足，会按照比例给予积分
							nScorePec = math.floor(nScorePec*nBaseScoreOfEnemy/nCombatMin)
						end
						if nScorePec>0 then
							--nRewardLv = 1~4   5~100	--根据星星计算出收益
							nScore = nScoreMin + 0.1*nScoreBase*nRewardLv/nRewardLvMax + 0.3*nScoreBase*bossLv*(5+nRewardLv)/(bossLvMax*(5+nRewardLvMax))
							if oHeroOpp~=nil then
								nScore = nScore + 0.6*nScoreBase*bossLv/bossLvMax
							else
								nScore = nScore + 0.4*nScoreBase*bossLv/bossLvMax
							end
							nScore = __GetUnitScoreByKill(oWorldWM,oUnitDx,math.floor(nScore*nScorePec/100))
							if nScore>0 then
								local pec = hVar.MAP_SCORE_BY_DIFFICULTY[oWorldWM.data.MapDifficulty]
								if pec and pec~=100 then
									nScore = math.max(1,hApi.floor(nScore*pec/100))
								end

								--如果获胜单位为本周的将星 则积分翻倍
								for i = 1,#g_HeroWeekStar  do
									if oUnitVx.data.id == g_HeroWeekStar[i][1] then
										nScore = math.ceil(nScore*g_HeroWeekStar[i][2])
									end
								end
								
								--暂时把积分记录进世界中
								if hGlobal.WORLD.LastWorldMap.data.explock == 0 then
									LuaAddPlayerScore(nScore)
									local map_get_score = LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.Map_GetScore) or 0
									map_get_score = map_get_score + nScore

									if nScore > 1 then
										LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.Map_GetScore,map_get_score)
									end
									
									--统计获得积分杀了几个怪
									local Map_ScoreRound = 0 
									Map_ScoreRound = (LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.Map_ScoreRound) or 0)

									if nScore > 1 then
										LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.Map_ScoreRound,Map_ScoreRound+1)
									end
								else
									--锁定模式不产生积分
									--积分产生后 记录当前玩家在游戏中的积分，方便回到3天前时 重置玩家积分 避免刷 掉落积分的 BOSS
									hGlobal.WORLD.LastWorldMap.data.dayscore = (hGlobal.WORLD.LastWorldMap.data.dayscore or 0) + nScore
								end
								
							end
						end
					end
				end
			end
		end
		oWorld:log({		--战斗结束log
			key = "battle_result",
			playerV = oUnitVx.data.owner,
			star = nStar,
			score = nScore,
		})
	end
	--扣兵
	for owner,lost in pairs(UnitLost) do
		local u = oWorld:getlordU(owner)
		if u then
			local save
			local ux = hApi.GetBattleUnit(u)
			--胜利者才能启用save机制
			if ux==oUnitVx then
				save = UnitSave[owner]
			end
			for i,num in pairs(lost)do
				if save and type(save[i])=="number" and save[i]>0 then
					num = math.max(0,num-save[i])
				end
				if num>0 then
					ux:teamremoveunit(i,num)
				end
			end
		end
	end
end

--战场结果的一些特殊处理，用来记录试炼地图相关的成就
hApi.SpecialBattleResultEvent = function(oUnitV,oUnitD,sResult)
	if hGlobal.WORLD.LastWorldMap==nil then
		return
	end
	local map_name = hGlobal.WORLD.LastWorldMap.data.map
	if sResult=="Victory" then
		--龙城飞将的特殊事件 记录击破波数
		if map_name == "world/level_lcfj" then
			local templist = {11017,11019,11020,11021,11022,11023,11024} --龙城飞将的敌人们...
			for i = 1,#templist do
				if oUnitD.data.id == templist[i] then
					hGlobal.WORLD.LastWorldMap.data.specialVal = i
					break
				end
			end
		end

		if map_name == "world/level_hjzl" then
			--如果在黄巾之乱中击杀过张曼诚
			if oUnitD.data.id == 6034 then
				if LuaGetPlayerMapAchi(map_name,hVar.ACHIEVEMENT_TYPE.KILLSMOEBOSS) == 0 then
					LuaSetPlayerMapAchi(map_name,hVar.ACHIEVEMENT_TYPE.KILLSMOEBOSS,1)
					LuaSavePlayerList()
				end
			end
		end
		
		--秘境试练的特殊事件 记录击破数
		if map_name == "world/level_xlslc" then
			local templist = {6015,5016,6004,6100,6025,6031,6071,6024,11030,6039,6023,5003,5028,6190,5006,5000,5023,6191} --m秘境试炼的敌人们...
			for i = 1,#templist do
				if oUnitD.data.id == templist[i] then
					hGlobal.WORLD.LastWorldMap.data.specialVal = i
					break
				end
			end
		end
			
		--如果死亡单位是英雄，则计入到击杀英雄 count 中
		if oUnitD.data.type == hVar.UNIT_TYPE.HERO then

		end
	end
end

local __GetHeroByBFUnit = function(oUnit)
	if oUnit~=nil then
		local oTown = oUnit:gettown()
		if oTown then
			local oGuard = oTown:getunit("guard")
			if oGuard~=nil then
				return oGuard:gethero()
			end
		end
		return oUnit:gethero()
	end
end

function hApi.CalculateBattleUnit(oWorld,oUnitV,oUnitD,sResult)
	if type(oWorld.data.netdata)=="table" then
		return
	end
	if hGlobal.WORLD.LastWorldMap==nil then
		return
	end
	if sResult=="Victory" then
		local tLoot = {
			[1] = {"attr","exp",0,0},
		}
		local oHero = __GetHeroByBFUnit(oUnitV)
		if oHero~=nil then
			local nExpGet = 0
			local enemyU = hApi.GetEnemyInBattlefield(oWorld,oUnitV:getowner())
			if enemyU~=nil then
				nExpGet = hApi.CalculateBattleExp(oWorld,oHero) or 0
				hApi.ReadUnitLoot(enemyU,tLoot)
			end
			--获得经验
			local tgrDataP = hGlobal.WORLD.LastWorldMap:getmapdata(1)
			if tgrDataP and type(tgrDataP.ExpPec)=="number" then
				nExpGet = math.floor(nExpGet*tgrDataP.ExpPec/100)
			end
			tLoot[1][3] = nExpGet
			tLoot[1][4] = oHero.attr.level
			--升级经验
			if hGlobal.WORLD.LastWorldMap.data.explock == 0 then
				local tUnit = {}
				tUnit[#tUnit+1] = oHero:getunit()
				oHero:enumteam(function(oHeroC)
					tUnit[#tUnit+1] = oHeroC:getunit()
				end)
				for i = 1,#tUnit do
					local oUnit = tUnit[i]
					local tgrData = oUnit:gettriggerdata()
					if tgrData and (tgrData.ExpLock or 0)>0 and oUnit.attr.level>=tgrData.ExpLock then
						--已经到达获取exp的上限
					else
						--可以获得exp
						hApi.UnitGetLoot(oUnit,"attr","exp",nExpGet)
					end
				end
			end
		end
		
		hApi.SpecialBattleResultEvent(oUnitV,oUnitD,sResult)
		if hGlobal.LocalPlayer:getfocusworld()==oWorld then
			return hGlobal.event:event("LocalEvent_BattlefieldResult",oWorld,oUnitV,oUnitD,tLoot)
		end
		--if oUnitV:getowner()==hGlobal.LocalPlayer or (oUnitD~=nil and oUnitD:getowner()==hGlobal.LocalPlayer) then
			--return hGlobal.event:event("LocalEvent_BattlefieldResult",oWorld,oUnitV,oUnitD,tLoot)
		--end
	elseif sResult=="Defeat" then
		local oDefeatHero = __GetHeroByBFUnit(oUnitV)
		local oTown = oUnitD:gettown()
		if oTown then
			--攻城战中如果战胜了，则城镇属方发生转换,兵种清空
			local oBuilding = oUnitD
			hGlobal.event:call("Event_UnitDefeated",oWorld,oBuilding,oDefeatHero)
			for i = 1,hVar.TEAM_UNIT_MAX do
				oBuilding:teamremoveunit(i,-9999)
			end
			local oGuard = oTown:getunit("guard")
			if oGuard~=nil then
				oGuard.data.IsBusy = 0
				oTown:setguard(nil)
				oUnitD = oGuard
			else
				oUnitD = nil
			end
			if oUnitV~=nil then
				hGlobal.event:call("Event_HeroOccupy",oWorld,oUnitV,oBuilding)
			end
		end
		if oUnitD~=nil then
			oUnitD:beforedead(oUnitV)
			local oHeroD = oUnitD:gethero()
			if oHeroD~=nil then
				oHeroD:teamdefeat(oDefeatHero)
				hGlobal.event:call("Event_HeroDefeated",oHeroD,oDefeatHero)
			end
			hGlobal.event:call("Event_UnitDefeated",oWorld,oUnitD,oDefeatHero)
			oUnitD:dead()	--被击败
			--如果是AI在走，并且快速战场击败敌人，直接移除该单位的碰撞（不然Ai这时候动不了）
			if oWorld.data.IsQuickBattlefield==1 and heroGameRule.isAiTurn() then
				if oUnitD.handle._c~=nil then
					xlChaSetBlockRadious(oUnitD.handle._c,0)
				end
			end
		end
	end
end

function hApi.InitTalkAfterBattle(oUnitV,oUnitD,tBattleLog)
	local vTalk
	--战斗结束，判断胜利触发器（对话）
	if oUnitV and oUnitD then
		local u = hApi.GetBattleUnit(oUnitV)
		local t = hApi.GetBattleUnit(oUnitD)
		if t.data.talkTag~=-1 then
			local tTalk = t:gettalk()
			if tTalk then
				local NormalDefeatCount = 0
				local PlayerDefeatCount = 0
				local NormalDefeatTag = "defeat"
				local PlayerDefeatTag = "p"..t.data.owner.."defeat"
				for i = 1,#tTalk do
					local tTag = tTalk[i][1]
					if tTag==NormalDefeatTag then
						NormalDefeatCount = NormalDefeatCount + 1
					elseif tTag==PlayerDefeatTag then
						PlayerDefeatCount = PlayerDefeatCount + 1
					end
				end
				if PlayerDefeatCount>0 then
					vTalk = hApi.InitUnitTalk(oUnitV,oUnitD,tTalk,PlayerDefeatTag,tBattleLog)
				elseif NormalDefeatCount>0 then
					vTalk = hApi.InitUnitTalk(oUnitV,oUnitD,tTalk,NormalDefeatTag,tBattleLog)
				end
			end
		end
	end
	return vTalk
end

hApi.EnterWorld = function()
	local oWorld = hGlobal.LocalPlayer:getfocusworld()
	if oWorld==nil then
		return
	end
	if oWorld.data.type=="battlefield" then
		if oWorld.data.codeOnExit~=0 then
			--已经执行过退出函数
			oWorld:exit("exit")
		else
			hGlobal.event:event("LocalEvent_PlayerLeaveBattlefield",hGlobal.LocalPlayer)
			if type(oWorld.data.netdata)=="table" then
				--网络战场
				hGlobal.event:event("LocalEvent_PlayerLeaveNetBattlefield")
			else
				--普通战场
				local oWorld = hGlobal.BattleField
				if oWorld then
					oWorld:del()
					hGlobal.BattleField = nil
				end
				--进战场以后世界地图停掉了，禁止发布任何其他命令
				if hGlobal.WORLD.LastWorldMap~=nil then
					hGlobal.WORLD.LastWorldMap:pause(0)
				end
				hApi.LuaReleaseBattlefield()
				hResource.model:releaseCache(hVar.TEMP_HANDLE_TYPE.OBJECT_BF)	--脚本清理战场显存
				if hGlobal.WORLD.LastWorldMap~=nil then
					hGlobal.LocalPlayer:focusworld(hGlobal.WORLD.LastWorldMap)
				end
			end
		end
	elseif oWorld.data.type=="town" then
		if hGlobal.WORLD.LastTown then
			hGlobal.WORLD.LastTown:del()
			hGlobal.WORLD.LastTown = nil
		end
		hResource.model:releaseCache(hVar.TEMP_HANDLE_TYPE.OBJECT_TN)	--脚本清理城镇显存
		if hGlobal.WORLD.LastWorldMap~=nil then
			hGlobal.LocalPlayer:focusworld(hGlobal.WORLD.LastWorldMap)
		end
	end
end

function hApi.GetBattleUnit(oUnit)
	local oTown = oUnit:gettown()
	if oTown then
		local oGuard = oTown:getunit("guard")
		if oGuard then
			return oGuard
		end
	end
	return oUnit
end

--local nGrowth = nil					--每周成长率(填0的话也会有些许成长,填空不成长)
--hApi.CreateArmyByGroup(oWorld,oUnit,oUnitToAddTeam,{
	--{"name",10001,10002,10003,10004,2},		--{名字,id,id,id,...,随机选择单位个数}
	--{"name",5000,5001,5002,1},
--},10000,nGrowth))					--10000战斗力

local __TempGroup = {n=0}
--local __SelectTeamFromGroup = function(oWorld,tGroup)
--	if oWorld.data.RandomGroupTag~=0 then
--		__TempGroup.n = 0
--		for i = 1,#tGroup do
--			if tGroup[i][1]==oWorld.data.RandomGroupTag then
--				__TempGroup.n = __TempGroup.n + 1
--				__TempGroup[__TempGroup.n] = tGroup[i]
--			end
--		end
--		if __TempGroup.n==1 then
--			return __TempGroup[1]
--		elseif __TempGroup.n>1 then
--			return __TempGroup[oWorld:random(1,__TempGroup.n)]
--		end
--	end
--	return tGroup[oWorld:random(1,#tGroup)]
--end

----创造随机建筑
--hApi.CreateBuildingByGroup = function(oWorld,oUnit,tGroup)
--	local sGroup
--	if oUnit.data.type==hVar.UNIT_TYPE.GROUP then
--		local tabU = oUnit:gettab()
--		if tabU and type(tabU.group)=="table" then
--			tGroup = tabU.group
--		end
--	end
--	if type(tGroup)=="table" and #tGroup>0 then
--		sGroup = __SelectTeamFromGroup(oWorld,tGroup)
--	end
--	if type(sGroup)=="table" and #sGroup>2 then
--		--只能随机1个单位
--		local rNum
--		if sGroup[#sGroup]<=13 then
--			rNum = #sGroup-1
--		else
--			rNum = #sGroup
--		end
--		if rNum>=2 then
--			local id = sGroup[oWorld:random(2,rNum)]
--			local tabU = hVar.tab_unit[id]
--			if tabU.type==hVar.UNIT_TYPE.BUILDING then
--				local triggerID = oUnit.data.triggerID
--				local tgrIndex = oWorld.data.triggerIndex
--				local tgrDataU
--				if triggerID~=0 and tgrIndex~=nil then
--					local v = tgrIndex[triggerID]
--					if v and v[1]==oUnit.ID and v[2]==oUnit.__ID then
--						--v[1] = 0
--						--v[2] = 0
--						tgrDataU = v
--					else
--						triggerID = 0
--					end
--				end
--				local owner = oUnit.data.owner
--				local facing = oUnit.data.facing
--				local worldX = oUnit.data.worldX
--				local worldY = oUnit.data.worldY
--				local editorID = oUnit.data.editorID
--				local oUnitB
--				if g_editor==1 then
--					--编辑器模式下只是设置标签
--					oUnit.data.nTarget = -1
--					--创造个不带编辑器ID的货给他
--					oUnitB = oWorld:addunit(id,owner,nil,nil,facing,worldX,worldY)
--				else
--					--非编辑器模式下把自己删掉
--					oUnit:del()
--					--创建新单位
--					oUnitB = oWorld:addunit(id,owner,nil,nil,facing,worldX,worldY,nil,{triggerID = triggerID,editorID = editorID})
--				end
--				if oUnitB~=nil then
--					oWorld:loadhire(oUnitB)
--					hGlobal.event:call("Event_UnitBorn",oUnitB)
--					return oUnitB
--				end
--			end
--		end
--	end
--end

--hApi.CreateHeroByGroup = function(oWorld,oUnit,tGroup)
--	local sGroup
--	if oUnit.data.type==hVar.UNIT_TYPE.GROUP then
--		local tabU = oUnit:gettab()
--		if tabU and type(tabU.group)=="table" then
--			tGroup = tabU.group
--		end
--	end
--	if type(tGroup)=="table" and #tGroup>0 then
--		sGroup = __SelectTeamFromGroup(oWorld,tGroup)
--	end
--	if type(sGroup)=="table" and #sGroup>2 then
--		--只能随机1个单位,并且同一个玩家不会随机出相同的英雄
--		local tIsHaveHero = {}
--		local p = oUnit:getowner()
--		if p and rawget(p,"heros") then
--			for i = 1,#p.heros do
--				if type(p.heros[i])=="table" then
--					tIsHaveHero[p.heros[i].data.id] = 1
--				end
--			end
--		end
--		local sTemp = {}
--		for i = 2,#sGroup do
--			local id = sGroup[i]
--			if i==#sGroup and id<=13 then
--				--忽略这个数字
--			elseif tIsHaveHero[id]~=1 then
--				sTemp[#sTemp+1] = id
--			end
--		end
--		if #sTemp<=0 then
--			--如果没刷出来，那么以后都不会刷英雄了
--			oUnit.data.nTarget = -1
--		else
--			local id = sTemp[oWorld:random(1,#sTemp)]
--			local tabU = hVar.tab_unit[id]
--			if tabU.type==hVar.UNIT_TYPE.HERO then
--				local triggerID = oUnit.data.triggerID
--				local tgrIndex = oWorld.data.triggerIndex
--				local tgrDataU
--				if triggerID~=0 and tgrIndex~=nil then
--					local v = tgrIndex[triggerID]
--					if v and v[1]==oUnit.ID and v[2]==oUnit.__ID then
--						tgrDataU = v[3]
--					else
--						triggerID = 0
--					end
--				end
--				local owner = oUnit.data.owner
--				local facing = oUnit.data.facing
--				local worldX = oUnit.data.worldX
--				local worldY = oUnit.data.worldY
--				local editorID = oUnit.data.editorID
--				local oUnitH
--				if g_editor==1 then
--					--编辑器模式下只是设置标签
--					oUnit.data.nTarget = -1
--					--创造个不带编辑器ID的货给他
--					oUnitH = oWorld:addunit(id,owner,nil,nil,facing,worldX,worldY)
--				else
--					--非编辑器模式下把自己删掉
--					oUnit:del()
--					--创建新单位
--					oUnitH = oWorld:addunit(id,owner,nil,nil,facing,worldX,worldY,nil,{triggerID = triggerID,editorID = editorID})
--				end
--				if oUnitH then
--					local oHero = hClass.hero:new({
--						name = hVar.tab_stringU[id][1],
--						id = id,
--						owner = owner,
--						unit = oUnitH,
--						playmode = oWorld.data.playmode,
--					})
--					if tgrDataU then
--						oHero:loadtriggerdata(tgrDataU)
--					end
--					hGlobal.event:call("Event_UnitBorn",oUnitH)
--					return oUnitH
--				end
--			end
--		end
--	end
--end

--hApi.CreateArmyByGroup = function(oWorld,oUnitGroup,oUnitToAddTeam,tGroup,nCombatScore,GrowthEveryDay,nScorePec)
--	if nCombatScore~=nil then
--		if type(nCombatScore)=="table" and type(nCombatScore[1])=="number" then
--			local s = nCombatScore
--			if type(s[2])=="number" and s[2]>s[1] then
--				nCombatScore = oWorld:random(s[1],s[2])
--			else
--				nCombatScore = s[1]
--			end
--		elseif type(nCombatScore)~="number" then
--			nCombatScore = nil
--		end
--	end
--	if oUnitGroup~=nil and oUnitGroup.data.type==hVar.UNIT_TYPE.GROUP then
--		local tabU = oUnitGroup:gettab()
--		if tabU then
--			if tGroup==nil and type(tabU.group)=="table" then
--				tGroup = tabU.group
--			end
--			--不存在合法的随机组
--			if tGroup==nil then
--				return
--			end
--			--从触发器数据中读取战斗力
--			if nCombatScore==nil then
--				local tgrDataU = oUnitGroup:gettriggerdata()
--				if tgrDataU and tgrDataU.score and type(tgrDataU.score)=="table" and type(tgrDataU.score[1])=="number" then
--					if type(tgrDataU.score[2])=="number" and tgrDataU.score[2]>tgrDataU.score[1] then
--						nCombatScore = oWorld:random(tgrDataU.score[1],tgrDataU.score[2])
--					else
--						nCombatScore = tgrDataU.score[1]
--					end
--				end
--			end
--			--如果没取到战斗力，那么从表格中读取
--			if nCombatScore==nil then
--				if type(tabU.score)=="table" and type(tabU.score[1])=="number" then
--					nCombatScore = oWorld:random(tabU.score[1],tabU.score[2] or tabU.score[1])
--				end
--			end
--			if nCombatScore~=nil then
--				local RandomPec
--				if oUnitGroup.data.owner==0 then
--					RandomPec = hApi.GetMapValueByDifficulty(oWorld,"RandomCreep")
--				else
--					local IsAI = hApi.IsUnitManagedByAI(oUnitGroup)
--					if IsAI==1 then
--						--任何电脑控制的单位（敌人）
--						RandomPec = hApi.GetMapValueByDifficulty(oWorld,"EnemyBorn")
--					elseif IsAI==-1 then
--						--任何电脑控制的单位（友军）
--						RandomPec = hApi.GetMapValueByDifficulty(oWorld,"AllyBorn")
--					end
--				end
--				if RandomPec then
--					if RandomPec<=0 then
--						RandomPec = 0
--					end
--					nCombatScore = hApi.floor(nCombatScore*RandomPec)
--				end
--			end
--		end
--	end
--	if nCombatScore==nil then
--		nCombatScore = 0
--	end
--	--如果没找到随机组，返回
--	if not(type(tGroup)=="table" and #tGroup>0) then
--		return
--	end
--	local sGroup = __SelectTeamFromGroup(oWorld,tGroup)
--	--开始计算随机刷怪流程
--	if type(sGroup)=="table" and #sGroup>2 and nCombatScore>0 then
--		if type(nScorePec)=="number" then
--			nCombatScore = hApi.floor(nScorePec*nCombatScore)
--		end
--		local uTemp = {}
--		local KickNum = 0
--		for i = 2,#sGroup do
--			if i==#sGroup and sGroup[i]<=13 then
--				KickNum = #uTemp-math.max(0,sGroup[i])
--			else
--				local id = sGroup[i]
--				local tTab = hVar.tab_unit[id]
--				if tTab and (tTab.type==hVar.UNIT_TYPE.UNIT or tTab.type==hVar.UNIT_TYPE.HERO) then
--					local nScoreBasic = math.max(1,(hVar.UNIT_COMBAT_SCORE[tTab.unitlevel or 0] or hVar.UNIT_COMBAT_SCORE[#hVar.UNIT_COMBAT_SCORE])[1])
--					uTemp[#uTemp+1] = {id,0,i-1,s=nScoreBasic,v=0}
--				end
--			end
--		end
--		--随机选择出其中的几个单位
--		if #uTemp>0 then
--			if KickNum>0 then
--				local kTab = {}
--				local vNum = #uTemp
--				for i = 1,vNum do
--					kTab[i] = i
--					uTemp[i][3] = -1
--				end
--				for i = 1,KickNum do
--					local e = vNum-i+1
--					local c = oWorld:random(1,e)
--					kTab[c] = kTab[e]
--					kTab[e] = 0
--				end
--				local r = {}
--				for i = 1,#kTab do
--					local n = kTab[i]
--					if n~=0 then
--						local cI = #r+1
--						r[cI] = uTemp[n]
--						r[cI][3] = cI
--					end
--				end
--				--这里替换了uTemp
--				uTemp = r
--			end
--		end
--		local IsNewUnit = 0
--		if #uTemp>0 and oUnitToAddTeam==nil and oUnitGroup~=nil then
--			--如果未传入需要加入部队的单位，则为新创建一个怪
--			local uId = uTemp[oWorld:random(1,#uTemp)][1]
--			local worldX,worldY = oUnitGroup.data.worldX,oUnitGroup.data.worldY
--			local owner = oUnitGroup.data.owner
--			--这里创建一个新的单位替换了oUnit
--			IsNewUnit = 1
--			oUnitToAddTeam = oWorld:addunit(uId,owner,nil,nil,hVar.UNIT_DEFAULT_FACING,worldX,worldY)
--			if oUnitToAddTeam then
--				oUnitToAddTeam.data.triggerID = oUnitGroup.data.triggerID
--				oUnitToAddTeam.data.nTarget = oUnitGroup.ID
--				oUnitGroup.data.nTarget = oUnitToAddTeam.ID
--			end
--		end
--		if #uTemp>0 and oUnitToAddTeam~=nil then
--			local nP = 0
--			local nInsertPlus = 0
--			for i = 1,#uTemp do
--				local p = oWorld:random(30,100)
--				uTemp[i].v = p
--				nP = nP + p
--			end
--			--初始化队伍
--			if oUnitToAddTeam.data.team==0 then
--				oUnitToAddTeam.data.team = hApi.InitUnitTeam()
--			else
--				local tTeam = oUnitToAddTeam.data.team
--				for i = 1,#tTeam do
--					if type(tTeam[i])=="table" then
--						nInsertPlus = i
--					end
--				end
--			end
--			if nP>0 then
--				if type(GrowthEveryDay)=="number" and GrowthEveryDay>0 then
--					local week = math.min(hApi.floor(oWorld.data.roundcount/7),19)
--					nCombatScore = hApi.getint(nCombatScore*(1+oWorld.data.roundcount*GrowthEveryDay)+(20*(1.1^(1+week))-22)*(1+oWorld.data.roundcount*0.15))
--				end
--				local nCombatScoreX = 0
--				local tinyC
--				for i = 1,#uTemp do
--					local c = uTemp[i]
--					local p = c.v
--					if p>0 then
--						local cs = hApi.getint(nCombatScore*p/nP)
--						c[2] = math.max(1,hApi.floor(cs/c.s))
--						c[3] = i + nInsertPlus
--						c[4] = 1
--						c.v = c[2]*c.s
--						nCombatScoreX = nCombatScoreX + c.v
--						if tinyC==nil or c.s<tinyC.s then
--							tinyC = c
--						end
--					end
--				end
--				nCombatScoreX = nCombatScore-nCombatScoreX
--				if nCombatScoreX>0 and tinyC then
--					local c = tinyC
--					c.v = c.v + nCombatScoreX
--					c[2] = hApi.getint(c.v/c.s)
--				end
--			end
--			--for i = 1,#uTemp do
--				--local id = uTemp[i][1]
--				--if hVar.tab_unit[id] then
--					--local num = (hVar.UNIT_AI_INCREASE_PER_DAY[hVar.tab_unit[id].unitlevel or 0] or 0)
--					--uTemp[i][2] = uTemp[i][2] + hApi.floor(num*w.data.roundcount)
--				--end
--			--end
--			oUnitToAddTeam:teamaddunit(uTemp)
--			--如果是新创建的单位那么这里调用一下出生事件
--			if IsNewUnit==1 then
--				hGlobal.event:call("Event_UnitBorn",oUnitToAddTeam)
--				return oUnitToAddTeam
--			end
--		end
--	end
--end

function hApi.RefreshCombatScore(u)
	if u and u.chaUI["number"] then 
		local combatScore = heroGameAI.CalculateSystem.Calculate(u,nil,heroGameAI.CalculateSystem.CALC_TYPE_DEF.COMBATSCORE)
		local lrs = heroGameAI.CalculateSystem.Calculate(u,nil,heroGameAI.CalculateSystem.CALC_TYPE_DEF.LONGRANGESCORE)
		local ttt
		if u:gethero() then
			local combatScoreB = u:calculate("CombatScore","Basic")
			ttt = string.format("[%s/%s/%s]",tostring(combatScoreB),tostring(combatScore),tostring(lrs))
		else
			ttt = string.format("[%s/%s]",tostring(combatScore),tostring(lrs))
		end
		u.chaUI["number"]:setText(ttt)
	end
end

--道具掉落
local __InitItemTemp = function(tList,temp,nDropQuality,nDropLevel)
	local c = 0
	for i = 1,#tList do
		local v = tList[i]
		--id，基本掉率，掉落质量，掉落等级，扩展掉落等级
		local iId,cBase,iQl,iLv,iEx = v[1],v[2],v[3],v[4],v[5]
		local chanceLv = 100
		local chanceQl = 100
		if nLv~=0 then
			--每个物品等级差距降低 12%+等级差^2 出现几率，超过5级以上的装备不会出现
			local dLv = math.max(0,math.abs(iLv - nDropLevel)-iEx)
			if dLv==0 then
				--什么都不做
			elseif dLv<=5 then
				chanceLv = math.max(0,chanceLv-dLv*12-dLv*dLv)
			else
				chanceLv = 0
			end
		end
		if iQl~=0 then
			--每个物品质量差距降低 2% 出现几率，质量差距超过50以上的装备不会出现
			local qLv = math.max(0,math.abs(iQl - nDropQuality))
			if qLv==0 then
				--什么都不做
			elseif qLv<=50 then
				chanceQl = math.max(0,chanceQl - 2*qLv)
			else
				chanceQl = 0
			end
		end
		if chanceX==100 and chanceQl==100 then
			temp[i] = cBase
		else
			temp[i] = hApi.getint(cBase*chanceLv*chanceQl/10000)
		end
		c = c + temp[i]
	end
	temp[0] = c
	return temp
end
local __TempC = {}
--local DropX = {
	--掉落的ID,基本掉率,掉落质量,掉落等级,掉落等级扩展
	--{1,100,30,10,0},
	--{2,70,15,12,0},
	--{3,40,20,8,0},
--}
hApi.RandomItemId = function(tList,nDropQuality,nDropLevel)
	local temp = __InitItemTemp(tList,__TempC,nDropQuality,nDropLevel)
	if temp[0]>0 then
		local cCur = hApi.random(1,temp[0])
		for i = 1,#tList do
			cCur = cCur - temp[i]
			if cCur<=0 then
				return tList[i][1]
			end
		end
	end
	return 0
end

--掉落随机战术技能卡片
local __DropT = {}
local __GetDropLv = function(id,nDropLv)
	local tabT = hVar.tab_tactics[id]
	if tabT and nDropLv>0 then
		local LvMx = tabT.level or 0
		if hVar.BFSKILL_LEVEL[LvMx] then
			if __DropT[LvMx] and __DropT[LvMx][nDropLv] then
				return __DropT[LvMx][nDropLv]
			else
				__DropT[LvMx] = __DropT[LvMx] or {}
				local tLv = hVar.BFSKILL_LEVEL[LvMx]
				local nLv = 0
				for i = 1,#tLv do
					if tLv[i]<=nDropLv then
						nLv = i
					else
						break
					end
				end
				__DropT[LvMx][nDropLv] = nLv
				return __DropT[LvMx][nDropLv]
			end
		end
	end
	return 0
end
local __TempC = {}
local __TempID = {}
local __InsertToTemp = function(nStart,tList,nCombatPower,nDropLv)
	local nNum = 0
	if tList then
		nNum = #tList
		local c = 0
		for i = 1,nNum do
			local v = tList[i]
			--掉落ID,基本掉率,最低战斗力需求
			local id,cBase,nCbtReq = v[1],v[2],v[3]
			if nCombatPower<nCbtReq then
				cBase = 0
			end
			if __GetDropLv(id,nDropLv)<=0 then
				cBase = 0
			end
			__TempC[nStart+i] = cBase
			__TempID[nStart+i] = id
			c = c + cBase
		end
		__TempC[0] = __TempC[0] + c
	end
	return nStart+nNum
end
local __InitPackTemp = function(tList,tListEx,nCombatPower,nDropLv)
	__TempC[0] = 0
	local nNum = 0
	nNum = __InsertToTemp(nNum,tList,nCombatPower,nDropLv)
	nNum = __InsertToTemp(nNum,tListEx,nCombatPower,nDropLv)
	return __TempC,__TempID,nNum
end
--local DropX = {
	--CombatRequire = {0,100,200,300,400},
	--掉落ID,基本掉率,最低战斗力需求,战斗力在不同难度下对掉落等级的影响(非表则使用CombatRequire)
	--{101,100,0,0},
--}
local __TempC = {}
local __TokenCbtReq = {}
local __RandomDropLevel = function(nDropQuality,a,b)
	if nDropQuality==100 then
		return hApi.random(a,b)
	else
		local nNumA,nNumB
		if a<b then
			nNumA = a*100
			nNumB = b*100
		else
			nNumA = b*100
			nNumB = a*100
		end
		if nDropQuality>100 then
			--正值，提升下限
			nNumA = nNumA + hApi.random(1,hApi.floor((nNumB-nNumA)*(nDropQuality-100)/100))
			return hApi.floor(hApi.random(nNumA,nNumB+99)/100)
		else
			--负值，降低上限
			nNumB = nNumB - hApi.random(1,hApi.floor((nNumB-nNumA)*(100-nDropQuality)/100))
			return hApi.floor(hApi.random(nNumA,nNumB+99)/100)
		end
	end
end
hApi.TestTacticsDrop = function(nMin,nMax,tTestChance)
	nMin = nMin or 1
	nMax = nMax or 6
	tTestChance = tTestChance or {100,125,150,175,200}
	local t = {}
	for i = 1,#tTestChance do
		t[tTestChance[i]] = {}
	end
	for k,v in pairs(t) do
		for i = 1,(nMax-nMin)*10000 do
			local n = __RandomDropLevel(k,nMin,nMax)
			v[n] = (v[n] or 0) + 1
		end
	end
	print("----TEST-DROP------")
	for i = 1,#tTestChance do
		local k = tTestChance[i]
		local v = t[k]
		local s = "["..k.."]:"
		for i = nMin,nMax do
			s = s.."("..i..")"..(v[i] or 0)..","
		end
		print(s)
	end
end
hApi.RandomTacticsId = function(oUnitD,oWorld,nCombatPower)
	if oWorld and oWorld.ID>0 then
		local cBase = 50
		local cExtra = 0
		if oUnitD.data.editorID==0 then
			cBase = 10
		end
		local nDifficulty = oWorld.data.MapDifficulty
		local tList
		local tDropLv
		local tCombatRequire
		local nDropQuality = 100
		local nLvMax = 1
		if hVar.tab_dropT.index[oWorld.data.map] then
			tList = hVar.tab_dropT[hVar.tab_dropT.index[oWorld.data.map]]
			tDropLv = tList.DropLv
			tCombatRequire = tList.CombatRequire
		else
			for i = 1,#hVar.tab_dropT.map do
				local v = hVar.tab_dropT.map[i]
				if oWorld.data.map==v[1] then
					tList = hVar.tab_dropT[1]	--这个必须有，没有就弹框
					nDropQuality = v[2]
					tDropLv = v[4]
					tCombatRequire = v[3]
					break
				end
			end
		end
		--判断掉落最高等级
		if type(tDropLv)=="table" then
			if oUnitD.data.owner~=1 and type(tDropLv[oUnitD.data.id])=="number" then
				nLvMax = tDropLv[oUnitD.data.id]
			else
				nLvMax = tDropLv[1] or 1
			end
		else
			nLvMax = 1
		end
		--处理战斗力
		if type(tCombatRequire)=="table" then
			local nCombatRequire = tCombatRequire[nDifficulty] or 99999999
			if nCombatPower>nCombatRequire and nCombatRequire>0 then
				--对于战斗力较强的怪物，获得战术技能卡的几率提高,至多为2*cBase(20 或 100)
				cExtra = math.min(3*cBase,hApi.floor(cBase*nCombatPower/nCombatRequire)) - cBase
				--根据掉落天数会提高高品质卡片的掉落几率，35天(3周以上)会获得完整的概率
				if cExtra>0 then
					cExtra = hApi.floor(cExtra*(20+hApi.NumBetween(oWorld.data.roundcount-5,0,30))/50)
				end
			end
		end
		if type(tList)=="table" and hApi.random(1,100)<=(cBase+cExtra) then
			local nDropLv = 0
			local tCbtReq = tCombatRequire
			if type(tCbtReq)~="table" then
				tCbtReq = __TokenCbtReq
			end
			local nRand = hApi.random(1,100)
			local nBounce = math.min(35,hApi.floor((100-nRand)*cExtra/200))
			nRand = nRand + nBounce
			if nDifficulty>=5 and nCombatPower>=(tCbtReq[5] or 99999999) then
				if nRand>=90 then
					nDropLv =__RandomDropLevel(nDropQuality,2,6)
				elseif nRand>=80 then
					nDropLv = __RandomDropLevel(nDropQuality,2,5)
				elseif nRand>=60 then
					nDropLv = __RandomDropLevel(nDropQuality,1,5)
				elseif nRand>=40 then
					nDropLv = __RandomDropLevel(nDropQuality,1,4)
				elseif nRand>=20 then
					nDropLv = __RandomDropLevel(nDropQuality,1,3)
				else
					nDropLv = __RandomDropLevel(nDropQuality,1,2)
				end
			elseif nDifficulty>=4 and nCombatPower>=(tCbtReq[4] or 99999999) then
				if nRand>=90 then
					nDropLv = __RandomDropLevel(nDropQuality,2,5)
				elseif nRand>=80 then
					nDropLv = __RandomDropLevel(nDropQuality,1,5)
				elseif nRand>=60 then
					nDropLv = __RandomDropLevel(nDropQuality,1,4)
				elseif nRand>=20 then
					nDropLv = __RandomDropLevel(nDropQuality,1,3)
				else
					nDropLv = __RandomDropLevel(nDropQuality,1,2)
				end
			elseif nDifficulty>=3 and nCombatPower>=(tCbtReq[3] or 99999999) then
				if nRand>=90 then
					nDropLv = __RandomDropLevel(nDropQuality,2,4)
				elseif nRand>=80 then
					nDropLv = __RandomDropLevel(nDropQuality,1,4)
				elseif nRand>=60 then
					nDropLv = __RandomDropLevel(nDropQuality,1,3)
				elseif nRand>=30 then
					nDropLv = __RandomDropLevel(nDropQuality,1,2)
				else
					nDropLv = 1
				end
			elseif nDifficulty>=2 and nCombatPower>=(tCbtReq[2] or 99999999) then
				if nRand>=90 then
					nDropLv = __RandomDropLevel(nDropQuality,1,2)
				elseif nRand>=50 then
					nDropLv = 1
				else
					nDropLv = 0
				end
			else
				nDropLv = 0
			end
			--根据最高卡片掉落等级调整
			nDropLv = math.min(nDropLv,nLvMax)
			if nDropLv>0 then
				local tempC,tempID,nNum = __InitPackTemp(tList,nil,nCombatPower,nDropLv)
				if tempC[0]>0 then
					local cCur = hApi.random(1,tempC[0])
					for i = 1,nNum do
						cCur = cCur - tempC[i]
						if cCur<=0 then
							local id = tempID[i]
							local lv = __GetDropLv(id,nDropLv)
							if lv>0 then
								return id,lv,cExtra
							else
								return 0,0,cExtra
							end
						end
					end
				end
			end
		end
		return 0,0,cExtra
	end
	return 0,0,0
end

--掉落随机战术卡片(根据卡包)
local __GetOneCard = function(nDropLv,tListEx)
	local tList = hVar.tab_dropT[1]		--基本掉落列表
	local tempC,tempID,nNum = __InitPackTemp(tList,tListEx,999999,nDropLv)
	local cCur = hApi.random(1,tempC[0])
	for i = 1,nNum do
		cCur = cCur - tempC[i]
		if cCur<=0 then
			local id = tempID[i]
			local lv = __GetDropLv(id,nDropLv)
			return id,lv
		end
	end
	return 0,0
end

--new zhenkira 2016.3.21
--随机战术技能卡（5抽1,5抽3）
hApi.RandomTacticsIdFromPack = function(itemId)
	local rTab = {}
	local tempItem = {}
	local tacticConfig = hVar.TACTIC_RANDOM_CONFIG[itemId]
	
	--如果战术技能卡权值配置及奖池存在，则进行随机
	if tacticConfig and hVar.TACTIC_RANDOM_CONFIG.pool then
		
		local pool = {}
		
		--格式化奖池，去除奖池中填错的战术技能卡
		for i = 1, #hVar.TACTIC_RANDOM_CONFIG.pool do
			local dropInfo = hVar.TACTIC_RANDOM_CONFIG.pool[i]
			pool[i] = {}
			for j = 1, #dropInfo do
				local dropId = dropInfo[j][1]
				local dropLv = dropInfo[j][2] or 1
				if dropId and hVar.tab_tactics[dropId] then
					local tacticQuality = hVar.tab_tactics[dropId].quality or 1
					if tacticQuality == i then
						pool[i][#(pool[i]) + 1] = dropInfo[j]
					end
				end
			end
		end
		
		--根据权值计算出各权重道具掉落个数
		--返回属性品质
		local configIdx
		--属性权重范围临时值
		local tmpTacticInfo = {}
		--总权值
		local sumWeight = 0
		
		--遍历所有权重信息，记录每一个属性权重范围，计算总的权重
		for i, randomInfo in pairs(tacticConfig) do
			local weight = randomInfo[1] or 0
			if weight > 0 then
				tmpTacticInfo[i] = {}
				tmpTacticInfo[i].min = sumWeight
				sumWeight = sumWeight + weight
				tmpTacticInfo[i].max = sumWeight
			end
		end
		
		--在总权重范围内随机
		local rWeight = hApi.random(1, sumWeight)
		
		--遍历权重范围临时值,看随机权值落在哪个区间
		for i, weightInfo in pairs(tmpTacticInfo) do
			if rWeight > weightInfo.min and rWeight <= weightInfo.max then
				configIdx = i
				break
			end
		end
		
		--如果存在掉落数量配置列表，则进行掉落
		if configIdx and tacticConfig[configIdx] and tacticConfig[configIdx][2] then
			--掉落数量列表
			local tabDropNums = tacticConfig[configIdx][2]
			--最大掉落数
			local maxDrop = 5
			--当前掉落数
			local dropNow = 0
			
			--遍历每一级掉落
			for i = 1, #tabDropNums do
				--当前掉落数如果大于最大掉落数，则中断循环
				if dropNow >= maxDrop then
					break
				end
				--掉落数
				local dropNum = tabDropNums[i] or 0
				--开始掉落
				for n = 1, dropNum do
					
					--当前掉落数如果大于最大掉落数，则中断循环
					if dropNow >= maxDrop then
						break
					end
					
					--当前等级的掉落列表
					local tacticInfos = pool[i]
					--随机掉落列表中的索引
					local tacticIdx = hApi.random(1, #tacticInfos)
					
					--如果掉落信息存在，则添加进掉落中
					if tacticIdx and tacticInfos[tacticIdx] and tacticInfos[tacticIdx][1] then
						local tacticId = tacticInfos[tacticIdx][1]
						local tacticLv = math.min((tacticInfos[tacticIdx][2] or 1), hVar.TACTIC_LVUP_INFO.maxTacticLv)
						tempItem[#tempItem + 1] = {tacticId, tacticLv}
						dropNow = dropNow + 1
					end
				end
			end
			
			--如果掉落数量不足，遍历所有奖池补全掉落
			if dropNow < maxDrop then
				for n = 1, maxDrop - dropNow do
					--当前掉落数如果大于最大掉落数，则中断循环
					if dropNow >= maxDrop then
						break
					end
					
					for i = 1, #pool do
						--当前等级的掉落列表
						local tacticInfos = pool[i]
						--随机掉落列表中的索引
						local tacticIdx = hApi.random(1, #tacticInfos)
						
						--如果掉落信息存在，则添加进掉落中
						if tacticIdx and tacticInfos[tacticIdx] and tacticInfos[tacticIdx][1] then
							local tacticId = tacticInfos[tacticIdx][1]
							local tacticLv = math.min((tacticInfos[tacticIdx][2] or 1), hVar.TACTIC_LVUP_INFO.maxTacticLv)
							tempItem[#tempItem + 1] = {tacticId, tacticLv}
							dropNow = dropNow + 1
						end
					end
				end
			end
		end
		
	end
	
	--随机排列
	local temp = {}
	hApi.RandomIndex(#tempItem,5,temp)
	for i = 1,5 do
		local tacticInfo = tempItem[temp[i]]
		rTab[i] = tacticInfo --类型，道具ID，道具名字，道具出现的几率，3个可选参数
	end

	return rTab
end

--old zhenkira 2016.3.21
--hApi.RandomTacticsIdFromPack = function(itemId)
--	local rTab = {}
--	--以全随机方式选出所有的卡片
--	if itemId==9101 then
--		local tListEx = hVar.tab_dropT[2]		--初级卡包额外掉落
--		--给1张的包，随机3~6品质
--		for i = 1,5 do
--			local rand = hApi.random(1,10)
--			local nDropLv = 1
--			if rand>=10 and rand<=10 then
--				--10%的几率获得品质6的卡
--				local id,lv = __GetOneCard(6,tListEx)
--				rTab[#rTab+1] = {id,lv}
--			elseif rand>=7 and rand<=9 then
--				--30%的几率获得可升级的卡片，最多5级
--				local id,lv = __GetOneCard(5,tListEx)
--				rTab[#rTab+1] = {id,lv}
--			else
--				--60%的几率获得等级3~4的卡片
--				local id,lv = __GetOneCard(hApi.random(3,4),tListEx)
--				rTab[#rTab+1] = {id,lv}
--			end
--		end
--	elseif itemId==9102 then
--		local tListEx = hVar.tab_dropT[3]		--高级卡包额外掉落
--		--给3张的包，随机5~7品质
--		for i = 1,5 do
--			local rand = hApi.random(1,10)
--			local nDropLv = 1
--			if rand>=9 and rand<=10 then
--				--20%的几率获得品质7的卡
--				local id,lv = __GetOneCard(7,tListEx)
--				rTab[#rTab+1] = {id,lv}
--			elseif rand>=6 and rand<=8 then
--				--30%的几率获得品质6的卡
--				local id,lv = __GetOneCard(6,tListEx)
--				rTab[#rTab+1] = {id,lv}
--			else
--				--50%的几率获得等级5的卡片
--				local id,lv = __GetOneCard(5,tListEx)
--				rTab[#rTab+1] = {id,lv}
--			end
--		end
--	end
--	return rTab
--end

--这是王总要的作弊函数
function cheat01()

  --加钱1000
  --建造cooldown恢复, 可以连续造东西
	hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD,1000)

	for i = 1, #hGlobal.LocalPlayer.data.ownTown do
		if hGlobal.LocalPlayer.data.ownTown[i] then
			local Town = hApi.GetObjectUnit(hGlobal.LocalPlayer.data.ownTown[i])
			if Town then
				local oTown = Town:gettown()
				if oTown then
					oTown.data.buildingCount = 0
				end
			end
			
		end
	end

	--这是常乾辰要的作弊功能
	local heros = hGlobal.LocalPlayer.heros
	for i = 1,#heros do
		local unit = heros[i]:getunit()
		if unit then
			--unit.data.team[6] = {10038,200}
			unit.data.team[5] = {10033,100}
			unit.data.team[6] = {10036,100}
			unit.data.team[7] = {11999,1}
		end
		--加经验
		heros[i]:addexp(99999)
		heros[i]:additembyID(8998,{3,0,0,0})---陶晶之剑
	end
	
	
	g_FPSUI_show = 0
	xlShowFPS(g_FPSUI_show)

	heroGameInfo.worldMap.ShowUnitsCombatScore(true)

	--增加积分
	LuaAddPlayerScore(1000)

	--增加游戏币
	--CCUserDefault:sharedUserDefault():setIntegerForKey("GameCoin",10000)
	--CCUserDefault:sharedUserDefault():flush()

	hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.CRYSTAL,100)
	hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.GOLD,10000)
	hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.FOOD,10000)
	hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.STONE,100)
	hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.WOOD,100)
	hGlobal.LocalPlayer:addresource(hVar.RESOURCE_TYPE.LIFE,100)

	--dofile("data/scripts/util/ui/uiEditor.lua")
end

function cheat02(team) --王总要的作弊功能 添加部队
	local heros = hGlobal.LocalPlayer.heros
	local unitID,num = 0,0
	for i = 1,#heros do
		local unit = heros[i]:getunit()
		if unit then
			for j = 2,#unit.data.team do
				unitID,num = unpack(team[j-1])
				unit.data.team[j] = {unitID,num}
			end
		end
	end
end
--(优化)不稳定代码
--hApi.ObjectSetFacing = function()
--end

--hApi.ObjectPlayAnimation = function()
	--return 1000
--end

--hClass.unit.setanimation = function(self,aniKey,forceToPlay)
	--return -1
--end

-- SpriteSet函数
--local __SpriteSetScaleByWHEx = function(s,scale,w,h,imageW,imageH)
	--local scaleX,scaleY = scale,scale
	--if w>0 then scaleX = scaleX*w/imageW end
	--if h>0 then scaleY = scaleY*h/imageH end
	--if scaleX~=1 then s:setScaleX(scaleX) end
	--if scaleY~=1 then s:setScaleY(scaleY) end
	--return scaleX,scaleY,w*scale,h*scale
--end

--local __Align = hVar.UI_ALIGN

--hApi.SpriteLoadOneFrameEx = function(handleTable,animation,scale,align,imageW,imageH,rTab)
	--local aniKey,IsSafe,modelTab = hApi.safeAnimation(handleTable,animation)
	--local ani = modelTab[aniKey]
	--local _x,_y,sizeW,sizeH= unpack(ani[1])
	--imageW,imageH = hApi.ImageCalculateWH(imageW,imageH,sizeW,sizeH)

	--local path = ani.image or modelTab.image or "_"
	--if rTab and type(rTab)=="table" then
		--rTab.x = _x
		--rTab.y = _y
		--rTab.w = sizeW
		--rTab.h = sizeH
	--end
	--local childS = xlCreateSprite("data/image/"..path)
	--local scaleX,scaleY = __SpriteSetScaleByWHEx(childS,scale,imageW,imageH,sizeW,sizeH)
	--if __Align[align] then
		--local a = __Align[align]
		--childS:setAnchorPoint(ccp(a[1]/2,a[2]/2))
	--end
	--if ani.flipX==1 then
		--childS:setFlipX(true)
	--end
	--if ani.flipY==1 then
		--childS:setFlipY(true)
	--end
	--if ani.roll~=nil and ani.roll~=0 then
		--childS:setRotation(-1*ani.roll)
	--end
	--return childS,imageW,imageH,scaleX,scaleY
--end

hApi.CalDisP2L = function(x,y,pTab)
	return math.abs(pTab.k*x+pTab.p*y+pTab.c)/pTab.m
end

local __pTab = {}
--选择一个目标移动方格
hApi.SelectMoveGrid = function(oUnit,tGrid,gridX,gridY)
	local w = oUnit:getworld()
	if #tGrid<=0 then
		return
	end
	if oUnit.attr.block==hVar.UNIT_BLOCK_MODE.RIDER then
		local tx,ty = w:grid2xy(gridX,gridY)
		local ux,uy = oUnit:getXY()
		local selectR
		if ux>tx then
			selectR = 0
		elseif ux<tx then
			selectR = 1
		end
		if selectR==nil then
			if oUnit.data.facing>90 and oUnit.data.facing<=270 then
				selectR = 0
			else
				selectR = 1
			end
		end
		local dis
		local selectI = 0
		--两格单位
		if selectR==1 then
			--左向选择
			for i = 1,#tGrid do
				local v = tGrid[i]
				if gridX==(v.x+1) and gridY==v.y then
					return v.x,v.y
				elseif gridX==v.x and gridY==v.y then
					selectI = i
				end
			end
		else
			--右向选择
			for i = 1,#tGrid do
				local v = tGrid[i]
				if gridX==v.x and gridY==v.y then
					return v.x,v.y
				elseif gridX==(v.x+1) and gridY==v.y then
					selectI = i
				end
			end
		end
		if selectI>0 then
			return tGrid[selectI].x,tGrid[selectI].y
		end
	else
		--一格单位
		for i = 1,#tGrid do
			local v = tGrid[i]
			if gridX==v.x and gridY==v.y then
				return v.x,v.y
			end
		end
	end
	local ux,uy = oUnit:getstandXY()
	local cx,cy = oUnit:getXY()
	local tx,ty = w:grid2xy(gridX,gridY)
	hApi.CalLineParam(cx,cy,tx,ty,__pTab)
	local nL = math.max(1,math.min(w.data.gridW,w.data.gridH))
	local dis
	local selectI = 0
	for i = 1,#tGrid do
		local wx,wy = w:grid2xy(tGrid[i].x,tGrid[i].y)
		if hApi.CalDisP2L(wx,wy,__pTab)<=nL then
			local l = (wx+ux-tx)^2+(wx+ux-tx)^2
			if dis==nil or dis>l then
				dis = l
				selectI = i
			end
		end
	end
	if selectI>0 then
		return tGrid[selectI].x,tGrid[selectI].y
	end
end

--计算一个道具可以锻造的次数
hApi.CalculateItemRewardEx = function(itemID)
	local itemLv = hVar.tab_item[itemID].itemLv or 1
	if itemLv == 0 then
		itemLv = 1
	end
	local itemRulu = hVar.ITEM_ENHANCE_NUM[itemLv]
	
	local m = 0
	--先得到总概率
	for i = 1,#itemRulu do
		m = m + itemRulu[i][1]
	end

	local tempN = hApi.random(1,m)
	local tempX = 0
	for i = 1,#itemRulu do
		tempX = tempX + itemRulu[i][1]
		if tempN<=tempX then
			return itemRulu[i][2]
		end
	end
	if #itemRulu>0 then
		return itemRulu[#itemRulu][2]
	else
		return 0
	end
end


------------------------------
--将道具给英雄
local __TokenItem = {
	ID = 0,
	__ID = 0,
	del = function(self)
		self.ID = 0
	end,
}
hApi.GiveItemToHeroByID = function(oHero,itemID,rewardEx,fromWhat,sBagName,nBagIndex,fromlist)
	local oItemToPick
	local tabI = hVar.tab_item[itemID]
	if tabI and tabI.type ~= hVar.ITEM_TYPE.RESOURCES then
		--生成一个道具唯一ID
		if tabI.type==hVar.ITEM_TYPE.DEPLETION then
			oItemToPick = hApi.CreateItemObjectByID(itemID,nil,nil,fromlist)
		elseif type(tabI.continuedays)=="number" then
			--时限型道具
			local tInfo = {g_game_days,tabI.continuedays}
			rewardEx = rewardEx or {0}
			oItemToPick = hApi.CreateItemObjectByID(itemID,rewardEx,tInfo,fromlist)
		else
			oItemToPick = hApi.CreateItemObjectByID(itemID,rewardEx,nil,fromlist)
		end
		__TokenItem.ID = -1
		if sBagName then
			hGlobal.event:call("Event_HeroGetItem",oHero,oItemToPick,sBagName,(nBagIndex or 0),nil,__TokenItem)
		else
			hGlobal.event:call("Event_HeroGetItem",oHero,oItemToPick,"bag",nil,nil,__TokenItem)
		end
		if __TokenItem.ID==0 then
			return 1
		else
			return 0
		end
	else
		return 0
	end
end

--zhenkira 2016.2.29 new code
--创建道具对象ID(道具id, 道具附加价值倍率, )
hApi.CreateItemObjectByID = function(itemID,rewardEx,info,fromlist,exValueRatio,entity,quality)
	--生成道具扩展属性
	local tabI = hVar.tab_item[itemID] or {}
	local itemLv = tabI.itemLv or hVar.ITEM_QUALITY.WHITE
	local itemValue = tabI.itemValue or 1

	if entity then
		--ID = 1,			--物品ID
		--NUM = 2,		--个数
		--SLOT = 3,		--锻造孔{孔数，属性1，属性2...属n}
		--PICK = 4,		--拾取时间{游戏内的天数，持续天数}
		--VERSION = 5,		--获得道具的版本号
		--UNIQUE = 6,		--物品唯一ID
		--QUALITY = 7,		--物品是否可装备(满足等级需求)
		--LOCK = 8,		--锻造锁 当锻造过 且没有锻造至顶级时 设置为0，否则设置为1 9 道具来源
		--FROM = 9,		--来源追溯
		--UNKNOW = 10,
		--XILIAN_COUNT = 11, --今日锁孔洗炼次数
		--XILIAN_DATE = 12, --今日锁孔洗炼次数最后一次的日期（字符串）（北京时间）
		local item_uniqueID = hApi.GetItemUniqueID(g_curPlayerName,g_localfilepath)
		return {itemID,1,entity.attr,info or 0,"",item_uniqueID,quality,1,{{hVar.ITEM_FROMWHAT_TYPE.NET,entity.dbid,entity.slotnum,0}},0,0,0,
			entity.randIdx1,entity.randVal1,entity.randIdx2,entity.randVal2,entity.randIdx3,entity.randVal3,entity.randIdx4,entity.randVal4,entity.randIdx5,entity.randVal5,
			entity.randSkillIdx1,entity.randSkillLv1,entity.randSkillIdx2,entity.randSkillLv2,entity.randSkillIdx3,entity.randSkillLv3,}
	else
		--只有装备，武器才有附加属性
		--print("exValueRatio:",exValueRatio,tabI.type)
		if exValueRatio and exValueRatio > 0 and tabI.type >= hVar.ITEM_TYPE.HEAD and tabI.type <= hVar.ITEM_TYPE.FOOT then
			rewardEx = hApi.CreateItemAttrEx(itemLv, itemValue, exValueRatio or 0)
			if rewardEx and type(rewardEx) == "table" then
				for i = 1, #rewardEx do
					print("reawrdEx:",rewardEx[i])
				end
			end
		end

		info = info or {-1,-1}
		fromlist = fromlist or 1
		if fromlist==-1 or (type(fromlist)=="table" and type(fromlist[1])=="table" and fromlist[1][1]==hVar.ITEM_FROMWHAT_TYPE.PICK) then
			local item_uniqueID = 0
			return {itemID,1,rewardEx,info or 0,"",item_uniqueID,0,1,fromlist,0}
		else
			local item_uniqueID = hApi.GetItemUniqueID(g_curPlayerName,g_localfilepath)
			return {itemID,1,rewardEx,info or 0,"",item_uniqueID,0,1,fromlist,0}
		end
	end
end

hApi.RedEquipToClientOItem = function(entity)
	local item_uniqueID = hApi.GetItemUniqueID(g_curPlayerName,g_localfilepath)
	return {entity.typeId,1,entity.attr,info,hVar.CURRENT_ITEM_VERSION,item_uniqueID,0,1,{{hVar.ITEM_FROMWHAT_TYPE.NET,entity.dbid,entity.slotnum,0}},0}
end

--获取装备随机属性
hApi.GetItemRandomAttr = function(attrR, excludeAttr)
	local baseAttrSet = hVar.ITEM_ATTR_QUALITY_DEF[attrR]

	--获取属性池
	--计算，如果已经抽取的属性不再抽取
	local attrSet = {}
	for i = 1, #hVar.ITEM_ATTR_QUALITY_DEF[attrR] do
		local flag = true
		local baseAttr = hVar.ITEM_ATTR_QUALITY_DEF[attrR][i]
		for j = 1, #excludeAttr do
			local excludeAttr = excludeAttr[j]
			--排除已经抽取的属性
			if hVar.ITEM_ATTR_VAL[baseAttr].attrAdd == hVar.ITEM_ATTR_VAL[excludeAttr].attrAdd then
				flag = false
				break
			end
		end
		if flag then
			attrSet[#attrSet + 1] = baseAttr
		end
	end
	
	--一个防出错机制，如果奖池中所有的属性都已经随出来过，则奖池等于基础奖池
	if #attrSet <= 0 then
		attrSet = baseAttrSet
		print("attr pool is null.")
	end
	--local attrSet = hVar.ITEM_ATTR_QUALITY_DEF[attrR]
	if #attrSet > 0 then
		--随机属性索引
		local attrIdx = hApi.random(1,#attrSet)
		--随机出的属性
		local attr = attrSet[attrIdx]
		if hVar.ITEM_ATTR_VAL[attr] then
			excludeAttr[#excludeAttr+1] = attr
			print("item get attr:",attr)
			return attr
		end
	end
end

--创建道具扩展属性(道具品质等级，道具基础价值，道具附加属性倍数)
hApi.CreateItemAttrEx = function(itemLv, itemValue, exValueRatio)
	local ret = -1
	--最大孔数
	local holeMax = hVar.ITEM_ATTR_EX_LIMIT[itemLv] or 0

	if holeMax > 0 then
		local hole = math.floor(exValueRatio / 5)
		local randomAttrFlag = false
		
		--如果必定产生的孔数大于等于道具可产生孔数
		if hole >= holeMax then
			hole = holeMax
		else
			--如果小于，则需要计算剩余价值是否能够再出一个新孔
			randomAttrFlag = true
		end
		
		--计算必出孔内的随机属性
		ret = {}
		local excludeAttr = {}
		--遍历每一个孔，随机属性
		for i = 1, hole do
			--随机属性品质
			local attrR = hApi.random(1,5) --随机属性的品质
			local attr = hApi.GetItemRandomAttr(attrR, excludeAttr)
			if attr then
				ret[#ret+1] = attr
			end
		end
		
		--计算剩余价值点数是否能够再出一个孔
		if randomAttrFlag then
			--如果必定产生的孔数小于道具可产生孔数
			local randomHole = math.mod(exValueRatio,5)
			local r = hApi.random(1, 5)
			if r <= randomHole then
				local attr = hApi.GetItemRandomAttr(r, excludeAttr)
				if attr then
					ret[#ret+1] = attr
				end
			end
		end
	end
	
	if ret and type(ret) == "table" then
		print("ret length:", #ret)
	end

	return ret
end
--zhenkira 2016.2.29 old code 
--hApi.CreateItemObjectByID = function(itemID,rewardEx,info,fromlist)
--	if rewardEx==nil then
--		rewardEx = -1
--	elseif type(rewardEx)=="number" then
--		
--	elseif type(rewardEx)~="table" then
--		local tabI = hVar.tab_item[itemID]
--		if tabI==nil then
--			--不知道类型的物品
--		else
--			if rewardEx=="mx" then
--				local n = hVar.EQUIPMENT_MAX_SLOT[tabI.itemLv or 1]
--				if n and hVar.ITEM_EQUIPMENT_POS[tabI.type]==1 then
--					rewardEx = hApi.NumTable(n+1)
--					rewardEx[1] = n
--				end
--			end
--			if type(rewardEx)~="table" then
--				rewardEx = 0
--			end
--		end
--	end
--	info = info or {-1,-1}
--	fromlist = fromlist or 1
--	if fromlist==-1 or (type(fromlist)=="table" and type(fromlist[1])=="table" and fromlist[1][1]==hVar.ITEM_FROMWHAT_TYPE.PICK) then
--		local item_uniqueID = 0
--		return {itemID,1,rewardEx,info,hVar.CURRENT_ITEM_VERSION,item_uniqueID,0,1,fromlist,0}
--	else
--		local item_uniqueID = hApi.GetItemUniqueID(g_curPlayerName,g_localfilepath)
--		return {itemID,1,rewardEx,info,hVar.CURRENT_ITEM_VERSION,item_uniqueID,0,1,fromlist,0}
--	end
--end

hApi.IsItemEquipable = function(oItem)
	if type(oItem) ~= "table" then
		return 0
	end
	local tabI = hVar.tab_item[oItem[hVar.ITEM_DATA_INDEX.ID]]
	if tabI==nil then
		--非法道具不能装备
		return 0
	elseif hVar.ITEM_EQUIPMENT_POS[tabI.type or 0]~=1 then
		--不能装备的道具
		return 0
	else
		return 1
	end
end

--物品是否可以被锻造
hApi.IsItemForgeable = function(oItem)
	if type(oItem) ~= "table" then
		return 0
	end
	local tabI = hVar.tab_item[oItem[hVar.ITEM_DATA_INDEX.ID]]
	if tabI==nil then
		--非法道具不能锻造
		return 0
	elseif hVar.ITEM_EQUIPMENT_POS[tabI.type or 0]~=1 then
		--只有可装备的道具才能被锻造
		return 0
	elseif type(oItem[hVar.ITEM_DATA_INDEX.PICK])=="table" and oItem[hVar.ITEM_DATA_INDEX.PICK][1]~=-1 then
		--限时道具不可锻造
		return 0
	else
		return 1
	end
end

--物品是否可以被分解
hApi.IsItemDecomposeable = function(oItem)
	if type(oItem) ~= "table" then
		return 0
	end
	local tabI = hVar.tab_item[oItem[hVar.ITEM_DATA_INDEX.PICK]]
	if tabI and tabI.itemLv==4 and tabI.unique==1 then
		--独特(首冲类)红装不能被分解
		return 0
	else
		return 1
	end
end

--物品是否可以被许愿(献祭)
hApi.IsItemWishable = function(oItem)
	if type(oItem) ~= "table" then
		return 0
	end
	local tabI = hVar.tab_item[oItem[PICK]]
	if tabI and tabI.itemLv==4 and tabI.unique==1 then
		--独特(首冲类)红装不能被合成
		return 0
	else
		return 1
	end
end

--格式化物品
--升级物品格式 当物品数据项少于8时 增加锻造锁 数据 并设置为1 锁定状态
--升级物品格式 当物品数据项少于9时 增加道具来源表
--升级物品格式 当物品数据少于10项时 增加锻造次数count
hApi.FormatItemObject = function(oItem)
	if type(oItem) == "table" then
		--老版本的道具没有版本号，在这里设置道具获得版本为当前版本号
		if type(oItem[hVar.ITEM_DATA_INDEX.VERSION])~="string" then
			oItem[hVar.ITEM_DATA_INDEX.VERSION] = "o:"..tostring(hVar.CURRENT_ITEM_VERSION)
		end
		if oItem[hVar.ITEM_DATA_INDEX.LOCK] == nil then
			oItem[hVar.ITEM_DATA_INDEX.LOCK] = 1
		end
		
		if oItem[hVar.ITEM_DATA_INDEX.FROM] == nil then
			oItem[hVar.ITEM_DATA_INDEX.FROM] = {}
		end

		if oItem[hVar.ITEM_DATA_INDEX.UNKNOWN] == nil then
			oItem[hVar.ITEM_DATA_INDEX.UNKNOWN] = 0
		end
		--oItem[hVar.ITEM_DATA_INDEX.ENABLE] = 0	--按照李宁要求 把所有道具在初始化时候的 是否可用标记设置为0
	end
end


--遍历玩家拥有的所有物品，进行操作
--这个接口只能在没开启世界地图的时候调用
local __CODE__EnumItemFunc = function(tTemp,pFunc,oItem,param1,param2,sBagName,nIndex)
	if type(oItem)~="table" then
		return oItem
	end
	local r = pFunc(oItem,param1,param2,sBagName,nIndex)
	if r~=nil then
		if tTemp then
			tTemp.reload = 1
		end
		return r
	else
		return oItem
	end
end
local __ENUM__ReloadMyHero = function(oHero,tReloadHeroID)
	if oHero.data.HeroCard==1 and tReloadHeroID[oHero.data.id]==1 and oHero:getowner()==hGlobal.LocalPlayer then
		oHero:LoadHeroFromCard("load")
	end
end
hApi.EnumAllMyItem = function(pFunc,param1,param2)
	local tSave = Save_PlayerData
	if type(tSave)=="table" then
		local tReloadHeroID = {reload=0}
		local NeedSave = 0
		if type(tSave.herocard)=="table" then
			for n = 1,#tSave.herocard do
				local v = tSave.herocard[n]
				tReloadHeroID.reload = 0
				local sBagName = v.id.."item"
				for i = 1,#v.item do
					v.item[i] = __CODE__EnumItemFunc(tReloadHeroID,pFunc,v.item[i],param1,param2,sNameBag,i)
				end
				local sBagName = v.id.."equipment"
				for i = 1,#v.equipment do
					v.equipment[i] = __CODE__EnumItemFunc(tReloadHeroID,pFunc,v.equipment[i],param1,param2,sNameBag,i)
				end
				if tReloadHeroID.reload==1 then
					NeedSave = 1
					tReloadHeroID[v.id] = 1
				end
			end
		end
		if type(tSave.bag)=="table" then
			tReloadHeroID.reload = 0
			local sBagName = "bag"
			for i = 1,#tSave.bag do
				tSave.bag[i] = __CODE__EnumItemFunc(tReloadHeroID,pFunc,tSave.bag[i],param1,param2,sNameBag,i)
			end
			if tReloadHeroID.reload==1 then
				NeedSave = 1
			end
		end
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld~=nil then
			hClass.hero:enum(__ENUM__ReloadMyHero,tReloadHeroID)
		end
		if NeedSave==1 then
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end
end

hApi.GetItemUniqueID = function()
	local playerData = LuaGetPlayerData()
	if playerData and playerData.itemUniqueID then
		playerData.itemUniqueID = playerData.itemUniqueID+1
		return playerData.itemUniqueID
	end
end

hApi.AddMapUniqueID = function()
	local playerData = LuaGetPlayerData()
	if playerData and playerData.mapUniqueID then
		playerData.mapUniqueID = playerData.mapUniqueID+1
		return playerData.mapUniqueID
	end
end

hApi.CheckItemAvailable = function(item)
	--[[
	if type(item) == "table" then
		if item[hVar.ITEM_DATA_INDEX.ENABLE] == 1 then
			return 0
		else
			return 1
		end
	end
	return 0
	]]
	return 1
end

--设置一个道具是否可使用
hApi.SetItemAvailable = function(item,Val)
	--[[
	if type(item) == "table" then
		if Val == 0 then
			item[hVar.ITEM_DATA_INDEX.ENABLE] = 1
		elseif Val == 1 then
			item[hVar.ITEM_DATA_INDEX.ENABLE] = 0
		end
		return 1
	end
	return 0
	]]
end

--设置一个道具的锻造锁开关
hApi.SetItemForgedLock = function(item,Val)
	if type(item) == "table" then
		item[hVar.ITEM_DATA_INDEX.LOCK] = Val
		return 1
	end
	return 0
end

--检测道具锁 返回0 表示 没有锁定 返回1 表示锁定
hApi.CheckItemForgedLock = function(item)
	if type(item) == "table" then
		return item[hVar.ITEM_DATA_INDEX.LOCK] or 1
	end
	return 0
end


--------------------------------------------裁剪功能相关的函数----------------------------------------------------------
--重载英雄卡片和 背景槽子的 父节点
hApi.ReloadParent = function(childNode,ParentNode)
	childNode:retain()
	childNode:getParent():removeChild(childNode,true)
	ParentNode:addChild(childNode)
	childNode:release()
end

--在裁剪面板上移动每一个 item 方法 参数 1,2 代表 x轴 y轴 的偏移量， 参数 3 4 描述一个 具体的 UI 控件 
hApi.MoveItemList = function(vX,vY,itemNode,itemList)
	local tempX,tempY = 0,0
	if type(itemList) == "table" then
		for i = 1,#itemList do
			tempX,tempY = itemNode[itemList[i]].data.x,itemNode[itemList[i]].data.y
			itemNode[itemList[i]].data.y = tempY+vY
			itemNode[itemList[i]].handle._n:setPosition(tempX,tempY+vY)
		end
	else
		print("hApi.MoveItemList have erro")
	end
end

--设置移动具体的 item 对象时 重新计算 item 的 绝对坐标， 因为 在 裁剪面板 和 原UI 体系中， 相对坐标是不同的 坐标系，故需要这一步操作
hApi.SetItemBeginPos = function(o,vx,vy)
	local tempX,tempY = o.data.x + vx , o.data.y + vy
	o.data.x,o.data.y = tempX,tempY
	o.handle._n:setPosition(tempX,tempY)
end

local __NETSHOP__Index = {}
hApi.GetNetShopItemById = function(id)
	local nIndex = __NETSHOP__Index[id] or 0
	local tabSI = hVar.tab_shopitem[nIndex]
	if tabSI and tabSI.type==1 and tabSI.itemID==id then
		return tabSI
	end
	for i = 1,math.max(#hVar.tab_shopitem,99) do
		local tabSI = hVar.tab_shopitem[i]
		if tabSI and tabSI.type==1 and tabSI.itemID==id then
			__NETSHOP__Index[id] = i
			return tabSI
		end
	end
end

--分解道具资源
--hApi.GetMatrialByDecomposeItem = function(oItem,rTab)
--	rTab = rTab or {}
--	local itemID = oItem[hVar.ITEM_DATA_INDEX.ID]
--	local itemLv = (hVar.tab_item[itemID].itemLv or 1)
--	--捡来的道具分解不出任何东西
--	if type(oItem[hVar.ITEM_DATA_INDEX.FROM])=="table" then
--		for i = 1,#oItem[hVar.ITEM_DATA_INDEX.FROM] do
--			if type(oItem[hVar.ITEM_DATA_INDEX.FROM][i]) == "table" then
--				if type(oItem[hVar.ITEM_DATA_INDEX.FROM][i][1]) == "number" then
--					if oItem[hVar.ITEM_DATA_INDEX.FROM][i][1]==hVar.ITEM_FROMWHAT_TYPE.PICK then
--						itemLv = 0
--						break
--					end
--				end
--			end
--		end
--	end
--	if itemLv==1 then
--		rTab[1] = (rTab[1] or 0) + hApi.random(1,5)							--取1-5之间的随机数
--	elseif itemLv==2 then
--		rTab[1] = (rTab[1] or 0) + hApi.random(5,10)
--		rTab[2] = (rTab[2] or 0) + hApi.random(0,2)
--	elseif itemLv==3 then
--		--分解黄装（3等级）	changed by pangyong 2015/4/22
--		if hVar.DecomposeMat3[itemID] ~= nil then 
--			rTab[1] = (rTab[1] or 0) + hApi.random( hVar.DecomposeMat3[itemID][1][1], hVar.DecomposeMat3[itemID][1][2] )
--			rTab[2] = (rTab[2] or 0) + hApi.random( hVar.DecomposeMat3[itemID][2][1], hVar.DecomposeMat3[itemID][2][2] )
--			rTab[3] = (rTab[3] or 0) + hVar.DecomposeMat3[itemID][3][ hApi.random(1, #hVar.DecomposeMat3[itemID][3]) ]
--		elseif 1 == hVar.tab_item[itemID].elite then	
--			--精英装备标记，1:精英地图打出来的	
--			rTab[1] = (rTab[1] or 0) + hApi.random(40,80)
--			rTab[2] = (rTab[2] or 0) + hApi.random(9,18)
--			rTab[3] = (rTab[3] or 0) + hApi.random(4,8)
--		end
--	elseif itemLv==4 then
--		rTab[1] = (rTab[1] or 0) + hApi.random(150,300)
--		rTab[2] = (rTab[2] or 0) + hApi.random(30,60)
--		rTab[3] = (rTab[3] or 0) + hApi.random(15,30)
--	end
--	return rTab
--end

--检测 战术技能卡 获取计数器 是否合法
hApi.CheckBFSCardIllegal = function(playerName)
	
	--如果是windows版 则不检验
	local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
	if g_tTargetPlatform.kTargetWindows == TargetPlatform then
		return 0
	end
	
	local bfsCount = LuaGetBFSkillCardCount()
	local new_CardCount = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..playerName.."SkillCardCount")
	local synchronous_CardCount_val = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."synchronous_CardCount_val")
	if bfsCount ~= new_CardCount  then
		xlAppAnalysis("cheat_bfskill",0,1,"info",tostring(xlPlayer_GetUID()).."-name:"..tostring(playerName).."-bfsCount:"..tostring(bfsCount).."-CardCount:"..tostring(new_CardCount).."-syncV"..tostring(synchronous_CardCount_val).."-T:"..tostring(os.date("%m%d%H%M%S")))
		--key中的值小于存档中的值，且从未做过同步时，用存档中的值进行一次同步
		if new_CardCount < bfsCount then
			if synchronous_CardCount_val == 0 then
				xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."SkillCardCount",bfsCount)
				xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."synchronous_CardCount_val",1)
				return 
			end
		end
		LuaSetBFSkillCardCount(new_CardCount)

		--直接删除游戏存档
		if hApi.FileExists(g_localfilepath..playerName..hVar.SAVE_DATA_PATH.MAP_SAVE,"full") then
			xlDeleteFileWithFullPath(g_localfilepath..playerName..hVar.SAVE_DATA_PATH.MAP_SAVE)
			xlDeleteFileWithFullPath(g_localfilepath..playerName..hVar.SAVE_DATA_PATH.FOG)
		end

		--当前场景在世界中 返回玩家 列表
		if g_current_scene == g_world then
			--如果世界存在 则删除
			if hGlobal.WORLD.LastWorldMap then
				hGlobal.WORLD.LastWorldMap:del()
				hGlobal.WORLD.LastWorldMap = nil
				
			end
			if hGlobal.WORLD.LastTown~=nil then
				hGlobal.WORLD.LastTown:del()
				hGlobal.WORLD.LastTown = nil
			end
			hApi.clearCurrentWorldScene()
			
			hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")

		end

		--[[
		--象征性的弹个面板 让玩家看看...
		hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_GameDataIllegalTip3"],{
			font = hVar.FONTC,
			ok = function()
			end,
		})
		--]]
		return 1
	end
	return 0
end

--检测参数ID 的道具是否需要实体
hApi.CheckEntityItem = function(itemID)
	for i = 1,#hVar.NO_ENTITY_ITEM do
		if hVar.NO_ENTITY_ITEM[i][1] == itemID then
			if hVar.NO_ENTITY_ITEM[i][2] == 1 then
				return 1
			else
				return 2
			end
		end
	end
	return 0
end

--检测各种宝箱是否达到购买上限 目前都是99 
local _buyItemMaxN = 99
hApi.CheckEntityItemMaxN = function(itemID,n)
	if itemID == 9006 and type(n) == "number" then
		if n > _buyItemMaxN -1 then return 1 end
	elseif itemID == 9005 and type(n) == "number" then
		if n > _buyItemMaxN -1 then return 1 end
	elseif itemID == 9004 and type(n) == "number" then
		if n > _buyItemMaxN -1 then return 1 end
	end
	return 0
end

--如果有野外生物需要加入的话调用这个接口产生对话
hApi.InitCreepJoinTalk = function(oUnit,tJoinTeam,NeedPay)
	local uId = tJoinTeam[1][1]
	local uIdH = oUnit.data.id
	local sUnitName = ""
	local tResCost = hApi.NumTable(#hVar.UNIT_PRICE_DEFINE)
	local vTalk = {
		id = {uId,oUnit.data.id},
	}
	vTalk.func = {
		["ShowPrice"] = function(tFunc)
			local NeedResource = 0
			for i = 1,#tResCost do
				if tResCost[i]>0 then
					NeedResource = 1
					break
				end
			end
			--需要资源才显示这个
			if NeedResource==1 then
				tFunc.GetFrm()
				local oFrm = tFunc.GetFrm()
				local x,y = oFrm.childUI["talk"].data.x,oFrm.childUI["talk"].data.y
				local oNode = tFunc.AddUIEx(hUI.node:new({
					parent = oFrm.handle._n,
					x = x,
					y = y-86,
					child = {
						{
							__UI = "label",
							__NAME = "resRequire",
							align = "LC",
							font = hVar.FONTC,
							text = hVar.tab_string["__TEXT__NEED_RESOURCE__"],
							size = oFrm.childUI["talk"].data.size,
						},
					},
				}))
				local iconX = oNode.childUI["resRequire"].handle.s:getContentSize().width+16
				for i = 1,#tResCost do
					local nCost = tResCost[i]
					local resType = hVar.UNIT_PRICE_DEFINE[i]
					if nCost>0 and resType then
						local curX = iconX
						iconX = iconX + 72
						if resType==hVar.RESOURCE_TYPE.GOLD or resType==hVar.RESOURCE_TYPE.FOOD then
							iconX = iconX + 32
						end
						oNode.childUI["resIcon"..i] = hUI.image:new({
							parent = oNode.handle._n,
							model = hVar.RESOURCE_ART[resType].icon,
							x = curX,
							w = 32,
							h = 32,
							smartWH = 1,
						})
						oNode.childUI["resVal"..i] = hUI.label:new({
							parent = oNode.handle._n,
							font = "numWhite",
							x = curX + (iconX-curX)/2,
							size = 18,
							align = "MC",
							text = tostring(nCost),
						})
						if hGlobal.LocalPlayer:getresource(resType)<nCost then
							oNode.childUI["resVal"..i].handle.s:setColor(ccc3(255,0,0))
						end
					end
				end
			end
		end,
	}
	for i = 1,#tJoinTeam do
		local id,num = tJoinTeam[i][1],tJoinTeam[i][2]
		if hVar.tab_unit[id] then
			sUnitName = sUnitName..(hVar.tab_stringU[id][1] or "unit_"..id).."("..num..")"
			if i~=#tJoinTeam then
				sUnitName = sUnitName..","
			end
			if NeedPay==1 and hVar.tab_unit[id].price then
				for n = 1,#tResCost do
					tResCost[n] = tResCost[n] + (hVar.tab_unit[id].price[n] or 0)*num
				end
			end
		end
	end
	vTalk.selection = {
		["yes"] = function(tFunc)
			vTalk[#vTalk+1] = "@L1:1@"
			for i = 1,#tResCost do
				local nCost = tResCost[i]
				local resType = hVar.UNIT_PRICE_DEFINE[i]
				if nCost>0 and hGlobal.LocalPlayer:getresource(resType)<nCost then
					vTalk[#vTalk+1] = hVar.tab_string["__TEXT__JOIN_FAIL_NEED_MORE_RESOURCE__"]
					return
				end
			end
			if oUnit:teamaddunit(tJoinTeam)~=hVar.RESULT_SUCESS then
				vTalk[#vTalk+1] = hVar.tab_string["__TEXT__JOIN_FAIL_TEAM_FULL__"]
				return
			end
			--成功加入了队伍
			vTalk[#vTalk+1] = hVar.tab_string["__TEXT__CREEP_JOIN_SUCESS__"]
			hApi.PlaySound("pay_gold")
			for i = 1,#tResCost do
				local nCost = tResCost[i]
				local resType = hVar.UNIT_PRICE_DEFINE[i]
				if nCost>0 then
					hGlobal.LocalPlayer:addresource(resType,-1*nCost)
				end
			end
		end,
		["no"] = function(tFunc)
			
		end,
	}
	local sJoinText = string.gsub(hVar.tab_string["__TEXT__CREEP_WANT_JOIN__"],"#NAME#",sUnitName)
	local tTokenTalk = {
		"#",
		"@L1:1@",
		"@R1:2@",
		"@select:2:$__YesOrNo@",
		"yes",
		"no",
		"@LoadFunc:ShowPrice@",
		sJoinText,
	}
	hApi.AnalyzeTalk(oUnit,oUnit,tTokenTalk,vTalk)
	return vTalk
end

--检测地图名字 是否满足 手机版UI 需求 如 选择地图VIP娱乐地图 
hApi.CheckMapNameIsPhoneCondition = function(MapName)
	for i = 1,#hVar.PHONE_Legal_MapName do
		if MapName == hVar.PHONE_Legal_MapName[i] then
			return 1
		end
	end
	return 0 
end

--根据战报返回进入战场时候的每个兵种等级的单位个数以及死亡个数 
-- {
--	[1] = {10,5}	--1级兵进入战场10个，死亡5个
--	[2] = {20,20}	--2级兵进入20个，死亡20个
-- }
hApi.CountUnitLvLost = function(oWorld,oPlayer,lostTeam)
	local nMyOwner = oPlayer.data.playerId
	local tMyHeroIndex = {}
	local nHeroCount = 0
	local nHeroDeadCount = 0
	local nMyArmyPower = 0
	local nMyArmyLostPower = 0

	--先从日志中找到英雄入场信息
	for i = 1,oWorld.__LOG.i do
		local v = oWorld.__LOG[i]
		if v.key=="hero_round1" and v.unit.owner==nMyOwner and v.unit.indexOfTeam~=0 then
			tMyHeroIndex[v.unit.indexOfTeam] = 1
			nHeroCount = nHeroCount + 1
		end
	end

	--统计我方部队总战斗力
	for i = 1,oWorld.__LOG.i do
		local v = oWorld.__LOG[i]
		if v.key=="EnterBattle" and v.unit.owner==nMyOwner then
			if type(v.team)=="table" then
				for n = 1,#v.team do
					if v.team[n]~=0 then
						local id,num = v.team[n][1],v.team[n][2]
						if hVar.tab_unit[id] and hVar.tab_unit[id].type==hVar.UNIT_TYPE.UNIT then
							nMyArmyPower = nMyArmyPower + hApi.PVPGetScoreByUnitID(id)*num
						end
					end
				end
			end
			break
		end
	end

	--统计英雄死亡,单位损失信息
	local tMyArmyLostCount = {}
	for i = 1,oWorld.__LOG.i do
		local v = oWorld.__LOG[i]
		if (v.key=="unit_damaged" or v.key=="unit_healed" or v.key=="unit_killed") and v.target.owner==nMyOwner and v.target.indexOfTeam~=0 then
			if v.key=="unit_killed" then
				if tMyHeroIndex[v.target.indexOfTeam]==1 then
					nHeroDeadCount = nHeroDeadCount + 1
				end
			elseif v.key=="unit_damaged" then
				if tMyHeroIndex[v.target.indexOfTeam]~=1 and v.lost>0 then
					tMyArmyLostCount[v.target.id] = (tMyArmyLostCount[v.target.id] or 0) + v.lost
				end
			elseif v.key=="unit_healed" then
				if tMyHeroIndex[v.target.indexOfTeam]~=1 and v.revive>0 then
					tMyArmyLostCount[v.target.id] = (tMyArmyLostCount[v.target.id] or 0) - v.revive
				end
			end
		end
	end
	for id,num in pairs(tMyArmyLostCount)do
		nMyArmyLostPower = nMyArmyLostPower + hApi.PVPGetScoreByUnitID(id)*num
	end
	
	local nMyArmyLostPec = 0
	if nMyArmyPower>0 then
		nMyArmyLostPec = hApi.NumBetween(math.floor(nMyArmyLostPower*100/nMyArmyPower),0,100)
	end
	
	return nHeroCount,nHeroDeadCount,nMyArmyLostPec
end

--根据战报分析出 英雄进入战场的总血量，以及离开战场时候的剩余血量
hApi.CalcHeroMaxHPAndLastHP = function(oWorld,oPlayer)
	local nMyOwner = oPlayer.data.playerId
	local tMyHeroIndex = {}
	local nMyHeroMxHp = 0
	local nMyHeroMxMp = 0
	--先从日志中找到英雄初始血量和魔法值表
	for i = 1,oWorld.__LOG.i do
		local v = oWorld.__LOG[i]
		if v.key=="hero_round1" and v.unit.owner==nMyOwner and v.unit.indexOfTeam~=0 then
			tMyHeroIndex[v.unit.indexOfTeam] = 1
			nMyHeroMxHp = nMyHeroMxHp + v.unit.mxhp
			nMyHeroMxMp = nMyHeroMxMp + v.unit.mxmp
		end
	end
	
	local nMyHeroHp = nMyHeroMxHp
	local nMyHeroMp = nMyHeroMxMp

	--计算伤害和治疗过程所扣除的英雄血量和魔法值
	for i = 1,oWorld.__LOG.i do
		local v = oWorld.__LOG[i]
		if v.key=="hero_mana" then
			if v.unit.owner==nMyOwner and tMyHeroIndex[v.unit.indexOfTeam]==1 then
				nMyHeroMp = nMyHeroMp - v.manacost
			end
		elseif v.key=="hero_damaged" or v.key=="hero_healed" then
			if v.target.owner==nMyOwner and tMyHeroIndex[v.target.indexOfTeam]==1 then
				nMyHeroHp = nMyHeroHp - v.dhp
			end
		end
	end

	local nMyHpLostPec = 0
	local nMyMpLostPec = 0

	if nMyHeroMxHp>0 then
		nMyHpLostPec = hApi.NumBetween(math.floor((nMyHeroMxHp-nMyHeroHp)*100/nMyHeroMxHp),0,100)
	end

	if nMyHeroMxMp>0 then
		nMyMpLostPec = hApi.NumBetween(math.floor((nMyHeroMxMp-nMyHeroMp)*100/nMyHeroMxMp),0,100)
	end
	return nMyHpLostPec,nMyMpLostPec,nMyHeroMxHp,nMyHeroMxMp
end

--返回战斗过程中造成的总伤害值，以及治疗值
hApi.CountDPSAndHPS = function(oWorld,oPlayer)
	local hps = 0		--总治疗量
	local dps = 0		--总伤害

	local hps_over = 0	--实际造成的治疗
	local dps_over = 0	--实际造成的伤害

	local Max_hps = 0	--本局造成的最大治疗
	local Max_dps = 0	--本局造成的最大伤害

	local nOwner = oPlayer.data.playerId
	for i = 1,oWorld.__LOG.i do
		local v = oWorld.__LOG[i]
		--统计 对部队 造成的 HPS
		if (v.key=="hero_healed" or v.key=="unit_healed") and v.unit.owner==nOwner and v.id ~= 1 then
			local nHeal = -1*v.dmg
			hps = hps + nHeal
			hps_over = hps_over - v.dhp
			if nHeal > Max_hps then
				Max_hps = nHeal
			end
		end

		--统计 对敌方部队造成的 DPS
		if (v.key=="hero_damaged" or v.key=="unit_damaged") and v.unit.owner==nOwner and v.id ~= 1 then
			dps = dps + v.dmg
			dps_over = dps + v.dhp

			if v.dmg > Max_dps then
				Max_dps = v.dmg
			end
		end
	end

	return dps,dps_over,Max_dps,hps,hps_over,Max_hps
end

hApi.CountKillAndLost = function(oWorld,oPlayer)
	local lostTemp = {}
	local killTemp = {}
	local idx = nil
	local BattlefieldType = 0
	local Target = 0
	local nStar = 0
	local nScore = 0
	local IsSurrender = 0
	if oPlayer==hGlobal.player[0] and hGlobal.player[-1]~=nil then
		oPlayer = hGlobal.player[-1]	--如果是玩家0，那么在这里转换为玩家-1，因为中立玩家在战场上的单位都被视作玩家-1的（玩家0的单位在战场上会有结盟判断的问题）
	end
	for i = 1,oWorld.__LOG.i do
		local v = oWorld.__LOG[i]
		--死亡的士兵(英雄因为比较特殊放在另外的地方统计)
		if v.key=="unit_damaged" and v.target.indexOfTeam~=0 then
			local tabU = hVar.tab_unit[v.target.id]
			if tabU then
				local a = oPlayer:allience(hGlobal.player[v.target.owner])
				if a==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
					if v.lost>0 then
						lostTemp[v.target.id] = (lostTemp[v.target.id] or 0) + v.lost
					end
				elseif a==hVar.PLAYER_ALLIENCE_TYPE.ENEMY then
					idx = idx or v.target.id
					if v.lost>0 then
						killTemp[v.target.id] = (killTemp[v.target.id] or 0) + v.lost
					end
				end
			end
		end
		
		--是攻城战
		if v.key == "Town" then
			BattlefieldType = v.Town.ID
		end
		
		--认输
		if v.key == "hero_surrender" then
			if oPlayer.data.playerId == v.player then
				IsSurrender = 1
				lostTemp[v.unit.id] = 1
				for k,v in pairs(v.team) do
					if v ~= 0 then
						if lostTemp[v[1]] == nil then
							lostTemp[v[1]] = v[2]
						elseif type(lostTemp[v[1]]) == "number" then 
							lostTemp[v[1]] = v[2]
						end
					end
				end
			else
				killTemp[v.unit.id] = 1
				for k,v in pairs(v.team) do
					if v ~= 0 then
						if killTemp[v[1]] == nil then
							killTemp[v[1]] = v[2]
						elseif type(killTemp[v[1]]) == "number" then 
							killTemp[v[1]] = v[2]
						end
					end
				end
			end
		end
		
		if v.key == "AtkTarget" then
			Target = hClass.unit:find(v.target.objectID)
		end
		
		if v.key=="battle_result" then
			nStar = v.star
			nScore = v.score
		end
	end
	
	for i = 1,oWorld.__LOG.i do
	--把通过治疗复活的单位从损失列表中移除
		local v = oWorld.__LOG[i]
		if v.key=="unit_healed" then
			for k,v1 in pairs(lostTemp) do
				if k == v.target.id then
					lostTemp[k] = v1 - v.revive
				end
			end
		end
	end

	--统计英雄死亡
	for i = 1,oWorld.__LOG.i do
		local v = oWorld.__LOG[i]
		--死亡的英雄
		if v.key=="unit_killed" and v.target.indexOfTeam~=0 and v.target.hero==1 then
			local a = oPlayer:allience(hGlobal.player[v.target.owner])
			if a==hVar.PLAYER_ALLIENCE_TYPE.OWNER then
				lostTemp[v.target.id] = 1
			elseif a==hVar.PLAYER_ALLIENCE_TYPE.ENEMY then
				killTemp[v.target.id] = 1
			end
		end
	end

	local lostUnits = {}
	for k,v in pairs(lostTemp)do
		if v > 0 then
			lostUnits[#lostUnits+1] = {k,v}
		end
	end
	local killUnits = {}
	for k,v in pairs(killTemp)do
		killUnits[#killUnits+1] = {k,v}
	end
	
	return idx,lostUnits,killUnits,IsSurrender,oWorld.data.roundcount,BattlefieldType,Target,nStar,nScore
end

hApi.GetBFHeroID = function(oWorld,nOwner)
	local tTemp = {}
	for i = 1,oWorld.__LOG.i do
		local v = oWorld.__LOG[i]
		if v.key=="EnterBattle" and v.unit.owner==nOwner then
			for idx = 1,#v.team do
				local t = v.team[idx]
				if type(t)=="table" then
					local tabU = hVar.tab_unit[t[1]]
					if tabU and tabU.type==hVar.UNIT_TYPE.HERO then
						tTemp[#tTemp+1] = tostring(t[1])..","
					end
				end
			end
			break
		end
	end
	if #tTemp>0 then
		return table.concat(tTemp)
	else
		return "0,"
	end
end

hApi.GetPlayerBFDetail = function(oWorld,oPlayer)
	local nMyOwner = oPlayer.data.playerId
	local tTemp = {}
	local tArmy = {}
	for i = 1,oWorld.__LOG.i do
		local v = oWorld.__LOG[i]
		if v.key=="EnterBattle" and v.unit.owner==nMyOwner then
			for i = 1,#v.tactics do
				local t = v.tactics[i]
				if type(t)=="table" then
					tTemp[#tTemp+1] = "t|"..t[1].."|"..t[2]..","
				end
			end
			for i = 1,#v.team do
				local t = v.team[i]
				if type(t)=="table" then
					tArmy[i] = {t[1],t[2],0,0}	--id,num,技能施放次数,攻击次数
				else
					tArmy[i] = 0
				end
			end
			break
		end
	end
	for i = 1,oWorld.__LOG.i do
		local v = oWorld.__LOG[i]
		if v.key=="cast_skill" then
			if v.unit.owner==nMyOwner then
				local tUnit = tArmy[v.unit.indexOfTeam]
				if type(tUnit)=="table" then
					if v.IsCast==1 then
						tUnit[3] = tUnit[3] + 1
					elseif v.IsAttack==1 then
						tUnit[4] = tUnit[4] + 1
					end
				end
			end
		elseif v.key=="hero_round1" then
			if v.unit.owner==nMyOwner then
				local tUnit = tArmy[v.unit.indexOfTeam]
				if type(tUnit)=="table" then
					--记录英雄血量
					tUnit[2] = v.unit.mxhp.."|"..v.unit.lea.."|"..v.unit.led.."|"..v.unit.str.."|"..v.unit.int.."|"..v.unit.con
				end
			end
		end
	end
	for i = 1,#tArmy do
		local v = tArmy[i]
		if type(v)=="table" then
			local tabU = hVar.tab_unit[v[1]]
			if tabU then
				if tabU.type==hVar.UNIT_TYPE.HERO then
					tTemp[#tTemp+1] = "h|"..v[1].."|"..v[2].."|"..v[3].."|"..v[4]..","
				else
					tTemp[#tTemp+1] = "u|"..v[1].."|"..v[2].."|"..v[3].."|"..v[4]..","
				end
			end
		end
	end
	if #tTemp>0 then
		return "army:{"..table.concat(tTemp).."};"
	else
		return ""
	end
end

hApi.PVPGetLevelByExp = function(nExp)
	for i = 1,10 do
		if nExp > 0 and nExp <hVar.PVPExp2Lv[i] then
			return i
		end
	end
	return 1
end

hApi.GetItemRequire = function(nItemID,sRequire)
	local tabI = hVar.tab_item[nItemID]
	if tabI and tabI.require then
		for i = 1,#tabI.require do
			local v = tabI.require[i]
			if v[1]==sRequire then
				return v[2]
			end
		end
	end
	return 0
end

local __TOKEN__Ret = {}
hApi.GetItemAttrRequire = function(nItemID)
	local r
	local tabI = hVar.tab_item[nItemID]
	if tabI and tabI.require then
		for i = 1,#tabI.require do
			local v = tabI.require[i]
			if hVar.HERO_ATTR_KEY[v[1]] then
				if r==nil then
					r = {}
				end
				r[#r+1] = {v[1],v[2]}
			end
		end
	end
	return r or __TOKEN__Ret
end

--产生随机强化属性
hApi.RandItemEnhance = function(itemID)
	local itemLv = (hVar.tab_item[itemID].itemLv or 1)
	local itemType = hVar.tab_item[itemID].type

	for i = 1,#hVar.ItemEnhanceType do
		if itemType == hVar.ItemEnhanceType[i][1] then
			local r = hApi.random(1,#hVar.ItemEnhanceType[i][2])
			return hVar.ItemEnhanceType[i][2][r]
		end
	end
	return nil
end

----锻造装备接口
--hApi.ForgeItem = function(oHero,vOrderId,tradeid)
--	if type(vOrderId) ~= "table" then return end
--	local fromType = vOrderId[1]
--	local fromIndex = vOrderId[2]
--	local tPlayerData = LuaGetPlayerData()
--	
--	if type(oHero)~="table" then
--		--不存在发布命令的英雄
--		_DEBUG_MSG("[LUA WARNING]无英雄的锻造命令禁止处理")
--		return false
--	elseif oHero.data.HeroCard~=1 and fromType~="playerbag" then
--		_DEBUG_MSG("[LUA WARNING]无英雄卡片的英雄只能对玩家背包中的物品进行锻造")
--		return false
--	elseif type(tPlayerData.mat)~="table" then
--		--玩家的材料表不存在
--		_DEBUG_MSG("[LUA WARNING]玩家材料表不存在，无法锻造")
--		return false
--	end
--
--	local oItem = oHero:getbagitem(fromType,fromIndex)
--	if oItem and type(oItem[hVar.ITEM_DATA_INDEX.SLOT])=="table" and type(oItem[hVar.ITEM_DATA_INDEX.SLOT][1])=="number" and oItem[hVar.ITEM_DATA_INDEX.SLOT][1]>0 then
--		local nEnhanceCount = 0
--		local itemID = oItem[hVar.ITEM_DATA_INDEX.ID]
--		local itemLv = hVar.tab_item[itemID].itemLv or 1
--		local itemMat = hVar.ITEMLEVEL[itemLv].DEPLETE
--
--		--加入判断玩家材料是否够 材料不够则不能锻造
--		for i = 1,3 do
--			local mat = LuaGetPlayerMaterial(i)
--			local nmat = itemMat[i] or 0
--			if mat < nmat then
--				return 
--			end
--		end
--
--		local tRecordEnhanceID = {}
--		local tTempAttr = {}
--		local IsMeetRequire = 0
--		--如果是身上的装备，那么先记录一下锻造之前的属性
--		if fromType=="equip" then
--			if hApi.IsAttrMeetEquipRequire(oHero, oHero.attr,oItem[hVar.ITEM_DATA_INDEX.ID])==1 then
--				IsMeetRequire = 1
--				hApi.GetEquipmentAttr(oItem[hVar.ITEM_DATA_INDEX.ID],oItem[hVar.ITEM_DATA_INDEX.SLOT],tTempAttr,-1)
--			end
--		end
--		for i = 2,#oItem[hVar.ITEM_DATA_INDEX.SLOT] do
--			if oItem[hVar.ITEM_DATA_INDEX.SLOT][i] ~= 0 then
--				tRecordEnhanceID[#tRecordEnhanceID+1] = oItem[hVar.ITEM_DATA_INDEX.SLOT][i]
--			end
--		end
--		for i = 2,#oItem[hVar.ITEM_DATA_INDEX.SLOT] do
--			if oItem[hVar.ITEM_DATA_INDEX.SLOT][i] == 0 then
--				local nEnhanceID = hApi.RandItemEnhance(itemID)
--				if type(nEnhanceID)=="number" and nEnhanceID>0 then
--					nEnhanceCount = nEnhanceCount + 1
--					oItem[hVar.ITEM_DATA_INDEX.SLOT][i] = nEnhanceID
--					--设置玩家表中的材料数
--					
--					for n = 1,#tPlayerData.mat do
--						LuaSetPlayerMaterial(n,LuaGetPlayerMaterial(n) - (itemMat[n] or 0))
--						
--					end
--					SendCmdFunc["Add_forged_mat_val"](luaGetplayerDataID(),0,(itemMat[1] or 0),(itemMat[2] or 0),(itemMat[3] or 0))
--					
--					--设置锻造次数
--					local new_Key_ForgedCount = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."forged")
--					if type(oItem[hVar.ITEM_DATA_INDEX.UNKNOW]) == "number" then
--						oItem[hVar.ITEM_DATA_INDEX.UNKNOW] = oItem[hVar.ITEM_DATA_INDEX.UNKNOW] + 1
--					elseif oItem[hVar.ITEM_DATA_INDEX.UNKNOW] == nil or type(oItem[hVar.ITEM_DATA_INDEX.UNKNOW]) ~= "number" then
--						oItem[hVar.ITEM_DATA_INDEX.UNKNOW] = 1
--					end
--					
--					xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."forged",new_Key_ForgedCount+1)
--					
--					
--					--LuaAddPlayerCountVal("forged",nil,1)
--					hGlobal.event:event("LocalEvent_Phone_SetPlayMatVal",g_curPlayerName,hVar.OPERATE_TYPE.HERO_FORGEITEM)
--					hGlobal.event:event("LocalEvent_phone_afterForg",oHero,{itemID,tRecordEnhanceID,{nEnhanceID}})
--					
--					SendCmdFunc["send_forged_finish"](luaGetplayerDataID(),4,tradeid,tostring(nEnhanceID),4)
--				else
--					_DEBUG_MSG("[LUA WARNING]锻造失败，没有出现可用的锻造属性")
--				end
--				break
--			end
--		end
--
--		--如果 rewardEx 的最后一项 为0 则解锁道具 否则都设置道具为 锁定状态
--		if oItem[hVar.ITEM_DATA_INDEX.SLOT][#oItem[hVar.ITEM_DATA_INDEX.SLOT]]==0 then
--			hApi.SetItemForgedLock(oItem,0)
--		else
--			hApi.SetItemForgedLock(oItem,1)
--		end
--		--如果成功锻造
--		if nEnhanceCount>0 then
--			local IsUpdateAttr = 0
--			if fromType=="equip" then
--				IsUpdateAttr = 1
--				if IsMeetRequire==1 then
--					hApi.GetEquipmentAttr(oItem[hVar.ITEM_DATA_INDEX.ID],oItem[hVar.ITEM_DATA_INDEX.SLOT],tTempAttr,1)
--				end
--				if #tTempAttr>0 then
--					oHero:loadattr(tTempAttr)
--				end
--			end
--			oHero:updatebag({{fromType,fromIndex}})
--			hGlobal.event:call("Event_HeroSortItem",oHero,IsUpdateAttr,hVar.OPERATE_TYPE.HERO_FORGEITEM)
--			return true
--		end
--	end
--	return false
--	
--end

--重铸装备接口
hApi.RecastItem = function(oHero,vOrderId)
	if type(vOrderId) ~= "table" then return end

	local fromType = vOrderId[1]
	local fromIndex = vOrderId[2]
	local RecastTable = vOrderId[3]
	local tPlayerData = LuaGetPlayerData()

	if type(oHero)~="table" then
		--不存在发布命令的英雄
		_DEBUG_MSG("[LUA WARNING]无英雄的重铸命令禁止处理")
		return false
	elseif oHero.data.HeroCard~=1 and fromType~="playerbag" then
		_DEBUG_MSG("[LUA WARNING]无英雄卡片的英雄只能对玩家背包中的物品进行重铸")
		return false
	elseif type(tPlayerData.mat)~="table" then
		--玩家的材料表不存在
		_DEBUG_MSG("[LUA WARNING]玩家材料表不存在，无法锻造")
		return false
	end
	--重铸装备栏中的道具
	local oItem = oHero:getbagitem(fromType,fromIndex)
	if oItem and type(oItem[hVar.ITEM_DATA_INDEX.SLOT])=="table" and type(oItem[hVar.ITEM_DATA_INDEX.SLOT][1])=="number" and oItem[hVar.ITEM_DATA_INDEX.SLOT][1]>0 then
		local tTempAttr = {}
		local IsMeetRequire = 0
		local IsUpdateAttr = 0
		--如果是身上的装备，那么先记录一下锻造之前的属性
		if fromType=="equip" then
			IsMeetRequire = hApi.IsAttrMeetEquipRequire(oHero, oHero.attr,oItem[hVar.ITEM_DATA_INDEX.ID])
			if IsMeetRequire==1 then
				hApi.GetEquipmentAttr(0,oItem[hVar.ITEM_DATA_INDEX.SLOT],tTempAttr,-1)
			end
		end
		if RecastTable == nil then
			--全部重铸流程
			for i = 2,oItem[hVar.ITEM_DATA_INDEX.SLOT][1]+1 do
				oItem[hVar.ITEM_DATA_INDEX.SLOT][i] = 0
			end
		else
			--锁孔重铸流程
			for i = 1,#RecastTable do
				if RecastTable[i]+1 >= 2 and RecastTable[i]+1 <= oItem[hVar.ITEM_DATA_INDEX.SLOT][1]+1 then
					oItem[hVar.ITEM_DATA_INDEX.SLOT][RecastTable[i]+1] = 0
				end
			end
			--记得把保留的属性加回去
			if IsMeetRequire==1 then
				hApi.GetEquipmentAttr(0,oItem[hVar.ITEM_DATA_INDEX.SLOT],tTempAttr,1)
			end
		end
		--移除重铸掉的属性
		if #tTempAttr>0 then
			IsUpdateAttr = 1
			oHero:loadattr(tTempAttr)
		end
		oHero:updatebag({{fromType,fromIndex}})
		
		hGlobal.event:event("LocalEvent_afterRecast",g_curPlayerName)
		hGlobal.event:call("Event_HeroSortItem",oHero,IsUpdateAttr,hVar.OPERATE_TYPE.HERO_RECASTITEM)
		return true
	end
	return false
end

--分解装备
hApi.RecastItemDecomposeItem = function(oHero,vOrderId)
	if type(vOrderId) ~= "table" then return end
	local fromType = vOrderId[1]
	local case = type(vOrderId[2])
	local tPlayerData = LuaGetPlayerData()
	
	if type(oHero)~="table" then
		--不存在发布命令的英雄
		_DEBUG_MSG("[LUA WARNING]无英雄的分解命令禁止处理")
		return false
	--elseif oHero.data.HeroCard~=1 and fromType~="playerbag" then
		--可以分解，但是不给东西
		--_DEBUG_MSG("[LUA WARNING]无英雄卡片的英雄只能对玩家背包中的物品进行分解")
		--return false
	elseif type(tPlayerData.mat)~="table" then
		--玩家的材料表不存在
		_DEBUG_MSG("[LUA WARNING]玩家材料表不存在，无法分解")
		return false
	end

	if case=="table" then
		local val = {}
		local nDecomposeCount = 0
		for i = 1,#vOrderId[2] do
			local fromIndex = vOrderId[2][i]
			local result,itemID,_,oItem = oHero:shiftitem(fromType,fromIndex,"decompose",1)
			if result==hVar.RESULT_SUCESS and hVar.tab_item[itemID] and type(oItem)=="table" then
				nDecomposeCount = nDecomposeCount + 1
				local itemLv = (hVar.tab_item[itemID].itemLv or 1)
				LuaAddDeleteItemCount(itemLv,1,itemID)
				if type(oItem[hVar.ITEM_DATA_INDEX.PICK])=="table" and oItem[hVar.ITEM_DATA_INDEX.PICK][2]~=-1 then
					--限时道具分解后不能获得任何材料
				elseif oHero.data.HeroCard~=1 and fromType~="playerbag" then
					--不拥有卡片的英雄分解任何玩家背包以外的装备不给材料
				else
					--一般道具分解，产生随机资源
					hApi.GetMatrialByDecomposeItem(oItem,val)
				end
			end
		end
		if nDecomposeCount>0 then
			for i = 1,#tPlayerData.mat do
				LuaSetPlayerMaterial(i,LuaGetPlayerMaterial(i) + (val[i] or 0))
			end
			LuaSaveHeroCard("DecomposeItem")
			hGlobal.event:event("LocalEvent_Phone_SetPlayMatVal",g_curPlayerName,hVar.OPERATE_TYPE.HERO_DECOMPOSEITEM,val)
			return true
		end
	elseif case=="number" then
		local val = {}
		local fromIndex = vOrderId[2]
		local result,itemID,_,oItem = oHero:shiftitem(fromType,fromIndex,"decompose",1)
		if result==hVar.RESULT_SUCESS and hVar.tab_item[itemID] and type(oItem)=="table" then
			local itemLv = (hVar.tab_item[itemID].itemLv or 1)
			LuaAddDeleteItemCount(itemLv,1,itemID)
			if type(oItem[hVar.ITEM_DATA_INDEX.PICK])=="table" and oItem[hVar.ITEM_DATA_INDEX.PICK][2]~=-1 then
				--限时道具分解后不能获得任何材料
			elseif oHero.data.HeroCard~=1 and fromType~="playerbag" then
				--不拥有卡片的英雄分解任何玩家背包以外的装备不给材料
			else
				--一般道具分解，产生随机资源
				hApi.GetMatrialByDecomposeItem(oItem,val)
			end
			for i = 1,#tPlayerData.mat do
				LuaSetPlayerMaterial(i,LuaGetPlayerMaterial(i) + (val[i] or 0))
			end
			LuaSaveHeroCard("DecomposeItem")
			hGlobal.event:event("LocalEvent_Phone_SetPlayMatVal",g_curPlayerName,hVar.OPERATE_TYPE.HERO_DECOMPOSEITEM,val)
			return true
		end
	end
	return false
end

hApi.GetItemName = function(nItemId)
	if rawget(hVar.tab_stringI,nItemId)~=nil then
		return hVar.tab_stringI[nItemId][1]
	else
		return "item_"..nItemId
	end
end

--产生随机战场背景图
hApi.GetRandomBattlefieldBG = function()
	local n = #hVar.BATTLEFIELD_BG
	local index = hApi.random(1,n)
	return hVar.BATTLEFIELD_BG[index]
end

hApi._add_Bar = function(name,x,y,color,width)
	return {
		__UI = "valbar",
		__NAME = name,
		x = x,
		y = y,
		w = width or 90,
		h = 8,
		align = "LC",
		back = {model = "UI:BAR_S1_ValueBar_BG",x=-2,y=0,w=(width or 90)+4,h=12},
		model = "UI:IMG_S1_ValueBar",
		v = 100,
		max = 100,
	}
end

hApi._add_Label = function(name,text,x,y,scale,align,size)
	return {
		__UI = "label",
		__NAME = name,
		text = text,
		size = size or 28,
		font = hVar.FONTC,
		scale = scale or 0.7,
		x = x,
		y = y,
		align = align or "LC",
	}
end

hApi._add_Val = function(name,font,x,y,text,align,size)
	return {
		__UI = "label",
		__NAME = name,
		text = text or "999/999",
		font = font,
		size = size or 14,
		x = x,
		y = y,
		align = align or "MC",
	}
end

hApi._add_Icon = function(name,model,animation,x,y,width)
	return {
		__UI = "image",
		__NAME = name,
		model = model,
		animation = animation,
		x = x,
		y = y,
		align = "LT",
		w = width or 28,
	}
end

hApi.CreateConf = function(UI,name,align,x,y,xp,yp)
	return function(key,t)
		t.__UI = UI
		t.__NAME = name..key
		t.align = align
		x = x + xp
		y = y + yp
		t.x = x
		t.y = y
		return t
	end
end

hApi.ShowHeroLevelUp = function(oHero)
	hApi.PlaySound("level_up")
	local oUnit = oHero:getunit()
	if oUnit then
		local oWorld = oUnit:getworld()
		if oWorld and oWorld.data.type == "worldmap" then
			local x,y = oUnit:getXY()
			oWorld:addeffect(12,1,nil,x,y)
		end
	end
end

--new zhenkira 2016.3.11
--只通过物品ID 产生宝箱物品列表
hApi.UseChestItem = function(itemID)
	
	--获得奖池
	local typ,ex,val = unpack(hVar.tab_item[itemID].used)
	local rewardlist = {}
	local tempDrop
	if type(val[1])=="table" then
		tempDrop = val[1]
	else
		if hVar.tab_drop[val[1]] then
			tempDrop = hVar.tab_drop[val[1]].td_basic
		else
			local dI = hVar.tab_drop.index[val[1]]
			if dI then
				tempDrop = hVar.tab_drop[dI].td_basic
			end
		end
	end
	
	--遍历奖池产生掉落的道具
	local tempItem = {}
	for i = 1, tempDrop.maxPool do
		local num = tempDrop.dropSetting[i] or 0
		for j = 1, num do
			local pool = tempDrop.pool[i]
			if #pool > 0 then
				local rIdx = hApi.random(1, #pool)
				tempItem[#tempItem + 1] = pool[rIdx]
			end
		end
	end

	--判断道具是否不足8个,则用最低奖池里的道具补满
	if #tempItem < tempDrop.maxDrop then
		for i = 1, tempDrop.maxDrop - #tempItem do
			local pool = tempDrop.pool[1]
			if #pool > 0 then
				local rIdx = hApi.random(1, #pool)
				tempItem[#tempItem + 1] = pool[rIdx]
			end
		end
	end
	
	--重新排列抽出的道具，去掉超过8个的部分
	local temp = {}
	hApi.RandomIndex(#tempItem,tempDrop.maxDrop,temp)

	for i = 1,tempDrop.maxDrop do
		local itemObj = tempItem[temp[i]]
		local itemID = itemObj[1]
		local itemExValueRatio = itemObj[2] or 0
		rewardlist[i] = {ex,itemID,hVar.tab_stringI[itemID][1],0,itemExValueRatio,0,0} --类型，道具ID，道具名字，道具出现的几率，3个可选参数
	end

	return rewardlist
end

--old zhenkira 2016.3.11
--只通过物品ID 产生宝箱物品列表
--hApi.UseChestItem = function(itemID)
--	local typ,ex,val = unpack(hVar.tab_item[itemID].used)
--	local rewardlist = {}
--	local tempDrop
--	if type(val[1])=="table" then
--		tempDrop = val[1]
--	else
--		if hVar.tab_drop[val[1]] then
--			tempDrop = hVar.tab_drop[val[1]]
--		else
--			local dI = hVar.tab_drop.index[val[1]]
--			if dI then
--				tempDrop = hVar.tab_drop[dI]
--			end
--		end
--	end
--
--	local tempItem = {}
--	if #val == 9 then
--		for i = 2,#val do
--			local id = hApi.RandomItemId(tempDrop,val[i][1],val[i][2])
--			if hVar.tab_item[id] then
--				--掉出东西了！
--				tempItem[#tempItem+1] = id
--			else
--				--如果啥都没掉出来的话，掉个等级0的东西给他
--				tempItem[#tempItem+1] = hVar.TokenRandomItem[hApi.random(1,#hVar.TokenRandomItem)]
--			end
--		end
--	end
--	local temp = {}
--	hApi.RandomIndex(#tempItem,8,temp)
--	for i = 1,8 do
--		local itemID = tempItem[temp[i]]
--		rewardlist[i] = {ex,itemID,hVar.tab_stringI[itemID][1],0,0,0,0} --类型，道具ID，道具名字，道具出现的几率，3个可选参数
--	end
--
--	return rewardlist
--end

--判断奖励类型ID 是否合法
hApi.CheckPrizeType = function(prizetype)
	for i = 1,#hVar.LEGALPRIZE_TYPE do
		if prizetype == hVar.LEGALPRIZE_TYPE[i] then
			return 1
		end
	end
	return 0
end

--解析字符串总入口
hApi.UnpackPrizeDataEx = function(str,mode)
	if type(str) ~= "string" then return end

	local itemID,itemNum,coin,score,itemHole,itemLv = 0,1,0,nil,nil,1
	local itemName,GiftTip,GiftTip_Ex= hVar.tab_string["__TEXT_noAppraise"],"",""
	local itemBack,itemModel,giftType = 0,"",0

	--道具类
	if string.find(str,"i:") then
		--装备类道具
		if string.find(str,"h:") then
			itemID = tonumber(string.sub(str,string.find(str,"i:")+2,string.find(str,"n:")-1))
			itemNum = tonumber(string.sub(str,string.find(str,"n:")+2,string.find(str,"h:")-1))
			itemHole = tonumber(string.sub(str,string.find(str,"h:")+2,string.len(str)))
		--锻造材料
		else
			itemID = tonumber(string.sub(str,string.find(str,"i:")+2,string.find(str,"n:")-1))
			itemNum = tonumber(string.sub(str,string.find(str,"n:")+2,string.len(str)))
		end
		itemName = hVar.tab_stringI[itemID][1] or hVar.tab_string["__TEXT_noAppraise"]
		itemLv = hVar.tab_item[itemID].itemLv or 1
		--碎片取碎片icon
		if itemID >= 9300 and itemID <= 9305 then
			itemModel = hVar.tab_item[itemID].chip
		else
			itemModel = hVar.tab_item[itemID].icon
		end
		itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL

		--给道具类的逻辑
		if mode == 1 then
			--如果是装备
			if hVar.tab_item[itemID].type >= 2 and hVar.tab_item[itemID].type <= 7 then
				local rewardEx = -1
				if type(itemHole) == "number" then
					--如果孔数为0 则随机产生孔数字
					if itemHole == 0 then
						local nSlotNum = hApi.CalculateItemRewardEx(itemID)
						rewardEx = hApi.NumTable(nSlotNum+1)
						rewardEx[1] = nSlotNum
					--否则就是指定孔数
					elseif itemHole >= 1 then
						rewardEx = hApi.NumTable(itemHole+1)
						rewardEx[1] = itemHole
					end
				elseif itemHole == nil then
					local itemRulu = hVar.ITEM_ENHANCE_NUM[itemLv]
					local MaxSlot = itemRulu[#itemRulu][2]
					rewardEx = hApi.NumTable(MaxSlot+1)
					rewardEx[1] = MaxSlot
				end
				
				local rs = 0
				rs,_ = LuaAddItemToPlayerBag(itemID,rewardEx)
				if rs == 1 then
					LuaAddGetGiftCount(itemID)
				end
			--如果是锻造材料
			elseif hVar.tab_item[itemID].type == hVar.ITEM_TYPE.PLAYERITEM then
				local matVal = hVar.tab_item[itemID].matVal
				--材料道具 直接增加玩家材料
				if matVal then
					LuaSetPlayerMaterial(matVal[1],LuaGetPlayerMaterial(matVal[1])+matVal[2]*itemNum)
				end
			end
		end
	--游戏币
	elseif string.find(str,"c:") then
		itemID = 27
		coin = tonumber(string.sub(str,3,string.len(str)))
		itemNum = coin
		itemName = hVar.tab_stringI[itemID][1] or hVar.tab_string["__TEXT_noAppraise"]
		itemLv = hVar.tab_item[itemID].itemLv or 1
		itemModel = hVar.tab_item[itemID].icon
		itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL
	--积分
	elseif string.find(str,"s:") then
		itemID = 25
		if hVar.tab_stringI[itemID] == nil then
			hVar.tab_stringI[itemID] = {}
		end
		if hVar.tab_item[itemID] == nil then
			hVar.tab_item[itemID] = {}
		end
		score = tonumber(string.sub(str,3,string.len(str)))
		itemNum = score
		itemName = hVar.tab_stringI[itemID][1] or hVar.tab_string["__TEXT_noAppraise"]
		itemLv = hVar.tab_item[itemID].itemLv or 1
		itemModel = hVar.tab_item[itemID].icon
		itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL
		
		--给给积分
		if mode == 1 then
			LuaAddPlayerScore(score)
		end
	--英雄令
	elseif string.find(str,"h:") then
		itemID = tonumber(string.sub(str,3,string.len(str)))
		itemBack = "UI_frm:slot"
		giftType = 1
		itemName = hVar.tab_stringU[itemID][1]..hVar.tab_string["__TEXT_Card"]
		itemModel = hVar.tab_unit[itemID].icon

		--给英雄令
		if mode == 1 then
			local oHero = hClass.hero:new({
				name = hVar.tab_stringU[itemID][1],
				id = itemID,
				owner = 1,
				unit = nil,
			})
			if mode == nil then
				mode = "BuyHeroCard"
			end
			hGlobal.event:call("LocalEvent_GetHeroCard",oHero,2)
			oHero:del()
		end
	--战术卡
	elseif string.find(str,"b:") then
		itemID = tonumber(string.sub(str,string.find(str,"b:")+2,string.find(str,"n:")-1))
		itemNum = tonumber(string.sub(str,string.find(str,"n:")+2,string.find(str,"l:")-1))
		itemLv =  tonumber(string.sub(str,string.find(str,"l:")+2,string.len(str)))
		GiftTip = hVar.tab_stringT[itemID][itemLv]
		giftType = 2
		itemModel = hVar.tab_tactics[itemID].icon
		itemName = hVar.tab_stringT[itemID][1] or hVar.tab_string["__TEXT_noAppraise"]
		itemName = itemName.." Lv : "..itemLv
		--给战术卡
		if mode == 1 then
			LuaAddPlayerSkillBook(itemID,itemLv,itemNum)
		end
	elseif string.find(str,"w:") then
		local rewardT = hApi.Split(str, ":")
		local unitid = tonumber(rewardT[2]) or 0
		local weaponid = tonumber(rewardT[3]) or 0
		local tabU = hVar.tab_unit[unitid]
		if tabU and tabU.weapon_unit then
			for i = 1,#tabU.weapon_unit do
				local weaponInfo = tabU.weapon_unit[i]
				if weaponInfo.unitId == weaponid then
					local lv = LuaGetHeroWeaponLv(unitid,i)
					if lv == 0 then
						LuaSetHeroWeaponLv(unitid,i, 1)
					end
				end
			end
		end
	end

	GiftTip = hVar.tab_string["__TEXT_GetItem4"].."\n"..hVar.tab_string["["]..itemName..hVar.tab_string["]"]
	return itemID,itemNum,itemName,itemHole,coin,score,itemBack,itemModel,GiftTip,GiftTip_Ex,giftType
end

--解析领奖数据
hApi.UnpackPrizeData = function(prizetype,prizeid,prizecode)
	--print("UnpackPrizeData", prizetype,prizeid,prizecode)
	local itemID,itemNum,coin,score = 0,1,0,nil
	local itemName,GiftTip,GiftTip_Ex,exNum,exY,exG= hVar.tab_string["__TEXT_noAppraise"],"","",nil,nil,nil
	local itemBack,itemModel = 0,""
	local itemHole = nil
	local giftType = 0
	--print(prizecode)
	--针对首冲奖励的解析
	if prizetype == 1030 or prizetype == 1031 or  prizetype == 1032 or prizetype == 1033 or prizetype == 1034 or prizetype == 1035 then
		--如果是新的格式
		if string.find(prizecode,"i:") ~= nil and string.find(prizecode,"s:") then
			local tempState = {}
			for prizecode in string.gfind(prizecode,"([^%;]+);+") do
				tempState[#tempState+1] = prizecode
			end
			itemID = tonumber(string.sub(tempState[1],string.find(tempState[1],"i:")+2,string.len(tempState[1])))
			score = tonumber(string.sub(tempState[2],string.find(tempState[2],"s:")+2,string.len(tempState[2])))
			if  hVar.tab_stringI[itemID] then
				local itemLv = (hVar.tab_item[itemID].itemLv or 1)
				itemName = hVar.tab_stringI[itemID][1] or hVar.tab_string["__TEXT_noAppraise"]
				itemModel = hVar.tab_item[itemID].icon
				itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL
			end
			GiftTip = hVar.tab_string["__TEXT_GetItem1"]..hVar.tab_string["["]..itemName..hVar.tab_string["]"]
		--如果是新的格式2
		elseif string.find(prizecode,"i:") ~= nil and string.find(prizecode,"c:") then
			local tempState = {}
			for prizecode in string.gfind(prizecode,"([^%;]+);+") do
				tempState[#tempState+1] = prizecode
			end
			itemID = tonumber(string.sub(prizecode,string.find(tempState[1],"i:")+2,string.find(tempState[1],"n:")-1))
			itemNum = tonumber(string.sub(prizecode,string.find(tempState[1],"n:")+2,string.len(tempState[1])))
			coin = tonumber(string.sub(tempState[2],string.find(tempState[2],"c:")+2,string.len(tempState[2])))
			if  hVar.tab_stringI[itemID] then
				local itemLv = (hVar.tab_item[itemID].itemLv or 1)
				itemName = hVar.tab_stringI[itemID][1] or hVar.tab_string["__TEXT_noAppraise"]
				itemModel = hVar.tab_item[itemID].icon
				itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL
			end
			GiftTip = hVar.tab_string["__TEXT_GetItem1"]..hVar.tab_string["["]..itemName..hVar.tab_string["]"]
			--print("itemID=", itemID)
			--print("coin=", coin)
		--老格式
		elseif string.find(prizecode,"i:") ~= nil then
			itemID = tonumber(string.sub(prizecode,string.find(prizecode,"i:")+2,string.find(prizecode,"n:")-1))
			itemNum = tonumber(string.sub(prizecode,string.find(prizecode,"n:")+2,string.len(prizecode)))
			if  hVar.tab_stringI[itemID] then
				local itemLv = (hVar.tab_item[itemID].itemLv or 1)
				itemName = hVar.tab_stringI[itemID][1] or hVar.tab_string["__TEXT_noAppraise"]
				itemModel = hVar.tab_item[itemID].icon
				itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL
			end
			GiftTip = hVar.tab_string["__TEXT_GetItem1"]..hVar.tab_string["["]..itemName..hVar.tab_string["]"]
		--如果是新的格式3
		elseif string.find(prizecode,"H:") ~= nil and string.find(prizecode,"c:") then
			local tempState = {}
			for prizecode in string.gfind(prizecode,"([^%;]+);+") do
				tempState[#tempState+1] = prizecode
			end
			itemID = tonumber(string.sub(tempState[1],string.find(tempState[1],"H:")+2,string.len(tempState[1])))
			itemModel = hVar.tab_unit[itemID].icon
			itemNum = 1
			GiftTip = hVar.tab_string["__TEXT_GetItem1"] .. hVar.tab_string["["] .. hVar.tab_stringU[itemID][1] .. hVar.tab_string["]"]
			itemBack = "UI_frm:slot"
			giftType = 1
			coin = tonumber(string.sub(tempState[2],string.find(tempState[2],"c:")+2,string.len(tempState[2])))
			--print("itemID=", itemID)
			--print("coin=", coin)
		--英雄令的奖励
		elseif string.find(prizecode,"H:") then
			local tempState = {}
			for prizecode in string.gfind(prizecode,"([^%;]+);+") do
				tempState[#tempState+1] = prizecode
			end
			--itemID = tonumber(string.sub(prizecode,3,string.len(prizecode)))
			itemID = tonumber(string.sub(tempState[1],string.find(tempState[1],"H:")+2,string.len(tempState[1])))
			itemModel = hVar.tab_unit[itemID].icon
			itemNum = 1
			GiftTip = hVar.tab_string["__TEXT_GetItem1"] .. hVar.tab_string["["] .. hVar.tab_stringU[itemID][1] .. hVar.tab_string["]"]
			itemBack = "UI_frm:slot"
			giftType = 1
		end
		
		
	elseif prizetype == 1201 or prizetype == 1202 then
		--推荐的游戏币奖励
		if string.find(prizecode,"c:") ~= nil then
			coin = tonumber(string.sub(prizecode,3,string.len(prizecode)-1))
		end
		itemModel = "UI:game_coins"
		itemNum = coin
		if prizetype == 1201 then
			GiftTip = hVar.tab_string["recomm_g1info"]
		elseif prizetype == 1202 then
			GiftTip = hVar.tab_string["recomm_g5info"]
		end
		itemName = hVar.tab_string["ios_gamecoin"]
	elseif prizetype == 1203 or prizetype == 1204 then
		itemID = 9006
		itemName = hVar.tab_stringI[itemID][1]
		local itemLv = (hVar.tab_item[itemID].itemLv or 1)
		itemModel = hVar.tab_item[itemID].icon
		itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL
		
		if prizetype == 1203 then
			GiftTip = hVar.tab_string["recomm_g10info"]
		elseif prizetype == 1204 then
			GiftTip = hVar.tab_string["recomm_g20info"]
		end
		
		if string.find(prizecode,"i:") ~= nil and string.find(prizecode,"n:") then
			itemNum = tonumber(string.sub(prizecode,string.find(prizecode,"n:")+2,string.len(prizecode)-1))
		end
	elseif prizetype == 1038 then
		itemID = 9100
		itemName = hVar.tab_stringI[itemID][1]
		local itemLv = (hVar.tab_item[itemID].itemLv or 1)
		itemModel = hVar.tab_item[itemID].icon
		itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL
		GiftTip = hVar.tab_string["__TEXT_Topup_Success_Tip1"]..hVar.tab_string["["]..itemName..hVar.tab_string["]"]
	elseif  prizetype == 1039 or prizetype == 1060 then
		itemID = 25
		itemName = hVar.tab_stringI[itemID][1]
		local itemLv = (hVar.tab_item[itemID].itemLv or 1)
		itemModel = hVar.tab_item[itemID].icon
		itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL
		itemNum = tonumber(prizecode)
		GiftTip = hVar.tab_string["__TEXT_Topup_Success_Tip1"]..hVar.tab_string["["]..itemName..hVar.tab_string["]"]
	elseif prizetype == 9004 or prizetype == 9005 or prizetype == 9006 then
		itemID = tonumber(prizetype)
		itemNum = tonumber(prizecode)
		
		if  hVar.tab_stringI[itemID] then
			local itemLv = (hVar.tab_item[itemID].itemLv or 1)
			itemName = hVar.tab_stringI[itemID][1] or hVar.tab_string["__TEXT_noAppraise"]
			itemModel = hVar.tab_item[itemID].icon
			itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL
		end
		
		GiftTip = hVar.tab_string["__TEXT_GetItem4"].."\n"..hVar.tab_string["["]..itemName..hVar.tab_string["]"]
		
	elseif prizetype == 4 or prizetype == 6 then
		--老格式的道具补偿
		if string.find(prizecode,";") == nil then
			if string.find(prizecode,"i:") ~= nil then
				itemID = tonumber(string.sub(prizecode,string.find(prizecode,"i:")+2,string.find(prizecode,"n:")-1))
				itemNum = tonumber(string.sub(prizecode,string.find(prizecode,"n:")+2,string.len(prizecode)))
				if string.find(prizecode,"h:") ~= nil then
					itemHole = tonumber(string.sub(prizecode,string.find(prizecode,"h:")+2,string.len(prizecode)))
				end
			end
		elseif string.find(prizecode,";") ~= nil then
		--新格式的道具补偿 都用 ; 隔开了
			local tempStr = {}
			for content in string.gfind(prizecode,"([^%;]+);+") do
				tempStr[#tempStr+1] = content
			end
			itemID = tonumber(string.sub(tempStr[1],3,string.len(tempStr[1])))
			itemNum = tonumber(string.sub(tempStr[2],3,string.len(tempStr[2])))
			itemHole = tonumber(string.sub(tempStr[3],3,string.len(tempStr[3])))
		end

		if  hVar.tab_stringI[itemID] then
			local itemLv = (hVar.tab_item[itemID].itemLv or 1)
			itemName = hVar.tab_stringI[itemID][1] or hVar.tab_string["__TEXT_noAppraise"]
			itemModel = hVar.tab_item[itemID].icon
			itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL
		end
		
		GiftTip = hVar.tab_string["__TEXT_GetItem2"].."\n"..hVar.tab_string["["]..itemName..hVar.tab_string["]"]
	--评价奖励
	elseif prizetype == 18 then
		itemModel = "UI:game_coins"
		itemBack = 0
		GiftTip = hVar.tab_stringGIFT[3][1] .. hVar.tab_string["__Reward__"] --"支持游戏奖励"
		
		local tempStr = {}
		for content in string.gfind(prizecode,"([^%;]+);+") do
			tempStr[#tempStr+1] = content
		end
		coin = tonumber(string.sub(tempStr[1],3,string.len(tempStr[1])))
		score = tonumber(string.sub(tempStr[2],3,string.len(tempStr[2])))
	--推荐奖励
	elseif prizetype >=10 and  prizetype ~= 17 and prizetype <= 21 then
		itemModel = "UI:GIFT"
		itemBack = 0
		GiftTip = hVar.tab_string[hVar.SHARTEXT[prizetype]]
		
		local tempStr = {}
		for content in string.gfind(prizecode,"([^%;]+);+") do
			tempStr[#tempStr+1] = content
		end
		coin = tonumber(string.sub(tempStr[1],3,string.len(tempStr[1])))
		score = tonumber(string.sub(tempStr[2],3,string.len(tempStr[2])))
	--新人礼包
	elseif prizetype == 100 then
		itemModel = "UI:game_coins"
		itemBack = 0
		GiftTip = hVar.tab_stringGIFT[2][1] .. hVar.tab_string["__Reward__"] --"新人礼包奖励"
		
		local tempStr = {}
		for content in string.gfind(prizecode,"([^%;]+);+") do
			tempStr[#tempStr+1] = content
		end
		coin = tonumber(string.sub(tempStr[1],3,string.len(tempStr[1])))
		score = tonumber(string.sub(tempStr[2],3,string.len(tempStr[2])))
	--每日奖励
	elseif prizetype == 9 then
		itemModel = "UI:game_coins"
		itemBack = 0
		GiftTip = hVar.tab_stringGIFT[1][1] --"每日奖励"
		
		local tempStr = {}
		for content in string.gfind(prizecode,"([^%;]+);+") do
			tempStr[#tempStr+1] = content
		end
		coin = tonumber(string.sub(tempStr[1],3,string.len(tempStr[1])))
		score = tonumber(string.sub(tempStr[2],3,string.len(tempStr[2])))
	elseif (prizetype >= 2000 and prizetype < 3000 ) or prizetype == 40001 then
		itemID = -1
		--itemModel = "ICON:Imperial_Academy"
		itemModel = "UI:BROADCAST_M"
		if string.find(prizecode,";") then
			GiftTip = string.sub(prizecode,1,string.find(prizecode,";")-1)
			GiftTip_Ex = string.sub(prizecode,string.find(prizecode,";")+1,string.len(prizecode))
		else
			GiftTip = prizecode
			GiftTip_Ex = prizecode
		end
	--红装卷轴
	elseif prizetype == 9999 then
		itemID = 9104
		itemModel = hVar.tab_item[itemID].icon
		itemNum = (tonumber(prizecode) or 1)
		local itemLv = (hVar.tab_item[itemID].itemLv or 1)
		itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL
		GiftTip = hVar.tab_stringI[itemID][2]
		itemName = hVar.tab_stringI[itemID][1]
	elseif prizetype == 4000 and string.find(prizecode,";") then
		itemID = -2
		itemModel = "ICON:Imperial_Academy"
		GiftTip = string.sub(prizecode,1,string.find(prizecode,";")-1)
		GiftTip_Ex = string.sub(prizecode,string.find(prizecode,";")+1,string.find(prizecode,"|")-1)
		--解析总额
		if string.find(prizecode,"M:") then
			_,_,exNum = string.find(prizecode,"M:(%d+);")
		end
		--解析Y坐标
		if string.find(prizecode,"Y:") then
			_,_,exY = string.find(prizecode,"Y:(%d+);")
		end
		--解析档位
		if string.find(prizecode,"G:") then
			exG = string.sub(prizecode,string.find(prizecode,"G:")+2,string.len(prizecode))
		end
	--微信月卡
	elseif prizetype == 5000 then
		if string.find(prizecode,"c:") ~= nil then
			coin = tonumber(string.sub(prizecode,3,string.len(prizecode)-1))
		end
		itemModel = "UI:game_coins"
		itemNum = coin
		GiftTip = hVar.tab_string["__TEXT_GetItem6"]
		itemName = hVar.tab_string["ios_gamecoin"]
	--橙装碎片
	elseif prizetype >= 9300 and prizetype <= 9305 then
		itemID = prizetype
		itemModel = hVar.tab_item[itemID].chip
		itemNum = (tonumber(prizecode) or 1)
		local itemLv = (hVar.tab_item[itemID].itemLv or 1)
		itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL
		GiftTip = hVar.tab_stringI[itemID][7]
		itemName = hVar.tab_stringI[itemID][6]
	--VIP8 的奖励 目前包括1张董卓英雄令 2张战术卡
	elseif prizetype == 6008 then
		if type(prizecode) == "string" then
			--英雄令的奖励
			if string.find(prizecode,"h:") then
				itemID = tonumber(string.sub(prizecode,3,string.len(prizecode)))
				itemModel = hVar.tab_unit[itemID].icon
				itemNum = 1
				GiftTip = hVar.tab_stringU[itemID][4]
				itemBack = "UI_frm:slot"
				giftType = 1
			--战术卡的奖励
			elseif string.find(prizecode,"b:") then
				itemID = tonumber(string.sub(prizecode,3,string.len(prizecode)))
				itemModel = hVar.tab_tactics[itemID].icon
				itemNum = 1
				GiftTip = hVar.tab_stringT[itemID][3]
				giftType = 2
			end
		end
	elseif prizetype == 7000 then
		if type(prizecode) == "string" then
			itemID = 9108
			itemNum = 1
			GiftTip = hVar.tab_stringI[itemID][2]
			itemModel = hVar.tab_item[itemID].icon
			itemName = hVar.tab_stringI[itemID][1]
			giftType = 3
		end
	--战术技能卡
	elseif prizetype == 7 then
		if type(prizecode) == "string" then
			local itemId = tonumber(string.sub(prizecode,string.find(prizecode,"bfs:")+4,string.find(prizecode,"lv:")-1))
			local itemLv = tonumber(string.sub(prizecode,string.find(prizecode,"lv:")+3,string.find(prizecode,"n:")-1))
			local itemNumber = tonumber(string.sub(prizecode,string.find(prizecode,"n:")+2,string.len(prizecode)))
			--实际增加卡牌的流程
			local tLv = itemLv or 0
			if tLv > hVar.TACTIC_LVUP_INFO.maxTacticLv then
				tLv = hVar.TACTIC_LVUP_INFO.maxTacticLv
			end
			local toDebris = 0
			local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO[tLv]
			if tacticLvUpInfo then
				toDebris = tacticLvUpInfo.toDebris or 0
			end
			local debris = (itemNumber or 1) * toDebris
			
			itemID = itemId
			itemModel = hVar.tab_tactics[itemID].icon
			itemName = "Lv:"..itemLv
			itemNum = ""
			itemHole = itemNumber
			
			GiftTip = hVar.tab_string["["].. hVar.tab_stringT[itemID][1].. hVar.tab_string["__Attr_Hint_Lev"] .. itemLv .. hVar.tab_string["]"]
			GiftTip = GiftTip .. "* " .. tostring(itemNumber).. " "
			GiftTip = GiftTip .. hVar.tab_string["__UPGRADEBFSKILL_OR"].. hVar.tab_string["["].. hVar.tab_stringT[itemID][1].. hVar.tab_string["__TEXT_ITEM_TYPE_TACTICDEBRIS"] .. hVar.tab_string["]"] .. "* " .. tostring(debris)
			
			giftType = 2
		end
		
	--英雄令
	elseif prizetype == 8 then
		if type(prizecode) == "string" then
			itemID = tonumber(string.sub(prizecode,string.find(prizecode,"ID:")+3,string.find(prizecode,";")-1))
			itemModel = hVar.tab_unit[itemID].icon
			itemNum = 1
			GiftTip = hVar.tab_stringU[itemID][1]..hVar.tab_string["MyHeroCard"]
			itemBack = "UI_frm:slot"
			giftType = 1
		end
	elseif (prizetype == 20001) then
		local tCmd = hApi.Split(prizecode,";")
		local ranking = tonumber(tCmd[1]) --排名
		local billboardId = tonumber(tCmd[2]) --排行榜id
		local strDate = tCmd[3] --日期
		local reward = {}
		for i = 4, #tCmd do
			reward[#reward + 1] = tCmd[i]
		end
		itemModel = "UI:GIFT"
		--GiftTip = "2016-07-28黄巾试炼第n名奖励" --邮件标题 --language
		local mapName = hVar.BILL_BOARD_MAP[billboardId].mapName
		GiftTip = strDate .. hVar.tab_stringM[mapName][1] .. hVar.tab_string["__TEXT_WORD_DI"] .. ranking .. hVar.tab_string["__TEXT_WORD_MING"] .. hVar.tab_string["__Reward__"] --邮件标题 --language
	elseif (prizetype == 20002) then --推荐人20游戏币领奖
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		for i = 1, #tCmd do
			reward[#reward + 1] = tCmd[i]
		end
		itemModel = "UI:game_coins"
		GiftTip = hVar.tab_string["rec_m_new_2"] --【推荐奖励】作为推荐人，奖励20游戏币。
	elseif (prizetype >= 20003) and (prizetype <= 20007) then --推荐领奖
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		for i = 1, #tCmd do
			reward[#reward + 1] = tCmd[i]
		end
		itemModel = "UI:GIFT"
		GiftTip = hVar.tab_string["rec_m_new_3"] .. hVar.tab_string["__TEXT_WORD_DI"] .. (prizetype - 20002) .. hVar.tab_string["__TEXT_WORD_DANG"] --"【推荐奖励】第x档"
	elseif (prizetype == 20008) or (prizetype == 20009) then --活动领奖
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		exNum = 0
		for i = 2, #tCmd do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and tCmd[i] ~= "" then
				reward[#reward + 1] = tCmd[i]
				exNum = exNum + 1
			end
		end
		itemModel = "UI:GIFT"
		
		--红包显示特别的图标
		--print("红包", string.find(tostring(tCmd[1]), "红包"))
		if (string.find(tostring(tCmd[1]), "红包") ~= nil) then
			itemModel = "UI:hongbao"
		end
		
		if (string.find(tostring(tCmd[1]), "幸运神器锦囊") ~= nil) then
			itemModel = hVar.tab_item[9919].icon
		end
		
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"【活动奖励】"
		--GiftTip = hVar.tab_string["["].. tostring(tCmd[1]) .. hVar.tab_string["]"] --"【活动奖励】"
		GiftTip = tostring(tCmd[1]) --"【活动奖励】"
	elseif (prizetype >= 1900 and prizetype < 2000) then --一次性分享奖励
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		exNum = 0
		for i = 2, #tCmd do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and tCmd[i] ~= "" then
				reward[#reward + 1] = tCmd[i]
				exNum = exNum + 1
			end
		end
		itemModel = "UI:CIRCLE"
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"【活动奖励】"
		local strRewardTitle = ""
		if (prizetype == 1900) then --"首通 桃园结义 分享朋友圈奖励"
			strRewardTitle = hVar.tab_string["__TEXT_ShareSNS_MAP_001"]
		elseif (prizetype == 1901) then --"首通 救援青州 分享朋友圈奖励"
			strRewardTitle = hVar.tab_string["__TEXT_ShareSNS_MAP_002"]
		elseif (prizetype == 1902) then --"首通 剿灭黄巾 分享朋友圈奖励"
			strRewardTitle = hVar.tab_string["__TEXT_ShareSNS_MAP_003"]
		end
		
		--GiftTip = hVar.tab_string["["].. strRewardTitle .. hVar.tab_string["]"] --"【活动奖励】"
		GiftTip = strRewardTitle --"【活动奖励】"
	elseif (prizetype == 20010) then --VIP5一次性奖励
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		local exNum = tonumber(tCmd[1]) or 0
		for i = 1, exNum do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and tCmd[i] ~= "" then
				reward[#reward + 1] = tCmd[i]
			end
		end
		itemModel = "ICON:skill_icon_x11y11"
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"【活动奖励】"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"【VIP】"
	elseif (prizetype == 20011) then --VIP6一次性奖励
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		local exNum = tonumber(tCmd[1]) or 0
		for i = 1, exNum do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and tCmd[i] ~= "" then
				reward[#reward + 1] = tCmd[i]
			end
		end
		itemModel = "icon/portrait/hero_xiaoqiao_s.png"
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"【活动奖励】"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"【VIP】"
	elseif (prizetype == 20012) then --VIP7一次性奖励
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		local exNum = tonumber(tCmd[1]) or 0
		for i = 1, exNum do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and tCmd[i] ~= "" then
				reward[#reward + 1] = tCmd[i]
			end
		end
		itemModel = "ICON:BF"
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"【活动奖励】"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"【VIP】"
	elseif (prizetype == 20013) then --VIP8一次性奖励
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		local exNum = tonumber(tCmd[1]) or 0
		for i = 1, exNum do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and tCmd[i] ~= "" then
				reward[#reward + 1] = tCmd[i]
			end
		end
		--itemModel = "ICON:BF"
		itemModel = "icon/portrait/hero_daqiao_s.png"
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"【活动奖励】"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"【VIP】"
	elseif (prizetype == 20014) then --VIP7一次性奖励2
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		local exNum = tonumber(tCmd[1]) or 0
		for i = 1, exNum do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and tCmd[i] ~= "" then
				reward[#reward + 1] = tCmd[i]
			end
		end
		itemModel = "ICON:skill_icon3_x15y9"
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"【活动奖励】"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"【VIP】"
	elseif (prizetype == 20015) then --VIP8一次性奖励2
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		local exNum = tonumber(tCmd[1]) or 0
		for i = 1, exNum do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and tCmd[i] ~= "" then
				reward[#reward + 1] = tCmd[i]
			end
		end
		--itemModel = "ICON:BF"
		itemModel = "icon/portrait/hero_caiwenji_s.png"
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"【活动奖励】"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"【VIP】"
	elseif (prizetype == 20016) then --vip8一次性奖励3(红妆兑换券*3, 仅限韩国版)
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		local exNum = tonumber(tCmd[1]) or 0
		for i = 1, exNum do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and tCmd[i] ~= "" then
				reward[#reward + 1] = tCmd[i]
			end
		end
		itemModel = "ICON:BF"
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"【活动奖励】"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"【VIP】"
	elseif (prizetype == 20017) then --VIP3一次性奖励
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		local exNum = tonumber(tCmd[1]) or 0
		for i = 1, exNum do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and tCmd[i] ~= "" then
				reward[#reward + 1] = tCmd[i]
			end
		end
		itemModel = "ICON:skill_icon3_x15y9"
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"【活动奖励】"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"【VIP】"
	elseif (prizetype == 20018) then --VIP4一次性奖励
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		local exNum = tonumber(tCmd[1]) or 0
		for i = 1, exNum do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and tCmd[i] ~= "" then
				reward[#reward + 1] = tCmd[i]
			end
		end
		itemModel = "ICON:skill_icon3_x15y9"
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"【活动奖励】"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"【VIP】"
	elseif (prizetype == 20020) then --vip7以上每充2000奖励
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		local exNum = tonumber(tCmd[1]) or 0
		for i = 1, exNum do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and tCmd[i] ~= "" then
				reward[#reward + 1] = tCmd[i]
			end
		end
		itemModel = "ICON:BF"
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"【活动奖励】"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"【VIP】"
	elseif (prizetype == 20028) then --服务器抽卡类奖励
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		exNum = 0
		for i = 2, #tCmd do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and tCmd[i] ~= "" then
				reward[#reward + 1] = tCmd[i]
				exNum = exNum + 1
			end
		end
		itemModel = "icon/item/gift_lv3.png"
		
		--默认图标是紫色箱子，如果里面包含神器，那么替换成金箱子
		--国庆累计消耗10000游戏币活动奖励;13:1:1:10_12008_4_0|10_11082_4_0|10_12409_4_0;
		if (type(reward[1] == "string")) then
			local card = hApi.Split(reward[1], ":")
			local cardList = hApi.Split(card[4], "|")
			local totalCardNum = #cardList --抽卡总数量
			for i = #cardList, 1, -1 do
				if (#cardList[i] == 0) then --防止最后一项是空表
					cardList[i] = nil
					totalCardNum = totalCardNum - 1
				else
					cardList[i] = hApi.Split(cardList[i], "_")
					cardList[i][1] = tonumber(cardList[i][1]) or 0
					cardList[i][2] = tonumber(cardList[i][2]) or 0
					cardList[i][3] = tonumber(cardList[i][3]) or 0
					cardList[i][4] = tonumber(cardList[i][4]) or 0
					--print(unpack(cardList[i]))
				end
			end
			
			--检测是否包含神器
			local bExistedRedEquip = false
			for i = 1, totalCardNum, 1 do
				local rewardT = cardList[i]
				local rewardType = tonumber(rewardT[1]) --奖励类型
				if (rewardType == 10) then --10:红装神器
					bExistedRedEquip = true --找到了
					itemModel = "ui/chest_8.png"
					break
				end
			end
			
			--如果里面包含战术卡碎片，那么替换成金盒子
			local bExistedTacticDerbris = false
			if (not bExistedRedEquip) then
				--检测是否包含战术卡碎片
				for i = 1, totalCardNum, 1 do
					local rewardT = cardList[i]
					local rewardType = tonumber(rewardT[1]) --奖励类型
					if (rewardType == 6) then --6:战术技能卡碎片
						bExistedTacticDerbris = true --找到了
						itemModel = "icon/item/card_lv3.png"
						--itemName = hVar.tab_string["TacticCardRow"] .. hVar.tab_string["__TEXT_ITEM_TYPE_GIFTITEM"] --"战术礼包"
						
						--如果是防御塔，改为防御塔礼包
						local itemId = tonumber(rewardT[2]) --战术卡道具id
						local tabI = hVar.tab_item[itemId] or {}
						local tacticID = tabI.tacticID or 0
						local tabT = hVar.tab_tactics[tacticID] or {}
						local tabTType = tabT.type
						if (tabTType == hVar.TACTICS_TYPE.TOWER) then
							itemModel = "UI:TOWERDERBIRS_GIFTCARD"
							--itemName = hVar.tab_string["__Attr_Hint_Led"] .. hVar.tab_string["__TEXT_SOLDIER_TOWER"] .. hVar.tab_string["__TEXT_ITEM_TYPE_GIFTITEM"] --"防御塔礼包"
						end
						
						--如果是兵种卡，改为兵种卡礼包
						if (tabTType == hVar.TACTICS_TYPE.ARMY) then
							itemModel = "ICON:Item_Treasure39"
							--itemName = hVar.tab_string["ArmyCardPage"] .. hVar.tab_string["__TEXT_ITEM_TYPE_GIFTITEM"] --"兵种礼包"
						end
						
						break
					end
				end
			end
			
			--如果里面包含橙装，那么替换成银盒子
			local bExistedOrangeEquip = false
			if (not bExistedRedEquip) and (not bExistedTacticDerbris) then
				--检测是否包含橙装
				for i = 1, totalCardNum, 1 do
					local rewardT = cardList[i]
					local rewardType = tonumber(rewardT[1]) --奖励类型
					local rewardId = tonumber(rewardT[2]) or 0 --奖励id
					if (rewardType == 3) then --3:道具
						local tabT = hVar.tab_item[rewardId] or {}
						if (tabT.itemLv == hVar.ITEM_QUALITY.RED) then --橙装
							bExistedOrangeEquip = true --找到了
							itemModel = "icon/item/random_lv2.png"
							break
						end
					end
				end
			end
			
			--如果里面包含英雄将魂，那么替换成礼包
			local bExisteHeroDebris = false
			if (not bExistedRedEquip) and (not bExistedTacticDerbris) and (not bExistedOrangeEquip) then
				--检测是否包含英雄将魂
				for i = 1, totalCardNum, 1 do
					local rewardT = cardList[i]
					local rewardType = tonumber(rewardT[1]) --奖励类型
					local rewardId = tonumber(rewardT[2]) or 0 --奖励id
					if (rewardType == 5) then --5:英雄将魂
						bExisteHeroDebris = true --找到了
						itemModel = "UI:HERODEBRIRS_GIFTCARD"
						--itemName = hVar.tab_string["__TEXT_ITEM_TYPE_SOULSTONE"] .. hVar.tab_string["__TEXT_ITEM_TYPE_GIFTITEM"] --"将魂礼包"
						
						--检测是否包含高级英雄将魂
						local itemId = tonumber(rewardT[2]) --战术卡道具id
						local tabI = hVar.tab_item[itemId] or {}
						local heroID = tabI.heroID or 0
						local pvp_only = false
						for h = 1, #hVar.HERO_AVAILABLE_LIST, 1 do
							if (hVar.HERO_AVAILABLE_LIST[h].id == heroID) then --找到了
								pvp_only = hVar.HERO_AVAILABLE_LIST[h].pvp_only
								break
							end
						end
						if pvp_only then
							itemModel = "UI:HERODEBRIRS_GIFTCARD_HIGH"
						end
						
						break
					end
				end
			end
			
			--如果里面包含宝物碎片，那么替换成书
			local bExisteTreasureDebris = false
			if (not bExistedRedEquip) and (not bExistedTacticDerbris) and (not bExistedOrangeEquip) and (not bExisteHeroDebris) then
				--检测是否包含宝物碎片
				for i = 1, totalCardNum, 1 do
					local rewardT = cardList[i]
					local rewardType = tonumber(rewardT[1]) --奖励类型
					local rewardId = tonumber(rewardT[2]) or 0 --奖励id
					if (rewardType == 22) then --22:宝物碎片
						bExisteTreasureDebris = true --找到了
						itemModel = "ICON:Item_Book05"
						--itemName = hVar.tab_string["__TEXT_ITEM_TYPE_ORNAMENTS"] .. hVar.tab_string["__TEXT_ITEM_TYPE_GIFTITEM"] --"宝物礼包"
						break
					end
				end
			end
			
			--月卡显示特别的图标
			--print("月卡", string.find(tostring(tCmd[1]), "月卡"))
			--if (string.find(tostring(tCmd[1]), "月卡") ~= nil) then
			if (string.find(tostring(tCmd[1]), hVar.tab_string["__TEXT_MONTHCARD"]) ~= nil) then
				itemModel = "UI:MONTHCARD_ICON"
			end
		end
		
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"【活动奖励】"
		--GiftTip = hVar.tab_string["["].. tostring(tCmd[1]) .. hVar.tab_string["]"] --"【活动奖励】"
		GiftTip = tostring(tCmd[1]) --"【活动奖励】"
	elseif (prizetype == 20029) then --无尽地图第一名通知
		--无尽地图每日排行奖励;2018-10-15;2;58;logId;奖励1;奖励2;奖励3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --标题
		local strDate = tostring(tCmd[2]) --日期
		local rankId = tonumber(tCmd[3]) or 0 --排行榜id
		local myRank = tonumber(tCmd[4]) or 0 --我的排名
		local logId = tonumber(tCmd[5]) or 0 --日志id
		local reward = {} --奖励
		local rewardNum = 0 --奖励数量
		for i = 6, #tCmd, 1 do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and (tCmd[i] ~= "") then
				local tReward = hApi.Split(tCmd[i] or "", ":")
				tReward[1] = tonumber(tReward[1]) or 0
				tReward[2] = tonumber(tReward[2]) or 0
				tReward[3] = tonumber(tReward[3]) or 0
				
				reward[#reward + 1] = tReward
				rewardNum = rewardNum + 1
			end
		end
		--print(title, strDate, rankId, myRank, logId)
		
		exNum = 0
		
		--图标
		if (rankId == 1) then --无尽试炼(苹果版本)
			itemModel = "ICON:HeroAttr_str"
		elseif (rankId == 2) then --无尽杀阵(苹果版本)
			itemModel = "UI:MOTA"
		elseif (rankId == 3) then --夺塔奇兵每日排名奖励
			itemModel = "UI:PVP_ONLY"
		elseif (rankId == 11) then --无尽试炼(安卓版本)（小米、9游、应用宝、OPPO、VIVO、google）
			itemModel = "ICON:HeroAttr_str"
		elseif (rankId == 12) then --无尽杀阵(安卓版本)（小米、9游、应用宝、OPPO、VIVO、google）
			itemModel = "UI:MOTA"
		elseif (rankId == 21) then --无尽试炼(安卓版本)（华为）
			itemModel = "ICON:HeroAttr_str"
		elseif (rankId == 22) then --无尽杀阵(安卓版本)（华为）
			itemModel = "UI:MOTA"
		elseif (rankId == 31) then --无尽试炼(安卓版本)（官方、taptap、好游快爆、预留版本YZYZ）
			itemModel = "ICON:HeroAttr_str"
		elseif (rankId == 32) then --无尽杀阵(安卓版本)（官方、taptap、好游快爆、预留版本YZYZ）
			itemModel = "UI:MOTA"
		elseif (rankId == 5) then --决战虚鲲
			itemModel = "UI:pvp_iron"
		end
		
		--邮件的产生时间
		local yyyy = string.sub(strDate, 1, 4)
		local mm = string.sub(strDate, 6, 7)
		local dd = string.sub(strDate, 9, 10)
		local mailTime = hApi.GetNewDate(strDate .. " 23:59:59")
		
		--服务器时间
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
		local hostTime = hApi.GetNewDate(g_systime)
		hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
		
		--时间差(北京时区)
		local ts = hostTime - mailTime
		local tab2 = os.date("*t", hostTime)
		
		--日期的文字描述
		--如果是昨天，显示"昨日"
		--如果是今年，显示"XX月XX日"
		--如果是更早的年份，显示"XXXX年XX月XX日"
		local strYMD = ""
		if (ts < (3600 * 24)) then --昨天
			--"昨日"
			strYMD = hVar.tab_string["__Yesterday"]
		elseif (tonumber(yyyy) == tab2.year) then --今年
			--"XX月XX日"
			strYMD = mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
		else --更久的年份
			--"XXXX年XX月XX日"
			strYMD = yyyy .. hVar.tab_string["_TEXT_YEAR_"] .. mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
		end
		
		--标题
		if (rankId == 1) then --随机迷宫
			GiftTip = hVar.tab_string["["] .. hVar.tab_stringM["world/csys_random_test"][1] .. hVar.tab_string["]"] .. strYMD .. hVar.tab_string["__TEXT_RankNum"] .. hVar.tab_string["__Reward__"] --"排名奖励"
		elseif (rankId == 2) then --前哨阵低
			GiftTip = hVar.tab_string["["] .. hVar.tab_stringM["world/yxys_ex_002"][1] .. hVar.tab_string["]"] .. strYMD .. hVar.tab_string["__TEXT_RankNum"] .. hVar.tab_string["__Reward__"] --"排名奖励"
		end
	elseif (prizetype == 20030) then --魔龙宝库勤劳奖
		--魔龙宝库每日勤劳奖;2018-10-15;10;奖励1;奖励2;奖励3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --标题
		local strDate = tostring(tCmd[2]) --日期
		local count = tonumber(tCmd[3]) or 0 --挑战次数
		local reward = {} --奖励
		local rewardNum = 0 --奖励数量
		for i = 4, #tCmd, 1 do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and (tCmd[i] ~= "") then
				local tReward = hApi.Split(tCmd[i] or "", ":")
				tReward[1] = tonumber(tReward[1]) or 0
				tReward[2] = tonumber(tReward[2]) or 0
				tReward[3] = tonumber(tReward[3]) or 0
				
				reward[#reward + 1] = tReward
				rewardNum = rewardNum + 1
			end
		end
		--print(title, strDate, rankId, myRank, logId)
		
		exNum = 0
		
		--图标
		itemModel = "ui/icon_mlbk.png"
		
		--邮件的产生时间
		local yyyy = string.sub(strDate, 1, 4)
		local mm = string.sub(strDate, 6, 7)
		local dd = string.sub(strDate, 9, 10)
		local mailTime = hApi.GetNewDate(strDate .. " 23:59:59")
		
		--服务器时间
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
		local hostTime = hApi.GetNewDate(g_systime)
		hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
		
		--时间差(北京时区)
		local ts = hostTime - mailTime
		local tab2 = os.date("*t", hostTime)
		
		--日期的文字描述
		--如果是昨天，显示"昨日"
		--如果是今年，显示"XX月XX日"
		--如果是更早的年份，显示"XXXX年XX月XX日"
		local strYMD = ""
		if (tonumber(yyyy) == tab2.year) and (tonumber(mm) == tab2.month) and (tonumber(dd) == tab2.day) then --今日
			--"今日"
			strYMD = hVar.tab_string["__Today"]
		elseif (ts < (3600 * 24)) then --昨天
			--"昨日"
			strYMD = hVar.tab_string["__Yesterday"]
		elseif (tonumber(yyyy) == tab2.year) then --今年
			--"XX月XX日"
			strYMD = mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
		else --更久的年份
			--"XXXX年XX月XX日"
			strYMD = yyyy .. hVar.tab_string["_TEXT_YEAR_"] .. mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
		end
		
		--标题
		GiftTip = hVar.tab_string["["] .. hVar.tab_stringM["world/td_wj_003"][1] .. hVar.tab_string["]"] .. strYMD .. hVar.tab_string["__TEXT_QinLaoJiang"] --"勤劳奖"
		
	elseif (prizetype == 20031) then --带有标题和正文的邮件奖励
		--奖励标题;奖励正文;奖励1;奖励2;奖励3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --标题
		local content = tostring(tCmd[2]) --正文
		local reward = {} --奖励
		local rewardNum = 0 --奖励数量
		for i = 3, #tCmd, 1 do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and (tCmd[i] ~= "") then
				local tReward = hApi.Split(tCmd[i] or "", ":")
				tReward[1] = tonumber(tReward[1]) or 0
				tReward[2] = tonumber(tReward[2]) or 0
				tReward[3] = tonumber(tReward[3]) or 0
				
				reward[#reward + 1] = tReward
				rewardNum = rewardNum + 1
			end
		end
		--print(title, strDate, rankId, myRank, logId)
		
		exNum = 0
		
		--图标
		itemModel = "ui/xf.png"
		
		--月卡显示特别的图标
		--print("月卡", string.find(tostring(tCmd[1]), "月卡"))
		--if (string.find(tostring(tCmd[1]), "月卡") ~= nil) then
		if (string.find(tostring(tCmd[1]), hVar.tab_string["__TEXT_MONTHCARD"]) ~= nil) then
			itemModel = "UI:MONTHCARD_ICON"
		end
		
		--[[
		--军团排名奖励显示特别的图标
		--print("军团排名奖励", string.find(tostring(tCmd[1]), "军团排名奖励"))
		--if (string.find(tostring(tCmd[1]), "军团排名奖励") ~= nil) then
		if (string.find(tostring(tCmd[1]), hVar.tab_string["__TEXT_GROUP_RANK_REWARD"]) ~= nil) then
			itemModel = "misc/chest/redpacket.png"
		end
		]]
		
		--标题
		--GiftTip = hVar.tab_string["["] .. title .. hVar.tab_string["]"]
		GiftTip = title
		
	elseif (prizetype == 20032) then --直接开锦囊奖励
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		exNum = 0
		for i = 2, #tCmd do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and tCmd[i] ~= "" then
				reward[#reward + 1] = tCmd[i]
				exNum = exNum + 1
				
				--解析锦囊id
				local rewardT = hApi.Split(tCmd[i], ":")
				local rtype = tonumber(rewardT[1]) or 0 --15:直接开锦囊奖励
				local chestId = tonumber(rewardT[2]) or 0 --锦囊id
				local rnum = tonumber(rewardT[3]) or 0 --锦囊数量
				local param4 = rewardT[4]
				
				--锦囊图标
				itemModel = hVar.tab_item[chestId].icon
			end
		end
		
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"【活动奖励】"
		--GiftTip = hVar.tab_string["["].. tostring(tCmd[1]) .. hVar.tab_string["]"] --"【活动奖励】"
		GiftTip = tostring(tCmd[1]) --"【活动奖励】"
		
	elseif (prizetype == 20033) then --只有标题和正文，没有奖励
		--奖励标题;奖励正文;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --标题
		local content = tostring(tCmd[2]) --正文
		local reward = {} --奖励
		local rewardNum = 0 --奖励数量
		
		exNum = 0
		
		--图标
		itemModel = "UI:BROADCAST_M"
		
		--标题
		--GiftTip = hVar.tab_string["["] .. title .. hVar.tab_string["]"]
		GiftTip = title
		
	elseif (prizetype == 20034) then --夺塔奇兵带有段位、标题和正文的奖励
		--段位;奖励标题;奖励正文;
		local tCmd = hApi.Split(prizecode,";")
		local rank = tonumber(tCmd[1]) or 0 --段位
		local title = tostring(tCmd[2]) --标题
		local content = tostring(tCmd[3]) --正文
		local reward = {} --奖励
		local rewardNum = 0 --奖励数量
		
		exNum = 0
		
		--图标
		local tabRank = hVar.tab_pvprank[rank] or hVar.tab_pvprank[0]
		itemModel = tabRank.icon
		
		--标题
		--GiftTip = hVar.tab_string["["] .. title .. hVar.tab_string["]"]
		GiftTip = title
		
	elseif (prizetype == 20035) then --聊天龙王奖
		--聊天龙王奖;2018-10-15;10;奖励1;奖励2;奖励3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --标题
		local strDate = tostring(tCmd[2]) --日期
		local count = tonumber(tCmd[3]) or 0 --挑战次数
		local reward = {} --奖励
		local rewardNum = 0 --奖励数量
		for i = 4, #tCmd, 1 do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and (tCmd[i] ~= "") then
				local tReward = hApi.Split(tCmd[i] or "", ":")
				tReward[1] = tonumber(tReward[1]) or 0
				tReward[2] = tonumber(tReward[2]) or 0
				tReward[3] = tonumber(tReward[3]) or 0
				
				reward[#reward + 1] = tReward
				rewardNum = rewardNum + 1
			end
		end
		--print(title, strDate, rankId, myRank, logId)
		
		exNum = 0
		
		--图标
		itemModel = "UI:ICON_CHAT_DRAGON"
		
		--邮件的产生时间
		local yyyy = string.sub(strDate, 1, 4)
		local mm = string.sub(strDate, 6, 7)
		local dd = string.sub(strDate, 9, 10)
		local mailTime = hApi.GetNewDate(strDate .. " 23:59:59")
		
		--服务器时间
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
		local hostTime = hApi.GetNewDate(g_systime)
		hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
		
		--时间差(北京时区)
		local ts = hostTime - mailTime
		local tab2 = os.date("*t", hostTime)
		
		--日期的文字描述
		--如果是昨天，显示"昨日"
		--如果是今年，显示"XX月XX日"
		--如果是更早的年份，显示"XXXX年XX月XX日"
		local strYMD = ""
		if (tonumber(yyyy) == tab2.year) and (tonumber(mm) == tab2.month) and (tonumber(dd) == tab2.day) then --今日
			--"今日"
			strYMD = hVar.tab_string["__Today"]
		elseif (ts < (3600 * 24)) then --昨天
			--"昨日"
			strYMD = hVar.tab_string["__Yesterday"]
		elseif (tonumber(yyyy) == tab2.year) then --今年
			--"XX月XX日"
			strYMD = mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
		else --更久的年份
			--"XXXX年XX月XX日"
			strYMD = yyyy .. hVar.tab_string["_TEXT_YEAR_"] .. mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
		end
		
		--标题
		GiftTip = strYMD .. hVar.tab_string["__TEXT_ChatDragonReward"] --"聊天龙王奖"
		
	elseif (prizetype == 20036) then --军团秘境试炼勤劳奖
		--军团秘境试炼勤劳奖;2018-10-15;10;奖励1;奖励2;奖励3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --标题
		local strDate = tostring(tCmd[2]) --日期
		local count = tonumber(tCmd[3]) or 0 --挑战次数
		local reward = {} --奖励
		local rewardNum = 0 --奖励数量
		for i = 4, #tCmd, 1 do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and (tCmd[i] ~= "") then
				local tReward = hApi.Split(tCmd[i] or "", ":")
				tReward[1] = tonumber(tReward[1]) or 0
				tReward[2] = tonumber(tReward[2]) or 0
				tReward[3] = tonumber(tReward[3]) or 0
				
				reward[#reward + 1] = tReward
				rewardNum = rewardNum + 1
			end
		end
		--print(title, strDate, rankId, myRank, logId)
		
		exNum = 0
		
		--图标
		itemModel = "icon/item/item_treasure01.png"
		
		--邮件的产生时间
		local yyyy = string.sub(strDate, 1, 4)
		local mm = string.sub(strDate, 6, 7)
		local dd = string.sub(strDate, 9, 10)
		local mailTime = hApi.GetNewDate(strDate .. " 23:59:59")
		
		--服务器时间
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
		local hostTime = hApi.GetNewDate(g_systime)
		hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
		
		--时间差(北京时区)
		local ts = hostTime - mailTime
		local tab2 = os.date("*t", hostTime)
		
		--日期的文字描述
		--如果是昨天，显示"昨日"
		--如果是今年，显示"XX月XX日"
		--如果是更早的年份，显示"XXXX年XX月XX日"
		local strYMD = ""
		if (tonumber(yyyy) == tab2.year) and (tonumber(mm) == tab2.month) and (tonumber(dd) == tab2.day) then --今日
			--"今日"
			strYMD = hVar.tab_string["__Today"]
		elseif (ts < (3600 * 24)) then --昨天
			--"昨日"
			strYMD = hVar.tab_string["__Yesterday"]
		elseif (tonumber(yyyy) == tab2.year) then --今年
			--"XX月XX日"
			strYMD = mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
		else --更久的年份
			--"XXXX年XX月XX日"
			strYMD = yyyy .. hVar.tab_string["_TEXT_YEAR_"] .. mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
		end
		
		--标题
		GiftTip = hVar.tab_string["["] .. hVar.tab_string["__TEXT_MAINUI_BTN_GROUP"] .. hVar.tab_stringM["world/td_jt_004"][1] .. hVar.tab_string["]"] .. strYMD .. hVar.tab_string["__TEXT_QinLaoJiang"] --"勤劳奖"
		
	elseif (prizetype == 20037) then --军团本周声望排名奖励
		--奖励标题;奖励正文;奖励1;奖励2;奖励3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --标题
		local content = tostring(tCmd[2]) --正文
		local reward = {} --奖励
		local rewardNum = 0 --奖励数量
		for i = 3, #tCmd, 1 do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and (tCmd[i] ~= "") then
				local tReward = hApi.Split(tCmd[i] or "", ":")
				tReward[1] = tonumber(tReward[1]) or 0
				tReward[2] = tonumber(tReward[2]) or 0
				tReward[3] = tonumber(tReward[3]) or 0
				
				reward[#reward + 1] = tReward
				rewardNum = rewardNum + 1
			end
		end
		--print(title, strDate, rankId, myRank, logId)
		
		exNum = 0
		
		--图标
		itemModel = "misc/chest/redpacket.png"
		
		--标题
		--GiftTip = hVar.tab_string["["] .. title .. hVar.tab_string["]"]
		GiftTip = title
		
	elseif (prizetype == 20038) then --军团本周声望第一名奖励
		--奖励标题;奖励正文;奖励1;奖励2;奖励3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --标题
		local content = tostring(tCmd[2]) --正文
		local reward = {} --奖励
		local rewardNum = 0 --奖励数量
		for i = 3, #tCmd, 1 do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and (tCmd[i] ~= "") then
				local tReward = hApi.Split(tCmd[i] or "", ":")
				tReward[1] = tonumber(tReward[1]) or 0
				tReward[2] = tonumber(tReward[2]) or 0
				tReward[3] = tonumber(tReward[3]) or 0
				
				reward[#reward + 1] = tReward
				rewardNum = rewardNum + 1
			end
		end
		--print(title, strDate, rankId, myRank, logId)
		
		exNum = 0
		
		--图标
		itemModel = "misc/chest/redpacket.png"
		
		--标题
		--GiftTip = hVar.tab_string["["] .. title .. hVar.tab_string["]"]
		GiftTip = title
		
	elseif (prizetype == 20039) then --更新维护带有标题和正文的奖励
		--奖励标题;奖励正文;奖励1;奖励2;奖励3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --标题
		local content = tostring(tCmd[2]) --正文
		local reward = {} --奖励
		local rewardNum = 0 --奖励数量
		for i = 3, #tCmd, 1 do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and (tCmd[i] ~= "") then
				local tReward = hApi.Split(tCmd[i] or "", ":")
				tReward[1] = tonumber(tReward[1]) or 0
				tReward[2] = tonumber(tReward[2]) or 0
				tReward[3] = tonumber(tReward[3]) or 0
				
				reward[#reward + 1] = tReward
				rewardNum = rewardNum + 1
			end
		end
		--print(title, strDate, rankId, myRank, logId)
		
		exNum = 0
		
		--图标
		itemModel = "UI:ICON_IKUN"
		
		--标题
		--GiftTip = hVar.tab_string["["] .. title .. hVar.tab_string["]"]
		GiftTip = title
		
	elseif (prizetype == 20040) then --体力带有标题和正文的奖励
		--奖励标题;奖励正文;奖励1;奖励2;奖励3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --标题
		local content = tostring(tCmd[2]) --正文
		local reward = {} --奖励
		local rewardNum = 0 --奖励数量
		for i = 3, #tCmd, 1 do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and (tCmd[i] ~= "") then
				local tReward = hApi.Split(tCmd[i] or "", ":")
				tReward[1] = tonumber(tReward[1]) or 0
				tReward[2] = tonumber(tReward[2]) or 0
				tReward[3] = tonumber(tReward[3]) or 0
				
				reward[#reward + 1] = tReward
				rewardNum = rewardNum + 1
			end
		end
		--print(title, strDate, rankId, myRank, logId)
		
		exNum = 0
		
		--图标
		itemModel = "misc/chest/redpacket.png"
		
		--标题
		--GiftTip = hVar.tab_string["["] .. title .. hVar.tab_string["]"]
		GiftTip = title
		
	elseif (prizetype == 20041) then --感谢信带有标题和正文的奖励
		--奖励标题;奖励正文;奖励1;奖励2;奖励3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --标题
		local content = tostring(tCmd[2]) --正文
		local reward = {} --奖励
		local rewardNum = 0 --奖励数量
		for i = 3, #tCmd, 1 do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and (tCmd[i] ~= "") then
				local tReward = hApi.Split(tCmd[i] or "", ":")
				tReward[1] = tonumber(tReward[1]) or 0
				tReward[2] = tonumber(tReward[2]) or 0
				tReward[3] = tonumber(tReward[3]) or 0
				
				reward[#reward + 1] = tReward
				rewardNum = rewardNum + 1
			end
		end
		--print(title, strDate, rankId, myRank, logId)
		
		exNum = 0
		
		--图标
		itemModel = "misc/chest/redpacket.png"
		
		--标题
		--GiftTip = hVar.tab_string["["] .. title .. hVar.tab_string["]"]
		GiftTip = title
		
	elseif (prizetype == 20042) then --分享信带有标题和正文的奖励
		--奖励标题;奖励正文;奖励1;奖励2;奖励3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --标题
		local content = tostring(tCmd[2]) --正文
		local reward = {} --奖励
		local rewardNum = 0 --奖励数量
		for i = 3, #tCmd, 1 do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and (tCmd[i] ~= "") then
				local tReward = hApi.Split(tCmd[i] or "", ":")
				tReward[1] = tonumber(tReward[1]) or 0
				tReward[2] = tonumber(tReward[2]) or 0
				tReward[3] = tonumber(tReward[3]) or 0
				
				reward[#reward + 1] = tReward
				rewardNum = rewardNum + 1
			end
		end
		--print(title, strDate, rankId, myRank, logId)
		
		exNum = 0
		
		--图标
		itemModel = "misc/chest/redpacket.png"
		
		--标题
		--GiftTip = hVar.tab_string["["] .. title .. hVar.tab_string["]"]
		GiftTip = title
		
	elseif (prizetype == 1035) then --首冲198元档
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		for i = 1, #tCmd do
			reward[#reward + 1] = tCmd[i]
		end
		local tReward = hApi.Split(reward[1] or "", ":")
		itemID = tonumber(tReward[2]) or 0
		if  hVar.tab_stringI[itemID] then
			local itemLv = (hVar.tab_item[itemID].itemLv or 1)
			itemName = hVar.tab_stringI[itemID][1] or hVar.tab_string["__TEXT_noAppraise"]
			itemModel = hVar.tab_item[itemID].icon
			itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL
		end
		--GiftTip = hVar.tab_string["__TEXT_GetItem1"]..hVar.tab_string["["]..itemName..hVar.tab_string["]"]
		GiftTip = hVar.tab_string["__TEXT_GetItem1"].. hVar.tab_string["["]..itemName..hVar.tab_string["]"]
		
		--也发游戏币
		if (type(reward[2]) == "string") then
			local tReward2 = hApi.Split(reward[2] or "", ":")
			coin = tonumber(tReward2[2]) or 0
		end
		
	elseif (prizetype == 1036) then --首冲388元档
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		for i = 1, #tCmd do
			reward[#reward + 1] = tCmd[i]
		end
		local tReward = hApi.Split(reward[1] or "", ":")
		itemID = tonumber(tReward[2]) or 0
		if  hVar.tab_stringI[itemID] then
			local itemLv = (hVar.tab_item[itemID].itemLv or 1)
			itemName = hVar.tab_stringI[itemID][1] or hVar.tab_string["__TEXT_noAppraise"]
			itemModel = hVar.tab_item[itemID].icon
			itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL
		end
		--GiftTip = hVar.tab_string["__TEXT_GetItem1"]..hVar.tab_string["["]..itemName..hVar.tab_string["]"]
		GiftTip = hVar.tab_string["__TEXT_GetItem1"].. hVar.tab_string["["]..itemName..hVar.tab_string["]"]
		
		--也发游戏币
		if (type(reward[2]) == "string") then
			local tReward2 = hApi.Split(reward[2] or "", ":")
			coin = tonumber(tReward2[2]) or 0
		end
		
	elseif prizetype == 40000 then
		itemID = 27
		itemName = hVar.tab_stringI[itemID][1]
		local itemLv = (hVar.tab_item[itemID].itemLv or 1)
		itemModel = hVar.tab_item[itemID].icon
		itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL
		itemNum = tonumber(prizecode)
		GiftTip = hVar.tab_string["__TEXT_CMSTG_PLAY"]..hVar.tab_string["["]..itemName..hVar.tab_string["]"]
	--活动奖励
	elseif prizetype == 10000 then
		local tempState = {}
		for prizecode in string.gfind(prizecode,"([^%;]+);+") do
			tempState[#tempState+1] = prizecode
		end
		
		--多个奖励
		if #tempState > 1 then
			itemID = 9103		--只是借用新手礼包的图标
			itemModel = hVar.tab_item[itemID].icon
			local itemLv = (hVar.tab_item[itemID].itemLv or 1)
			itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL
			itemNum = tonumber(prizecode)
			GiftTip = hVar.tab_string["__TEXT_GetItem4"]
		--只有一种奖励
		else
			itemID,itemNum,itemName,itemHole,coin,score,itemBack,itemModel,GiftTip,GiftTip_Ex,giftType = hApi.UnpackPrizeDataEx(tempState[1])
		end
	end
	
	return itemID,itemNum,itemName,itemHole,coin,score,itemBack,itemModel,GiftTip,GiftTip_Ex,exNum,exY,exG,giftType
end

--检测参数地图是否是地图包入口
hApi.CheckMapBagEx = function(mapName,achi)
	for i = 1,#hVar.MAP_BAG_EX do
		if hVar.MAP_BAG_EX[i] == mapName and LuaGetPlayerMapAchi(achi,hVar.ACHIEVEMENT_TYPE.LEVEL) == 1 then
			return 1
		end
	end
	return 0
end

--获得任务奖励道具孔数
hApi.GetQuestRewardItemSlotNum = function(id)
	local tabI = hVar.tab_item[id]
	if tabI and hVar.ITEM_EQUIPMENT_POS[tabI.type or 0]~=nil then
		--可装备的物品才有孔
		local nItemLv = tabI.itemLv or 0
		if tabI.elite==1 then
			nItemLv = 5		--橙装视为等级5的装备
		end
		return hVar.REWARD_EQUIPMENT_SLOT[nItemLv] or 0
	else
		return 0
	end
end

hApi.GetUnitAttackTypeById = function(id)
	local tabU = hVar.tab_unit[id]
	local nAttackType = 0
	local sAttackType = hVar.tab_string["__Attr_ATTACKMODE_NONE"]
	if tabU==nil then
	elseif type(tabU.type_ex)=="table" then
		local IsSiege = 0
		local IsMelee = 0
		local IsSpell = 0
		for i = 1,#tabU.type_ex do
			if tabU.type_ex[i]=="MELEE" then
				IsMelee = 1
			elseif tabU.type_ex[i]=="SIEGE" then
				IsSiege = 1
			elseif tabU.type_ex[i]=="WIZARD" or tabU.type_ex[i]=="LEGEND" then
				IsSpell = 1
			end
		end
		if IsMelee==1 then
			if IsSiege==1 then
				--近战攻城
				sAttackType = hVar.tab_string["__Attr_ATTACKMODE_23"]
			else
				--近战
				sAttackType = hVar.tab_string["__Attr_ATTACKMODE_28"]
			end
		else
			if IsSiege==1 then
				--远程攻城
				sAttackType = hVar.tab_string["__Attr_ATTACKMODE_24"]
			elseif IsSpell==1 then
				--法术
				sAttackType = hVar.tab_string["__Attr_ATTACKMODE_29"]
			else
				--远程
				sAttackType = hVar.tab_string["__Attr_ATTACKMODE_30"]
			end
		end
	elseif tabU.attr and tabU.attr.attack then
		if tabU.attr.attack[3] > 2 then
			if (tabU.attr.siege or 0)>0 then
				--远程攻城
				sAttackType = hVar.tab_string["__Attr_ATTACKMODE_24"]
			else
				--远程
				sAttackType = hVar.tab_string["__Attr_ATTACKMODE_30"]
			end
		else
			if (tabU.attr.siege or 0)>0 then
				--近战攻城
				sAttackType = hVar.tab_string["__Attr_ATTACKMODE_23"]
			else
				--近战
				sAttackType = hVar.tab_string["__Attr_ATTACKMODE_28"]
			end
		end
	end
	--如果有强行设置过的攻击类型
	if tabU and tabU.attr and tabU.attr.attack then
		local nAttackId = tabU.attr.attack[1]
		for i = 1,#hVar.UNIT_ATTACKMODE do
			local v = hVar.UNIT_ATTACKMODE[i]
			if v[1]==nAttackId then
				sAttackType = hVar.tab_string[v[2]]
				break
			end
		end
	end
	return nAttackType,sAttackType
end

--野外生物逃散对话(威震四方)
hApi.CreateDeterTalk = function(oUnit,oTarget,IfWithCheck)
	local sus = 1
	if IfWithCheck==1 then
		sus = 0
		local nCount,nLv = hGlobal.LocalPlayer.data.detercount,hGlobal.LocalPlayer.data.deterlevel
		if nCount>0 and nLv>0 then
			local nCombatScoreU = oUnit:calculate("CombatScore")
			local nCombatScoreT = oTarget:calculate("CombatScore")
			nLv = math.min(nLv,10)
			if nCombatScoreT<=0 then
				sus = 1
			elseif hApi.floor(100*nCombatScoreU/nCombatScoreT)>=(600-30*nLv) then
				sus = 1
			end
		end
	end
	if sus==1 then
		hGlobal.LocalPlayer.data.detercount = hGlobal.LocalPlayer.data.detercount - 1
		local IsPursue = 0
		local tName = hVar.tab_stringU[oTarget.data.id][1] or tostring(oTarget.data.name)
		local vTalk
		vTalk = {
			id = {oTarget.data.id,oUnit.data.id},
			selection = {
				["pursue"] = function(tFunc)
					IsPursue = 1
				end,
				["leave"] = function(tFunc)
					vTalk[#vTalk+1] = "@L1:1@"
					vTalk[#vTalk+1] = hVar.tab_string["__TEXT__CREEP_LEAVE__"]
				end,
			},
		}
		local tTokenTalk = {
			"occupy",
			"@L1:1@",
			"@select:2:$__PursueOrLeave@",
			"pursue",
			"leave",
			"@R1:2@",
			string.gsub(hVar.tab_string["__TEXT__FLEEING__"],"#NAME#",tName),
		}
		hApi.AnalyzeTalk(oUnit,oTarget,tTokenTalk,vTalk)
		hApi.CreateUnitTalk(vTalk,function()
			if IsPursue==1 then
				hUI.Disable(350,"追击敌人",1)
				hGlobal.BattleField = hApi.CreateBattlefield(oUnit,oTarget)
				hGlobal.WORLD.LastWorldMap:pause(1,"Battlefield")
				hApi.addTimerOnce("__WM__LocalPlayerAfterPursue",250,function()
					hApi.EnterBattlefield(hGlobal.BattleField,oUnit,oTarget)
				end)
			else
				hUI.Disable(250,"放走敌人")
				local vTalk = hApi.InitTalkAfterBattle(oUnit,oTarget)
				if vTalk then
					hApi.AnalyzeTalk(oUnit,oTarget,vTalk.talk,vTalk)
					return hApi.CreateUnitTalk(vTalk,function()
						oTarget:dead()
					end)
				else
					oTarget:dead()
				end
			end
		end)
		return hVar.RESULT_SUCESS
	else
		return hVar.RESULT_FAIL
	end
end

--判断地图是第几章节
hApi.MapChapterDecide = function(mapName)
	for i = 1,#hVar.CHAPTER_MAP do
		local chapter = hVar.CHAPTER_MAP[i]
		if type(chapter[mapName]) == "number" then
			return i
		end
	end
	return 0
end

hApi.Seconds2HMS = function(nSeconds)
	local Hour,Min,Sec = "00","00","00"
	if type(nSeconds) == "number" and nSeconds >= 0 then
		Hour = math.floor(nSeconds/3600) < 10 and "0"..math.floor(nSeconds/3600) or math.floor(nSeconds/3600)
		Min = math.floor(nSeconds%3600/60) < 10 and "0"..math.floor(nSeconds%3600/60) or math.floor(nSeconds%3600/60)
		Sec = math.floor(nSeconds%60) < 10 and "0"..math.floor(nSeconds%60) or math.floor(nSeconds%60)
	end
	return Hour, Min, Sec
end

hApi.Seconds2DHMS = function(nSeconds)
	local Day,Hour,Min,Sec = "0","0","00","00"
	if type(nSeconds) == "number" and nSeconds >= 0 then
		Day = math.floor(nSeconds/86400)
		Hour = math.floor(nSeconds%86400/3600)
		Min = math.floor(nSeconds%3600/60)
		Sec = math.floor(nSeconds%60)
	end
	return Day, Hour, Min, Sec
end

g_OBSwitch = {}
hApi.ReadOBConfig = function(sConfig)
	print("hApi.ReadOBConfig",sConfig)
	local str = "{" .. sConfig .."}"
	local tConfig = hApi.StringToTable(str)
	g_OBSwitch = {}
	if type(tConfig) == "table" then
		--渠道开关
		if type(tConfig.ChannelSwitch) == "table" then
			local iChannelId = getChannelInfo()
			if type(tConfig.ChannelSwitch.openBBS) == "table" then
				--开启论坛按钮
				for i = 1,#tConfig.ChannelSwitch.openBBS do
					local channel = tConfig.ChannelSwitch.openBBS[i]
					if iChannelId == channel then
						g_OBSwitch.openBBS = 1
					end
				end
			end
			if type(tConfig.ChannelSwitch.avoidRealname) == "table" then
				for i = 1,#tConfig.ChannelSwitch.avoidRealname do
					local channel = tConfig.ChannelSwitch.avoidRealname[i]
					if iChannelId == channel then
						g_OBSwitch.channelavoidRealname = 1
					end
				end
			end
			if type(tConfig.ChannelSwitch.cancloseRealname) == "table" then
				for i = 1,#tConfig.ChannelSwitch.cancloseRealname do
					local channel = tConfig.ChannelSwitch.cancloseRealname[i]
					if iChannelId == channel then
						g_OBSwitch.channelcanCloseRealname = 1
					end
				end
			end
			if type(tConfig.ChannelSwitch.privacy) == "table" then
				for i = 1,#tConfig.ChannelSwitch.privacy do
					local channel = tConfig.ChannelSwitch.privacy[i]
					print(iChannelId,channel)
					if iChannelId == channel then
						g_OBSwitch.privacydown = 1
					end
				end
			end
			if type(tConfig.ChannelSwitch.openChat) == "table" then
				for i = 1,#tConfig.ChannelSwitch.openChat do
					local channel = tConfig.ChannelSwitch.openChat[i]
					--print("openChat",iChannelId,channel)
					if iChannelId == channel then
						g_OBSwitch.openChat = 1
					end
				end
			end
			if type(tConfig.ChannelSwitch.delAccount) == "table" then
				for i = 1,#tConfig.ChannelSwitch.delAccount do
					local channel = tConfig.ChannelSwitch.delAccount[i]
					--print("delAccount",iChannelId,channel)
					if iChannelId == channel then
						g_OBSwitch.delAccount = 1
					end
				end
			end
			if type(tConfig.ChannelSwitch.lipinma) == "table" then
				for i = 1,#tConfig.ChannelSwitch.lipinma do
					local channel = tConfig.ChannelSwitch.lipinma[i]
					--print("lipinma",iChannelId,channel)
					if iChannelId == channel then
						g_OBSwitch.lipinma = 1
					end
				end
			end
			if type(tConfig.ChannelSwitch.openGame) == "table" then
				--print("g_is_account_test",g_is_account_test,iChannelId)
				for i = 1,#tConfig.ChannelSwitch.openGame do
					local channel = tConfig.ChannelSwitch.openGame[i]
					if iChannelId == channel then
						--print("11111111111")
						g_OBSwitch.opengame = 1
						--if g_firstlogin == 0 then
							--hGlobal.event:event("LocalEvent_KorealLogin")
						--end
						break
					elseif channel == 0 and (g_is_account_test == 1 or g_is_account_test == 2) then
						--print("22222222222")
						g_OBSwitch.opengame = 1
						--if g_firstlogin == 0 then
							--hGlobal.event:event("LocalEvent_KorealLogin")
						--end
						break
					end
				end
				if g_lua_src == 1 then
					g_OBSwitch.opengame = 1
				end
			end
		end
	end
end