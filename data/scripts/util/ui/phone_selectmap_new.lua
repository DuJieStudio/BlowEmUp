
--local function _list_table(tb, table_list, level)
	--local ret = ""
	--local indent = string.rep(" ", level*4)

	--for k, v in pairs(tb) do
		--local quo = type(k) == "string" and "\"" or ""
		--ret = ret .. indent .. "[" .. quo .. tostring(k) .. quo .. "] = "

		--if type(v) == "table" then
			--local t_name = table_list[v]
			--if t_name then
				--ret = ret .. tostring(v) .. " -- > [\"" .. t_name .. "\"]\n"
			--else
				--table_list[v] = tostring(k)
				--ret = ret .. "{\n"
				--ret = ret .. _list_table(v, table_list, level+1)
				--ret = ret .. indent .. "}\n"
			--end
		--elseif type(v) == "string" then
			--ret = ret .. "\"" .. tostring(v) .. "\"\n"
		--else
			--ret = ret .. tostring(v) .. "\n"
		--end
	--end

	--local mt = getmetatable(tb)
	--if mt then 
		--ret = ret .. "\n"
		--local t_name = table_list[mt]
		--ret = ret .. indent .. "<metatable> = "

		--if t_name then
			--ret = ret .. tostring(mt) .. " -- > [\"" .. t_name .. "\"]\n"
		--else
			--ret = ret .. "{\n"
			--ret = ret .. _list_table(mt, table_list, level+1)
			--ret = ret .. indent .. "}\n"
		--end
	--end
	--return ret
--end

--function table_tostring(tb)
	--if type(tb) ~= "table" then
		--error("Sorry, it's not table, it is " .. type(tb) .. ".")
		--print(debug.traceback())
		--return
	--end

	--local ret = " = {\n"
	--local table_list = {}
	--table_list[tb] = "root table"
	--ret = ret .. _list_table(tb, table_list, 1)
	--ret = ret .. "}"
	--return ret
--end


--function table_print(tb)
	--print(tostring(tb) .. table_tostring(tb))
--end

