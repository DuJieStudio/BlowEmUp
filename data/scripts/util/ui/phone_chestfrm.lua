


local _ScaleW = 1
local _ScaleH = 1

--iPhoneX黑边宽
local iPhoneX_WIDTH = 0
if (g_phone_mode == 4) then --iPhoneX
	iPhoneX_WIDTH = 80
end

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

local PAGE_BTN_LEFT_X = 120 --第一个分页按钮的x偏移
local PAGE_BTN_LEFT_Y = -23 --第一个分页按钮的y偏移
local PAGE_BTN_OFFSET_X = 140 --每个分页按钮的间距

local _nShouldUpdateTactics = 0

--临时UI管理
local leftRemoveFrmList = {} --左侧控件集
local rightRemoveFrmList = {} --右侧控件集
local rightDetailRemoveFrmList = {} --右侧详细信息控件集
local _removeLeftFrmFunc = hApi.DoNothing --清空左侧所有的临时控件
local _removeRightFrmFunc = hApi.DoNothing --清空右侧所有的临时控件
local _removeRightDetailFrmFunc = hApi.DoNothing --清空右侧所有的详细信息临时控件

--局部函数
local OnClosePanel = hApi.DoNothing --关闭本界面
local OnClickPageBtn = hApi.DoNothing --点击分页按钮
--local RefreshBillboardFinishPage = hApi.DoNothing --更新提示当前哪个分页可以有领取的了

--分页1：排行榜函数部分
local OnCreateRankBoardFrame_PVP_Endless = hApi.DoNothing --创建排行榜界面（第1个分页）
local OnRefreshTreasureDetail = hApi.DoNothing --显示某个指定的宝物详细界面
local getUpDownOffset = hApi.DoNothing --获得第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离
local OnCreateSingleTreasureData_PVP = hApi.DoNothing --绘制单条排行榜的信息
local OnCreateSingleTreasureData_PVP_async = hApi.DoNothing --异步绘制单条排行榜的信息（异步）
--local on_receive_ping_event_PVP_Endless = hApi.DoNothing --收到pvp的ping值回调
--local on_receive_connect_back_event_PVP_Endless = hApi.DoNothing --收到连接结果回调
--local on_receive_login_back_event_PVP_Endless = hApi.DoNothing --收到登入结果回调
local on_receive_refresh_systime_event_chest = hApi.DoNothing --收到获得系统时间的回调
local on_receive_treasure_event_chest = hApi.DoNothing --收到资源信息数据的回调
local on_receive_open_cangbaotu_event_chest = hApi.DoNothing --收到兑换藏宝图的回调
local on_receive_open_chest_event = hApi.DoNothing --收到宝物升星操作结果的回调
--local on_receive_treasure_attr_update_Treasure = hApi.DoNothing --收到玩家宝物属性位值更新结果
local on_enter_background_event_Treasure = hApi.DoNothing --收到程序进入后台的回调
local on_SpinScreen_event_chest = hApi.DoNothing --横竖屏切换事件
--local on_query_billboard_info_timer_PVP_Endless = hApi.DoNothing --定时向服务器查询当前的排行数据
--local OnCreateTreasureLvUpFrame = hApi.DoNothing --函数：创建宝物升级操作界面
local refresh_rank_board_UI_loop_RZWD = hApi.DoNothing --刷新排行榜界面的滚动
local refresh_rank_board_UI_loop_RZWD_async = hApi.DoNothing --异步刷新排行榜界面的滚动（异步）
local __DynamicAddRes = hApi.DoNothing --动态加载资源
local __DynamicRemoveRes = hApi.DoNothing --动态删除资源

--分页1：排行榜相关参数
local BILLBOARD_WIDTH = 200 --排行榜宽度
local BILLBOARD_HEIGHT = 180 --排行榜高度
local BILLBOARD_OFFSETX = 210 --排行榜第一个元素距离左侧的x偏移
local BILLBOARD_OFFSETY = -210 --排行榜第一个元素距离左侧的y偏移
local BILLBOARD_DISTANCEX = 10 --排行榜x间距
local BILLBOARD_DISTANCEY = 10 --排行榜y间距
local BILLBOARD_X_NUM = 3 --排行榜xn的数量
local BILLBOARD_Y_NUM = 3 --排行榜yn的数量
if (g_phone_mode == 1) then --iPhone4
	--
elseif (g_phone_mode == 2) then --iPhone5
	--
elseif (g_phone_mode == 3) then --iPhone6, iPhone7, iPhone8
	--
elseif (g_phone_mode == 4) then --iPhoneX
	--
elseif (g_phone_mode == 5) then --安卓宽屏
	--
elseif (g_phone_mode == 6) then --平板宽屏
	--
end

--横屏模式
if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
	BILLBOARD_OFFSETX = 260 --排行榜第一个元素距离左侧的x偏移
end

--[[
local BILLBOARD_DESK_INDEX1 = 1 --第一个需要绘制台子的索引值
local BILLBOARD_DESK_INDEX2 = 3 --第二个需要绘制台子的索引值
local BILLBOARD_DESK_DISTANCEX2 = 60 --第二个台子距离远速的x偏移
local BILLBOARD_DESK_IMG1 = "misc/treasure/medal_desk2.png" --第一个台子的图片
local BILLBOARD_DESK_IMG2 = "misc/treasure/medal_desk2.png" --第二个台子的图片
local BILLBOARD_DESK_OFFSET_X1 = 90 --第一个台子的偏移x
local BILLBOARD_DESK_OFFSET_X2 = 90 --第二个台子的偏移x
if (g_phone_mode == 1) then --iPhone4
	--
elseif (g_phone_mode == 2) then --iPhone5
	--
elseif (g_phone_mode == 3) then --iPhone6, iPhone7, iPhone8
	BILLBOARD_DESK_INDEX1 = 1
	BILLBOARD_DESK_INDEX2 = 3
	BILLBOARD_DESK_DISTANCEX2 = 30
	BILLBOARD_DESK_OFFSET_X1 = 90
	BILLBOARD_DESK_OFFSET_X2 = 90
	BILLBOARD_DESK_IMG1 = "misc/treasure/medal_desk2.png"
	BILLBOARD_DESK_IMG2 = "misc/treasure/medal_desk2.png"
elseif (g_phone_mode == 4) then --iPhoneX
	BILLBOARD_DESK_INDEX1 = 1
	BILLBOARD_DESK_INDEX2 = 3
	BILLBOARD_DESK_DISTANCEX2 = 40
	BILLBOARD_DESK_OFFSET_X1 = 90
	BILLBOARD_DESK_OFFSET_X2 = 90
	BILLBOARD_DESK_IMG1 = "misc/treasure/medal_desk2.png"
	BILLBOARD_DESK_IMG2 = "misc/treasure/medal_desk2.png"
elseif (g_phone_mode == 5) then --安卓宽屏
	BILLBOARD_DESK_INDEX1 = 1
	BILLBOARD_DESK_INDEX2 = 3
	BILLBOARD_DESK_DISTANCEX2 = 40
	BILLBOARD_DESK_OFFSET_X1 = 90
	BILLBOARD_DESK_OFFSET_X2 = 90
	BILLBOARD_DESK_IMG1 = "misc/treasure/medal_desk2.png"
	BILLBOARD_DESK_IMG2 = "misc/treasure/medal_desk2.png"
elseif (g_phone_mode == 6) then --平板宽屏
	BILLBOARD_DESK_INDEX1 = 1
	BILLBOARD_DESK_INDEX2 = 4
	BILLBOARD_DESK_DISTANCEX2 = 24
	BILLBOARD_DESK_OFFSET_X1 = 162
	BILLBOARD_DESK_OFFSET_X2 = 80
	BILLBOARD_DESK_IMG1 = "misc/treasure/medal_desk3.png"
	BILLBOARD_DESK_IMG2 = "misc/treasure/medal_desk2.png"
end
]]

local BILLBOARD_DETAIL_WIDTH = 510 --详细介绍的宽度

--local BILLBOARD_NODE_OFFSET_X = 145 --排行榜统一偏移x
--local BILLBOARD_NODE_OFFSET_Y = 28 - 28 --排行榜统一偏移y
--local BILLBOARD_NODE_WIDTH = 230 --排行榜宽度
--local BILLBOARD_NODE_HEIGHT = 550 --排行榜高度
--local BILLBOARD_NODE_EACHOFFSET = 25 --排行榜x间距
local MAX_SPEED = 50 --最大速度

local current_async_paint_list = {} --当前待异步绘制的聊天消息列表
local ASYNC_PAINTNUM_ONCE = 4 --一次绘制几条

local current_funcCallback = nil --关闭后的回调事件
--local current_PlayerId = 0 --本地玩家id
--local current_online_num = 0 --pvp房间在线人数
local current_cangbaotu_normal_num = 0 --藏宝图数量
local current_cangbaotu_high_num = 0 --高级藏宝图数量
local current_focus_billboardEx_idx = 0 --当前显示的排行榜ex的索引值（默认选中第一个）
--local current_billId = 2
--local current_billboardT = nil --排行榜的静态表
local current_chestInfo = {num = 0,} --人族无敌的排行数据表
--local last_query_multy_rzwd_board_time = 0 --上一次获取排行榜的时间
--local last_local_board_score = 0 --上一次的本地排行榜得分
local current_STATE = 0 --当前的状态(0:初始化 / 1:正在连接、登入、查询服务器时间 / 3:查询完毕)
--local current_enter_bg = 0 --当前程序是否在后台（如果进入后台，就不用定时器刷新排行榜情况）
local last_timer_query_time = 0 --上一次timer取排行榜的时间
--local QUERY_DELTA_SECOND = 60 --查询间隔秒数

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

local _bCanCreate = true --防止重复创建



