g_vip_data = {
	YJ_FREE_COUNT = 0,	--炎精
	CP_BUY_COUNT = 0,	--积分换卡
	CP_FREE_COUNT = 0,	--免费领卡
}
	--yanRest = 0--炎精
	--cardC = 0--换卡
	--cardF = 0--领卡

local getYan = nil
local getCard = nil
hGlobal.UI.InitVipLogic = function()
	hGlobal.event:listen("LocalEvent_VIP_REC_State","reflashVipGift",function(count_1,count_2,count_3)
		g_vip_data.YJ_FREE_COUNT = count_1
		g_vip_data.CP_BUY_COUNT = count_2
		g_vip_data.CP_FREE_COUNT = count_3
		hGlobal.event:event("LocalEvent_YAN_AND_CARD",g_vip_data.YJ_FREE_COUNT,math.max(g_vip_data.CP_BUY_COUNT,g_vip_data.CP_FREE_COUNT))
	end)
	hGlobal.event:listen("LocalEvent_VIP_REC_Result","reflashVipGift",function(iErrorCode,count_1,count_2,count_3,pTag)
		if iErrorCode == 0 then
			local yj_count = g_vip_data.YJ_FREE_COUNT
			g_vip_data.YJ_FREE_COUNT = count_1
			g_vip_data.CP_BUY_COUNT = count_2
			g_vip_data.CP_FREE_COUNT = count_3
			hGlobal.event:event("LocalEvent_showVipGetFrm",1,LuaGetPlayerVipLv())
			if pTag == hVar.VIP_REC_TYPE.RECEIVE then
				LuaSetPlayerMaterial(3,LuaGetPlayerMaterial(3) + yj_count)
			elseif pTag == hVar.VIP_REC_TYPE.CHANGECARD then
				LuaAddPlayerScore(-300)
				local typ,ex,val = unpack(hVar.tab_item[9101].used)
				hApi.UnitGetLoot(oUnit,typ,ex,val,nil,nil,nil,nil,{9101})
			elseif pTag == hVar.VIP_REC_TYPE.GETCARD then
				
				local typ,ex,val = unpack(hVar.tab_item[9101].used)
				hApi.UnitGetLoot(oUnit,typ,ex,val,nil,nil,nil,nil,{9101})
			end
			LuaSavePlayerData(g_localfilepath,g_curPlayerName,Save_PlayerData,Save_PlayerLog)
		end
	end)
end

