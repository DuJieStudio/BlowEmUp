hGlobal.UI.InitWdldCloseFrm_WDLD = function(sInitMode)
	if sInitMode=="init" then
		return hVar.RESULT_FAIL
	end
	hGlobal.UI.WdldCloseFrm = hUI.frame:new({
		x = 350,
		y = 600,
		closebtn = 0,--"BTN:PANEL_CLOSE",
		autoactive = 0,
		dragable = 2,
		background = "UI:PANEL_INFO_MINI",
		
	})
	hGlobal.UI.WdldCloseFrm:show(0)
		
	local _fram = hGlobal.UI.WdldCloseFrm
	local _childUI = _fram.childUI

	_childUI["BtnYes"] = hUI.button:new({
		parent = _fram.handle._n,
		model = "UI:ButtonBack2",
		dragbox = _fram.childUI["dragBox"],
		label = hVar.tab_string["__TEXT_SelectedMap"],
		font = hVar.FONTC,
		border = 1,
		x = _fram.data.w/2,
		y = -1*(_fram.data.h-54),
		scale = 0.8,
		scaleT = 0.9,
		code = function(self)
			--if g_phone_mode == 0 then
				hGlobal.event:event("LocalEvent_NextDayBreathe",0)
				--xlScene_Switch(g_playerlist)
				--hGlobal.event:event("LocalEvent_ShowPlayerListFram",Save_playerList,g_game_mode,g_curPlayerName)
			--else
				----xlScene_SetViewMovable(g_town,1)
				--xlScene_LoadMap(g_town,hVar.PHONE_MAINMENU)
				--xlScene_Switch(g_town)
				hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
			--end
			_fram:show(0)
		end,
	})

	_childUI["btnClose"] = hUI.button:new({
		parent = _fram.handle._n,
		model = "UI:ButtonBack2",
		dragbox = _fram.childUI["dragBox"],
		label = hVar.tab_string["__TEXT_Close"],
		font = hVar.FONTC,
		border = 1,
		x = _fram.data.w/2,
		y = -1*(_fram.data.h-54),
		scale = 0.8,
		scaleT = 0.9,
		code = function(self)
			_fram:show(0)
		end,
	})

	_childUI["wldl_no_net"] = hUI.label:new({
		parent = _fram.handle._n,
		size = 28,
		font = hVar.FONTC,
		align = "MC",
		x =  _fram.data.w/2 - 20,
		y = -100,
		width = 300,
		text = hVar.tab_string["wdld_no_net"],
		border = 1,
	})

	hGlobal.event:listen("LocalEvent_WdldClose","WDLD_close",function(bh)
		hGlobal.UI.WdldCloseFrm:show(bh)
		if bh == 1 then
			_fram:active()
			_childUI["BtnYes"]:setstate(-1)
			_childUI["btnClose"]:setstate(-1)
			if g_current_scene == g_world then
				_childUI["BtnYes"]:setstate(1)
			else
				_childUI["btnClose"]:setstate(1)
			end
		end
	end)
end