hGlobal.UI.InitSelectMapFrm_new = function()
	--【参数设定】
	local _nodeIndex = 0						--当前node索引号
	local _canDrag = false						--判断是否可移动
	local _indexList = {}
	local _mapInfo = nil
	local _dragW = 0
	local _gridW = 240
	local _deltaW = 0
	local _randMode = false
	local _scaleList = {0.5,0.5,0.5,0.65,0.75,0.85,0.75,0.65,0.5,0.5,0.5}
	local _gridNum = 11
	local _mapCount = 6
	local _currentInfo = {
		startNum = 1,
		startIndex = math.ceil(_gridNum /2),
		lastIndex = math.ceil(_gridNum /2),
	}
	local _tMaplist = {"world/csys_000","world/csys_001","world/csys_002","world/csys_003","world/csys_004","world/csys_005","world/csys_006","world/csys_ex_001","world/csys_ex_002"}
	local iPhoneX_WIDTH = 0
	local _startX = 100 + iPhoneX_WIDTH/2
	local _startY = hVar.SCREEN.h - (hVar.SCREEN.h - 460)/2 + 30
	local _nextbtnStartX = 50
	local _nextbtnScale = 0.8
	local _bgtex_ScaleX = 1.12
	local _bgtex_ScaleY = 1.4
	local _nCloseBtnX = 110				--关闭按钮X坐标
	local _nCloseBtnY = -60
	if (g_phone_mode == 4) then --iPhoneX
		_scaleList = {0.5,0.5,0.5,0.7,0.8,0.9,0.8,0.7,0.5,0.5,0.5}
		iPhoneX_WIDTH = hVar.SCREEN.offx
		_gridW = 260
		_startX = 140 + iPhoneX_WIDTH/2
		--_startY = hVar.SCREEN.h - (hVar.SCREEN.h - 460)/2 + 30
		_nextbtnStartX = 80
		_nextbtnScale = 1
		_bgtex_ScaleX = 0.98
		_bgtex_ScaleY = 1.4
		_nCloseBtnX = 120 + iPhoneX_WIDTH
	elseif (g_phone_mode == 2) then
		_nextbtnScale = 0.8
		_gridW = 220
		_nextbtnStartX = 50
		_scaleList = {0.5,0.5,0.5,0.6,0.7,0.8,0.7,0.6,0.5,0.5,0.5}
		_startX = 100 + iPhoneX_WIDTH/2
		_bgtex_ScaleY = 1.5
		_nCloseBtnX = 100
	elseif (g_phone_mode == 1) then
		_nextbtnScale = 0.7
		_gridW = 190
		_nextbtnStartX = 40
		_scaleList = {0.5,0.5,0.5,0.5,0.6,0.7,0.6,0.5,0.5,0.5,0.5}
		_startX = 80 + iPhoneX_WIDTH/2
		_bgtex_ScaleX = 1.15
		_bgtex_ScaleY = 1.45
		_nCloseBtnX = 80
	elseif (g_phone_mode == 0) then
		_nextbtnScale = 0.7
		_gridW = 195
		_scaleList = {0.5,0.5,0.5,0.5,0.6,0.7,0.6,0.5,0.5,0.5,0.5}
		_nextbtnStartX = 35
		_startX = 70 + iPhoneX_WIDTH/2
		_startY = hVar.SCREEN.h - (hVar.SCREEN.h - 460)/2 + 20
		_bgtex_ScaleY = 1.2
		_bgtex_ScaleX = 1.15
		_nCloseBtnX = 80
		_nCloseBtnY = -80
	end
	
	local _cliprect = {_startX,_startY,hVar.SCREEN.w - _startX * 2,460,0}

	--【函数定义】
	local _CODE_GetCurrentIndexList = hApi.DoNothing
	local _CODE_CreateMapItem = hApi.DoNothing
	local _CODE_OnInfoUp = hApi.DoNothing
	local _CODE_OnPageDrag = hApi.DoNothing
	local _CODE_UpdateGrid = hApi.DoNothing
	local _CODE_MoveGrid = hApi.DoNothing
	local _CODE_ResetGrid = hApi.DoNothing
	local _CODE_GetMapInfo = hApi.DoNothing
	local _CODE_CheckMapCanEnter = hApi.DoNothing
	local _CODE_SelectMap = hApi.DoNothing
	local _CODE_Exit = hApi.DoNothing

	hGlobal.UI.SelectMapFrm_new = hUI.frame:new({
		x = 0,
		y = 0,
		w = hVar.SCREEN.w,
		h = hVar.SCREEN.h,
		--z = 5555,
		show = 0,
		dragable = 2,
		--buttononly = 1,
		autoactive = 0,
		border = 0,
		codeOnTouch = function(self, relTouchX, relTouchY, IsInside, tTempPos)
			if _canDrag then
				local pama = {state = 0}
				self:pick("node".._nodeIndex,{_cliprect[1]-_dragW,_cliprect[2],_dragW*2,0},tTempPos,{_CODE_OnPageDrag,_CODE_OnInfoUp,pama})
			end
		end, 
	})
	local _frm = hGlobal.UI.SelectMapFrm_new
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	local _ClipNode = hApi.CreateClippingNode(_parent, _cliprect, 5, _cliprect[5])

	_childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		model = "misc/skillup/back.png",
		x = _nCloseBtnX,
		y = hVar.SCREEN.h + _nCloseBtnY,
		scaleT = 0.95,
		code = function()
			hApi.PlaySound("Button2")
			hGlobal.event:event("Event_StartPauseSwitch", false)
			_CODE_Exit()
			hGlobal.event:event("LocalEvent_MainBaseEventCB")
		end,
		z = 11,
	})

	_childUI["bg_texture1"] = hUI.image:new({
		parent = _parent,
		model = "misc/mask_white.png",
		x = hVar.SCREEN.w/2,
		y = hVar.SCREEN.h/2 + 30,
		w = hVar.SCREEN.w,
		h = 800,
		z = -1,
	})
	_childUI["bg_texture1"].handle.s:setColor(ccc3(0,0,0))
	_childUI["bg_texture1"].handle.s:setOpacity(200)
 
	--_childUI["bg_texture2"] = hUI.image:new({
		--parent = _parent,
		--model = "panel/bg_texture_02.png",
		--x = hVar.SCREEN.w/2,
		--y = hVar.SCREEN.h/2,
		--w = hVar.SCREEN.w * _bgtex_ScaleX,
		--h = hVar.SCREEN.h * _bgtex_ScaleY,
		--z = 10,
	--})
	--_childUI["bg_texture2"].handle.s:setOpacity(225)

	_childUI["SelectBtn"] = hUI.button:new({
		parent = _parent,
		model = "misc/addition/cg.png",
		label = {text = "ok",size = 28,border = 1,font = hVar.FONTC,y = 4,height= 32,},
		dragbox = _childUI["dragBox"],
		scaleT = 0.98,
		x = hVar.SCREEN.w/2,
		y = 120,
		scale = 1.4 * 0.74,
		code = function(self)
			_CODE_SelectMap()
		end,
		z = 11,
	})


	_childUI["randMode"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "misc/photo_frame.png",
		label = {text = "随机模式",font = hVar.FONTC,border = 1,size = 24,y = -50},
		x = hVar.SCREEN.w/2 + 250,
		y = 140,
		w = 40,
		h = 40,
		scaleT = 0.98,
		code = function(self)
			if _randMode then
				_randMode = false
			else
				_randMode = true
			end
			_childUI["randMode"].childUI["select"].handle._n:setVisible(_randMode)
		end,
		z = 11,
	})

	_childUI["randMode"].childUI["select"] = hUI.image:new({
		parent = _childUI["randMode"].handle._n,
		model = "misc/ok.png",
	})
	_childUI["randMode"].childUI["select"].handle._n:setVisible(_randMode)


	_childUI["lock"] = hUI.image:new({
		parent = _parent,
		model = "misc/skillup/lock.png",
		x = hVar.SCREEN.w/2,
		y = 124,
		scale = 1.4,
		z = 12,
	})
	_childUI["lock"].handle._n:setVisible(false)

	_childUI["ChangeBtn_left"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "misc/addition/change_arrow.png",
		x = _nextbtnStartX + iPhoneX_WIDTH/2,
		y = _cliprect[2] - _cliprect[4]/2,
		scale = _nextbtnScale,
		scaleT = 0.8,
		code = function(self)
			if _canDrag then
				_CODE_MoveGrid( -_gridW,200)
			end
		end,
		z = 11,
	})

	_childUI["ChangeBtn_right"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		model = "misc/addition/change_arrow.png",
		x = hVar.SCREEN.w - _nextbtnStartX - iPhoneX_WIDTH/2,
		y = _cliprect[2] - _cliprect[4]/2,
		scale = _nextbtnScale,
		scaleT = 0.8,
		code = function(self)
			if _canDrag then
				_CODE_MoveGrid( _gridW,200)
			end
		end,
		z = 11.
	})
	_childUI["ChangeBtn_right"].handle._n:setRotation(180)
	


	--【函数实现】
	--_CODE_GetMapInfo = function()
		--if type(_mapInfo) ~= "table" then
			--_mapInfo = {}
			--local tabChpt = hVar.tab_chapter[1]
			--if tabChpt then
				--local startMap = tabChpt.firstmap
				--local lastMap = tabChpt.lastmap
				--local MapCount = 0
				--if hVar.MAP_INFO[startMap] then
					--local mapname = startMap
					--local unlock = 1
					--while(hVar.MAP_INFO[mapname]) do
						--MapCount = MapCount + 1
						--_mapInfo[MapCount] = {
							--MapName = mapname,
							--MapImg = hVar.MAP_INFO[mapname].thumbnail,
							--Unlock = unlock,
							--MapStar = LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.MAPSTAR),
						--}
						--if unlock == 1 then
							--_currentInfo.startNum = MapCount
						--end
						--if hVar.MAP_INFO[mapname].nextmap and hVar.MAP_INFO[mapname].nextmap[1] and mapname ~= lastMap then
							--unlock = LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
							--mapname = hVar.MAP_INFO[mapname].nextmap[1]
						--else
							--mapname = nil
						--end
					--end
				--end
				--_mapCount = MapCount
			--end
			----table_print(_mapInfo)
		--end
	--end
	_CODE_GetMapInfo = function()
		if type(_mapInfo) ~= "table" then
			local _ex = {"","a","b","c"}
			_mapInfo = {}
			local MapCount = 0
			for index = 1,#_tMaplist do
				local mapname = _tMaplist[index]
				if hVar.MAP_INFO[mapname] then
					for i = 1,#_ex do
						local s_temgname = mapname .. _ex[i]
						if hVar.MAP_INFO[s_temgname] then
							MapCount = MapCount + 1
							_mapInfo[MapCount] = {
								MapName = s_temgname,
								MapImg = hVar.MAP_INFO[s_temgname].thumbnail,
								Unlock = 1,
								MapStar = LuaGetPlayerMapAchi(s_temgname,hVar.ACHIEVEMENT_TYPE.MAPSTAR),
							}
						end
					end
				end
			end
			_mapCount = MapCount
			--local tabChpt = hVar.tab_chapter[1]
			--if tabChpt then
				--local startMap = tabChpt.firstmap
				--local lastMap = tabChpt.lastmap
				--local MapCount = 0
				--if hVar.MAP_INFO[startMap] then
					--local mapname = startMap
					--local unlock = 1
					--while(hVar.MAP_INFO[mapname]) do
						--for i = 1,#_ex do
							--local s_temgname = mapname .. _ex[i]
							--if hVar.MAP_INFO[s_temgname] then
								--MapCount = MapCount + 1
								--_mapInfo[MapCount] = {
									--MapName = s_temgname,
									--MapImg = hVar.MAP_INFO[s_temgname].thumbnail,
									--Unlock = unlock,
									--MapStar = LuaGetPlayerMapAchi(s_temgname,hVar.ACHIEVEMENT_TYPE.MAPSTAR),
								--}
							--end
						--end
						--if hVar.MAP_INFO[mapname].nextmap and hVar.MAP_INFO[mapname].nextmap[1] and mapname ~= lastMap then
							--mapname = hVar.MAP_INFO[mapname].nextmap[1]
						--else
							--mapname = nil
						--end
					--end
				--end
				--_mapCount = MapCount
			--end
			--table_print(_mapInfo)
		end
	end

	_CODE_GetCurrentIndexList = function()
		_indexList = {}
		print(_currentInfo.startNum)
		local midnum = math.ceil(_gridNum /2)
		local index = _currentInfo.startNum - midnum + 1
		for i = 1,_gridNum do
			_indexList[i] = (index - 1) % _mapCount + 1
			index = index + 1
		end
		--table_print(_indexList)
	end

	_CODE_CreateMapItem = function()
		_CODE_GetCurrentIndexList()
		_childUI["node".._nodeIndex] = hUI.node:new({
			parent = _ClipNode,
			x = _cliprect[1],
			y = _cliprect[2],
		})
		local _NodeParent = _childUI["node".._nodeIndex].handle._n
		local _NodeChild =  _childUI["node".._nodeIndex].childUI
		local _OffX = 0
		local _OffY = 0   

		for i = 1,_gridNum do
			local n = (_gridNum+1)/2 - i 
			local z = (_gridNum+1)/2 - math.abs(n)

			_NodeChild["mapNode"..i] = hUI.node:new({
				parent = _NodeParent,
				x = _cliprect[3]/2 - _gridW * n,
				y = -_cliprect[4]/2 - 15,
				z = z,
			})

			local sNum = tostring(_indexList[i] * 10)
			local length = #sNum
			for j = 1,length do
				local n = math.floor(_indexList[i] / (10^(length-j)))% 10
				_NodeChild["mapNode"..i].childUI["image"..j] = hUI.image:new({
					parent = _NodeChild["mapNode"..i].handle._n,
					model = "UI:num_blue",
					animation = "N"..n,
					x = 46 * (j - 1) - (length-1)/2*46,
					--x = 0,
					y = 250,
				})
			end

			local info = _mapInfo[_indexList[i]]
			--print(imgModel)
			_NodeChild["mapNode"..i].childUI["image"] = hUI.image:new({
				parent = _NodeChild["mapNode"..i].handle._n,
				--model = "misc/menu_image_multifb.png",
				model = "misc/mask_white.png",
				x = 0,
				y = 0,
				w = 460,
				h = 340,
			})
			_NodeChild["mapNode"..i].childUI["image"].handle.s:setColor(ccc3(128,128,128))
			_NodeChild["mapNode"..i].childUI["block"] = hUI.image:new({
				parent = _NodeChild["mapNode"..i].handle._n,
				model = "misc/block.png",
				x = 0,
				y = 0,
			})
			_NodeChild["mapNode"..i].handle._n:setScale(_scaleList[i])

			_NodeChild["mapNode"..i].childUI["name"] = hUI.label:new({
				parent = _NodeChild["mapNode"..i].handle._n,
				text = info.MapName,
				border = 1,
				size = 28,
				align = "MC",
				x = 0,
				y = -150,
				RGB = {255,0,0},
			})

			--未解锁的变灰
			if info.Unlock == 0 then
				hApi.AddShader(_NodeChild["mapNode"..i].childUI["image"].handle.s, "gray")
			end
			--未选中的变暗
			if i ~= (_gridNum+1)/2 then
				_NodeChild["mapNode"..i].childUI["image"].handle.s:setColor(ccc3(80,80,80))
				--_NodeChild["mapNode"..i].childUI["image"].handle.s:setColor(ccc3(180,180,180))
				_NodeChild["mapNode"..i].childUI["block"].handle._n:setVisible(false)
			end

			for j = 1,3 do
				_NodeChild["mapNode"..i].childUI["starimage"..j] = hUI.image:new({
					parent = _NodeChild["mapNode"..i].handle._n,
					model = "misc/addition/star_light2.png",
					x = 60 * (j - 1) - (3-1)/2*60,
					--x = 60 * (j - 1) - 210,
					y = 205,
					scale = 0.6
				})
				if j > info.MapStar then
					hApi.AddShader(_NodeChild["mapNode"..i].childUI["starimage"..j].handle.s, "gray")
				end
			end
			
		end

		_dragW = _gridW * 3
		_CODE_CheckMapCanEnter()
	end

	_CODE_OnPageDrag = function(self,tTempPos,tPickParam)
		if 0 == tPickParam.state then
			if (tTempPos.x-tTempPos.tx)^2>400 then	--触摸移动点如果大于12个像素，即作为滑动处理
				if tPickParam.code and tPickParam.code~=0 then			--如果存在拖拉函数，则处理拖拉函数
					local pCode = tPickParam.code
					tPickParam.code = 0
					pCode(self,tTempPos,tPickParam)
				end
				if tPickParam.state==0 then
					hApi.PlaySound("button_1")
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
			local offx = tTempPos.x-tTempPos.tx
			_CODE_UpdateGrid(offx)
		end
	end

	_CODE_UpdateGrid = function(offx)
		--print(_childUI["node".._nodeIndex].data.x,offx)
		local _NodeChild =  _childUI["node".._nodeIndex].childUI
		local finalX = hApi.NumBetween(_dragW,offx,-_dragW)
		local scaleList = {}
		local oldIndex = _currentInfo.startIndex
		for i = 1,_gridNum do
			local nodeX = _NodeChild["mapNode"..i].data.x - _cliprect[3]/2 + finalX
			local scale = 0
			local z = -1
			for j = 1,_gridNum do
				local n = (_gridNum+1)/2 - j 
				if nodeX < - _gridW * n then
					if j ~= 1 then
						local deltaX = nodeX + _gridW * n
						scale = _scaleList[j] + deltaX * (_scaleList[j]-_scaleList[j-1]) / _gridW
						if scaleList.Biggest == nil or scaleList.Biggest < scale then
							scaleList.Biggest = scale
							scaleList.index = i
							_currentInfo.startNum = _indexList[i]
							_currentInfo.startIndex = i
						end
					end
					break
				end
			end
			if scale ~= 0 then
				_NodeChild["mapNode"..i].handle._n:setScale(scale)
			end
		end
		if oldIndex ~= _currentInfo.startIndex then
			hApi.PlaySound("button_1")
		end
		--排布先后顺序
		local maxZ = math.max(scaleList.index,_gridNum - scaleList.index + 1)
		for i = 1,_gridNum do
			local z = maxZ - math.abs(scaleList.index - i)
			_NodeChild["mapNode"..i].handle._n:getParent():reorderChild(_NodeChild["mapNode"..i].handle._n, z)
			if z == maxZ then
				--_NodeChild["mapNode"..i].childUI["image"].handle.s:setColor(ccc3(255,255,255))
				_NodeChild["mapNode"..i].childUI["image"].handle.s:setColor(ccc3(128,128,128))
				_NodeChild["mapNode"..i].childUI["block"].handle._n:setVisible(true)
			else
				--_NodeChild["mapNode"..i].childUI["image"].handle.s:setColor(ccc3(180,180,180))
				_NodeChild["mapNode"..i].childUI["image"].handle.s:setColor(ccc3(80,80,80))
				_NodeChild["mapNode"..i].childUI["block"].handle._n:setVisible(false)
			end
		end
	end

	_CODE_MoveGrid = function(offX,times)
		local Node = _childUI["node".._nodeIndex]
		if Node and times > 0 and _canDrag then
			hApi.clearTimer("MoveMapImg")
			_canDrag = false
			local oldX = Node.data.x
			local newX,newY = Node.data.x-offX,Node.data.y
			Node.handle._n:runAction(CCMoveTo:create(times/1000,ccp(newX,newY)))
			local index = 1
			local v = times /10
			hApi.addTimerForever("MoveMapImg",hVar.TIMER_MODE.PCTIME,v,function()
				index = index + 1
				if index * v > times then
					Node.data.x = newX
					hApi.clearTimer("MoveMapImg")
					_CODE_ResetGrid()
					return
				end
				_CODE_UpdateGrid(Node.data.x - _cliprect[1] - offX * index * v / times )
			end)
		end
	end

	--重置Grid (当拖动回弹动画结束后 重新创建grid 并延长一针删除旧的  防止闪烁)
	_CODE_ResetGrid = function()
		_canDrag = false
		if _currentInfo.startIndex ~= _currentInfo.lastIndex then
			_deltaW =_deltaW + (_currentInfo.startIndex - _currentInfo.lastIndex) * _gridW
			--print("_deltaW")
			local oldIndex  = _nodeIndex
			_nodeIndex = _nodeIndex == 0 and 1 or 0
			_CODE_CreateMapItem()
			_currentInfo.lastIndex = math.ceil(_gridNum /2)
			_currentInfo.startIndex = math.ceil(_gridNum /2)
			hApi.addTimerOnce("CleatOldNode",1,function()
				hApi.safeRemoveT(_childUI,"node"..oldIndex)
				_canDrag = true
			end)
		else
			_canDrag = true
		end
	end
	
	_CODE_OnInfoUp = function(self,tTempPos,tPickParam)	
		if 1 == tPickParam.state then
			local offx = tTempPos.x-tTempPos.tx
			local finalX = hApi.NumBetween(_dragW,offx,-_dragW)
			local Node = _childUI["node".._nodeIndex]
			local v = finalX % _gridW
			if v > _gridW/2 then
				_CODE_MoveGrid( v - _gridW,200)
			else
				_CODE_MoveGrid( v,200)
			end
		end
	end
	
	_CODE_CheckMapCanEnter = function()
		--_indexList
		local index = _currentInfo.startNum
		local mapInfo = _mapInfo[index]
		if mapInfo and mapInfo.Unlock == 1 then
			_childUI["SelectBtn"].handle.s:setColor(ccc3(255,255,255))
			_childUI["lock"].handle._n:setVisible(false)
		else
			_childUI["SelectBtn"].handle.s:setColor(ccc3(127,127,127))
			_childUI["lock"].handle._n:setVisible(true)
		end    
	end
	
	_CODE_SelectMap = function()
		if _canDrag then
			local index = _currentInfo.startNum
			local mapInfo = _mapInfo[index]
			if mapInfo and mapInfo.Unlock == 1 then
				local __MAPDIFF = 0
				local __MAPMODE = hVar.MAP_TD_TYPE.NORMAL
				local mapName = mapInfo.MapName
				hApi.PlaySound("Button2")
				if _randMode then
					LuaClearPlayerRandMapInfo(g_curPlayerName)
					local tInfos = {
						{"id",1},
						{"stage",2},
						{"lifecount",1},
						{"tank",6000},
						{"weaponlevel",5},
						{"istest",1},
					}
					LuaSetPlayerRandMapInfos(g_curPlayerName,tInfos)
					local tRMapInfo = {
						randmapId = 1,
						stage = 2,
						weaponlevel = 5,
						talentpoint = 2,
						talentskill = {}
					}
					hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
					
					hGlobal.LocalPlayer.data.diablodata.randMap = tRMapInfo
				else
					hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
				end
				--跳转
				_CODE_Exit()
				xlScene_LoadMap(g_world, mapName,__MAPDIFF,__MAPMODE)
			end
		end
	end

	_CODE_Exit = function()
		_frm:show(0)
		hApi.safeRemoveT(_childUI,"node".._nodeIndex)
		_nodeIndex = 0
		_mapInfo = nil
		local frm = hGlobal.UI.SystemMenuNewFram
		if frm then
			frm:show(0)
		end
	end

	--【监听事件】
	hGlobal.event:listen("LocalEvent_ShowSelectMapFrm","_show",function()
		_frm:show(1)
		_frm:active()

		_CODE_GetMapInfo()
		_CODE_CreateMapItem()
		_canDrag = true
	end)
