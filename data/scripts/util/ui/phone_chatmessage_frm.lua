--聊天面板

--iPhoneX黑边宽
local iPhoneX_WIDTH = 0
if (g_phone_mode == 4) then --iPhoneX
	iPhoneX_WIDTH = 80
end

local iPhoneX_HEIGHT = 0

if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
	iPhoneX_WIDTH = 0
	if (g_phone_mode == 4) then
		--iPhoneX_HEIGHT = 80
	end
	iPhoneX_HEIGHT = hVar.SCREEN.h / 2 - 360
elseif hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
	if (g_phone_mode == 4) then
		iPhoneX_WIDTH = 80
	end
	iPhoneX_HEIGHT = 0
end

local BOARD_WIDTH = 720 --聊天面板的宽度
local BOARD_HEIGHT = 720	--hVar.SCREEN.h - 10 - 2 * iPhoneX_HEIGHT	--聊天面板的高度	--edit by mj --hVar.SCREEN.h - 10	
local BOARD_OFFSETY = -0 --聊天面板y偏移中心点的值
local BOARD_POS_X = iPhoneX_WIDTH --聊天面板的x位置（最左侧）
local BOARD_POS_Y = hVar.SCREEN.h - iPhoneX_HEIGHT --hVar.SCREEN.h - 10 / 2 + BOARD_OFFSETY - iPhoneX_HEIGHT --聊天面板的y位置（最顶侧） --edit by mj --hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY 

local CHAT_BOARD_HEIGHT = BOARD_HEIGHT

local CHAT_INFO_FRM_POS_X = BOARD_WIDTH / 2				--BOARD_WIDTH / 2 + 2 		--聊天具体面板x位置
local CHAT_INFO_FRM_POS_Y = BOARD_HEIGHT / -2 			--BOARD_HEIGHT / -2 + 5 	--聊天具体面板y位置
local CHAT_INFO_FRM_POS_HEIGHT = BOARD_HEIGHT - 116		--BOARD_HEIGHT - 122 	--BOARD_HEIGHT - 126		--聊天具体面板高

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
local RefreshSelectedCardFrame = hApi.DoNothing --更新绘制当前查看的卡牌的信息

--分页1：世界聊天界面
local OnCreateWorldChatInfoFrame = hApi.DoNothing --创建世界聊天界面（第1个分页）
local on_create_single_message_UI = hApi.DoNothing --创建单条聊天信息
local on_create_single_message_UI_Async = hApi.DoNothing --异步创建单条聊天信息
--local on_receive_limittime_gift_event = hApi.DoNothing --收到限时礼包商品信息返回
local on_receive_grouperver_connect_back_event = hApi.DoNothing --收到工会服务器连接socket结果返回
local on_receive_group_server_login_back_event = hApi.DoNothing --收到工会服务器登陆结果返回
local on_receive_chat_init_event = hApi.DoNothing --收到聊天模块初始化事件返回
local on_receive_chat_id_list_event = hApi.DoNothing --收到聊天消息id列表事件返回
local on_receive_chat_content_list_event = hApi.DoNothing --收到聊天消息列表内容事件返回
local on_receive_single_chat_message_event = hApi.DoNothing --收到单条聊天消息事件返回
local on_receive_update_chat_message_event = hApi.DoNothing --收到更新聊天消息事件返回
local on_receive_remove_chat_message_event = hApi.DoNothing --收到删除聊天消息事件返回
local on_receive_chat_forbidden_event = hApi.DoNothing --收到被禁言的通知返回
local on_receive_chat_private_invite_event = hApi.DoNothing --收到发起私聊请求的结果返回
local on_receive_group_result_event = hApi.DoNothing --收到工会操作结果返回
local on_receive_group_invite_back_event = hApi.DoNothing --收到军团邀请函申请结果返回
local on_app_enter_background_event = hApi.DoNothing --程序进入后台事件返回
local on_game_end_event = hApi.DoNothing --游戏局结束事件
local on_pvp_wait_player_event = hApi.DoNothing --PVP等待其他玩家事件
local on_pvp_local_noheart_event = hApi.DoNothing --PVP本地长时间未响应事件
local on_android_local_disconnect_event = hApi.DoNothing --安卓本地掉线事件
local on_receive_pvp_connect_back_event_chat = hApi.DoNothing --收到pvp连接结果回调
local on_receive_pvp_login_back_event_chat = hApi.DoNothing --收到pvp登入结果回调
local on_receive_pvp_baseinfo_query_back_event_chat = hApi.DoNothing --收到pvp基础信息初始化结果回调
local on_receive_pvp_NetLogicError_event_chat = hApi.DoNothing --收到pvp游戏错误提示事件回调
local on_receive_pvp_EnterRoom_Fail_event_page_chat = hApi.DoNothing --进入pvp房间失败事件
local on_receive_pvp_EnterRoom_Success_event_page_chat = hApi.DoNothing --进入聊天直接进入pvp房间成功事件
local refresh_chatnet_timeout_timer = hApi.DoNothing --查询聊天超时一次性timer
local refresh_chatframe_scroll_world_loop = hApi.DoNothing --刷新世界聊天界面滚动的timer
local refresh_chatframe_autolink_loop = hApi.DoNothing --刷新聊天界面自动连接工会服务器的timer
local refresh_async_paint_message_loop = hApi.DoNothing --异步绘制消息的timer
local getUpDownOffset = hApi.DoNothing --获得第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离
local onCreateNewMessageHint = hApi.DoNothing --创建新消息提示
local onRemoveNewMessageHint = hApi.DoNothing --删除新消息提示
local onShowScrollBarHint = hApi.DoNothing --显示滚动条提示
local onHideScrollBarHint = hApi.DoNothing --隐藏滚动条提示
local OnCreateChatDialogueTip = hApi.DoNothing --创建消息互动操作界面tip
local on_update_notice_tanhao = hApi.DoNothing --更新叹号提示
local update_pay_redpacket_msg_paint = hApi.DoNothing --更新支付（土豪）红包消息界面绘制
local OnClickWorldRedPacketBtn = hApi.DoNothing --点击领世界红包按钮

--分页2: 邀请界面 -> 分页3
local OnCreateInviteChatInfoFrame = hApi.DoNothing --创建私聊天界面（第2个分页）
local refresh_chatframe_scroll_invite_loop = hApi.DoNothing --刷新邀请聊天界面倒计时的timer
local OnClickInviteJoinBtn = hApi.DoNothing --点击军团邀请函的申请按钮
local OnClickInviteNotJoinBtn = hApi.DoNothing --点击军团邀请函的不申请按钮
local OnClickInviteBattleCoupleBtn = hApi.DoNothing --点击组队邀请的前往组队按钮

--分页3: 私聊界面 -> 分页2
local OnCreatePrivateChatInfoFrame = hApi.DoNothing --创建私聊天界面（第3个分页）
local on_create_single_friend_UI = hApi.DoNothing --创建单条好友信息
local refresh_chatframe_scroll_private_loop = hApi.DoNothing --刷新私聊好友界面滚动的timer
local getLeftRightOffset = hApi.DoNothing --获得好友第一个控件和最后一个控件距离最左面边界线和最右面边界线的距离
local OnSelectedPrivateFriend = hApi.DoNothing --选中了某个私聊好友
local on_add_private_friend_event = hApi.DoNothing --收到添加单个私聊好友事件
local on_remove_private_friend_event = hApi.DoNothing --收到删除单个私聊好友事件
local OnClickPrivateInviteBtn = hApi.DoNothing --点击私聊好友验证按钮
local OnClickDeleteInviteBtn = hApi.DoNothing --点击私聊好友删除按钮

--分页4：军团界面
local OnCreateGroupChatInfoFrame = hApi.DoNothing --创建军团聊天界面（第4个分页）
local refresh_chat_redpacket_loop = hApi.DoNothing --刷新红包领取倒计时的timer
local update_group_redpacket_msg_paint = hApi.DoNothing --更新军团红包消息界面绘制
local on_create_group_redpacket_send_frame = hApi.DoNothing --创建发军团红包界面
local OnCreateSendRedPacketTipFrame = hApi.DoNothing --创建发红包规则介绍的tip
local OnClickGroupRedPacketBtn = hApi.DoNothing --点击领军团红包按钮

--分页5：组队界面
local OnCreateCoupleChatInfoFrame = hApi.DoNothing --创建组队聊天界面（第5个分页）

--其他函数
local on_spine_screen_event = hApi.DoNothing --横竖屏切换

--分页1：世界聊天分页的参数
--local current_connect_state = 0 --工会服务器socket连接状态
--local current_login_state = 0 --工会服务器登陆状态
local current_msgWorldFlag = 0 --世界聊天开关状态
local current_msgWorldNum = 0 --世界聊天今日次数
local current_msgWorldTime = 0 --最近一次世界聊天时间(本地时区)
local current_msgForbidden = 0 --是否禁言
local current_msgForbiddenTime = 0 --上次禁言时间(本地时区)
local current_msgForbidden_minute = 0 --禁言时长（单位: 分钟）
local current_msgForbidden_op_uid = 0 --禁言的操作者uid
local current_msgGroupId = 0 --玩家所在的军团id
local current_msgGroupLevel = 0 --玩家所在的军团权限
local current_msgInvite_group_list = {} --军团邀请函id表
local current_msgPrivate_friend_chat_list = {} --私聊好友列表
local current_msg_private_friend_last_uid --私聊最近一次的好友uid
local current_group_send_redpacket_num = 0 --今日发送军团红包的次数
local current_last_group_send_redpacket_time = 0 --最近一次发送军团红包的时间
local current_enterNameEditBox = nil --输入框（防止安卓闪退新增的检测输入框是否存在）
local current_tCallback = nil --本界面的一些回调函数
local current_groupId_gm = 0 --GM请求查看指定聊天记录的军团id
local current_IsAdviseWorld = false --是否首次点开世界聊天（首次点开，最后一条消息是聊天忠告）
local current_nAdviseMsgPrev = 0 --聊天忠告消息的前一条消息id
local current_IsQueryChampion = false --是否查询过称号（因为称号有有效期，每次打开聊天，在首次输入文字后查询一次称号）

local current_chat_type = 0 --聊天频道

local current_msg_id_list_world = {} --世界聊天界面展示的消息id列表
local current_chat_msg_hostory_cache_world = {} --本次缓存的世界聊天历史消息(用于降低查询频率)

local current_msg_id_list_invite = {} --邀请聊天界面展示的消息id列表
local current_chat_msg_hostory_cache_invite = {} --本次缓存的邀请聊天历史消息(用于降低查询频率)

local current_msgPrivate_msg_id_list = {} --私聊消息id列表
local current_msgPrivate_msg_hostory_cache = {} --私聊消息内容列表

local current_msg_id_list_group = {} --军团聊天界面展示的消息id列表
local current_chat_msg_hostory_cache_group = {} --本次缓存的军团聊天历史消息(用于降低查询频率)

local current_msg_id_list_couple = {} --组队聊天界面展示的消息id列表
local current_chat_msg_hostory_cache_couple = {} --本次缓存的组队聊天历史消息(用于降低查询频率)

local current_async_paint_list = {} --当前待异步绘制的聊天消息列表
local ASYNC_PAINTNUM_ONCE = 5 --一次绘制几条

local MAX_SPEED = 50 --最大速度
local current_DLCMap_max_num = 0 --条目总数量
--local current_in_scroll_down = true --是否下拉到底部（为true时有新消息自动滚到最下端）

--local WEAPON_X_NUM = 1 --x数量
--local WEAPON_Y_NUM = 1 --y数量
local WEAPON_WIDTH = 124 --宽度
local WEAPON_HEIGHT = 90 --高度
local CHAT_HEIGHT_MIN = 45 --聊天文本消息边框最小高度

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
local friction_dlcmapinfo_coefficient = 0.5 --阻力衰减系数(默认值)

--分页2：邀请分页的参数
local current_DLCMap_roomid = 0 --当前请求组队副本的房间消息id

--分页3：私聊分页的参数
local current_DLCMap_friend_max_num = 0 --私聊好友总数量
local PRVAITE_FRIEND_WH = 86 --私聊好友图标大小(普通)
local PRVAITE_FRIEND_WH_BIG = 96 --私聊好友大小(选中后)

--私聊控制参数
local click_pos_x_friendinfo = 0 --开始按下的坐标x
local click_pos_y_friendinfo = 0 --开始按下的坐标y
local last_click_pos_x_friendinfo = 0 --上一次按下的坐标x
local last_click_pos_y_friendinfo = 0 --上一次按下的坐标y
local draggle_speed_x_friendinfo = 0 --当前滑动的速度x
local selected_friendinfoEx_idx = 0 --选中的DLC地图面板ex索引
local click_scroll_friendinfo = false --是否在滑动DLC地图面板中
local b_need_auto_fixing_friendinfo = false --是否需要自动修正
local friction_friendinfo = 0 --阻力
local friction_friendinfo_coefficient = 0.5 --阻力衰减系数(默认值)

--分页4：军团分页的参数
--无

--当前选中的记录
local CurrentSelectRecord = {pageIdx = 0, contentIdx = 0, cardId = 0,} --当前选择的分页、数据项的信息记录

--弹出聊天界面
hGlobal.UI.InitChatDialogueFrm = function(mode)
	local tInitEventName = {"LocalEvent_Phone_ShowChatDialogue", "ShowChatDialogueFrm"}
	--if (mode ~= "include") then
	if (mode ~= "reload") then
		--return tInitEventName
		return
	end
	
	--再计算一次，这样切换横竖屏才能读取到
	-------------------------------------------------------------------------------------
	if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
		iPhoneX_WIDTH = 0
		if (g_phone_mode == 4) then --iPhoneX
			--iPhoneX_HEIGHT = 80
		end
		iPhoneX_HEIGHT = hVar.SCREEN.h / 2 - 360
	elseif hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL then
		if (g_phone_mode == 4) then --iPhoneX
			iPhoneX_WIDTH = 80
		end
		iPhoneX_HEIGHT = 0
	end

	BOARD_WIDTH = 720 --聊天面板的宽度
	BOARD_HEIGHT = 720	--聊天面板的高度
	BOARD_OFFSETY = -0 --聊天面板y偏移中心点的值
	BOARD_POS_X = iPhoneX_WIDTH --聊天面板的x位置（最左侧）
	BOARD_POS_Y = hVar.SCREEN.h - iPhoneX_HEIGHT  --聊天面板的y位置

	CHAT_BOARD_HEIGHT = BOARD_HEIGHT

	CHAT_INFO_FRM_POS_X = BOARD_WIDTH / 2 			--聊天具体面板x位置
	CHAT_INFO_FRM_POS_Y = BOARD_HEIGHT / -2 		--聊天具体面板y位置
	CHAT_INFO_FRM_POS_HEIGHT = BOARD_HEIGHT - 116	--聊天具体面板高
	-------------------------------------------------------------------------------------

	--删除上一次的界面
	if hGlobal.UI.ChatDialogueFrm then
		hGlobal.UI.ChatDialogueFrm:del()
		hGlobal.UI.ChatDialogueFrm = nil
	end
	
	--清除输入框指针
	current_enterNameEditBox = nil
	
	--清除可能的发红包界面
	if hGlobal.UI.SendRedPacketFrm then
		hGlobal.UI.SendRedPacketFrm:del()
		hGlobal.UI.SendRedPacketFrm = nil
	end
	
	--清除可能的玩家操作界面
	if hGlobal.UI.GameCoinTipFrame then
		hGlobal.UI.GameCoinTipFrame:del()
		hGlobal.UI.GameCoinTipFrame = nil
	end
	
	--加载资源
	--xlLoadResourceFromPList("data/image/misc/pvp.plist")
	hApi.clearTimer("__ONCE_CHAT_TIMEOUNT_TIMER__")
	hApi.clearTimer("__CHATFRAME_WORLD_TIMER_UPDATE__")
	hApi.clearTimer("__CHATFRAME_INVITE_TIMER_UPDATE__")
	hApi.clearTimer("__CHATFRAME_PRIVATE_TIMER_UPDATE__")
	hApi.clearTimer("__CHATFRAME_REDPACKET_TIMER_UPDATE__")
	hApi.clearTimer("__CHATAUTOLINK_TIMER_UPDATE__")
	hApi.clearTimer("__CHATPAINT_MESSAGE_ASYNC__")
	hApi.clearTimer("__VIEWDETAIL_PAY_REDPACKET_LIST__")
	hApi.clearTimer("__PAY_REDPACKET_CHANGE_ASYNC_TIMER__")
	hApi.clearTimer("__ONCE_CHAT_PAYREDPACKET_AMIN_TIMER__")
	
	--创建聊天面板
	hGlobal.UI.ChatDialogueFrm = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		z = hZorder.MainBaseFirstFrm + 1,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 2,
		show = 0, --一开始不显示
		--border = "UI:TileFrmBasic_thin",
		--border = "UI:TileFrmBack_PVP",
		--background = "panel/panel_part_pvp_00.png",
		background = "panel/panel_part_chat.png",--"panel/panel_part_00.png", --"UI:Tactic_Background",
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
	
	local _frm = hGlobal.UI.ChatDialogueFrm
	local _parent = _frm.handle._n
	
	--左侧裁剪区域
	--世界聊天裁剪区域
	--local _BTC_PageClippingRectWorld = {10, -60, BOARD_WIDTH - 16, hVar.SCREEN.h - 140, 0} -- {x, y, w, h, isShow}
	--local _BTC_PageClippingRectWorld = {10, -60, BOARD_WIDTH - 16, BOARD_HEIGHT - 130, 1} -- {x, y, w, h, isShow}
	local _BTC_PageClippingRectWorld = {8, -66, BOARD_WIDTH - 16, BOARD_HEIGHT - 140, 0} -- {x, y, w, h, isShow}
	local _BTC_pClipNodeWorld = hApi.CreateClippingNode(_frm, _BTC_PageClippingRectWorld, 99, _BTC_PageClippingRectWorld[5], "_BTC_pClipNodeWorld")
	
	--邀请聊天裁剪区域
	--local _BTC_PageClippingRectInvite = {10, -60, BOARD_WIDTH - 16, hVar.SCREEN.h - 140 + 60, 0} -- {x, y, w, h, isShow}
	local _BTC_PageClippingRectInvite = {10, -66, BOARD_WIDTH - 16, BOARD_HEIGHT - 140 + 60, 0} -- {x, y, w, h, isShow}
	local _BTC_pClipNodeInvite = hApi.CreateClippingNode(_frm, _BTC_PageClippingRectInvite, 99, _BTC_PageClippingRectInvite[5], "_BTC_pClipNodeInvite")
	
	--私聊好友列表裁剪区域
	--local _BTC_PageClippingRectPrivate = {10, -60, BOARD_WIDTH - 16, hVar.SCREEN.h - 140, 0} -- {x, y, w, h, isShow}
	local _BTC_PageClippingRectPrivate = {14, -66, BOARD_WIDTH - 28, BOARD_HEIGHT - 140, 0} -- {x, y, w, h, isShow}
	local _BTC_pClipNodePrivate = hApi.CreateClippingNode(_frm, _BTC_PageClippingRectPrivate, 99, _BTC_PageClippingRectPrivate[5], "_BTC_pClipNodePrivate")
	
	--军团聊天裁剪区域
	--local _BTC_PageClippingRectGroup = {10, -60, BOARD_WIDTH - 16, hVar.SCREEN.h - 140, 0} -- {x, y, w, h, isShow}
	local _BTC_PageClippingRectGroup = {10, -66, BOARD_WIDTH - 16, BOARD_HEIGHT - 140, 0} -- {x, y, w, h, isShow}
	local _BTC_pClipNodeGroup = hApi.CreateClippingNode(_frm, _BTC_PageClippingRectGroup, 99, _BTC_PageClippingRectGroup[5], "_BTC_pClipNodeGroup")
	
	--组队聊天裁剪区域
	--local _BTC_PageClippingRectCouple = {10, -60, BOARD_WIDTH - 16, hVar.SCREEN.h - 140, 0} -- {x, y, w, h, isShow}
	local _BTC_PageClippingRectCouple = {10, -66, BOARD_WIDTH - 16, BOARD_HEIGHT - 140, 0} -- {x, y, w, h, isShow}
	local _BTC_pClipNodeCouple = hApi.CreateClippingNode(_frm, _BTC_PageClippingRectCouple, 99, _BTC_PageClippingRectCouple[5], "_BTC_pClipNodeCouple")
	
	--[[
	--为防止走马灯出现clipbode混乱，这里再加一层
	_frm.childUI["CoverClipNode"] = hUI.image:new({ --作为按钮是为了挂载子控件
		parent = _parent,
		model = "panel/panel_part_00.png",
		--model = -1,
		x = 5 + (BOARD_WIDTH - 6) / 2,
		y = -29,
		z = 101,
		w = BOARD_WIDTH - 6,
		h = 54,
		z = 100,
	})
	--加一层背景图
	--九宫格
	--local s9 = hApi.CCScale9SpriteCreate("data/image/panel/MengBan32.png", 0, 0, BOARD_WIDTH - 6, 54, _frm.childUI["CoverClipNode"])
	--s9:setColor(ccc3(128, 128, 128))
	]]
	
	--关闭按钮
	local closeDx = -44---24
	local closeDy = -42---28
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		model = "misc/mask.png", --"BTN:PANEL_CLOSE",
		x = _frm.data.w + closeDx,
		y = closeDy,
		w = 84,
		h = 84,
		scaleT = 0.95,--0.95,
		code = function()
			--触发事件，关闭金币、积分界面
			hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
			
			--清除可能的发红包界面
			if hGlobal.UI.SendRedPacketFrm then
				hGlobal.UI.SendRedPacketFrm:del()
				hGlobal.UI.SendRedPacketFrm = nil
			end
			
			--清除可能的玩家操作界面
			if hGlobal.UI.GameCoinTipFrame then
				hGlobal.UI.GameCoinTipFrame:del()
				hGlobal.UI.GameCoinTipFrame = nil
			end
			
			--不显示聊天面板
			hGlobal.UI.ChatDialogueFrm:show(0)
			
			--横屏，暂时隐藏聊天按钮
			hApi.RecoverScreenRotation()
			
			--清空上次分页的全部信息
			_removeLeftFrmFunc()
			_removeRightFrmFunc()
			
			--清空切换分页之后取消的监听事件
			--移除移除事件监听：横竖屏切换
 			hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenAchievement_", nil)
			--移除事件监听：收到工会服务器socket连接结果回调
			hGlobal.event:listen("LocalEvent_Group_NetEvent", "__GroupServerConnectBack_", nil)
			--移除事件监听：收到工会服务器登陆结果回调
			hGlobal.event:listen("LocalEvent_Group_LogEvent", "__GroupServerLoginBack_", nil)
			--移除事件监听：收到聊天模块初始化事件
			hGlobal.event:listen("LocalEvent_Group_ChatInitEvent", "__GroupServerChatInitBack_", nil)
			--移除事件监听：收到聊天消息id事件
			hGlobal.event:listen("LocalEvent_Group_ChatIDListEvent", "__GroupServerChatIDListBack_", nil)
			--移除事件监听：收到聊天消息内容事件
			hGlobal.event:listen("LocalEvent_Group_ChatContentListEvent", "__GroupServerChatContentListBack_", nil)
			--移除事件监听：收到单条聊天消息事件
			hGlobal.event:listen("LocalEvent_Group_SingleChatMessageEvent", "__SingleChatMessageBack_", nil)
			--移除事件监听：收到更新聊天消息事件
			hGlobal.event:listen("LocalEvent_Group_UpdatChatMessageEvent", "__UpdateChatMessageBack_", nil)
			--移除事件监听：收到删除聊天消息事件
			hGlobal.event:listen("LocalEvent_Group_RemoveChatMessageEvent", "__RemoveChatMessageBack_", nil)
			--移除事件监听：收到被禁言的通知事件
			hGlobal.event:listen("LocalEvent_Group_ChatForbiddenEvent", "__ChatForbiddenBack_", nil)
			--移除事件监听：收到发起私聊请求的结果返回
			hGlobal.event:listen("LocalEvent_Group_PrivateInviteChatEvent", "__ChatPrivateInviteBack_", nil)
			--移除事件监听：收到工会操作结果返回
			hGlobal.event:listen("LocalEvent_Group_OperationRet", "__GroupOperationRetBack_", nil)
			--移除事件监听：收到加入军团邀请函结果返回
			hGlobal.event:listen("localEvent_GroupInviteJoinBack", "__GroupInviteRetBack_", nil)
			--移除监听：程序进入后台的回调
			hGlobal.event:listen("LocalEvent_AppEnterBackground", "__ChatMessageBack_", nil)
			--移除监听：游戏局结束事件
			hGlobal.event:listen("LocalEvent_GameOver", "__ChatGameEnd_", nil)
			--移除监听：游戏局结束事件（夺塔奇兵）
			hGlobal.event:listen("LocalEvent_GameOver_PVP", "__ChatGameEnd_", nil)
			--移除监听：游戏局结束事件（魔龙宝库）
			hGlobal.event:listen("LocalEvent_GameOver_PVP_Endless", "__ChatGameEnd_", nil)
			--移除监听：游戏局结束事件（铜雀台）
			hGlobal.event:listen("LocalEvent_GameOver_PVP_Endless_Singlebattle", "__ChatGameEnd_", nil)
			--移除监听：游戏局结束事件（新手地图）
			hGlobal.event:listen("LocalEvent_GameOver_NewGuideMap", "__ChatGameEnd_", nil)
			--移除监听：PVP等待其他玩家事件
			hGlobal.event:listen("LocalEvent_Pvp_Delay_Player", "__ChatPVPWaitPlayer_", nil)
			--移除监听：PVP本地长时间未响应事件
			hGlobal.event:listen("LocalEvent_Pvp_LocalNoHeart", "__ChatPVPLocalNoHeart_", nil)
			--移除监听：安卓本地掉线事件
			hGlobal.event:listen("LocalEvent_showAndroidNetAlreadyFrm", "__ChatAndroidDisconnect_", nil)
			--移除事件监听：切换剧情地图场景事件
			hGlobal.event:listen("LocalEvent_Battle_SwitchGame", "__BattleSwitchGameBack_chat2", nil)
			--移除事件监听：切换pvp场景事件
			hGlobal.event:listen("LocalEvent_Pvp_SwitchGame", "__PVPSwitchGameBack_chat2", nil)
			--移除事件监听：切换pvp匹配房场景事件
			hGlobal.event:listen("LocalEvent_Pvp_Match_SwitchGame", "__MatchSwitchGameBack_chat2", nil)
			--移除监听：收到领取支付（土豪）红包结果结果
			hGlobal.event:listen("LocalEvent_OnReceivePayRedPacketResult", "ReceivePayRedPacketResult", nil)
			--移除监听：收到查看支付（土豪）红包的领取详情结果
			hGlobal.event:listen("LocalEvent_ViewDetailPayRedPacketResult", "ViewDetailPayRedPacketResult", nil)
			
			--邀请
			--移除事件监听：收到pvp连接结果回调
			hGlobal.event:listen("LocalEvent_Pvp_NetEvent", "__ConnectBack_page_chat", nil)
			--移除事件监听：收到登入结果回调
			hGlobal.event:listen("LocalEvent_Pvp_PlayerLoginEvent", "__LoginBack_page_chat", nil)
			--移除事件监听：收到初始化玩家基础信息结果回调
			hGlobal.event:listen("LocalEvent_Pvp_UserBaseInfoQuerySuccess", "__BaseInfoQueryBack_page_chat", nil)
			--移除事件监听：pvp错误信息提示
			hGlobal.event:listen("LocalEvent_Pvp_NetLogicError", "__NetLogicError_page_chat", nil)
			--移除事件监听：进入pvp房间失败事件
			hGlobal.event:listen("LocalEvent_Pvp_RoomEnter_Fail", "__EnterRoomFail_page_chat", nil)
			--移除事件监听：聊天直接进入pvp房间成功事件
			hGlobal.event:listen("LocalEvent_Pvp_RoomDirectEnter_Success", "__EnterRoomsuccess_page_chat", nil)
			
			--移除监听：收到增加单个私聊好友
			hGlobal.event:listen("LocalEvent_Group_PrivateFriendAddEvent", "__ChatPrivateFriendAddBack_", nil)
			--移除监听：收到删除单个私聊好友
			hGlobal.event:listen("LocalEvent_Group_PrivateFriendRemoveEvent", "__ChatPrivateFriendRemoveBack_", nil)
			
			--移除timer
			hApi.clearTimer("__ONCE_CHAT_TIMEOUNT_TIMER__")
			hApi.clearTimer("__CHATFRAME_WORLD_TIMER_UPDATE__")
			hApi.clearTimer("__CHATFRAME_INVITE_TIMER_UPDATE__")
			hApi.clearTimer("__CHATFRAME_PRIVATE_TIMER_UPDATE__")
			hApi.clearTimer("__CHATFRAME_REDPACKET_TIMER_UPDATE__")
			hApi.clearTimer("__CHATAUTOLINK_TIMER_UPDATE__")
			hApi.clearTimer("__CHATPAINT_MESSAGE_ASYNC__")
			hApi.clearTimer("__VIEWDETAIL_PAY_REDPACKET_LIST__")
			hApi.clearTimer("__PAY_REDPACKET_CHANGE_ASYNC_TIMER__")
			hApi.clearTimer("__ONCE_CHAT_PAYREDPACKET_AMIN_TIMER__")
			
			--隐藏所有的clipNode
			hApi.EnableClipByName(_frm, "_BTC_pClipNodeWorld", 0)
			hApi.EnableClipByName(_frm, "_BTC_pClipNodeInvite", 0)
			hApi.EnableClipByName(_frm, "_BTC_pClipNodePrivate", 0)
			hApi.EnableClipByName(_frm, "_BTC_pClipNodeGroup", 0)
			hApi.EnableClipByName(_frm, "_BTC_pClipNodeCouple", 0)
			
			--触发事件：刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
			hGlobal.event:event("LocalEvent_RefreshMedalStateUI")
			
			--释放png, plist的纹理缓存（这里不清理也可以）
			--hApi.ReleasePngTextureCache()
			
			--触发关闭后事件
			if (type(current_tCallback) == "table") then
				if (type(current_tCallback.OnCloseFunc) == "function") then
					current_tCallback.OnCloseFunc()
				end
			end
			--current_tCallback = nil --不删除，因为后续还有调用的地方
			current_groupId_gm = 0 --GM请求查看指定聊天记录的军团id
			current_IsQueryChampion = false --是否查询过称号（因为称号有有效期，每次打开聊天，在首次输入文字后查询一次称号）
			
			--geyachao: 安卓手机存在输入时删除本界面，导致crash的问题
			--[[
			--删除本聊天界面
			if hGlobal.UI.ChatDialogueFrm then
				hGlobal.UI.ChatDialogueFrm:del()
				hGlobal.UI.ChatDialogueFrm = nil
			end
			
			--清除输入框指针
			current_enterNameEditBox = nil
			]]
			
			--回收lua内存
			--collectgarbage()
		end,
	})
	_frm.childUI["closeBtn"].handle.s:setOpacity(0) --只响应事件，不显示
	_frm.childUI["closeBtn"].childUI["image"] = hUI.image:new({
		parent = _frm.childUI["closeBtn"].handle._n,
		model = "misc/chest/btn_close_1.png", --"BTN:PANEL_CLOSE",
		x = 0,
		y = 0,
		scale = 0.7,
	})
	
	--每个分页按钮
	--英雄令、(图鉴 "ICON:Imperial_Academy" hVar.tab_string["__TEXT_TuJian"])、神器、塔、战术卡
	--local tPageIcons = {"ICON:ReviveHero", "MODEL_EFFECT:JIANTA1_BASE", "icon/item/card_lv3.png", "UI:shenqi",}
	--local tPageIconRot = {false, false, false, true,}
	--local tTexts = {"世界", "邀请", "私聊", "军团", "组队",} --language
	-------------------------------------------------------
	--修改聊天tab按钮顺序
	--local tTexts = {hVar.tab_string["__TEXT_MAINUI_BTN_WORLD"], hVar.tab_string["__TEXT_MAINUI_BTN_INVITE"], hVar.tab_string["__TEXT_MAINUI_BTN_PRIVATECHAT"], hVar.tab_string["__TEXT_MAINUI_BTN_GROUP"],} --language
	local tTexts = {hVar.tab_string["__TEXT_MAINUI_BTN_WORLD"], hVar.tab_string["__TEXT_MAINUI_BTN_PRIVATECHAT"], hVar.tab_string["__TEXT_MAINUI_BTN_INVITE"], hVar.tab_string["__TEXT_MAINUI_BTN_GROUP"],} --language
	--local tTexts = {hVar.tab_string["__TEXT_MAINUI_BTN_WORLD"], hVar.tab_string["__TEXT_MAINUI_BTN_INVITE"], hVar.tab_string["__TEXT_MAINUI_BTN_PRIVATECHAT"], hVar.tab_string["__TEXT_MAINUI_BTN_GROUP"], hVar.tab_string["__TEXT_MAINUI_BTN_COUPLE"],} --language
	--组队分页
	local sessionId = 0
	local world = hGlobal.WORLD.LastWorldMap
	if world then
		--PVP单人地图也不需要显示组队分页
		if (world.data.tdMapInfo.isNoWaitFrame ~= true) then --不是不等待同步帧模式
			sessionId = world.data.session_dbId
		end
	end
	if (sessionId > 0) then
		tTexts[5] = hVar.tab_string["__TEXT_MAINUI_BTN_COUPLE"]
	end
	
	--参数配置
	--iPad
	local nPageX = -3	--15 --按钮x(距离左侧)
	local nPageY = -38	---30 --按钮y(距离上侧)
	local nPageW = 140	--128 --按钮宽度
	local nPageH = 56	--66 --按钮高度
	local nPageWL = 140	--128 --长按钮宽度
	local nPageHL = 56	--66 --长按钮高度
	local nPageOffsetX = -24--0 --每个按钮间间距微调值
	local nIconX = 0 --图标x
	local nIconY = 0 --图标y
	local nIconW = 56 --图标宽
	local nIconH = 56 --图标高
	local nIconXL = 0 --长图标x
	local nIconYL = 30 --长图标y
	local nIconWL = 74 --长图标宽
	local nIconHL = 74 --长图标高
	
	--依次绘制
	for i = 1, #tTexts, 1 do
		--分页按钮
		_frm.childUI["PageBtn" .. i] = hUI.button:new({
			parent = _parent,
			--model = "misc/mask.png",
			model = -1,
			x = nPageX + nPageW / 2 + (i - 1) * (nPageW + nPageOffsetX),
			y = nPageY,
			z = 102,
			w = nPageW,
			h = nPageHL,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.0,
			scale = 0.8,
			code = function(self, screenX, screenY, isInside)
				OnClickPageBtn(i)
			end,
		})
		--_frm.childUI["PageBtn" .. i].handle.s:setOpacity(0) --分页按钮的控制部分，用于处理响应，不显示
		-------------------------------------------------------
		--隐藏暂时没有开启的聊天按钮
		if i > 2 then
			_frm.childUI["PageBtn" .. i]:setstate(-1) 
		end

		--分页按钮的方块图标
		_frm.childUI["PageBtn" .. i].childUI["PageImage"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = "misc/chest/btn_title_n.png", --"UI:ChestBag_2", --"UI:Tactic_Button",
			x = 0,
			y = 0,
			w = nPageW,
			h = nPageH,
			scale = 0.8,
		})
		
		--分页按钮的文字
		_frm.childUI["PageBtn" .. i].childUI["Text"] = hUI.label:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			x = 0,
			y = 1,--0,---5,
			size = 26,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 300,
			text = tTexts[i],
		})
		
		--分页按钮的提示有新消息的叹号
		_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"] = hUI.image:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			model = "UI:TaskTanHao",
			x = nPageW / 2 - 24 - 10,--nPageW / 2 - 24,
			y = nPageH / 2 - 30,
			w = 32,
			h = 32,
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
		_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"].handle.s:runAction(CCRepeatForever:create(sequence))
		_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"].handle._n:setVisible(false) --默认一开始不显示提示该分页有新消息的叹号
	end
	
	--分页内容的的父控件
	_frm.childUI["PageNode"] = hUI.button:new({
		parent = _frm,
		--model = tTexts[i],
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
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.ChatDialogueFrm
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
		
		--军团分页，需要加入军团后才能进去
		if (pageIndex == 4) then
			--没有加入军团，或者不是查询指定的军团id
			if (current_msgGroupId == 0) and (current_groupId_gm == 0) then
				--冒字
				--local strText = "加入军团后才能进入此分页！" --language
				local strText = hVar.tab_string["ios_err_network_cannot_group"] --language
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
		end
		
		--组队分页，需要在组队副本中才能进去
		if (pageIndex == 5) then
			local sessionId = 0
			local world = hGlobal.WORLD.LastWorldMap
			if world then
				--PVP单人地图也不需要显示组队分页
				if (world.data.tdMapInfo.isNoWaitFrame ~= true) then --不是不等待同步帧模式
					sessionId = world.data.session_dbId
				end
			end
			--不在组队副本中
			if (sessionId <= 0) then
				--冒字
				--local strText = "您不在组队副本中！" --language
				local strText = hVar.tab_string["ios_err_network_cannot_couple"] --language
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
		end
		--[[
		--启用全部的按钮
		for i = 1, #tTexts, 1 do
			_frm.childUI["PageBtn" .. i].childUI["Text"].handle.s:setVisible(true) --显示文字
		end
		]]
		--所有的按钮重算位置，并做动画
		for i = 1, #tTexts, 1 do
			local toX = 0
			local toY = nPageY
			local toW = nPageW
			local toH = nPageH
			local toModel = "misc/chest/btn_title_n.png"
			local cColorText = ccc3(212, 212, 212)
			
			if (i < pageIndex) then --左侧的
				toX = nPageX + nPageW / 2 + (i - 1) * (nPageW + nPageOffsetX)
			elseif (i == pageIndex) then --自身
				toX = nPageX + (pageIndex - 1) * (nPageW + nPageOffsetX) + nPageWL / 2
				toW = nPageWL
				toH = nPageHL
				toModel = "misc/chest/btn_title_h.png"
				cColorText = ccc3(255, 255, 0)
			else --右侧的
				toX = nPageX + (pageIndex - 1) * (nPageW + nPageOffsetX) + nPageW / 2 + nPageWL + nPageOffsetX + (i - pageIndex - 1) * (nPageW + nPageOffsetX)
			end
			
			_frm.childUI["PageBtn" .. i]:setXY(toX, toY)
			_frm.childUI["PageBtn" .. i].childUI["PageImage"]:setmodel(toModel, nil, nil, toW, toH)
			_frm.childUI["PageBtn" .. i].childUI["Text"].handle.s:setColor(cColorText)
		end
		
		--隐藏本分页下的新消息提示叹号
		--_frm.childUI["PageBtn" .. pageIndex].childUI["NoteJianTou"].handle._n:setVisible(false)
		
		--先清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--清空切换分页之后取消的监听事件
		--移除移除事件监听：横竖屏切换
 		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenAchievement_", nil)
		--移除事件监听：收到工会服务器socket连接结果回调
		hGlobal.event:listen("LocalEvent_Group_NetEvent", "__GroupServerConnectBack_", nil)
		--移除事件监听：收到工会服务器登陆结果回调
		hGlobal.event:listen("LocalEvent_Group_LogEvent", "__GroupServerLoginBack_", nil)
		--移除事件监听：收到聊天模块初始化事件
		hGlobal.event:listen("LocalEvent_Group_ChatInitEvent", "__GroupServerChatInitBack_", nil)
		--移除事件监听：收到聊天消息id事件
		hGlobal.event:listen("LocalEvent_Group_ChatIDListEvent", "__GroupServerChatIDListBack_", nil)
		--移除事件监听：收到聊天消息内容事件
		hGlobal.event:listen("LocalEvent_Group_ChatContentListEvent", "__GroupServerChatContentListBack_", nil)
		--移除事件监听：收到单条聊天消息事件
		hGlobal.event:listen("LocalEvent_Group_SingleChatMessageEvent", "__SingleChatMessageBack_", nil)
		--移除事件监听：收到更新聊天消息事件
		hGlobal.event:listen("LocalEvent_Group_UpdatChatMessageEvent", "__UpdateChatMessageBack_", nil)
		--移除事件监听：收到删除聊天消息事件
		hGlobal.event:listen("LocalEvent_Group_RemoveChatMessageEvent", "__RemoveChatMessageBack_", nil)
		--移除事件监听：收到被禁言的通知事件
		hGlobal.event:listen("LocalEvent_Group_ChatForbiddenEvent", "__ChatForbiddenBack_", nil)
		--移除事件监听：收到发起私聊请求的结果返回
		hGlobal.event:listen("LocalEvent_Group_PrivateInviteChatEvent", "__ChatPrivateInviteBack_", nil)
		--移除事件监听：收到工会操作结果返回
		hGlobal.event:listen("LocalEvent_Group_OperationRet", "__GroupOperationRetBack_", nil)
		--移除事件监听：收到加入军团邀请函结果返回
		hGlobal.event:listen("localEvent_GroupInviteJoinBack", "__GroupInviteRetBack_", nil)
		--移除监听：程序进入后台的回调
		hGlobal.event:listen("LocalEvent_AppEnterBackground", "__ChatMessageBack_", nil)
		--移除监听：游戏局结束事件
		hGlobal.event:listen("LocalEvent_GameOver", "__ChatGameEnd_", nil)
		--移除监听：游戏局结束事件（夺塔奇兵）
		hGlobal.event:listen("LocalEvent_GameOver_PVP", "__ChatGameEnd_", nil)
		--移除监听：游戏局结束事件（魔龙宝库）
		hGlobal.event:listen("LocalEvent_GameOver_PVP_Endless", "__ChatGameEnd_", nil)
		--移除监听：游戏局结束事件（铜雀台）
		hGlobal.event:listen("LocalEvent_GameOver_PVP_Endless_Singlebattle", "__ChatGameEnd_", nil)
		--移除监听：游戏局结束事件（新手地图）
		hGlobal.event:listen("LocalEvent_GameOver_NewGuideMap", "__ChatGameEnd_", nil)
		--移除监听：PVP等待其他玩家事件
		hGlobal.event:listen("LocalEvent_Pvp_Delay_Player", "__ChatPVPWaitPlayer_", nil)
		--移除监听：PVP本地长时间未响应事件
		hGlobal.event:listen("LocalEvent_Pvp_LocalNoHeart", "__ChatPVPLocalNoHeart_", nil)
		--移除监听：安卓本地掉线事件
		hGlobal.event:listen("LocalEvent_showAndroidNetAlreadyFrm", "__ChatAndroidDisconnect_", nil)
		--移除事件监听：切换剧情地图场景事件
		hGlobal.event:listen("LocalEvent_Battle_SwitchGame", "__BattleSwitchGameBack_chat2", nil)
		--移除事件监听：切换pvp场景事件
		hGlobal.event:listen("LocalEvent_Pvp_SwitchGame", "__PVPSwitchGameBack_chat2", nil)
		--移除事件监听：切换pvp匹配房场景事件
		hGlobal.event:listen("LocalEvent_Pvp_Match_SwitchGame", "__MatchSwitchGameBack_chat2", nil)
		--移除监听：收到领取支付（土豪）红包结果结果
		hGlobal.event:listen("LocalEvent_OnReceivePayRedPacketResult", "ReceivePayRedPacketResult", nil)
		--移除监听：收到查看支付（土豪）红包的领取详情结果
		hGlobal.event:listen("LocalEvent_ViewDetailPayRedPacketResult", "ViewDetailPayRedPacketResult", nil)
		
		--移除监听：收到增加单个私聊好友
		hGlobal.event:listen("LocalEvent_Group_PrivateFriendAddEvent", "__ChatPrivateFriendAddBack_", nil)
		--移除监听：收到删除单个私聊好友
		hGlobal.event:listen("LocalEvent_Group_PrivateFriendRemoveEvent", "__ChatPrivateFriendRemoveBack_", nil)

		--移除timer
		hApi.clearTimer("__ONCE_CHAT_TIMEOUNT_TIMER__")
		hApi.clearTimer("__CHATFRAME_WORLD_TIMER_UPDATE__")
		hApi.clearTimer("__CHATFRAME_INVITE_TIMER_UPDATE__")
		hApi.clearTimer("__CHATFRAME_PRIVATE_TIMER_UPDATE__")
		hApi.clearTimer("__CHATFRAME_REDPACKET_TIMER_UPDATE__")
		hApi.clearTimer("__CHATAUTOLINK_TIMER_UPDATE__")
		hApi.clearTimer("__CHATPAINT_MESSAGE_ASYNC__")
		hApi.clearTimer("__VIEWDETAIL_PAY_REDPACKET_LIST__")
		hApi.clearTimer("__PAY_REDPACKET_CHANGE_ASYNC_TIMER__")
		hApi.clearTimer("__ONCE_CHAT_PAYREDPACKET_AMIN_TIMER__")
		
		--隐藏所有的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNodeWorld", 0)
		hApi.EnableClipByName(_frm, "_BTC_pClipNodeInvite", 0)
		hApi.EnableClipByName(_frm, "_BTC_pClipNodePrivate", 0)
		hApi.EnableClipByName(_frm, "_BTC_pClipNodeGroup", 0)
		hApi.EnableClipByName(_frm, "_BTC_pClipNodeCouple", 0)
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：世界聊天
			--创建世界聊天分页
			OnCreateWorldChatInfoFrame(pageIndex)
		elseif (pageIndex == 2) then --邀请 -> 私聊
			--OnCreateInviteChatInfoFrame(pageIndex)
			-------------------------------------------------------
			--修改聊天tab按钮顺序
			OnCreatePrivateChatInfoFrame(pageIndex)
		elseif (pageIndex == 3) then --私聊 -> 邀请
			--OnCreatePrivateChatInfoFrame(pageIndex)
			--修改聊天tab按钮顺序
			OnCreateInviteChatInfoFrame(pageIndex)
		elseif (pageIndex == 4) then --军团
			OnCreateGroupChatInfoFrame(pageIndex)
		elseif (pageIndex == 5) then --组队
			OnCreateCoupleChatInfoFrame(pageIndex)
		end
		
		--标记当前选择的分页和页内的第几个
		CurrentSelectRecord.pageIdx = pageIndex
		CurrentSelectRecord.contentIdx = 1 --默认选中第一个
	end
	
	--函数：创建世界聊天界面（第1个分页）
	OnCreateWorldChatInfoFrame = function(pageIdx)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--允许本分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNodeWorld", 1)
		--hApi.EnableClipByName(_frm, "_BTC_pClipNodePrivate", 1)
		
		--标记本分页的聊天频道(世界频道)
		current_chat_type = hVar.CHAT_TYPE.WORLD
		
		--初始化数据
		current_DLCMap_max_num = 0
		current_async_paint_list = {} --清空异步缓存待绘制内容
		current_DLCMap_friend_max_num = 0
		current_DLCMap_roomid = 0 --当前请求组队副本的房间消息id
		
		--统一处理聊天页的位置和大小
		local pg_offX = CHAT_INFO_FRM_POS_X 							--362 						
		local pg_offY = CHAT_INFO_FRM_POS_Y 							---hVar.SCREEN.h / 2 + 10
		local pg_width = BOARD_WIDTH			--BOARD_WIDTH - 10		--
		local pg_height = CHAT_INFO_FRM_POS_HEIGHT						--hVar.SCREEN.h - 136
		
		--[[
		--左侧DLC地图包列表提示上翻页的图片
		_frmNode.childUI["DLCMapInfoPageUp"] = hUI.image:new({
			parent = _BTC_pClipNodeWorld,
			model = "misc/chest/tutorial_arrow_right.png", --"UI:PageBtn",
			x = pg_offX,
			y = pg_offY + 238,
			scale = 0.5,
			z = 500, --最前端显示
		})
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setRotation(-90)
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --默认不显示左上翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["DLCMapInfoPageUp"].handle._n:runAction(forever)
		
		--左侧DLC地图包列表提示下翻页的图片
		_frmNode.childUI["DLCMapInfoPageDown"] = hUI.image:new({
			parent = _BTC_pClipNodeWorld,
			model = "misc/chest/tutorial_arrow_right.png", --"UI:PageBtn",
			x = pg_offX,
			y = pg_offY - 238,
			scale = 0.5,
			z = 500, --最前端显示
		})
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setRotation(90)
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["DLCMapInfoPageDown"].handle._n:runAction(forever)
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --默认不显示下分翻页提示
		]]
		
		--[[
		--左侧向上翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["DLCMapInfoPageUp_Btn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = pg_offX,
			y = pg_offY + 182,
			w = 360,
			h = 60,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--超过一页的数量才滑屏
				if (current_DLCMap_max_num > (WEAPON_X_NUM * WEAPON_Y_NUM)) then
					--print("向下滚屏", screenY)
					--向下滚屏
					b_need_auto_fixing_dlcmapinfo = true
					friction_dlcmapinfo = 0
					friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
					draggle_speed_y_dlcmapinfo = -MAX_SPEED / 2.0 --负速度
				end
			end,
		})
		_frmNode.childUI["DLCMapInfoPageUp_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageUp_Btn"
		]]
		
		--[[
		--左侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["DLCMapInfoPageDown_Btn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = pg_offX,
			y = pg_offY - 182,
			w = 360,
			h = 60,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--超过一页的数量才滑屏
				if (current_DLCMap_max_num > (WEAPON_X_NUM * WEAPON_Y_NUM)) then
					--print("向上滚屏", screenY)
					--向上滚屏
					b_need_auto_fixing_dlcmapinfo = true
					friction_dlcmapinfo = 0
					friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
					draggle_speed_y_dlcmapinfo = MAX_SPEED / 2.0 --正速度
				end
			end,
		})
		_frmNode.childUI["DLCMapInfoPageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageDown_Btn"
		]]
		
		--获奖记录用于检测滑动事件的控件(世界聊天)
		_frmNode.childUI["DragPanelWorld"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = pg_offX,
			y = pg_offY,
			w = pg_width,
			h = pg_height,
			failcall = 1,
			
			--按下事件(世界聊天)
			codeOnTouch = function(self, touchX, touchY, sus)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
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
				friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
				
				--如果DLC地图面板数量未铺满一页，那么不需要滑动
				--if (current_DLCMap_max_num <= (WEAPON_X_NUM * WEAPON_Y_NUM)) then
				--	click_scroll_dlcmapinfo = false --不需要滑动DLC地图面板
				--end
				
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
				
				--模拟按下事件
				--检测是否点到了某些控件里(世界聊天)
				for i = 1, current_DLCMap_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					if ctrli then
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						
						--[[
						--检测是否点到了领奖按钮
						local ctrlI = ctrli.childUI["rewardBtn"]
						if ctrlI then
							if (ctrlI.data.state == 1) then --按钮可点状态
								local bcx = ctrlI.data.x --中心点x坐标
								local bcy = ctrlI.data.y --中心点y坐标
								local bcw, bch = ctrlI.data.w, ctrlI.data.h
								local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
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
									ctrlI.handle._n:stopAllActions()
									ctrlI.handle._n:runAction(sequence)
								end
							end
						end
						]]
					end
				end
				
				--在滑动过程中才会处理滑动
				if click_scroll_dlcmapinfo then
					--显示滚动条
					--_frmNode.childUI["ScrollBar"]:setstate(1)
					onShowScrollBarHint()
					
					--更新滚动条的进度(世界聊天)
					local progressMax = delta1_ly - deltNa_ry
					local progressNow = delta1_ly
					local height = _frmNode.childUI["ScrollBar"].data.w - _frmNode.childUI["ScrollBarProgress"].data.h --h
					local scrollX = _frmNode.childUI["ScrollBarProgress"].data.x
					local scrollY = _frmNode.childUI["ScrollBar"].data.y + (1 - progressNow / progressMax) * height - height / 2
					_frmNode.childUI["ScrollBarProgress"]:setXY(scrollX, scrollY)
				end
				
				--是否选中某个聊天消息的红包区域
				local selectTipIdxRedpacket = 0
				for i = 1, current_DLCMap_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					if ctrli then
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						local cw, ch = ctrli.data.w, ctrli.data.h
						local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
						local rx, ry = lx + cw, ly + ch --最右下角坐标
						--print(i, cx, cy)
						
						--检测是否点到了红包
						local ctrlI = ctrli.childUI["redPacket"]
						if ctrlI then
							local bcx = ctrlI.data.x --中心点x坐标
							local bcy = ctrlI.data.y --中心点y坐标
							local bcw, bch = ctrlI.data.w + 20, ctrlI.data.h + 20 --点击区域大一些
							local blx, bly = cx + bcx - bcw / 2, cy  + bcy - bch / 2 --最左上侧坐标
							local brx, bry = blx + bcw, bly + bch --最右下角坐标
							--print(i, bcx, bcy, bcw, bch)
							if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
								selectTipIdxRedpacket = i
								--print("点击按钮" .. selectTipIdxRedpacket)
							end
						end
					end
				end
				if (click_scroll_dlcmapinfo) and (math.abs(touchY - click_pos_y_dlcmapinfo) > 42) then
					selectTipIdxRedpacket = 0
				end
				--点击到某个档位的奖励控件之内(世界聊天)
				if (selectTipIdxRedpacket > 0) then
					--弹出操作界面
					--print(selectTipIdxRedpacket)
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. selectTipIdxRedpacket]
					local ctrlI = ctrli.childUI["redPacketIcon"]
					if ctrlI then
						--缩小再放大
						local act1 = CCEaseSineIn:create(CCScaleTo:create(0.1, 0.95))
						local act2 = CCEaseSineOut:create(CCScaleTo:create(0.1, 1.0))
						local a = CCArray:create()
						a:addObject(act1)
						a:addObject(act2)
						local sequence = CCSequence:create(a)
						ctrlI.handle._n:stopAllActions()
						ctrlI.handle._n:runAction(sequence)
					end
				end
			end,
			
			--滑动事件(世界聊天)
			codeOnDrag = function(self, touchX, touchY, sus)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--print("codeOnDrag", touchX, touchY, sus, draggle_speed_y_dlcmapinfo)
				
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
							if ctrli.handle._n then
								ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
								ctrli.data.x = ctrli.data.x
								ctrli.data.y = ctrli.data.y + deltaY
							end
						end
					end
					
					--更新滚动条的进度(世界聊天)
					local progressMax = delta1_ly - deltNa_ry
					local progressNow = delta1_ly
					local height = _frmNode.childUI["ScrollBar"].data.w - _frmNode.childUI["ScrollBarProgress"].data.h --h
					local scrollX = _frmNode.childUI["ScrollBarProgress"].data.x
					local scrollY = _frmNode.childUI["ScrollBar"].data.y + (1 - progressNow / progressMax) * height - height / 2
					_frmNode.childUI["ScrollBarProgress"]:setXY(scrollX, scrollY)
				end
				
				--存储本次的位置
				last_click_pos_y_dlcmapinfo = touchX
				last_click_pos_y_dlcmapinfo = touchY
			end,
			
			--抬起事件(世界聊天)
			code = function(self, touchX, touchY, sus)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_dlcmapinfo then
					--if (touchX ~= click_pos_x_dlcmapinfo) or (touchY ~= click_pos_y_dlcmapinfo) then --不是点击事件
						b_need_auto_fixing_dlcmapinfo = true
						friction_dlcmapinfo = 0
						friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
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
							friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
							draggle_speed_y_dlcmapinfo = MAX_SPEED / 1.0 --正速度 --速度一般大
							
							return
						end
					end
				end
				
				--是否选中某个聊天消息的头像区域(世界聊天)
				local selectTipIdx = 0
				for i = 1, current_DLCMap_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					if ctrli then
						if ctrli.handle._n then
							local cx = ctrli.data.x --中心点x坐标
							local cy = ctrli.data.y --中心点y坐标
							local cw, ch = ctrli.data.w, ctrli.data.h
							local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
							local rx, ry = lx + cw, ly + ch --最右下角坐标
							--print(i, cx, cy)
							
							--检测是否点到了头像
							local ctrlI = ctrli.childUI["roleIcon"]
							if ctrlI then
								local bcx = ctrlI.data.x --中心点x坐标
								local bcy = ctrlI.data.y --中心点y坐标
								local bcw, bch = ctrlI.data.w + 20, ctrlI.data.h + 20 --点击区域大一些
								local blx, bly = cx + bcx - bcw / 2, cy  + bcy - bch / 2 --最左上侧坐标
								local brx, bry = blx + bcw, bly + bch --最右下角坐标
								--print(i, bcx, bcy, bcw, bch)
								if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
									selectTipIdx = i
									--print("点击按钮" .. selectTipIdx)
								end
							end
						end
					end
				end
				
				if (click_scroll_dlcmapinfo) and (math.abs(touchY - click_pos_y_dlcmapinfo) > 42) then
					selectTipIdx = 0
				end
				
				--点击到某个档位的奖励控件之内(世界聊天)
				if (selectTipIdx > 0) then
					--弹出操作界面
					--print(selectTipIdx)
					local ctrlI = _frmNode.childUI["DLCMapInfoNode" .. selectTipIdx]
					if ctrlI then
						
						if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
							--创建消息互动操作界面tip
							OnCreateChatDialogueTip(selectTipIdx)
						else
							--此消息不是系统、不是我发的，可以有个交互操作
							local uid = ctrlI.data.uid
							if (uid ~= 0) and (uid ~= xlPlayer_GetUID()) then
								--创建消息互动操作界面tip
								OnCreateChatDialogueTip(selectTipIdx)
							end
						end
					end
				end
				
				--是否选中某个聊天消息的红包区域
				local selectTipIdxRedpacket = 0
				for i = 1, current_DLCMap_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					if ctrli then
						if ctrli.handle._n then
							local cx = ctrli.data.x --中心点x坐标
							local cy = ctrli.data.y --中心点y坐标
							local cw, ch = ctrli.data.w, ctrli.data.h
							local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
							local rx, ry = lx + cw, ly + ch --最右下角坐标
							--print(i, cx, cy)
							
							--检测是否点到了红包
							local ctrlI = ctrli.childUI["redPacket"]
							if ctrlI then
								local bcx = ctrlI.data.x --中心点x坐标
								local bcy = ctrlI.data.y --中心点y坐标
								local bcw, bch = ctrlI.data.w + 20, ctrlI.data.h + 20 --点击区域大一些
								local blx, bly = cx + bcx - bcw / 2, cy  + bcy - bch / 2 --最左上侧坐标
								local brx, bry = blx + bcw, bly + bch --最右下角坐标
								--print(i, bcx, bcy, bcw, bch)
								if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
									selectTipIdxRedpacket = i
									--print("点击按钮" .. selectTipIdxRedpacket)
								end
							end
						end
					end
				end
				if (click_scroll_dlcmapinfo) and (math.abs(touchY - click_pos_y_dlcmapinfo) > 42) then
					selectTipIdxRedpacket = 0
				end
				--点击到某个档位的奖励控件之内(世界消息红包)
				if (selectTipIdxRedpacket > 0) then
					--弹出操作界面
					--print(selectTipIdxRedpacket)
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. selectTipIdxRedpacket]
					local ctrlI = ctrli.childUI["redPacket"]
					if ctrlI then
						--print("点击红包")
						--点击领取红包按钮
						OnClickWorldRedPacketBtn(selectTipIdxRedpacket)
					end
				end
				
				--标记不用滑动
				click_scroll_dlcmapinfo = false
			end,
		})
		_frmNode.childUI["DragPanelWorld"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DragPanelWorld"
		
		--滑动条(世界聊天)
		_frmNode.childUI["ScrollBar"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/rank_line.png", --"UI:vipline", --"misc/chest/herodetailattr.png",
			x = pg_offX + pg_width / 2 - 8.5,
			y = pg_offY + 6,
			h = 4,
			w = pg_height - 20,
		})
		_frmNode.childUI["ScrollBar"].handle._n:setRotation(90)
		_frmNode.childUI["ScrollBar"].handle.s:setOpacity(0)
		_frmNode.childUI["ScrollBar"]:setstate(-1) --默认隐藏
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ScrollBar"
		--滚动进度
		_frmNode.childUI["ScrollBarProgress"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/scrollBtn.png",	--"UI:scrollBtn",
			x = pg_offX + pg_width / 2 - 8.5,
			y = pg_offY - 10, --pg_offY,
			w = 10,
			h = 22,
		})
		_frmNode.childUI["ScrollBarProgress"].handle.s:setOpacity(0)
		_frmNode.childUI["ScrollBarProgress"]:setstate(-1) --默认隐藏
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ScrollBarProgress"
		
		--物品背景图
		--九宫格
		--local s91 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bottom9g.png", 0, 0, pg_width-2, pg_height, _frmNode.childUI["DragPanelWorld"])
		--s9:setColor(ccc3(255, 255, 255))
		--s9:setOpacity(128)
		--local s92 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bottom9s.png", 0, 0, pg_width-2, pg_height, _frmNode.childUI["DragPanelWorld"])
		local s91 = hApi.CCScale9SpriteCreate("data/image/misc/treasure/medal_content.png", 0, 6, pg_width - 20, pg_height - 20, _frmNode.childUI["DragPanelWorld"])
		
		--删除之前可能的输入框
		if current_enterNameEditBox then
			_frmNode.handle._n:removeChild(current_enterNameEditBox, true)
			current_enterNameEditBox = nil
		end
		
		--绘制输入框
		--输入框
		local enterNameEditBox = nil
		local rgName = "" --输入的内容
		local editNameBoxTextEventHandle = function(strEventName, pSender)
			--local edit = tolua.cast(pSender, "CCEditBox") 
			--防止输入框被删除，触发回调安卓闪退
			if (current_enterNameEditBox ~= nil) then 
				if (strEventName == "began") then
					--
				elseif (strEventName == "changed") then --改变事件
					--
				elseif (strEventName == "ended") then
					rgName = enterNameEditBox:getText()
					
					--首次输入完文字后，查询称号
					if (not current_IsQueryChampion) then --是否查询过称号（因为称号有有效期，每次打开聊天，在首次输入文字后查询一次称号）
						--标记本次打开聊天界面已查询过称号
						current_IsQueryChampion = true
						
						--发起查询玩家称号
						SendCmdFunc["require_query_champion"]()
					end
				elseif (strEventName == "return") then
					--
				end
			end
			
			--print("editNameBoxTextEventHandle", strEventName, rgName)
			--xlLG("editbox", tostring(strEventName) .. ", rgName=" .. tostring(rgName) .. "\n")
		end
		
		--为了让输入文字比输入框稍微小些，这里输入框背景单独创建
		--输入框背景图
		--hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_grayyellow_light.png", -68, -pg_offY-hVar.SCREEN.h + 64 - 18, pg_width - 130, 64, _frmNode.childUI["DragPanelWorld"])
		--hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_grayyellow_light.png", -68, -pg_offY-CHAT_BOARD_HEIGHT + 54 - 18, pg_width - 130, 64, _frmNode.childUI["DragPanelWorld"])
		hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_grayyellow_light.png", -73, -pg_offY-CHAT_BOARD_HEIGHT + 54 - 12, pg_width - 160, 64, _frmNode.childUI["DragPanelWorld"])
		local SMALL_LENGTH = 8
		enterNameEditBox = CCEditBox:create(CCSizeMake(pg_width - 160-SMALL_LENGTH*2, 64-SMALL_LENGTH), CCScale9Sprite:create("data/image/misc/button_null.png"))--"data/image/misc/win_back.png""data/image/misc/1xs.png"
		--enterNameEditBox:setPosition(ccp(-68 + _frmNode.childUI["DragPanelWorld"].data.x, -pg_offY-CHAT_BOARD_HEIGHT + 54 - 18 + _frmNode.childUI["DragPanelWorld"].data.y+SMALL_LENGTH/8))
		enterNameEditBox:setPosition(ccp(-73 + _frmNode.childUI["DragPanelWorld"].data.x, -pg_offY-CHAT_BOARD_HEIGHT + 54 - 12 + _frmNode.childUI["DragPanelWorld"].data.y+SMALL_LENGTH/8))
		--enterNameEditBox:setFontName("Sketch Rockwell.ttf")
		enterNameEditBox:setFontSize(28)
		enterNameEditBox:setFontColor(ccc3(0, 0, 0))
		enterNameEditBox:setPlaceHolder(hVar.tab_string["__TEXT_TypeLetter"]) --"输入文字"
		enterNameEditBox:setPlaceholderFontColor(ccc3(128, 128, 128)) --默认显示文字颜色
		enterNameEditBox:setMaxLength(48) --最大支持字符数
		enterNameEditBox:registerScriptEditBoxHandler(editNameBoxTextEventHandle)
		enterNameEditBox:setTouchPriority(0)
		enterNameEditBox:setReturnType(kKeyboardReturnTypeDone)
		--_frmNode.childUI["DragPanelWorld"].handle._n:addChild(enterNameEditBox)
		_frmNode.handle._n:addChild(enterNameEditBox)
		
		--存储输入框指针
		current_enterNameEditBox = enterNameEditBox
		
		--发送按钮(世界聊天)
		_frmNode.childUI["btnSendMessageWorld"] = hUI.button:new({
			parent = _parentNode,
			x = pg_offX + pg_width / 2 - 130 / 2 - 1 - 15, --pg_offX + pg_width / 2 - 130 / 2 - 1,
			y = -hVar.SCREEN.h + 2 * iPhoneX_HEIGHT + 43, ---hVar.SCREEN.h + 2 * iPhoneX_HEIGHT + 46, ---hVar.SCREEN.h + 46,
			model = "misc/chest/chatsend.png",
			align = "MC",
			dragbox = _frm.childUI["dragBox"],
			w = 134,
			h = 56,
			scaleT = 0.95,
			code = function()
				--如果未连接socket工会服务器，不能操作
				if (Group_Server:GetState() ~= 1) then --未连接
					--冒字
					--local strText = "不能连接到网络" --language
					local strText = hVar.tab_string["ios_err_network_cannot_conn"] --language
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
				
				--如果未登入工会服务器，不能操作
				if (Group_Server:getonline() ~= 1) then --未登入
					--冒字
					--local strText = "不能连接到网络" --language
					local strText = hVar.tab_string["ios_err_network_cannot_conn"] --language
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
				
				--检测今日可发送次数是否用完
				local leftChatMsgNum = -1 --今日剩余聊天次数
				local vip = LuaGetPlayerVipLv() or 0
				local chatWorldMsgNum = hVar.Vip_Conifg.chatWorldMsgNum[vip] or -1
				if (chatWorldMsgNum > 0) then --有次数限制
					leftChatMsgNum = chatWorldMsgNum - current_msgWorldNum
					if (leftChatMsgNum < 0) then
						leftChatMsgNum = 0
					end
				end
				if (leftChatMsgNum == 0) then
					--冒字
					--local strText = "您今日聊天次数已用完！" --language
					local strText = hVar.tab_string["ios_err_network_cannot_chat_useout"] --language
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
				
				--被禁言不能发送消息
				if (current_msgForbidden == 1) then
					--计算禁言剩余时间
					local localTime = os.time() --客户端的时间(本地时区)
					--服务器的时间(本地时区)
					local hostTimeNow = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
					--禁言开始的时间(本地时区)
					local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
					local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
					local forbiddenBeginTime = hApi.GetNewDate(current_msgForbiddenTime) + delteZone * 3600 --服务器时间(本地时区)
					--剩余时间
					local forbiddenLeft = hostTimeNow - forbiddenBeginTime
					local minuteLeft = current_msgForbidden_minute - math.floor(forbiddenLeft / 60)
					if (minuteLeft > 0) then
						--冒字
						--local strText = "您被禁言，" .. minuteLeft .. "分钟后才能发送消息！" --language
						local strText = string.format(hVar.tab_string["ios_err_network_cannot_chat_forbidden"], minuteLeft) --language
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
				end
				
				--世界聊天全员禁言状态
				if (current_msgWorldFlag == 0) then
					if (g_is_account_test == 2) then --管理员
						--管理员允许发言
						--...
					else
						--冒字
						--local strText = "全员禁言中，只允许管理员发言！" --language
						local strText = hVar.tab_string["ios_err_network_cannot_chat_forbidden_all"] --language
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
				end
				
				--geyachao: windows版，接收不到输入框的ended事件，只能在点击按钮的时候，取一下输入的文本
				local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
				if (g_tTargetPlatform.kTargetWindows == TargetPlatform) then --windows版
					rgName = enterNameEditBox:getText()
				end
				
				--检测文字是否纯为空格
				if (rgName ~= "") then
					local bAllBlank = true
					for i = 1, #rgName, 1 do
						local s = string.sub(rgName, i, i)
						if (s ~= " ") then
							bAllBlank = false
							break
						end
					end
					if bAllBlank then
						--冒字
						--local strText = "聊天内容不能为空" --language
						local strText = hVar.tab_string["ios_chat_not_empty"] --language
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
				end
				
				--检测输入的文字是否过长
				local nLength = hApi.GetStringEmojiENLength(rgName) --英文长度
				if (nLength > 96) then
					--冒字
					--local strText = "您输入的内容过长" --language
					local strText = hVar.tab_string["ios_chat_too_long"] --language
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
				
				--处理文字(世界聊天)
				local message = rgName
				
				--去除特殊符号
				local origin = {"%(", "%)", "%.", "%%", "%+", "%-", "%*", "%?", "%[", "%]", "%^", "%$", ";", "/", "\\", "|", ":", ",", "'",}
				local replace = {"（", "）", "·", "％", "＋", "－", "＊", "？", "【", "】", "∧", "＄", "；", "╱", "╲", "│", "：", "，", "‘",}
				for i = 1, #origin, 1 do
					local originChar = origin[i]
					local replaceChar = replace[i]
					--print(i, originChar, replaceChar)
					while true do
						--print(message)
						local pos = string.find(message, originChar)
						--print(pos)
						if (pos ~= nil) then
							if (pos < #message) then --不是最后一个字符
								message = string.sub(message, 1, pos - 1) .. replaceChar .. string.sub(message, pos + 1, #message)
							else --最后一个字符
								message = string.sub(message, 1, pos - 1) .. replaceChar
							end
						else
							break
						end
					end
				end
				
				--去除回车等控制字符
				string.gsub(message, "%c", "")
				
				--去除屏蔽字
				local MESSAGE = string.upper(message) --大写(用于匹配)
				local GLOBAL_FILTER_TEXT = hVar.tab_filtertext
				for i = #GLOBAL_FILTER_TEXT, 1, -1 do
					local strFilter = GLOBAL_FILTER_TEXT[i]
					local nLength = hApi.GetStringEmojiENLength(strFilter, 1, 1) --Unicode长度
					while true do
						local pos = string.find(MESSAGE, strFilter)
						if (pos ~= nil) then
							local strRep = string.rep("*", nLength)
							--message = string.gsub(message, strFilter, strRep)
							if ((pos + #strFilter - 1) < #message) then --不是最后一个字符
								message = string.sub(message, 1, pos - 1) .. strRep .. string.sub(message, (pos + #strFilter - 1) + 1, #message)
							else --最后一个字符
								message = string.sub(message, 1, pos - 1) .. strRep
							end
							
							MESSAGE = string.upper(message) --大写(用于匹配)
						else
							break
						end
					end
				end
				
				--最后转小写
				--message = string.lower(message)
				
				--清空文字
				rgName = ""
				enterNameEditBox:setText("")
				
				--检测是否刷屏
				if (LuaCheckChatMessageIsFloodScreen(g_curPlayerName, current_chat_type, message) == 1) then
					--冒字
					--local strText = "您的聊天内容在短时间内已重复多次，不能发送" --language
					local strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_FLOOD_SCREEN"] --language
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
				
				--检测是否发言过快
				if (LuaCheckChatMessageIsTooFast(g_curPlayerName, current_chat_type, message) == 1) then
					--冒字
					--local strText = "您的聊天频率在短时间内过快，不能发送" --language
					local strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_TOO_FAST"] --language
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
				
				if (message ~= "") then
					--发送前本地先预处理，统计今日发送次数
					current_msgWorldNum = current_msgWorldNum + 1
					if (chatWorldMsgNum > 0) then --有次数限制
						leftChatMsgNum = chatWorldMsgNum - current_msgWorldNum
						if (leftChatMsgNum < 0) then
							leftChatMsgNum = 0
						end
					end
					
					if (leftChatMsgNum >= 0) then --有限制
						_frmNode.childUI["btnSendMessageWorld"].childUI["sendNoLimit"].handle._n:setVisible(false) --无限制
						
						_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"].handle._n:setVisible(true) --有限制
						_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"]:setText(hVar.tab_string["__TEXT_SEND"] .. " (" .. leftChatMsgNum .. ")") --"发送(??)"
						if (leftChatMsgNum > 0) then
							_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"].handle.s:setColor(ccc3(255, 255, 0))
						else
							_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"].handle.s:setColor(ccc3(212, 212, 212)) --灰掉
						end
					else
						_frmNode.childUI["btnSendMessageWorld"].childUI["sendNoLimit"].handle._n:setVisible(true) --无限制
						_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"].handle._n:setVisible(false) --有限制
					end
					
					--[[
					--测试 --test
					message = "一二三四五六七八九十一二三四五六七八九十"
					]]
					
					--请求发送消息（世界聊天）
					local msgType = hVar.MESSAGE_TYPE.TEXT --文本消息
					local touid = 0
					SendGroupCmdFunc["chat_send_message"](current_chat_type, msgType, message, touid)
					
					--本地添加一条发送消息记录（防刷屏）
					LuaAddtRecentChatMsg(g_curPlayerName, current_chat_type, message)
				end
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnSendMessageWorld"
		--发送按钮的文字"发送"(世界)
		_frmNode.childUI["btnSendMessageWorld"].childUI["sendNoLimit"] = hUI.label:new({
			parent = _frmNode.childUI["btnSendMessageWorld"].handle._n,
			x = -4,
			y = 1,---1,
			align = "MC",
			font = hVar.FONTC,
			size = 28,
			text = hVar.tab_string["__TEXT_SEND"], --"发送"
			border = 1,
			--RGB = {255, 255, 0,},
		})
		--发送按钮的文字"发送(nn)"(世界)
		_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"] = hUI.label:new({
			parent = _frmNode.childUI["btnSendMessageWorld"].handle._n,
			x = -4+3, --有偏移
			y = 1,---1,
			align = "MC",
			font = hVar.FONTC,
			size = 26,
			text = "", --"发送(??)",
			border = 1,
			--RGB = {255, 255, 0,},
		})
		--_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"].handle._n:setVisible(false)
		--创建时以本地数据绘制今日可发送世界聊天的次数
		local leftChatMsgNum = -1 --今日剩余聊天次数
		local vip = LuaGetPlayerVipLv() or 0
		local chatWorldMsgNum = hVar.Vip_Conifg.chatWorldMsgNum[vip] or -1
		if (chatWorldMsgNum > 0) then --有次数限制
			leftChatMsgNum = chatWorldMsgNum - current_msgWorldNum
			if (leftChatMsgNum < 0) then
				leftChatMsgNum = 0
			end
		end
		if (leftChatMsgNum >= 0) then --有限制
			_frmNode.childUI["btnSendMessageWorld"].childUI["sendNoLimit"].handle._n:setVisible(false) --无限制
			
			_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"].handle._n:setVisible(true) --有限制
			_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"]:setText(hVar.tab_string["__TEXT_SEND"] .. " (" .. leftChatMsgNum .. ")") --"发送(??)"
			if (leftChatMsgNum > 0) then
				_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"].handle.s:setColor(ccc3(255, 255, 0))
			else
				_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"].handle.s:setColor(ccc3(212, 212, 212)) --灰掉
			end
		else
			_frmNode.childUI["btnSendMessageWorld"].childUI["sendNoLimit"].handle._n:setVisible(true) --无限制
			_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"].handle._n:setVisible(false) --有限制
		end
		
		--查询的菊花
		_frmNode.childUI["waiting"] = hUI.button:new({ --作为按钮是为了挂载子控件
			parent = _BTC_pClipNodeWorld,
			x = _BTC_PageClippingRectWorld[1] + _BTC_PageClippingRectWorld[3]/2,
			y = _BTC_PageClippingRectWorld[2] - _BTC_PageClippingRectWorld[4]/2,
			z = 1,
			--label = {x = 0, y = -1, align = "MC", font = hVar.FONTC, size = 24, text = "重新连接", border = 1,},
			--model = "UI:PANEL_MENU_BTN_BIG", --"UI:SkillSlot",
			model = "misc/mask_white.png",
			--dragbox = _frm.childUI["dragBox"],
			w = 310,
			h = 120,
			--scaleT = 0.95,
			--code = function()
			--
			--end,
		})
		_frmNode.childUI["waiting"].handle.s:setColor(ccc3(128, 128, 128))
		_frmNode.childUI["waiting"].handle.s:setOpacity(64)
		_frmNode.childUI["waiting"]:setstate(-1) --默认隐藏
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "waiting"
		--查询的文字
		_frmNode.childUI["waiting"].childUI["text"] = hUI.label:new({
			parent = _frmNode.childUI["waiting"].handle._n,
			x = 0,
			y = 0,
			font = hVar.FONTC,
			align = "MC",
			size = 20,
			width = 500,
			text = "", --"正在连接中..."
			RGB = {212, 212, 212,},
		})
		
		--onCreateNewMessageHint()
		--onRemoveNewMessageHint()
		
		--添加监听
		--添加移除事件监听：横竖屏切换
 		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenAchievement_", on_spine_screen_event)
		--添加事件监听：收到工会服务器socket连接结果回调
		hGlobal.event:listen("LocalEvent_Group_NetEvent", "__GroupServerConnectBack_", on_receive_grouperver_connect_back_event)
		--添加事件监听：收到工会服务器登陆结果回调
		hGlobal.event:listen("LocalEvent_Group_LogEvent", "__GroupServerLoginBack_", on_receive_group_server_login_back_event)
		--添加事件监听：收到聊天模块初始化事件
		hGlobal.event:listen("LocalEvent_Group_ChatInitEvent", "__GroupServerChatInitBack_", on_receive_chat_init_event)
		--添加事件监听：收到聊天消息id事件
		hGlobal.event:listen("LocalEvent_Group_ChatIDListEvent", "__GroupServerChatIDListBack_", on_receive_chat_id_list_event)
		--添加事件监听：收到聊天消息内容事件
		hGlobal.event:listen("LocalEvent_Group_ChatContentListEvent", "__GroupServerChatContentListBack_", on_receive_chat_content_list_event)
		--添加事件监听：收到单条聊天消息事件
		hGlobal.event:listen("LocalEvent_Group_SingleChatMessageEvent", "__SingleChatMessageBack_", on_receive_single_chat_message_event)
		--添加事件监听：收到更新单条聊天消息事件
		hGlobal.event:listen("LocalEvent_Group_UpdatChatMessageEvent", "__UpdateChatMessageBack_", on_receive_update_chat_message_event)
		--添加事件监听：收到删除聊天消息事件
		hGlobal.event:listen("LocalEvent_Group_RemoveChatMessageEvent", "__RemoveChatMessageBack_", on_receive_remove_chat_message_event)
		--添加事件监听：收到被禁言的通知事件
		hGlobal.event:listen("LocalEvent_Group_ChatForbiddenEvent", "__ChatForbiddenBack_", on_receive_chat_forbidden_event)
		--添加事件监听：收到发起私聊请求的结果返回
		hGlobal.event:listen("LocalEvent_Group_PrivateInviteChatEvent", "__ChatPrivateInviteBack_", on_receive_chat_private_invite_event)
		--添加事件监听：收到工会操作结果返回
		hGlobal.event:listen("LocalEvent_Group_OperationRet", "__GroupOperationRetBack_", on_receive_group_result_event)
		--添加事件监听：收到加入军团邀请函结果返回
		hGlobal.event:listen("localEvent_GroupInviteJoinBack", "__GroupInviteRetBack_", on_receive_group_invite_back_event)
		--添加监听：程序进入后台的回调
		hGlobal.event:listen("LocalEvent_AppEnterBackground", "__ChatMessageBack_", on_app_enter_background_event)
		--添加监听：游戏局结束事件
		hGlobal.event:listen("LocalEvent_GameOver", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（夺塔奇兵）
		hGlobal.event:listen("LocalEvent_GameOver_PVP", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（魔龙宝库）
		hGlobal.event:listen("LocalEvent_GameOver_PVP_Endless", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（铜雀台）
		hGlobal.event:listen("LocalEvent_GameOver_PVP_Endless_Singlebattle", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（新手地图）
		hGlobal.event:listen("LocalEvent_GameOver_NewGuideMap", "__ChatGameEnd_", on_game_end_event)
		--添加监听：PVP等待其他玩家事件
		hGlobal.event:listen("LocalEvent_Pvp_Delay_Player", "__ChatPVPWaitPlayer_", on_pvp_wait_player_event)
		--添加监听：PVP本地长时间未响应事件
		hGlobal.event:listen("LocalEvent_Pvp_LocalNoHeart", "__ChatPVPLocalNoHeart_", on_pvp_local_noheart_event)
		--添加监听：安卓本地掉线事件
		hGlobal.event:listen("LocalEvent_showAndroidNetAlreadyFrm", "__ChatAndroidDisconnect_", on_android_local_disconnect_event)
		--添加事件监听：切换剧情地图场景事件
		hGlobal.event:listen("LocalEvent_Battle_SwitchGame", "__BattleSwitchGameBack_chat2", on_game_end_event)
		--添加事件监听：切换pvp场景事件
		hGlobal.event:listen("LocalEvent_Pvp_SwitchGame", "__PVPSwitchGameBack_chat2", on_game_end_event)
		--添加事件监听：切换pvp匹配房场景事件
		hGlobal.event:listen("LocalEvent_Pvp_Match_SwitchGame", "__MatchSwitchGameBack_chat2", on_game_end_event)
		
		--私聊
		--添加监听：收到增加单个私聊好友
		hGlobal.event:listen("LocalEvent_Group_PrivateFriendAddEvent", "__ChatPrivateFriendAddBack_", on_add_private_friend_event)
		--添加监听：收到删除单个私聊好友
		hGlobal.event:listen("LocalEvent_Group_PrivateFriendRemoveEvent", "__ChatPrivateFriendRemoveBack_", on_remove_private_friend_event)
		
		--刷新滚动的timer（世界消息）
		--hApi.addTimerForever("__CHATFRAME_PRIVATE_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_chatframe_scroll_private_loop)
		hApi.addTimerForever("__CHATFRAME_WORLD_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_chatframe_scroll_world_loop)
		--刷新红包领取倒计时的timer
		hApi.addTimerForever("__CHATFRAME_REDPACKET_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 1000, refresh_chat_redpacket_loop)
		--自动连接工会服务器的timer
		hApi.addTimerForever("__CHATAUTOLINK_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 5000, refresh_chatframe_autolink_loop)
		--异步绘制聊天消息的timer
		hApi.addTimerForever("__CHATPAINT_MESSAGE_ASYNC__", hVar.TIMER_MODE.GAMETIME, 1, refresh_async_paint_message_loop)
		
		--[[
		--测试 --test
		--发起查询，1元档商品信息
		--SendCmdFunc["iap_sale_gift"]()
		--依次绘制每条消息
		local tChatMsgList =
		{
			{msgId = 1, name = "adidas先生", date = "00:00:01", content = "¡¡¡¡¡¡¡¡¡¡",},
			{msgId = 1, name = "游客", date = "10:03:23", content = "||||||||||",},
			{msgId = 1, name = "游客21000001", date = "12:00:59", content = "}}}}}}}}}}",},
			{msgId = 1, name = "GUEST", date = "13:07:23", content = "^^^^^^^^^^",},
			{msgId = 1, name = "diaoxian", date = "14:23:00", content = "\\\\\\\\\\\\\\\\\\\\",},
			{msgId = 1, name = "u123123", date = "15:46:33", content = "~~~~~~~~~~",},
			{msgId = 1, name = "我是你的发", date = "16:54:47", content = "``````````",},
			{msgId = 1, name = "爱情", date = "18:03:09", content = "爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了",},
			{msgId = 1, name = "掉线", date = "20:33:12", content = ">>>>>>>>>>",},
			{msgId = 1, name = "打老师345", date = "23:24:32", content = "加群 qq:19900000",},
		}
		current_DLCMap_max_num = #tChatMsgList
		--依次绘制消息
		for i = 1, 10, 1 do
			on_create_single_message_UI(tChatMsgList[i], i)
		end
		]]
		
		
		--[[
		--获得一个加速度，使右边自动往上滚动
		--超过一页的数量才滑屏
		if (current_DLCMap_max_num > (WEAPON_X_NUM * WEAPON_Y_NUM)) then
			--向上滚屏
			b_need_auto_fixing_dlcmapinfo = true
			friction_dlcmapinfo = 0
			friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
			draggle_speed_y_dlcmapinfo = MAX_SPEED / 1.0 --正速度
		end
		]]
		
		--挡操作
		--hUI.NetDisable(30000)
		
		--发起登入工会服务器操作
		--print("发起登入工会服务器操作")
		--print("发起登入工会服务器操作", Group_Server:GetState())
		if (Group_Server:GetState() == 1) then --不重复登入
			--模拟触发连接工会服务socket结果回调
			--print("模拟触发连接工会服务socket结果回调")
			on_receive_grouperver_connect_back_event(1)
		else
			--连接
			--print("Group_Server:Connect()")
			Group_Server:Connect()
		end
	end
	
	--!!!! edit by mj !!!!wait edit this func!!!! 2022.11.15
	--函数：创建邀请聊天界面（第2个分页）-> 3
	OnCreateInviteChatInfoFrame = function(pageIdx)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--允许本分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNodeInvite", 1)
		
		--标记本分页的聊天频道(邀请聊天频道)
		current_chat_type = hVar.CHAT_TYPE.INVITE
		
		--初始化数据
		current_DLCMap_max_num = 0
		current_async_paint_list = {} --清空异步缓存待绘制内容
		current_DLCMap_friend_max_num = 0
		current_DLCMap_roomid = 0 --当前请求组队副本的房间消息id
		
		--统一处理聊天页的位置和大小
		local pg_offX = CHAT_INFO_FRM_POS_X 			--362
		local pg_offY = CHAT_INFO_FRM_POS_Y - 63 / 2 	---hVar.SCREEN.h / 2 + 10 - 63 / 2
		local pg_width = BOARD_WIDTH - 10
		local pg_height = CHAT_INFO_FRM_POS_HEIGHT + 63	--hVar.SCREEN.h - 136 + 63
		
		--[[
		--左侧DLC地图包列表提示上翻页的图片
		_frmNode.childUI["DLCMapInfoPageUp"] = hUI.image:new({
			parent = _BTC_pClipNodeWorld,
			model = "misc/chest/tutorial_arrow_right.png", --"UI:PageBtn",
			x = pg_offX,
			y = pg_offY + 238,
			scale = 0.5,
			z = 500, --最前端显示
		})
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setRotation(-90)
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --默认不显示左上翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["DLCMapInfoPageUp"].handle._n:runAction(forever)
		
		--左侧DLC地图包列表提示下翻页的图片
		_frmNode.childUI["DLCMapInfoPageDown"] = hUI.image:new({
			parent = _BTC_pClipNodeWorld,
			model = "misc/chest/tutorial_arrow_right.png", --"UI:PageBtn",
			x = pg_offX,
			y = pg_offY - 238,
			scale = 0.5,
			z = 500, --最前端显示
		})
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setRotation(90)
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["DLCMapInfoPageDown"].handle._n:runAction(forever)
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --默认不显示下分翻页提示
		]]
		
		--[[
		--左侧向上翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["DLCMapInfoPageUp_Btn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = pg_offX,
			y = pg_offY + 182,
			w = 360,
			h = 60,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--超过一页的数量才滑屏
				if (current_DLCMap_max_num > (WEAPON_X_NUM * WEAPON_Y_NUM)) then
					--print("向下滚屏", screenY)
					--向下滚屏
					b_need_auto_fixing_dlcmapinfo = true
					friction_dlcmapinfo = 0
					friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
					draggle_speed_y_dlcmapinfo = -MAX_SPEED / 2.0 --负速度
				end
			end,
		})
		_frmNode.childUI["DLCMapInfoPageUp_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageUp_Btn"
		]]
		
		--[[
		--左侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["DLCMapInfoPageDown_Btn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = pg_offX,
			y = pg_offY - 182,
			w = 360,
			h = 60,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--超过一页的数量才滑屏
				if (current_DLCMap_max_num > (WEAPON_X_NUM * WEAPON_Y_NUM)) then
					--print("向上滚屏", screenY)
					--向上滚屏
					b_need_auto_fixing_dlcmapinfo = true
					friction_dlcmapinfo = 0
					friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
					draggle_speed_y_dlcmapinfo = MAX_SPEED / 2.0 --正速度
				end
			end,
		})
		_frmNode.childUI["DLCMapInfoPageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageDown_Btn"
		]]
		
		--检测滑动事件的控件(邀请聊天)
		_frmNode.childUI["DragPanelInvite"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = pg_offX,
			y = pg_offY,
			w = pg_width,
			h = pg_height,
			failcall = 1,
			
			--按下事件(邀请聊天)
			codeOnTouch = function(self, touchX, touchY, sus)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
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
				friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
				
				--如果DLC地图面板数量未铺满一页，那么不需要滑动
				--if (current_DLCMap_max_num <= (WEAPON_X_NUM * WEAPON_Y_NUM)) then
				--	click_scroll_dlcmapinfo = false --不需要滑动DLC地图面板
				--end
				
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
				
				--模拟按下事件
				--检测是否点到了某些控件里(邀请聊天)
				for i = 1, current_DLCMap_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					if ctrli then
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						
						--检测是否点到了邀请函申请按钮
						local ctrlI = ctrli.childUI["btnJoin"]
						if ctrlI then
							if (ctrlI.data.state == 1) then --按钮可点状态
								local bcx = ctrlI.data.x --中心点x坐标
								local bcy = ctrlI.data.y --中心点y坐标
								local bcw, bch = ctrlI.data.w, ctrlI.data.h
								local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
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
									ctrlI.handle._n:stopAllActions()
									ctrlI.handle._n:runAction(sequence)
								end
							end
						end
						
						--检测是否点到了邀请函不申请按钮
						local ctrlI = ctrli.childUI["btnNotJoin"]
						if ctrlI then
							if (ctrlI.data.state == 1) then --按钮可点状态
								local bcx = ctrlI.data.x --中心点x坐标
								local bcy = ctrlI.data.y --中心点y坐标
								local bcw, bch = ctrlI.data.w, ctrlI.data.h
								local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
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
									ctrlI.handle._n:stopAllActions()
									ctrlI.handle._n:runAction(sequence)
								end
							end
						end
						
						--检测是否点到了组队邀请的前往组队按钮
						local ctrlI = ctrli.childUI["btnCouple"]
						if ctrlI then
							if (ctrlI.data.state == 1) then --按钮可点状态
								local bcx = ctrlI.data.x --中心点x坐标
								local bcy = ctrlI.data.y --中心点y坐标
								local bcw, bch = ctrlI.data.w, ctrlI.data.h
								local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
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
									ctrlI.handle._n:stopAllActions()
									ctrlI.handle._n:runAction(sequence)
								end
							end
						end
					end
				end
				
				--在滑动过程中才会处理滑动
				if click_scroll_dlcmapinfo then
					--显示滚动条
					--_frmNode.childUI["ScrollBar"]:setstate(1)
					onShowScrollBarHint()
					
					--更新滚动条的进度(邀请聊天)
					local progressMax = delta1_ly - deltNa_ry
					local progressNow = delta1_ly
					local height = _frmNode.childUI["ScrollBar"].data.w - _frmNode.childUI["ScrollBarProgress"].data.h --h
					local scrollX = _frmNode.childUI["ScrollBarProgress"].data.x
					local scrollY = _frmNode.childUI["ScrollBar"].data.y + (1 - progressNow / progressMax) * height - height / 2
					_frmNode.childUI["ScrollBarProgress"]:setXY(scrollX, scrollY)
				end
			end,
			
			--滑动事件(邀请聊天)
			codeOnDrag = function(self, touchX, touchY, sus)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--print("codeOnDrag", touchX, touchY, sus, draggle_speed_y_dlcmapinfo)
				
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
					
					--更新滚动条的进度(邀请聊天)
					local progressMax = delta1_ly - deltNa_ry
					local progressNow = delta1_ly
					local height = _frmNode.childUI["ScrollBar"].data.w - _frmNode.childUI["ScrollBarProgress"].data.h --h
					local scrollX = _frmNode.childUI["ScrollBarProgress"].data.x
					local scrollY = _frmNode.childUI["ScrollBar"].data.y + (1 - progressNow / progressMax) * height - height / 2
					_frmNode.childUI["ScrollBarProgress"]:setXY(scrollX, scrollY)
				end
				
				--存储本次的位置
				last_click_pos_y_dlcmapinfo = touchX
				last_click_pos_y_dlcmapinfo = touchY
			end,
			
			--抬起事件(邀请聊天)
			code = function(self, touchX, touchY, sus)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_dlcmapinfo then
					--if (touchX ~= click_pos_x_dlcmapinfo) or (touchY ~= click_pos_y_dlcmapinfo) then --不是点击事件
						b_need_auto_fixing_dlcmapinfo = true
						friction_dlcmapinfo = 0
						friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
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
							friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
							draggle_speed_y_dlcmapinfo = MAX_SPEED / 1.0 --正速度 --速度一般大
							
							return
						end
					end
				end
				
				--是否选中某个邀请函的操作按钮
				local inviteFlag = 0
				local selectTipIdx = 0
				for i = 1, current_DLCMap_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					if ctrli then
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						local cw, ch = ctrli.data.w, ctrli.data.h
						local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
						local rx, ry = lx + cw, ly + ch --最右下角坐标
						--print(i, cx, cy)
						
						--检测是否点到了军团邀请函的申请按钮
						local ctrlI = ctrli.childUI["btnJoin"]
						if ctrlI then
							if (ctrlI.data.state == 1) then --按钮可点状态
								local bcx = ctrlI.data.x --中心点x坐标
								local bcy = ctrlI.data.y --中心点y坐标
								local bcw, bch = ctrlI.data.w, ctrlI.data.h
								local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
								local brx, bry = blx + bcw, bly + bch --最右下角坐标
								--print(i, lx, rx, ly, ry, touchX, touchY)
								if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
									selectTipIdx = i
									inviteFlag = 1
								end
							end
						end
						
						--检测是否点到了军团邀请函的不申请按钮
						local ctrlI = ctrli.childUI["btnNotJoin"]
						if ctrlI then
							if (ctrlI.data.state == 1) then --按钮可点状态
								local bcx = ctrlI.data.x --中心点x坐标
								local bcy = ctrlI.data.y --中心点y坐标
								local bcw, bch = ctrlI.data.w, ctrlI.data.h
								local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
								local brx, bry = blx + bcw, bly + bch --最右下角坐标
								--print(i, lx, rx, ly, ry, touchX, touchY)
								if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
									selectTipIdx = i
									inviteFlag = 0
								end
							end
						end
					end
				end
				
				if (click_scroll_dlcmapinfo) and (math.abs(touchY - click_pos_y_dlcmapinfo) > 42) then
					selectTipIdx = 0
				end
				
				--点击到某个档位的奖励控件之内(私聊)
				if (selectTipIdx > 0) then
					if (inviteFlag == 1) then --申请
						--点击军团邀请函的申请按钮
						OnClickInviteJoinBtn(selectTipIdx)
					elseif (inviteFlag == 0) then --不申请
						--点击军团邀请函的不申请按钮
						OnClickInviteNotJoinBtn(selectTipIdx)
					end
				end
				
				--检测是否点到了组队邀请的前往组队按钮
				for i = 1, current_DLCMap_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					if ctrli then
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						local cw, ch = ctrli.data.w, ctrli.data.h
						local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
						local rx, ry = lx + cw, ly + ch --最右下角坐标
						
						local ctrlI = ctrli.childUI["btnCouple"]
						if ctrlI then
							local bcx = ctrlI.data.x --中心点x坐标
							local bcy = ctrlI.data.y --中心点y坐标
							local bcw, bch = ctrlI.data.w, ctrlI.data.h
							local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
							local brx, bry = blx + bcw, bly + bch --最右下角坐标
							--print(i, lx, rx, ly, ry, touchX, touchY)
							if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
								--点击组队邀请的前往组队按钮
								OnClickInviteBattleCoupleBtn(i)
							end
						end
					end
				end
				
				--是否选中某个聊天消息的头像区域(邀请聊天)
				local selectTipIdx = 0
				for i = 1, current_DLCMap_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					if ctrli then
						if ctrli.handle._n then
							local cx = ctrli.data.x --中心点x坐标
							local cy = ctrli.data.y --中心点y坐标
							local cw, ch = ctrli.data.w, ctrli.data.h
							local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
							local rx, ry = lx + cw, ly + ch --最右下角坐标
							--print(i, cx, cy)
							
							--检测是否点到了头像
							local ctrlI = ctrli.childUI["roleIcon"]
							if ctrlI then
								local bcx = ctrlI.data.x --中心点x坐标
								local bcy = ctrlI.data.y --中心点y坐标
								local bcw, bch = ctrlI.data.w + 20, ctrlI.data.h + 20 --点击区域大一些
								local blx, bly = cx + bcx - bcw / 2, cy  + bcy - bch / 2 --最左上侧坐标
								local brx, bry = blx + bcw, bly + bch --最右下角坐标
								--print(i, bcx, bcy, bcw, bch)
								if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
									selectTipIdx = i
									--print("点击按钮" .. selectTipIdx)
								end
							end
						end
					end
				end
				
				if (click_scroll_dlcmapinfo) and (math.abs(touchY - click_pos_y_dlcmapinfo) > 42) then
					selectTipIdx = 0
				end
				
				--点击到某个档位的奖励控件之内(邀请聊天)
				if (selectTipIdx > 0) then
					--弹出操作界面
					--print(selectTipIdx)
					local ctrlI = _frmNode.childUI["DLCMapInfoNode" .. selectTipIdx]
					if ctrlI then
						
						if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
							--创建消息互动操作界面tip
							OnCreateChatDialogueTip(selectTipIdx)
						else
							--此消息不是系统、不是我发的，可以有个交互操作
							local uid = ctrlI.data.uid
							if (uid ~= 0) and (uid ~= xlPlayer_GetUID()) then
								--创建消息互动操作界面tip
								OnCreateChatDialogueTip(selectTipIdx)
							end
						end
					end
				end
				
				--标记不用滑动
				click_scroll_dlcmapinfo = false
			end,
		})
		_frmNode.childUI["DragPanelInvite"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DragPanelInvite"
		
		--滑动条(邀请聊天)
		_frmNode.childUI["ScrollBar"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/rank_line.png", --"UI:vipline", --"misc/chest/herodetailattr.png",
			x = pg_offX + pg_width / 2 - 7,
			y = pg_offY,
			h = 4,
			w = pg_height - 6,
		})
		_frmNode.childUI["ScrollBar"].handle._n:setRotation(90)
		_frmNode.childUI["ScrollBar"].handle.s:setOpacity(0)
		_frmNode.childUI["ScrollBar"]:setstate(-1) --默认隐藏
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ScrollBar"
		--滚动进度
		_frmNode.childUI["ScrollBarProgress"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/scrollBtn.png",	--"UI:scrollBtn",
			x = pg_offX + pg_width / 2 - 7,
			y = pg_offY,
			w = 10,
			h = 22,
		})
		_frmNode.childUI["ScrollBarProgress"].handle.s:setOpacity(0)
		_frmNode.childUI["ScrollBarProgress"]:setstate(-1) --默认隐藏
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ScrollBarProgress"
		
		--物品背景图
		--九宫格
		local s91 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bottom9g.png", 0, 0, pg_width-2, pg_height, _frmNode.childUI["DragPanelInvite"])
		--s9:setColor(ccc3(255, 255, 255))
		--s9:setOpacity(128)
		local s92 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bottom9s.png", 0, 0, pg_width-2, pg_height, _frmNode.childUI["DragPanelInvite"])
		
		--删除之前可能的输入框
		if current_enterNameEditBox then
			_frmNode.handle._n:removeChild(current_enterNameEditBox, true)
			current_enterNameEditBox = nil
		end
		
		--存储输入框指针
		current_enterNameEditBox = nil
		
		--查询的菊花
		_frmNode.childUI["waiting"] = hUI.button:new({ --作为按钮是为了挂载子控件
			parent = _BTC_pClipNodeCouple,
			x = _BTC_PageClippingRectWorld[1] + _BTC_PageClippingRectWorld[3]/2,
			y = _BTC_PageClippingRectWorld[2] - _BTC_PageClippingRectWorld[4]/2,
			z = 1,
			--label = {x = 0, y = -1, align = "MC", font = hVar.FONTC, size = 24, text = "重新连接", border = 1,},
			--model = "UI:PANEL_MENU_BTN_BIG", --"UI:SkillSlot",
			model = "misc/mask_white.png",
			--dragbox = _frm.childUI["dragBox"],
			w = 310,
			h = 120,
			--scaleT = 0.95,
			--code = function()
			--
			--end,
		})
		_frmNode.childUI["waiting"].handle.s:setColor(ccc3(128, 128, 128))
		_frmNode.childUI["waiting"].handle.s:setOpacity(64)
		_frmNode.childUI["waiting"]:setstate(-1) --默认隐藏
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "waiting"
		--查询的文字
		_frmNode.childUI["waiting"].childUI["text"] = hUI.label:new({
			parent = _frmNode.childUI["waiting"].handle._n,
			x = 0,
			y = 0,
			font = hVar.FONTC,
			align = "MC",
			size = 20,
			width = 500,
			text = "", --"正在连接中..."
			RGB = {212, 212, 212,},
		})
		
		--添加监听
		--添加移除事件监听：横竖屏切换
 		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenAchievement_", on_spine_screen_event)
		--添加事件监听：收到工会服务器socket连接结果回调
		hGlobal.event:listen("LocalEvent_Group_NetEvent", "__GroupServerConnectBack_", on_receive_grouperver_connect_back_event)
		--添加事件监听：收到工会服务器登陆结果回调
		hGlobal.event:listen("LocalEvent_Group_LogEvent", "__GroupServerLoginBack_", on_receive_group_server_login_back_event)
		--添加事件监听：收到聊天模块初始化事件
		hGlobal.event:listen("LocalEvent_Group_ChatInitEvent", "__GroupServerChatInitBack_", on_receive_chat_init_event)
		--添加事件监听：收到聊天消息id事件
		hGlobal.event:listen("LocalEvent_Group_ChatIDListEvent", "__GroupServerChatIDListBack_", on_receive_chat_id_list_event)
		--添加事件监听：收到聊天消息内容事件
		hGlobal.event:listen("LocalEvent_Group_ChatContentListEvent", "__GroupServerChatContentListBack_", on_receive_chat_content_list_event)
		--添加事件监听：收到单条聊天消息事件
		hGlobal.event:listen("LocalEvent_Group_SingleChatMessageEvent", "__SingleChatMessageBack_", on_receive_single_chat_message_event)
		--添加事件监听：收到更新单条聊天消息事件
		hGlobal.event:listen("LocalEvent_Group_UpdatChatMessageEvent", "__UpdateChatMessageBack_", on_receive_update_chat_message_event)
		--添加事件监听：收到删除聊天消息事件
		hGlobal.event:listen("LocalEvent_Group_RemoveChatMessageEvent", "__RemoveChatMessageBack_", on_receive_remove_chat_message_event)
		--添加事件监听：收到被禁言的通知事件
		hGlobal.event:listen("LocalEvent_Group_ChatForbiddenEvent", "__ChatForbiddenBack_", on_receive_chat_forbidden_event)
		--添加事件监听：收到发起私聊请求的结果返回
		hGlobal.event:listen("LocalEvent_Group_PrivateInviteChatEvent", "__ChatPrivateInviteBack_", on_receive_chat_private_invite_event)
		--添加事件监听：收到工会操作结果返回
		hGlobal.event:listen("LocalEvent_Group_OperationRet", "__GroupOperationRetBack_", on_receive_group_result_event)
		--添加事件监听：收到加入军团邀请函结果返回
		hGlobal.event:listen("localEvent_GroupInviteJoinBack", "__GroupInviteRetBack_", on_receive_group_invite_back_event)
		--添加监听：程序进入后台的回调
		hGlobal.event:listen("LocalEvent_AppEnterBackground", "__ChatMessageBack_", on_app_enter_background_event)
		--添加监听：游戏局结束事件
		hGlobal.event:listen("LocalEvent_GameOver", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（夺塔奇兵）
		hGlobal.event:listen("LocalEvent_GameOver_PVP", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（魔龙宝库）
		hGlobal.event:listen("LocalEvent_GameOver_PVP_Endless", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（铜雀台）
		hGlobal.event:listen("LocalEvent_GameOver_PVP_Endless_Singlebattle", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（新手地图）
		hGlobal.event:listen("LocalEvent_GameOver_NewGuideMap", "__ChatGameEnd_", on_game_end_event)
		--添加监听：PVP等待其他玩家事件
		hGlobal.event:listen("LocalEvent_Pvp_Delay_Player", "__ChatPVPWaitPlayer_", on_pvp_wait_player_event)
		--添加监听：PVP本地长时间未响应事件
		hGlobal.event:listen("LocalEvent_Pvp_LocalNoHeart", "__ChatPVPLocalNoHeart_", on_pvp_local_noheart_event)
		--添加监听：安卓本地掉线事件
		hGlobal.event:listen("LocalEvent_showAndroidNetAlreadyFrm", "__ChatAndroidDisconnect_", on_android_local_disconnect_event)
		--添加事件监听：切换剧情地图场景事件
		hGlobal.event:listen("LocalEvent_Battle_SwitchGame", "__BattleSwitchGameBack_chat2", on_game_end_event)
		--添加事件监听：切换pvp场景事件
		hGlobal.event:listen("LocalEvent_Pvp_SwitchGame", "__PVPSwitchGameBack_chat2", on_game_end_event)
		--添加事件监听：切换pvp匹配房场景事件
		hGlobal.event:listen("LocalEvent_Pvp_Match_SwitchGame", "__MatchSwitchGameBack_chat2", on_game_end_event)
		
		--邀请
		--添加事件监听：收到pvp连接结果回调
		hGlobal.event:listen("LocalEvent_Pvp_NetEvent", "__ConnectBack_page_chat", on_receive_pvp_connect_back_event_chat)
		--添加事件监听：收到登入结果回调
		hGlobal.event:listen("LocalEvent_Pvp_PlayerLoginEvent", "__LoginBack_page_chat", on_receive_pvp_login_back_event_chat)
		--添加事件监听：收到初始化玩家基础信息结果回调
		hGlobal.event:listen("LocalEvent_Pvp_UserBaseInfoQuerySuccess", "__BaseInfoQueryBack_page_chat", on_receive_pvp_baseinfo_query_back_event_chat)
		--添加事件监听：pvp错误信息提示
		hGlobal.event:listen("LocalEvent_Pvp_NetLogicError", "__NetLogicError_page_chat", on_receive_pvp_NetLogicError_event_chat)
		--添加事件监听：进入pvp房间失败事件
		hGlobal.event:listen("LocalEvent_Pvp_RoomEnter_Fail", "__EnterRoomFail_page_chat", on_receive_pvp_EnterRoom_Fail_event_page_chat)
		--添加事件监听：聊天直接进入pvp房间成功事件
		hGlobal.event:listen("LocalEvent_Pvp_RoomDirectEnter_Success", "__EnterRoomsuccess_page_chat", on_receive_pvp_EnterRoom_Success_event_page_chat)
		
		--私聊
		--添加监听：收到增加单个私聊好友
		hGlobal.event:listen("LocalEvent_Group_PrivateFriendAddEvent", "__ChatPrivateFriendAddBack_", on_add_private_friend_event)
		--添加监听：收到删除单个私聊好友
		hGlobal.event:listen("LocalEvent_Group_PrivateFriendRemoveEvent", "__ChatPrivateFriendRemoveBack_", on_remove_private_friend_event)
		
		--刷新滚动的timer（邀请消息）
		hApi.addTimerForever("__CHATFRAME_INVITE_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 1000, refresh_chatframe_scroll_invite_loop)
		hApi.addTimerForever("__CHATFRAME_WORLD_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_chatframe_scroll_world_loop)
		--刷新红包领取倒计时的timer
		hApi.addTimerForever("__CHATFRAME_REDPACKET_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 1000, refresh_chat_redpacket_loop)
		--自动连接工会服务器的timer
		hApi.addTimerForever("__CHATAUTOLINK_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 5000, refresh_chatframe_autolink_loop)
		--异步绘制聊天消息的timer
		hApi.addTimerForever("__CHATPAINT_MESSAGE_ASYNC__", hVar.TIMER_MODE.GAMETIME, 1, refresh_async_paint_message_loop)
		
		--[[
		--测试 --test
		--发起查询，1元档商品信息
		--SendCmdFunc["iap_sale_gift"]()
		--依次绘制每条消息
		local tChatMsgList =
		{
			{msgId = 1, name = "adidas先生", date = "00:00:01", content = "¡¡¡¡¡¡¡¡¡¡",},
			{msgId = 1, name = "游客", date = "10:03:23", content = "||||||||||",},
			{msgId = 1, name = "游客21000001", date = "12:00:59", content = "}}}}}}}}}}",},
			{msgId = 1, name = "GUEST", date = "13:07:23", content = "^^^^^^^^^^",},
			{msgId = 1, name = "diaoxian", date = "14:23:00", content = "\\\\\\\\\\\\\\\\\\\\",},
			{msgId = 1, name = "u123123", date = "15:46:33", content = "~~~~~~~~~~",},
			{msgId = 1, name = "我是你的发", date = "16:54:47", content = "``````````",},
			{msgId = 1, name = "爱情", date = "18:03:09", content = "爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了",},
			{msgId = 1, name = "掉线", date = "20:33:12", content = ">>>>>>>>>>",},
			{msgId = 1, name = "打老师345", date = "23:24:32", content = "加群 qq:19900000",},
		}
		current_DLCMap_max_num = #tChatMsgList
		--依次绘制消息
		for i = 1, 10, 1 do
			on_create_single_message_UI(tChatMsgList[i], i)
		end
		]]
		
		
		--[[
		--获得一个加速度，使右边自动往上滚动
		--超过一页的数量才滑屏
		if (current_DLCMap_max_num > (WEAPON_X_NUM * WEAPON_Y_NUM)) then
			--向上滚屏
			b_need_auto_fixing_dlcmapinfo = true
			friction_dlcmapinfo = 0
			friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
			draggle_speed_y_dlcmapinfo = MAX_SPEED / 1.0 --正速度
		end
		]]
		
		--挡操作
		--hUI.NetDisable(30000)
		
		--发起登入工会服务器操作
		--print("发起登入工会服务器操作")
		--print("发起登入工会服务器操作", Group_Server:GetState())
		if (Group_Server:GetState() == 1) then --不重复登入
			--模拟触发连接工会服务socket结果回调
			--print("模拟触发连接工会服务socket结果回调")
			on_receive_grouperver_connect_back_event(1)
		else
			--连接
			--print("Group_Server:Connect()")
			Group_Server:Connect()
		end
	end
	
	--函数：创建私聊界面（第3个分页）-> 2
	OnCreatePrivateChatInfoFrame = function(pageIdx)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--允许本分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNodePrivate", 1)
		
		--标记本分页的聊天频道(私聊频道)
		current_chat_type = hVar.CHAT_TYPE.PRIVATE
		
		--初始化数据
		current_DLCMap_max_num = 0
		current_async_paint_list = {} --清空异步缓存待绘制内容
		current_DLCMap_friend_max_num = 0
		current_DLCMap_roomid = 0 --当前请求组队副本的房间消息id
		
		--统一处理聊天页的位置和大小
		local pg_offX = CHAT_INFO_FRM_POS_X 							--362
		local pg_offY = CHAT_INFO_FRM_POS_Y 							---hVar.SCREEN.h / 2 + 10
		local pg_width = BOARD_WIDTH					--BOARD_WIDTH - 10
		local pg_height = CHAT_INFO_FRM_POS_HEIGHT 						--hVar.SCREEN.h - 136
		
		--[[
		--左侧DLC地图包列表提示上翻页的图片
		_frmNode.childUI["DLCMapInfoPageUp"] = hUI.image:new({
			parent = _BTC_pClipNodeWorld,
			model = "misc/chest/tutorial_arrow_right.png", --"UI:PageBtn",
			x = pg_offX,
			y = pg_offY + 238,
			scale = 0.5,
			z = 500, --最前端显示
		})
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setRotation(-90)
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --默认不显示左上翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["DLCMapInfoPageUp"].handle._n:runAction(forever)
		
		--左侧DLC地图包列表提示下翻页的图片
		_frmNode.childUI["DLCMapInfoPageDown"] = hUI.image:new({
			parent = _BTC_pClipNodeWorld,
			model = "misc/chest/tutorial_arrow_right.png", --"UI:PageBtn",
			x = pg_offX,
			y = pg_offY - 238,
			scale = 0.5,
			z = 500, --最前端显示
		})
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setRotation(90)
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["DLCMapInfoPageDown"].handle._n:runAction(forever)
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --默认不显示下分翻页提示
		]]
		
		--[[
		--左侧向上翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["DLCMapInfoPageUp_Btn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = pg_offX,
			y = pg_offY + 182,
			w = 360,
			h = 60,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--超过一页的数量才滑屏
				if (current_DLCMap_max_num > (WEAPON_X_NUM * WEAPON_Y_NUM)) then
					--print("向下滚屏", screenY)
					--向下滚屏
					b_need_auto_fixing_dlcmapinfo = true
					friction_dlcmapinfo = 0
					friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
					draggle_speed_y_dlcmapinfo = -MAX_SPEED / 2.0 --负速度
				end
			end,
		})
		_frmNode.childUI["DLCMapInfoPageUp_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageUp_Btn"
		]]
		
		--[[
		--左侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["DLCMapInfoPageDown_Btn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = pg_offX,
			y = pg_offY - 182,
			w = 360,
			h = 60,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--超过一页的数量才滑屏
				if (current_DLCMap_max_num > (WEAPON_X_NUM * WEAPON_Y_NUM)) then
					--print("向上滚屏", screenY)
					--向上滚屏
					b_need_auto_fixing_dlcmapinfo = true
					friction_dlcmapinfo = 0
					friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
					draggle_speed_y_dlcmapinfo = MAX_SPEED / 2.0 --正速度
				end
			end,
		})
		_frmNode.childUI["DLCMapInfoPageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageDown_Btn"
		]]
		
		--检测滑动事件的控件(私聊)
		_frmNode.childUI["DragPanelPrivate"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = pg_offX,
			y = pg_offY,
			w = pg_width,
			h = pg_height,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
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
				friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
				
				--如果DLC地图面板数量未铺满一页，那么不需要滑动
				--if (current_DLCMap_max_num <= (WEAPON_X_NUM * WEAPON_Y_NUM)) then
				--	click_scroll_dlcmapinfo = false --不需要滑动DLC地图面板
				--end
				
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
				
				--模拟按下事件
				--检测是否点到了某些控件里
				for i = 1, current_DLCMap_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					if ctrli then
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						
						--检测是否点到了私聊添加好友邀请的接受按钮
						local ctrlI = ctrli.childUI["btnAccept"]
						if ctrlI then
							if (ctrlI.data.state == 1) then --按钮可点状态
								local bcx = ctrlI.data.x --中心点x坐标
								local bcy = ctrlI.data.y --中心点y坐标
								local bcw, bch = ctrlI.data.w, ctrlI.data.h
								local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
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
									ctrlI.handle._n:stopAllActions()
									ctrlI.handle._n:runAction(sequence)
								end
							end
						end
						
						--检测是否点到了私聊添加好友邀请的拒绝按钮
						local ctrlI = ctrli.childUI["btnRefuse"]
						if ctrlI then
							if (ctrlI.data.state == 1) then --按钮可点状态
								local bcx = ctrlI.data.x --中心点x坐标
								local bcy = ctrlI.data.y --中心点y坐标
								local bcw, bch = ctrlI.data.w, ctrlI.data.h
								local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
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
									ctrlI.handle._n:stopAllActions()
									ctrlI.handle._n:runAction(sequence)
								end
							end
						end
					end
				end
				
				--在滑动过程中才会处理滑动
				if click_scroll_dlcmapinfo then
					--显示滚动条
					--_frmNode.childUI["ScrollBar"]:setstate(1)
					onShowScrollBarHint()
					
					--更新滚动条的进度(私聊)
					local progressMax = delta1_ly - deltNa_ry
					local progressNow = delta1_ly
					local height = _frmNode.childUI["ScrollBar"].data.w - _frmNode.childUI["ScrollBarProgress"].data.h --h
					local scrollX = _frmNode.childUI["ScrollBarProgress"].data.x
					local scrollY = _frmNode.childUI["ScrollBar"].data.y + (1 - progressNow / progressMax) * height - height / 2
					_frmNode.childUI["ScrollBarProgress"]:setXY(scrollX, scrollY)
				end
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--print("codeOnDrag", touchX, touchY, sus, draggle_speed_y_dlcmapinfo)
				
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
					
					--更新滚动条的进度(私聊)
					local progressMax = delta1_ly - deltNa_ry
					local progressNow = delta1_ly
					local height = _frmNode.childUI["ScrollBar"].data.w - _frmNode.childUI["ScrollBarProgress"].data.h --h
					local scrollX = _frmNode.childUI["ScrollBarProgress"].data.x
					local scrollY = _frmNode.childUI["ScrollBar"].data.y + (1 - progressNow / progressMax) * height - height / 2
					_frmNode.childUI["ScrollBarProgress"]:setXY(scrollX, scrollY)
				end
				
				--存储本次的位置
				last_click_pos_y_dlcmapinfo = touchX
				last_click_pos_y_dlcmapinfo = touchY
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_dlcmapinfo then
					--if (touchX ~= click_pos_x_dlcmapinfo) or (touchY ~= click_pos_y_dlcmapinfo) then --不是点击事件
						b_need_auto_fixing_dlcmapinfo = true
						friction_dlcmapinfo = 0
						friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
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
							friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
							draggle_speed_y_dlcmapinfo = MAX_SPEED / 1.0 --正速度 --速度一般大
							
							return
						end
					end
				end
				
				--是否选中某个私聊邀请的操作按钮
				local inviteFlag = hVar.PRIVATE_INVITE_TYPE.NONE --操作结果
				local selectTipIdx = 0
				local selectTipIdxIcon = 0
				for i = 1, current_DLCMap_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					if ctrli then
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						local cw, ch = ctrli.data.w, ctrli.data.h
						local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
						local rx, ry = lx + cw, ly + ch --最右下角坐标
						--print(i, cx, cy)
						
						--检测是否点到了私聊添加好友邀请的接受按钮
						local ctrlI = ctrli.childUI["btnAccept"]
						if ctrlI then
							if (ctrlI.data.state == 1) then --按钮可点状态
								local bcx = ctrlI.data.x --中心点x坐标
								local bcy = ctrlI.data.y --中心点y坐标
								local bcw, bch = ctrlI.data.w, ctrlI.data.h
								local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
								local brx, bry = blx + bcw, bly + bch --最右下角坐标
								--print(i, lx, rx, ly, ry, touchX, touchY)
								if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
									selectTipIdx = i
									inviteFlag = hVar.PRIVATE_INVITE_TYPE.ACCEPT --通过
								end
							end
						end
						
						--检测是否点到了私聊添加好友邀请的拒绝按钮
						local ctrlI = ctrli.childUI["btnRefuse"]
						if ctrlI then
							if (ctrlI.data.state == 1) then --按钮可点状态
								local bcx = ctrlI.data.x --中心点x坐标
								local bcy = ctrlI.data.y --中心点y坐标
								local bcw, bch = ctrlI.data.w, ctrlI.data.h
								local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
								local brx, bry = blx + bcw, bly + bch --最右下角坐标
								--print(i, lx, rx, ly, ry, touchX, touchY)
								if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
									selectTipIdx = i
									inviteFlag = hVar.PRIVATE_INVITE_TYPE.REFUSE --拒绝
								end
							end
						end
						
						--检测是否点到了头像
						local ctrlI = ctrli.childUI["roleIcon"]
						if ctrlI then
							local bcx = ctrlI.data.x --中心点x坐标
							local bcy = ctrlI.data.y --中心点y坐标
							local bcw, bch = ctrlI.data.w + 20, ctrlI.data.h + 20 --点击区域大一些
							local blx, bly = cx + bcx - bcw / 2, cy  + bcy - bch / 2 --最左上侧坐标
							local brx, bry = blx + bcw, bly + bch --最右下角坐标
							--print(i, bcx, bcy, bcw, bch)
							if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
								selectTipIdxIcon = i
								--print("点击头像" .. selectTipIdxIcon)
							end
						end
					end
				end
				
				if (click_scroll_dlcmapinfo) and (math.abs(touchY - click_pos_y_dlcmapinfo) > 42) then
					selectTipIdx = 0
					selectTipIdxIcon = 0
				end
				
				--点击到某个档位的奖励控件之内(私聊)
				if (selectTipIdx > 0) then
					--弹出操作界面
					--print(selectTipIdx, inviteFlag)
					
					--点击私聊验证按钮
					OnClickPrivateInviteBtn(selectTipIdx, inviteFlag)
				end
				
				--点击到某个档位的奖励控件之内(私聊头像)
				if (selectTipIdxIcon > 0) then
					--弹出操作界面
					--print(selectTipIdxIcon)
					local ctrlI = _frmNode.childUI["DLCMapInfoNode" .. selectTipIdxIcon]
					if ctrlI then
						if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
							--创建消息互动操作界面tip
							OnCreateChatDialogueTip(selectTipIdxIcon)
						end
					end
				end
				
				--标记不用滑动
				click_scroll_dlcmapinfo = false
			end,
		})
		_frmNode.childUI["DragPanelPrivate"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DragPanelPrivate"
		
		--滑动条(私聊)
		_frmNode.childUI["ScrollBar"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/rank_line.png", --"UI:vipline", --"misc/chest/herodetailattr.png",
			x = pg_offX + pg_width / 2 - 8.5, --pg_offX + pg_width / 2 - 7,
			y = pg_offY - 90 + 6, --pg_offY - 90 + 10,--pg_offY - 90,
			h = 4,
			w = pg_height - 6 - 195,
		})
		_frmNode.childUI["ScrollBar"].handle._n:setRotation(90)
		_frmNode.childUI["ScrollBar"].handle.s:setOpacity(0)
		_frmNode.childUI["ScrollBar"]:setstate(-1) --默认隐藏
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ScrollBar"
		--滚动进度
		_frmNode.childUI["ScrollBarProgress"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/scrollBtn.png",	--"UI:scrollBtn",
			x = pg_offX + pg_width / 2 - 8.5,
			y = pg_offY - 10, --pg_offY,
			w = 10,
			h = 22,
		})
		_frmNode.childUI["ScrollBarProgress"].handle.s:setOpacity(0)
		_frmNode.childUI["ScrollBarProgress"]:setstate(-1) --默认隐藏
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ScrollBarProgress"
		
		--物品背景图
		--九宫格--略小
		--local s91 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bottom9g.png", 0, -90, pg_width-2, pg_height - 180, _frmNode.childUI["DragPanelPrivate"])
		--s9:setColor(ccc3(255, 255, 255))
		--s9:setOpacity(128)
		--local s92 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bottom9s.png", 0, 0, pg_width-2, pg_height, _frmNode.childUI["DragPanelPrivate"])
		local s91 = hApi.CCScale9SpriteCreate("data/image/misc/treasure/medal_content.png", 0, 6, pg_width - 20, pg_height - 20, _frmNode.childUI["DragPanelPrivate"])
		
		--正在私聊的好友的提示界面
		_frmNode.childUI["DLCMapInfoNowFriendBG"] = hUI.button:new({ --作为按钮是为了挂载子控件
			--parent = _parentNode,
			parent = _BTC_pClipNodePrivate,
			model = -1,
			x = pg_offX,
			y = -206,
			z = 100,
			w = 1,
			h = 1,
		})
		_frmNode.childUI["DLCMapInfoNowFriendBG"].handle._n:setVisible(false) --默认不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoNowFriendBG"
		--九宫格图片
		local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_9s_2.png", 0, 0, pg_width, 44, _frmNode.childUI["DLCMapInfoNowFriendBG"])
		--s9:setColor(ccc3(255, 255, 255))
		
		--正在私聊的好友的文字提示
		_frmNode.childUI["DLCMapInfoNowFriendLabel"] = hUI.label:new({
			--parent = _parentNode,
			parent = _BTC_pClipNodePrivate,
			x = pg_offX,
			y = -206 - 1, --文字有1像素的偏差
			z = 100,
			font = hVar.FONTC,
			align = "MC",
			size = 24,
			width = 500,
			text = string.format(hVar.tab_string["__TEXT_PrivateChatting"], ""), --"与xxxx聊天中..."
			--RGB = {255, 255, 255,},
		})
		_frmNode.childUI["DLCMapInfoNowFriendLabel"].handle._n:setVisible(false) --默认不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoNowFriendLabel"
		
		--正在私聊的好友的关闭按钮(私聊)
		_frmNode.childUI["DLCMapInfoNowFriendCloseBtn"] = hUI.button:new({
			--parent = _parentNode,
			parent = _BTC_pClipNodePrivate,
			model = "misc/chest/chatsend.png",
			dragbox = _frm.childUI["dragBox"],
			x = pg_offX  - 10 + BOARD_WIDTH / 2 - 120 / 2,
			label = {text = hVar.tab_string["__TEXT_Close"], size = 26, font = hVar.FONTC, border = 1, x = 0, y = 1.5, RGB = {255, 255, 255,},}, --"关闭"
			y = -207,
			z = 100,
			w = 110,
			h = 48,
			align = "MC",
			scaleT = 0.95,
			code = function()
				--点击关闭私聊好友按钮
				OnClickDeleteInviteBtn(current_msg_private_friend_last_uid)
			end,
		})
		_frmNode.childUI["DLCMapInfoNowFriendCloseBtn"]:setstate(-1) --默认不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoNowFriendCloseBtn"
		
		--用于遮挡私聊上半部分区域的图片
		_frmNode.childUI["DLCMapInfoNowFriendCoverImgBG"] = hUI.image:new({
			--parent = _parentNode,
			parent = _BTC_pClipNodePrivate,
			model = "misc/chest/bottom9g.png",
			dragbox = _frm.childUI["dragBox"],
			x = pg_offX,
			y = -150 - 2,	---150,
			z = 99,
			w = pg_width - 20,--pg_width,
			h = 180,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoNowFriendCoverImgBG"
		
		--删除之前可能的输入框
		if current_enterNameEditBox then
			_frmNode.handle._n:removeChild(current_enterNameEditBox, true)
			current_enterNameEditBox = nil
		end
		
		--绘制输入框
		--输入框
		local enterNameEditBox = nil
		local rgName = "" --输入的内容
		local editNameBoxTextEventHandle = function(strEventName, pSender)
			--local edit = tolua.cast(pSender, "CCEditBox") 
			--防止输入框被删除，触发回调安卓闪退
			if (current_enterNameEditBox ~= nil) then 
				if (strEventName == "began") then
					--
				elseif (strEventName == "changed") then --改变事件
					--
				elseif (strEventName == "ended") then
					rgName = enterNameEditBox:getText()
					
					--首次输入完文字后，查询称号
					if (not current_IsQueryChampion) then --是否查询过称号（因为称号有有效期，每次打开聊天，在首次输入文字后查询一次称号）
						--标记本次打开聊天界面已查询过称号
						current_IsQueryChampion = true
						
						--发起查询玩家称号
						SendCmdFunc["require_query_champion"]()
					end
				elseif (strEventName == "return") then
					--
				end
			end
			--print("editNameBoxTextEventHandle", strEventName, rgName)
			--xlLG("editbox", tostring(strEventName) .. ", rgName=" .. tostring(rgName) .. "\n")
		end
		
		--为了让输入文字比输入框稍微小些，这里输入框背景单独创建
		--输入框背景图
		--hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_grayyellow_light.png", -68, -pg_offY-hVar.SCREEN.h + 64 - 18, pg_width - 130, 64, _frmNode.childUI["DragPanelPrivate"])
		--hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_grayyellow_light.png", -68, -pg_offY-CHAT_BOARD_HEIGHT + 54 - 18, pg_width - 130, 64, _frmNode.childUI["DragPanelPrivate"])
		hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_grayyellow_light.png", -73, -pg_offY-CHAT_BOARD_HEIGHT + 54 - 12, pg_width - 160, 64, _frmNode.childUI["DragPanelPrivate"])
		local SMALL_LENGTH = 8
		enterNameEditBox = CCEditBox:create(CCSizeMake(pg_width - 160-SMALL_LENGTH*2, 64-SMALL_LENGTH), CCScale9Sprite:create("data/image/misc/button_null.png"))--"data/image/misc/win_back.png""data/image/misc/1xs.png"
		--enterNameEditBox:setPosition(ccp(-68 + _frmNode.childUI["DragPanelPrivate"].data.x, -pg_offY-CHAT_BOARD_HEIGHT + 54 - 18 + _frmNode.childUI["DragPanelPrivate"].data.y+SMALL_LENGTH/8))
		enterNameEditBox:setPosition(ccp(-73 + _frmNode.childUI["DragPanelPrivate"].data.x, -pg_offY-CHAT_BOARD_HEIGHT + 54 - 12 + _frmNode.childUI["DragPanelPrivate"].data.y+SMALL_LENGTH/8))
		--enterNameEditBox:setFontName("Sketch Rockwell.ttf")
		enterNameEditBox:setFontSize(28)
		enterNameEditBox:setFontColor(ccc3(0, 0, 0))
		enterNameEditBox:setPlaceHolder(hVar.tab_string["__TEXT_TypeLetter"]) --"输入文字"
		enterNameEditBox:setPlaceholderFontColor(ccc3(128, 128, 128)) --默认显示文字颜色
		enterNameEditBox:setMaxLength(48) --最大支持字符数
		enterNameEditBox:registerScriptEditBoxHandler(editNameBoxTextEventHandle)
		enterNameEditBox:setTouchPriority(0)
		enterNameEditBox:setReturnType(kKeyboardReturnTypeDone)
		--_frmNode.childUI["DragPanelPrivate"].handle._n:addChild(enterNameEditBox)
		_frmNode.handle._n:addChild(enterNameEditBox)
		
		--存储输入框指针
		current_enterNameEditBox = enterNameEditBox
		
		--发送按钮(私聊)
		_frmNode.childUI["btnSendMessagePrivate"] = hUI.button:new({
			parent = _parentNode,
			x = pg_offX + pg_width / 2 - 130 / 2 - 1 - 15,	--pg_offX + pg_width /2 - 130 / 2 - 1,
			y = -hVar.SCREEN.h + 2 * iPhoneX_HEIGHT + 43, 	---hVar.SCREEN.h + 2 * iPhoneX_HEIGHT + 46, ---hVar.SCREEN.h + 46,
			model = "misc/chest/chatsend.png",
			align = "MC",
			dragbox = _frm.childUI["dragBox"],
			w = 134,
			h = 56,
			scaleT = 0.95,
			code = function()
				--如果未连接socket工会服务器，不能操作
				if (Group_Server:GetState() ~= 1) then --未连接
					--冒字
					--local strText = "不能连接到网络" --language
					local strText = hVar.tab_string["ios_err_network_cannot_conn"] --language
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
				
				--如果未登入工会服务器，不能操作
				if (Group_Server:getonline() ~= 1) then --未登入
					--冒字
					--local strText = "不能连接到网络" --language
					local strText = hVar.tab_string["ios_err_network_cannot_conn"] --language
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
				
				--如果当前没有私聊的目标不能发送
				if (current_msg_private_friend_last_uid == 0) then
					--冒字
					--local strText = "没有私聊发送目标！" --language
					local strText = hVar.tab_string["ios_err_network_cannot_chat_private_target"] --language
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
				
				--被禁言不能发送消息
				if (current_msgForbidden == 1) then
					--计算禁言剩余时间
					local localTime = os.time() --客户端的时间(本地时区)
					--服务器的时间(本地时区)
					local hostTimeNow = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
					--禁言开始的时间(本地时区)
					local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
					local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
					local forbiddenBeginTime = hApi.GetNewDate(current_msgForbiddenTime) + delteZone * 3600 --服务器时间(本地时区)
					--剩余时间
					local forbiddenLeft = hostTimeNow - forbiddenBeginTime
					local minuteLeft = current_msgForbidden_minute - math.floor(forbiddenLeft / 60)
					if (minuteLeft > 0) then
						--冒字
						--local strText = "您被禁言，" .. minuteLeft .. "分钟后才能发送消息！" --language
						local strText = string.format(hVar.tab_string["ios_err_network_cannot_chat_forbidden"], minuteLeft) --language
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
				end
				
				--geyachao: windows版，接收不到输入框的ended事件，只能在点击按钮的时候，取一下输入的文本
				local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
				if (g_tTargetPlatform.kTargetWindows == TargetPlatform) then --windows版
					rgName = enterNameEditBox:getText()
				end
				
				--检测文字是否纯为空格
				if (rgName ~= "") then
					local bAllBlank = true
					for i = 1, #rgName, 1 do
						local s = string.sub(rgName, i, i)
						if (s ~= " ") then
							bAllBlank = false
							break
						end
					end
					if bAllBlank then
						--冒字
						--local strText = "聊天内容不能为空" --language
						local strText = hVar.tab_string["ios_chat_not_empty"] --language
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
				end
				
				--检测输入的文字是否过长
				local nLength = hApi.GetStringEmojiENLength(rgName) --英文长度
				if (nLength > 96) then
					--冒字
					--local strText = "您输入的内容过长" --language
					local strText = hVar.tab_string["ios_chat_too_long"] --language
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
				
				--处理文字(私聊)
				local message = rgName
				
				--去除特殊符号
				local origin = {"%(", "%)", "%.", "%%", "%+", "%-", "%*", "%?", "%[", "%]", "%^", "%$", ";", "/", "\\", "|", ":", ",", "'",}
				local replace = {"（", "）", "·", "％", "＋", "－", "＊", "？", "【", "】", "∧", "＄", "；", "╱", "╲", "│", "：", "，", "‘",}
				for i = 1, #origin, 1 do
					local originChar = origin[i]
					local replaceChar = replace[i]
					--print(i, originChar, replaceChar)
					while true do
						--print(message)
						local pos = string.find(message, originChar)
						--print(pos)
						if (pos ~= nil) then
							if (pos < #message) then --不是最后一个字符
								message = string.sub(message, 1, pos - 1) .. replaceChar .. string.sub(message, pos + 1, #message)
							else --最后一个字符
								message = string.sub(message, 1, pos - 1) .. replaceChar
							end
						else
							break
						end
					end
				end
				
				--去除回车等控制字符
				string.gsub(message, "%c", "")
				
				--去除屏蔽字
				local MESSAGE = string.upper(message) --大写(用于匹配)
				local GLOBAL_FILTER_TEXT = hVar.tab_filtertext
				for i = #GLOBAL_FILTER_TEXT, 1, -1 do
					local strFilter = GLOBAL_FILTER_TEXT[i]
					local nLength = hApi.GetStringEmojiENLength(strFilter, 1, 1) --Unicode长度
					while true do
						local pos = string.find(MESSAGE, strFilter)
						if (pos ~= nil) then
							local strRep = string.rep("*", nLength)
							--message = string.gsub(message, strFilter, strRep)
							if ((pos + #strFilter - 1) < #message) then --不是最后一个字符
								message = string.sub(message, 1, pos - 1) .. strRep .. string.sub(message, (pos + #strFilter - 1) + 1, #message)
							else --最后一个字符
								message = string.sub(message, 1, pos - 1) .. strRep
							end
							
							MESSAGE = string.upper(message) --大写(用于匹配)
						else
							break
						end
					end
				end
				
				--最后转小写
				--message = string.lower(message)
				
				--清空文字
				rgName = ""
				enterNameEditBox:setText("")
				
				--检测是否刷屏
				if (LuaCheckChatMessageIsFloodScreen(g_curPlayerName, current_chat_type, message) == 1) then
					--冒字
					--local strText = "您的聊天内容在短时间内已重复多次，不能发送" --language
					local strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_FLOOD_SCREEN"] --language
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
				
				--检测是否发言过快
				if (LuaCheckChatMessageIsTooFast(g_curPlayerName, current_chat_type, message) == 1) then
					--冒字
					--local strText = "您的聊天频率在短时间内过快，不能发送" --language
					local strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_TOO_FAST"] --language
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
				
				if (message ~= "") then
					--[[
					--测试 --test
					message = "一二三四五六七八九十一二三四五六七八九十"
					]]
					
					--请求发送消息（私聊）
					local msgType = hVar.MESSAGE_TYPE.TEXT --文本消息
					local touid = current_msg_private_friend_last_uid
					--print(current_chat_type, msgType, message, touid)
					SendGroupCmdFunc["chat_send_message"](current_chat_type, msgType, message, touid)
					
					--本地添加一条发送消息记录（防刷屏）
					LuaAddtRecentChatMsg(g_curPlayerName, current_chat_type, message)
				end
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnSendMessagePrivate"
		--发送按钮的文字"发送"(私聊)
		_frmNode.childUI["btnSendMessagePrivate"].childUI["sendNoLimit"] = hUI.label:new({
			parent = _frmNode.childUI["btnSendMessagePrivate"].handle._n,
			x = -4,
			y = 1,---1,
			align = "MC",
			font = hVar.FONTC,
			size = 28,
			text = hVar.tab_string["__TEXT_SEND"], --"发送"
			border = 1,
			--RGB = {255, 255, 0,},
		})
		
		--检测私聊好友列表控件(私聊好友列表)
		_frmNode.childUI["DragPanelPrivateFriend"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = pg_offX,
			y = -124,
			w = pg_width,
			h = 128,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--print("codeOnTouch", touchX, touchY, sus)
				click_pos_x_friendinfo = touchX --开始按下的坐标x
				click_pos_y_friendinfo = touchY --开始按下的坐标y
				last_click_pos_x_friendinfo = touchX --上一次按下的坐标x
				last_click_pos_y_friendinfo = touchY --上一次按下的坐标y
				draggle_speed_x_friendinfo = 0 --当前x速度为0
				selected_friendinfoEx_idx = 0 --选中的DLC地图面板ex索引
				click_scroll_friendinfo = true --是否滑动DLC地图面板
				b_need_auto_fixing_friendinfo = false --不需要自动修正位置
				friction_friendinfo = 0 --无阻力
				friction_friendinfo_coefficient = 0.5 --衰减系数(默认值)
				
				--如果DLC地图面板数量未铺满一页，那么不需要滑动
				--if (current_DLCMap_max_num <= (WEAPON_X_NUM * WEAPON_Y_NUM)) then
				--	click_scroll_friendinfo = false --不需要滑动DLC地图面板
				--end
				
				--检测是否滑动到了最顶部或最底部
				local delta1_lx = 0 --第一个DLC地图面板最上侧的y坐标
				local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
				delta1_lx, deltNa_rx = getLeftRightOffset()
				--print(delta1_lx, deltNa_rx)
				--delta1_lx +:在左底线之右 /-:在左底线之左
				--deltNa_rx +:在右底线之右 /-:在右底线之左
				
				--print("click_scroll_friendinfo=", click_scroll_friendinfo)
				
				--不满一页
				--左面对其左顶线，右面在在右底线之左
				if (delta1_lx == 0) and (deltNa_rx <= 0) then
					click_scroll_friendinfo = false --不需要滑动DLC地图面板
				end
				
				--模拟按下事件
				--检测是否点到了某些控件里
				for i = 1, current_DLCMap_friend_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNodeFriend" .. i]
					if ctrli then
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						
						--[[
						--检测是否点到了领奖按钮
						local ctrlI = ctrli.childUI["rewardBtn"]
						if ctrlI then
							if (ctrlI.data.state == 1) then --按钮可点状态
								local bcx = ctrlI.data.x --中心点x坐标
								local bcy = ctrlI.data.y --中心点y坐标
								local bcw, bch = ctrlI.data.w, ctrlI.data.h
								local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
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
									ctrlI.handle._n:stopAllActions()
									ctrlI.handle._n:runAction(sequence)
								end
							end
						end
						]]
					end
				end
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--print("codeOnDrag", touchX, touchY, sus, draggle_speed_x_friendinfo)
				
				--处理移动速度y
				draggle_speed_x_friendinfo = touchX - last_click_pos_x_friendinfo
				
				if (draggle_speed_x_friendinfo > MAX_SPEED) then
					draggle_speed_x_friendinfo = MAX_SPEED
				end
				if (draggle_speed_x_friendinfo < -MAX_SPEED) then
					draggle_speed_x_friendinfo = -MAX_SPEED
				end
				
				--检测是否滑动到了最顶部或最底部
				local delta1_lx = 0 --第一个DLC地图面板最左侧的x坐标
				local deltNa_rx = 0 --最后一个DLC地图面板最右侧的x坐标
				delta1_lx, deltNa_rx = getLeftRightOffset()
				--print(delta1_lx, deltNa_rx)
				--delta1_lx +:在左底线之右 /-:在左底线之左
				--deltNa_rx +:在右底线之右 /-:在右底线之左
				
				--print("click_scroll_friendinfo=", click_scroll_friendinfo)
				--在滑动过程中才会处理滑动
				if click_scroll_friendinfo then
					local deltaX = touchX - last_click_pos_x_friendinfo --与开始按下的位置的偏移值x
					--在滚动，标记未下拉到底部
					--current_in_scroll_down = false
					
					--第一个DLC地图面板的坐标不能跑到最左侧的右边去
					if ((delta1_lx + deltaX) >= 0) then --防止走过
						deltaX = -delta1_lx
						delta1_lx = 0
						
						--没有惯性
						draggle_speed_x_friendinfo = 0
						
						--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --上分翻页提示
					else
						--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(true) --上分翻页提示
					end
					
					--最后一个DLC地图面板的坐标不能跑到最右侧的左边去
					if ((deltNa_rx + deltaX) <= 0) then --防止走过
						deltaX = -deltNa_rx
						deltNa_rx = 0
						
						--没有惯性
						draggle_speed_x_friendinfo = 0
						
						--已到底部，标记下拉到底部（为true时有新消息自动滚到最下端）
						--current_in_scroll_down = true
						--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --下分翻页提示
						--已拉到底，删除新消息提示
						--onRemoveNewMessageHint()
					else
						--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下分翻页提示
					end
					
					for i = 1, current_DLCMap_friend_max_num, 1 do
						local ctrli = _frmNode.childUI["DLCMapInfoNodeFriend" .. i]
						--print(i)
						ctrli.handle._n:setPosition(ctrli.data.x + deltaX, ctrli.data.y)
						ctrli.data.x = ctrli.data.x + deltaX
						ctrli.data.y = ctrli.data.y
					end
				end
				
				--存储本次的位置
				last_click_pos_x_friendinfo = touchX
				last_click_pos_y_friendinfo = touchY
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_friendinfo then
					--if (touchX ~= click_pos_x_friendinfo) or (touchY ~= click_pos_y_friendinfo) then --不是点击事件
						b_need_auto_fixing_friendinfo = true
						friction_friendinfo = 0
						friction_friendinfo_coefficient = 0.5 --衰减系数(默认值)
					--end
				end
				
				--是否选中某个聊天消息的头像区域
				local selectTipIdx = 0
				for i = 1, current_DLCMap_friend_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNodeFriend" .. i]
					if ctrli then
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						local cw, ch = ctrli.data.w, ctrli.data.h
						local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
						local rx, ry = lx + cw, ly + ch --最右下角坐标
						--print(i, cx, cy)
						
						--检测是否点到了头像
						if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
							selectTipIdx = i
						end
					end
				end
				
				if (click_scroll_friendinfo) and (math.abs(touchX - click_pos_x_friendinfo) > 48) then
					selectTipIdx = 0
				end
				
				--点击到某个档位的奖励控件之内
				if (selectTipIdx > 0) then
					--不重复点击同一个好友
					local ctrlI = _frmNode.childUI["DLCMapInfoNodeFriend" .. selectTipIdx]
					if (ctrlI.data.selected == 0) then
						--选中了某个私聊好友头像
						--print(selectTipIdx)
						--OnSelectedPrivateFriend(selectTipIdx)
						
						--添加查询超时一次性timer
						hApi.addTimerOnce("__ONCE_CHAT_TIMEOUNT_TIMER__", 5000, refresh_chatnet_timeout_timer)
						
						--请求查询与此好友的聊天id列表
						local friendUid = ctrlI.data.touid
						SendGroupCmdFunc["chat_get_id_list"](current_chat_type, friendUid)
					end
				end
				
				--标记不用滑动
				click_scroll_friendinfo = false
			end,
		})
		_frmNode.childUI["DragPanelPrivateFriend"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DragPanelPrivateFriend"
		
		--查询的菊花
		_frmNode.childUI["waiting"] = hUI.button:new({ --作为按钮是为了挂载子控件
			parent = _BTC_pClipNodePrivate,
			x = _BTC_PageClippingRectWorld[1] + _BTC_PageClippingRectWorld[3]/2,
			y = _BTC_PageClippingRectWorld[2] - _BTC_PageClippingRectWorld[4]/2,
			z = 1,
			--label = {x = 0, y = -1, align = "MC", font = hVar.FONTC, size = 24, text = "重新连接", border = 1,},
			--model = "UI:PANEL_MENU_BTN_BIG", --"UI:SkillSlot",
			model = "misc/mask_white.png",
			--dragbox = _frm.childUI["dragBox"],
			w = 310,
			h = 120,
			--scaleT = 0.95,
			--code = function()
			--
			--end,
		})
		_frmNode.childUI["waiting"].handle.s:setColor(ccc3(128, 128, 128))
		_frmNode.childUI["waiting"].handle.s:setOpacity(64)
		_frmNode.childUI["waiting"]:setstate(-1) --默认隐藏
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "waiting"
		--查询的文字
		_frmNode.childUI["waiting"].childUI["text"] = hUI.label:new({
			parent = _frmNode.childUI["waiting"].handle._n,
			x = 0,
			y = 0,
			font = hVar.FONTC,
			align = "MC",
			size = 20,
			width = 500,
			text = "", --"正在连接中..."
			RGB = {212, 212, 212,},
		})
		
		--添加监听
		--添加移除事件监听：横竖屏切换
 		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenAchievement_", on_spine_screen_event)
		--添加事件监听：收到工会服务器socket连接结果回调
		hGlobal.event:listen("LocalEvent_Group_NetEvent", "__GroupServerConnectBack_", on_receive_grouperver_connect_back_event)
		--添加事件监听：收到工会服务器登陆结果回调
		hGlobal.event:listen("LocalEvent_Group_LogEvent", "__GroupServerLoginBack_", on_receive_group_server_login_back_event)
		--添加事件监听：收到聊天模块初始化事件
		hGlobal.event:listen("LocalEvent_Group_ChatInitEvent", "__GroupServerChatInitBack_", on_receive_chat_init_event)
		--添加事件监听：收到聊天消息id事件
		hGlobal.event:listen("LocalEvent_Group_ChatIDListEvent", "__GroupServerChatIDListBack_", on_receive_chat_id_list_event)
		--添加事件监听：收到聊天消息内容事件
		hGlobal.event:listen("LocalEvent_Group_ChatContentListEvent", "__GroupServerChatContentListBack_", on_receive_chat_content_list_event)
		--添加事件监听：收到单条聊天消息事件
		hGlobal.event:listen("LocalEvent_Group_SingleChatMessageEvent", "__SingleChatMessageBack_", on_receive_single_chat_message_event)
		--添加事件监听：收到更新单条聊天消息事件
		hGlobal.event:listen("LocalEvent_Group_UpdatChatMessageEvent", "__UpdateChatMessageBack_", on_receive_update_chat_message_event)
		--添加事件监听：收到删除聊天消息事件
		hGlobal.event:listen("LocalEvent_Group_RemoveChatMessageEvent", "__RemoveChatMessageBack_", on_receive_remove_chat_message_event)
		--添加事件监听：收到被禁言的通知事件
		hGlobal.event:listen("LocalEvent_Group_ChatForbiddenEvent", "__ChatForbiddenBack_", on_receive_chat_forbidden_event)
		--添加事件监听：收到发起私聊请求的结果返回
		hGlobal.event:listen("LocalEvent_Group_PrivateInviteChatEvent", "__ChatPrivateInviteBack_", on_receive_chat_private_invite_event)
		--添加事件监听：收到工会操作结果返回
		hGlobal.event:listen("LocalEvent_Group_OperationRet", "__GroupOperationRetBack_", on_receive_group_result_event)
		--添加事件监听：收到加入军团邀请函结果返回
		hGlobal.event:listen("localEvent_GroupInviteJoinBack", "__GroupInviteRetBack_", on_receive_group_invite_back_event)
		--添加监听：程序进入后台的回调
		hGlobal.event:listen("LocalEvent_AppEnterBackground", "__ChatMessageBack_", on_app_enter_background_event)
		--添加监听：游戏局结束事件
		hGlobal.event:listen("LocalEvent_GameOver", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（夺塔奇兵）
		hGlobal.event:listen("LocalEvent_GameOver_PVP", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（魔龙宝库）
		hGlobal.event:listen("LocalEvent_GameOver_PVP_Endless", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（铜雀台）
		hGlobal.event:listen("LocalEvent_GameOver_PVP_Endless_Singlebattle", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（新手地图）
		hGlobal.event:listen("LocalEvent_GameOver_NewGuideMap", "__ChatGameEnd_", on_game_end_event)
		--添加监听：PVP等待其他玩家事件
		hGlobal.event:listen("LocalEvent_Pvp_Delay_Player", "__ChatPVPWaitPlayer_", on_pvp_wait_player_event)
		--添加监听：PVP本地长时间未响应事件
		hGlobal.event:listen("LocalEvent_Pvp_LocalNoHeart", "__ChatPVPLocalNoHeart_", on_pvp_local_noheart_event)
		--添加监听：安卓本地掉线事件
		hGlobal.event:listen("LocalEvent_showAndroidNetAlreadyFrm", "__ChatAndroidDisconnect_", on_android_local_disconnect_event)
		--添加事件监听：切换剧情地图场景事件
		hGlobal.event:listen("LocalEvent_Battle_SwitchGame", "__BattleSwitchGameBack_chat2", on_game_end_event)
		--添加事件监听：切换pvp场景事件
		hGlobal.event:listen("LocalEvent_Pvp_SwitchGame", "__PVPSwitchGameBack_chat2", on_game_end_event)
		--添加事件监听：切换pvp匹配房场景事件
		hGlobal.event:listen("LocalEvent_Pvp_Match_SwitchGame", "__MatchSwitchGameBack_chat2", on_game_end_event)
		
		--私聊
		--添加监听：收到增加单个私聊好友
		hGlobal.event:listen("LocalEvent_Group_PrivateFriendAddEvent", "__ChatPrivateFriendAddBack_", on_add_private_friend_event)
		--添加监听：收到删除单个私聊好友
		hGlobal.event:listen("LocalEvent_Group_PrivateFriendRemoveEvent", "__ChatPrivateFriendRemoveBack_", on_remove_private_friend_event)
		
		--刷新滚动的timer（私聊消息）
		hApi.addTimerForever("__CHATFRAME_PRIVATE_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_chatframe_scroll_private_loop) --私聊频道
		hApi.addTimerForever("__CHATFRAME_WORLD_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_chatframe_scroll_world_loop)
		--刷新红包领取倒计时的timer
		hApi.addTimerForever("__CHATFRAME_REDPACKET_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 1000, refresh_chat_redpacket_loop)
		--自动连接工会服务器的timer
		hApi.addTimerForever("__CHATAUTOLINK_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 5000, refresh_chatframe_autolink_loop)
		--异步绘制聊天消息的timer
		hApi.addTimerForever("__CHATPAINT_MESSAGE_ASYNC__", hVar.TIMER_MODE.GAMETIME, 1, refresh_async_paint_message_loop)
		
		--[[
		--测试 --test
		--发起查询，1元档商品信息
		--SendCmdFunc["iap_sale_gift"]()
		--依次绘制每条消息
		local tChatMsgList =
		{
			{msgId = 1, name = "adidas先生", date = "00:00:01", content = "¡¡¡¡¡¡¡¡¡¡",},
			{msgId = 1, name = "游客", date = "10:03:23", content = "||||||||||",},
			{msgId = 1, name = "游客21000001", date = "12:00:59", content = "}}}}}}}}}}",},
			{msgId = 1, name = "GUEST", date = "13:07:23", content = "^^^^^^^^^^",},
			{msgId = 1, name = "diaoxian", date = "14:23:00", content = "\\\\\\\\\\\\\\\\\\\\",},
			{msgId = 1, name = "u123123", date = "15:46:33", content = "~~~~~~~~~~",},
			{msgId = 1, name = "我是你的发", date = "16:54:47", content = "``````````",},
			{msgId = 1, name = "爱情", date = "18:03:09", content = "爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了",},
			{msgId = 1, name = "掉线", date = "20:33:12", content = ">>>>>>>>>>",},
			{msgId = 1, name = "打老师345", date = "23:24:32", content = "加群 qq:19900000",},
		}
		current_DLCMap_max_num = #tChatMsgList
		--依次绘制消息
		for i = 1, 10, 1 do
			on_create_single_message_UI(tChatMsgList[i], i)
		end
		]]
		
		
		--[[
		--获得一个加速度，使右边自动往上滚动
		--超过一页的数量才滑屏
		if (current_DLCMap_max_num > (WEAPON_X_NUM * WEAPON_Y_NUM)) then
			--向上滚屏
			b_need_auto_fixing_dlcmapinfo = true
			friction_dlcmapinfo = 0
			friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
			draggle_speed_y_dlcmapinfo = MAX_SPEED / 1.0 --正速度
		end
		]]
		
		--挡操作
		--hUI.NetDisable(30000)
		
		--发起登入工会服务器操作
		--print("发起登入工会服务器操作")
		--print("发起登入工会服务器操作", Group_Server:GetState())
		if (Group_Server:GetState() == 1) then --不重复登入
			--模拟触发连接工会服务socket结果回调
			--print("模拟触发连接工会服务socket结果回调")
			on_receive_grouperver_connect_back_event(1)
		else
			--连接
			--print("Group_Server:Connect()")
			Group_Server:Connect()
		end
	end
	
	--!!!! edit by mj !!!!wait edit this func!!!! 2022.11.15
	--函数：创建军团聊天界面（第4个分页）
	OnCreateGroupChatInfoFrame = function(pageIdx)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--允许本分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNodeGroup", 1)
		
		--标记本分页的聊天频道(世界频道)
		current_chat_type = hVar.CHAT_TYPE.GROUP
		
		--初始化数据
		current_DLCMap_max_num = 0
		current_async_paint_list = {} --清空异步缓存待绘制内容
		current_DLCMap_friend_max_num = 0
		current_DLCMap_roomid = 0 --当前请求组队副本的房间消息id
		
		--统一处理聊天页的位置和大小
		local pg_offX = CHAT_INFO_FRM_POS_X 		--362
		local pg_offY = CHAT_INFO_FRM_POS_Y 		---hVar.SCREEN.h / 2 + 10
		local pg_width = BOARD_WIDTH - 10
		local pg_height = CHAT_INFO_FRM_POS_HEIGHT 	--hVar.SCREEN.h - 136
		
		--[[
		--左侧DLC地图包列表提示上翻页的图片
		_frmNode.childUI["DLCMapInfoPageUp"] = hUI.image:new({
			parent = _BTC_pClipNodeGroup,
			model = "misc/chest/tutorial_arrow_right.png", --"UI:PageBtn",
			x = pg_offX,
			y = pg_offY + 238,
			scale = 0.5,
			z = 500, --最前端显示
		})
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setRotation(-90)
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --默认不显示左上翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["DLCMapInfoPageUp"].handle._n:runAction(forever)
		
		--左侧DLC地图包列表提示下翻页的图片
		_frmNode.childUI["DLCMapInfoPageDown"] = hUI.image:new({
			parent = _BTC_pClipNodeGroup,
			model = "misc/chest/tutorial_arrow_right.png", --"UI:PageBtn",
			x = pg_offX,
			y = pg_offY - 238,
			scale = 0.5,
			z = 500, --最前端显示
		})
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setRotation(90)
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["DLCMapInfoPageDown"].handle._n:runAction(forever)
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --默认不显示下分翻页提示
		]]
		
		--[[
		--左侧向上翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["DLCMapInfoPageUp_Btn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = pg_offX,
			y = pg_offY + 182,
			w = 360,
			h = 60,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--超过一页的数量才滑屏
				if (current_DLCMap_max_num > (WEAPON_X_NUM * WEAPON_Y_NUM)) then
					--print("向下滚屏", screenY)
					--向下滚屏
					b_need_auto_fixing_dlcmapinfo = true
					friction_dlcmapinfo = 0
					friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
					draggle_speed_y_dlcmapinfo = -MAX_SPEED / 2.0 --负速度
				end
			end,
		})
		_frmNode.childUI["DLCMapInfoPageUp_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageUp_Btn"
		]]
		
		--[[
		--左侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["DLCMapInfoPageDown_Btn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = pg_offX,
			y = pg_offY - 182,
			w = 360,
			h = 60,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--超过一页的数量才滑屏
				if (current_DLCMap_max_num > (WEAPON_X_NUM * WEAPON_Y_NUM)) then
					--print("向上滚屏", screenY)
					--向上滚屏
					b_need_auto_fixing_dlcmapinfo = true
					friction_dlcmapinfo = 0
					friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
					draggle_speed_y_dlcmapinfo = MAX_SPEED / 2.0 --正速度
				end
			end,
		})
		_frmNode.childUI["DLCMapInfoPageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageDown_Btn"
		]]
		
		--获奖记录用于检测滑动事件的控件(军团聊天)
		_frmNode.childUI["DragPanelGroup"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = pg_offX,
			y = pg_offY,
			w = pg_width,
			h = pg_height,
			failcall = 1,
			
			--按下事件(军团聊天)
			codeOnTouch = function(self, touchX, touchY, sus)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
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
				friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
				
				--如果DLC地图面板数量未铺满一页，那么不需要滑动
				--if (current_DLCMap_max_num <= (WEAPON_X_NUM * WEAPON_Y_NUM)) then
				--	click_scroll_dlcmapinfo = false --不需要滑动DLC地图面板
				--end
				
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
				
				--模拟按下事件
				--检测是否点到了某些控件里(军团聊天)
				for i = 1, current_DLCMap_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					if ctrli then
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						
						--[[
						--检测是否点到了领奖按钮
						local ctrlI = ctrli.childUI["rewardBtn"]
						if ctrlI then
							if (ctrlI.data.state == 1) then --按钮可点状态
								local bcx = ctrlI.data.x --中心点x坐标
								local bcy = ctrlI.data.y --中心点y坐标
								local bcw, bch = ctrlI.data.w, ctrlI.data.h
								local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
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
									ctrlI.handle._n:stopAllActions()
									ctrlI.handle._n:runAction(sequence)
								end
							end
						end
						]]
					end
				end
				
				--在滑动过程中才会处理滑动
				if click_scroll_dlcmapinfo then
					--显示滚动条
					--_frmNode.childUI["ScrollBar"]:setstate(1)
					onShowScrollBarHint()
					
					--更新滚动条的进度(军团聊天)
					local progressMax = delta1_ly - deltNa_ry
					local progressNow = delta1_ly
					local height = _frmNode.childUI["ScrollBar"].data.w - _frmNode.childUI["ScrollBarProgress"].data.h --h
					local scrollX = _frmNode.childUI["ScrollBarProgress"].data.x
					local scrollY = _frmNode.childUI["ScrollBar"].data.y + (1 - progressNow / progressMax) * height - height / 2
					_frmNode.childUI["ScrollBarProgress"]:setXY(scrollX, scrollY)
				end
				
				--是否选中某个聊天消息的红包区域
				local selectTipIdxRedpacket = 0
				for i = 1, current_DLCMap_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					if ctrli then
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						local cw, ch = ctrli.data.w, ctrli.data.h
						local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
						local rx, ry = lx + cw, ly + ch --最右下角坐标
						--print(i, cx, cy)
						
						--检测是否点到了红包
						local ctrlI = ctrli.childUI["redPacket"]
						if ctrlI then
							local bcx = ctrlI.data.x --中心点x坐标
							local bcy = ctrlI.data.y --中心点y坐标
							local bcw, bch = ctrlI.data.w + 20, ctrlI.data.h + 20 --点击区域大一些
							local blx, bly = cx + bcx - bcw / 2, cy  + bcy - bch / 2 --最左上侧坐标
							local brx, bry = blx + bcw, bly + bch --最右下角坐标
							--print(i, bcx, bcy, bcw, bch)
							if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
								selectTipIdxRedpacket = i
								--print("点击按钮" .. selectTipIdxRedpacket)
							end
						end
					end
				end
				if (click_scroll_dlcmapinfo) and (math.abs(touchY - click_pos_y_dlcmapinfo) > 42) then
					selectTipIdxRedpacket = 0
				end
				--点击到某个档位的奖励控件之内
				if (selectTipIdxRedpacket > 0) then
					--弹出操作界面
					--print(selectTipIdxRedpacket)
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. selectTipIdxRedpacket]
					local ctrlI = ctrli.childUI["redPacketIcon"]
					if ctrlI then
						--缩小再放大
						local act1 = CCEaseSineIn:create(CCScaleTo:create(0.1, 0.95))
						local act2 = CCEaseSineOut:create(CCScaleTo:create(0.1, 1.0))
						local a = CCArray:create()
						a:addObject(act1)
						a:addObject(act2)
						local sequence = CCSequence:create(a)
						ctrlI.handle._n:stopAllActions()
						ctrlI.handle._n:runAction(sequence)
					end
				end
			end,
			
			--滑动事件(军团聊天)
			codeOnDrag = function(self, touchX, touchY, sus)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--print("codeOnDrag", touchX, touchY, sus, draggle_speed_y_dlcmapinfo)
				
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
					
					--更新滚动条的进度(军团聊天)
					local progressMax = delta1_ly - deltNa_ry
					local progressNow = delta1_ly
					local height = _frmNode.childUI["ScrollBar"].data.w - _frmNode.childUI["ScrollBarProgress"].data.h --h
					local scrollX = _frmNode.childUI["ScrollBarProgress"].data.x
					local scrollY = _frmNode.childUI["ScrollBar"].data.y + (1 - progressNow / progressMax) * height - height / 2
					_frmNode.childUI["ScrollBarProgress"]:setXY(scrollX, scrollY)
				end
				
				--存储本次的位置
				last_click_pos_y_dlcmapinfo = touchX
				last_click_pos_y_dlcmapinfo = touchY
			end,
			
			--抬起事件(军团聊天)
			code = function(self, touchX, touchY, sus)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_dlcmapinfo then
					--if (touchX ~= click_pos_x_dlcmapinfo) or (touchY ~= click_pos_y_dlcmapinfo) then --不是点击事件
						b_need_auto_fixing_dlcmapinfo = true
						friction_dlcmapinfo = 0
						friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
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
							friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
							draggle_speed_y_dlcmapinfo = MAX_SPEED / 1.0 --正速度 --速度一般大
							
							return
						end
					end
				end
				
				--是否选中某个聊天消息的头像区域(军团聊天)
				local selectTipIdxIcon = 0
				for i = 1, current_DLCMap_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					if ctrli then
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						local cw, ch = ctrli.data.w, ctrli.data.h
						local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
						local rx, ry = lx + cw, ly + ch --最右下角坐标
						--print(i, cx, cy)
						
						--检测是否点到了头像
						local ctrlI = ctrli.childUI["roleIcon"]
						if ctrlI then
							local bcx = ctrlI.data.x --中心点x坐标
							local bcy = ctrlI.data.y --中心点y坐标
							local bcw, bch = ctrlI.data.w + 20, ctrlI.data.h + 20 --点击区域大一些
							local blx, bly = cx + bcx - bcw / 2, cy  + bcy - bch / 2 --最左上侧坐标
							local brx, bry = blx + bcw, bly + bch --最右下角坐标
							--print(i, bcx, bcy, bcw, bch)
							if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
								selectTipIdxIcon = i
								--print("点击按钮" .. selectTipIdxIcon)
							end
						end
					end
				end
				if (click_scroll_dlcmapinfo) and (math.abs(touchY - click_pos_y_dlcmapinfo) > 42) then
					selectTipIdxIcon = 0
				end
				--点击到某个档位的奖励控件之内(军团聊天)
				if (selectTipIdxIcon > 0) then
					--弹出操作界面
					--print(selectTipIdxIcon)
					local ctrlI = _frmNode.childUI["DLCMapInfoNode" .. selectTipIdxIcon]
					if ctrlI then
						
						if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
							--创建消息互动操作界面tip
							OnCreateChatDialogueTip(selectTipIdxIcon)
						else
							--此消息不是系统、不是我发的，可以有个交互操作
							local uid = ctrlI.data.uid
							if (uid ~= 0) and (uid ~= xlPlayer_GetUID()) then
								--创建消息互动操作界面tip
								OnCreateChatDialogueTip(selectTipIdxIcon)
							end
						end
					end
				end
				
				--是否选中某个聊天消息的红包区域
				local selectTipIdxRedpacket = 0
				for i = 1, current_DLCMap_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					if ctrli then
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						local cw, ch = ctrli.data.w, ctrli.data.h
						local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
						local rx, ry = lx + cw, ly + ch --最右下角坐标
						--print(i, cx, cy)
						
						--检测是否点到了红包
						local ctrlI = ctrli.childUI["redPacket"]
						if ctrlI then
							local bcx = ctrlI.data.x --中心点x坐标
							local bcy = ctrlI.data.y --中心点y坐标
							local bcw, bch = ctrlI.data.w + 20, ctrlI.data.h + 20 --点击区域大一些
							local blx, bly = cx + bcx - bcw / 2, cy  + bcy - bch / 2 --最左上侧坐标
							local brx, bry = blx + bcw, bly + bch --最右下角坐标
							--print(i, bcx, bcy, bcw, bch)
							if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
								selectTipIdxRedpacket = i
								--print("点击按钮" .. selectTipIdxRedpacket)
							end
						end
					end
				end
				if (click_scroll_dlcmapinfo) and (math.abs(touchY - click_pos_y_dlcmapinfo) > 42) then
					selectTipIdxRedpacket = 0
				end
				--点击到某个档位的奖励控件之内
				if (selectTipIdxRedpacket > 0) then
					--弹出操作界面
					--print(selectTipIdxRedpacket)
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. selectTipIdxRedpacket]
					local ctrlI = ctrli.childUI["redPacket"]
					if ctrlI then
						--print("点击红包")
						--点击领取红包按钮
						OnClickGroupRedPacketBtn(selectTipIdxRedpacket)
					end
				end
				
				--标记不用滑动
				click_scroll_dlcmapinfo = false
			end,
		})
		_frmNode.childUI["DragPanelGroup"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DragPanelGroup"
		
		--滑动条(军团聊天)
		_frmNode.childUI["ScrollBar"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/rank_line.png", --"UI:vipline", --"misc/chest/herodetailattr.png",
			x = pg_offX + pg_width / 2 - 7,
			y = pg_offY,
			h = 4,
			w = pg_height - 6,
		})
		_frmNode.childUI["ScrollBar"].handle._n:setRotation(90)
		_frmNode.childUI["ScrollBar"].handle.s:setOpacity(0)
		_frmNode.childUI["ScrollBar"]:setstate(-1) --默认隐藏
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ScrollBar"
		--滚动进度
		_frmNode.childUI["ScrollBarProgress"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/scrollBtn.png",	--"UI:scrollBtn",
			x = pg_offX + pg_width / 2 - 7,
			y = pg_offY,
			w = 10,
			h = 22,
		})
		_frmNode.childUI["ScrollBarProgress"].handle.s:setOpacity(0)
		_frmNode.childUI["ScrollBarProgress"]:setstate(-1) --默认隐藏
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ScrollBarProgress"
		
		--物品背景图
		--九宫格
		local s91 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bottom9g.png", 0, 0, pg_width-2, pg_height, _frmNode.childUI["DragPanelGroup"])
		--s9:setColor(ccc3(255, 255, 255))
		--s9:setOpacity(128)
		local s92 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bottom9s.png", 0, 0, pg_width-2, pg_height, _frmNode.childUI["DragPanelGroup"])
		
		--删除之前可能的输入框
		if current_enterNameEditBox then
			_frmNode.handle._n:removeChild(current_enterNameEditBox, true)
			current_enterNameEditBox = nil
		end
		
		--绘制输入框
		--输入框
		local enterNameEditBox = nil
		local rgName = "" --输入的内容
		local editNameBoxTextEventHandle = function(strEventName, pSender)
			--local edit = tolua.cast(pSender, "CCEditBox") 
			--防止输入框被删除，触发回调安卓闪退
			if (current_enterNameEditBox ~= nil) then 
				if (strEventName == "began") then
					--
				elseif (strEventName == "changed") then --改变事件
					--
				elseif (strEventName == "ended") then
					rgName = enterNameEditBox:getText()
					
					--首次输入完文字后，查询称号
					if (not current_IsQueryChampion) then --是否查询过称号（因为称号有有效期，每次打开聊天，在首次输入文字后查询一次称号）
						--标记本次打开聊天界面已查询过称号
						current_IsQueryChampion = true
						
						--发起查询玩家称号
						SendCmdFunc["require_query_champion"]()
					end
				elseif (strEventName == "return") then
					--
				end
			end
			--print("editNameBoxTextEventHandle", strEventName, rgName)
			--xlLG("editbox", tostring(strEventName) .. ", rgName=" .. tostring(rgName) .. "\n")
		end
		
		--今日剩余发红包次数
		local vip = LuaGetPlayerVipLv() or 0
		local sendMaxNum = hVar.Vip_Conifg.groupSendRedpacketCount[vip] or 0
		local leftSendCount = sendMaxNum - current_group_send_redpacket_num
		if (leftSendCount < 0) then
			leftSendCount = 0
		end
		
		if (leftSendCount > 0) then
			--军团红包图标
			_frmNode.childUI["btnSendRedPacketGroup"] = hUI.button:new({
				parent = _parentNode,
				x = 32 + 6,
				y = -hVar.SCREEN.h + 46,
				--model = "misc/mask.png",
				model = -1,
				align = "MC",
				dragbox = _frm.childUI["dragBox"],
				w = 78,
				h = 78,
				scaleT = 0.95,
				code = function()
					--创建发红包界面
					on_create_group_redpacket_send_frame()
				end,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnSendRedPacketGroup"
			--_frmNode.childUI["btnSendRedPacketGroup"].handle.s:setOpacity(111) --只响应事件，不显示
			--军团红包图标
			_frmNode.childUI["btnSendRedPacketGroup"].childUI["imageIcon"] = hUI.image:new({
				parent = _frmNode.childUI["btnSendRedPacketGroup"].handle._n,
				x = 0,
				y = 0,
				model = "misc/chest/redpacket.png",
				align = "MC",
				dragbox = _frm.childUI["dragBox"],
				w = 58,
				h = 58,
			})
			--军团红包边框
			_frmNode.childUI["btnSendRedPacketGroup"].childUI["imageBorder"] = hUI.image:new({
				parent = _frmNode.childUI["btnSendRedPacketGroup"].handle._n,
				x = 0,
				y = 0,
				model = "misc/chest/purchase_border.png",
				align = "MC",
				dragbox = _frm.childUI["dragBox"],
				w = 60,
				h = 60,
			})
			
			--为了让输入文字比输入框稍微小些，这里输入框背景单独创建
			--输入框背景图
			hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_grayyellow_light.png", -68+ 62/2, -pg_offY-CHAT_BOARD_HEIGHT + 54 - 18, pg_width - 130 - 62, 64, _frmNode.childUI["DragPanelGroup"])
			local SMALL_LENGTH = 8
			enterNameEditBox = CCEditBox:create(CCSizeMake(pg_width - 130 - 62-SMALL_LENGTH*2, 64-SMALL_LENGTH), CCScale9Sprite:create("data/image/misc/button_null.png"))--"data/image/misc/win_back.png""data/image/misc/1xs.png"
			enterNameEditBox:setPosition(ccp(-68 + 62/2 + _frmNode.childUI["DragPanelGroup"].data.x, -pg_offY-CHAT_BOARD_HEIGHT + 54- 18 + _frmNode.childUI["DragPanelGroup"].data.y+SMALL_LENGTH/8))
			--enterNameEditBox:setFontName("Sketch Rockwell.ttf")
			enterNameEditBox:setFontSize(28)
			enterNameEditBox:setFontColor(ccc3(0, 0, 0))
			enterNameEditBox:setPlaceHolder(hVar.tab_string["__TEXT_TypeLetter"]) --"输入文字"
			enterNameEditBox:setPlaceholderFontColor(ccc3(128, 128, 128)) --默认显示文字颜色
			enterNameEditBox:setMaxLength(48) --最大支持字符数
			enterNameEditBox:registerScriptEditBoxHandler(editNameBoxTextEventHandle)
			enterNameEditBox:setTouchPriority(0)
			enterNameEditBox:setReturnType(kKeyboardReturnTypeDone)
			--_frmNode.childUI["DragPanelGroup"].handle._n:addChild(enterNameEditBox)
			_frmNode.handle._n:addChild(enterNameEditBox)
			
			--存储输入框指针
			current_enterNameEditBox = enterNameEditBox
		else
			--为了让输入文字比输入框稍微小些，这里输入框背景单独创建
			--输入框背景图
			hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_grayyellow_light.png", -68, -pg_offY-CHAT_BOARD_HEIGHT + 54 - 18, pg_width - 130, 64, _frmNode.childUI["DragPanelGroup"])
			local SMALL_LENGTH = 8
			enterNameEditBox = CCEditBox:create(CCSizeMake(pg_width - 130-SMALL_LENGTH*2, 64-SMALL_LENGTH), CCScale9Sprite:create("data/image/misc/button_null.png"))--"data/image/misc/win_back.png""data/image/misc/1xs.png"
			enterNameEditBox:setPosition(ccp(-68 + _frmNode.childUI["DragPanelGroup"].data.x, -pg_offY-CHAT_BOARD_HEIGHT + 54 - 18 + _frmNode.childUI["DragPanelGroup"].data.y+SMALL_LENGTH/8))
			--enterNameEditBox:setFontName("Sketch Rockwell.ttf")
			enterNameEditBox:setFontSize(28)
			enterNameEditBox:setFontColor(ccc3(0, 0, 0))
			enterNameEditBox:setPlaceHolder(hVar.tab_string["__TEXT_TypeLetter"]) --"输入文字"
			enterNameEditBox:setPlaceholderFontColor(ccc3(128, 128, 128)) --默认显示文字颜色
			enterNameEditBox:setMaxLength(48) --最大支持字符数
			enterNameEditBox:registerScriptEditBoxHandler(editNameBoxTextEventHandle)
			enterNameEditBox:setTouchPriority(0)
			enterNameEditBox:setReturnType(kKeyboardReturnTypeDone)
			--_frmNode.childUI["DragPanelGroup"].handle._n:addChild(enterNameEditBox)
			_frmNode.handle._n:addChild(enterNameEditBox)
			
			--存储输入框指针
			current_enterNameEditBox = enterNameEditBox
		end
		
		--发送按钮(军团聊天)
		_frmNode.childUI["btnSendMessageGroup"] = hUI.button:new({
			parent = _parentNode,
			x = pg_offX + pg_width /2 - 130 / 2 - 1,
			y = -hVar.SCREEN.h + 2 * iPhoneX_HEIGHT + 46,
			model = "misc/chest/chatsend.png",
			align = "MC",
			dragbox = _frm.childUI["dragBox"],
			w = 134,
			h = 56,
			scaleT = 0.95,
			code = function()
				--如果未连接socket工会服务器，不能操作
				if (Group_Server:GetState() ~= 1) then --未连接
					--冒字
					--local strText = "不能连接到网络" --language
					local strText = hVar.tab_string["ios_err_network_cannot_conn"] --language
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
				
				--如果未登入工会服务器，不能操作
				if (Group_Server:getonline() ~= 1) then --未登入
					--冒字
					--local strText = "不能连接到网络" --language
					local strText = hVar.tab_string["ios_err_network_cannot_conn"] --language
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
				
				--被禁言不能发送消息
				if (current_msgForbidden == 1) then
					--计算禁言剩余时间
					local localTime = os.time() --客户端的时间(本地时区)
					--服务器的时间(本地时区)
					local hostTimeNow = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
					--禁言开始的时间(本地时区)
					local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
					local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
					local forbiddenBeginTime = hApi.GetNewDate(current_msgForbiddenTime) + delteZone * 3600 --服务器时间(本地时区)
					--剩余时间
					local forbiddenLeft = hostTimeNow - forbiddenBeginTime
					local minuteLeft = current_msgForbidden_minute - math.floor(forbiddenLeft / 60)
					if (minuteLeft > 0) then
						--冒字
						--local strText = "您被禁言，" .. minuteLeft .. "分钟后才能发送消息！" --language
						local strText = string.format(hVar.tab_string["ios_err_network_cannot_chat_forbidden"], minuteLeft) --language
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
				end
				
				--geyachao: windows版，接收不到输入框的ended事件，只能在点击按钮的时候，取一下输入的文本
				local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
				if (g_tTargetPlatform.kTargetWindows == TargetPlatform) then --windows版
					rgName = enterNameEditBox:getText()
				end
				
				--检测文字是否纯为空格
				if (rgName ~= "") then
					local bAllBlank = true
					for i = 1, #rgName, 1 do
						local s = string.sub(rgName, i, i)
						if (s ~= " ") then
							bAllBlank = false
							break
						end
					end
					if bAllBlank then
						--冒字
						--local strText = "聊天内容不能为空" --language
						local strText = hVar.tab_string["ios_chat_not_empty"] --language
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
				end
				
				--检测输入的文字是否过长
				local nLength = hApi.GetStringEmojiENLength(rgName) --英文长度
				if (nLength > 96) then
					--冒字
					--local strText = "您输入的内容过长" --language
					local strText = hVar.tab_string["ios_chat_too_long"] --language
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
				
				--处理文字(军团聊天)
				local message = rgName
				
				--去除特殊符号
				local origin = {"%(", "%)", "%.", "%%", "%+", "%-", "%*", "%?", "%[", "%]", "%^", "%$", ";", "/", "\\", "|", ":", ",", "'",}
				local replace = {"（", "）", "·", "％", "＋", "－", "＊", "？", "【", "】", "∧", "＄", "；", "╱", "╲", "│", "：", "，", "‘",}
				for i = 1, #origin, 1 do
					local originChar = origin[i]
					local replaceChar = replace[i]
					--print(i, originChar, replaceChar)
					while true do
						--print(message)
						local pos = string.find(message, originChar)
						--print(pos)
						if (pos ~= nil) then
							if (pos < #message) then --不是最后一个字符
								message = string.sub(message, 1, pos - 1) .. replaceChar .. string.sub(message, pos + 1, #message)
							else --最后一个字符
								message = string.sub(message, 1, pos - 1) .. replaceChar
							end
						else
							break
						end
					end
				end
				
				--去除回车等控制字符
				string.gsub(message, "%c", "")
				
				--去除屏蔽字
				local MESSAGE = string.upper(message) --大写(用于匹配)
				local GLOBAL_FILTER_TEXT = hVar.tab_filtertext
				for i = #GLOBAL_FILTER_TEXT, 1, -1 do
					local strFilter = GLOBAL_FILTER_TEXT[i]
					local nLength = hApi.GetStringEmojiENLength(strFilter, 1, 1) --Unicode长度
					while true do
						local pos = string.find(MESSAGE, strFilter)
						if (pos ~= nil) then
							local strRep = string.rep("*", nLength)
							--message = string.gsub(message, strFilter, strRep)
							if ((pos + #strFilter - 1) < #message) then --不是最后一个字符
								message = string.sub(message, 1, pos - 1) .. strRep .. string.sub(message, (pos + #strFilter - 1) + 1, #message)
							else --最后一个字符
								message = string.sub(message, 1, pos - 1) .. strRep
							end
							
							MESSAGE = string.upper(message) --大写(用于匹配)
						else
							break
						end
					end
				end
				
				--最后转小写
				--message = string.lower(message)
				
				--清空文字
				rgName = ""
				enterNameEditBox:setText("")
				
				--检测是否刷屏
				if (LuaCheckChatMessageIsFloodScreen(g_curPlayerName, current_chat_type, message) == 1) then
					--冒字
					--local strText = "您的聊天内容在短时间内已重复多次，不能发送" --language
					local strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_FLOOD_SCREEN"] --language
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
				
				--检测是否发言过快
				if (LuaCheckChatMessageIsTooFast(g_curPlayerName, current_chat_type, message) == 1) then
					--冒字
					--local strText = "您的聊天频率在短时间内过快，不能发送" --language
					local strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_TOO_FAST"] --language
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
				
				if (message ~= "") then
					--[[
					--测试 --test
					message = "一二三四五六七八九十一二三四五六七八九十"
					]]
					
					--请求发送消息（军团聊天）
					local msgType = hVar.MESSAGE_TYPE.TEXT --文本消息
					local touid = current_msgGroupId
					SendGroupCmdFunc["chat_send_message"](current_chat_type, msgType, message, touid)
					
					--本地添加一条发送消息记录（防刷屏）
					LuaAddtRecentChatMsg(g_curPlayerName, current_chat_type, message)
				end
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnSendMessageGroup"
		--发送按钮的文字"发送"(军团)
		_frmNode.childUI["btnSendMessageGroup"].childUI["sendNoLimit"] = hUI.label:new({
			parent = _frmNode.childUI["btnSendMessageGroup"].handle._n,
			x = -4,
			y = -1,
			align = "MC",
			font = hVar.FONTC,
			size = 28,
			text = hVar.tab_string["__TEXT_SEND"], --"发送"
			border = 1,
			--RGB = {255, 255, 0,},
		})
		
		--查询的菊花
		_frmNode.childUI["waiting"] = hUI.button:new({ --作为按钮是为了挂载子控件
			parent = _BTC_pClipNodeGroup,
			x = _BTC_PageClippingRectWorld[1] + _BTC_PageClippingRectWorld[3]/2,
			y = _BTC_PageClippingRectWorld[2] - _BTC_PageClippingRectWorld[4]/2,
			z = 1,
			--label = {x = 0, y = -1, align = "MC", font = hVar.FONTC, size = 24, text = "重新连接", border = 1,},
			--model = "UI:PANEL_MENU_BTN_BIG", --"UI:SkillSlot",
			model = "misc/mask_white.png",
			--dragbox = _frm.childUI["dragBox"],
			w = 310,
			h = 120,
			--scaleT = 0.95,
			--code = function()
			--
			--end,
		})
		_frmNode.childUI["waiting"].handle.s:setColor(ccc3(128, 128, 128))
		_frmNode.childUI["waiting"].handle.s:setOpacity(64)
		_frmNode.childUI["waiting"]:setstate(-1) --默认隐藏
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "waiting"
		--查询的文字
		_frmNode.childUI["waiting"].childUI["text"] = hUI.label:new({
			parent = _frmNode.childUI["waiting"].handle._n,
			x = 0,
			y = 0,
			font = hVar.FONTC,
			align = "MC",
			size = 20,
			width = 500,
			text = "", --"正在连接中..."
			RGB = {212, 212, 212,},
		})
		
		--onCreateNewMessageHint()
		--onRemoveNewMessageHint()
		
		--添加监听
		--添加移除事件监听：横竖屏切换
 		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenAchievement_", on_spine_screen_event)
		--添加事件监听：收到工会服务器socket连接结果回调
		hGlobal.event:listen("LocalEvent_Group_NetEvent", "__GroupServerConnectBack_", on_receive_grouperver_connect_back_event)
		--添加事件监听：收到工会服务器登陆结果回调
		hGlobal.event:listen("LocalEvent_Group_LogEvent", "__GroupServerLoginBack_", on_receive_group_server_login_back_event)
		--添加事件监听：收到聊天模块初始化事件
		hGlobal.event:listen("LocalEvent_Group_ChatInitEvent", "__GroupServerChatInitBack_", on_receive_chat_init_event)
		--添加事件监听：收到聊天消息id事件
		hGlobal.event:listen("LocalEvent_Group_ChatIDListEvent", "__GroupServerChatIDListBack_", on_receive_chat_id_list_event)
		--添加事件监听：收到聊天消息内容事件
		hGlobal.event:listen("LocalEvent_Group_ChatContentListEvent", "__GroupServerChatContentListBack_", on_receive_chat_content_list_event)
		--添加事件监听：收到单条聊天消息事件
		hGlobal.event:listen("LocalEvent_Group_SingleChatMessageEvent", "__SingleChatMessageBack_", on_receive_single_chat_message_event)
		--添加事件监听：收到更新单条聊天消息事件
		hGlobal.event:listen("LocalEvent_Group_UpdatChatMessageEvent", "__UpdateChatMessageBack_", on_receive_update_chat_message_event)
		--添加事件监听：收到删除聊天消息事件
		hGlobal.event:listen("LocalEvent_Group_RemoveChatMessageEvent", "__RemoveChatMessageBack_", on_receive_remove_chat_message_event)
		--添加事件监听：收到被禁言的通知事件
		hGlobal.event:listen("LocalEvent_Group_ChatForbiddenEvent", "__ChatForbiddenBack_", on_receive_chat_forbidden_event)
		--添加事件监听：收到发起私聊请求的结果返回
		hGlobal.event:listen("LocalEvent_Group_PrivateInviteChatEvent", "__ChatPrivateInviteBack_", on_receive_chat_private_invite_event)
		--添加事件监听：收到工会操作结果返回
		hGlobal.event:listen("LocalEvent_Group_OperationRet", "__GroupOperationRetBack_", on_receive_group_result_event)
		--添加事件监听：收到加入军团邀请函结果返回
		hGlobal.event:listen("localEvent_GroupInviteJoinBack", "__GroupInviteRetBack_", on_receive_group_invite_back_event)
		--添加监听：程序进入后台的回调
		hGlobal.event:listen("LocalEvent_AppEnterBackground", "__ChatMessageBack_", on_app_enter_background_event)
		--添加监听：游戏局结束事件
		hGlobal.event:listen("LocalEvent_GameOver", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（夺塔奇兵）
		hGlobal.event:listen("LocalEvent_GameOver_PVP", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（魔龙宝库）
		hGlobal.event:listen("LocalEvent_GameOver_PVP_Endless", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（铜雀台）
		hGlobal.event:listen("LocalEvent_GameOver_PVP_Endless_Singlebattle", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（新手地图）
		hGlobal.event:listen("LocalEvent_GameOver_NewGuideMap", "__ChatGameEnd_", on_game_end_event)
		--添加监听：PVP等待其他玩家事件
		hGlobal.event:listen("LocalEvent_Pvp_Delay_Player", "__ChatPVPWaitPlayer_", on_pvp_wait_player_event)
		--添加监听：PVP本地长时间未响应事件
		hGlobal.event:listen("LocalEvent_Pvp_LocalNoHeart", "__ChatPVPLocalNoHeart_", on_pvp_local_noheart_event)
		--添加监听：安卓本地掉线事件
		hGlobal.event:listen("LocalEvent_showAndroidNetAlreadyFrm", "__ChatAndroidDisconnect_", on_android_local_disconnect_event)
		--添加事件监听：切换剧情地图场景事件
		hGlobal.event:listen("LocalEvent_Battle_SwitchGame", "__BattleSwitchGameBack_chat2", on_game_end_event)
		--添加事件监听：切换pvp场景事件
		hGlobal.event:listen("LocalEvent_Pvp_SwitchGame", "__PVPSwitchGameBack_chat2", on_game_end_event)
		--添加事件监听：切换pvp匹配房场景事件
		hGlobal.event:listen("LocalEvent_Pvp_Match_SwitchGame", "__MatchSwitchGameBack_chat2", on_game_end_event)
		
		--私聊
		--添加监听：收到增加单个私聊好友
		hGlobal.event:listen("LocalEvent_Group_PrivateFriendAddEvent", "__ChatPrivateFriendAddBack_", on_add_private_friend_event)
		--添加监听：收到删除单个私聊好友
		hGlobal.event:listen("LocalEvent_Group_PrivateFriendRemoveEvent", "__ChatPrivateFriendRemoveBack_", on_remove_private_friend_event)
		
		--刷新滚动的timer（军团消息）
		--hApi.addTimerForever("__CHATFRAME_PRIVATE_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_chatframe_scroll_private_loop)
		hApi.addTimerForever("__CHATFRAME_WORLD_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_chatframe_scroll_world_loop)
		--刷新红包领取倒计时的timer
		hApi.addTimerForever("__CHATFRAME_REDPACKET_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 1000, refresh_chat_redpacket_loop)
		--自动连接工会服务器的timer
		hApi.addTimerForever("__CHATAUTOLINK_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 5000, refresh_chatframe_autolink_loop)
		--异步绘制聊天消息的timer
		hApi.addTimerForever("__CHATPAINT_MESSAGE_ASYNC__", hVar.TIMER_MODE.GAMETIME, 1, refresh_async_paint_message_loop)
		
		--[[
		--测试 --test
		--发起查询，1元档商品信息
		--SendCmdFunc["iap_sale_gift"]()
		--依次绘制每条消息
		local tChatMsgList =
		{
			{msgId = 1, name = "adidas先生", date = "00:00:01", content = "¡¡¡¡¡¡¡¡¡¡",},
			{msgId = 1, name = "游客", date = "10:03:23", content = "||||||||||",},
			{msgId = 1, name = "游客21000001", date = "12:00:59", content = "}}}}}}}}}}",},
			{msgId = 1, name = "GUEST", date = "13:07:23", content = "^^^^^^^^^^",},
			{msgId = 1, name = "diaoxian", date = "14:23:00", content = "\\\\\\\\\\\\\\\\\\\\",},
			{msgId = 1, name = "u123123", date = "15:46:33", content = "~~~~~~~~~~",},
			{msgId = 1, name = "我是你的发", date = "16:54:47", content = "``````````",},
			{msgId = 1, name = "爱情", date = "18:03:09", content = "爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了",},
			{msgId = 1, name = "掉线", date = "20:33:12", content = ">>>>>>>>>>",},
			{msgId = 1, name = "打老师345", date = "23:24:32", content = "加群 qq:19900000",},
		}
		current_DLCMap_max_num = #tChatMsgList
		--依次绘制消息
		for i = 1, 10, 1 do
			on_create_single_message_UI(tChatMsgList[i], i)
		end
		]]
		
		
		--[[
		--获得一个加速度，使右边自动往上滚动
		--超过一页的数量才滑屏
		if (current_DLCMap_max_num > (WEAPON_X_NUM * WEAPON_Y_NUM)) then
			--向上滚屏
			b_need_auto_fixing_dlcmapinfo = true
			friction_dlcmapinfo = 0
			friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
			draggle_speed_y_dlcmapinfo = MAX_SPEED / 1.0 --正速度
		end
		]]
		
		--挡操作
		--hUI.NetDisable(30000)
		
		--发起登入工会服务器操作
		--print("发起登入工会服务器操作")
		--print("发起登入工会服务器操作", Group_Server:GetState())
		if (Group_Server:GetState() == 1) then --不重复登入
			--模拟触发连接工会服务socket结果回调
			--print("模拟触发连接工会服务socket结果回调")
			on_receive_grouperver_connect_back_event(1)
		else
			--连接
			--print("Group_Server:Connect()")
			Group_Server:Connect()
		end
	end
	
	--!!!! edit by mj !!!!wait edit this func!!!! 2022.11.15
	--函数：创建组队聊天界面（第5个分页）
	OnCreateCoupleChatInfoFrame = function(pageIdx)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--允许本分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNodeCouple", 1)
		
		--标记本分页的聊天频道(组队聊天频道)
		current_chat_type = hVar.CHAT_TYPE.COUPLE
		
		--初始化数据
		current_DLCMap_max_num = 0
		current_async_paint_list = {} --清空异步缓存待绘制内容
		current_DLCMap_friend_max_num = 0
		current_DLCMap_roomid = 0 --当前请求组队副本的房间消息id
		
		--统一处理聊天页的位置和大小
		local pg_offX = CHAT_INFO_FRM_POS_X 		--362
		local pg_offY = CHAT_INFO_FRM_POS_Y 		---hVar.SCREEN.h / 2 + 10
		local pg_width = BOARD_WIDTH - 10
		local pg_height = CHAT_INFO_FRM_POS_HEIGHT 	--hVar.SCREEN.h - 136
		
		--[[
		--左侧DLC地图包列表提示上翻页的图片
		_frmNode.childUI["DLCMapInfoPageUp"] = hUI.image:new({
			parent = _BTC_pClipNodeWorld,
			model = "misc/chest/tutorial_arrow_right.png", --"UI:PageBtn",
			x = pg_offX,
			y = pg_offY + 238,
			scale = 0.5,
			z = 500, --最前端显示
		})
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setRotation(-90)
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --默认不显示左上翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["DLCMapInfoPageUp"].handle._n:runAction(forever)
		
		--左侧DLC地图包列表提示下翻页的图片
		_frmNode.childUI["DLCMapInfoPageDown"] = hUI.image:new({
			parent = _BTC_pClipNodeWorld,
			model = "misc/chest/tutorial_arrow_right.png", --"UI:PageBtn",
			x = pg_offX,
			y = pg_offY - 238,
			scale = 0.5,
			z = 500, --最前端显示
		})
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setRotation(90)
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["DLCMapInfoPageDown"].handle._n:runAction(forever)
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --默认不显示下分翻页提示
		]]
		
		--[[
		--左侧向上翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["DLCMapInfoPageUp_Btn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = pg_offX,
			y = pg_offY + 182,
			w = 360,
			h = 60,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--超过一页的数量才滑屏
				if (current_DLCMap_max_num > (WEAPON_X_NUM * WEAPON_Y_NUM)) then
					--print("向下滚屏", screenY)
					--向下滚屏
					b_need_auto_fixing_dlcmapinfo = true
					friction_dlcmapinfo = 0
					friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
					draggle_speed_y_dlcmapinfo = -MAX_SPEED / 2.0 --负速度
				end
			end,
		})
		_frmNode.childUI["DLCMapInfoPageUp_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageUp_Btn"
		]]
		
		--[[
		--左侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["DLCMapInfoPageDown_Btn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = pg_offX,
			y = pg_offY - 182,
			w = 360,
			h = 60,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--超过一页的数量才滑屏
				if (current_DLCMap_max_num > (WEAPON_X_NUM * WEAPON_Y_NUM)) then
					--print("向上滚屏", screenY)
					--向上滚屏
					b_need_auto_fixing_dlcmapinfo = true
					friction_dlcmapinfo = 0
					friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
					draggle_speed_y_dlcmapinfo = MAX_SPEED / 2.0 --正速度
				end
			end,
		})
		_frmNode.childUI["DLCMapInfoPageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageDown_Btn"
		]]
		
		--检测滑动事件的控件(组队聊天)
		_frmNode.childUI["DragPanelCouple"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = pg_offX,
			y = pg_offY,
			w = pg_width,
			h = pg_height,
			failcall = 1,
			
			--按下事件(组队聊天)
			codeOnTouch = function(self, touchX, touchY, sus)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
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
				friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
				
				--如果DLC地图面板数量未铺满一页，那么不需要滑动
				--if (current_DLCMap_max_num <= (WEAPON_X_NUM * WEAPON_Y_NUM)) then
				--	click_scroll_dlcmapinfo = false --不需要滑动DLC地图面板
				--end
				
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
				
				--模拟按下事件
				--检测是否点到了某些控件里(组队聊天)
				for i = 1, current_DLCMap_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					if ctrli then
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						
						--[[
						--检测是否点到了领奖按钮
						local ctrlI = ctrli.childUI["rewardBtn"]
						if ctrlI then
							if (ctrlI.data.state == 1) then --按钮可点状态
								local bcx = ctrlI.data.x --中心点x坐标
								local bcy = ctrlI.data.y --中心点y坐标
								local bcw, bch = ctrlI.data.w, ctrlI.data.h
								local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
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
									ctrlI.handle._n:stopAllActions()
									ctrlI.handle._n:runAction(sequence)
								end
							end
						end
						]]
					end
				end
				
				--在滑动过程中才会处理滑动
				if click_scroll_dlcmapinfo then
					--显示滚动条
					--_frmNode.childUI["ScrollBar"]:setstate(1)
					onShowScrollBarHint()
					
					--更新滚动条的进度(组队聊天)
					local progressMax = delta1_ly - deltNa_ry
					local progressNow = delta1_ly
					local height = _frmNode.childUI["ScrollBar"].data.w - _frmNode.childUI["ScrollBarProgress"].data.h --h
					local scrollX = _frmNode.childUI["ScrollBarProgress"].data.x
					local scrollY = _frmNode.childUI["ScrollBar"].data.y + (1 - progressNow / progressMax) * height - height / 2
					_frmNode.childUI["ScrollBarProgress"]:setXY(scrollX, scrollY)
				end
			end,
			
			--滑动事件(组队聊天)
			codeOnDrag = function(self, touchX, touchY, sus)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--print("codeOnDrag", touchX, touchY, sus, draggle_speed_y_dlcmapinfo)
				
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
					
					--更新滚动条的进度(组队聊天)
					local progressMax = delta1_ly - deltNa_ry
					local progressNow = delta1_ly
					local height = _frmNode.childUI["ScrollBar"].data.w - _frmNode.childUI["ScrollBarProgress"].data.h --h
					local scrollX = _frmNode.childUI["ScrollBarProgress"].data.x
					local scrollY = _frmNode.childUI["ScrollBar"].data.y + (1 - progressNow / progressMax) * height - height / 2
					_frmNode.childUI["ScrollBarProgress"]:setXY(scrollX, scrollY)
				end
				
				--存储本次的位置
				last_click_pos_y_dlcmapinfo = touchX
				last_click_pos_y_dlcmapinfo = touchY
			end,
			
			--抬起事件(组队聊天)
			code = function(self, touchX, touchY, sus)
				--在动画中禁止点击
				if current_is_in_action then
					return
				end
				
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_dlcmapinfo then
					--if (touchX ~= click_pos_x_dlcmapinfo) or (touchY ~= click_pos_y_dlcmapinfo) then --不是点击事件
						b_need_auto_fixing_dlcmapinfo = true
						friction_dlcmapinfo = 0
						friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
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
							friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
							draggle_speed_y_dlcmapinfo = MAX_SPEED / 1.0 --正速度 --速度一般大
							
							return
						end
					end
				end
				
				--是否选中某个聊天消息的头像区域(组队聊天)
				local selectTipIdx = 0
				for i = 1, current_DLCMap_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					if ctrli then
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						local cw, ch = ctrli.data.w, ctrli.data.h
						local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
						local rx, ry = lx + cw, ly + ch --最右下角坐标
						--print(i, cx, cy)
						
						--检测是否点到了头像
						local ctrlI = ctrli.childUI["roleIcon"]
						if ctrlI then
							local bcx = ctrlI.data.x --中心点x坐标
							local bcy = ctrlI.data.y --中心点y坐标
							local bcw, bch = ctrlI.data.w + 20, ctrlI.data.h + 20 --点击区域大一些
							local blx, bly = cx + bcx - bcw / 2, cy  + bcy - bch / 2 --最左上侧坐标
							local brx, bry = blx + bcw, bly + bch --最右下角坐标
							--print(i, bcx, bcy, bcw, bch)
							if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
								selectTipIdx = i
								--print("点击按钮" .. selectTipIdx)
							end
						end
					end
				end
				
				if (click_scroll_dlcmapinfo) and (math.abs(touchY - click_pos_y_dlcmapinfo) > 42) then
					selectTipIdx = 0
				end
				
				--点击到某个档位的奖励控件之内(组队聊天)
				if (selectTipIdx > 0) then
					--弹出操作界面
					--print(selectTipIdx)
					local ctrlI = _frmNode.childUI["DLCMapInfoNode" .. selectTipIdx]
					if ctrlI then
						
						if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
							--创建消息互动操作界面tip
							OnCreateChatDialogueTip(selectTipIdx)
						else
							--此消息不是系统、不是我发的，可以有个交互操作
							local uid = ctrlI.data.uid
							if (uid ~= 0) and (uid ~= xlPlayer_GetUID()) then
								--创建消息互动操作界面tip
								OnCreateChatDialogueTip(selectTipIdx)
							end
						end
					end
				end
				
				--标记不用滑动
				click_scroll_dlcmapinfo = false
			end,
		})
		_frmNode.childUI["DragPanelCouple"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DragPanelCouple"
		
		--滑动条(组队聊天)
		_frmNode.childUI["ScrollBar"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/rank_line.png", --"UI:vipline", --"misc/chest/herodetailattr.png",
			x = pg_offX + pg_width / 2 - 7,
			y = pg_offY,
			h = 4,
			w = pg_height - 6,
		})
		_frmNode.childUI["ScrollBar"].handle._n:setRotation(90)
		_frmNode.childUI["ScrollBar"].handle.s:setOpacity(0)
		_frmNode.childUI["ScrollBar"]:setstate(-1) --默认隐藏
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ScrollBar"
		--滚动进度
		_frmNode.childUI["ScrollBarProgress"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/scrollBtn.png",	--"UI:scrollBtn",
			x = pg_offX + pg_width / 2 - 7,
			y = pg_offY,
			w = 10,
			h = 22,
		})
		_frmNode.childUI["ScrollBarProgress"].handle.s:setOpacity(0)
		_frmNode.childUI["ScrollBarProgress"]:setstate(-1) --默认隐藏
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ScrollBarProgress"
		
		--物品背景图
		--九宫格
		local s91 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bottom9g.png", 0, 0, pg_width-2, pg_height, _frmNode.childUI["DragPanelCouple"])
		--s9:setColor(ccc3(255, 255, 255))
		--s9:setOpacity(128)
		local s92 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bottom9s.png", 0, 0, pg_width-2, pg_height, _frmNode.childUI["DragPanelCouple"])
		
		--删除之前可能的输入框
		if current_enterNameEditBox then
			_frmNode.handle._n:removeChild(current_enterNameEditBox, true)
			current_enterNameEditBox = nil
		end
		
		--绘制输入框
		--输入框
		local enterNameEditBox = nil
		local rgName = "" --输入的内容
		local editNameBoxTextEventHandle = function(strEventName, pSender)
			--local edit = tolua.cast(pSender, "CCEditBox") 
			--防止输入框被删除，触发回调安卓闪退
			if (current_enterNameEditBox ~= nil) then 
				if (strEventName == "began") then
					--
				elseif (strEventName == "changed") then --改变事件
					--
				elseif (strEventName == "ended") then
					rgName = enterNameEditBox:getText()
					
					--首次输入完文字后，查询称号
					if (not current_IsQueryChampion) then --是否查询过称号（因为称号有有效期，每次打开聊天，在首次输入文字后查询一次称号）
						--标记本次打开聊天界面已查询过称号
						current_IsQueryChampion = true
						
						--发起查询玩家称号
						SendCmdFunc["require_query_champion"]()
					end
				elseif (strEventName == "return") then
					--
				end
			end
			--print("editNameBoxTextEventHandle", strEventName, rgName)
			--xlLG("editbox", tostring(strEventName) .. ", rgName=" .. tostring(rgName) .. "\n")
		end
		
		--为了让输入文字比输入框稍微小些，这里输入框背景单独创建
		--输入框背景图
		hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_grayyellow_light.png", -68, -pg_offY-CHAT_BOARD_HEIGHT + 54 - 18, pg_width - 130, 64, _frmNode.childUI["DragPanelCouple"])
		local SMALL_LENGTH = 8
		enterNameEditBox = CCEditBox:create(CCSizeMake(pg_width - 130-SMALL_LENGTH*2, 64-SMALL_LENGTH), CCScale9Sprite:create("data/image/misc/button_null.png"))--"data/image/misc/win_back.png""data/image/misc/1xs.png"
		enterNameEditBox:setPosition(ccp(-68 + _frmNode.childUI["DragPanelCouple"].data.x, -pg_offY-CHAT_BOARD_HEIGHT + 54 - 18 + _frmNode.childUI["DragPanelCouple"].data.y+SMALL_LENGTH/8))
		--enterNameEditBox:setFontName("Sketch Rockwell.ttf")
		enterNameEditBox:setFontSize(28)
		enterNameEditBox:setFontColor(ccc3(0, 0, 0))
		enterNameEditBox:setPlaceHolder(hVar.tab_string["__TEXT_TypeLetter"]) --"输入文字"
		enterNameEditBox:setPlaceholderFontColor(ccc3(128, 128, 128)) --默认显示文字颜色
		enterNameEditBox:setMaxLength(48) --最大支持字符数
		enterNameEditBox:registerScriptEditBoxHandler(editNameBoxTextEventHandle)
		enterNameEditBox:setTouchPriority(0)
		enterNameEditBox:setReturnType(kKeyboardReturnTypeDone)
		--_frmNode.childUI["DragPanelCouple"].handle._n:addChild(enterNameEditBox)
		_frmNode.handle._n:addChild(enterNameEditBox)
		
		--存储输入框指针
		current_enterNameEditBox = enterNameEditBox
		
		--发送按钮(组队)
		_frmNode.childUI["btnSendMessageCouple"] = hUI.button:new({
			parent = _parentNode,
			x = pg_offX + pg_width /2 - 130 / 2 - 1,
			y = -hVar.SCREEN.h + 2 * iPhoneX_HEIGHT + 46,
			model = "misc/chest/chatsend.png",
			align = "MC",
			dragbox = _frm.childUI["dragBox"],
			w = 134,
			h = 56,
			scaleT = 0.95,
			code = function()
				--如果未连接socket工会服务器，不能操作
				if (Group_Server:GetState() ~= 1) then --未连接
					--冒字
					--local strText = "不能连接到网络" --language
					local strText = hVar.tab_string["ios_err_network_cannot_conn"] --language
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
				
				--如果未登入工会服务器，不能操作
				if (Group_Server:getonline() ~= 1) then --未登入
					--冒字
					--local strText = "不能连接到网络" --language
					local strText = hVar.tab_string["ios_err_network_cannot_conn"] --language
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
				
				--被禁言不能发送消息
				if (current_msgForbidden == 1) then
					--计算禁言剩余时间
					local localTime = os.time() --客户端的时间(本地时区)
					--服务器的时间(本地时区)
					local hostTimeNow = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
					--禁言开始的时间(本地时区)
					local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
					local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
					local forbiddenBeginTime = hApi.GetNewDate(current_msgForbiddenTime) + delteZone * 3600 --服务器时间(本地时区)
					--剩余时间
					local forbiddenLeft = hostTimeNow - forbiddenBeginTime
					local minuteLeft = current_msgForbidden_minute - math.floor(forbiddenLeft / 60)
					if (minuteLeft > 0) then
						--冒字
						--local strText = "您被禁言，" .. minuteLeft .. "分钟后才能发送消息！" --language
						local strText = string.format(hVar.tab_string["ios_err_network_cannot_chat_forbidden"], minuteLeft) --language
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
				end
				
				--组队聊天，检测玩家是否在组队副本中
				local touid = 0
				local tolist = {}
				local world = hGlobal.WORLD.LastWorldMap
				if world then
					touid = world.data.session_dbId
					--touid = 10000
					for i = 1, 24, 1 do
						local player = world.data.PlayerList[i]
						if player then
							if (player:gettype() == 1) then --0空 1玩家 2简单电脑 3中等电脑 4困难电脑 5大师电脑 6专家电脑
								local name = player.data.name
								local dbid = player.data.dbid
								--print(i, name, dbid)
								tolist[#tolist+1] = dbid
							end
						end
					end
				end
				if (touid <= 0) then
					--冒字
					--local strText = "您不在组队副本中！" --language
					local strText = hVar.tab_string["ios_err_network_cannot_couple"] --language
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
				
				--geyachao: windows版，接收不到输入框的ended事件，只能在点击按钮的时候，取一下输入的文本
				local TargetPlatform = CCApplication:sharedApplication():getTargetPlatform()
				if (g_tTargetPlatform.kTargetWindows == TargetPlatform) then --windows版
					rgName = enterNameEditBox:getText()
				end
				
				--检测文字是否纯为空格
				if (rgName ~= "") then
					local bAllBlank = true
					for i = 1, #rgName, 1 do
						local s = string.sub(rgName, i, i)
						if (s ~= " ") then
							bAllBlank = false
							break
						end
					end
					if bAllBlank then
						--冒字
						--local strText = "聊天内容不能为空" --language
						local strText = hVar.tab_string["ios_chat_not_empty"] --language
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
				end
				
				--检测输入的文字是否过长
				local nLength = hApi.GetStringEmojiENLength(rgName) --英文长度
				if (nLength > 96) then
					--冒字
					--local strText = "您输入的内容过长" --language
					local strText = hVar.tab_string["ios_chat_too_long"] --language
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
				
				--处理文字(组队)
				local message = rgName
				
				--去除特殊符号
				local origin = {"%(", "%)", "%.", "%%", "%+", "%-", "%*", "%?", "%[", "%]", "%^", "%$", ";", "/", "\\", "|", ":", ",", "'",}
				local replace = {"（", "）", "·", "％", "＋", "－", "＊", "？", "【", "】", "∧", "＄", "；", "╱", "╲", "│", "：", "，", "‘",}
				for i = 1, #origin, 1 do
					local originChar = origin[i]
					local replaceChar = replace[i]
					--print(i, originChar, replaceChar)
					while true do
						--print(message)
						local pos = string.find(message, originChar)
						--print(pos)
						if (pos ~= nil) then
							if (pos < #message) then --不是最后一个字符
								message = string.sub(message, 1, pos - 1) .. replaceChar .. string.sub(message, pos + 1, #message)
							else --最后一个字符
								message = string.sub(message, 1, pos - 1) .. replaceChar
							end
						else
							break
						end
					end
				end
				
				--去除回车等控制字符
				string.gsub(message, "%c", "")
				
				--去除屏蔽字
				local MESSAGE = string.upper(message) --大写(用于匹配)
				local GLOBAL_FILTER_TEXT = hVar.tab_filtertext
				for i = #GLOBAL_FILTER_TEXT, 1, -1 do
					local strFilter = GLOBAL_FILTER_TEXT[i]
					local nLength = hApi.GetStringEmojiENLength(strFilter, 1, 1) --Unicode长度
					while true do
						local pos = string.find(MESSAGE, strFilter)
						if (pos ~= nil) then
							local strRep = string.rep("*", nLength)
							--message = string.gsub(message, strFilter, strRep)
							if ((pos + #strFilter - 1) < #message) then --不是最后一个字符
								message = string.sub(message, 1, pos - 1) .. strRep .. string.sub(message, (pos + #strFilter - 1) + 1, #message)
							else --最后一个字符
								message = string.sub(message, 1, pos - 1) .. strRep
							end
							
							MESSAGE = string.upper(message) --大写(用于匹配)
						else
							break
						end
					end
				end
				
				--最后转小写
				--message = string.lower(message)
				
				--清空文字
				rgName = ""
				enterNameEditBox:setText("")
				
				--检测是否刷屏
				if (LuaCheckChatMessageIsFloodScreen(g_curPlayerName, current_chat_type, message) == 1) then
					--冒字
					--local strText = "您的聊天内容在短时间内已重复多次，不能发送" --language
					local strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_FLOOD_SCREEN"] --language
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
				
				--检测是否发言过快
				if (LuaCheckChatMessageIsTooFast(g_curPlayerName, current_chat_type, message) == 1) then
					--冒字
					--local strText = "您的聊天频率在短时间内过快，不能发送" --language
					local strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_TOO_FAST"] --language
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
				
				if (message ~= "") then
					--[[
					--测试 --test
					message = "一二三四五六七八九十一二三四五六七八九十"
					]]
					
					--请求发送消息（组队聊天）
					local msgType = hVar.MESSAGE_TYPE.TEXT --文本消息
					--print(current_chat_type, msgType, message, touid)
					SendGroupCmdFunc["chat_send_message"](current_chat_type, msgType, message, touid, tolist)
					
					--本地添加一条发送消息记录（防刷屏）
					LuaAddtRecentChatMsg(g_curPlayerName, current_chat_type, message)
				end
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnSendMessageCouple"
		--发送按钮的文字"发送"(组队)
		_frmNode.childUI["btnSendMessageCouple"].childUI["sendNoLimit"] = hUI.label:new({
			parent = _frmNode.childUI["btnSendMessageCouple"].handle._n,
			x = -4,
			y = -1,
			align = "MC",
			font = hVar.FONTC,
			size = 28,
			text = hVar.tab_string["__TEXT_SEND"], --"发送"
			border = 1,
			--RGB = {255, 255, 0,},
		})
		
		--查询的菊花
		_frmNode.childUI["waiting"] = hUI.button:new({ --作为按钮是为了挂载子控件
			parent = _BTC_pClipNodeCouple,
			x = _BTC_PageClippingRectWorld[1] + _BTC_PageClippingRectWorld[3]/2,
			y = _BTC_PageClippingRectWorld[2] - _BTC_PageClippingRectWorld[4]/2,
			z = 1,
			--label = {x = 0, y = -1, align = "MC", font = hVar.FONTC, size = 24, text = "重新连接", border = 1,},
			--model = "UI:PANEL_MENU_BTN_BIG", --"UI:SkillSlot",
			model = "misc/mask_white.png",
			--dragbox = _frm.childUI["dragBox"],
			w = 310,
			h = 120,
			--scaleT = 0.95,
			--code = function()
			--
			--end,
		})
		_frmNode.childUI["waiting"].handle.s:setColor(ccc3(128, 128, 128))
		_frmNode.childUI["waiting"].handle.s:setOpacity(64)
		_frmNode.childUI["waiting"]:setstate(-1) --默认隐藏
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "waiting"
		--查询的文字
		_frmNode.childUI["waiting"].childUI["text"] = hUI.label:new({
			parent = _frmNode.childUI["waiting"].handle._n,
			x = 0,
			y = 0,
			font = hVar.FONTC,
			align = "MC",
			size = 20,
			width = 500,
			text = "", --"正在连接中..."
			RGB = {212, 212, 212,},
		})
		
		--添加监听
		--添加移除事件监听：横竖屏切换
 		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenAchievement_", on_spine_screen_event)
		--添加事件监听：收到工会服务器socket连接结果回调
		hGlobal.event:listen("LocalEvent_Group_NetEvent", "__GroupServerConnectBack_", on_receive_grouperver_connect_back_event)
		--添加事件监听：收到工会服务器登陆结果回调
		hGlobal.event:listen("LocalEvent_Group_LogEvent", "__GroupServerLoginBack_", on_receive_group_server_login_back_event)
		--添加事件监听：收到聊天模块初始化事件
		hGlobal.event:listen("LocalEvent_Group_ChatInitEvent", "__GroupServerChatInitBack_", on_receive_chat_init_event)
		--添加事件监听：收到聊天消息id事件
		hGlobal.event:listen("LocalEvent_Group_ChatIDListEvent", "__GroupServerChatIDListBack_", on_receive_chat_id_list_event)
		--添加事件监听：收到聊天消息内容事件
		hGlobal.event:listen("LocalEvent_Group_ChatContentListEvent", "__GroupServerChatContentListBack_", on_receive_chat_content_list_event)
		--添加事件监听：收到单条聊天消息事件
		hGlobal.event:listen("LocalEvent_Group_SingleChatMessageEvent", "__SingleChatMessageBack_", on_receive_single_chat_message_event)
		--添加事件监听：收到更新单条聊天消息事件
		hGlobal.event:listen("LocalEvent_Group_UpdatChatMessageEvent", "__UpdateChatMessageBack_", on_receive_update_chat_message_event)
		--添加事件监听：收到删除聊天消息事件
		hGlobal.event:listen("LocalEvent_Group_RemoveChatMessageEvent", "__RemoveChatMessageBack_", on_receive_remove_chat_message_event)
		--添加事件监听：收到被禁言的通知事件
		hGlobal.event:listen("LocalEvent_Group_ChatForbiddenEvent", "__ChatForbiddenBack_", on_receive_chat_forbidden_event)
		--添加事件监听：收到发起私聊请求的结果返回
		hGlobal.event:listen("LocalEvent_Group_PrivateInviteChatEvent", "__ChatPrivateInviteBack_", on_receive_chat_private_invite_event)
		--添加事件监听：收到工会操作结果返回
		hGlobal.event:listen("LocalEvent_Group_OperationRet", "__GroupOperationRetBack_", on_receive_group_result_event)
		--添加事件监听：收到加入军团邀请函结果返回
		hGlobal.event:listen("localEvent_GroupInviteJoinBack", "__GroupInviteRetBack_", on_receive_group_invite_back_event)
		--添加监听：程序进入后台的回调
		hGlobal.event:listen("LocalEvent_AppEnterBackground", "__ChatMessageBack_", on_app_enter_background_event)
		--添加监听：游戏局结束事件
		hGlobal.event:listen("LocalEvent_GameOver", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（夺塔奇兵）
		hGlobal.event:listen("LocalEvent_GameOver_PVP", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（魔龙宝库）
		hGlobal.event:listen("LocalEvent_GameOver_PVP_Endless", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（铜雀台）
		hGlobal.event:listen("LocalEvent_GameOver_PVP_Endless_Singlebattle", "__ChatGameEnd_", on_game_end_event)
		--添加监听：游戏局结束事件（新手地图）
		hGlobal.event:listen("LocalEvent_GameOver_NewGuideMap", "__ChatGameEnd_", on_game_end_event)
		--添加监听：PVP等待其他玩家事件
		hGlobal.event:listen("LocalEvent_Pvp_Delay_Player", "__ChatPVPWaitPlayer_", on_pvp_wait_player_event)
		--添加监听：PVP本地长时间未响应事件
		hGlobal.event:listen("LocalEvent_Pvp_LocalNoHeart", "__ChatPVPLocalNoHeart_", on_pvp_local_noheart_event)
		--添加监听：安卓本地掉线事件
		hGlobal.event:listen("LocalEvent_showAndroidNetAlreadyFrm", "__ChatAndroidDisconnect_", on_android_local_disconnect_event)
		--添加事件监听：切换剧情地图场景事件
		hGlobal.event:listen("LocalEvent_Battle_SwitchGame", "__BattleSwitchGameBack_chat2", on_game_end_event)
		--添加事件监听：切换pvp场景事件
		hGlobal.event:listen("LocalEvent_Pvp_SwitchGame", "__PVPSwitchGameBack_chat2", on_game_end_event)
		--添加事件监听：切换pvp匹配房场景事件
		hGlobal.event:listen("LocalEvent_Pvp_Match_SwitchGame", "__MatchSwitchGameBack_chat2", on_game_end_event)
		
		--私聊
		--添加监听：收到增加单个私聊好友
		hGlobal.event:listen("LocalEvent_Group_PrivateFriendAddEvent", "__ChatPrivateFriendAddBack_", on_add_private_friend_event)
		--添加监听：收到删除单个私聊好友
		hGlobal.event:listen("LocalEvent_Group_PrivateFriendRemoveEvent", "__ChatPrivateFriendRemoveBack_", on_remove_private_friend_event)
		
		--刷新滚动的timer（组队消息）
		--hApi.addTimerForever("__CHATFRAME_PRIVATE_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_chatframe_scroll_private_loop)
		hApi.addTimerForever("__CHATFRAME_WORLD_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_chatframe_scroll_world_loop)
		--刷新红包领取倒计时的timer
		hApi.addTimerForever("__CHATFRAME_REDPACKET_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 1000, refresh_chat_redpacket_loop)
		--自动连接工会服务器的timer
		hApi.addTimerForever("__CHATAUTOLINK_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 5000, refresh_chatframe_autolink_loop)
		--异步绘制聊天消息的timer
		hApi.addTimerForever("__CHATPAINT_MESSAGE_ASYNC__", hVar.TIMER_MODE.GAMETIME, 1, refresh_async_paint_message_loop)
		
		--[[
		--测试 --test
		--发起查询，1元档商品信息
		--SendCmdFunc["iap_sale_gift"]()
		--依次绘制每条消息
		local tChatMsgList =
		{
			{msgId = 1, name = "adidas先生", date = "00:00:01", content = "¡¡¡¡¡¡¡¡¡¡",},
			{msgId = 1, name = "游客", date = "10:03:23", content = "||||||||||",},
			{msgId = 1, name = "游客21000001", date = "12:00:59", content = "}}}}}}}}}}",},
			{msgId = 1, name = "GUEST", date = "13:07:23", content = "^^^^^^^^^^",},
			{msgId = 1, name = "diaoxian", date = "14:23:00", content = "\\\\\\\\\\\\\\\\\\\\",},
			{msgId = 1, name = "u123123", date = "15:46:33", content = "~~~~~~~~~~",},
			{msgId = 1, name = "我是你的发", date = "16:54:47", content = "``````````",},
			{msgId = 1, name = "爱情", date = "18:03:09", content = "爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了爱死你了",},
			{msgId = 1, name = "掉线", date = "20:33:12", content = ">>>>>>>>>>",},
			{msgId = 1, name = "打老师345", date = "23:24:32", content = "加群 qq:19900000",},
		}
		current_DLCMap_max_num = #tChatMsgList
		--依次绘制消息
		for i = 1, 10, 1 do
			on_create_single_message_UI(tChatMsgList[i], i)
		end
		]]
		
		
		--[[
		--获得一个加速度，使右边自动往上滚动
		--超过一页的数量才滑屏
		if (current_DLCMap_max_num > (WEAPON_X_NUM * WEAPON_Y_NUM)) then
			--向上滚屏
			b_need_auto_fixing_dlcmapinfo = true
			friction_dlcmapinfo = 0
			friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
			draggle_speed_y_dlcmapinfo = MAX_SPEED / 1.0 --正速度
		end
		]]
		
		--挡操作
		--hUI.NetDisable(30000)
		
		--发起登入工会服务器操作
		--print("发起登入工会服务器操作")
		--print("发起登入工会服务器操作", Group_Server:GetState())
		if (Group_Server:GetState() == 1) then --不重复登入
			--模拟触发连接工会服务socket结果回调
			--print("模拟触发连接工会服务socket结果回调")
			on_receive_grouperver_connect_back_event(1)
		else
			--连接
			--print("Group_Server:Connect()")
			Group_Server:Connect()
		end
	end
	
	--函数：横竖屏切换
	on_spine_screen_event = function()
		local cCallback = current_tCallback
		local _frm = hGlobal.UI.ChatDialogueFrm
		--local _frmNode = _frm.childUI["PageNode"]
		--local _parentNode = _frm.handle._n
		
		--关闭本界面
		_frm.childUI["closeBtn"].data.code()
		
		--重绘本界面
		hGlobal.UI.InitChatDialogueFrm("reload") --测试

		--触发事件，显示任务界面
		hGlobal.event:event("LocalEvent_Phone_ShowChatDialogue", nil, current_tCallback)
	end

	--函数：收到工会服务器连接socket结果返回
	on_receive_grouperver_connect_back_event = function(net_state)
		--print("收到工会服务器连接socket结果返回", net_state)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--标记工会服务器连接socket状态
		--current_connect_state = net_state
		
		if (net_state == 1) then
			--更新菊花
			if _frmNode.childUI["waiting"] then
				_frmNode.childUI["waiting"]:setstate(-1) --已联网不显示菊花
			end
			
			--发送工会服务器登陆请求
			--print("发送工会服务器登陆请求", hGlobal.LocalPlayer:getonline())
			if (Group_Server:getonline() == 1) then --不重复登陆
				--模拟触发收到登入结果回调
				--print("模拟触发收到登入结果回调")
				on_receive_group_server_login_back_event(1)
			else
				--print("Group_Server:UserLogin()")
				Group_Server:UserLogin()
			end
		else
			--失败
			--取消挡操作
			--hUI.NetDisable(0)
			--清空右侧控件
			--_removeRightFrmFunc()
			--清空消息数量
			--current_DLCMap_max_num = 0
			
			--更新菊花
			if _frmNode.childUI["waiting"] then
				_frmNode.childUI["waiting"]:setstate(1)
				_frmNode.childUI["waiting"].childUI["text"]:setText(hVar.tab_string["ios_err_network_cannot_conn"]) --"不能连接到网络"
			end
		end
	end
	
	--函数：收到工会服务器登陆结果返回
	on_receive_group_server_login_back_event = function(iResult)
		--print("收到工会服务器登陆结果返回", iResult)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--标记工会服务器登陆状态
		--current_login_state = net_state
		
		if (iResult == 1) then
			--更新菊花
			if _frmNode.childUI["waiting"] then
				_frmNode.childUI["waiting"]:setstate(-1) --已联网不显示菊花
			end
			
			--优化: 为避免每次打开界面，都要等待一会才刷新界面，这里用上次数据来预先绘制
			if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
				--模拟收到聊天消息内容
				--on_receive_chat_content_list_event(current_chat_type, current_msg_private_friend_last_uid, 0, nil)
			elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
				--
			elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
				--
			elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
				--
			elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
				--
			end
			
			--添加查询超时一次性timer
			hApi.addTimerOnce("__ONCE_CHAT_TIMEOUNT_TIMER__", 5000, refresh_chatnet_timeout_timer)
			
			--请求查询玩家聊天基础信息(剩余次数、禁言等状态)
			SendGroupCmdFunc["chat_init"]()
			--print("请求查询聊天id列表")
		else
			--失败
			--取消挡操作
			--hUI.NetDisable(0)
			--清空右侧控件
			--_removeRightFrmFunc()
			--清空消息数量
			--current_DLCMap_max_num = 0
			
			--更新菊花
			if _frmNode.childUI["waiting"] then
				_frmNode.childUI["waiting"]:setstate(1)
				_frmNode.childUI["waiting"].childUI["text"]:setText(hVar.tab_string["ios_err_network_cannot_conn"]) --"不能连接到网络"
			end
		end
	end
	
	--函数：收到聊天模块初始化事件返回
	on_receive_chat_init_event = function(version, debug_version, world_flag, msgWorldNum, strWorldTime, lastWorldMsgId, lastGroupMsgId, forbidden, strForbiddenTime, forbidden_minute, forbidden_op_uid, groupId, groupLevel, invite_group_list, msg_private_friend_chat_list, msg_private_friend_last_uid, send_redpacket_num, last_send_redpacket_time)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		--print("收到聊天模块初始化事件返回", version, debug_version, world_flag, msgWorldNum, strWorldTime, lastWorldMsgId, lastGroupMsgId, forbidden, strForbiddenTime, forbidden_minute, forbidden_op_uid, groupId, groupLevel, invite_group_list, msg_private_friend_chat_list, msg_private_friend_last_uid, send_redpacket_num, last_send_redpacket_time)
		
		--存储数据
		current_msgWorldFlag = world_flag --世界聊天开关状态
		current_msgWorldNum = msgWorldNum --世界聊天今日次数
		current_msgWorldTime = strWorldTime --最近一次世界聊天时间(服务器时间)
		current_msgForbidden = forbidden --是否禁言
		current_msgForbiddenTime = strForbiddenTime --上次禁言时间(服务器时间)
		current_msgForbidden_minute = forbidden_minute --禁言时长（单位: 分钟）
		current_msgForbidden_op_uid = forbidden_op_uid --禁言的操作者uid
		current_msgGroupId = groupId --玩家所在的军团id
		current_msgGroupLevel = groupLevel --玩家所在的军团权限
		current_msgInvite_group_list = invite_group_list --军团邀请函id表
		current_msgPrivate_friend_chat_list = msg_private_friend_chat_list --私聊好友列表
		current_msg_private_friend_last_uid = msg_private_friend_last_uid -- 私聊最近一次好友的uid
		current_group_send_redpacket_num = send_redpacket_num --今日发送军团红包的次数
		current_last_group_send_redpacket_time = last_send_redpacket_time --最近依次发送军团红包的时间
		
		--[[
		--测试 --test
		current_msgPrivate_friend_chat_list[2] = current_msgPrivate_friend_chat_list[1]
		current_msgPrivate_friend_chat_list[3] = current_msgPrivate_friend_chat_list[1]
		current_msgPrivate_friend_chat_list[4] = current_msgPrivate_friend_chat_list[1]
		current_msgPrivate_friend_chat_list[5] = current_msgPrivate_friend_chat_list[1]
		current_msgPrivate_friend_chat_list[6] = current_msgPrivate_friend_chat_list[1]
		current_msgPrivate_friend_chat_list[7] = current_msgPrivate_friend_chat_list[1]--2]
		current_msgPrivate_friend_chat_list[8] = current_msgPrivate_friend_chat_list[1]--2]
		current_msgPrivate_friend_chat_list[9] = current_msgPrivate_friend_chat_list[1]--2]
		current_msgPrivate_friend_chat_list[10] = current_msgPrivate_friend_chat_list[1]--]
		current_msgPrivate_friend_chat_list[11] = current_msgPrivate_friend_chat_list[1]--]
		current_msgPrivate_friend_chat_list[12] = current_msgPrivate_friend_chat_list[1]--]
		current_msgPrivate_friend_chat_list[13] = current_msgPrivate_friend_chat_list[1]--]
		current_msgPrivate_friend_chat_list[14] = current_msgPrivate_friend_chat_list[1]--]
		--]]
		
		--移除超时检测timer
		hApi.clearTimer("__ONCE_CHAT_TIMEOUNT_TIMER__")
		
		--如果版本号过低，不能使用聊天
		--检测pvp版本号，是否为最新版本
		local local_srcVer = tostring(hVar.CURRENT_ITEM_VERSION) --1.0.070502
		local group_control = tostring(version) --1.0.070502-v018-018-app
		if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员，显示具体的版本号
			group_control = tostring(debug_version) --1.0.070502-v018-018-app
		end
		local vbpos = string.find(group_control, "-")
		if vbpos then
			group_control = string.sub(group_control, 1, vbpos - 1)
		end
		--print("版本号", local_srcVer, group_control)
		--如果pvp版本号不一致，弹框
		if (local_srcVer < group_control) then
			--清空全部右侧内容
			_removeRightFrmFunc()
			
			--显示菊花和提示文字
			--更新菊花
			if _frmNode.childUI["waiting"] then
				_frmNode.childUI["waiting"]:setstate(1)
				_frmNode.childUI["waiting"].childUI["text"]:setText(hVar.tab_string["__TEXT_ScriptsTooOld"]) --提示更新
			end
			
			return false
		end
		
		--查询聊天内容的对方好友uid
		local friendUid = 0
		
		--更新聊天界面
		if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
			--更新今日可发送世界聊天的次数
			local leftChatMsgNum = -1 --今日剩余聊天次数
			local vip = LuaGetPlayerVipLv() or 0
			local chatWorldMsgNum = hVar.Vip_Conifg.chatWorldMsgNum[vip] or -1
			if (chatWorldMsgNum > 0) then --有次数限制
				leftChatMsgNum = chatWorldMsgNum - current_msgWorldNum
				if (leftChatMsgNum < 0) then
					leftChatMsgNum = 0
				end
			end
			if (leftChatMsgNum >= 0) then --有限制
				--世界聊天的按钮
				if _frmNode.childUI["btnSendMessageWorld"] then
					_frmNode.childUI["btnSendMessageWorld"].childUI["sendNoLimit"].handle._n:setVisible(false) --无限制
					
					_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"].handle._n:setVisible(true) --有限制
					_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"]:setText(hVar.tab_string["__TEXT_SEND"] .. " (" .. leftChatMsgNum .. ")") --"发送(??)"
					if (leftChatMsgNum > 0) then
						_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"].handle.s:setColor(ccc3(255, 255, 0))
					else
						_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"].handle.s:setColor(ccc3(212, 212, 212)) --灰掉
					end
				end
			else
				--世界聊天的按钮
				if _frmNode.childUI["btnSendMessageWorld"] then
					_frmNode.childUI["btnSendMessageWorld"].childUI["sendNoLimit"].handle._n:setVisible(true) --无限制
					_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"].handle._n:setVisible(false) --有限制
				end
			end
			
			--世界聊天，不需要对方好友uid
			friendUid = 0
		elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
			--
		elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			--删除之前的私聊好友列表（按管理员最大人数截断）
			for i = 1, hVar.CHAT_MAX_USERNUM_PRIVATE_GM, 1 do
				local ctrli = _frmNode.childUI["DLCMapInfoNodeFriend" .. i]
				if ctrli then
					--删除控件
					hApi.safeRemoveT(_frmNode.childUI, "DLCMapInfoNodeFriend" .. i)
					--print("删除控件", i)
					
					--删除 rightRemoveFrmList 存储标记
					for j = 1, #rightRemoveFrmList, 1 do
						if (rightRemoveFrmList[j] == ("DLCMapInfoNodeFriend" .. i)) then
							--print("删除 rightRemoveFrmList 存储标记", j, rightRemoveFrmList[j])
							table.remove(rightRemoveFrmList, j)
							break
						end
					end
				end
			end
			
			--清空私聊好友数量
			current_DLCMap_friend_max_num = 0
			
			--依次绘制新的私聊好友列表
			for i = 1, #current_msgPrivate_friend_chat_list, 1 do
				local tFriend = current_msgPrivate_friend_chat_list[i]
				local touid = tFriend.touid --好友uid
				local online = tFriend.online --好友是否在线
				local toname = tFriend.toname --好友玩家名
				local tochannelId = tFriend.tochannelId --好友渠道号
				local tovip = tFriend.tovip --好友vip等级
				local toborderId = tFriend.toborderId --好友边框id
				local toiconId = tFriend.toiconId --好友头像id
				local tochampionId = tFriend.tochampionId --好友称号id
				local toleaderId = tFriend.toleaderId --好友会长权限
				local todragonId = tFriend.todragonId --好友聊天龙王id
				local toheadId = tFriend.toleaderId --好友头衔id
				local tolineId = tFriend.tolineId --好友线索id
				
				--创建私聊好友头像
				on_create_single_friend_UI(tFriend, i)
				
				--标记私聊好友数量加1
				current_DLCMap_friend_max_num = current_DLCMap_friend_max_num + 1
			end
			
			--默认选中上次的私聊好友
			local lastIndex = 0
			for i = 1, #current_msgPrivate_friend_chat_list, 1 do
				local tFriend = current_msgPrivate_friend_chat_list[i]
				local touid = tFriend.touid --好友uid
				local online = tFriend.online --好友是否在线
				local toname = tFriend.toname --好友玩家名
				local tochannelId = tFriend.tochannelId --好友渠道号
				local tovip = tFriend.tovip --好友vip等级
				local toborderId = tFriend.toborderId --好友边框id
				local toiconId = tFriend.toiconId --好友头像id
				local tochampionId = tFriend.tochampionId --好友称号id
				local toleaderId = tFriend.toleaderId --好友会长权限
				local todragonId = tFriend.todragonId --好友聊天龙王id
				local toheadId = tFriend.toheadId --好友头衔id
				local tolineId = tFriend.tolineId --好友线索id
				
				--找到上次私聊的好友uid
				if (touid == current_msg_private_friend_last_uid) then
					lastIndex = i --找到了
					break
				end
			end
			--没找到
			if (lastIndex == 0) then
				--默认选中第一个好友
				if (#current_msgPrivate_friend_chat_list > 0) then
					lastIndex = 1
				end
			end
			
			--选中私聊好友
			if (lastIndex > 0) then
				--标记待查询的私聊对方好友uid
				friendUid = current_msgPrivate_friend_chat_list[lastIndex].touid
			else --没有私聊好友
				--清空私聊好友
				current_msg_private_friend_last_uid = 0
				
				--隐藏正在私聊的好友的提示界面
				_frmNode.childUI["DLCMapInfoNowFriendBG"].handle._n:setVisible(false)
				_frmNode.childUI["DLCMapInfoNowFriendLabel"].handle._n:setVisible(false)
				_frmNode.childUI["DLCMapInfoNowFriendCloseBtn"]:setstate(-1)
			end
			
			--私聊好友在屏幕外需要自动滑动
			--print("lastIndex=", lastIndex)
			if (lastIndex > 0) then
				--lastIndex = 6 --测试 --test
				if (lastIndex == 6) then
					b_need_auto_fixing_friendinfo = true
					friction_friendinfo = 0
					friction_friendinfo_coefficient = 0.5 --衰减系数(默认值)
					draggle_speed_x_friendinfo = -MAX_SPEED / 5
				elseif (lastIndex >= 7) and (lastIndex <= 10) then
					b_need_auto_fixing_friendinfo = true
					friction_friendinfo = 0
					friction_friendinfo_coefficient = 0.5 --衰减系数(默认值)
					draggle_speed_x_friendinfo = -MAX_SPEED * 1.09
				elseif (lastIndex >= 11) and (lastIndex <= 15) then
					b_need_auto_fixing_friendinfo = true
					friction_friendinfo = 0
					friction_friendinfo_coefficient = 0.5 --衰减系数(默认值)
					draggle_speed_x_friendinfo = -MAX_SPEED * 1.818
				elseif (lastIndex >= 16) and (lastIndex <= 20) then
					b_need_auto_fixing_friendinfo = true
					friction_friendinfo = 0
					friction_friendinfo_coefficient = 0.25 --衰减系数(默认值)
					draggle_speed_x_friendinfo = -MAX_SPEED * 1.922
				elseif (lastIndex >= 21) and (lastIndex <= 25) then
					b_need_auto_fixing_friendinfo = true
					friction_friendinfo = 0
					friction_friendinfo_coefficient = 0.14 --衰减系数(默认值)
					draggle_speed_x_friendinfo = -MAX_SPEED * 1.934
				elseif (lastIndex >= 26) and (lastIndex <= 30) then
					b_need_auto_fixing_friendinfo = true
					friction_friendinfo = 0
					friction_friendinfo_coefficient = 0.14 --衰减系数(默认值)
					draggle_speed_x_friendinfo = -MAX_SPEED * 2.254
				end
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
			--军团聊天，对方为军团id
			friendUid = current_msgGroupId
		elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
			--组队聊天，对方为游戏局id
			local sessionId = 0
			local world = hGlobal.WORLD.LastWorldMap
			if world then
				--PVP单人地图也不需要显示组队分页
				if (world.data.tdMapInfo.isNoWaitFrame ~= true) then --不是不等待同步帧模式
					sessionId = world.data.session_dbId
					--sessionId = 10000
				end
			end
			friendUid = sessionId
		end
		
		--添加查询超时一次性timer
		hApi.addTimerOnce("__ONCE_CHAT_TIMEOUNT_TIMER__", 5000, refresh_chatnet_timeout_timer)
		
		--如果本次查询的是管理员指定军团id的聊天信息，那么发送不同的指令
		if (current_groupId_gm > 0) then
			--请求查询聊天id列表（仅管理员可操作）
			SendGroupCmdFunc["chat_get_id_list_group_gm"](current_chat_type, current_groupId_gm)
		else
			--请求查询聊天id列表
			SendGroupCmdFunc["chat_get_id_list"](current_chat_type, friendUid)
		end
		--print("请求查询聊天id列表",current_chat_type, friendUid)
	end
	
	--函数：收到聊天消息id列表事件返回
	on_receive_chat_id_list_event = function(chatType, friendUid, msgNum, msgIDList)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		--print("收到聊天消息id列表事件返回", chatType, friendUid, msgNum, msgIDList)
		
		--移除超时检测timer
		hApi.clearTimer("__ONCE_CHAT_TIMEOUNT_TIMER__")
		
		--取消挡操作
		--hUI.NetDisable(0)
		--隐藏菊花
		if _frmNode.childUI["waiting"] then
			_frmNode.childUI["waiting"]:setstate(-1) --已联网不显示菊花
		end
		
		--如果收到的消息id不是本分页聊天频道，不处理
		if (current_chat_type ~= chatType) then
			return
		end
		
		--待查询消息内容的id列表
		local queryIDList = {}
		
		if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
			--存储世界聊天消息id列表
			current_msg_id_list_world = msgIDList
			
			--如果是首次打开世界聊天，末尾加上特殊id-1，表示是聊天忠告信息
			if (not current_IsAdviseWorld) then
				current_nAdviseMsgPrev = msgIDList[#msgIDList] --标记前一个消息id
				current_IsAdviseWorld = true --标记已处理聊天忠告
				
				--设置世界聊天的新收到的消息id
				LuaSetChatWorldReceiveMsgId(g_curPlayerName, -1*current_nAdviseMsgPrev)
				
				msgNum = msgNum + 2
				msgIDList[#msgIDList+1] = -2
				msgIDList[#msgIDList+1] = -1
			else
				--聊天忠告放到前一条消息的后面
				--print(current_nAdviseMsgPrev)
				for i = 1, msgNum, 1 do
					local msgId = msgIDList[i]
					--print("msgId=", msgId)
					if (msgId == current_nAdviseMsgPrev) then
						table.insert(msgIDList, i+1, -2)
						table.insert(msgIDList, i+2, -1)
						msgNum = msgNum + 2
						--print("找到了", current_nAdviseMsgPrev)
						
						local receive_msgid = LuaGetChatWorldReceiveMsgId(g_curPlayerName)
						if (receive_msgid == msgId) then
							--设置世界聊天的新收到的消息id
							LuaSetChatWorldReceiveMsgId(g_curPlayerName, -1*current_nAdviseMsgPrev)
						end
						
						break
					end
				end
			end
			
			--检测本地缓存的世界聊天历史聊天消息，哪些id是没有的
			for i = 1, msgNum, 1 do
				local msgId = msgIDList[i]
				--print(i, "msgId=", msgId)
				if (current_chat_msg_hostory_cache_world[msgId] == nil) then
					queryIDList[#queryIDList+1] = msgId
					--print("查询世界消息", msgId)
				end
			end
			
			--删除本地缓存的世界聊天历史记录无用的项
			for k, v in pairs(current_chat_msg_hostory_cache_world) do
				local bExisted = false
				for m = 1, #current_msg_id_list_world, 1 do
					if (current_msg_id_list_world[m] == k) then
						bExisted = true --找到了
						break
					end
				end
				if (not bExisted) then
					current_chat_msg_hostory_cache_world[k] = nil
					--print("删除世界消息", k)
				end
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
			--邀请频道，如果本地已处理了军邀请函消息，那么这些消息不需要再显示了
			
			--读取玩家已处理的军团邀请函id列表
			local tList = LuaGetInviteGroupIdList(g_curPlayerName)
			for it = 1, #tList, 1 do
				local msgId_it = tList[it] --已处理的消息id
				--print(msgId_it)
				for j = 1, #msgIDList, 1 do
					--print("msgIDListm", msgIDList[j])
					if (msgIDList[j] == msgId_it) then --找到了
						table.remove(msgIDList, j)
						break
					end
				end
			end
			
			--存储邀请聊天消息id列表
			current_msg_id_list_invite = msgIDList
			
			--检测本地缓存的邀请聊天历史聊天消息，哪些id是没有的
			for i = 1, msgNum, 1 do
				local msgId = msgIDList[i]
				--print(i, "msgId=", msgId)
				if (current_chat_msg_hostory_cache_invite[msgId] == nil) then
					queryIDList[#queryIDList+1] = msgId
					--print("查询邀请消息", msgId)
				end
			end
			
			--删除本地缓存的邀请聊天历史记录无用的项
			for k, v in pairs(current_chat_msg_hostory_cache_invite) do
				local bExisted = false
				for m = 1, #current_msg_id_list_invite, 1 do
					if (current_msg_id_list_invite[m] == k) then
						bExisted = true --找到了
						break
					end
				end
				if (not bExisted) then
					current_chat_msg_hostory_cache_invite[k] = nil
					--print("删除邀请消息", k)
				end
			end
			
			--邀请频道，只要有未处理的邀请函都需要叹号
			--更新叹号
			on_update_notice_tanhao()
		elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			--标记当前正在私聊的好友uid
			current_msg_private_friend_last_uid = friendUid
			
			--选中私聊好友
			local friendIdx = 0
			for i = 1, #current_msgPrivate_friend_chat_list, 1 do
				local tFriend = current_msgPrivate_friend_chat_list[i]
				local touid = tFriend.touid --好友uid
				local online = tFriend.online --好友是否在线
				local toname = tFriend.toname --好友玩家名
				local tochannelId = tFriend.tochannelId --好友渠道号
				local tovip = tFriend.tovip --好友vip等级
				local toborderId = tFriend.toborderId --好友边框id
				local toiconId = tFriend.toiconId --好友头像id
				local tochampionId = tFriend.tochampionId --好友称号id
				local toleaderId = tFriend.toleaderId --好友会长权限
				local todragonId = tFriend.todragonId --好友聊天龙王id
				local toheadId = tFriend.toheadId --好友头衔id
				local tolineId = tFriend.tolineId --好友线索id
				
				--找到上次私聊的好友uid
				if (touid == friendUid) then
					friendIdx = i --找到了
					break
				end
			end
			--选中私聊好友
			if (friendIdx > 0) then
				OnSelectedPrivateFriend(friendIdx)
			end
			
			--存储私聊消息id列表
			current_msgPrivate_msg_id_list[friendUid] = msgIDList
			
			--遍历私聊好友消息列表，检查是否存在此消息内容
			local tChatMsgFriendList = current_msgPrivate_msg_hostory_cache[friendUid]
			if (tChatMsgFriendList == nil) then --初始化
				tChatMsgFriendList = {}
				current_msgPrivate_msg_hostory_cache[friendUid] = tChatMsgFriendList
			end
			for i = 1, msgNum, 1 do
				local msgId = msgIDList[i]
				--print(i, "msgId=", msgId)
				if (tChatMsgFriendList[msgId] == nil) then
					queryIDList[#queryIDList+1] = msgId
					--print("查询私聊消息", msgId)
				end
			end
			
			--删除本地缓存的私聊消息历史记录无用的项
			for k, v in pairs(tChatMsgFriendList) do
				local bExisted = false
				for m = 1, #msgIDList, 1 do
					if (msgIDList[m] == k) then
						bExisted = true --找到了
						break
					end
				end
				if (not bExisted) then
					tChatMsgFriendList[k] = nil
					--print("删除私聊消息", k)
				end
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
			--存储军团聊天消息id列表
			current_msg_id_list_group = msgIDList
			
			--检测本地缓存的军团聊天历史聊天消息，哪些id是没有的
			for i = 1, msgNum, 1 do
				local msgId = msgIDList[i]
				--print(i, "msgId=", msgId)
				if (current_chat_msg_hostory_cache_group[msgId] == nil) then
					queryIDList[#queryIDList+1] = msgId
					--print("查询军团消息", msgId)
				end
			end
			
			--删除本地缓存的军团聊天历史记录无用的项
			for k, v in pairs(current_chat_msg_hostory_cache_group) do
				local bExisted = false
				for m = 1, #current_msg_id_list_group, 1 do
					if (current_msg_id_list_group[m] == k) then
						bExisted = true --找到了
						break
					end
				end
				if (not bExisted) then
					current_chat_msg_hostory_cache_group[k] = nil
					--print("删除军团消息", k)
				end
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
			--存储组队聊天消息id列表
			current_msg_id_list_couple = msgIDList
			
			--检测本地缓存的组队聊天历史聊天消息，哪些id是没有的
			for i = 1, msgNum, 1 do
				local msgId = msgIDList[i]
				--print(i, "msgId=", msgId)
				if (current_chat_msg_hostory_cache_couple[msgId] == nil) then
					queryIDList[#queryIDList+1] = msgId
					--print("查询组队消息", msgId)
				end
			end
			
			--删除本地缓存的组队聊天历史记录无用的项
			for k, v in pairs(current_chat_msg_hostory_cache_couple) do
				local bExisted = false
				for m = 1, #current_msg_id_list_couple, 1 do
					if (current_msg_id_list_couple[m] == k) then
						bExisted = true --找到了
						break
					end
				end
				if (not bExisted) then
					current_chat_msg_hostory_cache_couple[k] = nil
					--print("删除组队消息", k)
				end
			end
		end
		
		--存在待查询的消息id，发送请求
		if (#queryIDList > 0) then
			--添加查询超时一次性timer
			hApi.addTimerOnce("__ONCE_CHAT_TIMEOUNT_TIMER__", 5000, refresh_chatnet_timeout_timer)
			
			--获取指定聊天消息id列表的内容
			if (#queryIDList <= hVar.CHAT_MAX_LENGTH_WORLD) then
				--如果本次查询的是管理员指定军团id的聊天信息，那么发送不同的指令
				if (current_groupId_gm > 0) then
					--消息数量在可控范围内（仅管理员可操作）
					SendGroupCmdFunc["chat_get_content_list_group_gm"](current_chat_type, friendUid, queryIDList, 1, 1)
				else
					--消息数量在可控范围内
					SendGroupCmdFunc["chat_get_content_list"](current_chat_type, friendUid, queryIDList, 1, 1)
				end
			else
				--消息太多，分批次取消息
				local COUNT = math.ceil(#queryIDList / hVar.CHAT_MAX_LENGTH_WORLD)
				for c = 1, COUNT, 1 do
					local tempList = {}
					for k = 1, hVar.CHAT_MAX_LENGTH_WORLD, 1 do
						local idx = (c - 1) * hVar.CHAT_MAX_LENGTH_WORLD + k
						local msgId = queryIDList[idx]
						if msgId then
							tempList[#tempList+1] = msgId
						end
					end
					--如果本次查询的是管理员指定军团id的聊天信息，那么发送不同的指令
					if (current_groupId_gm > 0) then --（仅管理员可操作）
						SendGroupCmdFunc["chat_get_content_list_group_gm"](current_chat_type, friendUid, tempList, c, COUNT)
					else
						SendGroupCmdFunc["chat_get_content_list"](current_chat_type, friendUid, tempList, c, COUNT)
					end
				end
			end
			--print("获取指定聊天消息id列表的内容")
		else
			--模拟收到聊天消息内容
			on_receive_chat_content_list_event(current_chat_type, friendUid, 0, nil, 1, 1)
			--print("模拟收到聊天消息内容")
		end
		
		--检测是否需要查询某些动态消息，需要更新消息信息
		if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
			--检测本地是否有缓存的支付（土豪）红包消息，需要更新红包消息
			for k, v in pairs(current_chat_msg_hostory_cache_world) do
				local tMsg = v
				local chatType = tMsg.chatType --聊天频道
				local msgId = tMsg.id --消息id
				local msgType = tMsg.msgType --消息类型
				local touid = tMsg.touid --接收者uid
				if (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --发支付（土豪）红包
					--发起查询，更新此消息信息
					local uid = tMsg.uid --消息发送者uid
					local name = tMsg.name --玩家名
					local channelId = tMsg.channelId --渠道号
					local vip = tMsg.vip --vip等级
					local borderId = tMsg.borderId --边框id
					local iconId = tMsg.iconId --头像id
					local championId = tMsg.championId --称号id
					local leaderId = tMsg.leaderId --会长权限
					local dragonId = tMsg.dragonId --聊天龙王id
					local headId = tMsg.headId --头衔id
					local lineId = tMsg.lineId --线索id
					local date = tMsg.date --日期
					local content = tMsg.content --聊天内容
					local touid = tMsg.touid --接收者uid
					local result = tMsg.result --可交互类型消息的操作结果
					local resultParam = tMsg.resultParam --可交互类型消息的参数
					local redPacketParam = tMsg.redPacketParam --红包消息参数
					
					--支付（土豪）红包的红包参数信息
					local redPacketId = redPacketParam.redPacketId --红包唯一id
					local send_uid = redPacketParam.send_uid --红包发送者uid
					local send_name = redPacketParam.send_name --红包发送者名字
					local send_num = redPacketParam.send_num --红包发送数量
					local content = redPacketParam.content --内容
					local money = redPacketParam.money --充值金额
					local iap_id = redPacketParam.iap_id --充值记录id
					local channelId = redPacketParam.channelId --渠道号
					local vipLv = redPacketParam.vipLv --vip等级
					local borderId = redPacketParam.borderId --边框id
					local iconId = redPacketParam.iconId --头像id
					local championId = redPacketParam.championId --称号id
					local leaderId = redPacketParam.leaderId --会长权限
					local dragonId = redPacketParam.dragonId --聊天龙王id
					local headId = redPacketParam.headId --头衔id
					local lineId = redPacketParam.lineId --线索id
					local msg_id = redPacketParam.msg_id --消息id
					local receive_num = redPacketParam.receive_num --红包接收数量
					local send_time = redPacketParam.send_time --红包发送时间
					local expire_time = redPacketParam.expire_time --红包过期时间
					local redPacketReceiveList = redPacketParam.redPacketReceiveList --红包领取uid列表
					--print(expire_time)
					
					--红包未领完才需要更新消息
					if (receive_num < send_num) then --未领完
						--print(chatType, msgId, msgType, touid)
						SendGroupCmdFunc["chat_update_message"](chatType, msgId, touid)
					end
				end
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
			--检测本地是否有军团邀请函消息，需要更新军团邀请函消息
			for k, v in pairs(current_chat_msg_hostory_cache_invite) do
				local tMsg = v
				local chatType = tMsg.chatType --聊天频道
				local msgId = tMsg.id --消息id
				local msgType = tMsg.msgType --消息类型
				local touid = tMsg.touid --接收者uid
				if (msgType == hVar.MESSAGE_TYPE.INVITE_GROUP) then --军团邀请函消息
					--发起查询，更新此消息信息
					--print(chatType, msgId, msgType, touid)
					SendGroupCmdFunc["chat_update_message"](chatType, msgId, touid)
				end
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			--
		elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
			--检测本地是否有缓存的军团红包消息，需要更新红包消息
			for k, v in pairs(current_chat_msg_hostory_cache_group) do
				local tMsg = v
				local chatType = tMsg.chatType --聊天频道
				local msgId = tMsg.id --消息id
				local msgType = tMsg.msgType --消息类型
				local touid = tMsg.touid --接收者uid
				if (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) then --军团发红包
					--发起查询，更新此消息信息
					local uid = tMsg.uid --消息发送者uid
					local name = tMsg.name --玩家名
					local channelId = tMsg.channelId --渠道号
					local vip = tMsg.vip --vip等级
					local borderId = tMsg.borderId --边框id
					local iconId = tMsg.iconId --头像id
					local championId = tMsg.championId --称号id
					local leaderId = tMsg.leaderId --会长权限
					local dragonId = tMsg.dragonId --聊天龙王id
					local headId = tMsg.headId --头衔id
					local lineId = tMsg.lineId --线索id
					local date = tMsg.date --日期
					local content = tMsg.content --聊天内容
					local touid = tMsg.touid --接收者uid
					local result = tMsg.result --可交互类型消息的操作结果
					local resultParam = tMsg.resultParam --可交互类型消息的参数
					local redPacketParam = tMsg.redPacketParam --红包消息参数
					
					--军团红包的红包参数信息
					local redPacketId = redPacketParam.redPacketId --红包唯一id
					local send_uid = redPacketParam.send_uid --红包发送者uid
					local send_name = redPacketParam.send_name --红包发送者名字
					local group_id = redPacketParam.group_id --红包军团id
					local send_num = redPacketParam.send_num --红包发送数量
					local content = redPacketParam.content --内容
					local coin = redPacketParam.coin --游戏币
					local order_id = redPacketParam.order_id --订单号
					local msg_id = redPacketParam.msg_id --消息id
					local receive_num = redPacketParam.receive_num --红包接收数量
					local send_time = redPacketParam.send_time --红包发送时间
					local expire_time = redPacketParam.expire_time --红包过期时间
					local redPacketReceiveList = redPacketParam.redPacketReceiveList --红包领取uid列表
					--print(expire_time)
					
					--红包未领完才需要更新消息
					if (receive_num < send_num) then --未领完
						--print(chatType, msgId, msgType, touid)
						SendGroupCmdFunc["chat_update_message"](chatType, msgId, touid)
					end
				end
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
			--
		end
	end
	
	--函数：收到聊天消息内容列表事件返回
	local msgNumCache = 0
	local tChatMsgListCache = {}
	on_receive_chat_content_list_event = function(chatType, friendUid, msgNum, tChatMsgList, index, totalnum)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("收到聊天消息内容列表事件返回=", chatType, friendUid, msgNum, tChatMsgList)
		
		--分段发送的消息，合并之前的缓存获取的消息
		if (totalnum > 1) then
			--首次获得的缓存消息
			if (index == 1) then
				msgNumCache = 0
				tChatMsgListCache = {}
			end
			
			msgNumCache = msgNumCache + msgNum
			for i = 1, #tChatMsgList, 1 do
				tChatMsgListCache[#tChatMsgListCache+1] = tChatMsgList[i]
			end
			
			--最后获得的缓存消息
			if (index == totalnum) then
				--合并数据
				msgNum = msgNumCache
				tChatMsgList = tChatMsgListCache
				
				--清除缓存
				msgNumCache = 0
				tChatMsgListCache = {}
			else
				return
			end
		end
		
		--移除超时检测timer
		hApi.clearTimer("__ONCE_CHAT_TIMEOUNT_TIMER__")
		
		--取消挡操作
		--hUI.NetDisable(0)
		--隐藏菊花
		if _frmNode.childUI["waiting"] then
			_frmNode.childUI["waiting"]:setstate(-1) --已联网不显示菊花
		end
		
		--如果收到的消息内容不是本分页聊天频道，不处理
		if (current_chat_type ~= chatType) then
			return
		end
		
		--current_async_paint_list = {} --清空异步缓存待绘制内容
		
		if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
			--存储聊天内容
			for i = 1, msgNum, 1 do
				local tChatMsg = tChatMsgList[i]
				local msgId = tChatMsg.id
				current_chat_msg_hostory_cache_world[msgId] = tChatMsg
			end
			
			--先删除原控件中不需要的聊天内容
			for i = current_DLCMap_max_num, 1, -1 do
				local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
				if ctrli then
					local msgIdi = ctrli.data.msgId
					local bExisted = false
					for m = 1, #current_msg_id_list_world, 1 do
						if (current_msg_id_list_world[m] == msgIdi) then
							bExisted = true --找到了
							break
						end
					end
					
					--删除不存在的msgId原控件
					if (not bExisted) then
						--删除控件
						local chatHeight_i = ctrli.data.chatHeight
						hApi.safeRemoveT(_frmNode.childUI, "DLCMapInfoNode" .. i)
						--print("删除控件", i)
						
						--后续控件索引位置依次前移
						if (i < current_DLCMap_max_num) then
							for j = i + 1, current_DLCMap_max_num, 1 do
								local ctrlj = _frmNode.childUI["DLCMapInfoNode" .. j]
								_frmNode.childUI["DLCMapInfoNode" .. (j - 1)] = ctrlj
								
								--调整后续控件的坐标
								local posXj = ctrlj.data.x
								local posYj = ctrlj.data.y
								--理论相对距离
								local thisXj = posXj
								local thisYj = posYj + chatHeight_i
								ctrlj.handle._n:setPosition(thisXj, thisYj)
								ctrlj.data.x = thisXj
								ctrlj.data.y = thisYj
							end
						end
						
						--删除最后一个控件标记
						_frmNode.childUI["DLCMapInfoNode" .. current_DLCMap_max_num] = nil
						
						--删除 rightRemoveFrmList 存储标记
						for j = 1, #rightRemoveFrmList, 1 do
							if (rightRemoveFrmList[j] == ("DLCMapInfoNode" .. current_DLCMap_max_num)) then
								--print("删除 rightRemoveFrmList 存储标记", j, rightRemoveFrmList[j])
								table.remove(rightRemoveFrmList, j)
								break
							end
						end
						
						--删除历史消息缓存
						current_chat_msg_hostory_cache_world[msgIdi] = nil
						
						--删除可能的异步消息绘制列表
						for as = #current_async_paint_list, 1, -1 do
							local tMsg_i = current_async_paint_list[as]
							if (tMsg_i.id == msgIdi) then
								table.remove(current_async_paint_list, as)
								break
							end
						end
						
						--标记总数量减1
						current_DLCMap_max_num = current_DLCMap_max_num - 1
					end
				end
			end
			
			--是否异步
			local bAsyncPaint = false
			if (current_DLCMap_max_num == 0) then
				bAsyncPaint = true
			end
			--print("current_DLCMap_max_num=", current_DLCMap_max_num)
			
			--在绘制前就检测是否需要自动滚动
			--检测是否滑动到了最顶部或最底部
			local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
			local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
			delta1_ly, deltNa_ry = getUpDownOffset()
			--print(delta1_ly, deltNa_ry)
			--delta1_ly +:在下底线之上 /-:在下底线之下
			--deltNa_ry +:在下底线之上 /-:在下底线之下
			
			--世界消息，世界未领取的红包最后显示
			local tRedPacketMsgList = {}
			for m = #current_msg_id_list_world, 1, -1 do
				local msgId = current_msg_id_list_world[m]
				local tMsg = current_chat_msg_hostory_cache_world[msgId]
				if tMsg then
					local msgId = tMsg.id --消息id
					local chatType = tMsg.chatType --聊天频道
					local msgType = tMsg.msgType --消息类型
					if (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --发支付（土豪）红包
						local uid = tMsg.uid --消息发送者uid
						local name = tMsg.name --玩家名
						local channelId = tMsg.channelId --渠道号
						local vip = tMsg.vip --vip等级
						local borderId = tMsg.borderId --边框id
						local iconId = tMsg.iconId --头像id
						local championId = tMsg.championId --称号id
						local leaderId = tMsg.leaderId --会长权限
						local dragonId = tMsg.dragonId --聊天龙王id
						local headId = tMsg.headId --头衔id
						local lineId = tMsg.lineId --线索id
						local date = tMsg.date --日期
						local content = tMsg.content --聊天内容
						local touid = tMsg.touid --接收者uid
						local result = tMsg.result --可交互类型消息的操作结果
						local resultParam = tMsg.resultParam --可交互类型消息的参数
						local redPacketParam = tMsg.redPacketParam --红包消息参数
						
						--支付（土豪）红包的红包参数信息
						local redPacketId = redPacketParam.redPacketId --红包唯一id
						local send_uid = redPacketParam.send_uid --红包发送者uid
						local send_name = redPacketParam.send_name --红包发送者名字
						local send_num = redPacketParam.send_num --红包发送数量
						local content = redPacketParam.content --内容
						local money = redPacketParam.money --充值金额
						local iap_id = redPacketParam.iap_id --充值记录id
						local channelId = redPacketParam.channelId --渠道号
						local vipLv = redPacketParam.vipLv --vip等级
						local borderId = redPacketParam.borderId --边框id
						local iconId = redPacketParam.iconId --头像id
						local championId = redPacketParam.championId --称号id
						local leaderId = redPacketParam.leaderId --会长权限
						local dragonId = redPacketParam.dragonId --聊天龙王id
						local headId = redPacketParam.headId --头衔id
						local lineId = redPacketParam.lineId --线索id
						local msg_id = redPacketParam.msg_id --消息id
						local receive_num = redPacketParam.receive_num --红包接收数量
						local send_time = redPacketParam.send_time --红包发送时间
						local expire_time = redPacketParam.expire_time --红包过期时间
						local redPacketReceiveList = redPacketParam.redPacketReceiveList --红包领取uid列表
						--print(expire_time)
						
						--剩余红包数量
						local lefenum = send_num - receive_num
						
						--我是否已领取
						local uidMe = xlPlayer_GetUID()
						local bRewardMe = redPacketReceiveList[uidMe]
						
						if (lefenum <= 0) then --已被领完
							--
						elseif bRewardMe then --我已领取
							--
						else
							--未领取
							table.remove(current_msg_id_list_world, m)
							table.insert(tRedPacketMsgList, 1, msgId)
							--print("未领取", m, msgId)
						end
					end
				end
			end
			for n = 1, #tRedPacketMsgList, 1 do
				table.insert(current_msg_id_list_world, tRedPacketMsgList[n])
				--print("insert", n, tRedPacketMsgList[n])
			end
			
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
			
			--依次绘制新加的消息
			for m = 1, #current_msg_id_list_world, 1 do
				local msgId = current_msg_id_list_world[m]
				local tMsg = current_chat_msg_hostory_cache_world[msgId]
				--print("msgId=", msgId)
				
				--有可能上一次获得的消息id列表的某些消息，在服务器被删除，这里不能保证都能获得消息内容
				if tMsg then
					local bExisted = false
					for i = 1, current_DLCMap_max_num, 1 do
						local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
						if ctrli then
							local msgIdi = ctrli.data.msgId
							if (msgIdi == msgId) then --找到了
								bExisted = true
								break
							end
						end
					end
					
					if (not bExisted) then
						--标记总数量加1
						current_DLCMap_max_num = current_DLCMap_max_num + 1
						
						--绘制此消息
						if bAsyncPaint then
							on_create_single_message_UI_Async(tMsg, current_DLCMap_max_num)
						else
							on_create_single_message_UI(tMsg, current_DLCMap_max_num)
						end
					end
				end
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
				--向上滚屏
				b_need_auto_fixing_dlcmapinfo = true
				friction_dlcmapinfo = 0
				friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
				draggle_speed_y_dlcmapinfo = MAX_SPEED / 0.0001 --正速度 --速度极大
				--立即刷新位置
				refresh_chatframe_scroll_world_loop()
			else
				--没触发自动滑动，需要提示新消息
				if (delta1_ly == 0) and (deltNa_ry >= 0) then
					--因为不足一页的不滑动，不需要提示
					onRemoveNewMessageHint()
				else
					onCreateNewMessageHint()
				end
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
			--存储聊天内容
			--print(msgNum)
			for i = 1, msgNum, 1 do
				local tChatMsg = tChatMsgList[i]
				local msgId = tChatMsg.id
				--print("msgId=", msgId)
				current_chat_msg_hostory_cache_invite[msgId] = tChatMsg
			end
			
			--先删除原控件中不需要的聊天内容
			for i = current_DLCMap_max_num, 1, -1 do
				local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
				if ctrli then
					local msgIdi = ctrli.data.msgId
					local bExisted = false
					for m = 1, #current_msg_id_list_invite, 1 do
						if (current_msg_id_list_invite[m] == msgIdi) then
							bExisted = true --找到了
							break
						end
					end
					
					--删除不存在的msgId原控件
					if (not bExisted) then
						--删除控件
						local chatHeight_i = ctrli.data.chatHeight
						hApi.safeRemoveT(_frmNode.childUI, "DLCMapInfoNode" .. i)
						--print("删除控件", i)
						
						--后续控件索引位置依次前移
						if (i < current_DLCMap_max_num) then
							for j = i + 1, current_DLCMap_max_num, 1 do
								local ctrlj = _frmNode.childUI["DLCMapInfoNode" .. j]
								_frmNode.childUI["DLCMapInfoNode" .. (j - 1)] = ctrlj
								
								--调整后续控件的坐标
								local posXj = ctrlj.data.x
								local posYj = ctrlj.data.y
								--理论相对距离
								local thisXj = posXj
								local thisYj = posYj + chatHeight_i
								ctrlj.handle._n:setPosition(thisXj, thisYj)
								ctrlj.data.x = thisXj
								ctrlj.data.y = thisYj
							end
						end
						
						--删除最后一个控件标记
						_frmNode.childUI["DLCMapInfoNode" .. current_DLCMap_max_num] = nil
						
						--删除 rightRemoveFrmList 存储标记
						for j = 1, #rightRemoveFrmList, 1 do
							if (rightRemoveFrmList[j] == ("DLCMapInfoNode" .. current_DLCMap_max_num)) then
								--print("删除 rightRemoveFrmList 存储标记", j, rightRemoveFrmList[j])
								table.remove(rightRemoveFrmList, j)
								break
							end
						end
						
						--删除历史消息缓存
						current_chat_msg_hostory_cache_invite[msgIdi] = nil
						
						--删除可能的异步消息绘制列表
						for as = #current_async_paint_list, 1, -1 do
							local tMsg_i = current_async_paint_list[as]
							if (tMsg_i.id == msgIdi) then
								table.remove(current_async_paint_list, as)
								break
							end
						end
						
						--标记总数量减1
						current_DLCMap_max_num = current_DLCMap_max_num - 1
					end
				end
			end
			
			--是否异步
			local bAsyncPaint = false
			if (current_DLCMap_max_num == 0) then
				bAsyncPaint = true
			end
			--print("current_DLCMap_max_num=", current_DLCMap_max_num)
			
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
			
			--依次绘制新加的邀请消息
			for m = 1, #current_msg_id_list_invite, 1 do
				local msgId = current_msg_id_list_invite[m]
				local tMsg = current_chat_msg_hostory_cache_invite[msgId]
				--print("msgId=", msgId)
				
				--有可能上一次获得的消息id列表的某些消息，在服务器被删除，这里不能保证都能获得消息内容
				--print("tMsg=", tMsg)
				if tMsg then
					local bExisted = false
					for i = 1, current_DLCMap_max_num, 1 do
						local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
						if ctrli then
							local msgIdi = ctrli.data.msgId
							if (msgIdi == msgId) then --找到了
								bExisted = true
								break
							end
						end
					end
					
					if (not bExisted) then
						--标记总数量加1
						current_DLCMap_max_num = current_DLCMap_max_num + 1
						
						--绘制此消息
						if bAsyncPaint then
							on_create_single_message_UI_Async(tMsg, current_DLCMap_max_num)
						else
							on_create_single_message_UI(tMsg, current_DLCMap_max_num)
						end
					end
				end
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
			--print(in_scroll_down)
			
			--获得一个加速度，使右边自动往上滚动
			--超过一页的数量才滑屏
			--if (current_DLCMap_max_num > (WEAPON_X_NUM * WEAPON_Y_NUM)) then
			if in_scroll_down then
				--向上滚屏
				b_need_auto_fixing_dlcmapinfo = true
				friction_dlcmapinfo = 0
				friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
				draggle_speed_y_dlcmapinfo = MAX_SPEED / 0.0001 --正速度 --速度极大
				--立即刷新位置
				refresh_chatframe_scroll_world_loop()
			else
				--没触发自动滑动，需要提示新消息
				if (delta1_ly == 0) and (deltNa_ry >= 0) then
					--因为不足一页的不滑动，不需要提示
					onRemoveNewMessageHint()
				else
					onCreateNewMessageHint()
				end
			end
			
			--geyachao: 组队邀请类消息，在获得消息详情后，就标记全部组队消息为已读，并立即更新叹号
			--设置组队副本消息已读的消息id
			if (#current_msg_id_list_invite > 0) then
				local notSaveFlag = true
				LuaRemoveBattleInviteMsgAll(g_curPlayerName, notSaveFlag)
				
				for t = 1, #current_msg_id_list_invite, 1 do
					local msgId = current_msg_id_list_invite[t]
					LuaSetBattleInviteMsgIdRead(g_curPlayerName, msgId, notSaveFlag)
				end
				
				--存档
				LuaSavePlayerList()
			else
				--移除组队副本邀请全部未查看的消息id
				LuaRemoveBattleInviteMsgAll(g_curPlayerName)
			end
			
			--组队邀请类消息，立即更新叹号
			on_update_notice_tanhao()
			
		elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			--如果收到的消息内容不是当前正在聊天的好友uid，不处理
			if (current_msg_private_friend_last_uid ~= friendUid) then
				return
			end
			
			--存储聊天内容
			local tChatMsgFriendList = current_msgPrivate_msg_hostory_cache[friendUid]
			if (tChatMsgFriendList == nil) then --初始化
				tChatMsgFriendList = {}
				current_msgPrivate_msg_hostory_cache[friendUid] = tChatMsgFriendList
			end
			for i = 1, msgNum, 1 do
				local tChatMsg = tChatMsgList[i]
				local msgId = tChatMsg.id
				tChatMsgFriendList[msgId] = tChatMsg
			end
			
			--先删除原控件中不需要的聊天内容
			--print("原 current_DLCMap_max_num=", current_DLCMap_max_num)
			for i = current_DLCMap_max_num, 1, -1 do
				local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
				--已绘制的控件
				if ctrli then
					local msgIdi = ctrli.data.msgId
					local bExisted = false
					for m = 1, #current_msgPrivate_msg_id_list[friendUid], 1 do
						if (current_msgPrivate_msg_id_list[friendUid][m] == msgIdi) then
							bExisted = true --找到了
							break
						end
					end
					
					--删除不存在的msgId原控件
					if (not bExisted) then
						--删除控件
						local chatHeight_i = ctrli.data.chatHeight
						hApi.safeRemoveT(_frmNode.childUI, "DLCMapInfoNode" .. i)
						--print("删除控件", i)
						
						--后续控件索引位置依次前移
						if (i < current_DLCMap_max_num) then
							for j = i + 1, current_DLCMap_max_num, 1 do
								local ctrlj = _frmNode.childUI["DLCMapInfoNode" .. j]
								_frmNode.childUI["DLCMapInfoNode" .. (j - 1)] = ctrlj
								
								--调整后续控件的坐标
								local posXj = ctrlj.data.x
								local posYj = ctrlj.data.y
								--理论相对距离
								local thisXj = posXj
								local thisYj = posYj + chatHeight_i
								ctrlj.handle._n:setPosition(thisXj, thisYj)
								ctrlj.data.x = thisXj
								ctrlj.data.y = thisYj
							end
						end
						
						--删除最后一个控件标记
						_frmNode.childUI["DLCMapInfoNode" .. current_DLCMap_max_num] = nil
						
						--删除 rightRemoveFrmList 存储标记
						for j = 1, #rightRemoveFrmList, 1 do
							if (rightRemoveFrmList[j] == ("DLCMapInfoNode" .. current_DLCMap_max_num)) then
								--print("删除 rightRemoveFrmList 存储标记", j, rightRemoveFrmList[j])
								table.remove(rightRemoveFrmList, j)
								break
							end
						end
						
						--删除私聊历史消息缓存
						tChatMsgFriendList[msgIdi] = nil
						--print("删除私聊历史消息缓存", friendUid, msgIdi)
						
						--删除可能的异步消息绘制列表
						for as = #current_async_paint_list, 1, -1 do
							local tMsg_i = current_async_paint_list[as]
							if (tMsg_i.id == msgIdi) then
								table.remove(current_async_paint_list, as)
								break
							end
						end
						
						--标记消息总数量减1
						current_DLCMap_max_num = current_DLCMap_max_num - 1
					end
				end
			end
			
			--print("减掉已存在", current_DLCMap_max_num)
			
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
			
			--不需要绘制异步了
			--current_async_paint_list = {}
			
			--是否异步
			local bAsyncPaint = false
			if (current_DLCMap_max_num == 0) then
				bAsyncPaint = true
			end
			--print("current_DLCMap_max_num=", current_DLCMap_max_num)
			
			--依次绘制新加的私聊消息
			for m = 1, #current_msgPrivate_msg_id_list[friendUid], 1 do
				local msgId = current_msgPrivate_msg_id_list[friendUid][m]
				local tMsg = tChatMsgFriendList[msgId]
				--print("msgId=", msgId)
				
				--有可能上一次获得的消息id列表的某些消息，在服务器被删除，这里不能保证都能获得消息内容
				if tMsg then
					local bExisted = false
					for i = 1, current_DLCMap_max_num, 1 do
						local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
						if ctrli then
							local msgIdi = ctrli.data.msgId
							if (msgIdi == msgId) then --找到了
								bExisted = true
								break
							end
						end
					end
					
					if (not bExisted) then
						--标记总数量加1
						current_DLCMap_max_num = current_DLCMap_max_num + 1
						--print("current_DLCMap_max_num=", current_DLCMap_max_num, tMsg.content)
						
						--绘制此消息
						if bAsyncPaint then
							on_create_single_message_UI_Async(tMsg, current_DLCMap_max_num)
						else
							on_create_single_message_UI(tMsg, current_DLCMap_max_num)
						end
					end
				end
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
				--向上滚屏
				b_need_auto_fixing_dlcmapinfo = true
				friction_dlcmapinfo = 0
				friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
				draggle_speed_y_dlcmapinfo = MAX_SPEED / 0.0001 --正速度 --速度极大
				--立即刷新位置
				--refresh_chatframe_scroll_world_loop()
			else
				--没触发自动滑动，需要提示新消息
				if (delta1_ly == 0) and (deltNa_ry >= 0) then
					--因为不足一页的不滑动，不需要提示
					onRemoveNewMessageHint()
				else
					onCreateNewMessageHint()
				end
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
			--存储聊天内容
			for i = 1, msgNum, 1 do
				local tChatMsg = tChatMsgList[i]
				local msgId = tChatMsg.id
				current_chat_msg_hostory_cache_group[msgId] = tChatMsg
			end
			
			--先删除原控件中不需要的聊天内容
			for i = current_DLCMap_max_num, 1, -1 do
				local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
				if ctrli then
					local msgIdi = ctrli.data.msgId
					local bExisted = false
					for m = 1, #current_msg_id_list_group, 1 do
						if (current_msg_id_list_group[m] == msgIdi) then
							bExisted = true --找到了
							break
						end
					end
					
					--删除不存在的msgId原控件
					if (not bExisted) then
						--删除控件
						local chatHeight_i = ctrli.data.chatHeight
						hApi.safeRemoveT(_frmNode.childUI, "DLCMapInfoNode" .. i)
						--print("删除控件", i)
						
						--后续控件索引位置依次前移
						if (i < current_DLCMap_max_num) then
							for j = i + 1, current_DLCMap_max_num, 1 do
								local ctrlj = _frmNode.childUI["DLCMapInfoNode" .. j]
								_frmNode.childUI["DLCMapInfoNode" .. (j - 1)] = ctrlj
								
								--调整后续控件的坐标
								local posXj = ctrlj.data.x
								local posYj = ctrlj.data.y
								--理论相对距离
								local thisXj = posXj
								local thisYj = posYj + chatHeight_i
								ctrlj.handle._n:setPosition(thisXj, thisYj)
								ctrlj.data.x = thisXj
								ctrlj.data.y = thisYj
							end
						end
						
						--删除最后一个控件标记
						_frmNode.childUI["DLCMapInfoNode" .. current_DLCMap_max_num] = nil
						
						--删除 rightRemoveFrmList 存储标记
						for j = 1, #rightRemoveFrmList, 1 do
							if (rightRemoveFrmList[j] == ("DLCMapInfoNode" .. current_DLCMap_max_num)) then
								--print("删除 rightRemoveFrmList 存储标记", j, rightRemoveFrmList[j])
								table.remove(rightRemoveFrmList, j)
								break
							end
						end
						
						--删除历史消息缓存
						current_chat_msg_hostory_cache_group[msgIdi] = nil
						
						--删除可能的异步消息绘制列表
						for as = #current_async_paint_list, 1, -1 do
							local tMsg_i = current_async_paint_list[as]
							if (tMsg_i.id == msgIdi) then
								table.remove(current_async_paint_list, as)
								break
							end
						end
						
						--标记总数量减1
						current_DLCMap_max_num = current_DLCMap_max_num - 1
					end
				end
			end
			
			--是否异步
			local bAsyncPaint = false
			if (current_DLCMap_max_num == 0) then
				bAsyncPaint = true
			end
			--print("current_DLCMap_max_num=", current_DLCMap_max_num)
			
			--在绘制前就检测是否需要自动滚动
			--检测是否滑动到了最顶部或最底部
			local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
			local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
			delta1_ly, deltNa_ry = getUpDownOffset()
			--print(delta1_ly, deltNa_ry)
			--delta1_ly +:在下底线之上 /-:在下底线之下
			--deltNa_ry +:在下底线之上 /-:在下底线之下
			
			--军团消息，军团未领取的红包最后显示
			local tRedPacketMsgList = {}
			for m = #current_msg_id_list_group, 1, -1 do
				local msgId = current_msg_id_list_group[m]
				local tMsg = current_chat_msg_hostory_cache_group[msgId]
				if tMsg then
					local msgId = tMsg.id --消息id
					local chatType = tMsg.chatType --聊天频道
					local msgType = tMsg.msgType --消息类型
					if (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) then --军团发红包
						local uid = tMsg.uid --消息发送者uid
						local name = tMsg.name --玩家名
						local channelId = tMsg.channelId --渠道号
						local vip = tMsg.vip --vip等级
						local borderId = tMsg.borderId --边框id
						local iconId = tMsg.iconId --头像id
						local championId = tMsg.championId --称号id
						local leaderId = tMsg.leaderId --会长权限
						local dragonId = tMsg.dragonId --聊天龙王id
						local headId = tMsg.headId --头衔id
						local lineId = tMsg.lineId --线索id
						local date = tMsg.date --日期
						local content = tMsg.content --聊天内容
						local touid = tMsg.touid --接收者uid
						local result = tMsg.result --可交互类型消息的操作结果
						local resultParam = tMsg.resultParam --可交互类型消息的参数
						local redPacketParam = tMsg.redPacketParam --红包消息参数
						
						--军团红包的红包参数信息
						local redPacketId = redPacketParam.redPacketId --红包唯一id
						local send_uid = redPacketParam.send_uid --红包发送者uid
						local send_name = redPacketParam.send_name --红包发送者名字
						local group_id = redPacketParam.group_id --红包军团id
						local send_num = redPacketParam.send_num --红包发送数量
						local content = redPacketParam.content --内容
						local coin = redPacketParam.coin --游戏币
						local order_id = redPacketParam.order_id --订单号
						local msg_id = redPacketParam.msg_id --消息id
						local receive_num = redPacketParam.receive_num --红包接收数量
						local send_time = redPacketParam.send_time --红包发送时间
						local expire_time = redPacketParam.expire_time --红包过期时间
						local redPacketReceiveList = redPacketParam.redPacketReceiveList --红包领取uid列表
						--print(expire_time)
						
						--剩余红包数量
						local lefenum = send_num - receive_num
						
						--我是否已领取
						local uidMe = xlPlayer_GetUID()
						local bRewardMe = redPacketReceiveList[uidMe]
						
						if (lefenum <= 0) then --已被领完
							--
						elseif bRewardMe then --我已领取
							--
						else
							--未领取
							table.remove(current_msg_id_list_group, m)
							table.insert(tRedPacketMsgList, 1, msgId)
							--print("未领取", m, msgId)
						end
					end
				end
			end
			for n = 1, #tRedPacketMsgList, 1 do
				table.insert(current_msg_id_list_group, tRedPacketMsgList[n])
				--print("insert", n, tRedPacketMsgList[n])
			end
			
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
			
			--依次绘制新加的军团消息
			for m = 1, #current_msg_id_list_group, 1 do
				local msgId = current_msg_id_list_group[m]
				local tMsg = current_chat_msg_hostory_cache_group[msgId]
				--print("msgId=", msgId)
				
				--有可能上一次获得的消息id列表的某些消息，在服务器被删除，这里不能保证都能获得消息内容
				if tMsg then
					local bExisted = false
					for i = 1, current_DLCMap_max_num, 1 do
						local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
						if ctrli then
							local msgIdi = ctrli.data.msgId
							if (msgIdi == msgId) then --找到了
								bExisted = true
								break
							end
						end
					end
					
					if (not bExisted) then
						--标记总数量加1
						current_DLCMap_max_num = current_DLCMap_max_num + 1
						
						--绘制此消息
						if bAsyncPaint then
							on_create_single_message_UI_Async(tMsg, current_DLCMap_max_num)
						else
							on_create_single_message_UI(tMsg, current_DLCMap_max_num)
						end
					end
				end
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
				--向上滚屏
				b_need_auto_fixing_dlcmapinfo = true
				friction_dlcmapinfo = 0
				friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
				draggle_speed_y_dlcmapinfo = MAX_SPEED / 0.0001 --正速度 --速度极大
				--立即刷新位置
				refresh_chatframe_scroll_world_loop()
			else
				--没触发自动滑动，需要提示新消息
				if (delta1_ly == 0) and (deltNa_ry >= 0) then
					--因为不足一页的不滑动，不需要提示
					onRemoveNewMessageHint()
				else
					onCreateNewMessageHint()
				end
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
			--存储聊天内容
			for i = 1, msgNum, 1 do
				local tChatMsg = tChatMsgList[i]
				local msgId = tChatMsg.id
				current_chat_msg_hostory_cache_couple[msgId] = tChatMsg
			end
			
			--先删除原控件中不需要的聊天内容
			for i = current_DLCMap_max_num, 1, -1 do
				local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
				if ctrli then
					local msgIdi = ctrli.data.msgId
					local bExisted = false
					for m = 1, #current_msg_id_list_couple, 1 do
						if (current_msg_id_list_couple[m] == msgIdi) then
							bExisted = true --找到了
							break
						end
					end
					
					--删除不存在的msgId原控件
					if (not bExisted) then
						--删除控件
						local chatHeight_i = ctrli.data.chatHeight
						hApi.safeRemoveT(_frmNode.childUI, "DLCMapInfoNode" .. i)
						--print("删除控件", i)
						
						--后续控件索引位置依次前移
						if (i < current_DLCMap_max_num) then
							for j = i + 1, current_DLCMap_max_num, 1 do
								local ctrlj = _frmNode.childUI["DLCMapInfoNode" .. j]
								_frmNode.childUI["DLCMapInfoNode" .. (j - 1)] = ctrlj
								
								--调整后续控件的坐标
								local posXj = ctrlj.data.x
								local posYj = ctrlj.data.y
								--理论相对距离
								local thisXj = posXj
								local thisYj = posYj + chatHeight_i
								ctrlj.handle._n:setPosition(thisXj, thisYj)
								ctrlj.data.x = thisXj
								ctrlj.data.y = thisYj
							end
						end
						
						--删除最后一个控件标记
						_frmNode.childUI["DLCMapInfoNode" .. current_DLCMap_max_num] = nil
						
						--删除 rightRemoveFrmList 存储标记
						for j = 1, #rightRemoveFrmList, 1 do
							if (rightRemoveFrmList[j] == ("DLCMapInfoNode" .. current_DLCMap_max_num)) then
								--print("删除 rightRemoveFrmList 存储标记", j, rightRemoveFrmList[j])
								table.remove(rightRemoveFrmList, j)
								break
							end
						end
						
						--删除历史消息缓存
						current_chat_msg_hostory_cache_couple[msgIdi] = nil
						
						--删除可能的异步消息绘制列表
						for as = #current_async_paint_list, 1, -1 do
							local tMsg_i = current_async_paint_list[as]
							if (tMsg_i.id == msgIdi) then
								table.remove(current_async_paint_list, as)
								break
							end
						end
						
						--标记总数量减1
						current_DLCMap_max_num = current_DLCMap_max_num - 1
					end
				end
			end
			
			--是否异步
			local bAsyncPaint = false
			if (current_DLCMap_max_num == 0) then
				bAsyncPaint = true
			end
			--print("current_DLCMap_max_num=", current_DLCMap_max_num)
			
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
			
			--依次绘制新加的组队消息
			for m = 1, #current_msg_id_list_couple, 1 do
				local msgId = current_msg_id_list_couple[m]
				local tMsg = current_chat_msg_hostory_cache_couple[msgId]
				--print("msgId=", msgId)
				
				--有可能上一次获得的消息id列表的某些消息，在服务器被删除，这里不能保证都能获得消息内容
				--print("tMsg=", tMsg)
				if tMsg then
					local bExisted = false
					for i = 1, current_DLCMap_max_num, 1 do
						local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
						if ctrli then
							local msgIdi = ctrli.data.msgId
							if (msgIdi == msgId) then --找到了
								bExisted = true
								break
							end
						end
					end
					
					if (not bExisted) then
						--标记总数量加1
						current_DLCMap_max_num = current_DLCMap_max_num + 1
						
						--绘制此消息
						if bAsyncPaint then
							on_create_single_message_UI_Async(tMsg, current_DLCMap_max_num)
						else
							on_create_single_message_UI(tMsg, current_DLCMap_max_num)
						end
					end
				end
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
				--向上滚屏
				b_need_auto_fixing_dlcmapinfo = true
				friction_dlcmapinfo = 0
				friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
				draggle_speed_y_dlcmapinfo = MAX_SPEED / 0.0001 --正速度 --速度极大
				--立即刷新位置
				refresh_chatframe_scroll_world_loop()
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
		--end
			
		--[[
		--测试 --test
		onCreateNewMessageHint()
		]]
	end
	
	--函数：收到单条聊天消息事件返回
	on_receive_single_chat_message_event = function(tChatMsg)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("收到单条聊天消息事件返回", tChatMsg.id, "current_chat_type=", current_chat_type)
		
		--移除超时检测timer
		hApi.clearTimer("__ONCE_CHAT_TIMEOUNT_TIMER__")
		
		--取消挡操作
		--hUI.NetDisable(0)
		--隐藏菊花
		if _frmNode.childUI["waiting"] then
			_frmNode.childUI["waiting"]:setstate(-1) --已联网不显示菊花
		end
		
		--如果收到的消息id不是本分页聊天频道，不处理具体的逻辑
		if (current_chat_type ~= tChatMsg.chatType) then
			--更新叹号
			on_update_notice_tanhao()
			
			return
		end
		
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
		--注意: 这条消息可能跟在删除消息之后，所以上一帧所有控件有可能跑到上面了
		--if (delta1_ly == 0) and (deltNa_ry >= 0) then
		--[[
		--geyachao: 删除消息已经改为新的写法，第一个控件进行检测是否跑到顶部的下方后统一调整dy，所以这里不需要检测第一个控件的位置了
		if (delta1_ly >= 0) and (deltNa_ry >= 0) then --注意: 这条消息可能跟在删除消息之后，所以上一帧所有控件有可能跑到上面了
			in_scroll_down = true
		end
		]]
		if (deltNa_ry == 0) then
			in_scroll_down = true
		end
		--print(delta1_ly, deltNa_ry, in_scroll_down)
		
		if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
			--[[
			--检测世界聊天数量是否超过上限
			if (current_DLCMap_max_num >= hVar.CHAT_MAX_LENGTH_WORLD) then
				--删除第1条消息
				--删除控件
				local i = 1
				local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
				local msgIdi = ctrli.data.msgId
				local chatHeight_i = ctrli.data.chatHeight
				hApi.safeRemoveT(_frmNode.childUI, "DLCMapInfoNode" .. i)
				--print("删除控件", i)
				
				--后续控件索引位置依次前移
				if (i < current_DLCMap_max_num) then
					for j = i + 1, current_DLCMap_max_num, 1 do
						local ctrlj = _frmNode.childUI["DLCMapInfoNode" .. j]
						_frmNode.childUI["DLCMapInfoNode" .. (j - 1)] = ctrlj
						
						--[=[
						--调整后续控件的坐标
						local posXj = ctrlj.data.x
						local posYj = ctrlj.data.y
						--理论相对距离
						local thisXj = posXj
						local thisYj = posYj + chatHeight_i
						ctrlj.handle._n:setPosition(thisXj, thisYj)
						ctrlj.data.x = thisXj
						ctrlj.data.y = thisYj
						]=]
					end
				end
				
				--删除最后一个控件标记
				_frmNode.childUI["DLCMapInfoNode" .. current_DLCMap_max_num] = nil
				
				--删除 rightRemoveFrmList 存储标记
				for j = 1, #rightRemoveFrmList, 1 do
					if (rightRemoveFrmList[j] == ("DLCMapInfoNode" .. current_DLCMap_max_num)) then
						--print("删除 rightRemoveFrmList 存储标记", j, rightRemoveFrmList[j])
						table.remove(rightRemoveFrmList, j)
						break
					end
				end
				
				--标记总数量减1
				current_DLCMap_max_num = current_DLCMap_max_num - 1
				
				--删除此条消息的内容缓存
				table.remove(current_msg_id_list_world, i)
				current_chat_msg_hostory_cache_world[msgIdi] = nil
			end
			]]
			
			--存储聊天消息id列表
			local msgId = tChatMsg.id
			current_msg_id_list_world[#current_msg_id_list_world+1] = msgId
			
			--存储聊天内容
			current_chat_msg_hostory_cache_world[msgId] = tChatMsg
			
			--标记总数量加1
			current_DLCMap_max_num = current_DLCMap_max_num + 1
			
			--绘制本条消息
			on_create_single_message_UI(tChatMsg, current_DLCMap_max_num)
			
			--在绘制后检测是否需要自动滚动
			--只检测是否滑动到了最顶部
			local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
			local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
			delta1_ly, deltNa_ry = getUpDownOffset()
			--print("新", delta1_ly, deltNa_ry)
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
				--原本没有滚动，来新消息才需要自动滑动
				if (draggle_speed_y_dlcmapinfo == 0) then
					--向上滚屏
					b_need_auto_fixing_dlcmapinfo = true
					friction_dlcmapinfo = 0
					friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
					draggle_speed_y_dlcmapinfo = MAX_SPEED / 1.0 --正速度 --速度一般大
				end
			else
				--没触发自动滑动，需要提示新消息
				if (delta1_ly == 0) and (deltNa_ry >= 0) then
					--因为不足一页的不滑动，不需要提示
					onRemoveNewMessageHint()
				else
					onCreateNewMessageHint()
				end
			end
			--end
		elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
			--存储聊天消息id列表
			local msgId = tChatMsg.id
			current_msg_id_list_invite[#current_msg_id_list_invite+1] = msgId
			
			--存储聊天内容
			current_chat_msg_hostory_cache_invite[msgId] = tChatMsg
			
			--标记总数量加1
			current_DLCMap_max_num = current_DLCMap_max_num + 1
			
			--绘制本条消息
			on_create_single_message_UI(tChatMsg, current_DLCMap_max_num)
			
			--在绘制后检测是否需要自动滚动
			--只检测是否滑动到了最顶部
			local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
			local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
			delta1_ly, deltNa_ry = getUpDownOffset()
			--print("新", delta1_ly, deltNa_ry)
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
				--原本没有滚动，来新消息才需要自动滑动
				if (draggle_speed_y_dlcmapinfo == 0) then
					--向上滚屏
					b_need_auto_fixing_dlcmapinfo = true
					friction_dlcmapinfo = 0
					friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
					draggle_speed_y_dlcmapinfo = MAX_SPEED / 1.0 --正速度 --速度一般大
				end
			else
				--没触发自动滑动，需要提示新消息
				if (delta1_ly == 0) and (deltNa_ry >= 0) then
					--因为不足一页的不滑动，不需要提示
					onRemoveNewMessageHint()
				else
					onCreateNewMessageHint()
				end
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			--如果收到的消息内容不是当前正在聊天的好友uid，并且不是的系统，不处理具体逻辑
			local friendUid = current_msg_private_friend_last_uid --!!!! 这里需要标记一下，如果在私聊频道，没有私聊的情况下，需要考虑这个特殊情况
			--print("friendUid=", friendUid, tChatMsg.uid, tChatMsg.touid)
			if (friendUid ~= tChatMsg.uid) and (friendUid ~= tChatMsg.touid) and (tChatMsg.uid ~= 0) then
				--提示好友列表的新消息叹号
				--更新叹号提示
				on_update_notice_tanhao()
				return
			end
			
			--存储聊天内容
			local tChatMsgFriendList = current_msgPrivate_msg_hostory_cache[friendUid]
			if (tChatMsgFriendList == nil) then --初始化
				tChatMsgFriendList = {}
				current_msgPrivate_msg_hostory_cache[friendUid] = tChatMsgFriendList
			end
			
			--[[
			--检测私聊数量是否超过上限
			--print(current_DLCMap_max_num, hVar.CHAT_MAX_LENGTH_PRIVATE)
			if (current_DLCMap_max_num >= hVar.CHAT_MAX_LENGTH_PRIVATE) then
				--删除第1条消息
				--删除控件
				local i = 1
				local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
				local msgIdi = ctrli.data.msgId
				local chatHeight_i = ctrli.data.chatHeight
				hApi.safeRemoveT(_frmNode.childUI, "DLCMapInfoNode" .. i)
				--print("删除控件", i)
				
				--后续控件索引位置依次前移
				if (i < current_DLCMap_max_num) then
					for j = i + 1, current_DLCMap_max_num, 1 do
						local ctrlj = _frmNode.childUI["DLCMapInfoNode" .. j]
						_frmNode.childUI["DLCMapInfoNode" .. (j - 1)] = ctrlj
						
						--[=[
						--调整后续控件的坐标
						local posXj = ctrlj.data.x
						local posYj = ctrlj.data.y
						--理论相对距离
						local thisXj = posXj
						local thisYj = posYj + chatHeight_i
						ctrlj.handle._n:setPosition(thisXj, thisYj)
						ctrlj.data.x = thisXj
						ctrlj.data.y = thisYj
						]=]
					end
				end
				
				--删除最后一个控件标记
				_frmNode.childUI["DLCMapInfoNode" .. current_DLCMap_max_num] = nil
				
				--删除 rightRemoveFrmList 存储标记
				for j = 1, #rightRemoveFrmList, 1 do
					if (rightRemoveFrmList[j] == ("DLCMapInfoNode" .. current_DLCMap_max_num)) then
						--print("删除 rightRemoveFrmList 存储标记", j, rightRemoveFrmList[j])
						table.remove(rightRemoveFrmList, j)
						break
					end
				end
				
				--标记总数量减1
				current_DLCMap_max_num = current_DLCMap_max_num - 1
				
				--删除此条消息的内容缓存
				table.remove(current_msgPrivate_msg_id_list[friendUid], i)
				tChatMsgFriendList[msgIdi] = nil
			end
			]]
			
			--存储聊天消息id列表
			local msgId = tChatMsg.id
			current_msgPrivate_msg_id_list[friendUid][#current_msgPrivate_msg_id_list[friendUid]+1] = msgId
			
			--存储聊天内容
			tChatMsgFriendList[msgId] = tChatMsg
			
			--标记总数量加1
			current_DLCMap_max_num = current_DLCMap_max_num + 1
			
			--绘制本条消息
			on_create_single_message_UI(tChatMsg, current_DLCMap_max_num)
			--print("on_create_single_message_UI", current_DLCMap_max_num)
			
			--如果私聊发送者是对方，那么检测是否需要更新对方的图标和名字
			if (friendUid == tChatMsg.uid) then
				for i = 1, current_DLCMap_friend_max_num, 1 do
					local ctrl_i = _frmNode.childUI["DLCMapInfoNodeFriend" .. i]
					if ctrl_i then
						local touid = ctrl_i.data.touid
						local toname = ctrl_i.data.toname
						local tochannelId = ctrl_i.data.tochannelId
						local tovip = ctrl_i.data.tovip
						local toborderId = ctrl_i.data.toborderId
						local toiconId = ctrl_i.data.toiconId
						local tochampionId = ctrl_i.data.tochampionId
						local toleaderId = ctrl_i.data.toleaderId
						local todragonId = ctrl_i.data.todragonId
						local toheadId = ctrl_i.data.toheadId
						local tolineId = ctrl_i.data.tolineId
						local selected = ctrl_i.data.selected
						
						if (friendUid == touid) then --找到了
							--检测更新好友头像
							if (toiconId ~= tChatMsg.iconId) then
								local tRoleIcon = hVar.tab_roleicon[tChatMsg.iconId]
								if (tRoleIcon == nil) then
									tRoleIcon = hVar.tab_roleicon[0]
								end
								local iconW = tRoleIcon.width
								local iconH = tRoleIcon.height
								local width = PRVAITE_FRIEND_WH * iconW / iconH
								local height = PRVAITE_FRIEND_WH
								local posx = 0
								local posy = 0
								if (height > width) then
									posy = -(height - width) / 2
								end
								--好友头像图标
								ctrl_i.childUI["roleIcon"]:setmodel(tRoleIcon.icon, nil, nil, width, height)
								ctrl_i.toiconId = tChatMsg.iconId
								--print("更新好友头像图标")
							end
							
							--检测更新好友玩家名
							if (toname ~= tChatMsg.name) then
								ctrl_i.childUI["playerName"]:setText(tChatMsg.name)
								_frmNode.childUI["DLCMapInfoNowFriendLabel"]:setText(string.format(hVar.tab_string["__TEXT_PrivateChatting"], tChatMsg.name)) --"与" .. tChatMsg.name .. "聊天中..."
								ctrl_i.toname = tChatMsg.name
								--print("更新好友玩家名")
							end
						end
					end
				end
			end
			
			--在绘制后检测是否需要自动滚动
			--只检测是否滑动到了最顶部
			local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
			local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
			delta1_ly, deltNa_ry = getUpDownOffset()
			--print("新", delta1_ly, deltNa_ry)
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
				--原本没有滚动，来新消息才需要自动滑动
				if (draggle_speed_y_dlcmapinfo == 0) then
					--向上滚屏
					b_need_auto_fixing_dlcmapinfo = true
					friction_dlcmapinfo = 0
					friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
					draggle_speed_y_dlcmapinfo = MAX_SPEED / 1.0 --正速度 --速度一般大
				end
			else
				--没触发自动滑动，需要提示新消息
				if (delta1_ly == 0) and (deltNa_ry >= 0) then
					--因为不足一页的不滑动，不需要提示
					onRemoveNewMessageHint()
				else
					onCreateNewMessageHint()
				end
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
			--存储聊天消息id列表
			local msgId = tChatMsg.id
			current_msg_id_list_group[#current_msg_id_list_group+1] = msgId
			
			--存储聊天内容
			current_chat_msg_hostory_cache_group[msgId] = tChatMsg
			
			--标记总数量加1
			current_DLCMap_max_num = current_DLCMap_max_num + 1
			
			--绘制本条消息
			on_create_single_message_UI(tChatMsg, current_DLCMap_max_num)
			
			--在绘制后检测是否需要自动滚动
			--只检测是否滑动到了最顶部
			local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
			local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
			delta1_ly, deltNa_ry = getUpDownOffset()
			--print("新", delta1_ly, deltNa_ry)
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
				--原本没有滚动，来新消息才需要自动滑动
				if (draggle_speed_y_dlcmapinfo == 0) then
					--向上滚屏
					b_need_auto_fixing_dlcmapinfo = true
					friction_dlcmapinfo = 0
					friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
					draggle_speed_y_dlcmapinfo = MAX_SPEED / 1.0 --正速度 --速度一般大
				end
			else
				--没触发自动滑动，需要提示新消息
				if (delta1_ly == 0) and (deltNa_ry >= 0) then
					--因为不足一页的不滑动，不需要提示
					onRemoveNewMessageHint()
				else
					onCreateNewMessageHint()
				end
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
			--存储聊天消息id列表
			local msgId = tChatMsg.id
			current_msg_id_list_couple[#current_msg_id_list_couple+1] = msgId
			
			--存储聊天内容
			current_chat_msg_hostory_cache_couple[msgId] = tChatMsg
			
			--标记总数量加1
			current_DLCMap_max_num = current_DLCMap_max_num + 1
			
			--绘制本条消息
			on_create_single_message_UI(tChatMsg, current_DLCMap_max_num)
			
			--在绘制后检测是否需要自动滚动
			--只检测是否滑动到了最顶部
			local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
			local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
			delta1_ly, deltNa_ry = getUpDownOffset()
			--print("新", delta1_ly, deltNa_ry)
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
				--原本没有滚动，来新消息才需要自动滑动
				if (draggle_speed_y_dlcmapinfo == 0) then
					--向上滚屏
					b_need_auto_fixing_dlcmapinfo = true
					friction_dlcmapinfo = 0
					friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
					draggle_speed_y_dlcmapinfo = MAX_SPEED / 1.0 --正速度 --速度一般大
				end
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
		
		--更新叹号提示
		on_update_notice_tanhao()
	end
	
	--函数：收到pvp连接结果回调
	on_receive_pvp_connect_back_event_chat = function(net_state)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--在pvp模式地图里，不能自动登陆
		local world = hGlobal.WORLD.LastWorldMap
		if world then
			if (world.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
				return
			end
		end
		
		if (net_state == 1) then
			--发送登陆请求
			if hGlobal.LocalPlayer:getonline() then --不重复登陆
				--模拟触发收到登入结果回调
				on_receive_pvp_login_back_event_chat(1, hGlobal.LocalPlayer.data.playerId_pvp)
			else
				--print("调试-: " .. "Pvp_Server:UserLogin(3)")
				Pvp_Server:UserLogin()
			end
		else
			--失败
			--取消挡操作
			hUI.NetDisable(0)
			
			--清除当前请求组队副本的房间消息id
			current_DLCMap_roomid = 0
			
			--冒字
			--local strText = "连接失败！错误码: 0" --language
			local strText = hVar.tab_string["__TEXT_ConnectFail_ErrorCode"] .. tostring(net_state) --language
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
	
	--函数：收到登入结果回调
	on_receive_pvp_login_back_event_chat = function(iResult, playerId) --0失败 1成功
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--在pvp模式地图里，不能自动初始化玩家基础信息
		local world = hGlobal.WORLD.LastWorldMap
		if world then
			if (world.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
				return
			end
		end
		
		if (iResult == 1) then
			--存储本地玩家id
			--current_PlayerId = playerId
			
			--请求查询玩家初始化的基础信息(用于优化)
			SendPvpCmdFunc["request_player_baseinfo"]()
		else
			--失败
			--取消挡操作
			hUI.NetDisable(0)
			
			--清除当前请求组队副本的房间消息id
			current_DLCMap_roomid = 0
			
			--冒字
			--local strText = "登入失败！错误码: 0" --language
			local strText = hVar.tab_string["__TEXT_LoginFail_ErrorCode"] .. tostring(iResult) --language
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
	
	--函数：收到初始化玩家基础信息结果回调
	on_receive_pvp_baseinfo_query_back_event_chat = function(iResult) --0失败 1成功
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--在pvp模式地图里，不能处理
		local world = hGlobal.WORLD.LastWorldMap
		if world then
			if (world.data.tdMapInfo.mapMode == hVar.MAP_TD_TYPE.PVP) then
				return
			end
		end
		
		if (iResult == 1) then
			--如果存在组队的房间消息id，进行组队
			if (current_DLCMap_roomid > 0) then
				local tMsg = current_chat_msg_hostory_cache_invite[current_DLCMap_roomid]
				if tMsg then
					local roomId = tMsg.resultParam --可交互类型消息的参数
					if (roomId > 0) then
						--请求加入房间（聊天直接加入）
						SendPvpCmdFunc["enter_room_direct"](roomId, current_DLCMap_roomid)
					end
				end
				
				--清除当前请求组队副本的房间消息id
				current_DLCMap_roomid = 0
			end
		else
			--失败
			--取消挡操作
			hUI.NetDisable(0)
			
			--清除当前请求组队副本的房间消息id
			current_DLCMap_roomid = 0
			
			--冒字
			--local strText = "玩家未初始化" --language
			local strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_USER_INIT"] .. tostring(iResult) --language
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
	
	--函数：收到pvp游戏错误提示事件回调
	on_receive_pvp_NetLogicError_event_chat = function(errorStr)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--冒泡提示文字
		local strText = errorStr
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
	
	--函数：进入pvp房间失败事件
	on_receive_pvp_EnterRoom_Fail_event_page_chat = function(msgId)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--加入房间失败，需要删除此组队邀请消息
		if (msgId > 0) then
			--发送指令，删除组队副本邀请消息
			SendGroupCmdFunc["chat_remove_message_battle"](msgId)
		end
	end
	
	--函数：进入聊天直接进入pvp房间成功事件
	on_receive_pvp_EnterRoom_Success_event_page_chat = function(msgId, room)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--加入房间成功，需要删除此组队邀请消息
		if (msgId > 0) then
			--发送指令，删除组队副本邀请消息
			SendGroupCmdFunc["chat_remove_message_battle"](msgId)
		end
		
		--加入了pvp房间，需要关闭本界面
		--关闭本聊天界面
		_frm.childUI["closeBtn"].data.code()
		
		--弹出聊天直接加入组队界面前，先调用事件
		if (type(current_tCallback) == "table") then
			if (type(current_tCallback.OnBattleInviteEnterFunc) == "function") then
				current_tCallback.OnBattleInviteEnterFunc()
			end
		end
		
		--弹出聊天直接加入组队界面
		hGlobal.event:event("localEvent_ShowPhone_Chat_MyRoomFrm", room, current_tCallback)
	end
	
	--函数：更新支付（土豪）红包消息界面绘制
	update_pay_redpacket_msg_paint = function(selectIdx)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local ctrli = _frmNode.childUI["DLCMapInfoNode" .. selectIdx]
		if ctrli then
			local msgIdi = ctrli.data.msgId
			local tMsg = current_chat_msg_hostory_cache_world[msgIdi]
			if tMsg then
				local msgId = tMsg.id --消息id
				local chatType = tMsg.chatType --聊天频道
				local msgType = tMsg.msgType --消息类型
				if (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --发支付（土豪）红包
					local uid = tMsg.uid --消息发送者uid
					local name = tMsg.name --玩家名
					local channelId = tMsg.channelId --渠道号
					local vip = tMsg.vip --vip等级
					local borderId = tMsg.borderId --边框id
					local iconId = tMsg.iconId --头像id
					local championId = tMsg.championId --称号id
					local leaderId = tMsg.leaderId --会长权限
					local dragonId = tMsg.dragonId --聊天龙王id
					local headId = tMsg.headId --头衔id
					local lineId = tMsg.lineId --线索id
					local date = tMsg.date --日期
					local content = tMsg.content --聊天内容
					local touid = tMsg.touid --接收者uid
					local result = tMsg.result --可交互类型消息的操作结果
					local resultParam = tMsg.resultParam --可交互类型消息的参数
					local redPacketParam = tMsg.redPacketParam --红包消息参数
					
					--支付（土豪）红包的红包参数信息
					local redPacketId = redPacketParam.redPacketId --红包唯一id
					local send_uid = redPacketParam.send_uid --红包发送者uid
					local send_name = redPacketParam.send_name --红包发送者名字
					local send_num = redPacketParam.send_num --红包发送数量
					local content = redPacketParam.content --内容
					local money = redPacketParam.money --充值金额
					local iap_id = redPacketParam.iap_id --充值记录id
					local channelId = redPacketParam.channelId --渠道号
					local vipLv = redPacketParam.vipLv --vip等级
					local borderId = redPacketParam.borderId --边框id
					local iconId = redPacketParam.iconId --头像id
					local championId = redPacketParam.championId --称号id
					local leaderId = redPacketParam.leaderId --会长权限
					local dragonId = redPacketParam.dragonId --聊天龙王id
					local headId = redPacketParam.headId --头衔id
					local lineId = redPacketParam.lineId --线索id
					local msg_id = redPacketParam.msg_id --消息id
					local receive_num = redPacketParam.receive_num --红包接收数量
					local send_time = redPacketParam.send_time --红包发送时间
					local expire_time = redPacketParam.expire_time --红包过期时间
					local redPacketReceiveList = redPacketParam.redPacketReceiveList --红包领取uid列表
					--print(expire_time)
					
					--更新红包数量
					local lefenum = send_num - receive_num
					--ctrli.childUI["num"]:setText("x" .. lefenum)
					
					--我是否已领取
					local uidMe = xlPlayer_GetUID()
					local bRewardMe = redPacketReceiveList[uidMe]
					
					if (lefenum <= 0) then --已被领完
						--防止弹框（异步绘制阶段）
						if ctrli.childUI["redPacket"] and ctrli.childUI["redPacketEmpty"] then
							--红包底图灰掉
							ctrli.childUI["redPacket"].handle._n:setVisible(false)
							ctrli.childUI["redPacketEmpty"].handle._n:setVisible(true)
							--ctrli.childUI["redPacket"].handle.s:setColor(ccc3(64, 64, 64))
							
							--灰掉红包图标
							local shaderType = ctrli.childUI["redPacketIcon"].data.shaderType
							if (shaderType ~= "gray") then
								hApi.AddShader(ctrli.childUI["redPacketIcon"].handle.s, "gray")
								ctrli.childUI["redPacketIcon"].data.shaderType = "gray"
								--print("灰掉红包图标")
							end
							
							--暗淡文字
							ctrli.childUI["content"].handle.s:setColor(ccc3(224, 224, 0))
							
							--显示/隐藏已领取图标
							if bRewardMe then
								ctrli.childUI["rewardIcon"].handle._n:setVisible(true)
							else
								ctrli.childUI["rewardIcon"].handle._n:setVisible(false)
							end
							
							--隐藏领取文字
							ctrli.childUI["torewardlabel"].handle._n:setVisible(false)
							
							--隐藏已领取文字
							ctrli.childUI["rewardlabel"].handle._n:setVisible(false)
							
							--显示已被领完文字
							ctrli.childUI["rewardFinishlabel"].handle._n:setVisible(true)
							
							--不显示倒计时
							--...
						end
					elseif bRewardMe then --我已领取
						--防止弹框（异步绘制阶段）
						if ctrli.childUI["redPacket"] and ctrli.childUI["redPacketEmpty"] then
							--红包底图灰掉
							ctrli.childUI["redPacket"].handle._n:setVisible(false)
							ctrli.childUI["redPacketEmpty"].handle._n:setVisible(true)
							--ctrli.childUI["redPacket"].handle.s:setColor(ccc3(64, 64, 64))
							
							--高亮红包图标
							local shaderType = ctrli.childUI["redPacketIcon"].data.shaderType
							if (shaderType ~= "normal") then
								hApi.AddShader(ctrli.childUI["redPacketIcon"].handle.s, "normal")
								ctrli.childUI["redPacketIcon"].data.shaderType = "normal"
								--print("高亮红包图标")
							end
							
							--暗淡文字
							ctrli.childUI["content"].handle.s:setColor(ccc3(224, 224, 0))
							
							--显示已领取图标
							ctrli.childUI["rewardIcon"].handle._n:setVisible(true)
							
							--隐藏领取文字
							ctrli.childUI["torewardlabel"].handle._n:setVisible(false)
							
							--显示已领取文字
							ctrli.childUI["rewardlabel"].handle._n:setVisible(true)
							
							--隐藏已被领完文字
							ctrli.childUI["rewardFinishlabel"].handle._n:setVisible(false)
							
							--不显示倒计时
							--...
						end
					else
						--未领取
						
						--防止弹框（异步绘制阶段）
						if ctrli.childUI["redPacket"] and ctrli.childUI["redPacketEmpty"] then
							--红包底图高亮
							ctrli.childUI["redPacket"].handle._n:setVisible(true)
							ctrli.childUI["redPacketEmpty"].handle._n:setVisible(false)
							--ctrli.childUI["redPacket"].handle.s:setColor(ccc3(255, 255, 255))
							
							--高亮红包图标
							local shaderType = ctrli.childUI["redPacketIcon"].data.shaderType
							if (shaderType ~= "normal") then
								hApi.AddShader(ctrli.childUI["redPacketIcon"].handle.s, "normal")
								ctrli.childUI["redPacketIcon"].data.shaderType = "normal"
								--print("高亮红包图标")
							end
							
							--高亮文字
							ctrli.childUI["content"].handle.s:setColor(ccc3(255, 255, 0))
							
							--隐藏已领取图标
							ctrli.childUI["rewardIcon"].handle._n:setVisible(false)
							
							--显示领取文字
							ctrli.childUI["torewardlabel"].handle._n:setVisible(true)
							
							--隐藏已领取文字
							ctrli.childUI["rewardlabel"].handle._n:setVisible(false)
							
							--隐藏已被领完文字
							ctrli.childUI["rewardFinishlabel"].handle._n:setVisible(false)
							
							--[[
							--计算倒计时失效时间
							--客户端的时间
							local localTime = os.time()
							
							--服务器的时间
							local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
							local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
							local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
							hostTime = hostTime - delteZone * 3600 --GMT+8时区
							local nExpireTime = hApi.GetNewDate(expire_time) --时间戳
							local deltaSeconds = nExpireTime - hostTime --秒数
							if (deltaSeconds < 0) then
								deltaSeconds = 0
							end
							local day = math.floor(deltaSeconds / 3600 / 24) --时
							local hour = math.floor((deltaSeconds - day * 24 * 3600) / 3600) --时
							local minute = math.floor((deltaSeconds - day * 24 * 3600 hour * 3600)/ 60) --分
							local second = deltaSeconds - hour * 3600 - minute * 60 --秒
							
							--拼接字符串
							local szDay = tostring(day) --天(字符串)
							local szHour = tostring(hour) --时(字符串)
							if (#szHour < 2) then
								szHour = "0" .. szHour
							end
							local szMinute = tostring(minute) --分(字符串)
							--if (#szMinute < 2) then
							--	szMinute = "0" .. szMinute
							--end
							local szSecond = tostring(second) --秒(字符串)
							if (#szSecond < 2) then
								szSecond = "0" .. szSecond
							end
							
							--显示倒计时
							--...
							]]
						end
					end
				end
			end
		end
	end
	
	--函数：更新军团红包消息界面绘制
	update_group_redpacket_msg_paint = function(selectIdx)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local ctrli = _frmNode.childUI["DLCMapInfoNode" .. selectIdx]
		if ctrli then
			local msgIdi = ctrli.data.msgId
			local tMsg = current_chat_msg_hostory_cache_group[msgIdi]
			if tMsg then
				local msgId = tMsg.id --消息id
				local chatType = tMsg.chatType --聊天频道
				local msgType = tMsg.msgType --消息类型
				if (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) then --军团发红包
					local uid = tMsg.uid --消息发送者uid
					local name = tMsg.name --玩家名
					local channelId = tMsg.channelId --渠道号
					local vip = tMsg.vip --vip等级
					local borderId = tMsg.borderId --边框id
					local iconId = tMsg.iconId --头像id
					local championId = tMsg.championId --称号id
					local leaderId = tMsg.leaderId --会长权限
					local dragonId = tMsg.dragonId --聊天龙王id
					local headId = tMsg.headId --头衔id
					local lineId = tMsg.lineId --线索id
					local date = tMsg.date --日期
					local content = tMsg.content --聊天内容
					local touid = tMsg.touid --接收者uid
					local result = tMsg.result --可交互类型消息的操作结果
					local resultParam = tMsg.resultParam --可交互类型消息的参数
					local redPacketParam = tMsg.redPacketParam --红包消息参数
					
					--军团红包的红包参数信息
					local redPacketId = redPacketParam.redPacketId --红包唯一id
					local send_uid = redPacketParam.send_uid --红包发送者uid
					local send_name = redPacketParam.send_name --红包发送者名字
					local group_id = redPacketParam.group_id --红包军团id
					local send_num = redPacketParam.send_num --红包发送数量
					local content = redPacketParam.content --内容
					local coin = redPacketParam.coin --游戏币
					local order_id = redPacketParam.order_id --订单号
					local msg_id = redPacketParam.msg_id --消息id
					local receive_num = redPacketParam.receive_num --红包接收数量
					local send_time = redPacketParam.send_time --红包发送时间
					local expire_time = redPacketParam.expire_time --红包过期时间
					local redPacketReceiveList = redPacketParam.redPacketReceiveList --红包领取uid列表
					--print(expire_time)
					
					--更新红包数量
					local lefenum = send_num - receive_num
					ctrli.childUI["num"]:setText("x" .. lefenum)
					
					--我是否已领取
					local uidMe = xlPlayer_GetUID()
					local bRewardMe = redPacketReceiveList[uidMe]
					
					if (lefenum <= 0) then --已被领完
						--红包底图灰掉
						ctrli.childUI["redPacket"].handle._n:setVisible(false)
						ctrli.childUI["redPacketEmpty"].handle._n:setVisible(true)
						--ctrli.childUI["redPacket"].handle.s:setColor(ccc3(64, 64, 64))
						
						--灰掉红包图标
						local shaderType = ctrli.childUI["redPacketIcon"].data.shaderType
						if (shaderType ~= "gray") then
							hApi.AddShader(ctrli.childUI["redPacketIcon"].handle.s, "gray")
							ctrli.childUI["redPacketIcon"].data.shaderType = "gray"
							--print("灰掉红包图标")
						end
						
						--暗淡文字
						ctrli.childUI["content"].handle.s:setColor(ccc3(224, 224, 0))
						
						--显示/隐藏已领取图标
						if bRewardMe then
							ctrli.childUI["rewardIcon"].handle._n:setVisible(true)
						else
							ctrli.childUI["rewardIcon"].handle._n:setVisible(false)
						end
						
						--隐藏已领取文字
						ctrli.childUI["rewardlabel"].handle._n:setVisible(false)
						
						--显示已被领完文字
						ctrli.childUI["rewardFinishlabel"].handle._n:setVisible(true)
						
						--不显示倒计时
						ctrli.childUI["lefttimePrefix"].handle._n:setVisible(false) --剩余领取时间
						ctrli.childUI["lefttimeDay"].handle._n:setVisible(false) --红包剩余领取时间-天
						ctrli.childUI["lefttimeDayPostfix"].handle._n:setVisible(false) --红包剩余领取时间-天文字
						ctrli.childUI["lefttimeHour"].handle._n:setVisible(false) --红包剩余领取时间-小时
						ctrli.childUI["lefttimeHourPostfix"].handle._n:setVisible(false) --红包剩余领取时间-小时后缀
						ctrli.childUI["lefttimeMinute"].handle._n:setVisible(false) --红包剩余领取时间-分
						ctrli.childUI["lefttimeMinutePostfix"].handle._n:setVisible(false) --红包剩余领取时间-分文字
						ctrli.childUI["lefttimeSecond"].handle._n:setVisible(false) --红包剩余领取时间-秒
						ctrli.childUI["lefttimeSecondPostfix"].handle._n:setVisible(false) --红包剩余领取时间-秒后缀
					elseif bRewardMe then --我已领取
						--红包底图灰掉
						ctrli.childUI["redPacket"].handle._n:setVisible(false)
						ctrli.childUI["redPacketEmpty"].handle._n:setVisible(true)
						--ctrli.childUI["redPacket"].handle.s:setColor(ccc3(64, 64, 64))
						
						--高亮红包图标
						local shaderType = ctrli.childUI["redPacketIcon"].data.shaderType
						if (shaderType ~= "normal") then
							hApi.AddShader(ctrli.childUI["redPacketIcon"].handle.s, "normal")
							ctrli.childUI["redPacketIcon"].data.shaderType = "normal"
							--print("高亮红包图标")
						end
						
						--暗淡文字
						ctrli.childUI["content"].handle.s:setColor(ccc3(224, 224, 0))
						
						--显示已领取图标
						ctrli.childUI["rewardIcon"].handle._n:setVisible(true)
						
						--显示已领取文字
						ctrli.childUI["rewardlabel"].handle._n:setVisible(true)
						
						--隐藏已被领完文字
						ctrli.childUI["rewardFinishlabel"].handle._n:setVisible(false)
						
						--不显示倒计时
						ctrli.childUI["lefttimePrefix"].handle._n:setVisible(false) --剩余领取时间
						ctrli.childUI["lefttimeDay"].handle._n:setVisible(false) --红包剩余领取时间-天
						ctrli.childUI["lefttimeDayPostfix"].handle._n:setVisible(false) --红包剩余领取时间-天文字
						ctrli.childUI["lefttimeHour"].handle._n:setVisible(false) --红包剩余领取时间-小时
						ctrli.childUI["lefttimeHourPostfix"].handle._n:setVisible(false) --红包剩余领取时间-小时后缀
						ctrli.childUI["lefttimeMinute"].handle._n:setVisible(false) --红包剩余领取时间-分
						ctrli.childUI["lefttimeMinutePostfix"].handle._n:setVisible(false) --红包剩余领取时间-分文字
						ctrli.childUI["lefttimeSecond"].handle._n:setVisible(false) --红包剩余领取时间-秒
						ctrli.childUI["lefttimeSecondPostfix"].handle._n:setVisible(false) --红包剩余领取时间-秒后缀
					else
						--未领取
						
						--红包底图高亮
						ctrli.childUI["redPacket"].handle._n:setVisible(true)
						ctrli.childUI["redPacketEmpty"].handle._n:setVisible(false)
						--ctrli.childUI["redPacket"].handle.s:setColor(ccc3(255, 255, 255))
						
						--高亮红包图标
						local shaderType = ctrli.childUI["redPacketIcon"].data.shaderType
						if (shaderType ~= "normal") then
							hApi.AddShader(ctrli.childUI["redPacketIcon"].handle.s, "normal")
							ctrli.childUI["redPacketIcon"].data.shaderType = "normal"
							--print("高亮红包图标")
						end
						
						--高亮文字
						ctrli.childUI["content"].handle.s:setColor(ccc3(255, 255, 0))
						
						--隐藏已领取图标
						ctrli.childUI["rewardIcon"].handle._n:setVisible(false)
						
						--隐藏已领取文字
						ctrli.childUI["rewardlabel"].handle._n:setVisible(false)
						
						--隐藏已被领完文字
						ctrli.childUI["rewardFinishlabel"].handle._n:setVisible(false)
						
						--计算倒计时失效时间
						--客户端的时间
						local localTime = os.time()
						
						--服务器的时间
						local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
						local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
						local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
						hostTime = hostTime - delteZone * 3600 --GMT+8时区
						local nExpireTime = hApi.GetNewDate(expire_time) --时间戳
						local deltaSeconds = nExpireTime - hostTime --秒数
						if (deltaSeconds < 0) then
							deltaSeconds = 0
						end
						local day = math.floor(deltaSeconds / 3600 / 24) --时
						local hour = math.floor((deltaSeconds - day * 24 * 3600) / 3600) --时
						local minute = math.floor((deltaSeconds - day * 24 * 3600 - hour * 3600)/ 60) --分
						local second = deltaSeconds - hour * 3600 - minute * 60 --秒
						
						--拼接字符串
						local szDay = tostring(day) --天(字符串)
						local szHour = tostring(hour) --时(字符串)
						if (#szHour < 2) then
							szHour = "0" .. szHour
						end
						local szMinute = tostring(minute) --分(字符串)
						--if (#szMinute < 2) then
						--	szMinute = "0" .. szMinute
						--end
						local szSecond = tostring(second) --秒(字符串)
						if (#szSecond < 2) then
							szSecond = "0" .. szSecond
						end
						
						--显示倒计时
						ctrli.childUI["lefttimePrefix"].handle._n:setVisible(true) --剩余领取时间
						if (day > 0) or (hour > 0) then --1小时以上
							--天、时
							ctrli.childUI["lefttimeDay"].handle._n:setVisible(true) --红包剩余领取时间-天
							ctrli.childUI["lefttimeDayPostfix"].handle._n:setVisible(true) --红包剩余领取时间-天文字
							ctrli.childUI["lefttimeHour"].handle._n:setVisible(true) --红包剩余领取时间-小时
							ctrli.childUI["lefttimeHourPostfix"].handle._n:setVisible(true) --红包剩余领取时间-小时后缀
							
							--分、秒
							ctrli.childUI["lefttimeMinute"].handle._n:setVisible(false) --红包剩余领取时间-分
							ctrli.childUI["lefttimeMinutePostfix"].handle._n:setVisible(false) --红包剩余领取时间-分文字
							ctrli.childUI["lefttimeSecond"].handle._n:setVisible(false) --红包剩余领取时间-秒
							ctrli.childUI["lefttimeSecondPostfix"].handle._n:setVisible(false) --红包剩余领取时间-秒后缀
						else
							--天、时
							ctrli.childUI["lefttimeDay"].handle._n:setVisible(false) --红包剩余领取时间-天
							ctrli.childUI["lefttimeDayPostfix"].handle._n:setVisible(false) --红包剩余领取时间-天文字
							ctrli.childUI["lefttimeHour"].handle._n:setVisible(false) --红包剩余领取时间-小时
							ctrli.childUI["lefttimeHourPostfix"].handle._n:setVisible(false) --红包剩余领取时间-小时后缀
							
							--分、秒
							ctrli.childUI["lefttimeMinute"].handle._n:setVisible(true) --红包剩余领取时间-分
							ctrli.childUI["lefttimeMinutePostfix"].handle._n:setVisible(true) --红包剩余领取时间-分文字
							ctrli.childUI["lefttimeSecond"].handle._n:setVisible(true) --红包剩余领取时间-秒
							ctrli.childUI["lefttimeSecondPostfix"].handle._n:setVisible(true) --红包剩余领取时间-秒后缀
						end
						
						if (day > 0) or (hour > 0) then --1小时以上
							ctrli.childUI["lefttimeDay"]:setText(szDay)
							ctrli.childUI["lefttimeHour"]:setText(szHour)
						else
							ctrli.childUI["lefttimeMinute"]:setText(szMinute)
							ctrli.childUI["lefttimeSecond"]:setText(szSecond)
						end
					end
				end
			end
		end
	end
	
	--函数：创建发军团红包界面
	on_create_group_redpacket_send_frame = function()
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--删除上一次的界面
		if hGlobal.UI.SendRedPacketFrm then
			hGlobal.UI.SendRedPacketFrm:del()
			hGlobal.UI.SendRedPacketFrm = nil
		end
		
		--print("on_create_group_redpacket_send_frame")
		
		local BOARD_WIDTH = 416 --选卡面板的宽度
		local BOARD_HEIGHT = 580 - 10 --选卡面板的高度
		local BOARD_OFFSETX = -3 --选卡面板y偏移中心点的值
		local BOARD_OFFSETY = 5 --选卡面板y偏移中心点的值
		local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --聊天面板的x位置（最左侧）
		local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --聊天面板的y位置（最顶侧）
		
		--创建发红包界面
		hGlobal.UI.SendRedPacketFrm = hUI.frame:new(
		{
			x = BOARD_POS_X,
			y = BOARD_POS_Y,
			z = hZorder.CommonUIFrame + 1,
			w = BOARD_WIDTH,
			h = BOARD_HEIGHT,
			dragable = 2,
			show = 1, --一开始不显示
			--border = "UI:TileFrmBasic_thin",
			--border = "UI:TileFrmBack_PVP",
			--background = "panel/panel_part_pvp_00.png",
			background = "panel/panel_part_00.png", --"UI:Tactic_Background",
			--background = "UI:tip_item",
			--background = "UI:Tactic_Background",
			border = 1, --显示frame边框
			--background = "misc/chest/bottom9g.png", --"UI:Tactic_Background",
			autoactive = 0,
			
			--点击事件
			codeOnTouch = function(self, x, y, sus)
				--在外部点击
				if (sus == 0) then
					self.childUI["closeBtn"].data.code()
				end
			end,
		})
		
		local _frm2 = hGlobal.UI.SendRedPacketFrm
		local _parent2 = _frm2.handle._n
		
		_frm2:active()
		
		--选中的红包数量序号值
		local selectedNumIdx = 1
		
		--背景底图
		_frm2.childUI["BG"] = hUI.image:new({
			parent = _parent2,
			model = "misc/mask_white.png",
			x = 0,
			y = 0,
			z = -100,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
		})
		_frm2.childUI["BG"].handle.s:setOpacity(88)
		_frm2.childUI["BG"].handle.s:setColor(ccc3(0, 0, 0))
		
		--九宫格边框
		--local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bottom9s.png", BOARD_WIDTH/2, -BOARD_HEIGHT/2, BOARD_WIDTH, BOARD_HEIGHT, _frm2)
		
		--标题图标
		_frm2.childUI["titleImgIcon"] = hUI.image:new({
			parent = _parent2,
			model = "misc/chest/redpacket.png",
			x = 150,
			y = -60,
			w = 60,
			h = 60,
		})
		
		--标题边框
		_frm2.childUI["titleImgBorder"] = hUI.image:new({
			parent = _parent2,
			model = "misc/chest/purchase_border.png",
			x = 150,
			y = -60,
			w = 62,
			h = 62,
		})
		
		--标题文字
		_frm2.childUI["titleLabel"] = hUI.label:new({
			parent = _parent2,
			size = 32,
			font = hVar.FONTC,
			border = 1,
			align = "LC",
			x = 150 + 50,
			y = -60 - 1,
			width = 500,
			text = hVar.tab_string["__TEXT_MAINUI_BTN_GROUP"] .. hVar.tab_string["__TEXT_MAINUI_BTN_REDPACKET"], --军团红包
			RGB = {255, 64, 0,},
		})
		
		--军团红包tip按钮（响应区域）
		_frm2.childUI["btnTip"] = hUI.button:new({
			parent = _parent2,
			dragbox = _frm2.childUI["dragBox"],
			x = 40,
			y = -60,
			w = 100,
			h = 100,
			model = "misc/mask.png",
			scaleT = 1.0,
			code = function()
				--创建发红包规则介绍tip
				OnCreateSendRedPacketTipFrame()
			end,
		})
		_frm2.childUI["btnTip"].handle.s:setOpacity(0) --用于响应事件，不显示
		
		--问号图标
		_frm2.childUI["btnTip"].childUI["icon"] = hUI.image:new({
			parent = _frm2.childUI["btnTip"].handle._n,
			x = 0,
			y = 0,
			scale = 0.9,
			model = "ICON:action_info",
		})
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(1.0, 0.87) ,CCScaleTo:create(1.0, 0.93))
		local forever = CCRepeatForever:create(tolua.cast(towAction,"CCActionInterval"))
		_frm2.childUI["btnTip"].childUI["icon"].handle._n:runAction(forever)
		
		--请选择红包类型的文字
		_frm2.childUI["selectNoticeLabel"] = hUI.label:new({
			parent = _parent2,
			size = 24,
			font = hVar.FONTC,
			border = 1,
			align = "LC",
			x = 30,
			y = -180,
			width = 500,
			text = hVar.tab_string["__GROUP_REDPACKET_TIP_NUM"], --"请选择红包个数"
			RGB = {224, 224, 224,},
		})
		
		--红包（小）
		local shopItemIdMin = hVar.CHAT_GROUP_RED_PACKET_SHOPITEM[1]
		local tShopItemMin = hVar.tab_shopitem[shopItemIdMin]
		local numMin = tShopItemMin.num
		local gamecoinMin = tShopItemMin.rmb
		_frm2.childUI["btnRedPacketMin"] = hUI.button:new({
			parent = _parent2,
			dragbox = _frm2.childUI["dragBox"],
			x = 110,
			y = -270,
			w = 180,
			h = 140,
			model = "misc/mask.png",
			scaleT = 0.98,
			code = function()
				--选中红包（小）
				if (selectedNumIdx ~= 1) then --不重复选择
					--标记选中红包（小）
					selectedNumIdx = 1
					
					--红包（小）控件高亮
					_frm2.childUI["btnRedPacketMin"].data.s91:setVisible(false)
					_frm2.childUI["btnRedPacketMin"].data.s92:setVisible(true)
					_frm2.childUI["btnRedPacketMin"].childUI["num"].handle.s:setColor(ccc3(255, 255, 0))
					_frm2.childUI["btnRedPacketMin"].childUI["selectbox"].handle._n:setVisible(true)
					
					--红包（大）控件暗淡
					_frm2.childUI["btnRedPacketMax"].data.s91:setVisible(true)
					_frm2.childUI["btnRedPacketMax"].data.s92:setVisible(false)
					_frm2.childUI["btnRedPacketMax"].childUI["num"].handle.s:setColor(ccc3(128, 128, 128))
					_frm2.childUI["btnRedPacketMax"].childUI["selectbox"].handle._n:setVisible(false)
					
					--更新游戏币数量
					local shopItemId = hVar.CHAT_GROUP_RED_PACKET_SHOPITEM[selectedNumIdx]
					local tShopItem = hVar.tab_shopitem[shopItemId]
					local numMin = tShopItem.num
					local gamecoinMin = tShopItem.rmb
					_frm2.childUI["gamecoinLabel"]:setText(gamecoinMin)
				end
			end,
		})
		_frm2.childUI["btnRedPacketMin"].handle.s:setOpacity(0) --用于响应事件，不显示
		
		--红包（小）边框1
		local s91 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_attr.png", 0, 0, 160, 120, _frm2.childUI["btnRedPacketMin"])
		s91:setOpacity(48)
		s91:setVisible(false)
		_frm2.childUI["btnRedPacketMin"].data.s91 = s91
		
		--红包（大）边框2
		local s92 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_attr.png", 0, 0, 160, 120, _frm2.childUI["btnRedPacketMin"])
		_frm2.childUI["btnRedPacketMin"].data.s92 = s92
		
		--红包（小）数量
		_frm2.childUI["btnRedPacketMin"].childUI["num"] = hUI.label:new({
			parent = _frm2.childUI["btnRedPacketMin"].handle._n,
			size = 48,
			font = hVar.FONTC,
			border = 1,
			align = "MC",
			x = 0,
			y = -3, --数字字体有3像素的偏差
			width = 500,
			text = tostring(numMin) .. hVar.tab_string["__TEXT_COUNT"], --"个"
			--RGB = {128, 128, 128,}, --灰色
			RGB = {255, 255, 0,}, --黄色
		})
		
		--红包（小）选中框
		_frm2.childUI["btnRedPacketMin"].childUI["selectbox"] = hUI.image:new({
			parent = _frm2.childUI["btnRedPacketMin"].handle._n,
			dragbox = _frm2.childUI["dragBox"],
			x = 54,
			y = -32,
			model = "UI:ok",
			scale = 1.0,
		})
		
		--红包（大）
		local shopItemIdMax = hVar.CHAT_GROUP_RED_PACKET_SHOPITEM[2]
		local tShopItemMax = hVar.tab_shopitem[shopItemIdMax]
		local numMax = tShopItemMax.num
		local gamecoinMax = tShopItemMax.rmb
		_frm2.childUI["btnRedPacketMax"] = hUI.button:new({
			parent = _parent2,
			dragbox = _frm2.childUI["dragBox"],
			x = 310,
			y = -270,
			w = 180,
			h = 140,
			model = "misc/mask.png",
			scaleT = 0.98,
			code = function()
				--选中红包（大）
				if (selectedNumIdx ~= 2) then --不重复选择
					--标记选中红包（大）
					selectedNumIdx = 2
					
					--红包（小）控件暗淡
					_frm2.childUI["btnRedPacketMin"].data.s91:setVisible(true)
					_frm2.childUI["btnRedPacketMin"].data.s92:setVisible(false)
					_frm2.childUI["btnRedPacketMin"].childUI["num"].handle.s:setColor(ccc3(128, 128, 128))
					_frm2.childUI["btnRedPacketMin"].childUI["selectbox"].handle._n:setVisible(false)
					
					--红包（大）控件高亮
					_frm2.childUI["btnRedPacketMax"].data.s91:setVisible(false)
					_frm2.childUI["btnRedPacketMax"].data.s92:setVisible(true)
					_frm2.childUI["btnRedPacketMax"].childUI["num"].handle.s:setColor(ccc3(255, 255, 0))
					_frm2.childUI["btnRedPacketMax"].childUI["selectbox"].handle._n:setVisible(true)
					
					--更新游戏币数量
					local shopItemId = hVar.CHAT_GROUP_RED_PACKET_SHOPITEM[selectedNumIdx]
					local tShopItem = hVar.tab_shopitem[shopItemId]
					local numMin = tShopItem.num
					local gamecoinMin = tShopItem.rmb
					_frm2.childUI["gamecoinLabel"]:setText(gamecoinMin)
				end
			end,
		})
		_frm2.childUI["btnRedPacketMax"].handle.s:setOpacity(0) --用于响应事件，不显示
		
		--红包（大）边框1
		local s91 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_attr.png", 0, 0, 160, 120, _frm2.childUI["btnRedPacketMax"])
		s91:setOpacity(48)
		_frm2.childUI["btnRedPacketMax"].data.s91 = s91
		
		--红包（大）边框2
		local s92 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_attr.png", 0, 0, 160, 120, _frm2.childUI["btnRedPacketMax"])
		s92:setVisible(false)
		_frm2.childUI["btnRedPacketMax"].data.s92 = s92
		
		--红包（大）数量
		_frm2.childUI["btnRedPacketMax"].childUI["num"] = hUI.label:new({
			parent = _frm2.childUI["btnRedPacketMax"].handle._n,
			size = 48,
			font = hVar.FONTC,
			border = 1,
			align = "MC",
			x = 0,
			y = -3, --数字字体有3像素的偏差
			width = 500,
			text = tostring(numMax) .. hVar.tab_string["__TEXT_COUNT"], --"个"
			RGB = {128, 128, 128,}, --灰色
			--RGB = {255, 255, 0,}, --黄色
		})
		
		--红包（大）选中框
		_frm2.childUI["btnRedPacketMax"].childUI["selectbox"] = hUI.image:new({
			parent = _frm2.childUI["btnRedPacketMax"].handle._n,
			dragbox = _frm2.childUI["dragBox"],
			x = 54,
			y = -32,
			model = "UI:ok",
			scale = 1.0,
		})
		_frm2.childUI["btnRedPacketMax"].childUI["selectbox"].handle._n:setVisible(false) --默认不显示
		
		--游戏币消耗文字
		_frm2.childUI["gamecoinLabelPrefix"] = hUI.label:new({
			parent = _parent2,
			size = 24,
			font = hVar.FONTC,
			border = 1,
			align = "RC",
			x = 200 - 18,
			y = -440 - 14,
			width = 500,
			text = hVar.tab_string["__TEXT_CONSUME"], --"消耗"
			RGB = {255, 236, 0,},
		})
		
		--游戏币图标
		_frm2.childUI["gamecoinIcon"] = hUI.image:new({
			parent = _parent2,
			x = 200 + 4,
			y = -440 - 12,
			scale = 0.76,
			model = "UI:game_coins",
		})
		
		--游戏币数量
		_frm2.childUI["gamecoinLabel"] = hUI.label:new({
			parent = _parent2,
			size = 26,
			font = "num",
			border = 0,
			align = "LC",
			x = 200 + 24,
			y = -440 - 14 - 1,
			width = 500,
			text = gamecoinMin,
		})
		
		--发红包按钮
		_frm2.childUI["btnSendRedPacket"] = hUI.button:new({
			parent = _parent2,
			dragbox = _frm2.childUI["dragBox"],
			x = 210,
			y = -440 - 50 - 14,
			w = 200,
			h = 80,
			model = "misc/mask.png",
			scaleT = 0.95,
			code = function()
				--如果未连接socket工会服务器，不能操作
				if (Group_Server:GetState() ~= 1) then --未连接
					--冒字
					--local strText = "不能连接到网络" --language
					local strText = hVar.tab_string["ios_err_network_cannot_conn"] --language
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
				
				--如果未登入工会服务器，不能操作
				if (Group_Server:getonline() ~= 1) then --未登入
					--冒字
					--local strText = "不能连接到网络" --language
					local strText = hVar.tab_string["ios_err_network_cannot_conn"] --language
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
				
				--今日剩余发红包次数
				local vip = LuaGetPlayerVipLv() or 0
				local sendMaxNum = hVar.Vip_Conifg.groupSendRedpacketCount[vip] or 0
				local leftSendCount = sendMaxNum - current_group_send_redpacket_num
				if (leftSendCount < 0) then
					leftSendCount = 0
				end
				--有次数
				if (leftSendCount > 0) then
					--检测游戏币是否足够
					local shopItemId = hVar.CHAT_GROUP_RED_PACKET_SHOPITEM[selectedNumIdx]
					local tShopItem = hVar.tab_shopitem[shopItemId]
					local gamecoinCost = tShopItem.rmb
					local currentRmb = LuaGetPlayerRmb() --玩家当前的游戏币
					
					--游戏币不足
					if (currentRmb < gamecoinCost) then 
						--冒字
						--local strText = "游戏币不足" --language
						local strText = hVar.tab_string["ios_not_enough_game_coin"] --language
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
					
					--通过校验
					--消费弹窗提示
					hApi.ShowConsumeFrm(gamecoinCost, function()
						--挡操作
						hUI.NetDisable(30000)
						
						--本地发红包次数加1
						current_group_send_redpacket_num = current_group_send_redpacket_num + 1
						
						--发红包指令
						local groupId = current_msgGroupId
						local index = selectedNumIdx
						SendGroupCmdFunc["group_send_redpacket"](groupId, index)
						
						--删除本界面
						if hGlobal.UI.SendRedPacketFrm then
							hGlobal.UI.SendRedPacketFrm:del()
							hGlobal.UI.SendRedPacketFrm = nil
						end
					end)
				else
					--冒字
					--local strText = "今日发红包次数已达上限" --language
					local strText = hVar.tab_string["ios_err_network_cannot_redpacker_maxcount"] --language
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
			end,
		})
		_frm2.childUI["btnSendRedPacket"].handle.s:setOpacity(0) --只响应事件，不显示
		--发送图片
		_frm2.childUI["btnSendRedPacket"].childUI["image"] = hUI.image:new({
			parent = _frm2.childUI["btnSendRedPacket"].handle._n,
			dragbox = _frm2.childUI["dragBox"],
			x = 0,
			y = 0,
			w = 175,
			h = 64,
			model = "misc/chest/button_red.png",
		})
		--发送文字
		local vip = LuaGetPlayerVipLv() or 0
		local sendMaxNum = hVar.Vip_Conifg.groupSendRedpacketCount[vip] or 0
		local leftSendCount = sendMaxNum - current_group_send_redpacket_num
		if (leftSendCount < 0) then
			leftSendCount = 0
		end
		_frm2.childUI["btnSendRedPacket"].childUI["label"] = hUI.label:new({
			parent = _frm2.childUI["btnSendRedPacket"].handle._n,
			x = 0,
			y = 2,
			size = 26,
			align = "MC",
			border = 1,
			text = hVar.tab_string["__GROUP_REDPACKET_SEND_BTN"] .. " (" .. leftSendCount .. ")", --"发红包 (" .. leftSendCount .. ")"
			font = hVar.FONTC,
			RGB = {255, 255, 0,},
		})
		--有次数
		if (leftSendCount > 0) then
			--高亮
			hApi.AddShader(_frm2.childUI["btnSendRedPacket"].childUI["image"].handle.s, "normal")
			_frm2.childUI["btnSendRedPacket"].childUI["label"].handle.s:setColor(ccc3(255, 255, 0))
		else
			--灰掉
			hApi.AddShader(_frm2.childUI["btnSendRedPacket"].childUI["image"].handle.s, "gray")
			_frm2.childUI["btnSendRedPacket"].childUI["label"].handle.s:setColor(ccc3(168, 168, 168))
		end
		
		--关闭按钮
		_frm2.childUI["closeBtn"] = hUI.button:new({
			parent = _parent2,
			dragbox = _frm2.childUI["dragBox"],
			--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
			model = "BTN:PANEL_CLOSE",
			x = _frm2.data.w - 4,
			y = -8,
			z = 103,
			scaleT = 0.95,
			code = function()
				--删除本界面
				if hGlobal.UI.SendRedPacketFrm then
					hGlobal.UI.SendRedPacketFrm:del()
					hGlobal.UI.SendRedPacketFrm = nil
				end
			end,
		})
	end
	
	--函数：创建发红包规则介绍的tip
	OnCreateSendRedPacketTipFrame = function()
		--创建军团红包介绍tip
		local grouppacketTip = hUI.uiTip:new()
		grouppacketTip:AddIcon("misc/chest/redpacket.png")
		grouppacketTip:AddTitle(hVar.tab_string["__GROUP_REDPACKET_TIP_TITLE"], ccc3(255, 173, 65)) --"军团红包介绍"
		grouppacketTip:AddContent(hVar.tab_string["__GROUP_REDPACKET_TIP_1"]) --"1、VIP3及以上的玩家，每天可以发放红包。VIP等级越高，每天可发放的次数越多。"
		grouppacketTip:AddContent(hVar.tab_string["__GROUP_REDPACKET_TIP_2"]) --"2、红包共有两个档位：88游戏币"
		grouppacketTip:AddContent(hVar.tab_string["__GROUP_REDPACKET_TIP_3"]) --"3、红包发送后，发放者可立即获得随机军团资源奖励，同时军团成员可领取红包。"
		grouppacketTip:AddContent(hVar.tab_string["__GROUP_REDPACKET_TIP_4"]) --"4、红包领取后可随机获得奖励。"
		grouppacketTip:AddContent(hVar.tab_string["__GROUP_REDPACKET_TIP_5"]) --"5、红包发放后，需在48小时内领完，过期消失。"
		--grouppacketTip:AddContent(hVar.tab_string["__GROUP_REDPACKET_TIP_6"]) --"6、需加入军团24小时以上才能发放或领取红包。"
		grouppacketTip:AddContent(hVar.tab_string["__GROUP_REDPACKET_TIP_7"]) --"7、每日0点重置发红包次数。"
		grouppacketTip:SetTitleCentered()
	end
	
	--函数：收到更新聊天消息事件返回
	on_receive_update_chat_message_event = function(tChatMsg)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("收到单条聊天消息事件返回", tChatMsg.id, "current_chat_type=", current_chat_type)
		
		--移除超时检测timer
		hApi.clearTimer("__ONCE_CHAT_TIMEOUNT_TIMER__")
		
		--取消挡操作
		--hUI.NetDisable(0)
		--隐藏菊花
		if _frmNode.childUI["waiting"] then
			_frmNode.childUI["waiting"]:setstate(-1) --已联网不显示菊花
		end
		
		if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
			--更新世界聊天内容
			local msgId = tChatMsg.id
			if current_chat_msg_hostory_cache_world[msgId] then --只覆盖已存在的消息
				current_chat_msg_hostory_cache_world[msgId] = tChatMsg
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
			--更新邀请聊天内容
			local msgId = tChatMsg.id
			if current_chat_msg_hostory_cache_invite[msgId] then --只覆盖已存在的消息
				current_chat_msg_hostory_cache_invite[msgId] = tChatMsg
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			--不处理
			--...
		elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
			--更新军团聊天内容
			local msgId = tChatMsg.id
			if current_chat_msg_hostory_cache_group[msgId] then --只覆盖已存在的消息
				current_chat_msg_hostory_cache_group[msgId] = tChatMsg
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
			--更新组队聊天内容
			local msgId = tChatMsg.id
			if current_chat_msg_hostory_cache_couple[msgId] then --只覆盖已存在的消息
				current_chat_msg_hostory_cache_couple[msgId] = tChatMsg
			end
		end
	end
	
	--函数：收到删除聊天消息事件返回
	on_receive_remove_chat_message_event = function(msgId)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
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
		--[[
		if (delta1_ly == 0) and (deltNa_ry >= 0) then
			in_scroll_down = true
		end
		if (deltNa_ry == 0) then
			in_scroll_down = true
		end
		]]
		--geyachao: 已改为前序控件往下移动，所以删除操作不再需要检测之前的滑动状态了
		--print("删除前 in_scroll_down=", in_scroll_down)
		
		--查找并删除对应的 世界/邀请/私聊/军团/组队 聊天消息
		for i = current_DLCMap_max_num, 1, -1 do
			local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
			if ctrli then
				local msgIdi = ctrli.data.msgId
				local chatHeight_i = ctrli.data.chatHeight
				
				if (msgId == msgIdi) then
					--删除控件
					hApi.safeRemoveT(_frmNode.childUI, "DLCMapInfoNode" .. i)
					--print("删除控件", i)
					
					--后续控件索引位置依次前移
					if (i < current_DLCMap_max_num) then
						for j = i + 1, current_DLCMap_max_num, 1 do
							local ctrlj = _frmNode.childUI["DLCMapInfoNode" .. j]
							if ctrlj then
								_frmNode.childUI["DLCMapInfoNode" .. (j - 1)] = ctrlj
								
								--[[
								--调整后续控件的坐标
								local posXj = ctrlj.data.x
								local posYj = ctrlj.data.y
								--理论相对距离
								local thisXj = posXj
								local thisYj = posYj + chatHeight_i
								ctrlj.handle._n:setPosition(thisXj, thisYj)
								ctrlj.data.x = thisXj
								ctrlj.data.y = thisYj
								]]
							end
						end
					end
					
					--前序控件往下挪
					for j = 1, i - 1, 1 do
						local ctrlj = _frmNode.childUI["DLCMapInfoNode" .. j]
						if ctrlj then
							--调整后续控件的坐标
							local posXj = ctrlj.data.x
							local posYj = ctrlj.data.y
							--理论相对距离
							local thisXj = posXj
							local thisYj = posYj - chatHeight_i
							ctrlj.handle._n:setPosition(thisXj, thisYj)
							ctrlj.data.x = thisXj
							ctrlj.data.y = thisYj
						end
					end
					
					--删除最后一个控件标记
					_frmNode.childUI["DLCMapInfoNode" .. current_DLCMap_max_num] = nil
					
					--删除 rightRemoveFrmList 存储标记
					for j = 1, #rightRemoveFrmList, 1 do
						if (rightRemoveFrmList[j] == ("DLCMapInfoNode" .. current_DLCMap_max_num)) then
							--print("删除 rightRemoveFrmList 存储标记", j, rightRemoveFrmList[j])
							table.remove(rightRemoveFrmList, j)
							break
						end
					end
					
					--标记总数量减1
					current_DLCMap_max_num = current_DLCMap_max_num - 1
					
					--删除此消息的内容缓存
					if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
						--删除世界消息的缓存
						table.remove(current_msg_id_list_world, i)
						current_chat_msg_hostory_cache_world[msgIdi] = nil
						--print("删除此世界消息的内容缓存", msgIdi)
					elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
						--删除邀请消息的缓存
						table.remove(current_msg_id_list_invite, i)
						current_chat_msg_hostory_cache_invite[msgIdi] = nil
						--print("删除此邀请消息的内容缓存", msgIdi)
					elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
						--删除私聊消息的内容缓存
						local friendUid = current_msg_private_friend_last_uid
						local tChatMsgFriendList = current_msgPrivate_msg_hostory_cache[friendUid]
						if tChatMsgFriendList then 
							--删除此条消息的内容缓存
							table.remove(current_msgPrivate_msg_id_list[friendUid], i)
							tChatMsgFriendList[msgIdi] = nil
							--print("删除此私聊消息的内容缓存", msgIdi, "friendUid=", friendUid)
						end
					elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
						--删除军团消息的缓存
						table.remove(current_msg_id_list_group, i)
						current_chat_msg_hostory_cache_group[msgIdi] = nil
						--print("删除此军团消息的内容缓存", msgIdi)
					elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
						--删除组队消息的缓存
						table.remove(current_msg_id_list_couple, i)
						current_chat_msg_hostory_cache_couple[msgIdi] = nil
						--print("删除此组队消息的内容缓存", msgIdi)
					end
					
					--删除可能的异步消息绘制列表
					for as = #current_async_paint_list, 1, -1 do
						local tMsg_i = current_async_paint_list[as]
						if (tMsg_i.id == msgIdi) then
							table.remove(current_async_paint_list, as)
							break
						end
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
					--需要滑动
					if (delta1_ly < 0) then --第一个控件跑到最顶部的下面
						in_scroll_down = true
					end
					
					--获得一个加速度，使右边自动往上滚动
					--超过一页的数量才滑屏
					--if (current_DLCMap_max_num > (WEAPON_X_NUM * WEAPON_Y_NUM)) then
					if in_scroll_down then
						--[[
						--向上滚屏
						b_need_auto_fixing_dlcmapinfo = true
						friction_dlcmapinfo = 0
						friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
						draggle_speed_y_dlcmapinfo = MAX_SPEED / 1.0 --正速度 --速度一般大
						]]
						
						--geyachao: 删除消息改为全部控件往下挪动
						--[[
						--向下滚屏
						--print("draggle_speed_y_dlcmapinfo=",draggle_speed_y_dlcmapinfo)
						b_need_auto_fixing_dlcmapinfo = true
						friction_dlcmapinfo = 0
						friction_dlcmapinfo_coefficient = 0 --无衰减系数(持续滑动)
						draggle_speed_y_dlcmapinfo = -MAX_SPEED / 1.0 --负速度 --速度一般大
						]]
						for j = 1, current_DLCMap_max_num, 1 do
							local ctrlj = _frmNode.childUI["DLCMapInfoNode" .. j]
							if ctrlj then
								--调整后续控件的坐标
								local posXj = ctrlj.data.x
								local posYj = ctrlj.data.y
								--理论相对距离
								local thisXj = posXj
								local thisYj = posYj - delta1_ly
								ctrlj.handle._n:setPosition(thisXj, thisYj)
								ctrlj.data.x = thisXj
								ctrlj.data.y = thisYj
							end
						end
					else
						--没触发自动滑动，需要提示新消息
						if (delta1_ly == 0) and (deltNa_ry >= 0) then
							--因为不足一页的不滑动，不需要提示
							onRemoveNewMessageHint()
						else
							--onCreateNewMessageHint()
						end
					end
					
					break
				end
			end
		end
		
		--更新叹号提示
		on_update_notice_tanhao()
	end
	
	--函数：收到被禁言的通知返回
	on_receive_chat_forbidden_event = function(version, debug_version, world_flag, msgWorldNum, strWorldTime, lastWorldMsgId, lastGroupMsgId, forbidden, strForbiddenTime, forbidden_minute, forbidden_op_uid, groupId, groupLevel, invite_group_list, msg_private_friend_chat_list, msg_private_friend_last_uid, send_redpacket_num, last_send_redpacket_time)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		--print("收到被禁言的通知返回", version, debug_version, world_flag, msgWorldNum, strWorldTime, lastWorldMsgId, lastGroupMsgId, forbidden, strForbiddenTime, forbidden_minute, forbidden_op_uid, groupId, groupLevel, invite_group_list, msg_private_friend_chat_list, msg_private_friend_last_uid, send_redpacket_num, last_send_redpacket_time)
		
		--存储数据
		current_msgWorldFlag = world_flag --世界聊天开关状态
		current_msgWorldNum = msgWorldNum --世界聊天今日次数
		current_msgWorldTime = strWorldTime --最近一次世界聊天时间(服务器时间)
		current_msgForbidden = forbidden --是否禁言
		current_msgForbiddenTime = strForbiddenTime --上次禁言时间(服务器时间)
		current_msgForbidden_minute = forbidden_minute --禁言时长（单位: 分钟）
		current_msgForbidden_op_uid = forbidden_op_uid --禁言的操作者uid
		current_msgGroupId = groupId --玩家所在的军团id
		current_msgGroupLevel = groupLevel --玩家所在的军团权限
		current_msgInvite_group_list = invite_group_list --军团邀请函id表
		current_msgPrivate_friend_chat_list = msg_private_friend_chat_list --私聊好友列表
		current_msg_private_friend_last_uid = msg_private_friend_last_uid -- 私聊最近一次好友的uid
		current_group_send_redpacket_num = send_redpacket_num --今日发送军团红包的次数
		current_last_group_send_redpacket_time = last_send_redpacket_time --最近依次发送军团红包的时间
		
		--移除超时检测timer
		--hApi.clearTimer("__ONCE_CHAT_TIMEOUNT_TIMER__")
		
		if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
			--更新今日可发送世界聊天的次数
			local leftChatMsgNum = -1 --今日剩余聊天次数
			local vip = LuaGetPlayerVipLv() or 0
			local chatWorldMsgNum = hVar.Vip_Conifg.chatWorldMsgNum[vip] or -1
			if (chatWorldMsgNum > 0) then --有次数限制
				leftChatMsgNum = chatWorldMsgNum - current_msgWorldNum
				if (leftChatMsgNum < 0) then
					leftChatMsgNum = 0
				end
			end
			if (leftChatMsgNum >= 0) then --有限制
				--世界聊天的按钮
				if _frmNode.childUI["btnSendMessageWorld"] then
					_frmNode.childUI["btnSendMessageWorld"].childUI["sendNoLimit"].handle._n:setVisible(false) --无限制
					
					_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"].handle._n:setVisible(true) --有限制
					_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"]:setText(hVar.tab_string["__TEXT_SEND"] .. " (" .. leftChatMsgNum .. ")") --"发送(??)"
					if (leftChatMsgNum > 0) then
						_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"].handle.s:setColor(ccc3(255, 255, 0))
					else
						_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"].handle.s:setColor(ccc3(212, 212, 212)) --灰掉
					end
				end
			else
				--世界聊天的按钮
				if _frmNode.childUI["btnSendMessageWorld"] then
					_frmNode.childUI["btnSendMessageWorld"].childUI["sendNoLimit"].handle._n:setVisible(true) --无限制
					_frmNode.childUI["btnSendMessageWorld"].childUI["sendLimit"].handle._n:setVisible(false) --有限制
				end
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
			--
		elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			--
		elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
			--
		elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
			--
		end
	end
	
	--函数：收到发起私聊请求的结果返回
	on_receive_chat_private_invite_event = function(result)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("函数：收到发起私聊请求的结果返回", result)
		
		--移除超时检测timer
		hApi.clearTimer("__ONCE_CHAT_TIMEOUNT_TIMER__")
		
		--取消挡操作
		--hUI.NetDisable(0)
		--隐藏菊花
		if _frmNode.childUI["waiting"] then
			_frmNode.childUI["waiting"]:setstate(-1) --已联网不显示菊花
		end
		
		--操作成功
		if (result == 1) then
			if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
				--跳转到私聊频道
				--OnClickPageBtn(3) ---修改聊天tab按钮顺序
				OnClickPageBtn(2)
			elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
				--跳转到私聊频道
				--OnClickPageBtn(3) --修改聊天tab按钮顺序
				OnClickPageBtn(2)
			elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
				--不处理
				--...
			elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
				--跳转到私聊频道
				--OnClickPageBtn(3) --修改聊天tab按钮顺序
				OnClickPageBtn(2)
			elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
				--跳转到私聊频道
				--OnClickPageBtn(3) --修改聊天tab按钮顺序
				OnClickPageBtn(2)
			end
		end
	end
	
	--函数：收到工会操作结果返回
	on_receive_group_result_event = function(flag)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--移除超时检测timer
		hApi.clearTimer("__ONCE_CHAT_TIMEOUNT_TIMER__")
		
		--取消挡操作
		--hUI.NetDisable(0)
		--隐藏菊花
		if _frmNode.childUI["waiting"] then
			_frmNode.childUI["waiting"]:setstate(-1) --已联网不显示菊花
		end
	end
	
	--函数：收到军团邀请函申请结果返回
	on_receive_group_invite_back_event = function(result, inviteGroupId, msgId, groupId, groupLevel)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--移除超时检测timer
		hApi.clearTimer("__ONCE_CHAT_TIMEOUNT_TIMER__")
		
		--取消挡操作
		--hUI.NetDisable(0)
		--隐藏菊花
		if _frmNode.childUI["waiting"] then
			_frmNode.childUI["waiting"]:setstate(-1) --已联网不显示菊花
		end
		
		--通过军团邀请函加入军团成功
		if (result == 1) then
			--本地标记已处理此军团邀请函消息
			LuaAddInviteGroupId(g_curPlayerName, msgId)
			
			--模拟触发删除消息
			on_receive_remove_chat_message_event(msgId)
			
			current_msgGroupId = groupId --玩家所在的军团id
			current_msgGroupLevel = groupLevel --玩家所在的军团权限
			
			--"加入军团成功"
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Guild_InviteGroupJoin_Success"],{
				font = hVar.FONTC,
				ok = function()
					--
				end,
			})
		end
	end
	
	--函数：程序进入后台事件返回
	on_app_enter_background_event = function(flag)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		if (flag == 1) then --进入后台
			--geyachao: 不知道为什么可能导致死机，这里不隐藏界面了
			--[[
			--关闭本界面
			_frm.childUI["closeBtn"].data.code()
			
			--清除聊天交互界面
			if hGlobal.UI.GameCoinTipFrame then
				hGlobal.UI.GameCoinTipFrame:del()
				hGlobal.UI.GameCoinTipFrame = nil
			end
			]]
			if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
				--
			elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
				--
			elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
				--
			elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
				--
			elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
				--
			end
		elseif (flag == 0) then --进入程序
			if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
				--
			elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
				--
			elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
				--
			elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
				--
			elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
				--
			end
		end
	end
	
	--函数：游戏局结束事件
	on_game_end_event = function()
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--关闭本聊天界面
		_frm.childUI["closeBtn"].data.code()
	end
	
	--函数：PVP等待其他玩家事件
	on_pvp_wait_player_event = function(num, delayPlayer)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--有其他玩家在等待
		if (num > 0) then
			--关闭本聊天界面
			_frm.childUI["closeBtn"].data.code()
		end
	end
	
	--函数：PVP本地长时间未响应事件
	on_pvp_local_noheart_event = function()
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--关闭本聊天界面
		_frm.childUI["closeBtn"].data.code()
	end
	
	--函数：安卓本地掉线事件
	on_android_local_disconnect_event = function(isShow)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--本地掉线
		if (isShow == 1) then
			--关闭本聊天界面
			_frm.childUI["closeBtn"].data.code()
		end
	end
	
	--函数：获得第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离
	getUpDownOffset = function()
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--第一个DLC地图面板的数据
		local DLCMapInfoBtn1 = _frmNode.childUI["DLCMapInfoNode1"]
		local btn1_cx, btn1_cy = 0, 0 --第一个DLC地图面板中心点位置
		local btn1_ly = 0 --第一个DLC地图面板最上侧的x坐标
		local delta1_ly = 0 --第一个DLC地图面板距离上侧边界的距离
		if DLCMapInfoBtn1 then
			btn1_cx, btn1_cy = DLCMapInfoBtn1.data.x, DLCMapInfoBtn1.data.y --第一个DLC地图面板中心点位置
			btn1_ly = btn1_cy + WEAPON_HEIGHT / 2 --第一个DLC地图面板最上侧的x坐标
			if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
				delta1_ly = btn1_ly + 49 -- iPhoneX_HEIGHT --第一个DLC地图面板距离上侧边界的距离
			elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
				delta1_ly = btn1_ly + 49 -- iPhoneX_HEIGHT --第一个DLC地图面板距离上侧边界的距离
			elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
				delta1_ly = btn1_ly + 49 + 170 -- iPhoneX_HEIGHT --第一个DLC地图面板距离上侧边界的距离
			elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
				delta1_ly = btn1_ly + 49 -- iPhoneX_HEIGHT --第一个DLC地图面板距离上侧边界的距离
			elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
				delta1_ly = btn1_ly + 49 -- iPhoneX_HEIGHT --第一个DLC地图面板距离上侧边界的距离
			end
		end
		
		--最后一个DLC地图面板的数据
		local DLCMapInfoBtnN = _frmNode.childUI["DLCMapInfoNode" .. current_DLCMap_max_num]
		local btnN_cx, btnN_cy = 0, 0 --最后一个DLC地图面板中心点位置
		local btnN_ry = 0 --最后一个DLC地图面板最下侧的x坐标
		local deltNa_ry = 0 --最后一个DLC地图面板距离下侧边界的距离
		if DLCMapInfoBtnN then
			btnN_cx, btnN_cy = DLCMapInfoBtnN.data.x, DLCMapInfoBtnN.data.y --最后一个DLC地图面板中心点位置
			btnN_ry = btnN_cy - DLCMapInfoBtnN.data.chatHeight - WEAPON_HEIGHT / 2 --最后一个DLC地图面板最下侧的x坐标
			if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
				deltNa_ry = btnN_ry + (hVar.SCREEN.h + 1) - 2 * iPhoneX_HEIGHT --最后一个DLC地图面板距离下侧边界的距离
			elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
				deltNa_ry = btnN_ry + (hVar.SCREEN.h + 1) + 54 - 2 * iPhoneX_HEIGHT --最后一个DLC地图面板距离下侧边界的距离
			elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
				deltNa_ry = btnN_ry + (hVar.SCREEN.h + 1) - 2 * iPhoneX_HEIGHT--最后一个DLC地图面板距离下侧边界的距离
			elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
				deltNa_ry = btnN_ry + (hVar.SCREEN.h + 1) - 2 * iPhoneX_HEIGHT --最后一个DLC地图面板距离下侧边界的距离
			elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
				deltNa_ry = btnN_ry + (hVar.SCREEN.h + 1) - 2 * iPhoneX_HEIGHT --最后一个DLC地图面板距离下侧边界的距离
			end
			--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
			--print("btn1_ly, btnN_ry", btn1_ly, btnN_ry)
		end
		
		return delta1_ly, deltNa_ry
	end
	
	--函数：创建新消息提示
	onCreateNewMessageHint = function()
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--不重复创建
		if _frmNode.childUI["btnNewMessageHint"] then
			return
		end
		
		--print("创建新消息提示")
		
		--提示父控件
		local pClipNode = nil
		local _BTC_PageClippingRect = nil
		if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界聊天频道
			pClipNode = _BTC_pClipNodeWorld
			_BTC_PageClippingRect = _BTC_PageClippingRectWorld
		elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请聊天频道
			pClipNode = _BTC_pClipNodeInvite
			_BTC_PageClippingRect = _BTC_PageClippingRectInvite
		elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			pClipNode = _BTC_pClipNodePrivate
			_BTC_PageClippingRect = _BTC_PageClippingRectPrivate
		elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
			pClipNode = _BTC_pClipNodeGroup
			_BTC_PageClippingRect = _BTC_PageClippingRectGroup
		elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
			pClipNode = _BTC_pClipNodeCouple
			_BTC_PageClippingRect = _BTC_PageClippingRectCouple
		end
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
			y = -2,
			size = 18,
			font = hVar.FONTC,
			align = "MC",
			width = 500,
			text = hVar.tab_string["__TEXT_HINT_NEW_MESSGAE"], --"收到新消息"
			border = 1,
			RGB = {255, 255, 0,},
		})
		
		--箭头图片
		_frmNode.childUI["btnNewMessageHint"].childUI["point"] = hUI.image:new({
			parent = _frmNode.childUI["btnNewMessageHint"].handle._n,
			x = 60,
			y = 2,
			model = "misc/chest/tutorial_arrow_right.png", --"UI:PageBtn",
			scale = 0.56,
		})
		_frmNode.childUI["btnNewMessageHint"].childUI["point"].handle.s:setRotation(90)
		_frmNode.childUI["btnNewMessageHint"].childUI["point"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["btnNewMessageHint"].childUI["point"].handle._n:runAction(forever)
	end
	
	--函数：删除新消息提示
	onRemoveNewMessageHint = function()
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("删除新消息提示")
		
		--拉到最底部，标记已经阅读的最后一条消息id
		if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
			--设置世界聊天的已阅读的消息id
			if (#current_msg_id_list_world > 0) then
				if (current_msg_id_list_world[#current_msg_id_list_world] >= 0) then
					LuaSetChatWorldReadMsgId(g_curPlayerName, current_msg_id_list_world[#current_msg_id_list_world])
				else --负数表示聊天忠告
					if (#current_msg_id_list_world > 1) then
						--最后一个非负数的聊天消息id
						local readMsgId = -1
						for j = #current_msg_id_list_world, 1, -1 do
							local msgId_j = current_msg_id_list_world[j]
							--print("msgId_j=", msgId_j)
							if (msgId_j > 0) then
								readMsgId = msgId_j
								break
							end
						end
						LuaSetChatWorldReadMsgId(g_curPlayerName, readMsgId)
					else
						--没有消息。。。
						LuaSetChatWorldReadMsgId(g_curPlayerName, -1)
					end
				end
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
			--设置邀请聊天的已阅读的消息id
			if (#current_msg_id_list_invite > 0) then
				--LuaSetChatCoupleReadMsgId(g_curPlayerName, current_msg_id_list_invite[#current_msg_id_list_invite])
			end
			
			--geyachao:删除新消息提示，标记全部组队消息为已读，并立即更新叹号
			--设置组队副本消息已读的消息id
			if (#current_msg_id_list_invite > 0) then
				local notSaveFlag = true
				LuaRemoveBattleInviteMsgAll(g_curPlayerName, notSaveFlag)
				
				for t = 1, #current_msg_id_list_invite, 1 do
					local msgId = current_msg_id_list_invite[t]
					LuaSetBattleInviteMsgIdRead(g_curPlayerName, msgId, notSaveFlag)
				end
				
				--存档
				LuaSavePlayerList()
			else
				--移除组队副本邀请全部未查看的消息id
				LuaRemoveBattleInviteMsgAll(g_curPlayerName)
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			--设置私聊的已阅读消息id
			local touid = current_msg_private_friend_last_uid
			local list = current_msgPrivate_msg_id_list
			if list[touid] then
				if (#list[touid] > 0) then
					LuaSetChatPrivateFriendReadMsgId(g_curPlayerName, touid, list[touid][#list[touid]])
				end
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
			--设置军团聊天的已阅读的消息id
			if (#current_msg_id_list_group > 0) then
				LuaSetChatGroupReadMsgId(g_curPlayerName, current_msg_id_list_group[#current_msg_id_list_group])
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
			--设置组队聊天的已阅读的消息id
			if (#current_msg_id_list_couple > 0) then
				LuaSetChatCoupleReadMsgId(g_curPlayerName, current_msg_id_list_couple[#current_msg_id_list_couple])
			end
		end
		
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
		on_update_notice_tanhao()
	end
	
	--函数：显示滚动条提示
	onShowScrollBarHint = function()
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--滚动条淡入
		local act1 = CCDelayTime:create(0.01)
		local act2 = CCCallFunc:create(function()
			_frmNode.childUI["ScrollBar"]:setstate(1)
		end)
		local act3 = CCEaseSineOut:create(CCFadeTo:create(1.0, 255))
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		local sequence = CCSequence:create(a)
		_frmNode.childUI["ScrollBar"].handle.s:stopAllActions()
		_frmNode.childUI["ScrollBar"].handle.s:runAction(sequence)
		
		--滚动条进度淡入
		local act4 = CCDelayTime:create(0.01 + 0.1)
		local act5 = CCCallFunc:create(function()
			_frmNode.childUI["ScrollBarProgress"]:setstate(1)
		end)
		local act6 = CCEaseSineOut:create(CCFadeTo:create(0.9, 255))
		local a = CCArray:create()
		a:addObject(act4)
		a:addObject(act5)
		a:addObject(act6)
		local sequence = CCSequence:create(a)
		_frmNode.childUI["ScrollBarProgress"].handle.s:stopAllActions()
		_frmNode.childUI["ScrollBarProgress"].handle.s:runAction(sequence)
	end
	
	--函数：隐藏滚动条提示
	onHideScrollBarHint = function()
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--滚动条淡出
		local act1 = CCDelayTime:create(0.2)
		local act2 = CCEaseSineIn:create(CCFadeTo:create(1.0, 0))
		local act3 = CCCallFunc:create(function()
			_frmNode.childUI["ScrollBar"]:setstate(-1)
		end)
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		a:addObject(act3)
		local sequence = CCSequence:create(a)
		_frmNode.childUI["ScrollBar"].handle.s:stopAllActions()
		_frmNode.childUI["ScrollBar"].handle.s:runAction(sequence)
		
		--滚动条进度淡出
		local act4 = CCDelayTime:create(0.2)
		local act5 = CCEaseSineIn:create(CCFadeTo:create(0.9, 0))
		local act6 = CCDelayTime:create(0.1)
		local act7 = CCCallFunc:create(function()
			_frmNode.childUI["ScrollBarProgress"]:setstate(-1)
		end)
		local a = CCArray:create()
		a:addObject(act4)
		a:addObject(act5)
		a:addObject(act6)
		a:addObject(act7)
		local sequence = CCSequence:create(a)
		_frmNode.childUI["ScrollBarProgress"].handle.s:stopAllActions()
		_frmNode.childUI["ScrollBarProgress"].handle.s:runAction(sequence)
	end
	
	--函数：创建消息互动操作界面tip
	OnCreateChatDialogueTip = function(index)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--删除上一次的界面
		if hGlobal.UI.GameCoinTipFrame then
			hGlobal.UI.GameCoinTipFrame:del()
			hGlobal.UI.GameCoinTipFrame = nil
		end
		
		--找到此聊天控件的头像坐标
		local frameW = 220
		local frameH = 320
		local frameX = BOARD_POS_X + BOARD_WIDTH / 2 - frameW / 2
		local frameY = BOARD_POS_Y - BOARD_HEIGHT / 2 + frameH / 2
		local ctrli = _frmNode.childUI["DLCMapInfoNode" .. index]
		
		--不存在控件，直接返回
		if (ctrli == nil) then
			return
		end
		
		local msgId = ctrli.data.msgId
		local tMsg = nil
		if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
			tMsg = current_chat_msg_hostory_cache_world[msgId]
		elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
			tMsg = current_chat_msg_hostory_cache_invite[msgId]
		elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			local friendUid = current_msg_private_friend_last_uid
			tMsg = current_msgPrivate_msg_hostory_cache[friendUid][msgId]
		elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
			tMsg = current_chat_msg_hostory_cache_group[msgId]
		elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
			tMsg = current_chat_msg_hostory_cache_couple[msgId]
		end
		--print(msgId, tMsg)
		
		--不存在消息，直接返回
		if (tMsg == nil) then
			return
		end
		
		local msgId = tMsg.id --消息id
		local chatType = tMsg.chatType --聊天频道
		local msgType = tMsg.msgType --消息类型
		local uid = tMsg.uid --消息发送者uid
		local name = tMsg.name --玩家名
		local channelId = tMsg.channelId --渠道号
		local vip = tMsg.vip --vip等级
		local borderId = tMsg.borderId --边框id
		local iconId = tMsg.iconId --头像id
		local championId = tMsg.championId --称号id
		local leaderId = tMsg.leaderId --会长权限
		local dragonId = tMsg.dragonId --聊天龙王id
		local headId = tMsg.headId --头衔id
		local lineId = tMsg.lineId --线索id
		local date = tMsg.date --日期
		local content = tMsg.content --聊天内容
		local touid = tMsg.touid --接收者uid
		local result = tMsg.result --可交互类型消息的操作结果
		local resultParam = tMsg.resultParam --可交互类型消息的参数
		local redPacketParam = tMsg.redPacketParam --红包消息参数
		
		local cx = ctrli.data.x --中心点x坐标
		local cy = ctrli.data.y --中心点y坐标
		local ctrlI = ctrli.childUI["roleIcon"]
		if ctrlI then
			local bcx = ctrlI.data.x --中心点x坐标
			local bcy = ctrlI.data.y --中心点y坐标
			local bcw, bch = ctrlI.data.w, ctrlI.data.h
			local blx, bly = cx + bcx - bcw / 2, cy  + bcy - bch / 2 --最左上侧坐标
			local brx, bry = blx + bcw, bly + bch --最右下角坐标
			frameX = blx + 55 + iPhoneX_WIDTH --- bcw / 2 + 20 --blx + bcw + 20 --edit by mj 2022.11.17
			frameY = hVar.SCREEN.h + bly + bch
			--print(frameX,frameY)
			if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL) then
				if ((frameY - frameH) < 80 + iPhoneX_HEIGHT) then --距离最底部间距至少80像素
					frameY = frameH + 80 + iPhoneX_HEIGHT
				end

				if ((hVar.SCREEN.h - frameY) < 80 + iPhoneX_HEIGHT) then --距离最底部间距至少80像素
					frameY = hVar.SCREEN.h - 80 - iPhoneX_HEIGHT
				end
			else
				if ((frameY - frameH) < 80) then --距离最底部间距至少80像素
					frameY = frameH + 80
				end
			end

			if (uid == xlPlayer_GetUID()) then --我发送的消息
				if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
					frameX = brx- frameW - 55 + iPhoneX_WIDTH -- - frameW / 2 - 82 --frameX - frameW - 40 - 48 --edit by mj 2022.11.17
				end
			end
		end
		
		--创建息互动操作界面tip
		hGlobal.UI.GameCoinTipFrame = hUI.frame:new({
			x = frameX + frameW / 2,
			y = frameY - frameH / 2,
			w = frameW,
			h = frameH,
			z = hZorder.CommonUIFrame + 2,
			show = 1,
			--dragable = 2,
			dragable = 2,
			--buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			--border = "UI:TileFrmBasic_thin",
			--background = "ui/TacticBG.png",
			border = 0,
			background = -1,
			
			--点击事件（有可能在控件外部点击）
			codeOnDragEx = function(touchX, touchY, touchMode)
				--print("codeOnDragEx", touchX, touchY, touchMode)
				if (touchMode == 0) then --按下
					--
				elseif (touchMode == 1) then --滑动
					--
				elseif (touchMode == 2) then --抬起
					--在本界面之外点击，清除本界面
					if hGlobal.UI.GameCoinTipFrame then
						local cx = hGlobal.UI.GameCoinTipFrame.data.x --中心点x坐标
						local cy = hGlobal.UI.GameCoinTipFrame.data.y --中心点y坐标
						local cw, ch = hGlobal.UI.GameCoinTipFrame.data.w, hGlobal.UI.GameCoinTipFrame.data.h
						local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
						local rx, ry = lx + cw, ly + ch --最右下角坐标
						--print(lx, rx)
						--print(rx, ry)
						--检测是否点到了本面板之内
						if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
							--
						else
							--清除技能说明面板
							hGlobal.UI.GameCoinTipFrame:del()
							hGlobal.UI.GameCoinTipFrame = nil
						end
					end
					--print("点击事件（有可能在控件外部点击）")
				end
			end,
		})
		hGlobal.UI.GameCoinTipFrame:active()
		
		local _TacticTipParent = hGlobal.UI.GameCoinTipFrame.handle._n
		local _TacticTipChildUI = hGlobal.UI.GameCoinTipFrame.childUI
		
		local _offX = 0 --
		local _offY = 0 ---frameH / 2
		
		local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", _offX, _offY, frameW, frameH, hGlobal.UI.GameCoinTipFrame)
		img9:setOpacity(212)
		
		--创建玩家头像
		--头像图标
		local tRoleIcon = hVar.tab_roleicon[iconId]
		if (tRoleIcon == nil) then
			tRoleIcon = hVar.tab_roleicon[0]
		end
		local iconW = tRoleIcon.width
		local iconH = tRoleIcon.height
		local width = 48 * iconW / iconH
		local height = 48
		local posx = 0
		local posy = 0
		if (height > width) then
			posy = -(height - width) / 2
		end
		_TacticTipChildUI["RoleIcon"] = hUI.image:new({
			parent = _TacticTipParent,
			model = tRoleIcon.icon,
			x = _offX - 70 + posx,
			y = _offY + 115 + posy,
			w = width,
			h = height,
		})
		
		--创建玩家名
		_TacticTipChildUI["RoleName"] = hUI.label:new({
			parent = _TacticTipParent,
			model = tRoleIcon.icon,
			x = _offX - 70 + posx + 94,
			y = _offY + 115 + posy - 2,
			font = hVar.FONTC,
			align = "MC",
			size = 18,
			text = name,
			border = 1,
			width = 500,
			RGB = {255, 255, 212,},
		})
		
		--创建VIP等级
		if (vip > 0) then
			_TacticTipChildUI["RoleVIP"] = hUI.label:new({
				parent = _TacticTipParent,
				model = tRoleIcon.icon,
				x = _offX - 70 + posx,
				y = _offY + 115 + posy - 24,
				font = hVar.FONTC,
				align = "MT",
				size = 16,
				text = "VIP " .. vip,
				border = 1,
				width = 500,
				RGB = {255, 255, 0,},
			})
		end
		if (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM) then --系统文本消息
			_TacticTipChildUI["RoleVIP"].handle.s:setColor(ccc3(255, 168, 128))
		end
		
		--创建私聊按钮
		local btnY = 16
		--管理员有多个按钮，第一个按钮位置上移
		--if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
		if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
			btnY = 36
		end
		_TacticTipChildUI["btnPrivateMsg"] = hUI.button:new({
			parent = _TacticTipParent,
			model = "misc/chest/chatsend.png", --"UI:PANEL_MENU_BTN_BIG", --"UI:SkillSlot",
			x = _offX,
			y = _offY + btnY + posy - 76 * 0,
			label = {text = hVar.tab_string["__TEXT_MAINUI_BTN_PRIVATECHAT"], size = 28, font = hVar.FONTC, border = 1, x = 0, y = 1.5, RGB = {255, 255, 0,},}, --"私聊"
			dragbox = hGlobal.UI.GameCoinTipFrame.childUI["dragBox"],
			w = 120,
			h = 56,
			scaleT = 0.95,
			code = function()
				--关闭本页面
				if hGlobal.UI.GameCoinTipFrame then
					hGlobal.UI.GameCoinTipFrame:del()
					hGlobal.UI.GameCoinTipFrame = nil
				end
				
				--添加查询超时一次性timer
				hApi.addTimerOnce("__ONCE_CHAT_TIMEOUNT_TIMER__", 5000, refresh_chatnet_timeout_timer)
				
				--请求和此好友私聊
				SendGroupCmdFunc["chat_private_invite"](tMsg)
			end,
		})
		
		--管理员能查看玩家的id
		--if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
		if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
			--账号文本
			_TacticTipChildUI["RoleName"]:setText(name .. "\n" .. "(" .. uid .. ")" .. "\n" .. "[" .. channelId .. "]")
		end
		
		--管理员有个删除消息的按钮
		--if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
		if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
			--删除消息按钮
			_TacticTipChildUI["btnDeleteMsg"] = hUI.button:new({
				parent = _TacticTipParent,
				model = "misc/chest/chatsend.png", --"UI:PANEL_MENU_BTN_BIG", --"UI:SkillSlot",
				x = _offX,
				y = _offY + btnY + posy - 76 * 1,
				label = {text = hVar.tab_string["__TEXT_Delete"], size = 28, font = hVar.FONTC, border = 1, x = 0, y = 1.5, RGB = {255, 212, 0,},}, --"删除"
				dragbox = hGlobal.UI.GameCoinTipFrame.childUI["dragBox"],
				w = 120,
				h = 56,
				scaleT = 0.95,
				code = function()
					--关闭本页面
					if hGlobal.UI.GameCoinTipFrame then
						hGlobal.UI.GameCoinTipFrame:del()
						hGlobal.UI.GameCoinTipFrame = nil
					end
					
					--弹出对话框确认
					local MsgSelections = nil
					MsgSelections = {
						style = "mini",
						select = 0,
						ok = function()
							--发送指令，删除消息
							SendGroupCmdFunc["chat_remove_message"](msgId)
						end,
						cancel = function()
							--
						end,
						--cancelFun = cancelCallback, --点否的回调函数
						textOk = hVar.tab_string["__TEXT_Delete"], --"删除"
						textCancel = hVar.tab_string["__TEXT_Cancel"], --"取消"
						userflag = 0, --用户的标记
					}
					local showTitle = string.format(hVar.tab_string["__TEXT_IsChatDeleteMessage"], tostring(content)) --"是否删除消息 \"" .. content .. "\" ？"
					local msgBox = hGlobal.UI.MsgBox(showTitle, MsgSelections)
					msgBox:active()
					msgBox:show(1,"fade",{time=0.08})
				end,
			})
			--管理员标识星星1
			_TacticTipChildUI["btnDeleteMsg"].childUI["star1"] = hUI.image:new({
				parent = _TacticTipChildUI["btnDeleteMsg"].handle._n,
				x = -74,
				y = 0,
				model = "misc/weekstar.png",
				w = 24,
				h = 24,
			})
			--管理员标识星星2
			_TacticTipChildUI["btnDeleteMsg"].childUI["star2"] = hUI.image:new({
				parent = _TacticTipChildUI["btnDeleteMsg"].handle._n,
				x = -94,
				y = 0,
				model = "misc/weekstar.png",
				w = 24,
				h = 24,
			})
		end
		
		--管理员有个禁言的按钮
		--if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员
		if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
			--删除消息按钮
			_TacticTipChildUI["btnJinYanMsg"] = hUI.button:new({
				parent = _TacticTipParent,
				model = "misc/chest/chatsend.png", --"UI:PANEL_MENU_BTN_BIG", --"UI:SkillSlot",
				x = _offX,
				y = _offY + btnY + posy - 76 * 2,
				label = {text = hVar.tab_string["__TEXT_ChatBan"], size = 28, font = hVar.FONTC, border = 1, x = 0, y = 1.5, RGB = {255, 212, 0,},}, --"禁言"
				dragbox = hGlobal.UI.GameCoinTipFrame.childUI["dragBox"],
				w = 120,
				h = 56,
				scaleT = 0.95,
				code = function()
					--关闭本页面
					if hGlobal.UI.GameCoinTipFrame then
						hGlobal.UI.GameCoinTipFrame:del()
						hGlobal.UI.GameCoinTipFrame = nil
					end
					
					--弹出对话框确认
					local MsgSelections = nil
					MsgSelections = {
						style = "mini",
						select = 0,
						ok = function()
							--发送指令，删除消息
							SendGroupCmdFunc["chat_forbidden_user"](uid, MsgSelections.userflag)
						end,
						cancel = function()
							--
						end,
						--cancelFun = cancelCallback, --点否的回调函数
						textOk = hVar.tab_string["__TEXT_ChatBan"], --"禁言"
						textCancel = hVar.tab_string["__TEXT_Cancel"], --"取消"
						userflag = 0, --用户的标记（禁言时间: 默认0分钟）
					}
					local showTitle = string.format(hVar.tab_string["__TEXT_IsChatBanPlayer"], tostring(name)) --"是否禁言玩家 \"" .. name .. "\" ？"
					local msgBox = hGlobal.UI.MsgBox(showTitle, MsgSelections)
					msgBox:active()
					msgBox:show(1,"fade",{time=0.08})
					
					local _frm = msgBox
					local _parent = _frm.handle._n
					local _childUI = _frm.childUI
					local _scoreLabX = 16
					local _scoreLabY = -166
					
					--文字
					_childUI["text"] = hUI.label:new({
						parent = _parent,
						size = 24,
						align = "MC",
						font = hVar.FONTC,
						x = _scoreLabX + 70,
						y = _scoreLabY,
						width = 300,
						border = 1,
						text = MsgSelections.userflag .. hVar.tab_string["__Minute"], --"分"
					})
					
					--加1分钟按钮
					_childUI["language_sc_btn_day"] = hUI.button:new({
						parent = _frm,
						model = "UI:addone",
						dragbox = _childUI["dragBox"],
						label = {x = 0, y = 30, text = hVar.tab_string["__Minute"], size = 18, font = hVar.FONTC, border = 1, RGB = {0, 255, 0,},}, --"分"
						x = _scoreLabX + 170,
						y = _scoreLabY,
						w = 42,
						h = 40,
						scaleT = 0.95,
						code = function(self)
							MsgSelections.userflag = MsgSelections.userflag + 1 --1分钟
							
							local day = math.floor(MsgSelections.userflag / 1440)
							local hour = math.floor((MsgSelections.userflag - day * 1440) / 60)
							local minute = MsgSelections.userflag - day * 1440 - hour * 60
							local strText = ""
							if (day > 0) then
								strText = strText .. day .. hVar.tab_string["__TEXT_Dat"] --"天"
							end
							if (hour > 0) then
								strText = strText .. hour .. hVar.tab_string["__TEXT_Hour_Short"] --"时"
							end
							if (minute > 0) then
								strText = strText .. minute .. hVar.tab_string["__Minute"] --"分"
							end
							_childUI["text"]:setText(strText)
						end,
					})
					
					--加1小时按钮
					_childUI["language_sc_btn_hour"] = hUI.button:new({
						parent = _frm,
						model = "UI:addone",
						dragbox = _childUI["dragBox"],
						label = {x = 0, y = 30, text = hVar.tab_string["__TEXT_Hour_Short"], size = 18, font = hVar.FONTC, border = 1, RGB = {0, 255, 0,},}, --"时"
						x = _scoreLabX + 240,
						y = _scoreLabY,
						w = 42,
						h = 40,
						scaleT = 0.95,
						code = function(self)
							MsgSelections.userflag = MsgSelections.userflag + 60 --1小时
							
							local day = math.floor(MsgSelections.userflag / 1440)
							local hour = math.floor((MsgSelections.userflag - day * 1440) / 60)
							local minute = MsgSelections.userflag - day * 1440 - hour * 60
							local strText = ""
							if (day > 0) then
								strText = strText .. day .. hVar.tab_string["__TEXT_Dat"] --"天"
							end
							if (hour > 0) then
								strText = strText .. hour .. hVar.tab_string["__TEXT_Hour_Short"] --"时"
							end
							if (minute > 0) then
								strText = strText .. minute .. hVar.tab_string["__Minute"] --"分"
							end
							_childUI["text"]:setText(strText)
						end,
					})
					
					--加1天按钮
					_childUI["language_sc_btn_day"] = hUI.button:new({
						parent = _frm,
						model = "UI:addone",
						dragbox = _childUI["dragBox"],
						x = _scoreLabX + 310,
						label = {x = 0, y = 30, text = hVar.tab_string["__TEXT_Dat"], size = 18, font = hVar.FONTC, border = 1, RGB = {0, 255, 0,},}, --"天"
						y = _scoreLabY,
						w = 42,
						h = 40,
						scaleT = 0.95,
						code = function(self)
							MsgSelections.userflag = MsgSelections.userflag + 1440 --1天
							
							local day = math.floor(MsgSelections.userflag / 1440)
							local hour = math.floor((MsgSelections.userflag - day * 1440) / 60)
							local minute = MsgSelections.userflag - day * 1440 - hour * 60
							local strText = ""
							if (day > 0) then
								strText = strText .. day .. hVar.tab_string["__TEXT_Dat"] --"天"
							end
							if (hour > 0) then
								strText = strText .. hour .. hVar.tab_string["__TEXT_Hour_Short"] --"时"
							end
							if (minute > 0) then
								strText = strText .. minute .. hVar.tab_string["__Minute"] --"分"
							end
							_childUI["text"]:setText(strText)
						end,
					})
					
					--加1年按钮
					_childUI["language_sc_btn_year"] = hUI.button:new({
						parent = _frm,
						model = "UI:addone",
						dragbox = _childUI["dragBox"],
						x = _scoreLabX + 380,
						label = {x = 0, y = 30, text = hVar.tab_string["_TEXT_YEAR_"], size = 18, font = hVar.FONTC, border = 1, RGB = {0, 255, 0,},}, --"年"
						y = _scoreLabY,
						w = 42,
						h = 40,
						scaleT = 0.95,
						code = function(self)
							MsgSelections.userflag = MsgSelections.userflag + 1440*365 --1年
							
							local day = math.floor(MsgSelections.userflag / 1440)
							local hour = math.floor((MsgSelections.userflag - day * 1440) / 60)
							local minute = MsgSelections.userflag - day * 1440 - hour * 60
							local strText = ""
							if (day > 0) then
								strText = strText .. day .. hVar.tab_string["__TEXT_Dat"] --"天"
							end
							if (hour > 0) then
								strText = strText .. hour .. hVar.tab_string["__TEXT_Hour_Short"] --"时"
							end
							if (minute > 0) then
								strText = strText .. minute .. hVar.tab_string["__Minute"] --"分"
							end
							_childUI["text"]:setText(strText)
						end,
					})
					--[[
					--减按钮
					_childUI["language_sc_btn"] = hUI.button:new({
						parent = _frm,
						model = "UI:subone",
						dragbox = _childUI["dragBox"],
						x = _scoreLabX - 90,
						y = _scoreLabY,
						w = 42,
						h = 40,
						scaleT = 0.95,
						code = function(self)
							MsgSelections.userflag = math.max(MsgSelections.userflag - 10, 0)
							_childUI["text"]:setText(MsgSelections.userflag .. "分钟")
						end,
					})
					]]
				end,
			})
			--管理员标识星星1
			_TacticTipChildUI["btnJinYanMsg"].childUI["star1"] = hUI.image:new({
				parent = _TacticTipChildUI["btnJinYanMsg"].handle._n,
				x = -74,
				y = 0,
				model = "misc/weekstar.png",
				w = 24,
				h = 24,
			})
			--管理员标识星星2
			_TacticTipChildUI["btnJinYanMsg"].childUI["star2"] = hUI.image:new({
				parent = _TacticTipChildUI["btnJinYanMsg"].handle._n,
				x = -94,
				y = 0,
				model = "misc/weekstar.png",
				w = 24,
				h = 24,
			})
		end
	end
	
	--函数：更新叹号提示
	on_update_notice_tanhao = function()
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("更新叹号提示", os.time())
		
		--检查世界频道是否有未阅读的消息
		local bNoticeWorld = false
		local receive_msgid = LuaGetChatWorldReceiveMsgId(g_curPlayerName)
		local read_msgid = LuaGetChatWorldReadMsgId(g_curPlayerName)
		--print(receive_msgid, read_msgid)
		if (receive_msgid > read_msgid) then
			bNoticeWorld = true
		end
		
		--检查邀请频道是否有未阅读的消息
		local bNoticeInvite = false
		local receive_msgid = LuaGetChatInviteReceiveMsgId(g_curPlayerName)
		if (receive_msgid > 0) then
			--邀请频道，只有有一条消息未处理，都需要叹号
			bNoticeInvite = true
			
			local read_msgid_list = LuaGetInviteGroupIdList(g_curPlayerName)
			--print(receive_msgid, read_msgid_list)
			for r = 1, #read_msgid_list, 1 do
				if (read_msgid_list[r] == receive_msgid) then
					bNoticeInvite = false
				end
			end
		end
		
		--检查组队副本邀请消息是否有未阅读的
		local bNoticeInviteBattle = false
		local battle = LuaGetBattleInviteMsgIdList(g_curPlayerName)
		if battle then
			for t = 1, #battle, 1 do
				local msgId = battle[t]
				--正消息是未读的
				if (msgId > 0) then
					bNoticeInviteBattle = true
				end
			end
		end
		
		--检查私聊频道是否有未阅读的消息
		local bNoticePrivate = false
		local tPrivate = LuaGetChatPrivateFriendList(g_curPlayerName)
		if tPrivate then
			for touid, tt in pairs(tPrivate) do
				local receive_msgid = tt.receive_msgid or 0
				local read_msgid = tt.read_msgid or 0
				if (receive_msgid > read_msgid) then
					bNoticePrivate = true
				end
			end
		end
		
		--检查军团频道是否有未阅读的消息
		local bNoticeGroup = false
		local receive_msgid = LuaGetChatGroupReceiveMsgId(g_curPlayerName)
		local read_msgid = LuaGetChatGroupReadMsgId(g_curPlayerName)
		if (receive_msgid > read_msgid) then
			bNoticeGroup = true
		end
		
		--检查组队频道是否有未阅读的消息
		local bNoticeCouple = false
		local receive_msgid = LuaGetChatCoupleReceiveMsgId(g_curPlayerName)
		local read_msgid = LuaGetChatCoupleReadMsgId(g_curPlayerName)
		if (receive_msgid > read_msgid) then
			bNoticeCouple = true
		end
		
		--频道分页按钮的叹号提示
		_frm.childUI["PageBtn1"].childUI["NoteJianTou"].handle._n:setVisible(bNoticeWorld)
		--_frm.childUI["PageBtn2"].childUI["NoteJianTou"].handle._n:setVisible(bNoticeInvite or bNoticeInviteBattle)
		--_frm.childUI["PageBtn3"].childUI["NoteJianTou"].handle._n:setVisible(bNoticePrivate)
		_frm.childUI["PageBtn3"].childUI["NoteJianTou"].handle._n:setVisible(bNoticeInvite or bNoticeInviteBattle)
		_frm.childUI["PageBtn2"].childUI["NoteJianTou"].handle._n:setVisible(bNoticePrivate)
		_frm.childUI["PageBtn4"].childUI["NoteJianTou"].handle._n:setVisible(bNoticeGroup)
		if _frm.childUI["PageBtn5"] then
			_frm.childUI["PageBtn5"].childUI["NoteJianTou"].handle._n:setVisible(bNoticeCouple)
		end
		
		if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
			--
		elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
			--
		elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			--检测每个私聊好友头像，是否有新消息提示
			for i = 1, current_DLCMap_friend_max_num, 1 do
				local ctrl_i = _frmNode.childUI["DLCMapInfoNodeFriend" .. i]
				if ctrl_i then
					local bNoticePrivateFriend = false --私聊朋友是否需要提示叹号
					local touid = ctrl_i.data.touid
					local read_msgid = LuaGetChatPrivateFriendReadMsgId(g_curPlayerName, touid) or 0
					local receive_msgid = LuaGetChatPrivateFriendReceiveMsgId(g_curPlayerName, touid) or 0
					if (receive_msgid > read_msgid) then
						bNoticePrivateFriend = true
					end
					--print(touid, read_msgid, receive_msgid, bNoticePrivateFriend)
					_frmNode.childUI["DLCMapInfoNodeFriend" .. i].childUI["NoteJianTou"].handle._n:setVisible(bNoticePrivateFriend)
				end
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
			--
		elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
			--
		end

		hGlobal.event:event("LocalEvent_RefreshMedalStateUI")
	end
	
	--函数：创建单条聊天信息
	--bBottom: 是否对齐到底部
	on_create_single_message_UI = function(tMsg, index, bBottom)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local msgId = tMsg.id --消息id
		local chatType = tMsg.chatType --聊天频道
		local msgType = tMsg.msgType --消息类型
		local uid = tMsg.uid --消息发送者uid
		local name = tMsg.name --玩家名
		local channelId = tMsg.channelId --渠道号
		local vip = tMsg.vip --vip等级
		local borderId = tMsg.borderId --边框id
		local iconId = tMsg.iconId --头像id
		local championId = tMsg.championId --称号id
		local leaderId = tMsg.leaderId --会长权限
		local dragonId = tMsg.dragonId --聊天龙王id
		local headId = tMsg.headId --头衔id
		local lineId = tMsg.lineId --线索id
		local date = tMsg.date --日期
		local content = tMsg.content --聊天内容
		local touid = tMsg.touid --接收者uid
		local result = tMsg.result --可交互类型消息的操作结果
		local resultParam = tMsg.resultParam --可交互类型消息的参数
		local redPacketParam = tMsg.redPacketParam --红包消息参数
		
		--!!!! edit by mj 临时去掉会长权限/称号
		leaderId = 0
		championId = 0

		--[[
		--测试 --test
		content = "[" .. msgId .. "] " .. content
		]]
		
		--消息父控件
		local pClipNode = nil
		if (chatType == hVar.CHAT_TYPE.WORLD) then --世界聊天频道
			pClipNode = _BTC_pClipNodeWorld
		elseif (chatType == hVar.CHAT_TYPE.INVITE) then --邀请频道
			pClipNode = _BTC_pClipNodeInvite
		elseif (chatType == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			pClipNode = _BTC_pClipNodePrivate
		elseif (chatType == hVar.CHAT_TYPE.GROUP) then --军团频道
			pClipNode = _BTC_pClipNodeGroup
		elseif (chatType == hVar.CHAT_TYPE.COUPLE) then --组队频道
			pClipNode = _BTC_pClipNodeCouple
		end
		local nodePosY = 0
		if (chatType == hVar.CHAT_TYPE.WORLD) then --世界聊天频道
			nodePosY = -94
		elseif (chatType == hVar.CHAT_TYPE.INVITE) then --邀请频道
			nodePosY = -94 - 54
		elseif (chatType == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			nodePosY = -264
		elseif (chatType == hVar.CHAT_TYPE.GROUP) then --军团频道
			nodePosY = -94
		elseif (chatType == hVar.CHAT_TYPE.COUPLE) then --组队频道
			nodePosY = -94
		end
		_frmNode.childUI["DLCMapInfoNode" .. index] = hUI.button:new({
			--parent = _BTC_pClipNodeWorld,
			parent = pClipNode,
			--model = "misc/mask.png",
			model = -1,
			x = 46,
			y = nodePosY - (index - 1) * WEAPON_HEIGHT, --nodePosY - iPhoneX_HEIGHT - (index - 1) * WEAPON_HEIGHT,
			--z = 1,
			w = 48,
			h = 48,
		})
		--_frmNode.childUI["DLCMapInfoNode" .. index].handle.s:setOpacity(0) --默认不显示（只用于响应事件，不显示）
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoNode" .. index
		_frmNode.childUI["DLCMapInfoNode" .. index].data.msgId = msgId --存储控件的msgId
		_frmNode.childUI["DLCMapInfoNode" .. index].data.uid = uid --存储控件的uid
		
		--头像图标
		local tRoleIcon = hVar.tab_roleicon[iconId]
		if (tRoleIcon == nil) then
			tRoleIcon = hVar.tab_roleicon[0]
		end

		local iconW = tRoleIcon.width
		local iconH = tRoleIcon.height
		local width = 48 * iconW / iconH
		local height = 48
		local posx = 0
		local posy = 0
		if (height > width) then
			posy = -(height - width) / 2
		end
		--print(posy)
		_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"] = hUI.image:new({
			parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			model = tRoleIcon.icon,
			x = posx - 4,
			y = posy,
			w = width,
			h = height,
		})
		if (uid == xlPlayer_GetUID()) then --我发送的消息
			if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
				local nx = BOARD_WIDTH - 40 - 48
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"]:setXY(nx, posy)
			end
		end
		
		--[[
		--边框图标
		local tRoleBorder = hVar.tab_roleborder[borderId]
		if (tRoleBorder == nil) then
			tRoleBorder = hVar.tab_roleborder[0]
		end
		local iconW = tRoleBorder.width
		local iconH = tRoleBorder.height
		local width = 48 * iconW / iconH
		local height = 48
		local posx = 0
		local posy = 0
		if (height > width) then
			posy = -(height - width) / 2
		end
		_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleBorder"] = hUI.image:new({
			parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			model = tRoleBorder.icon,
			x = posx,
			y = posy,
			w = width,
			h = height,
		})
		if (uid == xlPlayer_GetUID()) then --我发送的消息
			if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
				local nx = BOARD_WIDTH - 40 - 48
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleBorder"]:setXY(nx, 0)
			end
		end
		]]
		
		--玩家名
		_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"] = hUI.label:new({
			parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			font = hVar.FONTC,
			x = 30,
			y = 24,
			align = "LT",
			size = 20,
			text = name,
			border = 1,
			--width = 500,
			RGB = {255, 255, 212,},
		})
		local playerNameLength = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"]:getWH()
		--print(playerNameLength)
		if (uid == xlPlayer_GetUID()) then --我发送的消息
			if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
				local nx = BOARD_WIDTH - 40 - 48 - 30 - playerNameLength
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"]:setXY(nx, 24)
			end
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].handle.s:setColor(ccc3(0,255,0))
		else 
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].handle.s:setColor(ccc3(255,255,212))
		end
		
		--会长权限
		local leaderOffsetX = 0
		if (leaderId == hVar.GROUP_MEMBER_AUTORITY.ADMIN) then
			--local length = hApi.GetStringEmojiCNLength(name) --处理表情，中文长度
			leaderOffsetX = 36
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				model = "UI:GROUP_HUIZHANG",
				x = 30 + playerNameLength + 22,
				align = "MC",
				y = 12 + 2,
				w = 30,
				h = 30,
			})
			if (uid == xlPlayer_GetUID()) then --我发送的消息
				if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
					local nx = BOARD_WIDTH - 40 - 48 - 30 - playerNameLength - 22
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"]:setXY(nx, 12 + 2)
				end
			end
		elseif (leaderId == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT) or (leaderId == hVar.GROUP_MEMBER_AUTORITY.ASSISTANT_SYSTEM) then --助理
			--local length = hApi.GetStringEmojiCNLength(name) --处理表情，中文长度
			leaderOffsetX = 36
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				model = "UI:GROUP_ZHULI",
				x = 30 + playerNameLength + 22,
				align = "MC",
				y = 12 + 2,
				w = 30,
				h = 30,
			})
			if (uid == xlPlayer_GetUID()) then --我发送的消息
				if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
					local nx = BOARD_WIDTH - 40 - 48 - 30 - playerNameLength - 22
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"]:setXY(nx, 12 + 2)
				end
			end
		end
		
		--聊天龙王
		local dragonOffeetX = 0
		if (dragonId == 1) then
			dragonOffeetX = 36
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				model = "UI:ICON_CHAT_DRAGON",
				x = 30 + leaderOffsetX + playerNameLength + 22,
				align = "MC",
				y = 12 + 2,
				w = 30,
				h = 30,
			})
			if (uid == xlPlayer_GetUID()) then --我发送的消息
				if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
					local nx = BOARD_WIDTH - 40 - 48 - 30 - leaderOffsetX - playerNameLength - 22
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"]:setXY(nx, 12 + 2)
				end
			end
		end
		
		--日期
		local year = string.sub(date, 1, 4)
		local month = string.sub(date, 6, 7)
		local day = string.sub(date, 9, 10)
		local hour = string.sub(date, 12, 13)
		local minute = string.sub(date,15, 16)
		local second = string.sub(date, 18, 19)
		
		--检测日期是否为今日
		--客户端的时间
		local localTime = os.time()
		--服务器的时间
		local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
		--转化为北京时间
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
		hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
		local nowDate = os.date("%Y-%m-%d %H:%M:%S", hostTime)
		local yearNow = string.sub(nowDate, 1, 4)
		local monthNow = string.sub(nowDate, 6, 7)
		local dayNow = string.sub(nowDate, 9, 10)
		
		local showDate = ""
		if (year == yearNow) and (month == monthNow) and (day == dayNow) then --今日
			showDate = string.sub(date, 12, 19)
		elseif (year == yearNow) then --今年
			showDate = month .. hVar.tab_string["_TEXT_MONTH_"] .. day .. hVar.tab_string["_TEXT_DAY_"] .. " " .. string.sub(date, 12, 19)
		else --去年
			showDate = year .. hVar.tab_string["_TEXT_YEAR_"] .. month .. hVar.tab_string["_TEXT_MONTH_"] .. day .. hVar.tab_string["_TEXT_DAY_"] .. " " .. string.sub(date, 12, 19)
		end
		--local length = hApi.GetStringEmojiCNLength(name) --处理表情，中文长度
		local strInfo = "  [ " .. showDate .. " ]"
		local strInfoAlign = "LT"
		if (uid == xlPlayer_GetUID()) then --我发送的消息
			if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
				strInfoAlign = "RT"
			end
		end
		_frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"] = hUI.label:new({
			parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			font = hVar.FONTC,
			x = 30 + leaderOffsetX + dragonOffeetX + playerNameLength,
			y = 22 - 0,
			size = 16,
			align = strInfoAlign, --"LT",
			width = 500,
			text = strInfo,
			border = 1,
			RGB = {212, 212, 212,},
		})
		if (uid == xlPlayer_GetUID()) then --我发送的消息
			if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
				--local lengthInfo = hApi.GetStringEmojiCNLength(strInfo) --处理表情，中文长度
				local nx = BOARD_WIDTH - leaderOffsetX - dragonOffeetX - 40 - 48 - 30 - playerNameLength - 12 --额外减12
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"]:setXY(nx, 22 - 0)
			end
		end
		
		--根据消息类型绘制聊天内容
		if (msgType == hVar.MESSAGE_TYPE.TEXT) then --文本消息
			--聊天内容
			--首先尝试一行绘制文本，检测文本是否超长，再换行
			local CHAT_TEXT_WIDTH_MIN = 60 --聊天内容一行最小长度
			local CHAT_TEXT_WIDTH_MAX = 363 --聊天内容一行最大长度
			local CHAT_TEXT_HEIGHT_MIN = 45 --聊天文本消息边框最小高度
			
			--聊天内容（尝试）
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 54 - 2,
				y = -15,
				z = 1,
				align = "LT",
				--width = 363, --18个汉字
				text = content,
				size = 22,
				border = 1,
			})
			local contentLength = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"]:getWH()
			if (contentLength > CHAT_TEXT_WIDTH_MAX) then
				--删除后重绘
				hApi.safeRemoveT(_frmNode.childUI["DLCMapInfoNode" .. index].childUI, "content")
				
				--聊天内容（2）
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
					parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
					font = hVar.FONTC,
					x = 54 - 2,
					y = -15,
					z = 1,
					align = "LT",
					width = CHAT_TEXT_WIDTH_MAX, --18个汉字
					text = content,
					size = 22,
					border = 1,
				})
				
				--定长
				contentLength = CHAT_TEXT_WIDTH_MAX
			end
			if (uid == xlPlayer_GetUID()) then --我发送的消息
				--local length = hApi.GetStringEmojiCNLength(content) --处理表情，中文长度
				--if (length > 16) then
				--	length = 16
				--end
				local nx = BOARD_WIDTH - 40 - 48 - 54 + 2 - contentLength
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"]:setXY(nx, -15)
			end
			
			--聊天冒泡
			--九宫格
			local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
			local swidth = contentLength + 32 --冒泡图片的额外长度
			local sheight = wh.height + 20
			--print(swidth,sheight)
			--[[
			local sRow = math.floor(wh.height / 20) --行数 --字体修正变小了
			if (sRow == 1) then --只有一行
				local lengthContent = hApi.GetStringEmojiCNLength(content) --处理表情，中文长度
				--print(content, "lengthContent=", lengthContent)
				swidth = lengthContent * 22 + 36
				if (swidth > (363 + 28)) then
					swidth = 363 + 28
				end
				if (swidth < 60) then
					swidth = 60
				end
				
				sheight = wh.height + 20
			end
			]]
			if (sheight < CHAT_TEXT_HEIGHT_MIN) then --最小高度
				sheight = CHAT_TEXT_HEIGHT_MIN
			end
			if (swidth < CHAT_TEXT_WIDTH_MIN) then --最小长度
				swidth = CHAT_TEXT_WIDTH_MIN
			end
			
			--print(swidth, sheight)
			--print(sRow, swidth, sheight)
			local s9 = nil
			if (uid == xlPlayer_GetUID()) then --我发送的消息
				 --冒泡图片（右侧）
				 local nx = BOARD_WIDTH - 40 - 48 - 30
				s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/chatbubble_r.png", nx, -3, swidth, sheight, _frmNode.childUI["DLCMapInfoNode" .. index])
				s9:setAnchorPoint(1, 1)
			else
				s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/chatbubble_l.png", 30, -3, swidth, sheight, _frmNode.childUI["DLCMapInfoNode" .. index])
				s9:setAnchorPoint(0, 1)
			end
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 42
			
			--[[
			--测试 --test
			if (uid == 22072344) then
				championId = 2001
			end
			]]
			
			--绘制称号（文本消息）
			if (championId > 0) then
				--称号图标
				local tRoleChampion = hVar.tab_rolechampion[championId]
				if (tRoleChampion == nil) then
					tRoleChampion = hVar.tab_rolechampion[0]
				end
				local iconW = tRoleChampion.width
				local iconH = tRoleChampion.height
				local width = 52 * iconW / iconH
				local height = 52
				local posx = iconW/2 + 8
				local posy = 0
				if (height > width) then
					posy = -(height - width) / 2
				end
				--print(posy)
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleChampion"] = hUI.image:new({
					parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
					model = tRoleChampion.icon,
					x = posx,
					y = posy,
					w = width,
					h = height,
				})
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
						local nx = BOARD_WIDTH - 40 - 48
						_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleChampion"]:setXY(nx - posx, posy)
					end
				end
				
				--重置一些控件的y坐标
				--图标
				local dx = 0
				local dy = -14
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					--
				end
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"]:setXY(px + dx, py + dy)
				--玩家名
				local dx = width + 0
				local dy = -18
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					dx = -dx
				end
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"]:setXY(px + dx, py + dy)
				--会长权限
				if _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"] then
					local dx = width + 0
					local dy = -18 + 2
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						dx = -dx
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"]:setXY(px + dx, py + dy)
				end
				--聊天龙王
				if _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"] then
					local dx = width + 0
					local dy = -18 + 2
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						dx = -dx
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"]:setXY(px + dx, py + dy)
				end
				--日期
				local dx = width + 0
				local dy = -18
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					dx = -dx
				end
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"]:setXY(px + dx, py + dy)
				--聊天底纹
				local dx = 0
				local dy = -height/2 - 2
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					dx = -dx
				end
				local px, py = s9:getPosition()
				s9:setPosition(px + dx, py + dy)
				--聊天文字
				local dx = 0
				local dy = -height/2 - 2
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					dx = -dx
				end
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"]:setXY(px + dx, py + dy)
				
				--存储此条聊天记录的高度
				_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = _frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight - dy
			end
		elseif (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_NOTICE) then --提示类系统文本消息
			--系统名称的颜色
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].handle.s:setColor(ccc3(255, 168, 128))
			
			--系统聊天内容
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 54 - 20,
				y = -15 + 10,
				z = 1,
				align = "LT",
				width = 594, --27个字 
				text = content,
				size = 22,
				border = 1,
				RGB = {0, 244, 0,},
			})
			
			local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
			local swidth = 594 + 28
			local sheight = wh.height + 20 - 16
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 42
		elseif (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_WARNING) then --警告类系统文本消息
			--系统名称的颜色
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].handle.s:setColor(ccc3(255, 168, 128))
			
			--系统聊天内容
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 54 - 20,
				y = -15 + 10,
				z = 1,
				align = "LT",
				width = 594, --27个字
				text = content,
				size = 22,
				border = 1,
				RGB = {244, 36, 36,}, --红色
			})
			
			local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
			local swidth = 594 + 28
			local sheight = wh.height + 20 - 16
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 42
		elseif (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_NOTICE) then --军团系统提示文本消息
			--系统名称的颜色
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].handle.s:setColor(ccc3(255, 168, 128))
			
			--系统聊天内容
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 54 - 20,
				y = -15 + 10,
				z = 1,
				align = "LT",
				width = 594, --27个字 
				text = content,
				size = 22,
				border = 1,
				RGB = {0, 244, 0,},
			})
			
			local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
			local swidth = 594 + 28
			local sheight = wh.height + 20 - 16
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 42
		elseif (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_WARNING) then --军团系统警告文本消息
			--系统名称的颜色
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].handle.s:setColor(ccc3(255, 168, 128))
			
			--系统聊天内容
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 54 - 20,
				y = -15 + 10,
				z = 1,
				align = "LT",
				width = 594, --27个字
				text = content,
				size = 22,
				border = 1,
				RGB = {244, 36, 36,}, --红色
			})
			
			local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
			local swidth = 594 + 28
			local sheight = wh.height + 20 - 16
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 42
		elseif (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_TODAY) then --军团系统今日文本消息
			--系统名称的颜色
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].handle.s:setColor(ccc3(255, 168, 128))
			
			--系统聊天内容
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 54 - 20,
				y = -15 + 10,
				z = 1,
				align = "LT",
				width = 594, --27个字 
				text = content,
				size = 22,
				border = 1,
				RGB = {0, 244, 0,},
			})
			
			local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
			local swidth = 594 + 28
			local sheight = wh.height + 20 - 16
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 42
		elseif (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_FORBIDDEN) then --禁言类系统文本消息
			--系统名称的颜色
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].handle.s:setColor(ccc3(255, 168, 128))
			
			--系统聊天内容
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 54 - 20,
				y = -15 + 10,
				z = 1,
				align = "LT",
				width = 594, --27个字 
				text = content,
				size = 22,
				border = 1,
				RGB = {192, 192, 192,},
			})
			
			local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
			local swidth = 594 + 28
			local sheight = wh.height + 20 - 16
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 42
		elseif (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_FORBIDDEN_ALL) then --全员禁言类系统文本消息
			--系统名称的颜色
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].handle.s:setColor(ccc3(255, 168, 128))
			
			--系统聊天内容
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 54 - 20,
				y = -15 + 10,
				z = 1,
				align = "LT",
				width = 594, --27个字 
				text = content,
				size = 22,
				border = 1,
				RGB = {244, 64, 64,}, --淡红色
			})
			
			local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
			local swidth = 594 + 28
			local sheight = wh.height + 20 - 16
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 42
		elseif (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_CANCEL_FORBIDDEN_ALL) then --取消全员禁言类系统文本消息
			--系统名称的颜色
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].handle.s:setColor(ccc3(255, 168, 128))
			
			--系统聊天内容
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 54 - 20,
				y = -15 + 10,
				z = 1,
				align = "LT",
				width = 594, --27个字
				text = content,
				size = 22,
				border = 1,
				RGB = {255, 255, 128,}, --淡黄色
			})
			
			local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
			local swidth = 594 + 28
			local sheight = wh.height + 20 - 16
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 42
		elseif (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_USER_BATTLE) then --系统文本玩家关卡通关消息
			--系统名称的颜色
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].handle.s:setColor(ccc3(255, 168, 128))
			
			--系统聊天内容
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 54 - 20,
				y = -15 + 10,
				z = 1,
				align = "LT",
				width = 594, --27个字 
				text = content,
				size = 22,
				border = 1,
				RGB = {0, 255, 255,},
			})
			
			local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
			local swidth = 594 + 28
			local sheight = wh.height + 20 - 16
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 42
		elseif (msgType == hVar.MESSAGE_TYPE.PRIVATE_INVITE) then --私聊好友验证消息
			--_tab_string["__TEXT_PrivateInvite1"] = "您已向对方发起私聊请求！正在等待回应！"
			--_tab_string["__TEXT_PrivateInvite2"] = "【%d】向您发起私聊请求！是否接受私聊？"
			
			--[[
			--测试 --test
			if (uid == 80001032) then
				championId = 2001
			end
			]]
			
			--如果我是私聊的发起者
			if (uid == xlPlayer_GetUID()) then --我发送的验证消息
				--修改聊天内容
				local content = hVar.tab_string["__TEXT_PrivateInvite1"] --"您已向对方发起私聊请求！正在等待回应！"
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
					parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
					font = hVar.FONTC,
					x = 54 - 20,
					y = -15 + 10,
					z = 1,
					align = "LT",
					width = 594, --27个字
					text = content,
					size = 22,
					border = 1,
					--RGB = {255, 255, 255,},
				})
				
				local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
				local swidth = 594 + 28
				local sheight = wh.height + 20 - 16
				
				local length = hApi.GetStringEmojiCNLength(content) --处理表情，中文长度
				if (length > 27) then
					length = 27
				end
				local nx = BOARD_WIDTH - 40 - 48 - 54 + 20 - 22 * length
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"]:setXY(nx, -15 + 10)
				
				--存储此条聊天记录的高度
				_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 42
				
				--绘制称号（私聊验证消息）
				if (championId > 0) then
					--称号图标
					local tRoleChampion = hVar.tab_rolechampion[championId]
					if (tRoleChampion == nil) then
						tRoleChampion = hVar.tab_rolechampion[0]
					end
					local iconW = tRoleChampion.width
					local iconH = tRoleChampion.height
					local width = 52 * iconW / iconH
					local height = 52
					local posx = iconW/2 + 8
					local posy = 0
					if (height > width) then
						posy = -(height - width) / 2
					end
					--print(posy)
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleChampion"] = hUI.image:new({
						parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
						model = tRoleChampion.icon,
						x = posx,
						y = posy,
						w = width,
						h = height,
					})
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
							local nx = BOARD_WIDTH - 40 - 48
							_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleChampion"]:setXY(nx - posx, posy)
						end
					end
					
					--重置一些控件的y坐标
					--图标
					local dx = 0
					local dy = -14
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						--
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"]:setXY(px + dx, py + dy)
					--玩家名
					local dx = width + 0
					local dy = -18
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						dx = -dx
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"]:setXY(px + dx, py + dy)
					--会长权限
					if _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"] then
						local dx = width + 0
						local dy = -18 + 2
						if (uid == xlPlayer_GetUID()) then --我发送的消息
							dx = -dx
						end
						local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"].data.y
						_frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"]:setXY(px + dx, py + dy)
					end
					--聊天龙王
					if _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"] then
						local dx = width + 0
						local dy = -18 + 2
						if (uid == xlPlayer_GetUID()) then --我发送的消息
							dx = -dx
						end
						local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"].data.y
						_frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"]:setXY(px + dx, py + dy)
					end
					--日期
					local dx = width + 0
					local dy = -18
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						dx = -dx
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"]:setXY(px + dx, py + dy)
					--聊天文字
					local dx = 0
					local dy = -height/2 - 2
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						dx = -dx
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"]:setXY(px + dx, py + dy)
					
					--存储此条聊天记录的高度
					_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = _frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight - dy
				end
			elseif (touid == xlPlayer_GetUID()) then --我收到的验证消息
				--修改聊天内容
				local content = string.format(hVar.tab_string["__TEXT_PrivateInvite2"], name) --"【%d】向您发起私聊请求！是否接受？"
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
					parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
					font = hVar.FONTC,
					x = 54,
					y = -15,
					z = 1,
					align = "LT",
					width = 594, --27个字
					text = content,
					size = 22,
					border = 1,
					--RGB = {255, 255, 255,},
				})
				
				--聊天冒泡
				--九宫格
				local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
				local swidth = 594 + 28
				local sheight = wh.height + 20 + 62 --加上按钮高度
				local sRow = math.floor(wh.height / 20) --行数 --字体修正变小了
				if (sRow == 1) then --只有一行
					local lengthContent = hApi.GetStringEmojiCNLength(content) --处理表情，中文长度
					swidth = lengthContent * 22 + 36
					if (swidth > (594 + 28)) then
						swidth = 594 + 28
					end
					if (swidth < 60) then
						swidth = 60
					end
				end
				--print(swidth, sheight)
				--print(sRow, swidth, sheight)
				local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/chatbubble_l.png", 30, -2, swidth, sheight, _frmNode.childUI["DLCMapInfoNode" .. index])
				s9:setAnchorPoint(0, 1)
				
				--接受按钮
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["btnAccept"] = hUI.button:new({ --作为按钮只是为了挂载子控件
					parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
					font = hVar.FONTC,
					x = 30 + 4 + swidth / 2 + 100,
					y = -wh.height - 54,
					model = "misc/addition/tank_anniu.png", --"UI:PANEL_MENU_BTN_BIG",
					label = {x = 2, y = 3, text = hVar.tab_string["__TEXT_Accept"], size = 24, font = hVar.FONTC, border = 1, RGB = {255, 255, 144},}, --"接受"
					w = 134,
					h = 54,
				})
				
				--拒绝按钮
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["btnRefuse"] = hUI.button:new({ --作为按钮只是为了挂载子控件
					parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
					font = hVar.FONTC,
					x = 30 + 4 + swidth / 2 - 100,
					y = -wh.height - 54,
					model = "misc/addition/tank_anniu.png", --"UI:PANEL_MENU_BTN_BIG",
					label = {x = 2, y = 3, text = hVar.tab_string["__TEXT_Refuse"], size = 24, font = hVar.FONTC, border = 1, RGB = {236, 236, 212},}, --"拒绝"
					w = 134,
					h = 54,
				})
				
				--存储此条聊天记录的高度
				_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 40 --加上按钮高度
				
				--绘制称号（私聊验证消息）
				if (championId > 0) then
					--称号图标
					local tRoleChampion = hVar.tab_rolechampion[championId]
					if (tRoleChampion == nil) then
						tRoleChampion = hVar.tab_rolechampion[0]
					end
					local iconW = tRoleChampion.width
					local iconH = tRoleChampion.height
					local width = 52 * iconW / iconH
					local height = 52
					local posx = iconW/2 + 8
					local posy = 0
					if (height > width) then
						posy = -(height - width) / 2
					end
					--print(posy)
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleChampion"] = hUI.image:new({
						parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
						model = tRoleChampion.icon,
						x = posx,
						y = posy,
						w = width,
						h = height,
					})
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
							local nx = BOARD_WIDTH - 40 - 48
							_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleChampion"]:setXY(nx - posx, posy)
						end
					end
					
					--重置一些控件的y坐标
					--图标
					local dx = 0
					local dy = -14
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						--
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"]:setXY(px + dx, py + dy)
					--玩家名
					local dx = width + 0
					local dy = -18
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						dx = -dx
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"]:setXY(px + dx, py + dy)
					--会长权限
					if _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"] then
						local dx = width + 0
						local dy = -18 + 2
						if (uid == xlPlayer_GetUID()) then --我发送的消息
							dx = -dx
						end
						local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"].data.y
						_frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"]:setXY(px + dx, py + dy)
					end
					--聊天龙王
					if _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"] then
						local dx = width + 0
						local dy = -18 + 2
						if (uid == xlPlayer_GetUID()) then --我发送的消息
							dx = -dx
						end
						local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"].data.y
						_frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"]:setXY(px + dx, py + dy)
					end
					--日期
					local dx = width + 0
					local dy = -18
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						dx = -dx
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"]:setXY(px + dx, py + dy)
					--聊天底纹
					local dx = 0
					local dy = -height/2 - 2
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						dx = -dx
					end
					local px, py = s9:getPosition()
					s9:setPosition(px + dx, py + dy)
					--接受按钮
					local dx = 0
					local dy = -height/2 - 2
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						dx = -dx
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["btnAccept"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["btnAccept"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["btnAccept"]:setXY(px + dx, py + dy)
					--拒绝按钮
					local dx = 0
					local dy = -height/2 - 2
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						dx = -dx
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["btnRefuse"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["btnRefuse"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["btnRefuse"]:setXY(px + dx, py + dy)
					--聊天文字
					local dx = 0
					local dy = -height/2 - 2
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						dx = -dx
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"]:setXY(px + dx, py + dy)
					
					--存储此条聊天记录的高度
					_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = _frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight - dy
				end
			end
		elseif (msgType == hVar.MESSAGE_TYPE.PRIVATE_INVITE_ACCEPT) then --私聊通过好友验证消息
			--修改聊天内容
			local content = string.format(hVar.tab_string["__TEXT_PrivateInviteAccept1"], name) --"【%s】接受了您的私聊请求，现在可以开始聊天了。"
			if (uid == xlPlayer_GetUID()) then --我操作的
				content = hVar.tab_string["__TEXT_PrivateInviteAccept2"] --"您接受了对方的的私聊请求，现在可以开始聊天了。"
			end
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 54 - 20,
				y = -15 + 10,
				z = 1,
				align = "LT",
				width = 594, --27个字
				text = content,
				size = 22,
				border = 1,
				RGB = {36, 244, 36,},
			})
			
			local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
			local swidth = 550 + 28
			local sheight = wh.height + 20 - 16
			
			if (uid == xlPlayer_GetUID()) then --我操作的
				local length = hApi.GetStringEmojiCNLength(content) --处理表情，中文长度
				if (length > 27) then
					length = 27
				end
				local nx = BOARD_WIDTH - 40 - 48 - 54 + 20 - 22 * length
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"]:setXY(nx, -15 + 10)
			end
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 42
			
			--绘制称号（私聊通过消息）
			if (championId > 0) then
				--称号图标
				local tRoleChampion = hVar.tab_rolechampion[championId]
				if (tRoleChampion == nil) then
					tRoleChampion = hVar.tab_rolechampion[0]
				end
				local iconW = tRoleChampion.width
				local iconH = tRoleChampion.height
				local width = 52 * iconW / iconH
				local height = 52
				local posx = iconW/2 + 8
				local posy = 0
				if (height > width) then
					posy = -(height - width) / 2
				end
				--print(posy)
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleChampion"] = hUI.image:new({
					parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
					model = tRoleChampion.icon,
					x = posx,
					y = posy,
					w = width,
					h = height,
				})
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
						local nx = BOARD_WIDTH - 40 - 48
						_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleChampion"]:setXY(nx - posx, posy)
					end
				end
				
				--重置一些控件的y坐标
				--图标
				local dx = 0
				local dy = -14
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					--
				end
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"]:setXY(px + dx, py + dy)
				--玩家名
				local dx = width + 0
				local dy = -18
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					dx = -dx
				end
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"]:setXY(px + dx, py + dy)
				--会长权限
				if _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"] then
					local dx = width + 0
					local dy = -18 + 2
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						dx = -dx
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"]:setXY(px + dx, py + dy)
				end
				--聊天龙王
				if _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"] then
					local dx = width + 0
					local dy = -18 + 2
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						dx = -dx
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"]:setXY(px + dx, py + dy)
				end
				--日期
				local dx = width + 0
				local dy = -18
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					dx = -dx
				end
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"]:setXY(px + dx, py + dy)
				--聊天文字
				local dx = 0
				local dy = -height/2 - 2
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					dx = -dx
				end
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"]:setXY(px + dx, py + dy)
				
				--存储此条聊天记录的高度
				_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = _frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight - dy
			end
		elseif (msgType == hVar.MESSAGE_TYPE.PRIVATE_INVITE_REFUSE) then --私聊拒绝好友验证消息
			--修改聊天内容
			local content = string.format(hVar.tab_string["__TEXT_PrivateInviteRefuse1"], name) --"【%s】拒绝了您的私聊请求！"
			if (uid == xlPlayer_GetUID()) then --我操作的
				content = hVar.tab_string["__TEXT_PrivateInviteRefuse2"] --"您拒绝了对方的的私聊请求！"
			end
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 54 - 20,
				y = -15 + 10,
				z = 1,
				align = "LT",
				width = 594, --27个字 
				text = content,
				size = 22,
				border = 1,
				RGB = {244, 36, 36,}, --红色
			})
			
			local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
			local swidth = 550 + 28
			local sheight = wh.height + 20 - 16
			
			if (uid == xlPlayer_GetUID()) then --我操作的
				local length = hApi.GetStringEmojiCNLength(content) --处理表情，中文长度
				if (length > 27) then
					length = 27
				end
				local nx = BOARD_WIDTH - 40 - 48 - 54 + 20 - 22 * length
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"]:setXY(nx, -15 + 10)
			end
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 42
			
			--绘制称号（私聊拒绝消息）
			if (championId > 0) then
				--称号图标
				local tRoleChampion = hVar.tab_rolechampion[championId]
				if (tRoleChampion == nil) then
					tRoleChampion = hVar.tab_rolechampion[0]
				end
				local iconW = tRoleChampion.width
				local iconH = tRoleChampion.height
				local width = 52 * iconW / iconH
				local height = 52
				local posx = iconW/2 + 8
				local posy = 0
				if (height > width) then
					posy = -(height - width) / 2
				end
				--print(posy)
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleChampion"] = hUI.image:new({
					parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
					model = tRoleChampion.icon,
					x = posx,
					y = posy,
					w = width,
					h = height,
				})
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
						local nx = BOARD_WIDTH - 40 - 48
						_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleChampion"]:setXY(nx - posx, posy)
					end
				end
				
				--重置一些控件的y坐标
				--图标
				local dx = 0
				local dy = -14
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					--
				end
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"]:setXY(px + dx, py + dy)
				--玩家名
				local dx = width + 0
				local dy = -18
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					dx = -dx
				end
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"]:setXY(px + dx, py + dy)
				--会长权限
				if _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"] then
					local dx = width + 0
					local dy = -18 + 2
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						dx = -dx
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"]:setXY(px + dx, py + dy)
				end
				--聊天龙王
				if _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"] then
					local dx = width + 0
					local dy = -18 + 2
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						dx = -dx
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"]:setXY(px + dx, py + dy)
				end
				--日期
				local dx = width + 0
				local dy = -18
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					dx = -dx
				end
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"]:setXY(px + dx, py + dy)
				--聊天文字
				local dx = 0
				local dy = -height/2 - 2
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					dx = -dx
				end
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"]:setXY(px + dx, py + dy)
				
				--存储此条聊天记录的高度
				_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = _frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight - dy
			end
		elseif (msgType == hVar.MESSAGE_TYPE.PRIVATE_DELETE) then --私聊删除好友消息
			--修改聊天内容
			local content = string.format(hVar.tab_string["__TEXT_PrivateDelete1"], name) --"【%s】已关闭和您的私聊，无法再发送消息！"
			if (uid == xlPlayer_GetUID()) then --我操作的
				content = hVar.tab_string["__TEXT_PrivateDelete2"] --"您已关闭和对方的私聊，无法再发送消息！"
			end
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 54 - 20,
				y = -15 + 10,
				z = 1,
				align = "LT",
				width = 594, --27个字 
				text = content,
				size = 22,
				border = 1,
				RGB = {244, 36, 36,}, --红色
			})
			
			local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
			local swidth = 594 + 28
			local sheight = wh.height + 20 - 16
			
			if (uid == xlPlayer_GetUID()) then --我操作的
				local length = hApi.GetStringEmojiCNLength(content) --处理表情，中文长度
				if (length > 27) then
					length = 27
				end
				local nx = BOARD_WIDTH - 40 - 48 - 54 + 20 - 22 * length
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"]:setXY(nx, -15 + 10)
			end
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 42
			
			--绘制称号（私聊删除好友消息）
			if (championId > 0) then
				--称号图标
				local tRoleChampion = hVar.tab_rolechampion[championId]
				if (tRoleChampion == nil) then
					tRoleChampion = hVar.tab_rolechampion[0]
				end
				local iconW = tRoleChampion.width
				local iconH = tRoleChampion.height
				local width = 52 * iconW / iconH
				local height = 52
				local posx = iconW/2 + 8
				local posy = 0
				if (height > width) then
					posy = -(height - width) / 2
				end
				--print(posy)
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleChampion"] = hUI.image:new({
					parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
					model = tRoleChampion.icon,
					x = posx,
					y = posy,
					w = width,
					h = height,
				})
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
						local nx = BOARD_WIDTH - 40 - 48
						_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleChampion"]:setXY(nx - posx, posy)
					end
				end
				
				--重置一些控件的y坐标
				--图标
				local dx = 0
				local dy = -14
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					--
				end
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"]:setXY(px + dx, py + dy)
				--玩家名
				local dx = width + 0
				local dy = -18
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					dx = -dx
				end
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"]:setXY(px + dx, py + dy)
				--会长权限
				if _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"] then
					local dx = width + 0
					local dy = -18 + 2
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						dx = -dx
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"]:setXY(px + dx, py + dy)
				end
				--聊天龙王
				if _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"] then
					local dx = width + 0
					local dy = -18 + 2
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						dx = -dx
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"]:setXY(px + dx, py + dy)
				end
				--日期
				local dx = width + 0
				local dy = -18
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					dx = -dx
				end
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"]:setXY(px + dx, py + dy)
				--聊天文字
				local dx = 0
				local dy = -height/2 - 2
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					dx = -dx
				end
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"]:setXY(px + dx, py + dy)
				
				--存储此条聊天记录的高度
				_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = _frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight - dy
			end
		elseif (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) then --军团发红包
			--系统名称的颜色
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].handle.s:setColor(ccc3(255, 168, 128))
			
			--军团红包的红包参数信息
			local redPacketId = redPacketParam.redPacketId --红包唯一id
			local send_uid = redPacketParam.send_uid --红包发送者uid
			local send_name = redPacketParam.send_name --红包发送者名字
			local group_id = redPacketParam.group_id --红包军团id
			local send_num = redPacketParam.send_num --红包发送数量
			local content = redPacketParam.content --内容
			local coin = redPacketParam.coin --游戏币
			local order_id = redPacketParam.order_id --订单号
			local msg_id = redPacketParam.msg_id --消息id
			local receive_num = redPacketParam.receive_num --红包接收数量
			local send_time = redPacketParam.send_time --红包发送时间
			local expire_time = redPacketParam.expire_time --红包过期时间
			local redPacketReceiveList = redPacketParam.redPacketReceiveList --红包领取uid列表
			--print(redPacketId, send_uid, send_name, group_id, send_num, content, coin, order_id, msg_id, receive_num, send_time, expire_time)
			--for receive_uid, _ in pairs(redPacketReceiveList) do
			--	print(receive_uid)
			--end
			
			--聊天内容
			local textSize = 22
			local contentLength = hApi.GetStringEmojiCNLength(content) --红包文字过长缩短字号
			if (contentLength > 15) then --超过15个汉字长度
				textSize = 20
			end
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 136,
				y = -22,
				z = 1,
				align = "LT",
				width = 800,
				text = content,
				--size = 20,
				size = textSize,
				border = 1,
				RGB = {255, 255, 0,},
			})
			
			--聊天冒泡红包
			local swidth = 420
			local sheight = 100 --加上按钮高度
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacket"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = swidth / 2 + 30 - 4,
				y = -sheight / 2 - 6,
				model = "misc/chest/chatbubble_redpacket.png",
				w = swidth,
				h = sheight,
				align = "MC",
			})
			
			--聊天冒泡红包（已领取）
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketEmpty"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = swidth / 2 + 30 - 4,
				y = -sheight / 2 - 6,
				model = "misc/chest/chatbubble_redpacket_empty.png",
				w = swidth,
				h = sheight,
				align = "MC",
			})
			
			--红包图标
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketIcon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 92,
				y = -56,
				model = "misc/chest/redpacket.png",
				w = 72,
				h = 72,
				align = "MC",
			})
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketIcon"].data.shaderType = "normal" --存储高亮
			
			--红包图标边框
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketIconBorder"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 92,
				y = -56,
				model = "misc/chest/purchase_border.png",
				w = 74,
				h = 74,
				align = "MC",
			})
			
			--红包剩余数量
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["num"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = "numWhite",
				x = 126,
				y = -64,
				z = 2,
				align = "RT",
				width = 500,
				text = "",
				size = 22,
				border = 0,
			})
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["num"].handle.s:setColor(ccc3(192, 255, 192))
			
			--红包剩余领取时间
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimePrefix"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 149,
				y = -68,
				z = 2,
				align = "LT",
				width = 500,
				text = hVar.tab_string["__TEXT_RewardLeftTime"] .. ":", --"剩余领取时间:"
				size = 20,
				border = 1,
				RGB = {255, 255, 255,},
			})
			
			--红包剩余领取时间-天
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeDay"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = "numWhite",
				x = 297,
				y = -68 + 1 + 2,
				z = 2,
				align = "MT",
				width = 500,
				text = "",
				size = 20,
				border = 0,
				--RGB = {255, 255, 255,},
			})
			
			--红包剩余领取时间-天文字
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeDayPostfix"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 319,
				y = -68,
				z = 2,
				align = "LT",
				width = 500,
				text = hVar.tab_string["__TEXT_Dat"], --"天"
				size = 20,
				border = 1,
				RGB = {255, 255, 255,},
			})
			
			--红包剩余领取时间-小时
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeHour"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = "numWhite",
				x = 361,
				y = -68 + 1 + 2,
				z = 2,
				align = "MT",
				width = 500,
				text = "",
				size = 20,
				border = 0,
				--RGB = {255, 255, 255,},
			})
			
			--红包剩余领取时间-小时后缀
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeHourPostfix"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 383,
				y = -68,
				z = 2,
				align = "LT",
				width = 500,
				text = hVar.tab_string["__TEXT_Hour"], --"小时"
				size = 20,
				border = 1,
				RGB = {255, 255, 255,},
			})
			
			--红包剩余领取时间-分
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeMinute"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = "numWhite",
				x = 297,
				y = -68 + 1 + 2,
				z = 2,
				align = "MT",
				width = 500,
				text = "",
				size = 20,
				border = 0,
				--RGB = {255, 255, 255,},
			})
			
			--红包剩余领取时间-分文字
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeMinutePostfix"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 319,
				y = -68,
				z = 2,
				align = "LT",
				width = 500,
				text = hVar.tab_string["__Minute"], --"分"
				size = 20,
				border = 1,
				RGB = {255, 255, 255,},
			})
			
			--红包剩余领取时间-秒
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeSecond"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = "numWhite",
				x = 361,
				y = -68 + 1 + 2,
				z = 2,
				align = "MT",
				width = 500,
				text = "",
				size = 20,
				border = 0,
				--RGB = {255, 255, 255,},
			})
			
			--红包剩余领取时间-秒后缀
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeSecondPostfix"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 383,
				y = -68,
				z = 2,
				align = "LT",
				width = 500,
				text = hVar.tab_string["__Second"], --"秒"
				size = 20,
				border = 1,
				RGB = {255, 255, 255,},
			})
			
			--已领取图标
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardIcon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 412,
				y = -76,
				model = "UI:FinishTag",
				w = 70,
				h = 60,
				align = "MC",
			})
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardIcon"].handle._n:setVisible(false) --一开始不显示
			
			--已领取文字
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardlabel"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 190,
				y = -68,
				z = 2,
				align = "LT",
				width = 500,
				text = hVar.tab_string["__GROUP_REDPACKET_RECEIVE_YOU"], --"您已领取该红包"
				size = 20,
				border = 1,
				RGB = {0, 224, 0,},
			})
			
			--已被领完文字
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardFinishlabel"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 190,
				y = -68,
				z = 1,
				align = "LT",
				width = 500,
				text = hVar.tab_string["__GROUP_REDPACKET_RECEIVE_EMPTY"], --"红包已被领完"
				size = 20,
				border = 1,
				RGB = {224, 224, 224,},
			})
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 38 --加上按钮高度
			
			--[[
			--测试 --test
			if (uid == 81001211) then
				championId = 2001
			end
			]]
			
			--绘制称号（军团发红包消息）
			if (championId > 0) then
				--称号图标
				local tRoleChampion = hVar.tab_rolechampion[championId]
				if (tRoleChampion == nil) then
					tRoleChampion = hVar.tab_rolechampion[0]
				end
				local iconW = tRoleChampion.width
				local iconH = tRoleChampion.height
				local width = 52 * iconW / iconH
				local height = 52
				local posx = iconW/2 + 8
				local posy = 0
				if (height > width) then
					posy = -(height - width) / 2
				end
				--print(posy)
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleChampion"] = hUI.image:new({
					parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
					model = tRoleChampion.icon,
					x = posx,
					y = posy,
					w = width,
					h = height,
				})
				
				--重置一些控件的y坐标
				--图标
				local dx = 0
				local dy = -14
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"]:setXY(px + dx, py + dy)
				--玩家名
				local dx = width + 0
				local dy = -18
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"]:setXY(px + dx, py + dy)
				--会长权限
				if _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"] then
					local dx = width + 0
					local dy = -18 + 2
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"]:setXY(px + dx, py + dy)
				end
				--聊天龙王
				if _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"] then
					local dx = width + 0
					local dy = -18 + 2
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"]:setXY(px + dx, py + dy)
				end
				--日期
				local dx = width + 0
				local dy = -18
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"]:setXY(px + dx, py + dy)
				--红包图片
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacket"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacket"].data.y
				--红包文字
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"]:setXY(px + dx, py + dy)
				--聊天冒泡红包
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacket"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacket"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacket"]:setXY(px + dx, py + dy)
				--聊天冒泡红包（已领取）
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketEmpty"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketEmpty"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketEmpty"]:setXY(px + dx, py + dy)
				--红包图标
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketIcon"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketIcon"]:setXY(px + dx, py + dy)
				--红包图标边框
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketIconBorder"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketIconBorder"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketIconBorder"]:setXY(px + dx, py + dy)
				--红包剩余数量
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["num"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["num"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["num"]:setXY(px + dx, py + dy)
				--红包剩余领取时间
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimePrefix"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimePrefix"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimePrefix"]:setXY(px + dx, py + dy)
				--红包剩余领取时间-天
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeDay"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeDay"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeDay"]:setXY(px + dx, py + dy)
				--红包剩余领取时间-天文字
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeDayPostfix"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeDayPostfix"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeDayPostfix"]:setXY(px + dx, py + dy)
				--红包剩余领取时间-小时
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeHour"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeHour"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeHour"]:setXY(px + dx, py + dy)
				--红包剩余领取时间-小时后缀
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeHourPostfix"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeHourPostfix"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeHourPostfix"]:setXY(px + dx, py + dy)
				--红包剩余领取时间-分
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeMinute"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeMinute"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeMinute"]:setXY(px + dx, py + dy)
				--红包剩余领取时间-分文字
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeMinutePostfix"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeMinutePostfix"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeMinutePostfix"]:setXY(px + dx, py + dy)
				--红包剩余领取时间-秒
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeSecond"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeSecond"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeSecond"]:setXY(px + dx, py + dy)
				--红包剩余领取时间-分文字
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeSecondPostfix"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeSecondPostfix"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttimeSecondPostfix"]:setXY(px + dx, py + dy)
				--已领取图标
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardIcon"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardIcon"]:setXY(px + dx, py + dy)
				--已领取文字
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardlabel"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardlabel"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardlabel"]:setXY(px + dx, py + dy)
				--已被领完文字
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardFinishlabel"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardFinishlabel"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardFinishlabel"]:setXY(px + dx, py + dy)
				
				--存储此条聊天记录的高度
				_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = _frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight - dy
			end
			
			--立即更新此军团红包消息界面绘制
			update_group_redpacket_msg_paint(index)
		elseif (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_RECEIVE) then --军团收红包
			--系统名称的颜色
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].handle.s:setColor(ccc3(255, 168, 128))
			
			--系统军团收红包聊天内容
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 54 - 20,
				y = -15 + 10,
				z = 1,
				align = "LT",
				width = 594, --27个字
				text = content,
				size = 22,
				border = 1,
				RGB = {255, 255, 0,}, --黄色
			})
			
			local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
			local swidth = 594 + 28
			local sheight = wh.height + 20 - 16
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 42
		elseif (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --发支付（土豪）红包
			--系统名称的颜色
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].handle.s:setColor(ccc3(255, 168, 128))
			
			--支付（土豪）红包的红包参数信息
			local redPacketId = redPacketParam.redPacketId --红包唯一id
			local send_uid = redPacketParam.send_uid --红包发送者uid
			local send_name = redPacketParam.send_name --红包发送者名字
			local send_num = redPacketParam.send_num --红包发送数量
			local content = redPacketParam.content --内容
			local money = redPacketParam.money --充值金额
			local iap_id = redPacketParam.iap_id --充值记录id
			local channelId = redPacketParam.channelId --渠道号
			local vipLv = redPacketParam.vipLv --vip等级
			local borderId = redPacketParam.borderId --边框id
			local iconId = redPacketParam.iconId --头像id
			local championId = redPacketParam.championId --称号id
			local leaderId = redPacketParam.leaderId --会长权限
			local dragonId = redPacketParam.dragonId --聊天龙王id
			local headId = redPacketParam.headId --头衔id
			local lineId = redPacketParam.lineId --线索id
			local msg_id = redPacketParam.msg_id --消息id
			local receive_num = redPacketParam.receive_num --红包接收数量
			local send_time = redPacketParam.send_time --红包发送时间
			local expire_time = redPacketParam.expire_time --红包过期时间
			local redPacketReceiveList = redPacketParam.redPacketReceiveList --红包领取uid列表
			--print(redPacketId, send_uid, send_name, send_num, content, money, iap_id, channelId, vipLv, borderId, iconId, championId, leaderId, dragonId, headId, lineId, msg_id, receive_num, send_time, expire_time)
			--for receive_uid, _ in pairs(redPacketReceiveList) do
			--	print(receive_uid)
			--end
			
			--!!!! edit by mj 临时去掉会长权限/称号
			leaderId = 0
			championId = 0

			--聊天内容
			local textSize = 24
			local contentLength = hApi.GetStringEmojiCNLength(content) --红包文字过长缩短字号
			if (contentLength > 15) then --超过15个汉字长度
				textSize = 20
			end
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 136,
				y = -22,
				z = 1,
				align = "LT",
				width = 800,
				text = content,
				--size = 20,
				size = textSize,
				border = 1,
				RGB = {255, 255, 0,},
			})
			
			--聊天冒泡红包
			local swidth = 420
			local sheight = 100 --加上按钮高度
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacket"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = swidth / 2 + 30 - 4,
				y = -sheight / 2 - 6,
				model = "misc/chest/chatbubble_redpacket.png",
				w = swidth,
				h = sheight,
				align = "MC",
			})
			
			--聊天冒泡红包（已领取）
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketEmpty"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = swidth / 2 + 30 - 4,
				y = -sheight / 2 - 6,
				model = "misc/chest/chatbubble_redpacket_empty.png",
				w = swidth,
				h = sheight,
				align = "MC",
			})
			
			--红包图标
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketIcon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 92,
				y = -56,
				model = "misc/chest/redpacket_open.png",
				w = 72,
				h = 72,
				align = "MC",
			})
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketIcon"].data.shaderType = "normal" --存储高亮
			
			--[[
			--红包图标边框
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketIconBorder"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 92,
				y = -56,
				model = "misc/chest/purchase_border.png",
				w = 74,
				h = 74,
				align = "MC",
			})
			]]
			
			--已领取图标
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardIcon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 412,
				y = -76,
				model = "UI:FinishTag",
				w = 70,
				h = 60,
				align = "MC",
			})
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardIcon"].handle._n:setVisible(false) --一开始不显示
			
			--点击领取文字
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["torewardlabel"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 190,
				y = -68,
				z = 2,
				align = "LT",
				width = 500,
				text = hVar.tab_string["__GROUP_REDPACKET_RECEIVE_CLICK"], --"点击领取红包"
				size = 20,
				border = 1,
				--RGB = {255, 255, 255,},
			})
			
			--已领取文字
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardlabel"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 190,
				y = -68,
				z = 2,
				align = "LT",
				width = 500,
				text = hVar.tab_string["__GROUP_REDPACKET_RECEIVE_YOU"], --"您已领取该红包"
				size = 20,
				border = 1,
				RGB = {0, 224, 0,},
			})
			
			--已被领完文字
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardFinishlabel"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 190,
				y = -68,
				z = 1,
				align = "LT",
				width = 500,
				text = hVar.tab_string["__GROUP_REDPACKET_RECEIVE_EMPTY"], --"红包已被领完"
				size = 20,
				border = 1,
				RGB = {224, 224, 224,},
			})
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 38 --加上按钮高度
			
			--[[
			--测试 --test
			if (uid == 21158182) then
				championId = 2001
			end
			]]
			
			--绘制称号（世界红包消息）
			if (championId > 0) then
				--称号图标
				local tRoleChampion = hVar.tab_rolechampion[championId]
				if (tRoleChampion == nil) then
					tRoleChampion = hVar.tab_rolechampion[0]
				end
				local iconW = tRoleChampion.width
				local iconH = tRoleChampion.height
				local width = 52 * iconW / iconH
				local height = 52
				local posx = iconW/2 + 8
				local posy = 0
				if (height > width) then
					posy = -(height - width) / 2
				end
				--print(posy)
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleChampion"] = hUI.image:new({
					parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
					model = tRoleChampion.icon,
					x = posx,
					y = posy,
					w = width,
					h = height,
				})
				
				--重置一些控件的y坐标
				--图标
				local dx = 0
				local dy = -14
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"]:setXY(px + dx, py + dy)
				--玩家名
				local dx = width + 0
				local dy = -18
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"]:setXY(px + dx, py + dy)
				--会长权限
				if _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"] then
					local dx = width + 0
					local dy = -18 + 2
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"]:setXY(px + dx, py + dy)
				end
				--聊天龙王
				if _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"] then
					local dx = width + 0
					local dy = -18 + 2
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"]:setXY(px + dx, py + dy)
				end
				--日期
				local dx = width + 0
				local dy = -18
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"]:setXY(px + dx, py + dy)
				--红包文字
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"]:setXY(px + dx, py + dy)
				--聊天冒泡红包
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacket"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacket"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacket"]:setXY(px + dx, py + dy)
				--聊天冒泡红包（已领取）
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketEmpty"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketEmpty"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketEmpty"]:setXY(px + dx, py + dy)
				--红包图标
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketIcon"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["redPacketIcon"]:setXY(px + dx, py + dy)
				--已领取图标
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardIcon"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardIcon"]:setXY(px + dx, py + dy)
				--点击领取文字
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["torewardlabel"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["torewardlabel"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["torewardlabel"]:setXY(px + dx, py + dy)
				--已领取文字
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardlabel"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardlabel"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardlabel"]:setXY(px + dx, py + dy)
				--已被领完文字
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardFinishlabel"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardFinishlabel"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rewardFinishlabel"]:setXY(px + dx, py + dy)
				
				--存储此条聊天记录的高度
				_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = _frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight - dy
			end
			
			--立即更新此支付（土豪）红包消息界面绘制
			update_pay_redpacket_msg_paint(index)
		elseif (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_RECEIVE) then --收支付（土豪）红包
			--系统名称的颜色
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].handle.s:setColor(ccc3(255, 168, 128))
			
			--收支付（土豪）红包聊天内容
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 54 - 20,
				y = -15 + 10,
				z = 1,
				align = "LT",
				width = 594, --27个字
				text = content,
				size = 22,
				border = 1,
				RGB = {255, 255, 0,}, --黄色
			})
			
			local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
			local swidth = 594 + 28
			local sheight = wh.height + 20 - 16
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 42
		elseif (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_ADVISE) then --系统聊天忠告信息
			--系统名称的颜色
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].handle.s:setColor(ccc3(255, 168, 128))
			
			--系统聊天内容
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 54 - 20,
				y = -15 + 10,
				z = 1,
				align = "LT",
				width = 594, --27个字
				text = hVar.tab_string["__TEXT_CHAT_ADVERSE"],
				size = 22,
				border = 1,
				RGB = {255, 255, 0,}, --黄色
			})
			
			local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
			local swidth = 594 + 28
			local sheight = wh.height + 20 - 16
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 42
		elseif (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_ADVISE2) then --系统聊天忠告信息2
			--系统名称的颜色
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].handle.s:setColor(ccc3(255, 168, 128))
			
			--系统聊天内容
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 54 - 20,
				y = -15 + 10,
				z = 1,
				align = "LT",
				width = 594, --27个字
				text = hVar.tab_string["__TEXT_CHAT_ADVERSE2"],
				size = 22,
				border = 1,
				RGB = {255, 255, 0,}, --黄色
			})
			
			local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
			local swidth = 594 + 28
			local sheight = wh.height + 20 - 16
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 42
		elseif (msgType == hVar.MESSAGE_TYPE.INVITE_GROUP) then --军团邀请函消息
			local inviteGroupId = redPacketParam.inviteGroupId --军团邀请函唯一id
			local groupId = redPacketParam.groupId --军团id
			local groupName = redPacketParam.groupName --军团名 --解析表情
			local groupLevel = redPacketParam.groupLevel --军团主城等级
			local groupForce = redPacketParam.groupForce --军团阵营
			local groupMember = redPacketParam.groupMember --军团当前成员人数
			local groupMemberMax = redPacketParam.groupMemberMax --军团总人数
			local groupIntroduce = redPacketParam.groupIntroduce --军团介绍 --解析表情
			local dayMin = redPacketParam.dayMin --军团需要的最小注册时间（天）
			local vipMin = redPacketParam.vipMin --军团需要的最小vip等级
			local msg_id = redPacketParam.msg_id --消息id
			local create_time = redPacketParam.create_time --军团邀请函发起时间
			local expire_time = redPacketParam.expire_time --军团邀请函过期时间
			
			--清除之前的控件
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"]:setText("")
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"]:setText("")
			hApi.safeRemoveT(_frmNode.childUI["DLCMapInfoNode" .. index].childUI, "leaderIcon")
			hApi.safeRemoveT(_frmNode.childUI["DLCMapInfoNode" .. index].childUI, "dragonIcon")
			hApi.safeRemoveT(_frmNode.childUI["DLCMapInfoNode" .. index].childUI, "roleIcon")
			
			--军团邀请函的底图
			local swidth = 690
			local sheight = 140
			local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_graywhite.png", swidth/2 - 28, -sheight/2 + 28, swidth, sheight, _frmNode.childUI["DLCMapInfoNode" .. index])
			
			--外边框
			local s92 = hApi.CCScale9SpriteCreate("data/image/misc/chest/purchase_border.png", swidth/2 - 28, -sheight/2 + 28, swidth - 4, sheight - 4, _frmNode.childUI["DLCMapInfoNode" .. index])
			
			--军团势力图标
			local modelForceIcon = nil
			if (groupForce == 1) then --魏国
				modelForceIcon = "misc/legion/flag_wei_s.png"
			elseif (groupForce == 2) then --蜀国
				modelForceIcon = "misc/legion/flag_shu_s.png"
			elseif (groupForce == 3) then --蜀国
				modelForceIcon = "misc/legion/flag_wu_s.png"
			end
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["GroupForce"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 32,
				y = -22,
				model = modelForceIcon,
				align = "MC",
				scale = 1.2,
			})
			
			--军团主城等级背景图
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["GroupLvBG"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 32,
				y = -22 - 40,
				model = "misc/chest/herodetailname.png",
				align = "MC",
				w = 90,
				h = 30,
				alpha = 128,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfo_GroupLvBG"
			
			--军团主城等级
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["GroupLv"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 32,
				y = -22 - 40 - 2,
				align = "MC",
				font = hVar.FONTC,
				border = 1,
				width = 300,
				text = "Lv " .. groupLevel,
				size = 22,
				RGB = {255, 255, 128,},
			})
			
			--军团名背景栏
			--九宫格
			local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_graygray.png", 270, -6, 370, 36, _frmNode.childUI["DLCMapInfoNode" .. index])
			s9:setOpacity(144)
			
			--军团名
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["GroupName"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 90,
				y = -6 - 1,
				align = "LC",
				font = hVar.FONTC,
				border = 1,
				--width = 300,
				text = hApi.StringDecodeEmoji(groupName), --解析表情
				size = 24,
				RGB = {0, 255, 0,},
			})
			
			--管理员可见本军团的id
			if (g_lua_src == 1) or (g_is_account_test == 2) then --源代码模式、管理员
				--军团的id
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["GroupIdLabel"] = hUI.label:new({ --作为按钮只是为了挂载子控件
					parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
					x = 32,
					y = -92,
					align = "MC",
					width = 300,
					text = "[" .. tostring(groupId) .. "]",
					border = 1,
					font = hVar.FONTC,
					size = 20,
					RGB = {255, 255, 0,},
				})
			end
			
			--XXX 军团的邀请函
			local groupNameLength = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["GroupName"]:getWH()
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["GroupInvite"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 90 + 2 + groupNameLength,
				y = -6 - 1,
				align = "LC",
				font = hVar.FONTC,
				border = 1,
				--width = 300,
				text = hVar.tab_string["__TEXT_GROUP_INVITE"], --"军团的邀请函"
				size = 24,
				RGB = {255, 255, 255,},
			})
			
			--军团公告
			--groupIntroduce = "扫荡发多方扫荡发多十扫荡发多方扫荡发多十扫荡发多方扫荡发多十扫荡" --32个汉字
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["BroadcastLabel"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 90,
				y = -28,
				align = "LT",
				font = hVar.FONTC,
				border = 1,
				width = 370,
				text = hApi.StringDecodeEmoji(hVar.tab_string["__TEXT_Notice"] .. ": " .. groupIntroduce), --解析表情
				size = 20,
				RGB = {255, 255, 236,},
			})
			
			--申请按钮
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["btnJoin"] = hUI.button:new({ --作为按钮只是为了挂载子控件
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = swidth - 86,
				y = -6,
				model = "misc/chest/button_green_small.png", --"UI:PANEL_MENU_BTN_BIG",
				label = {x = 0, y = -0, text = hVar.tab_string["__TEXT_Guild_Join"], size = 24, font = hVar.FONTC, border = 1, RGB = {255, 255, 255},}, --"申请"
				w = 76,
				h = 40,
			})
			
			--不申请按钮
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["btnNotJoin"] = hUI.button:new({ --作为按钮只是为了挂载子控件
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = swidth - 86 - 90,
				y = -6,
				model = "misc/chest/button_yellow_small.png", --"UI:PANEL_MENU_BTN_BIG",
				label = {x = 0, y = -1, text = hVar.tab_string["__TEXT_Cancel"], size = 24, font = hVar.FONTC, border = 1, RGB = {255, 255, 255},}, --"拒绝"
				w = 76,
				h = 40,
			})
			
			--分割线条
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["line"] = hUI.button:new({ --作为按钮只是为了挂载子控件
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 362,
				y = -74,
				model = "misc/mask_white.png",
				w = 550,
				h = 2,
			})
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["line"].handle.s:setOpacity(88)
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["line"].handle.s:setColor(ccc3(0, 0, 0))
			
			--[[
			--最低注册天数文字
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["MinDayPrefixLabel"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 90,
				y = -82,
				align = "LT",
				font = hVar.FONTC,
				border = 1,
				--width = 500,
				text = hVar.tab_string["__TEXT_GROUP_INVITE_DAYMIN"] .. ":", --"最低注册天数"
				size = 18,
				RGB = {255, 255, 0,},
			})
			
			--最低注册天数值
			local minDayNameLength = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["MinDayPrefixLabel"]:getWH()
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["MinDayLabel"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 90 + minDayNameLength + 6,
				y = -82,
				align = "LT",
				font = hVar.FONTC,
				border = 1,
				width = 500,
				size = 18,
				text = dayMin,
				RGB = {255, 255, 0,},
			})
			]]
			
			--需要最低VIP等级文字
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["MinVIPPrefixLabel"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 90,
				y = -92,
				align = "LC",
				font = hVar.FONTC,
				border = 1,
				--width = 500,
				text = hVar.tab_string["__TEXT_GROUP_INVITE_VIPMIN"] .. ":", --"最低VIP"
				size = 20,
				RGB = {255, 255, 0,},
			})
			
			--最低VIP等级值
			local minVIPNameLength = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["MinVIPPrefixLabel"]:getWH()
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["MinDayLabel"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 90 + minVIPNameLength + 6,
				y = -92,
				align = "LC",
				font = hVar.FONTC,
				border = 1,
				width = 500,
				size = 20,
				text = vipMin,
				RGB = {255, 255, 0,},
			})
			
			--军团人数文字
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["GroupNumPrefixLabel"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 272,
				y = -92,
				align = "LC",
				font = hVar.FONTC,
				border = 1,
				--width = 500,
				text = hVar.tab_string["__TEXT_GROUP_INVITE_MEMBERNUM"] .. ":", --"军团人数"
				size = 20,
				RGB = {255, 255, 0,},
			})
			
			--军团人数值
			local groupNumNameLength = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["GroupNumPrefixLabel"]:getWH()
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["GroupNumLabel"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 272 + groupNumNameLength + 6,
				y = -92,
				align = "LC",
				font = hVar.FONTC,
				border = 1,
				width = 500,
				size = 20,
				text = tostring(groupMember)  .. "/" .. tostring(groupMemberMax),
				RGB = {255, 255, 0,},
			})
			
			--剩余时间文字
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["LeftTimePrefixLabel"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 470,
				y = -92,
				align = "LC",
				font = hVar.FONTC,
				border = 1,
				--width = 500,
				text = hVar.tab_string["__TEXT_PVP_LefeTime"] .. ":", --"剩余时间"
				size = 20,
				RGB = {255, 255, 0,},
			})
			
			--剩余时间文字
			local leftTimeLength = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["LeftTimePrefixLabel"]:getWH()
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["LeftTimeLabel"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 470 + leftTimeLength + 6,
				y = -92,
				align = "LC",
				font = hVar.FONTC,
				border = 1,
				width = 500,
				size = 20,
				text = "00:00:00",
				RGB = {255, 255, 0,},
			})
			
			--客户端的时间
			local localTime = os.time()
			--服务器的时间
			local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
			--转化为北京时间
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
			hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
			--计算倒计时
			local nExpireTime = hApi.GetNewDate(expire_time, "DAY", 0) --过期的时间戳
			local deltaSeconds = nExpireTime - hostTime --秒数
			if (deltaSeconds < 0) then
				deltaSeconds = 0
			end
			local hour = math.floor(deltaSeconds / 3600) --时
			local minute = math.floor((deltaSeconds - hour * 3600)/ 60) --分
			local second = deltaSeconds - hour * 3600 - minute * 60 --秒
			--拼接字符串
			local szHour = tostring(hour) --时(字符串)
			if (#szHour < 2) then
				szHour = "0" .. szHour
			end
			local szMinute = tostring(minute) --分(字符串)
			if (#szMinute < 2) then
				szMinute = "0" .. szMinute
			end
			local szSecond = tostring(second) --秒(字符串)
			if (#szSecond < 2) then
				szSecond = "0" .. szSecond
			end
			--倒计时
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["LeftTimeLabel"]:setText(szHour .. ":" .. szMinute .. ":" .. szSecond)
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 86
		elseif (msgType == hVar.MESSAGE_TYPE.INVITE_BATTLE) then --组队副本邀请消息
			--系统名称的颜色
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].handle.s:setColor(ccc3(255, 168, 128))
			
			--聊天内容
			local textSize = 22
			local contentLength = hApi.GetStringEmojiCNLength(content) --红包文字过长缩短字号
			if (contentLength > 15) then --超过15个汉字长度
				textSize = 20
			end
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 136,
				y = -22 + 10,
				z = 1,
				align = "LT",
				width = 295,
				text = content,
				--size = 20,
				size = textSize,
				border = 1,
				RGB = {255, 255, 0,},
			})
			if (uid == xlPlayer_GetUID()) then --我发送的消息
				if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
					local nx = BOARD_WIDTH - 48 - 30 - 8 - 430
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"]:setXY(nx, -22 + 10)
				end
			end
			
			--聊天冒泡蓝包
			local swidth = 420
			local sheight = 100 --加上按钮高度
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["bluePacket"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = swidth / 2 + 30 - 4,
				y = -sheight / 2 - 6,
				model = "misc/chest/chatbubble_battle.png",
				w = swidth,
				h = sheight,
				align = "MC",
			})
			if (uid == xlPlayer_GetUID()) then --我发送的消息
				if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
					local nx = BOARD_WIDTH - 48 - 30 - swidth / 2 - 30 - 8
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["bluePacket"].handle._n:setFlipX(true)
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["bluePacket"]:setXY(nx, -sheight / 2 - 6)
				end
			end
			
			--组队副本图标
			local icon = ""
			local scale = 1.0
			for k, v in pairs(hVar.tChatBattleIcon) do
				if (v.interactType == result) then --找到了
					icon = v.icon
					scale = v.scale
				end
			end
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["bluePacketIcon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = 92,
				y = -56,
				model = icon,
				scale = scale,
				align = "MC",
			})
			if (uid == xlPlayer_GetUID()) then --我发送的消息
				if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
					local nx = BOARD_WIDTH - 48 - 30 - 8 - 92
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["bluePacketIcon"]:setXY(nx, -56)
				end
			end
			
			--前往组队按钮
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["btnCouple"] = hUI.button:new({ --作为按钮只是为了挂载子控件
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = swidth / 2 + 33,
				y = -82,
				model = "misc/button_null.png", --"UI:PANEL_MENU_BTN_BIG",
				label = {x = 0, y = -1, z = 1, text = hVar.tab_string["__TEXT_InviteBattle"], size = 24, font = hVar.FONTC, border = 1, RGB = {255, 255, 255},}, --"前往组队"
				w = 120,
				h = 46,
			})
			local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/button_yellow_small.png", 0, 0, 110, 40, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["btnCouple"])
			if (uid == xlPlayer_GetUID()) then --我发送的消息
				if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
					local nx = BOARD_WIDTH - 48 - 30 - swidth / 2 - 33 - 14
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["btnCouple"]:setXY(nx, -82)
				end
			end
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 38 --加上按钮高度
			
			--绘制称号（军团发红包消息）
			if (championId > 0) then
				--称号图标
				local tRoleChampion = hVar.tab_rolechampion[championId]
				if (tRoleChampion == nil) then
					tRoleChampion = hVar.tab_rolechampion[0]
				end
				local iconW = tRoleChampion.width
				local iconH = tRoleChampion.height
				local width = 52 * iconW / iconH
				local height = 52
				local posx = iconW/2 + 8
				local posy = 0
				if (height > width) then
					posy = -(height - width) / 2
				end
				--print(posy)
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleChampion"] = hUI.image:new({
					parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
					model = tRoleChampion.icon,
					x = posx,
					y = posy,
					w = width,
					h = height,
				})
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					if (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) and (msgType ~= hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --不是红发包类型的消息
						local nx = BOARD_WIDTH - 40 - 48
						_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleChampion"]:setXY(nx - posx, posy)
					end
				end
				
				--重置一些控件的y坐标
				--图标
				local dx = 0
				local dy = -14
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					--
				end
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["roleIcon"]:setXY(px + dx, py + dy)
				--玩家名
				local dx = width + 0
				local dy = -18
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					dx = -dx
				end
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["playerName"]:setXY(px + dx, py + dy)
				--会长权限
				if _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"] then
					local dx = width + 0
					local dy = -18 + 2
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						dx = -dx
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["leaderIcon"]:setXY(px + dx, py + dy)
				end
				--聊天龙王
				if _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"] then
					local dx = width + 0
					local dy = -18 + 2
					if (uid == xlPlayer_GetUID()) then --我发送的消息
						dx = -dx
					end
					local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"].data.y
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["dragonIcon"]:setXY(px + dx, py + dy)
				end
				--日期
				local dx = width + 0
				local dy = -18
				if (uid == xlPlayer_GetUID()) then --我发送的消息
					dx = -dx
				end
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["date"]:setXY(px + dx, py + dy)
				--蓝包图片
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["bluePacket"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["bluePacket"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["bluePacket"]:setXY(px + dx, py + dy)
				--蓝包文字
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"]:setXY(px + dx, py + dy)
				--组队图标
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["bluePacketIcon"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["bluePacketIcon"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["bluePacketIcon"]:setXY(px + dx, py + dy)
				--组队按钮
				local dx = 0
				local dy = -height/2 - 2
				local px, py = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["btnCouple"].data.x, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["btnCouple"].data.y
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["btnCouple"]:setXY(px + dx, py + dy)
				
				--存储此条聊天记录的高度
				_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = _frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight - dy
			end
		else --其他类型
			--聊天内容
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				font = hVar.FONTC,
				x = 54 - 20,
				y = -15 + 10,
				z = 1,
				align = "LT",
				width = 594, --27个字
				text = hVar.tab_string["__TEXT_Cant_ShowMessageType"], --"【收到不支持的消息类型，暂无法显示】"
				size = 22,
				border = 1,
				RGB = {236, 236, 236,},
			})
			if (uid == xlPlayer_GetUID()) then --我发送的消息
				local length = hApi.GetStringEmojiCNLength(content) --处理表情，中文长度
				if (length > 27) then
					length = 27
				end
				local nx = BOARD_WIDTH - 40 - 48 - 54 + 20 - 22 * length
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"]:setXY(nx, -15)
			end
			
			local wh = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["content"].handle.s:getContentSize()
			local swidth = 550 + 28
			local sheight = wh.height + 20 - 16
			
			--存储此条聊天记录的高度
			_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = WEAPON_HEIGHT + sheight - 42
		end
		
		--可能存在滑动，校对后一个控件的相对位置
		if _frmNode.childUI["DLCMapInfoNode" .. (index + 1)] then
			--实际相对距离
			local nextX = _frmNode.childUI["DLCMapInfoNode" .. (index + 1)].data.x
			local nextY = _frmNode.childUI["DLCMapInfoNode" .. (index + 1)].data.y
			--local nextChatHeight = _frmNode.childUI["DLCMapInfoNode" .. (index + 1)].data.chatHeight
			
			--理论相对距离
			local ctrli = _frmNode.childUI["DLCMapInfoNode" .. index]
			local thisX = nextX
			local thisY = nextY + ctrli.data.chatHeight
			ctrli.handle._n:setPosition(thisX, thisY)
			ctrli.data.x = thisX
			ctrli.data.y = thisY
		elseif _frmNode.childUI["DLCMapInfoNode" .. (index - 1)] then --前一个
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
		
		--print(index, _frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight)
		--对齐到底部
		if bBottom then
			local ctrli = _frmNode.childUI["DLCMapInfoNode" .. index]
			local btnN_cy = ctrli.data.chatHeight + WEAPON_HEIGHT / 2 - (hVar.SCREEN.h + 1) + 2 * iPhoneX_HEIGHT --ctrli.data.chatHeight + WEAPON_HEIGHT / 2 - (hVar.SCREEN.h + 1) + 2 * iPhoneX_HEIGHT
			
			if (chatType == hVar.CHAT_TYPE.WORLD) then --世界聊天频道
				--print(btnN_cy)
			elseif (chatType == hVar.CHAT_TYPE.INVITE) then --邀请频道
				btnN_cy = btnN_cy - 54
				--print(btnN_cy)
			elseif (chatType == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
				--
			elseif (chatType == hVar.CHAT_TYPE.GROUP) then --军团频道
				--
			elseif (chatType == hVar.CHAT_TYPE.COUPLE) then --组队频道
				--
			end
			
			ctrli.handle._n:setPosition(ctrli.data.x, btnN_cy)
			ctrli.data.y = btnN_cy
		end
	end
	
	--函数：异步创建单条聊天信息
	on_create_single_message_UI_Async = function(tMsg, index)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local msgId = tMsg.id --消息id
		local chatType = tMsg.chatType --聊天频道
		local msgType = tMsg.msgType --消息类型
		local uid = tMsg.uid --消息发送者uid
		local name = tMsg.name --玩家名
		local channelId = tMsg.channelId --渠道号
		local vip = tMsg.vip --vip等级
		local borderId = tMsg.borderId --边框id
		local iconId = tMsg.iconId --头像id
		local championId = tMsg.championId --称号id
		local leaderId = tMsg.leaderId --会长权限
		local dragonId = tMsg.dragonId --聊天龙王id
		local headId = tMsg.headId --头衔id
		local lineId = tMsg.lineId --线索id
		local date = tMsg.date --日期
		local content = tMsg.content --聊天内容
		local touid = tMsg.touid --接收者uid
		local result = tMsg.result --可交互类型消息的操作结果
		local resultParam = tMsg.resultParam --可交互类型消息的参数
		local redPacketParam = tMsg.redPacketParam --红包消息参数
		
		--!!!! edit by mj 临时去掉会长权限/称号
		leaderId = 0
		championId = 0

		--仅创建一个子节点
		--消息父控件
		local pClipNode = nil
		if (chatType == hVar.CHAT_TYPE.WORLD) then --世界聊天频道
			pClipNode = _BTC_pClipNodeWorld
		elseif (chatType == hVar.CHAT_TYPE.INVITE) then --邀请频道
			pClipNode = _BTC_pClipNodeInvite
		elseif (chatType == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			pClipNode = _BTC_pClipNodePrivate
		elseif (chatType == hVar.CHAT_TYPE.GROUP) then --军团频道
			pClipNode = _BTC_pClipNodeGroup
		elseif (chatType == hVar.CHAT_TYPE.COUPLE) then --组队频道
			pClipNode = _BTC_pClipNodeCouple
		end
		local nodePosY = 0
		if (chatType == hVar.CHAT_TYPE.WORLD) then --世界聊天频道
			nodePosY = -94
		elseif (chatType == hVar.CHAT_TYPE.INVITE) then --邀请频道
			nodePosY = -94 - 54
		elseif (chatType == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			nodePosY = -264
		elseif (chatType == hVar.CHAT_TYPE.GROUP) then --军团频道
			nodePosY = -94
		elseif (chatType == hVar.CHAT_TYPE.COUPLE) then --组队频道
			nodePosY = -94
		end
		_frmNode.childUI["DLCMapInfoNode" .. index] = hUI.button:new({
			--parent = _BTC_pClipNodeWorld,
			parent = pClipNode,
			--model = "misc/mask.png",
			model = -1,
			x = 46,
			y = nodePosY - (index - 1) * WEAPON_HEIGHT, --nodePosY - iPhoneX_HEIGHT - (index - 1) * WEAPON_HEIGHT,
			--z = 1,
			w = 48,
			h = 48,
		})
		
		--_frmNode.childUI["DLCMapInfoNode" .. index].handle.s:setOpacity(0) --默认不显示（只用于响应事件，不显示）
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoNode" .. index
		_frmNode.childUI["DLCMapInfoNode" .. index].data.msgId = msgId --存储控件的msgId
		_frmNode.childUI["DLCMapInfoNode" .. index].data.uid = uid --存储控件的uid
		
		--默认高度95
		_frmNode.childUI["DLCMapInfoNode" .. index].data.chatHeight = 95
		
		--存储异步待绘制消息列表
		current_async_paint_list[index] = tMsg
	end
	
	--函数：获得好友第一个控件和最后一个控件距离最左面边界线和最右面边界线的距离
	getLeftRightOffset = function()
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--第一个DLC地图面板的数据
		local DLCMapInfoBtn1 = _frmNode.childUI["DLCMapInfoNodeFriend1"]
		local btn1_cx, btn1_cy = 0, 0 --第一个DLC地图面板中心点位置
		local btn1_lx = 0 --第一个DLC地图面板最上侧的x坐标
		local delta1_lx = 0 --第一个DLC地图面板距离上侧边界的距离
		--print(DLCMapInfoBtn1)
		if DLCMapInfoBtn1 then
			btn1_cx, btn1_cy = DLCMapInfoBtn1.data.x, DLCMapInfoBtn1.data.y --第一个DLC地图面板中心点位置
			btn1_lx = btn1_cx + WEAPON_WIDTH / 2 --第一个DLC地图面板最左侧的x坐标
			delta1_lx = btn1_lx - 133 --第一个DLC地图面板距离左侧边界的距离
		end
		
		--最后一个DLC地图面板的数据
		local DLCMapInfoBtnN = _frmNode.childUI["DLCMapInfoNodeFriend" .. current_DLCMap_friend_max_num]
		local btnN_cx, btnN_cy = 0, 0 --最后一个DLC地图面板中心点位置
		local btnN_rx = 0 --最后一个DLC地图面板最下侧的x坐标
		local deltNa_rx = 0 --最后一个DLC地图面板距离下侧边界的距离
		if DLCMapInfoBtnN then
			btnN_cx, btnN_cy = DLCMapInfoBtnN.data.x, DLCMapInfoBtnN.data.y --最后一个DLC地图面板中心点位置
			btnN_rx = btnN_cx - WEAPON_WIDTH / 2 --最后一个DLC地图面板最右侧的x坐标
			deltNa_rx = btnN_rx - 592 --最后一个DLC地图面板距离右侧边界的距离
			--print("delta1_lx, deltNa_rx", delta1_lx, deltNa_rx)
		end
		
		return delta1_lx, deltNa_rx
	end
	
	--函数：点击军团邀请函的申请按钮
	OnClickInviteJoinBtn = function(index)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local ctrli = _frmNode.childUI["DLCMapInfoNode" .. index]
		if ctrli then
			local msgId = ctrli.data.msgId
			if (msgId > 0) then
				local tChatMsg = current_chat_msg_hostory_cache_invite[msgId]
				if tChatMsg then
					local redPacketParam = tChatMsg.redPacketParam --军团邀请函消息参数
					if redPacketParam then
						local inviteGroupId = redPacketParam.inviteGroupId --军团邀请函唯一id
						if (inviteGroupId > 0) then
							--检测是否通关"下邳之战"
							local isFinishMap19 = LuaGetPlayerMapAchi("world/td_109_xpzz", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第19关是否解锁
							if (isFinishMap19 == 0) then
								--冒字
								--local strText = "通关【下邳之战】后，才能解锁军团！" --language
								local strText = hVar.tab_string["__TEXT_MOLONGBAOKU_archiLock"] --language
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
							
							--如果已加入了军团不能申请
							if (current_msgGroupId > 0) then
								--冒字
								--local strText = "您已加入了军团" --language
								local strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_GROUP_JOIN_GROUP"] --language
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
							
							--添加查询超时一次性timer
							hApi.addTimerOnce("__ONCE_CHAT_TIMEOUNT_TIMER__", 5000, refresh_chatnet_timeout_timer)
							
							--挡操作
							hUI.NetDisable(30000)
							
							--请求申请邀请函
							SendGroupCmdFunc["group_invite_join"](inviteGroupId)
						else
							--冒字
							--local strText = "参数不合法" --language
							local strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] --language
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
			end
		end
	end
	
	--函数：点击军团邀请函的不申请按钮
	OnClickInviteNotJoinBtn = function(index)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local ctrli = _frmNode.childUI["DLCMapInfoNode" .. index]
		if ctrli then
			local msgId = ctrli.data.msgId
			if (msgId > 0) then
				local tChatMsg = current_chat_msg_hostory_cache_invite[msgId]
				if tChatMsg then
					local redPacketParam = tChatMsg.redPacketParam --军团邀请函消息参数
					if redPacketParam then
						local inviteGroupId = redPacketParam.inviteGroupId --军团邀请函唯一id
						if (inviteGroupId > 0) then
							--本地标记已处理此军团邀请函消息
							LuaAddInviteGroupId(g_curPlayerName, msgId)
							
							--模拟触发删除消息
							on_receive_remove_chat_message_event(msgId)
						else
							--冒字
							--local strText = "参数不合法" --language
							local strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] --language
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
			end
		end
	end
	
	--函数：点击组队邀请的前往组队按钮
	OnClickInviteBattleCoupleBtn = function(index)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--如果当前在游戏内，不能操作
		local world = hGlobal.WORLD.LastWorldMap
		if world then
			--冒字
			--local strText = "您正在游戏中不能加入组队！" --language
			local strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NOCOUPLE_INGAME"] --language
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
		
		--如果配置不允许前往组队，那么提示
		if (type(current_tCallback) == "table") then
			if (current_tCallback.bEnableBattleInvite == false) then
				--冒字
				local strText = current_tCallback.strDisableBattleInviteString
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
		end
		
		--检测作弊
		local cheatflag = LuaGetCheatFlag()
		local userID = xlPlayer_GetUID()
		if (cheatflag == 1) then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_WanJia"].."ID:"..userID.."\n"..hVar.tab_string["__TEXT_cheatPlayer"],{
				font = hVar.FONTC,
				ok = function()
					xlExit()
				end,
			})
			return
		end
		
		--检测本地存档是否有作弊行为
		hApi.CheckPlayerCheat()
		
		--"背包已满，无法进入房间"
		if (LuaCheckPlayerBagCanUse() == 0) then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_BAGLISTISFULL7"], {
				font = hVar.FONTC,
				ok = function()
					--
				end,
			})
			return
		end
		
		--检测临时背包是否有道具
		if (LuaCheckGiftBag() == 1) then
			--"临时背包有道具待领取，请领完后再操作"
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_BAGLISTISFULL11"], {
				font = hVar.FONTC,
				ok = function()
					--
				end,
			})
			return
		end
		
		local msgId = 0 --消息id
		local result = 0 --可交互类型消息的操作结果
		local resultParam = 0 --可交互类型消息的参数
		local ctrli = _frmNode.childUI["DLCMapInfoNode" .. index]
		if ctrli then
			local msgId_i = ctrli.data.msgId
			if (msgId_i > 0) then
				local tChatMsg = current_chat_msg_hostory_cache_invite[msgId_i]
				if tChatMsg then
					msgId = msgId_i --消息id
					result = tChatMsg.result --可交互类型消息的操作结果
					resultParam = tChatMsg.resultParam --可交互类型消息的参数
				end
			end
		end
		
		if (result == 0) then
			--冒字
			--local strText = "参数不合法" --language
			local strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] --language
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
		
		if (resultParam == 0) then
			--冒字
			--local strText = "参数不合法" --language
			local strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NO_VALID_PARAM"] --language
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
		
		--如果该组队副本解锁需要的地图未通关，那么提示
		--组队副本解锁条件
		local unlockMap = ""
		local unlockText = ""
		local isgroup = 0
		for k, v in pairs(hVar.tChatBattleIcon) do
			if (v.interactType == result) then --找到了
				unlockMap = v.unlockMap
				unlockText = v.unlockText
				isgroup = v.isgroup
			end
		end
		--是否通关指定地图
		local isFinishMap = LuaGetPlayerMapAchi(unlockMap, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --是否解锁
		if (isFinishMap == 0) then
			--冒字
			local strText = hVar.tab_string[unlockText]
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
		
		--如果该组队副本是军团副本，那么需要玩家已加入军团
		if (isgroup == 1) then
			if (current_msgGroupId == 0) then
				--冒字
				--local strText = "您还未加入军团不能挑战此副本" --language
				local strText = hVar.tab_string["__GROUP_SERVER_ERROR_TYPE_NOCOUPLE_NOTINGROUP"] --language
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
			
		end
		
		--通过校验
		
		--存储当前请求组队副本的房间消息id
		current_DLCMap_roomid = msgId
		
		--发送pvp连接请求
		if (Pvp_Server:GetState() == 1) then --不重复登入
			--模拟触发连接结果回调
			on_receive_pvp_connect_back_event_chat(1)
		else
			--连接
			Pvp_Server:Connect(Pvp_Server.SERVERTYPE_COUPLEBATTLE)
		end
	end
	
	--函数：创建单个私聊好友头像列表
	on_create_single_friend_UI = function(tFriend, index)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local touid = tFriend.touid --好友uid
		local online = tFriend.online --好友是否在线
		local toname = tFriend.toname --好友玩家名
		local tochannelId = tFriend.tochannelId --好友渠道号
		local tovip = tFriend.tovip --好友vip等级
		local toborderId = tFriend.toborderId --好友边框id
		local toiconId = tFriend.toiconId --好友头像id
		local tochampionId = tFriend.tochampionId --好友称号id
		local toleaderId = tFriend.toleaderId --好友会长权限
		local todragonId = tFriend.todragonId --好友聊天龙王id
		local toheadId = tFriend.toheadId --好友头衔id
		local tolineId = tFriend.tolineId --好友线索id
		
		--!!!! edit by mj 临时去掉会长权限/称号
		toleaderId = 0
		tochampionId = 0

		--好友父控件
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index] = hUI.button:new({
			parent = _BTC_pClipNodePrivate,
			model = "misc/mask.png",
			--model = -1,
			x = 71 + (index - 1) * WEAPON_WIDTH,
			y = -122,
			--z = 1,
			z = 100,
			w = PRVAITE_FRIEND_WH_BIG,
			h = PRVAITE_FRIEND_WH_BIG,
		})
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].handle.s:setOpacity(0) --默认不显示（只用于响应事件，不显示）
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoNodeFriend" .. index
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].data.touid = touid --存储控件的touid
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].data.online = online --好友是否在线
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].data.toname = toname --存储控件的toname
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].data.tochannelId = tochannelId --存储控件的tochannelId
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].data.tovip = tovip --存储控件的tovip
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].data.toborderId = toborderId --存储控件的toborderId
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].data.toiconId = toiconId --存储控件的toiconId
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].data.tochampionId = tochampionId --存储控件的tochampionId
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].data.toleaderId = toleaderId --存储控件的toleaderId
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].data.todragonId = todragonId --存储控件的todragonId
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].data.toheadId = toheadId --存储控件的toheadId
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].data.tolineId = tolineId --存储控件的tolineId
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].data.selected = 0 --存储控件是否被选中
		
		--好友头像图标
		local tRoleIcon = hVar.tab_roleicon[toiconId]
		if (tRoleIcon == nil) then
			tRoleIcon = hVar.tab_roleicon[0]
		end
		local iconW = tRoleIcon.width
		local iconH = tRoleIcon.height
		local width = PRVAITE_FRIEND_WH * iconW / iconH
		local height = PRVAITE_FRIEND_WH
		local posx = 0
		local posy = 0
		if (height > width) then
			posy = -(height - width) / 2
		end
		--好友边框
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].childUI["roleIconBorder"] = hUI.image:new({
			parent = _frmNode.childUI["DLCMapInfoNodeFriend" .. index].handle._n,
			model = "misc/chest/purchase_border.png",
			x = posx,
			y = posy,
			w = width + 8,
			h = height + 8,
		})
		
		--好友头像图标
		--print(posy)
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].childUI["roleIcon"] = hUI.image:new({
			parent = _frmNode.childUI["DLCMapInfoNodeFriend" .. index].handle._n,
			model = tRoleIcon.icon,
			x = posx,
			y = posy,
			w = width,
			h = height,
		})
		
		--好友玩家名
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].childUI["playerName"] = hUI.label:new({
			parent = _frmNode.childUI["DLCMapInfoNodeFriend" .. index].handle._n,
			font = hVar.FONTC,
			x = 0,
			y = -32,
			align = "MC",
			size = 14,
			text = toname,
			--text = "[" .. index .. "]",
			border = 1,
			width = 500,
			RGB = {255, 255, 212,},
		})
		
		--好友在线标记
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].childUI["playerOnline"] = hUI.label:new({
			parent = _frmNode.childUI["DLCMapInfoNodeFriend" .. index].handle._n,
			font = hVar.FONTC,
			x = 20,
			y = 28,
			align = "MC",
			size = 16,
			text = hVar.tab_string["__TEXT_PVP_Online"], --"在线",
			border = 1,
			width = 500,
			RGB = {0, 255, 0,},
		})
		if (online == 0) then --不在线
			_frmNode.childUI["DLCMapInfoNodeFriend" .. index].childUI["playerOnline"].handle._n:setVisible(false)
		end
		
		--好友提示有新消息的叹号
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].childUI["NoteJianTou"] = hUI.image:new({
			parent = _frmNode.childUI["DLCMapInfoNodeFriend" .. index].handle._n,
			model = "UI:TaskTanHao",
			x = 28,
			y = 30,--40,
			z = 3,
			w = 28,
			h = 28,
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
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].childUI["NoteJianTou"].handle.s:runAction(CCRepeatForever:create(sequence))
		_frmNode.childUI["DLCMapInfoNodeFriend" .. index].childUI["NoteJianTou"].handle._n:setVisible(false) --一开始不显示
	end
	
	--函数：选中了某个私聊好友
	OnSelectedPrivateFriend = function(index)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local ctrlI = _frmNode.childUI["DLCMapInfoNodeFriend" .. index]
		if ctrlI then
			--不重复选中同一个人
			local selected = ctrlI.data.selected
			if (selected == 0) then
				--将其他按钮恢复原大小
				for i = 1, current_DLCMap_friend_max_num, 1 do
					local ctrl_i = _frmNode.childUI["DLCMapInfoNodeFriend" .. i]
					if ctrl_i then
						if (ctrl_i.data.selected == 1) then
							ctrl_i.data.selected = 0
							ctrl_i.handle._n:setScale(1.0)
							hApi.safeRemoveT(ctrl_i.childUI, "selectedbox")
						end
					end
				end
				
				--隐藏此按钮的叹号
				--ctrlI.childUI["NoteJianTou"].handle._n:setVisible(false)
				
				--标记选中
				ctrlI.data.selected = 1
				
				--将此按钮变大
				ctrlI.handle._n:setScale(PRVAITE_FRIEND_WH_BIG / PRVAITE_FRIEND_WH)
				
				--添加选中框
				hApi.safeRemoveT(ctrlI.childUI, "selectedbox")
				ctrlI.childUI["selectedbox"] = hUI.node:new({ --作为按钮是为了挂载子控件
					parent = ctrlI.handle._n,
					--model = "misc/chest/purchase_border.png",
					model = -1,
					x = 0,
					y = 0,
					w = 1,
					h = 1,
				})
				local s9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TaskSelectBG.png", 0, 0, PRVAITE_FRIEND_WH_BIG - 6, PRVAITE_FRIEND_WH_BIG - 6, ctrlI.childUI["selectedbox"])
				
				--显示正在私聊的好友的提示界面
				_frmNode.childUI["DLCMapInfoNowFriendBG"].handle._n:setVisible(true)
				_frmNode.childUI["DLCMapInfoNowFriendLabel"].handle._n:setVisible(true)
				_frmNode.childUI["DLCMapInfoNowFriendCloseBtn"]:setstate(1)
				
				--设置好友名
				local tFriend = nil
				for i = 1, #current_msgPrivate_friend_chat_list, 1 do
					local tFriend_i = current_msgPrivate_friend_chat_list[i]
					if (tFriend_i.touid == ctrlI.data.touid) then --找到了
						tFriend = tFriend_i
						break
					end
				end
				
				if tFriend then
					local touid = tFriend.touid --好友uid
					local online = tFriend.online --好友是否在线
					local toname = tFriend.toname --好友玩家名
					local tochannelId = tFriend.tochannelId --好友渠道号
					local tovip = tFriend.tovip --好友vip等级
					local toborderId = tFriend.toborderId --好友边框id
					local toiconId = tFriend.toiconId --好友头像id
					local tochampionId = tFriend.tochampionId --好友称号id
					local toleaderId = tFriend.toleaderId --好友会长权限
					local todragonId = tFriend.todragonId --好友聊天龙王id
					local toheadId = tFriend.toheadId --好友头衔id
					local tolineId = tFriend.tolineId --好友线索id
					_frmNode.childUI["DLCMapInfoNowFriendLabel"]:setText(string.format(hVar.tab_string["__TEXT_PrivateChatting"], toname)) --"与" .. toname .. "聊天中..."
				else
					local toname = "???"
					_frmNode.childUI["DLCMapInfoNowFriendLabel"]:setText(string.format(hVar.tab_string["__TEXT_PrivateChatting"], toname)) --"与" .. toname .. "聊天中..."
					
					--冒字
					--local strText = "未知好友！" --language
					local strText = hVar.tab_string["__TEXT_CHAT_INVALID_UID"] --language
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
			end
		end
	end
	
	--函数：收到添加单个私聊好友事件
	on_add_private_friend_event = function(tFriend)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--移除超时检测timer
		hApi.clearTimer("__ONCE_CHAT_TIMEOUNT_TIMER__")
		
		--取消挡操作
		--hUI.NetDisable(0)
		--隐藏菊花
		if _frmNode.childUI["waiting"] then
			_frmNode.childUI["waiting"]:setstate(-1) --已联网不显示菊花
		end
		
		if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
			--
		elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
			--
		elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			--检测是否此好友已存在
			local bExisted = false
			for i = 1, #current_msgPrivate_friend_chat_list, 1 do
				local tFriend_i = current_msgPrivate_friend_chat_list[i]
				local touid = tFriend_i.touid --好友uid
				local online = tFriend_i.online --好友是否在线
				local toname = tFriend_i.toname --好友玩家名
				local tochannelId = tFriend_i.tochannelId --好友渠道号
				local tovip = tFriend_i.tovip --好友vip等级
				local toborderId = tFriend_i.toborderId --好友边框id
				local toiconId = tFriend_i.toiconId --好友头像id
				local tochampionId = tFriend_i.tochampionId --好友称号id
				local toleaderId = tFriend_i.toleaderId --好友会长权限
				local todragonId = tFriend_i.todragonId --好友聊天龙王id
				local toheadId = tFriend_i.toheadId --好友头衔id
				local tolineId = tFriend_i.tolineId --好友线索id
				
				--!!!! edit by mj，临时去掉会长权限/称号
				toleaderId = 0
				tochampionId = 0

				if (touid == tFriend.touid) then --找到了
					bExisted = true
					break
				end
			end
			
			--不存在，新加私聊好友到末尾
			if (not bExisted) then
				local i = current_DLCMap_friend_max_num + 1
				
				--存储数据
				current_msgPrivate_friend_chat_list[#current_msgPrivate_friend_chat_list+1] = tFriend
				
				--创建单条好友信息
				on_create_single_friend_UI(tFriend, i)
				
				--标记私聊好友数量加1
				current_DLCMap_friend_max_num = current_DLCMap_friend_max_num + 1
				
				--显示此头像的新消息提示
				local ctrl_i = _frmNode.childUI["DLCMapInfoNodeFriend" .. current_DLCMap_friend_max_num]
				--ctrl_i.childUI["NoteJianTou"].handle._n:setVisible(true)
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
			--
		elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
			--
		end
		
		--更新叹号提示
		on_update_notice_tanhao()
	end
	
	--函数：收到删除单个私聊好友事件
	on_remove_private_friend_event = function(friendUid)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("收到删除单个私聊好友事件=", friendUid)
		
		--移除超时检测timer
		hApi.clearTimer("__ONCE_CHAT_TIMEOUNT_TIMER__")
		
		--取消挡操作
		--hUI.NetDisable(0)
		--隐藏菊花
		if _frmNode.childUI["waiting"] then
			_frmNode.childUI["waiting"]:setstate(-1) --已联网不显示菊花
		end
		
		if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
			--不处理
			--...
		elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
			--不处理
			--...
		elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			--找到此好友所在的控件
			local ctrlI = nil
			local ctrlIdx = 0
			for i = 1, current_DLCMap_friend_max_num, 1 do
				local ctrli = _frmNode.childUI["DLCMapInfoNodeFriend" .. i]
				if (ctrli.data.touid == friendUid) then
					ctrlI = ctrli --找到了
					ctrlIdx = i
					break
				end
			end
			
			--不存在的uid，不处理
			if (ctrlI == nil) then
				return
			end
			
			--print("ctrlI=", ctrlI)
			
			--删除此控件
			hApi.safeRemoveT(_frmNode.childUI, "DLCMapInfoNodeFriend" .. ctrlIdx)
			--print("删除控件", ctrlIdx)
			
			--后续控件索引位置依次前移
			if (ctrlIdx < current_DLCMap_friend_max_num) then
				for j = ctrlIdx + 1, current_DLCMap_friend_max_num, 1 do
					local ctrlj = _frmNode.childUI["DLCMapInfoNodeFriend" .. j]
					_frmNode.childUI["DLCMapInfoNodeFriend" .. (j - 1)] = ctrlj
					
					--调整后续控件的坐标
					local posXj = ctrlj.data.x
					local posYj = ctrlj.data.y
					--理论相对距离
					local thisXj = posXj - WEAPON_WIDTH
					local thisYj = posYj
					ctrlj.handle._n:setPosition(thisXj, thisYj)
					ctrlj.data.x = thisXj
					ctrlj.data.y = thisYj
				end
			end
			
			--删除最后一个控件标记
			_frmNode.childUI["DLCMapInfoNodeFriend" .. current_DLCMap_friend_max_num] = nil
			
			--删除 rightRemoveFrmList 存储标记
			for j = 1, #rightRemoveFrmList, 1 do
				if (rightRemoveFrmList[j] == ("DLCMapInfoNodeFriend" .. current_DLCMap_friend_max_num)) then
					--print("删除 rightRemoveFrmList 存储标记", j, rightRemoveFrmList[j])
					table.remove(rightRemoveFrmList, j)
					break
				end
			end
			
			--删除存储数据
			table.remove(current_msgPrivate_friend_chat_list, ctrlIdx)
			
			--标记总数量减1
			current_DLCMap_friend_max_num = current_DLCMap_friend_max_num - 1
			
			--删除当前全部私聊信息
			for i = current_DLCMap_max_num, 1, -1 do
				--删除控件
				hApi.safeRemoveT(_frmNode.childUI, "DLCMapInfoNode" .. i)
				--print("删除控件", i)
				
				--删除控件标记
				_frmNode.childUI["DLCMapInfoNode" .. i] = nil
				
				--删除 rightRemoveFrmList 存储标记
				for j = 1, #rightRemoveFrmList, 1 do
					if (rightRemoveFrmList[j] == ("DLCMapInfoNode" .. current_DLCMap_max_num)) then
						--print("删除 rightRemoveFrmList 存储标记", j, rightRemoveFrmList[j])
						table.remove(rightRemoveFrmList, j)
						break
					end
				end
				
				--标记总数量减1
				current_DLCMap_max_num = current_DLCMap_max_num - 1
			end
			
			--删除新消息提示
			onRemoveNewMessageHint()
			
			--选中前一个好友
			if (current_DLCMap_friend_max_num > 0) then
				--添加查询超时一次性timer
				hApi.addTimerOnce("__ONCE_CHAT_TIMEOUNT_TIMER__", 5000, refresh_chatnet_timeout_timer)
				
				--请求查询与此好友的聊天id列表
				local newCtrlIdx = ctrlIdx - 1
				if (newCtrlIdx == 0) then --之前选中第一个，这次也选中第一个
					newCtrlIdx = 1
				end
				local friendUid = _frmNode.childUI["DLCMapInfoNodeFriend" .. newCtrlIdx].data.touid
				SendGroupCmdFunc["chat_get_id_list"](current_chat_type, friendUid)
			else
				--清空私聊好友
				current_msg_private_friend_last_uid = 0
				
				--隐藏正在私聊的好友的提示界面
				_frmNode.childUI["DLCMapInfoNowFriendBG"].handle._n:setVisible(false)
				_frmNode.childUI["DLCMapInfoNowFriendLabel"].handle._n:setVisible(false)
				_frmNode.childUI["DLCMapInfoNowFriendCloseBtn"]:setstate(-1)
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
			--不处理
			--...
		elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
			--不处理
			--...
		end
		
		--更新叹号提示
		on_update_notice_tanhao()
	end
	
	--函数：点击私聊验证按钮
	OnClickPrivateInviteBtn = function(selectTipIdx, inviteTag)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--私聊消息i
		local ctrlI = _frmNode.childUI["DLCMapInfoNode" .. selectTipIdx]
		if ctrlI then
			--添加查询超时一次性timer
			hApi.addTimerOnce("__ONCE_CHAT_TIMEOUNT_TIMER__", 5000, refresh_chatnet_timeout_timer)
			
			--请求私聊验证
			local msgId = ctrlI.data.msgId
			local touid = ctrlI.data.uid
			--print(selectTipIdx, inviteTag)
			SendGroupCmdFunc["chat_private_invite_op"](msgId, touid, inviteTag)
		end
	end
	
	--函数：点击删除私聊好友按钮
	OnClickDeleteInviteBtn = function(friendUid)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--删除上一次的界面
		if hGlobal.UI.GameCoinTipFrame then
			hGlobal.UI.GameCoinTipFrame:del()
			hGlobal.UI.GameCoinTipFrame = nil
		end
		
		--找到此好友所在的控件
		local ctrlI = nil
		for i = 1, current_DLCMap_friend_max_num, 1 do
			local ctrli = _frmNode.childUI["DLCMapInfoNodeFriend" .. i]
			if ctrli then
				if (ctrli.data.touid == friendUid) then
					ctrlI = ctrli --找到了
					break
				end
			end
		end
		
		--不存在的uid，不处理
		if (ctrlI == nil) then
			return
		end
		
		--创建息删除好友界面tip
		hGlobal.UI.GameCoinTipFrame = hUI.frame:new({
			x = hVar.SCREEN.w / 2,
			y = hVar.SCREEN.h / 2,
			w = 550,
			h = 300,
			z = hZorder.CommonUIFrame + 2,
			show = 1,
			--dragable = 2,
			dragable = 2,
			--buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			--border = "UI:TileFrmBasic_thin",
			--background = "ui/TacticBG.png",
			border = 0,
			background = -1,
			
			--点击事件（有可能在控件外部点击）
			codeOnDragEx = function(touchX, touchY, touchMode)
				--print("codeOnDragEx", touchX, touchY, touchMode)
				if (touchMode == 0) then --按下
					--
				elseif (touchMode == 1) then --滑动
					--
				elseif (touchMode == 2) then --抬起
					--在本界面之外点击，清除本界面
					if hGlobal.UI.GameCoinTipFrame then
						local cx = hGlobal.UI.GameCoinTipFrame.data.x --中心点x坐标
						local cy = hGlobal.UI.GameCoinTipFrame.data.y --中心点y坐标
						local cw, ch = hGlobal.UI.GameCoinTipFrame.data.w, hGlobal.UI.GameCoinTipFrame.data.h
						local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
						local rx, ry = lx + cw, ly + ch --最右下角坐标
						--print(lx, rx)
						--print(rx, ry)
						--检测是否点到了本面板之内
						if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
							--
						else
							--清除技能说明面板
							hGlobal.UI.GameCoinTipFrame:del()
							hGlobal.UI.GameCoinTipFrame = nil
						end
					end
					--print("点击事件（有可能在控件外部点击）")
				end
			end,
		})
		hGlobal.UI.GameCoinTipFrame:active()
		
		local _TacticTipParent = hGlobal.UI.GameCoinTipFrame.handle._n
		local _TacticTipChildUI = hGlobal.UI.GameCoinTipFrame.childUI
		
		local _offX = 0
		local _offY = 0
		
		--弹出对话框确认
		local MsgSelections = nil
		MsgSelections = {
			style = "normal2",--"mini",
			select = 0,
			ok = function()
				--关闭本页面
				if hGlobal.UI.GameCoinTipFrame then
					hGlobal.UI.GameCoinTipFrame:del()
					hGlobal.UI.GameCoinTipFrame = nil
				end
				
				--添加查询超时一次性timer
				hApi.addTimerOnce("__ONCE_CHAT_TIMEOUNT_TIMER__", 5000, refresh_chatnet_timeout_timer)
				
				--请求删除此好友
				SendGroupCmdFunc["chat_private_delete"](friendUid)
			end,
			cancel = function()
				--关闭本页面
				if hGlobal.UI.GameCoinTipFrame then
					hGlobal.UI.GameCoinTipFrame:del()
					hGlobal.UI.GameCoinTipFrame = nil
				end
			end,
			--cancelFun = cancelCallback, --点否的回调函数
			textOk = hVar.tab_string["__TEXT_Confirm"], 		--"确定"
			textCancel = hVar.tab_string["__TEXT_Cancel"], 		--"取消"
		}
		--local showTitle = string.format(hVar.tab_string["__TEXT_IsChatBanPlayer"], tostring(name)) --"是否禁言玩家 \"" .. name .. "\" ？"
		local showTitle = string.format(hVar.tab_string["__TEXT_PrivateClose"], ctrlI.data.toname) --"是否关闭和【" .. ctrlI.data.toname .. "】的私聊？"
		showTitle = showTitle .. "\n" ..hVar.tab_string["__TEXT_PrivateCloseNotice"]
		local msgBox = hGlobal.UI.MsgBox(showTitle, MsgSelections)
		msgBox:active()
		msgBox:show(1,"fade",{time=0.08})

		--[[
		--背景图
		local img9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_9s_2.png", _offX, _offY, 550, 300, hGlobal.UI.GameCoinTipFrame)
		--img9:setOpacity(212)
		
		--标题
		local strText = string.format(hVar.tab_string["__TEXT_PrivateClose"], ctrlI.data.toname) --"是否关闭和【" .. ctrlI.data.toname .. "】的私聊？"
		_TacticTipChildUI["RoleTitle"] = hUI.label:new({
			parent = _TacticTipParent,
			--model = tRoleIcon.icon,
			x = _offX,
			y = _offY + 70,
			font = hVar.FONTC,
			align = "MC",
			size = 32,
			text = strText,
			border = 1,
			width = 800,
			RGB = {255, 255, 212,},
		})
		
		--副标题
		local strTextSub = hVar.tab_string["__TEXT_PrivateCloseNotice"] --"关闭后无法给对方发送消息。世界聊天可以重新发起私聊。"
		_TacticTipChildUI["RoleSubTitle"] = hUI.label:new({
			parent = _TacticTipParent,
			--model = tRoleIcon.icon,
			x = _offX,
			y = _offY + 18,
			font = hVar.FONTC,
			align = "MC",
			size = 20,
			text = strTextSub,
			border = 1,
			width = 800,
			RGB = {192, 192, 192,},
		})
		
		--关闭按钮(弹出的对话框)
		_TacticTipChildUI["btnDeleteOK"] = hUI.button:new({
			parent = _TacticTipParent,
			model = "misc/chest/chatsend.png", --"UI:PANEL_MENU_BTN_BIG", --"UI:SkillSlot",
			x = _offX + 110,
			y = _offY - 66,
			model = "misc/chest/button_blue.png", --"UI:PANEL_MENU_BTN_BIG",
			label = {x = 2, y = 2, text = hVar.tab_string["__TEXT_Close"], size = 26, font = hVar.FONTC, border = 1, RGB = {255, 255, 144},}, --"关闭"
			w = 160,
			h = 68,
			dragbox = hGlobal.UI.GameCoinTipFrame.childUI["dragBox"],
			scaleT = 0.95,
			code = function()
				--关闭本页面
				if hGlobal.UI.GameCoinTipFrame then
					hGlobal.UI.GameCoinTipFrame:del()
					hGlobal.UI.GameCoinTipFrame = nil
				end
				
				--添加查询超时一次性timer
				hApi.addTimerOnce("__ONCE_CHAT_TIMEOUNT_TIMER__", 5000, refresh_chatnet_timeout_timer)
				
				--请求删除此好友
				SendGroupCmdFunc["chat_private_delete"](friendUid)
			end,
		})
		
		--取消按钮
		_TacticTipChildUI["btnDeleteCancel"] = hUI.button:new({
			parent = _TacticTipParent,
			model = "misc/chest/chatsend.png", --"UI:PANEL_MENU_BTN_BIG", --"UI:SkillSlot",
			x = _offX - 110,
			y = _offY - 66,
			model = "misc/chest/button_red.png", --"UI:PANEL_MENU_BTN_BIG",
			label = {x = 2, y = 2, text = hVar.tab_string["__TEXT_Cancel"], size = 26, font = hVar.FONTC, border = 1, RGB = {236, 236, 212},}, --"取消"
			w = 160,
			h = 68,
			dragbox = hGlobal.UI.GameCoinTipFrame.childUI["dragBox"],
			scaleT = 0.95,
			code = function()
				--关闭本页面
				if hGlobal.UI.GameCoinTipFrame then
					hGlobal.UI.GameCoinTipFrame:del()
					hGlobal.UI.GameCoinTipFrame = nil
				end
			end,
		})
		]]
	end
	
	--函数：点击世界红包按钮
	OnClickWorldRedPacketBtn = function(selectTipIdxRedpacket)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--红包消息i
		local ctrlI = _frmNode.childUI["DLCMapInfoNode" .. selectTipIdxRedpacket]
		if ctrlI then
			local msgIdi = ctrlI.data.msgId
			local tMsg = current_chat_msg_hostory_cache_world[msgIdi]
			if tMsg then
				local msgId = tMsg.id --消息id
				local chatType = tMsg.chatType --聊天频道
				local msgType = tMsg.msgType --消息类型
				if (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_PAY_REDPACKET_SEND) then --发支付（土豪）红包
					local uid = tMsg.uid --消息发送者uid
					local name = tMsg.name --玩家名
					local channelId = tMsg.channelId --渠道号
					local vip = tMsg.vip --vip等级
					local borderId = tMsg.borderId --边框id
					local iconId = tMsg.iconId --头像id
					local championId = tMsg.championId --称号id
					local leaderId = tMsg.leaderId --会长权限
					local dragonId = tMsg.dragonId --聊天龙王id
					local headId = tMsg.headId --头衔id
					local lineId = tMsg.lineId --线索id
					local date = tMsg.date --日期
					local content = tMsg.content --聊天内容
					local touid = tMsg.touid --接收者uid
					local result = tMsg.result --可交互类型消息的操作结果
					local resultParam = tMsg.resultParam --可交互类型消息的参数
					local redPacketParam = tMsg.redPacketParam --红包消息参数
					
					--支付（土豪）红包的红包参数信息
					local redPacketId = redPacketParam.redPacketId --红包唯一id
					local send_uid = redPacketParam.send_uid --红包发送者uid
					local send_name = redPacketParam.send_name --红包发送者名字
					local send_num = redPacketParam.send_num --红包发送数量
					local content = redPacketParam.content --内容
					local money = redPacketParam.money --充值金额
					local iap_id = redPacketParam.iap_id --充值记录id
					local channelId = redPacketParam.channelId --渠道号
					local vipLv = redPacketParam.vipLv --vip等级
					local borderId = redPacketParam.borderId --边框id
					local iconId = redPacketParam.iconId --头像id
					local championId = redPacketParam.championId --称号id
					local leaderId = redPacketParam.leaderId --会长权限
					local dragonId = redPacketParam.dragonId --聊天龙王id
					local headId = redPacketParam.headId --头衔id
					local lineId = redPacketParam.lineId --线索id
					local msg_id = redPacketParam.msg_id --消息id
					local receive_num = redPacketParam.receive_num --红包接收数量
					local send_time = redPacketParam.send_time --红包发送时间
					local expire_time = redPacketParam.expire_time --红包过期时间
					local redPacketReceiveList = redPacketParam.redPacketReceiveList --红包领取uid列表
					
					--删除上一次的界面
					if hGlobal.UI.SendRedPacketFrm then
						hGlobal.UI.SendRedPacketFrm:del()
						hGlobal.UI.SendRedPacketFrm = nil
					end
					
					--print("on_create_world_redpacket_send_frame")
					
					local BOARD_WIDTH = 416 --选卡面板的宽度
					local BOARD_HEIGHT = 580 --选卡面板的高度
					local BOARD_OFFSETX = -3 --选卡面板x偏移中心点的值
					local BOARD_OFFSETY = 5 --选卡面板y偏移中心点的值
					local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --聊天面板的x位置（最左侧）
					local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --聊天面板的y位置（最顶侧）
					
					--创建发红包界面（世界红包）
					hGlobal.UI.SendRedPacketFrm = hUI.frame:new(
					{
						x = BOARD_POS_X,
						y = BOARD_POS_Y,
						z = hZorder.CommonUIFrame + 1,
						w = BOARD_WIDTH,
						h = BOARD_HEIGHT,
						dragable = 2,
						show = 1, --一开始不显示
						--border = "UI:TileFrmBasic_thin",
						--border = "UI:TileFrmBack_PVP",
						background = -1, --"panel/panel_part_pvp_00.png",
						--background = "panel/panel_part_00.png", --"UI:Tactic_Background",
						--background = "UI:tip_item",
						--background = "UI:Tactic_Background",
						border = 0, --显示frame边框
						--background = "misc/chest/bottom9g.png", --"UI:Tactic_Background",
						autoactive = 0,
						
						--点击事件
						codeOnTouch = function(self, x, y, sus)
							--在外部点击
							if (sus == 0) then
								self.childUI["closeBtn2"].data.code()
							end
						end,
					})
					
					local _frm2 = hGlobal.UI.SendRedPacketFrm
					local _parent2 = _frm2.handle._n
					
					_frm2:active()
					
					--左侧裁剪区域（后端）
					local _BTC_PageClippingRect_back = {0, -250, BOARD_WIDTH, 330, 0} -- {x, y, w, h, isShow}
					local _BTC_pClipNode_back = hApi.CreateClippingNode(_frm2, _BTC_PageClippingRect_back, 99, _BTC_PageClippingRect_back[5], "_BTC_pClipNode_back")
					
					--控制参数
					local click_pos_x_dlcmapinfo_redpacket = 0 --开始按下的坐标x
					local click_pos_y_dlcmapinfo_redpacket = 0 --开始按下的坐标y
					local last_click_pos_y_dlcmapinfo_redpacket = 0 --上一次按下的坐标x
					local last_click_pos_y_dlcmapinfo_redpacket = 0 --上一次按下的坐标y
					local draggle_speed_y_dlcmapinfo_redpacket = 0 --当前滑动的速度x
					local selected_dlcmapinfoEx_idx_redpacket = 0 --选中的DLC地图面板ex索引
					local click_scroll_dlcmapinfo_redpacket = false --是否在滑动DLC地图面板中
					local b_need_auto_fixing_dlcmapinfo_redpacket = false --是否需要自动修正
					local friction_dlcmapinfo_redpacket = 0 --阻力
					local friction_dlcmapinfo_redpacket_coefficient = 0.5 --阻力衰减系数(默认值)
					
					local current_DLCMap_max_num_redpacket = 0
					--local WEAPON_X_NUM_REDPACKET = 3
					--local WEAPON_Y_NUM_REDPACKET = 1
					local current_async_paint_list_redpacket = {} --异步绘制红包领取条目表
					local ASYNC_PAINTNUM_ONCE_REDPACKET = 1 --一次绘制几条
					
					--接口
					local on_upddate_redpacket_received_ui = hApi.DoNothing --刷新红包已领取界面
					local on_click_open_redpacket_btn = hApi.DoNothing --点击开红包按钮
					local on_click_viewdetail_redpacket_btn = hApi.DoNothing --点击查看红包领取详情按钮
					local on_receive_takereward_pay_redpacket_event = hApi.DoNothing --收到领取支付（土豪）红包的结果
					local on_receive_viewdetail_pay_redpacket_event = hApi.DoNothing --收到查看支付（土豪）红包的领取详情结果
					local on_create_viewdetail_pay_redpacket_ui = hApi.DoNothing --创建支付（土豪）红包的领取详情界面
					local on_create_single_redpacket_record_UI = hApi.DoNothing --绘制单条红包领取记录数据
					local on_create_single_redpacket_record_UI_async = hApi.DoNothing --异步绘制单条红包领取记录数据（异步）
					local getUpDownOffset_redpacket = hApi.DoNothing --获得第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离
					local refresh_dlcmapinfo_viewdetail_redpacket_UI_loop = hApi.DoNothing --刷新支付（土豪）红包的领取详情列表滚动
					local refresh_async_paint_redpacket_record_loop = hApi.DoNothing --异步绘制红包领取记录条目的timer
					
					--显示clipnode
					hApi.EnableClipByName(_frm2, "_BTC_pClipNode_back", 1)
					
					--关闭按钮
					--closeBtn
					_frm2.childUI["closeBtn2"] = hUI.button:new({
						parent = _parent2,
						dragbox = _frm2.childUI["dragBox"],
						--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
						model = "misc/chest/redpacket_close.png", --"UI:close", --"BTN:PANEL_CLOSE",
						x = _frm2.data.w - 4 - 22 - 4,
						y = -8 - 22,
						z = 103,
						w = 48,
						h = 48,
						scaleT = 0.95,
						code = function()
							--移除监听：收到领取支付（土豪）红包结果结果
							hGlobal.event:listen("LocalEvent_OnReceivePayRedPacketResult", "ReceivePayRedPacketResult", nil)
							--移除监听：收到查看支付（土豪）红包的领取详情结果
							hGlobal.event:listen("LocalEvent_ViewDetailPayRedPacketResult", "ViewDetailPayRedPacketResult", nil)
							
							--移除timer
							hApi.clearTimer("__VIEWDETAIL_PAY_REDPACKET_LIST__")
							hApi.clearTimer("__PAY_REDPACKET_CHANGE_ASYNC_TIMER__")
							hApi.clearTimer("__ONCE_CHAT_PAYREDPACKET_AMIN_TIMER__")
							
							--删除本界面
							if hGlobal.UI.SendRedPacketFrm then
								hGlobal.UI.SendRedPacketFrm:del()
								hGlobal.UI.SendRedPacketFrm = nil
							end
							
							--清理数据
							current_async_paint_list_redpacket = nil
						end,
					})
					
					--背景底图
					_frm2.childUI["BG"] = hUI.image:new({
						parent = _parent2,
						model = "misc/mask_white.png",
						x = 0,
						y = 0,
						z = -100,
						w = hVar.SCREEN.w * 2,
						h = hVar.SCREEN.h * 2,
					})
					_frm2.childUI["BG"].handle.s:setOpacity(88)
					_frm2.childUI["BG"].handle.s:setColor(ccc3(0, 0, 0))
					
					--前端区域
					_frm2.childUI["nodeFront"] = hUI.node:new({
						parent = _parent2,
						x = 0,
						y = 0,
						z = 100,
						w = 1,
						h = 1,
					})
					
					--红包红色底图
					local s9R = hApi.CCScale9SpriteCreate("data/image/misc/chest/redpacket_cover.png", BOARD_WIDTH/2, -BOARD_HEIGHT/2, BOARD_WIDTH, BOARD_HEIGHT, _frm2.childUI["nodeFront"])
					_frm2.childUI["nodeFront"].data.s9R = s9R
					
					--玩家头像
					local tRoleIcon = hVar.tab_roleicon[iconId]
					if (tRoleIcon == nil) then
						tRoleIcon = hVar.tab_roleicon[0]
					end
					local iconW = tRoleIcon.width
					local iconH = tRoleIcon.height
					local width = 64 * iconW / iconH
					local height = 64
					--玩家头像
					_frm2.childUI["nodeFront"].childUI["titleImgIcon"] = hUI.image:new({
						parent = _frm2.childUI["nodeFront"].handle._n,
						model = tRoleIcon.icon,
						x = BOARD_WIDTH/2,
						y = -80,
						z = 2,
						w = width,
						h = height,
					})
					
					--玩家边框
					local tRoleBorder = hVar.tab_roleborder[borderId]
					if (tRoleBorder == nil) then
						tRoleBorder = hVar.tab_roleborder[0]
					end
					local iconW = tRoleBorder.width
					local iconH = tRoleBorder.height
					local width = 64 * iconW / iconH
					local height = 64
					_frm2.childUI["nodeFront"].childUI["titleImgBorder"] = hUI.image:new({
						parent = _frm2.childUI["nodeFront"].handle._n,
						model = tRoleBorder.icon,
						x = BOARD_WIDTH/2,
						y = -80,
						z = 3,
						w = width,
						h = height,
					})
					
					--玩家名
					_frm2.childUI["nodeFront"].childUI["titleLabel"] = hUI.label:new({
						parent = _frm2.childUI["nodeFront"].handle._n,
						size = 26,
						font = hVar.FONTC,
						border = 1,
						align = "MC",
						x = BOARD_WIDTH/2,
						y = -140,
						z = 2,
						width = 500,
						text = "【" .. tostring(send_name) .. "】",
						RGB = {255, 255, 168,},
					})
					
					--发送红包文字
					_frm2.childUI["nodeFront"].childUI["titleLabelIntro"] = hUI.label:new({
						parent = _frm2.childUI["nodeFront"].handle._n,
						size = 22,
						font = hVar.FONTC,
						border = 1,
						align = "MC",
						x = BOARD_WIDTH/2,
						y = -175,
						z = 2,
						width = 500,
						text = hVar.tab_string["__GROUP_REDPACKET_SEND"], --"发送了一个红包"
						RGB = {255, 255, 168,},
					})
					
					--发送红包正文
					_frm2.childUI["nodeFront"].childUI["titleLabelContent"] = hUI.label:new({
						parent = _frm2.childUI["nodeFront"].handle._n,
						size = 30,
						font = hVar.FONTC,
						border = 1,
						align = "MC",
						x = BOARD_WIDTH/2,
						y = -240,
						z = 2,
						width = 500,
						text = content,
						RGB = {255, 255, 168,},
					})
					
					--已领取的文字
					_frm2.childUI["nodeFront"].childUI["titleLabelReceived"] = hUI.label:new({
						parent = _frm2.childUI["nodeFront"].handle._n,
						size = 26,
						font = hVar.FONTC,
						border = 1,
						align = "MC",
						x = BOARD_WIDTH/2,
						y = -360,
						z = 2,
						width = 500,
						text = "",
						--RGB = {0, 255, 0,},
					})
					--_frm2.childUI["nodeFront"].childUI["titleLabelReceived"].handle._n:setVisible(false) --默认不显示
					
					--红包红色底图2
					_frm2.childUI["nodeFront"].childUI["BGRed2"] = hUI.image:new({
						parent = _frm2.childUI["nodeFront"].handle._n,
						model = "misc/chest/redpacket_bg.png",
						x = BOARD_WIDTH/2,
						y = -BOARD_HEIGHT/2,
						z = 1,
						w = BOARD_WIDTH,
						h = BOARD_HEIGHT,
					})
					--_frm2.childUI["nodeFront"].childUI["BGRed2"].handle.s:setOpacity(96)
					
					--开的按钮
					_frm2.childUI["btnOpen"] = hUI.button:new({
						parent = _parent2,
						dragbox = _frm2.childUI["dragBox"],
						model = "misc/chest/redpacket_open_big.png",
						x = BOARD_WIDTH/2,
						y = -440,
						z = 102,
						w = 120,
						h = 120,
						scaleT = 0.95,
						code = function(self)
							--禁止再次点击
							_frm2.childUI["btnOpen"]:setstate(0)
							
							--点击开红包按钮
							on_click_open_redpacket_btn()
						end,
					})
					
					--查看领取详情的按钮
					_frm2.childUI["btnViewDetail"] = hUI.button:new({
						parent = _parent2,
						dragbox = _frm2.childUI["dragBox"],
						model = "misc/chest/button_blue.png",
						x = BOARD_WIDTH/2,
						y = -510,
						z = 102,
						w = 175,
						h = 64,
						label = {text = hVar.tab_string["__GROUP_REDPACKET_DETAIL"], x = 5, y = 3, font = hVar.FONTC, size = 24, border = 1, align = "MC",}, --"查看领取详情"
						scaleT = 0.95,
						code = function()
							--点击查看领取详情的按钮
							on_click_viewdetail_redpacket_btn()
						end,
					})
					_frm2.childUI["btnViewDetail"]:setstate(-1) --默认不显示
					
					--后端
					--区域node
					_frm2.childUI["nodeBack"] = hUI.node:new({
						parent = _parent2,
						x = 0,
						y = 0,
						z = 0,
						w = 1,
						h = 1,
					})
					_frm2.childUI["nodeBack"].handle._n:setVisible(false) --默认隐藏
					
					--后端
					--后端红包红色底图
					local s9R2 = hApi.CCScale9SpriteCreate("data/image/misc/chest/redpacket_cover.png", BOARD_WIDTH/2, -BOARD_HEIGHT/2, BOARD_WIDTH, BOARD_HEIGHT, _frm2.childUI["nodeBack"])
					_frm2.childUI["nodeBack"].data.s9R2 = s9R2
					
					--后端白色底图
					_frm2.childUI["nodeBack"].childUI["BGWhite"] = hUI.image:new({
						parent = _frm2.childUI["nodeBack"].handle._n,
						model = "misc/chest/redpacket_detail_bg.png",
						x = BOARD_WIDTH/2,
						y = -BOARD_HEIGHT/2,
						--z = 0,
						w = BOARD_WIDTH,
						h = BOARD_HEIGHT,
					})
					
					--函数：刷新红包已领取界面
					on_upddate_redpacket_received_ui = function()
						local _frm2 = hGlobal.UI.SendRedPacketFrm
						local _parent2 = _frm2.handle._n
						
						--更新红包红色底图
						local s9R = _frm2.childUI["nodeFront"].data.s9R
						if s9R then
							_frm2.childUI["nodeFront"].handle._n:removeChild(s9R, true)
						end
						--红包红色底图
						local s9R = hApi.CCScale9SpriteCreate("data/image/misc/chest/redpacket_cover_empty.png", BOARD_WIDTH/2, -BOARD_HEIGHT/2, BOARD_WIDTH, BOARD_HEIGHT, _frm2.childUI["nodeFront"])
						_frm2.childUI["nodeFront"].data.s9R = s9R
						
						--更新红包下班部分底图
						_frm2.childUI["nodeFront"].childUI["BGRed2"].handle.s:setOpacity(64)
						
						--显示已领取文字
						local lefenum = send_num - receive_num
						if (lefenum <= 0) then
							_frm2.childUI["nodeFront"].childUI["titleLabelReceived"]:setText(hVar.tab_string["__GROUP_REDPACKET_RECEIVE_EMPTY"]) --"红包已被领完"
							_frm2.childUI["nodeFront"].childUI["titleLabelReceived"].handle.s:setColor(ccc3(224, 224, 224))
						else
							_frm2.childUI["nodeFront"].childUI["titleLabelReceived"]:setText(hVar.tab_string["__GROUP_REDPACKET_RECEIVE_YOU"]) --"您已领取该红包"
							_frm2.childUI["nodeFront"].childUI["titleLabelReceived"].handle.s:setColor(ccc3(0, 255, 0))
						end
						
						--隐藏领取按钮
						_frm2.childUI["btnOpen"].handle._n:stopAllActions()
						_frm2.childUI["btnOpen"]:setstate(-1)
						
						--显示查看领取详情按钮
						_frm2.childUI["btnViewDetail"]:setstate(1)
					end
					
					--函数：点击开红包按钮
					on_click_open_redpacket_btn = function()
						local _frm2 = hGlobal.UI.SendRedPacketFrm
						local _parent2 = _frm2.handle._n
						
						--如果未连接socket工会服务器，不能操作
						if (Group_Server:GetState() ~= 1) then --未连接
							--冒字
							--local strText = "不能连接到网络" --language
							local strText = hVar.tab_string["ios_err_network_cannot_conn"] --language
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
						
						--如果未登入工会服务器，不能操作
						if (Group_Server:getonline() ~= 1) then --未登入
							--冒字
							--local strText = "不能连接到网络" --language
							local strText = hVar.tab_string["ios_err_network_cannot_conn"] --language
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
						
						--通过校验，可以领红包
						--挡操作
						hUI.NetDisable(30000)
						
						--按钮转的动画
						local ROT_TIME = 0.2
						local act8 = CCEaseSineIn:create(CCOrbitCamera:create(ROT_TIME, 1, 0, 0, 90, 0, 0)) --参数: t, radius, deltaRadius, angleZ, deltaAngleZ, angleX, deltaAngleX
						local act10 = CCEaseSineOut:create(CCOrbitCamera:create(ROT_TIME, 1, 0, 90, -90, 0, 0)) --参数: t, radius, deltaRadius, angleZ, deltaAngleZ, angleX, deltaAngleX
						local a = CCArray:create()
						a:addObject(act8)
						a:addObject(act10)
						local sequence = CCSequence:create(a)
						local forever = CCRepeatForever:create(sequence)
						_frm2.childUI["btnOpen"].handle._n:runAction(forever)
						
						--请求领取红包
						local msgId = ctrlI.data.msgId
						--print(redPacketId)
						SendGroupCmdFunc["receive_pay_redpacket"](redPacketId)
					end
					
					--函数：收到领取支付（土豪）红包的结果
					on_receive_takereward_pay_redpacket_event = function(result, reward)
						local _frm2 = hGlobal.UI.SendRedPacketFrm
						local _parent2 = _frm2.handle._n
						
						--取消挡操作
						hUI.NetDisable(0)
						
						--领取成功
						if (result == 1) then
							--延时显示结果
							hApi.addTimerOnce("__ONCE_CHAT_PAYREDPACKET_AMIN_TIMER__", 400, function()
								local rewardN = #reward
								local tag, rewardResult = hApi.GetReawrdGift(reward, rewardN)
								--hApi.BubbleGiftAnim(reward, rewardN, hVar.SCREEN.w / 2, hVar.SCREEN.h / 2)
								--新的动画表现获得奖励
								hApi.PlayChestRewardAnimation(0, rewardResult)
								
								--缓存已领取
								receive_num = receive_num + 1
								
								--刷新已领取界面
								on_upddate_redpacket_received_ui()
							end)
						elseif (result == hVar.GROUPSERVER_ERROR_TYPE.NO_PAY_RECEIVE_RED_PACKET_EMYPT) then --红包已被领完
							--缓存已领完
							send_num = receive_num
							
							--刷新已领取界面
							on_upddate_redpacket_received_ui()
						end
					end
					
					--函数：点击查看领取详情的按钮
					on_click_viewdetail_redpacket_btn = function()
						local _frm2 = hGlobal.UI.SendRedPacketFrm
						local _parent2 = _frm2.handle._n
						
						--如果未连接socket工会服务器，不能操作
						if (Group_Server:GetState() ~= 1) then --未连接
							--冒字
							--local strText = "不能连接到网络" --language
							local strText = hVar.tab_string["ios_err_network_cannot_conn"] --language
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
						
						--如果未登入工会服务器，不能操作
						if (Group_Server:getonline() ~= 1) then --未登入
							--冒字
							--local strText = "不能连接到网络" --language
							local strText = hVar.tab_string["ios_err_network_cannot_conn"] --language
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
						
						--通过校验，可以查看红包领取详情
						--挡操作
						hUI.NetDisable(30000)
						
						--请求查看红包领取详情
						--print(redPacketId)
						SendGroupCmdFunc["viewdetail_pay_redpacket"](redPacketId)
					end
					
					--函数：收到查看支付（土豪）红包的领取详情结果
					on_receive_viewdetail_pay_redpacket_event = function(result, tSend, tReceive)
						local _frm2 = hGlobal.UI.SendRedPacketFrm
						local _parent2 = _frm2.handle._n
						
						--取消挡操作
						hUI.NetDisable(0)
						
						--查询成功
						if (result == 1) then
							--隐藏前端控件
							_frm2.childUI["nodeFront"].handle._n:setVisible(false)
							_frm2.childUI["btnOpen"].handle._n:stopAllActions()
							_frm2.childUI["btnOpen"]:setstate(-1)
							_frm2.childUI["btnViewDetail"]:setstate(-1)
							
							--显示后端控件
							_frm2.childUI["nodeBack"].handle._n:setVisible(true)
							
							--绘制后端控件
							on_create_viewdetail_pay_redpacket_ui(tSend, tReceive)
						end
					end
					
					--函数：创建支付（土豪）红包的领取详情界面
					on_create_viewdetail_pay_redpacket_ui = function(tSend, tReceive)
						local _frm2 = hGlobal.UI.SendRedPacketFrm
						local _parent2 = _frm2.handle._n
						
						--红包发送者信息
						local redPacketId = tSend.redPacketId
						local send_uid = tSend.send_uid
						local send_name = tSend.send_name
						local send_num = tSend.send_num
						local content = tSend.content
						local money = tSend.money
						local iap_id = tSend.iap_id
						local channelId = tSend.channelId
						local vipLv = tSend.vipLv
						local borderId = tSend.borderId
						local iconId = tSend.iconId
						local championId = tSend.championId
						local leaderId = tSend.leaderId
						local dragonId = tSend.dragonId --聊天龙王id
						local headId = tSend.headId --头衔id
						local lineId = tSend.lineId --线索id
						local msg_id = tSend.msg_id
						local receive_num = tSend.receive_num
						local send_time = tSend.send_time
						local expire_time = tSend.expire_time
						
						current_DLCMap_max_num_redpacket = #tReceive
						current_async_paint_list_redpacket = {} --清空异步缓存待绘制内容
						
						--我的uid
						local uidMe = xlPlayer_GetUID()
						
						--清除上一次的控件
						hApi.safeRemoveT(_frm2.childUI["nodeBack"].childUI, "node")
						hApi.safeRemoveT(_frm2.childUI["nodeBack"].childUI, "clipnode")
						
						--后端
						--重新创建后端区域node
						_frm2.childUI["nodeBack"].childUI["node"] = hUI.button:new({
							parent = _frm2.childUI["nodeBack"].handle._n,
							x = 0,
							y = 0,
							w = 1,
							h = 1,
						})
						
						--重新创建后端区域clipnode
						_frm2.childUI["nodeBack"].childUI["clipnode"] = hUI.button:new({
							parent = _BTC_pClipNode_back,
							x = 0,
							y = 0,
							w = 1,
							h = 1,
						})
						
						local _childUINode = _frm2.childUI["nodeBack"].childUI["node"]
						local _parentNode = _frm2.childUI["nodeBack"].childUI["node"].handle._n
						local _childUIClip = _frm2.childUI["nodeBack"].childUI["clipnode"]
						local _parentClip = _frm2.childUI["nodeBack"].childUI["clipnode"].handle._n
						
						--发送玩家头像
						local tRoleIcon = hVar.tab_roleicon[iconId]
						if (tRoleIcon == nil) then
							tRoleIcon = hVar.tab_roleicon[0]
						end
						local iconW = tRoleIcon.width
						local iconH = tRoleIcon.height
						local width = 64 * iconW / iconH
						local height = 64
						--发送玩家头像
						_childUINode.childUI["titleImgIcon"] = hUI.image:new({
							parent = _parentNode,
							model = tRoleIcon.icon,
							x = BOARD_WIDTH/2,
							y = -80,
							z = 1,
							w = width,
							h = height,
						})
						
						--发送玩家边框
						local tRoleBorder = hVar.tab_roleborder[borderId]
						if (tRoleBorder == nil) then
							tRoleBorder = hVar.tab_roleborder[0]
						end
						local iconW = tRoleBorder.width
						local iconH = tRoleBorder.height
						local width = 64 * iconW / iconH
						local height = 64
						_childUINode.childUI["titleImgBorder"] = hUI.image:new({
							parent = _parentNode,
							model = tRoleBorder.icon,
							x = BOARD_WIDTH/2,
							y = -80,
							z = 1,
							w = width,
							h = height,
						})
						
						--发送玩家名
						_childUINode.childUI["titleLabel"] = hUI.label:new({
							parent = _parentNode,
							size = 24,
							font = hVar.FONTC,
							border = 1,
							align = "MC",
							x = BOARD_WIDTH/2,
							y = -140,
							z = 1,
							width = 500,
							text = string.format(hVar.tab_string["__GROUP_REDPACKET_RECEIVE_NOTICE"], send_name), --"【" .. tostring(send_name) .. "】的红包"
							RGB = {255, 255, 168,},
						})
						
						--发送红包正文
						_childUINode.childUI["titleLabelContent"] = hUI.label:new({
							parent = _parentNode,
							size = 24,
							font = hVar.FONTC,
							border = 1,
							align = "MC",
							x = BOARD_WIDTH/2,
							y = -175,
							z = 1,
							width = 500,
							text = content,
							RGB = {255, 255, 168,},
						})
						
						--红包数量背景图
						_childUINode.childUI["titleRedPacketNumBG"] = hUI.image:new({
							parent = _parentNode,
							model = "misc/chest/task_s9.png",
							x = BOARD_WIDTH/2,
							y = -230,
							z = 1,
							w = BOARD_WIDTH,
							h = 40,
						})
						_childUINode.childUI["titleRedPacketNumBG"].handle.s:setOpacity(128)
						
						--红包领取数量
						local strRedPacketNum = ""
						if (receive_num < send_num) then --未领完
							strRedPacketNum = string.format(hVar.tab_string["__GROUP_REDPACKET_RECEIVE_DETAIL_SOME"], send_num, receive_num, send_num) --tostring(send_num) .. "个红包，已领取 " .. receive_num .. "/" .. send_num
						else
							strRedPacketNum = string.format(hVar.tab_string["__GROUP_REDPACKET_RECEIVE_DETAIL_ALL"], send_num) --tostring(send_num) .. "个红包，已全部领完"
						end
						_childUINode.childUI["titleLabelContent"] = hUI.label:new({
							parent = _parentNode,
							size = 22,
							font = hVar.FONTC,
							border = 1,
							align = "LC",
							x = 10,
							y = -230 - 1,
							z = 1,
							width = 500,
							text = strRedPacketNum,
							--RGB = {255, 255, 255,},
						})
						
						--红包玩家领取列表检测滑动事件的控件
						_childUINode.childUI["DragPanel"] = hUI.button:new({
							parent = _parentNode,
							model = "misc/mask.png",
							dragbox = _frm2.childUI["dragBox"],
							x = BOARD_WIDTH/2,
							y = -415,
							w = BOARD_WIDTH,
							h = 330,
							failcall = 1,
							
							--按下事件
							codeOnTouch = function(self, touchX, touchY, sus)
								--在动画中禁止点击
								if current_is_in_action then
									return
								end
								
								--print("codeOnTouch", touchX, touchY, sus)
								click_pos_x_dlcmapinfo_redpacket = touchX --开始按下的坐标x
								click_pos_y_dlcmapinfo_redpacket = touchY --开始按下的坐标y
								last_click_pos_y_dlcmapinfo_redpacket = touchX --上一次按下的坐标x
								last_click_pos_y_dlcmapinfo_redpacket = touchY --上一次按下的坐标y
								draggle_speed_y_dlcmapinfo_redpacket = 0 --当前速度为0
								selected_dlcmapinfoEx_idx_redpacket = 0 --选中的DLC地图面板ex索引
								click_scroll_dlcmapinfo_redpacket = true --是否滑动DLC地图面板
								b_need_auto_fixing_dlcmapinfo_redpacket = false --不需要自动修正位置
								friction_dlcmapinfo_redpacket = 0 --无阻力
								friction_dlcmapinfo_redpacket_coefficient = 0.5 --衰减系数(默认值)
								
								--检测是否滑动到了最顶部或最底部
								local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
								local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
								delta1_ly, deltNa_ry = getUpDownOffset_redpacket()
								--print(delta1_ly, deltNa_ry)
								--delta1_ly +:在下底线之上 /-:在下底线之下
								--deltNa_ry +:在下底线之上 /-:在下底线之下
								
								--print("click_scroll_dlcmapinfo=", click_scroll_dlcmapinfo)
								
								--不满一页
								--上面对其上顶线，下面在在下底线之上
								if (delta1_ly == 0) and (deltNa_ry >= 0) then
									click_scroll_dlcmapinfo_redpacket = false --不需要滑动DLC地图面板
								end
								
								--模拟按下事件
								--检测是否点到了某些控件里
								for i = 1, current_DLCMap_max_num_redpacket, 1 do
									local ctrli = _childUIClip.childUI["DLCMapInfoNode" .. i]
									if ctrli then
										local cx = ctrli.data.x --中心点x坐标
										local cy = ctrli.data.y --中心点y坐标
										
										--检测是否点到了奖励控件
										for m = 1, 4, 1 do
											local iconim = ctrli.childUI["icon_" .. m]
											if iconim then
												local mcx = iconim.data.x --中心点x坐标
												local mcy = iconim.data.y --中心点y坐标
												local mcw, mch = iconim.data.w, iconim.data.h
												local mlx, mly = cx + mcx - mcw / 2, cy  + mcy- mch / 2 --最左上侧坐标
												local mrx, mry = mlx + mcw, mly + mch --最右下角坐标
												--print(i, lx, rx, ly, ry, touchX, touchY)
												if (touchX >= mlx) and (touchX <= mrx) and (touchY >= mly) and (touchY <= mry) then
													--print("点击到了哪个DLC地图面板tip的框内" .. i, m)
													--缩小再放大
													local act1 = CCEaseSineIn:create(CCScaleTo:create(0.1, 0.95))
													local act2 = CCEaseSineOut:create(CCScaleTo:create(0.1, 1.0))
													local a = CCArray:create()
													a:addObject(act1)
													a:addObject(act2)
													local sequence = CCSequence:create(a)
													iconim.handle._n:stopAllActions()
													iconim.handle._n:runAction(sequence)
												end
											end
										end
										
										--检测是否点到了领奖按钮
										local ctrlI = ctrli.childUI["rewardBtn"]
										if ctrlI then
											if (ctrlI.data.state == 1) then --按钮可点状态
												local bcx = ctrlI.data.x --中心点x坐标
												local bcy = ctrlI.data.y --中心点y坐标
												local bcw, bch = ctrlI.data.w, ctrlI.data.h
												local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
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
													ctrlI.handle._n:stopAllActions()
													ctrlI.handle._n:runAction(sequence)
												end
											end
										end
									end
								end
							end,
							
							--滑动事件
							codeOnDrag = function(self, touchX, touchY, sus)
								--在动画中禁止点击
								if current_is_in_action then
									return
								end
								
								--print("codeOnDrag", touchX, touchY, sus)
								--处理移动速度y
								draggle_speed_y_dlcmapinfo_redpacket = touchY - last_click_pos_y_dlcmapinfo_redpacket
								
								if (draggle_speed_y_dlcmapinfo_redpacket > MAX_SPEED) then
									draggle_speed_y_dlcmapinfo_redpacket = MAX_SPEED
								end
								if (draggle_speed_y_dlcmapinfo_redpacket < -MAX_SPEED) then
									draggle_speed_y_dlcmapinfo_redpacket = -MAX_SPEED
								end
								
								--检测是否滑动到了最顶部或最底部
								local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
								local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
								delta1_ly, deltNa_ry = getUpDownOffset_redpacket()
								--print(delta1_ly, deltNa_ry)
								--delta1_ly +:在下底线之上 /-:在下底线之下
								--deltNa_ry +:在下底线之上 /-:在下底线之下
								
								--print("click_scroll_dlcmapinfo_redpacket=", click_scroll_dlcmapinfo_redpacket)
								--在滑动过程中才会处理滑动
								if click_scroll_dlcmapinfo_redpacket then
									local deltaY = touchY - last_click_pos_y_dlcmapinfo_redpacket --与开始按下的位置的偏移值x
									
									--第一个DLC地图面板的坐标不能跑到最上侧的下边去
									if ((delta1_ly + deltaY) <= 0) then --防止走过
										deltaY = -delta1_ly
										delta1_ly = 0
										
										--没有惯性
										draggle_speed_y_dlcmapinfo_redpacket = 0
										
										--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --上分翻页提示
									else
										--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(true) --上分翻页提示
									end
									
									--最后一个DLC地图面板的坐标不能跑到最下侧的上边去
									if ((deltNa_ry + deltaY) >= 0) then --防止走过
										deltaY = -deltNa_ry
										deltNa_ry = 0
										
										--没有惯性
										draggle_speed_y_dlcmapinfo_redpacket = 0
										
										--已到底部，标记下拉到底部（为true时有新消息自动滚到最下端）
										--current_in_scroll_down = true
										--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --下分翻页提示
										--已拉到底，删除新消息提示
										--onRemoveNewMessageHint()
									else
										--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下分翻页提示
									end
									
									for i = 1, current_DLCMap_max_num_redpacket, 1 do
										local ctrli = _childUIClip.childUI["DLCMapInfoNode" .. i]
										ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
										ctrli.data.x = ctrli.data.x
										ctrli.data.y = ctrli.data.y + deltaY
									end
								end
								
								--存储本次的位置
								last_click_pos_y_dlcmapinfo_redpacket = touchX
								last_click_pos_y_dlcmapinfo_redpacket = touchY
							end,
							
							--抬起事件
							code = function(self, touchX, touchY, sus)
								--在动画中禁止点击
								if current_is_in_action then
									return
								end
								
								--print("code", touchX, touchY, sus)
								--如果之前在滑动中，那么标记需要自动修正位置
								if click_scroll_dlcmapinfo_redpacket then
									--if (touchX ~= click_pos_x_dlcmapinfo_redpacket) or (touchY ~= click_pos_y_dlcmapinfo_redpacket) then --不是点击事件
										b_need_auto_fixing_dlcmapinfo_redpacket = true
										friction_dlcmapinfo_redpacket = 0
										friction_dlcmapinfo_redpacket_coefficient = 0.5 --衰减系数(默认值)
									--end
								end
								
								--是否选中某个DLC地图面板查看区域内查看tip
								local selectTipIdx = 0
								for i = 1, current_DLCMap_max_num_redpacket, 1 do
									local ctrli = _childUIClip.childUI["DLCMapInfoNode" .. i]
									local cx = ctrli.data.x --中心点x坐标
									local cy = ctrli.data.y --中心点y坐标
									local cw, ch = ctrli.data.w, ctrli.data.h
									local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
									local rx, ry = lx + cw, ly + ch --最右下角坐标
									--print(i, lx, rx, ly, ry, touchX, touchY)
									if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
										selectTipIdx = i
										--print("点击到了哪个DLC地图面板tip的框内" .. i)
										
										break
									end
								end
								
								if (click_scroll_dlcmapinfo_redpacket) and (math.abs(touchY - click_pos_y_dlcmapinfo_redpacket) > 60) then
									selectTipIdx = 0
								end
								
								--点击到某个档位的奖励控件之内
								if (selectTipIdx > 0) then
									--显示tip
									--print(selectTipIdx)
									--模拟点击事件
									--检测是否点到了某些控件里
									local ctrli = _childUIClip.childUI["DLCMapInfoNode" .. selectTipIdx]
									if ctrli then
										local cx = ctrli.data.x --中心点x坐标
										local cy = ctrli.data.y --中心点y坐标
										
										--检测是否点到了奖励控件
										for m = 1, 4, 1 do
											local iconim = ctrli.childUI["rewardIcon_" .. m]
											if iconim then
												local mcx = iconim.data.x --中心点x坐标
												local mcy = iconim.data.y --中心点y坐标
												local mcw, mch = iconim.data.w, iconim.data.h
												local mlx, mly = cx + mcx - mcw / 2, cy  + mcy- mch / 2 --最左上侧坐标
												local mrx, mry = mlx + mcw, mly + mch --最右下角坐标
												--print(i, lx, rx, ly, ry, touchX, touchY)
												if (touchX >= mlx) and (touchX <= mrx) and (touchY >= mly) and (touchY <= mry) then
													--显示各种类型的奖励的tip
													local rewardT = iconim.data.prize
													hApi.ShowRewardTip(rewardT)
												end
											end
										end
										
										--检测是否点到了领奖按钮
										local ctrlI = ctrli.childUI["rewardBtn"]
										if ctrlI then
											if (ctrlI.data.state == 1) then --按钮可点状态
												local bcx = ctrlI.data.x --中心点x坐标
												local bcy = ctrlI.data.y --中心点y坐标
												local bcw, bch = ctrlI.data.w, ctrlI.data.h
												local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
												local brx, bry = blx + bcw, bly + bch --最右下角坐标
												--print(i, lx, rx, ly, ry, touchX, touchY)
												if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
													--print("点击按钮" .. selectTipIdx)
													
													--一开始屏蔽操作
													hUI.NetDisable(30000)
													
													--发起查询，七日连续充值活动的完成状态
													SendCmdFunc["request_activity_sevenday_pay_takereward"](activityId, selectTipIdx)
												end
											end
										end
									end
								end
								
								--标记不用滑动
								click_scroll_dlcmapinfo_redpacket = false
							end,
						})
						_childUINode.childUI["DragPanel"].handle.s:setOpacity(0) --只用于控制，不显示
						
						--依次绘制玩家领取的奖励
						for i = 1, #tReceive, 1 do
							--依次绘制（异步）
							tReceive[i].index = i
							on_create_single_redpacket_record_UI_async(i, tReceive[i])
						end
					end
					
					--函数：绘制单条红包领取记录数据
					on_create_single_redpacket_record_UI = function(index, tRecordI)
						local _frm2 = hGlobal.UI.SendRedPacketFrm
						local _parent2 = _frm2.handle._n
						
						local _childUINode = _frm2.childUI["nodeBack"].childUI["node"]
						local _parentNode = _frm2.childUI["nodeBack"].childUI["node"].handle._n
						local _childUIClip = _frm2.childUI["nodeBack"].childUI["clipnode"]
						local _parentClip = _frm2.childUI["nodeBack"].childUI["clipnode"].handle._n
						
						local redPacketReceiveId = tRecordI.redPacketReceiveId --红包接收唯一id
						local redPacketId = tRecordI.redPacketId --红包唯一id
						local receive_uid = tRecordI.receive_uid --红包接收者uid
						local receive_name = tRecordI.receive_name --红包接收者名字
						local channelId = tRecordI.channelId  --渠道号
						local vipLv = tRecordI.vipLv --vip等级
						local borderId = tRecordI.borderId --边框id
						local iconId = tRecordI.iconId --头像id
						local championId = tRecordI.championId --称号id
						local leaderId = tRecordI.leaderId --会长权限
						local dragonId = tRecordI.dragonId --聊天龙王id
						local headId = tRecordI.headId --头衔id
						local lineId = tRecordI.lineId --线索id
						local msg_id = tRecordI.msg_id --消息id
						local rewardNum = tRecordI.rewardNum --奖励数量
						local reward = tRecordI.reward --奖励信息
						local receive_time = tRecordI.receive_time --红包领取时间
						
						--我的uid
						local uidMe = xlPlayer_GetUID()
						
						local WH = 56
						local OFFSETY = 15
						
						--接收者玩家头像
						local tRoleIcon = hVar.tab_roleicon[iconId]
						if (tRoleIcon == nil) then
							tRoleIcon = hVar.tab_roleicon[0]
						end
						local iconW = tRoleIcon.width
						local iconH = tRoleIcon.height
						local width = WH * iconW / iconH
						local height = WH
						
						--父控件
						local i = index
						_childUIClip.childUI["DLCMapInfoNode" .. i] = hUI.button:new({ --作为按钮只是为了挂载子控件
							parent = _parentClip,
							model = "misk/mask.png",
							x = BOARD_WIDTH/2,
							y = -286 - (i - 1) * (WH + OFFSETY),
							z = 1,
							w = BOARD_WIDTH,
							h = WH + OFFSETY - 1,
						})
						_childUIClip.childUI["DLCMapInfoNode" .. i].handle.s:setOpacity(0) --只挂载子控件，不显示
						
						--接收者玩家头像
						_childUIClip.childUI["DLCMapInfoNode" .. i].childUI["titleImgIconReceive"] = hUI.image:new({
							parent = _childUIClip.childUI["DLCMapInfoNode" .. i].handle._n,
							model = tRoleIcon.icon,
							x = -BOARD_WIDTH/2 + 40,
							y = 0,
							z = 1,
							w = WH,
							h = WH,
						})
						
						--接收者玩家边框
						local tRoleBorder = hVar.tab_roleborder[borderId]
						if (tRoleBorder == nil) then
							tRoleBorder = hVar.tab_roleborder[0]
						end
						local iconW = tRoleBorder.width
						local iconH = tRoleBorder.height
						local width = WH * iconW / iconH
						local height = WH
						_childUIClip.childUI["DLCMapInfoNode" .. i].childUI["titleImgBorderReceive"] = hUI.image:new({
							parent = _childUIClip.childUI["DLCMapInfoNode" .. i].handle._n,
							model = tRoleBorder.icon,
							x = -BOARD_WIDTH/2 + 40,
							y = 0,
							z = 1,
							w = WH,
							h = WH,
						})
						
						--接收者玩家名
						_childUIClip.childUI["DLCMapInfoNode" .. i].childUI["titleLabelReceive"] = hUI.label:new({
							parent = _childUIClip.childUI["DLCMapInfoNode" .. i].handle._n,
							size = 22,
							font = hVar.FONTC,
							border = 1,
							align = "LC",
							x = -BOARD_WIDTH/2 + 75,
							y = 11,
							z = 1,
							width = 500,
							text = tostring(receive_name),
						})
						--接收者玩家名颜色
						if (uidMe == receive_uid) then --我
							_childUIClip.childUI["DLCMapInfoNode" .. i].childUI["titleLabelReceive"].handle.s:setColor(ccc3(0, 255, 0)) --绿色
						else
							_childUIClip.childUI["DLCMapInfoNode" .. i].childUI["titleLabelReceive"].handle.s:setColor(ccc3(255, 255, 168)) --淡黄色
						end
						
						--如果是我，显示已领取
						if (uidMe == receive_uid) then --我
							--已领取
							_childUIClip.childUI["DLCMapInfoNode" .. i].childUI["titleImgBorderReceive"] = hUI.image:new({
								parent = _childUIClip.childUI["DLCMapInfoNode" .. i].handle._n,
								model = "UI:FinishTag",
								x = 100,
								y = 0,
								z = 1,
								scale = 0.9,
							})
						end
						
						--接收者领取红包时间
						--日期
						local year = string.sub(receive_time, 1, 4)
						local month = string.sub(receive_time, 6, 7)
						local day = string.sub(receive_time, 9, 10)
						local hour = string.sub(receive_time, 12, 13)
						local minute = string.sub(receive_time,15, 16)
						local second = string.sub(receive_time, 18, 19)
						
						--检测日期是否为今日
						--客户端的时间
						local localTime = os.time()
						--服务器的时间
						local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
						--转化为北京时间
						local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
						local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
						hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
						local nowDate = os.date("%Y-%m-%d %H:%M:%S", hostTime)
						local yearNow = string.sub(nowDate, 1, 4)
						local monthNow = string.sub(nowDate, 6, 7)
						local dayNow = string.sub(nowDate, 9, 10)
						
						local showDate = ""
						if (year == yearNow) and (month == monthNow) and (day == dayNow) then --今日
							showDate = string.sub(receive_time, 12, 19)
						elseif (year == yearNow) then --今年
							showDate = month .. "-" .. day .. " " .. string.sub(receive_time, 12, 19)
						else --去年
							showDate = year .. "-" .. month .. "-" .. day .. " " .. string.sub(receive_time, 12, 19)
						end
						_childUIClip.childUI["DLCMapInfoNode" .. i].childUI["titleTimeReceive"] = hUI.label:new({
							parent = _childUIClip.childUI["DLCMapInfoNode" .. i].handle._n,
							size = 18,
							font = hVar.FONTC,
							border = 1,
							align = "LC",
							x = -BOARD_WIDTH/2 + 75,
							y = -16,
							z = 1,
							width = 500,
							text = showDate,
							RGB = {255, 255, 255,},
						})
						
						--绘制奖励
						local rewardDx = 64
						local scale = 1.2
						for m = 1, #reward, 1 do
							local rewardT = reward[m]
							local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
							
							--奖励物品的图标按钮（只用于响应事件，不显示）
							_childUIClip.childUI["DLCMapInfoNode" .. i].childUI["rewardIcon_" .. m] = hUI.button:new({
								parent = _childUIClip.childUI["DLCMapInfoNode" .. i].handle._n,
								model = "misc/mask.png",
								x = -BOARD_WIDTH/2 + 375 + (m - 1) * rewardDx,
								y = 0,
								z = 1,
								w = 72,
								h = 72,
								--scaleT = 0.95,
								--dragbox = _frm2.childUI["dragBox"],
								--code = function()
								--	--显示各种类型的奖励的tip
								--	hApi.ShowRewardTip(rewardT)
								--end,
							})
							_childUIClip.childUI["DLCMapInfoNode" .. i].childUI["rewardIcon_" .. m].data.prize = rewardT --存储奖励数据
							_childUIClip.childUI["DLCMapInfoNode" .. i].childUI["rewardIcon_" .. m].handle.s:setOpacity(0) --默认不显示（只用于响应事件，不显示）
							
							--物品图标
							_childUIClip.childUI["DLCMapInfoNode" .. i].childUI["rewardIcon_" .. m].childUI["icon"] = hUI.image:new({
								parent = _childUIClip.childUI["DLCMapInfoNode" .. i].childUI["rewardIcon_" .. m].handle._n,
								model = tmpModel,
								x = 0,
								y = 0,
								w = itemWidth * scale,
								h = itemHeight * scale,
							})
							
							--绘制奖励图标的子控件
							if sub_tmpModel then
								_childUIClip.childUI["DLCMapInfoNode" .. i].childUI["rewardIcon_" .. m].childUI["subIcon"] = hUI.image:new({
									parent = _childUIClip.childUI["DLCMapInfoNode" .. i].childUI["rewardIcon_" .. m].handle._n,
									model = sub_tmpModel,
									x = sub_pos_x * scale,
									y = sub_pos_y * scale,
									w = sub_pos_w * scale,
									h = sub_pos_h * scale,
								})
							end
							
							--绘制奖励的数量
							local strRewardNum = "+" .. itemNum
							
							--[[
							--测试 --test
							strRewardNum = "+0000"
							]]
							
							local rewardNumLength = #strRewardNum
							local rewardNumFont = "numWhite" --字体
							local rewardNumFontSize = 20 --字体大小
							local rewardNumBorder = 0 --是否显示边框
							if (rewardNumLength == 3) then
								rewardNumFont = "numWhite" --字体
								rewardNumFontSize = 18 --字体大小
								rewardNumBorder = 0 --是否显示边框
							elseif (rewardNumLength == 4) then
								rewardNumFont = "numWhite" --字体
								rewardNumFontSize = 16 --字体大小
								rewardNumBorder = 0 --是否显示边框
							elseif (rewardNumLength == 5) then
								rewardNumFont = "numWhite" --字体
								rewardNumFontSize = 14 --字体大小
								rewardNumBorder = 0 --是否显示边框
							elseif (rewardNumLength >= 6) then
								rewardNumFont = hVar.FONTC --字体
								rewardNumFontSize = 12 --字体大小
								rewardNumBorder = 1 --是否显示边框
							end
							
							_childUIClip.childUI["DLCMapInfoNode" .. i].childUI["rewardIcon_" .. m].childUI["num"] = hUI.label:new({
								parent = _childUIClip.childUI["DLCMapInfoNode" .. i].childUI["rewardIcon_" .. m].handle._n,
								size = rewardNumFontSize,
								x = 0,
								y = -16,
								width = 500,
								align = "MC",
								font = rewardNumFont,
								text = strRewardNum,
								border = rewardNumBorder,
							})
						end
						
						--分界线
						_childUIClip.childUI["DLCMapInfoNode" .. i].childUI["titleImgSeparateLineReceive"] = hUI.image:new({
							parent = _childUIClip.childUI["DLCMapInfoNode" .. i].handle._n,
							model = "misc/rank_line.png",
							x = 0,
							y = -35,
							z = 1,
							w = BOARD_WIDTH - 10,
							h = 2,
						})
						_childUIClip.childUI["DLCMapInfoNode" .. i].childUI["titleImgSeparateLineReceive"].handle.s:setOpacity(64)
						
						---------------------------------------------------------------------
						--可能存在滑动，校对前一个控件的相对位置
						if _childUIClip.childUI["DLCMapInfoNode" .. (index - 1)] then --前一个
							--实际相对距离
							local lastX = _childUIClip.childUI["DLCMapInfoNode" .. (index - 1)].data.x
							local lastY = _childUIClip.childUI["DLCMapInfoNode" .. (index - 1)].data.y
							local lastChatHeight = (WH + OFFSETY)
							
							--理论相对距离
							local thisX = lastX
							local thisY = lastY - lastChatHeight
							local ctrli = _childUIClip.childUI["DLCMapInfoNode" .. index]
							ctrli.handle._n:setPosition(thisX, thisY)
							ctrli.data.x = thisX
							ctrli.data.y = thisY
						end
					end
					
					--函数：异步绘制单条红包领取记录数据（异步）
					on_create_single_redpacket_record_UI_async = function(index, tRecordI)
						local _frm2 = hGlobal.UI.SendRedPacketFrm
						local _parent2 = _frm2.handle._n
						
						local _childUINode = _frm2.childUI["nodeBack"].childUI["node"]
						local _parentNode = _frm2.childUI["nodeBack"].childUI["node"].handle._n
						local _childUIClip = _frm2.childUI["nodeBack"].childUI["clipnode"]
						local _parentClip = _frm2.childUI["nodeBack"].childUI["clipnode"].handle._n
						
						local redPacketReceiveId = tRecordI.redPacketReceiveId --红包接收唯一id
						local redPacketId = tRecordI.redPacketId --红包唯一id
						local receive_uid = tRecordI.receive_uid --红包接收者uid
						local receive_name = tRecordI.receive_name --红包接收者名字
						local channelId = tRecordI.channelId  --渠道号
						local vipLv = tRecordI.vipLv --vip等级
						local borderId = tRecordI.borderId --边框id
						local iconId = tRecordI.iconId --头像id
						local championId = tRecordI.championId --称号id
						local leaderId = tRecordI.leaderId --会长权限
						local dragonId = tRecordI.dragonId --聊天龙王id
						local headId = tRecordI.headId --头衔id
						local lineId = tRecordI.lineId --线索id
						local msg_id = tRecordI.msg_id --消息id
						local rewardNum = tRecordI.rewardNum --奖励数量
						local reward = tRecordI.reward --奖励信息
						local receive_time = tRecordI.receive_time --红包领取时间
						
						--我的uid
						local uidMe = xlPlayer_GetUID()
						
						local WH = 56
						local OFFSETY = 15
						
						--接收者玩家头像
						local tRoleIcon = hVar.tab_roleicon[iconId]
						if (tRoleIcon == nil) then
							tRoleIcon = hVar.tab_roleicon[0]
						end
						local iconW = tRoleIcon.width
						local iconH = tRoleIcon.height
						local width = WH * iconW / iconH
						local height = WH
						
						--父控件
						local i = index
						_childUIClip.childUI["DLCMapInfoNode" .. i] = hUI.button:new({ --作为按钮只是为了挂载子控件
							parent = _parentClip,
							model = "misk/mask.png",
							x = BOARD_WIDTH/2,
							y = -286 - (i - 1) * (WH + OFFSETY),
							z = 1,
							w = BOARD_WIDTH,
							h = WH + OFFSETY - 1,
						})
						_childUIClip.childUI["DLCMapInfoNode" .. i].handle.s:setOpacity(0) --只挂载子控件，不显示
						
						--存储异步待绘制红包消息列表
						current_async_paint_list_redpacket[index] = tRecordI
					end
					
					--函数：获得第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离
					getUpDownOffset_redpacket = function()
						local _frm2 = hGlobal.UI.SendRedPacketFrm
						local _parent2 = _frm2.handle._n
						local _childUIClip = _frm2.childUI["nodeBack"].childUI["clipnode"]
						
						--第一个DLC地图面板的数据
						local DLCMapInfoBtn1 = _childUIClip.childUI["DLCMapInfoNode1"]
						local btn1_cx, btn1_cy = 0, 0 --第一个DLC地图面板中心点位置
						local btn1_ly = 0 --第一个DLC地图面板最上侧的x坐标
						local delta1_ly = 0 --第一个DLC地图面板距离上侧边界的距离
						btn1_cx, btn1_cy = DLCMapInfoBtn1.data.x, DLCMapInfoBtn1.data.y --第一个DLC地图面板中心点位置
						btn1_ly = btn1_cy + WEAPON_HEIGHT / 2 --第一个DLC地图面板最上侧的x坐标
						delta1_ly = btn1_ly + 241 --第一个DLC地图面板距离上侧边界的距离
						
						--最后一个DLC地图面板的数据
						local DLCMapInfoBtnN = _childUIClip.childUI["DLCMapInfoNode" .. current_DLCMap_max_num_redpacket]
						local btnN_cx, btnN_cy = 0, 0 --最后一个DLC地图面板中心点位置
						local btnN_ry = 0 --最后一个DLC地图面板最下侧的x坐标
						local deltNa_ry = 0 --最后一个DLC地图面板距离下侧边界的距离
						btnN_cx, btnN_cy = DLCMapInfoBtnN.data.x, DLCMapInfoBtnN.data.y --最后一个DLC地图面板中心点位置
						btnN_ry = btnN_cy - WEAPON_HEIGHT / 2 --最后一个DLC地图面板最下侧的x坐标
						deltNa_ry = btnN_ry + 584 --最后一个DLC地图面板距离下侧边界的距离
						--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
						
						return delta1_ly, deltNa_ry
					end
					
					--异步绘制红包领取记录条目的timer
					refresh_async_paint_redpacket_record_loop = function()
						local _frm2 = hGlobal.UI.SendRedPacketFrm
						local _parent2 = _frm2.handle._n
						local _childUIClip = _frm2.childUI["nodeBack"].childUI["clipnode"]
						
						--如果待异步绘制表里有内容，逐一绘制
						if (#current_async_paint_list_redpacket > 0) then
							local loopCount = ASYNC_PAINTNUM_ONCE_REDPACKET
							if (loopCount > #current_async_paint_list_redpacket) then
								loopCount = #current_async_paint_list_redpacket
							end
							
							--一次绘制多条
							for loop = 1, loopCount, 1 do
								--取第一项
								local pivot = 1
								local tRecordI = current_async_paint_list_redpacket[pivot]
								local index = tRecordI.index
								
								--先删除虚控件
								hApi.safeRemoveT(_childUIClip.childUI, "DLCMapInfoNode" .. index)
								
								--再创建实体控件
								on_create_single_redpacket_record_UI(index, tRecordI)
								
								table.remove(current_async_paint_list_redpacket, pivot)
							end
						end
					end
					
					--刷新支付（土豪）红包的领取详情列表滚动
					refresh_dlcmapinfo_viewdetail_redpacket_UI_loop = function()
						--如果当前在动画中，不用处理
						--if (ANIM_IN_ACTION == 1) then
						--	return
						--end
						local _frm2 = hGlobal.UI.SendRedPacketFrm
						local _parent2 = _frm2.handle._n
						local _childUIClip = _frm2.childUI["nodeBack"].childUI["clipnode"]
						
						local SPEED = 50 --速度
						--print(b_need_auto_fixing_dlcmapinfo_redpacket)
						
						if b_need_auto_fixing_dlcmapinfo_redpacket then
							---第一个DLC地图面板的数据
							local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
							local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
							delta1_ly, deltNa_ry = getUpDownOffset_redpacket()
							--print(delta1_ly, deltNa_ry)
							--delta1_ly +:在下底线之上 /-:在下底线之下
							--deltNa_ry +:在下底线之上 /-:在下底线之下
							
							--print("delta1_ly=" .. delta1_ly, ", deltNa_rx=" .. deltNa_rx)
							--如果第一个DLC地图面板的头像跑到下边，那么优先将第一个DLC地图面板头像贴边
							if (delta1_ly < 0) then
								--print("优先将第一个DLC地图面板头像贴边")
								--需要修正
								--不会选中DLC地图面板
								selected_dlcmapinfoEx_idx_redpacket = 0 --选中的DLC地图面板索引
								
								--没有惯性
								draggle_speed_y_dlcmapinfo_redpacket = 0
								
								local speed = SPEED
								if ((delta1_ly + speed) > 0) then --防止走过
									speed = -delta1_ly
									delta1_ly = 0
								end
								
								--每个按钮向上侧做运动
								for i = 1, current_DLCMap_max_num_redpacket, 1 do
									local ctrli = _childUIClip.childUI["DLCMapInfoNode" .. i]
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
								--_childUIClip.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --上翻页提示
								--_childUIClip.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下翻页提示
							elseif (delta1_ly ~= 0) and (deltNa_ry > 0) then --第一个头像没有贴上侧，并且最后一个头像没有贴下侧，那么再将最后一个DLC地图面板头像贴边
								--print("将最后一个DLC地图面板头像贴边")
								--需要修正
								--不会选中DLC地图面板
								selected_dlcmapinfoEx_idx_redpacket = 0 --选中的DLC地图面板索引
								
								--没有惯性
								draggle_speed_y_dlcmapinfo_redpacket = 0
								
								local speed = SPEED
								if ((deltNa_ry - speed) < 0) then --防止走过
									speed = deltNa_ry
									deltNa_ry = 0
								end
								
								--每个按钮向下侧做运动
								for i = 1, current_DLCMap_max_num_redpacket, 1 do
								local ctrli = _childUIClip.childUI["DLCMapInfoNode" .. i]
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
								--_childUIClip.childUI["DLCMapInfoPageUp"].handle.s:setVisible(true) --上分翻页提示
								--_childUIClip.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --下分翻页不提示
							elseif (draggle_speed_y_dlcmapinfo_redpacket ~= 0) then --沿着当前的速度方向有惯性地运动一会
								--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_y_dlcmapinfo_redpacket)
								--不会选中DLC地图面板
								selected_dlcmapinfoEx_idx_redpacket = 0 --选中的DLC地图面板索引
								--print("    ->   draggle_speed_y_dlcmapinfo_redpacket=", draggle_speed_y_dlcmapinfo_redpacket)
								
								if (draggle_speed_y_dlcmapinfo_redpacket > 0) then --朝上运动
									local speed = (draggle_speed_y_dlcmapinfo_redpacket) * 1.0 --系数
									friction_dlcmapinfo_redpacket = friction_dlcmapinfo_redpacket - friction_dlcmapinfo_redpacket_coefficient
									draggle_speed_y_dlcmapinfo_redpacket = draggle_speed_y_dlcmapinfo_redpacket + friction_dlcmapinfo_redpacket --衰减（正）
									
									if (draggle_speed_y_dlcmapinfo_redpacket < 0) then
										draggle_speed_y_dlcmapinfo_redpacket = 0
									end
									
									--最后一个DLC地图面板的坐标不能跑到最下侧的上边去
									if ((deltNa_ry + speed) > 0) then --防止走过
										speed = -deltNa_ry
										deltNa_ry = 0
										
										--没有惯性
										draggle_speed_y_dlcmapinfo_redpacket = 0
									end
									
									--每个按钮向上侧做运动
									for i = 1, current_DLCMap_max_num_redpacket, 1 do
										local ctrli = _childUIClip.childUI["DLCMapInfoNode" .. i]
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
								elseif (draggle_speed_y_dlcmapinfo_redpacket < 0) then --朝下运动
									local speed = (draggle_speed_y_dlcmapinfo_redpacket) * 1.0 --系数
									friction_dlcmapinfo_redpacket = friction_dlcmapinfo_redpacket + friction_dlcmapinfo_redpacket_coefficient
									draggle_speed_y_dlcmapinfo_redpacket = draggle_speed_y_dlcmapinfo_redpacket + friction_dlcmapinfo_redpacket --衰减（负）
									
									if (draggle_speed_y_dlcmapinfo_redpacket > 0) then
										draggle_speed_y_dlcmapinfo_redpacket = 0
									end
									
									--第一个DLC地图面板的坐标不能跑到最上侧的下边去
									if ((delta1_ly + speed) < 0) then --防止走过
										speed = -delta1_ly
										delta1_ly = 0
										
										--没有惯性
										draggle_speed_y_dlcmapinfo_redpacket = 0
									end
									
									--每个按钮向下侧做运动
									for i = 1, current_DLCMap_max_num_redpacket, 1 do
										local ctrli = _childUIClip.childUI["DLCMapInfoNode" .. i]
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
									--_childUIClip.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --上分翻页提示
								else
									--_childUIClip.childUI["DLCMapInfoPageUp"].handle.s:setVisible(true) --上分翻页提示
								end
								if (deltNa_ry == 0) then
									--_childUIClip.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --下分翻页提示
								else
									--_childUIClip.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下分翻页提示
								end
							else --停止运动
								b_need_auto_fixing_dlcmapinfo_redpacket = false
								friction_dlcmapinfo_redpacket = 0
								friction_dlcmapinfo_redpacket_coefficient = 0.5 --衰减系数(默认值)
							end
						end
					end
					
					--添加监听：收到领取支付（土豪）红包结果结果
					hGlobal.event:listen("LocalEvent_OnReceivePayRedPacketResult", "ReceivePayRedPacketResult", on_receive_takereward_pay_redpacket_event)
					--添加监听：收到查看支付（土豪）红包的领取详情结果
					hGlobal.event:listen("LocalEvent_ViewDetailPayRedPacketResult", "ViewDetailPayRedPacketResult", on_receive_viewdetail_pay_redpacket_event)
					
					--创建timer，刷新支付（土豪）红包的领取详情列表滚动
					hApi.addTimerForever("__VIEWDETAIL_PAY_REDPACKET_LIST__", hVar.TIMER_MODE.GAMETIME, 30, refresh_dlcmapinfo_viewdetail_redpacket_UI_loop)
					--异步绘制红包领取记录条目的timer
					hApi.addTimerForever("__PAY_REDPACKET_CHANGE_ASYNC_TIMER__", hVar.TIMER_MODE.GAMETIME, 1, refresh_async_paint_redpacket_record_loop)
					
					------------------------------------------------------
					--立即刷新本界面
					local uidMe = xlPlayer_GetUID()
					local bRewardMe = redPacketReceiveList[uidMe]
					--红包剩余数量
					local lefenum = send_num - receive_num
					if (lefenum <= 0) then --已被全部领完
						--刷新已领取界面
						on_upddate_redpacket_received_ui()
					elseif bRewardMe then --我已领取
						--刷新已领取界面
						on_upddate_redpacket_received_ui()
					else --未领取
						--不处理
						--...
					end
				end
			end
		end
	end
	
	--函数：点击军团红包按钮
	OnClickGroupRedPacketBtn = function(selectTipIdxRedpacket)
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--红包消息i
		local ctrlI = _frmNode.childUI["DLCMapInfoNode" .. selectTipIdxRedpacket]
		if ctrlI then
			local msgIdi = ctrlI.data.msgId
			local tMsg = current_chat_msg_hostory_cache_group[msgIdi]
			if tMsg then
				local msgId = tMsg.id --消息id
				local chatType = tMsg.chatType --聊天频道
				local msgType = tMsg.msgType --消息类型
				if (msgType == hVar.MESSAGE_TYPE.TEXT_SYSTEM_GROUP_REDPACKET_SEND) then --军团发红包
					local uid = tMsg.uid --消息发送者uid
					local name = tMsg.name --玩家名
					local channelId = tMsg.channelId --渠道号
					local vip = tMsg.vip --vip等级
					local borderId = tMsg.borderId --边框id
					local iconId = tMsg.iconId --头像id
					local championId = tMsg.championId --称号id
					local leaderId = tMsg.leaderId --会长权限
					local dragonId = tMsg.dragonId --聊天龙王id
					local headId = tMsg.headId --头衔id
					local lineId = tMsg.lineId --线索id
					local date = tMsg.date --日期
					local content = tMsg.content --聊天内容
					local touid = tMsg.touid --接收者uid
					local result = tMsg.result --可交互类型消息的操作结果
					local resultParam = tMsg.resultParam --可交互类型消息的参数
					local redPacketParam = tMsg.redPacketParam --红包消息参数
					
					--军团红包的红包参数信息
					local redPacketId = redPacketParam.redPacketId --红包唯一id
					local send_uid = redPacketParam.send_uid --红包发送者uid
					local send_name = redPacketParam.send_name --红包发送者名字
					local group_id = redPacketParam.group_id --红包军团id
					local send_num = redPacketParam.send_num --红包发送数量
					local content = redPacketParam.content --内容
					local coin = redPacketParam.coin --游戏币
					local order_id = redPacketParam.order_id --订单号
					local msg_id = redPacketParam.msg_id --消息id
					local receive_num = redPacketParam.receive_num --红包接收数量
					local send_time = redPacketParam.send_time --红包发送时间
					local expire_time = redPacketParam.expire_time --红包过期时间
					local redPacketReceiveList = redPacketParam.redPacketReceiveList --红包领取uid列表
					
					--红包剩余数量
					local lefenum = send_num - receive_num
					
					local uidMe = xlPlayer_GetUID()
					local bRewardMe = redPacketReceiveList[uidMe]
					
					if (lefenum <= 0) then --已被全部领完
						--不处理
						--...
					elseif bRewardMe then --我已领取
						--不处理
						--请求领取红包
						--local msgId = ctrlI.data.msgId
						--print(group_id, redPacketId)
						--SendGroupCmdFunc["receive_group_redpacket"](group_id, redPacketId)
					else --未领取
						--请求领取红包
						local msgId = ctrlI.data.msgId
						--print(group_id, redPacketId)
						SendGroupCmdFunc["receive_group_redpacket"](group_id, redPacketId)
					end
				end
			end
		end
	end
	
	--函数：刷新世界聊天界面滚动的timer
	refresh_chatframe_scroll_world_loop = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local SPEED = 50 --速度
		--print(b_need_auto_fixing_dlcmapinfo)
		
		if b_need_auto_fixing_dlcmapinfo then
			--[[
			--第一个DLC地图面板的数据
			local DLCMapInfoBtn1 = _frmNode.childUI["DLCMapInfoNode1"]
			local btn1_cx, btn1_cy = 0, 0 --第一个DLC地图面板中心点位置
			local btn1_ly = 0 --第一个DLC地图面板最上侧的x坐标
			local delta1_ly = 0 --第一个DLC地图面板距离上侧边界的距离
			btn1_cx, btn1_cy = DLCMapInfoBtn1.data.x, DLCMapInfoBtn1.data.y --第一个DLC地图面板中心点位置
			btn1_ly = btn1_cy + WEAPON_HEIGHT / 2 --第一个DLC地图面板最上侧的x坐标
			delta1_ly = btn1_ly + 49 --第一个DLC地图面板距离上侧边界的距离
			
			--最后一个DLC地图面板的数据
			local DLCMapInfoBtnN = _frmNode.childUI["DLCMapInfoNode" .. current_DLCMap_max_num]
			local btnN_cx, btnN_cy = 0, 0 --最后一个DLC地图面板中心点位置
			local btnN_ry = 0 --最后一个DLC地图面板最下侧的x坐标
			local deltNa_ry = 0 --最后一个DLC地图面板距离下侧边界的距离
			btnN_cx, btnN_cy = DLCMapInfoBtnN.data.x, DLCMapInfoBtnN.data.y --最后一个DLC地图面板中心点位置
			btnN_ry = btnN_cy - DLCMapInfoBtnN.data.chatHeight - WEAPON_HEIGHT / 2 --最后一个DLC地图面板最下侧的x坐标
			deltNa_ry = btnN_ry + (hVar.SCREEN.h + 1) --最后一个DLC地图面板距离下侧边界的距离
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
				
				--更新滚动条的进度
				local progressMax = delta1_ly - deltNa_ry
				local progressNow = delta1_ly
				local height = _frmNode.childUI["ScrollBar"].data.w - _frmNode.childUI["ScrollBarProgress"].data.h --h
				local scrollX = _frmNode.childUI["ScrollBarProgress"].data.x
				local scrollY = _frmNode.childUI["ScrollBar"].data.y + (1 - progressNow / progressMax) * height - height / 2
				_frmNode.childUI["ScrollBarProgress"]:setXY(scrollX, scrollY)
				
				--上滑动翻页不显示，下滑动翻页显示
				--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --上翻页提示
				--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下翻页提示
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
				
				--更新滚动条的进度
				local progressMax = delta1_ly - deltNa_ry
				local progressNow = delta1_ly
				local height = _frmNode.childUI["ScrollBar"].data.w - _frmNode.childUI["ScrollBarProgress"].data.h --h
				local scrollX = _frmNode.childUI["ScrollBarProgress"].data.x
				local scrollY = _frmNode.childUI["ScrollBar"].data.y + (1 - progressNow / progressMax) * height - height / 2
				_frmNode.childUI["ScrollBarProgress"]:setXY(scrollX, scrollY)
				
				--上滑动翻页显示，下滑动翻页不显示
				--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(true) --上分翻页提示
				--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --下分翻页不提示
				--已拉到底，删除新消息提示
				onRemoveNewMessageHint()
			elseif (draggle_speed_y_dlcmapinfo ~= 0) then --沿着当前的速度方向有惯性地运动一会
				--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_y_dlcmapinfo)
				--不会选中DLC地图面板
				selected_dlcmapinfoEx_idx = 0 --选中的DLC地图面板索引
				--print("    ->   draggle_speed_y_dlcmapinfo=", draggle_speed_y_dlcmapinfo)
				
				if (draggle_speed_y_dlcmapinfo > 0) then --朝上运动
					local speed = (draggle_speed_y_dlcmapinfo) * 1.0 --系数
					friction_dlcmapinfo = friction_dlcmapinfo - friction_dlcmapinfo_coefficient
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
						
						--已到底部，标记下拉到底部（为true时有新消息自动滚到最下端）
						--current_in_scroll_down = true
					end
					
					--每个按钮向上侧做运动
					for i = 1, current_DLCMap_max_num, 1 do
						local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
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
					
					--更新滚动条的进度
					local progressMax = delta1_ly - deltNa_ry
					local progressNow = delta1_ly
					local height = _frmNode.childUI["ScrollBar"].data.w - _frmNode.childUI["ScrollBarProgress"].data.h --h
					local scrollX = _frmNode.childUI["ScrollBarProgress"].data.x
					local scrollY = _frmNode.childUI["ScrollBar"].data.y + (1 - progressNow / progressMax) * height - height / 2
					_frmNode.childUI["ScrollBarProgress"]:setXY(scrollX, scrollY)
				elseif (draggle_speed_y_dlcmapinfo < 0) then --朝下运动
					local speed = (draggle_speed_y_dlcmapinfo) * 1.0 --系数
					friction_dlcmapinfo = friction_dlcmapinfo + friction_dlcmapinfo_coefficient
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
					
					--更新滚动条的进度
					local progressMax = delta1_ly - deltNa_ry
					local progressNow = delta1_ly
					local height = _frmNode.childUI["ScrollBar"].data.w - _frmNode.childUI["ScrollBarProgress"].data.h --h
					local scrollX = _frmNode.childUI["ScrollBarProgress"].data.x
					local scrollY = _frmNode.childUI["ScrollBar"].data.y + (1 - progressNow / progressMax) * height - height / 2
					_frmNode.childUI["ScrollBarProgress"]:setXY(scrollX, scrollY)
				end
				
				--上滑动翻页显示，下滑动翻页显示
				if (delta1_ly == 0) then
					--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --上分翻页提示
				else
					--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(true) --上分翻页提示
				end
				if (deltNa_ry == 0) then
					--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --下分翻页提示
					--隐藏滚动条
					--_frmNode.childUI["ScrollBar"]:setstate(-1)
					onHideScrollBarHint()
					
					--已拉到底，删除新消息提示
					onRemoveNewMessageHint()
				else
					--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下分翻页提示
				end
			else --停止运动
				b_need_auto_fixing_dlcmapinfo = false
				friction_dlcmapinfo = 0
				friction_dlcmapinfo_coefficient = 0.5 --衰减系数(默认值)
				
				--隐藏滚动条
				--_frmNode.childUI["ScrollBar"]:setstate(-1)
				onHideScrollBarHint()
			end
			
			--[[
			--更新滚动条的进度
			local progressMax = delta1_ly - deltNa_ry
			local progressNow = delta1_ly
			local height = _frmNode.childUI["ScrollBar"].data.w - _frmNode.childUI["ScrollBarProgress"].data.h --h
			local scrollX = _frmNode.childUI["ScrollBarProgress"].data.x
			local scrollY = _frmNode.childUI["ScrollBar"].data.y + (1 - progressNow / progressMax) * height - height / 2
			_frmNode.childUI["ScrollBarProgress"]:setXY(scrollX, scrollY)
			]]
		end
	end
	
	--函数：刷新邀请聊天界面滚动的timer
	refresh_chatframe_scroll_invite_loop = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		local _frm = hGlobal.UI.ChatDialogueFrm
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
		
		--刷新邀请函的倒计时
		for i = 1, current_DLCMap_max_num, 1 do
			local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
			if ctrli then
				local msgId = ctrli.data.msgId
				if (msgId > 0) then
					local tChatMsg = current_chat_msg_hostory_cache_invite[msgId]
					if tChatMsg then
						local redPacketParam = tChatMsg.redPacketParam --军团邀请函消息参数
						if redPacketParam then
							--计算军团邀请函剩余有效时间
							local groupLevel = redPacketParam.groupLevel --军团主城等级
							local groupMember = redPacketParam.groupMember --军团当前成员人数
							local groupMemberMax = redPacketParam.groupMemberMax --军团总人数
							local expire_time = redPacketParam.expire_time --军团邀请函过期时间
							local nExpireTime = hApi.GetNewDate(expire_time, "DAY", 0) --过期的时间戳
							local deltaSeconds = nExpireTime - hostTime --秒数
							if (deltaSeconds < 0) then
								deltaSeconds = 0
							end
							local hour = math.floor(deltaSeconds / 3600) --时
							local minute = math.floor((deltaSeconds - hour * 3600)/ 60) --分
							local second = deltaSeconds - hour * 3600 - minute * 60 --秒
							
							--拼接字符串
							local szHour = tostring(hour) --时(字符串)
							if (#szHour < 2) then
								szHour = "0" .. szHour
							end
							local szMinute = tostring(minute) --分(字符串)
							if (#szMinute < 2) then
								szMinute = "0" .. szMinute
							end
							local szSecond = tostring(second) --秒(字符串)
							if (#szSecond < 2) then
								szSecond = "0" .. szSecond
							end
							
							--主城等级
							if ctrli.childUI["GroupLv"] then
								ctrli.childUI["GroupLv"]:setText("Lv " .. groupLevel)
							end
							
							--军团人数
							if ctrli.childUI["GroupNumLabel"] then
								ctrli.childUI["GroupNumLabel"]:setText(tostring(groupMember)  .. "/" .. tostring(groupMemberMax))
							end
							
							--倒计时
							if ctrli.childUI["LeftTimeLabel"] then
								ctrli.childUI["LeftTimeLabel"]:setText(szHour .. ":" .. szMinute .. ":" .. szSecond)
							end
						end
					end
				end
			end
		end
	end
	
	--函数：刷新私聊好友界面滚动的timer
	refresh_chatframe_scroll_private_loop = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local SPEED = 50 --速度
		--print(b_need_auto_fixing_dlcmapinfo)
		
		if b_need_auto_fixing_friendinfo then
			--检测是否滑动到了最左部或最右部
			local delta1_lx = 0 --第一个DLC地图面板最上侧的y坐标
			local deltNa_rx = 0 --最后一个DLC地图面板最下侧的y坐标
			delta1_lx, deltNa_rx = getLeftRightOffset()
			--print(delta1_lx, deltNa_rx)
			--delta1_lx +:在左底线之右 /-:在左底线之左
			--deltNa_rx +:在右底线之右 /-:在右底线之左
			
			--print("delta1_lx=" .. delta1_lx, ", deltNa_rx=" .. deltNa_rx)
			--如果第一个DLC地图面板的头像跑到右边，那么优先将第一个DLC地图面板头像贴边
			if (delta1_lx > 0) then
				--print("优先将第一个DLC地图面板头像贴边")
				--需要修正
				--不会选中DLC地图面板
				selected_friendinfoEx_idx = 0 --选中的DLC地图面板索引
				
				--没有惯性
				draggle_speed_x_friendinfo = 0
				
				local speed = -SPEED
				if ((delta1_lx + speed) < 0) then --防止走过
					speed = -delta1_lx
					delta1_lx = 0
				end
				
				--每个按钮向左侧做运动
				for i = 1, current_DLCMap_friend_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNodeFriend" .. i]
				--if (ctrli.data.selected == 0) then --只处理未选中的DLC地图面板卡牌
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x + speed, pos_y
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				--end
				end
				
				--上滑动翻页不显示，下滑动翻页显示
				--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --上翻页提示
				--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下翻页提示
			elseif (delta1_lx ~= 0) and (deltNa_rx < 0) then --第一个头像没有贴左侧，并且最后一个头像没有贴右侧，那么再将最后一个DLC地图面板头像贴边
				--print("将最后一个DLC地图面板头像贴边")
				--需要修正
				--不会选中DLC地图面板
				selected_friendinfoEx_idx = 0 --选中的DLC地图面板索引
				
				--没有惯性
				draggle_speed_x_friendinfo = 0
				
				local speed = SPEED
				if ((deltNa_rx + speed) > 0) then --防止走过
					speed = -deltNa_rx
					deltNa_rx = 0
				end
				
				--每个按钮向右侧做运动
				for i = 1, current_DLCMap_friend_max_num, 1 do
				local ctrli = _frmNode.childUI["DLCMapInfoNodeFriend" .. i]
				--if (ctrli.data.selected == 0) then --只处理未选中的DLC地图面板卡牌
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x + speed, pos_y
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				--end
				end
				
				--上滑动翻页显示，下滑动翻页不显示
				--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(true) --上分翻页提示
				--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --下分翻页不提示
				--已拉到底，删除新消息提示
				--onRemoveNewMessageHint()
			elseif (draggle_speed_x_friendinfo ~= 0) then --沿着当前的速度方向有惯性地运动一会
				--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_x_friendinfo)
				--不会选中DLC地图面板
				selected_friendinfoEx_idx = 0 --选中的DLC地图面板索引
				--print("    ->   draggle_speed_x_friendinfo=", draggle_speed_x_friendinfo)
				
				if (draggle_speed_x_friendinfo > 0) then --朝右运动
					local speed = (draggle_speed_x_friendinfo) * 1.0 --系数
					friction_friendinfo = friction_friendinfo - friction_friendinfo_coefficient
					draggle_speed_x_friendinfo = draggle_speed_x_friendinfo + friction_friendinfo --衰减（正）
					
					if (draggle_speed_x_friendinfo < 0) then
						draggle_speed_x_friendinfo = 0
					end
					
					--第一个DLC地图面板的坐标不能跑到最左侧的右边去
					if ((delta1_lx + speed) > 0) then --防止走过
						speed = -delta1_lx
						delta1_lx = 0
						
						--没有惯性
						draggle_speed_x_friendinfo = 0
					end
					
					--每个按钮向右侧做运动
					for i = 1, current_DLCMap_friend_max_num, 1 do
						local ctrli = _frmNode.childUI["DLCMapInfoNodeFriend" .. i]
					--if (ctrli.data.selected == 0) then --只处理未选中的DLC地图面板卡牌
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x + speed, pos_y
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					--end
					end
				elseif (draggle_speed_x_friendinfo < 0) then --朝左运动
					local speed = (draggle_speed_x_friendinfo) * 1.0 --系数
					friction_friendinfo = friction_friendinfo + friction_friendinfo_coefficient
					draggle_speed_x_friendinfo = draggle_speed_x_friendinfo + friction_friendinfo --衰减（负）
					
					if (draggle_speed_x_friendinfo > 0) then
						draggle_speed_x_friendinfo = 0
					end
					
					--最后一个DLC地图面板的坐标不能跑到最右侧的左边去
					if ((deltNa_rx + speed) < 0) then --防止走过
						speed = -deltNa_rx
						deltNa_rx = 0
						
						--没有惯性
						draggle_speed_x_friendinfo = 0
						
						--已到底部，标记下拉到底部（为true时有新消息自动滚到最下端）
						--current_in_scroll_down = true
					end
					
					--每个按钮向左侧做运动
					for i = 1, current_DLCMap_friend_max_num, 1 do
						local ctrli = _frmNode.childUI["DLCMapInfoNodeFriend" .. i]
					--if (ctrli.data.selected == 0) then --只处理未选中的DLC地图面板卡牌
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x + speed, pos_y
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
					--end
					end
				end
				
				--上滑动翻页显示，下滑动翻页显示
				if (delta1_lx == 0) then
					--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --上分翻页提示
				else
					--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(true) --上分翻页提示
				end
				if (deltNa_rx == 0) then
					--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --下分翻页提示
					--已拉到底，删除新消息提示
					--onRemoveNewMessageHint()
				else
					--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下分翻页提示
				end
			else --停止运动
				b_need_auto_fixing_friendinfo = false
				friction_friendinfo = 0
				friction_friendinfo_coefficient = 0.5 --衰减系数(默认值)
			end
		end
	end
	
	--函数：查询聊天超时的一次性timer
	refresh_chatnet_timeout_timer = function()
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--清空右侧控件
		--_removeRightFrmFunc()
		--清空消息数量
		--current_DLCMap_max_num = 0
		
		--更新菊花
		if _frmNode.childUI["waiting"] then
			_frmNode.childUI["waiting"]:setstate(1)
			_frmNode.childUI["waiting"].childUI["text"]:setText(hVar.tab_string["ios_err_network_cannot_conn"]) --"不能连接到网络"
		end
	end
	
	--函数：刷新红包倒计时的timer
	refresh_chat_redpacket_loop = function()
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--没有异步处理
		if (#current_async_paint_list > 0) then
			return
		end
		
		if (current_chat_type == hVar.CHAT_TYPE.WORLD) then --世界频道
			--依次遍历支付（土豪）红包类型的消息
			for i = 1, current_DLCMap_max_num, 1 do
				local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
				if ctrli then
					--更新支付（土豪）红包消息界面绘制
					update_pay_redpacket_msg_paint(i)
				end
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.INVITE) then --邀请频道
			--
		elseif (current_chat_type == hVar.CHAT_TYPE.PRIVATE) then --私聊频道
			--
		elseif (current_chat_type == hVar.CHAT_TYPE.GROUP) then --军团频道
			--依次遍历军团红包类型的消息
			for i = 1, current_DLCMap_max_num, 1 do
				local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
				if ctrli then
					--更新军团红包消息界面绘制
					update_group_redpacket_msg_paint(i)
				end
			end
		elseif (current_chat_type == hVar.CHAT_TYPE.COUPLE) then --组队频道
			--
		end
	end
	
	--函数：刷新聊天界面自动连接工会服务器的timer
	refresh_chatframe_autolink_loop = function()
		local _frm = hGlobal.UI.ChatDialogueFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		if (Group_Server:GetState() ~= 1) then --自动连接工会服务器socket
			--显示菊花
			if _frmNode.childUI["waiting"] then
				_frmNode.childUI["waiting"]:setstate(1)
				_frmNode.childUI["waiting"].childUI["text"]:setText(hVar.tab_string["ios_err_network_cannot_conn"]) --"不能连接到网络"
			end
			
			--连接socket
			Group_Server:Connect()
		elseif (Group_Server:getonline() ~= 1) then --自动登陆工会服务器
			--显示菊花
			if _frmNode.childUI["waiting"] then
				_frmNode.childUI["waiting"]:setstate(1)
				_frmNode.childUI["waiting"].childUI["text"]:setText(hVar.tab_string["ios_err_network_cannot_conn"]) --"不能连接到网络"
			end
			
			--登陆
			Group_Server:UserLogin()
		end
	end
	
	--函数：异步绘制聊天消息的timer
	refresh_async_paint_message_loop = function()
		local _frm = hGlobal.UI.ChatDialogueFrm
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
				--取最后一项
				local index = #current_async_paint_list
				local tMsg = current_async_paint_list[index]
				
				--先删除虚控件
				hApi.safeRemoveT(_frmNode.childUI, "DLCMapInfoNode" .. index)
				
				--再创建实体控件
				local  bBottom = (tonumber(index) == tonumber(current_DLCMap_max_num)) --是否底部对齐
				
				on_create_single_message_UI(tMsg, index, bBottom)
				
				table.remove(current_async_paint_list, index)
				
				--全部绘制完异步的消息控件，再检测一下是否需要不足一页，调整消息位置
				if (#current_async_paint_list == 0) then
					local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
					local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
					delta1_ly, deltNa_ry = getUpDownOffset()
					--delta1_ly +:在下底线之上 /-:在下底线之下
					--deltNa_ry +:在下底线之上 /-:在下底线之下
					
					--第一个跑到下面了
					if (delta1_ly < 0) then
						--print("第一个跑到下面了")
						for i = 1, current_DLCMap_max_num, 1 do
							local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
							if ctrli then
								local deltaY = -delta1_ly
								ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
								ctrli.data.x = ctrli.data.x
								ctrli.data.y = ctrli.data.y + deltaY
							end
						end
					end
				end
			end
		end
	end
end

--监听打开聊天界面通知事件
hGlobal.event:listen("LocalEvent_Phone_ShowChatDialogue", "ShowChatDialogueFrm", function(pageIndex, tCallback, groupId_gm)
	--current_in_scroll_down = true --是否下拉到底部（为true时有新消息自动滚到最下端）
	hGlobal.UI.InitChatDialogueFrm("reload")
	
	--横屏，暂时隐藏聊天按钮
	hApi.LockScreenRotation()
	
	--存储参数
	current_tCallback = tCallback
	current_groupId_gm = groupId_gm or 0
	current_IsQueryChampion = false --是否查询过称号（因为称号有有效期，每次打开聊天，在首次输入文字后查询一次称号）
	
	--显示聊天界面
	hGlobal.UI.ChatDialogueFrm:show(1)
	hGlobal.UI.ChatDialogueFrm:active()
	
	--打开上一次的分页（默认显示第1个分页: 限时礼包）
	local lastPageIdx = CurrentSelectRecord.pageIdx
	if (lastPageIdx == 0) then
		lastPageIdx = 1
	end
	--读取外部参数
	if pageIndex then
		lastPageIdx = pageIndex
	end
	
	--在组队副本中，默认打开组队分页
	local sessionId = 0
	local world = hGlobal.WORLD.LastWorldMap
	if world then
		--PVP单人地图也不需要显示组队分页
		if (world.data.tdMapInfo.isNoWaitFrame ~= true) then --不是不等待同步帧模式
			sessionId = world.data.session_dbId
		end
	end
	if (sessionId > 0) then
		lastPageIdx = 5
	else
		--如果上一次打开的是组队分页，默认转到世界分页
		if (lastPageIdx == 5) then
			lastPageIdx = 1
		end
	end
	
	CurrentSelectRecord.pageIdx = 0
	CurrentSelectRecord.contentIdx = 0
	OnClickPageBtn(lastPageIdx)
end)

--监听切换场景事件，清除组队消息缓存
hGlobal.event:listen("LocalEvent_PlayerFocusWorld", "ShowChatDialogueFrm", function(sSceneType, oWorld,oMap)
	--print("监听切换场景事件，清除组队消息缓存")
	current_msg_id_list_couple = {} --组队聊天界面展示的消息id列表
	current_chat_msg_hostory_cache_couple = {} --本次缓存的组队聊天历史消息(用于降低查询频率)
end)

--关闭聊天界面事件
hGlobal.event:listen("LocalEvent_Phone_CloseChatDialogue", "CloseChatDialogueFrm", function()
	if hGlobal.UI.ChatDialogueFrm then
		hGlobal.UI.ChatDialogueFrm.childUI["closeBtn"].data.code()
	end
end)

--[[
hVar.SCREEN_MODE = hVar.SCREEN_MODE_DEFINE.VERTICAL
hVar.SCREEN.w = 720
hVar.SCREEN.h = 1560
hGlobal.event:event("LocalEvent_SpinScreen")
--]]

--[[
hVar.SCREEN_MODE = hVar.SCREEN_MODE_DEFINE.HORIZONTAL
hVar.SCREEN.w = 1560
hVar.SCREEN.h = 720
hGlobal.event:event("LocalEvent_SpinScreen")
--]]

--test
--[[
--测试代码
if hGlobal.UI.ChatDialogueFrm then --删除上一次的聊天界面
	hGlobal.UI.ChatDialogueFrm:del()
	hGlobal.UI.ChatDialogueFrm = nil
end
hGlobal.UI.InitChatDialogueFrm("include") --测试创建聊天界面
--触发事件，显示聊天界面
hGlobal.event:event("LocalEvent_Phone_ShowChatDialogue", 1)
--]]
