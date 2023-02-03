hGlobal.UI.InitPrivacyAuthorizationFrm = function(mode)
	local tInitEventName = {"LocalEvent_PrivacyAuthorizationFrm","__showfrm"}
	if mode~="include" then
		return tInitEventName
	end

	local _boardw = 720
	local _boardh = 800
	local gridw = 186
	local gridh = 288
	local _frm,_childUI,_parent = nil,nil,nil
	local _tShowPrivacyList = {}
	local _cliprect = {hVar.SCREEN.w/2 - _boardw/2,gridh/2 - hVar.SCREEN.h/2 - 40,_boardw,gridh,1}
	local _dragrect = {}
	local _agree = 0

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateUI = hApi.DoNothing
	local _CODE_CreatePrivacy = hApi.DoNothing

	local _CODE_HitPage = hApi.DoNothing
	local _CODE_DragPage = hApi.DoNothing
	local _CODE_DropPage = hApi.DoNothing
	local _CODE_AutoLign = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.PrivacyAuthorizationFrm then
			hGlobal.UI.PrivacyAuthorizationFrm:del()
			hGlobal.UI.PrivacyAuthorizationFrm = nil
		end
		_frm,_childUI,_parent = nil,nil,nil
		_tShowPrivacyList = {}
		_dragrect = {}
		_agree = 0
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.PrivacyAuthorizationFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = "UI:black_bg",
			border = 0,
			dragable = 4,
			show = 0,
			autoactive = 0,
			z = 60000,
			codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
				--点击Grid
				local tPickParam = _CODE_HitPage(self, tTempPos, relTouchX, relTouchY)
				if tPickParam~=nil then
					--print("aaa",tPickParam.sGridName)
					table_print(_dragrect)
					return self:pick(tPickParam.sGridName, _dragrect, tTempPos, {_CODE_DragPage,_CODE_DropPage,tPickParam})
				end
			end,
		})
		_frm = hGlobal.UI.PrivacyAuthorizationFrm
		_childUI = _frm.childUI
		_parent = _frm.handle._n

		_frm.handle.s:setColor(ccc3(0,0,0))

		_frm:show(1)
		_frm:active()
	end

	_CODE_CreateUI = function()
		--_childUI["img_bg"] = hUI.image:new({
		--	parent = _parent,
		--	model = "UI:board10",
		--	x = hVar.SCREEN.w/2,
		--	y = -hVar.SCREEN.h/2,
		--})

		local img9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/itemtip.png", hVar.SCREEN.w/2, -hVar.SCREEN.h/2, _boardw, _boardh, _frm)

		_childUI["lab_title"] = hUI.label:new({
			parent = _parent,
			font = hVar.FONTC,
			size = 36,
			text = hVar.tab_string["privacylist"],
			align = "MC",
			x =  hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h/2 + _boardh/2 - 60,
			RGB = {255,200,0},
			border = 1,
		})

		local offy = - 20

		_childUI["lab_info1"] = hUI.label:new({
			parent = _parent,
			font = hVar.FONTC,
			size = 24,
			text = hVar.tab_string["privacyinfo1"],
			align = "LC",
			x =  160,
			y = -hVar.SCREEN.h/2 + _boardh/2 - 120 + offy,
			border = 1,
		})

		_childUI["lab_info2"] = hUI.label:new({
			parent = _parent,
			font = hVar.FONTC,
			size = 24,
			text = hVar.tab_string["privacyinfo2"],
			align = "LC",
			x =  160,
			y = -hVar.SCREEN.h/2 + _boardh/2 - 160 + offy,
			border = 1,
		})

		_childUI["node_info"] = hUI.button:new({
			parent = _parent,
			model = "",
			x =  0,
			y = -hVar.SCREEN.h/2 + _boardh/2 - 200 + offy,
		})
		_childUI["node_info"].handle.s:setOpacity(0)	--设置透明度

		local w = 0
		local privacyx = 0
		local protocolx = 0
		_childUI["node_info"].childUI["info1"] = hUI.label:new({
			parent = _childUI["node_info"].handle._n,
			font = hVar.FONTC,
			size = 24,
			text = hVar.tab_string["__TEXT_Game_Privacy"],
			align = "LC",
			x =  0,
			y = 0,
			border = 1,
		})
		local w1 = _childUI["node_info"].childUI["info1"]:getWH()
		w = w + w1

		_childUI["node_info"].childUI["info2"] = hUI.label:new({
			parent = _childUI["node_info"].handle._n,
			font = hVar.FONTC,
			size = 24,
			text = hVar.tab_string["privacyinfo5"],
			align = "LC",
			x =  w,
			y = 0,
			border = 1,
		})
		local info2W = _childUI["node_info"].childUI["info2"]:getWH()
		w = w + info2W

		_childUI["node_info"].childUI["info3"] = hUI.label:new({
			parent = _childUI["node_info"].handle._n,
			font = hVar.FONTC,
			size = 24,
			text = hVar.tab_string["privacyinfo3"],
			align = "LC",
			x =  w,
			y = 0,
			border = 1,
			RGB = {221,187,61},
		})
		local info3W = _childUI["node_info"].childUI["info3"]:getWH()
		local privacyx = w + info3W/2
		w = w + info3W

		_childUI["node_info"].childUI["and"] = hUI.label:new({
			parent = _childUI["node_info"].handle._n,
			font = hVar.FONTC,
			size = 24,
			text = hVar.tab_string["__TEXT_And"],
			align = "LC",
			x =  w,
			y = 0,
			border = 1,
		})
		local andw = _childUI["node_info"].childUI["and"]:getWH()
		w = w + andw

		_childUI["node_info"].childUI["info4"] = hUI.label:new({
			parent = _childUI["node_info"].handle._n,
			font = hVar.FONTC,
			size = 24,
			text = hVar.tab_string["privacyinfo4"],
			align = "LC",
			x =  w,
			y = 0,
			border = 1,
			RGB = {221,187,61},
		})
		local info4W = _childUI["node_info"].childUI["info4"]:getWH()
		protocolx = w + info4W/2
		w = w + info4W

		_childUI["node_info"].childUI["info5"] = hUI.label:new({
			parent = _childUI["node_info"].handle._n,
			font = hVar.FONTC,
			size = 24,
			text = hVar.tab_string["privacyinfo6"],
			align = "LC",
			x =  w,
			y = 0,
			border = 1,
		})
		local info5W = _childUI["node_info"].childUI["info5"]:getWH()
		w = w + info5W

		_childUI["node_info"]:setXY(160,-hVar.SCREEN.h/2 + _boardh/2 - 200 + offy)

		_childUI["btn_Agree"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/mask.png",
			x = _childUI["node_info"].data.x - 70,
			y = _childUI["node_info"].data.y + 40,
			w = 140,
			h = 50,
			code = function()
				if _agree == 0 then
					_agree = 1
					_childUI["btn_Agree"].childUI["img_finish"].handle._n:setVisible(true)
					hApi.AddShader(_childUI["btn_ok"].handle.s, "normal")
				else
					_agree = 0
					_childUI["btn_Agree"].childUI["img_finish"].handle._n:setVisible(false)
					hApi.AddShader(_childUI["btn_ok"].handle.s, "gray")
				end
			end,
		})
		_childUI["btn_Agree"].handle.s:setOpacity(0)

		_childUI["btn_Agree"].childUI["image"] = hUI.image:new({
			parent = _childUI["btn_Agree"].handle._n,
			model = "UI:Button_SelectBorder",
			scale = 0.5,
		})

		_childUI["btn_Agree"].childUI["img_finish"] = hUI.image:new({
			parent = _childUI["btn_Agree"].handle._n,
			model = "misc/gopherboom/gou.png",
			--scale = 1.2,
			x = 2,
			--y = 4,
		})
		_childUI["btn_Agree"].childUI["img_finish"].handle._n:setVisible(false)

		local iChannelId = getChannelInfo()
		local btnok_x = hVar.SCREEN.w/2
		if iChannelId == 1003 then
			btnok_x = hVar.SCREEN.w/2 + 140
			local btnno_x = hVar.SCREEN.w/2 - 140

			_childUI["btn_no"] = hUI.button:new({
				parent = _parent,
				dragbox = _childUI["dragBox"],
				model = "misc/chest/itembtn.png",
				scaleT = 0.95,
				label= {text = hVar.tab_string["__TEXT_NoAgree"],size = 30,font = hVar.FONTC},
				x =  btnno_x,
				y = -hVar.SCREEN.h/2 - _boardh/2 + 90,
				w = 180,
				h = 80,
				code = function()
					local str = string.format(hVar.tab_string["NoAgreeAndExit"],hVar.tab_string["privacyinfo3"],hVar.tab_string["privacyinfo4"])
					hGlobal.UI.MsgBox(str,
					{
						textFont = hVar.FONTC,
						textAlign = "LC",
						ok = function()
							xlExit()
						end,
					})
				end,
			})
		end

		_childUI["btn_ok"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/chest/itembtn.png",
			scaleT = 0.95,
			label= {text = hVar.tab_string["__TEXT_Agree"],size = 28,font = hVar.FONTC,y = 2},
			x =  btnok_x,
			y = -hVar.SCREEN.h/2 - _boardh/2 + 90,
			w = 180,
			h = 80,
			code = function()
				if _agree == 1 then
					if iChannelId ~= 1003 then
						hGlobal.event:event("LocalEvent_allowGamePrivacy")
					end
					--有这个本地缓存  说明不需要授权
					if type(g_noQueryPermission) == "table" then
						hApi.RecordNoQueryPermissionProcess(3)
						hGlobal.event:event("LocalEvent_CheckShowAnnouncementFrm")
					else
						if type(xlGrantPermission) == "function" then
							xlGrantPermission(0)
						end
					end
					_CODE_ClearFunc()
				else
					local text = hVar.tab_string["__TEXT_Game_Privacy"]..hVar.tab_string["__TEXT_Privacy"]..hVar.tab_string["__TEXT_And"]..hVar.tab_string["__TEXT_Protocol"]
					hUI.floatNumber:new({
						text = "",
						font = "numRed",
						moveY = 64,
					}):addtext(text,hVar.FONTC,36,"MC",hVar.SCREEN.w/2,hVar.SCREEN.h/2,nil,1)
				end
			end,
		})
		hApi.AddShader(_childUI["btn_ok"].handle.s, "gray")

		_childUI["btn_showprivacy"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "",
			x = _childUI["node_info"].data.x + privacyx,
			y = -hVar.SCREEN.h/2 + _boardh/2 - 200 + offy,
			w = info3W+10,
			h = 50,
			--scaleT = 0.9,
			--z = 1000,
			code = function(self)
				--print("2222")
				hGlobal.event:event("LocalEvent_ShowPrivacyAgreementFrm")
			end,
		})
		_childUI["btn_showprivacy"].handle.s:setOpacity(0)	--设置透明度

		_childUI["btn_showprotocol"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "",
			x = _childUI["node_info"].data.x + protocolx,
			y = -hVar.SCREEN.h/2 + _boardh/2 - 200 + offy,
			w = info4W+10,
			h = 50,
			--scaleT = 0.9,
			--z = 1000,
			code = function(self)
				--print("2222")
				hGlobal.event:event("LocalEvent_ShowProtocolAgreementFrm")
			end,
		})
		_childUI["btn_showprotocol"].handle.s:setOpacity(0)	--设置透明度
	end

	_CODE_CreatePrivacy = function()
		--_tShowPrivacyList = {1,2,3,3,2,1}
		_tShowPrivacyList = {1,2,3}
		local cownum = 3
		local num = #_tShowPrivacyList
		if num <= cownum then
			local offw = (_boardw - gridw * num )/ (num + 1)
			print(offw)
			for i = 1,num do
				local index = _tShowPrivacyList[i]
				_childUI["btn_privacy"..i] = hUI.button:new({
					parent = _parent,
					--dragbox = _childUI["dragBox"],
					model = "ICON:privacy"..index,
					x = hVar.SCREEN.w/2 - _boardw/2 + offw * i + gridw * (i - 0.5),
					y = - hVar.SCREEN.h/2 - 60,
					code = function()
						
					end,
				})

				local btn = _childUI["btn_privacy"..i]
				btn.childUI["name"] = hUI.label:new({
					parent = btn.handle._n,
					font = hVar.FONTC,
					size = 22,
					text = hVar.tab_string["privacyname"..index],
					align = "MC",
					x = 0,
					y = 20,
					border = 1,
				})

				btn.childUI["info"] = hUI.label:new({
					parent = btn.handle._n,
					font = hVar.FONTC,
					size = 22,
					text = hVar.tab_string["privacyintroduce"..index],
					--align = "LC",
					--x = -gridw/2 + 16,
					align = "MC",
					x = 0,
					y = -80,
					width = 160,
					border = 1,
				})
			end
		else
			local offw = (_boardw - gridw * cownum )/ (cownum + 1)
			local _ClipNode = hApi.CreateClippingNode(_parent, _cliprect, 5, _cliprect[5])
	
			_childUI["node"] = hUI.node:new({
				parent = _ClipNode,
				x = _cliprect[1],
				y = _cliprect[2],
				gridW = offw + gridw,
				gridH = gridh,
			})
			_NodeParent = _childUI["node"].handle._n
			_NodeChild =  _childUI["node"].childUI

			for i = 1,num do
				local index = _tShowPrivacyList[i]
				_NodeChild["btn_privacy"..i] = hUI.button:new({
					parent = _NodeParent,
					--dragbox = _childUI["dragBox"],
					model = "ICON:privacy"..index,
					x = offw * i + gridw * (i - 0.5),
					y = - gridh/2,
					code = function()
						
					end,
				})

				local btn = _NodeChild["btn_privacy"..i]
				btn.childUI["name"] = hUI.label:new({
					parent = btn.handle._n,
					font = hVar.FONTC,
					size = 22,
					text = hVar.tab_string["privacyname"..index],
					align = "MC",
					x = 0,
					y = 20,
					border = 1,
				})

				btn.childUI["info"] = hUI.label:new({
					parent = btn.handle._n,
					font = hVar.FONTC,
					size = 22,
					text = hVar.tab_string["privacyintroduce"..index],
					--align = "LC",
					--x = -gridw/2 + 16,
					align = "MC",
					x = 0,
					y = -80,
					width = 160,
					border = 1,
				})
			end
			local gw = (offw + gridw)* ( num - 5)
			_dragrect = {_cliprect[1]-gw-math.ceil(_cliprect[3]/cownum), _cliprect[2], gw+math.ceil(_cliprect[3]/cownum) , 0}
			hUI.uiSetXY(_childUI["node"], _cliprect[1], _cliprect[2])
		end
	end

	_CODE_HitPage = function(self,tTempPos,x,y)
		if hApi.IsInBox(x, y, _cliprect) then		--【判断是否在设定的可点击区域】
			local tPickParam = {sGridName = "node", nPickI=0,state=0, nDelay=0, code=0}
			return tPickParam
		end
	end
	--拖拽
	_CODE_DragPage = function(self,tTempPos,tPickParam)
		if 0 == tPickParam.state then
			if (tTempPos.x-tTempPos.tx)^2>36 then					--触摸移动点如果大于12个像素，即作为滑动处理
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
		end
	end
	--抬起
	_CODE_DropPage = function(self,tTempPos,tPickParam)
		if 1 == tPickParam.state then
			local autoalign = {"H","node",math.ceil(_cliprect[4]/4),0,-math.ceil(_cliprect[4]/4)}
			self:aligngrid(autoalign,_dragrect,tTempPos)
		end

	end

	_CODE_AutoLign = function(offx)
		local Node =_childUI["node"]
		local waittime = 0.2
		Node.handle._n:runAction(CCMoveTo:create(waittime,ccp(offx,_cliprect[2])))
		hApi.addTimerOnce("LegionInfoAutoAlign",waittime*1000+1,function()
			hUI.uiSetXY(Node, offx,_cliprect[2])
		end)
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_CODE_ClearFunc()
		_CODE_CreateFrm()
		_CODE_CreateUI()
		_CODE_CreatePrivacy()
	end)
