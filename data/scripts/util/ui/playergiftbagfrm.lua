------------
--礼包奖励的临时仓库面板，数据来源是 save_playerdata.giftbag
--
------------
hGlobal.UI.InitPlayerGiftBagFrm = function(mode)
	local tInitEventName = {"localEvent_ShowPlayerGiftBagFrm","showthisFrm"}
	if mode~="include" then
		return tInitEventName
	end
	local _x,_y,_w,_h = hVar.SCREEN.w/2 - 460,hVar.SCREEN.h/2 + 300,920,600
	hGlobal.UI.PlayerGiftBagFrm = hUI.frame:new({
		x = _x,
		y = _y,
		dragable = 2,
		w = _w,
		h = _h,
		titlebar = 0,
		show = 0,
		bgAlpha = 0,
		bgMode = "tile",
		background = "UI:tip_item",
		border = 1,
		autoactive = 0,
		closebtn = "BTN:PANEL_CLOSE",
		closebtnX = _w-10,
		closebtnY = -14,
		codeOnClose = function()
			--每次关闭时都要检测一次是否还继续显示
			hGlobal.event:event("LocalEvent_setGiftBtnState",-1)
		end
	})
	
	local _frm = hGlobal.UI.PlayerGiftBagFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	--提示文字title
	_childUI["tipLab"] =  hUI.label:new({
		parent = _parent,
		x = _w/2,
		y = -50,
		text = hVar.tab_string["__TEXT_PleaseChoose"],
		size = 30,
		width = _w-64,
		font = hVar.FONTC,
		align = "MC",
		border = 1,
	})
	
	local _cur_index = 0
	--面板的结束方法
	local _RemoveList = {}
	local _btnState = {}
	local _exitFunc = function()
		for i = 1,#_RemoveList do
			hApi.safeRemoveT(_childUI,_RemoveList[i])
		end
		_RemoveList = {}
		
		--初始化按钮状态
		for i = 1,#_btnState do 
			_btnState[i] = 0
		end
	end

	--确定按钮
	_childUI["confirmBtn"] =  hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		--model = "UI:ConfimBtn1",
		label = hVar.tab_string["__Get__"],
		x = _frm.data.w/2,
		y = -_frm.data.h + 30,
		scaleT = 0.9,
		code = function()
			_frm:show(0)
			if LuaGetItemFromPlayerGiftBag(_cur_index) == 1 then
				hGlobal.event:event("LocalEvent_setGiftBtnState",-1)
			else
				hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_BAGLISTISFULL"],{
					font = hVar.FONTC,
					ok = function()
					end,
				})
			end
			_exitFunc()
		end,
	})
	
	local _itemX,_itemY,_itemOffX,itemOffY,_itemW = 110,-120,100,90,60
	--选中框
	_childUI["giftSelectBox"] = hUI.image:new({
		parent = _parent,
		model = "UI:skillup",
		w = _itemW+20,
		h = _itemW+20,
		z = 10,
	})
	_childUI["giftSelectBox"].handle._n:setVisible(false)

	--创建40个道具槽子
	for i = 1,40 do
		_btnState[i] = 0
		_childUI["giftItem_bg_"..i] = hUI.button:new({
			parent = _parent,
			model = "UI_frm:slot",
			animation = "lightSlim",
			dragbox = _childUI["dragBox"],
			x = _itemX + (i-1)%8*_itemOffX,
			y = _itemY - math.ceil((i-8)/8)*itemOffY,
			w = _itemW,
			h = _itemW,
			code = function(self)
				if _btnState[i] == 1 then
					_cur_index = i
					local oItem = luaGetItemOBJByPlayerGiftBag(i)
					
					if type(oItem) == "table" then
						local tempX = 0
						--在左边显示
						if math.ceil(i/4) % 2 == 0 then
							tempX = 110
						--在右边显示
						elseif math.ceil(i/4) % 2 == 1 then
							tempX = 640
						end
						
						hGlobal.event:event("LocalEvent_ShowItemTipFram",{oItem},nil,1,tempX,_y)
					end
					
					_childUI["giftSelectBox"].handle._n:setPosition(self.data.x,self.data.y)
					_childUI["giftSelectBox"].handle._n:setVisible(true)
					_childUI["confirmBtn"]:setstate(1)
				end
			end,
		})
	end
	
	--根据玩家礼品背包中的道具信息创建 道具图片
	local _createGiftBagInfo = function(itemList)
		for i = 1,#_RemoveList do
			hApi.safeRemoveT(_childUI,_RemoveList[i])
		end
		_RemoveList = {}
		local tempID = 0
		for i = 1, #itemList, 1 do
			if type(itemList[i]) == "table" then
				_btnState[i] = 1
				tempID = itemList[i][1]
				
				local itemLv = hVar.tab_item[tempID].itemLv or 1
				_childUI["giftItem_image_bg_"..i] = hUI.image:new({
					parent = _parent,
					model = hVar.ITEMLEVEL[itemLv].BORDERMODEL,
					x = _itemX + (i-1)%8*_itemOffX,
					y = _itemY - math.ceil((i-8)/8)*itemOffY,
					w = _itemW,
					h = _itemW,
				})
				_RemoveList[#_RemoveList+1] = "giftItem_image_bg_"..i
				
				_childUI["giftItem_image_bg_"..i].handle.s:setOpacity(155)
				
				_childUI["giftItem_image_"..i] = hUI.image:new({
					parent = _parent,
					model = hVar.tab_item[tempID].icon,
					x = _itemX + (i-1)%8*_itemOffX,
					y = _itemY - math.ceil((i-8)/8)*itemOffY,
					w = _itemW,
					h = _itemW,
				})
				_RemoveList[#_RemoveList+1] = "giftItem_image_"..i
			end
		end
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(giftList)
		_childUI["confirmBtn"]:setstate(0)
		_cur_index = 0
		_childUI["giftSelectBox"].handle._n:setVisible(false)
		--创建礼品信息
		_createGiftBagInfo(giftList)
		
		_frm:show(1)
		_frm:active()
	end)
end