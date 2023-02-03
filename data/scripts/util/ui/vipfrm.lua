hGlobal.UI.InitVipFrm = function(mode)
	local tInitEventName = {"LocalEvent_showVipFrmC","__UI__showVipFrmC"}
	if mode~="include" then
		return tInitEventName
	end
	hGlobal.UI.VipFrm = hUI.frame:new({
		x = 352,
		y = 460,
		z = -1,
		dragable = 0,
		w = 648,
		h = 366,
		--z = -1,
		show = 0,
		autoactive = 0,
		background = "UI:tip_item",
		codeOnTouch = function()
			--hGlobal.event:event("LocalEvent_ShowItemTipFram",nil,nil,0)
		end,
	})

	local _frm = hGlobal.UI.VipFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	
	local showVipInfo = nil

	_childUI["apartline_back"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = 325,
		y = -210,
		w = 680,
		h = 8,
	})

	_childUI["vipGift"]= hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:BTN_ButtonRed",
		x = 100,
		y = -160,
		w = 140,
		h = 46,
		label = hVar.tab_string["MadelGiftGet"],
		font = hVar.FONTC,
		scaleT = 0.9,
		code = function(self)
			hGlobal.event:event("LocalEvent_showVipGetFrm",1,LuaGetPlayerVipLv())
		end,
	})
	_childUI["vipGift"]:setstate(0)

	for i = 1,7 do		
		_childUI["vipBtn"..i]= hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "UI:vip"..i,
			x = -35+i*90,
			y = -260,
			w = 56,
			h = 56,
			code = function(self)
				showVipInfo(i)
			end,
		})
		
		_childUI["VIpC"..i] = hUI.image:new({
			parent = _parent,
			model = "UI:skillup",
			x = -35+i*90,
			y = -258,
			--w = 80,
			--h = 80,
		})
		_childUI["VIpC"..i].handle._n:setVisible(false)

		_childUI["VIpGet"..i] = hUI.image:new({
			parent = _parent,
			model = "UI:finish",
			x = -35+i*90,
			y = -300,
			--w = 80,
			--h = 80,
		})
		_childUI["VIpGet"..i].handle._n:setVisible(false)
	end
	
	_childUI["rmbBg"] = hUI.bar:new({
		parent = _parent,
		model = "UI:card_select_back",
		x = 120,
		y = -50,
		w = 200,
		h = 70,
	})

	_childUI["giftGetBtn"]= hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:BTN_ButtonRed",
		x = 555,
		y = -335,
		w = 140,
		h = 46,
		label = hVar.tab_stringGIFT[5][3],
		font = hVar.FONTC,
		scaleT = 0.9,
		code = function(self)
			hGlobal.event:event("LocalEvent_InitInAppPurchaseTipFrm")
		end,
	})

	_childUI["RmbC"]= hUI.label:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		font = hVar.FONTC,
		x = 20,
		y = -325,
		text = hVar.tab_string["allRmb2"]..LuaGetTopupCount()..hVar.tab_string["Rmb"],
		size = 30,
	})

	_childUI["vipRmbLabel"]= hUI.label:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:GIFT",
		font = hVar.FONTC,
		x = 25,
		y = -20,
		text = hVar.tab_string["allRmb"],
		size = 30,
	})

	_childUI["vipRmbNeedLabel"]= hUI.label:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:GIFT",
		font = "numWhite",
		align = "MC",
		x = 103,
		y = -65,
		text = "",
		size = 28,
	})

	_childUI["vipRmbLabel"]= hUI.label:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:GIFT",
		font = hVar.FONTC,
		x = 175,
		y = -50,
		text = hVar.tab_string["Rmb"],
		size = 30,
	})

	--_childUI["TeQuan"]= hUI.label:new({
		--parent = _parent,
		--dragbox = _childUI["dragBox"],
		--model = "UI:GIFT",
		--font = hVar.FONTC,
		--x = 55,
		--y = -58,
		--text = hVar.tab_string["TeQuan"],
		--size = 30,
	--})
	_childUI["vipRmbTeQuanLabel1"]= hUI.label:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:GIFT",
		font = hVar.FONTC,
		x = 275,
		y = -25,
		text = hVar.tab_string["vipStr1"],
		size = 26,
	})
	_childUI["vipRmbTeQuanLabel2"]= hUI.label:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:GIFT",
		font = hVar.FONTC,
		x = 275,
		y = -63,
		text = hVar.tab_string["vipStr2"],
		size = 26,
	})
	_childUI["vipRmbTeQuanLabel3"]= hUI.label:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:GIFT",
		font = hVar.FONTC,
		x = 275,
		y = -101,
		text = "",
		size = 26,
	})
	_childUI["vipRmbTeQuanLabel4"]= hUI.label:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:GIFT",
		font = hVar.FONTC,
		x = 275,
		y = -139,
		text ="",
		size = 26,
	})
	_childUI["vipRmbTeQuanLabel5"]= hUI.label:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:GIFT",
		font = hVar.FONTC,
		x = 275,
		y = -177,
		text ="",
		size = 26,
	})

	_childUI["VIpGiftIcon1"] = hUI.image:new({
		parent = _parent,
		model = "UI:player_bag_btn_open",
		x = 255,
		y = -35,
		w = 32,
		h = 32,
	})
	_childUI["VIpGiftIcon1"].handle._n:setVisible(false)

	_childUI["VIpGiftIcon2"] = hUI.image:new({
		parent = _parent,
		model = "UI:item_res_gem",
		x = 255,
		y = -73,
		w = 28,
		h = 28,
	})
	_childUI["VIpGiftIcon2"].handle._n:setVisible(false)

	_childUI["VIpGiftIcon3"] = hUI.image:new({
		parent = _parent,
		model = "icon/item/card_lv1.png",
		x = 255,
		y = -111,
		w = 36,
		h = 36,
	})
	_childUI["VIpGiftIcon3"].handle._n:setVisible(false)

	_childUI["VIpGiftIcon4"] = hUI.image:new({
		parent = _parent,
		model = "icon/item/random_lv3.png",
		x = 255,
		y = -149,
		w = 36,
		h = 36,
	})
	_childUI["VIpGiftIcon4"].handle._n:setVisible(false)

	_childUI["VIpGiftIcon5"] = hUI.image:new({
		parent = _parent,
		model = "ui/forge_red_icon.png",
		x = 255,
		y = -187,
		w = 32,
		h = 32,
	})
	_childUI["VIpGiftIcon5"].handle._n:setVisible(false)

	_childUI["btn_comment"]= hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "misc/mask.png",
		x = 555,
		y = -335,
		w = 140,
		h = 46,
		label = hVar.tab_stringGIFT[5][3],
		font = hVar.FONTC,
		scaleT = 0.9,
		code = function(self)
			
		end,
	})

	showVipInfo = function(VipLevel)
		_childUI["vipRmbNeedLabel"]:setText(hVar.VipRmb[VipLevel])
		_childUI["RmbC"]:setText(hVar.tab_string["allRmb2"]..LuaGetTopupCount()..hVar.tab_string["Rmb"])
		_childUI["vipGift"]:setstate(-1)
		--_childUI["vipRmbTeQuanLabel"]:setText(hVar.tab_string["vip"..VipLevel])
		for i = 1,5 do
			_childUI["VIpGiftIcon"..i].handle._n:setVisible(false)
		end
		for i = 1,7 do
			_childUI["VIpC"..i].handle._n:setVisible(false)
			_childUI["VIpGet"..i].handle._n:setVisible(false)
		end
		_childUI["VIpC"..VipLevel].handle._n:setVisible(true)
		local myVip = LuaGetPlayerVipLv()
		if myVip > 0 then
			_childUI["VIpGet"..myVip].handle._n:setVisible(true)
			if myVip == VipLevel then
				_childUI["vipGift"]:setstate(1)
			end
		end
		if VipLevel == 1 then
			_childUI["vipRmbTeQuanLabel1"]:setText(hVar.tab_string["vipStr1"])
			_childUI["vipRmbTeQuanLabel2"]:setText(hVar.tab_string["vipStr2"])
			_childUI["vipRmbTeQuanLabel3"]:setText("")
			_childUI["vipRmbTeQuanLabel4"]:setText("")
			_childUI["vipRmbTeQuanLabel5"]:setText("")
			_childUI["VIpGiftIcon"..1].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..2].handle._n:setVisible(true)
		elseif VipLevel == 2 then
			_childUI["vipRmbTeQuanLabel1"]:setText(hVar.tab_string["vipStr1"])
			_childUI["vipRmbTeQuanLabel2"]:setText(hVar.tab_string["vipStr3"])
			_childUI["vipRmbTeQuanLabel3"]:setText(hVar.tab_string["vipStr11"])
			_childUI["vipRmbTeQuanLabel4"]:setText("")
			_childUI["vipRmbTeQuanLabel5"]:setText("")
			_childUI["VIpGiftIcon"..1].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..2].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..3].handle._n:setVisible(true)
		elseif VipLevel == 3 then
			_childUI["vipRmbTeQuanLabel1"]:setText(hVar.tab_string["vipStr10"])
			_childUI["vipRmbTeQuanLabel2"]:setText(hVar.tab_string["vipStr4"])
			_childUI["vipRmbTeQuanLabel3"]:setText(hVar.tab_string["vipStr11"])
			_childUI["vipRmbTeQuanLabel4"]:setText("")
			_childUI["vipRmbTeQuanLabel5"]:setText("")
			_childUI["VIpGiftIcon"..1].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..2].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..3].handle._n:setVisible(true)
		elseif VipLevel == 4 then
			_childUI["vipRmbTeQuanLabel1"]:setText(hVar.tab_string["vipStr10"])
			_childUI["vipRmbTeQuanLabel2"]:setText(hVar.tab_string["vipStr5"])
			_childUI["vipRmbTeQuanLabel3"]:setText(hVar.tab_string["vipStr11"])
			_childUI["vipRmbTeQuanLabel4"]:setText(hVar.tab_string["vipStr15"])
			_childUI["vipRmbTeQuanLabel5"]:setText("")
			_childUI["VIpGiftIcon"..1].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..2].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..3].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..4].handle._n:setVisible(true)
		elseif VipLevel == 5 then
			_childUI["vipRmbTeQuanLabel1"]:setText(hVar.tab_string["vipStr16"])
			_childUI["vipRmbTeQuanLabel2"]:setText(hVar.tab_string["vipStr6"])
			_childUI["vipRmbTeQuanLabel3"]:setText(hVar.tab_string["vipStr12"])
			_childUI["vipRmbTeQuanLabel4"]:setText(hVar.tab_string["vipStr15"])
			_childUI["vipRmbTeQuanLabel5"]:setText(hVar.tab_string["vipStr9"])
			_childUI["VIpGiftIcon"..1].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..2].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..3].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..4].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..5].handle._n:setVisible(true)
		elseif VipLevel == 6 then
			_childUI["vipRmbTeQuanLabel1"]:setText(hVar.tab_string["vipStr16"])
			_childUI["vipRmbTeQuanLabel2"]:setText(hVar.tab_string["vipStr7"])
			_childUI["vipRmbTeQuanLabel3"]:setText(hVar.tab_string["vipStr13"])
			_childUI["vipRmbTeQuanLabel4"]:setText(hVar.tab_string["vipStr15"])
			_childUI["vipRmbTeQuanLabel5"]:setText(hVar.tab_string["vipStr9"])
			_childUI["VIpGiftIcon"..1].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..2].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..3].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..4].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..5].handle._n:setVisible(true)
		elseif VipLevel == 7 then
			_childUI["vipRmbTeQuanLabel1"]:setText(hVar.tab_string["vipStr17"])
			_childUI["vipRmbTeQuanLabel2"]:setText(hVar.tab_string["vipStr8"])
			_childUI["vipRmbTeQuanLabel3"]:setText(hVar.tab_string["vipStr14"])
			_childUI["vipRmbTeQuanLabel4"]:setText(hVar.tab_string["vipStr15"])
			_childUI["vipRmbTeQuanLabel5"]:setText(hVar.tab_string["vipStr9"])
			_childUI["VIpGiftIcon"..1].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..2].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..3].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..4].handle._n:setVisible(true)
			_childUI["VIpGiftIcon"..5].handle._n:setVisible(true)
		end
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(IsShow,VipLevel)
		if IsShow==1 then
			_frm:show(1)
			if type(VipLevel)=="number" then
				showVipInfo(VipLevel)
			end
			_frm:active()
		else
			_frm:show(0)
		end
	end)
end