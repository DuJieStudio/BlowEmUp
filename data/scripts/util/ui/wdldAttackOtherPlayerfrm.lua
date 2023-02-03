--其实现在是我的领地里按game start后的面板 懒得svn上改名字
hGlobal.UI.InitWdldAttackOtherPlayerFrm_WDLD = function(sInitMode)
	if sInitMode=="init" then
		return hVar.RESULT_FAIL
	end
	hGlobal.UI.WdldAttackOtherPlayerFrm = hUI.frame:new({
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

	local _frm = hGlobal.UI.WdldAttackOtherPlayerFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	_frm:showBorder(1)

	local atkHeroIdUI = {}
	local atkHero = {}
	wdld_attackT = {}--出征数据中转
	wdld_attackHT = {}
	local cH = 0--参战英雄数量
	local tH = hVar.WDLD_AtkHeroNum--可参战英雄数量
	local tHeroB = {}--全部英雄
	local cHeroB = {}--选择英雄
	for i = 1,tH do
		cHeroB[i] = 0
	end

	_childUI["btnClose"] = hUI.button:new({
		parent = _frm,
		model = "BTN:PANEL_CLOSE",
		x = 490,
		y = -10,
		scaleT = 0.9,
		code = function(self)
			hGlobal.event:event("LocalEvent_ShowWdldAttackOtherPlayerFrame",0)
		end,
	})

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

	--frm title
	_childUI["frm_title"] = hUI.label:new({
		parent = _parent,
		size = 30,
		align = "MC",
		font = hVar.FONTC,
		x = _frm.data.w/2,
		y = -20,
		width = 300,
		text = "playerInfo:",
		RGB = {213,173,65},
	})

	--玩家名字
	_childUI["playNameTitle"] = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 30,
		y = -60,
		width = 300,
		text = "playerName:",
		RGB = {213,173,65},
	})

	_childUI["playName"] = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 200,
		y = -60,
		width = 300,
		text = "",
	})

	--玩家Lv
	_childUI["playLvTitle"] = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 30,
		y = -100,
		width = 300,
		text = "playerLv:",
		RGB = {213,173,65},
	})

	_childUI["playLv"] = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 200,
		y = -100,
		width = 300,
		text = "",
	})

	_childUI["playExpTitle"] = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 30,
		y = -140,
		width = 300,
		text = "playerExp:",
		RGB = {213,173,65},
	})
	_childUI["playExp"] = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 200,
		y = -140,
		width = 300,
		text = "",
	})

	--玩家资源
	_childUI["playResTitle"] = hUI.label:new({
		parent = _parent,
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
	local _ResX,_ResY,_ResOffX,_ResOffY = 145,-200,65,80
	for i = 1,6 do
		_childUI["resNode_"..i] = hUI.node:new({
			parent = _parent,
			x = _ResX + (i-1)% 6 * _ResOffX,
			y = _ResY - math.ceil((i-6)/6)*_ResOffY,
		})
		
		--资源图片
		_childUI["resNode_"..i].childUI["ResImage"] = hUI.image:new({
			parent = _childUI["resNode_"..i].handle._n,
			model = hVar.RESOURCE_ART[i].icon,
			w = 50,
		})

		--资源lab
		_childUI["resNode_"..i].childUI["ResLab"] = hUI.label:new({
			parent = _childUI["resNode_"..i].handle._n,
			size = 14,
			align = "MC",
			font = "numWhite",
			y = -30,
			width = 300,
			text = "",
		})
	end


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
		size = 36,
	})

	_childUI["attack"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:BTN_ButtonRed",
		label = hVar.tab_string["wdld_attack"],
		font = hVar.FONTC,
		scaleT = 0.9,
		x = 250,
		y = -570,
		code = function(self)
			local str = ""
			for i = 1,#cHeroB do
				if cHeroB[i] ~= 0 then
					str = str..cHeroB[i]..";"
				end
			end
			Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleBegin,luaGetplayerDataID(),lookPlayer.roleid,str})
		end
	})
	local choseHero = nil

	hGlobal.event:listen("LocalEvent_ShowWdldAttackOtherPlayerFrame","Griffin_showWdldAttackOtherPlayerFrm",function(isShow,heroNum)
		_frm:show(isShow)
		tipFrm:show(isShow)
		tH = heroNum or 0
		if isShow == 1 then
			_childUI["attack"]:setstate(0)
			cH = 0
			_childUI["heroCount"]:setText(hVar.tab_string["wdld_choseHeros"].." "..cH.."/"..tH)
			for i = 1,tH do
				cHeroB[i] = 0
			end
			_frm:active()
			tipFrm:active()
			local index = 0
			for i = 1,#atkHeroIdUI do
				hApi.safeRemoveT(tipFrm.childUI,"hh"..atkHeroIdUI[i])
				hApi.safeRemoveT(tipFrm.childUI,"hr"..atkHeroIdUI[i])
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
			atkHeroIdUI = {}
			local sH = {}
			hClass.hero:enum(function(eh)
				if eh.data.IsDefeated ~= 1 then
					if eh:getunit("worldmap").data.IsHide == 0 then--没有隐藏表示没守城守资源
						local hid = eh.data.id
						sH[#sH + 1] = hid
						index = index + 1
						
						tipFrm.childUI["hr"..hid] = hUI.image:new({
							parent = _tparent,
							model = "UI:finish",
							x = 85,
							y =  -(index - 1) * 80 - 67,
							w = 20,
							h = 20,
						})
						tipFrm.childUI["hr"..hid].handle._n:setVisible(false)

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
							for i = 1,7 do
								tipFrm.childUI["hh"..hid.."bg"..i] = hUI.image:new({
									parent = _tfrm.handle._n,
									model = "UI_frm:slot",
									animation = "lightSlim",
									x = 120 + (i - 1)*55,
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
											x = 120 + (i - 1)*55,
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
												x = 130 + (i - 1)*55,
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

	hGlobal.event:listen("LocalEvent_WdldAttackOtherFrameSetPlayerInfo","Griffin_WdldAttackOtherFrameSetPlayerInfo",function(info)
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

		_childUI["playName"]:setText(tostring(rolename))
		_childUI["playLv"]:setText(tostring(lv))
		_childUI["playExp"]:setText(tostring(exp))

		for i = 1,6 do
			_childUI["resNode_"..i].childUI["ResLab"]:setText(tostring(ResTab[i]))
		end

		g_WDLD_OtherLv = lv
	end)

	hGlobal.event:listen("LocalEvent_BattleBeginOk","Griffin_showWdldAttackOtherPlayerFrm",function()
		WDLD_NEED_ADD_MY_TEAM_TAG = 1
		wdld_attackT = {}
		wdld_attackHT = {}
		hClass.hero:enum(function(eh)
			if eh:getunit("worldmap").data.IsHide == 0 then
				local has = 0
				for i = 1,#cHeroB do
					if cHeroB[i] == eh.data.id then
						has = 1
						break
					end
				end
				if has == 1 then
					wdld_attackHT[#wdld_attackHT + 1] = eh.data.id
					wdld_attackT[#wdld_attackT + 1] = {}
						
					local u = eh:getunit()
					hApi.ReadParamWithDepth(u.data.team,nil,wdld_attackT[#wdld_attackT],3)
					for key = 1,#wdld_attackT[#wdld_attackT] do
						if type(wdld_attackT[#wdld_attackT][key]) == "table" then
							if wdld_attackT[#wdld_attackT][key][1] == eh.data.id then
								wdld_attackT[#wdld_attackT][key][1] = 0
								wdld_attackT[#wdld_attackT][key][2] = 0
								break
							end
						end
					end
				end
			end
		end)
		WdldRoleId = lookPlayer.roleid
		Game_Zone_OnGameEvent(GZone_Event_TypeDef.Load,luaGetplayerDataID(),lookPlayer.roleid,g_ReadyCitySave,xlSetSavePath("online")..lookPlayer.roleid..hVar.SAVE_DATA_PATH.MY_CITY)
		WDLD_NEED_CHANGE_OWNER_TAG = 1
		--WDLD_NEED_HIDE_SYS_MENU = 1
		hGlobal.event:event("LocalEvent_ShowPlayerRankFrame",0)
		hGlobal.event:event("LocalEvent_ShowWdldAttackOtherPlayerFrame",0)
	end)
end