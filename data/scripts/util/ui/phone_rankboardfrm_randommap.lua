



local BOARD_WIDTH = 720 --DLC地图面板面板的宽度
local BOARD_HEIGHT = 720 --DLC地图面板面板的高度
local BOARD_OFFSETY = -15 --DLC地图面板面板y偏移中心点的值
local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 --DLC地图面板面板的x位置（最左侧）
local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --DLC地图面板面板的y位置（最顶侧）
--横屏模式
if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
	BOARD_WIDTH = 720 --DLC地图面板面板的宽度
	BOARD_HEIGHT = 720 --DLC地图面板面板的高度
	BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 20
	BOARD_OFFSETY = 15 --DLC地图面板面板y偏移中心点的值
	BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --DLC地图面板面板的x位置（最左侧）
	BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --DLC地图面板面板的y位置（最顶侧）
end

local PAGE_BTN_LEFT_X = 480 --第一个分页按钮的x偏移
local PAGE_BTN_LEFT_Y = -6 --第一个分页按钮的x偏移
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
local on_receive_gamecoin_change_hostory_Back = hApi.DoNothing --收到游戏币变化历史纪录回调
local refresh_async_paint_gamecoin_record_loop = hApi.DoNothing --异步绘制游戏币变化记录条目的timer
local on_create_single_gamecoin_record_UI = hApi.DoNothing --绘制单条游戏币变化记录数据
local on_create_single_gamecoin_record_UI_async = hApi.DoNothing --异步绘制单条游戏币变化记录数据（异步）
local getUpDownOffset = hApi.DoNothing --获得第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离
local on_spine_screen_event = hApi.DoNothing --横竖屏切换
local OnClosePanel = hApi.DoNothing --关闭本界面
local OnRefreshRankBoardFrame_Single = hApi.DoNothing --显示某个指定的排行榜界面tip

--分页1：DLC地图包的参数
local DLCMAPINFO_WIDTH = 694 --DLC地图包宽度
local DLCMAPINFO_HEIGHT = 62 --DLC地图包高度
local DLCMAPINFO_OFFSET_X = -10 --DLC地图包统一偏移x
local DLCMAPINFO_OFFSET_Y = 28 --DLC地图包统一偏移y
local DLCMAPINFO_BOARD_HEIGHT = 650 --DLC地图包高度
local DLCMAPINFO_X_NUM = 1 --DLC地图面板x的数量
local DLCMAPINFO_Y_NUM = 9 --DLC地图面板y的数量
local MAX_SPEED = 50 --最大速度

--可变参数
local current_rankId = 1 --排行榜id
local current_DLCMap_max_num = 0 --最大的DLC地图包数量
local current_rankTemplateInfo = nil --排行榜静态模板信息
local current_rankInfo = nil --排行榜信息

local current_async_paint_list = {} --当前待异步绘制的聊天消息列表
local ASYNC_PAINTNUM_ONCE = 2 --一次绘制几条
local current_funcCallback = nil

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



