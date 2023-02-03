hGlobal.UI.InitCommentFrm = function(mode)
	local tInitEventName = {"LocalEvent_OpenComment", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _BOARDW = 720	--界面横
	local _BOARDH = 720	--界面宽
	local _ClIP_START_Y = - 96	--滑动列表起始Y
	local _CLIP_RESERVED_W = 20	--滑动列表预留宽度
	local _CLIP_RESERVED_H = 30	--滑动列表预留高度  实际高度位 _BOARDH + _ClIP_START_Y - _CLIP_RESERVED_H
	local _MAX_SHOW_COMMENT_NUM = 20 --最多显示的1级评论数
	local _LIMIT_COMMENT_SHOW_MAXHEIGHT = 2400 --限制评论上下最大显示高度(多删)
	local _LIMIT_COMMENT_SHOW_MINHEIGHT = 1600 --限制评论上下最小显示高度(少补)
	local _DEFAULT_SUBCOMMENT_NUM = 2 --默认显示子评论数
	local _SUBCOMMENTPAGE_MAXSHOW = 6
	local _COMMENT_SHOWWIDTH = 460		--评论显示长度
	local _SUBCOMMENT_SHOWWIDTH = 526	--子评论显示长度
	local _LINE_OFF_H = 16	--线条间隔高度
	local _ICON_WH = 72

	local _tBoardWH = {_BOARDW, _BOARDH}
	local _tBoardXY = {}
	local _tClippingRect = {}
	local _tDragRect = {0,0,0,0}
	local _tCommentUIManage = {}
	local _nSortingRules = 0
	local _nCommentType = 0
	local _nCommentTypeId = 0
	local _sCommentTitle = ""
	local _nCommentShowMode = -1

	local _frm,_childUI,_parent = nil,nil,nil
	local _pClipNode = nil
	local _bCanDrag = false
	local _bShowTestInfo = false

	local _CODE_CloseFunc = hApi.DoNothing
	local _CODE_ClearFrm = hApi.DoNothing
	local _CODE_GetUIConfig = hApi.DoNothing
	local _CODE_InitData = hApi.DoNothing
	local _CODE_SwitchCommentSortingRules = hApi.DoNothing
	local _CODE_UpdateCommentInfo = hApi.DoNothing
	local _CODE_UpdateCommentShow = hApi.DoNothing
	local _CODE_UpdateCommentStar = hApi.DoNothing
	local _CODE_UpdateSubCommentStar = hApi.DoNothing
	local _CODE_RemoveCommentUI = hApi.DoNothing
	local _CODE_CreateCommentUI = hApi.DoNothing
	local _CODE_CreateSubComment = hApi.DoNothing
	local _CODE_CreateSubCommentUI = hApi.DoNothing
	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_CreateShieldBoardFrm = hApi.DoNothing
	local _CODE_CreateCommentBtnFrm = hApi.DoNothing
	local _CODE_CreateBoardUI = hApi.DoNothing
	local _CODE_CreateTestInfo = hApi.DoNothing
	local _CODE_UpdateTestInfo = hApi.DoNothing
	local _CODE_AddEvent = hApi.DoNothing
	local _CODE_ClearEvent = hApi.DoNothing
	local _CODE_DealWithSpinScreen = hApi.DoNothing
	local _CODE_ShowLoadMore = hApi.DoNothing
	local _CODE_CheckLoadMore = hApi.DoNothing
	local _CODE_SwitchSubCommentShow = hApi.DoNothing
	local _CODE_EnterComment = hApi.DoNothing
	local _CODE_ReplySubComment = hApi.DoNothing
	local _CODE_BeforeAddSubComment = hApi.DoNothing
	local _CODE_RefreshUIXY = hApi.DoNothing
	local _CODE_RequireCommentDataFail = hApi.DoNothing
	local _CODE_UpdateCommentTitle = hApi.DoNothing
	local _CODE_CreateSpecialTitle = hApi.DoNothing
	local _CODE_CreateTankAvater = hApi.DoNothing

	local _CODE_AutoLign = hApi.DoNothing
	local _CODE_HitPage = hApi.DoNothing
	local _CODE_DragPage = hApi.DoNothing
	local _CODE_DropPage = hApi.DoNothing

	_CODE_CloseFunc = function()
		_nSortingRules = 0
		_nCommentType = 0
		_nCommentTypeId = 0
		_sCommentTitle = ""
		_nCommentShowMode = -1
		_tCommentUIManage = {}
		_CODE_ClearEvent()
		_CODE_ClearFrm()
		hGlobal.event:event("LocalEvent_SetCommentShieldBoardEnable",false)
	end

	_CODE_ClearFrm = function()
		--hGlobal.event:event("LocalEvent_CloseEnterCommentFrm")
		hGlobal.event:event("LocalEvent_HideEnterCommentFrm")
		if hGlobal.UI.CommentShieldBoardFrm then
			hGlobal.UI.CommentShieldBoardFrm:del()
			hGlobal.UI.CommentShieldBoardFrm = nil
		end
		if hGlobal.UI.CommentBtnFrm then
			hGlobal.UI.CommentBtnFrm:del()
			hGlobal.UI.CommentBtnFrm = nil
		end
		if hGlobal.UI.CommentFrm then
			hGlobal.UI.CommentFrm:del()
			hGlobal.UI.CommentFrm = nil
		end
		_frm,_childUI,_parent = nil,nil,nil
		_pClipNode = nil
		_bCanDrag = false
		_tBoardXY = {}
		_tDragRect = {0,0,0,0}
		hApi.clearTimer("UpdateCommentShow")
	end

	_CODE_GetUIConfig = function()
		if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
			_tBoardXY = {hVar.SCREEN.w / 2 - _tBoardWH[1] / 2,hVar.SCREEN.h / 2 + _tBoardWH[2] / 2 - 10}
		else
			_tBoardXY = {hVar.SCREEN.w / 2 - _tBoardWH[1] / 2,hVar.SCREEN.h / 2 + _tBoardWH[2] / 2}
		end
		_tClippingRect = {_CLIP_RESERVED_W, _ClIP_START_Y, _tBoardWH[1] - _CLIP_RESERVED_W * 2, _tBoardWH[2] + _ClIP_START_Y - _CLIP_RESERVED_H, 0}
	end

	_CODE_InitData = function(nCommentType,nCommentTypeId)
		_nCommentType = nCommentType
		_nCommentTypeId = nCommentTypeId
		local tInfo = CommentManage.GetCommentInfo(nCommentType,nCommentTypeId)
		--table_print(tInfo)
		_sCommentTitle = tInfo[1] or ""
		_nCommentShowMode = tInfo[2] or -1
	end

	_CODE_CreateShieldBoardFrm = function()
		hGlobal.UI.CommentShieldBoardFrm = hUI.frame:new({
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			background = -1,--"UI:zhezhao",
			dragable = 0,
			show = 0,
			z = hZorder.CommentFrm-1,
			codeOnTouch = function(self,relTouchX, relTouchY,IsInside,tTempPos)
				if hGlobal.UI.CommentBtnFrm then
					hGlobal.UI.CommentBtnFrm:active()
				end
				if hGlobal.UI.CommentFrm then
					hGlobal.UI.CommentFrm:active()
				end
			end,
		})

		local frm = hGlobal.UI.CommentShieldBoardFrm
		local child = frm.childUI
		local parent = frm.handle._n

		frm:show(1)
		if hGlobal.UI.CommentBtnFrm then
			hGlobal.UI.CommentBtnFrm:active()
		end
	end

	_CODE_CreateFrm = function()
		if CommentManage.data.EnableShieldBoard then
			_CODE_CreateShieldBoardFrm()
		end
		hGlobal.UI.CommentFrm = hUI.frame:new({
			x = _tBoardXY[1],
			y = _tBoardXY[2],
			w = _tBoardWH[1],
			h = _tBoardWH[2],
			background = -1,--"UI:zhezhao",
			dragable = 0,
			show = 0,
			z = hZorder.CommentFrm,
			codeOnTouch = function(self,relTouchX, relTouchY,IsInside,tTempPos)
				if _bCanDrag == true then
					local tParam = _CODE_HitPage(self,tTempPos,relTouchX, relTouchY)
					if tParam~=nil then
						----点击Grid
						return self:pick("node",_tDragRect,tTempPos,{_CODE_DragPage,_CODE_DropPage,tParam},1)
					end
				end
			end,
		})
		_frm = hGlobal.UI.CommentFrm
		_childUI = _frm.childUI
		_parent = _frm.handle._n

		_CODE_CreateBoardUI()
		_CODE_CreateCommentBtnFrm()

		_frm:show(1)
		_frm:active()
	end

	_CODE_CreateCommentBtnFrm = function()
		print("_nCommentShowMode",_nCommentShowMode)
		if _nCommentShowMode == 0 then
			if hGlobal.UI.CommentBtnFrm then
				return
			end
			hGlobal.UI.CommentBtnFrm = hUI.frame:new({
				x = 0,
				y = hVar.SCREEN.h,
				w = hVar.SCREEN.w,
				h = hVar.SCREEN.h,
				background = -1,--"UI:zhezhao",
				dragable = 0,
				show = 0,
				buttononly = 1,
				z = hZorder.CommentFrm + 1,
			})
			local frm = hGlobal.UI.CommentBtnFrm
			local childUI = frm.childUI
			local parent = frm.handle._n
			local btnX = hVar.SCREEN.w/2
			local btnY = - hVar.SCREEN.h/2 - _tBoardWH[2]/2 - 100
			if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
				btnX = hVar.SCREEN.w/2 + _tBoardWH[1]/2 + 60
				btnY = - _tBoardWH[2] + 60
			end

			childUI["btn_submitComments"] = hUI.button:new({
				parent = parent,
				dragbox = childUI["dragBox"],
				model = "misc/addition/comment_button.png",
				x = btnX,
				y = btnY,
				scaleT = 0.95,
				scale = 0.9,
				code = function()
					_CODE_EnterComment()
				end
			})

			frm:show(1)
			frm:active()
			_frm:active()
			
		end
	end

	_CODE_CreateBoardUI = function()
		local offx = _tBoardWH[1]/2
		local offy = -_tBoardWH[2]/2

		_childUI["_blackpanel"] = hUI.image:new({
			parent = _parent,
			model = "UI:zhezhao",
			x = offx,
			y = offy,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
			z = -1,
		})
		_frm.childUI["_blackpanel"].handle.s:setOpacity(100)
		
		_childUI["img_boardbg"] = hUI.image:new({
			parent = _parent,
			model = "misc/addition/comment_panel.png",
			x = offx,
			y = offy,
			w = _tBoardWH[1],
			h = _tBoardWH[2],
		})
		
		_childUI["closeBtn"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/btn_close.png",
			x = _tBoardWH[1] - 40,
			y = - 48,
			scaleT = 0.95,
			code = function()
				local shouldRecover = true
				if _nCommentType == hVar.CommentTargetTypeDefine.VIP then
					shouldRecover = false
				elseif _nCommentType == hVar.CommentTargetTypeDefine.TANKTALENT then
					shouldRecover = false
				end
				hGlobal.event:event("Event_StartPauseSwitch", false)
				_CODE_CloseFunc()
				if shouldRecover then
					hGlobal.event:event("LocalEvent_RecoverBarrage")
				end
			end,
		})

		--评论标题
		_childUI["titleText"] = hUI.label:new({
			parent = _parent,
			x = offx,
			y = - 33,
			font = hVar.FONTC,
			size = 36,
			align = "MC",
			width = _tBoardWH[1] - 160,
			height = 60,
			text = _sCommentTitle,
			border = 1,
		})

		local bFlag,tConfig = CommentManage.IsSpecialCommentTitle(_nCommentType,_nCommentTypeId)
		if bFlag then
			_childUI["titleText"]:setText("")
			_CODE_CreateSpecialTitle(tConfig)
		end

		_pClipNode = hApi.CreateClippingNode(_frm, _tClippingRect, 99, 0, "commentfrm")
		
		_CODE_SwitchCommentSortingRules()
		_CODE_CreateTestInfo()
	end

	_CODE_CreateSpecialTitle = function(tConfig)
		print("_CODE_CreateSpecialTitle")
		--tConfig.Icon = tInfo.icon
		--tConfig.IconTitle = tInfo.icon_title
		local offx = _tBoardWH[1]/2
		local offy = -_tBoardWH[2]/2
		if _childUI["img_title_icon"] == nil then
			_childUI["img_title_icon"] = hUI.image:new({
				parent = _parent,
				model = tConfig.Icon,
				x = offx - 74,
				y = - 30,
				scale = 0.9,
			})
		end

		if _childUI["img_title_icontitle"] == nil then
			_childUI["img_title_icontitle"] = hUI.image:new({
				parent = _parent,
				model = tConfig.IconTitle,
				x = offx + 48,
				y = - 33,
				scale = 0.9,
			})
		end
	end

	_CODE_CreateTestInfo = function()
		if g_lua_src == 1 and _bShowTestInfo and hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
			if _childUI["testnode"] == nil then
				local boardw = 240
				local boardh = 600
				local offX = - boardw - 10
				local offY = - hVar.SCREEN.h/2 + boardh/2
				_childUI["testnode"] = hUI.node:new({
					parent = _parent,
					x = offX,
					y = offY,
				})

				local testNode = _childUI["testnode"]
				local nodeChild = testNode.childUI
				local nodeParent = testNode.handle._n

				nodeChild["img"] =  hUI.image:new({
					parent = nodeParent,
					w = boardw,
					h = boardh,
					x = boardw/2,
					y = - boardh / 2,
				})

				local strlist = {
					"startIdx",
					"endIdx",
					"curIdx",
					"startShowH",
					"endShowH",
					"curShowH",
					"totalH",
					"showNum",
				}

				for i = 1,#strlist do
					local str = strlist[i]
					nodeChild["lab_"..str] = hUI.label:new({
						parent = nodeParent,
						x = 10,
						y = - 20 - 30 * (i - 1),
						align = "LC",
						size = 24,
						font = hVar.FONTC,
						text = "",
					})
				end
			end
		end
	end

	_CODE_UpdateTestInfo = function()
		--print("_CODE_UpdateTestInfo")
		local tData = _tCommentUIManage.Data
		local testNode = _childUI["testnode"]
				
		if tData and testNode then
			local nodeChild = testNode.childUI
			for str,value in pairs(tData) do
				--print("str",str,value)
				if type(value) == "number" then
					if nodeChild["lab_"..str] then
						nodeChild["lab_"..str]:setText(str .. "  " .. tostring(value))
					end
				end
			end
		end
	end

	_CODE_DealWithSpinScreen = function()
		hApi.clearTimer("UpdateCommentShow")
		--缓存数据
		local tUIData = hApi.ReadParamWithDepth(_tCommentUIManage.UIData,nil,{},3)
		local curShowH = _tCommentUIManage.Data.curShowH
		--local totalH = _tCommentUIManage.Data.totalH
		local curIdx = _tCommentUIManage.Data.curIdx
		_CODE_ClearFrm()
		_CODE_GetUIConfig()
		_CODE_CreateFrm()
		local Node =_childUI["node"]
		local tData = _tCommentUIManage.Data
		if Node and tData then
			_tCommentUIManage.UIData = tUIData
			tData.curIdx = curIdx
			tData.startIdx = math.max(1,curIdx - 1)
			tData.endIdx = math.max(0,curIdx - 1)
			tData.curShowH = curShowH
			tData.endShowH = curShowH
			tData.startShowH = curShowH
			tData.totalH = 0
			hUI.uiSetXY(Node, 0,tData.curShowH)
		end
		_CODE_UpdateCommentInfo()
	end

	_CODE_SwitchCommentSortingRules = function()
		hApi.safeRemoveT(_childUI,"node")
		_childUI["node"] = hUI.node:new({
			parent = _pClipNode,
		})
		_tCommentUIManage.Data = {
			startIdx = 1,--第一个显示的评论序号
			endIdx = 0,--最后一个显示的评论序号
			curIdx = 0,
			startShowH = 0,--第一个显示的评论所在高度
			endShowH = 0,--最后一个显示的评论所在高度
			curShowH = 0,--当前所显示的评论所在高度
			totalH = 0,--所有评论总高度
			showNum = 0,--目前显示的个数
			shouldRefresh = false,
		}
		_tCommentUIManage.UIData = {}
		_tCommentUIManage.tShowIdx = {}
		if _nSortingRules == 0 then	--热度排序（点赞数）
			CommentManage.RequireCommentData(_nCommentType,_nCommentTypeId,0,_nSortingRules)
		else
			
		end

		_childUI["node"].childUI["effect_waiting"] =hUI.image:new({
			parent = _childUI["node"].handle._n,
			model = "MODEL_EFFECT:waiting",
			x = 0 + _tClippingRect[1],
			y = 0 + _tClippingRect[2],
			z = 1,
			scale = 0.6,
		})
		_childUI["node"].childUI["effect_waiting"].handle._n:setVisible(false)

		_childUI["node"].childUI["node_loadmore"] = hUI.button:new({
			parent = _childUI["node"].handle._n,
			x = 0 + _tClippingRect[1],
			y = 0 + _tClippingRect[2],
			model = "",
			w = 1,
			h = 1,
		})
		_childUI["node"].childUI["node_loadmore"].childUI["lab1"] = hUI.label:new({
			parent = _childUI["node"].childUI["node_loadmore"].handle._n,
			x = _tClippingRect[3] / 2,
			y = -18,
			size = 24,
			text = hVar.tab_string["__TEXT_DragDownToLoadMore"],
			align = "MC",
			font = hVar.FONTC,
			border = 1,
		})
		_childUI["node"].childUI["node_loadmore"].childUI["lab1"].handle._n:setVisible(false)
		_childUI["node"].childUI["node_loadmore"].childUI["lab2"] = hUI.label:new({
			parent = _childUI["node"].childUI["node_loadmore"].handle._n,
			x = _tClippingRect[3] / 2,
			y = -18,
			size = 24,
			text = hVar.tab_string["__TEXT_CommentIsBottom"],
			align = "MC",
			font = hVar.FONTC,
			border = 1,
		})
		_childUI["node"].childUI["node_loadmore"].childUI["lab2"].handle._n:setVisible(false)
		local img9 = hApi.CCScale9SpriteCreate("data/image/misc/gopherboom/bar.png", _BOARDW/2, -20, _BOARDW, 40, _childUI["node"].childUI["node_loadmore"],-1)
		img9:setOpacity(120)
		_childUI["node"].childUI["node_loadmore"]:setstate(-1)
		hApi.addTimerForever("UpdateCommentShow", hVar.TIMER_MODE.GAMETIME, 10, _CODE_UpdateCommentShow)
	end

	_CODE_CreateTankAvater = function(avaterId,node)
		local tabA = hVar.tab_avater[avaterId]
		if tabA and node then
			local model = tabA.model
			local bind_wheel = tabA.bind_wheel
			local scale = tabA.scale
			node.childUI["tank"] = hUI.thumbImage:new({
				parent = node.handle._n,
				--id = tankId,
				x = 0,
				y = 0,
				model = model,
				facing = 0,
				w = _ICON_WH,
				h = _ICON_WH,
				scale = 2.1 * scale,
			})

			--战车轮子
			if bind_wheel and (bind_wheel ~= 0) then
				node.childUI["wheel"] = hUI.thumbImage:new({
					parent = node.handle._n,
					id = bind_wheel,
					x = 0,
					y = 0,
					facing = 0,
					w = _ICON_WH,
					h = _ICON_WH,
					scale = 1.5,
				})
			end

			local weaponUnitId = 6013
			local weaponUnitModel = hVar.tab_unit[weaponUnitId].model
			--print("weaponUnitId=", weaponUnitId, "weaponUnitModel=", weaponUnitModel)
			if (weaponUnitModel ~= nil) and (weaponUnitModel ~= "") then
				--战车当前模型
				node.childUI["weapon"] = hUI.thumbImage:new({
					parent = node.handle._n,
					id = weaponUnitId,
					x = 0,
					y = 0,
					--model = model,
					facing = 0,
					w = _ICON_WH,
					h = _ICON_WH,
					scale = 1.5,
				})
			else
				--战车当前模型（特效）
				local tEffect = hVar.tab_unit[weaponUnitId].effect[1]
				local effectId = tEffect[1]
				local effectScale = hVar.tab_effect[effectId].scale
				--print("effectId=", effectId)
				node.childUI["weapon"] = hUI.image:new({
					parent = node.handle._n,
					model = hVar.tab_effect[effectId].model,
					x = tEffect[2],
					y = tEffect[3],
					--model = model,
					facing = 0,
					w = _ICON_WH,
					h = _ICON_WH,
					scale = 1.5 * effectScale * tEffect[4],
				})
			end
		end
	end

	_CODE_RemoveCommentUI = function(nIdx,nCommentId)
		print("_CODE_RemoveCommentUI",nIdx,nCommentId)
		local tUIData = _tCommentUIManage.UIData
		local node = _childUI["node"]
		if node and tUIData[nIdx] then
			tUIData[nIdx].buttonList = {}
			tUIData[nIdx].subbuttonList = {}
			local nodeChild = node.childUI

			hApi.safeRemoveT(nodeChild,"node_comment"..nIdx)
		end
	end

	_CODE_CreateCommentUI = function(nIdx,nCommentId)
		--print("_CODE_CreateCommentUI",nIdx,nCommentId)
		local totalH = 0
		if nCommentId then
			local node = _childUI["node"]
			local tUIData = _tCommentUIManage.UIData
			local tCache = CommentManage.GetCache(_nCommentType,_nCommentTypeId)
			local tData = tCache.Data[nCommentId] or {}
			--table_print(tData)
			local showy = 0
			if tUIData[nIdx] then
				showy = tUIData[nIdx].y
				tUIData[nIdx].buttonList = {}
			else
				tUIData[nIdx] = {}
				tUIData[nIdx].buttonList = {}
				if tUIData[nIdx - 1] then
					showy = tUIData[nIdx - 1].y - tUIData[nIdx - 1].h
				end
			end
			tUIData[nIdx].y = showy
			--print("showy",showy)
			if node then
				local nodeChild = node.childUI
				local nodeParent = node.handle._n

				local canComment = true
				local showConfig = tData.showConfig
				local iconConfig = nil 
				local titleConfig = {}
				local contentConfig = {}
				if type(showConfig) == "table" then
					canComment = false
					iconConfig = showConfig.tIcon or nil
					titleConfig = showConfig.tTitle or {}
					contentConfig = showConfig.tContent or {}
				end

				nodeChild["node_comment"..nIdx] = hUI.button:new({
					parent = nodeParent,
					x = 0 + _tClippingRect[1],
					y = showy + _tClippingRect[2],
					model = "",
					w = 1,
					h = 1,
				})

				local commentNode = nodeChild["node_comment"..nIdx]

				if type(tData.model) == "table" then
					if type(iconConfig) == "table" then
						commentNode.childUI["img_icon"] = hUI.button:new({
							parent = commentNode.handle._n,
							model = "misc/button_null.png",
							model = "misc/mask.png",
							x = 64 + (iconConfig.x or 0),
							y = -40 + (iconConfig.y or 0),
							w = 10,
							h = 10,
							scale = iconConfig.scale or 1
						})
					else
						commentNode.childUI["img_icon"] = hUI.button:new({
							parent = commentNode.handle._n,
							x = 64,
							y = -40,
							model = "misc/button_null.png",
							model = "misc/mask.png",
							w = 10,
							h = 10,
						})
					end

					local stype,id = unpack(tData.model)
					--print()
					if stype ==  "tank_avater" then
						_CODE_CreateTankAvater(id,commentNode.childUI["img_icon"])
					end
				else
					if type(iconConfig) == "table" then
						commentNode.childUI["img_icon"] = hUI.image:new({
							parent = commentNode.handle._n,
							x = 64 + (iconConfig.x or 0),
							y = -40 + (iconConfig.y or 0),
							model = tData.icon,
							scale = iconConfig.scale or 1
						})
					else
						commentNode.childUI["img_icon"] = hUI.image:new({
							parent = commentNode.handle._n,
							x = 64,
							y = -40,
							model = tData.icon,
							w = _ICON_WH,
							h = _ICON_WH,
						})
					end
				end

				commentNode.childUI["lab_name"] = hUI.label:new({
					parent = commentNode.handle._n,
					x = 124 + (titleConfig.x or 0),
					y = - 18 + (titleConfig.y or 0),
					font = hVar.FONTC,
					size = titleConfig.size or 28,
					align = "LC",
					text = tData.name,
					border = 1,
					RGB = {255, 255, 0},
				})

				if canComment then
					commentNode.childUI["btn_zan"] = hUI.button:new({
						parent = commentNode.handle._n,
						x = _tClippingRect[3] - 54,
						y = - 18,
						model = "misc/button_null.png",
						w = 80,
						h = 30,
						code = function()
							print("zan",nCommentId)
							CommentManage.DoLikeComment(1,nCommentId)
						end,
					})
					local btnx = commentNode.childUI["btn_zan"].data.x - commentNode.childUI["btn_zan"].data.w/2
					local btny = commentNode.childUI["btn_zan"].data.y + commentNode.childUI["btn_zan"].data.h/2
					tUIData[nIdx].buttonList["btn_zan"] = {btnx,btny,commentNode.childUI["btn_zan"].data.w,commentNode.childUI["btn_zan"].data.h}

					commentNode.childUI["img_zan"] = hUI.image:new({
						parent = commentNode.handle._n,
						model = "misc/zan.png",
						x = _tClippingRect[3] - 42,
						y = - 18,
						w = 30,
						h = 30,
					})

					commentNode.childUI["lab_zan"] = hUI.label:new({
						parent = commentNode.handle._n,
						x = _tClippingRect[3] - 44 - 20,
						y = - 18,
						font = hVar.FONTC,
						size = 26,
						align = "RC",
						text = tData.star,
						border = 1,
					})

					commentNode.childUI["btn_reply"] = hUI.button:new({
						parent = commentNode.handle._n,
						x = _tClippingRect[3] - 44 - 14,
						y = - 60,
						model = "misc/button_null.png",
						w = 80,
						h = 42,
						code = function()
							print("reply",nCommentId)
							_CODE_ReplySubComment(nCommentId)
						end,
					})
					local btnx = commentNode.childUI["btn_reply"].data.x - commentNode.childUI["btn_reply"].data.w/2
					local btny = commentNode.childUI["btn_reply"].data.y + commentNode.childUI["btn_reply"].data.h/2
					tUIData[nIdx].buttonList["btn_reply"] = {btnx,btny,commentNode.childUI["btn_reply"].data.w,commentNode.childUI["btn_reply"].data.h}


					commentNode.childUI["img_reply"] = hUI.image:new({
						parent = commentNode.handle._n,
						model = "misc/addition/reply_button.png",
						x = _tClippingRect[3] - 44 - 14,
						y = - 58,
						w = 54,
						h = 36,
					})
				end

				commentNode.childUI["lab_comment"] = hUI.label:new({
					parent = commentNode.handle._n,
					x = 124 + (contentConfig.x or 0),
					y = - 42 + (contentConfig.y or 0),
					font = hVar.FONTC,
					size = contentConfig.size or 26,
					align = "LT",
					text = tData.str,
					width = _COMMENT_SHOWWIDTH,
					border = 1,
				})
				local _,lh = commentNode.childUI["lab_comment"]:getWH()
				local curY = math.min(-76,commentNode.childUI["lab_comment"].data.y - lh)

				local subCount = tData.subCount
				local subTotal = tData.subTotal
				--print(subCount,subTotal)

				tUIData[nIdx].commentId = nCommentId
				tUIData[nIdx].curmaxsub = subCount
				tUIData[nIdx].totalsub = subTotal
				tUIData[nIdx].subStartY = curY
				if subCount and subCount > 0 then
					local tParamCache = tUIData[nIdx].cache
					if tParamCache then
						curY = _CODE_SwitchSubCommentShow(tParamCache.mode,nIdx,curY,tParamCache.param,false)
					else
						curY = _CODE_SwitchSubCommentShow("mini",nIdx,curY,nil,false)
					end
				end

				commentNode.childUI["img_line"] = hUI.bar:new({
					parent = commentNode.handle._n,
					model = "UI:BAR_sepline",
					x = _tClippingRect[3] / 2,
					y = curY - _LINE_OFF_H,
					w = _tClippingRect[3],
					h = 2,
				})

				--print(nIdx,tUIData[nIdx].h)
				tUIData[nIdx].h = - curY + _LINE_OFF_H * 2
				totalH = -curY + _LINE_OFF_H * 2
			end
		end
		return totalH
	end

	_CODE_SwitchSubCommentShow = function(sMode,nIdx,offY,tParam,bRefreshUI)
		local newY = offY or 0
		--重建subUI并移动其他评论坐标
		local tUIData = _tCommentUIManage.UIData
		local node = _childUI["node"]
		if tUIData[nIdx] and node then
			tUIData[nIdx].cache = {
				mode = sMode,
				param = tParam,
			}
			local nodeChild = node.childUI
			local commentNode = nodeChild["node_comment"..nIdx]
			local nCommentId = tUIData[nIdx].commentId
			local nSubCount = tUIData[nIdx].curmaxsub
			local nTotalsub = tUIData[nIdx].totalsub
			local nSubH = tUIData[nIdx].h_sub or 0
			local nSubStartY = tUIData[nIdx].subStartY or 0
			if offY == nil and nSubStartY then
				newY = nSubStartY
			end
			local lastY = newY
			local maxPage = math.floor((nTotalsub-1) / _SUBCOMMENTPAGE_MAXSHOW) + 1
			local canShowPage = math.floor(nSubCount / _SUBCOMMENTPAGE_MAXSHOW)
			local curpage = tUIData[nIdx].page
			--print(nSubCount,maxPage,canShowPage)
			if sMode == "mini" then
				local shownum = math.min(nSubCount,_DEFAULT_SUBCOMMENT_NUM)
				tUIData[nIdx].page = 1
				newY = _CODE_CreateSubCommentUI(nIdx,commentNode,lastY,nCommentId,1,shownum,nTotalsub)
			elseif sMode == "page" then
				local shownum = _SUBCOMMENTPAGE_MAXSHOW
				local nPage = tParam.page
				if nPage > maxPage then
					return
				end
				tUIData[nIdx].page = nPage
				if nPage > canShowPage then
					if not(nPage == maxPage and nSubCount == nTotalsub) then
						--获取子评论
						CommentManage.RequireSubCommentData(_nCommentType,_nCommentTypeId,nCommentId,(nPage - 1)*_SUBCOMMENTPAGE_MAXSHOW)
					end
				end
				if nPage == maxPage then
					shownum = (nTotalsub - 1) % _SUBCOMMENTPAGE_MAXSHOW + 1
				end
				
				newY = _CODE_CreateSubCommentUI(nIdx,commentNode,lastY,nCommentId,nPage,shownum,nTotalsub)
			elseif sMode == "page_up" then
				local nPage = curpage + 1
				if nPage > maxPage then
					return
				end
				tUIData[nIdx].page = nPage
				local shownum = _SUBCOMMENTPAGE_MAXSHOW
				if nPage > canShowPage then
					if not(nPage == maxPage and nSubCount == nTotalsub) then
						--获取子评论
						CommentManage.RequireSubCommentData(_nCommentType,_nCommentTypeId,nCommentId,(nPage - 1)*_SUBCOMMENTPAGE_MAXSHOW)
					end
				end
				if nPage == maxPage then
					shownum = (nTotalsub - 1) % _SUBCOMMENTPAGE_MAXSHOW + 1
				end
				newY = _CODE_CreateSubCommentUI(nIdx,commentNode,lastY,nCommentId,nPage,shownum,nTotalsub)
			elseif sMode == "page_down" then
				local nPage = curpage - 1
				if nPage < 1 then
					return
				end
				local shownum = _SUBCOMMENTPAGE_MAXSHOW
				newY = _CODE_CreateSubCommentUI(nIdx,commentNode,lastY,nCommentId,nPage,shownum,nTotalsub)
				tUIData[nIdx].page = nPage
			elseif sMode == "all" then
				local shownum = math.min(nSubCount,_SUBCOMMENTPAGE_MAXSHOW)
				tUIData[nIdx].page = 1
				if nSubCount == _SUBCOMMENTPAGE_MAXSHOW then
					--获取子评论
					CommentManage.RequireSubCommentData(_nCommentType,_nCommentTypeId,nCommentId,nSubCount + 1)
				end
				newY = _CODE_CreateSubCommentUI(nIdx,commentNode,lastY,nCommentId,1,shownum,nTotalsub)
			end
			local subUI_h = lastY - newY
			local oldSubH = tUIData[nIdx].h_sub or 0
			tUIData[nIdx].h_sub = subUI_h
			--print("tUIData[nIdx].h",tUIData[nIdx].h)
			tUIData[nIdx].h = -nSubStartY + subUI_h + _LINE_OFF_H * 2
			--print(subUI_h,nSubStartY,tUIData[nIdx].h)
			if bRefreshUI then
				local tData = _tCommentUIManage.Data
				tData.shouldRefresh = true
				local _commentNode = nodeChild["node_comment"..nIdx]
				hUI.uiSetXY(_commentNode.childUI["img_line"], _commentNode.childUI["img_line"].data.x, newY - _LINE_OFF_H)
				_CODE_UpdateCommentShow()
