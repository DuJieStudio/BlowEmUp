hGlobal.UI.InitBuyFuStoneFrame = function(mode)
	local tInitEventName = {"LocalEvent_BuyFuStoneFrame","__UnitShowHireFrame"}
	if mode~="include" then
		return tInitEventName
	end
	local _frm,_childUI
	local _w,_h =  530,360
	local _x,_y = hVar.SCREEN.w/2 - _w/2,hVar.SCREEN.h/2 + _h/2

	hGlobal.UI.BuyFuStoneFrame = hUI.frame:new({
		x = _x,
		y = _y,
		w = _w,
		h = _h,
		show = 0,
		dragable = 2,
		background = "UI:tip_item",
		border = 1,
	})
	
	_frm = hGlobal.UI.BuyFuStoneFrame
	_childUI = _frm.childUI
	local _parent = _frm.handle._n

	_childUI["Tip"] = hUI.label:new({
		parent = _parent,
		font = hVar.FONTC,
		size = 30,
		text = hVar.tab_string["__TEXT_BuyFuStone"],
		align = "MC",
		x = _w/2,
		y = -40,
		border = 1,
	})
	

	_childUI["apartline_back"] = hUI.image:new({
		parent = _parent,
		model = "UI:panel_part_09",
		x = 270,
		y = -80,
		w = _w,
		h = 8,
	})

	--关闭按钮
	_childUI["Btnclose"] = hUI.button:new({
		parent = _parent,
		model = "BTN:PANEL_CLOSE",
		dragbox = _frm.childUI["dragBox"],
		x = _w,
		y = -10,
		scaleT = 0.9,
		code = function(self)
			_frm:show(0,"normal")
		end,
	})
	
	--创建符石购买项 项目起始 x,y,按照 offy 偏移,项目个数,符合项目个数的 内容
	local _tokenX,_tokenY,_tokenOffY,_num = 48,-160,106,2
	local _labT = {
		{"+ 1000","x 80","1000"},
		{"+ 2200","x 160","2200"},
	}
	local _creatFuStoneItem = function(x,y,offy,num,labT)
		for i = 1,num do
			_childUI["pvptokenbg_"..i] = hUI.image:new({
				parent = _parent,
				model = "UI:MADEL_BANNER",
				x = _w/2,
				y = _tokenY - (i-1) * offy,
				h = 60,
				w = _w - 40,
			})
			_childUI["pvptoken_"..i] = hUI.image:new({
				parent = _parent,
				model = "UI:pvptoken",
				x = _tokenX,
				y = _tokenY - (i-1) * offy,
			})
			_childUI["pvptoken1Tip_"..i] = hUI.label:new({
				border = 1,
				parent = _parent,
				font = "numWhite",
				size = 18,
				text = labT[i][1],
				align = "LT",
				width = 200,
				x = _childUI["pvptoken_"..i].data.x + 20,
				y = _childUI["pvptoken_"..i].data.y + 14,
			})
			
			_childUI["gamecoin_need"..i] = hUI.label:new({
				border = 1,
				parent = _parent,
				font = hVar.FONTC,
				size = 24,
				text = hVar.tab_string["__TEXT_NEED"],
				align = "MC",
				width = 200,
				x = _w/2 + 8,
				y = _tokenY - (i-1) * offy + 2,
			})

			_childUI["gamecoin_"..i] = hUI.image:new({
				parent = _parent,
				model = "UI:game_coins",
				x = _w/2 + 60,
				y = _tokenY - (i-1) * offy + 4,
				scale = 0.8,

			})

			_childUI["gamecoin_lab"..i] = hUI.label:new({
				border = 1,
				parent = _parent,
				size = 18,
				text = labT[i][2],
				font = "numWhite",
				align = "LT",
				width = 200,
				x = _w/2+80,
				y = _tokenY - (i-1) * offy + 14,
			})
			
			_childUI["buy_btn_"..i] = hUI.button:new({
				parent = _frm,
				model = "UI:ConfimBtn1",
				x = _w - 72,
				y = _tokenY - (i-1) * offy+2,
				scale = 0.9,
				scaleT = 0.9,
				code = function(self)
					--g_NetManager:sendGamePacket(hVar.PVP_DB_OPR_TYPE.C2L_REQUIRE, hVar.PVP_DB_OPR_TYPE.C2L_BUY_PVP_COIN,)
					g_NetManager:sendGamePacket(hVar.PVP_OPERATE_TYPE.C2L_PLAYER_NET_SAVE_UPDATE,hVar.NET_SAVE_OPR_TYPE.C2L_BUY_PVP_COIN,0,labT[i][3])
				end,
			})
		end
	end
	_creatFuStoneItem(_tokenX,_tokenY,_tokenOffY,_num,_labT)

	
	--显示面板
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_frm:show(1)
		_frm:active()
	end)

	--切地图隐藏
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","__UI__HideBuyFuStoneFrame",function()
		_frm:show(0)
	end)

end