--随机迷宫排行榜界面
hGlobal.UI.InitRandomMapRankInfoFrm = function(mode)
	local tInitEventName = {"LocalEvent_Phone_ShowRandomMapRankInfoFrm", "__ShowGameCoinHistoryFrm",}
	if (mode ~= "reload") then
		--return tInitEventName
		return
	end
	
	--不重复创建游戏币变化面板
	if hGlobal.UI.PhoneRandomMapRankInfoFrm then --游戏币变化面板
		hGlobal.UI.PhoneRandomMapRankInfoFrm:del()
		hGlobal.UI.PhoneRandomMapRankInfoFrm = nil
	end
	
	--[[
	--取消监听打开随机迷宫地图信息界面通知事件
	hGlobal.event:listen("LocalEvent_Phone_ShowRandomMapRankInfoFrm", "__ShowGameCoinHistoryFrm", nil)
	]]
	
	BOARD_WIDTH = 720 --DLC地图面板面板的宽度
	BOARD_HEIGHT = 720 --DLC地图面板面板的高度
	BOARD_OFFSETY = -15 --DLC地图面板面板y偏移中心点的值
	BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 --DLC地图面板面板的x位置（最左侧）
	BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --DLC地图面板面板的y位置（最顶侧）
	--横屏模式
	if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
		BOARD_WIDTH = 720 --DLC地图面板面板的宽度
		BOARD_HEIGHT = 720 --DLC地图面板面板的高度
		BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 20
		BOARD_OFFSETY = 10 --DLC地图面板面板y偏移中心点的值
		BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --DLC地图面板面板的x位置（最左侧）
		BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --DLC地图面板面板的y位置（最顶侧）
	end
	
	--加载资源
	--xlLoadResourceFromPList("data/image/misc/pvp.plist")
	
	hApi.clearTimer("__GAMECOIN_CHANGE_UPDATE__")
	hApi.clearTimer("__GAMECOIN_CHANGE_ASYNC_TIMER__")
	
	--创建游戏币变化面板
	hGlobal.UI.PhoneRandomMapRankInfoFrm = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		z = hZorder.CommonUIFrame,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 2,
		show = 0, --一开始不显示
		border = 0, --显示frame边框
		background = -1,--"misc/billboard/msgbox5.png", --"UI:Tactic_Background",
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
	
	local _frm = hGlobal.UI.PhoneRandomMapRankInfoFrm
	local _parent = _frm.handle._n

	local img9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/itemtip.png", BOARD_WIDTH/2, -BOARD_HEIGHT/2 - 10, BOARD_WIDTH, BOARD_HEIGHT, _frm)
	
	--左侧裁剪区域
	local _BTC_PageClippingRect = {20, -82, 690, DLCMAPINFO_BOARD_HEIGHT - 90, 0} -- {x, y, w, h, show}
	local _BTC_pClipNode_gamecoin = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect, 98, _BTC_PageClippingRect[5], "_BTC_pClipNode_gamecoin")
	
	--背景底图
	_frm.childUI["BG"] = hUI.image:new({
		parent = _parent,
		model = "misc/mask_white.png",
		x = 0,
		y = 0,
		z = -100,
		w = hVar.SCREEN.w * 2,
		h = hVar.SCREEN.h * 2,
	})
	_frm.childUI["BG"].handle.s:setOpacity(88)
	_frm.childUI["BG"].handle.s:setColor(ccc3(0, 0, 0))
	
	--关闭按钮
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		model = "misc/skillup/btn_close.png",
		x = _frm.data.w - 44,
		y = -8-44,
		scaleT = 0.95,
		code = function()
			--关闭本界面
			OnClosePanel()
			
			--回调事件
			if (type(current_funcCallback) == "function") then
				current_funcCallback()
			end
		end,
	})
	
	--每个分页按钮
	--DLC地图面板
	local tPageIcons = {"UI:ach_king",}
	--local tTexts = {"游戏币记录",} --language
	local tTexts = {"",} --language
	for i = 1, #tPageIcons, 1 do
		--分页按钮
		_frm.childUI["PageBtn" .. i] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			x = PAGE_BTN_LEFT_X + (i - 1) * PAGE_BTN_OFFSET_X,
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
			model = "misc/chest/get_new_hero_bar.png",
			x = 0,
			y = 0,
			w = 395,
			h = 73,
		})
		]]
		
		--[[
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
			x = 0,
			y = 9,
			size = 26,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 300,
			text = tTexts[i],
			RGB = {255, 255, 0,},
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
		local _frm = hGlobal.UI.PhoneRandomMapRankInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneRandomMapRankInfoFrm
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
		--移除事件监听：收到排行榜静态数据模板的回调
		hGlobal.event:listen("localEvent_refresh_billboardT", "__QueryComBatEvaluationBoardT", nil)
		--移除事件监听：收到排行榜信息回调
		hGlobal.event:listen("localEvent_refresh_billboard", "__GameCoinChangeHistory", nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenRandomMapRank_", nil)
		
		--移除timer
		hApi.clearTimer("__GAMECOIN_CHANGE_UPDATE__")
		hApi.clearTimer("__GAMECOIN_CHANGE_ASYNC_TIMER__")
		
		--隐藏所有的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_gamecoin", 0)
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：游戏币变化
			--创建游戏币变化分页
			OnCreateGameCoinChangeInfoFrame(pageIndex)
		end
		
		--标记当前选择的分页和页内的第几个
		CurrentSelectRecord.pageIdx = pageIndex
		CurrentSelectRecord.contentIdx = 1 --默认选中第一个
	end
	
	--函数：关闭本界面
	OnClosePanel = function()
		local _frm = hGlobal.UI.PhoneRandomMapRankInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--不显示游戏币变化面板
		hGlobal.UI.PhoneRandomMapRankInfoFrm:show(0)
		
		--清空分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--关闭界面后不需要监听的事件
		--取消监听：
		--...
		
		--清空切换分页之后取消的监听事件
		--移除事件监听：收到排行榜静态数据模板的回调
		hGlobal.event:listen("localEvent_refresh_billboardT", "__QueryComBatEvaluationBoardT", nil)
		--移除事件监听：收到排行榜信息回调
		hGlobal.event:listen("localEvent_refresh_billboard", "__GameCoinChangeHistory", nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenRandomMapRank_", nil)
		
		--删除DLC界面下拉滚动timer
		hApi.clearTimer("__GAMECOIN_CHANGE_UPDATE__")
		hApi.clearTimer("__GAMECOIN_CHANGE_ASYNC_TIMER__")
		
		--关闭金币、积分界面
		--hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
		
		--触发事件：关闭了主菜单按钮
		--hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
		
	end
	
	--函数：创建游戏币变化界面（第1个分页）
	OnCreateGameCoinChangeInfoFrame = function(pageIdx)
		local _frm = hGlobal.UI.PhoneRandomMapRankInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--允许本分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_gamecoin", 1)
		
		--初始化参数
		current_DLCMap_max_num = 0 --最大的DLC地图面板id
		current_rankTemplateInfo = nil --排行榜静态模板信息
		current_rankInfo = nil --排行榜信息
		current_async_paint_list = {} --清空异步缓存待绘制内容
		
		--local i = 3
		
		--左侧裁剪区域
		--local _BTC_PageClippingRect = {0, -82, 1000, 408, 0}
		--local _BTC_pClipNode_gamecoin = hApi.CreateClippingNode(_parentNode, _BTC_PageClippingRect, 99, _BTC_PageClippingRect[5])
		
		--[[
		--左侧底板
		--背景图
		_frmNode.childUI["DLCMapInfoListBG"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/selectbg.png",
			x = DLCMAPINFO_OFFSET_X + 120,
			y = DLCMAPINFO_OFFSET_Y - 336,
			w = 274,
			h = DLCMAPINFO_BOARD_HEIGHT,
		})
		_frmNode.childUI["DLCMapInfoListBG"].handle.s:setOpacity(128) --底板透明度为128
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoListBG"
		
		--左侧竖线
		_frmNode.childUI["DLCMapInfoListLineV"] = hUI.image:new({
			parent = _parentNode,
			model = "panel/panel_part_09.png",
			x = DLCMAPINFO_OFFSET_X + 230,
			y = DLCMAPINFO_OFFSET_Y - 336,
			w = DLCMAPINFO_BOARD_HEIGHT + 30,
			h = 12,
		})
		_frmNode.childUI["DLCMapInfoListLineV"].handle.s:setRotation(-90)
		_frmNode.childUI["DLCMapInfoListLineV"].handle.s:setOpacity(128) --竖线透明度为128
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoListLineV"
		]]
		
		--[[
		--左侧按钮
		--游戏币纪录
		_frmNode.childUI["DLCMapInfoGameCoinBtn"] = hUI.button:new({
			parent = _parentNode,
			model = "UI:PANEL_MENU_BTN_BIG",
			x = DLCMAPINFO_OFFSET_X + 120,
			y = DLCMAPINFO_OFFSET_Y - 106,
			dragbox = _frm.childUI["dragBox"],
			w = 190,
			h = 56,
			scaleT = 0.98,
			code = function()
				--print("DLCMapInfoGameCoinBtn")
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoGameCoinBtn"
		--文字
		_frmNode.childUI["DLCMapInfoGameCoinBtn"].childUI["label"] = hUI.label:new({
			parent = _frmNode.childUI["DLCMapInfoGameCoinBtn"].handle._n,
			--model = "UI:PANEL_MENU_BTN_NORMAL",
			x = 18,
			y = -2,
			align = "MC",
			size = 24,
			font = hVar.FONTC,
			width = 500,
			text = hVar.tab_string["__TEXT_Page_GameCoinRecord"],  --"游戏币记录"
			border = 1,
		})
		--图标
		_frmNode.childUI["DLCMapInfoGameCoinBtn"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["DLCMapInfoGameCoinBtn"].handle._n,
			model = "UI:PANEL_MENU_BTN_NORMAL",
			x = -64,
			y = 1,
			model = "UI:game_coins",
			--scale = 0.85,
			w = 52,
			h = 52,
		})
		
		--兵符记录
		_frmNode.childUI["DLCMapInfoPvpCoinBtn"] = hUI.button:new({
			parent = _parentNode,
			model = "UI:PANEL_MENU_BTN_NORMAL",
			x = DLCMAPINFO_OFFSET_X + 120,
			y = DLCMAPINFO_OFFSET_Y - 106 - 116*1,
			dragbox = _frm.childUI["dragBox"],
			w = 190,
			h = 56,
			scaleT = 0.98,
			code = function()
				--print("DLCMapInfoPvpCoinBtn")
				--关闭本界面
				_frm.childUI["closeBtn"].data.code()
				
				--打开兵符操作记录界面
				hGlobal.event:event("LocalEvent_Phone_ShowPvpCoinChangeInfoFrm")
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPvpCoinBtn"
		--文字
		_frmNode.childUI["DLCMapInfoPvpCoinBtn"].childUI["label"] = hUI.label:new({
			parent = _frmNode.childUI["DLCMapInfoPvpCoinBtn"].handle._n,
			--model = "UI:PANEL_MENU_BTN_NORMAL",
			x = 18,
			y = -2,
			align = "MC",
			size = 24,
			font = hVar.FONTC,
			width = 500,
			text = hVar.tab_string["__TEXT_Page_PvpCoinRecord"],  --"兵符记录"
			border = 1,
		})
		--图标
		_frmNode.childUI["DLCMapInfoPvpCoinBtn"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["DLCMapInfoPvpCoinBtn"].handle._n,
			model = "UI:PANEL_MENU_BTN_NORMAL",
			x = -64,
			y = 1,
			model = "UI:uitoken_new",
			--scale = 0.85,
			w = 42,
			h = 42,
		})
		]]
		
		--右侧DLC地图包列表提示上翻页的图片
		_frmNode.childUI["DLCMapInfoPageUp"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/skillup/arrow_down.png",
			x = DLCMAPINFO_OFFSET_X + 380,
			y = DLCMAPINFO_OFFSET_Y - 64,
			scale = 1.0,
			z = 500, --最前端显示
		})
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setRotation(180)
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --默认不显示左上翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["DLCMapInfoPageUp"].handle._n:runAction(forever)
		
		--右侧DLC地图包列表提示下翻页的图片
		_frmNode.childUI["DLCMapInfoPageDown"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/skillup/arrow_down.png",
			x = DLCMAPINFO_OFFSET_X + 380, --非对称的翻页图
			y = DLCMAPINFO_OFFSET_Y - 752,
			scale = 1.0,
			z = 500, --最前端显示
		})
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setRotation(0)
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
			x = DLCMAPINFO_OFFSET_X + 380,
			y = DLCMAPINFO_OFFSET_Y - 74,
			w = 400,
			h = 72,
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
			x = DLCMAPINFO_OFFSET_X + 380,
			y = DLCMAPINFO_OFFSET_Y -  760,
			w = 400,
			h = 72,
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
		
		--右侧用于检测滑动事件的控件
		_frmNode.childUI["DLCMapInfoDragPanel"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = DLCMAPINFO_OFFSET_X + 374,
			y = DLCMAPINFO_OFFSET_Y - 416,
			w = 690,
			h = DLCMAPINFO_BOARD_HEIGHT - 40,
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
				
				--print("click_scroll_dlcmapinfo=", click_scroll_dlcmapinfo)
				
				--不满一页
				--上面对其上顶线，下面在在下底线之上
				if (delta1_ly == 0) and (deltNa_ry >= 0) then
					click_scroll_dlcmapinfo = false --不需要滑动DLC地图面板
				end
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
				local deltaY = touchY - last_click_pos_y_dlcmapinfo --与开始按下的位置的偏移值x
				
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
				--第一个DLC地图面板的坐标不能跑到最上侧的下边去
				if ((delta1_ly + deltaY) <= 0) then --防止走过
					deltaY = -delta1_ly
					delta1_ly = 0
					
					--没有惯性
					draggle_speed_y_dlcmapinfo = 0
					
					_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --上分翻页提示
				else
					if click_scroll_dlcmapinfo then
						_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(true) --上分翻页提示
					end
				end
				
				--最后一个DLC地图面板的坐标不能跑到最下侧的上边去
				if ((deltNa_ry + deltaY) >= 0) then --防止走过
					deltaY = -deltNa_ry
					deltNa_ry = 0
					
					--没有惯性
					draggle_speed_y_dlcmapinfo = 0
					
					--已到底部，标记下拉到底部（为true时有新消息自动滚到最下端）
					--current_in_scroll_down = true
					_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --下分翻页提示
				else
					if click_scroll_dlcmapinfo then
						_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下分翻页提
					end
				end
				
				--print("click_scroll_dlcmapinfo=", click_scroll_dlcmapinfo)
				--在滑动过程中才会处理滑动
				if click_scroll_dlcmapinfo then
					--local deltaY = touchY - last_click_pos_y_dlcmapinfo --与开始按下的位置的偏移值x
					for i = 1, current_DLCMap_max_num, 1 do
						local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
						ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
						ctrli.data.x = ctrli.data.x
						ctrli.data.y = ctrli.data.y + deltaY
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
					OnRefreshRankBoardFrame_Single(selectTipIdx, touchX, touchY)
				end
				
				--标记不用滑动
				click_scroll_dlcmapinfo = false
			end,
		})
		_frmNode.childUI["DLCMapInfoDragPanel"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoDragPanel"
		
		--[[
		--标题的底纹
		_frmNode.childUI["DLCMapInfoTitle_BG"] = hUI.button:new({ --作为按钮只是为了挂载子控件
			parent = _parentNode,
			x = DLCMAPINFO_OFFSET_X + 588,
			y = DLCMAPINFO_OFFSET_Y - 90 + 2,
			--model = "misc/mask.png",
			model = -1,
			w = 1,
			h = 1,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTitle_BG"
		--九宫格
		--local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_9s_3.png", 0, 0, 710, 32, _frmNode.childUI["DLCMapInfoTitle_BG"])
		--s9:setOpacity(64)
		--s9:setColor(ccc3(168, 168, 168))
		]]
		
		--标题-排名
		_frmNode.childUI["DLCMapInfoTitle_Rank"] = hUI.label:new({
			parent = _parentNode,
			x = DLCMAPINFO_OFFSET_X + 104,
			y = DLCMAPINFO_OFFSET_Y - 90,
			font = hVar.FONTC,
			size = 26,
			align = "MC",
			text = hVar.tab_string["rank"], --"排名"
			border = 1,
			RGB = {255, 255, 0},
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTitle_Rank"
		
		--标题-玩家名
		_frmNode.childUI["DLCMapInfoTitle_Time"] = hUI.label:new({
			parent = _parentNode,
			x = DLCMAPINFO_OFFSET_X + 260,
			y = DLCMAPINFO_OFFSET_Y - 90,
			font = hVar.FONTC,
			size = 26,
			align = "MC",
			text = hVar.tab_string["__TEXT_PlayerName"], --"玩家名"
			border = 1,
			RGB = {255, 255, 0},
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTitle_Time"
		
		--标题-层数
		local titleStage = ""
		if (current_rankId == 1) then --随机迷宫
			titleStage = hVar.tab_string["__TEXT_BestStage"] --"层数"
		elseif (current_rankId == 2) then --前哨阵低
			titleStage = hVar.tab_string["__ATTR__Wave"] --"波次"
		end
		_frmNode.childUI["DLCMapInfoTitle_Coin"] = hUI.label:new({
			parent = _parentNode,
			x = DLCMAPINFO_OFFSET_X + 420,
			y = DLCMAPINFO_OFFSET_Y - 90,
			font = hVar.FONTC,
			size = 26,
			align = "MC",
			text = titleStage,
			border = 1,
			RGB = {255, 255, 0},
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTitle_Coin"
		
		--标题-奖励
		_frmNode.childUI["DLCMapInfoTitle_Reward"] = hUI.label:new({
			parent = _parentNode,
			x = DLCMAPINFO_OFFSET_X + 590,
			y = DLCMAPINFO_OFFSET_Y - 90,
			font = hVar.FONTC,
			size = 26,
			align = "MC",
			text = hVar.tab_string["__Reward__"],  --"奖励"
			border = 1,
			RGB = {255, 255, 0},
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTitle_Coin"
		
		--我的排名底纹
		_frmNode.childUI["DLCMapInfoTitle_BG"] = hUI.button:new({ --作为按钮只是为了挂载子控件
			parent = _parentNode,
			x = DLCMAPINFO_OFFSET_X + 370,
			y = DLCMAPINFO_OFFSET_Y - 716,
			--model = "misc/mask.png",
			model = -1,
			w = 1,
			h = 1,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTitle_BG"
		--九宫格
		--local s9 = hApi.CCScale9SpriteCreate("data/image/misc/billboard/kuang5.png", 0, 0, 710, 64, _frmNode.childUI["DLCMapInfoTitle_BG"])
		--s9:setRotation(180)
		local s9 = hApi.CCScale9SpriteCreate("data/image/misc/gopherboom/bar.png", -1, 1, 694, 62, _frmNode.childUI["DLCMapInfoTitle_BG"])
		--标题-我的排名
		_frmNode.childUI["DLCMapInfoTitle_RankMe"] = hUI.label:new({
			parent = _parentNode,
			x = DLCMAPINFO_OFFSET_X + 134,
			y = DLCMAPINFO_OFFSET_Y - 714,
			font = hVar.FONTC,
			size = 26,
			align = "MC",
			text = hVar.tab_string["__TEXT_MyRank"], --"我的排名"
			border = 1,
			RGB = {0, 255, 0},
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTitle_Rank"
		
		--标题-我的层数
		local titleMyStage = ""
		if (current_rankId == 1) then --随机迷宫
			titleMyStage = hVar.tab_string["__TEXT_MyBestStage"] --"我的层数"
		elseif (current_rankId == 2) then --前哨阵低
			titleMyStage = hVar.tab_string["__TEXT_MyBestWave"] --"我的波次"
		end
		_frmNode.childUI["DLCMapInfoTitle_StageMe"] = hUI.label:new({
			parent = _parentNode,
			x = DLCMAPINFO_OFFSET_X + 534,
			y = DLCMAPINFO_OFFSET_Y - 714,
			font = hVar.FONTC,
			size = 26,
			align = "MC",
			text = titleMyStage,
			border = 1,
			RGB = {0, 255, 0},
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTitle_Rank"
		
		--添加事件监听：收到排行榜静态数据模板的回调
		hGlobal.event:listen("localEvent_refresh_billboardT", "__QueryComBatEvaluationBoardT", on_receive_billboardT_event)
		--添加事件监听：收到排行榜信息回调
		hGlobal.event:listen("localEvent_refresh_billboard", "__GameCoinChangeHistory", on_receive_gamecoin_change_hostory_Back)
		--添加事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenRandomMapRank_", on_spine_screen_event)
		
		--创建timer，刷新DLC地图面板滚动
		hApi.addTimerForever("__GAMECOIN_CHANGE_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_dlcmapinfo_UI_loop)
		--异步绘制游戏币变化记录条目的timer
		hApi.addTimerForever("__GAMECOIN_CHANGE_ASYNC_TIMER__", hVar.TIMER_MODE.GAMETIME, 1, refresh_async_paint_gamecoin_record_loop)
		
		--挡操作
		hUI.NetDisable(30000)
		
		--发起查询排行榜静态数据
		--print("发起查询排行榜静态数据2",bId)
		local bId = current_rankId
		SendCmdFunc["get_billboardT"](bId)
	end
	
	--异步绘制游戏币变化记录条目的timer
	refresh_async_paint_gamecoin_record_loop = function()
		local _frm = hGlobal.UI.PhoneRandomMapRankInfoFrm
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
		local _frm = hGlobal.UI.PhoneRandomMapRankInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local SPEED = 50 --速度
		--print(b_need_auto_fixing_dlcmapinfo)
		
		if b_need_auto_fixing_dlcmapinfo then
			---第一个DLC地图面板的数据
			local DLCMapInfoBtn1 = _frmNode.childUI["DLCMapInfoNode1"]
			if DLCMapInfoBtn1 then
				--检测是否滑动到了最顶部或最底部
				local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
				local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
				delta1_ly, deltNa_ry = getUpDownOffset()
				--print(delta1_ly, deltNa_ry)
				--delta1_ly +:在下底线之上 /-:在下底线之下
				--deltNa_ry +:在下底线之上 /-:在下底线之下
				
				--print("delta1_ly=" .. delta1_ly, ", deltNa_ry=" .. deltNa_ry)
				
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
					_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --上翻页提示
					--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHUp"].handle.s, "gray") --上横线到顶了，灰掉
					_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下翻页提示
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
					_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(true) --上分翻页提示
					--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHUp"].handle.s, "normal") --上横线需要翻页，正常
					_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --下分翻页不提示
					--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHDown"].handle.s, "gray") --下横线到顶了，灰掉
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
						_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --上分翻页提示
						--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHUp"].handle.s, "gray") --上横线到顶了，灰掉
					else
						_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(true) --上分翻页提示
						--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHUp"].handle.s, "normal") --上横线需要翻页，正常
					end
					if (deltNa_ry == 0) then
						_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --下分翻页提示
						--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHDown"].handle.s, "gray") --下横线到顶了，灰掉
					else
						_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下分翻页提示
						--hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHDown"].handle.s, "normal") --下横线需要翻页，正常
					end
				else --停止运动
					b_need_auto_fixing_dlcmapinfo = false
					friction_dlcmapinfo = 0
				end
			end
		end
	end
	
	--函数：绘制单条游戏币变化记录数据
	on_create_single_gamecoin_record_UI = function(index, tRecordI)
		local _frm = hGlobal.UI.PhoneRandomMapRankInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local name = tRecordI.name
		local rank = tRecordI.rank
		--print(index, name, rank)
		
		--父控件
		_frmNode.childUI["DLCMapInfoNode" .. index] = hUI.button:new({
			parent = _BTC_pClipNode_gamecoin,
			--model = "misc/mask.png",
			model = -1,
			x = 530,
			y = -110 - (index - 1) * (DLCMAPINFO_HEIGHT + 0),
			--z = 1,
			w = DLCMAPINFO_WIDTH,
			h = DLCMAPINFO_HEIGHT,
		})
		--_frmNode.childUI["DLCMapInfoNode" .. index].handle.s:setOpacity(111) --默认不显示（只用于响应事件，不显示）
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoNode" .. index
		
		--排名
		_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rank"] = hUI.label:new({
			parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			x = -440,
			y = -1,
			font = "numWhite", --hVar.FONTC,
			size = 22,
			align = "MC",
			text = tostring(index),
			border = 0,
		})
		--_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rank"].handle.s:setColor(ccc3(255, 255, 0))
		if (current_rankInfo.rankingMe == index) then --此条是我的排名
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rank"].handle.s:setColor(ccc3(0, 255, 0)) --绿色
		end
		
		--玩家名
		_frmNode.childUI["DLCMapInfoNode" .. index].childUI["name"] = hUI.label:new({
			parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			x = -280,
			y = -1,
			font = hVar.FONTC,
			size = 24,
			align = "MC",
			text = name,
			border = 1,
		})
		if (current_rankInfo.rankingMe == index) then --此条是我的排名
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["name"].handle.s:setColor(ccc3(0, 255, 0)) --绿色
		end
		
		--战绩
		local value = ""
		if (current_rankId == 1) then --随机迷宫
			local stage = math.floor(rank / 10)
			local floor = math.floor(rank % 10)
			value = tostring(stage) .. "-" .. tostring(floor)
		elseif (current_rankId == 2) then --前哨阵低
			value = rank
		end
		_frmNode.childUI["DLCMapInfoNode" .. index].childUI["gamecoin"] = hUI.label:new({
			parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			x = -120,
			y = -1,
			font = "numWhite", --hVar.FONTC,
			size = 22,
			align = "MC",
			text = value,
			border = 0,
		})
		_frmNode.childUI["DLCMapInfoNode" .. index].childUI["gamecoin"].handle.s:setColor(ccc3(255, 255, 0))
		if (current_rankInfo.rankingMe == index) then --此条是我的排名
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["gamecoin"].handle.s:setColor(ccc3(0, 255, 0)) --绿色
		end
		
		--奖励
		--current_rankTemplateInfo
		--print(current_rankTemplateInfo[current_rankId])
		--检测本排行应该获得何种奖励
		local giveRewardT = {}
		for r = 1, #current_rankTemplateInfo.info[current_rankId].prize.reward, 1 do
			local rewardT = current_rankTemplateInfo.info[current_rankId].prize.reward[r]
			local from = rewardT.from
			local to = rewardT.to
			if (index >= from) and (index <= to) then
				giveRewardT = rewardT
				--print("giveRewardT", from, to, index)
				break
			end
		end
		local WIDTH = 54
		local scaleModel = 1.12
		for n = 1, #giveRewardT, 1 do
			--获得奖励的UI相关参数
			local rewardT = giveRewardT[n]
			local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
			--print(tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h)
			
			local offsetX = 0
			if (#giveRewardT % 2 == 1) then --奇数
				offsetX = (#giveRewardT - 1) / 2 * (WIDTH) - WIDTH / 2
			else --偶数
				offsetX = (#giveRewardT) / 2 * (WIDTH) / 2 - WIDTH / 2
			end
			
			--print(#giveRewardT)
			--一般奖励的数量为3个，如果为4个，那么往左再偏移一些
			if (#giveRewardT == 4) then
				offsetX = offsetX + 60
				WIDTH = WIDTH + 3
			end
			if (#giveRewardT == 5) then
				offsetX = offsetX + 25
				WIDTH = WIDTH + 1
			end
			
			--绘制奖励控件图标
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["reward" .. n] = hUI.button:new({ --作为button是为了子控件坐标正常
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				model = "misc/mask.pnng",
				x = 26 - offsetX + (n - 1) * (WIDTH),
				y = 0,
				w = WIDTH - 1,
				h = WIDTH - 1,
			})
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["reward" .. n].handle.s:setOpacity(0) --只挂载子控件，不显示
			
			--奖励道具
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["reward" .. n].childUI["icon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["reward" .. n].handle._n,
				model = tmpModel,
				x = 0,
				y = 0,
				w = itemWidth * scaleModel,
				h = itemHeight * scaleModel,
			})
			
			--绘制奖励控件图标的子控件
			if sub_tmpModel then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["reward" .. n].childUI["subIcon"] = hUI.image:new({
					parent = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["reward" .. n].handle._n,
					model = sub_tmpModel,
					x = sub_pos_x * scaleModel,
					y = sub_pos_y * scaleModel,
					w = sub_pos_w * scaleModel,
					h = sub_pos_h * scaleModel,
				})
			end
			
			--绘制奖励的数量
			local posX = 0
			local scaleSize = 18 --1位数
			local fontType = "numWhite"
			local fontBorder = 0
			local fontPosY = -2
			if (itemNum >= 1000) then --4位数
				scaleSize = 14
				fontBorder = 1
				fontPosY = -7
				fontType = hVar.FONTC
			elseif (itemNum >= 100) then --3位数
				scaleSize = 16
				fontBorder = 0
				fontPosY = -4
				fontType = "numWhite"
			elseif (itemNum >= 10) then --2位数
				scaleSize = 16
				fontBorder = 0
				fontPosY = -4
				fontType = "numWhite"
			end
			
			local strNum = ("+" .. itemNum)
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["reward" .. n].childUI["subNum"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["reward" .. n].handle._n,
				x = posX,
				y = fontPosY,
				size = scaleSize,
				font = fontType,
				align = "MT",
				width = 300,
				border = fontBorder,
				text = strNum,
			})
			if paintColor then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["reward" .. n].childUI["subNum"].handle.s:setColor(paintColor)
			end
		end
		
		--分割线
		_frmNode.childUI["DLCMapInfoNode" .. index].childUI["line"] = hUI.image:new({
			parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			x = -170,
			y = -DLCMAPINFO_HEIGHT/2 + 2,
			model = "misc/skillup/line.png", 
			w = DLCMAPINFO_WIDTH - 10,
			h = 2,
		})
		--_frmNode.childUI["DLCMapInfoNode" .. index].childUI["line"].handle.s:setColor(ccc3(0, 0, 0))
		
		---------------------------------------------------------------------
		--可能存在滑动，校对前一个控件的相对位置
		if _frmNode.childUI["DLCMapInfoNode" .. (index - 1)] then --前一个
			--实际相对距离
			local lastX = _frmNode.childUI["DLCMapInfoNode" .. (index - 1)].data.x
			local lastY = _frmNode.childUI["DLCMapInfoNode" .. (index - 1)].data.y
			local lastChatHeight = (DLCMAPINFO_HEIGHT + 0)
			
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
		local _frm = hGlobal.UI.PhoneRandomMapRankInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local name = tRecordI.name
		local rank = tRecordI.rank
		--print(index, name, rank)
		
		--父控件
		_frmNode.childUI["DLCMapInfoNode" .. index] = hUI.button:new({
			parent = _BTC_pClipNode_gamecoin,
			--model = "misc/mask.png",
			model = -1,
			x = 530,
			y = -110 - (index - 1) * (DLCMAPINFO_HEIGHT + 0),
			--z = 1,
			w = DLCMAPINFO_WIDTH,
			h = DLCMAPINFO_HEIGHT,
		})
		--_frmNode.childUI["DLCMapInfoNode" .. index].handle.s:setOpacity(111) --默认不显示（只用于响应事件，不显示）
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoNode" .. index
		
		--存储异步待绘制消息列表
		current_async_paint_list[index] = tRecordI
	end
	
	--函数：获得第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离
	getUpDownOffset = function()
		local _frm = hGlobal.UI.PhoneRandomMapRankInfoFrm
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
			delta1_ly = btn1_ly + 79
		end
		
		--最后一个DLC地图面板的数据
		local DLCMapInfoBtnN = _frmNode.childUI["DLCMapInfoNode" .. current_DLCMap_max_num]
		local btnN_cx, btnN_cy = 0, 0 --最后一个DLC地图面板中心点位置
		local btnN_ry = 0 --最后一个DLC地图面板最下侧的x坐标
		local deltNa_ry = 0 --最后一个DLC地图面板距离下侧边界的距离
		if DLCMapInfoBtnN then
			btnN_cx, btnN_cy = DLCMapInfoBtnN.data.x, DLCMapInfoBtnN.data.y --最后一个DLC地图面板中心点位置
			btnN_ry = btnN_cy - DLCMAPINFO_HEIGHT / 2 --最后一个DLC地图面板最下侧的x坐标
			deltNa_ry = btnN_ry + 610 + 26 --最后一个DLC地图面板距离下侧边界的距离
		end
		
		--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
		
		return delta1_ly, deltNa_ry
	end
	
	--函数：收到排行榜静态数据模板的回调（第1个、第2个分页）
	on_receive_billboardT_event = function(bId, billboardT)
		local _frm = hGlobal.UI.PhoneRandomMapRankInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		if (bId == current_rankId) then
			current_rankTemplateInfo = billboardT --排行榜静态模板信息
			
			--发起查询排名信息
			--print("发起查询排名信息")
			SendCmdFunc["get_billboard"](bId)
		end
	end
	
	--函数：收到排行榜信息回调
	on_receive_gamecoin_change_hostory_Back = function(bid, billboard)
		local _frm = hGlobal.UI.PhoneRandomMapRankInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("收到游戏币变化历史纪录回调", billboard, billboard.num)
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--清除右侧界面
		_removeRightFrmFunc()
		
		--隐藏上下分页按钮
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false)
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false)
		
		--依次绘制游戏币变化历史纪录
		--初始化参数
		current_DLCMap_max_num = 0
		current_rankInfo = billboard
		
		--依次绘制每条记录
		local tRecord = billboard.info
		for i = 1, #tRecord, 1 do
			--异步绘制
			on_create_single_gamecoin_record_UI_async(i, tRecord[i])
			
			--标记总数量
			current_DLCMap_max_num = current_DLCMap_max_num + 1
		end
		
		--超过一页，显示向下分页按钮
		if (current_DLCMap_max_num > (DLCMAPINFO_X_NUM * DLCMAPINFO_Y_NUM)) then
			_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true)
		end
		
		--我的排名值
		if (current_rankInfo.rankingMe > 0) then
			_frmNode.childUI["DLCMapInfoRankMe"] = hUI.label:new({
				parent = _parentNode,
				x = DLCMAPINFO_OFFSET_X + 200,
				y = DLCMAPINFO_OFFSET_Y - 714 - 2,
				font = "numWhite",
				size = 24,
				align = "LC",
				text = current_rankInfo.rankingMe,
				border = 0,
				--RGB = {0, 255, 0},
			})
			_frmNode.childUI["DLCMapInfoRankMe"].handle.s:setColor(ccc3(0, 255, 0))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoRankMe"
		else
			--无排名
			_frmNode.childUI["DLCMapInfoRankMe"] = hUI.label:new({
				parent = _parentNode,
				x = DLCMAPINFO_OFFSET_X + 200,
				y = DLCMAPINFO_OFFSET_Y - 714,
				font = hVar.FONTC,
				size = 26,
				align = "LC",
				text = hVar.tab_string["__TEXT_TemporaryNone"], --"暂无"
				border = 1,
				RGB = {192, 192, 192},
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoRankMe"
		end
		
		--我的战绩
		local myValue = ""
		if (current_rankId == 1) then --随机迷宫
			local stageMe = math.floor(current_rankInfo.rankMe / 10)
			local floorMe = math.floor(current_rankInfo.rankMe % 10)
			myValue = tostring(stageMe) .. "-" .. tostring(floorMe)
		elseif (current_rankId == 2) then --前哨阵低
			myValue = current_rankInfo.rankMe
		end
		if (current_rankInfo.rankingMe > 0) then
			local stageMe = math.floor(current_rankInfo.rankMe / 10)
			local floorMe = math.floor(current_rankInfo.rankMe % 10)
			_frmNode.childUI["DLCMapInfoStageMe"] = hUI.label:new({
				parent = _parentNode,
				x = DLCMAPINFO_OFFSET_X + 600,
				y = DLCMAPINFO_OFFSET_Y - 714 - 2,
				font = "numWhite",
				size = 24,
				align = "LC",
				text = myValue,
				border = 0,
				--RGB = {0, 255, 0},
			})
			_frmNode.childUI["DLCMapInfoStageMe"].handle.s:setColor(ccc3(0, 255, 0))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoStageMe"
		else
			--无排名
			_frmNode.childUI["DLCMapInfoRankMe"] = hUI.label:new({
				parent = _parentNode,
				x = DLCMAPINFO_OFFSET_X + 600,
				y = DLCMAPINFO_OFFSET_Y - 714,
				font = hVar.FONTC,
				size = 26,
				align = "LC",
				text = hVar.tab_string["__TEXT_TemporaryNone"], --"暂无"
				border = 1,
				RGB = {192, 192, 192},
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoRankMe"
		end
		
		--没有排名数据
		if (billboard.num == 0) then
			--暂无排名
			_frmNode.childUI["DLCMapInfoRankNone"] = hUI.label:new({
				parent = _parentNode,
				x = DLCMAPINFO_OFFSET_X + 320,
				y = DLCMAPINFO_OFFSET_Y - 390,
				font = hVar.FONTC,
				size = 26,
				align = "LC",
				text = hVar.tab_string["__TEXT_TemporaryNoneRank"], --"暂无排名"
				border = 1,
				RGB = {192, 192, 192},
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoRankNone"
		end
	end
	
	--函数：显示某个指定的排行榜界面tip
	OnRefreshRankBoardFrame_Single = function(selectTipIdx, touchX, touchY)
		local _frm = hGlobal.UI.PhoneRandomMapRankInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("显示某个指定的排行榜界面", selectTipIdx)
		--检测点到了哪个英雄、装备、塔上面，显示tip
		if (type(current_rankTemplateInfo == "table")) and (type(current_rankInfo == "table")) then
			local info = current_rankInfo.info
			if info then
				local playerInfo = info[selectTipIdx]
				if playerInfo then
					--检测是否点到了阵容查看区域、奖励道具区域
					local pnode = _frmNode.childUI["DLCMapInfoNode" .. selectTipIdx]
					if pnode then
						--检测奖励道具
						local reward = current_rankTemplateInfo.info[current_rankId].prize.reward
						if reward then
							for n = 1, #reward, 1 do
								local rbtn = _frmNode.childUI["DLCMapInfoNode" .. selectTipIdx].childUI["reward" .. n]
								if rbtn then
									local bx, by = rbtn.data.x + pnode.data.x, rbtn.data.y + pnode.data.y
									local ww, hh = rbtn.data.w, rbtn.data.h
									local button_left = bx - ww / 2 --英雄选中区域的最左侧
									local button_right = bx + ww / 2 --英雄选中区域的最右侧
									local button_top = by - hh / 2 --英雄选中区域的最上侧
									local button_bottom = by + hh / 2 --英雄选中区域的最下侧
									
									--检测是否点击到了奖励道具图片
									if (touchX >= button_left) and (touchX <= button_right) and (touchY >= button_top) and (touchY <= button_bottom) then
										--print("点到了奖励道具区域" .. selectTipIdx, n)
										
										--显示奖励道具tip
										local reward = current_rankTemplateInfo.info[current_rankId].prize.reward
										for r = 1, #reward, 1 do
											local giveRewardT = reward[r]
											local from = giveRewardT.from
											local to = giveRewardT.to
											if (selectTipIdx >= from) and (selectTipIdx <= to) then
												local rewardT = giveRewardT[n]
												if rewardT then
													--显示各种类型的奖励的tip
													hApi.ShowRewardTip(rewardT)
												end
												
												break
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	--函数：横竖屏切换
	on_spine_screen_event = function()
		local _frm = hGlobal.UI.PhoneRandomMapRankInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--关闭本界面
		OnClosePanel()
		
		--重绘本随机迷宫排行榜界面
		hGlobal.UI.InitRandomMapRankInfoFrm("reload") --测试
		--触发事件，显示随机迷宫排行榜界面
		hGlobal.event:event("LocalEvent_Phone_ShowRandomMapRankInfoFrm", current_rankId, current_funcCallback)
	end
	
end

--监听打开游戏币变化界面通知事件
hGlobal.event:listen("LocalEvent_Phone_ShowRandomMapRankInfoFrm", "__ShowGameCoinHistoryFrm", function(bId, callback)
	hGlobal.UI.InitRandomMapRankInfoFrm("reload")
	
	--触发事件，显示积分、金币界面
	--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
	
	--存储参数
	current_rankId = bId
	current_funcCallback = callback
	
	--显示游戏币变化界面
	hGlobal.UI.PhoneRandomMapRankInfoFrm:show(1)
	hGlobal.UI.PhoneRandomMapRankInfoFrm:active()
	
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
end)

--test
--[[
--测试代码
if hGlobal.UI.PhoneRandomMapRankInfoFrm then --删除上一次的游戏币变化界面
	hGlobal.UI.PhoneRandomMapRankInfoFrm:del()
	hGlobal.UI.PhoneRandomMapRankInfoFrm = nil
end
hGlobal.UI.InitRandomMapRankInfoFrm("reload") --测试创建随机迷宫排行榜界面
hGlobal.event:event("LocalEvent_Phone_ShowRandomMapRankInfoFrm", 2)
]]


