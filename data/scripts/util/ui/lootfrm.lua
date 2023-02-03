--------------------------------
-- 加载BOSS战斗奖励对话面板
--------------------------------
hGlobal.UI.InitLootFrm = function()
	local w,h = 554,462
	local x,y = hVar.SCREEN.w/2-w/2,hVar.SCREEN.h/2+h/2

	local _exitFunc = nil

	local _CODE_GetLootNormal = hApi.DoNothing
	local _CODE_GetLootBFCard = hApi.DoNothing
	local _CODE_GetLootChest = hApi.DoNothing
	local _CODE_GetRandomRes = hApi.DoNothing
	local _CODE_ShowLootDetail = hApi.DoNothing

	local _CODE_PlayerGetLootItem = hApi.DoNothing
	local _CODE_PlayerGetLootChest = hApi.DoNothing

	local _LF_FrmXYWH = {hVar.SCREEN.w/2-554/2,hVar.SCREEN.h/2+462/2,554,462}
	local _LF_LootIconXY = {
		[1] = hApi.InitItemPosList(1,272,-230,162),
		[2] = hApi.InitItemPosList(2,272,-230,148),
		[3] = hApi.InitItemPosList(3,272,-230,134),
		[4] = hApi.InitItemPosList(4,272,-230,120),
		[5] = hApi.InitItemPosList(5,272,-230,110),
	}

	local _LF_LootUnit = {}
	local _LF_LootTarget = {}
	local _LF_LootItem = nil
	local _LF_LootChest = nil

	local _FrmBG
	hGlobal.UI.__BossKillPanel = hUI.frame:new({
		x = _LF_FrmXYWH[1],
		y = _LF_FrmXYWH[2],
		w = _LF_FrmXYWH[3],
		h = _LF_FrmXYWH[4],
		dragable = 2,
		show = 0,
		closebtn = {
			model = "UI:BTN_ok",
			scaleT = 0.9,
			x = w/2-10,
			y = -400,
			code = function()
				_FrmBG:show(0,"appear")
				hApi.ClearLocalDeadIllusion()
				_CODE_PlayerGetLootItem()
				_CODE_PlayerGetLootChest()
				_CODE_ShowLootDetail()
				hGlobal.SceneEvent:continue(300)
			end,
		},
	})

	_FrmBG = hGlobal.UI.__BossKillPanel
	
	local _LF_UIHandle = {}
	local _LF_UIList = {
		{"image","imgCut","UI:panel_part_09",{270,-150,544,8}},
		{"image","imgSlotMy",{"UI_frm:slot","lightSlim"},{90,-75,64,64}},
		{"image","imgSlotOpp",{"UI_frm:slot","lightSlim"},{420,-75,64,64}},
		{"labelX","content","",{w/2,-160,22,1,"MT",hVar.FONTC}},
		{"labelX","title",hVar.tab_string["__TEXT_Savehint1"],{w/2-20,-110,26,1,"MC",hVar.FONTC}}, --获得奖励
		{"labelX","heroname","*",{90,-110,24,1,"MT",hVar.FONTC}},
		{"labelX","targetname","*",{420,-110,24,1,"MT",hVar.FONTC}},
	}
	hUI.CreateMultiUIByParam(_FrmBG,0,0,_LF_UIList,_LF_UIHandle)
	
	local _frame = hGlobal.UI.__BossKillPanel
	local _parent = _frame.handle._n
	local _childUI = _frame.childUI
	local nCurSelectIndex = nil
	local _rewardTable = nil
	local _resetFunc = nil
	
	--添加选中效果函数
	local _GP = {align = "MC"}
	local function __GridAddBorder(grid,gridX,girdY)
		grid:addimage("UI:Button_SelectBorder",gridX,girdY,_GP)
	end
	local _code_CreateHeroIcon = function(sSlotKey,x,y,sKey,oUnit)
		hApi.safeRemoveT(_childUI,sKey)
		local ix,iy = _LF_UIHandle[sSlotKey]:getPosition()
		local nId = 1
		if type(oUnit)=="table" then
			nId = oUnit.data.id
		elseif type(oUnit)=="number" then
			nId = oUnit
		end
		local w,h = hApi.GetUnitImageWH(nId,96,96)
		_childUI[sKey] = hUI.thumbImage:new({
			parent = _FrmBG.handle._n,
			id = nId,
			x = ix+x,
			y = iy+y,
			w = w,
			h = h,
			smartWH = 1,
		})
	end
	local _code_AddLootItemIcon = function(nMode,tLoot,i,x,y)
		local tItem = tLoot[i]
		--目前仅支持全给模式
		_childUI["imgLootItem_"..i] = hUI.node:new({
			parent = _FrmBG.handle._n,
			x = x,
			y = y,
		})
		local pNode = _childUI["imgLootItem_"..i].handle._n
		local tUIHandle = {}
		local tUIList = {
			{"image","imgItem",{tItem.model,tItem.animation},{0,0,-1,64,2}},
			{"label","labName",tostring(tItem.name),{0,-50,24,1,"MT",hVar.FONTC}},
		}
		if tItem.slot~=0 then
			tUIList[#tUIList+1] = {"image","imgSlot",{"UI_frm:slot","lightSlim"},{0,0,64,64,0}}
		end
		if type(tItem.hint)=="string" then
			local font = tItem.hintFont or tLoot.hintFont or "numWhite"
			local size = tItem.hintSize or tLoot.hintSize or 18
			tUIList[#tUIList+1] = {"label","labNumber",tItem.hint,{0,-72,size,1,"MT",font}}
		elseif type(tItem.num)=="number" and tItem.num>0 then
			local font = tItem.hintFont or tLoot.hintFont or "numWhite"
			local size = tItem.hintSize or tLoot.hintSize or 18
			tUIList[#tUIList+1] = {"label","labNumber","+"..tostring(tItem.num),{0,-72,size,1,"MT",font}}
		end
		hUI.CreateMultiUIByParam(pNode,0,0,tUIList,tUIHandle)
	end
	
	local _code_FormatRewardDataOne = function(tData,i)
		i = i or 0
		if tData[1]=="battlefieldskill" then
			local nLv = hApi.random(tData[3],tData[4])
			return {model=hApi.GetLootModel(tData),animation = hApi.GetLootAnimation(tData),name = hApi.GetLootName(tData),num = nLv,slot = 0,hint = "lv"..nLv,index = i}
		elseif tData[1]=="chest" then
			local nLv = tData[2] or 1
			local nNum = tData[3] or 1
			return {model="icon/item/random_lv"..nLv..".png",animation="normal",name=hVar.tab_string["chest"],num = 1,hint = "x"..nNum,index = i}
		else
			local nCount = hApi.random(tData[3],tData[4])
			if nCount==0 then
				nCount = nil
			end
			return {model=hApi.GetLootModel(tData),animation = hApi.GetLootAnimation(tData),name = hApi.GetLootName(tData),num = nCount,index = i}
		end
	end
	local _code_FormatRewardData = function(tReward,tLoot)
		if #tLoot>0 then
			for i = 1,#tLoot do
				tReward[#tReward+1] = _code_FormatRewardDataOne(tLoot[i],i)
			end
		end
		return tReward
	end
	--local _code_AIPlayerDefeated = function(oUnitE)
		--if oUnitE~=nil then
			--if heroGameRule.isAiTurn() then
				--hUI.Disable(500,"关闭访问面板AI turn")
				--hApi.addTimerOnce("__WM__AttackConfirmAfterBattle",300,function()
					--return hGlobal.event:event("Event_HeroAttackConfirm",nil,oUnitE,false)
				--end)
			--else
				--return hGlobal.event:event("Event_HeroAttackConfirm",nil,oUnitE,false)
			--end
		--end
	--end

	local turnOnMedal = 0
	hGlobal.event:listen("localEvent_TurnOnMedal_1_Griffin","单场战斗相关的勋章点亮",function(id)
		if id ~= 0 then
			turnOnMedal = id
		end
	end)
	--玩家胜利时给予奖励
	hGlobal.event:listen("localEvent_HeroVictoryReward","__ShowRewardsInfo__",function(tWorldLog,oHero,idx,oUnitE,tgrDataE)
		local oWorld = hGlobal.WORLD.LastWorldMap
		local oUnit = oHero:getunit("worldmap")
		local oTarget = oUnitE
		if turnOnMedal ~= 0 then
			--showBigMedalFrame(turnOnMedal,1,1)
			hGlobal.event:event("LocalEvent_showBigMedalFrame",turnOnMedal,1,1)
			turnOnMedal = 0
		end

		_LF_LootItem = nil
		_LF_LootChest = nil

		local tLoot = {}
		
		_CODE_GetLootNormal(tLoot,idx,tgrDataE,tWorldLog,oUnit,oTarget)
		_CODE_GetLootBFCard(tLoot,idx,tgrDataE,tWorldLog,oUnit,oTarget)

		--记录拾取
		hApi.SetObjectEx(_LF_LootUnit,oUnit)
		hApi.SetObjectEx(_LF_LootTarget,oTarget)
		if #tLoot==0 then
			--如果没有掉落的话
			_LF_LootItem = nil
			_LF_LootChest = nil
			local sus = 0
			--_code_AIPlayerDefeated(oUnitE)
			local nAlly = hGlobal.LocalPlayer:allience(oHero:getowner())
			if nAlly~=hVar.PLAYER_ALLIENCE_TYPE.OWNER and nAlly~=hVar.PLAYER_ALLIENCE_TYPE.ALLY then
				--非本地玩家,或友军玩家是不会获得随机资源的
			elseif oWorld.data.playmode==hVar.PLAY_MODE.KUMA_GAME then
				--KUMA模式没有随机资源
				sus = _CODE_GetRandomRes_KUMA(tWorldLog,oUnit,oUnitE,tgrDataE)
			elseif not(heroGameRule.isAiTurn()) and oUnitE~=nil then
				--如果不是电脑行动的轮次并且什么都没掉，那么有一定几率出现随机资源面板
				sus = _CODE_GetRandomRes(tWorldLog,oUnit,oUnitE,tgrDataE)
			end
			if sus~=1 then
				hGlobal.SceneEvent:continue()
			end
		--elseif heroGameRule.isAiTurn() then
			----如果是电脑打过来,不显示随机面板，也没有额外掉落
			--_LF_LootItem = tLoot
			--_LF_LootChest = nil
			--_CODE_PlayerGetLootItem()
			--_code_AIPlayerDefeated(oUnitE)
		else
			_LF_LootItem = tLoot
			local oHero = oUnit:gethero()
			if oUnitE~=nil and oWorld.data.playmode==hVar.PLAY_MODE.NO_HERO_CARD and oHero and oHero.data.HeroCard==0 then
				_LF_LootChest = oUnitE.data.loot
			else
				_LF_LootChest = nil
			end
			local tReward = _code_FormatRewardData({
				unit = oHero.data.id,
				target = idx,
			},tLoot)
			if type(_LF_LootChest)=="string" then
				tReward[#tReward+1] = _code_FormatRewardDataOne({"chest",3,1})
			end
			_CODE_ShowLootDetail(tReward)
			--_code_AIPlayerDefeated(oUnitE)
			hUI.Disable(500,"显示奖励面板")
			hApi.addTimerOnce("__UI__BossKillPanelShow",1,function()
				if _FrmBG.data.show==0 then
					_FrmBG:show(1,"fade")
					_FrmBG:active()
				end
			end)
		end
	end)

	--普通的给奖励(对话触发)
	hGlobal.event:listen("LocalEvent_HeroPickReward","__ShowRewardsInfo__",function(oUnit,oTarget,sRewardName)
		hApi.SetObjectEx(_LF_LootUnit,oUnit)
		hApi.SetObjectEx(_LF_LootTarget,oTarget)
		_LF_LootItem = nil
		_LF_LootChest = sRewardName

		local tReward = _code_FormatRewardData({
			unit = oUnit.data.id,
			target = 0,
		},{{"chest",3,1}})
		_CODE_ShowLootDetail(tReward)
		_FrmBG:show(1,"fade")
		_FrmBG:active()
	end)

	--显示拾取细节
	_CODE_ShowLootDetail = function(tReward)
		--删除之前创建的图样
		for i = 1,#_LF_LootIconXY do
			hApi.safeRemoveT(_childUI,"imgLootItem_"..i)
		end
		hApi.safeRemoveT(_childUI,"imgMy")
		hApi.safeRemoveT(_childUI,"imgOpp")
		if tReward==nil or (tReward.unit or 0)==0 then
			return
		elseif (tReward.target or 0)==0 then
			_LF_UIHandle["imgSlotOpp"]:setVisible(false)
			_childUI["targetname"]:setText("",2)
			local sHeroName = hApi.GetUnitName(tReward.unit)
			_code_CreateHeroIcon("imgSlotMy",0,-20,"imgMy",tReward.unit)
			_childUI["heroname"]:setText(sHeroName,2)
			_childUI["title"]:setText(hVar.tab_string["__TEXT_RewardTabletitle2"],2)
		else
			_LF_UIHandle["imgSlotOpp"]:setVisible(true)
			local sHeroName = hApi.GetUnitName(tReward.unit)
			local sTargetName = hApi.GetUnitName(tReward.target)
			_code_CreateHeroIcon("imgSlotMy",0,-20,"imgMy",tReward.unit)
			_code_CreateHeroIcon("imgSlotOpp",0,-20,"imgOpp",tReward.target)
			_childUI["heroname"]:setText(sHeroName,2)
			_childUI["targetname"]:setText(sTargetName,2)
			_childUI["title"]:setText(hVar.tab_string["__TEXT_RewardTabletitle1"],2)
		end
		--_childUI["dragBox"]:sortbutton()
		local nNum = math.min(#tReward,#_LF_LootIconXY)
		if nNum>0 then
			for i = 1,nNum do
				_code_AddLootItemIcon(tReward.rewardType,tReward,i,_LF_LootIconXY[nNum][i][1],_LF_LootIconXY[nNum][i][2])
			end
		end
	end

	_CODE_GetLootNormal = function(tReward,id,tgrDataE,tWorldLog,oUnit,oTarget)
		local tLootU
		local nLootType
		if tgrDataE~=nil and tgrDataE.loot then
			nLootType = hVar.UNIT_REWARD_TYPE.ALL
			tLootU = tgrDataE.loot
		else
			local tabU = hVar.tab_unit[id]
			if tabU and tabU.loot then
				if tabU.interactionBox then
					nLootType = tabU.interactionBox[2]
				else
					nLootType = hVar.UNIT_REWARD_TYPE.ALL
				end
				tLootU = tabU.loot
			end
		end
		if nLootType and type(tLootU)=="table" and #tLootU>0 then
			local IsCommonReward = 0
			--如果该单位会给予属性，那么必须是放置上去的单位才会给，否则转为通用奖励
			if oTarget and oTarget.data.editorID==0 then
				for i = 1,#tLootU do
					if type(tLootU[i])=="table" and tLootU[i][1]=="attr" then
						IsCommonReward = 1
						nLootType = hVar.UNIT_REWARD_TYPE.ALL
						break
					end
				end
			end
			--如果是英雄的话会给钱
			if IsCommonReward==1 and oTarget~=nil then
				local oHeroT = oTarget:gethero()
				if oHeroT then
					local rLv = math.mod(oHeroT.attr.level,2)+1
					tLootU = {
						{"res","GOLD",math.min(1000,rLv*200)},
						{"res","FOOD",math.min(500,rLv*100)},
					}
				end
			end
		end
		if nLootType and type(tLootU)=="table" and #tLootU>0 then
			if nLootType==hVar.UNIT_REWARD_TYPE.ALL then
				--全给
				for i = 1,#tLootU do
					tReward[#tReward+1] = tLootU[i]
				end
			else
				--随机给一个
				tReward[#tReward+1] = tLootU[hApi.random(1,#tLootU)]
			end
		end
	end

	_CODE_GetLootBFCard = function(tReward,id,tgrDataE,tWorldLog,oUnit,oTarget)
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld==nil then
			return
		end
		--计算敌人的参战分数
		local nCombatScore = 0
		for i = 1,#tWorldLog do
			local v = tWorldLog[i]
			if v.key=="EnterBattle" and v.unit.owner==oTarget.data.owner and oUnit~=oTarget then
				nCombatScore = v.CombatScoreBasic
				break
			end
		end
		--判断战术卡片掉落
		local nTacticsId,nTacticsLv,cExtra = 0,0,0
		if oTarget~=oUnit and nCombatScore>=200 then
			local sLootKey
			local oUnitT = hApi.GetBattleUnit(oTarget)
			if oUnitT==oTarget and oTarget.data.type==hVar.UNIT_TYPE.BUILDING then
				--打城不掉卡片！
			else
				--否则查一下战斗目标单位
				local sus = LuaAddLootRecordFromUnit(g_curPlayerName,oUnitT,"BFSkillCard")
				if sus==1 then
					if oUnitT.data.editorID~=0 or oUnitT:gethero() then
						--如果是英雄或摆上去的单位，那么有100%的几率判断是否掉落战术技能卡片
						nTacticsId,nTacticsLv,cExtra = hApi.RandomTacticsId(oUnitT,oWorld,nCombatScore)
					else
						--否则有20%的几率判断是否掉落战术技能卡片
						if hApi.random(1,10)<=2 then
							nTacticsId,nTacticsLv,cExtra = hApi.RandomTacticsId(oUnitT,oWorld,nCombatScore)
						end
					end
				else
					--print("已经从单位身上取得过战术技能卡")
				end
			end
			--如果随机出了一个非法的数字，那么清空
			if nTacticsId~=0 and hVar.tab_tactics[nTacticsId]==nil then
				nTacticsId = 0
				nTacticsLv = 0
			end
			--掉落战术技能卡片
			if nTacticsId>0 and nTacticsLv>0 then
				local nMapDifficulty = oWorld.data.MapDifficulty
				--根据掉落天数会有额外的几率掉落卡片，35天(5周以上)会获得完整的概率,提高0%~30%
				local nDayBounce = hApi.NumBetween(oWorld.data.roundcount-5,0,30)
				local nPowerBounce = 0
				local nDropChance
				if cExtra>0 then
					--说明是强力的怪物,提高掉率0%~20%
					nPowerBounce = hApi.NumBetween(hApi.floor(cExtra/5),0,20)
				end
				if nMapDifficulty>=5 then
					nDropChance = 35 + nDayBounce + nPowerBounce
				elseif nMapDifficulty>=4 then
					nDropChance = 30 + nDayBounce + nPowerBounce
				elseif nMapDifficulty>=3 then
					nDropChance = 25 + nDayBounce + nPowerBounce
				else
					nDropChance = 20 + nDayBounce
				end
				if hApi.random(1,100)<=nDropChance then
					tReward[#tReward+1] = {"battlefieldskill",nTacticsId,nTacticsLv}
				end
			end
		end
	end

	_CODE_GetRandomRes_KUMA = function(tWorldLog,oUnit,oTarget,tgrDataE)
		local r = hApi.random(1,10)
		if r > 5 then
			local tLoot = {
				{"item",9007,1,1,1},
				{"item",9008,1,1,1},
				{"item",9008,1,1,1},
				{"item",9007,2,1,1},
				{"item",9008,1,1,1},
				{"item",9007,5,1,1},
				{"score","random",{10,30},1,1},
				{"item",9008,1,1,1},
			}
			hGlobal.event:event("localEvent_ShowRewardFrm",oUnit,tLoot,0,0)
			return 1
		end
	end

	_CODE_GetRandomRes = function(tWorldLog,oUnit,oTarget,tgrDataE)
		local oWorld = hGlobal.WORLD.LastWorldMap
		--计算敌人的参战分数
		local nCombatScore = 0
		for i = 1,#tWorldLog do
			local v = tWorldLog[i]
			if v.key=="EnterBattle" and v.unit.owner==oTarget.data.owner and oUnit~=oTarget then
				nCombatScore = v.CombatScoreBasic
				break
			end
		end
		--150战斗力以上才会计算额外奖励
		if oWorld.data.PausedByWhat~="Victory" and nCombatScore>150 and oWorld.data.playmode==hVar.PLAY_MODE.NORMAL then
			if hApi.Is_WDLD_Map(oWorld.data.map)==1 then
				return
			end
			--根据战斗力不同，判断获得奖励的几率
			local GetRandomReward = 0
			if nCombatScore >= 800 then
				if oWorld:random(1,100)<=30 then
					GetRandomReward = 1
				end
			elseif nCombatScore >= 300 then
				if oWorld:random(1,100)<=25 then
					GetRandomReward = 1
				end
			elseif nCombatScore >= 200 then
				if oWorld:random(1,100)<=20 then
					GetRandomReward = 1
				end
			elseif nCombatScore >= 150 then
				if oWorld:random(1,100)<=15 then
					GetRandomReward = 1
				end
			end
			if GetRandomReward==1 then
				local tLoot = {
					{"res","FOOD",100,1,1},
					{"res","GOLD",100,1,1},
					{"res","WOOD",5,1,1},
					{"res","IRON",3,1,1},
					{"res","STONE",5,1,1},
					{"res","CRYSTAL",1,1,1},
					{"score","random",{10,50},1,1},
					{"res","FOOD",500,1,1},
				}
				hGlobal.event:event("localEvent_ShowRewardFrm",oUnit,tLoot,-1,1)
				return 1
			end
		end
	end

	_CODE_PlayerGetLootItem = function()
		local tLoot = _LF_LootItem
		local oUnit = hApi.GetObjectEx(hClass.unit,_LF_LootUnit)
		local oTarget = hApi.GetObjectEx(hClass.unit,_LF_LootTarget)
		_LF_LootItem = nil
		if oUnit~=nil and type(tLoot)=="table" and #tLoot>0 then
			local nAlly = hGlobal.LocalPlayer:allience(oUnit:getowner())
			if nAlly==hVar.PLAYER_ALLIENCE_TYPE.OWNER or nAlly==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
				for i = 1,#tLoot do
					local resType,resTypeEx,resMin,resMax = unpack(tLoot[i])
					if type(resMin)=="number" then
						local resValue = hApi.random(resMin,resMax)
						hApi.UnitGetLoot(oUnit,resType,resTypeEx,resValue,oTarget)
					end
				end
			end
		end
	end

	_CODE_PlayerGetLootChest = function()
		local sChestName = _LF_LootChest
		local oUnit = hApi.GetObjectEx(hClass.unit,_LF_LootUnit)
		local oTarget = hApi.GetObjectEx(hClass.unit,_LF_LootTarget)
		_LF_LootChest = nil
		if oUnit~=nil and type(sChestName)=="string" then
			local nAlly = hGlobal.LocalPlayer:allience(oUnit:getowner())
			if nAlly==hVar.PLAYER_ALLIENCE_TYPE.OWNER or nAlly==hVar.PLAYER_ALLIENCE_TYPE.ALLY then
				local oHero = oUnit:gethero()
				local oWorld = hGlobal.WORLD.LastWorldMap
				if oWorld and oHero and oHero.data.HeroCard==0 then
					local tMapData = oWorld:getmapdata(1)
					local tempDrop
					if tMapData and type(tMapData.DropItemList)=="table" then
						for i = 1,#tMapData.DropItemList do
							local v = tMapData.DropItemList[i]
							if v[1]==sChestName and #v>=2 then
								tempDrop = v
								mn = 2
								mx = #tempDrop
								break
							end
						end
					end
					--掉落8个道具
					if type(tempDrop)=="table" then
						local rewardlist = {}
						for i = 1,8 do
							local itemID = tempDrop[hApi.random(mn,mx)]
							rewardlist[i] = {"item",itemID,hVar.tab_stringI[itemID][1],0,0,0,0} --类型，道具ID，道具名字，道具出现的几率，3个可选参数
						end
						local ResetCount = 1
						local fromBag = nil
						local fromBagIndex = nil
						local fromItem = nil
						local fromMap = {hVar.ITEM_FROMWHAT_TYPE.PICK,hVar.MAP_INFO[oWorld.data.map].uniqueID,Save_PlayerData.mapUniqueID}
						return hGlobal.event:event("localEvent_ShowRewardFrm",oUnit,rewardlist,ResetCount,10,fromBag,fromBagIndex,fromItem,fromMap)
					end
				else
					print("[LUA WARNING]@RewardItemFrm:只有非卡片英雄允许触发掉落")
				end
			end
		end
	end
end
