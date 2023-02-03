local __OpenEditorMode = function()
	hGlobal.event:listen("LocalEvent_HitOnTarget","__WM__CommonOperate",nil)
	hGlobal.event:listen("LocalEvent_TouchOnWorld","__WM__CommonOperate",nil)
	local __Unit = {}
	local __tick = 0
	hGlobal.event:listen("LocalEvent_HitOnTarget","__EDT__HitOnUnit",function(oWorld,oUnit,worldX,worldY)
		--geyachao: 防止弹框
		if (not oUnit) or (oUnit == 0) then
			return
		end
		
		--if hApi.GetObject(oUnit)==oUnit and hApi.gametime()-__tick<=500 then
			--return
		--end
		--hApi.SetObject(__Unit,oUnit)
		--__tick = hApi.gametime()
		local w = oWorld
		local panel = w.worldUI["UI_UNIT_OPERATING_PANEL"]
		if panel and panel.data.bindU==oUnit.ID and panel.data.infoOnly==1 then
			--if panel.data.tick==0 then
				--panel:select(1,500)
			--end
		else
			if xlEditorPickCha~=nil then
				if xlEditorPickCha()==oUnit.handle._c then
					return
				end
			end
			hApi.safeRemoveT(w.worldUI,"UI_UNIT_OPERATING_PANEL")
			if rawget(hVar.tab_stringU,oUnit.data.id) then
				w.worldUI["UI_UNIT_OPERATING_PANEL"] = hUI.targetPanel:new({
					world = oWorld,
					target = oUnit,
					orderUnit = nil,
					infoOnly = 1,
				})
			end
		end
	end)
	
	local w = hGlobal.WORLD.LastWorldMap
	if w then 
		w:enumunit(function(eu)
			if eu.data.IsHide==1 then
				eu:sethide(0)
				eu.data.IsHide = -1
			elseif eu.data.editorID==0 and eu.data.triggerID~=0 then
				eu:sethide(1)
				eu.data.IsHide = -2
			end
			--if eu.data.type==hVar.UNIT_TYPE.GROUP then
				--eu:sethide(0)
			--else
				--local oTown = eu:gettown()
				--if oTown then
					--local gU = hApi.GetObjectUnit(oTown.data.guard)
					--if gU then
						--gU:sethide(0)
					--end
				--end
			--end
		end)
	end
	
	--hGlobal.event:listen("LocalEvent_HitOnTarget","__EDT__HitOnUnit",function(oWorld,oUnit,worldX,worldY)
		--local panel,CreatePanel,CreateDrag
		--local x,y,w,h = oUnit:getbox()
		--y = y or 0
		--h = h or 20
		--local btnX = 0
		--local btnY = 0
		--local btnH = 32
		--local function GetBtnY()
			--btnY = btnY - btnH
			--return btnY
		--end
		--CreateDrag = function()
			--if oUnit.handle._c~=nil then
				--xlEditorBeginLink(oUnit.handle._c)
				--hUI.dragBox:new({
					--top = 1,
					--autorelease = 1,
					--codeOnDrop = function(x,y,screenX,screenY)
						--local x,y = hApi.ui2world(screenX,screenY)
						--local u = oWorld:hit2unit(x,y,"editor")
						--local c
						--if u~=nil then
							--c = u.handle._c
						--end
						--xlEditorEndLink(c)
						--CreatePanel()
					--end
				--}):select()
			--end
		--end
		--CreatePanel = function()
			--btnY = -1*y-h+16
			--panel = hGlobal.O:replace("EDT_TargetPanel",hUI.panel:new({
				--unit = oUnit,
				--menu = 1,
				--child = {
					--{
						--__UI = "button",
						--mode = "imageButton",
						--scaleT = 0.8,
						--w = -1,
						--h = btnH,
						--x = btnX,
						--y = GetBtnY(),
						--label = "关闭",
						--code = function(btn)
							--btn.data.enable = 0
							--panel:settick(250)
						--end,
					--},
					--{
						--__UI = "button",
						--mode = "imageButton",
						--scaleT = 0.8,
						--w = -1,
						--h = btnH,
						--x = btnX,
						--y = GetBtnY(),
						--label = "设置守卫",
						--codeOnDrag = function(btn,x,y,IsInBox)
							--if IsInBox==hVar.RESULT_FAIL then
								--CreateDrag()
								--btn.data.enable = 0
								--panel:settick(100)
							--end
						--end,
					--},
				--},
			--}))
		--end
		--CreatePanel()
	--end)
end

local __CloseEditorMode = function()
	hGlobal.UI.InitWorldMapOperation()
	hGlobal.event:listen("LocalEvent_HitOnTarget","__EDT__HitOnUnit",nil)

	local w = hGlobal.WORLD.LastWorldMap
	if w then 
		w:enumunit(function(eu)
			if eu.data.IsHide==-1 then
				eu:sethide(1)
			elseif eu.data.IsHide==-2 then
				eu:sethide(0)
			end
			--if eu.data.type==hVar.UNIT_TYPE.GROUP then
				--eu:sethide(1)
			--else
				--local oTown = eu:gettown()
				--if oTown then
					--local gU = hApi.GetObjectUnit(oTown.data.guard)
					--if gU then
						--gU:sethide(1)
					--end
				--end
			--end
		end)
	end
end

