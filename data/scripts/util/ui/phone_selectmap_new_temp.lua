
--关卡选择界面（新版临时）
hGlobal.UI.InitSelectBattleMapFrm_temp = function(mode)
	local tInitEventName = {"localEvent_ShowSelectBattleMapFrm_temp", "_show",}
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
	
	local _mapDLCname =
	{
		"world/dlc_yxys_zerg", --虫族
		"world/dlc_bio_airship", --生化
		"world/dlc_yxys_airship", --飞船
		"world/dlc_yxys_spider", --机械蜘蛛
		"",
		"",
	}
	
	local _mapDLCunlock =
	{
		true, --虫族
		true, --生化
		true, --飞船
		true, --机械蜘蛛
		false,
		false,
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
		if hGlobal.UI.SelectBattleMapFrm_temp then
			hGlobal.UI.SelectBattleMapFrm_temp:del()
			hGlobal.UI.SelectBattleMapFrm_temp = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_ClipNode = nil
		_dragrect = nil
		_tCallback = nil
		_canDrag = false
	end

	_CODE_EnterMap = function(index, mapname)
		--print("_CODE_EnterMap", index, mapname)
		
		--_CODE_ClearFunc()
		--GameManager.GameStart(hVar.GameType.RANDBATTLE,nil,mapname)
		local tabM = hVar.MAP_INFO[mapname]
		if tabM then
			hGlobal.event:event("LocalEvent_Phone_ShowDLCMapInfoFrm", mapname)
		end
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
			local mapname = _mapDLCname[i]
			--local unlock = LuaGetPlayerMapAchi(mapname,hVar.ACHIEVEMENT_TYPE.LEVEL)
			local unlock = 0
			if _mapDLCunlock[i] then
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
					_CODE_EnterMap(index, mapname)
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
		hGlobal.UI.SelectBattleMapFrm_temp = hUI.frame:new({
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
		_frm = hGlobal.UI.SelectBattleMapFrm_temp
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

	hGlobal.event:listen("LocalEvent_SpinScreen","SelectBattleMapFrm_temp",function()
		if _frm and _frm.data.show == 1 then
			local tCallback = _tCallback
			_CODE_ClearFunc()
			_tCallback = tCallback
			_CODE_CreateFrm()
		end
	end)
	
	--切场景把自己藏起来
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld", "__Phone_UI__HideSelectmap_temp", function(sSceneType, oWorld, oMap)
		--隐藏自己
		_CODE_ClearFunc()
	end)
	
	--"localEvent_ShowSelectBattleMapFrm_temp"
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(tCallback)
		_CODE_ClearFunc()
		_tCallback = tCallback
		_CODE_CreateFrm()
	end)
end

--[[
if hGlobal.UI.SelectBattleMapFrm_temp then
	hGlobal.UI.SelectBattleMapFrm_temp:del()
	hGlobal.UI.SelectBattleMapFrm_temp = nil
end
hGlobal.UI.InitSelectBattleMapFrm_temp("include")
hGlobal.event:event("localEvent_ShowSelectBattleMapFrm_temp")
]]



