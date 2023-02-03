


--排行榜操作面板
hGlobal.UI.InitRankBoradFrm = function(mode)
	--不重复创建
	if hGlobal.UI.PhoneRankBoardFrm then --排行榜操作面板
		return
	end
	
	local BOARD_WIDTH = 840 --排行榜面板的宽度
	local BOARD_HEIGHT = 550 --排行榜面板的高度
	local BOARD_OFFSETY = -20 --排行榜面板y偏移中心点的值
	local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 --排行榜面板的x位置（最左侧）
	local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --排行榜面板的y位置（最顶侧）
	local BOARD_ACTIVE_WIDTH = 508 --排行榜面板活动宽度（卡牌显示的宽度）
	
	local PAGE_BTN_LEFT_X = 120 --第一个分页按钮的x偏移
	local PAGE_BTN_LEFT_Y = -23 --第一个分页按钮的y偏移
	local PAGE_BTN_OFFSET_X = 140 --每个分页按钮的间距
	
	--临时UI管理
	local leftRemoveFrmList = {} --左侧控件集
	local rightRemoveFrmList = {} --右侧控件集
	local _removeLeftFrmFunc = hApi.DoNothing --清空左侧所有的临时控件
	local _removeRightFrmFunc = hApi.DoNothing --清空右侧所有的临时控件
	
	--局部函数
	local OnClickPageBtn = hApi.DoNothing --点击分页按钮
	--local RefreshBillboardFinishPage = hApi.DoNothing --更新提示当前哪个分页可以有领取的了
	
	--分页1：排行榜函数部分
	local OnCreateRankBoardFrame = hApi.DoNothing --创建排行榜界面（第1个分页）
	local OnRefreshRankBoardFrame = hApi.DoNothing --显示某个指定的排行榜界面
	local OnCreateSingleBoardData = hApi.DoNothing --绘制单条排行榜的信息
	local OnCreateRankBoardTipFrame = hApi.DoNothing --排榜榜规则介绍tip
	local refresh_rank_board_UI_loop = hApi.DoNothing --刷新排行榜界面的滚动
	local on_receive_refresh_systime_event = hApi.DoNothing --收到获得系统时间的回调
	local on_receive_billboardT_event = hApi.DoNothing --收到排行榜静态数据模板的回调
	local on_receive_billboard_event = hApi.DoNothing --收到排行榜当前排行数据的回调
	local on_enter_background_event = hApi.DoNothing --收到程序进入后台的回调
	local on_query_billboard_info_timer = hApi.DoNothing --定时向服务器查询当前的排行数据
	
	--分页1：排行榜相关参数
	local BILLBOARD_WIDTH = 624 --排行榜宽度
	local BILLBOARD_HEIGHT = 30 --排行榜高度
	local BILLBOARD_X_NUM = 1 --排行榜xn的数量
	local BILLBOARD_Y_NUM = 14 --排行榜yn的数量
	local BILLBOARD_NODE_OFFSET_X = 90 --排行榜统一偏移x
	local BILLBOARD_NODE_OFFSET_Y = 28 --排行榜统一偏移y
	local BILLBOARD_NODE_WIDTH = 230 --排行榜宽度
	local BILLBOARD_NODE_HEIGHT = 550 --排行榜高度
	local BILLBOARD_NODE_EACHOFFSET = 25 --排行榜x间距
	local MAX_SPEED = 50 --最大速度
	
	local current_mapName_entry = 0 --通过哪个地图点进来的
	local current_focus_billboardEx_idx = 1 --当前显示的排行榜ex的索引值（默认选中第一个）
	local current_billId = 1
	local current_billboardT = nil --排行榜的静态表
	local current_billboardData = {bId = 1, num = 0, info = {}, nameMe = "", rankMe = 0, rankingMe = 0} --排行榜的排行数据表
	local last_query_board_time = 0 --上一次获取排行榜的时间
	local last_local_board_score = 0 --上一次的本地排行榜得分
	local current_STATE = 0 --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
	--local current_enter_bg = 0 --当前程序是否在后台（如果进入后台，就不用定时器刷新排行榜情况）
	local last_timer_query_time = 0 --上一次timer取排行榜的时间
	local QUERY_DELTA_SECOND = 180 --查询间隔秒数
	
	local click_pos_x_billboard = 0 --开始按下的坐标x
	local click_pos_y_billboard = 0 --开始按下的坐标y
	local last_click_pos_y_billboard = 0 --上一次按下的坐标x
	local last_click_pos_y_billboard = 0 --上一次按下的坐标y
	local draggle_speed_y_billboard = 0 --当前滑动的速度x
	local selected_billboardEx_idx = 0 --选中的排行榜ex索引
	local click_scroll_billboard = false --是否在滑动排行榜中
	local b_need_auto_fixing_billboard = false --是否需要自动修正
	local friction_billboard = 0 --阻力
	
	--当前选中的记录
	local CurrentSelectRecord = {pageIdx = 0, contentIdx = 0, cardId = 0,} --当前选择的分页、数据项的信息记录
	
	--加载资源
	--xlLoadResourceFromPList("data/image/misc/pvp.plist")
	
	hApi.clearTimer("__RANK_BOARD_UPDATE__")
	hApi.clearTimer("__RANK_QUERY_TIMER__")
	
	--创建排行榜操作面板
	hGlobal.UI.PhoneRankBoardFrm = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 2,
		show = 0, --一开始不显示
		border = 1, --显示frame边框
		background = "UI:Tactic_Background",
		--background = "UI:herocardfrm",
		autoactive = 0,
		--全部事件
		--codeOnDragEx = function(touchX, touchY, touchMode)
			--
		--end,
	})
	
	local _frm = hGlobal.UI.PhoneRankBoardFrm
	local _parent = _frm.handle._n
	
	--左侧裁剪区域
	local _BTC_PageClippingRect = {0, -45, 900, 470, 0}
	local _BTC_pClipNode_Rankboard = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect, 99, _BTC_PageClippingRect[5], "_BTC_pClipNode_Rankboard")
	
	--关闭按钮
	local closeDx = -5
	local closeDy = -5
	if (g_phone_mode ~= 0) then
		closeDx = 0
		closeDy = -20
	end
	--btnClose
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		model = "BTN:PANEL_CLOSE",
		x = _frm.data.w + closeDx,
		y = closeDy,
		scaleT = 0.95,
		code = function()
			--触发事件：刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
			--hGlobal.event:event("LocalEvent_RefreshMedalStateUI")
			
			--不显示排行榜面板
			hGlobal.UI.PhoneRankBoardFrm:show(0)
			
			--关闭界面后不需要监听的事件
			--取消监听：收到网络宝箱数量的事件
			--hGlobal.event:listen("LocalEvent_getNetChestNum", "__ItemGetChestNum_Frm", nil)
			
			--清空切换分页之后取消的监听事件
			--移除事件监听：收到服务器时间的回调
			hGlobal.event:listen("localEvent_refresh_Systime", "__QueryBillBoardTime", nil)
			--移除事件监听：收到排行榜静态数据模板的回调
			hGlobal.event:listen("localEvent_refresh_billboardT", "__QueryBillBoardT", nil)
			--移除事件监听：收到排行榜当前排行数据的回调
			hGlobal.event:listen("localEvent_refresh_billboard", "__QueryBillBoard", nil)
			--移除事件监听：程序进入后台的回调
			hGlobal.event:listen("LocalEvent_AppEnterBackground", "__QueryBillBoardEnterBG", nil)
			
			--清空上次分页的全部信息
			_removeLeftFrmFunc()
			_removeRightFrmFunc()
			
			--删除排行榜刷新界面timer
			hApi.clearTimer("__RANK_BOARD_UPDATE__")
			hApi.clearTimer("__RANK_QUERY_TIMER__")
			
			--标记当前状态
			current_STATE = 0 --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
			--current_enter_bg = 0 --当前程序是否在后台（如果进入后台，就不用定时器刷新排行榜情况）
			last_timer_query_time = 0 --上一次timer取排行榜的时间
			
			--关闭金币、积分界面
			--hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
			
			--触发事件：关闭了主菜单按钮
			--hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
			--如果是通过哪个地图传进来的，关闭界面之后，再打开之前的界面
			if current_mapName_entry and (current_mapName_entry ~= 0) then
				hGlobal.event:event("LocalEvent_Phone_ShowEndlessMapInfoFrm", current_mapName_entry)
			end
		end,
	})
	
	--面板的标题栏背景图
	_frm.childUI["frameTitleBG"] = hUI.image:new({
		parent = _parent,
		model = "UI:MedalDarkImg", --"UI:Tactic_Button",
		x = PAGE_BTN_LEFT_X + 296,
		y = PAGE_BTN_LEFT_Y + 53,
		w = 220 + 50,
		h = 40,
	})
	
	--面板的标题文字
	_frm.childUI["frameTitleBG"] = hUI.label:new({
		parent = _parent,
		x = PAGE_BTN_LEFT_X + 296,
		y = PAGE_BTN_LEFT_Y + 53 - 3,
		size = 32,
		align = "MC",
		border = 1,
		font = hVar.FONTC,
		width = 300,
		--text = "无尽试炼每日排行", --language
		text = hVar.tab_string[hVar.BILL_BOARD_MAP[1].name], --language
	})
	
	--每个分页按钮
	--排行榜
	local tPageIcons = {"ui/top100.png",}
	--local tTexts = {"排行榜",} --language
	local tTexts = {hVar.tab_string["__TEXT_PlayerRank"],} --language
	for i = 1, #tPageIcons, 1 do
		--分页按钮
		_frm.childUI["PageBtn" .. i] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			x = PAGE_BTN_LEFT_X + (i - 1) * PAGE_BTN_OFFSET_X,
			y = PAGE_BTN_LEFT_Y,
			w = 130,
			h = 60,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function(self, screenX, screenY, isInside)
				OnClickPageBtn(i)
			end,
		})
		_frm.childUI["PageBtn" .. i].handle.s:setOpacity(0) --分页按钮点击区域，只作为控制用，不用于显示
		
		--分页按钮的方块图标
		_frm.childUI["PageBtn" .. i].childUI["PageImage"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = "UI:Tactic_Button",
			x = 0,
			y = 0,
			w = 116,
			h = 48,
		})
		
		--分页按钮的图标
		_frm.childUI["PageBtn" .. i].childUI["PageIcon"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = tPageIcons[i],
			x = -40,
			y = 5,
			w = 32,
			h = 32,
		})
		
		--分页按钮的提示升级的动态箭头标识
		_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = "ICON:image_jiantouV",
			x = -40,
			y = 5 + 3,
			w = 32,
			h = 32,
		})
		_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"].handle.s:setVisible(false) --默认一开始不显示提示该分页升级的动态箭头
		
		--分页按钮的文字
		_frm.childUI["PageBtn" .. i].childUI["Text"] = hUI.label:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			x = 10,
			y = 3,
			size = 26,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 100,
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
		local _frm = hGlobal.UI.PhoneRankBoardFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneRankBoardFrm
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
		
		--本面板，不显示按钮
		--[[
		--启用全部的按钮
		for i = 1, #tPageIcons, 1 do
			_frm.childUI["PageBtn" .. i]:setstate(1) --按钮可用
			_frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s:setVisible(true) --显示图片
			_frm.childUI["PageBtn" .. i].childUI["PageIcon"].handle.s:setVisible(true) --显示图标
			_frm.childUI["PageBtn" .. i].childUI["Text"].handle.s:setVisible(true) --显示文字
		end
		
		--当前按钮高亮
		hApi.AddShader(_frm.childUI["PageBtn" .. pageIndex].childUI["PageImage"].handle.s, "normal")
		
		--其它按钮灰掉
		for i = 1, #tPageIcons, 1 do
			if (i ~= pageIndex) then
				hApi.AddShader(_frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s, "gray")
			end
		end
		]]
		for i = 1, #tPageIcons, 1 do
			_frm.childUI["PageBtn" .. i]:setstate(-1) --按钮不可用
		end
		
		--先清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--清空切换分页之后取消的监听事件
		--移除事件监听：收到服务器时间的回调
		hGlobal.event:listen("localEvent_refresh_Systime", "__QueryBillBoardTime", nil)
		--移除事件监听：收到排行榜静态数据模板的回调
		hGlobal.event:listen("localEvent_refresh_billboardT", "__QueryBillBoardT", nil)
		--移除事件监听：收到排行榜当前排行数据的回调
		hGlobal.event:listen("localEvent_refresh_billboard", "__QueryBillBoard", nil)
		--移除事件监听：程序进入后台的回调
		hGlobal.event:listen("LocalEvent_AppEnterBackground", "__QueryBillBoardEnterBG", nil)
		
		--移除本分页的timer
		hApi.clearTimer("__RANK_BOARD_UPDATE__")
		hApi.clearTimer("__RANK_QUERY_TIMER__")
		
		--隐藏所有的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Rankboard", 0)
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：排行榜
			--创建排行榜分页
			OnCreateRankBoardFrame(pageIndex)
		end
		
		--标记当前选择的分页和页内的第几个
		CurrentSelectRecord.pageIdx = pageIndex
		CurrentSelectRecord.contentIdx = 0
	end
	
	--函数：创建排行榜界面（第1个分页）
	OnCreateRankBoardFrame = function(pageIdx)
		local _frm = hGlobal.UI.PhoneRankBoardFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--允许本分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Rankboard", 1)
		
		--local i = 3
		
		--[[
		--左侧排行榜列表底板
		_frmNode.childUI["BillboardListBG2"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:TacticBG",
			x = BILLBOARD_NODE_OFFSET_X + 308,
			y = BILLBOARD_NODE_OFFSET_Y - 320,
			w = 750,
			h = BILLBOARD_NODE_HEIGHT + 4,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BillboardListBG2"
		
		--左侧排行榜列表底板
		_frmNode.childUI["BillboardListBG"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_Background", --"misc/gray_mask_16.png",
			x = BILLBOARD_NODE_OFFSET_X + 308,
			y = BILLBOARD_NODE_OFFSET_Y - 320,
			w = 746,
			h = BILLBOARD_NODE_HEIGHT,
		})
		--_frmNode.childUI["BillboardListBG"].handle.s:setColor(ccc3(168, 168, 168))
		--_frmNode.childUI["BillboardListBG"].handle.s:setOpacity(0)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BillboardListBG"
		]]
		
		--左侧排行榜列表提示上翻页的图片
		_frmNode.childUI["BillboardPageUp"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = BILLBOARD_NODE_OFFSET_X + 325,
			y = BILLBOARD_NODE_OFFSET_Y - 47,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["BillboardPageUp"].handle.s:setRotation(90)
		_frmNode.childUI["BillboardPageUp"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_frmNode.childUI["BillboardPageUp"].handle.s:setVisible(false) --默认不显示左分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BillboardPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["BillboardPageUp"].handle._n:runAction(forever)
		
		--左侧排行榜列表提示下翻页的图片
		_frmNode.childUI["BillboardPageDown"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = BILLBOARD_NODE_OFFSET_X + 325 + 7, --非对称的翻页图
			y = BILLBOARD_NODE_OFFSET_Y - 559,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["BillboardPageDown"].handle.s:setRotation(270)
		_frmNode.childUI["BillboardPageDown"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		_frmNode.childUI["BillboardPageDown"].handle.s:setVisible(false) --默认不显示下分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BillboardPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["BillboardPageDown"].handle._n:runAction(forever)
		
		--左侧向上翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["BillboardPageUp_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = BILLBOARD_NODE_OFFSET_X + 328,
			y = BILLBOARD_NODE_OFFSET_Y - 40,
			w = 300,
			h = 50,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (current_billboardData.num > (BILLBOARD_X_NUM * BILLBOARD_Y_NUM)) then
					--print("向下滚屏", screenY)
					--向下滚屏
					b_need_auto_fixing_billboard = true
					friction_billboard = 0
					draggle_speed_y_billboard = -MAX_SPEED / 2.0 --负速度
				end
			end,
		})
		_frmNode.childUI["BillboardPageUp_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BillboardPageUp_Btn"
		
		--左侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["BillboardPageDown_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = BILLBOARD_NODE_OFFSET_X + 328,
			y = BILLBOARD_NODE_OFFSET_Y - 566,
			w = 300,
			h = 50,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (current_billboardData.num > (BILLBOARD_X_NUM * BILLBOARD_Y_NUM)) then
					--print("向上滚屏", screenY)
					--向上滚屏
					b_need_auto_fixing_billboard = true
					friction_billboard = 0
					draggle_speed_y_billboard = MAX_SPEED / 2.0 --正速度
				end
			end,
		})
		_frmNode.childUI["BillboardPageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BillboardPageDown_Btn"
		
		--左侧用于检测滑动事件的控件
		_frmNode.childUI["BillboardDragPanel"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = BILLBOARD_NODE_OFFSET_X + 330,
			y = BILLBOARD_NODE_OFFSET_Y - 307,
			w = 840,
			h = BILLBOARD_NODE_HEIGHT - 75,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--print("codeOnTouch", touchX, touchY, sus)
				click_pos_x_billboard = touchX --开始按下的坐标x
				click_pos_y_billboard = touchY --开始按下的坐标y
				last_click_pos_y_billboard = touchX --上一次按下的坐标x
				last_click_pos_y_billboard = touchY --上一次按下的坐标y
				draggle_speed_y_billboard = 0 --当前速度为0
				selected_billboardEx_idx = 0 --选中的排行榜ex索引
				click_scroll_billboard = true --是否滑动排行榜
				b_need_auto_fixing_billboard = false --不需要自动修正位置
				friction_billboard = 0 --无阻力
				
				--如果排行榜数量未铺满一页，那么不需要滑动
				if (current_billboardData.num <= (BILLBOARD_X_NUM * BILLBOARD_Y_NUM)) then
					click_scroll_billboard = false --不需要滑动排行榜
				end
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
				--处理移动速度y
				draggle_speed_y_billboard = touchY - last_click_pos_y_billboard
				
				if (draggle_speed_y_billboard > MAX_SPEED) then
					draggle_speed_y_billboard = MAX_SPEED
				end
				if (draggle_speed_y_billboard < -MAX_SPEED) then
					draggle_speed_y_billboard = -MAX_SPEED
				end
				
				--print("click_scroll_billboard=", click_scroll_billboard)
				--在滑动过程中才会处理滑动 
				if click_scroll_billboard then
					local deltaY = touchY - last_click_pos_y_billboard --与开始按下的位置的偏移值x
					--如果当前的查询状态是在查询服务器时间，或者查询静态数据，那么不能处理
					if (current_STATE == 3) then --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
						--注意: 如果刚打开界面的瞬间，子控件都被删掉了，而这点击屏幕，并且有上一次排行榜缓存数据，逻辑会走到这，但是此时界面还没，会弹框
						if (_frmNode.childUI["BillboardNode1"] ~= nil) then
							for i = 1, current_billboardData.num, 1 do
								local ctrli = _frmNode.childUI["BillboardNode" .. i]
								ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
								ctrli.data.x = ctrli.data.x
								ctrli.data.y = ctrli.data.y + deltaY
							end
						end
					end
				end
				
				--存储本次的位置
				last_click_pos_y_billboard = touchX
				last_click_pos_y_billboard = touchY
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_billboard then
					--if (touchX ~= click_pos_x_billboard) or (touchY ~= click_pos_y_billboard) then --不是点击事件
						b_need_auto_fixing_billboard = true
						friction_billboard = 0
					--end
				end
				
				--检测
				--检测点击到了哪个排行榜框内
				--如果当前的查询状态是在查询服务器时间，或者查询静态数据，那么不能处理
				if (current_STATE == 3) then --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
					--注意: 如果刚打开界面的瞬间，子控件都被删掉了，而这点击屏幕，并且有上一次排行榜缓存数据，逻辑会走到这，但是此时界面还没，会弹框
					if (_frmNode.childUI["BillboardNode1"] ~= nil) then
						for i = 1, current_billboardData.num, 1 do
							local ctrli = _frmNode.childUI["BillboardNode" .. i]
							local cx = ctrli.data.x --中心点x坐标
							local cy = ctrli.data.y --中心点y坐标
							local cw, ch = ctrli.data.w, ctrli.data.h
							local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
							local rx, ry = lx + cw, ly + ch --最右下角坐标
							--print(i, lx, rx, touchX)
							--print("click" ..  i,  "x=" .. ctrli.data.x, touchX, touchY, lx, rx, ly, ry)
							if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
								selected_billboardEx_idx = i
								
								break
								--print("点击到了哪个排行榜的框内" .. i)
							end
						end
					end
				end
				
				--这种情况请注意：在触发滑动操作（排行榜数量大于一页），并且按下坐标和抬起坐标偏差过大，则认为该操作是滑动，不触发选择卡牌
				if (click_scroll_billboard) and (math.abs(touchY - click_pos_y_billboard) > BILLBOARD_HEIGHT) then
					selected_billboardEx_idx = 0
				end
				--print("selected_billboardEx_idx", selected_billboardEx_idx)
				
				--之前选中了某个排行榜
				if (selected_billboardEx_idx > 0) then
					OnRefreshRankBoardFrame(selected_billboardEx_idx)
					
					--selected_billboardEx_idx = 0
				end
				
				--标记不用滑动
				click_scroll_billboard = false
			end,
		})
		_frmNode.childUI["BillboardDragPanel"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BillboardDragPanel"
		
		--转圈圈的图: 右上角小菊花
		_frmNode.childUI["waiting"] = hUI.image:new({
			parent = _parentNode,
			model = "MODEL_EFFECT:waiting",
			x = BILLBOARD_NODE_OFFSET_X + 670,
			y = BILLBOARD_NODE_OFFSET_Y - 48,
			w = 36,
			h = 36,
		})
		_frmNode.childUI["waiting"].handle.s:setVisible(false) --一开始不显示小菊花
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "waiting"
		
		------------------------------------------------------------------
		--左侧排行榜的各列的标题
		
		--[[
		--排行的底纹
		_frmNode.childUI["RankColBG"] = hUI.image:new({
			parent = _parentNode,
			x = BILLBOARD_NODE_OFFSET_X + 320,
			y = BILLBOARD_NODE_OFFSET_Y - 140 + 90,
			model = "UI:AttrBg", --UI:login_lk", --"misc/y_mask_16.png",
			w = 800,
			h = BILLBOARD_HEIGHT,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RankColBG"
		]]
		
		--排行的名次
		_frmNode.childUI["RankCol1"] = hUI.label:new({
			parent = _parentNode,
			x = BILLBOARD_NODE_OFFSET_X + 25 - 40,
			y = BILLBOARD_NODE_OFFSET_Y - 140 + 89,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
			--text = "排名", --language
			text = hVar.tab_string["__TEXT_RankNum"], --language
		})
		_frmNode.childUI["RankCol1"].handle.s:setColor(ccc3(255, 255, 223))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RankCol1"
		
		--排行的玩家名
		_frmNode.childUI["RankCol2"] = hUI.label:new({
			parent = _parentNode,
			x = BILLBOARD_NODE_OFFSET_X + 25 + 140,
			y = BILLBOARD_NODE_OFFSET_Y - 140 + 89,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
			--text = "玩家名", --language
			text = hVar.tab_string["__TEXT_PlayerName"], --language
		})
		_frmNode.childUI["RankCol2"].handle.s:setColor(ccc3(255, 255, 223))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RankCol2"
		
		--排行的得分
		_frmNode.childUI["RankCol3"] = hUI.label:new({
			parent = _parentNode,
			x = BILLBOARD_NODE_OFFSET_X + 25 + 330,
			y = BILLBOARD_NODE_OFFSET_Y - 140 + 89,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
			--text = "得分", --language
			text = hVar.tab_string["__TEXT_Score"], --language
		})
		_frmNode.childUI["RankCol3"].handle.s:setColor(ccc3(255, 255, 223))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RankCol3"
		
		--排行的奖励
		_frmNode.childUI["RankCol4"] = hUI.label:new({
			parent = _parentNode,
			x = BILLBOARD_NODE_OFFSET_X + 25 + 550,
			y = BILLBOARD_NODE_OFFSET_Y - 140 + 89,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
			--text = "奖励", --language
			text = hVar.tab_string["__Reward__"], --language
		})
		_frmNode.childUI["RankCol4"].handle.s:setColor(ccc3(255, 255, 223))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RankCol4"
		
		--我的底纹
		_frmNode.childUI["MyRankColBG"] = hUI.image:new({
			parent = _parentNode,
			x = BILLBOARD_NODE_OFFSET_X + 320,
			y = BILLBOARD_NODE_OFFSET_Y - 140 - 420,
			model = "UI:AttrBg", --UI:login_lk", --"misc/y_mask_16.png",
			w = 800,
			h = BILLBOARD_HEIGHT,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "MyRankColBG"
		
		--"我的排名"文字前缀
		_frmNode.childUI["MyRankCol1"] = hUI.label:new({
			parent = _parentNode,
			x = BILLBOARD_NODE_OFFSET_X + 25 - 70,
			y = BILLBOARD_NODE_OFFSET_Y - 140 - 422,
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 300,
			border = 1,
			--text = "我的排名", --language
			text = hVar.tab_string["__TEXT_MyRank"], --language
		})
		_frmNode.childUI["MyRankCol1"].handle.s:setColor(ccc3(0, 255, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "MyRankCol1"
		
		--"我的得分"文字前缀
		_frmNode.childUI["MyRankCol2"] = hUI.label:new({
			parent = _parentNode,
			x = BILLBOARD_NODE_OFFSET_X + 25 + 380,
			y = BILLBOARD_NODE_OFFSET_Y - 140 - 422,
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 300,
			border = 1,
			--text = "我的得分", --language
			text = hVar.tab_string["__TEXT_MyScore"], --language
		})
		_frmNode.childUI["MyRankCol2"].handle.s:setColor(ccc3(0, 255, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "MyRankCol2"
		
		--排行榜规则(问号)按钮（响应区域）
		_frmNode.childUI["btnBoardIntro"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = BILLBOARD_NODE_OFFSET_X + 674,
			y = BILLBOARD_NODE_OFFSET_Y - 140 - 413,
			w = 128,
			h = 48,
			model = "misc/mask.png",
			scaleT = 1.0,
			scale = 1.0,
			code = function()
				--创建排榜榜规则介绍tip
				OnCreateRankBoardTipFrame()
			end,
		})
		_frmNode.childUI["btnBoardIntro"].handle.s:setOpacity(0) --用于响应事件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnBoardIntro"
		--问号图标
		_frmNode.childUI["btnBoardIntro"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["btnBoardIntro"].handle._n,
			dragbox = _frm.childUI["dragBox"],
			x = 0,
			y = 0,
			scale = 0.9,
			model = "ICON:action_info",
		})
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(1.0, 0.94) ,CCScaleTo:create(1.0, 0.86))
		local forever = CCRepeatForever:create(tolua.cast(towAction,"CCActionInterval"))
		_frmNode.childUI["btnBoardIntro"].childUI["icon"].handle._n:runAction(forever)
		_frmNode.childUI["btnBoardIntro"].childUI["icon"].handle.s:setVisible(false) --一开始不显示问号
		
		--添加本分页的监听事件
		--监听：收到服务器时间的回调
		hGlobal.event:listen("localEvent_refresh_Systime", "__QueryBillBoardTime", on_receive_refresh_systime_event)
		--监听：收到排行榜静态数据模板的回调
		hGlobal.event:listen("localEvent_refresh_billboardT", "__QueryBillBoardT", on_receive_billboardT_event)
		--监听：收到排行榜当前排行数据的回调
		hGlobal.event:listen("localEvent_refresh_billboard", "__QueryBillBoard", on_receive_billboard_event)
		--监听：程序进入后台的回调
		hGlobal.event:listen("LocalEvent_AppEnterBackground", "__QueryBillBoardEnterBG", on_enter_background_event)
		
		--创建只有本分页下才有的timer，刷新排行榜滚动
		hApi.addTimerForever("__RANK_BOARD_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_rank_board_UI_loop)
		
		--添加本分页的timer，定时取排行榜最新排名
		hApi.addTimerForever("__RANK_QUERY_TIMER__", hVar.TIMER_MODE.GAMETIME, QUERY_DELTA_SECOND * 1000, on_query_billboard_info_timer)
		
		--初始化当前状态
		current_STATE = 0 --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
		--current_enter_bg = 0 --当前程序是否在后台（如果进入后台，就不用定时器刷新排行榜情况）
		last_timer_query_time = 0 --上一次timer取排行榜的时间
		
		if (g_cur_net_state == -1) then --未联网
			--未联网的提示文字
			_frmNode.childUI["connnetFail"] = hUI.label:new({
				parent = _parentNode,
				x = BILLBOARD_NODE_OFFSET_X + 310 + 18,
				y = BILLBOARD_NODE_OFFSET_Y - 310,
				size = 28,
				font = hVar.FONTC,
				align = "MC",
				width = 300,
				border = 1,
				--text = "查看排行榜需要联网", --language
				text = hVar.tab_string["__TEXT_Cant_UseDepletion8_Net"], --language
			})
			_frmNode.childUI["connnetFail"].handle.s:setColor(ccc3(168, 168, 168))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "connnetFail"
		else --已联网
			--显示正在网络查询的小菊花
			_frmNode.childUI["waiting"].handle.s:setVisible(true)
			
			--创建联网的: 文字
			_frmNode.childUI["ActivityWaitingLabel"] = hUI.label:new({
				parent = _parentNode,
				x = BILLBOARD_NODE_OFFSET_X + 310 + 18,
				y = BILLBOARD_NODE_OFFSET_Y - 310,
				size = 28,
				font = hVar.FONTC,
				align = "MC",
				width = 300,
				border = 1,
				--text = "正在获取排行榜", --language
				text = hVar.tab_string["__TEXT_Getting__"] .. hVar.tab_string["__TEXT_PlayerRank"], --language
			})
			_frmNode.childUI["ActivityWaitingLabel"].handle.s:setColor(ccc3(168, 168, 168))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "ActivityWaitingLabel"
			
			--转圈圈的图: 大菊花
			_frmNode.childUI["waitingBigImg"] = hUI.image:new({
				parent = _parentNode,
				model = "MODEL_EFFECT:waiting",
				x = BILLBOARD_NODE_OFFSET_X + 310 + 18,
				y = BILLBOARD_NODE_OFFSET_Y - 240,
				scale = 1.0,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "waitingBigImg"
			
			--标记状态为正在查询服务器时间
			current_STATE = 1 --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
			
			--发起查询服务器系统时间
			SendCmdFunc["refresh_systime"]()
		end
	end
	
	--函数：收到系统时间的回调
	on_receive_refresh_systime_event = function()
		local _frm = hGlobal.UI.PhoneRankBoardFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		if (current_STATE == 1) then --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
			--标记当前状态为正在查询静态数据
			current_STATE = 2 --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
			
			--如果本地时间到了第二天，那么将本地的得分缓存值清零
			local intTimeNow = hApi.GetNewDate(g_systime) --现在服务器时间戳
			--与北京时间的时差
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - 8 --与北京时间的时差
			intTimeNow = intTimeNow - delteZone * 3600 --服务器时间(北京时区)
			local tabNow = os.date("*t", intTimeNow)
			local yearNow = tabNow.year
			local monthNow = tabNow.month
			local dayNow = tabNow.day
			
			local intTimeOld = last_query_board_time --上一次取排行榜的时间戳
			local tabOld = os.date("*t", intTimeOld)
			local yearOld = tabOld.year
			local monthOld = tabOld.month
			local dayOld = tabOld.day
			
			--print(yearNow, monthNow, dayNow)
			--print(yearOld, monthOld, dayOld)
			if (yearNow ~= yearOld) or (monthNow ~= monthOld) or (dayNow ~= dayOld) then
				last_local_board_score = 0 --本地存储的最高值，清零
			end
			
			--发起查询，获取排行榜静态数据模板
			if (not current_billboardT) then
				--查询排行榜静态数据模板（会收到排行榜静态数据模板的异步回调）
				--print("查询排行榜静态数据模板 get_billboardT")
				SendCmdFunc["get_billboardT"](current_billId)
			else
				--本地已经存在排行榜静态数据模板
				on_receive_billboardT_event(current_billboardT)
			end
		end
	end
	
	--函数：收到排行榜静态数据模板的回调事件
	on_receive_billboardT_event = function(billboardT)
		local _frm = hGlobal.UI.PhoneRankBoardFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		if (current_STATE == 2) then --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
			--标记当前状态为查询完毕
			current_STATE = 3 --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
			
			--隐藏正在网络查询的小菊花
			_frmNode.childUI["waiting"].handle.s:setVisible(false)
			
			 --显示问号
			_frmNode.childUI["btnBoardIntro"].childUI["icon"].handle.s:setVisible(true)
			
			--存储本地的静态数据
			current_billboardT = billboardT
			
			--检测本地无尽地图的得分，是否有更高的得分，需要上传
			local bId = current_billboardT.info[1].bId
			local timestamp = os.time() - g_localDeltaTime --(Local = Host + deltaTime)
			--与北京时间的时差
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - 8 --与北京时间的时差
			timestamp = timestamp - delteZone * 3600 --服务器时间(北京时区)
			
			--print("bId=", bId)
			--local mapId = "world/td_wj_001"
			local score = LuaGetPlayerBillBoard(g_curPlayerName, bId)
			--print("score", score, "last_query_board_time", last_query_board_time)
			--score = 1003 --test
			if (score > last_local_board_score) then
				--标记最新查询排行榜的时间
				last_query_board_time = timestamp
				
				--显示正在网络查询的小菊花
				_frmNode.childUI["waiting"].handle.s:setVisible(true)
				
				--存储最新的得分
				last_local_board_score = score
				
				--发起更新（会收到排行榜数据的异步回调）
				local strTime = os.date("%Y-%m-%d %H:%M:%S", timestamp) --北京时区
				local checkSum = (score + timestamp + delteZone * 3600) % 9973 --校验值
				--print("更新最新的得分 update_billboard_rank", bId, score, strTime, checkSum)
				SendCmdFunc["update_billboard_rank"](bId, score, strTime, checkSum)
			else
				--本地的得分不是最新，只需要刷新服务器的最新排行数据
				--检测time，是否需要再次更新排行榜的信息
				local deltatime = timestamp - last_query_board_time
				--print("deltatime=", deltatime, QUERY_DELTA_SECOND)
				if (deltatime >= QUERY_DELTA_SECOND) then
					--标记最新查询排行榜的时间
					last_query_board_time = timestamp
					
					--显示正在网络查询的小菊花
					_frmNode.childUI["waiting"].handle.s:setVisible(true)
					
					--print("发起查询，获取排行榜信息")
					--发起查询，获取排行榜信息
					--print("查询排行榜数据 get_billboard")
					SendCmdFunc["get_billboard"](bId)
				else
					--print("用本地存储的数据绘制界面")
					--用本地存储的数据绘制界面
					on_receive_billboard_event(current_billboardData)
				end
			end
		end
	end
	
	--函数：收到排行榜当前排行数据的回调事件
	on_receive_billboard_event = function(billboard)
		local _frm = hGlobal.UI.PhoneRankBoardFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--geyachao: 这里会弹框？
		if (not current_billboardT) then
			return
		end
		
		--隐藏正在网络查询的小菊花
		_frmNode.childUI["waiting"].handle.s:setVisible(false)
		
		--先清空右侧的信息
		_removeRightFrmFunc()
		
		--存储本次排行数据
		--[[
		--测试 --test
		local testest = "本人认为从以往的试点城市来看sss我过的征收的税率还是远远的低于国际上的平均水平的fff我想就算是房地产税落地实施ggg也没有我们想像的那么悲催，政府肯定会根据不同地区执行不同的征收标准，还会依照中国的国情设定一定的免征额。我想我们普通老百姓到时的税收会有一个对冲的效果，不必太多担忧。对于没有房子的朋友也称得上是利好，有了房地产税，呢么对于一些市场上的包租婆就相当于是增加了他们囤积房子的成本，也会让他们将手上空闲的余房进行抛售，那么市场上的房源供过于求，就会使我们没房的朋友购买房子的时候房价应该有所减少。要是楼市资金出逃的话，那么势必股市的资金就会流入，近期可以重点关注房地产板块，寻找一些资金流入，趋势走好，股价处于低位的个股关注，个股案例欢迎咨询。"
		billboard.num = 50
		for i = 1, billboard.num, 1 do
			local randNum = math.random(3, 5)
			local str = ""
			for i = 1, randNum, 1 do
				local idx = math.random(1, #testest)
				str = str .. string.sub(testest, idx, idx + 2)
			end
			billboard.info[i] = {}
			billboard.info[i].name = str
			billboard.info[i].rank = math.random(1, 10000)
		end
		]]
		--current_billboardData = billboard
		
		--依次绘制每个排行
		local bId = billboard.bId --排行榜id
		local num = billboard.num --总人数
		local info = billboard.info --详细信息
		--print(bId, num, info)
		for i = 1, num, 1 do
			local validIdx = i
			local xn = (validIdx % BILLBOARD_X_NUM) --xn
			if (xn == 0) then
				xn = BILLBOARD_X_NUM
			end
			local yn = (validIdx - xn) / BILLBOARD_X_NUM + 1 --yn
			
			local offsetX = BILLBOARD_NODE_OFFSET_X + 25 + (xn - 1) * 150
			local offsetY = BILLBOARD_NODE_OFFSET_Y - 135 + 42 - (yn - 1) * (BILLBOARD_HEIGHT + 6)
			
			--绘制该行
			OnCreateSingleBoardData(_BTC_pClipNode_Rankboard, i, offsetX, offsetY, info[i].name, info[i].rank, i, billboard)
			
			--[[
			--做运动
			local ctrli = _frmNode.childUI["BillboardNode" .. i]
			local cx, cy = ctrli.data.x, ctrli.data.y
			ctrli.handle._n:setPosition(ccp(cx + 800, cy))
			local delay = CCDelayTime:create(0.01 * i)
			local move = CCMoveBy:create(0.1, ccp(-800, 0))
			local actSeq = CCSequence:createWithTwoActions(delay, move)
			ctrli.handle._n:runAction(actSeq)
			]]
		end
		
		--绘制我的数据
		local iMe = num + 1
		local offsetXMe = BILLBOARD_NODE_OFFSET_X + 25
		local offsetYMe = BILLBOARD_NODE_OFFSET_Y - 560
		local nameMe = billboard.nameMe --我的名字
		local rankMe = billboard.rankMe --我的得分
		local rankingMe = billboard.rankingMe --我的排名
		--OnCreateSingleBoardData(_frmNode.handle._n, iMe, offsetXMe, offsetYMe, nameMe, rankMe, rankingMe, billboard)
		
		--我的排行的父控件
		_frmNode.childUI["BillboardNode" .. iMe] = hUI.button:new({ --作为button只是为了作为父控件，坐标正常
			parent = _parentNode,
			--model = "misc/buttonred.png",
			model = -1,
			x = offsetXMe,
			y = offsetYMe,
			w = BILLBOARD_WIDTH,
			h = BILLBOARD_HEIGHT,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "BillboardNode" .. iMe
		
		--绘制的颜色
		local paintColor = nil
		
		--"我的排名"值
		if (rankingMe == 1) then --第1名
			--金色
			paintColor = ccc3(255, 224, 0)
			
			_frmNode.childUI["BillboardNode" .. iMe].childUI["RankLabel"] = hUI.image:new({
				parent = _frmNode.childUI["BillboardNode" .. iMe].handle._n,
				model = "UI:rank_n_1",
				x = 76,
				y = -2,
				scale = 1.0,
			})
		elseif (rankingMe == 2) then --第2名
			--银色
			paintColor = ccc3(212, 212, 212)
			
			_frmNode.childUI["BillboardNode" .. iMe].childUI["RankLabel"] = hUI.image:new({
				parent = _frmNode.childUI["BillboardNode" .. iMe].handle._n,
				model = "UI:rank_n_2",
				x = 76,
				y = -2,
				scale = 1.0,
			})
		elseif (rankingMe == 3) then --第3名
			--铜色
			paintColor = ccc3(233, 168, 0)
			
			_frmNode.childUI["BillboardNode" .. iMe].childUI["RankLabel"] = hUI.image:new({
				parent = _frmNode.childUI["BillboardNode" .. iMe].handle._n,
				model = "UI:rank_n_3",
				x = 76,
				y = -2,
				scale = 1.0,
			})
		else --其他名次
			if (rankingMe >= 4) and (rankingMe <= 10) then --第4-10名
				--蓝色
				paintColor = ccc3(168, 212, 255)
			elseif (rankingMe >= 11) and (rankingMe <= 20) then --第11-20名
				--绿色
				paintColor = ccc3(212, 255, 212)
			elseif (rankingMe >= 21) and (rankingMe <= 30) then --第21-30名
				--青色
				paintColor = ccc3(176, 255, 255)
			else --其他名次
				paintColor = ccc3(255, 255, 255)
			end
			
			--我的排名值
			_frmNode.childUI["BillboardNode" .. iMe].childUI["RankLabel"] = hUI.label:new({
				parent = _frmNode.childUI["BillboardNode" .. iMe].handle._n,
				x = 43,
				y = -3, --字体有1像素偏差
				size = 22,
				font = "numWhite",
				align = "LC",
				width = 300,
				--border = 1,
				text = ((rankingMe == 0) and (current_billboardT.info[1].prize.max_rank .. "+") or rankingMe),
			})
			_frmNode.childUI["BillboardNode" .. iMe].childUI["RankLabel"].handle.s:setColor(paintColor)
		end
		
		--"我的得分"值
		_frmNode.childUI["BillboardNode" .. iMe].childUI["RanlScore"] = hUI.label:new({
			parent = _frmNode.childUI["BillboardNode" .. iMe].handle._n,
			x = 493,
			y = -3, --字体有1像素偏差
			size = 22,
			font = "numWhite",
			align = "LC",
			width = 300,
			--border = 1,
			text = rankMe,
		})
		_frmNode.childUI["BillboardNode" .. iMe].childUI["RanlScore"].handle.s:setColor(paintColor)
		
		--翻页按钮是否显示
		_frmNode.childUI["BillboardPageUp"].handle.s:setVisible(false) --不显示上翻页提示
		--如果排行总数量超过一页，那么显示下翻页提示
		if (billboard.num > (BILLBOARD_X_NUM * BILLBOARD_Y_NUM)) then
			_frmNode.childUI["BillboardPageDown"].handle.s:setVisible(true) --显示下翻页提示
		end
		
		--最后存储本次排行榜的数据（放在最后存储，是为了其他timer刷新界面时，取的数量为旧的，避免新控件还未创建）
		current_billboardData = billboard
	end
	
	--函数：收到程序进入后台的回调事件
	on_enter_background_event = function(flag)
		--print("收到程序进入后台的回调事件", flag)
		--current_enter_bg = flag --当前程序是否在后台（如果进入后台，就不用定时器刷新排行榜情况）
		if (flag == 1) then
			--移除timer
			--print("移除timer")
			--hApi.clearTimer("__RANK_QUERY_TIMER__")
			--暂停定时器
			--hApi.PauseTimer()
		elseif (flag == 0) then
			--添加timer
			--print("添加timer")
			--hApi.addTimerForever("__RANK_QUERY_TIMER__", hVar.TIMER_MODE.GAMETIME, QUERY_DELTA_SECOND * 1000, on_query_billboard_info_timer)
			--恢复定时器
			--hApi.ResumeTimer()
		end
	end
	
	--函数：绘制单条排行榜条目的内容
	OnCreateSingleBoardData = function(parent, index, offsetX, offsetY, name ,rank, ranking, billboard)
		local _frm = hGlobal.UI.PhoneRankBoardFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local i = index
		
		--排行的父控件
		_frmNode.childUI["BillboardNode" .. i] = hUI.button:new({ --作为button只是为了作为父控件，坐标正常
			parent = parent,
			--model = "misc/buttonred.png",
			model = -1,
			x = offsetX,
			y = offsetY,
			w = BILLBOARD_WIDTH,
			h = BILLBOARD_HEIGHT,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "BillboardNode" .. i
		
		--[[
		--排行的底纹图
		local bgModel = nil
		if (i % 2 == 0) then
			bgModel = "misc/y_mask_16.png"
		else
			bgModel = "misc/y_mask_16.png"
		end
		_frmNode.childUI["BillboardNode" .. i].childUI["imageBG"] = hUI.image:new({
			parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
			model = bgModel,
			x = 283,
			y = 0, --字体有1像素偏差
			w = 744,
			h = BILLBOARD_HEIGHT,
		})
		--_frmNode.childUI["BillboardNode" .. i].childUI["imageBG"].handle.s:setOpacity(32)
		local bgModel = nil
		if (i % 2 == 0) then
			_frmNode.childUI["BillboardNode" .. i].childUI["imageBG"].handle.s:setOpacity(32)
		else
			_frmNode.childUI["BillboardNode" .. i].childUI["imageBG"].handle.s:setOpacity(64)
		end
		]]
		
		--如果我的排名是本条排名，那么显示我的底纹
		--billboard.rankingMe = 13 --测试 --test
		if (ranking == billboard.rankingMe) then
			--我的背景图
			--[[
			_frmNode.childUI["BillboardNode" .. i].childUI["imageBG"] = hUI.image:new({
				parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
				model = "misc/win_back.png", --"misc/y_mask_16.png",
				x = 285,
				y = 0,
				w = 795,
				h = BILLBOARD_HEIGHT,
			})
			_frmNode.childUI["BillboardNode" .. i].childUI["imageBG"].handle.s:setOpacity(24)
			]]
			local enterNameEditBox = CCEditBox:create(CCSizeMake(838, BILLBOARD_HEIGHT + 6), CCScale9Sprite:create("data/image/misc/win_back.png"))--"data/image/misc/win_back.png""data/image/misc/1xs.png"
			enterNameEditBox:setPosition(ccp(304, 1))
			enterNameEditBox:setOpacity(36)
			_frmNode.childUI["BillboardNode" .. i].handle._n:addChild(enterNameEditBox)
			
			--我的叹号
			local th_dx = 0
			if (ranking == 1) then --第1名
				th_dx = 10
			elseif (ranking == 2) then --第2名
				th_dx = 10
			elseif (ranking == 3) then --第3名
				th_dx = 10
			elseif (ranking < 10) then --4~9名
				th_dx = -14
			elseif (ranking < 100) then --10~99名
				th_dx = -6
			else --100+名
				th_dx = 0
			end
			_frmNode.childUI["BillboardNode" .. i].childUI["TanHao"] = hUI.image:new({
				parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
				x = th_dx,
				y = 0,
				model = "UI:TaskTanHao",
				w = 24,
				h = 24,
			})
			local act1 = CCMoveBy:create(0.2, ccp(0, 5))
			local act2 = CCMoveBy:create(0.2, ccp(0, -5))
			local act3 = CCMoveBy:create(0.2, ccp(0, 5))
			local act4 = CCMoveBy:create(0.2, ccp(0, -5))
			local act5 = CCDelayTime:create(2.0)
			local a = CCArray:create()
			a:addObject(act1)
			a:addObject(act2)
			a:addObject(act3)
			a:addObject(act4)
			a:addObject(act5)
			local sequence = CCSequence:create(a)
			_frmNode.childUI["BillboardNode" .. i].childUI["TanHao"].handle.s:runAction(CCRepeatForever:create(sequence))
		end
		
		--绘制的颜色
		local paintColor = nil
		
		--排行的名次
		if (ranking == 1) then --第1名
			--金色
			paintColor = ccc3(255, 224, 0)
			
			_frmNode.childUI["BillboardNode" .. i].childUI["RankLabel"] = hUI.image:new({
				parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
				model = "UI:rank_n_1",
				x = -38,
				y = -2, --图片名次多1像素
				scale = 1.0,
			})
		elseif (ranking == 2) then --第2名
			--银色
			paintColor = ccc3(212, 212, 212)
			
			_frmNode.childUI["BillboardNode" .. i].childUI["RankLabel"] = hUI.image:new({
				parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
				model = "UI:rank_n_2",
				x = -38,
				y = -2, --图片名次多1像素
				scale = 1.0,
			})
		elseif (ranking == 3) then --第3名
			--铜色
			paintColor = ccc3(233, 168, 0)
			
			_frmNode.childUI["BillboardNode" .. i].childUI["RankLabel"] = hUI.image:new({
				parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
				model = "UI:rank_n_3",
				x = -38,
				y = -2, --图片名次多1像素
				scale = 1.0,
			})
		else --其他名次
			if (ranking >= 4) and (ranking <= 10) then --第4-10名
				--蓝色
				paintColor = ccc3(168, 212, 255)
			elseif (ranking >= 11) and (ranking <= 20) then --第11-20名
				--绿色
				paintColor = ccc3(212, 255, 212)
			elseif (ranking >= 21) and (ranking <= 30) then --第21-30名
				--青色
				paintColor = ccc3(176, 255, 255)
			else --其他名次
				paintColor = ccc3(255, 255, 255)
			end
			
			local scoreRankingSize = 22
			if (ranking > 9) then
				scoreRankingSize = 20
			end
			_frmNode.childUI["BillboardNode" .. i].childUI["RankLabel"] = hUI.label:new({
				parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
				x = -40,
				y = -1, --字体有1像素偏差
				--size = 22,
				size = scoreRankingSize,
				font = "numWhite",
				align = "MC",
				width = 300,
				--border = 1,
				text = ranking,
			})
			_frmNode.childUI["BillboardNode" .. i].childUI["RankLabel"].handle.s:setColor(paintColor)
		end
		
		--排行的玩家名
		local nameFontSize = 26
		if (ranking > 3) then
			nameFontSize = 25
		end
		_frmNode.childUI["BillboardNode" .. i].childUI["BillboardNodeTitle"] = hUI.label:new({
			parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
			x = 140,
			y = -1,
			size = nameFontSize,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
			text = name,
		})
		if paintColor then --前3名的颜色
			_frmNode.childUI["BillboardNode" .. i].childUI["BillboardNodeTitle"].handle.s:setColor(paintColor)
		else
		end
		
		--排行的得分
		local scoreFontSize = 21
		if (ranking > 3) then
			scoreFontSize = 20
		end
		_frmNode.childUI["BillboardNode" .. i].childUI["ScoreLabel"] = hUI.label:new({
			parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
			x = 330,
			y = -1, --字体有1像素偏差
			size = scoreFontSize,
			font = "numWhite",
			align = "MC",
			width = 300,
			--border = 1,
			text = rank,
		})
		if paintColor then
			_frmNode.childUI["BillboardNode" .. i].childUI["ScoreLabel"].handle.s:setColor(paintColor)
		end
		
		--排行的奖励
		--检测本排行应该获得何种奖励
		local giveRewardT = {}
		for r = 1, #current_billboardT.info[1].prize.reward, 1 do
			local rewardT = current_billboardT.info[1].prize.reward[r]
			local from = rewardT.from
			local to = rewardT.to
			if (ranking >= from) and (ranking <= to) then
				giveRewardT = rewardT
				--print(from, to, ranking)
				break
			end
		end
		local WIDTH = 78
		local scaleModel = 0.68
		for n = 1, #giveRewardT, 1 do
			--获得奖励的UI相关参数
			local rewardT = giveRewardT[n]
			local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
			--print(tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h)
			
			local offsetX = 0
			if (#giveRewardT % 2 == 1) then --奇数
				offsetX = (#giveRewardT - 1) / 2 * (WIDTH)-- + WIDTH * scaleModel
			else --偶数
				offsetX = (#giveRewardT) / 2 * (WIDTH) / 2-- + WIDTH * scaleModel
			end
			
			--绘制奖励控件图标
			_frmNode.childUI["BillboardNode" .. i].childUI["reward" .. n] = hUI.button:new({ --作为button是为了子控件坐标正常
				parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
				model = tmpModel,
				x = 530 - offsetX + (n - 1) * (WIDTH),
				y = 0,
				w = itemWidth * scaleModel,
				h = itemHeight * scaleModel,
			})
			
			--绘制奖励控件图标的子控件
			if sub_tmpModel then
				_frmNode.childUI["BillboardNode" .. i].childUI["reward" .. n].childUI["subIcon"] = hUI.image:new({
					parent = _frmNode.childUI["BillboardNode" .. i].childUI["reward" .. n].handle._n,
					model = sub_tmpModel,
					x = sub_pos_x * scaleModel,
					y = sub_pos_y * scaleModel,
					w = sub_pos_w * scaleModel,
					h = sub_pos_h * scaleModel,
				})
			end
			
			
			--绘制奖励的数量
			local posX = 15
			local scaleSize = 16
			if (itemNum >= 100) then
				posX = 18
				scaleSize = 14
			elseif (itemNum >= 10) then
				posX = 14
				scaleSize = 15
			end
			local strNum = ("+" .. itemNum)
			_frmNode.childUI["BillboardNode" .. i].childUI["reward" .. n].childUI["subNum"] = hUI.label:new({
				parent = _frmNode.childUI["BillboardNode" .. i].childUI["reward" .. n].handle._n,
				x = posX,
				y = -5,
				size = scaleSize,
				font = "numWhite",
				align = "LC",
				width = 300,
				border = 0,
				text = strNum,
			})
			if paintColor then
				_frmNode.childUI["BillboardNode" .. i].childUI["reward" .. n].childUI["subNum"].handle.s:setColor(paintColor)
			end
		end
	end
	
	--函数：创建排榜榜规则介绍tip
	OnCreateRankBoardTipFrame = function()
		local _frm = hGlobal.UI.PhoneRankBoardFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--先清除上一次的排行榜说明面板
		if hGlobal.UI.RankBoardInfoFrame then
			hGlobal.UI.RankBoardInfoFrame:del()
			hGlobal.UI.RankBoardInfoFrame = nil
		end
		
		--如果本地未获得排行榜静态数据，不显示tip
		if (not current_billboardT) then
			return
		end
		
		if (current_STATE < 3) then --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
			return
		end
		
		--创建排行榜说明面板
		hGlobal.UI.RankBoardInfoFrame = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			--z = -1,
			show = 1,
			--dragable = 2,
			dragable = 3, --点击后消失
			--buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			border = 0,
			background = -1, --不显示背景图
			
			--点击事件（有可能在控件外部点击）
			codeOnDragEx = function(screenX, screenY, touchMode)
				--print("codeOnDragEx", screenX, screenY, touchMode)
				if (touchMode == 0) then --按下
					--清除技能说明面板
					--hGlobal.UI.ItemMergeInfoFrame:del()
					--hGlobal.UI.ItemMergeInfoFrame = nil
					--print("点击事件（有可能在控件外部点击）")
				elseif (touchMode == 1) then --滑动
					--
				elseif (touchMode == 2) then --抬起
				end
			end,
		})
		hGlobal.UI.RankBoardInfoFrame:active()
		
		local _RankTipParent = hGlobal.UI.RankBoardInfoFrame.handle._n
		local _RankTipChildUI = hGlobal.UI.RankBoardInfoFrame.childUI
		local _offX = BOARD_POS_X + 415
		local _offY = BOARD_POS_Y - 45
		
		--创建每日排行介绍tip-图片背景
		--[[
		_RankTipChildUI["ItemBG_1"] = hUI.image:new({
			parent = _RankTipParent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "UI:TacticBG",
			x = _offX,
			y = _offY - 216,
			w = 680,
			h = 520,
		})
		_RankTipChildUI["ItemBG_1"].handle.s:setOpacity(204)
		]]
		local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", _offX, _offY - 216, 680, 520, hGlobal.UI.RankBoardInfoFrame)
		img9:setOpacity(204)
		
		--创建每日排行介绍tip-标题
		_RankTipChildUI["RankBoardName"] = hUI.label:new({
			parent = _RankTipParent,
			size = 32,
			x = _offX - 100,
			y = _offY + 10,
			width = 300,
			align = "LC",
			font = hVar.FONTC,
			--text = "每日排行介绍", --language
			text = hVar.tab_string["__TEXT_RankBoardIntro"], --language
			border = 1,
		})
		_RankTipChildUI["RankBoardName"].handle.s:setColor(ccc3(255, 128, 0))
		
		--创建每日排行介绍tip-内容1
		_RankTipChildUI["RankBoardContent1"] = hUI.label:new({
			parent = _RankTipParent,
			size = 26,
			x = _offX - 310,
			y = _offY - 20,
			width = 650,
			align = "LT",
			font = hVar.FONTC,
			--text = "每日挑战“黄巾试炼”得分前20名的玩家将获得奖励。", --language
			text = hVar.tab_string["__TEXT_RankBoardHint1.1"] .. current_billboardT.info[1].prize.max_rank .. hVar.tab_string["__TEXT_RankBoardHint1.2"], --language
			border = 1,
		})
		
		--创建每日排行介绍tip-内容2
		_RankTipChildUI["RankBoardContent2"] = hUI.label:new({
			parent = _RankTipParent,
			size = 26,
			x = _offX - 310,
			y = _offY - 55,
			width = 650,
			align = "LT",
			font = hVar.FONTC,
			--text = "得分每日重置。奖励次日发放。", --language
			text = hVar.tab_string["__TEXT_RankBoardHint2"], --language
			border = 1,
		})
		
		--创建每日排行介绍tip-内容3
		_RankTipChildUI["RankBoardContent3"] = hUI.label:new({
			parent = _RankTipParent,
			size = 28,
			x = _offX - 310,
			y = _offY - 110,
			width = 650,
			align = "LT",
			font = hVar.FONTC,
			--text = "排名奖励：", --language
			text = hVar.tab_string["__TEXT_RankBoardHint3"], --language
			border = 1,
		})
		_RankTipChildUI["RankBoardContent3"].handle.s:setColor(ccc3(223, 255, 223))
		
		--各名次的奖励
		local reward = current_billboardT.info[1].prize.reward
		for r = 1, #reward, 1 do
			local giveRewardT = current_billboardT.info[1].prize.reward[r]
			local from = giveRewardT.from
			local to = giveRewardT.to
			
			--排行的名次
			--绘制的颜色
			local paintColor = nil
			if (from == 1) and (to == 1) then --第1名
				--金色
				paintColor = ccc3(255, 224, 0)
			elseif (from == 2) and (to == 2) then --第2名
				--银色
				paintColor = ccc3(212, 212, 212)
			elseif (from == 3) and (to == 3) then --第3名
				--铜色
				paintColor = ccc3(233, 168, 0)
			elseif (from >= 4) and (to <= 10) then --第4-10名
				--蓝色
				paintColor = ccc3(168, 212, 255)
			elseif (from >= 11) and (to <= 20) then --第11-20名
				--绿色
				paintColor = ccc3(212, 255, 212)
			elseif (from >= 21) and (to <= 30) then --第21-30名
				--青色
				paintColor = ccc3(176, 255, 255)
			else --其他名次
				paintColor = ccc3(255, 255, 255)
			end
			
			--第多少名范围
			--local strRankRange = "第" .. from --language
			local strRankRange = hVar.tab_string["__TEXT_WORD_DI"] .. from --language
			if (to == from) then
				--strRankRange = strRankRange .. "名:" --language
				strRankRange = strRankRange .. hVar.tab_string["__TEXT_WORD_MING"] .. ":" --language
			else
				--strRankRange = strRankRange .. "-" .. to .. "名:" --language
				strRankRange = strRankRange .. "-" .. to .. hVar.tab_string["__TEXT_WORD_MING"] .. ":" --language
			end
			_RankTipChildUI["RankBoardContent-RankRange"] = hUI.label:new({
				parent = _RankTipParent,
				size = 26,
				x = _offX - 295,
				y = _offY - 150 - (r - 1) * 44,
				width = 650,
				align = "LT",
				font = hVar.FONTC,
				text = strRankRange,
				border = 1,
			})
			if paintColor then
				_RankTipChildUI["RankBoardContent-RankRange"].handle.s:setColor(paintColor)
			end
			
			--奖励物品图标
			local scaleModel = 0.75
			local WIDTH = 150
			for n = 1, #giveRewardT, 1 do
				--获得奖励的UI相关参数
				local rewardT = giveRewardT[n]
				local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
				--print(tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h)
			
				--绘制奖励控件图标
				_RankTipChildUI["RankBoardContent-Reward".. n] = hUI.button:new({ --作为button是为了子控件坐标正常
					parent = _RankTipParent,
					model = tmpModel,
					x = _offX - 120 + (n - 1) * WIDTH,
					y = _offY - 150 - (r - 1) * 44 - 9,
					w = itemWidth * scaleModel,
					h = itemHeight * scaleModel,
				})
				
				--绘制奖励控件图标的子控件
				if sub_tmpModel then
					_RankTipChildUI["RankBoardContent-Reward".. n].childUI["subIcon"] = hUI.image:new({
						parent = _RankTipChildUI["RankBoardContent-Reward".. n].handle._n,
						model = sub_tmpModel,
						x = sub_pos_x * scaleModel,
						y = sub_pos_y * scaleModel,
						w = sub_pos_w * scaleModel,
						h = sub_pos_h * scaleModel,
					})
				end
				
				--绘制奖励的数量
				local scaleSize = 20
				if (itemNum >= 100) then
					scaleSize = 16
				end
				_RankTipChildUI["RankBoardContent-RewardNum".. n] = hUI.label:new({
					parent = _RankTipParent,
					x = _offX - 100 + (n - 1) * WIDTH,
					y = _offY - 150 - (r - 1) * 44 - 9 - 5,
					size = scaleSize,
					font = "numWhite",
					align = "LC",
					width = 300,
					border = 1,
					text = "+" .. itemNum,
				})
				if paintColor then
					_RankTipChildUI["RankBoardContent-RewardNum".. n].handle.s:setColor(paintColor)
				end
			end
		end
	end
	
	--函数：定时向服务器查询当前的排行数据(timer)
	on_query_billboard_info_timer = function()
		--print("定时向服务器查询当前的排行数据(timer) on_query_billboard_info_timer")
		local _frm = hGlobal.UI.PhoneRankBoardFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local currenttime = hApi.gametime() --当前时间
		local deltatime = currenttime - last_timer_query_time --时间差
		--print("deltatime=", deltatime)
		if (deltatime >= (QUERY_DELTA_SECOND * 1000 - 100)) then
			--if (current_enter_bg == 0) then --当前程序是否在后台（如果进入后台，就不用定时器刷新排行榜情况）
				if (g_cur_net_state == 1) then --联网状态
					if current_billboardT then --已获得排行榜的静态数据
						if (current_STATE == 3) then --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
							--print("定时向服务器查询当前的排行数据(timer)")
							--标记timer
							last_timer_query_time = currenttime
							
							--标记最新查询的时间
							local timestamp = os.time()
							last_query_board_time = timestamp
							
							--显示正在网络查询的小菊花
							_frmNode.childUI["waiting"].handle.s:setVisible(true)
							
							--发起查询，获取排行榜信息
							local bId = current_billboardT.info[1].bId
							--print("bId=", bId)
							--print("查询排行榜数据 on_query_billboard_info_timer get_billboard")
							SendCmdFunc["get_billboard"](bId)
						end
					end
				end
			--end
		end
	end
	
	--函数：刷新排行榜界面的滚动
	refresh_rank_board_UI_loop = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		--print("current_STATE = " .. current_STATE)
		--如果当前的查询状态是在查询服务器时间，或者查询静态数据，那么不能滚动
		if (current_STATE < 3) then --当前的状态(0:初始化 / 1:正在查询服务器时间 / 2:正在查询静态数据 / 3:查询完毕)
			return
		end
		
		local _frm = hGlobal.UI.PhoneRankBoardFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--注意: 如果刚打开界面的瞬间，子控件都被删掉了，而这时滑动屏幕，并且有上一次排行榜缓存数据，逻辑会走到这，但是此时界面还没，会弹框
		if (_frmNode.childUI["BillboardNode1"] == nil) then
			return
		end
		
		local SPEED = 50 --速度
		--print(b_need_auto_fixing_billboard)
		
		if b_need_auto_fixing_billboard then
			---第一个排行榜的数据
			local BillboardBtn1 = _frmNode.childUI["BillboardNode1"]
			local btn1_cx, btn1_cy = 0, 0 --第一个排行榜中心点位置
			local btn1_ly = 0 --第一个排行榜最上侧的x坐标
			local delta1_ly = 0 --第一个排行榜距离上侧边界的距离
			btn1_cx, btn1_cy = BillboardBtn1.data.x, BillboardBtn1.data.y --第一个排行榜中心点位置
			btn1_ly = btn1_cy + BILLBOARD_HEIGHT / 2 --第一个排行榜最上侧的x坐标
			delta1_ly = btn1_ly + 50 --第一个排行榜距离上侧边界的距离
			
			--最后一个排行榜的数据
			local BillboardBtnN = _frmNode.childUI["BillboardNode" .. current_billboardData.num]
			local btnN_cx, btnN_cy = 0, 0 --最后一个排行榜中心点位置
			local btnN_ry = 0 --最后一个排行榜最下侧的x坐标
			local deltNa_ry = 0 --最后一个排行榜距离下侧边界的距离
			btnN_cx, btnN_cy = BillboardBtnN.data.x, BillboardBtnN.data.y --最后一个排行榜中心点位置
			btnN_ry = btnN_cy - BILLBOARD_HEIGHT / 2 --最后一个排行榜最下侧的x坐标
			deltNa_ry = btnN_ry + 513 --最后一个排行榜距离下侧边界的距离
			--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
			
			--print("delta1_ly=" .. delta1_ly, ", deltNa_rx=" .. deltNa_rx)
			--如果第一个排行榜的头像跑到下边，那么优先将第一个排行榜头像贴边
			if (delta1_ly < 0) then
				--print("优先将第一个排行榜头像贴边")
				--需要修正
				--不会选中排行榜
				selected_billboardEx_idx = 0 --选中的排行榜索引
				
				--没有惯性
				draggle_speed_y_billboard = 0
				
				local speed = SPEED
				if ((delta1_ly + speed) > 0) then --防止走过
					speed = -delta1_ly
					delta1_ly = 0
				end
				
				--每个按钮向上侧做运动
				for i = 1, current_billboardData.num, 1 do
					local ctrli = _frmNode.childUI["BillboardNode" .. i]
					--if (ctrli.data.selected == 0) then --只处理未选中的排行榜卡牌
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x, pos_y + speed
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页不显示，下滑动翻页显示
				_frmNode.childUI["BillboardPageUp"].handle.s:setVisible(false) --上翻页提示
				_frmNode.childUI["BillboardPageDown"].handle.s:setVisible(true) --下翻页提示
			elseif (delta1_ly ~= 0) and (deltNa_ry > 0) then --第一个头像没有贴上侧，并且最后一个头像没有贴下侧，那么再将最后一个排行榜头像贴边
				--print("将最后一个排行榜头像贴边")
				--需要修正
				--不会选中排行榜
				selected_billboardEx_idx = 0 --选中的排行榜索引
				
				--没有惯性
				draggle_speed_y_billboard = 0
				
				local speed = SPEED
				if ((deltNa_ry - speed) < 0) then --防止走过
					speed = deltNa_ry
					deltNa_ry = 0
				end
				
				--每个按钮向下侧做运动
				for i = 1, current_billboardData.num, 1 do
						local ctrli = _frmNode.childUI["BillboardNode" .. i]
					--if (ctrli.data.selected == 0) then --只处理未选中的排行榜卡牌
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y - speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					--end
				end
				
				--上滑动翻页显示，下滑动翻页不显示
				_frmNode.childUI["BillboardPageUp"].handle.s:setVisible(true) --上分翻页提示
				_frmNode.childUI["BillboardPageDown"].handle.s:setVisible(false) --下分翻页提示
			elseif (draggle_speed_y_billboard ~= 0) then --沿着当前的速度方向有惯性地运动一会
				--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_y_billboard)
				--不会选中排行榜
				selected_billboardEx_idx = 0 --选中的排行榜索引
				--print("    ->   draggle_speed_y_billboard=", draggle_speed_y_billboard)
				
				if (draggle_speed_y_billboard > 0) then --朝上运动
					local speed = (draggle_speed_y_billboard) * 1.0 --系数
					friction_billboard = friction_billboard - 0.5
					draggle_speed_y_billboard = draggle_speed_y_billboard + friction_billboard --衰减（正）
					
					if (draggle_speed_y_billboard < 0) then
						draggle_speed_y_billboard = 0
					end
					
					--最后一个排行榜的坐标不能跑到最下侧的上边去
					if ((deltNa_ry + speed) > 0) then --防止走过
						speed = -deltNa_ry
						deltNa_ry = 0
						
						--没有惯性
						draggle_speed_y_billboard = 0
					end
					
					--每个按钮向上侧做运动
					for i = 1, current_billboardData.num, 1 do
							local ctrli = _frmNode.childUI["BillboardNode" .. i]
						--if (ctrli.data.selected == 0) then --只处理未选中的排行榜卡牌
							local pos_x, pos_y = ctrli.data.x, ctrli.data.y
							
							--本地运动到达的坐标
							local to_x, to_y = pos_x, pos_y + speed
							
							--设置新坐标
							ctrli.data.x = to_x
							ctrli.data.y = to_y
							ctrli.handle._n:setPosition(to_x, to_y)
						--end
					end
				elseif (draggle_speed_y_billboard < 0) then --朝下运动
					local speed = (draggle_speed_y_billboard) * 1.0 --系数
					friction_billboard = friction_billboard + 0.5
					draggle_speed_y_billboard = draggle_speed_y_billboard + friction_billboard --衰减（负）
					
					if (draggle_speed_y_billboard > 0) then
						draggle_speed_y_billboard = 0
					end
					
					--第一个排行榜的坐标不能跑到最上侧的下边去
					if ((delta1_ly + speed) < 0) then --防止走过
						speed = -delta1_ly
						delta1_ly = 0
						
						--没有惯性
						draggle_speed_y_billboard = 0
					end
					
					--每个按钮向下侧做运动
					for i = 1, current_billboardData.num, 1 do
							local ctrli = _frmNode.childUI["BillboardNode" .. i]
						--if (ctrli.data.selected == 0) then --只处理未选中的排行榜卡牌
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
				
				--上滑动翻页显示，下滑动翻页显示
				if (delta1_ly == 0) then
					_frmNode.childUI["BillboardPageUp"].handle.s:setVisible(false) --上分翻页提示
				else
					_frmNode.childUI["BillboardPageUp"].handle.s:setVisible(true) --上分翻页提示
				end
				if (deltNa_ry == 0) then
					_frmNode.childUI["BillboardPageDown"].handle.s:setVisible(false) --下分翻页提示
				else
					_frmNode.childUI["BillboardPageDown"].handle.s:setVisible(true) --下分翻页提示
				end
			else --停止运动
				b_need_auto_fixing_billboard = false
				friction_billboard = 0
			end
		end
	end
	
	--函数：显示某个指定的排行榜界面
	OnRefreshRankBoardFrame = function(achieve_idx)
		local _frm = hGlobal.UI.PhoneRankBoardFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--标记选中的排行榜索引值
		local last_achieve_idx = current_focus_billboardEx_idx
		current_focus_billboardEx_idx = achieve_idx
		
		--...
		--print(achieve_idx)
	end
	
	--[[
	--函数：更新提示当前哪个分页可以有领取的了
	RefreshBillboardFinishPage = function()
		local _frm = hGlobal.UI.PhoneRankBoardFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--...
	end
	]]
	
	--监听打开排行榜界面通知事件
	hGlobal.event:listen("LocalEvent_Phone_ShowRankBorad", "__ShowRankBoardFrm", function(mapName)
		--触发事件，显示积分、金币界面
		--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
		
		--显示排行榜界面
		hGlobal.UI.PhoneRankBoardFrm:show(1)
		hGlobal.UI.PhoneRankBoardFrm:active()
		
		--打开上一次的分页（默认显示第1个分页:排行榜）
		local lastPageIdx = CurrentSelectRecord.pageIdx
		if (lastPageIdx == 0) then
			lastPageIdx = 1
		end
		
		CurrentSelectRecord.pageIdx = 0
		CurrentSelectRecord.contentIdx = 0
		OnClickPageBtn(lastPageIdx)
		
		--存储是哪张地图点进来的
		current_mapName_entry = mapName
		--print("current_mapName_entry=", current_mapName_entry)
		
		--更新提示当前哪个分页可以有领取的了
		--RefreshBillboardFinishPage()
		
		--只有在打开界面时才会监听的事件
		--监听：收到网络宝箱数量的事件
		--hGlobal.event:listen("LocalEvent_getNetChestNum", "__ItemGetChestNum_Frm", function(NumTab)
			--更新网络宝箱的数量和界面
			--
		--end)
	end)
end

--test
--[[
--测试代码
if hGlobal.UI.PhoneRankBoardFrm then --删除上一次的
	hGlobal.UI.PhoneRankBoardFrm:del()
	hGlobal.UI.PhoneRankBoardFrm = nil
end
hGlobal.UI.InitRankBoradFrm() --测试

--触发事件，显示排行榜界面
hGlobal.event:event("LocalEvent_Phone_ShowRankBorad", 0)
]]
