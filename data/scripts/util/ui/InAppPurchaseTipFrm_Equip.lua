


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
--local on_receive_IapList_event = hApi.DoNothing --收到充值信息列表回调
--local on_receive_purchase_event = hApi.DoNothing --收到充值成功或失败的回调
--local on_receive_gift_event = hApi.DoNothing --收到首充奖励的回调
local on_receive_giftequipinfo_event = hApi.DoNothing --收到玩家特惠装备信息返回结果
--local on_receive_IapList_gift_event = hApi.DoNothing --充值信息列表回调（仅限苹果）
local on_receive_giftequip_buyitem_back_event = hApi.DoNothing --收到购买特惠装备结果返回
--local on_update_gift_ui = hApi.DoNothing --刷新首充状态界面
local on_spine_screen_event = hApi.DoNothing --横竖屏切换
--local on_update_vip_tanhao_event = hApi.DoNothing --更新vip按钮叹号状态
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
--local ORINGIN_MONEY_TABLE = {6, 12, 25, 45, 98, 198,} --最后一个是月卡
--local ORINGIN_GAMECOIN_TABLE = {0, 0, 0, 0, 0, 0,} --最后一个是月卡
--local ORINGIN_REWARD_TABLE = {{101, 15006, 10,}, {101, 15007, 10,}, {103, 15104, 50,}, {6, 15213, 50,}, {3, 20014,}, {3, 20015,},} --最后一个是月卡

--可变参数
local current_Iap_max_num = 0 --最大的充值id
local current_focus_achievementEx_idx = 0 --当前显示的充值ex的索引值
local current_EquipInfo = {} --充值信息表
local current_GiftList = {} --首充奖励表
--local current_deal_idx = 0 --正在交易的充值id
local current_iIapType = 0 --支付类型(0:默认(苹果) / 1:苹果 / 2:支付宝 / 3:用户选择)
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

local MODEL_DISCOUNT = {0, "misc/discount_01_cn.png", "misc/discount_02_cn.png", "misc/discount_03_cn.png", "misc/discount_04_cn.png", "misc/discount_05_cn.png", "misc/discount_06_cn.png"} --折扣

--当前选中的记录
local CurrentSelectRecord = {pageIdx = 0, contentIdx = 0, cardId = 0,} --当前选择的分页、数据项的信息记录



