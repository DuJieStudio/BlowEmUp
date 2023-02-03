

--弹出推广其他游戏界面
hGlobal.UI.InitCMSTGTipFrm = function(mode)
	--不重复创建推广其他游戏
	if hGlobal.UI.CMSTGTipFrm then --推广其他游戏面板
		return
	end
	
	local BOARD_WIDTH = 840 --推广其他游戏面板的宽度
	local BOARD_HEIGHT = 550 --推广其他游戏面板的高度
	local BOARD_OFFSETY = -20 --推广其他游戏面板y偏移中心点的值
	local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 --推广其他游戏面板的x位置（最左侧）
	local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --推广其他游戏面板的y位置（最顶侧）
	
	local PAGE_BTN_LEFT_X = 290 --第一个分页按钮的x偏移
	local PAGE_BTN_LEFT_Y = -21 --第一个分页按钮的x偏移
	local PAGE_BTN_OFFSET_X = 140 --每个分页按钮的间距
	
	--临时UI管理
	local leftRemoveFrmList = {} --左侧控件集
	local rightRemoveFrmList = {} --右侧控件集
	local _removeLeftFrmFunc = hApi.DoNothing --清空左侧所有的临时控件
	local _removeRightFrmFunc = hApi.DoNothing --清空右侧所有的临时控件
	
	--局部函数
	local OnClickPageBtn = hApi.DoNothing --点击分页按钮
	local RefreshSelectedCardFrame = hApi.DoNothing --更新绘制当前查看的卡牌的信息
	
	--分页1：显示推广其他游戏界面
	local OnCreateCMSTGInfoFrame = hApi.DoNothing --创建推广其他游戏界面（第1个分页）
	local OnCreateCMSTGInfoFrame_LeftPart = hApi.DoNothing --绘制左侧推广其他游戏列表界面
	local OnCreateCMSTGInfoFrame_RightPart = hApi.DoNothing --显示某个推广其他游戏的详细信息
	local refresh_cmstg_UI_loop = hApi.DoNothing --刷新推广界面的滚动
	
	--分页1：推广其他游戏的参数
	local TOOTHERGAME_WIDTH = 120 --推广其他游戏宽度
	local TOOTHERGAME_HEIGHT = 120 --推广其他游戏高度
	local TOOTHERGAME_OFFSET_X = -10 --推广其他游戏统一偏移x
	local TOOTHERGAME_OFFSET_Y = 28 --推广其他游戏统一偏移y
	local TOOTHERGAME_BOARD_HEIGHT = 500 --推广其他游戏高度
	local TOOTHERGAME_X_NUM = 1 --推广x的数量
	local TOOTHERGAME_Y_NUM = 3 --推广y的数量
	local MAX_SPEED_TOOTHERGAME = 50 --最大速度
	
	--可变参数
	local current_OtherGame_max_num = 0 --最大的推广其他游戏数量
	
	--控制参数
	local click_pos_x_toothergame = 0 --开始按下的坐标x
	local click_pos_y_toothergame = 0 --开始按下的坐标y
	local last_click_pos_y_toothergame = 0 --上一次按下的坐标x
	local last_click_pos_y_toothergame = 0 --上一次按下的坐标y
	local draggle_speed_y_toothergame = 0 --当前滑动的速度x
	local selected_toothergameEx_idx = 0 --选中的推广ex索引
	local click_scroll_toothergame = false --是否在滑动推广中
	local b_need_auto_fixing_toothergame = false --是否需要自动修正
	local friction_toothergame = 0 --阻力
	
	--当前选中的记录
	local CurrentSelectRecord = {pageIdx = 0, contentIdx = 0, cardId = 0,} --当前选择的分页、数据项的信息记录
	
	--加载资源
	--xlLoadResourceFromPList("data/image/misc/pvp.plist")
	
	hApi.clearTimer("__SMSTG_INFO_UPDATE__")
	
	--创建推广其他游戏面板
	hGlobal.UI.CMSTGTipFrm = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 2,
		show = 0, --一开始不显示
		border = 1, --显示frame边框
		background = "UI:Tactic_Background",
		--background = "UI:tip_item",
		--background = "UI:Tactic_Background",
		--background = "UI:herocardfrm",
		autoactive = 0,
		
		--点击事件
		codeOnTouch = function(self, x, y, sus)
			--在外部点击
			if (sus == 0) then
				self.childUI["closeBtn"].data.code()
			end
		end,
	})
	
	local _frm = hGlobal.UI.CMSTGTipFrm
	local _parent = _frm.handle._n
	
	--左侧裁剪区域
	local _BTC_PageClippingRect_ToOtherGame = {0, -75, 1000, 438, 0} -- {x, y, w, h, ???}
	local _BTC_pClipNode_toothergame = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect_ToOtherGame, 98, _BTC_PageClippingRect_ToOtherGame[5], "_BTC_pClipNode_toothergame")
	
	--关闭按钮
	local closeDx = -5
	local closeDy = -5
	if (g_phone_mode ~= 0) then
		closeDx = 0
		closeDy = -20
	end
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		model = "BTN:PANEL_CLOSE",
		x = _frm.data.w + closeDx,
		y = closeDy,
		scaleT = 0.95,
		code = function()
			--不显示推广其他游戏面板
			hGlobal.UI.CMSTGTipFrm:show(0)
			
			--删除DLC界面滑动滚动timer
			hApi.clearTimer("__SMSTG_INFO_UPDATE__")
		end,
	})
	
	--每个分页按钮
	--推广
	local tPageIcons = {"UI:ach_king",}
	--local tTexts = {"游戏",} --language
	local tTexts = {hVar.tab_string["__TEXT_GameList"],} --language
	for i = 1, #tPageIcons, 1 do
		--分页按钮
		_frm.childUI["PageBtn" .. i] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			x = PAGE_BTN_LEFT_X + (i - 1) * PAGE_BTN_OFFSET_X - 175,
			y = PAGE_BTN_LEFT_Y,
			w = 250,
			h = 40,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.0,
			code = function(self, screenX, screenY, isInside)
				OnClickPageBtn(i)
			end,
		})
		_frm.childUI["PageBtn" .. i].handle.s:setOpacity(0) --分页按钮点击区域，只作为控制用，不用于显示
		
		--分页按钮的文字
		_frm.childUI["PageBtn" .. i].childUI["Text"] = hUI.label:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			x = 10,
			y = 0,
			size = 28,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 300,
			text = tTexts[i],
		})
	end
	
	--分页内容的的父控件
	_frm.childUI["PageNode"] = hUI.button:new({
		parent = _frm,
		--model = tPageIcons[i],
		x = 0,
		y = 0,
		w = 1,
		h = 1,
		--border = 0,
		--background = "UI:Tactic_Background",
		--z = 10,
	})
	
	--清空所有分页左侧的UI
	_removeLeftFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.CMSTGTipFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.CMSTGTipFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#rightRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, rightRemoveFrmList[i]) 
		end
		rightRemoveFrmList = {}
	end
	
	--函数：点击分页按钮函数
	OnClickPageBtn = function(pageIndex)
		--不重复显示同一个分页
		if (CurrentSelectRecord.pageIdx == pageIndex) then
			return
		end
		
		--启用全部的按钮
		for i = 1, #tPageIcons, 1 do
			_frm.childUI["PageBtn" .. i].childUI["Text"].handle.s:setVisible(true) --显示文字
		end
		
		--先清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--清空切换分页之后取消的监听事件
		
		--移除timer
		hApi.clearTimer("__SMSTG_INFO_UPDATE__")
		
		--隐藏所有的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_toothergame", 0)
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：推广其他游戏
			--创建推广其他游戏分页
			OnCreateCMSTGInfoFrame(pageIndex)
		end
		
		--标记当前选择的分页和页内的第几个
		CurrentSelectRecord.pageIdx = pageIndex
		CurrentSelectRecord.contentIdx = 1 --默认选中第一个
	end
	
	--函数：创建推广其他游戏界面（第1个分页）
	OnCreateCMSTGInfoFrame = function(pageIdx)
		local _frm = hGlobal.UI.CMSTGTipFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--允许本分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_toothergame", 1)
		
		--初始化参数
		current_OtherGame_max_num = 0 --最大的推广id
		
		--副标题
		_frmNode.childUI["ToOtherGamePageUp"] = hUI.label:new({
			parent = _parentNode,
			size = 28,
			x = TOOTHERGAME_OFFSET_X + 540,
			y = TOOTHERGAME_OFFSET_Y - 50,
			width = 800,
			align = "MC",
			font = hVar.FONTC,
			--text = "游戏介绍", --language
			text = hVar.tab_string["__TEXT_GameContent"], --language
			border = 1,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ToOtherGamePageUp"
		
		--左侧推广其他游戏列表提示上翻页的图片
		_frmNode.childUI["ToOtherGamePageUp"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = TOOTHERGAME_OFFSET_X + 123,
			y = TOOTHERGAME_OFFSET_Y - 85,
			scale = 1.0,
			z = 500, --最前端显示
		})
		_frmNode.childUI["ToOtherGamePageUp"].handle.s:setRotation(90)
		_frmNode.childUI["ToOtherGamePageUp"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_frmNode.childUI["ToOtherGamePageUp"].handle.s:setVisible(false) --默认不显示左上翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ToOtherGamePageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["ToOtherGamePageUp"].handle._n:runAction(forever)
		
		--左侧推广其他游戏列表提示下翻页的图片
		_frmNode.childUI["ToOtherGamePageDown"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = TOOTHERGAME_OFFSET_X + 123 + 7, --非对称的翻页图
			y = TOOTHERGAME_OFFSET_Y - 558,
			scale = 1.0,
			z = 500, --最前端显示
		})
		_frmNode.childUI["ToOtherGamePageDown"].handle.s:setRotation(270)
		_frmNode.childUI["ToOtherGamePageDown"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		_frmNode.childUI["ToOtherGamePageDown"].handle.s:setVisible(false) --默认不显示下分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ToOtherGamePageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["ToOtherGamePageDown"].handle._n:runAction(forever)
		
		--左侧向上翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["ToOtherGamePageUp_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = TOOTHERGAME_OFFSET_X + 123,
			y = TOOTHERGAME_OFFSET_Y - 84 + 2,
			w = 200,
			h = 36,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (current_OtherGame_max_num > (TOOTHERGAME_X_NUM * TOOTHERGAME_Y_NUM)) then
					--print("向下滚屏", screenY)
					--向下滚屏
					b_need_auto_fixing_toothergame = true
					friction_toothergame = 0
					draggle_speed_y_toothergame = -MAX_SPEED_TOOTHERGAME / 2.0 --负速度
				end
			end,
		})
		_frmNode.childUI["ToOtherGamePageUp_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ToOtherGamePageUp_Btn"
		
		--左侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["ToOtherGamePageDown_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = TOOTHERGAME_OFFSET_X + 123,
			y = TOOTHERGAME_OFFSET_Y - 558 - 2,
			w = 200,
			h = 36,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (current_OtherGame_max_num > (TOOTHERGAME_X_NUM * TOOTHERGAME_Y_NUM)) then
					--print("向上滚屏", screenY)
					--向上滚屏
					b_need_auto_fixing_toothergame = true
					friction_toothergame = 0
					draggle_speed_y_toothergame = MAX_SPEED_TOOTHERGAME / 2.0 --正速度
				end
			end,
		})
		_frmNode.childUI["ToOtherGamePageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ToOtherGamePageDown_Btn"
		
		--左侧底板
		--背景图
		_frmNode.childUI["ToOtherGameListBG"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/selectbg.png",
			x = TOOTHERGAME_OFFSET_X + 125,
			y = TOOTHERGAME_OFFSET_Y - 324,
			w = 280,
			h = TOOTHERGAME_BOARD_HEIGHT - 58,
		})
		_frmNode.childUI["ToOtherGameListBG"].handle.s:setOpacity(128) --底板透明度为128
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ToOtherGameListBG"
		
		--竖线
		_frmNode.childUI["ToOtherGameListLineV"] = hUI.image:new({
			parent = _parentNode,
			model = "panel/panel_part_01.png",
			x = TOOTHERGAME_OFFSET_X + 245,
			y = TOOTHERGAME_OFFSET_Y - 302,
			w = TOOTHERGAME_BOARD_HEIGHT + 47,
			h = 12,
		})
		_frmNode.childUI["ToOtherGameListLineV"].handle.s:setRotation(-90)
		_frmNode.childUI["ToOtherGameListLineV"].handle.s:setOpacity(128) --竖线透明度为128
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ToOtherGameListLineV"
		
		--上横线
		_frmNode.childUI["ToOtherGameListLineHUp"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/card_select_back.png",
			x = TOOTHERGAME_OFFSET_X + 130,
			y = TOOTHERGAME_OFFSET_Y - 100,
			w = 210,
			h = 3,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ToOtherGameListLineHUp"
		hApi.AddShader(_frmNode.childUI["ToOtherGameListLineHUp"].handle.s, "gray") --默认上横线到顶了，灰掉
		
		--下横线
		_frmNode.childUI["ToOtherGameListLineHDown"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/card_select_back.png",
			x = TOOTHERGAME_OFFSET_X + 130,
			y = TOOTHERGAME_OFFSET_Y - TOOTHERGAME_BOARD_HEIGHT - 42,
			w = 210,
			h = 3,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ToOtherGameListLineHDown"
		hApi.AddShader(_frmNode.childUI["ToOtherGameListLineHDown"].handle.s, "gray") --默认下横线到顶了，灰掉
		
		--左侧用于检测滑动事件的控件
		_frmNode.childUI["ToOtherGameDragPanel"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = TOOTHERGAME_OFFSET_X + 120,
			y = TOOTHERGAME_OFFSET_Y - 321,
			w = 230,
			h = TOOTHERGAME_BOARD_HEIGHT - 60,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--print("codeOnTouch", touchX, touchY, sus)
				click_pos_x_toothergame = touchX --开始按下的坐标x
				click_pos_y_toothergame = touchY --开始按下的坐标y
				last_click_pos_y_toothergame = touchX --上一次按下的坐标x
				last_click_pos_y_toothergame = touchY --上一次按下的坐标y
				draggle_speed_y_toothergame = 0 --当前速度为0
				selected_toothergameEx_idx = 0 --选中的推广ex索引
				click_scroll_toothergame = true --是否滑动推广
				b_need_auto_fixing_toothergame = false --不需要自动修正位置
				friction_toothergame = 0 --无阻力
				
				--如果推广数量未铺满一页，那么不需要滑动
				if (current_OtherGame_max_num <= (TOOTHERGAME_X_NUM * TOOTHERGAME_Y_NUM)) then
					click_scroll_toothergame = false --不需要滑动推广
				end
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
				--处理移动速度y
				draggle_speed_y_toothergame = touchY - last_click_pos_y_toothergame
				
				if (draggle_speed_y_toothergame > MAX_SPEED_TOOTHERGAME) then
					draggle_speed_y_toothergame = MAX_SPEED_TOOTHERGAME
				end
				if (draggle_speed_y_toothergame < -MAX_SPEED_TOOTHERGAME) then
					draggle_speed_y_toothergame = -MAX_SPEED_TOOTHERGAME
				end
				
				--print("click_scroll_toothergame=", click_scroll_toothergame)
				--在滑动过程中才会处理滑动
				if click_scroll_toothergame then
					local deltaY = touchY - last_click_pos_y_toothergame --与开始按下的位置的偏移值x
					for i = 1, #hVar.ToOther_Game, 1 do
						local mapId = hVar.ToOther_Game[i] --推广其他游戏的道具商店id
						local mapInfo = hVar.MAP_INFO[mapId]
						if (mapInfo) then
							local ctrli = _frmNode.childUI["ToOtherGameNode" .. i]
							ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
							ctrli.data.x = ctrli.data.x
							ctrli.data.y = ctrli.data.y + deltaY
						end
					end
				end
				
				--存储本次的位置
				last_click_pos_y_toothergame = touchX
				last_click_pos_y_toothergame = touchY
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_toothergame then
					--if (touchX ~= click_pos_x_toothergame) or (touchY ~= click_pos_y_toothergame) then --不是点击事件
						b_need_auto_fixing_toothergame = true
						friction_toothergame = 0
					--end
				end
				
				--是否选中某个推广查看区域内查看tip
				local selectTipIdx = 0
				for i = 1, #hVar.ToOther_Game, 1 do
					local mapId = hVar.ToOther_Game[i] --推广其他游戏的道具商店id
					local mapInfo = hVar.MAP_INFO[mapId]
					if (mapInfo) then
						local ctrli = _frmNode.childUI["ToOtherGameNode" .. i]
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						local cw, ch = ctrli.data.w, ctrli.data.h
						local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
						local rx, ry = lx + cw, ly + ch --最右下角坐标
						--print(i, lx, rx, ly, ry, touchX, touchY)
						if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
							selectTipIdx = i
							
							break
							--print("点击到了哪个推广tip的框内" .. i)
						end
					end
				end
				
				if (click_scroll_toothergame) and (math.abs(touchY - click_pos_y_toothergame) > 60) then
					selectTipIdx = 0
				end
				
				if (selectTipIdx > 0) then
					--显示tip
					--print(selectTipIdx)
					OnCreateCMSTGInfoFrame_RightPart(selectTipIdx)
				end
				
				--标记不用滑动
				click_scroll_toothergame = false
			end,
		})
		_frmNode.childUI["ToOtherGameDragPanel"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ToOtherGameDragPanel"
		
		--依次绘制左侧推广其他游戏列表（只绘制一次）
		OnCreateCMSTGInfoFrame_LeftPart()
		
		--默认选中第i个推广其他游戏，显示本地图包的详细信息
		OnCreateCMSTGInfoFrame_RightPart(1)
		
		--创建timer，刷新本分页（推广其他游戏界面）的滚动
		hApi.addTimerForever("__SMSTG_INFO_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_cmstg_UI_loop)
	end
	
	--函数：刷新推广其他游戏界面的滚动
	refresh_cmstg_UI_loop = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		local _frm = hGlobal.UI.CMSTGTipFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local SPEED = 50 --速度
		--print(b_need_auto_fixing_toothergame)
		
		if b_need_auto_fixing_toothergame then
			---第一个推广的数据
			local ToOtherGameBtn1 = _frmNode.childUI["ToOtherGameNode1"]
			local btn1_cx, btn1_cy = 0, 0 --第一个推广中心点位置
			local btn1_ly = 0 --第一个推广最上侧的x坐标
			local delta1_ly = 0 --第一个推广距离上侧边界的距离
			btn1_cx, btn1_cy = ToOtherGameBtn1.data.x, ToOtherGameBtn1.data.y --第一个推广中心点位置
			btn1_ly = btn1_cy + TOOTHERGAME_HEIGHT / 2 --第一个推广最上侧的x坐标
			delta1_ly = btn1_ly + 86 --第一个推广距离上侧边界的距离
			
			--最后一个推广的数据
			local ToOtherGameBtnN = _frmNode.childUI["ToOtherGameNode" .. current_OtherGame_max_num]
			local btnN_cx, btnN_cy = 0, 0 --最后一个推广中心点位置
			local btnN_ry = 0 --最后一个推广最下侧的x坐标
			local deltNa_ry = 0 --最后一个推广距离下侧边界的距离
			btnN_cx, btnN_cy = ToOtherGameBtnN.data.x, ToOtherGameBtnN.data.y --最后一个推广中心点位置
			btnN_ry = btnN_cy - TOOTHERGAME_HEIGHT / 2 --最后一个推广最下侧的x坐标
			deltNa_ry = btnN_ry + 496 --最后一个推广距离下侧边界的距离
			--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
			
			--print("delta1_ly=" .. delta1_ly, ", deltNa_rx=" .. deltNa_rx)
			--如果第一个推广的头像跑到下边，那么优先将第一个推广头像贴边
			if (delta1_ly < 0) then
				--print("优先将第一个推广头像贴边")
				--需要修正
				--不会选中推广
				selected_toothergameEx_idx = 0 --选中的推广索引
				
				--没有惯性
				draggle_speed_y_toothergame = 0
				
				local speed = SPEED
				if ((delta1_ly + speed) > 0) then --防止走过
					speed = -delta1_ly
					delta1_ly = 0
				end
				
				--每个按钮向上侧做运动
				for i = 1, #hVar.ToOther_Game, 1 do
					local mapId = hVar.ToOther_Game[i] --推广其他游戏的道具商店id
					local mapInfo = hVar.MAP_INFO[mapId]
					if (mapInfo) then
						local ctrli = _frmNode.childUI["ToOtherGameNode" .. i]
					--if (ctrli.data.selected == 0) then --只处理未选中的推广卡牌
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y + speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					--end
					end
				end
				
				--上滑动翻页不显示，下滑动翻页显示
				_frmNode.childUI["ToOtherGamePageUp"].handle.s:setVisible(false) --上翻页提示
				hApi.AddShader(_frmNode.childUI["ToOtherGameListLineHUp"].handle.s, "gray") --上横线到顶了，灰掉
				_frmNode.childUI["ToOtherGamePageDown"].handle.s:setVisible(true) --下翻页提示
				hApi.AddShader(_frmNode.childUI["ToOtherGameListLineHDown"].handle.s, "normal") --下横线需要翻页，正常
			elseif (delta1_ly ~= 0) and (deltNa_ry > 0) then --第一个头像没有贴上侧，并且最后一个头像没有贴下侧，那么再将最后一个推广头像贴边
				--print("将最后一个推广头像贴边")
				--需要修正
				--不会选中推广
				selected_toothergameEx_idx = 0 --选中的推广索引
				
				--没有惯性
				draggle_speed_y_toothergame = 0
				
				local speed = SPEED
				if ((deltNa_ry - speed) < 0) then --防止走过
					speed = deltNa_ry
					deltNa_ry = 0
				end
				
				--每个按钮向下侧做运动
				for i = 1, #hVar.ToOther_Game, 1 do
					local mapId = hVar.ToOther_Game[i] --推广其他游戏的道具商店id
					local mapInfo = hVar.MAP_INFO[mapId]
					if (mapInfo) then
						local ctrli = _frmNode.childUI["ToOtherGameNode" .. i]
					--if (ctrli.data.selected == 0) then --只处理未选中的推广卡牌
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y - speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					--end
					end
				end
				
				--上滑动翻页显示，下滑动翻页不显示
				_frmNode.childUI["ToOtherGamePageUp"].handle.s:setVisible(true) --上分翻页提示
				hApi.AddShader(_frmNode.childUI["ToOtherGameListLineHUp"].handle.s, "normal") --上横线需要翻页，正常
				_frmNode.childUI["ToOtherGamePageDown"].handle.s:setVisible(false) --下分翻页不提示
				hApi.AddShader(_frmNode.childUI["ToOtherGameListLineHDown"].handle.s, "gray") --下横线到顶了，灰掉
			elseif (draggle_speed_y_toothergame ~= 0) then --沿着当前的速度方向有惯性地运动一会
				--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_y_toothergame)
				--不会选中推广
				selected_toothergameEx_idx = 0 --选中的推广索引
				--print("    ->   draggle_speed_y_toothergame=", draggle_speed_y_toothergame)
				
				if (draggle_speed_y_toothergame > 0) then --朝上运动
					local speed = (draggle_speed_y_toothergame) * 1.0 --系数
					friction_toothergame = friction_toothergame - 0.5
					draggle_speed_y_toothergame = draggle_speed_y_toothergame + friction_toothergame --衰减（正）
					
					if (draggle_speed_y_toothergame < 0) then
						draggle_speed_y_toothergame = 0
					end
					
					--最后一个推广的坐标不能跑到最下侧的上边去
					if ((deltNa_ry + speed) > 0) then --防止走过
						speed = -deltNa_ry
						deltNa_ry = 0
						
						--没有惯性
						draggle_speed_y_toothergame = 0
					end
					
					--每个按钮向上侧做运动
					for i = 1, #hVar.ToOther_Game, 1 do
						local mapId = hVar.ToOther_Game[i] --推广其他游戏的道具商店id
						local mapInfo = hVar.MAP_INFO[mapId]
						if (mapInfo) then
							local ctrli = _frmNode.childUI["ToOtherGameNode" .. i]
						--if (ctrli.data.selected == 0) then --只处理未选中的推广卡牌
							local pos_x, pos_y = ctrli.data.x, ctrli.data.y
							
							--本地运动到达的坐标
							local to_x, to_y = pos_x, pos_y + speed
							
							--设置新坐标
							ctrli.data.x = to_x
							ctrli.data.y = to_y
							ctrli.handle._n:setPosition(to_x, to_y)
						--end
						end
					end
				elseif (draggle_speed_y_toothergame < 0) then --朝下运动
					local speed = (draggle_speed_y_toothergame) * 1.0 --系数
					friction_toothergame = friction_toothergame + 0.5
					draggle_speed_y_toothergame = draggle_speed_y_toothergame + friction_toothergame --衰减（负）
					
					if (draggle_speed_y_toothergame > 0) then
						draggle_speed_y_toothergame = 0
					end
					
					--第一个推广的坐标不能跑到最上侧的下边去
					if ((delta1_ly + speed) < 0) then --防止走过
						speed = -delta1_ly
						delta1_ly = 0
						
						--没有惯性
						draggle_speed_y_toothergame = 0
					end
					
					--每个按钮向下侧做运动
					for i = 1, #hVar.ToOther_Game, 1 do
						local mapId = hVar.ToOther_Game[i] --推广其他游戏的道具商店id
						local mapInfo = hVar.MAP_INFO[mapId]
						if (mapInfo) then
							local ctrli = _frmNode.childUI["ToOtherGameNode" .. i]
						--if (ctrli.data.selected == 0) then --只处理未选中的推广卡牌
							local pos_x, pos_y = ctrli.data.x, ctrli.data.y
							
							--本地运动到达的坐标
							local to_x, to_y = pos_x, pos_y + speed
							
							--设置新坐标
							ctrli.data.x = to_x
							ctrli.data.y = to_y
							ctrli.handle._n:setPosition(to_x, to_y)
						--end
						end
					end
				end
				
				--上滑动翻页显示，下滑动翻页显示
				if (delta1_ly == 0) then
					_frmNode.childUI["ToOtherGamePageUp"].handle.s:setVisible(false) --上分翻页提示
					hApi.AddShader(_frmNode.childUI["ToOtherGameListLineHUp"].handle.s, "gray") --上横线到顶了，灰掉
				else
					_frmNode.childUI["ToOtherGamePageUp"].handle.s:setVisible(true) --上分翻页提示
					hApi.AddShader(_frmNode.childUI["ToOtherGameListLineHUp"].handle.s, "normal") --上横线需要翻页，正常
				end
				if (deltNa_ry == 0) then
					_frmNode.childUI["ToOtherGamePageDown"].handle.s:setVisible(false) --下分翻页提示
					hApi.AddShader(_frmNode.childUI["ToOtherGameListLineHDown"].handle.s, "gray") --下横线到顶了，灰掉
				else
					_frmNode.childUI["ToOtherGamePageDown"].handle.s:setVisible(true) --下分翻页提示
					hApi.AddShader(_frmNode.childUI["ToOtherGameListLineHDown"].handle.s, "normal") --下横线需要翻页，正常
				end
			else --停止运动
				b_need_auto_fixing_toothergame = false
				friction_toothergame = 0
			end
		end
	end
	
	--函数：绘制左侧推广其他游戏列表界面（左半部分）（只绘制一次）
	OnCreateCMSTGInfoFrame_LeftPart = function()
		local _frm = hGlobal.UI.CMSTGTipFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--先清空上次推广信息的界面相关控件
		_removeRightFrmFunc()
		
		--初始化参数
		current_OtherGame_max_num = 0
		
		--依次绘制每个地图包的控件
		local validIdx = 0 --有效的id
		for i = 1, #hVar.ToOther_Game, 1 do
			local mapId = hVar.ToOther_Game[i] --推广其他游戏的道具商店id
			local mapInfo = hVar.MAP_INFO[mapId]
			if (mapInfo) then
				local icon = mapInfo.icon --地图包的图标
				--print(score, rmb, bagName, icon)
				
				--标记参数
				validIdx = validIdx + 1 --有效的索引加1
				current_OtherGame_max_num = validIdx --标记最大地图包数量
				
				local xn = (validIdx % TOOTHERGAME_X_NUM) --xn
				if (xn == 0) then
					xn = TOOTHERGAME_X_NUM
				end
				local yn = (validIdx - xn) / TOOTHERGAME_X_NUM + 1 --yn
				
				--地图包的底板
				_frmNode.childUI["ToOtherGameNode" .. i] = hUI.button:new({ --作为按钮只是为了让子控件坐标正常
					parent = _BTC_pClipNode_toothergame,
					--model = "UI:Purchase_BG",
					model = -1, --没有图片
					x = TOOTHERGAME_OFFSET_X + 120 + (xn - 1) * (TOOTHERGAME_WIDTH + 20),
					y = TOOTHERGAME_OFFSET_Y - 174 - (yn - 1) * (TOOTHERGAME_HEIGHT + 25),
					w = TOOTHERGAME_WIDTH,
					h = TOOTHERGAME_HEIGHT,
				})
				leftRemoveFrmList[#leftRemoveFrmList + 1] = "ToOtherGameNode" .. i
				
				--地图包的图标
				_frmNode.childUI["ToOtherGameNode" .. i].childUI["ConfimBtn"] = hUI.image:new({
					parent = _frmNode.childUI["ToOtherGameNode" .. i].handle._n,
					model = icon,
					x = 12,
					y = -10,
					scale = 0.65,
				})
				
				--地图包的名字
				_frmNode.childUI["ToOtherGameNode" .. i].childUI["mapName"] = hUI.label:new({
					parent = _frmNode.childUI["ToOtherGameNode" .. i].handle._n,
					size = 24,
					x = 10,
					y = -85,
					width = 800,
					align = "MC",
					font = hVar.FONTC,
					text = hVar.tab_stringM[mapId] and hVar.tab_stringM[mapId][1] or "未知游戏" .. mapId, --bagName
					border = 1,
				})
				
				--推广的选中边框
				_frmNode.childUI["ToOtherGameNode" .. i].childUI["selectbox"] = hUI.image:new({
					parent = _frmNode.childUI["ToOtherGameNode" .. i].handle._n,
					model = "UI:skill_point", --"UI:TacTicFrame",
					x = 10,
					y = -5,
					w = TOOTHERGAME_WIDTH + 20,
					h = TOOTHERGAME_HEIGHT + 30,
					z = -1,
				})
				_frmNode.childUI["ToOtherGameNode" .. i].childUI["selectbox"].handle.s:setVisible(false) --默认不显示选中框
			end
		end
		
		--更新左侧选中框
		--隐藏上一次的选中框
		--_frmNode.childUI["ToOtherGameSelectBox" .. last_achieve_idx].childUI["ToOtherGameSelectBox"].handle._n:setVisible(false)
		
		--显示本次的
		--_frmNode.childUI["ToOtherGameNode" .. current_focus_toothergameEx_idx].childUI["ToOtherGameSelectBox"].handle._n:setVisible(true)
		
		--更新提示翻页的按钮
		--不显示上翻页提示
		_frmNode.childUI["ToOtherGamePageUp"].handle.s:setVisible(false)
		hApi.AddShader(_frmNode.childUI["ToOtherGameListLineHUp"].handle.s, "gray") --上横线到顶了，灰掉
		
		--如果推广其他游戏数量未铺满第一页，那么不显示下翻页提示
		if (current_OtherGame_max_num <= (TOOTHERGAME_X_NUM * TOOTHERGAME_Y_NUM)) then
			_frmNode.childUI["ToOtherGamePageDown"].handle.s:setVisible(false)
			hApi.AddShader(_frmNode.childUI["ToOtherGameListLineHDown"].handle.s, "gray") --下横线到顶了，灰掉
		else --需要翻页
			_frmNode.childUI["ToOtherGamePageDown"].handle.s:setVisible(true)
			hApi.AddShader(_frmNode.childUI["ToOtherGameListLineHDown"].handle.s, "normal") --下横线需要翻页，正常
		end
	end
	
	--函数：显示某个推广其他游戏的详细信息（右半部分）
	OnCreateCMSTGInfoFrame_RightPart = function(idxEx)
		local _frm = hGlobal.UI.CMSTGTipFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--不重复显示
		if (CurrentSelectRecord.contentIdx == idxEx) then
			return
		end
		
		--标记选中本次
		local lastSelectedContentIdx = CurrentSelectRecord.contentIdx
		CurrentSelectRecord.contentIdx = idxEx
		--print(lastSelectedContentIdx, idxEx)

		local mapId = hVar.ToOther_Game[idxEx] --推广其他游戏的道具商店id
		local mapInfo = hVar.MAP_INFO[mapId]
		if (mapInfo and mapInfo.togameurl) then
			local url = mapInfo.togameurl
			local imgBg = mapInfo.imgGameBg
		
			--隐藏上一次的选中框、标题白色颜色
			if (lastSelectedContentIdx > 0) then
				_frmNode.childUI["ToOtherGameNode" .. lastSelectedContentIdx].childUI["selectbox"].handle.s:setVisible(false)
				_frmNode.childUI["ToOtherGameNode" .. lastSelectedContentIdx].childUI["mapName"].handle.s:setColor(ccc3(255, 255, 255))
			end
			
			--显示选中框、标题黄色颜色
			--print("idxEx", idxEx, _frmNode.childUI["ToOtherGameNode" .. idxEx], _frmNode.childUI["ToOtherGameNode" .. idxEx].childUI["selectbox"])
			_frmNode.childUI["ToOtherGameNode" .. idxEx].childUI["selectbox"].handle.s:setVisible(true)
			_frmNode.childUI["ToOtherGameNode" .. idxEx].childUI["mapName"].handle.s:setColor(ccc3(255, 255, 0))
			
			--先清除右侧的控件集
			_removeRightFrmFunc()
			
			--开始创建本推广其他游戏的详细信息
			local offsetX = 50
			local offsetY = -10
			local BG_WIDTH = 512 --底板宽度
			local BG_HEIGHT = 256 --底板高度
			
			--右侧底板3
			_frmNode.childUI["imgBg1"] = hUI.button:new({
				parent = _parentNode,
				model = "misc/mask.png",
				x = TOOTHERGAME_OFFSET_X + 540,
				y = TOOTHERGAME_OFFSET_Y - 220,
				w = BG_WIDTH + 4,
				h = BG_HEIGHT + 4,
			})
			_frmNode.childUI["imgBg1"].handle.s:setOpacity(0) --只挂载子控件，不显示
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "imgBg1"
			local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", 0, 0, BG_WIDTH + 4, BG_HEIGHT + 4, _frmNode.childUI["imgBg1"])
			--img9:setOpacity(204)
			
			--右侧底板
			_frmNode.childUI["imgBg2"] = hUI.image:new({
				parent = _parentNode,
				model = "misc/gray_mask_16.png",
				x = TOOTHERGAME_OFFSET_X + 540,
				y = TOOTHERGAME_OFFSET_Y - 220,
				w = BG_WIDTH,
				h = BG_HEIGHT,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "imgBg2"
			_frmNode.childUI["imgBg2"].handle.s:setColor(ccc3(168, 168, 168))

			--游戏app宣传图片
			_frmNode.childUI["imgToApp"] = hUI.image:new({
				parent = _parentNode,
				model = imgBg,
				x = TOOTHERGAME_OFFSET_X + 540,
				y = TOOTHERGAME_OFFSET_Y - 220,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "imgToApp"
			
			--游戏app文字
			_frmNode.childUI["labToApp"] = hUI.label:new({
				parent = _parentNode,
				size = 26,
				align = "MC",
				font = hVar.FONTC,
				x = TOOTHERGAME_OFFSET_X + 550,
				y = TOOTHERGAME_OFFSET_Y - 390,
				width = 500,
				border = 1,
				text = hVar.tab_string["App_Download_CMSTG_lab"]
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "labToApp"

			--去游戏app下载链接（按钮）
			_frmNode.childUI["btnToApp"] = hUI.button:new({
				parent = _parentNode,
				model = "UI:toapp",
				x = TOOTHERGAME_OFFSET_X + 550,
				y = TOOTHERGAME_OFFSET_Y - 500,
				w = 221,
				h = 85,
				scaleT = 0.99,
				dragbox = _frm.childUI["dragBox"],
				code = function()
					xlOpenUrl(url)
				end,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnToApp"
		end
	end
	
	--监听打开推广其他游戏界面通知事件
	hGlobal.event:listen("LocalEvent_ShowCMSTGTipFrm", "ShowCMSTGTipFrm", function()
		
		--显示推广其他游戏界面
		hGlobal.UI.CMSTGTipFrm:show(1)
		hGlobal.UI.CMSTGTipFrm:active()
		
		--打开上一次的分页（默认显示第1个分页: 推广其他游戏）
		local lastPageIdx = CurrentSelectRecord.pageIdx
		if (lastPageIdx == 0) then
			lastPageIdx = 1
		end
		
		CurrentSelectRecord.pageIdx = 0
		CurrentSelectRecord.contentIdx = 0
		OnClickPageBtn(lastPageIdx)
	end)
end


--test
--[[
--测试代码
if hGlobal.UI.CMSTGTipFrm then --删除上一次的推广其他游戏界面
	hGlobal.UI.CMSTGTipFrm:del()
	hGlobal.UI.CMSTGTipFrm = nil
end
hGlobal.UI.InitDLCMapInfoFrm() --测试创建界面
--触发事件，显示推广其他游戏界面
hGlobal.event:event("LocalEvent_ShowCMSTGTipFrm", 0)
]]

