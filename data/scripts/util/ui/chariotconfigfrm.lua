--战车背包界面
hGlobal.UI.InitChariotItemFrm = function(mode)
	local tInitEventName = {"localEvent_ShowChariotItemFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _frm,_childUI,_parent = nil,nil,nil
	local _nMode = 0
	local _fCallback = nil --回调事件
	local _nBoardW,_nBoardH = 620,718
	local _tItemList = {}
	local _nUnShowTypeBtn = 1
	local _nCurPage = 1
	local _nMaxPage = 5
	local _nChip = 0
	
	local _nItemGirdLine,_nItemGirdCow = hVar.PLAYERBAG_X_NUM,hVar.PLAYERBAG_Y_NUM -- 6, 5
	local _ItemMiniLen = _nItemGirdLine * _nItemGirdCow --每一个分页的背包长度
	local _nItemGridX,_nItemGridY = 78,-80
	local _nItemGridW,_nItemGridH = hVar.EquipWH,hVar.EquipWH
	local _nItemGridDiffW,_nItemGridDiffH = 93,93

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CloseFrm = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateUI = hApi.DoNothing
	local _CODE_CreateItemGrid  = hApi.DoNothing
	local _CODE_ClickTypeBtn = hApi.DoNothing
	local _CODE_GetData = hApi.DoNothing
	local _CODE_UpdateItem = hApi.DoNothing
	local _CODE_ClickButton = hApi.DoNothing
	local _CODE_ChangePage = hApi.DoNothing
	local _CODE_TidyEquip = hApi.DoNothing
	
	_CODE_ClearFunc = function()
		if hGlobal.UI.ChariotItemFrm then
			hGlobal.UI.ChariotItemFrm:del()
			hGlobal.UI.ChariotItemFrm = nil
		end
		_frm,_childUI,_parent = nil,nil,nil
		_tItemList = {}
		--print("_CODE_ClearFunc _tItemList")
	end
	
	_CODE_CloseFrm = function()
		hGlobal.event:event("LocalEvent_RecoverBarrage")
		_nCurPage = 1
		_nMode = 0
		_CODE_ClearFunc()
		
		--回调事件
		if (type(_fCallback) == "function") then
			_fCallback()
		end
	end
	
	_CODE_CreateFrm = function(ntype)
		hGlobal.UI.ChariotItemFrm  = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			dragable = 0,
			show = 0,
			--z = -1,
			z = hZorder.MainBaseFirstFrm + 1,
			buttononly = 1,
		})
		_frm = hGlobal.UI.ChariotItemFrm
		_childUI = _frm.childUI
		_parent = _frm.handle._n

		_childUI["_blackpanel"] = hUI.image:new({
			parent = _parent,
			model = "UI:zhezhao",
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h/2,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = -1,
		})
		_frm.childUI["_blackpanel"].handle.s:setOpacity(160)
		
		_frm:show(1)
		_frm:active()
	end

	_CODE_CreateUI = function()
		_childUI["btn_closeBoard"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			dragbox = _childUI["dragBox"],
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h/2,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			code = function()
				_CODE_CloseFrm()
			end,
		})
		
		_childUI["img_board"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			--model = "UI:board_bg",
			dragbox = _childUI["dragBox"],
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h/2,
			w = _nBoardW,
			h = _nBoardH,
		})
		
		_childUI["btn_bin"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/button_null.png",
			x = hVar.SCREEN.w/2 + 136,
			y = -hVar.SCREEN.h/2 + _nBoardH/2 - 30,
			w = 60,
			h = 60,
			z = 2,
			scaleT = 0.9,
			code = function()
				hGlobal.event:event("localEvent_ShowClearEquipFrm")
			end,
		})
		
		_childUI["btn_bin"].childUI["img"] = hUI.image:new({
			parent = _childUI["btn_bin"].handle._n,
			model = "ICON:CHIP_RECYCLE",
			scale = 0.8,
		})
		--_childUI["btn_bin"]:setstate(-1)

		--if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then
			--_childUI["btn_bin"]:setstate(1)
		--end
		
		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/btn_close.png",
			x = hVar.SCREEN.w/2 + _nBoardW/2 - 88,
			y = -hVar.SCREEN.h/2 + _nBoardH/2 - 38,
			scale = 0.9,
			scaleT = 0.9,
			z = 2,
			code = function()
				_CODE_ClearFunc()
				hGlobal.event:event("LocalEvent_RecoverBarrage")
				
				--回调事件
				if (type(_fCallback) == "function") then
					_fCallback()
				end
			end,
		})
		
		_childUI["btn_clickleft"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/chariotconfig/arrow_l.png",
			x = hVar.SCREEN.w/2 - 104,
			y = -hVar.SCREEN.h/2 - _nBoardH/2 + 48,
			scale = 0.8,
			scaleT = 0.9,
			z = 2,
			code = function()
				_CODE_ChangePage(-1)
			end,
		})

		_childUI["btn_clickright"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/chariotconfig/arrow_r.png",
			x = hVar.SCREEN.w/2 + 104,
			y = -hVar.SCREEN.h/2 - _nBoardH/2 + 48,
			scale = 0.8,
			scaleT = 0.9,
			z = 2,
			code = function()
				_CODE_ChangePage(1)
			end,
		})

		_childUI["btn_tidy"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/chariotconfig/tidy.png",
			x = hVar.SCREEN.w/2 + 200,
			y = -hVar.SCREEN.h/2 - _nBoardH/2 + 48,
			--w = 50,
			--h = 50,
			scaleT = 0.9,
			z = 2,
			code = function()
				_CODE_TidyEquip()
			end,
		})
		
		--跳转英雄装备栏的按钮
		--if _nMode == 1 then
			_childUI["btn_goequip"] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				model = "misc/chariotconfig/go_equips.png",
				x = hVar.SCREEN.w/2 - _nBoardW/2 + 84,
				y = -hVar.SCREEN.h/2 - _nBoardH/2 + 48,
				scale = 0.9,
				scaleT = 0.9,
				z = 2,
				code = function()
					_CODE_ClearFunc()
					hGlobal.event:event("LocalEvent_ShowChariotEquipFrm", _fCallback)
				end,
			})
			--跳转英雄装备栏的按钮叹号
			_childUI["btn_goequip"].childUI["lvup"] = hUI.image:new({
				parent = _childUI["btn_goequip"].handle._n,
				model = "UI:TaskTanHao",
				x = 15 - 30,
				y = 25 - 5 + 5,
				scale = 1.2,
			})
			local act1 = CCMoveBy:create(0.2, ccp(0, 6))
			local act2 = CCMoveBy:create(0.2, ccp(0, -6))
			local act3 = CCMoveBy:create(0.2, ccp(0, 6))
			local act4 = CCMoveBy:create(0.2, ccp(0, -6))
			local act5 = CCDelayTime:create(0.6)
			local act6 = CCRotateBy:create(0.1, 10)
			local act7 = CCRotateBy:create(0.1 * 1, -10 * 2)
			local act8 = CCRotateBy:create(0.1 * 1, 10 * 2)
			local act9 = CCRotateBy:create(0.1, -10)
			local act10 = CCDelayTime:create(0.8)
			local a = CCArray:create()
			a:addObject(act1)
			a:addObject(act2)
			a:addObject(act3)
			a:addObject(act4)
			a:addObject(act5)
			a:addObject(act6)
			a:addObject(act7)
			a:addObject(act8)
			a:addObject(act9)
			a:addObject(act10)
			local sequence = CCSequence:create(a)
			_childUI["btn_goequip"].childUI["lvup"].handle._n:runAction(CCRepeatForever:create(sequence))
			_childUI["btn_goequip"].childUI["lvup"].handle._n:setVisible(false) --默认隐藏
			
			--检测是否有背包的道具可装备到英雄身上
			local bHaveBagTakeOnEquip = hApi.CheckBagTakeOnEquip()
			local bShowNotice = (bHaveBagTakeOnEquip)
			_childUI["btn_goequip"].childUI["lvup"].handle._n:setVisible(bShowNotice)
		--end
		
		_childUI["lab_page"] = hUI.label:new({
			parent = _parent,
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h/2 - _nBoardH/2 + 52,
			text =  tostring(_nCurPage) .." / " .. tostring(_nMaxPage),
			size = 24,
			font = hVar.FONTC,
			width = 300,
			align = "MC",
		})
		
		_childUI["img_bg"] = hUI.image:new({
			parent = _parent,
			model = "misc/chariotconfig/storehousebg.png",
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h/2,
			z = -1,
		})

		_childUI["img_chip"] = hUI.image:new({
			parent = _parent,
			model = "ICON:CHIP_BROKEN",
			x = hVar.SCREEN.w/2 - 160,
			y = -hVar.SCREEN.h/2 + 328,
		})
		
		_childUI["img_chip"] = hUI.label:new({
			parent = _parent,
			x = hVar.SCREEN.w/2 - 124,
			y = -hVar.SCREEN.h/2 + 328,
			size = 24,
			align = "LC",
			font = "numWhite",
			text = tostring(_nChip),
		})
		
		--查询玩家碎片数量
		SendCmdFunc["get_mycoin"]()
	end
	
	_CODE_CreateItemGrid = function()
		local startX = hVar.SCREEN.w/2 -_nBoardW/2 + _nItemGridX
		local startY = - hVar.SCREEN.h/2 + _nBoardH/2 + _nItemGridY
		for i = 1,_nItemGirdLine do
			for j = 1,_nItemGirdCow do
				local index = (i - 1) * _nItemGirdCow + j
				--print("_nCurPage=", _nCurPage)
				_childUI["btn_grid"..index] = hUI.button:new({
					parent = _parent,
					--model = "misc/chariotconfig/itemgrid.png",
					--model = "misc/mask.png",
					model = "misc/button_null.png",
					dragbox = _childUI["dragBox"],
					x = startX + (j-0.5) * _nItemGridDiffW,
					y = startY - (i-0.5) * _nItemGridDiffH,
					w = _nItemGridW,
					h = _nItemGridH,
					code = function()
						--index加上页数
						local index2 = (i - 1) * _nItemGirdCow + j + (_nCurPage - 1) * _ItemMiniLen
						print(index2)
						_CODE_ClickButton(index2)
					end,
				})
			end
		end
	end

	_CODE_ChangePage = function(param)
		local page = _nCurPage + param
		if page >= 1 and page <= _nMaxPage then
			_nCurPage = page
			_childUI["lab_page"]:setText(tostring(_nCurPage) .." / " .. tostring(_nMaxPage))
			_CODE_GetData()
			_CODE_UpdateItem()
		end
	end

	_CODE_TidyEquip = function()
		--LuaRecordEquipPosInfo
		LuaTidyStorehouse()
		_nCurPage = 1
		_childUI["lab_page"]:setText(tostring(_nCurPage) .." / " .. tostring(_nMaxPage))
		_CODE_GetData()
		_CODE_UpdateItem()
	end
	
	_CODE_GetData = function()
		_tItemList = {}
		local storehouse = LuaGetStoreHouse()
		if (type(storehouse) == "table") then
			--table_print(playerbag)
			for i = 1, _ItemMiniLen, 1 do
				local index = (_nCurPage - 1) * _ItemMiniLen + i
				local uid = storehouse[index]
				local _,oEquip = LuaFindEquipByUniqueId(uid)
				--_tItemList[i] = oEquip
				_tItemList[index] = oEquip
				--print("_CODE_GetData", index,oEquip)
			end
		end
		
		--_tItemList[1] = 20005
		--_tItemList[2] = 20012
	end
	
	_CODE_UpdateItem = function()
		print("_CODE_UpdateItem")
		hApi.safeRemoveT(_childUI,"node_item")
		local startX = hVar.SCREEN.w/2 -_nBoardW/2 + _nItemGridX
		local startY = - hVar.SCREEN.h/2 + _nBoardH/2 + _nItemGridY
		_childUI["node_item"] = hUI.node:new({
			parent = _parent,
			model = "misc/mask.png",
			--model = "misc/button_null.png",
			x = startX,
			y = startY,
			w = 10,
			h = 10,
		})
		local nodeChildUI = _childUI["node_item"].childUI
		local nodeParent = _childUI["node_item"].handle._n
		for i = 1,_nItemGirdLine do
			for j = 1,_nItemGirdCow do
				local index = (i - 1) * _nItemGirdCow + j + (_nCurPage - 1) * _ItemMiniLen
				--local index = (i - 1) * _nItemGirdCow + j
				--print("index=", index,_tItemList[index])
				if type(_tItemList[index]) == "table" then
					local id = _tItemList[index][hVar.ITEM_DATA_INDEX.ID]
					local tabI = hVar.tab_item[id] or {}
					local quality = _tItemList[index][hVar.ITEM_DATA_INDEX.QUALITY] or 0
					local level = tabI.itemLv or 1
					local backmodel = hVar.ITEMLEVEL[level].BACKMODEL
						
					nodeChildUI["itembg"..index] = hUI.image:new({
						parent = nodeParent,
						model = backmodel,
						x = (j-0.5) * _nItemGridDiffW,
						y = - (i-0.5) * _nItemGridDiffH,
					})

					nodeChildUI["item"..index] = hUI.image:new({
						parent = nodeParent,
						--model = "misc/chariotconfig/item1.png",
						model = tabI.icon,
						x = (j-0.5) * _nItemGridDiffW,
						y = - (i-0.5) * _nItemGridDiffH,
						w = _nItemGridW,
						h = _nItemGridH,
					})
				end
			end
		end
	end

	_CODE_ClickButton = function(nIndex)
		if _tItemList[nIndex] and _tItemList[nIndex] ~= 0 then
			local tPos = {"storehouse",nIndex}
			MoveEquipManager.RecordPos2(tPos)
			local tPos1 = MoveEquipManager.GetPos1()
			local _,oEquip2 = LuaFindEquipByPos(tPos1)
			--table_print(_tItemList[nIndex])
			local showmode = 2
			if _nMode == 1 then
				showmode = 3
			end
			hGlobal.event:event("localEvent_ShowItemTipFrm",_tItemList[nIndex],showmode,oEquip2)
		end
	end
	
	--刷新背包栏
	hGlobal.event:listen("localEvent_UpdateChariotItemFrm", "UpdateChariotItem", function()
		if _frm and _frm.data.show == 1 then
			_CODE_ClearFunc()
			_CODE_CreateFrm()
			_CODE_CreateUI()
			_CODE_CreateItemGrid()
			_CODE_GetData()
			_CODE_UpdateItem()
		end
	end)

	hGlobal.event:listen("LocalEvent_SpinScreen","ChariotItemFrm",function()
		if _frm and _frm.data.show == 1 then
			_CODE_ClearFunc()
			_CODE_CreateFrm()
			_CODE_CreateUI()
			_CODE_CreateItemGrid()
			_CODE_GetData()
			_CODE_UpdateItem()
		end
	end)

	hGlobal.event:listen("LocalEvent_refreshafterSpinScreen","ChariotItemFrm",function()
		if _frm and _frm.data.show == 1 then
			_frm:active()
		end
	end)

	hGlobal.event:listen("localEvent_CloseChariotItemFrm", "UpdateChariotItem", function()
		_CODE_CloseFrm()
	end)
	
	--分解
	--出售装备事件（背包界面）
	hGlobal.event:listen("LocalEvent_DescomposeRedEquip_Result", "DescomposeChariotItem", function(iteminfo)
		if _frm and _frm.data.show == 1 then
			_CODE_ClearFunc()
			_CODE_CreateFrm()
			_CODE_CreateUI()
			_CODE_CreateItemGrid()
			_CODE_GetData()
			_CODE_UpdateItem()
		end
	end)

	hGlobal.event:listen("LocalEvent_GetGameResource", "ChariotItem",function(gamecoin, pvpcoin, crystal, evaluateE, redscroll, weaponChestNum, tacticChestNum, petChestNum, equipChestNum, scientistNum, tankDeadthCount, dishuCoin)
		_nChip = crystal
		if _frm then
			_childUI["img_chip"]:setText(tostring(_nChip))
		end
	end)
	
	--"localEvent_ShowChariotItemFrm"
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(nmode, callback)
		print(nmode)
		_CODE_ClearFunc()
		_nMode = nmode or 0
		_fCallback = callback --存储回调事件
		_nMaxPage = LuaGetPlayerBagPageNum(LuaGetPlayerVipLv())
		_CODE_CreateFrm()
		_CODE_CreateUI()
		_CODE_CreateItemGrid()
		_CODE_GetData()
		_CODE_UpdateItem()
	end)
end

