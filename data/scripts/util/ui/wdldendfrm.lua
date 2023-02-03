--其实现在是我的领地里按game start后的面板 懒得svn上改名字
WDLD_ATC_GET = 
{
	WOOD = 0,
	FOOD = 0,
	STONE = 0,
	IRON = 0,
	CRYSTAL = 0,
	GOLD = 0,
	EXP = 0,
	TIME = 0,
}

hGlobal.UI.InitWdldEndFrm_WDLD = function(sInitMode)
	if sInitMode=="init" then
		return hVar.RESULT_FAIL
	end
	hGlobal.UI.WdldEndFrm = hUI.frame:new({
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

	local _frm = hGlobal.UI.WdldEndFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	_frm:showBorder(1)

	_childUI["end"] = hUI.label:new({
		parent = _parent,
		size = 34,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 250,
		y = -50,
		width = 450,
		text = hVar.tab_string["wdld_end"].."0"..hVar.tab_string["second"],
	})

	_childUI["food"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:ICON_main_frm_ResourceFood",
		animation = "lightSlim",
		x = 100,
		y = - 100,
		w = 64,
		h = 64,
	})

	_childUI["foodNum"] = hUI.label:new({
		parent = _parent,
		size = 34,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 100,
		y = -150,
		width = 450,
		text = "",
	})

	_childUI["wood"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:ICON_main_frm_ResourceWood",
		animation = "lightSlim",
		x = 200,
		y = - 100,
		w = 64,
		h = 64,
	})

	_childUI["woodNum"] = hUI.label:new({
		parent = _parent,
		size = 34,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 200,
		y = -150,
		width = 450,
		text = "",
	})

	_childUI["stone"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:ICON_main_frm_ResourceStone",
		animation = "lightSlim",
		x = 300,
		y = - 100,
		w = 64,
		h = 64,
	})

	_childUI["stoneNum"] = hUI.label:new({
		parent = _parent,
		size = 34,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 300,
		y = -150,
		width = 450,
		text = "",
	})

	_childUI["iron"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:ICON_main_frm_ResourceIron",
		animation = "lightSlim",
		x = 400,
		y = - 100,
		w = 64,
		h = 64,
	})

	_childUI["ironNum"] = hUI.label:new({
		parent = _parent,
		size = 34,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 400,
		y = -150,
		width = 450,
		text = "",
	})

	_childUI["money"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:ICON_main_frm_ResourceGold",
		animation = "lightSlim",
		x = 100,
		y = - 200,
		w = 64,
		h = 64,
	})

	_childUI["moneyNum"] = hUI.label:new({
		parent = _parent,
		size = 34,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 100,
		y = -250,
		width = 450,
		text = "",
	})

	_childUI["crystal"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "UI:ICON_main_frm_ResourceJewel",
		animation = "lightSlim",
		x = 250,
		y = - 200,
		w = 64,
		h = 64,
	})

	_childUI["crystalNum"] = hUI.label:new({
		parent = _parent,
		size = 34,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 250,
		y = -250,
		width = 450,
		text = "",
	})

	_childUI["exp"] = hUI.image:new({
		parent = _frm.handle._n,
		model = "ICON:ATTR_exp",
		animation = "lightSlim",
		x = 400,
		y = - 200,
		w = 56,
		h = 56,
	})

	_childUI["expNum"] = hUI.label:new({
		parent = _parent,
		size = 34,
		align = "MC",
		font = hVar.FONTC,
		border = 1,
		x = 400,
		y = -250,
		width = 450,
		text = "",
	})

	_childUI["ok"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:BTN_ButtonRed",
		label = "ok",
		font = hVar.FONTC,
		scaleT = 0.9,
		x = 250,
		y = -570,
		code = function(self)
			_frm:show(0)
			hGlobal.event:event("LocalEvent_Back2WDLD",hGlobal.WORLD.LastWorldMap)
		end
	})

	hGlobal.event:listen("LocalEvent_ShowWDLDEndFrm","WDLD_END",function(bShow)
		if bShow == 1 then
			_childUI["foodNum"]:setText("+"..WDLD_ATC_GET.FOOD)
			_childUI["woodNum"]:setText("+"..WDLD_ATC_GET.WOOD)
			_childUI["ironNum"]:setText("+"..WDLD_ATC_GET.IRON)
			_childUI["stoneNum"]:setText("+"..WDLD_ATC_GET.STONE)
			_childUI["moneyNum"]:setText("+"..WDLD_ATC_GET.GOLD)
			_childUI["crystalNum"]:setText("+"..WDLD_ATC_GET.CRYSTAL)
			_childUI["expNum"]:setText("+"..WDLD_ATC_GET.EXP)
			_childUI["end"]:setText(hVar.tab_string["wdld_end"]..WDLD_ATC_GET.TIME..hVar.tab_string["second"])
			WDLD_ATC_GET.WOOD = 0
			WDLD_ATC_GET.FOOD = 0
			WDLD_ATC_GET.STONE = 0
			WDLD_ATC_GET.IRON = 0
			WDLD_ATC_GET.CRYSTAL = 0
			WDLD_ATC_GET.GOLD = 0
			WDLD_ATC_GET.EXP = 0
			WDLD_ATC_GET.TIME = 0
		end
		hGlobal.UI.WdldEndFrm:show(bShow)
	end)
end