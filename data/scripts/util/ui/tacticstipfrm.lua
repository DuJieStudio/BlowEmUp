hGlobal.UI.InitTacticsTipFrm = function(mode)
	local tInitEventName = {"localEvent_ShowTacticsTipFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _nBoardW = 430
	local _frm,_childUI,_parent = nil,nil,nil
	local _nTacticsId = 0
	local _nLv = 1
	local _nShowX = 0
	local _nShowY = 0
	local _nMode = 0

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_InitData = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateTacticsInfo = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.TacticsTipFrm then
			hGlobal.UI.TacticsTipFrm:del()
			hGlobal.UI.TacticsTipFrm = nil
		end
		_frm,_childUI,_parent = nil,nil,nil
		_nTacticsId = 0
		_nLv = 1
		_nShowX = 0
		_nShowY = 0
		_nMode = 0
	end

	_CODE_InitData = function(nTactics,nLv,nMode,nx,ny)
		_nTacticsId = nTactics
		_nLv = nLv
		_nShowX = hVar.SCREEN.w /2
		_nShowY = -hVar.SCREEN.h /2
		_nMode = nMode
		--nMode = 1 居中  nMode = nil 对准左上角
		if nMode == nil then
			if nx and ny then
				_nShowX = nx + _nBoardW/2
				_nShowY = ny
			end
		end
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.TacticsTipFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			dragable = 0,
			show = 0,
			z = hZorder.EquipTip,
			buttononly = 1,
		})
		_frm = hGlobal.UI.TacticsTipFrm
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

		_CODE_CreateTacticsInfo()

		_frm:show(1)
		_frm:active()
	end

	_CODE_CreateTacticsInfo = function()
		local nodeX = _nShowX
		local nodeY = _nShowY

		_childUI["btn_node"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			x = nodeX - _nBoardW/2,
			y = nodeY,
			w = 1,
			h = 1,
		})

		local node = _childUI["btn_node"]
		local nodeChild = node.childUI
		local nodeParent = node.handle._n

		local countH = 160
		local sIcon = ""
		local tabT = hVar.tab_tactics[_nTacticsId]
		if tabT then
			sIcon = tabT.icon or ""
		end
		local labx = _nBoardW/2
		if sIcon and sIcon ~= "" then
			nodeChild["img_icon"] = hUI.image:new({
				parent = nodeParent,
				model = sIcon,
				x = 72,
				y = - 72,
			})
		end
		local strT = hVar.tab_stringT[_nTacticsId] or {}
		nodeChild["lab_name"] = hUI.label:new({
			parent = nodeParent,
			text = strT[1],
			x = labx,
			y = - 72,
			font = hVar.FONTC,
			border = 1,
			align = "MC",
			size = 28,
			RGB = {255, 200, 50},
		})

		nodeChild["lab_info"] = hUI.label:new({
			parent = nodeParent,
			text = strT[_nLv+1],
			x = 38,
			y = - countH + 26,
			font = hVar.FONTC,
			border = 1,
			align = "LT",
			size = 26,
			width = _nBoardW - 76,
		})
		local _,labh = nodeChild["lab_info"]:getWH()
		countH = countH + labh + 16

		local showH = math.max(160,countH)

		local boardx = nodeX
		local boardy = nodeY - showH/2
		if _nMode == 1 then
			_childUI["btn_node"]:setXY(nodeX - _nBoardW/2,nodeY + showH/2)
			boardy = nodeY
		else
			local finalx = hApi.NumBetween(0,nodeX - _nBoardW/2,hVar.SCREEN.w - _nBoardW)
			local finaly = hApi.NumBetween(-showH,nodeY,-hVar.SCREEN.h + showH)
			boardx = finalx + _nBoardW/2
			boardy = finaly - showH/2
			_childUI["btn_node"]:setXY(finalx,finaly)
		end
		--nodeChild
		_childUI["btn_board"] = hUI.button:new({
			parent = _parent,
			model = "misc/button_null.png",
			dragbox = _childUI["dragBox"],
			x = boardx,
			y = boardy,
			w = _nBoardW,
			h = showH,
			z = -1,
		})
		local img9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/itemtip.png",0, 0, _nBoardW + 10, showH + 10, _childUI["btn_board"])
	end

	hGlobal.event:listen("LocalEvent_ClearTacticstip","TacticsTipFrm",function()
		_CODE_ClearFunc()
	end)

	hGlobal.event:listen("LocalEvent_PlayerFocusWorld","TacticsTipFrm",function()
		_CODE_ClearFunc()
	end)

	hGlobal.event:listen("LocalEvent_SpinScreen","TacticsTipFrm",function()
		_CODE_ClearFunc()
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(nTactics,nLv,nMode,nx,ny)
		--print("localEvent_ShowTacticsTipFrm",nTactics,nMode)
		_CODE_ClearFunc()
		_CODE_InitData(nTactics,nLv,nMode,nx,ny)
		_CODE_CreateFrm()
	end)
end
--hGlobal.UI.InitTacticsTipFrm("include")
--hGlobal.event:event("localEvent_ShowTacticsTipFrm",1201,3,nil,-200,-600)