end

hGlobal.UI.InitPrivacyAgreementFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowPrivacyAgreementFrm","__Show"}
	if mode ~= "include" then
		--return tInitEventName
	end

	local _frm,_parent,_childUI
	local _dragY = 0
	local _offy = -2
	local _VY = 0
	local _MaxLen, _nHeight =0,0
	local _waitT = 0
	local _lastT = 0
	local _CurTextIdx = 0
	local _loadTextNum = 1
	local _FrmW,_FrmH = 640,720
	local _cliprect = {hVar.SCREEN.w/2 - _FrmW/2,_FrmH/2 - hVar.SCREEN.h/2,_FrmW,_FrmH - 30,0}

	local _CODE_OnInfoUp = hApi.DoNothing
	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateText_async = hApi.DoNothing
	local _CODE_TimerAsync = hApi.DoNothing

	_CODE_ClearFunc = function()
		hApi.clearTimer("CreatePrivacyText_async")
		if hGlobal.UI.PrivacyAgreementFrm then
			hGlobal.UI.PrivacyAgreementFrm:del()
			hGlobal.UI.PrivacyAgreementFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_dragY = 0
		_offy = -2
		_VY = 0
		_MaxLen, _nHeight =0,0
		_CurTextIdx = 0
		_waitT = 0
		_lastT = 0
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.PrivacyAgreementFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			dragable = 2,
			background = -1, --无底图
			border = 0, --无边框
			show = 0,
			z = 60001,
			codeOnTouch = function(self, relTouchX, relTouchY, IsInside, tTempPos)
				if hApi.IsInBox(relTouchX,relTouchY,_cliprect) then
					local pama = {state = 0}
					self:pick("node",{_cliprect[1],_cliprect[2]+_dragY,0,_dragY},tTempPos,{10,_CODE_OnInfoUp,pama})
				end
			end
		})
		_frm = hGlobal.UI.PrivacyAgreementFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI
		--_frm.handle.s:setOpacity(180)

		local img9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/itemtip.png", hVar.SCREEN.w/2, -hVar.SCREEN.h/2, _FrmW + 40, _FrmH + 200, _frm)

		_childUI["lab_title"] = hUI.label:new({
			parent = _parent,
			font = hVar.FONTC,
			text = hVar.tab_string["__TEXT_GamePrivacy_Title"],
			size = 36,
			align = "MC",
			x = hVar.SCREEN.w/2,
			y = _cliprect[2] + 48,
		})

		local _ClipNode = hApi.CreateClippingNode(_parent, _cliprect, 5, _cliprect[5])
		_childUI["node"] = hUI.node:new({
			parent = _ClipNode,
			x = _cliprect[1],
			y = _cliprect[2],
		})

		_childUI["close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/chest/itembtn.png",
			x = hVar.SCREEN.w/2,
			y = _cliprect[2] - _cliprect[4] - 58,
			w = 180,
			h = 80,
			label = {text = hVar.tab_string["Exit_Ack"],font = hVar.FONTC,size = 26,border = 1,},
			scaleT = 0.9,
			code = function(self)
				_frm:show(0)
			end,
		})
	end
	
	_CODE_CreateText_async = function()
		--_CODE_TimerAsync()
		_NodeParent = _childUI["node"].handle._n
		_NodeChild =  _childUI["node"].childUI

		local offy = _offy
		local maxNum = #PrivacyAgreement_String
		if g_lua_src == 1 then
			maxNum = 30
		end
		for i = 1,_loadTextNum do
			local idx = _CurTextIdx + i
			curidx = idx

			if idx <= maxNum then
				local text = PrivacyAgreement_String[idx]
				strlength = string.len(text)
				showtext = text
				_NodeChild["lab_Content"..idx] = hUI.label:new({
					parent = _NodeParent,
					x= 15,
					y= offy,
					text= text,
					font= hVar.FONTC,
					size= 22,
					align="LT",
					width = _cliprect[3] - 30,
				})
				local _,h = _NodeChild["lab_Content"..idx]:getWH()
				offy = offy - h
				_nHeight = _nHeight + h
			else
				_CurTextIdx = _CurTextIdx + _loadTextNum
				hApi.clearTimer("CreatePrivacyText_async")
				--hGlobal.event:event("LocalEvent_ShowPrivacyAgreementFrm")
				break
			end
		end
		_CurTextIdx = _CurTextIdx + _loadTextNum
		_offy = offy

		local offY = _nHeight
		if offY <= _cliprect[4] then
			_dragY = _nHeight
		else
			_dragY = offY - _cliprect[4]
		end
	end

	--放开
	_CODE_OnInfoUp = function(self,tTempPos,tPickParam)
		local toX,toY = _cliprect[1],_childUI["node"].data.y
		if toY < _cliprect[2] then
			toY = _cliprect[2]
		elseif toY > _dragY + _cliprect[2] then
			toY = _dragY + _cliprect[2]
		end

		if _dragY == _nHeight then
			toY = _cliprect[2]
		end

		_childUI["node"].handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.2,ccp(toX,toY)),CCCallFunc:create(function()
			_childUI["node"].data.x,_childUI["node"].data.y = toX,toY
		end)))
	end

	_CODE_TimerAsync = function()
		hApi.addTimerForever("CreatePrivacyText_async",hVar.TIMER_MODE.GAMETIME,20,function()
			_CODE_CreateText_async()
		end)
	end

	hGlobal.event:listen("LocalEvent_ClearPrivacyFrm", "_ClearFrm",function()
		_CODE_ClearFunc()
	end)

	hGlobal.event:listen("LocalEvent_CreatePrivacyAgreementFrm_async", "asyncfrm",function()
		if _frm == nil then
			_CODE_CreateFrm()
			_CODE_TimerAsync()
		end
	end)

	hGlobal.event:listen(tInitEventName[1], tInitEventName[2],function()
		if _frm then
			_frm:show(1)
			_frm:active()
		end
	end)
