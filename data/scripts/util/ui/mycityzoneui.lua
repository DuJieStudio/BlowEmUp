--------------------------------
-- 加载我的领地用UI
--------------------------------
hGlobal.UI.InitMyCityZoneFrm_WDLD = function()

	hGlobal.UI.MyCityZoneFrm = hUI.frame:new({
		x = 0,
		y = 100,
		w = 800,
		h = 90,
		show = 0,
		buttononly = 1,
		dragable = 2,
		autoactive = 0,
		background = 0,
	})
	
	local _frm = hGlobal.UI.MyCityZoneFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","MyCityZoneFrm",function(sSceneType,oWorld,oMap)
		if oWorld and hApi.Is_WDLD_Map(oWorld.data.map) ~= -1 then
			_frm:show(1)
		else
			_frm:show(0)
		end
	end)
	
	_childUI["back"] = hUI.button:new({
		parent = _parent,
		model = "UI:ButtonBack2",
		label = "back",
		border = 1,
		w = 150,
		x = 500,
		y = -50,
		scaleT = 0.9,
		dragbox = _childUI["dragBox"],
		code = function()
			print("g_WDLD_BeginATK",g_WDLD_BeginATK,"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
			if g_WDLD_BeginATK == 0 then
				hGlobal.event:event("LocalEvent_Back2WDLD",hGlobal.WORLD.LastWorldMap)
			elseif g_WDLD_BeginATK == 1 then
				print("BEND")
				Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleEnd,luaGetplayerDataID(),lookPlayer.roleid})
				hGlobal.event:event("LocalEvent_ShowWDLDEndFrm",1)
			end
		end,
	})

	hGlobal.event:listen("LocalEvent_Back2WDLD","Griffin_wdld",function(oWorld)
		if oWorld then
			oWorld:del()
			oWorld = nil
		end
		hApi.clearCurrentWorldScene()
		WdldRoleId = luaGetplayerDataID()
		xlLoadGame(xlSetSavePath("online"),g_curPlayerName,hVar.SAVE_DATA_PATH.MY_CITY)
	end)

	--角色操作面板
	local _RoleCtrlFrm =  hUI.frame:new({
		x = 300,
		y = 550,
		w = 530,
		h = 400,
		show = 0,
		dragable = 2,
		autoactive = 0,
		closebtn = "BTN:PANEL_CLOSE",
		closebtnX = 520,
		closebtnY = -14,
		buttononly = 1,
	})

	local _Ctrlparent = _RoleCtrlFrm.handle._n
	local _CtrlChildUI = _RoleCtrlFrm.childUI
	
	--frm title
	_CtrlChildUI["frm_title"] = hUI.label:new({
		parent = _Ctrlparent,
		size = 30,
		align = "MC",
		font = hVar.FONTC,
		x = _RoleCtrlFrm.data.w/2,
		y = -20,
		width = 300,
		text = "playerInfo:",
		RGB = {213,173,65},
	})

	--玩家名字
	_CtrlChildUI["playNameTitle"] = hUI.label:new({
		parent = _Ctrlparent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 30,
		y = -60,
		width = 300,
		text = "playerName:",
		RGB = {213,173,65},
	})
		_CtrlChildUI["playName"] = hUI.label:new({
			parent = _Ctrlparent,
			size = 24,
			align = "LT",
			font = hVar.FONTC,
			x = 200,
			y = -60,
			width = 300,
			text = "",
		})
	
	--玩家Lv
	_CtrlChildUI["playLvTitle"] = hUI.label:new({
		parent = _Ctrlparent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 30,
		y = -100,
		width = 300,
		text = "playerLv:",
		RGB = {213,173,65},
	})
		_CtrlChildUI["playLv"] = hUI.label:new({
			parent = _Ctrlparent,
			size = 24,
			align = "LT",
			font = hVar.FONTC,
			x = 200,
			y = -100,
			width = 300,
			text = "",
		})

	--玩家Exp
	_CtrlChildUI["playExpTitle"] = hUI.label:new({
		parent = _Ctrlparent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 30,
		y = -140,
		width = 300,
		text = "playerExp:",
		RGB = {213,173,65},
	})
		_CtrlChildUI["playExp"] = hUI.label:new({
			parent = _Ctrlparent,
			size = 24,
			align = "LT",
			font = hVar.FONTC,
			x = 200,
			y = -140,
			width = 300,
			text = "",
		})

	--玩家资源
	_CtrlChildUI["playResTitle"] = hUI.label:new({
		parent = _Ctrlparent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 30,
		y = -180,
		width = 300,
		text = "playerRes:",
		RGB = {213,173,65},
	})
	
	--资源相关
	local _ResX,_ResY,_ResOffX,_ResOffY = 180,-200,140,80
	for i = 1,6 do
		_CtrlChildUI["resNode_"..i] = hUI.node:new({
			parent = _Ctrlparent,
			x = _ResX + (i-1)% 3 * _ResOffX,
			y = _ResY - math.ceil((i-3)/3)*_ResOffY,
		})
		
		--资源图片
		_CtrlChildUI["resNode_"..i].childUI["ResImage"] = hUI.image:new({
			parent = _CtrlChildUI["resNode_"..i].handle._n,
			model = hVar.RESOURCE_ART[i].icon,
			w = 50,
		})

		--资源lab
		_CtrlChildUI["resNode_"..i].childUI["ResLab"] = hUI.label:new({
			parent = _CtrlChildUI["resNode_"..i].handle._n,
			size = 18,
			align = "MC",
			font = "numWhite",
			y = -30,
			width = 300,
			text = "",
		})
	end
	lookPlayer = nil
	WDLD_NEED_CHANGE_OWNER_TAG = 0--我的领地转换势力标签
	--WDLD_NEED_HIDE_SYS_MENU_TAG = 0--我的领地隐藏系统菜单标签
	WDLD_NEED_ADD_MY_TEAM_TAG = 0--我的领地加入我的部队标签
	--查看按钮
	--_CtrlChildUI["LookOverBtn"] = hUI.button:new({
		--parent = _Ctrlparent,
		--label = "LookOverBtn",
		--border = 1,
		--w = 150,
		--x = _RoleCtrlFrm.data.w/2-100,
		--y = -_RoleCtrlFrm.data.h + 30,
		--scaleT = 0.9,
		--dragbox = _CtrlChildUI["dragBox"],
		--code = function()
			--WdldRoleId = lookPlayer.roleid
			--Game_Zone_OnGameEvent(GZone_Event_TypeDef.Load,luaGetplayerDataID(),lookPlayer.roleid,g_ReadyCitySave,xlSetSavePath("online")..lookPlayer.roleid..hVar.SAVE_DATA_PATH.MY_CITY)
			--_RoleCtrlFrm:show(0)
			--WDLD_NEED_CHANGE_OWNER_TAG = 1
			----WDLD_NEED_HIDE_SYS_MENU_TAG = 1
			--hGlobal.event:event("LocalEvent_ShowPlayerRankFrame",0)
		--end,
	--})

	WDLD_BUILDING_GUARD = function(oWorld)
		if g_lua_src == 1 or hApi.Is_WDLD_Map(oWorld.data.map) ~= -1 then
			oWorld:enumunit(function(eu)
				if eu.chaUI[eu.data.triggerID.."GBG"] then
					hApi.safeRemoveT(eu.chaUI,eu.data.triggerID.."GBG")
				end
				if eu.chaUI[eu.data.triggerID.."GIcon"] then
					hApi.safeRemoveT(eu.chaUI,eu.data.triggerID.."GIcon")
				end
				local tgrData = eu:gettriggerdata()
				if tgrData ~= nil and tgrData.guard then
					if tgrData.guard[1] ~= 0 then
						local worldX1,worldY1 = eu:getstopXY()
						local worldX2,worldY2 = eu:getXY()
						local posX = worldX1 - worldX2
						local directionX = 0
						--大于0时 向→偏移
						if posX > 0 then
							directionX = 20
						--小于0时 向←偏移
						elseif posX < 0 then
							directionX = -20
						end
						--print("tgrData.guard[1]",tgrData.guard[1])
						local gU = oWorld:tgrid2unit(tgrData.guard[1])
						if gU ~= nil then
							if hVar.tab_unit[gU.data.id].type == 2 then
								eu.chaUI[eu.data.triggerID.."GBG"] = hUI.image:new({
									parent = eu.handle._tn,
									model = "UI_frm:slot",
									animation = "lightSlim",
									w = 50,
									h = 50,
									x = posX - directionX,
									y = -(worldY1 - worldY2) + 45,
								})
								local head = hVar.tab_unit[gU.data.id].icon
								if head == nil then
									head = hVar.tab_unit[gU.data.id].model
								end
								eu.chaUI[eu.data.triggerID.."GIcon"] = hUI.thumbImage:new(
								{
									parent = eu.handle._tn,
									model = head,
									w = 44,
									h = 44,
									x = posX - directionX,
									y = -(worldY1 - worldY2) + 45,
								})
							end
						end
					end
				end
			end)
		end
	end

	SHOW_WDLD_END = 0
	hGlobal.event:listen("Event_WorldCreated","look over WDLD",function(oWorld)
		--if g_phone_mode ~= 0 then return end
		--local mapname = hGlobal.WORLD.LastWorldMap.data.map
		if oWorld.data.type == "worldmap" and g_editor ~= 1 then
			if hApi.Is_WDLD_Map(oWorld.data.map) ~= -1 then
				if WDLD_NEED_CHANGE_OWNER_TAG == 1 then
				hGlobal.event:event("LocalEvent_ClearTownList")--清除在别人领地那的“主城”按钮
				--看或进攻别人的领地
					hClass.unit:enum(function(eu)
						if eu:gettab().seizable==1 or eu:gettown() then
							eu:setowner(3)
						end
					end)

					hClass.hero:enum(function(eh)
						eh:setowner(3)
						eh.data.AIMode = hVar.AI_MODE.GUARD_AGAINST
					end)
					oWorld:GetPlayerMe().localdata.focusUnitT = {}
					
					local ih = hApi.Split(g_WDLD_OtherOutHero,";")
					local ihIDS = {}
					for oih = 1,#ih do
						if ih[oih] ~= "" then
							--print(">>>>>>>",ih[oih])
							local oihID = tonumber(ih[oih])
							if oihID ~= nil and oihID ~= 0 then
								ihIDS[#ihIDS + 1] = oihID
								--print(">>>>>>>",oihID)
							end
						end
					end

					--给别人领地没有守卫的建筑加上默认守卫
					hClass.unit:enum(function(eu)
						for oih = 1,#ihIDS do
							if eu.data.id == ihIDS[oih] then
								eu:sethide(1)
								break
							end
							
						end
						if  eu:gettab().seizable == 1 then --资源建筑
							local tgrData = eu:gettriggerdata()
							if tgrData ~= nil and tgrData.guard then
								if tgrData.guard[1] == 0 then
									--print("吃葡萄不吐葡萄皮")
									--获得下一个可用的triggerID
									local maxTriggerID = 0
									oWorld:enumunit(function(oUnit)
										if oUnit.data.triggerID > maxTriggerID then
											maxTriggerID = oUnit.data.triggerID
										end
									end)
									--new一个单位
									local tx,ty = eu:getstopXY()
									--tx, ty = hApi.Scene_GetSpace(tx, ty, 50)
									local c,u
									
									c = hApi.addChaByID(oWorld,3,hVar.tab_unit[12036].group[1][2],tx,ty,0,nil)
									u = hApi.findUnitByCha(c)
									
									--给这个单位添加部队
									u.data.team = {}
									--local teamAdd = ut.data.team
									--teamAdd[1] = {10040,10}
									--teamAdd[2] = {10036,10}
									--u:teamaddunit(teamAdd)
									--绑定这个单位的triggerID 并让其在世界上合法 并设置属方
									u.data.triggerID = maxTriggerID + 1
									local tgrIndex = oWorld.data.triggerIndex
									local tgrDataN = {uniqueID = u.data.triggerID}
									tgrIndex[#tgrIndex + 1] = {u.ID,u.__ID,tgrDataN}
									u:setowner(3)
									tgrData.guard[1] = u.data.triggerID
									local bs = hVar.WDLD_RandomBattleScore[g_WDLD_OtherLv] or 1
									local ut = hApi.CreateArmyByGroup(oWorld,u,u,hVar.tab_unit[12036].group,bs,0)
									--让new出来的单位去守卫这个建筑
									--hGlobal.WORLD.LastWorldMap:WDLD_BuildingSetGuard(eu,u,0)
								end
							end
						end
					end)
				end
				WDLD_NEED_CHANGE_OWNER_TAG = 0
				if WDLD_NEED_ADD_MY_TEAM_TAG == 1 then
					if xlMap_ResetFog then
						xlMap_ResetFog()
					end
					for i = 1,#wdld_attackHT do
						--hGlobal.event:event("LocalEvent_CreateHeroAndTeamOnMap",oWorld,wdld_attackHT[i],wdld_attackT[i],i)
					end
					--Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleBegin,luaGetplayerDataID(),lookPlayer.roleid})
				end
				WDLD_NEED_ADD_MY_TEAM_TAG = 0

				if lookPlayer and WdldRoleId == lookPlayer.roleid then
					_childUI["back"]:setstate(1)
				else
					_childUI["back"]:setstate(-1)
				end
				WDLD_BUILDING_GUARD(oWorld)
			elseif hApi.Is_RSYZ_Map(oWorld.data.map) ~= -1 then
				print("燃烧的远征")
				hGlobal.event:event("LocalEvent_RSDYZ_ClearDefData")
				local tMapData = oWorld:getmapdata(1)
				local cut = tMapData.ChangeUnit
				local cindex = 0
				hClass.hero:enum(function(eh)
					--eh:setowner(3)
					--eh.data.AIMode = hVar.AI_MODE.GUARD_AGAINST
					
					for i = 1,9 do
						if eh:getowner() == hGlobal.player[i] then
							if cut ~= nil then
								for j = 1,#cut do
									if cut[j][1] == i then
										
										local cu = eh:getunit()
										local mx = cu.data.worldX
										local my = cu.data.worldY
										local c,u
										cindex = cindex + 1
									
										if cindex > #rsdyzPlayerHeroSaveList then
											cindex = 1
										end
										local rhid = cindex
										if rsdyz_playerIdAndName[rhid].str == "" then
											local rhindex = 1--hApi.random(1,#rsdyzPlayerHeroSaveList[rhid])
											print(rhid,rhindex,"415!!!!!!!!")
											local hid = rsdyzPlayerHeroSaveList[rhid][rhindex].id
											c = hApi.addChaByID(hGlobal.WORLD.LastWorldMap,cut[j][2],hid,mx,my,225,nil)
											u = hApi.findUnitByCha(c)

											local oHero = hClass.hero:new({
												name = hVar.tab_stringU[hid][1],
												id = hid,
												unit = u,
												owner = cut[j][2],
											})
											if rsdyzPlayerHeroSaveList[rhid][rhindex] ~= nil then
												oHero:LoadHeroFromCardForNPC(rsdyzPlayerHeroSaveList[rhid][rhindex],1)
											end
											local tuid = eh:getunit().data.triggerID or 0
											u:settriggerdata(nil,tuid)
											
											--local attrT = math.floor((cindex - 1)/4)
											--oHero:addattr("allAttr",5*attrT)

											local gtID = eh:getunit().data.curTown
											if gtID ~= nil and gtID ~= 0 then
												hClass.town:find(gtID):setguard(u)
											end
											
											for rhindex = 2,3 do
												if #rsdyzPlayerHeroSaveList[rhid] >= rhindex then
													hid = rsdyzPlayerHeroSaveList[rhid][rhindex].id
													c = hApi.addChaByID(hGlobal.WORLD.LastWorldMap,cut[j][2],hid,mx,my,225,nil)
													nu = hApi.findUnitByCha(c)

													local nHero = hClass.hero:new({
														name = hVar.tab_stringU[hid][1],
														id = hid,
														unit = nu,
														owner = cut[j][2],
													})
													if rsdyzPlayerHeroSaveList[rhid][rhindex] ~= nil then
														nHero:LoadHeroFromCardForNPC(rsdyzPlayerHeroSaveList[rhid][rhindex],1)
													end
													--nHero:addattr("allAttr",5*attrT)
													oHero:teamaddmember(nHero,rhindex)
												end
											end

											local x,y,cw,ch = u:getbox()
											u.chaUI["__P_NAME__"] = hUI.label:new({
												parent = u.handle._tn,
												font = hVar.FONTC,
												text = rsdyz_playerIdAndName[rhid].rolename,
												size = 24,
												RGB = {255,0,0},
												border = 1,
												align = "MB",
												y = -1*y+10,
												width = 2048,
											})

											cu:sethide(1)
											hGlobal.event:event("LocalEvent_RSDYZ_SetDefData",tuid,rsdyz_playerIdAndName[rhid].roleid,rsdyz_playerIdAndName[rhid].rolename)
										else--取玩家设为防守组的
											local idsT = {}
											print(rsdyz_playerIdAndName[rhid].str)
											idsT = hApi.Split(rsdyz_playerIdAndName[rhid].str,";")
											for a = 1,#idsT do
												idsT[a] = tonumber(idsT[a])
											end
											hid = idsT[1]
											c = hApi.addChaByID(hGlobal.WORLD.LastWorldMap,cut[j][2],hid,mx,my,225,nil)
											u = hApi.findUnitByCha(c)

											local oHero = hClass.hero:new({
												name = hVar.tab_stringU[hid][1],
												id = hid,
												unit = u,
												owner = cut[j][2],
											})
										
											local heroDT = nil
											for a = 1,#rsdyzPlayerHeroSaveList[rhid] do
												local thisT = rsdyzPlayerHeroSaveList[rhid][a]
												print(thisT.id,hid,#rsdyzPlayerHeroSaveList[rhid])
												if thisT.id == hid then
													heroDT = thisT
													break
												end
											end
											if heroDT ~= nil then
												oHero:LoadHeroFromCardForNPC(heroDT,1)
											end
											--local attrT = math.floor((cindex - 1)/4)
											--oHero:addattr("allAttr",5*attrT)
											local tuid = eh:getunit().data.triggerID or 0
											u:settriggerdata(nil,tuid)
											
											local gtID = eh:getunit().data.curTown
											if gtID ~= nil and gtID ~= 0 then
												hClass.town:find(gtID):setguard(u)
											end

											for a = 2,3 do
												if #idsT >= a then
													hid = idsT[a]
													c = hApi.addChaByID(hGlobal.WORLD.LastWorldMap,cut[j][2],hid,mx,my,225,nil)
													nu = hApi.findUnitByCha(c)

													local nHero = hClass.hero:new({
														name = hVar.tab_stringU[hid][1],
														id = hid,
														unit = nu,
														owner = cut[j][2],
													})
													for a = 1,#rsdyzPlayerHeroSaveList[rhid] do
														local thisT = rsdyzPlayerHeroSaveList[rhid][a]
														if thisT.id == hid then
															heroDT = thisT
															break
														end
													end
													if heroDT ~= nil then
														nHero:LoadHeroFromCardForNPC(heroDT,1)
													end
													--nHero:addattr("allAttr",5*attrT)
													oHero:teamaddmember(nHero,rhindex)
												end
											end

											local x,y,cw,ch = u:getbox()
											u.chaUI["__P_NAME__"] = hUI.label:new({
												parent = u.handle._tn,
												font = hVar.FONTC,
												text = rsdyz_playerIdAndName[rhid].rolename,
												size = 24,
												RGB = {255,0,0},
												border = 1,
												align = "MB",
												y = -1*y+10,
												width = 2048,
											})

											cu:sethide(1)
											hGlobal.event:event("LocalEvent_RSDYZ_SetDefData",tuid,rsdyz_playerIdAndName[rhid].roleid,rsdyz_playerIdAndName[rhid].rolename)
										end
									end
								end
							end
						end
					end
				end)
				print("燃烧的远征")
			end
		end
	end)

	--攻击按钮
	_CtrlChildUI["AttackBtn"] = hUI.button:new({
		parent = _Ctrlparent,
		label = hVar.tab_string["wdld_attack"],
		border = 1,
		w = 150,
		x = _RoleCtrlFrm.data.w/2,
		y = -_RoleCtrlFrm.data.h + 30,
		scaleT = 0.9,
		dragbox = _CtrlChildUI["dragBox"],
		code = function()
			print("Attack this player")
			--hGlobal.event:event("LocalEvent_ShowWdldAttackFrame",1,3)--进入别人领地的英雄个数
			hGlobal.event:event("LocalEvent_ShowWdldAttackOtherPlayerFrame",1,3)
			_RoleCtrlFrm:show(0)
		end,
	})
	
	--设置此面板的信息
	local _setFrmInfo = function(info)
		local roleid,rolename,lv,exp = 0,0,0,0
		
		local ResTab = {}
		for i = 1,6 do
			ResTab[i] = 0
		end
		if type(info) == "table" then
			roleid = info.roleid
			rolename = info.rolename
			lv = info.lv
			exp = info.exp
			
			ResTab[hVar.RESOURCE_TYPE.LIFE] = info.iron
			ResTab[hVar.RESOURCE_TYPE.WOOD] = info.wood
			ResTab[hVar.RESOURCE_TYPE.FOOD] = info.food
			ResTab[hVar.RESOURCE_TYPE.GOLD] = info.gold
			ResTab[hVar.RESOURCE_TYPE.STONE] = info.stone
			ResTab[hVar.RESOURCE_TYPE.CRYSTAL] =  info.crystal
		end

		_CtrlChildUI["playName"]:setText(tostring(rolename))
		_CtrlChildUI["playLv"]:setText(tostring(lv))
		_CtrlChildUI["playExp"]:setText(tostring(exp))

		for i = 1,6 do
			_CtrlChildUI["resNode_"..i].childUI["ResLab"]:setText(tostring(ResTab[i]))
		end

		g_WDLD_OtherLv = lv
	end

	--打开此面板的监听
	hGlobal.event:listen("LocalEvent_ShowMyCityZonePlayerInfo","openThisFrm",function(playerInfo)
		lookPlayer = playerInfo
		--_setFrmInfo(playerInfo)
		--_RoleCtrlFrm:show(1)
		--_RoleCtrlFrm:active()
		hGlobal.event:event("LocalEvent_WdldAttackOtherFrameSetPlayerInfo",playerInfo)
		hGlobal.event:event("LocalEvent_ShowWdldAttackOtherPlayerFrame",1,3)
	end)
end