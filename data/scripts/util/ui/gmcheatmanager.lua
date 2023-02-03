hGlobal.UI.InitCheatManagerFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowCheatManagerFrm", "_show",}
	if (mode ~= "include") then
		--return tInitEventName
	end

	local _tMap = {
		{
			text = "主基地",
			maplist = {
				hVar.MainBase,
			},
		},
		{
			text = "引导关",
			maplist = {
				"world/csys_000",
			},
		},
		{
			text = "机械蜘蛛",
			maplist = {
				"world/yxys_spider_01",
				"world/yxys_spider_02",
				"world/yxys_spider_03",
				"world/yxys_spider_04",
			},
		},
		{
			text = "大飞机",
			maplist = {
				"world/yxys_airship_01",
				"world/yxys_airship_02",
				"world/yxys_airship_03",
				"world/yxys_airship_04",
			},
		},
		{
			text = "虫族",
			maplist = {
				"world/yxys_zerg_001",
				"world/yxys_zerg_002",
				"world/yxys_zerg_003",
				"world/yxys_zerg_004",
			},
		},
		{
			text = "眼球",
			maplist = {
				"world/yxys_bio_001",
				"world/yxys_bio_002",
				"world/yxys_bio_003",
				"world/yxys_bio_004",
			},
		},
		{
			text = "空中堡垒",
			maplist = {
				"world/yxys_mechanics_001",
				"world/yxys_mechanics_002",
				"world/yxys_mechanics_003",
				"world/yxys_mechanics_004",
			},
		},
		{
			text = "大飞碟",
			maplist = {
				"world/yxys_plate_01",
				"world/yxys_plate_02",
				"world/yxys_plate_03",
				"world/yxys_plate_04",
			},
		},
		{
			text = "测试图",
			maplist = {
				--"world/yxys_ex_001",
				"world/yxys_yoda_01",
				"world/yxys_ex_002",
				"world/yxys_ex_003",
				"world/csys_random_test",
			},
		}
	}

	local _tMapList = {
		"world/dlc_yxys_spider",
		"world/dlc_yxys_airship",
		"world/dlc_yxys_zerg",
		"world/dlc_bio_airship",
		"world/dlc_yxys_mechanics",
		"world/dlc_yxys_plate",
	}

	local _tCheatBtnForever = {
		{1001,"三倍血量","buff",15995,15996},
		{1002,"千倍血量","buff",15997,15998},
		{1003,"命无限","adddata",2},
		{1004,"移速+150","buff",15993,15994},
		{1005,"移速+300","buff",15999,16000},
		{1006,"武器满级","adddata",1,hVar.ROLE_NORMALATK_MAXLV},--函数序号1 
		{1007,"投弹强化","buff",803,804},
	}
	local _tAutoCheatIndex = {
		[1] = 1,
		[4] = 1,
		[6] = 1,
		[7] = 1,
	}

	local _tCheatAddAura = {
		1000,1001,1002,1003,1005,1006,1007,1009
	}

	local _tCheatBtnOnce = {
		--{2001,"武器等级+1","adddata",1},
		{2004,"通关全地图","adddata",5},
		{2002,"积分+10000","adddata",3,10000},
		{2003,"碎片+4000","adddata",4,4000},
	}

	local _tCheatBtnFunc = {
		{3001,"监控属性","func",1},
		{3002,"旧版选图","func",2},
		{3003,"管理宠物","func",3},
		{3004,"管理战术卡","func",4},
		{3005,"获取装备","func",5},
		{3006,"全新游戏","func",6}
	}

	local _frm,_parent,_childUI = nil,nil,nil
	local _tChooseMapInfo = {}
	local _tMapUI = {}
	local _nChooseMapIndex = 0
	local _nCurMapPage = 0
	local _tCheatBtnState = {}
	local _lastfloattime = 0
	local _floatH = 0

	local _nMapCow =0
	local _nMapLine = 0
	local _nMapW = 200
	local _nMapH = 80
	local _nCheatNodeStartY = 0
	local _nCloseCount = 0

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_ClearMapUI = hApi.DoNothing
	local _CODE_InitMapChooseConfig = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateMapChoose  = hApi.DoNothing
	local _CODE_ChangeMapPage = hApi.DoNothing
	local _CODE_ClickMapChild = hApi.DoNothing
	local _CODE_ClickMap = hApi.DoNothing
	local _CODE_RefreshMapChildUI = hApi.DoNothing
	local _CODE_RefreshMapUI = hApi.DoNothing

	local _CODE_CreateSetHotKeyFrm = hApi.DoNothing
	local _CODE_CreateCheatUI = hApi.DoNothing
	local _CODE_CreateCheatBtn = hApi.DoNothing
	local _CODE_ClickCheatButton = hApi.DoNothing
	local _CODE_DoCheatButton = hApi.DoNothing
	local _CODE_AddBuff = hApi.DoNothing
	local _CODE_RemoveBuff = hApi.DoNothing
	local _CODE_WeaponMax = hApi.DoNothing
	local _CODE_LifeEx = hApi.DoNothing
	local _CODE_AddScore = hApi.DoNothing
	local _CODE_AddCapsule = hApi.DoNothing
	local _CODE_UnLockAllMap = hApi.DoNothing
	local _CODE_ShowTankTip = hApi.DoNothing
	local _CODE_ShowOldSelectMap = hApi.DoNothing
	local _CODE_RefreshForeverCheat = hApi.DoNothing
	local _CODE_EnterNewMap = hApi.DoNothing
	local _CODE_ShowTacticsManager = hApi.DoNothing
	local _CODE_ShowPetManager = hApi.DoNothing
	local _CODE_ShowGetEquip = hApi.DoNothing
	local _CODE_CreateNewAccount = hApi.DoNothing
	local _CODE_FloatNumber = hApi.DoNothing
	local _CODE_AutoAttack = hApi.DoNothing
	local _CODE_SingleAttack = hApi.DoNothing
	local _CODE_TankSkill = hApi.DoNothing
	local _CODE_TacticsSkill = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.CheatManagerFrm then
			hGlobal.UI.CheatManagerFrm:del()
			hGlobal.UI.CheatManagerFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_tChooseMapInfo = {}
		_tMapUI = {}
		_nChooseMapIndex = 0
		_nCurMapPage = 0

		_nMapCow =0
		_nMapLine = 0
		_nCloseCount = 0

		_lastfloattime = 0
		_floatH = 0
	end

	_CODE_ClickMap = function(mapIndex)
		if _nChooseMapIndex == mapIndex then
			_nChooseMapIndex = 0 
		else
			_nChooseMapIndex = mapIndex 
		end
		_CODE_RefreshMapUI()
	end

	_CODE_ClickMapChild = function(mapIndex,childIndex)
		if _tChooseMapInfo[mapIndex].Choosechild == childIndex then
			_tChooseMapInfo[mapIndex].Choosechild = nil
		else
			_tChooseMapInfo[mapIndex].Choosechild = childIndex
		end
		_CODE_RefreshMapChildUI()
	end

	_CODE_RefreshMapUI = function()
		for i = 1,#_tChooseMapInfo do
			if _childUI["btn_map"..i] then
				local nodeChild = _childUI["btn_map"..i].childUI
				if nodeChild["choose"] then
					if _nChooseMapIndex == i then
						nodeChild["choose"].handle._n:setVisible(true)
					else
						nodeChild["choose"].handle._n:setVisible(false)
					end
				end
			end
		end
		if _nChooseMapIndex ~= 0 then
			hApi.AddShader(_childUI["btn_choosemap"].handle.s, "normal")
		else
			hApi.AddShader(_childUI["btn_choosemap"].handle.s, "gray")
		end
	end

	_CODE_RefreshMapChildUI = function()
		for i = 1,#_tChooseMapInfo do
			if #_tChooseMapInfo[i].maplist > 1 then
				for z = 1,#_tChooseMapInfo[i].maplist do
					if _childUI["btn_map"..i.."child"..z] then
						if z == _tChooseMapInfo[i].Choosechild then
							hApi.AddShader(_childUI["btn_map"..i.."child"..z].handle.s, "normal")
						else
							hApi.AddShader(_childUI["btn_map"..i.."child"..z].handle.s, "gray")
						end
					end
				end
			end
			if _childUI["btn_map"..i] then
				local nodeChild = _childUI["btn_map"..i].childUI
				if nodeChild["info"] then
					local text = ""
					if #_tChooseMapInfo[i].maplist > 1 then
						--print(_tChooseMapInfo[i].Choosechild)
						if _tChooseMapInfo[i].Choosechild == nil then
							text = "随机"
						else
							--table_print(_tChooseMapInfo[i].maplist)
							text = _tChooseMapInfo[i].maplist[_tChooseMapInfo[i].Choosechild]
						end
					else
						text = _tChooseMapInfo[i].maplist[1]
					end
					--print(text)
					nodeChild["info"]:setText(text)
				end
			end
		end

	end

	_CODE_InitMapChooseConfig = function()
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
			_nMapCow = 3
			_nMapLine = 3
		elseif hVar.SCREEN.w < 1280 then
			_nMapCow = 4
			_nMapLine = 2
		else
			_nMapCow = 5
			_nMapLine = 2
		end
		for index = 1,#_tMap do
			local tInfo = _tMap[index]
			local maplist = tInfo.maplist or {}
			_tChooseMapInfo[index] = {maplist = maplist}
		end
	end

	_CODE_ClearMapUI = function()
		for i = 1,#_tMapUI do
			hApi.safeRemoveT(_childUI,_tMapUI[i])
		end
		_tMapUI = {}
	end

	_CODE_ChangeMapPage = function(page)
		--print(page,_nCurMapPage)
		local maxpage = math.ceil(#_tMap/(_nMapCow*_nMapLine))
		if page >= 1 and page <= maxpage and page ~= _nCurMapPage then
			_CODE_ClearMapUI()
			_CODE_CreateMapChoose(page)
		end

		if _nCurMapPage == 1 then
			_childUI["btn_pagepro"]:setstate(-1)
		else
			_childUI["btn_pagepro"]:setstate(1)
		end

		print(_nCurMapPage,maxpage)
		
		--print("_CODE_ChangeMapPage",maxpage,_nCurMapPage)
		if _nCurMapPage == maxpage then
			_childUI["btn_pagenext"]:setstate(-1)
		else
			_childUI["btn_pagenext"]:setstate(1)
		end
	end

	_CODE_CreateMapChoose = function(page)
		_nCurMapPage = page
		local cow = _nMapCow
		local line = _nMapLine
		local mapw = _nMapW
		local maph = _nMapH
		local offw = math.floor((hVar.SCREEN.w - hVar.SCREEN.offx * 2 - cow * mapw)/(cow + 1))
		local offh = 100
		local startX = hVar.SCREEN.offx
		local startY = - 140 
		for i = 1,cow * line do
			local index = (page - 1) * (cow*line) + i
			local tInfo = _tMap[index]
			if tInfo then
				local text = tInfo.text
				local maplist = tInfo.maplist or {}
				local j = (i - 1) % cow + 1
				local k = math.floor((i - 1) / cow) + 1
				_childUI["btn_map"..index] = hUI.button:new({
					parent = _parent,
					dragbox = _childUI["dragBox"],
					model = "misc/button_null.png",
					--model = "misc/mask.png",
					x = startX + (mapw + offw) * (j - 0.5) + offw/2,
					y = startY - (k - 1) * (maph + offh),
					w = mapw,
					h = maph,
					code = function()
						_CODE_ClickMap(index)
					end,
				})
				local img = hApi.CCScale9SpriteCreate("data/image/misc/billboard/kuang5.png", 0, 0, mapw,maph, _childUI["btn_map"..index])
				_tMapUI[#_tMapUI+1] = "btn_map"..index

				if #maplist > 1 then
					for z = 1,#maplist do
						_childUI["btn_map"..index.."child"..z] = hUI.button:new({
							parent = _parent,
							dragbox = _childUI["dragBox"],
							model = "misc/billboard/kuang5.png",
							label = {text = z,align = "MC",size = 20,y = 4,},
							x = startX + (mapw + offw) * (j - 1) + offw/2 + z * 50,
							y = startY - (k - 0.5) * (maph + offh) + 10,
							w = 40,
							h = 40,
							code = function()
								_CODE_ClickMapChild(index,z)
							end,
						})
						_tMapUI[#_tMapUI+1] = "btn_map"..index.."child"..z
					end
				end

				local nodeChild = _childUI["btn_map"..index].childUI
				local nodeParent = _childUI["btn_map"..index].handle._n

				nodeChild["title"] = hUI.label:new({
					parent = nodeParent,
					text = text,
					align = "MC",
					size = 24,
					y = maph/2  - 24,
				})

				nodeChild["info"] = hUI.label:new({
					parent = nodeParent,
					align = "MC",
					size = 20,
					y = -maph/2 + 24,
				})

				nodeChild["choose"] = hUI.image:new({
					parent = nodeParent,
					model = "misc/skillup/tick.png",
					x = mapw/2,
				})
			end
		end
		_nCheatNodeStartY = startY - (line - 0.5) * (maph + offh) + 10 - 50

		_CODE_RefreshMapUI()
		_CODE_RefreshMapChildUI()
	end

	_CODE_CreateCheatBtn = function(btnname,tBtn,startx)
		local btnTotalH = hVar.SCREEN.h + _nCheatNodeStartY - 20
		local btnH = 70
		local btnW = 180
		local btnLine = math.floor(btnTotalH/btnH)
		local btnCow = math.ceil(#tBtn/btnLine)
		--print(btnTotalH,btnLine,btnCow)
		
		for i = 1,#tBtn do
			local keyIdx = tBtn[i][1]
			local text = tBtn[i][2]
			local keytype = tBtn[i][3]
			local param1 = tBtn[i][4]
			local param2 = tBtn[i][5]
			local k = math.ceil(i/btnLine)
			local j = (i -1)%btnLine + 1

			local RGB = nil
			if btnname == "btn_cheatfunc" and i == 5 then
				RGB = {255,255,0}
			end
			
			_childUI[btnname..i] = hUI.button:new({
				parent = _parent,
				model = "misc/addition/cg.png",
				dragbox = _childUI["dragBox"],
				label = {text = text,size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,RGB = RGB},
				x = startx + btnW * (k-0.5),
				y = _nCheatNodeStartY - 50 - btnH * (j-1),
				scale = 0.7,
				scaleT = 0.95,
				code = function()
					if btnname == "btn_cheatforever" then
						_CODE_ClickCheatButton(i,keytype,param1,param2)
					elseif btnname == "btn_cheatonce" then
						--print("btn_cheatonce")
						_CODE_DoCheatButton(1,i,keytype,param1,param2)
					elseif btnname == "btn_cheatfunc" then
						--print("btn_cheatfunc")
						_CODE_DoCheatButton(1,i,keytype,param1,param2)
					end
				end,
			})
			_childUI[btnname..i].data.keyIdx = keyIdx
			if btnname == "btn_cheatforever" then
				if _tCheatBtnState[i] ~= 1 then
					hApi.AddShader(_childUI[btnname..i].handle.s, "gray")
				end
			end
		end
		return btnW * btnCow
	end

	_CODE_CreateCheatUI = function()
		_childUI["line1"] = hUI.image:new({
			parent = _parent,
			model = "ui/title_line.png",
			x = hVar.SCREEN.w/2,
			y = _nCheatNodeStartY,
			w = hVar.SCREEN.w,
			h = 6,
		})

		local startx = hVar.SCREEN.offx + 30
		_childUI["lab_titleconfig1"] = hUI.label:new({
			parent = _parent,
			text = "永久效果",
			x = startx,
			y = _nCheatNodeStartY - 20,
			align = "MT",
			size = 26,
			width = 30,
		})

		local offw = _CODE_CreateCheatBtn("btn_cheatforever",_tCheatBtnForever,startx + 30)

		startx = startx + offw + 60
		_childUI["lab_titleconfig2"] = hUI.label:new({
			parent = _parent,
			text = "一次性效果",
			x = startx,
			y = _nCheatNodeStartY - 20,
			align = "MT",
			size = 26,
			width = 30,
		})

		local offw = _CODE_CreateCheatBtn("btn_cheatonce",_tCheatBtnOnce,startx + 30)

		startx = startx + offw + 60
		_childUI["lab_titleconfig3"] = hUI.label:new({
			parent = _parent,
			text = "功能性",
			x = startx,
			y = _nCheatNodeStartY - 20,
			align = "MT",
			size = 26,
			width = 30,
		})
		local offw = _CODE_CreateCheatBtn("btn_cheatfunc",_tCheatBtnFunc,startx + 30)
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.CheatManagerFrm  = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = "UI:zhezhao",
			dragable = 0,
			show = 0,
			z = 20000,
		})
		_frm = hGlobal.UI.CheatManagerFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI
		_frm.handle.s:setOpacity(220)

		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/back.png",
			x = 54 + hVar.SCREEN.offx,
			y = -54,
			code = function()
				_CODE_ClearFunc()
			end,
		})

		if g_lua_src == 1 then
			_childUI["btn_hotkey"] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				label = {text = "快捷键",size = 28,y= 2,},
				model = "misc/button_null.png",
				x = 240 + hVar.SCREEN.offx,
				y = -54,
				w = 160,
				h = 50,
				scaleT = 0.9,
				code = function()
					_CODE_CreateSetHotKeyFrm()
					--_CODE_ClearFunc()
				end,
			})
		end

		_childUI["btn_choosemap"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			label = {text = "START",size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
			dragbox = _childUI["dragBox"],
			scaleT = 0.95,
			x = hVar.SCREEN.w - hVar.SCREEN.offx - 140,
			y = -54,
			scale = 0.74,
			code = function()
				_CODE_EnterNewMap()
			end,
		})

		_childUI["lab_titlemap"] = hUI.label:new({
			parent = _parent,
			text = "选择关卡",
			x = hVar.SCREEN.w/2,
			y = -52,
			align = "MC",
			size = 32,
		})

		_childUI["btn_pagepro"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/change_arrow.png",
			dragbox = _childUI["dragBox"],
			x = hVar.SCREEN.w/2 - 120,
			y = -54,
			scale = 0.3,
			scaleT = 0.9,
			code = function()
				_CODE_ChangeMapPage(_nCurMapPage-1)
			end,
		})

		_childUI["btn_pagenext"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/change_arrow.png",
			dragbox = _childUI["dragBox"],
			x = hVar.SCREEN.w/2 + 120,
			y = -54,
			scale = 0.3,
			scaleT = 0.9,
			code = function()
				_CODE_ChangeMapPage(_nCurMapPage+1)
			end,
		})
		_childUI["btn_pagenext"].handle.s:setRotation(180)

		_CODE_InitMapChooseConfig()
		_CODE_ChangeMapPage(1)
		_CODE_CreateCheatUI()

		_frm:show(1)
		_frm:active()
	end

	_CODE_ClickCheatButton = function(index,keytype,param1,param2)
		if _tCheatBtnState[index] then
			_tCheatBtnState[index] = nil
			if _childUI and _childUI["btn_cheatforever"..index] then
				hApi.AddShader(_childUI["btn_cheatforever"..index].handle.s, "gray")
			else
				local floatname = _tCheatBtnForever[index][2]
				_CODE_FloatNumber(floatname.."关闭")
			end
		else
			_tCheatBtnState[index] = 1
			if _childUI and _childUI["btn_cheatforever"..index] then
				hApi.AddShader(_childUI["btn_cheatforever"..index].handle.s, "normal")
			else
				local floatname = _tCheatBtnForever[index][2]
				_CODE_FloatNumber(floatname.."开启")
			end
		end
		_CODE_DoCheatButton(_tCheatBtnState[index],index,keytype,param1,param2)
	end

	_CODE_DoCheatButton = function(state,index,keytype,param1,param2)
		print(state,index,keytype,param1,param2)
		if state then
			if keytype == "buff" then
				_CODE_AddBuff(param1)
			elseif keytype == "adddata" then
				if param1 == 1 then
					_CODE_WeaponMax(param2)
				elseif param1 == 2 then
					_CODE_LifeEx()
				elseif param1 == 3 then
					_CODE_AddScore(param2)
				elseif param1 == 4 then
					_CODE_AddCapsule(param2)
				elseif param1 == 5 then
					_CODE_UnLockAllMap()
				end
			elseif keytype == "func" then
				if param1 == 1 then
					_CODE_ShowTankTip()
				elseif param1 == 2 then
					_CODE_ShowOldSelectMap()
				elseif param1 == 3 then
					_CODE_ShowPetManager()
				elseif param1 == 4 then
					_CODE_ShowTacticsManager()
				elseif param1 == 5 then
					_CODE_ShowGetEquip()
				elseif param1 == 6 then
					_CODE_CreateNewAccount()
				end
			end
		else
			if keytype == "buff" then
				_CODE_RemoveBuff(param2)
			end
		end
	end

	_CODE_AddBuff = function(skill_id)
		local world = hGlobal.WORLD.LastWorldMap
		local me = world:GetPlayerMe()
		local heros = me.heros
		local oHero = heros[1]
		local oUnit = oHero:getunit()
		if oUnit then
			if (oUnit.data.IsDead ~= 1) then --活着的单位
				local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
				local gridX, gridY = world:xy2grid(targetX, targetY)
				local tCastParam =
				{
					level = 1, --等级
				}
				hApi.CastSkill(oUnit, skill_id, 0, 100, oUnit, gridX, gridY, tCastParam) --战车加血技能
			end
		end
	end
	
	_CODE_RemoveBuff = function(skill_id)
		local world = hGlobal.WORLD.LastWorldMap
		if world then
			local me = world:GetPlayerMe()
			if me then
				local heros = me.heros
				if heros then
					local oHero = heros[1]
					if oHero then
						local oUnit = oHero:getunit()
						if oUnit then
							if (oUnit.data.IsDead ~= 1) then --活着的单位
								local oBuff = oUnit:getBuffById(skill_id)
								if oBuff then --目标身上已有此buff
									--删除buff
									oBuff:del_buff()
								end
							end
						end
					end
				end
			end
		end
	end

	 _CODE_WeaponMax = function(lv)
	 	print("_CODE_WeaponMax",lv)
	 	local w = hGlobal.WORLD.LastWorldMap
		local me = w:GetPlayerMe()
		local heros = me.heros
		local oHero = heros[1]
		local u = oHero:getunit()
		local bindType = "bind_weapon"
		if u and (u ~= 0) then
			--绑定的单位
			bu = u.data[bindType]
			if bu and (bu ~= 0) then
				local oUnit = bu
				--print("aaaaaaaaaaaaaaaaaaa",oUnit.attr.attack[6])
				local newlv = math.min((lv or oUnit.attr.attack[6] + 1),hVar.ROLE_NORMALATK_MAXLV)
				oUnit.attr.attack[6] = newlv --普通攻击的等级
				
				--一并刷新界面的等级
				if (bindType == "bind_weapon") then
					local tacticCardCtrls = w.data.tacticCardCtrls --战术技能卡控件集
					local btn1 = tacticCardCtrls[hVar.NORMALATK_IDX]
					if btn1 then
						if (type(btn1) == "table") then
							btn1.childUI["labSkillLv"]:setText(newlv)
							if newlv > 1 then
								btn1.childUI["labSkillLv"].handle._n:setVisible(true)
								btn1.childUI["labSkillMana"].handle._n:setVisible(true)
							else
								btn1.childUI["labSkillLv"].handle._n:setVisible(false)
								btn1.childUI["labSkillMana"].handle._n:setVisible(false)
							end
						end
					end
				end
			end
		end
	end

	_CODE_LifeEx = function()
		print("_CODE_LifeEx")
		local diablodata = hGlobal.LocalPlayer.data.diablodata --大菠萝数据
		
		diablodata.lifecount = hVar.DEFAULT_LIFT_NUM
		diablodata.deathcount = 0
		diablodata.canbuylife = hVar.CAN_BUY_LIFE_NUM

		if type(diablodata.randMap) == "table" then
			--记录随机地图数据
			local tInfos = {
				{"lifecount",diablodata.lifecount},
				{"canbuylife",diablodata.canbuylife},
				{"deathcount",diablodata.deathcount},
			}
			LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)
		end
	end

	_CODE_AddScore = function(score)
		--LuaAddPlayerScoreByWay(score,hVar.GET_SCORE_WAY.GMCHEAT)
		--hGlobal.event:event("LocalEvent_RefreshCurGameScore")
		local world = hGlobal.WORLD.LastWorldMap
		local me = world:GetPlayerMe()
		me:addresource(hVar.RESOURCE_TYPE.GOLD, score)
		hGlobal.event:event("Event_TacticCastCostRefresh")
	end

	_CODE_AddCapsule = function(capsule)
		--[[
		LuaAddTankWeaponGunChestNum(capsule)
		LuaAddTankTacticChestNum(capsule)
		LuaAddTankPetChestNum(capsule)
		LuaAddTankEquipChestNum(capsule)
		--上传存档
		local keyList = {"material",}
		LuaSavePlayerData_Android_Upload(keyList, "作弊加宝箱碎片")
		hGlobal.event:event("LocalEvent_RefreshChestNum")
		]]
		
		--挡操作
		hUI.NetDisable(30000)
		
		--发送请求加碎片
		SendCmdFunc["gm_add_debris"](capsule)
	end

	_CODE_UnLockAllMap = function()
		for i = 1,#_tMapList do
			local mapliststr = _tMapList[i]
			local mapInfo = hVar.MAP_INFO[mapliststr]
			if type(mapInfo) == "table" and type(mapInfo.childMap) == "table" then
				local maps = mapInfo.childMap
				for j = 1,#maps do
					local mapname = maps[j]
					--print("mapname",mapname)
					LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.LEVEL,1)
					LuaSetPlayerMapAchi(mapname, hVar.ACHIEVEMENT_TYPE.MAPSTAR, 1, true)
					LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.RICHMAN,1,true)
					LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.BLITZ,1,true)
					LuaSetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.IMPERIAL,1,true)
				end
			end
		end
		LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		
		local keyList = {"map"}
		LuaSavePlayerData_Android_Upload(keyList, "通关全地图")

		_CODE_FloatNumber("通关全地图完成")
	end

	_CODE_ShowTankTip = function()
		hGlobal.event:event("localEvent_ShowTankAllAttrFrm")
		_CODE_ClearFunc()
	end

	_CODE_ShowOldSelectMap = function()
		hGlobal.event:event("CloseSystemMenuIntegrateFrm")
		hGlobal.event:event("LocalEvent_ShowSelectMapFrm")
		_CODE_ClearFunc()
	end

	_CODE_ShowPetManager = function()
		hGlobal.event:event("LocalEvent_ShowPetCheatManagerFrm")
	end

	_CODE_ShowGetEquip = function()
		--hGlobal.event:event("LocalEvent_ShowChariotConfigFrm")
		hGlobal.event:event("LocalEvent_ShowCheatEquipFrm")
	end

	_CODE_ShowTacticsManager = function()
		hGlobal.event:event("LocalEvent_ShowTacticsCheatManagerFrm")
	end

	_CODE_CreateNewAccount = function()
		hGlobal.event:event("LocalEvent_ShowNewGameDataFrm")
	end

	_CODE_RefreshForeverCheat = function()
		for i = 1,#_tCheatBtnForever do
			local keytype = _tCheatBtnForever[i][2]
			local param1 = _tCheatBtnForever[i][3]
			local param2 = _tCheatBtnForever[i][4]
			--print(i,keytype,param1,param2)
			_CODE_DoCheatButton(_tCheatBtnState[i],i,keytype,param1,param2)
		end
	end
	
	_CODE_EnterNewMap = function()
		local mapName
		local tInfo = _tChooseMapInfo[_nChooseMapIndex]
		if tInfo and tInfo.maplist then
			local mapnum = #tInfo.maplist
			if mapnum > 1 then
				if tInfo.Choosechild == nil then
					mapName = tInfo.maplist[math.random(1,mapnum)]
				else
					mapName = tInfo.maplist[tInfo.Choosechild]
				end
			else
				mapName = tInfo.maplist[1]
			end
		end
		if mapName and hVar.MAP_INFO[mapName] then
			_CODE_ClearFunc()
			hGlobal.event:event("CloseSystemMenuIntegrateFrm")
			--清除随机地图的进度
			LuaClearPlayerRandMapInfo(g_curPlayerName)
			--直接通关新手关
			if LuaGetPlayerMapAchi(hVar.GuideMap,hVar.ACHIEVEMENT_TYPE.LEVEL) ~= 1 then
				LuaSetPlayerMapAchi(hVar.GuideMap,hVar.ACHIEVEMENT_TYPE.LEVEL,1)
				local keyList = {"map"}
				LuaSavePlayerData_Android_Upload(keyList, "作弊通关顺带通新手关")
			end
			local __MAPDIFF = 0
			local __MAPMODE = hVar.MAP_TD_TYPE.NORMAL
			hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
			xlScene_LoadMap(g_world, mapName,__MAPDIFF,__MAPMODE)
		end
	end

	_CODE_CreateSetHotKeyFrm = function()
		hGlobal.event:event("LocalEvent_ShowSetHotKeyFrm",_nCheatNodeStartY)
	end

	_CODE_FloatNumber = function(str)
		local curTime = os.clock()
		print("curTime",curTime)
		if curTime - _lastfloattime > 0.5 then
			_floatH = 0
		else
			_floatH = _floatH - 50
			if _floatH < - 300 then
				_floatH = 0
			end
		end
		_lastfloattime = curTime
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2 + 20 + _floatH,
			align = "MC",
			text = "",
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		}):addtext(str, hVar.FONTC, 32, "MC", 0, 0,nil,1)
	end

	_CODE_AutoAttack = function()
		print("_CODE_AutoAttack")
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			local tacticCardCtrls = oWorld.data.tacticCardCtrls --战术技能卡控件集
			local btn1 = tacticCardCtrls[hVar.NORMALATK_IDX]
			if btn1 then
				print("oWorld.data.weapon_attack_state",oWorld.data.weapon_attack_state)
				if oWorld.data.weapon_attack_state == 0 then
					--_autoatk = 1
					hGlobal.event:event("Event_OpenAutoAttack")
				else	
					--_autoatk = 0
					--oWorld.data.weapon_attack_state = 0
					hGlobal.event:event("Event_CheckAutoAttack",{0,0})
					--hGlobal.event:event("Event_CloseAutoAttack")
				end
			end
		end
	end

	_CODE_SingleAttack = function()
		print("_CODE_SingleAttack")
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			local tacticCardCtrls = oWorld.data.tacticCardCtrls --战术技能卡控件集
			local btn1 = tacticCardCtrls[hVar.NORMALATK_IDX]
			if btn1 then
				btn1.data.codeOnTouch(btn1,0,0,1)
			end
		end
		
		--hGlobal.event:event("Event_ClickTankSkill")
	end

	_CODE_TankSkill = function()
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			local tacticCardCtrls = oWorld.data.tacticCardCtrls --战术技能卡控件集
			local btn1 = tacticCardCtrls[hVar.NORMALATK_IDX]
			if btn1 then
				hGlobal.event:event("Event_ClickTankSkill")
			end
		end
	end

	_CODE_TacticsSkill = function(i)
		hGlobal.event:event("Event_ClickTacticsBtn",i)
	end

	hGlobal.event:listen("Event_HeroRevive","cheatManger",function(oWorld,oHero,oUnit)
		if g_editor == 1 then
			return
		end
		--print("Event_HeroRevive")
		if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then
			hApi.addTimerOnce("RefreshForeverCheat",200,function()
				_CODE_RefreshForeverCheat()
			end)
		end
	end)

	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","cheatManger",function(sSceneType,oWorld,oMap)
		if g_editor == 1 then
			return
		end
		_CODE_ClearFunc()
		if oWorld then
			if oWorld.data.map == hVar.MainBase then
				_tCheatBtnState = {}
			else
				if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then
					hApi.addTimerOnce("RefreshForeverCheat",200,function()
						_CODE_RefreshForeverCheat()
					end)
				end
			end
		end
	end)

	hGlobal.event:listen("LocalEvent_ResetCloseCount","GMCheatFrm",function()
		_nCloseCount = 0
	end)

	hGlobal.event:listen("LocalEvent_UITouchBegin","__UI__HideGMCheatFrm",function(touchX,touchY)
		--print("LocalEvent_UITouchBegin",touchX,touchY,_nCloseCount)
		if _frm and _frm.data.show == 1 then
			if touchX < 100 and touchY > hVar.SCREEN.h - 100 then
				_nCloseCount = _nCloseCount + 1
			end

			if _nCloseCount == 5 then
				_CODE_ClearFunc()
			end
		end
	end)

	hGlobal.event:listen("LocalEvent_CheatAddAllBuff","GMCheatFrm",function()
		for i = 1,#_tCheatBtnForever do
			local keytype = _tCheatBtnForever[i][2]
			local param1 = _tCheatBtnForever[i][3]
			local param2 = _tCheatBtnForever[i][4]
			if _tAutoCheatIndex[i] == 1 then
				_tCheatBtnState[i] = 1
				--print(i,keytype,param1,param2)
				_CODE_DoCheatButton(_tCheatBtnState[i],i,keytype,param1,param2)
			end
		end
		local world = hGlobal.WORLD.LastWorldMap
		if world then
			local me = world:GetPlayerMe()
			if me then
				local heros = me.heros
				local oHero = heros[1]
				if oHero then
					local oUnit = oHero:getunit()
					if oUnit then
						if (oUnit.data.IsDead ~= 1) then --活着的单位
							local targetX, targetY = hApi.chaGetPos(oUnit.handle) --目标的位置
							local gridX, gridY = world:xy2grid(targetX, targetY)
							for i = 1,#_tCheatAddAura do
								local auraid = _tCheatAddAura[i]

								local tAura = hVar.tab_aura[auraid]
								local lv = 1
								if tAura then
									local skill_id = tAura.skill
									local tCastParam =
									{
										level = lv, --等级
									}
									hApi.CastSkill(oUnit, skill_id, 0, 100, oUnit, gridX, gridY, tCastParam) --战车加血技能
								
									local tData = {id = auraid, lv = 1}
									GameManager.AddGameInfo("auraInfo",tData) 
								end
							end
						end
					end
				end
			end
		end
		hGlobal.event:event("LocalEvent_RefreshTacticsBuffIcon")
	end)

	hGlobal.event:listen("LocalEvent_HotKeyControl","CheatManagerFrm",function(btnname,i,Idx)
		local tab = {}
		if btnname == "btn_cheatforever" then
			tab = _tCheatBtnForever
			if tab[i] then
				local keyIdx,_,keytype,param1,param2 = unpack(tab[i])
				if keyIdx == Idx then
					--print("btn_cheatforever")
					_CODE_ClickCheatButton(i,keytype,param1,param2)
				end
			end
		elseif btnname == "btn_cheatonce" then
			tab = _tCheatBtnOnce
			if tab[i] then
				local keyIdx,_,keytype,param1,param2 = unpack(tab[i])
				if keyIdx == Idx then
					--print("btn_cheatonce")
					_CODE_DoCheatButton(1,i,keytype,param1,param2)
				end
			end
		elseif btnname == "btn_cheatfunc" then
			tab = _tCheatBtnFunc
			if tab[i] then
				local keyIdx,_,keytype,param1,param2 = unpack(tab[i])
				if keyIdx == Idx then
					--print("btn_cheatfunc")
					_CODE_DoCheatButton(1,i,keytype,param1,param2)
				end
			end
		end
	end)

	hGlobal.event:listen("LocalEvent_HotKeyCustomControl","CheatManagerFrm",function(Idx)
		--[4001] = {"自动攻击","control",},
		--[4002] = {"单次攻击","control",},
		--[4003] = {"投雷","control",},
		--[4004] = {"战术卡1","control",},
		--[4005] = {"战术卡2","control",},
		--[4006] = {"战术卡3","control",},
		--[4007] = {"战术卡4","control",},
		--[4008] = {"战术卡5","control",},
		--[4009] = {"战术卡6","control",},
		if Idx == 4001 then
			print("Idx == 4001")
			_CODE_AutoAttack()
		elseif Idx == 4002 then
			_CODE_SingleAttack()
		elseif Idx == 4003 then
			_CODE_TankSkill()
		elseif Idx >= 4004 and Idx <= 4009 then
			_CODE_TacticsSkill(Idx - 4004 + 1)
		end
	end)

	hGlobal.event:listen("LocalEvent_SpinScreen","CheatManagerFrm",function()
		if _frm and _frm.data.show == 1 then
			_CODE_ClearFunc()
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_CODE_ClearFunc()
		if g_editor == 1 then
			return
		end
		if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then
			_CODE_CreateFrm()
		end
	end)