end

hGlobal.UI.InitProtocolAgreementFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowProtocolAgreementFrm","__Show"}
	if mode ~= "include" then
		--return tInitEventName
	end

	local _frm,_parent,_childUI
	local _dragY = 0
	local _offy = -2
	local _VY = 0
	local _MaxLen, _nHeight =0,0
	local _waitT = 0
	local _lastT = 0
	local _CurTextIdx = 0
	local _loadTextNum = 1
	local _FrmW,_FrmH = 640,720
	local _cliprect = {hVar.SCREEN.w/2 - _FrmW/2,_FrmH/2 - hVar.SCREEN.h/2,_FrmW,_FrmH - 42,0}

	local _CODE_OnInfoUp = hApi.DoNothing
	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateText_async = hApi.DoNothing
	local _CODE_TimerAsync = hApi.DoNothing

	_CODE_ClearFunc = function()
		hApi.clearTimer("CreateProtocolText_async")
		if hGlobal.UI.ProtocolAgreementFrm then
			hGlobal.UI.ProtocolAgreementFrm:del()
			hGlobal.UI.ProtocolAgreementFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_dragY = 0
		_offy = -2
		_VY = 0
		_MaxLen, _nHeight =0,0
		_CurTextIdx = 0
		_waitT = 0
		_lastT = 0
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.ProtocolAgreementFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			dragable = 2,
			background = -1, --无底图
			border = 0, --无边框
			show = 0,
			z = 60001,
			codeOnTouch = function(self, relTouchX, relTouchY, IsInside, tTempPos)
				if hApi.IsInBox(relTouchX,relTouchY,_cliprect) then
					local pama = {state = 0}
					self:pick("node",{_cliprect[1],_cliprect[2]+_dragY,0,_dragY},tTempPos,{10,_CODE_OnInfoUp,pama})
				end
			end
		})
		_frm = hGlobal.UI.ProtocolAgreementFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI
		--_frm.handle.s:setOpacity(180)

		local img9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/itemtip.png", hVar.SCREEN.w/2, -hVar.SCREEN.h/2, _FrmW + 40, _FrmH + 200, _frm)

		_childUI["lab_title"] = hUI.label:new({
			parent = _parent,
			font = hVar.FONTC,
			text = hVar.tab_string["__TEXT_GameProtocol_Title"],
			size = 36,
			align = "MC",
			x = hVar.SCREEN.w/2,
			y = _cliprect[2] + 48,
		})

		local _ClipNode = hApi.CreateClippingNode(_parent, _cliprect, 5, _cliprect[5])
		_childUI["node"] = hUI.node:new({
			parent = _ClipNode,
			x = _cliprect[1],
			y = _cliprect[2],
		})

		_childUI["close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/chest/itembtn.png",
			x = hVar.SCREEN.w/2,
			y = _cliprect[2] - _cliprect[4] - 70,
			w = 180,
			h = 80,
			label = {text = hVar.tab_string["Exit_Ack"],font = hVar.FONTC,size = 26,border = 1,},
			scaleT = 0.9,
			code = function(self)
				_frm:show(0)
			end,
		})
	end
	
	_CODE_CreateText_async = function()
		--_CODE_TimerAsync()
		_NodeParent = _childUI["node"].handle._n
		_NodeChild =  _childUI["node"].childUI

		local offy = _offy
		local maxNum = #ProtocolAgreement_String
		if g_lua_src == 1 then
			maxNum = 30
		end
		for i = 1,_loadTextNum do
			local idx = _CurTextIdx + i
			curidx = idx

			if idx <= maxNum then
				local text = ProtocolAgreement_String[idx]
				strlength = string.len(text)
				showtext = text
				_NodeChild["lab_Content"..idx] = hUI.label:new({
					parent = _NodeParent,
					x= 15,
					y= offy,
					text= text,
					font= hVar.FONTC,
					size= 22,
					align="LT",
					width = _cliprect[3] - 30,
				})
				local _,h = _NodeChild["lab_Content"..idx]:getWH()
				offy = offy - h
				_nHeight = _nHeight + h
			else
				_CurTextIdx = _CurTextIdx + _loadTextNum
				hApi.clearTimer("CreateProtocolText_async")
				--hGlobal.event:event("LocalEvent_ShowProtocolAgreementFrm")
				break
			end
		end
		_CurTextIdx = _CurTextIdx + _loadTextNum
		_offy = offy

		local offY = _nHeight
		if offY <= _cliprect[4] then
			_dragY = _nHeight
		else
			_dragY = offY - _cliprect[4]
		end
	end

	--放开
	_CODE_OnInfoUp = function(self,tTempPos,tPickParam)
		local toX,toY = _cliprect[1],_childUI["node"].data.y
		if toY < _cliprect[2] then
			toY = _cliprect[2]
		elseif toY > _dragY + _cliprect[2] then
			toY = _dragY + _cliprect[2]
		end

		if _dragY == _nHeight then
			toY = _cliprect[2]
		end

		_childUI["node"].handle._n:runAction(CCSequence:createWithTwoActions(CCMoveTo:create(0.2,ccp(toX,toY)),CCCallFunc:create(function()
			_childUI["node"].data.x,_childUI["node"].data.y = toX,toY
		end)))
	end

	_CODE_TimerAsync = function()
		hApi.addTimerForever("CreateProtocolText_async",hVar.TIMER_MODE.GAMETIME,20,function()
			_CODE_CreateText_async()
		end)
	end

	hGlobal.event:listen("LocalEvent_ClearProtocolFrm", "_ClearFrm",function()
		_CODE_ClearFunc()
	end)

	hGlobal.event:listen("LocalEvent_CreateProtocolAgreementFrm_async", "asyncfrm",function()
		if _frm == nil then
			_CODE_CreateFrm()
			_CODE_TimerAsync()
		end
	end)

	hGlobal.event:listen(tInitEventName[1], tInitEventName[2],function()
		if _frm then
			_frm:show(1)
			_frm:active()
		end
	end)
end