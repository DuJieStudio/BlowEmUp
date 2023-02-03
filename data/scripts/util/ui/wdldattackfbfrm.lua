--其实现在是我的领地里按game start后的面板 懒得svn上改名字
--hGlobal.UI.include("InitWdldAttackFBFrm")
hGlobal.UI.InitWdldAttackFBFrm_WDLD = function(sInitMode)
	if sInitMode=="init" then
		return hVar.RESULT_FAIL
	end
	local touchBaseFrm = nil
	hGlobal.UI.WdldAttackFBFrm = hUI.frame:new({
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
		--codeOnTouch = function(self,touchX,touchY)
			----touchBaseFrm(touchX,touchY)
		--end,
	})

	local _frm = hGlobal.UI.WdldAttackFBFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	local cH = 0--参战英雄数量
	local tH = hVar.WDLD_AtkHeroNum--可参战英雄数量
	local tHeroB = {}--全部英雄
	local cHeroB = {}--选择英雄
	local cMapCount = 0 --可选地图数量
	local atkHeroIdUI = {}
	for i = 1,tH do
		cHeroB[i] = 0
	end
	local heros = nil
	local canChoseMapName = nil
	_frm:showBorder(1)

	local tipFrm = nil--带裁剪的frm
	local tfx,tfy,tfw,tfh = 262,400,500,1000
	local cpx,cpy,cpw,cph = 262,400,500,240
	tipFrm = hUI.frame:new({
		x = tfx,
		y = tfy,
		dragable = {0,tfh-cph,0,tfh-cph},
		w = tfw,
		h = tfh,
		clipper = { cpx,cpy,cpw,cph},
		show = 0,
		autoactive = 0,
		autoalign = {"V",{0,-40,150,80},40,0,-10},
		background = -1,
		codeOnDragEx = function(touchX,touchY,touchMode)
			--print(touchX,touchY,touchMode)
		end
	})
	local _tfrm = tipFrm
	local _tparent = _tfrm.handle._n

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

	_childUI["btnClose"] = hUI.button:new({
		parent = _frm,
		model = "BTN:PANEL_CLOSE",
		x = 490,
		y = -10,
		scaleT = 0.9,
		code = function(self)
			hGlobal.event:event("LocalEvent_ShowWdldAttackFBFrame",0)
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
			hVar.WDLD_Heros = {}
			for i = 1,#cHeroB do
				if cHeroB[i] ~= 0 then
					hVar.WDLD_Heros[#hVar.WDLD_Heros + 1] = cHeroB[i]
				end
			end

			hGlobal.event:event("LocalEvent_ShowWdldAttackFBFrame",0)
			Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.WDLDRestart,luaGetplayerDataID(),g_WDLD_RESTART_MAP_NAME})
		end,
	})
	_childUI["attack"]:setstate(0)

	local choseMap = nil
	local choseHero = nil

	hGlobal.event:listen("LocalEvent_ShowWdldAttackFBFrame","Griffin_showWdldAttackFrm",function(isShow,heroNum)
		_frm:show(isShow)
		tipFrm:show(isShow)
		mapFrm:show(isShow)
		tH = heroNum or 0
		if isShow == 1 then
			_frm:active()
			mapFrm:active()
			tipFrm:active()
			_childUI["attack"]:setstate(0)
			for i = 1,cMapCount do
				hApi.safeRemoveT(mapFrm.childUI,"cm"..i)
				hApi.safeRemoveT(mapFrm.childUI,"cm"..i.."L")
				hApi.safeRemoveT(mapFrm.childUI,"cm"..i.."R")
			end
			canChoseMapName = nil
			local mapList = g_Game_Zone.ZoneTemplate[WDLD_Init_Data.LV].maplist
			mapList = "level_fb01"
			canChoseMapName = hApi.Split(mapList,";")
			cMapCount = #canChoseMapName
			local sn = 0
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
				hApi.safeRemoveT(tipFrm.childUI,"hh"..tHeroB[i].id)
				hApi.safeRemoveT(tipFrm.childUI,"hr"..tHeroB[i].id)
				for j = 1,7 do
					hApi.safeRemoveT(tipFrm.childUI,"hh"..atkHeroIdUI[i].."bg"..j)
					if tipFrm.childUI["hh"..atkHeroIdUI[i].."icon"..j] ~= nil then
						hApi.safeRemoveT(tipFrm.childUI,"hh"..atkHeroIdUI[i].."icon"..j)
					end
					if tipFrm.childUI["hh"..atkHeroIdUI[i].."num"..j] ~= nil then
						hApi.safeRemoveT(tipFrm.childUI,"hh"..atkHeroIdUI[i].."num"..j)
					end
				end
			end
			tHeroB = nil
			tHeroB = {}
			cHeroB = {}
			cH = 0
			for i = 1,tH do
				cHeroB[i] = 0
			end
			_childUI["heroCount"]:setText(hVar.tab_string["wdld_choseHeros"].." "..cH.."/"..tH)
			atkHeroIdUI = {}
			local index = 0
			local sH = {}
			hClass.hero:enum(function(eh)
				if eh.data.IsDefeated ~= 1 then
					if eh:getunit("worldmap").data.IsHide == 0 then--没有隐藏表示没守城守资源
						local hid = eh.data.id
						sH[#sH + 1] = hid
						index = index + 1
						
						if tipFrm.childUI["hh"..hid] == nil then
							tipFrm.childUI["hh"..hid] = hUI.button:new({
								parent = _tfrm,
								model = hVar.tab_unit[hid].icon,
								x = 50,
								y = -(index - 1) * 80 - 32,
								scaleT = 0.9,
								w = 64,
								h = 64,
								code = function(self)
									choseHero(hid)
								end,
							})
							atkHeroIdUI[#atkHeroIdUI + 1] = hid

							tipFrm.childUI["hr"..hid] = hUI.image:new({
								parent = _tparent,
								model = "UI:finish",
								x = 85,
								y =  -(index - 1) * 80 - 67,
								w = 20,
								h = 20,
								z = 101,
							})
							tipFrm.childUI["hr"..hid].handle._n:setVisible(false)

							for i = 1,7 do
								tipFrm.childUI["hh"..hid.."bg"..i] = hUI.image:new({
									parent = _tfrm.handle._n,
									model = "UI_frm:slot",
									animation = "lightSlim",
									x = 110 + (i - 1)*55,
									y = -(index - 1) * 80 - 39,
									w = 50,
									h = 50,
								})
								if eh:getunit().data.team ~= nil and eh:getunit().data.team ~= 0 and eh:getunit().data.team[i] ~= 0 then
									if eh:getunit().data.team[i][2] ~= nil and eh:getunit().data.team[i][2] ~= 0 then
										tipFrm.childUI["hh"..hid.."icon"..i] = hUI.image:new({
											parent = _tfrm.handle._n,
											model = hVar.tab_unit[eh:getunit().data.team[i][1]].model,
											animation = "lightSlim",
											x = 110 + (i - 1)*55,
											y = -(index - 1) * 80 - 59,
											w = 50,
											h = 50,
										})
										if eh:getunit().data.team[i][2] ~= 1 then
											tipFrm.childUI["hh"..hid.."num"..i] = hUI.label:new({
												parent = _tfrm.handle._n,
												size = 8,
												align = "LT",
												font = "numWhite",
												x = 120 + (i - 1)*55,
												y = -(index - 1) * 80 - 52,
												width = 100,
												text = eh:getunit().data.team[i][2],
											})
										end
									end
								end
							end
						end

					end
				end

			end)
			local tsnh = (index-3) * 80
			tipFrm:setXY(tfx,tfy,0,{0,tsnh+5,0,tsnh+10})--重设滑动范围
			if index <= hVar.WDLD_AtkHeroNum then
				for i = 1,hVar.WDLD_AtkHeroNum do
					choseHero(sH[i])
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
				tipFrm.childUI["hr"..cHeroB[i]].handle._n:setVisible(false)
			end
		end
		cHeroB = {}
		for i = 1,tH do
			cHeroB[i] = 0
		end
		cH = 0
		tH = hVar.WDLD_HeroNum[g_WDLD_RESTART_MAP_NAME] or 1--临时副本进1人
		_childUI["heroCount"]:setText(hVar.tab_string["wdld_choseHeros"].." "..cH.."/"..tH)
	end

	choseHero = function(hid)
		if hid == nil or type(hid) ~= "number" then
			return
		end
		local fn = 0
		for iii = 1,#cHeroB do
			if cHeroB[iii] == hid then
				fn = iii
				break
			end
		end
		if fn >= 1 and fn <= #cHeroB then
			cHeroB[fn] = 0
			tipFrm.childUI["hr"..hid].handle._n:setVisible(false)
			cH = cH - 1
		else
			if cH < #cHeroB then
				cH = cH + 1
				for bb = 1,#cHeroB do
					if cHeroB[bb] == 0 then
						cHeroB[bb] = hid
						break
					end
				end
				tipFrm.childUI["hr"..hid].handle._n:setVisible(true)
			end
		end
								
		_childUI["heroCount"]:setText(hVar.tab_string["wdld_choseHeros"].." "..cH.."/"..tH)
		if cH >= 1 then
			_childUI["attack"]:setstate(1)
		else
			_childUI["attack"]:setstate(0)
		end
	end
end