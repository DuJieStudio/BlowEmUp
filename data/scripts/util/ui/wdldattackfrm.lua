--其实现在是我的领地里按game start后的面板 懒得svn上改名字
hGlobal.UI.InitWdldAttackFrm_WDLD = function(sInitMode)
	if sInitMode=="init" then
		return hVar.RESULT_FAIL
	end
	hGlobal.UI.WdldAttackFrm = hUI.frame:new({
		x = 262,
		y = 684,
		--z = -1,
		dragable = 2,
		w = 500,
		h = 600,
		--z = -1,
		show = 0,
		autoactive = 0,
		--background = "UI:TileFrmBack",
	})

	local _frm = hGlobal.UI.WdldAttackFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	local cH = 0--参战英雄数量
	local tH = 0--可参战英雄数量
	local tHeroB = {}--全部英雄
	local cHeroB = {}--选择英雄
	local cMapCount = 0 --可选地图数量
	local heros = nil
	local canChoseMapName = nil
	_frm:showBorder(1)

	_childUI["btnClose"] = hUI.button:new({
		parent = _frm,
		model = "BTN:PANEL_CLOSE",
		x = 490,
		y = -10,
		scaleT = 0.9,
		code = function(self)
			hGlobal.event:event("LocalEvent_ShowWdldAttackFrame",0)
		end,
	})

	_childUI["choseMap"]= hUI.label:new({
		parent = _parent,
		x = 165,
		y = -10,
		w = 100,
		h = 80,
		width = 420,
		text = hVar.tab_string["wdld_choseMap"],
		font = hVar.FONTC,
		size = 28,
	})

	--分界线
	_childUI["apartline_back_w"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = 250,
		y = -250,
		w = 528,
		h = 8,
	})

	_childUI["heroCount"]= hUI.label:new({
		parent = _parent,
		x = 125,
		y = -255,
		w = 100,
		h = 80,
		width = 420,
		text = hVar.tab_string["wdld_choseHeros"].." "..cH.."/"..tH,
		font = hVar.FONTC,
		size = 28,
	})

	_childUI["attack"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:BTN_ButtonRed",
		label = hVar.tab_string["wdld_begin"],
		font = hVar.FONTC,
		scaleT = 0.9,
		x = 250,
		y = -550,
		code = function(self)
			--WDLD_NEED_ADD_MY_TEAM_TAG = 1
			--wdld_attackT = {}
			--wdld_attackHT = {}
			--for i = 1,#cHeroB do
				--for j = 1,#heros do
					--if cHeroB[i] == heros[j].id then
						--wdld_attackHT[#wdld_attackHT + 1] = heros[j].id
						--wdld_attackT[#wdld_attackT + 1] = {}
						--local u = heros[j]:getunit("worldmap")
						--hApi.ReadParamWithDepth(u.team,nil,wdld_attackT[#wdld_attackT],3)
						--for key = 1,#wdld_attackT[#wdld_attackT] do
							--if wdld_attackT[#wdld_attackT][key][1] == heros[j].id then
								--wdld_attackT[#wdld_attackT][key][1] = 0
								--wdld_attackT[#wdld_attackT][key][2] = 0
								--break
							--end
						--end
						--break
					--end
				--end
			--end
			--WdldRoleId = lookPlayer.roleid
			--Game_Zone_OnGameEvent(GZone_Event_TypeDef.Load,luaGetplayerDataID(),lookPlayer.roleid,g_ReadyCitySave,xlSetSavePath("online")..lookPlayer.roleid..hVar.SAVE_DATA_PATH.MY_CITY)
			--WDLD_NEED_CHANGE_OWNER_TAG = 1
			----WDLD_NEED_HIDE_SYS_MENU = 1
			--hGlobal.event:event("LocalEvent_ShowPlayerRankFrame",0)
			--hGlobal.event:event("LocalEvent_ShowWdldAttackFrame",0)
	
			hVar.WDLD_Heros = {}
			for i = 1,#cHeroB do
				if cHeroB[i] ~= 0 then
					hVar.WDLD_Heros[#hVar.WDLD_Heros + 1] = cHeroB[i]
				end
			end

			hGlobal.event:event("LocalEvent_ShowWdldAttackFrame",0)
			Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.WDLDRestart,luaGetplayerDataID(),g_WDLD_RESTART_MAP_NAME})
		end,
	})
	_childUI["attack"]:setstate(0)

	local choseMap = nil

	local mapFrm = nil
	local mtfx,mtfy,mtfw,mtfh = 290,640,1500,210
	local mcpx,mcpy,mcpw,mcph = 290,640,450,210
	mapFrm = hUI.frame:new({
		x = mtfx,
		y = mtfy,
		dragable = {mcpw-mtfw,0,mtfw-mcpw,0},
		autoalign = {"H",{95,-48,150,70},10,0,0},
		w = mtfw,
		h = mtfh,
		clipper = {mcpx,mcpy,mcpw,mcph},
		show = 0,
		autoactive = 0,
		background = -1,--"UI:tip_item",
		codeOnDragEx = function(touchX,touchY,touchMode)
			--print(touchX,touchY,touchMode)
		end
	})
	local _mfrm = mapFrm
	local _mparent = _mfrm.handle._n


	hGlobal.event:listen("LocalEvent_ShowWdldAttackFrame","Griffin_showWdldAttackFrm",function(isShow,heroNum)
		_frm:show(isShow)
		mapFrm:show(isShow)
		tH = heroNum or 0
		if isShow == 1 then
			_frm:active()
			mapFrm:active()
			_childUI["attack"]:setstate(0)
			for i = 1,cMapCount do
				hApi.safeRemoveT(mapFrm.childUI,"cm"..i)
				hApi.safeRemoveT(mapFrm.childUI,"cm"..i.."L")
				hApi.safeRemoveT(mapFrm.childUI,"cm"..i.."R")
			end
			canChoseMapName = nil
			local mapList = g_Game_Zone.ZoneTemplate[WDLD_Init_Data.LV].maplist
			canChoseMapName = hApi.Split(mapList,";")
			canChoseMapName[#canChoseMapName + 1] = "level_fb01"
			canChoseMapName[#canChoseMapName + 1] = "level_fb02"
			canChoseMapName[#canChoseMapName + 1] = "level_fb03"
			cMapCount = #canChoseMapName
			for i = 1,#canChoseMapName do
				sn = math.floor((i - 1)/9) + 1--在第几页
				local snindex = i - (sn - 1)*9--在当前页中的哪一个
				if mapFrm.childUI["cm"..i] == nil then
					mapFrm.childUI["cm"..i] = hUI.button:new({
						parent = _mfrm,
						model = "level_territory",
						x = (sn - 1)*mcpw + ((snindex - 1) % 3 ) * 150 + 80,
						y =  -math.floor((snindex - 1)/3) * 70 - 20,
						scaleT = 0.9,
						w = 80,
						h = 80,
						code = function(self)
							choseMap(i)
						end,
					})
				end
				if mapFrm.childUI["cm"..i.."L"] == nil then
					mapFrm.childUI["cm"..i.."L"]= hUI.label:new({
						parent = _mparent,
						x = (sn - 1)*mcpw + ((snindex - 1) % 3 ) * 150 + 40,
						y = -math.floor((snindex - 1)/3) * 70 - 48,
						w = 100,
						h = 80,
						width = 420,
						text = hVar.tab_stringM["world/"..canChoseMapName[i]][1],
						font = hVar.FONTC,
						size = 18,
					})
				end
				if mapFrm.childUI["cm"..i.."R"] == nil then
					mapFrm.childUI["cm"..i.."R"] = hUI.image:new({
						parent = _mparent,
						model = "UI:finish",
						x = (sn - 1)*mcpw + ((snindex - 1) % 3 ) * 150 + 100,
						y =  -math.floor((snindex - 1)/3) * 70 - 40,
						w = 24,
						h = 24,
					})
					mapFrm.childUI["cm"..i.."R"].handle._n:setVisible(false)
				end
			end
			mapFrm:setXY(mtfx,mtfy,0,{-20-(sn-1)*mcpw,0,(sn-1)*mcpw+40,0})--重设滑动范围


			local oldMapIndex = 1
			for i = 1,#canChoseMapName do
				if canChoseMapName[i] == g_WDLD_RESTART_MAP_NAME then
					oldMapIndex = i
					break
				end
			end
			choseMap(oldMapIndex)
			for i = 1,#tHeroB do
				hApi.safeRemoveT(_childUI,"hh"..tHeroB[i].id)
				hApi.safeRemoveT(_childUI,"hh"..tHeroB[i].id.."R")
			end
			tHeroB = nil
			tHeroB = {}
			cHeroB = {}
			cH = 0
			_childUI["heroCount"]:setText(hVar.tab_string["wdld_choseHeros"].." "..cH.."/"..tH)
			heros = Save_PlayerData.herocard
			for i = 1,#heros do
				if _childUI["hh"..heros[i].id] == nil then
					_childUI["hh"..heros[i].id] = hUI.button:new({
						parent = _frm,
						model = hVar.tab_unit[heros[i].id].icon,
						x = ((i - 1) % 8 ) * 56 + 50,
						y =  -math.floor((i - 1)/8) * 56 - 320,
						scaleT = 0.9,
						w = 48,
						h = 48,
						code = function(self)
							_childUI["attack"]:setstate(0)
							local index = 0
							for j = 1,#cHeroB do
								if cHeroB[j] == heros[i].id then
									index = i
									break
								end
							end
							if index == 0 then
								if cH < tH then
									cH = cH + 1
									cHeroB[#cHeroB + 1] = heros[i].id
									_childUI["hh"..heros[i].id.."R"].handle._n:setVisible(true)
								end
							else
								cH = cH - 1
								for j = 1,#cHeroB do
									if cHeroB[j] == heros[i].id then
										cHeroB[j] = 0
									end
								end
								_childUI["hh"..heros[i].id.."R"].handle._n:setVisible(false)
							end
							_childUI["heroCount"]:setText(hVar.tab_string["wdld_choseHeros"].." "..cH.."/"..tH)
							if cH <= tH and cH > 0 then --进入我的领地英雄数量不能超限制
								_childUI["attack"]:setstate(1)
							end
						end,
					})
					tHeroB[#tHeroB + 1] = heros[i]

					_childUI["hh"..heros[i].id.."R"] = hUI.image:new({
						parent = _parent,
						model = "UI:finish",
						x = ((i - 1) % 8 ) * 56 + 72,
						y =  -math.floor((i - 1)/8) * 56 - 342,
						w = 16,
						h = 16,
					})
					_childUI["hh"..heros[i].id.."R"].handle._n:setVisible(false)
				end
			end
		end
	end)

	choseMap = function(index)
		for i = 1,#canChoseMapName do
			if mapFrm.childUI["cm"..i.."R"] then
				mapFrm.childUI["cm"..i.."R"].handle._n:setVisible(false)
			end
		end
		mapFrm.childUI["cm"..index.."R"].handle._n:setVisible(true)
		g_WDLD_RESTART_MAP_NAME = canChoseMapName[index]
		for i = 1,#cHeroB do
			if cHeroB[i] ~= 0 then
				_childUI["hh"..cHeroB[i].."R"].handle._n:setVisible(false)
			end
		end
		cHeroB = {}
		cH = 0
		tH = hVar.WDLD_HeroNum[g_WDLD_RESTART_MAP_NAME]
		_childUI["heroCount"]:setText(hVar.tab_string["wdld_choseHeros"].." "..cH.."/"..tH)
	end
end