if hGlobal.O["EditorPanel"]==nil then
	if hGlobal.EditorIsOn==1 then
		hGlobal.EditorIsOn = 0
		__CloseEditorMode()
	end
	local btnY = 0
	local _GetBtnY = function()
		btnY = btnY - 50
		return btnY
	end
	local _sceobjSel = {
		enable = {text = _T("场景物件:可选"),RGB = {100,255,0}},
		disable = {text = _T("场景物件:禁选"),RGB = {255,150,0}},
	}

	hGlobal.O:replace("EditorPanel",hUI.frame:new({
		x = 100,
		y = 460,
		w = 300,
		h = 440,
		top = 1,
		closebtn = 1,
		child = {
			{
				__UI = "button",
				__NAME = "cqc",
				x = 140,
				y = _GetBtnY(),
				label = "编辑模式:关",
				scaleT = 0.9,
				w = 240,
				code = function(btn)
					if hGlobal.EditorIsOn~=1 then
						hGlobal.EditorIsOn = 1
						__OpenEditorMode()
						btn.childUI["label"]:setText("编辑模式:开")
						btn.childUI["label"].handle.s:setColor(ccc3(30,255,100))
						if hGlobal.WORLD.LastWorldMap~=nil then
							hGlobal.WORLD.LastWorldMap:enumunit(function(u)
								u:setowner(u.data.owner,2)	--这个模式一定会有小旗子
							end)
						end
						hGlobal.event:listen("Event_UnitCreated","__ShowUnitFlag",function(oUnit)
							--这个模式只要打开就一定可以编辑小旗子
							oUnit:setowner(oUnit.data.owner,2)
						end)
					else
						hGlobal.EditorIsOn = 0
						__CloseEditorMode()
						btn.childUI["label"]:setText("编辑模式:关")
						btn.childUI["label"].handle.s:setColor(ccc3(255,255,255))
						--if hGlobal.WORLD.LastWorldMap~=nil then
							--hGlobal.WORLD.LastWorldMap:enumunit(function(u)
								--u:setowner(u.data.owner,1)
							--end)
						--end
					end
				end,
			},
			{
				__UI = "button",
				x = 140,
				y = _GetBtnY(),
				w = 240,
				label = hVar.SCEOBJ_SELECTABLE~=0 and _sceobjSel.enable or _sceobjSel.disable,
				scaleT = 0.8,
				code = function(self)
					if hVar.SCEOBJ_SELECTABLE==0 then
						hVar.SCEOBJ_SELECTABLE = 1
						local t = _sceobjSel.enable
						self.childUI["label"]:setText(t.text)
						self.childUI["label"].handle.s:setColor(ccc3(unpack(t.RGB)))
						hClass.sceobj:enableselect(1)
					else
						hVar.SCEOBJ_SELECTABLE = 0
						local t = _sceobjSel.disable
						self.childUI["label"]:setText(t.text)
						self.childUI["label"].handle.s:setColor(ccc3(unpack(t.RGB)))
						hClass.sceobj:enableselect(0)
					end
				end,
			},
			{
				__UI = "button",
				x = 140,
				y = _GetBtnY(),
				w = 240,
				label = "开启移动瞬移",
				scaleT = 0.8,
				code = function(self)
					self:setstate(0)
					--点到了世界地图上，创建一个移动按钮
					local _PanelEnable = 0
					hGlobal.event:listen("LocalEvent_TouchOnWorld","__WM__CommonOperate",function(oWorld,worldX,worldY)
						local w = oWorld
						if w.data.type=="worldmap" then
							if hApi.IsInEditorDrag() then
								return
							end
							local t = oUnit
							local p = hGlobal.LocalPlayer
							local u = hGlobal.LocalPlayer:getfocusunit()
							if u~=nil then
								_PanelWorld = oWorld
								_PanelX,_PanelY = worldX,worldY
								local gridX,gridY = w:xy2grid(worldX,worldY)
								local x,y = w:grid2xy(gridX,gridY)
								local canMove = w:drawwaypoint(u,x,y)
								local panel
								local code
								local model = "ICON:action_move"
								if canMove==hVar.RESULT_SUCESS then
									_PanelEnable = 1
								else
									_PanelEnable = 0
								end
								local panel
								panel = hGlobal.O:replace("__WM__MoveOperatePanel",hUI.panel:new({
									bindTag = "UI_WORLD_WAYPOINT",
									world = w,
									menu = 1,
									x = x,
									y = y,
									child = {
										__NAME = "moveToGrid",
										__UI = "button",
										mode = "imageButton",
										model = model,
										x = 10,
										y = -10,
										scale = 0.75,
										scaleT = 0.75,
										model = model,
										code = function(self)
											if panel.data.tick==0 then
												panel:settick(800)
												local a = CCArray:create()
												a:addObject(CCDelayTime:create(0.3))
												a:addObject(CCFadeOut:create(0.5))
												self.handle.s:runAction(CCSequence:create(a))
												--p:order(w,hVar.OPERATE_TYPE.UNIT_MOVE,u,hVar.ZERO,nil,gridX,gridY,worldX,worldY)
												u:setgrid(gridX,gridY,hVar.OPERATE_TYPE.UNIT_MOVE)
											end
										end,
									},
								}))
								if canMove==hVar.RESULT_FAIL then
									panel.childUI["moveToGrid"].handle.s:setColor(ccc3(255,0,0))
								end
							end
						end
					end)
				end,
			},
			{
				__UI = "button",
				x = 140,
				y = _GetBtnY(),
				w = 240,
				label = hVar.SHOW_EDITOR_ID==1 and "显示ID:关" or "显示ID:开",
				scaleT = 0.8,
				code = function(btn)
					if hVar.SHOW_EDITOR_ID==1 then
						hVar.SHOW_EDITOR_ID = 0
						btn.childUI["label"]:setText("显示ID:开")
					else
						hVar.SHOW_EDITOR_ID = 1
						btn.childUI["label"]:setText("显示ID:关")
					end
					local w = hGlobal.LocalPlayer:getfocusworld()
					if w then
						if w.data.type=="worldmap" then
							w:enumunit(function(u)
								if u.data.triggerID~=0 then
									if u.chaUI["TGR_ID"]==nil then
										u.chaUI["TGR_ID"] = hUI.label:new({
											parent = u.handle._tn,
											font = "numWhite",
											align = "MC",
											size = 12,
											y = 20,
											text = "["..u.data.triggerID.."]",
										})
									end
									if hVar.SHOW_EDITOR_ID==1 then
										u.chaUI["TGR_ID"].handle.s:setVisible(true)
									else
										u.chaUI["TGR_ID"].handle.s:setVisible(false)
									end
								end
							end)
						elseif w.data.type=="town" then
							w:enumunit(function(u)
								if u.data.indexOfCreate~=0 then
									if u.chaUI["TGR_ID"]==nil then
										u.chaUI["TGR_ID"] = hUI.label:new({
											parent = u.handle._tn,
											font = "numWhite",
											align = "MC",
											size = 12,
											y = 20,
											text = "["..u.data.indexOfCreate.."]",
										})
									end
									if hVar.SHOW_EDITOR_ID==1 then
										u.chaUI["TGR_ID"].handle.s:setVisible(true)
									else
										u.chaUI["TGR_ID"].handle.s:setVisible(false)
									end
								end
							end)
						end
					end
				end,
			},
			--{
				--__UI = "button",
				--x = 140,
				--y = _GetBtnY(),
				--w = 240,
				--label = "小战场模式",
				--scaleT = 0.8,
				--code = function(btn)
					--local oWorld = hGlobal.LocalPlayer:getfocusworld()
					--if oWorld then
						--local sType = oWorld.data.type
						--oWorld.data.type = "battlefield"
						--oWorld:loadMapGrid("BATTLEFIELD")
						--oWorld.data.IsDrawGrid = 1
						--oWorld.data.borderW = 0
						--oWorld.data.borderH = 0
						--if oWorld.handle._bn==nil then
							--oWorld.handle._bn = hApi.SpriteInitBatchNode(oWorld.handle,"MODEL:grid")
							--oWorld.handle._n = CCNode:create()
							--oWorld.handle.worldLayer:addChild(oWorld.handle._n,hVar.ObjectZ.MAP+0)
							--oWorld.handle._n:addChild(oWorld.handle._bn,hVar.ObjectZ.MAP+1)
						--end
						--oWorld:drawgrid("default","green")
						--oWorld.data.type = sType
					--end
				--end,
			--},
			{
				__UI = "button",
				x = 140,
				y = _GetBtnY(),
				w = 240,
				label = "点击就送:关",
				scaleT = 0.8,
				code = function(btn)
					if btn.data.userdata==0 then
						btn.data.userdata = 1
						btn.childUI["label"]:setText("点击就送:开")
						hGlobal.event:listen("LocalEvent_HitOnShopItem","__GetItem",function(nItemID)
							hGlobal.event:event("NetEvent_L2CReward",9999,"点击就送","ooooo","idx:1;qst:1000;rw:{it,"..nItemID.."};")
						end)
						hGlobal.event:listen("LocalEvent_ShowBuyHeroCardFrm","__GetHero",function(oHero,shopID,off,heroID, star, lv)
							if type(heroID)=="number" and hApi.GetHeroCardById(heroID)==nil then
								hGlobal.event:event("LocalEvent_BuyHeroCardSucceed",heroID, star, lv)
							end
						end)
					else
						btn.data.userdata = 0
						btn.childUI["label"]:setText("点击就送:关")
						hGlobal.event:listen("LocalEvent_HitOnShopItem","__GetItem",nil)
						hGlobal.event:listen("LocalEvent_ShowBuyHeroCardFrm","__GetHero",nil)
					end
				end,
			},
			{
				__UI = "button",
				x = 140,
				y = _GetBtnY(),
				w = 240,
				label = "作弊01",
				scaleT = 0.8,
				code = function(btn)
					local oWorld = hGlobal.LocalPlayer:getfocusworld()
					if oWorld and g_curPlayerName~=nil then
						cheat01()
						--作弊模式下击败郭胜，全身装备变3全才
						hGlobal.event:listen("Event_HeroDefeated","__Editor__WhosYourDaddy",function(oHero,oHeroK)
							if oHeroK~=nil and oHeroK:getowner()==hGlobal.LocalPlayer and oHeroK.data.HeroCard==1 and type(oHeroK.data.item[1])=="table" and oHeroK.data.item[1][1]==1000 then
								for i = 1,7 do
									local oItem = oHeroK:getbagitem("equip",i)
									if oItem and type(oItem[hVar.ITEM_DATA_INDEX.SLOT])=="table" and (oItem[SLOT][1] or 0)>0 then
										for i = 2,oItem[hVar.ITEM_DATA_INDEX.SLOT][1]+1 do
											oItem[hVar.ITEM_DATA_INDEX.SLOT][i] = 32
										end
									end
								end
								LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
							end
						end)
					end
					--点击后重铸效果改为将所有孔变成3全才
					hApi.RecastItem = function(oHero,vOrderId)
						if type(vOrderId) ~= "table" then
							return
						end
						print("Cheat Recast Item!!!!!")
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
										oItem[hVar.ITEM_DATA_INDEX.SLOT][RecastTable[i]+1] = 32
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
				end,
			},
			{
				__UI = "button",
				x = 140,
				y = _GetBtnY(),
				w = 240,
				label = "自动战斗:开",
				scaleT = 0.8,
				code = function(btn)
					local oWorld = hGlobal.LocalPlayer:getfocusworld()
					if oWorld and oWorld.data.type=="battlefield" then
						if oWorld.data.autoBF==1 then
							oWorld.data.autoBF = 0
							hVar.OPTIONS.AUTO_BATTLEFIELD = 0
							btn.childUI["label"]:setText("自动战斗:关")
						else
							oWorld.data.autoBF = 1
							hVar.OPTIONS.AUTO_BATTLEFIELD = 1
							btn.childUI["label"]:setText("自动战斗:开")
						end
					else
						if hVar.OPTIONS.AUTO_BATTLEFIELD==1 then
							hVar.OPTIONS.AUTO_BATTLEFIELD = 0
							btn.childUI["label"]:setText("自动战斗:关")
						else
							hVar.OPTIONS.AUTO_BATTLEFIELD = 1
							btn.childUI["label"]:setText("自动战斗:开")
						end
					end
				end,
			},
			{
				__UI = "button",
				x = 140,
				y = _GetBtnY(),
				w = 240,
				label = "编辑刀光",
				scaleT = 0.8,
				code = function(btn)
					hGlobal.Editor.ShowModelViewer()
					hGlobal.O["EditorPanel"]:show(0)
				end,
			},
		},
	}))