--宝箱操作面板
hGlobal.UI.InitPhoneChestFrm = function(mode)
	local tInitEventName = {"LocalEvent_Phone_ShowPhoneChestFrame", "__ShowTreasureFrm"}
	if (mode ~= "reload") then
		--return tInitEventName
		return
	end
	
	--删除上一次的
	if hGlobal.UI.PhoneChestFrame then
		hGlobal.UI.PhoneChestFrame:del()
		hGlobal.UI.PhoneChestFrame = nil
	end
	if hGlobal.UI.PvpGeneralTipInfoFrame then --删除上一次的宝箱tip界面
		hGlobal.UI.PvpGeneralTipInfoFrame:del()
		hGlobal.UI.PvpGeneralTipInfoFrame = nil
	end
	
	--[[
	--取消监听打开宝箱界面通知事件
	hGlobal.event:listen("LocalEvent_Phone_ShowPhoneChestFrame", "__ShowTreasureFrm", nil)
	--取消监听关闭宝箱界面事件
	hGlobal.event:listen("clearPhoneChestFrm", "__CloseTreasureFrm", nil)
	]]
	
	--竖屏模式
	BOARD_WIDTH = 690 --DLC地图面板面板的宽度
	BOARD_HEIGHT = 740 --DLC地图面板面板的高度
	BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 10
	BOARD_OFFSETY = -15 --DLC地图面板面板y偏移中心点的值
	BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --DLC地图面板面板的x位置（最左侧）
	BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --DLC地图面板面板的y位置（最顶侧）
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
	
	BILLBOARD_OFFSETX = 210 --排行榜第一个元素距离左侧的x偏移
	--横屏模式
	if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
		BILLBOARD_OFFSETX = 260 --排行榜第一个元素距离左侧的x偏移
	end

	--加载资源
	--xlLoadResourceFromPList("data/image/misc/pvp.plist")
	
	hApi.clearTimer("__RANK_BOARD_UPDATE_CHEST__")
	hApi.clearTimer("__RANK_BOARD_UPDATE_CHEST_ASYNC__")
	hApi.clearTimer("__RANK_QUERY_TIMER_CHEST__")
	
	--创建宝箱操作面板
	hGlobal.UI.PhoneChestFrame = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		z = 100,
		dragable = 2,
		show = 0, --一开始不显示
		--border = 1, --显示frame边框
		--background = "misc/treasure/background.jpg",
		border = 0, --显示frame边框
		--background = "misc/skillup/msgbox4.png",
		--border = "UI:TileFrmMedal", --显示frame边框
		background = -1,
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
	
	local _frm = hGlobal.UI.PhoneChestFrame
	local _parent = _frm.handle._n
	
	--左侧裁剪区域
	--local _BTC_PageClippingRect_Rankboard = {0, -200, 2000, hVar.SCREEN.h - 242, 1}
	local _BTC_PageClippingRect_Rankboard = {0, -80+100, BOARD_WIDTH, BOARD_HEIGHT + 100, 0,}
	local _BTC_pClipNode_Rankboard_endless = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect_Rankboard, 99, _BTC_PageClippingRect_Rankboard[5], "_BTC_pClipNode_Rankboard_endless")
	
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
	
	--关闭按钮
	--btnClose
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
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
			
			--显示新无尽界面
			--local _frm2 = hGlobal.UI.PhoneBattleRoomFrm_SingleEndless
			--_frm2:show(1)
			
			--回调事件
			if (type(current_funcCallback) == "function") then
				current_funcCallback()
			end
			
			--刷新主基地ui
			hGlobal.event:event("LocalEvent_refreshWeaponInfo")
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
			--x = hVar.SCREEN.w / 2,
			--y = -hVar.SCREEN.h / 2,
			--z = 99999,
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
		local _frm = hGlobal.UI.PhoneChestFrame
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneChestFrame
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#rightRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, rightRemoveFrmList[i]) 
		end
		rightRemoveFrmList = {}
	end
	
	--清空所有分页右侧详细信息的UI
	_removeRightDetailFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneChestFrame
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#rightDetailRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, rightDetailRemoveFrmList[i]) 
		end
		rightDetailRemoveFrmList = {}
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
		_removeRightDetailFrmFunc()
		
		--清空切换分页之后取消的监听事件
		--移除监听：收到ping值回调
		--hGlobal.event:listen("LocalEvent_Pvp_Ping", "__PvpPing_page_Endless", nil)
		--移除监听：收到连接结果回调
		--hGlobal.event:listen("LocalEvent_Pvp_NetEvent", "__ConnectBack_Endless", nil)
		--移除监听：收到登入结果回调
		--hGlobal.event:listen("LocalEvent_Pvp_PlayerLoginEvent", "__LoginBack_Endless", nil)
		--移除事件监听：收到服务器时间的回调
		hGlobal.event:listen("localEvent_refresh_Systime", "__QueryBillBoardTime_Treasure", nil)
		--移除事件监听：收到玩家宝物信息数据的回调
		hGlobal.event:listen("LocalEvent_GetGameResource", "__QueryTreasure_Treasure", nil)
		--移除事件监听：收到玩家打开藏宝图的回调
		hGlobal.event:listen("localEvent_buyitem_return", "__OpenCangBaoTu_Treasure", nil)
		--移除事件监听：收到玩家开宝箱的回调
		hGlobal.event:listen("LocalEvent_OpenChest_Ret", "__OpenChestRet_Chest", nil)
		--移除事件监听：收到玩家宝物属性位值更新结果
		--hGlobal.event:listen("LocalEvent_TreasureAttrUpdate_Ret", "__TreasureAttrUpdate_Treasure", nil)
		--移除事件监听：程序进入后台的回调
		hGlobal.event:listen("LocalEvent_AppEnterBackground", "__QueryBillBoardEnterBG_Treaure", nil)
		--移除事件监听：横竖屏切换事件
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreen_Chest", nil)
		
		--移除本分页的timer
		hApi.clearTimer("__RANK_BOARD_UPDATE_CHEST__")
		hApi.clearTimer("__RANK_BOARD_UPDATE_CHEST_ASYNC__")
		hApi.clearTimer("__RANK_QUERY_TIMER_CHEST__")
		
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
		
		--不显示宝箱面板
		hGlobal.UI.PhoneChestFrame:show(0)
		--print("不显示人族无敌排行榜面板", debug.traceback())
		
		--关闭界面后不需要监听的事件
		--取消监听：收到网络宝箱数量的事件
		--hGlobal.event:listen("LocalEvent_getNetChestNum", "__ItemGetChestNum_Frm", nil)
		
		--清空切换分页之后取消的监听事件
		--移除监听：收到ping值回调
		--hGlobal.event:listen("LocalEvent_Pvp_Ping", "__PvpPing_page_Endless", nil)
		--移除监听：收到连接结果回调
		--hGlobal.event:listen("LocalEvent_Pvp_NetEvent", "__ConnectBack_Endless", nil)
		--移除监听：收到登入结果回调
		--hGlobal.event:listen("LocalEvent_Pvp_PlayerLoginEvent", "__LoginBack_Endless", nil)
		--移除事件监听：收到服务器时间的回调
		hGlobal.event:listen("localEvent_refresh_Systime", "__QueryBillBoardTime_Treasure", nil)
		--移除事件监听：收到玩家宝物信息数据的回调
		hGlobal.event:listen("LocalEvent_GetGameResource", "__QueryTreasure_Treasure", nil)
		--移除事件监听：收到玩家打开藏宝图的回调
		hGlobal.event:listen("localEvent_buyitem_return", "__OpenCangBaoTu_Treasure", nil)
		--移除事件监听：收到玩家开宝箱的回调
		hGlobal.event:listen("LocalEvent_OpenChest_Ret", "__OpenChestRet_Chest", nil)
		--移除事件监听：收到玩家宝物属性位值更新结果
		--hGlobal.event:listen("LocalEvent_TreasureAttrUpdate_Ret", "__TreasureAttrUpdate_Treasure", nil)
		--移除事件监听：程序进入后台的回调
		hGlobal.event:listen("LocalEvent_AppEnterBackground", "__QueryBillBoardEnterBG_Treaure", nil)
		--移除事件监听：横竖屏切换事件
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreen_Chest", nil)
		
		--动态删除宝物背景大图
		__DynamicRemoveRes()
		
		--清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		_removeRightDetailFrmFunc()
		
		--删除排行榜刷新界面timer
		hApi.clearTimer("__RANK_BOARD_UPDATE_CHEST__")
		hApi.clearTimer("__RANK_BOARD_UPDATE_CHEST_ASYNC__")
		hApi.clearTimer("__RANK_QUERY_TIMER_CHEST__")
		
		--隐藏所有的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Rankboard_endless", 0)
		
		--释放png, plist的纹理缓存（这里不清理也可以）
		--hApi.ReleasePngTextureCache()
		
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

		if _nShouldUpdateTactics == 1 then
			hGlobal.event:event("LocalEvent_refreshTacticsInfo","all")
		end
		_nShouldUpdateTactics = 0
		
		--允许再次打开
		_bCanCreate = true
	end
	
	--函数：创建人族无敌排行榜界面（第1个分页）
	OnCreateRankBoardFrame_PVP_Endless = function(pageIdx)
		local _frm = hGlobal.UI.PhoneChestFrame
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--允许本分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Rankboard_endless", 1)
		
		--初始化
		current_async_paint_list = {} --当前待异步绘制的聊天消息列表
		
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
		
		--动态加载宝物背景大图
		__DynamicAddRes()
		
		--主界面顶部栏1
		local top_left = 108
		local top_right = 142 + iPhoneX_WIDTH + iPhoneX_WIDTH
		local top_up = -110
		--[[
		_frmNode.childUI["menu_top_CfgCard1"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/addition/medal_inner_left.png",
			x = top_left,
			y = top_up,
			w = 216,
			h = 183,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "menu_top_CfgCard1"
		
		--主界面顶部栏2
		_frmNode.childUI["menu_top_CfgCard2"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/addition/medal_inner_left.png",
			x = hVar.SCREEN.w - top_right,
			y = top_up,
			w = 216,
			h = 183,
		})
		_frmNode.childUI["menu_top_CfgCard2"].handle.s:setFlipX(true)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "menu_top_CfgCard2"
		]]
		
		--[[
		--主界面顶部栏3
		_frmNode.childUI["menu_top_CfgCard3"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/addition/medal_inner_center.png",
			x = hVar.SCREEN.w / 2 - (top_right - top_left) / 2,
			y = top_up,
			w = hVar.SCREEN.w - top_right - top_right + iPhoneX_WIDTH + iPhoneX_WIDTH,
			h = 183,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "menu_top_CfgCard3"
		]]
		
		--[[
		--奖杯图标
		_frmNode.childUI["menu_top_medal_img"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/addition/medal_jiangbei.png",
			x = hVar.SCREEN.w / 2 - (top_right - top_left) / 2 - 50,
			y = top_up + 15,
			w = 128,
			h = 128,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "menu_top_medal_img"
		
		--奖杯进度条
		_frmNode.childUI["menu_top_medal_progress"] = hUI.valbar:new({
			parent = _parentNode,
			model = "UI:ValueBar",
			back = {model = "UI:ValueBar_Back",x = -8, y = -5,w = 250,h = 48},
			x = hVar.SCREEN.w / 2 - (top_right - top_left) / 2 + 50,
			y = top_up + 15,
			z = 1,
			w = 232,
			h = 18,
			align = "LC",
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "menu_top_medal_progress"
		_frmNode.childUI["menu_top_medal_progress"]:setV(100, 100)
		]]
		
		--[[
		--创建技能tip图片背景
		_frmNode.childUI["ItemBG_1"] = hUI.image:new({
			parent = _parentNode,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "misc/skillup/msgbox4.png",
			x = BOARD_WIDTH / 2,
			y = -BOARD_HEIGHT / 2,
			w = BOARD_WIDTH,
			h = BOARD_HEIGHT,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ItemBG_1"
		]]
		
		--[[
		--顶部中央
		_frmNode.childUI["menu_center_medal"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/treasure/medal_center.png",
			x = hVar.SCREEN.w / 2,
			y = -10,
			scale = 1.0,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "menu_center_medal"
		]]
		
		--[[
		--顶部左侧
		_frmNode.childUI["menu_left_medal"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/treasure/medal_desk.png",
			x = 230,
			y = -36,
			scale = 1.0,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "menu_left_medal"
		]]
		
		--[[
		--奖杯图标
		_frmNode.childUI["menu_top_medal_img"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/treasure/medal_jiangbei.png",
			x = 100,
			y = -52,
			w = 42,
			h = 42,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "menu_top_medal_img"
		]]
		
		--[[
		--收藏评分
		_frmNode.childUI["menu_top_medal_pingfen"] = hUI.label:new({
			parent = _parentNode,
			size = 24,
			x = 130,
			y = -52 - 1+4,
			font = hVar.FONTC,
			align = "LC",
			width = 300,
			border = 1,
			--text = "收藏评分", --language
			text = hVar.tab_string["ShouCangPingFen"], --language
			RGB = {0, 255, 0,},
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "menu_top_medal_pingfen"
		]]
		
		--[[
		--收藏评分值
		local score = hApi.GetTreasureScore()
		_frmNode.childUI["menu_top_medal_pingfen_value"] = hUI.label:new({
			parent = _parentNode,
			size = 22,
			x = 230,
			y = -52 - 1,
			font = "numGreen",
			align = "LC",
			width = 300,
			border = 1,
			text = score,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "menu_top_medal_pingfen_value"
		]]
		
		--[[
		--普通藏宝图按钮（响应区域）
		_frmNode.childUI["menu_top_medal_book_normal"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			x = hVar.SCREEN.w - iPhoneX_WIDTH * 2 - BILLBOARD_DETAIL_WIDTH - 150,
			y = -30,
			w = 84,
			h = 92,
		})
		_frmNode.childUI["menu_top_medal_book_normal"].handle.s:setOpacity(0) --只挂载子控件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "menu_top_medal_book_normal"
		
		--普通藏宝图图片
		_frmNode.childUI["menu_top_medal_book_normal"].childUI["image"] = hUI.image:new({
			parent = _frmNode.childUI["menu_top_medal_book_normal"].handle._n,
			model = "UI:CANGBAOTU_NORMAL",
			x = 0,
			y = 4,
			w = 80,
			h = 80,
		})
		
		--普通藏宝图进度
		_frmNode.childUI["menu_top_medal_book_normal"].childUI["progress"] = hUI.valbar:new({
			parent = _frmNode.childUI["menu_top_medal_book_normal"].handle._n,
			x = -32,
			y = -32,
			w = 66,
			h = 16,
			align = "LC",
			back = {model = "misc/chest/herodetailname.png", x = -2, y = 1, w = 70, h = 16},
			model = "misc/chest/xp_progress.png",
			--model = "misc/progress.png",
			v = current_cangbaotu_normal_num,
			max = hVar.EXCHANGE_CANGBAOTU_NORMAL_NUM,
		})
		
		--普通藏宝图进度文字
		_frmNode.childUI["menu_top_medal_book_normal"].childUI["num"] = hUI.label:new({
			parent = _frmNode.childUI["menu_top_medal_book_normal"].handle._n,
			size = 16,
			x = 0,
			y = -32 - 1,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
			text = current_cangbaotu_normal_num .. "/" .. hVar.EXCHANGE_CANGBAOTU_NORMAL_NUM,
		})
		
		--普通藏宝图提示可兑换
		_frmNode.childUI["menu_top_medal_book_normal"].childUI["tanhao"] = hUI.image:new({
			parent = _frmNode.childUI["menu_top_medal_book_normal"].handle._n,
			model = "UI:TaskTanHao",
			x = 18,
			y = 18,
			z = 2,
			w = 36,
			h = 36,
		})
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
		_frmNode.childUI["menu_top_medal_book_normal"].childUI["tanhao"].handle.s:runAction(CCRepeatForever:create(sequence))
		_frmNode.childUI["menu_top_medal_book_normal"].childUI["tanhao"].handle._n:setVisible(false) --一开始不显示叹号
		if(current_cangbaotu_normal_num >= hVar.EXCHANGE_CANGBAOTU_NORMAL_NUM) then
			_frmNode.childUI["menu_top_medal_book_normal"].childUI["tanhao"].handle._n:setVisible(true)
		end
		
		--高级藏宝图按钮（响应区域）
		_frmNode.childUI["menu_top_medal_book_high"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			x = hVar.SCREEN.w - iPhoneX_WIDTH * 2 - BILLBOARD_DETAIL_WIDTH - 60,
			y = -30,
			w = 84,
			h = 92,
		})
		_frmNode.childUI["menu_top_medal_book_high"].handle.s:setOpacity(0) --只挂载子控件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "menu_top_medal_book_high"
		
		--高级藏宝图图片
		_frmNode.childUI["menu_top_medal_book_high"].childUI["image"] = hUI.image:new({
			parent = _frmNode.childUI["menu_top_medal_book_high"].handle._n,
			model = "UI:CANGBAOTU_HIGH",
			x = 0,
			y = 4,
			w = 80,
			h = 80,
		})
		
		--高级藏宝图进度
		_frmNode.childUI["menu_top_medal_book_high"].childUI["progress"] = hUI.valbar:new({
			parent = _frmNode.childUI["menu_top_medal_book_high"].handle._n,
			x = -32,
			y = -32,
			w = 66,
			h = 16,
			align = "LC",
			back = {model = "misc/chest/herodetailname.png", x = -2, y = 1, w = 70, h = 16},
			model = "misc/chest/xp_progress.png",
			--model = "misc/progress.png",
			v = current_cangbaotu_high_num,
			max = hVar.EXCHANGE_CANGBAOTU_HIGH_NUM,
		})
		
		--高级藏宝图进度文字
		_frmNode.childUI["menu_top_medal_book_high"].childUI["num"] = hUI.label:new({
			parent = _frmNode.childUI["menu_top_medal_book_high"].handle._n,
			size = 16,
			x = 0,
			y = -32 - 1,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
			text = current_cangbaotu_high_num .. "/" .. hVar.EXCHANGE_CANGBAOTU_HIGH_NUM,
		})
		
		--高级藏宝图提示可兑换
		_frmNode.childUI["menu_top_medal_book_high"].childUI["tanhao"] = hUI.image:new({
			parent = _frmNode.childUI["menu_top_medal_book_high"].handle._n,
			model = "UI:TaskTanHao",
			x = 18,
			y = 18,
			z = 2,
			w = 36,
			h = 36,
		})
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
		_frmNode.childUI["menu_top_medal_book_high"].childUI["tanhao"].handle.s:runAction(CCRepeatForever:create(sequence))
		_frmNode.childUI["menu_top_medal_book_high"].childUI["tanhao"].handle._n:setVisible(false) --一开始不显示叹号
		if(current_cangbaotu_high_num >= hVar.EXCHANGE_CANGBAOTU_HIGH_NUM) then
			_frmNode.childUI["menu_top_medal_book_high"].childUI["tanhao"].handle._n:setVisible(true)
		end
		]]
		
		--[[
		--右侧竖线
		_frmNode.childUI["menu_right_medal_line"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/treasure/line.png",
			x = hVar.SCREEN.w - iPhoneX_WIDTH * 2 - BILLBOARD_DETAIL_WIDTH,
			y = -hVar.SCREEN.h / 2,
			w = 2,
			h = 638,
		})
		--_frmNode.childUI["menu_right_medal_line"].handle._n:setRotation(90)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "menu_right_medal_line"
		]]
		
		--左侧排行榜列表提示上翻页的图片
		_frmNode.childUI["BillboardPageUp"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/addition/change_arrow.png",
			x = BOARD_WIDTH / 2,
			y = 30,
			scale = 0.8,
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
			model = "misc/addition/change_arrow.png",
			x = BOARD_WIDTH / 2, --非对称式
			y = -BOARD_HEIGHT - 20,
			scale = 0.8,
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
			x = BOARD_WIDTH / 2,
			y = 30,
			w = 300,
			h = 100,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (current_chestInfo.num > (BILLBOARD_X_NUM * BILLBOARD_Y_NUM)) then
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
			x = BOARD_WIDTH / 2,
			y = -BOARD_HEIGHT - 10 - 32,
			w = 300,
			h = 100,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (current_chestInfo.num > (BILLBOARD_X_NUM * BILLBOARD_Y_NUM)) then
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
			x = BOARD_WIDTH / 2,
			y = -BOARD_HEIGHT / 2 - 10,
			w = BOARD_WIDTH,
			h = BOARD_HEIGHT - 70,
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
					click_scroll_billboard = false --不需要滑动DLC地图面板
				end
				
				--不超过一页，不需要滑动
				if (current_chestInfo.num <= (BILLBOARD_X_NUM * BILLBOARD_Y_NUM)) then
					click_scroll_billboard = false --不需要滑动DLC地图面板
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
				
				--[[
				--检测是否点到了某些控件里(高级藏宝图)
				local ctrli = _frmNode.childUI["menu_top_medal_book_high"]
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
				]]
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
				local deltaY = touchY - last_click_pos_y_billboard --与开始按下的位置的偏移值x
				
				--处理移动速度y
				draggle_speed_y_billboard = touchY - last_click_pos_y_billboard
				
				if (draggle_speed_y_billboard > MAX_SPEED) then
					draggle_speed_y_billboard = MAX_SPEED
				end
				if (draggle_speed_y_billboard < -MAX_SPEED) then
					draggle_speed_y_billboard = -MAX_SPEED
				end
				
				--检测是否滑动到了最顶部或最底部
				local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
				local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
				delta1_ly, deltNa_ry = getUpDownOffset()
				--print(delta1_ly, deltNa_ry)
				--delta1_ly +:在下底线之上 /-:在下底线之下
				--deltNa_ry +:在下底线之上 /-:在下底线之下
				--print(delta1_ly, deltaY)
				
				--第一个DLC地图面板的坐标不能跑到最上侧的下边去
				if ((delta1_ly + deltaY) <= 0) then --防止走过
					deltaY = -delta1_ly
					delta1_ly = 0
					
					--没有惯性
					draggle_speed_y_billboard = 0
					
					_frmNode.childUI["BillboardPageUp_Btn"].handle.s:setVisible(false) --上分翻页提示
				else
					if click_scroll_dlcmapinfo then
						_frmNode.childUI["BillboardPageUp_Btn"].handle.s:setVisible(true) --上分翻页提示
					end
				end
				
				--最后一个DLC地图面板的坐标不能跑到最下侧的上边去
				if ((deltNa_ry + deltaY) >= 0) then --防止走过
					deltaY = -deltNa_ry
					deltNa_ry = 0
					
					--没有惯性
					draggle_speed_y_billboard = 0
					
					--已到底部，标记下拉到底部（为true时有新消息自动滚到最下端）
					--current_in_scroll_down = true
					_frmNode.childUI["BillboardPageDown_Btn"].handle.s:setVisible(false) --下分翻页提示
				else
					if click_scroll_dlcmapinfo then
						_frmNode.childUI["BillboardPageDown_Btn"].handle.s:setVisible(true) --下分翻页提
					end
				end
				
				--print("click_scroll_billboard=", click_scroll_billboard)
				--在滑动过程中才会处理滑动 
				if click_scroll_billboard then
					--local deltaY = touchY - last_click_pos_y_billboard --与开始按下的位置的偏移值x
					--如果当前的查询状态是在查询服务器时间，或者查询静态数据，那么不能处理
					if (current_STATE == 3) then --当前的状态(0:初始化 / 1:正在连接、登入、查询服务器时间 / 3:查询完毕)
						--注意: 如果刚打开界面的瞬间，子控件都被删掉了，而这点击屏幕，并且有上一次排行榜缓存数据，逻辑会走到这，但是此时界面还没，会弹框
						if (_frmNode.childUI["BillboardNode1"] ~= nil) then
							for i = 1, current_chestInfo.num, 1 do
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
				
				--[[
				--模拟按下事件
				--检测是否点到了某些控件里(藏宝图)
				local ctrli = _frmNode.childUI["menu_top_medal_book_normal"]
				if ctrli then
					local bcx = ctrli.data.x --中心点x坐标
					local bcy = ctrli.data.y --中心点y坐标
					local bcw, bch = ctrli.data.w, ctrli.data.h
					local blx, bly = bcx - bcw / 2, bcy - bch / 2 --最左上侧坐标
					local brx, bry = blx + bcw, bly + bch --最右下角坐标
					--print(i, lx, rx, ly, ry, touchX, touchY)
					if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
						--点击藏宝图按钮
						OnClickCangBaoTuNormalBtn()
						
						return
					end
				end
				]]
				
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
				--检测点击到了哪个排行榜框内
				--如果当前的查询状态是在查询服务器时间，或者查询静态数据，那么不能处理
				if (current_STATE == 3) then --当前的状态(0:初始化 / 1:正在连接、登入、查询服务器时间 / 3:查询完毕)
					--注意: 如果刚打开界面的瞬间，子控件都被删掉了，而这点击屏幕，并且有上一次排行榜缓存数据，逻辑会走到这，但是此时界面还没，会弹框
					if (_frmNode.childUI["BillboardNode1"] ~= nil) then
						for i = 1, current_chestInfo.num, 1 do
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
								--print("点击到了哪个排行榜的框内" .. i)
								break
								
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
					OnRefreshTreasureDetail(selected_billboardEx_idx, touchX, touchY)
					
					--selected_billboardEx_idx = 0
				end
				
				--标记不用滑动
				click_scroll_billboard = false
			end,
		})
		_frmNode.childUI["BillboardDragPanel"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BillboardDragPanel"
		
		--[[
		--转圈圈的图: 右上角小菊花
		_frmNode.childUI["waiting"] = hUI.image:new({
			parent = _parentNode,
			model = "MODEL_EFFECT:waiting",
			x = hVar.SCREEN.w / 2,
			y = -BOARD_HEIGHT / 2,
			w = 36,
			h = 36,
		})
		_frmNode.childUI["waiting"].handle.s:setVisible(false) --一开始不显示小菊花
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "waiting"
		]]
		
		------------------------------------------------------------------
		--左侧排行榜的各列的标题
		--[[
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
		]]
		
		--[[
		--排行的排名
		_frmNode.childUI["RankCol1"] = hUI.label:new({
			parent = _parentNode,
			--x = BILLBOARD_NODE_OFFSET_X + 5 - 60,
			x = BILLBOARD_X_RANK,
			--y = BILLBOARD_NODE_OFFSET_Y - 140 + 87 - 1, --数字有1像素偏差
			y = -30 * _ScaleH,
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
		
		--排行的玩家名1
		_frmNode.childUI["RankCol2"] = hUI.label:new({
			parent = _parentNode,
			--x = BILLBOARD_NODE_OFFSET_X - 25 + 60,
			x = BILLBOARD_X_NAME1,
			--y = BILLBOARD_NODE_OFFSET_Y - 140 + 87 - 1, --数字有1像素偏差
			y = -30 * _ScaleH,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
			--text = "玩家1", --language
			text = hVar.tab_string["__TEXT_WanJia"] .. "1", --language
		})
		_frmNode.childUI["RankCol2"].handle.s:setColor(ccc3(255, 255, 223))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RankCol2"
		
		--排行的出战阵容1
		_frmNode.childUI["RankCol3"] = hUI.label:new({
			parent = _parentNode,
			--x = BILLBOARD_NODE_OFFSET_X + 25 + 330,
			x = BILLBOARD_X_CARD1,
			--y = BILLBOARD_NODE_OFFSET_Y - 140 + 87 - 1, --数字有1像素偏差
			y = -30 * _ScaleH,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
			--text = "玩家1阵容", --language
			text = hVar.tab_string["__TEXT_WanJia"] .. "1" .. hVar.tab_string["__TEXT_BTN_ZHENRONG"], --language
		})
		_frmNode.childUI["RankCol3"].handle.s:setColor(ccc3(255, 255, 223))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RankCol3"
		
		--排行的玩家名2
		_frmNode.childUI["RankCol4"] = hUI.label:new({
			parent = _parentNode,
			--x = BILLBOARD_NODE_OFFSET_X + 685,
			x = BILLBOARD_X_NAME2,
			--y = BILLBOARD_NODE_OFFSET_Y - 140 + 87 - 1, --数字有1像素偏差
			y = -30 * _ScaleH,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
			--text = "玩家2", --language
			text = hVar.tab_string["__TEXT_WanJia"] .. "2", --language
		})
		_frmNode.childUI["RankCol4"].handle.s:setColor(ccc3(255, 255, 223))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RankCol4"
		
		--排行的出战阵容2
		_frmNode.childUI["RankCol5"] = hUI.label:new({
			parent = _parentNode,
			--x = BILLBOARD_NODE_OFFSET_X + 25 + 330,
			x = BILLBOARD_X_CARD2,
			--y = BILLBOARD_NODE_OFFSET_Y - 140 + 87 - 1, --数字有1像素偏差
			y = -30 * _ScaleH,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
			--text = "玩家2阵容", --language
			text = hVar.tab_string["__TEXT_WanJia"] .. "2" .. hVar.tab_string["__TEXT_BTN_ZHENRONG"], --language
		})
		_frmNode.childUI["RankCol5"].handle.s:setColor(ccc3(255, 255, 223))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RankCol5"
		
		--我的底纹
		_frmNode.childUI["MyRankColBG"] = hUI.image:new({
			parent = _parentNode,
			--x = BILLBOARD_NODE_OFFSET_X + 320 + 7,
			x = hVar.SCREEN.w / 2,
			y = -hVar.SCREEN.h + 18,
			model = "UI:AttrBg", --UI:login_lk", --"misc/y_mask_16.png",
			w = hVar.SCREEN.w,
			h = 36,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "MyRankColBG"
		
		--我的排名的魔龙宝库图标
		_frmNode.childUI["RankColIcon"] = hUI.image:new({
			parent = _parentNode,
			x = iPhoneX_WIDTH + 34,
			y = -hVar.SCREEN.h + 6 + 19,
			model = "misc/chest/rzwd.png",
			w = 50 * _ScaleH,
			h = 50 * _ScaleH,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RankColIcon"
		
		--"我的排名"文字前缀
		_frmNode.childUI["MyRankCol1"] = hUI.label:new({
			parent = _parentNode,
			x = BILLBOARD_X_RANK + 84 + 20,
			y = -hVar.SCREEN.h + 6 + 11 - 1,
			size = 25,
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
			x = BILLBOARD_X_RANK + 140 + 20,
			y = -hVar.SCREEN.h + 6 + 11,
			model = "UI:rank_bottom",
			w = 102,
			h = 28,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "MyRankValBG"
		]]
		
		--[[
		--"我的通关时间"文字前缀
		_frmNode.childUI["MyRankCol2"] = hUI.label:new({
			parent = _parentNode,
			x = hVar.SCREEN.w - 500 * _ScaleW + 184,
			y = -hVar.SCREEN.h + 6 + 11 - 1,
			size = 25,
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
			x = hVar.SCREEN.w - 500 * _ScaleW + 245,
			y = -hVar.SCREEN.h + 6 + 11,
			model = "UI:rank_bottom",
			w = 112,
			h = 28,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "MyRankVal2BG"
		]]
		
		--[[
		--排行榜规则(人族无敌)按钮（响应区域）
		_frmNode.childUI["btnBoardIntro_Endless"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = hVar.SCREEN.w - iPhoneX_WIDTH - 38,
			y = -hVar.SCREEN.h + 28,
			w = 84,
			h = 84,
			model = "misc/mask.png",
			scaleT = 1.0,
			code = function()
				--创建人族无敌排行榜规则介绍tip
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
			scale = 1.0,
			model = "ICON:action_info",
		})
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(1.0, 0.96) ,CCScaleTo:create(1.0, 1.04))
		local forever = CCRepeatForever:create(tolua.cast(towAction,"CCActionInterval"))
		_frmNode.childUI["btnBoardIntro_Endless"].childUI["icon"].handle._n:runAction(forever)
		]]
		
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
			text = hVar.tab_string["__TEXT_PAGE_CHEST"], --"宝箱"
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BillboardTitlel"

		_frmNode.childUI["btn_comment"] = hUI.button:new({
			parent = _parent,
			model = "misc/addition/commentbtn.png",
			dragbox = _frm.childUI["dragBox"],
			scale = 0.8,
			scaleT = 0.8,
			x = 290 + BILLBOARD_OFFSETX - 10,
			y = -19 - 60,
			code = function()
				CommentManage.ReadyComment(hVar.CommentTargetTypeDefine.PIECES)
				hGlobal.event:event("LocalEvent_SetCommentShieldBoardEnable",true)
				hGlobal.event:event("LocalEvent_DoCommentProcess")
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btn_comment"
		
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
			scale = 0.8,
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
		hApi.AddShader(_frmNode.childUI["BillboardButton5"].childUI["image"].handle.s, "normal") --高亮图片
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
		
		--添加本分页的监听事件
		--添加监听：收到ping值回调
		--hGlobal.event:listen("LocalEvent_Pvp_Ping", "__PvpPing_page_Endless", on_receive_ping_event_PVP_Endless)
		--添加监听：收到连接结果回调
		--hGlobal.event:listen("LocalEvent_Pvp_NetEvent", "__ConnectBack_Endless", on_receive_connect_back_event_PVP_Endless)
		--添加监听：收到登入结果回调
		--hGlobal.event:listen("LocalEvent_Pvp_PlayerLoginEvent", "__LoginBack_Endless", on_receive_login_back_event_PVP_Endless)
		--添加监听：收到服务器时间的回调
		hGlobal.event:listen("localEvent_refresh_Systime", "__QueryBillBoardTime_Treasure", on_receive_refresh_systime_event_chest)
		--添加监听：收到玩家宝物信息数据的回调
		hGlobal.event:listen("LocalEvent_GetGameResource", "__QueryTreasure_Treasure", on_receive_treasure_event_chest)
		--添加事件监听：收到玩家打开藏宝图的回调
		hGlobal.event:listen("localEvent_buyitem_return", "__OpenCangBaoTu_Treasure", on_receive_open_cangbaotu_event_chest)
		--添加事件监听：收到玩家开宝箱的回调
		hGlobal.event:listen("LocalEvent_OpenChest_Ret", "__OpenChestRet_Chest", on_receive_open_chest_event)
		--添加事件监听：收到玩家宝物属性位值更新结果
		--hGlobal.event:listen("LocalEvent_TreasureAttrUpdate_Ret", "__TreasureAttrUpdate_Treasure", on_receive_treasure_attr_update_Treasure)
		--添加事件监听：程序进入后台的回调
		hGlobal.event:listen("LocalEvent_AppEnterBackground", "__QueryBillBoardEnterBG_Treaure", on_enter_background_event_Treasure)
		--添加事件监听：横竖屏切换事件
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreen_Chest", on_SpinScreen_event_chest)
		
		--创建只有本分页下才有的timer，刷新排行榜滚动
		hApi.addTimerForever("__RANK_BOARD_UPDATE_CHEST__", hVar.TIMER_MODE.GAMETIME, 30, refresh_rank_board_UI_loop_RZWD)
		hApi.addTimerForever("__RANK_BOARD_UPDATE_CHEST_ASYNC__", hVar.TIMER_MODE.GAMETIME, 1, refresh_rank_board_UI_loop_RZWD_async)
		
		--添加本分页的timer，定时取排行榜最新排名
		--hApi.addTimerForever("__RANK_QUERY_TIMER_CHEST__", hVar.TIMER_MODE.GAMETIME, QUERY_DELTA_SECOND * 1000, on_query_billboard_info_timer_PVP_Endless)
		
		--初始化当前状态
		current_STATE = 0 --当前的状态(0:初始化 / 1:正在连接、登入、查询服务器时间 / 3:查询完毕)
		--current_enter_bg = 0 --当前程序是否在后台（如果进入后台，就不用定时器刷新排行榜情况）
		last_timer_query_time = 0 --上一次timer取排行榜的时间
		
		if (g_cur_net_state == -1) then --未联网
			--未联网的提示文字
			_frmNode.childUI["connnetFail"] = hUI.label:new({
				parent = _parentNode,
				x = hVar.SCREEN.w / 2,
				y = -hVar.SCREEN.h / 2 - 60 * _ScaleH / 2,
				size = 28,
				font = hVar.FONTC,
				align = "MC",
				width = 300,
				border = 1,
				--text = "查看宝物需要联网", --language
				text = hVar.tab_string["__TEXT_Cant_UseDepletion19_Net"], --language
			})
			_frmNode.childUI["connnetFail"].handle.s:setColor(ccc3(168, 168, 168))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "connnetFail"
		else --已联网
			--显示正在网络查询的小菊花
			--_frmNode.childUI["waiting"].handle.s:setVisible(true)
			
			--[[
			--创建联网的: 文字
			_frmNode.childUI["ActivityWaitingLabel"] = hUI.label:new({
				parent = _parentNode,
				x = hVar.SCREEN.w / 2,
				y = -hVar.SCREEN.h / 2 - 60 * _ScaleH / 2,
				size = 28,
				font = hVar.FONTC,
				align = "MC",
				width = 300,
				border = 1,
				--text = "正在获取宝物", --language
				text = hVar.tab_string["__TEXT_Getting__"] .. hVar.tab_string["__TEXT_ITEM_TYPE_ORNAMENTS"], --language
			})
			_frmNode.childUI["ActivityWaitingLabel"].handle.s:setColor(ccc3(168, 168, 168))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "ActivityWaitingLabel"
			]]
			
			--转圈圈的图: 大菊花
			_frmNode.childUI["waitingBigImg"] = hUI.image:new({
				parent = _parentNode,
				model = "MODEL_EFFECT:waiting",
				x = hVar.SCREEN.w / 2,
				y = -BOARD_HEIGHT / 2,
				scale = 1.0,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "waitingBigImg"
			
			--标记状态为正在查询服务器时间
			current_STATE = 1 --当前的状态(0:初始化 / 1:正在连接、登入、查询服务器时间 / 3:查询完毕)
			
			--发起查询服务器系统时间
			--print("发起查询服务器系统时间")
			SendCmdFunc["refresh_systime"]()
		end
	end
	
	--函数：收到宝物系统系统时间的回调
	on_receive_refresh_systime_event_chest = function()
		--print("收到系统时间的回调")
		local _frm = hGlobal.UI.PhoneChestFrame
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--if (current_STATE == 1) then --当前的状态(0:初始化 / 1:正在连接、登入、查询服务器时间 / 3:查询完毕)
			--标记当前状态为查询完毕
			current_STATE = 3 --当前的状态(0:初始化 / 1:正在连接、登入、查询服务器时间 / 3:查询完毕)
			
			--隐藏正在网络查询的小菊花
			--_frmNode.childUI["waiting"].handle.s:setVisible(false)
			
			--显示正在网络查询的小菊花
			--_frmNode.childUI["waiting"].handle.s:setVisible(true)
			
			--print("发起查询，获取玩家宝物信息")
			--发起查询，获取玩家资源信息
			SendCmdFunc["get_mycoin"]()
		--end
	end
	
	--函数：收到玩家宝物信息数据的回调事件
	on_receive_treasure_event_chest = function(gamecoin, pvpcoin, crystal, evaluateE, redscroll, weaponChestNum, tacticChestNum, petChestNum, equipChestNum, scientistNum, tankDeadthCount, dishuCoin)
		--print("收到玩家宝物信息数据的回调事件")
		local _frm = hGlobal.UI.PhoneChestFrame
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--隐藏正在网络查询的小菊花
		--_frmNode.childUI["waiting"].handle.s:setVisible(false)
		
		--先清空右侧的信息
		_removeRightFrmFunc()
		_removeRightDetailFrmFunc()
		
		--初始化
		current_async_paint_list = {} --当前待异步绘制的聊天消息列表
		
		--存储数量
		current_cangbaotu_normal_num = cangbaotuNum
		current_cangbaotu_high_num = cangbaotuHighNum
		
		--依次按序号填充宝箱结构
		local tChest = {}
		for i = 1, #hVar.tab_chestEx, 1 do
			local chest_id = hVar.tab_chestEx[i]
			local tabChest = hVar.tab_chest[chest_id] or {}
			local icon = tabChest.icon
			local width = tabChest.width or 0
			local height = tabChest.height or 0
			local itemType = tabChest.itemType
			local shopItemId = tabChest.shopItemId --商品id
			local tabShopItem = hVar.tab_shopitem[shopItemId] or {}
			local debrisOpenNum = tabShopItem.debrisNum or 0 --开箱子需要数量
			local costGameCoin = tabShopItem.rmb or 0 --消耗的游戏币
			local num = 0
			
			if (itemType == hVar.ITEM_TYPE.CHEST_REDEQUIP) then --神器宝箱
				debrisOpenNum = costGameCoin
			end
			
			if (itemType == hVar.ITEM_TYPE.CHEST_WEAPON_GUN) then --武器枪宝箱
				num = LuaGetTankWeaponGunChestNum()
			elseif (itemType == hVar.ITEM_TYPE.CHEST_TACTIC) then --战术宝箱
				num = LuaGetTankTacticChestNum()
			elseif (itemType == hVar.ITEM_TYPE.CHEST_PET) then --宠物宝箱
				num = LuaGetTankPetChestNum()
			elseif (itemType == hVar.ITEM_TYPE.CHEST_EQUIP) then --装备宝箱
				num = LuaGetTankEquipChestNum()
			elseif (itemType == hVar.ITEM_TYPE.CHEST_REDEQUIP) then --神器宝箱
				num = LuaGetPlayerRmb() --当前游戏币
			end
			
			tChest[#tChest+1] = {id = chest_id, num = num,}
		end
		
		--最前面两个是藏宝图、高级藏宝图
		--table.insert(tTreasure, 1, {id = CANGBAOTU_TREASURE_ID, star = 0, num = 0,})
		--table.insert(tTreasure, 2, {id = CANGBAOTU_HIGH_TREASURE_ID, star = 0, num = 0,})
		
		tChest.num = #tChest
		
		--存储本次排行数据
		--[[
		--测试 --test
		local testest = "本人认为从以往的试点城市来看sss我过的征收的税率还是远远的低于国际上的平均水平的fff我想就算是房地产税落地实施ggg也没有我们想像的那么悲催，政府肯定会根据不同地区执行不同的征收标准，还会依照中国的国情设定一定的免征额。我想我们普通老百姓到时的税收会有一个对冲的效果，不必太多担忧。对于没有房子的朋友也称得上是利好，有了房地产税，呢么对于一些市场上的包租婆就相当于是增加了他们囤积房子的成本，也会让他们将手上空闲的余房进行抛售，那么市场上的房源供过于求，就会使我们没房的朋友购买房子的时候房价应该有所减少。要是楼市资金出逃的话，那么势必股市的资金就会流入，近期可以重点关注房地产板块，寻找一些资金流入，趋势走好，股价处于低位的个股关注，个股案例欢迎咨询。"
		tTreasure.cFirstIdx = 1
		tTreasure.cNum = 10
		tTreasure.num = 20
		tTreasure.info = {}
		tTreasure.rankingMe = 4
		tTreasure.gametimeMe = 829
		for i = 1, tTreasure.num, 1 do
			tTreasure[i] = {}
			tTreasure[i].gametime = math.random(1, 3600)
			tTreasure[i].playerInfo = {}
			
			--一组
			for j = 1, 2, 1 do
				local randNum = math.random(5, 7)
				local str = ""
				for i = 1, randNum, 1 do
					local idx = math.random(1, #testest)
					str = str .. string.sub(testest, idx, idx + 2)
				end
				
				tTreasure[i].playerInfo[j] = {}
				tTreasure[i].playerInfo[j].udbid = math.random(10000000, 99999999)
				tTreasure[i].playerInfo[j].vipLv = math.random(0, 7)
				tTreasure[i].playerInfo[j].name = str
				tTreasure[i].playerInfo[j].hero = {}
				for h = 1, 1, 1 do
					pveMultiLog[i].playerInfo[j].hero[h] = {id = math.random(18001, 18012), lv = math.random(1, 15), star = math.random(1, 2), equip = {},}
				end
				pveMultiLog[i].playerInfo[j].tower = {}
				for h = 1, 2, 1 do
					pveMultiLog[i].playerInfo[j].tower[h] = {id = math.random(1001, 1020), lv = math.random(1, 15),}
				end
				pveMultiLog[i].playerInfo[j].tactic = {}
				for h = 1, 1, 1 do
					pveMultiLog[i].playerInfo[j].tactic[h] = {id = math.random(1001, 1020), lv = math.random(1, 15),}
				end
			end
		end
		]]
		--current_chestInfo = tTreasure
		
		--依次绘制每个排行
		local num = tChest.num --查询到的数量
		
		--[[
		--测试 --test
		tTreasure.num = 0
		num = 0
		]]
		
		--print(cFirstIdx, cNum, num)
		for i = 1, num, 1 do
			
			--绘制该行（异步）
			OnCreateSingleTreasureData_PVP_async(i, tChest)
			
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
		
		--[[
		--更新藏宝图数量
		_frmNode.childUI["menu_top_medal_book_normal"].childUI["progress"]:setV(current_cangbaotu_normal_num, hVar.EXCHANGE_CANGBAOTU_NORMAL_NUM)
		_frmNode.childUI["menu_top_medal_book_normal"].childUI["num"]:setText(current_cangbaotu_normal_num .. "/" .. hVar.EXCHANGE_CANGBAOTU_NORMAL_NUM)
		if(current_cangbaotu_normal_num >= hVar.EXCHANGE_CANGBAOTU_NORMAL_NUM) then
			_frmNode.childUI["menu_top_medal_book_normal"].childUI["tanhao"].handle._n:setVisible(true)
		else
			_frmNode.childUI["menu_top_medal_book_normal"].childUI["tanhao"].handle._n:setVisible(false)
		end
		
		--更新高级藏宝图数量
		_frmNode.childUI["menu_top_medal_book_high"].childUI["progress"]:setV(current_cangbaotu_high_num, hVar.EXCHANGE_CANGBAOTU_HIGH_NUM)
		_frmNode.childUI["menu_top_medal_book_high"].childUI["num"]:setText(current_cangbaotu_high_num .. "/" .. hVar.EXCHANGE_CANGBAOTU_HIGH_NUM)
		if(current_cangbaotu_high_num >= hVar.EXCHANGE_CANGBAOTU_HIGH_NUM) then
			_frmNode.childUI["menu_top_medal_book_high"].childUI["tanhao"].handle._n:setVisible(true)
		else
			_frmNode.childUI["menu_top_medal_book_high"].childUI["tanhao"].handle._n:setVisible(false)
		end
		]]
		
		--翻页按钮是否显示
		_frmNode.childUI["BillboardPageUp"].handle.s:setVisible(false) --不显示上翻页提示
		--如果排行总数量超过一页，那么显示下翻页提示
		if (tChest.num > (BILLBOARD_X_NUM * BILLBOARD_Y_NUM)) then
			_frmNode.childUI["BillboardPageDown"].handle.s:setVisible(true) --显示下翻页提示
		end
		
		--最后存储本次排行榜的数据（放在最后存储，是为了其他timer刷新界面时，取的数量为旧的，避免新控件还未创建）
		current_chestInfo = tChest
		
		--[[
		--显示当前选中的宝物详细信息
		if (current_focus_billboardEx_idx > 0) then
			local idx = current_focus_billboardEx_idx
			current_focus_billboardEx_idx = 0
			OnRefreshTreasureDetail(idx)
		end
		]]
		
		--[[
		--检测宝物获取情况（统计值）
		local tTreasureAttr = hApi.GetTreasureAttrFinishTag() --统计值
		local tAttr = LuaGetTreasureAttrList() --本地宝物属性位值表
		--如果统计值和本地存档不一致，需要上传最新的本地值
		local bSamed = true
		for attr = 1, hVar.TREASURE_ATTR.ATTR_MAXCOUNT do
			local attrIncreaseType = hVar.TREASURE_ATTR_INCREASE_TYPE_LIST[attr]
			if (attrIncreaseType == hVar.TREASURE_ATTR_INCREASE_TYPE.COVER) then --覆盖型
				local v1 = tTreasureAttr[attr] or 0
				local v2 = tAttr[attr] or 0
				if (v1 ~= v2) then
					bSamed = false
					break
				end
			end
		end
		--上传本局宝物属性位值（统计值）
		if (not bSamed) then
			--玩家请求上传宝物属性位值
			local sessionId = 0
			local orderId = 0
			local battleId = os.time()
			local mapName = hVar.tab_string["__TEXT_BTN_STATISTICS"] --"统计"
			SendCmdFunc["upload_treasure_attr"](sessionId, orderId, battleId, mapName, tTreasureAttr)
		end
		]]
		
	end
	
	--函数：收到玩家开宝箱结果事件
	on_receive_open_chest_event = function(result, chestId, gamecoinNum)
		print("on_receive_open_chest_event", result, chestId, gamecoinNum)
		local _frm = hGlobal.UI.PhoneChestFrame
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--取消挡操作
		hUI.NetDisable(0)
		
		if (result == 1) then --成功
			--更新本地缓存
			for i = 1, #current_chestInfo, 1 do
				if (current_chestInfo[i].id == chestId) then --找到了
					local tabChest = hVar.tab_chest[chestId] or {}
					local icon = tabChest.icon
					local width = tabChest.width or 0
					local height = tabChest.height or 0
					local itemType = tabChest.itemType
					local shopItemId = tabChest.shopItemId --商品id
					local tabShopItem = hVar.tab_shopitem[shopItemId] or {}
					local debrisOpenNum = tabShopItem.debrisNum or 0 --开箱子需要数量
					local costGameCoin = tabShopItem.rmb or 0 --消耗的游戏币
					local num = 0
					
					if (itemType == hVar.ITEM_TYPE.CHEST_REDEQUIP) then --神器宝箱
						debrisOpenNum = costGameCoin
					end
					
					if (itemType == hVar.ITEM_TYPE.CHEST_WEAPON_GUN) then --武器枪宝箱
						num = LuaGetTankWeaponGunChestNum()
					elseif (itemType == hVar.ITEM_TYPE.CHEST_TACTIC) then --战术宝箱
						num = LuaGetTankTacticChestNum()
						_nShouldUpdateTactics = 1
					elseif (itemType == hVar.ITEM_TYPE.CHEST_PET) then --宠物宝箱
						num = LuaGetTankPetChestNum()
					elseif (itemType == hVar.ITEM_TYPE.CHEST_EQUIP) then --装备宝箱
						num = LuaGetTankEquipChestNum()
					elseif (itemType == hVar.ITEM_TYPE.CHEST_REDEQUIP) then --神器宝箱
						num = gamecoinNum --当前游戏币
					end
					
					current_chestInfo[i].num = num
					
					--更新当前宝物碎片数量
					local ctrli = _frmNode.childUI["BillboardNode" .. i]
					if ctrli then
						--更新文字
						ctrli.childUI["debrisNum"]:setText(num .. "/" .. debrisOpenNum)
						
						--更新颜色
						if (num >= debrisOpenNum) then --可以开启
							ctrli.childUI["debrisNum"].handle.s:setColor(ccc3(0, 255, 0))
						else
							ctrli.childUI["debrisNum"].handle.s:setColor(ccc3(255, 0, 0))
						end
						
						if (itemType == hVar.ITEM_TYPE.CHEST_REDEQUIP) then --神器宝箱
							--更新文字
							ctrli.childUI["debrisNum"]:setText(costGameCoin)
							
							--更新颜色
							if (num >= debrisOpenNum) then --可以开启
								ctrli.childUI["debrisNum"].handle.s:setColor(ccc3(255, 255, 255))
							else
								ctrli.childUI["debrisNum"].handle.s:setColor(ccc3(255, 0, 0))
							end
						end
						
						--更新叹号
						if (num >= debrisOpenNum) then --可以开启
							ctrli.childUI["tanhao"].handle._n:setVisible(true)
						else
							ctrli.childUI["tanhao"].handle._n:setVisible(false)
						end
					end
				end
			end
			
			--播放音效
			hApi.PlaySound("getcard")
			
			--隐藏宝物升级操作界面
			if hGlobal.UI.ChestLvUpInfoFrm then
				hGlobal.UI.ChestLvUpInfoFrm:del()
				hGlobal.UI.ChestLvUpInfoFrm = nil
			end
			
			--[[
			--更新当前宝物详细信息
			if (current_focus_billboardEx_idx > 0) then
				local idx = current_focus_billboardEx_idx
				current_focus_billboardEx_idx = 0
				OnRefreshTreasureDetail(idx)
			end
			]]
		end
	end
	
	--函数：收到玩家兑换藏宝图的回调事件
	on_receive_open_cangbaotu_event_chest = function(result, good, reward)
		local _frm = hGlobal.UI.PhoneChestFrame
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--取消挡操作
		hUI.NetDisable(0)
		
		if (result == 1) then --成功
			--重新发起查询，获取玩家宝物信息
			SendCmdFunc["query_treasure_info"]()
		end
	end
	
	--函数：收到程序进入后台的回调事件
	on_enter_background_event_Treasure = function(flag)
		--print("收到程序进入后台的回调事件", flag)
		--current_enter_bg = flag --当前程序是否在后台（如果进入后台，就不用定时器刷新排行榜情况）
		if (flag == 1) then
			--移除timer
			--print("移除timer")
			--hApi.clearTimer("__RANK_QUERY_TIMER_CHEST__")
			--暂停定时器
			--hApi.PauseTimer()
		elseif (flag == 0) then
			--添加timer
			--print("添加timer")
			--hApi.addTimerForever("__RANK_QUERY_TIMER_CHEST__", hVar.TIMER_MODE.GAMETIME, QUERY_DELTA_SECOND * 1000, on_query_billboard_info_timer_PVP_Endless)
			--恢复定时器
			--hApi.ResumeTimer()
		end
	end
	
	--函数：横竖屏切换事件
	on_SpinScreen_event_chest = function()
		local _frm = hGlobal.UI.PhoneChestFrame
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--关闭本界面
		OnClosePanel()
		
		--[[
		--取消监听打开宝箱界面通知事件
		hGlobal.event:listen("LocalEvent_Phone_ShowPhoneChestFrame", "__ShowTreasureFrm", nil)
		--取消监听关闭宝箱界面事件
		hGlobal.event:listen("clearPhoneChestFrm", "__CloseTreasureFrm", nil)
		]]
		
		--删除本界面
		if hGlobal.UI.PhoneChestFrame then --删除上一次的宝箱界面
			hGlobal.UI.PhoneChestFrame:del()
			hGlobal.UI.PhoneChestFrame = nil
		end
		if hGlobal.UI.PvpGeneralTipInfoFrame then --删除上一次的宝箱tip界面
			hGlobal.UI.PvpGeneralTipInfoFrame:del()
			hGlobal.UI.PvpGeneralTipInfoFrame = nil
		end
		
		--重新加载
		hGlobal.UI.InitPhoneChestFrm("reload")
		
		--触发事件，显示宝箱界面
		hGlobal.event:event("LocalEvent_Phone_ShowPhoneChestFrame")
	end
	
	--函数：获得第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离
	getUpDownOffset = function()
		local _frm = hGlobal.UI.PhoneChestFrame
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--第一个DLC地图面板的数据
		local DLCMapInfoBtn1 = _frmNode.childUI["BillboardNode1"]
		local btn1_cx, btn1_cy = 0, 0 --第一个DLC地图面板中心点位置
		local btn1_ly = 0 --第一个DLC地图面板最上侧的x坐标
		local delta1_ly = 0 --第一个DLC地图面板距离上侧边界的距离
		if DLCMapInfoBtn1 then
			btn1_cx, btn1_cy = DLCMapInfoBtn1.data.x, DLCMapInfoBtn1.data.y --第一个排行榜中心点位置
			btn1_ly = btn1_cy + BILLBOARD_HEIGHT / 2 --第一个排行榜最上侧的x坐标
			delta1_ly = btn1_ly + 90 --第一个排行榜距离上侧边界的距离
		end
		
		--最后一个DLC地图面板的数据
		local DLCMapInfoBtnN = _frmNode.childUI["BillboardNode" .. current_chestInfo.num]
		local btnN_cx, btnN_cy = 0, 0 --最后一个DLC地图面板中心点位置
		local btnN_ry = 0 --最后一个DLC地图面板最下侧的x坐标
		local deltNa_ry = 0 --最后一个DLC地图面板距离下侧边界的距离
		if DLCMapInfoBtnN then
			btnN_cx, btnN_cy = DLCMapInfoBtnN.data.x, DLCMapInfoBtnN.data.y --最后一个排行榜中心点位置
			btnN_ry = btnN_cy - BILLBOARD_HEIGHT / 2 --最后一个排行榜最下侧的x坐标
			deltNa_ry = btnN_ry + 710 --最后一个排行榜距离下侧边界的距离
		end
		
		--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
		
		return delta1_ly, deltNa_ry
	end
	
	--函数：异步绘制单条宝物条目的内容（异步）
	OnCreateSingleTreasureData_PVP_async = function(index, tChest)
		local _frm = hGlobal.UI.PhoneChestFrame
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local i = index
		local ranking = i
		local parent = _BTC_pClipNode_Rankboard_endless
		
		local validIdx = i
		local xn = (validIdx % BILLBOARD_X_NUM) --xn
		if (xn == 0) then
			xn = BILLBOARD_X_NUM
		end
		local yn = (validIdx - xn) / BILLBOARD_X_NUM + 1 --yn
		
		local offsetX = BILLBOARD_OFFSETX + (xn - 1) * (BILLBOARD_WIDTH + BILLBOARD_DISTANCEX)
		local offsetY = BILLBOARD_OFFSETY - (yn - 1) * (BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY)
		
		local offsetList =
		{
			[1] = {x = -67,y = 52,}, --武器枪宝箱
			[2] = {x = -(BILLBOARD_WIDTH + BILLBOARD_DISTANCEX)-67, y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY)+32,}, --战术宝箱
			[3] = {x = -158-82,y = -70,}, --宠物宝箱
			[4] = {x = -67,y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY) + 14,}, --装备宝箱
			[5] = {x = 52-82,y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY) + 14,}, --装备宝箱
			[6] = {x = -(BILLBOARD_WIDTH + BILLBOARD_DISTANCEX)+52-82,y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY) + 14,}, --装备宝箱
		}
		
		local id = tChest[i].id
		
		--排行的父控件
		_frmNode.childUI["BillboardNode" .. i] = hUI.button:new({ --作为button只是为了作为父控件，坐标正常
			parent = parent,
			model = "misc/mask.png",
			--model = -1,
			x = offsetX + offsetList[i].x,
			y = offsetY + offsetList[i].y,
			w = BILLBOARD_WIDTH,
			h = BILLBOARD_HEIGHT,
		})
		_frmNode.childUI["BillboardNode" .. i].handle.s:setOpacity(0) --只响应事件，不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "BillboardNode" .. i
		
		--存储异步待绘制消息列表
		local tRecordI =
		{
			index = index,
			tChest = tChest,
		}
		current_async_paint_list[index] = tRecordI
	end
	
	--函数：绘制单条宝物条目的内容
	OnCreateSingleTreasureData_PVP = function(index, tChest)
		local _frm = hGlobal.UI.PhoneChestFrame
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local i = index
		local ranking = i
		local parent = _BTC_pClipNode_Rankboard_endless
		
		local validIdx = i
		local xn = (validIdx % BILLBOARD_X_NUM) --xn
		if (xn == 0) then
			xn = BILLBOARD_X_NUM
		end
		local yn = (validIdx - xn) / BILLBOARD_X_NUM + 1 --yn
		
		local offsetX = BILLBOARD_OFFSETX + (xn - 1) * (BILLBOARD_WIDTH + BILLBOARD_DISTANCEX)
		local offsetY = BILLBOARD_OFFSETY - (yn - 1) * (BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY)
		
		local offsetList =
		{
			[1] = {x = -67,y = 52,}, --武器枪宝箱
			[2] = {x = -(BILLBOARD_WIDTH + BILLBOARD_DISTANCEX)-67, y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY)+32,}, --战术宝箱
			[3] = {x = -158-82,y = -70,}, --宠物宝箱
			[4] = {x = -67,y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY) + 14,}, --装备宝箱
			[5] = {x = 52-82,y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY) + 14,}, --装备宝箱
			[6] = {x = -(BILLBOARD_WIDTH + BILLBOARD_DISTANCEX)+52-82,y = -(BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY) + 14,}, --装备宝箱
		}
		
		local id = tChest[i].id
		local num = tChest[i].num
		local tabChest = hVar.tab_chest[id] or {}
		local icon = tabChest.icon
		local width = tabChest.width or 0
		local height = tabChest.height or 0
		local itemType = tabChest.itemType
		local shopItemId = tabChest.shopItemId --商品id
		local tabShopItem = hVar.tab_shopitem[shopItemId] or {}
		local debrisOpenNum = tabShopItem.debrisNum or 0 --开箱子需要数量
		local costGameCoin = tabShopItem.rmb or 0 --消耗的游戏币
		
		if (itemType == hVar.ITEM_TYPE.CHEST_REDEQUIP) then --神器宝箱
			debrisOpenNum = costGameCoin
		end
		
		--排行的父控件
		_frmNode.childUI["BillboardNode" .. i] = hUI.button:new({ --作为button只是为了作为父控件，坐标正常
			parent = parent,
			model = "misc/mask.png",
			--model = -1,
			x = offsetX + offsetList[i].x,
			y = offsetY + offsetList[i].y,
			--z = nodeZIndex,
			w = BILLBOARD_WIDTH,
			h = BILLBOARD_HEIGHT,
		})
		_frmNode.childUI["BillboardNode" .. i].handle.s:setOpacity(0) --只响应事件，不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "BillboardNode" .. i
		
		--[[
		--宝箱底图
		_frmNode.childUI["BillboardNode" .. i].childUI["iconBG"] = hUI.image:new({
			parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
			model = "misc/chest/chest_bg.png",
			x = 0,
			y = 0,
			w = 200 * 0.9,
			h = 200 * 0.9,
		})
		]]
		
		--宝箱图标
		_frmNode.childUI["BillboardNode" .. i].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
			model = icon,
			x = 0,
			y = 20,
			z = 1,
			w = width * 0.6,
			h = height * 0.6,
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
		_frmNode.childUI["BillboardNode" .. i].childUI["icon"].handle._n:runAction(CCRepeatForever:create(sequence))
		--未解锁的宝物暗淡处理
		--if (num == 0) then
		--	hApi.AddShader(_frmNode.childUI["BillboardNode" .. i].childUI["icon"].handle.s, "gray") --灰掉
		--end
		
		--碎片数量偏移
		local debrisOffsetList =
		{
			[1] = {x = -4,y = 12,}, --武器枪宝箱
			[2] = {x = -4, y = 12,}, --战术宝箱
			[3] = {x = 26, y = -53,}, --宠物宝箱
			[4] = {x = -4,y = 11,}, --装备宝箱
			[5] = {x = 34,y = 11,}, --装备宝箱
			[6] = {x = 34,y = 11,}, --装备宝箱
		}
		
		--碎片数量
		_frmNode.childUI["BillboardNode" .. i].childUI["debrisNum"] = hUI.label:new({
			parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
			width = 500,
			align = "MC",
			x = 0 + debrisOffsetList[i].x,
			y = -86 + debrisOffsetList[i].y,
			size = 22,
			font = "numWhite",
			border = 0,
			text = num .. "/" .. debrisOpenNum,
		})
		if (num >= debrisOpenNum) then --可以开启
			_frmNode.childUI["BillboardNode" .. i].childUI["debrisNum"].handle.s:setColor(ccc3(0, 255, 0))
		else
			_frmNode.childUI["BillboardNode" .. i].childUI["debrisNum"].handle.s:setColor(ccc3(255, 0, 0))
		end
		
		if (itemType == hVar.ITEM_TYPE.CHEST_REDEQUIP) then --神器宝箱
			hApi.safeRemoveT(_frmNode.childUI["BillboardNode" .. i].childUI, "debrisNum")
			
			--氪石图标
			_frmNode.childUI["BillboardNode" .. i].childUI["img_rmb"] = hUI.image:new({
				parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
				model = "misc/skillup/keshi.png",
				align = "MC",
				x = 0 + debrisOffsetList[i].x - 20,
				y = -86 + debrisOffsetList[i].y,
				w = 36,
				h = 36,
			})
			
			--游戏币数量
			_frmNode.childUI["BillboardNode" .. i].childUI["debrisNum"] = hUI.label:new({
				parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
				width = 500,
				align = "LC",
				x = 0 + debrisOffsetList[i].x + 6,
				y = -86 + debrisOffsetList[i].y,
				size = 22,
				font = "num",
				border = 0,
				text = debrisOpenNum,
			})
			if (num >= debrisOpenNum) then --可以开启
				_frmNode.childUI["BillboardNode" .. i].childUI["debrisNum"].handle.s:setColor(ccc3(255, 255, 255))
			else
				_frmNode.childUI["BillboardNode" .. i].childUI["debrisNum"].handle.s:setColor(ccc3(255, 0, 0))
			end
		end
		
		if (index % BILLBOARD_X_NUM == 0) then
			--[[
			--台子
			_frmNode.childUI["BillboardNode" .. i].childUI["desk2"] = hUI.image:new({
				parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
				--x = OFFSET_DX - 10,
				x = -BILLBOARD_WIDTH - BILLBOARD_DISTANCEX,
				y = -BILLBOARD_WIDTH / 2,
				z = -1,
				model = "misc/treasure/line.png",
				align = "MC",
				w = 2,
				h = 636,
			})
			_frmNode.childUI["BillboardNode" .. i].childUI["desk2"].handle.s:setRotation(90)
			]]
		end
		
		--叹号偏移
		local tanhaoOffsetList =
		{
			[1] = {x = -80, y = 156,}, --武器枪宝箱
			[2] = {x = -80, y = 157,}, --战术宝箱
			[3] = {x = -128, y = 293,}, --宠物宝箱
			[4] = {x = -80, y = 155,}, --装备宝箱
			[5] = {x = -148, y = 178,}, --神器宝箱
			[6] = {x = -80, y = 293,}, --
		}
		
		--提示可升级的叹号
		_frmNode.childUI["BillboardNode" .. i].childUI["tanhao"] = hUI.button:new({ --作为按钮只是为了挂载子控件
			parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
			model = "misc/chest/green_point3.png",
			x = 0 + debrisOffsetList[i].x + tanhaoOffsetList[i].x,
			y = -86 + debrisOffsetList[i].y + tanhaoOffsetList[i].y,
			z = 2,
			--w = 46,
			--h = 46,
			scale = 1.0,
		})
		if (num < debrisOpenNum) then --可以开启
			hApi.AddShader(_frmNode.childUI["BillboardNode" .. i].childUI["tanhao"].handle.s, "gray") --灰掉
		end
		--[[
		_frmNode.childUI["BillboardNode" .. i].childUI["tanhao"].childUI["light"] = hUI.button:new({ --作为按钮只是为了挂载子控件
			parent = _frmNode.childUI["BillboardNode" .. i].childUI["tanhao"].handle._n,
			model = "misc/chest/green_point2.png",
			x = 0,
			y = 0,
			z = 2,
			w = 46,
			h = 46,
		})
		local act1 = CCFadeIn:create(0.6)
		local act2 = CCFadeOut:create(0.6)
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		local sequence = CCSequence:create(a)
		_frmNode.childUI["BillboardNode" .. i].childUI["tanhao"].childUI["light"].handle.s:runAction(CCRepeatForever:create(sequence))
		_frmNode.childUI["BillboardNode" .. i].childUI["tanhao"].handle._n:setVisible(false) --一开始不显示叹号
		--if (num >= 0) then --可以开启
		if (num >= debrisOpenNum) then --可以开启
			_frmNode.childUI["BillboardNode" .. i].childUI["tanhao"].handle._n:setVisible(true)
		end
		]]
		--选中框
		_frmNode.childUI["BillboardNode" .. i].childUI["selectbox"] = hUI.image:new({
			parent = _frmNode.childUI["BillboardNode" .. i].handle._n,
			model = "misc/chest/chest_bg.png",
			x = 0,
			y = 20,
			w = 200 * 0.9,
			h = 200 * 0.9,
		})
		_frmNode.childUI["BillboardNode" .. i].childUI["selectbox"].handle.s:setColor(ccc3(255, 255, 0))
		_frmNode.childUI["BillboardNode" .. i].childUI["selectbox"].handle._n:setVisible(false) --一开始不显示选中框
		--选中框动画
		local act1 = CCDelayTime:create(0.5)
		local act2 = CCSpawn:createWithTwoActions(CCScaleTo:create(2.0, 0.95), CCMoveBy:create(2.0, ccp(0, 5)))
		local act3 = CCDelayTime:create(0.5)
		local act4 = CCSpawn:createWithTwoActions(CCScaleTo:create(2.0, 0.9), CCMoveBy:create(2.0, ccp(0, -5)))
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		a:addObject(act4)
		local sequence = CCSequence:create(a)
		--_frmNode.childUI["BillboardNode" .. i].childUI["selectbox"].handle.s:stopAllActions()
		_frmNode.childUI["BillboardNode" .. i].childUI["selectbox"].handle.s:runAction(CCRepeatForever:create(sequence))
		if (current_focus_billboardEx_idx == index) then --当前选中了宝物
			--print("当前选中了宝物", index)
			_frmNode.childUI["BillboardNode" .. i].childUI["selectbox"].handle._n:setVisible(true)
		end
		
		--[[
		---------------------------------------------------------------------
		--可能存在滑动，校对前一个控件的相对位置
		if _frmNode.childUI["BillboardNode" .. (index - 1)] then --前一个
			if ((index - 1) > 0) then --0控件这里代表我的排名
				local xn_1 = ((index - 1) % BILLBOARD_X_NUM) --xn
				if (xn_1 == 0) then
					xn_1 = BILLBOARD_X_NUM
				end
				local yn_1 = ((index - 1) - xn_1) / BILLBOARD_X_NUM + 1 --yn
				
				--实际相对距离
				local lastX = _frmNode.childUI["BillboardNode" .. (index - 1)].data.x
				local lastY = _frmNode.childUI["BillboardNode" .. (index - 1)].data.y
				local lastChatHeight = (BILLBOARD_HEIGHT + BILLBOARD_DISTANCEY)
				if (yn_1 == yn) then
					lastChatHeight = 0
				end
				--理论相对距离
				local thisX = _frmNode.childUI["BillboardNode" .. (index)].data.x
				local thisY = lastY - lastChatHeight
				local ctrli = _frmNode.childUI["BillboardNode" .. index]
				ctrli.handle._n:setPosition(thisX, thisY)
				ctrli.data.x = thisX
				ctrli.data.y = thisY
			end
		end
		]]
	end
	
	--[[
	--函数：定时向服务器查询当前人族无敌排行数据(timer)
	on_query_billboard_info_timer_PVP_Endless = function()
		--print("函数：定时向服务器查询当前魔龙宝库排行数据(timer) on_query_billboard_info_timer_PVP_Endless")
		local _frm = hGlobal.UI.PhoneChestFrame
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
						--last_query_multy_rzwd_board_time = timestamp
						
						--显示正在网络查询的小菊花
						if _frmNode.childUI["waiting"] then
							_frmNode.childUI["waiting"].handle.s:setVisible(true)
						end
						
						--发起查询服务器系统时间
						SendCmdFunc["refresh_systime"]()
					--end
				end
			--end
		end
	end
	]]
	
	--函数：显示某个指定的宝物详细界面
	OnRefreshTreasureDetail = function(achieve_idx, touchX, touchY)
		local _frm = hGlobal.UI.PhoneChestFrame
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--无效的索引
		if (achieve_idx == 0) then
			return
		end
		
		--宝箱数据
		local tInfo = current_chestInfo[achieve_idx]
		local id = tInfo.id
		local debrisNum = tInfo.num
		local tabChest = hVar.tab_chest[id] or {}
		local icon = tabChest.icon
		local width = tabChest.width or 0
		local height = tabChest.height or 0
		local itemType = tabChest.itemType
		local shopItemId = tabChest.shopItemId --商品id
		local tabShopItem = hVar.tab_shopitem[shopItemId] or {}
		local debrisOpenNum = tabShopItem.debrisNum or 0 --开箱子需要数量
		local costGameCoin = tabShopItem.rmb or 0 --消耗的游戏币
		
		if (itemType == hVar.ITEM_TYPE.CHEST_REDEQUIP) then --神器宝箱
			debrisOpenNum = costGameCoin
		end
		
		--不重复显示
		if (current_focus_billboardEx_idx == achieve_idx) then
			if (debrisNum >= debrisOpenNum) then --可以开启
				--检测gameserver版本号是否为最新
				if (not hApi.CheckGameServerVersionControl()) then
					return
				end
				
				--挡操作
				hUI.NetDisable(30000)
				
				--发送请求开宝箱
				SendCmdFunc["tank_open_chest"](shopItemId)
			else
				--title, titleColor, icon, iconW, iconH, content
				local scale = 0.4
				local chestName = hVar.tab_stringCHEST[id] and hVar.tab_stringCHEST[id][1] or ("未知宝箱" .. id)
				local chestIntro = hVar.tab_stringCHEST[id] and hVar.tab_stringCHEST[id][2] or ("未知宝箱说明" .. id)
				hApi.ShowGeneralMiniTip(chestName, ccc3(255, 255, 0), icon, width*scale, height*scale, chestIntro)
			end
			
			return
		end
		
		--标记选中的排行榜索引值
		local last_achieve_idx = current_focus_billboardEx_idx
		current_focus_billboardEx_idx = achieve_idx
		
		--清空上一次的右侧详细信息界面
		_removeRightDetailFrmFunc()
		
		--清除上次的选中框
		local ctrli = _frmNode.childUI["BillboardNode" .. last_achieve_idx]
		if ctrli then
			if ctrli.childUI["selectbox"] then
				ctrli.childUI["selectbox"].handle._n:setVisible(false)
			end
		end
		
		--显示本次的选中框
		local ctrlI = _frmNode.childUI["BillboardNode" .. achieve_idx]
		if ctrlI then
			if ctrlI.childUI["selectbox"] then
				ctrlI.childUI["selectbox"].handle._n:setVisible(true)
			end
		end
		
		if (debrisNum >= debrisOpenNum) then --可以开启
			--检测gameserver版本号是否为最新
			if (not hApi.CheckGameServerVersionControl()) then
				return
			end
			
			--挡操作
			hUI.NetDisable(30000)
			
			--发送请求开宝箱
			SendCmdFunc["tank_open_chest"](shopItemId)
		else
			local scale = 0.4
			local chestName = hVar.tab_stringCHEST[id] and hVar.tab_stringCHEST[id][1] or ("未知宝箱" .. id)
			local chestIntro = hVar.tab_stringCHEST[id] and hVar.tab_stringCHEST[id][2] or ("未知宝箱说明" .. id)
			hApi.ShowGeneralMiniTip(chestName, ccc3(255, 255, 0), icon, width*scale, height*scale, chestIntro)
		end
	end
	
	--[[
	--函数：更新提示当前哪个分页可以有领取的了
	RefreshBillboardFinishPage = function()
		local _frm = hGlobal.UI.PhoneChestFrame
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--...
	end
	]]
	
	--函数: 动态加载资源
	__DynamicAddRes = function()
		local _frm = hGlobal.UI.PhoneChestFrame
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--加载资源
		--动态加载宝物背景图
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/chest/chest_img_bg3.png")
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/chest/chest_img_bg3.png")
			print("加载宝物背景大图3！")
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
		local _frm = hGlobal.UI.PhoneChestFrame
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--删除资源
		--删除竞技场背景图
		_childUI["panel_bg"].handle._n:removeChild(_childUI["panel_bg"].data.pSprite, true)
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/chest/chest_img_bg3.png")
		if texture then
			CCTextureCache:sharedTextureCache():removeTexture(texture)
			print("清空宝物背景大图3！")
		end
	end
	
	--异步绘制排行榜记录条目的timer
	refresh_rank_board_UI_loop_RZWD_async = function()
		local _frm = hGlobal.UI.PhoneChestFrame
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
				local tChest = tRecordI.tChest
				
				--先删除虚控件
				hApi.safeRemoveT(_frmNode.childUI, "BillboardNode" .. index)
				
				--再创建实体控件
				OnCreateSingleTreasureData_PVP(index, tChest)
				
				table.remove(current_async_paint_list, pivot)
			end
		end
	end
	
	--函数：刷新排行榜界面的滚动
	refresh_rank_board_UI_loop_RZWD = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		--print("current_STATE = " .. current_STATE)
		--如果当前的查询状态是在查询服务器时间，或者查询静态数据，那么不能滚动
		if (current_STATE < 3) then --当前的状态(0:初始化 / 1:正在连接、登入、查询服务器时间 / 3:查询完毕)
			return
		end
		
		local _frm = hGlobal.UI.PhoneChestFrame
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--注意: 如果刚打开界面的瞬间，子控件都被删掉了，而这时滑动屏幕，并且有上一次排行榜缓存数据，逻辑会走到这，但是此时界面还没，会弹框
		if (_frmNode.childUI["BillboardNode1"] == nil) then
			return
		end
		
		--最后一个不存在，直接退出
		if (_frmNode.childUI["BillboardNode" .. current_chestInfo.num] == nil) then
			return
		end
		
		local SPEED = 50 --速度
		--print(b_need_auto_fixing_billboard)
		
		if b_need_auto_fixing_billboard then
			--检测是否滑动到了最顶部或最底部
			local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
			local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
			delta1_ly, deltNa_ry = getUpDownOffset()
			--print(delta1_ly, deltNa_ry)
			--delta1_ly +:在下底线之上 /-:在下底线之下
			--deltNa_ry +:在下底线之上 /-:在下底线之下
			
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
				for i = 1, current_chestInfo.num, 1 do
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
				for i = 1, current_chestInfo.num, 1 do
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
					for i = 1, current_chestInfo.num, 1 do
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
					for i = 1, current_chestInfo.num, 1 do
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
end

--监听打开宝箱界面通知事件
hGlobal.event:listen("LocalEvent_Phone_ShowPhoneChestFrame", "__ShowTreasureFrm", function(callback, bOpenImmediate)
	--触发事件，显示积分、金币界面
	--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
	--[[
	--显示宝箱界面
	hGlobal.UI.PhoneChestFrame:show(1)
	hGlobal.UI.PhoneChestFrame:active()
	
	--打开上一次的分页（默认显示第1个分页:人族无敌排行榜）
	local lastPageIdx = CurrentSelectRecord.pageIdx
	if (lastPageIdx == 0) then
		lastPageIdx = 1
	end
	
	--存储回调事件
	current_funcCallback = callback
	
	CurrentSelectRecord.pageIdx = 0
	CurrentSelectRecord.contentIdx = 0
	OnClickPageBtn(lastPageIdx)
	]]
	
	hGlobal.UI.InitPhoneChestFrm("reload")
	
	--直接打开
	if bOpenImmediate then
		--显示宝箱界面
		hGlobal.UI.PhoneChestFrame:show(1)
		hGlobal.UI.PhoneChestFrame:active()
		
		--打开上一次的分页（默认显示第1个分页:人族无敌排行榜）
		local lastPageIdx = CurrentSelectRecord.pageIdx
		if (lastPageIdx == 0) then
			lastPageIdx = 1
		end
		
		--存储回调事件
		current_funcCallback = callback
		
		CurrentSelectRecord.pageIdx = 0
		CurrentSelectRecord.contentIdx = 0
		OnClickPageBtn(lastPageIdx)
		
		--防止重复调用
		_bCanCreate = false
		
		return
	end
	
	--防止重复调用
	if _bCanCreate then
		_bCanCreate = false
		
		--步骤1: 绘制第一个分页，并将控件设置成初始位置（屏幕外，为步骤二播放动画做准备）
		local actM1 = CCCallFunc:create(function()
			--显示宝箱界面
			hGlobal.UI.PhoneChestFrame:show(1)
			hGlobal.UI.PhoneChestFrame:active()
			
			--打开上一次的分页（默认显示第1个分页:人族无敌排行榜）
			local lastPageIdx = CurrentSelectRecord.pageIdx
			if (lastPageIdx == 0) then
				lastPageIdx = 1
			end
			
			--存储回调事件
			current_funcCallback = callback
			
			CurrentSelectRecord.pageIdx = 0
			CurrentSelectRecord.contentIdx = 0
			OnClickPageBtn(lastPageIdx)
			
			--初始设置坐标
			--主面板设置到左侧屏幕外面
			local _frm = hGlobal.UI.PhoneChestFrame
			local dx = BOARD_WIDTH
			_frm:setXY(_frm.data.x + dx, _frm.data.y)
		end)
		
		--步骤2: 动画进入控件
		local actM2 = CCCallFunc:create(function()
			--本面板
			local _frm = hGlobal.UI.PhoneChestFrame
			
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
		local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
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
hGlobal.event:listen("clearPhoneChestFrm", "__CloseTreasureFrm", function()
	if hGlobal.UI.PhoneChestFrame then
		if (hGlobal.UI.PhoneChestFrame.data.show == 1) then
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
if hGlobal.UI.PhoneChestFrame then --删除上一次的宝箱界面
	hGlobal.UI.PhoneChestFrame:del()
	hGlobal.UI.PhoneChestFrame = nil
end
if hGlobal.UI.ChestLvUpInfoFrm then --删除上一次的宝箱界面界面
	hGlobal.UI.ChestLvUpInfoFrm:del()
	hGlobal.UI.ChestLvUpInfoFrm = nil
end
hGlobal.UI.InitPhoneChestFrm("reload") --测试

--触发事件，显示宝箱界面
hGlobal.event:event("LocalEvent_Phone_ShowPhoneChestFrame", callback)
]]
