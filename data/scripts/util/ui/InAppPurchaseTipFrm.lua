


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

local PAGE_BTN_LEFT_X = 480 --第一个分页按钮的x偏移
local PAGE_BTN_LEFT_Y = -6 --第一个分页按钮的x偏移
local PAGE_BTN_OFFSET_X = 140 --每个分页按钮的间距

local PRUCHASE_WIDTH = 200 --充值宽度
local PRUCHASE_HEIGHT = 208 --充值高度

local PRUCHASE_OFFSET_X = 0 --充值统一偏移x
local PRUCHASE_OFFSET_Y = 28 --充值统一偏移y
local PRUCHASE_BOARD_HEIGHT = 500 --充值高度

--临时UI管理
local leftRemoveFrmList = {} --左侧控件集
local rightRemoveFrmList = {} --右侧控件集
local _removeLeftFrmFunc = hApi.DoNothing --清空左侧所有的临时控件
local _removeRightFrmFunc = hApi.DoNothing --清空右侧所有的临时控件

--局部函数
local OnClickPageBtn = hApi.DoNothing --点击分页按钮
local RefreshSelectedCardFrame = hApi.DoNothing --更新绘制当前查看的卡牌的信息

--分页1：充值界面
local OnCreateChargeMoneyFrame = hApi.DoNothing --创建充值界面
local OnCreatePayTypeLogo = hApi.DoNothing --绘制充值方式小logo
local on_receive_IapList_event = hApi.DoNothing --收到充值信息列表回调
local on_receive_purchase_event = hApi.DoNothing --收到充值成功或失败的回调
local on_receive_gift_event = hApi.DoNothing --收到首充奖励的回调
local on_update_gift_ui = hApi.DoNothing --刷新首充状态界面
local on_update_vip_tanhao_event = hApi.DoNothing --更新vip按钮叹号状态
local on_spine_screen_event = hApi.DoNothing --横竖屏切换
local OnSelectChargeMoneyButton = hApi.DoNothing --选中某个充值按钮
local refresh_achievement_UI_loop = hApi.DoNothing --刷新充值界面的滚动
local ShowPurchaseTip = hApi.DoNothing --显示某个充值道具的tip
local __DynamicAddRes = hApi.DoNothing --动态加载资源
local __DynamicRemoveRes = hApi.DoNothing --动态删除资源
local OnClosePanel = hApi.DoNothing --关闭本界面

--分页1：充值相关参数
local BILLBOARD_WIDTH = 200 --排行榜宽度
local BILLBOARD_HEIGHT = 180 --排行榜高度
local BILLBOARD_OFFSETX = 210 --排行榜第一个元素距离左侧的x偏移
local BILLBOARD_OFFSETY = -210 --排行榜第一个元素距离左侧的y偏移
local BILLBOARD_DISTANCEX = 10 --排行榜x间距
local BILLBOARD_DISTANCEY = 10 --排行榜y间距
local ACHIEVEMENT_X_NUM = 3 --充值x的数量
local ACHIEVEMENT_Y_NUM = 3 --充值y的数量
local MAX_SPEED = 50 --最大速度

--横屏模式
if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
	BILLBOARD_OFFSETX = 210 + 50
end

--充值初始获得的游戏币表
--local ORINGIN_GAMECOIN_TABLE = {60, 180, 680, 980, 1980, 3880}
local ORINGIN_MONEY_TABLE = {30, 6, 68, 128, 328, 648,} --最后一个是月卡
local ORINGIN_GAMECOIN_TABLE = {300, 60, 680, 1280, 3280, 6480,} --最后一个是月卡
local ORINGIN_REWARD_TABLE = {{7, 300,}, {7, 60,}, {7, 680,}, {7, 1280,}, {7, 3280,}, {7, 6480,},} --最后一个是月卡
local ORINGIN_PRODUCTN_TABLE = {"tier05.yellowstone.aliensmash","tier01.yellowstone.aliensmash","tier10.yellowstone.aliensmash","tier20.yellowstone.aliensmash","tier50.yellowstone.aliensmash","tier60.yellowstone.aliensmash",} --本地假界面用到的充值条目

--可变参数
local current_Iap_max_num = 0 --最大的充值id
local current_focus_achievementEx_idx = 0 --当前显示的充值ex的索引值
--local current_IapListOrigin = nil --充值原始信息表
local current_IapList = {} --充值信息表
local current_GiftList = {} --首充奖励表
local current_deal_idx = 0 --正在交易的充值id
local current_iType = 0 --支付类型(0:默认(苹果) / 1:苹果 / 2:支付宝 / 3:用户选择)
local current_month_card_Info = {} --月卡充值信息表
local current_funcCallback = nil --关闭后的回调事件
local _bCanCreate = true --防止重复创建
--控制参数
local click_pos_x_achievement = 0 --开始按下的坐标x
local click_pos_y_achievement = 0 --开始按下的坐标y
local last_click_pos_y_achievement = 0 --上一次按下的坐标x
local last_click_pos_y_achievement = 0 --上一次按下的坐标y
local draggle_speed_y_achievement = 0 --当前滑动的速度x
local selected_achievementEx_idx = 0 --选中的充值ex索引
local click_scroll_achievement = false --是否在滑动充值中
local b_need_auto_fixing_achievement = false --是否需要自动修正
local friction_achievement = 0 --阻力

local MODEL_DISCOUNT = {0, "misc/discount_01_cn.png", "misc/discount_02_cn.png", "misc/discount_03_cn.png", "misc/discount_04_cn.png", "misc/discount_05_cn.png", "misc/discount_06_cn.png",} --折扣
local MODEL_PURCHANSE = {"UI:MONTHCARD_ICON","UI:Purchase_1","UI:Purchase_3","UI:Purchase_4","UI:Purchase_5","UI:Purchase_6",}
local MODEL_PURCHANSE_SCALE = {1.0, 1.0, 1.0, 1.0, 1.0, 1.0,}

--当前选中的记录
local CurrentSelectRecord = {pageIdx = 0, contentIdx = 0, cardId = 0,} --当前选择的分页、数据项的信息记录