--				local nY = tUIData[nIdx].y - tUIData[nIdx].h
--				for i = nIdx,#tUIData do
--					local t = tUIData[i]
--					if t then
--						local _commentNode = nodeChild["node_comment"..i]
--						if _commentNode then
--							if i == nIdx then
--								hUI.uiSetXY(_commentNode.childUI["img_line"], _commentNode.childUI["img_line"].data.x, newY - _LINE_OFF_H)
--							else
--								hUI.uiSetXY(_commentNode, _commentNode.data.x, nY + _tClippingRect[2])
--								t.y = nY
--								nY = nY - t.h
--							end
--						end
--					end
--				end
--				local tData = _tCommentUIManage.Data
--				tData.totalH = tData.totalH + subUI_h - oldSubH
--				tData.endShowH = tData.endShowH + subUI_h - oldSubH
--				local gh = math.max(0,tData.totalH - _tClippingRect[4])
--				_tDragRect = {0, gh, 0, math.max(1, gh)}
			end
		end
		return newY
	end

	_CODE_CreateSubCommentUI = function(nIdx,commentNode,offY,nCommentId,nPage,shownum,subTotal)
		print("_CODE_CreateSubCommentUI",nCommentId)
		hApi.safeRemoveT(commentNode.childUI,"node_subcomment")
		local curY = offY - 30
		commentNode.childUI["node_subcomment"] = hUI.button:new({
			parent = commentNode.handle._n,
			x = 122,
			y = curY,
			model = "",
			w = 1,
			h = 1,
		})

		local subtotalH = 0
		local tCache = CommentManage.GetCache(_nCommentType,_nCommentTypeId)
		local tSubIdx = tCache.tSubShowIdx[nCommentId] or {}
		local tUIData = _tCommentUIManage.UIData
		tUIData[nIdx].subbuttonList = {}
		--table_print(tSubIdx)
		print("shownum",shownum)
		for i = 1,shownum do
			local realIdx = _SUBCOMMENTPAGE_MAXSHOW * (nPage - 1) + i
			local subId = tSubIdx[realIdx] or 0
			if subId then
				local _nH = _CODE_CreateSubComment(commentNode.childUI["node_subcomment"],realIdx,subId,-subtotalH,nCommentId)
				if commentNode.childUI["node_subcomment"].childUI["btn_zan"..realIdx] then
					local btnx = commentNode.childUI["node_subcomment"].data.x + commentNode.childUI["node_subcomment"].childUI["btn_zan"..realIdx].data.x - commentNode.childUI["node_subcomment"].childUI["btn_zan"..realIdx].data.w/2
					local btny = commentNode.childUI["node_subcomment"].data.y + commentNode.childUI["node_subcomment"].childUI["btn_zan"..realIdx].data.y + commentNode.childUI["node_subcomment"].childUI["btn_zan"..realIdx].data.h/2
					tUIData[nIdx].subbuttonList["btn_zan"..realIdx] = {btnx,btny,commentNode.childUI["node_subcomment"].childUI["btn_zan"..realIdx].data.w,commentNode.childUI["node_subcomment"].childUI["btn_zan"..realIdx].data.h}
				end
				subtotalH = subtotalH + _nH
			end
		end

		local maxPage = math.floor((subTotal-1) / _SUBCOMMENTPAGE_MAXSHOW) + 1
		local pagemaxshow = math.min(subTotal,_SUBCOMMENTPAGE_MAXSHOW)
		if nPage == 1 and shownum <= _DEFAULT_SUBCOMMENT_NUM then
			if subTotal <= shownum then
			elseif shownum < pagemaxshow then
				commentNode.childUI["node_subcomment"].childUI["lab_total"] = hUI.label:new({
					parent = commentNode.childUI["node_subcomment"].handle._n,
					y = - subtotalH - 12,
					x = 0,
					align = "LC",
					font = hVar.FONTC,
					size = 22,
					text = "总计"..tostring(subTotal).."条评论",
					border = 1,
					RGB = {100, 180, 250},
				})
				subtotalH = subtotalH + 24

				commentNode.childUI["node_subcomment"].childUI["btn_showallsub"] = hUI.button:new({
					parent = commentNode.childUI["node_subcomment"].handle._n,
					model = "misc/button_null.png",
					y = - subtotalH - 12 + 22,
					x = 0 + 100,
					w = 200,
					h = 50,
					code = function()
						print("showallsub",nIdx)
						_CODE_SwitchSubCommentShow("all",nIdx,nil,nil,true)
					end,
				})
				local btnx = commentNode.childUI["node_subcomment"].data.x + commentNode.childUI["node_subcomment"].childUI["btn_showallsub"].data.x - commentNode.childUI["node_subcomment"].childUI["btn_showallsub"].data.w/2
				local btny = commentNode.childUI["node_subcomment"].data.y + commentNode.childUI["node_subcomment"].childUI["btn_showallsub"].data.y + commentNode.childUI["node_subcomment"].childUI["btn_showallsub"].data.h/2
				tUIData[nIdx].subbuttonList["btn_showallsub"] = {btnx,btny,commentNode.childUI["node_subcomment"].childUI["btn_showallsub"].data.w,commentNode.childUI["node_subcomment"].childUI["btn_showallsub"].data.h}
			end
		else
			local showmaxpage = 6
			local showlist = {}
			if maxPage < showmaxpage then
				for i = 1,maxPage do
					showlist[i] = i
				end
			else
				local _idx = 0
				if nPage <= 4 then
					for i = 1,showmaxpage - 1 do
						_idx = i
						showlist[_idx] = i
					end
					_idx = _idx + 1
					showlist[_idx] = ".."
					_idx = _idx + 1
					showlist[_idx] = maxPage
				elseif nPage > maxPage - showmaxpage + 2 then
					showlist[1] = 1
					showlist[2] = ".."
					_idx = 2
					for i = 1,showmaxpage - 1 do
						showlist[_idx + i] = maxPage - showmaxpage + 1 + i
					end
				else
					
					showlist[1] = 1
					showlist[2] = ".."
					_idx = 2
					for i = 1,showmaxpage - 2 do
						showlist[_idx + i] = nPage + i - 2
					end
					_idx = _idx + showmaxpage - 1
					showlist[_idx] = ".."
					_idx = _idx + 1
					showlist[_idx] = maxPage
				end
			end

			commentNode.childUI["node_subcomment"].childUI["btn_page_down"] = hUI.button:new({
				parent = commentNode.childUI["node_subcomment"].handle._n,
				model = "misc/button_null.png",
				y = - subtotalH - 14,
				x = 14,
				scaleT = 0.92,
				w = 40,
				h = 50,
				code = function()
					print("page_down",nIdx)
					_CODE_SwitchSubCommentShow("page_down",nIdx,nil,nil,true)
				end,
			})
			local btnx = commentNode.childUI["node_subcomment"].data.x + commentNode.childUI["node_subcomment"].childUI["btn_page_down"].data.x - commentNode.childUI["node_subcomment"].childUI["btn_page_down"].data.w/2
			local btny = commentNode.childUI["node_subcomment"].data.y + commentNode.childUI["node_subcomment"].childUI["btn_page_down"].data.y + commentNode.childUI["node_subcomment"].childUI["btn_page_down"].data.h/2
			tUIData[nIdx].subbuttonList["btn_page_down"] = {btnx,btny,commentNode.childUI["node_subcomment"].childUI["btn_page_down"].data.w,commentNode.childUI["node_subcomment"].childUI["btn_page_down"].data.h}
			commentNode.childUI["node_subcomment"].childUI["btn_page_down"].childUI["img"] = hUI.image:new({
				parent = commentNode.childUI["node_subcomment"].childUI["btn_page_down"].handle._n,
				model = "misc/chariotconfig/next_r.png",
				scale = 0.7,
			})
			commentNode.childUI["node_subcomment"].childUI["btn_page_down"].childUI["img"].handle.s:setFlipX(true)

			local sx = 40
			--table_print(showlist)
			for i = 1,#showlist do
				local param = showlist[i]
				if type(param) == "number" then
					sx = sx + 15
					local rgb = {255, 255, 255}
					if nPage == param then
						rgb = {100, 180, 250}
					end
					--tUIData[nIdx].subbuttonList
					commentNode.childUI["node_subcomment"].childUI["btn_page"..i] = hUI.button:new({
						parent = commentNode.childUI["node_subcomment"].handle._n,
						y = - subtotalH - 13,
						x = sx,
						model = "misc/button_null.png",
						w = 40,
						h = 50,
						code = function()
							print("page",nIdx,param)
							_CODE_SwitchSubCommentShow("page",nIdx,nil,{["page"] = param},true)
						end
					})
					local btnx = commentNode.childUI["node_subcomment"].data.x + commentNode.childUI["node_subcomment"].childUI["btn_page"..i].data.x - commentNode.childUI["node_subcomment"].childUI["btn_page"..i].data.w/2
					local btny = commentNode.childUI["node_subcomment"].data.y + commentNode.childUI["node_subcomment"].childUI["btn_page"..i].data.y + commentNode.childUI["node_subcomment"].childUI["btn_page"..i].data.h/2
					tUIData[nIdx].subbuttonList["btn_page"..i] = {btnx,btny,commentNode.childUI["node_subcomment"].childUI["btn_page"..i].data.w,commentNode.childUI["node_subcomment"].childUI["btn_page"..i].data.h}


					commentNode.childUI["node_subcomment"].childUI["lab_page"..i] = hUI.label:new({
						parent = commentNode.childUI["node_subcomment"].handle._n,
						y = - subtotalH - 13,
						x = sx,
						align = "MC",
						font = hVar.FONTC,
						size = 22,
						text = tostring(param),
						border = 1,
						RGB = rgb,
					})
					local _lw = commentNode.childUI["node_subcomment"].childUI["lab_page"..i]:getWH()
					sx = sx + _lw + 15
				else
					sx = sx + 4
					commentNode.childUI["node_subcomment"].childUI["lab_page"..i] = hUI.label:new({
						parent = commentNode.childUI["node_subcomment"].handle._n,
						y = - subtotalH - 13,
						x = sx - 10,
						align = "MC",
						font = hVar.FONTC,
						size = 22,
						text = tostring(param),
						border = 1,
					})
					sx = sx + 4
				end
			end

			commentNode.childUI["node_subcomment"].childUI["btn_page_up"] = hUI.button:new({
				parent = commentNode.childUI["node_subcomment"].handle._n,
				model = "misc/button_null.png",
				y = - subtotalH - 14,
				x = sx + 12,
				scaleT = 0.92,
				w = 40,
				h = 50,
				code = function()
					print("page_up",nIdx)
					_CODE_SwitchSubCommentShow("page_up",nIdx,nil,nil,true)
				end,
			})
			commentNode.childUI["node_subcomment"].childUI["btn_page_up"].childUI["img"] = hUI.image:new({
				parent = commentNode.childUI["node_subcomment"].childUI["btn_page_up"].handle._n,
				model = "misc/chariotconfig/next_r.png",
				scale = 0.7,
			})
			local btnx = commentNode.childUI["node_subcomment"].data.x + commentNode.childUI["node_subcomment"].childUI["btn_page_up"].data.x - commentNode.childUI["node_subcomment"].childUI["btn_page_up"].data.w/2
			local btny = commentNode.childUI["node_subcomment"].data.y + commentNode.childUI["node_subcomment"].childUI["btn_page_up"].data.y + commentNode.childUI["node_subcomment"].childUI["btn_page_up"].data.h/2
			tUIData[nIdx].subbuttonList["btn_page_up"] = {btnx,btny,commentNode.childUI["node_subcomment"].childUI["btn_page_up"].data.w,commentNode.childUI["node_subcomment"].childUI["btn_page_up"].data.h}

			commentNode.childUI["node_subcomment"].childUI["btn_putaway"] = hUI.button:new({
				parent = commentNode.childUI["node_subcomment"].handle._n,
				y = - subtotalH - 14,
				x = _SUBCOMMENT_SHOWWIDTH - 22,
				model = "misc/button_null.png",
				w = 60,
				h = 50,
				code = function()
					print("putaway",nIdx)
					_CODE_SwitchSubCommentShow("mini",nIdx,nil,nil,true)
				end
			})
			local btnx = commentNode.childUI["node_subcomment"].data.x + commentNode.childUI["node_subcomment"].childUI["btn_putaway"].data.x - commentNode.childUI["node_subcomment"].childUI["btn_putaway"].data.w/2
			local btny = commentNode.childUI["node_subcomment"].data.y + commentNode.childUI["node_subcomment"].childUI["btn_putaway"].data.y + commentNode.childUI["node_subcomment"].childUI["btn_putaway"].data.h/2
			tUIData[nIdx].subbuttonList["btn_putaway"] = {btnx,btny,commentNode.childUI["node_subcomment"].childUI["btn_putaway"].data.w,commentNode.childUI["node_subcomment"].childUI["btn_putaway"].data.h}

			
			commentNode.childUI["node_subcomment"].childUI["lab_putaway"] = hUI.label:new({
				parent = commentNode.childUI["node_subcomment"].handle._n,
				y = - subtotalH - 12,
				x = _SUBCOMMENT_SHOWWIDTH,
				align = "RC",
				font = hVar.FONTC,
				size = 22,
				text = hVar.tab_string["__TEXT_collapse"],
				border = 1,
				RGB = {100, 180, 250},
			})

			subtotalH = subtotalH + 24
		end
		curY = curY - 24
		local s9 = hApi.CCScale9SpriteCreate("data/image/misc/billboard/bg_ng_graywhite.png", _SUBCOMMENT_SHOWWIDTH/2, -subtotalH/2 - 2, _SUBCOMMENT_SHOWWIDTH + 36, subtotalH + 30, commentNode.childUI["node_subcomment"],-1)
		s9:setOpacity(30)
		curY = curY - subtotalH
		return curY
	end

	_CODE_CreateSubComment = function(subNode,idx,subId,offy,commentId)
		print("_CODE_CreateSubComment",idx,subId)
		local totalH = 0
		local tData = CommentManage.GetCommentCache(_nCommentType,_nCommentTypeId,subId)
		if subId == 0 then
			tData = {}
		end
		if subNode and tData then
			subNode.childUI["lab_name"..idx] = hUI.label:new({
				parent = subNode.handle._n,
				x = 0,
				y = - 16 + offy,
				font = hVar.FONTC,
				size = 24,
				align = "LC",
				text = tData.name or "",
				border = 1,
				RGB = {255, 255, 0},
			})
			local _lw1,_lh1 = subNode.childUI["lab_name"..idx]:getWH()
			local spacestr = "    "
			for i = 1,math.floor(_lw1 / 26) do
				spacestr = spacestr .. "    "
			end
			local str = spacestr .. (tData.str or "") --.."_"..idx.."|"..subId--"测试一下是否真1的可以换行并且显示很正常间距到底有多少"
			--str = str .. "测试一下看看换行显示在哪"

			subNode.childUI["lab_comment"..idx] = hUI.label:new({
				parent = subNode.handle._n,
				x = 0,
				y = - 3 + offy,
				width = _SUBCOMMENT_SHOWWIDTH - 50,
				font = hVar.FONTC,
				size = 24,
				align = "LT",
				text = str,
				border = 1,
			})

			if subId ~= 0 then
				subNode.childUI["btn_zan"..idx] = hUI.button:new({
					parent = subNode.handle._n,
					x =  _SUBCOMMENT_SHOWWIDTH - 20,
					y = - 18 + offy,
					model = "misc/button_null.png",
					--model = "misc/mask.png",
					w = 50,
					h = 24,
					code = function()
						print("zan",subId)
						CommentManage.DoLikeComment(2,subId,{_nCommentType,_nCommentTypeId,commentId})
					end,
				})

				subNode.childUI["img_zan"..idx] = hUI.image:new({
					parent = subNode.handle._n,
					model = "misc/zan.png",
					x =  _SUBCOMMENT_SHOWWIDTH - 8,
					y = - 18 + offy,
					w = 24,
					h = 24,
				})

				subNode.childUI["lab_zan"..idx] = hUI.label:new({
					parent = subNode.handle._n,
					x =  _SUBCOMMENT_SHOWWIDTH - 24,
					y = - 16 + offy,
					font = hVar.FONTC,
					size = 24,
					align = "RC",
					text = tData.star,
					border = 1,
				})
			end

			local _,_lh2 = subNode.childUI["lab_comment"..idx]:getWH()
			totalH = math.max(_lh1,_lh2) + 12
		end
		return totalH
	end

	_CODE_RefreshUIXY = function()
		local tUIData = _tCommentUIManage.UIData
		local node = _childUI["node"]		
		if tUIData and node then
			local nodeChild = node.childUI
			local nY = tUIData[1].y - tUIData[1].h
			for i = 2,#tUIData do
				local t = tUIData[i]
				if t then
					local _commentNode = nodeChild["node_comment"..i]
					if _commentNode then
						hUI.uiSetXY(_commentNode, _commentNode.data.x, nY + _tClippingRect[2])
					end
					t.y = nY
					nY = nY - t.h
				end
			end
			local tData = _tCommentUIManage.Data
			tData.totalH = -nY
			tData.endShowH = math.max(tData.totalH,tData.endShowH)
			local gh = math.max(0,tData.totalH - _tClippingRect[4])
			_tDragRect = {0, gh, 0, math.max(1, gh)}
		end
	end

	_CODE_UpdateCommentShow = function()
		--print("_CODE_UpdateCommentShow")
		local tData = _tCommentUIManage.Data
		if tData.shouldRefresh == true then
			_CODE_RefreshUIXY()
			tData.shouldRefresh = false
		end
		local tUIData = _tCommentUIManage.UIData
		local tShowIdx = _tCommentUIManage.tShowIdx
		local maxNum = #tShowIdx
		if tData.curShowH - tData.startShowH > _LIMIT_COMMENT_SHOW_MAXHEIGHT then --上方显示过多 需要删除
			local newIdx = tData.startIdx
			
			
			for i = tData.startIdx,tData.endIdx do
				tData.startShowH = -tUIData[i].y
				if tData.curShowH - tData.startShowH < _LIMIT_COMMENT_SHOW_MAXHEIGHT then
					--重新赋值
					newIdx = i
					break
				end
				_CODE_RemoveCommentUI(i,tShowIdx[i])
			end
			--print(tData.startShowH,newIdx,tData.startIdx)
			if tData.startIdx ~= newIdx then
				tData.startIdx = newIdx
			end
		elseif tData.curShowH - tData.startShowH < _LIMIT_COMMENT_SHOW_MINHEIGHT and tData.startIdx > 1 then --上方显示过少 需要补充数据
			local newIdx = tData.startIdx
			for i = tData.startIdx,1,-1 do
				local showH = _CODE_CreateCommentUI(i,tShowIdx[i])
				tData.startShowH = math.max(0,-tUIData[i].y - showH)
				--重新赋值
				newIdx = i
				if tData.curShowH - tData.startShowH > _LIMIT_COMMENT_SHOW_MAXHEIGHT then
					break
				end
			end
			if tData.startIdx ~= newIdx then
				tData.startIdx = newIdx
			end
		end
		if tData.endShowH - tData.curShowH > _LIMIT_COMMENT_SHOW_MAXHEIGHT then --下方显示过多需要删除
			local newIdx = tData.endIdx
			for i = tData.endIdx,tData.startIdx,-1 do
				tData.endShowH = -tUIData[i].y + tUIData[i].h
				if tData.endShowH - tData.curShowH < _LIMIT_COMMENT_SHOW_MAXHEIGHT then
					--重新赋值
					newIdx = i
					break
				end
				_CODE_RemoveCommentUI(i,tShowIdx[i])
			end
			if tData.endIdx ~= newIdx then
				tData.endIdx = newIdx
			end
		elseif tData.endShowH - tData.curShowH < _LIMIT_COMMENT_SHOW_MINHEIGHT and tData.endIdx < maxNum then --下方显示过少 需要补充数据
			local newIdx = tData.endIdx
			for i = tData.endIdx + 1,maxNum do
				--print("end_down",i,maxNum)
				if tData.endShowH - tData.curShowH > _LIMIT_COMMENT_SHOW_MINHEIGHT then
					break
				end
				local showH = _CODE_CreateCommentUI(i,tShowIdx[i])
				if showH > 0 then
					newIdx = i
					tData.endShowH = -tUIData[i].y + tUIData[i].h
				end
			end
			if tData.endIdx ~= newIdx then
				tData.endIdx = newIdx
			end
			if tData.endShowH > tData.totalH then
				tData.totalH = tData.endShowH
			end
		end
		local gh = math.max(0,tData.totalH - _tClippingRect[4])
		_tDragRect = {0, gh, 0, math.max(1, gh)}
		_CODE_UpdateTestInfo()
	end

	_CODE_UpdateCommentInfo = function()
		hApi.clearTimer("RequireCommentDataFail")
		local tCache = CommentManage.GetCache(_nCommentType,_nCommentTypeId)
		if tCache and tCache.tShowIdx and tCache.tShowIdx[_nSortingRules] then
			local tCacheShowIdx = tCache.tShowIdx[_nSortingRules]
			local tShowIdx = _tCommentUIManage.tShowIdx
			local startIdx = #tShowIdx + 1
			for i = startIdx,#tCacheShowIdx do
				tShowIdx[i] = tCacheShowIdx[i]
			end
		end
		_bCanDrag = true
		if _childUI["node"] and _childUI["node"].childUI["effect_waiting"] then
			_childUI["node"].childUI["effect_waiting"].handle._n:setVisible(false)
		end
	end

	_CODE_UpdateCommentStar = function(nCommentType,nCommentTypeId,nCommentID,nStarCount)
		print("_CODE_UpdateCommentStar",nCommentType,nCommentTypeId,nCommentID,nStarCount)
		if _nCommentType == nCommentType and _nCommentTypeId == nCommentTypeId then
			local tShowIdx = _tCommentUIManage.tShowIdx
			for nIdx = 1,#tShowIdx do
				local commentId = tShowIdx[nIdx]
				if commentId == nCommentID then
					local node = _childUI["node"]
					local nodeChild = node.childUI
					local commentNode = nodeChild["node_comment"..nIdx]
					if commentNode and commentNode.childUI["lab_zan"] then
						commentNode.childUI["lab_zan"]:setText(nStarCount)
					end
				end
			end
		end
	end

	_CODE_UpdateSubCommentStar = function(nCommentType,nCommentTypeId,nCommentID,nSubCommentID,nStarCount)
		if _nCommentType == nCommentType and _nCommentTypeId == nCommentTypeId then
			local tShowIdx = _tCommentUIManage.tShowIdx
			for nIdx = 1,#tShowIdx do
				local commentId = tShowIdx[nIdx]
				if commentId == nCommentID then
					local tCache = CommentManage.GetCache(_nCommentType,_nCommentTypeId)
					local tSubIdx = tCache.tSubShowIdx[nCommentID] or {}
					local node = _childUI["node"]
					local nodeChild = node.childUI
					local commentNode = nodeChild["node_comment"..nIdx]
					if commentNode and tSubIdx then
						for realIdx = 1,#tSubIdx do
							local subID = tSubIdx[realIdx]
							--print("realIdx",realIdx,nSubCommentID,subID,nStarCount)
							if nSubCommentID == subID then
								--print("aaaaaa")
								if commentNode.childUI["node_subcomment"] and commentNode.childUI["node_subcomment"].childUI["lab_zan"..realIdx] then
									commentNode.childUI["node_subcomment"].childUI["lab_zan"..realIdx]:setText(nStarCount)
								end
								
							end
						end
					end
				end
			end
		end
	end

	_CODE_EnterBackground = function()
		_CODE_CloseFunc()
	end

	_CODE_UpdateCommentTitle = function(sTitle,nMode,nCommentType,nCommentTypeId)
		if _nCommentType == nCommentType and _nCommentTypeId == nCommentTypeId then
			if _sCommentTitle == "" then
				_sCommentTitle = sTitle
				_childUI["titleText"]:setText(sTitle)
			end
			--判断是否是特殊标题
			local bFlag,tConfig = CommentManage.IsSpecialCommentTitle(nCommentType,nCommentTypeId)
			if bFlag then
				_childUI["titleText"]:setText("")
				_CODE_CreateSpecialTitle(tConfig)
			end
			_nCommentShowMode = nMode
			_CODE_CreateCommentBtnFrm()
		end
	end

	_CODE_RequireCommentDataFail = function()
		local strText = hVar.tab_string["try_again_later"]
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 2000,
			fadeout = -550,
			moveY = 32,
		}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)

		if _childUI["node"] and _childUI["node"].childUI["effect_waiting"] then
			_childUI["node"].childUI["effect_waiting"].handle._n:setVisible(false)
		end

		local finaly = _tDragRect[2]
		_CODE_AutoLign(finaly)
	end

	_CODE_CheckLoadMore = function(tPickParam)
		--print("_CODE_CheckLoadMore")
		--print(tPickParam.loadmode)
		local showload = 0
		local loadmode = tPickParam.loadmode
		if loadmode == 1 then
			local tCache = CommentManage.GetCache(_nCommentType,_nCommentTypeId)
			if tCache then
				local totalNum = tCache.totalCommentNum
				if tCache.tShowIdx and tCache.tShowIdx[_nSortingRules] then
					local tCacheShowIdx = tCache.tShowIdx[_nSortingRules]
					if #tCacheShowIdx < totalNum then
						showload = 1
						_childUI["node"].childUI["effect_waiting"].handle._n:setVisible(true)
						_childUI["node"].childUI["node_loadmore"]:setstate(-1)
						hApi.addTimerOnce("RequireCommentDataFail",5000,_CODE_RequireCommentDataFail)
						CommentManage.RequireCommentData(_nCommentType,_nCommentTypeId,#tCacheShowIdx,_nSortingRules)
					end
				end
			end
		end
		return showload
	end

	_CODE_ShowLoadMore = function(tTempPos,tPickParam)
		--暂时不显示
		local node = _childUI["node"]
		local offy = tTempPos.y-tTempPos.ty + tTempPos.oy
		--print(offy,_tDragRect[2])
		if offy > _tDragRect[2] + 150 then
			local state = 0
			local tData = _tCommentUIManage.Data
			local tCache = CommentManage.GetCache(_nCommentType,_nCommentTypeId)
			if tCache then
				local totalNum = tCache.totalCommentNum
				if tCache.tShowIdx and tCache.tShowIdx[_nSortingRules] then
					local tCacheShowIdx = tCache.tShowIdx[_nSortingRules]
					if #tCacheShowIdx < totalNum then
						state = 1
					else
						state = 2
					end
				end
			end
			tPickParam.loadmode = state
			if state > 0 then
				--显示文字
				if node.childUI["node_loadmore"] then
					hUI.uiSetXY(node.childUI["node_loadmore"],  _tClippingRect[1],_tClippingRect[2] - tData.totalH - 30 )
					node.childUI["node_loadmore"]:setstate(1)
				end
				if node.childUI["effect_waiting"] then
					hUI.uiSetXY(node.childUI["effect_waiting"],  _tClippingRect[1] + _tClippingRect[3]/2,_tClippingRect[2] - tData.totalH - 40 )
				end
				if state == 1 then
					_childUI["node"].childUI["node_loadmore"].childUI["lab1"].handle._n:setVisible(true)
				elseif state == 2 then
					_childUI["node"].childUI["node_loadmore"].childUI["lab2"].handle._n:setVisible(true)
				end
			end
		else
			--隐藏
			if node.childUI["node_loadmore"] then
				node.childUI["node_loadmore"]:setstate(-1)
				_childUI["node"].childUI["node_loadmore"].childUI["lab1"].handle._n:setVisible(false)
				_childUI["node"].childUI["node_loadmore"].childUI["lab2"].handle._n:setVisible(false)
			end
		end
	end

	_CODE_AddEvent = function()
		hGlobal.event:listen("LocalEvent_SpinScreen","__Commentfrm",_CODE_DealWithSpinScreen)
		hGlobal.event:listen("LocalEvent_UpdateCommentInfo","__Commentfrm",_CODE_UpdateCommentInfo)
		hGlobal.event:listen("LocalEvent_Comment_Clean","__Commentfrm",_CODE_CloseFunc)
		hGlobal.event:listen("LocalEvent_UpdateCommentStar","__Commentfrm",_CODE_UpdateCommentStar)
		hGlobal.event:listen("LocalEvent_UpdateSubCommentStar","__Commentfrm",_CODE_UpdateSubCommentStar)
		hGlobal.event:listen("LocalEvent_UpdateSubComment","__Commentfrm",_CODE_UpdateSubComment)
		hGlobal.event:listen("LocalEvent_BeforeAddSubCommentRet","__Commentfrm",_CODE_BeforeAddSubComment)
		hGlobal.event:listen("LocalEvent_BeforeAddCommentRet","__Commentfrm",_CODE_BeforeAddComment)
		hGlobal.event:listen("LocalEvent_UpdateCommentTitle","__Commentfrm",_CODE_UpdateCommentTitle)
		hGlobal.event:listen("LocalEvent_AppEnterBackground","__Commentfrm",_CODE_EnterBackground)
	end

	_CODE_ClearEvent = function()
		hGlobal.event:listen("LocalEvent_SpinScreen","__Commentfrm",nil)
		hGlobal.event:listen("LocalEvent_UpdateCommentInfo","__Commentfrm",nil)
		hGlobal.event:listen("LocalEvent_Comment_Clean","__Commentfrm",nil)
		hGlobal.event:listen("LocalEvent_UpdateCommentStar","__Commentfrm",nil)
		hGlobal.event:listen("LocalEvent_UpdateSubCommentStar","__Commentfrm",nil)
		hGlobal.event:listen("LocalEvent_UpdateSubComment","__Commentfrm",nil)
		hGlobal.event:listen("LocalEvent_BeforeAddSubCommentRet","__Commentfrm",nil)
		hGlobal.event:listen("LocalEvent_BeforeAddCommentRet","__Commentfrm",nil)
		hGlobal.event:listen("LocalEvent_UpdateCommentTitle","__CommentManage",nil)
		hGlobal.event:listen("LocalEvent_AppEnterBackground","__Commentfrm",nil)
	end

	_CODE_BeforeAddComment = function()
		_CODE_ClearFrm()
		_CODE_GetUIConfig()
		_CODE_CreateFrm()
		_CODE_UpdateCommentInfo()
	end

	_CODE_BeforeAddSubComment = function(nCommentID)
		print("_CODE_BeforeAddSubComment",nCommentID)
		local tShowIdx = _tCommentUIManage.tShowIdx
		for nIdx = 1,#tShowIdx do
			local commentId = tShowIdx[nIdx]
			if commentId == nCommentID then
				local tUIData = _tCommentUIManage.UIData
				if tUIData and tUIData[nIdx] then
					tUIData[nIdx].curmaxsub = (tUIData[nIdx].curmaxsub or 0) + 1
					tUIData[nIdx].totalsub = (tUIData[nIdx].totalsub or 0) + 1
				end
				_CODE_SwitchSubCommentShow("page",nIdx,nil,{["page"] = 1},true)
			end
		end
		--
	end

	_CODE_UpdateSubComment = function(nCommentID,nStartIdx,nSubCount)
		print("_CODE_UpdateSubComment",nCommentID,nStartIdx)
		local tShowIdx = _tCommentUIManage.tShowIdx
		for nIdx = 1,#tShowIdx do
			local commentId = tShowIdx[nIdx]
			if commentId == nCommentID then
				local tUIData = _tCommentUIManage.UIData
				if tUIData[nIdx] then
					tUIData[nIdx].curmaxsub = nSubCount
					local curpage = tUIData[nIdx].page
					local n = (curpage - 1) * _SUBCOMMENTPAGE_MAXSHOW
					if n >= nStartIdx and n < nStartIdx + 18 then
						_CODE_SwitchSubCommentShow("page",nIdx,nil,{["page"] = curpage},true)
					end
				end
			end
		end
	end

	_CODE_EnterComment = function()
		hGlobal.event:event("LocalEvent_EnterCommentFrm",_tBoardXY,_tBoardWH,_nCommentType,_nCommentTypeId)
	end

	_CODE_ReplySubComment = function(nCommentId)
		hGlobal.event:event("LocalEvent_EnterCommentFrm",_tBoardXY,_tBoardWH,hVar.CommentTargetTypeDefine.COMMENT,nCommentId)
	end

	_CODE_HitPage = function(self,tTempPos,x,y)
		local tParam
		if hApi.IsInBox(x,y,_tClippingRect) then
			tParam = {tip = "node",state=0, nDelay=0, code=0}
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
		elseif tPickParam.state==1 then
			_CODE_ShowLoadMore(tTempPos,tPickParam)
		elseif tPickParam.state==2 then
			return 0
		end
	end

	_CODE_AutoLign = function(offy)
		local Node =_childUI["node"]
		local waittime = 0.16
		Node.handle._n:runAction(CCMoveTo:create(waittime,ccp(0,offy)))
		hApi.addTimerOnce("commentfrmAutoAlign",waittime*1000+20,function()
			hUI.uiSetXY(Node, 0,offy)
			_bCanDrag = true
		end)
	end

	_CODE_DropPage = function(self,tTempPos,tPickParam)
		local tData = _tCommentUIManage.Data
		if 0 == tPickParam.state then
			local node =_childUI["node"]
			local ex = tTempPos.x - _tClippingRect[1] - _tBoardXY[1]
			local ey = tTempPos.y- _tBoardXY[2] - _tClippingRect[2] - node.data.y
			--print(ex,ey,node.data.y)
			local tUIData = _tCommentUIManage.UIData
			--table_print(tUIData)
			local curIdx = 0
			for i = 1,#tUIData do
				local t = tUIData[i]
				if ey < t.y and ey > t.y - t.h then
					curIdx = i
					break
				end
			end

			local t = tUIData[curIdx]
			if type(t) == "table" then
				--table_print(t)
				local nodeChild = node.childUI
				local node_comment = nodeChild["node_comment"..curIdx]
				if node_comment then
					if t.buttonList then
						for btnname,tBox in pairs(t.buttonList) do
							local posx = ex
							local posy = ey - t.y
							if hApi.IsInBox(posx, posy, tBox) then
								if node_comment.childUI[btnname] then
									node_comment.childUI[btnname].data.code()
									break
								end
							end
						end
					end
					local subnode = node_comment.childUI["node_subcomment"]
					if t.subbuttonList and subnode then
						for btnname,tBox in pairs(t.subbuttonList) do
							local posx = ex
							local posy = ey - t.y
							if hApi.IsInBox(posx, posy, tBox) then
								if subnode.childUI[btnname] then
									subnode.childUI[btnname].data.code()
									break
								end
							end
						end
					end
				end
			end
			print("curIdx",curIdx)
		elseif 1 == tPickParam.state then
			local node =_childUI["node"]
			local ey = - node.data.y
			local tUIData = _tCommentUIManage.UIData
			local curIdx = 0
			for i = 1,#tUIData do
				local t = tUIData[i]
				if ey < t.y and ey > t.y - t.h then
					curIdx = i
					break
				end
			end
			_tCommentUIManage.Data.curIdx = curIdx

			local offy = tTempPos.y-tTempPos.ty + tTempPos.oy
			local finaly = offy
			local showload = 0
			if offy > _tDragRect[2] then
				_bCanDrag = false
				finaly = _tDragRect[2]
				--判断是否要加载更多
				showload = _CODE_CheckLoadMore(tPickParam)
			elseif offy < 0 then
				_bCanDrag = false
				finaly = 0
			else
				
			end
			if showload == 0 then
				if _bCanDrag == false then
					--自动对齐
					_CODE_AutoLign(finaly)
				end
				--print("finaly",finaly)
				tData.curShowH = math.floor(finaly)	
			end
		end
	end

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(nCommentType,nCommentId)
		_CODE_ClearFrm()
		_CODE_InitData(nCommentType,nCommentId)
		_CODE_GetUIConfig()
		_CODE_CreateFrm()
		_CODE_AddEvent()
	end)