else
	local f = hGlobal.O["EditorPanel"]
	if f.data.show==0 then
		f:onscreen()
		f:show(1,"normal")
		f:active()
	else
		f:show(0,"normal")
	end
end

touchDownEidtorBtn = function(pra)
	if pra == 1 then
		hGlobal.EditorIsOn = 1
		__OpenEditorMode()
		hGlobal.O["EditorPanel"].childUI["cqc"].childUI["label"]:setText("编辑模式:开")
		hGlobal.O["EditorPanel"].childUI["cqc"].childUI["label"].handle.s:setColor(ccc3(30,255,100))
		if hGlobal.WORLD.LastWorldMap~=nil then
			hGlobal.WORLD.LastWorldMap:enumunit(function(u)
			u:setowner(u.data.owner,2)	--这个模式一定会有小旗子
			end)
		end
		hGlobal.event:listen("Event_UnitCreated","__ShowUnitFlag",function(oUnit)
							--这个模式只要打开就一定可以编辑小旗子
			oUnit:setowner(oUnit.data.owner,2)
		end)
	else
		hGlobal.EditorIsOn = 0
		__CloseEditorMode()
		hGlobal.O["EditorPanel"].childUI["cqc"].childUI["label"]:setText("编辑模式:关")
		hGlobal.O["EditorPanel"].childUI["cqc"].childUI["label"].handle.s:setColor(ccc3(255,255,255))
	end