hGlobal.UI.InitConfirmDelRedEpuipFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowConfirmDelRedEpuipFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _frm, _childUI,_parent = nil,nil,nil
	local _width,_height = 480,320

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateUI = hApi.DoNothing
	local _CODE_AddEvent = hApi.DoNothing
	local _CODE_ClearEvent = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.ConfirmDelRedEpuipFrm then
			hGlobal.UI.ConfirmDelRedEpuipFrm:del()
			hGlobal.UI.ConfirmDelRedEpuipFrm = nil
		end
		_frm, _childUI,_parent = nil,nil,nil
		_CODE_ClearEvent()
	end

	_CODE_AddEvent = function()
		hGlobal.event:listen("LocalEvent_SpinScreen","ConfirmDelRedEpuipFrm",function()
			if _frm and _frm.data.show == 1 then
				_CODE_ClearFunc()
				_CODE_CreateFrm()
			end
		end)
	end

	_CODE_ClearEvent = function()
		hGlobal.event:listen("LocalEvent_SpinScreen","ConfirmDelRedEpuipFrm",nil)
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.ConfirmDelRedEpuipFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			dragable = 0,
			show = 0,
			z = hZorder.EquipTip + 2,
		})
		_frm = hGlobal.UI.ConfirmDelRedEpuipFrm
		_childUI = _frm.childUI
		_parent = _frm.handle._n

		_CODE_CreateUI()

		_frm:show(1)
		_frm:active()
	end

	_CODE_CreateUI = function()
		local offx = hVar.SCREEN.w/2
		local offy = - hVar.SCREEN.h/2
		_childUI["btn_close"] =  hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			--model = "misc/mask.png",
			model = "misc/button_null.png",
			x = offx,
			y = offy,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			code = function()
				_CODE_ClearFunc()
			end,
		})

		_childUI["btn_border"] =  hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/msgbox4.png",
			x = offx,
			y = offy,
			w = _width,
			h = _height,
		})

		_childUI["lab_title"] = hUI.label:new({
			parent = _parent,
			align = "MC",
			size = 28,
			font = hVar.FONTC,
			border = 0,
			text = hVar.tab_string["__TEXT_Confirm_delREquip"],
			x = offx,
			y = offy + _height/2 - 100,
		})

		_childUI["btn_cancel"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			label = {text = hVar.tab_string["__TEXT_Cancel"],size = 24,border = 1,font = hVar.FONTC,y = 2},
			x = offx - 90,
			y = offy - _height/2 + 100,
			w = 120,
			h = 54,
			model = "misc/addition/cg.png",
			scaleT = 0.9,
			code = function(self)
				_CODE_ClearFunc()
			end,
		})

		_childUI["btn_ok"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			label = {text = hVar.tab_string["Exit_Ack"],size = 24,border = 1,font = hVar.FONTC,y = 2},
			x = offx + 90,
			y = offy - _height/2 + 100,
			w = 120,
			h = 54,
			model = "misc/addition/cg.png",
			scaleT = 0.9,
			code = function(self)
				hGlobal.event:event("LocalEvent_ConfirmDelRedEquip")
				_CODE_ClearFunc()
			end,
		})
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_CODE_ClearFunc()
		_CODE_CreateFrm()
		_CODE_AddEvent()
	end)
end

