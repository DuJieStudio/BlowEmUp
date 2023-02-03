--window�µ����ã� ���̰�������
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
  
--���������ַ�A~Z  
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
	local map = hGlobal.mapData[#hGlobal.mapData] or {}	--���صĵ�ͼ����
	for k,v in pairs(hGlobal.mapData)do
		--print("----------------------------------")
		--print("��ͼ���أ�",k)
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

--�����ս���ϴ����˵�λ����ʹ��Ӣ�۵����ݳ�ʼ������ǿ��
hApi.LoadUnitBounceBF = function(oWorld,oUnit)
	local tLeader = oWorld.data.HeroLeader[oUnit.data.owner]
	if type(tLeader)=="table" then
		oUnit.attr.lea = tLeader.attr.lea
		oUnit.attr.led = tLeader.attr.led
	end
end

------------------------------------------
--��λ��ö������Լӳ�
local __CODE__LoadArmyBounce = function(oUnit,tArmyBounce)
	if type(tArmyBounce)=="table" then
		local tAttrB = tArmyBounce[oUnit.data.indexOfTeam]
		if type(tAttrB)=="table" then
			for k,v in pairs(tAttrB)do
				if type(v)~="number" then
					--�����������ë
				elseif k=="atk" then
					--���ӹ�����
					oUnit.attr.attack[4] = oUnit.attr.attack[4] + v
					oUnit.attr.attack[5] = oUnit.attr.attack[5] + v
				elseif k=="hp" then
					--����Ѫ��
					oUnit.attr.hp = oUnit.attr.hp + v
					oUnit.attr.mxhp = oUnit.attr.mxhp + v
					oUnit.attr.__mxhp = oUnit.attr.__mxhp + v
				elseif type(oUnit.attr[k])=="number" then
					--�����������õ�������
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
		ownerId = -1	--�������˽��������������ж�
		--ת��ս������
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
	--�������Ӣ����Ϣ��ս���е��κε�λ���ܵ������Եļӳ�
	w.data.HeroLeader[ownerId] = {hero={},unitWM=hApi.SetObjectEx({},oLeader),attr={lea=0,led=0}}
	local tLeaderData = w.data.HeroLeader[ownerId]
	if oHero then
		local tAttr = tLeaderData.attr
		local tHero = tLeaderData.hero
		local LeaderMode = 1
		if w.data.typeEX==hVar.BF_WORLD_TYPE_EX.PVP then
			--PVPս����Ӣ�۵�ͳ˧�ͷ���ȡƽ��ֵ
			LeaderMode = 2
		elseif ownerId==hGlobal.LocalPlayer.data.playerId then
			--������Ҳ��ӵ�ͳ˧�ͷ���ȡƽ��ֵ
			LeaderMode = 2
		else
			LeaderMode = 1
		end
		if LeaderMode==1 then
			--ȡ��˧����
			tAttr.lea = tAttr.lea + oHero.attr.lea
			tAttr.led = tAttr.led + oHero.attr.led
			tHero[#tHero+1] = hApi.SetObjectEx({},oHero)
			oHero:enumteam(function(oHeroC)
				tHero[#tHero+1] = hApi.SetObjectEx({},oHeroC)
			end)
		elseif LeaderMode==2 then
			--ȡƽ������
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
				--ս����ʹ��scaleB����������������0.1
				local scale = math.floor((tabU.scaleB or 1)*100)
				local bossID = 0
				--��������õ�λ�������ս���ϵ�λ��
				if type(tabU.grid)=="table" then
					x,y = tabU.grid[1],tabU.grid[2]
				end
				--ӵ�в���������
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
						--ӵ���߻����Ѿ��������
						if nType==hVar.PLAYER_ALLIENCE_TYPE.OWNER or nType==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
							--����Ƿ�����õ�λ��������ҿ���
							--ע�����ս�����ǲ��������������ߵģ�������ΪAI�ж�ʧ�ܻᵯ��(�����Ѿ��ƶ�������ս�����ɵ��������洦����)
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
						--�����Ӣ�۵Ļ�
						oHeroX:bindBF(oUnit)
						oUnit.attr.lea = oHeroX.attr.lea
						oUnit.attr.led = oHeroX.attr.led
					elseif tabU.type==hVar.UNIT_TYPE.UNIT then
						--�������ͨ��λ
						__CODE__LoadArmyBounce(oUnit,tArmyBounce)
					end
					hGlobal.event:call("Event_UnitBorn",oUnit)
					--����boss part��λ
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
		--���ӵ���κ�Ӣ�۵�λ,���ս������
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
	--����ս�����ⵥλ
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
	--������ǽ
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
					--�ж��Ƿ���Ҫ�滻ģ��
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
			--δָ��
		elseif nIndex==1 then
			--����
			local tEnv = hVar.BATTLEFIELD_ENVIRONMENT[oWorld.data.background]
			if tEnv and #tEnv>0 then
				tArmyEx = hVar.tab_bfenv[tEnv[hApi.random(1,#tEnv)]]
			end
		elseif nIndex>0 then
			--ָ���ĵ������
			tArmyEx = hVar.tab_bfenv[nIndex]
		end
	end
	if type(tArmyEx)=="table" then
		for i = 1,#tArmyEx do
			local nTeam,id,num,gridX,gridY,facing = unpack(tArmyEx[i])
			if nTeam==0 then
				--�������������
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
			--�������ÿ�ζ���ȡ�浵�����ս������
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
			--��ȡ��ͼ�浵�����ս������
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
	local tArmySide = {1,2}		--������վ������
	local tDeployMode = {}
	local background = nil
	local bgm = nil
	local tabU = hVar.tab_unit[u.data.id]
	if tabU and type(tabU.part)=="table" then
		--Boss!ʼ��ʹ�ù����ߵ�����
		tArmySide = {2,1}
		local tgrData = u:gettriggerdata()
		if tgrData~=nil then
			background = tgrData.battlefield
			bgm = tgrData.bgm
		end
	else
		--һ�㵥λ����
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
	--�����Զ���ս������
	if type(tDataEx)=="table" then
		tArmyBounce = tDataEx.armybounce
		tTactics = tDataEx.tactics
	else
		--��ȡĬ�ϵ�ս����Ƭ
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
			--�����ˮս�Ļ����滻��ˮս����
			if background==nil and oHero~=nil and oHero:getGameVar("_MOUNT")>0 then
				background = "battlefield/battlefield_water_c"
			end
		end
	end
	if type(tTactics)~="table" then
		tTactics = {}
	end
	if oTown~=nil then
		--����ս
		--Ĭ�Ϲ��Ǳ�������
		if bgm==nil then
			bgm = "fight_town"
		end
		--Ĭ��ƽԭ������
		if background==nil then
			background = "battlefield/battlefield_plain_t"
		end
	else
		--���ָ����ս������
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
	--��ʼ��bfData
	oWorldBF.data.bfdata = {
		EnableQuest = 0,		--��ǰս���Ƿ�����������
		LocalTeamId = 0,		--��ʾΪ��ɫ�Ķ���
	}
	--�ж���ʾѪ����ɫ(˭��ս�����ض��飿)
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
	--�������⺯��
	if type(codeOnCreate)=="function" then
		codeOnCreate(oWorldBF)
	end
	if oWorldBF.map==nil then
		--ɶ�����?δ֪��ͼ��
		return oWorldBF
	elseif oTown~=nil then
		--����ս,Ĭ�Ͼ���ƽԭ������
		hApi.CreateArmyOnBattlefield(oWorldBF,u,tArmySide[1],tDeployMode[1],tArmyEx,hVar.SIEGE_GATE_UNIT)
		hApi.CreateArmyOnBattlefield(oWorldBF,t,tArmySide[2],tDeployMode[2],tArmyEx,hVar.SIEGE_GATE_UNIT)
		--����ǹ���ս����ô�����г�ǽ�����Ҷ���2Ϊ�سǷ�
		--ս�����뱻��������
		--��ʱ���سǷ����50%���˺�����,ÿ�ݻ�һ���ǽ����Ч������15%
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
		--�ǹ���ս
		hApi.CreateArmyOnBattlefield(oWorldBF,u,tArmySide[1],tDeployMode[1],tArmyEx)
		hApi.CreateArmyOnBattlefield(oWorldBF,t,tArmySide[2],tDeployMode[2],tArmyEx)
		--�ǹ���ս��������ϰ�
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
			--�ҿ��Ƶ�
			return 1
		elseif nAlly==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
			if oUnit.data.control==oWorld.data.bfdata.LocalTeamId then
				--�����ط�
				return 1
			else
				--�Ѿ�
				return 2
			end
		else
			--����
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
		oWorld:log({	--����ս��
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
		_DEBUG_MSG("ս���Ѿ���ɾ���ˡ�����")
	end
end

--�ڴ����¼���ɱ����x�������ֹ��ͣˢһֻ�ֻ�û���(10��Ӧ�ù�����)
local __LastKillNPC = {0,0,0,0,0,0,0,0,0,0}
local __GetCheatKillCount = function(oWorld,oUnit,nSecend)
	--��ֹˢ���֣��ڴ��
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
--��ȡĿ�굥λ����ɱ�Ĵ���(��ˢ��)
local __GetUnitScoreByKill = function(oWorld,oUnit,nScore)
	--��ȡ���300���ڶԸõ�λ�Ļ�ɱ����
	local nCheatKillCount = __GetCheatKillCount(oWorld,oUnit,300)
	--������ӻ��ֻ�ȡ��¼
	local r = LuaAddLootRecordFromUnit(g_curPlayerName,oUnit,"scoreI")
	if r==1 then
		--��������ˢ���֣���ֹ��
		if nCheatKillCount==1 then
			nScore = hApi.floor(nScore/2)	--ˢ1�μ���
		elseif nCheatKillCount>=2 then
			nScore = 1			--��ˢ�������Ͼͱ�1���ˣ�
		end
	elseif r==0 then
		--����Ѿ���ȡ��һ�λ��֣��ڶ��λ�õĻ��ֻ����
		nScore = hApi.floor(nScore/2)
		r = LuaAddLootRecordFromUnit(g_curPlayerName,oUnit,"scoreII")
		if nCheatKillCount>=2 then
			nScore = 1			--��ˢ�������Ͼͱ�1���ˣ�
		end
	end
	if r==1 then
		--�����ӻ��ֳɹ���������
		return nScore
	else
		--��Ϊ���ˢ̫���ˣ���1��
		return 1
	end
end

--�뿪ս��ʱ�۳�˫�������еĵ�λ����
--�۳�Ӣ�۵�ħ��ֵ
--ͳ�ƻ�ɱ����
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
	local oUnitVx = hApi.GetBattleUnit(oUnitV)		--���������ս��(ʤ��)��λ
	local oUnitDx = hApi.GetBattleUnit(oUnitD)		--���������ս��(ʧ��)��λ
	local oHeroVx = oUnitVx:gethero()
	local oHeroDx = oUnitDx:gethero()
	local nHpDx = 0
	if oHeroDx then
		nHpDx = oHeroDx.attr.hp				--������ǰ��Ѫ��
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
					--����
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
				--��ƨ�ˣ�Ѫ�۵������۹�
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
	--����ս�ܼ��
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
	--������ǿ���ս��������Ҫ�������
	if oWorld.data.IsQuickBattleField~=1 then
		--��¼����ս��
		hGlobal.LastBattleLog = oWorld.__LOG
		_DEBUG_MSG("--------------------------------------")
		_DEBUG_MSG("BFLog,round = ",oWorld.data.roundcount)
		local oWorldWM = oUnitVx:getworld()
		--��AI��ʤ���߲Ż��������
		local nStar = 0		--0��
		local nScore = 0	--0����
		local nRewardLv = 0	--0���ֵȼ�(�������Ǻ�ս��ʱ�����)
		local nRewardLvMax = 4	--��߻��ֵȼ�
		--�ҷ���ɱ�����Ѿ���ɱ������¼������Ǻͻ���(ֻ�б�����Ҳ����ս���Żῴ���˽��棬���Բ�����ɶ������)
		if oUnitVx:getowner()==hGlobal.LocalPlayer or hGlobal.LocalPlayer:allience(oUnitVx:getowner())==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
			--���������ʤ����
			--ͳ����һ���
			--�������Ķ�����������˽���ֹ���
			local cUnitLost = UnitLost[oUnitVx.data.owner]
			local cUnitSave = UnitSave[oUnitVx.data.owner]
			local eUnitLost = UnitLost[oUnitDx.data.owner]
			--�ж��ҷ�Ӣ���Ƿ�����
			if IsHeroDeadV==1 then
				--
			end
			--ͳ���ҷ�������������ս����
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
			--�ж���ʧ,��������ּӳ�
			if IsHeroDeadV==0 then
				--Ӣ��û�����Ļ�����2~6�ǵ��ж�����
				if nScoreOfLostArmy==0 then
					--�����κε�λ:5~6������
					if oWorld.data.roundcount<=7 then
						--7�غ��ڽ���ս��,6��,����+4
						nRewardLv = 4
						nStar = 6
					elseif oWorld.data.roundcount<=14 then
						--14�غ��ڽ���ս��,6��,����+3
						nRewardLv = 3
						nStar = 6
					else
						--14�غ������Ͻ���ս��,5��,����+2
						nRewardLv = 2
						nStar = 5
					end
				elseif nLostPec<=20 then
					--��ʧ�Ĳ���С�ڵз���λս����20%:4~5������
					if oWorld.data.roundcount<=7 then
						--7�غ��ڽ���ս��,5�ǣ�����+3
						nRewardLv = 3
						nStar = 5
					elseif oWorld.data.roundcount<=14 then
						--14�غ��ڽ���ս��,4�ǣ�����+2
						nRewardLv = 2
						nStar = 4
					else
						--14�غ����Ͻ���ս��,4�ǣ�����+1
						nRewardLv = 1
						nStar = 4
					end
				else
					if oWorld.data.roundcount<=7 then
						--7�غ��ڽ���ս��
						nStar = 4
					elseif oWorld.data.roundcount<=14 then
						--14�غ��ڽ���ս��
						nStar = 3
					else
						nStar = 2
					end
				end
			else
				--Ӣ�����˵Ļ�����1~5�ǵ��ж�����
				if nScoreOfLostArmy==0 then
					--δ��ʧ�κε�λ,5��,����+2
					nRewardLv = 2
					nStar = 5
				elseif nLostPec<=20 then
					--����ʧС�ڵз�ս������20%,4��,����+1
					nRewardLv = 1
					nStar = 4
				elseif oWorld.data.roundcount<=7 then
					--7�غ��ڽ���ս��,3��
					nStar = 3
				elseif oWorld.data.roundcount<=14 then
					--14�غ��ڽ���ս��,2��
					nStar = 2
				else
					--14�غ����Ͻ���ս��,1��
					nStar = 1
				end
			end
			--local pLog = oWorldWM:getplayerlog(oUnitVx.data.owner)
			local pLog = oWorldWM:getplayerlog(hGlobal.LocalPlayer.data.playerId)	--��ʵֻ�б�����ҿ��Կ�����������˵
			if pLog~=nil then
				--��û�������
				if pLog.star[nStar] then
					pLog.star[nStar] = pLog.star[nStar] + 1
				end
				local mapname = oWorldWM.data.map
				local tMapScore = hVar.MAP_SCORE[mapname]
				if oWorldWM.data.playmode==hVar.PLAY_MODE.KUMA_GAME then
					--KUMAģʽû�л���
					nScore = 0
				elseif type(g_curPlayerName)=="string" and tMapScore~=nil then
					local nScorePec = oUnitDx.data.mapScorePec
					local tScoreDetail = tMapScore[8]-- or {6,400,2400,5,77}
					local oHeroOpp = oUnitDx:gethero()
					if oHeroOpp and nScorePec==0 then
						nScorePec = 100
					end
					if nScorePec>0 and tScoreDetail then
						--�������
						nScorePec = math.floor(nScorePec*tMapScore[1]/100)	--��û��ֵİٷֱ�
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
							--��Ӣ�۵Ļ�������ս�������㣬�ᰴ�ձ����������
							nScorePec = math.floor(nScorePec*nBaseScoreOfEnemy/nCombatMin)
						end
						if nScorePec>0 then
							--nRewardLv = 1~4   5~100	--�������Ǽ��������
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

								--�����ʤ��λΪ���ܵĽ��� ����ַ���
								for i = 1,#g_HeroWeekStar  do
									if oUnitVx.data.id == g_HeroWeekStar[i][1] then
										nScore = math.ceil(nScore*g_HeroWeekStar[i][2])
									end
								end
								
								--��ʱ�ѻ��ּ�¼��������
								if hGlobal.WORLD.LastWorldMap.data.explock == 0 then
									LuaAddPlayerScore(nScore)
									local map_get_score = LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.Map_GetScore) or 0
									map_get_score = map_get_score + nScore

									if nScore > 1 then
										LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.Map_GetScore,map_get_score)
									end
									
									--ͳ�ƻ�û���ɱ�˼�����
									local Map_ScoreRound = 0 
									Map_ScoreRound = (LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.Map_ScoreRound) or 0)

									if nScore > 1 then
										LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.Map_ScoreRound,Map_ScoreRound+1)
									end
								else
									--����ģʽ����������
									--���ֲ����� ��¼��ǰ�������Ϸ�еĻ��֣�����ص�3��ǰʱ ������һ��� ����ˢ ������ֵ� BOSS
									hGlobal.WORLD.LastWorldMap.data.dayscore = (hGlobal.WORLD.LastWorldMap.data.dayscore or 0) + nScore
								end
								
							end
						end
					end
				end
			end
		end
		oWorld:log({		--ս������log
			key = "battle_result",
			playerV = oUnitVx.data.owner,
			star = nStar,
			score = nScore,
		})
	end
	--�۱�
	for owner,lost in pairs(UnitLost) do
		local u = oWorld:getlordU(owner)
		if u then
			local save
			local ux = hApi.GetBattleUnit(u)
			--ʤ���߲�������save����
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

--ս�������һЩ���⴦��������¼������ͼ��صĳɾ�
hApi.SpecialBattleResultEvent = function(oUnitV,oUnitD,sResult)
	if hGlobal.WORLD.LastWorldMap==nil then
		return
	end
	local map_name = hGlobal.WORLD.LastWorldMap.data.map
	if sResult=="Victory" then
		--���Ƿɽ��������¼� ��¼���Ʋ���
		if map_name == "world/level_lcfj" then
			local templist = {11017,11019,11020,11021,11022,11023,11024} --���Ƿɽ��ĵ�����...
			for i = 1,#templist do
				if oUnitD.data.id == templist[i] then
					hGlobal.WORLD.LastWorldMap.data.specialVal = i
					break
				end
			end
		end

		if map_name == "world/level_hjzl" then
			--����ڻƽ�֮���л�ɱ��������
			if oUnitD.data.id == 6034 then
				if LuaGetPlayerMapAchi(map_name,hVar.ACHIEVEMENT_TYPE.KILLSMOEBOSS) == 0 then
					LuaSetPlayerMapAchi(map_name,hVar.ACHIEVEMENT_TYPE.KILLSMOEBOSS,1)
					LuaSavePlayerList()
				end
			end
		end
		
		--�ؾ������������¼� ��¼������
		if map_name == "world/level_xlslc" then
			local templist = {6015,5016,6004,6100,6025,6031,6071,6024,11030,6039,6023,5003,5028,6190,5006,5000,5023,6191} --m�ؾ������ĵ�����...
			for i = 1,#templist do
				if oUnitD.data.id == templist[i] then
					hGlobal.WORLD.LastWorldMap.data.specialVal = i
					break
				end
			end
		end
			
		--���������λ��Ӣ�ۣ�����뵽��ɱӢ�� count ��
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
			--��þ���
			local tgrDataP = hGlobal.WORLD.LastWorldMap:getmapdata(1)
			if tgrDataP and type(tgrDataP.ExpPec)=="number" then
				nExpGet = math.floor(nExpGet*tgrDataP.ExpPec/100)
			end
			tLoot[1][3] = nExpGet
			tLoot[1][4] = oHero.attr.level
			--��������
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
						--�Ѿ������ȡexp������
					else
						--���Ի��exp
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
			--����ս�����սʤ�ˣ��������������ת��,�������
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
			oUnitD:dead()	--������
			--�����AI���ߣ����ҿ���ս�����ܵ��ˣ�ֱ���Ƴ��õ�λ����ײ����ȻAi��ʱ�򶯲��ˣ�
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
	--ս���������ж�ʤ�����������Ի���
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
			--�Ѿ�ִ�й��˳�����
			oWorld:exit("exit")
		else
			hGlobal.event:event("LocalEvent_PlayerLeaveBattlefield",hGlobal.LocalPlayer)
			if type(oWorld.data.netdata)=="table" then
				--����ս��
				hGlobal.event:event("LocalEvent_PlayerLeaveNetBattlefield")
			else
				--��ͨս��
				local oWorld = hGlobal.BattleField
				if oWorld then
					oWorld:del()
					hGlobal.BattleField = nil
				end
				--��ս���Ժ������ͼͣ���ˣ���ֹ�����κ���������
				if hGlobal.WORLD.LastWorldMap~=nil then
					hGlobal.WORLD.LastWorldMap:pause(0)
				end
				hApi.LuaReleaseBattlefield()
				hResource.model:releaseCache(hVar.TEMP_HANDLE_TYPE.OBJECT_BF)	--�ű�����ս���Դ�
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
		hResource.model:releaseCache(hVar.TEMP_HANDLE_TYPE.OBJECT_TN)	--�ű���������Դ�
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

--local nGrowth = nil					--ÿ�ܳɳ���(��0�Ļ�Ҳ����Щ��ɳ�,��ղ��ɳ�)
--hApi.CreateArmyByGroup(oWorld,oUnit,oUnitToAddTeam,{
	--{"name",10001,10002,10003,10004,2},		--{����,id,id,id,...,���ѡ��λ����}
	--{"name",5000,5001,5002,1},
--},10000,nGrowth))					--10000ս����

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

----�����������
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
--		--ֻ�����1����λ
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
--					--�༭��ģʽ��ֻ�����ñ�ǩ
--					oUnit.data.nTarget = -1
--					--����������༭��ID�Ļ�����
--					oUnitB = oWorld:addunit(id,owner,nil,nil,facing,worldX,worldY)
--				else
--					--�Ǳ༭��ģʽ�°��Լ�ɾ��
--					oUnit:del()
--					--�����µ�λ
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
--		--ֻ�����1����λ,����ͬһ����Ҳ����������ͬ��Ӣ��
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
--				--�����������
--			elseif tIsHaveHero[id]~=1 then
--				sTemp[#sTemp+1] = id
--			end
--		end
--		if #sTemp<=0 then
--			--���ûˢ��������ô�Ժ󶼲���ˢӢ����
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
--					--�༭��ģʽ��ֻ�����ñ�ǩ
--					oUnit.data.nTarget = -1
--					--����������༭��ID�Ļ�����
--					oUnitH = oWorld:addunit(id,owner,nil,nil,facing,worldX,worldY)
--				else
--					--�Ǳ༭��ģʽ�°��Լ�ɾ��
--					oUnit:del()
--					--�����µ�λ
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
--			--�����ںϷ��������
--			if tGroup==nil then
--				return
--			end
--			--�Ӵ����������ж�ȡս����
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
--			--���ûȡ��ս��������ô�ӱ���ж�ȡ
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
--						--�κε��Կ��Ƶĵ�λ�����ˣ�
--						RandomPec = hApi.GetMapValueByDifficulty(oWorld,"EnemyBorn")
--					elseif IsAI==-1 then
--						--�κε��Կ��Ƶĵ�λ���Ѿ���
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
--	--���û�ҵ�����飬����
--	if not(type(tGroup)=="table" and #tGroup>0) then
--		return
--	end
--	local sGroup = __SelectTeamFromGroup(oWorld,tGroup)
--	--��ʼ�������ˢ������
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
--		--���ѡ������еļ�����λ
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
--				--�����滻��uTemp
--				uTemp = r
--			end
--		end
--		local IsNewUnit = 0
--		if #uTemp>0 and oUnitToAddTeam==nil and oUnitGroup~=nil then
--			--���δ������Ҫ���벿�ӵĵ�λ����Ϊ�´���һ����
--			local uId = uTemp[oWorld:random(1,#uTemp)][1]
--			local worldX,worldY = oUnitGroup.data.worldX,oUnitGroup.data.worldY
--			local owner = oUnitGroup.data.owner
--			--���ﴴ��һ���µĵ�λ�滻��oUnit
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
--			--��ʼ������
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
--			--������´����ĵ�λ��ô�������һ�³����¼�
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

--���ߵ���
local __InitItemTemp = function(tList,temp,nDropQuality,nDropLevel)
	local c = 0
	for i = 1,#tList do
		local v = tList[i]
		--id���������ʣ���������������ȼ�����չ����ȼ�
		local iId,cBase,iQl,iLv,iEx = v[1],v[2],v[3],v[4],v[5]
		local chanceLv = 100
		local chanceQl = 100
		if nLv~=0 then
			--ÿ����Ʒ�ȼ���ཱུ�� 12%+�ȼ���^2 ���ּ��ʣ�����5�����ϵ�װ���������
			local dLv = math.max(0,math.abs(iLv - nDropLevel)-iEx)
			if dLv==0 then
				--ʲô������
			elseif dLv<=5 then
				chanceLv = math.max(0,chanceLv-dLv*12-dLv*dLv)
			else
				chanceLv = 0
			end
		end
		if iQl~=0 then
			--ÿ����Ʒ������ཱུ�� 2% ���ּ��ʣ�������೬��50���ϵ�װ���������
			local qLv = math.max(0,math.abs(iQl - nDropQuality))
			if qLv==0 then
				--ʲô������
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
	--�����ID,��������,��������,����ȼ�,����ȼ���չ
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

--�������ս�����ܿ�Ƭ
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
			--����ID,��������,���ս��������
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
	--����ID,��������,���ս��������,ս�����ڲ�ͬ�Ѷ��¶Ե���ȼ���Ӱ��(�Ǳ���ʹ��CombatRequire)
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
			--��ֵ����������
			nNumA = nNumA + hApi.random(1,hApi.floor((nNumB-nNumA)*(nDropQuality-100)/100))
			return hApi.floor(hApi.random(nNumA,nNumB+99)/100)
		else
			--��ֵ����������
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
					tList = hVar.tab_dropT[1]	--��������У�û�о͵���
					nDropQuality = v[2]
					tDropLv = v[4]
					tCombatRequire = v[3]
					break
				end
			end
		end
		--�жϵ�����ߵȼ�
		if type(tDropLv)=="table" then
			if oUnitD.data.owner~=1 and type(tDropLv[oUnitD.data.id])=="number" then
				nLvMax = tDropLv[oUnitD.data.id]
			else
				nLvMax = tDropLv[1] or 1
			end
		else
			nLvMax = 1
		end
		--����ս����
		if type(tCombatRequire)=="table" then
			local nCombatRequire = tCombatRequire[nDifficulty] or 99999999
			if nCombatPower>nCombatRequire and nCombatRequire>0 then
				--����ս������ǿ�Ĺ�����ս�����ܿ��ļ������,����Ϊ2*cBase(20 �� 100)
				cExtra = math.min(3*cBase,hApi.floor(cBase*nCombatPower/nCombatRequire)) - cBase
				--���ݵ�����������߸�Ʒ�ʿ�Ƭ�ĵ��伸�ʣ�35��(3������)���������ĸ���
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
			--������߿�Ƭ����ȼ�����
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

--�������ս����Ƭ(���ݿ���)
local __GetOneCard = function(nDropLv,tListEx)
	local tList = hVar.tab_dropT[1]		--���������б�
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
--���ս�����ܿ���5��1,5��3��
hApi.RandomTacticsIdFromPack = function(itemId)
	local rTab = {}
	local tempItem = {}
	local tacticConfig = hVar.TACTIC_RANDOM_CONFIG[itemId]
	
	--���ս�����ܿ�Ȩֵ���ü����ش��ڣ���������
	if tacticConfig and hVar.TACTIC_RANDOM_CONFIG.pool then
		
		local pool = {}
		
		--��ʽ�����أ�ȥ������������ս�����ܿ�
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
		
		--����Ȩֵ�������Ȩ�ص��ߵ������
		--��������Ʒ��
		local configIdx
		--����Ȩ�ط�Χ��ʱֵ
		local tmpTacticInfo = {}
		--��Ȩֵ
		local sumWeight = 0
		
		--��������Ȩ����Ϣ����¼ÿһ������Ȩ�ط�Χ�������ܵ�Ȩ��
		for i, randomInfo in pairs(tacticConfig) do
			local weight = randomInfo[1] or 0
			if weight > 0 then
				tmpTacticInfo[i] = {}
				tmpTacticInfo[i].min = sumWeight
				sumWeight = sumWeight + weight
				tmpTacticInfo[i].max = sumWeight
			end
		end
		
		--����Ȩ�ط�Χ�����
		local rWeight = hApi.random(1, sumWeight)
		
		--����Ȩ�ط�Χ��ʱֵ,�����Ȩֵ�����ĸ�����
		for i, weightInfo in pairs(tmpTacticInfo) do
			if rWeight > weightInfo.min and rWeight <= weightInfo.max then
				configIdx = i
				break
			end
		end
		
		--������ڵ������������б�����е���
		if configIdx and tacticConfig[configIdx] and tacticConfig[configIdx][2] then
			--���������б�
			local tabDropNums = tacticConfig[configIdx][2]
			--��������
			local maxDrop = 5
			--��ǰ������
			local dropNow = 0
			
			--����ÿһ������
			for i = 1, #tabDropNums do
				--��ǰ��������������������������ж�ѭ��
				if dropNow >= maxDrop then
					break
				end
				--������
				local dropNum = tabDropNums[i] or 0
				--��ʼ����
				for n = 1, dropNum do
					
					--��ǰ��������������������������ж�ѭ��
					if dropNow >= maxDrop then
						break
					end
					
					--��ǰ�ȼ��ĵ����б�
					local tacticInfos = pool[i]
					--��������б��е�����
					local tacticIdx = hApi.random(1, #tacticInfos)
					
					--���������Ϣ���ڣ�����ӽ�������
					if tacticIdx and tacticInfos[tacticIdx] and tacticInfos[tacticIdx][1] then
						local tacticId = tacticInfos[tacticIdx][1]
						local tacticLv = math.min((tacticInfos[tacticIdx][2] or 1), hVar.TACTIC_LVUP_INFO.maxTacticLv)
						tempItem[#tempItem + 1] = {tacticId, tacticLv}
						dropNow = dropNow + 1
					end
				end
			end
			
			--��������������㣬�������н��ز�ȫ����
			if dropNow < maxDrop then
				for n = 1, maxDrop - dropNow do
					--��ǰ��������������������������ж�ѭ��
					if dropNow >= maxDrop then
						break
					end
					
					for i = 1, #pool do
						--��ǰ�ȼ��ĵ����б�
						local tacticInfos = pool[i]
						--��������б��е�����
						local tacticIdx = hApi.random(1, #tacticInfos)
						
						--���������Ϣ���ڣ�����ӽ�������
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
	
	--�������
	local temp = {}
	hApi.RandomIndex(#tempItem,5,temp)
	for i = 1,5 do
		local tacticInfo = tempItem[temp[i]]
		rTab[i] = tacticInfo --���ͣ�����ID���������֣����߳��ֵļ��ʣ�3����ѡ����
	end

	return rTab
end

--old zhenkira 2016.3.21
--hApi.RandomTacticsIdFromPack = function(itemId)
--	local rTab = {}
--	--��ȫ�����ʽѡ�����еĿ�Ƭ
--	if itemId==9101 then
--		local tListEx = hVar.tab_dropT[2]		--���������������
--		--��1�ŵİ������3~6Ʒ��
--		for i = 1,5 do
--			local rand = hApi.random(1,10)
--			local nDropLv = 1
--			if rand>=10 and rand<=10 then
--				--10%�ļ��ʻ��Ʒ��6�Ŀ�
--				local id,lv = __GetOneCard(6,tListEx)
--				rTab[#rTab+1] = {id,lv}
--			elseif rand>=7 and rand<=9 then
--				--30%�ļ��ʻ�ÿ������Ŀ�Ƭ�����5��
--				local id,lv = __GetOneCard(5,tListEx)
--				rTab[#rTab+1] = {id,lv}
--			else
--				--60%�ļ��ʻ�õȼ�3~4�Ŀ�Ƭ
--				local id,lv = __GetOneCard(hApi.random(3,4),tListEx)
--				rTab[#rTab+1] = {id,lv}
--			end
--		end
--	elseif itemId==9102 then
--		local tListEx = hVar.tab_dropT[3]		--�߼������������
--		--��3�ŵİ������5~7Ʒ��
--		for i = 1,5 do
--			local rand = hApi.random(1,10)
--			local nDropLv = 1
--			if rand>=9 and rand<=10 then
--				--20%�ļ��ʻ��Ʒ��7�Ŀ�
--				local id,lv = __GetOneCard(7,tListEx)
--				rTab[#rTab+1] = {id,lv}
--			elseif rand>=6 and rand<=8 then
--				--30%�ļ��ʻ��Ʒ��6�Ŀ�
--				local id,lv = __GetOneCard(6,tListEx)
--				rTab[#rTab+1] = {id,lv}
--			else
--				--50%�ļ��ʻ�õȼ�5�Ŀ�Ƭ
--				local id,lv = __GetOneCard(5,tListEx)
--				rTab[#rTab+1] = {id,lv}
--			end
--		end
--	end
--	return rTab
--end

--��������Ҫ�����׺���
function cheat01()

  --��Ǯ1000
  --����cooldown�ָ�, ���������춫��
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

	--���ǳ�Ǭ��Ҫ�����׹���
	local heros = hGlobal.LocalPlayer.heros
	for i = 1,#heros do
		local unit = heros[i]:getunit()
		if unit then
			--unit.data.team[6] = {10038,200}
			unit.data.team[5] = {10033,100}
			unit.data.team[6] = {10036,100}
			unit.data.team[7] = {11999,1}
		end
		--�Ӿ���
		heros[i]:addexp(99999)
		heros[i]:additembyID(8998,{3,0,0,0})---�վ�֮��
	end
	
	
	g_FPSUI_show = 0
	xlShowFPS(g_FPSUI_show)

	heroGameInfo.worldMap.ShowUnitsCombatScore(true)

	--���ӻ���
	LuaAddPlayerScore(1000)

	--������Ϸ��
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

function cheat02(team) --����Ҫ�����׹��� ��Ӳ���
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
--(�Ż�)���ȶ�����
--hApi.ObjectSetFacing = function()
--end

--hApi.ObjectPlayAnimation = function()
	--return 1000
--end

--hClass.unit.setanimation = function(self,aniKey,forceToPlay)
	--return -1
--end

-- SpriteSet����
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
--ѡ��һ��Ŀ���ƶ�����
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
		--����λ
		if selectR==1 then
			--����ѡ��
			for i = 1,#tGrid do
				local v = tGrid[i]
				if gridX==(v.x+1) and gridY==v.y then
					return v.x,v.y
				elseif gridX==v.x and gridY==v.y then
					selectI = i
				end
			end
		else
			--����ѡ��
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
		--һ��λ
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

--����һ�����߿��Զ���Ĵ���
hApi.CalculateItemRewardEx = function(itemID)
	local itemLv = hVar.tab_item[itemID].itemLv or 1
	if itemLv == 0 then
		itemLv = 1
	end
	local itemRulu = hVar.ITEM_ENHANCE_NUM[itemLv]
	
	local m = 0
	--�ȵõ��ܸ���
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
--�����߸�Ӣ��
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
		--����һ������ΨһID
		if tabI.type==hVar.ITEM_TYPE.DEPLETION then
			oItemToPick = hApi.CreateItemObjectByID(itemID,nil,nil,fromlist)
		elseif type(tabI.continuedays)=="number" then
			--ʱ���͵���
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
--�������߶���ID(����id, ���߸��Ӽ�ֵ����, )
hApi.CreateItemObjectByID = function(itemID,rewardEx,info,fromlist,exValueRatio,entity,quality)
	--���ɵ�����չ����
	local tabI = hVar.tab_item[itemID] or {}
	local itemLv = tabI.itemLv or hVar.ITEM_QUALITY.WHITE
	local itemValue = tabI.itemValue or 1

	if entity then
		--ID = 1,			--��ƷID
		--NUM = 2,		--����
		--SLOT = 3,		--�����{����������1������2...��n}
		--PICK = 4,		--ʰȡʱ��{��Ϸ�ڵ���������������}
		--VERSION = 5,		--��õ��ߵİ汾��
		--UNIQUE = 6,		--��ƷΨһID
		--QUALITY = 7,		--��Ʒ�Ƿ��װ��(����ȼ�����)
		--LOCK = 8,		--������ ������� ��û�ж���������ʱ ����Ϊ0����������Ϊ1 9 ������Դ
		--FROM = 9,		--��Դ׷��
		--UNKNOW = 10,
		--XILIAN_COUNT = 11, --��������ϴ������
		--XILIAN_DATE = 12, --��������ϴ���������һ�ε����ڣ��ַ�����������ʱ�䣩
		local item_uniqueID = hApi.GetItemUniqueID(g_curPlayerName,g_localfilepath)
		return {itemID,1,entity.attr,info or 0,"",item_uniqueID,quality,1,{{hVar.ITEM_FROMWHAT_TYPE.NET,entity.dbid,entity.slotnum,0}},0,0,0,
			entity.randIdx1,entity.randVal1,entity.randIdx2,entity.randVal2,entity.randIdx3,entity.randVal3,entity.randIdx4,entity.randVal4,entity.randIdx5,entity.randVal5,
			entity.randSkillIdx1,entity.randSkillLv1,entity.randSkillIdx2,entity.randSkillLv2,entity.randSkillIdx3,entity.randSkillLv3,}
	else
		--ֻ��װ�����������и�������
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

--��ȡװ���������
hApi.GetItemRandomAttr = function(attrR, excludeAttr)
	local baseAttrSet = hVar.ITEM_ATTR_QUALITY_DEF[attrR]

	--��ȡ���Գ�
	--���㣬����Ѿ���ȡ�����Բ��ٳ�ȡ
	local attrSet = {}
	for i = 1, #hVar.ITEM_ATTR_QUALITY_DEF[attrR] do
		local flag = true
		local baseAttr = hVar.ITEM_ATTR_QUALITY_DEF[attrR][i]
		for j = 1, #excludeAttr do
			local excludeAttr = excludeAttr[j]
			--�ų��Ѿ���ȡ������
			if hVar.ITEM_ATTR_VAL[baseAttr].attrAdd == hVar.ITEM_ATTR_VAL[excludeAttr].attrAdd then
				flag = false
				break
			end
		end
		if flag then
			attrSet[#attrSet + 1] = baseAttr
		end
	end
	
	--һ����������ƣ�������������е����Զ��Ѿ�����������򽱳ص��ڻ�������
	if #attrSet <= 0 then
		attrSet = baseAttrSet
		print("attr pool is null.")
	end
	--local attrSet = hVar.ITEM_ATTR_QUALITY_DEF[attrR]
	if #attrSet > 0 then
		--�����������
		local attrIdx = hApi.random(1,#attrSet)
		--�����������
		local attr = attrSet[attrIdx]
		if hVar.ITEM_ATTR_VAL[attr] then
			excludeAttr[#excludeAttr+1] = attr
			print("item get attr:",attr)
			return attr
		end
	end
end

--����������չ����(����Ʒ�ʵȼ������߻�����ֵ�����߸������Ա���)
hApi.CreateItemAttrEx = function(itemLv, itemValue, exValueRatio)
	local ret = -1
	--������
	local holeMax = hVar.ITEM_ATTR_EX_LIMIT[itemLv] or 0

	if holeMax > 0 then
		local hole = math.floor(exValueRatio / 5)
		local randomAttrFlag = false
		
		--����ض������Ŀ������ڵ��ڵ��߿ɲ�������
		if hole >= holeMax then
			hole = holeMax
		else
			--���С�ڣ�����Ҫ����ʣ���ֵ�Ƿ��ܹ��ٳ�һ���¿�
			randomAttrFlag = true
		end
		
		--����س����ڵ��������
		ret = {}
		local excludeAttr = {}
		--����ÿһ���ף��������
		for i = 1, hole do
			--�������Ʒ��
			local attrR = hApi.random(1,5) --������Ե�Ʒ��
			local attr = hApi.GetItemRandomAttr(attrR, excludeAttr)
			if attr then
				ret[#ret+1] = attr
			end
		end
		
		--����ʣ���ֵ�����Ƿ��ܹ��ٳ�һ����
		if randomAttrFlag then
			--����ض������Ŀ���С�ڵ��߿ɲ�������
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
--			--��֪�����͵���Ʒ
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
		--�Ƿ����߲���װ��
		return 0
	elseif hVar.ITEM_EQUIPMENT_POS[tabI.type or 0]~=1 then
		--����װ���ĵ���
		return 0
	else
		return 1
	end
end

--��Ʒ�Ƿ���Ա�����
hApi.IsItemForgeable = function(oItem)
	if type(oItem) ~= "table" then
		return 0
	end
	local tabI = hVar.tab_item[oItem[hVar.ITEM_DATA_INDEX.ID]]
	if tabI==nil then
		--�Ƿ����߲��ܶ���
		return 0
	elseif hVar.ITEM_EQUIPMENT_POS[tabI.type or 0]~=1 then
		--ֻ�п�װ���ĵ��߲��ܱ�����
		return 0
	elseif type(oItem[hVar.ITEM_DATA_INDEX.PICK])=="table" and oItem[hVar.ITEM_DATA_INDEX.PICK][1]~=-1 then
		--��ʱ���߲��ɶ���
		return 0
	else
		return 1
	end
end

--��Ʒ�Ƿ���Ա��ֽ�
hApi.IsItemDecomposeable = function(oItem)
	if type(oItem) ~= "table" then
		return 0
	end
	local tabI = hVar.tab_item[oItem[hVar.ITEM_DATA_INDEX.PICK]]
	if tabI and tabI.itemLv==4 and tabI.unique==1 then
		--����(�׳���)��װ���ܱ��ֽ�
		return 0
	else
		return 1
	end
end

--��Ʒ�Ƿ���Ա���Ը(�׼�)
hApi.IsItemWishable = function(oItem)
	if type(oItem) ~= "table" then
		return 0
	end
	local tabI = hVar.tab_item[oItem[PICK]]
	if tabI and tabI.itemLv==4 and tabI.unique==1 then
		--����(�׳���)��װ���ܱ��ϳ�
		return 0
	else
		return 1
	end
end

--��ʽ����Ʒ
--������Ʒ��ʽ ����Ʒ����������8ʱ ���Ӷ����� ���� ������Ϊ1 ����״̬
--������Ʒ��ʽ ����Ʒ����������9ʱ ���ӵ�����Դ��
--������Ʒ��ʽ ����Ʒ��������10��ʱ ���Ӷ������count
hApi.FormatItemObject = function(oItem)
	if type(oItem) == "table" then
		--�ϰ汾�ĵ���û�а汾�ţ����������õ��߻�ð汾Ϊ��ǰ�汾��
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
		--oItem[hVar.ITEM_DATA_INDEX.ENABLE] = 0	--��������Ҫ�� �����е����ڳ�ʼ��ʱ��� �Ƿ���ñ������Ϊ0
	end
end


--�������ӵ�е�������Ʒ�����в���
--����ӿ�ֻ����û���������ͼ��ʱ�����
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

--����һ�������Ƿ��ʹ��
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

--����һ�����ߵĶ���������
hApi.SetItemForgedLock = function(item,Val)
	if type(item) == "table" then
		item[hVar.ITEM_DATA_INDEX.LOCK] = Val
		return 1
	end
	return 0
end

--�������� ����0 ��ʾ û������ ����1 ��ʾ����
hApi.CheckItemForgedLock = function(item)
	if type(item) == "table" then
		return item[hVar.ITEM_DATA_INDEX.LOCK] or 1
	end
	return 0
end


--------------------------------------------�ü�������صĺ���----------------------------------------------------------
--����Ӣ�ۿ�Ƭ�� �������ӵ� ���ڵ�
hApi.ReloadParent = function(childNode,ParentNode)
	childNode:retain()
	childNode:getParent():removeChild(childNode,true)
	ParentNode:addChild(childNode)
	childNode:release()
end

--�ڲü�������ƶ�ÿһ�� item ���� ���� 1,2 ���� x�� y�� ��ƫ������ ���� 3 4 ����һ�� ����� UI �ؼ� 
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

--�����ƶ������ item ����ʱ ���¼��� item �� �������꣬ ��Ϊ �� �ü���� �� ԭUI ��ϵ�У� ��������ǲ�ͬ�� ����ϵ������Ҫ��һ������
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

--�ֽ������Դ
--hApi.GetMatrialByDecomposeItem = function(oItem,rTab)
--	rTab = rTab or {}
--	local itemID = oItem[hVar.ITEM_DATA_INDEX.ID]
--	local itemLv = (hVar.tab_item[itemID].itemLv or 1)
--	--�����ĵ��߷ֽⲻ���κζ���
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
--		rTab[1] = (rTab[1] or 0) + hApi.random(1,5)							--ȡ1-5֮��������
--	elseif itemLv==2 then
--		rTab[1] = (rTab[1] or 0) + hApi.random(5,10)
--		rTab[2] = (rTab[2] or 0) + hApi.random(0,2)
--	elseif itemLv==3 then
--		--�ֽ��װ��3�ȼ���	changed by pangyong 2015/4/22
--		if hVar.DecomposeMat3[itemID] ~= nil then 
--			rTab[1] = (rTab[1] or 0) + hApi.random( hVar.DecomposeMat3[itemID][1][1], hVar.DecomposeMat3[itemID][1][2] )
--			rTab[2] = (rTab[2] or 0) + hApi.random( hVar.DecomposeMat3[itemID][2][1], hVar.DecomposeMat3[itemID][2][2] )
--			rTab[3] = (rTab[3] or 0) + hVar.DecomposeMat3[itemID][3][ hApi.random(1, #hVar.DecomposeMat3[itemID][3]) ]
--		elseif 1 == hVar.tab_item[itemID].elite then	
--			--��Ӣװ����ǣ�1:��Ӣ��ͼ�������	
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

--��� ս�����ܿ� ��ȡ������ �Ƿ�Ϸ�
hApi.CheckBFSCardIllegal = function(playerName)
	
	--�����windows�� �򲻼���
	local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
	if g_tTargetPlatform.kTargetWindows == TargetPlatform then
		return 0
	end
	
	local bfsCount = LuaGetBFSkillCardCount()
	local new_CardCount = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..playerName.."SkillCardCount")
	local synchronous_CardCount_val = xlGetIntFromKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."synchronous_CardCount_val")
	if bfsCount ~= new_CardCount  then
		xlAppAnalysis("cheat_bfskill",0,1,"info",tostring(xlPlayer_GetUID()).."-name:"..tostring(playerName).."-bfsCount:"..tostring(bfsCount).."-CardCount:"..tostring(new_CardCount).."-syncV"..tostring(synchronous_CardCount_val).."-T:"..tostring(os.date("%m%d%H%M%S")))
		--key�е�ֵС�ڴ浵�е�ֵ���Ҵ�δ����ͬ��ʱ���ô浵�е�ֵ����һ��ͬ��
		if new_CardCount < bfsCount then
			if synchronous_CardCount_val == 0 then
				xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."SkillCardCount",bfsCount)
				xlSaveIntToKeyChain(tostring(xlPlayer_GetUID())..tostring(luaGetplayerUniqueID())..g_curPlayerName.."synchronous_CardCount_val",1)
				return 
			end
		end
		LuaSetBFSkillCardCount(new_CardCount)

		--ֱ��ɾ����Ϸ�浵
		if hApi.FileExists(g_localfilepath..playerName..hVar.SAVE_DATA_PATH.MAP_SAVE,"full") then
			xlDeleteFileWithFullPath(g_localfilepath..playerName..hVar.SAVE_DATA_PATH.MAP_SAVE)
			xlDeleteFileWithFullPath(g_localfilepath..playerName..hVar.SAVE_DATA_PATH.FOG)
		end

		--��ǰ������������ ������� �б�
		if g_current_scene == g_world then
			--���������� ��ɾ��
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
		--�����Եĵ������ ����ҿ���...
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

--������ID �ĵ����Ƿ���Ҫʵ��
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

--�����ֱ����Ƿ�ﵽ�������� Ŀǰ����99 
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

--�����Ұ��������Ҫ����Ļ���������ӿڲ����Ի�
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
			--��Ҫ��Դ����ʾ���
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
			--�ɹ������˶���
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

--����ͼ���� �Ƿ����� �ֻ���UI ���� �� ѡ���ͼVIP���ֵ�ͼ 
hApi.CheckMapNameIsPhoneCondition = function(MapName)
	for i = 1,#hVar.PHONE_Legal_MapName do
		if MapName == hVar.PHONE_Legal_MapName[i] then
			return 1
		end
	end
	return 0 
end

--����ս�����ؽ���ս��ʱ���ÿ�����ֵȼ��ĵ�λ�����Լ��������� 
-- {
--	[1] = {10,5}	--1��������ս��10��������5��
--	[2] = {20,20}	--2��������20��������20��
-- }
hApi.CountUnitLvLost = function(oWorld,oPlayer,lostTeam)
	local nMyOwner = oPlayer.data.playerId
	local tMyHeroIndex = {}
	local nHeroCount = 0
	local nHeroDeadCount = 0
	local nMyArmyPower = 0
	local nMyArmyLostPower = 0

	--�ȴ���־���ҵ�Ӣ���볡��Ϣ
	for i = 1,oWorld.__LOG.i do
		local v = oWorld.__LOG[i]
		if v.key=="hero_round1" and v.unit.owner==nMyOwner and v.unit.indexOfTeam~=0 then
			tMyHeroIndex[v.unit.indexOfTeam] = 1
			nHeroCount = nHeroCount + 1
		end
	end

	--ͳ���ҷ�������ս����
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

	--ͳ��Ӣ������,��λ��ʧ��Ϣ
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

--����ս�������� Ӣ�۽���ս������Ѫ�����Լ��뿪ս��ʱ���ʣ��Ѫ��
hApi.CalcHeroMaxHPAndLastHP = function(oWorld,oPlayer)
	local nMyOwner = oPlayer.data.playerId
	local tMyHeroIndex = {}
	local nMyHeroMxHp = 0
	local nMyHeroMxMp = 0
	--�ȴ���־���ҵ�Ӣ�۳�ʼѪ����ħ��ֵ��
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

	--�����˺������ƹ������۳���Ӣ��Ѫ����ħ��ֵ
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

--����ս����������ɵ����˺�ֵ���Լ�����ֵ
hApi.CountDPSAndHPS = function(oWorld,oPlayer)
	local hps = 0		--��������
	local dps = 0		--���˺�

	local hps_over = 0	--ʵ����ɵ�����
	local dps_over = 0	--ʵ����ɵ��˺�

	local Max_hps = 0	--������ɵ��������
	local Max_dps = 0	--������ɵ�����˺�

	local nOwner = oPlayer.data.playerId
	for i = 1,oWorld.__LOG.i do
		local v = oWorld.__LOG[i]
		--ͳ�� �Բ��� ��ɵ� HPS
		if (v.key=="hero_healed" or v.key=="unit_healed") and v.unit.owner==nOwner and v.id ~= 1 then
			local nHeal = -1*v.dmg
			hps = hps + nHeal
			hps_over = hps_over - v.dhp
			if nHeal > Max_hps then
				Max_hps = nHeal
			end
		end

		--ͳ�� �Եз�������ɵ� DPS
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
		oPlayer = hGlobal.player[-1]	--��������0����ô������ת��Ϊ���-1����Ϊ���������ս���ϵĵ�λ�����������-1�ģ����0�ĵ�λ��ս���ϻ��н����жϵ����⣩
	end
	for i = 1,oWorld.__LOG.i do
		local v = oWorld.__LOG[i]
		--������ʿ��(Ӣ����Ϊ�Ƚ������������ĵط�ͳ��)
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
		
		--�ǹ���ս
		if v.key == "Town" then
			BattlefieldType = v.Town.ID
		end
		
		--����
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
	--��ͨ�����Ƹ���ĵ�λ����ʧ�б����Ƴ�
		local v = oWorld.__LOG[i]
		if v.key=="unit_healed" then
			for k,v1 in pairs(lostTemp) do
				if k == v.target.id then
					lostTemp[k] = v1 - v.revive
				end
			end
		end
	end

	--ͳ��Ӣ������
	for i = 1,oWorld.__LOG.i do
		local v = oWorld.__LOG[i]
		--������Ӣ��
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
					tArmy[i] = {t[1],t[2],0,0}	--id,num,����ʩ�Ŵ���,��������
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
					--��¼Ӣ��Ѫ��
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

--�������ǿ������
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

----����װ���ӿ�
--hApi.ForgeItem = function(oHero,vOrderId,tradeid)
--	if type(vOrderId) ~= "table" then return end
--	local fromType = vOrderId[1]
--	local fromIndex = vOrderId[2]
--	local tPlayerData = LuaGetPlayerData()
--	
--	if type(oHero)~="table" then
--		--�����ڷ��������Ӣ��
--		_DEBUG_MSG("[LUA WARNING]��Ӣ�۵Ķ��������ֹ����")
--		return false
--	elseif oHero.data.HeroCard~=1 and fromType~="playerbag" then
--		_DEBUG_MSG("[LUA WARNING]��Ӣ�ۿ�Ƭ��Ӣ��ֻ�ܶ���ұ����е���Ʒ���ж���")
--		return false
--	elseif type(tPlayerData.mat)~="table" then
--		--��ҵĲ��ϱ�����
--		_DEBUG_MSG("[LUA WARNING]��Ҳ��ϱ����ڣ��޷�����")
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
--		--�����ж���Ҳ����Ƿ� ���ϲ������ܶ���
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
--		--��������ϵ�װ������ô�ȼ�¼һ�¶���֮ǰ������
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
--					--������ұ��еĲ�����
--					
--					for n = 1,#tPlayerData.mat do
--						LuaSetPlayerMaterial(n,LuaGetPlayerMaterial(n) - (itemMat[n] or 0))
--						
--					end
--					SendCmdFunc["Add_forged_mat_val"](luaGetplayerDataID(),0,(itemMat[1] or 0),(itemMat[2] or 0),(itemMat[3] or 0))
--					
--					--���ö������
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
--					_DEBUG_MSG("[LUA WARNING]����ʧ�ܣ�û�г��ֿ��õĶ�������")
--				end
--				break
--			end
--		end
--
--		--��� rewardEx �����һ�� Ϊ0 ��������� �������õ���Ϊ ����״̬
--		if oItem[hVar.ITEM_DATA_INDEX.SLOT][#oItem[hVar.ITEM_DATA_INDEX.SLOT]]==0 then
--			hApi.SetItemForgedLock(oItem,0)
--		else
--			hApi.SetItemForgedLock(oItem,1)
--		end
--		--����ɹ�����
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

--����װ���ӿ�
hApi.RecastItem = function(oHero,vOrderId)
	if type(vOrderId) ~= "table" then return end

	local fromType = vOrderId[1]
	local fromIndex = vOrderId[2]
	local RecastTable = vOrderId[3]
	local tPlayerData = LuaGetPlayerData()

	if type(oHero)~="table" then
		--�����ڷ��������Ӣ��
		_DEBUG_MSG("[LUA WARNING]��Ӣ�۵����������ֹ����")
		return false
	elseif oHero.data.HeroCard~=1 and fromType~="playerbag" then
		_DEBUG_MSG("[LUA WARNING]��Ӣ�ۿ�Ƭ��Ӣ��ֻ�ܶ���ұ����е���Ʒ��������")
		return false
	elseif type(tPlayerData.mat)~="table" then
		--��ҵĲ��ϱ�����
		_DEBUG_MSG("[LUA WARNING]��Ҳ��ϱ����ڣ��޷�����")
		return false
	end
	--����װ�����еĵ���
	local oItem = oHero:getbagitem(fromType,fromIndex)
	if oItem and type(oItem[hVar.ITEM_DATA_INDEX.SLOT])=="table" and type(oItem[hVar.ITEM_DATA_INDEX.SLOT][1])=="number" and oItem[hVar.ITEM_DATA_INDEX.SLOT][1]>0 then
		local tTempAttr = {}
		local IsMeetRequire = 0
		local IsUpdateAttr = 0
		--��������ϵ�װ������ô�ȼ�¼һ�¶���֮ǰ������
		if fromType=="equip" then
			IsMeetRequire = hApi.IsAttrMeetEquipRequire(oHero, oHero.attr,oItem[hVar.ITEM_DATA_INDEX.ID])
			if IsMeetRequire==1 then
				hApi.GetEquipmentAttr(0,oItem[hVar.ITEM_DATA_INDEX.SLOT],tTempAttr,-1)
			end
		end
		if RecastTable == nil then
			--ȫ����������
			for i = 2,oItem[hVar.ITEM_DATA_INDEX.SLOT][1]+1 do
				oItem[hVar.ITEM_DATA_INDEX.SLOT][i] = 0
			end
		else
			--������������
			for i = 1,#RecastTable do
				if RecastTable[i]+1 >= 2 and RecastTable[i]+1 <= oItem[hVar.ITEM_DATA_INDEX.SLOT][1]+1 then
					oItem[hVar.ITEM_DATA_INDEX.SLOT][RecastTable[i]+1] = 0
				end
			end
			--�ǵðѱ��������Լӻ�ȥ
			if IsMeetRequire==1 then
				hApi.GetEquipmentAttr(0,oItem[hVar.ITEM_DATA_INDEX.SLOT],tTempAttr,1)
			end
		end
		--�Ƴ�������������
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

--�ֽ�װ��
hApi.RecastItemDecomposeItem = function(oHero,vOrderId)
	if type(vOrderId) ~= "table" then return end
	local fromType = vOrderId[1]
	local case = type(vOrderId[2])
	local tPlayerData = LuaGetPlayerData()
	
	if type(oHero)~="table" then
		--�����ڷ��������Ӣ��
		_DEBUG_MSG("[LUA WARNING]��Ӣ�۵ķֽ������ֹ����")
		return false
	--elseif oHero.data.HeroCard~=1 and fromType~="playerbag" then
		--���Էֽ⣬���ǲ�������
		--_DEBUG_MSG("[LUA WARNING]��Ӣ�ۿ�Ƭ��Ӣ��ֻ�ܶ���ұ����е���Ʒ���зֽ�")
		--return false
	elseif type(tPlayerData.mat)~="table" then
		--��ҵĲ��ϱ�����
		_DEBUG_MSG("[LUA WARNING]��Ҳ��ϱ����ڣ��޷��ֽ�")
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
					--��ʱ���߷ֽ���ܻ���κβ���
				elseif oHero.data.HeroCard~=1 and fromType~="playerbag" then
					--��ӵ�п�Ƭ��Ӣ�۷ֽ��κ���ұ��������װ����������
				else
					--һ����߷ֽ⣬���������Դ
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
				--��ʱ���߷ֽ���ܻ���κβ���
			elseif oHero.data.HeroCard~=1 and fromType~="playerbag" then
				--��ӵ�п�Ƭ��Ӣ�۷ֽ��κ���ұ��������װ����������
			else
				--һ����߷ֽ⣬���������Դ
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

--�������ս������ͼ
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
--ֻͨ����ƷID ����������Ʒ�б�
hApi.UseChestItem = function(itemID)
	
	--��ý���
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
	
	--�������ز�������ĵ���
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

	--�жϵ����Ƿ���8��,������ͽ�����ĵ��߲���
	if #tempItem < tempDrop.maxDrop then
		for i = 1, tempDrop.maxDrop - #tempItem do
			local pool = tempDrop.pool[1]
			if #pool > 0 then
				local rIdx = hApi.random(1, #pool)
				tempItem[#tempItem + 1] = pool[rIdx]
			end
		end
	end
	
	--�������г���ĵ��ߣ�ȥ������8���Ĳ���
	local temp = {}
	hApi.RandomIndex(#tempItem,tempDrop.maxDrop,temp)

	for i = 1,tempDrop.maxDrop do
		local itemObj = tempItem[temp[i]]
		local itemID = itemObj[1]
		local itemExValueRatio = itemObj[2] or 0
		rewardlist[i] = {ex,itemID,hVar.tab_stringI[itemID][1],0,itemExValueRatio,0,0} --���ͣ�����ID���������֣����߳��ֵļ��ʣ�3����ѡ����
	end

	return rewardlist
end

--old zhenkira 2016.3.11
--ֻͨ����ƷID ����������Ʒ�б�
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
--				--���������ˣ�
--				tempItem[#tempItem+1] = id
--			else
--				--���ɶ��û�������Ļ��������ȼ�0�Ķ�������
--				tempItem[#tempItem+1] = hVar.TokenRandomItem[hApi.random(1,#hVar.TokenRandomItem)]
--			end
--		end
--	end
--	local temp = {}
--	hApi.RandomIndex(#tempItem,8,temp)
--	for i = 1,8 do
--		local itemID = tempItem[temp[i]]
--		rewardlist[i] = {ex,itemID,hVar.tab_stringI[itemID][1],0,0,0,0} --���ͣ�����ID���������֣����߳��ֵļ��ʣ�3����ѡ����
--	end
--
--	return rewardlist
--end

--�жϽ�������ID �Ƿ�Ϸ�
hApi.CheckPrizeType = function(prizetype)
	for i = 1,#hVar.LEGALPRIZE_TYPE do
		if prizetype == hVar.LEGALPRIZE_TYPE[i] then
			return 1
		end
	end
	return 0
end

--�����ַ��������
hApi.UnpackPrizeDataEx = function(str,mode)
	if type(str) ~= "string" then return end

	local itemID,itemNum,coin,score,itemHole,itemLv = 0,1,0,nil,nil,1
	local itemName,GiftTip,GiftTip_Ex= hVar.tab_string["__TEXT_noAppraise"],"",""
	local itemBack,itemModel,giftType = 0,"",0

	--������
	if string.find(str,"i:") then
		--װ�������
		if string.find(str,"h:") then
			itemID = tonumber(string.sub(str,string.find(str,"i:")+2,string.find(str,"n:")-1))
			itemNum = tonumber(string.sub(str,string.find(str,"n:")+2,string.find(str,"h:")-1))
			itemHole = tonumber(string.sub(str,string.find(str,"h:")+2,string.len(str)))
		--�������
		else
			itemID = tonumber(string.sub(str,string.find(str,"i:")+2,string.find(str,"n:")-1))
			itemNum = tonumber(string.sub(str,string.find(str,"n:")+2,string.len(str)))
		end
		itemName = hVar.tab_stringI[itemID][1] or hVar.tab_string["__TEXT_noAppraise"]
		itemLv = hVar.tab_item[itemID].itemLv or 1
		--��Ƭȡ��Ƭicon
		if itemID >= 9300 and itemID <= 9305 then
			itemModel = hVar.tab_item[itemID].chip
		else
			itemModel = hVar.tab_item[itemID].icon
		end
		itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL

		--����������߼�
		if mode == 1 then
			--�����װ��
			if hVar.tab_item[itemID].type >= 2 and hVar.tab_item[itemID].type <= 7 then
				local rewardEx = -1
				if type(itemHole) == "number" then
					--�������Ϊ0 ���������������
					if itemHole == 0 then
						local nSlotNum = hApi.CalculateItemRewardEx(itemID)
						rewardEx = hApi.NumTable(nSlotNum+1)
						rewardEx[1] = nSlotNum
					--�������ָ������
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
			--����Ƕ������
			elseif hVar.tab_item[itemID].type == hVar.ITEM_TYPE.PLAYERITEM then
				local matVal = hVar.tab_item[itemID].matVal
				--���ϵ��� ֱ��������Ҳ���
				if matVal then
					LuaSetPlayerMaterial(matVal[1],LuaGetPlayerMaterial(matVal[1])+matVal[2]*itemNum)
				end
			end
		end
	--��Ϸ��
	elseif string.find(str,"c:") then
		itemID = 27
		coin = tonumber(string.sub(str,3,string.len(str)))
		itemNum = coin
		itemName = hVar.tab_stringI[itemID][1] or hVar.tab_string["__TEXT_noAppraise"]
		itemLv = hVar.tab_item[itemID].itemLv or 1
		itemModel = hVar.tab_item[itemID].icon
		itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL
	--����
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
		
		--��������
		if mode == 1 then
			LuaAddPlayerScore(score)
		end
	--Ӣ����
	elseif string.find(str,"h:") then
		itemID = tonumber(string.sub(str,3,string.len(str)))
		itemBack = "UI_frm:slot"
		giftType = 1
		itemName = hVar.tab_stringU[itemID][1]..hVar.tab_string["__TEXT_Card"]
		itemModel = hVar.tab_unit[itemID].icon

		--��Ӣ����
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
	--ս����
	elseif string.find(str,"b:") then
		itemID = tonumber(string.sub(str,string.find(str,"b:")+2,string.find(str,"n:")-1))
		itemNum = tonumber(string.sub(str,string.find(str,"n:")+2,string.find(str,"l:")-1))
		itemLv =  tonumber(string.sub(str,string.find(str,"l:")+2,string.len(str)))
		GiftTip = hVar.tab_stringT[itemID][itemLv]
		giftType = 2
		itemModel = hVar.tab_tactics[itemID].icon
		itemName = hVar.tab_stringT[itemID][1] or hVar.tab_string["__TEXT_noAppraise"]
		itemName = itemName.." Lv : "..itemLv
		--��ս����
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

--�����콱����
hApi.UnpackPrizeData = function(prizetype,prizeid,prizecode)
	--print("UnpackPrizeData", prizetype,prizeid,prizecode)
	local itemID,itemNum,coin,score = 0,1,0,nil
	local itemName,GiftTip,GiftTip_Ex,exNum,exY,exG= hVar.tab_string["__TEXT_noAppraise"],"","",nil,nil,nil
	local itemBack,itemModel = 0,""
	local itemHole = nil
	local giftType = 0
	--print(prizecode)
	--����׳影���Ľ���
	if prizetype == 1030 or prizetype == 1031 or  prizetype == 1032 or prizetype == 1033 or prizetype == 1034 or prizetype == 1035 then
		--������µĸ�ʽ
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
		--������µĸ�ʽ2
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
		--�ϸ�ʽ
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
		--������µĸ�ʽ3
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
		--Ӣ����Ľ���
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
		--�Ƽ�����Ϸ�ҽ���
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
		--�ϸ�ʽ�ĵ��߲���
		if string.find(prizecode,";") == nil then
			if string.find(prizecode,"i:") ~= nil then
				itemID = tonumber(string.sub(prizecode,string.find(prizecode,"i:")+2,string.find(prizecode,"n:")-1))
				itemNum = tonumber(string.sub(prizecode,string.find(prizecode,"n:")+2,string.len(prizecode)))
				if string.find(prizecode,"h:") ~= nil then
					itemHole = tonumber(string.sub(prizecode,string.find(prizecode,"h:")+2,string.len(prizecode)))
				end
			end
		elseif string.find(prizecode,";") ~= nil then
		--�¸�ʽ�ĵ��߲��� ���� ; ������
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
	--���۽���
	elseif prizetype == 18 then
		itemModel = "UI:game_coins"
		itemBack = 0
		GiftTip = hVar.tab_stringGIFT[3][1] .. hVar.tab_string["__Reward__"] --"֧����Ϸ����"
		
		local tempStr = {}
		for content in string.gfind(prizecode,"([^%;]+);+") do
			tempStr[#tempStr+1] = content
		end
		coin = tonumber(string.sub(tempStr[1],3,string.len(tempStr[1])))
		score = tonumber(string.sub(tempStr[2],3,string.len(tempStr[2])))
	--�Ƽ�����
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
	--�������
	elseif prizetype == 100 then
		itemModel = "UI:game_coins"
		itemBack = 0
		GiftTip = hVar.tab_stringGIFT[2][1] .. hVar.tab_string["__Reward__"] --"�����������"
		
		local tempStr = {}
		for content in string.gfind(prizecode,"([^%;]+);+") do
			tempStr[#tempStr+1] = content
		end
		coin = tonumber(string.sub(tempStr[1],3,string.len(tempStr[1])))
		score = tonumber(string.sub(tempStr[2],3,string.len(tempStr[2])))
	--ÿ�ս���
	elseif prizetype == 9 then
		itemModel = "UI:game_coins"
		itemBack = 0
		GiftTip = hVar.tab_stringGIFT[1][1] --"ÿ�ս���"
		
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
	--��װ����
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
		--�����ܶ�
		if string.find(prizecode,"M:") then
			_,_,exNum = string.find(prizecode,"M:(%d+);")
		end
		--����Y����
		if string.find(prizecode,"Y:") then
			_,_,exY = string.find(prizecode,"Y:(%d+);")
		end
		--������λ
		if string.find(prizecode,"G:") then
			exG = string.sub(prizecode,string.find(prizecode,"G:")+2,string.len(prizecode))
		end
	--΢���¿�
	elseif prizetype == 5000 then
		if string.find(prizecode,"c:") ~= nil then
			coin = tonumber(string.sub(prizecode,3,string.len(prizecode)-1))
		end
		itemModel = "UI:game_coins"
		itemNum = coin
		GiftTip = hVar.tab_string["__TEXT_GetItem6"]
		itemName = hVar.tab_string["ios_gamecoin"]
	--��װ��Ƭ
	elseif prizetype >= 9300 and prizetype <= 9305 then
		itemID = prizetype
		itemModel = hVar.tab_item[itemID].chip
		itemNum = (tonumber(prizecode) or 1)
		local itemLv = (hVar.tab_item[itemID].itemLv or 1)
		itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL
		GiftTip = hVar.tab_stringI[itemID][7]
		itemName = hVar.tab_stringI[itemID][6]
	--VIP8 �Ľ��� Ŀǰ����1�Ŷ�׿Ӣ���� 2��ս����
	elseif prizetype == 6008 then
		if type(prizecode) == "string" then
			--Ӣ����Ľ���
			if string.find(prizecode,"h:") then
				itemID = tonumber(string.sub(prizecode,3,string.len(prizecode)))
				itemModel = hVar.tab_unit[itemID].icon
				itemNum = 1
				GiftTip = hVar.tab_stringU[itemID][4]
				itemBack = "UI_frm:slot"
				giftType = 1
			--ս�����Ľ���
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
	--ս�����ܿ�
	elseif prizetype == 7 then
		if type(prizecode) == "string" then
			local itemId = tonumber(string.sub(prizecode,string.find(prizecode,"bfs:")+4,string.find(prizecode,"lv:")-1))
			local itemLv = tonumber(string.sub(prizecode,string.find(prizecode,"lv:")+3,string.find(prizecode,"n:")-1))
			local itemNumber = tonumber(string.sub(prizecode,string.find(prizecode,"n:")+2,string.len(prizecode)))
			--ʵ�����ӿ��Ƶ�����
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
		
	--Ӣ����
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
		local ranking = tonumber(tCmd[1]) --����
		local billboardId = tonumber(tCmd[2]) --���а�id
		local strDate = tCmd[3] --����
		local reward = {}
		for i = 4, #tCmd do
			reward[#reward + 1] = tCmd[i]
		end
		itemModel = "UI:GIFT"
		--GiftTip = "2016-07-28�ƽ�������n������" --�ʼ����� --language
		local mapName = hVar.BILL_BOARD_MAP[billboardId].mapName
		GiftTip = strDate .. hVar.tab_stringM[mapName][1] .. hVar.tab_string["__TEXT_WORD_DI"] .. ranking .. hVar.tab_string["__TEXT_WORD_MING"] .. hVar.tab_string["__Reward__"] --�ʼ����� --language
	elseif (prizetype == 20002) then --�Ƽ���20��Ϸ���콱
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		for i = 1, #tCmd do
			reward[#reward + 1] = tCmd[i]
		end
		itemModel = "UI:game_coins"
		GiftTip = hVar.tab_string["rec_m_new_2"] --���Ƽ���������Ϊ�Ƽ��ˣ�����20��Ϸ�ҡ�
	elseif (prizetype >= 20003) and (prizetype <= 20007) then --�Ƽ��콱
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		for i = 1, #tCmd do
			reward[#reward + 1] = tCmd[i]
		end
		itemModel = "UI:GIFT"
		GiftTip = hVar.tab_string["rec_m_new_3"] .. hVar.tab_string["__TEXT_WORD_DI"] .. (prizetype - 20002) .. hVar.tab_string["__TEXT_WORD_DANG"] --"���Ƽ���������x��"
	elseif (prizetype == 20008) or (prizetype == 20009) then --��콱
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
		
		--�����ʾ�ر��ͼ��
		--print("���", string.find(tostring(tCmd[1]), "���"))
		if (string.find(tostring(tCmd[1]), "���") ~= nil) then
			itemModel = "UI:hongbao"
		end
		
		if (string.find(tostring(tCmd[1]), "������������") ~= nil) then
			itemModel = hVar.tab_item[9919].icon
		end
		
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"���������"
		--GiftTip = hVar.tab_string["["].. tostring(tCmd[1]) .. hVar.tab_string["]"] --"���������"
		GiftTip = tostring(tCmd[1]) --"���������"
	elseif (prizetype >= 1900 and prizetype < 2000) then --һ���Է�����
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
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"���������"
		local strRewardTitle = ""
		if (prizetype == 1900) then --"��ͨ ��԰���� ��������Ȧ����"
			strRewardTitle = hVar.tab_string["__TEXT_ShareSNS_MAP_001"]
		elseif (prizetype == 1901) then --"��ͨ ��Ԯ���� ��������Ȧ����"
			strRewardTitle = hVar.tab_string["__TEXT_ShareSNS_MAP_002"]
		elseif (prizetype == 1902) then --"��ͨ ����ƽ� ��������Ȧ����"
			strRewardTitle = hVar.tab_string["__TEXT_ShareSNS_MAP_003"]
		end
		
		--GiftTip = hVar.tab_string["["].. strRewardTitle .. hVar.tab_string["]"] --"���������"
		GiftTip = strRewardTitle --"���������"
	elseif (prizetype == 20010) then --VIP5һ���Խ���
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
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"���������"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"��VIP��"
	elseif (prizetype == 20011) then --VIP6һ���Խ���
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
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"���������"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"��VIP��"
	elseif (prizetype == 20012) then --VIP7һ���Խ���
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
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"���������"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"��VIP��"
	elseif (prizetype == 20013) then --VIP8һ���Խ���
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
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"���������"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"��VIP��"
	elseif (prizetype == 20014) then --VIP7һ���Խ���2
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
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"���������"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"��VIP��"
	elseif (prizetype == 20015) then --VIP8һ���Խ���2
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
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"���������"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"��VIP��"
	elseif (prizetype == 20016) then --vip8һ���Խ���3(��ױ�һ�ȯ*3, ���޺�����)
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
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"���������"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"��VIP��"
	elseif (prizetype == 20017) then --VIP3һ���Խ���
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
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"���������"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"��VIP��"
	elseif (prizetype == 20018) then --VIP4һ���Խ���
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
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"���������"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"��VIP��"
	elseif (prizetype == 20020) then --vip7����ÿ��2000����
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
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"���������"
		GiftTip = hVar.tab_string["vipOneOffReward"..prizetype] --"��VIP��"
	elseif (prizetype == 20028) then --�������鿨�ཱ��
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
		
		--Ĭ��ͼ������ɫ���ӣ�������������������ô�滻�ɽ�����
		--�����ۼ�����10000��Ϸ�һ����;13:1:1:10_12008_4_0|10_11082_4_0|10_12409_4_0;
		if (type(reward[1] == "string")) then
			local card = hApi.Split(reward[1], ":")
			local cardList = hApi.Split(card[4], "|")
			local totalCardNum = #cardList --�鿨������
			for i = #cardList, 1, -1 do
				if (#cardList[i] == 0) then --��ֹ���һ���ǿձ�
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
			
			--����Ƿ��������
			local bExistedRedEquip = false
			for i = 1, totalCardNum, 1 do
				local rewardT = cardList[i]
				local rewardType = tonumber(rewardT[1]) --��������
				if (rewardType == 10) then --10:��װ����
					bExistedRedEquip = true --�ҵ���
					itemModel = "ui/chest_8.png"
					break
				end
			end
			
			--����������ս������Ƭ����ô�滻�ɽ����
			local bExistedTacticDerbris = false
			if (not bExistedRedEquip) then
				--����Ƿ����ս������Ƭ
				for i = 1, totalCardNum, 1 do
					local rewardT = cardList[i]
					local rewardType = tonumber(rewardT[1]) --��������
					if (rewardType == 6) then --6:ս�����ܿ���Ƭ
						bExistedTacticDerbris = true --�ҵ���
						itemModel = "icon/item/card_lv3.png"
						--itemName = hVar.tab_string["TacticCardRow"] .. hVar.tab_string["__TEXT_ITEM_TYPE_GIFTITEM"] --"ս�����"
						
						--����Ƿ���������Ϊ���������
						local itemId = tonumber(rewardT[2]) --ս��������id
						local tabI = hVar.tab_item[itemId] or {}
						local tacticID = tabI.tacticID or 0
						local tabT = hVar.tab_tactics[tacticID] or {}
						local tabTType = tabT.type
						if (tabTType == hVar.TACTICS_TYPE.TOWER) then
							itemModel = "UI:TOWERDERBIRS_GIFTCARD"
							--itemName = hVar.tab_string["__Attr_Hint_Led"] .. hVar.tab_string["__TEXT_SOLDIER_TOWER"] .. hVar.tab_string["__TEXT_ITEM_TYPE_GIFTITEM"] --"���������"
						end
						
						--����Ǳ��ֿ�����Ϊ���ֿ����
						if (tabTType == hVar.TACTICS_TYPE.ARMY) then
							itemModel = "ICON:Item_Treasure39"
							--itemName = hVar.tab_string["ArmyCardPage"] .. hVar.tab_string["__TEXT_ITEM_TYPE_GIFTITEM"] --"�������"
						end
						
						break
					end
				end
			end
			
			--������������װ����ô�滻��������
			local bExistedOrangeEquip = false
			if (not bExistedRedEquip) and (not bExistedTacticDerbris) then
				--����Ƿ������װ
				for i = 1, totalCardNum, 1 do
					local rewardT = cardList[i]
					local rewardType = tonumber(rewardT[1]) --��������
					local rewardId = tonumber(rewardT[2]) or 0 --����id
					if (rewardType == 3) then --3:����
						local tabT = hVar.tab_item[rewardId] or {}
						if (tabT.itemLv == hVar.ITEM_QUALITY.RED) then --��װ
							bExistedOrangeEquip = true --�ҵ���
							itemModel = "icon/item/random_lv2.png"
							break
						end
					end
				end
			end
			
			--����������Ӣ�۽��꣬��ô�滻�����
			local bExisteHeroDebris = false
			if (not bExistedRedEquip) and (not bExistedTacticDerbris) and (not bExistedOrangeEquip) then
				--����Ƿ����Ӣ�۽���
				for i = 1, totalCardNum, 1 do
					local rewardT = cardList[i]
					local rewardType = tonumber(rewardT[1]) --��������
					local rewardId = tonumber(rewardT[2]) or 0 --����id
					if (rewardType == 5) then --5:Ӣ�۽���
						bExisteHeroDebris = true --�ҵ���
						itemModel = "UI:HERODEBRIRS_GIFTCARD"
						--itemName = hVar.tab_string["__TEXT_ITEM_TYPE_SOULSTONE"] .. hVar.tab_string["__TEXT_ITEM_TYPE_GIFTITEM"] --"�������"
						
						--����Ƿ�����߼�Ӣ�۽���
						local itemId = tonumber(rewardT[2]) --ս��������id
						local tabI = hVar.tab_item[itemId] or {}
						local heroID = tabI.heroID or 0
						local pvp_only = false
						for h = 1, #hVar.HERO_AVAILABLE_LIST, 1 do
							if (hVar.HERO_AVAILABLE_LIST[h].id == heroID) then --�ҵ���
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
			
			--����������������Ƭ����ô�滻����
			local bExisteTreasureDebris = false
			if (not bExistedRedEquip) and (not bExistedTacticDerbris) and (not bExistedOrangeEquip) and (not bExisteHeroDebris) then
				--����Ƿ����������Ƭ
				for i = 1, totalCardNum, 1 do
					local rewardT = cardList[i]
					local rewardType = tonumber(rewardT[1]) --��������
					local rewardId = tonumber(rewardT[2]) or 0 --����id
					if (rewardType == 22) then --22:������Ƭ
						bExisteTreasureDebris = true --�ҵ���
						itemModel = "ICON:Item_Book05"
						--itemName = hVar.tab_string["__TEXT_ITEM_TYPE_ORNAMENTS"] .. hVar.tab_string["__TEXT_ITEM_TYPE_GIFTITEM"] --"�������"
						break
					end
				end
			end
			
			--�¿���ʾ�ر��ͼ��
			--print("�¿�", string.find(tostring(tCmd[1]), "�¿�"))
			--if (string.find(tostring(tCmd[1]), "�¿�") ~= nil) then
			if (string.find(tostring(tCmd[1]), hVar.tab_string["__TEXT_MONTHCARD"]) ~= nil) then
				itemModel = "UI:MONTHCARD_ICON"
			end
		end
		
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"���������"
		--GiftTip = hVar.tab_string["["].. tostring(tCmd[1]) .. hVar.tab_string["]"] --"���������"
		GiftTip = tostring(tCmd[1]) --"���������"
	elseif (prizetype == 20029) then --�޾���ͼ��һ��֪ͨ
		--�޾���ͼÿ�����н���;2018-10-15;2;58;logId;����1;����2;����3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --����
		local strDate = tostring(tCmd[2]) --����
		local rankId = tonumber(tCmd[3]) or 0 --���а�id
		local myRank = tonumber(tCmd[4]) or 0 --�ҵ�����
		local logId = tonumber(tCmd[5]) or 0 --��־id
		local reward = {} --����
		local rewardNum = 0 --��������
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
		
		--ͼ��
		if (rankId == 1) then --�޾�����(ƻ���汾)
			itemModel = "ICON:HeroAttr_str"
		elseif (rankId == 2) then --�޾�ɱ��(ƻ���汾)
			itemModel = "UI:MOTA"
		elseif (rankId == 3) then --�������ÿ����������
			itemModel = "UI:PVP_ONLY"
		elseif (rankId == 11) then --�޾�����(��׿�汾)��С�ס�9�Ρ�Ӧ�ñ���OPPO��VIVO��google��
			itemModel = "ICON:HeroAttr_str"
		elseif (rankId == 12) then --�޾�ɱ��(��׿�汾)��С�ס�9�Ρ�Ӧ�ñ���OPPO��VIVO��google��
			itemModel = "UI:MOTA"
		elseif (rankId == 21) then --�޾�����(��׿�汾)����Ϊ��
			itemModel = "ICON:HeroAttr_str"
		elseif (rankId == 22) then --�޾�ɱ��(��׿�汾)����Ϊ��
			itemModel = "UI:MOTA"
		elseif (rankId == 31) then --�޾�����(��׿�汾)���ٷ���taptap�����ο챬��Ԥ���汾YZYZ��
			itemModel = "ICON:HeroAttr_str"
		elseif (rankId == 32) then --�޾�ɱ��(��׿�汾)���ٷ���taptap�����ο챬��Ԥ���汾YZYZ��
			itemModel = "UI:MOTA"
		elseif (rankId == 5) then --��ս����
			itemModel = "UI:pvp_iron"
		end
		
		--�ʼ��Ĳ���ʱ��
		local yyyy = string.sub(strDate, 1, 4)
		local mm = string.sub(strDate, 6, 7)
		local dd = string.sub(strDate, 9, 10)
		local mailTime = hApi.GetNewDate(strDate .. " 23:59:59")
		
		--������ʱ��
		local localTimeZone = hApi.get_timezone() --��ñ��ص�ʱ��(GMT+?)
		local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --�뱱��ʱ���ʱ��
		local hostTime = hApi.GetNewDate(g_systime)
		hostTime = hostTime - delteZone * 3600 --������ʱ��(����ʱ��)
		
		--ʱ���(����ʱ��)
		local ts = hostTime - mailTime
		local tab2 = os.date("*t", hostTime)
		
		--���ڵ���������
		--��������죬��ʾ"����"
		--����ǽ��꣬��ʾ"XX��XX��"
		--����Ǹ������ݣ���ʾ"XXXX��XX��XX��"
		local strYMD = ""
		if (ts < (3600 * 24)) then --����
			--"����"
			strYMD = hVar.tab_string["__Yesterday"]
		elseif (tonumber(yyyy) == tab2.year) then --����
			--"XX��XX��"
			strYMD = mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
		else --���õ����
			--"XXXX��XX��XX��"
			strYMD = yyyy .. hVar.tab_string["_TEXT_YEAR_"] .. mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
		end
		
		--����
		if (rankId == 1) then --����Թ�
			GiftTip = hVar.tab_string["["] .. hVar.tab_stringM["world/csys_random_test"][1] .. hVar.tab_string["]"] .. strYMD .. hVar.tab_string["__TEXT_RankNum"] .. hVar.tab_string["__Reward__"] --"��������"
		elseif (rankId == 2) then --ǰ�����
			GiftTip = hVar.tab_string["["] .. hVar.tab_stringM["world/yxys_ex_002"][1] .. hVar.tab_string["]"] .. strYMD .. hVar.tab_string["__TEXT_RankNum"] .. hVar.tab_string["__Reward__"] --"��������"
		end
	elseif (prizetype == 20030) then --ħ���������ͽ�
		--ħ������ÿ�����ͽ�;2018-10-15;10;����1;����2;����3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --����
		local strDate = tostring(tCmd[2]) --����
		local count = tonumber(tCmd[3]) or 0 --��ս����
		local reward = {} --����
		local rewardNum = 0 --��������
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
		
		--ͼ��
		itemModel = "ui/icon_mlbk.png"
		
		--�ʼ��Ĳ���ʱ��
		local yyyy = string.sub(strDate, 1, 4)
		local mm = string.sub(strDate, 6, 7)
		local dd = string.sub(strDate, 9, 10)
		local mailTime = hApi.GetNewDate(strDate .. " 23:59:59")
		
		--������ʱ��
		local localTimeZone = hApi.get_timezone() --��ñ��ص�ʱ��(GMT+?)
		local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --�뱱��ʱ���ʱ��
		local hostTime = hApi.GetNewDate(g_systime)
		hostTime = hostTime - delteZone * 3600 --������ʱ��(����ʱ��)
		
		--ʱ���(����ʱ��)
		local ts = hostTime - mailTime
		local tab2 = os.date("*t", hostTime)
		
		--���ڵ���������
		--��������죬��ʾ"����"
		--����ǽ��꣬��ʾ"XX��XX��"
		--����Ǹ������ݣ���ʾ"XXXX��XX��XX��"
		local strYMD = ""
		if (tonumber(yyyy) == tab2.year) and (tonumber(mm) == tab2.month) and (tonumber(dd) == tab2.day) then --����
			--"����"
			strYMD = hVar.tab_string["__Today"]
		elseif (ts < (3600 * 24)) then --����
			--"����"
			strYMD = hVar.tab_string["__Yesterday"]
		elseif (tonumber(yyyy) == tab2.year) then --����
			--"XX��XX��"
			strYMD = mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
		else --���õ����
			--"XXXX��XX��XX��"
			strYMD = yyyy .. hVar.tab_string["_TEXT_YEAR_"] .. mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
		end
		
		--����
		GiftTip = hVar.tab_string["["] .. hVar.tab_stringM["world/td_wj_003"][1] .. hVar.tab_string["]"] .. strYMD .. hVar.tab_string["__TEXT_QinLaoJiang"] --"���ͽ�"
		
	elseif (prizetype == 20031) then --���б�������ĵ��ʼ�����
		--��������;��������;����1;����2;����3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --����
		local content = tostring(tCmd[2]) --����
		local reward = {} --����
		local rewardNum = 0 --��������
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
		
		--ͼ��
		itemModel = "ui/xf.png"
		
		--�¿���ʾ�ر��ͼ��
		--print("�¿�", string.find(tostring(tCmd[1]), "�¿�"))
		--if (string.find(tostring(tCmd[1]), "�¿�") ~= nil) then
		if (string.find(tostring(tCmd[1]), hVar.tab_string["__TEXT_MONTHCARD"]) ~= nil) then
			itemModel = "UI:MONTHCARD_ICON"
		end
		
		--[[
		--��������������ʾ�ر��ͼ��
		--print("������������", string.find(tostring(tCmd[1]), "������������"))
		--if (string.find(tostring(tCmd[1]), "������������") ~= nil) then
		if (string.find(tostring(tCmd[1]), hVar.tab_string["__TEXT_GROUP_RANK_REWARD"]) ~= nil) then
			itemModel = "misc/chest/redpacket.png"
		end
		]]
		
		--����
		--GiftTip = hVar.tab_string["["] .. title .. hVar.tab_string["]"]
		GiftTip = title
		
	elseif (prizetype == 20032) then --ֱ�ӿ����ҽ���
		local tCmd = hApi.Split(prizecode,";")
		local reward = {}
		exNum = 0
		for i = 2, #tCmd do
			--print("tCmd[i]:",tCmd[i])
			if tCmd[i] and tCmd[i] ~= "" then
				reward[#reward + 1] = tCmd[i]
				exNum = exNum + 1
				
				--��������id
				local rewardT = hApi.Split(tCmd[i], ":")
				local rtype = tonumber(rewardT[1]) or 0 --15:ֱ�ӿ����ҽ���
				local chestId = tonumber(rewardT[2]) or 0 --����id
				local rnum = tonumber(rewardT[3]) or 0 --��������
				local param4 = rewardT[4]
				
				--����ͼ��
				itemModel = hVar.tab_item[chestId].icon
			end
		end
		
		--GiftTip = hVar.tab_string["["]..hVar.tab_string["__TEXT_Activity"] .. hVar.tab_string["__Reward__"] .. hVar.tab_string["]"] --"���������"
		--GiftTip = hVar.tab_string["["].. tostring(tCmd[1]) .. hVar.tab_string["]"] --"���������"
		GiftTip = tostring(tCmd[1]) --"���������"
		
	elseif (prizetype == 20033) then --ֻ�б�������ģ�û�н���
		--��������;��������;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --����
		local content = tostring(tCmd[2]) --����
		local reward = {} --����
		local rewardNum = 0 --��������
		
		exNum = 0
		
		--ͼ��
		itemModel = "UI:BROADCAST_M"
		
		--����
		--GiftTip = hVar.tab_string["["] .. title .. hVar.tab_string["]"]
		GiftTip = title
		
	elseif (prizetype == 20034) then --����������ж�λ����������ĵĽ���
		--��λ;��������;��������;
		local tCmd = hApi.Split(prizecode,";")
		local rank = tonumber(tCmd[1]) or 0 --��λ
		local title = tostring(tCmd[2]) --����
		local content = tostring(tCmd[3]) --����
		local reward = {} --����
		local rewardNum = 0 --��������
		
		exNum = 0
		
		--ͼ��
		local tabRank = hVar.tab_pvprank[rank] or hVar.tab_pvprank[0]
		itemModel = tabRank.icon
		
		--����
		--GiftTip = hVar.tab_string["["] .. title .. hVar.tab_string["]"]
		GiftTip = title
		
	elseif (prizetype == 20035) then --����������
		--����������;2018-10-15;10;����1;����2;����3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --����
		local strDate = tostring(tCmd[2]) --����
		local count = tonumber(tCmd[3]) or 0 --��ս����
		local reward = {} --����
		local rewardNum = 0 --��������
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
		
		--ͼ��
		itemModel = "UI:ICON_CHAT_DRAGON"
		
		--�ʼ��Ĳ���ʱ��
		local yyyy = string.sub(strDate, 1, 4)
		local mm = string.sub(strDate, 6, 7)
		local dd = string.sub(strDate, 9, 10)
		local mailTime = hApi.GetNewDate(strDate .. " 23:59:59")
		
		--������ʱ��
		local localTimeZone = hApi.get_timezone() --��ñ��ص�ʱ��(GMT+?)
		local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --�뱱��ʱ���ʱ��
		local hostTime = hApi.GetNewDate(g_systime)
		hostTime = hostTime - delteZone * 3600 --������ʱ��(����ʱ��)
		
		--ʱ���(����ʱ��)
		local ts = hostTime - mailTime
		local tab2 = os.date("*t", hostTime)
		
		--���ڵ���������
		--��������죬��ʾ"����"
		--����ǽ��꣬��ʾ"XX��XX��"
		--����Ǹ������ݣ���ʾ"XXXX��XX��XX��"
		local strYMD = ""
		if (tonumber(yyyy) == tab2.year) and (tonumber(mm) == tab2.month) and (tonumber(dd) == tab2.day) then --����
			--"����"
			strYMD = hVar.tab_string["__Today"]
		elseif (ts < (3600 * 24)) then --����
			--"����"
			strYMD = hVar.tab_string["__Yesterday"]
		elseif (tonumber(yyyy) == tab2.year) then --����
			--"XX��XX��"
			strYMD = mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
		else --���õ����
			--"XXXX��XX��XX��"
			strYMD = yyyy .. hVar.tab_string["_TEXT_YEAR_"] .. mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
		end
		
		--����
		GiftTip = strYMD .. hVar.tab_string["__TEXT_ChatDragonReward"] --"����������"
		
	elseif (prizetype == 20036) then --�����ؾ��������ͽ�
		--�����ؾ��������ͽ�;2018-10-15;10;����1;����2;����3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --����
		local strDate = tostring(tCmd[2]) --����
		local count = tonumber(tCmd[3]) or 0 --��ս����
		local reward = {} --����
		local rewardNum = 0 --��������
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
		
		--ͼ��
		itemModel = "icon/item/item_treasure01.png"
		
		--�ʼ��Ĳ���ʱ��
		local yyyy = string.sub(strDate, 1, 4)
		local mm = string.sub(strDate, 6, 7)
		local dd = string.sub(strDate, 9, 10)
		local mailTime = hApi.GetNewDate(strDate .. " 23:59:59")
		
		--������ʱ��
		local localTimeZone = hApi.get_timezone() --��ñ��ص�ʱ��(GMT+?)
		local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --�뱱��ʱ���ʱ��
		local hostTime = hApi.GetNewDate(g_systime)
		hostTime = hostTime - delteZone * 3600 --������ʱ��(����ʱ��)
		
		--ʱ���(����ʱ��)
		local ts = hostTime - mailTime
		local tab2 = os.date("*t", hostTime)
		
		--���ڵ���������
		--��������죬��ʾ"����"
		--����ǽ��꣬��ʾ"XX��XX��"
		--����Ǹ������ݣ���ʾ"XXXX��XX��XX��"
		local strYMD = ""
		if (tonumber(yyyy) == tab2.year) and (tonumber(mm) == tab2.month) and (tonumber(dd) == tab2.day) then --����
			--"����"
			strYMD = hVar.tab_string["__Today"]
		elseif (ts < (3600 * 24)) then --����
			--"����"
			strYMD = hVar.tab_string["__Yesterday"]
		elseif (tonumber(yyyy) == tab2.year) then --����
			--"XX��XX��"
			strYMD = mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
		else --���õ����
			--"XXXX��XX��XX��"
			strYMD = yyyy .. hVar.tab_string["_TEXT_YEAR_"] .. mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
		end
		
		--����
		GiftTip = hVar.tab_string["["] .. hVar.tab_string["__TEXT_MAINUI_BTN_GROUP"] .. hVar.tab_stringM["world/td_jt_004"][1] .. hVar.tab_string["]"] .. strYMD .. hVar.tab_string["__TEXT_QinLaoJiang"] --"���ͽ�"
		
	elseif (prizetype == 20037) then --���ű���������������
		--��������;��������;����1;����2;����3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --����
		local content = tostring(tCmd[2]) --����
		local reward = {} --����
		local rewardNum = 0 --��������
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
		
		--ͼ��
		itemModel = "misc/chest/redpacket.png"
		
		--����
		--GiftTip = hVar.tab_string["["] .. title .. hVar.tab_string["]"]
		GiftTip = title
		
	elseif (prizetype == 20038) then --���ű���������һ������
		--��������;��������;����1;����2;����3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --����
		local content = tostring(tCmd[2]) --����
		local reward = {} --����
		local rewardNum = 0 --��������
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
		
		--ͼ��
		itemModel = "misc/chest/redpacket.png"
		
		--����
		--GiftTip = hVar.tab_string["["] .. title .. hVar.tab_string["]"]
		GiftTip = title
		
	elseif (prizetype == 20039) then --����ά�����б�������ĵĽ���
		--��������;��������;����1;����2;����3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --����
		local content = tostring(tCmd[2]) --����
		local reward = {} --����
		local rewardNum = 0 --��������
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
		
		--ͼ��
		itemModel = "UI:ICON_IKUN"
		
		--����
		--GiftTip = hVar.tab_string["["] .. title .. hVar.tab_string["]"]
		GiftTip = title
		
	elseif (prizetype == 20040) then --�������б�������ĵĽ���
		--��������;��������;����1;����2;����3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --����
		local content = tostring(tCmd[2]) --����
		local reward = {} --����
		local rewardNum = 0 --��������
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
		
		--ͼ��
		itemModel = "misc/chest/redpacket.png"
		
		--����
		--GiftTip = hVar.tab_string["["] .. title .. hVar.tab_string["]"]
		GiftTip = title
		
	elseif (prizetype == 20041) then --��л�Ŵ��б�������ĵĽ���
		--��������;��������;����1;����2;����3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --����
		local content = tostring(tCmd[2]) --����
		local reward = {} --����
		local rewardNum = 0 --��������
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
		
		--ͼ��
		itemModel = "misc/chest/redpacket.png"
		
		--����
		--GiftTip = hVar.tab_string["["] .. title .. hVar.tab_string["]"]
		GiftTip = title
		
	elseif (prizetype == 20042) then --�����Ŵ��б�������ĵĽ���
		--��������;��������;����1;����2;����3;
		local tCmd = hApi.Split(prizecode,";")
		local title = tostring(tCmd[1]) --����
		local content = tostring(tCmd[2]) --����
		local reward = {} --����
		local rewardNum = 0 --��������
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
		
		--ͼ��
		itemModel = "misc/chest/redpacket.png"
		
		--����
		--GiftTip = hVar.tab_string["["] .. title .. hVar.tab_string["]"]
		GiftTip = title
		
	elseif (prizetype == 1035) then --�׳�198Ԫ��
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
		
		--Ҳ����Ϸ��
		if (type(reward[2]) == "string") then
			local tReward2 = hApi.Split(reward[2] or "", ":")
			coin = tonumber(tReward2[2]) or 0
		end
		
	elseif (prizetype == 1036) then --�׳�388Ԫ��
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
		
		--Ҳ����Ϸ��
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
	--�����
	elseif prizetype == 10000 then
		local tempState = {}
		for prizecode in string.gfind(prizecode,"([^%;]+);+") do
			tempState[#tempState+1] = prizecode
		end
		
		--�������
		if #tempState > 1 then
			itemID = 9103		--ֻ�ǽ������������ͼ��
			itemModel = hVar.tab_item[itemID].icon
			local itemLv = (hVar.tab_item[itemID].itemLv or 1)
			itemBack = hVar.ITEMLEVEL[itemLv].BORDERMODEL
			itemNum = tonumber(prizecode)
			GiftTip = hVar.tab_string["__TEXT_GetItem4"]
		--ֻ��һ�ֽ���
		else
			itemID,itemNum,itemName,itemHole,coin,score,itemBack,itemModel,GiftTip,GiftTip_Ex,giftType = hApi.UnpackPrizeDataEx(tempState[1])
		end
	end
	
	return itemID,itemNum,itemName,itemHole,coin,score,itemBack,itemModel,GiftTip,GiftTip_Ex,exNum,exY,exG,giftType
end

--��������ͼ�Ƿ��ǵ�ͼ�����
hApi.CheckMapBagEx = function(mapName,achi)
	for i = 1,#hVar.MAP_BAG_EX do
		if hVar.MAP_BAG_EX[i] == mapName and LuaGetPlayerMapAchi(achi,hVar.ACHIEVEMENT_TYPE.LEVEL) == 1 then
			return 1
		end
	end
	return 0
end

--������������߿���
hApi.GetQuestRewardItemSlotNum = function(id)
	local tabI = hVar.tab_item[id]
	if tabI and hVar.ITEM_EQUIPMENT_POS[tabI.type or 0]~=nil then
		--��װ������Ʒ���п�
		local nItemLv = tabI.itemLv or 0
		if tabI.elite==1 then
			nItemLv = 5		--��װ��Ϊ�ȼ�5��װ��
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
				--��ս����
				sAttackType = hVar.tab_string["__Attr_ATTACKMODE_23"]
			else
				--��ս
				sAttackType = hVar.tab_string["__Attr_ATTACKMODE_28"]
			end
		else
			if IsSiege==1 then
				--Զ�̹���
				sAttackType = hVar.tab_string["__Attr_ATTACKMODE_24"]
			elseif IsSpell==1 then
				--����
				sAttackType = hVar.tab_string["__Attr_ATTACKMODE_29"]
			else
				--Զ��
				sAttackType = hVar.tab_string["__Attr_ATTACKMODE_30"]
			end
		end
	elseif tabU.attr and tabU.attr.attack then
		if tabU.attr.attack[3] > 2 then
			if (tabU.attr.siege or 0)>0 then
				--Զ�̹���
				sAttackType = hVar.tab_string["__Attr_ATTACKMODE_24"]
			else
				--Զ��
				sAttackType = hVar.tab_string["__Attr_ATTACKMODE_30"]
			end
		else
			if (tabU.attr.siege or 0)>0 then
				--��ս����
				sAttackType = hVar.tab_string["__Attr_ATTACKMODE_23"]
			else
				--��ս
				sAttackType = hVar.tab_string["__Attr_ATTACKMODE_28"]
			end
		end
	end
	--�����ǿ�����ù��Ĺ�������
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

--Ұ��������ɢ�Ի�(�����ķ�)
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
				hUI.Disable(350,"׷������",1)
				hGlobal.BattleField = hApi.CreateBattlefield(oUnit,oTarget)
				hGlobal.WORLD.LastWorldMap:pause(1,"Battlefield")
				hApi.addTimerOnce("__WM__LocalPlayerAfterPursue",250,function()
					hApi.EnterBattlefield(hGlobal.BattleField,oUnit,oTarget)
				end)
			else
				hUI.Disable(250,"���ߵ���")
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

--�жϵ�ͼ�ǵڼ��½�
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
		--��������
		if type(tConfig.ChannelSwitch) == "table" then
			local iChannelId = getChannelInfo()
			if type(tConfig.ChannelSwitch.openBBS) == "table" then
				--������̳��ť
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