end

hGlobal.UI.InitSetHotKeyFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowSetHotKeyFrm", "_show",}
	if (mode ~= "include") then
		--return tInitEventName
	end
	local nHotKeyVerson = "1.0.2"
	local tCanUseSameHotKey = {
		["btn_cheatforever"] = 1,
	}
	local _tBtnlist = {"btn_cheatforever","btn_cheatonce","btn_cheatfunc"}
	local tDynamicSetHotKey = {
		[4001] = {"自动攻击","control",},
		--[4002] = {"单次攻击","control",},
		[4003] = {"投雷","control",},
		[4004] = {"战术卡1","control",},
		[4005] = {"战术卡2","control",},
		[4006] = {"战术卡3","control",},
		[4007] = {"战术卡4","control",},
		[4008] = {"战术卡5","control",},
		[4009] = {"战术卡6","control",},
	}
	local tVK_def = {
		--小键盘0 到 9
		[45] = "n0",
		[35] = "n1",
		[40] = "n2",
		[34] = "n3",
		[37] = "n4",
		[12] = "n5",
		[39] = "n6",
		[36] = "n7",
		[38] = "n8",
		[33] = "n9",
		-- ~ 到 =
		[192] = "~",
		[48] = "0",
		[49] = "1",
		[50] = "2",
		[51] = "3",
		[52] = "4",
		[53] = "5",
		[54] = "6",
		[55] = "7",
		[56] = "8",
		[57] = "9",
		[189] = "-",
		[187] = "=",
		-- q 到 、
		[81] = "q",
		--[87] = "w",
		[69] = "e",
		[82] = "r",
		[84] = "t",
		[89] = "y",
		[85] = "u",
		[73] = "i",
		[79] = "o",
		[80] = "p",
		[219] = "[",
		[221] = "]",
		[220] = "|",
		-- f 到 ’
		[70] = "f",
		[71] = "g",
		[72] = "h",
		[74] = "j",
		[75] = "k",
		[76] = "l",
		[186] = ";",
		[222] = "'",
		-- z 到 、
		[90] = "z",
		[88] = "x",
		[67] = "c",
		[86] = "v",
		[66] = "b",
		[78] = "n",
		[77] = "m",
		[188] = ",",
		[190] = ".",
		[191] = "、",
	}
	local _nShouldUpdate = 0
	local _nHaveInit = 0
	local _nBtnDefaultY = 0 
	local _nCustomCount = 1
	local _frm,_parent,_childUI = nil,nil,nil
	local _nClickBtnInfo = nil
	local _tCustomFrmHotKey = {}
	local _tempCustomFrmHotKey = {}
	local _tVKList = {}
	local _tVKListIdx = {}
	local _tempBackVKList = {}
	local _tempBackVKListIdx = {}
	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateHotKeyBtn = hApi.DoNothing
	local _CODE_CreateBtn = hApi.DoNothing
	local _CODE_CreateCustomHotKeyBtn = hApi.DoNothing
	local _CODE_ClickBtn = hApi.DoNothing
	local _CODE_ClickCustomBtn = hApi.DoNothing
	local _CODE_SetCustomChoose = hApi.DoNothing
	local _CODE_SetCustomChooseInfo = hApi.DoNothing
	local _CODE_ShowtDynamicSetChoose = hApi.DoNothing
	local _CODE_CreateText = hApi.DoNothing
	local _CODE_RefreshButtonEffect = hApi.DoNothing
	local _CODE_SetHotKey = hApi.DoNothing
	local _CODE_CreateHotKeyLabel = hApi.DoNothing
	local _CODE_FloatNumber = hApi.DoNothing
	local _CODE_CancelFunc = hApi.DoNothing
	local _CODE_CancelHotKey = hApi.DoNothing
	local _CODE_CancelAllHotKey = hApi.DoNothing
	local _CODE_SaveHotKetConfig = hApi.DoNothing
	local _CODE_InitHotKeyConfig = hApi.DoNothing
	local _CODE_ControlHotKey = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.SetHotKeyFrm then
			hGlobal.UI.SetHotKeyFrm:del()
			hGlobal.UI.SetHotKeyFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_nClickBtnInfo = nil
		_nShouldUpdate = 0
		_nBtnDefaultY = 0 
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.SetHotKeyFrm  = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,--"UI:zhezhao",
			dragable = 0,
			show = 0,
			z = 20001,
		})
		_frm = hGlobal.UI.SetHotKeyFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		
		local blackareaH = -_nodeY
		local startY = - blackareaH/2

		_childUI["img_blackarea"] = hUI.image:new({
			parent = _parent,
			model = "UI:zhezhao",
			x = hVar.SCREEN.w/2,
			y = startY,
			w = hVar.SCREEN.w,
			h = blackareaH,
		})

		_childUI["lab_title"] = hUI.label:new({
			parent = _parent,
			text = "快捷键设置",
			x = hVar.SCREEN.w/2,
			y = - 50,
			align = "MC",
			size = 28,
		})

		_childUI["btn_cancelclick"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/button_null.png",
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h/2,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			code = function()
				_CODE_ClickBtn(0)
			end,
		})
		
		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/back.png",
			x = 54 + hVar.SCREEN.offx,
			y = -54,
			code = function()
				if _nShouldUpdate == 1 then
					hGlobal.UI.MsgBox("当前快捷键变动并未保存，是否确定要离开",{
						font = hVar.FONTC,
						ok = {"直接离开",function()
							_tVKList = hApi.ReadParamWithDepth(_tempBackVKList,nil,{},3)
							_tVKListIdx = hApi.ReadParamWithDepth(_tempBackVKListIdx,nil,{},3)
							_tCustomFrmHotKey = hApi.ReadParamWithDepth(_tempCustomFrmHotKey,nil,{},3)
							_tempBackVKList = {}
							_tempBackVKListIdx = {}
							_tempCustomFrmHotKey = {}
							_CODE_ClearFunc()
						end},
						cancel = {"取消",function()
							
						end},
					})
				else
					_CODE_ClearFunc()
				end
				
			end,
		})

		_CODE_CreateText()
		_CODE_CreateBtn()
		_CODE_CreateHotKeyBtn()
		_CODE_CreateCustomHotKeyBtn()

		_frm:show(1)
		_frm:active()
	end

	_CODE_CreateText = function()
		local tText = {
			"功能键 F1-F12 back键 awsd 不可用",
			"永久效果栏可共用一个快捷键",
			"点击下方按钮 显示红框即可输入快捷键 按ESC可取消当前快捷键",
			"无论修改还是重置 只有最终点击保存才会起效",
		}

		for i = 1,#tText do
			local txt = tText[i]
			_childUI["lab_txt"..i] = hUI.label:new({
				parent = _parent,
				text = txt,
				x = 40 + hVar.SCREEN.offx,
				y = - 108 - (i - 1) * 32,
				align = "LC",
				size = 24,
			})
			_nBtnDefaultY = - 108 - (i - 1) * 32
		end
	end

	_CODE_CancelFunc = function()
		if type(_nClickBtnInfo) == "table" then
			local idx,btnname,i = unpack(_nClickBtnInfo)
			if btnname == "custom" then
				_CODE_CancelHotKey()
				_CODE_CancelCustomChoose()
				hGlobal.event:event("LocalEvent_CloseDynamicSetChooseFrm")
				_CODE_ClickCustomBtn(0)
			else
				_CODE_CancelHotKey()
				_CODE_ClickBtn(0)
			end
		end
	end

	_CODE_CancelHotKey = function()
		local idx = _nClickBtnInfo[1]
		if _tCustomFrmHotKey[idx] then
			_tCustomFrmHotKey[idx] = 0
		end
		if _childUI["btn_hotkey"..idx] then
			_childUI["btn_hotkey"..idx].handle.s:setOpacity(0)
			hApi.safeRemoveT(_childUI["btn_hotkey"..idx].childUI,"hotkey")
		end
		local key = _tVKListIdx[idx] or 0
		_tVKListIdx[idx] = nil
		if type(_tVKList[key]) == "table" then
			for i = 1,#_tVKList[key] do
				local param = _tVKList[key][i]
				local nIdx = param[1]
				if nIdx == idx then
					table.remove(_tVKList[key],i)
					break
				end
			end
			--_tVKList[key] = nil
			_nShouldUpdate = 1
		end
	end

	_CODE_CancelAllHotKey = function()
		for idx,key in pairs(_tVKListIdx) do
			print(key,idx)
			if _childUI["btn_hotkey"..idx] then
				_childUI["btn_hotkey"..idx].handle.s:setOpacity(0)
				hApi.safeRemoveT(_childUI["btn_hotkey"..idx].childUI,"hotkey")
			end
			_tVKListIdx[idx] = nil
		end
		_tVKListIdx = {}
		_tVKList = {}
		_nClickBtnInfo = nil
		_nShouldUpdate = 1
		_CODE_ClickBtn(0)
		for curIdx = 1,_nCustomCount do
			if _childUI["btn_hotkey"..curIdx] then
				_childUI["btn_hotkey"..curIdx].childUI["add"].handle._n:setVisible(true)
				hApi.safeRemoveT(_childUI["btn_hotkey"..curIdx].childUI,"btn")
				if curIdx ~= 1 then
					_childUI["btn_hotkey"..curIdx]:setstate(-1)
				end
			end
		end
		_tCustomFrmHotKey = {}
		_nCustomCount = 1
	end

	_CODE_RefreshButtonEffect = function(idx,rgb)
		if _childUI["btn_hotkey"..idx] and _childUI["btn_hotkey"..idx].childUI["img"] then
			_childUI["btn_hotkey"..idx].childUI["img"].handle.s:setColor(ccc3(rgb[1], rgb[2], rgb[3]))
		end
	end

	_CODE_ClickCustomBtn = function(idx)
		local oldidx = (_nClickBtnInfo or {})[1] or 0
		if oldidx == 0 and idx == 0 then
			return
		end
		if idx == 0 then
			_CODE_RefreshButtonEffect(oldidx,{255, 255, 255})
			_nClickBtnInfo = nil
		else
			if  oldidx ~= idx and oldidx ~= 0 then
				_CODE_RefreshButtonEffect(oldidx,{255, 255, 255})
			end
			_CODE_RefreshButtonEffect(idx,{255, 0, 0})
			_nClickBtnInfo = {idx,"custom",}
			_CODE_ShowtDynamicSetChoose()
		end
	end

	_CODE_ShowtDynamicSetChoose = function()
		--tDynamicSetHotKey
		local tShow = {}
		local hotIdxlist = {}
		for i = 1,#_tCustomFrmHotKey do
			local hotIdx = _tCustomFrmHotKey[i]
			hotIdxlist[hotIdx] = 1
		end
		--table_print(_tCustomFrmHotKey)
		--table_print(hotIdxlist)
		for hotIdx in pairs(tDynamicSetHotKey) do
			if hotIdxlist[hotIdx] == nil then
				tShow[#tShow+1] = {hotIdx,tDynamicSetHotKey[hotIdx][1]}
			end
		end
		table.sort(tShow,function(t1,t2)
			return t1[1] < t2[1]
		end)
		hGlobal.event:event("LocalEvent_ShowDynamicSetChooseFrm",tShow)
	end

	_CODE_ClickBtn = function(idx,btnname,i)
		print(idx,btnname,i)
		local oldidx = (_nClickBtnInfo or {})[1] or 0
		if oldidx == 0 and idx == 0 then
			return
		end
		if oldidx == idx or idx == 0 then
			_CODE_RefreshButtonEffect(oldidx,{255, 255, 255})
			_nClickBtnInfo = nil
		else
			if oldidx ~= 0 then
				_CODE_RefreshButtonEffect(oldidx,{255, 255, 255})
			end
			_CODE_RefreshButtonEffect(idx,{255, 0, 0})
			_nClickBtnInfo = {idx,btnname,i}
		end
	end

	_CODE_InitHotKeyConfig = function()
		local config = "hotkeyconfig.lua"
		if hApi.FileExists(config) then
			dofile(config)
		end
		--table_print(g_hotkeyConfig)
		if g_hotkeyConfig then
			if nHotKeyVerson ~= g_hotkeyVerson then
				_CODE_FloatNumber("热键版本更新 快捷键重置")
				return
			end
			local temp = {}
			_tCustomFrmHotKey = {}
			_tVKList = hApi.ReadParamWithDepth(g_hotkeyConfig,nil,{},3)
			for key,list in pairs(_tVKList) do
				for i = 1,#list do
					local param = list[i]
					local p1,p2,p3 = unpack(param)
					if type(p2) == "string" and p2 == "custom" then
						temp[#temp + 1] = {p3,key}
					elseif type(p1) == "number"  then
						_tVKListIdx[p1] = key
					end
				end
			end
			table.sort(temp,function(t1,t2)
				if t1[1] == t2[1] then
					return t1[2] < t2[2]
				else
					return t1[1] < t2[1]
				end
			end)
			for i = 1,#temp do
				_tCustomFrmHotKey[i] = temp[i][1]
				_tVKListIdx[i] = temp[i][2]
				if _tVKList[temp[i][2]] then
					for i = 1,#_tVKList[temp[i][2]] do
						if _tVKList[temp[i][2]][i][3] == temp[i][1] then
							_tVKList[temp[i][2]][i][1] = i
						end
					end
					
				end
			end
			_nCustomCount = #_tCustomFrmHotKey + 1
			
			table_print(_tCustomFrmHotKey)
		end
	end

	_CODE_SaveHotKetConfig = function()
		local writeFilePath = "hotkeyconfig.lua"	--写入文件的路径
		local f = io.open(writeFilePath,"w")
		f:write("g_hotkeyConfig = {")
		f:write("\n")
		table_print(_tVKList)
		for key,list in pairs(_tVKList) do
			f:write("  ["..key.."]={\n")
			for i = 1,#list do
				local param = list[i]
				local idx,btnname,i = unpack(param)
				if btnname == "custom" then
					f:write("    {0,\""..btnname.."\","..i.."},\n")
				else
					f:write("    {"..idx..",\""..btnname.."\","..i.."},\n")
				end
			end
			f:write("  },\n")
		end
		f:write("}\n")
		f:write("g_hotkeyVerson = \""..nHotKeyVerson .."\"\n")
		f:close()
		_tempBackVKList = hApi.ReadParamWithDepth(_tVKList,nil,{},3)
		_tempBackVKListIdx = hApi.ReadParamWithDepth(_tVKListIdx,nil,{},3)
		_CODE_FloatNumber("保存成功")
		_nShouldUpdate = 0
	end

	_CODE_CreateBtn = function()
		local maxbtn = 3
		local btnoffw = 200
		local btnY = _nodeY - 20
		local btnH = 80
		local btnx = hVar.SCREEN.w - 110 --hVar.SCREEN.w/2 - (math.floor(maxbtn + 1)/2 - 1) * btnoffw
		_childUI["btn_clearall"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			dragbox = _childUI["dragBox"],
			label = {text = "重置全部",size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,RGB = RGB},
			x = btnx,
			y = btnY + btnH * 2,
			scale = 0.7,
			scaleT = 0.95,
			code = function()
				_CODE_CancelAllHotKey()
			end,
		})

		_childUI["btn_save"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/cg.png",
			dragbox = _childUI["dragBox"],
			label = {text = "保存配置",size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,RGB = RGB},
			x = btnx,
			y = btnY + btnH,
			scale = 0.7,
			scaleT = 0.95,
			code = function()
				_CODE_SaveHotKetConfig()
			end,
		})
	end

	_CODE_CreateCustomHotKeyBtn = function()
		print("_CODE_CreateCustomHotKeyBtn")
		local startx = hVar.SCREEN.offx + 30
		_childUI["lab_titleconfig1"] = hUI.label:new({
			parent = _parent,
			text = "功能快捷键",
			x = startx,
			y = _nBtnDefaultY - 40,
			align = "MT",
			size = 26,
			width = 30,
		})

		local line = 3
		local cow = 5
		local startIdx = 0
		local btnw = 160
		local btnh = 50
		local btnoffw = 196
		local btnoffh = 70
		for j = 1,cow do
			for i = 1,line do
				local idx = (j - 1) * line + i
				local curIdx = startIdx + idx
				_childUI["btn_hotkey"..curIdx] = hUI.button:new({
					parent = _parent,
					model = "UI:zhezhao",
					dragbox = _childUI["dragBox"],
					w = btnw,
					h = btnh,
					x = startx + (j - 0.5) * btnoffw + 24,
					y = _nBtnDefaultY - (i -0.5) * btnoffh - 30,
					scaleT = 0.9,
					code = function()
						_CODE_ClickCustomBtn(curIdx)
					end,
				})
				_childUI["btn_hotkey"..curIdx].handle.s:setOpacity(0)

				_childUI["btn_hotkey"..curIdx].childUI["add"] = hUI.button:new({
					parent = _childUI["btn_hotkey"..curIdx].handle._n,
					model = "misc/skillup/addtimes.png",
				})

				_childUI["btn_hotkey"..curIdx].childUI["img"] = hUI.image:new({
					parent = _childUI["btn_hotkey"..curIdx].handle._n,
					model = "misc/billboard/kuang8.png",
					w = btnw + 10,
					h = btnh + 8,
					z = 5,
				})
				_childUI["btn_hotkey"..curIdx]:setstate(-1)
				if _tCustomFrmHotKey[curIdx] then
					_childUI["btn_hotkey"..curIdx]:setstate(1)
					_CODE_SetCustomChooseInfo(curIdx,_tCustomFrmHotKey[curIdx])
					if _tVKListIdx[curIdx] then
						local key = _tVKListIdx[curIdx]
						_CODE_CreateHotKeyLabel(curIdx,key,tVK_def[key])
					end
				elseif #_tCustomFrmHotKey + 1 == idx then
					_childUI["btn_hotkey"..curIdx]:setstate(1)
				end
			end
		end
	end

	_CODE_CancelCustomChoose = function()
		local curIdx = _nClickBtnInfo[1]
		_childUI["btn_hotkey"..curIdx].childUI["add"].handle._n:setVisible(true)
		hApi.safeRemoveT(_childUI["btn_hotkey"..curIdx].childUI,"btn")
	end

	_CODE_SetCustomChoose = function(hotIdx)
		_nClickBtnInfo[3] = hotIdx
		local curIdx = _nClickBtnInfo[1]
		_tCustomFrmHotKey[curIdx] = hotIdx
		--table_print(_tCustomFrmHotKey)
		if _nCustomCount == curIdx then
			_nCustomCount = _nCustomCount + 1
			_childUI["btn_hotkey".._nCustomCount]:setstate(1)
		end
		_CODE_SetCustomChooseInfo(curIdx,hotIdx)
	end

	_CODE_SetCustomChooseInfo = function(curIdx,hotIdx)
		--{"自动攻击","control",},
		--{"单次攻击","control",},
		--{"投雷","control",},
		local tInfo = nil
		for nhotIdx in pairs(tDynamicSetHotKey) do
			if nhotIdx == hotIdx then
				tInfo = tDynamicSetHotKey[nhotIdx]
				break
			end
		end

		if tInfo == nil then
			return
		end
		
		_childUI["btn_hotkey"..curIdx].childUI["add"].handle._n:setVisible(false)
		hApi.safeRemoveT(_childUI["btn_hotkey"..curIdx].childUI,"btn")
		_childUI["btn_hotkey"..curIdx].childUI["btn"] = hUI.button:new({
			parent = _childUI["btn_hotkey"..curIdx].handle._n,
			model = "misc/addition/cg.png",
			scale = 0.7,
			label = {text = tInfo[1],size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32},
			z = -1,
		})
	end

	_CODE_CreateHotKeyBtn = function()
		local frm = hGlobal.UI.CheatManagerFrm
		if frm then
			local childUI = frm.childUI
			local maxnum = 20
			for z = 1,#_tBtnlist do
				for i = 1,maxnum do
					local btnname = _tBtnlist[z]
					local btn = childUI[btnname..i]
					if btn then
						local curIdx = btn.data.keyIdx
						print(btnname,i,curIdx)
						_childUI["btn_hotkey"..curIdx] = hUI.button:new({
							parent = _parent,
							dragbox = _childUI["dragBox"],
							model = "UI:zhezhao",
							--model = "misc/billboard/kuang8.png",
							x = btn.data.x,
							y = btn.data.y,
							w = btn.data.w + 10,
							h = btn.data.h + 8,
							scaleT = 0.9,
							code = function(self)
								print(curIdx,btnname,i)
								_CODE_ClickBtn(curIdx,btnname,i)
							end,
						})
						_childUI["btn_hotkey"..curIdx].handle.s:setOpacity(0)
						_childUI["btn_hotkey"..curIdx].childUI["img"] = hUI.image:new({
							parent = _childUI["btn_hotkey"..curIdx].handle._n,
							model = "misc/billboard/kuang8.png",
							w = btn.data.w + 10,
							h = btn.data.h + 8,
						})

						if _tVKListIdx[curIdx] then
							local key = _tVKListIdx[curIdx]
							_CODE_CreateHotKeyLabel(curIdx,key,tVK_def[key])
						end
					end
				end
			end
		end
	end

	_CODE_CreateHotKeyLabel = function(idx,key,txt)
		if _childUI["btn_hotkey"..idx] then
			_childUI["btn_hotkey"..idx].handle.s:setOpacity(200)
			hApi.safeRemoveT(_childUI["btn_hotkey"..idx].childUI,"hotkey")
			_childUI["btn_hotkey"..idx].childUI["hotkey"] = hUI.label:new({
				parent = _childUI["btn_hotkey"..idx].handle._n,
				text = tostring(txt),
				x = _childUI["btn_hotkey"..idx].data.w/2 - 8,
				y = 6,
				align = "RC",
				size = 42,
				RGB = {0, 255, 255},
			})
		end
	end

	_CODE_FloatNumber = function(str)
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2 + 20,
			align = "MC",
			text = "",
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		}):addtext(str, hVar.FONTC, 32, "MC", 0, 0,nil,1)
	end

	_CODE_SetHotKey = function(key)
		if tVK_def[key] then
			if type(_nClickBtnInfo) == "table" then
				local newidx,newbtnname,newi = unpack(_nClickBtnInfo)
				if newi == nil then
					return
				end
				if _tVKList[key] then
					local cleadIdxList = {}
					local shouldClear = 0
					for i = 1,#_tVKList[key] do
						local param = _tVKList[key][i]
						local idx,btnname,i = unpack(param)
						cleadIdxList[#cleadIdxList + 1] = idx
						print(btnname,newbtnname)
						if tCanUseSameHotKey[btnname] ~= 1 or tCanUseSameHotKey[newbtnname] ~= 1 then
							shouldClear = 1
						end
						if newidx == idx then
							return
						end
					end
					if shouldClear == 1 then
						for i = 1,#cleadIdxList do
							local idx = cleadIdxList[i]
							if _childUI["btn_hotkey"..idx] then
								_childUI["btn_hotkey"..idx].handle.s:setOpacity(0)
								hApi.safeRemoveT(_childUI["btn_hotkey"..idx].childUI,"hotkey")
							end
							_tVKListIdx[idx] = nil
						end
						_tVKList[key] = nil
						local str = string.format("快捷键%s发生变更",tVK_def[key])
						_CODE_FloatNumber(str)
					end
				end
				local oldkey = _tVKListIdx[newidx]
				if oldkey then
					_tVKList[oldkey] = nil
				end

				if _tVKList[key] == nil then
					_tVKList[key] = {}
				end
				local nextI = #_tVKList[key] + 1
				_CODE_CreateHotKeyLabel(newidx,key,tVK_def[key])
				_tVKList[key][nextI] = hApi.ReadParamWithDepth(_nClickBtnInfo,nil,{},3)
				_tVKListIdx[newidx] = key
				_nShouldUpdate = 1
				--table_print(_tVKList)
			end
		else
			if type(_nClickBtnInfo) == "table" then
				_CODE_FloatNumber("此快捷键不可用")
			end
		end
	end

	_CODE_ControlHotKey = function(key)
		local list = _tVKList[key]
		if type(list) == "table" then
			--table_print(list)
			for i = 1,#list do
				local control = list[i]
				if type(control) == "table" then
					local p1,p2,p3 = unpack(control)
					if type(p2) == "string" and p2 == "custom" then
						hGlobal.event:event("LocalEvent_HotKeyCustomControl",p3)
					elseif type(p1) == "number" then
						hGlobal.event:event("LocalEvent_HotKeyControl",p2,p3,p1)
					end
				end
			end
		end
	end

	hGlobal.event:listen("LocalEvent_SpinScreen","CheatManagerFrm",function()
		if _frm and _frm.data.show == 1 then
			_CODE_ClearFunc()
		end
	end)

	hGlobal.event:listen("Event_SetHotKey","cheatManger",function(key)
		print("key="..key)
		if _frm and _frm.data.show == 1 then
			--设置
			if key ~= 27 then	--ESC
				_CODE_SetHotKey(key)
			else
				_CODE_CancelFunc()
			end
		else
			--使用
			_CODE_ControlHotKey(key)
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(nodeY)
		if g_editor == 1 then
			return
		end
		_tempBackVKList = hApi.ReadParamWithDepth(_tVKList,nil,{},3)
		_tempBackVKListIdx = hApi.ReadParamWithDepth(_tVKListIdx,nil,{},3)
		_tempCustomFrmHotKey = hApi.ReadParamWithDepth(_tCustomFrmHotKey,nil,{},3)
		_CODE_ClearFunc()
		_nodeY = nodeY
		_CODE_CreateFrm()
	end)

	hGlobal.event:listen("Event_ChooseCustomHotIdx","cheatManger",function(hotIdx)
		print("hotIdx",hotIdx)
		_CODE_SetCustomChoose(hotIdx)
	end)

	hGlobal.event:listen("Event_InitHotKey","cheatManger",function(key)
		if g_editor == 1 then
			return
		end
		if g_lua_src ~= 1 then
			return
		end
		if _nHaveInit == 0 then
			_nHaveInit = 1
			_CODE_InitHotKeyConfig()
		end
	end)
	_CODE_InitHotKeyConfig()
end

hGlobal.UI.InitDynamicSetChooseFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowDynamicSetChooseFrm", "_show",}
	if (mode ~= "include") then
		--return tInitEventName
	end

	local _boardWH = {360,660}

	local _frm,_parent,_childUI = nil,nil,nil
	local _tChoose = {}
	local _nCurrentPage = 1
	local _nMaxPage = 0
	local _nMaxShow = 8

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateChoose = hApi.DoNothing
	local _CODE_ChangePage = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.DynamicSetChooseFrm then
			hGlobal.UI.DynamicSetChooseFrm:del()
			hGlobal.UI.DynamicSetChooseFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_tChoose = {}
		_nMaxPage = 0
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.DynamicSetChooseFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,--"UI:zhezhao",
			dragable = 0,
			show = 0,
			z = 20002,
		})
		_frm = hGlobal.UI.DynamicSetChooseFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		local offx = hVar.SCREEN.w/2
		local offy = -hVar.SCREEN.h/2

		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			--model = "misc/mask.png",
			dragbox = _childUI["dragBox"],
			x = offx,
			y = offy,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			code = function()
				print("aaa")
				_CODE_ClearFunc()
			end
		})

		_childUI["img_blackarea"] = hUI.button:new({
			parent = _parent,
			--model = "misc/button_null.png",
			model = "UI:zhezhao",
			dragbox = _childUI["dragBox"],
			x = offx,
			y = offy,
			w = _boardWH[1],
			h = _boardWH[2],
		})
		local img9 = hApi.CCScale9SpriteCreate("data/image/misc/billboard/bg_ng_graywhite.png", 0, 0, _boardWH[1], _boardWH[2], _childUI["img_blackarea"])
		img9:setOpacity(150)

		_childUI["lab_title"] = hUI.label:new({
			parent = _parent,
			text = "选择操作",
			x = offx,
			y = offy + _boardWH[2]/2 - 40,
			align = "MC",
			size = 32,
		})

		_childUI["lab_page"] = hUI.label:new({
			parent = _parent,
			x = offx,
			y = offy - _boardWH[2]/2 + 64,
			align = "MC",
			font = hVar.FONTC,
			text = tostring(_nCurrentPage) .. " / " .. tostring(_nMaxPage),
			size = 28,
		})

		_childUI["btn_pagepro"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/change_arrow.png",
			dragbox = _childUI["dragBox"],
			x = offx - 96,
			y = offy - _boardWH[2]/2 + 60,
			scale = 0.3,
			scaleT = 0.9,
			code = function()
				_CODE_ChangePage(-1)
			end,
		})

		_childUI["btn_pagenext"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/change_arrow.png",
			dragbox = _childUI["dragBox"],
			x = offx + 96,
			y = offy - _boardWH[2]/2 + 60,
			scale = 0.3,
			scaleT = 0.9,
			code = function()
				_CODE_ChangePage(1)
			end,
		})
		_childUI["btn_pagenext"].handle.s:setRotation(180)

		_frm:show(1)
		_frm:active()
	end

	_CODE_ChangePage = function(value)
		local newPage = _nCurrentPage + value
		if newPage >= 1 and newPage <= _nMaxPage then
			_nCurrentPage = newPage
			local text = tostring(_nCurrentPage) .. " / " .. tostring(_nMaxPage)
			_childUI["lab_page"]:setText(text)
			_CODE_CreateChoose()
		end
	end

	_CODE_CreateChoose = function()
		local offx = hVar.SCREEN.w/2
		local offy = -hVar.SCREEN.h/2
		local startY = offy + _boardWH[2]/2 - 90
		local offh = math.floor(470 /_nMaxShow)
		for i = 1,_nMaxShow do
			hApi.safeRemoveT(_childUI,"btn_choose"..i)
			local realIdx = (_nCurrentPage - 1) * _nMaxShow + i
			if _tChoose[realIdx] then
				local hotidx,txt = unpack(_tChoose[realIdx])
				_childUI["btn_choose"..i] = hUI.button:new({
					parent = _parent,
					model = "misc/mask.png",
					dragbox = _childUI["dragBox"],
					x = offx,
					y = startY - (i - 0.5) * offh,
					w = _boardWH[1] - 10,
					h = offh - 6,
					code = function()
						--print(hotidx,i,realIdx)
						hGlobal.event:event("Event_ChooseCustomHotIdx",hotidx)
						_CODE_ClearFunc()
					end,
				})
				_childUI["btn_choose"..i].handle.s:setColor(ccc3(50,50,50))

				local btnChild = _childUI["btn_choose"..i].childUI
				local btnParent = _childUI["btn_choose"..i].handle._n

				btnChild["lab"] = hUI.label:new({
					parent = btnParent,
					text = txt,
					align = "MC",
					font = hVar.FONTC,
					size = 28,
				})
			end
		end
	end

	hGlobal.event:listen("LocalEvent_SpinScreen","DynamicSetChooseFrm",function()
		if _frm and _frm.data.show == 1 then
			_CODE_ClearFunc()
		end
	end)

	hGlobal.event:listen("LocalEvent_CloseDynamicSetChooseFrm","DynamicSetChooseFrm",function()
		_CODE_ClearFunc()
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(tChooseList)
		if g_editor == 1 then
			return
		end
		_CODE_ClearFunc()
		_tChoose = tChooseList
		--for i = 1,20 do
			--if _tChoose[i] == nil then
				--_tChoose[i] = _tChoose[1]
			--end
		--end
		--table_print(_tChoose)
		_nMaxPage = math.ceil(#_tChoose / _nMaxShow)
		_nCurrentPage = math.min(_nCurrentPage,_nMaxPage)
		_CODE_CreateFrm()
		_CODE_CreateChoose()
	end)
end

hGlobal.UI.InitPetCheatManagerFrm = function()
	local tInitEventName = {"LocalEvent_ShowPetCheatManagerFrm", "_show",}
	if (mode ~= "include") then
		--return tInitEventName
	end

	local _nPetListLine = 2
	local _nPetListCow = 5

	local _nChoosePetStartX = hVar.SCREEN.offx + 220
	local _nChoosePetStartY = - 100
	local _nChoosePetBgW = hVar.SCREEN.w - hVar.SCREEN.offx * 2 - 220 - 30
	local _nChoosePetBgH = 160
	local _nChoosePetWH = 160
	local _nSCREENoffx = 0
	local _nSCREENoffy = 0

	local _frm,_parent,_childUI = nil,nil,nil
	local _nChooseType = 0
	local _nChoosePage = 0
	local _nChooseCow = 0
	local _nChooseLine = 0
	local _nChooseLv = 0
	local _tChooseUI = {}

	local _tPetMain = {}
	local _tPetManagerList = {}
	
	local _tPetUnitManager = {}

	local _bHaveChange = false


	local _tChooseType = {
		{"主宠物",5},
		{"召唤物",5},
	}

	local _tMainPet = {
		{13041,0,0},
		{13042,0,-10},
		{13043,0,-20},
		{13044,0,0},
	}

	--31020
	local _tSummon = {
		{12217,0,0},
		{12218,0,0},
		{12219,0,-10},
	}

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_GetUIParam = hApi.DoNothing
	local _CODE_GetPetData = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateChooseType = hApi.DoNothing
	local _CODE_CreateChooseUI = hApi.DoNothing
	local _CODE_CreateChoose = hApi.DoNothing
	local _CODE_ClearChooseUI = hApi.DoNothing
	local _CODE_ClickChooseType = hApi.DoNothing
	local _CODE_ChangeChoosePage = hApi.DoNothing
	local _CODE_RefreshChoose = hApi.DoNothing
	local _CODE_ClearLevelBtn = hApi.DoNothing
	local _CODE_CreateLevelBtn = hApi.DoNothing
	local _CODE_RefreshLevelBtn = hApi.DoNothing

	local _CODE_ClickChoose = hApi.DoNothing

	local _CODE_CreatePetManagerUI = hApi.DoNothing
	local _CODE_CreatePetInfo = hApi.DoNothing
	local _CODE_RefreshPetManager = hApi.DoNothing
	local _CODE_RefreshMainPet = hApi.DoNothing
	local _CODE_RefreshPetList = hApi.DoNothing

	local _CODE_ChangePet = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.PetCheatManagerFrm then
			hGlobal.UI.PetCheatManagerFrm:del()
			hGlobal.UI.PetCheatManagerFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_nChooseType = 0
		_nChooseCow = 0
		_nChoosePage = 0
		_nChooseLv = 0
		_tChooseUI = {}
	end

	_CODE_ClearChooseUI = function()
		for i = 1,#_tChooseUI do
			hApi.safeRemoveT(_childUI,_tChooseUI[i])
		end
		_tChooseUI = {}
	end

	_CODE_GetUIParam = function()
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
			_nPetListLine = 2
			_nPetListCow = 5

			_nSCREENoffx = hVar.SCREEN.offx
			_nSCREENoffy = 0
			_nChoosePetStartX = _nSCREENoffx + 220
			_nChoosePetStartY = - 100
			_nChoosePetBgW = hVar.SCREEN.w - _nSCREENoffx * 2 - 220 - 30
			_nChoosePetBgH = 160
			_nChoosePetWH = 160
			_nChooseLine = 1
		else
			_nSCREENoffx = 0
			_nSCREENoffy = - hVar.SCREEN.offx
			_nChoosePetStartX =  220
			_nChoosePetStartY = - 100 + _nSCREENoffy
			_nPetListLine = 4
			_nPetListCow = 2
			_nChoosePetBgW = hVar.SCREEN.w - 220 - 30
			_nChoosePetBgH = 360
			_nChooseLine = 2
		end
	end

	_CODE_CreateChoose = function()
		local tList
		if _nChooseType == 1 then
			tList = _tMainPet
		elseif _nChooseType == 2 then
			tList = _tSummon
		end
		if type(tList) == "table" then
			local petWH = _nChoosePetWH
			local cow = _nChooseCow
			local offw = math.floor((_nChoosePetBgW - petWH * cow)/(cow + 1))
			local offh = math.floor((_nChoosePetBgH - petWH * _nChooseLine)/(_nChooseLine + 1))
			local pagemax = _nChooseLine + _nChooseCow
			for j = 1,_nChooseLine do
				for i = 1,cow do
					local idx = (j - 1) * cow + i
					local index = (_nChoosePage - 1) * pagemax + idx
					if tList[index] then
						local id,offx,offy = unpack(tList[index])
						_childUI["_CODE_ChoosePet"..idx] = hUI.button:new({
							parent = _parent,
							dragbox = _childUI["dragBox"],
							--model = "misc/mask.png",
							model = "misc/button_null.png",
							x = _nChoosePetStartX + (petWH + offw) * (i-1) + petWH/2 + offw,
							y = _nChoosePetStartY - offh * j - petWH * (j - 0.5),
							w = petWH,
							h = petWH,
							code = function()
								print("index",index)
								_CODE_ClickChoose(index)
							end
						})
						_tChooseUI[#_tChooseUI+1] = "_CODE_ChoosePet"..idx

						_childUI["_CODE_ChoosePet"..idx].childUI["pet"] = hUI.thumbImage:new({
							parent = _childUI["_CODE_ChoosePet"..idx].handle._n,
							x = offx,
							y = offy,
							id = id,
							facing = 270,
						})

						_childUI["_CODE_ChoosePet"..idx].childUI["name"] = hUI.label:new({
							parent = _childUI["_CODE_ChoosePet"..idx].handle._n,
							x = 0,
							y = - 40,
							text = id,
							size = 26,
							align = "MC",
						})
					end
				end
			end
		end
	end

	_CODE_RefreshChoose = function()
		_CODE_ClearChooseUI()
		for i = 1,#_tChooseType do
			if _childUI["btn_type"..i] then
				if _nChooseType == i then
					hApi.AddShader(_childUI["btn_type"..i].handle.s, "normal")
				else
					hApi.AddShader(_childUI["btn_type"..i].handle.s, "gray")
				end
			end
		end
		_CODE_CreateChoose()
	end

	_CODE_ClearLevelBtn = function()
		if _tChooseType[_nChooseType] then
			local lvmax = _tChooseType[_nChooseType][2] or 0
			for i = 1,lvmax do
				hApi.safeRemoveT(_childUI,"btn_level"..i)
			end
		end
	end

	_CODE_CreateLevelBtn = function()
		if _tChooseType[_nChooseType] then
			local lvmax = _tChooseType[_nChooseType][2] or 0
			local btnWH = 40
			for i = 1,lvmax do
				_childUI["btn_level"..i] = hUI.button:new({
					parent = _parent,
					model = "misc/billboard/kuang5.png",
					dragbox = _childUI["dragBox"],
					label = {text = i,z = 1,y = 2,},
					x = _nSCREENoffx + 150 + (i-1)*50,
					y = - 132 - _nChoosePetBgH + _nSCREENoffy,
					w = btnWH,
					h = btnWH,
					code = function()
						if i == _nChooseLv then
							_nChooseLv = 0
						else
							_nChooseLv = i
						end
						_CODE_RefreshLevelBtn()
					end,
				})
			end
			_CODE_RefreshLevelBtn()
		end
	end

	_CODE_RefreshLevelBtn = function()
		local lvmax = _tChooseType[_nChooseType][2] or 0
		for i = 1,lvmax do
			if _childUI["btn_level"..i] then
				if _nChooseLv == i then
					hApi.AddShader(_childUI["btn_level"..i].handle.s, "normal")
				else
					hApi.AddShader(_childUI["btn_level"..i].handle.s, "gray")
				end
			end
		end
	end

	_CODE_ClickChooseType = function(ntype)
		if _nChooseType ~= ntype then
			_CODE_ClearLevelBtn()		--清理等级按钮
			_nChooseType = ntype		--切换类型
			_CODE_CreateLevelBtn()		--创建等级按钮
			_nChoosePage = 0		--重置page
			_CODE_ChangeChoosePage(1)	--切page为1
		end
	end

	_CODE_ChangeChoosePage = function(npage)
		--print("_CODE_ChangeChoosePage",npage,_nChoosePage)
		local tList
		if _nChooseType == 1 then
			tList = _tMainPet
		elseif _nChooseType == 2 then
			tList = _tSummon
		end
		if type(tList) == "table" then
			_nChooseCow = math.floor(_nChoosePetBgW/_nChoosePetWH)
			--print(#tList,_nChooseCow)
			local maxPage = math.ceil(#tList/_nChooseCow/_nChooseLine)
			if npage>=1 and npage<= maxPage and _nChoosePage ~= npage then
				_nChoosePage = npage
				--刷新所有选择项
				_CODE_RefreshChoose()
			end
			--刷新页数
			_childUI["lab_page"]:setText("page "..tostring(_nChoosePage).." / "..maxPage)
			--刷新按钮状态
			if  _nChoosePage == 1 then
				_childUI["btn_pagepro"]:setstate(-1)
			else
				_childUI["btn_pagepro"]:setstate(1)
			end
			if _nChoosePage == maxPage then
				_childUI["btn_pagenext"]:setstate(-1)
			else
				_childUI["btn_pagenext"]:setstate(1)
			end
		end
	end

	_CODE_CreateChooseType = function()
		for i = 1,#_tChooseType do
			_childUI["btn_type"..i] = hUI.button:new({
				parent = _parent,
				--model = "misc/mask.png",
				dragbox = _childUI["dragBox"],
				model = "misc/addition/cg.png",
				label = {text = _tChooseType[i][1],size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
				x = _nSCREENoffx + 110,
				y = -140 - (i-1)* 70 + _nSCREENoffy,
				scale = 0.74,
				scaleT = 0.95,
				code = function()
					_CODE_ClickChooseType(i)
				end,
			})
		end
	end

	_CODE_CreateChooseUI = function()
		_childUI["img_choosepetbg"] = hUI.button:new({
			parent = _parent,
			--model = "misc/mask.png",
			model = "misc/button_null.png",
			x = _nChoosePetStartX + _nChoosePetBgW/2,
			y = _nChoosePetStartY - _nChoosePetBgH/2,
			w = _nChoosePetBgW,
			h = _nChoosePetBgH,
		})
		hApi.CCScale9SpriteCreate("data/image/misc/billboard/kuang5.png", 0, 0, _nChoosePetBgW,_nChoosePetBgH, _childUI["img_choosepetbg"])

		_childUI["lab_level"] = hUI.label:new({
			parent = _parent,
			text = "LEVEL",
			x = _nSCREENoffx + 30,
			y = - 130 - _nChoosePetBgH + _nSCREENoffy,
			align = "LC",
			size = 26,
		}) 

		_childUI["lab_page"] = hUI.label:new({
			parent = _parent,
			x = hVar.SCREEN.w - _nSCREENoffx - 160,
			y = - 130 - _nChoosePetBgH + _nSCREENoffy,
			align = "MC",
			size = 26,
		}) 

		_childUI["btn_pagepro"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/change_arrow.png",
			dragbox = _childUI["dragBox"],
			x = hVar.SCREEN.w - _nSCREENoffx - 280,
			y = - 132 - _nChoosePetBgH + _nSCREENoffy,
			scale = 0.3,
			scaleT = 0.9,
			code = function()
				_CODE_ChangeChoosePage(_nChoosePage-1)
			end,
		})

		_childUI["btn_pagenext"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/change_arrow.png",
			dragbox = _childUI["dragBox"],
			x = hVar.SCREEN.w - _nSCREENoffx - 40,
			y = - 132 - _nChoosePetBgH + _nSCREENoffy,
			scale = 0.3,
			scaleT = 0.9,
			code = function()
				_CODE_ChangeChoosePage(_nChoosePage+1)
			end,
		})
		_childUI["btn_pagenext"].handle.s:setRotation(180)

		_childUI["line1"] = hUI.image:new({
			parent = _parent,
			model = "ui/title_line.png",
			x = hVar.SCREEN.w/2,
			y = - 190 - _nChoosePetBgH + _nSCREENoffy,
			w = hVar.SCREEN.w,
			h = 6,
		})

		_CODE_CreateChooseType()
		_CODE_ClickChooseType(1)
	end

	_CODE_CreatePetManagerUI = function()
		local offw = (hVar.SCREEN.w - 2 * _nSCREENoffx - (_nPetListCow+1) * _nChoosePetWH - 120) / (_nPetListCow+2)
		local startx = _nSCREENoffx + 40
		_childUI["lab_mainpet"] = hUI.label:new({
			parent = _parent,
			text = "主宠物",
			x = startx,
			y = - 210 - _nChoosePetBgH + _nSCREENoffy,
			width = 30,
			align = "MT",
			size = 26,
		})

		startx = startx + 15 + _nChoosePetWH/2 + offw

		_childUI["node_mainpet"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			dragbox = _childUI["dragBox"],
			x = startx ,
			y = - 210 - _nChoosePetBgH - _nChoosePetWH/2+ _nSCREENoffy,
			w = _nChoosePetWH,
			h = _nChoosePetWH,
			code = function()
				_tPetMain = 0
				_CODE_RefreshMainPet()
				_bHaveChange = true
			end
		})
		hApi.CCScale9SpriteCreate("data/image/misc/billboard/kuang5.png", 0, 0, _nChoosePetWH,_nChoosePetWH, _childUI["node_mainpet"])
		
		startx = startx + _nChoosePetWH/2 + offw + 15

		_childUI["lab_petlist"] = hUI.label:new({
			parent = _parent,
			text = "召唤物列表",
			x = startx,
			y = - 210 - _nChoosePetBgH + _nSCREENoffy,
			width = 30,
			align = "MT",
			size = 26,
		})

		local startx = startx + 15 + offw
		for i = 1,_nPetListLine do
			for j = 1,_nPetListCow do
				local index = (i-1) * _nPetListCow + j
				_childUI["node_petlist"..index] = hUI.button:new({
					parent = _parent,
					model = "misc/button_null.png",
					dragbox = _childUI["dragBox"],
					x = startx + _nChoosePetWH/2 + (j-1)* (_nChoosePetWH + offw),
					y = - 210 - _nChoosePetBgH - _nChoosePetWH/2 - (i-1)* (_nChoosePetWH + 16) + _nSCREENoffy,
					w = _nChoosePetWH,
					h = _nChoosePetWH,
					code = function()
						if _tPetManagerList[index] then
							table.remove(_tPetManagerList,index)
							_CODE_RefreshPetList()
							_bHaveChange = true
						end
					end
				})
				hApi.CCScale9SpriteCreate("data/image/misc/billboard/kuang5.png", 0, 0, _nChoosePetWH,_nChoosePetWH, _childUI["node_petlist"..index])
			end
		end
		_CODE_RefreshPetManager()
	end

	_CODE_RefreshPetManager = function()
		_CODE_RefreshMainPet()
		_CODE_RefreshPetList()
	end

	_CODE_RefreshMainPet = function()
		if _childUI and _childUI["node_mainpet"] then
			hApi.safeRemoveT(_childUI["node_mainpet"].childUI,"node_info")
			if type(_tPetMain) == "table" then
				local petid,petlv = unpack(_tPetMain)
				if (petid or 0) ~= 0 then
					_CODE_CreatePetInfo(_childUI["node_mainpet"],petid,petlv)
				end
			end
		end
	end

	_CODE_RefreshPetList = function()
		local maxnum = _nPetListLine * _nPetListCow
		for index = 1,maxnum do
			if _childUI and _childUI["node_petlist"..index] then
				hApi.safeRemoveT(_childUI["node_petlist"..index].childUI,"node_info")
				if type(_tPetManagerList[index]) == "table" then
					local petid,petlv = unpack(_tPetManagerList[index])
					if (petid or 0) ~= 0 then
						_CODE_CreatePetInfo(_childUI["node_petlist"..index],petid,petlv)
					end
				end
			end
		end
	end

	_CODE_CreatePetInfo = function(node,id,lv)
		node.childUI["node_info"] = hUI.button:new({
			parent = node.handle._n,
			model = "misc/button_null.png",
			x = 0,
			y = 0,
			w = 1,
			h = 1,
		})

		local nodeChild = node.childUI["node_info"].childUI
		local nodeParent = node.childUI["node_info"].handle._n

		nodeChild["img_pet"] = hUI.thumbImage:new({
			parent = nodeParent,
			x = 0,
			y = 10,
			id = id,
			facing = 270,
		})

		nodeChild["lab_petid"] = hUI.label:new({
			parent = nodeParent,
			x = 0,
			y = - 30,
			text = id,
			size = 26,
			align = "MC",
		})

		nodeChild["lab_petlv"] = hUI.label:new({
			parent = nodeParent,
			x = 0,
			y = - 60,
			text = "LEVEL"..tostring(lv),
			size = 24,
			align = "MC",
		})
	end

	_CODE_ClickChoose = function(index)
		if _nChooseType == 1 then
			local info = _tMainPet[index]
			if info then
				local petid = info[1]
				local shouldchange = false
				if type(_tPetMain) == "table" then
					local curpetid = _tPetMain[1] or 0
					local curpetlv = _tPetMain[2] or 0
					if curpetid ~= petid or curpetlv ~= _nChooseLv then
						shouldchange = true
					end
				else
					shouldchange = true
				end
				if shouldchange then
					_tPetMain = {}
					_tPetMain[1] = petid
					if _nChooseLv == 0 then
						local index = LuaGetHeroPetIndexById(hVar.MY_TANK_ID,petid)
						local petLv = LuaGetHeroPetLv(hVar.MY_TANK_ID, index)
						if petLv == 0 then
							petLv = 1
						end
						_tPetMain[2] = petLv
					else
						_tPetMain[2] = _nChooseLv
					end
					_CODE_RefreshMainPet()
					_bHaveChange = true
				end
			end
		elseif _nChooseType == 2 then
			--print("_nChooseType == 2")
			local maxnum = _nPetListLine * _nPetListCow
			if #_tPetManagerList < maxnum then
				local info = _tSummon[index]
				if info then
					local petid = info[1]
					local petlv = 1
					if _nChooseLv ~= 0 then
						petlv = _nChooseLv
					end
					_tPetManagerList[#_tPetManagerList+1] = {petid,petlv}
					--table_print(_tPetManagerList)
					_CODE_RefreshPetList()
					_bHaveChange = true
				end
			end
		end
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.PetCheatManagerFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = "UI:zhezhao",
			dragable = 0,
			show = 0,
			z = 20001,
		})
		_frm = hGlobal.UI.PetCheatManagerFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/back.png",
			x = 54 + _nSCREENoffx,
			y = -54 + _nSCREENoffy,
			code = function()
				hGlobal.event:event("LocalEvent_ResetCloseCount")
				_CODE_ChangePet()
				_CODE_ClearFunc()
			end,
		})

		_childUI["lab_titlemap"] = hUI.label:new({
			parent = _parent,
			text = "宠物管理界面",
			x = hVar.SCREEN.w/2,
			y = -48 + _nSCREENoffy,
			align = "MC",
			size = 32,
		})

		_CODE_CreateChooseUI()
		_CODE_CreatePetManagerUI()

		_frm:show(1)
		_frm:active()
	end

	_CODE_GetPetData = function()
		local petid = LuaGetHeroPetId(hVar.MY_TANK_ID)
		if petid ~= 0 then
			local index = LuaGetHeroPetIdx(hVar.MY_TANK_ID)
			local petLv = LuaGetHeroPetLv(hVar.MY_TANK_ID, index)
			_tPetMain = {petid,petLv}
		end
	end

	_CODE_ChangePet = function()
		if _bHaveChange then
			local oWorld = hGlobal.WORLD.LastWorldMap
			if oWorld then
				local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
				local oHero = oPlayerMe.heros[1]
				--print(oHero)
				if oHero then
					local oUnit = oHero:getunit()
					--print(oUnit)
					if oUnit then
						local randPosX, randPosY = hApi.chaGetPos(oUnit.handle)
						local petPosX = randPosX + oWorld:random(-50, 50) --随机x位置
						local petPosY = randPosY + oWorld:random(-50, 50) --随机y位置
						petPosX, petPosY = hApi.Scene_GetSpace(petPosX, petPosY, 50)
						
						--之前有宠物
						if (oWorld.data.follow_pet_unit ~= 0) then
							petPosX, petPosY = hApi.chaGetPos(oWorld.data.follow_pet_unit.handle)
							
							oWorld.data.rpgunits[oWorld.data.follow_pet_unit] = nil
							oWorld.data.follow_pet_unit:del()
						end

						local tPet = hVar.tab_unit[hVar.MY_TANK_ID].pet_unit
						if tPet then
							if type(_tPetMain) == "table" then
								local id = _tPetMain[1]
								local petLv = _tPetMain[2]

								local petIdx = LuaGetHeroPetIndexById(hVar.MY_TANK_ID,id)
								local petId = tPet[petIdx].summonUnit
								--print("petId=", petId)
								local petSide = 1 --蜀国
								if (oWorld.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.TANKCONFIG) then --配置坦克地图
									petSide = 23
								end
								local oPetUnit = oWorld:addunit(petId, petSide, nil ,nil, angle, petPosX, petPosY, nil, nil, petLv, 1)
								
								oWorld.data.rpgunits[oPetUnit] = oPetUnit:getworldC() --标记是我方单位
								oWorld.data.follow_pet_unit = oPetUnit

								-- 用于测试宠物跟随任务：同时生成多个宠物
								--[[
								local count = hVar.TEST_PET_COUNT
								for i=1,count do
									local pet = oWorld:addunit(petId, petSide, nil ,nil, angle, petPosX, petPosY, nil, nil, petLv, 1)
									oWorld.data.rpgunits[pet] = pet:getworldC()
								end
								--]]
							end
						end
						for i = 1,#_tPetUnitManager do
							local u = _tPetUnitManager[i]
							if u then
								oWorld.data.rpgunits[u] = nil
								u:del()
							end
						end
						_tPetUnitManager = {}
						for i = 1,#_tPetManagerList do
							local petId,petLv = unpack(_tPetManagerList[i])
							local facing = hVar.UNIT_DEFAULT_FACING --角色的朝向
							local unitForce = oUnit:getowner():getpos()
							local randPosX, randPosY = hApi.chaGetPos(oUnit.handle)
							local petPosX = randPosX + oWorld:random(-100, 100) --随机x位置
							local petPosY = randPosY + oWorld:random(-100, 100) --随机y位置
							petPosX, petPosY = hApi.Scene_GetSpace(petPosX, petPosY, 50)
							local cha = oWorld:addunit(petId, unitForce, nil, nil, facing, petPosX, petPosY, nil, nil, petLv, 1)
							
							if cha then
								cha.data.is_summon = 1
								hGlobal.event:call("Event_UnitBorn", cha)
			
			
								--是否为rpgunits
								if (cha:getowner():getforce() == hVar.FORCE_DEF.SHU) then
									if (cha.data.type ~= hVar.UNIT_TYPE.NOT_USED) and (cha.data.type ~= hVar.UNIT_TYPE.SCEOBJ) then
										oWorld.data.rpgunits[cha] = cha:getworldC() --标记是我方单位
									end
								end
								_tPetUnitManager[#_tPetUnitManager+1] = cha
							end
						end
					end
				end
			end
		end
	end

	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","PetcheatManger",function(sSceneType,oWorld,oMap)
		if g_editor == 1 then
			return
		end
		if oWorld then
			_tPetManagerList = {}
			_tPetMain = 0
			if oWorld.data.map == hVar.MainBase then
			else
				if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then
					_CODE_GetPetData()
				end
			end
		end
	end)

	hGlobal.event:listen("LocalEvent_refreshbeforeSpinScreen","PetCheatManagerFrm",function()
		if _frm then
			_CODE_ClearFunc()
			_CODE_GetUIParam()
			_CODE_CreateFrm()
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_CODE_ClearFunc()
		if g_editor == 1 then
			return
		end
		if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then
			_CODE_GetUIParam()
			_CODE_CreateFrm()
		end
	end)
