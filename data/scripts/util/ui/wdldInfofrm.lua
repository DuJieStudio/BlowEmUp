hGlobal.UI.InitWdldInfoFrm_WDLD = function(sInitMode)
	if sInitMode=="init" then
		return hVar.RESULT_FAIL
	end
	hGlobal.UI.WdldInfoFrm = hUI.frame:new({
		x = 12,
		y = 684,
		--z = -1,
		dragable = 2,
		w = 1000,
		h = 600,
		--z = -1,
		show = 0,
		autoactive = 0,
		--background = "UI:TileFrmBack",
	})

	local _frm = hGlobal.UI.WdldInfoFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	local nextLVExp = 0
	--_frm:showBorder(1)

	local logNum = 9

	_childUI["btnClose"] = hUI.button:new({
		parent = _frm,
		model = "BTN:PANEL_CLOSE",
		x = 990,
		y = -10,
		scaleT = 0.9,
		code = function(self)
			hGlobal.event:event("LocalEvent_ShowWDLDInfoFrm",0)
		end,
	})

	_childUI["wdld_info"] = hUI.label:new({
		parent = _parent,
		size = 34,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 250,
		y = -30,
		width = 450,
		text = hVar.tab_string["wdld_info"],
	})

	_childUI["wdld_level"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 90,
		y = -65,
		width = 450,
		text = hVar.tab_string["wdld_level"],
	})

	_childUI["wdld_LV"] = hUI.label:new({
		parent = _parent,
		size = 18,
		align = "MC",
		font = "num",
		border = 1,
		x = 200,
		y = -65,
		width = 450,
		text = "lv",
	})

	_childUI["wdld_LVC"] = hUI.label:new({
		parent = _parent,
		size = 18,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 235,
		y = -65,
		width = 450,
		text = hVar.tab_string["__Attr_Hint_Lev"],
	})

	_childUI["exp"] = hUI.valbar:new({
		parent = _parent,
		w = 166,
		h = 8,
		x = 260,
		y = -100,
		align = "LB",
		back = {model = "UI:BAR_S1_ValueBar_BG",x=-2,y=-1,w=170,h=10},
		model = "UI:IMG_S1_ValueBar",
		v = 0,
		max = 100,
	})

	_childUI["exp_icon"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "ui/heroattr.png",
		animation = "lightSlim",
		x = 200,
		y = - 90,
		w = 28,
		h = 28,
	})

	_childUI["expC"] = hUI.label:new({
		parent = _parent,
		size = 18,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 235,
		y = - 95,
		width = 450,
		text = hVar.tab_string["__Attr_Hint_Exp"],
	})

	_childUI["exp_num"] = hUI.label:new({
		parent = _parent,
		size = 14,
		align = "MC",
		font = "num",
		border = 1,
		x = 340,
		y = - 95,
		width = 450,
		text = WDLD_Init_Data.EXP.."/"..nextLVExp,
	})

	_childUI["wdld_cur_lv"] = hUI.label:new({
		parent = _parent,
		size = 18,
		align = "MC",
		font = "num",
		border = 1,
		x = 340,
		y = -65,
		width = 450,
		text = "",
	})

	_childUI["wdld_res_cur"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 146,
		y = -120,
		width = 450,
		text = hVar.tab_string["wdld_res_cur"],
	})

	_childUI["food_cur_icon"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:ICON_main_frm_ResourceFood",
		animation = "lightSlim",
		x = 70,
		y = - 150,
		w = 48,
		h = 48,
	})

	_childUI["food_cur_num"] = hUI.label:new({
		parent = _parent,
		size = 22,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 70,
		y = -185,
		width = 450,
		text = "",
	})

	_childUI["wood_cur_icon"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:ICON_main_frm_ResourceWood",
		animation = "lightSlim",
		x = 140,
		y = - 150,
		w = 48,
		h = 48,
	})

	_childUI["wood_cur_num"] = hUI.label:new({
		parent = _parent,
		size = 22,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 140,
		y = -185,
		width = 450,
		text = "",
	})

	_childUI["stone_cur_icon"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:ICON_main_frm_ResourceStone",
		animation = "lightSlim",
		x = 210,
		y = - 150,
		w = 48,
		h = 48,
	})

	_childUI["stone_cur_num"] = hUI.label:new({
		parent = _parent,
		size = 22,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 210,
		y = -185,
		width = 450,
		text = "",
	})

	_childUI["iron_cur_icon"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:ICON_main_frm_ResourceIron",
		animation = "lightSlim",
		x = 280,
		y = - 150,
		w = 48,
		h = 48,
	})

	_childUI["iron_cur_num"] = hUI.label:new({
		parent = _parent,
		size = 22,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 280,
		y = -185,
		width = 450,
		text = "",
	})

	_childUI["money_cur_icon"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:ICON_main_frm_ResourceGold",
		animation = "lightSlim",
		x = 350,
		y = - 150,
		w = 48,
		h = 48,
	})

	_childUI["money_cur_num"] = hUI.label:new({
		parent = _parent,
		size = 22,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 350,
		y = -185,
		width = 450,
		text = "",
	})

	_childUI["crystal_cur_icon"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:ICON_main_frm_ResourceJewel",
		animation = "lightSlim",
		x = 420,
		y = - 150,
		w = 48,
		h = 48,
	})

	_childUI["crystal_cur_num"] = hUI.label:new({
		parent = _parent,
		size = 22,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 420,
		y = -185,
		width = 450,
		text = "",
	})


	_childUI["wdld_res_next"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 146,
		y = -215,
		width = 450,
		text = hVar.tab_string["wdld_res_next"],
	})

	_childUI["food_next_icon"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:ICON_main_frm_ResourceFood",
		animation = "lightSlim",
		x = 70,
		y = - 245,
		w = 48,
		h = 48,
	})

	_childUI["food_next_num"] = hUI.label:new({
		parent = _parent,
		size = 22,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 70,
		y = - 280,
		width = 450,
		text = "",
	})

	_childUI["wood_next_icon"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:ICON_main_frm_ResourceWood",
		animation = "lightSlim",
		x = 140,
		y = - 245,
		w = 48,
		h = 48,
	})

	_childUI["wood_next_num"] = hUI.label:new({
		parent = _parent,
		size = 22,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 140,
		y = - 280,
		width = 450,
		text = "",
	})

	_childUI["stone_next_icon"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:ICON_main_frm_ResourceStone",
		animation = "lightSlim",
		x = 210,
		y = - 245,
		w = 48,
		h = 48,
	})

	_childUI["stone_next_num"] = hUI.label:new({
		parent = _parent,
		size = 22,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 210,
		y = -280,
		width = 450,
		text = "",
	})

	_childUI["iron_next_icon"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:ICON_main_frm_ResourceIron",
		animation = "lightSlim",
		x = 280,
		y = - 245,
		w = 48,
		h = 48,
	})

	_childUI["iron_next_num"] = hUI.label:new({
		parent = _parent,
		size = 22,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 280,
		y = -280,
		width = 450,
		text = "",
	})

	_childUI["money_next_icon"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:ICON_main_frm_ResourceGold",
		animation = "lightSlim",
		x = 350,
		y = - 245,
		w = 48,
		h = 48,
	})

	_childUI["money_next_num"] = hUI.label:new({
		parent = _parent,
		size = 22,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 350,
		y = -280,
		width = 450,
		text = "",
	})

	_childUI["crystal_next_icon"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:ICON_main_frm_ResourceJewel",
		animation = "lightSlim",
		x = 420,
		y = -245,
		w = 48,
		h = 48,
	})

	_childUI["crystal_next_num"] = hUI.label:new({
		parent = _parent,
		size = 22,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 420,
		y = -280,
		width = 450,
		text = "",
	})

	
	--分界线
	_childUI["apartline_back_w"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = 250,
		y = -300,
		w = 525,
		h = 8,
	})

	_childUI["apartline_back_h"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_03",
		x = 500,
		y = -299,
		w = 16,
		h = 598,
	})

	_childUI["Account_waiting"] =hUI.image:new({
		parent = _parent,
		model = "MODEL_EFFECT:waiting",
		x = 750,
		y = -300,
		z = 1,
	})

	_childUI["attack"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:BTN_ButtonRed",
		label = {text = hVar.tab_string["wdld_attack"],size = 22,font = hVar.FONTC,},
		font = hVar.FONTC,
		scaleT = 0.9,
		x = 420,
		y = -575,
		code = function(self)
			hGlobal.event:event("LocalEvent_ShowWDLDInfoFrm",0)
			hGlobal.event:event("LocalEvent_ShowPlayerRankFrame",1,200,nil,"city")
		end
	})

	_childUI["restart"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:BTN_ButtonRed",
		label = {text = hVar.tab_string["wdld_restart"],size = 22,font = hVar.FONTC,},
		font = hVar.FONTC,
		scaleT = 0.9,
		x = 120,
		y = -575,
		code = function(self)
			hGlobal.event:event("LocalEvent_ShowWDLDInfoFrm",0)
			hGlobal.event:event("LocalEvent_ShowWdldAttackFrame",1,hVar.WDLD_HeroNum[g_WDLD_RESTART_MAP_NAME])--进入别人领地的英雄个数
		end
	})

	_childUI["officia"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:BTN_ButtonRed",
		label = {text = "officia",size = 22,font = hVar.FONTC,},
		font = hVar.FONTC,
		scaleT = 0.9,
		x = 120,
		y = -525,
		code = function(self)
			hGlobal.event:event("LocalEvent_ShowWdldOfficalFrame",1)
		end
	})

	_childUI["FB"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:BTN_ButtonRed",
		label = {text = "FB",size = 22,font = hVar.FONTC,},
		font = hVar.FONTC,
		scaleT = 0.9,
		x = 270,
		y = -525,
		code = function(self)
			hGlobal.event:event("LocalEvent_ShowWdldAttackFBFrame",1,3)
		end
	})

	_childUI["prepare"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:BTN_ButtonRed",
		label = {text = hVar.tab_string["wdld_prepared"],size = 22,font = hVar.FONTC,},
		font = hVar.FONTC,
		scaleT = 0.9,
		x = 270,
		y = -575,
		code = function(self)
			xlScene_SaveMap(g_curPlayerName,g_ReadyCitySave)
		end
	})

	hGlobal.event:listen("LocalEvent_WDLD_prepared_ok","Griffin_WDLD_prepared_ok",function(state)
		_childUI["prepare"]:setstate(state)
		if state == 0 then
			_childUI["attack"]:setstate(1)
		end
	end)

	for logIndex = 1,logNum do
		_childUI["logStr"..logIndex] = hUI.label:new({
			parent = _parent,
			size = 20,
			align = "LC",
			font = hVar.FONTC,
			border = 1,
			x = 505,
			y = -20 - (logIndex - 1)*60,
			width = 450,
			text = ""..logIndex,
		})

		_childUI["food_icon"..logIndex] = hUI.image:new({
			parent = _frm.handle._n,
			model = "UI:ICON_main_frm_ResourceFood",
			animation = "lightSlim",
			x = 525,
			y = -50 - (logIndex - 1)*60,
			w = 48,
			h = 48,
		})

		_childUI["food_num"..logIndex] = hUI.label:new({
			parent = _parent,
			size = 20,
			align = "MC",
			font = hVar.FONTC,
			border = 1,
			x = 555,
			y = -55 - (logIndex - 1)*60,
			width = 450,
			text = ""..200,
		})

		_childUI["wood_icon"..logIndex] = hUI.image:new({
			parent = _frm.handle._n,
			model = "UI:ICON_main_frm_ResourceWood",
			animation = "lightSlim",
			x = 595,
			y = -50 - (logIndex - 1)*60,
			w = 48,
			h = 48,
		})

		_childUI["wood_num"..logIndex] = hUI.label:new({
			parent = _parent,
			size = 20,
			align = "MC",
			font = hVar.FONTC,
			border = 1,
			x = 615,
			y = -55 - (logIndex - 1)*60,
			width = 450,
			text = ""..200,
		})

		_childUI["stone_icon"..logIndex] = hUI.image:new({
			parent = _frm.handle._n,
			model = "UI:ICON_main_frm_ResourceStone",
			animation = "lightSlim",
			x = 665,
			y = -50 - (logIndex - 1)*60,
			w = 48,
			h = 48,
		})

		_childUI["stone_num"..logIndex] = hUI.label:new({
			parent = _parent,
			size = 20,
			align = "MC",
			font = hVar.FONTC,
			border = 1,
			x = 695,
			y = -55 - (logIndex - 1)*60,
			width = 450,
			text = ""..200,
		})

		_childUI["iron_icon"..logIndex] = hUI.image:new({
			parent = _frm.handle._n,
			model = "UI:ICON_main_frm_ResourceIron",
			animation = "lightSlim",
			x = 735,
			y = -50 - (logIndex - 1)*60,
			w = 48,
			h = 48,
		})

		_childUI["iron_num"..logIndex] = hUI.label:new({
			parent = _parent,
			size = 20,
			align = "MC",
			font = hVar.FONTC,
			border = 1,
			x = 765,
			y = -55 - (logIndex - 1)*60,
			width = 450,
			text = ""..200,
		})

		_childUI["money_icon"..logIndex] = hUI.image:new({
			parent = _frm.handle._n,
			model = "UI:ICON_main_frm_ResourceGold",
			animation = "lightSlim",
			x = 805,
			y = -50 - (logIndex - 1)*60,
			w = 48,
			h = 48,
		})

		_childUI["money_num"..logIndex] = hUI.label:new({
			parent = _parent,
			size = 20,
			align = "MC",
			font = hVar.FONTC,
			border = 1,
			x = 835,
			y = -55 - (logIndex - 1)*60,
			width = 450,
			text = ""..200,
		})

		_childUI["crystal_icon"..logIndex] = hUI.image:new({
			parent = _frm.handle._n,
			model = "UI:ICON_main_frm_ResourceJewel",
			animation = "lightSlim",
			x = 875,
			y = -50 - (logIndex - 1)*60,
			w = 48,
			h = 48,
		})

		_childUI["crystal_num"..logIndex] = hUI.label:new({
			parent = _parent,
			size = 20,
			align = "MC",
			font = hVar.FONTC,
			border = 1,
			x = 905,
			y = -55 - (logIndex - 1)*60,
			width = 450,
			text = ""..200,
		})

		_childUI["exp_icon"..logIndex] = hUI.image:new({
			parent = _frm.handle._n,
			model = "ui/heroattr.png",
			animation = "lightSlim",
			x = 945,
			y = -50 - (logIndex - 1)*60,
			w = 38,
			h = 38,
		})

		_childUI["exp_num"..logIndex] = hUI.label:new({
			parent = _parent,
			size = 20,
			align = "MC",
			font = hVar.FONTC,
			border = 1,
			x = 975,
			y = -55 - (logIndex - 1)*60,
			width = 450,
			text = ""..200,
		})
		
	end

	hGlobal.event:listen("LocalEvent_ShowWDLDInfoFrm","WDLD_END",function(bShow)
		hGlobal.UI.WdldInfoFrm:show(bShow)
		if bShow == 1 then
			if g_editor ~= 1 then
				local b_prepared = g_WDLD_Attr
				if b_prepared == -1 then
					_childUI["prepare"]:setstate(0)
					_childUI["attack"]:setstate(1)
				else
					_childUI["prepare"]:setstate(1)
					_childUI["attack"]:setstate(0)
				end
			end
			for logIndex = 1,logNum do
				_childUI["logStr"..logIndex]:setText("")
				_childUI["food_icon"..logIndex].handle._n:setVisible(false)
				_childUI["wood_icon"..logIndex].handle._n:setVisible(false)
				_childUI["stone_icon"..logIndex].handle._n:setVisible(false)
				_childUI["iron_icon"..logIndex].handle._n:setVisible(false)
				_childUI["money_icon"..logIndex].handle._n:setVisible(false)
				_childUI["crystal_icon"..logIndex].handle._n:setVisible(false)
				_childUI["exp_icon"..logIndex].handle._n:setVisible(false)
				_childUI["food_num"..logIndex]:setText("")
				_childUI["wood_num"..logIndex]:setText("")
				_childUI["stone_num"..logIndex]:setText("")
				_childUI["iron_num"..logIndex]:setText("")
				_childUI["money_num"..logIndex]:setText("")
				_childUI["crystal_num"..logIndex]:setText("")
				_childUI["exp_num"..logIndex]:setText("")
			end

			_childUI["Account_waiting"].handle._n:setVisible(true)
			_childUI["attack"]:setstate(0)
			
			Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.GetBattleSummary,luaGetplayerDataID()})

			if g_WDLD_Attr == -1 then
				_childUI["attack"]:setstate(1)
			end
			--print("%%%%%%%%%",g_Game_Zone.ZoneTemplate)
			--print("%%%%%%%%%",WDLD_Init_Data.LV)
			_childUI["wdld_cur_lv"]:setText(""..WDLD_Init_Data.LV)
			_childUI["food_cur_num"]:setText(""..g_Game_Zone.ZoneTemplate[WDLD_Init_Data.LV].food)
			_childUI["wood_cur_num"]:setText(""..g_Game_Zone.ZoneTemplate[WDLD_Init_Data.LV].wood)
			_childUI["stone_cur_num"]:setText(""..g_Game_Zone.ZoneTemplate[WDLD_Init_Data.LV].stone)
			_childUI["iron_cur_num"]:setText(""..g_Game_Zone.ZoneTemplate[WDLD_Init_Data.LV].iron)
			_childUI["money_cur_num"]:setText(""..g_Game_Zone.ZoneTemplate[WDLD_Init_Data.LV].gold)
			_childUI["crystal_cur_num"]:setText(""..g_Game_Zone.ZoneTemplate[WDLD_Init_Data.LV].crystal)
			if WDLD_Init_Data.LV < #g_Game_Zone.ZoneTemplate then
				_childUI["food_next_num"]:setText(""..g_Game_Zone.ZoneTemplate[WDLD_Init_Data.LV+1].food)
				_childUI["wood_next_num"]:setText(""..g_Game_Zone.ZoneTemplate[WDLD_Init_Data.LV+1].wood)
				_childUI["stone_next_num"]:setText(""..g_Game_Zone.ZoneTemplate[WDLD_Init_Data.LV+1].stone)
				_childUI["iron_next_num"]:setText(""..g_Game_Zone.ZoneTemplate[WDLD_Init_Data.LV+1].iron)
				_childUI["money_next_num"]:setText(""..g_Game_Zone.ZoneTemplate[WDLD_Init_Data.LV+1].gold)
				_childUI["crystal_next_num"]:setText(""..g_Game_Zone.ZoneTemplate[WDLD_Init_Data.LV+1].crystal)
				nextLVExp = g_Game_Zone.ZoneTemplate[WDLD_Init_Data.LV+1].exp
			else
				_childUI["food_next_num"]:setText("--")
				_childUI["wood_next_num"]:setText("--")
				_childUI["stone_next_num"]:setText("--")
				_childUI["iron_next_num"]:setText("--")
				_childUI["money_next_num"]:setText("--")
				_childUI["crystal_next_num"]:setText("--")
				nextLVExp = g_Game_Zone.ZoneTemplate[#g_Game_Zone.ZoneTemplate].exp
			end

			if _childUI["exp"]~=nil then
				_childUI["exp"]:setV((WDLD_Init_Data.EXP/nextLVExp)*100,100)
			end
			if _childUI["exp_num"] ~= nil then
				_childUI["exp_num"]:setText(WDLD_Init_Data.EXP.."/"..nextLVExp)
			end
		end
	end)

	hGlobal.event:listen("LocalEvent_ShowBattleLog","WDLD_END",function(bh)
		_childUI["Account_waiting"].handle._n:setVisible(false)
		local logL = logNum

		if #zone_battle_summary < logL then
			logL = #zone_battle_summary
		end
		if bh == 1 then
			for logIndex = 1,logL do
				local c = 0
				local battletime = zone_battle_summary[logIndex].time_begin
				battletime = string.sub(battletime,6,-4)
				if zone_battle_summary[logIndex].offense_id == luaGetplayerDataID() then
					_childUI["logStr"..logIndex]:setText(hVar.tab_string["you"]..hVar.tab_string["at"]..battletime..hVar.tab_string["rob"]..zone_battle_summary[logIndex].defence_name..hVar.tab_string["sWDLD"]..","..hVar.tab_string["you"]..hVar.tab_string["get"]..":")
					_childUI["logStr"..logIndex].handle.s:setColor(ccc3(0,255,255))
				elseif zone_battle_summary[logIndex].defence_id == luaGetplayerDataID() then
					_childUI["logStr"..logIndex]:setText(zone_battle_summary[logIndex].offense_name..hVar.tab_string["at"]..battletime..hVar.tab_string["rob"]..hVar.tab_string["you"]..hVar.tab_string["sWDLD"]..","..hVar.tab_string["you"]..hVar.tab_string["lost"]..":")
					_childUI["logStr"..logIndex].handle.s:setColor(ccc3(255,0,0))
				else
					c = 1
				end
				if c == 0 then
					_childUI["food_icon"..logIndex].handle._n:setVisible(true)
					_childUI["wood_icon"..logIndex].handle._n:setVisible(true)
					_childUI["stone_icon"..logIndex].handle._n:setVisible(true)
					_childUI["iron_icon"..logIndex].handle._n:setVisible(true)
					_childUI["money_icon"..logIndex].handle._n:setVisible(true)
					_childUI["crystal_icon"..logIndex].handle._n:setVisible(true)
					_childUI["exp_icon"..logIndex].handle._n:setVisible(true)
					_childUI["food_num"..logIndex]:setText(""..zone_battle_summary[logIndex].food)
					_childUI["wood_num"..logIndex]:setText(""..zone_battle_summary[logIndex].wood)
					_childUI["stone_num"..logIndex]:setText(""..zone_battle_summary[logIndex].stone)
					_childUI["iron_num"..logIndex]:setText(""..zone_battle_summary[logIndex].iron)
					_childUI["money_num"..logIndex]:setText(""..zone_battle_summary[logIndex].gold)
					_childUI["crystal_num"..logIndex]:setText(""..zone_battle_summary[logIndex].crystal)
					if zone_battle_summary[logIndex].offense_id == luaGetplayerDataID() then
						_childUI["exp_num"..logIndex]:setText(""..zone_battle_summary[logIndex].exp)
					elseif zone_battle_summary[logIndex].defence_id == luaGetplayerDataID() then
						_childUI["exp_num"..logIndex]:setText(""..0)
					end
				end
			end
		elseif bh == 0 then
			for logIndex = 1,logNum do
				_childUI["logStr"..logIndex]:setText("")
				_childUI["food_icon"..logIndex].handle._n:setVisible(false)
				_childUI["wood_icon"..logIndex].handle._n:setVisible(false)
				_childUI["stone_icon"..logIndex].handle._n:setVisible(false)
				_childUI["iron_icon"..logIndex].handle._n:setVisible(false)
				_childUI["money_icon"..logIndex].handle._n:setVisible(false)
				_childUI["crystal_icon"..logIndex].handle._n:setVisible(false)
				_childUI["exp_icon"..logIndex].handle._n:setVisible(false)
				_childUI["food_num"..logIndex]:setText("")
				_childUI["wood_num"..logIndex]:setText("")
				_childUI["stone_num"..logIndex]:setText("")
				_childUI["iron_num"..logIndex]:setText("")
				_childUI["money_num"..logIndex]:setText("")
				_childUI["crystal_num"..logIndex]:setText("")
				_childUI["exp_num"..logIndex]:setText("")
			end
		end
	end)
end