end

hGlobal.UI.InitEnterCommentFrm = function(mode)
	local tInitEventName = {"LocalEvent_EnterCommentFrm", "_show",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _frm,_childUI,_parent = nil,nil,nil
	local _oEnterEditBox = nil
	local _sComment = ""
	local _nCommentType = 0
	local _nCommentTypeId = 0

	local _CODE_CreateFrm = hApi.DoNothing
	local _CODE_ClearFrm = hApi.DoNothing
	local _CODE_CloseFunc = hApi.DoNothing
	local _CODE_EditBoxTextEventHandle = hApi.DoNothing
	local _CODE_GetEditBoxText = hApi.DoNothing

	_CODE_CloseFunc = function()
		_CODE_ClearFrm()
		_nCommentType = 0
		_nCommentTypeId = 0
		hApi.RecoverScreenRotation()
	end

	_CODE_ClearFrm = function()
		--if _oEnterEditBox then
			--_oEnterEditBox:unregisterScriptEditBoxHandler()
			--_oEnterEditBox:getParent():removeChild(_oEnterEditBox,true)
		--end
		if hGlobal.UI.EnterCommentFrm then
			hGlobal.UI.EnterCommentFrm:del()
			hGlobal.UI.EnterCommentFrm = nil
		end
		_frm,_childUI,_parent = nil,nil,nil
		_oEnterEditBox = nil
		_sComment = ""
	end

	_CODE_CreateFrm = function(tBoardXY,tBoardWH)
		hGlobal.UI.EnterCommentFrm = hUI.frame:new({
			x = tBoardXY[1],
			y = tBoardXY[2],
			w = hVar.SCREEN.w,
			h = tBoardWH[2],
			background = -1,
			dragable = 0,
			show = 0,
			z = hZorder.CommentFrm + 2,
		})
		_frm = hGlobal.UI.EnterCommentFrm
		_childUI = _frm.childUI
		_parent = _frm.handle._n

		local offx = tBoardWH[1]/2
		local offy = -tBoardWH[2]/2

		_childUI["_blackpanel"] = hUI.image:new({
			parent = _parent,
			model = "UI:zhezhao",
			x = offx,
			y = offy,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
			z = -1,
		})
		_childUI["_blackpanel"].handle.s:setOpacity(200)

		_childUI["btn_send"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/chest/itembtn.png",
			x = offx - 100,
			y = offy - 60,
			w = 120,
			h = 70,
			scaleT = 0.95,
			label = {text = hVar.tab_string["__TEXT_send"],size = 24,font = hVar.FONTC, y = 2},
			code = function()
				local message = _CODE_GetEditBoxText()
				print("message",message)
				if (message ~= "") then
					CommentManage.CacheOwnComment("addcomment",{_nCommentType,_nCommentTypeId,message})
					SendCmdFunc["comment_system_add_comment"](_nCommentType,_nCommentTypeId,1, message)
					_CODE_CloseFunc()
				end
			end,
		})

		_childUI["btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/chest/itembtn.png",
			x = offx + 100,
			y = offy - 60,
			w = 120,
			h = 70,
			scaleT = 0.95,
			label = {text = hVar.tab_string["__TEXT_Close"],size = 24,font = hVar.FONTC, y = 2},
			code = function()
				_CODE_CloseFunc()
			end,
		})
		hApi.CCScale9SpriteCreate("data/image/misc/billboard/bg_ng_graywhite.png", offx, offy + 60, 480, 54, _frm)
		_oEnterEditBox = CCEditBox:create(CCSizeMake(440, 40), CCScale9Sprite:create("data/image/misc/button_null.png"))
		_oEnterEditBox:setPosition(ccp(offx, offy + 60))
		--_oEnterEditBox:setFontName("Sketch Rockwell.ttf")
		_oEnterEditBox:setFontSize(22)
		_oEnterEditBox:setFontColor(ccc3(0, 0, 0))
		_oEnterEditBox:setPlaceHolder("")--hVar.tab_string["enter_name_7_15"]
		_oEnterEditBox:setPlaceholderFontColor(ccc3(192, 192, 192))
		_oEnterEditBox:setMaxLength(128)
		_oEnterEditBox:registerScriptEditBoxHandler(_CODE_EditBoxTextEventHandle)
		_oEnterEditBox:setTouchPriority(0)
		_oEnterEditBox:setReturnType(kKeyboardReturnTypeDone)
		_parent:addChild(_oEnterEditBox)

		_frm:show(1)
		_frm:active()
	end

	_CODE_EditBoxTextEventHandle = function(strEventName, pSender)
		--local edit = tolua.cast(pSender, "CCEditBox") 
		
		if (strEventName == "began") then
			--
		elseif (strEventName == "changed") then --改变事件
			--
		elseif (strEventName == "ended") then
			_sComment = _oEnterEditBox:getText()
		elseif (strEventName == "return") then
			--
		end
		
		--print("_CODE_EditBoxTextEventHandle", strEventName, _sComment)
		--xlLG("editbox", tostring(strEventName) .. ", _sComment=" .. tostring(_sComment) .. "\n")
	end

	_CODE_GetEditBoxText = function()
		--geyachao: windows版，接收不到输入框的ended事件，只能在点击按钮的时候，取一下输入的文本
		local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
		if (g_tTargetPlatform.kTargetWindows == TargetPlatform) then --windows版
			_sComment = _oEnterEditBox:getText()
		end
		
		--检测文字是否纯为空格
		if (_sComment ~= "") then
			local bAllBlank = true
			for i = 1, #_sComment, 1 do
				local s = string.sub(_sComment, i, i)
				if (s ~= " ") then
					bAllBlank = false
					break
				end
			end
			if bAllBlank then
				--冒字
				--local strText = "聊天内容不能为空" --language
				local strText = hVar.tab_string["ios_chat_not_empty"] --language
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 2000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
				
				return
			end
		end

		if string.find(_sComment,"##") then
			local strText = hVar.tab_string["__TEXT_CanUseSpecialCharacters"]
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 2000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
			return
		end
		
		--检测输入的文字是否过长
		local nLength = hApi.GetStringEmojiENLength(_sComment) --英文长度
		if (nLength > 96) then
			--冒字
			--local strText = "您输入的内容过长" --language
			local strText = hVar.tab_string["ios_chat_too_long"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 2000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
			
			return
		end
		
		--处理文字(私聊)
		local message = _sComment

		--去除屏蔽字
		local MESSAGE = string.upper(message) --大写(用于匹配)
		local GLOBAL_FILTER_TEXT = hVar.tab_filtertext
		for i = #GLOBAL_FILTER_TEXT, 1, -1 do
			local strFilter = GLOBAL_FILTER_TEXT[i]
			local nLength = hApi.GetStringEmojiENLength(strFilter, 1, 1) --Unicode长度
			while true do
				local pos = string.find(MESSAGE, strFilter)
				if (pos ~= nil) then
					local strRep = string.rep("*", nLength)
					--message = string.gsub(message, strFilter, strRep)
					if ((pos + #strFilter - 1) < #message) then --不是最后一个字符
						message = string.sub(message, 1, pos - 1) .. strRep .. string.sub(message, (pos + #strFilter - 1) + 1, #message)
					else --最后一个字符
						message = string.sub(message, 1, pos - 1) .. strRep
					end
					
					MESSAGE = string.upper(message) --大写(用于匹配)
				else
					break
				end
			end
		end
		
		--最后转小写
		--message = string.lower(message)
		
		--清空文字
		_sComment = ""
		_oEnterEditBox:setText("")
		
		return message
	end

	hGlobal.event:listen("LocalEvent_CloseEnterCommentFrm","_closefrm",function()
		_CODE_CloseFunc()
	end)

	hGlobal.event:listen("LocalEvent_HideEnterCommentFrm","_hidefrm",function()
		if _frm then
			_frm:show(0)
			hApi.RecoverScreenRotation()
		end
	end)

	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function(tBoardXY,tBoardWH,nCommentType,nCommentTypeId)
		_CODE_ClearFrm()
		hApi.LockScreenRotation()
		_nCommentType = nCommentType
		_nCommentTypeId = nCommentTypeId
		_CODE_CreateFrm(tBoardXY,tBoardWH)
	end)
end
if true then
	return
end
local BOARD_WIDTH = 720 --面板的宽度
local BOARD_HEIGHT = 720 --面板的高度
local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 
local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2

local COMMENT_BOARD_Z_ORDER = 9001

local BOARD_COMMENT_LIST_ROOT_X = 39			--内容列表起始x位置
local BOARD_COMMENT_LIST_ROOT_Y = -80			--内容列表起始y位置

local BOARD_CONTENT_VIEW_HEIGHT = 560			--评论区高度
local BOARD_CONTENT_LINE_OFFSET_X = 100			--评论偏移x
local BOARD_CONTENT_LINE_OFFSET_Y = -100			--评论偏移y
local BOARD_CONTENT_LINE_WIDTH = 440			--单条评论宽度

local BOARD_SUB_COMMENT_NAME_OFFSET_X = 120		--子评论用户名起始x位置
local BOARD_SUB_COMMENT_NAME_OFFSET_Y = 10		--子评论用户名起始y位置
local BOARD_SUB_CONTENT_LINE_OFFSET_X = 120		--子评论偏移x
local BOARD_SUB_CONTENT_LINE_OFFSET_Y = -70		--子评论偏移y
local BOARD_SUB_CONTENT_LINE_WIDTH = 420		--单条子评论宽度

local BOARD_ROLENAME_LINE_WIDTH = 360			--角色名长度


local SPLITLINE_OFFSET_X = 330
local LIKE_BUTTON_OFFSET_X = 600				--点赞按钮偏移x
local LIKE_BUTTON_OFFSET_Y =-52					--点赞按钮偏移y
local LIKE_BUTTON_OFFSET_W = 40					--点赞按钮宽度w
local LIKE_BUTTON_OFFSET_H = 40					--点赞按钮高度h

local COMMIT_BUTTON_OFFSET_X = 570				--单条评论按钮偏移x
local COMMIT_BUTTON_OFFSET_Y = -94				--单条评论按钮偏移y
local COMMIT_BUTTON_OFFSET_W = 64		--单条评论按钮宽度w
local COMMIT_BUTTON_OFFSET_H = 40				--单条评论按钮高度h


local COMMENT_PAGE_SIZE = 10

if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL) then		--竖屏模式
	if (g_phone_mode == 1) then --iPhone4
		--
	elseif (g_phone_mode == 2) then --iPhone5
		--
	elseif (g_phone_mode == 3) then --iPhone6, iPhone7, iPhone8

	elseif (g_phone_mode == 4) then --iPhoneX
		BOARD_HEIGHT = 720
		BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 
	elseif (g_phone_mode == 5) then --安卓宽屏

	elseif (g_phone_mode == 6) then --平板宽屏

	end
else									--横屏模式
	if (g_phone_mode == 1) then --iPhone4

	elseif (g_phone_mode == 2) then --iPhone5

	elseif (g_phone_mode == 3) then --iPhone6, iPhone7, iPhone8
		BOARD_POS_X = hVar.SCREEN.w / 2 - 124
	elseif (g_phone_mode == 4) then --iPhoneX
		BOARD_POS_X = hVar.SCREEN.w / 2 + 32
	elseif (g_phone_mode == 5) then --安卓宽屏
		BOARD_POS_X = hVar.SCREEN.w / 2 - 84
	elseif (g_phone_mode == 6) then --平板宽屏
		BOARD_POS_X = hVar.SCREEN.w / 2 - 190
	end
end


--local commentData = {}
		--data = list
		--commentItem = {
		--		commentID = ,
		--		uid = ,
		--		rid = ,
		--		content = ,
		--		show = ,
		--		star = ,
		--		updateDate = ,
		--		icon = ,
		--		name = ,
		--		subComment = {} list
		--	}


local CleanSelf = hApi.DoNothing
local HideSelf = hApi.DoNothing
local ShowSelf = hApi.DoNothing
local SetCommentBtnState = hApi.DoNothing

local _commentType = 1
local _tyepID = 1

local _editCommentType = 1
local _editTyepID = 1
local _nCanDrag = 1

local CommentType2String = {
	[1] = "tab_unit",
	[2] = "tab_tactics",
}

local CommentTypeStringName = {
	[1] = "tab_stringU",
	[2] = "tab_stringT",
}


local function IsCommandString(content)
	local resultStrList = hApi.Split(content,"##")
	local isCommand,icon,name,text = false,nil,nil
	if #resultStrList > 2 then
		local itemType = tonumber(resultStrList[2])
		local itemID = tonumber(resultStrList[3])
		if CommentType2String[itemType] and hVar[CommentType2String[itemType]] and hVar[CommentType2String[itemType]][itemID] then
			icon = hVar[CommentType2String[itemType]][itemID].icon
		end
		if CommentTypeStringName[itemType] and hVar[CommentTypeStringName[itemType]] and hVar[CommentTypeStringName[itemType]][itemID] then
			name = hVar[CommentTypeStringName[itemType]][itemID][1]
		else
			name = resultStrList[3]
		end
		text = resultStrList[4]
		--print("IsCommandString")
		isCommand = true
	end
	return isCommand,icon,name,text
end

hGlobal.event:listen("LocalEvent_SpinScreen","__Commentfrm",function()
	if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL) then		--竖屏模式
		BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 
		BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2
	else
		BOARD_POS_X = hVar.SCREEN.w - BOARD_WIDTH - hVar.SCREEN.offx - 20 
		BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2
	end
end)

--打开评论面板
hGlobal.event:listen("LocalEvent_Comment_Open", "__CommentOpen__", function(title,commentType,tyepID,beginIndex)
	if hGlobal.UI.CommentFrm == nil then
		hGlobal.UI.InitCommentFrm()
		_commentType = commentType
		_tyepID = tyepID
		SendCmdFunc["comment_system_query_title"](_commentType,_tyepID)
		SendCmdFunc["comment_system_look_comment"](_commentType,_tyepID,beginIndex)
	end
	_nCanDrag = 1
	ShowSelf()

	--设置评论面板标题
	if title then
		hGlobal.UI.CommentFrm.childUI["titleText"]:setText(title)
	end
	print("LocalEvent_Comment_Open")
end)

--打开评论面板
hGlobal.event:listen("LocalEvent_Comment_Update_Title", "__CommentUpdateTitle__", function(title,nMode)
	--设置评论面板标题
	if hGlobal.UI.CommentFrm and title then
		hGlobal.UI.CommentFrm.childUI["titleText"]:setText(title)
	end
	if nMode ~= 1 then
		SetCommentBtnState(1)
	else
		SetCommentBtnState(-1)
	end
	print("LocalEvent_Comment_Update_Title")
end)


--隐藏评论面板
hGlobal.event:listen("LocalEvent_Comment_Close", "__CommentClose__", function()
	HideSelf()
end)

--清理评论面板，删除面板资源
hGlobal.event:listen("LocalEvent_Comment_Clean", "__CommentClean__", function() 
	CleanSelf()
end)

--评论面板
hGlobal.UI.InitCommentFrm = function(mode)
	--系统加载时，不创建
	if mode ~= nil then
		return
	end

	--不重复创建弹幕面板
	if hGlobal.UI.CommentFrm then --游戏币变化面板
		return
	end
	

	--创建评论面板
	hGlobal.UI.CommentFrm = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 0,
		show = 0, --一开始不显示
		border = 0, --显示frame边框
		--background = -1,--"misc/skillup/msgbox6.png",
		background = "misc/addition/comment_panel.png",
		autoactive = 0,
		z =  COMMENT_BOARD_Z_ORDER,
		--点击事件
		codeOnTouch = function(self, x, y, sus)
		end,
	})

	local currentPageIndex = 1
	local maxCommentline = 0
	local _nCanComment = 1

	local _frm = hGlobal.UI.CommentFrm
	local _parent = _frm.handle._n

	--local img9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/itemtip.png", BOARD_WIDTH/2, -BOARD_HEIGHT/2 , BOARD_WIDTH, BOARD_HEIGHT, _frm)
	
	local frmClippingRect = {0, BOARD_COMMENT_LIST_ROOT_Y, BOARD_WIDTH, BOARD_CONTENT_VIEW_HEIGHT, 0} -- {x, y, w, h, show}
	local frmClipNode = hApi.CreateClippingNode(_frm, frmClippingRect, 98, 0, "FrmClipNode")

	local CreatPullMoreCommentButton = hApi.DoNothing
	local CreateEditBox = hApi.DoNothing
	local GetEditBoxText = hApi.DoNothing
	local MoveContentToLine = hApi.DoNothing
	
	--关闭按钮
	local closeDx = -40
	local closeDy = -48
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		model = "misc/skillup/btn_close.png",
		x = _frm.data.w + closeDx,
		y = closeDy,
		z = 10000,
		scaleT = 0.95,
		code = function()
			CleanSelf()
			hGlobal.event:event("LocalEvent_RecoverBarrage")
		end,
	})

	--评论标题
	_frm.childUI["titleText"] = hUI.label:new({
		parent =_parent,
		x = BOARD_WIDTH/2,
		y = - 35,
		font = hVar.FONTC,
		size = 40,
		align = "MC",
		width = BOARD_WIDTH,
		height = 60,
		text = "评论",
		border = 1,
	})

	--更多评论
	_frm.childUI["pullMoreCommentButton"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		model = "misc/chest/itembtn.png",
		x = 600,
		y = -650,
		w = 150,
		h = 80,
		scaleT = 0.95,
		label = {text = "更多评论",size = 24,font = hVar.FONTC, y = 2},
		--z = 2,
		code = function()
			print("CreatPullMoreCommentButton ",currentPageIndex)
			SendCmdFunc["comment_system_look_comment"](_commentType,_tyepID,currentPageIndex)
		end
	})
	_frm.childUI["pullMoreCommentButton"]:setstate(-1)

	--发表评论