end

hGlobal.UI.InitTacticsCheatManagerFrm = function()
	local tInitEventName = {"LocalEvent_ShowTacticsCheatManagerFrm", "_show",}
	if (mode ~= "include") then
		--return tInitEventName
	end

	local _nChooseTacticsStartX = hVar.SCREEN.offx + 20
	local _nChooseTacticsStartY = - 100
	local _nChooseTacticsBgW = hVar.SCREEN.w - hVar.SCREEN.offx * 2 - 40
	local _nChooseTacticsBgH = 230
	local _nChooseTacticsWH = 100
	--local _nChooseTacticsH = 100
	local _nLevelUIStartX = 0
	local _nLevelUIStartY = 0
	local _nNumUIStartX = 0
	local _nNumUIStartY = 0
	local _nPageUIStartX = 0
	local _nCurListStartX = 0
	local _nCurListStartY = 0

	local _frmoffx = 0
	local _frmoffy = 0

	local _tNumList = {1,5,10,20,-1}

	local _frm,_parent,_childUI = nil,nil,nil 
	local _tShowList = nil
	local _tItemIDwithUnitList = nil
	local _tChooseUI = {}
	local _tMyTacticsList = {}
	local _nChooseLv = 0
	local _nChooseNumIndex = 0
	local _nChooseCow = 0
	local _nChooseLine = 2
	local _nChoosePage = 0
	local _nMyTacticsLine = 2
	local _nMyTacticsCow = 10
	local _nMyTacticsPage = 0

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_GetUIParam = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_GetTacticsData = hApi.DoNothing
	local _CODE_CreateChooseUI = hApi.DoNothing
	local _CODE_CreateCHoose = hApi.DoNothing
	local _CODE_ClearChooseUI = hApi.DoNothing
	local _CODE_RefreshLevelBtn = hApi.DoNothing
	local _CODE_CreateLevelBtn = hApi.DoNothing
	local _CODE_RefreshNumBtn = hApi.DoNothing
	local _CODE_CreateNumBtn = hApi.DoNothing
	local _CODE_CreateMyListUI = hApi.DoNothing
	local _CODE_ChangeChoosePage = hApi.DoNothing
	local _CODE_ChangeListPage = hApi.DoNothing
	local _CODE_RefreshMyTactics = hApi.DoNothing

	local _CODE_ChooseTactics = hApi.DoNothing
	local _CODE_RemoveTactics = hApi.DoNothing
	local _CODE_SetPlayerTactics = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.TacticsCheatManagerFrm then
			hGlobal.UI.TacticsCheatManagerFrm:del()
			hGlobal.UI.TacticsCheatManagerFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_tChooseUI = {}
		_nChooseLv = 0
		_nChooseNumIndex = 0
		_nChooseCow = 0
		_nChoosePage = 0
		_nMyTacticsPage = 0
	end

	_CODE_ClearChooseUI = function()
		for i = 1,#_tChooseUI do
			hApi.safeRemoveT(_childUI,_tChooseUI[i])
		end
		_tChooseUI = {}
	end

	_CODE_GetUIParam = function()
		_frmoffx = hVar.SCREEN.offx
		_frmoffy = 0
		_nChooseTacticsStartX = _frmoffx + 20
		_nChooseTacticsStartY = - 100
		_nChooseTacticsBgW = hVar.SCREEN.w - _frmoffx * 2 - 40
		_nChooseTacticsBgH = 230
		_nChooseTacticsWH = 100
		_nChooseLine = 2
		_nMyTacticsLine = 2
		_nMyTacticsCow = 10

		_nLevelUIStartX = _frmoffx + 30
		_nLevelUIStartY = - 130 - _nChooseTacticsBgH
		_nNumUIStartX = _frmoffx + 420
		_nNumUIStartY = - 130 - _nChooseTacticsBgH
		_nPageUIStartX = hVar.SCREEN.w - _frmoffx - 160

		_nCurListStartX = _frmoffx
		_nCurListStartY = - 200 - _nChooseTacticsBgH

		if hVar.SCREEN_MODE ~= hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
			_frmoffx = 0
			_frmoffy = - hVar.SCREEN.offx

			_nChooseTacticsStartX = 20
			_nChooseTacticsStartY = - 100 + _frmoffy
			_nChooseTacticsBgW = hVar.SCREEN.w - 40
			_nChooseTacticsBgH = 230
			_nMyTacticsLine = 5
			_nMyTacticsCow = 4

			_nLevelUIStartX = 30
			_nLevelUIStartY = - 130 - _nChooseTacticsBgH + _frmoffy
			_nNumUIStartX = 30
			_nNumUIStartY = - 180 - _nChooseTacticsBgH + _frmoffy
			_nPageUIStartX = hVar.SCREEN.w - 160

			_nCurListStartX = 0
			_nCurListStartY = - 260 - _nChooseTacticsBgH + _frmoffy

			
		end
	end

	_CODE_CreateChooseUI = function()
		_childUI["img_choosetacticsbg"] = hUI.button:new({
			parent = _parent,
			--model = "misc/mask.png",
			model = "misc/button_null.png",
			x = _nChooseTacticsStartX + _nChooseTacticsBgW/2,
			y = _nChooseTacticsStartY - _nChooseTacticsBgH/2,
			w = _nChooseTacticsBgW,
			h = _nChooseTacticsBgH,
		})
		hApi.CCScale9SpriteCreate("data/image/misc/billboard/kuang5.png", 0, 0, _nChooseTacticsBgW,_nChooseTacticsBgH, _childUI["img_choosetacticsbg"])

		_childUI["lab_level"] = hUI.label:new({
			parent = _parent,
			text = "LEVEL",
			x = _nLevelUIStartX,
			y = _nLevelUIStartY,
			align = "LC",
			size = 26,
		})

		_childUI["lab_num"] = hUI.label:new({
			parent = _parent,
			text = "NUM",
			x = _nNumUIStartX,
			y = _nNumUIStartY,
			align = "LC",
			size = 26,
		})

		_childUI["lab_page"] = hUI.label:new({
			parent = _parent,
			x = _nPageUIStartX,
			y = _nLevelUIStartY,
			align = "MC",
			size = 26,
		}) 

		_childUI["btn_pagepro"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/change_arrow.png",
			dragbox = _childUI["dragBox"],
			x = _nPageUIStartX - 120,
			y = _nLevelUIStartY - 2,
			scale = 0.3,
			scaleT = 0.9,
			code = function()
				_CODE_ChangeChoosePage(_nChoosePage-1)
			end,
		})

		_childUI["btn_pagenext"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/change_arrow.png",
			dragbox = _childUI["dragBox"],
			x = _nPageUIStartX + 120,
			y = _nLevelUIStartY - 2,
			scale = 0.3,
			scaleT = 0.9,
			code = function()
				_CODE_ChangeChoosePage(_nChoosePage+1)
			end,
		})
		_childUI["btn_pagenext"].handle.s:setRotation(180)

		_CODE_ChangeChoosePage(1)
		_CODE_CreateLevelBtn()
		_CODE_CreateNumBtn()
	end

	_CODE_RefreshLevelBtn = function()
		local lvmax = 5
		for i = 1,lvmax do
			if _childUI["btn_level"..i] then
				if _nChooseLv == i then
					hApi.AddShader(_childUI["btn_level"..i].handle.s, "normal")
				else
					hApi.AddShader(_childUI["btn_level"..i].handle.s, "gray")
				end
			end
		end
	end

	_CODE_CreateLevelBtn = function()
		local lvmax = 5
		local btnWH = 40
		for i = 1,lvmax do
			_childUI["btn_level"..i] = hUI.button:new({
				parent = _parent,
				model = "misc/billboard/kuang5.png",
				dragbox = _childUI["dragBox"],
				label = {text = i,z = 1,y = 2,},
				x = hVar.SCREEN.offx + 150 + (i-1)*50,
				y = - 132 - _nChooseTacticsBgH,
				w = btnWH,
				h = btnWH,
				code = function()
					if i == _nChooseLv then
						_nChooseLv = 0
					else
						_nChooseLv = i
					end
					_CODE_RefreshLevelBtn()
				end,
			})
		end
		_CODE_RefreshLevelBtn()
	end

	_CODE_RefreshNumBtn = function()
		local lvmax = 5
		for i = 1,#_tNumList do
			if _childUI["btn_num"..i] then
				if _nChooseNumIndex == i then
					hApi.AddShader(_childUI["btn_num"..i].handle.s, "normal")
				else
					hApi.AddShader(_childUI["btn_num"..i].handle.s, "gray")
				end
			end
		end
	end
	
	_CODE_CreateNumBtn = function()
		local btnWH = 40
		for i = 1,#_tNumList do
			local num = _tNumList[i]
			local text = tostring(num)
			if num == -1 then
				text = "∞"
			end
			_childUI["btn_num"..i] = hUI.button:new({
				parent = _parent,
				model = "misc/billboard/kuang5.png",
				dragbox = _childUI["dragBox"],
				label = {text = text,z = 1,y = 2,},
				x = _nNumUIStartX + 120 + (i-1)*50,
				y = _nNumUIStartY,
				w = btnWH,
				h = btnWH,
				code = function()
					if i == _nChooseNumIndex then
						_nChooseNumIndex = 0
					else
						_nChooseNumIndex = i
					end
					_CODE_RefreshNumBtn()
				end,
			})
		end
		_CODE_RefreshNumBtn()
	end

	_CODE_ChangeChoosePage = function(npage)
		_nChooseCow = math.floor(_nChooseTacticsBgW/_nChooseTacticsWH) - 1
		--print(#tList,_nChooseCow)
		local maxPage = math.ceil(#_tShowList/(_nChooseCow*_nChooseLine))
		if npage>=1 and npage<= maxPage and _nChoosePage ~= npage then
			_nChoosePage = npage
			--刷新所有选择项
			_CODE_ClearChooseUI()

			_CODE_CreateCHoose()

			--刷新页数
			_childUI["lab_page"]:setText("page "..tostring(_nChoosePage).." / "..maxPage)
			--刷新按钮状态
			if  _nChoosePage == 1 then
				_childUI["btn_pagepro"]:setstate(-1)
			else
				_childUI["btn_pagepro"]:setstate(1)
			end
			if _nChoosePage == maxPage then
				_childUI["btn_pagenext"]:setstate(-1)
			else
				_childUI["btn_pagenext"]:setstate(1)
			end
		end	
	end

	_CODE_CreateCHoose = function()
		local maxshow = _nChooseLine * _nChooseCow
		local offw = math.floor((_nChooseTacticsBgW - _nChooseTacticsWH * _nChooseCow)/(_nChooseCow + 1))
		local offh = math.floor((_nChooseTacticsBgH - _nChooseTacticsWH * _nChooseLine)/(_nChooseLine + 1))
		for i = 1,_nChooseLine do
			for j = 1,_nChooseCow do
				local index = (i-1)*_nChooseCow + j + maxshow * (_nChoosePage - 1)
				if _tShowList[index] then
					local id,tacticsid = unpack(_tShowList[index])

					_childUI["ChooseTactics"..index] = hUI.button:new({
						parent = _parent,
						dragbox = _childUI["dragBox"],
						--model = "misc/mask.png",
						model = "misc/button_null.png",
						x = _nChooseTacticsStartX + (_nChooseTacticsWH + offw) * (j-1) + _nChooseTacticsWH/2 + offw,
						y = _nChooseTacticsStartY - (_nChooseTacticsWH + offh) * (i-1) - _nChooseTacticsWH/2 - offh,
						w = _nChooseTacticsWH,
						h = _nChooseTacticsWH,
						code = function()
							print("index",index)
							--_CODE_ClickChoose(index)
							_CODE_ChooseTactics(id)
						end
					})
					_tChooseUI[#_tChooseUI+1] = "ChooseTactics"..index

					_childUI["ChooseTactics"..index].childUI["tactics"] = hUI.thumbImage:new({
						parent = _childUI["ChooseTactics"..index].handle._n,
						x = 0,
						y = 8,
						id = id,
						facing = 270,
					})

					_childUI["ChooseTactics"..index].childUI["lab"] = hUI.label:new({
						parent = _childUI["ChooseTactics"..index].handle._n,
						text = id,
						align = "MC",
						size = 24,
						y = - 34,
					})
				end
			end
		end
	end

	_CODE_CreateMyListUI = function()
		_childUI["lab_curlist"] = hUI.label:new({
			parent = _parent,
			x = _nCurListStartX + 24,
			y = _nCurListStartY,
			align = "LC",
			size = 26,
			text = "当前战术卡",
		})

		_childUI["lab_listpage"] = hUI.label:new({
			parent = _parent,
			x = _nCurListStartX + 260,
			y = _nCurListStartY,
			align = "MC",
			size = 26,
		}) 

		_childUI["btn_listPro"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/addition/cg.png",
			label = {text = "上一页",size = 24,border = 1,font = hVar.FONTC,y = 2,height= 32,},
			x = _nCurListStartX + 90,
			y = _nCurListStartY - 70,
			scale = 0.6,
			scaleT = 0.95,
			code = function()
				_CODE_ChangeListPage(_nMyTacticsPage - 1)
			end,
		})

		_childUI["btn_listNext"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/addition/cg.png",
			label = {text = "下一页",size = 24,border = 1,font = hVar.FONTC,y = 2,height= 32,},
			x = _nCurListStartX + 90,
			y = _nCurListStartY - 150,
			scale = 0.6,
			scaleT = 0.95,
			code = function()
				_CODE_ChangeListPage(_nMyTacticsPage + 1)
			end,
		})

		_childUI["btn_clear"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/addition/cg.png",
			label = {text = "清空",size = 24,border = 1,font = hVar.FONTC,y = 2,height= 32,},
			x = _nCurListStartX + 90,
			y = _nCurListStartY - 230,
			scale = 0.6,
			scaleT = 0.95,
			code = function()
				_tMyTacticsList = {}
				_CODE_ChangeListPage(1,1)
			end,
		})

		local offw = (hVar.SCREEN.w - _frmoffx * 2 - 200 - _nChooseTacticsWH * _nMyTacticsCow) / (_nMyTacticsCow + 1)
		local offh = 20
		for i = 1,_nMyTacticsLine do
			for j = 1,_nMyTacticsCow do
				local index = (i-1) * _nMyTacticsCow + j
				_childUI["btn_mytactics"..index] = hUI.button:new({
					parent = _parent,
					dragbox = _childUI["dragBox"],
					model = "misc/button_null.png",
					x = _frmoffx + 180 + offw + _nChooseTacticsWH/2 + (j-1) * (_nChooseTacticsWH + offw),
					y = _nCurListStartY - 90 - (i-1)* (_nChooseTacticsWH + offh),
					w = _nChooseTacticsWH,
					h = (_nChooseTacticsWH + 10),
					code = function()
						print("index",index)
						_CODE_RemoveTactics(index)
					end
				})
				
				hApi.CCScale9SpriteCreate("data/image/misc/billboard/kuang5.png", 0, 0, _nChooseTacticsWH,(_nChooseTacticsWH + 10), _childUI["btn_mytactics"..index])
			end
		end

		_CODE_ChangeListPage(1)
	end

	_CODE_ChangeListPage = function(page,mustfresh)
		print("_CODE_ChangeListPage")
		local nummax = _nMyTacticsLine * _nMyTacticsCow
		local maxPage = math.max(1,math.ceil(#_tMyTacticsList/nummax))

		print(page,nummax,maxPage)

		if (page and page >= 1 and page <= maxPage) or (mustfresh == 1) then
			_nMyTacticsPage = page
			--
			_CODE_RefreshMyTactics()
		end

		--刷新页数
		_childUI["lab_listpage"]:setText("page "..tostring(_nMyTacticsPage).." / "..maxPage)
	end

	_CODE_RefreshMyTactics = function()
		local nummax = _nMyTacticsLine * _nMyTacticsCow
		for i = 1,_nMyTacticsLine do
			for j = 1,_nMyTacticsCow do
				local index = (i-1) * _nMyTacticsCow + j

				if _childUI["btn_mytactics"..index] then
					hApi.safeRemoveT(_childUI["btn_mytactics"..index].childUI,"infonode")
				end

				local realI = nummax * (_nMyTacticsPage - 1) + index

				if _tMyTacticsList[realI] then
					local id,lv,num = unpack(_tMyTacticsList[realI])

					_childUI["btn_mytactics"..index].childUI["infonode"] = hUI.button:new({
						parent = _childUI["btn_mytactics"..index].handle._n,
						model = "misc/button_null.png",
						--model = "misc/mask.png",
						w = 1,
						h = 1,
					})

					local nodeChild = _childUI["btn_mytactics"..index].childUI["infonode"].childUI
					local nodeParent = _childUI["btn_mytactics"..index].childUI["infonode"].handle._n

					nodeChild["img_tactics"] = hUI.thumbImage:new({
						parent = nodeParent,
						x = 0,
						y = 6,
						id = id,
						facing = 270,
					})

					nodeChild["lab_tacticinfo"] = hUI.label:new({
						parent = nodeParent,
						text = tostring(id).."_lv"..tostring(lv),
						align = "MC",
						size = 22,
						y = - 36,
					})

					local textnum = ""
					if num == -1 then
						textnum = "∞"
					else
						textnum = tostring(num)
					end

					nodeChild["lab_tacticnum"] = hUI.label:new({
						parent = nodeParent,
						text = textnum,
						align = "MC",
						size = 22,
						x = 40,
						y = 0,
						RGB = {255,0,0},
					})
				end
			end
		end
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.TacticsCheatManagerFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = "UI:zhezhao",
			dragable = 0,
			show = 0,
			z = 20001,
		})

		_frm = hGlobal.UI.TacticsCheatManagerFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/back.png",
			x = 54 + _frmoffx,
			y = -54 + _frmoffy,
			code = function()
				hGlobal.event:event("LocalEvent_ResetCloseCount")
				_CODE_SetPlayerTactics()
				_CODE_ClearFunc()
			end,
		})

		_childUI["lab_titlemap"] = hUI.label:new({
			parent = _parent,
			text = "战术卡管理界面",
			x = hVar.SCREEN.w/2,
			y = -48 + _frmoffy,
			align = "MC",
			size = 32,
		})

		_childUI["line1"] = hUI.image:new({
			parent = _parent,
			model = "ui/title_line.png",
			x = hVar.SCREEN.w/2,
			y = _nNumUIStartY - 40 + _frmoffy,
			w = hVar.SCREEN.w,
			h = 6,
		})

		_CODE_CreateChooseUI()
		_CODE_CreateMyListUI()

		_frm:show(1)
		_frm:active()
	end

	_CODE_GetTacticsData = function()
		if _tShowList == nil or _tItemIDwithUnitList == nil then
			_tShowList = {}
			_tItemIDwithUnitList = {}
			for unitid,itemid in pairs(hVar.UnitToTacticsItemList) do
				_tShowList[#_tShowList+1] = {unitid,itemid}
				_tItemIDwithUnitList[itemid] = unitid
			end
			table.sort(_tShowList,function(t1,t2)
				return t1[1] < t2[1]
			end)
		end
		--table_print(_tShowList)
		_tMyTacticsList = {}
		local oWorld = hGlobal.WORLD.LastWorldMap
		if oWorld then
			local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
			for j = 1, #oPlayerMe.heros, 1 do
				local oHero = oPlayerMe.heros[j]
				if oHero then
					local itemSkillT = oHero.data.itemSkillT
					for z = 1,#itemSkillT do
						local id = itemSkillT[z].activeItemId
						local lv = itemSkillT[z].activeItemLv
						local num = itemSkillT[z].activeItemNum or 1
						--print(oHero.data.id,id,lv)

						local unitid = _tItemIDwithUnitList[id]
						if unitid then
							_tMyTacticsList[#_tMyTacticsList+1] = {unitid,lv,num}
						end
					end
				end
			end
		end
	end

	_CODE_RemoveTactics = function(index)
		local nummax = _nMyTacticsLine * _nMyTacticsCow
		local realI = nummax * (_nMyTacticsPage - 1) + index
		if _tMyTacticsList[realI] then
			table.remove(_tMyTacticsList,realI)

			_CODE_ChangeListPage(_nMyTacticsPage,1)
		end
	end

	_CODE_ChooseTactics = function(id)
		local addnum = 1
		if _nChooseNumIndex ~= 0 then
			addnum = _tNumList[_nChooseNumIndex] or 1
		end
		local tacticslv = _nChooseLv
		if _nChooseLv == 0 then
			_nChooseLv = 1
			local tacticId = hVar.UnitToTacticsItemList[id]
			local tacticInfo = LuaGetPlayerTacticById(tacticId)
			if tacticInfo then
				local _,lv = unpack(tacticInfo)
				if type(lv) == "number" and lv > 0 then
					_nChooseLv = lv
				end
			end
		end
		--for i = 1,addnum do
		local tacticsIndex = 0
		for i = 1,#_tMyTacticsList do
			local nid,nlv,num = unpack(_tMyTacticsList[i])
			if nid == id then
				tacticsIndex = i
				break
			end
		end
		if tacticsIndex == 0 then
			_tMyTacticsList[#_tMyTacticsList + 1] = {id,tacticslv,addnum}
		else
			_tMyTacticsList[tacticsIndex][2] = tacticslv
			if _tMyTacticsList[tacticsIndex][3] ~= -1 and addnum ~= -1 then
				_tMyTacticsList[tacticsIndex][3] = _tMyTacticsList[tacticsIndex][3] + addnum
			else
				_tMyTacticsList[tacticsIndex][3] = -1
			end
		end
		_CODE_ChangeListPage(_nMyTacticsPage,1)
	end

	_CODE_SetPlayerTactics = function()
		local tItemList = {}
		for i = 1,#_tMyTacticsList do
			local id,lv,num = unpack(_tMyTacticsList[i])
			local itemid = hVar.UnitToTacticsItemList[id]
			if itemid then
				tItemList[#tItemList + 1] = {itemid,lv,num}
			end
		end
		hGlobal.event:event("Event_SetNewTacticsActiveSkill",tItemList)
	end

	hGlobal.event:listen("LocalEvent_SpinScreen","TacticsCheatManagerFrm",function()
		if _frm and _frm.data.show == 1 then
			_CODE_ClearFunc()
			if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then
				_CODE_GetTacticsData()
				_CODE_GetUIParam()
				_CODE_CreateFrm()
			end
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_CODE_ClearFunc()
		if g_editor == 1 then
			return
		end
		if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then
			_CODE_GetTacticsData()
			_CODE_GetUIParam()
			_CODE_CreateFrm()
		end
	end)
end

hGlobal.UI.InitCheatEquipFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowCheatEquipFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _nChooseStartX = hVar.SCREEN.offx + 20
	local _nChooseStartY = - 100
	local _nChooseBgW = hVar.SCREEN.w - hVar.SCREEN.offx * 2 - 360
	local _nChooseBgH = hVar.SCREEN.h - 200
	local _nEquipInfoX = 0
	local _nBtnOffY = 0
	local _nLevelOffY = 0
	local _nShowCow = 4
	local _nShowLine = 4
	local _nIconWH = 82
	local _nItemGridWH = hVar.EquipWH
	local _nDefaultQuality = 10

	local _frm, _childUI,_parent = nil,nil,nil
	local _nCurPage = 1
	local _nMaxPage = 0
	local _nChooseLv = 0
	local _tEquipList = {}
	local _tShowList = {}
	local _nEquipQuality = _nDefaultQuality
	local _nEquipId = 0

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateUI = hApi.DoNothing
	local _CODE_CreateChooseUI = hApi.DoNothing
	local _CODE_CreateLevelBtn = hApi.DoNothing
	local _CODE_CreateEquipUI = hApi.DoNothing
	local _CODE_CreateEquip = hApi.DoNothing
	local _CODE_CreateEquipInfo = hApi.DoNothing

	local _CODE_UpdateEquipUI = hApi.DoNothing

	local _CODE_ClickEquip = hApi.DoNothing
	local _CODE_ChangePage = hApi.DoNothing

	local _CODE_GetSelectBorderParam = hApi.DoNothing
	local _CODE_GetEquipData = hApi.DoNothing

	local _CODE_ClickGetEquip = hApi.DoNothing
	local _CODE_ClickGMGetEquip = hApi.DoNothing

	local _CODE_RefreshLevelBtn = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.CheatEquipFrm then
			hGlobal.UI.CheatEquipFrm:del()
			hGlobal.UI.CheatEquipFrm = nil
		end
		_frm, _childUI,_parent = nil,nil,nil
		_tEquipList = {}
		_tShowList = {}
		_nCurPage = 1
		_nMaxPage = 0
		_nChooseLv = 0
		_nEquipQuality = _nDefaultQuality
		_nEquipId = 0
	end

	_CODE_GetSelectBorderParam = function()
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
			_nChooseBgW = math.min((hVar.SCREEN.w - 360 - 40),1040)
			_nChooseBgH = hVar.SCREEN.h - 200
			local offw = math.max(0,(hVar.SCREEN.w - _nChooseBgW - 40 - 360)/3)
			_nChooseStartX = hVar.SCREEN.offx + 20 + offw
			_nChooseStartY = - 100
			_nEquipInfoX = hVar.SCREEN.w - 360 + 20 - offw
			_nBtnOffY = 0
			_nLevelOffY = 0


			_nShowCow = math.floor((_nChooseBgW - 120)/_nIconWH) - 2
			_nShowLine = math.floor(_nChooseBgH/_nIconWH) - 2
		else
			_nChooseBgW = hVar.SCREEN.w - 360
			_nChooseBgH = hVar.SCREEN.h - 300 - hVar.SCREEN.offx * 2
			_nChooseStartX = 20
			_nChooseStartY = - 100 + hVar.SCREEN.offx
			_nEquipInfoX = hVar.SCREEN.w - 360 + 20
			_nBtnOffY = 200
			_nLevelOffY = -80

			_nShowCow = math.floor(_nChooseBgW/_nIconWH) - 1
			_nShowLine = math.floor((_nChooseBgH - 120)/_nIconWH) - 2
		end
	end

	_CODE_GetEquipData = function()
		_tEquipList = {}
		local temp = {}
		for itemid,tabI in pairs(hVar.tab_item) do
			--type = hVar.ITEM_TYPE.MOUNT,
			if tabI.type >= hVar.ITEM_TYPE.BODY and tabI.type <= hVar.ITEM_TYPE.MOUNT and itemid >= 20000 then
				temp[#temp+1] = {itemid,tabI.type,tabI.itemLv or hVar.ITEM_QUALITY.WHITE}
			end
		end
		table.sort(temp,function(t1,t2)
			if t1[2] == t2[2] then
				if t1[3] == t2[3] then
					return t1[1] < t2[1]
				else
					return t1[3] < t2[3]
				end
			else
				return t1[2] < t2[2]
			end
		end)
		_tEquipList = temp
		--table_print(_tEquipList)
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.CheatEquipFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = "UI:zhezhao",
			dragable = 0,
			show = 0,
			z = 20001,
		})
		_frm = hGlobal.UI.CheatEquipFrm
		_childUI = _frm.childUI
		_parent = _frm.handle._n

		_CODE_CreateUI()
		_CODE_CreateChooseUI()
		_CODE_CreateEquipUI()
		_CODE_CreateLevelBtn()

		_CODE_UpdateEquipUI()

		_frm:show(1)
		_frm:active()
	end

	_CODE_CreateUI = function()
		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/back.png",
			x = 54 + hVar.SCREEN.offx,
			y = -54,
			code = function()
				_CODE_ClearFunc()
			end,
		})

		_childUI["lab_title"] = hUI.label:new({
			parent = _parent,
			text = "获取装备界面",
			x = hVar.SCREEN.w/2,
			y = -48,
			align = "MC",
			size = 32,
		})

		_childUI["node_equipinfo"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			x = _nEquipInfoX,
			y = _nChooseStartY,
			w = 1,
			h = 1,
		})