end

--if hGlobal.UI.SelectMapFrm_new then
	--hGlobal.UI.SelectMapFrm_new:del()
	--hGlobal.UI.SelectMapFrm_new = nil
--end
--hGlobal.UI.InitSelectMapFrm_new()
--hGlobal.event:event("LocalEvent_ShowSelectMapFrm")

--关卡选择界面
hGlobal.UI.InitSelectBattleMapFrm = function(mode)
	local tInitEventName = {"localEvent_ShowSelectBattleMapFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _frm,_parent,_childUI = nil,nil,nil
	local _ClipNode = nil
	local _dragrect = nil
	local _tCallback = nil
	local _boardW,_boardH = 720,720
	local _cliprect = {(hVar.SCREEN.w - _boardW)/2,0,_boardW,_boardH - 100,0}
	local _canDrag = false

	local _mapPos = {
		--x,y
		{- 168,250},
		{10,200},
		{-216,84},
		{204,-16},
		{-250,-146},
		{146,-270},
	}
	local _starPos = {
		{30,70},
		{54,54},
		{68,30},
	}

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateEffect = hApi.DoNothing
	local _CODE_CreateMap = hApi.DoNothing
	local _CODE_CreateMapInfo = hApi.DoNothing

	local _CODE_EnterMap = hApi.DoNothing

	local _CODE_OnPageDrag = hApi.DoNothing
	local _CODE_OnInfoUp = hApi.DoNothing
	local _CODE_AutoLign = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.SelectBattleMapFrm then
			hGlobal.UI.SelectBattleMapFrm:del()
			hGlobal.UI.SelectBattleMapFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_ClipNode = nil
		_dragrect = nil
		_tCallback = nil
		_canDrag = false
	end

	_CODE_EnterMap = function(mapname)
		--print("_CODE_EnterMap")
		_CODE_ClearFunc()
		GameManager.GameStart(hVar.GameType.RANDBATTLE,nil,mapname)
	end

	_CODE_CreateEffect = function()
		local offx = hVar.SCREEN.w/2
		local offy = -hVar.SCREEN.h/2
		_childUI["img_sun"] = hUI.image:new({
			parent = _parent,
			model = "MODEL_EFFECT:SPACE_SUN",
			x = offx + 14,
			y = offy - 152,
		})

		local starw = 220
		local starh = 220

		local cow = math.floor(hVar.SCREEN.w / starw) - 1
		local line = math.floor(hVar.SCREEN.h / starh) - 1

		local areaw =  math.floor(hVar.SCREEN.w / cow)
		local areah =  math.floor(hVar.SCREEN.h / line)

		local rangex = (areaw - starw) / 2
		local rangey = (areah - starh) / 2

		local stareffect = {
			"stand1",
			"stand2",
			"stand3",
		}

		for j = 1,line do
			for i = 1,cow do
				local index = (j - 1) * cow + i
				local sx = (i - 0.5) * areaw + math.random(-rangex,rangex)
				local sy = (j - 0.5) * areah + math.random(-rangey,rangey)

				--print(j,i,sx,sy)

				local effect = math.random(0,#stareffect + 2)

				if effect ~= 0 and stareffect[effect] then
					local timer = math.random(50,1000)
					--print(index,effect,timer)
					hApi.addTimerOnce("CreateSpaceStar"..index,timer,function()
						_childUI["img_star"..index] = hUI.image:new({
							parent = _parent,
							model = "MODEL_EFFECT:SPACE_STAR",
							x = sx,
							y = -sy,
							animation = stareffect[effect],
						})
					end)
				end
			end
		end
	end

	_CODE_CreateMap = function()
		--[[
		hApi.safeRemoveT(_childUI,"node")
		_childUI["node"] = hUI.node:new({
			parent = _ClipNode,
			x = _cliprect[1],
			y = _cliprect[2],
		})
		local _NodeParent = _childUI["node"].handle._n
		local _NodeChild =  _childUI["node"].childUI

		local mapw = 300
		local mapH = 180
		local shownum = 3
		local offH = (_cliprect[4] - mapH * shownum)/(shownum + 1)

		local num = #hVar.tab_randmap[1]
		for i = 1,num do
			local tab = hVar.tab_randmap[1][i]
			local randmap = tab.randmap

			local x = 40 + mapw/2
			if i % 2 == 0 then
				x = _cliprect[3] - x
			end
			local y = offH * i + mapH * (i - 0.5)
			--print(i,x,y)
			
			_NodeChild["map"..i] = hUI.image:new({
				parent = _NodeParent,
				model = "misc/selectmap/map"..i..".png",
				w = mapw,
				h = mapH,
				x = x,
				y = -y,
			})
		end

		local gh = math.max(0,(num + 1) * offH + num * mapH - _cliprect[4])
		_dragrect = {_cliprect[1], _cliprect[2]+gh, 0, math.max(1, gh)}

		_canDrag = true
		--]]
		local first = 0
		for i = 1,#_mapPos do
			local x,y = unpack(_mapPos[i])
			local icon = string.format("misc/selectmap/map%d.png",i)
			local mapname = string.format("world/csys_%03d",i)
			local unlock = LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.LEVEL)
			if unlock == 0 and first == 0 then
				unlock = 1
				first = i
			end
			--print(mapname)
			_CODE_CreateMapInfo(i,x,y,icon,mapname,unlock)
		end
	end

	_CODE_CreateMapInfo = function(index,x,y,icon,mapname,unlock)
		local _x = x or 0
		local _y = y or 0
		local _icon = icon or ""
		local offx = hVar.SCREEN.w/2
		local offy = -hVar.SCREEN.h/2
		_childUI["btn_mapinfo"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			x = offx + _x,
			y = offy + _y,
			scaleT = 0.96,
			w = 150,
			h = 150,
			model = "misc/button_null.png",
			--model = "misc/selectmap/circlebg.png",
			code = function()
				if unlock == 1 then
					_CODE_EnterMap(mapname)
				end
			end,
		})

		_childUI["btn_mapinfo"].childUI["circlebg"] = hUI.image:new({
			parent = _childUI["btn_mapinfo"].handle._n,
			model = "misc/selectmap/circlebg.png",
		})
		
		local rotate1 = CCRotateBy:create(1, 6)
		_childUI["btn_mapinfo"].childUI["circlebg"].handle._n:runAction(CCRepeatForever:create(rotate1))

		if unlock == 1 then 
			_childUI["btn_mapinfo"].childUI["unlock"] = hUI.image:new({
				parent = _childUI["btn_mapinfo"].handle._n,
				model = "misc/selectmap/unlock.png",
			})
			local rotate2 = CCRotateBy:create(1, -12)
			_childUI["btn_mapinfo"].childUI["unlock"].handle._n:runAction(CCRepeatForever:create(rotate2))

			for i = 1,#_starPos do
				local starx,stary = unpack(_starPos[i])
				_childUI["btn_mapinfo"].childUI["boss"] = hUI.image:new({
					parent = _childUI["btn_mapinfo"].handle._n,
					model = "misc/selectmap/star.png",
					x = starx,
					y = stary,
				})
			end
		else
			_childUI["btn_mapinfo"].childUI["lock"] = hUI.image:new({
				parent = _childUI["btn_mapinfo"].handle._n,
				model = "misc/selectmap/lock.png",
				x = 70,
				y = -50,
				z = 2,
			})
		end

		_childUI["btn_mapinfo"].childUI["boss"] = hUI.image:new({
			parent = _childUI["btn_mapinfo"].handle._n,
			model = icon,
			--scale = 0.9,
			x = 26,
			y = -26,
			z = 1,
		})
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.SelectBattleMapFrm = hUI.frame:new({
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
			codeOnTouch = function(self, relTouchX, relTouchY, IsInside, tTempPos)
				if _canDrag then
					if hApi.IsInBox(relTouchX, relTouchY, _cliprect) then
						local pama = {state = 0}
						self:pick("node",_dragrect,tTempPos,{_CODE_OnPageDrag,_CODE_OnInfoUp,pama},1)
					end
				end
			end, 
		})
		_frm = hGlobal.UI.SelectBattleMapFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

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
		_frm.childUI["_blackpanel"].handle.s:setOpacity(220)

		_childUI["img_bg"] = hUI.image:new({
			parent = _parent,
			model = "misc/selectmap/bg.png",
			x = offx,
			y = offy,
			--w = _boardW,
			--h = _boardH,
		})
		--_childUI["img_bg"].handle.s:setColor(ccc3(0,0,0))

		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/back.png",
			x = 54,
			y = - 54,
			scaleT = 0.9,
			code = function()
				if type(_tCallback) == "table" then
					hGlobal.event:event(_tCallback[1],_tCallback[2])
				end
				_CODE_ClearFunc()
			end,
		})

		--_ClipNode = hApi.CreateClippingNode(_parent, _cliprect, 5, _cliprect[5])
		_CODE_CreateEffect()
		_CODE_CreateMap()

		_frm:active()
		_frm:show(1)
	end

	_CODE_AutoLign = function(offy)
		local Node =_childUI["node"]
		if Node then
			local waittime = 0.2
			Node.handle._n:runAction(CCMoveTo:create(waittime,ccp(_cliprect[1],offy)))
			hApi.addTimerOnce("SelectBattleMapAutoAlign",waittime*1000+1,function()
				hUI.uiSetXY(Node, _cliprect[1],offy)
				_canDrag = true
			end)
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
		if 1 == tPickParam.state then
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
		elseif 0 == tPickParam.state then
			
		end
	end

	hGlobal.event:listen("LocalEvent_SpinScreen","SelectBattleMapFrm",function()
		if _frm and _frm.data.show == 1 then
			local tCallback = _tCallback
			_CODE_ClearFunc()
			_tCallback = tCallback
			_CODE_CreateFrm()
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(tCallback)
		_CODE_ClearFunc()
		_tCallback = tCallback
		_CODE_CreateFrm()
	end)
end