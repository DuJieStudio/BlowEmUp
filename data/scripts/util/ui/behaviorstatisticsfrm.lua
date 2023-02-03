hGlobal.UI.InitBehaviorStatisticsFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowBehaviorStatisticsFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end
	local _frm,_parent,_childUI = nil,nil,nil
	local _nHaveCreateBehaviorList = 0
	local _nShowBehaviorList = 0
	local _blfrm,_blparent,_blchildUI = nil,nil,nil
	local _pClipNode = nil
	local _canDrag = false
	local _tBehaviorListUIInfo = {}
	local _dragrect = {0,0,0,0}
	local _tClippingRect = {0,0,0,0}
	local _tBoardWH = {300,hVar.SCREEN.h - 200}
	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CloseFrm = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_ClickBehaviorListBtn = hApi.DoNothing
	local _CODE_CreateBehaviorListFrm = hApi.DoNothing
	local _CODE_CreateBehavior = hApi.DoNothing
	local _CODE_SwitchUIShow = hApi.DoNothing
	local _CODE_SwitchAllUI = hApi.DoNothing
	local _CODE_SetSwitchUIRGB = hApi.DoNothing
	local _CODE_ClickBehaviorUI = hApi.DoNothing
	local _CODE_UpdateBehaviorUI = hApi.DoNothing
	local _CODE_AddEvent = hApi.DoNothing
	local _CODE_ClearEvent = hApi.DoNothing

	local _CODE_HitPage = hApi.DoNothing
	local _CODE_DragPage = hApi.DoNothing
	local _CODE_DropPage = hApi.DoNothing

	_CODE_CloseFrm = function()
		_CODE_ClearFunc()
		_CODE_ClearEvent()
		_nShowBehaviorList = 0
	end

	_CODE_ClearFunc = function()
		if hGlobal.UI.BehaviorStatisticsFrm then
			hGlobal.UI.BehaviorStatisticsFrm:del()
			hGlobal.UI.BehaviorStatisticsFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		if hGlobal.UI.BehaviorListFrm then
			hGlobal.UI.BehaviorListFrm:del()
			hGlobal.UI.BehaviorListFrm = nil
		end
		_blfrm,_blparent,_blchildUI = nil,nil,nil
		_pClipNode = nil
		_canDrag = false
		_nHaveCreateBehaviorList = 0
		_tClippingRect = {0,0,0,0}
		_tBehaviorListUIInfo = {}
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.BehaviorStatisticsFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,--"UI:zhezhao",
			dragable = 0,
			show = 0,
			buttononly = 1,
			z = 20001,
		})
		_frm = hGlobal.UI.BehaviorStatisticsFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		_childUI["btn_list"] = hUI.button:new({
			parent = _parent,
			model = "UI:zhezhao",
			dragbox = _childUI["dragBox"],
			label = {text = "行为列表",align = "MC",font = hVar.FONTC,size = 24,width = 60,y = 2,},
			x = 60,
			y = - hVar.SCREEN.h + 60,
			w = 60,
			h = 60,
			scaleT = 0.95,
			code = function()
				--print("aaaaaaa")
				_CODE_ClickBehaviorListBtn()
			end,
		})

		_childUI["btn_reload"] = hUI.button:new({
			parent = _parent,
			model = "UI:zhezhao",
			dragbox = _childUI["dragBox"],
			label = {text = "重载文件",align = "MC",font = hVar.FONTC,size = 24,width = 60,y = 2,},
			x = 140,
			y = - hVar.SCREEN.h + 60,
			w = 60,
			h = 60,
			scaleT = 0.95,
			code = function()
				BehaviorStatistics.Reload()
			end,
		})

		_childUI["btn_RestartGame"] = hUI.button:new({
			parent = _parent,
			model = "UI:zhezhao",
			dragbox = _childUI["dragBox"],
			label = {text = "重开此关",align = "MC",font = hVar.FONTC,size = 24,width = 60,y = 2,},
			x = 220,
			y = - hVar.SCREEN.h + 60,
			w = 60,
			h = 60,
			scaleT = 0.95,
			code = function()
				local str = "重开游戏并清理所有统计"
				hGlobal.UI.MsgBox(str, {
					font = hVar.FONTC,
					textAlign = "LC",
					ok = {"清理并重开",function()
						BehaviorStatistics.RestartGame(true)
					end},
					cancel = {"不清理并重开",function()
						BehaviorStatistics.RestartGame(false)
					end},
				})
			end,
		})


		_frm:show(1)
		_frm:active()
	end

	_CODE_ClickBehaviorListBtn = function()
		if _nShowBehaviorList == 0 then
			if _nHaveCreateBehaviorList == 0 then
				_CODE_CreateBehaviorListFrm()
			end
			_nShowBehaviorList = 1
			_blfrm:show(1)
		else
			_nShowBehaviorList = 0
			_blfrm:show(0)
		end
	end

	_CODE_CreateBehaviorListFrm = function()
		print("_CODE_CreateBehaviorListFrm")
		hGlobal.UI.BehaviorListFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h/2 + _tBoardWH[2]/2,
			w = _tBoardWH[1],
			h = _tBoardWH[2],
			background = -1,--"UI:zhezhao",
			dragable = 0,
			show = 0,
			z = 20002,
			codeOnTouch = function(self,relTouchX, relTouchY,IsInside,tTempPos)
				if _canDrag == true then
					local tParam = _CODE_HitPage(self,tTempPos,relTouchX, relTouchY)
					if tParam~=nil then
						--点击Grid
						return self:pick("node1",_dragrect,tTempPos,{_CODE_DragPage,_CODE_DropPage,tParam})
					end
				end
			end,
		})
		_blfrm = hGlobal.UI.BehaviorListFrm
		_blparent = _blfrm.handle._n
		_blchildUI = _blfrm.childUI

		local offx = _tBoardWH[1]/2
		local offy = -_tBoardWH[2]/2
		print("offy",offy)


		_blchildUI["btn_board"] = hUI.button:new({
			parent = _blparent,
			model = "misc/button_null.png",
			x = offx,
			y = offy,
			w = _tBoardWH[1],
			h = _tBoardWH[2],
		})
		local img9 = hApi.CCScale9SpriteCreate("data/image/misc/chariotconfig/boardbg.png", 0, 0, _tBoardWH[1], _tBoardWH[2], _blchildUI["btn_board"])
		img9:setOpacity(200)

		_tClippingRect = {5,-60,_tBoardWH[1] - 10,_tBoardWH[2] - 64}
		_pClipNode = hApi.CreateClippingNode(_blfrm,_tClippingRect,99,0)

		_CODE_CreateBehavior()

		_blfrm:show(1)
		_blfrm:active()

		_nHaveCreateBehaviorList = 1
	end

	_CODE_SetSwitchUIRGB = function(behaviorId,stype,nstate)
		local node = _blchildUI["node1"]
		if node then
			local nodeChild = node.childUI
			if nodeChild and nodeChild["node_behavior"..behaviorId] then
				local nbchild = nodeChild["node_behavior"..behaviorId].childUI
				if nbchild then
					if stype == "sw_area" then
						if nbchild["lab_area"] then
							if nstate == 1 then
								nbchild["lab_area"].handle.s:setColor(ccc3(50, 200, 100))
							else
								nbchild["lab_area"].handle.s:setColor(ccc3(255, 255, 255))
							end
						end
					elseif stype == "sw_id" then
						if nbchild["lab_id"] then
							if nstate == 1 then
								nbchild["lab_id"].handle.s:setColor(ccc3(50, 200, 100))
							else
								nbchild["lab_id"].handle.s:setColor(ccc3(255, 255, 255))
							end
						end
					end
				end
				--
			end
		end
	end

	_CODE_SwitchUIShow = function(behaviorId,tUIList,bflag)
		local childList = BehaviorStatistics.data.childList[behaviorId]
		if type(childList) == "table" then
			for i = 1,#childList do
				local uitype,param1 = unpack(childList[i])
				print("uitype",uitype)
				if tUIList == "all" or (type(tUIList) == "table" and tUIList[uitype] == 1) then
					
					if uitype == "unit_bid" then
						if param1 and param1.chaUI["BehaviorId"..behaviorId] then
							param1.chaUI["BehaviorId"..behaviorId].handle._n:setVisible(bflag)
						end
					else
						if param1 and param1.handle._n then
							param1.handle._n:setVisible(bflag)
						end
					end
				end
			end
		end
	end

	_CODE_SwitchAllUI = function(bflag)
		for i = 1,#BehaviorStatistics.data.InfoIdx do
			local behaviorId = BehaviorStatistics.data.InfoIdx[i]
			local tUistate = _tBehaviorListUIInfo.uistate[behaviorId]
			for stype,state in pairs(tUistate) do
				if state ~= 0 then
					if bflag then
						_CODE_SetSwitchUIRGB(behaviorId,stype,1)
						_tBehaviorListUIInfo.uistate[behaviorId][stype] = 1
					else
						_CODE_SetSwitchUIRGB(behaviorId,stype,-1)
						_tBehaviorListUIInfo.uistate[behaviorId][stype] = -1
					end
				end
			end
			_CODE_SwitchUIShow(behaviorId,"all",bflag)
		end
	end

	_CODE_ClickBehaviorUI = function(idx,stype)
		local behaviorId = _tBehaviorListUIInfo.list[idx]
		local uilist = BehaviorStatistics.data.childList[behaviorId]
		
		local state = _tBehaviorListUIInfo.uistate[behaviorId][stype] or 0
		if state ~= 0 then
			local bflag = true
			if state == 1 then
				bflag = false
				_CODE_SetSwitchUIRGB(behaviorId,stype,-1)
				_tBehaviorListUIInfo.uistate[behaviorId][stype] = -1
			else
				_CODE_SetSwitchUIRGB(behaviorId,stype,1)
				_tBehaviorListUIInfo.uistate[behaviorId][stype] = 1
			end
			if stype == "sw_area" then
				_CODE_SwitchUIShow(behaviorId,{["area_img"] = 1,["area_bid"] = 1,},bflag)
			elseif stype == "sw_id" then
				_CODE_SwitchUIShow(behaviorId,{["unit_bid"] = 1,},bflag)
			end
		end
	end

	_CODE_CreateBehavior = function()
		_blchildUI["lab_title"] = hUI.label:new({
			parent = _blparent,
			text = "行为统计",
			size = 26,
			align = "LC",
			font = hVar.FONTC,
			x = 20,
			y = - 30,
		})

		_blchildUI["btn_closearea"] = hUI.button:new({
			parent = _blparent,
			model = "UI:zhezhao",
			dragbox = _blchildUI["dragBox"],
			label = {text = "信息全关",align = "MC",font = hVar.FONTC,size = 22,width = 60,y = 2,},
			w = 54,
			h = 54,
			x = 180,
			y = - 30,
			scaleT = 0.9,
			code = function()
				_CODE_SwitchAllUI(false)
			end,
		})

		_blchildUI["btn_showarea"] = hUI.button:new({
			parent = _blparent,
			model = "UI:zhezhao",
			dragbox = _blchildUI["dragBox"],
			label = {text = "信息全开",align = "MC",font = hVar.FONTC,size = 22,width = 60,y = 2,},
			w = 54,
			h = 54,
			x = 260,
			y = - 30,
			scaleT = 0.9,
			code = function()
				_CODE_SwitchAllUI(true)
			end,
		})

		print("_CODE_CreateBehavior")
		hApi.safeRemoveT(_blchildUI,"node1")
		_blchildUI["node1"] = hUI.node:new({
			parent = _pClipNode,
			--x = _ClippingRect_a1[1],
			--y = _ClippingRect_a1[2],
		})
		local nodeChild = _blchildUI["node1"].childUI
		local nodeParent = _blchildUI["node1"].handle._n
		--BehaviorStatistics.data.Info[id] = {
		--	count = info.count or 1,
		--	times = 0,
		--	str = "信息",
		--}
		local offh = 64
		local offx = _tClippingRect[1]
		local offy = _tClippingRect[2] - offh/2
		_tBehaviorListUIInfo = {}
		_tBehaviorListUIInfo.totalH = 0
		_tBehaviorListUIInfo.uix = offx
		_tBehaviorListUIInfo.uiy = offy
		_tBehaviorListUIInfo.offh = offh
		_tBehaviorListUIInfo.list = {}
		_tBehaviorListUIInfo.uistate = {}
		_tBehaviorListUIInfo.btnlist = {
			["sw_area"] = {
				200, 62, 30, 60
			},
			["sw_id"] = {
				240, 62, 30, 60
			},
		}
		local totalH = 0
		for i = 1,#BehaviorStatistics.data.InfoIdx do
			local behaviorId = BehaviorStatistics.data.InfoIdx[i]
			--print("behaviorId",behaviorId)
			local info = BehaviorStatistics.data.Info[behaviorId]
			local killevent = BehaviorStatistics.data.KillEvent[behaviorId]
			_tBehaviorListUIInfo.list[i] = behaviorId
			_tBehaviorListUIInfo.uistate[behaviorId] = {}
			--table_print(info)
			nodeChild["node_behavior"..behaviorId] = hUI.button:new({
				parent = nodeParent,
				model = "misc/mask.png",
				x = offx + 5,
				y = offy - (i - 1) * offh,
				w = 1,
				h = 1,
			})

			local nbchild = nodeChild["node_behavior"..behaviorId].childUI
			local nbparent = nodeChild["node_behavior"..behaviorId].handle._n
			
			local str = string.format("%d:  %d / %d\n%s",behaviorId,info.count,info.times,info.str)
			nbchild["lab_info"] = hUI.label:new({
				parent = nbparent,
				text = str,
				size = 22,
				align = "LC",
				font = hVar.FONTC,
				x = 0,
				y = 0,
			})
			if info.count >= info.times then
				nbchild["lab_info"].handle.s:setColor(ccc3(50, 200, 100))
			end

			local rgb = {255,255,255}
			_tBehaviorListUIInfo.uistate[behaviorId]["sw_area"] = -1
			if info.DrawArea == nil then
				rgb = {100, 100, 100}
				_tBehaviorListUIInfo.uistate[behaviorId]["sw_area"] = 0
			end
			nbchild["lab_area"] = hUI.label:new({
				parent = nbparent,
				text = "区域",
				size = 22,
				align = "LC",
				font = hVar.FONTC,
				width = 30,
				x = 200,
				y = 0,
				RGB = rgb,
			})
			
			local rgb = {255,255,255}
			_tBehaviorListUIInfo.uistate[behaviorId]["sw_id"] = -1
			if killevent == nil then
				rgb = {100, 100, 100}
				_tBehaviorListUIInfo.uistate[behaviorId]["sw_id"] = 0
			end
			nbchild["lab_id"] = hUI.label:new({
				parent = nbparent,
				text = "目标",
				size = 22,
				align = "LC",
				font = hVar.FONTC,
				width = 30,
				x = 240,
				y = 0,
				RGB = rgb,
			})
			totalH = totalH + offh
		end
		local gh = math.max(0,totalH - _tClippingRect[4])
		_dragrect = {0, gh, 0, math.max(1, gh)}
		_canDrag = true
	end

	_CODE_HitPage = function(self,tTempPos,x,y)
		local tParam
		if hApi.IsInBox(x,y,_tClippingRect) then
			tParam = {tip = "node1",state=0, nDelay=0, code=0}
		end
		return tParam
	end

	_CODE_DragPage = function(self,tTempPos,tPickParam)
		if tPickParam.state==0 then
			if (tTempPos.y-tTempPos.ty)^2>64 then
				if tPickParam.state==0 then
					tPickParam.state = 1
					tTempPos.tx = tTempPos.x
					tTempPos.ty = tTempPos.y
				else
					return 0
				end
			else
				return 0
			end
		elseif tPickParam.state==2 then
			return 0
		end
	end

	_CODE_DropPage = function(self,tTempPos,tPickParam)
		if tPickParam.state==0 then
			local oy = (_tBoardWH[2] - hVar.SCREEN.h)/2 + _tClippingRect[2]
			local ox = _tClippingRect[1] + 1
			local nodeoffy = _blchildUI["node1"].data.y
			local realY = math.abs(tTempPos.y - hVar.SCREEN.h - oy) + nodeoffy
			local realX = tTempPos.x - ox
			local index = math.floor(realY / _tBehaviorListUIInfo.offh) + 1
			print("index",index)
			if index then
				local offy = realY % _tBehaviorListUIInfo.offh
				for uiname,box in pairs(_tBehaviorListUIInfo.btnlist) do
					if hApi.IsInBox(realX,offy,box) then
						--print(uiname)
						_CODE_ClickBehaviorUI(index,uiname)
						break
					end
				end
			end
		end
	end

	_CODE_UpdateBehaviorUI = function(tBehaviorIdList)
		if _blfrm and _blfrm.data.show == 1 then
			local node = _blchildUI["node1"]
			local nodeChild = node.childUI
			local nodeParent = node.handle._n
			for i = 1,#tBehaviorIdList do
				local behaviorId = tBehaviorIdList[i]
				local nbnode = nodeChild["node_behavior"..behaviorId]
				local info = BehaviorStatistics.data.Info[behaviorId]
				if nbnode and info then
					local nbchild = nbnode.childUI
					local nbparent = nbnode.handle._n
					
					local str = string.format("%d:  %d / %d\n%s",behaviorId,info.count,info.times,info.str)
					nbchild["lab_info"]:setText(str)
					if info.count >= info.times then
						nbchild["lab_info"].handle.s:setColor(ccc3(50, 200, 100))
					end
				end
			end
		end
	end

	_CODE_AddEvent = function()
		hGlobal.event:listen("LocalEvent_UpdateBehaviorStatistics","BehaviorStatistics",_CODE_UpdateBehaviorUI)
		hGlobal.event:listen("LocalEvent_CloseBehaviorStatistics","BehaviorStatistics",_CODE_CloseFrm)
	end

	_CODE_ClearEvent = function()
		hGlobal.event:listen("LocalEvent_UpdateBehaviorStatistics","BehaviorStatistics",nil)
		hGlobal.event:listen("LocalEvent_CloseBehaviorStatistics","BehaviorStatistics",nil)
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_CODE_ClearFunc()
		_CODE_CreateFrm()
		_CODE_AddEvent()
		_CODE_ClickBehaviorListBtn()
	end)
end