--		_childUI["btn_getequip"] = hUI.button:new({
--			parent = _parent,
--			dragbox = _childUI["dragBox"],
--			model = "misc/chest/itembtn.png",
--			label = {text = "Get",font = hVar.FONTC,size = 24,align = "MC",y = 4,},
--			scaleT = 0.95,
--			x = _nEquipInfoX + 160 - 80,
--			y = - hVar.SCREEN.h + 50 + _nBtnOffY,
--			w = 120,
--			h = 70,
--			code = function()
--				_CODE_ClickGetEquip()
--			end,
--		})

		_childUI["btn_GMgetequip"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/chest/itembtn.png",
			label = {text = "GM Get",font = hVar.FONTC,size = 24,align = "MC",y = 4,},
			scaleT = 0.95,
			x = _nEquipInfoX + 160,
			y = - hVar.SCREEN.h + 50 + _nBtnOffY,
			w = 120,
			h = 70,
			code = function()
				_CODE_ClickGMGetEquip()
			end,
		})
	end

	_CODE_CreateChooseUI = function()
		_childUI["img_choosetacticsbg"] = hUI.button:new({
			parent = _parent,
			--model = "misc/mask.png",
			model = "misc/button_null.png",
			x = _nChooseStartX + _nChooseBgW/2,
			y = _nChooseStartY - _nChooseBgH/2,
			w = _nChooseBgW,
			h = _nChooseBgH,
		})
		hApi.CCScale9SpriteCreate("data/image/misc/billboard/kuang5.png", 0, 0, _nChooseBgW,_nChooseBgH, _childUI["img_choosetacticsbg"])

		_childUI["lab_page"] = hUI.label:new({
			parent = _parent,
			x = _nChooseStartX + _nChooseBgW - 120,
			y = _nChooseStartY - _nChooseBgH - 46,
			align = "MC",
			size = 26,
			--text = "1/1",
		}) 

		_childUI["btn_pagepro"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/change_arrow.png",
			dragbox = _childUI["dragBox"],
			x = _nChooseStartX + _nChooseBgW - 210,
			y = _nChooseStartY - _nChooseBgH - 48,
			scale = 0.3,
			scaleT = 0.9,
			code = function()
				_CODE_ChangePage(_nCurPage-1)
			end,
		})

		_childUI["btn_pagenext"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/change_arrow.png",
			dragbox = _childUI["dragBox"],
			x = _nChooseStartX + _nChooseBgW - 30,
			y = _nChooseStartY - _nChooseBgH - 48,
			scale = 0.3,
			scaleT = 0.9,
			code = function()
				_CODE_ChangePage(_nCurPage+1)
			end,
		})
		_childUI["btn_pagenext"].handle.s:setRotation(180)
	end

	_CODE_CreateLevelBtn = function()
		_childUI["lab_level"] = hUI.label:new({
			parent = _parent,
			text = "LEVEL",
			x = hVar.SCREEN.offx + 30,
			y = _nChooseStartY - _nChooseBgH - 46 + _nLevelOffY,
			align = "LC",
			size = 26,
		}) 

		local lvlist = {}
		lvlist[1] = 0
		local lvmax = hVar.ITEM_QUALITY.MAX
		for i = lvmax,1,-1 do
			lvlist[#lvlist+1] = i
		end
		local btnWH = 50
		for i = 1,#lvlist do
			local idx = lvlist[i]
			local showtxt = idx
			if idx == 0 then
				showtxt = "all"
			end
			_childUI["btn_level"..idx] = hUI.button:new({
				parent = _parent,
				model = "misc/billboard/kuang5.png",
				dragbox = _childUI["dragBox"],
				label = {text = showtxt,z = 1,y = 2,},
				x = hVar.SCREEN.offx + 150 + (i-1) * 60,
				y = _nChooseStartY - _nChooseBgH - 46 + _nLevelOffY,
				w = btnWH,
				h = btnWH,
				scaleT =  0.95,
				code = function()
					if idx == _nChooseLv then
						return
					else
						_nChooseLv = idx
						_nCurPage = 1
					end
					_CODE_RefreshLevelBtn()
					_CODE_UpdateEquipUI()
				end,
			})
		end
		_CODE_RefreshLevelBtn()
	end

	_CODE_ChangePage = function(page)
		if page > 0 and page <=_nMaxPage and page ~= _nCurPage then
			_nCurPage = page
			_CODE_UpdateEquipUI()
		end
	end

	_CODE_CreateEquipUI = function()
		local offw = math.floor((_nChooseBgW - _nIconWH * _nShowCow)/(_nShowCow + 1))
		local offh = math.floor((_nChooseBgH - _nIconWH * _nShowLine)/(_nShowLine + 1))
		for i = 1,_nShowLine do
			for j = 1,_nShowCow do
				local idx = (i-1) * _nShowCow + j
				_childUI["btn_EquipNode"..idx] = hUI.button:new({
					parent = _parent,
					model = "misc/button_null.png",
					dragbox = _childUI["dragBox"],
					w = _nIconWH,
					h = _nIconWH,
					x = _nChooseStartX + offw * j + _nIconWH * (j - 0.5),
					y = _nChooseStartY - offh * i - _nIconWH * (i - 0.5),
					code = function()
						print("idx",idx)
						_CODE_ClickEquip(idx)
					end,
				})
			end
		end
	end

	_CODE_CreateEquip = function(node,equipinfo)
		hApi.safeRemoveT(node.childUI,"node")
		if type(equipinfo) == "table" then
			node.childUI["node"] = hUI.button:new({
				parent = node.handle._n,
				model = "misc/button_null.png",
			})

			local nodeChild = node.childUI["node"].childUI
			local nodeParent = node.childUI["node"].handle._n
			local bgWH = 100
			local itemID = equipinfo[1]
			local tabI = hVar.tab_item[itemID] or {}
			
			nodeChild["bg"] = hUI.image:new({
				parent = nodeParent,
				model = "misc/chariotconfig/itemgrid2.png",
			})

			nodeChild["icon"] = hUI.image:new({
				parent = nodeParent,
				model = tabI.icon,
				w = _nItemGridWH,
				h = _nItemGridWH,
			})

			nodeChild["id"] = hUI.label:new({
				parent = nodeParent,
				text = tostring(itemID),
				x = 0,
				y = -28,
				align = "MC",
				size = 18,
				font = "numRed",
			})
		end
	end

	_CODE_CreateEquipInfo = function(equipinfo)
		if type(equipinfo) == "table" then
			hApi.safeRemoveT(_childUI["node_equipinfo"].childUI,"node")
			local itemID = equipinfo[1]
			local oEquip = {itemID, 1, nil, 0,"", 0, 0, 1,{{hVar.ITEM_FROMWHAT_TYPE.NET,0,0,0}},0,0,0,
					0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,}
			hGlobal.event:event("localEvent_ShowItemTipFrm", oEquip)
			local tabI = hVar.tab_item[itemID] or {}
			local level = tabI.itemLv
			local backmodel = hVar.ITEMLEVEL[level].BACKMODEL

			_nEquipQuality = _nDefaultQuality
			_nEquipId = itemID

			_childUI["node_equipinfo"].childUI["node"] = hUI.button:new({
				parent = _childUI["node_equipinfo"].handle._n,
				model = "misc/button_null.png",
				w = 1,
				h = 1,
			})
			local nodeChild = _childUI["node_equipinfo"].childUI["node"].childUI
			local nodeParent = _childUI["node_equipinfo"].childUI["node"].handle._n
			nodeChild["equipbg"] = hUI.image:new({
				parent = nodeParent,
				model = "misc/chariotconfig/itemgrid2.png",
				x = 50,
				y = -50,
			})

			nodeChild["img_itembg"] = hUI.image:new({
				parent = nodeParent,
				model = backmodel,
				x = 50,
				y = -50,
			})

			nodeChild["equipicon"] = hUI.image:new({
				parent = nodeParent,
				model = tabI.icon,
				x = 50,
				y = -50,
				w = _nItemGridWH,
				h = _nItemGridWH,
			})

			local itemname = LuaGetObjectName(itemID,2)
			local iteminfo = hVar.ITEMLEVEL[level]
			nodeChild["equipname"] = hUI.label:new({
				parent = nodeParent,
				align = "MC",
				font = hVar.FONTC,
				x = 320/2 + 40,
				y = - 44,
				text =  itemname,
				RGB = iteminfo.NAMERGB,
				size = 28,
			})

			local countH = 0
			local strI = hVar.tab_stringI[itemID] -- or {"","测试一下回不回换行且效果如何\n第三行效果"}
			if type(strI) == "table" and type(strI[2]) == "string" and string.len(strI[2]) > 2 then
				--countH = countH + 24
				nodeChild["lab_describe"] = hUI.label:new({
					parent = nodeParent,
					x = 10,
					y = - 110,
					size = 24,
					font = hVar.FONTC,
					align = "LT",
					text = strI[2],
					RGB = {135, 206, 235,},
					width = 310,
				})
				
				local _,lh = nodeChild["lab_describe"]:getWH()
				countH = countH + lh + 30
			end

			nodeChild["lab_quality"] = hUI.label:new({
				parent = nodeParent,
				x = 10,
				y = - 120 - countH,
				size = 24,
				font = hVar.FONTC,
				align = "LC",
				text = hVar.tab_string["__TEXT_Quality"], --"品质"
				RGB = {255, 255, 0,},
			})
			
			nodeChild["lab_quality_value"] = hUI.label:new({
				parent = nodeParent,
				x = 140,
				y = - 120 - countH,
				size = 24,
				font = hVar.FONTC,
				align = "LC",
				text = _nEquipQuality,
				RGB = {255, 255, 0,},
			})

			nodeChild["valuebar_quality"] = hUI.valbar:new({
				parent = nodeParent,
				model = "UI:IMG_S1_ValueBar",
				back = {model = "misc/mask_white.png", x= - 1, y= - 1, w= 282, h=18},
				x = 10,
				y = -160 - countH,
				w = 280,
				h = 16,
				align = "LC",
			})
			nodeChild["valuebar_quality"]:setV(_nEquipQuality, _nDefaultQuality)

			_childUI["btn_quality"] = hUI.button:new({
				parent = _parent,
				model = "misc/button_null.png",
				dragbox = _childUI["dragBox"],
				x = _childUI["node_equipinfo"].data.x + 10 + 140,
				y = _childUI["node_equipinfo"].data.y - 160 - countH,
				w = 280,
				h = 24,
				code = function()
				end,
				codeOnDrag = function(self,x,y,sus)
					if sus == 1 then
						local btnx = self.data.x
						local btnw = self.data.w
						local realx = x - btnx +btnw/2
						--print(realx)
						local quality
						local offW = btnw/_nDefaultQuality
						if realx < offW * 1.5 then
							quality = 1
						elseif realx > btnw - offW * 0.5 then
							quality = 10
						else
							local p1 = math.floor(realx/offW)
							local p2 = math.mod(realx,offW)
							--print("p1 p2",p1,p2,realx)
							if p2 > offW/2 then
								quality = p1 + 1
							else
								quality = p1
							end
						end
						if quality ~= _nEquipQuality then
							_nEquipQuality = quality
							nodeChild["lab_quality_value"]:setText(_nEquipQuality)
							nodeChild["valuebar_quality"]:setV(_nEquipQuality, _nDefaultQuality)
							_CODE_ShowEquipAttr(nodeChild["attrnode"],tabI)
						end
						--print("quality",quality)
					end
				end,
			})

			nodeChild["attrnode"] = hUI.button:new({
				parent = nodeParent,
				model = "misc/button_null.png",
				x = 10,
				y = -210 - countH,
				w = 1,
				h = 1,
			})

			_CODE_ShowEquipAttr(nodeChild["attrnode"],tabI)
		end
	end

	_CODE_ShowEquipAttr = function(node,tabI)
		hApi.safeRemoveT(node.childUI,"node")
		node.childUI["node"] = hUI.button:new({
			parent = node.handle._n,
			model = "misc/button_null.png",
			w = 1,
			h = 1,
		})
		local nodeChild = node.childUI["node"].childUI
		local nodeParent = node.childUI["node"].handle._n
		local attr = {}
		if tabI.reward then
			for i = 1,#tabI.reward do
				local key,strExpress = unpack(tabI.reward[i])
				local lv = 1
				--print(id,strExpress,quality)
				local value = hApi.AnalyzeValueExpr(nil, nil, {["@lv"] = lv,["@quality"] = _nEquipQuality,}, strExpress, 0)
				attr[i] = {hVar.tab_string[hVar.ItemRewardStr[key]],value, key}
			end
		end
		
		local countH = 0
		if #attr > 0 then
			for i =1,#attr do
				if i == 11 then
					nodeChild["lab_attr"..i] = hUI.label:new({
						parent = nodeParent,
						x = 0,
						y = - countH,
						size = 24,
						font = hVar.FONTC,
						align = "LC",
						text = "剩余"..(#attr-10).."条",
					})
					break
				else
					local v1,v2, key = unpack(attr[i])
					v2 = tonumber(v2)
					
					if (hVar.ItemRewardMillinSecondMode[key] == 1) then
						v2 = v2 / 1000
					end
					
					nodeChild["lab_attr"..i] = hUI.label:new({
						parent = nodeParent,
						x = 0,
						y = - countH,
						size = 24,
						font = hVar.FONTC,
						align = "LC",
						text = v1,
					})

					local valuatext = ""
					if v2 > 0 then
						valuatext = "+ " .. v2
					else
						valuatext = "- " .. math.abs(v2)
					end
					
					if (hVar.ItemRewardStrMode[key] == 1) then
						valuatext = valuatext .. " %"
					end
					
					nodeChild["lab_value"..i] = hUI.label:new({
						parent = nodeParent,
						x = 140,
						y = - countH,
						size = 24,
						font = hVar.FONTC,
						align = "LC",
						text = valuatext,
					})

					countH = countH + 30
				end
			end
		end
	end

	_CODE_ClickEquip = function(i)
		local maxnum = _nShowLine * _nShowCow
		local realIdX = (_nCurPage - 1) * maxnum + i
		local equipidx = _tShowList[realIdX] or nil
		_CODE_CreateEquipInfo(_tEquipList[equipidx])
	end

	_CODE_RefreshLevelBtn = function()
		local lvmax = hVar.ITEM_QUALITY.MAX
		for i = 0,lvmax do
			if _nChooseLv == i then
				hApi.AddShader(_childUI["btn_level"..i].handle.s, "normal")
			else
				hApi.AddShader(_childUI["btn_level"..i].handle.s, "gray")
			end
			
		end
	end

	_CODE_UpdateEquipUI = function()
		_tShowList = {}
		for i = 1,#_tEquipList do
			if _nChooseLv == 0 then
				_tShowList[#_tShowList + 1] = i
			else
				local lv = (_tEquipList[i] or {})[3] or 1
				if _nChooseLv == lv then
					_tShowList[#_tShowList + 1] = i
				end
			end
		end
		local maxnum = _nShowLine * _nShowCow
		for i = 1,maxnum do
			local realIdX = (_nCurPage - 1) * maxnum + i
			local equipidx = _tShowList[realIdX] or nil
			_CODE_CreateEquip(_childUI["btn_EquipNode"..i],_tEquipList[equipidx])
		end
		if #_tShowList < maxnum then
			_childUI["btn_pagepro"]:setstate(-1)
			_childUI["btn_pagenext"]:setstate(-1)
		else
			_childUI["btn_pagepro"]:setstate(1)
			_childUI["btn_pagenext"]:setstate(1)
		end
		_nMaxPage = math.ceil(math.max(#_tShowList-1,0)/maxnum)
		_childUI["lab_page"]:setText(_nCurPage.."/".._nMaxPage)
	end

	_CODE_ClickGetEquip = function()
		local strText = "获取失败"
		if _nEquipId ~= 0 then
			if (LuaCheckPlayerBagCanUse() ~= 0) then
				local itemId = _nEquipId
				local quality = _nEquipQuality
				local entity = {}
				local UniqueId = -9999
				entity.dbid = UniqueId
				entity.typeId = itemId
				entity.slotnum = 0
				entity.attr = {}
				local _,_,oItem = LuaAddItemToPlayerBag(itemId,nil,nil,nil,entity,quality)
				if oItem then
					--统一塞到仓库里
					LuaGainNewEquip(oItem)
					strText = "获取成功"
				end
			end
		end
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

	_CODE_ClickGMGetEquip = function()
		if _nEquipId ~= 0 then
			if (LuaCheckPlayerBagCanUse() ~= 0) then
				--GM作弊加装备
				local itemId= _nEquipId
				local quality = _nEquipQuality
				SendCmdFunc["gm_operation_add_resource"](10, itemId, 0, quality)
			end
		end
		
	end

	hGlobal.event:listen("LocalEvent_refreshafterSpinScreen","CheatEquipFrm",function()
		if _frm then
			_CODE_ClearFunc()
			_CODE_GetSelectBorderParam()
			_CODE_GetEquipData()
			_CODE_CreateFrm()
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_CODE_ClearFunc()
		_CODE_GetSelectBorderParam()
		_CODE_GetEquipData()
		_CODE_CreateFrm()
	end)
end