hGlobal.UI.InitTankTipFrm = function()
	local tInitEventName = {"localEvent_ShowTankTipFrm", "_show",}
	if (mode ~= "include") then
		--return tInitEventName
	end

	local btnw = 40
	local btnH = 40

	local _boardW,_boardH = 300,520
	local _showW,_showH = 0,0
	local _frm,_childUI,_parent = nil,nil,nil
	local _bg = nil

	local _mode = 0
	local _showattrmode = 1
	local _ShowAttr = {}

	local _DefaultAttrList = {
		"atk",
		"hp_max",
		"move_speed",
		"def_fire",
		"def_poison",
		"grenade_capacity",
		"grenade_cd",
		"grenade_dis",
		"inertia",
		"grenade_crit",
		"grenade_fire",
		"grenade_child",
	}

	local _DefaultAttrType = {
		"all",
		"basic",
		"item",
		"buff",
		"aura",
		"tactic",
	}

	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateBoard = hApi.DoNothing
	local _CODE_SetModeConfig = hApi.DoNothing
	local _CODE_CreateAttrUI = hApi.DoNothing
	local _CODE_RefreshAttr = hApi.DoNothing
	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_GetAttrV = hApi.DoNothing
	local _CODE_ChangeShowAttrModeType = hApi.DoNothing
	local _CODE_AddTimer = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.TankTipFrm then
			hGlobal.UI.TankTipFrm:del()
			hGlobal.UI.TankTipFrm = nil
		end
		_frm,_childUI,_parent = nil,nil,nil
		_bg = nil
		_ShowAttr = {}
		hApi.clearTimer("refreshtanktipfrm")
	end

	_CODE_SetModeConfig = function(tShowAttr)
		if _mode == 0 then
			_ShowAttr = _DefaultAttrList
			_showW = _boardW
			_showH = 140 + 32 * #_ShowAttr
		elseif _mode == 1 then
			_ShowAttr = tShowAttr
			_showW = _boardW
			_showH = 140 + 32 * #_ShowAttr
		end
	end

	_CODE_CreateAttrUI = function()
		hApi.safeRemoveT(_childUI["btn_node"].childUI,"attrnode")

		_childUI["btn_node"].childUI["attrnode"] = hUI.button:new({
			parent = _childUI["btn_node"].handle._n,
			model = "misc/button_null.png",
			--model = "misc/mask.png",
			x = -btnw/2,
			y = -btnH - 10,
			w = 20,
			h = 20,
		})

		local nodeChildUI = _childUI["btn_node"].childUI["attrnode"].childUI
		local nodeParent = _childUI["btn_node"].childUI["attrnode"].handle._n

		for i = 1,#_ShowAttr do
			local key = _ShowAttr[i]
			nodeChildUI["lab_K"..key] = hUI.label:new({
				parent = nodeParent,
				x = 10,
				y = -(i - 1) * 32,
				align = "LC",
				text = hVar.tab_string[hVar.ItemRewardStr[key]],
			})

			nodeChildUI["lab_V"..key] = hUI.label:new({
				parent = nodeParent,
				x = _boardW * 2 /3 ,
				y = -(i - 1) * 32,
				align = "LC",
			})
		end
	end

	_CODE_GetAttrV = function(oUnit,key)
		local value
		if _showattrmode == 1 then
			local t = {}
			hApi.ReadUnitValue(t,key,oUnit,"Attr",key)
			if t[key] then
				value = t[key]
			end
		else
			local attr = oUnit.attr
			local skey = key.. "_".. (_DefaultAttrType[_showattrmode] or "")
			if attr[skey] then
				value = attr[skey]
			end
		end
		return value
	end

	_CODE_RefreshAttr = function(shouldrefresh)
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			if oPlayerMe then
				local oHero = oPlayerMe.heros[1]
				--print(oHero)
				if oHero then
					local oUnit = oHero:getunit()
					--print(oUnit)
					if oUnit then
						if shouldrefresh == 1 then
							oUnit:AttrRecheckBasic()
						end
						local attr = oUnit.attr
						--table_print(attr)
						if _childUI["btn_node"] and _childUI["btn_node"].childUI["attrnode"] then
							local nodeChildUI = _childUI["btn_node"].childUI["attrnode"].childUI
							for i = 1,#_ShowAttr do
								local key = _ShowAttr[i]
								local num = _CODE_GetAttrV(oUnit,key)
								
								if nodeChildUI["lab_V"..key] then
									--print(num)
									nodeChildUI["lab_V"..key]:setText(tostring(num))
								end
							end
						end
					end
				end
			end
		end
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.TankTipFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			dragable = 4,
			show = 0,
			--z = -1,
			buttononly = 1,
			z = 29999,
		})
		_frm = hGlobal.UI.TankTipFrm
		_childUI = _frm.childUI
		_parent = _frm.handle._n

		_CODE_CreateBoard()
		_CODE_CreateAttrUI()

		_frm:show(1)
		_frm:active()
	end

	_CODE_CreateBoard = function()
		local offx = hVar.SCREEN.w - _showW
		local offy = math.max(- 100,- hVar.SCREEN.h + _showH)

		_childUI["btn_board"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			--model = "misc/mask.png",
			dragbox = _childUI["dragBox"],
			x = _showW/2 + offx,
			y = -_showH/2 + offy,
			w = _showW,
			h = _showH,
		})

		_bg = hApi.CCScale9SpriteCreate("data/image/misc/chariotconfig/boardbg.png",0, 0, _showW, _showH, _childUI["btn_board"])


		_childUI["btn_node"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			dragbox = _childUI["dragBox"],
			x = btnw/2 + offx,
			y = -btnH/2 + offy,
			w = btnw,
			h = btnH,
			--z = -2,
			codeOnDrag = function(self,x,y,sus)
				--print("1111",x,y)
				local newX = hApi.NumBetween(btnw/2,hVar.SCREEN.w - _showW + btnw/2,x)
				local newY = hApi.NumBetween(-btnH/2,-hVar.SCREEN.h + _showH - btnH/2,y)
				_childUI["btn_node"]:setXY(newX,newY)
				_childUI["btn_board"]:setXY(newX - btnw/2 +_showW/2,newY-_showH/2 + btnH/2)
				_childUI["btn_close"]:setXY(newX + _showW - 6-btnw,newY-6)
				_childUI["btn_control"]:setXY(newX + btnw + _showW/4 + _showW/6+7-btnw,newY -10)
				_childUI["btn_config"]:setXY(newX - btnw/2 +_showW/2,newY - _showH + 40)
				for i = 1,#_DefaultAttrType do
					_childUI["btn_showattrtype"..i]:setXY(newX - btnw/2 + (i-1) * 40 + 30,newY - _showH + 80)
				end
				_childUI["btn_refreshbtn"]:setXY(newX - btnw/2 + _showW - 30,newY - _showH + 80)
			end,
		})

		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			model = "misc/skillup/btn_close.png",
			dragbox = _childUI["dragBox"],
			x = -btnw/2 + _showW - 6 + offx,
			y = -btnH/2 - 6 + offy,
			w = btnw,
			h = btnH,
			code = function()
				_CODE_ClearFunc()
			end
		})

		_childUI["btn_node"].childUI["bar"] = hUI.valbar:new({
			parent = _childUI["btn_node"].handle._n,
			model = "UI:ValueBar2",
			back = {model = "UI:ValueBar_Back",x=-14,y=6,w=_showW/2 + 10,h=btnH/2,z=-1},
			w = _showW/2,
			h = btnH/2,
			y = -10,
			x = _showW/6 + 7,
			align = "LC",
		})
		_childUI["btn_node"].childUI["bar"]:setV(255,255)

		_childUI["btn_control"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			dragbox = _childUI["dragBox"],
			x = btnw/2 +_showW/4 + _showW/6+7 + offx,
			y = -btnH/2 -10 + offy,
			w = _showW/2,
			h = btnH/2,
			codeOnTouch = function(self,x,y)
				local v = (x-_childUI["btn_control"].data.x + _showW/4)/(_showW/2)
				local newV = hApi.NumBetween(0,1,v)
				--print(x-_childUI["btn_control"].data.x,v,_showW/4)
				_childUI["btn_node"].childUI["bar"]:setV(newV * 255,255)
				_bg:setOpacity(newV * 255)
			end,
			codeOnDrag = function(self,x,y,sus)
				local v = (x-_childUI["btn_control"].data.x + _showW/4)/(_showW/2)
				local newV = hApi.NumBetween(0,1,v)
				--print(x-_childUI["btn_control"].data.x,v,_showW/4)
				_childUI["btn_node"].childUI["bar"]:setV(newV * 255,255)
				_bg:setOpacity(newV * 255)
			end,
			
		})

		_childUI["btn_config"] = hUI.button:new({
			parent = _parent,
			--model = "misc/button_null.png",
			model = "misc/mask.png",
			dragbox = _childUI["dragBox"],
			label = {text = "所有信息",size = 20,font = hVar.FONTC,y = 4,},
			x = _showW/2 + offx,
			y = -btnH/2 - _showH + 40 + offy,
			w = _showW,
			h = 40,
			code = function(self,x,y,sus)
				hGlobal.event:event("Event_StartPauseSwitch", true)
				--print("ssssss")
				hGlobal.event:event("localEvent_ShowTankAllAttrFrm")
			end,
		})

		for i = 1,#_DefaultAttrType do
			local text = _DefaultAttrType[i]
			_childUI["btn_showattrtype"..i] = hUI.button:new({
				parent = _parent,
				model = "misc/addition/cg.png",
				label = {text = text,size = 16,y = 2,},
				dragbox = _childUI["dragBox"],
				x = (i-1) * 40 + 30 + offx,
				y = -btnH/2 - _showH + 80 + offy,
				w = 36,
				h = 28,
				code = function(self,x,y,sus)
					_CODE_ChangeShowAttrModeType(i)
				end,
			})
			hApi.AddShader(_childUI["btn_showattrtype"..i].handle.s, "gray")
		end

		_childUI["btn_refreshbtn"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/select_l.png",
			x = _showW - 30 + offx,
			y = -btnH/2 - _showH + 80 + offy,
			w = 24,
			h = 24,
			code = function(self,x,y,sus)
				_CODE_RefreshAttr(1)
			end,
		})

		_childUI["btn_node"].childUI["label"] = hUI.label:new({
			parent = _childUI["btn_node"].handle._n,
			x = -btnw/2,
			y = btnH/2,
			size = btnw/2,
			width = btnw,
			text = "点击拖动",
		})
	end

	_CODE_ChangeShowAttrModeType = function(showtype)
		--print("_CODE_ChangeShowAttrModeType",_showattrmode,showtype)
		_showattrmode = showtype
		for i = 1,#_DefaultAttrType do
			--print(i,_showattrmode)
			if i == _showattrmode then
				hApi.AddShader(_childUI["btn_showattrtype"..i].handle.s, "normal")
			else
				hApi.AddShader(_childUI["btn_showattrtype"..i].handle.s, "gray")
			end
		end
		_CODE_RefreshAttr()
	end

	_CODE_AddTimer = function()
		if hGlobal.UI.TankTipFrm then
			hApi.clearTimer("refreshtanktipfrm")
			hApi.addTimerForever("refreshtanktipfrm",hVar.TIMER_MODE.GAMETIME,10,function()
				_CODE_RefreshAttr()
			end)
		end
	end

	hGlobal.event:listen("LocalEvent_PlayerFocusWorld", "TankTipFrm",function(sSceneType,oWorld,oMap)
		_CODE_AddTimer()
	end)

	hGlobal.event:listen("LocalEvent_SpinScreen","TankTipFrm",function()
		if _frm and _frm.data.show == 1 then
			local nMode = _mode
			local tShowAttr = _ShowAttr
			_CODE_ClearFunc()
			if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then
				_mode = nMode or 0
				_ShowAttr = tShowAttr
				_CODE_SetModeConfig(tShowAttr)
				_CODE_CreateFrm()
				_CODE_ChangeShowAttrModeType(_showattrmode)
			end
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(nMode,tShowAttr)
		_CODE_ClearFunc()
		if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then
			_mode = nMode or 0
			_CODE_SetModeConfig(tShowAttr)
			_CODE_CreateFrm()
			_CODE_ChangeShowAttrModeType(_showattrmode)
			if nMode == 1 then
				_CODE_AddTimer()
			end
		end
	end)
