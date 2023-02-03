



--竖屏模式
local BOARD_WIDTH = 690 --DLC地图面板面板的宽度
local BOARD_HEIGHT = 740 --DLC地图面板面板的高度
local BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 10
local BOARD_OFFSETY = -15 --DLC地图面板面板y偏移中心点的值
local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --DLC地图面板面板的x位置（最左侧）
local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --DLC地图面板面板的y位置（最顶侧）
--local BOARD_ACTIVE_WIDTH = 508 --排行榜面板活动宽度（卡牌显示的宽度）

--横屏模式
if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
	BOARD_WIDTH = 740 --DLC地图面板面板的宽度
	BOARD_HEIGHT = 690 --DLC地图面板面板的高度
	BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 20
	BOARD_OFFSETY = 15 --DLC地图面板面板y偏移中心点的值
	BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --DLC地图面板面板的x位置（最左侧）
	BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --DLC地图面板面板的y位置（最顶侧）
end

local BOARD_ACTIVE_WIDTH = 508 --任务操作面板活动宽度（卡牌显示的宽度）

local PAGE_BTN_LEFT_X = 480 --第一个分页按钮的x偏移
local PAGE_BTN_LEFT_Y = -6 --第一个分页按钮的x偏移
local PAGE_BTN_OFFSET_X = 140 --每个分页按钮的间距

local BILLBOARD_WIDTH = 200 --排行榜宽度
local BILLBOARD_HEIGHT = 180 --排行榜高度
local BILLBOARD_OFFSETX = 210 --排行榜第一个元素距离左侧的x偏移
local BILLBOARD_OFFSETY = -210 --排行榜第一个元素距离左侧的y偏移
local BILLBOARD_DISTANCEX = 10 --排行榜x间距
local BILLBOARD_DISTANCEY = 10 --排行榜y间距
	
--横屏模式
if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
	BILLBOARD_OFFSETX = 210 + 50
end

--临时UI管理
local leftRemoveFrmList = {} --左侧控件集
local rightRemoveFrmList = {} --右侧控件集
local _removeLeftFrmFunc = hApi.DoNothing --清空左侧所有的临时控件
local _removeRightFrmFunc = hApi.DoNothing --清空右侧所有的临时控件

--局部函数
--local OnConnectGameCenterSuccess = hApi.DoNothing --登入gamecenter成功事件
local OnClickPageBtn = hApi.DoNothing --点击分页按钮

--函数部分
--分页1：商城抽奖函数部分
--local OnCreateShopChouJiangFrame = hApi.DoNothing --创建商城抽奖界面（第1个分页）
--local on_update_shop_autosell_flag = hApi.DoNothing --更新商城自动分解标识
--local on_receive_shop_choujiang_info_event = hApi.DoNothing --收到商城抽奖信息结果返回
--local on_receive_shop_choujiang_redchest_result_event = hApi.DoNothing --收到商城神器宝箱抽一次（抽十次）结果返回
--local on_receive_shop_choujiang_tacticcard_result_event = hApi.DoNothing --收到商城战术卡包抽一次（抽十次）结果返回
--local on_check_shopchoujiang_tanhao = hApi.DoNothing --刷新商城抽奖叹号
--local on_refresh_shop_redchest_free_lefttime_timer = hApi.DoNothing --刷新商城倒计时timer

--分页2：商城碎片函数部分
local OnCreateShopLimitTimeDebrisFrame = hApi.DoNothing --创建商城限时碎片界面（第2个分页）
local on_receive_shop_iteminfo_back_event = hApi.DoNothing --收到商城商品信息结果返回
local on_receive_shop_refresh_back_event = hApi.DoNothing --收到商城刷新结果返回
local on_spine_screen_event = hApi.DoNothing --横竖屏切换
local on_click_buitem_shopitem = hApi.DoNothing --点击购买商城道具逻辑
local on_click_refresh_shopitem = hApi.DoNothing --点击刷新商城道具逻辑
local on_check_shopitem_tanhao = hApi.DoNothing --刷新限时商城叹号
local on_refresh_shop_buyitem_lefttime_timer = hApi.DoNothing --刷新商城限时商品倒计时timer
local __DynamicAddRes = hApi.DoNothing --动态加载资源
local __DynamicRemoveRes = hApi.DoNothing --动态删除资源
local OnClosePanel = hApi.DoNothing --关闭本界面

--分页3：商城广告
--local OnCreateShopAdvertisementFrame = hApi.DoNothing --创建商城广告界面（第3个分页）
--local on_receive_adv_view_count_info_back_event = hApi.DoNothing --收到商城今日看广告次数信息结果返回
--local on_receive_advview_finish_back_event = hApi.DoNothing --收到商城今日看广告完成事件返回
--local on_receive_advview_fail_back_event = hApi.DoNothing --收到商城今日看广告失败事件返回
--local on_receive_advview_takereward_back_event = hApi.DoNothing --收到商城今日看广告领取奖励结果返回
--local on_click_view_adv_btn = hApi.DoNothing --点击看广告逻辑
--local on_click_view_adv_takereward_btn = hApi.DoNothing --点击广告领奖逻辑
--local on_check_advview_tanhao = hApi.DoNothing --刷新看广告叹号
--local on_refresh_shop_adv_view_lefttime_timer = hApi.DoNothing --刷新商城看广告倒计时timer

--参数部分

--分页1：限时商品相关参数
local SHOP_ITEM_X_NUM = 3
local SHOP_ITEM_Y_NUM = 2
local SHOP_BUYITEM_SHOPID = 1 --商店id
local SHOP_REFRESH_RMBCOST = 20 --商店刷新需要的游戏币
local current_shop_inaction = false --商店是否动画中（动画中不刷新界面）
local current_shop_query_flag = 0 --商店是否需要查询（仅每次第一次打开才需要发起查询）
local current_funcCallback = nil --关闭后的回调事件
local _bCanCreate = true --防止重复创建
--当前选中的记录
local CurrentSelectRecord = {pageIdx = 0, contentIdx = 0, cardId = 0,} --当前选择的分页、数据项的信息记录



