hGlobal.UI.InitCommonBoardFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowCommonBoardFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _nCurrentType = 0
	local _nLock = 0
	local _frm,_parent,_childUI = nil,nil,nil
	local _tUIList = {}

	local _tButtonInLineDefine = {
		[1] = {"UI:btn_inline1","宝箱",3,0,8},
		[2] = {"UI:btn_inline2","宝物",0,0,3},
		[3] = {"UI:btn_inline3","电影院",0,0,9},
		[4] = {"UI:btn_inline4","",3,0,0},
	}

	local _tButtonInCowDefine = {
		[1] = "UI:btn_incow1",
		[2] = "UI:btn_incow2",
		[3] = "UI:btn_incow3",
		[4] = "UI:btn_incow4",
	}

	local _treasuretype = {
		"科技宝箱",
		"宠物宝箱",
		"战术宝箱",
	}

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateLeftBtn = hApi.DoNothing
	local _CODE_CreateLineBtn = hApi.DoNothing
	local _CODE_CreateCowBtn = hApi.DoNothing
	local _CODE_ClickTypeBtn = hApi.DoNothing
	local _CODE_CreateTV = hApi.DoNothing
	local _CODE_CreateTreasure = hApi.DoNothing
	local _CODE_CreateTreasureBox = hApi.DoNothing
	local _CODE_ClearUI = hApi.DoNothing

	_CODE_ClearUI = function()
		for i = 1,#_tUIList do
			hApi.safeRemoveT(_childUI,_tUIList[i])
		end
		_tUIList = {}
	end
	
	_CODE_ClearFunc = function()
		if hGlobal.UI.CommonBoardFrm then
			hGlobal.UI.CommonBoardFrm:del()
			hGlobal.UI.CommonBoardFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_nCurrentType = 0
		_nLock = 0
		_tUIList = {}
		hGlobal.event:event("LocalEvent_ClearBoardFrm")
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.CommonBoardFrm  = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			autoactive = 0,
			dragable = 0,
			show = 0,
			z = 1000,
		})
		_frm = hGlobal.UI.CommonBoardFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		_childUI["img_bg"] = hUI.image:new({
			parent = _parent,
			model = "UI:bg_10",
			x = hVar.SCREEN.w/2,
			y = -hVar.SCREEN.h/2,
		})

		_childUI["img_cowbar"] = hUI.image:new({
			parent = _parent,
			model = "UI:cowbar",
			x = hVar.SCREEN.w/2,
			y = - 70,
			w = math.floor(1212 * 0.8),
			h = 118,
			--scale = 0.8,
		})

		_childUI["btn_back"] = hUI.button:new({
			parent = _parent,
			model = "UI:backbtn",
			dragbox = _childUI["dragBox"],
			x = hVar.SCREEN.offx + 80,
			y = - 50,
			z = 1,
			code = function()
				_CODE_ClearFunc()
			end,
		})

		_frm:show(1)
		_frm:active()
	end

	_CODE_CreateLineBtn = function()
		_childUI["img_line1"] = hUI.image:new({
			parent = _parent,
			model = "UI:line_store",
			x = hVar.SCREEN.offx + 80,
			y = - hVar.SCREEN.h/2,
		})

		for i = 1,#_tButtonInLineDefine do
			local icon,name,cownum,labx,laby = unpack(_tButtonInLineDefine[i])
			_childUI["btn_inLine"..i] = hUI.button:new({
				parent = _parent,
				model = icon,
				dragbox = _childUI["dragBox"],
				label = {text = name,size = 26,font = hVar.FONTC,x = labx,y = laby},
				x = hVar.SCREEN.offx + 100,
				y = - 80 - i * 90,
				scaleT = 0.9,
				code = function()
					if _nLock ~= 1 then	--锁住
						_CODE_ClickTypeBtn(i)
					end
				end
			})
		end
		
	end

	_CODE_CreateLeftBtn = function()
		local startY = -220
		local startX = hVar.SCREEN.offx + 90
		_childUI["btn_hl1"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/commonboard/btn_hl1.png",
			x = startX,
			y = startY,
			scale = 0.9,
			scaleT = 0.9,
			code = function()
				if _nLock ~= 1 then	--锁住
					_CODE_ClickTypeBtn(1)
				end
			end
		})

		_childUI["btn_hl2"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/commonboard/btn_hl2.png",
			x = startX + 110,
			y = startY - 20,
			scale = 0.9,
			scaleT = 0.9,
			code = function()
				if _nLock ~= 1 then	--锁住
					_CODE_ClickTypeBtn(2)
				end
			end
		})

		_childUI["btn_hl3"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/commonboard/btn_hl3.png",
			x = startX + 40,
			y = startY - 100,
			scale = 0.9,
			scaleT = 0.9,
			code = function()
				if _nLock ~= 1 then	--锁住
					_CODE_ClickTypeBtn(3)
				end
			end
		})

		_childUI["btn_hl4"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/commonboard/btn_hl4.png",
			x = startX + 40,
			y = startY - 180,
			scale = 0.9,
			scaleT = 0.9,
			code = function()
				if _nLock ~= 1 then	--锁住
					_CODE_ClickTypeBtn(4)
				end
			end
		})

		_childUI["img_blackdragon"] = hUI.image:new({
			parent = _parent,
			model = "misc/commonboard/blackdragon.png",
			x = hVar.SCREEN.offx + 150,
			y = - hVar.SCREEN.h + 180,
			scale = 0.8,
		})
	end

	_CODE_CreateCowBtn = function(cownum)
		for i = 1,cownum do
			local name = ""
			local icon = _tButtonInCowDefine[i]
			if _nCurrentType == 1 then
				name = _treasuretype[i]
			end
			_childUI["btn_inCow"..i] = hUI.button:new({
				parent = _parent,
				model = icon,
				dragbox = _childUI["dragBox"],
				x = (hVar.SCREEN.w - 1280)/2 + 380 + (i-1)*174,
				y = - 40,
				label = {text = name,size = 24,},
				scale = 0.9,
				scaleT = 0.9,
				code = function()
					if _nLock ~= 1 then	--锁住
						
					end
				end
			})

			_tUIList[#_tUIList + 1] = "btn_inCow"..i
		end
	end

	_CODE_ClickTypeBtn = function(nType)
		if _nCurrentType == nType then
			return
		end
		_CODE_ClearUI()
		hGlobal.event:event("LocalEvent_ClearBoardFrm")
		_nCurrentType = nType
		local cownum = _tButtonInLineDefine[nType][3]
		_CODE_CreateCowBtn(cownum)
		if nType == 1 then
			_CODE_CreateTreasureBox()
		elseif nType == 2 then
			_CODE_CreateTreasure()
		elseif nType == 3 then
			_CODE_CreateTV()
		end
	end

	_CODE_CreateTV = function()
		hGlobal.event:event("LocalEvent_ShowTvBoardFrm")
	end

	_CODE_CreateTreasure = function()
		hGlobal.event:event("LocalEvent_ShowTreasureBoardFrm")
	end

	_CODE_CreateTreasureBox = function()
		hGlobal.event:event("LocalEvent_ShowTreasureBoxBoardFrm")
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(nType,nLock)
		_CODE_ClearFunc()
		_nLock = nLock
		_CODE_CreateFrm()
		--_CODE_CreateLineBtn()
		_CODE_CreateLeftBtn()
		_CODE_ClickTypeBtn(nType)
	end)