end

hGlobal.UI.InitTankAllAttrFrm = function()
	local tInitEventName = {"localEvent_ShowTankAllAttrFrm", "_show",}
	if (mode ~= "include") then
		--return tInitEventName
	end

	local _frm,_childUI,_parent = nil,nil,nil
	local _mode = 0
	local _showattrmode = 0
	local _maxChoose = 16
	local _tAttrList = {}
	local _tChooseList = {}

	local _DefaultAttrType = {
		"all",
		"basic",
		"item",
		"buff",
		"aura",
		"tactic",
	}

	local _AllAttrType = {
		"hp",
		"move_speed",
		"def_physic",
		"def_thunder",
		"def_fire",
		"def_poison",
		"grenade_child",
		"grenade_fire",
		"grenade_dis",
		"grenade_cd",
		"grenade_crit",
		"grenade_multiply",
		"inertia",
		"crystal_rate",
		--"melee_bounce",
		--"melee_fight",
		--"melee_stone",
		"pet_hp_restore", --宠物回血
	}

	local _tModeDifine = {
		"所有属性",
		"监控属性",
	}

	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateUI = hApi.DoNothing
	local _CODE_CreateAttr = hApi.DoNothing
	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_RefreshAttr = hApi.DoNothing
	local _CODE_ChangeModeType = hApi.DoNothing
	local _CODE_ChangeShowAttrModeType = hApi.DoNothing
	local _CODE_ChooseAttr = hApi.DoNothing
	local _CODE_AlterAttr = hApi.DoNothing
	local _CODE_RefreshAttrChoose = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.TankAllAttrFrm then
			hGlobal.UI.TankAllAttrFrm:del()
			hGlobal.UI.TankAllAttrFrm = nil
		end
		_frm,_childUI,_parent = nil,nil,nil
		_mode = 0
		_showattrmode = 0
	end

	_CODE_GetAttrV = function(oUnit,key,attrmode)
		local value
		local mode = attrmode or  _showattrmode
		if mode == 1 then
			local t = {}
			hApi.ReadUnitValue(t,key,oUnit,"Attr",key)
			if t[key] then
				value = t[key]
			end
		else
			local attr = oUnit.attr
			local skey = key .. "_"..(_DefaultAttrType[mode] or "")
			--print(mode,skey,_DefaultAttrType[mode])
			if attr[skey] then
				value = attr[skey]
			end
		end
		return value
	end

	_CODE_ChangeModeType = function(modetype)
		print("_CODE_ChangeModeType",_mode,modetype)
		if _mode ~= modetype then
			_mode = modetype
			for i = 1,#_tModeDifine do
				print("i",i)
				if i == _mode then
					hApi.AddShader(_childUI["btn_modetype"..i].handle.s, "normal")
				else
					hApi.AddShader(_childUI["btn_modetype"..i].handle.s, "gray")
				end
			end
			for j = 1,#_DefaultAttrType do
				if _mode == 1 then
					_childUI["btn_showattrtype"..j]:setstate(1)
				else
					_childUI["btn_showattrtype"..j]:setstate(-1)
				end
			end
			for j = 1,#_tAttrList do
				local attr = _tAttrList[j]
				if _mode == 1 then
					_childUI["lab_V"..attr].handle._n:setVisible(true)
					--_childUI["img_choose"..attr].handle._n:setVisible(false)
					_childUI["btn_"..attr]:setstate(-1)
					_childUI["btn_alter"..attr]:setstate(1)
				else
					_childUI["lab_V"..attr].handle._n:setVisible(false)
					--_childUI["img_choose"..attr].handle._n:setVisible(true)
					_childUI["btn_"..attr]:setstate(1)
					_childUI["btn_alter"..attr]:setstate(-1)
				end
			end
			if _mode == 1 then
				_childUI["lab_choosenum"].handle._n:setVisible(false)
				_childUI["btn_chooseok"]:setstate(-1)
			else
				_childUI["lab_choosenum"].handle._n:setVisible(true)
				_childUI["btn_chooseok"]:setstate(1)
			end
		end
	end

	_CODE_ChangeShowAttrModeType = function(showtype)
		print("_CODE_ChangeShowAttrModeType",_showattrmode,showtype)
		if _showattrmode ~= showtype then
			_showattrmode = showtype
			for i = 1,#_DefaultAttrType do
				print(i,_showattrmode)
				if i == _showattrmode then
					hApi.AddShader(_childUI["btn_showattrtype"..i].handle.s, "normal")
				else
					hApi.AddShader(_childUI["btn_showattrtype"..i].handle.s, "gray")
				end
			end
			_CODE_RefreshAttr()
		end
	end

	_CODE_RefreshAttr = function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
		local oHero = oPlayerMe.heros[1]
		--print(oHero)
		if oHero then
			local oUnit = oHero:getunit()
			--print(oUnit)
			if oUnit then
				for j = 1,#_tAttrList do
					local attr = _tAttrList[j]
					local num = _CODE_GetAttrV(oUnit,attr)
					if _childUI["lab_V"..attr] then
						local str = tostring(num)
						if hVar.ItemRewardStrMode[attr] then
							str = str .. "%"
						end
						if (hVar.ItemRewardMillinSecondMode[attr] == 1) then
							str = str / 1000
						end
						_childUI["lab_V"..attr]:setText(str)
					end
				end
			end
		end
	end

	_CODE_ChooseAttr = function(attr)
		if _mode == 1 then
		else
			if _tChooseList[attr] then
				local index = _tChooseList[attr]
				table.remove(_tChooseList,index)
				_tChooseList[attr] = nil
				for i = index,#_tChooseList do
					local a = _tChooseList[i]
					_tChooseList[a] = i
				end
				_CODE_RefreshAttrChoose()
			elseif #_tChooseList < _maxChoose then
				_tChooseList[#_tChooseList+1] = attr
				_tChooseList[attr] = #_tChooseList
				_CODE_RefreshAttrChoose()
			end
		end
	end

	_CODE_AlterAttr = function(attr)
		if _mode == 1 then
			local oWorld = hGlobal.WORLD.LastWorldMap
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			local oHero = oPlayerMe.heros[1]
			--print(oHero)
			if oHero then
				local oUnit = oHero:getunit()
				--print(oUnit)
				if oUnit then
					local totalN = _CODE_GetAttrV(oUnit,attr,1)
					local tacticsN = _CODE_GetAttrV(oUnit,attr,6)
					hGlobal.event:event("localEvent_ShowCheatAlterTankAttrFrm",attr,totalN,tacticsN)
				end
			end
		end
	end

	_CODE_RefreshAttrChoose = function()
		for i = 1,#_tAttrList do
			local attr = _tAttrList[i]
			if _tChooseList[attr] then
				if _childUI["btn_"..attr] and _childUI["btn_"..attr].childUI["choose"] then
					_childUI["btn_"..attr].childUI["choose"].handle._n:setVisible(true)
				end
			else
				if _childUI["btn_"..attr] and _childUI["btn_"..attr].childUI["choose"] then
					_childUI["btn_"..attr].childUI["choose"].handle._n:setVisible(false)
				end
			end
		end
		_childUI["lab_choosenum"]:setText("已选择 "..tostring(#_tChooseList).." / ".._maxChoose)
	end

	_CODE_CreateAttr = function()
		_tAttrList = {}
		local offh = 40
		local index = 0

		local cow = math.floor((hVar.SCREEN.w - 2 * hVar.SCREEN.offx) / 300)
		local line = math.floor((hVar.SCREEN.h - 120)/offh)

		local offw = math.floor((hVar.SCREEN.w - 2 * hVar.SCREEN.offx - 300 * cow)/(cow+1))

		local startX = hVar.SCREEN.offx + offw
		local startY = - 120

		if hVar.SCREEN_MODE ~= hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
			cow = math.floor(hVar.SCREEN.w / 300)
			line = math.floor((hVar.SCREEN.h - 2 * hVar.SCREEN.offx - 120)/offh)
			offw = math.floor((hVar.SCREEN.w - 300 * cow)/(cow+1))
			startX = offw
			startY = - 200 - hVar.SCREEN.offx
		end

		--print(cow,line,offw)

		--for attr,text in pairs(hVar.ItemRewardStr) do
		for i = 1,#_AllAttrType do
			local attr = _AllAttrType[i]
			--_tAttrList[index] = {attr}
			--if hVar.tab_string[hVar.ItemRewardStr[attr]] ~= hVar.ItemRewardStr[attr] then
			if hVar.tab_string[hVar.ItemRewardStr[attr]] and hVar.ItemRewardStr[attr] then
				index = index + 1
				_tAttrList[index] = attr
			

				local j = (index - 1) % cow + 1
				local k = math.floor((index-1)/cow)

				_childUI["btn_"..attr] = hUI.button:new({
					parent = _parent,
					--model = "misc/mask.png",
					model = "misc/button_null.png",
					dragbox = _childUI["dragBox"],
					x = startX + (j - 0.5) * (300 + offw) - 10,
					y = startY - k * offh,
					w = 300,
					h = offh,
					code = function()
						print(attr)
						_CODE_ChooseAttr(attr)
					end,
				})
				_childUI["btn_"..attr]:setstate(-1)

				_childUI["btn_alter"..attr] = hUI.button:new({
					parent = _parent,
					--model = "misc/mask.png",
					model = "misc/button_null.png",
					dragbox = _childUI["dragBox"],
					x = startX + (j - 0.5) * (300 + offw) - 10,
					y = startY - k * offh,
					w = 300,
					h = offh,
					code = function()
						print(attr)
						_CODE_AlterAttr(attr)
					end,
				})
				_childUI["btn_alter"..attr]:setstate(-1)

				_childUI["lab_K"..attr] = hUI.label:new({
					parent = _parent,
					x = startX + (j - 1) * (300 + offw) + 10,
					y = startY - k * offh,
					align = "LC",
					text = hVar.tab_string[hVar.ItemRewardStr[attr]],
				})

				_childUI["lab_V"..attr] = hUI.label:new({
					parent = _parent,
					x = startX + (j - 1) * (300 + offw) + 220,
					y = startY - k * offh,
					align = "LC",
					--text = 10,
				})

				_childUI["btn_"..attr].childUI["choose"] = hUI.image:new({
					parent = _childUI["btn_"..attr].handle._n,
					model = "misc/skillup/tick.png",
					x = (300 + offw)/2 - 50,
					y = 0,
				})
				_childUI["btn_"..attr].childUI["choose"].handle._n:setVisible(false)
			end
		end
	end

	_CODE_CreateUI = function()
		local nMtypeStartX = 20
		local nMtypeStartY = -54
		local nDAtypeStartX = hVar.SCREEN.w - hVar.SCREEN.offx - (#_DefaultAttrType + 0.5) * 80 - 20
		local nDAtypeStartY = -54
		if hVar.SCREEN_MODE ~= hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
			nMtypeStartX = hVar.SCREEN.w - 450 - 30
			nMtypeStartY = -54 +  hVar.SCREEN.offx
			nDAtypeStartY = - 130 + hVar.SCREEN.offx
		end
		for i = 1,#_tModeDifine do
			local text = _tModeDifine[i]
			_childUI["btn_modetype"..i] = hUI.button:new({
				parent = _parent,
				model = "misc/addition/cg.png",
				label = {text = text,size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
				dragbox = _childUI["dragBox"],
				scaleT = 0.95,
				x = 180 * i + nMtypeStartX,
				y = nMtypeStartY,
				scale = 0.74,
				code = function()
					_CODE_ChangeModeType(i)
				end,
			})
			hApi.AddShader(_childUI["btn_modetype"..i].handle.s, "gray")
		end

		for i = 1,#_DefaultAttrType do
			_childUI["btn_showattrtype"..i] = hUI.button:new({
				parent = _parent,
				model = "misc/billboard/kuang5.png",
				label = {text = _DefaultAttrType[i],size = 20,y = 4},
				dragbox = _childUI["dragBox"],
				x = nDAtypeStartX + i * 80,
				y = nDAtypeStartY,
				w = 60,
				h = 40,
				code = function()
					_CODE_ChangeShowAttrModeType(i)
				end
			})
			hApi.AddShader(_childUI["btn_showattrtype"..i].handle.s, "gray")
		end

		_childUI["lab_choosenum"] = hUI.label:new({
			parent = _parent,
			x = hVar.SCREEN.w - hVar.SCREEN.offx - 340,
			y = nDAtypeStartY,
			text = "",
			size = 28,
			align = "MC",
		})

		_childUI["btn_chooseok"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			label = {text = hVar.tab_string["Exit_Ack"],size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
			dragbox = _childUI["dragBox"],
			scaleT = 0.95,
			x = hVar.SCREEN.w - hVar.SCREEN.offx - 120,
			y = nDAtypeStartY,
			scale = 0.74,
			code = function()
				hGlobal.event:event("localEvent_ShowTankTipFrm",1,_tChooseList)
				_CODE_ClearFunc()
				local frm = hGlobal.UI.SystemMenuNewFram
				if frm and frm.data.show == 0 then
					hGlobal.event:event("Event_StartPauseSwitch", false)
				end
			end,
		})

		_CODE_ChangeShowAttrModeType(1)
		_CODE_ChangeModeType(1)
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.TankAllAttrFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = "UI:zhezhao",
			dragable = 4,
			show = 0,
			--z = -1,
			--buttononly = 1,
			z = 30001,
		})
		_frm = hGlobal.UI.TankAllAttrFrm
		_childUI = _frm.childUI
		_parent = _frm.handle._n

		local nCloseX = 54 + hVar.SCREEN.offx
		local nCloseY = -54
		if hVar.SCREEN_MODE ~= hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
			nCloseX = 54
			nCloseY = -54 - hVar.SCREEN.offx
		end

		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/back.png",
			x = nCloseX,
			y = nCloseY,
			code = function()
				_CODE_ClearFunc()
				--hGlobal.event:event("Event_StartPauseSwitch", false)
				local frm = hGlobal.UI.SystemMenuNewFram
				if frm and frm.data.show == 0 then
					hGlobal.event:event("Event_StartPauseSwitch", false)
				end
			end,
		})

		_CODE_CreateAttr()
		_CODE_CreateUI()
		_CODE_RefreshAttr()
		_CODE_RefreshAttrChoose()
		

		_frm:show(1)
		_frm:active()
	end

	hGlobal.event:listen("LocalEvent_CheatAlterAttr","TankAllAttrFrm",function(key,value)
		if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then
			local mode = 6
			local oWorld = hGlobal.WORLD.LastWorldMap
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			local oHero = oPlayerMe.heros[1]
			if oHero then
				local oUnit = oHero:getunit()
				if oUnit then
					local attr = oUnit.attr
					local skey = key .. "_"..(_DefaultAttrType[mode] or "")
					--print(mode,skey,_DefaultAttrType[mode])
					if attr[skey] then
						attr[skey] = value
						_CODE_RefreshAttr()
					end
				end
			end
		end
	end)

	hGlobal.event:listen("LocalEvent_SpinScreen","TankAllAttrFrm",function()
		if _frm and _frm.data.show == 1 then
			_CODE_ClearFunc()
			if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then
				_CODE_CreateFrm()
			end
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_CODE_ClearFunc()
		if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then
			--hGlobal.event:event("Event_StartPauseSwitch", true)
			_CODE_CreateFrm()
		end
	end)
end

hGlobal.UI.InitCheatAlterTankAttrFrm = function()
	local tInitEventName = {"localEvent_ShowCheatAlterTankAttrFrm", "_show",}
	if (mode ~= "include") then
		--return tInitEventName
	end

	local _FrmW = 300
	local _FrmH = 440
	
	local _frm,_childUI,_parent = nil,nil,nil
	local _oEnterNumEditBox = nil
	local _sAttr = ""
	local _nTotalN = 0
	local _nTacticsN = 0
	local _nAlterN = 0

	local _CODE_CloseFrm = hApi.DoNothing
	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateUI = hApi.DoNothing

	local _CODE_EditBoxTextEventHandle = hApi.DoNothing
	local _CODE_GetEditBoxNumText = hApi.DoNothing
	local _CODE_RefreshNum = hApi.DoNothing


	_CODE_CloseFrm = function()
		_CODE_ClearFunc()
	end

	_CODE_ClearFunc = function()
		if hGlobal.UI.CheatAlterTankAttrFrm then
			hGlobal.UI.CheatAlterTankAttrFrm:del()
			hGlobal.UI.CheatAlterTankAttrFrm = nil
		end
		_frm,_childUI,_parent = nil,nil,nil
		_sAttr = ""
		_nTotalN = 0
		_nTacticsN = 0
		_nAlterN = 0
		_oEnterNumEditBox = nil
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.CheatAlterTankAttrFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			dragable = 4,
			show = 0,
			--z = -1,
			--buttononly = 1,
			z = 30002,
		})
		_frm = hGlobal.UI.CheatAlterTankAttrFrm
		_childUI = _frm.childUI
		_parent = _frm.handle._n

		local offx = hVar.SCREEN.w/2
		local offy = -hVar.SCREEN.h/2

		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/button_null.png",
			x = offx,
			y = offy,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			code = function()
				_CODE_CloseFrm()
			end,
		})

		_childUI["btn_board"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/button_null.png",
			x = offx,
			y = offy,
			w = _FrmW,
			h = _FrmH,
		})

		local img9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/itemtip.png", offx, offy, _FrmW + 20, _FrmH + 20, _frm,-1)

		_CODE_CreateUI()
		_CODE_RefreshNum()

		_frm:show(1)
		_frm:active()
	end

	_CODE_CreateUI = function()
		local offx = hVar.SCREEN.w/2
		local offy = -hVar.SCREEN.h/2

		local editw = 120
		local edith = 32
		local editx = offx + editw/2
		local edity = offy - 10
		hApi.CCScale9SpriteCreate("data/image/misc/chest/bottom9s.png", editx, edity, editw + 8, edith + 8, _frm,-1)
		_oEnterNumEditBox = CCEditBox:create(CCSizeMake(editw, edith), CCScale9Sprite:create("data/image/misc/button_null.png"))
		_oEnterNumEditBox:setPosition(ccp(editx, edity))
		--_oEnterNumEditBox:setFontName("Sketch Rockwell.ttf")
		_oEnterNumEditBox:setFontSize(0)
		_oEnterNumEditBox:setFontColor(ccc3(0, 0, 0))
		_oEnterNumEditBox:setPlaceHolder("")--hVar.tab_string["enter_name_7_15"]
		_oEnterNumEditBox:setPlaceholderFontColor(ccc3(255, 255, 255))
		_oEnterNumEditBox:setMaxLength(10)
		_oEnterNumEditBox:registerScriptEditBoxHandler(_CODE_EditBoxTextEventHandle)
		_oEnterNumEditBox:setTouchPriority(0)
		_oEnterNumEditBox:setReturnType(kKeyboardReturnTypeDone)
		_oEnterNumEditBox:setInputMode(kEditBoxInputModeNumeric)
		_parent:addChild(_oEnterNumEditBox)

		_childUI["img_valuebg"] = hUI.image:new({
			parent = _parent,
			model = "misc/mask_white.png",
			x = editx,
			y = edity,
			w = editw,
			h = edith,
			z = -1,
		})
		_childUI["img_valuebg"].handle.s:setColor(ccc3(0,0,0))

		_childUI["lab_title"] = hUI.label:new({
			parent = _parent,
			font = hVar.FONTC,
			size = 28,
			x = offx,
			y = offy + _FrmH/2 - 42,
			text = "修改属性",
			align = "MC",
		})

		_childUI["lab_AttrName"] = hUI.label:new({
			parent = _parent,
			font = hVar.FONTC,
			size = 26,
			x = offx,
			y = offy + _FrmH/2 - 100,
			text = hVar.tab_string[hVar.ItemRewardStr[_sAttr]],
			align = "MC",
			RGB = {255,0,0},
		})

		_childUI["lab_AttrTotal"] = hUI.label:new({
			parent = _parent,
			font = hVar.FONTC,
			size = 26,
			x = offx - _FrmW/2 + 30,
			y = offy + 50,
			text = "当前值:",
			align = "LC",
		})

		_childUI["lab_AttrTotalV"] = hUI.label:new({
			parent = _parent,
			font = hVar.FONTC,
			size = 26,
			x = offx + _FrmW/2 - 30,
			y = offy + 50,
			--text = "0",
			align = "RC",
		})

		_childUI["lab_AttrAlter"] = hUI.label:new({
			parent = _parent,
			font = hVar.FONTC,
			size = 26,
			x = offx - _FrmW/2 + 30,
			y = offy - 10,
			text = "修改值:",
			align = "LC",
		})

		_childUI["lab_AttrAlterV"] = hUI.label:new({
			parent = _parent,
			font = hVar.FONTC,
			size = 26,
			x = offx + _FrmW/2 - 30,
			y = offy - 10,
			--text = "0",
			align = "RC",
			z = 100,
		})

		_childUI["lab_Attrfinal"] = hUI.label:new({
			parent = _parent,
			font = hVar.FONTC,
			size = 26,
			x = offx - _FrmW/2 + 30,
			y = offy - 70,
			text = "最终值:",
			align = "LC",
		})

		_childUI["lab_AttrfinalV"] = hUI.label:new({
			parent = _parent,
			font = hVar.FONTC,
			size = 26,
			x = offx + _FrmW/2 - 30,
			y = offy - 70,
			--text = "0",
			align = "RC",
		})

		_childUI["btn_OK"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/chest/itembtn.png",
			label = {text = hVar.tab_string["Exit_Ack"],size = 24,font = hVar.FONTC},
			x = offx,
			y = offy - _FrmH/2 + 60,
			code = function()
				hGlobal.event:event("LocalEvent_CheatAlterAttr",_sAttr,_nAlterN)
				_CODE_CloseFrm()
			end,
		})
	end

	_CODE_RefreshNum = function()
		local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
		if (g_tTargetPlatform.kTargetWindows == TargetPlatform) then --windows版
			local value = _oEnterNumEditBox:getText()
			_nAlterN = tonumber(value)
			print("_nAlterN",_nAlterN,value)
		end
		if type(_nAlterN) ~= "number" then
			_nAlterN = 0
		end
		if _nAlterN == 0 then
			_childUI["lab_AttrTotalV"]:setText(tostring(_nTotalN - _nTacticsN).."+"..tostring(_nTacticsN))
		else
			if _nAlterN > 0 then
				_childUI["lab_AttrTotalV"]:setText(tostring(_nTotalN - _nTacticsN).."+"..tostring(_nAlterN))
			else
				_childUI["lab_AttrTotalV"]:setText(tostring(_nTotalN - _nTacticsN)..tostring(_nAlterN))
			end
		end
		_childUI["lab_AttrAlterV"]:setText(tostring(_nAlterN))
		_childUI["lab_AttrfinalV"]:setText(tostring(_nTotalN - _nTacticsN + _nAlterN))
	end

	_CODE_EditBoxTextEventHandle = function()
		if (strEventName == "began") then
			--
		elseif (strEventName == "changed") then --改变事件
			--
		elseif (strEventName == "ended") then
			local value = _oEnterNumEditBox:getText()
			_nAlterN = tonumber(value)
		elseif (strEventName == "return") then
			--
		end
		_CODE_RefreshNum()
		--print("_CODE_EditBoxTextEventHandle", strEventName, _sComment)
		--xlLG("editbox", tostring(strEventName) .. ", _sComment=" .. tostring(_sComment) .. "\n")
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(sAttr,nTotalN,nTacticsN)
		_CODE_ClearFunc()
		if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then
			--hGlobal.event:event("Event_StartPauseSwitch", true)
			_sAttr = sAttr
			_nTotalN = nTotalN or 0
			_nTacticsN = nTacticsN or 0
			_CODE_CreateFrm()
		end
	end)
end