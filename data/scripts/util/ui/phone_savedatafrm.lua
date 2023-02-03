


--可变参数
local current_DLCMap_savelist = {}

--添加事件监听：收到游戏币变化历史纪录回调
hGlobal.event:listen("localEvent_SaveDataChangeLog", "__SaveDataChangeLog__", function(tRecord)
	--存储
	current_DLCMap_savelist[#current_DLCMap_savelist+1] = tRecord
end)

--游戏币变化面板
hGlobal.UI.InitSaveDataChangeInfoFrm = function(mode)
	local tInitEventName = {"LocalEvent_Phone_ShowSaveDataChangeInfoFrm", "__ShowGameCoinHistoryFrm",}
	if (mode ~= "include") then
		return tInitEventName
	end
	
	--不重复创建游戏币变化面板
	if hGlobal.UI.PhoneSaveDataChangeInfoFrm then --游戏币变化面板
		return
	end
	
	--iPhoneX黑边宽
	local iPhoneX_WIDTH = 0
	if (g_phone_mode == 4) then --iPhoneX
		iPhoneX_WIDTH = 110
	end
	
	local BOARD_WIDTH = 480 --DLC地图面板面板的宽度
	local BOARD_HEIGHT = 640 --DLC地图面板面板的高度
	local BOARD_OFFSETY = -30 --DLC地图面板面板y偏移中心点的值
	local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 - 390 - iPhoneX_WIDTH --DLC地图面板面板的x位置（最左侧）
	local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --DLC地图面板面板的y位置（最顶侧）
	
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
	
	--分页1：显示游戏币变化界面
	local OnCreateGameCoinChangeInfoFrame = hApi.DoNothing --创建DLC地图界面（第1个分页）
	local refresh_dlcmapinfo_UI_loop = hApi.DoNothing --刷新DLC地图面板界面的滚动
	local on_receive_savedata_Back = hApi.DoNothing --收到游戏币变化历史纪录回调
	local refresh_async_paint_gamecoin_record_loop = hApi.DoNothing --异步绘制游戏币变化记录条目的timer
	local on_create_single_gamecoin_record_UI = hApi.DoNothing --绘制单条游戏币变化记录数据
	local getUpDownOffset = hApi.DoNothing --函数：获得第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离
	local on_create_single_gamecoin_record_UI_async = hApi.DoNothing --异步绘制单条游戏币变化记录数据（异步）
	local onCreateNewMessageHint = hApi.DoNothing --创建新消息提示
	local onRemoveNewMessageHint = hApi.DoNothing --删除新消息提示
	
	--分页1：DLC地图包的参数
	local DLCMAPINFO_WIDTH = 694 --DLC地图包宽度
	local DLCMAPINFO_HEIGHT = 42 --DLC地图包高度
	local DLCMAPINFO_OFFSET_X = -10 --DLC地图包统一偏移x
	local DLCMAPINFO_OFFSET_Y = 28 --DLC地图包统一偏移y
	local DLCMAPINFO_BOARD_HEIGHT = 570 --DLC地图包高度
	local DLCMAPINFO_X_NUM = 1 --DLC地图面板x的数量
	local DLCMAPINFO_Y_NUM = 12 --DLC地图面板y的数量
	local MAX_SPEED = 50 --最大速度
	
	--可变参数
	local current_DLCMap_max_num = 0 --最大的DLC地图包数量
	--local current_DLCMap_savelist = {}
	
	local current_async_paint_list = {} --当前待异步绘制的聊天消息列表
	local ASYNC_PAINTNUM_ONCE = 12 --一次绘制几条
	
	--控制参数
	local click_pos_x_dlcmapinfo = 0 --开始按下的坐标x
	local click_pos_y_dlcmapinfo = 0 --开始按下的坐标y
	local last_click_pos_y_dlcmapinfo = 0 --上一次按下的坐标x
	local last_click_pos_y_dlcmapinfo = 0 --上一次按下的坐标y
	local draggle_speed_y_dlcmapinfo = 0 --当前滑动的速度x
	local selected_dlcmapinfoEx_idx = 0 --选中的DLC地图面板ex索引
	local click_scroll_dlcmapinfo = false --是否在滑动DLC地图面板中
	local b_need_auto_fixing_dlcmapinfo = false --是否需要自动修正
	local friction_dlcmapinfo = 0 --阻力
	
	--当前选中的记录
	local CurrentSelectRecord = {pageIdx = 0, contentIdx = 0, cardId = 0,} --当前选择的分页、数据项的信息记录
	
	--加载资源
	--xlLoadResourceFromPList("data/image/misc/pvp.plist")
	
	hApi.clearTimer("__SAVEDATA_CHANGE_UPDATE__")
	hApi.clearTimer("__SAVEDATA_CHANGE_ASYNC_TIMER__")
	
	--创建游戏币变化面板
	hGlobal.UI.PhoneSaveDataChangeInfoFrm = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 2,
		show = 0, --一开始不显示
		border = 0, --显示frame边框
		background = "misc/skillup/msgbox4.png",
		--background = "UI:tip_item",
		--background = "UI:Tactic_Background",
		--background = "UI:herocardfrm",
		autoactive = 0,
		
		--点击事件
		codeOnTouch = function(self, x, y, sus)
			--在外部点击
			if (sus == 0) then
				--self.childUI["closeBtn"].data.code()
			end
		end,
	})
	
	local _frm = hGlobal.UI.PhoneSaveDataChangeInfoFrm
	local _parent = _frm.handle._n
	
	--左侧裁剪区域
	local _BTC_PageClippingRect = {20, -40, 440, DLCMAPINFO_BOARD_HEIGHT, 0} -- {x, y, w, h, show}
	local _BTC_pClipNode_savedata = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect, 98, _BTC_PageClippingRect[5], "_BTC_pClipNode_savedata")
	
	--关闭按钮
	local closeDx = -30
	local closeDy = -20
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		model = "misc/skillup/btn_close.png",
		x = _frm.data.w + closeDx,
		y = closeDy,
		scaleT = 0.95,
		code = function()
			--不显示游戏币变化面板
			hGlobal.UI.PhoneSaveDataChangeInfoFrm:show(0)
			
			--关闭界面后不需要监听的事件
			--取消监听：
			--...
			
			--清空切换分页之后取消的监听事件
			--移除事件监听：收到游戏币变化历史纪录回调
			hGlobal.event:listen("localEvent_SaveDataChangeLog", "__GameCoinChangeHistory", nil)
			
			--删除DLC界面下拉滚动timer
			hApi.clearTimer("__SAVEDATA_CHANGE_UPDATE__")
			hApi.clearTimer("__SAVEDATA_CHANGE_ASYNC_TIMER__")
			
			--关闭金币、积分界面
			--hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
			
			--触发事件：关闭了主菜单按钮
			--hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
		end,
	})
	
	--每个分页按钮
	--DLC地图面板
	local tPageIcons = {"UI:ach_king",}
	--local tTexts = {"地图包",} --language
	local tTexts = {"",} --language
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
		
		--[[
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
		]]
		
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
		
		--[[
		--分页按钮的提示升级的动态箭头标识
		_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = "UI:TaskTanHao",
			x = -40,
			y = 6,
			w = 36,
			h = 36,
		})
		_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"].handle.s:setVisible(false) --默认一开始不显示提示该分页可以领取的动态箭头
		local act1 = CCMoveBy:create(0.2, ccp(0, 6))
		local act2 = CCMoveBy:create(0.2, ccp(0, -6))
		local act3 = CCMoveBy:create(0.2, ccp(0, 6))
		local act4 = CCMoveBy:create(0.2, ccp(0, -6))
		local act5 = CCDelayTime:create(0.6)
		local act6 = CCRotateBy:create(0.1, 10)
		local act7 = CCRotateBy:create(0.1 * 1, -10 * 2)
		local act8 = CCRotateBy:create(0.1 * 1, 10 * 2)
		local act9 = CCRotateBy:create(0.1, -10)
		local act10 = CCDelayTime:create(0.8)
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		a:addObject(act5)
		a:addObject(act6)
		a:addObject(act7)
		a:addObject(act8)
		a:addObject(act9)
		a:addObject(act10)
		local sequence = CCSequence:create(a)
		_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"].handle.s:runAction(CCRepeatForever:create(sequence))
		]]
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
		local _frm = hGlobal.UI.PhoneSaveDataChangeInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneSaveDataChangeInfoFrm
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
			--_frm.childUI["PageBtn" .. i]:setstate(1) --按钮可用
			--_frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s:setVisible(true) --显示图片
			--_frm.childUI["PageBtn" .. i].childUI["PageIcon"].handle.s:setVisible(true) --显示图标
			_frm.childUI["PageBtn" .. i].childUI["Text"].handle.s:setVisible(true) --显示文字
		end
		
		--当前按钮高亮
		--[[
		hApi.AddShader(_frm.childUI["PageBtn" .. pageIndex].childUI["PageImage"].handle.s, "normal")
		
		--其它按钮灰掉
		for i = 1, #tPageIcons, 1 do
			if (i ~= pageIndex) then
				hApi.AddShader(_frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s, "gray")
			end
		end
		]]
		
		--先清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--清空切换分页之后取消的监听事件
		--移除事件监听：收到游戏币变化历史纪录回调
		hGlobal.event:listen("localEvent_SaveDataChangeLog", "__GameCoinChangeHistory", nil)
		
		--移除timer
		hApi.clearTimer("__SAVEDATA_CHANGE_UPDATE__")
		hApi.clearTimer("__SAVEDATA_CHANGE_ASYNC_TIMER__")
		
		--隐藏所有的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_savedata", 0)
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：游戏币变化
			--创建游戏币变化分页
			OnCreateGameCoinChangeInfoFrame(pageIndex)
		end
		
		--标记当前选择的分页和页内的第几个
		CurrentSelectRecord.pageIdx = pageIndex
		CurrentSelectRecord.contentIdx = 1 --默认选中第一个
	end
	
	--函数：创建游戏币变化界面（第1个分页）
	OnCreateGameCoinChangeInfoFrame = function(pageIdx)
		local _frm = hGlobal.UI.PhoneSaveDataChangeInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--允许本分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_savedata", 1)
		
		--初始化参数
		current_DLCMap_max_num = 0 --最大的DLC地图面板id
		current_async_paint_list = {} --清空异步缓存待绘制内容
		
		--local i = 3
		
		--左侧裁剪区域
		--local _BTC_PageClippingRect = {0, -82, 1000, 408, 0}
		--local _BTC_pClipNode_savedata = hApi.CreateClippingNode(_parentNode, _BTC_PageClippingRect, 99, _BTC_PageClippingRect[5])
		
		--[[
		--右侧DLC地图包列表提示上翻页的图片
		_frmNode.childUI["DLCMapInfoPageUp"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = DLCMAPINFO_OFFSET_X + 560,
			y = DLCMAPINFO_OFFSET_Y - 14,
			scale = 1.0,
			z = 500, --最前端显示
		})
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setRotation(90)
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --默认不显示左上翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["DLCMapInfoPageUp"].handle._n:runAction(forever)
		
		--右侧DLC地图包列表提示下翻页的图片
		_frmNode.childUI["DLCMapInfoPageDown"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = DLCMAPINFO_OFFSET_X + 560, --非对称的翻页图
			y = DLCMAPINFO_OFFSET_Y - 600,
			scale = 1.0,
			z = 500, --最前端显示
		})
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setRotation(270)
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --默认不显示下分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["DLCMapInfoPageDown"].handle._n:runAction(forever)
		
		--右侧向上翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["DLCMapInfoPageUp_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = DLCMAPINFO_OFFSET_X + 560,
			y = DLCMAPINFO_OFFSET_Y - 14 + 2,
			w = 600,
			h = 46,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (current_DLCMap_max_num > (DLCMAPINFO_X_NUM * DLCMAPINFO_Y_NUM)) then
					--print("向下滚屏", screenY)
					--向下滚屏
					b_need_auto_fixing_dlcmapinfo = true
					friction_dlcmapinfo = 0
					draggle_speed_y_dlcmapinfo = -MAX_SPEED / 2.0 --负速度
				end
			end,
		})
		_frmNode.childUI["DLCMapInfoPageUp_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageUp_Btn"
		
		--右侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["DLCMapInfoPageDown_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = DLCMAPINFO_OFFSET_X + 560,
			y = DLCMAPINFO_OFFSET_Y - 600 - 2,
			w = 600,
			h = 46,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (current_DLCMap_max_num > (DLCMAPINFO_X_NUM * DLCMAPINFO_Y_NUM)) then
					--print("向上滚屏", screenY)
					--向上滚屏
					b_need_auto_fixing_dlcmapinfo = true
					friction_dlcmapinfo = 0
					draggle_speed_y_dlcmapinfo = MAX_SPEED / 2.0 --正速度
				end
			end,
		})
		_frmNode.childUI["DLCMapInfoPageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageDown_Btn"
		]]
		
		--右侧用于检测滑动事件的控件
		_frmNode.childUI["DLCMapInfoDragPanel"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask_white.png",
			dragbox = _frm.childUI["dragBox"],
			x = DLCMAPINFO_OFFSET_X + 250,
			y = DLCMAPINFO_OFFSET_Y - 353,
			w = 440,
			h = DLCMAPINFO_BOARD_HEIGHT,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--print("codeOnTouch", touchX, touchY, sus)
				click_pos_x_dlcmapinfo = touchX --开始按下的坐标x
				click_pos_y_dlcmapinfo = touchY --开始按下的坐标y
				last_click_pos_y_dlcmapinfo = touchX --上一次按下的坐标x
				last_click_pos_y_dlcmapinfo = touchY --上一次按下的坐标y
				draggle_speed_y_dlcmapinfo = 0 --当前速度为0
				selected_dlcmapinfoEx_idx = 0 --选中的DLC地图面板ex索引
				click_scroll_dlcmapinfo = true --是否滑动DLC地图面板
				b_need_auto_fixing_dlcmapinfo = false --不需要自动修正位置
				friction_dlcmapinfo = 0 --无阻力
				
				--检测是否滑动到了最顶部或最底部
				local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
				local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
				delta1_ly, deltNa_ry = getUpDownOffset()
				--print(delta1_ly, deltNa_ry)
				--delta1_ly +:在下底线之上 /-:在下底线之下
				--deltNa_ry +:在下底线之上 /-:在下底线之下
				
				--不满一页
				--上面对其上顶线，下面在在下底线之上
				if (delta1_ly == 0) and (deltNa_ry >= 0) then
					click_scroll_dlcmapinfo = false --不需要滑动DLC地图面板
				end
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
				--处理移动速度y
				draggle_speed_y_dlcmapinfo = touchY - last_click_pos_y_dlcmapinfo
				
				if (draggle_speed_y_dlcmapinfo > MAX_SPEED) then
					draggle_speed_y_dlcmapinfo = MAX_SPEED
				end
				if (draggle_speed_y_dlcmapinfo < -MAX_SPEED) then
					draggle_speed_y_dlcmapinfo = -MAX_SPEED
				end
				
				--检测是否滑动到了最顶部或最底部
				local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
				local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
				delta1_ly, deltNa_ry = getUpDownOffset()
				--print(delta1_ly, deltNa_ry)
				--delta1_ly +:在下底线之上 /-:在下底线之下
				--deltNa_ry +:在下底线之上 /-:在下底线之下
				
				--print("click_scroll_dlcmapinfo=", click_scroll_dlcmapinfo)
				--在滑动过程中才会处理滑动
				if click_scroll_dlcmapinfo then
					local deltaY = touchY - last_click_pos_y_dlcmapinfo --与开始按下的位置的偏移值x
					
					--在滚动，标记未下拉到底部
					--current_in_scroll_down = false
					
					--第一个DLC地图面板的坐标不能跑到最上侧的下边去
					if ((delta1_ly + deltaY) <= 0) then --防止走过
						deltaY = -delta1_ly
						delta1_ly = 0
						
						--没有惯性
						draggle_speed_y_dlcmapinfo = 0
						
						--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --上分翻页提示
					else
						--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(true) --上分翻页提示
					end
					
					--最后一个DLC地图面板的坐标不能跑到最下侧的上边去
					if ((deltNa_ry + deltaY) >= 0) then --防止走过
						deltaY = -deltNa_ry
						deltNa_ry = 0
						
						--没有惯性
						draggle_speed_y_dlcmapinfo = 0
						
						--已到底部，标记下拉到底部（为true时有新消息自动滚到最下端）
						--current_in_scroll_down = true
						--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --下分翻页提示
						
						--已拉到底，删除新消息提示
						onRemoveNewMessageHint()
					else
						--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下分翻页提示
					end
					
					for i = 1, current_DLCMap_max_num, 1 do
						local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
						if ctrli then
							ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
							ctrli.data.x = ctrli.data.x
							ctrli.data.y = ctrli.data.y + deltaY
						end
					end
				end
				
				--存储本次的位置
				last_click_pos_y_dlcmapinfo = touchX
				last_click_pos_y_dlcmapinfo = touchY
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_dlcmapinfo then
					--if (touchX ~= click_pos_x_dlcmapinfo) or (touchY ~= click_pos_y_dlcmapinfo) then --不是点击事件
						b_need_auto_fixing_dlcmapinfo = true
						friction_dlcmapinfo = 0
					--end
				end
				
				--是否选中了新消息快捷方式区域，直接跳到末尾
				local ctrlNewMsgHint = _frmNode.childUI["btnNewMessageHint"]
				if ctrlNewMsgHint then
					local cx = ctrlNewMsgHint.data.x --中心点x坐标
					local cy = ctrlNewMsgHint.data.y --中心点y坐标
					local cw, ch = ctrlNewMsgHint.data.w, ctrlNewMsgHint.data.h
					local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
					local rx, ry = lx + cw, ly + ch --最右下角坐标
					--print(i, cx, cy)
					
					if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
						--按下时也在选中了新消息快捷方式区域，才算点击此区域
						if (click_pos_x_dlcmapinfo >= lx) and (click_pos_x_dlcmapinfo <= rx) and (click_pos_y_dlcmapinfo >= ly) and (click_pos_y_dlcmapinfo <= ry) then
							--向上滚屏
							b_need_auto_fixing_dlcmapinfo = true
							friction_dlcmapinfo = 0
							draggle_speed_y_dlcmapinfo = MAX_SPEED / 1.0 --正速度 --速度一般大
							
							return
						end
					end
				end
				
				--是否选中某个DLC地图面板查看区域内查看tip
				local selectTipIdx = 0
				for i = 1, current_DLCMap_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					local cx = ctrli.data.x --中心点x坐标
					local cy = ctrli.data.y --中心点y坐标
					local cw, ch = ctrli.data.w, ctrli.data.h
					local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
					local rx, ry = lx + cw, ly + ch --最右下角坐标
					--print(i, lx, rx, ly, ry, touchX, touchY)
					if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
						selectTipIdx = i
						
						break
						--print("点击到了哪个DLC地图面板tip的框内" .. i)
					end
				end
				
				if (click_scroll_dlcmapinfo) and (math.abs(touchY - click_pos_y_dlcmapinfo) > 48) then
					selectTipIdx = 0
				end
				
				if (selectTipIdx > 0) then
					--显示tip
					--print(selectTipIdx)
					--OnCreateGameCoinChangeInfoFrame_RightPart(selectTipIdx)
				end
				
				--标记不用滑动
				click_scroll_dlcmapinfo = false
			end,
		})
		_frmNode.childUI["DLCMapInfoDragPanel"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoDragPanel"
		
		--添加事件监听：收到游戏币变化历史纪录回调
		hGlobal.event:listen("localEvent_SaveDataChangeLog", "__GameCoinChangeHistory", on_receive_savedata_Back)
		
		--创建timer，刷新DLC地图面板滚动
		hApi.addTimerForever("__SAVEDATA_CHANGE_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_dlcmapinfo_UI_loop)
		--异步绘制游戏币变化记录条目的timer
		hApi.addTimerForever("__SAVEDATA_CHANGE_ASYNC_TIMER__", hVar.TIMER_MODE.GAMETIME, 1, refresh_async_paint_gamecoin_record_loop)
		
		--挡操作
		--hUI.NetDisable(30000)
		
		--在绘制前就检测是否需要自动滚动
		--检测是否滑动到了最顶部或最底部
		local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
		local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
		delta1_ly, deltNa_ry = getUpDownOffset()
		--print(delta1_ly, deltNa_ry)
		--delta1_ly +:在下底线之上 /-:在下底线之下
		--deltNa_ry +:在下底线之上 /-:在下底线之下
		
		--if current_in_scroll_down then
		--上面对其上顶线，下面不到底，不足一页
		--或下面对其下底线
		--需要滚动
		local in_scroll_down = false
		if (delta1_ly == 0) and (deltNa_ry >= 0) then
			in_scroll_down = true
		end
		if (deltNa_ry == 0) then
			in_scroll_down = true
		end
		
		--发起查询游戏币变化纪录
		--print("发起查询游戏币变化纪录")
		--SendCmdFunc["get_gamecoin_change_history"]()
		--将本地缓存的数据绘制
		for i = 1, #current_DLCMap_savelist, 1 do
			local tRecord = current_DLCMap_savelist[i]
			
			current_DLCMap_max_num = current_DLCMap_max_num + 1
			
			tRecord.index = current_DLCMap_max_num
			
			--绘制记录
			--异步绘制
			on_create_single_gamecoin_record_UI_async(tRecord.index, tRecord)
		end
		
		--在绘制后检测是否需要自动滚动
		--只检测是否滑动到了最顶部
		local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
		local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
		delta1_ly, deltNa_ry = getUpDownOffset()
		--print(delta1_ly, deltNa_ry)
		--delta1_ly +:在下底线之上 /-:在下底线之下
		--deltNa_ry +:在下底线之上 /-:在下底线之下
		--if current_in_scroll_down then
		--上面对其上顶线，下面不到底，不足一页
		--不需要滑动
		if (delta1_ly == 0) and (deltNa_ry >= 0) then
			in_scroll_down = false
		end
		
		--获得一个加速度，使右边自动往上滚动
		--超过一页的数量才滑屏
		--if (current_DLCMap_max_num > (WEAPON_X_NUM * WEAPON_Y_NUM)) then
		if in_scroll_down then
			--onCreateNewMessageHint()
			--向上滚屏
			b_need_auto_fixing_dlcmapinfo = true
			friction_dlcmapinfo = 0
			draggle_speed_y_dlcmapinfo = MAX_SPEED / 0.0001 --正速度 --速度极大
			--立即刷新位置
			refresh_async_paint_gamecoin_record_loop()
		end
	end
	
	--函数：绘制单条游戏币变化记录数据
	on_create_single_gamecoin_record_UI = function(index, tRecordI)
		local _frm = hGlobal.UI.PhoneSaveDataChangeInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local time = tRecordI.time
		local content = tRecordI.content
		local color = tRecordI.color
		--print(time, content)
		
		--父控件
		_frmNode.childUI["DLCMapInfoNode" .. index] = hUI.button:new({
			parent = _BTC_pClipNode_savedata,
			--model = "misc/mask.png",
			model = -1,
			x = 22,
			y = -42 - (index - 1) * (DLCMAPINFO_HEIGHT + 1),
			--z = 1,
			w = DLCMAPINFO_WIDTH,
			h = DLCMAPINFO_HEIGHT,
		})
		--_frmNode.childUI["DLCMapInfoNode" .. index].handle.s:setOpacity(111) --默认不显示（只用于响应事件，不显示）
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoNode" .. index
		
		--操作日期
		local strTime = "[ " .. time .. " ]"
		_frmNode.childUI["DLCMapInfoNode" .. index].childUI["time"] = hUI.label:new({
			parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			x = 0,
			y = 0,
			--font = hVar.FONTC,
			size = 18,
			align = "LT",
			width = 423,
			text = strTime,
			border = 1,
		})
		
		--操作原因
		local length = hApi.GetStringEmojiCNLength(strTime) --处理表情，中文长度
		local strContent = string.rep(" ", 37) .. content
		_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
			parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			x = 9,
			y = -2,
			--font = hVar.FONTC,
			size = 18,
			align = "LT",
			width = 423,
			text = strContent,
			border = 1,
		})
		if color then
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:setColor(ccc3(color[1], color[2], color[3]))
		end
		
		--实际高度
		local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
		_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = wh.height + 8
		
		---------------------------------------------------------------------
		--可能存在滑动，校对前一个控件的相对位置
		if _frmNode.childUI["DLCMapInfoNode" .. (index - 1)] then --前一个
			--实际相对距离
			local lastX = _frmNode.childUI["DLCMapInfoNode" .. (index - 1)].data.x
			local lastY = _frmNode.childUI["DLCMapInfoNode" .. (index - 1)].data.y
			local lastChatHeight = _frmNode.childUI["DLCMapInfoNode" .. (index - 1)].data.chatHeight
			
			--理论相对距离
			local thisX = lastX
			local thisY = lastY - lastChatHeight
			local ctrli = _frmNode.childUI["DLCMapInfoNode" .. index]
			ctrli.handle._n:setPosition(thisX, thisY)
			ctrli.data.x = thisX
			ctrli.data.y = thisY
		end
	end
	
	--函数：异步绘制单条游戏币变化记录数据（异步）
	on_create_single_gamecoin_record_UI_async = function(index, tRecordI)
		local _frm = hGlobal.UI.PhoneSaveDataChangeInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local time = tRecordI.time
		local content = tRecordI.content
		--print(time, content)
		
		--print("异步绘制单条游戏币变化记录数据（异步）", index,time, content)
		
		--父控件
		_frmNode.childUI["DLCMapInfoNode" .. index] = hUI.button:new({
			parent = _BTC_pClipNode_savedata,
			--model = "misc/mask.png",
			model = -1,
			x = 20,
			y = -42 - (index - 1) * (DLCMAPINFO_HEIGHT + 1),
			--z = 1,
			w = DLCMAPINFO_WIDTH,
			h = DLCMAPINFO_HEIGHT,
		})
		--_frmNode.childUI["DLCMapInfoNode" .. index].handle.s:setOpacity(111) --默认不显示（只用于响应事件，不显示）
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoNode" .. index
		
		--默认高度95
		_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = 95
		
		--存储异步待绘制消息列表
		current_async_paint_list[#current_async_paint_list+1] = tRecordI
	end
	
	--函数：获得第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离
	getUpDownOffset = function()
		local _frm = hGlobal.UI.PhoneSaveDataChangeInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--第一个DLC地图面板的数据
		local DLCMapInfoBtn1 = _frmNode.childUI["DLCMapInfoNode1"]
		local btn1_cx, btn1_cy = 0, 0 --第一个DLC地图面板中心点位置
		local btn1_ly = 0 --第一个DLC地图面板最上侧的x坐标
		local delta1_ly = 0 --第一个DLC地图面板距离上侧边界的距离
		if DLCMapInfoBtn1 then
			btn1_cx, btn1_cy = DLCMapInfoBtn1.data.x, DLCMapInfoBtn1.data.y --第一个DLC地图面板中心点位置
			btn1_ly = btn1_cy + DLCMAPINFO_HEIGHT / 2 --第一个DLC地图面板最上侧的x坐标
			delta1_ly = btn1_ly + 21 --第一个DLC地图面板距离上侧边界的距离
		end
		
		--最后一个DLC地图面板的数据
		local DLCMapInfoBtnN = _frmNode.childUI["DLCMapInfoNode" .. current_DLCMap_max_num]
		local btnN_cx, btnN_cy = 0, 0 --最后一个DLC地图面板中心点位置
		local btnN_ry = 0 --最后一个DLC地图面板最下侧的x坐标
		local deltNa_ry = 0 --最后一个DLC地图面板距离下侧边界的距离
		if DLCMapInfoBtnN then
			btnN_cx, btnN_cy = DLCMapInfoBtnN.data.x, DLCMapInfoBtnN.data.y --最后一个DLC地图面板中心点位置
			btnN_ry = btnN_cy - DLCMapInfoBtnN.data.chatHeight - DLCMAPINFO_HEIGHT / 2 --最后一个DLC地图面板最下侧的x坐标
			deltNa_ry = btnN_ry + 630 --最后一个DLC地图面板距离下侧边界的距离
			--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
		end
		
		return delta1_ly, deltNa_ry
	end
	
	--函数：创建新消息提示
	onCreateNewMessageHint = function()
		local _frm = hGlobal.UI.PhoneSaveDataChangeInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--不重复创建
		if _frmNode.childUI["btnNewMessageHint"] then
			return
		end
		
		--提示父控件
		local pClipNode = _BTC_pClipNode_savedata
		_frmNode.childUI["btnNewMessageHint"] = hUI.button:new({ --作为按钮只是为了挂载子控件
			--parent = _BTC_pClipNodeWorld,
			parent = pClipNode,
			x = _BTC_PageClippingRect[1] + _BTC_PageClippingRect[3]/2,
			y = _BTC_PageClippingRect[2] - _BTC_PageClippingRect[4] + 32/2,
			z = 1,
			model = "misc/mask_white.png",
			w = _BTC_PageClippingRect[3] - 6,
			h = 32,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnNewMessageHint"
		_frmNode.childUI["btnNewMessageHint"].handle.s:setColor(ccc3(255, 255, 0))
		_frmNode.childUI["btnNewMessageHint"].handle.s:setOpacity(64)
		
		--文字
		_frmNode.childUI["btnNewMessageHint"].childUI["label"] = hUI.label:new({
			parent = _frmNode.childUI["btnNewMessageHint"].handle._n,
			x = 0,
			y = 0,
			size = 18,
			font = hVar.FONTC,
			align = "MC",
			width = 500,
			text = "收到新消息",
			border = 1,
			RGB = {255, 255, 0,},
		})
		
		--箭头图片
		_frmNode.childUI["btnNewMessageHint"].childUI["point"] = hUI.image:new({
			parent = _frmNode.childUI["btnNewMessageHint"].handle._n,
			x = 60,
			y = 2,
			model = "misc/skillup/arrow_down.png", --"UI:PageBtn",
			scale = 0.56,
		})
		_frmNode.childUI["btnNewMessageHint"].childUI["point"].handle.s:setRotation(0)
		_frmNode.childUI["btnNewMessageHint"].childUI["point"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["btnNewMessageHint"].childUI["point"].handle._n:runAction(forever)
	end
	
	--函数：删除新消息提示
	onRemoveNewMessageHint = function()
		local _frm = hGlobal.UI.PhoneSaveDataChangeInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("删除新消息提示")
		
		--[[
		--设置军团聊天的已阅读的消息id
		if (#current_msg_id_list_group > 0) then
			LuaSetChatGroupReadMsgId(g_curPlayerName, current_msg_id_list_group[#current_msg_id_list_group])
		end
		]]
		
		--删除提示控件
		if _frmNode.childUI["btnNewMessageHint"] then
			hApi.safeRemoveT(_frmNode.childUI, "btnNewMessageHint")
			
			--删除 leftRemoveFrmList 存储标记
			for j = 1, #rightRemoveFrmList, 1 do
				if (leftRemoveFrmList[j] == "btnNewMessageHint") then
					--print("删除 leftRemoveFrmList 存储标记", j)
					table.remove(leftRemoveFrmList, j)
					break
				end
			end
		end
		
		--更新叹号提示
		--on_update_notice_tanhao()
	end
	
	--函数：收到游戏币变化历史纪录回调
	on_receive_savedata_Back = function(tRecord)
		local _frm = hGlobal.UI.PhoneSaveDataChangeInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("收到游戏币变化历史纪录回调")
		
		--取消挡操作
		--hUI.NetDisable(0)
		
		--在绘制前就检测是否需要自动滚动
		--检测是否滑动到了最顶部或最底部
		local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
		local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
		delta1_ly, deltNa_ry = getUpDownOffset()
		--print(delta1_ly, deltNa_ry)
		--delta1_ly +:在下底线之上 /-:在下底线之下
		--deltNa_ry +:在下底线之上 /-:在下底线之下
		
		--上面对其上顶线，下面不到底，不足一页
		--或下面对其下底线
		--需要滚动
		local in_scroll_down = false
		if (delta1_ly == 0) and (deltNa_ry >= 0) then
			in_scroll_down = true
		end
		if (deltNa_ry == 0) then
			in_scroll_down = true
		end
		--清除右侧界面
		--_removeRightFrmFunc()
		
		--隐藏上下分页按钮
		--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false)
		--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false)
		
		--标记总数量
		current_DLCMap_max_num = current_DLCMap_max_num + 1
		
		--绘制记录
		--异步绘制
		tRecord.index = current_DLCMap_max_num
		on_create_single_gamecoin_record_UI_async(tRecord.index, tRecord)
		
		--超过一页，显示向下分页按钮
		--if (current_DLCMap_max_num > (DLCMAPINFO_X_NUM * DLCMAPINFO_Y_NUM)) then
		--	_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true)
		--end
		
		--在绘制后检测是否需要自动滚动
		--只检测是否滑动到了最顶部
		local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
		local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
		delta1_ly, deltNa_ry = getUpDownOffset()
		--print(delta1_ly, deltNa_ry)
		--delta1_ly +:在下底线之上 /-:在下底线之下
		--deltNa_ry +:在下底线之上 /-:在下底线之下
		--if current_in_scroll_down then
		--上面对其上顶线，下面不到底，不足一页
		--不需要滑动
		if (delta1_ly == 0) and (deltNa_ry >= 0) then
			in_scroll_down = false
		end
		
		--获得一个加速度，使右边自动往上滚动
		--超过一页的数量才滑屏
		--if (current_DLCMap_max_num > (WEAPON_X_NUM * WEAPON_Y_NUM)) then
		if in_scroll_down then
			--向上滚屏
			b_need_auto_fixing_dlcmapinfo = true
			friction_dlcmapinfo = 0
			draggle_speed_y_dlcmapinfo = MAX_SPEED / 0.0001 --正速度 --速度极大
			--立即刷新位置
			refresh_async_paint_gamecoin_record_loop()
		else
			--没触发自动滑动，需要提示新消息
			if (delta1_ly == 0) and (deltNa_ry >= 0) then
				--因为不足一页的不滑动，不需要提示
				onRemoveNewMessageHint()
			else
				onCreateNewMessageHint()
			end
		end
	end
	
	--异步绘制游戏币变化记录条目的timer
	refresh_async_paint_gamecoin_record_loop = function()
		local _frm = hGlobal.UI.PhoneSaveDataChangeInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--如果待异步绘制表里有内容，逐一绘制
		if (#current_async_paint_list > 0) then
			local loopCount = ASYNC_PAINTNUM_ONCE
			if (loopCount > #current_async_paint_list) then
				loopCount = #current_async_paint_list
			end
			
			--一次绘制多条
			for loop = 1, loopCount, 1 do
				--取第一项
				local pivot = 1
				local tRecordI = current_async_paint_list[pivot]
				local index = tRecordI.index
				
				--先删除虚控件
				hApi.safeRemoveT(_frmNode.childUI, "DLCMapInfoNode" .. index)
				
				--再创建实体控件
				on_create_single_gamecoin_record_UI(index, tRecordI)
				
				table.remove(current_async_paint_list, pivot)
			end
		end
	end
	
	--函数：刷新DLC地图面板界面的滚动
	refresh_dlcmapinfo_UI_loop = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		local _frm = hGlobal.UI.PhoneSaveDataChangeInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local SPEED = 50 --速度
		--print(b_need_auto_fixing_dlcmapinfo)
		
		if b_need_auto_fixing_dlcmapinfo then
			---第一个DLC地图面板的数据
			local DLCMapInfoBtn1 = _frmNode.childUI["DLCMapInfoNode1"]
			if DLCMapInfoBtn1 then
				--[[
				local btn1_cx, btn1_cy = 0, 0 --第一个DLC地图面板中心点位置
				local btn1_ly = 0 --第一个DLC地图面板最上侧的x坐标
				local delta1_ly = 0 --第一个DLC地图面板距离上侧边界的距离
				btn1_cx, btn1_cy = DLCMapInfoBtn1.data.x, DLCMapInfoBtn1.data.y --第一个DLC地图面板中心点位置
				btn1_ly = btn1_cy + DLCMAPINFO_HEIGHT / 2 --第一个DLC地图面板最上侧的x坐标
				delta1_ly = btn1_ly + 41 --第一个DLC地图面板距离上侧边界的距离
				]]
				
				--[[
				--最后一个DLC地图面板的数据
				local DLCMapInfoBtnN = _frmNode.childUI["DLCMapInfoNode" .. current_DLCMap_max_num]
				local btnN_cx, btnN_cy = 0, 0 --最后一个DLC地图面板中心点位置
				local btnN_ry = 0 --最后一个DLC地图面板最下侧的x坐标
				local deltNa_ry = 0 --最后一个DLC地图面板距离下侧边界的距离
				btnN_cx, btnN_cy = DLCMapInfoBtnN.data.x, DLCMapInfoBtnN.data.y --最后一个DLC地图面板中心点位置
				btnN_ry = btnN_cy - DLCMAPINFO_HEIGHT / 2 --最后一个DLC地图面板最下侧的x坐标
				deltNa_ry = btnN_ry + 556 --最后一个DLC地图面板距离下侧边界的距离
				--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
				]]
				
				--检测是否滑动到了最顶部或最底部
				local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
				local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
				delta1_ly, deltNa_ry = getUpDownOffset()
				--print(delta1_ly, deltNa_ry)
				--delta1_ly +:在下底线之上 /-:在下底线之下
				--deltNa_ry +:在下底线之上 /-:在下底线之下
				
				--print("delta1_ly=" .. delta1_ly, ", deltNa_rx=" .. deltNa_rx)
				--如果第一个DLC地图面板的头像跑到下边，那么优先将第一个DLC地图面板头像贴边
				if (delta1_ly < 0) then
					--print("优先将第一个DLC地图面板头像贴边")
					--需要修正
					--不会选中DLC地图面板
					selected_dlcmapinfoEx_idx = 0 --选中的DLC地图面板索引
					
					--没有惯性
					draggle_speed_y_dlcmapinfo = 0
					
					local speed = SPEED
					if ((delta1_ly + speed) > 0) then --防止走过
						speed = -delta1_ly
						delta1_ly = 0
					end
					
					--每个按钮向上侧做运动
					for i = 1, current_DLCMap_max_num, 1 do
						local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					--if (ctrli.data.selected == 0) then --只处理未选中的DLC地图面板卡牌
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y + speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					--end
					end
					
					--上滑动翻页不显示，下滑动翻页显示
					--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --上翻页提示
					--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHUp"].handle.s, "gray") --上横线到顶了，灰掉
					--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下翻页提示
					--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHDown"].handle.s, "normal") --下横线需要翻页，正常
				elseif (delta1_ly ~= 0) and (deltNa_ry > 0) then --第一个头像没有贴上侧，并且最后一个头像没有贴下侧，那么再将最后一个DLC地图面板头像贴边
					--print("将最后一个DLC地图面板头像贴边")
					--需要修正
					--不会选中DLC地图面板
					selected_dlcmapinfoEx_idx = 0 --选中的DLC地图面板索引
					
					--没有惯性
					draggle_speed_y_dlcmapinfo = 0
					
					local speed = SPEED
					if ((deltNa_ry - speed) < 0) then --防止走过
						speed = deltNa_ry
						deltNa_ry = 0
					end
					
					--每个按钮向下侧做运动
					for i = 1, current_DLCMap_max_num, 1 do
						local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					--if (ctrli.data.selected == 0) then --只处理未选中的DLC地图面板卡牌
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
					--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(true) --上分翻页提示
					--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHUp"].handle.s, "normal") --上横线需要翻页，正常
					--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --下分翻页不提示
					--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHDown"].handle.s, "gray") --下横线到顶了，灰掉
					
					--已拉到底，删除新消息提示
					onRemoveNewMessageHint()
				elseif (draggle_speed_y_dlcmapinfo ~= 0) then --沿着当前的速度方向有惯性地运动一会
					--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_y_dlcmapinfo)
					--不会选中DLC地图面板
					selected_dlcmapinfoEx_idx = 0 --选中的DLC地图面板索引
					--print("    ->   draggle_speed_y_dlcmapinfo=", draggle_speed_y_dlcmapinfo)
					
					if (draggle_speed_y_dlcmapinfo > 0) then --朝上运动
						local speed = (draggle_speed_y_dlcmapinfo) * 1.0 --系数
						friction_dlcmapinfo = friction_dlcmapinfo - 0.5
						draggle_speed_y_dlcmapinfo = draggle_speed_y_dlcmapinfo + friction_dlcmapinfo --衰减（正）
						
						if (draggle_speed_y_dlcmapinfo < 0) then
							draggle_speed_y_dlcmapinfo = 0
						end
						
						--最后一个DLC地图面板的坐标不能跑到最下侧的上边去
						if ((deltNa_ry + speed) > 0) then --防止走过
							speed = -deltNa_ry
							deltNa_ry = 0
							
							--没有惯性
							draggle_speed_y_dlcmapinfo = 0
						end
						
						--每个按钮向上侧做运动
						for i = 1, current_DLCMap_max_num, 1 do
							local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
						--if (ctrli.data.selected == 0) then --只处理未选中的DLC地图面板卡牌
							local pos_x, pos_y = ctrli.data.x, ctrli.data.y
							
							--本地运动到达的坐标
							local to_x, to_y = pos_x, pos_y + speed
							
							--设置新坐标
							ctrli.data.x = to_x
							ctrli.data.y = to_y
							ctrli.handle._n:setPosition(to_x, to_y)
						--end
						end
					elseif (draggle_speed_y_dlcmapinfo < 0) then --朝下运动
						local speed = (draggle_speed_y_dlcmapinfo) * 1.0 --系数
						friction_dlcmapinfo = friction_dlcmapinfo + 0.5
						draggle_speed_y_dlcmapinfo = draggle_speed_y_dlcmapinfo + friction_dlcmapinfo --衰减（负）
						
						if (draggle_speed_y_dlcmapinfo > 0) then
							draggle_speed_y_dlcmapinfo = 0
						end
						
						--第一个DLC地图面板的坐标不能跑到最上侧的下边去
						if ((delta1_ly + speed) < 0) then --防止走过
							speed = -delta1_ly
							delta1_ly = 0
							
							--没有惯性
							draggle_speed_y_dlcmapinfo = 0
						end
						
						--每个按钮向下侧做运动
						for i = 1, current_DLCMap_max_num, 1 do
							local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
						--if (ctrli.data.selected == 0) then --只处理未选中的DLC地图面板卡牌
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
						--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --上分翻页提示
						--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHUp"].handle.s, "gray") --上横线到顶了，灰掉
					else
						--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(true) --上分翻页提示
						--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHUp"].handle.s, "normal") --上横线需要翻页，正常
					end
					if (deltNa_ry == 0) then
						--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --下分翻页提示
						--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHDown"].handle.s, "gray") --下横线到顶了，灰掉
						--已拉到底，删除新消息提示
						onRemoveNewMessageHint()
					else
						--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下分翻页提示
						--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHDown"].handle.s, "normal") --下横线需要翻页，正常
					end
				else --停止运动
					b_need_auto_fixing_dlcmapinfo = false
					friction_dlcmapinfo = 0
				end
			end
		end
	end
	
	--监听打开游戏币变化界面通知事件
	hGlobal.event:listen("LocalEvent_Phone_ShowSaveDataChangeInfoFrm", "__ShowGameCoinHistoryFrm", function()
		--[[
		--触发事件，显示积分、金币界面
		--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
		
		--显示游戏币变化界面
		hGlobal.UI.PhoneSaveDataChangeInfoFrm:show(1)
		hGlobal.UI.PhoneSaveDataChangeInfoFrm:active()
		
		--打开上一次的分页（默认显示第1个分页:DLC地图面板）
		local lastPageIdx = CurrentSelectRecord.pageIdx
		if (lastPageIdx == 0) then
			lastPageIdx = 1
		end
		
		CurrentSelectRecord.pageIdx = 0
		CurrentSelectRecord.contentIdx = 0
		OnClickPageBtn(lastPageIdx)
		
		--只有在打开界面时才会监听的事件
		--监听：收到网络宝箱数量的事件
		--hGlobal.event:listen("LocalEvent_getNetChestNum", "__ItemGetChestNum_Frm", function(NumTab)
			--更新网络宝箱的数量和界面
			--
		--end)
		]]
		
		print("测试 test 测试 test 测试 test 测试 test 测试 test 测试 test 测试 test ")
		--测试 --test
		hVar.tab_unit[6000].attr.hp = 1000000
		hVar.tab_unit[6000].attr.hp_restore = 1000
		hVar.tab_unit[6000].attr.move_speed = 800
		
		--大菠萝数据初始化
		hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
		xlScene_LoadMap(g_world, hVar.RandomMap, 0, hVar.MAP_TD_TYPE.NORMAL)
		
		--[[
		--作弊加宝箱碎片
		LuaAddTankWeaponGunChestNum(400)
		LuaAddTankTacticChestNum(400)
		LuaAddTankPetChestNum(400)
		LuaAddTankEquipChestNum(400)
		--上传存档
		local keyList = {"material",}
		LuaSavePlayerData_Android_Upload(keyList, "作弊加宝箱碎片")
		]]
	end)
end

--test
--[[
--测试代码
if hGlobal.UI.PhoneSaveDataChangeInfoFrm then --删除上一次的游戏币变化界面
	hGlobal.UI.PhoneSaveDataChangeInfoFrm:del()
	hGlobal.UI.PhoneSaveDataChangeInfoFrm = nil
end
hGlobal.UI.InitSaveDataChangeInfoFrm("include") --测试创建DLC地图界面

hGlobal.event:event("LocalEvent_Phone_ShowSaveDataChangeInfoFrm")
]]