end

hGlobal.UI.InitTVBoardFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowTvBoardFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _tBoardArea = {hVar.SCREEN.offx + 280,-100,1000,hVar.SCREEN.h - 100,0}
	if hVar.SCREEN.w == 1360 then
		_tBoardArea[1] = hVar.SCREEN.offx + 320
	elseif hVar.SCREEN.w == 1560 then
		_tBoardArea[1] = hVar.SCREEN.offx + 360
	end

	local _frm,_parent,_childUI = nil,nil,nil
	local _pClipNode = nil
	local _dragrect = {}

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateTv = hApi.DoNothing

	local _CODE_HitPage = hApi.DoNothing
	local _CODE_DragPage = hApi.DoNothing
	local _CODE_DropPage = hApi.DoNothing
	local _CODE_AdjustGridButton = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.TvBoardFrm then
			hGlobal.UI.TvBoardFrm:del()
			hGlobal.UI.TvBoardFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_pClipNode = nil
		_dragrect = {}
	end

	_CODE_CreateFrm = function()
		table_print(_tBoardArea)
		hGlobal.UI.TvBoardFrm  = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			dragable = 0,
			buttononly = 2,
			autoactive = 0,
			show = 0,
			z = 1001,
			codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
				--点击Grid
				local tPickParam = _CODE_HitPage(self, tTempPos, relTouchX, relTouchY)
				if tPickParam~=nil then
					return self:pick(tPickParam.sGridName, _dragrect, tTempPos, {_CODE_DragPage,_CODE_DropPage,tPickParam})
				end
			end,
		})
		_frm = hGlobal.UI.TvBoardFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI
		_childUI["dragBox"].data.dragArea = _tBoardArea

		local pClipNode,pClipMask,pClipMaskN = hApi.CreateClippingNode(_frm,_tBoardArea,0,_tBoardArea[5])
		_pClipNode = pClipNode

		_CODE_CreateTv()

		_frm:show(1)
		_frm:active()
	end

	_CODE_CreateTv = function()
		local scale = 0.8
		local width = 316 * scale
		local height = 250 * scale
		local line = 2
		local cow = 3

		local offw = (_tBoardArea[3] - width * cow)/(cow + 1)
		local offh = (_tBoardArea[4] - height * line)/(line + 1)
		local num = 6

		_childUI["clipnode"] = hUI.node:new({
			parent = _pClipNode,
			gridW = (width + offw*(cow + 1)/cow),
			gridH = (height + offh*(line + 1)/line),
		})
		local nodeChild = _childUI["clipnode"].childUI
		local nodeParent = _childUI["clipnode"].handle._n
		

		for i = 1,num do
			local j = (i - 1) % cow + 1
			local k = math.floor((i-1) / cow)
			nodeChild["btn_tv"..i] = hUI.button:new({
				parent = nodeParent,
				model = "UI:TV",
				dragbox = _childUI["dragBox"],
				x = _tBoardArea[1] + width/2 + offw + (width + offw) * (j-1),
				y = _tBoardArea[2] - height/2 - offh - (height + offh) * k,
				scaleT = 0.98,
				scale = scale,
				code = function()
					--显示广告
					xlShowAds()
				end,
			})
		end

		local gh = math.max(0,math.ceil(num/cow)-line)*(height + offh*(line + 1)/line)
		_dragrect = {0, 0+gh, 0, math.max(1, gh)}

		_CODE_AdjustGridButton()
	end

	_CODE_HitPage = function(self,tTempPos,x,y)
		if hApi.IsInBox(x, y, _tBoardArea) then		--【判断是否在设定的可点击区域】
			local tPickParam = {sGridName = "clipnode", nPickI=0,state=0, nDelay=0, code=0}
			return tPickParam
		end
	end
	--拖拽
	_CODE_DragPage = function(self,tTempPos,tPickParam)
		if 0 == tPickParam.state then
			if (tTempPos.x-tTempPos.tx)^2+(tTempPos.y-tTempPos.ty)^2>144 then	--触摸移动点如果大于12个像素，即作为滑动处理
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
			--调整显示内容位置对其顶部
			local autoalign = {"V","clipnode",0,0,0}
			self:aligngrid(autoalign, _dragrect, tTempPos)

			--调整Grid中的按钮
			_CODE_AdjustGridButton()
		end
	end

	_CODE_AdjustGridButton = function()
		local node = _childUI["clipnode"]
		if not(node) then return end
		_childUI["dragBox"]:sortbutton()

		local nodeChild =  _childUI["clipnode"].childUI
		--更新Grid中按钮
		local btnList = {}
		local num = 6
		btnList = {"btn_tv"}
		for i = 1,num do
			for j = 1,#btnList do
				local btnname = btnList[j]..i
				local oBtn = nodeChild[btnname]
				if oBtn then
					oBtn.data.ox = node.data.x
					oBtn.data.oy = node.data.y
					_childUI["dragBox"]:setbutton(oBtn,oBtn.data.ox,oBtn.data.oy)
					if hApi.IsInBox(oBtn.data.x+oBtn.data.ox,oBtn.data.y+oBtn.data.oy, _tBoardArea) then
						--可视区域内
						oBtn.data.state = 1
					else
						--可视区域外   设置为隐藏
						oBtn.data.state = 0
					end
				end
			end
		end
	end

	hGlobal.event:listen("LocalEvent_ClearBoardFrm","TvBoardFrm",function()
		_CODE_ClearFunc()
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_CODE_ClearFunc()
		_CODE_CreateFrm()
	end)
