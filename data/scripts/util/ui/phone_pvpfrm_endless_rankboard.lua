



--铜雀台排行榜操作面板
hGlobal.UI.InitRankBoradFrm_PVP_Endless = function(mode)
	--不重复创建
	if hGlobal.UI.PhoneRankBoardFrm_PVP_Endless then --排行榜操作面板
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
	local OnClosePanel = hApi.DoNothing --关闭本界面
	local OnClickPageBtn = hApi.DoNothing --点击分页按钮
	--local RefreshBillboardFinishPage = hApi.DoNothing --更新提示当前哪个分页可以有领取的了
	
	--分页1：排行榜函数部分
	local OnCreateRankBoardFrame_PVP_Endless = hApi.DoNothing --创建排行榜界面（第1个分页）
	local OnRefreshRankBoardFrame_PVP_Endless = hApi.DoNothing --显示某个指定的排行榜界面
	local OnCreateSingleBoardData_PVP = hApi.DoNothing --绘制单条排行榜的信息
	local refresh_rank_board_UI_loop_PVP_Endless = hApi.DoNothing --刷新排行榜界面的滚动
	local on_receive_ping_event_PVP_Endless = hApi.DoNothing --收到pvp的ping值回调
	local on_receive_connect_back_event_PVP_Endless = hApi.DoNothing --收到连接结果回调
	local on_receive_login_back_event_PVP_Endless = hApi.DoNothing --收到登入结果回调
	local on_receive_refresh_systime_event_PVP_Endless = hApi.DoNothing --收到获得系统时间的回调
	local on_receive_billboard_event_PVP_Endless = hApi.DoNothing --收到铜雀台当前排行数据的回调
	local on_enter_background_event_PVP_Endless = hApi.DoNothing --收到程序进入后台的回调
	local on_query_billboard_info_timer_PVP_Endless = hApi.DoNothing --定时向服务器查询当前的排行数据
	local OnCreateRankBoardTipFrame_PVP_Endless = hApi.DoNothing --函数：创建铜雀台排行榜规则介绍tip
	
	--分页1：排行榜相关参数
	local BILLBOARD_WIDTH = 828 --排行榜宽度
	local BILLBOARD_HEIGHT = 147 --排行榜高度
	local BILLBOARD_X_NUM = 1 --排行榜xn的数量
	local BILLBOARD_Y_NUM = 3 --排行榜yn的数量
	local BILLBOARD_NODE_OFFSET_X = 145 --排行榜统一偏移x
	local BILLBOARD_NODE_OFFSET_Y = 28 - 28 --排行榜统一偏移y
	local BILLBOARD_NODE_WIDTH = 230 --排行榜宽度
	local BILLBOARD_NODE_HEIGHT = 550 --排行榜高度
	local BILLBOARD_NODE_EACHOFFSET = 25 --排行榜x间距
	local MAX_SPEED = 50 --最大速度
	
	--local current_PlayerId = 0 --本地玩家id
	--local current_online_num = 0 --pvp房间在线人数
	local current_focus_billboardEx_idx = 1 --当前显示的排行榜ex的索引值（默认选中第一个）
	--local current_billId = 2
	--local current_billboardT = nil --排行榜的静态表
	local current_pveMultiLog = {num = 0,} --铜雀台的排行数据表
	local last_query_multy_pve_board_time = 0 --上一次获取排行榜的时间
	--local last_local_board_score = 0 --上一次的本地排行榜得分
	local current_STATE = 0 --当前的状态(0:初始化 / 1:正在连接、登入、查询服务器时间 / 3:查询完毕)
	--local current_enter_bg = 0 --当前程序是否在后台（如果进入后台，就不用定时器刷新排行榜情况）
	local last_timer_query_time = 0 --上一次timer取排行榜的时间
	local QUERY_DELTA_SECOND = 60 --查询间隔秒数
	
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
	
	hApi.clearTimer("__RANK_BOARD_UPDATE_PVP_ENDLESS__")
	hApi.clearTimer("__RANK_QUERY_TIMER_PVP_ENDLESS__")
	
	--创建铜雀台排行榜操作面板
	hGlobal.UI.PhoneRankBoardFrm_PVP_Endless = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		z = 100,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 2,
		show = 0, --一开始不显示
		border = 1, --显示frame边框
		--background = "UI:Tactic_Background",
		background = -1,
		--background = "UI:herocardfrm",
		autoactive = 0,
		
		--全部事件
		codeOnDragEx = function(touchX, touchY, touchMode)
			--print("codeOnDragEx", touchX, touchY, touchMode)
			if (touchMode == 2) then --抬起事件
				--穿透点击，检测是否点到了背后的pvp界面的子分页按钮
				local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
				if _frm then
					--是否点击了铜雀台按钮
					local btn = _frm.childUI["PageBtn2"]
					if btn then
						local bx, by = btn.data.x + _frm.data.x, btn.data.y + _frm.data.y
						local w, h = btn.data.w, btn.data.h
						
						local button_left = bx - w / 2 --英雄选中区域的最左侧
						local button_right = bx + w / 2 --英雄选中区域的最右侧
						local button_top = by - h / 2 --英雄选中区域的最上侧
						local button_bottom = by + h / 2 --英雄选中区域的最下侧
						
						--检测是否点击到了子按钮i
						if (touchX >= button_left) and (touchX <= button_right) and (touchY >= button_top) and (touchY <= button_bottom) then
							--print("点到了" .. i)
							--先关闭本面板
							OnClosePanel()
							
							--模拟点击后面的子按钮
							btn.data.code(btn)
						end
					end
					
					--是否点击了子按钮
					local _frmNode = _frm.childUI["PageNode"]
					if _frmNode then
						for i = 1, 4, 1 do
							--不重复点击自己
							--子按钮i
							local sbtn = _frmNode.childUI["SubPageBtn" .. i]
							if sbtn then
								local bx, by = sbtn.data.x + _frm.data.x, sbtn.data.y + _frm.data.y
								local w, h = sbtn.data.w, sbtn.data.h
								
								local button_left = bx - w / 2 --英雄选中区域的最左侧
								local button_right = bx + w / 2 --英雄选中区域的最右侧
								local button_top = by - h / 2 --英雄选中区域的最上侧
								local button_bottom = by + h / 2 --英雄选中区域的最下侧
								
								--检测是否点击到了子按钮i
								if (touchX >= button_left) and (touchX <= button_right) and (touchY >= button_top) and (touchY <= button_bottom) then
									--print("点到了" .. i)
									--先关闭本面板
									OnClosePanel()
									
									--模拟点击后面的子按钮
									sbtn.data.code(sbtn)
									
									break
								end
							end
						end
					end
				end
			end
		end,
	})
	
	local _frm = hGlobal.UI.PhoneRankBoardFrm_PVP_Endless
	local _parent = _frm.handle._n
	
	--左侧裁剪区域
	local _BTC_PageClippingRect_Rankboard = {0, -45 - 28 + BILLBOARD_NODE_OFFSET_Y, 900, 458, 0}
	local _BTC_pClipNode_Rankboard_endless = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect_Rankboard, 99, _BTC_PageClippingRect_Rankboard[5], "_BTC_pClipNode_Rankboard_endless")
	
	--关闭按钮
	local closeDx = -5
	local closeDy = -5
	--print(hVar.SCREEN.w, hVar.SCREEN.h)
	if (hVar.SCREEN.w <= 960) then
		closeDx = -35
	elseif (hVar.SCREEN.w >= 1136) then
		closeDx = 5
	end
	if (hVar.SCREEN.h <= 640) then
		closeDy = -35
	end
	--btnClose
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		model = "BTN:PANEL_CLOSE",
		x = _frm.data.w + closeDx + 60,
		y = closeDy + 65,
		scaleT = 0.95,
		code = function()
			--先关闭本界面
			OnClosePanel()
			
			--跳转到铜雀台的主页子分页
			local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
			if _frm then
				local btn2 = _frm.childUI["PageBtn2"]
				if btn2 then
					btn2.data.code(btn2)
				end
			end
		end,
	})
	
	--[[
	--"排行榜"的返回（只响应事件，不显示）
	_frm.childUI["returnBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		model = "misc/mask.png",
		x = 0 + 310 + 208 + 345,
		y = 28 - 400 - 167,
		w = 100,
		h = 100,
		scaleT = 0.95,
		code = function()
			--先关闭本面板
			OnClosePanel()
			
			--返回到竞技场的子分页
			local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
			if _frm then
				local _frmNode = _frm.childUI["PageNode"]
				if _frmNode then
					--子按钮i
					local sbtn = _frmNode.childUI["SubPageBtn2"]
					if sbtn then --模拟点击后面的子按钮
						sbtn.data.clear() --先清除数据
						sbtn.data.code(sbtn)
					end
				end
			end
		end,
	})
	_frm.childUI["returnBtn"].handle.s:setOpacity(0) --只响应事件，不显示
	
	--"排行榜"的图标
	_frm.childUI["returnBtn"].childUI["image"] = hUI.image:new({
		parent = _frm.childUI["returnBtn"].handle._n,
		x = 0,
		y = 0,
		model = "UI:button_return",
		scale = 1.0,
	})
	local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.8, ccp(-3, 0)), CCMoveBy:create(0.8, ccp(3, 0)))
	local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
	_frm.childUI["returnBtn"].childUI["image"].handle._n:runAction(forever)
	]]
	
	--[[
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
	]]
	
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
		z = 99,
		w = 1,
		h = 1,
		--border = 0,
		--background = "UI:Tactic_Background",
		--z = 10,
	})
	
	--清空所有分页左侧的UI
	_removeLeftFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneRankBoardFrm_PVP_Endless
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneRankBoardFrm_PVP_Endless
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
		--移除监听：收到ping值回调
		hGlobal.event:listen("LocalEvent_Pvp_Ping", "__PvpPing_page_Endless", nil)
		--移除监听：收到连接结果回调
		hGlobal.event:listen("LocalEvent_Pvp_NetEvent", "__ConnectBack_Endless", nil)
		--移除监听：收到登入结果回调
		hGlobal.event:listen("LocalEvent_Pvp_PlayerLoginEvent", "__LoginBack_Endless", nil)
		--移除事件监听：收到服务器时间的回调
		hGlobal.event:listen("localEvent_refresh_Systime", "__QueryBillBoardTime_Endless", nil)
		--移除事件监听：收到铜雀台当前排行数据的回调
		hGlobal.event:listen("localEvent_ShowPvpEndlessBillboard", "__QueryBillBoard_Endless", nil)
		--移除事件监听：程序进入后台的回调
		hGlobal.event:listen("LocalEvent_AppEnterBackground", "__QueryBillBoardEnterBG_Endless", nil)
		
		--移除本分页的timer
		hApi.clearTimer("__RANK_BOARD_UPDATE_PVP_ENDLESS__")
		hApi.clearTimer("__RANK_QUERY_TIMER_PVP_ENDLESS__")
		
		--隐藏所有的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Rankboard_endless", 0)
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：排行榜
			--创建排行榜分页
			OnCreateRankBoardFrame_PVP_Endless(pageIndex)
		end
		
		--标记当前选择的分页和页内的第几个
		CurrentSelectRecord.pageIdx = pageIndex
		CurrentSelectRecord.contentIdx = 0
	end
	
	--函数：关闭本界面
	OnClosePanel = function()
		--触发事件：刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
		--hGlobal.event:event("LocalEvent_RefreshMedalStateUI")
		
		--不显示排行榜面板
		hGlobal.UI.PhoneRankBoardFrm_PVP_Endless:show(0)
		
		--关闭界面后不需要监听的事件
		--取消监听：收到网络宝箱数量的事件
		--hGlobal.event:listen("LocalEvent_getNetChestNum", "__ItemGetChestNum_Frm", nil)
		
		--清空切换分页之后取消的监听事件
		--移除监听：收到ping值回调
		hGlobal.event:listen("LocalEvent_Pvp_Ping", "__PvpPing_page_Endless", nil)
		--移除监听：收到连接结果回调
		hGlobal.event:listen("LocalEvent_Pvp_NetEvent", "__ConnectBack_Endless", nil)
		--移除监听：收到登入结果回调
		hGlobal.event:listen("LocalEvent_Pvp_PlayerLoginEvent", "__LoginBack_Endless", nil)
		--移除事件监听：收到服务器时间的回调
		hGlobal.event:listen("localEvent_refresh_Systime", "__QueryBillBoardTime_Endless", nil)
		--移除事件监听：收到铜雀台当前排行数据的回调
		hGlobal.event:listen("localEvent_ShowPvpEndlessBillboard", "__QueryBillBoard_Endless", nil)
		--移除事件监听：程序进入后台的回调
		hGlobal.event:listen("LocalEvent_AppEnterBackground", "__QueryBillBoardEnterBG_Endless", nil)
		
		--清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--删除排行榜刷新界面timer
		hApi.clearTimer("__RANK_BOARD_UPDATE_PVP_ENDLESS__")
		hApi.clearTimer("__RANK_QUERY_TIMER_PVP_ENDLESS__")
		
		--隐藏所有的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Rankboard_endless", 0)
		
		--标记当前状态
		current_STATE = 0 --当前的状态(0:初始化 / 1:正在连接、登入、查询服务器时间 / 3:查询完毕)
		--current_enter_bg = 0 --当前程序是否在后台（如果进入后台，就不用定时器刷新排行榜情况）
		last_timer_query_time = 0 --上一次timer取排行榜的时间
		
		--关闭金币、积分界面
		--hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
		
		--触发事件：关闭了主菜单按钮
		--hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
		--如果是通过哪个地图传进来的，关闭界面之后，再打开之前的界面
		--if current_mapName_entry and (current_mapName_entry ~= 0) then
		--	hGlobal.event:event("LocalEvent_Phone_ShowEndlessMapInfoFrm", current_mapName_entry)
		--end
	end
	
	--函数：创建铜雀台排行榜界面（第1个分页）
	OnCreateRankBoardFrame_PVP_Endless = function(pageIdx)
		local _frm = hGlobal.UI.PhoneRankBoardFrm_PVP_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--允许本分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Rankboard_endless", 1)
		
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
			y = BILLBOARD_NODE_OFFSET_Y - 47 + 31,
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
			y = BILLBOARD_NODE_OFFSET_Y - 585 + 36,
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
			y = BILLBOARD_NODE_OFFSET_Y - 40 + 26,
			w = 300,
			h = 50,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (current_pveMultiLog.num > (BILLBOARD_X_NUM * BILLBOARD_Y_NUM)) then
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
			y = BILLBOARD_NODE_OFFSET_Y - 590 + 33,
			w = 300,
			h = 50,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (current_pveMultiLog.num > (BILLBOARD_X_NUM * BILLBOARD_Y_NUM)) then
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
			y = BILLBOARD_NODE_OFFSET_Y - 308 + 8,
			w = 840,
			h = BILLBOARD_NODE_HEIGHT - 89,
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
				if (current_pveMultiLog.num <= (BILLBOARD_X_NUM * BILLBOARD_Y_NUM)) then
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
					if (current_STATE == 3) then --当前的状态(0:初始化 / 1:正在连接、登入、查询服务器时间 / 3:查询完毕)
						--注意: 如果刚打开界面的瞬间，子控件都被删掉了，而这点击屏幕，并且有上一次排行榜缓存数据，逻辑会走到这，但是此时界面还没，会弹框
						if (_frmNode.childUI["BillboardNode1"] ~= nil) then
							for i = 1, current_pveMultiLog.num, 1 do
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
				if (current_STATE == 3) then --当前的状态(0:初始化 / 1:正在连接、登入、查询服务器时间 / 3:查询完毕)
					--注意: 如果刚打开界面的瞬间，子控件都被删掉了，而这点击屏幕，并且有上一次排行榜缓存数据，逻辑会走到这，但是此时界面还没，会弹框
					if (_frmNode.childUI["BillboardNode1"] ~= nil) then
						for i = 1, current_pveMultiLog.num, 1 do
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
				--print(math.abs(touchY - click_pos_y_billboard), BILLBOARD_HEIGHT)
				if (click_scroll_billboard) and (math.abs(touchY - click_pos_y_billboard) > 32) then
					selected_billboardEx_idx = 0
				end
				--print("selected_billboardEx_idx", selected_billboardEx_idx)
				
				--之前选中了某个排行榜
				if (selected_billboardEx_idx > 0) then
					OnRefreshRankBoardFrame_PVP_Endless(selected_billboardEx_idx, touchX, touchY)
					
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
			x = BILLBOARD_NODE_OFFSET_X + 724,
			y = BILLBOARD_NODE_OFFSET_Y - 9,
			w = 36,
			h = 36,
		})
		_frmNode.childUI["waiting"].handle.s:setVisible(false) --一开始不显示小菊花
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "waiting"
		
		------------------------------------------------------------------
		--左侧排行榜的各列的标题
		--排行的底纹
		_frmNode.childUI["RankColBG"] = hUI.image:new({
			parent = _parentNode,
			x = BILLBOARD_NODE_OFFSET_X + 320 + 9,
			y = BILLBOARD_NODE_OFFSET_Y - 140 + 87,
			model = "UI:td_mui_blbar", --UI:login_lk", --"misc/y_mask_16.png",
			w = 836,
			h = 32,
		})
		_frmNode.childUI["RankColBG"].handle.s:setColor(ccc3(128, 128, 128))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RankColBG"
		
		--排行的排名
		_frmNode.childUI["RankCol1"] = hUI.label:new({
			parent = _parentNode,
			x = BILLBOARD_NODE_OFFSET_X + 5 - 60,
			y = BILLBOARD_NODE_OFFSET_Y - 140 + 87 - 1, --数字有1像素偏差
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
		_frmNode.childUI["RankCol3"] = hUI.label:new({
			parent = _parentNode,
			x = BILLBOARD_NODE_OFFSET_X - 25 + 60,
			y = BILLBOARD_NODE_OFFSET_Y - 140 + 87 - 1, --数字有1像素偏差
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
			--text = "玩家名", --language
			text = hVar.tab_string["__TEXT_PlayerName"], --language
		})
		_frmNode.childUI["RankCol3"].handle.s:setColor(ccc3(255, 255, 223))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RankCol3"
		
		--排行的出战阵容
		_frmNode.childUI["RankCol4"] = hUI.label:new({
			parent = _parentNode,
			x = BILLBOARD_NODE_OFFSET_X + 25 + 330,
			y = BILLBOARD_NODE_OFFSET_Y - 140 + 87 - 1, --数字有1像素偏差
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
			--text = "出战阵容", --language
			text = hVar.tab_string["BattleList"], --language
		})
		_frmNode.childUI["RankCol4"].handle.s:setColor(ccc3(255, 255, 223))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RankCol4"
		
		--排行的通关时间
		_frmNode.childUI["RankCol2"] = hUI.label:new({
			parent = _parentNode,
			x = BILLBOARD_NODE_OFFSET_X + 685,
			y = BILLBOARD_NODE_OFFSET_Y - 140 + 87 - 1, --数字有1像素偏差
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
			--text = "通关时间", --language
			text = hVar.tab_string["PVP_CostTime"], --language
		})
		_frmNode.childUI["RankCol2"].handle.s:setColor(ccc3(255, 255, 223))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RankCol2"
		
		--我的底纹
		_frmNode.childUI["MyRankColBG"] = hUI.image:new({
			parent = _parentNode,
			x = BILLBOARD_NODE_OFFSET_X + 320 + 7,
			y = BILLBOARD_NODE_OFFSET_Y - 140 - 420 + 10,
			model = "UI:AttrBg", --UI:login_lk", --"misc/y_mask_16.png",
			w = 830,
			h = 32,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "MyRankColBG"
		
		--"我的排名"文字前缀
		_frmNode.childUI["MyRankCol1"] = hUI.label:new({
			parent = _parentNode,
			x = BILLBOARD_NODE_OFFSET_X + 25 - 100 + 104,
			y = BILLBOARD_NODE_OFFSET_Y - 140 - 422 + 11 - 1,
			size = 26,
			font = hVar.FONTC,
			align = "RC",
			width = 300,
			border = 1,
			--text = "我的排名", --language
			text = hVar.tab_string["__TEXT_MyRank"], --language
		})
		_frmNode.childUI["MyRankCol1"].handle.s:setColor(ccc3(0, 255, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "MyRankCol1"
		
		--"我的排名"值的背景图
		_frmNode.childUI["MyRankValBG"] = hUI.image:new({
			parent = _parentNode,
			x = BILLBOARD_NODE_OFFSET_X + 25 - 100 + 160,
			y = BILLBOARD_NODE_OFFSET_Y - 140 - 422 + 11,
			model = "UI:rank_bottom",
			w = 102,
			h = 28,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "MyRankValBG"
		
		--"我的通关时间"文字前缀
		_frmNode.childUI["MyRankCol2"] = hUI.label:new({
			parent = _parentNode,
			x = BILLBOARD_NODE_OFFSET_X + 25 + 350 + 60 + 104,
			y = BILLBOARD_NODE_OFFSET_Y - 140 - 422 + 11 - 1,
			size = 26,
			font = hVar.FONTC,
			align = "RC",
			width = 300,
			border = 1,
			--text = "我的通关时间", --language
			text = hVar.tab_string["PVP_MyCostTime"], --language
		})
		_frmNode.childUI["MyRankCol2"].handle.s:setColor(ccc3(0, 255, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "MyRankCol2"
		
		--"我的通关时间"值的背景图
		_frmNode.childUI["MyRankVal2BG"] = hUI.image:new({
			parent = _parentNode,
			x = BILLBOARD_NODE_OFFSET_X + 25 + 350 + 220,
			y = BILLBOARD_NODE_OFFSET_Y - 140 - 422 + 11,
			model = "UI:rank_bottom",
			w = 102,
			h = 28,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "MyRankVal2BG"
		
		--排行榜规则(铜雀台)按钮（响应区域）
		_frmNode.childUI["btnBoardIntro_Endless"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = BILLBOARD_NODE_OFFSET_X + 715,
			y = BILLBOARD_NODE_OFFSET_Y - 140 - 400,
			w = 84,
			h = 84,
			model = "misc/mask.png",
			scaleT = 1.0,
			code = function()
				--创建铜雀台排行榜规则介绍tip
				OnCreateRankBoardTipFrame_PVP_Endless()
			end,
		})
		_frmNode.childUI["btnBoardIntro_Endless"].handle.s:setOpacity(0) --用于响应事件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnBoardIntro_Endless"
		--问号图标
		_frmNode.childUI["btnBoardIntro_Endless"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["btnBoardIntro_Endless"].handle._n,
			dragbox = _frm.childUI["dragBox"],
			x = 0,
			y = 0,
			scale = 0.9,
			model = "ICON:action_info",
		})
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(1.0, 0.94) ,CCScaleTo:create(1.0, 0.86))
		local forever = CCRepeatForever:create(tolua.cast(towAction,"CCActionInterval"))
		_frmNode.childUI["btnBoardIntro_Endless"].childUI["icon"].handle._n:runAction(forever)
		
		--添加本分页的监听事件
		--添加监听：收到ping值回调
		hGlobal.event:listen("LocalEvent_Pvp_Ping", "__PvpPing_page_Endless", on_receive_ping_event_PVP_Endless)
		--添加监听：收到连接结果回调
		hGlobal.event:listen("LocalEvent_Pvp_NetEvent", "__ConnectBack_Endless", on_receive_connect_back_event_PVP_Endless)
		--添加监听：收到登入结果回调
		hGlobal.event:listen("LocalEvent_Pvp_PlayerLoginEvent", "__LoginBack_Endless", on_receive_login_back_event_PVP_Endless)
		--添加监听：收到服务器时间的回调
		hGlobal.event:listen("localEvent_refresh_Systime", "__QueryBillBoardTime_Endless", on_receive_refresh_systime_event_PVP_Endless)
		--添加监听：收到铜雀台当前排行数据的回调
		hGlobal.event:listen("localEvent_ShowPvpEndlessBillboard", "__QueryBillBoard_Endless", on_receive_billboard_event_PVP_Endless)
		--添加监听：程序进入后台的回调
		hGlobal.event:listen("LocalEvent_AppEnterBackground", "__QueryBillBoardEnterBG_Endless", on_enter_background_event_PVP_Endless)
		
		--创建只有本分页下才有的timer，刷新排行榜滚动
		hApi.addTimerForever("__RANK_BOARD_UPDATE_PVP_ENDLESS__", hVar.TIMER_MODE.GAMETIME, 30, refresh_rank_board_UI_loop_PVP_Endless)
		
		--添加本分页的timer，定时取排行榜最新排名
		hApi.addTimerForever("__RANK_QUERY_TIMER_PVP_ENDLESS__", hVar.TIMER_MODE.GAMETIME, QUERY_DELTA_SECOND * 1000, on_query_billboard_info_timer_PVP_Endless)
		
		--初始化当前状态
		current_STATE = 0 --当前的状态(0:初始化 / 1:正在连接、登入、查询服务器时间 / 3:查询完毕)
		--current_enter_bg = 0 --当前程序是否在后台（如果进入后台，就不用定时器刷新排行榜情况）
		last_timer_query_time = 0 --上一次timer取排行榜的时间
		
		if (g_cur_net_state == -1) or (Pvp_Server:GetState() ~= 1) or (not hGlobal.LocalPlayer:getonline()) then --未联网、未连接pvp、未登陆pvp
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
			current_STATE = 1 --当前的状态(0:初始化 / 1:正在连接、登入、查询服务器时间 / 3:查询完毕)
			
			--发起登入操作
			--print("发起登入操作")
			--print("发起登入操作", Pvp_Server:GetState())
			if (Pvp_Server:GetState() == 1) then --不重复登入
				--模拟触发连接结果回调
				on_receive_connect_back_event_PVP_Endless(1)
			else
				--连接
				Pvp_Server:Connect()
			end
			
			--发起查询服务器系统时间
			--SendCmdFunc["refresh_systime"]()
		end
	end
	
	--函数：收到连接结果回调
	on_receive_ping_event_PVP_Endless = function(ping, online_num)
		local _frm = hGlobal.UI.PhoneRankBoardFrm_PVP_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--存储pvp我的ping值
		--current_ping_value = ping
		
		--存储pvp在线人数
		--current_online_num = online_num
		
		local _frm2 = hGlobal.UI.PhoneBattleRoomFrm_Endless
		if _frm2 then
			local _frmNode2 = _frm2.childUI["PageNode"]
			if _frmNode2 then
				--绘制pvp铜雀台的在线人数控件
				if _frmNode2.childUI["RoomOnlineLabel"] then
					_frmNode2.childUI["RoomOnlineLabel"]:setText(online_num)
				end
			end
		end
	end
	
	--函数：收到连接结果回调
	on_receive_connect_back_event_PVP_Endless = function(net_state)
		--print("收到连接结果回调", net_state)
		local _frm = hGlobal.UI.PhoneRankBoardFrm_PVP_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--标记连接状态
		--current_connect_state = net_state --连接状态
		
		if (net_state == 1) then
			--发送登陆请求
			--print("发送登陆请求", hGlobal.LocalPlayer:getonline())
			if hGlobal.LocalPlayer:getonline() then --不重复登陆
				--模拟触发收到登入结果回调
				on_receive_login_back_event_PVP_Endless(1, hGlobal.LocalPlayer.data.playerId)
			else
				--print("调试-: " .. "Pvp_Server:UserLogin(1)")
				Pvp_Server:UserLogin()
			end
		else
			--失败
			--取消挡操作
			hUI.NetDisable(0)
		end
	end
	
	--函数：收到登入结果回调
	on_receive_login_back_event_PVP_Endless = function(iResult, playerId) --0失败 1成功
		--print("收到登入结果回调")
		local _frm = hGlobal.UI.PhoneRankBoardFrm_PVP_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		--print("login_state", login_state)
		
		--标记登入状态
		--current_login_state = iResult --登入状态
		
		if (iResult == 1) then
			--存储本地玩家id
			--current_PlayerId = playerId
			
			--检测time，是否需要再次查询铜雀台排行榜的信息
			local timestamp = os.time() - g_localDeltaTime --(Local = Host + deltaTime)
			local deltatime = timestamp - last_query_multy_pve_board_time
			--print("deltatime=", deltatime, QUERY_DELTA_SECOND)
			if (deltatime >= QUERY_DELTA_SECOND) then
				--发起查询服务器系统时间
				SendCmdFunc["refresh_systime"]()
			else
				--print("用本地存储的系统时间继续流程")
				--用本地存储的系统时间继续流程
				on_receive_refresh_systime_event_PVP_Endless()
			end
		else
			--失败
			--...
		end
	end
	
	--函数：收到铜雀台系统时间的回调
	on_receive_refresh_systime_event_PVP_Endless = function()
		--print("收到系统时间的回调")
		local _frm = hGlobal.UI.PhoneRankBoardFrm_PVP_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--if (current_STATE == 1) then --当前的状态(0:初始化 / 1:正在连接、登入、查询服务器时间 / 3:查询完毕)
			--标记当前状态为查询完毕
			current_STATE = 3 --当前的状态(0:初始化 / 1:正在连接、登入、查询服务器时间 / 3:查询完毕)
			
			--隐藏正在网络查询的小菊花
			_frmNode.childUI["waiting"].handle.s:setVisible(false)
			
			--检测time，是否需要再次查询铜雀台排行榜的信息
			local timestamp = os.time() - g_localDeltaTime --(Local = Host + deltaTime)
			local deltatime = timestamp - last_query_multy_pve_board_time
			--print("deltatime=", deltatime, QUERY_DELTA_SECOND)
			if (deltatime >= QUERY_DELTA_SECOND) then
				--标记最新查询排行榜的时间
				last_query_multy_pve_board_time = timestamp
				
				--显示正在网络查询的小菊花
				_frmNode.childUI["waiting"].handle.s:setVisible(true)
				
				--print("发起查询，获取铜雀台排行榜信息")
				--发起查询，获取铜雀台排行榜信息
				SendPvpCmdFunc["get_pve_multi_log"](0, 20)
			else
				--print("用本地存储的铜雀台数据绘制界面")
				--用本地存储的铜雀台数据绘制界面
				on_receive_billboard_event_PVP_Endless(current_pveMultiLog)
			end
		--end
	end
	
	--函数：收到铜雀台当前排行数据的回调事件
	on_receive_billboard_event_PVP_Endless = function(pveMultiLog)
		--print("收到铜雀台排行榜")
		local _frm = hGlobal.UI.PhoneRankBoardFrm_PVP_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--隐藏正在网络查询的小菊花
		_frmNode.childUI["waiting"].handle.s:setVisible(false)
		
		--优化处理: 检测本次排行和上次的是否完全一致（如果完全一致，不需要重绘界面）
		local bAllSamed = true
		if (type(current_pveMultiLog) ~= "table") or (type(pveMultiLog) ~= "table") then
			bAllSamed = false
		elseif (current_pveMultiLog.num ~= pveMultiLog.num) then
			bAllSamed = false
		else
			for i = 1, #pveMultiLog, 1 do
				if bAllSamed then
					local id = pveMultiLog[i].id
					local gametime = pveMultiLog[i].gametime
					local playerInfo = pveMultiLog[i].playerInfo
					local cur_id = current_pveMultiLog[i].id
					local cur_gametime = current_pveMultiLog[i].gametime
					local cur_playerInfo = current_pveMultiLog[i].playerInfo
					
					if (cur_id ~= id) or (cur_gametime ~= gametime) or (#cur_playerInfo ~= #playerInfo) then --id、游戏时间、配置不一致
						bAllSamed = false
						break
					end
					
					for p = 1, #playerInfo, 1 do
						local tp = playerInfo[p]
						local udbid = tp.udbid --玩家dibid
						--local name = tp.name --玩家名
						--local hero = tp.hero --玩家使用的英雄数据
						--local tower = tp.tower --玩家使用的塔数据
						local cur_tp = cur_playerInfo[p]
						local cur_udbid = cur_tp.udbid --玩家dibid
						
						if (udbid ~= cur_udbid) then --玩家不一致
							bAllSamed = false
							break
						end
					end
				end
			end
		end
		
		--如果和上一次排行榜完全一致，不重复绘制
		if bAllSamed then
			--print("如果和上一次排行榜完全一致，不重复绘制")
			if (_frmNode.childUI["BillboardNode1"] ~= nil) then --排行榜已经绘制了界面
				return
			end
		end
		
		--先清空右侧的信息
		_removeRightFrmFunc()
		
		--检测版本号，是否为最新版本
		local local_srcVer = tostring(hVar.CURRENT_ITEM_VERSION) --1.0.070502
		local version_control = tostring(g_version_control) --1.0.070502-v018-018-app
		local vbpos = string.find(version_control, "-")
		if vbpos then
			version_control = string.sub(version_control, 1, vbpos - 1)
		end
		if (local_srcVer < version_control) then
			--弹系统框
			local msgTitle = hVar.tab_string["__TEXT_SystemNotice"]
			if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员，显示具体的版本号
				msgTitle = hVar.tab_string["__TEXT_SystemNotice"] .. " (" .. local_srcVer .. "|" .. version_control .. ")"
			end
			--hApi.ShowSysMsgBox(msgTitle, hVar.tab_string["__TEXT_ScriptsTooOld"])
			
			--弹系统框标题
			_frmNode.childUI["msgboxTitle"] = hUI.label:new({
				parent = _parentNode,
				x = BILLBOARD_NODE_OFFSET_X + 330,
				y = BILLBOARD_NODE_OFFSET_Y - 310 + 110,
				size = 34,
				font = hVar.FONTC,
				align = "MC",
				width = 400,
				border = 1,
				text = msgTitle,
			})
			_frmNode.childUI["msgboxTitle"].handle.s:setColor(ccc3(0, 255, 0))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "msgboxTitle"
			
			--弹系统框标题
			_frmNode.childUI["msgboxContent"] = hUI.label:new({
				parent = _parentNode,
				x = BILLBOARD_NODE_OFFSET_X + 330,
				y = BILLBOARD_NODE_OFFSET_Y - 310 + 50,
				size = 26,
				font = hVar.FONTC,
				align = "MT",
				width = 660,
				border = 1,
				--text = "游戏有更新！请重新启动游戏，进行自动更新！", --language
				text = hVar.tab_string["__TEXT_ScriptsTooOld"], --language
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "msgboxContent"
			
			return
		end
		
		--存储本次排行数据
		--[[
		--测试 --test
		local testest = "本人认为从以往的试点城市来看sss我过的征收的税率还是远远的低于国际上的平均水平的fff我想就算是房地产税落地实施ggg也没有我们想像的那么悲催，政府肯定会根据不同地区执行不同的征收标准，还会依照中国的国情设定一定的免征额。我想我们普通老百姓到时的税收会有一个对冲的效果，不必太多担忧。对于没有房子的朋友也称得上是利好，有了房地产税，呢么对于一些市场上的包租婆就相当于是增加了他们囤积房子的成本，也会让他们将手上空闲的余房进行抛售，那么市场上的房源供过于求，就会使我们没房的朋友购买房子的时候房价应该有所减少。要是楼市资金出逃的话，那么势必股市的资金就会流入，近期可以重点关注房地产板块，寻找一些资金流入，趋势走好，股价处于低位的个股关注，个股案例欢迎咨询。"
		pveMultiLog.num = 50
		for i = 1, pveMultiLog.num, 1 do
			local randNum = math.random(3, 5)
			local str = ""
			for i = 1, randNum, 1 do
				local idx = math.random(1, #testest)
				str = str .. string.sub(testest, idx, idx + 2)
			end
			pveMultiLog.info[i] = {}
			pveMultiLog.info[i].name = str
			pveMultiLog.info[i].rank = math.random(1, 10000)
		end
		]]
		--current_pveMultiLog = pveMultiLog
		
		--依次绘制每个排行
		local cFirstIdx = pveMultiLog.cFirstIdx --起始条目idx
		local cNum = pveMultiLog.cNum --条目数
		local num = pveMultiLog.num --查询到的数量
		--print(cFirstIdx, cNum, num)
		for i = 1, num, 1 do
			local validIdx = i
			local xn = (validIdx % BILLBOARD_X_NUM) --xn
			if (xn == 0) then
				xn = BILLBOARD_X_NUM
			end
			local yn = (validIdx - xn) / BILLBOARD_X_NUM + 1 --yn
			
			local offsetX = BILLBOARD_NODE_OFFSET_X + 45 + 281 + (xn - 1) * 150 
			local offsetY = BILLBOARD_NODE_OFFSET_Y - 190 + 45 - (yn - 1) * (BILLBOARD_HEIGHT + 6)
			
			--绘制该行
			OnCreateSingleBoardData_PVP(_BTC_pClipNode_Rankboard_endless, i, offsetX, offsetY, cFirstIdx, cNum, pveMultiLog)
			
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
		
		--我的排行的父控件
		local iMe = 0
		local offsetXMe = BILLBOARD_NODE_OFFSET_X + 25
		local offsetYMe = BILLBOARD_NODE_OFFSET_Y - 560
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
		
		--"我的排名"颜色
		local rankingMe = pveMultiLog.rankingMe or -1
		--rankingMe = -1 --测试 --test
		local paintColor = nil
		if (rankingMe == 1) then --第1名
			--金色
			paintColor = ccc3(255, 224, 0)
		elseif (rankingMe == 2) then --第2名
			--银色
			paintColor = ccc3(212, 212, 212)
		elseif (rankingMe == 3) then --第3名
			--铜色
			paintColor = ccc3(233, 168, 0)
		elseif (rankingMe > 0) then --第4~n名
			paintColor = ccc3(255, 255, 255)
		else --无名次
			paintColor = ccc3(192, 192, 192)
		end
		
		--"我的排名"值
		if (rankingMe == 1) then --第1名
			_frmNode.childUI["BillboardNode" .. iMe].childUI["RankLabel"] = hUI.image:new({
				parent = _frmNode.childUI["BillboardNode" .. iMe].handle._n,
				model = "UI:rank_n_1",
				x = 36 + 60 + 15 - 50,
				y = -2 + 11,
				scale = 1.0,
			})
		elseif (rankingMe == 2) then --第2名
			_frmNode.childUI["BillboardNode" .. iMe].childUI["RankLabel"] = hUI.image:new({
				parent = _frmNode.childUI["BillboardNode" .. iMe].handle._n,
				model = "UI:rank_n_2",
				x = 36 + 60 + 15 - 50,
				y = -2 + 11,
				scale = 1.0,
			})
		elseif (rankingMe == 3) then --第3名
			_frmNode.childUI["BillboardNode" .. iMe].childUI["RankLabel"] = hUI.image:new({
				parent = _frmNode.childUI["BillboardNode" .. iMe].handle._n,
				model = "UI:rank_n_3",
				x = 36 + 60 + 15 - 50,
				y = -2 + 11,
				scale = 1.0,
			})
		elseif (rankingMe > 0) then --其他名次
			_frmNode.childUI["BillboardNode" .. iMe].childUI["RankLabel"] = hUI.label:new({
				parent = _frmNode.childUI["BillboardNode" .. iMe].handle._n,
				x = 36 + 60 + 15 - 50,
				y = -3 + 11, --字体有1像素偏差
				size = 22,
				font = "numWhite",
				align = "MC",
				width = 300,
				--border = 1,
				text = rankingMe,
			})
			_frmNode.childUI["BillboardNode" .. iMe].childUI["RankLabel"].handle.s:setColor(paintColor)
		else --无名次
			_frmNode.childUI["BillboardNode" .. iMe].childUI["RankLabel"] = hUI.label:new({
				parent = _frmNode.childUI["BillboardNode" .. iMe].handle._n,
				x = 36 + 60 + 15 - 50,
				y = -3 + 11, --字体有1像素偏差
				size = 24,
				font = hVar.FONTC,
				align = "MC",
				width = 300,
				--text = "暂无", --language
				text = hVar.tab_string["__TEXT_TemporaryNone"], --language
				border = 1,
			})
			_frmNode.childUI["BillboardNode" .. iMe].childUI["RankLabel"].handle.s:setColor(paintColor)
		end
		
		--我的通关时间
		local gametimeMe = pveMultiLog.gametimeMe or -1
		if (gametimeMe > 0) then --有名次
			--绘制我的通关时间
			local minuteMe = math.floor((gametimeMe) / 60) --分
			local secondMe = gametimeMe - minuteMe * 60 --秒
			local strSecondMe = tostring(secondMe)
			if (#strSecondMe < 2) then
				strSecondMe = "0" .. strSecondMe
			end
			
			_frmNode.childUI["BillboardNode" .. iMe].childUI["GameTimeLabel"] = hUI.label:new({
				parent = _frmNode.childUI["BillboardNode" .. iMe].handle._n,
				x = 463 + 106,
				y = -3 + 11, --字体有1像素偏差
				size = 22,
				font = "numWhite",
				align = "MC",
				width = 300,
				--border = 1,
				text = (minuteMe .. ":" .. strSecondMe),
			})
			_frmNode.childUI["BillboardNode" .. iMe].childUI["GameTimeLabel"].handle.s:setColor(paintColor)
		else --无名次
			_frmNode.childUI["BillboardNode" .. iMe].childUI["GameTimeLabel"] = hUI.label:new({
				parent = _frmNode.childUI["BillboardNode" .. iMe].handle._n,
				x = 463 + 106,
				y = -3 + 11, --字体有1像素偏差
				size = 24,
				font = hVar.FONTC,
				align = "MC",
				width = 300,
				--text = "暂无", --language
				text = hVar.tab_string["__TEXT_TemporaryNone"], --language
				border = 1,
			})
			_frmNode.childUI["BillboardNode" .. iMe].childUI["GameTimeLabel"].handle.s:setColor(paintColor)
		end
		
		--翻页按钮是否显示
		_frmNode.childUI["BillboardPageUp"].handle.s:setVisible(false) --不显示上翻页提示
		--如果排行总数量超过一页，那么显示下翻页提示
		if (pveMultiLog.num > (BILLBOARD_X_NUM * BILLBOARD_Y_NUM)) then
			_frmNode.childUI["BillboardPageDown"].handle.s:setVisible(true) --显示下翻页提示
		end
		
		--最后存储本次排行榜的数据（放在最后存储，是为了其他timer刷新界面时，取的数量为旧的，避免新控件还未创建）
		current_pveMultiLog = pveMultiLog
	end
	
	--函数：收到程序进入后台的回调事件
	on_enter_background_event_PVP_Endless = function(flag)
		--print("收到程序进入后台的回调事件", flag)
		--current_enter_bg = flag --当前程序是否在后台（如果进入后台，就不用定时器刷新排行榜情况）
		if (flag == 1) then
			--移除timer
			--print("移除timer")
			--hApi.clearTimer("__RANK_QUERY_TIMER_PVP_ENDLESS__")
			--暂停定时器
			--hApi.PauseTimer()
		elseif (flag == 0) then
			--添加timer
			--print("添加timer")
			--hApi.addTimerForever("__RANK_QUERY_TIMER_PVP_ENDLESS__", hVar.TIMER_MODE.GAMETIME, QUERY_DELTA_SECOND * 1000, on_query_billboard_info_timer_PVP_Endless)
			--恢复定时器
			--hApi.ResumeTimer()
		end
	end
	
	--函数：绘制单条铜雀台排行榜条目的内容
	OnCreateSingleBoardData_PVP = function(parent, index, offsetX, offsetY, cFirstIdx, cNum, pveMultiLog)
		local _frm = hGlobal.UI.PhoneRankBoardFrm_PVP_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local i = index
		local ranking = i
		
		local id = pveMultiLog[i].id
		local gametime = pveMultiLog[i].gametime
		local playerInfo = pveMultiLog[i].playerInfo
		
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
		
		--背景图
		local bgModel = nil
		if (i % 2 == 0) then
			bgModel = "misc/y_mask_16.png"
		else
			bgModel = "misc/y_mask_16.png"
		end
		_frmNode.childUI["BillboardNode" .. i].childUI["imageBG"] = hUI.image:new({
			parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
			model = bgModel,
			x = 0,
			y = 0,
			w = BILLBOARD_WIDTH,
			h = BILLBOARD_HEIGHT,
		})
		local bgModel = nil
		if (i % 2 == 0) then
			_frmNode.childUI["BillboardNode" .. i].childUI["imageBG"].handle.s:setOpacity(32)
		else
			_frmNode.childUI["BillboardNode" .. i].childUI["imageBG"].handle.s:setOpacity(64)
		end
		
		--左边界线
		_frmNode.childUI["BillboardNode" .. i].childUI["imageBG_lineL"] = hUI.image:new({
			parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
			model = "UI:vipline",
			x = -BILLBOARD_WIDTH / 2 + 3,
			y = 0,
			w = BILLBOARD_HEIGHT,
			h = 1,
		})
		_frmNode.childUI["BillboardNode" .. i].childUI["imageBG_lineL"].handle.s:setRotation(-90)
		
		--右边界线
		_frmNode.childUI["BillboardNode" .. i].childUI["imageBG_lineR"] = hUI.image:new({
			parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
			model = "UI:vipline",
			x = BILLBOARD_WIDTH / 2 - 3,
			y = 0,
			w = BILLBOARD_HEIGHT,
			h = 1,
		})
		_frmNode.childUI["BillboardNode" .. i].childUI["imageBG_lineR"].handle.s:setRotation(90)
		
		--上边界线
		_frmNode.childUI["BillboardNode" .. i].childUI["imageBG_lineU"] = hUI.image:new({
			parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
			model = "UI:vipline",
			x = 0,
			y = BILLBOARD_HEIGHT / 2,
			w = BILLBOARD_WIDTH - 4, --宽
			h = 1,
		})
		_frmNode.childUI["BillboardNode" .. i].childUI["imageBG_lineU"].handle.s:setRotation(0)
		
		--下边界线
		_frmNode.childUI["BillboardNode" .. i].childUI["imageBG_lineD"] = hUI.image:new({
			parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
			model = "UI:vipline",
			x = 0,
			y = -BILLBOARD_HEIGHT / 2,
			w = BILLBOARD_WIDTH - 4, --宽
			h = 1,
		})
		_frmNode.childUI["BillboardNode" .. i].childUI["imageBG_lineD"].handle.s:setRotation(180)
		
		local OFFSET_DX = -281
		
		--[[
		--排行的排名
		if (ranking == 1) then --第1名
			--金色
			paintColor = ccc3(255, 224, 0)
			
			_frmNode.childUI["BillboardNode" .. i].childUI["RankLabel"] = hUI.image:new({
				parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
				model = "UI:rank_n_1",
				x = OFFSET_DX - 98,
				y = 0,
				scale = 1.0,
			})
		elseif (ranking == 2) then --第2名
			--银色
			paintColor = ccc3(212, 212, 212)
			
			_frmNode.childUI["BillboardNode" .. i].childUI["RankLabel"] = hUI.image:new({
				parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
				model = "UI:rank_n_2",
				x = OFFSET_DX - 98,
				y = 0,
				scale = 1.0,
			})
		elseif (ranking == 3) then --第3名
			--铜色
			paintColor = ccc3(233, 168, 0)
			
			_frmNode.childUI["BillboardNode" .. i].childUI["RankLabel"] = hUI.image:new({
				parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
				model = "UI:rank_n_3",
				x = OFFSET_DX - 98,
				y = 0,
				scale = 1.0,
			})
		else --其他名次
			paintColor = ccc3(255, 255, 255) --第4~n名
			
			local scoreRankingSize = 22
			if (ranking > 9) then
				scoreRankingSize = 20
			end
			_frmNode.childUI["BillboardNode" .. i].childUI["RankLabel"] = hUI.label:new({
				parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
				x = OFFSET_DX - 98 - 2,
				y = 0,
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
		]]
		--排行的排名
		if (ranking == 1) then --第1名
			--金色
			paintColor = ccc3(255, 224, 0)
		elseif (ranking == 2) then --第2名
			--银色
			paintColor = ccc3(212, 212, 212)
		elseif (ranking == 3) then --第3名
			--铜色
			paintColor = ccc3(233, 168, 0)
		else --其他名次
			paintColor = ccc3(255, 255, 255) --第4~n名
		end
		_frmNode.childUI["BillboardNode" .. i].childUI["RankLabel"] = hUI.label:new({
			parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
			x = OFFSET_DX - 98 - 3,
			y = 0,
			size = 26,
			font = "numWhite",
			align = "MC",
			width = 300,
			--border = 1,
			text = ranking,
		})
		_frmNode.childUI["BillboardNode" .. i].childUI["RankLabel"].handle.s:setColor(paintColor)
		
		--绘制通关时间
		local minute = math.floor((gametime) / 60) --分
		local second = gametime - minute * 60 --秒
		local strSecond = tostring(second)
		if (#strSecond < 2) then
			strSecond = "0" .. strSecond
		end
		_frmNode.childUI["BillboardNode" .. i].childUI["costTime"] = hUI.label:new({
			parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
			x = OFFSET_DX + 645,
			y = 0,
			size = 20,
			font = "numWhite",
			align = "MC",
			width = 300,
			text = (minute .. ":" .. strSecond),
			border = 0,
		})
		_frmNode.childUI["BillboardNode" .. i].childUI["costTime"].handle.s:setColor(paintColor)
		--_frmNode.childUI["BillboardNode" .. i].childUI["costTime"].handle.s:setColor(ccc3(212, 255, 212))
		
		--玩家的分界线1
		_frmNode.childUI["BillboardNode" .. i].childUI["PlayerLine1"] = hUI.image:new({
			parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
			model = "UI:title_line", --"UI:vipline", --"UI:Tactic_SeparateLine",
			x = OFFSET_DX + 268,
			y = -2,
			w = 666,
			--h = 4,
			h = 2,
		})
		_frmNode.childUI["BillboardNode" .. i].childUI["PlayerLine1"].handle.s:setRotation(180)
		--_frmNode.childUI["BillboardNode" .. i].childUI["PlayerLine1"].handle.s:setColor(ccc3(0, 255, 0))
		_frmNode.childUI["BillboardNode" .. i].childUI["PlayerLine1"].handle.s:setOpacity(168)
		
		--玩家的分界线2
		_frmNode.childUI["BillboardNode" .. i].childUI["PlayerLine2"] = hUI.image:new({
			parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
			model = "UI:title_line", --"UI:vipline", --"UI:Tactic_SeparateLine",
			x = OFFSET_DX + 511,
			y = -1,
			w = 180,
			--h = 4,
			h = 2,
		})
		--_frmNode.childUI["BillboardNode" .. i].childUI["PlayerLine2"].handle.s:setColor(ccc3(0, 255, 0))
		_frmNode.childUI["BillboardNode" .. i].childUI["PlayerLine2"].handle.s:setOpacity(168)
		
		--依次绘制本条的所有玩家的信息
		for p = 1, #playerInfo, 1 do
			local tp = playerInfo[p]
			local udbid = tp.udbid --玩家dibid
			local name = tp.name --玩家名
			local hero = tp.hero --玩家使用的英雄数据
			local tower = tp.tower --玩家使用的塔数据
			--print(i, "玩家" .. p, udbid, name)
			
			--绘制玩家名
			_frmNode.childUI["BillboardNode" .. i].childUI["Player_" .. p .. "_" .. "name"] = hUI.label:new({
				parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
				x = OFFSET_DX - 10,
				y = 35 - (p - 1) * 75,
				size = 24,
				font = hVar.FONTC,
				align = "MC",
				width = 300,
				text = name,
				--text = "策马守天关",
				border = 1,
			})
			_frmNode.childUI["BillboardNode" .. i].childUI["Player_" .. p .. "_" .. "name"].handle.s:setColor(paintColor)
			--if (p == 1) then --玩家1
			--	_frmNode.childUI["BillboardNode" .. i].childUI["Player_" .. p .. "_" .. "name"].handle.s:setColor(ccc3(192, 255, 255))
			--else --玩家2
			--	_frmNode.childUI["BillboardNode" .. i].childUI["Player_" .. p .. "_" .. "name"].handle.s:setColor(ccc3(192, 255, 192))
			--end
			
			--如果该玩家是我，显示叹号
			if (udbid == xlPlayer_GetUID()) then
				--存储第一条我的排行
				--if (pveMultiLog.rankingMe == nil) then
				--	pveMultiLog.rankingMe = index
				--end
				
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
				
				--[[
				local enterNameEditBox = CCEditBox:create(CCSizeMake(BILLBOARD_WIDTH, BILLBOARD_HEIGHT / 2), CCScale9Sprite:create("data/image/misc/win_back.png"))--"data/image/misc/win_back.png""data/image/misc/1xs.png"
				enterNameEditBox:setPosition(ccp(281, BILLBOARD_HEIGHT / 4 - (p - 1) * BILLBOARD_HEIGHT / 2))
				enterNameEditBox:setOpacity(32)
				_frmNode.childUI["BillboardNode" .. i].handle._n:addChild(enterNameEditBox)
				]]
				
				--我的叹号
				local th_dx = -80
				_frmNode.childUI["BillboardNode" .. i].childUI["TanHao"] = hUI.image:new({
					parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
					x = OFFSET_DX + th_dx,
					y = 35 - (p - 1) * BILLBOARD_HEIGHT / 2,
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
			
			--绘制玩家英雄
			for h = 1, #hero, 1 do
				--绘制英雄头像
				local heroT = hero[h]
				local typeId = heroT.id
				local lv = heroT.lv
				local star = heroT.star
				local equip = heroT.equip
				
				--英雄的框
				_frmNode.childUI["BillboardNode" .. i].childUI["Player_" .. p .. "_hero_" .. h .. "_" .. "heroBG"] = hUI.image:new({
					parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
					x = OFFSET_DX + 90 + (h - 1) * (205),
					y = 35 - (p - 1) * 75,
					size = 26,
					model = "UI:NewKuang",
					w = 64,
					h = 64,
				})
				
				--英雄的头像
				_frmNode.childUI["BillboardNode" .. i].childUI["Player_" .. p .. "_hero_" .. h .. "_" .. "heroIcon"] = hUI.image:new({
					parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
					x = OFFSET_DX + 90 + (h - 1) * (205),
					y = 35 - (p - 1) * 75,
					size = 26,
					model = hVar.tab_unit[typeId] and hVar.tab_unit[typeId].icon,
					w = 64 - 8,
					h = 64 - 8,
				})
				
				--英雄的等级背景图
				_frmNode.childUI["BillboardNode" .. i].childUI["Player_" .. p .. "_hero_" .. h .. "_" .. "lvBG"] = hUI.image:new({
					parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
					x = OFFSET_DX + 90 + (h - 1) * (205) + 28,
					y = 35 - (p - 1) * 75 + 20,
					size = 26,
					model = "ui/pvp/pvpselect.png",
					w = 34,
					h = 34,
				})
				
				--英雄等级
				local fontSize = 24
				if lv and (lv >= 10) then
					fontSize = 16
				end
				_frmNode.childUI["BillboardNode" .. i].childUI["Player_" .. p .. "_hero_" .. h .. "_" .. "lv"] = hUI.label:new({
					parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
					x = OFFSET_DX + 90 + (h - 1) * (205) + 28,
					y = 35 - (p - 1) * 75 + 20 - 1,
					size = fontSize,
					align = "MC",
					width = 300,
					font = "numWhite",
					text = lv,
				})
				
				--英雄的装备
				--重新组织装备（有可能有部位没穿装备）
				local tWeapon = 0 --武器
				local tBody = 0 --防具
				local tOrnamnts = 0 --宝物
				local tMount = 0 --马
				for e = 1, #equip, 1 do
					local te =  equip[e]
					local itemId = te.id
					local tabI = hVar.tab_item[itemId]
					if tabI then
						local typeI = tabI.type
						if (typeI == hVar.ITEM_TYPE.WEAPON) then
							tWeapon = te --武器
						elseif (typeI == hVar.ITEM_TYPE.BODY) then
							tBody = te --防具
						elseif (typeI == hVar.ITEM_TYPE.ORNAMENTS) then
							tOrnamnts = te --宝物
						elseif (typeI == hVar.ITEM_TYPE.MOUNT) then
							tMount = te --马
						end
					end
				end
				local tEquip = {tWeapon, tBody, tOrnamnts, tMount,}
				for e = 1, #tEquip, 1 do
					local tEq = tEquip[e]
					local itemId = 0 --装备id
					if tEq and (tEq ~= 0) then
						itemId = tEq.id --装备id
					end
					
					--local exn = (e + 1) % 2 + 1
					--local eyn = math.floor((e + 1) / 2)
					--local ewh = 36
					local exn = e
					local eyn = 0
					local ewh = 34
					
					--存在道具
					if hVar.tab_item[itemId] then
						local itemLv = hVar.tab_item[itemId].itemLv or 1
						local itemModel = hVar.ITEMLEVEL[itemLv].BORDERMODEL --模型
						
						--if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
						--	itemModel = "ICON:Back_red2"
						--end
						--道具品质颜色
						_frmNode.childUI["BillboardNode" .. i].childUI["Player_" .. p .. "_hero_" .. h .. "_item_" .. e .. "_itemBorder"] = hUI.image:new({
							parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
							x = OFFSET_DX + 90 + 49 + (h - 1) * (205) + (exn - 1) * (ewh + 1),
							y = 35 - 49 - (p - 1) * 75 - (eyn - 1) * (ewh + 1),
							model = itemModel,
							w = ewh,
							h = ewh,
						})
						--存储数据
						_frmNode.childUI["BillboardNode" .. i].childUI["Player_" .. p .. "_hero_" .. h .. "_item_" .. e .. "_itemBorder"].data.tEq = tEq
						
						--道具图标
						_frmNode.childUI["BillboardNode" .. i].childUI["Player_" .. p .. "_hero_" .. h .. "_item_" .. e .. "_itemIcon"] = hUI.image:new({
							parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
							x = OFFSET_DX + 90 + 49 + (h - 1) * (205) + (exn - 1) * (ewh + 1),
							y = 35 - 49 - (p - 1) * 75 - (eyn - 1) * (ewh + 1),
							model = hVar.tab_item[itemId].icon,
							w = ewh - 2,
							h = ewh - 2,
						})
					else
						--道具品质颜色
						_frmNode.childUI["BillboardNode" .. i].childUI["Player_" .. p .. "_hero_" .. h .. "_item_" .. e .. "_itemBorder"] = hUI.image:new({
							parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
							x = OFFSET_DX + 90 + 49 + (h - 1) * (205) + (exn - 1) * (ewh + 1),
							y = 35 - 49 - (p - 1) * 75 - (eyn - 1) * (ewh + 1),
							model = "misc/photo_frame.png",
							w = ewh,
							h = ewh,
						})
						--存储数据
						_frmNode.childUI["BillboardNode" .. i].childUI["Player_" .. p .. "_hero_" .. h .. "_item_" .. e .. "_itemBorder"].data.tEq = tEq
					end
				end
			end
			
			--绘制玩家塔
			for t = 1, #tower, 1 do
				--绘制塔图标
				local towerT = tower[t]
				local towerId = towerT.id
				local lv = towerT.lv
				
				--塔的图标
				_frmNode.childUI["BillboardNode" .. i].childUI["Player_" .. p .. "_tower_" .. t .. "_" .. "towerIcon"] = hUI.image:new({
					parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
					x = OFFSET_DX + 90 + (#hero) * (205) + (t - 1) * (58 + 10),
					y = 35 - 3 - (p - 1) * 75,
					size = 26,
					model = hVar.tab_tactics[towerId] and hVar.tab_tactics[towerId].icon,
					w = 58,
					h = 58,
				})
				
				--塔的等级背景图
				_frmNode.childUI["BillboardNode" .. i].childUI["Player_" .. p .. "_tower_" .. t .. "_" .. "lvBG"] = hUI.image:new({
					parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
					x = OFFSET_DX + 90 + (#hero) * (205) + (t - 1) * (58 + 10) + 20,
					y = 35 - 3 - (p - 1) * 75 + 23,
					size = 26,
					model = "ui/pvp/pvpselect.png",
					w = 34,
					h = 34,
				})
				
				--塔等级
				local fontSize = 24
				if lv and (lv >= 10) then
					fontSize = 16
				end
				_frmNode.childUI["BillboardNode" .. i].childUI["Player_" .. p .. "_tower_" .. t .. "_" .. "lv"] = hUI.label:new({
					parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
					x = OFFSET_DX + 90 + (#hero) * (205) + (t - 1) * (58 + 10) + 20,
					y = 35 - 3 - (p - 1) * 75 + 23 - 1,
					size = fontSize,
					align = "MC",
					width = 200,
					font = "numWhite",
					text = lv,
				})
			end
		end
	end
	
	--函数：定时向服务器查询当前铜雀台排行数据(timer)
	on_query_billboard_info_timer_PVP_Endless = function()
		--print("函数：定时向服务器查询当前铜雀台排行数据(timer) on_query_billboard_info_timer_PVP_Endless")
		local _frm = hGlobal.UI.PhoneRankBoardFrm_PVP_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local currenttime = hApi.gametime() --当前时间
		local deltatime = currenttime - last_timer_query_time --时间差
		--print("deltatime=", deltatime)
		if (deltatime >= (QUERY_DELTA_SECOND * 1000 - 100)) then
			--if (current_enter_bg == 0) then --当前程序是否在后台（如果进入后台，就不用定时器刷新排行榜情况）
				if (g_cur_net_state == 1) then --联网状态
					--if (current_STATE == 3) then --当前的状态(0:初始化 / 1:正在连接、登入、查询服务器时间 / 3:查询完毕)
						--print("定时向服务器查询当前的排行数据(timer)")
						--标记timer
						last_timer_query_time = currenttime
						
						--标记最新查询的时间
						--local timestamp = os.time()
						--last_query_multy_pve_board_time = timestamp
						
						--显示正在网络查询的小菊花
						if _frmNode.childUI["waiting"] then
							_frmNode.childUI["waiting"].handle.s:setVisible(true)
						end
						
						--发起登入操作
						--print("发起登入操作")
						--print("发起登入操作", Pvp_Server:GetState())
						if (Pvp_Server:GetState() == 1) then --不重复登入
							--模拟触发连接结果回调
							on_receive_connect_back_event_PVP_Endless(1)
						else
							--连接
							Pvp_Server:Connect()
						end
					--end
				end
			--end
		end
	end
	
	--函数：刷新排行榜界面的滚动
	refresh_rank_board_UI_loop_PVP_Endless = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		--print("current_STATE = " .. current_STATE)
		--如果当前的查询状态是在查询服务器时间，或者查询静态数据，那么不能滚动
		if (current_STATE < 3) then --当前的状态(0:初始化 / 1:正在连接、登入、查询服务器时间 / 3:查询完毕)
			return
		end
		
		local _frm = hGlobal.UI.PhoneRankBoardFrm_PVP_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--注意: 如果刚打开界面的瞬间，子控件都被删掉了，而这时滑动屏幕，并且有上一次排行榜缓存数据，逻辑会走到这，但是此时界面还没，会弹框
		if (_frmNode.childUI["BillboardNode1"] == nil) then
			return
		end
		
		--最后一个不存在，直接退出
		if (_frmNode.childUI["BillboardNode" .. current_pveMultiLog.num] == nil) then
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
			delta1_ly = btn1_ly + 72 --第一个排行榜距离上侧边界的距离
			
			--最后一个排行榜的数据
			local BillboardBtnN = _frmNode.childUI["BillboardNode" .. current_pveMultiLog.num]
			local btnN_cx, btnN_cy = 0, 0 --最后一个排行榜中心点位置
			local btnN_ry = 0 --最后一个排行榜最下侧的x坐标
			local deltNa_ry = 0 --最后一个排行榜距离下侧边界的距离
			btnN_cx, btnN_cy = BillboardBtnN.data.x, BillboardBtnN.data.y --最后一个排行榜中心点位置
			btnN_ry = btnN_cy - BILLBOARD_HEIGHT / 2 --最后一个排行榜最下侧的x坐标
			deltNa_ry = btnN_ry + 530 --最后一个排行榜距离下侧边界的距离
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
				for i = 1, current_pveMultiLog.num, 1 do
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
				for i = 1, current_pveMultiLog.num, 1 do
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
					for i = 1, current_pveMultiLog.num, 1 do
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
					for i = 1, current_pveMultiLog.num, 1 do
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
	OnRefreshRankBoardFrame_PVP_Endless = function(achieve_idx, touchX, touchY)
		local _frm = hGlobal.UI.PhoneRankBoardFrm_PVP_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--标记选中的排行榜索引值
		local last_achieve_idx = current_focus_billboardEx_idx
		current_focus_billboardEx_idx = achieve_idx
		
		--检测点到了哪个英雄、装备、塔上面，显示tip
		local pveMultiLogi = current_pveMultiLog[achieve_idx]
		if pveMultiLogi then
			local playerInfo = pveMultiLogi.playerInfo
			if playerInfo then
				for p = 1, #playerInfo, 1 do
					local tp = playerInfo[p]
					local udbid = tp.udbid --玩家dibid
					local name = tp.name --玩家名
					local hero = tp.hero --玩家使用的英雄数据
					local tower = tp.tower --玩家使用的塔数据
					
					local pnode = _frmNode.childUI["BillboardNode" .. achieve_idx]
					if pnode then
						--检测英雄
						for h = 1, #hero, 1 do
							--英雄子按钮
							local hbtn = _frmNode.childUI["BillboardNode" .. achieve_idx].childUI["Player_" .. p .. "_hero_" .. h .. "_" .. "heroBG"]
							if hbtn then
								local bx, by = hbtn.data.x + pnode.data.x, hbtn.data.y + pnode.data.y
								local ww, hh = hbtn.data.w, hbtn.data.h
								local button_left = bx - ww / 2 --英雄选中区域的最左侧
								local button_right = bx + ww / 2 --英雄选中区域的最右侧
								local button_top = by - hh / 2 --英雄选中区域的最上侧
								local button_bottom = by + hh / 2 --英雄选中区域的最下侧
								
								--检测是否点击到了英雄图片
								if (touchX >= button_left) and (touchX <= button_right) and (touchY >= button_top) and (touchY <= button_bottom) then
									--显示英雄属性tip
									local typeId = hero[h].id
									local lv = hero[h].lv
									local star = hero[h].star
									local equipment = {}
									--检测装备
									for e = 1, 4, 1 do
										--装备子按钮
										local ebtn = pnode.childUI["Player_" .. p .. "_hero_" .. h .. "_item_" .. e .. "_itemBorder"]
										if ebtn then
											local tEq = ebtn.data.tEq
											if tEq and (tEq ~= 0) then
												equipment[#equipment+1] = {tEq.id, 1, tEq.attr}
											else
												equipment[#equipment+1] = {}
											end
										end
									end
									
									--显示英雄属性tip
									hApi.ShowHeroInfoTip_Short(typeId, lv, star, equipment, name)
									
									break
								end
							
								--检测装备
								for e = 1, 4, 1 do
									--装备子按钮
									local ebtn = pnode.childUI["Player_" .. p .. "_hero_" .. h .. "_item_" .. e .. "_itemBorder"]
									if ebtn then
										local bx, by = ebtn.data.x + pnode.data.x, ebtn.data.y + pnode.data.y
										local ww, hh = ebtn.data.w, ebtn.data.h
										local button_left = bx - ww / 2 --英雄选中区域的最左侧
										local button_right = bx + ww / 2 --英雄选中区域的最右侧
										local button_top = by - hh / 2 --英雄选中区域的最上侧
										local button_bottom = by + hh / 2 --英雄选中区域的最下侧
										
										--检测是否点击到了装备图片
										if (touchX >= button_left) and (touchX <= button_right) and (touchY >= button_top) and (touchY <= button_bottom) then
											--显示装备tip
											local tEq = ebtn.data.tEq
											if tEq and (tEq ~= 0) then
												local equipment = {tEq.id, 1, tEq.attr}
												--显示道具tip
												local itemtipX = nil --最右侧
												if (h == 2) then
													itemtipX = 120 + (hVar.SCREEN.w - 1024) / 2 --左侧
												end
												local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
												hGlobal.event:event("LocalEvent_ShowItemTipFram", {equipment}, nil, 1, itemtipX, itemtipY, 0)
											end
											
											break
										end
									end
								end
							end
						end
					
						--检测塔
						for t = 1, #tower, 1 do
							local pnode = _frmNode.childUI["BillboardNode" .. achieve_idx]
							if pnode then
								--塔子按钮
								local tbtn = pnode.childUI["Player_" .. p .. "_tower_" .. t .. "_" .. "towerIcon"]
								if tbtn then
									local bx, by = tbtn.data.x + pnode.data.x, tbtn.data.y + pnode.data.y
									local ww, hh = tbtn.data.w, tbtn.data.h
									local button_left = bx - ww / 2 --英雄选中区域的最左侧
									local button_right = bx + ww / 2 --英雄选中区域的最右侧
									local button_top = by - hh / 2 --英雄选中区域的最上侧
									local button_bottom = by + hh / 2 --英雄选中区域的最下侧
									
									--检测是否点击到了塔图标
									if (touchX >= button_left) and (touchX <= button_right) and (touchY >= button_top) and (touchY <= button_bottom) then
										--显示战术技能卡tip
										local towerId = tower[t].id
										local towerLv = tower[t].lv
										hApi.ShowTacticCardTip(3, towerId, towerLv)
										
										break
									end
								end
							end
						end
					end
				end
			end
		end
		--print(achieve_idx)
	end
	
	--函数：创建铜雀台排行榜规则介绍tip
	OnCreateRankBoardTipFrame_PVP_Endless = function()
		local _frm = hGlobal.UI.PhoneRankBoardFrm_PVP_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--先清除上一次的竞技场排行榜说明面板
		if hGlobal.UI.RankBoardInfoFrame_PVP_Endless then
			hGlobal.UI.RankBoardInfoFrame_PVP_Endless:del()
			hGlobal.UI.RankBoardInfoFrame_PVP_Endless = nil
		end
		
		if (current_STATE < 3) then --当前的状态(0:初始化 / 1:正在连接、登入、查询服务器时间 / 3:查询完毕)
			return
		end
		
		--创建铜雀台排行榜说明面板
		hGlobal.UI.RankBoardInfoFrame_PVP_Endless = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			z = 100001,
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
		hGlobal.UI.RankBoardInfoFrame_PVP_Endless:active()
		
		local _RankTipParent = hGlobal.UI.RankBoardInfoFrame_PVP_Endless.handle._n
		local _RankTipChildUI = hGlobal.UI.RankBoardInfoFrame_PVP_Endless.childUI
		local _offX = BOARD_POS_X + 467
		local _offY = BOARD_POS_Y - 10
		
		--创建每日排行介绍tip-图片背景
		--[[
		_RankTipChildUI["ItemBG_1"] = hUI.image:new({
			parent = _RankTipParent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "UI:TacticBG",
			x = _offX,
			y = _offY - 235,
			w = 680,
			h = 560,
		})
		_RankTipChildUI["ItemBG_1"].handle.s:setOpacity(204)
		]]
		local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", _offX, _offY - 235, 620, 460, hGlobal.UI.RankBoardInfoFrame_PVP_Endless)
		img9:setOpacity(204)
		
		--创建每日排行介绍tip-标题
		--local strTitle = "《魔龙宝库》排行榜" --language
		local strTitle = hVar.tab_string["PVPEndlessWeekRewardI"] --language
		local paintColor = ccc3(255, 224, 0)
		_RankTipChildUI["RankBoardName"] = hUI.label:new({
			parent = _RankTipParent,
			size = 32,
			x = _offX - 10,
			y = _offY - 50,
			width = 500,
			align = "MC",
			font = hVar.FONTC,
			text = strTitle,
			border = 1,
		})
		_RankTipChildUI["RankBoardName"].handle.s:setColor(paintColor)
		
		--创建每日排行介绍tip-标题1
		--local strHint1 = "玩法介绍" --language
		local strTitle1 = hVar.tab_string["__TEXT_PVP_PLAYINTRO"] --language
		_RankTipChildUI["RankBoardTitle1"] = hUI.label:new({
			parent = _RankTipParent,
			size = 28,
			x = _offX - 300 + 10,
			y = _offY - 100,
			width = 590,
			align = "LT",
			font = hVar.FONTC,
			text = strTitle1,
			border = 1,
			RGB = {255, 255, 223},
		})
		
		--创建每日排行介绍tip-内容1
		--local strHint1 = "玩家可以与他人一起挑战，搭配英雄、塔，与队友配合阻挡敌人一波波的进攻。副本每天限时开放，通关后才会扣除领奖次数。" --language
		local strHint1 = hVar.tab_string["PVPEndlessWeekIntroI1"] --language
		_RankTipChildUI["RankBoardContent1"] = hUI.label:new({
			parent = _RankTipParent,
			size = 26,
			x = _offX - 300 + 10,
			y = _offY - 140,
			width = 590,
			align = "LT",
			font = hVar.FONTC,
			text = strHint1,
			border = 1,
			RGB = {236, 236, 236},
		})
		
		--创建每日排行介绍tip-标题2
		--local strHint1 = "排行榜" --language
		local strTitle2 = hVar.tab_string["__TEXT_PVP_LADDER"] --language
		_RankTipChildUI["RankBoardTitle2"] = hUI.label:new({
			parent = _RankTipParent,
			size = 28,
			x = _offX - 300 + 10,
			y = _offY - 270,
			width = 590,
			align = "LT",
			font = hVar.FONTC,
			text = strTitle2,
			border = 1,
			RGB = {255, 255, 223},
		})
		
		--创建每日排行介绍tip-内容2
		--local strHint2 = "排行榜上展示了最快通关的前10组队伍。您可以点击玩家的英雄头像、装备、塔，查看详细属性，便于学习参考。" --language
		local strHint2 = hVar.tab_string["PVPEndlessWeekIntroI2"] --language
		_RankTipChildUI["RankBoardContent2"] = hUI.label:new({
			parent = _RankTipParent,
			size = 26,
			x = _offX - 300 + 10,
			y = _offY - 310,
			width = 590,
			align = "LT",
			font = hVar.FONTC,
			text = strHint2,
			border = 1,
			RGB = {236, 236, 236},
		})
	end
	
	--[[
	--函数：更新提示当前哪个分页可以有领取的了
	RefreshBillboardFinishPage = function()
		local _frm = hGlobal.UI.PhoneRankBoardFrm_PVP_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--...
	end
	]]
	
	--监听打开铜雀台排行榜界面通知事件
	hGlobal.event:listen("LocalEvent_Phone_ShowRankBorad_PVP_Endless", "__ShowRankBoardFrm_PVP", function()
		--触发事件，显示积分、金币界面
		--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
		
		--显示铜雀台排行榜界面
		hGlobal.UI.PhoneRankBoardFrm_PVP_Endless:show(1)
		hGlobal.UI.PhoneRankBoardFrm_PVP_Endless:active()
		
		--打开上一次的分页（默认显示第1个分页:铜雀台排行榜）
		local lastPageIdx = CurrentSelectRecord.pageIdx
		if (lastPageIdx == 0) then
			lastPageIdx = 1
		end
		
		CurrentSelectRecord.pageIdx = 0
		CurrentSelectRecord.contentIdx = 0
		OnClickPageBtn(lastPageIdx)
		
		--存储是哪张地图点进来的
		--current_mapName_entry = mapName
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
if hGlobal.UI.PhoneRankBoardFrm_PVP_Endless then --删除上一次的
	hGlobal.UI.PhoneRankBoardFrm_PVP_Endless:del()
	hGlobal.UI.PhoneRankBoardFrm_PVP_Endless = nil
end
hGlobal.UI.InitRankBoradFrm_PVP_Endless() --测试

--触发事件，显示铜雀台排行榜界面
hGlobal.event:event("LocalEvent_Phone_ShowRankBorad_PVP_Endless")
]]


