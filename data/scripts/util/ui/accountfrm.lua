--“—∑œ∆˙ 2014/9/3
----------------------
-- ’À∫≈µ«¬ΩΩÁ√Ê
----------------------
hGlobal.UI._InitAccountFrm = function()
	hGlobal.UI.AccountFrm =hUI.frame:new({
		x = 270,
		y = 500,
		dragable = 2,
		h = 340,
		w = 460,
		show = 0,
	})

	local _frm = hGlobal.UI.AccountFrm
	local _childUI = _frm.childUI
	local _parent = _frm.handle._n


	--±ÍÃ‚
	_childUI["WeekStarHeroTitle"] = hUI.label:new({
		parent = _parent,
		size = 32,
		align = "MC",
		font = hVar.FONTC,
		x = _frm.data.w/2-10,
		y = -30,
		width = 540,
		text = hVar.tab_string["__TEXT__AccountTip"],
	})
	
	
	--’À∫≈√˚
	_childUI["HeroCardInfo"]  = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 20,
		y = -100,
		width = 270,
		text = hVar.tab_string["__TEXT__Account_Name"],
		RGB = {0,255,0},
	})

	-- ‰»ÎøÚ1 ±≥æ∞Õº ’À∫≈√˚
	_childUI["Account_bar"] = hUI.bar:new({
		model = "UI:win_back",
		parent = _parent,
		align = "LT",
		x = 100,
		y = -100,
		w = 300,
		h = 32,
	})

	--√‹¬Î
	_childUI["SkillInfo"]  = hUI.label:new({
		parent = _parent,
		size = 24,
		align = "LT",
		font = hVar.FONTC,
		x = 20,
		y = -160,
		width = 270,
		text = hVar.tab_string["__TEXT__PASSWORD"],
		RGB = {0,255,0},
	})

	-- ‰»ÎøÚ2 ±≥æ∞Õº √‹¬Î
	_childUI["PassWord_bar"] = hUI.bar:new({
		model = "UI:win_back",
		parent = _parent,
		align = "LT",
		x = 100,
		y = -160,
		w = 300,
		h = 32,
	})


	--µ«¬º∞¥≈•
	_childUI["btnOK"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		label = hVar.tab_string["__TEXT_Confirm"],
		x = _frm.data.w/2,
		y = 30 -_frm.data.h,
		scaleT = 0.9,
		code = function()
			--_exitFun()
			_frm:show(0)
			xlMap_ShowFogOfWar(0)
		end,
	})


	local _showFrmCallBack = function()
		_frm:active()
	end

	hGlobal.event:listen("LocalEvent_ShowAccountFrm","__ShowAccountFrm",function()
		_frm:show(1)
		_frm.handle._n:runAction(CCSequence:createWithTwoActions(CCJumpTo:create(0.1,ccp(_frm.data.x,_frm.data.y),5,1),CCCallFunc:create(_showFrmCallBack)))
	end)
end