hGlobal.UI.InitVipGetFrm = function(mode)
	local tInitEventName = {"LocalEvent_showVipGetFrm","__UI__showVipGetFrm"}
	if mode~="include" then
		return tInitEventName
	end
	hGlobal.UI.VipGetFrm = hUI.frame:new({
		x = hVar.SCREEN.w/2 - 175,
		y = hVar.SCREEN.h/2 + 125,
		dragable = 4,
		w = 350,
		h = 250,
		--z = -1,
		show = 0,
		--autoactive = 0,
		background = "UI:TileFrmBack",
		codeOnTouch = function()
			--hGlobal.event:event("LocalEvent_ShowItemTipFram",nil,nil,0)
		end,
	})

	local _frm = hGlobal.UI.VipGetFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI
	_frm:showBorder(1)

	local restCard = 0--剩余的免费卡包
	local restYan = 0
	local changeOrFree = 0--0换 1领
	local cardButtonStr = ""
	_childUI["btnClose"] = hUI.button:new({
		parent = _frm,
		model = "BTN:PANEL_CLOSE",
		x = 342,
		y = -8,
		--w = hVar.CloseButtonWH[1],
		--h = hVar.CloseButtonWH[2],
		scaleT = 0.9,
		code = function(self)
			hGlobal.event:event("LocalEvent_showVipGetFrm",0)
		end,
	})

	_childUI["vipgetinfo"]= hUI.label:new({
		parent = _parent,
		x = 90,
		y = -30,
		w = 100,
		h = 80,
		width = 420,
		text = hVar.tab_string["vipGetInfo"],
		font = hVar.FONTC,
		size = 28,
	})
	--_childUI["gift_get_info"].handle._n:setVisible(false)
	
	--_childUI["yanBg"] = hUI.image:new({
		--parent = _parent,
		--model = "misc/card_select_back.png",
		--x = 80,
		--y = -92,
		--w = 90,
		--h = 40,
	--})

	_childUI["yan"] = hUI.image:new({
		parent = _parent,
		model = "UI:item_res_gem",
		x = 70,
		y = -115,
		w = 42,
		h = 42,
	})

	_childUI["yanRest"]= hUI.label:new({
		parent = _parent,
		x = 90,
		y = -105,
		w = 100,
		h = 80,
		width = 420,
		text = "",
		font = hVar.FONTC,
		size = 31,
	})
	getYan = _childUI["yanRest"]

	_childUI["yanGet"]= hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:ButtonBack2",
		x = 90,
		y = -200,
		w = 106,
		h = 38,
		label = hVar.tab_string["MadelGiftGet"],
		font = hVar.FONTC,
		scaleT = 0.9,
		code = function(self)
			SendCmdFunc["send_VIP_REC_State"](hVar.VIP_REC_TYPE.RECEIVE,g_vip_data.YJ_FREE_COUNT,hVar.VIP_REC_TYPE.RECEIVE)
		end,
	})

	--_childUI["cardBg"] = hUI.image:new({
		--parent = _parent,
		--model = "misc/card_select_back.png",
		--x = 200,
		--y = -90,
		--w = 100,
		--h = 45,
	--})

	_childUI["card"] = hUI.image:new({
		parent = _parent,
		model = "icon/item/card_lv1.png",
		x = 240,
		y = -117,
		w = 50,
		h = 50,
	})

	_childUI["cardRest"]= hUI.label:new({
		parent = _parent,
		x = 260,
		y = -107,
		w = 100,
		h = 80,
		width = 420,
		text = "",
		font = hVar.FONTC,
		size = 31,
	})
	getCard = _childUI["cardRest"]

	_childUI["cardGet"]= hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "UI:ButtonBack2",
		x = 260,
		y = -200,
		w = 106,
		h = 38,
		label = hVar.tab_string["vipGet1"]..4,
		font = hVar.FONTC,
		scaleT = 0.9,
		code = function(self)
			if g_cur_net_state ~= 1 then return end
			if LuaGetPlayerVipLv() >= 5 then
				--SendCmdFunc["send_VIP_REC_State"](hVar.VIP_REC_TYPE.GETCARD,1,hVar.VIP_REC_TYPE.GETCARD)
				--SendCmdFunc["buy_shopitem"](9101,0,"vip get card",0,tostring(luaGetplayerDataID()))
				SendCmdFunc["get_VIP_FBC"](0,0,9101,0)

				if g_vip_data.CP_FREE_COUNT == 1 then
					self:setstate(0)
				end
			elseif LuaGetPlayerVipLv() >= 2 then
				if LuaGetPlayerScore() >= 300 then
					--SendCmdFunc["send_VIP_REC_State"](hVar.VIP_REC_TYPE.CHANGECARD,1,hVar.VIP_REC_TYPE.CHANGECARD)
					SendCmdFunc["get_VIP_FBC"](0,300,9101,1)
					--SendCmdFunc["buy_shopitem"](9101,0,"vip change card",300,"sc:"..300)
					if g_vip_data.CP_BUY_COUNT == 1 then
						self:setstate(0)
					end
				end
			end	
		end,
	})

	_childUI["noScore"]= hUI.label:new({
		parent = _parent,
		x = 190,
		y = -200,
		w = 100,
		h = 80,
		width = 420,
		text = "",
		font = hVar.FONTC,
		size = 24,
		RGB = {255,0,0},
	})
	
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(bShow,viplv)
		if bShow == 1 then
			SendCmdFunc["get_VIP_REC_State"]()
			_childUI["noScore"]:setText("")
			_childUI["yanGet"]:setstate(0)
			_childUI["cardGet"]:setstate(0)
			_childUI["vipgetinfo"]:setText("VIP"..viplv.."  "..hVar.tab_string["vipGetInfo"])
			_childUI["yanRest"]:setText(" "..g_vip_data.YJ_FREE_COUNT)
			if viplv >= 5 then
				cardButtonStr = hVar.tab_string["vipGet1"]
			else
				cardButtonStr = hVar.tab_string["vipGet2"]
			end
			_childUI["cardGet"]:setText(cardButtonStr)
			_childUI["cardRest"]:setText(" "..0)

			if g_vip_data.CP_FREE_COUNT > 0 then
				_childUI["cardRest"]:setText(" "..g_vip_data.CP_FREE_COUNT)
				_childUI["cardGet"]:setstate(1)
			elseif g_vip_data.CP_BUY_COUNT > 0 then
				_childUI["cardRest"]:setText(" "..g_vip_data.CP_BUY_COUNT)
				_childUI["cardGet"]:setstate(1)
			end
			if g_vip_data.YJ_FREE_COUNT > 0 then
				_childUI["yanGet"]:setstate(1)
			end
			
			if viplv < 5 and LuaGetPlayerScore() < 300 then
				_childUI["cardGet"]:setstate(0)
				_childUI["noScore"]:setText(hVar.tab_string["noenoughscore"])
			end
			_frm:active()
		end
		_frm:show(bShow)
	end)

	hGlobal.event:listen("LocalEvent_YAN_AND_CARD","reflashVipGift",function(y,c)
		_childUI["cardRest"]:setText(" "..c)
		_childUI["yanRest"]:setText(" "..y)
	end)
end