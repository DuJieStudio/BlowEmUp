-----------------------
--分兵界面
-----------------------
hGlobal.UI.InitArmyCtrlFrm = function()
	--主界面
	hGlobal.UI.PartArmyFrm = hUI.frame:new({
		x = 520,
		y = 350,
		closebtn = "BTN:PANEL_CLOSE",
		background = "UI:PANEL_INFO_MINI",
		dragable = 2,
		show = 0,
		codeOnClose = function()
			--changed by pangyong 2015/4/13		(分兵界面的关闭后对军队列表关闭的影响，hGlobal.UI.Phone_herocardFrm已经废弃，现用hGlobal.UI.HeroCardNewFrm = hUI.frame:new)
			--if hGlobal.UI.Phone_herocardFrm and hGlobal.UI.Phone_herocardFrm.data.show ~= 1 then
				--hGlobal.event:event("LocalEvent_PartArmy_close")
			--end
			hGlobal.event:event("LocalEvent_PartArmy_close")
		end,
	})
	
	local _frm = hGlobal.UI.PartArmyFrm
	local _parent = _frm.handle._n
	local _childui = _frm.childUI
	
	local _NNUM,_NMAX = 1,2
	local _uNum = {0,0}
	local _bar,_num
	
	_uNum[_NMAX] = 0
	_uNum[_NNUM] = 0 
	
	--拖拽条
	_childui["PartArmy_bar"] = hUI.valbar:new({
		parent = _parent,
		model = "UI:ValueBar",
		back = {model = "UI:ValueBar_Back",x=0,y=0,w=280,h=36},
		w = 280,
		h = 36,
		x = 60,
		y = -_frm.data.h/2 + 30,
		align = "LT",
	})
	_bar = _childui["PartArmy_bar"]
	_bar:setV(140,280)
	

	_childui["scrollBtn"] = hUI.image:new({
		parent = _parent,
		model = "UI:scrollBtn",
		x = 65,
		y = -_frm.data.h/2 + 19,
	})
	_childui["scrollBtn"].handle._n:setPosition(205,-_frm.data.h/2 + 19)
	--拖拽条上显示的数字
	_childui["PartArmy_labNum"] = hUI.label:new({
		parent = _parent,
		font = "numWhite",
		size = 18,
		text = "",
		align = "MC",
		x = _bar.data.x+_bar.data.w/2,
		y = _bar.data.y-_bar.data.h/2,
	})
	_num = _childui["PartArmy_labNum"]
	
	_childui["PartArmy_title"] = hUI.label:new({
		parent = _parent,
		font = hVar.FONTC,
		size = 32,
		border = 1,
		RGB = {255,255,0},
		text = hVar.tab_string["__TEXT_PartArmy"],
		align = "MC",
		x = _bar.data.x+_bar.data.w/2,
		y = _bar.data.y+ 50,
	})

	_childui["PartArmy_btnScorll"] = hUI.button:new({
		parent = _parent,
		mode = "imageButton",
		dragbox = _frm.childUI["dragBox"],
		model = "MODEL:Default",
		w = _bar.data.w,
		h = 32,
		x = _bar.data.x,
		y = _bar.data.y,
		align = "LT",
		failcall = 1,
		codeOnTouch = function(self,x,y,sus)
			x = math.min(280,math.max(0,x-self.data.x))
			_bar:setV(x,280)
			local tempX = x
			if tempX > 270 then tempX = 270 end
			_childui["scrollBtn"].handle._n:setPosition(tempX+65,-_frm.data.h/2 + 19)
			_uNum[_NNUM] = math.ceil(_uNum[_NMAX]*x/_bar.data.w)
			_num:setText(tostring(_uNum[_NNUM].."/".._uNum[_NMAX]))
			if _uNum[_NNUM] == 0 or _uNum[_NNUM] == _uNum[_NMAX] then
				_childui["btnConfirm"]:setstate(0)
			else
				_childui["btnConfirm"]:setstate(1)
			end
			
		end,
		codeOnDrag = function(self,x,y,sus)
			x = math.min(280,math.max(0,x-self.data.x))
			_bar:setV(x,280)
			local tempX = x
			if tempX > 270 then tempX = 270 end
			_childui["scrollBtn"].handle._n:setPosition(tempX+65,-_frm.data.h/2 + 19)
			_uNum[_NNUM] = math.ceil(_uNum[_NMAX]*x/_bar.data.w)
			_num:setText(tostring(_uNum[_NNUM].."/".._uNum[_NMAX]))
			if _uNum[_NNUM] == 0 or _uNum[_NNUM] == _uNum[_NMAX] then
				_childui["btnConfirm"]:setstate(0)
			else
				_childui["btnConfirm"]:setstate(1)
			end
		end,
	})
	_childui["PartArmy_btnScorll"].handle.s:setVisible(false)
	
	--拖拽条左箭头
	_childui["PartArmy__btnMinus"] = hUI.button:new({
		parent = _parent,
		mode = "imageButton",
		dragbox = _frm.childUI["dragBox"],
		model = "UI:btnMinus",
		animation = "L",
		w = 32,
		h = 32,
		x = _bar.data.x-20,
		y = _bar.data.y-16,
		scaleT = 0.75,
		codeOnTouch = function(self,x,y,sus)
			if _uNum[_NNUM]>0 then
				_uNum[_NNUM] = _uNum[_NNUM] - 1
				_bar:setV(_uNum[_NNUM],_uNum[_NMAX])
				local tempX = _bar.data.w -_bar.data.curW+65
				_childui["scrollBtn"].handle._n:setPosition(_bar.data.w -_bar.data.curW+65,-_frm.data.h/2 + 19)
				_num:setText(tostring(_uNum[_NNUM].."/".._uNum[_NMAX]))
			end
			if _uNum[_NNUM] == 0 or _uNum[_NNUM] == _uNum[_NMAX] then
				_childui["btnConfirm"]:setstate(0)
			else
				_childui["btnConfirm"]:setstate(1)
			end
		end,
	})
	--拖拽条右箭头
	_childui["PartArmy__btnPlus"] = hUI.button:new({
		parent = _parent,
		mode = "imageButton",
		dragbox = _frm.childUI["dragBox"],
		model = "UI:btnPlus",
		animation = "R",
		w = 32,
		h = 32,
		x = _bar.data.x+_bar.data.w+20,
		y = _bar.data.y-16,
		scaleT = 0.75,
		codeOnTouch = function(self,x,y,sus)
			if _uNum[_NNUM]<_uNum[_NMAX] then
				_uNum[_NNUM] = _uNum[_NNUM] + 1
				_bar:setV(_uNum[_NNUM],_uNum[_NMAX])
				local tempX = _bar.data.w -_bar.data.curW
				if tempX>270 then tempX = 270 end
				_childui["scrollBtn"].handle._n:setPosition(tempX+65,-_frm.data.h/2 + 19)
				_num:setText(tostring(_uNum[_NNUM].."/".._uNum[_NMAX]))
			end
			if _uNum[_NNUM] == 0 or _uNum[_NNUM] == _uNum[_NMAX] then
				_childui["btnConfirm"]:setstate(0)
			else
				_childui["btnConfirm"]:setstate(1)
			end
		end,
	})
	local _oUnit = {}
	local _index,_frmIndex = 0,0
	--确定按钮
	_childui["btnConfirm"] = hUI.button:new({
		parent = _parent,
		mode = "imageButton",
		model = "UI:ConfimBtn1",
		dragbox = _frm.childUI["dragBox"],
		x = _frm.data.w/2 - 10,
		y = -1*(_frm.data.h-70),
		scaleT = 0.9,
		code = function(self)
			_frm:show(0)
			local u = hApi.GetObject(_oUnit)
			hGlobal.LocalPlayer:order(u:getworld(),hVar.OPERATE_TYPE.ARMY_PART,u,{_index,u.data.team[_index][1],_uNum[_NNUM],_uNum[_NMAX]},_frmIndex)
			--hGlobal.event:event("LocalEvent_PartArmy",u,_index,u.data.team[_index][1],_uNum[_NNUM],_uNum[_NMAX],_frmIndex)
		end,
	})
	
	hGlobal.event:listen("LocalEvent_ShowPartArmyFrm","_showthisfrm",function(oUnit,index,frmIndex)
		_frmIndex = frmIndex
		_index = index
		hApi.SetObject(_oUnit,oUnit)
		_uNum[_NMAX] = oUnit.data.team[index][2]
		_uNum[_NNUM] = math.ceil(_uNum[_NMAX]/2)
		_num:setText(tostring(_uNum[_NNUM].."/".._uNum[_NMAX]))
		_childui["scrollBtn"].handle._n:setPosition(205,-_frm.data.h/2 + 19)
		_bar:setV(_uNum[_NNUM],_uNum[_NMAX])
		if _uNum[_NNUM] == 0 or _uNum[_NNUM] == _uNum[_NMAX] then
			_childui["btnConfirm"]:setstate(0)
		else
			_childui["btnConfirm"]:setstate(1)
		end
		_frm:show(1)
		_frm:active()
	end)
	
end