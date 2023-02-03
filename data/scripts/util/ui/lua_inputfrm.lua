--脚本创建的输入框，目的是为了 安卓版的 登录界面 输入 账号和 密码

hGlobal.UI.InitLua_InputFrm = function()
	local _w,_h = 622,170
	local _x,_y = hVar.SCREEN.w/2 - _w/2 , _h + 20
	local ui_name = ""
	local _exitFunc = nil
	hGlobal.UI.Lua_InputFrm =hUI.frame:new({
			x = _x,
			y = _y,
			w = _w,
			h = _h,
			show = 0,
			dragable = 2,
			titlebar = 0,
			bgAlpha = 0,
			bgMode = "tile",
			border = "UI:TileFrmBasic_thin",
			autoactive = 0,
			codeOnTouch = function(self,x,y,sus)
				if sus == 0 then
					_exitFunc()
				end
			end,
	})

	local _frm = hGlobal.UI.Lua_InputFrm
	local _childUI = _frm.childUI
	local _parent = _frm.handle._n

	local _mode = 0
	
	_childUI["login_lk_bg"] = hUI.bar:new({
		parent = _parent,
		model = "UI:login_lk",
		x = _w/2+2,
		y = -_h/2,
		w = _w-6,
		h = _h,
	})

	for i = 1,10 do
		local text = i
		if i == 10 then text = "0" end
		_childUI["btn"..i] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "UI:login_an",
			label = text,
			border = 1,
			x = 60 + ((i - 1) % 5 ) * 100,
			y = -44 + math.floor((i - 1)/5) * -84,
			scaleT = 0.9,
			code = function()
				hGlobal.event:event("LocalEvent_set_UGID_PASSWORD",ui_name,tostring(text))
			end,
		})
	end

	--退格键
	_childUI["btnDelete"] = hUI.button:new({
		parent = _frm,
		model = "UI:login_an",
		x = 570,
		y = -44, 
		scaleT = 0.9,
		code = function()
			--_childUI["btnOK"]:setstate(0)
			hGlobal.event:event("LocalEvent_BackSpace",ui_name)
		end,
	})
	_childUI["btnDelete"].childUI["icon"] = hUI.button:new({
		parent = _childUI["btnDelete"].handle._n,
		model = "UI:backspace",
		x = 2,
		y = -4,

	})
	
	--_childUI["btnDeleteAll"] = hUI.button:new({
		--parent = _frm,
		--model = "UI:login_an",
		--x = 650,
		--y = -100, 
		--scaleT = 0.9,
		--code = function()
			--_childUI["btnOK"]:setstate(0)
			--hGlobal.event:event("LocalEvent_BackSpaceAll",_mode)
		--end,
	--})

	--_childUI["btnDeleteAll"].childUI["icon"] = hUI.button:new({
		--parent = _childUI["btnDeleteAll"].handle._n,
		--model = "UI:backspaceall",
		--x = 2,
		--y = -2,

	--})

	--取消输入的回调方法
	local _moveFuncBack1 = function()
		_frm:setXY(_x,0)
		_frm.handle._n:setPosition(_x,0)
		_frm:show(0)
	end

	_exitFunc = function()
		_frm.handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.2,ccp(_x,0)),CCCallFunc:create(_moveFuncBack1)))
	end

	--确定按钮
	local _palyerName,_index = "",0
	_childUI["btnOK"] = hUI.button:new({
		parent = _parent,
		dragbox = _childUI["dragBox"],
		label = "OK",
		x = 570,
		y = -128, 
		border = 1,
		model = "UI:login_an",
		scaleT = 0.9,
		code = function(self)
			_exitFunc()
		end,
	})
	_childUI["btnOK"]:setstate(0)

	hGlobal.event:listen("LocalEvent_set_OKbtnState","set_OKbtnState",function(state)
		_childUI["btnOK"]:setstate(state)
	end)

	
	----取消按钮
	--_childUI["btnCancel"] = hUI.button:new({
		--parent = _parent,
		--dragbox = _childUI["dragBox"],
		--label = hVar.tab_string["Exit_Now"],
		--x = _w/2 - 200,
		--y = 30 -_frm.data.h,
		--model = "UI:ButtonBack2",
		--scaleT = 0.9,
		--code = function()
			--_exitFunc()
		--end,
	--})

	--回调函数
	local _tempY = 0
	local _moveFuncBack = function()
		_frm:active()
		_frm:setXY(_x,_tempY)
		_frm.handle._n:setPosition(_x,_tempY)
	end

	--打开此面板
	hGlobal.event:listen("LocalEvent_showLuaInputFrm","__showInputFrm",function(isShow,ui_str_name,mode,len_need,len)
		_mode = mode
		ui_name = ui_str_name
		local y = _h+10
		_childUI["btnOK"]:setstate(0)
		if len and len_need and len >= len_need then
			_childUI["btnOK"]:setstate(1)
		end
		--if mode == 1 and len == 8 then
			--_childUI["btnOK"]:setstate(1)
		--elseif (mode == 2 or mode == 3 or mode == 4)and len == 6 then
			--_childUI["btnOK"]:setstate(1)
		--else
			--_childUI["btnOK"]:setstate(0)
		--end
		_frm:show(isShow)
		if isShow == 1 then
			_frm:active()
			_tempY = y
			_frm:setXY(_x,0)
			_frm.handle._n:setPosition(_x,0)
			_frm.handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.2,ccp(_x,y)),CCCallFunc:create(_moveFuncBack)))
		end
	end)	

end