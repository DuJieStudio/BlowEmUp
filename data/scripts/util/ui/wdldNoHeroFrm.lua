hGlobal.UI.InitWdldNoHeroFrm_WDLD = function(sInitMode)
	if sInitMode=="init" then
		return hVar.RESULT_FAIL
	end
	hGlobal.UI.WdldNoHeroFrm = hUI.frame:new({
		x = 350,
		y = 600,
		closebtn = 0,--"BTN:PANEL_CLOSE",
		autoactive = 0,
		dragable = 2,
		background = "UI:PANEL_INFO_MINI",
		
	})
	hGlobal.UI.WdldNoHeroFrm:show(0)
		
	local _fram = hGlobal.UI.WdldNoHeroFrm
	local _childUI = _fram.childUI

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

	_childUI["wldl_no_hero"] = hUI.label:new({
		parent = _fram.handle._n,
		size = 28,
		font = hVar.FONTC,
		align = "MC",
		x =  _fram.data.w/2 - 20,
		y = -100,
		width = 300,
		text = hVar.tab_string["wdld_no_hero"],
		border = 1,
	})

	hGlobal.event:listen("LocalEvent_WdldNoHero","WDLD_close",function(bh)
		hGlobal.UI.WdldNoHeroFrm:show(bh)
		if bh == 1 then
			_fram:active()
		end
	end)
end