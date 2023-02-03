


--PVP铜雀台房间面板
hGlobal.UI.InitBattleRoomFrm_Endless = function(mode)
	--不重复创建PVP对战房间面板
	--if hGlobal.UI.PhoneBattleRoomFrm_Endless then --PVP对战房间面板
	--	return
	--end
	local tInitEventName = {"localEvent_ShowPhone_PVPRoomFrm_Endless", "__ShowPVPRoomFrm_Endless",}
	if (mode ~= "include") then
		return tInitEventName
	end
	
	local BOARD_WIDTH = 960 --PVP房间面板的宽度
	local BOARD_HEIGHT = 640 --PVP房间面板的高度
	local BOARD_OFFSETY = 0 --PVP房间面板y偏移中心点的值
	local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 --PVP房间面板的x位置（最左侧）
	local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --PVP房间面板的y位置（最顶侧）
	
	local PAGE_BTN_LEFT_X = 120 --第一个分页按钮的x偏移
	local PAGE_BTN_LEFT_Y = -23 --第一个分页按钮的y偏移
	local PAGE_BTN_OFFSET_Y = 94 --每个分页按钮的间距
	
	--临时UI管理
	local pagerightRemoveFrmList = {} --分页控件集（在本分页下，一直存在的控件）
	local leftRemoveFrmList = {} --左侧控件集
	local rightRemoveFrmList = {} --右侧控件集
	local _removePageFrmFunc = hApi.DoNothing --清空分页所有的临时控件（在本分页下，一直存在的控件）
	local _removeLeftFrmFunc = hApi.DoNothing --清空左侧所有的临时控件
	local _removeRightFrmFunc = hApi.DoNothing --清空右侧所有的临时控件
	
	--局部函数
	local OnClickPageBtn = hApi.DoNothing --点击分页按钮
	local OnClearAllEventsAndTimers = hApi.DoNothing --移除所有的监听、timer、clipNode
	
	--分页2：铜雀台logo展示分页
	local OnCreateTongQueTaiLogoShowFrame = hApi.DoNothing --创建铜雀台界面（第2个分页）
	local on_receive_connect_back_event_page2_0 = hApi.DoNothing --收到连接结果回调
	local on_receive_login_back_event_page2_0 = hApi.DoNothing --收到登入结果回调
	local on_receive_multy_roomcfg_event_page2_0 = hApi.DoNothing --收到铜雀台今日生效配置信息
	local on_receive_multy_roomcfg_refresh_UI_page2_0 = hApi.DoNothing --收到铜雀台今日生效配置信息，刷新界面
	
	--分页2的子分页1：对战房间子分页
	local OnCreateBattleRoomSubFrame_page2 = hApi.DoNothing --创建娱乐房界面（第2个分页的子分页1）
	local on_receive_ping_event_page2 = hApi.DoNothing --收到pvp的ping值回调
	local on_receive_connect_back_event_page2 = hApi.DoNothing --收到连接结果回调
	local on_receive_login_back_event_page2 = hApi.DoNothing --收到登入结果回调
	local on_receive_RoomIdList_event_page2 = hApi.DoNothing --收到房间id列表回调
	local OnCreateSingleRoomAbstractFrame_page2 = hApi.DoNothing --创建单个房间的摘要信息界面
	local on_receive_RoomAbstract_event_page2 = hApi.DoNothing --收到房间摘要回调
	local on_receive_SingleRoomAbstractChanged_event_page2 = hApi.DoNothing --收到单个房间摘要信息发生变化回调
	local on_receive_RoomEvent_event_page2 = hApi.DoNothing --收到房间状态变化事件回调
	local on_receive_RoomInfo_event_page2 = hApi.DoNothing --收到自己所处的房间信息变化事件回调
	local on_single_show_ready_state_UI = hApi.DoNothing --单独绘制房间的某位置玩家准备状态变化界面
	local on_single_show_room_config_list_UI = hApi.DoNothing --单独绘制房间的某位置配置卡牌信息界面
	local on_receive_LeaveRoom_event_page2 = hApi.DoNothing --收到离开房间事件回调
	local on_receive_EnterRoom_Fail_event_page2 = hApi.DoNothing --收到加入房间失败事件回调
	--local refresh_room_general_loop_page1 = hApi.DoNothing --分页1的通用timer1事件
	local on_receive_Pvp_NetLogicError_event = hApi.DoNothing --收到pvp游戏错误提示事件回调
	local on_receive_Pvp_SwitchGame_event = hApi.DoNothing --收到切换场景事件回调
	local CheckPvpVersionControl = hApi.DoNothing --检测pvp的版本号
	local CheckPvpEscapePunish = hApi.DoNothing --检测pvp是否在逃跑惩罚中
	local CheckPvpEscapeMaxCount = hApi.DoNothing --检测pvp逃跑是否到上限
	local CheckPvpSurrenderPunish = hApi.DoNothing --检测pvp是否在投降惩罚中
	local CheckPvpCfgCardOK = hApi.DoNothing --检测pvp的配卡是否完整
	local CheckPvpCoinOK = hApi.DoNothing --检测pvp的兵符是否足够
	local CheckCheatOK = hApi.DoNothing --检测玩家是否作弊
	local CheckBrushOK = hApi.DoNothing --检测玩家是否在刷
	local CheckPvpBattleOpenState = hApi.DoNothing --检测pvp是否开放对战（活动300和301的控制）
	--local CalPvpLevel = hApi.DoNothing --计算pvp的等级
	local OnCreateRoomButton_page2 = hApi.DoNothing --创建房间操作
	local OnLeaveRoomButton_page2 = hApi.DoNothing --离开房间操作
	local OnGetPvpCoinButton = hApi.DoNothing --领取兵符操作
	local refresh_pvproom_UI_loop_page2 = hApi.DoNothing --定时刷新PVP房间界面的滚动
	local refresh_room_gametime_loop_page21 = hApi.DoNothing --定时刷新房间内的所有在游戏中的时间
	local refresh_room_list_loop_page2 = hApi.DoNothing --定时刷新房间列表
	local OnConnectRoomButton_page2 = hApi.DoNothing --点击重新连接房间按钮
	local OnEnterRoomButton_page2 = hApi.DoNothing --点击加入某个房间按钮
	local OnReadyRoomButton_page2 = hApi.DoNothing --点击房间内准备按钮
	local OnCancelReadyRoomButton_page2 = hApi.DoNothing --点击房间内取消准备按钮
	--local OnClickSelectComputerButton_page2 = hApi.DoNothing --点击房间内选择电脑按钮
	--local OnClickCancelComputerButton_page2 = hApi.DoNothing --点击房间内取消电脑按钮
	--local OnClickIsEquipButton_page1 = hAp2.DoNothing --点击房间是否允许电脑的按钮
	--local OnChangePosTypeRoomButton_page2 = hApi.DoNothing --点击修改房间内位置类型按钮 0空 1玩家 2简单电脑 3中等电脑 4困难电脑
	local OnBeginGameRoomButton_page2 = hApi.DoNothing --点击房间开始游戏按钮
	local on_receive_Pvp_BattleCfg_event_page2 = hApi.DoNothing --收到配置卡组返回事件
	local on_receive_Pvp_baseInfoRet_page2 = hApi.DoNothing --收到我的基础信息返回事件
	local on_receive_UI_BattleCfg_Complete_page2 = hApi.DoNothing --收到配置卡组界面操作完成事件
	local refresh_pve_multy_room_timer = hApi.DoNothing --定时刷新铜雀台的开放时间
	
	
	--分页2的子分页4：配置卡牌分页
	local OnCreateConfigCardSubFrame_page2 = hApi.DoNothing --配置卡牌分页（第2个分页的子分页4）
	local On_cover_host_card_config_UI_page2 = hApi.DoNothin --将服务器的卡牌配置刷到本地的界面
	local On_create_single_herocard_config_card = hApi.DoNothing --创建单个英雄卡牌
	local On_create_single_towercard_config_card = hApi.DoNothing --创建单个塔卡牌
	local On_create_single_armycard_config_card = hApi.DoNothing --创建单个兵种卡牌
	local On_create_single_herocard_config_card_tiny = hApi.DoNothing --创建单个英雄卡牌（简版）
	local On_create_single_towercard_config_card_tiny = hApi.DoNothing --创建单个塔卡牌（简版）
	local On_create_single_armycard_config_card_tiny = hApi.DoNothing --创建单个兵种卡牌（简版）
	local refresh_pvproom_UI_loop_page24 = hApi.DoNothing --定时刷新PVP选卡界面的滚动2-4
	local On_show_herocard_detail_info = hApi.DoNothing --显示英雄卡牌的详细信息
	local On_show_towercard_detail_info = hApi.DoNothing --显示塔卡牌的详细信息
	local On_show_armycard_detail_info = hApi.DoNothing --显示兵种卡的详细信息
	local On_add_or_remove_Cfg_button = hApi.DoNothing --显示右侧"加入配置"/"移除配置"按钮
	local On_create_card_selectbox = hApi.DoNothing --创建卡牌的选中框
	local On_delete_card_selectbox = hApi.DoNothing --删除卡牌的选中框
	local On_refresh_single_hero_card = hApi.DoNothing --刷新单张英雄卡牌 
	local On_refresh_single_army_card = hApi.DoNothing --刷新单张兵种卡牌 
	local AddCardToConfig = hApi.DoNothing --将某个卡牌加入到配置栏
	local RemoveCardFromConfig = hApi.DoNothing --将某个卡牌从配置栏移除
	local IsCompareTwoConfigCardsSame = hApi.DoNothing --比较两套卡组，是否一致
	local UploadClientConfigCard_page2 = hApi.DoNothing --将本地的卡牌配置上传到服务器
	
	
	--分页1的子分页0：铜雀台今日生效卡牌
	local current_TakeEffectCfg = nil --铜雀台生效表
	
	--分页1的子分页1：铜雀台PVP娱乐房相关参数
	local PVPROOM =
	{
		WIDTH = 400, --PVP房间宽度
		HEIGHT = 180, --PVP房间高度
		OFFSET_X = 0, --PVP房间统一偏移x
		OFFSET_Y = 28, --PVP房间统一偏移y
	}
	local PVPROOM_BOARD_HEIGHT = 366 --PVP房间高度
	local PVPROOM_X_NUM = 2 --PVP房间x的数量
	local PVPROOM_Y_NUM = 2 --PVP房间y的数量
	local PVPROOM_MAX_SPEED = 50 --最大速度
	local PVPROOM_COLOR_RATE_MIN = 1 --对于不同比例值（逃跑率、掉线率，等）的最小显示值
	local PVPROOM_COLOR_RATE_TABLE = --对于不同比例值（逃跑率、掉线率，等）的颜色
	{
		{0, ccc3(255, 255, 255),},
		{5, ccc3(255, 255, 0),},
		{10, ccc3(255, 128, 0),},
		{15, ccc3(255, 0, 0),},
	}
	
	--可变参数1-1
	local ROOM_ESCAPE_MAX_COUNT = 100000000 --pvp掉线最大允许的次数
	
	local current_connect_state = 0 --连接状态
	local current_login_state = 0 --登入状态
	local current_PlayerId = 0 --本地玩家id
	local current_pvplevel = 1 --本地的竞技场等级
	local current_pvpcoin = 0 --本地的竞技场兵符
	local current_gamecoin = 0 --本地的游戏币
	local current_evaluateStar = 0 --本地的星星
	local current_Room_page1 = nil --自己所处的房间
	local current_RoomId_page1 = 0 --自己所处的房间id
	local current_RoomEnterTime_page1 = 0 --自己所处的房间进入的时间（服务器时间）
	local current_RoomBeginTime_page1 = -1 --自己所处的房间双方都准备好的时间（服务器时间）
	local current_page1_is_roomlist = true --当前page1是否是房间列表状态
	local current_RoomAbstractList_page1 = {} --大厅房间信息摘要列表
	--local current_Room_max_num_page1 = 0 --最大的PVP房间id
	local current_ConfigCardList = nil --我的配置的卡牌列表
	local current_ping_value = 0 --pvp我的ping值
	local current_online_num = 0 --pvp房间在线人数
	local current_matchuserInEnter = 0 --pvp匹配中人数
	local current_matchuserInGame = 0 --pvp游戏中人数
	local current_matchovertime = 0 --pvp匹配超时人数
	local current_AllPlayerCfgList = {} --pvp铜雀台所有玩家的配置信息表
	
	--控制参数1-1
	--local click_pos_x_pvproom_page1 = 0 --开始按下的坐标x
	--local click_pos_y_pvproom_page1 = 0 --开始按下的坐标y
	--local last_click_pos_y_pvproom_page1 = 0 --上一次按下的坐标x
	--local last_click_pos_y_pvproom_page1 = 0 --上一次按下的坐标y
	--local draggle_speed_y_pvproom_page1 = 0 --当前滑动的速度x
	--local selected_pvproomEx_idx_page1 = 0 --选中的PVP房间ex索引
	--local click_scroll_pvproom_page1 = false --是否在滑动PVP房间中
	--local b_need_auto_fixing_pvproom_page1 = false --是否需要自动修正
	--local friction_pvproom_page1 = 0 --阻力
	
	--分页2的子分页1
	--可变参数2-1
	local current_focus_pvproomEx_idx_page2 = 0 --当前显示的PVP房间ex的索引值
	local last_room_query_time_page2 = -math.huge --上一次timer取房间列表的时间
	local QUERY_ROOM_DELTA_SECOND_PAGE2 = 30 --查询房间列表的间隔秒数（单位: 秒）
	local last_room_gametime_time_page2 = -math.huge --上一次timer取房间游戏时间的时间
	local QUERY_ROOM_GAMETIME_DELTA_SECOND_PAGE2 = 1 --查询房间游戏时间的间隔秒数
	local ROOM_NUM_MAX_NUM_PAGE2 = 50 --房间最大数量
	
	--local current_connect_state = 0 --连接状态
	--local current_login_state = 0 --登入状态
	--local current_PlayerId = 0 --本地玩家id
	--local current_gamecoin = 0 --本地的游戏币
	local current_Room_page2 = nil --自己所处的房间
	local current_RoomId_page2 = 0 --自己所处的房间id
	local current_RoomAbstractList_page2 = {} --大厅房间信息摘要列表
	local current_Room_max_num_page2 = 0 --最大的PVP房间id
	--local current_ConfigCardList = nil --配置的卡牌列表
	--local current_ping_value = 0 --pvp我的ping值
	--local current_online_num = 0 --pvp房间在线人数
	
	--控制参数2-1
	local click_pos_x_pvproom_page2 = 0 --开始按下的坐标x
	local click_pos_y_pvproom_page2 = 0 --开始按下的坐标y
	local last_click_pos_y_pvproom_page2 = 0 --上一次按下的坐标x
	local last_click_pos_y_pvproom_page2 = 0 --上一次按下的坐标y
	local draggle_speed_y_pvproom_page2 = 0 --当前滑动的速度x
	local selected_pvproomEx_idx_page2 = 0 --选中的PVP房间ex索引
	local click_scroll_pvproom_page2 = false --是否在滑动PVP房间中
	local b_need_auto_fixing_pvproom_page2 = false --是否需要自动修正
	local friction_pvproom_page2 = 0 --阻力
	
	--分页1的子分页4
	local CONFIG_CARD_WIDTH = 88 --配置卡牌的宽度
	local CONFIG_CARD_HEIGHT = 110 --配置卡牌的高度
	local CONFIG_CARD_OSSSET_XL = 125 --第一个配置卡牌的偏移值x左
	local CONFIG_CARD_OSSSET_Y = -68 --第一个配置卡牌的偏移值y上
	local CONFIG_CARD_DISTANCE_X = 93 --每个配置卡牌的x间距
	local CONFIG_CARD_DISTANCE_Y = 115 --每个配置卡牌的y间距
	local CONFIG_NUM_MAX = 12 --最多配置12项
	local CONFIG_COLS = 6 --每行最多6项
	local SELECT_NUM_MAX =
	{
		HERO = 2, --最多选择英雄的数量
		TOWER = 2, --最多选择塔类技能卡的数量
		ARMY_ATK = 0, --最多选择进攻兵种卡的数量
		ARMY_DEF = 0, --最多选择防守兵种卡的数量
	}
	--控制参数2-4
	local click_pos_x_pvproom_page14 = 0 --开始按下的坐标x
	local click_pos_y_pvproom_page14 = 0 --开始按下的坐标y
	local last_click_pos_y_pvproom_page14 = 0 --上一次按下的坐标x
	local last_click_pos_y_pvproom_page14 = 0 --上一次按下的坐标y
	local draggle_speed_y_pvproom_page14 = 0 --当前滑动的速度x
	local selected_pvproomEx_idx_page14 = 0 --选中的PVP房间ex索引
	local click_scroll_pvproom_page14 = false --是否在滑动PVP房间中
	local b_need_auto_fixing_pvproom_page14 = false --是否需要自动修正
	
	--变化参数2-4
	local PVP_MATCH_MAX_TIME = 60 --pvp匹配的最大时间60秒
	local current_tCfgCard_DragCtrls = {} --滑动的控件集
	local current_tCfgCard = {} --已选好的控件集
	local current_tCfgCard_Data = {} --已选好的控件集数据部分
	local current_cfg_selected_ctrl = nil --当前选中的配置控件
	
	--当前选中的记录
	local CurrentSelectRecord = {pageIdx = 0, contentIdx = 0, cardId = 0,} --当前选择的分页、数据项的信息记录
	
	--hGlobal.UI.InitBattleRoomFrm_Endless = function(mode)
	--不重复创建PVP对战房间面板
	if hGlobal.UI.PhoneBattleRoomFrm_Endless then --PVP对战房间面板
		return
	end
	
	--加载 pvp.plist
	xlLoadResourceFromPList("data/image/misc/pvp.plist")
	
	--hApi.clearTimer("__PVP_ROOM_GENERAL_PAGE1__") --通用timer1
	hApi.clearTimer("__PVP_ROOM_SCROLL_PAGE11__")
	hApi.clearTimer("__PVP_ROOM_QUERY_PAGE11__")
	hApi.clearTimer("__PVP_ROOM_GAMETIME_PAGE11__")
	hApi.clearTimer("__PVP_ROOM_READY_PAGE11__")
	hApi.clearTimer("__PVP_ROOM_GAMETIME_PAGE13__")
	hApi.clearTimer("__PVP_ROOM_SCROLL_PAGE24__")
	hApi.clearTimer("__PVP_ROOM_MATCH_PAGE25__")
	hApi.clearTimer("__PVP_ROOM_SCROLL_PAGE21__")
	hApi.clearTimer("__PVP_ROOM_QUERY_PAGE21__")
	hApi.clearTimer("__PVP_ROOM_GAMETIME_PAGE21__")
	
	--创建铜雀台房间操作面板
	hGlobal.UI.PhoneBattleRoomFrm_Endless = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		--z = 100,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 2,
		show = 0, --一开始不显示
		--border = 1, --显示frame边框
		border = "UI:TileFrmBack_PVP",
		background = "panel/panel_part_pvp_00.png",
		--background = -1,
		autoactive = 0,
		--全部事件
		--codeOnDragEx = function(touchX, touchY, touchMode)
			--
		--end,
	})
	
	local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
	local _parent = _frm.handle._n
	
	--左侧裁剪区域1-1
	--local _BTC_PageClippingRect_page11 = {0, -105, 1000, 362, 0} -- {x, y, w, h, ???}
	--local _BTC_pClipNode_Room_page11 = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect_page11, 98, _BTC_PageClippingRect_page11[5], "_BTC_pClipNode_Room_page11")
	
	--左侧裁剪区域1-4
	--local _BTC_PageClippingRect_page14 = {0, -151, 1000, 479, 0} -- {x, y, w, h, ???}
	--local _BTC_pClipNode_Room_page14 = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect_page14, 98, _BTC_PageClippingRect_page14[5], "_BTC_pClipNode_Room_page14")
	
	--左侧裁剪区域2-1
	local _BTC_PageClippingRect_page21 = {0, -105, 1000, 456, 0} -- {x, y, w, h, ???}
	local _BTC_pClipNode_Room_page21 = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect_page21, 98, _BTC_PageClippingRect_page21[5], "_BTC_pClipNode_Room_page21")
	
	--左侧裁剪区域2-4
	local _BTC_PageClippingRect_page24 = {0, -151, 1000, 479, 0} -- {x, y, w, h, ???}
	local _BTC_pClipNode_Room_page24 = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect_page24, 98, _BTC_PageClippingRect_page24[5], "_BTC_pClipNode_Room_page24")
	
	--主界面黑色背景图
	_frm.childUI["panel_bg"] = hUI.button:new({
		parent = _parent,
		model = "misc/mask.png",
		x = PAGE_BTN_LEFT_X + 362,
		y = PAGE_BTN_LEFT_Y - 344,
		w = 956,
		h = 544,
	})
	_frm.childUI["panel_bg"].handle.s:setOpacity(0) --为了挂载动态图
	
	--面板的背景图-上i
	for i = 1, 10, 1 do
		_frm.childUI["frameBG_Top_" .. i] = hUI.image:new({
			parent = _parent,
			model = "panel/panel_part_pvp_00.png",
			x = PAGE_BTN_LEFT_X - 64 + (i - 1) * 94,
			y = PAGE_BTN_LEFT_Y - 27,
			w = 94,
			h = 88,
		})
	end
	
	--面板的背景图-左下
	_frm.childUI["frameBG_LB"] = hUI.image:new({
		parent = _parent,
		model = "panel/panel_part_pvp_08.png",
		x = PAGE_BTN_LEFT_X - 72,
		y = PAGE_BTN_LEFT_Y - 569,
		w = 96,
		h = 96,
	})
	
	--面板的背景图-左下中
	_frm.childUI["frameBG_LBC"] = hUI.image:new({
		parent = _parent,
		model = "panel/panel_part_pvp_02.png",
		x = PAGE_BTN_LEFT_X + 70,
		y = PAGE_BTN_LEFT_Y - 593,
		w = 250,
		h = 48,
	})
	
	--面板的背景图-左中中竖
	_frm.childUI["frameBG_LCCV"] = hUI.image:new({
		parent = _parent,
		model = "panel/panel_part_pvp_03.png",
		x = PAGE_BTN_LEFT_X - 96,
		y = PAGE_BTN_LEFT_Y - 292,
		w = 48,
		h = 508,
	})
	
	--面板的背景图-左中中横
	_frm.childUI["frameBG_LCCH"] = hUI.image:new({
		parent = _parent,
		model = "panel/panel_part_pvp_01.png",
		x = PAGE_BTN_LEFT_X - 12,
		y = PAGE_BTN_LEFT_Y - 96,
		w = 200,
		h = 48,
	})
	
	--面板的背景图-右上
	_frm.childUI["frameBG_RT"] = hUI.image:new({
		parent = _parent,
		model = "panel/panel_part_pvp_06.png",
		x = PAGE_BTN_LEFT_X + 792,
		y = PAGE_BTN_LEFT_Y - 25,
		w = 96,
		h = 96,
	})
	
	--面板的背景图-右中竖
	_frm.childUI["frameBG_RCV"] = hUI.image:new({
		parent = _parent,
		model = "panel/panel_part_pvp_04.png",
		x = PAGE_BTN_LEFT_X + 816,
		y = PAGE_BTN_LEFT_Y - 100,
		w = 48,
		h = 200,
	})
	
	--关闭按钮（小门图标）
	--btnClose
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		model = "UI:LEAVETOWNBTN",
		x = 58 - 5000, --看不见了。。。
		y = -590,
		scaleT = 0.95,
		code = function()
			--将本地的卡牌配置上传到服务器(铜雀台)
			UploadClientConfigCard_page2()
			
			--关闭金币、积分界面
			--hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
			
			--触发事件：关闭了主菜单按钮
			hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
			
			--不显示对战房间面板
			hGlobal.UI.PhoneBattleRoomFrm_Endless:show(0)
			
			--移除所有的监听、timer、clipNode
			OnClearAllEventsAndTimers()
			
			--清空所有分页的全部信息
			_removePageFrmFunc()
			_removeLeftFrmFunc()
			_removeRightFrmFunc()
			
			--动态删除pvp背景图
			__DynamicRemoveRes()
			
			--last_room_query_time_page1 = 0 --上一次timer取房间列表的时间
			--last_room_gametime_time_page1 = 0 --上一次timer取房间游戏时间的时间
			
			--关闭连接
			--if Pvp_Server then
			--	Pvp_Server:Close()
			--end
			
			--清空夺塔奇兵大图
			local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/addition/pvp_dtqb.jpg")
			if texture then
				CCTextureCache:sharedTextureCache():removeTexture(texture)
			end
			--清空铜雀台大图
			local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/addition/pvp_tqt.jpg")
			if texture then
				CCTextureCache:sharedTextureCache():removeTexture(texture)
			end
			
			--删除pvp资源
			xlReleaseResourceFromPList("data/image/misc/pvp.plist")
			
			--播放背景音乐
			--hApi.PlaySoundBG(g_channel_town, "main_theme")
		end,
	})
	
	--叉叉关闭按钮
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
	_frm.childUI["closeBtnRight"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		model = "BTN:PANEL_CLOSE",
		x = _frm.data.w + closeDx,
		y = closeDy,
		scaleT = 0.95,
		code = _frm.childUI["closeBtn"].data.code,
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
		--text = "PVP对战", --language
		text = hVar.tab_string["__TEXT_MAINUI_BTN_PVP"], --language
	})
	]]
	
	--每个分页按钮
	--PVP房间
	local tPageIcons = {"misc/pvp/td_pvp_001.png", "misc/pvp/td_wj_003.png",}
	--local tPageIcons = {"misc/pvp/td_pvp_001.png", "misc/pvp/pvpyl.png", "misc/pvp/pvphd.png",}
	--[[
	for i = 2, #tPageIcons, 1 do
		--分页按钮
		_frm.childUI["PageBtn" .. i] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			x = PAGE_BTN_LEFT_X - 60,
			y = PAGE_BTN_LEFT_Y - 50 - (i - 1) * PAGE_BTN_OFFSET_Y,
			w = 110,
			h = 100,
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
			model = tPageIcons[i],
			x = 10,
			y = 0,
			scale = 1.0,
		})
	end
	]]
	
	--分页按钮2: 铜雀台
	local i = 2
	_frm.childUI["PageBtn" .. i] = hUI.button:new({
		parent = _parent,
		model = "misc/mask.png",
		x = PAGE_BTN_LEFT_X - 55 + 40,
		y = PAGE_BTN_LEFT_Y - 29,
		w = 170,
		h = 100,
		dragbox = _frm.childUI["dragBox"],
		scaleT = 0.98,
		code = function(self, screenX, screenY, isInside)
			OnClickPageBtn(i)
		end,
	})
	_frm.childUI["PageBtn" .. i].handle.s:setOpacity(0) --分页按钮点击区域，只作为控制用，不用于显示
	
	--分页按钮的方块图标
	_frm.childUI["PageBtn" .. i].childUI["PageImage"] = hUI.image:new({
		parent = _frm.childUI["PageBtn" .. i].handle._n,
		model = tPageIcons[i],
		x = -27,
		y = 1,
		w = 137,
		h = 88,
	})
	
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
	
	--清空分页所有的临时控件（在本分页下，一直存在的控件）
	_removePageFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1, #pagerightRemoveFrmList, 1 do
			hApi.safeRemoveT(_frmNode.childUI, pagerightRemoveFrmList[i]) 
		end
		pagerightRemoveFrmList = {}
	end
	
	--清空所有分页左侧的UI
	_removeLeftFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1, #leftRemoveFrmList, 1 do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1, #rightRemoveFrmList, 1 do
			hApi.safeRemoveT(_frmNode.childUI, rightRemoveFrmList[i]) 
		end
		rightRemoveFrmList = {}
	end
	
	--函数：点击分页按钮函数
	OnClickPageBtn = function(pageIndex)
		--不重复显示同一个分页（这里同时子分页也一样才行）
		if (CurrentSelectRecord.pageIdx == pageIndex) and (CurrentSelectRecord.contentIdx == 0) then
			--print("不重复显示同一个分页")
			return
		end
		
		--[[
		--启用全部的按钮
		for i = 1, #tPageIcons, 1 do
			_frm.childUI["PageBtn" .. i]:setstate(1) --按钮可用
			_frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s:setVisible(true) --显示图片
		end
		
		--当前按钮高亮
		if (pageIndex ~= 1) then
			--hApi.AddShader(_frm.childUI["PageBtn" .. pageIndex].childUI["PageImage"].handle.s, "normal")
			_frm.childUI["PageBtn" .. pageIndex].childUI["PageImage"].handle._n:setPosition(ccp(15, 0))
		end
		
		--其它按钮灰掉
		for i = 1, #tPageIcons, 1 do
			if (i ~= pageIndex) then
				--geyachao: 夺塔奇兵分页永远亮着
				if (i ~= 1) then
					--hApi.AddShader(_frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s, "gray")
					_frm.childUI["PageBtn" .. i].childUI["PageImage"].handle._n:setPosition(ccp(7, 0))
				end
			end
		end
		]]
		
		--移除所有的监听、timer、clipNode
		OnClearAllEventsAndTimers()
		
		--清空上次分页的全部信息
		_removePageFrmFunc()
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：夺塔奇兵
			--创建夺塔奇兵分页
			--...
		elseif (pageIndex == 2) then --分页2：铜雀台
			--创建铜雀台分页
			OnCreateTongQueTaiLogoShowFrame(pageIndex)
		end
		
		--标记当前选择的分页和页内的第几个
		CurrentSelectRecord.pageIdx = pageIndex
		CurrentSelectRecord.contentIdx = 0
	end
	
	--函数：移除所有的监听、timer、clipNode
	OnClearAllEventsAndTimers = function()
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--清空切换分页之后取消的监听事件
		--分页2-0
		--移除事件监听：收到pvp的ping值回调
		hGlobal.event:listen("LocalEvent_Pvp_Ping", "__PvpPing_page2_0", nil)
		--移除事件监听：收到连接结果回调
		hGlobal.event:listen("LocalEvent_Pvp_NetEvent", "__ConnectBack_page2_0", nil)
		--移除事件监听：收到登入结果回调
		hGlobal.event:listen("LocalEvent_Pvp_PlayerLoginEvent", "__LoginBack_page2_0", nil)
		--移除事件监听：我的基础信息返回事件
		hGlobal.event:listen("LocalEvent_Pvp_UserBaseInfo", "__BattleBaseInfo_page2_0", nil)
		--移除事件监听：pvp错误信息提示
		hGlobal.event:listen("LocalEvent_Pvp_NetLogicError", "__NetLogicError_page2_0", nil)
		--移除事件监听：配置卡组回调事件
		hGlobal.event:listen("LocalEvent_Pvp_battleCfg", "__BattleCfgBack_page2_0", nil)
		--移除事件监听：收到铜雀台今日生效配置信息
		hGlobal.event:listen("LocalEvent_PvpMulty_RoomTakeEffectCfg", "__PvpMultyCfgBack_page2_0", nil)
		
		--分页2-0
		hGlobal.event:listen("LocalEvent_PvpMulty_RoomTakeEffectCfg", "__PvpMultyCfgBack_RefreshUI_page2_0", nil)
		
		--分页2-1
		--移除事件监听：收到pvp的ping值回调
		hGlobal.event:listen("LocalEvent_Pvp_Ping", "__PvpPing_page2", nil)
		--移除事件监听：收到连接结果回调
		hGlobal.event:listen("LocalEvent_Pvp_NetEvent", "__ConnectBack_page2", nil)
		--移除事件监听：收到登入结果回调
		hGlobal.event:listen("LocalEvent_Pvp_PlayerLoginEvent", "__LoginBack_page2", nil)
		--移除事件监听：收到房间id列表回调
		hGlobal.event:listen("LocalEvent_Pvp_RoomList", "__RoomListBack_page2", nil)
		--移除事件监听：收到房间摘要回调
		hGlobal.event:listen("LocalEvent_Pvp_RoomsAbstract", "__RoomAbstarctBack_page2", nil)
		--移除事件监听：收到单个房间摘要发生变化回调
		hGlobal.event:listen("LocalEvent_Pvp_SingleRoomsAbstractChanged", "__RoomSingleAbstarctChangedBack_page2", nil)
		--移除事件监听：房间状态回调
		hGlobal.event:listen("LocalEvent_Pvp_RoomEvent", "__RoomEventBack_page2", nil)
		--移除事件监听：自己所处的房间信息变化回调
		hGlobal.event:listen("LocalEvent_Pvp_RoomInfo", "__RoomInfoBack_page2", nil)
		--移除事件监听：离开房间回调
		hGlobal.event:listen("LocalEvent_Pvp_RoomLeave", "__LeaveRoomBack_page2", nil)
		--移除事件监听：进入房间失败事件
		hGlobal.event:listen("LocalEvent_Pvp_RoomEnter_Fail", "__EnterRoomFail_page2", nil)
		--移除事件监听：pvp错误信息提示
		hGlobal.event:listen("LocalEvent_Pvp_NetLogicError", "__NetLogicError_page2", nil)
		--移除事件监听：切换场景事件
		hGlobal.event:listen("LocalEvent_Pvp_SwitchGame", "__SwitchGameBack_page2", nil)
		--移除事件监听：配置卡组回调事件
		hGlobal.event:listen("LocalEvent_Pvp_battleCfg", "__BattleCfgBack_page2", nil)
		--移除事件监听：我的基础信息返回事件
		hGlobal.event:listen("LocalEvent_Pvp_UserBaseInfo", "__BattleBaseInfo_page2", nil)
		--移除事件监听：配置卡组界面操作完成事件
		hGlobal.event:listen("LocalEvent_UI_battleCfg_Complete", "__BattleCfgBack_page2", nil)
		
		--分页2-4
		--移除事件监听：配置卡组回调事件
		hGlobal.event:listen("LocalEvent_Pvp_battleCfg", "__BattleCfgBack_page2_4", nil)
		
		
		--删除刷新房间界面timer
		--hApi.clearTimer("__PVP_ROOM_GENERAL_PAGE1__") --通用timer1
		hApi.clearTimer("__PVP_ROOM_SCROLL_PAGE11__")
		hApi.clearTimer("__PVP_ROOM_QUERY_PAGE11__")
		hApi.clearTimer("__PVP_ROOM_GAMETIME_PAGE11__")
		hApi.clearTimer("__PVP_ROOM_READY_PAGE11__")
		hApi.clearTimer("__PVP_ROOM_GAMETIME_PAGE13__")
		hApi.clearTimer("__PVP_ROOM_SCROLL_PAGE24__")
		hApi.clearTimer("__PVP_ROOM_MATCH_PAGE25__")
		hApi.clearTimer("__PVP_ROOM_SCROLL_PAGE21__")
		hApi.clearTimer("__PVP_ROOM_QUERY_PAGE21__")
		hApi.clearTimer("__PVP_ROOM_GAMETIME_PAGE21__")
		
		--隐藏所有的clipNode
		--hApi.EnableClipByName(_frm, "_BTC_pClipNode_Room_page11", 0)
		--hApi.EnableClipByName(_frm, "_BTC_pClipNode_Room_page14", 0)
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Room_page21", 0)
		--print("隐藏所有的clipNode", tostring(_frm))
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Room_page24", 0)
	end
	
	--函数：收到pvp游戏错误提示事件回调(夺塔奇兵)(铜雀台)
	on_receive_Pvp_NetLogicError_event = function(errorStr)
		--print("on_receive_Pvp_NetLogicError_event", errorStr)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--冒泡提示文字
		hUI.floatNumber:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			align = "MC",
			text = "",
			lifetime = 1000,
			fadeout = -550,
			moveY = 32,
		}):addtext(errorStr, hVar.FONTC, 40, "MC", 0, 0)
	end
	
	--函数：收到pvp切换场景事件回调(夺塔奇兵)(铜雀台)
	on_receive_Pvp_SwitchGame_event = function()
		--取消挡操作
		hUI.NetDisable(0)
		
		--关闭金币、积分界面
		--hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
			
		--不显示铜雀台房间面板
		hGlobal.UI.PhoneBattleRoomFrm_Endless:show(0)
		
		--触发事件：关闭了主菜单按钮
		hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
		
		--移除所有的监听、timer、clipNode
		OnClearAllEventsAndTimers()
		
		--清空所有分页的全部信息
		_removePageFrmFunc()
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--动态删除pvp背景图
		__DynamicRemoveRes()
		
		--删除英雄例会资源
		--hUI.SYSAutoReleaseUI:addModel("portrait",tabU.portrait)
		--hResource.model:releaseCache(hVar.TEMP_HANDLE_TYPE.UI_GRID_AUTO_RELEASE)
		local tRelease = {}
		local tPng = hUI.SYSAutoReleaseUI.png
		for i = 1, #tPng, 1 do
			local path = tPng[i]
			tRelease[path] = 1
		end
		hResource.model:releasePng(tRelease)
		hUI.SYSAutoReleaseUI.png = {idx = {}}
		
		--释放png, plist的纹理缓存（这里不清理也可以）
		--hApi.ReleasePngTextureCache()
		
		--回收lua内存（这里不清理也可以）
		--collectgarbage()
		
		--关闭连接
		--if Pvp_Server then
		--	Pvp_Server:Close()
		--end
		
		--清空夺塔奇兵大图
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/addition/pvp_dtqb.jpg")
		if texture then
			CCTextureCache:sharedTextureCache():removeTexture(texture)
		end
		--清空铜雀台大图
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/addition/pvp_tqt.jpg")
		if texture then
			CCTextureCache:sharedTextureCache():removeTexture(texture)
		end
		
		--删除pvp资源
		xlReleaseResourceFromPList("data/image/misc/pvp.plist")
		
		--标记不是最新数据了
		g_myPvP_BaseInfo.updated = 0
		
		--清空卡牌生效表（进游戏结束后可能会领奖，需要重新取今日可领奖次数）
		current_TakeEffectCfg = nil --铜雀台今日卡牌生效表
	end
	
	--函数：检测pvp的版本号(夺塔奇兵)(铜雀台)
	CheckPvpVersionControl = function()
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--检测pvp版本号，是否为最新版本
		local local_srcVer = tostring(hVar.CURRENT_ITEM_VERSION) --1.0.070502
		local pvp_control = tostring(g_pvp_control) --1.0.070502-v018-018-app
		local vbpos = string.find(pvp_control, "-")
		if vbpos then
			pvp_control = string.sub(pvp_control, 1, vbpos - 1)
		end
		--print(local_srcVer, pvp_control)
		--如果pvp版本号不一致，弹框
		if (local_srcVer ~= pvp_control) then
			--弹系统框
			local msgTitle = hVar.tab_string["__TEXT_SystemNotice"]
			if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员，显示具体的版本号
				msgTitle = hVar.tab_string["__TEXT_SystemNotice"] .. " (" .. local_srcVer .. "|" .. pvp_control .. ")"
			end
			hApi.ShowSysMsgBox(msgTitle, hVar.tab_string["__TEXT_ScriptsTooOld"])
			
			return false
		end
		
		return true
	end
	
	--函数：检测pvp是否在逃跑惩罚中(夺塔奇兵)(铜雀台)
	CheckPvpEscapePunish = function()
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local clienttime = os.time()
		local hosttime = clienttime - g_localDeltaTime_pvp --(Local = Host + deltaTime)
		local escapePunishTime = g_myPvP_BaseInfo.escapePunishTime --逃跑惩罚时间(单位:秒)
		local lastPunishTime = g_myPvP_BaseInfo.lastPunishTime --上一次惩罚时间(数值)
		local lefttime = escapePunishTime - (hosttime - lastPunishTime)
		--[[
		print("CheckPvpEscapePunish:")
		print("    escapePunishTime=" .. escapePunishTime)
		print("    lastPunishTime=" .. lastPunishTime)
		print("    lefttime=" .. lefttime)
		print("    punishCount=" .. g_myPvP_BaseInfo.punishCount)
		]]
		if (lefttime > 0) then
			local minute = math.ceil(lefttime / 60) --惩罚的分钟
			--local msgTitle = "您因为逃跑或掉线次数过多，需要等待" .. minute .. "分钟才能对战！" --language
			local msgTitle = hVar.tab_string["__TEXT_PVP_PvpEscapePunish1"] .. minute .. hVar.tab_string["__TEXT_PVP_PvpEscapePunish2"] --language
			hGlobal.UI.MsgBox(msgTitle,{
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			return false
		end
		
		return true
	end
	
	--函数：检测pvp逃跑是否到上限(夺塔奇兵)(铜雀台)
	CheckPvpEscapeMaxCount = function()
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local escapeE = g_myPvP_BaseInfo.escapeE --用户娱乐房逃跑场
		local errE = g_myPvP_BaseInfo.errE --用户娱乐房异常场
		local escapeSum = escapeE + errE
		
		if (escapeSum > ROOM_ESCAPE_MAX_COUNT) then
			--local msgTitle = "您因为逃跑或掉线次数太多，禁止对战！" --language
			local msgTitle = hVar.tab_string["__TEXT_PVP_PvpEscapeMaxCount"] --language
			hGlobal.UI.MsgBox(msgTitle,{
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			return false
		end
		
		return true
	end
	
	--函数：检测pvp是否在投降惩罚中(夺塔奇兵)(铜雀台)
	CheckPvpSurrenderPunish = function()
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local clienttime = os.time()
		local hosttime = clienttime - g_localDeltaTime_pvp --(Local = Host + deltaTime)
		local escapePunishTime1 = g_myPvP_BaseInfo.escapePunishTime --逃跑惩罚时间(单位:秒)
		local lastPunishTime1 = g_myPvP_BaseInfo.lastPunishTime1 --上一次惩罚时间(数值)
		local lefttime1 = escapePunishTime1 - (hosttime - lastPunishTime1)
		if (lefttime1 > 0) then
			local minute1 = math.ceil(lefttime1 / 60) --惩罚的分钟
			--local msgTitle = "您因为投降次数过多，需要等待" .. minute1 .. "分钟才能对战！" --language
			local msgTitle = hVar.tab_string["__TEXT_PVP_PvpSurrenderPunish1"] .. minute1 .. hVar.tab_string["__TEXT_PVP_PvpSurrenderPunish2"] --language
			hGlobal.UI.MsgBox(msgTitle,{
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			return false
		end
		
		return true
	end
	
	--函数：检测pvp的配卡是否完整(夺塔奇兵)(铜雀台)
	CheckPvpCfgCardOK = function()
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		--print("current_ConfigCardList=", current_ConfigCardList)
		if (not current_ConfigCardList) then
			--弹系统框
			--local msgTitle = "您还未配置阵容或阵容不完整，请先配置阵容" --language
			local msgTitle = hVar.tab_string["__TEXT_PVP_CfgNotFilled"] --language
			hGlobal.UI.MsgBox(msgTitle,{
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			return false
		else
			local herocard = current_ConfigCardList.herocard or {}
			local towercard = current_ConfigCardList.towercard or {}
			local tacticcard = current_ConfigCardList.tacticcard or {}
			
			local bReleased = true
			if (#towercard == 0) then
				bReleased = false
			end
			--if (#tacticcard == 0) then
			--	bReleased = false
			--end
			
			--如果pvp配卡不完整，不能进游戏
			if (not bReleased) then
				--弹系统框
				--local msgTitle = "您还未配置阵容或阵容不完整，请先配置阵容" --language
				local msgTitle = hVar.tab_string["__TEXT_PVP_CfgNotFilled"] --language
				hGlobal.UI.MsgBox(msgTitle,{
					font = hVar.FONTC,
					ok = function()
					end,
				})
				
				return false
			end
			
			return true
		end
	end
	
	--函数：检测pvp的兵符是否足够(夺塔奇兵)(铜雀台)
	CheckPvpCoinOK = function()
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--检测竞技场兵符是否为0
		if (g_myPvP_BaseInfo.pvpcoin <= 0) then
			--弹系统框
			--local msgTitle = "您的竞技场兵符数量不足！\n（点击上方兵符按钮，每天可领取一次）" --language
			local msgTitle = hVar.tab_string["__TEXT_PVP_PvpCoinNotEnough"] --language
			hGlobal.UI.MsgBox(msgTitle,{
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			return false
		end
		
		return true
	end
	
	--函数：检测游戏币是否足够(夺塔奇兵)(铜雀台)
	CheckGamecoinOK = function(gamecoin)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--检测游戏币是否足够
		if (LuaGetPlayerRmb() < gamecoin) then
			--[[
			--弹系统框
			--local msgTitle = "游戏币不足" --language
			local msgTitle = hVar.tab_string["ios_not_enough_game_coin"] --language
			hGlobal.UI.MsgBox(msgTitle,{
				font = hVar.FONTC,
				ok = function()
				end,
			})
			]]
			
			--弹出游戏币不足并提示是否购买的框
			hGlobal.event:event("LocalEvent_BuyItemfail", 1, 0)
			
			return false
		end
		
		return true
	end
	
	--函数：检测玩家是否作弊(夺塔奇兵)(铜雀台)
	CheckCheatOK = function()
		--geyachao: 暂时屏蔽掉检测作弊
		--[[
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--检测本地存档的每一项校验和是否一致
		local pvp_battle_user_info = LuaGetPVPUserInfo(g_curPlayerName)
		for i = 1, #pvp_battle_user_info, 1 do
			local tInfo = pvp_battle_user_info[i]
			local session_dbId = tInfo.session_dbId
			local userId = tInfo.userId
			local userName = tInfo.userName
			local hosttime = hApi.GetNewDate(tInfo.strBattleTime) --GMT+8时区
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - 8 --与北京时间的时差
			hosttime = hosttime + delteZone * 3600 --本地时区
			local bUseEquip = tInfo.bUseEquip --本局是否携带状态
			local pvpcoinCost = tInfo.pvpcoinCost
			local gametime = tInfo.gametime
			--print(session_dbId, userId, hosttime, bUseEquip, pvpcoinCost, gametime)
			
			--算出校验和
			local nUseEquip = bUseEquip and 1 or 0
			local checksum = (session_dbId + userId + (#userName) + hosttime + nUseEquip + pvpcoinCost + gametime) % 9973
			if (checksum ~= tInfo.checksum) then
				--弹系统框
				--local msgTitle = "系统检测到您存在作弊行为！禁止对战！" --language
				local msgTitle = hVar.tab_string["__TEXT_PVP_PvpCheat"] --language
				hGlobal.UI.MsgBox(msgTitle,{
					font = hVar.FONTC,
					ok = function()
					end,
				})
				
				return false
			end
		end
		]]
		
		return true
	end
	
	--函数：检测玩家是否在刷(夺塔奇兵)(铜雀台)
	CheckBrushOK = function(enterPlayerName)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--解析房间的双方玩家名
		local playerNameList = {"", ""} --玩家名
		if enterPlayerName and (enterPlayerName ~= "") then
			local maohao_pos = string.find(enterPlayerName, ":") --冒号的位置
			if maohao_pos then
				playerNameList[1] = string.sub(enterPlayerName, 1, maohao_pos - 1)
				playerNameList[2] = string.sub(enterPlayerName, maohao_pos + 1, #enterPlayerName)
				if (string.sub(playerNameList[1], #playerNameList[1], #playerNameList[1]) == ":") then --去掉末尾的冒号
					playerNameList[1] = string.sub(playerNameList[1], 1, #playerNameList[1] - 1)
				end
				if (string.sub(playerNameList[1], #playerNameList[1], #playerNameList[1]) == "|") then --去掉末尾的竖线
					playerNameList[1] = string.sub(playerNameList[1], 1, #playerNameList[1] - 1)
				end
				if (string.sub(playerNameList[2], #playerNameList[2], #playerNameList[2]) == ":") then --去掉末尾的冒号
					playerNameList[2] = string.sub(playerNameList[2], 1, #playerNameList[2] - 1)
				end
				if (string.sub(playerNameList[2], #playerNameList[2], #playerNameList[2]) == "|") then --去掉末尾的竖线
					playerNameList[2] = string.sub(playerNameList[2], 1, #playerNameList[2] - 1)
				end
			end
		end
		
		--对方的名字
		local playerName = playerNameList[1]
		if (playerName == "") then
			playerName = playerNameList[2]
		end
		
		--获得当前时间(北京时区)
		local clienttime = os.time()
		local hosttime = clienttime - g_localDeltaTime_pvp --(Local = Host + deltaTime)
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - 8 --与北京时间的时差
		hosttime = hosttime - delteZone * 3600 --GMT+8时区
		local tabNow = os.date("*t", hosttime) --GMT+8时区
		local yearNow = tabNow.year
		local monthNow = tabNow.month
		local dayNow = tabNow.day
		
		--检测本地存档今天和玩家对战的次数
		local PVPCOIN_LIMIT = 10 --排除条件: 本局自己消耗10兵符
		local GAMETIME_LIMIT = 10 * 60 --排除条件: 游戏局打满10分钟
		local LAST_PK_TIME = 60 * 60 --防刷: 需要等待60分钟
		local CHECK_COUNT = 3 --3次
		local recentCount = 0
		local recentTime = 0
		
		local pvp_battle_user_info = LuaGetPVPUserInfo(g_curPlayerName)
		for i = 1, #pvp_battle_user_info, 1 do
			local tInfo = pvp_battle_user_info[i]
			local session_dbId = tInfo.session_dbId
			local userId = tInfo.userId
			local userName = tInfo.userName
			local hosttime_i = hApi.GetNewDate(tInfo.strBattleTime) --GMT+8时区
			local bUseEquip = tInfo.bUseEquip --本局是否携带状态
			local pvpcoinCost = tInfo.pvpcoinCost
			local gametime = tInfo.gametime
			local checksum = tInfo.checksum
			
			--是同一个人
			if (userName == playerName) then
				--是装备局，或者自己的兵符消耗不够、游戏时长不够
				if (bUseEquip) or ((pvpcoinCost < PVPCOIN_LIMIT) and (gametime < GAMETIME_LIMIT)) then
					local tabOld = os.date("*t", hosttime_i) --GMT+8时区
					local yearOld = tabOld.year
					local monthOld = tabOld.month
					local dayOld = tabOld.day
					
					--今天的对战局
					if (yearNow == yearOld) and (monthNow == monthOld) and (dayNow == dayOld) then
						--次数加1
						recentCount = recentCount + 1
						
						--标记最近一次的时间
						if (hosttime_i > recentTime) then
							recentTime = hosttime_i
						end
					end
				end
			end
			
			--print("recentCount=", recentCount)
			--print("recentTime=", os.date("%Y-%m-%d %H:%M:%S", recentTime))
			
			--今日与同一个人对战超过3次，最近一次对战在60分钟内
			if (recentCount >= CHECK_COUNT) and ((hosttime - recentTime) < LAST_PK_TIME) then
				local leftMinute = math.ceil((LAST_PK_TIME - (hosttime - recentTime)) / 60)
				
				--弹系统框
				--local msgTitle = "对方已挂起免战牌！60分钟内不能和该玩家对战！" --language
				local msgTitle = hVar.tab_string["__TEXT_PVP_PvpBrush1"] .. leftMinute .. hVar.tab_string["__TEXT_PVP_PvpBrush2"] --language
				hGlobal.UI.MsgBox(msgTitle,{
					font = hVar.FONTC,
					ok = function()
					end,
				})
				
				return false
			end
		end
		
		return true
	end
	
	--函数：检测pvp是否开放对战（活动300和301的控制）(夺塔奇兵)(铜雀台)
	CheckPvpBattleOpenState = function()
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--如果是当前时段未开放，显示开放的时段
		--g_pvp_room_closetime
		--主界面刷新竞技场关闭的倒计时
		local clienttime = os.time()
		local hosttime = clienttime - g_localDeltaTime_pvp --(Local = Host + deltaTime)
		
		--20:00:00～21:59:59 GMT+8时区
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - 8 --与北京时间的时差
		hosttime = hosttime - delteZone * 3600
		local tabNow = os.date("*t", hosttime) --北京时区
		local yearNow = tabNow.year
		local monthNow = tabNow.month
		local dayNow = tabNow.day
		local strYearNow = tostring(yearNow)
		local strMonthNow = tostring(monthNow)
		if (monthNow < 10) then
			strMonthNow = "0" .. strMonthNow
		end
		local strDayNow = tostring(dayNow)
		if (dayNow < 10) then
			strDayNow = "0" .. strDayNow
		end
		local strDayBegin = strYearNow .. "-" .. strMonthNow .. "-" .. strDayNow .. " 20:00:00"
		local strDayEnd = strYearNow .. "-" .. strMonthNow .. "-" .. strDayNow .. " 21:59:59"
		local pve_room_begintime = hApi.GetNewDate(strDayBegin)
		local pve_room_closetime = hApi.GetNewDate(strDayEnd)
		
		local begintime_room = hosttime - pve_room_begintime
		local lefttime_room = pve_room_closetime - hosttime
		--print("now=", os.date("%Y-%m-%d %H:%M:%S", hosttime))
		--print(strDayBegin, strDayEnd)
		--print(begintime_room, lefttime_room)
		
		if (lefttime_room >= 0) and (begintime_room >= 0) then
			return true
		else
			--if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
			if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
				return true
			else
				--冒字
				--local strText = "当前时段未开放挑战魔龙！" --language
				local strText = hVar.tab_string["__TEXT_PVP_PvpMultyBattleClosed"] --language
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
				
				return false
			end
		end
	end
	
	--函数：领取兵符操作(夺塔奇兵)(铜雀台)
	OnGetPvpCoinButton = function()
		--删除上一次兵符界面
		if hGlobal.UI.PhonePvpoinFrm then
			hGlobal.UI.PhonePvpoinFrm:del()
			hGlobal.UI.PhonePvpoinFrm = nil
		end
		
		--创建兵符面板
		hGlobal.UI.PhonePvpoinFrm = hUI.frame:new(
		{
			x = hVar.SCREEN.w / 2 - 460 / 2,
			y = hVar.SCREEN.h / 2 + 500 / 2 - 45,
			z = 100,
			w = 450,
			h = 500,
			dragable = 3,
			show = 1, --一开始不显示
			--border = 1, --显示frame边框
			--border = "UI:TileFrmBack_PVP",
			--background = "panel/panel_part_pvp_00.png",
			autoactive = 0,
			--全部事件
			--codeOnDragEx = function(touchX, touchY, touchMode)
				--
			--end,
		})
		--[[
		local onclickevent = nil
		local MsgSelections = nil
		MsgSelections = {
			style = "mini",
			select = 0,
			ok = function()
				onclickevent()
			end,
			--cancel = function()
			--	onclickevent()
			--end,
			--cancelFun = cancelCallback, --点否的回调函数
			--textOk = "领取",
			textOk = hVar.tab_string["__Get__"], --language
			--textCancel = "确定", --language
			--textCancel = hVar.tab_string["Exit_Ack"], --language
			userflag = 0, --用户的标记
		}
		local msgBox = hGlobal.UI.MsgBox("", MsgSelections)
		msgBox:active()
		msgBox:show(1,"fade",{time=0.08})
		]]
		local msgBox = hGlobal.UI.PhonePvpoinFrm
		
		--关闭按钮
		msgBox.childUI["closeBtn"] = hUI.button:new({
			parent = msgBox.handle._n,
			dragbox = msgBox.childUI["dragBox"],
			model = "BTN:PANEL_CLOSE",
			x = msgBox.data.w,
			y = 0,
			scaleT = 0.95,
			code = function()
				msgBox:del()
			end,
		})
		
		--兵符标题
		msgBox.childUI["title"] = hUI.label:new({
			parent = msgBox.handle._n,
			x = 225,
			y = -15,
			size = 40,
			font = hVar.FONTC,
			align = "MT",
			width = 500,
			border = 1,
			--text = "兵符", --language
			text = hVar.tab_string["ios_bingfu"], --language
		})
		msgBox.childUI["title"].handle.s:setColor(ccc3(255, 255, 212))
		
		--说明1
		--local showTitle1 = "1、每次发兵消耗1兵符。" --language
		local showTitle1 = hVar.tab_string["__TEXT_PVP_PvpCoinGetMsgBox1"] --language
		msgBox.childUI["label1"] = hUI.label:new({
			parent = msgBox.handle._n,
			x = 15,
			y = -65,
			size = 26,
			font = hVar.FONTC,
			align = "LT",
			width = 500,
			border = 1,
			text = showTitle1, --language
		})
		
		--说明2
		--local showTitle2 = "2、英雄免等待复活消耗5个兵符。" --language
		local showTitle2 = hVar.tab_string["__TEXT_PVP_PvpCoinGetMsgBox2"] --language
		msgBox.childUI["label2"] = hUI.label:new({
			parent = msgBox.handle._n,
			x = 15,
			y = -100,
			size = 26,
			font = hVar.FONTC,
			align = "LT",
			width = 500,
			border = 1,
			text = showTitle2, --language
		})
		
		--说明3
		--local showTitle3 = "3、每天可领取一次，补充100兵符。\n    （最多补满到100兵符）" --language
		local showTitle3 = hVar.tab_string["__TEXT_PVP_PvpCoinGetMsgBox3"] --language
		msgBox.childUI["label3"] = hUI.label:new({
			parent = msgBox.handle._n,
			x = 15,
			y = -135,
			size = 26,
			font = hVar.FONTC,
			align = "LT",
			width = 500,
			border = 1,
			text = showTitle3, --language
		})
		
		--不能领取兵符的原因
		local bEnableGet = true
		local strDisbaleStr = ""
		
		--如果未连接，不能领取兵符
		if bEnableGet then
			if (Pvp_Server:GetState() ~= 1) then --未连接
				--strDisbaleStr = "您已断开连接，请重新登入" --language
				strDisbaleStr = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
				
				--不能领取兵符
				bEnableGet = false
			end
		end
		
		--如果未登入，不能领取兵符
		if bEnableGet then
			if (not hGlobal.LocalPlayer:getonline()) then --未登入
				--strDisbaleStr = "您已断开连接，请重新登入" --language
				strDisbaleStr = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
				
				--不能领取兵符
				bEnableGet = false
			end
		end
		
		--如果今日已领取，不能重复领取
		if bEnableGet then
			--取服务器当前时间
			local localTime = os.time()
			local intTimeNow = localTime - g_localDeltaTime_pvp --现在服务器时间戳(Local = Host + deltaTime)
			local tabNow = os.date("*t", intTimeNow)
			local yearNow = tabNow.year
			local monthNow = tabNow.month
			local dayNow = tabNow.day
			--print("Now:", yearNow, monthNow, dayNow)
			
			local intTimeOld = hApi.GetNewDate(g_myPvP_BaseInfo.pvpcoin_last_gettime) --上一次存档的时间戳
			local tabOld = os.date("*t", intTimeOld)
			local yearOld = tabOld.year
			local monthOld = tabOld.month
			local dayOld = tabOld.day
			--print("Old:", yearOld, monthOld, dayOld)
			
			--同一天
			if (yearNow == yearOld) and (monthNow == monthOld) and (dayNow == dayOld) then
				--strDisbaleStr = "每日只能领取一次！" --language
				strDisbaleStr = hVar.tab_string["__TEXT_PVP_PvpCoinGetOnceDay"] --language
				
				--不能领取兵符
				bEnableGet = false
			end
		end
		
		--兵符是满的
		if bEnableGet then
			if (g_myPvP_BaseInfo.pvpcoin >= hVar.PVP_COIN_MAX_NUM) then
				--strDisbaleStr = "兵符不足100才能领取！" --language
				strDisbaleStr = hVar.tab_string["__TEXT_PVP_PvpCoinGetMax"] --language
				
				--不能领取兵符
				bEnableGet = false
			end
		end
		
		--领取按钮
		msgBox.childUI["btnOk"] = hUI.button:new({
			parent = msgBox.handle._n,
			dragbox = msgBox.childUI["dragBox"],
			model = "misc/mask.png",
			x = 225,
			y = -255,
			scaleT = 0.95,
			code = function()
				if bEnableGet then
					--挡操作
					hUI.NetDisable(30000)
					
					--发送领取兵符的协议
					SendPvpCmdFunc["get_pvpcoin_everyday"]()
				else
					hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "",
						lifetime = 1000,
						fadeout = -550,
						moveY = 32,
					}):addtext(strDisbaleStr, hVar.FONTC, 40, "MC", 0, 0)
				end
			end,
			w = 200,
			h = 90,
		})
		msgBox.childUI["btnOk"].handle.s:setOpacity(0) --只响应控制，不显示
		msgBox.childUI["btnOk"].childUI["image"] = hUI.image:new({
			parent = msgBox.childUI["btnOk"].handle._n,
			x = 0,
			y = 0,
			model = "UI:BTN_ButtonRed",
			scale = 1.2,
		})
		msgBox.childUI["btnOk"].childUI["labelName"] = hUI.label:new({
			parent = msgBox.childUI["btnOk"].handle._n,
			x = 0,
			y = -2, --数字字体有2像素偏差
			--text = "领取", --language
			text = hVar.tab_string["__Get__"], --language
			font = hVar.FONTC,
			align = "MC",
			size = 32,
			border = 1,
		})
		
		--如果不能领兵符，显示原因
		if (not bEnableGet) then
			--按钮灰掉
			--msgBox.childUI["btnOk"].handle.s:setColor(ccc3(168, 168, 168))
			hApi.AddShader(msgBox.childUI["btnOk"].childUI["image"].handle.s, "gray")
			
			--显示原因
			msgBox.childUI["disableReason"] = hUI.label:new({
				parent = msgBox.handle._n,
				x = 225,
				y = -200,
				size = 24,
				font = hVar.FONTC,
				align = "MT",
				width = 500,
				border = 1,
				text = strDisbaleStr, --language
			})
			msgBox.childUI["disableReason"].handle.s:setColor(ccc3(255, 0, 0))
		end
		
		--说明4
		--local showTitle4 = "兑换兵符" --language
		local showTitle4 = hVar.tab_string["__TEXT_PVP_PvpCoinGetMsgBox4"] --language
		msgBox.childUI["label3"] = hUI.label:new({
			parent = msgBox.handle._n,
			x = 225,
			y = -365,
			size = 26,
			font = hVar.FONTC,
			align = "MT",
			width = 500,
			border = 1,
			text = showTitle4, --language
		})
		
		--说明5
		--local showTitle5 = "20游戏币 =  30兵符" --language
		local requireGameCoin = 20
		local exchangePvpCoin = 30
		--游戏币图标
		msgBox.childUI["label5_1"] = hUI.image:new({
			parent = msgBox.handle._n,
			x = 225 - 70,
			y = -410,
			model = "UI:game_coins",
			w = 36,
			h = 36,
		})
		--游戏币值
		msgBox.childUI["label5_2"] = hUI.label:new({
			parent = msgBox.handle._n,
			x = 240 - 70,
			y = -410 - 3,
			text = requireGameCoin,
			font = "numWhite",
			align = "LC",
			size = 21,
			border = 0,
		})
		msgBox.childUI["label5_2"].handle.s:setColor(ccc3(255, 236, 0))
		--等于号
		msgBox.childUI["label5_3"] = hUI.label:new({
			parent = msgBox.handle._n,
			x = 302 - 70,
			y = -410 - 3,
			text = "=",
			font = "numWhite",
			align = "MC",
			size = 26,
			border = 0,
		})
		--兵符图标
		msgBox.childUI["label5_4"] = hUI.image:new({
			parent = msgBox.handle._n,
			x = 340 - 70,
			y = -410,
			model = "UI:uitoken",
			w = 24,
			h = 30,
		})
		--兵符值
		msgBox.childUI["label5_5"] = hUI.label:new({
			parent = msgBox.handle._n,
			x = 350 - 70,
			y = -410 - 3,
			text = exchangePvpCoin .. " ",
			font = hVar.FONTC,
			align = "LC",
			size = 30,
			border = 1,
		})
		msgBox.childUI["label5_5"].handle.s:setColor(ccc3(236, 236, 236))
		
		--兑换按钮
		msgBox.childUI["btnExchange"] = hUI.button:new({
			parent = msgBox.handle._n,
			dragbox = msgBox.childUI["dragBox"],
			model = "misc/mask.png",
			x = 225,
			y = -460,
			w = 200,
			h = 90,
			scaleT = 0.95,
			code = function()
				--如果未连接，不能兑换兵符
				if (Pvp_Server:GetState() ~= 1) then --未连接
					--local strDisbaleStr = "您已断开连接，请重新登入" --language
					local strDisbaleStr = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
					
					hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "",
						lifetime = 1000,
						fadeout = -550,
						moveY = 32,
					}):addtext(strDisbaleStr, hVar.FONTC, 40, "MC", 0, 0)
					
					return
				end
				
				--如果未登入，不能兑换兵符
				if (not hGlobal.LocalPlayer:getonline()) then --未登入
					--local strDisbaleStr = "您已断开连接，请重新登入" --language
					local strDisbaleStr = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
					
					hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "",
						lifetime = 1000,
						fadeout = -550,
						moveY = 32,
					}):addtext(strDisbaleStr, hVar.FONTC, 40, "MC", 0, 0)
					
					return
				end
				
				--游戏币不足，不能兑换兵符
				if (LuaGetPlayerRmb() < requireGameCoin) then
					--[[
					--弹系统框
					--local msgTitle = "游戏币不足" --language
					local msgTitle = hVar.tab_string["ios_not_enough_game_coin"] --language
					hGlobal.UI.MsgBox(msgTitle,{
						font = hVar.FONTC,
						ok = function()
						end,
					})
					]]
					
					--弹出游戏币不足并提示是否购买的框
					hGlobal.event:event("LocalEvent_BuyItemfail", 1, 0)
					
					return
				end
				
				--可以兑换
				--挡操作
				hUI.NetDisable(30000)
					
				--发送领取兵符的协议
				SendPvpCmdFunc["buy_pvpcoin"]()
			end,
		})
		msgBox.childUI["btnExchange"].handle.s:setOpacity(0) --只响应控制，不显示
		msgBox.childUI["btnExchange"].childUI["image"] = hUI.image:new({
			parent = msgBox.childUI["btnExchange"].handle._n,
			x = 0,
			y = 0,
			model = "UI:BTN_ButtonRed",
			scale = 1.2,
		})
		msgBox.childUI["btnExchange"].childUI["labelName"] = hUI.label:new({
			parent = msgBox.childUI["btnExchange"].handle._n,
			x = 0,
			y = -2, --数字字体有2像素偏差
			--text = "兑换", --language
			text = hVar.tab_string["__Exchange__"], --language
			font = hVar.FONTC,
			align = "MC",
			size = 32,
			border = 1,
		})
	end
	
	--函数：创建铜雀台界面（第2个分页）
	OnCreateTongQueTaiLogoShowFrame = function(pageIndex)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		-----------------------------------------------------------------------
		--本分页，一直显示的控件
		--子按钮1-娱乐房
		_frmNode.childUI["SubPageBtn1"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			x = PAGE_BTN_LEFT_X - 60,
			y = PAGE_BTN_LEFT_Y - 100 - PAGE_BTN_OFFSET_Y * 2,
			w = 110,
			h = 100,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function(self, screenX, screenY, isInside)
				--不重复显示同一个分页（这里同时子分页也一样才行）
				if (CurrentSelectRecord.pageIdx == pageIndex) and (CurrentSelectRecord.contentIdx == 2) then
					--print("不重复显示同一个子分页")
					return
				end
				
				--移除所有的监听、timer、clipNode
				OnClearAllEventsAndTimers()
				
				--只清空子分页的控件
				_removeLeftFrmFunc()
				_removeRightFrmFunc()
				
				--标记子分页
				CurrentSelectRecord.contentIdx = 2
				
				--本按钮突出显示
				_frmNode.childUI["SubPageBtn1"].handle._n:setPositionX(PAGE_BTN_LEFT_X - 60 + 7)
				_frmNode.childUI["SubPageBtn1"].childUI["PageImage"].handle.s:setColor(ccc3(255, 255, 255))
				_frmNode.childUI["SubPageBtn2"].handle._n:setPositionX(PAGE_BTN_LEFT_X - 60)
				_frmNode.childUI["SubPageBtn2"].childUI["PageImage"].handle.s:setColor(ccc3(168, 168, 168))
				
				--创建娱乐房界面（第2个分页的子分页1）
				OnCreateBattleRoomSubFrame_page2(pageIdx)
				--print("创建娱乐房界面")
			end,
		})
		_frmNode.childUI["SubPageBtn1"].handle.s:setOpacity(0) --分页子按钮点击区域，只作为控制用，不用于显示
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "SubPageBtn1"
		
		--子按钮1的方块图标
		_frmNode.childUI["SubPageBtn1"].childUI["PageImage"] = hUI.image:new({
			parent = _frmNode.childUI["SubPageBtn1"].handle._n,
			model = "misc/pvp/pvpfb.png",
			x = 10,
			y = 0,
			scale = 1.0,
		})
		
		--子按钮2-出战
		_frmNode.childUI["SubPageBtn2"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			x = PAGE_BTN_LEFT_X - 60,
			y = PAGE_BTN_LEFT_Y - 100 - PAGE_BTN_OFFSET_Y * 1,
			w = 110,
			h = 100,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function(self, screenX, screenY, isInside)
				--不重复显示同一个分页（这里同时子分页也一样才行）
				if (CurrentSelectRecord.pageIdx == pageIndex) and (CurrentSelectRecord.contentIdx == 4) then
					--print("不重复显示同一个子分页")
					return
				end
				
				--移除所有的监听、timer、clipNode
				OnClearAllEventsAndTimers()
				
				--只清空子分页的控件
				_removeLeftFrmFunc()
				_removeRightFrmFunc()
				
				--标记子分页
				CurrentSelectRecord.contentIdx = 4
				
				--本按钮突出显示
				_frmNode.childUI["SubPageBtn1"].handle._n:setPositionX(PAGE_BTN_LEFT_X - 60)
				_frmNode.childUI["SubPageBtn1"].childUI["PageImage"].handle.s:setColor(ccc3(168, 168, 168))
				_frmNode.childUI["SubPageBtn2"].handle._n:setPositionX(PAGE_BTN_LEFT_X - 60 + 7)
				_frmNode.childUI["SubPageBtn2"].childUI["PageImage"].handle.s:setColor(ccc3(255, 255, 255))
				
				--创建铜雀台配置卡牌子分页（第2个分页的子分页4）
				OnCreateConfigCardSubFrame_page2(pageIdx)
			end,
		})
		_frmNode.childUI["SubPageBtn2"].handle.s:setOpacity(0) --分页子按钮点击区域，只作为控制用，不用于显示
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "SubPageBtn2"
		
		--子按钮2的方块图标
		_frmNode.childUI["SubPageBtn2"].childUI["PageImage"] = hUI.image:new({
			parent = _frmNode.childUI["SubPageBtn2"].handle._n,
			model = "misc/pvp/pvpcj.png",
			x = 10,
			y = 0,
			scale = 1.0,
		})
		
		--排行榜图标
		_frmNode.childUI["RnkBoardButton"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			x = PAGE_BTN_LEFT_X - 60,
			y = PAGE_BTN_LEFT_Y - 110 - PAGE_BTN_OFFSET_Y * 3,
			w = 110,
			h = 100,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function(self, screenX, screenY, isInside)
				--不重复显示同一个分页（这里同时子分页也一样才行）
				if (CurrentSelectRecord.pageIdx == pageIndex) and (CurrentSelectRecord.contentIdx == 5) then
					--print("不重复显示同一个子分页")
					return
				end
				
				--移除所有的监听、timer、clipNode
				OnClearAllEventsAndTimers()
				
				--只清空子分页的控件
				_removeLeftFrmFunc()
				_removeRightFrmFunc()
				
				--标记子分页
				CurrentSelectRecord.contentIdx = 5
				
				--本按钮突出显示
				_frmNode.childUI["SubPageBtn1"].handle._n:setPositionX(PAGE_BTN_LEFT_X - 60)
				_frmNode.childUI["SubPageBtn1"].childUI["PageImage"].handle.s:setColor(ccc3(168, 168, 168))
				_frmNode.childUI["SubPageBtn2"].handle._n:setPositionX(PAGE_BTN_LEFT_X - 60)
				_frmNode.childUI["SubPageBtn2"].childUI["PageImage"].handle.s:setColor(ccc3(168, 168, 168))
				
				--点击排行榜按钮
				--触发事件，显示铜雀台排行榜界面
				hGlobal.event:event("LocalEvent_Phone_ShowRankBorad_PVP_Endless")
			end,
		})
		_frmNode.childUI["RnkBoardButton"].handle.s:setOpacity(0) --分页子按钮点击区域，只作为控制用，不用于显示
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "RnkBoardButton"
		--"排行榜"的图标
		_frmNode.childUI["RnkBoardButton"].childUI["image"] = hUI.image:new({
			parent = _frmNode.childUI["RnkBoardButton"].handle._n,
			x = 0,
			y = 0,
			model = "UI:phb",
			scale = 0.9,
		})
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.8, 0.92), CCScaleTo:create(0.8, 0.88))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["RnkBoardButton"].childUI["image"].handle._n:runAction(forever)
		
		--在线人数
		_frmNode.childUI["RoomOnlineLabelPrefix"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 60,
			y = PVPROOM.OFFSET_Y - 535,
			size = 28,
			font = hVar.FONTC,
			align = "MC",
			width = 500,
			border = 1,
			--text = "在线", --language
			text = hVar.tab_string["__TEXT_PVP_Online"], --language
		})
		_frmNode.childUI["RoomOnlineLabelPrefix"].handle.s:setColor(ccc3(255, 224, 0))
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "RoomOnlineLabelPrefix"
		
		--在线人数值
		_frmNode.childUI["RoomOnlineLabel"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 60,
			y = PVPROOM.OFFSET_Y - 570, --数字字体有1像素的偏差
			size = 24,
			font = "numWhite",
			align = "MC",
			width = 500,
			--border = 1,
			text = current_online_num,
		})
		_frmNode.childUI["RoomOnlineLabel"].handle.s:setColor(ccc3(255, 224, 0))
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "RoomOnlineLabel"
		
		--[[
		--星星区域的按钮响应（用于查看星星介绍）
		_frmNode.childUI["Icon_Star_Btn"] = hUI.button:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 250 - 10,
			y = PVPROOM.OFFSET_Y - 83,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			w = 160,
			h = 70,
			scaleT = 1.0,
			code = function()
				--创建通用tip-战功积分
				local strModelStar = "UI:STAR_YELLOW"
				--local strTitleStar = "战功积分" --language
				local strTitleStar = hVar.tab_string["PVPStar"] --language
				--local strIntroStar = "与玩家对战时，达到有效对战时间3分钟，按评价给予一定数量的战功积分。（上限200积分）\n战功积分可用于兑换锦囊。" --language
				local strIntroStar = hVar.tab_string["PVPStarIntroduce"] --language
				local offsetX = -250
				local offsetY = 120
				local colorTitle = ccc3(255, 255, 212)
				hApi.ShowGeneralTip(strModelStar, strTitleStar, strIntroStar, offsetX, offsetY, colorTitle)
			end,
		})
		_frmNode.childUI["Icon_Star_Btn"].handle.s:setOpacity(0) --不显示，只用于控制
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "Icon_Star_Btn"
		
		--星星区域的底纹
		_frmNode.childUI["Icon_Star_BG"] = hUI.image:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 250,
			y = PVPROOM.OFFSET_Y - 83,
			model = "UI:PVP_RedCover",
			w = 130,
			h = 32,
		})
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "Icon_Star_BG"
		
		--星星图标
		_frmNode.childUI["Icon_Star"] = hUI.image:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 250 - 62,
			y = PVPROOM.OFFSET_Y - 83 + 1,
			model = "UI:STAR_YELLOW",
			w = 42,
			h = 42,
		})
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "Icon_Star"
		
		--星星数量
		_frmNode.childUI["Icon_Star_Num"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 250 - 35,
			y = PVPROOM.OFFSET_Y - 83 - 2, --数字字体有2像素偏差
			size = 23,
			font = "num",
			align = "LC",
			width = 500,
			--border = 1,
			text = g_myPvP_BaseInfo.evaluateE,
		})
		--_frmNode.childUI["Icon_Star_Num"].handle.s:setColor(ccc3(255, 255, 0))
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "Icon_Star_Num"
		--与上次的星星数量发生变化，播放动画
		if (current_evaluateStar ~= g_myPvP_BaseInfo.evaluateE) then
			--本地的战功积分
			current_evaluateStar = g_myPvP_BaseInfo.evaluateE
			
			local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.08, 1.3), CCScaleTo:create(0.08, 0.88))
			_frmNode.childUI["Icon_Star_Num"].handle._n:runAction(towAction)
		end
		]]
		
		--兵符区域的按钮响应（用于查看星星介绍）
		_frmNode.childUI["Icon_HuFu_Btn"] = hUI.button:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 201 + 50,
			y = PVPROOM.OFFSET_Y - 83,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			w = 200,
			h = 70,
			scaleT = 1.0,
			code = function()
				--领取兵符操作
				OnGetPvpCoinButton()
			end,
		})
		_frmNode.childUI["Icon_HuFu_Btn"].handle.s:setOpacity(0) --不显示，只用于控制
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "Icon_HuFu_Btn"
		
		--兵符区域的底纹
		_frmNode.childUI["Icon_HuFu_BG"] = hUI.image:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 211 + 30,
			y = PVPROOM.OFFSET_Y - 83,
			model = "UI:PVP_BlueCover",
			w = 130,
			h = 32,
		})
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "Icon_HuFu_BG"
		
		--兵符图标
		_frmNode.childUI["Icon_HuFu"] = hUI.image:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 211 - 34,
			y = PVPROOM.OFFSET_Y - 83,
			model = "UI:uitoken",
			scale = 1.1,
		})
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "Icon_HuFu"
		
		--兵符数量
		_frmNode.childUI["Icon_HuFu_Num"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 211 - 12,
			y = PVPROOM.OFFSET_Y - 83 - 2, --数字字体有1像素偏差
			size = 28,
			font = hVar.FONTC,
			align = "LC",
			width = 500,
			border = 1,
			text = g_myPvP_BaseInfo.pvpcoin,
		})
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "Icon_HuFu_Num"
		--与上次的兵符数量发生变化，播放动画
		if (current_pvpcoin ~= g_myPvP_BaseInfo.pvpcoin) then
			--本地的竞技场兵符
			current_pvpcoin = g_myPvP_BaseInfo.pvpcoin
			
			local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.08, 1.3), CCScaleTo:create(0.08, 1.0))
			--_frmNode.childUI["Icon_HuFu_Num"].handle._n:runAction(towAction)
		end
		
		--"领取兵符"的按钮
		_frmNode.childUI["GetHuFuBtn"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			model = "UI:add_exAttrPoint", --"BTN:PANEL_CLOSE",
			x = PVPROOM.OFFSET_X + 211 + 90,
			y = PVPROOM.OFFSET_Y - 83 + 1,
			w = 30,
			h = 30,
			--label = "领取兵符",
			--font = hVar.FONTC,
			--border = 1,
			scaleT = 0.95,
			code = function()
				--领取兵符操作
				OnGetPvpCoinButton()
			end,
		})
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "GetHuFuBtn"
		--[[
		--"领取兵符"的文字
		_frmNode.childUI["GetHuFuBtn"].childUI["label"] = hUI.label:new({
			parent = _frmNode.childUI["GetHuFuBtn"].handle._n,
			x = 0,
			y = -2, --文字有2像素的偏差
			size = 22,
			--text = "领取兵符", --language
			text = hVar.tab_string["__Get__"] .. hVar.tab_string["ios_bingfu"], --language
			align = "MC",
			font = hVar.FONTC,
			border = 1,
		})
		]]
		
		--[[
		--我的战绩的背景图1
		_frmNode.childUI["RoomMyRankBG1"] = hUI.image:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			model = "UI:AttrBg",
			x = PVPROOM.OFFSET_X + 710,
			y = PVPROOM.OFFSET_Y - 83,
			w = 420,
			h = 40,
		})
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "RoomMyRankBG1"
		
		--我的战绩的背景图2
		_frmNode.childUI["RoomMyRankBG2"] = hUI.image:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			model = "ui/title_line.png",
			x = PVPROOM.OFFSET_X + 710,
			y = PVPROOM.OFFSET_Y - 83 + 20,
			w = 420,
			h = 3,
		})
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "RoomMyRankBG2"
		
		--我的战绩的背景图3
		_frmNode.childUI["RoomMyRankBG3"] = hUI.image:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			model = "ui/title_line.png",
			x = PVPROOM.OFFSET_X + 710,
			y = PVPROOM.OFFSET_Y - 83 - 20,
			w = 420,
			h = 3,
		})
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "RoomMyRankBG3"
		
		--胜率的按钮响应（用于查看胜率介绍）
		_frmNode.childUI["Icon_WinRate_Btn"] = hUI.button:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + BOARD_WIDTH - 378,
			y = PVPROOM.OFFSET_Y - 83,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			w = 120,
			h = 70,
			scaleT = 1.0,
			code = function()
				--创建通用tip-竞技场胜率
				local strModelStar = nil
				--local strTitleStar = "胜率" --language
				local strTitleStar = hVar.tab_string["PVPVictory"] --language
				--local strIntroStar = "在夺塔奇兵对战中，每完成一把有效局（与玩家对战、游戏时间大于3分钟），总场次加1。\n每完成一把有效局的胜利，胜利场次加1。" --language
				local strIntroStar = hVar.tab_string["PVPWinRateIntroduce"] --language
				local offsetX = 0
				local offsetY = 120
				local colorTitle = ccc3(48, 225, 39)
				hApi.ShowGeneralTip(strModelStar, strTitleStar, strIntroStar, offsetX, offsetY, colorTitle)
			end,
		})
		_frmNode.childUI["Icon_WinRate_Btn"].handle.s:setOpacity(0) --不显示，只用于控制
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "Icon_WinRate_Btn"
		
		--显示我的胜率前缀
		_frmNode.childUI["RoomMyWinRatePrefixLabel"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + BOARD_WIDTH - 440,
			y = PVPROOM.OFFSET_Y - 85,
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 500,
			border = 1,
			--text = "胜率", --language
			text = hVar.tab_string["PVPVictory"] .. "", --language
		})
		_frmNode.childUI["RoomMyWinRatePrefixLabel"].handle.s:setColor(ccc3(48, 225, 39))
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "RoomMyWinRatePrefixLabel"
		
		--显示我的胜率值
		_frmNode.childUI["RoomMyWinRateLabel"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + BOARD_WIDTH - 440 + 60,
			y = PVPROOM.OFFSET_Y - 85 - 1, --数字字体有1像素偏差
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 500,
			border = 1,
			text = (g_myPvP_BaseInfo.winE) .. "/" .. (g_myPvP_BaseInfo.totalE),
		})
		--_frmNode.childUI["RoomMyWinRateLabel"].handle.s:setColor(ccc3(48, 225, 39))
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "RoomMyWinRateLabel"
		
		--逃跑的按钮响应（用于查看胜率介绍）
		_frmNode.childUI["Icon_EscapeRate_Btn"] = hUI.button:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + BOARD_WIDTH - 247,
			y = PVPROOM.OFFSET_Y - 83,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			w = 140,
			h = 70,
			scaleT = 1.0,
			code = function()
				--创建通用tip-竞技场逃跑
				local strModelStar = nil
				--local strTitleStar = "逃跑" --language
				local strTitleStar = hVar.tab_string["__TEXT_Surrender"] --language
				--local strIntroStar = "与玩家对战时，未达到有效对战时间3分钟的情况下，点击逃跑按钮离开游戏，逃跑次数加1，并扣除1点战功积分。\n逃跑或掉线每累计达到3次，" .. (g_myPvP_BaseInfo.escapePunishTime / 60) .. "分钟内无法对战，并且之后打开的第一个锦囊掉率减半。" --language
				local strIntroStar = hVar.tab_string["PVPEscapeIntroduce1"] .. (g_myPvP_BaseInfo.escapePunishTime / 60) .. hVar.tab_string["PVPEscapeIntroduce2"] --language
				local offsetX = 140
				local offsetY = 120
				local colorTitle = ccc3(193, 43, 43)
				hApi.ShowGeneralTip(strModelStar, strTitleStar, strIntroStar, offsetX, offsetY, colorTitle)
			end,
		})
		_frmNode.childUI["Icon_EscapeRate_Btn"].handle.s:setOpacity(0) --不显示，只用于控制
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "Icon_EscapeRate_Btn"
		
		--显示我的逃跑率前缀
		_frmNode.childUI["RoomMyEscapeRatePrefixLabel"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + BOARD_WIDTH - 290,
			y = PVPROOM.OFFSET_Y - 85,
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 500,
			border = 1,
			--text = "逃跑", --language
			text = hVar.tab_string["__TEXT_Surrender"] .. "", --language
		})
		_frmNode.childUI["RoomMyEscapeRatePrefixLabel"].handle.s:setColor(ccc3(193, 43, 43))
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "RoomMyEscapeRatePrefixLabel"
		
		--显示我的逃跑率值
		local escapeRate = 0
		local escapeColor = nil
		if (g_myPvP_BaseInfo.escapeE >= PVPROOM_COLOR_RATE_MIN) then
			--escapeRate = math.ceil(g_myPvP_BaseInfo.escapeE / (g_myPvP_BaseInfo.escapeE + g_myPvP_BaseInfo.totalE) * 100)
			escapeRate = g_myPvP_BaseInfo.escapeE
		end
		for i = #PVPROOM_COLOR_RATE_TABLE, 1 , -1 do
			if (escapeRate >= PVPROOM_COLOR_RATE_TABLE[i][1]) then
				escapeColor = PVPROOM_COLOR_RATE_TABLE[i][2]
				break
			end
		end
		_frmNode.childUI["RoomMyEscapeRateLabel"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + BOARD_WIDTH - 290 + 60,
			y = PVPROOM.OFFSET_Y - 85, - 1, --数字字体有1像素偏差
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 500,
			--border = 1,
			--text = (escapeRate) .. "%",
			text = (escapeRate),
		})
		_frmNode.childUI["RoomMyEscapeRateLabel"].handle.s:setColor(escapeColor)
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "RoomMyEscapeRateLabel"
		
		--掉线的按钮响应（用于查看胜率介绍）
		_frmNode.childUI["Icon_OfflineRate_Btn"] = hUI.button:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + BOARD_WIDTH - 106,
			y = PVPROOM.OFFSET_Y - 83,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			w = 140,
			h = 70,
			scaleT = 1.0,
			code = function()
				--创建通用tip-竞技场掉线
				local strModelStar = nil
				--local strTitleStar = "掉线" --language
				local strTitleStar = hVar.tab_string["PVPOfflineRate"] --language
				--local strIntroStar = "与玩家对战时，网络断开连接或其它异常离开，掉线次数加1，并扣除2点战功积分。\n逃跑或掉线每累计达到3次，" .. (g_myPvP_BaseInfo.escapePunishTime / 60) .. "分钟内无法对战，并且之后打开的第一个锦囊掉率减半。" --language
				local strIntroStar = hVar.tab_string["PVPOfflineIntroduce1"] .. (g_myPvP_BaseInfo.escapePunishTime / 60) .. hVar.tab_string["PVPOfflineIntroduce2"] --language
				local offsetX = 257
				local offsetY = 120
				local colorTitle = ccc3(193, 43, 43)
				hApi.ShowGeneralTip(strModelStar, strTitleStar, strIntroStar, offsetX, offsetY, colorTitle)
			end,
		})
		_frmNode.childUI["Icon_OfflineRate_Btn"].handle.s:setOpacity(0) --不显示，只用于控制
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "Icon_OfflineRate_Btn"
		
		--显示我的掉线率前缀
		_frmNode.childUI["RoomMyOfflineRatePrefixLabel"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + BOARD_WIDTH - 160,
			y = PVPROOM.OFFSET_Y - 85,
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 500,
			border = 1,
			--text = "掉线", --language
			text = hVar.tab_string["PVPOfflineRate"] .. "", --language
		})
		_frmNode.childUI["RoomMyOfflineRatePrefixLabel"].handle.s:setColor(ccc3(193, 43, 43))
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "RoomMyOfflineRatePrefixLabel"
		
		--显示我的掉线率值
		local offlineRate = 0
		local offlineColor = nil
		if (g_myPvP_BaseInfo.errE >= PVPROOM_COLOR_RATE_MIN) then
			--offlineRate = math.ceil(g_myPvP_BaseInfo.errE / (g_myPvP_BaseInfo.errE + g_myPvP_BaseInfo.totalE) * 100)
			offlineRate = g_myPvP_BaseInfo.errE
		end
		for i = #PVPROOM_COLOR_RATE_TABLE, 1 , -1 do
			if (offlineRate >= PVPROOM_COLOR_RATE_TABLE[i][1]) then
				offlineColor = PVPROOM_COLOR_RATE_TABLE[i][2]
				break
			end
		end
		_frmNode.childUI["RoomMyOfflineRateLabel"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + BOARD_WIDTH - 160 + 60,
			y = PVPROOM.OFFSET_Y - 85 - 1, --数字字体有1像素偏差
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 500,
			--border = 1,
			--text = (offlineRate) .. "%",
			text = (offlineRate),
		})
		_frmNode.childUI["RoomMyOfflineRateLabel"].handle.s:setColor(offlineColor)
		pagerightRemoveFrmList[#pagerightRemoveFrmList + 1] = "RoomMyOfflineRateLabel"
		]]
		
		-----------------------------------------------------------------------
		--只在本页面下的控件
		--[[
		--父控件（只用于挂载子控件的大图）
		_frmNode.childUI["Parent"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			x = 0,
			y = 0,
			w = 1,
			h = 1,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "Parent"
		_frmNode.childUI["Parent"].handle.s:setOpacity(0) --只用于挂载子控件，不显示
		
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/addition/pvp_tqt.jpg")
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/addition/pvp_tqt.jpg")
			--print("加载大图-铜雀台！")
		end
		--print(tostring(texture))
		local tSize = texture:getContentSize()
		local pSprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
		pSprite:setPosition(117, -631)
		pSprite:setAnchorPoint(ccp(0, 0))
		--pSprite:setScaleX(1.106)
		--pSprite:setScaleY(1.051)
		--local rx = tSize.width * 1.106
		--local ry = tSize.height * 1.051
		--print(rx, ry)
		_frmNode.childUI["Parent"].handle._n:addChild(pSprite)
		]]
		
		--绘制双龙塔
		_frmNode.childUI["Title_td_slt_Img"] = hUI.button:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 268,
			y = PVPROOM.OFFSET_Y - 335,
			model = "MODEL_EFFECT:td_slt",
			w = 240,
			h = 272,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "Title_td_slt_Img"
		
		--绘制标题背景图
		_frmNode.childUI["TitleBGImg"] = hUI.button:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 291,
			y = PVPROOM.OFFSET_Y - 170,
			model = "PVP:imgtitlebg",
			w = 348,
			h = 82,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "TitleBGImg"
		
		--绘制标题图
		_frmNode.childUI["TitleImg"] = hUI.button:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 268,
			y = PVPROOM.OFFSET_Y - 156,
			model = "PVP:txtmolongbaoku",
			w = 154,
			h = 44,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "TitleImg"
		
		--大金币1(左)
		_frmNode.childUI["Gold1Img"] = hUI.button:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 176,
			y = PVPROOM.OFFSET_Y - 390,
			model = "UI:Purchase_6",
			w = 143,
			h = 104,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "Gold1Img"
		
		--神器晶石1(左)
		_frmNode.childUI["Debris1Img"] = hUI.button:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 303,
			y = PVPROOM.OFFSET_Y - 395,
			model = "icon/item/chip06.png",
			w = 32,
			h = 36,
		})
		_frmNode.childUI["Debris1Img"].handle.s:setRotation(-76)
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "Debris1Img"
		
		--献祭之石
		_frmNode.childUI["Sone1Img"] = hUI.button:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 217,
			y = PVPROOM.OFFSET_Y - 404,
			model = "icon/item/item_treasure34.png",
			w = 38,
			h = 38,
		})
		_frmNode.childUI["Sone1Img"].handle.s:setRotation(-100)
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "Sone1Img"
		
		--大金币2(右)
		_frmNode.childUI["Gold2Img"] = hUI.button:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 348,
			y = PVPROOM.OFFSET_Y - 400,
			model = "UI:Purchase_6",
			w = 143,
			h = 104,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "Gold2Img"
		
		--中金币
		_frmNode.childUI["GoldMImg"] = hUI.button:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 330,
			y = PVPROOM.OFFSET_Y - 420,
			model = "UI:Purchase_2",
			w = 110,
			h = 80,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "GoldMImg"
		
		--大金币3(中)
		_frmNode.childUI["Gold3Img"] = hUI.button:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 254,
			y = PVPROOM.OFFSET_Y - 412,
			model = "UI:Purchase_6",
			w = 143,
			h = 104,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "Gold3Img"
		
		--神器晶石2(左)
		_frmNode.childUI["Debris2Img"] = hUI.button:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 284,
			y = PVPROOM.OFFSET_Y - 446,
			model = "icon/item/chip06.png",
			w = 32,
			h = 36,
		})
		_frmNode.childUI["Debris2Img"].handle.s:setRotation(20)
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "Debris2Img"
		
		--本周关卡内获得以下效果
		_frmNode.childUI["ThisWeekEffectPrefixLabel"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 122,
			y = PVPROOM.OFFSET_Y - 482,
			size = 20,
			font = hVar.FONTC,
			align = "LC",
			width = 500,
			border = 1,
			--text = "本周关卡内获得以下效果", --language
			text = hVar.tab_string["__TEXT_PVP_THIS_WEEK_EFFECT"], --language
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "ThisWeekEffectPrefixLabel"
		
		--效果背景图
		_frmNode.childUI["ThisWeekEffectBGImg"] = hUI.button:new({ --作为按钮是为了挂载子控件
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 285,
			y = PVPROOM.OFFSET_Y - 575,
			model = "misc/mask.png",
			w = 330,
			h = 150,
		})
		_frmNode.childUI["ThisWeekEffectBGImg"].handle.s:setOpacity(0) --只挂载子控件，不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "ThisWeekEffectBGImg"
		
		--9宫格
		hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/pvp/playerbg.png", 0, 0, 330, 154, _frmNode.childUI["ThisWeekEffectBGImg"])
		hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/attr_bg.png", 0, 0, 330, 150, _frmNode.childUI["ThisWeekEffectBGImg"])
		
		--依次绘制3种效果
		for i = 1, 3, 1 do
			--按钮i
			_frmNode.childUI["ThisWeekCardBtn" .. i] = hUI.button:new({
				parent = _parentNode,
				x = PVPROOM.OFFSET_X + 285,
				y = PVPROOM.OFFSET_Y - 480 - i * (46 + 2),
				model = "misc/mask.png",
				w = 330,
				h = 46,
				dragbox = _frm.childUI["dragBox"],
				scaleT = 0.98,
				code = function()
					--读取战术卡i是否存在
					if current_TakeEffectCfg then
						local tacticList = current_TakeEffectCfg.tacticList
						if tacticList then
							local ti = tacticList[i]
							if ti then
								local tacticId = ti[1]
								if tacticId then
									--显示战术技能卡tip
									local rewardType = 2
									local tacticId = tacticId
									local tacticNum = 1
									local tacticLv = ti[2]
									hApi.ShowTacticCardTip(rewardType, tacticId, tacticLv)
								end
							end
						end
					end
				end,
			})
			_frmNode.childUI["ThisWeekCardBtn" .. i].handle.s:setOpacity(0) --只挂载子控件，不显示
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "ThisWeekCardBtn" .. i
			
			--战术卡图标
			_frmNode.childUI["ThisWeekCardBtn" .. i].childUI["icon"] = hUI.image:new({
				parent = _frmNode.childUI["ThisWeekCardBtn" .. i].handle._n,
				x = -140,
				y = 0,
				model = "ICON:skill_icon1_x3y3",
				w = 46,
				h = 46,
			})
			
			--战术卡文字
			_frmNode.childUI["ThisWeekCardBtn" .. i].childUI["intro"] = hUI.label:new({
				parent = _frmNode.childUI["ThisWeekCardBtn" .. i].handle._n,
				x = -110,
				y = 0,
				width = 300,
				align = "LC",
				font = hVar.FONTC,
				size = 24,
				border = 1,
				text = "--",
			})
			
			--获取战术卡菊花
			_frmNode.childUI["ThisWeekCardBtn" .. i].childUI["waiting"] = hUI.image:new({
				parent = _frmNode.childUI["ThisWeekCardBtn" .. i].handle._n,
				x = 100,
				y = 0,
				model = "MODEL_EFFECT:waiting",
				w = 42,
				h = 42,
			})
		end
		
		--神器合成的背景图1
		_frmNode.childUI["imgMergeBG1"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:RedEquipmentBG1",
			x = PVPROOM.OFFSET_X + 725,
			y = PVPROOM.OFFSET_Y - 340,
			w = 310,
			h = 310,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "imgMergeBG1"
		
		--神器合成的背景图2
		_frmNode.childUI["imgMergeBG2"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:RedEquipmentBG2",
			x = PVPROOM.OFFSET_X + 725,
			y = PVPROOM.OFFSET_Y - 340,
			w = 194,
			h = 194,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "imgMergeBG2"
		
		--通关奖励图片
		_frmNode.childUI["imgTitleBG"] = hUI.button:new({ --作为按钮是为了挂载子控件
			parent = _parentNode,
			model = "ui/pvp/pvptimeoutbg2.png",
			x = PVPROOM.OFFSET_X + 725,
			y = PVPROOM.OFFSET_Y - 186,
			w = 170,
			h = 40,
		})
		_frmNode.childUI["imgTitleBG"].handle.s:setOpacity(0) --只挂载子控件，不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "imgTitleBG"
		--九宫格
		local imgLvUpBg9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/pvp/pvptimeoutbg2.png", 0, 0, 170, 40, _frmNode.childUI["imgTitleBG"])
		--imgLvUpBg9:setOpacity(212)
		
		--通关奖励文字
		_frmNode.childUI["imgTitleLabel"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 725,
			y = PVPROOM.OFFSET_Y - 186 - 1, --文字有1像素的偏差
			width = 300,
			align = "MC",
			font = hVar.FONTC,
			size = 24,
			border = 1,
			--text = "随机奖励", --language
			text = hVar.tab_string["__RandDrop__"], --language
			RGB = {255, 255, 0},
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "imgTitleLabel"
		
		--奖励道具
		for i = 1, 4, 1 do
			--奖励按钮
			_frmNode.childUI["btnRewardItem" .. i] = hUI.button:new({
				parent = _parentNode,
				model = "misc/mask.png",
				x = PVPROOM.OFFSET_X + 684 + ((i - 1) % 2) * 80,
				y = PVPROOM.OFFSET_Y - 300 - math.floor((i - 1) / 2) * 78,
				w = 72,
				h = 72,
				dragbox = _frm.childUI["dragBox"],
				scaleT = 0.95,
				code = function()
					--读取战术卡i是否存在
					if current_TakeEffectCfg then
						local rewardShowList = current_TakeEffectCfg.rewardShowList
						if rewardShowList then
							local rewardT = rewardShowList[i]
							if rewardT then
								local rewardType = rewardT[1]
								--print(rewardType)
								
								--(1:积分 / 2:战术技能卡 / 3:道具 / 4:英雄 / 5:英雄将魂 / 6:战术技能卡碎片 / 7:游戏币 / 8:网络宝箱 / 9:抽奖类战术技能卡 / 10:神器 / 11:神器晶石)
								if (rewardType == 1) then --1:积分
									--显示积分介绍的tip
									hApi.ShowJiFennTip()
								elseif (rewardType == 2) then --2:战术技能卡
									--显示战术技能卡tip
									local tacticId = rewardT[2] or 0
									local tacticNum = rewardT[3] or 0
									local tacticLv = rewardT[4] or 1
									hApi.ShowTacticCardTip(rewardType, tacticId, tacticLv)
								elseif (rewardType == 3) then --3:道具
									--显示道具tip
									local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
									local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
									hGlobal.event:event("LocalEvent_ShowItemTipFram", {{rewardT[2], 1}}, nil, 1, itemtipX, itemtipY, 0)
								elseif (rewardType == 4) then --4:英雄
									--显示英雄tip
									local herotipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
									local herotipY = 600 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
									hGlobal.event:event("LocalEvent_HeroCardInfo", rewardT[2])
								elseif (rewardType == 5) then --5:英雄将魂
									--
								elseif (rewardType == 6) then --6:战术技能卡碎片
									--显示战术技能卡碎片tip
									local tacticId = rewardT[2] or 0
									local tacticNum = rewardT[3] or 0
									local tacticLv = rewardT[4] or 1
									hApi.ShowTacticCardTip(rewardType, tacticId, tacticLv)
								elseif (rewardType == 7) then --7:游戏币(服务器处理，客户端只拼日志)
									--显示游戏币介绍的tip
									hApi.ShowGameCoinTip()
								elseif (rewardType == 8) then --8:网络宝箱(服务器处理，客户端只拼日志)
									--显示道具tip
									local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
									local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
									hGlobal.event:event("LocalEvent_ShowItemTipFram", {{rewardT[2], 1}}, nil, 1, itemtipX, itemtipY, 0)
								elseif (rewardType == 9) then --9:抽奖类战术技能卡
									--显示道具tip
									local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
									local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
									hGlobal.event:event("LocalEvent_ShowItemTipFram", {{rewardT[2], 1}}, nil, 1, itemtipX, itemtipY, 0)
								elseif (rewardType == 10) then --10:红装神器
									--显示道具tip
									local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
									local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
									hGlobal.event:event("LocalEvent_ShowItemTipFram", {{rewardT[2], 1}}, nil, 1, itemtipX, itemtipY, 0)
								elseif (rewardType == 11) then --11:神器晶石
									--显示神器晶石介绍的tip
									hApi.ShowRedEquipDeribsTip()
								end
							end
						end
					end
				end,
			})
			_frmNode.childUI["btnRewardItem" .. i].handle.s:setOpacity(0) --只挂载子控件，不显示
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnRewardItem" .. i
			
			--道具黑色底图
			_frmNode.childUI["btnRewardItem" .. i].childUI["blackBG"] = hUI.image:new({
				parent = _frmNode.childUI["btnRewardItem" .. i].handle._n,
				model = "UI_frm:slot",
				animation = "normal",
				x = 0,
				y = 0,
				w = 64,
				h = 64,
			})
			
			--查新道具菊花
			_frmNode.childUI["btnRewardItem" .. i].childUI["waiting"] = hUI.image:new({
				parent = _frmNode.childUI["btnRewardItem" .. i].handle._n,
				x = 0,
				y = 0,
				model = "MODEL_EFFECT:waiting",
				w = 52,
				h = 52,
			})
		end
		
		--今日可领奖次数前缀
		_frmNode.childUI["battleCountPrefixLabel"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 765,
			y = PVPROOM.OFFSET_Y - 520,
			width = 300,
			align = "RC",
			font = hVar.FONTC,
			size = 22,
			border = 1,
			--text = "今日可领奖次数", --language
			text = hVar.tab_string["__TodayRewardCount"], --language
			--RGB = {255, 255, 0},
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "battleCountPrefixLabel"
		
		--今日可领奖次数值
		_frmNode.childUI["battleCountValueLabel"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 765 + 10,
			y = PVPROOM.OFFSET_Y - 520 - 1, --数字字体有1像素的偏差
			width = 300,
			align = "LC",
			font = "numWhite",
			size = 20,
			border = 0,
			text = "-/-",
			--RGB = {255, 255, 0},
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "battleCountValueLabel"
		
		--查询今日可领奖次数菊花
		_frmNode.childUI["battleCountWaiting"] = hUI.image:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 840,
			y = PVPROOM.OFFSET_Y - 520,
			model = "MODEL_EFFECT:waiting",
			w = 36,
			h = 36,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "battleCountWaiting"
		
		--"阵容配置"的按钮（分页0）
		_frmNode.childUI["ConfigCardButton"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
			model = "BTN:PANEL_CLOSE",
			x = PVPROOM.OFFSET_X + 730 - 90,
			y = PVPROOM.OFFSET_Y - 586,
			scale = 1.1,
			--label = "阵容配置",
			--font = hVar.FONTC,
			--border = 1,
			model = "UI:BTN_ButtonRed",
			animation = "normal",
			scaleT = 0.95,
			code = function()
				_frmNode.childUI["SubPageBtn2"].data.code()
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "ConfigCardButton"
		
		--"阵容配置"（分页0）的文字
		_frmNode.childUI["ConfigCardButton"].childUI["label"] = hUI.label:new({
			parent = _frmNode.childUI["ConfigCardButton"].handle._n,
			x = 0,
			y = -2, --文字有2像素的偏差
			size = 28,
			--text = "阵容配置", --language
			text = hVar.tab_string["__TEXT_PVP_BattleConfig"], --language
			align = "MC",
			font = hVar.FONTC,
			border = 1,
		})
		
		--"创建房间"的按钮（分页0）
		_frmNode.childUI["CreateRoomButton_page0"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
			model = "BTN:PANEL_CLOSE",
			x = PVPROOM.OFFSET_X + 730 + 90,
			y = PVPROOM.OFFSET_Y - 586,
			scale = 1.1,
			--label = "创建房间",
			--font = hVar.FONTC,
			--border = 1,
			model = "UI:BTN_ButtonRed",
			animation = "normal",
			scaleT = 0.95,
			code = function()
				_frmNode.childUI["SubPageBtn1"].data.code()
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "CreateRoomButton_page0"
		
		--"创建房间"的文字（分页0）
		_frmNode.childUI["CreateRoomButton_page0"].childUI["label"] = hUI.label:new({
			parent = _frmNode.childUI["CreateRoomButton_page0"].handle._n,
			x = 0,
			y = -2, --文字有2像素的偏差
			size = 28,
			--text = "创建房间", --language
			text = hVar.tab_string["__TEXT_PVP_Create"] .. hVar.tab_string["__TEXT_PVP_Room"], --language
			align = "MC",
			font = hVar.FONTC,
			border = 1,
		})
		
		--Pvp_Server:Close()
		
		--分页2-0(通用)
		--添加事件监听：收到pvp的ping值回调
		hGlobal.event:listen("LocalEvent_Pvp_Ping", "__PvpPing_page2_0", on_receive_ping_event_page2)
		--添加事件监听：收到连接结果回调
		hGlobal.event:listen("LocalEvent_Pvp_NetEvent", "__ConnectBack_page2_0", on_receive_connect_back_event_page2_0)
		--添加事件监听：收到登入结果回调
		hGlobal.event:listen("LocalEvent_Pvp_PlayerLoginEvent", "__LoginBack_page2_0", on_receive_login_back_event_page2_0)
		--添加事件监听：我的基础信息返回事件
		hGlobal.event:listen("LocalEvent_Pvp_UserBaseInfo", "__BattleBaseInfo_page2_0", on_receive_Pvp_baseInfoRet_page2)
		--添加事件监听：pvp错误信息提示
		hGlobal.event:listen("LocalEvent_Pvp_NetLogicError", "__NetLogicError_page2_0", on_receive_Pvp_NetLogicError_event)
		--添加事件监听：配置卡组回调事件
		hGlobal.event:listen("LocalEvent_Pvp_battleCfg", "__BattleCfgBack_page2_0", on_receive_Pvp_BattleCfg_event_page2_0)
		--添加事件监听：收到铜雀台今日生效配置信息
		hGlobal.event:listen("LocalEvent_PvpMulty_RoomTakeEffectCfg", "__PvpMultyCfgBack_page2_0", on_receive_multy_roomcfg_event_page2_0)
		
		--分页2-0
		--添加事件监听：收到铜雀台今日生效配置信息，刷新界面
		hGlobal.event:listen("LocalEvent_PvpMulty_RoomTakeEffectCfg", "__PvpMultyCfgBack_RefreshUI_page2_0", on_receive_multy_roomcfg_refresh_UI_page2_0)
		
		--发起登入操作
		--print("发起登入操作")
		--print("发起登入操作", Pvp_Server:GetState())
		if (Pvp_Server:GetState() == 1) then --不重复登入
			--模拟触发连接结果回调
			on_receive_connect_back_event_page2_0(1)
		else
			--连接
			Pvp_Server:Connect()
		end
	end
	
	--函数：收到连接结果回调2-0(铜雀台)
	on_receive_connect_back_event_page2_0 = function(net_state)
		--print("收到连接结果回调", net_state)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--标记连接状态
		current_connect_state = net_state --连接状态
		
		if (net_state == 1) then
			--发送登陆请求
			--print("发送登陆请求", hGlobal.LocalPlayer:getonline())
			if hGlobal.LocalPlayer:getonline() then --不重复登陆
				--模拟触发收到登入结果回调
				on_receive_login_back_event_page2_0(1, hGlobal.LocalPlayer.data.playerId)
			else
				--print("调试-: " .. "Pvp_Server:UserLogin(3)")
				Pvp_Server:UserLogin()
			end
		else
			--失败
			--取消挡操作
			hUI.NetDisable(0)
		end
	end
	
	--函数：收到登入结果回调2-0(铜雀台)
	on_receive_login_back_event_page2_0 = function(iResult, playerId) --0失败 1成功
		--print("收到登入结果回调2-0")
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		--print("login_state", login_state)
		
		--标记登入状态
		current_login_state = iResult --登入状态
		
		if (iResult == 1) then
			--存储本地玩家id
			current_PlayerId = playerId
			
			--发起查询我的基本信息(铜雀台)
			if (g_myPvP_BaseInfo.updated == 0) then --不重复刷
				--print("调试-: " .. "SendPvpCmdFunc[get_user_baseinfo](3)")
				SendPvpCmdFunc["refresh_userinfo_fromdb"]()
				SendPvpCmdFunc["get_user_baseinfo"]()
			end
			
			--发起查询我的pvp配置的卡牌2-0(铜雀台)
			if (not current_ConfigCardList) then
				--local cfgId = 2
				local cfgId = 9999
				local udbid = nil
				local rid = nil
				SendPvpCmdFunc["get_battle_cfg"](cfgId, udbid, rid)
				--print("发起查询pvp配置的卡牌")
			end
			
			--发起查询今日的生效卡牌
			--检测是否到第二天
			local localTime_pvp = os.time() --pvp客户端时间
			local hostTime_pvp = localTime_pvp - g_localDeltaTime_pvp --pvp服务器时间(Local = Host + deltaTime)
			
			--转化为北京时间
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - 8 --与北京时间的时差
			hostTime_pvp = hostTime_pvp - delteZone * 3600 --服务器时间(北京时区)
			local tabNow = os.date("*t", hostTime_pvp)
			local yearNow = tabNow.year
			local monthNow = tabNow.month
			local dayNow = tabNow.day
			--print("dayNow", dayNow)
			local tab1 = os.date("*t", current_TakeEffectCfg and current_TakeEffectCfg.lasttime or 0)
			
			if (tab1.year ~= yearNow) or (tab1.month ~= monthNow) or (tab1.day ~= dayNow) then --到了第二天
				--获取铜雀台配置信息(参数:是否刷新次数)
				local refreshFlag = 0
				SendPvpCmdFunc["get_pve_multi_cfg"](refreshFlag)
				--print("获取铜雀台配置信息2-0")
			else
				--模拟出发回调，获取铜雀台配置信息
				on_receive_multy_roomcfg_refresh_UI_page2_0(current_TakeEffectCfg)
				--print("模拟出发回调，获取铜雀台配置信息2-0")
			end
		else
			--失败
			--...
		end
	end
	
	--函数：收到铜雀台今日生效配置信息2-0(铜雀台)
	on_receive_multy_roomcfg_event_page2_0 = function(roomCfg)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local roomCfgId = roomCfg.roomCfgId --配置id
		local challengeMaxCount = roomCfg.challengeMaxCount --挑战次数
		local challengeMaxCountCfg = roomCfg.challengeMaxCountCfg --最大挑战次数
		local challengeRefreshTime = roomCfg.challengeRefreshTime --刷新时间 "2017-01-01"
		local tacticList = roomCfg.tacticList --生效战术卡
		local rewardShowList = roomCfg.rewardShowList --奖励道具
		
		--当前时间
		local localTime_pvp = os.time() --pvp客户端时间
		local hostTime_pvp = localTime_pvp - g_localDeltaTime_pvp --pvp服务器时间(Local = Host + deltaTime)
		
		--转化为北京时间
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - 8 --与北京时间的时差
		hostTime_pvp = hostTime_pvp - delteZone * 3600 --服务器时间(北京时区)
		
		roomCfg.lasttime = hostTime_pvp
		
		--print("roomCfgId=", roomCfgId)
		--print("challengeMaxCount=", challengeMaxCount)
		--print("challengeMaxCountCfg=", challengeMaxCountCfg)
		--print("challengeRefreshTime=", challengeRefreshTime)
		--print("tacticList=", tacticList)
		--print("rewardShowList=", rewardShowList)
		--print("lasttime=", hostTime_pvp, os.date("%Y-%m-%d %H:%M:%S", hostTime_pvp))
		
		--存储表
		current_TakeEffectCfg = roomCfg
	end
	
	--函数：收到铜雀台今日生效配置信息2-0，刷新界面(铜雀台)
	on_receive_multy_roomcfg_refresh_UI_page2_0 = function(roomCfg)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local roomCfgId = roomCfg.roomCfgId --配置id
		local challengeMaxCount = roomCfg.challengeMaxCount --剩余挑战次数
		local challengeMaxCountCfg = roomCfg.challengeMaxCountCfg --最大挑战次数
		local challengeRefreshTime = roomCfg.challengeRefreshTime --刷新时间 "2017-01-01"
		local tacticList = roomCfg.tacticList --生效战术卡
		local rewardShowList = roomCfg.rewardShowList --奖励道具
		
		--刷新战术卡
		for i = 1, 3, 1 do
			local button = _frmNode.childUI["ThisWeekCardBtn" .. i]
			if button then
				local tacticId = tacticList[i] and tacticList[i] [1]
				local tacticLv = tacticList[i] and tacticList[i][2]
				local tabT = hVar.tab_tactics[tacticId] or {}
				
				--修改战术卡图标
				local model = tabT.icon
				button.childUI["icon"]:setmodel(model, nil, nil, button.childUI["icon"].data.w, button.childUI["icon"].data.h)
				
				--修改战术卡文字
				local text = hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][2] or ("未知战术卡" .. tostring(tacticId))
				button.childUI["intro"]:setText(text)
				
				--修改战术卡颜色
				local negative = tabT.negative --是否负面
				if negative then
					button.childUI["intro"].handle.s:setColor(ccc3(255, 0, 0))
				else
					button.childUI["intro"].handle.s:setColor(ccc3(0, 255, 0))
				end
				
				--隐藏战术卡菊花
				button.childUI["waiting"].handle.s:setVisible(false)
			end
		end
		
		--刷新奖励道具
		for i = 1, 4, 1 do
			local button = _frmNode.childUI["btnRewardItem" .. i]
			if button then
				local reward = rewardShowList[i]
				
				if reward then --有奖励道具i
					local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(reward)
					local scaleI = 1.3
					--删除上一次道具
					hApi.safeRemoveT(button.childUI, "item_icon")
					hApi.safeRemoveT(button.childUI, "item_sub_icon")
					
					--显示道具按钮
					button:setstate(1)
					
					--重绘新的成就奖励图标
					button.childUI["item_icon"] = hUI.image:new({
						parent = button.handle._n,
						model = tmpModel,
						x = 0,
						y = 0,
						w = itemWidth * scaleI,
						h = itemHeight * scaleI,
					})
					
					--绘制奖励图标的子控件
					if sub_tmpModel then
						button.childUI["item_sub_icon"] = hUI.image:new({
							parent = button.handle._n,
							model = sub_tmpModel,
							x = sub_pos_x * scaleI,
							y = sub_pos_y * scaleI,
							w = sub_pos_w * scaleI,
							h = sub_pos_h * scaleI,
						})
					end
					
					--调整奖励位置
					if (i == 3) then
						local button4 = _frmNode.childUI["btnRewardItem" .. "4"]
						if (#rewardShowList == 3) then
							button:setXY(button4.data.x - 40, button4.data.y)
						else
							button:setXY(button4.data.x - 80, button4.data.y)
						end
					end
					
					--隐藏奖励道具菊花
					button.childUI["waiting"].handle.s:setVisible(false)
				else
					--无道具奖励i
					--隐藏道具按钮
					button:setstate(-1)
					
					--隐藏奖励道具菊花
					button.childUI["waiting"].handle.s:setVisible(false)
				end
			end
		end
		
		--刷新剩余挑战次数
		if _frmNode.childUI["battleCountValueLabel"] then
			_frmNode.childUI["battleCountValueLabel"]:setText(challengeMaxCount .. "/" .. challengeMaxCountCfg)
		end
		
		--隐藏挑战次数菊花
		if _frmNode.childUI["battleCountWaiting"] then
			_frmNode.childUI["battleCountWaiting"].handle.s:setVisible(false)
		end
	end
	
	--函数：创建娱乐房界面（第2个分页的子分页1）
	OnCreateBattleRoomSubFrame_page2 = function(pageIndex)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--将本地的卡牌配置上传到服务器(铜雀台)
		UploadClientConfigCard_page2()
		
		--允许本分分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Room_page21", 1)
		--print("允许本分分页的的clipNode", tostring(_frm))
		
		--初始化参数
		current_focus_pvproomEx_idx_page2 = 0 --当前显示的PVP房间ex的索引值
		--last_room_query_time_page2 = 0 --上一次timer取房间列表的时间
		--last_room_gametime_time_page2 = 0 --上一次timer取房间游戏时间的时间
		
		current_connect_state = 0 --连接状态
		current_login_state = 0 --登入状态
		current_PlayerId = 0 --本地玩家id
		--current_gamecoin = 0 --本地的游戏币
		current_Room_page2 = nil --自己所处的房间
		current_RoomId_page2 = 0 --自己所处的房间id
		--current_RoomAbstractList_page2 = {} --大厅房间摘要列表
		--current_Room_max_num_page2 = 0 --最大的PVP房间id
		--current_ConfigCardList = nil --配置的卡牌列表
		
		--local i = 3
		
		--左侧PVP房间列表提示上翻页的图片
		_frmNode.childUI["PvpRoomPageUp"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = PVPROOM.OFFSET_X + 415 + 110,
			y = PVPROOM.OFFSET_Y - 87 - 20,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["PvpRoomPageUp"].handle.s:setRotation(90)
		_frmNode.childUI["PvpRoomPageUp"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_frmNode.childUI["PvpRoomPageUp"].handle.s:setVisible(false) --默认不显示左分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "PvpRoomPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["PvpRoomPageUp"].handle._n:runAction(forever)
		
		--左侧PVP房间列表提示下翻页的图片
		_frmNode.childUI["PvpRoomPageDown"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = PVPROOM.OFFSET_X + 415 + 7 + 110, --非对称的翻页图
			y = PVPROOM.OFFSET_Y - 509 - 110,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["PvpRoomPageDown"].handle.s:setRotation(270)
		_frmNode.childUI["PvpRoomPageDown"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		_frmNode.childUI["PvpRoomPageDown"].handle.s:setVisible(false) --默认不显示左分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "PvpRoomPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["PvpRoomPageDown"].handle._n:runAction(forever)
		
		--左侧向上翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["PvpRoomPageUp_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = PVPROOM.OFFSET_X + 415 + 110,
			y = PVPROOM.OFFSET_Y - 70 - 40,
			w = 200,
			h = 30,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (current_Room_max_num_page2 > (PVPROOM_X_NUM * PVPROOM_Y_NUM)) then
					--print("向下滚屏", screenY)
					--向下滚屏
					b_need_auto_fixing_pvproom_page2 = true
					friction_pvproom_page2 = 0
					draggle_speed_y_pvproom_page2 = -PVPROOM_MAX_SPEED / 2.0 --负速度
				end
			end,
		})
		_frmNode.childUI["PvpRoomPageUp_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "PvpRoomPageUp_Btn"
		
		--左侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["PvpRoomPageDown_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = PVPROOM.OFFSET_X + 415 + 110,
			y = PVPROOM.OFFSET_Y - 612 - 20,
			w = 180,
			h = 80,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (current_Room_max_num_page2 > (PVPROOM_X_NUM * PVPROOM_Y_NUM)) then
					--print("向上滚屏", screenY)
					--向上滚屏
					b_need_auto_fixing_pvproom_page2 = true
					friction_pvproom_page2 = 0
					draggle_speed_y_pvproom_page2 = PVPROOM_MAX_SPEED / 2.0 --正速度
					--print("正速度")
				end
			end,
		})
		_frmNode.childUI["PvpRoomPageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "PvpRoomPageDown_Btn"
		
		--左侧用于检测滑动事件的控件
		_frmNode.childUI["PvpRoomDragPanel"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = PVPROOM.OFFSET_X + 420 + 114,
			y = PVPROOM.OFFSET_Y - 311 - 50,
			w = BOARD_WIDTH - 130,
			h = PVPROOM_BOARD_HEIGHT + 20,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--在房间中不处理
				if (current_RoomId_page2 ~= 0) then
					return
				end
				
				--断开连接，不用处理
				if (current_connect_state ~= 1) or (current_login_state ~= 1) then
					return
				end
				
				--当前没有任何控件，不用处理
				if (not _frmNode.childUI["PvpRoomNode1"]) then
					return
				end
				
				--print("codeOnTouch", touchX, touchY, sus)
				click_pos_x_pvproom_page2 = touchX --开始按下的坐标x
				click_pos_y_pvproom_page2 = touchY --开始按下的坐标y
				last_click_pos_y_pvproom_page2 = touchX --上一次按下的坐标x
				last_click_pos_y_pvproom_page2 = touchY --上一次按下的坐标y
				draggle_speed_y_pvproom_page2 = 0 --当前速度为0
				click_scroll_pvproom_page2 = true --是否滑动PVP房间
				b_need_auto_fixing_pvproom_page2 = false --不需要自动修正位置
				friction_pvproom_page2 = 0 --无阻力
				--print("codeOnTouch")
				
				--如果PVP房间数量未铺满一页，那么不需要滑动
				if (current_Room_max_num_page2 <= (PVPROOM_X_NUM * PVPROOM_Y_NUM)) then
					--print("如果PVP房间数量未铺满一页，那么不需要滑动")
					click_scroll_pvproom_page2 = false --不需要滑动PVP房间
				end
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--在房间中不处理
				if (current_RoomId_page2 ~= 0) then
					return
				end
				
				--断开连接，不用处理
				if (current_connect_state ~= 1) or (current_login_state ~= 1) then
					return
				end
				
				--当前没有任何控件，不用处理
				if (not _frmNode.childUI["PvpRoomNode1"]) then
					return
				end
				
				--print("codeOnDrag", touchX, touchY, sus)
				--处理移动速度y
				draggle_speed_y_pvproom_page2 = touchY - last_click_pos_y_pvproom_page2
				
				if (draggle_speed_y_pvproom_page2 > PVPROOM_MAX_SPEED) then
					draggle_speed_y_pvproom_page2 = PVPROOM_MAX_SPEED
				end
				if (draggle_speed_y_pvproom_page2 < -PVPROOM_MAX_SPEED) then
					draggle_speed_y_pvproom_page2 = -PVPROOM_MAX_SPEED
				end
				
				--print("click_scroll_pvproom_page2=", click_scroll_pvproom_page2)
				--在滑动过程中才会处理滑动
				if click_scroll_pvproom_page2 then
					local deltaY = touchY - last_click_pos_y_pvproom_page2 --与开始按下的位置的偏移值x
					for i = 1, #current_RoomAbstractList_page2, 1 do
						local listI = current_RoomAbstractList_page2[i] --第i项
						if (listI) then --存在PVP房间信息第i项表
							local ctrli = _frmNode.childUI["PvpRoomNode" .. i]
							ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
							ctrli.data.x = ctrli.data.x
							ctrli.data.y = ctrli.data.y + deltaY
						end
					end
				end
				
				--存储本次的位置
				last_click_pos_y_pvproom_page2 = touchX
				last_click_pos_y_pvproom_page2 = touchY
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--在房间中不处理
				if (current_RoomId_page2 ~= 0) then
					return
				end
				
				--断开连接，不用处理
				if (current_connect_state ~= 1) or (current_login_state ~= 1) then
					return
				end
				
				--当前没有任何控件，不用处理
				if (not _frmNode.childUI["PvpRoomNode1"]) then
					return
				end
				
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_pvproom_page2 then
					--if (touchX ~= click_pos_x_pvproom_page2) or (touchY ~= click_pos_y_pvproom_page2) then --不是点击事件
						b_need_auto_fixing_pvproom_page2 = true
						friction_pvproom_page2 = 0
					--end
				end
				
				local selectTipIdx = 0
				for i = 1, #current_RoomAbstractList_page2, 1 do
					local listI = current_RoomAbstractList_page2[i] --第i项
					if (listI) then --存在PVP房间信息第i项表
						local ctrli = _frmNode.childUI["PvpRoomNode" .. i]
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						local cw, ch = ctrli.data.w, ctrli.data.h
						local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
						local rx, ry = lx + cw, ly + ch --最右下角坐标
						--print(i, lx, rx, ly, ry, touchX, touchY)
						if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
							selectTipIdx = i
							
							break
							--print("点击到了哪个PVP房间tip的框内" .. i)
						end
					end
				end
				
				if (click_scroll_pvproom_page2) and (math.abs(touchY - click_pos_y_pvproom_page2) > 32) then
					selectTipIdx = 0
				end
				
				if (selectTipIdx > 0) then
					--点击加入某个房间按钮
					OnEnterRoomButton_page2(selectTipIdx)
				end
				
				--标记不用滑动
				click_scroll_pvproom_page2 = false
			end,
		})
		_frmNode.childUI["PvpRoomDragPanel"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "PvpRoomDragPanel"
		
		--转圈圈的图: 右上角小菊花
		_frmNode.childUI["waitingSmall"] = hUI.image:new({
			parent = _parentNode,
			model = "MODEL_EFFECT:waiting",
			x = PVPROOM.OFFSET_X + 90 + 842,
			y = PVPROOM.OFFSET_Y - 102,
			w = 36,
			h = 36,
		})
		_frmNode.childUI["waitingSmall"].handle.s:setVisible(false) --一开始不显示小菊花
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "waitingSmall"
		
		--"创建房间"的按钮
		_frmNode.childUI["CreateRoomButton"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
			model = "BTN:PANEL_CLOSE",
			x = _frm.data.w - 100,
			y = -_frm.data.h + 45,
			scale = 1.1,
			--label = "创建房间",
			--font = hVar.FONTC,
			--border = 1,
			model = "UI:BTN_ButtonRed",
			animation = "normal",
			scaleT = 0.95,
			code = function()
				--点击创建房间按钮后，隐藏自身
				--_frmNode.childUI["CreateRoomButton"]:setstate(-1)
				--_frmNode.childUI["ModifyConfigButton"]:setstate(-1)
				
				--创建房间
				OnCreateRoomButton_page2()
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "CreateRoomButton"
		_frmNode.childUI["CreateRoomButton"]:setstate(-1) --默认隐藏
		
		--"创建房间"的文字
		_frmNode.childUI["CreateRoomButton"].childUI["label"] = hUI.label:new({
			parent = _frmNode.childUI["CreateRoomButton"].handle._n,
			x = 0,
			y = -2, --文字有2像素的偏差
			size = 28,
			--text = "创建房间", --language
			text = hVar.tab_string["__TEXT_PVP_Create"] .. hVar.tab_string["__TEXT_PVP_Room"], --language
			align = "MC",
			font = hVar.FONTC,
			border = 1,
		})
		
		--管理员全天开放
		--if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
		if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
			--"创建房间"的按钮（管理员）
			_frmNode.childUI["CreateRoomButton_Admin"] = hUI.button:new({
				parent = _parentNode,
				dragbox = _frm.childUI["dragBox"],
				--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
				model = "BTN:PANEL_CLOSE",
				x = _frm.data.w - 100,
				y = -_frm.data.h + 45,
				scale = 1.1,
				--label = "创建房间",
				--font = hVar.FONTC,
				--border = 1,
				model = "UI:BTN_ButtonRed",
				animation = "normal",
				scaleT = 0.95,
				code = function()
					--点击创建房间按钮后，隐藏自身
					--_frmNode.childUI["CreateRoomButton_Admin"]:setstate(-1)
					--_frmNode.childUI["ModifyConfigButton"]:setstate(-1)
					
					--创建房间（管理员）
					OnCreateRoomButton_page2()
				end,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "CreateRoomButton_Admin"
			_frmNode.childUI["CreateRoomButton_Admin"]:setstate(-1) --默认隐藏
			
			--"创建房间"的文字（管理员）
			_frmNode.childUI["CreateRoomButton_Admin"].childUI["label"] = hUI.label:new({
				parent = _frmNode.childUI["CreateRoomButton_Admin"].handle._n,
				x = 0,
				y = -2, --文字有2像素的偏差
				size = 28,
				--text = "创建房间", --language
				text = hVar.tab_string["__TEXT_PVP_Create"] .. hVar.tab_string["__TEXT_PVP_Room"], --language
				align = "MC",
				font = hVar.FONTC,
				border = 1,
			})
			
			if (g_is_account_test == 1) then --测试员
				--1颗星
				_frmNode.childUI["CreateRoomButton_Admin"].childUI["star1"] = hUI.image:new({
					parent = _frmNode.childUI["btnDebug"].handle._n,
					x = 0,
					y = 42,
					model = "misc/weekstar.png",
					dragbox = _frm.childUI["dragBox"],
					w = 32,
					h = 32,
				})
			else
				--2颗星
				_frmNode.childUI["CreateRoomButton_Admin"].childUI["star1"] = hUI.image:new({
					parent = _frmNode.childUI["CreateRoomButton_Admin"].handle._n,
					x = -14,
					y = 42,
					model = "misc/weekstar.png",
					dragbox = _frm.childUI["dragBox"],
					w = 32,
					h = 32,
				})
				_frmNode.childUI["CreateRoomButton_Admin"].childUI["star2"] = hUI.image:new({
					parent = _frmNode.childUI["CreateRoomButton_Admin"].handle._n,
					x = 14,
					y = 42,
					model = "misc/weekstar.png",
					dragbox = _frm.childUI["dragBox"],
					w = 32,
					h = 32,
				})
			end
		end
		
		--[[
		--阵容配置的按钮
		_frmNode.childUI["ModifyConfigButton"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
			model = "BTN:PANEL_CLOSE",
			x = _frm.data.w - 270,
			y = -_frm.data.h + 45,
			scale = 1.1,
			--label = "阵容配置",
			--font = hVar.FONTC,
			--border = 1,
			model = "UI:BTN_ButtonRed",
			animation = "normal",
			scaleT = 0.95,
			code = function()
				--Pvp_Server:Close()
				OnModifyConfigButton_page2()
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ModifyConfigButton"
		_frmNode.childUI["ModifyConfigButton"]:setstate(-1) --默认隐藏
		
		--"阵容配置"的文字
		_frmNode.childUI["ModifyConfigButton"].childUI["label"] = hUI.label:new({
			parent = _frmNode.childUI["ModifyConfigButton"].handle._n,
			x = 0,
			y = -2, --文字有2像素的偏差
			size = 28,
			--text = "阵容配置", --language
			text = hVar.tab_string["__TEXT_PVP_BattleConfig"], --language
			align = "MC",
			font = hVar.FONTC,
			border = 1,
		})
		]]
		
		--"重新连接"的按钮
		_frmNode.childUI["ConnectRoomButton"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
			model = "BTN:PANEL_CLOSE",
			x = PVPROOM.OFFSET_X + 310 + 208,
			y = PVPROOM.OFFSET_Y - 430,
			scale = 1.1,
			--label = "重新连接",
			--font = hVar.FONTC,
			--border = 1,
			model = "UI:BTN_ButtonRed",
			animation = "normal",
			scaleT = 0.95,
			code = function()
				--重新连接
				OnConnectRoomButton_page2()
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConnectRoomButton"
		_frmNode.childUI["ConnectRoomButton"]:setstate(-1) --默认隐藏
		
		--"重新连接"的文字
		_frmNode.childUI["ConnectRoomButton"].childUI["label"] = hUI.label:new({
			parent = _frmNode.childUI["ConnectRoomButton"].handle._n,
			x = 0,
			y = -2,
			size = 28,
			--text = "重新连接", --language
			text = hVar.tab_string["RSDYZ_RECONNECT"], --language
			align = "MC",
			font = hVar.FONTC,
			border = 1,
		})
		
		--分页2-1
		--添加事件监听：收到pvp的ping值回调
		hGlobal.event:listen("LocalEvent_Pvp_Ping", "__PvpPing_page2", on_receive_ping_event_page2)
		--添加事件监听：收到连接结果回调
		hGlobal.event:listen("LocalEvent_Pvp_NetEvent", "__ConnectBack_page2", on_receive_connect_back_event_page2)
		--添加事件监听：收到登入结果回调
		hGlobal.event:listen("LocalEvent_Pvp_PlayerLoginEvent", "__LoginBack_page2", on_receive_login_back_event_page2)
		--添加事件监听：收到房间id列表回调
		hGlobal.event:listen("LocalEvent_Pvp_RoomList", "__RoomListBack_page2", on_receive_RoomIdList_event_page2)
		--添加事件监听：收到房间摘要回调
		hGlobal.event:listen("LocalEvent_Pvp_RoomsAbstract", "__RoomAbstarctBack_page2", on_receive_RoomAbstract_event_page2)
		--添加事件监听：收到单个房间摘要发生变化回调
		hGlobal.event:listen("LocalEvent_Pvp_SingleRoomsAbstractChanged", "__RoomSingleAbstarctChangedBack_page2", on_receive_SingleRoomAbstractChanged_event_page2)
		--添加事件监听：房间状态回调
		hGlobal.event:listen("LocalEvent_Pvp_RoomEvent", "__RoomEventBack_page2", on_receive_RoomEvent_event_page2)
		--添加事件监听：自己所处的房间信息变化回调
		hGlobal.event:listen("LocalEvent_Pvp_RoomInfo", "__RoomInfoBack_page2", on_receive_RoomInfo_event_page2)
		--添加事件监听：离开房间回调
		hGlobal.event:listen("LocalEvent_Pvp_RoomLeave", "__LeaveRoomBack_page2", on_receive_LeaveRoom_event_page2)
		--添加事件监听：进入房间失败事件
		hGlobal.event:listen("LocalEvent_Pvp_RoomEnter_Fail", "__EnterRoomFail_page2", on_receive_EnterRoom_Fail_event_page2)
		--添加事件监听：pvp错误信息提示
		hGlobal.event:listen("LocalEvent_Pvp_NetLogicError", "__NetLogicError_page2", on_receive_Pvp_NetLogicError_event)
		--添加事件监听：切换场景事件
		hGlobal.event:listen("LocalEvent_Pvp_SwitchGame", "__SwitchGameBack_page2", on_receive_Pvp_SwitchGame_event)
		--添加事件监听：配置卡组回调事件
		hGlobal.event:listen("LocalEvent_Pvp_battleCfg", "__BattleCfgBack_page2", on_receive_Pvp_BattleCfg_event_page2)
		--添加事件监听：我的基础信息返回事件
		hGlobal.event:listen("LocalEvent_Pvp_UserBaseInfo", "__BattleBaseInfo_page2", on_receive_Pvp_baseInfoRet_page2)
		--添加事件监听：配置卡组界面操作完成事件
		hGlobal.event:listen("LocalEvent_UI_battleCfg_Complete", "__BattleCfgBack_page2", on_receive_UI_BattleCfg_Complete_page2)
		--添加事件监听：收到铜雀台今日生效配置信息
		hGlobal.event:listen("LocalEvent_PvpMulty_RoomTakeEffectCfg", "__PvpMultyCfgBack_page2_0", on_receive_multy_roomcfg_event_page2_0)
		
		--创建timer，刷新房间滚动
		hApi.addTimerForever("__PVP_ROOM_SCROLL_PAGE21__", hVar.TIMER_MODE.GAMETIME, 30, refresh_pvproom_UI_loop_page2)
		--创建timer，定时刷新房间列表
		hApi.addTimerForever("__PVP_ROOM_QUERY_PAGE21__", hVar.TIMER_MODE.GAMETIME, QUERY_ROOM_DELTA_SECOND_PAGE2 * 1000, refresh_room_list_loop_page2)
		--创建timer，定时刷新房间内的所有在游戏中的时间
		hApi.addTimerForever("__PVP_ROOM_GAMETIME_PAGE21__", hVar.TIMER_MODE.GAMETIME, QUERY_ROOM_GAMETIME_DELTA_SECOND_PAGE2 * 1000, refresh_room_gametime_loop_page21)
		--定时刷新铜雀台的开放时间
		hApi.addTimerForever("__PVP_ROOM_MATCH_PAGE25__", hVar.TIMER_MODE.GAMETIME, 1000 * 1, refresh_pve_multy_room_timer)
		
		--提示正在登入的文字
		_frmNode.childUI["StateLabel"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 310 + 208,
			y = PVPROOM.OFFSET_Y - 350,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 500,
			border = 1,
			--text = "正在连接中...", --language
			text = hVar.tab_string["__TEXT_NetConnecting"], --language
		})
		_frmNode.childUI["StateLabel"].handle.s:setColor(ccc3(168, 168, 168))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "StateLabel"
		
		--提示大菊花
		_frmNode.childUI["WaitingImg"] = hUI.image:new({
			parent = _parentNode,
			model = "MODEL_EFFECT:waiting",
			x = PVPROOM.OFFSET_X + 310 + 208,
			y = PVPROOM.OFFSET_Y - 280,
			scale = 1.0,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "WaitingImg"
		
		--发起登入操作
		--print("发起登入操作")
		--print("发起登入操作", Pvp_Server:GetState())
		if (Pvp_Server:GetState() == 1) then --不重复登入
			--模拟触发连接结果回调
			on_receive_connect_back_event_page2(1)
		else
			--连接
			Pvp_Server:Connect()
		end
		
		--test
		--[[
		--模拟触发回调: 收到连接结果回调
		if (IAPServerIP == g_lrc_Ip) then --内网
			hGlobal.event:event("LocalEvent_Pvp_NetEvent", 1)
		end
		]]
	end
	
	--函数：收到pvp的ping值回调(铜雀台)
	on_receive_ping_event_page2 = function(ping, online_num)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--存储pvp我的ping值
		current_ping_value = ping
		
		--存储pvp在线人数
		current_online_num = online_num
		
		if _frmNode.childUI["RoomPingLabel"] then
			_frmNode.childUI["RoomPingLabel"]:setText(ping)
		end
		if _frmNode.childUI["RoomOnlineLabel"] then
			_frmNode.childUI["RoomOnlineLabel"]:setText(online_num)
		end
	end
	
	--函数：收到配置卡组返回事件2-0(铜雀台)
	on_receive_Pvp_BattleCfg_event_page2_0 = function(tCfg, udbid)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--存储配置的卡牌列表
		if (udbid == xlPlayer_GetUID()) then --我
			current_ConfigCardList = tCfg or {}
		end
		--print("存储配置的卡牌列表", current_ConfigCardList)
		
		--存储所有玩家的卡牌配置表
		current_AllPlayerCfgList[udbid] = tCfg or {}
	end
	
	--函数：收到连接结果回调(铜雀台)
	on_receive_connect_back_event_page2 = function(net_state)
		--print("收到连接结果回调", net_state)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--标记连接状态
		current_connect_state = net_state --连接状态
		
		if (net_state == 1) then
			--修改文字：连接成功
			_frmNode.childUI["waitingSmall"].handle.s:setVisible(true)
			if _frmNode.childUI["WaitingImg"] then
				_frmNode.childUI["WaitingImg"].handle.s:setVisible(true)
			end
			if _frmNode.childUI["StateLabel"] then
				--_frmNode.childUI["StateLabel"]:setText("正在登入中...") --language
				_frmNode.childUI["StateLabel"]:setText(hVar.tab_string["__TEXT_NetLogining"]) --language
			end
			
			--隐藏登入按钮
			_frmNode.childUI["ConnectRoomButton"]:setstate(-1)
			
			--发送登陆请求
			--print("发送登陆请求", hGlobal.LocalPlayer:getonline())
			if hGlobal.LocalPlayer:getonline() then --不重复登陆
				--模拟触发收到登入结果回调
				on_receive_login_back_event_page2(1, hGlobal.LocalPlayer.data.playerId)
			else
				--print("调试-: " .. "Pvp_Server:UserLogin(4)")
				Pvp_Server:UserLogin()
			end
		else
			--初始化参数
			current_focus_pvproomEx_idx_page2 = 0 --当前显示的PVP房间ex的索引值
			
			current_connect_state = 0 --连接状态
			current_login_state = 0 --登入状态
			current_PlayerId = 0 --本地玩家id
			--current_gamecoin = 0 --本地的游戏币
			current_Room_page2 = nil --自己所处的房间
			current_RoomId_page2 = 0 --自己所处的房间id
			--current_RoomAbstractList_page2 = {} --大厅房间摘要列表
			--current_Room_max_num_page2 = 0 --最大的PVP房间id
			--current_ConfigCardList = nil --配置的卡牌列表
			
			--取消挡操作
			hUI.NetDisable(0)
			
			--清空右侧的控件
			_removeRightFrmFunc()
			
			--隐藏可能的翻页按钮
			_frmNode.childUI["PvpRoomPageUp"].handle.s:setVisible(false)
			_frmNode.childUI["PvpRoomPageDown"].handle.s:setVisible(false)
			
			--隐藏创建房间和修改配置按钮
			_frmNode.childUI["CreateRoomButton"]:setstate(-1)
			if _frmNode.childUI["CreateRoomButton_Admin"] then
				_frmNode.childUI["CreateRoomButton_Admin"]:setstate(-1)
			end
			--_frmNode.childUI["ModifyConfigButton"]:setstate(-1)
			
			--修改文字：连接失败
			_frmNode.childUI["waitingSmall"].handle.s:setVisible(false)
			--_frmNode.childUI["WaitingImg"].handle.s:setVisible(false)
			--_frmNode.childUI["StateLabel"]:setText("连接失败！错误码: " .. net_state)
			
			--提示正在登入的文字
			_frmNode.childUI["StateFailLabel"] = hUI.label:new({
				parent = _parentNode,
				x = PVPROOM.OFFSET_X + 310 + 208,
				y = PVPROOM.OFFSET_Y - 350,
				size = 26,
				font = hVar.FONTC,
				align = "MC",
				width = 500,
				border = 1,
				--text = "连接失败！错误码: " .. tostring(net_state), --language
				text = hVar.tab_string["__TEXT_ConnectFail_ErrorCode"] .. tostring(net_state), --language
			})
			_frmNode.childUI["StateFailLabel"].handle.s:setColor(ccc3(168, 168, 168))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "StateFailLabel"
			
			--显示登入按钮
			_frmNode.childUI["ConnectRoomButton"]:setstate(1)
		end
	end
	
	--函数：收到登入结果回调2-1(铜雀台)
	on_receive_login_back_event_page2 = function(iResult, playerId) --0失败 1成功
		--print("收到登入结果回调2")
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		--print("login_state", login_state)
		
		--标记登入状态
		current_login_state = iResult --登入状态
		
		if (iResult == 1) then
			--存储本地玩家id
			current_PlayerId = playerId
			
			--修改文字：获取房间信息
			_frmNode.childUI["waitingSmall"].handle.s:setVisible(true)
			if _frmNode.childUI["WaitingImg"] then
				_frmNode.childUI["WaitingImg"].handle.s:setVisible(true)
			end
			if _frmNode.childUI["StateLabel"] then
				--_frmNode.childUI["StateLabel"]:setText("正在获取房间列表...") --language
				_frmNode.childUI["StateLabel"]:setText(hVar.tab_string["__TEXT_GettingRoomLists"]) --language
			end
			
			--是否到了间隔时间
			local currenttime = hApi.gametime() --当前时间
			local deltatime = currenttime - last_room_query_time_page2 --时间差
			if (deltatime >= (QUERY_ROOM_DELTA_SECOND_PAGE2 * 1000 - 100)) then
				--标记timer
				last_room_query_time_page2 = currenttime
				
				--发起查询前清空数据
				--current_RoomAbstractList_page2 = {} --大厅房间摘要列表
				--current_Room_max_num_page2 = 0 --最大的PVP房间id
				
				--发起查询我的基本信息(铜雀台)
				if (g_myPvP_BaseInfo.updated == 0) then --不重复刷
					--print("调试-: " .. "SendPvpCmdFunc[get_user_baseinfo](4)")
					SendPvpCmdFunc["refresh_userinfo_fromdb"]()
					SendPvpCmdFunc["get_user_baseinfo"]()
				end
				
				--发起查询房间id列表(铜雀台)
				--local cfgId = 2
				local cfgId = 9999
				SendPvpCmdFunc["get_roomlist"](cfgId)
				--print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx发起查询房间id列表 -begin")
			else
				--用上次的数据，直接触发回调
				on_receive_RoomAbstract_event_page2(current_RoomAbstractList_page2)
			end
			
			--发起查询我的pvp配置的卡牌2-1
			if (not current_ConfigCardList) then
				--local cfgId = 2
				local cfgId = 9999
				local udbid = nil
				local rid = nil
				SendPvpCmdFunc["get_battle_cfg"](cfgId, udbid, rid)
				--print("发起查询pvp配置的卡牌")
			end
			
			--发起查询今日的生效卡牌
			--检测是否到第二天
			local localTime_pvp = os.time() --pvp客户端时间
			local hostTime_pvp = localTime_pvp - g_localDeltaTime_pvp --pvp服务器时间(Local = Host + deltaTime)
			
			--转化为北京时间
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - 8 --与北京时间的时差
			hostTime_pvp = hostTime_pvp - delteZone * 3600 --服务器时间(北京时区)
			local tabNow = os.date("*t", hostTime_pvp)
			local yearNow = tabNow.year
			local monthNow = tabNow.month
			local dayNow = tabNow.day
			--print("dayNow", dayNow)
			local tab1 = os.date("*t", current_TakeEffectCfg and current_TakeEffectCfg.lasttime or 0)
			
			if (tab1.year ~= yearNow) or (tab1.month ~= monthNow) or (tab1.day ~= dayNow) then --到了第二天
				--获取铜雀台配置信息(参数:是否刷新次数)
				local refreshFlag = 0
				SendPvpCmdFunc["get_pve_multi_cfg"](refreshFlag)
				--print("获取铜雀台配置信息2-1")
			else
				--模拟出发回调，获取铜雀台配置信息
				on_receive_multy_roomcfg_refresh_UI_page2_0(current_TakeEffectCfg)
				--print("模拟出发回调，获取铜雀台配置信息2-1")
			end
		else
			--修改文字：获取房间信息
			_frmNode.childUI["waitingSmall"].handle.s:setVisible(false)
			if _frmNode.childUI["WaitingImg"] then
				_frmNode.childUI["WaitingImg"].handle.s:setVisible(false)
			end
			if _frmNode.childUI["StateLabel"] then
				--_frmNode.childUI["StateLabel"]:setText("登入失败！错误码: " .. tostring(iResult)) --language
				_frmNode.childUI["StateLabel"]:setText(hVar.tab_string["__TEXT_LoginFail_ErrorCode"] .. tostring(iResult)) --language
			end
		end
	end
	
	--函数：收到房间id列表回调(铜雀台)
	--roomStateList: --1:初始化 / 2:启动游戏中/ 3:正在游戏
	on_receive_RoomIdList_event_page2 = function(roomIdList, roomStateList)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--修改文字：获取房间信息
		_frmNode.childUI["waitingSmall"].handle.s:setVisible(true)
		if _frmNode.childUI["WaitingImg"] then
			_frmNode.childUI["WaitingImg"].handle.s:setVisible(true)
		end
		if _frmNode.childUI["StateLabel"] then
			--_frmNode.childUI["StateLabel"]:setText("正在获取房间信息...") --language
			_frmNode.childUI["StateLabel"]:setText(hVar.tab_string["__TEXT_GettingRoomDetails"]) --language
		end
		
		--要发起查询的有效房间id集
		local query_roomIdList = nil
		if (#roomIdList <= ROOM_NUM_MAX_NUM_PAGE2) then --未超房间查询数量上限
			query_roomIdList = roomIdList
		else --达到上限
			--进行排序，优先查询未开始的房间
			local sortT = {}
			for i = 1, #roomIdList, 1 do
				table.insert(sortT, {id = roomIdList[i], state = (roomStateList[i] or 4), index = i})
			end
			
			--排序
			table.sort(sortT, function(sa, sb)
				local va = sa.state * 100000000 + sa.index
				local vb = sb.state * 100000000 + sb.index
				
				return (va < vb)
			end)
			
			--取前n个
			query_roomIdList = {}
			for i = 1, ROOM_NUM_MAX_NUM_PAGE2, 1 do
				table.insert(query_roomIdList, sortT[i].id)
			end
		end
		
		if (#query_roomIdList > 0) then
			--发起查询房间id列表
			SendPvpCmdFunc["get_rooms_abstract"](query_roomIdList)
		else
			--没有房间，直接触发回调
			on_receive_RoomAbstract_event_page2(query_roomIdList)
		end
	end
	
	--函数：创建单个房间的摘要信息界面(铜雀台)
	OnCreateSingleRoomAbstractFrame_page2 = function(listI, i)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		if (listI) then --存在PVP房间信息第i项表
			local id = listI.id --房间id
			local roomName = listI.name --房间名称
			local cfgId = listI.cfgId --房间地图配置索引
			local rm = listI.rm --房主uid
			local mapName = listI.mapName --房间地图名
			local mapInfo = listI.mapInfo --房主地图信息
			local state = listI.state --房主状态(1:未开始 / 2:加载中 / 3:正在游戏)
			local allPlayerNum = listI.allPlayerNum --玩家总数
			local enterPlayerNum = listI.enterPlayerNum --已进入玩家数
			local sessionState = listI.sessionState --游戏局状态	-1未初始化 1初始化 2在游戏 3游戏开始 4游戏结束
			local sessionBeginTimestamp = listI.sessionBeginTimestamp --游戏开始时间戳
			local enterPlayerName = listI.enterPlayerName --玩家姓名(用:分割)
			local bUseEquip = listI.bUseEquip --是否允许装备
			
			--print("allPlayerNum=" .. allPlayerNum)
			--print("enterPlayerNum=" .. enterPlayerNum)
			--print("sessionBeginTimestamp=" .. sessionBeginTimestamp)
			--print("enterPlayerName=" .. enterPlayerName)
			
			local xn = (i % PVPROOM_X_NUM) --xn
			if (xn == 0) then
				xn = PVPROOM_X_NUM
			end
			local yn = (i - xn) / PVPROOM_X_NUM + 1 --yn
			
			--房间的底板
			if _frmNode.childUI["PvpRoomNode" .. i] then
				hApi.safeRemoveT(_frmNode.childUI, "bg2")
				hApi.safeRemoveT(_frmNode.childUI, "title")
				hApi.safeRemoveT(_frmNode.childUI, "roleBG_1")
				hApi.safeRemoveT(_frmNode.childUI, "roleBG_2")
				hApi.safeRemoveT(_frmNode.childUI, "roleBG_3")
				hApi.safeRemoveT(_frmNode.childUI, "role_1")
				hApi.safeRemoveT(_frmNode.childUI, "role_2")
				hApi.safeRemoveT(_frmNode.childUI, "role_3")
				hApi.safeRemoveT(_frmNode.childUI, "roleName_1")
				hApi.safeRemoveT(_frmNode.childUI, "roleName_2")
				hApi.safeRemoveT(_frmNode.childUI, "roleName_3")
				--hApi.safeRemoveT(_frmNode.childUI, "equipment1")
				--hApi.safeRemoveT(_frmNode.childUI, "equipment2")
				hApi.safeRemoveT(_frmNode.childUI, "roomFullLabel")
				hApi.safeRemoveT(_frmNode.childUI, "roomGameTimeLabel")
				hApi.safeRemoveT(_frmNode.childUI, "selectbox")
			else
				_frmNode.childUI["PvpRoomNode" .. i] = hUI.button:new({
					parent = _BTC_pClipNode_Room_page21,
					model = "misc/mask.png",
					x = PVPROOM.OFFSET_X + 325 + (xn - 1) * (PVPROOM.WIDTH + 6),
					y = PVPROOM.OFFSET_Y - 221 - (yn - 1) * (PVPROOM.HEIGHT + 6),
					w = PVPROOM.WIDTH,
					h = PVPROOM.HEIGHT,
				})
				_frmNode.childUI["PvpRoomNode" .. i].handle.s:setOpacity(0) --只作为控制用，不显示
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "PvpRoomNode" .. i
			end
			
			--[[
			--房间的底板图（9宫格）
			local img9 = CCScale9Sprite:createWithSpriteFrameName("data/image/misc/pvp/pvproom1.png")
			img9:setPosition(ccp(0, 0))
			img9:setContentSize(CCSizeMake(PVPROOM.WIDTH, PVPROOM.HEIGHT))
			_frmNode.childUI["PvpRoomNode" .. i].handle._n:addChild(img9)
			]]
			
			--房间的底板图2
			local bgModel = nil
			if (enterPlayerNum >= allPlayerNum) or (state > 1) then --人数已满或已开始游戏，灰掉
				bgModel = "UI:pvproom2"
			else
				bgModel = "UI:pvproom1"
			end
			_frmNode.childUI["PvpRoomNode" .. i].childUI["bg2"] = hUI.image:new({
				parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
				model = bgModel,
				x = 0,
				y = 0,
				w = PVPROOM.WIDTH - 6,
				h = PVPROOM.HEIGHT - 6,
			})
			if (enterPlayerNum >= allPlayerNum) or (state > 1) then --人数已满或已开始游戏，灰掉
				_frmNode.childUI["PvpRoomNode" .. i].childUI["bg2"].handle.s:setColor(ccc3(192, 192, 192))
			else
				--_frmNode.childUI["PvpRoomNode" .. i].childUI["bg2"].handle.s:setColor(ccc3(255, 255, 128))
			end
			
			--解析房间的双方玩家名
			local playerNameList = {"", ""} --玩家名
			--local playsrColorList = {{232, 255, 232}, {248, 255, 212},}
			--print("enterPlayerName=" .. tostring(enterPlayerName))
			if enterPlayerName and (enterPlayerName ~= "") then
				local tmp = enterPlayerName
				local maohao_pos = string.find(tmp, ":") --冒号的位置
				if maohao_pos then
					tmp = string.sub(tmp, 1, maohao_pos - 1) --蜀国的玩家名字列表
					if (string.sub(tmp, #tmp, #tmp) == "|") then --去掉末尾的竖线
						tmp = string.sub(tmp, 1, #tmp - 1)
						--print(tmp)
					end
					local shuxian_pos = string.find(tmp, "|") --竖线的位置
					if shuxian_pos then
						playerNameList[1] = string.sub(tmp, 1, shuxian_pos - 1)
						playerNameList[2] = string.sub(tmp, shuxian_pos + 1, #tmp)
					end
				end
			end
			
			--房间人数图标、名字
			--enterPlayerNum = 1
			local imgList = {"icon/portrait/hero_liubei_s.png", "icon/portrait/hero_caocao_s.png", "icon/portrait/hero_zhangjiao_s.png"}
			for p = 1, allPlayerNum, 1 do
				--存在玩家
				if (playerNameList[p] ~= "") then
					--英雄头像边框
					_frmNode.childUI["PvpRoomNode" .. i].childUI["roleBG_" .. p] = hUI.image:new({
						parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
						model = "UI:NewKuang",
						x = -135 + (p - 1) * (80 + 16),
						y = 8,
						w = 56,
						h = 56,
					})
					if (enterPlayerNum >= allPlayerNum) or (state > 1) then --人数已满或已开始游戏，灰掉
						_frmNode.childUI["PvpRoomNode" .. i].childUI["roleBG_" .. p].handle.s:setColor(ccc3(168, 168, 168))
					else
						--_frmNode.childUI["PvpRoomNode" .. i].childUI["roleBG_" .. p].handle.s:setColor(ccc3(255, 255, 128))
					end
					
					--英雄头像
					local imgModel = imgList[p]
					_frmNode.childUI["PvpRoomNode" .. i].childUI["role_" .. p] = hUI.image:new({
						parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
						model = imgModel,
						x = -135 + (p - 1) * (80 + 16),
						y = 8,
						w = 56 - 8,
						h = 56 - 8,
					})
					if (enterPlayerNum >= allPlayerNum) or (state > 1) then --人数已满或已开始游戏，灰掉
						_frmNode.childUI["PvpRoomNode" .. i].childUI["role_" .. p].handle.s:setColor(ccc3(168, 168, 168))
					else
						--_frmNode.childUI["PvpRoomNode" .. i].childUI["role_" .. p].handle.s:setColor(ccc3(255, 255, 128))
					end
					
					--玩家名
					local playernameFontSize = 18
					--if (#playerNameList[p] > 18) then
					--	playernameFontSize = 15
					--end
					_frmNode.childUI["PvpRoomNode" .. i].childUI["roleName_" .. p] = hUI.label:new({
						parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
						size = playernameFontSize,
						x = -135 + (p - 1) * (80 + 16),
						y = -36,
						width = 300,
						align = "MC",
						font = hVar.FONTC,
						text = playerNameList[p],
						border = 1,
						--RGB = playsrColorList[p],
					})
					if (enterPlayerNum >= allPlayerNum) or (state > 1) then --人数已满或已开始游戏，灰掉
						_frmNode.childUI["PvpRoomNode" .. i].childUI["roleName_" .. p].handle.s:setColor(ccc3(192, 192, 192))
					else
						--_frmNode.childUI["PvpRoomNode" .. i].childUI["roleName_" .. p].handle.s:setColor(ccc3(255, 255, 255))
					end
				else
					--没有玩家
					--空头像边框
					_frmNode.childUI["PvpRoomNode" .. i].childUI["roleBG_" .. p] = hUI.image:new({
						parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
						model = "ui/kuang.png",
						x = -135 + (p - 1) * (80 + 16),
						y = 8,
						w = 56,
						h = 56,
					})
				end
			end
			
			--[[
			--vs的文字
			_frmNode.childUI["PvpRoomNode" .. i].childUI["vs"] = hUI.label:new({
				parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
				size = 38,
				x = -1,
				y = -12 + ctrlExtraOffsetY,
				width = 300,
				align = "MC",
				font = hVar.FONTC,
				text = "vs",
				border = 1,
			})
			if (enterPlayerNum >= allPlayerNum) or (state > 1) then --人数已满或已开始游戏，灰掉
				_frmNode.childUI["PvpRoomNode" .. i].childUI["vs"].handle.s:setColor(ccc3(32, 192, 96))
			else
				_frmNode.childUI["PvpRoomNode" .. i].childUI["vs"].handle.s:setColor(ccc3(64, 255, 128))
			end
			]]
			
			--[[
			--携带装备的图标
			if (bUseEquip) then
				--装备图标1
				_frmNode.childUI["PvpRoomNode" .. i].childUI["equipment1"] = hUI.image:new({
					parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
					model = "UI:UI_EQUIP",
					x = 0,
					y = 2,
					w = 59,
					h = 50,
				})
				
				--装备图标2
				_frmNode.childUI["PvpRoomNode" .. i].childUI["equipment2"] = hUI.image:new({
					parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
					model = "UI:FONT_ZHAN2",
					x = 0,
					y = 2,
					w = 42,
					h = 42,
				})
			end
			]]
			
			--[[
			--如果不允许携带装备，装备图标灰掉
			if (not bUseEquip) then
				hApi.AddShader(_frmNode.childUI["PvpRoomNode" .. i].childUI["equipment"].handle.s, "gray") --灰色图片
				
				--禁用图标
				_frmNode.childUI["PvpRoomNode" .. i].childUI["equipmentBan"] = hUI.image:new({
					parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
					model = "UI:ban",
					x = 114 + 4,
					y = -54 - 4,
					w = 24,
					h = 24,
				})
				_frmNode.childUI["PvpRoomNode" .. i].childUI["equipmentBan"].handle.s:setOpacity(212)
			end
			]]
			
			--房间人数已满或者游戏中的文字
			if (enterPlayerNum >= allPlayerNum) or (state > 1) then --人数已满或已开始游戏
				--人数已满的文本
				_frmNode.childUI["PvpRoomNode" .. i].childUI["roomFullLabel"] = hUI.label:new({
					parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
					size = 22,
					x = 0,
					y = -63,
					width = 300,
					align = "MC",
					font = hVar.FONTC,
					--text = "人数已满", --language
					text = hVar.tab_string["__TEXT_PVP_Full"], --language
					border = 1,
				})
				_frmNode.childUI["PvpRoomNode" .. i].childUI["roomFullLabel"].handle.s:setColor(ccc3(255, 64, 0))
				
				--游戏时间的文本
				_frmNode.childUI["PvpRoomNode" .. i].childUI["roomGameTimeLabel"] = hUI.label:new({
					parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
					size = 18,
					x = 0,
					y = -63,
					width = 300,
					align = "MC",
					font = "numWhite",
					text = "",
					--border = 1,
				})
				_frmNode.childUI["PvpRoomNode" .. i].childUI["roomGameTimeLabel"].handle.s:setColor(ccc3(255, 64, 0))
				if (state > 1) then
					local localTime_pvp = os.time() --pvp客户端时间
					local hostTime_pvp = localTime_pvp - g_localDeltaTime_pvp --pvp服务器时间(Local = Host + deltaTime)
					local deltaSeconds = hostTime_pvp - sessionBeginTimestamp --秒
					local deltaMinutes = math.floor(deltaSeconds / 60) --分
					deltaSeconds = deltaSeconds - deltaMinutes * 60
					if (deltaMinutes < 0) then
						deltaMinutes = 0
						deltaSeconds = 0
					end
					if (deltaMinutes > 999) then
						deltaMinutes = 0
						deltaSeconds = 0
					end
					
					--转字符串
					local strdeltaMinutes = tostring(deltaMinutes)
					if (deltaMinutes < 10) then
						strdeltaMinutes = "0" .. deltaMinutes
					end
					local strdeltaSeconds = tostring(deltaSeconds)
					if (deltaSeconds < 10) then
						strdeltaSeconds = "0" .. strdeltaSeconds
					end
					local strGameTime = strdeltaMinutes .. ":" .. strdeltaSeconds
					
					_frmNode.childUI["PvpRoomNode" .. i].childUI["roomFullLabel"]:setText("")
					_frmNode.childUI["PvpRoomNode" .. i].childUI["roomGameTimeLabel"]:setText(strGameTime)
				end
			end
			
			--[[
			--未知人数图标
			for p = enterPlayerNum + 1, allPlayerNum, 1 do
				_frmNode.childUI["PvpRoomNode" .. i].childUI["role" .. p] = hUI.image:new({
					parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
					model = "ICON:action_info",
					x = -45 + (p - 1) * 90,
					y = 0,
					w = 48,
					h = 48,
				})
			end
			]]
			
			--[[
			--当前房间状态
			local szState = nil
			if (state == 1) then
				szState = "未开始"
			elseif (state == 2) then
				szState = "正在游戏"
			end
			
			_frmNode.childUI["PvpRoomNode" .. i].childUI["state"] = hUI.label:new({
				parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
				size = 24,
				x = 0,
				y = -45,
				width = 300,
				align = "MC",
				font = hVar.FONTC,
				text = szState,
				border = 1,
			})
			]]
			
			--检测房间名是否是本房间内玩家的名字
			local bRoomNameValid = false
			for p = 1, allPlayerNum, 1 do
				if (playerNameList[p] ~= "") then
					local pos = string.find(roomName, playerNameList[p])
					if (pos ~= nil) then
						bRoomNameValid = true
						break
					end
				end
			end
			if (not bRoomNameValid) then
				local validName = ""
				for p = 1, allPlayerNum, 1 do
					if (playerNameList[p] ~= "") then
						validName = playerNameList[p]
						break
					end
				end
				if bIsArena then
					--roomName = validName .. "的擂台" --language
					roomName = validName .. hVar.tab_string["__TEXT_PVP_SARENA"] --language
				else
					--roomName = validName .. "的房间" --language
					roomName = validName .. hVar.tab_string["__TEXT_PVP_SROOM"] --language
				end
			end
			
			--房间的标题
			local roomFontSize = 24
			--if (#roomName > 27) then
			--	roomFontSize = 22
			--end
			_frmNode.childUI["PvpRoomNode" .. i].childUI["title"] = hUI.label:new({
				parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
				size = roomFontSize,
				x = 0,
				y = 60,
				width = 300,
				align = "MC",
				font = hVar.FONTC,
				text = roomName,
				border = 1,
			})
			if (enterPlayerNum >= allPlayerNum) or (state > 1) then --人数已满或已开始游戏，灰掉
				_frmNode.childUI["PvpRoomNode" .. i].childUI["title"].handle.s:setColor(ccc3(192, 192, 96))
			else
				_frmNode.childUI["PvpRoomNode" .. i].childUI["title"].handle.s:setColor(ccc3(255, 255, 128))
			end
			
			--装备图标1
			_frmNode.childUI["PvpRoomNode" .. i].childUI["equipment1"] = hUI.image:new({
				parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
				model = "UI:UI_EQUIP",
				x = 50,
				y = 5,
				w = 70,
				h = 58,
			})
			
			--战图片文字2
			_frmNode.childUI["PvpRoomNode" .. i].childUI["equipment2"] = hUI.image:new({
				parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
				model = "UI:FONT_ZHAN2",
				x = 50,
				y = 7,
				w = 46,
				h = 46,
			})
			
			--魏国头像
			_frmNode.childUI["PvpRoomNode" .. i].childUI["side2RoleIcon"] = hUI.image:new({
				parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
				model = "ICON:skill_icon1_x4y4",
				x = 135,
				y = 8,
				w = 56,
				h = 56,
			})
			if (enterPlayerNum >= allPlayerNum) or (state > 1) then --人数已满或已开始游戏，灰掉
				_frmNode.childUI["PvpRoomNode" .. i].childUI["side2RoleIcon"].handle.s:setColor(ccc3(168, 168, 168))
			else
				--_frmNode.childUI["PvpRoomNode" .. i].childUI["side2RoleIcon"].handle.s:setColor(ccc3(255, 255, 255))
			end
			
			--魏国头像边框
			_frmNode.childUI["PvpRoomNode" .. i].childUI["side2RoleIconBorder"] = hUI.image:new({
				parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
				model = "UI:NewKuang",
				x = 135,
				y = 8,
				w = 56,
				h = 56,
			})
			if (enterPlayerNum >= allPlayerNum) or (state > 1) then --人数已满或已开始游戏，灰掉
				_frmNode.childUI["PvpRoomNode" .. i].childUI["side2RoleIconBorder"].handle.s:setColor(ccc3(168, 168, 168))
			else
				--_frmNode.childUI["PvpRoomNode" .. i].childUI["side2RoleIconBorder"].handle.s:setColor(ccc3(255, 255, 255))
			end
			
			--魏国名字
			_frmNode.childUI["PvpRoomNode" .. i].childUI["side2RoleName"] = hUI.label:new({
				parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
				size = 18,
				x = 135,
				y = -36,
				width = 300,
				align = "MC",
				font = hVar.FONTC,
				--text = "魔龙", --langauage
				text = hVar.tab_string["__TEXT_PVP_DRAGON"], --langauage
				--RGB = {255, 0, 0},
				border = 1,
			})
			if (enterPlayerNum >= allPlayerNum) or (state > 1) then --人数已满或已开始游戏，灰掉
				_frmNode.childUI["PvpRoomNode" .. i].childUI["side2RoleName"].handle.s:setColor(ccc3(192, 0, 0))
			else
				_frmNode.childUI["PvpRoomNode" .. i].childUI["side2RoleName"].handle.s:setColor(ccc3(255, 0, 0))
			end
			
			--房间的选中边框
			_frmNode.childUI["PvpRoomNode" .. i].childUI["selectbox"] = hUI.button:new({ --作为按钮是为了挂载子控件
				parent = _frmNode.childUI["PvpRoomNode" .. i].handle._n,
				model = "misc/mask.png",
				x = 0,
				y = 0,
				w = PVPROOM.WIDTH + 4,
				h = PVPROOM.HEIGHT + 4,
			})
			_frmNode.childUI["PvpRoomNode" .. i].childUI["selectbox"].handle.s:setOpacity(0) --只挂载子控件，不显示
			--_frmNode.childUI["PvpRoomNode" .. i].childUI["selectbox"].handle.s:setVisible(false) --默认不显示选中框
			_frmNode.childUI["PvpRoomNode" .. i].childUI["selectbox"]:setstate(-1) --默认不显示选中框
			--9宫格
			hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/tactic_frame.png", 0, 0, PVPROOM.WIDTH, PVPROOM.HEIGHT, _frmNode.childUI["PvpRoomNode" .. i].childUI["selectbox"])
		end
	end
	
	--函数：收到房间摘要信息回调(铜雀台)
	on_receive_RoomAbstract_event_page2 = function(roomAbstractList)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--隐藏菊花和提示信息
		_frmNode.childUI["waitingSmall"].handle.s:setVisible(false)
		if _frmNode.childUI["WaitingImg"] then
			_frmNode.childUI["WaitingImg"].handle.s:setVisible(false)
		end
		if _frmNode.childUI["StateLabel"] then
			--_frmNode.childUI["StateLabel"]:setText("")
			hApi.safeRemoveT(_frmNode.childUI, "StateLabel")
		end
		
		--先清空上次PVP房间信息的界面相关控件
		_removeRightFrmFunc()
		
		--[[
		--测试 --test
		roomAbstractList =
		{
			{id = 1, name = "铜雀台的房间1", cfgId = 2, rm = 80000001, mapName = "测试地图", mapInfo = {}, state = 1, allPlayerNum = 2, enterPlayerNum = 1, sessionState = 0, sessionBeginTimestamp = -1, enterPlayerName = "策马奔腾啊|铜雀台的的||:魏国", bUseEquip = true},
			{id = 2, name = "呵呵呵呵呵2", cfgId = 2, rm = 80000002, mapName = "测试地图", mapInfo = {}, state = 1, allPlayerNum = 2, enterPlayerNum = 2, sessionState = 0, sessionBeginTimestamp = -1, enterPlayerName = "呵呵呵呵呵|sdfsdfsdfsdf||:魏国", bUseEquip = false},
			{id = 3, name = "铜雀台的房间3", cfgId = 2, rm = 80000003, mapName = "测试地图", mapInfo = {}, state = 1, allPlayerNum = 2, enterPlayerNum = 1, sessionState = 0, sessionBeginTimestamp = -1, enterPlayerName = "xxx||:魏国", bUseEquip = true},
			{id = 4, name = "铜雀台的房间4", cfgId = 2, rm = 80000004, mapName = "测试地图", mapInfo = {}, state = 1, allPlayerNum = 2, enterPlayerNum = 2, sessionState = 0, sessionBeginTimestamp = -1, enterPlayerName = "X3|W4|Z5:魏国", bUseEquip = false},
			{id = 5, name = "铜雀台的房间5", cfgId = 2, rm = 80000005, mapName = "测试地图", mapInfo = {}, state = 1, allPlayerNum = 2, enterPlayerNum = 1, sessionState = 0, sessionBeginTimestamp = -1, enterPlayerName = "||B:魏国", bUseEquip = true},
			{id = 6, name = "铜雀台的房间6", cfgId = 2, rm = 80000006, mapName = "测试地图", mapInfo = {}, state = 2, allPlayerNum = 2, enterPlayerNum = 2, sessionState = 0, sessionBeginTimestamp = -1, enterPlayerName = "|||:魏国", bUseEquip = false},
			{id = 7, name = "铜雀台的房间7", cfgId = 2, rm = 80000007, mapName = "测试地图", mapInfo = {}, state = 1, allPlayerNum = 2, enterPlayerNum = 1, sessionState = 0, sessionBeginTimestamp = -1, enterPlayerName = "无||:魏国", bUseEquip = true},
			{id = 8, name = "铜雀台的房间8", cfgId = 2, rm = 80000008, mapName = "测试地图", mapInfo = {}, state = 2, allPlayerNum = 2, enterPlayerNum = 2, sessionState = 0, sessionBeginTimestamp = -1, enterPlayerName = "困难电脑|简单电脑|中等电脑|:魏国", bUseEquip = false},
			{id = 9, name = "铜雀台的房间9", cfgId = 2, rm = 80000009, mapName = "测试地图", mapInfo = {}, state = 1, allPlayerNum = 2, enterPlayerNum = 1, sessionState = 0, sessionBeginTimestamp = -1, enterPlayerName = "|右边右边右边打斗|:魏国", bUseEquip = true},
			{id = 10, name = "铜雀台的房间10", cfgId = 2, rm = 80000010, mapName = "测试地图", mapInfo = {}, state = 2, allPlayerNum = 2, enterPlayerNum = 2, sessionState = 0, sessionBeginTimestamp = -1, enterPlayerName = "困难电脑|中等电脑:魏国", bUseEquip = true},
			{id = 11, name = "铜雀台的房间11", cfgId = 2, rm = 80000011, mapName = "测试地图", mapInfo = {}, state = 1, allPlayerNum = 2, enterPlayerNum = 1, sessionState = 0, sessionBeginTimestamp = -1, enterPlayerName = "中等电脑||:魏国", bUseEquip = false},
			{id = 12, name = "铜雀台的房间12", cfgId = 2, rm = 80000012, mapName = "测试地图", mapInfo = {}, state = 2, allPlayerNum = 2, enterPlayerNum = 2, sessionState = 0, sessionBeginTimestamp = -1, enterPlayerName = "", bUseEquip = false},
			{id = 13, name = "铜雀台的房间13", cfgId = 2, rm = 80000013, mapName = "测试地图", mapInfo = {}, state = 2, allPlayerNum = 2, enterPlayerNum = 2, sessionState = 0, sessionBeginTimestamp = -1, enterPlayerName = "", bUseEquip = false},
		}
		]]
		
		--排序
		table.sort(roomAbstractList, function(ra, rb)
			--人数未满的，排在前面
			if (ra.enterPlayerNum ~= rb.enterPlayerNum) then
				return (ra.enterPlayerNum < rb.enterPlayerNum)
			end
			
			--未开局的，排在前面
			if (ra.state ~= rb.state) then
				return (ra.state < rb.state)
			end
			
			--按房主id排序
			return (ra.rm < rb.rm)
		end)
		
		--本页面只显示铜雀台地图的房间，不显示别的地图（夺塔奇兵，等）的房间
		for i = #roomAbstractList, 1, -1 do
			local cfgId = roomAbstractList[i].cfgId --房间地图配置索引
			if (cfgId ~= 2) then --非铜雀台地图
				table.remove(roomAbstractList, i)
			end
		end
		
		--自己的房间，第一个显示
		if (current_RoomId_page2 > 0) then
			for i = 2, #roomAbstractList, 1 do --本身就是第1个就不处理了
				local listI = roomAbstractList[i]
				if (listI.id == current_RoomId_page2) then
					table.remove(roomAbstractList, i)
					table.insert(roomAbstractList, 1, listI)
					break
				end
			end
		end
		
		--存储PVP房间信息表
		--print("roomAbstractList=" .. tostring(roomAbstractList), #roomAbstractList)
		current_RoomAbstractList_page2 = roomAbstractList
		current_Room_max_num_page2 = 0
		
		--[[
		--test
		--打log
		xlLG("IapList", "xlLuaEvent_OnIapList()\n")
		for i = 1, #current_RoomAbstractList_page2, 1 do
			local listI = current_RoomAbstractList_page2[i] --第i项
			if (listI) then --存在PVP房间信息第i项表
				xlLG("IapList", "i=" .. i .. "\n")
				for k, v in pairs(listI) do
					xlLG("IapList", "[" .. k .. "]=" .. v .. "\n")
				end
			end
		end
		]]
		
		--依次绘制界面
		local validIdx = 0 --有效的索引
		for i = 1, #current_RoomAbstractList_page2, 1 do
			local listI = current_RoomAbstractList_page2[i] --第i项
			if (listI) then --存在PVP房间信息第i项表
				--标记参数
				validIdx = validIdx + 1 --有效的索引加1
				current_Room_max_num_page2 = validIdx --标记最大PVP房间id
				
				--依次创建单个界面
				OnCreateSingleRoomAbstractFrame_page2(listI, i)
			end
		end
		
		--如果是当前时段未开放，显示开放的时段
		--g_pvp_room_closetime
		--主界面刷新竞技场关闭的倒计时
		local clienttime = os.time()
		local hosttime = clienttime - g_localDeltaTime_pvp --(Local = Host + deltaTime)
		
		--20:00:00～21:59:59 GMT+8时区
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - 8 --与北京时间的时差
		hosttime = hosttime - delteZone * 3600
		local tabNow = os.date("*t", hosttime) --北京时区
		local yearNow = tabNow.year
		local monthNow = tabNow.month
		local dayNow = tabNow.day
		local strYearNow = tostring(yearNow)
		local strMonthNow = tostring(monthNow)
		if (monthNow < 10) then
			strMonthNow = "0" .. strMonthNow
		end
		local strDayNow = tostring(dayNow)
		if (dayNow < 10) then
			strDayNow = "0" .. strDayNow
		end
		local strDayBegin = strYearNow .. "-" .. strMonthNow .. "-" .. strDayNow .. " 20:00:00"
		local strDayEnd = strYearNow .. "-" .. strMonthNow .. "-" .. strDayNow .. " 21:59:59"
		local pve_room_begintime = hApi.GetNewDate(strDayBegin)
		local pve_room_closetime = hApi.GetNewDate(strDayEnd)
		
		local begintime_room = hosttime - pve_room_begintime
		local lefttime_room = pve_room_closetime - hosttime
		--print("now=", os.date("%Y-%m-%d %H:%M:%S", hosttime))
		--print(strDayBegin, strDayEnd)
		--print(begintime_room, lefttime_room)
		
		--如果一个房间都没，显示文字
		if (#current_RoomAbstractList_page2 == 0) then
			--提示没有房间
			_frmNode.childUI["NoRoomHint"] = hUI.label:new({
				parent = _parentNode,
				x = PVPROOM.OFFSET_X + 310 + 208,
				y = PVPROOM.OFFSET_Y - 350,
				size = 26,
				font = hVar.FONTC,
				align = "MC",
				width = 500,
				border = 1,
				--text = "暂无房间", --language
				text = hVar.tab_string["__TEXT_PVP_NoRoom"], --language
			})
			_frmNode.childUI["NoRoomHint"].handle.s:setColor(ccc3(168, 168, 168))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "NoRoomHint"
			
			if (lefttime_room >= 0) and (begintime_room >= 0) then
				--_frmNode.childUI["NoRoomHint"]:setText("暂无房间") --language
				_frmNode.childUI["NoRoomHint"]:setText(hVar.tab_string["__TEXT_PVP_NoRoom"]) --language
			else
				local intBeginHour = (20 + delteZone) % 24 --开始的小时
				local intEndHour = (22 + delteZone) % 24 --结束的小时
				if (intEndHour == 0) then
					intEndHour = 24
				end
				--local strOpenTime = "挑战魔龙开放时段：每天20:00 - 22:00" --language
				local strOpenTime = hVar.tab_string["__TEXT_PVP_NoRoom_OpenTime_MultyPve"] .. intBeginHour .. ":00 - " .. intEndHour .. ":00" --language
				if (delteZone == 0) then --北京时间
					_frmNode.childUI["NoRoomHint"]:setText(strOpenTime)
				else
					_frmNode.childUI["NoRoomHint"]:setText(strOpenTime .. "\n" .. hVar.tab_string["__TEXT_PVP_NoRoom_OpenTime_Standard_MultyPve"])
				end
			end
		end
		
		--目前支持的网络文字
		_frmNode.childUI["RoomSupportNetLabel"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 300,
			y = PVPROOM.OFFSET_Y - 619 - 24,
			size = 22,
			font = hVar.FONTC,
			align = "LC",
			width = 500,
			border = 1,
			--text = "目前支持网络: 电信WiFi , 移动4G", --language
			text = hVar.tab_string["__TEXT_PVP_SupportNetEnvironment"], --language
		})
		--_frmNode.childUI["RoomPingPrefixLabel"].handle.s:setColor(ccc3(255, 255, 64))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomSupportNetLabel"
		
		--显示我的网络延时前缀
		_frmNode.childUI["RoomPingPrefixLabel"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 122,
			y = PVPROOM.OFFSET_Y - 619 - 24,
			size = 22,
			font = hVar.FONTC,
			align = "LC",
			width = 500,
			border = 1,
			--text = "网络延时:", --language
			text = hVar.tab_string["__TEXT_NetDelayTime"] .. ":", --language
		})
		--_frmNode.childUI["RoomPingPrefixLabel"].handle.s:setColor(ccc3(255, 255, 64))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomPingPrefixLabel"
		
		--显示我的网络延时
		_frmNode.childUI["RoomPingLabel"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 222,
			y = PVPROOM.OFFSET_Y - 619 - 24 - 1, --数字字体有1像素偏差
			size = 17,
			font = "numWhite",
			align = "LC",
			width = 500,
			--border = 1,
			text = current_ping_value,
		})
		--_frmNode.childUI["RoomPingLabel"].handle.s:setColor(ccc3(255, 255, 64))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomPingLabel"
		
		--更新左侧选中框
		--隐藏上一次的选中框
		--_frmNode.childUI["PvpRoomNode" .. last_achieve_idx].childUI["PvpRoomSelectBox"].handle._n:setVisible(false)
		
		--显示本次的
		--_frmNode.childUI["PvpRoomNode" .. current_focus_pvproomEx_idx_page2].childUI["PvpRoomSelectBox"].handle._n:setVisible(true)
		
		--更新提示翻页的按钮
		--不显示上翻页提示
		_frmNode.childUI["PvpRoomPageUp"].handle.s:setVisible(false)
		
		--如果PVP房间未铺满第一页，那么不显示下翻页提示
		if (current_Room_max_num_page2 <= (PVPROOM_X_NUM * PVPROOM_Y_NUM)) then
			_frmNode.childUI["PvpRoomPageDown"].handle.s:setVisible(false)
		else
			_frmNode.childUI["PvpRoomPageDown"].handle.s:setVisible(true)
		end
		
		--创建房间的按钮
		if (current_RoomId_page2 == 0) then --如果本地没有在房间中，那么创建房间的按钮
			if (lefttime_room >= 0) and (begintime_room >= 0) then
				--创建房间、修改配置的按钮
				_frmNode.childUI["CreateRoomButton"]:setstate(1)
				
				--隐藏管理员创建房间按钮
				if _frmNode.childUI["CreateRoomButton_Admin"] then
					_frmNode.childUI["CreateRoomButton_Admin"]:setstate(-1)
				end
			else
				--创建房间、修改配置的按钮
				_frmNode.childUI["CreateRoomButton"]:setstate(-1)
				
				--if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
				if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
					--显示管理员创建房间按钮
					if _frmNode.childUI["CreateRoomButton_Admin"] then
						_frmNode.childUI["CreateRoomButton_Admin"]:setstate(1)
					end
				end
			end
			--_frmNode.childUI["ModifyConfigButton"]:setstate(1)
		else --在房间中，删除创建按钮、修改配置按钮
			_frmNode.childUI["CreateRoomButton"]:setstate(-1)
			if _frmNode.childUI["CreateRoomButton_Admin"] then
				_frmNode.childUI["CreateRoomButton_Admin"]:setstate(-1)
			end
			--_frmNode.childUI["ModifyConfigButton"]:setstate(-1)
		end
	end
	
	--函数：收到单个房间摘要信息发生变化回调(铜雀台)
	on_receive_SingleRoomAbstractChanged_event_page2 = function(singleRoomAbstractList)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--自己在房间里，不处理
		if (current_RoomId_page2 > 0) then
			return
		end
		
		--没有单个房间信息，直接返回
		if (#singleRoomAbstractList < 1) then
			return
		end
		
		--[[
		--测试 --test
		singleRoomAbstractList =
		{
			{id = 1, name = "铜雀台打斗打斗的房间", cfgId = 2, rm = 80000001, mapName = "测试地图", mapInfo = {}, state = 1, allPlayerNum = 2, enterPlayerNum = 1, sessionState = 0, sessionBeginTimestamp = -1, enterPlayerName = ":策马奔腾", bUseEquip = true},
		}
		]]
		
		--检测是否在已有的房间列表里
		local findIdx = 0
		for i = 1, #current_RoomAbstractList_page2, 1 do
			local listi = current_RoomAbstractList_page2[i] --第i项
			if (listi) then --存在PVP房间信息第i项表
				local idi = listi.id --房间id
				if (idi == singleRoomAbstractList[1].id) then
					findIdx = i --找到了
					break
				end
			end
		end
		
		--print("findIdx=", findIdx)
		--是否为删除房间
		local released = singleRoomAbstractList[1].released
		
		--处理删除房间的行为
		if released then
			--存在房间，删除界面
			if (findIdx > 0) then
				--最大索引
				local maxIdx = current_Room_max_num_page2
				
				--非最后一项，把最后一项的内容拷到findIdx项
				if (findIdx ~= maxIdx) then
					--重新创建单个界面
					local listi = current_RoomAbstractList_page2[maxIdx]
					OnCreateSingleRoomAbstractFrame_page2(listi, findIdx)
				end
				
				--删除最后一项
				if _frmNode.childUI["PvpRoomNode" .. maxIdx] then
					hApi.safeRemoveT(_frmNode.childUI, "PvpRoomNode" .. maxIdx)
				end
				
				--存储本次的值
				current_Room_max_num_page2 = current_Room_max_num_page2 - 1
				
				if (findIdx ~= maxIdx) then
					local listi = current_RoomAbstractList_page2[maxIdx]
					current_RoomAbstractList_page2[findIdx] = listi
				end
				current_RoomAbstractList_page2[maxIdx] = nil
				
				--如果当前没一个房间了，加"暂无房间"的文字提示
				if (current_Room_max_num_page2 == 0) then
					--提示没有房间
					if (not _frmNode.childUI["NoRoomHint"]) then
						_frmNode.childUI["NoRoomHint"] = hUI.label:new({
							parent = _parentNode,
							x = PVPROOM.OFFSET_X + 310 + 208,
							y = PVPROOM.OFFSET_Y - 350,
							size = 26,
							font = hVar.FONTC,
							align = "MC",
							width = 500,
							border = 1,
							--text = "暂无房间", --language
							text = hVar.tab_string["__TEXT_PVP_NoRoom"], --language
						})
						_frmNode.childUI["NoRoomHint"].handle.s:setColor(ccc3(168, 168, 168))
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "NoRoomHint"
					end
					
					--如果是当前时段未开放，显示开放的时段
					--g_pvp_room_closetime
					--主界面刷新竞技场关闭的倒计时
					local clienttime = os.time()
					local hosttime = clienttime - g_localDeltaTime_pvp --(Local = Host + deltaTime)
					
					--20:00:00～21:59:59 GMT+8时区
					local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
					local delteZone = localTimeZone - 8 --与北京时间的时差
					hosttime = hosttime - delteZone * 3600
					local tabNow = os.date("*t", hosttime) --北京时区
					local yearNow = tabNow.year
					local monthNow = tabNow.month
					local dayNow = tabNow.day
					local strYearNow = tostring(yearNow)
					local strMonthNow = tostring(monthNow)
					if (monthNow < 10) then
						strMonthNow = "0" .. strMonthNow
					end
					local strDayNow = tostring(dayNow)
					if (dayNow < 10) then
						strDayNow = "0" .. strDayNow
					end
					local strDayBegin = strYearNow .. "-" .. strMonthNow .. "-" .. strDayNow .. " 20:00:00"
					local strDayEnd = strYearNow .. "-" .. strMonthNow .. "-" .. strDayNow .. " 21:59:59"
					local pve_room_begintime = hApi.GetNewDate(strDayBegin)
					local pve_room_closetime = hApi.GetNewDate(strDayEnd)
					
					local begintime_room = hosttime - pve_room_begintime
					local lefttime_room = pve_room_closetime - hosttime
					--print("now=", os.date("%Y-%m-%d %H:%M:%S", hosttime))
					--print(strDayBegin, strDayEnd)
					--print(begintime_room, lefttime_room)
					
					if (lefttime_room >= 0) and (begintime_room >= 0) then
						--_frmNode.childUI["NoRoomHint"]:setText("暂无房间") --language
						_frmNode.childUI["NoRoomHint"]:setText(hVar.tab_string["__TEXT_PVP_NoRoom"]) --language
					else
						local intBeginHour = (20 + delteZone) % 24 --开始的小时
						local intEndHour = (22 + delteZone) % 24 --结束的小时
						if (intEndHour == 0) then
							intEndHour = 24
						end
						--local strOpenTime = "挑战魔龙开放时段：每天20:00 - 22:00" --language
						local strOpenTime = hVar.tab_string["__TEXT_PVP_NoRoom_OpenTime_MultyPve"] .. intBeginHour .. ":00 - " .. intEndHour .. ":00" --language
						if (delteZone == 0) then --北京时间
							_frmNode.childUI["NoRoomHint"]:setText(strOpenTime)
						else
							_frmNode.childUI["NoRoomHint"]:setText(strOpenTime .. "\n" .. hVar.tab_string["__TEXT_PVP_NoRoom_OpenTime_Standard_MultyPve"])
						end
					end
				end
				
				--如果不足一页了，隐藏上下翻页的按钮
				if (current_Room_max_num_page2 <= (PVPROOM_X_NUM * PVPROOM_Y_NUM)) then
					_frmNode.childUI["PvpRoomPageUp"].handle.s:setVisible(false)
					_frmNode.childUI["PvpRoomPageDown"].handle.s:setVisible(false)
				end
			end
		else
			--有房间
			--本页面只显示铜雀台地图的房间，不显示别的地图（夺塔奇兵，等）的房间
			local cfgId = singleRoomAbstractList[1].cfgId --房间地图配置索引
			if (cfgId ~= 2) then --非铜雀台地图
				return
			end
			
			--存在房间，修改界面
			if (findIdx > 0) then
				local i = findIdx --全部房间摘要表的第findIdx项
				local listI = singleRoomAbstractList[1] --单个房间摘要表的第1项
				if (listI) then --存在PVP房间信息第i项表
					if (listI.sessionBeginTimestamp == -1) then
						listI.sessionBeginTimestamp = os.time() - g_localDeltaTime_pvp --(Local = Host + deltaTime)
					end
					
					--删除上一次的
					--if _frmNode.childUI["PvpRoomNode" .. i] then
					--	hApi.safeRemoveT(_frmNode.childUI, "PvpRoomNode" .. i)
					--end
					
					--重新创建单个界面
					OnCreateSingleRoomAbstractFrame_page2(listI, i)
					
					--存储本次的值
					current_RoomAbstractList_page2[i] = listI
				end
			else --新创建的房间
				--如果当前小于一个屏幕内，创建新的控件（有可能存在滑动，不能确定当前控件的位置）
				if (current_Room_max_num_page2 < (PVPROOM_X_NUM * PVPROOM_Y_NUM)) then
					local i = current_Room_max_num_page2 + 1 --全部房间摘要表的最后一项
					local listI = singleRoomAbstractList[1] --单个房间摘要表的第1项
					if (listI) then --存在PVP房间信息第i项表
						--删除上一次的
						--if _frmNode.childUI["PvpRoomNode" .. i] then
						--	hApi.safeRemoveT(_frmNode.childUI, "PvpRoomNode" .. i)
						--end
						if (listI.sessionBeginTimestamp == -1) then
							listI.sessionBeginTimestamp = os.time() - g_localDeltaTime_pvp --(Local = Host + deltaTime)
						end
						
						--重新创建单个界面
						OnCreateSingleRoomAbstractFrame_page2(listI, i)
						
						--存储本次的值
						current_Room_max_num_page2 = current_Room_max_num_page2 + 1
						current_RoomAbstractList_page2[i] = listI
					end
				else
					--房间已满，找到第一个状态是已在游戏局的游戏局，替换掉它
					local replaceIdx = 0
					for i = 1, #current_RoomAbstractList_page2, 1 do
						local listi = current_RoomAbstractList_page2[i] --第i项
						if (listi) then --存在PVP房间信息第i项表
							local statei = listi.state --房主状态(1:未开始 / 2:正在游戏)
							if (statei > 1) then
								replaceIdx = i --找到了
								break
							end
						end
					end
					
					--存在替换的房间
					if (replaceIdx > 0) then
						local i = replaceIdx --全部房间摘要表的第replaceIdx项
						local listI = singleRoomAbstractList[1] --单个房间摘要表的第1项
						if (listI) then --存在PVP房间信息第i项表
							
							--删除上一次的
							--if _frmNode.childUI["PvpRoomNode" .. i] then
							--	hApi.safeRemoveT(_frmNode.childUI, "PvpRoomNode" .. i)
							--end
							
							--重新创建单个界面
							OnCreateSingleRoomAbstractFrame_page2(listI, i)
							
							--存储本次的值
							current_RoomAbstractList_page2[i] = listI
						end
					else
						--所有的房间都是未开始状态，那么忽略本次
						--...
					end
				end
			end
			
			--删除"暂无房间"的文字提示
			hApi.safeRemoveT(_frmNode.childUI, "NoRoomHint")
			
			--如果超过一页了，显示上下翻页的按钮
			if (current_Room_max_num_page2 > (PVPROOM_X_NUM * PVPROOM_Y_NUM)) then
				_frmNode.childUI["PvpRoomPageUp"].handle.s:setVisible(true)
				_frmNode.childUI["PvpRoomPageDown"].handle.s:setVisible(true)
			end
		end
	end
	
	--函数：收到房间状态变化事件(铜雀台)
	on_receive_RoomEvent_event_page2 = function(eventId, user)
		--print("on_receive_RoomEvent_event_page2", eventId, user)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--user.id = tonumber(tCmd[2])
		--user.dbid = tonumber(tCmd[3])
		--user.rid = tonumber(tCmd[4])
		--user.name = tCmd[5]
		
		--1创建 2离开 3准备 4进入游戏 5房主变更 6被房主踢出
		if (eventId == 1) then --1:创建房间
			--...
		elseif (eventId == 6) then --6:被房主踢出
			--文字提示，被踢出房间
			--local strText = "您被房主踢出房间！" --language
			local strText = hVar.tab_string["__TEXT_PVP_KickOutRoom"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			--触发离开房间事件
			on_receive_LeaveRoom_event_page2(-1)
		end
	end
	
	--函数：收到自己所处的房间信息变化事件(铜雀台)
	on_receive_RoomInfo_event_page2 = function(room)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--隐藏菊花和提示信息
		_frmNode.childUI["waitingSmall"].handle.s:setVisible(false)
		if _frmNode.childUI["WaitingImg"] then
			_frmNode.childUI["WaitingImg"].handle.s:setVisible(false)
		end
		if _frmNode.childUI["StateLabel"] then
			--_frmNode.childUI["StateLabel"]:setText("")
			hApi.safeRemoveT(_frmNode.childUI, "StateLabel")
		end
		
		--隐藏可能的翻页按钮
		_frmNode.childUI["PvpRoomPageUp"].handle.s:setVisible(false)
		_frmNode.childUI["PvpRoomPageDown"].handle.s:setVisible(false)
		
		--优化处理: 跟上一次的房间信息做比较，检测是否只是准备状态发生了变化，只刷新局部
		local bPlayerInfoSame = true --玩家是否变化了
		if current_Room_page2 and room then
			if current_Room_page2.pList and room.pList then
				for force, forceInfo in ipairs(room.pList) do
					if (force == 1) then --铜雀台，只显示蜀国
						for idx, tmpPInfo in ipairs(forceInfo) do
							local uid = tmpPInfo.uid --用户id
							local udbid = tmpPInfo.dbid --用户dbid
							local rid = tmpPInfo.rid --用户rid
							local utype = tmpPInfo.utype --默认类型 0空 1玩家 2简单电脑 3中等电脑 4困难电脑
							--local ready = tmpPInfo.ready --是否准备 0 未准备 1 准备
							
							local tmpPInfoOld = current_Room_page2.pList[force][idx]
							local uidOld = tmpPInfoOld.uid --用户id
							local udbidOld = tmpPInfoOld.dbid --用户dbid
							local ridOld = tmpPInfoOld.rid --用户rid
							local utypeOld = tmpPInfoOld.utype --默认类型 0空 1玩家 2简单电脑 3中等电脑 4困难电脑
							
							if (uid ~= uidOld) or (udbid ~= udbidOld) or (rid ~= ridOld) or (utype ~= utypeOld) then
								bPlayerInfoSame = false --玩家变化了
							end
						end
					end
				end
			else
				bPlayerInfoSame = false --玩家变化了
			end
		else
			bPlayerInfoSame = false --玩家变化了
		end
		
		--玩家信息都没变，说明只是准备状态改变了
		if bPlayerInfoSame then
			--更新大厅的本房间信息
			current_Room_page2 = room
			current_RoomId_page2 = id
			
			--单独绘制房间的某位置玩家准备状态变化界面
			on_single_show_ready_state_UI(room)
			
			return
		end
		
		--先清空上次PVP房间信息的界面相关控件
		_removeRightFrmFunc()
		
		local id = room.id --房间id
		local cfgId = room.cfgId --房间地图配置索引
		local name = room.name --房间名
		local rm = room.rm --房主uid
		local mapName = room.mapName --房间地图名
		local mapInfo = room.mapInfo --地图信息
		local state = room.state --地图状态(未开始，正在游戏)
		local pList = room.pList --玩家列表
		local bUseEquip = room.bUseEquip --是否允许携带装备
		--print(bUseEquip)
		--print("on_receive_RoomInfo_event_page2(): id=" .. id .. ", cfgId=" .. cfgId .. ", name=" .. name .. ", rm=" .. rm .. ", mapName=" .. mapName .. ", mapInfo=" .. mapInfo .. ", state=" .. state)
		
		--更新大厅的本房间信息
		current_Room_page2 = room
		current_RoomId_page2 = id
		--current_RoomAbstractList_page2 = {}
		--current_Room_max_num_page2 = 0
		
		--[[
		--如果大厅没有自己房间的信息，那么插入到第一条中
		local bExisted = false
		for i = 1, #current_RoomAbstractList_page2, 1 do
			if (current_RoomAbstractList_page2[i].id == id) then
				bExisted = true --找到了
				--todo: 修改控件
				break
			end
		end
		
		if (not bExisted) then
			local listI = {}
			listI.id  = id --房间id
			listI.name = name --房间名称
			listI.cfgId  = cfgId --房间地图配置索引
			listI.rm  = rm --房主uid
			listI.mapName = mapName --房间地图名
			listI.mapInfo = mapInfo --房主地图信息
			listI.state = state --房主状态(1:未开始 / 2:正在游戏)
			listI.allPlayerNum  = 2 --玩家总数
			listI.enterPlayerNum = 1 --已进入玩家数
			
			table.insert(current_RoomAbstractList_page2, 1, listI)
			
			--函数：收到房间摘要信息回调
			on_receive_RoomAbstract_event_page2(current_RoomAbstractList_page2)
		end
		]]
		
		--绘制本房间信息
		--删除创建按钮、修改配置按钮
		_frmNode.childUI["CreateRoomButton"]:setstate(-1)
		if _frmNode.childUI["CreateRoomButton_Admin"] then
			_frmNode.childUI["CreateRoomButton_Admin"]:setstate(-1)
		end
		--_frmNode.childUI["ModifyConfigButton"]:setstate(-1)
		
		--创建挡操作的按钮1
		_frmNode.childUI["btnCoverOP1"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			model = "misc/mask.png",
			x = 25,
			y = -350,
			scaleT = 1.0,
			w = 250,
			h = 900,
			code = function()
				--
			end,
		})
		_frmNode.childUI["btnCoverOP1"].handle.s:setOpacity(0) --不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnCoverOP1"
		
		--创建挡操作的按钮2
		_frmNode.childUI["btnCoverOP2"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			model = "misc/mask.png",
			x = 150,
			y = -50,
			scaleT = 1.0,
			w = 800,
			h = 250,
			code = function()
				--
			end,
		})
		_frmNode.childUI["btnCoverOP2"].handle.s:setOpacity(0) --不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnCoverOP2"
		
		--创建挡操作的图片1
		_frmNode.childUI["btnCoverLine1"] = hUI.image:new({
			parent = _parentNode,
			model = "panel/panel_part_pvp_00.png",
			x = 59,
			y = -360,
			scaleT = 1.0,
			w = 100,
			h = 520,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnCoverLine1"
		
		--创建挡操作的图片2
		_frmNode.childUI["btnCoverLine2"] = hUI.image:new({
			parent = _parentNode,
			model = "panel/panel_part_pvp_03.png",
			x = 132,
			y = -360,
			scaleT = 1.0,
			w = 48,
			h = 500,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnCoverLine2"
		
		
		--[[
		--创建挡操作的图片1
		--面板的背景图-上i
		for i = 1, 10, 1 do
			_frmNode.childUI["frameBG_Top_" .. i] = hUI.image:new({
				parent = _parentNode,
				model = "panel/panel_part_pvp_00.png",
				x = PAGE_BTN_LEFT_X - 64 + (i - 1) * 94,
				y = PAGE_BTN_LEFT_Y - 27,
				w = 94,
				h = 88,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "frameBG_Top_" .. i
		end
		]]
		
		--面板的背景图-上i
		local i = 1
		_frmNode.childUI["frameBG_Top_" .. i] = hUI.image:new({
			parent = _parentNode,
			model = "panel/panel_part_pvp_00.png",
			x = PAGE_BTN_LEFT_X - 64 + (i - 1) * 94,
			y = PAGE_BTN_LEFT_Y - 27,
			w = 94,
			h = 88,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "frameBG_Top_" .. i
		--面板的背景图-上i
		local i = 2
		_frmNode.childUI["frameBG_Top_" .. i] = hUI.image:new({
			parent = _parentNode,
			model = "panel/panel_part_pvp_00.png",
			x = PAGE_BTN_LEFT_X - 64 + (i - 1) * 94 - 45,
			y = PAGE_BTN_LEFT_Y - 27,
			w = 94,
			h = 88,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "frameBG_Top_" .. i
		
		--创建挡操作的图片2
		for i = 1, 15, 1 do
			_frmNode.childUI["frameBG_Left_" .. i] = hUI.image:new({
				parent = _parentNode,
				model = "UI:pvproombg_left",
				x = PAGE_BTN_LEFT_X - 61,
				y = PAGE_BTN_LEFT_Y - 108 - (i - 1) * 34,
				w = 100,
				h = 34,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "frameBG_Left_" .. i
		end
		
		--创建挡操作的图片2
		_frmNode.childUI["btnCoverLine2"] = hUI.image:new({
			parent = _parentNode,
			model = "panel/panel_part_pvp_03.png",
			x = 132,
			y = -360,
			scaleT = 1.0,
			w = 48,
			h = 500,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnCoverLine2"
		--[[
		--创建挡操作的图片3
		_frmNode.childUI["btnCoverLine3"] = hUI.image:new({
			parent = _parentNode,
			model = "panel/panel_part_pvp_00.png",
			x = 480,
			y = -50,
			scaleT = 1.0,
			w = 940,
			h = 85,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnCoverLine3"
		]]
		
		--创建我的房间关闭按钮(铜雀台)
		_frmNode.childUI["btnCloseMyRoom"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
			model = "BTN:PANEL_CLOSE",
			x = _frm.data.w + closeDx,
			y = closeDy,
			scaleT = 0.95,
			code = function()
				--离开房间(铜雀台)
				OnLeaveRoomButton_page2()
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnCloseMyRoom"
		
		--创建我的房间关闭按钮2
		_frmNode.childUI["btnCloseMyRoom2"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
			model = "UI:LEAVETOWNBTN",
			x = 58,
			y = -590,
			scaleT = 0.95,
			code = _frmNode.childUI["btnCloseMyRoom"].data.code,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnCloseMyRoom2"
		
		--[[
		---本房间的标题背景图
		_frmNode.childUI["RoomTitleImg"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:MedalDarkImg", --"UI:Tactic_Button",
			x = PAGE_BTN_LEFT_X + 296,
			y = PAGE_BTN_LEFT_Y + 53,
			w = 220 + 50,
			h = 40,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomTitleImg"
		]]
		
		--本房间的标题
		_frmNode.childUI["RoomTitle"] = hUI.label:new({
			parent = _parentNode,
			x = PAGE_BTN_LEFT_X + 368,
			y = PAGE_BTN_LEFT_Y - 30,
			size = 36,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 300,
			text = name,
		})
		_frmNode.childUI["RoomTitle"].handle.s:setColor(ccc3(234, 255, 234))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomTitle"
		
		--[[
		--本房间的地图名
		_frmNode.childUI["RoomMapName"] = hUI.label:new({
			parent = _parentNode,
			size = 24,
			x = PVPROOM.OFFSET_X + 410,
			y = PVPROOM.OFFSET_Y - 90,
			width = 720,
			align = "MT",
			font = hVar.FONTC,
			--text = "地图名: " .. mapName,
			text = mapName,
			border = 1,
		})
		_frmNode.childUI["RoomMapName"].handle.s:setColor(ccc3(255, 255, 128))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomMapName"
		]]
		
		--[[
		--本房间id
		_frmNode.childUI["RoomId"] = hUI.label:new({
			parent = _parentNode,
			size = 24,
			x = PVPROOM.OFFSET_X + 280,
			y = PVPROOM.OFFSET_Y - 130,
			width = 720,
			align = "LT",
			font = hVar.FONTC,
			text = "地图id: " .. id,
			border = 1,
		})
		_frmNode.childUI["RoomId"].handle.s:setColor(ccc3(202, 255, 202))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomId"
		]]
		
		--本房间的房主
		local fangzhuName = "" --房主玩家名
		for force, forceInfo in ipairs(pList) do
			for idx, tmpPInfo in ipairs(forceInfo) do
				local uid = tmpPInfo.uid --玩家id
				local name = tmpPInfo.name --玩家姓名
				if (uid == rm) then
					fangzhuName = name
				end
			end
		end
		--房主玩家名控件
		_frmNode.childUI["RoomMapCreater"] = hUI.label:new({
			parent = _parentNode,
			size = 24,
			x = PVPROOM.OFFSET_X + 730,
			y = PVPROOM.OFFSET_Y - 95,
			width = 720,
			align = "LT",
			font = hVar.FONTC,
			--text = "房主: " .. fangzhuName, --language
			text = hVar.tab_string["__TEXT_PVP_RoomCreater"] .. ": " .. fangzhuName, --language
			border = 1,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomMapCreater"
		--_frmNode.childUI["RoomMapCreater"].handle.s:setColor(ccc3(255, 255, 192))
		
		--[[
		--本房间的地图简介
		_frmNode.childUI["RoomMapIntro"] = hUI.label:new({
			parent = _parentNode,
			size = 24,
			x = PVPROOM.OFFSET_X + 30,
			y = PVPROOM.OFFSET_Y - 155,
			width = 790,
			align = "LT",
			font = hVar.FONTC,
			--text = "地图介绍: " .. mapInfo, --language
			text = hVar.tab_string["__TEXT_PVP_MapIntroduce"] .. ": " .. mapInfo, --language
			border = 1,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomMapIntro"
		]]
		
		--[[
		--本地图的状态
		local szState = nil
		if (state == 1) then
			szState = "未开始"
		elseif (state == 2) then
			szState = "正在游戏"
		end
		_frmNode.childUI["RoomMapStateStr"] = hUI.label:new({
			parent = _parentNode,
			size = 24,
			x = PVPROOM.OFFSET_X + 40,
			y = PVPROOM.OFFSET_Y - 220,
			width = 720,
			align = "LT",
			font = hVar.FONTC,
			text = "状态: " .. szState,
			border = 1,
		})
		--_frmNode.childUI["RoomMapStateStr"].handle.s:setColor(ccc3(223, 255, 255))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomMapStateStr"
		]]
		
		--依次绘制每个势力
		--local forceNameList = {"蜀国", "魏国",} --language
		local forceNameList = {hVar.tab_string["__TEXT_PVP_Shu"], hVar.tab_string["__TEXT_PVP_Wei"],} --language
		local forceMe = 0 --我的势力
		local indexMe = 0 --我的索引位置
		local readyMe = 0 --我是否准备
		local OFFSETX = 330
		local OFFSETY = 480
		local DISTACEX = 400
		local DISTACEY = 230
		for force, forceInfo in ipairs(pList) do
			if (force == 1) then --铜雀台，只显示蜀国
				for idx, tmpPInfo in ipairs(forceInfo) do
					local pos = tmpPInfo.pos --用户位置
					local uid = tmpPInfo.uid --用户id
					local udbid = tmpPInfo.dbid --用户dbid
					local rid = tmpPInfo.rid --用户rid
					local name = tmpPInfo.name --玩家姓名
					local utype = tmpPInfo.utype --默认类型 0空 1玩家 2简单电脑 3中等电脑 4困难电脑
					local ready = tmpPInfo.ready --是否准备 0 未准备 1 准备
					local computerOnly = tmpPInfo.computerOnly --是否只允许电脑 0 否 1 是
					local ready = tmpPInfo.ready --是否准备 0 未准备 1 准备
					local winE = tmpPInfo.winE --用户娱乐房胜场
					local loseE = tmpPInfo.loseE --用户娱乐房负场
					local drawE = tmpPInfo.drawE --用户娱乐房平局
					local errE = tmpPInfo.errE --用户娱乐房异常场
					local escapeE = tmpPInfo.escapeE --用户娱乐房逃跑场
					local outsyncE = tmpPInfo.outsyncE --用户娱乐房不同步场
					local evaluateE =  tmpPInfo.evaluateE --用户娱乐模式累计星星评价
					local totalE = tmpPInfo.totalE --用户娱乐房总场
					local total = tmpPInfo.total --用户所有房间总场
					local coppercount = tmpPInfo.coppercount --用户开过的铜宝箱总量
					local silvercount = tmpPInfo.silvercount --用户开过的银宝箱总量
					local goldcount = tmpPInfo.goldcount --开过的金宝箱总量
					local chestexp = tmpPInfo.chestexp --总经验值
					
					--print("idx=" .. idx .. ", force=" .. force .. ", uid=" .. uid .. ", udbid=" .. tostring(udbid) .. ", pos=" .. pos .. ", utype=" .. utype .. ", ready=" .. ready .. ", computerOnly=" .. tostring(computerOnly))
					--print("current_PlayerId=" .. current_PlayerId)
					
					local xn = math.floor((idx - 1) / 2) + 1
					local yn = ((idx - 1) % 2)
					
					--框选整个玩家区域的背景框（只用于挂载子控件，不显示）
					--玩家的区域底图
					_frmNode.childUI["RoomPlayerBG_Paent" .. force .. "_" .. idx] = hUI.button:new({
						parent = _parentNode,
						model = "misc/mask.png", --"UI:MedalDarkImg",
						x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX,
						y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY,
						w = 1,
						h = 1,
					})
					_frmNode.childUI["RoomPlayerBG_Paent" .. force .. "_" .. idx].handle.s:setOpacity(0) --只用于挂载子控件，不显示
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomPlayerBG_Paent" .. force .. "_" .. idx
					--9宫格图
					--local imgLvUpBg9 = CCScale9Sprite:createWithSpriteFrameName("data/image/ui/kuang.png")
					--imgLvUpBg9:setPosition(ccp(136, -176))
					--imgLvUpBg9:setContentSize(CCSizeMake(270, 440))
					--_frmNode.childUI["RoomPlayerBG_Paent" .. force .. "_" .. idx].handle._n:addChild(imgLvUpBg9)
					local imgLvUpBg9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/kuang.png", 0, 0, 390, 220, _frmNode.childUI["RoomPlayerBG_Paent" .. force .. "_" .. idx])
					
					--玩家的区域底图
					_frmNode.childUI["RoomPlayerBG" .. force .. "_" .. idx] = hUI.image:new({
						parent = _parentNode,
						model = "UI:MedalDarkImg", --"UI:MedalDarkImg",
						x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX + 136 - 180 - 5,
						y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY + 60 + 10,
						w = 260,
						h = 42,
					})
					--_frmNode.childUI["RoomPlayerBG" .. force .. "_" .. idx].handle.s:setOpacity(168)
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomPlayerBG" .. force .. "_" .. idx
					
					--[[
					--玩家的区域底图2（9宫格）
					_frmNode.childUI["RoomPlayerBG2" .. force .. "_" .. idx] = hUI.button:new({ --作为按钮是为了挂载子控件
						parent = _parentNode,
						model = "misc/mask.png",
						x = PVPROOM.OFFSET_X + OFFSETX + (force - 1) * DISTACEX + 155,
						y = PVPROOM.OFFSET_Y - OFFSETY - (idx) * 30 - 150,
						w = 1,
						h = 1,
					})
					_frmNode.childUI["RoomPlayerBG2" .. force .. "_" .. idx].handle.s:setOpacity(0) --不显示，只挂载子控件
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomPlayerBG2" .. force .. "_" .. idx
					
					--9宫格图
					local imgLvUpBg9 = CCScale9Sprite:createWithSpriteFrameName("data/image/ui/image_frame.png")
					imgLvUpBg9:setPosition(ccp(0, 0))
					imgLvUpBg9:setContentSize(CCSizeMake(390, 350))
					_frmNode.childUI["RoomPlayerBG2" .. force .. "_" .. idx].handle._n:addChild(imgLvUpBg9)
					]]
					
					--玩家的名字
					_frmNode.childUI["RoomPlayer" .. force .. "_" .. idx] = hUI.label:new({
						parent = _parentNode,
						size = 26,
						x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX + 11 - 180 - 5,
						y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY + 60 + 10 - 1, --字体有1像素的偏差
						width = 720,
						align = "LC",
						font = hVar.FONTC,
						text = name,
						border = 1,
					})
					--_frmNode.childUI["RoomPlayer" .. force .. "_" .. idx].handle.s:setColor(ccc3(128, 255, 0))
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomPlayer" .. force .. "_" .. idx
					
					--空位置的玩家名文字稍微暗一点
					if (utype == 0) then
						_frmNode.childUI["RoomPlayer" .. force .. "_" .. idx].handle.s:setColor(ccc3(144, 144, 144))
					end
					
					--给自己加个箭头，标识自己在哪
					if (current_PlayerId == uid) then
						--我的势力
						forceMe = force
						indexMe = idx
						readyMe = ready
						
						--我的箭头
						_frmNode.childUI["JianTouMe" .. force .. "_" .. idx] = hUI.image:new({
							parent = _parentNode,
							model = "UI:direction",
							x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX + 11 + 180 - 90,
							y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY + 60 + 10 - 1, --字体有1像素的偏差
							scale = 0.5,
						})
						_frmNode.childUI["JianTouMe" .. force .. "_" .. idx].handle.s:setRotation(180)
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "JianTouMe" .. force .. "_" .. idx
						local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.8, ccp(3, 0)), CCMoveBy:create(0.8, ccp(-3, 0)))
						local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
						_frmNode.childUI["JianTouMe" .. force .. "_" .. idx].handle._n:runAction(forever)
					end
					
					--[[
					--战绩
					if (utype == 1) and (current_PlayerId ~= uid) then --是玩家，不显示我的
					--if  (current_PlayerId ~= uid) then --是玩家，不显示我的 --测试 --test
						--玩家的胜率前缀
						local strRate = (winE) .. "/" .. (totalE)
						_frmNode.childUI["RoomPlayerWinRatePrefix" .. force .. "_" .. idx] = hUI.label:new({
							parent = _parentNode,
							size = 26,
							x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX + 11 - 185,
							y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY + 60 - 50,
							width = 720,
							align = "LC",
							font = hVar.FONTC,
							--text = "胜率:", --language
							text = hVar.tab_string["PVPVictory"] .. ":", --language
							border = 1,
						})
						--_frmNode.childUI["RoomPlayerWinRatePrefix" .. force .. "_" .. idx].handle.s:setColor(ccc3(255, 255, 212))
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomPlayerWinRatePrefix" .. force .. "_" .. idx
						
						--玩家的胜率值
						_frmNode.childUI["RoomPlayerWinRate" .. force .. "_" .. idx] = hUI.label:new({
							parent = _parentNode,
							size = 22,
							x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX + 11 - 180 + 72,
							y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY + 60 - 50 - 1, --数字字体有1像素的偏差
							width = 720,
							align = "LC",
							font = "numWhite",
							--text = "234/774",
							text = strRate,
							--border = 1,
						})
						--_frmNode.childUI["RoomPlayerWinRate" .. force .. "_" .. idx].handle.s:setColor(ccc3(255, 255, 212))
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomPlayerWinRate" .. force .. "_" .. idx
						
						--玩家的逃跑率前缀
						_frmNode.childUI["RoomPlayerEscapeRatePrefix" .. force .. "_" .. idx] = hUI.label:new({
							parent = _parentNode,
							size = 26,
							x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX + 11 - 185,
							y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY + 60 - 90,
							width = 720,
							align = "LC",
							font = hVar.FONTC,
							--text = "逃跑率:", --language
							text = hVar.tab_string["__TEXT_Surrender"] .. ":", --language
							border = 1,
						})
						--_frmNode.childUI["RoomPlayerEscapeRatePrefix" .. force .. "_" .. idx].handle.s:setColor(ccc3(255, 255, 192))
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomPlayerEscapeRatePrefix" .. force .. "_" .. idx
						
						--玩家的逃跑率值
						local escapeRate = 0
						local escapeColor = nil
						if (escapeE >= PVPROOM_COLOR_RATE_MIN) then
							--escapeRate = math.ceil(escapeE / (escapeE + totalE) * 100)
							escapeRate = escapeE
						end
						for i = #PVPROOM_COLOR_RATE_TABLE, 1 , -1 do
							if (escapeRate >= PVPROOM_COLOR_RATE_TABLE[i][1]) then
								escapeColor = PVPROOM_COLOR_RATE_TABLE[i][2]
								break
							end
						end
						_frmNode.childUI["RoomPlayerEscapeRate" .. force .. "_" .. idx] = hUI.label:new({
							parent = _parentNode,
							size = 22,
							x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX + 11 - 180 + 72,
							y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY + 60 - 90 - 1, --数字字体有1像素的偏差
							width = 720,
							align = "LC",
							font = "numWhite",
							--text = (escapeRate .. "%"),
							text = (escapeRate),
						})
						_frmNode.childUI["RoomPlayerEscapeRate" .. force .. "_" .. idx].handle.s:setColor(escapeColor)
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomPlayerEscapeRate" .. force .. "_" .. idx
						
						--玩家的掉线率前缀
						_frmNode.childUI["RoomPlayerOfflineRatePrefix" .. force .. "_" .. idx] = hUI.label:new({
							parent = _parentNode,
							size = 26,
							x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX + 11 - 185,
							y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY + 60 - 130,
							width = 720,
							align = "LC",
							font = hVar.FONTC,
							--text = "掉线率:", --language
							text = hVar.tab_string["PVPOfflineRate"] .. ":", --language
							border = 1,
						})
						--_frmNode.childUI["RoomPlayerOfflineRatePrefix" .. force .. "_" .. idx].handle.s:setColor(ccc3(255, 255, 192))
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomPlayerOfflineRatePrefix" .. force .. "_" .. idx
						
						--玩家的掉线率值
						local offlineRate = 0
						local offlineColor = nil
						if (errE >= PVPROOM_COLOR_RATE_MIN) then
							--offlineRate = math.ceil(errE / (errE + totalE) * 100)
							offlineRate = errE
						end
						for i = #PVPROOM_COLOR_RATE_TABLE, 1 , -1 do
							if (offlineRate >= PVPROOM_COLOR_RATE_TABLE[i][1]) then
								offlineColor = PVPROOM_COLOR_RATE_TABLE[i][2]
								break
							end
						end
						_frmNode.childUI["RoomPlayerOfflineRate" .. force .. "_" .. idx] = hUI.label:new({
							parent = _parentNode,
							size = 22,
							x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX + 11 - 180 + 72,
							y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY + 60 - 130 - 1, --数字字体有1像素的偏差
							width = 720,
							align = "LC",
							font = "numWhite",
							--text = (offlineRate .. "%"),
							text = (offlineRate),
						})
						_frmNode.childUI["RoomPlayerOfflineRate" .. force .. "_" .. idx].handle.s:setColor(offlineColor)
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomPlayerOfflineRate" .. force .. "_" .. idx
					end
					]]
					
					--[[
					--玩家的标识是否准备的底图
					_frmNode.childUI["RoomPlayerStateBG" .. force .. "_" .. idx] = hUI.image:new({
						parent = _parentNode,
						model = "UI:MedalDarkImg",
						x = PVPROOM.OFFSET_X + OFFSETX + (force - 1) * DISTACEX + 270,
						y = PVPROOM.OFFSET_Y - OFFSETY - (idx) * 30,
						w = 100,
						h = 38,
					})
					_frmNode.childUI["RoomPlayerStateBG" .. force .. "_" .. idx].handle.s:setOpacity(96)
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomPlayerStateBG" .. force .. "_" .. idx
					]]
					
					--非空玩家，绘制是否 房主/已准备/未准备 的文字
					if (utype ~= 0) then
						local szReady = nil
						local colorReady = nil
						if (ready == 0) then --未准备
							--szReady = "(未准备)" --language
							szReady = "(" .. hVar.tab_string["__TEXT_PVP_RoomNotReady"] .. ")" --language
							colorReady = ccc3(255, 0, 0)
						elseif (ready == 1) then --已准备
							--szReady = "(已准备)" --language
							szReady = "(" .. hVar.tab_string["__TEXT_PVP_RoomReady"] .. ")" --language
							colorReady = ccc3(0, 255, 0)
						end
						if (rm == uid) then --是房主
							--szReady = "(房主)" --language
							szReady = "(" .. hVar.tab_string["__TEXT_PVP_RoomCreater"] .. ")" --language
							colorReady = ccc3(255, 255, 0)
						end
						_frmNode.childUI["RoomPlayerReady" .. force .. "_" .. idx] = hUI.label:new({
							parent = _parentNode,
							size = 26,
							x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX + 256 - 180 - 5,
							y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY + 60 + 10 - 1, --字体有1像素的偏差
							width = 720,
							align = "RC",
							font = hVar.FONTC,
							text = szReady,
							border = 1,
						})
						_frmNode.childUI["RoomPlayerReady" .. force .. "_" .. idx].handle.s:setColor(colorReady)
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "RoomPlayerReady" .. force .. "_" .. idx
					end
					
					--如果当前位置自己，那么有一个准备或者取消准备的按钮(房主不能准备)
					--print(current_PlayerId, uid)
					if (current_PlayerId == uid) and (rm ~= uid) then
					--if (current_PlayerId == uid) then --测试 --test
						--准备或者取消准备的按钮
						local szReady = nil
						if (ready == 0) then --未准备
							--szReady = "准备" --language
							szReady = hVar.tab_string["__TEXT_PVP_Ready"] --language
						elseif (ready == 1) then --已准备
							--szReady = "取消准备" --language
							szReady = hVar.tab_string["__TEXT_Cancel"] .. hVar.tab_string["__TEXT_PVP_Ready"] --language
						end
						
						--准备或者取消准备的按钮
						_frmNode.childUI["ReadyButton" .. force .. "_" .. idx] = hUI.button:new({
							parent = _parentNode,
							dragbox = _frm.childUI["dragBox"],
							--x = PVPROOM.OFFSET_X + 745,
							--y = PVPROOM.OFFSET_Y - 520,
							x = _frm.data.w - 100,
							y = -_frm.data.h + 45,
							scale = 1.1,
							--label = "准备"/"取消准备",
							--font = hVar.FONTC,
							--border = 1,
							model = "UI:BTN_ButtonRed",
							animation = "normal",
							scaleT = 0.95,
							code = function()
								if (ready == 0) then --未准备
									--点击房间内准备按钮
									OnReadyRoomButton_page2()
								elseif (ready == 1) then --已准备
									--点击房间内取消准备按钮
									OnCancelReadyRoomButton_page2()
								end
							end,
						})
						--_frmNode.childUI["ReadyButton" .. force .. "_" .. idx].handle.s:setOpacity(0) --只响应事件，不显示
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "ReadyButton" .. force .. "_" .. idx
						
						--"准备"/"取消"的文字
						_frmNode.childUI["ReadyButton" .. force .. "_" .. idx].childUI["label"] = hUI.label:new({
							parent = _frmNode.childUI["ReadyButton" .. force .. "_" .. idx].handle._n,
							x = 0,
							y = -2, --文字有2像素的偏差
							size = 28,
							text = szReady,
							align = "MC",
							font = hVar.FONTC,
							border = 1,
						})
					end
					
					--[[
					--房主可以踢掉本位置的有效玩家(房主不能踢自己)
					if (current_PlayerId == rm) and (current_PlayerId ~= uid) and (utype == 1) then
						--准备或者取消准备的按钮
						local szKick = "踢掉"
						_frmNode.childUI["ChangePosTypeButton" .. force .. "_" .. idx] = hUI.button:new({
							parent = _parentNode,
							dragbox = _frm.childUI["dragBox"],
							--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
							model = "BTN:PANEL_CLOSE",
							x = PVPROOM.OFFSET_X + OFFSETX + (force - 1) * DISTACEX + 295,
							y = PVPROOM.OFFSET_Y - OFFSETY - (idx) * 30,
							w = 80,
							h = 50,
							scale = 0.9,
							label = szKick,
							font = hVar.FONTC,
							border = 1,
							model = "UI:BTN_ButtonRed",
							animation = "normal",
							scaleT = 0.95,
							code = function()
								--点击修改房间内位置类型按钮 0空 1玩家 2简单电脑 3中等电脑 4困难电脑
								OnChangePosTypeRoomButton(force, idx, 0)
							end,
						})
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "ChangePosTypeButton" .. force .. "_" .. idx
					end
					]]
					
					--显示玩家配置的卡牌
					local configCardList = current_AllPlayerCfgList[udbid]
					if configCardList and (current_PlayerId == uid) then --我自己不用重取
						on_single_show_room_config_list_UI(room, configCardList, udbid)
					else
						if (udbid > 0) then
							--查询
							local cfgId = 9999
							local udbid = udbid
							local rid = rid
							SendPvpCmdFunc["get_battle_cfg"](cfgId, udbid, rid)
						end
					end
				end
			end
		end
		
		--装备图标1
		_frmNode.childUI["equipment1"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:UI_EQUIP",
			x = PVPROOM.OFFSET_X + OFFSETX + 285,
			y = PVPROOM.OFFSET_Y - OFFSETY+ 110,
			w = 70 * 1.2,
			h = 58 * 1.2,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "equipment1"
		
		--战图片文字2
		_frmNode.childUI["equipment2"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:FONT_ZHAN2",
			x = PVPROOM.OFFSET_X + OFFSETX + 285,
			y = PVPROOM.OFFSET_Y - OFFSETY + 110,
			w = 46 * 1.2,
			h = 46 * 1.2,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "equipment2"
		
		--绘制怪物的模型
		local typeId = 30030 --魔龙
		local tUnit = hVar.tab_unit[typeId]
		local unitModel = tUnit.model --模型
		local unitScale = tUnit.scale or 1.0 --缩放
		_frmNode.childUI["UnitModel"] = hUI.image:new({
			parent = _parentNode,
			model = unitModel,
			align = "MC",
			x = PVPROOM.OFFSET_X + OFFSETX + 440,
			y = PVPROOM.OFFSET_Y - OFFSETY + 45,
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
		--local effect = tUnit.effect or {} --特效列表
		local effect =
		{
			{94, 10, 30, 1.0, -1},
			--{461, 10, 70, 1.0, 1},
			{80, 10, 30, 1},
		}
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
					x = PVPROOM.OFFSET_X + OFFSETX + effX + 440,
					y = PVPROOM.OFFSET_Y - OFFSETY + effY + 45,
					z = effect[i][4] or -1,
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
		
		local bEnableBegin = true --是否可以开始
		local szDisableBeginReason = nil --不能开始的原因
		
		local bEnableConfig = true --是否可以配置
		local szDisableConfigReason = nil --不能配置的原因
		
		local readyNumTotal = 0 --准备的总人数
		local bAllPlayerReady = true --所有玩家都准备
		
		if (rm ~= current_PlayerId) then --非房主不能点开始按钮
			bEnableBegin = false --不能开始游戏
			--szDisableBeginReason = "只有房主才能开始游戏" --language
			szDisableBeginReason = hVar.tab_string["__TEXT_PVP_OnlyRoomCreaterCanBegin"] --language
			
			if (readyMe == 1) then
				bEnableConfig = false --不能配置
				--szDisableConfigReason = "您已准备，不能配置阵容" --language
				szDisableConfigReason = hVar.tab_string["__TEXT_PVP_ReadyStateNoConfig"] --language
			end
		else --房主
			--如果除了房主之外，所有的正常玩家都准备了，那么可以开始游戏
			for force, forceInfo in ipairs(pList) do
				local forcePlayerNum = 0 --势力的玩家数量
				
				for idx, tmpPInfo in ipairs(forceInfo) do
					local uid = tmpPInfo.uid --玩家id
					local name = tmpPInfo.name --玩家姓名
					local utype = tmpPInfo.utype --默认类型 0空 1玩家 2简单电脑 3中等电脑 4困难电脑
					local ready = tmpPInfo.ready --是否准备 0 未准备 1 准备
					local computerOnly = tmpPInfo.computerOnly --是否只允许电脑 0 否 1 是
					
					--不是空未知，人数加1
					if (utype ~= 0) then
						forcePlayerNum = forcePlayerNum + 1
					end
					
					if (utype == 1) and (ready == 0) then --有人未准备
						bAllPlayerReady = false --所有玩家都准备
						
						bEnableBegin = false --不能开始游戏
						--szDisableBeginReason = "所有玩家都已准备才能开始游戏" --language
						szDisableBeginReason = hVar.tab_string["__TEXT_PVP_AllPlayerReadyCanBegin"] --language
						break
					end
					
					if (utype == 1) and (ready == 1) then --有人准备了
						readyNumTotal = readyNumTotal + 1
					end
				end
				
				if (forcePlayerNum == 0) then --有一方没人
					bEnableBegin = false --不能开始游戏
					--szDisableBeginReason = "等待其它玩家加入" --language
					szDisableBeginReason = hVar.tab_string["__TEXT_PVP_WaitingOtherCanBegin"] --language
					break
				end
				
				if (not bEnableBegin) then
					break
				end
			end
			
			--房主永远都能配置阵容
			bEnableConfig = true
		end
		
		--继续检测
		if bEnableBegin then
			--至少2人才能开战
			local requireNumTotal = 2
			--if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
			if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
				--管理员可以单开
				requireNumTotal = 1
			end
			
			if (readyNumTotal < requireNumTotal) then
				bEnableBegin = false --不能开始游戏
				--szDisableBeginReason = "等待其它玩家加入" --language
				szDisableBeginReason = hVar.tab_string["__TEXT_PVP_WaitingOtherCanBegin"] --language
			end
		end
		
		--房主有个开始对战的按钮
		if (current_PlayerId == rm) then
			--开始游戏的按钮
			_frmNode.childUI["BeginGameButton"] = hUI.button:new({
				parent = _parentNode,
				dragbox = _frm.childUI["dragBox"],
				--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
				--x = PVPROOM.OFFSET_X + 745,
				--y = PVPROOM.OFFSET_Y - 520,
				x = _frm.data.w - 100,
				y = -_frm.data.h + 45,
				scale = 1.1,
				--label = "开始对战",
				--font = hVar.FONTC,
				--border = 1,
				model = "UI:BTN_ButtonRed",
				animation = "normal",
				scaleT = 0.95,
				code = function()
					--如果未连接，不能开始战斗
					if (Pvp_Server:GetState() ~= 1) then --未连接
						--local strText = "您已断开连接，请重新登入" --language
						local strText = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
						hUI.floatNumber:new({
							x = hVar.SCREEN.w / 2,
							y = hVar.SCREEN.h / 2,
							align = "MC",
							text = "",
							lifetime = 1000,
							fadeout = -550,
							moveY = 32,
						}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
						
						return
					end
					
					--如果未登入，不能开始战斗
					if (not hGlobal.LocalPlayer:getonline()) then --未登入
						--local strText = "您已断开连接，请重新登入" --language
						local strText = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
						hUI.floatNumber:new({
							x = hVar.SCREEN.w / 2,
							y = hVar.SCREEN.h / 2,
							align = "MC",
							text = "",
							lifetime = 1000,
							fadeout = -550,
							moveY = 32,
						}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
						
						return
					end
					
					--检测pvp的版本号
					if (not CheckPvpVersionControl()) then
						return
					end
					
					--检测pvp是否开放对战（活动300和301的控制）
					if (not CheckPvpBattleOpenState()) then
						return
					end
					
					if bEnableBegin then
						--点击房间开始游戏按钮
						OnBeginGameRoomButton_page2()
					else
						hUI.floatNumber:new({
							x = hVar.SCREEN.w / 2,
							y = hVar.SCREEN.h / 2,
							align = "MC",
							text = "",
							lifetime = 1000,
							fadeout = -550,
							moveY = 32,
						}):addtext(szDisableBeginReason,hVar.FONTC,40,"MC", 0,0)
					end
				end,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "BeginGameButton"
			if (not bEnableBegin) then
				hApi.AddShader(_frmNode.childUI["BeginGameButton"].handle.s, "gray") --灰色图片
			end
			
			--"开始对战"的文字
			_frmNode.childUI["BeginGameButton"].childUI["label"] = hUI.label:new({
				parent = _frmNode.childUI["BeginGameButton"].handle._n,
				x = 0,
				y = -2, --文字有2像素的偏差
				size = 28,
				--text = "开始对战", --language
				text = hVar.tab_string["__TEXT_PVP_BeginBattle"], --language
				align = "MC",
				font = hVar.FONTC,
				border = 1,
			})
			
			--管理员可以单开，所以加个管理员的星星标记
			if bAllPlayerReady then
				if (readyNumTotal == 1) then
					--if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
					if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
						if (g_is_account_test == 1) then --测试员
							--1颗星
							_frmNode.childUI["BeginGameButton"].childUI["star1"] = hUI.image:new({
								parent = _frmNode.childUI["btnDebug"].handle._n,
								x = 0,
								y = 42,
								model = "misc/weekstar.png",
								dragbox = _frm.childUI["dragBox"],
								w = 32,
								h = 32,
							})
						else
							--2颗星
							_frmNode.childUI["BeginGameButton"].childUI["star1"] = hUI.image:new({
								parent = _frmNode.childUI["BeginGameButton"].handle._n,
								x = -14,
								y = 42,
								model = "misc/weekstar.png",
								dragbox = _frm.childUI["dragBox"],
								w = 32,
								h = 32,
							})
							_frmNode.childUI["BeginGameButton"].childUI["star2"] = hUI.image:new({
								parent = _frmNode.childUI["BeginGameButton"].handle._n,
								x = 14,
								y = 42,
								model = "misc/weekstar.png",
								dragbox = _frm.childUI["dragBox"],
								w = 32,
								h = 32,
							})
						end
					end
				end
			end
		end
		
		--离开房间的按钮(铜雀台)
		_frmNode.childUI["LeaveRoomButton"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
			model = "BTN:PANEL_CLOSE",
			--x = PVPROOM.OFFSET_X + 92,
			--y = PVPROOM.OFFSET_Y - 520,
			x = 200,
			y = -_frm.data.h + 45,
			scale = 1.1,
			--label = "离开房间",
			--font = hVar.FONTC,
			--border = 1,
			model = "UI:BTN_ButtonRed",
			animation = "normal",
			scaleT = 0.95,
			code = function()
				--离开房间(铜雀台)
				OnLeaveRoomButton_page2()
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "LeaveRoomButton"
		
		--"离开房间"的文字
		_frmNode.childUI["LeaveRoomButton"].childUI["label"] = hUI.label:new({
			parent = _frmNode.childUI["LeaveRoomButton"].handle._n,
			x = 0,
			y = -2, --文字有2像素的偏差
			size = 28,
			--text = "离开房间", --language
			text = hVar.tab_string["__TEXT_PVP_Leave"] .. hVar.tab_string["__TEXT_PVP_Room"], --language
			align = "MC",
			font = hVar.FONTC,
			border = 1,
		})
		
		--[[
		--阵容配置的按钮（我的战斗里）
		_frmNode.childUI["BattleLeaveRoomButton"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
			model = "BTN:PANEL_CLOSE",
			--x = PVPROOM.OFFSET_X + 92,
			--y = PVPROOM.OFFSET_Y - 520,
			x = 370,
			y = -_frm.data.h + 45,
			scale = 1.1,
			--label = "阵容配置",
			--font = hVar.FONTC,
			--border = 1,
			model = "UI:BTN_ButtonRed",
			animation = "normal",
			scaleT = 0.95,
			code = function()
				if bEnableConfig then
					--点击房间阵容配置按钮
					OnModifyConfigButton_page2()
				else
					hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "",
						lifetime = 1000,
						fadeout = -550,
						moveY = 32,
					}):addtext(szDisableConfigReason, hVar.FONTC,40,"MC", 0,0)
				end
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "BattleLeaveRoomButton"
		if (not bEnableConfig) then
			hApi.AddShader(_frmNode.childUI["BattleLeaveRoomButton"].handle.s, "gray") --灰色图片
		end
		
		
		--"阵容配置"的文字（我的战斗里）
		_frmNode.childUI["BattleLeaveRoomButton"].childUI["label"] = hUI.label:new({
			parent = _frmNode.childUI["BattleLeaveRoomButton"].handle._n,
			x = 0,
			y = -2, --文字有2像素的偏差
			size = 28,
			--text = "阵容配置", --language
			text = hVar.tab_string["__TEXT_PVP_BattleConfig"], --language
			align = "MC",
			font = hVar.FONTC,
			border = 1,
		})
		]]
	end
	
	--函数：单独绘制房间的某位置玩家准备状态变化界面
	on_single_show_ready_state_UI = function(room)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local forceMe = 0 --我的势力
		local indexMe = 0 --我的索引位置
		local readyMe = 0 --我是否准备
		
		local rm = room.rm --房主uid
		local pList = room.pList --玩家列表
		local bUseEquip = room.bUseEquip --是否允许携带装备
		for force, forceInfo in ipairs(pList) do
			if (force == 1) then --铜雀台，只显示蜀国
				for idx, tmpPInfo in ipairs(forceInfo) do
					local pos = tmpPInfo.pos --用户位置
					local uid = tmpPInfo.uid --用户id
					local udbid = tmpPInfo.dbid --用户dbid
					local rid = tmpPInfo.rid --用户rid
					local name = tmpPInfo.name --玩家姓名
					local utype = tmpPInfo.utype --默认类型 0空 1玩家 2简单电脑 3中等电脑 4困难电脑
					local ready = tmpPInfo.ready --是否准备 0 未准备 1 准备
					
					--给自己加个箭头，标识自己在哪
					if (current_PlayerId == uid) then
						--我的势力
						forceMe = force
						indexMe = idx
						readyMe = ready
					end
					
					--非空玩家，绘制是否 房主/已准备/未准备 的文字
					if (utype ~= 0) then
						local szReady = nil
						local colorReady = nil
						if (ready == 0) then --未准备
							--szReady = "(未准备)" --language
							szReady = "(" .. hVar.tab_string["__TEXT_PVP_RoomNotReady"] .. ")" --language
							colorReady = ccc3(255, 0, 0)
						elseif (ready == 1) then --已准备
							--szReady = "(已准备)" --language
							szReady = "(" .. hVar.tab_string["__TEXT_PVP_RoomReady"] .. ")" --language
							colorReady = ccc3(0, 255, 0)
						end
						if (rm == uid) then --是房主
							--szReady = "(房主)" --language
							szReady = "(" .. hVar.tab_string["__TEXT_PVP_RoomCreater"] .. ")" --language
							colorReady = ccc3(255, 255, 0)
						end
						
						if _frmNode.childUI["RoomPlayerReady" .. force .. "_" .. idx] then
							_frmNode.childUI["RoomPlayerReady" .. force .. "_" .. idx]:setText(szReady)
							_frmNode.childUI["RoomPlayerReady" .. force .. "_" .. idx].handle.s:setColor(colorReady)
						end
					end
					
					--如果当前位置自己，那么有一个准备或者取消准备的按钮(房主不能准备)
					if (current_PlayerId == uid) and (rm ~= uid) then
						--删除上一个次的控件
						hApi.safeRemoveT(_frmNode.childUI, "ReadyButton" .. force .. "_" .. idx)
						
					--if (current_PlayerId == uid) then --测试 --test
						--准备或者取消准备的按钮
						local szReady = nil
						if (ready == 0) then --未准备
							--szReady = "准备" --language
							szReady = hVar.tab_string["__TEXT_PVP_Ready"] --language
						elseif (ready == 1) then --已准备
							--szReady = "取消准备" --language
							szReady = hVar.tab_string["__TEXT_Cancel"] .. hVar.tab_string["__TEXT_PVP_Ready"] --language
						end
						
						--准备或者取消准备的按钮
						_frmNode.childUI["ReadyButton" .. force .. "_" .. idx] = hUI.button:new({
							parent = _parentNode,
							dragbox = _frm.childUI["dragBox"],
							--x = PVPROOM.OFFSET_X + 745,
							--y = PVPROOM.OFFSET_Y - 520,
							x = _frm.data.w - 100,
							y = -_frm.data.h + 45,
							scale = 1.1,
							--label = "准备"/"取消准备",
							--font = hVar.FONTC,
							--border = 1,
							model = "UI:BTN_ButtonRed",
							animation = "normal",
							scaleT = 0.95,
							code = function()
								if (ready == 0) then --未准备
									--点击房间内准备按钮
									OnReadyRoomButton_page2()
								elseif (ready == 1) then --已准备
									--点击房间内取消准备按钮
									OnCancelReadyRoomButton_page2()
								end
							end,
						})
						--_frmNode.childUI["ReadyButton" .. force .. "_" .. idx].handle.s:setOpacity(0) --只响应事件，不显示
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "ReadyButton" .. force .. "_" .. idx
						
						--"准备"/"取消"的文字
						_frmNode.childUI["ReadyButton" .. force .. "_" .. idx].childUI["label"] = hUI.label:new({
							parent = _frmNode.childUI["ReadyButton" .. force .. "_" .. idx].handle._n,
							x = 0,
							y = -2, --文字有2像素的偏差
							size = 28,
							text = szReady,
							align = "MC",
							font = hVar.FONTC,
							border = 1,
						})
					end
				end
			end
		end
		
		local bEnableBegin = true --是否可以开始
		local szDisableBeginReason = nil --不能开始的原因
		
		local bEnableConfig = true --是否可以配置
		local szDisableConfigReason = nil --不能配置的原因
		
		local readyNumTotal = 0 --准备的总人数
		local bAllPlayerReady = true --所有玩家都准备
		
		if (rm ~= current_PlayerId) then --非房主不能点开始按钮
			bEnableBegin = false --不能开始游戏
			--szDisableBeginReason = "只有房主才能开始游戏" --language
			szDisableBeginReason = hVar.tab_string["__TEXT_PVP_OnlyRoomCreaterCanBegin"] --language
			
			if (readyMe == 1) then
				bEnableConfig = false --不能配置
				--szDisableConfigReason = "您已准备，不能配置阵容" --language
				szDisableConfigReason = hVar.tab_string["__TEXT_PVP_ReadyStateNoConfig"] --language
			end
		else --房主
			--如果除了房主之外，所有的正常玩家都准备了，那么可以开始游戏
			for force, forceInfo in ipairs(pList) do
				local forcePlayerNum = 0 --势力的玩家数量
				
				for idx, tmpPInfo in ipairs(forceInfo) do
					local uid = tmpPInfo.uid --玩家id
					local name = tmpPInfo.name --玩家姓名
					local utype = tmpPInfo.utype --默认类型 0空 1玩家 2简单电脑 3中等电脑 4困难电脑
					local ready = tmpPInfo.ready --是否准备 0 未准备 1 准备
					local computerOnly = tmpPInfo.computerOnly --是否只允许电脑 0 否 1 是
					
					--不是空未知，人数加1
					if (utype ~= 0) then
						forcePlayerNum = forcePlayerNum + 1
					end
					
					if (utype == 1) and (ready == 0) then --有人未准备
						bAllPlayerReady = false --所有玩家都准备
						
						bEnableBegin = false --不能开始游戏
						--szDisableBeginReason = "所有玩家都已准备才能开始游戏" --language
						szDisableBeginReason = hVar.tab_string["__TEXT_PVP_AllPlayerReadyCanBegin"] --language
						break
					end
					
					if (utype == 1) and (ready == 1) then --有人准备了
						readyNumTotal = readyNumTotal + 1
					end
				end
				
				if (forcePlayerNum == 0) then --有一方没人
					bEnableBegin = false --不能开始游戏
					--szDisableBeginReason = "等待其它玩家加入" --language
					szDisableBeginReason = hVar.tab_string["__TEXT_PVP_WaitingOtherCanBegin"] --language
					break
				end
				
				if (not bEnableBegin) then
					break
				end
			end
			
			--房主永远都能配置阵容
			bEnableConfig = true
		end
		
		--继续检测
		if bEnableBegin then
			--至少2人才能开战
			local requireNumTotal = 2
			--if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
			if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
				--管理员可以单开
				requireNumTotal = 1
			end
			
			if (readyNumTotal < requireNumTotal) then
				bEnableBegin = false --不能开始游戏
				--szDisableBeginReason = "等待其它玩家加入" --language
				szDisableBeginReason = hVar.tab_string["__TEXT_PVP_WaitingOtherCanBegin"] --language
			end
		end
		
		--房主开始对战的按钮的状态变化
		if (current_PlayerId == rm) then
			--删除上一次的控件
			hApi.safeRemoveT(_frmNode.childUI, "BeginGameButton")
			
			--开始游戏的按钮
			_frmNode.childUI["BeginGameButton"] = hUI.button:new({
				parent = _parentNode,
				dragbox = _frm.childUI["dragBox"],
				--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
				--x = PVPROOM.OFFSET_X + 745,
				--y = PVPROOM.OFFSET_Y - 520,
				x = _frm.data.w - 100,
				y = -_frm.data.h + 45,
				scale = 1.1,
				--label = "开始对战",
				--font = hVar.FONTC,
				--border = 1,
				model = "UI:BTN_ButtonRed",
				animation = "normal",
				scaleT = 0.95,
				code = function()
					--如果未连接，不能开始战斗
					if (Pvp_Server:GetState() ~= 1) then --未连接
						--local strText = "您已断开连接，请重新登入" --language
						local strText = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
						hUI.floatNumber:new({
							x = hVar.SCREEN.w / 2,
							y = hVar.SCREEN.h / 2,
							align = "MC",
							text = "",
							lifetime = 1000,
							fadeout = -550,
							moveY = 32,
						}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
						
						return
					end
					
					--如果未登入，不能开始战斗
					if (not hGlobal.LocalPlayer:getonline()) then --未登入
						--local strText = "您已断开连接，请重新登入" --language
						local strText = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
						hUI.floatNumber:new({
							x = hVar.SCREEN.w / 2,
							y = hVar.SCREEN.h / 2,
							align = "MC",
							text = "",
							lifetime = 1000,
							fadeout = -550,
							moveY = 32,
						}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
						
						return
					end
					
					--检测pvp的版本号
					if (not CheckPvpVersionControl()) then
						return
					end
					
					--检测pvp是否开放对战（活动300和301的控制）
					if (not CheckPvpBattleOpenState()) then
						return
					end
					
					if bEnableBegin then
						--点击房间开始游戏按钮
						OnBeginGameRoomButton_page2()
					else
						hUI.floatNumber:new({
							x = hVar.SCREEN.w / 2,
							y = hVar.SCREEN.h / 2,
							align = "MC",
							text = "",
							lifetime = 1000,
							fadeout = -550,
							moveY = 32,
						}):addtext(szDisableBeginReason,hVar.FONTC,40,"MC", 0,0)
					end
				end,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "BeginGameButton"
			if (not bEnableBegin) then
				hApi.AddShader(_frmNode.childUI["BeginGameButton"].handle.s, "gray") --灰色图片
			end
			
			--"开始对战"的文字
			_frmNode.childUI["BeginGameButton"].childUI["label"] = hUI.label:new({
				parent = _frmNode.childUI["BeginGameButton"].handle._n,
				x = 0,
				y = -2, --文字有2像素的偏差
				size = 28,
				--text = "开始对战", --language
				text = hVar.tab_string["__TEXT_PVP_BeginBattle"], --language
				align = "MC",
				font = hVar.FONTC,
				border = 1,
			})
			
			--管理员可以单开，所以加个管理员的星星标记
			if bAllPlayerReady then
				if (readyNumTotal == 1) then
					--if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
					if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
						if (g_is_account_test == 1) then --测试员
							--1颗星
							_frmNode.childUI["BeginGameButton"].childUI["star1"] = hUI.image:new({
								parent = _frmNode.childUI["btnDebug"].handle._n,
								x = 0,
								y = 42,
								model = "misc/weekstar.png",
								dragbox = _frm.childUI["dragBox"],
								w = 32,
								h = 32,
							})
						else
							--2颗星
							_frmNode.childUI["BeginGameButton"].childUI["star1"] = hUI.image:new({
								parent = _frmNode.childUI["BeginGameButton"].handle._n,
								x = -14,
								y = 42,
								model = "misc/weekstar.png",
								dragbox = _frm.childUI["dragBox"],
								w = 32,
								h = 32,
							})
							_frmNode.childUI["BeginGameButton"].childUI["star2"] = hUI.image:new({
								parent = _frmNode.childUI["BeginGameButton"].handle._n,
								x = 14,
								y = 42,
								model = "misc/weekstar.png",
								dragbox = _frm.childUI["dragBox"],
								w = 32,
								h = 32,
							})
						end
					end
				end
			end
		end
	end
	
	--函数：单独绘制房间的某位置配置卡牌信息界面
	on_single_show_room_config_list_UI = function(room, configCardList, udbid)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local OFFSETX = 330
		local OFFSETY = 480
		local DISTACEX = 400
		local DISTACEY = 230
		
		local pList = room.pList --玩家列表
		local bUseEquip = room.bUseEquip --是否允许携带装备
		local index = 0
		local username = nil --玩家名
		for force, forceInfo in ipairs(pList) do
			if (force == 1) then --铜雀台，只显示蜀国
				for idx, tmpPInfo in ipairs(forceInfo) do
					local udbidi = tmpPInfo.dbid --用户dbid
					if (udbidi == udbid) then --找到了
						index = idx
						username = tmpPInfo.name
						break
					end
				end
			end
		end
		
		--不在房间里
		if (index == 0) then
			return
		end
		
		--先删除上一次的该玩家的卡牌配置
		hApi.safeRemoveT(_frmNode.childUI, "MyConfig_Label_" .. index) --"我的阵容"的文字
		for i = 1, SELECT_NUM_MAX.TOWER, 1 do
			hApi.safeRemoveT(_frmNode.childUI, "ConfigTowerCard" .. i .. "_" .. index) --配置的塔
		end
		for i = 1, SELECT_NUM_MAX.ARMY_ATK, 1 do
			hApi.safeRemoveT(_frmNode.childUI, "ConfigArmyCard_Atk" .. i .. "_" .. index) --配置的进攻兵种
		end
		for i = 1, SELECT_NUM_MAX.ARMY_DEF, 1 do
			hApi.safeRemoveT(_frmNode.childUI, "ConfigArmyCard_Def" .. i .. "_" .. index) --配置的防守兵种
		end
		for i = 1, SELECT_NUM_MAX.HERO, 1 do
			hApi.safeRemoveT(_frmNode.childUI, "ConfigHeroCard" .. i .. "_" .. index) --配置的英雄
			for eq = 1, 4, 1 do
				hApi.safeRemoveT(_frmNode.childUI, "ConfigHeroCard" .. i .. "_equipBG" .. eq .. "_" .. index) --英雄装备
			end
		end
		hApi.safeRemoveT(_frmNode.childUI, "ConfigCardNoTower" .. "_" .. index) --还未配置塔
		hApi.safeRemoveT(_frmNode.childUI, "ConfigCardNoHero" .. "_" .. index) --还未配置英雄
		--显示配置的卡牌
		if configCardList then
			local herocard = configCardList.herocard
			local towercard = configCardList.towercard
			local tacticcard = configCardList.tacticcard
			local bConfigedTower = false --是否配置了塔
			local bConfigedHero = false --是否配置了英雄
			local bConfigeArmy_atk = false --是否配置了进攻兵种
			local bConfigeArmy_def = false --是否配置了防守兵种
			local indexHero = 0
			local indexCard = 0
			local indexArmy_atk = 0
			local indexArmy_def = 0
			
			--[[
			--分界线-标题
			_frmNode.childUI["SeparateLine_Title"] = hUI.image:new({
				parent = _parentNode,
				model = "UI:Tactic_SeparateLine",
				x = PVPROOM.OFFSET_X + OFFSETX + (index - 1) * DISTACEX + 114,
				y = PVPROOM.OFFSET_Y - OFFSETY - 70,
				w = 280,
				h = 4,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "SeparateLine_Title"
			]]
			
			--"我的阵容"或"队友阵容"的文字
			local xn = math.floor((index - 1) / 2) + 1
			local yn = ((index - 1) % 2)
			
			local cfgTitle = nil
			local cfgColor = nil
			if (udbid == xlPlayer_GetUID()) then --我
				--cfgTitle = "我的阵容" --language
				cfgTitle = hVar.tab_string["__TEXT_PVP_MyConfig"] --language
				cfgColor = ccc3(64, 255, 64)
			else
				--cfgTitle = "队友阵容" --language
				cfgTitle = hVar.tab_string["__TEXT_PVP_AllyConfig"] --language
				cfgColor = ccc3(255, 255, 128)
			end
			
			--"我的阵容"或"队友阵容"文字
			_frmNode.childUI["MyConfig_Label_" .. index] = hUI.label:new({
				parent = _parentNode,
				x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX - 180 + 18,
				y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY + 60 - 92,
				size = 26,
				text = cfgTitle,
				align = "MC",
				font = hVar.FONTC,
				border = 1,
				width = 26,
			})
			_frmNode.childUI["MyConfig_Label_" .. index].handle.s:setColor(cfgColor)
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "MyConfig_Label_" .. index
			
			--塔
			if towercard then
				--towercard[1] = nil --test
				--towercard[2] = nil --test
				--towercard[3] = nil --test
				--towercard[4] = nil --test
				for i = 1, #towercard, 1 do
					bConfigedTower = true --配置了
					indexCard = indexCard + 1
					
					--配置的塔卡
					local towerId = towercard[i][1]
					local towerLv = towercard[i][2]
					local WIDTH = 52
					_frmNode.childUI["ConfigTowerCard" .. i .. "_" .. index] = hUI.button:new({
						parent = _parentNode,
						model = hVar.tab_tactics[towerId].icon,
						x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX - 180 + 329,
						y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY + 60 - (indexCard - 1) * (WIDTH + 8)- 45,
						w = WIDTH,
						h = WIDTH,
						dragbox = _frm.childUI["dragBox"],
						scaleT = 0.95,
						code = function()
							--显示塔tip
							local rewardType = 2
							hApi.ShowTacticCardTip(rewardType, towerId, towerLv)
						end,
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "ConfigTowerCard" .. i .. "_" .. index
					
					--塔等级背景图
					_frmNode.childUI["ConfigTowerCard" .. i .. "_" .. index].childUI["LvBG"]= hUI.image:new({
						parent = _frmNode.childUI["ConfigTowerCard" .. i .. "_" .. index].handle._n,
						model = "ui/pvp/pvpselect.png",
						x = WIDTH - 28,
						y = 18,
						w = 34,
						h = 34,
					})
					
					--塔等级
					local fontSize = 24
					if towerLv and (towerLv >= 10) then --如果等级是2位数的，那么缩一下文字
						fontSize = 16
					end
					_frmNode.childUI["ConfigTowerCard" .. i .. "_" .. index].childUI["Lv"] = hUI.label:new({
						parent = _frmNode.childUI["ConfigTowerCard" .. i .. "_" .. index].handle._n,
						x = WIDTH - 28,
						y = 18 - 1,
						text = towerLv,
						size = fontSize,
						font = "numWhite",
						align = "MC",
						width = 200,
					})
				end
			end
			
			--进攻兵种
			--local armycard_atk = {{1301, 1}, {1302, 1}, {1303, 1}, {1304, 1}, {1305, 1}}
			local armycard_atk = {}
			if tacticcard then
				for i = 1, #tacticcard, 1 do
					for j = 1, #hVar.tab_tacticsArmyEx_Atk, 1 do
						if (tacticcard[i][1] == hVar.tab_tacticsArmyEx_Atk[j]) then
							armycard_atk[#armycard_atk+1] = tacticcard[i]
							break
						end
					end
				end
			end
			for i = 1, #armycard_atk, 1 do
				bConfigeArmy_atk = true --配置了
				indexArmy_atk = indexArmy_atk + 1
				
				--配置的战术技能卡
				local tacticId = armycard_atk[i][1]
				local tacticLv = armycard_atk[i][2]
				
				local WIDTH = 40
				_frmNode.childUI["ConfigArmyCard_Atk" .. i .. "_" .. index] = hUI.button:new({
					parent = _parentNode,
					model = hVar.tab_tactics[tacticId].icon,
					x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX - 180 + 215 + (indexArmy_atk - 1) * (WIDTH + 6) - 32,
					y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY + 60 - 90,
					w = WIDTH,
					h = WIDTH,
					dragbox = _frm.childUI["dragBox"],
					scaleT = 0.95,
					code = function()
						--显示PVP进攻兵种tip
						hApi.ShowTacticCardTip_PVP(tacticId, tacticLv)
					end,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "ConfigArmyCard_Atk" .. i .. "_" .. index
			end
			
			--防守兵种
			--local armycard_def = {{1301, 1}, {1302, 1}, {1303, 1}, {1304, 1}, {1305, 1}}
			local armycard_def = {}
			if tacticcard then
				for i = 1, #tacticcard, 1 do
					for j = 1, #hVar.tab_tacticsArmyEx_Def, 1 do
						if (tacticcard[i][1] == hVar.tab_tacticsArmyEx_Def[j]) then
							armycard_def[#armycard_def+1] = tacticcard[i]
							break
						end
					end
				end
			end
			for i = 1, #armycard_def, 1 do
				bConfigeArmy_def = true --配置了
				indexArmy_def = indexArmy_def + 1
				
				--配置的战术技能卡
				local tacticId = armycard_def[i][1]
				local tacticLv = armycard_def[i][2]
				
				local WIDTH = 40
				_frmNode.childUI["ConfigArmyCard_Def" .. i .. "_" .. index] = hUI.button:new({
					parent = _parentNode,
					model = hVar.tab_tactics[tacticId].icon,
					x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX - 180 + 215 + (indexArmy_def - 1) * (WIDTH + 6) - 32,
					y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY + 60 - 135,
					w = WIDTH,
					h = WIDTH,
					dragbox = _frm.childUI["dragBox"],
					scaleT = 0.95,
					code = function()
						--显示PVP防守兵种卡tip
						hApi.ShowTacticCardTip_PVP(tacticId, tacticLv)
					end,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "ConfigArmyCard_Def" .. i .. "_" .. index
			end
			
			--英雄
			if herocard then
				--herocard[1] = nil --test
				--herocard[2] = nil --test
				for i = 1, #herocard, 1 do
					bConfigedHero = true --配置了
					indexHero = indexHero + 1
					
					--配置的英雄卡牌
					local heroId = herocard[i].id
					local heroLv = herocard[i].attr.level
					local heroStar = herocard[i].attr.star
					local heroEquipment = herocard[i].equipment
					
					local WIDTH = 80
					--英雄头像按钮
					local hero_x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX - 180 + 95 + (indexHero - 1) * (125 + 8)
					local hero_y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY + 60 - 95
					_frmNode.childUI["ConfigHeroCard" .. i .. "_" .. index] = hUI.button:new({ --作为按钮是为了挂载子控件
						parent = _parentNode,
						model = "UI:MedalDarkImg", --"UI:lvUpBg", --"misc/masc.png",
						x = hero_x,
						y = hero_y + 18,
						w = 112 + 2,
						h = 112 + 4,
						dragbox = _frm.childUI["dragBox"],
						scaleT = 0.95,
						code = function()
							--[[
							--显示英雄tip
							local herotipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
							local herotipY = 600 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
							local pvp_heroId = heroId + 100
							hGlobal.event:event("LocalEvent_HeroCardInfo", pvp_heroId)
							]]
							--显示英雄属性tip(简版)
							hApi.ShowHeroInfoTip_Short(heroId, heroLv, heroStar, heroEquipment, username)
						end,
					})
					--_frmNode.childUI["ConfigHeroCard" .. i].handle.s:setOpacity(0)
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "ConfigHeroCard" .. i .. "_" .. index
					
					--[[
					--英雄头像背景图1（九宫格）
					local img91 = CCScale9Sprite:createWithSpriteFrameName("data/image/ui/kuang.png")
					img91:setPosition(ccp(0, 0))
					img91:setContentSize(CCSizeMake(120, 120))
					_frmNode.childUI["ConfigHeroCard" .. i].handle._n:addChild(img91)
					]]
					
					--英雄头像背景图2（九宫格）
					local img92 = CCScale9Sprite:createWithSpriteFrameName("data/image/ui/login_lk.png")
					img92:setPosition(ccp(0, 1))
					img92:setContentSize(CCSizeMake(108, 108))
					_frmNode.childUI["ConfigHeroCard" .. i .. "_" .. index].handle._n:addChild(img92)
					
					--英雄头像图片
					_frmNode.childUI["ConfigHeroCard" .. i .. "_" .. index].childUI["heroIcon"] = hUI.image:new({
						parent = _frmNode.childUI["ConfigHeroCard" .. i .. "_" .. index].handle._n,
						model = hVar.tab_unit[heroId].portrait,
						x = 0,
						y = 0,
						w = 108,
						h = 108,
					})
					hUI.SYSAutoReleaseUI:addModel("portrait", hVar.tab_unit[heroId].portrait) --待回收
					
					--英雄等级背景图
					_frmNode.childUI["ConfigHeroCard" .. i .. "_" .. index].childUI["LvBG"]= hUI.image:new({
						parent = _frmNode.childUI["ConfigHeroCard" .. i .. "_" .. index].handle._n,
						model = "ui/pvp/pvpselect.png",
						x = 108 - 52,
						y = 0 + 48,
						w = 34,
						h = 34,
					})
					
					--英雄等级
					local fontSize = 24
					if heroLv and (heroLv >= 10) then --如果等级是2位数的，那么缩一下文字
						fontSize = 16
					end
					_frmNode.childUI["ConfigHeroCard" .. i .. "_" .. index].childUI["Lv"] = hUI.label:new({
						parent = _frmNode.childUI["ConfigHeroCard" .. i .. "_" .. index].handle._n,
						x = 108 - 52,
						y = 0 + 48 - 1,
						text = heroLv,
						size = fontSize,
						font = "numWhite",
						align = "MC",
						width = 200,
					})
					
					--英雄星级
					for star = 1, heroStar, 1 do
						_frmNode.childUI["ConfigHeroCard" .. i .. "_" .. index].childUI["Star" .. star]= hUI.image:new({
							parent = _frmNode.childUI["ConfigHeroCard" .. i .. "_" .. index].handle._n,
							model = "UI:STAR_YELLOW",
							x = 108 - 68 - (star - 1) * (28 + 2),
							y = 0 - 40,
							w = 28,
							h = 28,
						})
					end
					
					--[[
					--英雄名
					_frmNode.childUI["ConfigHeroCard" .. i .. "_" .. index].childUI["name"] = hUI.label:new({
						parent = _frmNode.childUI["ConfigHeroCard" .. i .. "_" .. index].handle._n,
						model = hVar.tab_unit[heroId].portrait,
						x = 0,
						y = -86,
						width = 200,
						align = "MC",
						border = 1,
						text = hVar.tab_stringU[heroId] and hVar.tab_stringU[heroId][1] or ("未知英雄" .. heroId),
						font = hVar.FONTC,
						size = 20,
					})
					hUI.SYSAutoReleaseUI:addModel("portrait", hVar.tab_unit[heroId].portrait) --待回收
					]]
					
					--携带装备模式，绘制装备
					if bUseEquip then
						--英雄装备的图标
						local equipment = herocard[i].equipment or {}
						local equiptype = {1, 2, 4, 3}
						for eq = 1, 4, 1 do
							local itemId = 0
							local idx = equiptype[eq]
							local equp = equipment[idx]
							if (type(equp) == "table") then
								itemId = equp[1]
							end
							
							local eq_wh = 27
							local eq_px = eq * (eq_wh + 3) - 74
							local eq_py = -73
							
							--存在道具
							if hVar.tab_item[itemId] then
								--绘制道具背景图
								local itemLv = hVar.tab_item[itemId].itemLv or 1
								local itemtModel = hVar.ITEMLEVEL[itemLv].BORDERMODEL
								_frmNode.childUI["ConfigHeroCard" .. i .. "_equipBG" .. eq .. "_" .. index] = hUI.button:new({
									parent = _parentNode,
									model = itemtModel, --"UI:SkillSlot",
									x = hero_x + eq_px,
									y = hero_y + 18 + eq_py,
									w = eq_wh,
									h = eq_wh,
									scaleT = 0.95,
									dragbox = _frm.childUI["dragBox"],
									code = function()
										--显示道具tip
										local itemtipX = 400 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
										--local itemtipY = 660 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
										hGlobal.event:event("LocalEvent_ShowItemTipFram", {equp}, nil, 1, itemtipX, nil, 0)
									end,
								})
								rightRemoveFrmList[#rightRemoveFrmList + 1] = "ConfigHeroCard" .. i .. "_equipBG" .. eq .. "_" .. index
								
								--绘制道具图标
								_frmNode.childUI["ConfigHeroCard" .. i .. "_equipBG" .. eq .. "_" .. index].childUI["equip" .. eq] = hUI.image:new({
									parent = _frmNode.childUI["ConfigHeroCard" .. i .. "_equipBG" .. eq .. "_" .. index].handle._n,
									model = hVar.tab_item[itemId].icon,
									x = 0,
									y = 0,
									w = eq_wh - 2,
									h = eq_wh - 2,
								})
								
								--如果配置不能携带装备，道具不显示
								if (not bUseEquip) then
									_frmNode.childUI["ConfigHeroCard" .. i .. "_equipBG" .. eq .. "_" .. index]:setstate(0)
								end
							else
								--不存在道具，画个空板子
								_frmNode.childUI["ConfigHeroCard" .. i .. "_equipBG" .. eq .. "_" .. index] = hUI.button:new({
									parent = _parentNode,
									model = "misc/photo_frame.png",
									x = hero_x + eq_px,
									y = hero_y + 18 + eq_py,
									w = eq_wh,
									h = eq_wh,
								})
								--hApi.AddShader(_frmNode.childUI["ConfigHeroCard" .. i .. "_equipBG" .. eq .. "_" .. index].handle.s, "gray") --灰色图片
								rightRemoveFrmList[#rightRemoveFrmList + 1] = "ConfigHeroCard" .. i .. "_equipBG" .. eq .. "_" .. index
							end
						end
					end
				end
			end
			
			--[[
			--我的卡牌文字
			_frmNode.childUI["ConfigCardText"] = hUI.label:new({
				parent = _parentNode,
				x = PVPROOM.OFFSET_X + OFFSETX + (index - 1) * DISTACEX + 118,
				y = PVPROOM.OFFSET_Y - 390,
				size = 24,
				font = hVar.FONTC,
				align = "MC",
				width = 500,
				border = 1,
				text = "我的卡牌:",
			})
			_frmNode.childUI["ConfigCardText"].handle.s:setColor(ccc3(255, 212, 196))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "ConfigCardText"
			]]
			
			--未配置塔显示"您还未配置塔"
			if (not bConfigedTower) then
				_frmNode.childUI["ConfigCardNoTower" .. "_" .. index] = hUI.label:new({
					parent = _parentNode,
					x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX - 180 + 165,
					y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY + 60 - 45 - 1, --文字有1像素的偏差
					size = 22,
					font = hVar.FONTC,
					align = "LC",
					width = 500,
					border = 1,
					--text = "您还未配置塔", --language
					text = hVar.tab_string["__TEXT_PVP_NotYetConfig"] .. hVar.tab_string["__TEXT_SOLDIER_TOWER"], --language
				})
				_frmNode.childUI["ConfigCardNoTower" .. "_" .. index].handle.s:setColor(ccc3(255, 0, 0))
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "ConfigCardNoTower" .. "_" .. index
			end
			
			--[[
			--未配置进攻兵种显示"您还未配置进攻兵种"
			if (not bConfigeArmy_atk) then
				_frmNode.childUI["ConfigCardNoArmy_Atk"] = hUI.label:new({
					parent = _parentNode,
					x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX - 180 + 165,
					y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY + 60 - 90 - 1, --文字有1像素的偏差
					size = 22,
					font = hVar.FONTC,
					align = "LC",
					width = 500,
					border = 1,
					--text = "您还未配置进攻兵种", --language
					text = hVar.tab_string["__TEXT_PVP_NotYetConfig"] .. hVar.tab_string["__TEXT_PVP_Atk"] .. hVar.tab_string["ArmyCardPage"], --language
				})
				_frmNode.childUI["ConfigCardNoArmy_Atk"].handle.s:setColor(ccc3(255, 0, 0))
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "ConfigCardNoArmy_Atk"
			end
			]]
			
			--[[
			--未配置防守兵种显示"您还未配置防守兵种"
			if (not bConfigeArmy_def) then
				_frmNode.childUI["ConfigCardNoArmy_Def"] = hUI.label:new({
					parent = _parentNode,
					x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX - 180 + 165,
					y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY + 60 - 135 - 1, --文字有1像素的偏差
					size = 22,
					font = hVar.FONTC,
					align = "LC",
					width = 500,
					border = 1,
					--text = "您还未配置防守兵种", --language
					text = hVar.tab_string["__TEXT_PVP_NotYetConfig"] .. hVar.tab_string["__TEXT_PVP_Def"] .. hVar.tab_string["ArmyCardPage"], --language
				})
				_frmNode.childUI["ConfigCardNoArmy_Def"].handle.s:setColor(ccc3(255, 0, 0))
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "ConfigCardNoArmy_Def"
			end
			]]
			
			--未配置英雄显示"您还未配置英雄"
			if (not bConfigedHero) then
				_frmNode.childUI["ConfigCardNoHero" .. "_" .. index] = hUI.label:new({
					parent = _parentNode,
					x = PVPROOM.OFFSET_X + OFFSETX + (xn - 1) * DISTACEX - 180 + 98,
					y = PVPROOM.OFFSET_Y - OFFSETY - (yn - 1) * DISTACEY + 60 - 90 - 1, --文字有1像素的偏差
					size = 22,
					font = hVar.FONTC,
					align = "MC",
					width = 88,
					border = 1,
					--text = "您还未配置英雄", --language
					text = hVar.tab_string["__TEXT_PVP_NotYetConfig"] .. hVar.tab_string["hero"], --language
				})
				_frmNode.childUI["ConfigCardNoHero"].handle.s:setColor(ccc3(255, 0, 0))
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "ConfigCardNoHero" .. "_" .. index
			end
		end
	end
	
	--函数：收到离开房间事件(铜雀台)
	on_receive_LeaveRoom_event_page2 = function(roomId)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--标记本地所在的房间id为0
		current_Room_page2 = nil
		current_RoomId_page2 = 0
		
		--修改文字：重新获取房间信息
		_frmNode.childUI["waitingSmall"].handle.s:setVisible(true)
		if _frmNode.childUI["WaitingImg"] then
			_frmNode.childUI["WaitingImg"].handle.s:setVisible(true)
		end
		if _frmNode.childUI["StateLabel"] then
			--_frmNode.childUI["StateLabel"]:setText("正在获取房间列表...") --language
			_frmNode.childUI["StateLabel"]:setText(hVar.tab_string["__TEXT_GettingRoomLists"]) --language
		end
		
		--重新发起查询，所有的房间id列表
		--大于时间间隔
		local currenttime = hApi.gametime() --当前时间
		local deltatime = currenttime - last_room_query_time_page2 --时间差
		if (deltatime >= (QUERY_ROOM_DELTA_SECOND_PAGE2 * 1000 - 100)) then
			--标记timer
			last_room_query_time_page2 = currenttime
			
			--发起查询前清空数据
			--current_RoomAbstractList_page2 = {} --大厅房间摘要列表
			--current_Room_max_num_page2 = 0 --最大的PVP房间id
			
			--发起查询房间id列表(铜雀台)
			--local cfgId = 2
			local cfgId = 9999
			SendPvpCmdFunc["get_roomlist"](cfgId)
			--print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx发起查询房间id列表 -LeaveRoom")
		else
			--用上次的数据，直接触发回调
			on_receive_RoomAbstract_event_page2(current_RoomAbstractList_page2)
		end
	end
	
	--函数：加入房间失败事件回调(铜雀台)
	on_receive_EnterRoom_Fail_event_page2 = function()
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--修改文字：重新获取房间信息
		_frmNode.childUI["waitingSmall"].handle.s:setVisible(true)
		if _frmNode.childUI["WaitingImg"] then
			_frmNode.childUI["WaitingImg"].handle.s:setVisible(true)
		end
		if _frmNode.childUI["StateLabel"] then
			_frmNode.childUI["StateLabel"]:setText("重新获取房间id...")
		end
		
		--隐藏所有的选中框
		for i = 1, #current_RoomAbstractList_page2, 1 do
			local listI = current_RoomAbstractList_page2[i] --第i项
			if (listI) then --存在PVP房间信息第i项表
				local ctrli = _frmNode.childUI["PvpRoomNode" .. i]
				if ctrli then
					--ctrli.childUI["selectbox"].handle.s:setVisible(false)
					ctrli.childUI["selectbox"]:setstate(-1)
				end
			end
		end
		
		--geyachao: 改为只要进入失败了都查询
		--标记timer
		local currenttime = hApi.gametime() --当前时间
		last_room_query_time_page2 = currenttime
		
		--发起查询前清空数据
		--current_RoomAbstractList_page2 = {} --大厅房间摘要列表
		--current_Room_max_num_page2 = 0 --最大的PVP房间id
		
		--发起查询房间id列表(铜雀台)
		--local cfgId = 2
		local cfgId = 9999
		SendPvpCmdFunc["get_roomlist"](cfgId)
		--print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx发起查询房间id列表 -EnterRoom_Fail")
		
		--[[
		--重新发起查询，所有的房间id列表
		--大于时间间隔
		local currenttime = hApi.gametime() --当前时间
		local deltatime = currenttime - last_room_query_time_page2 --时间差
		if (deltatime >= (QUERY_ROOM_DELTA_SECOND_PAGE2 * 1000 - 100)) then
			--标记timer
			last_room_query_time_page2 = currenttime
			
			--发起查询前清空数据
			--current_RoomAbstractList_page2 = {} --大厅房间摘要列表
			--current_Room_max_num_page2 = 0 --最大的PVP房间id
			
			--发起查询房间id列表(铜雀台)
			SendPvpCmdFunc["get_roomlist"](2)
			--print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx发起查询房间id列表 -EnterRoom_Fail")
		else
			--用上次的数据，直接触发回调
			--on_receive_RoomAbstract_event_page2(current_RoomAbstractList_page2)
			
			--不处理
			--隐藏菊花和提示信息
			_frmNode.childUI["waitingSmall"].handle.s:setVisible(false)
			if _frmNode.childUI["WaitingImg"] then
				_frmNode.childUI["WaitingImg"].handle.s:setVisible(false)
			end
			if _frmNode.childUI["StateLabel"] then
				_frmNode.childUI["StateLabel"]:setText("")
			end
		end
		]]
	end
	
	--函数：创建房间操作(铜雀台)
	OnCreateRoomButton_page2 = function()
		--如果未连接，不能创建房间
		if (Pvp_Server:GetState() ~= 1) then --未连接
			--local strText = "您已断开连接，请重新登入" --language
			local strText = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--如果未登入，不能创建房间
		if (not hGlobal.LocalPlayer:getonline()) then --未登入
			--local strText = "您已断开连接，请重新登入" --language
			local strText = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--检测pvp的版本号
		if (not CheckPvpVersionControl()) then
			return
		end
		
		--检测pvp是否达到逃跑最大次数限制
		if (not CheckPvpEscapeMaxCount()) then
			return
		end
		
		--检测pvp是否在逃跑惩罚中
		if (not CheckPvpEscapePunish()) then
			return
		end
		
		--检测pvp是否在投降惩罚中
		if (not CheckPvpSurrenderPunish()) then
			return
		end
		
		--检测pvp是否开放对战（活动300和301的控制）
		if (not CheckPvpBattleOpenState()) then
			return
		end
		
		--检测pvp配卡是否完整
		if (not CheckPvpCfgCardOK()) then
			return
		end
		
		--检测pvp兵符是否足够
		if (not CheckPvpCoinOK()) then
			return
		end
		
		--检测玩家是否作弊
		if (not CheckCheatOK()) then
			return
		end
		
		--挡操作
		hUI.NetDisable(30000)
		
		--房间名
		--去掉GM的字样
		local myName = g_curPlayerName
		while (string.find(myName, "GM") ~= nil) do
			local pos = string.find(myName, "GM")
			myName = string.sub(myName, pos + 2, #myName)
		end
		--local roomName = "玩家" .. xlPlayer_GetUID() .. "的房间"
		--local roomName = myName .. "的房间" --language
		local roomName = myName .. hVar.tab_string["__TEXT_PVP_SROOM"] --language
		
		--[[
		local onclickevent = nil
		local MsgSelections = nil
		MsgSelections = {
			style = "mini",
			select = 0,
			ok = function()
				onclickevent(2)
			end,
			cancel = function()
				onclickevent(1)
			end,
			--cancelFun = cancelCallback, --点否的回调函数
			textOk = "铜雀台",
			textCancel = "夺塔奇兵",
			userflag = 0, --用户的标记
		}
		local showTitle = "请选择您要对战的地图："
		local msgBox = hGlobal.UI.MsgBox(showTitle, MsgSelections)
		msgBox:active()
		msgBox:show(1,"fade",{time=0.08})
		
		hUI.NetDisable(0)
		onclickevent = function(roomType)
			hUI.NetDisable(30000)
			
			--创建房间（参数：房间地图类型, 房间名, 是否带装备）
			SendPvpCmdFunc["create_room"](roomType, roomName)
		end
		]]
		
		--创建房间（参数：房间地图类型, 房间名, 是否带装备, 是否擂台赛）
		--local roomType = 2
		local roomType = 9999
		SendPvpCmdFunc["create_room"](roomType, roomName, true)
	end
	
	--函数：离开房间操作(铜雀台)
	OnLeaveRoomButton_page2 = function()
		--如果未连接，不能离开房间
		if (Pvp_Server:GetState() ~= 1) then --未连接
			--local strText = "您已断开连接，请重新登入" --language
			local strText = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--如果未登入，不能离开房间
		if (not hGlobal.LocalPlayer:getonline()) then --未登入
			--local strText = "您已断开连接，请重新登入" --language
			local strText = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--挡操作
		hUI.NetDisable(30000)
		
		--发送离开房间的协议
		local roomId = current_RoomId_page2
		SendPvpCmdFunc["leave_room"](roomId)
	end
	
	--函数：定时刷新PVP房间界面的滚动(铜雀台)
	refresh_pvproom_UI_loop_page2 = function()
		--在房间中不处理
		if (current_RoomId_page2 ~= 0) then
			return
		end
		
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--未创建第一个控件，不处理
		if (not _frmNode.childUI["PvpRoomNode1"]) then
			return
		end
		
		--未创建最后一个控件，不处理
		if (not _frmNode.childUI["PvpRoomNode" .. current_Room_max_num_page2]) then
			return
		end
		
		local SPEED = 50 --速度
		--print(b_need_auto_fixing_pvproom_page2)
		
		if b_need_auto_fixing_pvproom_page2 then
			---第一个PVP房间的数据
			local PvpRoomBtn1 = _frmNode.childUI["PvpRoomNode1"]
			local btn1_cx, btn1_cy = 0, 0 --第一个PVP房间中心点位置
			local btn1_ly = 0 --第一个PVP房间最上侧的x坐标
			local delta1_ly = 0 --第一个PVP房间距离上侧边界的距离
			btn1_cx, btn1_cy = PvpRoomBtn1.data.x, PvpRoomBtn1.data.y --第一个PVP房间中心点位置
			btn1_ly = btn1_cy + PVPROOM.HEIGHT / 2 --第一个PVP房间最上侧的x坐标
			delta1_ly = btn1_ly + 102 --第一个PVP房间距离上侧边界的距离
			
			--最后一个PVP房间的数据
			local PvpRoomBtnN = _frmNode.childUI["PvpRoomNode" .. current_Room_max_num_page2]
			local btnN_cx, btnN_cy = 0, 0 --最后一个PVP房间中心点位置
			local btnN_ry = 0 --最后一个PVP房间最下侧的x坐标
			local deltNa_ry = 0 --最后一个PVP房间距离下侧边界的距离
			btnN_cx, btnN_cy = PvpRoomBtnN.data.x, PvpRoomBtnN.data.y --最后一个PVP房间中心点位置
			btnN_ry = btnN_cy - PVPROOM.HEIGHT / 2 --最后一个PVP房间最下侧的x坐标
			deltNa_ry = btnN_ry + 564 --最后一个PVP房间距离下侧边界的距离
			--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
			
			--print("delta1_ly=" .. delta1_ly, ", deltNa_rx=" .. deltNa_rx)
			--如果第一个PVP房间的头像跑到下边，那么优先将第一个PVP房间头像贴边
			if (delta1_ly < 0) then
				--print("优先将第一个PVP房间头像贴边")
				--需要修正
				--不会选中PVP房间
				selected_pvproomEx_idx_page2 = 0 --选中的PVP房间索引
				
				--没有惯性
				draggle_speed_y_pvproom_page2 = 0
				
				local speed = SPEED
				if ((delta1_ly + speed) > 0) then --防止走过
					speed = -delta1_ly
					delta1_ly = 0
				end
				
				--每个按钮向上侧做运动
				for i = 1, #current_RoomAbstractList_page2, 1 do
					local listI = current_RoomAbstractList_page2[i] --第i项
					if (listI) then --存在PVP房间信息第i项表
						local ctrli = _frmNode.childUI["PvpRoomNode" .. i]
					--if (ctrli.data.selected == 0) then --只处理未选中的PVP房间卡牌
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
				_frmNode.childUI["PvpRoomPageUp"].handle.s:setVisible(false) --上翻页提示
				_frmNode.childUI["PvpRoomPageDown"].handle.s:setVisible(true) --下翻页提示
			elseif (delta1_ly ~= 0) and (deltNa_ry > 0) then --第一个头像没有贴上侧，并且最后一个头像没有贴下侧，那么再将最后一个PVP房间头像贴边
				--print("将最后一个PVP房间头像贴边")
				--需要修正
				--不会选中PVP房间
				selected_pvproomEx_idx_page2 = 0 --选中的PVP房间索引
				
				--没有惯性
				draggle_speed_y_pvproom_page2 = 0
				
				local speed = SPEED
				if ((deltNa_ry - speed) < 0) then --防止走过
					speed = deltNa_ry
					deltNa_ry = 0
				end
				
				--每个按钮向下侧做运动
				for i = 1, #current_RoomAbstractList_page2, 1 do
					local listI = current_RoomAbstractList_page2[i] --第i项
					if (listI) then --存在PVP房间信息第i项表
						local ctrli = _frmNode.childUI["PvpRoomNode" .. i]
					--if (ctrli.data.selected == 0) then --只处理未选中的PVP房间卡牌
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
				_frmNode.childUI["PvpRoomPageUp"].handle.s:setVisible(true) --上分翻页提示
				_frmNode.childUI["PvpRoomPageDown"].handle.s:setVisible(false) --下分翻页提示
			elseif (draggle_speed_y_pvproom_page2 ~= 0) then --沿着当前的速度方向有惯性地运动一会
				--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_y_pvproom_page2)
				--不会选中PVP房间
				selected_pvproomEx_idx_page2 = 0 --选中的PVP房间索引
				--print("    ->   draggle_speed_y_pvproom_page2=", draggle_speed_y_pvproom_page2)
				
				if (draggle_speed_y_pvproom_page2 > 0) then --朝上运动
					local speed = (draggle_speed_y_pvproom_page2) * 1.0 --系数
					friction_pvproom_page2 = friction_pvproom_page2 - 0.5
					draggle_speed_y_pvproom_page2 = draggle_speed_y_pvproom_page2 + friction_pvproom_page2 --衰减（正）
					
					if (draggle_speed_y_pvproom_page2 < 0) then
						draggle_speed_y_pvproom_page2 = 0
					end
					
					--最后一个PVP房间的坐标不能跑到最下侧的上边去
					if ((deltNa_ry + speed) > 0) then --防止走过
						speed = -deltNa_ry
						deltNa_ry = 0
						
						--没有惯性
						draggle_speed_y_pvproom_page2 = 0
					end
					
					--每个按钮向上侧做运动
					for i = 1, #current_RoomAbstractList_page2, 1 do
						local listI = current_RoomAbstractList_page2[i] --第i项
						if (listI) then --存在PVP房间信息第i项表
							local ctrli = _frmNode.childUI["PvpRoomNode" .. i]
						--if (ctrli.data.selected == 0) then --只处理未选中的PVP房间卡牌
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
				elseif (draggle_speed_y_pvproom_page2 < 0) then --朝下运动
					local speed = (draggle_speed_y_pvproom_page2) * 1.0 --系数
					friction_pvproom_page2 = friction_pvproom_page2 + 0.5
					draggle_speed_y_pvproom_page2 = draggle_speed_y_pvproom_page2 + friction_pvproom_page2 --衰减（负）
					
					if (draggle_speed_y_pvproom_page2 > 0) then
						draggle_speed_y_pvproom_page2 = 0
					end
					
					--第一个PVP房间的坐标不能跑到最上侧的下边去
					if ((delta1_ly + speed) < 0) then --防止走过
						speed = -delta1_ly
						delta1_ly = 0
						
						--没有惯性
						draggle_speed_y_pvproom_page2 = 0
					end
					
					--每个按钮向下侧做运动
					for i = 1, #current_RoomAbstractList_page2, 1 do
						local listI = current_RoomAbstractList_page2[i] --第i项
						if (listI) then --存在PVP房间信息第i项表
							local ctrli = _frmNode.childUI["PvpRoomNode" .. i]
						--if (ctrli.data.selected == 0) then --只处理未选中的PVP房间卡牌
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
					_frmNode.childUI["PvpRoomPageUp"].handle.s:setVisible(false) --上分翻页提示
				else
					_frmNode.childUI["PvpRoomPageUp"].handle.s:setVisible(true) --上分翻页提示
				end
				if (deltNa_ry == 0) then
					_frmNode.childUI["PvpRoomPageDown"].handle.s:setVisible(false) --下分翻页提示
				else
					_frmNode.childUI["PvpRoomPageDown"].handle.s:setVisible(true) --下分翻页提示
				end
			else --停止运动
				b_need_auto_fixing_pvproom_page2 = false
				friction_pvproom_page2 = 0
			end
		end
	end
	
	--函数：定时刷新大厅房间列表(铜雀台)
	refresh_room_list_loop_page2 = function()
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--连接成功状态、登入成功状态
		if (current_connect_state == 1) and (current_login_state == 1) then
			--不在房间中才发起查询
			if (current_RoomId_page2 == 0) then
				--大于时间间隔
				local currenttime = hApi.gametime() --当前时间
				local deltatime = currenttime - last_room_query_time_page2 --时间差
				if (deltatime >= (QUERY_ROOM_DELTA_SECOND_PAGE2 * 1000 - 100)) then
					--修改文字：重新获取房间信息
					_frmNode.childUI["waitingSmall"].handle.s:setVisible(true)
					if _frmNode.childUI["WaitingImg"] then
						_frmNode.childUI["WaitingImg"].handle.s:setVisible(true)
					end
					if _frmNode.childUI["StateLabel"] then
						_frmNode.childUI["StateLabel"]:setText("正在刷新房间列表...")
					end
					
					--发起查询前清空数据
					--current_RoomAbstractList_page2 = {} --大厅房间摘要列表
					--current_Room_max_num_page2 = 0 --最大的PVP房间id
					
					--重新发起查询，所有的房间id列表(铜雀台)
					--local cfgId = 2
					local cfgId = 9999
					SendPvpCmdFunc["get_roomlist"](cfgId)
					--print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx发起查询房间id列表 -loop")
				end
			end
		end
	end
	
	--函数：定时刷新房间内的所有在游戏中的时间(铜雀台)
	refresh_room_gametime_loop_page21 = function()
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--连接成功状态、登入成功状态
		if (current_connect_state == 1) and (current_login_state == 1) then
			--不在房间中才发起查询
			if (current_RoomId_page2 == 0) then
				--大于时间间隔
				local currenttime = hApi.gametime() --当前时间
				local deltatime = currenttime - last_room_gametime_time_page2 --时间差
				if (deltatime >= (QUERY_ROOM_GAMETIME_DELTA_SECOND_PAGE2 * 1000 - 100)) then
					--标记timer
					last_room_gametime_time_page2 = currenttime
					
					--修改文字：重新获取房间信息
					for i = 1, #current_RoomAbstractList_page2, 1 do
						local listI = current_RoomAbstractList_page2[i] --第i项
						if (listI) then --存在PVP房间信息第i项表
							local id = listI.id --房间id
							local name = listI.name --房间名称
							local cfgId = listI.cfgId --房间地图配置索引
							local rm = listI.rm --房主uid
							local mapName = listI.mapName --房间地图名
							local mapInfo = listI.mapInfo --房主地图信息
							local state = listI.state --房主状态(1:未开始 / 2:加载中 / 3:正在游戏)
							local allPlayerNum = listI.allPlayerNum --玩家总数
							local enterPlayerNum = listI.enterPlayerNum --已进入玩家数
							local sessionState = listI.sessionState --游戏局状态	-1未初始化 1初始化 2在游戏 3游戏开始 4游戏结束
							local sessionBeginTimestamp = listI.sessionBeginTimestamp --游戏开始时间戳
							local enterPlayerName = listI.enterPlayerName --玩家姓名(用:分割)
							local bUseEquip = listI.bUseEquip --是否允许装备
							
							--房间人数已满或者游戏中的文字
							if (enterPlayerNum >= allPlayerNum) or (state > 1) then --人数已满或已开始游戏
								if (state > 1) then
									if _frmNode.childUI["PvpRoomNode" .. i] then
										local localTime_pvp = os.time() --pvp客户端时间
										local hostTime_pvp = localTime_pvp - g_localDeltaTime_pvp --pvp服务器时间(Local = Host + deltaTime)
										local deltaSeconds = hostTime_pvp - sessionBeginTimestamp --秒
										--print("deltaSeconds", deltaSeconds)
										local deltaMinutes = math.floor(deltaSeconds / 60) --分
										deltaSeconds = deltaSeconds - deltaMinutes * 60
										if (deltaMinutes < 0) then
											deltaMinutes = 0
											deltaSeconds = 0
										end
										if (deltaMinutes > 999) then
											deltaMinutes = 0
											deltaSeconds = 0
										end
										--print(state, sessionBeginTimestamp, deltaMinutes, deltaSeconds)
										--转字符串
										local strdeltaMinutes = tostring(deltaMinutes)
										if (deltaMinutes < 10) then
											strdeltaMinutes = "0" .. deltaMinutes
										end
										local strdeltaSeconds = tostring(deltaSeconds)
										if (deltaSeconds < 10) then
											strdeltaSeconds = "0" .. strdeltaSeconds
										end
										local strGameTime = strdeltaMinutes .. ":" .. strdeltaSeconds
										
										_frmNode.childUI["PvpRoomNode" .. i].childUI["roomFullLabel"]:setText("")
										_frmNode.childUI["PvpRoomNode" .. i].childUI["roomGameTimeLabel"]:setText(strGameTime)
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	--函数：断开连接后，点击连接房间按钮(铜雀台)
	OnConnectRoomButton_page2 = function()
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--清空右侧控件
		_removeRightFrmFunc()
		
		--显示状态
		_frmNode.childUI["waitingSmall"].handle.s:setVisible(true)
		
		--提示正在登入的文字
		_frmNode.childUI["StateLabel"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 310 + 208,
			y = PVPROOM.OFFSET_Y - 350,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 500,
			border = 1,
			--text = "正在连接中...", --language
			text = hVar.tab_string["__TEXT_NetConnecting"], --language
		})
		_frmNode.childUI["StateLabel"].handle.s:setColor(ccc3(168, 168, 168))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "StateLabel"
		
		--提示大菊花
		_frmNode.childUI["WaitingImg"] = hUI.image:new({
			parent = _parentNode,
			model = "MODEL_EFFECT:waiting",
			x = PVPROOM.OFFSET_X + 310 + 208,
			y = PVPROOM.OFFSET_Y - 280,
			scale = 1.0,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "WaitingImg"
		
		--隐藏登入按钮
		_frmNode.childUI["ConnectRoomButton"]:setstate(-1)
		
		--发起登入操作
		--print("发起登入操作")
		if Pvp_Server then
			--print("发起登入操作", Pvp_Server:GetState())
			if (Pvp_Server:GetState() == 1) then --不重复登入
				--模拟触发连接结果回调
				on_receive_connect_back_event_page2(1)
			else
				Pvp_Server:Connect()
			end
		end
	end
	
	--函数：点击加入某个人的房间按钮(铜雀台)
	OnEnterRoomButton_page2 = function(idxEx)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--如果未连接，不能加入某个房间
		if (Pvp_Server:GetState() ~= 1) then --未连接
			--local strText = "您已断开连接，请重新登入" --language
			local strText = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--如果未登入，不能加入某个房间
		if (not hGlobal.LocalPlayer:getonline()) then --未登入
			--local strText = "您已断开连接，请重新登入" --language
			local strText = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--检测pvp的版本号
		if (not CheckPvpVersionControl()) then
			return
		end
		
		--检测pvp是否达到逃跑最大次数限制
		if (not CheckPvpEscapeMaxCount()) then
			return
		end
		
		--检测pvp是否在逃跑惩罚中
		if (not CheckPvpEscapePunish()) then
			return
		end
		
		--检测pvp是否在投降惩罚中
		if (not CheckPvpSurrenderPunish()) then
			return
		end
		
		--检测pvp是否开放对战（活动300和301的控制）
		if (not CheckPvpBattleOpenState()) then
			return
		end
		
		--检测pvp配卡是否完整
		if (not CheckPvpCfgCardOK()) then
			return
		end
		
		--检测pvp兵符是否足够
		if (not CheckPvpCoinOK()) then
			return
		end
		
		--检测玩家是否作弊
		if (not CheckCheatOK()) then
			return
		end
		
		local listI = current_RoomAbstractList_page2[idxEx] --第i项
		if (listI) then --存在PVP房间信息第i项表
			local id = listI.id --房间id
			local name = listI.name --房间名称
			local cfgId = listI.cfgId --房间地图配置索引
			local rm = listI.rm --房主uid
			local mapName = listI.mapName --房间地图名
			local mapInfo = listI.mapInfo --房主地图信息
			local state = listI.state --房主状态(1:未开始 / 2:加载中 / 3:正在游戏)
			local allPlayerNum = listI.allPlayerNum --玩家总数
			local enterPlayerNum = listI.enterPlayerNum --已进入玩家数
			local sessionState = listI.sessionState --游戏局状态	-1未初始化 1初始化 2在游戏 3游戏开始 4游戏结束
			local sessionBeginTimestamp = listI.sessionBeginTimestamp --游戏开始时间戳
			local enterPlayerName = listI.enterPlayerName --玩家姓名(用:分割)
			local bUseEquip = listI.bUseEquip --是否允许装备
			
			--显示选中框
			--_frmNode.childUI["PvpRoomNode" .. idxEx].childUI["selectbox"].handle.s:setVisible(true)
			_frmNode.childUI["PvpRoomNode" .. idxEx].childUI["selectbox"]:setstate(1)
			
			--检测是否玩家已满或已开始游戏
			if (enterPlayerNum >= allPlayerNum) or (state > 1) then --人数已满或已开始游戏
				--冒泡文字
				--local strText = "该房间人数已满！" --language
				local strText = hVar.tab_string["__TEXT_PVP_RoomFull"] --language
				if (state > 1) then
					--strText = "该房间正在游戏中！" --language
					strText = hVar.tab_string["__TEXT_PVP_RoomInGame"] --language
				end
				
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC,40,"MC", 0,0)
				
				--不显示选中框
				--_frmNode.childUI["PvpRoomNode" .. idxEx].childUI["selectbox"].handle.s:setVisible(false)
				_frmNode.childUI["PvpRoomNode" .. idxEx].childUI["selectbox"]:setstate(-1)
			else
				--发起请求，进入房间
				--进入房间
				local roomId = id
				SendPvpCmdFunc["enter_room"](roomId)
			end
		end
	end
	
	--函数：点击房间内准备按钮(铜雀台)
	OnReadyRoomButton_page2 = function()
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--挡操作
		hUI.NetDisable(30000)
		
		--房间中准备
		local roomId = current_RoomId_page2
		local state = 1
		SendPvpCmdFunc["prepare_game"](roomId, state) --0 取消准备, 1 准备
	end
	
	--函数：点击房间内取消准备按钮(铜雀台)
	OnCancelReadyRoomButton_page2 = function()
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--挡操作
		hUI.NetDisable(30000)
		
		--房间中准备
		local roomId = current_RoomId_page2
		local state = 0
		SendPvpCmdFunc["prepare_game"](roomId, state) --0 取消准备, 1 准备
	end
	
	--函数：点击房间开始游戏按钮(铜雀台)
	OnBeginGameRoomButton_page2 = function()
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--挡操作
		hUI.NetDisable(30000)
		
		--房主开始游戏
		local roomId = current_RoomId_page2
		SendPvpCmdFunc["begin_game"](roomId)
	end
	
	--函数：收到配置卡组返回事件(铜雀台)
	on_receive_Pvp_BattleCfg_event_page2 = function(tCfg, udbid)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--存储配置的卡牌列表
		if (udbid == xlPlayer_GetUID()) then --我
			current_ConfigCardList = tCfg or {}
		end
		--print("存储配置的卡牌列表", current_ConfigCardList)
		
		--存储所有玩家的卡牌配置表
		current_AllPlayerCfgList[udbid] = tCfg or {}
		
		--如果自己在房间中，更新房间
		if (current_PlayerId ~= 0) then
			--模拟触发事件
			if current_Room_page2 then
				--on_receive_RoomInfo_event_page2(current_Room_page2)
				on_single_show_room_config_list_UI(current_Room_page2, tCfg, udbid)
			end
		end
	end
	
	--函数：收到我的基础信息返回事件(铜雀台)
	on_receive_Pvp_baseInfoRet_page2 = function(baseInfo)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("收到我的基础信息返回事件(夺塔奇兵)")
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--print("收到我的战绩返回事件")
		
		--[[
		--更新我的胜率值
		if _frmNode.childUI["RoomMyWinRateLabel"] then
			_frmNode.childUI["RoomMyWinRateLabel"]:setText((g_myPvP_BaseInfo.winE) .. "/" .. (g_myPvP_BaseInfo.totalE))
		end
		
		--更新我的逃跑率值
		local escapeRate = 0
		local escapeColor = nil
		if (g_myPvP_BaseInfo.escapeE >= PVPROOM_COLOR_RATE_MIN) then
			--escapeRate = math.ceil(g_myPvP_BaseInfo.escapeE / (g_myPvP_BaseInfo.escapeE + g_myPvP_BaseInfo.totalE) * 100)
			escapeRate = g_myPvP_BaseInfo.escapeE
		end
		for i = #PVPROOM_COLOR_RATE_TABLE, 1 , -1 do
			if (escapeRate >= PVPROOM_COLOR_RATE_TABLE[i][1]) then
				escapeColor = PVPROOM_COLOR_RATE_TABLE[i][2]
				break
			end
		end
		if _frmNode.childUI["RoomMyEscapeRateLabel"] then
			--_frmNode.childUI["RoomMyEscapeRateLabel"]:setText((escapeRate) .. "%")
			_frmNode.childUI["RoomMyEscapeRateLabel"]:setText(escapeRate)
			_frmNode.childUI["RoomMyEscapeRateLabel"].handle.s:setColor(escapeColor)
		end
		
		--更新我的掉线率值
		local offlineRate = 0
		local offlineColor = nil
		if (g_myPvP_BaseInfo.errE >= PVPROOM_COLOR_RATE_MIN) then
			--offlineRate = math.ceil(g_myPvP_BaseInfo.errE / (g_myPvP_BaseInfo.errE + g_myPvP_BaseInfo.totalE) * 100)
			offlineRate = g_myPvP_BaseInfo.errE
		end
		for i = #PVPROOM_COLOR_RATE_TABLE, 1 , -1 do
			if (offlineRate >= PVPROOM_COLOR_RATE_TABLE[i][1]) then
				offlineColor = PVPROOM_COLOR_RATE_TABLE[i][2]
				break
			end
		end
		if _frmNode.childUI["RoomMyOfflineRateLabel"] then
			--_frmNode.childUI["RoomMyOfflineRateLabel"]:setText((offlineRate) .. "%")
			_frmNode.childUI["RoomMyOfflineRateLabel"]:setText(offlineRate)
			_frmNode.childUI["RoomMyOfflineRateLabel"].handle.s:setColor(offlineColor)
		end
		
		local gamecoin = baseInfo.gamecoin --游戏币
		local pvpcoin = baseInfo.pvpcoin --兵符
		
		current_gamecoin = gamecoin --本地的游戏币
		
		--修改pvp等级
		if _frmNode.childUI["Level_Progress_Icon"] then
			local pvpLevelNew = CalPvpLevel(g_myPvP_BaseInfo.coppercount, g_myPvP_BaseInfo.silvercount, g_myPvP_BaseInfo.goldcount, g_myPvP_BaseInfo.chestexp)
			
			--与上次的pvp等级发生变化，修改值
			if (current_pvplevel ~= pvpLevelNew) then
				--本地的pvp等级
				current_pvplevel = pvpLevelNew --本地的竞技场等级
				
				_frmNode.childUI["Level_Progress_Icon"]:setmodel(hVar.PVPRankUI[pvpLevelNew][1], nil, nil, _frmNode.childUI["Level_Progress_Icon"].data.w, _frmNode.childUI["Level_Progress_Icon"].data.h)
				_frmNode.childUI["Level_Num_Label"]:setText(pvpLevelNew)
				_frmNode.childUI["Level_Progress_ChengHao"]:setText(hVar.tab_string[hVar.PVPRankUI[pvpLevelNew][2] ])
			end
		end
		]]
		
		--修改兵符值
		if _frmNode.childUI["Icon_HuFu_Num"] then
			--与上次的兵符数量发生变化，播放动画
			if (current_pvpcoin ~= g_myPvP_BaseInfo.pvpcoin) then
				--本地的竞技场兵符
				current_pvpcoin = g_myPvP_BaseInfo.pvpcoin
				
				_frmNode.childUI["Icon_HuFu_Num"]:setText(g_myPvP_BaseInfo.pvpcoin)
				
				local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.08, 1.3), CCScaleTo:create(0.08, 1.0))
				_frmNode.childUI["Icon_HuFu_Num"].handle._n:runAction(towAction)
			end
		end
		
		--[[
		--修改星星值
		if _frmNode.childUI["Icon_Star_Num"] then
			--与上次的星星数量发生变化，播放动画
			if (current_evaluateStar ~= g_myPvP_BaseInfo.evaluateE) then
				--本地的战功积分
				current_evaluateStar = g_myPvP_BaseInfo.evaluateE
				
				_frmNode.childUI["Icon_Star_Num"]:setText(g_myPvP_BaseInfo.evaluateE)
				
				local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.08, 1.3), CCScaleTo:create(0.08, 0.88))
				_frmNode.childUI["Icon_Star_Num"].handle._n:runAction(towAction)
			end
		end
		]]
	end
	
	--函数：收到配置卡组界面操作完成事件(铜雀台)
	on_receive_UI_BattleCfg_Complete_page2 = function(nIsModify)
		--print("收到配置卡组界面操作完成事件")
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--显示本界面
		_frm:show(1)
		_frm:active()
		
		--显示按钮
		--_frmNode.childUI["ModifyConfigButton"]:setstate(1)
		
		--进行了修改操作
		if (nIsModify == 1) then
			--冒泡文字
			--local strText = "阵容配置成功！" --language
			local strText = hVar.tab_string["__TEXT_PVP_ConfigSuccess"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0,0)
		else
			--...
		end
	end
	
	--函数：定时刷新铜雀台的开放时间
	refresh_pve_multy_room_timer = function()
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--不在铜雀台房间中
		if (current_RoomId_page2 == 0) then
			--如果是当前时段未开放，显示开放的时段
			--g_pvp_room_closetime
			--主界面刷新竞技场关闭的倒计时
			local clienttime = os.time()
			local hosttime = clienttime - g_localDeltaTime_pvp --(Local = Host + deltaTime)
			
			--20:00:00～21:59:59 GMT+8时区
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - 8 --与北京时间的时差
			hosttime = hosttime - delteZone * 3600
			local tabNow = os.date("*t", hosttime) --北京时区
			local yearNow = tabNow.year
			local monthNow = tabNow.month
			local dayNow = tabNow.day
			local strYearNow = tostring(yearNow)
			local strMonthNow = tostring(monthNow)
			if (monthNow < 10) then
				strMonthNow = "0" .. strMonthNow
			end
			local strDayNow = tostring(dayNow)
			if (dayNow < 10) then
				strDayNow = "0" .. strDayNow
			end
			local strDayBegin = strYearNow .. "-" .. strMonthNow .. "-" .. strDayNow .. " 20:00:00"
			local strDayEnd = strYearNow .. "-" .. strMonthNow .. "-" .. strDayNow .. " 21:59:59"
			local pve_room_begintime = hApi.GetNewDate(strDayBegin)
			local pve_room_closetime = hApi.GetNewDate(strDayEnd)
			
			local begintime_room = hosttime - pve_room_begintime
			local lefttime_room = pve_room_closetime - hosttime
			--print("now=", os.date("%Y-%m-%d %H:%M:%S", hosttime))
			--print(strDayBegin, strDayEnd)
			--print(begintime_room, lefttime_room)
			
			if (lefttime_room >= 0) and (begintime_room >= 0) then
				--提示文字
				if _frmNode.childUI["NoRoomHint"] then
					--_frmNode.childUI["NoRoomHint"].handle._n:setVisible(false)
					--_frmNode.childUI["NoRoomHint"]:setText("暂无房间") --language
					_frmNode.childUI["NoRoomHint"]:setText(hVar.tab_string["__TEXT_PVP_NoRoom"]) --language
				end
				
				--创建房间、修改配置的按钮
				_frmNode.childUI["CreateRoomButton"]:setstate(1)
				
				--隐藏管理员创建房间按钮
				if _frmNode.childUI["CreateRoomButton_Admin"] then
					_frmNode.childUI["CreateRoomButton_Admin"]:setstate(-1)
				end
			else
				--提示文字
				if _frmNode.childUI["NoRoomHint"] then
					--_frmNode.childUI["NoRoomHint"].handle._n:setVisible(true)
					local intBeginHour = (20 + delteZone) % 24 --开始的小时
					local intEndHour = (22 + delteZone) % 24 --结束的小时
					if (intEndHour == 0) then
						intEndHour = 24
					end
					--local strOpenTime = "挑战魔龙开放时段：每天20:00 - 22:00" --language
					local strOpenTime = hVar.tab_string["__TEXT_PVP_NoRoom_OpenTime_MultyPve"] .. intBeginHour .. ":00 - " .. intEndHour .. ":00" --language
					if (delteZone == 0) then --北京时间
						_frmNode.childUI["NoRoomHint"]:setText(strOpenTime)
					else
						_frmNode.childUI["NoRoomHint"]:setText(strOpenTime .. "\n" .. hVar.tab_string["__TEXT_PVP_NoRoom_OpenTime_Standard_MultyPve"])
					end
				end
				
				--创建房间、修改配置的按钮
				_frmNode.childUI["CreateRoomButton"]:setstate(-1)
				
				if (Pvp_Server:GetState() == 1) and hGlobal.LocalPlayer:getonline() then --已连接、已登入
					--if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
					if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
						--显示管理员创建房间按钮
						if _frmNode.childUI["CreateRoomButton_Admin"] then
							_frmNode.childUI["CreateRoomButton_Admin"]:setstate(1)
						end
					end
				end
			end
		end
	end
	
	--函数：创建铜雀台配置卡牌分页（第2个分页的子分页4）
	OnCreateConfigCardSubFrame_page2 = function(pageIndex)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--将本地的卡牌配置上传到服务器(铜雀台)
		UploadClientConfigCard_page2()
		
		--允许本分分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Room_page24", 1)
		
		--清空所有的滑动控件
		current_tCfgCard_DragCtrls = {}
		current_tCfgCard = {} --已选好的控件集
		current_tCfgCard_Data = {} --已选好的控件集数据部分
		current_cfg_selected_ctrl = nil
		
		--面板的背景图-上i
		for i = 1, 8, 1 do
			_frmNode.childUI["frameSubPgaeBG_Top_" .. i] = hUI.button:new({
				parent = _parentNode,
				model = "panel/panel_part_pvp_00.png",
				--model = "misc/mask.png",
				dragbox = _frm.childUI["dragBox"],
				x = PAGE_BTN_LEFT_X - 64 + (i - 1) * 94 + 111,
				y = PAGE_BTN_LEFT_Y - 27,
				w = 94,
				h = 88,
				code = function()
					--
				end,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "frameSubPgaeBG_Top_" .. i
		end
		local i = 9
		_frmNode.childUI["frameSubPgaeBG_Top_" .. i] = hUI.button:new({
			parent = _parentNode,
			model = "panel/panel_part_pvp_00.png",
			--model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = PAGE_BTN_LEFT_X - 64 + (i - 1) * 94 + 135 - 70,
			y = PAGE_BTN_LEFT_Y - 27,
			w = 94,
			h = 88,
			code = function()
				--
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "frameSubPgaeBG_Top_" .. i
		local i = 10
		_frmNode.childUI["frameSubPgaeBG_Top_" .. i] = hUI.button:new({
			parent = _parentNode,
			model = "panel/panel_part_pvp_00.png",
			dragbox = _frm.childUI["dragBox"],
			x = PAGE_BTN_LEFT_X - 64 + (i - 1) * 94 + 135 - 503,
			y = PAGE_BTN_LEFT_Y - 27 - 50,
			w = 836,
			h = 16,
			code = function()
				--
			end,
		})
		_frmNode.childUI["frameSubPgaeBG_Top_" .. i].handle.s:setRotation(180)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "frameSubPgaeBG_Top_" .. i
		
		local CFG_CARD_DX = 262 - 9
		
		--左侧PVP配卡分页提示上翻页的图片
		_frmNode.childUI["PvpCfgCardPageUp"] = hUI.image:new({
			parent = _frm.handle._n,
			model = "UI:PageBtn",
			x = PVPROOM.OFFSET_X + CFG_CARD_DX + 415 - 15,
			y = PVPROOM.OFFSET_Y - 288 + 500, --永远看不见
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["PvpCfgCardPageUp"].handle.s:setRotation(90)
		_frmNode.childUI["PvpCfgCardPageUp"].handle.s:setOpacity(144) --提示上翻页默认透明度为144
		_frmNode.childUI["PvpCfgCardPageUp"].handle.s:setVisible(false) --默认不显示左分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "PvpCfgCardPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["PvpCfgCardPageUp"].handle._n:runAction(forever)
		
		--左侧PVP配卡分页提示下翻页的图片
		_frmNode.childUI["PvpCfgCardPageDown"] = hUI.image:new({
			parent = _frm.handle._n,
			model = "UI:PageBtn",
			x = PVPROOM.OFFSET_X + CFG_CARD_DX + 415 + 7 - 15, --非对称的翻页图
			y = PVPROOM.OFFSET_Y - 509 - 140 - 500, --永远看不见
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["PvpCfgCardPageDown"].handle.s:setRotation(270)
		_frmNode.childUI["PvpCfgCardPageDown"].handle.s:setOpacity(144) --提示下翻页默认透明度为144
		--_frmNode.childUI["PvpCfgCardPageDown"].handle.s:setVisible(false) --默认不显示左分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "PvpCfgCardPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["PvpCfgCardPageDown"].handle._n:runAction(forever)
		
		--左侧配卡分页向上翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["PvpCfgCardPageUp_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = PVPROOM.OFFSET_X + CFG_CARD_DX + 415 - 15,
			y = PVPROOM.OFFSET_Y - 70 + 55 + 500, --永远看不见
			w = 200,
			h = 34,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--滑屏
				--print("向下滚屏", screenY)
				--向下滚屏
				b_need_auto_fixing_pvproom_page14 = true
				friction_pvproom_page14 = 0
				draggle_speed_y_pvproom_page14 = -PVPROOM_MAX_SPEED / 2.0 --负速度
			end,
		})
		_frmNode.childUI["PvpCfgCardPageUp_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "PvpCfgCardPageUp_Btn"
		
		--左侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["PvpCfgCardPageDown_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = PVPROOM.OFFSET_X + CFG_CARD_DX + 415 - 15,
			y = PVPROOM.OFFSET_Y - 612 - 90 - 500, --永远看不见
			w = 180,
			h = 80,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--滑屏
				--print("向上滚屏", screenY)
				--向上滚屏
				b_need_auto_fixing_pvproom_page14 = true
				friction_pvproom_page14 = 0
				draggle_speed_y_pvproom_page14 = PVPROOM_MAX_SPEED / 2.0 --正速度
				--print("正速度")
			end,
		})
		_frmNode.childUI["PvpCfgCardPageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "PvpCfgCardPageDown_Btn"
		
		--左侧用于检测滑动事件的控件
		_frmNode.childUI["PvpCfgCardDragPanel"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = PVPROOM.OFFSET_X + CFG_CARD_DX + 402,
			y = PVPROOM.OFFSET_Y - 470 + 52,
			w = 566,
			h = 483,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--print("codeOnTouch", touchX, touchY, sus)
				click_pos_x_pvproom_page14 = touchX --开始按下的坐标x
				click_pos_y_pvproom_page14 = touchY --开始按下的坐标y
				last_click_pos_y_pvproom_page14 = touchX --上一次按下的坐标x
				last_click_pos_y_pvproom_page14 = touchY --上一次按下的坐标y
				draggle_speed_y_pvproom_page14 = 0 --当前速度为0
				click_scroll_pvproom_page14 = true --是否滑动PVP房间
				b_need_auto_fixing_pvproom_page14 = false --不需要自动修正位置
				friction_pvproom_page14 = 0 --无阻力
				--print("codeOnTouch")
				
				--需要滑动
				click_scroll_pvproom_page14 = true
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
				--处理移动速度y
				draggle_speed_y_pvproom_page14 = touchY - last_click_pos_y_pvproom_page14
				
				if (draggle_speed_y_pvproom_page14 > PVPROOM_MAX_SPEED) then
					draggle_speed_y_pvproom_page14 = PVPROOM_MAX_SPEED
				end
				if (draggle_speed_y_pvproom_page14 < -PVPROOM_MAX_SPEED) then
					draggle_speed_y_pvproom_page14 = -PVPROOM_MAX_SPEED
				end
				
				--print("click_scroll_pvproom_page14=", click_scroll_pvproom_page14)
				--在滑动过程中才会处理滑动
				if click_scroll_pvproom_page14 then
					local deltaY = touchY - last_click_pos_y_pvproom_page14 --与开始按下的位置的偏移值x
					for i = 1, #current_tCfgCard_DragCtrls, 1 do
						local ctrli = current_tCfgCard_DragCtrls[i] --第i项
						if (ctrli) then --存在第i项
							ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
							ctrli.data.x = ctrli.data.x
							ctrli.data.y = ctrli.data.y + deltaY
						end
					end
				end
				
				--存储本次的位置
				last_click_pos_y_pvproom_page14 = touchX
				last_click_pos_y_pvproom_page14 = touchY
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--没有刷新到配卡，禁止点击
				if (not current_ConfigCardList) then
					return
				end
				
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_pvproom_page14 then
					--if (touchX ~= click_pos_x_pvproom_page14) or (touchY ~= click_pos_y_pvproom_page14) then --不是点击事件
						b_need_auto_fixing_pvproom_page14 = true
						friction_pvproom_page14 = 0
					--end
				end
				
				--检测点到了哪个滑动控件
				local selectTipCtrl = nil
				for i = 1, #current_tCfgCard_DragCtrls, 1 do
					local ctrli = current_tCfgCard_DragCtrls[i] --第i项
					if (ctrli) then --存在第i项
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						local cw, ch = ctrli.data.w, ctrli.data.h
						if cw and ch then
							local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
							local rx, ry = lx + cw, ly + ch --最右下角坐标
							--print(i, lx, rx, ly, ry, touchX, touchY)
							if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
								selectTipCtrl = ctrli
								
								break
								--print("点击到了哪个滑动控件框内" .. i)
							end
						end
					end
				end
				
				if (click_scroll_pvproom_page14) and (math.abs(touchY - click_pos_y_pvproom_page14) > 32) then
					selectTipCtrl = nil
				end
				
				--选中了
				if (selectTipCtrl) then
					--点击了有效的控件
					if (selectTipCtrl.data.nType) then
						--不重复选中同一个控件
						if (current_cfg_selected_ctrl ~= selectTipCtrl) then
							--取消上次选中的控件
							if current_cfg_selected_ctrl then
								--current_cfg_selected_ctrl.childUI["selectbox"].handle._n:setVisible(false)
								On_delete_card_selectbox(current_cfg_selected_ctrl) --删除选中框
								
								if current_cfg_selected_ctrl.childUI["imgUse"] then
									hApi.safeRemoveT(current_cfg_selected_ctrl.childUI, "imgUse")
									hApi.safeRemoveT(current_cfg_selected_ctrl.childUI, "labelUse")
									--current_cfg_selected_ctrl.childUI["imgUse"].handle._n:setVisible(false)
									--current_cfg_selected_ctrl.childUI["labelUse"].handle._n:setVisible(false)
								end
							end
							
							--标识选中了此控件
							current_cfg_selected_ctrl = selectTipCtrl
							--print("selectTipCtrl", selectTipCtrl, selectTipCtrl.data.nType)
							
							--显示选中框
							On_create_card_selectbox(selectTipCtrl)
							
							if (selectTipCtrl.data.nType == 1) then --点到了英雄
								--显示英雄卡牌的详细信息
								On_show_herocard_detail_info(selectTipCtrl)
							elseif (selectTipCtrl.data.nType == 2) then --点到了塔
								--显示塔卡牌的详细信息
								On_show_towercard_detail_info(selectTipCtrl)
							elseif (selectTipCtrl.data.nType == 3) then --点到了进攻兵种
								--显示进攻兵种卡牌的详细信息
								On_show_armycard_detail_info(selectTipCtrl)
							elseif (selectTipCtrl.data.nType == 4) then --点到了防守兵种
								--显示防守兵种卡牌的详细信息
								On_show_armycard_detail_info(selectTipCtrl)
							end
						else --点到了同一个控件
							--检测是否点到了使用/卸下的区域
							if selectTipCtrl.childUI["imgUse"] then
								local subCtrl = selectTipCtrl.childUI["imgUse"]
								local cx = selectTipCtrl.data.x  + subCtrl.data.x --中心点x坐标
								local cy = selectTipCtrl.data.y + subCtrl.data.y --中心点y坐标
								local cw, ch = subCtrl.data.w, subCtrl.data.h
								if cw and ch then
									local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
									local rx, ry = lx + cw, ly + ch --最右下角坐标
									--print(i, lx, rx, ly, ry, touchX, touchY)
									if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
										local nType = selectTipCtrl.data.nType --卡牌的类型
										local id = selectTipCtrl.data.id --卡牌的id
										local bConfiged = false --是否已加入配置
										
										--依次检测已配置的卡牌
										for i = 1, #current_tCfgCard, 1 do
											local btni = current_tCfgCard[i]
											if btni and (btni ~= 0) then
												if (btni.data.nType == nType) and (btni.data.id == id) then
													--找到了
													bConfiged = true
													
													break
												end
											end
										end
										if bConfiged then
											--将此卡牌从配置栏移除
											RemoveCardFromConfig(selectTipCtrl)
										else
											--将此卡牌加入到配置栏
											AddCardToConfig(selectTipCtrl)
										end
									end
								end
							end
						end
					end
				end
				
				--标记不用滑动
				click_scroll_pvproom_page14 = false
			end,
		})
		_frmNode.childUI["PvpCfgCardDragPanel"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "PvpCfgCardDragPanel"
		
		--已配置好的卡牌的底板2
		_frmNode.childUI["ConfigCardBG2"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			x = PVPROOM.OFFSET_X + CFG_CARD_DX + 401,
			y = PVPROOM.OFFSET_Y - 226 + 72 + 52,
			w = 560 + 4,
			h = 126 + 4,
		})
		_frmNode.childUI["ConfigCardBG2"].handle.s:setOpacity(0) --只挂载子控件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardBG2"
		local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", 0, 0, 560 + 4, 126 + 4, _frmNode.childUI["ConfigCardBG2"])
		--img9:setOpacity(204)
		
		--已配置好的卡牌的底板
		_frmNode.childUI["ConfigCardBG"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/gray_mask_16.png",
			x = PVPROOM.OFFSET_X + CFG_CARD_DX + 401,
			y = PVPROOM.OFFSET_Y - 226 + 72 + 52,
			w = 560,
			h = 126,
		})
		_frmNode.childUI["ConfigCardBG"].handle.s:setColor(ccc3(168, 168, 168))
		--_frmNode.childUI["ConfigCardBG"].handle.s:setOpacity(0)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardBG"
		
		--左侧横线条
		_frmNode.childUI["LineLeftpatr1"] = hUI.image:new({
			parent = _parentNode,
			model = "panel/panel_part_pvp_01.png",
			x = PVPROOM.OFFSET_X + CFG_CARD_DX + 390,
			y = PVPROOM.OFFSET_Y - 298 + 104,
			w = 600,
			h = 48,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "LineLeftpatr1"
		
		--左侧卡牌详细信息列表底板2
		_frmNode.childUI["AchievementListBG2"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			x = PVPROOM.OFFSET_X + CFG_CARD_DX + 815 - 832 + 12,
			y = PVPROOM.OFFSET_Y - 347,
			w = 250 + 4,
			h = 617 + 4,
		})
		_frmNode.childUI["AchievementListBG2"].handle.s:setOpacity(0) --只挂载子控件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "AchievementListBG2"
		local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", 0, 0, 250 + 4, 617 + 4, _frmNode.childUI["AchievementListBG2"])
		--img9:setOpacity(204)
		
		--左侧卡牌详细信息列表底板
		_frmNode.childUI["AchievementListBG"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/gray_mask_16.png",
			x = PVPROOM.OFFSET_X + CFG_CARD_DX + 815 - 832 + 12,
			y = PVPROOM.OFFSET_Y - 347,
			w = 250,
			h = 617,
		})
		_frmNode.childUI["AchievementListBG"].handle.s:setColor(ccc3(168, 168, 168))
		--_frmNode.childUI["AchievementListBG"].handle.s:setOpacity(0)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "AchievementListBG"
		
		--[[
		--游戏币底图1
		_frmNode.childUI["GameCoinBG1"] = hUI.image:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			model = "UI:AttrBg",
			x = PVPROOM.OFFSET_X + 800,
			y = PVPROOM.OFFSET_Y - 60,
			w = 230,
			h = 36,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "GameCoinBG1"
		
		--游戏币底图2
		_frmNode.childUI["GameCoinBG2"] = hUI.image:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			model = "ui/title_line.png",
			x = PVPROOM.OFFSET_X + 800,
			y = PVPROOM.OFFSET_Y + 18 - 60,
			w = 230,
			h = 3,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "GameCoinBG2"
		
		--游戏币底图3
		_frmNode.childUI["GameCoinBG3"] = hUI.image:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			model = "ui/title_line.png",
			x = PVPROOM.OFFSET_X + 800,
			y = PVPROOM.OFFSET_Y - 18 - 60,
			w = 230,
			h = 3,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "GameCoinBG3"
		
		--游戏币图标
		_frmNode.childUI["GameCoinIcon"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:game_coins",
			x = PVPROOM.OFFSET_X + 800 - 85,
			y = PVPROOM.OFFSET_Y - 20 - 40,
			w = 42,
			h = 42,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "GameCoinIcon"
		
		--游戏币值
		_frmNode.childUI["GameCoinValue"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 800 - 90 + 190,
			y = PVPROOM.OFFSET_Y - 20 - 40 - 2, --数字字体有2像素偏差
			size = 24,
			font = "numWhite",
			align = "RC",
			width = 500,
			border = 0,
			text = LuaGetPlayerRmb(),
		})
		_frmNode.childUI["GameCoinValue"].handle.s:setColor(ccc3(255, 236, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "GameCoinValue"
		
		--积分底图1
		_frmNode.childUI["JiFenBG1"] = hUI.image:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			model = "UI:AttrBg",
			x = PVPROOM.OFFSET_X + 800,
			y = PVPROOM.OFFSET_Y - 106,
			w = 230,
			h = 36,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "JiFenBG1"
		
		--积分底图2
		_frmNode.childUI["JiFenBG2"] = hUI.image:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			model = "ui/title_line.png",
			x = PVPROOM.OFFSET_X + 800,
			y = PVPROOM.OFFSET_Y + 18 - 106,
			w = 230,
			h = 3,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "JiFenBG2"
		
		--积分底图3
		_frmNode.childUI["JiFenBG3"] = hUI.image:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			model = "ui/title_line.png",
			x = PVPROOM.OFFSET_X + 800,
			y = PVPROOM.OFFSET_Y - 18 - 106,
			w = 230,
			h = 3,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "JiFenBG3"
		
		--积分图标
		_frmNode.childUI["JiFenCoinIcon"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:score",
			x = PVPROOM.OFFSET_X + 800 - 85,
			y = PVPROOM.OFFSET_Y - 20 - 106 + 20,
			w = 26,
			h = 26,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "JiFenCoinIcon"
		
		--积分值
		_frmNode.childUI["JiFenCoinValue"] = hUI.label:new({
			parent = _parentNode,
			x = PVPROOM.OFFSET_X + 800 - 90 + 190,
			y = PVPROOM.OFFSET_Y - 20 - 106 + 20 - 2, --数字字体有2像素偏差
			size = 24,
			font = "numWhite",
			align = "RC",
			width = 500,
			border = 0,
			text = LuaGetPlayerScore(),
		})
		--_frmNode.childUI["RoomMyWinRateLabel"].handle.s:setColor(ccc3(48, 225, 39))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "JiFenCoinValue"
		]]
		
		--关闭按钮
		_frmNode.childUI["closeBtnRight_SubPage"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
			model = "BTN:PANEL_CLOSE",
			x = _frm.childUI["closeBtnRight"].data.x,
			y = _frm.childUI["closeBtnRight"].data.y,
			scaleT = 0.95,
			code = _frm.childUI["closeBtn"].data.code,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "closeBtnRight_SubPage"
		
		--出战阵容背景图
		_frmNode.childUI["ConfigTitleConfigBG"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:buttonredV",
			x = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + 25,
			y = CONFIG_CARD_OSSSET_Y - 8,
			w = 50,
			h = 124,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigTitleConfigBG"
		
		--出战阵容标题名字
		_frmNode.childUI["ConfigTitleConfigLabel"] = hUI.label:new({
			parent = _parentNode,
			y = 28,
			size = 26,
			align = "MC",
			border = 1,
			x = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + 25 + 2,
			y = CONFIG_CARD_OSSSET_Y - 8,
			font = hVar.FONTC,
			width = 40,
			--text = "出战阵容", --language
			text = hVar.tab_string["BattleList"], --language
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigTitleConfigLabel"
		
		--[[
		--绘制已配置好的卡牌的底板
		local xn = 0
		local yn = 0
		for i = 1, CONFIG_NUM_MAX, 1 do
			xn = xn + 1
			if (xn > CONFIG_COLS) then
				xn = 1
				yn = yn + 1
			end
			--底板i
			_frmNode.childUI["ConfigBG" .. i] = hUI.button:new({
				parent = _parentNode,
				model = "UI:cardbg0",
				x = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + (CONFIG_CARD_WIDTH / 2) + (xn - 1) *  CONFIG_CARD_DISTANCE_X,
				y = CONFIG_CARD_OSSSET_Y - yn * CONFIG_CARD_DISTANCE_Y,
				w = CONFIG_CARD_WIDTH,
				h = CONFIG_CARD_HEIGHT,
				dragbox = _frm.childUI["dragBox"],
				scaleT = 1.0,
				show = 1,
				z = zOrder,
				--点击事件
				code = function(self, touchX, touchY, isInside)
					--检测本位置是否存在已配置的卡牌
					local selectTipCtrl = _frmNode.childUI["ConfigCardBtn_Config" .. i]
					if selectTipCtrl then
						--不重复选中同一个控件
						if (current_cfg_selected_ctrl ~= selectTipCtrl) then
							--取消上次选中的控件
							if current_cfg_selected_ctrl then
								On_delete_card_selectbox(current_cfg_selected_ctrl)
								if current_cfg_selected_ctrl.childUI["imgUse"] then
									--current_cfg_selected_ctrl.childUI["selectbox"].handle._n:setVisible(false)
									hApi.safeRemoveT(current_cfg_selected_ctrl.childUI, "imgUse")
									hApi.safeRemoveT(current_cfg_selected_ctrl.childUI, "labelUse")
									--current_cfg_selected_ctrl.childUI["imgUse"].handle._n:setVisible(false)
									--current_cfg_selected_ctrl.childUI["labelUse"].handle._n:setVisible(false)
								end
							end
							
							--标识选中了此控件
							current_cfg_selected_ctrl = selectTipCtrl
							--print("selectTipCtrl", selectTipCtrl, selectTipCtrl.data.nType)
							
							--显示选中框
							On_create_card_selectbox(selectTipCtrl)
							
							if (selectTipCtrl.data.nType == 1) then --点到了英雄
								--显示英雄卡牌的详细信息
								On_show_herocard_detail_info(selectTipCtrl)
							elseif (selectTipCtrl.data.nType == 2) then --点到了塔
								--显示塔卡牌的详细信息
								On_show_towercard_detail_info(selectTipCtrl)
							elseif (selectTipCtrl.data.nType == 3) then --点到了进攻兵种
								--显示进攻兵种卡牌的详细信息
								On_show_armycard_detail_info(selectTipCtrl)
							elseif (selectTipCtrl.data.nType == 4) then --点到了防守兵种
								--显示防守兵种卡牌的详细信息
								On_show_armycard_detail_info(selectTipCtrl)
							end
						else --选中了同一个控件
							--检测是否点到了使用/卸下的区域
							if selectTipCtrl.childUI["imgUse"] then
								local subCtrl = selectTipCtrl.childUI["imgUse"]
								local cx = selectTipCtrl.data.x  + subCtrl.data.x --中心点x坐标
								local cy = selectTipCtrl.data.y + subCtrl.data.y --中心点y坐标
								local cw, ch = subCtrl.data.w, subCtrl.data.h
								if cw and ch then
									local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
									local rx, ry = lx + cw, ly + ch --最右下角坐标
									--print(i, lx, rx, ly, ry, touchX, touchY)
									if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
										local nType = selectTipCtrl.data.nType --卡牌的类型
										local id = selectTipCtrl.data.id --卡牌的id
										local bConfiged = false --是否已加入配置
										
										--依次检测已配置的卡牌
										for i = 1, #current_tCfgCard, 1 do
											local btni = current_tCfgCard[i]
											if (btni.data.nType == nType) and (btni.data.id == id) then
												--找到了
												bConfiged = true
												
												break
											end
										end
										if bConfiged then
											--将此卡牌从配置栏移除
											RemoveCardFromConfig(selectTipCtrl)
										else
											--将此卡牌加入到配置栏
											AddCardToConfig(selectTipCtrl)
										end
									end
								end
							end
						end
					end
				end,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigBG" .. i
		end
		]]
		--绘制已配置好的卡牌的底板-英雄
		for i = 1, SELECT_NUM_MAX.HERO, 1 do
			_frmNode.childUI["ConfigBG" .. i] = hUI.button:new({
				parent = _parentNode,
				--model = "UI:Tactic_IntroBG",
				model = "UI:cardbg0", --"ui/kuang.png",
				x = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + 105 + (i - 1) * (94 + 30),
				y = CONFIG_CARD_OSSSET_Y - 5,
				w = 94,
				h = 118,
				dragbox = _frm.childUI["dragBox"],
				scaleT = 1.0,
				show = 1,
				z = zOrder,
				--点击事件
				code = function(self, touchX, touchY, isInside)
					--检测本位置是否存在已配置的卡牌
					local selectTipCtrl = _frmNode.childUI["ConfigCardBtn_Config" .. i]
					if selectTipCtrl then
						--不重复选中同一个控件
						if (current_cfg_selected_ctrl ~= selectTipCtrl) then
							--取消上次选中的控件
							if current_cfg_selected_ctrl then
								On_delete_card_selectbox(current_cfg_selected_ctrl)
								if current_cfg_selected_ctrl.childUI["imgUse"] then
									--current_cfg_selected_ctrl.childUI["selectbox"].handle._n:setVisible(false)
									hApi.safeRemoveT(current_cfg_selected_ctrl.childUI, "imgUse")
									hApi.safeRemoveT(current_cfg_selected_ctrl.childUI, "labelUse")
									--current_cfg_selected_ctrl.childUI["imgUse"].handle._n:setVisible(false)
									--current_cfg_selected_ctrl.childUI["labelUse"].handle._n:setVisible(false)
								end
							end
							
							--标识选中了此控件
							current_cfg_selected_ctrl = selectTipCtrl
							--print("selectTipCtrl", selectTipCtrl, selectTipCtrl.data.nType)
							
							--显示选中框
							On_create_card_selectbox(selectTipCtrl)
							
							if (selectTipCtrl.data.nType == 1) then --点到了英雄
								--显示英雄卡牌的详细信息
								On_show_herocard_detail_info(selectTipCtrl, true)
							elseif (selectTipCtrl.data.nType == 2) then --点到了塔
								--显示塔卡牌的详细信息
								On_show_towercard_detail_info(selectTipCtrl, true)
							elseif (selectTipCtrl.data.nType == 3) then --点到了进攻兵种
								--显示进攻兵种卡牌的详细信息
								On_show_armycard_detail_info(selectTipCtrl, true)
							elseif (selectTipCtrl.data.nType == 4) then --点到了防守兵种
								--显示防守兵种卡牌的详细信息
								On_show_armycard_detail_info(selectTipCtrl, true)
							end
						end
					end
				end,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigBG" .. i
		end
		--绘制已配置好的卡牌的底板-塔、进攻兵种、防守兵种
		local sum = SELECT_NUM_MAX.TOWER + SELECT_NUM_MAX.ARMY_ATK + SELECT_NUM_MAX.ARMY_DEF
		local xn = 0
		local yn = 0
		for i = 1, sum, 1 do
			xn = xn + 1
			if (xn > sum/2) then
				xn = 1
				yn = yn + 1
			end
			_frmNode.childUI["ConfigBG" .. (SELECT_NUM_MAX.HERO + i)] = hUI.button:new({
				parent = _parentNode,
				model = "ui/kuang.png",
				x = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + 336 + (xn - 1) * (56 + 4),
				y = CONFIG_CARD_OSSSET_Y + 24 - yn * (56 + 4),
				w = 56,
				h = 56,
				dragbox = _frm.childUI["dragBox"],
				scaleT = 1.0,
				show = 1,
				z = zOrder,
				--点击事件
				code = function(self, touchX, touchY, isInside)
					--检测本位置是否存在已配置的卡牌
					local selectTipCtrl = _frmNode.childUI["ConfigCardBtn_Config" .. (SELECT_NUM_MAX.HERO + i)]
					if selectTipCtrl then
						--不重复选中同一个控件
						if (current_cfg_selected_ctrl ~= selectTipCtrl) then
							--取消上次选中的控件
							if current_cfg_selected_ctrl then
								On_delete_card_selectbox(current_cfg_selected_ctrl)
								if current_cfg_selected_ctrl.childUI["imgUse"] then
									--current_cfg_selected_ctrl.childUI["selectbox"].handle._n:setVisible(false)
									hApi.safeRemoveT(current_cfg_selected_ctrl.childUI, "imgUse")
									hApi.safeRemoveT(current_cfg_selected_ctrl.childUI, "labelUse")
									--current_cfg_selected_ctrl.childUI["imgUse"].handle._n:setVisible(false)
									--current_cfg_selected_ctrl.childUI["labelUse"].handle._n:setVisible(false)
								end
							end
							
							--标识选中了此控件
							current_cfg_selected_ctrl = selectTipCtrl
							--print("selectTipCtrl", selectTipCtrl, selectTipCtrl.data.nType)
							
							--显示选中框
							On_create_card_selectbox(selectTipCtrl)
							
							if (selectTipCtrl.data.nType == 1) then --点到了英雄
								--显示英雄卡牌的详细信息
								On_show_herocard_detail_info(selectTipCtrl, true)
							elseif (selectTipCtrl.data.nType == 2) then --点到了塔
								--显示塔卡牌的详细信息
								On_show_towercard_detail_info(selectTipCtrl, true)
							elseif (selectTipCtrl.data.nType == 3) then --点到了进攻兵种
								--显示进攻兵种卡牌的详细信息
								On_show_armycard_detail_info(selectTipCtrl, true)
							elseif (selectTipCtrl.data.nType == 4) then --点到了防守兵种
								--显示防守兵种卡牌的详细信息
								On_show_armycard_detail_info(selectTipCtrl, true)
							end
						end
					end
				end,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigBG" .. (SELECT_NUM_MAX.HERO + i)
		end
		
		
		--开始绘制滑动区域
		local OFFSET_Y = CONFIG_CARD_OSSSET_Y - 75
		
		--绘制第一个控件
		_frmNode.childUI["ConfigCard_FirstCtrl"] = hUI.image:new({
			parent = _BTC_pClipNode_Room_page24,
			model = "UI:title_line",
			x = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + CONFIG_CARD_DISTANCE_X + 200,
			y = OFFSET_Y,
			w = 282,
			h = 6,
		})
		_frmNode.childUI["ConfigCard_FirstCtrl"].handle.s:setVisible(false)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCard_FirstCtrl"
		current_tCfgCard_DragCtrls[#current_tCfgCard_DragCtrls+1] = _frmNode.childUI["ConfigCard_FirstCtrl"] --加入到滑动控件里
		
		--偏移值++
		OFFSET_Y = OFFSET_Y - 32
		
		--绘制英雄标题图片
		_frmNode.childUI["ConfigCardBG_Hero"] = hUI.image:new({
			parent = _BTC_pClipNode_Room_page24,
			model = "ui/pvp/pvptimeoutbg2.png", --"UI:PVP_RedCover",
			x = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + CONFIG_CARD_DISTANCE_X + 200 - 15,
			y = OFFSET_Y,
			w = 188,
			h = 36,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardBG_Hero"
		current_tCfgCard_DragCtrls[#current_tCfgCard_DragCtrls+1] = _frmNode.childUI["ConfigCardBG_Hero"] --加入到滑动控件里
		
		--绘制英雄标题文字
		_frmNode.childUI["ConfigCardLabel_Hero"] = hUI.label:new({
			parent = _BTC_pClipNode_Room_page24,
			x = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + CONFIG_CARD_DISTANCE_X + 170 - 15,
			y = OFFSET_Y + 13,
			--text = "英雄", --language
			text = hVar.tab_string["hero"], --language
			size = 28,
			font = hVar.FONTC,
			align = "LT",
			border = 1,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardLabel_Hero"
		current_tCfgCard_DragCtrls[#current_tCfgCard_DragCtrls+1] = _frmNode.childUI["ConfigCardLabel_Hero"] --加入到滑动控件里
		
		--绘制英雄标题已选择的数量
		_frmNode.childUI["ConfigCardLabel_HeroNum"] = hUI.label:new({
			parent = _BTC_pClipNode_Room_page24,
			x = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + CONFIG_CARD_DISTANCE_X + 300 - 15,
			y = OFFSET_Y + 13 + 1,
			text = "0/" .. SELECT_NUM_MAX.HERO,
			size = 22,
			font = "numWhite",
			align = "LT",
			border = 0,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardLabel_HeroNum"
		current_tCfgCard_DragCtrls[#current_tCfgCard_DragCtrls+1] = _frmNode.childUI["ConfigCardLabel_HeroNum"] --加入到滑动控件里
		
		--偏移值++
		OFFSET_Y = OFFSET_Y - 45 - 6 --铜雀台的英雄间距稍微大一点
		
		--绘制所有的英雄
		local tAllHeros = {}
		for i = 1, #hVar.HERO_AVAILABLE_LIST, 1 do
			tAllHeros[#tAllHeros+1] = {typeId = hVar.HERO_AVAILABLE_LIST[i].id, index = i, heroLv = 1, heroStar = 1, heroNum = 0}
		end
		--遍历一下存档，读取已获得的英雄
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
						
						--更新表
						for j = 1, #tAllHeros, 1 do
							if (tAllHeros[j].typeId == typeId) then --找到了
								tAllHeros[j].heroLv = heroLv
								tAllHeros[j].heroStar = heroStar
								tAllHeros[j].heroNum = 1
								break
							end
						end
					end
				end
			end
		end
		--计算英雄的权重(已获得的英雄，排序靠前的，值越大)
		local CalHeroWeight = function(t)
			local key1Value = -t.index
			local key2Value = t.heroNum * 10000
			
			return (key1Value + key2Value)
		end
		--排序
		table.sort(tAllHeros, function(t1, t2)
			local wa = CalHeroWeight(t1)
			local wb = CalHeroWeight(t2)
			return (wa > wb)
		end)
		--依次绘制英雄
		local xn = 0
		local yn = 0
		for i = 1, #tAllHeros, 1 do
			xn = xn + 1
			if (xn > (CONFIG_COLS - 1)) then --铜雀台的英雄间距稍微大一点
				xn = 1
				yn = yn + 1
			end
			local posX = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + (CONFIG_CARD_WIDTH / 2) + (xn - 1) *  (CONFIG_CARD_DISTANCE_X + 20) --铜雀台的英雄间距稍微大一点
			local posY = OFFSET_Y - 38 - yn * (CONFIG_CARD_DISTANCE_Y + 6) --铜雀台的英雄间距稍微大一点
			_frmNode.childUI["ConfigCardBtn_Hero" .. i] = On_create_single_herocard_config_card(tAllHeros[i].typeId, tAllHeros[i].heroLv, tAllHeros[i].heroStar, posX, posY, (tAllHeros[i].heroNum > 0), _BTC_pClipNode_Room_page24)
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardBtn_Hero" .. i
			current_tCfgCard_DragCtrls[#current_tCfgCard_DragCtrls+1] = _frmNode.childUI["ConfigCardBtn_Hero" .. i] --加入滑动控件里
			
			--存储英雄
			_frmNode.childUI["ConfigCardBtn_Hero" .. i].data.nType = 1 --英雄类型为1
			_frmNode.childUI["ConfigCardBtn_Hero" .. i].data.id = tAllHeros[i].typeId --id
			_frmNode.childUI["ConfigCardBtn_Hero" .. i].data.lv = tAllHeros[i].heroLv --lv
			_frmNode.childUI["ConfigCardBtn_Hero" .. i].data.num = tAllHeros[i].heroNum --num
			--
			_frmNode.childUI["ConfigCardBtn_Hero" .. i].data.star = tAllHeros[i].heroStar --star
		end
		
		--偏移值++
		OFFSET_Y = OFFSET_Y - 260 - 110 - 110 - 6 * 4 --铜雀台的英雄间距稍微大一点
		
		--绘制塔标题图片
		_frmNode.childUI["ConfigCardBG_Tower"] = hUI.image:new({
			parent = _BTC_pClipNode_Room_page24,
			model = "ui/pvp/pvptimeoutbg1.png", --"UI:PVP_RedCover",
			x = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + CONFIG_CARD_DISTANCE_X + 200 - 15,
			y = OFFSET_Y,
			w = 188,
			h = 36,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardBG_Tower"
		current_tCfgCard_DragCtrls[#current_tCfgCard_DragCtrls+1] = _frmNode.childUI["ConfigCardBG_Tower"] --加入到滑动控件里
		
		--绘制塔标题文字
		_frmNode.childUI["ConfigCardLabel_Tower"] = hUI.label:new({
			parent = _BTC_pClipNode_Room_page24,
			x = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + CONFIG_CARD_DISTANCE_X + 170 + 14 - 15,
			y = OFFSET_Y + 13,
			--text = "塔", --language
			text = hVar.tab_string["__TEXT_SOLDIER_TOWER"], --language
			size = 28,
			font = hVar.FONTC,
			align = "LT",
			border = 1,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardLabel_Tower"
		current_tCfgCard_DragCtrls[#current_tCfgCard_DragCtrls+1] = _frmNode.childUI["ConfigCardLabel_Tower"] --加入到滑动控件里
		
		--绘制塔标题已选择的数量
		_frmNode.childUI["ConfigCardLabel_TowerNum"] = hUI.label:new({
			parent = _BTC_pClipNode_Room_page24,
			x = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + CONFIG_CARD_DISTANCE_X + 300 - 15,
			y = OFFSET_Y + 13 + 1,
			text = "0/" .. SELECT_NUM_MAX.TOWER,
			size = 22,
			font = "numWhite",
			align = "LT",
			border = 0,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardLabel_TowerNum"
		current_tCfgCard_DragCtrls[#current_tCfgCard_DragCtrls+1] = _frmNode.childUI["ConfigCardLabel_TowerNum"] --加入到滑动控件里
		
		--偏移值++
		OFFSET_Y = OFFSET_Y - 45 - 6 --铜雀台的塔间距稍微大一点
		
		--绘制所有的塔
		local tAllTowers = {}
		for i = 1, #hVar.TACTIC_UPDATE_JIANTA, 1 do --箭塔系
			tAllTowers[#tAllTowers+1] = {towerId = hVar.TACTIC_UPDATE_JIANTA[i], index = i, towerLv = 1, towerNum = 0}
		end
		for i = 1, #hVar.TACTIC_UPDATE_FASHUTA, 1 do --法术塔系
			tAllTowers[#tAllTowers+1] = {towerId = hVar.TACTIC_UPDATE_FASHUTA[i], index = #hVar.TACTIC_UPDATE_JIANTA + i, towerLv = 1, towerNum = 0}
		end
		for i = 1, #hVar.TACTIC_UPDATE_PAOTA, 1 do --炮塔系
			tAllTowers[#tAllTowers+1] = {towerId = hVar.TACTIC_UPDATE_PAOTA[i], index = #hVar.TACTIC_UPDATE_JIANTA + #hVar.TACTIC_UPDATE_FASHUTA + i, towerLv = 1, towerNum = 0}
		end
		--遍历一下存档，读取已获得的塔
		local tTactics = LuaGetPlayerSkillBook()
		if tTactics then
			for i = 1,#tTactics, 1 do
				if (type(tTactics[i]) == "table") then
					local id, lv, num = unpack(tTactics[i])
					--print("find tower:".. tostring(id).. ",".. tostring(lv).. ",".. tostring(num))
					for j = 1, #tAllTowers, 1 do
						if (tAllTowers[j].towerId == id) then --找到了
							tAllTowers[j].towerLv = lv
							tAllTowers[j].towerNum = 1
							
							break
						end
					end
				end
			end
		end
		--计算塔的权重(已获得的塔，排序靠前的，值越大)
		local CalTowerWeight = function(t)
			local key1Value = -t.index
			local key2Value = t.towerNum * 10000
			
			return (key1Value + key2Value)
		end
		--排序
		table.sort(tAllTowers, function(t1, t2)
			local wa = CalTowerWeight(t1)
			local wb = CalTowerWeight(t2)
			return (wa > wb)
		end)
		--依次绘制塔
		local xn = 0
		local yn = 0
		for i = 1, #tAllTowers, 1 do
			xn = xn + 1
			if (xn > (CONFIG_COLS - 1)) then --铜雀台的塔间距稍微大一点
				xn = 1
				yn = yn + 1
			end
			local posX = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + (CONFIG_CARD_WIDTH / 2) + (xn - 1) *  (CONFIG_CARD_DISTANCE_X + 20) --铜雀台的塔间距稍微大一点
			local posY = OFFSET_Y - 38 - yn * (CONFIG_CARD_DISTANCE_Y + 6 * 2) --铜雀台的塔间距稍微大一点
			_frmNode.childUI["ConfigCardBtn_Tower" .. i] = On_create_single_towercard_config_card(tAllTowers[i].towerId, tAllTowers[i].towerLv, posX, posY, (tAllTowers[i].towerNum > 0), _BTC_pClipNode_Room_page24)
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardBtn_Tower" .. i
			current_tCfgCard_DragCtrls[#current_tCfgCard_DragCtrls+1] = _frmNode.childUI["ConfigCardBtn_Tower" .. i] --加入滑动控件里
			
			--存储塔
			_frmNode.childUI["ConfigCardBtn_Tower" .. i].data.nType = 2 --塔类型为2
			_frmNode.childUI["ConfigCardBtn_Tower" .. i].data.id = tAllTowers[i].towerId --id
			_frmNode.childUI["ConfigCardBtn_Tower" .. i].data.lv = tAllTowers[i].towerLv --lv
			_frmNode.childUI["ConfigCardBtn_Tower" .. i].data.num = tAllTowers[i].towerNum --num
		end
		
		--偏移值++
		OFFSET_Y = OFFSET_Y - 260 - 6 --铜雀台的塔间距稍微大一点
		
		--[[
		--绘制进攻兵种标题图片
		_frmNode.childUI["ConfigCardBG_Army_Atk"] = hUI.image:new({
			parent = _BTC_pClipNode_Room_page24,
			model = "ui/pvp/pvptimeoutbg1.png", --"UI:PVP_RedCover",
			x = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + CONFIG_CARD_DISTANCE_X + 200 - 15,
			y = OFFSET_Y,
			w = 188,
			h = 36,
		})
		_frmNode.childUI["ConfigCardBG_Army_Atk"].handle.s:setColor(ccc3(0, 255, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardBG_Army_Atk"
		current_tCfgCard_DragCtrls[#current_tCfgCard_DragCtrls+1] = _frmNode.childUI["ConfigCardBG_Army_Atk"] --加入到滑动控件里
		
		--绘制进攻兵种标题文字
		_frmNode.childUI["ConfigCardLabel_Army_Atk"] = hUI.label:new({
			parent = _BTC_pClipNode_Room_page24,
			x = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + CONFIG_CARD_DISTANCE_X + 142 - 15,
			y = OFFSET_Y + 13,
			--text = "进攻兵种", --language
			text = hVar.tab_string["__TEXT_PVP_Atk"] .. hVar.tab_string["ArmyCardPage"], --language
			size = 28,
			font = hVar.FONTC,
			align = "LT",
			border = 1,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardLabel_Army_Atk"
		current_tCfgCard_DragCtrls[#current_tCfgCard_DragCtrls+1] = _frmNode.childUI["ConfigCardLabel_Army_Atk"] --加入到滑动控件里
		
		--绘制进攻兵种标题已选择的数量
		_frmNode.childUI["ConfigCardLabel_Army_AtkNum"] = hUI.label:new({
			parent = _BTC_pClipNode_Room_page24,
			x = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + CONFIG_CARD_DISTANCE_X + 300 - 15,
			y = OFFSET_Y + 13 + 1,
			text = "0/" .. SELECT_NUM_MAX.ARMY_ATK,
			size = 22,
			font = "numWhite",
			align = "LT",
			border = 0,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardLabel_Army_AtkNum"
		current_tCfgCard_DragCtrls[#current_tCfgCard_DragCtrls+1] = _frmNode.childUI["ConfigCardLabel_Army_AtkNum"] --加入到滑动控件里
		
		--偏移值++
		OFFSET_Y = OFFSET_Y - 45
		
		--绘制所有的兵种-进攻
		local tAllArmys_atk = {}
		for i = 1, #hVar.tab_tacticsArmyEx_Atk, 1 do
			local id = hVar.tab_tacticsArmyEx_Atk[i]
			local bFind = false
			for k, v in pairs(g_myPvP_BaseInfo.tacticInfo) do
				if (k == id) then --找到了
					bFind = true
					--print(v.lv, v.debris)
					table.insert(tAllArmys_atk, {tacticId = id, index = i, tacticLv = v.lv, tacticNum = 1, debris = v.debris,}) --PVP-兵种
					break
				end
			end
			
			if (not bFind) then
				table.insert(tAllArmys_atk, {tacticId = id, index = i, tacticLv = 0, tacticNum = 1, debris = 0,}) --PVP-兵种
			end
		end
		--依次绘制进攻兵种
		local xn = 0
		local yn = 0
		for i = 1, #tAllArmys_atk, 1 do
			xn = xn + 1
			if (xn > CONFIG_COLS) then
				xn = 1
				yn = yn + 1
			end
			local posX = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + (CONFIG_CARD_WIDTH / 2) + (xn - 1) *  CONFIG_CARD_DISTANCE_X
			local posY = OFFSET_Y - 38 - yn * CONFIG_CARD_DISTANCE_Y
			_frmNode.childUI["ConfigCardBtn_Army_Atk" .. i] = On_create_single_armycard_config_card(tAllArmys_atk[i].tacticId, tAllArmys_atk[i].tacticLv, posX, posY, (tAllArmys_atk[i].tacticLv > 0), _BTC_pClipNode_Room_page24)
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardBtn_Army_Atk" .. i
			current_tCfgCard_DragCtrls[#current_tCfgCard_DragCtrls+1] = _frmNode.childUI["ConfigCardBtn_Army_Atk" .. i] --加入滑动控件里
			
			--存储兵种
			_frmNode.childUI["ConfigCardBtn_Army_Atk" .. i].data.nType = 3 --进攻兵种类型为3
			_frmNode.childUI["ConfigCardBtn_Army_Atk" .. i].data.id = tAllArmys_atk[i].tacticId --id
			_frmNode.childUI["ConfigCardBtn_Army_Atk" .. i].data.lv = tAllArmys_atk[i].tacticLv --lv
			_frmNode.childUI["ConfigCardBtn_Army_Atk" .. i].data.num = tAllArmys_atk[i].tacticNum --num
			--
			_frmNode.childUI["ConfigCardBtn_Army_Atk" .. i].data.debris = tAllArmys_atk[i].debris --debris
		end
		
		--偏移值++
		OFFSET_Y = OFFSET_Y - 260
		
		--绘制防守兵种标题图片
		_frmNode.childUI["ConfigCardBG_Army_Def"] = hUI.image:new({
			parent = _BTC_pClipNode_Room_page24,
			model = "ui/pvp/pvptimeoutbg1.png", --"UI:PVP_RedCover",
			x = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + CONFIG_CARD_DISTANCE_X + 200 - 15,
			y = OFFSET_Y,
			w = 188,
			h = 36,
		})
		_frmNode.childUI["ConfigCardBG_Army_Def"].handle.s:setColor(ccc3(0, 255, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardBG_Army_Def"
		current_tCfgCard_DragCtrls[#current_tCfgCard_DragCtrls+1] = _frmNode.childUI["ConfigCardBG_Army_Def"] --加入到滑动控件里
		
		--绘制防守兵种标题文字
		_frmNode.childUI["ConfigCardLabel_Army_Def"] = hUI.label:new({
			parent = _BTC_pClipNode_Room_page24,
			x = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + CONFIG_CARD_DISTANCE_X + 142 - 15,
			y = OFFSET_Y + 13,
			--text = "防守兵种", --language
			text = hVar.tab_string["__TEXT_PVP_Def"] .. hVar.tab_string["ArmyCardPage"], --language
			size = 28,
			font = hVar.FONTC,
			align = "LT",
			border = 1,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardLabel_Army_Def"
		current_tCfgCard_DragCtrls[#current_tCfgCard_DragCtrls+1] = _frmNode.childUI["ConfigCardLabel_Army_Def"] --加入到滑动控件里
		
		--绘制进攻兵种标题已选择的数量
		_frmNode.childUI["ConfigCardLabel_Army_DefNum"] = hUI.label:new({
			parent = _BTC_pClipNode_Room_page24,
			x = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + CONFIG_CARD_DISTANCE_X + 300 - 15,
			y = OFFSET_Y + 13 + 1,
			text = "0/" .. SELECT_NUM_MAX.ARMY_DEF,
			size = 22,
			font = "numWhite",
			align = "LT",
			border = 0,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardLabel_Army_DefNum"
		current_tCfgCard_DragCtrls[#current_tCfgCard_DragCtrls+1] = _frmNode.childUI["ConfigCardLabel_Army_DefNum"] --加入到滑动控件里
		
		--偏移值++
		OFFSET_Y = OFFSET_Y - 45
		
		--绘制所有的兵种-防守
		local tAllArmys_def = {}
		for i = 1, #hVar.tab_tacticsArmyEx_Def, 1 do
			local id = hVar.tab_tacticsArmyEx_Def[i]
			local bFind = false
			for k, v in pairs(g_myPvP_BaseInfo.tacticInfo) do
				if (k == id) then --找到了
					bFind = true
					--print(v.lv, v.debris)
					table.insert(tAllArmys_def, {tacticId = id, index = i, tacticLv = v.lv, tacticNum = 1, debris = v.debris,}) --PVP-兵种
					break
				end
			end
			
			if (not bFind) then
				table.insert(tAllArmys_def, {tacticId = id, index = i, tacticLv = 0, tacticNum = 1, debris = 0,}) --PVP-兵种
			end
		end
		--依次绘制防守兵种
		local xn = 0
		local yn = 0
		for i = 1, #tAllArmys_def, 1 do
			xn = xn + 1
			if (xn > CONFIG_COLS) then
				xn = 1
				yn = yn + 1
			end
			local posX = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + (CONFIG_CARD_WIDTH / 2) + (xn - 1) *  CONFIG_CARD_DISTANCE_X
			local posY = OFFSET_Y - 38 - yn * CONFIG_CARD_DISTANCE_Y
			_frmNode.childUI["ConfigCardBtn_Army_Def" .. i] = On_create_single_armycard_config_card(tAllArmys_def[i].tacticId, tAllArmys_def[i].tacticLv, posX, posY, (tAllArmys_def[i].tacticLv > 0), _BTC_pClipNode_Room_page24)
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardBtn_Army_Def" .. i
			current_tCfgCard_DragCtrls[#current_tCfgCard_DragCtrls+1] = _frmNode.childUI["ConfigCardBtn_Army_Def" .. i] --加入滑动控件里
			
			--存储兵种
			_frmNode.childUI["ConfigCardBtn_Army_Def" .. i].data.nType = 4 --防守兵种类型为4
			_frmNode.childUI["ConfigCardBtn_Army_Def" .. i].data.id = tAllArmys_def[i].tacticId --id
			_frmNode.childUI["ConfigCardBtn_Army_Def" .. i].data.lv = tAllArmys_def[i].tacticLv --lv
			_frmNode.childUI["ConfigCardBtn_Army_Def" .. i].data.num = tAllArmys_def[i].tacticNum --num
			--
			_frmNode.childUI["ConfigCardBtn_Army_Def" .. i].data.debris = tAllArmys_def[i].debris --debris
		end
		
		--偏移值++
		OFFSET_Y = OFFSET_Y - 260 + 110
		]]
		
		--偏移值++
		OFFSET_Y = OFFSET_Y - 15
		
		--绘制最后一个控件
		_frmNode.childUI["ConfigCard_LastCtrl"] = hUI.image:new({
			parent = _BTC_pClipNode_Room_page24,
			model = "UI:title_line",
			x = CONFIG_CARD_OSSSET_XL + CFG_CARD_DX + CONFIG_CARD_DISTANCE_X + 200,
			y = OFFSET_Y,
			w = 282,
			h = 6,
		})
		_frmNode.childUI["ConfigCard_LastCtrl"].handle.s:setVisible(false)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCard_LastCtrl"
		current_tCfgCard_DragCtrls[#current_tCfgCard_DragCtrls+1] = _frmNode.childUI["ConfigCard_LastCtrl"] --加入到滑动控件里
		
		--挡操作的背景图
		_frmNode.childUI["WaitingBG"] = hUI.image:new({
			parent = _parentNode,
			model = "ui/login_lk.png",
			x = PVPROOM.OFFSET_X + CFG_CARD_DX + 310 + 100,
			y = PVPROOM.OFFSET_Y - 390 + 43,
			w = 580,
			h = 620,
		})
		_frmNode.childUI["WaitingBG"].handle.s:setOpacity(168)
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "WaitingBG"
		
		--挡操作的菊花图片
		_frmNode.childUI["WaitingImg"] = hUI.image:new({
			parent = _parentNode,
			model = "MODEL_EFFECT:waiting",
			x = PVPROOM.OFFSET_X + CFG_CARD_DX + 310 + 100,
			y = PVPROOM.OFFSET_Y - 225 + 43 + 80,
			scale = 1.0,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "WaitingImg"
		
		--分页2-4(同2-0)
		--添加事件监听：收到pvp的ping值回调
		hGlobal.event:listen("LocalEvent_Pvp_Ping", "__PvpPing_page2_0", on_receive_ping_event_page2)
		--添加事件监听：收到连接结果回调
		hGlobal.event:listen("LocalEvent_Pvp_NetEvent", "__ConnectBack_page2_0", on_receive_connect_back_event_page2_0)
		--添加事件监听：收到登入结果回调
		hGlobal.event:listen("LocalEvent_Pvp_PlayerLoginEvent", "__LoginBack_page2_0", on_receive_login_back_event_page2_0)
		--添加事件监听：我的基础信息返回事件
		hGlobal.event:listen("LocalEvent_Pvp_UserBaseInfo", "__BattleBaseInfo_page2_0", on_receive_Pvp_baseInfoRet_page2)
		--添加事件监听：pvp错误信息提示
		hGlobal.event:listen("LocalEvent_Pvp_NetLogicError", "__NetLogicError_page2_0", on_receive_Pvp_NetLogicError_event)
		--添加事件监听：配置卡组回调事件
		hGlobal.event:listen("LocalEvent_Pvp_battleCfg", "__BattleCfgBack_page2_0", on_receive_Pvp_BattleCfg_event_page2_0)
		--添加事件监听：收到铜雀台今日生效配置信息
		hGlobal.event:listen("LocalEvent_PvpMulty_RoomTakeEffectCfg", "__PvpMultyCfgBack_page2_0", on_receive_multy_roomcfg_event_page2_0)
		
		--分页2-4监听的事件
		--...
		
		--如果已配好卡了，刷新界面
		if (not current_ConfigCardList) then
			--添加事件监听：配置卡组回调事件
			hGlobal.event:listen("LocalEvent_Pvp_battleCfg", "__BattleCfgBack_page2_4", On_cover_host_card_config_UI_page2)
		else
			On_cover_host_card_config_UI_page2()
			--_removeRightFrmFunc() --测试 --test
		end
		
		--创建timer，刷新PVP配卡界面滚动2-4
		hApi.addTimerForever("__PVP_ROOM_SCROLL_PAGE24__", hVar.TIMER_MODE.GAMETIME, 30, refresh_pvproom_UI_loop_page24)
		
		--发起登入操作
		--print("发起登入操作")
		--print("发起登入操作", Pvp_Server:GetState())
		if (Pvp_Server:GetState() == 1) then --不重复登入
			--模拟触发连接结果回调
			on_receive_connect_back_event_page2_0(1)
		else
			--连接
			Pvp_Server:Connect()
		end
		
		--新手引导: 打过1局以内的，切换到本分页会弹框显示新手介绍
		if (g_myPvP_BaseInfo.updated == 1) and ((g_myPvP_BaseInfo.totalE + g_myPvP_BaseInfo.totalM) < 1) then
			--_ShowNewbieGuide()
		end
	end
	
	local _getCardBGmodel = function(cardLv, mode)
		cardLv = cardLv or 1
		if (cardLv > 1) then --geyachao: 目前只有1张图，没办法！
			cardLv = 1
		end
		return ("UI:PANEL_CARD_0" .. cardLv)
	end
	
	--函数：将服务器的卡牌配置刷到本地的界面(铜雀台)
	On_cover_host_card_config_UI_page2 = function()
		--print("将服务器的卡牌配置刷到本地的界面(铜雀台)")
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("将服务器的卡牌配置刷到本地的界面")
		
		--移除事件监听：配置卡组回调事件（防止收到2个回调）
		hGlobal.event:listen("LocalEvent_Pvp_battleCfg", "__BattleCfgBack_page2_4", nil)
		
		--清除右侧控件集
		_removeRightFrmFunc()
		
		--绘制右侧提示文字
		_frmNode.childUI["HintClickText"] = hUI.label:new({
			parent = _parentNode,
			x = 811 - 681,
			y = -290,
			--text = "请在右侧上方区域，\n选择配置挑战魔龙的英雄、防守塔。", --language
			text = hVar.tab_string["ClickCardSeeDetail2"], --language
			size = 26,
			font = hVar.FONTC,
			align = "LT",
			border = 1,
			width = 234,
		})
		_frmNode.childUI["HintClickText"].handle.s:setColor(ccc3(196, 196, 196))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "HintClickText"
		
		--绘制右侧提示箭头
		_frmNode.childUI["HintClickImage"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:pointer",
			x = 811 - 481,
			y = -75,
			w = 76,
			h = 76,
			align = "MC",
		})
		_frmNode.childUI["HintClickImage"].handle._n:setRotation(90)
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "HintClickImage"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(3, 0)), CCMoveBy:create(0.5, ccp(-3, 0)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["HintClickImage"].handle.s:runAction(forever)
		
		--绘制已选好的卡牌
		local cfg_idx = 1
		local herocard = current_ConfigCardList.herocard or {}
		local towercard = current_ConfigCardList.towercard or {}
		local armycard = current_ConfigCardList.tacticcard or {}
		
		--绘制已选好的英雄
		if herocard then
			local herocard_cfg_num = 0 --已配置的英雄的数量
			for i = 1, #herocard, 1 do
				local heroId = herocard[i].id
				local heroLv = herocard[i].attr.level
				local heroStar = herocard[i].attr.star
				
				--找出绘制好的英雄
				for j = 1, #current_tCfgCard_DragCtrls, 1 do
					local button = current_tCfgCard_DragCtrls[j]
					if (button.data.nType == 1) then --1:英雄类型
						local id = button.data.id
						local lv = button.data.lv
						local num = button.data.num
						local star = button.data.star
						--local lv = heroLv
						--local num = button.data.num
						--local star = heroStar
						
						if (id == heroId) then --找到了
							if (herocard_cfg_num < SELECT_NUM_MAX.HERO) then --不超过最大数量
								--创建拷贝
								local posX = _frmNode.childUI["ConfigBG" .. cfg_idx].data.x
								local posY = _frmNode.childUI["ConfigBG" .. cfg_idx].data.y
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx] = On_create_single_herocard_config_card_tiny(id, lv, star, posX, posY, true, _parentNode, nil)
								
								leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardBtn_Config" .. cfg_idx
								current_tCfgCard[#current_tCfgCard+1] = _frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx] --加入已配置控件里
								current_tCfgCard_Data[#current_tCfgCard_Data+1] = {nType = 1, id = id, lv = lv} --已选好的控件集数据部分
								
								--存储英雄
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.nType = 1 --英雄类型为1
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.id = id --id
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.lv = lv --lv
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.num = num --num
								--
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.star = star --star
								
								--显示选中状态
								button.childUI["ok"].handle._n:setVisible(true)
								--_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].childUI["ok"].handle._n:setVisible(true) --geyachao: 暂时不显示已配置的勾勾
								
								--已配置的英雄数量加1
								herocard_cfg_num = herocard_cfg_num + 1
								
								--索引加1
								cfg_idx = cfg_idx + 1
							end
							
							break
						end
					end
				end
			end
			
			--更新已配置的英雄的数量
			_frmNode.childUI["ConfigCardLabel_HeroNum"]:setText(herocard_cfg_num .. "/" .. SELECT_NUM_MAX.HERO)
			
			--空位补0
			for i = cfg_idx, SELECT_NUM_MAX.HERO, 1 do
				current_tCfgCard[#current_tCfgCard+1] = 0
				current_tCfgCard_Data[#current_tCfgCard_Data+1] = 0
				
				--索引加1
				cfg_idx = cfg_idx + 1
			end
		end
		
		--绘制已选好的塔
		if towercard then
			local towercard_cfg_num = 0 --已配置的塔的数量
			for i = 1, #towercard, 1 do
				local towerId = towercard[i][1]
				local towerLv = towercard[i][2]
				
				--找出绘制好的塔
				for j = 1, #current_tCfgCard_DragCtrls, 1 do
					local button = current_tCfgCard_DragCtrls[j]
					if (button.data.nType == 2) then --2:塔类型
						local id = button.data.id
						local lv = button.data.lv
						--local lv = towerLv
						local num = button.data.num
						
						if (id == towerId) then --找到了
							if (towercard_cfg_num < SELECT_NUM_MAX.TOWER) then --不超过最大数量
								--创建拷贝
								local posX = _frmNode.childUI["ConfigBG" .. cfg_idx].data.x
								local posY = _frmNode.childUI["ConfigBG" .. cfg_idx].data.y
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx] = On_create_single_towercard_config_card_tiny(id, lv, posX, posY, true, _parentNode, nil)
								leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardBtn_Config" .. cfg_idx
								current_tCfgCard[#current_tCfgCard+1] = _frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx] --加入已配置控件里
								current_tCfgCard_Data[#current_tCfgCard_Data+1] = {nType = 2, id = id, lv = lv} --已选好的控件集数据部分
								
								--存储塔
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.nType = 2 --塔类型为2
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.id = id --id
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.lv = lv --lv
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.num = num --num
								
								--显示选中状态
								button.childUI["ok"].handle._n:setVisible(true)
								--_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].childUI["ok"].handle._n:setVisible(true) --geyachao: 暂时不显示已配置的勾勾
								
								--已配置的塔数量加1
								towercard_cfg_num = towercard_cfg_num + 1
								
								--索引加1
								cfg_idx = cfg_idx + 1
							end
							
							break
						end
					end
				end
			end
			
			--更新已配置的塔的数量
			_frmNode.childUI["ConfigCardLabel_TowerNum"]:setText(towercard_cfg_num .. "/" .. SELECT_NUM_MAX.TOWER)
		end
		
		--[[
		--绘制已选好的兵种(进攻)
		if armycard then
			local armycard_atk_cfg_num = 0 --已配置的兵种(进攻)的数量
			for i = 1, #armycard, 1 do
				local tacticId = armycard[i][1]
				local tacticLv = armycard[i][2]
				
				--找出绘制好的兵种(进攻)
				for j = 1, #current_tCfgCard_DragCtrls, 1 do
					local button = current_tCfgCard_DragCtrls[j]
					if (button.data.nType == 3) then --3:进攻兵种类型
						local id = button.data.id
						local lv = button.data.lv
						--local lv = tacticLv
						local num = button.data.num
						local debris = button.data.debris
						
						if (id == tacticId) then --找到了
							--创建拷贝
							if (armycard_atk_cfg_num < SELECT_NUM_MAX.ARMY_ATK) then --不超过最大数量
								local posX = _frmNode.childUI["ConfigBG" .. cfg_idx].data.x
								local posY = _frmNode.childUI["ConfigBG" .. cfg_idx].data.y
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx] = On_create_single_armycard_config_card_tiny(id, lv, posX, posY, true, _parentNode, nil)
								leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardBtn_Config" .. cfg_idx
								current_tCfgCard[#current_tCfgCard+1] = _frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx] --加入已配置控件里
								current_tCfgCard_Data[#current_tCfgCard_Data+1] = {nType = 3, id = id, lv = lv} --已选好的控件集数据部分
								
								--存储进攻兵种
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.nType = 3 --兵种类型为3
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.id = id --id
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.lv = lv --lv
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.num = num --num
								--
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.debris = debris --debris
								
								--显示选中状态
								button.childUI["ok"].handle._n:setVisible(true)
								--_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].childUI["ok"].handle._n:setVisible(true) --geyachao: 暂时不显示已配置的勾勾
								
								--已配置的进攻兵种数量加1
								armycard_atk_cfg_num = armycard_atk_cfg_num + 1
								
								--索引加1
								cfg_idx = cfg_idx + 1
							end
							
							break
						end
					end
				end
			end
			
			--更新已配置的兵种(进攻)的数量
			_frmNode.childUI["ConfigCardLabel_Army_AtkNum"]:setText(armycard_atk_cfg_num .. "/" .. SELECT_NUM_MAX.ARMY_ATK)
		end
		
		--绘制已选好的兵种(防守)
		if armycard then
			local armycard_def_cfg_num = 0 --已配置的兵种(防守)的数量
			for i = 1, #armycard, 1 do
				local tacticId = armycard[i][1]
				local tacticLv = armycard[i][2]
				
				--找出绘制好的兵种(防守)
				for j = 1, #current_tCfgCard_DragCtrls, 1 do
					local button = current_tCfgCard_DragCtrls[j]
					if (button.data.nType == 4) then --4:防守兵种类型
						local id = button.data.id
						local lv = button.data.lv
						local num = button.data.num
						local debris = button.data.debris
						
						if (id == tacticId) then --找到了
							if (armycard_def_cfg_num < SELECT_NUM_MAX.ARMY_DEF) then --不超过最大数量
								--创建拷贝
								local posX = _frmNode.childUI["ConfigBG" .. cfg_idx].data.x
								local posY = _frmNode.childUI["ConfigBG" .. cfg_idx].data.y
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx] = On_create_single_armycard_config_card_tiny(id, lv, posX, posY, true, _parentNode, nil)
								leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardBtn_Config" .. cfg_idx
								current_tCfgCard[#current_tCfgCard+1] = _frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx] --加入已配置控件里
								current_tCfgCard_Data[#current_tCfgCard_Data+1] = {nType = 4, id = id, lv = lv} --已选好的控件集数据部分
								
								--存储防御兵种
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.nType = 4 --兵种类型为3
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.id = id --id
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.lv = lv --lv
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.num = num --num
								--
								_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.debris = debris --debris
								
								--显示选中状态
								button.childUI["ok"].handle._n:setVisible(true)
								--_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].childUI["ok"].handle._n:setVisible(true) --geyachao: 暂时不显示已配置的勾勾
								
								--已配置的防守兵种数量加1
								armycard_def_cfg_num = armycard_def_cfg_num + 1
								
								--索引加1
								cfg_idx = cfg_idx + 1
							end
							
							break
						end
					end
				end
			end
			
			--更新已配置的兵种(防守)的数量
			_frmNode.childUI["ConfigCardLabel_Army_DefNum"]:setText(armycard_def_cfg_num .. "/" .. SELECT_NUM_MAX.ARMY_DEF)
		end
		]]
	end
	
	--函数：创建单个英雄卡牌的接口
	On_create_single_herocard_config_card = function(heroId, heroLv, heroStar, posX, posY, bHaveThisHero, parent, zOrder)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print(heroId, heroLv, heroStar, posX, posY, bHaveThisHero, parent, zOrder)
		--英雄背景框
		local button = hUI.button:new({
			parent = parent,
			mode = "imageButton",
			--dragbox = _frm.childUI["dragBox"], --作为button只是因为image的话，子控件显示异常，只能定义为button，但不接受事件
			model = _getCardBGmodel(heroLv, 1),
			x = posX,
			y = posY,
			w = CONFIG_CARD_WIDTH,
			h = CONFIG_CARD_HEIGHT,
			scale = 1.0,
			align = "MC",
			scaleT = 1.0,
			--failcall = 1,
			show = 1,
			z = zOrder,
			--点击事件
			--code = function(self, screenX, screenY, isInside)
				--print(index, screenX, screenY, isInside)
			--end,
		})
		--如果英雄未获得，背景框灰掉
		if (not bHaveThisHero) then
			hApi.AddShader(button.handle.s, "gray")
		end
		
		--英雄头像
		button.childUI["bg"] = hUI.image:new({
			parent = button.handle._n,
			model = hVar.tab_unit[heroId].portrait,
			x = 1,
			y = 12,
			w = CONFIG_CARD_WIDTH - 8,
			h = CONFIG_CARD_HEIGHT - 30,
			align = "MC",
		})
		hUI.SYSAutoReleaseUI:addModel("portrait", hVar.tab_unit[heroId].portrait) --待回收
		--如果英雄未获得，头像灰掉
		if (not bHaveThisHero) then
			hApi.AddShader(button.childUI["bg"].handle.s, "gray")
		end
		
		--已获得的英雄，显示等级
		if bHaveThisHero then
			--等级背景图
			button.childUI["LvBG"]= hUI.image:new({
				parent = button.handle._n,
				model = "ui/pvp/pvpselect.png",
				x = CONFIG_CARD_WIDTH - 42,
				y = 47,
				w = 34,
				h = 34,
			})
			
			--等级
			local fontSize = 24
			if heroLv and (heroLv >= 10) then --如果等级是2位数的，那么缩一下文字
				fontSize = 16
			end
			button.childUI["Lv"] = hUI.label:new({
				parent = button.handle._n,
				x = CONFIG_CARD_WIDTH - 42,
				y = 47 - 1,
				text = heroLv,
				size = fontSize,
				font = "numWhite",
				align = "MC",
				width = 200,
			})
		end
		
		--英雄名
		local nameFontSize = 24
		local nameText = hVar.tab_stringU[heroId] and hVar.tab_stringU[heroId][1] or ("未知英雄" .. heroId)
		if (#nameText > 9) then
			nameFontSize = 18
		end
		button.childUI["heroName"] = hUI.label:new({
			parent = button.handle._n,
			x = 0,
			y = -42,
			text = nameText,
			size = nameFontSize,
			font = hVar.FONTC,
			align = "MC",
			border = 1,
		})
		
		--当前此英雄的碎片数量
		local heroDebris = 0 --英雄将魂碎片的数量
		
		heroDebris = g_myPvP_BaseInfo.heroInfo[heroId] and g_myPvP_BaseInfo.heroInfo[heroId].soulstone or 0
		--if bHaveThisHero then
		--	local tHeroCard = hApi.GetHeroCardById(heroId)
		--	heroDebris = tHeroCard.attr.soulstone --英雄将魂碎片的数量
		--end
		local maxStarLv = hVar.HERO_STAR_INFO.maxStarLv --最高星级
		local maxLv = 0 --最高等级
		local costSoulStone = 0 --升到下一星需要的碎片数量
		if (heroStar < maxStarLv) then
			costSoulStone = hVar.HERO_STAR_INFO[heroId][heroStar].costSoulStone
			maxLv = hVar.HERO_STAR_INFO[heroId][heroStar].maxLv
		else
			costSoulStone = hVar.HERO_STAR_INFO[heroId][maxStarLv].costSoulStone
			maxLv = hVar.HERO_STAR_INFO[heroId][heroStar].maxLv
		end
		
		--未获得该英雄，并且该英雄只有在竞技场获得，那么需要的等级为0级
		local HeroCard = hApi.GetHeroCardById(heroId) --英雄卡牌
		--英雄是否是竞技场专属
		local pvp_only = false --是否竞技场专属英雄
		for i = 1, #hVar.HERO_AVAILABLE_LIST, 1 do
			if (hVar.HERO_AVAILABLE_LIST[i].id == heroId) then --找到了
				pvp_only = hVar.HERO_AVAILABLE_LIST[i].pvp_only
				
				break
			end
		end
		if (not HeroCard) and (pvp_only) then
			maxLv = 0
		end
		--print(heroLv, maxLv, heroDebris, costSoulStone, heroStar, maxStarLv)
		
		--英雄的星级
		if bHaveThisHero then
			for i = 1, maxStarLv, 1 do
				button.childUI["heroStar" .. i] = hUI.image:new({
					parent = button.handle._n,
					model = "UI:STAR_YELLOW",
					x = -28 + (i - 1) * (20 + 1),
					y = -16,
					w = 20,
					h = 20,
				})
				
				--只显示当前数量
				if (i > heroStar) then
					button.childUI["heroStar" .. i].handle.s:setVisible(false)
				end
			end
		else
			--未获得，都不显示
			for i = 1, maxStarLv, 1 do
				button.childUI["heroStar" .. i] = hUI.image:new({
					parent = button.handle._n,
					model = "UI:STAR_YELLOW",
					x = -30 + (i - 1) * (20 + 1),
					y = -17,
					w = 20,
					h = 20,
				})
				button.childUI["heroStar" .. i].handle.s:setVisible(false)
			end
		end
		
		--已获得的英雄，显示装备
		if bHaveThisHero then
			--英雄装备的图标
			local equipment = HeroCard.equipment or {}
			local equiptype = {1, 2, 4, 3}
			for eq = 1, 4, 1 do
				local itemId = 0
				local idx = equiptype[eq]
				local equp = equipment[idx]
				if (type(equp) == "table") then
					itemId = equp[1]
				end
				
				local eq_wh = 19
				local eq_px = 52
				local eq_py = 40 - eq * (eq_wh + 2) 
				
				--存在道具
				if hVar.tab_item[itemId] then
					--绘制道具背景图
					local itemLv = hVar.tab_item[itemId].itemLv or 1
					local itemtModel = hVar.ITEMLEVEL[itemLv].BORDERMODEL
					button.childUI["equipBG" .. eq] = hUI.image:new({
						parent = button.handle._n,
						model = itemtModel, --"UI:SkillSlot",
						x = eq_px,
						y = eq_py,
						w = eq_wh,
						h = eq_wh,
					})
					
					--绘制道具图标
					button.childUI["equip" .. eq] = hUI.image:new({
						parent = button.handle._n,
						model = hVar.tab_item[itemId].icon,
						x = eq_px,
						y = eq_py,
						w = eq_wh - 4,
						h = eq_wh - 4,
					})
				else
					--不存在道具，画个空板子
					button.childUI["equipBG" .. eq] = hUI.image:new({
						parent = button.handle._n,
						model = "misc/photo_frame.png",
						x = eq_px,
						y = eq_py,
						w = eq_wh,
						h = eq_wh,
					})
					hApi.AddShader(button.childUI["equipBG" .. eq].handle.s, "gray") --灰色图片
				end
			end
		end
		
		--英雄是竞技场专属的盖章图标
		local pvp_only = false --是否竞技场专属英雄
		for i = 1, #hVar.HERO_AVAILABLE_LIST, 1 do
			if (hVar.HERO_AVAILABLE_LIST[i].id == heroId) then --找到了
				pvp_only = hVar.HERO_AVAILABLE_LIST[i].pvp_only
				
				break
			end
		end
		if pvp_only then
			button.childUI["pvp_only"] = hUI.image:new({
				parent = button.handle._n,
				model = "UI:PVP_ONLY",
				x = 19,
				y = -7,
				w = 48,
				h = 48,
			})
		end
		
		--英雄提示升星的跳动箭头
		button.childUI["heroStarUp_JianTou"] = hUI.image:new({
			parent = button.handle._n,
			model = "ICON:image_jiantouV",
			x = 23,
			y = -6,
			w = 32,
			h = 32,
		})
		button.childUI["heroStarUp_JianTou"].handle.s:setVisible(false) --默认不显示
		
		--如果等级升到最高级，碎片数量足够，星未到顶级，那么提示可升星箭头
		if (heroLv >= maxLv) and (heroDebris >= costSoulStone) and (heroStar < maxStarLv) then
			button.childUI["heroStarUp_JianTou"].handle.s:setVisible(true) --显示
		end
		
		--[[
		--碎片进度显示
		button.childUI["barSoulStoneExp"] = hUI.valbar:new({
			parent = button.handle._n,
			x = -32,
			y = -15,
			w = 80 - 14,
			h = 15,
			align = "LC",
			back = {model = "UI:SoulStoneBarBg1", x = -2, y = 0, w = 80 - 10, h = 18},
			model = "UI:SoulStoneBar1",
			--model = "misc/progress.png",
			v = heroDebris,
			max = costSoulStone,
		})
		]]
		
		--ok图片
		button.childUI["ok"] = hUI.image:new({
			parent = button.handle._n,
			model = "UI:ok",
			x = 25,
			y = -35,
			align = "MC",
			w = 30,
			h = 30,
		})
		button.childUI["ok"].handle._n:setVisible(false) --默认隐藏
		
		--[[
		--本卡牌添加子控件-使用的背景图
		button.childUI["imgUse"]= hUI.image:new({
			parent = button.handle._n,
			model = "ui/Purchase_Button.png",
			x = 0,
			y = -CONFIG_CARD_HEIGHT / 2 + 16,
			w = CONFIG_CARD_WIDTH,
			h = 40,
		})
		button.childUI["imgUse"].handle._n:setVisible(false) --默认隐藏
		
		--本卡牌添加子控件-使用的背景图
		button.childUI["labelUse"]= hUI.label:new({
			parent = button.handle._n,
			x = 0,
			y = -CONFIG_CARD_HEIGHT / 2 + 16,
			w = CONFIG_CARD_WIDTH,
			size = 28,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 360,
			--text = "使用", --language
			text = hVar.tab_string["__TEXT_Use"],  --language
		})
		button.childUI["labelUse"].handle._n:setVisible(false) --默认隐藏
		]]
		
		--[[
		--按钮选中框
		local scaleX = (CONFIG_CARD_WIDTH + 4) / 72
		local scaleY = (CONFIG_CARD_HEIGHT + 4) / 72
		button.childUI["selectbox"] = hUI.image:new({
			parent = button.handle._n,
			model = "UI:TacTicFrame",
			align = "MC",
			w = CONFIG_CARD_WIDTH + 4,
			h = CONFIG_CARD_HEIGHT + 4,
			z = 1,
		})
		button.childUI["selectbox"].handle._n:setVisible(false) --默认隐藏
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, scaleX - 0.015, scaleY - 0.015), CCScaleTo:create(0.6, scaleX + 0.025, scaleY + 0.025))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		button.childUI["selectbox"].handle.s:runAction(forever)
		]]
		
		--[[
		--英雄等级的背景图
		button.childUI["heroLvBG"]= hUI.image:new({
			parent = button.handle._n,
			model = "ui/pvp/pvpselect.png",
			x = CONFIG_CARD_WIDTH - 51,
			y = 41,
			w = 34,
			h = 34,
		})
		
		--英雄等级
		local fontSize = 26
		if heroLv and (heroLv >= 10) then
			fontSize = 18
		end
		button.childUI["heroLv"] = hUI.label:new({
			parent = button.handle._n,
			x = HERO_CARD_WIDTH - 51,
			y = 40,
			text = (heroLv or 1),
			size = fontSize,
			font = "numWhite",
			align = "MC",
			width = 200,
		})
		]]
		
		return button
	end
	
	--函数：创建单个英雄卡牌的接口（简版）
	On_create_single_herocard_config_card_tiny = function(heroId, heroLv, heroStar, posX, posY, bHaveThisHero, parent, zOrder)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print(heroId, heroLv, heroStar, posX, posY, bHaveThisHero, parent, zOrder)
		--英雄背景框（简版）
		local button = hUI.button:new({
			parent = parent,
			mode = "imageButton",
			--dragbox = _frm.childUI["dragBox"], --作为button只是因为image的话，子控件显示异常，只能定义为button，但不接受事件
			model = _getCardBGmodel(heroLv, 1),
			x = posX,
			y = posY,
			w = 94,
			h = 118,
			scale = 1.0,
			align = "MC",
			scaleT = 1.0,
			--failcall = 1,
			show = 1,
			z = zOrder,
			--点击事件
			--code = function(self, screenX, screenY, isInside)
				--print(index, screenX, screenY, isInside)
			--end,
		})
		--如果英雄未获得，背景框灰掉（简版）
		if (not bHaveThisHero) then
			hApi.AddShader(button.handle.s, "gray")
		end
		
		--英雄头像（简版）
		button.childUI["bg"] = hUI.image:new({
			parent = button.handle._n,
			model = hVar.tab_unit[heroId].portrait,
			x = 1,
			y = 12,
			w = CONFIG_CARD_WIDTH - 8,
			h = CONFIG_CARD_HEIGHT - 30,
			align = "MC",
		})
		hUI.SYSAutoReleaseUI:addModel("portrait", hVar.tab_unit[heroId].portrait) --待回收
		--如果英雄未获得，头像灰掉（简版）
		if (not bHaveThisHero) then
			hApi.AddShader(button.childUI["bg"].handle.s, "gray")
		end
		
		--已获得的英雄，显示等级（简版）
		if bHaveThisHero then
			--等级背景图（简版）
			button.childUI["LvBG"]= hUI.image:new({
				parent = button.handle._n,
				model = "ui/pvp/pvpselect.png",
				x = CONFIG_CARD_WIDTH - 38,
				y = 46,
				w = 34,
				h = 34,
			})
			
			--等级（简版）
			local fontSize = 24
			if heroLv and (heroLv >= 10) then --如果等级是2位数的，那么缩一下文字
				fontSize = 16
			end
			button.childUI["Lv"] = hUI.label:new({
				parent = button.handle._n,
				x = CONFIG_CARD_WIDTH - 38,
				y = 46 - 1,
				text = heroLv,
				size = fontSize,
				font = "numWhite",
				align = "MC",
				width = 200,
			})
		end
		
		--英雄名（简版）
		local nameFontSize = 24
		local nameText = hVar.tab_stringU[heroId] and hVar.tab_stringU[heroId][1] or ("未知英雄" .. heroId)
		if (#nameText > 9) then
			nameFontSize = 18
		end
		button.childUI["heroName"] = hUI.label:new({
			parent = button.handle._n,
			x = 0,
			y = -42 - 2,
			text = nameText,
			size = nameFontSize,
			font = hVar.FONTC,
			align = "MC",
			border = 1,
		})
		--当前此英雄的碎片数量（简版）
		local heroDebris = 0 --英雄将魂碎片的数量
		
		heroDebris = g_myPvP_BaseInfo.heroInfo[heroId] and g_myPvP_BaseInfo.heroInfo[heroId].soulstone or 0
		--if bHaveThisHero then
		--	local tHeroCard = hApi.GetHeroCardById(heroId)
		--	heroDebris = tHeroCard.attr.soulstone --英雄将魂碎片的数量
		--end
		local maxStarLv = hVar.HERO_STAR_INFO.maxStarLv --最高星级
		local maxLv = 0 --最高等级
		local costSoulStone = 0 --升到下一星需要的碎片数量
		if (heroStar < maxStarLv) then
			costSoulStone = hVar.HERO_STAR_INFO[heroId][heroStar].costSoulStone
			maxLv = hVar.HERO_STAR_INFO[heroId][heroStar].maxLv
		else
			costSoulStone = hVar.HERO_STAR_INFO[heroId][maxStarLv].costSoulStone
			maxLv = hVar.HERO_STAR_INFO[heroId][heroStar].maxLv
		end
		
		--未获得该英雄，并且该英雄只有在竞技场获得，那么需要的等级为0级（简版）
		local HeroCard = hApi.GetHeroCardById(heroId) --英雄卡牌
		--英雄是否是竞技场专属（简版）
		local pvp_only = false --是否竞技场专属英雄
		for i = 1, #hVar.HERO_AVAILABLE_LIST, 1 do
			if (hVar.HERO_AVAILABLE_LIST[i].id == heroId) then --找到了
				pvp_only = hVar.HERO_AVAILABLE_LIST[i].pvp_only
				
				break
			end
		end
		if (not HeroCard) and (pvp_only) then
			maxLv = 0
		end
		--print(heroLv, maxLv, heroDebris, costSoulStone, heroStar, maxStarLv)
		
		--英雄的星级（简版）
		if bHaveThisHero then
			for i = 1, maxStarLv, 1 do
				button.childUI["heroStar" .. i] = hUI.image:new({
					parent = button.handle._n,
					model = "UI:STAR_YELLOW",
					x = -30 + (i - 1) * (20 + 1),
					y = -17,
					w = 20,
					h = 20,
				})
				
				--只显示当前数量
				if (i > heroStar) then
					button.childUI["heroStar" .. i].handle.s:setVisible(false)
				end
			end
		else
			--未获得，都不显示（简版）
			for i = 1, maxStarLv, 1 do
				button.childUI["heroStar" .. i] = hUI.image:new({
					parent = button.handle._n,
					model = "UI:STAR_YELLOW",
					x = -30 + (i - 1) * (20 + 1),
					y = -17,
					w = 20,
					h = 20,
				})
				button.childUI["heroStar" .. i].handle.s:setVisible(false)
			end
		end
		
		--已获得的英雄，显示装备（简版）
		if bHaveThisHero then
			--英雄装备的图标（简版）
			local equipment = HeroCard.equipment or {}
			local equiptype = {1, 2, 4, 3}
			for eq = 1, 4, 1 do
				local itemId = 0
				local idx = equiptype[eq]
				local equp = equipment[idx]
				if (type(equp) == "table") then
					itemId = equp[1]
				end
				
				local eq_wh = 20
				local eq_px = 55
				local eq_py = 41 - eq * (eq_wh + 2) 
				
				--存在道具
				if hVar.tab_item[itemId] then
					--绘制道具背景图
					local itemLv = hVar.tab_item[itemId].itemLv or 1
					local itemtModel = hVar.ITEMLEVEL[itemLv].BORDERMODEL
					button.childUI["equipBG" .. eq] = hUI.image:new({
						parent = button.handle._n,
						model = itemtModel, --"UI:SkillSlot",
						x = eq_px,
						y = eq_py,
						w = eq_wh,
						h = eq_wh,
					})
					
					--绘制道具图标
					button.childUI["equip" .. eq] = hUI.image:new({
						parent = button.handle._n,
						model = hVar.tab_item[itemId].icon,
						x = eq_px,
						y = eq_py,
						w = eq_wh - 4,
						h = eq_wh - 4,
					})
				else
					--不存在道具，画个空板子
					button.childUI["equipBG" .. eq] = hUI.image:new({
						parent = button.handle._n,
						model = "misc/photo_frame.png",
						x = eq_px,
						y = eq_py,
						w = eq_wh,
						h = eq_wh,
					})
					hApi.AddShader(button.childUI["equipBG" .. eq].handle.s, "gray") --灰色图片
				end
			end
		end
		
		--英雄提示升星的跳动箭头（简版）
		button.childUI["heroStarUp_JianTou"] = hUI.image:new({
			parent = button.handle._n,
			model = "ICON:image_jiantouV",
			x = 25,
			y = -8,
			w = 32,
			h = 32,
		})
		button.childUI["heroStarUp_JianTou"].handle.s:setVisible(false) --默认不显示
		
		--如果等级升到最高级，碎片数量足够，星未到顶级，那么提示可升星箭头
		if (heroLv >= maxLv) and (heroDebris >= costSoulStone) and (heroStar < maxStarLv) then
			button.childUI["heroStarUp_JianTou"].handle.s:setVisible(true) --显示
		end
		
		--[[
		--碎片进度显示
		button.childUI["barSoulStoneExp"] = hUI.valbar:new({
			parent = button.handle._n,
			x = -32,
			y = -15,
			w = 80 - 14,
			h = 15,
			align = "LC",
			back = {model = "UI:SoulStoneBarBg1", x = -2, y = 0, w = 80 - 10, h = 18},
			model = "UI:SoulStoneBar1",
			--model = "misc/progress.png",
			v = heroDebris,
			max = costSoulStone,
		})
		]]
		
		--[[
		--本卡牌添加子控件-使用的背景图
		button.childUI["imgUse"]= hUI.image:new({
			parent = button.handle._n,
			model = "ui/Purchase_Button.png",
			x = 0,
			y = -CONFIG_CARD_HEIGHT / 2 + 16,
			w = CONFIG_CARD_WIDTH,
			h = 40,
		})
		button.childUI["imgUse"].handle._n:setVisible(false) --默认隐藏
		
		--本卡牌添加子控件-使用的背景图
		button.childUI["labelUse"]= hUI.label:new({
			parent = button.handle._n,
			x = 0,
			y = -CONFIG_CARD_HEIGHT / 2 + 16,
			w = CONFIG_CARD_WIDTH,
			size = 28,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 360,
			--text = "使用", --language
			text = hVar.tab_string["__TEXT_Use"],  --language
		})
		button.childUI["labelUse"].handle._n:setVisible(false) --默认隐藏
		]]
		
		--[[
		--按钮选中框
		local scaleX = (CONFIG_CARD_WIDTH + 4) / 72
		local scaleY = (CONFIG_CARD_HEIGHT + 4) / 72
		button.childUI["selectbox"] = hUI.image:new({
			parent = button.handle._n,
			model = "UI:TacTicFrame",
			align = "MC",
			w = CONFIG_CARD_WIDTH + 4,
			h = CONFIG_CARD_HEIGHT + 4,
			z = 1,
		})
		button.childUI["selectbox"].handle._n:setVisible(false) --默认隐藏
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, scaleX - 0.015, scaleY - 0.015), CCScaleTo:create(0.6, scaleX + 0.025, scaleY + 0.025))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		button.childUI["selectbox"].handle.s:runAction(forever)
		]]
		
		--[[
		--英雄等级的背景图
		button.childUI["heroLvBG"]= hUI.image:new({
			parent = button.handle._n,
			model = "ui/pvp/pvpselect.png",
			x = CONFIG_CARD_WIDTH - 51,
			y = 41,
			w = 34,
			h = 34,
		})
		
		--英雄等级
		local fontSize = 26
		if heroLv and (heroLv >= 10) then
			fontSize = 18
		end
		button.childUI["heroLv"] = hUI.label:new({
			parent = button.handle._n,
			x = HERO_CARD_WIDTH - 51,
			y = 40,
			text = (heroLv or 1),
			size = fontSize,
			font = "numWhite",
			align = "MC",
			width = 200,
		})
		]]
		
		return button
	end
	
	--函数：显示英雄卡牌的详细信息
	On_show_herocard_detail_info = function(button, bIgnoreOp)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--先清除上一次的右侧控件集
		_removeRightFrmFunc()
		
		--绘制本次的
		local typeId = button.data.id --英雄类型id
		local name = hVar.tab_stringU[typeId] and hVar.tab_stringU[typeId][1] or ("未知英雄" .. typeId) --名字
		local lv = button.data.lv --等级
		local intro = hVar.tab_stringU[typeId] and hVar.tab_stringU[typeId][2] or ("未知英雄" .. typeId) --描述
		local attr = hApi.GetUnitAttrsByHeroCard(typeId) --计算出角色的最终属性
		local atkMin = math.floor(attr.atk_min) --最小攻击力
		local atkMax = math.floor(attr.atk_max) --最大攻击力
		local atkRange = attr.atk_radius --攻击范围
		local hp_max = attr.hp_max --血量
		local moveSpeed = attr.move_speed --移动速度
		local atkSpeed = attr.atk_interval / 1000 --攻击速度
		local pDef = math.floor(attr.def_physic) --物理防御
		local mDef = math.floor(attr.def_magic) --法术防御
		local atk_skill_id = hVar.tab_unit[typeId] and hVar.tab_unit[typeId].attr and hVar.tab_unit[typeId].attr.attack and hVar.tab_unit[typeId].attr.attack[1]
		
		local pvp_only = false --是否竞技场专属英雄
		for i = 1, #hVar.HERO_AVAILABLE_LIST, 1 do
			if (hVar.HERO_AVAILABLE_LIST[i].id == typeId) then --找到了
				pvp_only = hVar.HERO_AVAILABLE_LIST[i].pvp_only
				
				break
			end
		end
		
		--print("On_show_herocard_detail_info", name)
		local HeroCard = hApi.GetHeroCardById(typeId) --英雄卡牌
		local skill = nil --技能列表
		local tactic = nil --战术技能卡技能
		if HeroCard then --存在本地卡牌
			skill = {} --技能列表
			local talent = hVar.tab_unit[typeId].talent
			for i = 1, #talent, 1 do
				table.insert(skill, {id = talent[i][1], lv = HeroCard.talent[i].lv or 0,})
			end
			
			--skill = HeroCard.talent or {} --技能列表
			tactic = HeroCard.tactic or {} --战术技能卡技能
		else --未获得的英雄
			skill = {} --技能列表
			local talent = hVar.tab_unit[typeId].talent
			for i = 1, #talent, 1 do
				table.insert(skill, {id = talent[i][1], lv = 0,})
			end
			tactic = {} --战术技能卡技能
			local tactics = hVar.tab_unit[typeId].tactics
			for i = 1, #tactics, 1 do
				table.insert(tactic, {id = tactics[i], lv = 0,})
			end
		end
		
		local DETAIL_OFFSET_X = 6 - 568 --详细信息面板的x偏移值
		local DETAIL_OFFSET_Y = 55 --详细信息面板的y偏移值
		
		--英雄头像背景框
		_frmNode.childUI["heroIconBolder"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = "UI:NewKuang",
			x = BOARD_WIDTH - 230 - 3 + DETAIL_OFFSET_X,
			y = -BOARD_HEIGHT / 2 + 210 - 2 + DETAIL_OFFSET_Y,
			w = 64 + 8,
			h = 64 + 8,
			align = "MC",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroIconBolder"
		
		--英雄头像
		_frmNode.childUI["heroIcon"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = hVar.tab_unit[typeId].icon,
			x = BOARD_WIDTH - 232 + DETAIL_OFFSET_X,
			y = -BOARD_HEIGHT / 2 + 208 + DETAIL_OFFSET_Y,
			w = 64,
			h = 64,
			align = "MC",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroIcon"
		
		--英雄名字
		_frmNode.childUI["detail_info_name"] = hUI.label:new({
			parent = _parentNode,
			size = 34,
			align = "LC",
			border = 1,
			x = BOARD_WIDTH - 190 + DETAIL_OFFSET_X,
			y = -BOARD_HEIGHT / 2 + 220 + DETAIL_OFFSET_Y,
			font = hVar.FONTC,
			width = 360,
			text = name,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "detail_info_name"
		
		local maxStarLv = hVar.HERO_STAR_INFO.maxStarLv --最高星级
		local currentStar = HeroCard and HeroCard.attr.star or 1
		
		--绘制英雄当前星级
		if HeroCard then --存在本地卡牌
			--英雄的星级(灰)
			for i = 1, 5, 1 do
				_frmNode.childUI["imgStarBg_" .. i] = hUI.image:new({
					parent = _parentNode,
					model = "UI:HeroStarBG",
					x = BOARD_WIDTH - 175 + DETAIL_OFFSET_X + (i - 1) * 29,
					y = -BOARD_HEIGHT / 2 + 190 + DETAIL_OFFSET_Y,
					scale = 0.8,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "imgStarBg_" .. i
			end
			
			
			--英雄的星级(亮)
			for i = 1, currentStar, 1 do
				_frmNode.childUI["imgStar_" .. i] = hUI.image:new({
					parent = _parentNode,
					model = "UI:STAR_YELLOW",
					x = BOARD_WIDTH - 175 + DETAIL_OFFSET_X + (i - 1) * 29,
					y = -BOARD_HEIGHT / 2 + 190 + DETAIL_OFFSET_Y,
					scale = 0.4,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "imgStar_" .. i
			end
		end
		
		--英雄说明
		_frmNode.childUI["detail_info_intro"] = hUI.label:new({
			parent = _parentNode,
			y = 28,
			size = 26,
			align = "LT",
			border = 1,
			x = BOARD_WIDTH - 265 + DETAIL_OFFSET_X,
			y = -BOARD_HEIGHT / 2 + 160 + DETAIL_OFFSET_Y,
			font = hVar.FONTC,
			width = 230,
			text = intro,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "detail_info_intro"
		
		--分割线1
		_frmNode.childUI["heroSeparateLine1"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = "UI:Tactic_SeparateLine",
			x = BOARD_WIDTH + DETAIL_OFFSET_X - 152,
			y = -BOARD_HEIGHT / 2 + DETAIL_OFFSET_Y + 67,
			w = 250,
			h = 4,
			align = "MC",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroSeparateLine1"
		
		local offsetX = BOARD_WIDTH - 250 + DETAIL_OFFSET_X
		local offsetY = -BOARD_HEIGHT / 2 + 86 + DETAIL_OFFSET_Y
		
		--攻击力图标
		if (atkRange <= 150) then
			--近战攻击力图标
			_frmNode.childUI["heroAttrAtkIcon"] = hUI.image:new({
				parent = _frmNode.handle._n,
				model = "ICON:action_attack", --"UI:Attr_Atk"
				x = offsetX - 5,
				y = offsetY - 40,
				w = 26,
				h = 26,
				align = "MC",
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrAtkIcon"
		else
			--print(atk_skill_id)
			if hVar.tab_skill[atk_skill_id] and (hVar.tab_skill[atk_skill_id].DamageType == 2) then
				--远程法术攻击图标
				_frmNode.childUI["heroAttrAtkIcon"] = hUI.image:new({
					parent = _frmNode.handle._n,
					model = "ICON:/battle_attack03",
					x = offsetX - 5,
					y = offsetY - 40,
					w = 26,
					h = 26,
					align = "MC",
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrAtkIcon"
			else
				--远程物理攻击图标
				_frmNode.childUI["heroAttrAtkIcon"] = hUI.image:new({
					parent = _frmNode.handle._n,
					model = "ui/battle_attack02.png",
					x = offsetX - 5,
					y = offsetY - 40,
					w = 26,
					h = 26,
					align = "MC",
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrAtkIcon"
			end
		end
		
		--攻击力文字
		local atkValTotal = atkMin .. "-" .. atkMax
		--atkValTotal = "138-159" --test
		local atkSize = 22
		if (#atkValTotal > 6) then --如果攻击力文字太长，缩小文字大小
			atkSize = 16
		elseif (#atkValTotal > 5) then --如果攻击力文字太长，缩小文字大小
			atkSize = 18
		end
		_frmNode.childUI["heroAttrAtkValue"] = hUI.label:new({
			parent = _parentNode,
			size = atkSize,
			align = "LC",
			--border = 1,
			x = offsetX + 15,
			y = offsetY - 40 - 2, --num字体有2像素偏差
			font = "numWhite",
			width = 210,
			text = atkValTotal,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrAtkValue"
		
		--血量图标
		_frmNode.childUI["heroAttrHp"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = "ui/hp_pec.png", --"UI:Attr_Hp",
			x = offsetX + 120,
			y = offsetY - 40,
			w = 26,
			h = 26,
			align = "MC",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrHp"
		
		--血量文字
		local hpSize = 22
		if (hp_max > 5) then --如果血量太大，缩小文字大小
			hpSize = 20
		end
		_frmNode.childUI["heroAttrHpValue"] = hUI.label:new({
			parent = _parentNode,
			y = 28,
			size = hpSize,
			align = "LC",
			--border = 1,
			x = offsetX + 20 + 120,
			y = offsetY - 40 - 2, --num字体有2像素偏差
			font = "numWhite",
			width = 210,
			text = hp_max,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrHpValue"
		
		--移动速度图标
		_frmNode.childUI["heroAttrMoveSpeed"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = "ICON:Item_Horse01", --"UI:Attr_MoveSpeed",
			x = offsetX - 5,
			y = offsetY - 70,
			w = 26,
			h = 26,
			align = "MC",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrMoveSpeed"
		
		--移动速度文字
		_frmNode.childUI["heroAttrMoveSpeedValue"] = hUI.label:new({
			parent = _parentNode,
			size = 22,
			align = "LC",
			--border = 1,
			x = offsetX + 15,
			y = offsetY - 70 - 2, --num字体有2像素偏差
			font = "numWhite",
			width = 210,
			text = moveSpeed,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrMoveSpeedValue"
		
		--攻击速度图标
		_frmNode.childUI["heroAttrAtkSpeed"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = "ICON:MOVESPEED", --"UI:Attr_CD",
			x = offsetX + 120,
			y = offsetY - 70,
			w = 26,
			h = 26,
			align = "MC",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrAtkSpeed"
		
		--攻击速度文字
		_frmNode.childUI["heroAttrAtkSpeedValue"] = hUI.label:new({
			parent = _parentNode,
			y = 28,
			size = 22,
			align = "LC",
			--border = 1,
			x = offsetX + 20 + 120,
			y = offsetY - 70 - 2, --num字体有2像素偏差
			font = "numWhite",
			width = 210,
			--text = ("%d.%d"):format(math.floor(atkSpeed), math.floor((atkSpeed - math.floor(atkSpeed)) * 100)) --保留2位有效数字
			text = string.format("%.2f", atkSpeed), --保留2位有效数字
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrAtkSpeedValue"
		
		--物理防御图标
		_frmNode.childUI["heroAttrPDef"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = "ICON:DETICON", --"UI:Attr_PDef",
			x = offsetX - 5,
			y = offsetY - 100,
			w = 26,
			h = 26,
			align = "MC",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrPDef"
		
		--物理防御文字
		_frmNode.childUI["heroAttrPDefValue"] = hUI.label:new({
			parent = _parentNode,
			size = 22,
			align = "LC",
			--border = 1,
			x = offsetX + 15,
			y = offsetY - 100 - 2, --num字体有2像素偏差
			font = "numWhite",
			width = 210,
			text = pDef,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrPDefValue"
		
		--法术防御图标
		_frmNode.childUI["heroAttrMDef"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = "ICON:icon01_x1y1", --"UI:Attr_MDef",
			x = offsetX + 120,
			y = offsetY - 100,
			w = 26,
			h = 26,
			align = "MC",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrMDef"
		
		--法术防御文字
		_frmNode.childUI["heroAttrMDefValue"] = hUI.label:new({
			parent = _parentNode,
			y = 28,
			size = 22,
			align = "LC",
			--border = 1,
			x = offsetX + 20 + 120,
			y = offsetY - 100 - 2, --num字体有2像素偏差
			font = "numWhite",
			width = 210,
			text = mDef,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrMDefValue"
		
		--分割线2
		_frmNode.childUI["heroSeparateLine2"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = "UI:Tactic_SeparateLine",
			x = BOARD_WIDTH + DETAIL_OFFSET_X - 152,
			y = -BOARD_HEIGHT / 2 + DETAIL_OFFSET_Y - 40,
			w = 250,
			h = 4,
			align = "MC",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroSeparateLine2"
		
		--技能图标
		local nShowSkillCount = 0 --显示的技能图标的数量
		local offsetSkill = -16
		
		--战术技能卡的技能
		if tactic then
			for i = 1, 4, 1 do
				local tacticTable = tactic[i] --技能表 --geyahcao: 这里改为1，测试4个摆满
				if tacticTable then
					local skillId = tacticTable.id --技能id
					local skillLv = tacticTable.lv --技能等级
					
					if skillId and (skillId > 0) then
						--数量自增1
						nShowSkillCount = nShowSkillCount + 1
						
						local typeId_pvp = typeId + 100 --pvp英雄加100
						local skillId_pvp = hVar.tab_unit[typeId_pvp].tactics[i]
						
						--技能响应点击事件的按钮区域
						_frmNode.childUI["heroAttrBtn" .. nShowSkillCount] = hUI.button:new({
							parent = _frmNode.handle._n,
							model = "misc/mask.png",
							x = offsetX - 54 + nShowSkillCount * (52 + 8),
							y = offsetY + offsetSkill - 149,
							w = 58,
							h = 58,
							align = "MC",
							dragbox = _frm.childUI["dragBox"],
							code = function()
								--显示英雄战术技能tip
								--[[
								local activeSkillId = hVar.tab_tactics[skillId].activeSkill.id
								hGlobal.event:event("LocalEvent_ShowSkillInfoFram", typeId, activeSkillId, 150, 600)
								]]
								local typeId_pvp = typeId + 100 --pvp英雄加100
								local skillId_pvp = hVar.tab_unit[typeId_pvp].tactics[i]
								if skillId_pvp then
									local activeSkillId_pvp = hVar.tab_tactics[skillId_pvp].activeSkill.id
									hGlobal.event:event("LocalEvent_ShowSkillInfoFram", typeId_pvp, activeSkillId_pvp, 150, 600)
								else
									local activeSkillId = hVar.tab_tactics[skillId].activeSkill.id
									hGlobal.event:event("LocalEvent_ShowSkillInfoFram", typeId, activeSkillId, 150, 600)
								end
							end,
						})
						_frmNode.childUI["heroAttrBtn" .. nShowSkillCount].handle.s:setOpacity(0) --只用于响应事件，不显示
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrBtn" .. nShowSkillCount
						
						--技能图标
						_frmNode.childUI["heroAttrSkill" .. nShowSkillCount] = hUI.image:new({
							parent = _frmNode.handle._n,
							model = hVar.tab_tactics[skillId_pvp].icon,
							x = offsetX - 54 + nShowSkillCount * (52 + 8),
							y = offsetY + offsetSkill - 149,
							w = 52,
							h = 52,
							align = "MC",
						})
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrSkill" .. nShowSkillCount
						
						--技能名称
						local skillName = hVar.tab_stringT[skillId_pvp] and hVar.tab_stringT[skillId_pvp][1] or ("未知" .. skillId_pvp)
						_frmNode.childUI["heroAttrSkillName" .. nShowSkillCount] = hUI.label:new({
							parent = _parentNode,
							y = 28,
							size = 22,
							align = "MC",
							border = 1,
							x = offsetX - 45 + nShowSkillCount * (52 + 8),
							y = offsetY + offsetSkill - 182,
							font = hVar.DEFAULT_FONT,
							width = 210,
							text = "", --skillName, --geyachao: 这里不显示名字了
						})
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrSkillName" .. nShowSkillCount
						
						--技能等级
						if (skillLv > 0) then --已解锁
							--[[
							--英雄等级的背景图
							_frmNode.childUI["heroAttrSkillLvBG" .. nShowSkillCount] = hUI.image:new({
								parent = _parentNode,
								model = "ui/pvp/pvpselect.png",
								x = offsetX - 35 + nShowSkillCount * (52 + 8) - 2,
								y = offsetY + offsetSkill - 134 + 4,
								w = 28,
								h = 28,
							})
							rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrSkillLvBG" .. nShowSkillCount
							
							--英雄等级
							local fontSize = 22
							if skillLv and (skillLv >= 10) then
								fontSize = 14
							end
							_frmNode.childUI["heroAttrSkillLv" .. nShowSkillCount] = hUI.label:new({
								parent = _parentNode,
								y = 28,
								size = fontSize,
								align = "MC",
								border = 1,
								x = offsetX - 35 + nShowSkillCount * (52 + 8) - 2,
								y = offsetY + offsetSkill - 134 + 3,
								font = "numWhite",
								width = 210,
								text = skillLv,
							})
							rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrSkillLv" .. nShowSkillCount
							]]
						else --未解锁
							--[[
							_frmNode.childUI["heroAttrSkillLv" .. nShowSkillCount] = hUI.label:new({
								parent = _parentNode,
								y = 28,
								size = 18,
								align = "MC",
								border = 1,
								x = offsetX - 35 + nShowSkillCount * (52 + 8) - 2,
								y = offsetY - 134 + 3,
								font = hVar.DEFAULT_FONT,
								width = 210,
								text = "未解锁",
							})
							]]
							--技能图标灰掉
							hApi.AddShader(_frmNode.childUI["heroAttrSkill" .. nShowSkillCount].handle.s, "gray") --技能图标
						end
					end
				end
			end
		end
		
		--被动技能
		if skill then
			for i = 1, 4, 1 do
				local skillTable = skill[i] --技能表 --geyahcao: 这里改为1，测试4个摆满
				if skillTable then
					local skillId = skillTable.id --技能id
					local skillLv = skillTable.lv --技能等级
					
					if skillId and (skillId > 0) then
						--数量自增1
						nShowSkillCount = nShowSkillCount + 1
						
						--技能响应点击事件的按钮区域
						_frmNode.childUI["heroAttrBtn" .. nShowSkillCount] = hUI.button:new({
							parent = _frmNode.handle._n,
							model = "misc/mask.png",
							x = offsetX - 54 + nShowSkillCount * (52 + 8),
							y = offsetY + offsetSkill - 149,
							w = 58,
							h = 58,
							align = "MC",
							dragbox = _frm.childUI["dragBox"],
							code = function()
								--[[
								--显示英雄被动技能tip
								hGlobal.event:event("LocalEvent_ShowSkillInfoFram", typeId, skillId, 150, 600)
								]]
								local typeId_pvp = typeId + 100 --pvp英雄加100
								if hVar.tab_unit[typeId_pvp].talent[i] then
									local skillId_pvp = hVar.tab_unit[typeId_pvp].talent[i][1]
									hGlobal.event:event("LocalEvent_ShowSkillInfoFram", typeId_pvp, skillId_pvp, 150, 600)
								else
									hGlobal.event:event("LocalEvent_ShowSkillInfoFram", typeId, skillId, 150, 600)
								end
							end,
						})
						_frmNode.childUI["heroAttrBtn" .. nShowSkillCount].handle.s:setOpacity(0) --只用于响应事件，不显示
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrBtn" .. nShowSkillCount
						
						--技能图标
						_frmNode.childUI["heroAttrSkill" .. nShowSkillCount] = hUI.image:new({
							parent = _frmNode.handle._n,
							model = hVar.tab_skill[skillId] and hVar.tab_skill[skillId].icon,
							x = offsetX - 54 + nShowSkillCount * (52 + 8),
							y = offsetY + offsetSkill - 149,
							w = 52,
							h = 52,
							align = "MC",
						})
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrSkill" .. nShowSkillCount
						
						--技能名称
						local skillName = hVar.tab_stringS[skillId] and hVar.tab_stringS[skillId][1] or ("未知" .. skillId)
						_frmNode.childUI["heroAttrSkillName" .. nShowSkillCount] = hUI.label:new({
							parent = _parentNode,
							y = 28,
							size = 22,
							align = "MC",
							border = 1,
							x = offsetX - 45 + nShowSkillCount * (52 + 8),
							y = offsetY + offsetSkill - 182,
							font = hVar.DEFAULT_FONT,
							width = 210,
							text = "", --skillName, --geyachao: 这里不显示名字了
						})
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrSkillName" .. nShowSkillCount
						
						--技能等级
						if (skillLv > 0) then --已解锁
							--[[
							--英雄等级的背景图
							_frmNode.childUI["heroAttrSkillLvBG" .. nShowSkillCount] = hUI.image:new({
								parent = _parentNode,
								model = "ui/pvp/pvpselect.png",
								x = offsetX - 35 + nShowSkillCount * (52 + 8) - 2,
								y = offsetY + offsetSkill - 134 + 4,
								w = 28,
								h = 28,
							})
							rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrSkillLvBG" .. nShowSkillCount
							
							--英雄等级
							local fontSize = 22
							if skillLv and (skillLv >= 10) then
								fontSize = 14
							end
							_frmNode.childUI["heroAttrSkillLv" .. nShowSkillCount] = hUI.label:new({
								parent = _parentNode,
								y = 28,
								size = fontSize,
								align = "MC",
								border = 1,
								x = offsetX - 35 + nShowSkillCount * (52 + 8) - 2,
								y = offsetY + offsetSkill - 134 + 3,
								font = "numWhite",
								width = 210,
								text = skillLv,
							})
							rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroAttrSkillLv" .. nShowSkillCount
							]]
						else --未解锁
							--[[
							_frmNode.childUI["heroAttrSkillLv" .. nShowSkillCount] = hUI.label:new({
								parent = _parentNode,
								y = 28,
								size = 18,
								align = "MC",
								border = 1,
								x = offsetX - 35 + nShowSkillCount * (52 + 8) - 2,
								y = offsetY - 134 + 3,
								font = hVar.DEFAULT_FONT,
								width = 210,
								text = "未解锁",
							})
							]]
							--技能图标灰掉
							hApi.AddShader(_frmNode.childUI["heroAttrSkill" .. nShowSkillCount].handle.s, "gray") --技能图标
						end
					end
				end
			end
		end
		
		--分割线3
		_frmNode.childUI["heroSeparateLine3"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = "UI:Tactic_SeparateLine",
			x = BOARD_WIDTH + DETAIL_OFFSET_X - 152,
			y = -BOARD_HEIGHT / 2 + DETAIL_OFFSET_Y - 120,
			w = 250,
			h = 4,
			align = "MC",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroSeparateLine3"
		
		--升星的介绍描述文字
		local starIntroFontSize = 25 --文字大小
		local starrIntroColor = nil --文字颜色
		--local strStarUpIntro = "升星可以提升英雄等级上限。" --language
		local strStarUpIntro = hVar.tab_string["hero_starupintro"] --language
		--未获得该英雄，并且该英雄只有在竞技场获得，那么文字提示修改
		if (not HeroCard) and (pvp_only) then
			starIntroFontSize = 22 --文字大小
			starrIntroColor = ccc3( 255, 48, 48) --文字颜色
			--strStarUpIntro = "甘宁为竞技场专属英雄，只能从竞技场战斗中积攒将魂碎片获取。" --language
			strStarUpIntro = hVar.tab_stringU[typeId][3] --language
		end
		_frmNode.childUI["heroStarUpIntro"] = hUI.label:new({
			parent = _parentNode,
			size = starIntroFontSize,
			align = "LT",
			--border = 1,
			x = offsetX - 20,
			y = offsetY - 245 + 28,
			font = hVar.FONTC,
			width = 242,
			border = 1,
			text = strStarUpIntro,
		})
		if starrIntroColor then
			_frmNode.childUI["heroStarUpIntro"].handle.s:setColor(starrIntroColor)
		end
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroStarUpIntro"
		
		--当前此英雄将魂碎片数量
		local currentLv = lv or 1 --当前等级
		--print(currentLv)
		--local heroDebris = HeroCard and HeroCard.attr.soulstone or 0 --英雄将魂碎片的数量
		local heroDebris = g_myPvP_BaseInfo.heroInfo[typeId] and g_myPvP_BaseInfo.heroInfo[typeId].soulstone or 0 --英雄将魂碎片的数量
		local maxStarLv = hVar.HERO_STAR_INFO.maxStarLv --最高星级
		local costSoulStone = 0 --升到下一星需要的碎片数量
		local maxLv = 0 --升星需要的等级
		local requireRmb = 0 --升星需要的游戏币数量
		
		if (currentStar < maxStarLv) then
			costSoulStone = hVar.HERO_STAR_INFO[typeId][currentStar].costSoulStone
			maxLv = hVar.HERO_STAR_INFO[typeId][currentStar].maxLv
			local shopItemId = hVar.HERO_STAR_INFO[typeId][currentStar].shopItemId
			requireRmb = hVar.tab_shopitem[shopItemId].rmb
		else
			costSoulStone = hVar.HERO_STAR_INFO[typeId][maxStarLv].costSoulStone
			maxLv = hVar.HERO_STAR_INFO[typeId][maxStarLv].maxLv
			local shopItemId = hVar.HERO_STAR_INFO[typeId][maxStarLv].shopItemId
			requireRmb = hVar.tab_shopitem[shopItemId].rmb
		end
		
		--未获得该英雄，并且该英雄只有在竞技场获得，那么需要的等级为0级
		if (not HeroCard) and (pvp_only) then
			maxLv = 0
			requireRmb = 0
		end
		
		--"将魂"文字
		_frmNode.childUI["heroSoleStoneLabel"] = hUI.label:new({
			parent = _parentNode,
			y = 28,
			size = 26,
			align = "LC",
			--border = 1,
			x = offsetX - 20,
			y = offsetY - 272 - 40,
			font = hVar.FONTC,
			width = 225,
			border = 1,
			--text = "将魂", --language
			text = hVar.tab_string["__TEXT_ITEM_TYPE_SOULSTONE"], --language
		})
		_frmNode.childUI["heroSoleStoneLabel"].handle.s:setColor(ccc3(0, 212, 0))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroSoleStoneLabel"
		
		
		local ACHIEVEMENT_WIDTH = 230
		--英雄将魂碎片进度条
		_frmNode.childUI["heroDebrisProgress"] = hUI.valbar:new({
			parent = _parentNode,
			x = offsetX + 92 - 51,
			y = offsetY - 270 - 40,
			w = ACHIEVEMENT_WIDTH - 64,
			h = 30,
			align = "LC",
			back = {model = "UI:SoulStoneBarBg1", x = -5, y = 0, w = ACHIEVEMENT_WIDTH - 56, h = 30 + 6},
			model = "UI:SoulStoneBar1",
			--model = "misc/progress.png",
			v = heroDebris,
			max = costSoulStone,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroDebrisProgress"
		--print("v=" .. heroDebris, "max=" .. costSoulStone)
		
		--英雄将魂碎片进度文字
		local showNumText = (heroDebris .. "/" .. costSoulStone)
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
		_frmNode.childUI["heroDebrisProgressLabel"] = hUI.label:new({
			parent = _parentNode,
			x = offsetX + 122,
			y = offsetY - 270 - 40,
			size = 26,
			align = "MC",
			--font = hVar.FONTC,
			font = "numWhite",
			text = showNumText,
			scale = scaleText,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroDebrisProgressLabel"
		
		--未到顶星，可以升星
		if (currentStar < maxStarLv) then
			--游戏币为0，不显示需要游戏的界面
			if (requireRmb > 0) then
				--当前此英雄升星需要的游戏币文字前缀
				_frmNode.childUI["heroStarUpRmbPrefix"] = hUI.label:new({
					parent = _parentNode,
					y = 28,
					size = 24,
					align = "LC",
					--border = 1,
					x = offsetX + 10,
					y = offsetY - 317 - 40,
					font = hVar.FONTC,
					width = 300,
					--text = "消耗", --language
					text = hVar.tab_string["__TEXT_CONSUME"], --language
					border = 1,
				})
				_frmNode.childUI["heroStarUpRmbPrefix"].handle.s:setColor(ccc3(255, 236, 0))
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroStarUpRmbPrefix"
				
				--当前此英雄升星需要的游戏币图标
				_frmNode.childUI["heroStarUpRmbIcon"] = hUI.image:new({
					parent = _frmNode.handle._n,
					model = "UI:game_coins",
					x = offsetX + 90,
					y = offsetY - 313 - 40,
					w = 36,
					h = 36,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroStarUpRmbIcon"
				
				--当前此英雄升星需要的游戏币值
				_frmNode.childUI["heroStarUpRmbValue"] = hUI.label:new({
					parent = _parentNode,
					y = 28,
					size = 20,
					align = "LC",
					--border = 1,
					x = offsetX + 108,
					y = offsetY - 317 - 40,
					font = "numWhite",
					width = 300,
					text = requireRmb,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroStarUpRmbValue"
				_frmNode.childUI["heroStarUpRmbValue"].handle.s:setColor(ccc3(255, 236, 0))
			end
			
			--升星按钮
			--local labStarUp = "升星" --language
			local labStarUp = hVar.tab_string["__UPGRADESTAR"] --language
			local sizestarUp = 32
			--未获得该英雄，并且该英雄只有在竞技场获得，那么文字提示修改
			if (not HeroCard) and (pvp_only) then
				--labStarUp = "解锁获得" --language
				labStarUp = hVar.tab_string["__UNLOCK"] .. hVar.tab_string["__TEXT_Get1"] --language
				sizestarUp = 28
			end
			
			_frmNode.childUI["btnStarUp"] = hUI.button:new({
				parent = _parentNode,
				dragbox = _frm.childUI["dragBox"],
				x = offsetX + 92,
				y = offsetY - 357 - 40,
				w = 160,
				h = 50,
				--label = labStarUp,
				label = {text = labStarUp, font = hVar.FONTC, size = sizestarUp,},
				font = hVar.FONTC,
				size = 21,
				border = 1,
				model = "UI:BTN_ButtonRed",
				animation = "normal",
				scaleT = 0.95,
				scale = 1.0,
				code = function()
					--如果未连接，不能确认配置
					if (Pvp_Server:GetState() ~= 1) then --未连接
						--local strText = "您已断开连接，请重新登入" --language
						local strText = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
						hUI.floatNumber:new({
							x = hVar.SCREEN.w / 2,
							y = hVar.SCREEN.h / 2,
							align = "MC",
							text = "",
							lifetime = 1000,
							fadeout = -550,
							moveY = 32,
						}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
						
						return
					end
					
					--如果未登入，不能确认配置
					if (not hGlobal.LocalPlayer:getonline()) then --未登入
						--local strText = "您已断开连接，请重新登入" --language
						local strText = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
						hUI.floatNumber:new({
							x = hVar.SCREEN.w / 2,
							y = hVar.SCREEN.h / 2,
							align = "MC",
							text = "",
							lifetime = 1000,
							fadeout = -550,
							moveY = 32,
						}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
						
						return
					end
					
					--检测pvp的版本号
					if (not CheckPvpVersionControl()) then
						return
					end
					
					--检测游戏币是否足够
					if (LuaGetPlayerRmb() < requireRmb) then
						--弹框
						--[[
						--local strText = "游戏币不足" --language
						local strText = hVar.tab_string["ios_not_enough_game_coin"] --language
						hGlobal.UI.MsgBox(strText, {
							font = hVar.FONTC,
							ok = function()
							end,
						})
						]]
						--弹出游戏币不足并提示是否购买的框
						hGlobal.event:event("LocalEvent_BuyItemfail", 1, 0)
						
						return
					end
					
					--检测英雄等级是否不够
					if (currentLv < maxLv) then 
						--弹框
						--local strText = "英雄等级不够！" --language
						local strText = hVar.tab_string["hero_evelnotfull"] --language
						hGlobal.UI.MsgBox(strText,{
							font = hVar.FONTC,
							ok = function()
								--
							end,
						})
						
						return
					end
					
					--检测是否到顶星
					if (currentStar >= maxStarLv) then
						--弹框
						--local strText = "星级已满" --language
						local strText = hVar.tab_string["hero_starMax"] --language
						hGlobal.UI.MsgBox(strText,{
							font = hVar.FONTC,
							ok = function()
								--
							end,
						})
						
						return
					end
					
					--检测碎片数量足够
					if (heroDebris < costSoulStone) then
						--弹框
						--local strText = "英雄将魂不足！" --language
						local strText = hVar.tab_string["hero_lessSoulstone"] --language
						hGlobal.UI.MsgBox(strText,{
							font = hVar.FONTC,
							ok = function()
								--
							end,
						})
						
						return
					end
					
					--可以升星
					--挡操作
					hUI.NetDisable(30000)
					
					--解锁甘宁功能
					if (not HeroCard) and (pvp_only) then
						--添加监听事件
						--监听收到pvp解锁回调事件
						hGlobal.event:listen("LocalEvent_Pvp_Hero_Unlock_Ok", "__PvpHeroStarUnlockBack_2", function(newHeroOk, tHero)
							--移除监听
							hGlobal.event:listen("LocalEvent_Pvp_Hero_Unlock_Ok", "__PvpHeroStarUnlockBack_2", nil)
							
							--去掉菊花
							hUI.NetDisable(0)
							
							--升星成功
							--local strText = "解锁成功！" --language
							local strText = hVar.tab_string["army_unlocksuccess"] --language
							hGlobal.UI.MsgBox(strText,{
								font = hVar.FONTC,
								ok = function()
									--刷新单个英雄卡牌的界面
									On_refresh_single_hero_card(typeId)
									
									--刷新本详细信息界面
									On_show_herocard_detail_info(button)
								end,
							})
						end)
						
						--发送解锁指令
						local heroId = typeId
						SendPvpCmdFunc["hero_unlock"](heroId)
					else
						--添加监听事件
						--监听收到pvp升星回调事件
						hGlobal.event:listen("LocalEvent_Pvp_Hero_StarLvup_Ok", "__PvpHeroStarLvupBack_2", function(cfg)
							--移除监听
							hGlobal.event:listen("LocalEvent_Pvp_Hero_StarLvup_Ok", "__PvpHeroStarLvupBack_2", nil)
							
							--去掉菊花
							hUI.NetDisable(0)
							
							--升星成功
							--local strText = "升星成功！" --language
							local strText = hVar.tab_string["hero_starupsuccess"] --language
							hGlobal.UI.MsgBox(strText,{
								font = hVar.FONTC,
								ok = function()
									--刷新单个英雄卡牌的界面
									On_refresh_single_hero_card(typeId)
									
									--刷新本详细信息界面
									On_show_herocard_detail_info(button)
								end,
							})
						end)
						
						--发送升星指令
						local heroId = typeId
						SendPvpCmdFunc["hero_star_lvup"](heroId)
					end
				end,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnStarUp"
			--英雄升满级级，碎片数量足够，未到顶星，才能升星
			if (currentLv >= maxLv) and (heroDebris >= costSoulStone) and (currentStar < maxStarLv) then
				hApi.AddShader(_frmNode.childUI["btnStarUp"].handle.s, "normal")
				
				--创建提示升星的跳动箭头
				_frmNode.childUI["heroStarUpJianTou"] = hUI.image:new({
					parent = _frmNode.handle._n,
					model = "ICON:image_jiantouV",
					x = offsetX + 32,
					y = offsetY + 111,
					w = 36,
					h = 36,
					align = "MC",
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroStarUpJianTou"
			else
				hApi.AddShader(_frmNode.childUI["btnStarUp"].handle.s, "gray")
			end
			
			--未获得该英雄，并且该英雄只有在竞技场获得，那么显示特别的升级箭头
			if (not HeroCard) and (pvp_only) then
				--
			else
				--升星按钮的升级小箭头
				_frmNode.childUI["btnStarUp"].childUI["UI_Arrow"] = hUI.image:new({
					parent = _frmNode.childUI["btnStarUp"].handle._n,
					model = "UI:UI_Arrow",
					scale = 0.7,
					roll = 90,
					x = 90,
				})
				_frmNode.childUI["btnStarUp"].childUI["UI_Arrow"].handle._n:setRotation(-90)
			end
		else
			--当前此英雄升星需要的游戏币文字前缀
			_frmNode.childUI["heroStarUpRmbPrefix"] = hUI.label:new({
				parent = _parentNode,
				y = 28,
				size = 24,
				align = "MC",
				--border = 1,
				x = offsetX + 92,
				y = offsetY - 317 - 40,
				font = hVar.FONTC,
				width = 300,
				--text = "已到顶星", --language
				text = hVar.tab_string["UpToMaxStar"], --language
				border = 1,
			})
			_frmNode.childUI["heroStarUpRmbPrefix"].handle.s:setColor(ccc3(255, 64, 0))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "heroStarUpRmbPrefix"
		end
		
		--显示右侧"加入配置"/"移除配置"按钮
		if (not bIgnoreOp) then
			On_add_or_remove_Cfg_button(button)
		end
	end
	
	--函数：创建单个塔卡牌的接口
	On_create_single_towercard_config_card = function(towerId, towerLv, posX, posY, bHaveThisTower, parent, zOrder)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--显示不超过最大等级
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		if (towerLv > maxLv) then
			towerLv = maxLv
		end
		
		--塔类卡牌的背景框
		local button = hUI.button:new({
			parent = parent,
			--mode = "imageButton",
			--dragbox = _frm.childUI["dragBox"], --作为button只是因为image的话，子控件显示异常，只能定义为button，但不接受事件
			model = "UI:slotBig", --"UI:pvpprivatesb" ..  towerLv,
			x = posX,
			y = posY,
			w = CONFIG_CARD_WIDTH - 1,
			h = CONFIG_CARD_HEIGHT - 1,
			scale = 1.0,
			align = "MC",
			scaleT = 1.0,
			--failcall = 1,
			z = zOrder,
			--点击事件
			--code = function(self, screenX, screenY, isInside)
				--print(index, screenX, screenY, isInside)
			--end,
		})
		--如果塔未获得，背景框灰掉
		if (not bHaveThisTower) then
			hApi.AddShader(button.handle.s, "gray")
		end
		
		--塔类卡牌的的图标
		button.childUI["towerIcon"]= hUI.image:new({
			parent = button.handle._n,
			model = hVar.tab_tactics[towerId].icon,
			x = 0,
			y = 12,
			w = 64,
			h = 64,
		})
		--如果塔未获得，图标灰掉
		if (not bHaveThisTower) then
			hApi.AddShader(button.childUI["towerIcon"].handle.s, "gray")
		end
		
		--已获得此塔
		if bHaveThisTower then
			--等级背景图
			button.childUI["LvBG"]= hUI.image:new({
				parent = button.handle._n,
				model = "ui/pvp/pvpselect.png",
				x = CONFIG_CARD_WIDTH - 48,
				y = 50,
				w = 34,
				h = 34,
			})
			
			--等级
			local fontSize = 24
			if towerLv and (towerLv >= 10) then --如果等级是2位数的，那么缩一下文字
				fontSize = 16
			end
			button.childUI["Lv"] = hUI.label:new({
				parent = button.handle._n,
				x = CONFIG_CARD_WIDTH - 48,
				y = 50 - 1,
				text = towerLv,
				size = fontSize,
				font = "numWhite",
				align = "MC",
				width = 200,
			})
		end
		
		--local towerUnitId = hVar.tab_tactics[towerId].remouldUnlock[towerLv][1] --对应的塔的单位
		--塔类卡牌的名字
		local nameFontSize = 24
		local nameText = hVar.tab_stringT[towerId] and hVar.tab_stringT[towerId][1] or ("未知塔" .. towerId)
		if (#nameText > 9) then
			nameFontSize = 18
		end
		button.childUI["name"] = hUI.label:new({
			parent = button.handle._n,
			x = 0,
			y = -38,
			size = nameFontSize,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 400,
			--text = hVar.tab_stringU[towerUnitId] and hVar.tab_stringU[towerUnitId][1] or ("未知塔" .. towerId),
			text = nameText,
		})
		--button.childUI["name"].handle.s:setColor(ccc3(164, 164, 164)) --变灰
		
		--[[
		--个数
		button.childUI["num"] = hUI.label:new({
			parent = button.handle._n,
			x = 18,
			y = -25,
			size = 16,
			align = "MC",
			border = 1,
			font = "numWhite",
			width = 400,
			text = "", --num, 这里不要显示数量了
		})
		--button.childUI["num"].handle.s:setColor(ccc3(164, 164, 164)) --变灰
		]]
		
		--ok图片
		button.childUI["ok"] = hUI.image:new({
			parent = button.handle._n,
			model = "UI:ok",
			x = 25,
			y = -35,
			w = 30,
			h = 30,
		})
		button.childUI["ok"].handle._n:setVisible(false) --默认隐藏
		
		--[[
		--本卡牌添加子控件-使用的背景图
		button.childUI["imgUse"]= hUI.image:new({
			parent = button.handle._n,
			model = "ui/Purchase_Button.png",
			x = 0,
			y = -CONFIG_CARD_HEIGHT / 2 + 16,
			w = CONFIG_CARD_WIDTH,
			h = 40,
		})
		button.childUI["imgUse"].handle._n:setVisible(false) --默认隐藏
		
		--本卡牌添加子控件-使用的背景图
		button.childUI["labelUse"]= hUI.label:new({
			parent = button.handle._n,
			x = 0,
			y = -CONFIG_CARD_HEIGHT / 2 + 16,
			w = CONFIG_CARD_WIDTH,
			size = 28,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 360,
			--text = "使用", --language
			text = hVar.tab_string["__TEXT_Use"],  --language
		})
		button.childUI["labelUse"].handle._n:setVisible(false) --默认隐藏
		]]
		
		--[[
		--按钮选中框
		local scaleX = (CONFIG_CARD_WIDTH + 4) / 72
		local scaleY = (CONFIG_CARD_HEIGHT + 4) / 72
		button.childUI["selectbox"] = hUI.image:new({
			parent = button.handle._n,
			model = "UI:TacTicFrame",
			align = "MC",
			w = CONFIG_CARD_WIDTH + 4,
			h = CONFIG_CARD_HEIGHT + 4,
			z = 1,
		})
		button.childUI["selectbox"].handle._n:setVisible(false) --默认隐藏
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, scaleX - 0.015, scaleY - 0.015), CCScaleTo:create(0.6, scaleX + 0.025, scaleY + 0.025))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		button.childUI["selectbox"].handle.s:runAction(forever)
		]]
		
		--[[
		--塔卡的等级的背景图
		button.childUI["LvBG"]= hUI.image:new({
			parent = button.handle._n,
			model = "ui/pvp/pvpselect.png",
			x = HERO_CARD_WIDTH - 51,
			y = 41,
			w = 34,
			h = 34,
		})
		
		--塔卡的等级
		local fontSize = 26
		if towerLv and (towerLv >= 10) then
			fontSize = 18
		end
		button.childUI["Lv"] = hUI.label:new({
			parent = button.handle._n,
			x = HERO_CARD_WIDTH - 51,
			y = 40,
			text = towerLv or 1,
			size = fontSize,
			font = "numWhite",
			align = "MC",
			width = 200,
		})
		]]
		return button
	end
	
	--函数：创建单个塔卡牌的接口（简版）
	On_create_single_towercard_config_card_tiny = function(towerId, towerLv, posX, posY, bHaveThisTower, parent, zOrder)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--显示不超过最大等级（简版）
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		if (towerLv > maxLv) then
			towerLv = maxLv
		end
		
		--塔类卡牌的背景框（简版）
		local button = hUI.button:new({
			parent = parent,
			--mode = "imageButton",
			--dragbox = _frm.childUI["dragBox"], --作为button只是因为image的话，子控件显示异常，只能定义为button，但不接受事件
			model = hVar.tab_tactics[towerId].icon,
			x = posX,
			y = posY,
			w = 56,
			h = 56,
			scale = 1.0,
			align = "MC",
			scaleT = 1.0,
			--failcall = 1,
			z = zOrder,
			--点击事件
			--code = function(self, screenX, screenY, isInside)
				--print(index, screenX, screenY, isInside)
			--end,
		})
		--如果塔未获得，背景框灰掉（简版）
		if (not bHaveThisTower) then
			hApi.AddShader(button.handle.s, "gray")
		end
		
		--已获得此塔（简版）
		if bHaveThisTower then
			--等级背景图（简版）
			button.childUI["LvBG"]= hUI.image:new({
				parent = button.handle._n,
				model = "ui/pvp/pvpselect.png",
				x = CONFIG_CARD_WIDTH - 65,
				y = 17,
				w = 34,
				h = 34,
			})
			
			--等级（简版）
			local fontSize = 24
			if towerLv and (towerLv >= 10) then --如果等级是2位数的，那么缩一下文字
				fontSize = 16
			end
			button.childUI["Lv"] = hUI.label:new({
				parent = button.handle._n,
				x = CONFIG_CARD_WIDTH - 65,
				y = 17 - 1,
				text = towerLv,
				size = fontSize,
				font = "numWhite",
				align = "MC",
				width = 200,
			})
		end
		
		return button
	end
	
	--函数：显示塔卡牌的详细信息
	On_show_towercard_detail_info = function(button, bIgnoreOp)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--先清除上一次的右侧控件集
		_removeRightFrmFunc()
		
		--绘制本次的
		local towerId = button.data.id --塔类战术技能卡id
		local towerLv = button.data.lv --塔类战术技能卡等级
		--print(towerId, towerLv)
		if (towerLv == 0) then --为了处理无尽模式，为了显示禁用的塔，这里的等级可能为0
			towerLv = 1
		end
		local towerUnitId = hVar.tab_tactics[towerId].remouldUnlock[towerLv][1] --对应的塔的单位
		local intro = hVar.tab_stringU[towerId] and hVar.tab_stringU[towerUnitId][2] or ("无")
		local name = hVar.tab_stringT[towerId] and hVar.tab_stringT[towerId][1] or ("未知" .. towerId)
		local lv = button.data.lv --战术技能卡id
		
		--显示不超过最大等级
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		if (lv > maxLv) then
			lv = maxLv
		end
		
		--显示不超过最大等级
		local maxLv = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		if (towerLv > maxLv) then
			towerLv = maxLv
		end
		towerLv = 10 --pvp模式为10级
		local towerUnitId = hVar.tab_tactics[towerId].remouldUnlock[towerLv][1] --对应的塔基的单位
		local basetowerId = hVar.tab_tactics[towerId].remouldUnlock.baseTowerId --对应的塔基单位
		--print("basetowerId", basetowerId)
		local tUnitTab = hVar.tab_unit[towerUnitId] or {}
		local attr = tUnitTab.attr or {}
		local atkMin = attr.attack and attr.attack[4] or "?" --最小攻击力
		local atkMax = attr.attack and attr.attack[5] or "?" --最大攻击力
		local atkRange = attr.atk_radius or "?" --攻击范围
		local hp = attr.hp or "?" --血量
		local moveSpeed = attr.move_speed or "?" --移动速度
		local atkSpeed = (attr.atk_interval or 0) / 1000 --攻击速度
		local pDef = attr.def_physic --物理防御
		local mDef = attr.def_magic --法术防御
		local upgradeSkill = tUnitTab.td_upgrade and tUnitTab.td_upgrade.upgradeSkill or {} --技能升级列表
		
		local DETAIL_OFFSET_X = 6 - 568 --详细信息面板的x偏移值
		local DETAIL_OFFSET_Y = 55 --详细信息面板的y偏移值
		
		--塔的头像
		_frmNode.childUI["towerIcon"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = hVar.tab_tactics[towerId].icon,
			x = BOARD_WIDTH - 230 + DETAIL_OFFSET_X,
			y = -BOARD_HEIGHT / 2 + 210 + DETAIL_OFFSET_Y,
			w = 64,
			h = 64,
			align = "MC",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "towerIcon"
		
		--塔名字
		_frmNode.childUI["detail_info_name"] = hUI.label:new({
			parent = _parentNode,
			size = 34,
			align = "LC",
			border = 1,
			x = BOARD_WIDTH - 190 + DETAIL_OFFSET_X,
			y = -BOARD_HEIGHT / 2 + 208 + DETAIL_OFFSET_Y,
			font = hVar.FONTC,
			width = 360,
			text = name,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "detail_info_name"
		
		--塔说明
		_frmNode.childUI["detail_info_intro"] = hUI.label:new({
			parent = _parentNode,
			y = 28,
			size = 26,
			align = "LT",
			border = 1,
			x = BOARD_WIDTH - 265 + DETAIL_OFFSET_X,
			y = -BOARD_HEIGHT / 2 + 160 + DETAIL_OFFSET_Y,
			font = hVar.FONTC,
			width = 230,
			text = intro,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "detail_info_intro"
		
		--分割线1
		_frmNode.childUI["towerSeparateLine1"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = "UI:Tactic_SeparateLine",
			x = BOARD_WIDTH + DETAIL_OFFSET_X - 152,
			y = -BOARD_HEIGHT / 2 + DETAIL_OFFSET_Y + 67,
			w = 250,
			h = 4,
			align = "MC",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "towerSeparateLine1"
		
		local offsetX = BOARD_WIDTH - 250 + DETAIL_OFFSET_X
		local offsetY = -BOARD_HEIGHT / 2 + 76 + DETAIL_OFFSET_Y
		
		--攻击力图标
		local towerAtkIcon = nil --塔的攻击力图标
		
		if tUnitTab.tag and (tUnitTab.tag[hVar.UNIT_TAG_TYPE.TOWER.TAG_JIANTA]) then --箭塔系
			towerAtkIcon = "ui/battle_attack02.png"
		elseif tUnitTab.tag and (tUnitTab.tag[hVar.UNIT_TAG_TYPE.TOWER.TAG_FASHUTA]) then --法术塔系
			towerAtkIcon = "ui/battle_attack03.png"
		elseif tUnitTab.tag and (tUnitTab.tag[hVar.UNIT_TAG_TYPE.TOWER.TAG_PAOTA]) then --炮塔系
			towerAtkIcon = "ui/battle_move.png"
		else
			towerAtkIcon = "ICON:action_attack"
		end
		_frmNode.childUI["towerAttrAtkIcon"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = towerAtkIcon,
			x = offsetX - 3,
			y = offsetY - 30,
			w = 26,
			h = 26,
			align = "MC",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "towerAttrAtkIcon"
		
		--攻击力文字
		local atkValTotal = atkMin .. "-" .. atkMax
		local atkSize = 22
		if (#atkValTotal > 6) then --如果攻击力文字太长，缩小文字大小
			atkSize = 16
		elseif (#atkValTotal > 5) then --如果攻击力文字太长，缩小文字大小
			atkSize = 18
		end
		_frmNode.childUI["towerAttrAtkValue"] = hUI.label:new({
			parent = _parentNode,
			size = atkSize,
			align = "LC",
			--border = 1,
			x = offsetX + 20 - 3,
			y = offsetY - 30 - 2, --num字体有2像素偏差
			font = "numWhite",
			width = 210,
			text = atkValTotal,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "towerAttrAtkValue"
		
		--射程图标
		_frmNode.childUI["towerAttrAtkRange"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = "ICON:MOVERANGE", --"UI:Attr_AtkRange",
			x = offsetX + 120 + 5,
			y = offsetY - 30,
			w = 26,
			h = 26,
			align = "MC",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "towerAttrAtkRange"
		
		--射程文字
		_frmNode.childUI["towerAttrAtkRangeValue"] = hUI.label:new({
			parent = _parentNode,
			size = 22,
			align = "LC",
			--border = 1,
			x = offsetX + 20 + 120 + 5,
			y = offsetY - 30 - 2, --num字体有2像素偏差
			font = "numWhite",
			width = 210,
			text = atkRange,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "towerAttrAtkRangeValue"
		
		--攻击速度图标
		_frmNode.childUI["towerAttrAtkSpeed"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = "ICON:MOVESPEED", --"UI:Attr_CD",
			x = offsetX - 3,
			y = offsetY - 65,
			w = 26,
			h = 26,
			align = "MC",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "towerAttrAtkSpeed"
		
		--攻击速度文字
		_frmNode.childUI["towerAttrAtkSpeedValue"] = hUI.label:new({
			parent = _parentNode,
			size = 22,
			align = "LC",
			--border = 1,
			x = offsetX + 20 - 3,
			y = offsetY - 65 - 2, --num字体有2像素偏差
			font = "numWhite",
			width = 210,
			--text = ("%d.%d"):format(math.floor(atkSpeed), math.floor((atkSpeed - math.floor(atkSpeed)) * 100)) --保留2位有效数字
			text = string.format("%.2f", atkSpeed), --保留2位有效数字
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "towerAttrAtkSpeedValue"
		
		--[[
		--攻击速度符号文字
		_frmNode.childUI["towerAttrAtkSpeedSign"] = hUI.label:new({
			parent = _parentNode,
			size = 26,
			align = "LC",
			border = 1,
			x = offsetX + 40 + 38 - 3,
			y = offsetY - 60,
			font = hVar.DEFAULT_FONT,
			width = 210,
			text = "s",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "towerAttrAtkSpeedSign"
		--_frmNode.childUI["towerAttrAtkSpeedSign"].handle.s:setColor(ccc3(255, 255, 0))
		]]
		
		--需要的金币图标
		_frmNode.childUI["towerAttrGold"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = "UI:ICON_ResourceGold",
			x = offsetX + 120 + 5,
			y = offsetY - 65,
			w = 32,
			h = 32,
			align = "MC",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "towerAttrGold"
		
		--计算需要消耗的金币
		local remouldCost = 0
		if (type(basetowerId) == "table") then
			basetowerId = basetowerId[2] --pvp填第2项
		end
		
		local td_upgrade = hVar.tab_unit[basetowerId].td_upgrade --zhenkira 2015.9.25 修改为角色身上的属性,并且使用kv形式存储表结构
		if td_upgrade and type(td_upgrade) == "table" then
			local remould = td_upgrade.remould
			if remould then
				local buildInfo = remould[towerUnitId]
				remouldCost = (buildInfo and buildInfo.cost or 0) + (buildInfo and buildInfo.costAdd or 0)
			end
		end
		
		--需要的金币文字
		_frmNode.childUI["towerAttrGoldValue"] = hUI.label:new({
			parent = _parentNode,
			size = 22,
			align = "LC",
			--border = 1,
			x = offsetX + 20 + 120 + 5,
			y = offsetY - 65 - 2, --num字体有2像素偏差
			font = "numWhite",
			width = 210,
			text = remouldCost,
			border = 0,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "towerAttrGoldValue"
		
		--分割线2
		_frmNode.childUI["towerSeparateLine2"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = "UI:Tactic_SeparateLine",
			x = BOARD_WIDTH + DETAIL_OFFSET_X - 152,
			y = -BOARD_HEIGHT / 2 + DETAIL_OFFSET_Y - 17,
			w = 250,
			h = 4,
			align = "MC",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "towerSeparateLine2"
		
		--塔的技能图标
		if upgradeSkill then
			local skillList = {} --实际的技能排序列表
			
			if upgradeSkill.order and type(upgradeSkill.order) == "table" then
				for i = 1, # upgradeSkill.order do
					local skillId =  upgradeSkill.order[i]
					
					if upgradeSkill[skillId] then
						table.insert(skillList, skillId) --添加塔的技能（有序）
					end
				end
			else
				for skillId, v in pairs(upgradeSkill) do
					if (skillId ~= "order") then
						table.insert(skillList, skillId) --添加塔的技能（乱序）
					end
				end
			end
			
			--依次绘制塔的技能图标
			local skillDy = 70
			local skillWH = 56
			for i = 1, #skillList, 1 do
				local skillId = skillList[i]
				local v = upgradeSkill[skillId]
				
				--技能响应点击事件的按钮区域
				_frmNode.childUI["towerAttrSkillBtn" .. i] = hUI.button:new({
					parent = _frmNode.handle._n,
					model = "misc/mask.png",
					x = offsetX - 48 + (skillWH + 6) + 85,
					y = offsetY - skillDy - i * (skillWH + 10),
					w = 254,
					h = 62,
					align = "MC",
					dragbox = _frm.childUI["dragBox"],
					code = function()
						--显示塔技能tip
						--hGlobal.event:event("LocalEvent_ShowSkillInfoFram", towerUnitId, skillId, 150, 600)
						hApi.ShowSkillTip(skillId, nil)
					end,
				})
				_frmNode.childUI["towerAttrSkillBtn" .. i].handle.s:setOpacity(0) --只用于响应事件，不显示
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "towerAttrSkillBtn" .. i
				
				--技能图标
				_frmNode.childUI["towerAttrSkill" .. i] = hUI.image:new({
					parent = _frmNode.handle._n,
					model = v.icon,
					x = offsetX - 48 + (skillWH + 6),
					y = offsetY - skillDy - i * (skillWH + 10),
					w = skillWH,
					h = skillWH,
					align = "MC",
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "towerAttrSkill" .. i
				
				--技能名称
				local skillName = hVar.tab_stringS[skillId] and hVar.tab_stringS[skillId][1] or ("未知技能" .. skillId)
				_frmNode.childUI["towerAttrSkillName" .. i] = hUI.label:new({
					parent = _parentNode,
					size = 26,
					align = "LT",
					border = 1,
					x = offsetX - 44 + (skillWH + 6) + 32,
					y = offsetY - skillDy - 1 - i * (skillWH + 10) + 28,
					font = hVar.FONTC,
					width = 210,
					text = skillName,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "towerAttrSkillName" .. i
				--_frmNode.childUI["towerAttrSkillName" .. i].handle.s:setColor(ccc3(255, 255, 0))
				
				--技能升级需要的金币图标
				_frmNode.childUI["towerAttrSkillGold" .. i] = hUI.image:new({
					parent = _parentNode,
					model = "UI:ICON_ResourceGold",
					x = offsetX - 43 + (skillWH + 6) + 48,
					y = offsetY - skillDy - 9 - i * (skillWH + 10) - 5,
					w = 32,
					h = 32,
					align = "MC",
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "towerAttrSkillGold" .. i
				
				--计算升级技能需要消耗的金币
				local skillCost = 0
				local td_upgrade = hVar.tab_unit[towerUnitId].td_upgrade --zhenkira 2015.9.25 修改为角色身上的属性,并且使用kv形式存储表结构
				if td_upgrade and (type(td_upgrade) == "table") then
					local upgradeSkill = td_upgrade.upgradeSkill
					if upgradeSkill then
						local buildInfo = upgradeSkill[skillId]
						if buildInfo then
							skillCost = buildInfo.cost and buildInfo.cost[1] or 0
						end
					end
				end
				
				--技能升级需要的金币文字
				_frmNode.childUI["towerAttrSkillGoldValue" .. i] = hUI.label:new({
					parent = _parentNode,
					size = 22,
					align = "LC",
					x = offsetX - 43 + (skillWH + 6) + 66,
					y = offsetY - skillDy - 9 - i * (skillWH + 10) - 5 - 2, --num字体有2像素偏差
					font = "numWhite",
					width = 210,
					text = skillCost,
					border = 0,
				})
				_frmNode.childUI["towerAttrSkillGoldValue" .. i].handle.s:setColor(ccc3(255, 255, 248)) --淡黄色
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "towerAttrSkillGoldValue" .. i
				
				--[[
				--技能描述
				v.maxLv = 1 --pvp技能只升级1次
				--local skillIntro = hVar.tab_stringS[skillId] and hVar.tab_stringS[skillId][2] or ("未知技能说明" .. skillId)
				--local skillIntro = "最高可升级" .. (v.maxLv or 1) .. "次" --language
				local skillIntro = hVar.tab_string["CanLvUpMax"] .. (v.maxLv or 1) .. hVar.tab_string["__TEXT_YouCanForgedCount1"] --language
				
				if (v.maxLv == 0) then
					--skillIntro = "未解锁升级该技能" --language
					skillIntro = hVar.tab_string["CanNotLvUp"] --language
				end
				_frmNode.childUI["towerAttrSkillIntro" .. i] = hUI.label:new({
					parent = _parentNode,
					size = 22,
					align = "LT",
					border = 1,
					x = offsetX - 43 + (skillWH + 6) + 28,
					y = offsetY - skillDy - 14 - i * (skillWH + 2) + 10,
					font = hVar.FONTC,
					width = 170,
					text = skillIntro,
				})
				_frmNode.childUI["towerAttrSkillIntro" .. i].handle.s:setColor(ccc3(0, 255, 0))
				if (v.maxLv == 0) then
					_frmNode.childUI["towerAttrSkillIntro" .. i].handle.s:setColor(ccc3(255, 0, 0))
				end
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "towerAttrSkillIntro" .. i
				]]
			end
		end
		
		--显示右侧"加入配置"/"移除配置"按钮
		if (not bIgnoreOp) then
			On_add_or_remove_Cfg_button(button)
		end
	end
	
	--函数：创建单个兵种卡牌的接口
	On_create_single_armycard_config_card = function(tacticId, tacticLv, posX, posY, bHaveThisTactic, parent, zOrder)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--显示不超过最大等级
		local maxLv = hVar.TACTIC_LVUP_INFO.maxArmyLv or 1
		if (tacticLv > maxLv) then
			tacticLv = maxLv
		end
		
		--兵种类卡牌的背景框
		local button = hUI.button:new({
			parent = parent,
			--mode = "imageButton",
			--dragbox = _frm.childUI["dragBox"], --作为button只是因为image的话，子控件显示异常，只能定义为button，但不接受事件
			model = "UI:tactic_card_1",
			x = posX,
			y = posY,
			w = CONFIG_CARD_WIDTH,
			h = CONFIG_CARD_HEIGHT,
			scale = 1.0,
			align = "MC",
			scaleT = 1.0,
			--failcall = 1,
			z = zOrder,
			--点击事件
			--code = function(self, screenX, screenY, isInside)
				--print(index, screenX, screenY, isInside)
			--end,
		})
		--如果兵种未获得，背景框灰掉
		if (not bHaveThisTactic) then
			hApi.AddShader(button.handle.s, "gray")
		end
		
		--兵种类卡牌的的图标
		button.childUI["towerIcon"]= hUI.image:new({
			parent = button.handle._n,
			model = hVar.tab_tactics[tacticId].icon,
			x = 0,
			y = 1,
			w = 52,
			h = 52,
		})
		--如果兵种未获得，图标灰掉
		if (not bHaveThisTactic) then
			hApi.AddShader(button.childUI["towerIcon"].handle.s, "gray")
		end
		
		--战术技能卡类型图标
		button.childUI["typeicon"] = hUI.image:new({
			parent = button.handle._n,
			model = hApi.GetTacticsCardTypeIcon(tacticId, "model"),
			x = -2,
			y = 42,
			w = 26,
			h = 26,
		})
		--如果兵种未获得，类型图标灰掉
		if (not bHaveThisTactic) then
			hApi.AddShader(button.childUI["typeicon"].handle.s, "gray")
		end
		
		--local towerUnitId = hVar.tab_tactics[tacticId].remouldUnlock[tacticLv][1] --对应的兵种的单位
		--兵种类卡牌的名字
		local nameFontSize = 24
		local nameText = hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][1] or ("未知兵种" .. tacticId)
		if (#nameText > 9) then
			nameFontSize = 18
		end
		button.childUI["name"] = hUI.label:new({
			parent = button.handle._n,
			x = 0,
			y = -41,
			size = nameFontSize,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 400,
			--text = hVar.tab_stringU[towerUnitId] and hVar.tab_stringU[towerUnitId][1] or ("未知兵种" .. tacticId),
			text = nameText,
		})
		--button.childUI["name"].handle.s:setColor(ccc3(164, 164, 164)) --变灰
		
		--[[
		--个数
		button.childUI["num"] = hUI.label:new({
			parent = button.handle._n,
			x = 18,
			y = -25,
			size = 16,
			align = "MC",
			border = 1,
			font = "numWhite",
			width = 400,
			text = "", --num, 这里不要显示数量了
		})
		--button.childUI["num"].handle.s:setColor(ccc3(164, 164, 164)) --变灰
		]]
		
		--兵种提示升级的跳动箭头
		button.childUI["armyStarUp_JianTou"] = hUI.image:new({
			parent = button.handle._n,
			model = "ICON:image_jiantouV",
			x = 7,
			y = -3,
			w = 32,
			h = 32,
		})
		button.childUI["armyStarUp_JianTou"].handle.s:setVisible(false) --默认不显示
		--如果碎片数量足够，未到顶级，那么提示可升级
		local armLvupInfo = hVar.tab_tactics[tacticId].armLvupInfo
		local material = armLvupInfo[tacticLv] and armLvupInfo[tacticLv].material or {} --升到下一级需要材料
		
		--兵种碎片足够，未到顶级，才能升级
		local bDebrisEnough = true --碎片是否足够
		for i = 1, #material, 1 do
			--兵种卡升级信息
			local requireTacticId = material[i].id --升到下一级需要的兵种id
			local requireDebris = material[i].num or 500 --升到下一级需要的碎片
			local debris = g_myPvP_BaseInfo.tacticInfo[requireTacticId] and g_myPvP_BaseInfo.tacticInfo[requireTacticId].debris or 0 --本兵种卡当前碎片数量
			if (debris < requireDebris) then
				bDebrisEnough = false --碎片不足
			end
		end
		local maxLv = hVar.TACTIC_LVUP_INFO.maxArmyLv or 1
		if (bDebrisEnough) and (tacticLv < maxLv) then
			button.childUI["armyStarUp_JianTou"].handle.s:setVisible(true) --显示
		end
		
		--ok图片
		button.childUI["ok"] = hUI.image:new({
			parent = button.handle._n,
			model = "UI:ok",
			x = 25,
			y = -35,
			w = 30,
			h = 30,
		})
		button.childUI["ok"].handle._n:setVisible(false) --默认隐藏
		
		--[[
		--本卡牌添加子控件-使用的背景图
		button.childUI["imgUse"]= hUI.image:new({
			parent = button.handle._n,
			model = "ui/Purchase_Button.png",
			x = 0,
			y = -CONFIG_CARD_HEIGHT / 2 + 16,
			w = CONFIG_CARD_WIDTH,
			h = 40,
		})
		button.childUI["imgUse"].handle._n:setVisible(false) --默认隐藏
		
		--本卡牌添加子控件-使用的背景图
		button.childUI["labelUse"]= hUI.label:new({
			parent = button.handle._n,
			x = 0,
			y = -CONFIG_CARD_HEIGHT / 2 + 16,
			w = CONFIG_CARD_WIDTH,
			size = 28,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 360,
			--text = "使用", --language
			text = hVar.tab_string["__TEXT_Use"],  --language
		})
		button.childUI["labelUse"].handle._n:setVisible(false) --默认隐藏
		]]
		
		--[[
		--按钮选中框
		local scaleX = (CONFIG_CARD_WIDTH + 4) / 72
		local scaleY = (CONFIG_CARD_HEIGHT + 4) / 72
		button.childUI["selectbox"] = hUI.image:new({
			parent = button.handle._n,
			model = "UI:TacTicFrame",
			align = "MC",
			w = CONFIG_CARD_WIDTH + 4,
			h = CONFIG_CARD_HEIGHT + 4,
			z = 1,
		})
		button.childUI["selectbox"].handle._n:setVisible(false) --默认隐藏
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, scaleX - 0.015, scaleY - 0.015), CCScaleTo:create(0.6, scaleX + 0.025, scaleY + 0.025))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		button.childUI["selectbox"].handle.s:runAction(forever)
		]]
		
		--[[
		--兵种卡的等级的背景图
		button.childUI["LvBG"]= hUI.image:new({
			parent = button.handle._n,
			model = "ui/pvp/pvpselect.png",
			x = HERO_CARD_WIDTH - 51,
			y = 41,
			w = 34,
			h = 34,
		})
		
		--兵种卡的等级
		local fontSize = 26
		if tacticLv and (tacticLv >= 10) then
			fontSize = 18
		end
		button.childUI["Lv"] = hUI.label:new({
			parent = button.handle._n,
			x = HERO_CARD_WIDTH - 51,
			y = 40,
			text = tacticLv or 1,
			size = fontSize,
			font = "numWhite",
			align = "MC",
			width = 200,
		})
		]]
		return button
	end
	
	--函数：创建单个兵种卡牌的接口（简版）
	On_create_single_armycard_config_card_tiny = function(tacticId, tacticLv, posX, posY, bHaveThisTactic, parent, zOrder)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--显示不超过最大等级
		local maxLv = hVar.TACTIC_LVUP_INFO.maxArmyLv or 1
		if (tacticLv > maxLv) then
			tacticLv = maxLv
		end
		
		--兵种类卡牌的背景框
		local button = hUI.button:new({
			parent = parent,
			model = hVar.tab_tactics[tacticId].icon,
			x = posX,
			y = posY,
			w = 56,
			h = 56,
			scale = 1.0,
			align = "MC",
			scaleT = 1.0,
			--failcall = 1,
			z = zOrder,
			--点击事件
			--code = function(self, screenX, screenY, isInside)
				--print(index, screenX, screenY, isInside)
			--end,
		})
		--如果兵种未获得，背景框灰掉
		if (not bHaveThisTactic) then
			hApi.AddShader(button.handle.s, "gray")
		end
		
		return button
	end
	
	--函数：显示兵种卡的详细信息
	On_show_armycard_detail_info = function(button, bIgnoreOp)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--先清除上一次的右侧控件集
		_removeRightFrmFunc()
		
		--绘制本次的
		local tacticId = button.data.id --战术技能卡id
		local name = hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][1] or ("未知" .. tacticId)
		local lv = button.data.lv --战术技能卡id
		
		--显示不超过最大等级
		local maxLv = hVar.TACTIC_LVUP_INFO.maxArmyLv or 1
		if (lv > maxLv) then
			lv = maxLv
		end
		
		--intro = hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][2] or ("无")
		local intro = "" --战术技能卡上面不显示文字
		
		local tacticLv = button.data.lv
		local tabTactic = hVar.tab_tactics[tacticId] --战术技能卡表
		local activeSkill = tabTactic.activeSkill --主动技能表
		local effectRange = "N/A" --技能生效的范围
		local gold = "N/A" --技能消耗的金币
		local cooldown = "N/A" --技能冷却时间
		if (activeSkill) and (activeSkill ~= 0) then --存在主动技能
			--local castType = activeSkill.type --技能释放的类型
			--local activeSkillId = activeSkill.id --主动技能id
			effectRange = activeSkill.effectRange[tacticLv] or 0 --技能生效的范围
			gold = activeSkill.costMana[tacticLv] or 0 --技能消耗的金币
			cooldown = activeSkill.cd[tacticLv] or 0 --技能冷却时间
		end
		
		local DETAIL_OFFSET_X = 6 - 568 --详细信息面板的x偏移值
		local DETAIL_OFFSET_Y = 55 --详细信息面板的y偏移值
		
		--战术技能卡的图标
		_frmNode.childUI["tacticIcon"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = hVar.tab_tactics[tacticId].icon,
			x = BOARD_WIDTH - 230 + DETAIL_OFFSET_X,
			y = -BOARD_HEIGHT / 2 + 210 + DETAIL_OFFSET_Y,
			w = 64,
			h = 64,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "tacticIcon"
		
		--兵种名字
		_frmNode.childUI["detail_info_name"] = hUI.label:new({
			parent = _parentNode,
			size = 34,
			align = "LC",
			border = 1,
			x = BOARD_WIDTH - 190 + DETAIL_OFFSET_X,
			y = -BOARD_HEIGHT / 2 + 208 + DETAIL_OFFSET_Y,
			font = hVar.FONTC,
			width = 360,
			text = name,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "detail_info_name"
		
		local offsetX = BOARD_WIDTH - 250 + DETAIL_OFFSET_X
		local offsetY = -BOARD_HEIGHT / 2 + 90 + DETAIL_OFFSET_Y
		
		--消耗的金币图标
		_frmNode.childUI["tacticAttrGold"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = "UI:ICON_ResourceGold",
			x = offsetX,
			y = offsetY + 62 - 2,
			w = 32,
			h = 32,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "tacticAttrGold"
		
		--消耗的金币文字
		local tacticSkillId = hVar.tab_tactics[tacticId].castSkillUnlock.unlockSkillId[1]
		local targetId = hVar.tab_tactics[tacticId].castSkillUnlock.targetId[1]
		local goldCost = hVar.tab_unit[targetId].td_upgrade.castSkill[tacticSkillId].cost
		_frmNode.childUI["tacticAttrGoldValue"] = hUI.label:new({
			parent = _parentNode,
			size = 20,
			align = "LC",
			--border = 1,
			x = offsetX + 24,
			y = offsetY + 62 - 4, --num字体有4像素偏差
			font = "numWhite",
			width = 210,
			text = goldCost,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "tacticAttrGoldValue"
		
		--兵符图标
		_frmNode.childUI["tacticAttrPvpCoin"] = hUI.image:new({
			parent = _frmNode.handle._n,
			model = "UI:uitoken",
			x = offsetX + 130,
			y = offsetY + 62,
			scale = 0.85,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "tacticAttrPvpCoin"
		
		--兵符消耗值
		_frmNode.childUI["tacticAttrPvpCoinValue"] = hUI.label:new({
			parent = _parentNode,
			size = 20,
			align = "LC",
			--border = 1,
			x = offsetX + 130 + 20,
			y = offsetY + 62 - 4, --num字体有4像素偏差
			font = "numWhite",
			width = 210,
			text = "1",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "tacticAttrPvpCoinValue"
		
		local nShowIntroLv = math.max(1, tacticLv)
		local skillIntro = hVar.tab_stringT[tacticId] and hVar.tab_stringT[tacticId][nShowIntroLv + 1] or ("无")
		--战术技能卡技能描述
		_frmNode.childUI["tacticAttrSkillIntro"] = hUI.label:new({
			parent = _parentNode,
			size = 26,
			align = "LT",
			border = 1,
			x = offsetX - 20,
			y = offsetY + 35,
			font = hVar.FONTC,
			width = 240,
			text = skillIntro,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "tacticAttrSkillIntro"
		
		--战术技能卡碎片数量
		local armLvupInfo = hVar.tab_tactics[tacticId].armLvupInfo
		local material = armLvupInfo[tacticLv] and armLvupInfo[tacticLv].material or {} --升到下一级需要材料
		local requireScore = armLvupInfo[tacticLv] and armLvupInfo[tacticLv].score or 0 --升到下一级需要的积分
		local requireRmb = armLvupInfo[tacticLv] and armLvupInfo[tacticLv].gold or 0 --升到下一级需要的游戏币
		local matDy = -104
		for i = 1, #material, 1 do
			--兵种卡升级信息
			local requireTacticId = material[i].id --升到下一级需要的兵种id
			local requireDebris = material[i].num or 500 --升到下一级需要的碎片
			local debris = g_myPvP_BaseInfo.tacticInfo[requireTacticId] and g_myPvP_BaseInfo.tacticInfo[requireTacticId].debris or 0 --本兵种卡当前碎片数量
			--print(requireTacticId, requireDebris, debris)
			
			--绘制按钮响应点击事件的区域
			_frmNode.childUI["tacticDebrisBtn" .. i] = hUI.button:new({
				parent = _frmNode.handle._n,
				model = "masc./misc.png",
				dragbox = _frm.childUI["dragBox"],
				x = BOARD_WIDTH + DETAIL_OFFSET_X - 245 + 95,
				y = -BOARD_HEIGHT / 2 + DETAIL_OFFSET_Y + 21 - 100 + matDy + (i - 1) * 45 - 40,
				w = 256,
				h = 44,
				code = function()
					--显示战术技能卡的tip
					local rewardType = 6 --碎片类型
					local tacticLv = 1
					hApi.ShowTacticCardTip(rewardType, requireTacticId, tacticLv, tacticId)
				end,
			})
			_frmNode.childUI["tacticDebrisBtn" .. i].handle.s:setOpacity(0) --只用于控制，不显示
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "tacticDebrisBtn" .. i
			
			--绘制需要的战术卡的碎片图标
			--战术技能卡的碎片图标
			_frmNode.childUI["tacticDebrisIcon" .. i] = hUI.image:new({
				parent = _frmNode.handle._n,
				model = hVar.tab_tactics[requireTacticId].icon,
				x = BOARD_WIDTH + DETAIL_OFFSET_X - 245,
				y = -BOARD_HEIGHT / 2 + DETAIL_OFFSET_Y + 21 - 100 + matDy + (i - 1) * 45 - 40,
				w = 34,
				h = 34,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "tacticDebrisIcon" .. i
			
			--碎片图标
			_frmNode.childUI["debrisIcon" .. i] = hUI.image:new({
				parent = _frmNode.handle._n,
				model = "UI:SoulStoneFlag",
				x = BOARD_WIDTH + DETAIL_OFFSET_X - 245 + 8,
				y = -BOARD_HEIGHT / 2 + DETAIL_OFFSET_Y + 21 - 4 - 100 + matDy + (i - 1) * 45 - 40,
				w = 28,
				h = 41,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "debrisIcon" .. i
			
			local ACHIEVEMENT_WIDTH = 230
			--战术技能卡碎片进度条
			_frmNode.childUI["tacticDebrisProgress" .. i] = hUI.valbar:new({
				parent = _parentNode,
				x = offsetX + 92 - 51,
				y = offsetY - 240 + 70 + matDy + (i - 1) * 45 - 40,
				w = ACHIEVEMENT_WIDTH - 64,
				h = 30,
				align = "LC",
				back = {model = "UI:SoulStoneBarBg1", x = -5, y = 0, w = ACHIEVEMENT_WIDTH - 56, h = 30 + 6},
				model = "UI:SoulStoneBar1",
				v = debris,
				max = requireDebris,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "tacticDebrisProgress" .. i
			
			--战术技能卡碎片进度文字
			local showNumText = (debris .. "/" .. requireDebris)
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
			_frmNode.childUI["tacticDebrisProgressLabel" .. i] = hUI.label:new({
				parent = _parentNode,
				x = offsetX + 122,
				y = offsetY - 240 + 70 + matDy + (i - 1) * 45 - 40,
				size = 26,
				align = "MC",
				--font = hVar.FONTC,
				font = "numWhite",
				text = showNumText,
				scale = scaleText
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "tacticDebrisProgressLabel" .. i
		end
		
		--未到顶级，可以升级
		if (tacticLv < maxLv) then
			--分割线1
			_frmNode.childUI["tacticSeparateLine1"] = hUI.image:new({
				parent = _frmNode.handle._n,
				model = "UI:Tactic_SeparateLine",
				x = BOARD_WIDTH + DETAIL_OFFSET_X - 152,
				y = offsetY + matDy - 106,
				w = 250,
				h = 4,
				align = "MC",
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "tacticSeparateLine1"
			
			--当前此兵种升级需要的积分文字前缀
			_frmNode.childUI["armyUpdateJFPrefix"] = hUI.label:new({
				parent = _parentNode,
				y = 28,
				size = 24,
				align = "LC",
				--border = 1,
				x = offsetX - 15,
				y = offsetY - 317 + 100 - 40 + matDy,
				font = hVar.FONTC,
				width = 300,
				--text = "消耗", --language
				text = hVar.tab_string["__TEXT_CONSUME"], --language
				border = 1,
			})
			_frmNode.childUI["armyUpdateJFPrefix"].handle.s:setColor(ccc3(255, 236, 0))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "armyUpdateJFPrefix"
			
			--当前此兵种升级需要的积分图标
			_frmNode.childUI["armyUpdateJFIcon"] = hUI.image:new({
				parent = _frmNode.handle._n,
				model = "UI:score",
				x = offsetX + 60,
				y = offsetY - 313 + 100 - 40 + matDy,
				w = 26,
				h = 26,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "armyUpdateJFIcon"
			
			--当前此兵种升级需要的积分值
			_frmNode.childUI["armyUpdateJFValue"] = hUI.label:new({
				parent = _parentNode,
				size = 20,
				align = "LC",
				--border = 1,
				x = offsetX + 78,
				y = offsetY - 317 + 100 - 40 + matDy,
				font = "numWhite",
				width = 300,
				text = requireScore,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "armyUpdateJFValue"
			--_frmNode.childUI["armyUpdateJFValue"].handle.s:setColor(ccc3(255, 236, 0))
			
			--当前此兵种升级需要的游戏币图标
			_frmNode.childUI["armyStarUpRmbIcon"] = hUI.image:new({
				parent = _frmNode.handle._n,
				model = "UI:game_coins",
				x = offsetX + 142,
				y = offsetY - 313 + 100 - 40 + matDy,
				w = 36,
				h = 36,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "armyStarUpRmbIcon"
			
			--当前此兵种升级需要的游戏币值
			_frmNode.childUI["armyStarUpRmbValue"] = hUI.label:new({
				parent = _parentNode,
				y = 28,
				size = 20,
				align = "LC",
				--border = 1,
				x = offsetX + 158,
				y = offsetY - 317 + 100 - 40 + matDy,
				font = "numWhite",
				width = 300,
				text = requireRmb,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "armyStarUpRmbValue"
			_frmNode.childUI["armyStarUpRmbValue"].handle.s:setColor(ccc3(255, 236, 0))
			
			--碎片是否足够
			local bDebrisEnough = true --碎片是否足够
			for i = 1, #material, 1 do
				--兵种卡升级信息
				local requireTacticId = material[i].id --升到下一级需要的兵种id
				local requireDebris = material[i].num or 500 --升到下一级需要的碎片
				local debris = g_myPvP_BaseInfo.tacticInfo[requireTacticId] and g_myPvP_BaseInfo.tacticInfo[requireTacticId].debris or 0 --本兵种卡当前碎片数量
				if (debris < requireDebris) then
					bDebrisEnough = false --碎片不足
				end
			end
			
			--升级按钮
			--local strBtnText = "升级" --lanugage
			local strBtnText = hVar.tab_string["__UPGRADE"] --lanugage
			if (tacticLv == 0) then
				--strBtnText = "解锁" --lanugage
				strBtnText = hVar.tab_string["__UNLOCK"] --lanugage
			end
			_frmNode.childUI["btnStarUp"] = hUI.button:new({
				parent = _parentNode,
				dragbox = _frm.childUI["dragBox"],
				x = offsetX + 92,
				y = offsetY - 357 + 100 - 40 + matDy,
				w = 160,
				h = 50,
				label = strBtnText,
				font = hVar.FONTC,
				border = 1,
				model = "UI:BTN_ButtonRed",
				animation = "normal",
				scaleT = 0.95,
				scale = 1.0,
				code = function()
					--如果未连接，不能确认配置
					if (Pvp_Server:GetState() ~= 1) then --未连接
						--local strText = "您已断开连接，请重新登入" --language
						local strText = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
						hUI.floatNumber:new({
							x = hVar.SCREEN.w / 2,
							y = hVar.SCREEN.h / 2,
							align = "MC",
							text = "",
							lifetime = 1000,
							fadeout = -550,
							moveY = 32,
						}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
						
						return
					end
					
					--如果未登入，不能确认配置
					if (not hGlobal.LocalPlayer:getonline()) then --未登入
						--local strText = "您已断开连接，请重新登入" --language
						local strText = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
						hUI.floatNumber:new({
							x = hVar.SCREEN.w / 2,
							y = hVar.SCREEN.h / 2,
							align = "MC",
							text = "",
							lifetime = 1000,
							fadeout = -550,
							moveY = 32,
						}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
						
						return
					end
					
					--检测pvp的版本号
					if (not CheckPvpVersionControl()) then
						return
					end
					
					--检测积分是否足够
					if (LuaGetPlayerScore() < requireScore) then
						--弹框
						--local strText = "积分不足" --language
						local strText = hVar.tab_string["__TEXT_ScoreNotEnough"] --language
						hGlobal.UI.MsgBox(strText, {
							font = hVar.FONTC,
							ok = function()
							end,
						})
						
						return
					end
					
					--检测游戏币是否足够
					if (LuaGetPlayerRmb() < requireRmb) then
						--弹框
						--[[
						--local strText = "游戏币不足" --language
						local strText = hVar.tab_string["ios_not_enough_game_coin"] --language
						hGlobal.UI.MsgBox(strText, {
							font = hVar.FONTC,
							ok = function()
							end,
						})
						]]
						--弹出游戏币不足并提示是否购买的框
						hGlobal.event:event("LocalEvent_BuyItemfail", 1, 0)
						
						return
					end
					
					--点击升级按钮
					if (tacticLv >= maxLv) then --未到顶级
						--弹框
						--local strText = "已到顶级" --language
						local strText = hVar.tab_string["UpToMaxLv"] --language
						hGlobal.UI.MsgBox(strText,{
							font = hVar.FONTC,
							ok = function()
								--
							end,
						})
						
						return
					elseif (not bDebrisEnough) then --碎片数量足够
						--弹框
						--local strText = "碎片不足" --language
						local strText = hVar.tab_string["tactic_lessDebris"] --language
						hGlobal.UI.MsgBox(strText,{
							font = hVar.FONTC,
							ok = function()
								--
							end,
						})
						
						return
					else
						--可以升级
						--挡操作
						hUI.NetDisable(30000)
						
						--添加监听事件
						--监听收到pvp升级回调事件
						hGlobal.event:listen("LocalEvent_Pvp_Army_Lvup_Ok", "__PvpArmyLvupBack_2", function(id, lv, num)
							--print("LocalEvent_Pvp_Army_Lvup_Ok", tacticId)
							--移除监听
							hGlobal.event:listen("LocalEvent_Pvp_Army_Lvup_Ok", "__PvpArmyLvupBack_2", nil)
							
							--去掉菊花
							hUI.NetDisable(0)
							
							--升级成功
							--local strText = 升级成功！" --language
							local strText = hVar.tab_string["army_levelupsuccess"] --language
							if (lv == 1) then
								--strText = 解锁成功！" --language
								strText = hVar.tab_string["army_unlocksuccess"] --language
							end
							hGlobal.UI.MsgBox(strText,{
								font = hVar.FONTC,
								ok = function()
									--刷新单个兵种卡
									On_refresh_single_army_card(tacticId)
									
									--刷新素材兵种卡
									for i = 1, #material, 1 do
										--兵种卡升级信息
										local requireTacticId = material[i].id --升到下一级需要的兵种id
										if (tacticId ~= requireTacticId) then
											On_refresh_single_army_card(requireTacticId)
										end
									end
									
									--刷新本详细信息界面
									On_show_armycard_detail_info(button)
								end,
							})
						end)
						
						--发送升级指令
						local tacticId = tacticId
						SendPvpCmdFunc["army_lvup"](tacticId)
					end
				end,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnStarUp"
			--兵种碎片足够，未到顶级，才能升级
			if (bDebrisEnough) and (tacticLv < maxLv) then
				hApi.AddShader(_frmNode.childUI["btnStarUp"].handle.s, "normal")
				
				--创建提示升星的跳动箭头
				_frmNode.childUI["armyStarUpJianTou"] = hUI.image:new({
					parent = _parentNode,
					model = "ICON:image_jiantouV",
					x = offsetX + 32,
					y = offsetY + 112,
					w = 36,
					h = 36,
					align = "MC",
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "armyStarUpJianTou"
			else
				hApi.AddShader(_frmNode.childUI["btnStarUp"].handle.s, "gray")
			end
			
			--升星按钮的升级小箭头
			_frmNode.childUI["btnStarUp"].childUI["UI_Arrow"] = hUI.image:new({
				parent = _frmNode.childUI["btnStarUp"].handle._n,
				model = "UI:UI_Arrow",
				scale = 0.7,
				roll = 90,
				x = 90,
			})
			_frmNode.childUI["btnStarUp"].childUI["UI_Arrow"].handle._n:setRotation(-90)
		end
		
		--显示右侧"加入配置"/"移除配置"按钮
		if (not bIgnoreOp) then
			On_add_or_remove_Cfg_button(button)
		end
	end
	
	--函数：显示右侧"加入配置"/"移除配置"按钮(铜雀台)
	On_add_or_remove_Cfg_button = function(button)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local nType = button.data.nType --卡牌的类型
		local id = button.data.id --卡牌的id
		local lv = button.data.lv --卡牌的等级
		local num = button.data.num --卡牌的数量
		local bConfiged = false --是否已加入配置
		
		--依次检测已配置的卡牌
		for i = 1, #current_tCfgCard, 1 do
			local btni = current_tCfgCard[i]
			if (btni ~= 0) then
				if (btni.data.nType == nType) and (btni.data.id == id) then
					--找到了
					bConfiged = true
					
					break
				end
			end
		end
		
		local strText = nil
		local strModel = nil
		if bConfiged then
			--strText = "卸下" --language
			strText = hVar.tab_string["__TEXT_UnUse"] --language
			strModel = "misc/jdt2.png"
		else
			--strText = "使用" --language
			strText = hVar.tab_string["__TEXT_Use"] --language
			strModel = "misc/jdt1.png"
		end
		
		local bHaveThisCard = false --是否有这张卡
		if (nType == 1) then --1:英雄 类型
			bHaveThisCard = (num > 0)
		elseif (nType == 2) then --2:塔类型
			bHaveThisCard = (num > 0)
		elseif (nType == 3) then --3:进攻兵种类型
			bHaveThisCard = (lv > 0)
		elseif (nType == 4) then --4:防守兵种类型
			bHaveThisCard = (lv > 0)
		end
		
		--[[
		local DETAIL_OFFSET_X = 6 - 568 --详细信息面板的x偏移值
		local DETAIL_OFFSET_Y = -40 --详细信息面板的y偏移值
		local offsetX = BOARD_WIDTH - 250 + DETAIL_OFFSET_X
		local offsetY = -BOARD_HEIGHT / 2 + 90 + DETAIL_OFFSET_Y
		
		--加入配置的按钮
		_frmNode.childUI["btnAddCfg"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = offsetX + 92,
			y = offsetY - 310,
			w = 160,
			h = 50,
			label = strText,
			font = hVar.FONTC,
			border = 1,
			model = "UI:BTN_ButtonRed",
			animation = "normal",
			scaleT = 0.95,
			scale = 1.0,
			code = function()
				if bConfiged then
					--将此卡牌从配置栏移除
					RemoveCardFromConfig(button)
				else
					--将此卡牌加入到配置栏
					AddCardToConfig(button)
				end
				
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnAddCfg"
		]]
		
		--显示使用和移除按钮
		hApi.safeRemoveT(button.childUI, "imgUse")
		hApi.safeRemoveT(button.childUI, "labelUse")
		
		--print("显示使用和移除按钮", bConfiged, strText)
		
		if bHaveThisCard then
			--本卡牌添加子控件-使用的背景图
			button.childUI["imgUse"]= hUI.image:new({
				parent = button.handle._n,
				model = strModel,
				x = 1,
				y = -CONFIG_CARD_HEIGHT / 2 + 24,
				w = CONFIG_CARD_WIDTH + 4,
				h = 56,
			})
			
			--本卡牌添加子控件-使用的背景图
			button.childUI["labelUse"]= hUI.label:new({
				parent = button.handle._n,
				x = 0,
				y = -CONFIG_CARD_HEIGHT / 2 + 24 + 2,
				w = CONFIG_CARD_WIDTH,
				size = 32,
				align = "MC",
				border = 1,
				font = hVar.FONTC,
				width = 360,
				text = strText,
			})
			--[[
			button.childUI["imgUse"].handle._n:setVisible(true)
			button.childUI["labelUse"].handle._n:setVisible(true)
			button.childUI["labelUse"]:setText(strText)
			]]
		end
	end
	
	--函数：创建卡牌的选中框(铜雀台)
	On_create_card_selectbox = function(button)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--删除上次的选中框控件
		hApi.safeRemoveT(button.childUI, "selectbox")
		
		--按钮选中框
		local ww = button.data.w
		local hh = button.data.h
		local scaleX = (ww + 4) / 72
		local scaleY = (hh + 4) / 72
		button.childUI["selectbox"] = hUI.image:new({
			parent = button.handle._n,
			model = "UI:TacTicFrame",
			align = "MC",
			w = ww + 4,
			h = hh + 4,
			z = 1,
		})
		--button.childUI["selectbox"].handle._n:setVisible(false) --默认隐藏
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(0.6, scaleX - 0.015, scaleY - 0.015), CCScaleTo:create(0.6, scaleX + 0.025, scaleY + 0.025))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		button.childUI["selectbox"].handle.s:runAction(forever)
	end
	
	--函数：删除卡牌的选中框(铜雀台)
	On_delete_card_selectbox = function(button)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--删除选中框控件
		hApi.safeRemoveT(button.childUI, "selectbox")
	end
	
	--函数：刷新单张英雄卡牌(铜雀台)
	On_refresh_single_hero_card = function(heroId)
		--print("On_refresh_single_hero_card", heroId)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--更新游戏币值
		if _frmNode.childUI["GameCoinValue"] then
			_frmNode.childUI["GameCoinValue"]:setText(LuaGetPlayerRmb())
		end
		
		--更新积分值
		if _frmNode.childUI["JiFenCoinValue"] then
			_frmNode.childUI["JiFenCoinValue"]:setText(LuaGetPlayerScore())
		end
		
		--找到滑动控件里的此张卡牌的控件
		local buttonList = {}
		for i = 1, #current_tCfgCard_DragCtrls, 1 do
			local btni = current_tCfgCard_DragCtrls[i] --第i项
			if btni and (btni ~= 0) then
				local nType = btni.data.nType
				local id = btni.data.id
				if (nType == 1) and (id == heroId) then --找到了
					table.insert(buttonList, btni)
					break
				end
			end
		end
		
		--找到已配置控件里的此张卡的控件
		for i = 1, #current_tCfgCard, 1 do
			local btni = current_tCfgCard[i] --第i项
			if btni and (btni ~= 0) then
				local nType = btni.data.nType
				local id = btni.data.id
				if (nType == 1) and (id == heroId) then --找到了
					table.insert(buttonList, btni)
					break
				end
			end
		end
		
		--存在滑动控件
		for i = 1, #buttonList, 1 do
			local button = buttonList[i]
			--print("存在滑动控件", i)
			
			--更新控件的数据
			local heroStar = g_myPvP_BaseInfo.heroInfo[heroId] and g_myPvP_BaseInfo.heroInfo[heroId].star or 0 --本英雄卡当前星级
			local heroDebris = g_myPvP_BaseInfo.heroInfo[heroId] and g_myPvP_BaseInfo.heroInfo[heroId].soulstone or 0 --本英雄卡当前碎片数量
			local heroLv = button.data.lv
			
			button.data.star = heroStar
			button.data.soulstone = heroDebris
			
			--当前此英雄的碎片数量
			local maxStarLv = hVar.HERO_STAR_INFO.maxStarLv --最高星级
			local maxLv = 0 --最高等级
			local costSoulStone = 0 --升到下一星需要的碎片数量
			if (heroStar < maxStarLv) then
				costSoulStone = hVar.HERO_STAR_INFO[heroId][heroStar].costSoulStone
				maxLv = hVar.HERO_STAR_INFO[heroId][heroStar].maxLv
			else
				costSoulStone = hVar.HERO_STAR_INFO[heroId][maxStarLv].costSoulStone
				maxLv = hVar.HERO_STAR_INFO[heroId][heroStar].maxLv
			end
			
			--未获得该英雄，并且该英雄只有在竞技场获得，那么需要的等级为0级
			local HeroCard = hApi.GetHeroCardById(heroId) --英雄卡牌
			--英雄是否是竞技场专属
			local pvp_only = false --是否竞技场专属英雄
			for i = 1, #hVar.HERO_AVAILABLE_LIST, 1 do
				if (hVar.HERO_AVAILABLE_LIST[i].id == heroId) then --找到了
					pvp_only = hVar.HERO_AVAILABLE_LIST[i].pvp_only
					
					break
				end
			end
			if (not HeroCard) and (pvp_only) then
				maxLv = 0
			end
			--print(heroLv, maxLv, heroDebris, costSoulStone, heroStar, maxStarLv)
			
			--更新星级
			for i = 1, maxStarLv, 1 do
				--只显示当前数量
				if (i > heroStar) then
					button.childUI["heroStar" .. i].handle.s:setVisible(false)
				else
					button.childUI["heroStar" .. i].handle.s:setVisible(true)
				end
			end
			
			--如果等级升到最高级，碎片数量足够，星未到顶级，那么提示可升星箭头
			if (heroLv >= maxLv) and (heroDebris >= costSoulStone) and (heroStar < maxStarLv) then
				button.childUI["heroStarUp_JianTou"].handle.s:setVisible(true) --显示
			else
				button.childUI["heroStarUp_JianTou"].handle.s:setVisible(false) --不显示
			end
		end
	end
	
	--函数：刷新单张兵种卡牌(铜雀台)
	On_refresh_single_army_card = function(tacticId)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--更新游戏币值
		if _frmNode.childUI["GameCoinValue"] then
			_frmNode.childUI["GameCoinValue"]:setText(LuaGetPlayerRmb())
		end
		
		--更新积分值
		if _frmNode.childUI["JiFenCoinValue"] then
			_frmNode.childUI["JiFenCoinValue"]:setText(LuaGetPlayerScore())
		end
		
		--找到滑动控件里的此张卡牌的控件
		local buttonList = {}
		for i = 1, #current_tCfgCard_DragCtrls, 1 do
			local btni = current_tCfgCard_DragCtrls[i] --第i项
			if btni and (btni ~= 0) then
				local nType = btni.data.nType
				local id = btni.data.id
				if ((nType == 3) or (nType == 4)) and (id == tacticId) then --找到了
					table.insert(buttonList, btni)
					break
				end
			end
		end
		
		--找到已配置控件里的此张卡的控件
		for i = 1, #current_tCfgCard, 1 do
			local btni = current_tCfgCard[i] --第i项
			if btni and (btni ~= 0) then
				local nType = btni.data.nType
				local id = btni.data.id
				if ((nType == 3) or (nType == 4)) and (id == tacticId) then --找到了
					table.insert(buttonList, btni)
					break
				end
			end
		end
		
		--存在滑动控件
		for i = 1, #buttonList, 1 do
			local button = buttonList[i]
			
			--更新控件的数据
			local tacticLv = g_myPvP_BaseInfo.tacticInfo[tacticId] and g_myPvP_BaseInfo.tacticInfo[tacticId].lv or 0 --本兵种卡当前等级
			local debris = g_myPvP_BaseInfo.tacticInfo[tacticId] and g_myPvP_BaseInfo.tacticInfo[tacticId].debris or 0 --本兵种卡当前碎片数量
			button.data.lv = tacticLv
			button.data.debris = debris
			
			--等级大于0，亮
			if (tacticLv > 0) then
				hApi.AddShader(button.handle.s, "normal") --背景框
				if button.childUI["towerIcon"] then
					hApi.AddShader(button.childUI["towerIcon"].handle.s, "normal") --图标
				end
				if button.childUI["typeicon"] then
					hApi.AddShader(button.childUI["typeicon"].handle.s, "normal") --类型图标
				end
			else
				hApi.AddShader(button.handle.s, "gray") --背景框
				if button.childUI["towerIcon"] then
					hApi.AddShader(button.childUI["towerIcon"].handle.s, "gray") --图标
				end
				if button.childUI["typeicon"] then
					hApi.AddShader(button.childUI["typeicon"].handle.s, "gray") --类型图标
				end
			end
			
			--如果碎片数量足够，未到顶级，那么提示可升级
			local armLvupInfo = hVar.tab_tactics[tacticId].armLvupInfo
			local material = armLvupInfo[tacticLv] and armLvupInfo[tacticLv].material or {} --升到下一级需要材料
			
			--兵种碎片足够，未到顶级，才能升级
			local bDebrisEnough = true --碎片是否足够
			for i = 1, #material, 1 do
				--兵种卡升级信息
				local requireTacticId = material[i].id --升到下一级需要的兵种id
				local requireDebris = material[i].num or 500 --升到下一级需要的碎片
				local debris = g_myPvP_BaseInfo.tacticInfo[requireTacticId] and g_myPvP_BaseInfo.tacticInfo[requireTacticId].debris or 0 --本兵种卡当前碎片数量
				if (debris < requireDebris) then
					bDebrisEnough = false --碎片不足
				end
			end
			local maxLv = hVar.TACTIC_LVUP_INFO.maxArmyLv or 1
			if (bDebrisEnough) and (tacticLv < maxLv) then
				if button.childUI["armyStarUp_JianTou"] then
					button.childUI["armyStarUp_JianTou"].handle.s:setVisible(true) --显示
				end
			else
				if button.childUI["armyStarUp_JianTou"] then
					button.childUI["armyStarUp_JianTou"].handle.s:setVisible(false) --不显示
				end
			end
		end
	end
	
	--函数：将某个卡牌加入到配置栏(铜雀台)
	AddCardToConfig = function(button)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--检测每个分类是否超过可配置的上限
		local heroTotalNum = 0
		local towerTotalNum = 0
		local armyTotalNum_atk = 0
		local armyTotalNum_def = 0
		for k = 1, #current_tCfgCard, 1 do
			if (current_tCfgCard[k] ~= 0) then
				local nType = current_tCfgCard[k].data.nType
				--print(nType)
				if (nType == 1) then --1:英雄 类型
					heroTotalNum = heroTotalNum + 1
				elseif (nType == 2) then --2:塔类型
					towerTotalNum = towerTotalNum + 1
				elseif (nType == 3) then --3:进攻兵种类型
					armyTotalNum_atk = armyTotalNum_atk + 1
				elseif (nType == 4) then --4:防守兵种类型
					armyTotalNum_def = armyTotalNum_def + 1
				end
			end
		end
		--print(heroTotalNum, towerTotalNum, armyTotalNum_atk, armyTotalNum_def)
		--总的选了的数量
		local TotalNum = heroTotalNum + towerTotalNum + armyTotalNum_atk + armyTotalNum_def
		
		--本次是操作英雄，英雄未获得，禁止操作
		if (button.data.nType == 1) and (button.data.num <= 0) then
			--local strText = "您还没有获得该英雄" --language
			local strText = hVar.tab_string["NoHaveGetThisHero"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--如果英雄卡已到上限，并且本次是操作英雄，禁止操作
		if (heroTotalNum >= SELECT_NUM_MAX.HERO) and (button.data.nType == 1) then
			--local strText = "您选择的英雄数量超过可选上限！" --language
			local strText = hVar.tab_string["SelectHeroExpireMax"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--本次是操作塔，塔未获得，禁止操作
		if (button.data.nType == 2) and (button.data.num <= 0) then
			--local strText = "您还没有获得该塔" --language
			local strText = hVar.tab_string["NoHaveGetThisTower"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--如果塔卡已到上限，并且本次是操作塔，禁止操作
		if (towerTotalNum >= SELECT_NUM_MAX.TOWER) and (button.data.nType == 2) then
			--local strText = "您选择的塔数量超过可选上限！" --language
			local strText = hVar.tab_string["SelectTowerExpireMax"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--本次是操作进攻兵种，进攻兵种未获得，禁止操作
		if (button.data.nType == 3) and (button.data.lv <= 0) then
			--local strText = "该兵种卡未解锁" --language
			local strText = hVar.tab_string["SelecTacticNoDebris"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--如果进攻兵种卡已到上限，并且本次是操作进攻兵种，禁止操作
		if (armyTotalNum_atk >= SELECT_NUM_MAX.ARMY_ATK) and (button.data.nType == 3) then
			--local strText = "您选择的进攻兵种卡数量超过可选上限！" --language
			local strText = hVar.tab_string["SelectArmyExpireMax_Atk"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--本次是操作防守兵种，防守兵种未获得，禁止操作
		if (button.data.nType == 4) and (button.data.lv <= 0) then
			--local strText = "该兵种卡未解锁" --language
			local strText = hVar.tab_string["SelecTacticNoDebris"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--如果防守兵种卡已到上限，并且本次是操作进攻兵种，禁止操作
		if (armyTotalNum_def >= SELECT_NUM_MAX.ARMY_DEF) and (button.data.nType == 4) then
			--local strText = "您选择的防守兵种卡数量超过可选上限！" --language
			local strText = hVar.tab_string["SelectArmyExpireMax_Def"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--如果卡牌已经超过配置的上限，禁止操作
		if (TotalNum >= CONFIG_NUM_MAX) then
			--local strText = "您选择的卡牌超过可选上限！" --language
			local strText = hVar.tab_string["SelectTotalExpireMax"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--通过判断
		--挡操作
		hUI.NetDisable(30000)
		
		local nType = button.data.nType --卡牌的类型
		local id = button.data.id --卡牌的id
		
		--创建此卡牌的拷贝控件
		--local cfg_idx = #current_tCfgCard + 1
		local cfg_idx = 0
		for j = 1, #current_tCfgCard_DragCtrls, 1 do
			local btni = current_tCfgCard_DragCtrls[j]
			local nType = btni.data.nType
			local id = btni.data.id
			local lv = btni.data.lv
			local num = btni.data.num
			local star = btni.data.star
			local debris = btni.data.debris
			
			if (button.data.nType == nType) and (button.data.id == id) then --找到了
				if (nType == 1) then -- 1:英雄类型
					--定位索引位置
					if (not current_tCfgCard[1]) or (current_tCfgCard[1] == 0) then --没有第一个英雄
						cfg_idx = 1
					else
						cfg_idx = heroTotalNum + 1
					end
					--print("定位索引位置, cfg_idx=", cfg_idx)
					
					--创建拷贝
					local posX = btni.data.x
					local posY = btni.data.y
					_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx] = On_create_single_herocard_config_card_tiny(id, lv, star, posX, posY, (num > 0), _parentNode, 10)
					
					leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardBtn_Config" .. cfg_idx
					current_tCfgCard[cfg_idx] = _frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx] --加入已配置控件里
					current_tCfgCard_Data[cfg_idx] = {nType = 1, id = id, lv = lv} --已选好的控件集数据部分
					
					--存储英雄
					_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.nType = 1 --英雄类型为1
					_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.id = id --id
					_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.lv = lv --lv
					_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.num = num --num
					--
					_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.star = star --star
					
					--[[
					--显示选中状态
					button.childUI["ok"].handle._n:setVisible(true)
					_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].childUI["ok"].handle._n:setVisible(true)
					
					--索引加1
					cfg_idx = cfg_idx + 1
					]]
					
					break
				elseif (nType == 2) then -- 2:塔类型
					--定位索引位置
					--cfg_idx = SELECT_NUM_MAX.HERO + towerTotalNum + armyTotalNum_atk + armyTotalNum_def + 1
					--print("#current_tCfgCard=", #current_tCfgCard)
					for k = 1, #current_tCfgCard, 1 do
						local btni = current_tCfgCard[k]
						if btni and (btni ~= 0) then
							if (btni.data.nType > 2) then --插入到塔的末尾
								cfg_idx = k
								break
							end
						end
					end
					if (cfg_idx == 0) then
						cfg_idx = #current_tCfgCard + 1
					end
					
					--重新存储控件索引
					for k = #current_tCfgCard, cfg_idx, -1 do
						_frmNode.childUI["ConfigCardBtn_Config" .. (k + 1)] = current_tCfgCard[k]
					end
					
					--添加最后一项控件
					table.insert(leftRemoveFrmList, "ConfigCardBtn_Config" .. (#current_tCfgCard + 1))
					
					--添加存储位置的项
					table.insert(current_tCfgCard, cfg_idx, 0)
					table.insert(current_tCfgCard_Data, cfg_idx, 0)
					
					local posX = btni.data.x
					local posY = btni.data.y
					_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx] = On_create_single_towercard_config_card_tiny(id, lv, posX, posY, (num > 0), _parentNode, 10)
					leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardBtn_Config" .. cfg_idx
					current_tCfgCard[cfg_idx] = _frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx] --加入已配置控件里
					current_tCfgCard_Data[cfg_idx] = {nType = 2, id = id, lv = lv} --已选好的控件集数据部分
					
					--存储塔
					_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.nType = 2 --塔类型为2
					_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.id = id --id
					_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.lv = lv --lv
					_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.num = num --num
					
					--[[
					--显示选中状态
					button.childUI["ok"].handle._n:setVisible(true)
					_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].childUI["ok"].handle._n:setVisible(true)
					
					--索引加1
					cfg_idx = cfg_idx + 1
					]]
					
					break
				elseif (nType == 3) then -- 3:进攻兵种类型
					--定位索引位置
					--cfg_idx = SELECT_NUM_MAX.HERO + towerTotalNum + armyTotalNum_atk + armyTotalNum_def + 1
					for k = 1, #current_tCfgCard, 1 do
						local btni = current_tCfgCard[k]
						if btni and (btni ~= 0) then
							if (btni.data.nType > 3) then --插入到进攻兵种的末尾
								cfg_idx = k
								break
							end
						end
					end
					if (cfg_idx == 0) then
						cfg_idx = #current_tCfgCard + 1
					end
					
					--重新存储控件索引
					for k = #current_tCfgCard, cfg_idx, -1 do
						_frmNode.childUI["ConfigCardBtn_Config" .. (k + 1)] = current_tCfgCard[k]
					end
					
					--添加最后一项控件
					table.insert(leftRemoveFrmList, "ConfigCardBtn_Config" .. (#current_tCfgCard + 1))
					
					--添加存储位置的项
					table.insert(current_tCfgCard, cfg_idx, 0)
					table.insert(current_tCfgCard_Data, cfg_idx, 0)
					
					local posX = btni.data.x
					local posY = btni.data.y
					_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx] = On_create_single_armycard_config_card_tiny(id, lv, posX, posY, (lv > 0), _parentNode, 10)
						leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardBtn_Config" .. cfg_idx
						current_tCfgCard[cfg_idx] = _frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx] --加入已配置控件里
						current_tCfgCard_Data[cfg_idx] = {nType = 3, id = id, lv = lv} --已选好的控件集数据部分
						
						--存储进攻兵种
						_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.nType = 3 --进攻兵种类型为3
						_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.id = id --id
						_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.lv = lv --lv
						_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.num = num --num
						--
						_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.debris = debris --debris
						
					break
				elseif (nType == 4) then -- 4:防守兵种类型
					--定位索引位置
					cfg_idx = SELECT_NUM_MAX.HERO + towerTotalNum + armyTotalNum_atk + armyTotalNum_def + 1
					
					local posX = btni.data.x
					local posY = btni.data.y
					_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx] = On_create_single_armycard_config_card_tiny(id, lv, posX, posY, (lv > 0), _parentNode, 10)
						leftRemoveFrmList[#leftRemoveFrmList + 1] = "ConfigCardBtn_Config" .. cfg_idx
						current_tCfgCard[#current_tCfgCard+1] = _frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx] --加入已配置控件里
						current_tCfgCard_Data[#current_tCfgCard_Data+1] = {nType = 4, id = id, lv = lv} --已选好的控件集数据部分
						
						--存储防御兵种
						_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.nType = 4 --防守兵种类型为4
						_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.id = id --id
						_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.lv = lv --lv
						_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.num = num --num
						--
						_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.debris = debris --debris
						
					break
				end
			end
		end
		
		--回调函数
		local actionsSend = #current_tCfgCard - cfg_idx + 1
		local actionReceive = 0
		--print("cfg_idx=", cfg_idx)
		--print("#current_tCfgCard=", #current_tCfgCard)
		--print("actionsSend=", actionsSend)
		--print("actionReceive=", actionReceive)
		local AllActionsDoneEvent_A = nil
		
		--此卡牌做运动
		local toX = _frmNode.childUI["ConfigBG" .. cfg_idx].data.x
		local toY = _frmNode.childUI["ConfigBG" .. cfg_idx].data.y
		
		local move = CCMoveTo:create(0.2, ccp(toX, toY))
		local actCall = CCCallFunc:create(function(ctrl)
			--标记选中状态
			button.childUI["ok"].handle._n:setVisible(true)
			--_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].childUI["ok"].handle._n:setVisible(true) --geyachao: 暂时不显示已配置的勾勾
			
			--更新坐标
			_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.x = _frmNode.childUI["ConfigBG" .. cfg_idx].data.x
			_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].data.y = _frmNode.childUI["ConfigBG" .. cfg_idx].data.y
			
			--收到+1
			actionReceive = actionReceive + 1
			--print("actionReceive=", actionReceive)
			--print(actionReceive, actionsSend)
			--除了英雄，其它类型卡牌，后面的往前挪
			if (button.data.nType ~= 1) then
				if (actionReceive == actionsSend) then
					AllActionsDoneEvent_A()
				end
			else
				--英雄卡牌直接回调
				AllActionsDoneEvent_A()
			end
		end)
		local towAction = CCSequence:createWithTwoActions(move, actCall)
		_frmNode.childUI["ConfigCardBtn_Config" .. cfg_idx].handle._n:runAction(towAction)
		
		--除了英雄，其它类型卡牌，前面的往后挪
		if (button.data.nType ~= 1) then
			--前面的卡牌挪到后一格位置
			for k = #current_tCfgCard, cfg_idx + 1, -1 do
				--print("前面的卡牌挪到后一格位置", #current_tCfgCard, cfg_idx + 1, k)
				local btnk = current_tCfgCard[k]
				local toX = _frmNode.childUI["ConfigBG" .. k].data.x
				local toY = _frmNode.childUI["ConfigBG" .. k].data.y
				
				local move = CCMoveTo:create(0.2, ccp(toX, toY))
				local actCall = CCCallFunc:create(function(ctrl)
					--收到+1
					actionReceive = actionReceive + 1
					--print("actionReceive=", actionReceive)
					--print(actionReceive, actionsSend)
					if (actionReceive == actionsSend) then
						AllActionsDoneEvent_A()
					end
				end)
				local towAction = CCSequence:createWithTwoActions(move, actCall)
				btnk.handle._n:runAction(towAction)
			end
		end
		
		--回调函数实现
		AllActionsDoneEvent_A = function()
			--重新存储控件的坐标
			if (button.data.nType ~= 1) then --非英雄才需要操作
				for k = cfg_idx + 1, #current_tCfgCard, 1 do
					current_tCfgCard[k].data.x = _frmNode.childUI["ConfigBG" .. k].data.x
					current_tCfgCard[k].data.y = _frmNode.childUI["ConfigBG" .. k].data.y
				end
			end
			
			--更新已选的分支的数量
			if (button.data.nType == 1) then --点到了英雄
				--更新已配置的英雄的数量
				local herocard_cfg_num = heroTotalNum + 1
				_frmNode.childUI["ConfigCardLabel_HeroNum"]:setText(herocard_cfg_num .. "/" .. SELECT_NUM_MAX.HERO)
			elseif (button.data.nType == 2) then --点到了塔
				--更新已配置的塔的数量
				local towercard_cfg_num = towerTotalNum + 1
				_frmNode.childUI["ConfigCardLabel_TowerNum"]:setText(towercard_cfg_num .. "/" .. SELECT_NUM_MAX.TOWER)
			elseif (button.data.nType == 3) then --点到了进攻兵种
				--更新已配置的兵种(进攻)的数量
				local armycard_atk_cfg_num = armyTotalNum_atk + 1
				_frmNode.childUI["ConfigCardLabel_Army_AtkNum"]:setText(armycard_atk_cfg_num .. "/" .. SELECT_NUM_MAX.ARMY_ATK)
			elseif (button.data.nType == 4) then --点到了防守进攻兵种
				--更新已配置的兵种(防守)的数量
				local armycard_def_cfg_num = armyTotalNum_def + 1
				_frmNode.childUI["ConfigCardLabel_Army_DefNum"]:setText(armycard_def_cfg_num .. "/" .. SELECT_NUM_MAX.ARMY_DEF)
			end
			
			--刷新右侧详细信息
			if (button.data.nType == 1) then --点到了英雄
				--显示英雄卡牌的详细信息
				On_show_herocard_detail_info(button)
			elseif (button.data.nType == 2) then --点到了塔
				--显示塔卡牌的详细信息
				On_show_towercard_detail_info(button)
			elseif (button.data.nType == 3) then --点到了进攻兵种
				--显示进攻兵种卡牌的详细信息
				On_show_armycard_detail_info(button)
			elseif (button.data.nType == 4) then --点到了防守进攻兵种
				--显示防守兵种卡牌的详细信息
				On_show_armycard_detail_info(button)
			end
			
			--取消挡操作
			hUI.NetDisable(0)
			
			--print("#current_tCfgCard_Data=", #current_tCfgCard_Data, "add")
		end
	end
	
	--函数：将某个卡牌从配置栏移除(铜雀台)
	RemoveCardFromConfig = function(button)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local nType = button.data.nType --卡牌的类型
		local id = button.data.id --卡牌的id
		--print(nType, id)
		
		--找到此卡牌的已配置索引位置
		local cfg_idx = 0
		for k = 1, #current_tCfgCard, 1 do
			local btni = current_tCfgCard[k]
			if btni and (btni ~= 0) then
				local nType = btni.data.nType
				local id = btni.data.id
				
				if (button.data.nType == nType) and (button.data.id == id) then --找到了
					cfg_idx = k
					break
				end
			end
		end
		
		--找不到此控件
		if (cfg_idx == 0) then
			--local strText = "您还没有选择卡牌！" --language
			local strText = hVar.tab_string["NoSelectAnyCard"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--通过判断
		--挡操作
		hUI.NetDisable(30000)
		
		--替换此控件为已配置的控件
		button = current_tCfgCard[cfg_idx]
		
		--回调函数
		local actionsSend = #current_tCfgCard - cfg_idx + 1
		local actionReceive = 0
		local AllActionsDoneEvent_R = nil
		
		--找到此卡牌的拷贝控件
		for j = 1, #current_tCfgCard_DragCtrls, 1 do
			local btni = current_tCfgCard_DragCtrls[j]
			local nType = btni.data.nType
			local id = btni.data.id
			
			if (button.data.nType == nType) and (button.data.id == id) then --找到了
				--此卡牌做运动
				local toX = btni.data.x
				local toY = btni.data.y
				
				local move = CCMoveTo:create(0.2, ccp(toX, toY))
				local actCall = CCCallFunc:create(function(ctrl)
					--取消滑动控件的选中状态
					--button.childUI["ok"].handle._n:setVisible(false)
					btni.childUI["ok"].handle._n:setVisible(false)
					
					--收到+1
					actionReceive = actionReceive + 1
					--print(actionReceive, actionsSend)
					--除了英雄，其它类型卡牌，后面的往前挪
					if (button.data.nType ~= 1) then
						if (actionReceive == actionsSend) then
							AllActionsDoneEvent_R()
						end
					else
						--英雄卡牌直接回调
						AllActionsDoneEvent_R()
					end
				end)
				local towAction = CCSequence:createWithTwoActions(move, actCall)
				button.handle._n:runAction(towAction)
				
				--除了英雄，其它类型卡牌，后面的往前挪
				if (button.data.nType ~= 1) then
					--后面的卡牌挪到前一格位置
					for k = #current_tCfgCard, cfg_idx + 1, -1 do
						--print("后面的卡牌挪到前一格位置", #current_tCfgCard, cfg_idx + 1, k)
						local btnk = current_tCfgCard[k]
						local toX = current_tCfgCard[k - 1].data.x
						local toY = current_tCfgCard[k - 1].data.y
						
						local move = CCMoveTo:create(0.2, ccp(toX, toY))
						local actCall = CCCallFunc:create(function(ctrl)
							--收到+1
							actionReceive = actionReceive + 1
							--print(actionReceive, actionsSend)
							if (actionReceive == actionsSend) then
								AllActionsDoneEvent_R()
							end
						end)
						local towAction = CCSequence:createWithTwoActions(move, actCall)
						btnk.handle._n:runAction(towAction)
					end
				end
				
				break
			end
		end
		
		--回调函数实现
		AllActionsDoneEvent_R = function()
			--重新存储控件索引
			if (button.data.nType ~= 1) then --除了英雄，其它类型卡牌，后面的往前挪
				for k = #current_tCfgCard, cfg_idx + 1, -1 do
					_frmNode.childUI["ConfigCardBtn_Config" .. (k - 1)] = current_tCfgCard[k]
				end
			end
			
			--重新存储控件的坐标
			if (button.data.nType ~= 1) then --除了英雄，其它类型卡牌，后面的往前挪
				for k = #current_tCfgCard - 1, cfg_idx, -1 do
					current_tCfgCard[k + 1].data.x = current_tCfgCard[k].data.x
					current_tCfgCard[k + 1].data.y = current_tCfgCard[k].data.y
				end
			end
			
			--删除最后一项控件
			if (button.data.nType ~= 1) then --除了英雄，其它类型卡牌，后面的往前挪
				_frmNode.childUI["ConfigCardBtn_Config" .. (#current_tCfgCard)] = nil
				
				for k = 1, #leftRemoveFrmList, 1 do
					if (leftRemoveFrmList[k] == ("ConfigCardBtn_Config" .. (#current_tCfgCard))) then
						--print("k", k)
						table.remove(leftRemoveFrmList, k)
						break
					end
				end
			end
			
			--移除存储位置的项
			if (button.data.nType ~= 1) then --除了英雄，其它类型卡牌，后面的往前挪
				table.remove(current_tCfgCard, cfg_idx)
				table.remove(current_tCfgCard_Data, cfg_idx)
			else
				current_tCfgCard[cfg_idx] = 0
				current_tCfgCard_Data[cfg_idx] = 0
			end
			
			--print("#current_tCfgCard_Data=", #current_tCfgCard_Data, "remove")
			
			--更新自身控件
			--检测每个分类已配置的数量
			local heroTotalNum = 0
			local towerTotalNum = 0
			local armyTotalNum_atk = 0
			local armyTotalNum_def = 0
			for k = 1, #current_tCfgCard, 1 do
				if (current_tCfgCard[k] ~= 0) then
					local nType = current_tCfgCard[k].data.nType
					--print(nType)
					if (nType == 1) then --1:英雄 类型
						heroTotalNum = heroTotalNum + 1
					elseif (nType == 2) then --2:塔类型
						towerTotalNum = towerTotalNum + 1
					elseif (nType == 3) then --3:进攻兵种类型
						armyTotalNum_atk = armyTotalNum_atk + 1
					elseif (nType == 4) then --4:防守兵种类型
						armyTotalNum_def = armyTotalNum_def + 1
					end
				end
			end
			--print(heroTotalNum, towerTotalNum, armyTotalNum_atk, armyTotalNum_def)
			--更新已选的分支的数量
			if (button.data.nType == 1) then --点到了英雄
				--更新已配置的英雄的数量
				_frmNode.childUI["ConfigCardLabel_HeroNum"]:setText(heroTotalNum .. "/" .. SELECT_NUM_MAX.HERO)
			elseif (button.data.nType == 2) then --点到了塔
				--更新已配置的塔的数量
				_frmNode.childUI["ConfigCardLabel_TowerNum"]:setText(towerTotalNum .. "/" .. SELECT_NUM_MAX.TOWER)
			elseif (button.data.nType == 3) then --点到了进攻兵种
				--更新已配置的兵种(进攻)的数量
				_frmNode.childUI["ConfigCardLabel_Army_AtkNum"]:setText(armyTotalNum_atk .. "/" .. SELECT_NUM_MAX.ARMY_ATK)
			elseif (button.data.nType == 4) then --点到了防守进攻兵种
				--更新已配置的兵种(防守)的数量
				_frmNode.childUI["ConfigCardLabel_Army_DefNum"]:setText(armyTotalNum_def .. "/" .. SELECT_NUM_MAX.ARMY_DEF)
			end
			
			--删除本控件
			button:del()
			
			--标识选中了此控件
			--找到此卡牌的滑动控件
			local btni = nil
			for j = 1, #current_tCfgCard_DragCtrls, 1 do
				btni = current_tCfgCard_DragCtrls[j]
				local nType = btni.data.nType
				local id = btni.data.id
				
				if (button.data.nType == nType) and (button.data.id == id) then --找到了
					current_cfg_selected_ctrl = btni
					--print("selectTipCtrl", selectTipCtrl, selectTipCtrl.data.nType)
					
					--显示滑动控件选中框
					On_create_card_selectbox(btni)
					--if btni.childUI["selectbox"] then
					--	btni.childUI["selectbox"].handle._n:setVisible(true)
					--end
					
					break
				end
			end
			
			--更新自身控件
			--print("更新自身控件", "nType=" .. button.data.nType)
			--刷新右侧详细信息
			if (button.data.nType == 1) then --点到了英雄
				--显示英雄卡牌的详细信息
				On_show_herocard_detail_info(btni)
			elseif (button.data.nType == 2) then --点到了塔
				--显示塔卡牌的详细信息
				On_show_towercard_detail_info(btni)
			elseif (button.data.nType == 3) then --点到了进攻兵种
				--显示进攻兵种卡牌的详细信息
				On_show_armycard_detail_info(btni)
			elseif (button.data.nType == 4) then --点到了防守兵种
				--显示防守兵种卡牌的详细信息
				On_show_armycard_detail_info(btni)
			end
			
			--取消挡操作
			hUI.NetDisable(0)
		end
	end
	
	--函数：比较两套卡组，是否一致
	IsCompareTwoConfigCardsSame = function(PlayerData1, PlayerData2)
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--卡牌为空，返回false
		if (not PlayerData1) or (not PlayerData2) then
			print("卡牌为空")
			return false
		end
		
		--开始比较英雄
		local herocard1 = PlayerData1.herocard or {}
		local herocard2 = PlayerData2.herocard or {}
		
		--英雄数量不一致，返回false
		if (#herocard1 ~= #herocard2) then
			print("英雄数量不一致", #herocard1, #herocard2)
			return false
		end
		--开始遍历每个英雄i
		for i = 1, #herocard1, 1 do
			local ti = herocard1[i]
			local idi = ti.id
			local attri = ti.attr
			local tactici = ti.tactic
			local equipmenti = ti.equipment
			local talenti = ti.talent
			local bFindIdi = false --是否找到了本id
			
			--遍历每个英雄j
			for j = 1, #herocard2, 1 do
				local tj = herocard2[j]
				local idj = tj.id
				local attrj = tj.attr
				local tacticj = tj.tactic
				local equipmentj = tj.equipment
				local talentj = tj.talent
				
				if (idi == idj) then
					bFindIdi = true --找到了
					
					--比较attr
					--英雄idi灵魂石不一致，返回false
					if (attri.soulstone ~= attrj.soulstone) then
						print("英雄" .. idi .. "灵魂石不一致")
						return false
					end
					
					--英雄idi经验值不一致，返回false
					if (attri.exp ~= attrj.exp) then
						print("英雄" .. idi .. "经验值不一致")
						return false
					end
					
					--英雄idi等级不一致，返回false
					if (attri.level ~= attrj.level) then
						print("英雄" .. idi .. "等级不一致")
						return false
					end
					
					--英雄idi星级不一致，返回false
					if (attri.star ~= attrj.star) then
						print("英雄" .. idi .. "星级不一致")
						return false
					end
					
					--比较tactic
					--英雄idi战术技能数量不一致，返回false
					if (#tactici ~= #tacticj) then
						print("英雄" .. idi .. "战术技能数量不一致")
						return false
					end
					for k = 1, #tactici, 1 do
						--英雄idi战术技能k技能id不一致，返回false
						if (tactici[k].id ~= tacticj[k].id) then
							print("英雄" .. idi .. "战术技能" .. k .. "技能id不一致")
							return false
						end
						
						--英雄idi战术技能k技能lv不一致，返回false
						if (tactici[k].lv ~= tacticj[k].lv) then
							print("英雄" .. idi .. "战术技能" .. k .. "技能lv不一致")
							return false
						end
					end
					
					--比较talent
					--英雄idi天赋技能数量不一致，返回false
					if (#talenti ~= #talentj) then
						print("英雄" .. idi .. "天赋技能数量不一致")
						return false
					end
					for k = 1, #talenti, 1 do
						--英雄idi天赋技能k技能id不一致，返回false
						if (talenti[k].id ~= talentj[k].id) then
							print("英雄" .. idi .. "天赋技能" .. k .. "技能id不一致")
							return false
						end
						
						--英雄idi天赋技能k技能lv不一致，返回false
						if (talenti[k].lv ~=talentj[k].lv) then
							print("英雄" .. idi .. "天赋技能" .. k .. "技能lv不一致")
							return false
						end
					end
					
					--比较equipment
					if (#equipmenti ~= #equipmentj) then
						print("英雄" .. idi .. "装备数量不一致")
						return false
					end
					for k = 1, #equipmenti, 1 do
						--英雄idi装备k类型不一致，返回false
						if (type(equipmenti[k]) ~= type(equipmentj[k])) then
							print("英雄" .. idi .. "装备" .. k .. "类型不一致")
							return false
						end
						if (type(equipmenti[k]) == "table") then
							for s = 1, #equipmenti[k], 1 do
								--英雄idi装备k孔位置[s]类型不一致，返回false
								if (type(equipmenti[k][s]) ~= type(equipmentj[k][s])) then
									print("英雄" .. idi .. "装备" .. k .. "孔位置[" .. s .. "]类型不一致")
									return false
								end
								if (type(equipmenti[k][s]) == "table") then
									for t = 1, #equipmenti[k][s], 1 do
										--英雄idi装备k孔位置[s]属性t不一致，返回false
										--print("  ", equipmenti[k][s][t], equipmentj[k][s][t])
										if (equipmenti[k][s][t] ~= equipmentj[k][s][t]) then
											--英雄idi装备k孔位置[s]属性t类型不一致，返回false
											if (type(equipmenti[k][s][t]) ~= type(equipmentj[k][s][t])) then
												print("英雄" .. idi .. "装备" .. k .. "孔位置[" .. s .. "]属性" .. t .. "类型不一致")
												return false
											end
											if (type(equipmenti[k][s][t]) == "table") then
												for u = 1, #equipmenti[k][s][t], 1 do
													--print("    ", equipmenti[k][s][t][u], equipmentj[k][s][t][u])
													--英雄idi装备k孔位置[s]属性t值u不一致，返回false
													if (type(equipmenti[k][s][t][u]) ~= type(equipmentj[k][s][t][u])) then
														print("英雄" .. idi .. "装备" .. k .. "孔位置[" .. s .. "]属性" .. t .. "值" .. u .. "不一致")
														return false
													end
												end
											else
												--print("    ", equipmenti[k][s][t], equipmentj[k][s][t])
												--英雄idi装备k孔位置[s]属性t不一致，返回false
												if (equipmenti[k][s][t] ~= equipmentj[k][s][t]) then
													print("英雄" .. idi .. "装备" .. k .. "孔位置[" .. s .. "]属性" .. t .. "不一致")
													return false
												end
											end
										end
									end
								else
									--print(equipmenti[k][s], equipmentj[k][s])
									--英雄idi装备k孔位置[s]属性不一致，返回false
									if (equipmenti[k][s] ~= equipmentj[k][s]) then
										print("英雄" .. idi .. "装备" .. k .. "孔位置[" .. s .. "]属性不一致")
										return false
									end
								end
							end
						else
							--英雄idi装备k属性不一致，返回false
							if (equipmenti[k] ~= equipmentj[k]) then
								print("英雄" .. idi .. "装备" .. k .. "属性不一致")
								return false
							end
						end
					end
					
					break
				end
			end
			
			--英雄idi未找到，不一致，返回false
			if (not bFindIdi) then
				--英雄idi不一致，返回false
				print("英雄" .. idi .. "未找到，不一致")
				return false
			end
		end
		
		--开始比较塔
		local towercard1 = PlayerData1.towercard or {}
		local towercard2 = PlayerData2.towercard or {}
		
		--塔数量不一致，返回false
		if (#towercard1 ~= #towercard2) then
			print("塔数量不一致", #towercard1, #towercard2)
			return false
		end
		--开始遍历每个塔i
		for i = 1, #towercard1, 1 do
			local ti = towercard1[i]
			local idi = ti[1]
			local lvi = ti[2]
			local numi = ti[3]
			local bFindIdi = false --是否找到了本id
			
			--遍历每个塔j
			for j = 1, #towercard2, 1 do
				local tj = towercard2[j]
				local idj = tj[1]
				local lvj = tj[2]
				local numj = tj[3]
				
				if (idi == idj) then
					bFindIdi = true --找到了
					
					--比较属性
					--塔idi等级不一致，返回false
					if (lvi ~= lvj) then
						print("塔" .. idi .. "等级不一致")
						return false
					end
					
					--塔idi数量不一致，返回false
					if (numi ~= numj) then
						print("塔" .. idi .. "数量不一致")
						return false
					end
					
					break
				end
			end
			
			--塔idi未找到，不一致，返回false
			if (not bFindIdi) then
				print("塔" .. idi .. "未找到，不一致")
				return false
			end
		end
		
		--开始比较兵种
		local tacticcard1 = PlayerData1.tacticcard or {}
		local tacticcard2 = PlayerData2.tacticcard or {}
		
		--兵种数量不一致，返回false
		if (#tacticcard1 ~= #tacticcard2) then
			print("兵种数量不一致", #tacticcard1, #tacticcard2)
			return false
		end
		--开始遍历每个兵种i
		for i = 1, #tacticcard1, 1 do
			local ti = tacticcard1[i]
			local idi = ti[1]
			local lvi = ti[2]
			local numi = ti[3]
			local bFindIdi = false --是否找到了本id
			
			--遍历每个兵种j
			for j = 1, #tacticcard2, 1 do
				local tj = tacticcard2[j]
				local idj = tj[1]
				local lvj = tj[2]
				local numj = tj[3]
				
				if (idi == idj) then
					bFindIdi = true --找到了
					
					--比较属性
					--兵种idi等级不一致，返回false
					if (lvi ~= lvj) then
						print("兵种" .. idi .. "等级不一致")
						return false
					end
					
					--兵种idi数量不一致，返回false
					if (numi ~= numj) then
						print("兵种" .. idi .. "数量不一致")
						return false
					end
					
					break
				end
			end
			
			--兵种idi未找到，不一致，返回false
			if (not bFindIdi) then
				print("兵种" .. idi .. "未找到，不一致")
				return false
			end
		end
		
		--通过所有校验，都一致，返回true
		return true
	end
	
	--函数：将本地的卡牌配置上传到服务器(铜雀台)
	UploadClientConfigCard_page2 = function()
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("UploadClientConfigCard_page2", #current_tCfgCard)
		
		--没有数据，不用上传
		if (#current_tCfgCard_Data == 0) then
			return
		end
		
		--显示不超过最大等级
		local maxLvTower = hVar.TACTIC_LVUP_INFO.maxTacticLv or 1
		local maxLvArmy = hVar.TACTIC_LVUP_INFO.maxArmyLv or 1
		
		--组织数据
		local PlayerData = {}
		
		--英雄数据部分（铜雀台）
		PlayerData.herocard = {}
		
		for i = 1, #current_tCfgCard_Data, 1 do
			local datai = current_tCfgCard_Data[i]
			if datai and (datai ~= 0) then
				if (datai.nType == 1) then --1:英雄类型
					local id = datai.id --单位类型id
					local HeroCard = hApi.GetHeroCardById(id) or {}
					HeroCard.attr = HeroCard.attr or {}
					HeroCard.tactic = HeroCard.tactic or {}
					HeroCard.equipment = HeroCard.equipment or {}
					HeroCard.talent = HeroCard.talent or {}
					local attr = {}
					attr.soulstone = HeroCard.attr.soulstone or 0
					attr.exp = HeroCard.attr.exp or 0
					attr.level = HeroCard.attr.level or 1
					attr.star = HeroCard.attr.star or 1
					
					local tactic = {}
					for i = 1, #HeroCard.tactic, 1 do
						tactic[i] = {id = HeroCard.tactic[i].id, lv = HeroCard.tactic[i].lv,} --todo: 测试
						--tactic[i] = {id = HeroCard.tactic[i].id, lv = 1,}
					end
					
					local equipment = {}
					for i = 1, #HeroCard.equipment, 1 do
						if (type(HeroCard.equipment[i]) == "table") then
							equipment[i] = {}
							
							for j = 1, #HeroCard.equipment[i], 1 do
								equipment[i][j] = HeroCard.equipment[i][j]
							end
							
							--todo: 测试
							--equipment[i][3] = {}
						else
							equipment[i] = HeroCard.equipment[i]
						end
					end
					
					local talent = {}
					for i = 1, #HeroCard.talent, 1 do
						talent[i] = {id = HeroCard.talent[i].id, lv = HeroCard.talent[i].lv,} --todo: 测试
						--talent[i] = {id = HeroCard.talent[i].id, lv = 1,} --todo: 测试
					end
					
					table.insert(PlayerData.herocard,
					{
						attr = attr,
						tactic = tactic,
						id = id,
						equipment = equipment,
						talent = talent,
					})
					--print("英雄卡", id)
				end
			end
		end
		
		--塔类部分（铜雀台）
		PlayerData.towercard = {}
		--table.insert(PlayerData.towercard, {1021, 1, 0}) --pvp模式默认带兵营
		
		--统计塔类战术技能卡
		for i = 1, #current_tCfgCard_Data, 1 do
			local datai = current_tCfgCard_Data[i]
			if datai and (datai ~= 0) then
				if (datai.nType == 2) then --2:塔类型
					local towerId = datai.id
					local towerLv = datai.lv
					--显示不超过最大等级
					if (towerLv > maxLvTower) then
						towerLv = maxLvTower
					end
					
					table.insert(PlayerData.towercard, {towerId, towerLv, 0}) --todo: 测试
					--table.insert(PlayerData.towercard, {towerId, 5, 0}) --5级
					--print("塔卡", towerId)
				end
			end
		end
		
		--兵种卡部分（铜雀台）
		PlayerData.tacticcard = {}
		
		--统计兵种卡
		for i = 1, #current_tCfgCard_Data, 1 do
			local datai = current_tCfgCard_Data[i]
			if datai and (datai ~= 0) then
				if (datai.nType == 3) or (datai.nType == 4) then --3:进攻类型 / 4:防御兵种
					local tacticId = datai.id
					local tacticLv = datai.lv
					--显示不超过最大等级
					if (tacticLv > maxLvArmy) then
						tacticLv = maxLvArmy
					end
					
					table.insert(PlayerData.tacticcard, {tacticId, tacticLv, 0}) --todo: 测试
					--table.insert(PlayerData.tacticcard, {tacticId, 1, 0})
					--print("兵种卡", tacticId)
				end
			end
		end
		
		
		--卡牌与上一次配置一致，不用上传
		if IsCompareTwoConfigCardsSame(PlayerData, current_ConfigCardList) then
			return
		end
		
		--先清空本地数据
		current_tCfgCard_Data = {}
		current_ConfigCardList = nil --geyachao: 需要清除吗？？？
		--print("先清空本地数据, 更新战斗配置")
		
		--更新战斗配置
		local strCfg = hApi.serialize(PlayerData) --战斗配置
		--local cfgId = 2
		local cfgId = 9999
		print("铜雀台更新战斗配置:upload_battle_cfg, cfgId = " .. cfgId)
		SendPvpCmdFunc["upload_battle_cfg"](strCfg, cfgId)
	end
	
	--函数：定时刷新PVP配卡界面的滚动(铜雀台)
	refresh_pvproom_UI_loop_page24 = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local SPEED = 50 --速度
		--print(b_need_auto_fixing_pvproom_page14)
		
		if b_need_auto_fixing_pvproom_page14 then
			---第一个控件的数据
			local PvpRoomBtn1 = _frmNode.childUI["ConfigCard_FirstCtrl"]
			local btn1_cx, btn1_cy = 0, 0 --第一个PVP房间中心点位置
			local btn1_ly = 0 --第一个PVP房间最上侧的x坐标
			local delta1_ly = 0 --第一个PVP房间距离上侧边界的距离
			btn1_cx, btn1_cy = PvpRoomBtn1.data.x, PvpRoomBtn1.data.y --第一个PVP房间中心点位置
			btn1_ly = btn1_cy + PVPROOM.HEIGHT / 2 --第一个PVP房间最上侧的x坐标
			delta1_ly = btn1_ly + 53 --第一个PVP房间距离上侧边界的距离
			
			--最后一个控件的数据
			local PvpRoomBtnN = _frmNode.childUI["ConfigCard_LastCtrl"]
			local btnN_cx, btnN_cy = 0, 0 --最后一个PVP房间中心点位置
			local btnN_ry = 0 --最后一个PVP房间最下侧的x坐标
			local deltNa_ry = 0 --最后一个PVP房间距离下侧边界的距离
			btnN_cx, btnN_cy = PvpRoomBtnN.data.x, PvpRoomBtnN.data.y --最后一个PVP房间中心点位置
			btnN_ry = btnN_cy - PVPROOM.HEIGHT / 2 --最后一个PVP房间最下侧的x坐标
			deltNa_ry = btnN_ry + 770 --最后一个PVP房间距离下侧边界的距离
			--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
			
			--print("delta1_ly=" .. delta1_ly, ", deltNa_rx=" .. deltNa_rx)
			--如果第一个PVP房间的头像跑到下边，那么优先将第一个PVP房间头像贴边
			if (delta1_ly < 0) then
				--print("优先将第一个PVP房间头像贴边")
				--需要修正
				--不会选中PVP房间
				selected_pvproomEx_idx_page14 = 0 --选中的PVP房间索引
				
				--没有惯性
				draggle_speed_y_pvproom_page14 = 0
				
				local speed = SPEED
				if ((delta1_ly + speed) > 0) then --防止走过
					speed = -delta1_ly
					delta1_ly = 0
				end
				
				--每个按钮向上侧做运动
				for i = 1, #current_tCfgCard_DragCtrls, 1 do
					local ctrli = current_tCfgCard_DragCtrls[i] --第i项
					if (ctrli) then --存在PVP房间信息第i项表
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
				_frmNode.childUI["PvpCfgCardPageUp"].handle.s:setVisible(false) --上翻页提示
				_frmNode.childUI["PvpCfgCardPageDown"].handle.s:setVisible(true) --下翻页提示
			elseif (delta1_ly ~= 0) and (deltNa_ry > 0) then --第一个头像没有贴上侧，并且最后一个头像没有贴下侧，那么再将最后一个PVP房间头像贴边
				--print("将最后一个PVP房间头像贴边")
				--需要修正
				--不会选中PVP房间
				selected_pvproomEx_idx_page14 = 0 --选中的PVP房间索引
				
				--没有惯性
				draggle_speed_y_pvproom_page14 = 0
				
				local speed = SPEED
				if ((deltNa_ry - speed) < 0) then --防止走过
					speed = deltNa_ry
					deltNa_ry = 0
				end
				
				--每个按钮向下侧做运动
				for i = 1, #current_tCfgCard_DragCtrls, 1 do
					local ctrli = current_tCfgCard_DragCtrls[i] --第i项
					if (ctrli) then --存在PVP房间信息第i项表
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
				_frmNode.childUI["PvpCfgCardPageUp"].handle.s:setVisible(true) --上分翻页提示
				_frmNode.childUI["PvpCfgCardPageDown"].handle.s:setVisible(false) --下分翻页提示
			elseif (draggle_speed_y_pvproom_page14 ~= 0) then --沿着当前的速度方向有惯性地运动一会
				--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_y_pvproom_page14)
				--不会选中PVP房间
				selected_pvproomEx_idx_page14 = 0 --选中的PVP房间索引
				--print("    ->   draggle_speed_y_pvproom_page14=", draggle_speed_y_pvproom_page14)
				
				if (draggle_speed_y_pvproom_page14 > 0) then --朝上运动
					local speed = (draggle_speed_y_pvproom_page14) * 1.0 --系数
					friction_pvproom_page14 = friction_pvproom_page14 - 0.5
					draggle_speed_y_pvproom_page14 = draggle_speed_y_pvproom_page14 + friction_pvproom_page14 --衰减（正）
					
					if (draggle_speed_y_pvproom_page14 < 0) then
						draggle_speed_y_pvproom_page14 = 0
					end
					
					--最后一个PVP房间的坐标不能跑到最下侧的上边去
					if ((deltNa_ry + speed) > 0) then --防止走过
						speed = -deltNa_ry
						deltNa_ry = 0
						
						--没有惯性
						draggle_speed_y_pvproom_page14 = 0
					end
					
					--每个按钮向上侧做运动
					for i = 1, #current_tCfgCard_DragCtrls, 1 do
						local ctrli = current_tCfgCard_DragCtrls[i] --第i项
						if (ctrli) then --存在PVP房间信息第i项表
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
				elseif (draggle_speed_y_pvproom_page14 < 0) then --朝下运动
					local speed = (draggle_speed_y_pvproom_page14) * 1.0 --系数
					friction_pvproom_page14 = friction_pvproom_page14 + 0.5
					draggle_speed_y_pvproom_page14 = draggle_speed_y_pvproom_page14 + friction_pvproom_page14 --衰减（负）
					
					if (draggle_speed_y_pvproom_page14 > 0) then
						draggle_speed_y_pvproom_page14 = 0
					end
					
					--第一个PVP房间的坐标不能跑到最上侧的下边去
					if ((delta1_ly + speed) < 0) then --防止走过
						speed = -delta1_ly
						delta1_ly = 0
						
						--没有惯性
						draggle_speed_y_pvproom_page14 = 0
					end
					
					--每个按钮向下侧做运动
					for i = 1, #current_tCfgCard_DragCtrls, 1 do
						local ctrli = current_tCfgCard_DragCtrls[i] --第i项
						if (ctrli) then --存在PVP房间信息第i项表
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
					_frmNode.childUI["PvpCfgCardPageUp"].handle.s:setVisible(false) --上分翻页提示
				else
					_frmNode.childUI["PvpCfgCardPageUp"].handle.s:setVisible(true) --上分翻页提示
				end
				if (deltNa_ry == 0) then
					_frmNode.childUI["PvpCfgCardPageDown"].handle.s:setVisible(false) --下分翻页提示
				else
					_frmNode.childUI["PvpCfgCardPageDown"].handle.s:setVisible(true) --下分翻页提示
				end
			else --停止运动
				b_need_auto_fixing_pvproom_page14 = false
				friction_pvproom_page14 = 0
			end
		end
	end
	
	--函数: 动态加载资源
	__DynamicAddRes = function()
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--加载资源
		--动态加载竞技场背景图
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/pvproombg.png")
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/pvproombg.png")
			print("加载竞技场背景大图！")
		end
		--print(tostring(texture))
		local tSize = texture:getContentSize()
		local pSprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
		pSprite:setPosition(0, 0)
		pSprite:setAnchorPoint(ccp(0.5, 0.5))
		pSprite:setScaleX(956 / tSize.width)
		pSprite:setScaleY(544 / tSize.height)
		_childUI["panel_bg"].data.pSprite = pSprite
		_childUI["panel_bg"].handle._n:addChild(pSprite)
	end
	
	--函数: 动态删除资源
	__DynamicRemoveRes = function()
		local _frm = hGlobal.UI.PhoneBattleRoomFrm_Endless
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--删除资源
		--删除竞技场背景图
		_childUI["panel_bg"].handle._n:removeChild(_childUI["panel_bg"].data.pSprite, true)
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/pvproombg.png")
		if texture then
			CCTextureCache:sharedTextureCache():removeTexture(texture)
			print("清空竞技场背景大图！")
		end
	end
	
	--监听擂台赛、铜雀台游戏结果事件，界面通知
	hGlobal.event:listen("LocalEvent_Pvp_ArenaResult_Info", "_ArenaResult_Info_PVP", function(pResultList, sessionType)
		if (sessionType == 2) then --2:铜雀台
			local userNameList = {} --玩家1
			local bWin = false --是否胜利
			
			for i = 1, #pResultList, 1 do
				local dbid = pResultList[i].dbid
				local name = pResultList[i].name
				local result = pResultList[i].result
				--print("LocalEvent_Pvp_ArenaResult_Info", sessionType, dbid, name, result)
				if (dbid > 0) then
					--只显示胜利、失败局
					--SURRENDER = -7,		--投降（有效局的主动离开算投降）
					--LEAVE = -6,		--主动离开游戏（无效局的主动离开算无效）
					--LOST = -5,		--掉线
					--KICK = -4,		--卡了被踢
					--OUTSYNC = -3,		--不同步
					--ERROR = -2,		--异常
					--UNINIT = -1,		--未初始化
					--WIN = 0,		--赢
					--LOSE = 1,		--败
					--DRAW = 2,		--平
					
					--有一方胜利都算胜利
					if (result == 0) then
						bWin = true
					end
					
					userNameList[#userNameList+1] = name
				end
			end
			
			--print("监听擂台赛游戏结果事件，界面通知", userName, enemyName)
			
			--铜雀台失败局，不显示通知
			if (not bWin) then
				return
			end
			
			hApi.BubbleQueueArenaMsg(userNameList[1], userNameList[2], 2)
		end
	end)
	
	--监听打开PPV无尽联机对战房间事件
	hGlobal.event:listen("localEvent_ShowPhone_PVPRoomFrm_Endless", "__ShowPVPRoomFrm_Endless", function()
		--触发事件，显示积分、金币界面
		--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
		
		--加载 pvp.plist
		xlLoadResourceFromPList("data/image/misc/pvp.plist")
		
		--动态加载pvp背景图
		__DynamicAddRes()
		
		--显示对战房间界面
		hGlobal.UI.PhoneBattleRoomFrm_Endless:show(1)
		hGlobal.UI.PhoneBattleRoomFrm_Endless:active()
		
		--打开上一次的分页（默认显示第1个分页:PVP房间）
		local lastPageIdx = CurrentSelectRecord.pageIdx
		if (lastPageIdx == 0) then
			lastPageIdx = 2
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
		--播放背景音乐
		--hApi.PlaySoundBG(g_channel_town, "fight02")
	end)
end

--test
--[[
--测试代码
if hGlobal.UI.PhoneBattleRoomFrm_Endless then --删除上一次的PVP无尽联机对战界面
	hGlobal.UI.PhoneBattleRoomFrm_Endless:del()
	hGlobal.UI.PhoneBattleRoomFrm_Endless = nil
end
hGlobal.UI.InitBattleRoomFrm_Endless("include") --测试创建PVP无尽联机对战界面
--触发事件，显示PVP铜雀台对战界面界面
hGlobal.event:event("localEvent_ShowPhone_PVPRoomFrm_Endless")
--for i = 1, 20, 1 do
--	local singleRoomAbstractList =
--	{
--		{id = i, name = "策马三国打斗打" .. i, released = true, cfgId = 2, rm = 80000001, mapName = "测试地图", mapInfo = {}, state = 1, allPlayerNum = 2, enterPlayerNum = 1, sessionState = 0, sessionBeginTimestamp = -1, enterPlayerName = ":策马奔腾", bUseEquip = true},
--	}
--	hGlobal.event:event("LocalEvent_Pvp_SingleRoomsAbstractChanged", singleRoomAbstractList)
--end
]]
