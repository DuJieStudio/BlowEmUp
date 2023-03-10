--------------------------------
-- 加载我的领地用UI
--------------------------------
--hGlobal.UI.InitEnterMapFrm_WDLD = function(mode)
--	local tInitEventName = {"LocalEvent_ShowEnterMapFrm","MyCityZoneFrm"}
--	if mode~="include" then
--		return tInitEventName
--	end
--	local _x,_y,_w,_h = 300,600,540,440
--	hGlobal.UI.EnterMapFrm = hUI.frame:new({
--		x = _x,
--		y = _y,
--		w = _w,
--		h = _h,
--		show = 0,
--		dragable = 2,
--		autoactive = 0,
--		background = "UI:tip_item",
--		border = 1,
--	})
--
--	local _frm = hGlobal.UI.EnterMapFrm
--	local _parent = _frm.handle._n
--	local _childUI = _frm.childUI
--	
--	--地图名字
--	_childUI["mapName"] = hUI.label:new({
--		parent = _parent,
--		x = _w/2 - 5,
--		y = - 35,
--		text = "",
--		size = 30,
--		font = hVar.FONTC,
--		align = "MC",
--		width = 300 ,
--		--RGB = {255,205,55},
--		border = 1,
--	})
--	
--	--地图信息
--	_childUI["mapInfo"] = hUI.label:new({
--		parent = _parent,
--		x = 10,
--		y = - 70,
--		text = "",
--		size = 26,
--		font = hVar.FONTC,
--		align = "LT",
--		width = _w-20 ,
--		
--		border = 1,
--	})
--	
--	--子地图信息
--	_childUI["childmapInfo"] = hUI.label:new({
--		parent = _parent,
--		x = 10,
--		y = - 170,
--		text = "",
--		size = 24,
--		font = hVar.FONTC,
--		align = "LT",
--		RGB = {255,205,55},
--		width = _w-20 ,
--		border = 1,
--	})
--
--	--根据地图名 获取地图 icon
--	local _getMapIcon = function(mapName)
--		local icon = ""
--		for k,v in pairs(hVar.MAP_INFO) do
--			if k == mapName then
--				icon = v.icon
--				break
--			end
--		end
--		return icon
--	end
--
--	--创建地图信息
--	local _MapName = ""
--	local _removeList = {}
--	local _createMapInfo = function(mapName)
--		_MapName = mapName
--		--地图图标
--		--local icon =_getMapIcon(mapName)
--		--_childUI["map_image"] = hUI.button:new({
--			--parent = _parent,
--			--model = icon,
--			--x = _w/2,
--			--y =-_h/2 - 90,
--		--})
--		--_removeList[#_removeList+1] = "map_image"
--		
--		--local nameInfo = hApi.GetMapNameLabInfo(mapName)
--		--if type(nameInfo) == "table" then
--			--_childUI["map_image"].childUI["level_name"] = hUI.label:new({
--				--parent = _childUI["map_image"].handle._n,
--				--x = nameInfo.labX,
--				--y = nameInfo.labY,
--				--font = hVar.FONTC,
--				--text = hVar.MAP_INFO[mapName].name,
--				--size = nameInfo.size,
--				--align = "MC",
--				--border = 1,
--				--RGB = nameInfo.RGB,
--			--})
--		--end
--		
--		local name,info = (hVar.tab_stringM[mapName][5] or hVar.MAP_INFO[mapName].name) , (hVar.tab_stringM[mapName][6] or hVar.MAP_INFO[mapName].info)
--		_childUI["mapName"]:setText(name)
--		_childUI["mapInfo"]:setText(info)
--
--		_childUI["childmapInfo"]:setText(hVar.MAP_INFO[mapName].info)
--
--	end
--
--	local _exitFunc = function()
--		_frm:show(0)
--		for i = 1,#_removeList do
--			hApi.safeRemoveT(_childUI,_removeList[i]) 
--		end
--		_removeList = {}
--	end
--
--	--进入地图按钮
--	_childUI["BtnEnter"] = hUI.button:new({
--		parent = _parent,
--		model = "UI:ButtonBack",
--		icon = "ICON:action_attack",
--		iconWH = 32,
--		iconX = 4,
--		dragbox = _childUI["dragBox"],
--		label = hVar.tab_string["__TEXT_EnterTraining"],
--		font = hVar.FONTC,
--		size = 20,
--		border = 1,
--		x = _w/2 - 120,
--		y = -_h + 30,
--		scaleT = 0.9,
--		scale = 0.9,
--		dragbox = _childUI["dragBox"],
--		code = function()
--			local nMapDifficulty = 3
--			if hGlobal.WORLD.LastWorldMap then
--				nMapDifficulty = hGlobal.WORLD.LastWorldMap.data.MapDifficulty
--				hGlobal.WORLD.LastWorldMap:del()
--				hGlobal.WORLD.LastWorldMap = nil
--				
--			end
--			_exitFunc()
--			xlScene_LoadMap(g_world, _MapName,nMapDifficulty)
--		end,
--	})
--
--	--取消按钮
--	_childUI["BtnCancel"] = hUI.button:new({
--		parent = _parent,
--		model = "BTN:PANEL_CLOSE",
--		dragbox = _childUI["dragBox"],
--		x = _w,
--		y = -10,
--		scaleT = 0.9,
--		dragbox = _childUI["dragBox"],
--		code = function()
--			_exitFunc()
--		end,
--	})
--
--	--返回当前关卡
--	_childUI["BtnBack"] = hUI.button:new({
--		parent = _parent,
--		model = "UI:ButtonBack",
--		icon = "ui/bimage_replay.png",
--		iconWH = 32,
--		iconX = 4,
--		dragbox = _childUI["dragBox"],
--		label = hVar.tab_string["__TEXT_ContinueMap"],
--		font = hVar.FONTC,
--		border = 1,
--		size = 20,
--		x = _w/2+ 120,
--		y = -_h + 30,
--		scaleT = 0.9,
--		scale = 0.9,
--		dragbox = _childUI["dragBox"],
--		code = function()
--			_exitFunc()
--		end,
--	})
--	
--	--找打地图包当前的进度
--	local _findCurLevel = function(mapInfo)
--		for i = 1,#mapInfo.childmap do
--			local childName = mapInfo.childmap[i]
--			local m_level =  LuaGetPlayerMapAchi(map_name,hVar.ACHIEVEMENT_TYPE.LEVEL)
--			if m_level == 0 then
--				return childName
--			end
--		end
--		local mapname = LuaGetCurExmMpName(g_curPlayerName)
--		if mapname == 0 then
--			return mapInfo.childmap[1]
--		end
--		return mapname
--	end
--
--	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(isShow,mapName)
--		for k,v in pairs(hVar.MAP_INFO) do
--			if k == mapName then
--				if v.level == 0 then
--					mapName = _findCurLevel(v)
--					break
--				end
--			end
--		end
--		_createMapInfo(mapName)
--		_frm:show(isShow)
--		_frm:active()
--	end)
--
--end