end

local __CreateSlashControl = function(frm,ParamTab,BaseTab,CodeOfSlash)
	frm.handle._tn = CCNode:create()
	frm.handle._tn:setPosition(frm.childUI["back"].data.x,frm.childUI["back"].data.y)
	frm.handle._n:addChild(frm.handle._tn,9999)
	local LastTick = 0
	local DefaultTab = {}
	local CurrentTab = nil
	for k,v in pairs(BaseTab)do
		if k~="index" then
			v[4] = math.max(1,v[4] or 1)
			DefaultTab[k] = v[1]
		end
	end
	for _,aTab in pairs(ParamTab)do
		for k,v in pairs(aTab)do
			if type(v)=="table" then
				for i = 1,#BaseTab.index do
					local n = BaseTab.index[i]
					if v[n]==nil then
						v[n] = DefaultTab[n]
					end
				end
			end
		end
	end
	local ReadParamV = function(k,pec)
		if CurrentTab and frm.childUI["ValueBar_"..k] then
			local _,nMin,nMax,nMul = unpack(BaseTab[k])
			local bVal = nMax-nMin
			local newVal
			if pec then
				newVal = math.min(nMax,nMin+hApi.floor((bVal+1)*pec))
			end
			if newVal~=CurrentTab[k] then
				if newVal~=nil then
					CurrentTab[k] = newVal
				end
				frm.childUI["ValueLabel_"..k]:setText(tostring(k)..":"..tostring(CurrentTab[k]/nMul))
				frm.childUI["ValueBar_"..k]:setV(CurrentTab[k]-nMin,bVal)
			end
		end
	end
	local barY = -300
	local barH = 24
	local count = 0
	for i = 1,#BaseTab.index do
		local k = BaseTab.index[i]
		count = count + 1
		barY = barY - barH - 6
		frm.childUI["ValueBar_"..k] = hUI.valbar:new({
			parent = frm.handle._n,
			x = 32,
			y = barY,
			w = frm.data.w-64,
			h = barH,
		})
		frm.childUI["ValueLabel_"..k] = hUI.label:new({
			parent = frm.handle._n,
			x = frm.data.w/2,
			y = barY,
			align = "MC",
			text = "/",
		})
		frm.childUI["ValueBtn_"..k] = hUI.button:new({
			parent = frm,
			x = frm.data.w/2,
			y = barY,
			w = frm.data.w-64,
			h = barH,
			model = -1,
			codeOnTouch = function(self,x,y,sus)
				local pec = math.min(1,math.max(0,(x-32)/self.data.w))
				ReadParamV(k,pec)
			end,
			codeOnDrag = function(self,x,y,sus)
				local pec = math.min(1,math.max(0,(x-32)/self.data.w))
				ReadParamV(k,pec)
			end,
		})
	end
	local AnimationToPlay
	if xlAddKnifeLightWithAngle then
		local __SlashCodeA = xlAddKnifeLightWithAngle
		hApi.addTimerForever("__EDT_ModelSlash",hVar.TIMER_MODE.GAMETIME,1,function(tick)
			if LastTick<=tick then
				local img = frm.childUI["thumb"]
				local tick = hApi.gametime()
				if img.data.animation~="stand" then
					img:setmodel(img.data.model,"stand",nil,192,192)
					LastTick = tick + 750
				elseif AnimationToPlay~=nil then
					img:setmodel(img.data.model,AnimationToPlay,nil,192,192)
					LastTick = tick + img.handle.animationtime + 1
				end
				--if img.data.animation=="stand" then
					--LastTick = LastTick + 750
					--return
				--else
					--LastTick = LastTick + img.handle.animationtime
				--end
				local ani = img.data.animation
				if ParamTab[ani]==nil then
					return
				end
				local aTag = hApi.calAngleS(img.handle.modelmode,img.data.facing)
				if ParamTab[ani][aTag]==nil then
					ParamTab[ani][aTag] = hApi.ReadParam(DefaultTab,nil,{})
				end
				CurrentTab = ParamTab[ani][aTag]
				for k in pairs(CurrentTab)do
					ReadParamV(k)
				end
				for i = 1,10 do
					local p = ParamTab[ani..i]
					if p and p[aTag] then
						local s = CodeOfSlash(p[aTag])
						if s~=nil then
							s:getParent():removeChild(s,false)
							frm.handle._tn:addChild(s)
						end
					end
				end
				local s = CodeOfSlash(CurrentTab)
				if s~=nil then
					s:getParent():removeChild(s,false)
					frm.handle._tn:addChild(s)
				end
			end
		end)
	end
	local code = function(tick,animation)
		LastTick = tick or 0
		if animation~=0 then
			AnimationToPlay = animation
		end
		local img = frm.childUI["thumb"]
		local ani = AnimationToPlay or 0
		if animation==nil or ParamTab[ani]==nil then
			if CurrentTab~=nil then
				CurrentTab = nil
				for i = 1,#BaseTab.index do
					local k = BaseTab.index[i]
					frm.childUI["ValueLabel_"..k]:setText("/")
					frm.childUI["ValueBar_"..k]:setV(100,100)
				end
			end
			return
		end
		local aTag = hApi.calAngleS(img.handle.modelmode,img.data.facing)
		if ParamTab[ani][aTag]==nil then
			ParamTab[ani][aTag] = hApi.ReadParam(DefaultTab,nil,{})
		end
		if CurrentTab==ParamTab[ani][aTag] then
			return
		end
		CurrentTab = ParamTab[ani][aTag]
		for k in pairs(CurrentTab)do
			ReadParamV(k)
		end
	end
	return code