--	_frm.childUI["commitCommentButton"] = hUI.button:new({
--		parent = _parent,
--		dragbox = _frm.childUI["dragBox"],
--		model = "misc/chest/itembtn.png",
--		x = 400,
--		y = -650,
--		w = 150,
--		h = 80,
--		scaleT = 0.95,
--		label = {text = "发表评论",size = 24,font = hVar.FONTC, y = 2},
--		--z = 12,
--		code = function()
--			--SendCmdFunc["comment_system_add_comment"](1, 1, 0, "测试 "..tostring(testSerialNo))
--			_editCommentType = _commentType
--			_editTyepID = _tyepID
--			CreateEditBox()
--			--testSerialNo = testSerialNo + 1
--			--SendCmdFunc["comment_system_look_comment"](1,1,currentPageIndex)
--		end
--	})

	_frm.childUI["commitCommentButton"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		model = "misc/addition/comment_button.png",
		x = BOARD_WIDTH - 40 - 36,
		y = - BOARD_HEIGHT + 36,
		--w = 150,
		--h = 80,
		scaleT = 0.95,
		scale = 0.9,
		--z = 12,
		code = function()
			--SendCmdFunc["comment_system_add_comment"](1, 1, 0, "测试 "..tostring(testSerialNo))
			_editCommentType = _commentType
			_editTyepID = _tyepID
			CreateEditBox()
			--testSerialNo = testSerialNo + 1
			--SendCmdFunc["comment_system_look_comment"](1,1,currentPageIndex)
		end
	})
	_frm.childUI["commitCommentButton"]:setstate(-1)


	--控制参数
	local last_click_pos_x = 0			--上一次按下的坐标x
	local last_click_pos_y = 0			--上一次按下的坐标y
	local MAX_SLIDE_SPEED = 50			--最大速度
	
	local contentY = 0
	local contentHeight = 0

	local contentLines = {}				--行号排列的评论
	local contentViews = {}				--每条评论内部的视图组件结构


	local SetItemNodeY = function(node,newY)
		local x,y,w,h = hUI.uiGetXYWH(node) 
		hUI.uiSetXY(node ,x,newY)
	end


	local contentViewRoot = hUI.button:new({
		parent = frmClipNode,
		model = -1,
		--model = "misc/mask_white.png",
		x = BOARD_COMMENT_LIST_ROOT_X,
		y = BOARD_COMMENT_LIST_ROOT_Y,
		w = 600,
		h = 600,
		align = "LT",
	})

	local UpdateLikeButtonState = function(views,state)
		views["likeButtonData"] = state
		if views["likeButtonData"] == "0" then
			--views["likeButton"]:setText("")
			views["likeButton"]:setstate(1)
		else
			--views["likeButton"]:setText("")
			views["likeButton"]:setstate(-1)
		end
	end


	local CreateSubContentLine = function(parentNode,posY,commentData)
		--print("CreateSubContentLine y ", posY )

		local subItem = {}
		subItem["commentID"] = commentData.commentID

		local roleName = hUI.label:new({
					parent = parentNode.handle._n,
					x = BOARD_SUB_COMMENT_NAME_OFFSET_X,
					y = posY + BOARD_SUB_COMMENT_NAME_OFFSET_Y,
					font = hVar.FONTC,
					size = 24,
					align = "LT",
					width = BOARD_ROLENAME_LINE_WIDTH,
					height = 70,
					text = commentData.name,
					border = 1,
				}) 
		roleName.handle.s:setColor(ccc3(255, 255, 0))
		subItem["roleName"] = roleName
		--print("CreateSubContentLine roleName	",posY + BOARD_SUB_COMMENT_NAME_OFFSET_Y)

		--[[
		local starNum = hUI.label:new({
					parent = parentNode.handle._n,
					x = 320,
					y = posY -30,
					font = hVar.FONTC,
					size = 24,
					align = "LT",
					width = 200,
					height = 70,
					text = tostring(commentData.star),
					border = 1,
				})
		subItem["starNum"] = starNum
		--]]


		local contentText = hUI.label:new({
					parent = parentNode.handle._n,
					x =  BOARD_SUB_CONTENT_LINE_OFFSET_X,
					y =  posY + BOARD_SUB_CONTENT_LINE_OFFSET_Y,
					font = hVar.FONTC,
					size = 28,
					align = "LT",
					width = BOARD_SUB_CONTENT_LINE_WIDTH,
					--height = textHeight,
					text = commentData.content,
					border = 1,
				})
	--	local fontColor = {255,255,255}
	--	contentText.handle.s:setColor(ccc3(fontColor[1], fontColor[2], fontColor[3]))
		local info2W, info2H = contentText:getWH()
		subItem["contentText"] = contentText
		--print("CreateSubContentLine contentText	",posY + BOARD_SUB_CONTENT_LINE_OFFSET_Y)

		local itemHeight = info2H + math.abs(BOARD_SUB_CONTENT_LINE_OFFSET_Y)


		subItem["height"] = itemHeight
		return subItem ,itemHeight
	end

	local CreateContentEntry = function(parentNode,posY,commentData)
		local views = {}
		local contentEntry = hUI.button:new({
			parent = parentNode,
			model = -1,
			--model = "misc/mask_white.png",
			x = 0,
			y = posY,
			--w = 400,
			--h = 1000,
			align = "LT",
		})
		views["root"] = contentEntry

		local iconId = 1 -- commentData.icon
		local tRoleIcon = hVar.tab_roleicon[iconId]
		if (tRoleIcon == nil) then
			tRoleIcon = hVar.tab_roleicon[0]
		end
		local iconW = tRoleIcon.width
		local iconH = tRoleIcon.height
		local iconPath = tRoleIcon.icon

		local roleNameText = commentData.name
		local content = commentData.content

		local isCommand,icon,name,text = IsCommandString(commentData.content)
		if isCommand then
			iconPath = icon or iconPath
			roleNameText = name or roleNameText
			content = text or content
		end


		local roleIcon =  hUI.image:new({
				parent = contentEntry.handle._n,
				model = iconPath,
				x = 38,
				y = - 94,
				align = "LT",
				w = 72,--iconW,
				h = 72,--iconH,
			})
		views["roleIcon"] = roleIcon
		
		local roleName = hUI.label:new({
					parent = contentEntry.handle._n,
					x = 100,
					y = -20,
					font = hVar.FONTC,
					size = 30,
					align = "LT",
					width = BOARD_ROLENAME_LINE_WIDTH,
					height = 70,
					text = roleNameText,
					border = 1,
				}) 
		roleName.handle.s:setColor(ccc3(255, 255, 0))
		views["roleName"] = roleName

		local starNum = hUI.label:new({
					parent = contentEntry.handle._n,
					x = LIKE_BUTTON_OFFSET_X - 6,
					y = -20,
					font = hVar.FONTC,
					size = 30,
					align = "RT",
					width = 200,
					height = 70,
					text = tostring(commentData.star),
					border = 1,
				})
		views["starNum"] = starNum		

		local likeButton = hUI.button:new({
			parent = contentEntry.handle._n,
			model = "misc/zan.png",
			x = LIKE_BUTTON_OFFSET_X,
			y = LIKE_BUTTON_OFFSET_Y,
			w = LIKE_BUTTON_OFFSET_W,
			h = LIKE_BUTTON_OFFSET_H,
			scaleT = 0.95,
			--label = {text = "赞",size = 24,font = hVar.FONTC, y = 2},
			align = "LT",
			code = function()
			end
		})
		views["likeButton"] = likeButton
		UpdateLikeButtonState(views,commentData.isLike)

		--	_editCommentType = _commentType
		--	_editTyepID = _tyepID


		local contentText = hUI.label:new({
					parent = contentEntry.handle._n,
					x =  BOARD_CONTENT_LINE_OFFSET_X,
					y =  BOARD_CONTENT_LINE_OFFSET_Y ,
					font = hVar.FONTC,
					size = 28,
					align = "LT",
					width = BOARD_CONTENT_LINE_WIDTH,
					--height = textHeight,
					text = content,
					border = 1,
				})
	--	local fontColor = {255,255,255}
	--	contentText.handle.s:setColor(ccc3(fontColor[1], fontColor[2], fontColor[3]))
		local info2W, info2H = contentText:getWH()
		views["contentText"] = contentText

		views["commentID"] = commentData.commentID 
		local itemHeight = info2H + math.abs(BOARD_CONTENT_LINE_OFFSET_Y)
		local commitbtny = BOARD_CONTENT_LINE_OFFSET_Y - (info2H - 30)/2 + 3


		local commitButton = hUI.button:new({
			parent = contentEntry.handle._n,
			model = "misc/addition/reply_button.png",
			x = COMMIT_BUTTON_OFFSET_X,
			--y = - itemHeight + COMMIT_BUTTON_OFFSET_H ,
			y = commitbtny,
			w = COMMIT_BUTTON_OFFSET_W,
			h = COMMIT_BUTTON_OFFSET_H,
			scaleT = 0.95,
			--label = {text = "回复",size = 24,font = hVar.FONTC, y = 2},
			align = "LT",
			code = function()
			end
		})
		views["commitButton"] = commitButton
		--views["commitButtonPosY"] = - itemHeight + COMMIT_BUTTON_OFFSET_H
		views["commitButtonPosY"] = commitbtny
		--	_editCommentType = _commentType
		--	_editTyepID = _tyepID


		views["subBeginPosY"] = itemHeight
		if commentData.subComment then
			local subLineHeight = 0
			views["subItems"] = {}
			views["subItemsBeginIndex"] = views["subItemsBeginIndex"] or 0
			views["subItemsBeginIndex"] = views["subItemsBeginIndex"] + #commentData.subComment
			for i,v in ipairs(commentData.subComment)do
				local items,lineHeight = CreateSubContentLine(contentEntry, - itemHeight - subLineHeight,v)
				subLineHeight = subLineHeight + lineHeight
				table.insert(views["subItems"],items)
			end
			itemHeight = itemHeight + subLineHeight
			
			if views["subItemsBeginIndex"] < commentData.subTotal then
				local moreSubCommentButton = hUI.button:new({
					parent = contentEntry.handle._n,
					model = "misc/chest/itembtn.png",
					x = COMMIT_BUTTON_OFFSET_X,
					y = - itemHeight + COMMIT_BUTTON_OFFSET_H ,
					w = COMMIT_BUTTON_OFFSET_W,
					h = COMMIT_BUTTON_OFFSET_H,
					scaleT = 0.95,
					label = {text = "更多",size = 24,font = hVar.FONTC, y = 2},
					align = "LT",
					code = function()
					end
				})
				views["moreSubCommentButton"] = moreSubCommentButton
				views["moreSubCommentButtonPosY"] = - itemHeight + COMMIT_BUTTON_OFFSET_H
			end
		end

		--分割线2
		local splitLine = hUI.image:new({
			parent = contentEntry.handle._n,
			model = "misc/chest/line.png",
			--x = offX,
			--y = offY - 60,
			x = SPLITLINE_OFFSET_X,
			y = - itemHeight - 30,
			w = BOARD_WIDTH + 20,
			h = 15,
		})
		itemHeight = itemHeight + 10
		views["splitLine"] = splitLine

		return contentEntry , itemHeight , views
	end

	local AddOneComment2View = function(posY,data,line)
		local view,height,subItems = CreateContentEntry(contentViewRoot.handle._n,posY,data)
		contentViews[data.commentID] = {level = 1,view = view,subItems = subItems,height = height,posY = posY,line = line}
		--print("AddOneComment2View ",data.commentID)
		if subItems["subItems"] ~= nil then
			for _,v in ipairs(subItems["subItems"])do
				contentViews[v.commentID] = {level = 2,views = v,parentID = data.commentID}
			end
		end
		return view,height
	end

	local CreateContentView = function(data)
		contentLines = {}

		local posY = 0
		for i,v in ipairs(data) do
			local _,height = AddOneComment2View(posY,v,#contentLines+1)
			table.insert(contentLines, v.commentID )
			posY = posY - height
		end
		contentHeight = - posY
	end

	local RefreshBelowLineView = function(lineNubmer,posY)
		for i = lineNubmer,#contentLines do
			local commentID = contentLines[i]
			--print("RefreshBelowLineView	",commentID,i)
			local view = contentViews[commentID]
			SetItemNodeY(view.view,posY)
			view.posY = posY
			posY = posY - view.height
		end
		contentHeight = -posY
	end

	local DelViewByLineNumber = function(lineNubmer)
		local commentID = contentLines[lineNubmer]
		local view  = contentViews[commentID]
		if view then
			--contentViewRoot.handle._n:removeChild(view.view._n,true)
			view.view:del()
			table.remove(contentLines,lineNubmer)
			contentViews[commentID] = nil

			RefreshBelowLineView(lineNubmer,view.posY)
		end
	end

	local CalLineCommnetPosY = function(line)
		local posY = 0
		if line > #contentLines then
			if #contentLines > 0 then
				local commentID = contentLines[#contentLines]
				local view  = contentViews[commentID]
				posY = view.posY - view.height
			end
		else
			local commentID = contentLines[line]
			local view  = contentViews[commentID]
			posY = view.posY
		end
		return posY
	end

	local GetClickLineView = function(x,y)
		local rtn , line
		--local lineBaseX = x - BOARD_COMMENT_LIST_ROOT_X
		--local lineBaseY = y - BOARD_COMMENT_LIST_ROOT_Y - contentY
		--print("GetClickLineView	",x,y,lineBaseX,lineBaseY)
		for i,id in ipairs(contentLines)do
			local commentID = contentLines[i]
			local view  = contentViews[commentID]
			if y < view.posY and y > view.posY - view.height then
				rtn = view
				line = i
				break
			end
		end
		return rtn , line
	end

	local TestLikeButtonClick = function(view,x,y)
		if x > 0 and x < LIKE_BUTTON_OFFSET_W and
			y < 0 and y > - LIKE_BUTTON_OFFSET_H then
			--print("TestLikeButtonClick	",view.subItems["commentID"])
			if view.subItems["likeButtonData"] == "0" then
				SendCmdFunc["comment_system_like_comment"](view.subItems["commentID"])
			else
				--SendCmdFunc["comment_system_cannel_like_comment"](view.subItems["commentID"])
			end
		end
	end

	local TestCommitButtonClick = function(view,x,y)
		if x > 0 and x < COMMIT_BUTTON_OFFSET_W and
			y < 0 and y > - COMMIT_BUTTON_OFFSET_H then
			print("TestCommitButtonClick	",view.subItems["commentID"])
			_editCommentType = hVar.CommentTargetTypeDefine.COMMENT
			_editTyepID = view.subItems["commentID"]
			CreateEditBox()
		end
	end

	local TestMoreSubCommentButtonClick = function(view,x,y)
		if x > 0 and x < COMMIT_BUTTON_OFFSET_W and
			y < 0 and y > - COMMIT_BUTTON_OFFSET_H then
			print("TestMoreSubCommentButtonClick	",view.subItems["commentID"],view.subItems["subItemsBeginIndex"])
			SendCmdFunc["comment_system_look_comment"](hVar.CommentTargetTypeDefine.COMMENT,view.subItems["commentID"],view.subItems["subItemsBeginIndex"])
		end
	end

	local UpdateContentView = function(lineNumber,data)
		local view  = contentViews[data.commentID]
		if view ~= nil then
			view.view:del()
			local posY = view.posY
			local line = view.line
			local height
			view,height =  AddOneComment2View(posY,data,line)
			posY = posY - height
			contentLines[line] = data.commentID
			--print("UpdateContentView	",line,data.commentID)
			RefreshBelowLineView(line+1,posY)
		else
			local posY = CalLineCommnetPosY(lineNumber)
			--print("UpdateContentView posY ",lineNumber,posY)
			local _,height = AddOneComment2View(posY,data,lineNumber)
			table.insert(contentLines , lineNumber ,data.commentID )
			for i = lineNumber+1,#contentLines do
				local commentID = contentLines[i]
				local view  = contentViews[commentID]
				view.line = view.line + 1
			end
			RefreshBelowLineView(lineNumber+1,posY - height)
			contentHeight = contentHeight + height
		end
		--DelViewByLineNumber(2)
	end

	local UpdateSubComment = function(commentID,subData)
		local parentComment = contentViews[commentID]
		if parentComment then
			local views = parentComment.subItems
			local itemHeight = views["subBeginPosY"]
			local posY = parentComment.posY
			local line = parentComment.line

			if subData then
				local subLineHeight = 0
				if views["subItems"] then
					for _,v in ipairs(views["subItems"]) do
						v["roleName"]:del()
						v["contentText"]:del()
					end
				end
				views["subItems"] = {}

				views["subItemsBeginIndex"] = views["subItemsBeginIndex"] or 0
				if subData then
					views["subItemsBeginIndex"] = views["subItemsBeginIndex"] + #subData
				end

				for i,v in ipairs(subData)do
					local items,lineHeight = CreateSubContentLine(parentComment.view, - itemHeight - subLineHeight,v)
					subLineHeight = subLineHeight + lineHeight
					table.insert(views["subItems"],items)
				end
				itemHeight = itemHeight + subLineHeight
			end

			SetItemNodeY(views["splitLine"],-itemHeight - 30)
			itemHeight = itemHeight + 30

			posY = posY - itemHeight
			RefreshBelowLineView(line+1,posY)
			
			if subData then
				MoveContentToLine(line)
			end
		end
	end

	local MoveContentDeltaY = function(deltaY)
		--内容长度大于显示窗口才需要移动
		if contentHeight > BOARD_CONTENT_VIEW_HEIGHT then
			local newPos = contentY + deltaY

			--不超过上边界
			if newPos < 0 then
				newPos = 0
			end
			--不超过下边界
			if contentHeight - newPos <  BOARD_CONTENT_VIEW_HEIGHT then
				newPos = contentHeight - BOARD_CONTENT_VIEW_HEIGHT
			end

			SetItemNodeY(contentViewRoot,newPos + BOARD_COMMENT_LIST_ROOT_Y)
			contentY = newPos
			--print("MoveContentDeltaY ",newPos)
		end
	end


	--右侧用于检测滑动事件的控件
	local slideButton = hUI.button:new({
		parent = _parent,
		model = "misc/mask_white.png",
		dragbox = _frm.childUI["dragBox"],
		x = 50,
		y = BOARD_COMMENT_LIST_ROOT_Y,
		w = BOARD_WIDTH, 
		h = BOARD_CONTENT_VIEW_HEIGHT,
		align = "LT",
		failcall = 1,
		
		--按下事件
		codeOnTouch = function(self, touchX, touchY, sus)
			if _nCanDrag == 0 then
				return
			end
	--		print("codeOnTouch", touchX, touchY, sus)
			last_click_pos_x = touchX			--上一次按下的坐标x
			last_click_pos_y = touchY			--上一次按下的坐标y
		--	print("slideButton codeOnTouch")
		end,
		
		--滑动事件
		codeOnDrag = function(self, touchX, touchY, sus)
			if _nCanDrag == 0 then
				return
			end
			--处理移动速度y
			local draggle_speed = touchY - last_click_pos_y
	--		print("slideButton codeOnDrag touchY last_click_pos_y draggle_speed",touchY , last_click_pos_y,draggle_speed)			


			if (draggle_speed > MAX_SLIDE_SPEED) then
				draggle_speed = MAX_SLIDE_SPEED
			end
			if (draggle_speed < -MAX_SLIDE_SPEED) then
				draggle_speed = -MAX_SLIDE_SPEED
			end
			
			MoveContentDeltaY(draggle_speed)
			
			--存储本次的位置
			last_click_pos_x = touchX			--上一次按下的坐标x
			last_click_pos_y = touchY			--上一次按下的坐标y

	--		print("slideButton codeOnDrag")

		end,
		
		--抬起事件
		code = function(self, touchX, touchY, sus)
			if _nCanDrag == 0 then
				return
			end
			local lineBaseX = touchX - BOARD_COMMENT_LIST_ROOT_X
			local lineBaseY = touchY - BOARD_COMMENT_LIST_ROOT_Y - contentY
	
			local view,line = GetClickLineView(lineBaseX,lineBaseY)
			if view and line then
				local likeButtonBaseX = lineBaseX - LIKE_BUTTON_OFFSET_X
				local likeButtonBaseY = lineBaseY - view.posY - LIKE_BUTTON_OFFSET_Y
				TestLikeButtonClick(view,likeButtonBaseX,likeButtonBaseY )

				local commitButtonBaseX = lineBaseX - COMMIT_BUTTON_OFFSET_X
				local commitButtonBaseY = lineBaseY - view.posY - view["subItems"]["commitButtonPosY"]
				TestCommitButtonClick(view,commitButtonBaseX,commitButtonBaseY )

				if view["subItems"]["moreSubCommentButtonPosY"] then
					local moreSubCommentButtonBaseX = lineBaseX - COMMIT_BUTTON_OFFSET_X
					local moreSubCommentButtonBaseY = lineBaseY - view.posY - view["subItems"]["moreSubCommentButtonPosY"]
					TestMoreSubCommentButtonClick(view,moreSubCommentButtonBaseX,moreSubCommentButtonBaseY)
				end
			end
		end,
	})
	slideButton.handle.s:setOpacity(0) --只用于控制，不显示

	--将内容移动到指定行到最上
	MoveContentToLine = function(line)
		local commentID = contentLines[line]
		if commentID then
			local view  = contentViews[commentID]
			--内容长度大于显示窗口才需要移动
			if contentHeight > BOARD_CONTENT_VIEW_HEIGHT then
				--SetItemNodeY(contentViewRoot,-(view.posY + BOARD_COMMENT_LIST_ROOT_Y))
				SetItemNodeY(contentViewRoot,-(view.posY))
				contentY = -(view.posY + BOARD_COMMENT_LIST_ROOT_Y)
			end
		end	
	end

	--输入框
	local EditBoxBG = nil
	local enterNameEditBox = nil
	local current_enterNameEditBox = nil
	local rgName = ""

	local CloseEditBox = function()
		--删除之前可能的输入框
		if current_enterNameEditBox then
			_frm.handle._n:removeChild(current_enterNameEditBox, true)
			current_enterNameEditBox = nil
		end
		if EditBoxBG then
			_frm.handle._n:removeChild(EditBoxBG, true)
			EditBoxBG = nil
		end
		if _frm.childUI["_blackpanel"] then
			_frm.childUI["_blackpanel"].handle._n:setVisible(false)
		end
		hApi.safeRemoveT(_frm.childUI,"btn_mask")
		_nCanDrag = 1
		_frm.childUI["btnSendMessagePrivate"]:setstate(-1)
		_frm.childUI["btnSendMessageCancel"]:setstate(-1)

		contentViewRoot:setstate(1)
		--_frm.childUI["pullMoreCommentButton"]:setstate(_nCanComment)
		_frm.childUI["commitCommentButton"]:setstate(_nCanComment)
		hApi.RecoverScreenRotation()
	end

	GetEditBoxText = function()
		--geyachao: windows版，接收不到输入框的ended事件，只能在点击按钮的时候，取一下输入的文本
		local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
		if (g_tTargetPlatform.kTargetWindows == TargetPlatform) then --windows版
			rgName = current_enterNameEditBox:getText()
		end
		
		--检测文字是否纯为空格
		if (rgName ~= "") then
			local bAllBlank = true
			for i = 1, #rgName, 1 do
				local s = string.sub(rgName, i, i)
				if (s ~= " ") then
					bAllBlank = false
					break
				end
			end
			if bAllBlank then
				--冒字
				--local strText = "聊天内容不能为空" --language
				local strText = hVar.tab_string["ios_chat_not_empty"] --language
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 2000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
				
				return
			end
		end
		
		--检测输入的文字是否过长
		local nLength = hApi.GetStringEmojiENLength(rgName) --英文长度
		if (nLength > 96) then
			--冒字
			--local strText = "您输入的内容过长" --language
			local strText = hVar.tab_string["ios_chat_too_long"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 2000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
			
			return
		end
		
		--处理文字(私聊)
		local message = rgName

		--去除屏蔽字
		local MESSAGE = string.upper(message) --大写(用于匹配)
		local GLOBAL_FILTER_TEXT = hVar.tab_filtertext
		for i = #GLOBAL_FILTER_TEXT, 1, -1 do
			local strFilter = GLOBAL_FILTER_TEXT[i]
			local nLength = hApi.GetStringEmojiENLength(strFilter, 1, 1) --Unicode长度
			while true do
				local pos = string.find(MESSAGE, strFilter)
				if (pos ~= nil) then
					local strRep = string.rep("*", nLength)
					--message = string.gsub(message, strFilter, strRep)
					if ((pos + #strFilter - 1) < #message) then --不是最后一个字符
						message = string.sub(message, 1, pos - 1) .. strRep .. string.sub(message, (pos + #strFilter - 1) + 1, #message)
					else --最后一个字符
						message = string.sub(message, 1, pos - 1) .. strRep
					end
					
					MESSAGE = string.upper(message) --大写(用于匹配)
				else
					break
				end
			end
		end
		
		--最后转小写
		--message = string.lower(message)
		
		--清空文字
		rgName = ""
		current_enterNameEditBox:setText("")
		
		return message
	end

	CreateEditBox = function()
		hApi.LockScreenRotation()
		_nCanDrag = 0
		--删除之前可能的输入框
		if current_enterNameEditBox then
			_frm.handle._n:removeChild(current_enterNameEditBox, true)
			current_enterNameEditBox = nil
		end
		
		--绘制输入框
		rgName = "" --输入的内容
		local editNameBoxTextEventHandle = function(strEventName, pSender)
			--local edit = tolua.cast(pSender, "CCEditBox") 
			--防止输入框被删除，触发回调安卓闪退
			if (current_enterNameEditBox ~= nil) then 
				if (strEventName == "began") then
					--
				elseif (strEventName == "changed") then --改变事件
					--
				elseif (strEventName == "ended") then
					rgName = enterNameEditBox:getText()				
				elseif (strEventName == "return") then
					--
				end
			end
			--print("editNameBoxTextEventHandle", strEventName, rgName)
			--xlLG("editbox", tostring(strEventName) .. ", rgName=" .. tostring(rgName) .. "\n")
		end

		if _frm.childUI["_blackpanel"] == nil then
			_frm.childUI["_blackpanel"] = hUI.image:new({
				parent = _frm.handle._n,
				model = "UI:zhezhao",
				x = 0,
				y = 0,
				w = hVar.SCREEN.w * 2,
				h = hVar.SCREEN.h * 2,
				z = 9999,
			})
			_frm.childUI["_blackpanel"].handle.s:setOpacity(200)
		end
		_frm.childUI["_blackpanel"].handle._n:setVisible(true)

		_frm.childUI["btn_mask"] = hUI.button:new({
			parent = _frm.handle._n,
			model = "misc/button_null.png",
			x = BOARD_WIDTH / 2,
			y = - BOARD_HEIGHT /2,
			w = BOARD_WIDTH,
			h = BOARD_HEIGHT,
			z = 10000,
		})
		
		--为了让输入文字比输入框稍微小些，这里输入框背景单独创建
		--输入框背景图
		EditBoxBG = hApi.CCScale9SpriteCreate("data/image/misc/billboard/bg_ng_graywhite.png", BOARD_WIDTH/2, - BOARD_HEIGHT/2 + 40, 580, 64, _frm,10000)
		local SMALL_LENGTH = 8
		enterNameEditBox = CCEditBox:create(CCSizeMake(550, 48), CCScale9Sprite:create("data/image/misc/button_null.png"))--"data/image/misc/win_back.png""data/image/misc/1xs.png"
		enterNameEditBox:setPosition(ccp(BOARD_WIDTH/2, - BOARD_HEIGHT/2 + 40))
		--enterNameEditBox:setFontName("Sketch Rockwell.ttf")
		enterNameEditBox:setFontSize(28)
		enterNameEditBox:setFontColor(ccc3(0, 0, 0))
		enterNameEditBox:setPlaceHolder(hVar.tab_string["点击输入评论"]) --"输入文字"
		enterNameEditBox:setPlaceholderFontColor(ccc3(192, 192, 192)) --默认显示文字颜色
		enterNameEditBox:setMaxLength(48) --最大支持字符数
		enterNameEditBox:registerScriptEditBoxHandler(editNameBoxTextEventHandle)
		enterNameEditBox:setTouchPriority(0)
		enterNameEditBox:setReturnType(kKeyboardReturnTypeDone)
		--_frmNode.childUI["DragPanelPrivate"].handle._n:addChild(enterNameEditBox)
		_frm.handle._n:addChild(enterNameEditBox,10000)
		
		--存储输入框指针
		current_enterNameEditBox = enterNameEditBox
		
		if _frm.childUI["btnSendMessagePrivate"] then
			_frm.childUI["btnSendMessagePrivate"]:setstate(1)
		else
		--发送按钮(私聊)
		_frm.childUI["btnSendMessagePrivate"] = hUI.button:new({
			parent = _parent,
			dragbox = _frm.childUI["dragBox"],
			model = "misc/chest/itembtn.png",
			x = BOARD_WIDTH / 2 - 120,
			y = - BOARD_HEIGHT /2 - 100,
			w = 150,
			h = 80,
			scaleT = 0.95,
			z = 10000,
			label = {text = "发送",size = 24,font = hVar.FONTC, y = 2},

			code = function()
				local message = GetEditBoxText()
				
				if (message ~= "") then
					SendCmdFunc["comment_system_add_comment"](_editCommentType,_editTyepID,1, message)
					CloseEditBox()
				end
			end,
		})
			
		end

		if _frm.childUI["btnSendMessageCancel"] then
			_frm.childUI["btnSendMessageCancel"]:setstate(1)
		else
		_frm.childUI["btnSendMessageCancel"] = hUI.button:new({
			parent = _parent,
			dragbox = _frm.childUI["dragBox"],
			model = "misc/chest/itembtn.png",
			x = BOARD_WIDTH / 2 + 120,
			y = - BOARD_HEIGHT /2 - 100,
			w = 150,
			h = 80,
			z = 10000,
			scaleT = 0.95,
			label = {text = "关闭",size = 24,font = hVar.FONTC, y = 2},

			code = function()
				CloseEditBox()
			end,
		})

		end


		--contentViewRoot:setstate(-1)
		_frm.childUI["pullMoreCommentButton"]:setstate(-1)
		_frm.childUI["commitCommentButton"]:setstate(-1)

	end
	
	CleanSelf = function()
		if hGlobal.UI.CommentFrm then --删除界面
			hGlobal.UI.CommentFrm:del()
			hGlobal.UI.CommentFrm = nil
			
			hGlobal.event:listen("localEvent_Comment_DataChange", "__CommentDataChange__",nil)
			hGlobal.event:listen("localEvent_Add_Comment_Ret", "__AddCommentRet__",nil)
			hGlobal.event:listen("localEvent_Like_Comment_Ret", "__LikeCommentRet__",nil)
			hGlobal.event:listen("localEvent_Cancel_Like_Comment_Ret", "__CancelLikeCommentRet__",nil)
		end

		--清空数据
		contentLines = nil				--行号排列的评论
		contentViews = nil				--每条评论内部的视图组件结构

		hApi.RecoverScreenRotation()
	end

	HideSelf = function()
		_frm:show(0)

		hGlobal.event:listen("localEvent_Comment_DataChange", "__CommentDataChange__",nil)
		hGlobal.event:listen("localEvent_Add_Comment_Ret", "__AddCommentRet__",nil)
		hGlobal.event:listen("localEvent_Like_Comment_Ret", "__LikeCommentRet__",nil)
		hGlobal.event:listen("localEvent_Cancel_Like_Comment_Ret", "__CancelLikeCommentRet__",nil)
	
	end
	
	ShowSelf = function()
		hGlobal.UI.CommentFrm:show(1)
		hGlobal.UI.CommentFrm:active()

		--添加事件监听：收到弹幕数据变化回调
		hGlobal.event:listen("localEvent_Comment_DataChange", "__CommentDataChange__", function(data)
			--table.insert(commentData,data)
			--print("__CommentDataChange__	dataType ",data.commentType)
			if data.commentType == hVar.CommentTargetTypeDefine.COMMENT then
				UpdateSubComment(data.typeID,data.lookData)
			else
				for i,v in ipairs(data.lookData)do
					--print("__CommentDataChange__	comment id ,line ,update ",v.commentID,data.pageIndex + i,v.updateDate)
					UpdateContentView(data.pageIndex + i,v)
				end

				currentPageIndex = data.pageIndex + #data.lookData;

				if maxCommentline < currentPageIndex then
					maxCommentline = currentPageIndex
				end
			end

			--[[
			if maxCommentline < data.commentCount then
				print("more", currentPageIndex , data.commentCount)
				_frm.childUI["pullMoreCommentButton"]:setstate(1)
			else
				print("end " , currentPageIndex , data.commentCount )
				_frm.childUI["pullMoreCommentButton"]:setstate(-1)
			end
			--]]
		end)

		
		hGlobal.event:listen("localEvent_Add_Comment_Ret", "__AddCommentRet__", function(data,commentID,commentType,typeID)
			if data == "0" then
				--print("add comment success")
				if commentType == hVar.CommentTargetTypeDefine.COMMENT then
					print("add comment success ",commentID,commentType,typeID)
					if contentViews[typeID] then
						MoveContentToLine(contentViews[typeID].line)
					end
					SendCmdFunc["comment_system_look_comment"](commentType,typeID,0)
				else
					MoveContentToLine(1)
					SendCmdFunc["comment_system_look_comment"](_commentType,_tyepID,0)
				end
			else
				--print("add comment failed " , data)
			end
			
		end)

		--点赞评论结果
		hGlobal.event:listen("localEvent_Like_Comment_Ret", "__LikeCommentRet__", function(ret,commentID,starCount)
			if ret == "0" then
				local view  = contentViews[commentID]
				print("localEvent_Like_Comment_Ret",ret,commentID,starCount,view)
				if view then
					UpdateLikeButtonState(view.subItems,"1")
					view.subItems["starNum"]:setText(starCount)
				end
			else
				--print("add comment failed " , data)
			end
			
		end)

		--取消点赞评论结果
		hGlobal.event:listen("localEvent_Cancel_Like_Comment_Ret", "__CancelLikeCommentRet__", function(ret,commentID,starCount)
			if ret == "0" then
				local view  = contentViews[commentID]
				print("localEvent_Cancel_Like_Comment_Ret",ret,commentID,starCount,view)
				if view then
					UpdateLikeButtonState(view.subItems,"0")
					view.subItems["starNum"]:setText(starCount)
				end
			else
				--print("add comment failed " , data)
			end
			
		end)

	end

	SetCommentBtnState = function(nState)
		_nCanComment = nState
		--_frm.childUI["pullMoreCommentButton"]:setstate(_nCanComment)
		if _frm and _frm.childUI["commitCommentButton"] then
			_frm.childUI["commitCommentButton"]:setstate(_nCanComment)
		end
	end
end

--[[
if hGlobal.UI.CommentFrm then --删除上一次的界面
	hGlobal.UI.CommentFrm:del()
	hGlobal.UI.CommentFrm = nil
end
hGlobal.UI.InitCommentFrm() --

hGlobal.event:event("LocalEvent_Comment_Open")
--]]


