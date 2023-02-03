hGlobal.UI.InitGameTempBagFrm = function(mode)
	local tInitEventName = {"localEvent_ShowGameTempBagFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _frm,_childUI,_parent = nil,nil,nil
	local _tTacticsData = {}
	local _tCapsuleData = {}
	local _tUiList = {}
	local _boardw,_boardh = 696,696
	local _nCow = 7
	local _nTacticsLine = 3
	local _nCapsuleLine = 3
	local _nTacticsW,_nTacticsH = 76,70
	local _nCapsuleW,_nCapsuleH = 76,76

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateUI = hApi.DoNothing
	local _CODE_CreateGrid = hApi.DoNothing
	local _CODE_GetData = hApi.DoNothing
	local _CODE_CreateData = hApi.DoNothing
	local _CODE_ClearUI = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.GameTempBagFrm then
			hGlobal.UI.GameTempBagFrm:del()
			hGlobal.UI.GameTempBagFrm = nil
		end
		_frm,_childUI,_parent = nil,nil,nil
		_tTacticsData = {}
		_tCapsuleData = {}
		_tUiList = {}
	end

	local _CODE_Sortbysmallid = function(t1,t2)
		return t1[1] < t2[1]
	end

	_CODE_GetData = function()
		_tTacticsData = {}
		_tCapsuleData = {}
		local tacticInfo = GameManager.GetGameInfo("tacticInfo")
		for key,value in pairs(tacticInfo) do
			_tTacticsData[#_tTacticsData+1] = {key,value}
		end
		table.sort(_tTacticsData,_CODE_Sortbysmallid)

		local chestinfo = GameManager.GetGameInfo("chestInfo")
		for key,value in pairs(chestinfo) do
			_tCapsuleData[#_tCapsuleData+1] = {key,value}
		end
		table.sort(_tCapsuleData,_CODE_Sortbysmallid)

		local scoreNum = GameManager.GetGameInfo("ckscore")
		if type(scoreNum) == "number" and scoreNum > 0 then
			table.insert(_tCapsuleData,1,{13004,scoreNum})
		end
	end

	_CODE_CreateData = function()
		_CODE_ClearUI()
		_CODE_GetData()
		
		--[[
		_tTacticsData= {
			{12013,3},
			{12014,3},
		}
		_tCapsuleData = {
			{13005,3},
			{13006,4},
			{13007,5},
		}
		--]]
		for index = 1,#_tTacticsData do
			--print("index",index)
			local id = _tTacticsData[index][1]
			local value = _tTacticsData[index][2]
			local gridnode = _childUI["img_tacticsbg"..index]
			local tabI = hVar.tab_item[id]
			--print("id",id)
			if gridnode and tabI then
				local x = gridnode.data.x
				local y = gridnode.data.y
				--print(x,y)
				_childUI["img_tactics"..index] = hUI.image:new({
					parent = _parent,
					model = tabI.icon,
					x = x + 1,
					y = y - 2,
				})
				_tUiList[#_tUiList+1] = "img_tactics"..index

				_childUI["lab_tactics"..index] = hUI.label:new({
					parent = _parent,
					text = tostring(value),
					align = "RC",
					font = "num",
					size = 18,
					x = x + 36,
					y = y - 26,
				})
				_tUiList[#_tUiList+1] = "lab_tactics"..index
			end
		end

		for index = 1,#_tCapsuleData do
			local id = _tCapsuleData[index][1]
			local value = _tCapsuleData[index][2]
			local kind = _tCapsuleData[index][3]
			local tabI = hVar.tab_item[id]
			local gridnode = _childUI["img_capsulebg"..index]
			print("id",id)
			if gridnode and tabI then
				local x = gridnode.data.x
				local y = gridnode.data.y
				print(x,y)
				_childUI["img_capsule"..index] = hUI.image:new({
					parent = _parent,
					model = tabI.icon,
					x = x + 1,
					y = y - 2,
				})
				_tUiList[#_tUiList+1] = "img_capsule"..index

				_childUI["lab_capsule"..index] = hUI.label:new({
					parent = _parent,
					text = tostring(value),
					align = "RC",
					font = "num",
					size = 18,
					x = x + 36,
					y = y - 26,
				})
				_tUiList[#_tUiList+1] = "lab_capsule"..index
			end
		end
	end

	_CODE_CreateGrid = function()
		local offx = hVar.SCREEN.w/2
		local offy = -hVar.SCREEN.h/2

		local startx = offx - _boardw/2 - 18
		local starty = offy + _boardh/2 - 12

		local offw = (_boardw - _nTacticsW * _nCow - 40)/(_nCow+1)
		local offh = (310 - _nTacticsH * _nTacticsLine - 10)/(_nTacticsLine+1)
		for i = 1,_nTacticsLine do
			for j = 1,_nCow do
				local index = _nCow * (i-1) + j
				_childUI["img_tacticsbg"..index] = hUI.button:new({
					parent = _parent,
					dragbox = _childUI["dragBox"],
					model = "misc/tempbag/invertedtrg.png",--square
					x = startx + j * _nTacticsW + offw * j,
					y = starty - i * _nTacticsH - offh * i,
				})
			end
		end

		local startx = offx - _boardw/2 - 18
		local starty = offy + _boardh/2 - 320

		local offw = (_boardw - _nCapsuleW * _nCow - 40)/(_nCow+1)
		local offh = (330 - _nCapsuleH * _nCapsuleLine - 10)/(_nCapsuleLine+1)

		for i = 1,_nCapsuleLine do
			for j = 1,_nCow do
				local index = _nCow * (i-1) + j
				_childUI["img_capsulebg"..index] = hUI.button:new({
					parent = _parent,
					dragbox = _childUI["dragBox"],
					model = "misc/tempbag/square.png",--square
					x = startx + j * _nCapsuleW + offw * j,
					y = starty - i * _nCapsuleH - offh * i,
				})
			end
		end
	end

	_CODE_CreateUI = function()
		local offx = hVar.SCREEN.w/2
		local offy = -hVar.SCREEN.h/2

		_childUI["btn_closeArea"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/button_null.png",
			x = offx,
			y = offy,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			code = function()
				_CODE_ClearFunc()
				hGlobal.event:event("Event_StartPauseSwitch", false)
			end,
		})

		_childUI["board"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/tempbag/bagborder.png",
			x = offx,
			y = offy,
			w = _boardw,
			h = _boardh,
		})

		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/tempbag/close.png",
			x = offx + _boardw/2 - 50,
			y = offy + _boardh/2 - 24,
			scaleT = 0.95,
			code = function()
				_CODE_ClearFunc()
				hGlobal.event:event("Event_StartPauseSwitch", false)
			end,
		})

		_CODE_CreateGrid()
		_CODE_CreateData()
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.GameTempBagFrm  = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			dragable = 2,
			show = 0,
		})
		_frm = hGlobal.UI.GameTempBagFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		_CODE_CreateUI()

		_frm:show(1)
		_frm:active()
	end

	hGlobal.event:listen("LocalEvent_SpinScreen","GameTempBag",function()
		if _frm and _frm.data.show == 1 then
			_CODE_ClearFunc()
			_CODE_CreateFrm()
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(weaponId)
		hGlobal.event:event("Event_StartPauseSwitch", true)
		_CODE_ClearFunc()
		_CODE_CreateFrm()
	end)
end