end

hGlobal.UI.InitTreasureBoardFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowTreasureBoardFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _infooffw = 20
	local _tBoardArea = {hVar.SCREEN.offx + 280,-110,680,hVar.SCREEN.h - 140,0}
	if hVar.SCREEN.w == 1360 then
		_tBoardArea[1] = hVar.SCREEN.offx + 320
		_infooffw = 30
	elseif hVar.SCREEN.w == 1560 then
		_tBoardArea[1] = hVar.SCREEN.offx + 340
		_infooffw = 50
	end

	local _frm,_parent,_childUI = nil,nil,nil
	local _pClipNode = nil
	local _curIndex = 0 
	local _tUIList = {}

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateTreasure = hApi.DoNothing
	local _CODE_RunAction = hApi.DoNothing
	local _CODE_ClickTreasure = hApi.DoNothing
	local _CODE_ClearUI = hApi.DoNothing

	local _CODE_HitPage = hApi.DoNothing
	local _CODE_DragPage = hApi.DoNothing
	local _CODE_DropPage = hApi.DoNothing
	local _CODE_AdjustGridButton = hApi.DoNothing

	_CODE_RunAction = function(child)
		local delayTime1 = math.random(200, 500)
		local delayTime2 = math.random(500, 1500)
		local moveTime = math.random(1000, 2500)
		local moveDy = math.random(5, 12)
		local act1 = CCDelayTime:create(delayTime1/1000)
		local act2 = CCMoveBy:create(moveTime/1000, ccp(0, moveDy))
		local act3 = CCDelayTime:create(delayTime2/1000)
		local act4 = CCMoveBy:create(moveTime/1000, ccp(0, -moveDy))
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		--oItem.handle.s:stopAllActions() --先停掉之前的动作
		child.handle._n:runAction(CCRepeatForever:create(sequence))
	end

	_CODE_ClearFunc = function()
		if hGlobal.UI.TreasureBoardFrm then
			hGlobal.UI.TreasureBoardFrm:del()
			hGlobal.UI.TreasureBoardFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_pClipNode = nil
		_curIndex = 0
		_tUIList = {}
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.TreasureBoardFrm  = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			dragable = 2,
			buttononly = 2,
			show = 0,
			z = 1001,
			codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
				--点击Grid
				local tPickParam = _CODE_HitPage(self, tTempPos, relTouchX, relTouchY)
				if tPickParam~=nil then
					return self:pick(tPickParam.sGridName, _dragrect, tTempPos, {_CODE_DragPage,_CODE_DropPage,tPickParam})
				end
			end,
		})
		_frm = hGlobal.UI.TreasureBoardFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI
		_childUI["dragBox"].data.dragArea = _tBoardArea

		local pClipNode,pClipMask,pClipMaskN = hApi.CreateClippingNode(_frm,_tBoardArea,99,_tBoardArea[5])
		_pClipNode = pClipNode

		_childUI["img_line"] = hUI.image:new({
			parent = _parent,
			model = "UI:line_blue",
			x = _tBoardArea[1] + _tBoardArea[3],
			y = - hVar.SCREEN.h/2 - 70,
		})
		

		_CODE_CreateTreasure()
		_CODE_ClickTreasure(1)

		_frm:show(1)
		_frm:active()
	end

	_CODE_CreateTreasure = function()
		local width = 96
		local height = 96
		local line = 4
		local cow = 4

		local maxStar = 5

		local offw = (_tBoardArea[3] - width * cow)/(cow + 1)
		local offh = (_tBoardArea[4] - height * line)/(line + 1)
		local num = #hVar.tab_treasureEx

		_childUI["clipnode"] = hUI.node:new({
			parent = _pClipNode,
			gridW = (width + offw*(cow + 1)/cow),
			gridH = (height + offh*(line + 1)/line),
		})
		local nodeChild = _childUI["clipnode"].childUI
		local nodeParent = _childUI["clipnode"].handle._n

		local startx = _tBoardArea[1] - 20
		local starty = _tBoardArea[2]
		

		for i = 1,num do
			local icon = ""
			local index = hVar.tab_treasureEx[i]
			local tabT =  hVar.tab_treasure[index]
			if tabT and tabT.icon then
				icon = tabT.icon
			end
			local j = (i - 1) % cow + 1
			local k = math.floor((i-1) / cow)
			nodeChild["btn_Treasure"..i] = hUI.button:new({
				parent = nodeParent,
				model = icon,
				dragbox = _childUI["dragBox"],
				x = startx + width/2 + offw + (width + offw) * (j-1),
				y = starty - height/2 - offh - (height + offh) * k,
				scaleT = 0.98,
				code = function()
					_CODE_ClickTreasure(i)
				end,
			})
			_CODE_RunAction(nodeChild["btn_Treasure"..i])

			--星星底纹
			for s = 1, maxStar, 1 do
				--星星底纹
				nodeChild["img_starbg" .. i.."_"..s] = hUI.image:new({
					parent = nodeParent,
					model = "misc/treasure/medal_xingbian.png",
					x = startx + width/2 + offw + (width + offw) * (j-1) + 18 * (s-1) - 34,
					y = starty - height/2 - offh - (height + offh) * k - 58,
					z = 2,
					w = 26,
					h = 26,
					scale = 0.7,
					alpha = 128,
				})
			end

			if i%2 == 1 then
				nodeChild["img_desk" .. i] = hUI.image:new({
					parent = nodeParent,
					--x = OFFSET_DX - 10,
					x = startx + width/2 + offw + (width + offw) * (j-1) + 84,
					y = starty - height/2 - offh - (height + offh) * k - 60,
					z = -1,
					model = "misc/treasure/medal_desk2.png",
					scale = 0.7,
					align = "MC",
				})
			end
		end

		local gh = math.max(0,math.ceil(num/cow)-line)*(height + offh*(line + 1)/line)
		_dragrect = {0, 0+gh, 0, math.max(1, gh)}

		_CODE_AdjustGridButton()
	end

	_CODE_ClearUI = function()
		for i = 1,#_tUIList do
			hApi.safeRemoveT(_childUI,_tUIList[i])
		end
		_tUIList = {}
	end

	_CODE_ClickTreasure = function(nI)
		if _curIndex == nI then
			return
		end
		_curIndex = nI
		local index = hVar.tab_treasureEx[_curIndex]
		local tabT =  hVar.tab_treasure[index]
		if tabT == nil then
			return
		end
		
		_CODE_ClearUI()

		local totalw = (hVar.SCREEN.w - _tBoardArea[1] - _tBoardArea[3])
		local startx = _tBoardArea[1] + _tBoardArea[3]

		_childUI["img_curTreasure"] = hUI.image:new({
			parent = _parent,
			model = tabT.icon,
			x = startx+80,
			y = - 190,
		})
		_CODE_RunAction(_childUI["img_curTreasure"])
		_tUIList[#_tUIList+1] = "img_curTreasure"

		_childUI["lab_curname"] = hUI.label:new({
			parent = _parent,
			text = tabT.name,
			align = "LC",
			x = startx+140,
			y = - 200,
		})
		_tUIList[#_tUIList+1] = "lab_curname"

		local tab_STR = hVar.tab_stringTR[_curIndex]
		local level = 1
		if tab_STR[level] then
			local height = 0
			for i = 1,#tab_STR[level] do
				local info = tab_STR[level][i]
				local info = tab_STR[level][i]
				_childUI["lab_info"..i] = hUI.label:new({
					parent = _parent,
					text = info,
					align = "LT",
					x = startx+_infooffw,
					y = - 260 - height - (i-1)*20,
					width = totalw - _infooffw - hVar.SCREEN.offx - 20,
				})
				_tUIList[#_tUIList+1] = "lab_info"..i
				local _,h = _childUI["lab_info"..i]:getWH()
				height = height + h
			end
		end

		local btnname = hVar.tab_string["__UNLOCK"]
		_childUI["btn_Cost"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			x = startx + totalw/2,
			y = -hVar.SCREEN.h +80,
			w = 130,
			h = 60,
			label = {x = 0, y = 4, text = btnname, font = hVar.FONTC, border = 1, align = "MC", size = 30,},
			font = hVar.FONTC,
			border = 1,
			model = "misc/chariotconfig/button10.png",
			animation = "normal",
			scaleT = 0.95,
			scale = 1.0,
			code = function()
				
			end,
		})
		_tUIList[#_tUIList+1] = "btn_Cost"
		hApi.AddShader(_childUI["btn_Cost"].handle.s,"gray")
	end

	_CODE_HitPage = function(self,tTempPos,x,y)
		if hApi.IsInBox(x, y, _tBoardArea) then		--【判断是否在设定的可点击区域】
			local tPickParam = {sGridName = "clipnode", nPickI=0,state=0, nDelay=0, code=0}
			return tPickParam
		end
	end
	--拖拽
	_CODE_DragPage = function(self,tTempPos,tPickParam)
		if 0 == tPickParam.state then
			if (tTempPos.x-tTempPos.tx)^2+(tTempPos.y-tTempPos.ty)^2>144 then	--触摸移动点如果大于12个像素，即作为滑动处理
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
			--调整显示内容位置对其顶部
			local autoalign = {"V","clipnode",0,0,0}
			self:aligngrid(autoalign, _dragrect, tTempPos)

			--调整Grid中的按钮
			_CODE_AdjustGridButton()
		end
	end

	_CODE_AdjustGridButton = function()
		local node = _childUI["clipnode"]
		if not(node) then return end
		_childUI["dragBox"]:sortbutton()

		local nodeChild =  _childUI["clipnode"].childUI
		--更新Grid中按钮
		local btnList = {}
		local num = #hVar.tab_treasureEx
		btnList = {"btn_Treasure"}
		for i = 1,num do
			for j = 1,#btnList do
				local btnname = btnList[j]..i
				local oBtn = nodeChild[btnname]
				if oBtn then
					oBtn.data.ox = node.data.x
					oBtn.data.oy = node.data.y
					_childUI["dragBox"]:setbutton(oBtn,oBtn.data.ox,oBtn.data.oy)
					if hApi.IsInBox(oBtn.data.x+oBtn.data.ox,oBtn.data.y+oBtn.data.oy, _tBoardArea) then
						--可视区域内
						oBtn.data.state = 1
					else
						--可视区域外   设置为隐藏
						oBtn.data.state = 0
					end
				end
			end
		end
	end

	hGlobal.event:listen("LocalEvent_ClearBoardFrm","TreasureBoardFrm",function()
		_CODE_ClearFunc()
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_CODE_ClearFunc()
		_CODE_CreateFrm()
	end)
end

hGlobal.UI.InitTreasureBoxBoardFrm = function(mode)
	local tInitEventName = {"LocalEvent_ShowTreasureBoxBoardFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _tBoardArea = {hVar.SCREEN.offx + 280,-110,1000,hVar.SCREEN.h - 140,0}
	local _tBoardArea = {hVar.SCREEN.offx + 280,-100,1000,hVar.SCREEN.h - 100,0}
	if hVar.SCREEN.w == 1360 then
		_tBoardArea[1] = hVar.SCREEN.offx + 320
	elseif hVar.SCREEN.w == 1560 then
		_tBoardArea[1] = hVar.SCREEN.offx + 360
	end

	local _frm,_parent,_childUI = nil,nil,nil
	local _pClipNode = nil

	local _CODE_ClearFunc = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateTreasureBox = hApi.DoNothing
	local _CODE_RunAction = hApi.DoNothing

	local _CODE_HitPage = hApi.DoNothing
	local _CODE_DragPage = hApi.DoNothing
	local _CODE_DropPage = hApi.DoNothing
	local _CODE_AdjustGridButton = hApi.DoNothing

	_CODE_ClearFunc = function()
		if hGlobal.UI.TreasureBoxBoardFrm then
			hGlobal.UI.TreasureBoxBoardFrm:del()
			hGlobal.UI.TreasureBoxBoardFrm = nil
		end
		_frm,_parent,_childUI = nil,nil,nil
		_pClipNode = nil
	end

	_CODE_CreateFrm = function()
		hGlobal.UI.TreasureBoxBoardFrm  = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,
			dragable = 2,
			buttononly = 2,
			show = 0,
			z = 1001,
			codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
				--点击Grid
				local tPickParam = _CODE_HitPage(self, tTempPos, relTouchX, relTouchY)
				if tPickParam~=nil then
					return self:pick(tPickParam.sGridName, _dragrect, tTempPos, {_CODE_DragPage,_CODE_DropPage,tPickParam})
				end
			end,
		})
		_frm = hGlobal.UI.TreasureBoxBoardFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI
		_childUI["dragBox"].data.dragArea = _tBoardArea

		local pClipNode,pClipMask,pClipMaskN = hApi.CreateClippingNode(_frm,_tBoardArea,99,_tBoardArea[5])
		_pClipNode = pClipNode

		_CODE_CreateTreasureBox()

		_frm:show(1)
		_frm:active()
	end

	_CODE_RunAction = function(index)
		local nodeChild = _childUI["clipnode"].childUI
		local nodeParent = _childUI["clipnode"].handle._n

		local delayTime1 = math.random(200, 500)
		local delayTime2 = math.random(500, 1500)
		local moveTime = math.random(1000, 2500)
		local moveDy = math.random(5, 15)
		local act1 = CCDelayTime:create(delayTime1/1000)
		local act2 = CCMoveBy:create(moveTime/1000, ccp(0, moveDy))
		local act3 = CCDelayTime:create(delayTime2/1000)
		local act4 = CCMoveBy:create(moveTime/1000, ccp(0, -moveDy))
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		--oItem.handle.s:stopAllActions() --先停掉之前的动作
		nodeChild["btn_treasurebox"..index].handle._n:runAction(CCRepeatForever:create(sequence))
	end

	_CODE_CreateTreasureBox = function()
		local scale = 1
		local width = 300 * scale
		local height = 200 * scale
		local line = 2
		local cow = 3

		local offw = (_tBoardArea[3] - width * cow)/(cow + 1)
		local offh = (_tBoardArea[4] - height * line)/(line + 1)
		local num = 6

		_childUI["clipnode"] = hUI.node:new({
			parent = _pClipNode,
			gridW = (width + offw*(cow + 1)/cow),
			gridH = (height + offh*(line + 1)/line),
		})
		local nodeChild = _childUI["clipnode"].childUI
		local nodeParent = _childUI["clipnode"].handle._n
		
		local startx = _tBoardArea[1]
		local starty = _tBoardArea[2] + 30

		for i = 1,num do
			local j = (i - 1) % cow + 1
			local k = math.floor((i-1) / cow)
			nodeChild["btn_treasurebox"..i] = hUI.button:new({
				parent = nodeParent,
				model = "UI:treasurebox",
				dragbox = _childUI["dragBox"],
				x = startx + width/2 + offw + (width + offw) * (j-1),
				y = starty - height/2 - offh - (height + offh) * k,
				scaleT = 0.98,
				scale = scale,
				code = function()
					
				end,
			})
			_CODE_RunAction(i)

			nodeChild["img_treasureboxbg"..i] = hUI.image:new({
				parent = nodeParent,
				model = "UI:treasureboxbg",
				x = startx + width/2 + offw + (width + offw) * (j-1),
				y = starty - height/2 - offh - (height + offh) * k - 40,
				scale = scale,
				code = function()
					
				end,
			})
		end

		local gh = math.max(0,math.ceil(num/cow)-line)*(height + offh*(line + 1)/line)
		_dragrect = {0, 0+gh, 0, math.max(1, gh)}

		_CODE_AdjustGridButton()
	end

	_CODE_HitPage = function(self,tTempPos,x,y)
		if hApi.IsInBox(x, y, _tBoardArea) then		--【判断是否在设定的可点击区域】
			local tPickParam = {sGridName = "clipnode", nPickI=0,state=0, nDelay=0, code=0}
			return tPickParam
		end
	end
	--拖拽
	_CODE_DragPage = function(self,tTempPos,tPickParam)
		if 0 == tPickParam.state then
			if (tTempPos.x-tTempPos.tx)^2+(tTempPos.y-tTempPos.ty)^2>144 then	--触摸移动点如果大于12个像素，即作为滑动处理
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
			--调整显示内容位置对其顶部
			local autoalign = {"V","clipnode",0,0,0}
			self:aligngrid(autoalign, _dragrect, tTempPos)

			--调整Grid中的按钮
			_CODE_AdjustGridButton()
		end
	end

	_CODE_AdjustGridButton = function()
		local node = _childUI["clipnode"]
		if not(node) then return end
		_childUI["dragBox"]:sortbutton()

		local nodeChild =  _childUI["clipnode"].childUI
		--更新Grid中按钮
		local btnList = {}
		local num = #hVar.tab_treasureEx
		btnList = {"btn_treasurebox"}
		for i = 1,num do
			for j = 1,#btnList do
				local btnname = btnList[j]..i
				local oBtn = nodeChild[btnname]
				if oBtn then
					oBtn.data.ox = node.data.x
					oBtn.data.oy = node.data.y
					_childUI["dragBox"]:setbutton(oBtn,oBtn.data.ox,oBtn.data.oy)
					if hApi.IsInBox(oBtn.data.x+oBtn.data.ox,oBtn.data.y+oBtn.data.oy, _tBoardArea) then
						--可视区域内
						oBtn.data.state = 1
					else
						--可视区域外   设置为隐藏
						oBtn.data.state = 0
					end
				end
			end
		end
	end

	hGlobal.event:listen("LocalEvent_ClearBoardFrm","TreasureBoxBoardFrm",function()
		_CODE_ClearFunc()
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		_CODE_ClearFunc()
		_CODE_CreateFrm()
	end)
end