--新商店面板
hGlobal.UI.InitNetShopNewFrm = function(mode)
	local tInitEventName = {"LocalEvent_Phone_ShowNetShopNewFrm", "__ShowNetShopNewFrm",}
	if (mode ~= "reload") then
		--return tInitEventName
		return
	end
	
	--不重复创建
	if hGlobal.UI.PhoneNetShopFrm_New then --新商店面板
		hGlobal.UI.PhoneNetShopFrm_New:del()
		hGlobal.UI.PhoneNetShopFrm_New = nil
	end
	
	--[[
	--取消监听打开新商店界面事件
	hGlobal.event:listen("LocalEvent_Phone_ShowNetShopNewFrm", "__ShowNetShopNewFrm", nil)
	--取消监听关闭宝箱界面事件
	hGlobal.event:listen("clearPhoneChestFrm", "__CloseLimittimeShopFrm", nil)
	]]
	
	--竖屏模式
	BOARD_WIDTH = 690 --DLC地图面板面板的宽度
	BOARD_HEIGHT = 740 --DLC地图面板面板的高度
	BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 10
	BOARD_OFFSETY = -15 --DLC地图面板面板y偏移中心点的值
	BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --DLC地图面板面板的x位置（最左侧）
	BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --DLC地图面板面板的y位置（最顶侧）
	--横屏模式
	if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
		BOARD_WIDTH = 740 --DLC地图面板面板的宽度
		BOARD_HEIGHT = 690 --DLC地图面板面板的高度
		BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 20
		BOARD_OFFSETY = 15 --DLC地图面板面板y偏移中心点的值
		BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --DLC地图面板面板的x位置（最左侧）
		BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --DLC地图面板面板的y位置（最顶侧）
	end
	
	BILLBOARD_OFFSETX = 210 --排行榜第一个元素距离左侧的x偏移
	--横屏模式
	if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
		BILLBOARD_OFFSETX = 210 + 50
	end
	--加载资源
	--xlLoadResourceFromPList("data/image/misc/pvp.plist")
	
	--hApi.clearTimer("__SHOP_TIMER_PAGE_OPENCHEST__")
	hApi.clearTimer("__SHOP_TIMER_PAGE_BUYITEM__")
	--hApi.clearTimer("__SHOP_TIMER_PAGE_ADVVIEW__")
	
	--创建新商城面板
	hGlobal.UI.PhoneNetShopFrm_New = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 2,
		show = 0, --一开始不显示
		border = 1, --显示frame边框
		background = -1, --"panel/panel_part_00.png",
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
	
	local _frm = hGlobal.UI.PhoneNetShopFrm_New
	local _parent = _frm.handle._n
	
	--活动左侧裁剪区域
	--local _BTC_PageClippingRect_Activity = {0, -80, 1000, 460, 0}
	--local _BTC_pClipNode_Activity = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect_Activity, 99, _BTC_PageClippingRect_Activity[5], "_BTC_pClipNode_Activity")
	
	--主界面黑色背景图
	_frm.childUI["panel_bg"] = hUI.button:new({
		parent = _parent,
		model = "misc/mask.png",
		x = _frm.data.w,
		y = 0,
		w = 1,
		h = 1,
		z = -1,
	})
	_frm.childUI["panel_bg"].handle.s:setOpacity(0) --为了挂载动态图
	
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
	--btnClose
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		model = "misc/mask.png",
		--x = hVar.SCREEN.w - iPhoneX_WIDTH - 40 * _ScaleW,
		--y = -34 * _ScaleH,
		--x = hVar.SCREEN.w - iPhoneX_WIDTH * 2 - 57,
		x = BOARD_WIDTH - 49,
		y = -30 - 19,
		z = 100,
		w = 96,
		h = 96,
		scaleT = 0.95,
		code = function()
			--关闭本界面
			OnClosePanel()
			
			--由关闭按钮触发的关闭，不能再次打开
			_bCanCreate = false
			
			--回调事件
			if (type(current_funcCallback) == "function") then
				current_funcCallback()
			end
		end,
	})
	_frm.childUI["closeBtn"].handle.s:setOpacity(0) --只响应事件，不显示
	--关闭图标
	_frm.childUI["closeBtn"].childUI["icon"] = hUI.button:new({
		parent = _frm.childUI["closeBtn"].handle._n,
		model = "misc/skillup/btn_close.png",
		--model = "BTN:PANEL_CLOSE",
		align = "MC",
		x = 0,
		y = 0,
		scale = 1.0,
	})
	
	--[[
	--面板的标题栏背景图
	_frm.childUI["frameTitleBG"] = hUI.image:new({
		parent = _parent,
		model = "UI:MedalDarkImg", --"UI:Tactic_Button",
		x = PAGE_BTN_LEFT_X + 296,
		y = PAGE_BTN_LEFT_Y + 53,
		w = 220,
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
		--text = "任务成就", --language
		text = hVar.tab_string["__TEXT_MAINUI_BTN_MISSION"], --language
	})
	]]
	
	--每个分页按钮
	--商城抽奖、商城碎片、看广告
	local tPageIcons = {"UI:JUBAOPEN",}
	--local tTexts = {"聚宝盆", "限时商品", "看广告",} --language
	local tTexts = {"",} --language --hVar.tab_string["__TEXT_Page_Rune"]
	for i = 1, #tPageIcons, 1 do
		--分页按钮
		_frm.childUI["PageBtn" .. i] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			x = PAGE_BTN_LEFT_X,
			y = PAGE_BTN_LEFT_Y - (i - 1) * PAGE_BTN_OFFSET_X,
			z = 1,
			w = 170,
			h = 80,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function(self, screenX, screenY, isInside)
				OnClickPageBtn(i)
			end,
		})
		_frm.childUI["PageBtn" .. i].handle.s:setOpacity(0) --分页按钮点击区域，只作为控制用，不用于显示
		
		--[[
		--分页按钮的方块图标
		_frm.childUI["PageBtn" .. i].childUI["PageImage"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = "UI:BTN_TASK", --"UI:Tactic_Button",
			x = 0,
			y = 0,
			w = 166,
			h = 74,
		})
		
		--分页按钮的图标
		_frm.childUI["PageBtn" .. i].childUI["PageIcon"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = tPageIcons[i],
			x = -40 - 4,
			y = 0,
			w = 36,
			h = 36,
		})
		
		--分页按钮的文字
		local fontSize = 26
		local fontDx = 0
		local fontLength = (#tTexts[i])
		if (fontLength >= 12) then --4个汉字
			fontSize = 22
			fontDx = -6
		elseif (fontLength >= 9) then --3个汉字
			fontSize = 24
			fontDx = 0
		end
		_frm.childUI["PageBtn" .. i].childUI["PageText"] = hUI.label:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			x = -16 - 4 + fontDx,
			y = -2,
			size = fontSize,
			align = "LC",
			border = 1,
			font = hVar.FONTC,
			width = 100,
			text = tTexts[i],
		})
		]]
		--分页按钮的提示升级的动态箭头标识
		_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = "UI:TaskTanHao",
			x = -40,
			y = 6,
			w = 42,
			h = 42,
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
		local _frm = hGlobal.UI.PhoneNetShopFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneNetShopFrm_New
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
			_frm.childUI["PageBtn" .. i]:setstate(1) --按钮可用
			--_frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s:setVisible(true) --显示图片
			--_frm.childUI["PageBtn" .. i].childUI["PageIcon"].handle.s:setVisible(true) --显示图标
			--_frm.childUI["PageBtn" .. i].childUI["PageText"].handle.s:setVisible(true) --显示文字
		end
		
		--[[
		--当前按钮高亮
		--hApi.AddShader(_frm.childUI["PageBtn" .. pageIndex].childUI["PageImage"].handle.s, "normal")
		_frm.childUI["PageBtn" .. pageIndex].childUI["PageImage"]:setmodel("UI:BTN_TASK", nil, nil)
		hApi.AddShader(_frm.childUI["PageBtn" .. pageIndex].childUI["PageIcon"].handle.s, "normal")
		_frm.childUI["PageBtn" .. pageIndex].childUI["PageText"].handle.s:setColor(ccc3(255, 255, 0))
		
		--其它按钮灰掉
		for i = 1, #tPageIcons, 1 do
			if (i ~= pageIndex) then
				--hApi.AddShader(_frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s, "gray")
				_frm.childUI["PageBtn" .. i].childUI["PageImage"]:setmodel("UI:BTN_TASK_DARK", nil, nil)
				hApi.AddShader(_frm.childUI["PageBtn" .. i].childUI["PageIcon"].handle.s, "gray")
				_frm.childUI["PageBtn" .. i].childUI["PageText"].handle.s:setColor(ccc3(192, 192, 192))
			end
		end
		]]
		
		--先清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--清空切换分页之后取消的监听事件
		--移除事件监听：收到新商店抽奖信息结果回调
		hGlobal.event:listen("localEvent_ShopChouJiangInfo_Ret", "__OnReceiveShopChouJiangInfo", nil)
		--移除事件监听：使用商城抽奖-神器宝箱抽一次结果返回
		hGlobal.event:listen("localEvent_ShopChouJiangRedChestOnce_Ret", "__OnReceiveShopChouJiangRedChestOnce", nil)
		--移除事件监听：使用商城抽奖-神器宝箱抽十次结果返回
		hGlobal.event:listen("localEvent_ShopChouJiangRedChestTenth_Ret", "__OnReceiveShopChouJiangRedChestTenth", nil)
		--移除事件监听：使用商城抽奖-战术卡包抽一次结果返回
		hGlobal.event:listen("localEvent_ShopChouJiangTacticCardOnce_Ret", "__OnReceiveShopChouJiangTacticCardOnce", nil)
		--移除事件监听：使用商城抽奖-战术卡包抽十次结果返回
		hGlobal.event:listen("localEvent_ShopChouJiangTacticCardTenth_Ret", "__OnReceiveShopChouJiangTacticCardTenth", nil)
		--移除事件监听：商城信息返回
		hGlobal.event:listen("localEvent_refresh_shopinfo", "__OnReceiveShopItemRet", nil)
		--移除事件监听：商城刷新操作事件返回
		hGlobal.event:listen("localEvent_shop_refresh_result_ret", "__OnReceiveShopRefreshRet", nil)
		--移除事件监听：商城今日看广告次数信息结果返回
		hGlobal.event:listen("localEvent_ShopTodayAdvViewInfo_Ret", "__OnReceiveAdvViewCountRet", nil)
		--移除事件监听：商城今日看广告完成事件返回
		hGlobal.event:listen("LocalEvent_AdsOver", "__AdsOverRet", nil)
		--移除事件监听：今日看广告失败事件返回
		hGlobal.event:listen("LocalEvent_AdsFailed", "__AdsFailRet_Shop_", nil)
		--移除事件监听：商城今日看广告领取奖励结果返回
		hGlobal.event:listen("localEvent_ShopTodayAdvViewTakeReward_Ret", "__AdsTakeRewardRet", nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenShop_", nil)
		
		--移除timer
		--hApi.clearTimer("__SHOP_TIMER_PAGE_OPENCHEST__")
		hApi.clearTimer("__SHOP_TIMER_PAGE_BUYITEM__")
		--hApi.clearTimer("__SHOP_TIMER_PAGE_ADVVIEW__")
		
		--隐藏所有的clipNode
		--hApi.EnableClipByName(_frm, "_BTC_pClipNode_Activity", 0)
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：商城碎片
			--创建商城碎片界面
			OnCreateShopLimitTimeDebrisFrame(pageIndex)
		end
		
		--标记当前选择的分页和页内的第几个
		CurrentSelectRecord.pageIdx = pageIndex
		CurrentSelectRecord.contentIdx = 0
	end
	
	--函数：创建商城限时商品界面（第1个分页）
	OnCreateShopLimitTimeDebrisFrame = function(pageIdx)
		local _frm = hGlobal.UI.PhoneNetShopFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--动态加载宝物背景大图
		__DynamicAddRes()
		
		--[[
		--分页的中央标题背景底图
		_frmNode.childUI["TaskPageImage"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/chest/get_new_hero_bar.png",
			x = 480,
			y = -6,
			w = 395,
			h = 73,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TaskPageImage"
		
		--分页的中央标题背景底图
		_frmNode.childUI["TaskPageTitle"] = hUI.label:new({
			parent = _parentNode,
			x = 480,
			y = -6+9,
			size = 26,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 300,
			text = tTexts[pageIdx],
			RGB = {255, 255, 0,},
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TaskPageTitle"
		]]
		local bgWidth = 140
		--[[
		--左侧底板
		--背景图
		local bgWidth = 140
		_frmNode.childUI["DLCMapInfoListBG"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/selectbg.png",
			x = bgWidth/2 + 6,
			y = -BOARD_HEIGHT/2,
			w = bgWidth + 60,
			h = BOARD_HEIGHT - 12,
		})
		_frmNode.childUI["DLCMapInfoListBG"].handle.s:setOpacity(128) --底板透明度为128
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoListBG"
		
		--左侧竖线
		_frmNode.childUI["DLCMapInfoListLineV"] = hUI.button:new({ --作为按钮只是为了挂载子控件
			parent = _parentNode,
			model = "panel/panel_part_09.png",
			x = bgWidth + 16,
			y = -BOARD_HEIGHT/2,
			w = BOARD_HEIGHT + 16,
			h = 12,
		})
		_frmNode.childUI["DLCMapInfoListLineV"].handle.s:setRotation(-90)
		_frmNode.childUI["DLCMapInfoListLineV"].handle.s:setOpacity(128) --竖线透明度为128
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoListLineV"
		]]
		
		----------------------------------------------------------------------------------------------------
		--抽神器黑色背景底板
		--九宫格
		--local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_graywhite.png", 401, -20, 756, 540, _frmNode.childUI["DLCMapInfoListLineV"])
		--s9:setColor(ccc3(128, 128, 128))
		--s9:setOpacity(32)
		
		--loop
		--依次绘制限时商品
		local NUM = SHOP_ITEM_X_NUM * SHOP_ITEM_Y_NUM
		for i = 1, NUM, 1 do
			local xn = i % SHOP_ITEM_X_NUM
			if (xn == 0) then
				xn = SHOP_ITEM_X_NUM
			end
			local yn = (i - xn) / SHOP_ITEM_X_NUM + 1
			--local posX = bgWidth + 150 + (xn - 1) * (180)
			--local posY = -BOARD_HEIGHT/2 + 62 - (yn - 1) * (230)
			local offsetList =
			{
				[1] = {x = -54,y = 59,}, --武器枪宝箱
				[2] = {x = -(BILLBOARD_WIDTH + BILLBOARD_DISTANCEX)-54, y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY)+69,}, --战术宝箱
				[3] = {x = -158-60,y = 59,}, --宠物宝箱
				[4] = {x = -54,y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY) + 79,}, --装备宝箱
				[5] = {x = 52-60,y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY) + 259,}, --装备宝箱
				[6] = {x = -(BILLBOARD_WIDTH + BILLBOARD_DISTANCEX)+52-60,y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY) + 79,}, --装备宝箱
			}
			
			local offsetX = BILLBOARD_OFFSETX + (xn - 1) * (BILLBOARD_WIDTH + BILLBOARD_DISTANCEX)
			local offsetY = BILLBOARD_OFFSETY - (yn - 1) * (BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY)
			
			--商品i
			_frmNode.childUI["DLCMapInfoShopItem_" .. i] = hUI.button:new({ --作为按钮只是为了挂载子控件
				parent = _parentNode,
				model = "misc/mask.png",
				x = offsetX + offsetList[i].x,
				y = offsetY + offsetList[i].y,
				w = BILLBOARD_WIDTH,
				h = BILLBOARD_HEIGHT,
				dragbox = _frm.childUI["dragBox"],
				scaleT = 1.0,
				
				--点击事件
				code = function(self, touchX, touchY, sus)
					--print("i", i)
					local shopId = SHOP_BUYITEM_SHOPID
					local list = LuaGetTodayNetShopGoods(g_curPlayerName, shopId)
					if list then
						local goods = list.goods
						if (type(goods) == "table") then
							local good = goods[i]
							if (type(good) == "table") then
								local id = good.id --tab_shopitem的id
								local itemId = good.itemId --tab_item的id
								local num = good.num --碎片数量
								local score = good.score --购买需要的积分
								local rmb = good.rmb --购买需要的游戏币
								local quota = good.quota --总购买次数
								local saledCount = good.saledCount --已购买次数
								local leftNum = quota - saledCount --剩余购买次数
								
								--点击商品
								on_click_buitem_shopitem(i, good)
								
								--[[
								--显示道具的tip
								--检测是否为英雄将魂、兵种卡等道具
								local tabI = hVar.tab_item[itemId] or {}
								local itemType = tabI.type
								if (itemType == hVar.ITEM_TYPE.SOULSTONE) then --英雄将魂
									--显示英雄将魂tip
									local heroItemId = itemId
									hApi.ShowHeroDerbiesTip(heroItemId)
								elseif (itemType == hVar.ITEM_TYPE.TACTICDEBRIS) then --兵种卡或兵种卡
									local tacticId = tabI.tacticID or 0
									local tabT = hVar.tab_tactics[tacticId] or {}
									local tactiType = tabT.type
									
									if (tactiType == hVar.TACTICS_TYPE.ARMY) then --兵种卡
										--显示PVP兵种tip
										local tacticLv = 1
										hApi.ShowTacticCardTip_PVP(tacticId, tacticLv)
									else --战术卡
										--显示战术技能卡碎片tip
										local rewardType = 6
										local tacticNum = 1
										local tacticLv = 1
										hApi.ShowTacticCardTip(rewardType, tacticId, tacticLv)
									end
								elseif (itemType == hVar.ITEM_TYPE.CANGBAOTU_NORMAL) then --藏宝图
									--显示藏宝图tip
									hApi.ShowCangBaoTuTip()
								elseif (itemType == hVar.ITEM_TYPE.CANGBAOTU_HIGH) then --高级藏宝图
									--显示高级藏宝图tip
									hApi.ShowCangBaoTuHighTip()
								else --一般道具
									--显示道具tip
									local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
									local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
									hGlobal.event:event("LocalEvent_ShowItemTipFram", {{itemId, 1}}, nil, 1, itemtipX, itemtipY, 0)
								end
								]]
							end
						end
					end
				end,
			})
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].handle.s:setOpacity(0) --只响应事件，不显示
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoShopItem_" .. i
			
			--[[
			--商品卡背（正面）
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["card"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoShopItem_" .. i].handle._n,
				model = "UI:CHOUJIANG_TACTIC_FRONT",
				x = 0,
				y = 0,
				w = 130*1.1,
				h = 188*1.1,
			})
			
			--商品名称背景图
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["titleBG"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoShopItem_" .. i].handle._n,
				model = "UI:cjbt",
				x = 0,
				y = 74,
				w = 130,
				h = 26,
				alpha = 168, --透明度
			})
			]]
			
			--[[
			--商品名称
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["title"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoShopItem_" .. i].handle._n,
				model = "UI:game_coins",
				x = 0,
				y = 74 - 1,
				size = 20,
				align = "MC",
				font = hVar.FONTC,
				border = 1,
				text = "",
			})
			]]
			
			--[[
			--商品图标外框
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["itemBox"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoShopItem_" .. i].handle._n,
				model = "misc/chest/astro_btnbg.png",
				x = 0,
				y = -4,
				w = 96,
				h = 96,
			})
			]]
			
			--商品图标
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["itemIconParent"] = hUI.node:new({
				parent = _frmNode.childUI["DLCMapInfoShopItem_" .. i].handle._n,
				model = "misc/button_null.png",
				x = 0,
				y = 20,
				w = 1,
				h = 1,
			})
			--宝物图标随机动画
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
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["itemIconParent"].handle._n:runAction(CCRepeatForever:create(sequence))
			
			--商品图标
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["itemIconParent"].childUI["itemIcon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["itemIconParent"].handle._n,
				model = "misc/button_null.png",
				x = 0,
				y = 0,
				w = 96,
				h = 96,
			})
			
			--商品碎片图标
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["itemIconParent"].childUI["debrisIcon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["itemIconParent"].handle._n,
				model = "UI:SoulStoneFlag",
				x = 30,
				y = -26,
				w = 32,
				h = 32,
			})
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["itemIconParent"].childUI["debrisIcon"].handle._n:setVisible(false) --默认不显示
			
			--数量x10的图标
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["itemIconParent"].childUI["debris10Icon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["itemIconParent"].handle._n,
				model = "ICON:debris_10",
				x = 0,
				y = -32,
				scale = 1.0,
			})
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["itemIconParent"].childUI["debris10Icon"].handle._n:setVisible(false) --默认不显示
			--数量x50的图标
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["itemIconParent"].childUI["debris50Icon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["itemIconParent"].handle._n,
				model = "ICON:debris_50",
				x = 0,
				y = -32,
				w = 90,
				h = 32,
			})
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["itemIconParent"].childUI["debris50Icon"].handle._n:setVisible(false) --默认不显示
			
			--商品数量
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["itemNum"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoShopItem_" .. i].handle._n,
				x = 0,
				y = -20,
				size = 32,
				align = "MC",
				font = "numWhite",
				border = 0,
				text = "",
			})
			
			--碎片数量偏移
			local debrisOffsetList =
			{
				[1] = {x = 13,y = 27,}, --武器枪宝箱
				[2] = {x = 13, y = 27,}, --战术宝箱
				[3] = {x = 15, y = 27,}, --宠物宝箱
				[4] = {x = 13,y = 27,}, --装备宝箱
				[5] = {x = 15,y = 27,}, --装备宝箱
				[6] = {x = 15,y = 27,}, --装备宝箱
			}
			
			--商品价格区域node
			_frmNode.childUI["DLCMapInfoShopItem_" .. i .. "rbmBtn"] = hUI.button:new({ --作为按钮只是为了挂载子控件
				parent = _parentNode,
				model = "misc/mask.png",
				--x = 0,
				--y = -80,
				dragbox = _frm.childUI["dragBox"],
				x = offsetX + offsetList[i].x + debrisOffsetList[i].x,
				y = offsetY + offsetList[i].y - 86 + debrisOffsetList[i].y,
				w = 204,
				h = 52,
				scaleT = 0.95,
				code = function()
					--print("i", i)
					local shopId = SHOP_BUYITEM_SHOPID
					local list = LuaGetTodayNetShopGoods(g_curPlayerName, shopId)
					if list then
						local goods = list.goods
						if (type(goods) == "table") then
							local good = goods[i]
							if (type(good) == "table") then
								local id = good.id --tab_shopitem的id
								local itemId = good.itemId --tab_item的id
								local num = good.num --碎片数量
								local score = good.score --购买需要的积分
								local rmb = good.rmb --购买需要的游戏币
								local quota = good.quota --总购买次数
								local saledCount = good.saledCount --已购买次数
								local leftNum = quota - saledCount --剩余购买次数
								
								--点击商品
								on_click_buitem_shopitem(i, good)
								--[[
								--有剩余次数
								if (leftNum > 0) then
									--购买商品
									on_click_buitem_shopitem(i)
								else
									--显示道具的tip
									--检测是否为英雄将魂、兵种卡等道具
									local tabI = hVar.tab_item[itemId] or {}
									local itemType = tabI.type
									if (itemType == hVar.ITEM_TYPE.SOULSTONE) then --英雄将魂
										--显示英雄将魂tip
										local heroItemId = itemId
										hApi.ShowHeroDerbiesTip(heroItemId)
									elseif (itemType == hVar.ITEM_TYPE.TACTICDEBRIS) then --兵种卡或兵种卡
										local tacticId = tabI.tacticID or 0
										local tabT = hVar.tab_tactics[tacticId] or {}
										local tactiType = tabT.type
										
										if (tactiType == hVar.TACTICS_TYPE.ARMY) then --兵种卡
											--显示PVP兵种tip
											local tacticLv = 1
											hApi.ShowTacticCardTip_PVP(tacticId, tacticLv)
										else --战术卡
											--显示战术技能卡碎片tip
											local rewardType = 6
											local tacticNum = 1
											local tacticLv = 1
											hApi.ShowTacticCardTip(rewardType, tacticId, tacticLv)
										end
									elseif (itemType == hVar.ITEM_TYPE.CANGBAOTU_NORMAL) then --藏宝图
										--显示藏宝图tip
										hApi.ShowCangBaoTuTip()
									elseif (itemType == hVar.ITEM_TYPE.CANGBAOTU_HIGH) then --高级藏宝图
										--显示高级藏宝图tip
										hApi.ShowCangBaoTuHighTip()
									else --一般道具
										--显示道具tip
										local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
										local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
										hGlobal.event:event("LocalEvent_ShowItemTipFram", {{itemId, 1}}, nil, 1, itemtipX, itemtipY, 0)
									end
								end
								]]
							end
						end
					end
				end,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoShopItem_" .. i .. "rbmBtn"
			_frmNode.childUI["DLCMapInfoShopItem_" .. i .. "rbmBtn"].handle.s:setOpacity(0) --只挂载子控件，不显示
			
			--[[
			--商品价格底纹
			_frmNode.childUI["DLCMapInfoShopItem_" .. i .. "rbmBtn"].childUI["BG"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoShopItem_" .. i .. "rbmBtn"].handle._n,
				model = "misc/chest/bg_ng_graygray.png",
				x = 0,
				y = 0,
				w = 126,
				h = 30,
				alpha = 144, --透明度
			})
			]]
			
			--游戏币图标
			_frmNode.childUI["DLCMapInfoShopItem_" .. i .. "rbmBtn"].childUI["gamecoinIcon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoShopItem_" .. i .. "rbmBtn"].handle._n,
				model = "misc/skillup/keshi.png",
				x = -32,
				y = 1,
				w = 38,
				h = 38,
			})
			
			--游戏币值
			_frmNode.childUI["DLCMapInfoShopItem_" .. i .. "rbmBtn"].childUI["gamecoin"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoShopItem_" .. i .. "rbmBtn"].handle._n,
				x = -6,
				y = -1, --数字字体有2像素的偏差
				size = 26,
				align = "LC",
				font = "num",
				border = 0,
				text = "",
			})
			
			--今日剩余次数2图片
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["leftcount2"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoShopItem_" .. i].handle._n,
				x = -37,
				y = 72,
				model = "UI:SHOP_LEFTCOUNT_2",
				align = "MC",
				scale = 1,
			})
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["leftcount2"].handle._n:setVisible(false) --默认不显示
			
			--[[
			--今日剩余次数1图片
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["leftcount1"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoShopItem_" .. i].handle._n,
				x = -37,
				y = 72,
				model = "UI:SHOP_LEFTCOUNT_1",
				align = "MC",
				scale = 1,
			})
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["leftcount1"].handle._n:setVisible(false) --默认不显示
			]]
			
			--[[
			--商品售罄蒙版
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["selloutBG"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoShopItem_" .. i].handle._n,
				model = "UI:TacticBG",
				x = 0,
				y = 20,
				z = 3,
				w = 130*1.1,
				h = 130*1.1,
				alpha = 255, --透明度
			})
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["selloutBG"].handle._n:setVisible(false) --默认不显示
			]]
			
			--商品售罄图标
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["sellout"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoShopItem_" .. i].handle._n,
				model = "UI:FinishTag5_big",
				x = -4,
				y = 20,
				z = 4,
				w = 114,
				h = 81,
			})
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["sellout"].handle._n:setRotation(-5)
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["sellout"].handle._n:setVisible(false) --默认不显示
			
			--商品卡背（背面）
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["card_back"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoShopItem_" .. i].handle._n,
				model = "UI:CHOUJIANG_TACTIC2",
				x = 0,
				y = 0,
				z = 5,
				w = 130*1.1,
				h = 188*1.1,
			})
			_frmNode.childUI["DLCMapInfoShopItem_" .. i].childUI["card_back"].handle._n:setVisible(false) --默认不显示
		end
		
		--商品刷新时间背景框
		--九宫格
		--local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_9s_3.png", 401, BOARD_HEIGHT/2 - 90, 720, 48, _frmNode.childUI["DLCMapInfoListLineV"])
		
		--倒计时文字-小时值得
		local timeDx = -20 + BILLBOARD_OFFSETX - 210
		local timeDy = -26
		
		--重刷倒计时文字前缀
		_frmNode.childUI["DLCMapInfoShopRefreshTimePrefix"] = hUI.label:new({
			parent = _parentNode,
			x = bgWidth + timeDx - 70,
			y = -640 + 2,
			width = 500,
			align = "LC",
			font = hVar.FONTC,
			text = "", --hVar.tab_string["PVPChongShuaDaoJiShi_Shop"] .. ":", --"重刷倒计时"
			border = 1,
			size = 24,
			RGB = {0, 255, 0,},
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoShopRefreshTimePrefix"
		
		--刷新按钮
		_frmNode.childUI["DLCMapInfoShopRefreshBtn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/task/ironbuf_refresh.png",
			x = bgWidth + timeDx + 68 + 256,
			y = -640,
			w = 87,
			h = 87,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function()
				--刷新商城
				on_click_refresh_shopitem()
			end,
		})
		--_frmNode.childUI["DLCMapInfoShopRefreshBtn"].handle.s:setOpacity(0) --只响应事件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoShopRefreshBtn"
		--刷新按钮文字
		_frmNode.childUI["DLCMapInfoShopRefreshBtn"].childUI["label"] = hUI.label:new({
			parent = _frmNode.childUI["DLCMapInfoShopRefreshBtn"].handle._n,
			x = 0, --右括号偏左
			y = 0,
			width = 500,
			align = "MC",
			font = "numWhite",
			text = "", --hVar.tab_string["__TEXT_Reflash"], --"刷新"
			size = 26,
			border = 0,
		})
		--刷新按钮需要的游戏币图标
		_frmNode.childUI["DLCMapInfoShopRefreshBtn"].childUI["gamecoinIcon"] = hUI.image:new({
			parent = _frmNode.childUI["DLCMapInfoShopRefreshBtn"].handle._n,
			model = "misc/skillup/keshi.png",
			x = -24 - 100,
			y = 40 + 1 - 44,
			w = 38,
			h = 38,
		})
		_frmNode.childUI["DLCMapInfoShopRefreshBtn"].childUI["gamecoinIcon"].handle._n:setVisible(false) --默认隐藏
		--刷新按钮需要的游戏币值
		_frmNode.childUI["DLCMapInfoShopRefreshBtn"].childUI["gamecoinValue"] = hUI.label:new({
			parent = _frmNode.childUI["DLCMapInfoShopRefreshBtn"].handle._n,
			x = 24 - 100,
			y = 40 - 0 - 44, --数字字体有2像素的偏差
			width = 500,
			align = "MC",
			font = "num",
			text = "",
			size = 26,
			border = 0,
		})
		--刷新按钮免费文字
		_frmNode.childUI["DLCMapInfoShopRefreshBtn"].childUI["free"] = hUI.label:new({
			parent = _frmNode.childUI["DLCMapInfoShopRefreshBtn"].handle._n,
			x = 0,
			y = 48 - 2, --数字字体有2像素的偏差
			font = hVar.FONTC,
			width = 500,
			align = "MC",
			size = 20,
			text = hVar.tab_string["__TEXT_PVP_Fun_Free"], --"免费"
			border = 1,
			RGB = {0, 255, 0,},
		})
		_frmNode.childUI["DLCMapInfoShopRefreshBtn"].childUI["free"].handle._n:setVisible(false) --默认隐藏
		
		--[[
		----------------------------------------------------------------------------------------------------
		--限时商品规则介绍按钮（响应区域）
		_frmNode.childUI["DLCMapInfo_ShopItemIntroduceBtn"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = 700,
			y = -26,
			w = 84,
			h = 84,
			model = "misc/mask.png",
			scaleT = 1.0,
			scale = 1.0,
			code = function()
				--创建限时商品介绍tip
				local shopitemTip = hUI.uiTip:new()
				shopitemTip:AddIcon("UI:SHOP_DEBRIS")
				shopitemTip:AddTitle(hVar.tab_string["__TEXT_Page_Rune"], ccc3(255, 255, 0)) --"限时商品"
				shopitemTip:AddContent(hVar.tab_string["__TEXT_SHOP_DEBRIRS_INTRODUCE_1"])
				shopitemTip:AddContent(hVar.tab_string["__TEXT_SHOP_DEBRIRS_INTRODUCE_2"])
				shopitemTip:AddContent(hVar.tab_string["__TEXT_SHOP_DEBRIRS_INTRODUCE_3"])
				shopitemTip:AddContent(hVar.tab_string["__TEXT_SHOP_DEBRIRS_INTRODUCE_4"])
				shopitemTip:SetTitleCentered()
			end,
		})
		_frmNode.childUI["DLCMapInfo_ShopItemIntroduceBtn"].handle.s:setOpacity(0) --用于响应事件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfo_ShopItemIntroduceBtn"
		--限时商品规则介绍图标
		--问号
		_frmNode.childUI["DLCMapInfo_ShopItemIntroduceBtn"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["DLCMapInfo_ShopItemIntroduceBtn"].handle._n,
			x = 0,
			y = 0,
			w = 32, --scale:0.667
			h = 32,
			model = "ICON:action_info",
		})
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(1.0, 0.687, 0.687) ,CCScaleTo:create(1.0, 0.647, 0.647))
		local forever = CCRepeatForever:create(tolua.cast(towAction,"CCActionInterval"))
		_frmNode.childUI["DLCMapInfo_ShopItemIntroduceBtn"].childUI["icon"].handle._n:runAction(forever)
		]]
		
		--刷新按钮的叹号
		--on_check_shopchoujiang_tanhao()
		on_check_shopitem_tanhao()
		--on_check_advview_tanhao()
		
		--添加事件监听：商城信息返回
		hGlobal.event:listen("localEvent_refresh_shopinfo", "__OnReceiveShopItemRet", on_receive_shop_iteminfo_back_event)
		--添加事件监听：商城刷新操作事件返回
		hGlobal.event:listen("localEvent_shop_refresh_result_ret", "__OnReceiveShopRefreshRet", on_receive_shop_refresh_back_event)
		--添加事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenShop_", on_spine_screen_event)
		
		--只有在本分页才会有的timer
		hApi.addTimerForever("__SHOP_TIMER_PAGE_BUYITEM__", hVar.TIMER_MODE.GAMETIME, 1000, on_refresh_shop_buyitem_lefttime_timer)
		
		--标题
		_frmNode.childUI["BillboardTitlel"] = hUI.label:new({
			parent = _parent,
			x = 290 + BILLBOARD_OFFSETX - 210,
			y = -19,
			size = 24,
			font = hVar.FONTC,
			align = "MC",
			width = 500,
			border = 1,
			RGB = {255, 255, 255},
			text = hVar.tab_string["__TEXT_PAGE_SHOP"], --"商城"
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BillboardTitlel"
		
		--标题2（调试显示iap列表数量）
		local iapNum = 0
		if (type(xlLuaEvent_GetIapList()) == "table") then
			iapNum = #xlLuaEvent_GetIapList()
		end
		_frmNode.childUI["BillboardTitlel_2"] = hUI.label:new({
			parent = _parent,
			x = 290 + BILLBOARD_OFFSETX - 210 + 200,
			y = -19,
			size = 24,
			font = hVar.FONTC,
			align = "MC",
			width = 500,
			border = 1,
			RGB = {255, 255, 0},
			text = iapNum,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BillboardTitlel"
		
		--左侧按钮1（装备）
		_frmNode.childUI["BillboardButton1"] = hUI.button:new({
			parent = _parent,
			model = "misc/chariotconfig/tabbutton.png",
			model = "misc/mask.png",
			x = 606 + BILLBOARD_OFFSETX - 210,
			y = -196 - 88 * 0,
			w = 160,
			h = 90,
			label = {x = 0, y = 0, font = hVar.FONTC, align = "MC", border = 1, text = hVar.tab_string["__TEXT_Page_Equip"], size = 36, width = 300, RGB = {192, 192, 192,},}, --"装备"
			--scale = 0.8,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function()
				--print("AAA")
				--关闭本界面
				OnClosePanel()
				
				--由关闭按钮触发的关闭，不能再次打开
				_bCanCreate = false
				
				--打开礼包装备界面
				local bOpenImmediate = true
				hGlobal.event:event("LocalEvent_InitInAppPurchaseGiftFrm_Equip", current_funcCallback, bOpenImmediate)
			end,
		})
		_frmNode.childUI["BillboardButton1"].handle.s:setOpacity(0) --只响应事件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BillboardButton1"
		
		--左侧按钮2（限时商店）
		_frmNode.childUI["BillboardButton2"] = hUI.button:new({
			parent = _parent,
			model = "misc/chariotconfig/tabbutton.png",
			model = "misc/mask.png",
			x = 606 + BILLBOARD_OFFSETX - 210,
			y = -196 - 88 * 1 + 0,
			w = 160,
			h = 90,
			z = 100,
			label = {x = 0, y = 0, font = hVar.FONTC, align = "MC", border = 1, text = hVar.tab_string["__TEXT_PAGE_SHOP"], size = 36, width = 300, RGB = {255, 255, 0,},}, --"商城"
			--scale = 0.8,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function()
				--print("BBB")
			end,
		})
		_frmNode.childUI["BillboardButton2"].handle.s:setOpacity(0) --只响应事件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BillboardButton2"
		
		--左侧按钮3（礼包）
		_frmNode.childUI["BillboardButton3"] = hUI.button:new({
			parent = _parent,
			parent = _parent,
			model = "misc/mask.png",
			x = 606 + BILLBOARD_OFFSETX - 210,
			y = -196 - 88 * 2 + 0,
			w = 160,
			h = 90,
			z = 100,
			label = {x = 0, y = 0, font = hVar.FONTC, align = "MC", border = 1, text = hVar.tab_string["__TEXT_PAGE_GIFT"], size = 36, width = 300, RGB = {192, 192, 192,},}, --"礼包"
			scale = 0.8,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function()
				--print("CCC")
				--关闭本界面
				OnClosePanel()
				
				--由关闭按钮触发的关闭，不能再次打开
				_bCanCreate = false
				
				--打开礼包充值界面
				local bOpenImmediate = true
				hGlobal.event:event("LocalEvent_InitInAppPurchaseGiftFrm_Gift", current_funcCallback, bOpenImmediate)
			end,
		})
		_frmNode.childUI["BillboardButton3"].handle.s:setOpacity(2) --只响应事件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BillboardButton3"
		
		--左侧按钮4（充值）
		_frmNode.childUI["BillboardButton4"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			x = 606 + BILLBOARD_OFFSETX - 210,
			y = -196 - 88 * 3 + 0,
			w = 160,
			h = 90,
			z = 100,
			label = {x = 0, y = 0, font = hVar.FONTC, align = "MC", border = 1, text = hVar.tab_string["__TEXT_PAGE_PURCHASE"], size = 36, width = 300, RGB = {192, 192, 192,},}, --"氪石"
			scale = 0.8,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function()
				--print("DDD")
				--关闭本界面
				OnClosePanel()
				
				--由关闭按钮触发的关闭，不能再次打开
				_bCanCreate = false
				
				--打开充值界面
				local bOpenImmediate = true
				hGlobal.event:event("LocalEvent_InitInAppPurchaseTipFrm", current_funcCallback, bOpenImmediate)
			end,
		})
		_frmNode.childUI["BillboardButton4"].handle.s:setOpacity(2) --只响应事件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BillboardButton4"
		
		--左侧按钮5（宝箱）
		_frmNode.childUI["BillboardButton5"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			x = 606 + BILLBOARD_OFFSETX - 210,
			y = -196 - 88 * 4 - 70,
			w = 160,
			h = 180,
			z = 100,
			--label = {x = 0, y = 0, font = hVar.FONTC, align = "MC", border = 1, text = hVar.tab_string["__TEXT_PAGE_CHEST"], size = 36, width = 300, RGB = {192, 192, 192,},}, --"宝箱"
			--scale = 0.8,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function()
				--print("EEE")
				--关闭本界面
				OnClosePanel()
				
				--由关闭按钮触发的关闭，不能再次打开
				_bCanCreate = false
				
				--触发事件，显示宝箱界面
				local bOpenImmediate = true
				hGlobal.event:event("LocalEvent_Phone_ShowPhoneChestFrame", current_funcCallback, bOpenImmediate)
			end,
		})
		_frmNode.childUI["BillboardButton5"].handle.s:setOpacity(0) --只响应事件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BillboardButton5"
		--宝箱的动画效果
		_frmNode.childUI["BillboardButton5"].childUI["image"] = hUI.image:new({
			parent = _frmNode.childUI["BillboardButton5"].handle._n,
			model = "misc/chest/chest_img_rd_center.png",
			x = 16,
			y = 10,
			w = 120,
			h = 142,
		})
		hApi.AddShader(_frmNode.childUI["BillboardButton5"].childUI["image"].handle.s, "gray") --灰掉图片
		--宝物图标随机动画
		local delayTime1 = math.random(300, 600)
		local delayTime2 = math.random(600, 1200)
		local moveTime = math.random(1000, 2000)
		local moveDy = math.random(5, 10)
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
		_frmNode.childUI["BillboardButton5"].childUI["image"].handle._n:runAction(CCRepeatForever:create(sequence))
		
		--是否要重新查询
		local enableQueryShop = true
		
		--创建大菊花
		_frmNode.childUI["WaitingImg"] = hUI.image:new({
			parent = _parentNode,
			model = "MODEL_EFFECT:waiting",
			x = hVar.SCREEN.w / 2,
			y = -BOARD_HEIGHT / 2,
			scale = 1.0,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "WaitingImg"
		
		--读取存档里的今日商城商品列表数据
		local shopId = SHOP_BUYITEM_SHOPID
		local list = LuaGetTodayNetShopGoods(g_curPlayerName, shopId)
		if list then
			--客户端的时间
			local localTime = os.time()
			
			--服务器的时间
			local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
			
			--转化为北京时间
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
			hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
			local tabNow = os.date("*t", hosttime)
			local yearNow = tabNow.year
			local monthNow = tabNow.month
			local dayNow = tabNow.day
			
			local strStandardRecordTime = list.date
			local hosttime_old = hApi.GetNewDate(strStandardRecordTime) --GMT+8时区
			local deltatime = 3600 * 24 - (hostTime - hosttime_old)
			
			--没超过24小时
			if (deltatime >= 0) then
				--print("没超过24小时，那么不需要重新查询")
				enableQueryShop = false
			end
		end
		--print("enableQueryShop=", enableQueryShop)
		--需要查询每日商品列表
		if enableQueryShop then
			--print("查询每日商品列表")
			SendCmdFunc["open_shop"](shopId)
		else
			--商店是否需要查询（仅每次第一次打开才需要发起查询）
			if (current_shop_query_flag == 0) then
				--print("每次打开查询每日商品列表")
				SendCmdFunc["open_shop"](shopId)
			else
				--模拟触发回调
				--print("模拟触发回调")
				on_receive_shop_iteminfo_back_event(list.shopId, list.rmb_refresh_count, list.goods)
			end
		end
	end
	
	--函数：收到商城每日商品列表结果返回
	on_receive_shop_iteminfo_back_event = function(shopId, rmb_refresh_count, goods)
		local _frm = hGlobal.UI.PhoneNetShopFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--清空右侧
		_removeRightFrmFunc()
		
		--print("on_receive_shop_iteminfo_back_event",shopId, rmb_refresh_count, goods)
		
		--设置存档里的今日商城商品列表数据
		LuaSetTodayNetShopGoods(g_curPlayerName, shopId, rmb_refresh_count, goods)
		
		--刷新按钮的叹号
		on_check_shopitem_tanhao()
		
		--商店是否需要查询（仅每次第一次打开才需要发起查询）
		current_shop_query_flag = 1
		
		--商城动画中禁止刷新
		if current_shop_inaction then
			return
		end
		
		--刷新商品
		for good_idx = 1, #goods, 1 do
			local good = goods[good_idx]
			local id = good.id --tab_shopitem的id
			local itemId = good.itemId --tab_item的id
			local num = good.num --碎片数量
			local score = good.score --购买需要的积分
			local rmb = good.rmb --购买需要的游戏币
			local quota = good.quota --总购买次数
			local saledCount = good.saledCount --已购买次数
			local leftNum = quota - saledCount --剩余购买次数
			
			--依次更新商品界面
			local ctrlI = _frmNode.childUI["DLCMapInfoShopItem_" .. good_idx]
			if ctrlI then
				--获得商品的品质颜色
				local tabI = hVar.tab_item[itemId] or {}
				local tabM = hVar.ITEMLEVEL[tabI.itemLv or 1]
				local NAMERGB = tabM.NAMERGB
				local BORDERMODEL = tabM.BORDERMODEL
				local itemName = hVar.tab_stringI[itemId] and hVar.tab_stringI[itemId][1] or ("未知商品" .. itemId)
				local icon = tabI.icon
				--print(itemId, icon)
				
				--修改商品名称
				--ctrlI.childUI["title"]:setText(itemName)
				
				--修改商品图标
				ctrlI.childUI["itemIconParent"].childUI["itemIcon"]:setmodel(icon)
				
				--修改商品数量
				ctrlI.childUI["itemNum"]:setText("+" .. num)
				
				--如果数量是1、10、50，不显示数组
				if (num == 1) or (num == 10) or (num == 50) then
					ctrlI.childUI["itemNum"]:setText("")
				end
				
				--修改商品碎片图标是否显示
				if (tabI.type == hVar.ITEM_TYPE.SOULSTONE) then --英雄将魂
					if (num == 10) then
						ctrlI.childUI["itemIconParent"].childUI["debrisIcon"].handle._n:setVisible(false)
						ctrlI.childUI["itemIconParent"].childUI["debris10Icon"].handle._n:setVisible(true)
						ctrlI.childUI["itemIconParent"].childUI["debris50Icon"].handle._n:setVisible(false)
					elseif (num == 50) then
						ctrlI.childUI["itemIconParent"].childUI["debrisIcon"].handle._n:setVisible(false)
						ctrlI.childUI["itemIconParent"].childUI["debris10Icon"].handle._n:setVisible(false)
						ctrlI.childUI["itemIconParent"].childUI["debris50Icon"].handle._n:setVisible(true)
					else
						ctrlI.childUI["itemIconParent"].childUI["debrisIcon"].handle._n:setVisible(true)
						ctrlI.childUI["itemIconParent"].childUI["debris10Icon"].handle._n:setVisible(false)
						ctrlI.childUI["itemIconParent"].childUI["debris50Icon"].handle._n:setVisible(false)
					end
				elseif (tabI.type == hVar.ITEM_TYPE.TACTICDEBRIS) then --战术卡碎片
					if (num == 10) then
						ctrlI.childUI["itemIconParent"].childUI["debrisIcon"].handle._n:setVisible(false)
						ctrlI.childUI["itemIconParent"].childUI["debris10Icon"].handle._n:setVisible(true)
						ctrlI.childUI["itemIconParent"].childUI["debris50Icon"].handle._n:setVisible(false)
					elseif (num == 50) then
						ctrlI.childUI["itemIconParent"].childUI["debrisIcon"].handle._n:setVisible(false)
						ctrlI.childUI["itemIconParent"].childUI["debris10Icon"].handle._n:setVisible(false)
						ctrlI.childUI["itemIconParent"].childUI["debris50Icon"].handle._n:setVisible(true)
					else
						ctrlI.childUI["itemIconParent"].childUI["debrisIcon"].handle._n:setVisible(true)
						ctrlI.childUI["itemIconParent"].childUI["debris10Icon"].handle._n:setVisible(false)
						ctrlI.childUI["itemIconParent"].childUI["debris50Icon"].handle._n:setVisible(false)
					end
				elseif (tabI.type == hVar.ITEM_TYPE.CANGBAOTU_NORMAL) then --藏宝图
					ctrlI.childUI["itemIconParent"].childUI["debrisIcon"].handle._n:setVisible(false)
					ctrlI.childUI["itemIconParent"].childUI["debris10Icon"].handle._n:setVisible(false)
					ctrlI.childUI["itemIconParent"].childUI["debris10Icon"].handle._n:setVisible(false)
				elseif (tabI.type == hVar.ITEM_TYPE.CANGBAOTU_HIGH) then --高级藏宝图
					ctrlI.childUI["itemIconParent"].childUI["debrisIcon"].handle._n:setVisible(false)
					ctrlI.childUI["itemIconParent"].childUI["debris10Icon"].handle._n:setVisible(false)
				elseif (tabI.type == hVar.ITEM_TYPE.WEAPONGUNDEBRIS) then --武器枪碎片
					if (num == 10) then
						ctrlI.childUI["itemIconParent"].childUI["debrisIcon"].handle._n:setVisible(false)
						ctrlI.childUI["itemIconParent"].childUI["debris10Icon"].handle._n:setVisible(true)
						ctrlI.childUI["itemIconParent"].childUI["debris50Icon"].handle._n:setVisible(false)
					elseif (num == 50) then
						ctrlI.childUI["itemIconParent"].childUI["debrisIcon"].handle._n:setVisible(false)
						ctrlI.childUI["itemIconParent"].childUI["debris10Icon"].handle._n:setVisible(false)
						ctrlI.childUI["itemIconParent"].childUI["debris50Icon"].handle._n:setVisible(true)
					else
						ctrlI.childUI["itemIconParent"].childUI["debrisIcon"].handle._n:setVisible(true)
						ctrlI.childUI["itemIconParent"].childUI["debris10Icon"].handle._n:setVisible(false)
						ctrlI.childUI["itemIconParent"].childUI["debris50Icon"].handle._n:setVisible(false)
					end
				elseif (tabI.type == hVar.ITEM_TYPE.PETDEBRIS) then --宠物碎片
					if (num == 10) then
						ctrlI.childUI["itemIconParent"].childUI["debrisIcon"].handle._n:setVisible(false)
						ctrlI.childUI["itemIconParent"].childUI["debris10Icon"].handle._n:setVisible(true)
						ctrlI.childUI["itemIconParent"].childUI["debris50Icon"].handle._n:setVisible(false)
					elseif (num == 50) then
						ctrlI.childUI["itemIconParent"].childUI["debrisIcon"].handle._n:setVisible(false)
						ctrlI.childUI["itemIconParent"].childUI["debris10Icon"].handle._n:setVisible(false)
						ctrlI.childUI["itemIconParent"].childUI["debris50Icon"].handle._n:setVisible(true)
					else
						ctrlI.childUI["itemIconParent"].childUI["debrisIcon"].handle._n:setVisible(true)
						ctrlI.childUI["itemIconParent"].childUI["debris10Icon"].handle._n:setVisible(false)
						ctrlI.childUI["itemIconParent"].childUI["debris50Icon"].handle._n:setVisible(false)
					end
				end
				
				--修改游戏币值
				local ctrlI_rmb = _frmNode.childUI["DLCMapInfoShopItem_" .. good_idx .. "rbmBtn"]
				ctrlI_rmb.childUI["gamecoin"]:setText(rmb)
				if (rmb < 100) then --2位数
					ctrlI_rmb.childUI["gamecoin"]:setXY(-6, -2)
				else --3位数
					ctrlI_rmb.childUI["gamecoin"]:setXY(-12, -2)
				end
				
				--修改剩余购买次数
				if (leftNum == 2) then
					ctrlI.childUI["leftcount2"].handle._n:setVisible(true)
					--ctrlI.childUI["leftcount1"].handle._n:setVisible(false)
				elseif (leftNum == 1) then
					ctrlI.childUI["leftcount2"].handle._n:setVisible(false)
					--ctrlI.childUI["leftcount1"].handle._n:setVisible(true)
				elseif (leftNum <= 0) then
					ctrlI.childUI["leftcount2"].handle._n:setVisible(false)
					--ctrlI.childUI["leftcount1"].handle._n:setVisible(false)
				end
				
				
				--是否售罄
				if (leftNum <= 0) then
					--售罄
					--ctrlI.childUI["selloutBG"].handle._n:setVisible(true)
					ctrlI.childUI["sellout"].handle._n:setVisible(true)
					
					ctrlI.childUI["itemIconParent"].childUI["itemIcon"].handle.s:setColor(ccc3(192, 192, 192))
				else
					--可以购买
					--ctrlI.childUI["selloutBG"].handle._n:setVisible(false)
					ctrlI.childUI["sellout"].handle._n:setVisible(false)
					
					ctrlI.childUI["itemIconParent"].childUI["itemIcon"].handle.s:setColor(ccc3(255, 255, 255))
				end
				--[[
				--修改商品图标背景图
				if (("_itemBGX") == sUIName) then
					local oImage = tItemUIHandle[sUIName]
					if oImage then
						local icon = tabI.icon
						oImage:setmodel(BORDERMODEL)
					end
				end
				
				--修改商品图标
				if (("_itemIconX") == sUIName) then
					local oImage = tItemUIHandle[sUIName]
					if oImage then
						local icon = tabI.icon
						oImage:setmodel(icon)
					end
				end
				
				--修改碎片图标
				if (("_itemDebrisIcon") == sUIName) then
					local oImage = tItemUIHandle[sUIName]
					if oImage then
						if (tabI.type == hVar.ITEM_TYPE.SOULSTONE) then --英雄将魂
							oImage:setVisible(true)
						elseif (tabI.type == hVar.ITEM_TYPE.TACTICDEBRIS) then --战术卡碎片
							oImage:setVisible(true)
						elseif (tabI.type == hVar.ITEM_TYPE.CANGBAOTU_NORMAL) then --藏宝图
							oImage:setVisible(false)
						elseif (tabI.type == hVar.ITEM_TYPE.CANGBAOTU_HIGH) then --高级藏宝图
							oImage:setVisible(false)
						end
					end
				end
				]]
			end
		end
		
		--更新今日重刷次数
		local rmbRefreshCount = hVar.tab_shop[shopId].rmbRefreshCount --每天可用金币刷新n次
		local rmbCost = SHOP_REFRESH_RMBCOST --每次刷新消耗游戏币
		local vipLv = LuaGetPlayerVipLv()
		if (vipLv > 0) then --vip有额外刷新次数
			local netshopRefreshCount = hVar.Vip_Conifg.netshopRefreshCount[vipLv] --vip该等级可以免费重刷的次数
			if (netshopRefreshCount > 0) then
				rmbRefreshCount = netshopRefreshCount
				--rmbCost = 0
			end
		end
		local left_count = rmbRefreshCount - rmb_refresh_count --剩余次数
		--_frmNode.childUI["DLCMapInfoShopRefreshBtn"].childUI["label"]:setText(hVar.tab_string["__TEXT_Reflash"] .. "(" .. left_count .. ")") --"刷新 (nn)"
		_frmNode.childUI["DLCMapInfoShopRefreshBtn"].childUI["label"]:setText(left_count) --"刷新 (nn)"
		
		--更新重刷需要的游戏币
		if (rmbCost > 0) then
			_frmNode.childUI["DLCMapInfoShopRefreshBtn"].childUI["gamecoinIcon"].handle._n:setVisible(true)
			_frmNode.childUI["DLCMapInfoShopRefreshBtn"].childUI["gamecoinValue"]:setText(rmbCost)
			_frmNode.childUI["DLCMapInfoShopRefreshBtn"].childUI["free"].handle._n:setVisible(false)
		else
			--重刷免费
			_frmNode.childUI["DLCMapInfoShopRefreshBtn"].childUI["gamecoinIcon"].handle._n:setVisible(false)
			_frmNode.childUI["DLCMapInfoShopRefreshBtn"].childUI["gamecoinValue"]:setText("")
			_frmNode.childUI["DLCMapInfoShopRefreshBtn"].childUI["free"].handle._n:setVisible(true)
		end
		
		--更新刷新按钮
		if (left_count > 0) then
			_frmNode.childUI["DLCMapInfoShopRefreshBtn"].handle.s:setColor(ccc3(255, 255, 255))
			_frmNode.childUI["DLCMapInfoShopRefreshBtn"].childUI["label"].handle.s:setColor(ccc3(255, 255, 255))
		else
			_frmNode.childUI["DLCMapInfoShopRefreshBtn"].handle.s:setColor(ccc3(192, 192, 192))
			_frmNode.childUI["DLCMapInfoShopRefreshBtn"].childUI["label"].handle.s:setColor(ccc3(192, 192, 192))
			
			_frmNode.childUI["DLCMapInfoShopRefreshBtn"].childUI["gamecoinIcon"].handle._n:setVisible(false)
			_frmNode.childUI["DLCMapInfoShopRefreshBtn"].childUI["gamecoinValue"]:setText("")
			_frmNode.childUI["DLCMapInfoShopRefreshBtn"].childUI["free"].handle._n:setVisible(false)
		end
		
		--立即刷新限时商品倒计时
		on_refresh_shop_buyitem_lefttime_timer()
	end
	
	--函数：收到商城刷新结果返回
	on_receive_shop_refresh_back_event = function(result, id, itemId)
		local _frm = hGlobal.UI.PhoneNetShopFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--操作成功
		if (result == 1) then
			--标记商城在刷新中
			current_shop_inaction = true
			
			--创建一个挡操作的控件，动画期间禁止操作
			hApi.safeRemoveT(_frmNode.childUI, "shopRefreshBanBtn")
			_frmNode.childUI["shopRefreshBanBtn"] = hUI.button:new({
				parent = _parentNode,
				x = 0,
				y = 0,
				model = -1,
				w = hVar.SCREEN.w * 2,
				h = hVar.SCREEN.h * 2,
				dragbox = _frm.childUI["dragBox"],
				scaleT = 0.95,
				code = function()
					--print("shopRefreshBanBtn")
				end,
			})
			
			--播放音效
			hApi.PlaySound("eff_pickup")
			
			--刷新商品
			local NUM = SHOP_ITEM_X_NUM * SHOP_ITEM_Y_NUM
			local sendNum = NUM
			local receiveNum = 0
			local ROT_TIME = 0.12 --旋转时间
			for i = 1, NUM, 1 do
				--每个商品翻转
				local ctrlI = _frmNode.childUI["DLCMapInfoShopItem_" .. i]
				if ctrlI then
					local rot1 = CCOrbitCamera:create(ROT_TIME,1,0,0,90,0,0)
					local callback1 = CCCallFunc:create(function()
						--显示卡背面
						ctrlI.childUI["card_back"].handle._n:setVisible(true)
					end)
					local rot2 = CCOrbitCamera:create(ROT_TIME,-1,0,90,90,0,0)
					local callback2 = CCCallFunc:create(function()
						--只需要刷新一次
						if (i == 1) then
							--标记不在动画中
							current_shop_inaction = false
							
							--读取存档里的今日商城商品列表数据
							local shopId = SHOP_BUYITEM_SHOPID
							local list = LuaGetTodayNetShopGoods(g_curPlayerName, shopId)
							--刷新界面
							on_receive_shop_iteminfo_back_event(list.shopId, list.rmb_refresh_count, list.goods)
						end
					end)
					local rot3 = CCOrbitCamera:create(ROT_TIME,1,0,0,90,0,0)
					local callback3 = CCCallFunc:create(function()
						--隐藏卡背面
						ctrlI.childUI["card_back"].handle._n:setVisible(false)
					end)
					local rot4 = CCOrbitCamera:create(ROT_TIME,-1,0,90,90,0,0)
					local callback4 = CCCallFunc:create(function()
						receiveNum = receiveNum + 1
						
						--动画全部完成
						if (receiveNum >= sendNum) then
							--允许操作
							hApi.safeRemoveT(_frmNode.childUI, "shopRefreshBanBtn")
						end
					end)
					local a = CCArray:create()
					a:addObject(rot1)
					a:addObject(callback1)
					a:addObject(rot2)
					a:addObject(callback2)
					a:addObject(rot3)
					a:addObject(callback3)
					a:addObject(rot4)
					a:addObject(callback4)
					local sequence = CCSequence:create(a)
					ctrlI.handle._n:stopAllActions()
					ctrlI.handle._n:runAction(sequence)
				end
			end
		end
	end
	
	--函数：横竖屏切换
	on_spine_screen_event = function()
		local _frm = hGlobal.UI.PhoneNetShopFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--关闭本界面
		OnClosePanel()
		
		--重绘本界面
		hGlobal.UI.InitNetShopNewFrm("reload") --测试
		--触发事件，显示新商店界面
		hGlobal.event:event("LocalEvent_Phone_ShowNetShopNewFrm", current_funcCallback)
	end
	
	--函数：点击购买商城道具逻辑
	on_click_buitem_shopitem = function(itemIdx, good)
		local _frm = hGlobal.UI.PhoneNetShopFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local id = good.id --tab_shopitem的id
		local itemId = good.itemId --tab_item的id
		local num = good.num --碎片数量
		local score = good.score --购买需要的积分
		local rmb = good.rmb --购买需要的游戏币
		local quota = good.quota --总购买次数
		local saledCount = good.saledCount --已购买次数
		local leftNum = quota - saledCount --剩余购买次数
		
		--显示道具的tip
		--检测是否为英雄将魂、兵种卡等道具
		local tabI = hVar.tab_item[itemId] or {}
		local icon = tabI.icon
		local itemType = tabI.type
		local itemLv = tabI.itemLv or hVar.ITEM_QUALITY.WHITE
		local NAMERGB = hVar.ITEMLEVEL[itemLv].NAMERGB
		--local txt = tabI.txt
		local backModel = hVar.ITEMLEVEL[itemLv].BACKMODEL
		
		--显示商品tip
		local title = "" --LuaGetObjectName(itemId, 2)
		local titleColor = ccc3(NAMERGB[1], NAMERGB[2], NAMERGB[3])
		local _frm2 = hApi.ShowGeneralMiniTip(title, titleColor, icon, iconW, iconH, content)
		local _GameCoinTipParent = _frm2.handle._n
		local _GameCoinTipChildUI = _frm2.childUI
		local _offX = hVar.SCREEN.w / 2
		local _offY = hVar.SCREEN.h / 2 + 220
		
		--道具图标
		local TacticIcon = _GameCoinTipChildUI["TacticIcon"]
		TacticIcon:setXY(TacticIcon.data.x + 70, TacticIcon.data.y)
		
		--道具碎片数量
		local itemNumIcon = nil
		if (num == 10) then
			itemNumIcon = "ICON:debris_10"
		elseif (num == 50) then
			itemNumIcon = "ICON:debris_50"
		elseif (num == 88) then
			itemNumIcon = "ICON:debris_88"
		end
		--道具数量
		if itemNumIcon then
			_GameCoinTipChildUI["TacticIconBG"] = hUI.image:new({
				parent = _GameCoinTipParent,
				model = itemNumIcon,
				x = TacticIcon.data.x,
				y = TacticIcon.data.y - 28,
				z = 100,
				scale = 1.0,
			})
		end
		
		--道具显示道具属性
		if (itemType == hVar.ITEM_TYPE.WEAPON) or (itemType == hVar.ITEM_TYPE.BODY) or (itemType == hVar.ITEM_TYPE.MOUNT) or (itemType == hVar.ITEM_TYPE.ORNAMENTS) then --道具
			--道具图标底图
			_GameCoinTipChildUI["TacticIconBG"] = hUI.image:new({
				parent = _GameCoinTipParent,
				model = backModel,
				x = _offX - 76,
				y = _offY - 65,
				z = 0,
				w = 72,
				h = 72,
			})
			
			local reward = tabI.reward or {}
			local countH = 140
			for i = 1, #reward, 1 do
				local key,strExpress = unpack(reward[i])
				local lv = 1
				local quality = 1
				--print(id,strExpress,quality)
				local value = hApi.AnalyzeValueExpr(nil, nil, {["@lv"] = lv,["@quality"] = quality,}, strExpress, 0)
				local strText = hVar.tab_string[hVar.ItemRewardStr[key]]
				
				_GameCoinTipChildUI["lab_attr"..i] = hUI.label:new({
					parent = _GameCoinTipParent,
					x = _offX - 110,
					y = _offY - countH,
					size = 26,
					font = hVar.FONTC,
					align = "LC",
					text = strText,
				})
				
				local valuatext = ""
				if value > 0 then
					valuatext = "+ " .. value
				else
					valuatext = "- " .. math.abs(value)
				end
				if (hVar.ItemRewardStrMode[key] == 1) then
					valuatext = valuatext .. " %"
				end
				_GameCoinTipChildUI["lab_value"..i] = hUI.label:new({
					parent = _GameCoinTipParent,
					x = _offX + 30,
					y = _offY - countH,
					size = 26,
					font = hVar.FONTC,
					align = "LC",
					text = valuatext,
				})
				
				countH = countH + 32
			end
		end
		
		--有剩余次数
		if (leftNum > 0) then
			--购买按钮
			_GameCoinTipChildUI["BtnBuy"] = hUI.button:new({
				parent = _GameCoinTipParent,
				model = "misc/chest/itembtn.png",
				x = _offX,
				y = _offY - 410,
				w = 108,
				h = 63,
				label = {x = 0, y = 2, font = hVar.FONTC, align = "MC", border = 1, text = hVar.tab_string["__TEXT_Buy"], size = 28, width = 300, RGB = {255, 255, 0,},}, --"购买"
				dragbox = _frm2.childUI["dragBox"],
				scaleT = 0.95,
				code = function()
					--如果本地未联网，那么提示没联网
					if (g_cur_net_state == -1) then --未联网
						--local strText = 购买商品需要联网" --language
						local strText = hVar.tab_string["__TEXT_Cant_UseDepletion12_Net"] --language
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
						hApi.ShowSysMsgBox(msgTitle, hVar.tab_string["__TEXT_ScriptsTooOld"])
						
						return
					end
					
					--挡操作
					hUI.NetDisable(3000)
					
					--发送购买每日商品的指令
					local shopId = SHOP_BUYITEM_SHOPID
					--print("发送购买每日商品的指令", shopId, itemIdx)
					SendCmdFunc["buyitem"](shopId, itemIdx)
					
					--播放音效
					hApi.PlaySound("pay_gold")
				end,
			})
			--游戏币图标
			_GameCoinTipChildUI["BtnBuy"].childUI["gamecoinIcon"] = hUI.image:new({
				parent = _GameCoinTipChildUI["BtnBuy"].handle._n,
				model = "misc/skillup/keshi.png",
				x = -32,
				y = 56+1,
				w = 38,
				h = 38,
			})
			
			--游戏币值
			_GameCoinTipChildUI["BtnBuy"].childUI["gamecoin"] = hUI.label:new({
				parent = _GameCoinTipChildUI["BtnBuy"].handle._n,
				x = -6,
				y = 56-1, --数字字体有2像素的偏差
				size = 26,
				align = "LC",
				font = "num",
				border = 0,
				text = rmb,
			})
		end
		
		--[[
		if (itemType == hVar.ITEM_TYPE.SOULSTONE) then --英雄将魂
			--显示英雄将魂tip
			local heroItemId = itemId
			hApi.ShowHeroDerbiesTip(heroItemId)
		elseif (itemType == hVar.ITEM_TYPE.TACTICDEBRIS) then --兵种卡或兵种卡
			local tacticId = tabI.tacticID or 0
			local tabT = hVar.tab_tactics[tacticId] or {}
			local tactiType = tabT.type
			
			if (tactiType == hVar.TACTICS_TYPE.ARMY) then --兵种卡
				--显示PVP兵种tip
				local tacticLv = 1
				hApi.ShowTacticCardTip_PVP(tacticId, tacticLv)
			else --战术卡
				--显示战术技能卡碎片tip
				local rewardType = 6
				local tacticNum = 1
				local tacticLv = 1
				hApi.ShowTacticCardTip(rewardType, tacticId, tacticLv)
			end
		elseif (itemType == hVar.ITEM_TYPE.CANGBAOTU_NORMAL) then --藏宝图
			--显示藏宝图tip
			hApi.ShowCangBaoTuTip()
		elseif (itemType == hVar.ITEM_TYPE.CANGBAOTU_HIGH) then --高级藏宝图
			--显示高级藏宝图tip
			hApi.ShowCangBaoTuHighTip()
		else --一般道具
			--显示道具tip
			local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
			local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
			hGlobal.event:event("LocalEvent_ShowItemTipFram", {{itemId, 1}}, nil, 1, itemtipX, itemtipY, 0)
		end
		]]
		
		--[[
		
		]]
	end
	
	--函数：点击刷新商城道具逻辑
	on_click_refresh_shopitem = function(itemIdx)
		local _frm = hGlobal.UI.PhoneNetShopFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--如果本地未联网，那么提示没联网
		if (g_cur_net_state == -1) then --未联网
			--local strText = 购买商品需要联网" --language
			local strText = hVar.tab_string["__TEXT_Cant_UseDepletion12_Net"] --language
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
			hApi.ShowSysMsgBox(msgTitle, hVar.tab_string["__TEXT_ScriptsTooOld"])
			
			return
		end
		
		--检测今日刷新商店次数是否用光
		local leftRefreshCount = 0
		local shopId = SHOP_BUYITEM_SHOPID
		local rmbCost = SHOP_REFRESH_RMBCOST --每次刷新消耗游戏币
		local list = LuaGetTodayNetShopGoods(g_curPlayerName, shopId)
		if list then
			--刷新今日重刷次数
			local rmbRefreshCount = hVar.tab_shop[shopId].rmbRefreshCount --每天可用金币刷新n次
			local vipLv = LuaGetPlayerVipLv()
			if (vipLv > 0) then --vip有额外刷新次数
				local netshopRefreshCount = hVar.Vip_Conifg.netshopRefreshCount[vipLv] --vip该等级可以免费重刷的次数
				if (netshopRefreshCount > 0) then
					rmbRefreshCount = netshopRefreshCount
					--rmbCost = 0
				end
			end
			
			leftRefreshCount = rmbRefreshCount - list.rmb_refresh_count --剩余刷新商店次数
		end
		if (leftRefreshCount <= 0) then
			--local strText = 今日刷新次数已用完！" --language
			local strText = hVar.tab_string["__TEXT_TodayRefreshCountUsedUp"] --language
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
		--弹框
		local onclickevent = nil
		local MsgSelections = nil
		MsgSelections = {
			style = "mini",
			select = 0,
			ok = function()
				onclickevent()
			end,
			cancel = function()
				--
			end,
			--cancelFun = cancelCallback, --点否的回调函数
			--textOk = "确定", --language
			textOk = hVar.tab_string["Exit_Ack"], --language
			--textCancel = "取消", --language
			textCancel = hVar.tab_string["__TEXT_Cancel"], --language
			userflag = 0, --用户的标记
		}
		local showTitle = hVar.tab_string["__TEXT_Refresh_Item_Consume"] --"是否消耗20游戏币立即刷新商品列表？"
		if (rmbCost == 0) then
			showTitle = hVar.tab_string["__TEXT_Refresh_Item_Free"] --"是否立即刷新商品列表？"
		end
		local msgBox = hGlobal.UI.MsgBox(showTitle, MsgSelections)
		msgBox:active()
		msgBox:show(1,"fade",{time=0.08})
		
		--点击事件
		onclickevent = function()
			--挡操作
			hUI.NetDisable(3000)
			
			--发送刷新每日商品的指令
			--print("发送刷新每日商品的指令", shopId)
			SendCmdFunc["refresh_shop"](shopId)
		end
	end
	
	--函数：刷新限时商城叹号
	on_check_shopitem_tanhao = function()
		local _frm = hGlobal.UI.PhoneNetShopFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--检测是否到第二天刷新了商城出售的道具
		local enableQueryShop = true
		
		--读取存档里的今日商城商品列表数据
		local shopId = SHOP_BUYITEM_SHOPID
		local list = LuaGetTodayNetShopGoods(g_curPlayerName, shopId)
		
		if list then
			--客户端的时间
			local localTime = os.time()
			
			--服务器的时间
			local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
			
			--转化为北京时间
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
			hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
			local tabNow = os.date("*t", hosttime)
			local yearNow = tabNow.year
			local monthNow = tabNow.month
			local dayNow = tabNow.day
			
			local strStandardRecordTime = list.date
			local hosttime_old = hApi.GetNewDate(strStandardRecordTime) --GMT+8时区
			local deltatime = 3600 * 24 - (hostTime - hosttime_old)
			
			--没超过24小时
			if (deltatime >= 0) then
				--print("没超过24小时，那么不需要重新查询")
				enableQueryShop = false
			end
		end
		
		local oBtn = _frm.childUI["PageBtn2"]
		if oBtn then
			if oBtn.childUI["NoteJianTou"] then
				oBtn.childUI["NoteJianTou"].handle._n:setVisible(enableQueryShop)
			end
		end
	end
	
	--函数: 动态加载资源
	__DynamicAddRes = function()
		local _frm = hGlobal.UI.PhoneNetShopFrm_New
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--加载资源
		--动态加载宝物背景图
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/chest/chest_img_bg2.png")
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/chest/chest_img_bg2.png")
			print("加载宝物背景大图2！")
		end
		--print(tostring(texture))
		local tSize = texture:getContentSize()
		local pSprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
		pSprite:setPosition(-tSize.width/2, -tSize.height/2)
		pSprite:setAnchorPoint(ccp(0.5, 0.5))
		--pSprite:setScaleX((hVar.SCREEN.w - iPhoneX_WIDTH * 2) / tSize.width)
		--pSprite:setScaleY(hVar.SCREEN.h / tSize.height)
		_childUI["panel_bg"].data.pSprite = pSprite
		_childUI["panel_bg"].handle._n:addChild(pSprite)
	end
	
	--函数: 动态删除资源
	__DynamicRemoveRes = function()
		local _frm = hGlobal.UI.PhoneNetShopFrm_New
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--删除资源
		--删除竞技场背景图
		_childUI["panel_bg"].handle._n:removeChild(_childUI["panel_bg"].data.pSprite, true)
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/chest/chest_img_bg2.png")
		if texture then
			CCTextureCache:sharedTextureCache():removeTexture(texture)
			print("清空宝物背景大图2！")
		end
	end
	
	--函数：关闭本界面
	OnClosePanel = function()
		--触发事件：刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
		hGlobal.event:event("LocalEvent_RefreshMedalStateUI")
		
		--不显示任务操作面板
		hGlobal.UI.PhoneNetShopFrm_New:show(0)
		
		--商店是否需要查询（仅每次第一次打开才需要发起查询）
		current_shop_query_flag = 0
		
		--关闭界面后不需要监听的事件
		--取消监听：收到网络宝箱数量的事件
		--hGlobal.event:listen("LocalEvent_getNetChestNum", "__ItemGetChestNum_Frm", nil)
		
		--清空切换分页之后取消的监听事件
		--移除事件监听：收到新商店抽奖信息结果回调
		hGlobal.event:listen("localEvent_ShopChouJiangInfo_Ret", "__OnReceiveShopChouJiangInfo", nil)
		--移除事件监听：使用商城抽奖-神器宝箱抽一次结果返回
		hGlobal.event:listen("localEvent_ShopChouJiangRedChestOnce_Ret", "__OnReceiveShopChouJiangRedChestOnce", nil)
		--移除事件监听：使用商城抽奖-神器宝箱抽十次结果返回
		hGlobal.event:listen("localEvent_ShopChouJiangRedChestTenth_Ret", "__OnReceiveShopChouJiangRedChestTenth", nil)
		--移除事件监听：使用商城抽奖-战术卡包抽一次结果返回
		hGlobal.event:listen("localEvent_ShopChouJiangTacticCardOnce_Ret", "__OnReceiveShopChouJiangTacticCardOnce", nil)
		--移除事件监听：使用商城抽奖-战术卡包抽十次结果返回
		hGlobal.event:listen("localEvent_ShopChouJiangTacticCardTenth_Ret", "__OnReceiveShopChouJiangTacticCardTenth", nil)
		--移除事件监听：商城信息返回
		hGlobal.event:listen("localEvent_refresh_shopinfo", "__OnReceiveShopItemRet", nil)
		--移除事件监听：商城刷新操作事件返回
		hGlobal.event:listen("localEvent_shop_refresh_result_ret", "__OnReceiveShopRefreshRet", nil)
		--移除事件监听：商城今日看广告次数信息结果返回
		hGlobal.event:listen("localEvent_ShopTodayAdvViewInfo_Ret", "__OnReceiveAdvViewCountRet", nil)
		--移除事件监听：商城今日看广告完成事件返回
		hGlobal.event:listen("LocalEvent_AdsOver", "__AdsOverRet", nil)
		--移除事件监听：今日看广告失败事件返回
		hGlobal.event:listen("LocalEvent_AdsFailed", "__AdsFailRet_Shop_", nil)
		--移除事件监听：商城今日看广告领取奖励结果返回
		hGlobal.event:listen("localEvent_ShopTodayAdvViewTakeReward_Ret", "__AdsTakeRewardRet", nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenShop_", nil)
		
		--动态删除宝物背景大图
		__DynamicRemoveRes()
		
		--清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--移除timer
		--hApi.clearTimer("__SHOP_TIMER_PAGE_OPENCHEST__")
		hApi.clearTimer("__SHOP_TIMER_PAGE_BUYITEM__")
		--hApi.clearTimer("__SHOP_TIMER_PAGE_ADVVIEW__")
		
		--清除资源缓存
		--local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
		--cache:removeSpriteFramesFromFile("data/image/ui.plist")
		
		--关闭金币、积分界面
		--hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
		
		--检测临时背包是否显示
		hGlobal.event:event("LocalEvent_setGiftBtnState")
		
		--触发事件：关闭了主菜单按钮
		--hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
		
		--允许再次打开
		_bCanCreate = true
	end
	
	--函数：刷新商城限时商品倒计时timer
	on_refresh_shop_buyitem_lefttime_timer = function()
		local _frm = hGlobal.UI.PhoneNetShopFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--客户端的时间
		local localTime = os.time()
		
		--服务器的时间
		local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
		
		--转化为北京时间
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
		hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
		
		local tabNow = os.date("*t", hosttime)
		local yearNow = tabNow.year
		local monthNow = tabNow.month
		local dayNow = tabNow.day
		local hourNow = tabNow.hour
		local minNow = tabNow.min
		local secNow = tabNow.sec
		
		--读取存档的上次刷新的时间
		local shopId = SHOP_BUYITEM_SHOPID
		local list = LuaGetTodayNetShopGoods(g_curPlayerName, shopId)
		if list then
			--客户端上次获取的时间
			local strStandardRecordTime = list.date
			local hosttime_old = hApi.GetNewDate(strStandardRecordTime) --GMT+8时区
			local deltatime = 3600 * 24 - (hostTime - hosttime_old)
			--print(deltatime)
			--超过24小时
			if (deltatime < 0) then
				deltatime = 0
				
				--发送刷新每日商品的指令
				--print("timer 发送刷新每日商品的指令", shopId)
				SendCmdFunc["open_shop"](shopId)
			end
			
			--刷新倒计时
			local hour = math.floor(deltatime / 3600) --小时（总）
			local minute = math.floor((deltatime - hour * 3600) / 60) --分钟
			local second = deltatime - hour * 3600 - minute * 60 --秒
			
			local strHour = tostring(hour) --小时(字符串)
			if (hour < 10) then
				strHour = "0" .. strHour
			end
			local strMinute = tostring(minute) --分钟(字符串)
			if (minute < 10) then
				strMinute = "0" .. strMinute
			end
			local strSecond = tostring(second) --秒(字符串)
			if (second < 10) then
				strSecond = "0" .. strSecond
			end
			
			--print(hour, minute, second)
			local strText = string.format(hVar.tab_string["PVPChongShuaDaoJiShi_Shop"], strHour .. ":" .. strMinute .. ":" .. strSecond)
			_frmNode.childUI["DLCMapInfoShopRefreshTimePrefix"]:setText(strText)
		else
			--if _childUI["PageRuneTimeLabel"] then
			--	_childUI["PageRuneTimeLabel"]:setText("--:--:--")
			--end
		end
	end
end

--监听打开新商店界面事件
hGlobal.event:listen("LocalEvent_Phone_ShowNetShopNewFrm", "__ShowNetShopNewFrm", function(callback, bOpenImmediate)
	hGlobal.UI.InitNetShopNewFrm("reload")
	
	--直接打开
	if bOpenImmediate then
		--触发事件，显示积分、金币界面
		--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
		
		--显示道具界面
		hGlobal.UI.PhoneNetShopFrm_New:show(1)
		hGlobal.UI.PhoneNetShopFrm_New:active()
		
		--[[
		--连接pvp服务器
		if (Pvp_Server:GetState() ~= 1) then --未连接
			Pvp_Server:Connect()
		elseif (not hGlobal.LocalPlayer:getonline()) then --不重复登陆
			Pvp_Server:UserLogin()
		end
		]]
		
		--打开上一次的分页（默认显示第1个分页: 商城抽奖）
		local lastPageIdx = CurrentSelectRecord.pageIdx
		if (lastPageIdx == 0) then
			lastPageIdx = 1
		end
		
		CurrentSelectRecord.pageIdx = 0
		CurrentSelectRecord.contentIdx = 0
		OnClickPageBtn(lastPageIdx)
		
		--存储回调事件
		current_funcCallback = callback
		
		--防止重复调用
		_bCanCreate = false
		
		return
	end
	
	--防止重复调用
	if _bCanCreate then
		_bCanCreate = false
		
		--步骤1: 绘制第一个分页，并将控件设置成初始位置（屏幕外，为步骤二播放动画做准备）
		local actM1 = CCCallFunc:create(function()
			--触发事件，显示积分、金币界面
			--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
			
			--显示道具界面
			hGlobal.UI.PhoneNetShopFrm_New:show(1)
			hGlobal.UI.PhoneNetShopFrm_New:active()
			
			--[[
			--连接pvp服务器
			if (Pvp_Server:GetState() ~= 1) then --未连接
				Pvp_Server:Connect()
			elseif (not hGlobal.LocalPlayer:getonline()) then --不重复登陆
				Pvp_Server:UserLogin()
			end
			]]
			
			--打开上一次的分页（默认显示第1个分页: 商城抽奖）
			local lastPageIdx = CurrentSelectRecord.pageIdx
			if (lastPageIdx == 0) then
				lastPageIdx = 1
			end
			
			CurrentSelectRecord.pageIdx = 0
			CurrentSelectRecord.contentIdx = 0
			OnClickPageBtn(lastPageIdx)
			
			--存储回调事件
			current_funcCallback = callback
			
			--初始设置坐标
			--主面板设置到左侧屏幕外面
			local _frm = hGlobal.UI.PhoneNetShopFrm_New
			local dx = BOARD_WIDTH
			_frm:setXY(_frm.data.x + dx, _frm.data.y)
		end)
		
		--步骤2: 动画进入控件
		local actM2 = CCCallFunc:create(function()
			--本面板
			local _frm = hGlobal.UI.PhoneNetShopFrm_New
			
			--往左做运动
			local px, py = _frm.data.x, _frm.data.y
			local dx = BOARD_WIDTH
			--local act1 = CCDelayTime:create(0.01)
			local act2 = CCMoveTo:create(0.5, ccp(px - dx, py))
			local act4 = CCCallFunc:create(function()
				--_frm.data.x = 0
				_frm:setXY(px - dx, py)
			end)
			local a = CCArray:create()
			--a:addObject(act1)
			a:addObject(act2)
			a:addObject(act4)
			local sequence = CCSequence:create(a)
			_frm.handle._n:stopAllActions() --先停掉之前可能的动画
			_frm.handle._n:runAction(sequence)
			
		end)
		
		local aM = CCArray:create()
		aM:addObject(actM1)
		aM:addObject(actM2)
		local sequence = CCSequence:create(aM)
		local _frm = hGlobal.UI.PhoneNetShopFrm_New
		_frm.handle._n:stopAllActions() --先停掉之前可能的动画
		_frm.handle._n:runAction(sequence)
		
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
	end
end)

--监听关闭宝箱界面事件
hGlobal.event:listen("clearPhoneChestFrm", "__CloseLimittimeShopFrm", function()
	if hGlobal.UI.PhoneChargeMoneyFrm_Gift then
		if (hGlobal.UI.PhoneChargeMoneyFrm_Gift.data.show == 1) then
			--关闭本界面
			OnClosePanel()
		end
		
		--允许再次打开
		_bCanCreate = true
	end
end)

--test
--[[
--测试代码
if hGlobal.UI.PhoneNetShopFrm_New then --新商店面板
	hGlobal.UI.PhoneNetShopFrm_New:del()
	hGlobal.UI.PhoneNetShopFrm_New = nil
end
hGlobal.UI.InitNetShopNewFrm("reload") --测试
--触发事件，显示新商店界面
hGlobal.event:event("LocalEvent_Phone_ShowNetShopNewFrm")
]]