--充值操作面板
hGlobal.UI.InitChargeMoneyFrm = function(mode)
	local tInitEventName = {"LocalEvent_InitInAppPurchaseTipFrm", "__ShowChargeMoneyFrm",}
	if (mode ~= "reload") then
		--return tInitEventName
		return
	end
	
	--删除可能的本界面
	if hGlobal.UI.PhoneChargeMoneyFrm then --充值面板
		hGlobal.UI.PhoneChargeMoneyFrm:del()
		hGlobal.UI.PhoneChargeMoneyFrm = nil
	end
	
	--[[
	--取消监听充值界面通知事件
	hGlobal.event:listen("LocalEvent_InitInAppPurchaseTipFrm", "__ShowChargeMoneyFrm", nil)
	--取消监听关闭宝箱界面事件
	hGlobal.event:listen("clearPhoneChestFrm", "__ClosePurchaseFrm", nil)
	--取消监听允许响应打开充值界面事件
	hGlobal.event:listen("enablePhonePurchaseFrm", "__EnablePurchaseFrm", nil)
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
	
	hApi.clearTimer("__CHARGE_MONEY_UPDATE__")
	
	--创建充值操作面板
	hGlobal.UI.PhoneChargeMoneyFrm = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		z = 500-1,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 2,
		show = 0, --一开始不显示
		--border = 1, --显示frame边框
		--background = "UI:Tactic_Background",
		--border = "UI:TileFrmPVP", --显示frame边框
		border = 1,
		background = -1, --"panel/panel_part_00.png", --"UI:Tactic_Background",
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
	
	local _frm = hGlobal.UI.PhoneChargeMoneyFrm
	local _parent = _frm.handle._n
	
	--左侧裁剪区域
	local _BTC_PageClippingRect = {0, -80+100, BOARD_WIDTH, BOARD_HEIGHT + 100, 0,} -- {x, y, w, h, ???}
	local _BTC_pClipNode = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect, 99, _BTC_PageClippingRect[5])
	
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
	--关闭按钮
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
			--先关闭本界面
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
	
	--每个分页按钮
	--充值
	local tPageIcons = {"UI:ach_king",}
	--local tTexts = {"购买游戏币",} --language
	local tTexts = {"",} --language hVar.tab_string["ios_buy_gamecoin"]
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
			width = 500,
			RGB = {255, 255, 0,},
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
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm
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
		--移除事件监听：充值信息列表回调
		hGlobal.event:listen("LocalEvent_OnIapList_Back", "__IapListBack", nil)
		--移除事件监听：充值成功或失败的回调
		hGlobal.event:listen("LocalEvent_Purchase_Back", "__PurchaseBack", nil)
		--移除事件监听：首充奖励的回调
		hGlobal.event:listen("LocalEvent_SetgiftFrmBtnState", "__GiftBack", nil)
		--移除事件监听：获得VIP等级和领取状态事件
		hGlobal.event:listen("LocalEvent_GetVipState_New", "__PurchaseGetVipStateBack", nil)
		--移除事件监听：获得VIP领取状态事件
		hGlobal.event:listen("LocalEvent_GetVipDailyRewardFlag", "__PurchaseDailyRewardBack", nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__PurchaseSpinScreen", nil)
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：充值
			--创建充值分页
			OnCreateChargeMoneyFrame(pageIndex)
		end
		
		--标记当前选择的分页和页内的第几个
		CurrentSelectRecord.pageIdx = pageIndex
		CurrentSelectRecord.contentIdx = 0
	end
	
	--函数：创建充值界面（第1个分页）
	OnCreateChargeMoneyFrame = function(pageIdx)
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--动态加载宝物背景大图
		__DynamicAddRes()
		
		--初始化参数
		current_Iap_max_num = 0 --最大的充值id
		current_focus_achievementEx_idx = 0 --当前显示的充值ex的索引值
		--current_IapListOrigin = nil
		current_IapList = {} --充值信息表
		current_GiftList = {} --首充奖励表
		current_deal_idx = 0 --正在交易的充值id
		current_iType = 0 --初始化支付类型(1:苹果 / 2:支付宝 / 3:用户选择)
		
		if xlGetIapType then
			current_iType = xlGetIapType() --读取支付类型
			
			--默认是用苹果支付
			if (current_iType == 0) then
				current_iType = 1
			end
		end
		
		--local i = 3
		
		--左侧裁剪区域
		--local _BTC_PageClippingRect = {0, -82, 1000, 408, 0}
		--local _BTC_pClipNode = hApi.CreateClippingNode(_parentNode, _BTC_PageClippingRect, 99, _BTC_PageClippingRect[5])
		
		--左侧充值列表提示上翻页的图片
		_frmNode.childUI["AchievementPageUp"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = PRUCHASE_OFFSET_X + 476,
			y = PRUCHASE_OFFSET_Y - 60-30,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["AchievementPageUp"].handle.s:setRotation(90)
		_frmNode.childUI["AchievementPageUp"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_frmNode.childUI["AchievementPageUp"].handle.s:setVisible(false) --默认不显示左分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "AchievementPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["AchievementPageUp"].handle._n:runAction(forever)
		
		--左侧充值列表提示下翻页的图片
		_frmNode.childUI["AchievementPageDown"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = PRUCHASE_OFFSET_X + 476 + 7, --非对称的翻页图
			y = PRUCHASE_OFFSET_Y - 622-30,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["AchievementPageDown"].handle.s:setRotation(270)
		_frmNode.childUI["AchievementPageDown"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		_frmNode.childUI["AchievementPageDown"].handle.s:setVisible(false) --默认不显示左分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "AchievementPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["AchievementPageDown"].handle._n:runAction(forever)
		
		--[[
		--左侧向上翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["AchievementPageUp_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = PRUCHASE_OFFSET_X + 476,
			y = PRUCHASE_OFFSET_Y - 42-30,
			w = 800,
			h = 72,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (current_Iap_max_num > (ACHIEVEMENT_X_NUM * ACHIEVEMENT_Y_NUM)) then
					--print("向下滚屏", screenY)
					--向下滚屏
					b_need_auto_fixing_achievement = true
					friction_achievement = 0
					draggle_speed_y_achievement = -MAX_SPEED / 2.0 --负速度
				end
			end,
		})
		_frmNode.childUI["AchievementPageUp_Btn"].handle.s:setOpacity(111) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "AchievementPageUp_Btn"
		
		--左侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["AchievementPageDown_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = PRUCHASE_OFFSET_X + 476,
			y = PRUCHASE_OFFSET_Y - 618-30,
			w = 800,
			h = 72,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (current_Iap_max_num > (ACHIEVEMENT_X_NUM * ACHIEVEMENT_Y_NUM)) then
					--print("向上滚屏", screenY)
					--向上滚屏
					b_need_auto_fixing_achievement = true
					friction_achievement = 0
					draggle_speed_y_achievement = MAX_SPEED / 2.0 --正速度
				end
			end,
		})
		_frmNode.childUI["AchievementPageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "AchievementPageDown_Btn"
		]]
		
		--左侧用于检测滑动事件的控件
		_frmNode.childUI["AchievementDragPanel"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = BOARD_WIDTH / 2,
			y = -BOARD_HEIGHT / 2 - 10,
			w = BOARD_WIDTH,
			h = BOARD_HEIGHT - 70,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--print("codeOnTouch", touchX, touchY, sus)
				click_pos_x_achievement = touchX --开始按下的坐标x
				click_pos_y_achievement = touchY --开始按下的坐标y
				last_click_pos_y_achievement = touchX --上一次按下的坐标x
				last_click_pos_y_achievement = touchY --上一次按下的坐标y
				draggle_speed_y_achievement = 0 --当前速度为0
				click_scroll_achievement = true --是否滑动充值
				b_need_auto_fixing_achievement = false --不需要自动修正位置
				friction_achievement = 0 --无阻力
				
				--如果充值数量未铺满一页，那么不需要滑动
				if (current_Iap_max_num <= (ACHIEVEMENT_X_NUM * ACHIEVEMENT_Y_NUM)) then
					click_scroll_achievement = false --不需要滑动充值
				end
				
				--模拟按下事件
				--检测是否点到了某些控件里(关闭按钮)
				local ctrli = _frm.childUI["closeBtn"]
				if ctrli then
					local bcx = ctrli.data.x --中心点x坐标
					local bcy = ctrli.data.y --中心点y坐标
					local bcw, bch = ctrli.data.w, ctrli.data.h
					local blx, bly = bcx - bcw / 2, bcy - bch / 2 --最左上侧坐标
					local brx, bry = blx + bcw, bly + bch --最右下角坐标
					--print(i, lx, rx, ly, ry, touchX, touchY)
					if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
						--print("点击到了哪个DLC地图面板tip的框内" .. i, m)
						--缩小再放大
						local act1 = CCEaseSineIn:create(CCScaleTo:create(0.1, 0.95))
						local act2 = CCEaseSineOut:create(CCScaleTo:create(0.1, 1.0))
						local a = CCArray:create()
						a:addObject(act1)
						a:addObject(act2)
						local sequence = CCSequence:create(a)
						ctrli.handle._n:stopAllActions()
						ctrli.handle._n:runAction(sequence)
						
						return
					end
				end
				
				--检测
				--检测点击到了哪个充值框内，按钮做点响应互动
				local selectedEx_Idx = 0
				for i = 1, #current_IapList, 1 do
					local listI = current_IapList[i] --第i项
					if (listI) then --存在充值信息第i项表
						local ctrli = _frmNode.childUI["AchievementNode" .. i]
						if ctrli then
							local parentX, parentY = ctrli.data.x, ctrli.data.y
							local childI = ctrli.childUI["ConfimBtn"]
							local cx = parentX + childI.data.x --中心点x坐标
							local cy = parentY + childI.data.y --中心点y坐标
							local cw, ch = childI.data.w, childI.data.h
							local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
							local rx, ry = lx + cw, ly + ch --最右下角坐标
							--print(i, lx, rx, ly, ry, touchX, touchY)
							if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
								--selectedEx_Idx = i
								
								--缩小再放大
								local act1 = CCEaseSineIn:create(CCScaleTo:create(0.1, 0.95))
								local act2 = CCEaseSineOut:create(CCScaleTo:create(0.1, 1.0))
								local a = CCArray:create()
								a:addObject(act1)
								a:addObject(act2)
								local sequence = CCSequence:create(a)
								childI.handle._n:stopAllActions()
								childI.handle._n:runAction(sequence)
								
								break
								--print("点击到了哪个充值的框内" .. i)
							end
						end
					end
				end
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
				--处理移动速度y
				draggle_speed_y_achievement = touchY - last_click_pos_y_achievement
				
				if (draggle_speed_y_achievement > MAX_SPEED) then
					draggle_speed_y_achievement = MAX_SPEED
				end
				if (draggle_speed_y_achievement < -MAX_SPEED) then
					draggle_speed_y_achievement = -MAX_SPEED
				end
				
				--print("click_scroll_achievement=", click_scroll_achievement)
				--在滑动过程中才会处理滑动
				if click_scroll_achievement then
					local deltaY = touchY - last_click_pos_y_achievement --与开始按下的位置的偏移值x
					for i = 1, #current_IapList, 1 do
						local listI = current_IapList[i] --第i项
						if (listI) then --存在充值信息第i项表
							local ctrli = _frmNode.childUI["AchievementNode" .. i]
							if ctrli then
								ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
								ctrli.data.x = ctrli.data.x
								ctrli.data.y = ctrli.data.y + deltaY
							end
						end
					end
				end
				
				--存储本次的位置
				last_click_pos_y_achievement = touchX
				last_click_pos_y_achievement = touchY
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_achievement then
					--if (touchX ~= click_pos_x_achievement) or (touchY ~= click_pos_y_achievement) then --不是点击事件
						b_need_auto_fixing_achievement = true
						friction_achievement = 0
					--end
				end
				
				--检测是否点到了某些控件里(关闭按钮)
				local ctrli = _frm.childUI["closeBtn"]
				if ctrli then
					local bcx = ctrli.data.x --中心点x坐标
					local bcy = ctrli.data.y --中心点y坐标
					local bcw, bch = ctrli.data.w, ctrli.data.h
					local blx, bly = bcx - bcw / 2, bcy - bch / 2 --最左上侧坐标
					local brx, bry = blx + bcw, bly + bch --最右下角坐标
					--print(i, lx, rx, ly, ry, touchX, touchY)
					if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
						ctrli.data.code()
						
						return
					end
				end
				
				--检测
				--检测点击到了哪个充值框内
				local selectedEx_Idx = 0
				for i = 1, #current_IapList, 1 do
					local listI = current_IapList[i] --第i项
					if (listI) then --存在充值信息第i项表
						local ctrli = _frmNode.childUI["AchievementNode" .. i]
						if ctrli then
							local parentX, parentY = ctrli.data.x, ctrli.data.y
							local childI = ctrli.childUI["ConfimBtn"]
							local cx = parentX + childI.data.x --中心点x坐标
							local cy = parentY + childI.data.y --中心点y坐标
							local cw, ch = childI.data.w, childI.data.h
							local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
							local rx, ry = lx + cw, ly + ch --最右下角坐标
							--print(i, lx, rx, ly, ry, touchX, touchY)
							if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
								selectedEx_Idx = i
								
								break
								--print("点击到了哪个充值的框内" .. i)
							end
						end
					end
				end
				selected_achievementEx_idx = selectedEx_Idx
				
				--这种情况请注意：在触发滑动操作（充值数量大于一页），并且按下坐标和抬起坐标偏差过大，则认为该操作是滑动，不触发选择卡牌
				if (click_scroll_achievement) and (math.abs(touchY - click_pos_y_achievement) > 60) then
					selected_achievementEx_idx = 0
				end
				--print("selected_achievementEx_idx", selected_achievementEx_idx)
				
				--更新选中了某个充值
				--if (selected_achievementEx_idx > 0) then
				--OnSelectChargeMoneyButton(selected_achievementEx_idx)
				ShowPurchaseTip(selected_achievementEx_idx)
					
					--selected_achievementEx_idx = 0
				--end
				
				--如果没有选中某个充值，再检测是否选中某个充值查看区域内查看tip
				if (selected_achievementEx_idx == 0) then
					local selectTipIdx = 0
					for i = 1, #current_IapList, 1 do
						local listI = current_IapList[i] --第i项
						if (listI) then --存在充值信息第i项表
							local ctrli = _frmNode.childUI["AchievementNode" .. i]
							if ctrli then
								local cx = ctrli.data.x --中心点x坐标
								local cy = ctrli.data.y --中心点y坐标
								local cw, ch = ctrli.data.w, ctrli.data.h
								local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
								local rx, ry = lx + cw, ly + ch --最右下角坐标
								--print(i, lx, rx, ly, ry, touchX, touchY)
								if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
									selectTipIdx = i
									
									break
									--print("点击到了哪个充值tip的框内" .. i)
								end
							end
						end
					end
					
					if (click_scroll_achievement) and (math.abs(touchY - click_pos_y_achievement) > 60) then
						selectTipIdx = 0
					end
					
					if (selectTipIdx > 0) then
						--显示tip
						--print(selectTipIdx)
						ShowPurchaseTip(selectTipIdx)
					end
				end
				
				--标记不用滑动
				click_scroll_achievement = false
			end,
		})
		_frmNode.childUI["AchievementDragPanel"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "AchievementDragPanel"
		
		--[[
		--分界线
		_frmNode.childUI["AchievementSeparateLine"] = hUI.button:new({
			parent = _parentNode,
			model = "UI:panel_part_09",
			x = BOARD_WIDTH/2,
			y = -80,
			dragbox = _frm.childUI["dragBox"],
			w = BOARD_WIDTH+20,
			h = 8,
			scaleT = 0.95,
			code = function()
				print("XXX")
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "AchievementSeparateLine"
		
		--vip按钮
		_frmNode.childUI["AchievementVipBtn"] = hUI.button:new({
			parent = _parentNode,
			model = "UI:vipbtn", --"misc/mask.png"
			x = PRUCHASE_OFFSET_X + 866-40,
			y = PRUCHASE_OFFSET_Y - 80,
			dragbox = _frm.childUI["dragBox"],
			scale = 1.0,
			scaleT = 0.95,
			code = function()
				--显示vip界面
				hGlobal.event:event("localEvent_ShowMyVIPFrm", 0)
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "AchievementVipBtn"
		--vip按钮的叹号
		_frmNode.childUI["AchievementVipBtn"].childUI["PageTanHao"] = hUI.image:new({
			parent = _frmNode.childUI["AchievementVipBtn"].handle._n,
			x = 30,
			y = 20,
			model = "UI:TaskTanHao",
			w = 36,
			h = 36,
		})
		_frmNode.childUI["AchievementVipBtn"].childUI["PageTanHao"].handle._n:setVisible(false) --一开始不显示VIP领取状态的跳动的叹号
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
		_frmNode.childUI["AchievementVipBtn"].childUI["PageTanHao"].handle.s:runAction(CCRepeatForever:create(sequence))
		]]
		
		--创建大菊花
		_frmNode.childUI["WaitingImg"] = hUI.image:new({
			parent = _parentNode,
			model = "MODEL_EFFECT:waiting",
			x = hVar.SCREEN.w / 2,
			y = -BOARD_HEIGHT / 2,
			scale = 1.0,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "WaitingImg"
		
		--更新vip叹号
		on_update_vip_tanhao_event()
		
		--OnRefreshAchievementFrame()
		--添加事件监听：充值信息列表回调
		hGlobal.event:listen("LocalEvent_OnIapList_Back", "__IapListBack", on_receive_IapList_event)
		
		--添加事件监听：充值成功或失败的回调
		hGlobal.event:listen("LocalEvent_Purchase_Back", "__PurchaseBack", on_receive_purchase_event)
		
		--添加事件监听：首充奖励的回调
		hGlobal.event:listen("LocalEvent_SetgiftFrmBtnState", "__GiftBack", on_receive_gift_event)
		
		--添加事件监听：获得VIP等级和领取状态事件
		hGlobal.event:listen("LocalEvent_GetVipState_New", "__PurchaseGetVipStateBack", on_update_vip_tanhao_event)
		
		--添加事件监听：获得VIP领取状态事件
		hGlobal.event:listen("LocalEvent_GetVipDailyRewardFlag", "__PurchaseDailyRewardBack", on_update_vip_tanhao_event)
		
		--添加事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__PurchaseSpinScreen", on_spine_screen_event)
		
		--发起查询，充值信息列表
		--if (current_IapListOrigin == nil) then
		--	current_IapListOrigin = xlLuaEvent_GetIapList()
		--end
		
		if (xlLuaEvent_GetIapList() == nil) or (#xlLuaEvent_GetIapList() == 0) then
			if xlRequestIapList then
				--如果类型是1或者2，那么直接发起查询
				if (current_iType == 1) or (current_iType == 2) then --支付类型(1:苹果 / 2:支付宝 / 3:用户选择)
					xlRequestIapList(current_iType)
					
					--绘制充值方式小logo
					OnCreatePayTypeLogo()
				else --用户选择或者其他异常情况
					--用户选择选哪一种
					local MsgSelections = nil
					MsgSelections = {
						style = "mini",
						select = 0,
						ok = function()
							--print("支付宝")
							current_iType = 2
							xlRequestIapList(current_iType)
							
							--绘制充值方式小logo
							OnCreatePayTypeLogo()
						end,
						cancel = function()
							--print("苹果")
							current_iType = 1
							xlRequestIapList(current_iType)
							
							--绘制充值方式小logo
							OnCreatePayTypeLogo()
						end,
						--cancelFun = cancelCallback, --点否的回调函数
						--textOk = "支付宝", --language
						textOk = hVar.tab_string["ios_payment_alipay"], --language
						--textCancel = "苹果", --language
						textCancel = hVar.tab_string["ios_payment_apple"], --language
						userflag = 0, --用户的标记
					}
					--local showTitle = "请选择支付方式" --language
					local showTitle = hVar.tab_string["ios_payment_select_pay_mode"] --language
					local msgBox = hGlobal.UI.MsgBox(showTitle, MsgSelections)
					msgBox:active()
					msgBox:show(1,"fade",{time=0.08})
				end
			end
			
			--应王总要求，条目数为0时，立即刷新界面
			on_receive_IapList_event({})
		else
			--geyachao: 应王总要求，如果有缓存充值条目就不查询了
			--模拟收到充值信息列表回调
			on_receive_IapList_event(xlLuaEvent_GetIapList())
		end
		
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
			text = hVar.tab_string["__TEXT_PAGE_PURCHASE"], --"氪石"
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
			model = "misc/mask.png",
			x = 606 + BILLBOARD_OFFSETX - 210,
			y = -196 - 88 * 0,
			w = 160,
			h = 90,
			z = 100,
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
			model = "misc/mask.png",
			x = 606 + BILLBOARD_OFFSETX - 210,
			y = -196 - 88 * 1 + 0,
			w = 160,
			h = 90,
			z = 100,
			label = {x = 0, y = 0, font = hVar.FONTC, align = "MC", border = 1, text = hVar.tab_string["__TEXT_PAGE_SHOP"], size = 36, width = 300, RGB = {192, 192, 192,},}, --"商城"
			--scale = 0.8,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function()
				--print("BBB")
				--关闭本界面
				OnClosePanel()
				
				--由关闭按钮触发的关闭，不能再次打开
				_bCanCreate = false
				
				--触发事件，显示限时商店界面
				local bOpenImmediate = true
				hGlobal.event:event("LocalEvent_Phone_ShowNetShopNewFrm", current_funcCallback, bOpenImmediate)
			end,
		})
		_frmNode.childUI["BillboardButton2"].handle.s:setOpacity(0) --只响应事件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BillboardButton2"
		
		--左侧按钮3（礼包）
		_frmNode.childUI["BillboardButton3"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			x = 606 + BILLBOARD_OFFSETX - 210,
			y = -196 - 88 * 2 + 0,
			w = 160,
			h = 90,
			z = 100,
			label = {x = 0, y = 0, font = hVar.FONTC, align = "MC", border = 1, text = hVar.tab_string["__TEXT_PAGE_GIFT"], size = 36, width = 300, RGB = {192, 192, 192,},}, --"礼包"
			--scale = 0.8,
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
		_frmNode.childUI["BillboardButton3"].handle.s:setOpacity(0) --只响应事件，不显示
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
			label = {x = 0, y = 0, font = hVar.FONTC, align = "MC", border = 1, text = hVar.tab_string["__TEXT_PAGE_PURCHASE"], size = 36, width = 300, RGB = {255, 255, 0,},}, --"氪石"
			--scale = 0.8,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function()
				--print("DDD")
			end,
		})
		_frmNode.childUI["BillboardButton4"].handle.s:setOpacity(0) --只响应事件，不显示
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
		
		--发起查询月卡和月卡每日领奖
		SendCmdFunc["query_month_card"]()
		
		--发起查询，首充奖励信息
		SendCmdFunc["gift_state"]("9;100;18;3;1030;1031;1033;1034;1035;1036;1900;1901;1902;")
		
		
		--[[
		--测试 --test
		--模拟触发回调: 充值信息列表回调
		if (IAPServerIP == "192.168.1.30") then --内网
			current_iType = 1
				
			--绘制充值方式小logo
			OnCreatePayTypeLogo()
			
			--模拟触发回调: 充值信息列表回调
			hGlobal.event:event("LocalEvent_OnIapList_Back", {
				[1] = {productId = "tier01.td.xingames.com", productName = "游戏币60", productPriceDesc = "￥6.00", productDesc = "获得充值游戏币60。\n获得500积分。", productPrice = "6", productGameCoin = "60",},
				[2] = {productId = "tier03.td.xingames.com", productName = "游戏币200", productPriceDesc = "￥18.00", productDesc = "获得充值游戏币180，额外赠送游戏币20。\n获得1000积分。", productPrice = "18", productGameCoin = "200",},
				[3] = {productId = "tier10.td.xingames.com", productName = "游戏币800", productPriceDesc = "￥68.00", productDesc = "获得充值游戏币680，额外赠送游戏币120。\n获得3000积分。", productPrice = "68", productGameCoin = "800",},
				[4] = {productId = "tier15.td.xingames.com", productName = "游戏币1200", productPriceDesc = "￥98.00", productDesc = "获得充值游戏币980，额外赠送游戏币220。\n获得4000积分。", productPrice = "98", productGameCoin = "1200",},
				[5] = {productId = "tier30.td.xingames.com", productName = "游戏币2500", productPriceDesc = "￥198.00", productDesc = "获得充值游戏币1980，额外赠送游戏币520。\n获得8000积分。", productPrice = "198", productGameCoin = "2500",},
				[6] = {productId = "388.td.xingames.com", productName = "游戏币5000", productPriceDesc = "￥388.00", productDesc = "获得充值游戏币3880，额外赠送游戏币1120。\n获得16000积分。", productPrice = "399", productGameCoin = "5000",},
				[7] = {productId = "month30.td.xingames.com", productName = "月卡一个月", productPriceDesc = "￥30.00", productDesc = "获得充值游戏币450，额外赠送游戏币175", productPrice = "45", productGameCoin = "525",},
			})
		end
		]]
	end
	
	--函数：收到充值信息列表回调
	on_receive_IapList_event = function(list)
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--先清空上次充值信息的界面相关控件
		_removeRightFrmFunc()
		
		--苹果月卡位置可能不在最后一个，这里进行处理
		if (#list > 0) then
			--初始化实际的充值索引
			for i = 1, #list, 1 do
				local listI = list[i]
				listI.custombuyindex = i
			end
			
			for i = 1, #list, 1 do
				local listI = list[i]
				if (listI.productId == "month30.td.xingames.com") then --月卡(苹果)
					table.remove(list, i)
					table.insert(list, listI)
					break
				end
			end
		end
		
		--筛选出本界面需要展示的充值条目
		local list_new = {}
		for j = 1, #ORINGIN_MONEY_TABLE, 1 do
			for i = 1, #list, 1 do
				local listI = list[i] --第i项
				if (listI) then --存在充值信息第i项表
					local productPrice = tonumber(listI.productPrice) or 0 --产品价格
					
					if (productPrice == ORINGIN_MONEY_TABLE[j]) and (listI.productId ~= "tier01.giftpack.aliensmash") and (listI.productId ~= 10002) then --找到了（6元礼包和充值档位价格一样）
						list_new[#list_new+1] = listI
						--print("list_new", productPrice)
						break
					end
				end
			end
		end
		
		--苹果渠道，特殊处理，如果没刷到条目，就展示假的
		if (current_iType == 1) then --苹果
			if (#list_new == 0) then
				for i = 1, #ORINGIN_REWARD_TABLE, 1 do
					local gamecoin = ORINGIN_REWARD_TABLE[i][2]
					local price = gamecoin / 10
					list_new[i] = {productId = "", productPriceDesc = "¥"..tostring(price), productPrice = price, productGameCoin = gamecoin, custombuyindex = i,}
				end
			end
		end
		
		--存储充值信息表
		--current_IapListOrigin = list
		current_IapList = list_new
		current_Iap_max_num = 0
		
		--[[
		--test
		--打log
		xlLG("IapList", "xlLuaEvent_OnIapList()\n")
		for i = 1, #current_IapList, 1 do
			local listI = current_IapList[i] --第i项
			if (listI) then --存在充值信息第i项表
				xlLG("IapList", "i=" .. i .. "\n")
				for k, v in pairs(listI) do
					xlLG("IapList", "[" .. k .. "]=" .. v .. "\n")
				end
			end
		end
		]]
		
		--依次绘制界面
		local validIdx = 0 --有效的索引
		--战车最多显示6个
		--for i = 1, 6, 1 do
		for i = 1, #current_IapList, 1 do
			local listI = current_IapList[i] --第i项
			if (listI) then --存在充值信息第i项表
				local productId = listI.productId --产品id
				local productName = listI.productName --产品名称
				local productPriceDesc = listI.productPriceDesc --产品价格描述
				local productDesc = listI.productDesc --产品描述
				local productPrice = tonumber(listI.productPrice) or 0 --产品价格
				local productGameCoin = tonumber(listI.productGameCoin) or 0 --获得的总游戏币
				--local originGameCoin = productPrice * 10 --初始游戏币
				local originGameCoin = ORINGIN_GAMECOIN_TABLE[i] or 0 --初始游戏币
				local extraGameCoin = productGameCoin - originGameCoin --额外赠送的游戏币
				
				--print(i, productPrice)
				
				--productId 10101 (月卡:安卓)
				---productId "month30.td.xingames.com" (月卡:苹果)
				--print(i, productId)
				--检测是否月卡
				local isBuyMonthCard = 0
				if (productId == 10101) or (productId == "10101") or (productId == "tier05.yellowstone.aliensmash") then
					isBuyMonthCard = 1
				end
				
				--标记参数
				validIdx = validIdx + 1 --有效的索引加1
				current_Iap_max_num = validIdx --标记最大充值id
				
				local xn = (validIdx % ACHIEVEMENT_X_NUM) --xn
				if (xn == 0) then
					xn = ACHIEVEMENT_X_NUM
				end
				local yn = (validIdx - xn) / ACHIEVEMENT_X_NUM + 1 --yn
				
				local offsetList =
				{
					[1] = {x = -67,y = 52,}, --武器枪宝箱
					[2] = {x = -(BILLBOARD_WIDTH + BILLBOARD_DISTANCEX)-67, y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY)+32,}, --战术宝箱
					[3] = {x = -158-97,y = 53,}, --宠物宝箱
					[4] = {x = -67,y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY) + 14,}, --装备宝箱
					[5] = {x = 52-82,y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY) + 222,}, --装备宝箱
					[6] = {x = -(BILLBOARD_WIDTH + BILLBOARD_DISTANCEX)+52-82,y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY) + 14,}, --装备宝箱
				}
				
				local offsetX = BILLBOARD_OFFSETX + (xn - 1) * (BILLBOARD_WIDTH + BILLBOARD_DISTANCEX)
				local offsetY = BILLBOARD_OFFSETY - (yn - 1) * (BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY)
				
				--充值的底板
				_frmNode.childUI["AchievementNode" .. i] = hUI.button:new({
					parent = _BTC_pClipNode,
					model = "misc/mask.png", --"UI:Purchase_BG",
					--x = PRUCHASE_OFFSET_X + 148 + (xn - 1) * (PRUCHASE_WIDTH + 22),
					--y = PRUCHASE_OFFSET_Y - 200 - (yn - 1) * (PRUCHASE_HEIGHT + 30) + 10-30,
					x = offsetX + offsetList[i].x,
					y = offsetY + offsetList[i].y,
					w = BILLBOARD_WIDTH,
					h = BILLBOARD_HEIGHT,
				})
				--_frmNode.childUI["AchievementNode" .. i].data.productGameCoin = productGameCoin --存储总游戏币
				_frmNode.childUI["AchievementNode" .. i].handle.s:setOpacity(0) --只响应事件，不显示
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "AchievementNode" .. i
				
				--[[
				--充值的遮罩层
				_frmNode.childUI["AchievementNode" .. i].childUI["mask"] = hUI.image:new({
					parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
					model = "misc/gray_mask_16.png", --misc/common_main_select_frame.png",
					x = 0,
					y = 0,
					w = PRUCHASE_WIDTH,
					h = PRUCHASE_HEIGHT,
				})
				_frmNode.childUI["AchievementNode" .. i].childUI["mask"].handle.s:setColor(ccc3(168, 168, 168))
				]]
				
				--碎片数量偏移
				local debrisOffsetList =
				{
					[1] = {x = -4,y = 12,}, --武器枪宝箱
					[2] = {x = -4, y = 12,}, --战术宝箱
					[3] = {x = 14, y = 11,}, --宠物宝箱
					[4] = {x = -4,y = 11,}, --装备宝箱
					[5] = {x = 34,y = 12,}, --装备宝箱
					[6] = {x = 34,y = 11,}, --装备宝箱
				}
				
				--[[
				--充值的金币图标
				--local gold_icon_x = -8 - (#tostring(originGameCoin)) * 8
				--local gold_icon_y = 65
				_frmNode.childUI["AchievementNode" .. i].childUI["gold"] = hUI.image:new({
					parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
					model = "misc/skillup/keshi.png",
					--x = 0 + debrisOffsetList[i].x - 30,
					--y = -86 + debrisOffsetList[i].y,
					x = 0,
					y = 50,
					z = 100,
					scale = 0.6,
				})
				]]
				
				--充值获得的金币数量（原始数量）
				local rewardT = nil
				for j = 1, #ORINGIN_MONEY_TABLE, 1 do
					if (ORINGIN_MONEY_TABLE[j] == productPrice) then --找到了
						rewardT = ORINGIN_REWARD_TABLE[j]
						break
					end
				end
				local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
				_frmNode.childUI["AchievementNode" .. i].childUI["gamecoinsLabel"] = hUI.label:new({
					parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
					--x = 0 + debrisOffsetList[i].x + 00,
					--y = -86 + debrisOffsetList[i].y,
					x = 0,
					y = -20,
					z = 100,
					size = 28,
					font = "num",
					align = "MC",
					width = 300,
					--border = 1,
					text = itemNum, --originGameCoin,
				})
				--_frmNode.childUI["AchievementNode" .. i].childUI["gamecoinsLabel"].handle.s:setColor(ccc3(255, 255, 0))
				
				_frmNode.childUI["AchievementNode" .. i].data.productGameCoin = itemNum --存储总游戏币
				
				--首充双倍角标
				_frmNode.childUI["AchievementNode" .. i].childUI["double"] = hUI.image:new({
					parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
					model = "UI:INAPP_DOUBLE",
					x = -64,
					y = 47,
					scale = 0.8,
				})
				_frmNode.childUI["AchievementNode" .. i].childUI["double"].handle._n:setVisible(false) --默认隐藏
				
				--首充双倍额外赠送的游戏币文字
				_frmNode.childUI["AchievementNode" .. i].childUI["doubleLabel"] = hUI.label:new({
					parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
					x = 0,
					y = -66,
					size = 18,
					font = hVar.FONTC,
					align = "MC",
					width = 500,
					border = 1,
					RGB = {255, 255, 0}, --55}
					text = "",
				})
				
				--[[
				--充值的标题
				_frmNode.childUI["AchievementNode" .. i].childUI["title"] = hUI.label:new({
					parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
					x = 0,
					y = 70, --字体有1像素偏差
					size = 24,
					font = hVar.FONTC,
					align = "MC",
					width = 300,
					border = 1,
					text = (hVar.tab_string["PurchaseLv" .. i] or productName),
				})
				--_frmNode.childUI["AchievementNode" .. i].childUI["title"].handle.s:setColor(ccc3(255, 255, 0))
				]]
				
				--发光的金币底纹
				--local pruchase_icon_x = 0
				--local pruchase_icon_y = -16
				--if (extraGameCoin > 0) then
				--	pruchase_icon_x = 5 - (#tostring(extraGameCoin)) * 14
				--end
				_frmNode.childUI["AchievementNode" .. i].childUI["light"] = hUI.image:new({
					parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
					model = "UI:PurchaseLight",
					x = 0,
					y = 20,
					scale = 2.0,
				})
				--宝物图标随机动画
				local moveTime = 30000
				local act1 = CCRotateBy:create(moveTime/1000, 360)
				local a = CCArray:create()
				local sequence = CCSequence:create(a)
				a:addObject(act1)
				--oItem.handle.s:stopAllActions() --先停掉之前的动作
				_frmNode.childUI["AchievementNode" .. i].childUI["light"].handle._n:runAction(CCRepeatForever:create(act1))
				
				--充值满载金币的商品图（金币造型图）
				_frmNode.childUI["AchievementNode" .. i].childUI["icon"] = hUI.image:new({
					parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
					model = MODEL_PURCHANSE[i],
					x = 0,
					y = 20,
					scale = MODEL_PURCHANSE_SCALE[i],
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
				_frmNode.childUI["AchievementNode" .. i].childUI["icon"].handle._n:runAction(CCRepeatForever:create(sequence))
				
				--[[
				--额外赠送的金币
				if (extraGameCoin > 0) then
					--额外赠送的金币数量（赠送数量）
					_frmNode.childUI["AchievementNode" .. i].childUI["gamecoinsExtraLabel"] = hUI.label:new({
						parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
						x = 16 - (#tostring(extraGameCoin) - 2) * 10,
						y = pruchase_icon_y - 2, --字体有1像素偏差
						size = 18,
						font = "num",
						align = "LC",
						width = 300,
						--border = 1,
						text = "+" .. extraGameCoin,
					})
					--_frmNode.childUI["AchievementNode" .. i].childUI["gamecoinsExtraLabel"].handle.s:setColor(ccc3(255, 255, ))
					
					--额外赠送的金币图标
					_frmNode.childUI["AchievementNode" .. i].childUI["Extragold"] = hUI.image:new({
						parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
						model = "UI:game_coins",
						x = 54 - (#tostring(extraGameCoin) - 2) * 10 + (#tostring(extraGameCoin)) * 12,
						y = pruchase_icon_y - 0,
						scale = 0.58,
					})
				end
				]]
				
				--[[
				--充值的折扣角标图
				local discountMisc = MODEL_DISCOUNT[i]
				if discountMisc and (discountMisc ~= 0) then
					_frmNode.childUI["AchievementNode" .. i].childUI["discount"] = hUI.image:new({
						parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
						model = discountMisc,
						x = -10,
						y = 35,
						scale = 0.55,
					})
				end
				]]
				
				--点充值的按钮
				_frmNode.childUI["AchievementNode" .. i].childUI["ConfimBtn"] = hUI.button:new({ --作为按钮是为了挂载子控件
					parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
					model = "misc/mask.png", --"UI:Purchase_Button", --"UI:button_back", --"UI:ConfimBtn1",
					x = 0 + debrisOffsetList[i].x,
					y = -86 + debrisOffsetList[i].y,
					w = 204,
					h = 52,
				})
				_frmNode.childUI["AchievementNode" .. i].childUI["ConfimBtn"].handle.s:setOpacity(0) --只相应事件，不显示
				--hApi.AddShader(_frmNode.childUI["AchievementNode" .. i].childUI["ConfimBtn"].handle.s, "normal") --正常图片
				
				--充值的金额
				_frmNode.childUI["AchievementNode" .. i].childUI["ConfimBtn"].childUI["money"] = hUI.label:new({
					parent = _frmNode.childUI["AchievementNode" .. i].childUI["ConfimBtn"].handle._n,
					x = 0,
					y = 2, --字体有2像素偏差
					size = 28,
					font = hVar.FONTC,
					align = "MC",
					width = 300,
					border = 1,
					text = productPriceDesc,
				})
				--_frmNode.childUI["AchievementNode" .. i].childUI["sign"].handle.s:setColor(ccc3(255, 255, 0))
				
				if (isBuyMonthCard == 1) then --月卡
					--月卡角标
					_frmNode.childUI["AchievementNode" .. i].childUI["icon"] = hUI.image:new({
						parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
						model = "UI:MONTHCARD_FLAG",
						x = -68,
						y = 68,
						scale = 1.0,
					})
					
					_frmNode.childUI["AchievementNode" .. i].childUI["gamecoinsLabel"]:setText("")
				end
				
				--本条目充值的菊花
				_frmNode.childUI["AchievementNode" .. i].childUI["waiting"] = hUI.image:new({
					parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
					model = "MODEL_EFFECT:waiting",
					x = 0,
					y = pruchase_icon_y,
					w = 64,
					h = 64,
				})
				_frmNode.childUI["AchievementNode" .. i].childUI["waiting"].handle.s:setVisible(false) --默认不显示菊花
				
				--充值的选中边框
				_frmNode.childUI["AchievementNode" .. i].childUI["selectbox"] = hUI.button:new({ --作为按钮是为了挂载子控件
					parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
					model = "UI:TacTicFrame",
					x = 0,
					y = 0,
					w = PRUCHASE_WIDTH + 2,
					h = PRUCHASE_HEIGHT - 50 + 4,
				})
				_frmNode.childUI["AchievementNode" .. i].childUI["selectbox"].handle.s:setOpacity(0)
				_frmNode.childUI["AchievementNode" .. i].childUI["selectbox"].handle._n:setVisible(false) --默认不显示选中框
				
				--local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/purchase_border.png", 0, 0, PRUCHASE_WIDTH + 2, PRUCHASE_HEIGHT - 50 + 4, _frmNode.childUI["AchievementNode" .. i].childUI["selectbox"])
				--s9:setColor(ccc3(244, 244, 244))
			end
		end
		
		--更新左侧选中框
		--隐藏上一次的选中框
		--_frmNode.childUI["AchievementNode" .. last_achieve_idx].childUI["AchievementSelectBox"].handle._n:setVisible(false)
		
		--显示本次的
		--_frmNode.childUI["AchievementNode" .. current_focus_achievementEx_idx].childUI["AchievementSelectBox"].handle._n:setVisible(true)
		
		--更新提示翻页的按钮
		--不显示上翻页提示
		_frmNode.childUI["AchievementPageUp"].handle.s:setVisible(false)
		
		--如果充值未铺满第一页，那么不显示下翻页提示
		if (current_Iap_max_num <= (ACHIEVEMENT_X_NUM * ACHIEVEMENT_Y_NUM)) then
			_frmNode.childUI["AchievementPageDown"].handle.s:setVisible(false)
		else
			_frmNode.childUI["AchievementPageDown"].handle.s:setVisible(true)
		end
		
		--如果充值长度为0，说明没取到成功，可能是未联网，也可能是连接超时
		--print(current_Iap_max_num)
		if (current_Iap_max_num == 0) then
			--充值的底板
			_frmNode.childUI["DisabelConnectLabel"] = hUI.label:new({
				parent = _parentNode,
				size = 26,
				x = PRUCHASE_OFFSET_X + 276,
				y = PRUCHASE_OFFSET_Y - 390 + 6,
				width = 800,
				align = "MC",
				font = hVar.FONTC,
				--text = "连接AppStore失败，请检查您的网络设置。", --language
				text = hVar.tab_string["ios_pruchase_connect"] .. hVar.tab_string["ios_pruchase_pay" .. current_iType] .. hVar.tab_string["ios_pruchase_fail"], --language
				border = 1,
			})
			_frmNode.childUI["DisabelConnectLabel"].handle.s:setColor(ccc3(212, 212, 212))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "DisabelConnectLabel"
			
			local iChannelId = getChannelInfo()
			--print("iChannelId=",iChannelId)
			if (iChannelId == 1) then
				_frmNode.childUI["DisabelConnectLabel"]:setText(hVar.tab_string["ios_pruchase_connect_ios"])
			end
		end
		
		--立即刷新一次首充状态
		on_update_gift_ui()
	end
	
	--函数：收到充值成功或失败的回调
	on_receive_purchase_event = function(nResult)
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		--requestCurrency()
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--如果存在上一次交易的id，那么取消该交易的等待状态
		if (current_deal_idx > 0) then
			--隐藏菊花
			if _frmNode.childUI["AchievementNode" .. current_deal_idx] then
				_frmNode.childUI["AchievementNode" .. current_deal_idx].childUI["waiting"].handle.s:setVisible(false)
				
				--[[
				--正常按钮
				hApi.AddShader(_frmNode.childUI["AchievementNode" .. current_deal_idx].handle.s, "normal") --亮掉图片
				hApi.AddShader(_frmNode.childUI["AchievementNode" .. current_deal_idx].childUI["ConfimBtn"].handle.s, "normal") --亮掉图片
				]]
			end
			
			--标记当前正在交易的id为0
			current_deal_idx = 0
		end
		
		--充值成功
		if (nResult == 1) then
			--弹框
			--"充值成功！"
			hGlobal.UI.MsgBox(hVar.tab_string["recharge_success_short"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			--再次发起查询月卡和月卡每日领奖
			SendCmdFunc["query_month_card"]()
			
			--再次发起查询首充状态
			SendCmdFunc["gift_state"]("9;100;18;3;1030;1031;1033;1034;1035;1036;1900;1901;1902;")
			
			--查询VIP等级和领取状态
			SendCmdFunc["get_VIP_Lv_New"]()
		end
	end
	
	--函数：收到首充奖励的回调
	on_receive_gift_event = function(statelist)
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--第5~10项是首充是否充过的状态（1:已经充值过了 / 其他值:没充值过）
		for i = 5, 10, 1 do
			current_GiftList[i - 4] = statelist[i]
		end
		
		--刷新首充状态界面
		on_update_gift_ui()
	end
	
	--函数：刷新首充状态界面
	on_update_gift_ui = function()
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--[[
		--geyachao:暂时不要首充双倍
		--如果已经绘制充值条目，更新条目中的首充角标
		for i = 1, 6, 1 do
			if _frmNode.childUI["AchievementNode" .. i] then
				if _frmNode.childUI["AchievementNode" .. i].childUI["double"] then
					if (current_GiftList[i] == 1) or (current_GiftList[i] == nil) then --非首充、未获取数据
						_frmNode.childUI["AchievementNode" .. i].childUI["double"].handle._n:setVisible(false)
						_frmNode.childUI["AchievementNode" .. i].childUI["doubleLabel"]:setText("")
					elseif (current_GiftList[i] == 0) then --首充
						local productGameCoin = _frmNode.childUI["AchievementNode" .. i].data.productGameCoin or 0
						_frmNode.childUI["AchievementNode" .. i].childUI["double"].handle._n:setVisible(true)
						if (productGameCoin > 0) then
							_frmNode.childUI["AchievementNode" .. i].childUI["doubleLabel"]:setText(string.format(hVar.tab_string["ios_payment_inapp_double_ganecoin"], productGameCoin))
						else
							_frmNode.childUI["AchievementNode" .. i].childUI["doubleLabel"]:setText("")
						end
					end
				end
			end
		end
		]]
	end
	
	--函数：更新vip按钮叹号状态
	on_update_vip_tanhao_event = function()
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local enableVIPDaliyReward = false
		if (LuaGetPlayerVipLv() > 0) and (LuaGetDailyReward() == 0) then --是vip，没领取奖励
			enableVIPDaliyReward = true
		end
		
		 --设置VIP领取状态的跳动的叹号
		--_frmNode.childUI["AchievementVipBtn"].childUI["PageTanHao"].handle._n:setVisible(enableVIPDaliyReward)
	end
	
	--函数：横竖屏切换
	on_spine_screen_event = function()
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--关闭本界面
		OnClosePanel()
		
		--重绘本界面
		hGlobal.UI.InitChargeMoneyFrm("reload") --测试
		--触发事件，显示充值界面
		hGlobal.event:event("LocalEvent_InitInAppPurchaseTipFrm", current_funcCallback)
	end
	
	--函数：绘制充值方式小logo
	OnCreatePayTypeLogo = function()
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--支付类型(1:苹果 / 2:支付宝 / 3:用户选择)
		if (current_iType == 1) then --苹果
			--苹果的logo
			--_frm.childUI["PageBtn1"].childUI["Text"]:setText(tTexts[1] .. " - " .. hVar.tab_string["ios_payment_apple"])
			--_frm.childUI["PageBtn1"].childUI["Text"]:setText(tTexts[1])
		elseif (current_iType == 2) then --支付宝
			--支付宝的logo
			--_frm.childUI["PageBtn1"].childUI["Text"]:setText(tTexts[1] .. " - " .. hVar.tab_string["ios_payment_alipay"])
		end
	end
	
	--函数：刷新充值界面的滚动
	refresh_achievement_UI_loop = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local SPEED = 50 --速度
		--print(b_need_auto_fixing_achievement)
		
		if b_need_auto_fixing_achievement then
			---第一个充值的数据
			local AchievementBtn1 = _frmNode.childUI["AchievementNode1"]
			local btn1_cx, btn1_cy = 0, 0 --第一个充值中心点位置
			local btn1_ly = 0 --第一个充值最上侧的x坐标
			local delta1_ly = 0 --第一个充值距离上侧边界的距离
			btn1_cx, btn1_cy = AchievementBtn1.data.x, AchievementBtn1.data.y --第一个充值中心点位置
			btn1_ly = btn1_cy + PRUCHASE_HEIGHT / 2 --第一个充值最上侧的x坐标
			delta1_ly = btn1_ly + 58-30 --第一个充值距离上侧边界的距离
			
			--最后一个充值的数据
			local AchievementBtnN = _frmNode.childUI["AchievementNode" .. current_Iap_max_num]
			local btnN_cx, btnN_cy = 0, 0 --最后一个充值中心点位置
			local btnN_ry = 0 --最后一个充值最下侧的x坐标
			local deltNa_ry = 0 --最后一个充值距离下侧边界的距离
			btnN_cx, btnN_cy = AchievementBtnN.data.x, AchievementBtnN.data.y --最后一个充值中心点位置
			btnN_ry = btnN_cy - PRUCHASE_HEIGHT / 2 --最后一个充值最下侧的x坐标
			deltNa_ry = btnN_ry + 504-30 --最后一个充值距离下侧边界的距离
			--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
			
			--print("delta1_ly=" .. delta1_ly, ", deltNa_rx=" .. deltNa_rx)
			--如果第一个充值的头像跑到下边，那么优先将第一个充值头像贴边
			if (delta1_ly < 0) then
				--print("优先将第一个充值头像贴边")
				--需要修正
				--不会选中充值
				selected_achievementEx_idx = 0 --选中的充值索引
				
				--没有惯性
				draggle_speed_y_achievement = 0
				
				local speed = SPEED
				if ((delta1_ly + speed) > 0) then --防止走过
					speed = -delta1_ly
					delta1_ly = 0
				end
				
				--每个按钮向上侧做运动
				for i = 1, #current_IapList, 1 do
					local listI = current_IapList[i] --第i项
					if (listI) then --存在充值信息第i项表
						local ctrli = _frmNode.childUI["AchievementNode" .. i]
						if ctrli then
						--if (ctrli.data.selected == 0) then --只处理未选中的充值卡牌
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
				
				--上滑动翻页不显示，下滑动翻页显示
				_frmNode.childUI["AchievementPageUp"].handle.s:setVisible(false) --上翻页提示
				_frmNode.childUI["AchievementPageDown"].handle.s:setVisible(true) --下翻页提示
			elseif (delta1_ly ~= 0) and (deltNa_ry > 0) then --第一个头像没有贴上侧，并且最后一个头像没有贴下侧，那么再将最后一个充值头像贴边
				--print("将最后一个充值头像贴边")
				--需要修正
				--不会选中充值
				selected_achievementEx_idx = 0 --选中的充值索引
				
				--没有惯性
				draggle_speed_y_achievement = 0
				
				local speed = SPEED
				if ((deltNa_ry - speed) < 0) then --防止走过
					speed = deltNa_ry
					deltNa_ry = 0
				end
				
				--每个按钮向下侧做运动
				for i = 1, #current_IapList, 1 do
					local listI = current_IapList[i] --第i项
					if (listI) then --存在充值信息第i项表
						local ctrli = _frmNode.childUI["AchievementNode" .. i]
						if ctrli then
						--if (ctrli.data.selected == 0) then --只处理未选中的充值卡牌
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
				end
				
				--上滑动翻页显示，下滑动翻页不显示
				_frmNode.childUI["AchievementPageUp"].handle.s:setVisible(true) --上分翻页提示
				_frmNode.childUI["AchievementPageDown"].handle.s:setVisible(false) --下分翻页提示
			elseif (draggle_speed_y_achievement ~= 0) then --沿着当前的速度方向有惯性地运动一会
				--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_y_achievement)
				--不会选中充值
				selected_achievementEx_idx = 0 --选中的充值索引
				--print("    ->   draggle_speed_y_achievement=", draggle_speed_y_achievement)
				
				if (draggle_speed_y_achievement > 0) then --朝上运动
					local speed = (draggle_speed_y_achievement) * 1.0 --系数
					friction_achievement = friction_achievement - 0.5
					draggle_speed_y_achievement = draggle_speed_y_achievement + friction_achievement --衰减（正）
					
					if (draggle_speed_y_achievement < 0) then
						draggle_speed_y_achievement = 0
					end
					
					--最后一个充值的坐标不能跑到最下侧的上边去
					if ((deltNa_ry + speed) > 0) then --防止走过
						speed = -deltNa_ry
						deltNa_ry = 0
						
						--没有惯性
						draggle_speed_y_achievement = 0
					end
					
					--每个按钮向上侧做运动
					for i = 1, #current_IapList, 1 do
						local listI = current_IapList[i] --第i项
						if (listI) then --存在充值信息第i项表
							local ctrli = _frmNode.childUI["AchievementNode" .. i]
							if ctrli then
							--if (ctrli.data.selected == 0) then --只处理未选中的充值卡牌
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
				elseif (draggle_speed_y_achievement < 0) then --朝下运动
					local speed = (draggle_speed_y_achievement) * 1.0 --系数
					friction_achievement = friction_achievement + 0.5
					draggle_speed_y_achievement = draggle_speed_y_achievement + friction_achievement --衰减（负）
					
					if (draggle_speed_y_achievement > 0) then
						draggle_speed_y_achievement = 0
					end
					
					--第一个充值的坐标不能跑到最上侧的下边去
					if ((delta1_ly + speed) < 0) then --防止走过
						speed = -delta1_ly
						delta1_ly = 0
						
						--没有惯性
						draggle_speed_y_achievement = 0
					end
					
					--每个按钮向下侧做运动
					for i = 1, #current_IapList, 1 do
						local listI = current_IapList[i] --第i项
						if (listI) then --存在充值信息第i项表
							local ctrli = _frmNode.childUI["AchievementNode" .. i]
							if ctrli then
							--if (ctrli.data.selected == 0) then --只处理未选中的充值卡牌
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
				end
				
				--上滑动翻页显示，下滑动翻页显示
				if (delta1_ly == 0) then
					_frmNode.childUI["AchievementPageUp"].handle.s:setVisible(false) --上分翻页提示
				else
					_frmNode.childUI["AchievementPageUp"].handle.s:setVisible(true) --上分翻页提示
				end
				if (deltNa_ry == 0) then
					_frmNode.childUI["AchievementPageDown"].handle.s:setVisible(false) --下分翻页提示
				else
					_frmNode.childUI["AchievementPageDown"].handle.s:setVisible(true) --下分翻页提示
				end
			else --停止运动
				b_need_auto_fixing_achievement = false
				friction_achievement = 0
			end
		end
	end
	
	--函数：选中某个充值按钮
	OnSelectChargeMoneyButton = function(idxEx)
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--标记选中哪个充值idx
		local last_achieve_idx = current_focus_achievementEx_idx
		current_focus_achievementEx_idx = idxEx
		
		--显示本次的
		if (current_focus_achievementEx_idx > 0) then
			--如果当前存在正在交易的购买，不能再次购买
			if (current_deal_idx == 0) then
				--标记当前正在交易的id
				current_deal_idx = current_focus_achievementEx_idx
				
				--显示菊花
				_frmNode.childUI["AchievementNode" .. current_focus_achievementEx_idx].childUI["waiting"].handle.s:setVisible(true)
				
				--[[
				--灰掉按钮
				hApi.AddShader(_frmNode.childUI["AchievementNode" .. current_focus_achievementEx_idx].handle.s, "gray") --灰色图片
				hApi.AddShader(_frmNode.childUI["AchievementNode" .. current_focus_achievementEx_idx].childUI["ConfimBtn"].handle.s, "gray") --灰色图片
				]]
				
				--弹出购买游戏币的窗口
				if xlIapBuyItem then
					--支付类型(1:苹果 / 2:支付宝 / 3:用户选择)
					if (current_iType == 1) then --苹果
						local listI = current_IapList[idxEx] --第i项
						--local id = current_focus_achievementEx_idx - 1
						local id = listI.custombuyindex - 1
						local productId = listI.productId
						
						--服务器没取到product，不能充值
						if (productId == "") then
							--[[
							--local strText = "内购条目准备中" --language
							local strText = hVar.tab_string["ios_pruchase_connect_ios"] --language
							hUI.floatNumber:new({
								x = hVar.SCREEN.w / 2,
								y = hVar.SCREEN.h / 2,
								align = "MC",
								text = "",
								lifetime = 2000,
								fadeout = -550,
								moveY = 32,
							}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
							
							--模拟触发事件: 充值失败事件回调
							hGlobal.event:event("LocalEvent_Purchase_Back", 0)
							
							return
							]]
							
							--挡操作
							hUI.NetDisable(5000, "purchase")
							
							--直接按key买商品
							local sItemName = ORINGIN_PRODUCTN_TABLE[idxEx]
							xlIapBuyIosItem(sItemName)
						else
							--挡操作
							hUI.NetDisable(5000, "purchase")
							
							xlIapBuyItem(current_iType, id)
						end
					elseif (current_iType == 2) then --支付宝
						local listI = current_IapList[idxEx] --第i项
						if (listI) then --存在充值信息第i项表
							local iChannelId = getChannelInfo()
							if (iChannelId == 100) or (iChannelId == 106) or (iChannelId == 1002) then --taptap
							--if (iChannelId == 10002) then --taptap
								--支付宝支付
								local onclickevent_zfb = function()
									print("支付宝")
									
									--挡操作
									hUI.NetDisable(5000, "purchase")
									
									local productId = listI.productId --产品id
									xlIapBuyItem(current_iType, productId)
								end
								
								--微信支付
								local onclickevent_wx = function()
									print("微信")
									
									--检测程序版本号是否支持微信支付
									if (xlGetChannelVersion() >= 2023010101) then
										--挡操作
										hUI.NetDisable(5000, "purchase")
										
										local productId = listI.productId --产品id
										xlIapBuyItem(4, productId)
									else
										--弹框，版本太旧
										local strText = hVar.tab_string["__TEXT_AppVersionTooOld_Download"] --"您的应用程序版本太旧，请从商店更新至最新版本！"
										hGlobal.UI.MsgBox(strText,{
											font = hVar.FONTC,
											ok = function()
											end,
										})
										
										--取消标记当前正在交易的id
										current_deal_idx = 0
										--隐藏菊花
										_frmNode.childUI["AchievementNode" .. current_focus_achievementEx_idx].childUI["waiting"].handle.s:setVisible(false)
									end
								end
								
								local MsgSelections = nil
								MsgSelections = {
									style = "mini",
									select = 0,
									ok = onclickevent_zfb,
									cancel = onclickevent_wx,
									--cancelFun = cancelCallback, --点否的回调函数
									--textOk = "领取",
									textOk = hVar.tab_string["__TEXT_IAPPAY_ALI"], --language
									--textCancel = "确定", --language
									textCancel = hVar.tab_string["__TEXT_IAPPAY_WEIXIN"], --language
									userflag = 0, --用户的标记
								}
								local msgBox = hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_IAPPAY_SELECT"], MsgSelections) --"请选择支付方式"
								msgBox:active()
								msgBox:show(1,"fade",{time=0.08})
							else
								--挡操作
								hUI.NetDisable(5000, "purchase")
								
								local productId = listI.productId --产品id
								xlIapBuyItem(current_iType, productId)
							end
						end
					end
				end
				
				--测试 --test
				--[[
				if (IAPServerIP == "192.168.1.30") then --内网
					--模拟触发回调: 充值成功
					hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Topup_Success_Tip"],{
						font = hVar.FONTC,
						ok = function()
						end,
					})
					hGlobal.event:event("LocalEvent_Purchase_Back", 1)
				end
				]]
			else
				--冒字显示正在交易中
				--local strText = "上一个交易正在处理中！" --language
				local strText = hVar.tab_string["ios_deal_ing"] --language
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 2000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
			end
		end
	end
	
	--函数：显示某个充值道具的tip
	ShowPurchaseTip = function(idxEx)
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local listI = current_IapList[idxEx] --第i项
		if (listI) then --存在充值信息第i项表
			local productId = listI.productId --产品id
			local productName = listI.productName --产品名称
			local productPriceDesc = listI.productPriceDesc --产品价格描述
			local productDesc = listI.productDesc --产品描述
			local productPrice = tonumber(listI.productPrice) --产品价格
			local productGameCoin = tonumber(listI.productGameCoin) --获得的游戏币
			--local originGameCoin = productPrice * 10 --初始游戏币
			local originGameCoin = ORINGIN_GAMECOIN_TABLE[idxEx] --初始游戏币
			local extraGameCoin = productGameCoin - originGameCoin --额外赠送的游戏币
			
			--检测是否月卡
			local isBuyMonthCard = 0
			if (productId == 10101) or (productId == "10101") or (productId == "tier05.yellowstone.aliensmash") then
				isBuyMonthCard = 1
			end
			
			--绘制tip
			--先清除上一次的商品说明面板
			if hGlobal.UI.PurchaseInfoFram then
				hGlobal.UI.PurchaseInfoFram:del()
				hGlobal.UI.PurchaseInfoFram = nil
			end
			
			--[[
			--月卡
			if (isBuyMonthCard == 1) then --月卡
				--创建月卡介绍tip
				local monthcardTip = hUI.uiTip:new()
				monthcardTip:AddIcon("UI:MONTHCARD_ICON")
				monthcardTip:AddTitle(hVar.tab_string["__TEXT_MONTHCARD_title"], ccc3(255, 192, 0)) --"月卡福利"
				monthcardTip:AddContent(hVar.tab_string["__TEXT_MONTHCARD_info1"])
				monthcardTip:AddContent(hVar.tab_string["__TEXT_MONTHCARD_info2"])
				monthcardTip:AddContent(hVar.tab_string["__TEXT_MONTHCARD_info3"])
				monthcardTip:AddContent(hVar.tab_string["__TEXT_MONTHCARD_info4"])
				monthcardTip:SetTitleCentered()
				
				return
			end
			]]
			
			--显示选中框
			_frmNode.childUI["AchievementNode" .. idxEx].childUI["selectbox"].handle._n:setVisible(true)
			
			--先清除上一次的游戏币说明面板
			if hGlobal.UI.PurchaseInfoFram then
				hGlobal.UI.PurchaseInfoFram:del()
				hGlobal.UI.PurchaseInfoFram = nil
			end
			if hGlobal.UI.GameCoinTipFrame then
				hGlobal.UI.GameCoinTipFrame:del()
				hGlobal.UI.GameCoinTipFrame = nil
			end
			
			--创建游戏币说明tip
			hGlobal.UI.PurchaseInfoFram = hUI.frame:new({
				x = 0,
				y = 0,
				w = hVar.SCREEN.w,
				h = hVar.SCREEN.h,
				z = hZorder.CommentFrm - 2,
				show = 1,
				--dragable = 2,
				dragable = 2,
				--buttononly = 1,
				autoactive = 0,
				--background = "UI:PANEL_INFO_MINI",
				failcall = 1, --出按钮区域抬起也会响应事件
				background = -1, --无底图
				border = 0, --无边框
				
				--点击事件（有可能在控件外部点击）
				codeOnDragEx = function(screenX, screenY, touchMode)
					--print("codeOnDragEx", screenX, screenY, touchMode)
					if (touchMode == 0) then --按下
						--
					elseif (touchMode == 1) then --滑动
						--
					elseif (touchMode == 2) then --抬起
						--[[
						--清除技能说明面板
						hGlobal.UI.PurchaseInfoFram:del()
						hGlobal.UI.PurchaseInfoFram = nil
						--print("点击事件（有可能在控件外部点击）")
						]]
					end
				end,
			})
			hGlobal.UI.PurchaseInfoFram:active()
			
			local _frm2 = hGlobal.UI.PurchaseInfoFram
			local _GameCoinTipParent = hGlobal.UI.PurchaseInfoFram.handle._n
			local _GameCoinTipChildUI = hGlobal.UI.PurchaseInfoFram.childUI
			
			local _offX = hVar.SCREEN.w / 2
			local _offY = hVar.SCREEN.h / 2 + 220
			
			--关闭按钮响应区域
			_GameCoinTipChildUI["closeBtn"] = hUI.button:new({
				parent = _GameCoinTipParent,
				model = -1,
				--model = "misc/mask.png",
				dragbox = _frm2.childUI["dragBox"],
				align = "MC",
				x = hVar.SCREEN.w/2,
				y = hVar.SCREEN.h/2,
				w = hVar.SCREEN.w,
				h = hVar.SCREEN.h,
				code = function()
					--清除将魂抽卡说明面板
					if hGlobal.UI.PurchaseInfoFram then
						hGlobal.UI.PurchaseInfoFram:del()
						hGlobal.UI.PurchaseInfoFram = nil
					end
				end,
			})
			
			local img9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/itemtip.png", _offX, _offY - 235, 680, 480, hGlobal.UI.PurchaseInfoFram)
			
			_GameCoinTipChildUI["BtnMask"] = hUI.button:new({
				parent = _GameCoinTipParent,
				model = "misc/button_null.png",
				x = _offX,
				y = _offY - 235,
				w = 680,
				h = 480,
				dragbox = _frm2.childUI["dragBox"],
				scaleT = 0.95,
				code = function()
				end
			})
			
			--底板
			--创建游戏币图标
			_GameCoinTipChildUI["TacticIcon"] = hUI.image:new({
				parent = _GameCoinTipParent,
				model = MODEL_PURCHANSE[idxEx],
				x = _offX - 76 - 8,
				y = _offY - 65-10,
				z = 1,
				w = 72,
				h = 72,
			})
			
			--创建游戏币名称
			local title = hVar.tab_string["__TEXT_PAGE_PURCHASE"] .. tostring(originGameCoin)
			local titleColor = ccc3(255, 255, 0)
			--月卡的标题
			if (isBuyMonthCard == 1) then --月卡
				title = hVar.tab_string["__TEXT_MONTHCARD"]
			end
			_GameCoinTipChildUI["TacticName"] = hUI.label:new({
				parent = _GameCoinTipParent,
				size = 30,
				x = _offX + 40,
				y = _offY - 60 - 8 - 10,
				width = 300,
				align = "MC",
				font = hVar.FONTC,
				text = title,
				border = 1,
			})
			_GameCoinTipChildUI["TacticName"].handle.s:setColor(titleColor)
			
			--[[
			--创建通用tip
			--local title = hVar.tab_string["__TEXT_PAGE_PURCHASE"] .. tostring(productGameCoin)
			local title = hVar.tab_string["__TEXT_PAGE_PURCHASE"] .. tostring(originGameCoin)
			local titleColor = ccc3(255, 255, 0)
			local icon = "UI:Purchase_" .. idxEx
			local iconW = 64
			local iconH = 64
			--local content = string.format(hVar.tab_string["__TEXT_PURCHASE_DESC"], productGameCoin)
			local content = string.format(hVar.tab_string["__TEXT_PURCHASE_DESC"], originGameCoin)
			local _frm2 = hApi.ShowGeneralMiniTip(title, titleColor, icon, iconW, iconH, content)
			local _GameCoinTipParent = _frm2.handle._n
			local _GameCoinTipChildUI = _frm2.childUI
			local _offX = hVar.SCREEN.w / 2
			local _offY = hVar.SCREEN.h / 2 + 220
			]]
			
			local reward = {ORINGIN_REWARD_TABLE[idxEx],}
			local img9Width = 480
			if (#reward >= 5) then
				img9Width = 600
			end
			if (isBuyMonthCard == 1) then --月卡
				img9Width = 500
			end
			local img9 = hApi.CCScale9SpriteCreate("data/image/misc/treasure/medal_content2.png", _offX, _offY - 235, img9Width, 150, hGlobal.UI.PurchaseInfoFram)
			
			local ICONW = 120
			local ICONH = 120
			local ICONDX = 120
			local ICONX = -(#reward) / 2 * ICONDX + ICONDX / 2
			
			--依次绘制奖励
			for i = 1, #reward, 1 do
				local rewardT = reward[i]
				
				--显示各种类型的奖励的tip
				--print(i, rewardT)
				local rewardType = rewardT[1]
				local itemId =  rewardT[2]
				--print(rewardType)
				local title = ""
				local icon = ""
				local titleColor = ccc3(255, 255, 255)
				
				local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
				
				--充值的底板
				_GameCoinTipChildUI["rewardBtn_" .. i] = hUI.button:new({
					parent = _GameCoinTipParent,
					model = "misc/mask.png", --"UI:Purchase_BG",
					--x = PRUCHASE_OFFSET_X + 148 + (xn - 1) * (PRUCHASE_WIDTH + 22),
					--y = PRUCHASE_OFFSET_Y - 200 - (yn - 1) * (PRUCHASE_HEIGHT + 30) + 10-30,
					x = _offX + ICONX +  (i - 1) * ICONDX,
					y = _offY - 230,
					w = ICONW,
					h = ICONH,
					dragbox = _frm2.childUI["dragBox"],
					scaleT = 0.95,
					code = function()
						--显示各种类型的奖励的tip
						hApi.ShowRewardTip(rewardT)
					end,
				})
				_GameCoinTipChildUI["rewardBtn_" .. i].handle.s:setOpacity(0) --只响应事件，不显示
				
				--奖励道具
				local scale = 2.1
				_GameCoinTipChildUI["rewardBtn_" .. i].childUI["icon"] = hUI.button:new({ --作为按钮只是为了挂载子控件
					parent = _GameCoinTipChildUI["rewardBtn_" .. i].handle._n,
					model = tmpModel, --"UI:Purchase_" .. i,
					x = 0,
					y = 0,
					w = itemWidth * scale,
					h = itemHeight * scale,
				})
				
				--绘制奖励图标的子控件
				if sub_tmpModel then
					--geyachao: 碎片图标不显示了
					if (sub_tmpModel ~= "UI:SoulStoneFlag") then --不是碎片图标
						_GameCoinTipChildUI["rewardBtn_" .. i].childUI["icon"].childUI["subIcon"] = hUI.image:new({
							parent = _GameCoinTipChildUI["rewardBtn_" .. i].childUI["icon"].handle._n,
							model = sub_tmpModel,
							x = sub_pos_x * scale,
							y = sub_pos_y * scale,
							w = sub_pos_w * scale,
							h = sub_pos_h * scale,
						})
					end
				end
				
				--奖励道具数量
				_GameCoinTipChildUI["rewardBtn_" .. i].childUI["gamecoinsLabel"] = hUI.label:new({
					parent = _GameCoinTipChildUI["rewardBtn_" .. i].handle._n,
					--x = 0 + debrisOffsetList[i].x + 00,
					--y = -86 + debrisOffsetList[i].y,
					x = 0,
					y = -40,
					z = 100,
					size = 28,
					font = "numWhite",
					align = "MC",
					width = 300,
					--border = 1,
					text = "+" .. itemNum, --originGameCoin,
				})
			end
			
			--月卡的标题
			if (isBuyMonthCard == 1) then --月卡
				--删除图标奖励
				for i = 1, #reward, 1 do
					_GameCoinTipChildUI["rewardBtn_" .. i]:del()
					_GameCoinTipChildUI["rewardBtn_" .. i] = nil
				end
				
				--显示文字说明1
				_GameCoinTipChildUI["rewardLabel_1"] = hUI.label:new({
					parent = _GameCoinTipParent,
					x = _offX - 220,
					y = _offY - 232 + 42,
					width = 500,
					align = "LC",
					font = hVar.FONTC,
					size = 26,
					text = hVar.tab_string["__TEXT_MONTHCARD_INTRODUCE1"],
				})
				
				--显示文字说明2
				_GameCoinTipChildUI["rewardLabel_2"] = hUI.label:new({
					parent = _GameCoinTipParent,
					x = _offX - 220,
					y = _offY - 232 - 0,
					width = 500,
					align = "LC",
					font = hVar.FONTC,
					size = 26,
					text = hVar.tab_string["__TEXT_MONTHCARD_INTRODUCE2"],
				})
				
				--显示文字说明3
				_GameCoinTipChildUI["rewardLabel_3"] = hUI.label:new({
					parent = _GameCoinTipParent,
					x = _offX - 220,
					y = _offY - 232 - 42,
					width = 500,
					align = "LC",
					font = hVar.FONTC,
					size = 26,
					text = hVar.tab_string["__TEXT_MONTHCARD_INTRODUCE3"],
				})
				
				--展示剩余月卡时间
				if (g_monthcard_leftdays > 0) then
					--显示文字说明2
					_GameCoinTipChildUI["monthcardLeftTimeLabel"] = hUI.label:new({
						parent = _GameCoinTipParent,
						x = _offX,
						y = _offY - 130,
						width = 500,
						align = "MC",
						font = hVar.FONTC,
						size = 24,
						text = string.format(hVar.tab_string["__TEXT_MONTHCARD_LEFTTIME"], g_monthcard_leftdays),
						RGB = {0, 255, 0,},
					})
				else
					--显示文字说明2
					_GameCoinTipChildUI["monthcardLeftTimeLabel"] = hUI.label:new({
						parent = _GameCoinTipParent,
						x = _offX,
						y = _offY - 130,
						width = 500,
						align = "MC",
						font = hVar.FONTC,
						size = 24,
						text = hVar.tab_string["__TEXT_MONTHCARD_NOTHAVE"],
						RGB = {212, 64, 42,},
					})
				end
				
				--月卡的评论区按钮
				_GameCoinTipChildUI["BtnComment"] = hUI.button:new({
					parent = _GameCoinTipParent,
					model = "misc/addition/commentbtn.png",
					x = _offX + 280,
					y = _offY - 80,
					dragbox = _frm2.childUI["dragBox"],
					scaleT = 0.95,
					scale = 0.8,
					scaleT = 0.8,
					--z = 10,
					code = function()
						--清除tip面版
						--if hGlobal.UI.PurchaseInfoFram then
							--hGlobal.UI.PurchaseInfoFram:del()
							--hGlobal.UI.PurchaseInfoFram = nil
						--end
						CommentManage.ReadyComment(hVar.CommentTargetTypeDefine.MONTH_CARD)
						hGlobal.event:event("LocalEvent_DoCommentProcess",{})
					end,
				})
			end
			
			--充值按钮
			_GameCoinTipChildUI["BtnBuy"] = hUI.button:new({
				parent = _GameCoinTipParent,
				model = "misc/chest/itembtn.png",
				x = _offX,
				y = _offY - 400,
				w = 108,
				h = 63,
				label = {x = 0, y = 2, font = hVar.FONTC, align = "MC", border = 1, text = hVar.tab_string["__TEXT_Buy"], size = 28, width = 300, RGB = {255, 255, 0,},}, --"购买"
				dragbox = _frm2.childUI["dragBox"],
				scaleT = 0.95,
				code = function()
					--清除tip面版
					if hGlobal.UI.PurchaseInfoFram then
						hGlobal.UI.PurchaseInfoFram:del()
						hGlobal.UI.PurchaseInfoFram = nil
					end
					
					--点击充值按钮
					OnSelectChargeMoneyButton(idxEx)
				end,
			})
		end
	end
	
	--函数：关闭本界面
	OnClosePanel = function()
		--不显示充值面板
		hGlobal.UI.PhoneChargeMoneyFrm:show(0)
		
		--先清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--动态删除宝物背景大图
		__DynamicRemoveRes()
		
		--关闭界面后不需要监听的事件
		--取消监听：
		--...
		
		--清空切换分页之后取消的监听事件
		--移除事件监听：充值信息列表回调
		hGlobal.event:listen("LocalEvent_OnIapList_Back", "__IapListBack", nil)
		--移除事件监听：充值成功或失败的回调
		hGlobal.event:listen("LocalEvent_Purchase_Back", "__PurchaseBack", nil)
		--移除事件监听：首充奖励的回调
		hGlobal.event:listen("LocalEvent_SetgiftFrmBtnState", "__GiftBack", nil)
		--移除事件监听：获得VIP等级和领取状态事件
		hGlobal.event:listen("LocalEvent_GetVipState_New", "__PurchaseGetVipStateBack", nil)
		--移除事件监听：获得VIP领取状态事件
		hGlobal.event:listen("LocalEvent_GetVipDailyRewardFlag", "__PurchaseDailyRewardBack", nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__PurchaseSpinScreen", nil)
		
		--移除timer
		hApi.clearTimer("__TASK_TIMER_UPDATE__")
		
		--删除充值刷新界面timer
		hApi.clearTimer("__CHARGE_MONEY_UPDATE__")
		
		--关闭金币、积分界面
		hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
		
		--触发事件：关闭了主菜单按钮
		--hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
		
		--清除当前正在交易的id为0
		current_focus_achievementEx_idx = 0
		current_deal_idx = 0
		
		--允许再次打开
		_bCanCreate = true
	end
	
	--函数: 动态加载资源
	__DynamicAddRes = function()
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--加载资源
		--动态加载宝物背景图
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/chest/chest_img_bg4.png")
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/chest/chest_img_bg4.png")
			print("加载宝物背景大图4！")
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
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--删除资源
		--删除竞技场背景图
		_childUI["panel_bg"].handle._n:removeChild(_childUI["panel_bg"].data.pSprite, true)
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/chest/chest_img_bg4.png")
		if texture then
			CCTextureCache:sharedTextureCache():removeTexture(texture)
			print("清空宝物背景大图4！")
		end
	end
	
	---------------------------------------------------------------------------------------
	------------------------------------月卡相关-------------------------------------------
	---------------------------------------------------------------------------------------
	
	local isBuyMonthCard = 0 --是否购买月卡
	
	--重置交易序号
	hGlobal.event:listen("LocalEvent_ResetDealIdx","__ResetValue",function()
		if current_deal_idx == 9999 then
			current_deal_idx = 0
		end
	end)
	
	--购买月卡
	hGlobal.event:listen("LocalEvent_BuyMonthCard","__BuyMonthCard",function()
		--如果有正在交易的id  那么直接漂浮文字并返回
		if current_deal_idx > 0 then
			--local strText = "上一个交易正在处理中！" --language
			local strText = hVar.tab_string["ios_deal_ing"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2 - 120,
				align = "MC",
				text = "",
				lifetime = 2000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 32, "MC", 32, 0)
			return
		end
		hGlobal.event:event("LocalEvent_SetBuyMthCardBtnState",true)
		isBuyMonthCard = 1
		--获取类型
		if xlGetIapType then
			current_iType = xlGetIapType() --读取支付类型
			
			--默认是用苹果支付
			if (current_iType == 0) then
				current_iType = 1
			end
		end
		--发起查询，充值信息列表
		if xlRequestIapList then
			--current_iType = hVar.IAP_TYPE.OP
			--如果类型是1或者2或者103或者104，那么直接发起查询
			if (current_iType == 1) or (current_iType == 2) or (current_iType >= hVar.IAP_TYPE.MI and current_iType <= hVar.IAP_TYPE.IAP_TYPE_MAX) then 
			--支付类型(1:苹果 / 2:支付宝 /103:米币 /104:华为 /107:OPPO / 3:用户选择 当前平台支付方式 或 支付宝)
				xlRequestIapList(current_iType)
				
				--绘制充值方式小logo
				OnCreatePayTypeLogo()
			else	--根据平台不同  显示不同选择
				local iChannelId = getChannelInfo()
				--苹果或者小米平台
				if type(iChannelId) == "number" and (iChannelId == 1 or (iChannelId >= 1003 and iChannelId <= 1010)) then--
					local MsgSelections = nil
					local ok_itype = 2	--支付宝
					local cancel_itype = iChannelId --平台自己的
					if 1003 <= cancel_itype then 
						cancel_itype = cancel_itype - 900
					end
					local ok_text = hVar.tab_string["ios_payment_alipay"]
					local cancel_text = " "
					if cancel_itype == 1 then
						cancel_text = hVar.tab_string["ios_payment_apple"]
					elseif cancel_itype == hVar.IAP_TYPE.MI then
						cancel_text = hVar.tab_string["ios_payment_mipay"]
					elseif cancel_itype == hVar.IAP_TYPE.HW then
						cancel_text = hVar.tab_string["ios_payment_huawei"]
					elseif cancel_itype == hVar.IAP_TYPE.JY then
						cancel_text = hVar.tab_string["ios_payment_jiuyou"]
					elseif cancel_itype == hVar.IAP_TYPE.TX then
						cancel_text = hVar.tab_string["ios_payment_txpay"]
					elseif cancel_itype == hVar.IAP_TYPE.OP then
						cancel_text = "" --"OPPO"
					elseif cancel_itype == hVar.IAP_TYPE.VV then
						cancel_text = "VIVO"
					elseif cancel_itype == hVar.IAP_TYPE.LHH then
						cancel_text = hVar.tab_string["ios_payment_lhhpay"]
					elseif (cancel_itype == hVar.IAP_TYPE.YZYZ) then
						cancel_text = hVar.tab_string["ios_payment_alipay"]
					elseif (cancel_itype == hVar.IAP_TYPE.OP_QMHY) then --OPPO 全民互娱
						cancel_text = "" --"OPPO"
					elseif (cancel_itype == hVar.IAP_TYPE.VV_QMHY) then --VIVO 全民互娱
						cancel_text = "VIVO"
					elseif (cancel_itype == hVar.IAP_TYPE.TX_XMHY_TEST) then --应用宝测试(海南希萌互娱)
						cancel_text = hVar.tab_string["ios_payment_txpay"]
					elseif (cancel_itype == hVar.IAP_TYPE.HW_XMHY) then --华为(海南希萌互娱)
						cancel_text = hVar.tab_string["ios_payment_huawei"]
					elseif (cancel_itype == hVar.IAP_TYPE.TX_XMHY) then --应用宝(海南希萌互娱)
						cancel_text = hVar.tab_string["ios_payment_txpay"]
					elseif (cancel_itype == hVar.IAP_TYPE.HW_STANDARD) then --华为(官方)
						cancel_text = hVar.tab_string["ios_payment_huawei"]
					elseif (cancel_itype == hVar.IAP_TYPE.TX_STANDARD) then --应用宝(官方)
						cancel_text = hVar.tab_string["ios_payment_txpay"]
					elseif (cancel_itype == hVar.IAP_TYPE.OP_STANDARD) then --OPPO(官方)
						cancel_text = "" --"OPPO"
					elseif (cancel_itype == hVar.IAP_TYPE.VV_STANDARD) then --VIVO(官方)
						cancel_text = "VIVO"
					elseif (cancel_itype == hVar.IAP_TYPE.GOOGLE) then --googleplay
						cancel_text = "GOOGLE"
					elseif (cancel_itype == hVar.IAP_TYPE.GOOGLE_KOREA) then --googleplay_korea
						cancel_text = "GOOGLE"
					end
					MsgSelections = {
						style = "mini",
						select = 0,
						ok = function()
							current_iType = ok_itype
							xlRequestIapList(current_iType)
							--绘制充值方式小logo
							OnCreatePayTypeLogo()
						end,
						cancel = function()
							current_iType = cancel_itype
							xlRequestIapList(current_iType)
							--绘制充值方式小logo
							OnCreatePayTypeLogo()
						end,
						cancelFun = cancelCallback, --点否的回调函数
						textOk = ok_text, --language
						textCancel = cancel_text, --language
						userflag = 0, --用户的标记
					}
					--local showTitle = "请选择支付方式" --language
					local showTitle = hVar.tab_string["ios_payment_select_pay_mode"] --language
					local msgBox = hGlobal.UI.MsgBox(showTitle, MsgSelections)
					msgBox:active()
					msgBox:show(1,"fade",{time=0.08})
				elseif iChannelId == 1013 then --预留渠道YZYZ
					current_iType = 113
					xlRequestIapList(current_iType)
					--绘制充值方式小logo
					OnCreatePayTypeLogo()
				elseif iChannelId == 1014 then --好游快爆
					current_iType = 114
					xlRequestIapList(current_iType)
					--绘制充值方式小logo
					OnCreatePayTypeLogo()
				elseif iChannelId == 1017 then --oppo 全民互娱
					current_iType = 117
					xlRequestIapList(current_iType)
					--绘制充值方式小logo
					OnCreatePayTypeLogo()
				elseif iChannelId == 1018 then --vivo 全民互娱
					current_iType = 118
					xlRequestIapList(current_iType)
					--绘制充值方式小logo
					OnCreatePayTypeLogo()
				elseif iChannelId == 1019 then --应用宝测试(海南希萌互娱)
					current_iType = 119
					xlRequestIapList(current_iType)
					--绘制充值方式小logo
					OnCreatePayTypeLogo()
				elseif iChannelId == 1020 then --华为(海南希萌互娱)
					current_iType = 120
					xlRequestIapList(current_iType)
					--绘制充值方式小logo
					OnCreatePayTypeLogo()
				elseif iChannelId == 1021 then --应用宝(海南希萌互娱)
					current_iType = 121
					xlRequestIapList(current_iType)
					--绘制充值方式小logo
					OnCreatePayTypeLogo()
				elseif iChannelId == 1024 then --华为(官方)
					current_iType = 124
					xlRequestIapList(current_iType)
					--绘制充值方式小logo
					OnCreatePayTypeLogo()
				elseif iChannelId == 1026 then --应用宝(官方)
					current_iType = 126
					xlRequestIapList(current_iType)
					--绘制充值方式小logo
					OnCreatePayTypeLogo()
				elseif iChannelId == 1027 then --oppo(官方)
					current_iType = 127
					xlRequestIapList(current_iType)
					--绘制充值方式小logo
					OnCreatePayTypeLogo()
				elseif iChannelId == 1028 then --vivo(官方)
					current_iType = 128
					xlRequestIapList(current_iType)
					--绘制充值方式小logo
					OnCreatePayTypeLogo()
				elseif iChannelId == 1012 then --googleplay
					current_iType = 112
					xlRequestIapList(current_iType)
					--绘制充值方式小logo
					OnCreatePayTypeLogo()
				elseif iChannelId == 2012 then --googleplay_korea
					current_iType = 1112
					xlRequestIapList(current_iType)
					--绘制充值方式小logo
					OnCreatePayTypeLogo()
				else --非渠道 或数据异常   默认用支付宝
					current_iType = 2
					xlRequestIapList(current_iType)
					--绘制充值方式小logo
					OnCreatePayTypeLogo()
				end
			end
		end
	end)
	
	--存储月卡充值信息
	hGlobal.event:listen("LocalEvent_GetMonthCardInfo","__GetMonthCardIndex",function(tInfo)
		current_month_card_Info = tInfo
	end)
	
	--获取月卡序号
	hGlobal.event:listen("LocalEvent_GetMonthCardIndex","__GetMonthCardIndex",function(index)
		--获得列表得到序号时判断是否当前是购买月卡
		if isBuyMonthCard == 1 then
			isBuyMonthCard = 0
			current_deal_idx = 9999 --月卡
			--调用接口购买
			if xlIapBuyItem then
				--实名模式需要等待异步回调再判断
--				if xlRealNameCheckMode() then
--					local productPrice = 30 --产品价格 --月卡
--					xlRealNameCheckPayLimit( productPrice * 100 )
--					--[[
--					if g_lua_src == 1 then
--						xlLuaEvent_RealName_CheckPay(0,"sssss")
--					end
--					--]]
--				else
					--支付类型(1:苹果 / 2:支付宝 / 3:用户选择)
					if (current_iType == 1) then --苹果
						local id = index - 1
						xlIapBuyItem(current_iType, id)
					elseif (current_iType == 2 or (current_iType >= hVar.IAP_TYPE.MI and current_iType <= hVar.IAP_TYPE.IAP_TYPE_MAX)) then --支付宝 or 米币
						if (current_iType ~= hVar.IAP_TYPE.TX) then --腾讯应用宝1006渠道专用，其他应用宝渠道不走此流程
							xlIapBuyItem(current_iType, index)
						else
							YYBSpecialTreatment(index,1)
						end
					end
--				end
			end
		end
	end)
end

--监听充值界面通知事件
hGlobal.event:listen("LocalEvent_InitInAppPurchaseTipFrm", "__ShowChargeMoneyFrm", function(callback, bOpenImmediate)
	hGlobal.UI.InitChargeMoneyFrm("reload")
	
	--print("监听充值界面通知事件",callback, bOpenImmediate)
	--直接打开
	if bOpenImmediate then
		--触发事件，显示积分、金币界面
		--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
		
		--显示道具界面
		hGlobal.UI.PhoneChargeMoneyFrm:show(1)
		hGlobal.UI.PhoneChargeMoneyFrm:active()
		
		--打开上一次的分页（默认显示第1个分页:充值）
		local lastPageIdx = CurrentSelectRecord.pageIdx
		if (lastPageIdx == 0) then
			lastPageIdx = 1
		end
		
		--print("监听充值界面通知事件")
		
		CurrentSelectRecord.pageIdx = 0
		CurrentSelectRecord.contentIdx = 0
		OnClickPageBtn(lastPageIdx)
		
		--存储回调事件
		current_funcCallback = callback
		
		--[[
		--连接pvp服务器，获取碎片、将魂
		if (Pvp_Server:GetState() ~= 1) then --未连接
			Pvp_Server:Connect()
		elseif (not hGlobal.LocalPlayer:getonline()) then --不重复登陆
			Pvp_Server:UserLogin()
		end
		]]
		
		--只有在打开界面时才会监听的事件
		--监听：收到网络宝箱数量的事件
		--hGlobal.event:listen("LocalEvent_getNetChestNum", "__ItemGetChestNum_Frm", function(NumTab)
			--更新网络宝箱的数量和界面
			--
		--end)
		
		--创建timer，刷新充值滚动
		hApi.addTimerForever("__CHARGE_MONEY_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, function()
			refresh_achievement_UI_loop()
		end)
		
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
			hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
			
			--显示道具界面
			hGlobal.UI.PhoneChargeMoneyFrm:show(1)
			hGlobal.UI.PhoneChargeMoneyFrm:active()
			
			--打开上一次的分页（默认显示第1个分页:充值）
			local lastPageIdx = CurrentSelectRecord.pageIdx
			if (lastPageIdx == 0) then
				lastPageIdx = 1
			end
			
			CurrentSelectRecord.pageIdx = 0
			CurrentSelectRecord.contentIdx = 0
			OnClickPageBtn(lastPageIdx)
			
			--存储回调事件
			current_funcCallback = callback
			
			--[[
			--连接pvp服务器，获取碎片、将魂
			if (Pvp_Server:GetState() ~= 1) then --未连接
				Pvp_Server:Connect()
			elseif (not hGlobal.LocalPlayer:getonline()) then --不重复登陆
				Pvp_Server:UserLogin()
			end
			]]
			
			--只有在打开界面时才会监听的事件
			--监听：收到网络宝箱数量的事件
			--hGlobal.event:listen("LocalEvent_getNetChestNum", "__ItemGetChestNum_Frm", function(NumTab)
				--更新网络宝箱的数量和界面
				--
			--end)
			
			--创建timer，刷新充值滚动
			hApi.addTimerForever("__CHARGE_MONEY_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, function()
				refresh_achievement_UI_loop()
			end)
			
			--初始设置坐标
			--主面板设置到左侧屏幕外面
			local _frm = hGlobal.UI.PhoneChargeMoneyFrm
			local dx = BOARD_WIDTH
			_frm:setXY(_frm.data.x + dx, _frm.data.y)
		end)
		
		--步骤2: 动画进入控件
		local actM2 = CCCallFunc:create(function()
			--本面板
			local _frm = hGlobal.UI.PhoneChargeMoneyFrm
			
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
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm
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
hGlobal.event:listen("clearPhoneChestFrm", "__ClosePurchaseFrm", function()
	if hGlobal.UI.PhoneChargeMoneyFrm then
		if (hGlobal.UI.PhoneChargeMoneyFrm.data.show == 1) then
			--关闭本界面
			OnClosePanel()
		end
		
		--允许再次打开
		_bCanCreate = true
	end
end)

--监听允许响应打开充值界面事件
hGlobal.event:listen("enablePhonePurchaseFrm", "__EnablePurchaseFrm", function()
	--允许打开
	_bCanCreate = true
end)

--测试 --test
--[[
--测试代码
if hGlobal.UI.PhoneChargeMoneyFrm then --删除上一次的充值界面
	hGlobal.UI.PhoneChargeMoneyFrm:del()
	hGlobal.UI.PhoneChargeMoneyFrm = nil
end
hGlobal.UI.InitChargeMoneyFrm("reload") --测试
--触发事件，显示充值界面
hGlobal.event:event("LocalEvent_InitInAppPurchaseTipFrm")
]]
