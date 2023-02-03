
--购买道具的失败面板
hGlobal.UI.InitBuyItemFailFrm = function(mode)
	local tInitEventName = {"LocalEvent_BuyItemfail","__show"}
	if mode~="include" then
		return tInitEventName
	end
	hGlobal.UI.BuyItemFailFrm = hUI.frame:new({
		x = hVar.SCREEN.w/2 - 230,
		y = hVar.SCREEN.h/2 + 150,
		z = 100000,
		w = 460,
		h = 300,
		dragable = 4,
		show = 0,
		background = "UI:tip_item",
		border = 1,
		autoactive = 0,
	})
	
	local _frm = hGlobal.UI.BuyItemFailFrm
	local _childUI = _frm.childUI
	local _parent = _frm.handle._n
	
	--您的游戏币不足
	_childUI["tipInfo"] = hUI.label:new({
		parent = _parent,
		x = _frm.data.w/2,
		y = -60,
		text = hVar.tab_string["__TEXT_not_enough_money"],
		size = 34,
		font = hVar.FONTC,
		align = "MC",
		RGB = {0,255,0},
	})
	
	_childUI["buyGameCoinTip"] = hUI.label:new({
		parent = _parent,
		x = _frm.data.w/2,
		y = -_frm.data.h/2,
		text = hVar.tab_string["__TEXT_BuyGameCoinTip"],
		size = 26,
		font = hVar.FONTC,
		align = "MC",
	})
	
	--购买按钮
	_childUI["Buy"] = hUI.button:new({
		parent = _frm,
		label = {text = hVar.tab_string["__TEXT_GoodsBuy"], border = 1,font = hVar.FONTC, size = 32,},
		x = _frm.data.w - 150,
		y = 30 -_frm.data.h,
		scaleT = 0.9,
		code = function(self)
			hGlobal.event:event("LocalEvent_InitInAppPurchaseTipFrm")
			_frm:show(0)
		end,
	})
	
	--取消按钮
	_childUI["btnCancel"] = hUI.button:new({
		parent = _frm,
		label = {text = hVar.tab_string["Exit_Now"], border = 1,font = hVar.FONTC, size = 32,},
		x = _frm.data.w/5 + 50,
		y = 30 -_frm.data.h,
		scaleT = 0.9,
		code = function()
			_frm:show(0)
		end,
	})
	
	--监听事件
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(result)
		
		if (result == 1) then
			print("not enough money")
			_childUI["tipInfo"]:setText(hVar.tab_string["__TEXT_not_enough_money"])
			_childUI["buyGameCoinTip"]:setText(hVar.tab_string["__TEXT_BuyGameCoinTip"])
			
		elseif (result == 2) then
			print("device is illegal")
			_childUI["tipInfo"]:setText("device is illegal")
			_childUI["buyGameCoinTip"]:setText("device is illegal")
		end
		
		--geyachao; 根据是否开放购买功能，决定按钮的布局
		if (hVar.SHOW_PURCHASE_HOST == 1) and (hVar.SHOW_PURCHASE_CLIENT == 1) then
			--购买按钮
			_childUI["Buy"]:setstate(1)
			_childUI["Buy"]:setXY(_frm.data.w - 150, 30 -_frm.data.h)
			--取消按钮
			_childUI["btnCancel"]:setstate(1)
			_childUI["btnCancel"]:setXY(_frm.data.w/5 + 50, 30 -_frm.data.h)
		else
			--购买按钮
			_childUI["Buy"]:setstate(-1)
			--_childUI["Buy"]:setXY(_frm.data.w - 150, 30 -_frm.data.h)
			--取消按钮
			_childUI["btnCancel"]:setstate(1)
			_childUI["btnCancel"]:setXY(_frm.data.w/5 + 135, 30 -_frm.data.h)
			
			_childUI["tipInfo"]:setText(hVar.tab_string["ios_not_enough_game_coin"])
			_childUI["buyGameCoinTip"]:setText(hVar.tab_string["__TEXT_not_enough_money"])
		end
	
		_frm:show(1)
		_frm:active()
	end)
	
end