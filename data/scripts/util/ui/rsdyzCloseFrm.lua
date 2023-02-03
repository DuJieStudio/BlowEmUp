--其实现在是我的领地里按game start后的面板 懒得svn上改名字
hGlobal.UI.InitRsdyzCloseFrm_RSDYZ = function(sInitMode)
	if sInitMode=="init" then
		return hVar.RESULT_FAIL
	end

	local _x,_y,_w,_h = hVar.SCREEN.w/2 -230,hVar.SCREEN.h/2 +170,460,340
	local x,y,w,h = _x,_y,_w,_h
	local wait = 0

	local aaa = hUI.frame:new({
		x = _x,
		y = _y,
		h = _h,
		w = _w,
		dragable = 2,
		show = 0,
		--background = "UI:tip_item",
		--closebtn = "BTN:PANEL_CLOSE",
		--closebtnX = _w - 10,
		--closebtnY = -14,
		border = 1,
		autoactive = 0,
		codeOnTouch = function(self,x,y,IsInside,tTempPos)
			
		end,
		codeOnClose = function(self)

		end
	})

	local _frm = aaa
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	_childUI["reconnect"] = hUI.button:new({
		parent = _parent,
		model = "UI:ButtonBack",
		dragbox = _frm.childUI["dragBox"],
		x = 150,
		y = -300,
		w = 110,
		h = 40,
		scaleT = 0.9,
		align = "MC",
		label = {text = hVar.tab_string["RSDYZ_RECONNECT"],size = 24,font = hVar.FONTC,border = 1,},
		code = function(self)
			if wait == 0 then
				Game_Zone_OnGameEvent(GZone_Event_TypeDef.Enter,luaGetplayerDataID())
				hGlobal.event:event("LocalEvent_ShowRsdyzCloseFrm",0)
			elseif wait == 1 then
				wait = 0
				hGlobal.event:event("LocalEvent_ShowRsdyzCloseFrm",0)
			end
		end,
	})

	local goMain = function()
		if g_current_scene == g_world then
			if hGlobal.WORLD.LastWorldMap~=nil then
				local mapname = hGlobal.WORLD.LastWorldMap.data.map
				if hApi.Is_RSYZ_Map(mapname) ~= -1 then
					Game_Zone_OnGameEvent(GZone_Event_TypeDef.Lua,{GZone_Event_TypeDef.BattleEnd_Fire,luaGetplayerDataID(),g_RSDYZ_BattleID})
				end
				hGlobal.WORLD.LastWorldMap:del()
			end
		end

		hGlobal.event:event("LocalEvent_OpenPhoneMainMenu")
		hGlobal.event:event("LocalEvent_ShowRsdyzCloseFrm",0)
		Game_Zone_OnGameEvent(GZone_Event_TypeDef.Leave,luaGetplayerDataID())
	end

	_childUI["back"] = hUI.button:new({
		parent = _parent,
		model = "UI:ButtonBack",
		dragbox = _frm.childUI["dragBox"],
		x = w - 150,
		y = -300,
		w = 110,
		h = 40,
		scaleT = 0.9,
		align = "MC",
		label = {text = hVar.tab_string["RSDYZ_Attack_End"],size = 24,font = hVar.FONTC,border = 1,},
		code = function(self)
			goMain()
		end,
	})

	_childUI["back_2"] = hUI.button:new({
		parent = _parent,
		model = "UI:ButtonBack",
		dragbox = _frm.childUI["dragBox"],
		x = w/2,
		y = -300,
		w = 110,
		h = 40,
		scaleT = 0.9,
		align = "MC",
		label = {text = hVar.tab_string["RSDYZ_Attack_End"],size = 24,font = hVar.FONTC,border = 1,},
		code = function(self)
			goMain()
		end,
	})

	_childUI["playerInfo"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "MC",
		font = hVar.FONTC,
		x = w/2,
		y = -170,
		width = 300,
		text = "uid:"..xlPlayer_GetUID().."  "..luaGetplayerDataID(),
		border = 1,
	})

	_childUI["errorInfo"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "MC",
		font = hVar.FONTC,
		x = w/2,
		y = -70,
		width = 400,
		text = "",
		border = 1,
	})

	_childUI["gameInfo"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "MC",
		font = hVar.FONTC,
		x = w/2,
		y = -120,
		width = 600,
		text = hVar.tab_string["RSDYZ_ERROR_HAPPENED"],
		border = 1,
	})

	hGlobal.event:listen("LocalEvent_ShowRsdyzCloseFrm","Griffin_showRsdyzCloseFrm",function(isShow,choiceNum,str,errorOrLost)
		_frm:show(isShow)
		local errorHappened = errorOrLost or 1
		if isShow == 1 then
			hGlobal.event:event("LocalEvent_ShowRsdyzInfoFrm",0)
			hGlobal.event:event("LocalEvent_ShowRsdyzAttackFrm",0)

			_frm:active()
			_childUI["reconnect"]:setstate(-1)
			_childUI["back"]:setstate(-1)
			_childUI["back_2"]:setstate(-1)

			if choiceNum == 2 then
				_childUI["reconnect"]:setstate(1)
				_childUI["back"]:setstate(1)
				_childUI["reconnect"]:setText(hVar.tab_string["RSDYZ_RECONNECT"])
			elseif choiceNum == 1 then
				_childUI["back_2"]:setstate(1)
			elseif choiceNum == 3 then
				_childUI["reconnect"]:setstate(1)
				_childUI["back"]:setstate(1)
				_childUI["reconnect"]:setText(hVar.tab_string["RSDYZ_WAIT"])
				wait = 1
			else
				_childUI["back_2"]:setstate(1)
			end
			_childUI["errorInfo"]:setText("")
			if str then
				_childUI["errorInfo"]:setText(str)
			end
			_childUI["gameInfo"]:setText(hVar.tab_string["RSDYZ_ERROR_HAPPENED"])
			if errorHappened == 0 then
				_childUI["gameInfo"]:setText("")
				_childUI["playerInfo"]:setText("")
			end
		end
	end)
end