--装备tip界面
hGlobal.UI.InitItemTipFrm = function(mode)
	local tInitEventName = {"localEvent_ShowItemTipFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _frm,_childUI,_parent = nil,nil,nil
	local _nItemId = nil
	local _nMode = 0
	local _tItem1 = nil
	local _tItem2 = nil
	local _nBagIdx1 = 0 --装备1所在背包（装备）索引
	local _nBagIdx2 = 0 --装备2所在背包（装备）索引
	local _bShowAccessWay = false
	
	local _nBoardW = 354
	local _nItemGridW,_nItemGridH = hVar.EquipWH,hVar.EquipWH
	local _tBtnDefine = {
		--[1] = "强化",
		[1] = "分解",
		[2] = hVar.tab_string["__TEXT_Page_Equip"], --"装备",
		[3] = hVar.tab_string["__TEXT_remove"],--"卸载",
		[4] = hVar.tab_string["__TEXT_Change"],--"更换",
		[5] = hVar.tab_string["__ITEM_PANEL__PAGE_XILIAN"], --"洗炼",
	}

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateItemInfo = hApi.DoNothing
	local _CODE_CreateButton = hApi.DoNothing
	local _CODE_GetButtonInfo = hApi.DoNothing
	local _CODE_ClickButton = hApi.DoNothing
	local _CODE_ShowItem = hApi.DoNothing
	local _CODE_DelEquip = hApi.DoNothing
	local _CODE_ConfirmDelEquip =hApi.DoNothing
	
	_CODE_ClearFunc = function()
		if hGlobal.UI.ItemTipFrm then
			hGlobal.UI.ItemTipFrm:del()
			hGlobal.UI.ItemTipFrm = nil
		end
		_frm,_childUI,_parent = nil,nil,nil
		_nItemId = nil
		_nMode = 0
		_nBagIdx1 = 0
		_nBagIdx2 = 0
		_tItem1 = nil
		_tItem2 = nil
	end
	
	_CODE_CreateFrm = function()
		hGlobal.UI.ItemTipFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			z = hZorder.EquipTip,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			dragable = 0,
			show = 0,
			z = hZorder.EquipTip,
			buttononly = 1,
		})
		_frm = hGlobal.UI.ItemTipFrm
		_childUI = _frm.childUI
		_parent = _frm.handle._n

		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			dragbox = _childUI["dragBox"],
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h/2,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = -2,
			code = function()
				_CODE_ClearFunc()
			end,
		})

		_CODE_ShowItem()

		_frm:show(1)
		_frm:active()
	end

	_CODE_CreateItemInfo = function(index,tItem,x,y)
		index = index or 1
		tItem = tItem or _tItem1
		local id = tItem[hVar.ITEM_DATA_INDEX.ID]
		local tabI = hVar.tab_item[id] or {}
		local lv = 1 -- tItem[hVar.ITEM_DATA_INDEX.UNKNOWN]
		local nodeX = x or hVar.SCREEN.w/2
		local nodeY = y or - 88
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
			nodeY = y or - 80
		end
		_childUI["node"..index] = hUI.node:new({
			parent = _parent,
			x = nodeX,
			y = nodeY,
		})

		local nodeChildUI = _childUI["node"..index].childUI
		local nodeParent = _childUI["node"..index].handle._n
		local countH = 148

		nodeChildUI["img_iconbg"] = hUI.image:new({
			parent = nodeParent,
			model = "misc/chariotconfig/itemgrid2.png",
			x = - _nBoardW/2 + 74,
			y = - 70,
		})

		local level = tabI.itemLv
		--装备品质
		local quality = tItem[hVar.ITEM_DATA_INDEX.QUALITY] or 0
		local backmodel = hVar.ITEMLEVEL[level].BACKMODEL
		
		nodeChildUI["img_itembg"] = hUI.image:new({
			parent = nodeParent,
			model = backmodel,
			x = - _nBoardW/2 + 74,
			y = - 70,
		})

		nodeChildUI["img_icon"] = hUI.image:new({
			parent = nodeParent,
			--model = "misc/chariotconfig/item1.png",
			model = tabI.icon,
			x = - _nBoardW/2 + 74,
			y = - 70,
			w = _nItemGridW,
			h = _nItemGridH,
		})
		
		local itemname = LuaGetObjectName(id,2)
		local iteminfo = hVar.ITEMLEVEL[level]
		local reward = tabI.reward
		local randreward = tabI.randreward
		
		nodeChildUI["lab_name"] = hUI.label:new({
			parent = nodeParent,
			x = 34,
			y = - 70 + 2,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			text = itemname,
			RGB = iteminfo.NAMERGB,
			border = 1,
		})
		
		local attr = {}
		--[[
		local attr = {
			{"动力",100},
			{"防火",20},
			{"装甲",50},
		}
		--]]
		
		--[[
		if (quality >= 0) then
			nodeChildUI["lab_quality"] = hUI.label:new({
				parent = nodeParent,
				x = 28 - _nBoardW/2,
				y = - countH,
				size = 24,
				font = hVar.FONTC,
				align = "LC",
				text = hVar.tab_string["__TEXT_Quality"], --"品质"
				RGB = {255, 255, 0,},
			})
			
			nodeChildUI["lab_quality_value"] = hUI.label:new({
				parent = nodeParent,
				x = 190 - _nBoardW/2,
				y = - countH,
				size = 24,
				font = hVar.FONTC,
				align = "LC",
				text = quality,
				RGB = {255, 255, 0,},
			})
			
			countH = countH + 32
		end
		]]
		--基础属性文字
		nodeChildUI["lab_quality"] = hUI.label:new({
			parent = nodeParent,
			x = 28 - _nBoardW/2,
			y = - countH,
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			text = "", --hVar.tab_string["__TEXT__ItemBaseAttr"], --"[基础属性]:"
			RGB = {255, 255, 168,},
			border = 1,
		})
		
		--countH = countH + 32 + 4
		
		--固定属性
		if reward then
			for i = 1, #reward, 1 do
				local key,strExpress = unpack(tabI.reward[i])
				local lv = 1
				--print(id,strExpress,quality)
				local value = hApi.AnalyzeValueExpr(nil, nil, {["@lv"] = lv,["@quality"] = quality,}, strExpress, 0)
				attr[i] = {hVar.tab_string[hVar.ItemRewardStr[key]],value, key}
			end
		end
		
		--随机属性
		if randreward then
			--随机属性1
			--randIdx1,,randIdx2,randVal2,randIdx3,randVal3,randIdx4,randVal4,randIdx5,randVal5,randSkillIdx1,randSkillLv1,randSkillIdx2,randSkillLv2,randSkillIdx3,randSkillLv3
			local randIdx1 = tItem[hVar.ITEM_DATA_INDEX.RAND_IDX1]
			local randVal1 = tItem[hVar.ITEM_DATA_INDEX.RAND_VAL1]
			if (randIdx1 > 0) then
				if randreward[randIdx1] then
					local key = randreward[randIdx1][1]
					local value = randVal1
					--print("随机属性1", key, value)
					attr[#attr+1] = {hVar.tab_string[hVar.ItemRewardStr[key]],value, key}
				end
			end
			
			--随机属性2
			local randIdx2 = tItem[hVar.ITEM_DATA_INDEX.RAND_IDX2]
			local randVal2 = tItem[hVar.ITEM_DATA_INDEX.RAND_VAL2]
			if (randIdx2 > 0) then
				if randreward[randIdx2] then
					local key = randreward[randIdx2][1]
					local value = randVal2
					--print("随机属性2", key, value)
					attr[#attr+1] = {hVar.tab_string[hVar.ItemRewardStr[key]],value, key}
				end
			end
			
			--随机属性3
			local randIdx3 = tItem[hVar.ITEM_DATA_INDEX.RAND_IDX3]
			local randVal3 = tItem[hVar.ITEM_DATA_INDEX.RAND_VAL3]
			if (randIdx3 > 0) then
				if randreward[randIdx3] then
					local key = randreward[randIdx3][1]
					local value = randVal3
					--print("随机属性3", key, value)
					attr[#attr+1] = {hVar.tab_string[hVar.ItemRewardStr[key]],value, key}
				end
			end
			
			--随机属性4
			local randIdx4 = tItem[hVar.ITEM_DATA_INDEX.RAND_IDX4]
			local randVal4 = tItem[hVar.ITEM_DATA_INDEX.RAND_VAL4]
			if (randIdx4 > 0) then
				if randreward[randIdx4] then
					local key = randreward[randIdx4][1]
					local value = randVal4
					--print("随机属性4", key, value)
					attr[#attr+1] = {hVar.tab_string[hVar.ItemRewardStr[key]],value, key}
				end
			end
			
			--随机属性5
			local randIdx5 = tItem[hVar.ITEM_DATA_INDEX.RAND_IDX5]
			local randVal5 = tItem[hVar.ITEM_DATA_INDEX.RAND_VAL5]
			if (randIdx5 > 0) then
				if randreward[randIdx5] then
					local key = randreward[randIdx5][1]
					local value = randVal5
					--print("随机属性5", key, value)
					attr[#attr+1] = {hVar.tab_string[hVar.ItemRewardStr[key]],value, key}
				end
			end
		end
		
		--展示属性
		if #attr > 0 then
			for i =1,#attr do
				local v1,v2, key = unpack(attr[i])
				v2 = tonumber(v2)
				
				if (hVar.ItemRewardMillinSecondMode[key] == 1) then
					v2 = v2 / 1000
				end
				
				nodeChildUI["lab_attr"..i] = hUI.label:new({
					parent = nodeParent,
					x = 36 - _nBoardW/2,
					y = - countH,
					size = 26,
					font = hVar.FONTC,
					align = "LC",
					text = v1,
					border = 1,
				})
				
				local valuatext = ""
				if v2 > 0 then
					valuatext = "+ " .. v2
				else
					valuatext = "- " .. math.abs(v2)
				end
				
				if (hVar.ItemRewardStrMode[key] == 1) then
					valuatext = valuatext .. " %"
				end
				
				nodeChildUI["lab_value"..i] = hUI.label:new({
					parent = nodeParent,
					x = 220 - _nBoardW/2,
					y = - countH,
					size = 26,
					font = hVar.FONTC,
					align = "LC",
					text = valuatext,
					border = 1,
				})
				
				countH = countH + 32
			end
		end
		
		--如果一个随机属性都没有，那么说明是看原始tip
		--print("randreward=", randreward)
		if randreward then
			local randIdx1 = tItem[hVar.ITEM_DATA_INDEX.RAND_IDX1]
			local randIdx2 = tItem[hVar.ITEM_DATA_INDEX.RAND_IDX2]
			local randIdx3 = tItem[hVar.ITEM_DATA_INDEX.RAND_IDX3]
			local randIdx4 = tItem[hVar.ITEM_DATA_INDEX.RAND_IDX4]
			local randIdx5 = tItem[hVar.ITEM_DATA_INDEX.RAND_IDX5]
			if (randIdx1 == 0) and (randIdx2 == 0) and (randIdx3 == 0) and (randIdx4 == 0) and (randIdx5 == 0) then
				local randnum = randreward.randnum
				local randnum_num = #randreward
				local randnum_min, randnum_max = randnum[1], randnum[2]
				--print("randnum_min=", randnum_min, "randnum_max=", randnum_max)
				--print("randnum_num=", randnum_num)
				
				--不是全部随到的属性，有一行说明
				if (randnum_min < randnum_num) then
					--可能有以下m个属性中的n个
					local strSelectNum = tostring(randnum_min) .. "~" .. tostring(randnum_max)
					if (randnum_min == randnum_max) then
						strSelectNum = tostring(randnum_min)
					end
					nodeChildUI["lab_quality"] = hUI.label:new({
						parent = nodeParent,
						x = 28 - _nBoardW/2,
						y = - countH,
						size = 26,
						font = hVar.FONTC,
						align = "LC",
						text = string.format(hVar.tab_string["__TEXT__ItemProbablityAttr"], randnum_num, strSelectNum),
						RGB = {255, 255, 168,},
						border = 1,
					})
					
					countH = countH + 32 + 4
				end
				
				--展示全部可能是随机属性
				for i = 1, randnum_num, 1 do
					local key = randreward[i][1]
					local v1 = hVar.tab_string[hVar.ItemRewardStr[key]]
					local v2 = randreward[i][2]
					local v3 = randreward[i][3]
					
					if (hVar.ItemRewardMillinSecondMode[key] == 1) then
						v2 = v2 / 1000
						v3 = v3 / 1000
					end
					
					nodeChildUI["lab_rand_attr"..i] = hUI.label:new({
						parent = nodeParent,
						x = 36 - _nBoardW/2,
						y = - countH,
						size = 26,
						font = hVar.FONTC,
						align = "LC",
						text = v1,
						border = 1,
					})
					
					local valuatext = ""
					if v2 > 0 then
						valuatext = "+ (" .. v2 .."~" .. v3 .. ")"
					else
						valuatext = "- (" .. math.abs(v2) .."~" .. math.abs(v3) .. ")"
					end
					
					if (hVar.ItemRewardStrMode[key] == 1) then
						valuatext = valuatext .. " %"
					end
					
					nodeChildUI["lab_rand_value"..i] = hUI.label:new({
						parent = nodeParent,
						x = 220 - _nBoardW/2 - 30,
						y = - countH,
						size = 26,
						font = hVar.FONTC,
						align = "LC",
						text = valuatext,
						border = 1,
					})
					
					countH = countH + 32
				end
			end
		end
		
		--展示锻造孔的属性
		--额外属性系列
		local rewardEx = tItem[hVar.ITEM_DATA_INDEX.SLOT]
		local upCount = 0 --有效的孔的数量
		--如果是装备，才算孔
		--计算出当前的空槽子
		if rewardEx and type(rewardEx) == "table" then
			--MaxCount = #rewardEx
			for j = 1,#rewardEx do
				if rewardEx[j] and type(rewardEx[j]) == "string" and hVar.ITEM_ATTR_VAL[rewardEx[j]] then
					upCount = upCount + 1
				end
			end
		end
		print("upCount=", upCount)
		--显示 孔的额外属性
		if rewardEx and type(rewardEx) == "table" then
			
			countH = countH + 32
			
			--锻造属性文字
			nodeChildUI["lab_slot"] = hUI.label:new({
				parent = nodeParent,
				x = 28 - _nBoardW/2,
				y = - countH,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				text = "", --hVar.tab_string["__TEXT__ItemSlotAttr"], --"[锻造属性]:"
				RGB = {255, 255, 168,},
				border = 1,
			})
			
			--countH = countH + 32 + 4
			
			for j = 1, #rewardEx, 1 do
				local attr = rewardEx[j]
				if rewardEx[j] ~= 0 then
					local attrVal = hVar.ITEM_ATTR_VAL[attr]
					if attrVal and attrVal.attrAdd then
						local key = attrVal.attrAdd
						local value = attrVal.value1
						local strTip = attrVal.strTip
						local strSlotAttrName = hVar.tab_string[strTip]
						--local rgb = hVar.ITEMLEVEL[attrVal.quality].NAMERGB
						local rgb = hVar.ITEM_ATTR_CHIP_COLOR_DEF[attrVal.quality]
						print("key="..key, "value="..value)
						if (hVar.ItemRewardMillinSecondMode[key] == 1) then
							value = value / 1000
						end
						
						local valuatext = ""
						if value > 0 then
							valuatext = "+ " .. value
						else
							valuatext = "- " .. math.abs(value)
						end
						
						if (hVar.ItemRewardStrMode[key] == 1) then
							valuatext = valuatext .. " %"
						end
						
						--仅供界面展示几孔的填充的属性
						if (key == "unknwon") then
							valuatext = ""
						end
						
						--孔属性图标
						local chipModel = hVar.ITEM_ATTR_CHIP_IMG_DEF[attrVal.quality]
						nodeChildUI["lab_slotattr_diamond"..j] = hUI.image:new({
							parent = nodeParent,
							x = 28 - _nBoardW/2 + 16,
							y = - countH,
							model = chipModel, --"MODEL_EFFECT:diamond",
							align = "MC",
							w = 42,
							h = 42,
						})
						
						--孔属性名
						nodeChildUI["lab_slotattr"..j] = hUI.label:new({
							parent = nodeParent,
							x = 36 - _nBoardW/2 + 36,
							y = - countH,
							size = 26,
							font = hVar.FONTC,
							align = "LC",
							text = strSlotAttrName,
							RGB = rgb,
							border = 1,
						})
						
						--孔属性值
						nodeChildUI["lab_slotattr"..j] = hUI.label:new({
							parent = nodeParent,
							x = 220 - _nBoardW/2,
							y = - countH,
							size = 26,
							font = hVar.FONTC,
							align = "LC",
							text = valuatext,
							RGB = rgb,
							border = 1,
						})
						
						countH = countH + 32
					end
				end
			end
			countH = countH + 12
		end
		
		--技能
		local strI = hVar.tab_stringI[id] -- or {"","测试一下回不回换行且效果如何\n第三行效果"}
		if type(strI) == "table" and type(strI[2]) == "string" and string.len(strI[2]) > 2 then
			nodeChildUI["lab_describeline"] = hUI.image:new({
				parent = nodeParent,
				model = "misc/title_line.png",
				x = 0,
				y = - countH,
				w = _nBoardW - 40,
				h = 3,
			})

			countH = countH + 24

			nodeChildUI["lab_describe"] = hUI.label:new({
				parent = nodeParent,
				x = 28 - _nBoardW/2,
				y = - countH,
				size = 26,
				font = hVar.FONTC,
				align = "LT",
				text = strI[2],
				RGB = {135, 206, 235,},
				width = _nBoardW - 60,
			})
			
			local _,lh = nodeChildUI["lab_describe"]:getWH()
			countH = countH + lh

			countH = countH + 24
		end

		--获取方式
		if _bShowAccessWay then
			local strI = hVar.tab_stringI[id]
			if type(strI) == "table" and type(strI[3]) == "string" and string.len(strI[3]) > 0 then
				nodeChildUI["lab_access_way_line"] = hUI.image:new({
					parent = nodeParent,
					model = "misc/title_line.png",
					x = 0,
					y = - countH,
					w = _nBoardW - 40,
					h = 3,
				})

				countH = countH + 24

				nodeChildUI["lab_access_way"] = hUI.label:new({
					parent = nodeParent,
					x = 28 - _nBoardW/2,
					y = - countH,
					size = 26,
					font = hVar.FONTC,
					align = "LT",
					text = strI[3],
					RGB = {0, 200, 0},
					width = _nBoardW - 60,
				})
				
				local _,lh = nodeChildUI["lab_access_way"]:getWH()
				countH = countH + lh

				countH = countH + 24
			end
		end
		
		--留一些空白
		countH = countH + 12
		
		local tButtonList = {}
		if index == nil or index == 1 then
			tButtonList = _CODE_GetButtonInfo(tItem)
		end
		
		if #tButtonList > 0 then
			countH = countH + 90
		end
		
		_childUI["btn_board"..index] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			dragbox = _childUI["dragBox"],
			x = nodeX,
			y = nodeY - countH/2,
			w = _nBoardW,
			h = countH,
			z = -1,
		})
		--local img9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/itemtip.png", hVar.SCREEN.w/2, -hVar.SCREEN.h/2, _boardw, _boardh, _frm)
		
		local img9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/itemtip.png",0, 0, _nBoardW + 10, countH + 10, _childUI["btn_board"..index])
		
		countH = _CODE_CreateButton(tButtonList,nodeX,nodeY,countH)
		print("index="..index,"quality="..quality,countH)
	end

	_CODE_GetButtonInfo = function(tItem)
		--table_print(tItem)
		local showXiLian = false
		if type(tItem) == "table" and type(tItem[3]) == "table" and #tItem[3] > 0 then
			showXiLian = true
		end
		local tButtonList = {}
		if _nMode == 1 then	--更换 卸载 
			if showXiLian then
				tButtonList[#tButtonList+1] = {5,_tBtnDefine[5]}
			end
			tButtonList[#tButtonList+1] = {4,_tBtnDefine[4]}
			--tButtonList[#tButtonList+1] = {3,_tBtnDefine[3]}
			tButtonList.del = 1
		elseif _nMode == 2 then	--分解 洗练 装备
			if showXiLian then
				tButtonList[#tButtonList+1] = {5,_tBtnDefine[5]}
			end
			tButtonList[#tButtonList+1] = {2,_tBtnDefine[2]}
			tButtonList.del = 1
		elseif _nMode == 3 then	--分解 洗练
			if showXiLian then
				tButtonList[#tButtonList+1] = {5,_tBtnDefine[5]}
			end
			tButtonList.del = 1
		end
		return tButtonList
	end
	
	_CODE_CreateButton = function(tButtonList,nodeX,nodeY,countH)
		local width = 154
		if type(tButtonList) == "table" then
			if tButtonList.del then
				--分解按钮
				_childUI["btn_del"] = hUI.button:new({
					parent = _parent,
					dragbox = _childUI["dragBox"],
					model = "misc/button_null.png",
					--model = "misc/mask.png",
					x = nodeX + _nBoardW/2 - 35,
					y = nodeY - 70,
					w = 60,
					h = 70,
					scaleT = 0.9,
					code = function()
						_CODE_ClickButton(1)
					end
				})

				_childUI["btn_del"].childUI["img"] = hUI.image:new({
					parent = _childUI["btn_del"].handle._n,
					model = "ICON:CHIP_RECYCLE",
					scale = 0.8,
					x = - 5,
					y = 1,
				})
			end
			for i = 1,#tButtonList do
				local ntype,text = unpack(tButtonList[i])
				_childUI["btn_"..i] = hUI.button:new({
					parent = _parent,
					dragbox = _childUI["dragBox"],
					--model = "misc/billboard/btn_empty.png",
					model = "misc/chest/itembtn.png",
					x = nodeX + width * (i- (#tButtonList+1)/2),
					y = nodeY - countH + 50,
					w = 116,
					h = 60,
					scaleT = 0.95,
					label = {text = text,size = 24,font = hVar.FONTC, y = 2},
					z = 2,
					code = function()
						_CODE_ClickButton(ntype)
					end
				})
			end
		end
		return countH
	end

	_CODE_DelEquip = function()
		--挡操作
		hUI.NetDisable(30000)
			
		--发送指令出售装备
		local tRedequip_dbid = {}
		
		local dbid = 0
		local tfrom = _tItem1[hVar.ITEM_DATA_INDEX.FROM]
		if (type(tfrom) == "table") then
			for k = 1, #tfrom, 1 do
				if (type(tfrom[k]) == "table") then
					if (tfrom[k][1] == hVar.ITEM_FROMWHAT_TYPE.NET) then
						dbid = tfrom[k][2]
						break
					end
				end
			end
		end
		tRedequip_dbid[#tRedequip_dbid + 1] = dbid
		SendCmdFunc["descompos_redequip"](#tRedequip_dbid, tRedequip_dbid)
	end

	_CODE_ConfirmDelEquip = function()
		
	end
		--你确定要分解红色装备吗？
	
	_CODE_ClickButton = function(ntype)
		print(ntype)
		if ntype == 3 then
			local tPos = {"storehouse"}
			MoveEquipManager.RecordPos2(tPos)
			MoveEquipManager.MoveEquip()
			_CODE_ClearFunc()
		elseif ntype == 2 then --装备
			MoveEquipManager.MoveEquip()
			_CODE_ClearFunc()
		--elseif ntype == 1 then --装备
		elseif ntype == 1 then --分解
			local id = _tItem1[hVar.ITEM_DATA_INDEX.ID]
			local tabI = hVar.tab_item[id] or {}
			if tabI and tabI.itemLv ~= hVar.ITEM_QUALITY.ORANGE then
				_CODE_DelEquip()
			else
				hGlobal.event:event("LocalEvent_ShowConfirmDelRedEpuipFrm")
			end
		elseif ntype == 4 then
			hGlobal.event:event("localEvent_ShowChariotItemFrm")
			_CODE_ClearFunc()
		elseif ntype == 5 then	--洗练
			--打开洗炼迷你面板（洗炼）
			--print(_nBagIdx1)
			--print(_nBagIdx2)
			hGlobal.event:event("localEvent_ShowPhone_ItemMini", 0, _tItem1)
			_CODE_ClearFunc()
		end
	end
	
	_CODE_ShowItem = function()
		local item_uid1 = _tItem1[hVar.ITEM_DATA_INDEX.UNIQUE]
		if type(_tItem2) == "table" then
			local item_uid2 = _tItem2[hVar.ITEM_DATA_INDEX.UNIQUE]
			if item_uid1 == item_uid2 then
				_nMode = 3
				_CODE_CreateItemInfo()
			else
				if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
					_CODE_CreateItemInfo(1,_tItem1,hVar.SCREEN.w/2 + 180,-80)
					_CODE_CreateItemInfo(2,_tItem2,hVar.SCREEN.w/2 - 180,-80)
				else
					_CODE_CreateItemInfo(1,_tItem1,hVar.SCREEN.w/2 + 410,-88)
					_CODE_CreateItemInfo(2,_tItem2,hVar.SCREEN.w/2 - 410,-88)
				end
			end
		else
			_CODE_CreateItemInfo()
		end
	end
	
	hGlobal.event:listen("LocalEvent_SpinScreen","ItemTipFrm",function()
		_CODE_ClearFunc()
	end)
	
	--分解
	--出售装备事件（道具tip）
	hGlobal.event:listen("LocalEvent_DescomposeRedEquip_Result", "DescomposeChariotItemTip", function(iteminfo)
		_CODE_ClearFunc()
	end)

	hGlobal.event:listen("LocalEvent_ConfirmDelRedEquip","_ConfirmDelRedEquip",function()
		_CODE_DelEquip()
	end)
	
	--"localEvent_ShowItemTipFrm"
	-- @param bShowAccessWay bool 是否显示获取方式
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(tItem1,nMode,tItem2,bShowAccessWay)
		_bShowAccessWay = bShowAccessWay
		_CODE_ClearFunc()
		-- print("localEvent_ShowItemTipFrm", tItem1,nMode,tItem2)
		if type(tItem1) == "table" then
			_tItem1 = tItem1
			_nMode = nMode or 0
			--_nBagIdx1 = bagIdx1 or 0 --装备1所在背包（装备）索引
			--_nBagIdx2 = bagIdx2 or 0 --装备1所在背包（装备）索引
			_tItem2 = tItem2
			_CODE_CreateFrm()
		end
	end)
end
--[[
--测试 --test
if hGlobal.UI.ItemTipFrm then
	hGlobal.UI.ItemTipFrm:del()
	hGlobal.UI.ItemTipFrm = nil
end
hGlobal.UI.InitItemTipFrm("include")
local _,oEquip = LuaFindEquipByPos({"hero", 6000,1,})
local id = oEquip[hVar.ITEM_DATA_INDEX.ID]
-- hVar.tab_stringI[id][2] = "每过7秒向四周发射剑气。每过7秒向四周发射剑气。每过7秒向四周发射剑气。"
hVar.tab_stringI[id][3] = "获取方式 \n开启装备宝箱和神器宝箱"
print("oEquip:", oEquip, id)
hGlobal.event:event("localEvent_ShowItemTipFrm",oEquip)
--]]

--战车装备栏
hGlobal.UI.InitChariotEpuipFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowChariotEquipFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end
	
	local _frm,_parent,_childUI = nil,nil,nil
	local _tItemList = {}
	local _tCallback = {}
	local _tClearUI = {}
	local _tPageBtnUI = {}
	local _boardW,_boardH = 720,720
	local _nItemGridLine = hVar.ItemGridLine --4
	local _nItemGridCow = hVar.ItemGridCow --3
	local _nItemGridW,_nItemGridH = hVar.EquipWH,hVar.EquipWH
	local _nItemGridDiffW,_nItemGridDiffH = 123,122
	--local _nItemGridX,_nItemGridY = hVar.SCREEN.w / 2 + 140,-hVar.SCREEN.h/2 - _boardH/2 + 404
	local _nItemGridX,_nItemGridY = hVar.SCREEN.w/2- _boardW/2 + 513,-hVar.SCREEN.h/2
	local _nClipW = 300
	local _nClipStartY = -100
	local _nCurPage = 0
	local _cliprect = {}
	local _dragrect = {}
	local _cliprect_talent = {}
	local _dragrect_talent = {}
	local _tChariotTalentTab = {}
	local _canDrag = false
	local _ClipNode = nil
	local _ClipNode_talent = nil
	local _tClipNode = nil
	local _bInGuideState = false --是否在引导中（引导图展示一个装备闪烁的动画
	
	local _tChariotAttrList = {
		[1] = {
			list = {
				--"类型",“属性”,"小图标","自定义名字",额外参数1
				{"attr","hp_max",{image = "ICON:SKILL_SET04_01"},},						--生命
				{"weaponatk","atk_bullet",{image = "ICON:SKILL_SET04_02"},"__Attr_Hint_skill_damage"},		--武器
			},
		},
		[2] = {
			--image = "icon/skill/def_physic.png",
			BigIcon = {--大图标
				image = "misc/chariotconfig/ws_tab03_selected.png",
				scale = 0.5,
				w = -1,
				h = -1,
			},
			list = {
				{"attr","move_speed",{image = "ICON:SKILL_SET02_04"},},						--动力
				{"attr","def_physic",{image = "ICON:SKILL_SET02_01"},},						--护甲
				{"attr","def_fire",{image = "ICON:SKILL_SET02_05"},},						--防火
				{"attr","def_poison",{image = "ICON:SKILL_SET02_06"},},						--防毒
				{"attr","def_thunder",{image = "ICON:SKILL_SET02_07"},},					--防电
				{"attr","melee_bounce",{image = "ICON:SKILL_SET02_03"},"__TEXT_melee_bounce"},
				--{"talent","melee_bounce",{image = "ICON:SKILL_SET02_03"},"__TEXT_melee_bounce",26},		--冲撞
				{"attr","melee_fight",{image = "ICON:SKILL_SET02_02"},},					--刀片伤害
				--{"attr","melee_stone",{image = "ICON:SKILL_SET02_02"},},					--碎石伤害
			},
		},
		[3] = {
			--image = "icon/skill/icon4.png",
			BigIcon = {--大图标
				image = "misc/chariotconfig/ws_tab02_selected.png",
				scale = 0.5,
				w = -1,
				h = -1,
			},
			list = {
				--{"attr","grenade_dis",{image = ""},},								--投雷距离
				{"attr","grenade_cd",{image = "ICON:SKILL_SET01_03"},"__Attr_Hint_grenade_cd2"},						--投雷冷却
				{"attr","grenade_multiply",{image = "ICON:SKILL_SET01_02"},},					--双雷
				{"attr","grenade_fire",{image = "ICON:SKILL_SET01_07"},"__Attr_Hint_grenade_fire2"},					--燃烧
				{"attr","grenade_child",{image = "ICON:SKILL_SET01_05"},},					--子母
			},
		},
		[4] = {
			--image = "misc/gear.png",
			BigIcon = {--大图标
				image = "misc/chariotconfig/ws_tab04_selected.png",
				scale = 0.5,
				w = -1,
				h = -1,
			},
			list = {
				{"attr","pet_capacity",{image = "ICON:SKILL_SET03_01"},},					--宠物携带
				{"attr","pet_hp_restore",{image = "ICON:SKILL_SET03_02"},"__TEXT_hp_restore"},			--宠物治疗
				--{"talent","trap_lv",{image = "ICON:SKILL_SET03_04"},"__Attr_Hint_trap",44},			--陷阱
				--{"talent","tianwang",{image = "ICON:SKILL_SET03_05"},"txt_crit_tianwang",45},			--天网
			},
		},
	}
	--只显示总属性
	local singlevaluelist = {
		["grenade_cd"] = 1,
	}
	--防御特殊处理
	local defspeciallist = {
		--["def_physic"] = 1,
		--["def_fire"] = 1,
		--["def_poison"] = 1,
		--["def_thunder"] = 1,
	}

	local posstartx = 60
	local posstarty = 60
	local posdeltawh = 92
	--天赋坐标布局
	local _tTalentShowIcon = 0		--改成1可以看到绿色的选取范围
	local _chariottalentpath = "misc/chariotconfig/"		--路径  优化图片填写
	local _tChariotTalentPos_offX = 0
	local _tChariotTalentPos_offY = 0
	local _tChariotTalentPos = {
		[hVar.ChariotTalentType.BOMB] = {
			--id = {posx,posy}
			--[4] = {posstartx,-posstarty},
			--[1] = {posstartx + posdeltawh,-posstarty},
			--[6] = {posstartx,-posstarty- posdeltawh*2},
			--[5] = {posstartx,-posstarty-posdeltawh},
			--[8] = {posstartx + posdeltawh,- posstarty - posdeltawh},
			--[3] = {posstartx + posdeltawh * 1.72,-posstarty- posdeltawh*1.72},
			--[2] = {posstartx + posdeltawh * 2.72,-posstarty- posdeltawh*1.72},
			--[7] = {posstartx + posdeltawh * 0.72,-posstarty- posdeltawh*2.72},
			[4] = {204,-47},
			[1] = {297,-202},
			[6] = {204,-152},
			[8] = {107,-202},
			[3] = {79,-333},
			[2] = {333,-333},
			[7] = {204,-333},
		},
		[hVar.ChariotTalentType.SURVIVE] = {
			--[21] = {posstartx,-posstarty- posdeltawh*0.29},
			--[22] = {posstartx + posdeltawh * 0.72,-posstarty- posdeltawh*1.29},
			--[23] = {posstartx + posdeltawh * 1.72,-posstarty- posdeltawh*0.72},
			--[26] = {posstartx + posdeltawh * 2.72,-posstarty- posdeltawh*0.72},
			--[24] = {posstartx + posdeltawh * 1.72,-posstarty- posdeltawh*1.72},
			--[25] = {posstartx + posdeltawh * 2.72,-posstarty- posdeltawh*1.72},
			[21] = {205,-20},
			[27] = {56,-101},
			[26] = {351,-102},
			[25] = {205,-181},
			[22] = {56,-275},
			[24] = {351,-275},
			[23] = {205,-341},
		},
		[hVar.ChariotTalentType.HUNTER] = {
			--[42] = {posstartx,-posstarty- posdeltawh*0.29},
			--[43] = {posstartx,-posstarty- posdeltawh*1.29},
			--[44] = {posstartx + posdeltawh * 1.29,-posstarty- posdeltawh*0.35},
			--[41] = {posstartx + posdeltawh * 2.35,-posstarty- posdeltawh*0.35},
			--[45] = {posstartx + posdeltawh,-posstarty- posdeltawh*2.29},
			--[46] = {posstartx + posdeltawh * 1.72,-posstarty- posdeltawh*1.57},
			--[47] = {posstartx + posdeltawh * 2.72,-posstarty- posdeltawh*1.57},
			[41] = {206,-26},
			[42] = {60,-144},
			[43] = {355,-144},
			[44] = {115,-318},
			[45] = {298,-318},
		},
	}
	hVar.ChariotAttrList = _tChariotTalentPos
	--整体偏移
	local _tChariotTalentoff = {
		[hVar.ChariotTalentType.BOMB] = {0,0},
		[hVar.ChariotTalentType.SURVIVE] = {0,0},
		[hVar.ChariotTalentType.HUNTER] = {0,0},
	}

	local _CODE_CloseFunc = hApi.DoNothing
	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateEquipGrid = hApi.DoNothing
	local _CODE_CreateChariot = hApi.DoNothing --战车属性显示
	local _CODE_GetAttrV = hApi.DoNothing
	local _CODE_GetWeaponAtk = hApi.DoNothing
	local _CODE_UpdateAttr = hApi.DoNothing
	local _CODE_GetEquipData = hApi.DoNothing
	local _CODE_UpdateEquip = hApi.DoNothing
	local _CODE_UpdateTalent = hApi.DoNothing
	local _CODE_RemoveEquip = hApi.DoNothing
	local _CODE_InitData = hApi.DoNothing

	local _CODE_RefreshFrm = hApi.DoNothing
	local _CODE_RefreshTalent = hApi.DoNothing

	local _CODE_CreatePageBtn = hApi.DoNothing
	local _CODE_ClearPageUI = hApi.DoNothing
	local _CODE_ClickTypePage = hApi.DoNothing
	local _CODE_CreateChariotTalent = hApi.DoNothing
	local _CODE_CreateChariotTalentInfo = hApi.DoNothing
	
	local _CODE_OnPageDrag = hApi.DoNothing
	local _CODE_OnInfoUp = hApi.DoNothing
	local _CODE_AutoLign = hApi.DoNothing
	local _CODE_AdjustTalentButton = hApi.DoNothing
	local _CODE_AutoLign_talent = hApi.DoNothing
	
	_CODE_ClearFunc = function()
		if hGlobal.UI.ChariotEpuipFrm then
			hGlobal.UI.ChariotEpuipFrm:del()
			hGlobal.UI.ChariotEpuipFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_ClipNode = nil
		_tClipNode = nil
		_tItemList = {}
		_tCallback = {}
		_cliprect = {}
		_dragrect = {}
		_canDrag = false
		_tClearUI = {}
		_nCurPage = 0
		_tChariotTalentTab = {}
		_cliprect_talent = {}
		_dragrect_talent = {}
		_ClipNode_talent = {}
	end

	_CODE_InitData = function()
		_tChariotTalentTab = LuaGetChariotTalentTab(hVar.MY_TANK_ID)
	end
	
	_CODE_GetAttrV = function(key)
		local value = 0
		local baseV = 0
		local otherV = 0
		local tattr,tbase = hApi.GetUnitAttrsByHeroCard(hVar.MY_TANK_ID)
		if tattr[key] then
			value = tattr[key]
		end
		if tbase[key] then
			baseV = tbase[key]
		end
		otherV = value - baseV
		
		return value,baseV,otherV
	end

	_CODE_GetWeaponAtk = function()
		local baseatk = 0
		local otheratk = 0
		local oWorld = hGlobal.WORLD.LastWorldMap
		local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
		local oHero = oPlayerMe.heros[1]
		local weaponIdx = LuaGetHeroWeaponIdx(hVar.MY_TANK_ID) --当前选中的武器索引值
		local weaponid = 0
		if (weaponIdx > 0) then
			local tab = hVar.tab_unit[hVar.MY_TANK_ID] or {}
			local weapon_unit = tab.weapon_unit or {} --单位武器列表
			local tWeapon = weapon_unit[weaponIdx] or {}
			weaponid = tWeapon.unitId or 0
		end
		if oHero then
			local oUnit = oHero:getunit()
			if oUnit then
				local tabU = hVar.tab_unit[weaponid] or {}
				local attr = tabU.attr or {}
				local atk = attr.attack and attr.attack[5] or 0
				
				--附加等级成长值
				local star = LuaGetHeroWeaponLv(hVar.MY_TANK_ID, weaponIdx) --当前星级
				local level = LuaGetHeroWeaponExp(hVar.MY_TANK_ID, weaponIdx) --当前等级
				local atk_max_lvup = tabU.attr.atk_max_lvup
				--计算攻击力
				if (type(atk_max_lvup) == "table") then
					atk = atk + (level - 1) * (atk_max_lvup[star] or 0)
				elseif (type(atk_max_lvup) == "number") then
					atk = atk + (level - 1) * atk_max_lvup
				end
				
				local atkBullet = _CODE_GetAttrV("atk_bullet")
				baseatk = atk
				otheratk = math.floor((atkBullet - 100) * atk/100)
			end
		end
		return baseatk,otheratk
	end
	
	_CODE_UpdateAttr = function()
		if _childUI and _childUI["node"] then
			local _NodeChild =  _childUI["node"].childUI
			for i = 1,#_tChariotAttrList do
				local tlist = _tChariotAttrList[i].list
				local totalV,baseV,otherV = 0,0,0
				for j = 1,#tlist do
					local gettype,attrkey,_,_,param1 = unpack(tlist[j])
					if gettype == "attr" then
						totalV,baseV,otherV = _CODE_GetAttrV(attrkey)
						print(attrkey,totalV,baseV,otherV)
						if "grenade_multiply" == attrkey then
							baseV = baseV - 1
						end

						_NodeChild["node_value"..attrkey].childUI["lab_BaseV"]:setText(tostring(baseV))
						--[[
						if totalV == baseV then
							_NodeChild["node_value"..attrkey].childUI["lab_otherV"]:setText("")
							_NodeChild["node_value"..attrkey].childUI["lab_BaseV"]:setXY(0,0)
						else
							local str_otherV = ""
							if otherV >= 0 then
								str_otherV = " + "..math.abs(otherV)
							else
								str_otherV = " - "..math.abs(otherV)
							end
							_NodeChild["node_value"..attrkey].childUI["lab_otherV"]:setText(str_otherV)
							local baseV_w = _NodeChild["node_value"..attrkey].childUI["lab_BaseV"]:getWH()
							local otherV_w = _NodeChild["node_value"..attrkey].childUI["lab_otherV"]:getWH()
							local totalw = baseV_w + otherV_w
							_NodeChild["node_value"..attrkey].childUI["lab_BaseV"]:setXY((baseV_w - totalw)/2 - 1,0)
							_NodeChild["node_value"..attrkey].childUI["lab_otherV"]:setXY((totalw - otherV_w)/2 - 1,0)
						end
						--]]
					elseif gettype == "talent" then
						totalV,baseV,otherV = 0,0,0
						local curLv = LuaGetHeroTalentSkillLv(hVar.MY_TANK_ID, param1)
						--_NodeChild["lab_value_"..attrkey]:setText(tostring(curLv))
						_NodeChild["node_value"..attrkey].childUI["lab_BaseV"]:setText(tostring(curLv))
					elseif gettype == "weaponatk" then
						baseV,otherV = _CODE_GetWeaponAtk()
						_NodeChild["node_value"..attrkey].childUI["lab_BaseV"]:setText(tostring(baseV))
					end
					local str_otherV = ""
					if otherV > 0 then
						str_otherV = " + "..math.abs(otherV)
					elseif otherV < 0 then
						str_otherV = " - "..math.abs(otherV)
					end
					local baseV_w = _NodeChild["node_value"..attrkey].childUI["lab_BaseV"]:getWH()
					if singlevaluelist[attrkey] == 1 then
						_NodeChild["node_value"..attrkey].childUI["lab_BaseV"]:setText(tostring(baseV + otherV))
						_NodeChild["node_value"..attrkey].childUI["lab_BaseV"]:setXY(0,0)
					else
						_NodeChild["node_value"..attrkey].childUI["lab_otherV"]:setText(str_otherV)
						_NodeChild["node_value"..attrkey].childUI["lab_BaseV"]:setXY(0,0)
						_NodeChild["node_value"..attrkey].childUI["lab_otherV"]:setXY(baseV_w * 0.67,0)
					end
					if defspeciallist[attrkey] == 1 then
						if _NodeChild["lab_def_"..attrkey] then
							local num = math.floor((baseV + otherV)/10)
							if num > 0 then
								_NodeChild["lab_def_"..attrkey]:setText(num)
							else
								_NodeChild["lab_def_"..attrkey]:setText("")
							end
						end
					end
				end
			end
		end
	end
	
	_CODE_GetEquipData = function()
		--_tItemList = {20002,20008,20003}
		_tItemList = {}
		local oHero = hApi.GetHeroCardById(hVar.MY_TANK_ID)
		local equipment = oHero.equipment
		
		if type(equipment) == "table" then
			for i = 1,hVar.HERO_EQUIP_SIZE do
				local uid = equipment[i]
				local _,oEquip = LuaFindEquipByUniqueId(uid)
				_tItemList[i] = oEquip
			end
		end
	end
	
	_CODE_UpdateEquip = function()
		if _nCurPage ~= 1 then
			return
		end
		_CODE_GetEquipData()
		
		--是否绘制过叹号了（背包栏有道具，装备第一个空位显示叹号）
		local bNoticeTanHao = false
		
		--检测是否有背包的道具可装备到英雄身上
		local bHaveBagTakeOnEquip = hApi.CheckBagTakeOnEquip()
		local bShowNotice = (bHaveBagTakeOnEquip)
		
		for i = 1,_nItemGridLine do
			for j = 1,_nItemGridCow do
				local index = (i-1)*_nItemGridCow + j
				if _childUI["btn_remove_equip"..index] then
					_childUI["btn_remove_equip"..index]:setstate(-1)
				end
				hApi.safeRemoveT(_childUI["btn_grid"..index].childUI,"bg")
				hApi.safeRemoveT(_childUI["btn_grid"..index].childUI,"equip")
				hApi.safeRemoveT(_childUI["btn_grid"..index].childUI,"tanhao")
				local oEquip = _tItemList[index]
				if (type(oEquip) == "table") then
					local equipid = oEquip[hVar.ITEM_DATA_INDEX.ID]
					local tabI = hVar.tab_item[equipid]
					print(equipid,index)
					if tabI then
						local quality = _tItemList[index][hVar.ITEM_DATA_INDEX.QUALITY] or 0
						local level = tabI.itemLv
						local backmodel = hVar.ITEMLEVEL[level].BACKMODEL
						
						_childUI["btn_grid"..index].childUI["bg"] = hUI.image:new({
							parent = _childUI["btn_grid"..index].handle._n,
							model = backmodel,
							--w = _nItemGridW,
							--h = _nItemGridH,
							--model = "misc/chariotconfig/item1.png",
						})
						
						_childUI["btn_grid"..index].childUI["equip"] = hUI.image:new({
							parent = _childUI["btn_grid"..index].handle._n,
							model = tabI.icon,
							w = _nItemGridW,
							h = _nItemGridH,
							--model = "misc/chariotconfig/item1.png",
						})
						
						if _childUI["btn_remove_equip"..index] then
							_childUI["btn_remove_equip"..index]:setstate(1)
						end
					end
				else
					if bShowNotice then
						if (not bNoticeTanHao) then
							--提示该位置可以装备的特效动画
							_childUI["btn_grid"..index].childUI["tanhao"] = hUI.image:new({
								parent = _childUI["btn_grid"..index].handle._n,
								model = "MODEL_EFFECT:strengthen2",
								x = -3,
								y = 3,
								w = 160,
								h = 160,
							})
							
							--标记绘制过叹号了
							bNoticeTanHao = true
						end
					end
				end
			end
		end
	end
	
	_CODE_CreateFrm = function()
		hGlobal.UI.ChariotEpuipFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			--z = 5555,
			show = 0,
			dragable = 2,
			background = -1,
			autoactive = 0,
			border = 0,
			z = hZorder.MainBaseFirstFrm,
			codeOnTouch = function(self, relTouchX, relTouchY, IsInside, tTempPos)
				if _canDrag then
					if hApi.IsInBox(relTouchX, relTouchY, _cliprect) then
						local pama = {state = 0,tip = "tankinfo"}
						self:pick("node",_dragrect,tTempPos,{_CODE_OnPageDrag,_CODE_OnInfoUp,pama},1)
					--elseif hApi.IsInBox(relTouchX, relTouchY, _cliprect_talent) then
						--local pama = {state = 0,tip = "tanktalent"}
						--self:pick("node_talent",_dragrect_talent,tTempPos,{_CODE_OnPageDrag,_CODE_OnInfoUp,pama},1)
					end
				end
			end, 
		})
		_frm = hGlobal.UI.ChariotEpuipFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI
		
		local offx = hVar.SCREEN.w/2
		local offy = -hVar.SCREEN.h/2
		
		
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
			local closebtnw = (hVar.SCREEN.w - _boardW)/2
			_childUI["btn_close1"] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				model = "misc/button_null.png",
				--model = "misc/mask.png",
				x = closebtnw/2,
				y = offy,
				w = closebtnw,
				h = hVar.SCREEN.h,
				z = -2,
				code = function()
					_CODE_CloseFunc()
				end,
			})
			
			_childUI["btn_close2"] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				model = "misc/button_null.png",
				--model = "misc/mask.png",
				x = hVar.SCREEN.w - closebtnw/2,
				y = offy,
				w = (hVar.SCREEN.w - _boardW)/2,
				h = hVar.SCREEN.h,
				z = -2,
				code = function()
					_CODE_CloseFunc()
				end,
			})
		else
			local closebtnh = (hVar.SCREEN.h - _boardH)/2
			_childUI["btn_close1"] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				model = "misc/button_null.png",
				--model = "misc/mask.png",
				x = offx,
				y = -closebtnh/2,
				w = hVar.SCREEN.w,
				h = closebtnh,
				z = -2,
				code = function()
					_CODE_CloseFunc()
				end,
			})
			
			_childUI["btn_close2"] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				model = "misc/button_null.png",
				--model = "misc/mask.png",
				x = offx,
				y = - hVar.SCREEN.h + closebtnh/2,
				w = hVar.SCREEN.w,
				h = closebtnh,
				z = -2,
				code = function()
					_CODE_CloseFunc()
				end,
			})
		end
		
		
		_childUI["img_bg"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			--dragbox = _childUI["dragBox"],
			x = offx,
			y = offy,
			w = _boardW,
			h = _boardH,
			z = -1,
		})
		--local img9 = hApi.CCScale9SpriteCreate("data/image/misc/chariotconfig/boardbg.png",0, 0, _boardW, _boardH, _childUI["img_bg"])
		
		_cliprect = {(hVar.SCREEN.w - _boardW)/2,(_boardH - hVar.SCREEN.h)/2 + _nClipStartY,_nClipW,_boardH + _nClipStartY * 2,0}
		local _cliprectnode = {_cliprect[1], _cliprect[2], _cliprect[3], _cliprect[4] + 88, _cliprect[5],}
		local pFrmClipper,pFrmClipperMask,pFrmClipperMaskN = hApi.CreateClippingNode(_frm, _cliprectnode, 5,_cliprect[5],"tankinfo")
		_ClipNode = pFrmClipper
		_tClipNode = {pFrmClipper,pFrmClipperMask,pFrmClipperMaskN}
		_cliprect_talent = {(hVar.SCREEN.w - _boardW )/2 + 310,(_boardH - hVar.SCREEN.h)/2 - 154,390,400,0}
		_ClipNode_talent = hApi.CreateClippingNode(_parent, _cliprect_talent, 5, _cliprect_talent[5])
		
		_CODE_CreateChariot()
		--_CODE_CreatePageBtn()
		
		_frm:active()
		_frm:show(1)
		
		--添加监听事件
		--收到玩家战车技能点数信息返回结果
		hGlobal.event:listen("LocalEvent_OnReceiveTankSkillPoint", "ChariotEpuip", function()
			_CODE_CreateChariot()
			_CODE_UpdateAttr()
		end)
		
		--获取战车技能点数同步数据
		--SendCmdFunc["tank_sync_talentpoint_info"]()
	end
	
	--关闭装备界面
	_CODE_CloseFunc = function()
		--引导中，禁止关闭本界面
		if _bInGuideState then
			return
		end
		
		hGlobal.event:event("LocalEvent_CloseEnterCommentFrm")
		CommentManage.LeaveArea()
		--移除监听事件
		--收到玩家战车技能点数信息返回结果
		hGlobal.event:listen("LocalEvent_OnReceiveTankSkillPoint", "ChariotEpuip", nil)
		
		hGlobal.event:event("LocalEvent_RecoverBarrage")
		
		--部分界面
		--释放png, plist的纹理缓存（这里不清理也可以）
		--hApi.ReleasePngTextureCache()
		
		--回收lua内存（这里不清理也可以）
		--collectgarbage()
		
		--print("关闭装备界面")
		
		--更新战车属性
		local oWorld = hGlobal.WORLD.LastWorldMap
		local oPlayerMe = oWorld:GetPlayerMe() --我的玩家对象
		local oHero = oPlayerMe.heros[1]
		--print(oHero)
		if oHero then
			local oUnit = oHero:getunit()
			--print(oUnit)
			if oUnit then
				local HeroCard = hApi.GetHeroCardById(hVar.MY_TANK_ID)
				oHero:loadequip(HeroCard) --加载英雄装备
				oHero:refreshequip(oUnit) --刷新单位属性
			end
		end
		
		if type(_tCallback) == "table" then
			hGlobal.event:event(_tCallback[1],_tCallback[2])
		end
		if type(_tCallback) == "function" then
			_tCallback()
		end
		_CODE_ClearFunc()
	end
	
	_CODE_RemoveEquip = function(index)
		--引导中，禁止卸下装备
		if _bInGuideState then
			return
		end
		
		local tPos1 = {"hero",hVar.MY_TANK_ID,index}
		MoveEquipManager.RecordPos1(tPos1)
		local tPos2 = {"storehouse"}
		MoveEquipManager.RecordPos2(tPos2)
		MoveEquipManager.MoveEquip()
	end
	
	_CODE_CreateEquipGrid = function()
		--_nItemGridX,_nItemGridY = hVar.SCREEN.w/2- _boardW/2 + 513,-hVar.SCREEN.h/2
		
		_childUI["img_equipgridbg"] = hUI.image:new({
			parent = _parent,
			model = "misc/chariotconfig/workshop_equips.png",
			x = _nItemGridX,
			y = _nItemGridY,
			--scale = 0.9,
			z = -1,
		})
		_tClearUI[#_tClearUI+1] = "img_equipgridbg"
		
		
		for i = 1,_nItemGridLine do
			for j = 1,_nItemGridCow do
				local index = (i-1)*_nItemGridCow + j
				_childUI["btn_grid"..index] = hUI.button:new({
					parent = _parent,
					--model = "misc/chariotconfig/itemgrid.png",
					--model = "misc/mask.png",
					model = "misc/button_null.png",
					dragbox = _childUI["dragBox"],
					x = _nItemGridX + _nItemGridDiffW * (j - _nItemGridCow/2 - 0.5) - 1,
					y = _nItemGridY - (i - 1) * _nItemGridDiffH + 205,
					w = _nItemGridW,
					h = _nItemGridH,
					code = function()
						--引导中，禁止点击装备
						if _bInGuideState then
							return
						end
						
						print(index)
						local tPos = {"hero",hVar.MY_TANK_ID,index}
						MoveEquipManager.RecordPos1(tPos)
						if _tItemList[index] and _tItemList[index] ~= 0 then 
							hGlobal.event:event("localEvent_ShowItemTipFrm",_tItemList[index],1)
						else
							hGlobal.event:event("localEvent_ShowChariotItemFrm",0)
						end
					end,
				})
				_tClearUI[#_tClearUI+1] = "btn_grid"..index

				--if g_lua_src == 1 then
					local btnwh = 40
					_childUI["btn_remove_equip"..index] = hUI.button:new({
						parent = _parent,
						model = "misc/button_null.png",
						dragbox = _childUI["dragBox"],
						x = _nItemGridX + _nItemGridDiffW * (j - _nItemGridCow/2) - 1 - btnwh/2,
						y = _nItemGridY - (i - 1.5) * _nItemGridDiffH + 205 - btnwh/2,
						w = btnwh,
						h = btnwh,
						scaleT = 0.9,
						code = function()
							_CODE_RemoveEquip(index)
						end
					})
					_tClearUI[#_tClearUI+1] = "btn_remove_equip"..index

					_childUI["btn_remove_equip"..index].childUI["img"] = hUI.image:new({
						parent = _childUI["btn_remove_equip"..index].handle._n,
						model = "misc/skillup/btn_close.png",
						w = 32,
						h = 32,
					})
					_childUI["btn_remove_equip"..index]:setstate(-1)
				--end
			end
		end
	end
	
	--战车属性显示
	_CODE_CreateChariot = function()
		hApi.safeRemoveT(_childUI,"img_chariotbg")
		_childUI["img_chariotbg"] = hUI.image:new({
			parent = _parent,
			model = "misc/chariotconfig/workshop_list_panel.png",
			x = _cliprect[1] + _cliprect[3]/2 + 2,
			y = _cliprect[2] - _cliprect[4]/2,
		})
		hApi.safeRemoveT(_childUI,"node")
		hApi.safeRemoveT(_childUI,"nodeHold") --静止不动的控件
		_childUI["node"] = hUI.node:new({
			parent = _ClipNode,
			x = _cliprect[1],
			y = _cliprect[2],
		})
		_childUI["nodeHold"] = hUI.node:new({ --静止不动的控件
			parent = _parent,
			x = _cliprect[1],
			y = _cliprect[2],
		})
		local _NodeParent = _childUI["node"].handle._n
		local _NodeChild =  _childUI["node"].childUI
		
		local _NodeParentHold = _childUI["nodeHold"].handle._n --静止不动的控件
		local _NodeChildHold = _childUI["nodeHold"].childUI --静止不动的控件
		
		--hVar.ItemRewardStr
		local totalH = 40
		local offx = - 6
		
		local level = 1
		local star = 1
		local exp = 0
		local tankIdx = LuaGetHeroTankIdx()
		local tankId = hVar.tab_unit[hVar.MY_TANK_ID].tank_unit[tankIdx]
		local tHeroCard = hApi.GetHeroCardById(tankId)
		if tHeroCard then
			level = tHeroCard.attr.level
			star = tHeroCard.attr.star
			exp = tHeroCard.attr.exp
		end
		--print("level=", level)
		local nextExp = hVar.TANK_LEVELUP_EXP[level].nextExp --下一级所需经验值
		local curExp = exp - hVar.TANK_LEVELUP_EXP[level].minExp --本级经验值
		
		--显示战车的等级
		_NodeChildHold["tankLv"] = hUI.label:new({
			parent = _NodeParentHold,
			x = 156 + offx,
			y = - totalH + 71,
			width = 300,
			font = "num",
			size = 26,
			--text = "lv " .. level,
			text = level,
			align = "MC",
		})
		
		--显示战车的经验进度
		_NodeChildHold["barExp"] = hUI.valbar:new({
			parent = _NodeParentHold,
			model = "UI:MedalDarkImg",
			x = 12 + offx,
			y = - totalH + 108,
			w = 276,
			h = 26,
			--back = {model = "UI:BAR_S1_ValueBar_BG", x = -2, y = 0, w = 226, h = 22+4},
			model = "UI:IMG_S1_ValueBar",
			v = curExp,
			max = nextExp,
		})
		--显示战车的经验进度文字
		_NodeChildHold["tankExp"] = hUI.label:new({
			parent = _NodeParentHold,
			x = 156 + offx,
			y = - totalH + 108 + 1,
			width = 300,
			font = "numWhite",
			size = 22,
			text = tostring(curExp) .. "/" .. tostring(nextExp),
			align = "MC",
		})
		
		totalH = totalH - 10
		
		for i = 1,#_tChariotAttrList do
			local tBigIcon = _tChariotAttrList[i].BigIcon
			local tlist = _tChariotAttrList[i].list
			if tBigIcon then
				_NodeChild["image_attrtype"..i] = hUI.image:new({
					parent = _NodeParent,
					model = tBigIcon.image,
					--x = 50 + offx,
					x = _cliprect[3]/2,
					y = - totalH - 6,
					w = tBigIcon.w or 50,
					h = tBigIcon.h or 50,
					scale = tBigIcon.scale or 1,
				})
				totalH = totalH + 64
			end

			for j = 1,#tlist do
				local gettype,attrkey,tIcon,customStr,param1 = unpack(tlist[j])
				--local str = "__Attr_Abbreviation_"..attrkey
				local str = hVar.ItemRewardStr[attrkey]
				local text = hVar.tab_string[str]
				if customStr ~= nil and customStr ~= "" then
					text = hVar.tab_string[customStr]
				end
				--百分比显示
				if (hVar.ItemRewardStrMode[str] == 1) then
					info = info .. " %"
				end
				--if (hVar.ItemRewardMillinSecondMode[str] == 1) then
				--	info = tonumber(info) / 1000
				--end
				_NodeChild["img_icon_"..attrkey] = hUI.image:new({
					parent = _NodeParent,
					model = tIcon.image,
					x = 40 + offx,
					y = - totalH - 2,
					scale = 0.54,
				})

				if defspeciallist[attrkey] == 1 then
					_NodeChild["lab_def_"..attrkey] = hUI.label:new({
						parent = _NodeParent,
						text = "",
						align = "MC",
						size = 22,
						x = 40 + offx + 15,
						y = - totalH - 14,
						font = "num",
					})
				end

				_NodeChild["lab_name_"..attrkey] = hUI.label:new({
					parent = _NodeParent,
					text = text,
					font = hVar.FONTC,
					align = "LC",
					size = 24,
					x = 72 + offx,
					y = - totalH,
				})

				_NodeChild["node_value"..attrkey] = hUI.button:new({
					parent = _NodeParent,
					model = "misc/button_null.png",
					--model = "misc/mask.png",
					w = 1,
					h = 1,
					x = 142 + offx,
					--x = _cliprect[3]/2 + 62 + offx,
					y = - totalH - 4,
				})

				_NodeChild["node_value"..attrkey].childUI["lab_BaseV"] = hUI.label:new({
					parent = _NodeChild["node_value"..attrkey].handle._n,
					text = "",
					align = "LC",
					size = 18,
					font = "numWhite",
				})

				_NodeChild["node_value"..attrkey].childUI["lab_otherV"] = hUI.label:new({
					parent = _NodeChild["node_value"..attrkey].handle._n,
					text = "",
					align = "LC",
					size = 18,
					font = "numGreen"
					--RGB = {165,250,50},
				})
				totalH = totalH + 58
			end
			
			totalH = totalH + 20
			--totalH = totalH + 22 - 50
		end
		
		local gh = math.max(0,totalH - _cliprect[4])
		_dragrect = {_cliprect[1], _cliprect[2]+gh, 0, math.max(1, gh)}
		
		_canDrag = true
	end
	
	_CODE_ClearPageUI = function()
		for i = 1,#_tClearUI do
			hApi.safeRemoveT(_childUI,_tClearUI[i])
		end
		_tClearUI = {}
		hApi.safeRemoveT(_childUI,"node_talent")
		hApi.safeRemoveT(_childUI,"node_talentinfo")
	end
	
	_CODE_ClickTypePage = function(nPage)
		--引导中，禁止切换分页
		if _bInGuideState then
			return
		end
		
		if _nCurPage ~= nPage then
			_CODE_ClearPageUI()
			_nCurPage = nPage
			_CODE_CreatePageBtn()
			if _nCurPage == 1 then
				_CODE_CreateEquipGrid()
				_CODE_UpdateEquip()
			else
				_CODE_CreateChariotTalent(_nCurPage - 1)
			end
		end
	end

	_CODE_CreateChariotTalent = function(index)
		_childUI["img_talentbg"] = hUI.image:new({
			parent = _parent,
			model = "misc/chariotconfig/workshop_skill0"..index..".png",
			x = hVar.SCREEN.w/2- _boardW/2 + 513,
			y = -hVar.SCREEN.h/2,
			z = -1,
		})
		_tClearUI[#_tClearUI+1] = "img_talentbg"

		local startx = hVar.SCREEN.w/2- _boardW/2 + 360
		local starty = -hVar.SCREEN.h/2 - _boardH/2 + 660

		_childUI["img_talentpoint"] = hUI.image:new({
			parent = _parent,
			model = "misc/chariotconfig/point.png",
			x = startx,
			y = starty,
			scale = 0.8,
			--z = 10,
		})
		_tClearUI[#_tClearUI+1] = "img_talentpoint"

		_childUI["lab_talentpoint"] = hUI.label:new({
			parent = _parent,
			text = LuaGetHeroTalentPoint(hVar.MY_TANK_ID),
			font = "numWhite",
			align = "LC",
			size = 24,
			x = startx + 40,
			y = starty,
		})
		_tClearUI[#_tClearUI+1] = "lab_talentpoint"

		_childUI["btn_comment"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/commentbtn.png",
			dragbox = _childUI["dragBox"],
			x = startx+ 298,
			y = starty - 4,
			scale = 0.8,
			scaleT = 0.8,
			--z = 10,
			code = function()
				hGlobal.event:event("LocalEvent_DoCommentProcess",{})
			end,
		})
		_tClearUI[#_tClearUI+1] = "btn_comment"

		_childUI["btn_clear"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			--model = "misc/mask.png",
			dragbox = _childUI["dragBox"],
			x = startx + 60,
			y = starty,
			scaleT = 0.95,
			w = 200,
			h = 70,
			code = function()
				--SendCmdFunc["tank_talentpoint_restore"]()
				hGlobal.event:event("LocalEvent_ShowResetChariotTalentFrm")
			end,
		})
		_tClearUI[#_tClearUI+1] = "btn_clear"

		--_childUI["btn_clear"].childUI["lab"] = hUI.label:new({
			--parent = _childUI["btn_clear"].handle._n,
			--text = "reset",
			--font = hVar.FONTC,
			--align = "MC",
			--size = 22,
			--y = 4,
		--})
		
		hApi.safeRemoveT(_childUI,"node_talent")
		_childUI["node_talent"] = hUI.node:new({
			--parent = _ClipNode_talent,
			parent = _parent,
			x = _cliprect_talent[1],
			y = _cliprect_talent[2],
		})
		local _NodeParent = _childUI["node_talent"].handle._n
		local _NodeChild =  _childUI["node_talent"].childUI

		_dragrect_talent = {}
		local tab = _tChariotTalentTab[index]
		if tab then
			local talenttype = tab.talenttype
			local talentoffx,talentoffy = 0,0
			if _tChariotTalentoff[talenttype] then
				talentoffx,talentoffy = unpack(_tChariotTalentoff[talenttype])
			end
			for i = 1,#tab.talentid do
				local talentid = tab.talentid[i]
				local posx = -60 + ((i - 1)%3 + 1) * 120
				local posy = - 60 - math.floor((i-1)/3) * 120
				local showicon = ""
				local icon = "misc/button_null.png"
				local iconwh = 72
				if _tChariotTalentPos[talenttype] and _tChariotTalentPos[talenttype][talentid] then
					posx,posy = unpack(_tChariotTalentPos[talenttype][talentid])
				end
				local tabCT = hVar.tab_chariottalent[talentid] or {}
				showicon = tabCT.icon
				if showicon == nil or showicon == "" then
					showicon = "misc/button_null.png"
				end
				if _tTalentShowIcon == 1 then
					icon = "misc/mask.png"
				end
				_NodeChild["talent"..i] = hUI.button:new({
					parent = _NodeParent,
					dragbox = _childUI["dragBox"],
					model = icon,
					x = posx+talentoffx,
					y = posy+talentoffy,
					w = iconwh,
					h = iconwh,
					scaleT = 0.95,
					code = function()
						print("talent",i)
						--_CODE_CreateUpgradeTreeSecondaryFrm(i)
						--_CODE_CreateChariotTalentInfo(i)
						hGlobal.event:event("LocalEvent_ShowUpgradeChariotTalentFrm",talentid,showicon)
					end,
				})

				local btnChild = _NodeChild["talent"..i].childUI
				local btnParent = _NodeChild["talent"..i].handle._n

				btnChild["img"] = hUI.image:new({
					parent = btnParent,
					model = showicon,
					x = _tChariotTalentPos_offX,
					y = _tChariotTalentPos_offY,
				})

				local tabCT = hVar.tab_chariottalent[talentid] or {}
				if _tTalentShowIcon == 1 then
					btnChild["lab_talentid"] = hUI.label:new({
						parent = btnParent,
						text = talentid,
						align = "MC",
						y = - 42,
					})
				end
				
				

				local curLv = LuaGetHeroTalentSkillLv(hVar.MY_TANK_ID, talentid)
				local maxLv = math.min(6,tabCT.attrPointMaxLv)
				if curLv > 0 then
					local shownum = 6/maxLv*curLv
					--for j = 1,shownum do
					btnChild["img_curlv"] = hUI.image:new({
						parent = btnParent,
						model = "misc/chariotconfig/tough_learned_0"..shownum..".png",
						z = 1,
					})
					--end
				--[[
				else
					btnChild["img_curlv"] = hUI.image:new({
						parent = btnParent,
						model = "misc/chariotconfig/tough_learned_03.png",
						z = 1,
					})--]]
				end
				
			end
			local totalH = 72 - _NodeChild["talent"..#tab.talentid].data.y
			--print(totalH)
			local gh = math.max(0,totalH - _cliprect_talent[4])
			_dragrect_talent = {_cliprect_talent[1], _cliprect_talent[2]+gh, 0, math.max(1, gh)}
			_CODE_AdjustTalentButton()
			--_CODE_CreateChariotTalentInfo(1)
		end
	end

	_CODE_CreatePageBtn = function()
		for i = 1,#_tPageBtnUI do
			local uiname = _tPageBtnUI[i]
			hApi.safeRemoveT(_childUI,uiname)
		end
		_tPageBtnUI = {}
		local offx = hVar.SCREEN.w/2
		local offy = -hVar.SCREEN.h/2
		local t_wh = {
			[1] = {
				{85,85},
				{98,98},
			},
			[2] = {
				{89,98},
				{101,112},
			},
			[3] = {
				{89,98},
				{101,112},
			},
			[4] = {
				{89,98},
				{101,112},
			},
		}
		local btnh = 94
		local num = #_tChariotTalentTab + 1

		local offw = 0
		print("_nCurPage",_nCurPage)
		for i = num,1,-1 do
			local str = ""
			local w = t_wh[i][1][1]
			local h = t_wh[i][1][2]
			local y = offy - _boardH/2 + 126/2
			if _nCurPage == i then
				str = "_selected"
				--y = offy - _boardH/2 + 112/2
				w = t_wh[i][2][1]
				h = t_wh[i][2][2]
			end
			offw = offw - w/2
			local x = offx + _boardW/2 + offw
			offw = offw - w/2
			
			_childUI["btn_page"..i] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				model = "misc/chariotconfig/ws_tab0"..i..str..".png",
				x = x,
				y = y,
				--w = wh,
				--h = wh,
				z = 1,
				scaleT = 0.9,
				code = function()
					_CODE_ClickTypePage(i)
				end
			})
			_tPageBtnUI[#_tPageBtnUI+1] = "btn_page"..i
		end
		
		--绘制跳转背包的按钮
		hApi.safeRemoveT(_childUI,"btnToBag")
		if (_nCurPage == 1) then
			_childUI["btnToBag"] = hUI.button:new({
				parent = _parent,
				model = "misc/mask.png",
				x = _nItemGridX - 130,
				y = _nItemGridY + 300,
				w = 84,
				h = 84,
				dragbox = _childUI["dragBox"],
				scaleT = 0.95,
				code = function()
					--引导中，禁止跳转背包
					if _bInGuideState then
						return
					end
					
					--弹出仓库按钮
					--hGlobal.event:event("LocalEvent_HideBarrage")
					hGlobal.event:event("localEvent_ShowChariotItemFrm", 0)
				end,
			})
			_childUI["btnToBag"].handle.s:setOpacity(0) --只响应事件，不显示
			--图片
			_childUI["btnToBag"] = hUI.image:new({
				parent = _childUI["btnToBag"].handle._n,
				model = "misc/tempbag/iconbag.png",
				x = 0,
				y = 0,
				w = 64,
				h = 64,
			})
		end
	end
	
	_CODE_CreateChariotTalentInfo = function(index)
		print("_CODE_CreateChariotTalentInfo")
		local tab = _tChariotTalentTab[_nCurPage - 1]
		local talentid = _tChariotTalentTab[_nCurPage - 1].talentid[index]
		local lv = LuaGetHeroTalentSkillLv(hVar.MY_TANK_ID, talentid)

		hApi.safeRemoveT(_childUI,"node_talentinfo")

		local tTakentTree = hVar.tab_chariottalent[talentid]
		if tTakentTree == nil or lv > tTakentTree.attrPointMaxLv then
			return
		end

		local offx = _cliprect_talent[1]
		local offy = _cliprect_talent[2] +- _cliprect_talent[4]

		_childUI["node_talentinfo"] = hUI.node:new({
			parent = _parent,
			x = offx,
			y = offy,
		})

		local nodeParent = _childUI["node_talentinfo"].handle._n
		local nodeChildUI = _childUI["node_talentinfo"].childUI

		local bgw = 380
		local bgh = 120

		local img9 = hApi.CCScale9SpriteCreate("data/image/misc/skillup/skillpoint_bg.png",bgw/2, -bgh/2 - 6, bgw, bgh, _childUI["node_talentinfo"])

		if tTakentTree.attrAdd then
			nodeChildUI["node_lab"] = hUI.button:new({
				parent = nodeParent,
				model = "misc/button_null.png",
				x = 24,
				y = -32,
				w = 1,
				h = 1,
			})
			
			local addattr = tTakentTree.attrAdd[lv+1]
			local info = hVar.tab_string[hVar.ItemRewardStr[addattr[1][1]]]
			
			
			nodeChildUI["node_lab"].childUI["lab_info"] = hUI.label:new({
				parent = nodeChildUI["node_lab"].handle._n,
				text = info,
				x = 0,
				y = 0,
				size = 28,
				align = "LC",
				font = hVar.FONTC,
			})
			local size = nodeChildUI["node_lab"].childUI["lab_info"].handle.s:getContentSize()
			local labwidth = size.width
			if addattr[1][2] then
				local addattr_value = addattr[1][2]
				if (hVar.ItemRewardMillinSecondMode[addattr[1][1]] == 1) then
					addattr_value = addattr_value / 1000
				end
				
				local numtext = ""
				if addattr_value > 0 then
					numtext = "+ "..math.abs(addattr_value)
				else
					numtext = "- "..math.abs(addattr_value)
				end
				
				--百分比显示
				if (hVar.ItemRewardStrMode[addattr[1][1]] == 1) then
					numtext = numtext .. " %"
				end
				
				nodeChildUI["node_lab"].childUI["lab_num"] = hUI.label:new({
					parent = nodeChildUI["node_lab"].handle._n,
					text = numtext,
					x = 20 + labwidth,
					y = -2,
					size = 28,
					align = "LC",
					font = "numWhite",
				})
				local size = nodeChildUI["node_lab"].childUI["lab_num"].handle.s:getContentSize()
				labwidth = labwidth + size.width + 20
			end
			--nodeChildUI["node_lab"]:setXY(30 - labwidth/2,-40)
		end

		nodeChildUI["img_point"] = hUI.image:new({
			parent = nodeParent,
			model = "misc/chariotconfig/point.png",
			x = 42,
			y = - 90,
			scale = 0.8,
		})

		nodeChildUI["lab_cost"] = hUI.label:new({
			parent = nodeParent,
			text = "- " .. tostring(tTakentTree.attrPointUpgrade.requireAttrPoint),
			x = 80,
			y = -90,
			size = 28,
			align = "LC",
			font = "numWhite",
		})

		--[[
		if lv < tTakentTree.attrPointMaxLv then
			_childUI["btn_upgrade"] = hUI.button:new({
				parent = _parent,
				model = "misc/skillup/btnicon_upgrade.png",
				--model = "misc/mask.png",
				dragbox = _childUI["dragBox"],
				x = offx + 330,
				y = offy - 90,
				scale = 0.8,
				scaleT = 0.95,
				code = function()
					SendCmdFunc["tank_talentpoint_addpoint"](tankId, talentid)
				end,
			})
			_tClearUI[#_tClearUI+1] = "btn_upgrade"
		end
		--]]
	end

	_CODE_AutoLign = function(offy)
		local Node =_childUI["node"]
		if Node then
			local waittime = 0.2
			Node.handle._n:runAction(CCMoveTo:create(waittime,ccp(_cliprect[1],offy)))
			hApi.addTimerOnce("ChariotEquipFrmAutoAlign",waittime*1000+100,function()
				hUI.uiSetXY(Node, _cliprect[1],offy)
				_canDrag = true
			end)
		end
	end

	_CODE_AutoLign_talent = function(offy)
		local Node =_childUI["node_talent"]
		if Node then
			local waittime = 0.2
			Node.handle._n:runAction(CCMoveTo:create(waittime,ccp(_cliprect_talent[1],offy)))
			hApi.addTimerOnce("ChariotEquipFrmAutoAlign",waittime*1000+100,function()
				hUI.uiSetXY(Node, _cliprect_talent[1],offy)
				_CODE_AdjustTalentButton()
				_canDrag = true
			end)
		end
	end

	_CODE_AdjustTalentButton = function()
		if _nCurPage > 1 then
			local index = _nCurPage - 1
			local node = _childUI["node_talent"]
			if not(node) then return end
			_childUI["dragBox"]:sortbutton()

			local _NodeChild =  _childUI["node_talent"].childUI
			--更新Grid中按钮
			local btnList = {}
			local tab = _tChariotTalentTab[index]
			if tab then
				for i = 1,#tab.talentid do
					local oBtn = _NodeChild["talent"..i]
					if oBtn then
						oBtn.data.ox = node.data.x
						oBtn.data.oy = node.data.y
						_childUI["dragBox"]:setbutton(oBtn,oBtn.data.ox,oBtn.data.oy)
						
						if hApi.IsInBox(oBtn.data.x+oBtn.data.ox,oBtn.data.y+oBtn.data.oy, _cliprect_talent) then
							--可视区域内
							oBtn.data.state = 1
						else
							--可视区域外   设置为隐藏
							oBtn.data.state = 0
						end
					end
				end
			end
		end
	end
	
	_CODE_OnPageDrag = function(self,tTempPos,tPickParam)
		--print("_CODE_OnPageDrag")
		if 0 == tPickParam.state then
			if (tTempPos.y-tTempPos.ty)^2>144 then	--触摸移动点如果大于12个像素，即作为滑动处理
				if tPickParam.code and tPickParam.code~=0 then			--如果存在拖拉函数，则处理拖拉函数
					local pCode = tPickParam.code
					tPickParam.code = 0
					pCode(self,tTempPos,tPickParam)
				end
				if tPickParam.state==0 then
					tPickParam.state = 1					--设置状态：进入拖拉状态
					tTempPos.tx = tTempPos.x
					tTempPos.ty = tTempPos.y
				else
					return 0
				end
			else
				return 0
			end
		elseif 1 == tPickParam.state then
			--local offy = tTempPos.y-tTempPos.ty
		end
	end 
	
	_CODE_OnInfoUp = function(self,tTempPos,tPickParam)
		--print(tPickParam.state)
		if 1 == tPickParam.state then
			if tPickParam.tip == "tankinfo" then
				local offy = tTempPos.y-tTempPos.ty + tTempPos.oy - _cliprect[2]
				local finaly = offy
				if offy > _dragrect[4] then
					_canDrag = false
					finaly = _cliprect[2]+_dragrect[4]
				elseif offy < 0 then
					finaly = _cliprect[2]
				else
					return
				end
				_canDrag = false
				print("finaly",finaly)
				_CODE_AutoLign(finaly)
			elseif tPickParam.tip == "tanktalent" then
				local offy = tTempPos.y-tTempPos.ty + tTempPos.oy - _cliprect_talent[2]
				local finaly = offy
				if offy > _dragrect_talent[4] then
					_canDrag = false
					finaly = _cliprect_talent[2]+_dragrect_talent[4]
				elseif offy < 0 then
					finaly = _cliprect_talent[2]
				else
					return
				end
				_canDrag = false
				print("finaly",finaly)
				_CODE_AutoLign_talent(finaly)
			end
		elseif 0 == tPickParam.state then
			
		end
	end

	_CODE_RefreshTalent = function(talentpoint)
		--_CODE_CreateChariotTalent(_nCurPage - 1)
		_CODE_UpdateAttr()
		_CODE_UpdateTalent(_nCurPage - 1)
		if _childUI["lab_talentpoint"] then
			_childUI["lab_talentpoint"]:setText(talentpoint)
		end
	end

	_CODE_UpdateTalent = function(index)
		local _NodeParent = _childUI["node_talent"].handle._n
		local _NodeChild =  _childUI["node_talent"].childUI

		local tab = _tChariotTalentTab[index]
		if tab then
			for i = 1,#tab.talentid do
				local talentid = tab.talentid[i]
				

				local btnChild = _NodeChild["talent"..i].childUI
				local btnParent = _NodeChild["talent"..i].handle._n
				hApi.safeRemoveT(btnChild,"img_curlv")

				local tabCT = hVar.tab_chariottalent[talentid] or {}
				local curLv = LuaGetHeroTalentSkillLv(hVar.MY_TANK_ID, talentid)
				local maxLv = math.min(6,tabCT.attrPointMaxLv)
				if curLv > 0 then
					local shownum = 6/maxLv*curLv
					--for j = 1,shownum do
					btnChild["img_curlv"] = hUI.image:new({
						parent = btnParent,
						model = "misc/chariotconfig/tough_learned_0"..shownum..".png",
						z = 1,
					})
				end
				
			end
		end
	end

	_CODE_RefreshFrm = function()
		local tCallback = _tCallback
		local page = _nCurPage
		_CODE_ClearFunc()
		_tCallback = tCallback
		_CODE_InitData()
		_CODE_CreateFrm()
		print("_CODE_RefreshFrm",page,_nCurPage)
		_nCurPage = 0
		_CODE_ClickTypePage(page)
		_CODE_UpdateAttr()
	end
	
	hGlobal.event:listen("LocalEvent_SpinScreen","ChariotEquipFrm",function()
		if _frm and _frm.data.show == 1 then
			_CODE_RefreshFrm()
		end
	end)
	
	--刷新战车装备栏
	hGlobal.event:listen("LocalEvent_UpdateChariotEquipFrm","ChariotEquipFrm",function()
		if _frm and _frm.data.show == 1 then
			_CODE_UpdateAttr()
			_CODE_UpdateEquip()
		end
	end)

	hGlobal.event:listen("LocalEvent_TankAddTalent_Ret","ChariotEquipFrm",function(result, tankId, talentId, requireAttrPoint, costScore, talentPointNew, talentLvNew)
		--print("LocalEvent_TankAddTalent_Ret",result, talentId, requireAttrPoint, costScore, talentPointNew, talentLvNew)
		--取消挡操作
		hUI.NetDisable(0)
		hApi.PlaySound("getcard")
		
		if _frm and _frm.data.show == 1 then
			if result == 1 then
				_CODE_RefreshTalent(talentPointNew)
				--_CODE_RefreshFrm()
			end
		end
	end)
	
	hGlobal.event:listen("LocalEvent_TankRestoreTalent_Ret","ChariotEquipFrm",function(result, tankId, costScore, talentPointNew)
		--print("LocalEvent_TankRestoreTalent_Ret",result, costScore, talentPointNew)
		--取消挡操作
		hUI.NetDisable(0)
		if _frm and _frm.data.show == 1 then
			if result == 1 then
				_CODE_RefreshTalent(talentPointNew)
				--_CODE_RefreshFrm()
			end
		end
	end)
	
	--引导显示两件新手装备穿上的过程
	hGlobal.event:listen("LocalEvent_ShowChariotEquipGuide", "ChariotEquipGuide", function()
		local WAITTIME1 = 1.2
		local FADEINTIME1 = 0.5
		
		--道具1动画
		local index = 1
		local ctrli = _childUI["btn_grid"..index]
		if ctrli then
			hApi.safeRemoveT(ctrli.childUI, "tanhao1")
			
			if ctrli.childUI["bg"] then
				ctrli.childUI["bg"].handle.s:setOpacity(0)
			end
			if ctrli.childUI["equip"] then
				ctrli.childUI["equip"].handle.s:setOpacity(0)
			end
			
			--背景1
			local act1 = CCCallFunc:create(function()
				ctrli.childUI["tanhao1"] = hUI.image:new({
					parent = ctrli.handle._n,
					model = "MODEL_EFFECT:strengthen2",
					x = -3,
					y = 3,
					w = 160,
					h = 160,
				})
			end)
			local act2 = CCDelayTime:create(WAITTIME1)
			local act3 = CCCallFunc:create(function()
				hApi.safeRemoveT(ctrli.childUI, "tanhao1")
				
				--播放领取任务的音效
				hApi.PlaySound("eff_pickup")
			end)
			local act4 = CCFadeIn:create(FADEINTIME1)
			local a = CCArray:create()
			a:addObject(act1)
			a:addObject(act2)
			a:addObject(act3)
			a:addObject(act4)
			local sequence = CCSequence:create(a)
			ctrli.childUI["bg"].handle.s:runAction(sequence)
			
			--道具图标1
			local act1 = CCCallFunc:create(function()
				--
			end)
			local act2 = CCDelayTime:create(WAITTIME1)
			local act3 = CCCallFunc:create(function()
				--
			end)
			local act4 = CCFadeIn:create(FADEINTIME1)
			local a = CCArray:create()
			a:addObject(act1)
			a:addObject(act2)
			a:addObject(act3)
			a:addObject(act4)
			local sequence = CCSequence:create(a)
			ctrli.childUI["equip"].handle.s:runAction(sequence)
		end
		
		--道具2动画
		local index = 2
		local ctrli = _childUI["btn_grid"..index]
		if ctrli then
			hApi.safeRemoveT(ctrli.childUI, "tanhao1")
			
			if ctrli.childUI["bg"] then
				ctrli.childUI["bg"].handle.s:setOpacity(0)
			end
			if ctrli.childUI["equip"] then
				ctrli.childUI["equip"].handle.s:setOpacity(0)
			end
			
			--标记在引导中
			_bInGuideState = true
			
			--背景2
			local act0 = CCDelayTime:create(WAITTIME1 + FADEINTIME1)
			local act1 = CCCallFunc:create(function()
				ctrli.childUI["tanhao1"] = hUI.image:new({
					parent = ctrli.handle._n,
					model = "MODEL_EFFECT:strengthen2",
					x = -3,
					y = 3,
					w = 160,
					h = 160,
				})
			end)
			local act2 = CCDelayTime:create(WAITTIME1)
			local act3 = CCCallFunc:create(function()
				hApi.safeRemoveT(ctrli.childUI, "tanhao1")
				
				--播放领取任务的音效
				hApi.PlaySound("eff_pickup")
			end)
			local act4 = CCFadeIn:create(FADEINTIME1)
			local act5 = CCDelayTime:create(WAITTIME1)
			local act6 = CCCallFunc:create(function()
				--标记不在引导中
				_bInGuideState = false
				
				--关闭装备界面
				_CODE_CloseFunc()
			end)
			local a = CCArray:create()
			a:addObject(act0)
			a:addObject(act1)
			a:addObject(act2)
			a:addObject(act3)
			a:addObject(act4)
			a:addObject(act5)
			a:addObject(act6)
			local sequence = CCSequence:create(a)
			ctrli.childUI["bg"].handle.s:runAction(sequence)
			
			--道具图标2
			local act0 = CCDelayTime:create(WAITTIME1 + FADEINTIME1)
			local act1 = CCCallFunc:create(function()
				--
			end)
			local act2 = CCDelayTime:create(WAITTIME1)
			local act3 = CCCallFunc:create(function()
				--
			end)
			local act4 = CCFadeIn:create(FADEINTIME1)
			local a = CCArray:create()
			a:addObject(act0)
			a:addObject(act1)
			a:addObject(act2)
			a:addObject(act3)
			a:addObject(act4)
			local sequence = CCSequence:create(a)
			ctrli.childUI["equip"].handle.s:runAction(sequence)
		end
	end)
	
	--"LocalEvent_ShowChariotEquipFrm"
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(tCallback)
		if _frm and _frm.data.show == 1 then
			return
		end
		_CODE_ClearFunc()
		--CommentManage.EnterArea("tankconfig")
		CommentManage.ReadyComment(hVar.CommentTargetTypeDefine.TANKTALENT)
		_tCallback = tCallback
		_CODE_InitData()
		_CODE_CreateFrm()
		_CODE_ClickTypePage(1)
		--_CODE_CreatePageBtn()
		_CODE_UpdateAttr()
		hGlobal.event:event("LocalEvent_HideBarrage")
	end)
end
--[[
--测试 --test
if hGlobal.UI.ChariotEpuipFrm then
	hGlobal.UI.ChariotEpuipFrm:del()
	hGlobal.UI.ChariotEpuipFrm = nil
end
hGlobal.UI.InitChariotEpuipFrm("include")
--加载战车装备栏界面
hGlobal.event:event("LocalEvent_ShowChariotEquipFrm", nil)
]]

hGlobal.UI.InitUpgradeChariotTalentFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowUpgradeChariotTalentFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _borderW = 640
	local _borderH = 600
	local _frm, _childUI,_parent = nil,nil,nil
	local _nTalentId = 0
	local _nTalentLv = 0
	local _nTalentMaxLv = 0
	local _nCostPoint = 0
	local _tTakentTree = {}
	local _sIcon = ""

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CloseFrm = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateUI = hApi.DoNothing
	local _CODE_CreateTalentInfo = hApi.DoNothing
	local _CODE_CreateTalentIcon = hApi.DoNothing
	local _CODE_CreateTalentDescribe = hApi.DoNothing
	local _CODE_CreateAttrInfo = hApi.DoNothing
	local _CODE_UpdateAttrLab = hApi.DoNothing
	local _CODE_InitData = hApi.DoNothing
	local _CODE_AddEvent = hApi.DoNothing
	local _CODE_ClearEvent = hApi.DoNothing
	local _CODE_RebuildAfterSpinScreen = hApi.DoNothing
	
	_CODE_ClearFunc = function()
		if hGlobal.UI.UpgradeChariotTalentFrm then
			hGlobal.UI.UpgradeChariotTalentFrm:del()
			hGlobal.UI.UpgradeChariotTalentFrm = nil
		end
		_frm, _childUI,_parent = nil,nil,nil
		_nTalentId = 0
		_nTalentLv = 0
		_nTalentMaxLv = 0
		_nCostPoint = 0
		_tTakentTree = {}
		_sIcon = ""
		
		--标记不在引导中
		_bInGuideState = false
	end

	_CODE_CloseFrm = function()
		_CODE_ClearEvent()
		_CODE_ClearFunc()
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.UpgradeChariotTalentFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			dragable = 0,
			show = 0,
			z = hZorder.MainBaseFirstFrm + 1,
		})
		_frm = hGlobal.UI.UpgradeChariotTalentFrm
		_childUI = _frm.childUI
		_parent = _frm.handle._n

		_CODE_CreateUI()

		_frm:show(1)
		_frm:active()
	end

	_CODE_CreateUI = function()
		local offx = hVar.SCREEN.w/2
		local offy = -hVar.SCREEN.h/2

		_childUI["_blackpanel"] = hUI.image:new({
			parent = _parent,
			model = "UI:zhezhao",
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h/2,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = -1,
		})
		_frm.childUI["_blackpanel"].handle.s:setOpacity(160)

		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/button_null.png",
			--model = "misc/mask.png",
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			x = offx,
			y = offy,
			code = function()
				_CODE_CloseFrm()
			end,
		})

		_childUI["btn_border"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/button_null.png",
			--model = "misc/mask.png",
			w = _borderW,
			h = _borderH,
			x = offx,
			y = offy,
			z = 0,
		})
		local img9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/itemtip.png",0, 0, _borderW + 10, _borderH + 10, _childUI["btn_border"])
	
		_CODE_CreateTalentInfo()
		_CODE_CreateTalentDescribe()

		if _nTalentLv < _nTalentMaxLv then
			_childUI["img_point"] = hUI.image:new({
				parent = _parent,
				model = "misc/chariotconfig/point.png",
				x = offx - 38,
				y = offy - _borderH/2 + 156,
				scale = 0.8,
			})

			_childUI["lab_cost"] = hUI.label:new({
				parent = _parent,
				text = "- " .. tostring(_nCostPoint),
				x = offx + 26,
				y = offy - _borderH/2 + 156,
				size = 28,
				align = "MC",
				font = "numWhite",
			})

			_childUI["btn_ok"] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				model = "misc/chest/itembtn.png",
				label = {text = hVar.tab_string["upgrade"],size = 24,border = 1,font = hVar.FONTC,y = 4,height= 32,},
				scaleT = 0.95,
				x = offx,
				y = offy - _borderH/2 + 80,
				--scale = 0.74,
				code = function()
					hUI.NetDisable(5000)
					local tankIdx = LuaGetHeroTankIdx()
					local tankId = hVar.tab_unit[hVar.MY_TANK_ID].tank_unit[tankIdx]
					SendCmdFunc["tank_talentpoint_addpoint"](tankId, _nTalentId)
					_CODE_CloseFrm()
				end,
			})
		end
	end

	_CODE_CreateTalentIcon = function(uiname,x,y,shownum)
		_childUI[uiname] = hUI.button:new({
			parent = _parent,
			model = _sIcon,
			x = x,
			y = y,
		})

		if shownum > 0 then
			_childUI[uiname].childUI["img_curlv"] = hUI.image:new({
				parent = _childUI[uiname].handle._n,
				model = "misc/chariotconfig/tough_learned_0"..shownum..".png",
				z = 1,
			})
		end
	end

	_CODE_CreateTalentInfo = function()
		local offx = hVar.SCREEN.w/2
		local offy = -hVar.SCREEN.h/2
		local showy = offy + _borderH/2 - 90
		--local 
		if _nTalentLv == 0 then
			_CODE_CreateTalentIcon("img_talenticon1",offx - 150,showy,0)
			local shownum = 6/_nTalentMaxLv * (_nTalentLv + 1)
			_CODE_CreateTalentIcon("img_talenticon2",offx + 150,showy,shownum)

			_childUI["img_arrow"] = hUI.image:new({
				parent = _parent,
				model = "misc/chariotconfig/arrow_r.png",
				z = 1,
				scale = 0.8,
				x = offx,
				y = showy,
			})
		elseif _nTalentLv >= _nTalentMaxLv then
			_CODE_CreateTalentIcon("img_talenticon1",offx,showy,6)
		else
			local shownum = 6/_nTalentMaxLv * _nTalentLv
			_CODE_CreateTalentIcon("img_talenticon1",offx - 150,showy,shownum)
			local shownum = 6/_nTalentMaxLv * (_nTalentLv + 1)
			_CODE_CreateTalentIcon("img_talenticon2",offx + 150,showy,shownum)

			_childUI["img_arrow"] = hUI.image:new({
				parent = _parent,
				model = "misc/chariotconfig/arrow_r.png",
				z = 1,
				scale = 0.8,
				x = offx,
				y = showy,
			})
		end
	end

	_CODE_CreateTalentDescribe = function()
		local offx = hVar.SCREEN.w/2
		local offy = -hVar.SCREEN.h/2

		if type(_tTakentTree.attrAdd) ~= "table" then
			return
		end

		local showlist = {}
		local infoW = _borderW - 80
		local infoH = 180
		local labcenter  = - 26
		local nodeoffy = 20
		--_nTalentLv = 2
		if _nTalentLv == 0 then
			infoW = 400
			showlist[#showlist + 1] = {_nTalentLv+1,{str = "__TEXT_get_after_upgrade"}}
		elseif _nTalentLv >= _nTalentMaxLv then
			infoW = 320
			nodeoffy = - 60
			showlist[#showlist + 1] = {_nTalentLv,{str = "__TEXT_cur_get"}}
		else
			showlist[#showlist + 1] = {_nTalentLv,{str = "__TEXT_cur_get"}}
			showlist[#showlist + 1] = {_nTalentLv + 1,{str = "__TEXT_nextlv_get"}}
		end
		local maxnum = 0
		local maxnumidx = 0
		for i = 1,#showlist do
			local showlv = showlist[i][1]
			local tAddAttr = _tTakentTree.attrAdd[showlv]
			if type(tAddAttr) == "table" then
				local num = #tAddAttr
				if num > maxnum then
					maxnum = num
					maxnumidx = i
				end
				if num == 1 then
					showlist[i][2].labcenter = - 18
					showlist[i][2].delteH = 0
				elseif num == 2 then
					infoH = 220
					showlist[i][2].labcenter = - 24
					showlist[i][2].delteH = 54
				elseif num == 3 then
					infoH = 220
					showlist[i][2].labcenter = labcenter
					showlist[i][2].delteH = 42
				end
				showlist[i][2].usenum = num
			end
		end
		--取最大行
		if #showlist > 1 then
			for i = 1,#showlist do
				if i ~= maxnumidx and showlist[i][2].usenum ~= maxnum then
					showlist[i][2].labcenter = showlist[maxnumidx][2].labcenter
					showlist[i][2].delteH = showlist[maxnumidx][2].delteH
					showlist[i][2].usenum = showlist[maxnumidx][2].usenum
				end
			end
		end
		
		_childUI["btn_node"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			--model = "misc/mask.png",
			w = infoW,
			h = infoH,
			x = offx,
			y = offy + nodeoffy,
			z = 1,
		})
		local node =  _childUI["btn_node"]
		local nodeParent = node.handle._n
		local nodeChild = node.childUI
		local img9 = hApi.CCScale9SpriteCreate("data/image/misc/treasure/medal_content.png",0, 0, infoW, infoH, node,-1)
		
		if #showlist > 1 then
			nodeChild["img_arrow"] = hUI.image:new({
				parent = nodeParent,
				model = "misc/chariotconfig/arrow_r.png",
				scale = 0.5,
			})
		end
		--table_print(showlist)
		for i = 1,#showlist do
			local showlv = showlist[i][1]
			local config = showlist[i][2]
			local startx = 0
			if #showlist == 2 then
				if i == 1 then
					startx = - 160
				else
					startx = 160
				end
			end

			nodeChild["lab_title"..i] = hUI.label:new({
				parent = nodeParent,
				text = hVar.tab_string[config.str],
				x = startx,
				y = infoH/2 - 40,
				align = "MC",
				size = 26,
				font = hVar.FONTC,
				RGB = {213,173,65},
			})
			
			local tSize = {}
			local tAddAttr = _tTakentTree.attrAdd[showlv]
			if type(tAddAttr) == "table" then
				for j = 1,#tAddAttr do
					local attr = tAddAttr[j]
					local x = startx
					local y = config.labcenter + ((config.usenum+1)/2 - j) * config.delteH
					local uiname = "lab_node_"..i.."_"..j
					print(x,y)
					nodeChild[uiname] = hUI.button:new({
						parent = nodeParent,
						model = "misc/button_null.png",
						x = x,
						y = y,
						w = 1,
						h = 1,
					})
					_CODE_CreateAttrInfo(nodeChild[uiname],attr,tSize)
					_CODE_UpdateAttrLab(i,tSize)
				end
			end
		end
	end

	_CODE_UpdateAttrLab = function(i,tSize)
		local node =  _childUI["btn_node"]
		local nodeParent = node.handle._n
		local nodeChild = node.childUI
		if #tSize == 1 then	--居中
			local uiname = "lab_node_"..i.."_1"
			local labnode = nodeChild[uiname]
			if labnode then
				local totalw = tSize[1][1] + tSize[1][2]
				labnode.childUI["lab_attr"]:setXY(-totalw/2,0)
				labnode.childUI["lab_value"]:setXY(-totalw/2 + tSize[1][1] + 12,0)
			end
		else	--以最长的作为标准
			local maxLw = 0
			local maxRw = 0
			for z = 1,#tSize do
				if tSize[z][1] > maxLw then
					maxLw = tSize[z][1]
				end
				if tSize[z][2] > maxRw then
					maxRw = tSize[z][2]
				end
			end
			local totalw = maxLw + maxRw
			for z = 1,#tSize do
				local uiname = "lab_node_"..i.."_"..z
				local labnode = nodeChild[uiname]
				if labnode then
					labnode.childUI["lab_attr"]:setXY(-totalw/2,0)
					labnode.childUI["lab_value"]:setXY(-totalw/2 + maxLw + 12,0)
				end
			end
		end
	end

	_CODE_CreateAttrInfo = function(node,attr,tSize)
		tSize[#tSize + 1] = {}
		local attrname = attr[1]
		local value = attr[2]
		local str = hVar.tab_string[hVar.ItemRewardStr[attrname]]
		node.childUI["lab_attr"] = hUI.label:new({
			parent = node.handle._n,
			text = str,
			x = - 100,
			y = 0,
			align = "LC",
			size = 26,
			font = hVar.FONTC,
		})
		local w1 = node.childUI["lab_attr"]:getWH()
		tSize[#tSize][1] = w1

		if value then
			local addattr_value = value
			if (hVar.ItemRewardMillinSecondMode[attrname] == 1) then
				addattr_value = addattr_value / 1000
			end
			
			local numtext = ""
			if addattr_value > 0 then
				numtext = "+ "..math.abs(addattr_value)
			else
				numtext = "- "..math.abs(addattr_value)
			end
			
			--百分比显示
			if (hVar.ItemRewardStrMode[attrname] == 1) then
				numtext = numtext .. " %"
			end

			node.childUI["lab_value"] = hUI.label:new({
				parent = node.handle._n,
				text = numtext,
				x = 20,
				y = 0,
				align = "LC",
				size = 20,
				font = "numWhite",
			})
			local w2 = node.childUI["lab_value"]:getWH()
			tSize[#tSize][2] = w2
		end
	end

	_CODE_AddEvent = function()
		hGlobal.event:listen("LocalEvent_refreshafterSpinScreen","UpgradeChariotTalentFrm",_CODE_RebuildAfterSpinScreen)
	end

	_CODE_ClearEvent = function()
		hGlobal.event:listen("LocalEvent_refreshafterSpinScreen","UpgradeChariotTalentFrm",nil)
	end

	_CODE_InitData = function(nTalentId,sIcon)
		local tTakentTree = hVar.tab_chariottalent[nTalentId]
		if type(tTakentTree) ~= "table" then
			return -1
		end
		_tTakentTree = tTakentTree
		_nTalentId = nTalentId
		_sIcon = sIcon
		local tabCT = hVar.tab_chariottalent[_nTalentId] or {}
		_nTalentLv = LuaGetHeroTalentSkillLv(hVar.MY_TANK_ID, _nTalentId)
		_nTalentMaxLv = math.min(6,tabCT.attrPointMaxLv)
		--测试
		--_nTalentLv = _nTalentMaxLv
		if _nTalentLv < _nTalentMaxLv then
			_borderW = 640
			_borderH = 600
		else
			_borderW = 480
			_borderH = 480
		end
		_nCostPoint = tTakentTree.attrPointUpgrade.requireAttrPoint
	end

	_CODE_RebuildAfterSpinScreen = function()
		if _frm and _frm.data.show == 1 then
			local nTalentId = _nTalentId
			local sIcon = _sIcon
			_CODE_ClearFunc()
			_CODE_InitData(nTalentId,sIcon)
			_CODE_CreateFrm()
		end
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(nTalentId,sIcon)
		_CODE_ClearFunc()
		if _CODE_InitData(nTalentId,sIcon) == -1 then
			return
		end
		_CODE_CreateFrm()
		_CODE_AddEvent()
	end)
end


--重置天赋点界面
hGlobal.UI.InitResetChariotTalentFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowResetChariotTalentFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _borderW = 420
	local _borderH = 560
	local _frm, _childUI,_parent = nil,nil,nil
	local _bombnum = 0
	local _survivenum = 0
	local _hunternum = 0

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateUI = hApi.DoNothing
	local _CODE_CreateStar = hApi.DoNothing
	local _CODE_UpdateInfo = hApi.DoNothing
	local _CODE_GetTalentTypeUseNum = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.ResetChariotTalentFrm then
			hGlobal.UI.ResetChariotTalentFrm:del()
			hGlobal.UI.ResetChariotTalentFrm = nil
		end
		_frm, _childUI,_parent = nil,nil,nil
		_bombnum = 0
		_survivenum = 0
		_hunternum = 0
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.ResetChariotTalentFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			dragable = 0,
			show = 0,
			z = hZorder.MainBaseFirstFrm + 1,
		})
		_frm = hGlobal.UI.ResetChariotTalentFrm
		_childUI = _frm.childUI
		_parent = _frm.handle._n

		_CODE_CreateUI()

		_frm:show(1)
		_frm:active()
	end

	_CODE_CreateUI = function()
		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/button_null.png",
			--model = "misc/mask.png",
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h/2,
			code = function()
				_CODE_ClearFunc()
			end,
		}) 

		_childUI["btn_border"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/button_null.png",
			--model = "misc/mask.png",
			w = _borderW,
			h = _borderH,
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h/2,
		})
		local img9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/itemtip.png",0, 0, _borderW + 10, _borderH + 10, _childUI["btn_border"])

		_childUI["_blackpanel"] = hUI.image:new({
			parent = _parent,
			model = "UI:zhezhao",
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h/2,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = -1,
		})
		_childUI["_blackpanel"].handle.s:setOpacity(160)

		local starty = -hVar.SCREEN.h/2 + 140
		_childUI["img_gague"] = hUI.button:new({
			parent = _parent,
			model = "misc/chariotconfig/skill_gague.png",
			x = hVar.SCREEN.w/2,
			y = starty - 100,
		})

		_childUI["img_TalentType_BOMB"] = hUI.button:new({
			parent = _parent,
			model = "misc/chariotconfig/ws_tab02_selected.png",
			x = hVar.SCREEN.w/2,
			y = starty,
		})
		_CODE_CreateStar(_childUI["img_TalentType_BOMB"],84)


		_childUI["img_TalentType_SURVIVE"] = hUI.button:new({
			parent = _parent,
			model = "misc/chariotconfig/ws_tab03_selected.png",
			x = hVar.SCREEN.w/2 - 98,
			y = starty - 170,
		})
		_CODE_CreateStar(_childUI["img_TalentType_SURVIVE"],-84)

		_childUI["img_TalentType_HUNTER"] = hUI.button:new({
			parent = _parent,
			model = "misc/chariotconfig/ws_tab04_selected.png",
			x = hVar.SCREEN.w/2 + 98,
			y = starty - 170,
		})
		_CODE_CreateStar(_childUI["img_TalentType_HUNTER"],-84)
		
		--重置天赋按钮
		_childUI["btn_clear"] = hUI.button:new({
			parent = _parent,
			model = "misc/chest/itembtn.png",
			--model = "misc/mask.png",
			dragbox = _childUI["dragBox"],
			x = hVar.SCREEN.w/2,
			y = starty - 350,
			scaleT = 0.95,
			w = 120,
			h = 70,
			code = function()
				--已经升过了天赋点，才需要重置
				if _bombnum + _survivenum + _hunternum > 0 then
					local MsgSelections = nil
					MsgSelections = {
						style = "mini",
						select = 0,
						ok = function()
							if g_GameCurrencyResource.keshi < 200 then
								hApi.NotEnoughResource("keshi")
							else
								--挡操作
								hUI.NetDisable(3000)
								
								local tankIdx = LuaGetHeroTankIdx()
								local tankId = hVar.tab_unit[hVar.MY_TANK_ID].tank_unit[tankIdx]
								SendCmdFunc["tank_talentpoint_restore"](tankId)
							end
							
							_CODE_ClearFunc()
						end,
						cancel = function()
							--
						end,
						--cancelFun = cancelCallback, --点否的回调函数
						--textOk = "确定", --language
						textOk = hVar.tab_string["Exit_Ack"], --language
						--textCancel = "取消", --language
						textCancel = hVar.tab_string["__TEXT_Cancel"], --language
						userflag = 0, --用户的标记
					}
					local showTitle = hVar.tab_string["__TEXT_ResetALL"] --"您确定要重置吗？"
					local msgBox = hGlobal.UI.MsgBox(showTitle, MsgSelections)
					msgBox:active()
					msgBox:show(1,"fade",{time=0.08})
				end
			end,
		})
		
		_childUI["btn_clear"].childUI["lab"] = hUI.label:new({
			parent = _childUI["btn_clear"].handle._n,
			text = hVar.tab_string["__TEXT_Reset"],
			font = hVar.FONTC,
			align = "MC",
			size = 22,
			y = 4,
		})

		_childUI["img_keshi"] = hUI.image:new({
			parent = _parent,
			model = "misc/skillup/keshi.png",
			x = hVar.SCREEN.w/2 - 32 + 130,
			y = _childUI["btn_clear"].data.y,
			scale = 0.7,
		})

		_childUI["lab_keshi"] = hUI.label:new({
			parent = _parent,
			x = hVar.SCREEN.w/2 + 26 + 130,
			y = _childUI["btn_clear"].data.y,
			text = "200",
			font = "numWhite",
			align = "MC",
			size = 24,
		})
	end

	_CODE_CreateStar = function(node,offy)
		node.childUI["star"] = hUI.image:new({
			parent = node.handle._n,
			model = "misc/chariotconfig/point.png",
			x = - 24,
			y = offy,
			scale = 0.8,
		})

		node.childUI["num"] = hUI.label:new({
			parent = node.handle._n,
			text = "0",
			align = "LC",
			size = 24,
			font = "numWhite",
			x = 8,
			y = offy,
		})
	end

	_CODE_UpdateInfo = function()
		_bombnum = _CODE_GetTalentTypeUseNum(hVar.ChariotTalentType.BOMB)
		_survivenum = _CODE_GetTalentTypeUseNum(hVar.ChariotTalentType.SURVIVE)
		_hunternum = _CODE_GetTalentTypeUseNum(hVar.ChariotTalentType.HUNTER)
		_childUI["img_TalentType_BOMB"].childUI["num"]:setText(_bombnum)
		_childUI["img_TalentType_SURVIVE"].childUI["num"]:setText(_survivenum)
		_childUI["img_TalentType_HUNTER"].childUI["num"]:setText(_hunternum)

		if _bombnum + _survivenum + _hunternum == 0 then
			hApi.AddShader(_childUI["btn_clear"].handle.s, "gray")
		elseif g_GameCurrencyResource.keshi < 200 then
			_childUI["lab_keshi"].handle.s:setColor(ccc3(255,0,0))
			hApi.AddShader(_childUI["btn_clear"].handle.s, "gray")
		else
			hApi.AddShader(_childUI["btn_clear"].handle.s, "normal")
		end
	end
		
	_CODE_GetTalentTypeUseNum = function(ntype)
		local usenum = 0
		local list = hVar.ChariotAttrList[ntype]
		if list then
			for talentid in pairs(list) do
				print("talentid",talentid)
				local tabCT = hVar.tab_chariottalent[talentid]
				if tabCT then
					local curLv = LuaGetHeroTalentSkillLv(hVar.MY_TANK_ID, talentid)
					local point = tabCT.attrPointUpgrade.requireAttrPoint
					usenum = usenum + point * curLv
				end
			end
		end
		return usenum
	end

	hGlobal.event:listen("LocalEvent_refreshafterSpinScreen","ResetChariotTalenFrm",function()
		if _frm then
			_CODE_ClearFunc()
			_CODE_CreateFrm()
			_CODE_UpdateInfo()
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_CODE_ClearFunc()
		_CODE_CreateFrm()
		_CODE_UpdateInfo()
	end)
