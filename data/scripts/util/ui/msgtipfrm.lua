-------------------------------
--各种信息提示面板
-------------------------------
hGlobal.UI.InitMsgTipFrm = function()
	hGlobal.UI.MsgTipFrm  = hUI.frame:new({
		x = 600,
		y = 280,
		dragable = 0,
		show = 0,
		z = 101,
		background = "UI:PANEL_INFO_MINI",
	})

	local _frm = hGlobal.UI.MsgTipFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	_childUI["tipText"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "LT",
		font = hVar.FONTC,
		border = 1,
		x = 50,
		y = -30,
		width = 300,
		text = "",
	})
	
	_childUI["OKbtn"] = hUI.button:new({
		parent = _parent,
		model = "UI:ButtonBack2",
		label = hVar.tab_string["__TEXT_Confirm"],
		font = hVar.FONTC,
		border = 1,
		dragbox = _childUI["dragBox"],
		x = _frm.data.w/2-10,
		y = -1*(_frm.data.h-60),
		scale = 0.8,
		scaleT = 0.9,
		code = function(self)
			_frm:show(0)
			hApi.safeRemoveT(_childUI,"tipImage")
		end,
	})
	
	hGlobal.event:listen("LocalEvent_MsgTipFrm","showMsgTip",function(text,image)
		_childUI["tipText"]:setText(text)
		
		hApi.safeRemoveT(_childUI,"tipImage")
		if image then
			--如果第二个参数有值则创建提示图片
			_childUI["tipImage"] = hUI.image:new({
				parent = _parent,
				model = image,
				x = _frm.data.w/2-10,
				y = -_frm.data.h/2 - 20,
				w = 64,
				h = 64,
				z = 1,
			})
		end

		_frm:show(1,"appear")
	end)
end