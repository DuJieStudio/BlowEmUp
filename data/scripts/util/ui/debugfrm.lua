--用于调试的窗口
hGlobal.UI.InitDeBugFrm = function()
	local _x,_y,_w,_h = 300,600,400,300
	hGlobal.UI.DeBugFrm  = hUI.frame:new({
		x = _x,
		y = _y,
		dragable = 2,
		show = 0,
		w = _w,
		h = _h,
		closebtn = "BTN:PANEL_CLOSE",
		closebtnX = _w - 10,
		closebtnY = -14,
	})

	local _frm = hGlobal.UI.DeBugFrm
	local _parent = _frm.handle._n
	local _childUI = _frm.childUI

	--建筑名字以及Title
	_childUI["DeBug_frm_title"] = hUI.label:new({
		parent = _parent,
		size = 28,
		align = "MC",
		border = 1,
		x = _frm.data.w/2+10,
		y = -30,
		width = 450,
		text = "DebugFrm",
	})
	
	local _removeList = {}
	--创建按钮选择租
	local _btnX,_btnY,_btnOffX,_btnOffY = 100,-80,150,50
	local _createBtnList = function()
		for i = 1,#hVar.DeBugBtnList do
			local v = hVar.DeBugBtnList[i]
			local sText = v[1]
			local tToDo = v[2]
			local nOptionSwitch = 0
			local pCodeOnHit
			--点击执行函数
			if type(tToDo)=="table" and tToDo[1]=="OPTIONS" and type(hVar.OPTIONS[tToDo[2]])=="number" then
				nOptionSwitch = hVar.OPTIONS[tToDo[2]]
				pCodeOnHit = function()
					if hVar.OPTIONS[tToDo[2]]==0 then
						nOptionSwitch = 1
						hVar.OPTIONS[tToDo[2]] = 1
					else
						nOptionSwitch = 0
						hVar.OPTIONS[tToDo[2]] = 0
					end
					hApi.SaveGameOptions()
				end
			else
				pCodeOnHit = function()
					if nOptionSwitch==0 then
						nOptionSwitch = 1
					else
						nOptionSwitch = 0
					end
					DebugFunc(i,nOptionSwitch)
				end
			end
			
			--选择框
			_childUI["select_box_"..i] = hUI.image:new({
				parent = _parent,
				model = "UI:Button_SelectBorder",
				x = _btnX + (i-1)% 1 * _btnOffX + 120,
				y = _btnY- math.ceil((i-1)/1)*_btnOffY,
				scale = 0.4,
			})
		
			_childUI["selectbox_finish_"..i] = hUI.image:new({
				parent = _parent,
				model = "UI:finish",
				scale = 0.9,
				x = _btnX + (i-1)% 1 * _btnOffX + 120,
				y = _btnY- math.ceil((i-1)/1)*_btnOffY,
			})
			if nOptionSwitch==0 then
				_childUI["selectbox_finish_"..i].handle._n:setVisible(false)
			end
			local oSwitchIcon = _childUI["selectbox_finish_"..i]
			_childUI["debugbtn_"..i] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				--model = "UI:button_back",
				border = 1,
				label = sText,
				font = hVar.FONTC,
				scaleT = 0.9,
				x = _btnX + (i-1)% 1 * _btnOffX,
				y = _btnY- math.ceil((i-1)/1)*_btnOffY,
				w = 200,
				scale = 0.9,
				code = function(self)
					pCodeOnHit()
					if nOptionSwitch==0 then
						oSwitchIcon.handle._n:setVisible(false)
					else
						oSwitchIcon.handle._n:setVisible(true)
					end
				end,
			})
		end
	end
	
	_createBtnList()

	hGlobal.event:listen("LocalEvent_OpenDebugFrm","OpenDebugFrm",function()
		--_createBtnList(hVar.DeBugBtnList)
		_frm:show(1,"appear")
		_frm:active()
	end)
end