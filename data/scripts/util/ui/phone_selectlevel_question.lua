hGlobal.UI.InitSelectLevelQuestionFrm = function(mode)
	local tInitEventName = {"LocalEvent_phone_SelectLevel_OpenQuestionFrm","__show"}
	if mode~="include" then
		return tInitEventName
	end
	hGlobal.UI.PhoneSelectLevel_QuestionFrm =hUI.frame:new({
			x = hVar.SCREEN.w/2 - 310,
			y = hVar.SCREEN.h/2 + 200,
			h = 420,
			w = 600,
			show = 0,
			dragable = 3,										--changed by pangyong 2015/4/9
			titlebar = 0,
			bgAlpha = 0,
			bgMode = "tile",
			background = "UI:tip_item",
			border = 1,
			autoactive = 0,
	})

	local _frm = hGlobal.UI.PhoneSelectLevel_QuestionFrm
	local _childUI = _frm.childUI
	local _parent = _frm.handle._n

	

	--退出按钮
	_childUI["btnClose1"] = hUI.button:new({
		parent = _parent,
		model = "BTN:PANEL_CLOSE",
		dragbox = _childUI["dragBox"],
		scaleT = 0.9,
		x = 590,
		y = -10,
		--w = hVar.CloseButtonWH[1],
		--h = hVar.CloseButtonWH[2],
		code = function()
			_frm:show(0)
		end,
	})

	--分界线1
	_childUI["apartline_1"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = _frm.data.w/2,
		y = -80,
		w = 630,
		h = 8,
	})

	--提示
	_childUI["PromptInfo"]  = hUI.label:new({
		parent = _parent,
		size = 45,
		align = "LT",
		font = hVar.FONTC,
		x = _frm.data.w/2 - 130,
		y = -15,
		--width = 300,
		text = hVar.tab_string["__TEXT_Question_Prompt3"],
		--RGB = {255,0,0},
	})

	_childUI["PromptMessageDetailed"]= hUI.label:new({
		parent = _parent,
		size = 29,
		align = "LT",
		font = hVar.FONTC,
		x = 25,
		y = -100,
		text = hVar.tab_string["__TEXT_Sprog_Prompt888"],
		width = 560,
	})
	_childUI["PromptMessageDetailed"]= hUI.label:new({
		parent = _parent,
		size = 25,
		align = "LT",
		font = hVar.FONTC,
		x = 25,
		y = -260,
		RGB = {230,180,50},
		text = hVar.tab_string["__TEXT_Question_Prompt2"],
		width = 670,
	})
	_childUI["PromptMessageDetailed"]= hUI.label:new({
		parent = _parent,
		size = 25,
		align = "LT",
		font = hVar.FONTC,
		x = 25,
		y = -262,
		RGB = {230,180,50},
		text = hVar.tab_string["__TEXT_Sprog_Prompt999"],
		width = 560,
	})

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_frm:show(1)
		_frm:active()
	end)
end