end

hGlobal.UI.InitClearEquipFrm = function(mode)
	local tInitEventName = {"localEvent_ShowClearEquipFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _frm,_childUI,_parent = nil,nil,nil
	
	local _nMaxPage = 5
	local _tChoose = {}
	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_ClearLowEquip = hApi.DoNothing
	local _CODE_ClearALLEquip = hApi.DoNothing
	local _CODE_ClearChooseEquip = hApi.DoNothing
	local _CODE_CreateEquipQualityBtn = hApi.DoNothing
	local _CODE_CliceOk = hApi.DoNothing
	local _CODE_ChooseQuality = hApi.DoNothing
	
	_CODE_ClearFunc = function()
		_tChoose = {}
		if hGlobal.UI.ClearEquipFrm then
			hGlobal.UI.ClearEquipFrm:del()
			hGlobal.UI.ClearEquipFrm = nil
		end
		_frm,_childUI,_parent = nil,nil,nil
	end

	_CODE_ClearChooseEquip = function()
		local num = 0
		local tLv = {}
		for _,lv in pairs(_tChoose) do
			tLv[lv] = 1
			num = num + 1
		end
		if num > 0 then
			--挡操作
			hUI.NetDisable(3000)
					
			--发送指令出售装备
			local tRedequip_dbid = {}
			local storehouse = LuaGetStoreHouse()
			if (type(storehouse) == "table") then
				for index = 1,hVar.EquipMaxNum do
					local uid = storehouse[index]
					local _,oEquip = LuaFindEquipByUniqueId(uid)
					if type(oEquip) == "table" then
						local itemId = oEquip[hVar.ITEM_DATA_INDEX.ID]
						local tabI = hVar.tab_item[itemId] or {}
						local itemLv = tabI.itemLv or 1
						--print(itemId,itemLv,hVar.ITEM_QUALITY.ORANGE)
						if itemLv < hVar.ITEM_QUALITY.ORANGE and tLv[itemLv] == 1 then
							local tfrom = oEquip[hVar.ITEM_DATA_INDEX.FROM]
							if (type(tfrom) == "table") then
								for k = 1, #tfrom, 1 do
									if (type(tfrom[k]) == "table") then
										if (tfrom[k][1] == hVar.ITEM_FROMWHAT_TYPE.NET) then
											local dbid = tfrom[k][2]
											if dbid > 0 then
												tRedequip_dbid[#tRedequip_dbid + 1] = dbid
											end
											break
										end
									end
								end
							end
						end
					end
				end
			end
			if #tRedequip_dbid > 0 then
				SendCmdFunc["descompos_redequip"](#tRedequip_dbid, tRedequip_dbid)
			else
				hUI.NetDisable(0)
			end
		end
	end

	_CODE_ChooseQuality = function(index,lv)
		local show = false
		if _tChoose[index] then
			_tChoose[index] = nil
		else
			_tChoose[index] = lv
			show = true
		end
		local btn = _childUI["btn_quality"..index]
		if btn and btn.childUI["gou"] then
			btn.childUI["gou"].handle._n:setVisible(show)
		end
	end

	_CODE_CreateEquipQualityBtn = function()
		local offX = hVar.SCREEN.w/2
		local offY = -hVar.SCREEN.h/2
		local borderW = 480
		local borderH = 360
		local _tTypeList = {1,2}
		local offw = 180
		if g_lua_src == 1 then
			_tTypeList = {1,2,3}
			offw = 148
		end
		local shownum = #_tTypeList
		for i = 1,shownum do
			local lv = _tTypeList[i]
			local str = hVar.tab_string["__TEXT_EquipQuality"..lv]
			local x = (i - (shownum+1)/2) * offw + offX
			_childUI["btn_quality"..i] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				x = x,
				y = offY + 20,
				w = 120,
				h = 60,
				model = "misc/button_null.png",
				code = function()
					_CODE_ChooseQuality(i,lv)
				end,
			})

			local btnChild = _childUI["btn_quality"..i].childUI
			local btnParent = _childUI["btn_quality"..i].handle._n

			btnChild["kuang"] = hUI.image:new({
				parent = btnParent,
				model = "UI:Button_SelectBorder",
				x = - 32,
				scale = 0.5,
			})

			btnChild["gou"] = hUI.image:new({
				parent = btnParent,
				model = "misc/gopherboom/gou.png",
				x = - 32 + 4,
				--scale = 0.9,
			})
			btnChild["gou"].handle._n:setVisible(false)

			btnChild["lab"] = hUI.label:new({
				parent = btnParent,
				text = str,
				align = "LC",
				font = hVar.FONTC,
				size = 24,
				x = 0,
				RGB = hVar.ITEM_ELITE_LEVEL[lv].NAMERGB,
			})
		end
	end
	
	_CODE_CreateFrm = function(ntype)
		hGlobal.UI.ClearEquipFrm  = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			dragable = 0,
			show = 0,
			--z = -1,
			z = hZorder.MainBaseFirstFrm + 1,
			buttononly = 1,
		})
		_frm = hGlobal.UI.ClearEquipFrm
		_childUI = _frm.childUI
		_parent = _frm.handle._n

		_childUI["_blackpanel"] = hUI.image:new({
			parent = _parent,
			model = "UI:zhezhao",
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h/2,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = -1,
		})
		_frm.childUI["_blackpanel"].handle.s:setOpacity(160)

		local offX = hVar.SCREEN.w/2
		local offY = -hVar.SCREEN.h/2
		local borderW = 480
		local borderH = 360

		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = offY,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			code = function()
				_CODE_ClearFunc()
			end,
		})
		
		--创建技能tip图片背景
		_childUI["ItemBG_1"] = hUI.button:new({
			parent = _parent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "misc/skillup/msgbox4.png",
			dragbox = _childUI["dragBox"],
			x = offX,
			y = offY,
			w = borderW,
			h = borderH,
			code = function()
				--print("技能tip图片背景")
			end,
		})
		
		local btnChild = _childUI["ItemBG_1"].childUI
		local btnParent = _childUI["ItemBG_1"].handle._n

		btnChild["title"] = hUI.label:new({
			parent = btnParent,
			text = hVar.tab_string["__TEXT_ExchangeEquip"],
			align = "MC",
			font = hVar.FONTC,
			size = 28,
			x = 0,
			y = borderH/2 - 54,
		})

		_CODE_CreateEquipQualityBtn()

		_childUI["btn_ok"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/addition/cg.png",
			--w = 166,
			--h = 64,
			scale = 0.74,
			label = {text = hVar.tab_string["Exit_Ack"],size = 24,border = 1,font = hVar.FONTC,y = 2,height= 32,},
			x = offX,
			y = offY-borderH/2 + 72,
			code = function()
				_CODE_ClearChooseEquip()
				_CODE_ClearFunc()
			end,
		})