end

hGlobal.Editor = {}
hGlobal.Editor.ShowModelViewer = function(self,id)
	if id==nil then
		if type(hGlobal.LocalPlayer.heros[1])=="table" then
			id = hGlobal.LocalPlayer.heros[1].data.id
		else
			return
		end
	end
	local cX,cY = 192,-168
	local _WH = 192
	local _frm
	local _BtnY = 0
	local _UNIT_ID = tonumber(id)--10008
	if hGlobal.O["__UnitDummyEditor"]~=nil then
		_frm = hGlobal.O["__UnitDummyEditor"]
		_frm.childUI["thumb"]:del()
		_frm.childUI["thumb"] = hUI.thumbImage:new({
			parent = _frm.handle._n,
			id = _UNIT_ID,
			animation = "stand",
			facing = 0,
			x = cX,
			y = cY-48,
			w = _WH,
			h = _WH,
		})
	else
		local LastKeep
		local ResetFacingCode = hApi.DoNothing
		local _SideBtn = function(key,code,codeEx)
			_BtnY = _BtnY - 56
			local t = {
				__UI = "button",
				__NAME = "btn_"..key,
				label = key,
				scaleT = 0.9,
				x = 400,
				y = _BtnY,
			}
			if code~=nil then
				t.code = code
			else
				t.code = function()
					local img = _frm.childUI["thumb"]
					if img~=nil then
						img:setmodel(img.data.model,key,nil,_WH,_WH)
					end
					if codeEx then
						return codeEx()
					end
				end
			end
			return t
		end
		local CurrentAnimation = "stand"
		local SaveP = {attack = "kn",skill = "kn"}
		for i = 1,10 do
			SaveP["attack"..i] = "kn"
			SaveP["skill"..i] = "kn"
		end
		_frm = hGlobal.O:replace("__UnitDummyEditor",hUI.frame:new({
			x = 100,
			y = 740,
			w = 500,
			h = 720,
			top = 1,
			child = {
				{
					__NAME = "back",
					__UI = "button",
					model = "UI_frm:slot",
					animation = "lightSlim",
					x = cX,
					y = cY,
					w = 256,
					h = 256,
					codeOnDrag = function(self,x,y)
						x = x-cX
						y = y-cY
						local img = _frm.childUI["thumb"]
						if img~=nil then
							img:setfacing(hApi.angleBetweenPoints(0,0,x,-1*y))
							--ResetFacingCode(hApi.gametime() + img.handle.animationtime,0)
						end
					end,
				},
				{
					__NAME = "thumb",
					__UI = "thumbImage",
					id = _UNIT_ID,
					animation = "stand",
					facing = 0,
					x = cX,
					y = cY-48,
					w = _WH,
					h = _WH,
				},
				_SideBtn("stand",nil,function()
					CurrentAnimation = "stand"
					LastKeep = nil
					_frm.childUI["btn_keep"].childUI["label"]:setText("keep")
					return ResetFacingCode(0)
				end),
				_SideBtn("attack",function()CurrentAnimation = "attack" return ResetFacingCode(0,CurrentAnimation) end),
				_SideBtn("skill",function()CurrentAnimation = "skill" return ResetFacingCode(0,CurrentAnimation) end),
				_SideBtn("keep",function()
					--local img = _frm.childUI["thumb"]
					--local ani = CurrentAnimation
					--local sTab = hGlobal.Editor.SlashParamTab
					--if sTab and sTab[ani] then
						--local aTag = hApi.calAngleS(img.handle.modelmode,img.data.facing)
						--if sTab[ani][aTag] then
							--if LastKeep==nil then
								--_frm.childUI["btn_keep"].childUI["label"]:setText("load")
								--LastKeep = hApi.ReadParam(sTab[ani][aTag],nil,{})
							--else
								--_frm.childUI["btn_keep"].childUI["label"]:setText("keep")
								--hApi.ReadParam(LastKeep,nil,sTab[ani][aTag])
								--LastKeep = nil
								--ResetFacingCode(0,0)
							--end
						--end
					--end
				end),
				_SideBtn("save",function()
					if hGlobal.Editor.SlashParamTab==nil then
						hGlobal.Editor.SlashParamTab = {}
					end
					local tab = hApi.SaveTableEx(hGlobal.Editor.SlashParamTab,{"hGlobal.Editor.SlashParamTab"},SaveP)
					local f = io.open("SlashData.lua","w")
					for i = 1,#tab do
						f:write(tab[i])
					end
					f:close()
				end),
			},
		}))
		hGlobal.Editor.SlashParamTab = {}
		if hApi.FileExists("SlashData.lua") then
			dofile("SlashData.lua")
		end
		local spTab = hGlobal.Editor.SlashParamTab
		spTab.attack = spTab.attack or {}
		spTab.skill = spTab.skill or {}
		local SlashPath = hVar.SLASH_PATH["slash_1"]
		if type(SlashPath)=="string" then
			SlashPath = {hVar.SLASH_PATH["slash_1"]}
		end
		ResetFacingCode = __CreateSlashControl(_frm,hGlobal.Editor.SlashParamTab,{
			index={"model","x","y","width","r","roll","facing","shape","fadeIn","fadeOut","delay","delayEx","cycleShape"},
			model = {1,1,#SlashPath},
			x = {0,-100,100,100},
			y = {0,-100,100,100},
			width = {200,-270,270},
			r = {100,0,200},
			roll = {0,-360,360},
			facing = {0,-360,360},
			shape = {20,1,100},
			fadeIn = {15,0,100,100},
			fadeOut = {60,0,100,100},
			delay = {0,0,500,100},
			delayEx = {220,0,500,100},
			cycleShape = {40,1,100,100},
		},function(param)
			local path = SlashPath[param.model] or SlashPath[1]
			local width = param.width
			local r = param.r
			local roll = param.roll
			local facing = param.facing
			local nShape = param.shape
			local x = hApi.floor(param.x*96/100)
			local y = hApi.floor(param.y*96/100)
			local fadeIn = param.fadeIn/100
			local fadeOut = param.fadeOut/100
			local fDelay = param.delay/100
			local fDelayEx = param.delayEx/100
			local fCycleShape = param.cycleShape/100
			--texturePath,fadeIn,x,y,facing,width,r,roll,fadeOut,nShape,fDelay,fDelayEx,fCycleShape
			return xlAddKnifeLightWithAngle(path,fadeIn,x,y,facing,width,r,roll,fadeOut,nShape,fDelay,fDelayEx,fCycleShape)
		end)
	end
end

hGlobal.Editor.HeroAttrLog = function(sInputPath,sOutputPath)
	sInputPath = sInputPath or "tab_unit.lua"
	sOutputPath = sOutputPath or "attr.txt"
	local GameHero = {}

	for id in pairs(hVar.HERO_FREE) do
		GameHero[id] = 1
	end

	for i = 1,999 do
		local tabSI = hVar.tab_shopitem[i]
		if tabSI and hVar.tab_item[tabSI.itemID].type==hVar.ITEM_TYPE.HEROCARD then
			GameHero[hVar.tab_item[tabSI.itemID].heroID] = 1
		end
	end

	local tabU = hVar.tab_unit
	dofile(sInputPath)
	hVar.tab_unit_old = hVar.tab_unit
	hVar.tab_unit = tabU

	local f = io.open(sOutputPath,"w")
	if f then
		local tAttr = {"lea","led","str","int","con"}
		local tToken = {0,0}
		local ShowHeroAttr = function(pre,id,tabU)
			if tabU and tabU.type==hVar.UNIT_TYPE.HERO and tabU.hero_attr and GameHero[id] then
				local s = pre..(hVar.tab_stringU[id][1] or "unit_"..id).."["
				for i = 1,#tAttr do
					local k = tAttr[i]
					local v = tabU.hero_attr[k] or tToken
					s = s.."	"..k..v[1].."+"..(v[2] or 0)..","
				end
				if pre=="--" then
					f:write(s.."\n\n")
				else
					f:write(s.."\n")
				end
			end
		end
		for id = 1,9999 do
			ShowHeroAttr("**",id,hVar.tab_unit[id])
			ShowHeroAttr("--",id,hVar.tab_unit_old[id])
		end
		f:close()
	end
end

hGlobal.Editor.DropTest = function(id,number,CanReRoll)
	if id==nil then
		return print("参数错误")
	end
	if hVar.tab_item[id]==nil then
		return print("没有"..id.."的物品！")
	end
	--local drop = {
		--"copper_box",
		--{10,1},
		--{10,1},
		--{10,1},
		--{10,1},
		--{10,1},
		--{20,1},
		--{30,2},
		--{40,4},
	--}

	--local drop = {
		--"gold_box",
		--{20,2},
		--{20,2},
		--{20,2},
		--{40,2},
		--{40,2},
		--{40,3},
		--{60,3},
		--{90,5},
	--}

	--local drop = {
		--"silver_box",
		--{20,2},
		--{20,2},
		--{20,2},
		--{20,2},
		--{20,2},
		--{40,2},
		--{40,4},
		--{80,5},
	--}
	local drop
	if hVar.tab_item[id].used and hVar.tab_item[id].used[1]=="treasure" and hVar.tab_item[id].used[2]=="item" then
		drop = hVar.tab_item[id].used[3]
	end
	if drop==nil then
		return print(id.."不是宝箱！")
	end
	local dropName = drop[1]
	local tempDrop = hVar.tab_drop[hVar.tab_drop.index[dropName]]
	local dropId = {}
	local dropCount = {}
	--local dropString = {
		--[0] = "灰色",
		--[1] = "白色",
		--[2] = "蓝色",
		--[3] = "金色",
		--[4] = "红色",
	--}
	local tQuality = {
		[0] = "0",
		[1] = "white",
		[2] = "blue",
		[3] = "gold",
		[4] = "red",
	}
	local nDropCount = 0
	local nDropNum = number or 1000
	hApi.addTimerForever("__TEST__DropCount__",hVar.TIMER_MODE.GAMETIME,1,function()
		local step = math.min(200,nDropNum-nDropCount)
		nDropCount = nDropCount + step
		local tDrop = {}
		for i = 1,step do
			for n = 2,#drop do
				local id = hApi.RandomItemId(tempDrop,drop[n][1],drop[n][2])
				tDrop[n-1] = id
			end
			local id = tDrop[hApi.random(1,8)]
			local lv = hVar.tab_item[id].itemLv or 1
			if CanReRoll==1 and lv<#tQuality then
				id = tDrop[hApi.random(1,8)]
				lv = math.max(lv,hVar.tab_item[id].itemLv or 1)
			end
			dropCount[lv] = (dropCount[lv] or 0)+1
		end
		local dropString = ""
		for i = 0,4 do
			dropString = dropString.."["..i.."]"..(dropCount[i] or 0)..",  "
		end
		print("["..nDropCount.."/"..nDropNum.."]drop:"..dropString)
		if nDropNum-nDropCount<=0 then
			print("drop test "..nDropNum.." ....")
			for i = 0,#tQuality do
				if dropCount[i] then
					print("["..tQuality[i].."] get:"..dropCount[i])
				end
			end
			return hApi.clearTimer("__TEST__DropCount__")
		end
	end)
end


hApi.GMGetAllTacticsCard = function()
	if g_localfilepath and g_curPlayerName and Save_PlayerData and Save_PlayerLog then
		local tTactics = Save_PlayerData.battlefieldskillbook
		local tIndex = {}
		for i = 1,#tTactics do
			local id,lv = tTactics[i][1],tTactics[i][2]
			tIndex[id] = lv
		end
		for id = 11,999 do
			local v = hVar.tab_tactics[id]
			if v and (v.level or 1)>(tIndex[id] or 0) then
				tTactics[#tTactics+1] = {id,(v.level or 1),1}
			end
		end

		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
	end
end

hApi.GMGetAllHeroCard = function(nLv)
	if g_localfilepath and g_curPlayerName and Save_PlayerData and Save_PlayerLog then
		local nExpGet = 0
		local nHeroLv = 0
		if type(nLv)=="number" and hVar.HERO_EXP[nLv] then
			nExpGet = hVar.HERO_EXP[nLv]
			nHeroLv = nLv
		end
		for id = 5000,5200 do
			local tabU = hVar.tab_unit[id]
			if tabU and tabU.portrait and tabU.talent then
				LuaAddNewHeroCard(id)
				local tCard = LuaGetHeroCardInfoByUnitID(id)
				if type(tCard)=="table" and nExpGet>0 then
					tCard.attr.exp = nExpGet
					tCard.attr.level = nHeroLv
				end
			end
		end
		LuaSaveHeroCard()
	end
end

hGlobal.Editor.PVPHeroSet = function()
	if hGlobal.UI.PVPHeroSetFrm~=nil then
		if hGlobal.UI.PVPHeroSetFrm.data.show==1 then
			hGlobal.UI.PVPHeroSetFrm:active(1)
		else
			hGlobal.UI.PVPHeroSetFrm:show(1)
			hGlobal.UI.PVPHeroSetFrm:active(1)
			hGlobal.UI.PVPHeroSetFrmFunc.Update()
		end
		return
	end
	local _FrmBG
	local _childUI
	local _PHS_BtnXYWH = {80,0,-1,32}
	local _PHS_FilePath = "data/tabs/tab_pvpset.lua"
	local tFunc = {}

	hGlobal.UI.PVPHeroSetFrm = hUI.frame:new({
		x = 820,
		y = 640,
		w = 180,
		h = 600,
		closebtn = 1,
		dragable = 0,
	})
	hGlobal.UI.PVPHeroSetFrmFunc = tFunc
	_FrmBG = hGlobal.UI.PVPHeroSetFrm
	_childUI = _FrmBG.childUI

	_childUI["btnSave"] = hUI.button:new({
		parent = _FrmBG,
		x = _PHS_BtnXYWH[1],
		y = -24,
		h = _PHS_BtnXYWH[4],
		label = "save",
		scaleT = 0.9,
		code = function()
			for i = 1,99 do
				local oBtn = _childUI["btnSet_"..i]
				if oBtn~=nil then
					if oBtn.childUI["choosed"]~=nil and oBtn.childUI["choosed"].handle._n:isVisible() then
						tFunc.SavePVPHero(i)
						break
					end
				else
					break
				end
			end
		end,
	})


	local tForge = {
		{"__Attr_Hint_Lea","+3",3},
		{"__Attr_Hint_Led","+3",6},
		{"__Attr_Hint_Str","+3",9},
		{"__Attr_Hint_Int","+3",12},
		{"__Attr_Hint_Con","+3",15},
		{"__Attr_Hint_AllAttr","+2",32},
		{"__Attr_Toughness","+2",38},
	}
	local _code_GetDefaultForgeByID = function(id)
		local tabI = hVar.tab_item[id]
		if tabI and tabI.itemLv==4 then
			return {3,0,0,0}
		else
			return {2,0,0}
		end
	end
	local _code_SetForgeForHero = function(nIndex)
		local nHeroID = hApi.GetEquipFrmHeroID()
		local tHeroCard = hApi.GetHeroCardById(nHeroID)
		if tHeroCard then
			if type(tHeroCard.item[1])=="table" then
				local id = tHeroCard.item[1][hVar.ITEM_DATA_INDEX.ID]
				local ex = tHeroCard.item[1][hVar.ITEM_DATA_INDEX.SLOT]
				if type(ex)=="table" then
					if nIndex==0 then
						tHeroCard.item[1][hVar.ITEM_DATA_INDEX.SLOT] = _code_GetDefaultForgeByID(id)
					else
						for i = 2,#ex,1 do
							if ex[i]==0 then
								ex[i] = tForge[nIndex][3]
								break
							end
						end
					end
				end
			end
			--LuaSaveHeroCard("Editor")
		end
	end
	_childUI["btnForge_Clear"] = hUI.button:new({
		parent = _FrmBG,
		x = _PHS_BtnXYWH[1],
		y = -340,
		h = _PHS_BtnXYWH[4],
		label = "clear forge",
		scaleT = 0.9,
		code = function()
			_code_SetForgeForHero(0)
		end,
	})
	for i = 1,#tForge do
		local nIndex = i
		_childUI["btnForge_"..i] = hUI.button:new({
			parent = _FrmBG,
			x = _PHS_BtnXYWH[1],
			y = -340-(i*_PHS_BtnXYWH[4]+4),
			h = _PHS_BtnXYWH[4],
			label = hVar.tab_string[tForge[i][1]]..tForge[i][2],
			scaleT = 0.9,
			code = function()
				_code_SetForgeForHero(nIndex)
			end,
		})
	end

	tFunc.ShowChooseIcon = function(nIndex)
		local f = io.open(_PHS_FilePath,"r")
		if f then
			f:close()
			dofile(_PHS_FilePath)
		end
		for i = 1,99 do
			if _childUI["btnSet_"..i]~=nil then
				if _childUI["btnSet_"..i].childUI["choosed"]~=nil then
					_childUI["btnSet_"..i].childUI["choosed"].handle._n:setVisible(false)
				end
			else
				break
			end
		end
		local oBtn = _childUI["btnSet_"..nIndex]
		if oBtn~=nil then
			if oBtn.childUI["choosed"]~=nil then
				oBtn.childUI["choosed"].handle._n:setVisible(true)
			else
				oBtn.childUI["choosed"] = hUI.image:new({
					parent = oBtn.handle._n,
					x = 96,
					w = 32,
					model = "UI:ok",
				})
			end
		end
	end

	tFunc.SavePVPHero = function(nIndex)
		local nHeroID = hApi.GetEquipFrmHeroID()
		local tHeroCard = hApi.GetHeroCardById(nHeroID)
		if tHeroCard then
			local f = io.open(_PHS_FilePath,"r")
			if f then
				f:close()
				dofile(_PHS_FilePath)
			end
			if hVar.tab_pvpset==nil then
				hVar.tab_pvpset = {}
			end
			if hVar.tab_pvpset[nHeroID]==nil then
				hVar.tab_pvpset[nHeroID] = {}
			end
			local tMyHero = hVar.tab_pvpset[nHeroID]
			if nIndex and tMyHero[nIndex] then
				tMyHero[nIndex] = {id=nHeroID,equipment=tHeroCard.equipment}
			else
				tMyHero[#tMyHero+1] = {id=nHeroID,equipment=tHeroCard.equipment}
			end
			local tTemp = {}
			for id = 5000,5100,1 do
				local tabH = hVar.tab_pvpset[id]
				if tabH then
					tTemp[#tTemp+1] = hApi.SaveTable(tabH,{"_tab_pvpset["..id.."]"},{equipment="n"})
				end
			end
			local f = io.open(_PHS_FilePath,"w")
			if f then
				f:write("hVar.tab_pvpset = {}\n")
				f:write("local _tab_pvpset = hVar.tab_pvpset\n")
				for i = 1,#tTemp do
					for j = 1,#tTemp[i] do
						f:write(tTemp[i][j])
					end
					f:write("\n\n")
				end
				f:close()
			end
		end
	end

	tFunc.ShowPVPHero = function(nHeroID,tEquipment)
		local tHeroCard = hApi.GetHeroCardById(nHeroID)
		if tHeroCard and type(tEquipment)=="table" then
			tHeroCard.equipment = tEquipment
			hGlobal.event:event("LocalEvent_showHeroCardFrm",nil,nHeroID,nil,1)
			_FrmBG:active()
		end
	end

	tFunc.Update = function()
		for i = 1,99 do
			hApi.safeRemoveT(_childUI,"btnSet_"..i)
		end
		hApi.safeRemoveT(_childUI,"btnNew")
		_childUI["dragBox"]:sortbutton()
		local f = io.open(_PHS_FilePath,"r")
		if f then
			f:close()
			dofile(_PHS_FilePath)
		end
		if hVar.tab_pvpset==nil then
			hVar.tab_pvpset = {}
		end
		local nHeroID = hApi.GetEquipFrmHeroID()
		local tMyHeroEquip
		for k,v in pairs(hVar.tab_pvpset)do
			if k==nHeroID then
				tMyHeroEquip = v
				break
			end
		end
		local y = -64
		if tMyHeroEquip then
			for i = 1,#tMyHeroEquip do
				y = y - _PHS_BtnXYWH[4] - 4
				local tEquip = tMyHeroEquip[i].equipment
				_childUI["btnSet_"..i] = hUI.button:new({
					parent = _FrmBG,
					x = _PHS_BtnXYWH[1],
					y = y,
					h = _PHS_BtnXYWH[4],
					label = "Set:"..i,
					scaleT = 0.9,
					code = function()
						tFunc.ShowChooseIcon(i)
						tFunc.ShowPVPHero(nHeroID,tEquip)
					end,
				})
			end
		end
		y = y - _PHS_BtnXYWH[4] - 4
		_childUI["btnNew"] = hUI.button:new({
			parent = _FrmBG,
			x = _PHS_BtnXYWH[1],
			y = y,
			h = _PHS_BtnXYWH[4],
			label = "new",
			scaleT = 0.9,
			code = function()
				tFunc.SavePVPHero()
				tFunc.Update()
			end,
		})
	end

	tFunc.Update()
end