--充值装备操作面板
hGlobal.UI.InitChargeMoneyFrm_Equip = function(mode)
	local tInitEventName = {"LocalEvent_InitInAppPurchaseGiftFrm_Equip", "__ShowChargeMoneyFrm"}
	if (mode ~= "reload") then
		--return tInitEventName
		return
	end
	
	--不重复创建
	if hGlobal.UI.PhoneChargeMoneyFrm_Equip then --充值面板
		hGlobal.UI.PhoneChargeMoneyFrm_Equip:del()
		hGlobal.UI.PhoneChargeMoneyFrm_Equip = nil
	end
	
	--先清除上一次的游戏币说明面板
	if hGlobal.UI.PurchaseInfoFram then
		hGlobal.UI.PurchaseInfoFram:del()
		hGlobal.UI.PurchaseInfoFram = nil
	end
	if hGlobal.UI.GameCoinTipFrame then
		hGlobal.UI.GameCoinTipFrame:del()
		hGlobal.UI.GameCoinTipFrame = nil
	end
	
	--[[
	--取消监听充值界面通知事件
	hGlobal.event:listen("LocalEvent_InitInAppPurchaseGiftFrm_Equip", "__ShowChargeMoneyFrm", nil)
	--取消监听关闭宝箱界面事件
	hGlobal.event:listen("clearPhoneChestFrm", "__ClosePurchaseGiftFrm", nil)
	]]
	
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
	
	hApi.clearTimer("__CHARGE_MONEY_EQUIP_UPDATE__")
	
	--创建充值装备操作面板
	hGlobal.UI.PhoneChargeMoneyFrm_Equip = hUI.frame:new(
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
	
	local _frm = hGlobal.UI.PhoneChargeMoneyFrm_Equip
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
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm_Equip
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm_Equip
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
		--hGlobal.event:listen("LocalEvent_OnIapList_Back", "__IapGiftListBack", nil)
		--移除事件监听：充值成功或失败的回调
		--hGlobal.event:listen("LocalEvent_Purchase_Back", "__PurchaseGiftBack", nil)
		--移除事件监听：首充奖励的回调
		--hGlobal.event:listen("LocalEvent_SetgiftFrmBtnState", "__GiftBack2", nil)
		--移除事件监听：获得VIP等级和领取状态事件
		--hGlobal.event:listen("LocalEvent_GetVipState_New", "__PurchaseGetVipStateGiftBack", nil)
		--移除事件监听：获得VIP领取状态事件
		--hGlobal.event:listen("LocalEvent_GetVipDailyRewardFlag", "__PurchaseDailyRewardGiftBack", nil)
		--移除事件监听：收到玩家特惠装备信息返回结果
		hGlobal.event:listen("localEvent_OnReceiveGiftEquipInfo_Ret", "__GiftEquipInfo", nil)
		--移除事件监听：收到玩家购买特惠装备结果返回
		hGlobal.event:listen("localEvent_OnReceiveGiftEquipBuyItem_Ret", "__GiftEquipBuyItemBack", nil)
		--移除事件监听：充值信息列表回调（仅限苹果）
		--hGlobal.event:listen("LocalEvent_OnIapList_Back", "__IapGiftListBack", nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__PurchaseGiftSpinScreen", nil)
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：充值
			--创建充值分页
			OnCreateChargeMoneyFrame(pageIndex)
		end
		
		--标记当前选择的分页和页内的第几个
		CurrentSelectRecord.pageIdx = pageIndex
		CurrentSelectRecord.contentIdx = 0
	end
	
	--函数：创建充值装备界面（第1个分页）
	OnCreateChargeMoneyFrame = function(pageIdx)
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm_Equip
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--动态加载宝物背景大图
		__DynamicAddRes()
		
		--初始化参数
		--current_Iap_max_num = 0 --最大的充值id
		current_focus_achievementEx_idx = 0 --当前显示的充值ex的索引值
		--current_EquipInfo = {} --充值信息表
		current_GiftList = {} --首充奖励表
		--current_deal_idx = 0 --正在交易的充值id
		--current_iIapType = 0 --初始化支付类型(1:苹果 / 2:支付宝 / 3:用户选择)
		
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
				for i = 1, #current_EquipInfo, 1 do
					local listI = current_EquipInfo[i] --第i项
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
					for i = 1, #current_EquipInfo, 1 do
						local listI = current_EquipInfo[i] --第i项
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
				for i = 1, #current_EquipInfo, 1 do
					local listI = current_EquipInfo[i] --第i项
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
					for i = 1, #current_EquipInfo, 1 do
						local listI = current_EquipInfo[i] --第i项
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
		--on_update_vip_tanhao_event()
		
		--只在本分页有效的事件
		
		--添加事件监听：充值信息列表回调
		--hGlobal.event:listen("LocalEvent_OnIapList_Back", "__IapGiftListBack", on_receive_IapList_event)
		
		--添加事件监听：充值成功或失败的回调
		--hGlobal.event:listen("LocalEvent_Purchase_Back", "__PurchaseGiftBack", on_receive_purchase_event)
		
		--添加事件监听：首充奖励的回调
		--hGlobal.event:listen("LocalEvent_SetgiftFrmBtnState", "__GiftBack2", on_receive_gift_event)
		
		--添加事件监听：收到玩家特惠装备信息返回结果
		hGlobal.event:listen("localEvent_OnReceiveGiftEquipInfo_Ret", "__GiftEquipInfo", on_receive_giftequipinfo_event)
		--添加事件监听：收到玩家购买特惠装备结果返回
		hGlobal.event:listen("localEvent_OnReceiveGiftEquipBuyItem_Ret", "__GiftEquipBuyItemBack", on_receive_giftequip_buyitem_back_event)
		--添加事件监听：充值信息列表回调（仅限苹果）
		--hGlobal.event:listen("LocalEvent_OnIapList_Back", "__IapGiftListBack", on_receive_IapList_gift_event)
		
		--添加事件监听：获得VIP等级和领取状态事件
		--hGlobal.event:listen("LocalEvent_GetVipState_New", "__PurchaseGetVipStateGiftBack", on_update_vip_tanhao_event)
		
		--添加事件监听：获得VIP领取状态事件
		--hGlobal.event:listen("LocalEvent_GetVipDailyRewardFlag", "__PurchaseDailyRewardGiftBack", on_update_vip_tanhao_event)
		
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__PurchaseGiftSpinScreen", on_spine_screen_event)
		
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
			text = hVar.tab_string["__TEXT_Page_Equip"], --"装备"
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
			y = -196 - 88 * 0 + 0,
			w = 160,
			h = 90,
			label = {x = 0, y = 0, font = hVar.FONTC, align = "MC", border = 1, text = hVar.tab_string["__TEXT_Page_Equip"], size = 36, width = 300, RGB = {255, 255, 0,},}, --"装备"
			--scale = 0.8,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function()
				--print("AAA")
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
			model = "misc/chariotconfig/tabbutton.png",
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
		
		--发起查询特惠礼包装备信息
		SendCmdFunc["require_giftequip_info"]()
	end
	
	--[[
	--函数：更新vip按钮叹号状态
	on_update_vip_tanhao_event = function()
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm_Equip
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local enableVIPDaliyReward = false
		if (LuaGetPlayerVipLv() > 0) and (LuaGetDailyReward() == 0) then --是vip，没领取奖励
			enableVIPDaliyReward = true
		end
		
		 --设置VIP领取状态的跳动的叹号
		--_frmNode.childUI["AchievementVipBtn"].childUI["PageTanHao"].handle._n:setVisible(enableVIPDaliyReward)
	end
	]]
	
	--函数：收到限时商品信息回调
	on_receive_giftequipinfo_event = function(equipNum, tEquipInfo)
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm_Equip
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("on_receive_giftequipinfo_event", equipNum, tEquipInfo)
		
		--先清空右侧分页的信息
		_removeRightFrmFunc()
		
		--存储数量
		current_Iap_max_num = equipNum
		current_EquipInfo = tEquipInfo
		current_iIapType = 0
		
		--找到1元档商品
		for i = 1, equipNum, 1 do
			local reward = tEquipInfo[i].reward --奖励表
			local iCount = tEquipInfo[i].iCount or 0 --已购买次数
			local iMaxCount = tEquipInfo[i].iMaxCount or 1 --最大购买次数
			local goldCost = tEquipInfo[i].goldCost or 0 --需要的游戏币
			
			--第一个奖励
			local rewardT = reward[1]
			
			local xn = (i % ACHIEVEMENT_X_NUM) --xn
			if (xn == 0) then
				xn = ACHIEVEMENT_X_NUM
			end
			local yn = (i - xn) / ACHIEVEMENT_X_NUM + 1 --yn
			
			local offsetList =
			{
				[1] = {x = -67,y = 52,}, --武器枪宝箱
				[2] = {x = -(BILLBOARD_WIDTH + BILLBOARD_DISTANCEX)-67, y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY)+32,}, --战术宝箱
				[3] = {x = -158-97,y = 53,}, --宠物宝箱
				[4] = {x = -67,y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY) + 14,}, --装备宝箱
				[5] = {x = 52-82,y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY) + 222,}, --装备宝箱
				[6] = {x = -(BILLBOARD_WIDTH + BILLBOARD_DISTANCEX)+52-82,y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY) + 14,}, --装备宝箱
			}
			
			offsetList[3].x = offsetList[3].x - (BILLBOARD_WIDTH + BILLBOARD_DISTANCEX) - 20
			offsetList[3].y = offsetList[3].y - (BILLBOARD_WIDTH + BILLBOARD_DISTANCEX) * 2
			offsetList[4].x = offsetList[4].x + (BILLBOARD_WIDTH + BILLBOARD_DISTANCEX) + 20
			offsetList[4].y = offsetList[4].y + (BILLBOARD_WIDTH + BILLBOARD_DISTANCEX) * 2
			
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
			--_frmNode.childUI["AchievementNode" .. i].data.rewardT = rewardT --存储奖励
			_frmNode.childUI["AchievementNode" .. i].handle.s:setOpacity(0) --只响应事件，不显示
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AchievementNode" .. i
			
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
			
			debrisOffsetList[3].x = debrisOffsetList[3].x - 14
			debrisOffsetList[3].y = debrisOffsetList[3].y - 0
			debrisOffsetList[4].x = debrisOffsetList[4].x + 24
			debrisOffsetList[4].y = debrisOffsetList[4].y + 0
			
			--只显示第一个奖励
			--local rewardT = reward[1]
			local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
			
			--geyachao: 统一改为箱子图标
			--tmpModel = "icon/item/iap_gift_lv" .. i .. ".png"
			--itemNum = 1
			
			_frmNode.childUI["AchievementNode" .. i].childUI["gamecoinsLabel"] = hUI.label:new({
				parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
				--x = 0 + debrisOffsetList[i].x + 00,
				--y = -86 + debrisOffsetList[i].y,
				x = 0,
				y = -20,
				z = 100,
				size = 28,
				font = "numWhite",
				align = "MC",
				width = 300,
				--border = 1,
				text = "", --"+" .. itemNum, --geyachao: 王总说不显示"+1"了
			})
			
			_frmNode.childUI["AchievementNode" .. i].childUI["light"] = hUI.image:new({
				parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
				model = "misk/mask.png",
				x = 0,
				y = 20,
				w = 64,
				h = 64,
			})
			_frmNode.childUI["AchievementNode" .. i].childUI["light"].handle.s:setOpacity(0) --只挂载子控件，不显示
			--宝物图标随机动画
			local moveTime = 30000
			local act1 = CCRotateBy:create(moveTime/1000, 360)
			local a = CCArray:create()
			local sequence = CCSequence:create(a)
			a:addObject(act1)
			--oItem.handle.s:stopAllActions() --先停掉之前的动作
			_frmNode.childUI["AchievementNode" .. i].childUI["light"].handle._n:runAction(CCRepeatForever:create(act1))
			
			--充值满载金币的商品图（金币造型图）
			local scale = 2.8
			_frmNode.childUI["AchievementNode" .. i].childUI["icon"] = hUI.button:new({ --作为按钮只是为了挂载子控件
				parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
				model = tmpModel, --"UI:Purchase_" .. i,
				x = 0,
				y = 20,
				w = itemWidth * scale,
				h = itemHeight * scale
			})
			_frmNode.childUI["AchievementNode" .. i].childUI["icon"].handle.s:setOpacity(0) --应王总要求，不显示品质颜色图片
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
			
			--绘制奖励图标的子控件
			if sub_tmpModel then
				--geyachao: 碎片图标不显示了
				if (sub_tmpModel ~= "UI:SoulStoneFlag") then --不是碎片图标
					_frmNode.childUI["AchievementNode" .. i].childUI["icon"].childUI["subIcon"] = hUI.image:new({
						parent = _frmNode.childUI["AchievementNode" .. i].childUI["icon"].handle._n,
						model = sub_tmpModel,
						x = sub_pos_x * scale,
						y = sub_pos_y * scale,
						w = sub_pos_w * scale,
						h = sub_pos_h * scale,
					})
				end
			end
			
			--[[
			--特殊数量的数字，用图片表示
			if (itemNum == 1) then
				_frmNode.childUI["AchievementNode" .. i].childUI["gamecoinsLabel"]:setText("")
			elseif (itemNum == 10) then
				_frmNode.childUI["AchievementNode" .. i].childUI["gamecoinsLabel"]:setText("")
				
				--数量x10的图标
				_frmNode.childUI["AchievementNode" .. i].childUI["icon"].childUI["debris10Icon"] = hUI.image:new({
					parent = _frmNode.childUI["AchievementNode" .. i].childUI["icon"].handle._n,
					model = "ICON:debris_10",
					x = 0,
					y = -40,
					z = 100,
					scale = 1,
				})
			elseif (itemNum == 50) then
				_frmNode.childUI["AchievementNode" .. i].childUI["gamecoinsLabel"]:setText("")
				
				--数量x50的图标
				_frmNode.childUI["AchievementNode" .. i].childUI["icon"].childUI["debris50Icon"] = hUI.image:new({
					parent = _frmNode.childUI["AchievementNode" .. i].childUI["icon"].handle._n,
					model = "ICON:debris_50",
					x = 0,
					y = -40,
					z = 100,
					scale = 1,
				})
			elseif (itemNum == 88) then
				_frmNode.childUI["AchievementNode" .. i].childUI["gamecoinsLabel"]:setText("")
				
				--数量x50的图标
				_frmNode.childUI["AchievementNode" .. i].childUI["icon"].childUI["debris88Icon"] = hUI.image:new({
					parent = _frmNode.childUI["AchievementNode" .. i].childUI["icon"].handle._n,
					model = "ICON:debris_88",
					x = 0,
					y = -40,
					z = 100,
					scale = 1,
				})
			end
			]]
			
			--商品售罄图标
			_frmNode.childUI["AchievementNode" .. i].childUI["sellout"] = hUI.image:new({
				parent = _frmNode.childUI["AchievementNode" .. i].handle._n,
				model = "UI:FinishTag5_big",
				x = -4,
				y = 20,
				z = 4,
				w = 114,
				h = 81,
			})
			_frmNode.childUI["AchievementNode" .. i].childUI["sellout"].handle._n:setRotation(-5)
			_frmNode.childUI["AchievementNode" .. i].childUI["sellout"].handle._n:setVisible(false) --默认不显示
			if (iCount >= iMaxCount) then
				_frmNode.childUI["AchievementNode" .. i].childUI["sellout"].handle._n:setVisible(true)
			end
			
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
			
			--游戏币图标
			_frmNode.childUI["AchievementNode" .. i].childUI["ConfimBtn"].childUI["gamecoinIcon"] = hUI.image:new({
				parent = _frmNode.childUI["AchievementNode" .. i].childUI["ConfimBtn"].handle._n,
				model = "misc/skillup/keshi.png",
				x = -32,
				y = 1,
				w = 38,
				h = 38,
			})
			
			--游戏币数量
			_frmNode.childUI["AchievementNode" .. i].childUI["ConfimBtn"].childUI["money"] = hUI.label:new({
				parent = _frmNode.childUI["AchievementNode" .. i].childUI["ConfimBtn"].handle._n,
				x = -6,
				y = -1 + 1, --数字字体有2像素的偏差
				size = 26,
				align = "LC",
				font = "num",
				border = 0,
				text = goldCost,
			})
			--_frmNode.childUI["AchievementNode" .. i].childUI["sign"].handle.s:setColor(ccc3(255, 255, 0))
			if (goldCost < 10) then --一位数的处理
				_frmNode.childUI["AchievementNode" .. i].childUI["ConfimBtn"].childUI["money"]:setXY(0, -1 + 1)
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
				model = "misk/mask.png", --"UI:TacTicFrame",
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
		
		--立即刷新一次首充状态
		--on_update_gift_ui()
	end
	
	--函数：横竖屏切换
	on_spine_screen_event = function()
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm_Equip
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--关闭本界面
		OnClosePanel()
		
		--重绘本界面
		hGlobal.UI.InitChargeMoneyFrm_Equip("reload") --测试
		--触发事件，显示充值装备界面
		hGlobal.event:event("LocalEvent_InitInAppPurchaseGiftFrm_Equip", current_funcCallback)
	end
	
	--函数：刷新充值界面的滚动
	refresh_achievement_UI_loop = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm_Equip
		local _frmNode = _frm.childUI["PageNode"]
		if (_frmNode == nil) then
			return
		end
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
				for i = 1, #current_EquipInfo, 1 do
					local listI = current_EquipInfo[i] --第i项
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
				for i = 1, #current_EquipInfo, 1 do
					local listI = current_EquipInfo[i] --第i项
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
					for i = 1, #current_EquipInfo, 1 do
						local listI = current_EquipInfo[i] --第i项
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
					for i = 1, #current_EquipInfo, 1 do
						local listI = current_EquipInfo[i] --第i项
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
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm_Equip
		local _frmNode = _frm.childUI["PageNode"]
		if (_frmNode == nil) then
			return
		end
		local _parentNode = _frmNode.handle._n
		
		--标记选中哪个充值idx
		local last_achieve_idx = current_focus_achievementEx_idx
		current_focus_achievementEx_idx = idxEx
		
		--显示本次的
		if (current_focus_achievementEx_idx > 0) then
			local listI = current_EquipInfo[current_focus_achievementEx_idx]
			local reward = listI.reward --奖励表
			local iCount = listI.iCount or 0 --已购买次数
			local iMaxCount = listI.iMaxCount or 1 --最大购买次数
			local goldCost = listI.goldCost or 0 --需要的游戏币
			
			--显示菊花
			_frmNode.childUI["AchievementNode" .. current_focus_achievementEx_idx].childUI["waiting"].handle.s:setVisible(true)
			
			--[[
			--灰掉按钮
			hApi.AddShader(_frmNode.childUI["AchievementNode" .. current_focus_achievementEx_idx].handle.s, "gray") --灰色图片
			hApi.AddShader(_frmNode.childUI["AchievementNode" .. current_focus_achievementEx_idx].childUI["ConfimBtn"].handle.s, "gray") --灰色图片
			]]
			
			--先清除上一次的游戏币说明面板
			if hGlobal.UI.PurchaseInfoFram then
				hGlobal.UI.PurchaseInfoFram:del()
				hGlobal.UI.PurchaseInfoFram = nil
			end
			if hGlobal.UI.GameCoinTipFrame then
				hGlobal.UI.GameCoinTipFrame:del()
				hGlobal.UI.GameCoinTipFrame = nil
			end
			
			--挡操作
			--hUI.NetDisable(30000)
			
			--充值按钮不可点
			if _frmNode.childUI["btnPruchase"] then
				_frmNode.childUI["btnPruchase"]:setstate(0)
			end
			
			--播放出售音效
			hApi.PlaySound("pay_gold")
			
			--发起请求，购买特惠礼包装备
			SendCmdFunc["require_gift_equip_buyitem"](current_focus_achievementEx_idx)
		end
	end
	
	--函数：购买特惠装备结果返回
	on_receive_giftequip_buyitem_back_event = function(result, shopIdx, rewardResult)
		--print("收到限时商品充值返回", iErrCode)
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm_Equip
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--如果存在上一次交易的id，那么取消该交易的等待状态
		if (current_focus_achievementEx_idx > 0) then
			--隐藏菊花
			if _frmNode.childUI["AchievementNode" .. current_focus_achievementEx_idx] then
				_frmNode.childUI["AchievementNode" .. current_focus_achievementEx_idx].childUI["waiting"].handle.s:setVisible(false)
				
				--[[
				--正常按钮
				hApi.AddShader(_frmNode.childUI["AchievementNode" .. current_focus_achievementEx_idx].handle.s, "normal") --亮掉图片
				hApi.AddShader(_frmNode.childUI["AchievementNode" .. current_focus_achievementEx_idx].childUI["ConfimBtn"].handle.s, "normal") --亮掉图片
				]]
			end
			
			--标记当前正在交易的id为0
			current_focus_achievementEx_idx = 0
		end
		
		--购买成功
		if (result == 1) then
			--再次发起查询特惠礼包装备信息
			SendCmdFunc["require_giftequip_info"]()
		end
	end
	
	--函数：显示某个充值道具的tip
	ShowPurchaseTip = function(idxEx)
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm_Equip
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local listI = current_EquipInfo[idxEx] --第i项
		if (listI) then --存在充值信息第i项表
			local reward = listI.reward --奖励表
			local iCount = listI.iCount or 0 --已购买次数
			local iMaxCount = listI.iMaxCount or 1 --最大购买次数
			local goldCost = listI.goldCost or 0 --需要的游戏币
			
			--绘制tip
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
				z = hZorder.EquipTip,
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
					hGlobal.UI.PurchaseInfoFram:del()
					hGlobal.UI.PurchaseInfoFram = nil
				end,
			})
			
			--创建游戏币图片背景
			--[[
			_GameCoinTipChildUI["ItemBG_1"] = hUI.image:new({
				parent = _GameCoinTipParent,
				--model = "UI_frm:slot",
				--animation = "normal",
				model = "UI:TacticBG",
				x = _offX,
				y = _offY - 235,
				w = 250,
				h = 380,
			})
			_GameCoinTipChildUI["ItemBG_1"].handle.s:setOpacity(204) --战术卡tip背景图片透明度为204
			]]
			--local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", _offX, _offY - 235, 250, 380, hGlobal.UI.PurchaseInfoFram)
			--img9:setOpacity(204)
			local img9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/itemtip.png", _offX, _offY - 235, 680, 480, hGlobal.UI.PurchaseInfoFram)
			
			--底板
			--[[
			--创建游戏币图标
			_GameCoinTipChildUI["TacticIcon"] = hUI.image:new({
				parent = _GameCoinTipParent,
				model = "icon/item/iap_gift_lv" .. idxEx .. ".png",
				x = _offX - 76 - 8,
				y = _offY - 65-10,
				z = 1,
				w = 72,
				h = 72,
			})
			]]
			--创建游戏币名称
			local titleColor = ccc3(255, 255, 0)
			_GameCoinTipChildUI["TacticName"] = hUI.label:new({
				parent = _GameCoinTipParent,
				size = 30,
				x = _offX + 40 - 40,
				y = _offY - 60 - 8 - 10,
				width = 300,
				align = "MC",
				font = hVar.FONTC,
				text = hVar.tab_string["__TEXT_Page_Equip2"],
				border = 1,
			})
			_GameCoinTipChildUI["TacticName"].handle.s:setColor(titleColor)
			
			--[[
			--游戏币描述
			_GameCoinTipChildUI["TacticIntro"] = hUI.label:new({
				parent = _GameCoinTipParent,
				size = 26,
				x = _offX - 120,
				y = _offY - 150-10,
				width = 250,
				align = "LT",
				font = hVar.FONTC,
				text = hVar.tab_string["__TEXT_GIFT_CONTAIN"],
				border = 1,
				RGB = {244, 244, 244,},
			})
			]]
			
			local img9Width = 480
			if (#reward >= 5) then
				img9Width = 600
			end
			local img9 = hApi.CCScale9SpriteCreate("data/image/misc/treasure/medal_content.png", _offX, _offY - 235, img9Width, 150, hGlobal.UI.PurchaseInfoFram)
			
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
				
				--特殊数量的数字，用图片表示
				if (rewardType == 6) or (rewardType == 11) or (rewardType == 11) or (rewardType == 101) or (rewardType == 103) or (rewardType == 105) or (rewardType == 106) or (rewardType == 107) or (rewardType == 108) then
					if (itemNum == 1) then
						_GameCoinTipChildUI["rewardBtn_" .. i].childUI["gamecoinsLabel"]:setText("")
					elseif (itemNum == 5) then
						_GameCoinTipChildUI["rewardBtn_" .. i].childUI["gamecoinsLabel"]:setText("")
						
						--数量x10的图标
						_GameCoinTipChildUI["rewardBtn_" .. i].childUI["icon"].childUI["debris5Icon"] = hUI.image:new({
							parent = _GameCoinTipChildUI["rewardBtn_" .. i].childUI["icon"].handle._n,
							model = "ICON:debris_5",
							x = 0,
							y = -40,
							z = 100,
							scale = 1,
						})
					elseif (itemNum == 10) then
						_GameCoinTipChildUI["rewardBtn_" .. i].childUI["gamecoinsLabel"]:setText("")
						
						--数量x10的图标
						_GameCoinTipChildUI["rewardBtn_" .. i].childUI["icon"].childUI["debris10Icon"] = hUI.image:new({
							parent = _GameCoinTipChildUI["rewardBtn_" .. i].childUI["icon"].handle._n,
							model = "ICON:debris_10",
							x = 0,
							y = -40,
							z = 100,
							scale = 1,
						})
					elseif (itemNum == 50) then
						_GameCoinTipChildUI["rewardBtn_" .. i].childUI["gamecoinsLabel"]:setText("")
						
						--数量x50的图标
						_GameCoinTipChildUI["rewardBtn_" .. i].childUI["icon"].childUI["debris50Icon"] = hUI.image:new({
							parent = _GameCoinTipChildUI["rewardBtn_" .. i].childUI["icon"].handle._n,
							model = "ICON:debris_50",
							x = 0,
							y = -40,
							z = 100,
							scale = 1,
						})
					elseif (itemNum == 88) then
						_GameCoinTipChildUI["rewardBtn_" .. i].childUI["gamecoinsLabel"]:setText("")
						
						--数量x88的图标
						_GameCoinTipChildUI["rewardBtn_" .. i].childUI["icon"].childUI["debris88Icon"] = hUI.image:new({
							parent = _GameCoinTipChildUI["rewardBtn_" .. i].childUI["icon"].handle._n,
							model = "ICON:debris_88",
							x = 0,
							y = -40,
							z = 100,
							scale = 1,
						})
					elseif (itemNum == 100) then
						_GameCoinTipChildUI["rewardBtn_" .. i].childUI["gamecoinsLabel"]:setText("")
						
						--数量x100的图标
						_GameCoinTipChildUI["rewardBtn_" .. i].childUI["icon"].childUI["debris100Icon"] = hUI.image:new({
							parent = _GameCoinTipChildUI["rewardBtn_" .. i].childUI["icon"].handle._n,
							model = "ICON:debris_100",
							x = 0,
							y = -40,
							z = 100,
							scale = 1,
						})
					elseif (itemNum == 188) then
						_GameCoinTipChildUI["rewardBtn_" .. i].childUI["gamecoinsLabel"]:setText("")
						
						--数量x188的图标
						_GameCoinTipChildUI["rewardBtn_" .. i].childUI["icon"].childUI["debris188Icon"] = hUI.image:new({
							parent = _GameCoinTipChildUI["rewardBtn_" .. i].childUI["icon"].handle._n,
							model = "ICON:debris_188",
							x = 0,
							y = -40,
							z = 100,
							scale = 1,
						})
					elseif (itemNum == 300) then
						_GameCoinTipChildUI["rewardBtn_" .. i].childUI["gamecoinsLabel"]:setText("")
						
						--数量x188的图标
						_GameCoinTipChildUI["rewardBtn_" .. i].childUI["icon"].childUI["debris300Icon"] = hUI.image:new({
							parent = _GameCoinTipChildUI["rewardBtn_" .. i].childUI["icon"].handle._n,
							model = "ICON:debris_300",
							x = 0,
							y = -40,
							z = 100,
							scale = 1,
						})
					end
				end
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
					--充值
					OnSelectChargeMoneyButton(idxEx)
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
				text = goldCost,
			})
			if (iCount >= iMaxCount) then
				_GameCoinTipChildUI["BtnBuy"]:setstate(-1)
			end
			
			--已购买的图片
			_GameCoinTipChildUI["BtnBuyTag"] = hUI.image:new({
				parent = _GameCoinTipParent,
				model = "UI:FinishTag4",
				x = _offX,
				y = _offY - 400,
				scale = 1.0,
			})
			_GameCoinTipChildUI["BtnBuyTag"].handle._n:setRotation(15)
			if (iCount < iMaxCount) then
				_GameCoinTipChildUI["BtnBuyTag"].handle._n:setVisible(false)
			end
		end
	end
	
	--函数：关闭本界面
	OnClosePanel = function()
		--不显示充值面板
		hGlobal.UI.PhoneChargeMoneyFrm_Equip:show(0)
		
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
		--hGlobal.event:listen("LocalEvent_OnIapList_Back", "__IapGiftListBack", nil)
		--移除事件监听：充值成功或失败的回调
		--hGlobal.event:listen("LocalEvent_Purchase_Back", "__PurchaseGiftBack", nil)
		--移除事件监听：首充奖励的回调
		--hGlobal.event:listen("LocalEvent_SetgiftFrmBtnState", "__GiftBack2", nil)
		--移除事件监听：获得VIP等级和领取状态事件
		--hGlobal.event:listen("LocalEvent_GetVipState_New", "__PurchaseGetVipStateGiftBack", nil)
		--移除事件监听：获得VIP领取状态事件
		--hGlobal.event:listen("LocalEvent_GetVipDailyRewardFlag", "__PurchaseDailyRewardGiftBack", nil)
		--移除事件监听：收到玩家特惠装备信息返回结果
		hGlobal.event:listen("localEvent_OnReceiveGiftEquipInfo_Ret", "__GiftEquipInfo", nil)
		--移除事件监听：收到玩家购买特惠装备结果返回
		hGlobal.event:listen("localEvent_OnReceiveGiftEquipBuyItem_Ret", "__GiftEquipBuyItemBack", nil)
		--移除事件监听：充值信息列表回调（仅限苹果）
		--hGlobal.event:listen("LocalEvent_OnIapList_Back", "__IapGiftListBack", nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__PurchaseGiftSpinScreen", nil)
		
		--移除timer
		hApi.clearTimer("__TASK_TIMER_UPDATE__")
		
		--删除充值刷新界面timer
		hApi.clearTimer("__CHARGE_MONEY_EQUIP_UPDATE__")
		
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
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm_Equip
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
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm_Equip
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
	
	--[[
	--监听允许响应打开充值界面事件
	hGlobal.event:listen("enablePhonePurchaseFrm", "__EnablePurchaseFrm", function()
		--允许打开
		_bCanCreate = true
	end)
	]]
end


--监听充值界面通知事件
hGlobal.event:listen("LocalEvent_InitInAppPurchaseGiftFrm_Equip", "__ShowChargeMoneyFrm", function(callback, bOpenImmediate)
	--print("监听充值界面通知事件",callback, bOpenImmediate)
	hGlobal.UI.InitChargeMoneyFrm_Equip("reload")
	
	--直接打开
	if bOpenImmediate then
		--触发事件，显示积分、金币界面
		--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
		
		--显示道具界面
		hGlobal.UI.PhoneChargeMoneyFrm_Equip:show(1)
		hGlobal.UI.PhoneChargeMoneyFrm_Equip:active()
		
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
		hApi.addTimerForever("__CHARGE_MONEY_EQUIP_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, function()
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
			hGlobal.UI.PhoneChargeMoneyFrm_Equip:show(1)
			hGlobal.UI.PhoneChargeMoneyFrm_Equip:active()
			
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
			hApi.addTimerForever("__CHARGE_MONEY_EQUIP_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, function()
				refresh_achievement_UI_loop()
			end)
			
			--初始设置坐标
			--主面板设置到左侧屏幕外面
			local _frm = hGlobal.UI.PhoneChargeMoneyFrm_Equip
			local dx = BOARD_WIDTH
			_frm:setXY(_frm.data.x + dx, _frm.data.y)
		end)
		
		--步骤2: 动画进入控件
		local actM2 = CCCallFunc:create(function()
			--本面板
			local _frm = hGlobal.UI.PhoneChargeMoneyFrm_Equip
			
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
		local _frm = hGlobal.UI.PhoneChargeMoneyFrm_Equip
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
hGlobal.event:listen("clearPhoneChestFrm", "__ClosePurchaseGiftFrm", function()
	if hGlobal.UI.PhoneChargeMoneyFrm_Equip then
		if (hGlobal.UI.PhoneChargeMoneyFrm_Equip.data.show == 1) then
			--关闭本界面
			OnClosePanel()
		end
		
		--允许再次打开
		_bCanCreate = true
	end
end)


--测试 --test
--[[
--测试代码
if hGlobal.UI.PhoneChargeMoneyFrm_Equip then --删除上一次的充值界面
	hGlobal.UI.PhoneChargeMoneyFrm_Equip:del()
	hGlobal.UI.PhoneChargeMoneyFrm_Equip = nil
end
hGlobal.UI.InitChargeMoneyFrm_Equip("reload") --测试
--触发事件，显示充值界面
hGlobal.event:event("LocalEvent_InitInAppPurchaseGiftFrm_Equip")
]]