--		_childUI["btn_clearlow"] = hUI.button:new({
--			parent = _parent,
--			model = "misc/addition/cg.png",
--			label = {text = hVar.tab_string["低品质"],size = 28,border = 1,font = hVar.FONTC,y = 4,height= 32,},
--			dragbox = _childUI["dragBox"],
--			scaleT = 0.95,
--			x = offX,
--			y = offY + 30,
--			scale = 0.74,
--			--w = 124,
--			--h = 52,
--			code = function()
--				_CODE_ClearLowEquip()
--				_CODE_ClearFunc()
--			end,
--		})
--
--		_childUI["btn_clearall"] = hUI.button:new({
--			parent = _parent,
--			model = "misc/addition/cg.png",
--			label = {text = hVar.tab_string["全部装备"],size = 28,border = 1,font = hVar.FONTC,y = 4,height= 32,},
--			dragbox = _childUI["dragBox"],
--			scaleT = 0.95,
--			x = offX,
--			y = offY - 70,
--			scale = 0.74,
--			--w = 124,
--			--h = 52,
--			code = function()
--				_CODE_ClearALLEquip()
--				_CODE_ClearFunc()
--			end,
--		})
		
		_frm:show(1)
		_frm:active()
	end

	_CODE_ClearLowEquip = function()
		--挡操作
		hUI.NetDisable(3000)
				
		--发送指令出售装备
		local tRedequip_dbid = {}
			
		local storehouse = LuaGetStoreHouse()
		if (type(storehouse) == "table") then
			for index = 1,hVar.EquipMaxNum do
				local uid = storehouse[index]
				local _,oEquip = LuaFindEquipByUniqueId(uid)
				if type(oEquip) == "table" then
					print("aaaa")
					local itemId = oEquip[hVar.ITEM_DATA_INDEX.ID]
					local tabI = hVar.tab_item[itemId] or {}
					local itemLv = tabI.itemLv or 1
					print(itemId,itemLv,hVar.ITEM_QUALITY.ORANGE)
					if itemLv < hVar.ITEM_QUALITY.ORANGE then
						local tfrom = oEquip[hVar.ITEM_DATA_INDEX.FROM]
						if (type(tfrom) == "table") then
							for k = 1, #tfrom, 1 do
								if (type(tfrom[k]) == "table") then
									if (tfrom[k][1] == hVar.ITEM_FROMWHAT_TYPE.NET) then
										local dbid = tfrom[k][2]
										if dbid > 0 then
											tRedequip_dbid[#tRedequip_dbid + 1] = dbid
										end
										break
									end
								end
							end
						end
					end
				end
			end
		end
		if #tRedequip_dbid > 0 then
			SendCmdFunc["descompos_redequip"](#tRedequip_dbid, tRedequip_dbid)
		else
			hUI.NetDisable(0)
		end
	end
	
	_CODE_ClearALLEquip = function()
		--挡操作
		hUI.NetDisable(3000)
				
		--发送指令出售装备
		local tRedequip_dbid = {}
			
		local storehouse = LuaGetStoreHouse()
		if (type(storehouse) == "table") then
			for index = 1,hVar.EquipMaxNum do
				local uid = storehouse[index]
				local _,oEquip = LuaFindEquipByUniqueId(uid)
				if type(oEquip) == "table" then
					local itemid = oEquip[hVar.ITEM_DATA_INDEX.ID]
					local tfrom = oEquip[hVar.ITEM_DATA_INDEX.FROM]
					if (type(tfrom) == "table") then
						for k = 1, #tfrom, 1 do
							if (type(tfrom[k]) == "table") then
								if (tfrom[k][1] == hVar.ITEM_FROMWHAT_TYPE.NET) then
									local dbid = tfrom[k][2]
									if dbid > 0 then
										tRedequip_dbid[#tRedequip_dbid + 1] = dbid
									end
									break
								end
							end
						end
					end
				end
			end
		end

		if #tRedequip_dbid > 0 then
			SendCmdFunc["descompos_redequip"](#tRedequip_dbid, tRedequip_dbid)
		else
			hUI.NetDisable(0)
		end
	end
	
	hGlobal.event:listen("LocalEvent_refreshafterSpinScreen","ClearEquipFrm",function()
		if _frm and _frm.data.show == 1 then
			_CODE_ClearFunc()
			_CODE_CreateFrm()
		end
	end)
	
	--"localEvent_ShowChariotItemFrm"
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_CODE_ClearFunc()
		_nMaxPage = LuaGetPlayerBagPageNum(LuaGetPlayerVipLv())
		--print("vip=", LuaGetPlayerVipLv())
		--print("_nMaxPage=", _nMaxPage)
		_CODE_CreateFrm()
	end)
end

