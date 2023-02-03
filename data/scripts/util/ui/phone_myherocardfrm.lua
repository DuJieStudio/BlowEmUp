




--新的英雄令、图鉴、神器、塔、战术卡面板
hGlobal.UI.InitHeroCardFrm_New = function(mode)
	--不重复创建
	if hGlobal.UI.Phone_MyHeroCardFrm_New then --新的选择英雄令、图鉴面板
		return
	end
	
	local BOARD_WIDTH = 1280 --英雄令、图鉴面板的宽度
	local BOARD_HEIGHT = 760 --英雄令、图鉴面板的高度
	--local BOARD_OFFSETY = -20 --英雄令、图鉴面板y偏移中心点的值
	--local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 --英雄令、图鉴面板的x位置（最左侧）
	--local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --英雄令、图鉴面板的y位置（最顶侧）
	--local BOARD_ACTIVE_WIDTH = 508 --英雄令、图鉴面板活动宽度（卡牌显示的宽度）
	--界面整体缩放比例
	local _ScaleW = hVar.SCREEN.w / 1280
	local _ScaleH = hVar.SCREEN.h / 768
	
	--local PAGE_BTN_LEFT_X = 120 --第一个分页按钮的x偏移
	--local PAGE_BTN_LEFT_Y = -23 --第一个分页按钮的y偏移
	local PAGE_BTN_OFFSET_X = 165 --每个分页按钮的间距
	
	--临时UI管理
	local leftRemoveFrmList = {} --左侧控件集
	local rightRemoveFrmList = {} --右侧控件集
	local _removeLeftFrmFunc = hApi.DoNothing --清空左侧所有的临时控件
	local _removeRightFrmFunc = hApi.DoNothing --清空右侧所有的临时控件
	
	--局部函数
	--公共分页部分
	local OnClosePanelFrame = hApi.DoNothing --关闭本面板
	local OnClickPageBtn = hApi.DoNothing --点击分页按钮
	local RefreshGuideUpgratePage = hApi.DoNothing --更新提示当前哪个分页可以升级了
	
	--分页1:英雄令
	local OnCreateHeroCardFrame = hApi.DoNothing --创建英雄令的升级图界面（第1个分页）
	local OnCreateSingleHeroCard = hApi.DoNothing --创建单个英雄卡牌控件
	local refresh_herocard_UI_scroll_loop = hApi.DoNothing --自动调整英雄令控件的滑动
	local OnClickHeroCardBtn = hApi.DoNothing --点击英雄卡的按钮
	local RefreshHeroCardUpgrateSubPage = hApi.DoNothing --更新提示当前英雄令的哪个子分页可以升级了
	
	--分页2:图鉴(暂时不显示)
	local OnCreateTuJianDiagramFrame = hApi.DoNothing --创建图鉴界面（第2个分页）
	local ShowChapterTuJianListFrame = hApi.DoNothing --显示指定章节下的全部怪物列表界面
	local OnCreateSingleEnemyIcon = hApi.DoNothing --创建单个怪物图标控件
	local refresh_tujian_UI_scroll_loop = hApi.DoNothing --自动调整图鉴控件的滑动
	local OnClickTuJianCardBtn = hApi.DoNothing --点击图鉴卡的按钮
	--local OnCreateLifeTipFrame = hApi.DoNothing --查看/隐藏 图鉴卡漏怪扣除血量说明tip
	--local OnCreateGoldTipFrame = hApi.DoNothing --查看/隐藏 图鉴卡金钱说明tip
	--local OnCreateSkillTipFrame = hApi.DoNothing --查看图鉴卡技能说明tip
	
	--分页2:神器
	local OnCreateShenQiEquipmentFrame = hApi.DoNothing --创建神器界面（第3个分页）
	local OnCreateRedEquip = hApi.DoNothing --创建单个神器控件
	local OnCreateRedEquipTip = hApi.DoNothing --创建红装的tip
	local OnClickedEquipBtn = hApi.DoNothing --点击神器的按钮
	local refresh_redequip_UI_scroll_loop = hApi.DoNothing --自动调整神器控件的滑动
	
	--分页3:塔
	local GetFirstLvUpTowerCardIdx = hApi.DoNothing --获得第一个可以升级的塔的索引
	local OnCreateTowerArchyDiagramFrame = hApi.DoNothing --创建分支类塔的升级图界面（第3分页）（1、2、3个子分页）
	local OnClickTowerBtn = hApi.DoNothing --点击塔的按钮
	local OnCreateSpecialDiagramFrame = hApi.DoNothing --创建特种塔的升级图界面（第3分页）（第4个子分页）
	local OnCreateSingleSpecialCard = hApi.DoNothing --创建单个特种塔控件
	local GetFirstLvUpSpecialTowerIdx = hApi.DoNothing --获得第一个可以升级的特种塔的索引
	local OnClickSpecialTowerBtn = hApi.DoNothing --点击特种塔的按钮
	local CalSpecialCardIndex = hApi.DoNothing --计算某个特种塔的索引值
	local RefreshTowerUpgrateSubPage = hApi.DoNothing --更新提示当前塔的哪个子分页可以升级了
	
	--分页4:一般战术技能卡
	local OnCreateTacticDiagramFrame = hApi.DoNothing --创建战术技能卡的升级图界面（第4个分页）
	local GetFirstLvUpTacticCardIdx = hApi.DoNothing --获得第一个可以升级的战术技能卡的索引
	local OnCreateSingleTacticCard = hApi.DoNothing --创建单个战术技能卡控件
	local refresh_tacitc_UI_scroll_loop = hApi.DoNothing --自动调整战术技能卡控件的滑动
	local CalTacticCardIndex = hApi.DoNothing --计算某个一般战术技能卡的索引值
	local OnClickTacticBtn = hApi.DoNothing --点击一般战术技能卡的按钮
	local OnClickLvUpButton = hApi.DoNothing --点击升级战术技能卡按钮
	local OnCreateSkillTipFrame = hApi.DoNothing --查看塔的技能说明tip
	local RefreshSelectedCardFrame = hApi.DoNothing --更新绘制当前查看的卡牌的信息
	
	--变量部分
	--分页1:英雄令
	local HERO_CARD_WIDTH = 160 --英雄令的宽度
	local HERO_CARD_HEIGHT = 205 --英雄令的高度
	local HERO_CARD_X_NUM = 5 --英雄令x方向数量
	local HERO_CARD_Y_NUM = 2 --英雄令y方向数量
	if (g_phone_mode ~= 0) then --手机模式
		HERO_CARD_X_NUM = 6 --英雄令x方向数量
		
		--iphone4
		if (hVar.SCREEN.w <= 960) then
			HERO_CARD_X_NUM = 5 --英雄令x方向数量
		end
	end
	local HERO_CARD_DISTANCE_X = 180
	local HERO_CARD_DISTANCE_Y = 235
	local HERO_CARD_OSSSET_XL = (hVar.SCREEN.w - HERO_CARD_DISTANCE_X * HERO_CARD_X_NUM) / 2 +  6 * _ScaleH --第一个英雄的x位置
	local HERO_CARD_OSSSET_Y = 0 - 60 * _ScaleH + 2 * _ScaleH - HERO_CARD_HEIGHT / 2 - 25 * _ScaleH --第一个英雄的y位置
	local HERO_CARD_OSSSET_YB = -hVar.SCREEN.h + 84 * _ScaleH + 10 / 2 * _ScaleH --最后一个英雄的y位置
	--local HERO_PANEL_HEIGHT = 420 --英雄令面板的高度
	
	--参数
	--英雄令界面相关参数
	local MAX_SPEED_HEROCARD = 50 --英雄卡最大速度
	local click_pos_x_herocard = 0 --英雄卡开始按下的坐标x
	local click_pos_y_herocard = 0 --英雄卡开始按下的坐标y
	local last_click_pos_x_herocard = 0 --英雄卡上一次按下的坐标x
	local last_click_pos_y_herocard = 0 --英雄卡上一次按下的坐标y
	local draggle_speed_y_herocard = 0 --英雄卡当前滑动的速度x
	local selected_herocard_idx = 0 --英雄卡选中的索引
	local click_scroll_herocard = false --英雄卡是否在滑动中
	local b_need_auto_fixing_herocard = false --英雄卡是否需要自动修正
	local friction_herocard = 0 --阻力
	
	--分页2:图鉴
	local TUJIAN_CARD_WIDTH = 76 --图鉴卡的宽度
	local TUJIAN_CARD_HEIGHT = 76 --图鉴卡的高度
	local TUJIAN_CARD_X_NUM = 4 --图鉴卡x方向数量
	local TUJIAN_CARD_Y_NUM = 5 --图鉴卡y方向数量
	if (g_phone_mode ~= 0) then --手机模式
		TUJIAN_CARD_X_NUM = 5 --图鉴卡x方向数量
	end
	--local TUJIAN_CARD_OSSSET_XL = PAGE_BTN_LEFT_X - 35 --第一个图鉴卡的x位置
	--local TUJIAN_CARD_OSSSET_Y = PAGE_BTN_LEFT_Y - 107 --第一个图鉴卡的y位置
	local TUJIAN_CARD_DISTANCE_X = 96
	local TUJIAN_CARD_DISTANCE_Y = 96
	local TUJIAN_CARD_OSSSET_XL = 72 * _ScaleH --第一个图鉴卡的x位置
	local TUJIAN_CARD_OSSSET_Y = 0 - 60 * _ScaleH + 2 * _ScaleH - TUJIAN_CARD_HEIGHT / 2 - 20 * _ScaleH --第一个图鉴卡的y位置
	local TUJIAN_CARD_OSSSET_YB = -hVar.SCREEN.h + 84 * _ScaleH + 10 / 2 * _ScaleH --最后一个图鉴卡的y位置
	--local TUJIAN_PANEL_HEIGHT = 375 --一图鉴卡面板的高度
	--参数
	--图鉴界面相关参数
	local MAX_SPEED_TUJIAN = 50 --图鉴最大速度
	local click_pos_x_tujian = 0 --图鉴开始按下的坐标x
	local click_pos_y_tujian = 0 --图鉴开始按下的坐标y
	local last_click_pos_x_tujian = 0 --图鉴上一次按下的坐标x
	local last_click_pos_y_tujian = 0 --图鉴上一次按下的坐标y
	local draggle_speed_y_tujian = 0 --图鉴当前滑动的速度x
	local selected_tujian_idx = 0 --图鉴选中的索引
	local click_scroll_tujian = false --图鉴是否在滑动中
	local b_need_auto_fixing_tujian = false --图鉴是否需要自动修正
	local friction_tujian = 0 --图鉴阻力
	local tujian_chapterId = 1 --当前显示的图鉴章节
	
	--分页2:神器
	local REDEQUIP_WIDTH = 110 --神器的宽度
	local REDEQUIP_HEIGHT = 110 --神器的高度
	local REDEQUIP_X_NUM = 6 --神器x方向数量
	local REDEQUIP_Y_NUM = 4 --神器y方向数量
	if (g_phone_mode ~= 0) then --手机模式
		REDEQUIP_Y_NUM = 4 --神器y方向数量
	end
	local REDEQUIP_OSSSET_XL = 30 * _ScaleH --第一个神器的x位置
	if (g_phone_mode ~= 0) then --手机模式
		REDEQUIP_OSSSET_XL = 50 * _ScaleH --第一个神器的x位置
		
		--iphone4
		if (hVar.SCREEN.w <= 960) then
			REDEQUIP_OSSSET_XL = 30 * _ScaleH --第一个神器的x位置
		end
	end
	local REDEQUIP_OSSSET_Y = 0 - 60 * _ScaleH + 2 * _ScaleH - TUJIAN_CARD_HEIGHT / 2 - 50 * _ScaleH --第一个神器的y位置
	local REDEQUIP_OSSSET_YB = -hVar.SCREEN.h + 84 * _ScaleH + 10 / 2 * _ScaleH --最后一个神器的y位置
	local REDEQUIP_DISTANCE_X = 100 --神器X间距
	if (g_phone_mode ~= 0) then --手机模式
		REDEQUIP_DISTANCE_X = 115 --神器X间距
		
		--iphone4
		if (hVar.SCREEN.w <= 960) then
			REDEQUIP_DISTANCE_X = 90 --神器X间距
		end
	end
	local REDEQUIP_DISTANCE_Y = 110
	local REDEQUIP_PANEL_HEIGHT = 420 --神器面板的高度
	local REDEQUIP_TYPESECTION_HEIGHT = 10 --神器类型分组之间的间隔
	--local REDEQUIP_TITLE_HEIGHT = 40 --神器类型title与神器图标的间隔
	local REDEQUIP_ROWNUM_PERTYPE = 1 --每个类型有多少行
	
	--神器界面相关参数
	local MAX_SPEED_REDEQUIP = 50 --神器最大速度
	local click_pos_x_redequip = 0 --神器开始按下的坐标x
	local click_pos_y_redequip = 0 --神器开始按下的坐标y
	local last_click_pos_x_redequip = 0 --神器上一次按下的坐标x
	local last_click_pos_y_redequip = 0 --神器上一次按下的坐标y
	local draggle_speed_y_redequip = 0 --神器当前滑动的速度x
	local selected_redequip_idx = 0 --神器选中的索引
	local click_scroll_redequip = false --神器是否在滑动中
	local b_need_auto_fixing_redequip = false --神器是否需要自动修正
	local friction_redequip = 0 --阻力
	--装备底座
	local _NSP_ItemSlotPath = {}				--【装备底座图案】
	do
		--黄金宝箱装备(可以被许愿产出的装备)  显示为黄色
		for i = 1,#hVar.WISHING_WELL_ITEM do
			local id = hVar.WISHING_WELL_ITEM[i]
			_NSP_ItemSlotPath[id] = 1
		end
		--vip装备 显示为红色
		for i = 1,#hVar.VIP_GIFT_ITEM do
			local id = hVar.VIP_GIFT_ITEM[i]
			_NSP_ItemSlotPath[id] = 2
		end
	end
	
	--分页3: 塔
	--参数
	--箭塔配置参数
	local baseTowercardId_jianta = 10001 --箭塔的最原始塔的类型id
	local mediumTowetcardId_jianta = 10002 --箭塔第一次升级的塔的类型id
	local archyTacticCardList_jianta = hVar.TACTIC_UPDATE_JIANTA --箭塔升级的分支战术技能卡
	--法术塔配置信息
	local baseTowercardId_fashu = 10201 --法术塔的最原始塔的类型id
	local mediumTowetcardId_fashu = 10202 --法术塔第一次升级的塔的类型id
	local archyTacticCardList_fashu = hVar.TACTIC_UPDATE_FASHUTA --法术塔升级的分支战术技能卡
	--炮塔配置信息
	local baseTowercardId_paota = 10101 --炮塔的最原始塔的类型id
	local mediumTowetcardId_paota = 10102 --炮塔第一次升级的塔的类型id
	local archyTacticCardList_paota = hVar.TACTIC_UPDATE_PAOTA --炮塔升级的分支战术技能卡
	
	--特种塔界面相关参数
	local SPECIAL_CARD_WIDTH = 86 --特种塔卡的宽度
	local SPECIAL_CARD_HEIGHT = 86 --特种塔的高度
	--local SPECIAL_X_NUM = 4 --特种塔x方向数量
	--local SPECIAL_Y_NUM = 3 --特种塔y方向数量
	local SPECIAL_CARD_DISTANCE_X = 107
	local SPECIAL_CARD_DISTANCE_Y = 105
	--local selected_specialEx_idx = 0 --特种塔选中的ex索引
	
	--分页4: 一般战术卡
	--一般战术卡界面相关参数
	local TACTIC_CARD_WIDTH = 90 --战术技能卡的宽度
	local TACTIC_CARD_HEIGHT = 112 --战术技能卡的高度
	local TACTIC_X_NUM = 4 --战术卡x方向数量
	if (g_phone_mode ~= 0) then --手机模式
		TACTIC_X_NUM = 5 --战术卡x方向数量
		
		--iphone4
		if (hVar.SCREEN.w <= 960) then
			TACTIC_X_NUM = 4 --战术卡x方向数量
		end
	end
	local TACTIC_Y_NUM = 4 --战术卡y方向数量
	local TACTIC_CARD_OSSSET_XL = 110 * _ScaleH --第一个战术技能卡的x位置
	if (g_phone_mode ~= 0) then --手机模式
		TACTIC_CARD_OSSSET_XL = 140 * _ScaleH --第一个战术技能卡的x位置
		
		--iphone4
		if (hVar.SCREEN.w <= 960) then
			TACTIC_CARD_OSSSET_XL = 120 * _ScaleH --第一个战术技能卡的x位置
		end
	end
	local TACTIC_CARD_OSSSET_Y = 0 - 92 * _ScaleH + 2 * _ScaleH - TUJIAN_CARD_HEIGHT / 2 --第一个战术技能卡的y位置
	local TACTIC_CARD_OSSSET_YB = -hVar.SCREEN.h + 84 * _ScaleH + 10 / 2 * _ScaleH --最后一个战术技能卡的y位置
	local TACTIC_CARD_DISTANCE_X = 103
	local TACTIC_CARD_DISTANCE_Y = 125
	--local TACTIC_PANEL_HEIGHT = 440 --一般战术技能卡面板的高度
	local MAX_SPEED_TACTIC = 50 --战术卡最大速度
	
	local click_pos_x_tactic = 0 --战术卡开始按下的坐标x
	local click_pos_y_tactic = 0 --战术卡开始按下的坐标y
	local last_click_pos_x_tactic = 0 --战术卡上一次按下的坐标x
	local last_click_pos_y_tactic = 0 --战术卡上一次按下的坐标y
	local draggle_speed_y_tactic = 0 --战术卡战术卡当前滑动的速度x
	local selected_tacticEx_idx = 0 --战术卡选中的成就ex索引
	local click_scroll_tactic = false --战术卡是否在滑动成就中
	local b_need_auto_fixing_tactic = false --战术卡是否需要自动修正
	local friction_tactic = 0 --战术卡阻力
	
	--公共分页部分参数
	--当前选中的记录
	local CurrentSelectRecord = {pageIdx = 0, subPageIdx = 0, contentIdx = 0, cardId = 0,} --当前选择的分页索引、数据项索引，卡牌id的信息记录
	
	--移除监听
	--监听积分改变事件
	hGlobal.event:listen("LocalEvent_SetCurGameScore", "__RefreshHeroCardFrm__", nil)
	--监听金币改变事件
	hGlobal.event:listen("LocalEvent_SetCurGameCoin", "__RefreshHeroCardFrm__", nil)
	--监听金币改变（手机版）事件
	hGlobal.event:listen("LocalEvent_Phone_SetCurGameCoin_Game", "__RefreshHeroCardFrm__", nil)
	--监听获得战术技能卡（碎片）事件
	hGlobal.event:listen("Event_PlayerGetTacticCard", "__RefreshHeroCardFrm__", nil)
	--监听英雄技能升级返回事件
	hGlobal.event:listen("Local_Event_HeroSkill_LvUp_Result", "__RefreshHeroCardFrm__", nil)
	--监听通知刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
	hGlobal.event:listen("LocalEvent_RefreshMedalStateUI", "__RefreshHeroCardFrm__", nil)
	
	--加载资源
	--xlLoadResourceFromPList("data/image/misc/pvp.plist")
	hApi.clearTimer("__HEROCARD_TIMER_UPDATE__")
	hApi.clearTimer("__TUJIAN_TIMER_UPDATE__")
	hApi.clearTimer("__REDEQUIP_TIMER_UPDATE__")
	hApi.clearTimer("__TACTIC_TIMER_UPDATE__")
	
	--创建英雄令、图鉴父控件（新）
	hGlobal.UI.Phone_MyHeroCardFrm_New = hUI.frame:new(
	{
		x = 0,
		y = hVar.SCREEN.h,
		w = hVar.SCREEN.w,
		h = hVar.SCREEN.h,
		dragable = 2,
		show = 0, --一开始不显示
		--border = 1, --显示frame边框
		--background = "UI:Tactic_Background",
		border = -1, --显示frame边框
		background = 0,
		autoactive = 0,
		--全部事件
		--codeOnDragEx = function(touchX, touchY, touchMode)
			--
		--end,
	})
	
	local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
	local _parent = _frm.handle._n
	
	--左侧裁剪区域-英雄令
	local _BTC_PageClippingRect_HeroCard = {0, -60 * _ScaleH - 0 * _ScaleH, 2000, hVar.SCREEN.h - 60 * _ScaleH - 84 * _ScaleH + 10 * _ScaleH, 0}
	local _BTC_pClipNode_HeroCard = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect_HeroCard, -1, _BTC_PageClippingRect_HeroCard[5], "_BTC_pClipNode_HeroCard")
	
	--左侧裁剪区域-图鉴
	local _BTC_PageClippingRect_TuJianCard = {0, -60 * _ScaleH - 0 * _ScaleH, 2000, hVar.SCREEN.h - 60 * _ScaleH - 84 * _ScaleH + 10 * _ScaleH - 95 * _ScaleH, 0}
	local _BTC_pClipNode_TuJianCard = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect_TuJianCard, -1, _BTC_PageClippingRect_TuJianCard[5], "_BTC_pClipNode_TuJianCard")
	
	--左侧裁剪区域-红装
	local _BTC_PageClippingRect_RedEquip = {0, -60 * _ScaleH - 0 * _ScaleH, 2000, hVar.SCREEN.h - 60 * _ScaleH - 84 * _ScaleH + 10 * _ScaleH, 0}
	local _BTC_pClipNode_RedEquip = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect_RedEquip, -1, _BTC_PageClippingRect_RedEquip[5], "_BTC_pClipNode_RedEquip")
	
	
	--左侧裁剪区域-一般战术卡
	local _BTC_PageClippingRect_Tactic = {0, -60 * _ScaleH - 0 * _ScaleH, 2000, hVar.SCREEN.h - 60 * _ScaleH - 84 * _ScaleH + 10 * _ScaleH, 0}
	local _BTC_pClipNode_Tactic = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect_Tactic, 99, _BTC_PageClippingRect_Tactic[5], "_BTC_pClipNode_Tactic")
	
	--主界面顶部栏
	_frm.childUI["menu_top"] = hUI.button:new({
		parent = _frm.handle._n,
		model = "UI:PANEL_MENU_NEW_TOP",
		x = hVar.SCREEN.w / 2,
		y = -60 * _ScaleH / 2,
		w = hVar.SCREEN.w,
		h = 100 * _ScaleH,
	})
	
	--主界面底部栏
	_frm.childUI["menu_bottom2"] = hUI.button:new({
		parent = _frm.handle._n,
		model = "UI:PANEL_MENU_NEW_BOTTOM2",
		x = hVar.SCREEN.w / 2,
		y = -hVar.SCREEN.h + 84 * _ScaleH / 2,
		w = hVar.SCREEN.w,
		h = 84 * _ScaleH,
	})
	
	--关闭按钮（只响应事件，不显示）
	--btnClose
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		model = "misc/mask.png",
		--model = "BTN:PANEL_CLOSE",
		x = 56 * _ScaleW,
		y = -hVar.SCREEN.h + 34 * _ScaleH,
		w = 120,
		h = 120,
		scaleT = 0.95,
		code = function()
			--播放关闭按钮音效
			hApi.PlaySound("button")
			
			--关闭本面板
			OnClosePanelFrame()
		end,
	})
	_frm.childUI["closeBtn"].handle.s:setOpacity(0) --只响应事件，不显示
	_frm.childUI["closeBtn"].childUI["icon"] = hUI.image:new({
		parent = _frm.childUI["closeBtn"].handle._n,
		model = "UI:return",
		--model = "BTN:PANEL_CLOSE",
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
		--text = "点将台", --language
		text = hVar.tab_string["__TEXT_MAINUI_BTN_HERO"], --language
	})
	]]
	
	--每个分页按钮
	--英雄令、(图鉴 "ICON:Imperial_Academy" hVar.tab_string["__TEXT_TuJian"])、神器、塔、战术卡
	local tPageIcons = {"ICON:ReviveHero", "UI:shenqi", "MODEL_EFFECT:JIANTA1_BASE", "icon/item/card_lv3.png",}
	local tPageIconRot = {false, true, false, false,}
	--local tTexts = {"英雄令", "图鉴", "神器", "塔", "战术卡",} --language
	local tTexts = {hVar.tab_string["__TEXT_Card"], hVar.tab_string["__TEXT_ShenQi"], hVar.tab_string["__TEXT_SOLDIER_TOWER"], hVar.tab_string["TacticCardPage"],} --language
	
	--参数配置
	--iPad
	local nPageX = 0 --按钮x(距离右侧)
	local nPageY = 42 --按钮y(距离下侧)
	local nPageW = 170 --按钮宽度
	local nPageWL = 250 --长按钮宽度
	local nPageH = 84 --按钮高度
	local nPageOffsetX = 5 --每个按钮间间距微调值
	local nIconX = 0 --图标x
	local nIconY = 0 --图标y
	local nIconW = 56 --图标宽
	local nIconH = 56 --图标高
	local nIconXL = 0 --长图标x
	local nIconYL = 25 --长图标y
	local nIconWL = 70 --长图标宽
	local nIconHL = 70 --长图标高
	
	--[[
	if (g_phone_mode ~= 0) then --手机模式
		--参数配置
		--iPhone5
		nPageX = 0 --按钮x(距离右侧)
		nPageY = 42 --按钮y(距离下侧)
		nPageW = 170 --按钮宽度
		nPageWL = 250 --长按钮宽度
		nPageH = 84 --按钮高度
		nPageOffsetX = 5 --每个按钮间间距微调值
		nIconX = 0 --图标x
		nIconY = 0 --图标y
		nIconW = 56 --图标宽
		nIconH = 56 --图标高
		nIconXL = 0 --长图标x
		nIconYL = 25 --长图标y
		nIconWL = 70 --长图标宽
		nIconHL = 70 --长图标高
		
		--iphone4
		if (hVar.SCREEN.w <= 960) then
			--参数配置
			--iPhone4
			nPageX = 0 --按钮x(距离右侧)
			nPageY = 42 --按钮y(距离下侧)
			nPageW = 170 --按钮宽度
			nPageWL = 250 --长按钮宽度
			nPageH = 84 --按钮高度
			nPageOffsetX = 5 --每个按钮间间距微调值
			nIconX = 0 --图标x
			nIconY = 0 --图标y
			nIconW = 56 --图标宽
			nIconH = 56 --图标高
			nIconXL = 0 --长图标x
			nIconYL = 25 --长图标y
			nIconWL = 70 --长图标宽
			nIconHL = 70 --长图标高
		end
	end
	]]
	
	--依次绘制
	for i = 1, #tPageIcons, 1 do
		--分页按钮
		_frm.childUI["PageBtn" .. i] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			x = hVar.SCREEN.w + nPageX * _ScaleW - (#tPageIcons - i) * nPageW * _ScaleW - nPageW / 2 * _ScaleW + (#tPageIcons - i) * nPageOffsetX * _ScaleW,
			y = -hVar.SCREEN.h + nPageY * _ScaleH,
			w = nPageW * _ScaleW,
			h = nPageH * _ScaleH,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.0,
			code = function(self, screenX, screenY, isInside)
				OnClickPageBtn(i, true)
			end,
		})
		_frm.childUI["PageBtn" .. i].handle.s:setOpacity(0) --分页按钮的控制部分，用于处理响应，不显示
		
		--分页按钮的方块图标
		_frm.childUI["PageBtn" .. i].childUI["PageImage"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = "UI:PANEL_MENU_BTN_NORMAL", --"UI:ChestBag_2", --"UI:Tactic_Button",
			x = 0,
			y = 0,
			w = nPageW * _ScaleW,
			h = nPageH * _ScaleH,
		})
		
		--分页按钮的图标
		_frm.childUI["PageBtn" .. i].childUI["PageIcon"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = tPageIcons[i],
			x = nIconX * _ScaleW,
			y = nIconY * _ScaleH,
			w = nIconW * math.max(_ScaleW, _ScaleH),
			h = nIconH * math.max(_ScaleW, _ScaleH),
		})
		if tPageIconRot and tPageIconRot[i] then
			_frm.childUI["PageBtn" .. i].childUI["PageIcon"].handle.s:setFlipX(true)
		end
		
		--分页按钮的提示升级的动态箭头标识
		_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = "ICON:image_jiantouV",
			x = 30,
			y = 30,
			w = 42,
			h = 42,
		})
		_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"].handle.s:setVisible(false) --默认一开始不显示提示该分页升级的动态箭头
		
		--分页按钮的文字
		_frm.childUI["PageBtn" .. i].childUI["Text"] = hUI.label:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			x = 0,
			y = -22 * _ScaleH,
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
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#rightRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, rightRemoveFrmList[i]) 
		end
		rightRemoveFrmList = {}
	end
	
	--关闭本页面
	OnClosePanelFrame = function()
		--按钮往下做运动
		for i = 1, #tPageIcons, 1 do
			local px, py = _frm.childUI["PageBtn" .. i].data.x, _frm.childUI["PageBtn" .. i].data.y
			local act1 = CCDelayTime:create(0.01 + 0.03 * i)
			local act2 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px, -hVar.SCREEN.h - 114 * _ScaleH / 2)))
			local act4 = CCCallFunc:create(function()
				--_frm.childUI["PageBtn" .. i].data.y = -hVar.SCREEN.h - 114 * _ScaleH / 2
				_frm.childUI["PageBtn" .. i]:setXY(px, -hVar.SCREEN.h - 114 * _ScaleH / 2)
			end)
			local a = CCArray:create()
			a:addObject(act1)
			a:addObject(act2)
			a:addObject(act4)
			local sequence = CCSequence:create(a)
			_frm.childUI["PageBtn" .. i].handle._n:stopAllActions() --先停掉之前可能的动画
			_frm.childUI["PageBtn" .. i].handle._n:runAction(sequence)
		end
		
		--主界面顶部栏往上做运动
		local px, py = _frm.childUI["menu_top"].data.x, _frm.childUI["menu_top"].data.y
		local act1 = CCDelayTime:create(0.12)
		local act2 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px, 100 * _ScaleH / 2)))
		local act4 = CCCallFunc:create(function()
			--_frm.childUI["menu_top"].data.y = 100 * _ScaleH / 2
			_frm.childUI["menu_top"]:setXY(px, 100 * _ScaleH / 2)
		end)
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_frm.childUI["menu_top"].handle._n:stopAllActions() --先停掉之前可能的动画
		_frm.childUI["menu_top"].handle._n:runAction(sequence)
		
		--主界面底部栏往下做运动
		local px, py = _frm.childUI["menu_bottom2"].data.x, _frm.childUI["menu_bottom2"].data.y
		local act1 = CCDelayTime:create(0.12)
		local act2 = CCEaseSineOut:create(CCMoveTo:create(0.16, ccp(px, -hVar.SCREEN.h - 125 * _ScaleH / 2)))
		local act4 = CCCallFunc:create(function()
			--_frm.childUI["menu_bottom2"].data.y = -hVar.SCREEN.h - 125 * _ScaleH / 2
			_frm.childUI["menu_bottom2"]:setXY(px, -hVar.SCREEN.h - 125 * _ScaleH / 2)
		end)
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_frm.childUI["menu_bottom2"].handle._n:stopAllActions() --先停掉之前可能的动画
		_frm.childUI["menu_bottom2"].handle._n:runAction(sequence)
		
		--本面板
		--往左做运动
		local px, py = _frm.data.x, _frm.data.y
		local act1 = CCDelayTime:create(0.28)
		local act2 = CCEaseSineIn:create(CCMoveTo:create(0.18, ccp(-hVar.SCREEN.w, py)))
		local act4 = CCCallFunc:create(function()
			--_frm.data.x = -hVar.SCREEN.w
			_frm:setXY(-hVar.SCREEN.w, py)
			
			--不显示金币界面
			hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
			
			--不显示点将台、图鉴面板
			hGlobal.UI.Phone_MyHeroCardFrm_New:show(0)
			
			--清空上次分页的全部信息
			_removeLeftFrmFunc()
			_removeRightFrmFunc()
			
			--移除监听
			hGlobal.event:listen("LocalEvent_SetCurGameScore", "__RefreshHeroCardFrm__", nil)
			--监听金币改变事件
			hGlobal.event:listen("LocalEvent_SetCurGameCoin", "__RefreshHeroCardFrm__", nil)
			--监听金币改变（手机版）事件
			hGlobal.event:listen("LocalEvent_Phone_SetCurGameCoin_Game", "__RefreshHeroCardFrm__", nil)
			--监听获得战术技能卡（碎片）事件
			hGlobal.event:listen("Event_PlayerGetTacticCard", "__RefreshHeroCardFrm__", nil)
			--监听英雄技能升级返回事件
			hGlobal.event:listen("Local_Event_HeroSkill_LvUp_Result", "__RefreshHeroCardFrm__", nil)
			--监听通知刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
			hGlobal.event:listen("LocalEvent_RefreshMedalStateUI", "__RefreshHeroCardFrm__", nil)
			
			--删除英雄令自动调整滑动的timer
			hApi.clearTimer("__HEROCARD_TIMER_UPDATE__")
			
			--删除图鉴自动调整滑动的timer
			hApi.clearTimer("__TUJIAN_TIMER_UPDATE__")
			
			--删除红装自动调整滑动的timer
			hApi.clearTimer("__REDEQUIP_TIMER_UPDATE__")
			
			--删除战术卡自动调整滑动的tmier
			hApi.clearTimer("__TACTIC_TIMER_UPDATE__")
			
			hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
			
			--显示新主界面
			hGlobal.event:event("LocalEvent_new_mainmenu_frm", 1)
			
			--触发引导: 新主界面
			hGlobal.event:event("LocalEvent_EnterGuideProgress", hVar.PHONE_MAINDOTA, nil, "maindota")
		end)
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		_frm.handle._n:stopAllActions() --先停掉之前可能的动画
		_frm.handle._n:runAction(sequence)
	end
	
	--点击分页按钮函数
	OnClickPageBtn = function(pageIndex, bPlayAmin)
		--不重复显示同一个分页
		if (CurrentSelectRecord.pageIdx == pageIndex) then
			return
		end
		
		--print("OnClickPageBtn", pageIndex)
		
		--[[
		--当前按钮高亮
		hApi.AddShader(_frm.childUI["PageBtn" .. pageIndex].childUI["PageImage"].handle.s, "normal")
		
		--其它按钮灰掉
		for i = 1, #tPageIcons, 1 do
			if (i ~= pageIndex) then
				hApi.AddShader(_frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s, "gray")
			end
		end
		]]
		
		--所有的按钮重算位置，并做动画
		for i = 1, #tPageIcons, 1 do
			local toX = 0
			local toY = -hVar.SCREEN.h + nPageY * _ScaleH
			local toW = nPageW * _ScaleW
			local toH = nPageH * _ScaleH
			local toModel = "UI:PANEL_MENU_BTN_NORMAL"
			local iconModel = tPageIcons[i]
			local iconX = nIconX * _ScaleW
			local iconY = nIconY * _ScaleH
			local iconW = nIconW * math.max(_ScaleW, _ScaleH)
			local iconH = nIconH * math.max(_ScaleW, _ScaleH)
			local labelVisible = false
			
			if (i < pageIndex) then --左侧的
				toX = hVar.SCREEN.w + nPageX * _ScaleW - (#tPageIcons - i - 1) * nPageW * _ScaleW - nPageWL * _ScaleW - nPageW / 2 * _ScaleW + (#tPageIcons - i) * nPageOffsetX * _ScaleW
			elseif (i == pageIndex) then --自身
				toX = hVar.SCREEN.w + nPageX * _ScaleW - (#tPageIcons - i) * nPageW * _ScaleW - nPageWL / 2 * _ScaleW + (#tPageIcons - i) * nPageOffsetX * _ScaleW
				toW = nPageWL * _ScaleW
				toModel = "UI:PANEL_MENU_BTN_BIG"
				iconX = nIconXL * _ScaleW
				iconY = nIconYL * _ScaleH
				iconW = nIconWL * math.max(_ScaleW, _ScaleH)
				iconH = nIconHL * math.max(_ScaleW, _ScaleH)
				labelVisible = true
			else --右侧的
				toX = hVar.SCREEN.w + nPageX * _ScaleW - (#tPageIcons - i) * nPageW * _ScaleW - nPageW / 2 * _ScaleW + (#tPageIcons - i) * nPageOffsetX * _ScaleW
			end
			
			--_frm.childUI["PageBtn" .. i]:setXY(toX, toY)
			_frm.childUI["PageBtn" .. i].childUI["PageImage"]:setmodel(toModel, nil, nil, toW, toH)
			_frm.childUI["PageBtn" .. i].childUI["PageIcon"]:setmodel(iconModel, nil, nil, iconW, iconH)
			if tPageIconRot and tPageIconRot[i] then
				_frm.childUI["PageBtn" .. i].childUI["PageIcon"].handle.s:setFlipX(true)
			end
			_frm.childUI["PageBtn" .. i].childUI["PageIcon"]:setXY(iconX, iconY)
			_frm.childUI["PageBtn" .. i].childUI["Text"].handle._n:setVisible(labelVisible)
			
			if bPlayAmin then
				--主界面底部栏往上做运动
				local act1 = CCCallFunc:create(function()
					_frm.childUI["PageBtn" .. i].data.x = toX
				end)
				local act2 = CCMoveTo:create(0.03, ccp(toX, toY))
				local act3 = CCCallFunc:create(function()
					_frm.childUI["PageBtn" .. i]:setXY(toX, toY)
				end)
				local a = CCArray:create()
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act3)
				local sequence = CCSequence:create(a)
				_frm.childUI["PageBtn" .. i].handle._n:stopAllActions() --先停掉之前可能的动画
				_frm.childUI["PageBtn" .. i].handle._n:runAction(sequence)
			else
				_frm.childUI["PageBtn" .. i]:setXY(toX, toY)
			end
		end
		
		--先清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--清空切换分页之后取消的监听事件
		--移除监听
		hGlobal.event:listen("LocalEvent_SetCurGameScore", "__RefreshHeroCardFrm__", nil)
		--监听金币改变事件
		hGlobal.event:listen("LocalEvent_SetCurGameCoin", "__RefreshHeroCardFrm__", nil)
		--监听金币改变（手机版）事件
		hGlobal.event:listen("LocalEvent_Phone_SetCurGameCoin_Game", "__RefreshHeroCardFrm__", nil)
		--监听获得战术技能卡（碎片）事件
		hGlobal.event:listen("Event_PlayerGetTacticCard", "__RefreshHeroCardFrm__", nil)
		--监听英雄技能升级返回事件
		hGlobal.event:listen("Local_Event_HeroSkill_LvUp_Result", "__RefreshHeroCardFrm__", nil)
		--监听通知刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
		hGlobal.event:listen("LocalEvent_RefreshMedalStateUI", "__RefreshHeroCardFrm__", nil)
		
		--移除timer
		hApi.clearTimer("__HEROCARD_TIMER_UPDATE__")
		hApi.clearTimer("__TUJIAN_TIMER_UPDATE__")
		hApi.clearTimer("__REDEQUIP_TIMER_UPDATE__")
		hApi.clearTimer("__TACTIC_TIMER_UPDATE__")
		
		--隐藏所有的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_HeroCard", 0)
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_TuJianCard", 0)
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_RedEquip", 0)
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Tactic", 0)
		
		--标记当前选择的分页、页内的第几个、卡牌id
		CurrentSelectRecord.pageIdx = pageIndex
		--CurrentSelectRecord.subPageIdx = 0
		CurrentSelectRecord.contentIdx = 0
		CurrentSelectRecord.cardId = 0
		--print("标记当前选择的分页、页内的第几个、卡牌id", 0)
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：英雄令
			--创建英雄令界面
			OnCreateHeroCardFrame(pageIndex)
		elseif (pageIndex == 2) then --分页2：神器
			--创建图鉴界面
			--OnCreateTuJianDiagramFrame(pageIndex)
			--创建神器界面
			OnCreateShenQiEquipmentFrame(pageIndex)
		elseif (pageIndex == 3) then --分页3：塔
			--创建塔界面
			local i = CurrentSelectRecord.subPageIdx
			--print(i)
			if (i == 0) then
				i = 1
			end
			
			if (i == 1) then --分页1：箭塔
				--创建分支类塔的升级图界面（第3分页）（1、2、3个子分页）
				OnCreateTowerArchyDiagramFrame(pageIndex, i, baseTowercardId_jianta, mediumTowetcardId_jianta, archyTacticCardList_jianta)
				
				--默认点击第一个可升级的塔（没有返回左下角的塔）
				--CurrentSelectRecord.contentIdx = 0
				local firstLvUpTowerIdx = GetFirstLvUpTowerCardIdx(i)
				OnClickTowerBtn(i, firstLvUpTowerIdx)
			elseif (i == 2) then --分页2：法术塔
				--创建分支类塔的升级图界面（第3分页）（1、2、3个子分页）
				OnCreateTowerArchyDiagramFrame(pageIndex, i, baseTowercardId_fashu, mediumTowetcardId_fashu, archyTacticCardList_fashu)
				
				--默认点击第一个可升级的塔（没有返回左下角的塔）
				--CurrentSelectRecord.contentIdx = 0
				local firstLvUpTowerIdx = GetFirstLvUpTowerCardIdx(i)
				OnClickTowerBtn(i, firstLvUpTowerIdx)
			elseif (i == 3) then --分页3：炮塔
				--炮塔配置信息
				--创建分支类塔的升级图界面（第3分页）（1、2、3个子分页）
				OnCreateTowerArchyDiagramFrame(pageIndex, i, baseTowercardId_paota, mediumTowetcardId_paota, archyTacticCardList_paota)
				
				--默认点击第一个可升级的塔（没有返回左下角的塔）
				--CurrentSelectRecord.contentIdx = 0
				local firstLvUpTowerIdx = GetFirstLvUpTowerCardIdx(i)
				OnClickTowerBtn(i, firstLvUpTowerIdx)
			elseif (i == 4) then --分页4：特种塔
				--创建特种塔的升级图界面（第3分页）（第4个子分页）
				OnCreateSpecialDiagramFrame(pageIndex, i)
				
				--默认点击第一个可升级的特种塔（没有返回第一项）
				--CurrentSelectRecord.contentIdx = 0
				local firstLvUpSpecialIdx = GetFirstLvUpSpecialTowerIdx()
				OnClickSpecialTowerBtn(i, firstLvUpSpecialIdx)
			end
		elseif (pageIndex == 4) then --分页4：战术技能卡
			--创建战术技能卡的升级图界面
			OnCreateTacticDiagramFrame(pageIndex)
		end
		
		--播放点击按钮音效
		hApi.PlaySound("button")
		
		--默认选中第一个按钮
		if (pageIndex == 1) then --英雄令
			--
		elseif (pageIndex == 2) then --图鉴
			--
		elseif (pageIndex == 3) then --塔
			--默认点击第一个可升级的塔（没有返回左下角的塔）
			--local firstLvUpTowerIdx = GetFirstLvUpTowerCardIdx(1)
			--OnClickTowerBtn(1, firstLvUpTowerIdx)
		elseif (pageIndex == 4) then --一般战术卡
			--默认点击第一个可升级的战术技能卡（没有返回第一项）
			local firstLvUpTacticIdx = GetFirstLvUpTacticCardIdx()
			OnClickTacticBtn(pageIndex, firstLvUpTacticIdx)
		end
	end
	
	------------------------------------------------------------------------------------------
	--函数：创建英雄令界面（第1个分页）
	OnCreateHeroCardFrame = function(pageIndex)
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--允许本分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_HeroCard", 1)
		
		--左侧提示上翻页的图片
		_frmNode.childUI["HeroCardPageUp"] = hUI.image:new({
			parent = _parent,
			model = "UI:PageBtn",
			x = hVar.SCREEN.w / 2 - 170 * _ScaleW,
			y = 0 - 75 * _ScaleH + 40 * _ScaleH,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["HeroCardPageUp"].handle.s:setRotation(90)
		_frmNode.childUI["HeroCardPageUp"].handle.s:setOpacity(8) --提示上翻页默认透明度为212
		_frmNode.childUI["HeroCardPageUp"].handle.s:setVisible(false) --默认不显示左分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "HeroCardPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["HeroCardPageUp"].handle._n:runAction(forever)
		
		--左侧提示下翻页的图片
		_frmNode.childUI["HeroCardPageDown"] = hUI.image:new({
			parent = _parent,
			model = "UI:PageBtn",
			x = hVar.SCREEN.w / 2 - 170 * _ScaleW + 5, --非对称式
			y = -hVar.SCREEN.h + 95 * _ScaleH - 40 * _ScaleH,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["HeroCardPageDown"].handle.s:setRotation(270)
		_frmNode.childUI["HeroCardPageDown"].handle.s:setOpacity(8) --提示下翻页默认透明度为212
		--如果英雄卡数量未铺满第一页，那么不显示下翻页提示
		if (#hVar.HERO_AVAILABLE_LIST <= (HERO_CARD_X_NUM * HERO_CARD_Y_NUM)) then
			_frmNode.childUI["HeroCardPageDown"].handle.s:setVisible(false) --默认不显示下分翻页提示
		end
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "HeroCardPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["HeroCardPageDown"].handle._n:runAction(forever)
		
		--左侧向上翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["HeroCardPageUp_Btn"] = hUI.button:new({
			parent = _frm,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = hVar.SCREEN.w / 2 - 170 * _ScaleW,
			y = 0 - 75 * _ScaleH + 40 * _ScaleH,
			w = 200 * _ScaleW,
			h = 80 * _ScaleH,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (#hVar.HERO_AVAILABLE_LIST > (HERO_CARD_X_NUM * HERO_CARD_Y_NUM)) then
					--print("向下滚屏", screenY)
					--向下滚屏
					b_need_auto_fixing_herocard = true
					friction_herocard = 0
					draggle_speed_y_herocard = -MAX_SPEED_HEROCARD / 2.0 --负速度
				end
			end,
		})
		_frmNode.childUI["HeroCardPageUp_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "HeroCardPageUp_Btn"
		
		--左侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["HeroCardPageDown_Btn"] = hUI.button:new({
			parent = _frm,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = hVar.SCREEN.w / 2 - 170 * _ScaleW,
			y = -hVar.SCREEN.h + 95 * _ScaleH - 40 * _ScaleH,
			w = 200 * _ScaleW,
			h = 80 * _ScaleH,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (#hVar.HERO_AVAILABLE_LIST > (HERO_CARD_X_NUM * HERO_CARD_Y_NUM)) then
					--print("向上滚屏", screenY)
					--向上滚屏
					b_need_auto_fixing_herocard = true
					friction_herocard = 0
					draggle_speed_y_herocard = MAX_SPEED_HEROCARD / 2.0 --正速度
				end
			end,
		})
		_frmNode.childUI["HeroCardPageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "HeroCardPageDown_Btn"
		
		--左侧用于检测滑动事件的控件
		_frmNode.childUI["HeroCardDragPanel"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = hVar.SCREEN.w / 2,
			y = (-hVar.SCREEN.h - 60 * _ScaleH + 84 * _ScaleH) / 2 - 10 / 2 * _ScaleH,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h - 60 * _ScaleH - 84 * _ScaleH + 10 * _ScaleH,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--print("codeOnTouch", touchX, touchY, sus)
				click_pos_x_herocard = touchX --开始按下的坐标x
				click_pos_y_herocard = touchY --开始按下的坐标y
				last_click_pos_y_herocard = touchX --上一次按下的坐标x
				last_click_pos_y_herocard = touchY --上一次按下的坐标y
				draggle_speed_y_herocard = 0 --当前速度为0
				selected_herocard_idx = 0 --英雄卡选中的索引
				click_scroll_herocard = true --是否滑动英雄卡
				b_need_auto_fixing_herocard = false --不需要自动修正位置
				friction_herocard = 0 --无阻力
				
				--如果英雄卡数量未铺满一页，那么不需要滑动
				if (#hVar.HERO_AVAILABLE_LIST <= (HERO_CARD_X_NUM * HERO_CARD_Y_NUM)) then
					click_scroll_herocard = false --不需要滑动英雄卡
				end
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
				--处理移动速度y
				draggle_speed_y_herocard = touchY - last_click_pos_y_herocard
				
				if (draggle_speed_y_herocard > MAX_SPEED_HEROCARD) then
					draggle_speed_y_herocard = MAX_SPEED_HEROCARD
				end
				if (draggle_speed_y_herocard < -MAX_SPEED_HEROCARD) then
					draggle_speed_y_herocard = -MAX_SPEED_HEROCARD
				end
				
				--print("click_scroll_herocard=", click_scroll_herocard)
				--在滑动过程中才会处理滑动
				if click_scroll_herocard then
					local deltaY = touchY - last_click_pos_y_herocard --与开始按下的位置的偏移值x
					for i = 1, #hVar.HERO_AVAILABLE_LIST, 1 do
						local ctrli = _frmNode.childUI["HeroCard" .. i]
						ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
						ctrli.data.x = ctrli.data.x
						ctrli.data.y = ctrli.data.y + deltaY
					end
				end
				
				--存储本次的位置
				last_click_pos_y_herocard = touchX
				last_click_pos_y_herocard = touchY
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_herocard then
					--if (touchX ~= click_pos_x_herocard) or (touchY ~= click_pos_y_herocard) then --不是点击事件
						b_need_auto_fixing_herocard = true
						friction_herocard = 0
					--end
				end
				
				--检测
				--检测点击到了哪个英雄卡框内
				for i = 1, #hVar.HERO_AVAILABLE_LIST, 1 do
					local ctrli = _frmNode.childUI["HeroCard" .. i]
					local cx = ctrli.data.x --中心点x坐标
					local cy = ctrli.data.y --中心点y坐标
					local cw, ch = ctrli.data.w, ctrli.data.h
					local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
					local rx, ry = lx + cw, ly + ch --最右下角坐标
					--print(i, lx, rx, touchX)
					--print("click" ..  i,  "x=" .. ctrli.data.x, touchX, touchY, lx, rx, ly, ry)
					if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
						selected_herocard_idx = i
						
						break
						--print("点击到了哪个英雄卡的框内" .. i)
					end
				end
				
				--这种情况请注意：在触发滑动操作（英雄卡数量大于一页），并且按下坐标和抬起坐标偏差过大，则认为该操作是滑动，不触发选择卡牌
				if (click_scroll_herocard) and (math.abs(touchY - click_pos_y_herocard) > 40) then
					selected_herocard_idx = 0
				end
				--print("selected_herocard_idx", selected_herocard_idx)
				
				--之前选中了某个英雄卡
				if (selected_herocard_idx > 0) then
					--点击英雄卡按钮
					CurrentSelectRecord.contentIdx = 0 --该模板不会重复点击同个控件两次，所以为了能够两次点到，这里清空上次点击的索引值
					OnClickHeroCardBtn(pageIndex, selected_herocard_idx)
					
					--selected_herocard_idx = 0
				end
				
				--标记不用滑动
				click_scroll_herocard = false
			end,
		})
		_frmNode.childUI["HeroCardDragPanel"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "HeroCardDragPanel"
		
		--找出所有已获得的英雄卡
		local heroHashList = {} --英雄键值表
		local tHeroCards = Save_PlayerData.herocard
		if tHeroCards then
			for i = 1, #tHeroCards, 1 do
				if (type(tHeroCards[i])=="table") then
					local typeId = tHeroCards[i].id
					
					--存在表项
					if hVar.tab_unit[typeId] then
						local heroLv = 1 --英雄等级
						local heroStar = 1 --英雄星级
						if (tHeroCards[i].attr) then
							heroLv = tHeroCards[i].attr.level
							heroStar = tHeroCards[i].attr.star
						end
						
						--插入表
						heroHashList[typeId] = {typeId = typeId, heroLv = heroLv, heroStar = heroStar, heroNum = 1}
					end
				end
			end
		end
		
		--先绘制每一个已获得的英雄
		local indexHave = 0 --已获得的英雄索引值
		for i = 1, #hVar.HERO_AVAILABLE_LIST, 1 do
			local typeId = hVar.HERO_AVAILABLE_LIST[i].id --英雄id
			local heroLv = hVar.HERO_AVAILABLE_LIST[i].attr.level --英雄等级
			local heroStar = hVar.HERO_AVAILABLE_LIST[i].attr.star --英雄星级
			local heroNum = 0 --英雄的数量
			
			if heroHashList[typeId] then
				heroLv = heroHashList[typeId].heroLv
				heroStar = heroHashList[typeId].heroStar
				heroNum = heroHashList[typeId].heroNum
			end
			
			if (heroNum > 0) then
				indexHave = indexHave + 1
				--创建单个英雄控件已获得的
				OnCreateSingleHeroCard(pageIndex, indexHave, typeId, heroHashList)
			end
		end
		
		--再绘制每一个未获得的英雄
		local indexNotHave = indexHave --未获得的英雄索引值
		for i = 1, #hVar.HERO_AVAILABLE_LIST, 1 do
			local typeId = hVar.HERO_AVAILABLE_LIST[i].id --英雄id
			local heroLv = hVar.HERO_AVAILABLE_LIST[i].attr.level --英雄等级
			local heroStar = hVar.HERO_AVAILABLE_LIST[i].attr.star --英雄星级
			local heroNum = 0 --英雄的数量
			
			if heroHashList[typeId] then
				heroLv = heroHashList[typeId].heroLv
				heroStar = heroHashList[typeId].heroStar
				heroNum = heroHashList[typeId].num
			end
			
			if (heroNum == 0) then
				indexNotHave = indexNotHave + 1
				--创建单个英雄控件未获得的
				OnCreateSingleHeroCard(pageIndex, indexNotHave, typeId, heroHashList)
			end
		end
		
		--只在本分页有效
		--监听积分改变事件
		hGlobal.event:listen("LocalEvent_SetCurGameScore", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听金币改变事件
		hGlobal.event:listen("LocalEvent_SetCurGameCoin", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听金币改变（手机版）事件
		hGlobal.event:listen("LocalEvent_Phone_SetCurGameCoin_Game", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听获得战术技能卡（碎片）事件
		hGlobal.event:listen("Event_PlayerGetTacticCard", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听英雄技能升级返回事件
		hGlobal.event:listen("Local_Event_HeroSkill_LvUp_Result", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听通知刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
		hGlobal.event:listen("LocalEvent_RefreshMedalStateUI", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		
		--只在本分页有效
		--创建timer，刷新英雄令滚动
		hApi.addTimerForever("__HEROCARD_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_herocard_UI_scroll_loop)
	end
	
	--函数：创建单个英雄卡片控件
	OnCreateSingleHeroCard = function(pageIndex, index, typeId, heroHashList)
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--先计算xi和yi
		local xi = (index % HERO_CARD_X_NUM) --xi
		if (xi == 0) then
			xi = HERO_CARD_X_NUM
		end
		local yi = (index - xi) / HERO_CARD_X_NUM + 1 --yi
		local heroLv = 0 --英雄等级
		local heroStar = 0 --英雄星级
		local heroNum = 0 --英雄数量
		if heroHashList[typeId] then
			heroLv = heroHashList[typeId].heroLv --英雄等级
			heroStar = heroHashList[typeId].heroStar --英雄星级
			heroNum = heroHashList[typeId].heroNum --英雄数量
		end
		
		--英雄卡牌控件
		_frmNode.childUI["HeroCard" .. index] = hUI.button:new({ --作为button只是为了作为父控件，让子控件的坐标显示正常
			parent = _BTC_pClipNode_HeroCard,
			--mode = "imageButton",
			--dragbox = _frm.childUI["dragBox"],
			model = "UI:PANEL_CARD_01",
			x = HERO_CARD_OSSSET_XL + (xi - 1) *  HERO_CARD_DISTANCE_X + HERO_CARD_WIDTH / 2,
			y = HERO_CARD_OSSSET_Y - (yi - 1) * HERO_CARD_DISTANCE_Y,
			w = HERO_CARD_WIDTH,
			h = HERO_CARD_HEIGHT,
			scale = 1.0,
			align = "MC",
			--scaleT = 1.0,
			--failcall = 1,
			--点击事件
			--code = function(self, screenX, screenY, isInside)
			--	--
			--end,
		})
		_frmNode.childUI["HeroCard" .. index].data.typeId = typeId --存储英雄id
		_frmNode.childUI["HeroCard" .. index].data.heroLv = heroLv --存储英雄等级
		_frmNode.childUI["HeroCard" .. index].data.heroNum = heroNum --存储英雄数量
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "HeroCard" .. index
		
		local button = _frmNode.childUI["HeroCard" .. index]
		
		--button.childUI["skillIcon"].handle.s:setColor(ccc3(164, 164, 164)) --变灰
		
		--英雄头像
		button.childUI["imgPortrait"] = hUI.image:new({
			parent = button.handle._n,
			model = hVar.tab_unit[typeId].portrait,
			x = 0,
			y = 22,
			w = 144,
			h = 144,
		})
		hUI.SYSAutoReleaseUI:addModel("portrait", hVar.tab_unit[typeId].portrait) --待回收
		
		--英雄升级的动态箭头
		button.childUI["heroCardjianTou"] = hUI.image:new({
			parent = button.handle._n,
			model = "ICON:image_jiantouV",
			x = 50,
			y = -25,
			scale = 1.1,
			z = 100,
		})
		--如果该英雄可以升级，那么显示提示箭头
		local bCanUpdate = hApi.IsEnableUpgrateSkill(typeId) --是否可以升级
		button.childUI["heroCardjianTou"].handle._n:setVisible(bCanUpdate)
		
		--英雄等级
		button.childUI["labLv"] = hUI.label:new({
			parent = button.handle._n,
			x = -34,
			y = -85,
			text = heroLv,
			size = 18,
			font = "num",
			align = "RC",
			width = 200,
		})
		
		--英雄等级后缀
		button.childUI["labLvPostfix"] = hUI.label:new({
			parent = button.handle._n,
			x = -34,
			y = -85,
			text = "级", --language
			--text = hVar.tab_string["__TEXT_ji"], --language
			size = 22,
			font = hVar.FONTC,
			align = "LC",
			width = 200,
			border = 1,
		})
		button.childUI["labLvPostfix"].handle.s:setColor(ccc3(255, 212, 0))
		
		--英雄名
		local heroName = hVar.tab_stringU[typeId] and hVar.tab_stringU[typeId][1] or ("未知英雄" .. typeId)
		button.childUI["labName"] = hUI.label:new({
			parent = button.handle._n,
			x = 23,
			y = -85,
			text = heroName,
			size = 22,
			font = hVar.FONTC,
			align = "MC",
			width = 200,
			border = 1,
		})
		
		--英雄星级
		for i = 1, heroStar, 1 do
			button.childUI["star" .. i] = hUI.image:new({
				parent = button.handle._n,
				model = "UI:HERO_STAR",
				x = -44 + (i - 1) * (12 + 9),
				y = -60,
				w = 14,
				h = 14,
			})
		end
		
		--英雄是竞技场专属的盖章图标
		local pvp_only = false --是否竞技场专属英雄
		for i = 1, #hVar.HERO_AVAILABLE_LIST, 1 do
			if (hVar.HERO_AVAILABLE_LIST[i].id == typeId) then --找到了
				pvp_only = hVar.HERO_AVAILABLE_LIST[i].pvp_only
				
				break
			end
		end
		if pvp_only then
			button.childUI["pvp_only"] = hUI.image:new({
				parent = button.handle._n,
				model = "UI:PVP_ONLY",
				x = 35,
				y = -13,
				w = 64,
				h = 64,
			})
		end
		
		--[[
		--英雄选中框
		--选中框（九宫格处理）
		local selectbox9 = CCScale9Sprite:createWithSpriteFrameName("data/image/ui/TaskSelectBG.png")
		selectbox9:setPosition(ccp(0, 0))
		selectbox9:setContentSize(CCSizeMake(HERO_CARD_WIDTH + 4, HERO_CARD_HEIGHT + 4))
		--selectbox9:setScaleX(ACTIVITY_WIDTH / 121)
		--selectbox9:setScaleY(ACTIVITY_HEIGHT / 43)
		button.handle._n:addChild(selectbox9)
		button.data.selectbox9 = selectbox9 --存储九宫格
		--动画
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, 1.01, 1.02), CCScaleTo:create(0.6, 1.0, 1.0))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		selectbox9:runAction(forever)
		--默认隐藏
		selectbox9:setVisible(false)
		]]
		
		--如果该英雄未获得，那么灰掉一些控件
		if (heroNum == 0) then
			local alpha = 128
			button.handle.s:setColor(ccc3(alpha, alpha, alpha)) --背景图
			button.childUI["imgPortrait"].handle.s:setColor(ccc3(alpha, alpha, alpha)) --英雄头像
			button.childUI["labLv"].handle.s:setColor(ccc3(alpha, alpha, alpha)) --英雄等级
			button.childUI["labLvPostfix"].handle.s:setColor(ccc3(alpha, alpha - 20, 0)) --英雄等级后缀
			button.childUI["labName"].handle.s:setColor(ccc3(alpha, alpha, alpha)) --英雄等级
			for i = 1, heroStar, 1 do
				button.childUI["star" .. i].handle.s:setColor(ccc3(alpha, alpha, alpha)) --英雄星级
			end
			if button.childUI["pvp_only"] then
				button.childUI["pvp_only"].handle.s:setColor(ccc3(192, 192, 192)) --英雄是竞技场的标识
			end
		end
	end
	
	--函数：点击英雄卡的按钮的执行逻辑
	OnClickHeroCardBtn = function(pageIndex, contentIndex)
		--print("OnClickHeroCardBtn", pageIndex, contentIndex, CurrentSelectRecord.contentIdx)
		--不重复绘制同一个项索引值
		if (CurrentSelectRecord.contentIdx == contentIndex) then
			return
		end
		
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--[[
		--更新选中框
		local last_herocard_idx = CurrentSelectRecord.contentIdx
		--隐藏上一次的选中框
		if (last_herocard_idx > 0) then
			_frmNode.childUI["HeroCard" .. last_herocard_idx].data.selectbox9:setVisible(false)
		end
		
		--显示本次的
		_frmNode.childUI["HeroCard" .. contentIndex].data.selectbox9:setVisible(true)
		]]
		
		--获得参数
		local button = _frmNode.childUI["HeroCard" .. contentIndex]
		local cardId = button.data.typeId --英雄id
		local heroLv = button.data.heroLv --英雄等级
		local heroNum = button.data.heroNum --英雄数量
		
		if (heroNum > 0) then --已获得的英雄
			--关闭本面板
			--OnClosePanelFrame()
			
			--有可能英雄界面被删除了
			if not hGlobal.UI.HeroCardNewFrm then
				hGlobal.UI.InitHeroCardNewFrm()
			end
			
			--打开英雄详细信息面板
			--print("打开英雄详细信息面板")
			hGlobal.event:event("LocalEvent_showHeroCardFrm", 0, cardId, 0)
			
			--隐藏本界面
			_frm:show(0)
			
			--[[
			----------------------------
					--按钮往下做运动
					for i = 1, #tPageIcons, 1 do
						local px, py = _frm.childUI["PageBtn" .. i].data.x, _frm.childUI["PageBtn" .. i].data.y
						local act1 = CCDelayTime:create(0.01 + 0.03 * i)
						local act2 = CCEaseSineOut:create(CCMoveTo:create(0.2, ccp(px, -hVar.SCREEN.h - 84 * _ScaleH / 2)))
						local act4 = CCCallFunc:create(function()
							--_frm.childUI["PageBtn" .. i].data.y = -hVar.SCREEN.h - 84 * _ScaleH / 2
							_frm.childUI["PageBtn" .. i]:setXY(px, -hVar.SCREEN.h - 84 * _ScaleH / 2)
						end)
						local a = CCArray:create()
						a:addObject(act1)
						a:addObject(act2)
						a:addObject(act4)
						local sequence = CCSequence:create(a)
						_frm.childUI["PageBtn" .. i].handle._n:stopAllActions() --先停掉之前可能的动画
						_frm.childUI["PageBtn" .. i].handle._n:runAction(sequence)
					end
					
					--主界面顶部栏往上做运动
					local px, py = _frm.childUI["menu_top"].data.x, _frm.childUI["menu_top"].data.y
					local act1 = CCDelayTime:create(0.11)
					local act2 = CCEaseSineOut:create(CCMoveTo:create(0.2, ccp(px, 100 * _ScaleH / 2)))
					local act4 = CCCallFunc:create(function()
						--_frm.childUI["menu_top"].data.y = 100 * _ScaleH / 2
						_frm.childUI["menu_top"]:setXY(px, 100 * _ScaleH / 2)
					end)
					local a = CCArray:create()
					a:addObject(act1)
					a:addObject(act2)
					a:addObject(act4)
					local sequence = CCSequence:create(a)
					_frm.childUI["menu_top"].handle._n:stopAllActions() --先停掉之前可能的动画
					_frm.childUI["menu_top"].handle._n:runAction(sequence)
					
					--主界面底部栏往下做运动
					local px, py = _frm.childUI["menu_bottom2"].data.x, _frm.childUI["menu_bottom2"].data.y
					local act1 = CCDelayTime:create(0.11)
					local act2 = CCEaseSineOut:create(CCMoveTo:create(0.2, ccp(px, -hVar.SCREEN.h - 125 * _ScaleH / 2)))
					local act4 = CCCallFunc:create(function()
						--_frm.childUI["menu_bottom2"].data.y = -hVar.SCREEN.h - 125 * _ScaleH / 2
						_frm.childUI["menu_bottom2"]:setXY(px, -hVar.SCREEN.h - 125 * _ScaleH / 2)
					end)
					local a = CCArray:create()
					a:addObject(act1)
					a:addObject(act2)
					a:addObject(act4)
					local sequence = CCSequence:create(a)
					_frm.childUI["menu_bottom2"].handle._n:stopAllActions() --先停掉之前可能的动画
					_frm.childUI["menu_bottom2"].handle._n:runAction(sequence)
					
					--本面板
					--往左做运动
					local px, py = _frm.data.x, _frm.data.y
					local act1 = CCDelayTime:create(0.31)
					local act2 = CCEaseSineIn:create(CCMoveTo:create(0.2, ccp(-hVar.SCREEN.w, py)))
					local act4 = CCCallFunc:create(function()
						--_frm.data.x = -hVar.SCREEN.w
						_frm:setXY(-hVar.SCREEN.w, py)
						
						--不显示金币界面
						hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
						
						--不显示点将台、图鉴面板
						hGlobal.UI.Phone_MyHeroCardFrm_New:show(0)
						
						--清空上次分页的全部信息
						_removeLeftFrmFunc()
						_removeRightFrmFunc()
						
						--删除英雄令自动调整滑动的timer
						hApi.clearTimer("__HEROCARD_TIMER_UPDATE__")
						
						--删除图鉴自动调整滑动的timer
						hApi.clearTimer("__TUJIAN_TIMER_UPDATE__")
						
						--删除红装自动调整滑动的timer
						hApi.clearTimer("__REDEQUIP_TIMER_UPDATE__")
						
						--删除战术卡自动调整滑动的timer
						hApi.clearTimer("__TACTIC_TIMER_UPDATE__")
						
						hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
						
					end)
					local a = CCArray:create()
					a:addObject(act1)
					a:addObject(act2)
					a:addObject(act4)
					local sequence = CCSequence:create(a)
					_frm.handle._n:stopAllActions() --先停掉之前可能的动画
					_frm.handle._n:runAction(sequence)
					----------------------------
				]]
		else --未获得的英雄
			--显示英雄介绍
			hGlobal.event:event("LocalEvent_HeroCardInfo", cardId)
		end
		
		--标记当前选中的项的索引和卡牌id
		CurrentSelectRecord.contentIdx = contentIndex
		CurrentSelectRecord.cardId = cardId
	end
	
	--函数：自动调整英雄令控件的滑动
	refresh_herocard_UI_scroll_loop = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local SPEED = 50 --速度
		--print(b_need_auto_fixing_herocard)
		
		if b_need_auto_fixing_herocard then
			---第一个英雄卡的数据
			local HerolBtn1 = _frmNode.childUI["HeroCard1"]
			local btn1_cx, btn1_cy = 0, 0 --第一个英雄卡中心点位置
			local btn1_ly = 0 --第一个英雄卡最上侧的y坐标
			local delta1_ly = 0 --第一个英雄卡距离上侧边界的距离
			btn1_cx, btn1_cy = HerolBtn1.data.x, HerolBtn1.data.y --第一个英雄卡中心点位置
			btn1_ly = math.floor(btn1_cy + HERO_CARD_HEIGHT / 2 * _ScaleH) --第一个英雄卡最上侧的y坐标
			delta1_ly = math.floor(btn1_ly - HERO_CARD_OSSSET_Y - 101 * _ScaleH) --第一个英雄卡距离上侧边界的距离
			
			--最后一个英雄卡的数据
			local HeroBtnN = _frmNode.childUI["HeroCard" .. (#hVar.HERO_AVAILABLE_LIST)]
			local btnN_cx, btnN_cy = 0, 0 --最后一个英雄卡中心点位置
			local btnN_ry = 0 --最后一个英雄卡最下侧的x坐标
			local deltNa_ry = 0 --最后一个英雄卡距离下侧边界的距离
			btnN_cx, btnN_cy = HeroBtnN.data.x, HeroBtnN.data.y --最后一个英雄卡中心点位置
			btnN_ry = math.floor(btnN_cy - HERO_CARD_HEIGHT / 2  * _ScaleH) --最后一个英雄卡最下侧的x坐标
			deltNa_ry = math.floor(btnN_ry - HERO_CARD_OSSSET_YB - 20 * _ScaleH) --最后一个英雄卡距离下侧边界的距离
			--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
			
			--print("delta1_ly=" .. delta1_ly, ", deltNa_rx=" .. deltNa_rx)
			--如果第一个英雄卡的头像跑到下边，那么优先将第一个英雄卡头像贴边
			if (delta1_ly < 0) then
				--print("优先将第一个英雄卡头像贴边")
				--需要修正
				--不会选中英雄卡
				selected_herocard_idx = 0 --选中的英雄卡索引
				
				--没有惯性
				draggle_speed_y_herocard = 0
				
				local speed = SPEED
				if ((delta1_ly + speed) > 0) then --防止走过
					speed = -delta1_ly
					delta1_ly = 0
				end
				--print("speed=", speed, SPEED)
				--每个按钮向上侧做运动
				for i = 1, #hVar.HERO_AVAILABLE_LIST, 1 do
					local ctrli = _frmNode.childUI["HeroCard" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x, pos_y + speed
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页不显示，下滑动翻页显示
				_frmNode.childUI["HeroCardPageUp"].handle.s:setVisible(false) --上翻页提示
				_frmNode.childUI["HeroCardPageDown"].handle.s:setVisible(true) --下翻页提示
			elseif (delta1_ly ~= 0) and (deltNa_ry > 0) then --第一个头像没有贴上侧，并且最后一个头像没有贴下侧，那么再将最后一个英雄卡头像贴边
				--print("将最后一个英雄卡头像贴边")
				--需要修正
				--不会选中英雄卡
				selected_herocard_idx = 0 --选中的英雄卡索引
				
				--没有惯性
				draggle_speed_y_herocard = 0
				
				local speed = SPEED
				if ((deltNa_ry - speed) < 0) then --防止走过
					speed = deltNa_ry
					deltNa_ry = 0
				end
				
				--每个按钮向下侧做运动
				for i = 1, #hVar.HERO_AVAILABLE_LIST, 1 do
					local ctrli = _frmNode.childUI["HeroCard" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x, pos_y - speed
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页显示，下滑动翻页不显示
				_frmNode.childUI["HeroCardPageUp"].handle.s:setVisible(true) --上分翻页提示
				_frmNode.childUI["HeroCardPageDown"].handle.s:setVisible(false) --下分翻页提示
			elseif (draggle_speed_y_herocard ~= 0) then --沿着当前的速度方向有惯性地运动一会
				--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_y_herocard)
				--不会选中英雄卡
				selected_herocard_idx = 0 --选中的英雄卡索引
				--print("    ->   draggle_speed_y_herocard=", draggle_speed_y_herocard)
				
				if (draggle_speed_y_herocard > 0) then --朝上运动
					local speed = (draggle_speed_y_herocard) * 1.0 --系数
					friction_herocard = friction_herocard - 0.5
					draggle_speed_y_herocard = draggle_speed_y_herocard + friction_herocard --衰减（正）
					
					if (draggle_speed_y_herocard < 0) then
						draggle_speed_y_herocard = 0
					end
					
					--最后一个英雄卡的坐标不能跑到最下侧的上边去
					if ((deltNa_ry + speed) > 0) then --防止走过
						speed = -deltNa_ry
						deltNa_ry = 0
						
						--没有惯性
						draggle_speed_y_herocard = 0
					end
					
					--每个按钮向上侧做运动
					for i = 1, #hVar.HERO_AVAILABLE_LIST, 1 do
						local ctrli = _frmNode.childUI["HeroCard" .. i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y + speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
				elseif (draggle_speed_y_herocard < 0) then --朝下运动
					local speed = (draggle_speed_y_herocard) * 1.0 --系数
					friction_herocard = friction_herocard + 0.5
					draggle_speed_y_herocard = draggle_speed_y_herocard + friction_herocard --衰减（负）
					
					if (draggle_speed_y_herocard > 0) then
						draggle_speed_y_herocard = 0
					end
					
					--第一个英雄卡的坐标不能跑到最上侧的下边去
					if ((delta1_ly + speed) < 0) then --防止走过
						speed = -delta1_ly
						delta1_ly = 0
						
						--没有惯性
						draggle_speed_y_herocard = 0
					end
					
					--每个按钮向下侧做运动
					for i = 1, #hVar.HERO_AVAILABLE_LIST, 1 do
						local ctrli = _frmNode.childUI["HeroCard" .. i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y + speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
				end
				
				--上滑动翻页显示，下滑动翻页显示
				if (delta1_ly == 0) then
					_frmNode.childUI["HeroCardPageUp"].handle.s:setVisible(false) --上分翻页提示
				else
					_frmNode.childUI["HeroCardPageUp"].handle.s:setVisible(true) --上分翻页提示
				end
				if (deltNa_ry == 0) then
					_frmNode.childUI["HeroCardPageDown"].handle.s:setVisible(false) --下分翻页提示
				else
					_frmNode.childUI["HeroCardPageDown"].handle.s:setVisible(true) --下分翻页提示
				end
			else --停止运动
				b_need_auto_fixing_herocard = false
				friction_herocard = 0
			end
		end
	end
	
	--函数：更新提示当前英雄令的哪个子分页可以升级了
	RefreshHeroCardUpgrateSubPage = function()
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--所有英雄卡控件
		for index = 1, #hVar.HERO_AVAILABLE_LIST, 1 do
			local button = _frmNode.childUI["HeroCard" .. index]
			if button then
				local typeId = button.data.typeId --存储英雄id
				local heroNum = button.data.typeId --英雄的数量
				if (heroNum > 0) then
					local bCanUpdate = hApi.IsEnableUpgrateSkill(typeId) --是否可以升级
					button.childUI["heroCardjianTou"].handle._n:setVisible(bCanUpdate)
				end
			end
		end
	end
	
	------------------------------------------------------------------------------------------
	--函数：创建图鉴界面（第2个分页）
	OnCreateTuJianDiagramFrame = function(pageIndex)
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--允许本分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_TuJianCard", 1)
		
		--[[
		--左侧图鉴列表底板2
		_frmNode.childUI["TuJianListBG2"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:TacticBG",
			x = TUJIAN_CARD_OSSSET_XL + 135,
			y = TUJIAN_CARD_OSSSET_Y - 130,
			w = 375 + 4,
			h = TUJIAN_PANEL_HEIGHT + 2 + 4,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TuJianListBG2"
		
		--左侧图鉴列表底板
		_frmNode.childUI["TuJianListBG"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/gray_mask_16.png",
			x = TUJIAN_CARD_OSSSET_XL + 135,
			y = TUJIAN_CARD_OSSSET_Y - 130,
			w = 375,
			h = TUJIAN_PANEL_HEIGHT + 2,
		})
		_frmNode.childUI["TuJianListBG"].handle.s:setColor(ccc3(168, 168, 168))
		--_frmNode.childUI["AchievementListBG"].handle.s:setOpacity(0)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TuJianListBG"
		]]
		--左侧图鉴提示上翻页的图片
		_frmNode.childUI["TuJianPageUp"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = TUJIAN_CARD_OSSSET_XL + (TUJIAN_CARD_X_NUM * TUJIAN_CARD_DISTANCE_X) / 2 - TUJIAN_CARD_DISTANCE_X / 2 - 2, --非对称式
			y = 0 - 75 * _ScaleH + 40 * _ScaleH,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["TuJianPageUp"].handle.s:setRotation(90)
		_frmNode.childUI["TuJianPageUp"].handle.s:setOpacity(8) --提示上翻页默认透明度为212
		_frmNode.childUI["TuJianPageUp"].handle.s:setVisible(false) --默认不显示左分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TuJianPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["TuJianPageUp"].handle._n:runAction(forever)
		
		--左侧图鉴提示下翻页的图片
		_frmNode.childUI["TuJianPageDown"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = TUJIAN_CARD_OSSSET_XL + (TUJIAN_CARD_X_NUM * TUJIAN_CARD_DISTANCE_X) / 2 - TUJIAN_CARD_DISTANCE_X / 2 + 3, --非对称式
			y = -hVar.SCREEN.h + 95 * _ScaleH - 40 * _ScaleH,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["TuJianPageDown"].handle.s:setRotation(270)
		_frmNode.childUI["TuJianPageDown"].handle.s:setOpacity(8) --提示下翻页默认透明度为212
		--如果图鉴未铺满第一页，那么不显示图鉴下翻页提示
		if (#hVar.tab_unitShowEx[tujian_chapterId] <= (TUJIAN_CARD_X_NUM * TUJIAN_CARD_Y_NUM)) then
			_frmNode.childUI["TuJianPageDown"].handle.s:setVisible(false) --默认不显示下分翻页提示
		end
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TuJianPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["TuJianPageDown"].handle._n:runAction(forever)
		
		--图鉴左侧向上翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["TuJianPageUp_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = TUJIAN_CARD_OSSSET_XL + (TUJIAN_CARD_X_NUM * TUJIAN_CARD_DISTANCE_X) / 2 - TUJIAN_CARD_DISTANCE_X / 2,
			y = 0 - 75 * _ScaleH + 40 * _ScaleH,
			w = 200 * _ScaleW,
			h = 80 * _ScaleH,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (#hVar.tab_unitShowEx[tujian_chapterId] > (TUJIAN_CARD_X_NUM * TUJIAN_CARD_Y_NUM)) then
					--print("向下滚屏", screenY)
					--向下滚屏
					b_need_auto_fixing_tujian = true
					friction_tujian = 0
					draggle_speed_y_tujian = -MAX_SPEED_TUJIAN / 2.0 --负速度
				end
			end,
		})
		_frmNode.childUI["TuJianPageUp_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TuJianPageUp_Btn"
		
		--图鉴左侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["TuJianPageDown_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = TUJIAN_CARD_OSSSET_XL + (TUJIAN_CARD_X_NUM * TUJIAN_CARD_DISTANCE_X) / 2 - TUJIAN_CARD_DISTANCE_X / 2,
			y = -hVar.SCREEN.h + 95 * _ScaleH - 40 * _ScaleH,
			w = 200 * _ScaleW,
			h = 80 * _ScaleH,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (#hVar.tab_unitShowEx[tujian_chapterId] > (TUJIAN_CARD_X_NUM * TUJIAN_CARD_Y_NUM)) then
					--print("向上滚屏", screenY)
					--向上滚屏
					b_need_auto_fixing_tujian = true
					friction_tujian = 0
					draggle_speed_y_tujian = MAX_SPEED_TUJIAN / 2.0 --正速度
				end
			end,
		})
		_frmNode.childUI["TuJianPageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TuJianPageDown_Btn"
		
		--左侧图鉴用于检测滑动事件的控件
		_frmNode.childUI["TuJianDragPanel"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = TUJIAN_CARD_OSSSET_XL + (TUJIAN_CARD_X_NUM * TUJIAN_CARD_DISTANCE_X) / 2 - TUJIAN_CARD_DISTANCE_X / 2,
			y = (-hVar.SCREEN.h - 60 * _ScaleH + 84 * _ScaleH) / 2 - 10 / 2 * _ScaleH,
			w = TUJIAN_CARD_X_NUM * TUJIAN_CARD_DISTANCE_X,
			h = hVar.SCREEN.h - 60 * _ScaleH - 84 * _ScaleH + 10 * _ScaleH,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--print("codeOnTouch", touchX, touchY, sus)
				click_pos_x_tujian = touchX --开始按下的坐标x
				click_pos_y_tujian = touchY --开始按下的坐标y
				last_click_pos_y_tujian = touchX --上一次按下的坐标x
				last_click_pos_y_tujian = touchY --上一次按下的坐标y
				draggle_speed_y_tujian = 0 --当前速度为0
				selected_tujian_idx = 0 --图鉴选中的索引
				click_scroll_tujian = true --是否滑动图鉴
				b_need_auto_fixing_tujian = false --不需要自动修正位置
				friction_tujian = 0 --无阻力
				
				--如果英雄令数量未铺满一页，那么不需要滑动
				if (#hVar.tab_unitShowEx[tujian_chapterId] <= (TUJIAN_CARD_X_NUM * TUJIAN_CARD_Y_NUM)) then
					click_scroll_tujian = false --不需要滑动图鉴
				end
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
				--处理移动速度y
				draggle_speed_y_tujian = touchY - last_click_pos_y_tujian
				
				if (draggle_speed_y_tujian > MAX_SPEED_TUJIAN) then
					draggle_speed_y_tujian = MAX_SPEED_TUJIAN
				end
				if (draggle_speed_y_tujian < -MAX_SPEED_TUJIAN) then
					draggle_speed_y_tujian = -MAX_SPEED_TUJIAN
				end
				
				--print("click_scroll_tujian=", click_scroll_tujian)
				--在滑动过程中才会处理滑动
				if click_scroll_tujian then
					local deltaY = touchY - last_click_pos_y_tujian --与开始按下的位置的偏移值x
					for i = 1, #hVar.tab_unitShowEx[tujian_chapterId], 1 do
						local ctrli = _frmNode.childUI["TuJianCard" .. i]
						ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
						ctrli.data.x = ctrli.data.x
						ctrli.data.y = ctrli.data.y + deltaY
					end
				end
				
				--存储本次的位置
				last_click_pos_y_tujian = touchX
				last_click_pos_y_tujian = touchY
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_tujian then
					--if (touchX ~= click_pos_x_tujian) or (touchY ~= click_pos_y_tujian) then --不是点击事件
						b_need_auto_fixing_tujian = true
						friction_tujian = 0
					--end
				end
				
				--检测
				--检测点击到了哪个图鉴框内
				for i = 1, #hVar.tab_unitShowEx[tujian_chapterId], 1 do
					local ctrli = _frmNode.childUI["TuJianCard" .. i]
					local cx = ctrli.data.x --中心点x坐标
					local cy = ctrli.data.y --中心点y坐标
					local cw, ch = ctrli.data.w, ctrli.data.h
					local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
					local rx, ry = lx + cw, ly + ch --最右下角坐标
					--print(i, lx, rx, touchX)
					--print("click" ..  i,  "x=" .. ctrli.data.x, touchX, touchY, lx, rx, ly, ry)
					if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
						selected_tujian_idx = i
						
						break
						--print("点击到了哪个图鉴的框内" .. i)
					end
				end
				
				--这种情况请注意：在触发滑动操作（图鉴数量大于一页），并且按下坐标和抬起坐标偏差过大，则认为该操作是滑动，不触发选择卡牌
				if (click_scroll_tujian) and (math.abs(touchY - click_pos_y_tujian) > 40) then
					selected_tujian_idx = 0
				end
				--print("selected_tujian_idx", selected_tujian_idx)
				
				--之前选中了某个图鉴
				if (selected_tujian_idx > 0) then
					--OnRefreshAchievementFrame(selected_tujian_idx)
					--点击图鉴按钮
					OnClickTuJianCardBtn(pageIndex, selected_tujian_idx)
					
					--selected_tujian_idx = 0
				end
				
				--标记不用滑动
				click_scroll_tujian = false
			end,
		})
		_frmNode.childUI["TuJianDragPanel"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TuJianDragPanel"
		
		--章节翻页的底纹图
		_frmNode.childUI["imgChapterBG"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/mask.png", --"UI:ItemSlot", --"UI:login_lk", --"UI:MedalDarkImg",
			x = TUJIAN_CARD_OSSSET_XL + (TUJIAN_CARD_X_NUM * TUJIAN_CARD_DISTANCE_X) / 2 - TUJIAN_CARD_DISTANCE_X / 2,
			y = -hVar.SCREEN.h + 95 * _ScaleH + 25 * _ScaleH + 1,
			w = 260,
			h = 56,
		})
		_frmNode.childUI["imgChapterBG"].handle.s:setOpacity(0) --只挂载子控件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "imgChapterBG"
		local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", 0, 0, 260, 56, _frmNode.childUI["imgChapterBG"])
		img9:setOpacity(128)
		
		--向左翻页的章节按钮控件（只用于控制，不显示）
		_frmNode.childUI["btnChapter_L"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			x = TUJIAN_CARD_OSSSET_XL + (TUJIAN_CARD_X_NUM * TUJIAN_CARD_DISTANCE_X) / 2 - TUJIAN_CARD_DISTANCE_X / 2 - 120,
			y = -hVar.SCREEN.h + 95 * _ScaleH + 25 * _ScaleH,
			dragbox = _frm.childUI["dragBox"],
			w = 90,
			h = 70,
			scaleT = 0.95,
			code = function(self)
				--print("向左翻页")
				if (tujian_chapterId <= 1) then
					--print("已是第一章")
					return
				end
				
				--切换章节
				ShowChapterTuJianListFrame(pageIndex, tujian_chapterId - 1)
			end,
		})
		_frmNode.childUI["btnChapter_L"].handle.s:setOpacity(0) --只作为控制用，不用于显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnChapter_L"
		--章节翻页图片左
		_frmNode.childUI["btnChapter_L"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["btnChapter_L"].handle._n,
			model = "UI:button_return", --"UI:PageBtn",
			x = 0,
			y = 0,
			scale = 1.0,
		})
		--_childUI["btnChapter_L"].childUI["icon"].handle._n:setRotation(90)
		local scaleBig = CCMoveTo:create(0.8, ccp(-3, 0))
		local scaleSmall = CCMoveTo:create(0.8, ccp(0, 0))
		local actSeq = CCSequence:createWithTwoActions(scaleBig, scaleSmall)
		_frmNode.childUI["btnChapter_L"].childUI["icon"].handle._n:runAction(CCRepeatForever:create(actSeq))
		--章节翻页图片左（灰色）
		_frmNode.childUI["btnChapter_L"].childUI["iconGray"] = hUI.image:new({
			parent = _frmNode.childUI["btnChapter_L"].handle._n,
			model = "UI:button_return", --"UI:PageBtn",
			x = 0,
			y = 0,
			scale = 1.0,
		})
		--hApi.AddShader(_childUI["btnChapter_L"].childUI["iconGray"].handle.s, "gray")
		_frmNode.childUI["btnChapter_L"].childUI["iconGray"].handle.s:setColor(ccc3(128, 128, 128))
		_frmNode.childUI["btnChapter_L"].childUI["iconGray"].handle._n:setVisible(false) --默认隐藏
		
		--向右翻页的章节按钮控件（只用于控制，不显示）
		_frmNode.childUI["btnChapter_R"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			x = TUJIAN_CARD_OSSSET_XL + (TUJIAN_CARD_X_NUM * TUJIAN_CARD_DISTANCE_X) / 2 - TUJIAN_CARD_DISTANCE_X / 2 + 120,
			y = -hVar.SCREEN.h + 95 * _ScaleH + 25 * _ScaleH,
			w = 90,
			h = 70,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function(self)
				--print("向右翻页")
				if (tujian_chapterId >= (#hVar.tab_unitShowEx)) then
					--print("一是最后一章")
					return
				end
				
				--检测本章的最后一关是否已通关，未通关不能点下一章
				local lastMapName = hVar.tab_chapter[tujian_chapterId].lastmap
				local isFinishLast = LuaGetPlayerMapAchi(lastMapName, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
				if (isFinishLast == 0) then
					--print("您还未通关本章")
					return
				end
				
				--切换章节
				ShowChapterTuJianListFrame(pageIndex, tujian_chapterId + 1)
			end,
		})
		_frmNode.childUI["btnChapter_R"].handle.s:setOpacity(0) --只作为控制用，不用于显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnChapter_R"
		--章节翻页图片右
		_frmNode.childUI["btnChapter_R"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["btnChapter_R"].handle._n,
			model = "UI:button_return", --"UI:PageBtn",
			x = 0,
			y = 1,
			scale = 1.0,
		})
		_frmNode.childUI["btnChapter_R"].childUI["icon"].handle._n:setRotation(180)
		local scaleBig = CCMoveTo:create(0.8, ccp(3, 1))
		local scaleSmall = CCMoveTo:create(0.8, ccp(0, 1))
		local actSeq = CCSequence:createWithTwoActions(scaleBig, scaleSmall)
		_frmNode.childUI["btnChapter_R"].childUI["icon"].handle._n:runAction(CCRepeatForever:create(actSeq))
		--章节翻页图片右（灰色）
		_frmNode.childUI["btnChapter_R"].childUI["iconGray"] = hUI.image:new({
			parent = _frmNode.childUI["btnChapter_R"].handle._n,
			model = "UI:button_return", --"UI:PageBtn",
			x = 0,
			y = 1,
			scale = 1.0,
		})
		_frmNode.childUI["btnChapter_R"].childUI["iconGray"].handle._n:setRotation(180)
		--hApi.AddShader(_childUI["btnChapter_R"].childUI["iconGray"].handle.s, "gray")
		_frmNode.childUI["btnChapter_R"].childUI["iconGray"].handle.s:setColor(ccc3(128, 128, 128))
		_frmNode.childUI["btnChapter_R"].childUI["iconGray"].handle._n:setVisible(false) --默认隐藏
		
		--第几章的文字
		_frmNode.childUI["labelChapterIndex"] =  hUI.label:new({
			parent = _parentNode,
			x = TUJIAN_CARD_OSSSET_XL + (TUJIAN_CARD_X_NUM * TUJIAN_CARD_DISTANCE_X) / 2 - TUJIAN_CARD_DISTANCE_X / 2,
			y = -hVar.SCREEN.h + 95 * _ScaleH + 25 * _ScaleH - 2,
			size = 32,
			width = 500,
			font = hVar.FONTC,
			align = "MC",
			border = 1,
			text = "",
		})
		_frmNode.childUI["labelChapterIndex"].handle.s:setColor(ccc3(255, 255, 255))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "labelChapterIndex"
		
		--绘制当前章节下的全部怪物列表
		local chapterId = tujian_chapterId
		tujian_chapterId = 0
		ShowChapterTuJianListFrame(pageIndex, chapterId)
		
		--只在本分页有效
		--创建timer，刷新图鉴卡的滚动
		hApi.addTimerForever("__TUJIAN_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_tujian_UI_scroll_loop)
	end
	
	--函数：显示指定章节下的全部怪物列表界面
	ShowChapterTuJianListFrame = function(pageIndex, chapterId)
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--不重复绘制
		if (chapterId == tujian_chapterId) then
			return
		end
		
		--清空上一次的全部左侧图鉴控件
		if (tujian_chapterId > 0) then
			for i = 1, #hVar.tab_unitShowEx[tujian_chapterId], 1 do
				hApi.safeRemoveT(_frmNode.childUI, "TuJianCard" .. i)
				
				for j = 1, #leftRemoveFrmList, 1 do
					if (leftRemoveFrmList[j] == "TuJianCard" .. i) then
						table.remove(leftRemoveFrmList, j)
						break
					end
				end
			end
		end
		
		--清空全部右侧控件
		_removeRightFrmFunc()
		
		--介绍点击图鉴卡的文字
		--右侧显示提示点击图鉴卡的图标查看文字
		_frmNode.childUI["HintClickTuJian"] = hUI.label:new({
			parent = _parentNode,
			x = TUJIAN_CARD_OSSSET_XL + (TUJIAN_CARD_X_NUM * TUJIAN_CARD_DISTANCE_X) - TUJIAN_CARD_DISTANCE_X / 2 + 220 * _ScaleW,
			y = -hVar.SCREEN.h/2 + 30 * _ScaleH,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 220,
			--text = "点击左侧单位头像查看详情。", --language
			text = hVar.tab_string["ClickEnemyiconSeeDetail"], --language
			border = 1,
		})
		_frmNode.childUI["HintClickTuJian"].handle.s:setColor(ccc3(196, 196, 196))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "HintClickTuJian"
		
		--标记当前绘制的章节id
		tujian_chapterId = chapterId
		
		--因为翻到下一章，清空标记当前选中的项的索引和卡牌id
		CurrentSelectRecord.contentIdx = 0
		CurrentSelectRecord.cardId = 0
		
		--读取该章节下的所有怪物列表
		local enemyList = hVar.tab_unitShowEx[tujian_chapterId]
		
		--无效的章节id，直接返回
		if (not enemyList) then
			return
		end
		
		--依次绘制每个怪物图标控件
		for i = 1, #enemyList, 1 do
			--创建单个怪物图标控件
			OnCreateSingleEnemyIcon(pageIndex, i, enemyList[i][1], enemyList[i][2])
		end
		
		--绘制上下翻页按钮的状态
		_frmNode.childUI["TuJianPageUp"].handle.s:setVisible(false) --不显示左分翻页提示
		--如果图鉴未铺满第一页，那么不显示图鉴下翻页提示
		if (#hVar.tab_unitShowEx[tujian_chapterId] <= (TUJIAN_CARD_X_NUM * TUJIAN_CARD_Y_NUM)) then
			_frmNode.childUI["TuJianPageDown"].handle.s:setVisible(false) --不显示下分翻页提示
		else
			_frmNode.childUI["TuJianPageDown"].handle.s:setVisible(true) --显示下分翻页提示
		end
		
		--更新章节名
		local chapterIdx = hVar.tab_stringCH[tujian_chapterId] and hVar.tab_stringCH[tujian_chapterId][2] or ("未知" .. tujian_chapterId)
		_frmNode.childUI["labelChapterIndex"]:setText(chapterIdx)
		
		--绘制章节翻页按钮的状态
		--标记翻页按钮的状态（左）
		if ((#hVar.tab_unitShowEx) == 1) then --总共只有1章
			--都灰掉
			_frmNode.childUI["btnChapter_L"].childUI["icon"].handle._n:setVisible(false)
			_frmNode.childUI["btnChapter_L"].childUI["iconGray"].handle._n:setVisible(true)
			_frmNode.childUI["btnChapter_R"].childUI["icon"].handle._n:setVisible(false)
			_frmNode.childUI["btnChapter_R"].childUI["iconGray"].handle._n:setVisible(true)
		else --有很多章
			if (tujian_chapterId <= 1) then --翻页（左）当前是第一章
				_frmNode.childUI["btnChapter_L"].childUI["icon"].handle._n:setVisible(false)
				_frmNode.childUI["btnChapter_L"].childUI["iconGray"].handle._n:setVisible(true)
			else --翻页（左）当前大于第一章
				_frmNode.childUI["btnChapter_L"].childUI["icon"].handle._n:setVisible(true)
				_frmNode.childUI["btnChapter_L"].childUI["iconGray"].handle._n:setVisible(false)
			end
			
			--标记翻页按钮的状态（右）
			if (tujian_chapterId >= (#hVar.tab_unitShowEx)) then --翻页（右）当前是最后一章
				_frmNode.childUI["btnChapter_R"].childUI["icon"].handle._n:setVisible(false)
				_frmNode.childUI["btnChapter_R"].childUI["iconGray"].handle._n:setVisible(true)
			else
				--检测是否通关本章的最后一关
				local lastMapName = hVar.tab_chapter[tujian_chapterId].lastmap
				local isFinishLast = LuaGetPlayerMapAchi(lastMapName, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0
				if (isFinishLast == 0) then --未通关本章的最后一关
					_frmNode.childUI["btnChapter_R"].childUI["icon"].handle._n:setVisible(false)
					_frmNode.childUI["btnChapter_R"].childUI["iconGray"].handle._n:setVisible(true)
				else --已通过
					_frmNode.childUI["btnChapter_R"].childUI["icon"].handle._n:setVisible(true)
					_frmNode.childUI["btnChapter_R"].childUI["iconGray"].handle._n:setVisible(false)
				end
			end
		end
	end
	
	--函数：创建单个怪物图标控件
	OnCreateSingleEnemyIcon = function(pageIndex, index, typeId, mapName)
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--先计算xi和yi
		local xi = (index % TUJIAN_CARD_X_NUM) --xi
		if (xi == 0) then
			xi = TUJIAN_CARD_X_NUM
		end
		local yi = (index - xi) / TUJIAN_CARD_X_NUM + 1 --yi
		local heroLv = 0 --英雄等级
		local bBoss = (hVar.tab_unit[typeId].tag and hVar.tab_unit[typeId].tag[hVar.UNIT_TAG_TYPE.OTHER.TAG_BOSS]) --是否为boss
		local bUnlock = ((hVar.tab_unitShowEx.IsShowAllIcon == 1) or (LuaGetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.LEVEL) == 1)) --是否已解锁可以看
		
		--图鉴卡牌控件
		_frmNode.childUI["TuJianCard" .. index] = hUI.button:new({ --作为button只是为了作为父控件，让子控件的坐标显示正常
			parent = _BTC_pClipNode_TuJianCard,
			--mode = "imageButton",
			--dragbox = _frm.childUI["dragBox"],
			model = "UI_frm:slot",
			animation = "lightSlim",
			x = TUJIAN_CARD_OSSSET_XL + (xi - 1) *  TUJIAN_CARD_DISTANCE_X,
			y = TUJIAN_CARD_OSSSET_Y - (yi - 1) * TUJIAN_CARD_DISTANCE_Y,
			w = TUJIAN_CARD_WIDTH,
			h = TUJIAN_CARD_HEIGHT,
		})
		_frmNode.childUI["TuJianCard" .. index].data.typeId = typeId --存储怪物id
		_frmNode.childUI["TuJianCard" .. index].data.mapName = mapName --存储怪物需要解锁的地图名
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TuJianCard" .. index
		--_frmNode.childUI["TuJianCard" .. index].handle.s:setOpacity(0) --不显示
		
		local button = _frmNode.childUI["TuJianCard" .. index]
		
		--button.childUI["skillIcon"].handle.s:setColor(ccc3(164, 164, 164)) --变灰
		
		--怪物图标
		--解锁后才能显示图标
		local iconRes = "ICON:skill_icon1_x3y3" --问号
		local iconW = 52
		local iconH = 52
		if (bUnlock) then --已解锁可以看
			iconRes = hVar.tab_unit[typeId].icon
			iconW = TUJIAN_CARD_WIDTH - 4
			iconH = TUJIAN_CARD_HEIGHT - 4
		end
		button.childUI["imgEnemyIcon"] = hUI.image:new({
			parent = button.handle._n,
			model = iconRes,
			x = 0,
			y = 0,
			w = iconW,
			h = iconH,
		})
		
		--如果是boss，并且已解锁，额外显示boss图标
		if (bUnlock) and (bBoss) then
			--boss图标
			button.childUI["imgEnemyBoss"] = hUI.image:new({
				parent = button.handle._n,
				model = "ui/icon01_x3y5.png",
				x = 26,
				y = -23,
				w = 36,
				h = 32,
			})
		end
		
		--[[
		--怪物升级的动态箭头
		button.childUI["tujianCardjianTou"] = hUI.image:new({
			parent = button.handle._n,
			model = "ICON:image_jiantouV",
			x = 45,
			y = -20,
			scale = 1.0,
			z = 100,
		})
		button.childUI["tujianCardjianTou"].handle._n:setVisible(true)
		]]
		
		--怪物的选中框
		local Scale0 = (TUJIAN_CARD_HEIGHT + 8) / 70
		button.childUI["selectbox"] = hUI.image:new({
			parent = button.handle._n,
			model = "UI:Tactic_Selected",
			align = "MC",
			x = 0,
			y = 0,
			scale = Scale0,
		})
		button.childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, Scale0 - 0.015), CCScaleTo:create(0.6, Scale0 + 0.025))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		button.childUI["selectbox"].handle.s:runAction(forever)
	end
	
	--函数：图鉴卡的按钮的执行逻辑
	OnClickTuJianCardBtn = function(pageIndex, contentIndex)
		--print("OnClickTuJianCardBtn")
		--不重复绘制同一个项索引值
		if (CurrentSelectRecord.contentIdx == contentIndex) then
			return
		end
		
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--清空右侧分页的全部信息
		_removeRightFrmFunc()
		
		--隐藏上一个选中的图鉴卡选中框
		local lastContentIdx = CurrentSelectRecord.contentIdx
		if (lastContentIdx > 0) then
			_frmNode.childUI["TuJianCard" .. lastContentIdx].childUI["selectbox"].handle.s:setVisible(false)
		end
		
		--显示本次选中的图鉴卡选中框
		_frmNode.childUI["TuJianCard" .. contentIndex].childUI["selectbox"].handle.s:setVisible(true)
		
		--获得参数
		local button = _frmNode.childUI["TuJianCard" .. contentIndex]
		local cardId = button.data.typeId --英雄id
		local mapName = button.data.mapName --地图名
		
		--标记当前选中的项的索引和卡牌id
		CurrentSelectRecord.contentIdx = contentIndex
		CurrentSelectRecord.cardId = cardId
		
		--绘制右侧怪物属性
		--第一个文字的偏移值
		local FONT_OFFSET_X = TUJIAN_CARD_OSSSET_XL + (TUJIAN_CARD_X_NUM * TUJIAN_CARD_DISTANCE_X) - TUJIAN_CARD_DISTANCE_X / 2 + 25 * _ScaleW --第一个文字的偏移值x
		local FONT_OFFSET_XR = 200 --右半部分的额外偏移值
		local FONT_OFFSET_Y = 0 - 154 * _ScaleH --第一个文字的偏移值y
		local LINE1_OFFSET_Y = -150 --第一个线条的偏移值y
		local ATTR1_OFFSET_Y = -20 --第一个属性条的偏移值y
		local FONT_DELTA_Y = 46 --属性条文字间的间隔y
		local LINE2_OFFSET_Y = -55 --第二个线条的偏移值y
		local SKILL1_OFFSET_Y = -65 --第一个技能的偏移值y
		if (g_phone_mode ~= 0) then --手机模式
			LINE1_OFFSET_Y = -130 --第一个线条的偏移值y（手机版）
			ATTR1_OFFSET_Y = -7 --第一个属性条的偏移值y
			FONT_DELTA_Y = 40 --属性条文字间的间隔y（手机版）
			LINE2_OFFSET_Y = -35 --第二个线条的偏移值y（手机版）
			SKILL1_OFFSET_Y = -51 --第一个技能的偏移值y（手机版）
		end
		
		--解锁后才能显示属性
		if (hVar.tab_unitShowEx.IsShowAllIcon == 1) or (LuaGetPlayerMapAchi(mapName, hVar.ACHIEVEMENT_TYPE.LEVEL) == 1) then
			--读取塔单位的属性
			local tUnit = hVar.tab_unit[cardId]
			local attr = tUnit.attr --属性表
			local space_type = attr.space_type or hVar.UNIT_SPACE_TYPE.SPACE_GROUND --单位的空间类型（0:地面单位 / 1:空中单位）
			local atk_space_type = attr.atk_space_type or hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_GROUND --单位的攻击空间类型（0:地面单位 / 1:地面和空中单位 / 2:空中单位）
			local hp = attr.hp --生命值
			local atk_min = attr.attack[4] --最小攻击力
			local atk_max = attr.attack[5] --最大攻击力
			local atk_range = attr.atk_radius or 0 --射程
			local move_speed = attr.move_speed or 0 --移动速度
			local atk_speed = attr.atk_interval or 0 --攻击速度
			local def_physic = attr.def_physic or 0 --物防
			local def_magic = attr.def_magic or 0 --法防
			local escape_punish = attr.escape_punish or 0 --漏怪惩
			local dodge_rate = attr.dodge_rate or 0 --闪避几率（去百分号后的值）
			local crit_rate = attr.crit_rate or 0 --暴击几率（去百分号后的值）
			local suck_blood_rate = attr.suck_blood_rate or 0 --吸血率（去百分号后的值）
			local kill_gold = attr.kill_gold or 0 --击杀奖励的金钱
			local skill = attr.skill or {} --技能表
			--print("闪避" .. dodge_rate .. ", 暴击" .. crit_rate .. ", 吸血" .. suck_blood_rate)
			local atkSpeed = atk_speed / 1000
			local divValue = math.floor(atkSpeed)
			local modValue = (atkSpeed - divValue) * 100
			local szAtkSpeed = ("%d.%s"):format(divValue, tostring(modValue)) --保留2位小数
			
			--显示怪物的名字
			_frmNode.childUI["EnemyName"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X,
				y = FONT_OFFSET_Y + 50,
				size = 32,
				font = hVar.FONTC,
				align = "LC",
				width = 340,
				text = hVar.tab_stringU[cardId] and hVar.tab_stringU[cardId][1] or ("未知单位" .. cardId),
				border = 1,
			})
			_frmNode.childUI["EnemyName"].handle.s:setColor(ccc3(255, 255, 0))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "EnemyName"
			
			--显示怪物的空间类型
			local strSpaceType = nil
			if (space_type == hVar.UNIT_SPACE_TYPE.SPACE_GROUND) then --地面
				--strSpaceType = "地面单位" --language
				strSpaceType = hVar.tab_string["__ATTR__Space_Ground"] --language
			elseif (space_type == hVar.UNIT_SPACE_TYPE.SPACE_FLY) then --空中
				--strSpaceType = "空中单位" --language
				strSpaceType = hVar.tab_string["__ATTR__Space_Fly"] --language
			end
			_frmNode.childUI["EnemySpaceType"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 250,
				y = FONT_OFFSET_Y + 50 - 1,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 340,
				text = strSpaceType,
				border = 1,
			})
			--_frmNode.childUI["EnemySpaceType"].handle.s:setColor(ccc3(255, 255, 0))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "EnemySpaceType"
			
			--显示怪物的漏怪扣血的按钮（用于响应点击事件，不显示）
			_frmNode.childUI["EnemyEscapePunishButton"] = hUI.button:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 21 + 30,
				y = FONT_OFFSET_Y + 10 - 60,
				model = "misc/mask.png",
				w = 146,
				h = 280,
				scaleT = 0.95,
				dragbox = _frm.childUI["dragBox"],
				--[[
				--failcall = 1,
				--按下事件
				codeOnTouch = function(self, touchX, touchY, sus)
					--创建图鉴卡漏怪扣血tip
					OnCreateLifeTipFrame(true)
				end,
				
				--抬起事件
				code = function(self, screenX, screenY, isInside)
					--删除图鉴卡漏怪扣血tip
					OnCreateLifeTipFrame(false)
				end,
				]]
				--抬起事件
				code = function(self, screenX, screenY, isInside)
					--创建怪物生命点介绍tip
					hApi.ShowEnemyLifePointTip()
				end,
			})
			_frmNode.childUI["EnemyEscapePunishButton"].handle.s:setOpacity(0) --用于处理响应，不显示
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "EnemyEscapePunishButton"
			
			--显示怪物的漏怪扣血图片
			_frmNode.childUI["EnemyEscapePunishPrefix"] = hUI.image:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 21,
				y = FONT_OFFSET_Y + 10,
				model = "ui/Attr_Hp.png",
				scale = 0.9,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "EnemyEscapePunishPrefix"
			
			--显示怪物的漏怪扣血选中框
			_frmNode.childUI["EnemyEscapePunishSelectBox"] = hUI.image:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 21,
				y = FONT_OFFSET_Y + 10,
				model = "UI:Tactic_Selected",
				w = 40,
				h = 40,
			})
			_frmNode.childUI["EnemyEscapePunishSelectBox"].handle.s:setVisible(false) --默认隐藏
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "EnemyEscapePunishSelectBox"
			
			--显示怪物的漏怪扣血值
			_frmNode.childUI["EnemyEscapePunishValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 46,
				y = FONT_OFFSET_Y + 10 - 3, --偏差
				size = 24,
				font = "numWhite",
				align = "LC",
				width = 300,
				text = escape_punish,
			})
			_frmNode.childUI["EnemyEscapePunishValue"].handle.s:setColor(ccc3(255, 144, 144))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "EnemyEscapePunishValue"
			
			--显示怪物的击杀得金币的按钮（用于响应点击事件，不显示）
			_frmNode.childUI["EnemyGetGoldButton"] = hUI.button:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 156 + 90,
				y = FONT_OFFSET_Y + 10 - 60,
				model = "misc/mask.png",
				w = 240,
				h = 280,
				scaleT = 0.95,
				dragbox = _frm.childUI["dragBox"],
				--[[
				failcall = 1,
				
				--按下事件
				codeOnTouch = function(self, touchX, touchY, sus)
					--创建图鉴卡击杀得钱tip
					OnCreateGoldTipFrame(true)
				end,
				
				--抬起事件
				code = function(self, screenX, screenY, isInside)
					--删除图鉴卡击杀得钱tip
					OnCreateGoldTipFrame(false)
				end,
				]]
				--抬起事件
				code = function(self, screenX, screenY, isInside)
					--显示怪物击杀得钱的tip
					hApi.ShowEnemyKillGoldTip(false)
				end,
			})
			_frmNode.childUI["EnemyGetGoldButton"].handle.s:setOpacity(0) --用于处理响应，不显示
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "EnemyGetGoldButton"
			
			--显示怪物的击杀得钱图片
			_frmNode.childUI["EnemyKillGoldPrefix"] = hUI.image:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 156,
				y = FONT_OFFSET_Y + 10 - 1, --图有点偏
				model = "ui/res_money.png",
				scale = 0.7,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "EnemyKillGoldPrefix"
			
			--显示怪物的击杀得钱选中框
			_frmNode.childUI["EnemyKillGoldSeletBox"] = hUI.image:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 156,
				y = FONT_OFFSET_Y + 10,
				model = "UI:Tactic_Selected",
				w = 40,
				h = 40,
			})
			_frmNode.childUI["EnemyKillGoldSeletBox"].handle.s:setVisible(false) --默认隐藏
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "EnemyKillGoldSeletBox"
			
			--显示怪物的击杀得钱值
			_frmNode.childUI["EnemyKillGoldValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 183,
				y = FONT_OFFSET_Y + 10 - 3, --偏差
				size = 24,
				font = "numWhite",
				align = "LC",
				width = 300,
				text = kill_gold,
			})
			_frmNode.childUI["EnemyKillGoldValue"].handle.s:setColor(ccc3(255, 255, 128))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "EnemyKillGoldValue"
			
			--显示怪物的说明
			_frmNode.childUI["EnemyIntro"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 3,
				y = FONT_OFFSET_Y - 20,
				size = 24,
				font = hVar.FONTC,
				align = "LT",
				width = 380,
				text = hVar.tab_stringU[cardId] and hVar.tab_stringU[cardId][2] or ("未知单位说明" .. cardId),
				border = 1,
			})
			_frmNode.childUI["EnemyIntro"].handle.s:setColor(ccc3(224, 224, 224))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "EnemyIntro"
			
			--显示分割线1
			_frmNode.childUI["SeparateLine1"] = hUI.image:new({
				parent = _parentNode,
				model = "UI:Tactic_SeparateLine",
				x = FONT_OFFSET_X + 172,
				y = FONT_OFFSET_Y + LINE1_OFFSET_Y + 20,
				w = 364,
				h = 4,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "SeparateLine1"
			
			--显示“生命”文字
			_frmNode.childUI["HpPrefix"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X,
				y = FONT_OFFSET_Y + LINE1_OFFSET_Y + ATTR1_OFFSET_Y - FONT_DELTA_Y * 0,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 300,
				--text = "生命", --language
				text = hVar.tab_string["blood"], --language
				border = 1,
			})
			--_frmNode.childUI["HpPrefix"].handle.s:setColor(ccc3(255, 244, 244))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "HpPrefix"
			
			--显示生命值
			_frmNode.childUI["HpValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 70,
				y = FONT_OFFSET_Y + LINE1_OFFSET_Y + ATTR1_OFFSET_Y - FONT_DELTA_Y * 0 - 1, --数字字体有1像素偏差
				size = 24,
				font = "numWhite",
				align = "LC",
				width = 300,
				text = hp,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "HpValue"
			
			--显示“攻击空间类型”文字
			_frmNode.childUI["atkSpaceTypePrefix"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + FONT_OFFSET_XR,
				y = FONT_OFFSET_Y + LINE1_OFFSET_Y + ATTR1_OFFSET_Y - FONT_DELTA_Y * 0,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 300,
				--text = "范围", --language
				text = hVar.tab_string["__ATTR__AtkSpace_Type"], --language
				border = 1,
			})
			--_frmNode.childUI["HpPrefix"].handle.s:setColor(ccc3(255, 244, 244))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "atkSpaceTypePrefix"
			
			--显示怪物的攻击空间类型值
			local strAtkSpaceType = nil
			if (atk_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_GROUND) then --地面
				--strAtkSpaceType = "对地" --language
				strAtkSpaceType = hVar.tab_string["__ATTR__AtkSpace_Ground"] --language
			elseif (atk_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_ALL) then --空中
				--strAtkSpaceType = "对空" --language
				strAtkSpaceType = hVar.tab_string["__ATTR__AtkSpace_FlyGround"] --language
			elseif (atk_space_type == hVar.UNIT_ATTACK_SPACE_TYPE.ATTACK_SPACE_FLY) then --空中
				--strAtkSpaceType = "对空" --language
				strAtkSpaceType = hVar.tab_string["__ATTR__AtkSpace_Fly"] --language
			end
			_frmNode.childUI["atkSpaceTypeValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 70 + FONT_OFFSET_XR,
				y = FONT_OFFSET_Y + LINE1_OFFSET_Y + ATTR1_OFFSET_Y - FONT_DELTA_Y * 0 - 1, --数字字体有1像素偏差
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 300,
				text = strAtkSpaceType,
				border = 1,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "atkSpaceTypeValue"
			
			--显示“攻击”文字
			_frmNode.childUI["AtkPrefix"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X,
				y = FONT_OFFSET_Y + LINE1_OFFSET_Y + ATTR1_OFFSET_Y - FONT_DELTA_Y * 1,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 300,
				--text = "攻击", --language
				text = hVar.tab_string["__Attr_Hint_atk"], --language
				border = 1,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkPrefix"
			
			--显示攻击力值
			local atkValueTotal = atk_min .. "-" .. atk_max
			if (atk_min == atk_max) then --如果两个攻击力一样大，那么合并
				atkValueTotal = tostring(atk_min)
			end
			local atkSize = 24
			if (#atkValueTotal > 6) then --如果攻击力文字过长，缩小字体
				atkSize = 20
			end
			_frmNode.childUI["AtkValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 70,
				y = FONT_OFFSET_Y + LINE1_OFFSET_Y + ATTR1_OFFSET_Y - FONT_DELTA_Y * 1 - 1, --数字字体有1像素偏差
				size = atkSize,
				font = "numWhite",
				align = "LC",
				width = 300,
				text = atkValueTotal,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkValue"
			
			--显示“射程”文字
			_frmNode.childUI["AtkRangePrefix"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + FONT_OFFSET_XR,
				y = FONT_OFFSET_Y + LINE1_OFFSET_Y + ATTR1_OFFSET_Y - FONT_DELTA_Y,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 300,
				--text = "射程", --language
				text = hVar.tab_string["__Attr_Atk_Range"], --language
				border = 1,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkRangePrefix"
			
			--显示射程值
			local strAtkRange = atk_range
			local fontAtkRange = "numWhite"
			local fontSizeAtkRange = 24
			if (strAtkRange <= 90) then
				--strAtkRange = "近战" --language
				strAtkRange = hVar.tab_string["__Attr_ATTACKMODE_28"] --language
				fontAtkRange = hVar.FONTC
				fontSizeAtkRange = 26
			end
			
			_frmNode.childUI["AtkRangeValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 70 + FONT_OFFSET_XR,
				y = FONT_OFFSET_Y + LINE1_OFFSET_Y + ATTR1_OFFSET_Y - FONT_DELTA_Y - 1, --数字字体有1像素偏差
				size = fontSizeAtkRange,
				font = fontAtkRange,
				align = "LC",
				width = 300,
				text = strAtkRange,
				border = 1,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkRangeValue"
			
			--显示“移动速度”文字
			_frmNode.childUI["MoveSpeedPrefix"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X,
				y = FONT_OFFSET_Y + LINE1_OFFSET_Y + ATTR1_OFFSET_Y - FONT_DELTA_Y * 2,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 300,
				--text = "移速", --language
				text = hVar.tab_string["__Attr_Hint_move_speed_short"], --language
				border = 1,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "MoveSpeedPrefix"
			
			--显示移动速度值
			_frmNode.childUI["MoveSpeedValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 70,
				y = FONT_OFFSET_Y + LINE1_OFFSET_Y + ATTR1_OFFSET_Y - FONT_DELTA_Y * 2 - 1, --数字字体有1像素偏差
				size = 24,
				font = "numWhite",
				align = "LC",
				width = 300,
				text = move_speed,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "MoveSpeedValue"
			
			--显示“攻速”文字
			_frmNode.childUI["AtkSpeedPrefix"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + FONT_OFFSET_XR,
				y = FONT_OFFSET_Y + LINE1_OFFSET_Y + ATTR1_OFFSET_Y - FONT_DELTA_Y * 2,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 300,
				--text = "攻速", --language
				text = hVar.tab_string["__Attr_Speed"], --language
				border = 1,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkSpeedPrefix"
			
			--显示攻击速度
			_frmNode.childUI["AtkSpeedValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 70 + FONT_OFFSET_XR,
				y = FONT_OFFSET_Y + LINE1_OFFSET_Y + ATTR1_OFFSET_Y - FONT_DELTA_Y * 2 - 1, --数字字体有1像素偏差
				size = 24,
				font = "numWhite",
				align = "LC",
				width = 300,
				text = szAtkSpeed,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkSpeedValue"
			
			--显示“物防”文字
			_frmNode.childUI["PhyDefPrefix"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X,
				y = FONT_OFFSET_Y + LINE1_OFFSET_Y + ATTR1_OFFSET_Y - FONT_DELTA_Y * 3,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 300,
				--text = "物防", --language
				text = hVar.tab_string["__Attr_Def"], --language
				border = 1,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "PhyDefPrefix"
			
			--显示物防值
			_frmNode.childUI["PhyDefValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 70,
				y = FONT_OFFSET_Y + LINE1_OFFSET_Y + ATTR1_OFFSET_Y - FONT_DELTA_Y * 3 - 1, --数字字体有1像素偏差
				size = 24,
				font = "numWhite",
				align = "LC",
				width = 300,
				text = def_physic,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "PhyDefValue"
			
			--显示“法防”文字
			_frmNode.childUI["MgcDefPrefix"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + FONT_OFFSET_XR,
				y = FONT_OFFSET_Y + LINE1_OFFSET_Y + ATTR1_OFFSET_Y - FONT_DELTA_Y * 3,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 300,
				--text = "法防", --language
				text = hVar.tab_string["__ATTR__toughness"], --language
				border = 1,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "MgcDefPrefix"
			
			--显示法防值
			_frmNode.childUI["MgcDefValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 70 + FONT_OFFSET_XR,
				y = FONT_OFFSET_Y + LINE1_OFFSET_Y + ATTR1_OFFSET_Y - FONT_DELTA_Y * 3 - 1, --数字字体有1像素偏差
				size = 24,
				font = "numWhite",
				align = "LC",
				width = 300,
				text = def_magic,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "MgcDefValue"
			
			--显示分割线2
			_frmNode.childUI["SeparateLine2"] = hUI.image:new({
				parent = _parentNode,
				model = "UI:Tactic_SeparateLine",
				x = FONT_OFFSET_X + 172,
				y = FONT_OFFSET_Y + LINE1_OFFSET_Y - FONT_DELTA_Y * 3 + LINE2_OFFSET_Y,
				w = 364,
				h = 4,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "SeparateLine2"
			
			--显示单位的技能
			for i = 1, #skill, 1 do
				local skillId = skill[i][1]
				local skillLv = skill[i][2]
				local skillCD = skill[i][3]
				
				--技能图标按钮（用于响应点击事件，不显示）
				_frmNode.childUI["EnemySkill" .. i] = hUI.button:new({
					parent = _parentNode,
					model = "misc/mask.png",
					x = FONT_OFFSET_X + (i - 1) * (64 + 16) + 32,
					y = FONT_OFFSET_Y + LINE1_OFFSET_Y - FONT_DELTA_Y * 3 + LINE2_OFFSET_Y + SKILL1_OFFSET_Y,
					w = 80,
					h = 80,
					scaleT = 0.95,
					dragbox = _frm.childUI["dragBox"],
					code = function(self, screenX, screenY, isInside)
						--显示技能tip
						--OnCreateSkillTipFrame(i, skillId, skillLv, skillCD)
						hApi.ShowSkillTip(skillId, skillCD)
					end,
				})
				_frmNode.childUI["EnemySkill" .. i].handle.s:setOpacity(0) --用于处理响应，不显示
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "EnemySkill" .. i
				
				--技能图标
				_frmNode.childUI["EnemySkill" .. i].childUI["icon"] = hUI.image:new({
					parent = _frmNode.childUI["EnemySkill" .. i].handle._n,
					model = hVar.tab_skill[skillId].icon,
					x = 0,
					y = 0,
					w = TUJIAN_CARD_HEIGHT,
					h = TUJIAN_CARD_HEIGHT,
				})
				
				--技能的选中框
				local Scale0 = (TUJIAN_CARD_HEIGHT + 8) / 70
				_frmNode.childUI["EnemySkill" .. i].childUI["selectbox"] = hUI.image:new({
					parent = _frmNode.childUI["EnemySkill" .. i].handle._n,
					model = "UI:Tactic_Selected",
					align = "MC",
					x = 0,
					y = 0,
					scale = Scale0,
				})
				_frmNode.childUI["EnemySkill" .. i].childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
				local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, Scale0 - 0.015), CCScaleTo:create(0.6, Scale0 + 0.025))
				local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
				_frmNode.childUI["EnemySkill" .. i].childUI["selectbox"].handle.s:runAction(forever)
			end
			
			--没有技能，显示一行文字
			if (#skill == 0) then
				_frmNode.childUI["NoSkillLabel"] = hUI.label:new({
					parent = _parentNode,
					x = FONT_OFFSET_X,
					y = FONT_OFFSET_Y + LINE1_OFFSET_Y - FONT_DELTA_Y * 3 + LINE2_OFFSET_Y + SKILL1_OFFSET_Y,
					size = 26,
					font = hVar.FONTC,
					align = "LC",
					width = 300,
					--text = "无技能", --language
					text = hVar.tab_string["__TEXT_Nothing"] .. hVar.tab_string["__Attr_Skill"], --language
					border = 1,
				})
				_frmNode.childUI["NoSkillLabel"].handle.s:setColor(ccc3(144, 144, 144))
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "NoSkillLabel"
			end
			
			--绘制怪物的模型
			local unitModel = tUnit.model --模型
			local unitScale = tUnit.scale or 1.0 --缩放
			_frmNode.childUI["UnitModel"] = hUI.image:new({
				parent = _parentNode,
				model = unitModel,
				align = "MC",
				x = hVar.SCREEN.w - 150 * _ScaleW,
				y = -hVar.SCREEN.h/2 - 30 * _ScaleH,
				scale = 1.2 * unitScale,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "UnitModel"
			
			local tabM = hApi.GetModelByName(unitModel)
			--print(tabM)
			if tabM then
				local tRelease = {}
				local path = tabM.image
				path = string.sub(path, 1, #path - 8) .. "_world" .. ".pvr.ccz"
				
				tRelease[path] = 1
				hResource.model:releasePlist(tRelease)
				
				local plistPath = "data/image/"..(path)
				local texture = CCTextureCache:sharedTextureCache():textureForKey(plistPath)
				
				--print("释放模型")
				--print("plistPath=", plistPath)
				--print("texture=", texture)
				if texture then
					CCTextureCache:sharedTextureCache():removeTexture(texture)
				end
			end
			
			--绘制怪物特效
			local effect = tUnit.effect or {} --特效列表
			for i = 1, #effect, 1 do
				local effectId = effect[i][1]
				local effX = effect[i][2] or 0
				local effY = effect[i][3] or 0
				local effScale = effect[i][4] or 1.0
				--print(effectId, cardId)
				local effModel = effectId
				if (type(effectId) == "number") then
					effModel = hVar.tab_effect[effectId].model
				end
				if effModel then
					_frmNode.childUI["UnitEffModel" .. i] = hUI.image:new({
						parent = _parentNode,
						model = effModel,
						align = "MC",
						x = hVar.SCREEN.w - 150 * _ScaleW + effX,
						y = -hVar.SCREEN.h/2 - 30 * _ScaleH + effY,
						z = -1,
						scale = 1.2 * effScale,
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "UnitEffModel" .. i
					
					local tabM = hApi.GetModelByName(effModel)
					if tabM then
						local tRelease = {}
						local path = tabM.image
						tRelease[path] = 1
						hResource.model:releasePlist(tRelease)
						
						local pngPath = "data/image/"..(tabM.image)
						local texture = CCTextureCache:sharedTextureCache():textureForKey(pngPath)
						--print("释放特效")
						--print("pngPath=", pngPath)
						--print("texture = ", texture)
						
						if texture then
							CCTextureCache:sharedTextureCache():removeTexture(texture)
						end
					end
				end
			end
			
			--print()
			--print()
		else --未解锁
			--显示最初始的塔的辅助信息
			_frmNode.childUI["UnlockHint"] = hUI.label:new({
				parent = _parentNode,
				x = TUJIAN_CARD_OSSSET_XL + (TUJIAN_CARD_X_NUM * TUJIAN_CARD_DISTANCE_X) - TUJIAN_CARD_DISTANCE_X / 2 + 220 * _ScaleW,
				y = -hVar.SCREEN.h/2 + 30 * _ScaleH,
				size = 26,
				font = hVar.FONTC,
				align = "MC",
				width = 330,
				--text = "通关更多关卡可查看。", --language
				text = hVar.tab_string["__UNLOCK_MORE_CHAPTER"], --language
				border = 1,
			})
			_frmNode.childUI["UnlockHint"].handle.s:setColor(ccc3(196, 196, 196))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "UnlockHint"
		end
	end
	
	--[[
	--函数：创建/隐藏 图鉴卡漏怪扣除血量说明tip
	OnCreateLifeTipFrame = function(bVisible)
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--先清除上一次的图鉴卡漏怪扣除血量说明面板
		if hGlobal.UI.TuJianLiftInfoFram then
			hGlobal.UI.TuJianLiftInfoFram:del()
		end
		
		--如果是隐藏tip，到这就直接退出
		if (not bVisible) then
			_frmNode.childUI["EnemyEscapePunishSelectBox"].handle.s:setVisible(false) --不显示
			
			return
		end
		
		--显示血量选中框
		_frmNode.childUI["EnemyEscapePunishSelectBox"].handle.s:setVisible(true) --显示
		
		--创建漏怪扣除血量说明面板
		hGlobal.UI.TuJianLiftInfoFram = hUI.frame:new({
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
			background = -1, --无底图
			border = 0, --无边框
		})
		hGlobal.UI.TuJianLiftInfoFram:active()
		
		local _LifeParent = hGlobal.UI.TuJianLiftInfoFram.handle._n
		local _LifeChildUI = hGlobal.UI.TuJianLiftInfoFram.childUI
		local _offX = BOARD_POS_X + 620
		local _offY = BOARD_POS_Y + 0
		
		--创建漏怪扣除血量tip图片背景
		_LifeChildUI["ItemBG_1"] = hUI.image:new({
			parent = _LifeParent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "UI:TacticBG",
			x = _offX,
			y = _offY - 35,
			w = 370,
			h = 110,
		})
		_LifeChildUI["ItemBG_1"].handle.s:setOpacity(232) --技能背景图片透明度为232
		
		--创建漏怪扣除血量tip-血量图标
		--print(hVar.tab_skill[skillId].icon)
		_LifeChildUI["LifeIcon"] = hUI.image:new({
			parent = _LifeParent,
			model = "ui/Attr_Hp.png",
			x = _offX - 151,
			y = _offY - 5,
			scale = 1.0,
		})
		
		--创建漏怪扣除血量tip-血量名称
		_LifeChildUI["LifeName"] = hUI.label:new({
			parent = _LifeParent,
			size = 28,
			x = _offX - 123,
			y = _offY - 5 - 5,
			width = 300,
			align = "LC",
			font = hVar.FONTC,
			--text = "漏怪扣生命点数", --language
			text = hVar.tab_string["__ATTR__EscapePunish"], --language
			border = 1,
		})
		_LifeChildUI["LifeName"].handle.s:setColor(ccc3(255, 255, 0))
		
		--创建漏怪扣除血量tip-血量说明
		_LifeChildUI["LifeHint"] = hUI.label:new({
			parent = _LifeParent,
			size = 24,
			x = _offX - 168,
			y = _offY - 57,
			width = 350,
			align = "LC",
			font = hVar.FONTC,
			--text = "敌人从终点漏过，扣除您的生命点数。", --language
			text = hVar.tab_string["__ATTR__EscapePunish_Hint"], --language
			border = 1,
		})
		--_LifeChildUI["LifeHint"].handle.s:setColor(ccc3(255, 255, 255))
	end
	]]
	
	--[[
	--函数：创建/隐藏 图鉴卡击杀得金钱说明tip
	OnCreateGoldTipFrame = function(bVisible)
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--先清除上一次的图鉴卡击杀得金钱说明面板
		if hGlobal.UI.TuJianGoldInfoFram then
			hGlobal.UI.TuJianGoldInfoFram:del()
		end
		
		--如果是隐藏tip，到这就直接退出
		if (not bVisible) then
			_frmNode.childUI["EnemyKillGoldSeletBox"].handle.s:setVisible(false) --不显示
			
			return
		end
		
		--显示金钱选中框
		_frmNode.childUI["EnemyKillGoldSeletBox"].handle.s:setVisible(true) --显示
		
		--创建击杀得金钱说明面板
		hGlobal.UI.TuJianGoldInfoFram = hUI.frame:new({
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
			background = -1, --无底图
			border = 0, --无边框
		})
		hGlobal.UI.TuJianGoldInfoFram:active()
		
		local _GoldParent = hGlobal.UI.TuJianGoldInfoFram.handle._n
		local _GoldChildUI = hGlobal.UI.TuJianGoldInfoFram.childUI
		local _offX = BOARD_POS_X + 620
		local _offY = BOARD_POS_Y
		
		--创建击杀得金钱tip图片背景
		_GoldChildUI["ItemBG_1"] = hUI.image:new({
			parent = _GoldParent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "UI:TacticBG",
			x = _offX,
			y = _offY - 35,
			w = 370,
			h = 110,
		})
		_GoldChildUI["ItemBG_1"].handle.s:setOpacity(232) --技能背景图片透明度为232
		
		--创建击杀得金钱tip-金钱图标
		--print(hVar.tab_skill[skillId].icon)
		_GoldChildUI["GoldIcon"] = hUI.image:new({
			parent = _GoldParent,
			model = "ui/res_money.png",
			x = _offX - 151,
			y = _offY - 5 - 1, --图有点偏
			scale = 0.7,
		})
		
		--创建击杀得金钱tip-血量名称
		_GoldChildUI["GoldName"] = hUI.label:new({
			parent = _GoldParent,
			size = 28,
			x = _offX - 123,
			y = _offY - 5 - 5,
			width = 300,
			align = "LC",
			font = hVar.FONTC,
			--text = "击杀获得金币", --language
			text = hVar.tab_string["__ATTR__KillGold"], --language
			border = 1,
		})
		_GoldChildUI["GoldName"].handle.s:setColor(ccc3(255, 255, 0))
		
		--创建击杀得金钱tip-金钱说明
		_GoldChildUI["GoldHint"] = hUI.label:new({
			parent = _GoldParent,
			size = 24,
			x = _offX - 168,
			y = _offY - 57,
			width = 350,
			align = "LC",
			font = hVar.FONTC,
			--text = "击杀敌人获得的金币。（有一定的几率获得双倍金币奖励）", --language
			text = hVar.tab_string["__ATTR__KillGold_Hint"], --language
			border = 1,
		})
		--_GoldChildUI["GoldHint"].handle.s:setColor(ccc3(255, 255, 255))
	end
	]]
	
	--[[
	--函数：查看图鉴卡技能说明tip
	OnCreateSkillTipFrame = function(skillIdx, skillId, skillLv, skillCD)
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--先清除上一次的技能说明面板
		if hGlobal.UI.TuJianSkillInfoFram then
			hGlobal.UI.TuJianSkillInfoFram:del()
		end
		
		_frmNode.childUI["EnemySkill" .. skillIdx].childUI["selectbox"].handle.s:setVisible(true) --显示
		
		--创建技能说明面板
		hGlobal.UI.TuJianSkillInfoFram = hUI.frame:new({
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
			background = -1, --无底图
			border = 0, --无边框
			
			--点击事件（有可能在控件外部点击）
			codeOnDragEx = function(screenX, screenY, touchMode)
				--print("codeOnDragEx", screenX, screenY, touchMode)
				if (touchMode == 0) then --按下
					--清除技能说明面板
					--hGlobal.UI.TuJianSkillInfoFram:del()
					--hGlobal.UI.TuJianSkillInfoFram = nil
					--print("点击事件（有可能在控件外部点击）")
					--隐藏技能选中框
					_frmNode.childUI["EnemySkill" .. skillIdx].childUI["selectbox"].handle.s:setVisible(false) --隐藏
				elseif (touchMode == 1) then --滑动
					--
				elseif (touchMode == 2) then --抬起
				end
			end,
		})
		hGlobal.UI.TuJianSkillInfoFram:active()
		
		local _SkillParent = hGlobal.UI.TuJianSkillInfoFram.handle._n
		local _SkillChildUI = hGlobal.UI.TuJianSkillInfoFram.childUI
		local _offX = BOARD_POS_X + 620
		local _offY = BOARD_POS_Y + 0
		
		--创建技能tip图片背景
		_SkillChildUI["ItemBG_1"] = hUI.image:new({
			parent = _SkillParent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "UI:TacticBG",
			x = _offX,
			y = _offY - 235,
			w = 320,
			h = 320,
		})
		_SkillChildUI["ItemBG_1"].handle.s:setOpacity(232) --技能背景图片透明度为232
		
		--创建技能tip-技能图标
		--print(hVar.tab_skill[skillId].icon)
		_SkillChildUI["SkillIcon"] = hUI.image:new({
			parent = _SkillParent,
			model = hVar.tab_skill[skillId].icon,
			x = _offX - 110 + 4,
			y = _offY - 125,
			w = 64,
			h = 64,
		})
		
		--创建技能tip-技能名称
		_SkillChildUI["SkillName"] = hUI.label:new({
			parent = _SkillParent,
			size = 32,
			x = _offX - 70,
			y = _offY - 125 - 3,
			width = 300,
			align = "LC",
			font = hVar.FONTC,
			text = hVar.tab_stringS[skillId] and hVar.tab_stringS[skillId][1] or ("未知技能" .. skillId),
			border = 1,
		})
		_SkillChildUI["SkillName"].handle.s:setColor(ccc3(255, 255, 0))
		
		--创建技能tip-技能冷却时间图标
		_SkillChildUI["SkillCDIcon"] = hUI.image:new({
			parent = _SkillParent,
			model = "ui/bimage_replay.png",
			x = _offX - 124,
			y = _offY - 185,
			w = 32,
			h = 32,
		})
		--技能冷却的时间
		_SkillChildUI["skillCDLabel"] = hUI.label:new({
			parent = _SkillParent,
			size = 20,
			align = "RT",
			font = "numWhite",
			--border = 1,
			x = _offX - 64,
			y = _offY - 174,
			width = 300,
			text = (skillCD / 1000),
		})
		_SkillChildUI["skillCDLabel"].handle.s:setColor(ccc3(168, 168, 168))
		
		--技能冷却"秒"
		_SkillChildUI["skillCDSecond"] = hUI.label:new({
			parent = _SkillParent,
			size = 26,
			align = "LT",
			font = hVar.FONTC,
			border = 1,
			x = _offX - 64,
			y = _offY - 174 - 1,
			width = 320,
			--text = "秒", --language
			text = hVar.tab_string["__Second"], --language
		})
		_SkillChildUI["skillCDSecond"].handle.s:setColor(ccc3(168, 168, 168))
		
		--技能说明
		_SkillChildUI["SkillIntro"] = hUI.label:new({
			parent = _SkillParent,
			size = 26,
			x = _offX - 144,
			y = _offY - 218,
			width = 295,
			align = "LT",
			font = hVar.FONTC,
			text = hVar.tab_stringS[skillId] and hVar.tab_stringS[skillId][2] or ("未知技能说明" .. skillId),
			border = 1,
		})
	end
	]]
	
	--函数：自动调整图鉴卡控件的滑动
	refresh_tujian_UI_scroll_loop = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local SPEED = 50 --速度
		--print(b_need_auto_fixing_tujian)
		
		if b_need_auto_fixing_tujian then
			---第一个图鉴卡的数据
			local TuJianBtn1 = _frmNode.childUI["TuJianCard1"]
			local btn1_cx, btn1_cy = 0, 0 --第一个图鉴中心点位置
			local btn1_ly = 0 --第一个图鉴最上侧的y坐标
			local delta1_ly = 0 --第一个图鉴距离上侧边界的距离
			btn1_cx, btn1_cy = TuJianBtn1.data.x, TuJianBtn1.data.y --第一个图鉴中心点位置
			btn1_ly = math.floor(btn1_cy + TUJIAN_CARD_HEIGHT / 2 * _ScaleH) --第一个图鉴最上侧的y坐标
			delta1_ly = math.floor(btn1_ly - TUJIAN_CARD_OSSSET_Y - 37 * _ScaleH) --第一个图鉴距离上侧边界的距离
			
			--最后一个图鉴卡的数据
			local TuJianBtnN = _frmNode.childUI["TuJianCard" .. (#hVar.tab_unitShowEx[tujian_chapterId])]
			local btnN_cx, btnN_cy = 0, 0 --最后一个图鉴中心点位置
			local btnN_ry = 0 --最后一个图鉴最下侧的x坐标
			local deltNa_ry = 0 --最后一个图鉴距离下侧边界的距离
			btnN_cx, btnN_cy = TuJianBtnN.data.x, TuJianBtnN.data.y --最后一个图鉴中心点位置
			btnN_ry = math.floor(btnN_cy - TUJIAN_CARD_HEIGHT / 2  * _ScaleH) --最后一个图鉴最下侧的x坐标
			deltNa_ry = math.floor(btnN_ry - TUJIAN_CARD_OSSSET_YB - 100 * _ScaleH) --最后一个图鉴距离下侧边界的距离
			--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
			
			--print("delta1_ly=" .. delta1_ly, ", deltNa_rx=" .. deltNa_rx)
			--如果第一个图鉴的头像跑到下边，那么优先将第一个图鉴头像贴边
			if (delta1_ly < 0) then
				--print("优先将第一个图鉴头像贴边")
				--需要修正
				--不会选中图鉴
				selected_tujian_idx = 0 --选中的图鉴索引
				
				--没有惯性
				draggle_speed_y_tujian = 0
				
				local speed = SPEED
				if ((delta1_ly + speed) > 0) then --防止走过
					speed = -delta1_ly
					delta1_ly = 0
				end
				
				--每个按钮向上侧做运动
				for i = 1, #hVar.tab_unitShowEx[tujian_chapterId], 1 do
					local ctrli = _frmNode.childUI["TuJianCard" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x, pos_y + speed
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页不显示，下滑动翻页显示
				_frmNode.childUI["TuJianPageUp"].handle.s:setVisible(false) --上翻页提示
				_frmNode.childUI["TuJianPageDown"].handle.s:setVisible(true) --下翻页提示
			elseif (delta1_ly ~= 0) and (deltNa_ry > 0) then --第一个头像没有贴上侧，并且最后一个头像没有贴下侧，那么再将最后一个图鉴头像贴边
				--print("将最后一个图鉴头像贴边")
				--需要修正
				--不会选中图鉴
				selected_tujian_idx = 0 --选中的图鉴索引
				
				--没有惯性
				draggle_speed_y_tujian = 0
				
				local speed = SPEED
				if ((deltNa_ry - speed) < 0) then --防止走过
					speed = deltNa_ry
					deltNa_ry = 0
				end
				
				--每个按钮向下侧做运动
				for i = 1, #hVar.tab_unitShowEx[tujian_chapterId], 1 do
					local ctrli = _frmNode.childUI["TuJianCard" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x, pos_y - speed
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页显示，下滑动翻页不显示
				_frmNode.childUI["TuJianPageUp"].handle.s:setVisible(true) --上分翻页提示
				_frmNode.childUI["TuJianPageDown"].handle.s:setVisible(false) --下分翻页提示
			elseif (draggle_speed_y_tujian ~= 0) then --沿着当前的速度方向有惯性地运动一会
				--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_y_tujian)
				--不会选中图鉴
				selected_tujian_idx = 0 --选中的图鉴索引
				--print("    ->   draggle_speed_y_tujian=", draggle_speed_y_tujian)
				
				if (draggle_speed_y_tujian > 0) then --朝上运动
					local speed = (draggle_speed_y_tujian) * 1.0 --系数
					friction_tujian = friction_tujian - 0.5
					draggle_speed_y_tujian = draggle_speed_y_tujian + friction_tujian --衰减（正）
					
					if (draggle_speed_y_tujian < 0) then
						draggle_speed_y_tujian = 0
					end
					
					--最后一个图鉴的坐标不能跑到最下侧的上边去
					if ((deltNa_ry + speed) > 0) then --防止走过
						speed = -deltNa_ry
						deltNa_ry = 0
						
						--没有惯性
						draggle_speed_y_tujian = 0
					end
					
					--每个按钮向上侧做运动
					for i = 1, #hVar.tab_unitShowEx[tujian_chapterId], 1 do
						local ctrli = _frmNode.childUI["TuJianCard" .. i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y + speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
				elseif (draggle_speed_y_tujian < 0) then --朝下运动
					local speed = (draggle_speed_y_tujian) * 1.0 --系数
					friction_tujian = friction_tujian + 0.5
					draggle_speed_y_tujian = draggle_speed_y_tujian + friction_tujian --衰减（负）
					
					if (draggle_speed_y_tujian > 0) then
						draggle_speed_y_tujian = 0
					end
					
					--第一个图鉴的坐标不能跑到最上侧的下边去
					if ((delta1_ly + speed) < 0) then --防止走过
						speed = -delta1_ly
						delta1_ly = 0
						
						--没有惯性
						draggle_speed_y_tujian = 0
					end
					
					--每个按钮向下侧做运动
					for i = 1, #hVar.tab_unitShowEx[tujian_chapterId], 1 do
						local ctrli = _frmNode.childUI["TuJianCard" .. i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y + speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
				end
				
				--上滑动翻页显示，下滑动翻页显示
				if (delta1_ly == 0) then
					_frmNode.childUI["TuJianPageUp"].handle.s:setVisible(false) --上分翻页提示
				else
					_frmNode.childUI["TuJianPageUp"].handle.s:setVisible(true) --上分翻页提示
				end
				if (deltNa_ry == 0) then
					_frmNode.childUI["TuJianPageDown"].handle.s:setVisible(false) --下分翻页提示
				else
					_frmNode.childUI["TuJianPageDown"].handle.s:setVisible(true) --下分翻页提示
				end
			else --停止运动
				b_need_auto_fixing_tujian = false
				friction_tujian = 0
			end
		end
	end
	
	------------------------------------------------------------------------------------------
	--函数：创建神器界面（第3个分页）
	OnCreateShenQiEquipmentFrame = function(pageIndex)
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("创建神器界面（第3个分页）")
		--允许本分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_RedEquip", 1)
		
		--找出所有已获得的红装
		local redequipHashList = {} --红装键值表
		redequipHashList = LuaGetPlayerDataItemCount() --统计玩家拥有的红装数量
		table.sort(hVar.RedEquip, function(a, b)
			local tItem1 = hVar.tab_item[a]
			local tItem2 = hVar.tab_item[b]
			if tItem1 and tItem2 then
				local nType1 = hVar.RedEquip.sort[tItem1.type] or 0
				local nType2 = hVar.RedEquip.sort[tItem2.type] or 0
				
				if (nType1 == nType2) then
					if (redequipHashList[a] or 0) ~= (redequipHashList[b] or 0) then
						return (redequipHashList[a] or 0) > (redequipHashList[b] or 0)
					else
						return (a) > (b)
					end
				else
					return (nType1 < nType2)
				end
			else	
				return false
			end
		end)
		
		--神器左侧提示上翻页的图片
		_frmNode.childUI["RedEquipPageUp"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = REDEQUIP_OSSSET_XL + (REDEQUIP_X_NUM * REDEQUIP_DISTANCE_X) / 2 - REDEQUIP_DISTANCE_X / 2 + 100 * _ScaleW / 2 - 2, --非对称式
			y = 0 - 75 * _ScaleH + 40 * _ScaleH,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["RedEquipPageUp"].handle.s:setRotation(90)
		_frmNode.childUI["RedEquipPageUp"].handle.s:setOpacity(8) --提示上翻页默认透明度为212
		_frmNode.childUI["RedEquipPageUp"].handle.s:setVisible(false) --默认不显示左分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RedEquipPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["RedEquipPageUp"].handle._n:runAction(forever)
		
		--神器左侧提示下翻页的图片
		_frmNode.childUI["RedEquipPageDown"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = REDEQUIP_OSSSET_XL + (REDEQUIP_X_NUM * REDEQUIP_DISTANCE_X) / 2 - REDEQUIP_DISTANCE_X / 2 + 100 * _ScaleW / 2 + 3, --非对称式
			y = -hVar.SCREEN.h + 95 * _ScaleH - 40 * _ScaleH,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["RedEquipPageDown"].handle.s:setRotation(270)
		_frmNode.childUI["RedEquipPageDown"].handle.s:setOpacity(8) --提示下翻页默认透明度为212
		--如果神器数量未铺满第一页，那么不显示下翻页提示
		if (#hVar.RedEquip <= (REDEQUIP_X_NUM * REDEQUIP_Y_NUM)) then
			_frmNode.childUI["RedEquipPageDown"].handle.s:setVisible(false) --默认不显示下分翻页提示
		end
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RedEquipPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["RedEquipPageDown"].handle._n:runAction(forever)
		
		--左侧向上翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["RedEquipPageUp_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = REDEQUIP_OSSSET_XL + (REDEQUIP_X_NUM * REDEQUIP_DISTANCE_X) / 2 - REDEQUIP_DISTANCE_X / 2 + 100 * _ScaleW / 2,
			y = 0 - 75 * _ScaleH + 40 * _ScaleH,
			w = 200 * _ScaleW,
			h = 80 * _ScaleH,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (#hVar.RedEquip > (REDEQUIP_X_NUM * REDEQUIP_Y_NUM)) then
					--print("向下滚屏", screenY)
					--向下滚屏
					b_need_auto_fixing_redequip = true
					friction_redequip = 0
					draggle_speed_y_redequip = -MAX_SPEED_REDEQUIP / 2.0 --负速度
				end
			end,
		})
		_frmNode.childUI["RedEquipPageUp_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RedEquipPageUp_Btn"
		
		--左侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["RedEquipPageDown_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = REDEQUIP_OSSSET_XL + (REDEQUIP_X_NUM * REDEQUIP_DISTANCE_X) / 2 - REDEQUIP_DISTANCE_X / 2 + 100 * _ScaleW / 2,
			y = -hVar.SCREEN.h + 95 * _ScaleH - 40 * _ScaleH,
			w = 200 * _ScaleW,
			h = 80 * _ScaleH,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (#hVar.RedEquip > (REDEQUIP_X_NUM * REDEQUIP_Y_NUM)) then
					--print("向上滚屏", screenY)
					--向上滚屏
					b_need_auto_fixing_redequip = true
					friction_redequip = 0
					draggle_speed_y_redequip = MAX_SPEED_REDEQUIP / 2.0 --正速度
				end
			end,
		})
		_frmNode.childUI["RedEquipPageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RedEquipPageDown_Btn"
		
		--左侧用于检测滑动事件的控件
		_frmNode.childUI["RedEquipDragPanel"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = REDEQUIP_OSSSET_XL + (REDEQUIP_X_NUM * REDEQUIP_DISTANCE_X) / 2 - REDEQUIP_DISTANCE_X / 2 + 100 * _ScaleW / 2,
			y = (-hVar.SCREEN.h - 60 * _ScaleH + 84 * _ScaleH) / 2 - 10 / 2 * _ScaleH,
			w = REDEQUIP_X_NUM * REDEQUIP_DISTANCE_X,
			h = hVar.SCREEN.h - 60 * _ScaleH - 84 * _ScaleH + 10 * _ScaleH,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--print("codeOnTouch", touchX, touchY, sus)
				click_pos_x_redequip = touchX --开始按下的坐标x
				click_pos_y_redequip = touchY --开始按下的坐标y
				last_click_pos_y_redequip = touchX --上一次按下的坐标x
				last_click_pos_y_redequip = touchY --上一次按下的坐标y
				draggle_speed_y_redequip = 0 --当前速度为0
				selected_redequip_idx = 0 --神器选中的索引
				click_scroll_redequip = true --是否滑动神器
				b_need_auto_fixing_redequip = false --不需要自动修正位置
				friction_redequip = 0 --无阻力
				
				--如果神器数量未铺满一页，那么不需要滑动
				if (#hVar.RedEquip <= (REDEQUIP_X_NUM * REDEQUIP_Y_NUM)) then
					click_scroll_redequip = false --不需要滑动神器
				end
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
				--处理移动速度y
				draggle_speed_y_redequip = touchY - last_click_pos_y_redequip
				
				if (draggle_speed_y_redequip > MAX_SPEED_REDEQUIP) then
					draggle_speed_y_redequip = MAX_SPEED_REDEQUIP
				end
				if (draggle_speed_y_redequip < -MAX_SPEED_REDEQUIP) then
					draggle_speed_y_redequip = -MAX_SPEED_REDEQUIP
				end
				
				--print("click_scroll_redequip=", click_scroll_redequip)
				--在滑动过程中才会处理滑动
				if click_scroll_redequip then
					local deltaY = touchY - last_click_pos_y_redequip --与开始按下的位置的偏移值x
					for i = 1, #hVar.RedEquip, 1 do
						local ctrli = _frmNode.childUI["RedEquip" .. i]
						ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
						ctrli.data.x = ctrli.data.x
						ctrli.data.y = ctrli.data.y + deltaY
					end
					
					for k,equipType in pairs(hVar.ITEM_TYPE) do
						local ctrli = _frmNode.childUI["RedEquipTypeBg"..equipType]
						if ctrli then
							ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
							ctrli.data.x = ctrli.data.x
							ctrli.data.y = ctrli.data.y + deltaY
						end
						
						--绘制英雄标题文字
						local ctrli = _frmNode.childUI["RedEquipTypeLabel"..equipType]
						if ctrli then
							ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
							ctrli.data.x = ctrli.data.x
							ctrli.data.y = ctrli.data.y + deltaY
						end
						
					end
					
				end
				
				--存储本次的位置
				last_click_pos_y_redequip = touchX
				last_click_pos_y_redequip = touchY
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_redequip then
					--if (touchX ~= click_pos_x_redequip) or (touchY ~= click_pos_y_redequip) then --不是点击事件
						b_need_auto_fixing_redequip = true
						friction_redequip = 0
					--end
				end
				
				--检测
				--检测点击到了哪个神器框内
				for i = 1, #hVar.RedEquip, 1 do
					local ctrli = _frmNode.childUI["RedEquip" .. i]
					local cx = ctrli.data.x --中心点x坐标
					local cy = ctrli.data.y --中心点y坐标
					local cw, ch = ctrli.data.w, ctrli.data.h
					local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
					local rx, ry = lx + cw, ly + ch --最右下角坐标
					--print(i, lx, rx, touchX)
					--print("click" ..  i,  "x=" .. ctrli.data.x, touchX, touchY, lx, rx, ly, ry)
					if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
						selected_redequip_idx = i
						
						break
						--print("点击到了哪个神器的框内" .. i)
					end
				end
				
				--这种情况请注意：在触发滑动操作（英雄卡数量大于一页），并且按下坐标和抬起坐标偏差过大，则认为该操作是滑动，不触发选择卡牌
				if (click_scroll_redequip) and (math.abs(touchY - click_pos_y_redequip) > 40) then
					selected_redequip_idx = 0
				end
				--print("selected_redequip_idx", selected_redequip_idx)
				
				--之前选中了某个神器
				if (selected_redequip_idx > 0) then
					--[[
					--点击神器按钮
					CurrentSelectRecord.contentIdx = 0 --该模板不会重复点击同个控件两次，所以为了能够两次点到，这里清空上次点击的索引值
					
					local itemtipX = 710 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
					local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
					hGlobal.event:event("LocalEvent_ShowItemTipFram", {{hVar.RedEquip[selected_redequip_idx], 1}}, nil, 1, itemtipX, itemtipY, 0)
					]]
					
					--selected_redequip_idx = 0
					--点击了神器按钮
					--点击神器按钮
					OnClickedEquipBtn(selected_redequip_idx)
				else
					--未点击到神器按钮
					for i = 1, #hVar.RedEquip, 1 do
						local ctrli = _frmNode.childUI["RedEquip" .. i]
						ctrli.childUI["selectbox"].handle.s:setVisible(false) --不显示
					end
					
					--清空全部右侧控件
					_removeRightFrmFunc()
				end
				
				--标记不用滑动
				click_scroll_redequip = false
			end,
		})
		_frmNode.childUI["RedEquipDragPanel"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RedEquipDragPanel"
		
		----绘制每一个红装
		--for i = 1, #hVar.RedEquip, 1 do
		--	local typeId = hVar.RedEquip[i] --红装id
		--	local redequipNum = 0
		--	if redequipHashList[typeId] then
		--		redequipNum = redequipHashList[typeId]
		--	end
		--	
		--	--创建单个红装控件未获得的
		--	OnCreateRedEquip(pageIndex, i, typeId, redequipHashList)
		--end
		
		local offsetY = REDEQUIP_OSSSET_Y
		offsetY = OnCreateRedEquipByType(pageIndex,hVar.ITEM_TYPE.WEAPON,redequipHashList,offsetY)
		offsetY = OnCreateRedEquipByType(pageIndex,hVar.ITEM_TYPE.BODY,redequipHashList,offsetY)
		offsetY = OnCreateRedEquipByType(pageIndex,hVar.ITEM_TYPE.ORNAMENTS,redequipHashList,offsetY)
		offsetY = OnCreateRedEquipByType(pageIndex,hVar.ITEM_TYPE.MOUNT,redequipHashList,offsetY)
		
		--print("offsetY:",offsetY)
		
		--默认选中第一个神器
		OnClickedEquipBtn(1)
		
		--只在本分页有效
		--监听积分改变事件
		hGlobal.event:listen("LocalEvent_SetCurGameScore", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听金币改变事件
		hGlobal.event:listen("LocalEvent_SetCurGameCoin", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听金币改变（手机版）事件
		hGlobal.event:listen("LocalEvent_Phone_SetCurGameCoin_Game", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听获得战术技能卡（碎片）事件
		hGlobal.event:listen("Event_PlayerGetTacticCard", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听英雄技能升级返回事件
		hGlobal.event:listen("Local_Event_HeroSkill_LvUp_Result", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听通知刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
		hGlobal.event:listen("LocalEvent_RefreshMedalStateUI", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		
		--创建timer，刷新英雄令滚动
		hApi.addTimerForever("__REDEQUIP_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_redequip_UI_scroll_loop)
	end
	
	--创建某个类型的红装(装备类型, 当前偏移, 红装hashList, )
	OnCreateRedEquipByType = function(pageIndex, equipType, redequipHashList, offsetY)
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local colNum = REDEQUIP_ROWNUM_PERTYPE
		
		--[[
		--绘制神器背景
		_frmNode.childUI["RedEquipTypeBg"..equipType] = hUI.image:new({
			parent = _BTC_pClipNode_RedEquip,
			model = "ui/redequipbg.png", --"UI:PVP_RedCover",
			x = REDEQUIP_OSSSET_XL + 285,
			y = offsetY - 40 * (colNum - 1) + 10,
			w = 800,
			h = 130 * colNum,
			scale = 0.83,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RedEquipTypeBg"..equipType
		]]
		
		
		--绘制英雄标题文字
		--_frmNode.childUI["RedEquipTypeLabel"..equipType] = hUI.label:new({
		--	parent = _BTC_pClipNode_RedEquip,
		--	x = REDEQUIP_OSSSET_XL + 335,
		--	y = offsetY + 13 + 45,
		--	--text = "英雄", --language
		--	text = hVar.tab_string[hVar.ItemTypeStr[equipType]], --language
		--	size = 28,
		--	font = hVar.FONTC,
		--	align = "LT",
		--	border = 1,
		--})
		--leftRemoveFrmList[#leftRemoveFrmList + 1] = "RedEquipTypeLabel"..equipType
		
		--绘制神器标题
		_frmNode.childUI["RedEquipTypeLabel"..equipType] = hUI.image:new({
			parent = _BTC_pClipNode_RedEquip,
			model = "ui/itempageflag" .. equipType .. ".png", --"UI:PVP_RedCover",
			x = REDEQUIP_OSSSET_XL + 0,
			y = offsetY - 40 * (colNum - 1) + 10,
			scale = 0.6,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RedEquipTypeLabel"..equipType
		
		--绘制每一个红装
		local equipNum = 0
		for i = 1, #hVar.RedEquip, 1 do
			local typeId = hVar.RedEquip[i] --红装id
			if hVar.tab_item[typeId].type == equipType then
				local redequipNum = 0
				if redequipHashList[typeId] then
					redequipNum = redequipHashList[typeId]
				end
				
				equipNum = equipNum + 1
				
				--创建单个红装控件未获得的
				OnCreateRedEquip(pageIndex, equipNum, i, typeId, redequipHashList, offsetY)
			end
		end
		
		--先计算xi和yi
		local ret = 0
		local index = REDEQUIP_ROWNUM_PERTYPE * REDEQUIP_X_NUM
		local xi = (index % REDEQUIP_X_NUM) --xi
		if (xi == 0) then
			xi = REDEQUIP_X_NUM
		end
		local yi = (index - xi) / REDEQUIP_X_NUM + 1 --yi
		
		ret = offsetY - REDEQUIP_TYPESECTION_HEIGHT - 20 * (colNum - 1) + (REDEQUIP_OSSSET_Y - (yi - 1) * REDEQUIP_DISTANCE_Y + 10)
		
		return ret
	end
	
	--函数：创建单个红装
	OnCreateRedEquip = function(pageIndex, index, idxInList, typeId, redequipHashList, offsetY)
		--print("创建单个红装", pageIndex, index, idxInList, hVar.tab_item[typeId].name, redequipHashList, offsetY)
		local tItem = hVar.tab_item[typeId]
		if not(tItem) then return end
		
		local redequipNum = 0
		if redequipHashList[typeId] then
			redequipNum = redequipHashList[typeId]
		end
		
		--槽
		--local nStyle = (_NSP_ItemSlotPath[typeId] or 3)*2-1
		--if (redequipHashList[typeId] or 0)>0 then
		--	nStyle = nStyle + 1
		--end
		--local nBg =  "ui/itempageslot"..nStyle..".png"
		local nBg =  "ui/itempageslot7.png"
		if ((redequipHashList[typeId] or 0) > 0) then
			nBg =  "ui/itempageslot4.png"
		end
		
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--先计算xi和yi
		local xi = (index % REDEQUIP_X_NUM) --xi
		if (xi == 0) then
			xi = REDEQUIP_X_NUM
		end
		local yi = (index - xi) / REDEQUIP_X_NUM + 1 --yi
		
		--神器控件
		_frmNode.childUI["RedEquip" .. idxInList] = hUI.button:new({ --作为button只是为了作为父控件，让子控件的坐标显示正常
			parent = _BTC_pClipNode_RedEquip,
			model = "misc/mask.png",
			--dragbox = _frm.childUI["dragBox"],
			x = REDEQUIP_OSSSET_XL + (xi - 1) *  REDEQUIP_DISTANCE_X + 100 * _ScaleW,
			--y = REDEQUIP_OSSSET_Y - (yi - 1) * REDEQUIP_DISTANCE_Y + 10,
			y = offsetY - (yi - 1) * REDEQUIP_DISTANCE_Y + 10,
			w = REDEQUIP_WIDTH,
			h = REDEQUIP_HEIGHT,
			align = "MC",
			--scaleT = 1.0,
			--failcall = 1,
			--点击事件
			--code = function(self, screenX, screenY, isInside)
			--	--
			--end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RedEquip" .. idxInList
		local button = _frmNode.childUI["RedEquip" .. idxInList]
		button.handle.s:setOpacity(0) --背景图（只响应时间，不显示）
		--button.childUI["skillIcon"].handle.s:setColor(ccc3(164, 164, 164)) --变灰
		
		--红装背景图（底座）
		button.childUI["imgPortraitBg"] = hUI.image:new({
			parent = button.handle._n,
			model = nBg,
			x = 0,
			y = -15,
			w = 84,
			h = 68,
		})
		
		--红装
		button.childUI["imgPortrait"] = hUI.image:new({
			parent = button.handle._n,
			model = tItem.icon,
			x = 0,
			y = 10,
			w = 64,
			h = 64,
		})
		
		--红装的选中框
		local Scale0 = (REDEQUIP_WIDTH - 8) / 70
		button.childUI["selectbox"] = hUI.image:new({
			parent = button.handle._n,
			model = "UI:Tactic_Selected",
			align = "MC",
			x = 0,
			y = 0,
			scale = Scale0,
		})
		button.childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, Scale0 - 0.015), CCScaleTo:create(0.6, Scale0 + 0.025))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		button.childUI["selectbox"].handle.s:runAction(forever)
		
		--如果该红装未获得，那么灰掉一些控件
		if (redequipNum == 0) then
			local alpha = 128
			--button.handle.s:setColor(ccc3(alpha, alpha, alpha)) --背景图
			--button.childUI["imgPortraitBg"].handle.s:setColor(ccc3(alpha, alpha, alpha)) --红装
			--button.childUI["imgPortrait"].handle.s:setColor(ccc3(alpha, alpha, alpha)) --红装
			hApi.AddShader(button.childUI["imgPortrait"].handle.s, "gray")
		end
	end
	
	--函数：点击神器按钮
	OnClickedEquipBtn = function(selectedIdx)
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--存储
		selected_redequip_idx = selectedIdx
		
		--点击了神器按钮
		for i = 1, #hVar.RedEquip, 1 do
			local ctrli = _frmNode.childUI["RedEquip" .. i]
			ctrli.childUI["selectbox"].handle.s:setVisible(false) --不显示
		end
		_frmNode.childUI["RedEquip" .. selected_redequip_idx].childUI["selectbox"].handle.s:setVisible(true) --显示
		
		--显示tip
		OnCreateRedEquipTip()
	end
	
	--函数：创建红装的tip
	OnCreateRedEquipTip = function()
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--清空全部右侧控件
		_removeRightFrmFunc()
		
		--道具tip父控件
		_frmNode.childUI["ItemTipParent"] = hUI.button:new({ --作为按钮是为了挂载子控件
			parent = _parentNode,
			model = "misc/mask.png",
			x = 0,
			y = 0,
			w = 1,
			h = 1,
		})
		_frmNode.childUI["ItemTipParent"].handle.s:setOpacity(0) --只挂载子控件，不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "ItemTipParent"
		
		local _ItemParent = _frmNode.childUI["ItemTipParent"]
		local _ItemchildUI = _frmNode.childUI["ItemTipParent"].childUI
		local _offX = 580
		local _offY = 10
	
		--道具图片底板1
		_ItemchildUI["ItemBan_1"] = hUI.image:new({
			parent = _ItemParent.handle._n,
			model = "UI:item1",
			x = 44 + 4,
			y = -60 + _offY,
			w = 72,
			h = 72,
		})
		_ItemchildUI["ItemBan_1"].handle._n:setVisible(false)
		
		--道具品质颜色背景1
		_ItemchildUI["ItemBG_1"] = hUI.image:new({
			parent = _ItemParent.handle._n,
			model = "UI_frm:slot",
			animation = "lightSlim",
			x = 44 + 4,
			y = -60 + _offY,
				z = 1,
			w = 72,
			h = 72,
		})
		_ItemchildUI["ItemBG_1"].handle._n:setVisible(false)
		
		--道具品质颜色背景1-颜色背景1
		_ItemchildUI["ItemBG_1_color"] = hUI.image:new({
			parent = _ItemParent.handle._n,
			model = "UI_frm:slot",
			animation = "lightSlim",
			x = 44 + 4 - _offX,
			y = -60 + _offY,
			w = 72,
			h = 72,
		})
		_ItemchildUI["ItemBG_1_color"].handle._n:setVisible(false)
		
		--道具名字1
		_ItemchildUI["itmeName_1"] = hUI.label:new({
			parent = _ItemParent.handle._n,
			size = 32,
			align = "MC",
			font = hVar.FONTC,
			x = 160 + 20,
			y = -35 - 3 + _offY,
			width = 500,
			text = "",
		})
		
		--装备部位类型1
		_ItemchildUI["itmetype_1"] = hUI.label:new({
			parent = _ItemParent.handle._n,
			size = 28,
			align = "MC",
			font = hVar.FONTC,
			x = 160 + 20 + _offY,
			y = -80,
			width = 160,
			text = "",
		})
		
		--道具说明1
		_ItemchildUI["itmehint_1"] = hUI.label:new({
			parent = _ItemParent.handle._n,
			size = 24,
			align = "LT",
			font = hVar.FONTC,
			x = 10,
			y = 0 + _offY,
			width = 312,
			text = "",
			RGB = {196, 196, 196},
		})
		
		--道具的附加说明
		_ItemchildUI["itmehintEx_1"] = hUI.label:new({
			parent = _ItemParent.handle._n,
			size = 24,
			align = "LT",
			font = hVar.FONTC,
			x = 10,
			y = 0 + _offY,
			width = 305,
			text = "",
			RGB = {230,180,50},
		})
		
		--道具图片底板2
		_ItemchildUI["ItemBan_2"] = hUI.image:new({
			parent = _ItemParent.handle._n,
			model = "UI:item1",
			x = 44 + 4,
			y = -60 + _offY,
			w = 72,
			h = 72,
		})
		_ItemchildUI["ItemBan_2"].handle._n:setVisible(false)
		
		--图片品质颜色背景2
		_ItemchildUI["ItemBG_2"] = hUI.image:new({
			parent = _ItemParent.handle._n,
			model = "UI_frm:slot",
			animation = "lightSlim",
			x = 44 + 4 - _offX,
			y = -60 + _offY,
			z = 1,
			w = 72,
			h = 72,
		})
		_ItemchildUI["ItemBG_2"].handle._n:setVisible(false)
		
		--道具品质颜色背景2-颜色背景1
		_ItemchildUI["ItemBG_2_color"] = hUI.image:new({
			parent = _ItemParent.handle._n,
			model = "UI_frm:slot",
			animation = "lightSlim",
			x = 44 + 4 - _offX,
			y = -60 + _offY,
			w = 72,
			h = 72,
		})
		_ItemchildUI["ItemBG_2_color"].handle._n:setVisible(false)
		
		--道具名字2
		_ItemchildUI["itmeName_2"] = hUI.label:new({
			parent = _ItemParent.handle._n,
			size = 32,
			align = "MC",
			font = hVar.FONTC,
			x = 160 + 20 - _offX,
			y = -35 - 3 + _offY,
			width = 160,
			text = "",
		})
		
		--_ItemchildUI["itmeyzb"] = hUI.label:new({
			--parent = _ItemParent,
			--size = 24,
			--align = "MC",
			--font = hVar.FONTC,
			--x = 160 - _offX,
			--y = -58 + _offY,
			--width = 160,
			--RGB = {0,255,0},
			--text = hVar.tab_string["__TEXT_ISQuipment"],
		--})
		--leftRemoveFrmList[#leftRemoveFrmList + 1] = "itmeyzb"
		
		--勾勾2
		_ItemchildUI["ItemBG_2"].childUI["itmeyzb"] = hUI.image:new({
			parent = _ItemchildUI["ItemBG_2"].handle._n,
			--size = 24,
			model = "UI:finish",
			x = 72 - 15,
			y = 0 + 10 + _offY,
			z = 100,
			scale = 0.8,
		})
		
		--装备部位类型2
		_ItemchildUI["itmetype_2"] = hUI.label:new({
			parent = _ItemParent.handle._n,
			size = 28,
			align = "MC",
			font = hVar.FONTC,
			x = 160 + 20 - _offX,
			y = -80 + _offY,
			width = 160,
			text = "",
		})
		
		--道具说明2
		_ItemchildUI["itmehint_2"] = hUI.label:new({
			parent = _ItemParent.handle._n,
			size = 24,
			align = "LT",
			font = hVar.FONTC,
			x = 10 -_offX,
			y = 0 + _offY,
			width = 312,
			text = "",
			RGB = {196, 196, 196},
		})
		
		--道具的附加说明2
		_ItemchildUI["itmehintEx_2"] = hUI.label:new({
			parent = _ItemParent.handle._n,
			size = 24,
			align = "LT",
			font = hVar.FONTC,
			x = 10,
			y = 0 + _offY,
			width = 305,
			text = "",
			RGB = {230,180,50},
		})
		
		local itemtipX = hVar.SCREEN.w - 350
		local itemtipY = -70 * _ScaleH
		if (g_phone_mode ~= 0) then --手机模式
			itemtipX = hVar.SCREEN.w - 350
			itemtipY = -30 * _ScaleH
		end
		hGlobal.event:event("LocalEvent_ShowItemTipFram", {{hVar.RedEquip[selected_redequip_idx], 1}}, nil, 1, itemtipX, itemtipY, 0, nil, nil, nil, _ItemParent)
	end
	
	--函数：刷新神器界面的滚动
	refresh_redequip_UI_scroll_loop = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local SPEED = 50 --速度
		--print(b_need_auto_fixing_redequip)
		
		if b_need_auto_fixing_redequip then
			---第一个神器的数据
			local RedEquipBtn1 = _frmNode.childUI["RedEquip1"]
			local btn1_cx, btn1_cy = 0, 0 --第一个神器中心点位置
			local btn1_ly = 0 --第一个神器最上侧的y坐标
			local delta1_ly = 0 --第一个神器距离上侧边界的距离
			btn1_cx, btn1_cy = RedEquipBtn1.data.x, RedEquipBtn1.data.y --第一个神器中心点位置
			btn1_ly = math.floor(btn1_cy + REDEQUIP_HEIGHT / 2 * _ScaleH) --第一个神器最上侧的y坐标
			delta1_ly = math.floor(btn1_ly - REDEQUIP_OSSSET_Y - 56 * _ScaleH) --第一个神器距离上侧边界的距离
			
			--最后一个神器的数据
			local RedEquipBtnN = _frmNode.childUI["RedEquip" .. (#hVar.RedEquip)]
			local btnN_cx, btnN_cy = 0, 0 --最后一个神器中心点位置
			local btnN_ry = 0 --最后一个神器最下侧的x坐标
			local deltNa_ry = 0 --最后一个神器距离下侧边界的距离
			btnN_cx, btnN_cy = RedEquipBtnN.data.x, RedEquipBtnN.data.y --最后一个神器中心点位置
			btnN_ry = math.floor(btnN_cy - REDEQUIP_HEIGHT / 2  * _ScaleH) --最后一个神器最下侧的x坐标
			deltNa_ry = math.floor(btnN_ry - REDEQUIP_OSSSET_YB - 30 * _ScaleH) --最后一个神器距离下侧边界的距离
			--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
			
			--print("delta1_ly=" .. delta1_ly, ", deltNa_rx=" .. deltNa_rx)
			--如果第一个神器的头像跑到下边，那么优先将第一个神器头像贴边
			if (delta1_ly < 0) then
				--print("优先将第一个神器头像贴边")
				--需要修正
				--不会选中神器
				selected_redequip_idx = 0 --选中的神器索引
				
				--没有惯性
				draggle_speed_y_redequip = 0
				
				local speed = SPEED
				if ((delta1_ly + speed) > 0) then --防止走过
					speed = -delta1_ly
					delta1_ly = 0
				end
				
				--每个按钮向上侧做运动
				for i = 1, #hVar.RedEquip, 1 do
					local ctrli = _frmNode.childUI["RedEquip" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x, pos_y + speed
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				for k, equipType in pairs(hVar.ITEM_TYPE) do
					local ctrli = _frmNode.childUI["RedEquipTypeBg"..equipType]
					if ctrli then
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y + speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
					
					--绘制神器标题文字
					local ctrli = _frmNode.childUI["RedEquipTypeLabel"..equipType]
					if ctrli then
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y + speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
					
				end
				
				--上滑动翻页不显示，下滑动翻页显示
				_frmNode.childUI["RedEquipPageUp"].handle.s:setVisible(false) --上翻页提示
				_frmNode.childUI["RedEquipPageDown"].handle.s:setVisible(true) --下翻页提示
			elseif (delta1_ly ~= 0) and (deltNa_ry > 0) then --第一个神器没有贴上侧，并且最后一个神器有贴下侧，那么再将最后一个神器头像贴边
				--print("将最后一个神器头像贴边")
				--需要修正
				--不会选中神器
				selected_redequip_idx = 0 --选中的神器索引
				
				--没有惯性
				draggle_speed_y_redequip = 0
				
				local speed = SPEED
				if ((deltNa_ry - speed) < 0) then --防止走过
					speed = deltNa_ry
					deltNa_ry = 0
				end
				
				--每个按钮向下侧做运动
				for i = 1, #hVar.RedEquip, 1 do
					local ctrli = _frmNode.childUI["RedEquip" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x, pos_y - speed
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				for k, equipType in pairs(hVar.ITEM_TYPE) do
					local ctrli = _frmNode.childUI["RedEquipTypeBg"..equipType]
					if ctrli then
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y - speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
					
					--绘制神器标题文字
					local ctrli = _frmNode.childUI["RedEquipTypeLabel"..equipType]
					if ctrli then
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y - speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
					
				end
				
				--上滑动翻页显示，下滑动翻页不显示
				_frmNode.childUI["RedEquipPageUp"].handle.s:setVisible(true) --上分翻页提示
				_frmNode.childUI["RedEquipPageDown"].handle.s:setVisible(false) --下分翻页提示
			elseif (draggle_speed_y_redequip ~= 0) then --沿着当前的速度方向有惯性地运动一会
				--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_y_herocard)
				--不会选中神器
				selected_redequip_idx = 0 --选中的神器索引
				--print("    ->   draggle_speed_y_herocard=", draggle_speed_y_herocard)
				
				if (draggle_speed_y_redequip > 0) then --朝上运动
					local speed = (draggle_speed_y_redequip) * 1.0 --系数
					friction_redequip = friction_redequip - 0.5
					draggle_speed_y_redequip = draggle_speed_y_redequip + friction_redequip --衰减（正）
					
					if (draggle_speed_y_redequip < 0) then
						draggle_speed_y_redequip = 0
					end
					
					--最后一个神器的坐标不能跑到最下侧的上边去
					if ((deltNa_ry + speed) > 0) then --防止走过
						speed = -deltNa_ry
						deltNa_ry = 0
						
						--没有惯性
						draggle_speed_y_redequip = 0
					end
					
					--每个按钮向上侧做运动
					for i = 1, #hVar.RedEquip, 1 do
						local ctrli = _frmNode.childUI["RedEquip" .. i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y + speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
					
					for k, equipType in pairs(hVar.ITEM_TYPE) do
						local ctrli = _frmNode.childUI["RedEquipTypeBg"..equipType]
						if ctrli then
							local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
							--本地运动到达的坐标
							local to_x, to_y = pos_x, pos_y + speed
							
							--设置新坐标
							ctrli.data.x = to_x
							ctrli.data.y = to_y
							ctrli.handle._n:setPosition(to_x, to_y)
						end
						
						--绘制神器标题文字
						local ctrli = _frmNode.childUI["RedEquipTypeLabel"..equipType]
						if ctrli then
							local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
							--本地运动到达的坐标
							local to_x, to_y = pos_x, pos_y + speed
							
							--设置新坐标
							ctrli.data.x = to_x
							ctrli.data.y = to_y
							ctrli.handle._n:setPosition(to_x, to_y)
						end
						
					end
				elseif (draggle_speed_y_redequip < 0) then --朝下运动
					local speed = (draggle_speed_y_redequip) * 1.0 --系数
					friction_redequip = friction_redequip + 0.5
					draggle_speed_y_redequip = draggle_speed_y_redequip + friction_redequip --衰减（负）
					
					if (draggle_speed_y_redequip > 0) then
						draggle_speed_y_redequip = 0
					end
					
					--第一个神器的坐标不能跑到最上侧的下边去
					if ((delta1_ly + speed) < 0) then --防止走过
						speed = -delta1_ly
						delta1_ly = 0
						
						--没有惯性
						draggle_speed_y_redequip = 0
					end
					
					--每个按钮向下侧做运动
					for i = 1, #hVar.RedEquip, 1 do
						local ctrli = _frmNode.childUI["RedEquip" .. i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y + speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
					
					for k,equipType in pairs(hVar.ITEM_TYPE) do
						local ctrli = _frmNode.childUI["RedEquipTypeBg"..equipType]
						if ctrli then
							local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
							--本地运动到达的坐标
							local to_x, to_y = pos_x, pos_y + speed
							
							--设置新坐标
							ctrli.data.x = to_x
							ctrli.data.y = to_y
							ctrli.handle._n:setPosition(to_x, to_y)
						end
						
						--绘制神器标题文字
						local ctrli = _frmNode.childUI["RedEquipTypeLabel"..equipType]
						if ctrli then
							local pos_x, pos_y = ctrli.data.x, ctrli.data.y
							
							--本地运动到达的坐标
							local to_x, to_y = pos_x, pos_y + speed
							
							--设置新坐标
							ctrli.data.x = to_x
							ctrli.data.y = to_y
							ctrli.handle._n:setPosition(to_x, to_y)
						end
						
					end
				end
				
				--上滑动翻页显示，下滑动翻页显示
				if (delta1_ly == 0) then
					_frmNode.childUI["RedEquipPageUp"].handle.s:setVisible(false) --上分翻页提示
				else
					_frmNode.childUI["RedEquipPageUp"].handle.s:setVisible(true) --上分翻页提示
				end
				if (deltNa_ry == 0) then
					_frmNode.childUI["RedEquipPageDown"].handle.s:setVisible(false) --下分翻页提示
				else
					_frmNode.childUI["RedEquipPageDown"].handle.s:setVisible(true) --下分翻页提示
				end
			else --停止运动
				b_need_auto_fixing_redequip = false
				friction_redequip = 0
			end
		end
	end
	
	--函数：获得第一个可以升级的塔的索引
	GetFirstLvUpTowerCardIdx =  function(subPageIndex)
		local towerList = nil --塔的列表
		if (subPageIndex == 1) then --箭塔分页
			towerList = archyTacticCardList_jianta
		elseif (subPageIndex == 2) then --法术塔分页
			towerList = archyTacticCardList_fashu
		elseif (subPageIndex == 3) then --炮塔分页
			towerList = archyTacticCardList_paota
		end
		
		--塔的最高等级
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		
		--当前的积分
		local currentScore = LuaGetPlayerScore()
		
		--获得所有塔类战术卡
		local towerDictionary = {} --塔类战术技能卡
		local tTactics = LuaGetPlayerSkillBook()
		if tTactics then
			for i = 1,#tTactics, 1 do
				if type(tTactics[i])=="table" then
					local id, lv, num = unpack(tTactics[i])
					--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
					
					--存在表项
					if hVar.tab_tactics[id] then
						local type = hVar.tab_tactics[id].type --战术技能卡类型
						if (type == hVar.TACTICS_TYPE.TOWER) then --此类专属于塔类战术技能卡，放在此处
							--检测是否重复
							if (towerDictionary[id]) then --已存在
								--如果等级更大，用大等级的
								if (lv > towerDictionary[j].skillLV) then
									towerDictionary[j].skillLV = lv
									towerDictionary[j].num = num
								end
							else --不存在
								towerDictionary[id] = {skillID = id, skillLV = lv, num = num}
							end
						end
					end
				end
			end
		end
		
		for i = 1, #towerList, 1 do
			local towerId = towerList[i] --塔id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if towerDictionary[towerId] then
				tacticLv = towerDictionary[towerId].skillLV
				tacticDebrisNum = towerDictionary[towerId].num
			end
			
			--检测是否可以升级
			local lvNow = tacticLv or 0
			if (lvNow >= maxLv) then
				lvNow = maxLv
			end
			local costDebris = hVar.TACTIC_LVUP_INFO[lvNow].costDebris or 0
			local costScore = 0 --需要的积分
			local shopItemId = hVar.TACTIC_LVUP_INFO[lvNow].shopItemId or 0
			local tabShopItem = hVar.tab_shopitem[shopItemId]
			if tabShopItem then
				costScore = tabShopItem.score or 0 --需要的积分
			end
			
			if (lvNow > 0) then --已获得的
				if (lvNow >= maxLv) then --战术技能卡已到顶级
					--不能升级
					--...
				else --还可以升级
					if (tacticDebrisNum >= costDebris) and (currentScore >= costScore) then
						return (2 + i) --前2个是基础塔和高级塔
					end
				end
			else --未获得的
				--可升级的提示
				if (tacticDebrisNum >= costDebris) and (currentScore >= costScore) then
					return (2 + i)
				end
			end
		end
		
		--走到这里说明没有能升级的塔
		return 3 --前2个是基础塔和高级塔
	end
	
	------------------------------------------------------------------------------------------
	--函数：创建分支类塔的升级图界面（第3分页）（1、2、3个子分页）
	--参数：页面索引值，父控件，基础塔类型id，升级一次后的塔类型id，升级的战术技能卡列表
	OnCreateTowerArchyDiagramFrame = function(pageIndex, subPageIndex, baseTowercardId, mediumTowetcardId, archyTacticCardList)
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local BTN_EDGE = 64 --按钮的边长
		local lineVHeight1 = 60 --第一条竖线高度
		local lineVHeight2 = 40 --第二条竖线高度
		local lineHWidth = 80 --横线的宽度
		
		local OFFSET_X = 330 * _ScaleW --统一偏移x
		local OFFSET_Y = -160 * _ScaleH --统一偏移y
		if (g_phone_mode ~= 0) then --手机模式
			OFFSET_X = 330 * _ScaleW --统一偏移x
			OFFSET_Y = -120 * _ScaleH --统一偏移y
			
			--iphone4
			if (hVar.SCREEN.w <= 960) then
				OFFSET_X = 300 * _ScaleW --统一偏移x
				OFFSET_Y = -120 * _ScaleH --统一偏移y
			end
		end
		
		local Scale0 = BTN_EDGE / 70
		
		--依次绘制每个子塔的按钮
		local tSubPageIcons = {"ui/page_jianta.png", "ui/page_fashuta.png", "ui/page_paota.png", "ui/page_teshuta.png",}
		--local tTexts = {"箭塔", "法术塔", "炮塔", "特种塔",} --language
		local tSubTexts = {hVar.tab_string["JianTaPage"], hVar.tab_string["FashuTaPage"], hVar.tab_string["PaoTaPage"], hVar.tab_string["TeShuTaPage"],} --language
		for i = 1, #tSubPageIcons, 1 do
			--子分页按钮
			_frmNode.childUI["SubPageBtn" .. i] = hUI.button:new({
				parent = _parentNode,
				model = "misc/mask.png",
				x = hVar.SCREEN.w - 60,
				y = OFFSET_Y - (i - 1) * 110 - 48 * _ScaleH,
				w = 108,
				h = 108,
				dragbox = _frm.childUI["dragBox"],
				scaleT = 0.95,
				code = function(self, screenX, screenY, isInside)
					--print("子分页按钮", i)
					if (CurrentSelectRecord.subPageIdx ~= i) then --不重复绘制
						--先清空上次分页的全部信息
						_removeLeftFrmFunc()
						_removeRightFrmFunc()
						
						--新建该分页下的全部信息
						if (i == 1) then --分页1：箭塔
							--创建分支类塔的升级图界面（第3分页）（1、2、3个子分页）
							OnCreateTowerArchyDiagramFrame(pageIndex, i, baseTowercardId_jianta, mediumTowetcardId_jianta, archyTacticCardList_jianta)
							
							--默认点击第一个可升级的塔（没有返回左下角的塔）
							--CurrentSelectRecord.contentIdx = 0
							local firstLvUpTowerIdx = GetFirstLvUpTowerCardIdx(i)
							OnClickTowerBtn(i, firstLvUpTowerIdx)
						elseif (i == 2) then --分页2：法术塔
							--创建分支类塔的升级图界面（第3分页）（1、2、3个子分页）
							OnCreateTowerArchyDiagramFrame(pageIndex, i, baseTowercardId_fashu, mediumTowetcardId_fashu, archyTacticCardList_fashu)
							
							--默认点击第一个可升级的塔（没有返回左下角的塔）
							--CurrentSelectRecord.contentIdx = 0
							local firstLvUpTowerIdx = GetFirstLvUpTowerCardIdx(i)
							OnClickTowerBtn(i, firstLvUpTowerIdx)
						elseif (i == 3) then --分页3：炮塔
							--炮塔配置信息
							--创建分支类塔的升级图界面（第3分页）（1、2、3个子分页）
							OnCreateTowerArchyDiagramFrame(pageIndex, i, baseTowercardId_paota, mediumTowetcardId_paota, archyTacticCardList_paota)
							
							--默认点击第一个可升级的塔（没有返回左下角的塔）
							--CurrentSelectRecord.contentIdx = 0
							local firstLvUpTowerIdx = GetFirstLvUpTowerCardIdx(i)
							OnClickTowerBtn(i, firstLvUpTowerIdx)
						elseif (i == 4) then --分页4：特殊
							--创建特种塔的升级图界面（第3分页）（第4个子分页）
							OnCreateSpecialDiagramFrame(pageIndex, i)
							
							--默认点击第一个可升级的特种塔（没有返回第一项）
							--CurrentSelectRecord.contentIdx = 0
							local firstLvUpSpecialIdx = GetFirstLvUpSpecialTowerIdx()
							OnClickSpecialTowerBtn(i, firstLvUpSpecialIdx)
						end
						
						--当前按钮高亮
						hApi.AddShader(_frmNode.childUI["SubPageBtn" .. i].childUI["PageIcon"].handle.s, "normal")
						
						--其它按钮灰掉
						for k = 1, #tSubPageIcons, 1 do
							if (k ~= i) then
								hApi.AddShader(_frmNode.childUI["SubPageBtn" .. k].childUI["PageIcon"].handle.s, "gray")
							end
						end
					end
				end,
			})
			_frmNode.childUI["SubPageBtn" .. i].handle.s:setOpacity(0) --子分页按钮的控制部分，用于处理响应，不显示
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "SubPageBtn" .. i
			
			--[[
			--分页按钮的方块图标
			_frmNode.childUI["SubPageBtn" .. i].childUI["PageImage"] = hUI.image:new({
				parent = _frmNode.childUI["SubPageBtn" .. i].handle._n,
				model = "UI:Tactic_Button",
				x = 0,
				y = 0,
				w = 116,
				h = 48,
			})
			_frmNode.childUI["SubPageBtn" .. i].childUI["PageImage"].handle.s:setRotation(90)
			]]
			
			--子分页按钮的图标
			_frmNode.childUI["SubPageBtn" .. i].childUI["PageIcon"] = hUI.image:new({
				parent = _frmNode.childUI["SubPageBtn" .. i].handle._n,
				model = tSubPageIcons[i],
				x = 0,
				y = 0,
				w = 64,
				h = 64,
			})
			
			--子分页按钮的提示升级的动态箭头标识
			_frmNode.childUI["SubPageBtn" .. i].childUI["NoteJianTou"] = hUI.image:new({
				parent = _frmNode.childUI["SubPageBtn" .. i].handle._n,
				model = "ICON:image_jiantouV",
				x = 18,
				y = -15,
				w = 32,
				h = 32,
			})
			_frmNode.childUI["SubPageBtn" .. i].childUI["NoteJianTou"].handle.s:setVisible(false) --默认一开始不显示提示该分页升级的动态箭头
			
			--[[
			--子分页按钮的文字
			_frmNode.childUI["SubPageBtn" .. i].childUI["Text"] = hUI.label:new({
				parent = _frmNode.childUI["SubPageBtn" .. i].handle._n,
				x = 3,
				y = -12,
				size = 26,
				align = "MC",
				border = 1,
				font = hVar.FONTC,
				width = 26,
				text = tSubTexts[i],
			})
			]]
		end
		
		--默认第一个高亮
		hApi.AddShader(_frmNode.childUI["SubPageBtn" .. subPageIndex].childUI["PageIcon"].handle.s, "normal")
		_frmNode.childUI["SubPageBtn" .. subPageIndex].childUI["PageIcon"].handle.s:setScale(1.2)
		--其它按钮灰掉
		for k = 1, #tSubPageIcons, 1 do
			if (k ~= subPageIndex) then
				hApi.AddShader(_frmNode.childUI["SubPageBtn" .. k].childUI["PageIcon"].handle.s, "gray")
				_frmNode.childUI["SubPageBtn" .. k].childUI["PageIcon"].handle.s:setScale(1.0)
			end
		end
		
		--刷新哪个子分页能升级
		RefreshTowerUpgrateSubPage()
		
		--绘制塔基
		_frmNode.childUI["TaJiTowerIcon"] = hUI.button:new({
			parent = _parentNode,
			model = "MODEL_EFFECT:TD_Base2",
			x = OFFSET_X,
			y = OFFSET_Y + 10,
			w = BTN_EDGE * 1.1,
			h = BTN_EDGE * 62 / 114,
			z = 1,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.00,
			code = function(self, screenX, screenY, isInside)
				--点击塔的按钮
				OnClickTowerBtn(subPageIndex, 0)
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TaJiTowerIcon"
		
		--塔基的按钮选中框
		_frmNode.childUI["TaJiTowerIcon"].childUI["selectbox"] = hUI.image:new({
			parent = _frmNode.childUI["TaJiTowerIcon"].handle._n,
			model = "UI:Tactic_Selected",
			align = "MC",
			x = 0,
			y = 3,
			scale = Scale0,
		})
		_frmNode.childUI["TaJiTowerIcon"].childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, Scale0 - 0.015, Scale0 - 0.3 - 0.015), CCScaleTo:create(0.4, Scale0 + 0.025, Scale0 - 0.3 - 0.015))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["TaJiTowerIcon"].childUI["selectbox"].handle.s:runAction(forever)
		
		--第O条竖线
		_frmNode.childUI["LineV0"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineV",
			x = OFFSET_X,
			y = OFFSET_Y + 10 - BTN_EDGE / 2,
			w = 12,
			h = lineVHeight1,
			--z = 111111,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineV0"
		
		--绘制初级塔
		_frmNode.childUI["BaseTowerIcon"] = hUI.button:new({
			parent = _parentNode,
			model = hVar.tab_unit[baseTowercardId].icon,
			x = OFFSET_X,
			y = OFFSET_Y - 65,
			w = BTN_EDGE,
			h = BTN_EDGE,
			z = 1,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.00,
			code = function(self, screenX, screenY, isInside)
				--点击塔的按钮
				OnClickTowerBtn(subPageIndex, 1)
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BaseTowerIcon"
		
		--初级塔的按钮选中框
		_frmNode.childUI["BaseTowerIcon"].childUI["selectbox"] = hUI.image:new({
			parent = _frmNode.childUI["BaseTowerIcon"].handle._n,
			model = "UI:Tactic_Selected",
			align = "MC",
			x = 0,
			y = 0,
			scale = Scale0,
		})
		_frmNode.childUI["BaseTowerIcon"].childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, Scale0 - 0.015), CCScaleTo:create(0.6, Scale0 + 0.025))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["BaseTowerIcon"].childUI["selectbox"].handle.s:runAction(forever)
		
		--第一条竖线
		_frmNode.childUI["LineV1"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineV",
			x = OFFSET_X,
			y = OFFSET_Y - 50 - BTN_EDGE / 2 - lineVHeight1 / 2,
			w = 12,
			h = lineVHeight1,
			--z = 111111,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineV1"
		
		--中间升级的塔图标
		_frmNode.childUI["mediumTowerIcon"] = hUI.button:new({
			parent = _parentNode,
			model = hVar.tab_unit[mediumTowetcardId].icon,
			x = OFFSET_X,
			y = OFFSET_Y - BTN_EDGE - lineVHeight1 - 40,
			w = BTN_EDGE,
			h = BTN_EDGE,
			z = 1,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.00,
			code = function(self, screenX, screenY, isInside)
				--点击塔的按钮
				OnClickTowerBtn(subPageIndex, 2)
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "mediumTowerIcon"
		
		--中间升级的塔的按钮选中框
		_frmNode.childUI["mediumTowerIcon"].childUI["selectbox"] = hUI.image:new({
			parent = _frmNode.childUI["mediumTowerIcon"].handle._n,
			model = "UI:Tactic_Selected",
			align = "MC",
			x = 0,
			y = 0,
			scale = Scale0,
		})
		_frmNode.childUI["mediumTowerIcon"].childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, Scale0 - 0.015), CCScaleTo:create(0.6, Scale0 + 0.025))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["mediumTowerIcon"].childUI["selectbox"].handle.s:runAction(forever)
		
		--第二条竖线
		_frmNode.childUI["LineV2"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineV",
			x = OFFSET_X,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 / 2 - 1, --1像素偏差
			w = 12,
			h = lineVHeight2,
			--z = 111111,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineV2"
		
		--三叉线
		_frmNode.childUI["LineThree"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineT",
			x = OFFSET_X,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 8,
			w = 30,
			h = 16,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineThree"
		
		--左侧横线
		_frmNode.childUI["LineHL"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineH",
			x = OFFSET_X - 15 - lineHWidth / 2 - 3, --3像素偏差
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 8 - 3,
			w = lineHWidth + 15, --15像素偏差
			h = 10,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineHL"
		
		--左侧拐弯线
		_frmNode.childUI["LineRJT_L"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineRJT",
			x = OFFSET_X - 15 - lineHWidth - 12,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 8 - 12,
			w = 24,
			h = 28,
		})
		--_frmNode.childUI["LineRJT_L"].handle.s:setFlipX(true)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineRJT_L"
		
		--右侧横线
		_frmNode.childUI["LineHR"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineH",
			x = OFFSET_X + 15 + lineHWidth / 2 - 3,--3像素偏差
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 8 - 3,
			w = lineHWidth + 15, --15像素偏差
			h = 10,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineHR"
		
		--右侧拐弯线
		_frmNode.childUI["LineRJT_R"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineRJT",
			x = OFFSET_X + 15 + lineHWidth + 12,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 8 - 12,
			w = 24,
			h = 28,
		})
		_frmNode.childUI["LineRJT_R"].handle.s:setFlipX(true)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineRJT_R"
		
		--中间的竖线箭头
		_frmNode.childUI["LineJT_M"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineJT",
			x = OFFSET_X,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 24,
			w = 24,
			h = 20,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineJT_M"
		
		--第一个改造塔的分支
		local tacticCardId1 = archyTacticCardList[1] --第一个战术技能卡分支的id
		local model1 = "UI:LOCK"
		if tacticCardId1 and (tacticCardId1 ~= 0) then
			model1 = hVar.tab_tactics[tacticCardId1].icon
		end
		_frmNode.childUI["archyTowerIcon1"] = hUI.button:new({
			parent = _parentNode,
			model = model1,
			x = OFFSET_X - 15 - lineHWidth - 12,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 36 - BTN_EDGE / 2,
			w = BTN_EDGE,
			h = BTN_EDGE,
			z = 1,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.00,
			code = function(self, screenX, screenY, isInside)
				--点击塔的按钮
				OnClickTowerBtn(subPageIndex, 3)
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "archyTowerIcon1"
		
		--第二个改造塔的分支
		local tacticCardId2 = archyTacticCardList[2] --第二个战术技能卡分支的id
		local model2 = "UI:LOCK"
		if tacticCardId2 and (tacticCardId2 ~= 0) then
			model2 = hVar.tab_tactics[tacticCardId2].icon
		end
		_frmNode.childUI["archyTowerIcon2"] = hUI.button:new({
			parent = _parentNode,
			model = model2,
			x = OFFSET_X,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 36 - BTN_EDGE / 2,
			w = BTN_EDGE,
			h = BTN_EDGE,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.00,
			z = 1,
			code = function(self, screenX, screenY, isInside)
				--点击塔的按钮
				OnClickTowerBtn(subPageIndex, 4)
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "archyTowerIcon2"
		
		--第三个改造塔的分支
		local tacticCardId3 = archyTacticCardList[3] --第三个战术技能卡分支的id
		local model3 = "UI:LOCK"
		if tacticCardId3 and (tacticCardId3 ~= 0) then
			model3 = hVar.tab_tactics[tacticCardId3].icon
		end
		_frmNode.childUI["archyTowerIcon3"] = hUI.button:new({
			parent = _parentNode,
			model = model3,
			x = OFFSET_X + 15 + lineHWidth + 12,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 36 - BTN_EDGE / 2,
			w = BTN_EDGE,
			h = BTN_EDGE,
			z = 1,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.00,
			code = function(self, screenX, screenY, isInside)
				--点击塔的按钮
				OnClickTowerBtn(subPageIndex, 5)
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "archyTowerIcon3"
		
		--获得所有的塔类战术技能卡
		local towerDictionary = {} --塔类战术技能卡
		local tTactics = LuaGetPlayerSkillBook()
		if tTactics then
			for i = 1,#tTactics, 1 do
				if type(tTactics[i])=="table" then
					local id, lv, num = unpack(tTactics[i])
					--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
					
					--存在表项
					if hVar.tab_tactics[id] then
						local type = hVar.tab_tactics[id].type --战术技能卡类型
						if (type == hVar.TACTICS_TYPE.TOWER) then --此类专属于塔类战术技能卡，放在此处
							--检测是否重复
							if (towerDictionary[id]) then --已存在
								--如果等级更大，用大等级的
								if (lv > towerDictionary[j].skillLV) then
									towerDictionary[j].skillLV = lv
									towerDictionary[j].num = num
								end
							else --不存在
								towerDictionary[id] = {skillID = id, skillLV = lv, num = num}
							end
						end
					end
				end
			end
		end
		
		--依次绘制每个改造塔的子控件
		for i = 1, 3, 1 do
			local button = _frmNode.childUI["archyTowerIcon" .. i]
			local towerLv = 0 --塔的等级
			local towerNum = 0 --塔类碎片的数量
			local towerLvMax = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1 --塔类的最大等级
			local requireDebriNum = hVar.TACTIC_LVUP_INFO[1].costDebris --升级需要的碎片的数量
			local nowScore = LuaGetPlayerScore() --当前的积分
			local costScore = 0 --升级需要的积分
			
			local tacticCardId = archyTacticCardList[i] --战术技能卡id
			if (towerDictionary[tacticCardId]) then
				towerLv = towerDictionary[tacticCardId].skillLV --塔的等级
				towerNum = towerDictionary[tacticCardId].num --塔类碎片的数量
				
				--当前等级不超过最大等级
				if (towerLv > towerLvMax) then
					towerLv = towerLvMax
				end
				
				local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO[towerLv]
				requireDebriNum = tacticLvUpInfo.costDebris --升级需要的碎片的数量
				local shopItemId = tacticLvUpInfo.shopItemId or 0
				local tabShopItem = hVar.tab_shopitem[shopItemId]
				if tabShopItem then
					costScore = tabShopItem.score or 0 --需要的积分
				end
			end
			
			--塔的按钮选中框
			button.childUI["selectbox"] = hUI.image:new({
				parent = button.handle._n,
				model = "UI:Tactic_Selected",
				align = "MC",
				x = 0,
				y = 0,
				scale = Scale0,
			})
			button.childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
			_frmNode.childUI["mediumTowerIcon"].childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
			local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, Scale0 - 0.015), CCScaleTo:create(0.6, Scale0 + 0.025))
			local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
			button.childUI["selectbox"].handle.s:runAction(forever)
			
			if (tacticCardId ~= 0) then
				--塔的的等级的背景图
				button.childUI["LvBG"]= hUI.image:new({
					parent = button.handle._n,
					model = "ui/pvp/pvpselect.png",
					x = BTN_EDGE - 38,
					y = 28,
					w = 34,
					h = 34,
				})
				
				--塔的等级文字
				local fontSize = 26
				if towerLv and (towerLv >= 10) then --如果等级是2位数的，那么缩一下文字
					fontSize = 18
				end
				button.childUI["Lv"] = hUI.label:new({
					parent = button.handle._n,
					x = BTN_EDGE - 38,
					y = 27,
					text = towerLv,
					size = fontSize,
					font = "numWhite",
					align = "MC",
					width = 200,
				})
				
				--塔的将魂经验条
				button.childUI["barSoulStoneExp"] = hUI.valbar:new({
					parent = button.handle._n,
					x = -31,
					y = -42,
					w = BTN_EDGE,
					h = 15,
					align = "LC",
					back = {model = "UI:SoulStoneBarBg1", x = -2, y = 0, w = BTN_EDGE + 4, h = 18},
					model = "UI:SoulStoneBar1",
					--model = "misc/progress.png",
					v = 0,
					max = 100,
				})
				
				--将魂可以升级的箭头提示
				--塔的升级的动态箭头
				button.childUI["towerSoulStonejianTou"] = hUI.image:new({
					parent = button.handle._n,
					model = "ICON:image_jiantouV",
					x = 15,
					y = -11,
					w = 26, --236
					h = 26, --146
					align = "MC",
				})
				--_frm.childUI["towerSoulStonejianTou"].handle._n:setRotation(0)
				button.childUI["towerSoulStonejianTou"].handle.s:setVisible(false) --默认隐藏
				
				--print(towerLv ,towerLvMax,towerNum,requireDebriNum)
				--根据碎片和当前等级的不同，来绘制一些控件的数值或颜色
				if (towerLv <= 0) then --还没有获得这个塔
					--灰掉
					hApi.AddShader(button.handle.s, "gray")
					
					--设置碎片进度
					button.childUI["barSoulStoneExp"]:setV(towerNum, requireDebriNum)
					
					--可升级的提示
					--碎片足够、积分足够
					local nowScore = LuaGetPlayerScore() --当前的积分
					local itemId = 0 --商品道具id
					local tacticInfo = LuaGetPlayerTacticById(cardId)
					if tacticInfo then
						local id, lv, num = unpack(tacticInfo)
						nowDebris = num --当前的碎片数量
					end
					
					--未升满级
					--碎片足够、积分足够，才提示可升级
					if (towerNum >= requireDebriNum) and (nowScore >= costScore) then
						button.childUI["towerSoulStonejianTou"].handle.s:setVisible(true) --显示可升级的箭头提示
					else
						button.childUI["towerSoulStonejianTou"].handle.s:setVisible(false) --隐藏可升级的箭头提示
					end
				else --已经获得这个塔
					--正常
					hApi.AddShader(button.handle.s,"normal")
					
					if (towerLv >= towerLvMax) then --塔的等级已经升到最高级
						--设置碎片进度为0
						button.childUI["barSoulStoneExp"]:setV(0, 100)
						--button.childUI["labSoulStoneExp"]:setText(hVar.tab_string[("__BLANK__")])
						
						--隐藏可升级的提示
						button.childUI["towerSoulStonejianTou"].handle.s:setVisible(false) --隐藏可升级的箭头提示
						
						--创建一个进度条满了的特别进度条
						button.childUI["towerMaxLvProgressImg"] = hUI.image:new({
							parent = button.handle._n,
							model = "misc/jdt2.png", --"UI:IMG_ValueBarBoss",
							x = -31 + BTN_EDGE / 2,
							y = -42,
							w = BTN_EDGE, --236
							h = 15, --146
							align = "MC",
						})
					else --还可以升级
						--设置碎片进度
						button.childUI["barSoulStoneExp"]:setV(towerNum, requireDebriNum)
						--button.childUI["labSoulStoneExp"]:setText(tostring(towerNum).. "/".. tostring(requireDebriNum))
						
						--可升级的提示
						--碎片足够、积分足够，才提示可升级
						if (towerNum >= requireDebriNum) and (nowScore >= costScore) then
							button.childUI["towerSoulStonejianTou"].handle.s:setVisible(true) --显示可升级的箭头提示
						else
							button.childUI["towerSoulStonejianTou"].handle.s:setVisible(false) --隐藏可升级的箭头提示
						end
					end
				end
			end
		end
		
		--[[
		--塔的名字、介绍部分的底板
		_frmNode.childUI["TowerIntroBG"] = hUI.button:new({
			parent = _parentNode,
			model = "UI:Tactic_IntroBG",
			x = OFFSET_X,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 159 - BTN_EDGE / 2 - 5,
			w = 320,
			h = 140,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TowerIntroBG"
		]]
		
		--塔的类型底图
		_frmNode.childUI["TowerTypeImg"] = hUI.image:new({
			parent = _parentNode,
			x = 190 / 2 + 15 * _ScaleW,
			y = -100 * _ScaleH,
			model = "UI:PVP_RedCover",
			w = 190,
			h = 50,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TowerTypeImg"
		
		--塔的类型文字
		_frmNode.childUI["TowerTypeLabel"] = hUI.label:new({
			parent = _parentNode,
			x = 190 / 2 + 15 * _ScaleW - 15,
			y = -100 * _ScaleH - 1, --文字有1像素的偏差
			text = "",
			size = 36,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
		})
		--_frmNode.childUI["TowerTypeLabel"].handle.s:setColor(ccc3(255, 255, 0)) --橙色
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TowerTypeLabel"
		
		--塔的名字文字
		_frmNode.childUI["TowerNameLabel"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 190 + 39,
			text = "",
			size = 30,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
		})
		_frmNode.childUI["TowerNameLabel"].handle.s:setColor(ccc3(255, 255, 0)) --橙色
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TowerNameLabel"
		
		--塔的等级文字
		_frmNode.childUI["TowerLvLabel"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X + 55,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 190 + 39,
			text = "",
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 300,
			border = 1,
		})
		_frmNode.childUI["TowerLvLabel"].handle.s:setColor(ccc3(255, 255, 0)) --橙色
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TowerLvLabel"
		
		--塔的简介文字
		_frmNode.childUI["TowerIntroLabel"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X - 142,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 190 + 24,
			size = 26,
			font = hVar.FONTC,
			align = "LT",
			width = 300,
			text = "",
			border = 1,
		})
		_frmNode.childUI["TowerIntroLabel"].handle.s:setColor(ccc3(255, 255, 255)) --白色
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TowerIntroLabel"
		
		--右侧显示提示点击塔的图标查看文字
		_frmNode.childUI["HintClickTower"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X + 400,
			y = -278,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 330,
			--text = "点击左侧塔查看详情。", --language
			text = hVar.tab_string["ClickTowerSeeDetail"], --language
			border = 1,
		})
		_frmNode.childUI["HintClickTower"].handle.s:setColor(ccc3(196, 196, 196))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "HintClickTower"
		
		--只在本分页有效
		--监听积分改变事件
		hGlobal.event:listen("LocalEvent_SetCurGameScore", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听金币改变事件
		hGlobal.event:listen("LocalEvent_SetCurGameCoin", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听金币改变（手机版）事件
		hGlobal.event:listen("LocalEvent_Phone_SetCurGameCoin_Game", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听获得战术技能卡（碎片）事件
		hGlobal.event:listen("Event_PlayerGetTacticCard", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听英雄技能升级返回事件
		hGlobal.event:listen("Local_Event_HeroSkill_LvUp_Result", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听通知刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
		hGlobal.event:listen("LocalEvent_RefreshMedalStateUI", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
	end
	--函数：点击塔的按钮的执行逻辑
	OnClickTowerBtn = function(subPageIndex, contentIndex)
		--print("OnClickTowerBtn", subPageIndex, contentIndex, CurrentSelectRecord.pageIdx, CurrentSelectRecord.contentIdx)
		--不重复绘制同一个项索引值
		if (CurrentSelectRecord.subPageIdx == subPageIndex) and (CurrentSelectRecord.contentIdx == contentIndex) then
			--print("不重复绘制同一个项索引值", subPageIndex, contentIndex)
			return
		end
		
		--print(pageIndex, cardId, bIsUnit, bIsBaseTower)
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--获得参数
		local button = nil --按钮控件
		local bIsUnit = nil --是否是单位塔
		local bIsBaseTower = nil --是否是最原始的塔
		local bIsTaJi = nil --是否是塔基
		local cardId = nil --卡牌id
		if (contentIndex == 0) then --塔基
			button = _frmNode.childUI["TaJiTowerIcon"]
			bIsUnit = true
			bIsBaseTower = true
			bIsTaJi = true --是否是塔基
			
			cardId = 69997 --塔基
		elseif (contentIndex == 1) then --最初级塔
			button = _frmNode.childUI["BaseTowerIcon"]
			bIsUnit = true
			bIsBaseTower = true
			bIsTaJi = false --是否是塔基
			
			if (subPageIndex == 1) then --箭塔
				cardId = baseTowercardId_jianta
			elseif (subPageIndex == 2) then --法术塔
				cardId = baseTowercardId_fashu
			elseif (subPageIndex == 3) then --炮塔
				cardId = baseTowercardId_paota
			end
		elseif (contentIndex == 2) then --升后的高级塔
			button = _frmNode.childUI["mediumTowerIcon"]
			bIsUnit = true
			bIsBaseTower = false
			bIsTaJi = false --是否是塔基
			
			if (subPageIndex == 1) then --箭塔
				cardId = mediumTowetcardId_jianta
			elseif (subPageIndex == 2) then --法术塔
				cardId = mediumTowetcardId_fashu
			elseif (subPageIndex == 3) then --炮塔
				cardId = mediumTowetcardId_paota
			end
		elseif (contentIndex == 3) then --分支1塔
			button = _frmNode.childUI["archyTowerIcon1"]
			bIsUnit = false
			bIsBaseTower = false
			bIsTaJi = false --是否是塔基
			
			if (subPageIndex == 1) then --箭塔
				cardId = archyTacticCardList_jianta[1]
			elseif (subPageIndex == 2) then --法术塔
				cardId = archyTacticCardList_fashu[1]
			elseif (subPageIndex == 3) then --炮塔
				cardId = archyTacticCardList_paota[1]
			end
		elseif (contentIndex == 4) then --分支2塔
			button = _frmNode.childUI["archyTowerIcon2"]
			bIsUnit = false
			bIsBaseTower = false
			bIsTaJi = false --是否是塔基
			
			if (subPageIndex == 1) then --箭塔
				cardId = archyTacticCardList_jianta[2]
			elseif (subPageIndex == 2) then --法术塔
				cardId = archyTacticCardList_fashu[2]
			elseif (subPageIndex == 3) then --炮塔
				cardId = archyTacticCardList_paota[2]
			end
		elseif (contentIndex == 5) then --分支3塔
			button = _frmNode.childUI["archyTowerIcon3"]
			bIsUnit = false
			bIsBaseTower = false
			bIsTaJi = false --是否是塔基
			
			if (subPageIndex == 1) then --箭塔
				cardId = archyTacticCardList_jianta[3]
			elseif (subPageIndex == 2) then --法术塔
				cardId = archyTacticCardList_fashu[3]
			elseif (subPageIndex == 3) then --炮塔
				cardId = archyTacticCardList_paota[3]
			end
		end
		
		--其它塔的选中框灰掉
		if (button ~= _frmNode.childUI["TaJiTowerIcon"]) then
			if _frmNode.childUI["TaJiTowerIcon"] then
				_frmNode.childUI["TaJiTowerIcon"].childUI["selectbox"].handle.s:setVisible(false) --隐藏
			end
		end
		if (button ~= _frmNode.childUI["BaseTowerIcon"]) then
			if _frmNode.childUI["BaseTowerIcon"] then
				_frmNode.childUI["BaseTowerIcon"].childUI["selectbox"].handle.s:setVisible(false) --隐藏
			end
		end
		if (button ~= _frmNode.childUI["mediumTowerIcon"]) then
			if _frmNode.childUI["mediumTowerIcon"] then
				_frmNode.childUI["mediumTowerIcon"].childUI["selectbox"].handle.s:setVisible(false) --隐藏
			end
		end
		for i = 1, 3, 1 do
			if (button ~= _frmNode.childUI["archyTowerIcon" .. i]) then
				if _frmNode.childUI["archyTowerIcon" .. i] then
					_frmNode.childUI["archyTowerIcon" .. i].childUI["selectbox"].handle.s:setVisible(false) --隐藏
				end
			end
		end
		for i = 1, 12, 1 do
			if (button ~= _frmNode.childUI["SpecialCard" .. i]) then
				if _frmNode.childUI["SpecialCard" .. i] then
					_frmNode.childUI["SpecialCard" .. i].childUI["selectbox"].handle.s:setVisible(false) --隐藏
				end
			end
		end
		
		--自身的选中框高亮
		button.childUI["selectbox"].handle.s:setVisible(true) --显示
		
		--塔的等级
		local towerLv = 0 --等级
		
		--显示塔的系
		local strTowerType = nil
		if (subPageIndex == 1) then --箭塔
			strTowerType = hVar.tab_string["JianTaPage"] --"箭塔"
		elseif (subPageIndex == 2) then --法术塔
			strTowerType = hVar.tab_string["FashuTaPage"] --"法术塔"
		elseif (subPageIndex == 3) then --炮塔
			strTowerType = hVar.tab_string["PaoTaPage"] --"炮塔"
		elseif (subPageIndex == 4) then --特种塔
			strTowerType = hVar.tab_string["TeShuTaPage"] --"特种塔"
		end
		--_frmNode.childUI["TowerTypeLabel"]:setText("箭塔系") --language
		_frmNode.childUI["TowerTypeLabel"]:setText(strTowerType) --language
		
		--显示塔的名称和说明
		local towerName = "" --塔的名字
		local towerIntro = "" --塔的简介
		local szTowerLv = "" --塔的等级文字描述
		local towerLvColor = nil --塔的等级文字的颜色
		if bIsUnit then --是单位
			--显示单位的名字
			towerName = hVar.tab_stringU[cardId] and hVar.tab_stringU[cardId][1] or ("未知塔" .. cardId)
			
			--不显示等级文字
			szTowerLv = ""
			towerLvColor = ccc3(255, 255, 0) --橙色
			
			--显示单位的简介
			towerIntro = hVar.tab_stringU[cardId] and hVar.tab_stringU[cardId][2] or ("未知单位说明" .. cardId)
		else --是塔类战术技能卡
			if (cardId ~= 0) then --已开放的塔类战术技能卡分支
				--显示塔类战术技能卡的名字
				towerName = hVar.tab_stringT[cardId] and hVar.tab_stringT[cardId][1] or ("未知塔" .. cardId)
				
				--显示塔类战术技能卡的简介
				local tTactics = LuaGetPlayerSkillBook()
				if tTactics then
					for i = 1,#tTactics, 1 do
						if type(tTactics[i])=="table" then
							local id, lv, num = unpack(tTactics[i])
							
							--是否一致
							if (id == cardId) then --已存在
								--如果等级更大，用大等级的
								if (lv > towerLv) then
									towerLv = lv
								end
							end
						end
					end
				end
				
				local showTowerLv = towerLv --显示文字的塔的等级
				if (showTowerLv == 0) then
					showTowerLv = 1
				end
				--显示不超过最大等级
				local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
				if (showTowerLv > maxLv) then
					showTowerLv = maxLv
				end
				if (towerLv > 0) then --已获得的塔
					--szTowerLv = showTowerLv .. "级" --language
					szTowerLv = showTowerLv .. hVar.tab_string["__TEXT_ji"] --language
					towerLvColor = ccc3(255, 255, 128) --黄色
				else --未获得的塔
					--szTowerLv = "未获得" --language
					szTowerLv = hVar.tab_string["CurrentNotGet"] --language
					towerLvColor = ccc3(255, 0, 0) --红色
				end
				
				towerIntro = hVar.tab_stringT[cardId] and hVar.tab_stringT[cardId][showTowerLv + 1] or ("未知战术技能卡说明" .. cardId)
			else --还未开放的战术技能卡分支
				--未开放的战术技能卡的名字
				towerName = ""
				
				--未开放的战术技能卡的等级
				szTowerLv = ""
				towerLvColor = ccc3(255, 255, 0) --橙色
				
				--未开放的战术技能卡的简介
				towerIntro = ""
			end
		end
		
		--更新说明
		_frmNode.childUI["TowerNameLabel"]:setText(towerName)
		_frmNode.childUI["TowerLvLabel"]:setText(szTowerLv)
		_frmNode.childUI["TowerLvLabel"].handle.s:setColor(towerLvColor)
		_frmNode.childUI["TowerIntroLabel"]:setText(towerIntro)
		
		--更新详细面板
		--先清空上次右侧的控件集
		_removeRightFrmFunc(pageIndex)
		
		--显示不超过最大等级
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		if (towerLv > maxLv) then
			towerLv = maxLv
		end
		
		--塔的单位
		local towerUnitId = cardId --塔的单位的类型id
		if (not bIsUnit)and (cardId ~= 0) then
			if (towerLv == 0) then
				towerUnitId = hVar.tab_tactics[cardId].remouldUnlock[1][1]
			else
				towerUnitId = hVar.tab_tactics[cardId].remouldUnlock[towerLv][1]
			end
		end
		
		--print("towerUnitId", towerUnitId, towerLv)
		
		--第一个文字的偏移值
		local FONT_OFFSET_X = hVar.SCREEN.w - 650 *_ScaleW --第一个文字的偏移值x
		local FONT_OFFSET_Y = -140 * _ScaleH --第一个文字的偏移值y
		if (g_phone_mode ~= 0) then --手机模式
			FONT_OFFSET_X = hVar.SCREEN.w - 650 *_ScaleW --第一个文字的偏移值x
			FONT_OFFSET_Y = -100 * _ScaleH --第一个文字的偏移值y
			
			--iphone4
			if (hVar.SCREEN.w <= 960) then
				FONT_OFFSET_X = hVar.SCREEN.w - 650 *_ScaleW --第一个文字的偏移值x
				FONT_OFFSET_Y = -100 * _ScaleH --第一个文字的偏移值y
			end
		end
		local FONT_UNIT_DX = 0 --单位类型的塔的额外偏移值x
		local FONT_LV0_DX = 0 --0级塔的额外偏移值x
		if bIsUnit then
			FONT_UNIT_DX = 90
		elseif (towerLv <= 0) then
			FONT_LV0_DX = 90
		end
		
		local FONT_DELTA_Y = 40 --文字间的间隔y
		
		--读取塔单位的属性
		if (cardId ~= 0) then --已解锁的塔
			local attr = hVar.tab_unit[towerUnitId].attr --属性表
			local atk_min = attr.attack[4] --最小攻击力
			local atk_max = attr.attack[5] --最大攻击力
			local atk_speed = attr.atk_interval --攻击速度
			local atk_range = attr.atk_radius --射程
			
			local atkSpeed = atk_speed / 1000
			local divValue = math.floor(atkSpeed)
			local modValue = (atkSpeed - divValue) * 100
			local szAtkSpeed = ("%d.%s"):format(divValue, tostring(modValue)) --保留2位小数
			
			--显示“攻击”文字
			_frmNode.childUI["AtkPrefix"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX,
				y = FONT_OFFSET_Y,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 300,
				--text = "攻击", --language
				text = hVar.tab_string["__Attr_Hint_atk"], --language
				border = 1,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkPrefix"
			
			--显示攻击力
			local atkFont = "numWhite"
			local atkValueTotal = atk_min .. "-" .. atk_max
			local atkSize = 24
			local atkShowBorder = 0
			local atkExtaDx = 0 --额外的偏移值x
			if (#atkValueTotal > 6) then --如果攻击力文字过长，缩小字体
				atkSize = 20
			end
			if (atk_max <= 0) then --如果该单位没有攻击力，那么显示"无"
				atkSize = 26
				--atkValueTotal = "无" --language
				atkValueTotal = hVar.tab_string["__TEXT_Nothing"] --language
				atkFont = hVar.FONTC
				atkShowBorder = 1
				atkExtaDx = 40 --额外的偏移值x
			end
			_frmNode.childUI["AtkValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX + 70 + atkExtaDx,
				y = FONT_OFFSET_Y - 1, --数字字体有1像素偏差
				size = atkSize,
				font = atkFont,
				align = "LC",
				width = 300,
				text = atkValueTotal,
				border = atkShowBorder,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkValue"
			
			--显示“攻速”文字
			_frmNode.childUI["AtkSpeedPrefix"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX,
				y = FONT_OFFSET_Y - FONT_DELTA_Y,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 300,
				--text = "攻速", --language
				text = hVar.tab_string["__Attr_Speed"], --language
				border = 1,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkSpeedPrefix"
			
			--显示攻击速度值
			local atkSpeedFont = "numWhite"
			local atkSpeedSize = 24
			local atkSpeedShowBorder = 0
			local atkSpeedExtaDx = 0 --额外的偏移值x
			if (atk_max <= 0) then --如果该单位没有攻击力，那么显示"无"
				atkSpeedSize = 26
				--szAtkSpeed = "无" --language
				szAtkSpeed = hVar.tab_string["__TEXT_Nothing"] --language
				atkSpeedFont = hVar.FONTC
				atkSpeedShowBorder = 1
				atkSpeedExtaDx = 40 --额外的偏移值x
			end
			_frmNode.childUI["AtkSpeedValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX + 70 + atkSpeedExtaDx,
				y = FONT_OFFSET_Y - FONT_DELTA_Y - 1, --数字字体有1像素偏差
				size = atkSpeedSize,
				font = atkSpeedFont,
				align = "LC",
				width = 300,
				text = szAtkSpeed,
				border = atkSpeedShowBorder,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkSpeedValue"
			
			--显示“射程”文字
			_frmNode.childUI["AtkRangePrefix"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 300,
				--text = "射程", --language
				text = hVar.tab_string["__Attr_Atk_Range"], --language
				border = 1,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkRangePrefix"
			
			--显示射程值
			local atkRangeFont = "numWhite"
			local atkRangeSize = 24
			local atkRangeShowBorder = 0
			local atkRangeExtaDx = 0 --额外的偏移值x
			if (atk_max <= 0) then --如果该单位没有攻击力，那么显示"无"
				atkRangeSize = 26
				--atk_range = "无" --language
				atk_range = hVar.tab_string["__TEXT_Nothing"] --language
				atkRangeFont = hVar.FONTC
				atkRangeShowBorder = 1
				atkRangeExtaDx = 40 --额外的偏移值x
			end
			_frmNode.childUI["AtkRangeValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX + 70 + atkRangeExtaDx,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 1, --数字字体有1像素偏差
				size = 24,
				font = atkRangeFont,
				align = "LC",
				width = 300,
				text = atk_range,
				border = atkRangeShowBorder,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkRangeValue"
			
			--显示分割线1
			_frmNode.childUI["SeparateLine1"] = hUI.image:new({
				parent = _parentNode,
				model = "UI:Tactic_SeparateLine",
				x = FONT_OFFSET_X + 172,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 45,
				w = 364,
				h = 4,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "SeparateLine1"
			
			--分支：基础塔显示基本描述，战术技能卡显示技能和升级按钮
			if bIsUnit then --是基础塔
				--塔基，显示一些辅助信息
				if bIsTaJi then --最初级的塔
					--显示塔基的辅助信息
					_frmNode.childUI["BaseTowerHint"] = hUI.label:new({
						parent = _parentNode,
						x = FONT_OFFSET_X + 10,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 70,
						size = 26,
						font = hVar.FONTC,
						align = "LT",
						width = 330,
						--text = "游戏局中固定位置摆放的塔基，可建造箭塔、法术塔、炮塔、特种塔。", --language
						text = hVar.tab_string["Tower_TaJi_Intro"], --language
						border = 1,
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "BaseTowerHint"
				--基础塔，显示一些辅助信息
				elseif bIsBaseTower then --最初级的塔
					--显示最初始的塔的辅助信息
					_frmNode.childUI["BaseTowerHint"] = hUI.label:new({
						parent = _parentNode,
						x = FONT_OFFSET_X + 10,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 70,
						size = 26,
						font = hVar.FONTC,
						align = "LT",
						width = 330,
						--text = "最初级的塔，由塔基建造而成。", --language
						text = hVar.tab_string["Tower_Base_Intro"], --language
						border = 1,
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "BaseTowerHint"
				else --第一次升级后的塔
					--显示最初始的塔的辅助信息
					_frmNode.childUI["BaseTowerHint"] = hUI.label:new({
						parent = _parentNode,
						x = FONT_OFFSET_X + 10,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 70,
						size = 26,
						font = hVar.FONTC,
						align = "LT",
						width = 330,
						--text = "通过初级塔再次建造而成，并可选择某个高级塔分支再次建造。（需要在游戏中携带该分支的卡牌）", --language
						text = hVar.tab_string["Tower_Medium_Intro"], --language
						border = 1,
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "BaseTowerHint"
				end
			else --是战术技能卡塔
				--显示下一级塔的属性
				local towerLvMax = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1 --塔类的最大等级
				
				--如果该塔不是0级才显示下一级的属性
				--print(towerLv)
				if (towerLv > 0) then
					local next_font = nil --下一级的文字字体
					local next_color = nil --下一级的文字颜色
					local next_szAtk = nil --攻击力
					local next_szAtkSpeed = nil --攻击速度
					local next_atk_range = nil --射程
					
					--print("towerLv=", towerLv, "towerLvMax=", towerLvMax)
					if (towerLv >= towerLvMax) then --塔已升到顶级
						next_font = hVar.FONTC --下一级的文字字体
						next_color = ccc3(255, 64, 0) --下一级的文字颜色
						--next_szAtk = "已到顶级" --攻击力 --language
						--next_szAtkSpeed = "已到顶级" --攻击速度 --language
						--next_atk_range = "已到顶级" --射程 --language
						next_szAtk = hVar.tab_string["UpToMaxLv"] --攻击力 --language
						next_szAtkSpeed = hVar.tab_string["UpToMaxLv"] --攻击速度 --language
						next_atk_range = hVar.tab_string["UpToMaxLv"] --射程 --language
					else
						--读取下一级塔单位的属性
						local next_towerUnitId = hVar.tab_tactics[cardId].remouldUnlock[towerLv + 1][1]
						next_font = "numWhite" --下一级的文字字体
						next_color = ccc3(0, 255, 0) --下一级的文字颜色
						next_szAtk = "?-?" --攻击力
						next_szAtkSpeed = "?" --攻击速度
						next_atk_range = "?" --射程
						
						local tUnit = hVar.tab_unit[next_towerUnitId] --下一级的表项
						
						if tUnit then
							local next_attr = tUnit.attr --属性表
							local next_atk_min = next_attr.attack[4] --最小攻击力
							local next_atk_max = next_attr.attack[5] --最大攻击力
							local next_atk_speed = next_attr.atk_interval --攻击速度
							next_szAtk = next_atk_min .. "-" .. next_atk_max
							if (next_atk_min == next_atk_max) then --如果下一级两个攻击力一样大，那么合并
								next_szAtk = tostring(next_atk_min)
							end
							next_atk_range = next_attr.atk_radius --射程
							
							local next_atkSpeed = next_atk_speed / 1000
							local next_divValue = math.floor(next_atkSpeed)
							local next_modValue = (next_atkSpeed - next_divValue) * 100
							next_szAtkSpeed = ("%d.%s"):format(next_divValue, tostring(next_modValue)) --保留2位小数
						end
					end
					
					--显示“攻击”的箭头
					_frmNode.childUI["AtkJianTou"] = hUI.image:new({
						parent = _parentNode,
						x = FONT_OFFSET_X + 210,
						y = FONT_OFFSET_Y,
						w = 30,
						h = 20,
						model = "UI:Tactic_RPointer",
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkJianTou"
					
					--显示“攻速”的箭头
					_frmNode.childUI["AtkSpeedJianTou"] = hUI.image:new({
						parent = _parentNode,
						x = FONT_OFFSET_X + 210,
						y = FONT_OFFSET_Y - FONT_DELTA_Y,
						w = 30,
						h = 20,
						model = "UI:Tactic_RPointer",
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkSpeedJianTou"
					
					--显示“射程”的箭头
					_frmNode.childUI["AtkRangeJianTou"] = hUI.image:new({
						parent = _parentNode,
						x = FONT_OFFSET_X + 210,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2,
						w = 30,
						h = 20,
						model = "UI:Tactic_RPointer",
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkRangeJianTou"
					
					--显示下一级攻击力
					local next_atkSize = 24
					local next_atkShowBorder = 0
					if (#next_szAtk > 6) then --如果下一级攻击力文字过长，缩小字体
						next_atkSize = 20
					end
					if (towerLv >= towerLvMax) then --塔已升到顶级
						next_atkSize = 24 --这里是中文，可以显示的下
						next_atkShowBorder = 1
					end
					
					_frmNode.childUI["AtkNextValue"] = hUI.label:new({
						parent = _parentNode,
						x = FONT_OFFSET_X + 250,
						y = FONT_OFFSET_Y - 1, --数字字体有1像素偏差
						size = next_atkSize,
						font = next_font,
						align = "LC",
						width = 300,
						text = next_szAtk,
						border = next_atkShowBorder,
					})
					_frmNode.childUI["AtkNextValue"].handle.s:setColor(next_color)
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkNextValue"
					
					--显示下一级攻击速度
					_frmNode.childUI["AtkSpeedNextValue"] = hUI.label:new({
						parent = _parentNode,
						x = FONT_OFFSET_X + 250,
						y = FONT_OFFSET_Y - FONT_DELTA_Y - 1, --数字字体有1像素偏差
						size = 24,
						font = next_font,
						align = "LC",
						width = 300,
						text = next_szAtkSpeed,
						border = next_atkShowBorder,
					})
					_frmNode.childUI["AtkSpeedNextValue"].handle.s:setColor(next_color)
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkSpeedNextValue"
					
					--显示下一级攻击射程
					_frmNode.childUI["AtkRangeNextValue"] = hUI.label:new({
						parent = _parentNode,
						x = FONT_OFFSET_X + 250,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 1, --数字字体有1像素偏差
						size = 24,
						font = next_font,
						align = "LC",
						width = 300,
						text = next_atk_range,
						border = next_atkShowBorder,
					})
					_frmNode.childUI["AtkRangeNextValue"].handle.s:setColor(next_color)
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkRangeNextValue"
				end
				
				--显示塔的技能
				local order = hVar.tab_unit[towerUnitId].td_upgrade.upgradeSkill.order --塔的技能列表
				for i = 1, #order, 1 do
					--响应技能点击事件的按钮区域
					local skill_id = order[i] --技能id
					_frmNode.childUI["SkillButton" .. i] = hUI.button:new({
						parent = _parentNode,
						model = "misc/mask.png",
						x = FONT_OFFSET_X + 160,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 100 - (i - 1) * 72,
						w = 360,
						h = 68,
						dragbox = _frm.childUI["dragBox"],
						scaleT = 1.00,
						codeOnTouch = function(self, screenX, screenY, isInside)
							--显示塔的技能说明
							OnCreateSkillTipFrame(towerUnitId, skill_id, i)
						end,
					})
					_frmNode.childUI["SkillButton" .. i].handle.s:setOpacity(0) --用于响应点击事件，不显示
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillButton" .. i
					
					--创建技能图标
					_frmNode.childUI["SkillIcon" .. i] = hUI.image:new({
						parent = _parentNode,
						model = hVar.tab_skill[skill_id].icon,
						x = FONT_OFFSET_X + FONT_LV0_DX + 32,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 100 - (i - 1) * 72,
						w = 64,
						h = 64,
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillIcon" .. i
					
					--创建技能选中框
					local Scale0 = 64 / 70
					_frmNode.childUI["SkillIcon" .. i].childUI["selectbox"] = hUI.image:new({
						parent = _frmNode.childUI["SkillIcon" .. i].handle._n,
						model = "UI:Tactic_Selected",
						x = 32,
						y = 32,
						scale = Scale0,
					})
					_frmNode.childUI["SkillIcon" .. i].childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
					local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, Scale0 - 0.015), CCScaleTo:create(0.6, Scale0 + 0.025))
					local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
					_frmNode.childUI["SkillIcon" .. i].childUI["selectbox"].handle.s:runAction(forever)
					
					--创建技能名称
					_frmNode.childUI["SkillName" .. i] = hUI.label:new({
						parent = _parentNode,
						size = 26,
						x = FONT_OFFSET_X + FONT_LV0_DX + 75,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 85 - (i - 1) * 72,
						w = 300,
						align = "LC",
						font = hVar.FONTC,
						text = hVar.tab_stringS[skill_id] and hVar.tab_stringS[skill_id][1] or ("未知技能" .. skill_id),
						border = 1,
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillName" .. i
					
					--创建当前技能的卡槽背景框
					_frmNode.childUI["SlotBG" .. i] = hUI.image:new({
						parent = _parentNode,
						model = "UI:Tactic_SlotBG",
						x = FONT_OFFSET_X + FONT_LV0_DX + 110,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
						w = 70,
						h = 14,
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "SlotBG" .. i
					
					--创建本技能可以升级到的卡槽的数量
					local slotNum = 0
					local tab = hVar.tab_unit[towerUnitId].td_upgrade.upgradeSkill[skill_id]
					if tab then
						if tab.isUnlock then
							slotNum = tab.maxLv
						end
					end
					
					for slot = 1, slotNum, 1 do
						--创建当前技能的单个卡槽条
						_frmNode.childUI["Slot" .. i .. slot] = hUI.image:new({
							parent = _parentNode,
							model = "UI:Tactic_Slot",
							x = FONT_OFFSET_X + FONT_LV0_DX + 110 + (slot - 1) * 13 - 26,
							y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
							w = 11,
							h = 10,
						})
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "Slot" .. i .. slot
					end
				end
				
				--如果该塔不是0级，才显示下一级的技能信息
				if (towerLv <= 0) then --0级
					--
				elseif (towerLv >= towerLvMax) then --已到顶级
					for i = 1, #order, 1 do
						--显示“下一级技能”的箭头
						_frmNode.childUI["SkillJianTou" .. i] = hUI.image:new({
							parent = _parentNode,
							x = FONT_OFFSET_X + 210,
							y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
							w = 30,
							h = 20,
							model = "UI:Tactic_RPointer",
						})
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillJianTou" .. i
						
						--显示已升到顶级的文字
						_frmNode.childUI["SkillToTopLabel" .. i] = hUI.label:new({
							parent = _parentNode,
							x = FONT_OFFSET_X + 250,
							y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
							w = 300,
							align = "LC",
							font = hVar.FONTC,
							--text = "已到顶级", --language
							text = hVar.tab_string["UpToMaxLv"], --language
							border = 1,
						})
						_frmNode.childUI["SkillToTopLabel" .. i].handle.s:setColor(ccc3(255, 64, 0))
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillToTopLabel" .. i
					end
				else --有下一级的技能
					local next_towerUnitId = hVar.tab_tactics[cardId].remouldUnlock[towerLv + 1][1]
					local tUnit = hVar.tab_unit[next_towerUnitId] --下一级的表项
					if tUnit then
						local next_order = tUnit.td_upgrade.upgradeSkill.order --下一级塔的技能列表
						for i = 1, #next_order, 1 do
							local skill_id = next_order[i] --技能id
							
							--显示“下一级技能”的箭头
							_frmNode.childUI["SkillJianTou" .. i] = hUI.image:new({
								parent = _parentNode,
								x = FONT_OFFSET_X + 210,
								y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
								w = 30,
								h = 20,
								model = "UI:Tactic_RPointer",
							})
							rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillJianTou" .. i
							
							--创建下一级技能的卡槽背景框
							_frmNode.childUI["SlotBGNext" .. i] = hUI.image:new({
								parent = _parentNode,
								model = "UI:Tactic_SlotBG",
								x = FONT_OFFSET_X + FONT_LV0_DX + 290,
								y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
								w = 70,
								h = 14,
							})
							rightRemoveFrmList[#rightRemoveFrmList + 1] = "SlotBGNext" .. i
							
							--创建下一级技能可以升级到的卡槽的数量
							local next_slotNum = 0
							local next_tab = hVar.tab_unit[next_towerUnitId].td_upgrade.upgradeSkill[skill_id]
							if next_tab then
								if next_tab.isUnlock then
									next_slotNum = next_tab.maxLv
								end
							end
							
							--本次的数量（用于对比）
							local slotNum = 0
							local tab = hVar.tab_unit[towerUnitId].td_upgrade.upgradeSkill[skill_id]
							if tab then
								if tab.isUnlock then
									slotNum = tab.maxLv
								end
							end
							for slot = 1, next_slotNum, 1 do
								--创建下一级技能的单个卡槽条
								_frmNode.childUI["SlotNext" .. i .. slot] = hUI.image:new({
									parent = _parentNode,
									model = "UI:Tactic_Slot",
									x = FONT_OFFSET_X + FONT_LV0_DX + 290 + (slot - 1) * 13 - 26,
									y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
									w = 11,
									h = 10,
								})
								if (slot > slotNum) then
									_frmNode.childUI["SlotNext" .. i .. slot].handle.s:setColor(ccc3(0, 255, 0))
								end
								rightRemoveFrmList[#rightRemoveFrmList + 1] = "SlotNext" .. i .. slot
							end
						end
					end
				end
				
				--显示分割线2
				_frmNode.childUI["SeparateLine2"] = hUI.image:new({
					parent = _parentNode,
					model = "UI:Tactic_SeparateLine",
					x = FONT_OFFSET_X + 172,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 230,
					w = 364,
					h = 4,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "SeparateLine2"
				
				--升级塔需要的碎片数量
				--local towerLv = 0 --等级
				local costDebris = 0 --需要的碎片数量
				local nowDebris = 0 --当前的碎片数量
				local costScore = 0 --需要的积分
				local nowScore = LuaGetPlayerScore() --当前的积分
				local itemId = 0 --商品道具id
				local tacticInfo = LuaGetPlayerTacticById(cardId)
				if tacticInfo then
					local id, lv, num = unpack(tacticInfo)
					nowDebris = num --当前的碎片数量
				end
				
				--geyachao: x3说不管等级有没有满，都会填写下一级的数据，有问题找x3
				--if (towerLv < hVar.TACTIC_LVUP_INFO.maxTacticLv) then
					local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO[towerLv]
					costDebris = tacticLvUpInfo.costDebris or 0 --需要的碎片数量
					local shopItemId = tacticLvUpInfo.shopItemId or 0
					local tabShopItem = hVar.tab_shopitem[shopItemId]
					if tabShopItem then
						--costRmb = tabShopItem.rmb or 0
						costScore = tabShopItem.score or 0 --需要的积分
						itemId = tabShopItem.itemID or 0 --商品道具id
					end
				--else --到顶级了
					--
				--end
				
				--升级需要的塔卡图标
				_frmNode.childUI["RequireCardIcon"] = hUI.image:new({
					parent = _parentNode,
					model = hVar.tab_tactics[cardId].icon,
					x = FONT_OFFSET_X + 30,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
					w = 36,
					h = 36,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireCardIcon"
				
				--碎片图标
				_frmNode.childUI["DebrisIcon"] = hUI.image:new({
					parent = _parentNode,
					model = "UI:SoulStoneFlag",
					x = FONT_OFFSET_X + 39,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 281,
					w = 30,
					h = 40,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "DebrisIcon"
				
				--碎片进度条
				local progressV = nowDebris / costDebris * 100 --进度
				if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔到顶级了
					progressV = 0
				end
				_frmNode.childUI["rightBarSoulStoneExp"] = hUI.valbar:new({
					parent = _parentNode,
					x = FONT_OFFSET_X + 55,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 277,
					w = 150,
					h = 25,
					align = "LC",
					back = {model = "UI:SoulStoneBarBg1", x = -4, y = 0, w = 150 + 7, h = 34},
					model = "UI:SoulStoneBar1",
					--model = "misc/progress.png",
					v = progressV,
					max = 100,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "rightBarSoulStoneExp"
				
				--创建一个进度条满了的特别进度条
				if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔到顶级了
					_frmNode.childUI["rightBarSoulStoneExpMaxLv"] = hUI.image:new({
						parent = _parentNode,
						model = "misc/jdt2.png", --"UI:IMG_ValueBarBoss",
						x = FONT_OFFSET_X + 55 + (150) / 2,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 277,
						w = 150,
						h = 25,
						align = "LC",
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "rightBarSoulStoneExpMaxLv"
				end
				
				--塔类卡牌
				--升级需要的碎片的数量文字
				local showNumText = nowDebris .. "/" .. costDebris
				local towerFont = "numWhite"
				local towerColor = ccc3(255, 255, 255)
				local towerBorder = 0
				if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔到顶级了
					--showNumText = "无" --language
					--showNumText = hVar.tab_string["__TEXT_Nothing"] --language
					--towerFont = hVar.FONTC
					towerColor = ccc3(255, 64, 0)
					--towerBorder = 1
				end
				
				--local showNumText = "49999/500000"
				local scaleText = 1.0
				local showTextLength = #showNumText
				if (showTextLength > 11) then --如果长度大于11，只能缩小文字(12~...个字)
					scaleText = 0.56
				elseif (showTextLength > 9) then --如果长度大于9，只能缩小文字(10~11个字)
					scaleText = 0.64
				elseif (showTextLength > 7) then --如果长度大于7，只能缩小文字(8~9个字)
					scaleText = 0.8
				else --可以显示下
					scaleText = 1.0
				end
				_frmNode.childUI["DebrisNum"] = hUI.label:new({
					parent = _parentNode,
					size = 24,
					x = FONT_OFFSET_X + 128,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 278,
					w = 300,
					align = "MC",
					font = towerFont,
					text = showNumText,
					border = towerBorder,
					scale = scaleText,
				})
				_frmNode.childUI["DebrisNum"].handle.s:setColor(towerColor)
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "DebrisNum"
				
				--升级需要的积分图标
				_frmNode.childUI["RequireScoreIcon"] = hUI.image:new({
					parent = _parentNode,
					model = "UI:score",
					x = FONT_OFFSET_X + 260,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
					w = 32,
					h = 32,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireScoreIcon"
				
				--塔类卡牌
				--升级需要的积分的数量文字
				local showJFText = tostring(costScore)
				local JFFont = "numWhite"
				local JFColor = ccc3(255, 255, 255)
				local JFBorder = 0
				if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔到顶级了
					showJFText = "无" --language
					showJFText = hVar.tab_string["__TEXT_Nothing"] --language
					JFFont = hVar.FONTC
					--showJFText = "N/A"
					JFColor = ccc3(255, 64, 0)
					JFBorder = 1
				end
				--local showJFText = "499999"
				local scaleJFText = 1.0
				local showJFTextLength = #showJFText
				if (showJFTextLength > 7) then --如果长度大于7，只能缩小文字(8个字)
					scaleJFText = 0.7
				elseif (showJFTextLength > 5) then --如果长度大于5，只能缩小文字(6~7个字)
					scaleJFText = 0.8
				elseif (showJFTextLength > 4) then --如果长度大于4，只能缩小文字(5个字)
					scaleJFText = 0.9
				else --可以显示下
					scaleJFText = 1.0
				end
				_frmNode.childUI["ScoreNum"] = hUI.label:new({
					parent = _parentNode,
					size = 24,
					x = FONT_OFFSET_X + 280,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 279,
					w = 300,
					align = "LC",
					font = JFFont,
					text = showJFText,
					border = JFBorder,
					scale = scaleJFText
				})
				_frmNode.childUI["ScoreNum"].handle.s:setColor(JFColor)
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "ScoreNum"
				
				--事件响应控件
				--碎片用于点击的区域
				_frmNode.childUI["RequireCardTouchBtn"] = hUI.button:new({
					parent = _parentNode,
					model = "misc/mask.png",
					dragbox = _frm.childUI["dragBox"],
					x = FONT_OFFSET_X + 110,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
					w = 220,
					h = 68,
					scaleT = 1.0,
					--[[
					failcall = 1,
					
					--按下碎片图标区域事件，显示碎片说明
					codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
						local __parent = _frmNode.childUI["RequireCardTouchBtn"]
						local __parentHandle = __parent.handle._n
						local offset = 75
						local yOffset = 100
						
						--选中框
						__parent.childUI["box"] = hUI.image:new({
							parent = __parentHandle,
							model = "UI:Tactic_Selected",
							x = -80,
							y = 0,
							w = 36,
							h = 36,
							align = "MC",
						})
						
						--技能背景框
						__parent.childUI["imgBg"] = hUI.image:new({
							parent = __parentHandle,
							model = "UI:TacticBG", --"UI:ExpBG",
							x = offset,
							y = yOffset,
							w = 380,
							h = 110,
							align = "MC",
						})
						__parent.childUI["imgBg"].handle.s:setOpacity(204) --技能背景框透明度为204
						
						--图标
						__parent.childUI["imgIcon"] = hUI.image:new({
							parent = __parentHandle,
							model = hVar.tab_tactics[cardId].icon,
							x = offset - 148,
							y = yOffset - 2,
							w = 64,
							h = 64,
							align = "MC",
						})
						
						--碎片图标
						__parent.childUI["imgSoleStone"] = hUI.image:new({
							parent = __parentHandle,
							model = "UI:SoulStoneFlag",
							x = offset - 148 + 20,
							y = yOffset - 17,
							w = 40,
							h = 54,
							align = "MC",
						})
						
						--碎片名称
						local name = hVar.tab_stringT[cardId] and hVar.tab_stringT[cardId][1] or ("未知塔" .. cardId)
						__parent.childUI["labName"] = hUI.label:new({
							parent = __parentHandle,
							size = 30,
							align = "LT",
							border = 1,
							x = offset - 110,
							y = yOffset + 43,
							--font = hVar.FONTC,
							font = hVar.FONTC,
							width = 290,
							--text = name .. "碎片", --language
							text = name .. hVar.tab_string["__TEXT_ITEM_TYPE_TACTICDEBRIS"], --language
						})
						__parent.childUI["labName"].handle.s:setColor(ccc3(196, 255, 196))
						
						--碎片介绍
						--local intro = "升级" .. name .. "需要消耗一定数量的该碎片。"
						local intro = hVar.tab_string["__UPGRADE"] .. name .. hVar.tab_string["RequireCostSomeDebris"] --language
						__parent.childUI["labIntro"] = hUI.label:new({
							parent = __parentHandle,
							size = 26,
							align = "LT",
							border = 1,
							x = offset - 110,
							y = yOffset + 8,
							--font = hVar.FONTC,
							font = hVar.FONTC,
							width = 290,
							text = intro,
						})
						__parent.childUI["labIntro"].handle.s:setColor(ccc3(255, 255, 255))
					end,
					
					--抬起碎片图标区域事件，删除该战术技能卡的说明
					code = function(self)
						local __parent = _frmNode.childUI["RequireCardTouchBtn"]
						hApi.safeRemoveT(__parent.childUI, "box") --选中框
						hApi.safeRemoveT(__parent.childUI, "imgBg") --技能背景框
						hApi.safeRemoveT(__parent.childUI, "imgIcon") --图标
						hApi.safeRemoveT(__parent.childUI, "imgSoleStone") --碎片图标
						hApi.safeRemoveT(__parent.childUI, "labName") --碎片名称
						hApi.safeRemoveT(__parent.childUI, "labIntro") --碎片介绍
					end,
					]]
					--抬起碎片图标区域事件，删除该战术技能卡的说明
					code = function(self)
						--显示战术技能卡的tip
						local rewardType = 6 --碎片类型
						local tacticLv = 1
						hApi.ShowTacticCardTip(rewardType, cardId, tacticLv, cardId)
					end,
				})
				_frmNode.childUI["RequireCardTouchBtn"].handle.s:setOpacity(0) --用于响应点击事件，不显示
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireCardTouchBtn"
				
				--事件响应控件
				--积分用于点击的区域
				_frmNode.childUI["RequireJiFenTouchBtn"] = hUI.button:new({
					parent = _parentNode,
					model = "misc/mask.png",
					dragbox = _frm.childUI["dragBox"],
					x = FONT_OFFSET_X + 310,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
					w = 160,
					h = 68,
					scaleT = 1.0,
					--[[
					failcall = 1,
					
					--按下积分图标区域事件，显示碎片说明
					codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
						local __parent = _frmNode.childUI["RequireJiFenTouchBtn"]
						local __parentHandle = __parent.handle._n
						local offset = -125
						local yOffset = 100
						
						--选中框
						__parent.childUI["box"] = hUI.image:new({
							parent = __parentHandle,
							model = "UI:Tactic_Selected",
							x = -50,
							y = 0,
							w = 36,
							h = 36,
							align = "MC",
						})
						
						--技能背景框
						__parent.childUI["imgBg"] = hUI.image:new({
							parent = __parentHandle,
							model = "UI:TacticBG", --"UI:ExpBG",
							x = offset,
							y = yOffset,
							w = 380,
							h = 110,
							align = "MC",
						})
						__parent.childUI["imgBg"].handle.s:setOpacity(204) --技能背景框透明度为204
						
						--图标
						__parent.childUI["imgIcon"] = hUI.image:new({
							parent = __parentHandle,
							model = "UI:score",
							x = offset - 148,
							y = yOffset - 2,
							w = 64,
							h = 64,
							align = "MC",
						})
						
						--积分名称
						__parent.childUI["labName"] = hUI.label:new({
							parent = __parentHandle,
							size = 30,
							align = "LT",
							border = 1,
							x = offset - 110,
							y = yOffset + 43,
							--font = hVar.FONTC,
							font = hVar.FONTC,
							width = 290,
							--text = "积分", --language
							text = hVar.tab_string["ios_score"], --language
						})
						__parent.childUI["labName"].handle.s:setColor(ccc3(255, 255, 196))
						
						--积分介绍
						local name = hVar.tab_stringT[cardId] and hVar.tab_stringT[cardId][1] or ("未知塔" .. cardId)
						--local intro = "升级" .. name .. "需要消耗一定数量的积分。" --language
						local intro = hVar.tab_string["__UPGRADE"] .. name .. hVar.tab_string["RequireCostSomeJiFen"] --language
						__parent.childUI["labIntro"] = hUI.label:new({
							parent = __parentHandle,
							size = 26,
							align = "LT",
							border = 1,
							x = offset - 110,
							y = yOffset + 8,
							--font = hVar.FONTC,
							font = hVar.FONTC,
							width = 290,
							text = intro,
						})
						__parent.childUI["labIntro"].handle.s:setColor(ccc3(255, 255, 255))
					end,
					
					--抬起积分图标区域事件，删除该战术技能卡的说明
					code = function(self)
						local __parent = _frmNode.childUI["RequireJiFenTouchBtn"]
						hApi.safeRemoveT(__parent.childUI, "box") --选中框
						hApi.safeRemoveT(__parent.childUI, "imgBg") --技能背景框
						hApi.safeRemoveT(__parent.childUI, "imgIcon") --图标
						hApi.safeRemoveT(__parent.childUI, "labName") --积分名称
						hApi.safeRemoveT(__parent.childUI, "labIntro") --积分介绍
					end,
					]]
					--抬起积分图标区域事件，删除该战术技能卡的说明
					code = function(self)
						--显示积分介绍的tip
						hApi.ShowJiFennTip()
					end,
				})
				_frmNode.childUI["RequireJiFenTouchBtn"].handle.s:setOpacity(0) --用于响应事件，不显示
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireJiFenTouchBtn"
				
				--塔类卡牌的升级按钮
				--升级或者解锁塔的按钮
				local updateText = hVar.tab_string["__UPGRADE"] --"升级"
				if (towerLv == 0) then
					updateText = hVar.tab_string["__UNLOCK"] --"解锁"
				end
				_frmNode.childUI["btnCostJiFen"] = hUI.button:new({
					parent = _parentNode,
					dragbox = _frm.childUI["dragBox"],
					x = FONT_OFFSET_X + 190,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 360,
					w = 180,
					h = 70,
					--label = updateText,
					--font = hVar.FONTC,
					--border = 1,
					--model = "UI:BTN_ButtonRed",
					model = "panel/panel_menu_btn_big.png", --"UI:BTN_ButtonRed"
					--animation = "normal",
					scaleT = 0.95,
					--scale = 1.0,
					code = function()
						--点击用积分升级塔按钮
						if (towerLv < hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔未到顶级
							OnClickLvUpButton(cardId, towerLv, costDebris, nowDebris, costScore, nowScore, itemId)
						end
					end,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnCostJiFen"
				if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔已到顶级
					_frmNode.childUI["btnCostJiFen"].handle._n:setVisible(false)
				end
				--积分升级按钮的升级小箭头
				_frmNode.childUI["btnCostJiFen"].childUI["UI_Arrow"] = hUI.image:new({
					parent = _frmNode.childUI["btnCostJiFen"].handle._n,
					model = "UI:jiantou_new",
					x = 0,
					y = 23,
					w = 74,
					h = 74,
				})
				--_frmNode.childUI["btnCostJiFen"].childUI["UI_Arrow"].handle._n:setRotation(-90)
				--名字
				_frmNode.childUI["btnCostJiFen"].childUI["name"] = hUI.label:new({
					parent = _frmNode.childUI["btnCostJiFen"].handle._n,
					font = hVar.FONTC,
					border = 1,
					align = "MC",
					text = updateText,
					x = 0,
					y = -10,
					size = 32,
				})
				
				
				--如果不符合升级的条件，按钮灰掉
				if (nowDebris < costDebris) or (nowScore < costScore) or (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then
					hApi.AddShader(_frmNode.childUI["btnCostJiFen"].handle.s, "gray")
					hApi.AddShader(_frmNode.childUI["btnCostJiFen"].childUI["UI_Arrow"].handle.s, "gray")
				end
				
				--...
			end
		else --未解锁的战术技能卡
			--显示未解锁塔的辅助信息
			_frmNode.childUI["UnlockHint"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 60,
				y = -278,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 330,
				text = "该分支塔暂未开放。",
				border = 1,
			})
			_frmNode.childUI["UnlockHint"].handle.s:setColor(ccc3(255, 0, 0))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "UnlockHint"
		end
		
		--标记当前选中的项的索引和卡牌id
		--print("标记当前选中的项的索引和卡牌id subPageIndex", subPageIndex)
		CurrentSelectRecord.subPageIdx = subPageIndex
		CurrentSelectRecord.contentIdx = contentIndex
		CurrentSelectRecord.cardId = cardId
	end
	
	--函数：查看塔的技能说明tip
	OnCreateSkillTipFrame = function(towerUnitId, skill_id, skillIdx)
		--先清除上一次塔的技能说明面板
		if hGlobal.UI.TacticSkillInfoFram then
			hGlobal.UI.TacticSkillInfoFram:del()
		end
		
		--显示塔的技能的选中框
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		_frmNode.childUI["SkillIcon" .. skillIdx].childUI["selectbox"].handle.s:setVisible(true) --显示
		
		--创建技能说明面板
		hGlobal.UI.TacticSkillInfoFram = hUI.frame:new({
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
			background = -1, --无底图
			border = 0, --无边框
			
			--点击事件（有可能在控件外部点击）
			codeOnDragEx = function(screenX, screenY, touchMode)
				--print("codeOnDragEx", screenX, screenY, touchMode)
				if (touchMode == 0) then --按下
					--清除技能说明面板
					--hGlobal.UI.TacticSkillInfoFram:del()
					--hGlobal.UI.TacticSkillInfoFram = nil
					--print("点击事件（有可能在控件外部点击）")
					--隐藏技能选中框
					_frmNode.childUI["SkillIcon" .. skillIdx].childUI["selectbox"].handle.s:setVisible(false) --隐藏
				elseif (touchMode == 1) then --滑动
					--
				elseif (touchMode == 2) then --抬起
				end
			end,
		})
		hGlobal.UI.TacticSkillInfoFram:active()
		
		--响应其它技能点击事件
		--[[
		for i = 1, 3, 1 do
			if _frmNode.childUI["SkillButton" .. i] then
				_frmNode.childUI["SkillButton" .. i]:active()
			end
		end
		]]
		
		--本技能可以升级到的技能次数
		local slotNum = 0
		local cost = nil --消耗的金币
		local tab = hVar.tab_unit[towerUnitId].td_upgrade.upgradeSkill[skill_id]
		if tab then
			if tab.isUnlock then
				slotNum = tab.maxLv
			end
			cost = tab.cost
		end
		
		local _SkillParent = hGlobal.UI.TacticSkillInfoFram.handle._n
		local _SkillChildUI = hGlobal.UI.TacticSkillInfoFram.childUI
		local _offX = hVar.SCREEN.w / 2 - 300 * _ScaleW
		local _offY = hVar.SCREEN.h - 110 * _ScaleW
		
		--创建技能tip图片背景
		--[[
		_SkillChildUI["ItemBG_1"] = hUI.image:new({
			parent = _SkillParent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "UI:TacticBG",
			x = _offX,
			y = _offY - 235,
			w = 460,
			h = 580,
		})
		_SkillChildUI["ItemBG_1"].handle.s:setOpacity(232) --技能背景图片透明度为232
		]]
		local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", _offX, _offY - 235, 460, 580, hGlobal.UI.TacticSkillInfoFram)
		img9:setOpacity(232)
		
		--创建技能tip-技能图标
		--print(hVar.tab_skill[skill_id].icon)
		_SkillChildUI["SkillIcon"] = hUI.image:new({
			parent = _SkillParent,
			model = hVar.tab_skill[skill_id].icon,
			x = _offX - 180,
			y = _offY + 15,
			w = 56,
			h = 56,
		})
		
		--创建技能tip-技能名称
		_SkillChildUI["SkillName"] = hUI.label:new({
			parent = _SkillParent,
			size = 32,
			x = _offX - 145,
			y = _offY + 15 - 3,
			width = 300,
			align = "LC",
			font = hVar.FONTC,
			text = hVar.tab_stringS[skill_id] and hVar.tab_stringS[skill_id][1] or ("未知技能" .. skill_id),
			border = 1,
		})
		
		--绘制现在已有的效果前缀
		_SkillChildUI["SkillLv0"] = hUI.label:new({
			parent = _SkillParent,
			size = 24,
			x = _offX - 150,
			y = _offY - 25,
			width = 120,
			align = "MT",
			font = hVar.FONTC,
			--text = "技能升级后效果", --language
			text = hVar.tab_string["SkillUpgrateEffect"], --language
			border = 1,
		})
		_SkillChildUI["SkillLv0"].handle.s:setColor(ccc3(0, 255, 0))
		
		--创建技能tip初始等级的效果
		_SkillChildUI["SkillIntro0"] = hUI.label:new({
			parent = _SkillParent,
			size = 24,
			x = _offX - 60,
			y = _offY - 25,
			width = 280,
			align = "LT",
			font = hVar.FONTC,
			text = hVar.tab_stringS[skill_id][2],
			border = 1,
		})
		_SkillChildUI["SkillIntro0"].handle.s:setColor(ccc3(0, 255, 0))
		
		
		--创建技能tip最高可升级的次数
		--local showCountsText = "游戏局中最高可升级" .. slotNum .. "次" --language
		local showCountsText = hVar.tab_string["InBattle"] .. hVar.tab_string["CanLvUpMax"] .. slotNum .. hVar.tab_string["__TEXT_YouCanForgedCount1"] --language
		if (slotNum == 0) then
			--showCountsText = "游戏局中未解锁升级该技能" --language
			showCountsText = hVar.tab_string["InBattle"] .. hVar.tab_string["CanNotLvUp"]  .. hVar.tab_string["ThisSkill"] --language
		end
		_SkillChildUI["SkillCounts"] = hUI.label:new({
			parent = _SkillParent,
			size = 24,
			x = _offX - 210,
			y = _offY - 200,
			width = 500,
			align = "LC",
			font = hVar.FONTC,
			text = showCountsText,
			border = 1,
		})
		if (slotNum > 0) then
			_SkillChildUI["SkillCounts"].handle.s:setColor(ccc3(0, 255, 255))
		else
			_SkillChildUI["SkillCounts"].handle.s:setColor(ccc3(255, 0, 0))
		end
		
		--依次绘制每一级的效果
		local skill_maxlv = 0 --最大等级
		if hVar.tab_stringS[skill_id] then
			skill_maxlv = #hVar.tab_stringS[skill_id] - 2 --第一个是技能名，第二个是技能总体描述
		end
		for i = 1, skill_maxlv, 1 do
			--创建技能tip每个等级
			_SkillChildUI["SkillLv" .. i] = hUI.label:new({
				parent = _SkillParent,
				size = 24,
				x = _offX - 180,
				y = _offY - 225 - (i - 1) * 60,
				width = 80,
				align = "MT",
				font = hVar.FONTC,
				--text = "第" .. i .. "次升级", --language
				text = hVar.tab_string["__TEXT_WORD_DI"] .. i .. hVar.tab_string["__TEXT_YouCanForgedCount1"] .. hVar.tab_string["__UPGRADE"], --language
				border = 1,
			})
			if (i > slotNum) then --未解锁的技能等级
				_SkillChildUI["SkillLv" .. i].handle.s:setColor(ccc3(64, 64, 64))
			else
				_SkillChildUI["SkillLv" .. i].handle.s:setColor(ccc3(255, 255, 0))
			end
			
			--创建技能tip每个金币图标
			_SkillChildUI["SkillGoldIcon" .. i] = hUI.image:new({
				parent = _SkillParent,
				size = 24,
				x = _offX - 107 + 1,
				y = _offY - 241 - (i - 1) * 60,
				scale = 0.45,
				model = "ui/res_money.png",
			})
			if (i > slotNum) then --未解锁的技能等级
				_SkillChildUI["SkillGoldIcon" .. i].handle.s:setColor(ccc3(64, 64, 64))
				--hApi.AddShader(_SkillChildUI["SkillGoldIcon" .. i].handle.s,"gray")
				--_SkillChildUI["SkillGoldIcon" .. i].handle.s:setOpacity(0)
			else
				--_SkillChildUI["SkillGoldIcon" .. i].handle.s:setColor(ccc3(255, 255, 0))
			end
			
			--创建技能tip每个等级的升级需要金钱
			local strShowGoldValue = cost[i]
			if (i > slotNum) then --未解锁的技能等级的详细效果
				strShowGoldValue = "--"
			end
			_SkillChildUI["SkillGoldValue" .. i] = hUI.label:new({
				parent = _SkillParent,
				size = 14,
				x = _offX - 107,
				y = _offY - 253 - (i - 1) * 60,
				width = 500,
				align = "MT",
				font = "numWhite",
				text = strShowGoldValue,
				border = 0,
			})
			if (i > slotNum) then --未解锁的技能等级的详细效果
				_SkillChildUI["SkillGoldValue" .. i].handle.s:setColor(ccc3(64, 64, 0))
			else
				_SkillChildUI["SkillGoldValue" .. i].handle.s:setColor(ccc3(255, 255, 0))
			end
			
			--创建技能tip每个等级的详细效果
			_SkillChildUI["SkillIntro" .. i] = hUI.label:new({
				parent = _SkillParent,
				size = 24,
				x = _offX - 60,
				y = _offY - 225 - (i - 1) * 60,
				width = 280,
				align = "LT",
				font = hVar.FONTC,
				text = hVar.tab_stringS[skill_id][i + 2],
				border = 1,
			})
			if (i > slotNum) then --未解锁的技能等级的详细效果
				_SkillChildUI["SkillIntro" .. i].handle.s:setColor(ccc3(64, 64, 64))
			else
				_SkillChildUI["SkillIntro" .. i].handle.s:setColor(ccc3(255, 255, 0))
			end
		end
	end
	
	--函数：点击战术技能卡升级按钮
	OnClickLvUpButton = function(tacticId, tacticLv, costDebris, nowDebris, costScore, nowScore, itemId)
		local errorMsg = "" --失败的原因
		local bEnableUpdate = true --是否可以升级
		
		if (g_cur_net_state == -1) then --未联网模式
			errorMsg = hVar.tab_string["__TEXT_Cant'UseDepletion4_Net"]
			bEnableUpdate = false
		elseif (tacticLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --战术技能卡升到顶级
			errorMsg = hVar.tab_string["__UPGRADEBFSKILL_CANT"]
			bEnableUpdate = false
		elseif (nowDebris < costDebris) then --碎片不足
			errorMsg = hVar.tab_string["tactic_lessDebris"]
			bEnableUpdate = false
		elseif (nowScore < costScore) then --积分不足
			errorMsg = hVar.tab_string["__TEXT_ScoreNotEnough"]
			bEnableUpdate = false
		end
		
		if (not bEnableUpdate) then --不能升级
			hGlobal.UI.MsgBox(errorMsg, {
				font = hVar.FONTC,
				ok = function()
					--self:setstate(1)
				end,
			})
		else --可以升级
			hUI.NetDisable(30000)
			--发送扣费请求
			local strTag = "ci:" .. tacticId .. ";cd:" .. costDebris ..";sc:".. costScore .. ";"
			SendCmdFunc["order_begin"](6, itemId, 0, 1, hVar.tab_stringI[itemId][1], costScore, 0, strTag)
		end
	end
	
	--函数：创建单个特种塔控件
	OnCreateSingleSpecialCard = function(pageIndex, index, tacticId, tacticHashList)
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local OFFSET_X = 330 * _ScaleW --统一偏移x
		local OFFSET_Y = -160 * _ScaleH --统一偏移y
		if (g_phone_mode ~= 0) then --手机模式
			OFFSET_X = 330 * _ScaleW --统一偏移x
			OFFSET_Y = -120 * _ScaleH --统一偏移y
			
			--iphone4
			if (hVar.SCREEN.w <= 960) then
				OFFSET_X = 300 * _ScaleW --统一偏移x
				OFFSET_Y = -120 * _ScaleH --统一偏移y
			end
		end
		
		--先计算xi和yi
		local xi = index --xi
		local yi = 1 --yi
		local tacticLv = 0 --特种塔卡等级
		local tacticDebrisNum = 0 --特种塔卡碎片的数量
		
		if tacticHashList[tacticId] then
			tacticLv = tacticHashList[tacticId].skillLV
			tacticDebrisNum = tacticHashList[tacticId].num
			
			--显示不超过最大等级
			local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
			if (tacticLv > maxLv) then
				tacticLv = maxLv
			end
		end
		
		--特种塔控件
		local qLv = math.min((hVar.tab_tactics[tacticId].quality or 1), 4) --图片最多只有4张
		_frmNode.childUI["SpecialCard" .. index] = hUI.button:new({ --只响应事件，不显示
			parent = _parentNode,
			--mode = "imageButton",
			dragbox = _frm.childUI["dragBox"],
			model = "misc/mask.png", --"UI:tactic_card_" .. qLv,
			x = OFFSET_X - 107 + (xi - 1) *  SPECIAL_CARD_DISTANCE_X,
			y = OFFSET_Y - 284 - (yi - 1) * SPECIAL_CARD_DISTANCE_Y,
			w = SPECIAL_CARD_WIDTH,
			h = SPECIAL_CARD_HEIGHT,
			scale = 1.0,
			align = "MC",
			--scaleT = 1.0,
			--failcall = 1,
			--点击事件
			code = function(self, screenX, screenY, isInside)
				--点击特种塔
				OnClickSpecialTowerBtn(4, index)
			end,
		})
		_frmNode.childUI["SpecialCard" .. index].handle.s:setOpacity(0) --只响应事件，不显示
		_frmNode.childUI["SpecialCard" .. index].data.tacticId = tacticId --存储战术技能卡id
		_frmNode.childUI["SpecialCard" .. index].data.tacticLv = tacticLv --存储战术技能卡等级
		_frmNode.childUI["SpecialCard" .. index].data.tacticDebrisNum = tacticDebrisNum --存储战术技能卡碎片数量
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SpecialCard" .. index
		
		local button = _frmNode.childUI["SpecialCard" .. index]
		local BTN_EDGE = 64 --按钮的边长
		--[[
		--战术技能卡类型图标
		button.childUI["typeicon"] = hUI.image:new({
			parent = button.handle._n,
			model = hApi.GetTacticsCardTypeIcon(tacticId, "model"),
			x = -2,
			y = 37,
			w = 26,
			h = 26,
		})
		--button.childUI["typeicon"].handle.s:setColor(ccc3(164, 164, 164)) --变灰
		]]
		
		--特种塔图标
		button.childUI["skillIcon"]= hUI.image:new({
			parent = button.handle._n,
			model = hVar.tab_tactics[tacticId].icon,
			x = 0,
			y = 0,
			w = BTN_EDGE,
			h = BTN_EDGE,
		})
		--button.childUI["skillIcon"].handle.s:setColor(ccc3(164, 164, 164)) --变灰
		
		--特种塔碎片经验条
		button.childUI["barSoulStoneExp"] = hUI.valbar:new({
			parent = button.handle._n,
			x = -31,
			y = -42,
			w = BTN_EDGE,
			h = 15,
			align = "LC",
			back = {model = "UI:SoulStoneBarBg1", x = -2, y = 0, w = BTN_EDGE + 4, h = 18},
			model = "UI:SoulStoneBar1",
			--model = "misc/progress.png",
			v = 100,
			max = 100,
		})
		
		--特种塔碎片所需经验显示
		button.childUI["labSoulStoneExp"] = hUI.label:new({
			parent = button.handle._n,
			size = 26,
			align = "MC",
			--font = hVar.FONTC,
			font = hVar.DEFAULT_FONT,
			x = 0,
			y = -35,
			text = "", --"NA", --geyachao: 这里不显示等级文字了
		})
		
		--碎片可以升级的箭头提示
		--特种塔升级的动态箭头
		button.childUI["tacticSoulStonejianTou"] = hUI.image:new({
			parent = button.handle._n,
			model = "ICON:image_jiantouV",
			x = 18,
			y = -5,
			w = 26, --236
			h = 26, --146
			align = "MC",
		})
		--_frm.childUI["tacticSoulStonejianTou"].handle._n:setRotation(0)
		button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(false) --默认隐藏
		
		--特种塔按钮选中框
		local Scale0 = BTN_EDGE / 70
		button.childUI["selectbox"] = hUI.image:new({
			parent = button.handle._n,
			model = "UI:Tactic_Selected",
			align = "MC",
			x = 0,
			y = 0,
			scale = Scale0,
		})
		button.childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, Scale0 - 0.015), CCScaleTo:create(0.6, Scale0 + 0.025))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		button.childUI["selectbox"].handle.s:runAction(forever)
		
		--特种塔的等级背景图
		button.childUI["LvBG"]= hUI.image:new({
			parent = button.handle._n,
			model = "ui/pvp/pvpselect.png",
			x = BTN_EDGE - 38,
			y = 28,
			w = 34,
			h = 34,
		})
		
		--特种塔的等级
		local fontSize = 26
		if tacticLv and (tacticLv >= 10) then --如果等级是2位数的，那么缩一下文字
			fontSize = 18
		end
		button.childUI["Lv"] = hUI.label:new({
			parent = button.handle._n,
			x = BTN_EDGE - 38,
			y = 27,
			text = tacticLv,
			size = fontSize,
			font = "numWhite",
			align = "MC",
			width = 200,
		})
		
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		local lvNow = tacticLv or 0
		if (lvNow >= maxLv) then
			lvNow = maxLv
		end
		local costDebris = hVar.TACTIC_LVUP_INFO[lvNow].costDebris or 0
		local costScore = 0 --需要的积分
		local shopItemId = hVar.TACTIC_LVUP_INFO[lvNow].shopItemId or 0
		local tabShopItem = hVar.tab_shopitem[shopItemId]
		if tabShopItem then
			costScore = tabShopItem.score or 0 --需要的积分
		end
		
		--未获得特种塔
		if (lvNow <= 0) then
			--hApi.AddShader(button.handle.s,"gray")
			hApi.AddShader(button.childUI["skillIcon"].handle.s,"gray")
			--hApi.AddShader(button.childUI["typeicon"].handle.s,"gray")
			button.childUI["barSoulStoneExp"]:setV(tacticDebrisNum, costDebris)
			--button.childUI["labSoulStoneExp"]:setText(tostring(tacticDebrisNum).. "/".. tostring(costDebris))
			
			--可升级的提示
			if (tacticDebrisNum >= costDebris) and (LuaGetPlayerScore() >= costScore) then
				button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(true) --显示可升级的箭头提示
			else
				button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(false) --隐藏可升级的箭头提示
			end
		else
			if (lvNow >= maxLv) then --战术技能卡已到顶级
				button.childUI["barSoulStoneExp"]:setV(0, 100)
				--button.childUI["labSoulStoneExp"]:setText(hVar.tab_string[("__BLANK__")])
				
				--不能升级的提示
				button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(false) --隐藏可升级的箭头提示
				
				--创建一个进度条满了的特别进度条
				button.childUI["tacticMaxLvProgressImg"] = hUI.image:new({
					parent = button.handle._n,
					model = "misc/jdt2.png", --"UI:IMG_ValueBarBoss",
					x = -31 + BTN_EDGE / 2,
					y = -42,
					w = BTN_EDGE, --236
					h = 15, --146
					align = "MC",
				})
			else --还可以升级
				button.childUI["barSoulStoneExp"]:setV(tacticDebrisNum, costDebris)
				--button.childUI["labSoulStoneExp"]:setText(tostring(tacticDebrisNum).. "/".. tostring(costDebris))
				
				--可升级的提示
				if (tacticDebrisNum >= costDebris) and (LuaGetPlayerScore() >= costScore) then
					button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(true) --显示可升级的箭头提示
				else
					button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(false) --隐藏可升级的箭头提示
				end
			end
		end
	end
	
	----------------------------------------------------
	--函数：创建特种塔的升级图界面（第3分页）（第4个子分页）
	OnCreateSpecialDiagramFrame = function(pageIndex, subPageIndex)
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local OFFSET_X = 330 * _ScaleW --统一偏移x
		local OFFSET_Y = -160 * _ScaleH --统一偏移y
		if (g_phone_mode ~= 0) then --手机模式
			OFFSET_X = 330 * _ScaleW --统一偏移x
			OFFSET_Y = -120 * _ScaleH --统一偏移y
			
			--iphone4
			if (hVar.SCREEN.w <= 960) then
				OFFSET_X = 300 * _ScaleW --统一偏移x
				OFFSET_Y = -120 * _ScaleH --统一偏移y
			end
		end
		
		--依次绘制每个塔的按钮
		local tSubPageIcons = {"ui/page_jianta.png", "ui/page_fashuta.png", "ui/page_paota.png", "ui/page_teshuta.png",}
		--local tTexts = {"箭塔", "法术塔", "炮塔", "特种塔",} --language
		local tSubTexts = {hVar.tab_string["JianTaPage"], hVar.tab_string["FashuTaPage"], hVar.tab_string["PaoTaPage"], hVar.tab_string["TeShuTaPage"],} --language
		for i = 1, #tSubPageIcons, 1 do
			--子分页按钮
			_frmNode.childUI["SubPageBtn" .. i] = hUI.button:new({
				parent = _parentNode,
				model = "misc/mask.png",
				x = hVar.SCREEN.w - 60,
				y = OFFSET_Y - (i - 1) * 110 - 48 * _ScaleH,
				w = 108,
				h = 108,
				dragbox = _frm.childUI["dragBox"],
				scaleT = 0.95,
				code = function(self, screenX, screenY, isInside)
					if (CurrentSelectRecord.subPageIdx ~= i) then --不重复绘制
						--先清空上次分页的全部信息
						_removeLeftFrmFunc()
						_removeRightFrmFunc()
						
						--新建该分页下的全部信息
						if (i == 1) then --分页1：箭塔
							--创建分支类塔的升级图界面（第3分页）（1、2、3个子分页）
							OnCreateTowerArchyDiagramFrame(pageIndex, i, baseTowercardId_jianta, mediumTowetcardId_jianta, archyTacticCardList_jianta)
							
							--默认点击第一个可升级的塔（没有返回左下角的塔）
							--CurrentSelectRecord.contentIdx = 0
							local firstLvUpTowerIdx = GetFirstLvUpTowerCardIdx(i)
							OnClickTowerBtn(i, firstLvUpTowerIdx)
						elseif (i == 2) then --分页2：法术塔
							--创建分支类塔的升级图界面（第3分页）（1、2、3个子分页）
							OnCreateTowerArchyDiagramFrame(pageIndex, i, baseTowercardId_fashu, mediumTowetcardId_fashu, archyTacticCardList_fashu)
							
							--默认点击第一个可升级的塔（没有返回左下角的塔）
							--CurrentSelectRecord.contentIdx = 0
							local firstLvUpTowerIdx = GetFirstLvUpTowerCardIdx(i)
							OnClickTowerBtn(i, firstLvUpTowerIdx)
						elseif (i == 3) then --分页3：炮塔
							--炮塔配置信息
							--创建分支类塔的升级图界面（第3分页）（1、2、3个子分页）
							OnCreateTowerArchyDiagramFrame(pageIndex, i, baseTowercardId_paota, mediumTowetcardId_paota, archyTacticCardList_paota)
							
							--默认点击第一个可升级的塔（没有返回左下角的塔）
							--CurrentSelectRecord.contentIdx = 0
							local firstLvUpTowerIdx = GetFirstLvUpTowerCardIdx(i)
							OnClickTowerBtn(i, firstLvUpTowerIdx)
						elseif (i == 4) then --分页4：特殊
							--创建特种塔的升级图界面（第3分页）（第4个子分页）
							OnCreateSpecialDiagramFrame(pageIndex, i)
							
							--默认点击第一个可升级的特种塔（没有返回第一项）
							--CurrentSelectRecord.contentIdx = 0
							local firstLvUpSpecialIdx = GetFirstLvUpSpecialTowerIdx()
							OnClickSpecialTowerBtn(i, firstLvUpSpecialIdx)
						end
						
						--当前按钮高亮
						hApi.AddShader(_frmNode.childUI["SubPageBtn" .. i].childUI["PageIcon"].handle.s, "normal")
						
						--其它按钮灰掉
						for k = 1, #tSubPageIcons, 1 do
							if (k ~= i) then
								hApi.AddShader(_frmNode.childUI["SubPageBtn" .. k].childUI["PageIcon"].handle.s, "gray")
							end
						end
					end
				end,
			})
			_frmNode.childUI["SubPageBtn" .. i].handle.s:setOpacity(0) --子分页按钮的控制部分，用于处理响应，不显示
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "SubPageBtn" .. i
			
			--[[
			--子分页按钮的方块图标
			_frmNode.childUI["SubPageBtn" .. i].childUI["PageImage"] = hUI.image:new({
				parent = _frmNode.childUI["SubPageBtn" .. i].handle._n,
				model = "UI:Tactic_Button",
				x = 0,
				y = 0,
				w = 116,
				h = 48,
			})
			_frmNode.childUI["SubPageBtn" .. i].childUI["PageImage"].handle.s:setRotation(90)
			]]
			
			--子分页按钮的图标
			_frmNode.childUI["SubPageBtn" .. i].childUI["PageIcon"] = hUI.image:new({
				parent = _frmNode.childUI["SubPageBtn" .. i].handle._n,
				model = tSubPageIcons[i],
				x = 0,
				y = 0,
				w = 64,
				h = 64,
			})
			
			--子分页按钮的提示升级的动态箭头标识
			_frmNode.childUI["SubPageBtn" .. i].childUI["NoteJianTou"] = hUI.image:new({
				parent = _frmNode.childUI["SubPageBtn" .. i].handle._n,
				model = "ICON:image_jiantouV",
				x = 18,
				y = -15,
				w = 32,
				h = 32,
			})
			_frmNode.childUI["SubPageBtn" .. i].childUI["NoteJianTou"].handle.s:setVisible(false) --默认一开始不显示提示该分页升级的动态箭头
			
			--[[
			--分页按钮的文字
			_frmNode.childUI["SubPageBtn" .. i].childUI["Text"] = hUI.label:new({
				parent = _frmNode.childUI["SubPageBtn" .. i].handle._n,
				x = 3,
				y = -12,
				size = 26,
				align = "MC",
				border = 1,
				font = hVar.FONTC,
				width = 26,
				text = tSubTexts[i],
			})
			]]
		end
		
		--默认第一个高亮
		hApi.AddShader(_frmNode.childUI["SubPageBtn" .. subPageIndex].childUI["PageIcon"].handle.s, "normal")
		_frmNode.childUI["SubPageBtn" .. subPageIndex].childUI["PageIcon"].handle.s:setScale(1.2)
		--其它按钮灰掉
		for k = 1, #tSubPageIcons, 1 do
			if (k ~= subPageIndex) then
				hApi.AddShader(_frmNode.childUI["SubPageBtn" .. k].childUI["PageIcon"].handle.s, "gray")
				_frmNode.childUI["SubPageBtn" .. k].childUI["PageIcon"].handle.s:setScale(1.0)
			end
		end
		
		--刷新哪个子分页能升级
		RefreshTowerUpgrateSubPage()
		
		--[[
		--特种塔暂未开放
		_frmNode.childUI["SpecialNotOpenLabel"] = hUI.label:new({
			parent = _parentNode,
			x = PAGE_BTN_LEFT_X + 285,
			y = PAGE_BTN_LEFT_Y - 210,
			size = 28,
			font = hVar.FONTC,
			align = "MT",
			width = 700,
			--text = "解锁更多关卡后，将有几率获特殊战术卡和塔。", --language
			text = hVar.tab_string["SpecialTacticIntro"], --language
			border = 1,
		})
		_frmNode.childUI["SpecialNotOpenLabel"].handle.s:setColor(ccc3(255, 128, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SpecialNotOpenLabel"
		]]
		
		local BTN_EDGE = 64 --按钮的边长
		local lineVHeight1 = 60 --第一条竖线高度
		local lineVHeight2 = 40 --第二条竖线高度
		local lineHWidth = 80 --横线的宽度
		
		local Scale0 = BTN_EDGE / 70
		
		--绘制塔基
		_frmNode.childUI["TaJiTowerIcon"] = hUI.button:new({
			parent = _parentNode,
			model = "MODEL_EFFECT:TD_Base2",
			x = OFFSET_X,
			y = OFFSET_Y + 10,
			w = BTN_EDGE * 1.1,
			h = BTN_EDGE * 62 / 114,
			z = 1,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.00,
			code = function(self, screenX, screenY, isInside)
				--点击塔的按钮
				OnClickTowerBtn(4, 0)
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TaJiTowerIcon"
		
		--塔基的按钮选中框
		_frmNode.childUI["TaJiTowerIcon"].childUI["selectbox"] = hUI.image:new({
			parent = _frmNode.childUI["TaJiTowerIcon"].handle._n,
			model = "UI:Tactic_Selected",
			align = "MC",
			x = 0,
			y = 3,
			scale = Scale0,
		})
		_frmNode.childUI["TaJiTowerIcon"].childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, Scale0 - 0.015, Scale0 - 0.3 - 0.015), CCScaleTo:create(0.4, Scale0 + 0.025, Scale0 - 0.3 - 0.015))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["TaJiTowerIcon"].childUI["selectbox"].handle.s:runAction(forever)
		
		--第O条竖线
		_frmNode.childUI["LineV0"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineV",
			x = OFFSET_X,
			y = OFFSET_Y + 10 - BTN_EDGE / 2,
			w = 12,
			h = lineVHeight1,
			--z = 111111,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineV0"
		
		--第一条竖线+
		_frmNode.childUI["LineV1_Plus"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineV",
			x = OFFSET_X,
			y = OFFSET_Y - 50 - BTN_EDGE / 2 - lineVHeight1 / 2,
			w = 12,
			h = lineVHeight1 + 90,
			--z = 111111,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineV1_Plus"
		
		--第二条竖线
		_frmNode.childUI["LineV2"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineV",
			x = OFFSET_X,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 / 2 - 1, --1像素偏差
			w = 12,
			h = lineVHeight2,
			--z = 111111,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineV2"
		
		--三叉线
		_frmNode.childUI["LineThree"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineT",
			x = OFFSET_X,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 8,
			w = 30,
			h = 16,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineThree"
		
		--左侧横线
		_frmNode.childUI["LineHL"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineH",
			x = OFFSET_X - 15 - lineHWidth / 2 - 3, --3像素偏差
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 8 - 3,
			w = lineHWidth + 15, --15像素偏差
			h = 10,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineHL"
		
		--左侧拐弯线
		_frmNode.childUI["LineRJT_L"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineRJT",
			x = OFFSET_X - 15 - lineHWidth - 12,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 8 - 12,
			w = 24,
			h = 28,
		})
		--_frmNode.childUI["LineRJT_L"].handle.s:setFlipX(true)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineRJT_L"
		
		--右侧横线
		_frmNode.childUI["LineHR"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineH",
			x = OFFSET_X + 15 + lineHWidth / 2 - 3,--3像素偏差
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 8 - 3,
			w = lineHWidth + 15, --15像素偏差
			h = 10,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineHR"
		
		--右侧拐弯线
		_frmNode.childUI["LineRJT_R"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineRJT",
			x = OFFSET_X + 15 + lineHWidth + 12,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 8 - 12,
			w = 24,
			h = 28,
		})
		_frmNode.childUI["LineRJT_R"].handle.s:setFlipX(true)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineRJT_R"
		
		--中间的竖线箭头
		_frmNode.childUI["LineJT_M"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_LineJT",
			x = OFFSET_X,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 24,
			w = 24,
			h = 20,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineJT_M"
		
		--找出所有已获得的特种塔
		local tacticHashList = {} --特种塔键值表
		local tTactics = LuaGetPlayerSkillBook()
		if tTactics then
			for i = 1,#tTactics, 1 do
				if (type(tTactics[i])=="table") then
					local id, lv, num = unpack(tTactics[i])
					--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
					
					--存在表项
					if hVar.tab_tactics[id] then
						local type = hVar.tab_tactics[id].type --战术技能卡类型
						if (type == hVar.TACTICS_TYPE.SPECIAL) then --此类专属于特种塔，放在此处
							--检测是否重复
							if tacticHashList[id] then
								--如果等级更大，用大等级的
								if (lv > tacticHashList[id].skillLV) then
									tacticHashList[id].skillLV = lv
									tacticHashList[id].num = num
								end
							else  --不存在
								tacticHashList[id] = {skillID = id, skillLV = lv, num = num}
							end
						end
					end
				end
			end
		end
		
		--[[
		--先绘制每一个已获得的特种塔（等级大于0）
		local indexHave = 0 --已获得的战术技能卡（等级大于0）索引值
		for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
			local tacticId = hVar.tab_tacticsSpecialEx[i] --特种塔id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv > 0) then
				indexHave = indexHave + 1
				--创建单个特种塔控件已获得的（等级大于0）
				OnCreateSingleSpecialCard(pageIndex, indexHave, tacticId, tacticHashList)
			end
		end
		
		--再绘制每一个未获得的特种塔（等级等于0或者不存在）
		local indexNotHave = indexHave --未获得的战术技能卡（等级等于0或者不存在）索引值
		for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
			local tacticId = hVar.tab_tacticsSpecialEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv == 0) then
				indexNotHave = indexNotHave + 1
				--创建单个特种塔控件未获得的（等级等于0或者不存在）
				OnCreateSingleSpecialCard(pageIndex, indexNotHave, tacticId, tacticHashList)
			end
		end
		]]
		
		--绘制每一个已获得的特种塔（等级大于0），和每一个未获得的特种塔（等级等于0或者不存在）
		local indexHaveAndnotHave = 0 --已获得的战术技能卡（等级大于0）索引值，和每一个未获得的特种塔（等级等于0或者不存在）
		for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
			local tacticId = hVar.tab_tacticsSpecialEx[i] --特种塔id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv > 0) then
				indexHaveAndnotHave = indexHaveAndnotHave + 1
				--创建单个特种塔控件已获得的（等级大于0）
				OnCreateSingleSpecialCard(pageIndex, indexHaveAndnotHave, tacticId, tacticHashList)
			end
			
			if (tacticLv == 0) then
				indexHaveAndnotHave = indexHaveAndnotHave + 1
				--创建单个特种塔控件未获得的（等级等于0或者不存在）
				OnCreateSingleSpecialCard(pageIndex, indexHaveAndnotHave, tacticId, tacticHashList)
			end
		end
		
		--[[
		--特种塔的名字、介绍部分的底板
		_frmNode.childUI["SpecialTowerIntroBG"] = hUI.button:new({
			parent = _parentNode,
			model = "UI:Tactic_IntroBG",
			x = OFFSET_X,
			y = OFFSET_Y - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 159 - BTN_EDGE / 2 - 5,
			w = 320,
			h = 140,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "SpecialTowerIntroBG"
		]]
		
		--特种塔的类型底图
		_frmNode.childUI["TowerTypeImg"] = hUI.image:new({
				parent = _parentNode,
			x = 190 / 2 + 15 * _ScaleW,
			y = -100 * _ScaleH,
			model = "UI:PVP_RedCover",
			w = 190,
			h = 50,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TowerTypeImg"
		
		--特种塔的类型文字
		_frmNode.childUI["TowerTypeLabel"] = hUI.label:new({
			parent = _parentNode,
			x = 190 / 2 + 15 * _ScaleW - 15,
			y = -100 * _ScaleH - 1, --文字有1像素的偏差
			text = "",
			size = 36,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
		})
		--_frmNode.childUI["TowerTypeLabel"].handle.s:setColor(ccc3(255, 255, 0)) --橙色
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TowerTypeLabel"
		
		--特种塔的名字文字
		_frmNode.childUI["TowerNameLabel"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 190 + 39,
			text = "",
			size = 30,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
		})
		_frmNode.childUI["TowerNameLabel"].handle.s:setColor(ccc3(255, 255, 0)) --橙色
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TowerNameLabel"
		
		--特种塔的等级文字
		_frmNode.childUI["TowerLvLabel"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X + 55,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 190 + 39,
			text = "",
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 300,
			border = 1,
		})
		_frmNode.childUI["TowerLvLabel"].handle.s:setColor(ccc3(255, 255, 0)) --橙色
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TowerLvLabel"
		
		--特种塔的简介文字
		_frmNode.childUI["TowerIntroLabel"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X - 142,
			y = OFFSET_Y - 20 - BTN_EDGE - lineVHeight1 - BTN_EDGE / 2 - lineVHeight2 - 190 + 24,
			size = 26,
			font = hVar.FONTC,
			align = "LT",
			width = 300,
			text = "",
			border = 1,
		})
		_frmNode.childUI["TowerIntroLabel"].handle.s:setColor(ccc3(255, 255, 255)) --白色
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TowerIntroLabel"
		
		--介绍点击特种塔的文字
		--右侧显示提示点击塔的图标查看文字
		_frmNode.childUI["HintClickSpecial"] = hUI.label:new({
			parent = _parentNode,
			x = 615,
			y = -278,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 250,
			--text = "点击左侧特种塔查看详情。", --language
			text = hVar.tab_string["ClickSpecialTowerSeeDetail"], --language
			border = 1,
		})
		_frmNode.childUI["HintClickSpecial"].handle.s:setColor(ccc3(196, 196, 196))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "HintClickSpecial"
		
		--只在本分页有效
		--监听积分改变事件
		hGlobal.event:listen("LocalEvent_SetCurGameScore", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听金币改变事件
		hGlobal.event:listen("LocalEvent_SetCurGameCoin", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听金币改变（手机版）事件
		hGlobal.event:listen("LocalEvent_Phone_SetCurGameCoin_Game", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听获得战术技能卡（碎片）事件
		hGlobal.event:listen("Event_PlayerGetTacticCard", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听英雄技能升级返回事件
		hGlobal.event:listen("Local_Event_HeroSkill_LvUp_Result", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
		--监听通知刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
		hGlobal.event:listen("LocalEvent_RefreshMedalStateUI", "__RefreshHeroCardFrm__", RefreshGuideUpgratePage)
	end
	
	--函数：获得第一个可以升级的特种塔的索引
	GetFirstLvUpSpecialTowerIdx = function()
		--print("GetFirstLvUpTacticCardIdx")
		--特种塔的最高等级
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		
		--当前的积分
		local currentScore = LuaGetPlayerScore()
		
		--特种塔键值表
		local tacticHashList = {}
		local tTactics = LuaGetPlayerSkillBook()
		if tTactics then
			for i = 1, #tTactics, 1 do
				if (type(tTactics[i])=="table") then
					local id, lv, num = unpack(tTactics[i])
					--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
					
					--存在表项
					if hVar.tab_tactics[id] then
						local type = hVar.tab_tactics[id].type --战术技能卡类型
						if (type == hVar.TACTICS_TYPE.SPECIAL) then --此类专属于特种塔，放在此处
							--检测是否重复
							if tacticHashList[id] then
								--如果等级更大，用大等级的
								if (lv > tacticHashList[id].skillLV) then
									tacticHashList[id].skillLV = lv
									tacticHashList[id].num = num
								end
							else  --不存在
								tacticHashList[id] = {skillID = id, skillLV = lv, num = num}
							end
						end
					end
				end
			end
		end
		
		--[[
		--先查找每一个已获得的特种塔（等级大于0）
		local indexHave = 0 --已获得的特种塔（等级大于0）索引值
		for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
			local tacticId = hVar.tab_tacticsSpecialEx[i] --特种塔id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv > 0) then
				indexHave = indexHave + 1
				
				--检测是否可以升级
				local lvNow = tacticLv or 0
				if (lvNow >= maxLv) then
					lvNow = maxLv
				end
				local costDebris = hVar.TACTIC_LVUP_INFO[lvNow].costDebris or 0
				local costScore = 0 --需要的积分
				local shopItemId = hVar.TACTIC_LVUP_INFO[lvNow].shopItemId or 0
				local tabShopItem = hVar.tab_shopitem[shopItemId]
				if tabShopItem then
					costScore = tabShopItem.score or 0 --需要的积分
				end
				
				if (lvNow >= maxLv) then --战术技能卡已到顶级
					--不能升级
					--...
				else --还可以升级
					if (tacticDebrisNum >= costDebris) and (currentScore >= costScore) then
						return indexHave
					end
				end
			end
		end
		
		--再绘制每一个未获得的特种塔（等级等于0或者不存在）
		local indexNotHave = indexHave --未获得的特种塔（等级等于0或者不存在）索引值
		for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
			local tacticId = hVar.tab_tacticsSpecialEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv == 0) then
				indexNotHave = indexNotHave + 1
				--print("indexNotHave", indexNotHave)
				--检测是否可以升级
				local lvNow = tacticLv or 0
				if (lvNow >= maxLv) then
					lvNow = maxLv
				end
				local costDebris = hVar.TACTIC_LVUP_INFO[lvNow].costDebris or 0
				local costScore = 0 --需要的积分
				local shopItemId = hVar.TACTIC_LVUP_INFO[lvNow].shopItemId or 0
				local tabShopItem = hVar.tab_shopitem[shopItemId]
				if tabShopItem then
					costScore = tabShopItem.score or 0 --需要的积分
				end
				
				--可升级的提示
				if (tacticDebrisNum >= costDebris) and (currentScore >= costScore) then
					return indexNotHave
				end
			end
		end
		]]
		
		--查找每一个已获得的特种塔（等级大于0），和每一个未获得的特种塔（等级等于0或者不存在）
		local indexHaveAndNotHave = 0 --已获得的特种塔（等级大于0）索引值
		for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
			local tacticId = hVar.tab_tacticsSpecialEx[i] --特种塔id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv > 0) then
				indexHaveAndNotHave = indexHaveAndNotHave + 1
				
				--检测是否可以升级
				local lvNow = tacticLv or 0
				if (lvNow >= maxLv) then
					lvNow = maxLv
				end
				local costDebris = hVar.TACTIC_LVUP_INFO[lvNow].costDebris or 0
				local costScore = 0 --需要的积分
				local shopItemId = hVar.TACTIC_LVUP_INFO[lvNow].shopItemId or 0
				local tabShopItem = hVar.tab_shopitem[shopItemId]
				if tabShopItem then
					costScore = tabShopItem.score or 0 --需要的积分
				end
				
				if (lvNow >= maxLv) then --战术技能卡已到顶级
					--不能升级
					--...
				else --还可以升级
					if (tacticDebrisNum >= costDebris) and (currentScore >= costScore) then
						return indexHaveAndNotHave
					end
				end
			end
			
			if (tacticLv == 0) then
				indexHaveAndNotHave = indexHaveAndNotHave + 1
				--print("indexHaveAndNotHave", indexHaveAndNotHave)
				--检测是否可以升级
				local lvNow = tacticLv or 0
				if (lvNow >= maxLv) then
					lvNow = maxLv
				end
				local costDebris = hVar.TACTIC_LVUP_INFO[lvNow].costDebris or 0
				local costScore = 0 --需要的积分
				local shopItemId = hVar.TACTIC_LVUP_INFO[lvNow].shopItemId or 0
				local tabShopItem = hVar.tab_shopitem[shopItemId]
				if tabShopItem then
					costScore = tabShopItem.score or 0 --需要的积分
				end
				
				--可升级的提示
				if (tacticDebrisNum >= costDebris) and (currentScore >= costScore) then
					return indexHaveAndNotHave
				end
			end
		end
		
		--走到这里说明没有一个是能升级的，返回第一项
		return 1
	end
	
	--函数：计算某个特种塔的索引值
	CalSpecialCardIndex = function(tacticCardId)
		--特种塔键值表
		local tacticHashList = {}
		local tTactics = LuaGetPlayerSkillBook()
		if tTactics then
			for i = 1, #tTactics, 1 do
				if (type(tTactics[i])=="table") then
					local id, lv, num = unpack(tTactics[i])
					--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
					
					--存在表项
					if hVar.tab_tactics[id] then
						local type = hVar.tab_tactics[id].type --战术技能卡类型
						if (type == hVar.TACTICS_TYPE.SPECIAL) then --此类专属于特种塔，放在此处
							--检测是否重复
							if tacticHashList[id] then
								--如果等级更大，用大等级的
								if (lv > tacticHashList[id].skillLV) then
									tacticHashList[id].skillLV = lv
									tacticHashList[id].num = num
								end
							else  --不存在
								tacticHashList[id] = {skillID = id, skillLV = lv, num = num}
							end
						end
					end
				end
			end
		end
		
		--[[
		--先检测每一个已获得的特种塔（等级大于0）
		local indexHave = 0 --已获得的特种塔（等级大于0）索引值
		for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
			local tacticId = hVar.tab_tacticsSpecialEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv > 0) then
				indexHave = indexHave + 1
				
				--检测是否是要找的
				if (tacticCardId == tacticId) then
					return indexHave
				end
			end
		end
		
		--再检测每一个未获得的特种塔（等级等于0或者不存在）
		local indexNotHave = indexHave --未获得的特种塔（等级等于0或者不存在）索引值
		for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
			local tacticId = hVar.tab_tacticsSpecialEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv == 0) then
				indexNotHave = indexNotHave + 1
				
				--检测是否是要找的
				if (tacticCardId == tacticId) then
					return indexNotHave
				end
			end
		end
		]]
		
		--检测每一个已获得的特种塔（等级大于0），和每一个未获得的特种塔（等级等于0或者不存在）
		local indexHaveAndNotHave = 0 --已获得的特种塔（等级大于0）索引值，和每一个未获得的特种塔（等级等于0或者不存在）
		for i = 1, #hVar.tab_tacticsSpecialEx, 1 do
			local tacticId = hVar.tab_tacticsSpecialEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv > 0) then
				indexHaveAndNotHave = indexHaveAndNotHave + 1
				
				--检测是否是要找的
				if (tacticCardId == tacticId) then
					return indexHaveAndNotHave
				end
			end
			
			if (tacticLv == 0) then
				indexHaveAndNotHave = indexHaveAndNotHave + 1
				
				--检测是否是要找的
				if (tacticCardId == tacticId) then
					return indexHaveAndNotHave
				end
			end
		end
		
		
		return 0
	end
	
	--函数：点击特种塔的按钮的执行逻辑
	OnClickSpecialTowerBtn = function(subPageIndex, contentIndex)
		--print("OnClickSpecialTowerBtn", subPageIndex, contentIndex, CurrentSelectRecord.subPageIdx, CurrentSelectRecord.contentIdx)
		--不重复绘制同一个项索引值
		if (CurrentSelectRecord.subPageIdx == subPageIndex) and (CurrentSelectRecord.contentIdx == contentIndex) then
			--print("不重复绘制同一个项索引值", subPageIndex, contentIndex)
			return
		end
		
		--print("OnClickSpecialTowerBtn")
		
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--获得参数
		local button = _frmNode.childUI["SpecialCard" .. contentIndex]
		local cardId = button.data.tacticId --特种塔战术技能卡id
		local towerLv = button.data.tacticLv --特种塔战术技能卡的等级
		local nowDebris = button.data.tacticDebrisNum --战术技能卡碎片数量
		
		--上一次选中的特种塔取消选中
		if (CurrentSelectRecord.contentIndex ~= 0) then
			if _frmNode.childUI["SpecialCard" .. CurrentSelectRecord.contentIdx] then
				_frmNode.childUI["SpecialCard" .. CurrentSelectRecord.contentIdx].childUI["selectbox"].handle.s:setVisible(false) --隐藏
			end
		end
		
		--隐藏塔基选中框
		if (contentIndex ~= 0) then
			if _frmNode.childUI["TaJiTowerIcon"] then
				_frmNode.childUI["TaJiTowerIcon"].childUI["selectbox"].handle.s:setVisible(false) --隐藏
			end
		end
		
		--自身的选中框高亮
		button.childUI["selectbox"].handle.s:setVisible(true) --显示
		
		--显示塔的系
		--_frmNode.childUI["TowerTypeLabel"]:setText("特种塔系") --language
		_frmNode.childUI["TowerTypeLabel"]:setText(hVar.tab_string["TeShuTaPage"]) --language
		
		--显示塔的名称和说明
		local towerName = "" --塔的名字
		local towerIntro = "" --塔的简介
		local szTowerLv = "" --塔的等级文字描述
		local towerLvColor = nil --塔的等级文字的颜色
		--显示塔类战术技能卡的名字
		towerName = hVar.tab_stringT[cardId] and hVar.tab_stringT[cardId][1] or ("未知塔" .. cardId)
		
		--显示塔类战术技能卡的简介
		local tTactics = LuaGetPlayerSkillBook()
		if tTactics then
			for i = 1,#tTactics, 1 do
				if type(tTactics[i])=="table" then
					local id, lv, num = unpack(tTactics[i])
					
					--是否一致
					if (id == cardId) then --已存在
						--如果等级更大，用大等级的
						if (lv > towerLv) then
							towerLv = lv
						end
					end
				end
			end
		end
		
		local showTowerLv = towerLv --显示文字的塔的等级
		if (showTowerLv == 0) then
			showTowerLv = 1
		end
		--显示不超过最大等级
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		if (showTowerLv > maxLv) then
			showTowerLv = maxLv
		end
		if (towerLv > 0) then --已获得的特种塔
			--szTowerLv = showTowerLv .. "级" --language
			szTowerLv = showTowerLv .. hVar.tab_string["__TEXT_ji"] --language
			towerLvColor = ccc3(255, 255, 0) --橙色
		else --未获得的特种塔
			--szTowerLv = "未获得" --language
			szTowerLv = hVar.tab_string["CurrentNotGet"] --language
			towerLvColor = ccc3(255, 0, 0) --红色
		end
		
		towerIntro = hVar.tab_stringT[cardId] and hVar.tab_stringT[cardId][showTowerLv + 1] or ("未知战术技能卡说明" .. cardId)
		
		--更新说明
		_frmNode.childUI["TowerNameLabel"]:setText(towerName)
		_frmNode.childUI["TowerLvLabel"]:setText(szTowerLv)
		_frmNode.childUI["TowerLvLabel"].handle.s:setColor(towerLvColor)
		_frmNode.childUI["TowerIntroLabel"]:setText(towerIntro)
		
		--更新详细面板
		--先清空上次右侧的控件集
		_removeRightFrmFunc(pageIndex)
		
		--显示不超过最大等级
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		if (towerLv > maxLv) then
			towerLv = maxLv
		end
		
		--塔的单位
		local towerUnitId = cardId --塔的单位的类型id
		if (towerLv == 0) then
			towerUnitId = hVar.tab_tactics[cardId].remouldUnlock and hVar.tab_tactics[cardId].remouldUnlock[1][1]
		else
			towerUnitId = hVar.tab_tactics[cardId].remouldUnlock and hVar.tab_tactics[cardId].remouldUnlock[towerLv][1]
		end
		--print("towerUnitId", towerUnitId, towerLv)
		
		--特种塔第一个文字的偏移值
		local FONT_OFFSET_X = hVar.SCREEN.w - 650 *_ScaleW --第一个文字的偏移值x
		local FONT_OFFSET_Y = -140 * _ScaleH --第一个文字的偏移值y
		if (g_phone_mode ~= 0) then --手机模式
			FONT_OFFSET_X = hVar.SCREEN.w - 650 *_ScaleW --第一个文字的偏移值x
			FONT_OFFSET_Y = -100 * _ScaleH --第一个文字的偏移值y
			
			--iphone4
			if (hVar.SCREEN.w <= 960) then
				FONT_OFFSET_X = hVar.SCREEN.w - 650 *_ScaleW --第一个文字的偏移值x
				FONT_OFFSET_Y = -100 * _ScaleH --第一个文字的偏移值y
			end
		end
		local FONT_UNIT_DX = 0 --单位类型的塔的额外偏移值x
		local FONT_LV0_DX = 0 --0级塔的额外偏移值x
		if bIsUnit then
			FONT_UNIT_DX = 90
		elseif (towerLv <= 0) then
			FONT_LV0_DX = 90
		end
		local FONT_DELTA_Y = 40 --文字间的间隔y
		
		--读取塔单位的属性
		local attr = hVar.tab_unit[towerUnitId] and hVar.tab_unit[towerUnitId].attr or {} --属性表
		local atk_min = attr.attack and attr.attack[4] or 0 --最小攻击力
		local atk_max = attr.attack and attr.attack[5] or 0 --最大攻击力
		local atk_speed = attr.atk_interval or 0 --攻击速度
		local atk_range = attr.atk_radius or 0 --射程
		
		local atkSpeed = atk_speed / 1000
		local divValue = math.floor(atkSpeed)
		local modValue = (atkSpeed - divValue) * 100
		local szAtkSpeed = ("%d.%s"):format(divValue, tostring(modValue)) --保留2位小数
		
		--显示“攻击”文字
		_frmNode.childUI["AtkPrefix"] = hUI.label:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX,
			y = FONT_OFFSET_Y,
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 300,
			--text = "攻击", --language
			text = hVar.tab_string["__Attr_Hint_atk"], --language
			border = 1,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkPrefix"
		
		--显示攻击力
		local atkFont = "numWhite"
		local atkValueTotal = atk_min .. "-" .. atk_max
		local atkSize = 24
		local atkShowBorder = 0
		local atkExtaDx = 0 --额外的偏移值x
		if (#atkValueTotal > 6) then --如果攻击力文字过长，缩小字体
			atkSize = 20
		end
		if (atk_max <= 0) then --如果该单位没有攻击力，那么显示"无"
			atkSize = 26
			--atkValueTotal = "无" --language
			atkValueTotal = hVar.tab_string["__TEXT_Nothing"] --language
			atkFont = hVar.FONTC
			atkShowBorder = 1
			atkExtaDx = 40 --额外的偏移值x
		end
		_frmNode.childUI["AtkValue"] = hUI.label:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX + 70 + atkExtaDx,
			y = FONT_OFFSET_Y - 1, --数字字体有1像素偏差
			size = atkSize,
			font = atkFont,
			align = "LC",
			width = 300,
			text = atkValueTotal,
			border = atkShowBorder,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkValue"
		
		--显示“攻速”文字
		_frmNode.childUI["AtkSpeedPrefix"] = hUI.label:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX,
			y = FONT_OFFSET_Y - FONT_DELTA_Y,
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 300,
			--text = "攻速", --language
			text = hVar.tab_string["__Attr_Speed"], --language
			border = 1,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkSpeedPrefix"
		
		--显示攻击速度值
		local atkSpeedFont = "numWhite"
		local atkSpeedSize = 24
		local atkSpeedShowBorder = 0
		local atkSpeedExtaDx = 0 --额外的偏移值x
		if (atk_max <= 0) then --如果该单位没有攻击力，那么显示"无"
			atkSpeedSize = 26
			--szAtkSpeed = "无" --language
			szAtkSpeed = hVar.tab_string["__TEXT_Nothing"] --language
			atkSpeedFont = hVar.FONTC
			atkSpeedShowBorder = 1
			atkSpeedExtaDx = 40 --额外的偏移值x
		end
		_frmNode.childUI["AtkSpeedValue"] = hUI.label:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX + 70 + atkSpeedExtaDx,
			y = FONT_OFFSET_Y - FONT_DELTA_Y - 1, --数字字体有1像素偏差
			size = atkSpeedSize,
			font = atkSpeedFont,
			align = "LC",
			width = 300,
			text = szAtkSpeed,
			border = atkSpeedShowBorder,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkSpeedValue"
		
		--显示“射程”文字
		_frmNode.childUI["AtkRangePrefix"] = hUI.label:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2,
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 300,
			--text = "射程", --language
			text = hVar.tab_string["__Attr_Atk_Range"], --language
			border = 1,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkRangePrefix"
		
		--显示射程值
		local atkRangeFont = "numWhite"
		local atkRangeSize = 24
		local atkRangeShowBorder = 0
		local atkRangeExtaDx = 0 --额外的偏移值x
		if (atk_max <= 0) then --如果该单位没有攻击力，那么显示"无"
			atkRangeSize = 26
			--atk_range = "无" --language
			atk_range = hVar.tab_string["__TEXT_Nothing"] --language
			atkRangeFont = hVar.FONTC
			atkRangeShowBorder = 1
			atkRangeExtaDx = 40 --额外的偏移值x
		end
		_frmNode.childUI["AtkRangeValue"] = hUI.label:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + FONT_UNIT_DX + FONT_LV0_DX + 70 + atkRangeExtaDx,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 1, --数字字体有1像素偏差
			size = 24,
			font = atkRangeFont,
			align = "LC",
			width = 300,
			text = atk_range,
			border = atkRangeShowBorder,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkRangeValue"
		
		--显示分割线1
		_frmNode.childUI["SeparateLine1"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_SeparateLine",
			x = FONT_OFFSET_X + 172,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 45,
			w = 364,
			h = 4,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "SeparateLine1"
		
		--是战术技能卡塔
		--显示下一级塔的属性
		local towerLvMax = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1 --塔类的最大等级
		
		--如果该塔不是0级才显示下一级的属性
		--print(towerLv)
		if (towerLv > 0) then
			local next_font = nil --下一级的文字字体
			local next_color = nil --下一级的文字颜色
			local next_szAtk = nil --攻击力
			local next_szAtkSpeed = nil --攻击速度
			local next_atk_range = nil --射程
			local next_atk_max = 1 --下一级的最大攻击力
			
			--print("towerLv=", towerLv, "towerLvMax=", towerLvMax)
			if (towerLv >= towerLvMax) then --塔已升到顶级
				next_font = hVar.FONTC --下一级的文字字体
				next_color = ccc3(255, 64, 0) --下一级的文字颜色
				--next_szAtk = "已到顶级" --攻击力 --language
				--next_szAtkSpeed = "已到顶级" --攻击速度 --language
				--next_atk_range = "已到顶级" --射程 --language
				next_szAtk = hVar.tab_string["UpToMaxLv"] --攻击力 --language
				next_szAtkSpeed = hVar.tab_string["UpToMaxLv"] --攻击速度 --language
				next_atk_range = hVar.tab_string["UpToMaxLv"] --射程 --language
			else
				--读取下一级塔单位的属性
				local next_towerUnitId = hVar.tab_tactics[cardId] and hVar.tab_tactics[cardId].remouldUnlock and hVar.tab_tactics[cardId].remouldUnlock[towerLv + 1][1] or 0
				next_font = "numWhite" --下一级的文字字体
				next_color = ccc3(0, 255, 0) --下一级的文字颜色
				next_szAtk = "?-?" --攻击力
				next_szAtkSpeed = "?" --攻击速度
				next_atk_range = "?" --射程
				
				local tUnit = hVar.tab_unit[next_towerUnitId] or {} --下一级的表项
				
				if tUnit then
					local next_attr = tUnit.attr or {} --属性表
					local next_atk_min = next_attr.attack and next_attr.attack[4] or 0 --最小攻击力
					local next_atk_max_val = next_attr.attack and next_attr.attack[5] or 0 --最大攻击力
					local next_atk_speed = next_attr.attack and next_attr.atk_interval or 0 --攻击速度
					next_atk_max = next_atk_max_val --存储
					next_szAtk = next_atk_min .. "-" .. next_atk_max_val
					next_atk_range = next_attr.atk_radius --射程
					
					local next_atkSpeed = next_atk_speed / 1000
					local next_divValue = math.floor(next_atkSpeed)
					local next_modValue = (next_atkSpeed - next_divValue) * 100
					next_szAtkSpeed = ("%d.%s"):format(next_divValue, tostring(next_modValue)) --保留2位小数
				end
			end
			
			--显示“攻击”的箭头
			_frmNode.childUI["AtkJianTou"] = hUI.image:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 210,
				y = FONT_OFFSET_Y,
				w = 30,
				h = 20,
				model = "UI:Tactic_RPointer",
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkJianTou"
			
			--显示“攻速”的箭头
			_frmNode.childUI["AtkSpeedJianTou"] = hUI.image:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 210,
				y = FONT_OFFSET_Y - FONT_DELTA_Y,
				w = 30,
				h = 20,
				model = "UI:Tactic_RPointer",
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkSpeedJianTou"
			
			--显示“射程”的箭头
			_frmNode.childUI["AtkRangeJianTou"] = hUI.image:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 210,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2,
				w = 30,
				h = 20,
				model = "UI:Tactic_RPointer",
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkRangeJianTou"
			
			--显示下一级攻击力值
			local next_atkSize = 24
			local next_atkShowBorder = 0
			if (#next_szAtk > 6) then --如果下一级攻击力文字过长，缩小字体
				next_atkSize = 20
			end
			if (towerLv >= towerLvMax) then --塔已升到顶级
				next_atkSize = 24 --这里是中文，可以显示的下
				next_atkShowBorder = 1
			end
			
			local next_atkExtaDx = 0 --额外的偏移值x
			if (next_atk_max <= 0) then --如果该单位下一级没有攻击力，那么显示"无"
				next_atkSize = 26
				--next_szAtk = "无" --language
				next_szAtk = hVar.tab_string["__TEXT_Nothing"] --language
				--next_szAtkSpeed = "无" --language
				next_szAtkSpeed = hVar.tab_string["__TEXT_Nothing"] --language
				--next_atk_range = "无" --language
				next_atk_range = hVar.tab_string["__TEXT_Nothing"] --language
				next_font = hVar.FONTC
				next_atkShowBorder = 1
				next_atkExtaDx = 30 --额外的偏移值x
			end
			_frmNode.childUI["AtkNextValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 250 + next_atkExtaDx,
				y = FONT_OFFSET_Y - 1, --数字字体有1像素偏差
				size = next_atkSize,
				font = next_font,
				align = "LC",
				width = 300,
				text = next_szAtk,
				border = next_atkShowBorder,
			})
			_frmNode.childUI["AtkNextValue"].handle.s:setColor(next_color)
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkNextValue"
			
			--显示下一级攻击速度
			_frmNode.childUI["AtkSpeedNextValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 250 + next_atkExtaDx,
				y = FONT_OFFSET_Y - FONT_DELTA_Y - 1, --数字字体有1像素偏差
				size = 24,
				font = next_font,
				align = "LC",
				width = 300,
				text = next_szAtkSpeed,
				border = next_atkShowBorder,
			})
			_frmNode.childUI["AtkSpeedNextValue"].handle.s:setColor(next_color)
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkSpeedNextValue"
			
			--显示下一级攻击射程
			_frmNode.childUI["AtkRangeNextValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 250 + next_atkExtaDx,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 1, --数字字体有1像素偏差
				size = 24,
				font = next_font,
				align = "LC",
				width = 300,
				text = next_atk_range,
				border = next_atkShowBorder,
			})
			_frmNode.childUI["AtkRangeNextValue"].handle.s:setColor(next_color)
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "AtkRangeNextValue"
		end
		
		--显示特种塔的技能
		local order = hVar.tab_unit[towerUnitId] and hVar.tab_unit[towerUnitId].td_upgrade.upgradeSkill.order or {} --塔的技能列表
		for i = 1, #order, 1 do
			--响应技能点击事件的按钮区域
			local skill_id = order[i] --技能id
			_frmNode.childUI["SkillButton" .. i] = hUI.button:new({
				parent = _parentNode,
				model = "misc/mask.png",
				x = FONT_OFFSET_X + 160,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 100 - (i - 1) * 72,
				w = 360,
				h = 68,
				dragbox = _frm.childUI["dragBox"],
				scaleT = 1.00,
				codeOnTouch = function(self, screenX, screenY, isInside)
					--print(towerUnitId, skill_id, i)
					OnCreateSkillTipFrame(towerUnitId, skill_id, i)
				end,
			})
			_frmNode.childUI["SkillButton" .. i].handle.s:setOpacity(0) --用于响应点击事件，不显示
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillButton" .. i
			
			--创建技能图标
			_frmNode.childUI["SkillIcon" .. i] = hUI.image:new({
				parent = _parentNode,
				model = hVar.tab_skill[skill_id].icon,
				x = FONT_OFFSET_X + FONT_LV0_DX + 32,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 100 - (i - 1) * 72,
				w = 64,
				h = 64,
				--z = 1,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillIcon" .. i
			
			--创建技能选中框
			local Scale0 = 64 / 70
			_frmNode.childUI["SkillIcon" .. i].childUI["selectbox"] = hUI.image:new({
				parent = _frmNode.childUI["SkillIcon" .. i].handle._n,
				model = "UI:Tactic_Selected",
				x = 32,
				y = 32,
				scale = Scale0,
			})
			_frmNode.childUI["SkillIcon" .. i].childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
			local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, Scale0 - 0.015), CCScaleTo:create(0.6, Scale0 + 0.025))
			local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
			_frmNode.childUI["SkillIcon" .. i].childUI["selectbox"].handle.s:runAction(forever)
			
			--创建技能名称
			_frmNode.childUI["SkillName" .. i] = hUI.label:new({
				parent = _parentNode,
				size = 26,
				x = FONT_OFFSET_X + FONT_LV0_DX + 75,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 85 - (i - 1) * 72,
				w = 300,
				align = "LC",
				font = hVar.FONTC,
				text = hVar.tab_stringS[skill_id] and hVar.tab_stringS[skill_id][1] or ("未知技能" .. skill_id),
				border = 1,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillName" .. i
			
			--创建当前技能的卡槽背景框
			_frmNode.childUI["SlotBG" .. i] = hUI.image:new({
				parent = _parentNode,
				model = "UI:Tactic_SlotBG",
				x = FONT_OFFSET_X + FONT_LV0_DX + 110,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
				w = 70,
				h = 14,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "SlotBG" .. i
			
			--创建本技能可以升级到的卡槽的数量
			local slotNum = 0
			local tab = hVar.tab_unit[towerUnitId].td_upgrade.upgradeSkill[skill_id]
			if tab then
				if tab.isUnlock then
					slotNum = tab.maxLv
				end
			end
			
			for slot = 1, slotNum, 1 do
				--创建当前技能的单个卡槽条
				_frmNode.childUI["Slot" .. i .. slot] = hUI.image:new({
					parent = _parentNode,
					model = "UI:Tactic_Slot",
					x = FONT_OFFSET_X + FONT_LV0_DX + 110 + (slot - 1) * 13 - 26,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
					w = 11,
					h = 10,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "Slot" .. i .. slot
			end
		end
		
		--如果该塔不是0级，才显示下一级的技能信息
		if (towerLv <= 0) then --0级
			--
		elseif (towerLv >= towerLvMax) then --已到顶级
			for i = 1, #order, 1 do
				--显示“下一级技能”的箭头
				_frmNode.childUI["SkillJianTou" .. i] = hUI.image:new({
					parent = _parentNode,
					x = FONT_OFFSET_X + 210,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
					w = 30,
					h = 20,
					model = "UI:Tactic_RPointer",
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillJianTou" .. i
				
				--显示已升到顶级的文字
				_frmNode.childUI["SkillToTopLabel" .. i] = hUI.label:new({
					parent = _parentNode,
					x = FONT_OFFSET_X + 250,
					y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
					w = 300,
					align = "LC",
					font = hVar.FONTC,
					--text = "已到顶级", --language
					text = hVar.tab_string["UpToMaxLv"], --language
					border = 1,
				})
				_frmNode.childUI["SkillToTopLabel" .. i].handle.s:setColor(ccc3(255, 64, 0))
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillToTopLabel" .. i
			end
		else --有下一级的技能
			local next_towerUnitId = hVar.tab_tactics[cardId] and hVar.tab_tactics[cardId].remouldUnlock and hVar.tab_tactics[cardId].remouldUnlock[towerLv + 1][1] or 0
			local tUnit = hVar.tab_unit[next_towerUnitId] --下一级的表项
			if tUnit then
				local next_order = tUnit.td_upgrade.upgradeSkill.order --下一级塔的技能列表
				for i = 1, #next_order, 1 do
					local skill_id = next_order[i] --技能id
					
					--显示“下一级技能”的箭头
					_frmNode.childUI["SkillJianTou" .. i] = hUI.image:new({
						parent = _parentNode,
						x = FONT_OFFSET_X + 210,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
						w = 30,
						h = 20,
						model = "UI:Tactic_RPointer",
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "SkillJianTou" .. i
					
					--创建下一级技能的卡槽背景框
					_frmNode.childUI["SlotBGNext" .. i] = hUI.image:new({
						parent = _parentNode,
						model = "UI:Tactic_SlotBG",
						x = FONT_OFFSET_X + FONT_LV0_DX + 290,
						y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
						w = 70,
						h = 14,
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "SlotBGNext" .. i
					
					--创建下一级技能可以升级到的卡槽的数量
					local next_slotNum = 0
					local next_tab = hVar.tab_unit[next_towerUnitId].td_upgrade.upgradeSkill[skill_id]
					if next_tab then
						if next_tab.isUnlock then
							next_slotNum = next_tab.maxLv
						end
					end
					
					--本次的数量（用于对比）
					local slotNum = 0
					local tab = hVar.tab_unit[towerUnitId].td_upgrade.upgradeSkill[skill_id]
					if tab then
						if tab.isUnlock then
							slotNum = tab.maxLv
						end
					end
					for slot = 1, next_slotNum, 1 do
						--创建下一级技能的单个卡槽条
						_frmNode.childUI["SlotNext" .. i .. slot] = hUI.image:new({
							parent = _parentNode,
							model = "UI:Tactic_Slot",
							x = FONT_OFFSET_X + FONT_LV0_DX + 290 + (slot - 1) * 13 - 26,
							y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 115 - (i - 1) * 72,
							w = 11,
							h = 10,
						})
						if (slot > slotNum) then
							_frmNode.childUI["SlotNext" .. i .. slot].handle.s:setColor(ccc3(0, 255, 0))
						end
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "SlotNext" .. i .. slot
					end
				end
			end
		end
		
		--显示分割线2
		_frmNode.childUI["SeparateLine2"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_SeparateLine",
			x = FONT_OFFSET_X + 172,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 230,
			w = 364,
			h = 4,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "SeparateLine2"
		
		--升级塔需要的碎片数量
		--local towerLv = 0 --等级
		local costDebris = 0 --需要的碎片数量
		local nowDebris = 0 --当前的碎片数量
		local costScore = 0 --需要的积分
		local nowScore = LuaGetPlayerScore() --当前的积分
		local itemId = 0 --商品道具id
		local tacticInfo = LuaGetPlayerTacticById(cardId)
		if tacticInfo then
			local id, lv, num = unpack(tacticInfo)
			nowDebris = num --当前的碎片数量
		end
		
		--geyachao: x3说不管等级有没有满，都会填写下一级的数据，有问题找x3
		--if (towerLv < hVar.TACTIC_LVUP_INFO.maxTacticLv) then
			local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO[towerLv]
			costDebris = tacticLvUpInfo.costDebris or 0 --需要的碎片数量
			local shopItemId = tacticLvUpInfo.shopItemId or 0
			local tabShopItem = hVar.tab_shopitem[shopItemId]
			if tabShopItem then
				--costRmb = tabShopItem.rmb or 0
				costScore = tabShopItem.score or 0 --需要的积分
				itemId = tabShopItem.itemID or 0 --商品道具id
			end
		--else --到顶级了
			--
		--end
		
		--升级需要的塔卡图标
		_frmNode.childUI["RequireCardIcon"] = hUI.image:new({
			parent = _parentNode,
			model = hVar.tab_tactics[cardId].icon,
			x = FONT_OFFSET_X + 30,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
			w = 36,
			h = 36,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireCardIcon"
		
		--碎片图标
		_frmNode.childUI["DebrisIcon"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:SoulStoneFlag",
			x = FONT_OFFSET_X + 39,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 281,
			w = 30,
			h = 40,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "DebrisIcon"
		
		--碎片进度条
		local progressV = nowDebris / costDebris * 100 --进度
		if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔到顶级了
			progressV = 0
		end
		_frmNode.childUI["rightBarSoulStoneExp"] = hUI.valbar:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + 55,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 277,
			w = 150,
			h = 25,
			align = "LC",
			back = {model = "UI:SoulStoneBarBg1", x = -4, y = 0, w = 150 + 7, h = 34},
			model = "UI:SoulStoneBar1",
			--model = "misc/progress.png",
			v = progressV,
			max = 100,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "rightBarSoulStoneExp"
		
		--创建一个进度条满了的特别进度条
		if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔到顶级了
			_frmNode.childUI["rightBarSoulStoneExpMaxLv"] = hUI.image:new({
				parent = _parentNode,
				model = "misc/jdt2.png", --"UI:IMG_ValueBarBoss",
				x = FONT_OFFSET_X + 55 + (150) / 2,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 277,
				w = 150,
				h = 25,
				align = "LC",
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "rightBarSoulStoneExpMaxLv"
		end
		
		--塔类卡牌
		--升级需要的碎片的数量文字
		local showNumText = nowDebris .. "/" .. costDebris
		local towerFont = "numWhite"
		local towerColor = ccc3(255, 255, 255)
		local towerBorder = 0
		if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔到顶级了
			--showNumText = "无" --language
			--showNumText = hVar.tab_string["__TEXT_Nothing"] --language
			--towerFont = hVar.FONTC
			towerColor = ccc3(255, 64, 0)
			--towerBorder = 1
		end
		
		--local showNumText = "49999/500000"
		local scaleText = 1.0
		local showTextLength = #showNumText
		if (showTextLength > 11) then --如果长度大于11，只能缩小文字(12~...个字)
			scaleText = 0.56
		elseif (showTextLength > 9) then --如果长度大于9，只能缩小文字(10~11个字)
			scaleText = 0.64
		elseif (showTextLength > 7) then --如果长度大于7，只能缩小文字(8~9个字)
			scaleText = 0.8
		else --可以显示下
			scaleText = 1.0
		end
		_frmNode.childUI["DebrisNum"] = hUI.label:new({
			parent = _parentNode,
			size = 24,
			x = FONT_OFFSET_X + 128,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 278,
			w = 300,
			align = "MC",
			font = towerFont,
			text = showNumText,
			border = towerBorder,
			scale = scaleText,
		})
		_frmNode.childUI["DebrisNum"].handle.s:setColor(towerColor)
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "DebrisNum"
		
		--升级需要的积分图标
		_frmNode.childUI["RequireScoreIcon"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:score",
			x = FONT_OFFSET_X + 260,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
			w = 32,
			h = 32,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireScoreIcon"
		
		--塔类卡牌
		--升级需要的积分的数量文字
		local showJFText = tostring(costScore)
		local JFFont = "numWhite"
		local JFColor = ccc3(255, 255, 255)
		local JFBorder = 0
		if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔到顶级了
			showJFText = "无" --language
			showJFText = hVar.tab_string["__TEXT_Nothing"] --language
			JFFont = hVar.FONTC
			--showJFText = "N/A"
			JFColor = ccc3(255, 64, 0)
			JFBorder = 1
		end
		--local showJFText = "499999"
		local scaleJFText = 1.0
		local showJFTextLength = #showJFText
		if (showJFTextLength > 7) then --如果长度大于7，只能缩小文字(8个字)
			scaleJFText = 0.7
		elseif (showJFTextLength > 5) then --如果长度大于5，只能缩小文字(6~7个字)
			scaleJFText = 0.8
		elseif (showJFTextLength > 4) then --如果长度大于4，只能缩小文字(5个字)
			scaleJFText = 0.9
		else --可以显示下
			scaleJFText = 1.0
		end
		_frmNode.childUI["ScoreNum"] = hUI.label:new({
			parent = _parentNode,
			size = 24,
			x = FONT_OFFSET_X + 280,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 279,
			w = 300,
			align = "LC",
			font = JFFont,
			text = showJFText,
			border = JFBorder,
			scale = scaleJFText
		})
		_frmNode.childUI["ScoreNum"].handle.s:setColor(JFColor)
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "ScoreNum"
		
		--事件响应控件
		--碎片用于点击的区域
		_frmNode.childUI["RequireCardTouchBtn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = FONT_OFFSET_X + 110,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
			w = 220,
			h = 68,
			scaleT = 1.0,
			--[[
			failcall = 1,
			
			--按下碎片图标区域事件，显示碎片说明
			codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
				local __parent = _frmNode.childUI["RequireCardTouchBtn"]
				local __parentHandle = __parent.handle._n
				local offset = 75
				local yOffset = 100
				
				--选中框
				__parent.childUI["box"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:Tactic_Selected",
					x = -80,
					y = 0,
					w = 36,
					h = 36,
					align = "MC",
				})
				
				--技能背景框
				__parent.childUI["imgBg"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:TacticBG", --"UI:ExpBG",
					x = offset,
					y = yOffset,
					w = 380,
					h = 110,
					align = "MC",
				})
				__parent.childUI["imgBg"].handle.s:setOpacity(204) --技能背景框透明度为204
				
				--图标
				__parent.childUI["imgIcon"] = hUI.image:new({
					parent = __parentHandle,
					model = hVar.tab_tactics[cardId].icon,
					x = offset - 148,
					y = yOffset - 2,
					w = 64,
					h = 64,
					align = "MC",
				})
				
				--碎片图标
				__parent.childUI["imgSoleStone"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:SoulStoneFlag",
					x = offset - 148 + 20,
					y = yOffset - 17,
					w = 40,
					h = 54,
					align = "MC",
				})
				
				--碎片名称
				local name = hVar.tab_stringT[cardId] and hVar.tab_stringT[cardId][1] or ("未知塔" .. cardId)
				__parent.childUI["labName"] = hUI.label:new({
					parent = __parentHandle,
					size = 30,
					align = "LT",
					border = 1,
					x = offset - 110,
					y = yOffset + 43,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					--text = name .. "碎片", --language
					text = name .. hVar.tab_string["__TEXT_ITEM_TYPE_TACTICDEBRIS"], --language
				})
				__parent.childUI["labName"].handle.s:setColor(ccc3(196, 255, 196))
				
				--碎片介绍
				--local intro = "升级" .. name .. "需要消耗一定数量的该碎片。"
				local intro = hVar.tab_string["__UPGRADE"] .. name .. hVar.tab_string["RequireCostSomeDebris"] --language
				__parent.childUI["labIntro"] = hUI.label:new({
					parent = __parentHandle,
					size = 26,
					align = "LT",
					border = 1,
					x = offset - 110,
					y = yOffset + 8,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					text = intro,
				})
				__parent.childUI["labIntro"].handle.s:setColor(ccc3(255, 255, 255))
			end,
			
			--抬起碎片图标区域事件，删除该战术技能卡的说明
			code = function(self)
				local __parent = _frmNode.childUI["RequireCardTouchBtn"]
				hApi.safeRemoveT(__parent.childUI, "box") --选中框
				hApi.safeRemoveT(__parent.childUI, "imgBg") --技能背景框
				hApi.safeRemoveT(__parent.childUI, "imgIcon") --图标
				hApi.safeRemoveT(__parent.childUI, "imgSoleStone") --碎片图标
				hApi.safeRemoveT(__parent.childUI, "labName") --碎片名称
				hApi.safeRemoveT(__parent.childUI, "labIntro") --碎片介绍
			end,
			]]
			--抬起碎片图标区域事件，删除该战术技能卡的说明
			code = function(self)
				--显示战术技能卡的tip
				local rewardType = 6 --碎片类型
				local tacticLv = 1
				hApi.ShowTacticCardTip(rewardType, cardId, tacticLv, cardId)
			end,
		})
		_frmNode.childUI["RequireCardTouchBtn"].handle.s:setOpacity(0) --用于响应点击事件，不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireCardTouchBtn"
		
		--事件响应控件
		--积分用于点击的区域
		_frmNode.childUI["RequireJiFenTouchBtn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = FONT_OFFSET_X + 310,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
			w = 160,
			h = 68,
			scaleT = 1.0,
			--[[
			failcall = 1,
			
			--按下积分图标区域事件，显示碎片说明
			codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
				local __parent = _frmNode.childUI["RequireJiFenTouchBtn"]
				local __parentHandle = __parent.handle._n
				local offset = -125
				local yOffset = 100
				
				--选中框
				__parent.childUI["box"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:Tactic_Selected",
					x = -50,
					y = 0,
					w = 36,
					h = 36,
					align = "MC",
				})
				
				--技能背景框
				__parent.childUI["imgBg"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:TacticBG", --"UI:ExpBG",
					x = offset,
					y = yOffset,
					w = 380,
					h = 110,
					align = "MC",
				})
				__parent.childUI["imgBg"].handle.s:setOpacity(204) --技能背景框透明度为204
				
				--图标
				__parent.childUI["imgIcon"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:score",
					x = offset - 148,
					y = yOffset - 2,
					w = 64,
					h = 64,
					align = "MC",
				})
				
				--积分名称
				__parent.childUI["labName"] = hUI.label:new({
					parent = __parentHandle,
					size = 30,
					align = "LT",
					border = 1,
					x = offset - 110,
					y = yOffset + 43,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					--text = "积分", --language
					text = hVar.tab_string["ios_score"], --language
				})
				__parent.childUI["labName"].handle.s:setColor(ccc3(255, 255, 196))
				
				--积分介绍
				local name = hVar.tab_stringT[cardId] and hVar.tab_stringT[cardId][1] or ("未知塔" .. cardId)
				--local intro = "升级" .. name .. "需要消耗一定数量的积分。" --language
				local intro = hVar.tab_string["__UPGRADE"] .. name .. hVar.tab_string["RequireCostSomeJiFen"] --language
				__parent.childUI["labIntro"] = hUI.label:new({
					parent = __parentHandle,
					size = 26,
					align = "LT",
					border = 1,
					x = offset - 110,
					y = yOffset + 8,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					text = intro,
				})
				__parent.childUI["labIntro"].handle.s:setColor(ccc3(255, 255, 255))
			end,
			
			--抬起积分图标区域事件，删除该战术技能卡的说明
			code = function(self)
				local __parent = _frmNode.childUI["RequireJiFenTouchBtn"]
				hApi.safeRemoveT(__parent.childUI, "box") --选中框
				hApi.safeRemoveT(__parent.childUI, "imgBg") --技能背景框
				hApi.safeRemoveT(__parent.childUI, "imgIcon") --图标
				hApi.safeRemoveT(__parent.childUI, "labName") --积分名称
				hApi.safeRemoveT(__parent.childUI, "labIntro") --积分介绍
			end,
			]]
			--抬起积分图标区域事件，删除该战术技能卡的说明
			code = function(self)
				--显示积分介绍的tip
				hApi.ShowJiFennTip()
			end,
		})
		_frmNode.childUI["RequireJiFenTouchBtn"].handle.s:setOpacity(0) --用于响应事件，不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireJiFenTouchBtn"
		
		--塔类卡牌的升级按钮
		--升级或者解锁塔的按钮
		local updateText = hVar.tab_string["__UPGRADE"] --"升级"
		if (towerLv == 0) then
			updateText = hVar.tab_string["__UNLOCK"] --"解锁"
		end
		_frmNode.childUI["btnCostJiFen"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = FONT_OFFSET_X + 190,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 360,
			w = 180,
			h = 70,
			--label = updateText,
			--font = hVar.FONTC,
			--border = 1,
			--model = "UI:BTN_ButtonRed",
			model = "panel/panel_menu_btn_big.png", --"UI:BTN_ButtonRed"
			--animation = "normal",
			scaleT = 0.95,
			--scale = 1.0,
			code = function()
				--点击用积分升级塔按钮
				if (towerLv < hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔未到顶级
					OnClickLvUpButton(cardId, towerLv, costDebris, nowDebris, costScore, nowScore, itemId)
				end
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnCostJiFen"
		if (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果塔已到顶级
			_frmNode.childUI["btnCostJiFen"].handle._n:setVisible(false)
		end
		--积分升级按钮的升级小箭头
		_frmNode.childUI["btnCostJiFen"].childUI["UI_Arrow"] = hUI.image:new({
			parent = _frmNode.childUI["btnCostJiFen"].handle._n,
			model = "UI:jiantou_new",
			x = 0,
			y = 23,
			w = 74,
			h = 74,
		})
		--_frmNode.childUI["btnCostJiFen"].childUI["UI_Arrow"].handle._n:setRotation(-90)
		--名字
		_frmNode.childUI["btnCostJiFen"].childUI["name"] = hUI.label:new({
			parent = _frmNode.childUI["btnCostJiFen"].handle._n,
			font = hVar.FONTC,
			border = 1,
			align = "MC",
			text = updateText,
			x = 0,
			y = -10,
			size = 32,
		})
		
		--如果不符合升级的条件，按钮灰掉
		if (nowDebris < costDebris) or (nowScore < costScore) or (towerLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then
			hApi.AddShader(_frmNode.childUI["btnCostJiFen"].handle.s, "gray")
			hApi.AddShader(_frmNode.childUI["btnCostJiFen"].childUI["UI_Arrow"].handle.s, "gray")
		end
		
		--标记当前选中的特种塔项的索引和卡牌id
		--print("标记当前选中的特种塔项的索引和卡牌id", subPageIndex)
		CurrentSelectRecord.subPageIdx = subPageIndex
		CurrentSelectRecord.contentIdx = contentIndex
		CurrentSelectRecord.cardId = cardId
	end
	
	
	--函数：创建战术技能卡的升级图界面（第4个分页）
	OnCreateTacticDiagramFrame = function(pageIndex)
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--允许本分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Tactic", 1)
		
		--[[
		--左侧战术技能卡列表底板
		_frmNode.childUI["TacticListBG2"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:TacticBG",
			x = TACTIC_CARD_OSSSET_XL + 135,
			y = TACTIC_CARD_OSSSET_Y - 165,
			w = 375 + 4,
			h = TACTIC_PANEL_HEIGHT + 2 + 4,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TacticListBG2"
		
		--左侧战术技能卡列表底板
		_frmNode.childUI["TacticListBG"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/gray_mask_16.png",
			x = TACTIC_CARD_OSSSET_XL + 135,
			y = TACTIC_CARD_OSSSET_Y - 165,
			w = 375,
			h = TACTIC_PANEL_HEIGHT + 2,
		})
		_frmNode.childUI["TacticListBG"].handle.s:setColor(ccc3(168, 168, 168))
		--_frmNode.childUI["TacticListBG"].handle.s:setOpacity(0)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TacticListBG"
		]]
		
		--左侧提示上翻页的图片
		_frmNode.childUI["TacticPageUp"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = TACTIC_CARD_OSSSET_XL + (TACTIC_X_NUM * TACTIC_CARD_DISTANCE_X) / 2 - TACTIC_CARD_DISTANCE_X / 2 - 2, --非对称式
			y = 0 - 75 * _ScaleH + 40 * _ScaleH,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["TacticPageUp"].handle.s:setRotation(90)
		_frmNode.childUI["TacticPageUp"].handle.s:setOpacity(8) --提示上翻页默认透明度为212
		_frmNode.childUI["TacticPageUp"].handle.s:setVisible(false) --默认不显示左分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TacticPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["TacticPageUp"].handle._n:runAction(forever)
		
		--左侧提示下翻页的图片
		_frmNode.childUI["TacticPageDown"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = TACTIC_CARD_OSSSET_XL + (TACTIC_X_NUM * TACTIC_CARD_DISTANCE_X) / 2 - TACTIC_CARD_DISTANCE_X / 2 + 3, --非对称式
			y = -hVar.SCREEN.h + 95 * _ScaleH - 40 * _ScaleH,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["TacticPageDown"].handle.s:setRotation(270)
		_frmNode.childUI["TacticPageDown"].handle.s:setOpacity(8) --提示下翻页默认透明度为212
		--如果战术卡数量未铺满第一页，那么不显示下翻页提示
		if (#hVar.tab_tacticsEx <= (TACTIC_X_NUM * TACTIC_Y_NUM)) then
			_frmNode.childUI["TacticPageDown"].handle.s:setVisible(false) --默认不显示下分翻页提示
		end
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TacticPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["TacticPageDown"].handle._n:runAction(forever)
		
		--战术卡左侧向上翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["TacticPageUp_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = TACTIC_CARD_OSSSET_XL + (TACTIC_X_NUM * TACTIC_CARD_DISTANCE_X) / 2 - TACTIC_CARD_DISTANCE_X / 2,
			y = 0 - 75 * _ScaleH + 40 * _ScaleH + 20 * _ScaleH,
			w = 200 * _ScaleW,
			h = 80 * _ScaleH,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (#hVar.tab_tacticsEx > (TACTIC_X_NUM * TACTIC_Y_NUM)) then
					--print("向下滚屏", screenY)
					--向下滚屏
					b_need_auto_fixing_tactic = true
					friction_tactic = 0
					draggle_speed_y_tactic = -MAX_SPEED_TACTIC / 2.0 --负速度
				end
			end,
		})
		_frmNode.childUI["TacticPageUp_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TacticPageUp_Btn"
		
		---战术卡左侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["TacticPageDown_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = TACTIC_CARD_OSSSET_XL + (TACTIC_X_NUM * TACTIC_CARD_DISTANCE_X) / 2 - TACTIC_CARD_DISTANCE_X / 2,
			y = -hVar.SCREEN.h + 95 * _ScaleH - 40 * _ScaleH - 20 * _ScaleH,
			w = 200 * _ScaleW,
			h = 80 * _ScaleH,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (#hVar.tab_tacticsEx > (TACTIC_X_NUM * TACTIC_Y_NUM)) then
					--print("向上滚屏", screenY)
					--向上滚屏
					b_need_auto_fixing_tactic = true
					friction_tactic = 0
					draggle_speed_y_tactic = MAX_SPEED_TACTIC / 2.0 --正速度
				end
			end,
		})
		_frmNode.childUI["TacticPageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TacticPageDown_Btn"
		
		--左侧用于检测滑动事件的控件
		_frmNode.childUI["TacticDragPanel"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = TACTIC_CARD_OSSSET_XL + (TACTIC_X_NUM * TACTIC_CARD_DISTANCE_X) / 2 - TACTIC_CARD_DISTANCE_X / 2,
			y = (-hVar.SCREEN.h - 60 * _ScaleH + 84 * _ScaleH) / 2 - 10 / 2 * _ScaleH,
			w = TACTIC_X_NUM * TACTIC_CARD_DISTANCE_X,
			h = hVar.SCREEN.h - 60 * _ScaleH - 84 * _ScaleH + 10 * _ScaleH,
			--w = 380,
			--h = TACTIC_PANEL_HEIGHT,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--print("codeOnTouch", touchX, touchY, sus)
				click_pos_x_tactic = touchX --开始按下的坐标x
				click_pos_y_tactic = touchY --开始按下的坐标y
				last_click_pos_y_tactic = touchX --上一次按下的坐标x
				last_click_pos_y_tactic = touchY --上一次按下的坐标y
				selected_tacticEx_idx = 0 --战术卡选中的成就ex索引
				draggle_speed_y_tactic = 0 --当前速度为0
				click_scroll_tactic = true --是否滑动成就
				b_need_auto_fixing_tactic = false --不需要自动修正位置
				friction_tactic = 0 --无阻力
				
				--如果一般战术技能卡数量未铺满一页，那么不需要滑动
				if (#hVar.tab_tacticsEx <= (TACTIC_X_NUM * TACTIC_Y_NUM)) then
					click_scroll_tactic = false --不需要滑动成就
				end
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
				--处理移动速度y
				draggle_speed_y_tactic = touchY - last_click_pos_y_tactic
				
				if (draggle_speed_y_tactic > MAX_SPEED_TACTIC) then
					draggle_speed_y_tactic = MAX_SPEED_TACTIC
				end
				if (draggle_speed_y_tactic < -MAX_SPEED_TACTIC) then
					draggle_speed_y_tactic = -MAX_SPEED_TACTIC
				end
				
				--print("click_scroll_tactic=", click_scroll_tactic)
				--在滑动过程中才会处理滑动
				if click_scroll_tactic then
					local deltaY = touchY - last_click_pos_y_tactic --与开始按下的位置的偏移值x
					for i = 1, #hVar.tab_tacticsEx, 1 do
						local ctrli = _frmNode.childUI["TacticCard" .. i]
						ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
						ctrli.data.x = ctrli.data.x
						ctrli.data.y = ctrli.data.y + deltaY
					end
				end
				
				--存储本次的位置
				last_click_pos_y_tactic = touchX
				last_click_pos_y_tactic = touchY
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_tactic then
					--if (touchX ~= click_pos_x_tactic) or (touchY ~= click_pos_y_tactic) then --不是点击事件
						b_need_auto_fixing_tactic = true
						friction_tactic = 0
					--end
				end
				
				--检测
				--检测点击到了哪个战术卡框内
				for i = 1, #hVar.tab_tacticsEx, 1 do
					local ctrli = _frmNode.childUI["TacticCard" .. i]
					local cx = ctrli.data.x --中心点x坐标
					local cy = ctrli.data.y --中心点y坐标
					local cw, ch = ctrli.data.w, ctrli.data.h
					local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
					local rx, ry = lx + cw, ly + ch --最右下角坐标
					--print(i, lx, rx, touchX)
					--print("click" ..  i,  "x=" .. ctrli.data.x, touchX, touchY, lx, rx, ly, ry)
					if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
						selected_tacticEx_idx = i
						
						break
						--print("点击到了哪个成就的框内" .. i)
					end
				end
				
				--这种情况请注意：在触发滑动操作（成就数量大于一页），并且按下坐标和抬起坐标偏差过大，则认为该操作是滑动，不触发选择卡牌
				if (click_scroll_tactic) and (math.abs(touchY - click_pos_y_tactic) > 40) then
					selected_tacticEx_idx = 0
				end
				--print("selected_tacticEx_idx", selected_tacticEx_idx)
				
				--之前选中了某个成就
				if (selected_tacticEx_idx > 0) then
					--点击战术技能卡按钮
					OnClickTacticBtn(pageIndex, selected_tacticEx_idx)
					
					--selected_tacticEx_idx = 0
				end
				
				--标记不用滑动
				click_scroll_tactic = false
			end,
		})
		_frmNode.childUI["TacticDragPanel"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TacticDragPanel"
		
		--找出所有已获得的一般战术技能卡
		local tacticHashList = {} --一般类战术技能键值表
		local tTactics = LuaGetPlayerSkillBook()
		if tTactics then
			for i = 1,#tTactics, 1 do
				if (type(tTactics[i])=="table") then
					local id, lv, num = unpack(tTactics[i])
					--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
					
					--存在表项
					if hVar.tab_tactics[id] then
						local type = hVar.tab_tactics[id].type --战术技能卡类型
						if (type == hVar.TACTICS_TYPE.OTHER) then --此类专属于一般战术技能卡，放在此处
							--检测是否重复
							if tacticHashList[id] then
								--如果等级更大，用大等级的
								if (lv > tacticHashList[id].skillLV) then
									tacticHashList[id].skillLV = lv
									tacticHashList[id].num = num
								end
							else  --不存在
								tacticHashList[id] = {skillID = id, skillLV = lv, num = num}
							end
						end
					end
				end
			end
		end
		
		--先绘制每一个已获得的战术技能卡（等级大于0）
		local indexHave = 0 --已获得的战术技能卡（等级大于0）索引值
		for i = 1, #hVar.tab_tacticsEx, 1 do
			local tacticId = hVar.tab_tacticsEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv > 0) then
				indexHave = indexHave + 1
				--创建单个战术技能卡控件已获得的（等级大于0）
				OnCreateSingleTacticCard(pageIndex, indexHave, tacticId, tacticHashList)
			end
		end
		
		--再绘制每一个未获得的战术技能卡（等级等于0或者不存在）
		local indexNotHave = indexHave --未获得的战术技能卡（等级等于0或者不存在）索引值
		for i = 1, #hVar.tab_tacticsEx, 1 do
			local tacticId = hVar.tab_tacticsEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv == 0) then
				indexNotHave = indexNotHave + 1
				--创建单个战术技能卡控件未获得的（等级等于0或者不存在）
				OnCreateSingleTacticCard(pageIndex, indexNotHave, tacticId, tacticHashList)
			end
		end
		
		--介绍点击战术技能卡的文字
		--右侧显示提示点击塔的图标查看文字
		_frmNode.childUI["HintClickTactic"] = hUI.label:new({
			parent = _parentNode,
			x = hVar.SCREEN.w - 300 *_ScaleW,
			y = -278,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 250,
			--text = "点击左侧战术卡查看详情。", --language
			text = hVar.tab_string["ClickTacticCardSeeDetail"], --language
			border = 1,
		})
		_frmNode.childUI["HintClickTactic"].handle.s:setColor(ccc3(196, 196, 196))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "HintClickTactic"
		
		--只在本分页有效
		--创建timer，刷新战术技能卡滚动
		hApi.addTimerForever("__TACTIC_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_tacitc_UI_scroll_loop)
	end
	
	--函数：获得第一个可以升级的战术技能卡的索引
	GetFirstLvUpTacticCardIdx = function()
		--print("GetFirstLvUpTacticCardIdx")
		--战术卡的最高等级
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		
		--当前的积分
		local currentScore = LuaGetPlayerScore()
		
		--一般类战术技能键值表
		local tacticHashList = {}
		local tTactics = LuaGetPlayerSkillBook()
		if tTactics then
			for i = 1, #tTactics, 1 do
				if (type(tTactics[i])=="table") then
					local id, lv, num = unpack(tTactics[i])
					--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
					
					--存在表项
					if hVar.tab_tactics[id] then
						local type = hVar.tab_tactics[id].type --战术技能卡类型
						if (type == hVar.TACTICS_TYPE.OTHER) then --此类专属于一般战术技能卡，放在此处
							--检测是否重复
							if tacticHashList[id] then
								--如果等级更大，用大等级的
								if (lv > tacticHashList[id].skillLV) then
									tacticHashList[id].skillLV = lv
									tacticHashList[id].num = num
								end
							else  --不存在
								tacticHashList[id] = {skillID = id, skillLV = lv, num = num}
							end
						end
					end
				end
			end
		end
		
		--先绘制每一个已获得的战术技能卡（等级大于0）
		local indexHave = 0 --已获得的战术技能卡（等级大于0）索引值
		for i = 1, #hVar.tab_tacticsEx, 1 do
			local tacticId = hVar.tab_tacticsEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv > 0) then
				indexHave = indexHave + 1
				
				--检测是否可以升级
				local lvNow = tacticLv or 0
				if (lvNow >= maxLv) then
					lvNow = maxLv
				end
				local costDebris = hVar.TACTIC_LVUP_INFO[lvNow].costDebris or 0
				local costScore = 0 --需要的积分
				local shopItemId = hVar.TACTIC_LVUP_INFO[lvNow].shopItemId or 0
				local tabShopItem = hVar.tab_shopitem[shopItemId]
				if tabShopItem then
					costScore = tabShopItem.score or 0 --需要的积分
				end
				
				if (lvNow >= maxLv) then --战术技能卡已到顶级
					--不能升级
					--...
				else --还可以升级
					if (tacticDebrisNum >= costDebris) and (currentScore >= costScore) then
						return indexHave
					end
				end
			end
		end
		
		--再绘制每一个未获得的战术技能卡（等级等于0或者不存在）
		local indexNotHave = indexHave --未获得的战术技能卡（等级等于0或者不存在）索引值
		for i = 1, #hVar.tab_tacticsEx, 1 do
			local tacticId = hVar.tab_tacticsEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv == 0) then
				indexNotHave = indexNotHave + 1
				--print("indexNotHave", indexNotHave)
				--检测是否可以升级
				local lvNow = tacticLv or 0
				if (lvNow >= maxLv) then
					lvNow = maxLv
				end
				local costDebris = hVar.TACTIC_LVUP_INFO[lvNow].costDebris or 0
				local costScore = 0 --需要的积分
				local shopItemId = hVar.TACTIC_LVUP_INFO[lvNow].shopItemId or 0
				local tabShopItem = hVar.tab_shopitem[shopItemId]
				if tabShopItem then
					costScore = tabShopItem.score or 0 --需要的积分
				end
				
				--可升级的提示
				if (tacticDebrisNum >= costDebris) and (currentScore >= costScore) then
					return indexNotHave
				end
			end
		end
		
		--走到这里说明没有一个是能升级的，返回第一项
		return 1
	end
	
	--函数：创建单个战术技能卡控件
	OnCreateSingleTacticCard = function(pageIndex, index, tacticId, tacticHashList)
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--先计算xi和yi
		local xi = (index % TACTIC_X_NUM) --xi
		if (xi == 0) then
			xi = TACTIC_X_NUM
		end
		local yi = (index - xi) / TACTIC_X_NUM + 1 --yi
		local tacticLv = 0 --战术技能卡等级
		local tacticDebrisNum = 0 --战术技能卡碎片的数量
		
		if tacticHashList[tacticId] then
			tacticLv = tacticHashList[tacticId].skillLV
			tacticDebrisNum = tacticHashList[tacticId].num
			
			--显示不超过最大等级
			local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
			if (tacticLv > maxLv) then
				tacticLv = maxLv
			end
		end
		
		--战术技能卡控件
		local qLv = math.min((hVar.tab_tactics[tacticId].quality or 1), 4) --图片最多只有4张
		_frmNode.childUI["TacticCard" .. index] = hUI.button:new({ --作为button只是为了作为父控件，让子控件的坐标显示正常
			parent = _BTC_pClipNode_Tactic,
			--mode = "imageButton",
			--dragbox = _frm.childUI["dragBox"],
			model = "UI:tactic_card_" .. qLv,
			x = TACTIC_CARD_OSSSET_XL + (xi - 1) *  TACTIC_CARD_DISTANCE_X,
			y = TACTIC_CARD_OSSSET_Y - (yi - 1) * TACTIC_CARD_DISTANCE_Y,
			w = TACTIC_CARD_WIDTH,
			h = TACTIC_CARD_HEIGHT,
			scale = 1.0,
			align = "MC",
			--scaleT = 1.0,
			--failcall = 1,
			--点击事件
			--code = function(self, screenX, screenY, isInside)
			--	--点击战术技能卡按钮
			--	OnClickTacticBtn(pageIndex, index)
			--end,
		})
		_frmNode.childUI["TacticCard" .. index].data.tacticId = tacticId --存储战术技能卡id
		_frmNode.childUI["TacticCard" .. index].data.tacticLv = tacticLv --存储战术技能卡等级
		_frmNode.childUI["TacticCard" .. index].data.tacticDebrisNum = tacticDebrisNum --存储战术技能卡碎片数量
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TacticCard" .. index
		
		--战术技能卡类型图标
		local button = _frmNode.childUI["TacticCard" .. index]
		button.childUI["typeicon"] = hUI.image:new({
			parent = button.handle._n,
			model = hApi.GetTacticsCardTypeIcon(tacticId, "model"),
			x = -2,
			y = 42,
			w = 28,
			h = 28,
		})
		--button.childUI["typeicon"].handle.s:setColor(ccc3(164, 164, 164)) --变灰
		
		--战术技能卡技能图标
		button.childUI["skillIcon"]= hUI.image:new({
			parent = button.handle._n,
			model = hVar.tab_tactics[tacticId].icon,
			x = 0,
			y = 0,
			w = 60,
			h = 60,
		})
		--button.childUI["skillIcon"].handle.s:setColor(ccc3(164, 164, 164)) --变灰
		
		--一般战术技能卡的技能背景图
		button.childUI["LvBG"]= hUI.image:new({
			parent = button.handle._n,
			model = "ui/pvp/pvpselect.png",
			x = TACTIC_CARD_WIDTH - 58,
			y = 38,
			w = 36,
			h = 36,
		})
		
		--一般战术技能卡的等级
		local fontSize = 26
		if tacticLv and (tacticLv >= 10) then --如果等级是2位数的，那么缩一下文字
			fontSize = 18
		end
		button.childUI["Lv"] = hUI.label:new({
			parent = button.handle._n,
			x = TACTIC_CARD_WIDTH - 58,
			y = 38 - 1,
			text = tacticLv,
			size = fontSize,
			font = "numWhite",
			align = "MC",
			width = 200,
		})
		
		--一般战术技能卡将魂经验条
		button.childUI["barSoulStoneExp"] = hUI.valbar:new({
			parent = button.handle._n,
			x = -37,
			y = -42,
			w = TACTIC_CARD_WIDTH - 14,
			h = 15,
			align = "LC",
			back = {model = "UI:SoulStoneBarBg1", x = -2, y = 0, w = TACTIC_CARD_WIDTH - 10, h = 18},
			model = "UI:SoulStoneBar1",
			--model = "misc/progress.png",
			v = 100,
			max = 100,
		})
		
		--一般战术技能卡将魂所需经验显示
		button.childUI["labSoulStoneExp"] = hUI.label:new({
			parent = button.handle._n,
			size = 26,
			align = "MC",
			--font = hVar.FONTC,
			font = hVar.DEFAULT_FONT,
			x = 0,
			y = -35,
			text = "", --"NA", --geyachao: 这里不显示等级文字了
		})
		
		--将魂可以升级的箭头提示
		--一般战术技能卡升级的动态箭头
		button.childUI["tacticSoulStonejianTou"] = hUI.image:new({
			parent = button.handle._n,
			model = "ICON:image_jiantouV",
			x = 13,
			y = -9,
			w = 28, --236
			h = 28, --146
			align = "MC",
		})
		--_frm.childUI["tacticSoulStonejianTou"].handle._n:setRotation(0)
		button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(false) --默认隐藏
		
		--一般战术技能卡按钮选中框
		local scaleX = (TACTIC_CARD_WIDTH + 4) / 72
		local scaleY = (TACTIC_CARD_HEIGHT + 4) / 72
		button.childUI["selectbox"] = hUI.image:new({
			parent = button.handle._n,
			model = "UI:TacTicFrame", --"UI:PHOTO_FRAME_BAR",
			align = "MC",
			x = 0,
			y = 0,
			w = TACTIC_CARD_WIDTH + 4,
			h = TACTIC_CARD_HEIGHT + 4,
		})
		button.childUI["selectbox"].handle.s:setVisible(false) --默认隐藏
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, scaleX - 0.015, scaleY - 0.015), CCScaleTo:create(0.6, scaleX + 0.025, scaleY + 0.025))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		button.childUI["selectbox"].handle.s:runAction(forever)
		
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		local lvNow = tacticLv or 0
		if (lvNow >= maxLv) then
			lvNow = maxLv
		end
		local costDebris = hVar.TACTIC_LVUP_INFO[lvNow].costDebris or 0
		local costScore = 0 --需要的积分
		local shopItemId = hVar.TACTIC_LVUP_INFO[lvNow].shopItemId or 0
		local tabShopItem = hVar.tab_shopitem[shopItemId]
		if tabShopItem then
			costScore = tabShopItem.score or 0 --需要的积分
		end
		
		--未获得战术技能卡
		if (lvNow <= 0) then
			hApi.AddShader(button.handle.s,"gray")
			hApi.AddShader(button.childUI["skillIcon"].handle.s,"gray")
			hApi.AddShader(button.childUI["typeicon"].handle.s,"gray")
			button.childUI["barSoulStoneExp"]:setV(tacticDebrisNum, costDebris)
			--button.childUI["labSoulStoneExp"]:setText(tostring(tacticDebrisNum).. "/".. tostring(costDebris))
			
			--可升级的提示
			if (tacticDebrisNum >= costDebris) and (LuaGetPlayerScore() >= costScore) then
				button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(true) --显示可升级的箭头提示
			else
				button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(false) --隐藏可升级的箭头提示
			end
		else
			if (lvNow >= maxLv) then --战术技能卡已到顶级
				button.childUI["barSoulStoneExp"]:setV(0, 100)
				--button.childUI["labSoulStoneExp"]:setText(hVar.tab_string[("__BLANK__")])
				
				--不能升级的提示
				button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(false) --隐藏可升级的箭头提示
				
				--创建一个进度条满了的特别进度条
				button.childUI["tacticMaxLvProgressImg"] = hUI.image:new({
					parent = button.handle._n,
					model = "misc/jdt2.png", --"UI:IMG_ValueBarBoss",
					x = -37 + (TACTIC_CARD_WIDTH - 14) / 2,
					y = -42,
					w = TACTIC_CARD_WIDTH - 14,
					h = 15, --146
					align = "MC",
				})
			else --还可以升级
				button.childUI["barSoulStoneExp"]:setV(tacticDebrisNum, costDebris)
				--button.childUI["labSoulStoneExp"]:setText(tostring(tacticDebrisNum).. "/".. tostring(costDebris))
				
				--可升级的提示
				if (tacticDebrisNum >= costDebris) and (LuaGetPlayerScore() >= costScore) then
					button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(true) --显示可升级的箭头提示
				else
					button.childUI["tacticSoulStonejianTou"].handle.s:setVisible(false) --隐藏可升级的箭头提示
				end
			end
		end
	end
	
	--函数：自动调整战术技能卡控件的滑动
	refresh_tacitc_UI_scroll_loop = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local SPEED = 50 --速度
		--print(b_need_auto_fixing_tactic)
		
		if b_need_auto_fixing_tactic then
			---第一个战术卡的数据
			local TacticBtn1 = _frmNode.childUI["TacticCard1"]
			local btn1_cx, btn1_cy = 0, 0 --第一个战术卡中心点位置
			local btn1_ly = 0 --第一个成就最上侧的x坐标
			local delta1_ly = 0 --第一个成就距离上侧边界的距离
			btn1_cx, btn1_cy = TacticBtn1.data.x, TacticBtn1.data.y --第一个成就中心点位置
			btn1_ly = math.floor(btn1_cy + TACTIC_CARD_HEIGHT / 2 * _ScaleH) --第一个战术卡最上侧的y坐标
			delta1_ly = math.floor(btn1_ly - TACTIC_CARD_OSSSET_Y - 55 * _ScaleH) --第一个战术卡距离上侧边界的距离
			
			--最后一个战术卡的数据
			local TacticBtnN = _frmNode.childUI["TacticCard" .. (#hVar.tab_tacticsEx)]
			local btnN_cx, btnN_cy = 0, 0 --最后一个成就中心点位置
			local btnN_ry = 0 --最后一个成就最下侧的x坐标
			local deltNa_ry = 0 --最后一个成就距离下侧边界的距离
			btnN_cx, btnN_cy = TacticBtnN.data.x, TacticBtnN.data.y --最后一个成就中心点位置
			btnN_ry = math.floor(btnN_cy - TACTIC_CARD_HEIGHT / 2  * _ScaleH) --最后一个战术卡最下侧的x坐标
			deltNa_ry = math.floor(btnN_ry - TACTIC_CARD_OSSSET_YB - 10 * _ScaleH) --最后一个战术卡距离下侧边界的距离
			--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
			
			--print("delta1_ly=" .. delta1_ly, ", deltNa_rx=" .. deltNa_rx)
			--如果第一个成就的头像跑到下边，那么优先将第一个成就头像贴边
			if (delta1_ly < 0) then
				--print("优先将第一个成就头像贴边")
				--需要修正
				--不会选中成就
				selected_tacticEx_idx = 0 --选中的成就索引
				
				--没有惯性
				draggle_speed_y_tactic = 0
				
				local speed = SPEED
				if ((delta1_ly + speed) > 0) then --防止走过
					speed = -delta1_ly
					delta1_ly = 0
				end
				
				--每个按钮向上侧做运动
				for i = 1, #hVar.tab_tacticsEx, 1 do
					local ctrli = _frmNode.childUI["TacticCard" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x, pos_y + speed
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页不显示，下滑动翻页显示
				_frmNode.childUI["TacticPageUp"].handle.s:setVisible(false) --上翻页提示
				_frmNode.childUI["TacticPageDown"].handle.s:setVisible(true) --下翻页提示
			elseif (delta1_ly ~= 0) and (deltNa_ry > 0) then --第一个头像没有贴上侧，并且最后一个头像没有贴下侧，那么再将最后一个成就头像贴边
				--print("将最后一个成就头像贴边")
				--需要修正
				--不会选中成就
				selected_tacticEx_idx = 0 --选中的成就索引
				
				--没有惯性
				draggle_speed_y_tactic = 0
				
				local speed = SPEED
				if ((deltNa_ry - speed) < 0) then --防止走过
					speed = deltNa_ry
					deltNa_ry = 0
				end
				
				--每个按钮向下侧做运动
				for i = 1, #hVar.tab_tacticsEx, 1 do
					local ctrli = _frmNode.childUI["TacticCard" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x, pos_y - speed
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页显示，下滑动翻页不显示
				_frmNode.childUI["TacticPageUp"].handle.s:setVisible(true) --上分翻页提示
				_frmNode.childUI["TacticPageDown"].handle.s:setVisible(false) --下分翻页提示
			elseif (draggle_speed_y_tactic ~= 0) then --沿着当前的速度方向有惯性地运动一会
				--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_y_tactic)
				--不会选中成就
				selected_tacticEx_idx = 0 --选中的成就索引
				--print("    ->   draggle_speed_y_tactic=", draggle_speed_y_tactic)
				
				if (draggle_speed_y_tactic > 0) then --朝上运动
					local speed = (draggle_speed_y_tactic) * 1.0 --系数
					friction_tactic = friction_tactic - 0.5
					draggle_speed_y_tactic = draggle_speed_y_tactic + friction_tactic --衰减（正）
					
					if (draggle_speed_y_tactic < 0) then
						draggle_speed_y_tactic = 0
					end
					
					--最后一个成就的坐标不能跑到最下侧的上边去
					if ((deltNa_ry + speed) > 0) then --防止走过
						speed = -deltNa_ry
						deltNa_ry = 0
						
						--没有惯性
						draggle_speed_y_tactic = 0
					end
					
					--每个按钮向上侧做运动
					for i = 1, #hVar.tab_tacticsEx, 1 do
						local ctrli = _frmNode.childUI["TacticCard" .. i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y + speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
				elseif (draggle_speed_y_tactic < 0) then --朝下运动
					local speed = (draggle_speed_y_tactic) * 1.0 --系数
					friction_tactic = friction_tactic + 0.5
					draggle_speed_y_tactic = draggle_speed_y_tactic + friction_tactic --衰减（负）
					
					if (draggle_speed_y_tactic > 0) then
						draggle_speed_y_tactic = 0
					end
					
					--第一个成就的坐标不能跑到最上侧的下边去
					if ((delta1_ly + speed) < 0) then --防止走过
						speed = -delta1_ly
						delta1_ly = 0
						
						--没有惯性
						draggle_speed_y_tactic = 0
					end
					
					--每个按钮向下侧做运动
					for i = 1, #hVar.tab_tacticsEx, 1 do
						local ctrli = _frmNode.childUI["TacticCard" .. i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y + speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					end
				end
				
				--上滑动翻页显示，下滑动翻页显示
				if (delta1_ly == 0) then
					_frmNode.childUI["TacticPageUp"].handle.s:setVisible(false) --上分翻页提示
				else
					_frmNode.childUI["TacticPageUp"].handle.s:setVisible(true) --上分翻页提示
				end
				if (deltNa_ry == 0) then
					_frmNode.childUI["TacticPageDown"].handle.s:setVisible(false) --下分翻页提示
				else
					_frmNode.childUI["TacticPageDown"].handle.s:setVisible(true) --下分翻页提示
				end
			else --停止运动
				b_need_auto_fixing_tactic = false
				friction_tactic = 0
			end
		end
	end
	
	--函数：计算某个一般战术技能卡的索引值
	CalTacticCardIndex = function(tacticCardId)
		--一般类战术技能键值表
		local tacticHashList = {}
		local tTactics = LuaGetPlayerSkillBook()
		if tTactics then
			for i = 1, #tTactics, 1 do
				if (type(tTactics[i])=="table") then
					local id, lv, num = unpack(tTactics[i])
					--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
					
					--存在表项
					if hVar.tab_tactics[id] then
						local type = hVar.tab_tactics[id].type --战术技能卡类型
						if (type == hVar.TACTICS_TYPE.OTHER) then --此类专属于一般战术技能卡，放在此处
							--检测是否重复
							if tacticHashList[id] then
								--如果等级更大，用大等级的
								if (lv > tacticHashList[id].skillLV) then
									tacticHashList[id].skillLV = lv
									tacticHashList[id].num = num
								end
							else  --不存在
								tacticHashList[id] = {skillID = id, skillLV = lv, num = num}
							end
						end
					end
				end
			end
		end
		
		--先检测每一个已获得的战术技能卡（等级大于0）
		local indexHave = 0 --已获得的战术技能卡（等级大于0）索引值
		for i = 1, #hVar.tab_tacticsEx, 1 do
			local tacticId = hVar.tab_tacticsEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv > 0) then
				indexHave = indexHave + 1
				
				--检测是否是要找的
				if (tacticCardId == tacticId) then
					return indexHave
				end
			end
		end
		
		--再检测每一个未获得的战术技能卡（等级等于0或者不存在）
		local indexNotHave = indexHave --未获得的战术技能卡（等级等于0或者不存在）索引值
		for i = 1, #hVar.tab_tacticsEx, 1 do
			local tacticId = hVar.tab_tacticsEx[i] --战术技能卡id
			local tacticLv = 0 --战术技能卡等级
			local tacticDebrisNum = 0 --战术技能卡碎片的数量
			
			if tacticHashList[tacticId] then
				tacticLv = tacticHashList[tacticId].skillLV
				tacticDebrisNum = tacticHashList[tacticId].num
			end
			
			if (tacticLv == 0) then
				indexNotHave = indexNotHave + 1
				
				--检测是否是要找的
				if (tacticCardId == tacticId) then
					return indexNotHave
				end
			end
		end
		
		return 0
	end
	
	--函数：点击战术技能卡的按钮的执行逻辑
	OnClickTacticBtn = function(pageIndex, contentIndex)
		--print("OnClickTacticBtn")
		--不重复绘制同一个项索引值
		if (CurrentSelectRecord.contentIdx == contentIndex) then
			return
		end
		--print("OnClickTacticBtn2")
		
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--获得参数
		local button = _frmNode.childUI["TacticCard" .. contentIndex]
		local tacticId = button.data.tacticId --战术技能卡id
		local tacticLv = button.data.tacticLv --战术技能卡的等级
		local nowDebris = button.data.tacticDebrisNum --战术技能卡碎片数量
		
		--自身的选中框高亮
		button.childUI["selectbox"].handle.s:setVisible(true) --显示
		
		--上一次选中的战术技能卡取消选中
		if (CurrentSelectRecord.contentIdx ~= 0) then
			_frmNode.childUI["TacticCard" .. CurrentSelectRecord.contentIdx].childUI["selectbox"].handle.s:setVisible(false) --隐藏
		end
		
		--更新详细面板
		--先清空上次右侧的控件集
		_removeRightFrmFunc(pageIndex)
		
		--战术卡第一个文字的偏移值
		--第一个文字的偏移值
		local FONT_OFFSET_X = hVar.SCREEN.w - 580 *_ScaleW --第一个文字的偏移值x
		local FONT_OFFSET_Y = -140 * _ScaleH --第一个文字的偏移值y
		if (g_phone_mode ~= 0) then --手机模式
			FONT_OFFSET_X = hVar.SCREEN.w - 540 *_ScaleW --第一个文字的偏移值x
			FONT_OFFSET_Y = -100 * _ScaleH --第一个文字的偏移值y
			
			--iphone4
			if (hVar.SCREEN.w <= 960) then
				FONT_OFFSET_X = hVar.SCREEN.w - 580 *_ScaleW --第一个文字的偏移值x
				FONT_OFFSET_Y = -100 * _ScaleH --第一个文字的偏移值y
			end
		end
		local FONT_LV0_DX = 0 --0级战术技能卡的额外偏移值x
		local FONT_DELTA_Y = 40 --文字间的间隔y
		
		--显示战术技能卡的名称和说明
		local showTacticLv = tacticLv --显示文字的战术技能卡的等级
		if (showTacticLv == 0) then
			showTacticLv = 1
		end
		local tacticName = hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][1] or ("未知" .. tacticId) --战术技能卡的名字
		local tacticIntro = hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][showTacticLv + 1] or ("未知战术技能卡说明" .. tacticId) --战术技能卡的简介
		
		--显示战术技能卡的名字
		_frmNode.childUI["TacticCardName"] = hUI.label:new({
			parent = _parentNode,
			x = FONT_OFFSET_X,
			y = FONT_OFFSET_Y,
			size = 32,
			font = hVar.FONTC,
			align = "LC",
			width = 340,
			text = tacticName,
			border = 1,
		})
		_frmNode.childUI["TacticCardName"].handle.s:setColor(ccc3(255, 255, 0))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardName"
		
		--分支：等级大于0的战术技能卡显示等级，等级为0的战术技能卡显示未获得
		if (tacticLv > 0) then --已获得
			--显示战术技能卡“等级”文字
			_frmNode.childUI["TacticCardLvPrefix"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 190,
				y = FONT_OFFSET_Y,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 340,
				--text = "等级", --language
				text = hVar.tab_string["__Attr_Hint_Lev"], --language
				border = 1,
			})
			_frmNode.childUI["TacticCardLvPrefix"].handle.s:setColor(ccc3(255, 255, 128))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardLvPrefix"
			
			--显示战术技能卡的等级数值
			--显示不超过最大等级
			local showTacticLv = tacticLv
			local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
			if (showTacticLv > maxLv) then
				showTacticLv = maxLv
			end
			_frmNode.childUI["TacticCardLvValue"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 260,
				y = FONT_OFFSET_Y - 1,
				size = 24,
				font = "numWhite",
				align = "LC",
				width = 340,
				text = showTacticLv,
				--border = 1,
			})
			_frmNode.childUI["TacticCardLvValue"].handle.s:setColor(ccc3(255, 255, 128))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardLvValue"
		else --未获得
			--显示战术技能卡“未获得”文字
			_frmNode.childUI["TacticCardUnGet"] = hUI.label:new({
				parent = _parentNode,
				x = FONT_OFFSET_X + 190,
				y = FONT_OFFSET_Y,
				size = 26,
				font = hVar.FONTC,
				align = "LC",
				width = 340,
				--text = "未获得", --language
				text = hVar.tab_string["CurrentNotGet"], --language=
				border = 1,
			})
			_frmNode.childUI["TacticCardUnGet"].handle.s:setColor(ccc3(255, 0, 0))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardUnGet"
		end
		
		--[[
		--显示战术技能卡当前等级效果的背景图
		_frmNode.childUI["TacticCardSkillBG"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:Tactic_IntroBG",
			x = FONT_OFFSET_X + 183,
			y = FONT_OFFSET_Y - 85,
			w = 366,
			h = 130,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardSkillBG"
		]]
		
		--显示战术技能卡“当前效果”的文字
		local currentLvEffectText = nil
		--分支：等级大于0的战术技能卡显示等级，等级为0的战术技能卡显示未获得
		if (tacticLv > 0) then --已获得
			--currentLvEffectText = "当前效果" --language
			currentLvEffectText = hVar.tab_string["CurrentEffect"] --language
		else --未获得
			--currentLvEffectText = "解锁后效果" --language
			currentLvEffectText = hVar.tab_string["UnLockEffect"] --language
		end
		_frmNode.childUI["TacticCardIntroPrefix"] = hUI.label:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + 15,
			y = FONT_OFFSET_Y - 45,
			size = 28,
			font = hVar.FONTC,
			align = "LC",
			width = 340,
			text = currentLvEffectText,
			border = 1,
		})
		_frmNode.childUI["TacticCardIntroPrefix"].handle.s:setColor(ccc3(0, 255, 0))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardIntroPrefix"
		
		--显示战术技能卡的本级效果
		_frmNode.childUI["TacticCardIntro"] = hUI.label:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + 15,
			y = FONT_OFFSET_Y - 58,
			size = 26,
			font = hVar.FONTC,
			align = "LT",
			width = 340,
			text = tacticIntro,
			border = 1,
		})
		if (tacticLv <= 0) then --未获得
			--暗淡当前效果的标题
			_frmNode.childUI["TacticCardIntroPrefix"].handle.s:setColor(ccc3(212, 0, 0))
			
			--暗淡当前效果的说明
			_frmNode.childUI["TacticCardIntro"].handle.s:setColor(ccc3(168, 168, 168))
		end
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardIntro"
		
		--只有获得该战术技能卡，才会显示升级后的对比效果
		if (tacticLv > 0) then --已获得
			--显示下一级升级的动态箭头
			_frmNode.childUI["TacticCardLvUpJianTou"] = hUI.image:new({
				parent = _parentNode,
				--model = "ICON:image_jiantouV",
				model = "UI:Tactic_RPointer",
				x = FONT_OFFSET_X + 176,
				y = FONT_OFFSET_Y - 167,
				w = 30, --32
				h = 20, --28
				align = "MC",
			})
			_frmNode.childUI["TacticCardLvUpJianTou"].handle._n:setRotation(90)
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardLvUpJianTou"
			
			local tacticLvMax = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1 --战术技能卡的最大等级
			if (showTacticLv >= tacticLvMax) then --战术技能卡已升到顶级
				--战术技能卡已到顶级的文字
				_frmNode.childUI["TacticCardIntroToTop"] = hUI.label:new({
					parent = _parentNode,
					x = FONT_OFFSET_X + 116,
					y = FONT_OFFSET_Y - 45 - 155,
					size = 28,
					font = hVar.FONTC,
					align = "LC",
					width = 340,
					--text = "已到顶级", --language
					text = hVar.tab_string["UpToMaxLv"], --language
					border = 1,
				})
				_frmNode.childUI["TacticCardIntroToTop"].handle.s:setColor(ccc3(255, 64, 0))
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardIntroToTop"
			else --可以升级
				--[[
				--显示战术技能卡下一等级效果的背景图
				_frmNode.childUI["TacticCardSkillNextBG"] = hUI.image:new({
					parent = _parentNode,
					model = "UI:Tactic_IntroBG",
					x = FONT_OFFSET_X + 183,
					y = FONT_OFFSET_Y - 85 - 165,
					w = 366,
					h = 130,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardSkillNextBG"
				]]
				
				--显示战术技能卡“下一等级效果”的文字
				_frmNode.childUI["TacticCardIntroNextPrefix"] = hUI.label:new({
					parent = _parentNode,
					x = FONT_OFFSET_X + 15,
					y = FONT_OFFSET_Y - 45 - 165,
					size = 28,
					font = hVar.FONTC,
					align = "LC",
					width = 340,
					--text = "下一等级效果", --language
					text = hVar.tab_string["NextLvEffect"], --language
					border = 1,
				})
				_frmNode.childUI["TacticCardIntroNextPrefix"].handle.s:setColor(ccc3(0, 212, 0))
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardIntroNextPrefix"
				
				--显示战术技能卡的下一等级效果
				_frmNode.childUI["TacticCardIntroNext"] = hUI.label:new({
					parent = _parentNode,
					x = FONT_OFFSET_X + 15,
					y = FONT_OFFSET_Y - 58 - 165,
					size = 26,
					font = hVar.FONTC,
					align = "LT",
					width = 340,
					text = hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][showTacticLv + 2] or ("未知战术技能卡说明" .. tacticId),
					border = 1,
				})
				_frmNode.childUI["TacticCardIntroNext"].handle.s:setColor(ccc3(168, 168, 168))
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "TacticCardIntroNext"
			end
		end
		
		--升级战术技能卡需要的碎片数量
		local costDebris = 0 --需要的碎片数量
		--local nowDebris = 0 --当前的碎片数量
		local costScore = 0 --需要的积分
		local nowScore = LuaGetPlayerScore() --当前的积分
		local itemId = 0 --商品道具id
		--local tacticInfo = LuaGetPlayerTacticById(tacticId)
		--if tacticInfo then
		--	local id, lv, num = unpack(tacticInfo)
		--	nowDebris = num --当前的碎片数量
		--end
		
		--geyachao: x3说不管等级有没有满，都会填写下一级的数据，有问题找x3
		--if (tacticLv < hVar.TACTIC_LVUP_INFO.maxTacticLv) then
			local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO[tacticLv]
			costDebris = tacticLvUpInfo.costDebris or 0 --需要的碎片数量
			local shopItemId = tacticLvUpInfo.shopItemId or 0
			local tabShopItem = hVar.tab_shopitem[shopItemId]
			if tabShopItem then
				--costRmb = tabShopItem.rmb or 0
				costScore = tabShopItem.score or 0 --需要的积分
				itemId = tabShopItem.itemID or 0 --商品道具id
			end
		--else --到顶级了
			--
		--end
		
		--升级需要的战术技能卡图标
		_frmNode.childUI["RequireCardIcon"] = hUI.image:new({
			parent = _parentNode,
			model = hVar.tab_tactics[tacticId].icon,
			x = FONT_OFFSET_X + 30,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
			w = 36,
			h = 36,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireCardIcon"
		
		--碎片图标
		_frmNode.childUI["DebrisIcon"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:SoulStoneFlag",
			x = FONT_OFFSET_X + 39,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 281,
			w = 30,
			h = 40,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "DebrisIcon"
		
		--碎片进度条
		local progressV = nowDebris / costDebris * 100 --进度
		if (tacticLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果战术技能卡到顶级了
			progressV = 0
		end
		_frmNode.childUI["rightBarSoulStoneExp"] = hUI.valbar:new({
			parent = _parentNode,
			x = FONT_OFFSET_X + 55,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 277,
			w = 150,
			h = 25,
			align = "LC",
			back = {model = "UI:SoulStoneBarBg1", x = -4, y = 0, w = 150 + 7, h = 34},
			model = "UI:SoulStoneBar1",
			--model = "misc/progress.png",
			v = progressV,
			max = 100,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "rightBarSoulStoneExp"
		
		--创建一个进度条满了的特别进度条
		if (tacticLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果战术技能卡到顶级了
			_frmNode.childUI["rightBarSoulStoneExpMaxLv"] = hUI.image:new({
				parent = _parentNode,
				model = "misc/jdt2.png", --"UI:IMG_ValueBarBoss",
				x = FONT_OFFSET_X + 55 + (150) / 2,
				y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 277,
				w = 150,
				h = 25,
				align = "LC",
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "rightBarSoulStoneExpMaxLv"
		end
		
		--战术技能卡
		--升级需要的碎片的数量文字
		local showNumText = nowDebris .. "/" .. costDebris
		local tacticFont = "numWhite"
		local tacticColor = ccc3(255, 255, 255)
		local tacticBorder = 0
		if (tacticLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果战术技能卡到顶级了
			--showNumText = "无" --language
			--showNumText = hVar.tab_string["__TEXT_Nothing"] --language
			--tacticFont = hVar.FONTC
			tacticColor = ccc3(255, 64, 0)
			--tacticBorder = 1
		end
		--local showNumText = "49999/500000"
		local scaleText = 1.0
		local showTextLength = #showNumText
		if (showTextLength > 11) then --如果长度大于11，只能缩小文字(12~...个字)
			scaleText = 0.56
		elseif (showTextLength > 9) then --如果长度大于9，只能缩小文字(10~11个字)
			scaleText = 0.64
		elseif (showTextLength > 7) then --如果长度大于7，只能缩小文字(8~9个字)
			scaleText = 0.8
		else --可以显示下
			scaleText = 1.0
		end
		_frmNode.childUI["DebrisNum"] = hUI.label:new({
			parent = _parentNode,
			size = 24,
			x = FONT_OFFSET_X + 128,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 278,
			w = 300,
			align = "MC",
			font = tacticFont,
			text = showNumText,
			border = tacticBorder,
			scale = scaleText,
		})
		_frmNode.childUI["DebrisNum"].handle.s:setColor(tacticColor)
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "DebrisNum"
		
		--升级需要的积分图标
		_frmNode.childUI["RequireScoreIcon"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:score",
			x = FONT_OFFSET_X + 260,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
			w = 32,
			h = 32,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireScoreIcon"
		
		--战术技能卡
		--升级需要的积分的数量文字
		local showJFText = tostring(costScore)
		local JFFont = "numWhite"
		local JFColor = ccc3(255, 255, 255)
		local JFBorder = 0
		if (tacticLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果战术技能卡到顶级了
			showJFText = "无" --language
			showJFText = hVar.tab_string["__TEXT_Nothing"] --language
			JFFont = hVar.FONTC
			--showJFText = "N/A"
			JFColor = ccc3(255, 64, 0)
			JFBorder = 1
		end
		--local showJFText = "499999"
		local scaleJFText = 1.0
		local showJFTextLength = #showJFText
		if (showJFTextLength > 7) then --如果长度大于7，只能缩小文字(8个字)
			scaleJFText = 0.7
		elseif (showJFTextLength > 5) then --如果长度大于5，只能缩小文字(6~7个字)
			scaleJFText = 0.8
		elseif (showJFTextLength > 4) then --如果长度大于4，只能缩小文字(5个字)
			scaleJFText = 0.9
		else --可以显示下
			scaleJFText = 1.0
		end
		_frmNode.childUI["ScoreNum"] = hUI.label:new({
			parent = _parentNode,
			size = 24,
			x = FONT_OFFSET_X + 280,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 279,
			w = 300,
			align = "LC",
			font = JFFont,
			text = showJFText,
			border = JFBorder,
			scale = scaleJFText,
		})
		_frmNode.childUI["ScoreNum"].handle.s:setColor(JFColor)
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "ScoreNum"
		
		--事件响应控件
		--碎片用于点击的区域
		_frmNode.childUI["RequireCardTouchBtn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = FONT_OFFSET_X + 110,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
			w = 220,
			h = 68,
			scaleT = 1.0,
			--[[
			failcall = 1,
			
			--按下碎片图标区域事件，显示碎片说明
			codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
				local __parent = _frmNode.childUI["RequireCardTouchBtn"]
				local __parentHandle = __parent.handle._n
				local offset = 75
				local yOffset = 100
				
				--选中框
				__parent.childUI["box"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:Tactic_Selected",
					x = -80,
					y = 0,
					w = 36,
					h = 36,
					align = "MC",
				})
				
				--碎片背景框
				__parent.childUI["imgBg"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:TacticBG", --"UI:ExpBG",
					x = offset,
					y = yOffset,
					w = 380,
					h = 110,
					align = "MC",
				})
				__parent.childUI["imgBg"].handle.s:setOpacity(204) --碎片背景图片透明度为204
				
				--图标
				__parent.childUI["imgIcon"] = hUI.image:new({
					parent = __parentHandle,
					model = hVar.tab_tactics[tacticId].icon,
					x = offset - 148,
					y = yOffset - 2,
					w = 64,
					h = 64,
					align = "MC",
				})
				
				--碎片图标
				__parent.childUI["imgSoleStone"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:SoulStoneFlag",
					x = offset - 148 + 20,
					y = yOffset - 17,
					w = 40,
					h = 54,
					align = "MC",
				})
				
				--碎片名称
				local name = hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][1] or ("未知战术技能卡" .. tacticId)
				__parent.childUI["labName"] = hUI.label:new({
					parent = __parentHandle,
					size = 30,
					align = "LT",
					border = 1,
					x = offset - 110,
					y = yOffset + 43,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					--text = name .. "卡碎片", --language
					text = name .. hVar.tab_string["Card"] .. hVar.tab_string["__TEXT_ITEM_TYPE_TACTICDEBRIS"], --language
				})
				__parent.childUI["labName"].handle.s:setColor(ccc3(196, 255, 196))
				
				--碎片介绍
				--local intro = "升级" .. name .. "卡需要消耗一定数量的该碎片。" --language
				local intro = hVar.tab_string["__UPGRADE"] .. name .. hVar.tab_string["Card"] .. hVar.tab_string["RequireCostSomeDebris"] --language
				__parent.childUI["labIntro"] = hUI.label:new({
					parent = __parentHandle,
					size = 26,
					align = "LT",
					border = 1,
					x = offset - 110,
					y = yOffset + 8,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					text = intro,
				})
				__parent.childUI["labIntro"].handle.s:setColor(ccc3(255, 255, 255))
			end,
			
			--抬起碎片图标区域事件，删除该战术技能卡的说明
			code = function(self)
				local __parent = _frmNode.childUI["RequireCardTouchBtn"]
				hApi.safeRemoveT(__parent.childUI, "box") --选中框
				hApi.safeRemoveT(__parent.childUI, "imgBg") --技能背景框
				hApi.safeRemoveT(__parent.childUI, "imgIcon") --图标
				hApi.safeRemoveT(__parent.childUI, "imgSoleStone") --碎片图标
				hApi.safeRemoveT(__parent.childUI, "labName") --碎片名称
				hApi.safeRemoveT(__parent.childUI, "labIntro") --碎片介绍
			end,
			]]
			--抬起碎片图标区域事件，删除该战术技能卡的说明
			code = function(self)
				--显示战术技能卡的tip
				local rewardType = 6 --碎片类型
				local tacticLv = 1
				hApi.ShowTacticCardTip(rewardType, tacticId, tacticLv, tacticId)
			end,
		})
		_frmNode.childUI["RequireCardTouchBtn"].handle.s:setOpacity(0) --需要卡牌的响应点击事件，不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireCardTouchBtn"
		
		--事件响应控件
		--积分用于点击的区域
		_frmNode.childUI["RequireJiFenTouchBtn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = FONT_OFFSET_X + 310,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 275,
			w = 160,
			h = 68,
			scaleT = 1.0,
			--[[
			failcall = 1,
			
			--按下积分图标区域事件，显示碎片说明
			codeOnTouch = function(self,relTouchX,relTouchY,IsInside)
				local __parent = _frmNode.childUI["RequireJiFenTouchBtn"]
				local __parentHandle = __parent.handle._n
				local offset = -125
				local yOffset = 100
				
				--选中框
				__parent.childUI["box"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:Tactic_Selected",
					x = -50,
					y = 0,
					w = 36,
					h = 36,
					align = "MC",
				})
				
				--积分背景框
				__parent.childUI["imgBg"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:TacticBG", --"UI:ExpBG",
					x = offset,
					y = yOffset,
					w = 380,
					h = 110,
					align = "MC",
				})
				__parent.childUI["imgBg"].handle.s:setOpacity(204) --积分背景图片透明度为204
				
				--图标
				__parent.childUI["imgIcon"] = hUI.image:new({
					parent = __parentHandle,
					model = "UI:score",
					x = offset - 148,
					y = yOffset - 2,
					w = 64,
					h = 64,
					align = "MC",
				})
				
				--积分名称
				__parent.childUI["labName"] = hUI.label:new({
					parent = __parentHandle,
					size = 30,
					align = "LT",
					border = 1,
					x = offset - 110,
					y = yOffset + 43,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					--text = "积分", --language
					text = hVar.tab_string["ios_score"], --language
				})
				__parent.childUI["labName"].handle.s:setColor(ccc3(255, 255, 196))
				
				--积分介绍
				local name = hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][1] or ("未知塔" .. tacticId)
				--local intro = "升级" .. name .. "卡需要消耗一定数量的积分。"
				local intro = hVar.tab_string["__UPGRADE"] .. name .. hVar.tab_string["Card"] .. hVar.tab_string["RequireCostSomeJiFen"] --language
				__parent.childUI["labIntro"] = hUI.label:new({
					parent = __parentHandle,
					size = 26,
					align = "LT",
					border = 1,
					x = offset - 110,
					y = yOffset + 8,
					--font = hVar.FONTC,
					font = hVar.FONTC,
					width = 290,
					text = intro,
				})
				__parent.childUI["labIntro"].handle.s:setColor(ccc3(255, 255, 255))
			end,
			
			--抬起积分图标区域事件，删除该战术技能卡的说明
			code = function(self)
				local __parent = _frmNode.childUI["RequireJiFenTouchBtn"]
				hApi.safeRemoveT(__parent.childUI, "box") --选中框
				hApi.safeRemoveT(__parent.childUI, "imgBg") --技能背景框
				hApi.safeRemoveT(__parent.childUI, "imgIcon") --图标
				hApi.safeRemoveT(__parent.childUI, "labName") --积分名称
				hApi.safeRemoveT(__parent.childUI, "labIntro") --积分介绍
			end,
			]]
			--抬起积分图标区域事件，删除该战术技能卡的说明
			code = function(self)
				--显示积分介绍的tip
				hApi.ShowJiFennTip()
			end,
		})
		_frmNode.childUI["RequireJiFenTouchBtn"].handle.s:setOpacity(0) --用于响应事件，不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RequireJiFenTouchBtn"
		
		--战术技能卡升级按钮
		--升级或者解锁战术技能卡的按钮
		--local updateText = "升级" --language
		local updateText = hVar.tab_string["__UPGRADE"] --language
		if (tacticLv == 0) then
			--updateText = "解锁" --language
			updateText = hVar.tab_string["__UNLOCK"] --language
		end
		_frmNode.childUI["btnCostJiFen"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = FONT_OFFSET_X + 190,
			y = FONT_OFFSET_Y - FONT_DELTA_Y * 2 - 360,
			w = 180,
			h = 70,
			--label = updateText,
			--font = hVar.FONTC,
			--border = 1,
			--model = "UI:BTN_ButtonRed",
			model = "panel/panel_menu_btn_big.png", --"UI:BTN_ButtonRed"
			--animation = "normal",
			scaleT = 0.95,
			--scale = 1.0,
			code = function()
				--点击用积分升级战术卡按钮
				if (tacticLv < hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果战术技能卡未到顶级
					OnClickLvUpButton(tacticId, tacticLv, costDebris, nowDebris, costScore, nowScore, itemId)
				end
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnCostJiFen"
		if (tacticLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then --如果战术技能卡已到顶级
			_frmNode.childUI["btnCostJiFen"].handle._n:setVisible(false)
		end
		--积分升级按钮的升级小箭头
		_frmNode.childUI["btnCostJiFen"].childUI["UI_Arrow"] = hUI.image:new({
			parent = _frmNode.childUI["btnCostJiFen"].handle._n,
			model = "UI:jiantou_new",
			x = 0,
			y = 23,
			w = 74,
			h = 74,
		})
		--_frmNode.childUI["btnCostJiFen"].childUI["UI_Arrow"].handle._n:setRotation(-90)
		--名字
		_frmNode.childUI["btnCostJiFen"].childUI["name"] = hUI.label:new({
			parent = _frmNode.childUI["btnCostJiFen"].handle._n,
			font = hVar.FONTC,
			border = 1,
			align = "MC",
			text = updateText,
			x = 0,
			y = -10,
			size = 32,
		})
		
		--如果不符合升级的条件，按钮灰掉
		if (nowDebris < costDebris) or (nowScore < costScore) or (tacticLv >= hVar.TACTIC_LVUP_INFO.maxTacticLv) then
			hApi.AddShader(_frmNode.childUI["btnCostJiFen"].handle.s, "gray")
			hApi.AddShader(_frmNode.childUI["btnCostJiFen"].childUI["UI_Arrow"].handle.s, "gray")
		end
		
		--标记当前选中的项的索引和卡牌id
		CurrentSelectRecord.contentIdx = contentIndex
		CurrentSelectRecord.cardId = tacticId
	end
	
	--函数：更新塔的分页，提示当前哪个子分页可以升级了
	RefreshTowerUpgrateSubPage = function()
		local tTactics = LuaGetPlayerSkillBook()
		local nowScore = LuaGetPlayerScore() --当前的积分
		
		--不存在战术技能卡，直接返回
		if (not tTactics) then
			return
		end
		
		local pageNoteResult = {} --每个分页是否需要提示升级的表
		for i = 1, 5, 1 do
			pageNoteResult[i] = false --默认都不需要提示升级
		end
		
		--遍历所有的战术技能卡
		for i = 1, #tTactics, 1 do
			if (type(tTactics[i]) == "table") then
				local id, lv, num = unpack(tTactics[i])
				--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
				
				--存在表项
				if hVar.tab_tactics[id] then
					local type = hVar.tab_tactics[id].type --战术技能卡类型
					if (type == hVar.TACTICS_TYPE.OTHER) or (type == hVar.TACTICS_TYPE.TOWER)  or (type == hVar.TACTICS_TYPE.SPECIAL) then --只处理塔类战术技能卡、一般战术技能卡、特种塔
						--升级战术技能卡需要的碎片数量
						local tacticLv = lv --战术技能卡的等级
						local costDebris = 0 --需要的碎片数量
						local nowDebris = num --当前的碎片数量
						local costScore = 0 --需要的积分
						
						--未升满级
						if (tacticLv < hVar.TACTIC_LVUP_INFO.maxTacticLv) then
							local tacticLvUpInfo = hVar.TACTIC_LVUP_INFO[tacticLv]
							costDebris = tacticLvUpInfo.costDebris or 0 --需要的碎片数量
							local shopItemId = tacticLvUpInfo.shopItemId or 0
							local tabShopItem = hVar.tab_shopitem[shopItemId]
							if tabShopItem then
								--costRmb = tabShopItem.rmb or 0
								costScore = tabShopItem.score or 0 --需要的积分
								
								--积分、碎片数量都符合，并且等级未到顶级
								if (nowDebris >= costDebris) and (nowScore >= costScore) and (tacticLv < hVar.TACTIC_LVUP_INFO.maxTacticLv) then
									--可以升级了，检测这个属于哪个分页的卡牌
									--检测分页1：箭塔分支
									for i = 1, #archyTacticCardList_jianta, 1 do
										if (archyTacticCardList_jianta[i] == id) then
											pageNoteResult[1] = true --分页1：箭塔分页是否提示
										end
									end
									
									--检测分页2：法术塔分支
									for i = 1, #archyTacticCardList_fashu, 1 do
										if (archyTacticCardList_fashu[i] == id) then
											pageNoteResult[2] = true --分页2：法术塔分页是否提示
										end
									end
									
									--检测分页3：炮塔分支
									for i = 1, #archyTacticCardList_paota, 1 do
										if (archyTacticCardList_paota[i] == id) then
											pageNoteResult[3] = true --分页3：炮塔分页是否提示
										end
									end
									
									--检测分页4：特种塔分支
									if (type == hVar.TACTICS_TYPE.SPECIAL) then
										pageNoteResult[4] = true --分页4：特种塔分页是否提示
									end
									
									--检测分页5：一般战术技能卡
									if (type == hVar.TACTICS_TYPE.OTHER) then
										pageNoteResult[5] = true --分页5：一般战术技能卡分页是否提示
									end
								end
							end
						else --到顶级了
							--
						end
						
					end
				end
			end
		end
		
		--全部遍历完毕
		--更新绘制
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		for i = 1, 5, 1 do
			if _frmNode.childUI["SubPageBtn" .. i] then
				_frmNode.childUI["SubPageBtn" .. i].childUI["NoteJianTou"].handle.s:setVisible(pageNoteResult[i]) --是否显示提示该分页升级的动态箭头
			end
		end
		
		return pageNoteResult
	end
	
	--函数：更新绘制当前查看的卡牌的信息
	RefreshSelectedCardFrame = function()
		--print("--函数：更新绘制当前查看的卡牌的信息", CurrentSelectRecord.pageIdx)
		--如果当前未选中分页，不需要更新绘制
		--print("CurrentSelectRecord.pageIdx=", CurrentSelectRecord.pageIdx)
		if (CurrentSelectRecord.pageIdx == 0) then
			return
		end
		
		--重新绘制该分页
		local pageIndex = CurrentSelectRecord.pageIdx
		local subPageIndex = CurrentSelectRecord.subPageIdx
		local contentIdx = CurrentSelectRecord.contentIdx
		local cardId = CurrentSelectRecord.cardId
		CurrentSelectRecord.pageIdx = 0
		--CurrentSelectRecord.subPageIdx = 0
		CurrentSelectRecord.contentIdx = 0
		CurrentSelectRecord.cardId = cardId
		--print("更新绘制当前查看的卡牌的信息", pageIndex, subPageIndex, contentIdx, cardId)
		--重新绘制该分页
		OnClickPageBtn(pageIndex) --重绘当前分页
		--print("OnClickPageBtn", pageIndex, contentIdx, cardId)
		
		--如果当前未选中页面内的卡牌索引，不需要更新绘制
		if (contentIdx == 0) then
			return
		end
		
		--如果当前未选中卡牌，不需要更新绘制
		if (cardId == 0) then
			return
		end
		
		--选中该卡牌
		if (pageIndex == 3) then --分页3: 塔
			if (subPageIndex == 1) or (subPageIndex == 2) or (subPageIndex == 3) then --塔的子分页
				--点击塔的按钮
				OnClickTowerBtn(subPageIndex, contentIdx)
			elseif (subPageIndex == 4) then --特种塔子分页
				--点击特种塔的按钮
				--geyachao: 对于特种塔要特殊处理，因为可能升级后，新解锁卡牌，排序发生了变化，这里以cardId为准，重新找contentIdx
				contentIdx = CalSpecialCardIndex(cardId)
				OnClickSpecialTowerBtn(subPageIndex, contentIdx)
			end
		elseif (pageIndex == 4) then --分页4: 战术技能卡
			--点击战术技能卡的按钮
			--geyachao: 对于战术技能卡要特殊处理，因为可能升级后，新解锁卡牌，排序发生了变化，这里以cardId为准，重新找contentIdx
			contentIdx = CalTacticCardIndex(cardId)
			OnClickTacticBtn(pageIndex, contentIdx)
		end
	end
	
	-------------------------------------------
	--函数：更新提示当前哪个分页可以升级了
	RefreshGuideUpgratePage = function()
		--print("更新提示当前哪个分页可以升级了")
		
		--分页1: 英雄令
		local bCanUpdateHeroCard = hApi.IsEnableUpgrateHeroSkill() --是否可以升级英雄卡
		_frm.childUI["PageBtn1"].childUI["NoteJianTou"].handle.s:setVisible(bCanUpdateHeroCard) --是否显示提示该分页升级的动态箭头
		RefreshHeroCardUpgrateSubPage() --刷新英雄卡分页每个卡牌是否可升级提示箭头
		
		--分页2: 神器
		--local bCanUpdateTuJian = false --是否可以升级
		--_frm.childUI["PageBtn2"].childUI["NoteJianTou"].handle.s:setVisible(bCanUpdateTuJian) --是否显示提示该分页升级的动态箭头
		
		--分页3: 塔
		local pageNoteResult = RefreshTowerUpgrateSubPage()
		local bCanUpdateTower = pageNoteResult[1] or pageNoteResult[2] or pageNoteResult[3] or pageNoteResult[4] --是否可以升级塔
		_frm.childUI["PageBtn3"].childUI["NoteJianTou"].handle.s:setVisible(bCanUpdateTower) --是否显示提示该分页升级的动态箭头
		
		--分页4: 一般战术卡
		--local pageNoteResult = RefreshTowerUpgrateSubPage()
		local bCanUpdateTactic = pageNoteResult[5] --是否可以升级一般战术卡
		_frm.childUI["PageBtn4"].childUI["NoteJianTou"].handle.s:setVisible(bCanUpdateTactic) --是否显示提示该分页升级的动态箭头
	end
	
	--通过订单系统 战术技能卡升级
	hGlobal.event:listen("localEvent_afterTacticLvUpSucceed", "_TacticSkillLvUp", function(overage, strTag, order_id)
		--print("localEvent_afterTacticLvUpSucceed", overage, strTag, order_id)
		
		hUI.NetDisable(0)
		
		local ret = false
		local strRet = hVar.tab_string["ios_err_unknow"]
		
		--保留字符串 如果存在 则进行解析 这块功能必须要等外网服务器更新以后才能生效
		--local strTag = "hi:"..nHeroId..";si:"..skillId..";st:"..type..";sp:"..idx..";sc:"..costScore..";"
		if type(strTag) == "string" and string.find(strTag,"ci:") and string.find(strTag,"sc:") then
			local tempStr = {}
			for strTag in string.gfind(strTag,"([^%;]+);+") do
				tempStr[#tempStr+1] = strTag
			end
			
			--卡牌Id
			local cardId = tonumber(string.sub(tempStr[1],string.find(tempStr[1],"ci:")+3,string.len(tempStr[1])))
			--升级消耗材料
			local costDebris = tonumber(string.sub(tempStr[2],string.find(tempStr[2],"cd:")+3,string.len(tempStr[2])))
			--升级积分消耗
			local cost = tonumber(string.sub(tempStr[3],string.find(tempStr[3],"sc:")+3,string.len(tempStr[3])))
			
			--local retex = LuaAddPlayerTacticDebris(cardId,-costDebris) --错误流程
			local retex = LuaLvUpPlayerTactic(cardId)
			--print("retex=", retex)
			if (retex == 1) then
				ret = true
				--扣除积分
				LuaAddPlayerScore(-cost)
				LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
				
				--播放升级战术技能卡的音效
				hApi.PlaySound("getcard")
				
				--geyachao: 如果玩家升级了战术技能卡，那么就认为战术技能卡界面的引导完成
				--标记主城引导战术技能卡界面完成
				LuaSetPlayerGuideState(g_curPlayerName, "town/town_mainmenu", 6)
				
				--更新当前选中的战术技能卡(塔)分页界面
				RefreshSelectedCardFrame()
				
				--更新提示当前哪个分页可以升级了
				RefreshGuideUpgratePage()
			else
				ret = false
				--卡牌不存在
				if retex == 2 then
					strRet = hVar.tab_string["ios_err_unknow"]
				--等级已满
				elseif retex == 3 then
					strRet = hVar.tab_string["__UPGRADEBFSKILL_CANT"]
				--碎片不足
				elseif retex == 4 then
					strRet = hVar.tab_string["tactic_lessDebris"]
				end
			end
		else
			strRet = hVar.tab_string["ios_err_unknow"]
		end
		
		if (not ret) then
			--弹框
			hGlobal.UI.MsgBox(strRet,{
				font = hVar.FONTC,
				ok = function()
				end,
			})
		end
	end)
	
	--购买失败
	hGlobal.event:listen("LocalEvent_BuyItemfail", "__TacticLvUpClearLock", function(result, nItemID)
		--收到消息后解除购买锁
		--如果技能升级失败，解除按钮锁定
		hUI.NetDisable(0)
	end)
	
	--网络断开
	hGlobal.event:listen("LocalEvent_Set_activity_refresh", "__TacticLvUpClearLock", function(connect_state)
		--如果断开网络则恢复不可使用锻造状态
		if (connect_state == -1) then
			hUI.NetDisable(0)
		end
	end)
	
	--监听打开英雄令、图鉴、神器、塔、战术卡事件
	hGlobal.event:listen("LocalEvent_Phone_ShowMyHerocard", "__ShowPhoneMyHerocar", function()
		--步骤1: 绘制第一个分页，并将控件设置成初始位置（屏幕外，为步骤二播放动画做准备）
		local actM1 = CCCallFunc:create(function()
			--触发事件，显示游戏币界面
			hGlobal.event:event("LocalEvent_ShowGameCoinFrm", "fullscreen")
			
			--显示新的英雄令、图鉴、神器、塔界面
			hGlobal.UI.Phone_MyHeroCardFrm_New:show(1)
			hGlobal.UI.Phone_MyHeroCardFrm_New:active()
			
			--打开上次分页（默认显示第一个分页）
			local lastPageIdx = CurrentSelectRecord.pageIdx
			if (lastPageIdx == 0) then
				lastPageIdx = 1
			end
			CurrentSelectRecord.pageIdx = 0
			CurrentSelectRecord.contentIdx = 0
			OnClickPageBtn(lastPageIdx, false)
			
			--更新提示当前哪个分页可以升级了
			RefreshGuideUpgratePage()
			
			--初始设置坐标
			--主面板设置到左侧屏幕外面
			local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
			_frm:setXY(-hVar.SCREEN.w, hVar.SCREEN.h)
			
			--主界面顶部栏到上侧屏幕外面
			_frm.childUI["menu_top"]:setXY(hVar.SCREEN.w / 2, 100 * _ScaleH / 2)
			
			--主界面底部栏到下侧屏幕外面
			_frm.childUI["menu_bottom2"]:setXY(hVar.SCREEN.w / 2, -hVar.SCREEN.h - 125 * _ScaleH / 2)
			
			--按钮到下侧屏幕外面
			for i = 1, #tPageIcons, 1 do
				local px, py = _frm.childUI["PageBtn" .. i].data.x, _frm.childUI["PageBtn" .. i].data.y
				_frm.childUI["PageBtn" .. i]:setXY(px, -hVar.SCREEN.h - 114 / 2 * _ScaleH)
			end
		end)
		
		--步骤2: 动画进入控件
		local actM2 = CCCallFunc:create(function()
			--本面板
			local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
			
			--往左做运动
			local px, py = _frm.data.x, _frm.data.y
			local act1 = CCDelayTime:create(0.01)
			local act2 = CCEaseSineIn:create(CCMoveTo:create(0.18, ccp(0, py)))
			local act4 = CCCallFunc:create(function()
				--_frm.data.x = 0
				_frm:setXY(0, py)
			end)
			local a = CCArray:create()
			a:addObject(act1)
			a:addObject(act2)
			a:addObject(act4)
			local sequence = CCSequence:create(a)
			_frm.handle._n:stopAllActions() --先停掉之前可能的动画
			_frm.handle._n:runAction(sequence)
			
			--主界面顶部栏往下做运动
			local px, py = _frm.childUI["menu_top"].data.x, _frm.childUI["menu_top"].data.y
			local act1 = CCDelayTime:create(0.20)
			local act2 = CCEaseSineIn:create(CCMoveTo:create(0.18, ccp(px, -60 * _ScaleH / 2)))
			local act4 = CCCallFunc:create(function()
				--_frm.childUI["menu_top"].data.y = -60 * _ScaleH / 2
				_frm.childUI["menu_top"]:setXY(px, -60 * _ScaleH / 2)
			end)
			local a = CCArray:create()
			a:addObject(act1)
			a:addObject(act2)
			a:addObject(act4)
			local sequence = CCSequence:create(a)
			_frm.childUI["menu_top"].handle._n:stopAllActions() --先停掉之前可能的动画
			_frm.childUI["menu_top"].handle._n:runAction(sequence)
			
			--主界面底部栏往上做运动
			local px, py = _frm.childUI["menu_bottom2"].data.x, _frm.childUI["menu_bottom2"].data.y
			local act1 = CCDelayTime:create(0.20)
			local act2 = CCEaseSineIn:create(CCMoveTo:create(0.18, ccp(px, -hVar.SCREEN.h + 84 * _ScaleH / 2)))
			local act4 = CCCallFunc:create(function()
				--_frm.childUI["menu_bottom2"].data.y = -hVar.SCREEN.h + 84 * _ScaleH / 2
				_frm.childUI["menu_bottom2"]:setXY(px, -hVar.SCREEN.h + 84 * _ScaleH / 2)
			end)
			local a = CCArray:create()
			a:addObject(act1)
			a:addObject(act2)
			a:addObject(act4)
			local sequence = CCSequence:create(a)
			_frm.childUI["menu_bottom2"].handle._n:stopAllActions() --先停掉之前可能的动画
			_frm.childUI["menu_bottom2"].handle._n:runAction(sequence)
			
			--按钮往上做运动
			for i = 1, #tPageIcons, 1 do
				local px, py = _frm.childUI["PageBtn" .. i].data.x, _frm.childUI["PageBtn" .. i].data.y
				local act1 = CCDelayTime:create(0.20 + 0.03 * i)
				local act2 = CCEaseSineIn:create(CCMoveTo:create(0.18, ccp(px, -hVar.SCREEN.h + 84 * _ScaleH / 2)))
				local act4 = CCCallFunc:create(function()
					--_frm.childUI["PageBtn" .. i].data.y = -hVar.SCREEN.h + 84 * _ScaleH / 2
					_frm.childUI["PageBtn" .. i]:setXY(px, -hVar.SCREEN.h + 84 * _ScaleH / 2)
				end)
				local a = CCArray:create()
				a:addObject(act1)
				a:addObject(act2)
				a:addObject(act4)
				local sequence = CCSequence:create(a)
				_frm.childUI["PageBtn" .. i].handle._n:stopAllActions() --先停掉之前可能的动画
				_frm.childUI["PageBtn" .. i].handle._n:runAction(sequence)
			end
		end)
		
		local aM = CCArray:create()
		aM:addObject(actM1)
		aM:addObject(actM2)
		local sequence = CCSequence:create(aM)
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
		_frm.handle._n:stopAllActions() --先停掉之前可能的动画
		_frm.handle._n:runAction(sequence)
	end)
end
--test
--[[
--测试代码
if hGlobal.UI.Phone_MyHeroCardFrm_New then --删除上一次的英雄令、图鉴面板
	hGlobal.UI.Phone_MyHeroCardFrm_New:del()
	hGlobal.UI.Phone_MyHeroCardFrm_New = nil
end
hGlobal.UI.InitHeroCardFrm_New() --测试创建英雄令、图鉴界面
--触发事件，显示英雄令、图鉴、神器、塔、战术卡界面
hGlobal.event:event("LocalEvent_Phone_ShowMyHerocard", 1)
--LuaAddPlayerTacticDebris(1023, 100) --测试加碎片
--LuaAddPlayerScore(100) --测试加积分
]]

