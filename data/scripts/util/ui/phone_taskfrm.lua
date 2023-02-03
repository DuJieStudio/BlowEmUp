

local BOARD_WIDTH = 720 --任务操作面板的宽度
local BOARD_HEIGHT = 720 --任务操作面板的高度
local BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 0
local BOARD_OFFSETY = 0 --任务操作面板y偏移中心点的值
local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --任务操作面板的x位置（最左侧）
local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --任务操作面板的y位置（最顶侧）
local BOARD_ACTIVE_WIDTH = 508 --任务操作面板活动宽度（卡牌显示的宽度）

--横屏模式
if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
	BOARD_WIDTH = 720 --DLC地图面板面板的宽度
	BOARD_HEIGHT = 720 --DLC地图面板面板的高度
	BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 20
	BOARD_OFFSETY = 0 --DLC地图面板面板y偏移中心点的值
	BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --DLC地图面板面板的x位置（最左侧）
	BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --DLC地图面板面板的y位置（最顶侧）
end

local PAGE_BTN_LEFT_X = 80 --第一个分页按钮的x偏移
local PAGE_BTN_LEFT_Y = -120 --第一个分页按钮的x偏移
local PAGE_BTN_OFFSET_X = 140 --每个分页按钮的间距

--local SetAllLabelCentered = hApi.DoNothing --使多个label整体居中

--临时UI管理
local leftRemoveFrmList = {} --左侧控件集
local rightRemoveFrmList = {} --右侧控件集
local _removeLeftFrmFunc = hApi.DoNothing --清空左侧所有的临时控件
local _removeRightFrmFunc = hApi.DoNothing --清空右侧所有的临时控件

--局部函数
--local OnConnectGameCenterSuccess = hApi.DoNothing --登入gamecenter成功事件
local OnClosePanel = hApi.DoNothing --关闭本界面
local OnClickPageBtn = hApi.DoNothing --点击分页按钮
local RefreshSelectedCardFrame = hApi.DoNothing --更新绘制当前查看的卡牌的信息
local RefreshTaskAchievementFinishPage = hApi.DoNothing --更新提示当前哪个分页可以有领取的了

--函数部分
--分页2：每日任务函数部分
local OnCreateTaskFrame = hApi.DoNothing --创建每日任务界面（第2个分页）
--local __OnRefreshTaskFrame = hApi.DoNothing --更新每日任务界面（已经获得任务的前提下）
local BeginToOnQueryTask = hApi.DoNothing --发起查询任务
--local OnClickTaskFinish = hApi.DoNothing --点击领取每日任务奖励按钮处理的逻辑
local on_task_receive_systime_event = hApi.DoNothing --任务收到获得系统时间的回调
local on_receive_task_event = hApi.DoNothing --收到获得任务信息的回调
local on_spine_screen_event = hApi.DoNothing --横竖屏切换
local on_create_single_task_UI = hApi.DoNothing --绘制单条任务数据
local on_create_single_task_UI_async = hApi.DoNothing --异步绘制单条任务数据（异步）
local on_task_finish_success_event = hApi.DoNothing --任务领取成功事件的回调
local on_week_progress_takereward_success_event = hApi.DoNothing --收到周任务进度档位奖励领取成功的回调
local on_task_finish_all_success_event = hApi.DoNothing --任务全部领取成功事件的回调
local refresh_task_timer = hApi.DoNothing --刷新任务倒计时的timer
local refresh_dlcmapinfo_UI_task_loop = hApi.DoNothing --刷新任务DLC地图面板滚动的timer
local refresh_async_paint_task_loop = hApi.DoNothing --异步绘制任务条目的timer
local getUpDownOffset_task = hApi.DoNothing --获得任务第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离
local OnSelectTaskButton = hApi.DoNothing --选中某个任务按钮处理的逻辑
local OnSelectTaskJumpToButton = hApi.DoNothing --点击某个任务跳转按钮处理的逻辑
local OnSelectTaskTakeRewardButton = hApi.DoNothing --点击某个任务领奖按钮处理的逻辑
local OnSelectTaskTakeRewardAllButton = hApi.DoNothing --点击一键领取按钮处理的逻辑
local OnClickTaskStoneWeekRewardButton = hApi.DoNothing --点击周活跃度奖励按钮处理的逻辑
local __DynamicAddRes = hApi.DoNothing --动态加载资源
local __DynamicRemoveRes = hApi.DoNothing --动态删除资源

--参数部分
local MAX_SPEED = 50 --最大速度

--分页2：每日任务相关参数
local TASK_OFFSET_X = 140 --任务统一偏移x
local TASK_OFFSET_Y = 70 --任务统一偏移y
local TASK_WIDTH = 760 --任务宽度
local TASK_HEIGHT = 110 --任务高度
local TASK_EACHOFFSET = 4 --x间距
local TASK_X_NUM = 1 --活动x的数量
local TASK_Y_NUM = 5 --活动y的数量
--local TASK_NUM = 3 --每日任务的数量
--local MAX_SPEED = 50 --最大速度
--local task_get_state = 0 --任务是否已经获取到了(用于判断是否需要刷新timer)
local task_lasHostTime = os.time() --服务器上次获取任务的时间
--local task_deltaTime = 0 --客户端和服务器的时间误差(Local = Host + deltaTime)
--可变参数
--local current_DLCMap_max_num_task = 0 --最大的DLC地图包数量
local current_focus_task_idx = 0 --当前选中的任务索引值
local current_TaskInfo = {} --任务信息表
local current_TaskWeekRewardInfo = {} --周任务领奖信息表
local current_TaskStoneNum = 0 --当前任务之石数量
local current_async_paint_list_task = {} --当前待异步绘制的聊天消息列表
local ASYNC_PAINTNUM_ONCE_TASK = 1 --一次绘制几条

local _bCanCreate = true --防止重复创建
local current_funcCallback = nil --关闭后的回调事件

--控制参数（任务）
local click_pos_task = {}
click_pos_task.x = 0 --开始按下的坐标x
click_pos_task.y = 0 --开始按下的坐标y
local last_click_pos_task = {}
last_click_pos_task.x = 0 --上一次按下的坐标x
last_click_pos_task.y = 0 --上一次按下的坐标y
local draggle_speed_y_task = 0 --当前滑动的速度x
local selected_taskEx_idx = 0 --选中的活动ex索引
local click_scroll_task = false --是否在滑动活动中
local b_need_auto_fixing_task = false --是否需要自动修正
local friction_task = 0 --阻力

--分页3：活动相关参数
local ACTIVITY_OFFSET_X = 254 --活动统一偏移x
local ACTIVITY_OFFSET_Y = 20 --活动统一偏移y
local ACTIVITY_X_NUM = 2 --活动x的数量
local ACTIVITY_Y_NUM = 5 --活动y的数量
local ACTIVITY_WIDTH = 360 --活动宽度
local ACTIVITY_HEIGHT = 90 --活动高度
--local ACTIVITY_PANEL_HEIGHT = 530 --活动面板的高度
--local MAX_SPEED = 50 --最大速度

--当前选中的记录
local CurrentSelectRecord = {pageIdx = 0, contentIdx = 0, cardId = 0,} --当前选择的分页、数据项的信息记录




--任务面板
hGlobal.UI.InitMyTaskActivityFrm = function(mode)
	local tInitEventName = {"LocalEvent_Phone_ShowMyTask", "__ShowTaskFrm",}
	if (mode ~= "reload") then
		--return tInitEventName
		return
	end
	
	--不重复创建
	if hGlobal.UI.PhoneTaskFrm then --任务操作面板
		hGlobal.UI.PhoneTaskFrm:del()
		hGlobal.UI.PhoneTaskFrm = nil
	end
	
	--[[
	--取消监听打开任务、成就、活动界面通知事件
	hGlobal.event:listen("LocalEvent_Phone_ShowMyTask", "__ShowTaskFrm", nil)
	--取消监听关闭宝箱界面事件
	hGlobal.event:listen("clearPhoneChestFrm", "__CloseTaskFrm", nil)
	]]
	
	BOARD_WIDTH = 720 --任务操作面板的宽度
	BOARD_HEIGHT = 720 --任务操作面板的高度
	BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 0
	BOARD_OFFSETY = 0 --任务操作面板y偏移中心点的值
	BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --任务操作面板的x位置（最左侧）
	BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --任务操作面板的y位置（最顶侧）
	BOARD_ACTIVE_WIDTH = 508 --任务操作面板活动宽度（卡牌显示的宽度）
	
	--横屏模式
	if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
		BOARD_WIDTH = 720 --DLC地图面板面板的宽度
		BOARD_HEIGHT = 720 --DLC地图面板面板的高度
		BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 20
		BOARD_OFFSETY = 0 --DLC地图面板面板y偏移中心点的值
		BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --DLC地图面板面板的x位置（最左侧）
		BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --DLC地图面板面板的y位置（最顶侧）
	end
	
	--加载资源
	--xlLoadResourceFromPList("data/image/misc/pvp.plist")
	
	hApi.clearTimer("__ACHIEVEMENT_SCROLL_TIMER_UPDATE__")
	hApi.clearTimer("__ACHIEVEMENT_ASYNC_TIMER__")
	hApi.clearTimer("__TASK_TIMER_UPDATE__")
	hApi.clearTimer("__TASK_SCROLL_UPDATE__")
	hApi.clearTimer("__TASK_ASYNC_TIMER__")
	hApi.clearTimer("__ACTIVITY_SCROLL_TIMER_UPDATE__")
	hApi.clearTimer("__ACTIVITY_TIMER_UPDATE__")
	hApi.clearTimer("__ACTIVITY_TURNTABLE_LEFTTIME_TIMER__")
	hApi.clearTimer("__ACTIVITY_TURNTABLE_TIMER__")
	hApi.clearTimer("__ACTIVITY_TURNTABLE_PRIZELIST__")
	hApi.clearTimer("__ACTIVITY_TURNTABLE_PAINT_ASYNC__")
	hApi.clearTimer("__ACTIVITY_SIGNIN_LIST__")
	hApi.clearTimer("__ACTIVITY_SEVENDAY_PAY_LIST__")
	hApi.clearTimer("__ACTIVITY_LOGIN_LIST__")
	hApi.clearTimer("__ACTIVITY_CHOUJIANG_LEFTTIME_TIMER__")
	hApi.clearTimer("__ACTIVITY_CHOUJIANG_ONCE_TIMER__")
	hApi.clearTimer("__ACTIVITY_CHOUJIANG_TENTH_TIMER__")
	
	--创建任务、成就操作面板
	hGlobal.UI.PhoneTaskFrm = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 2,
		show = 0, --一开始不显示
		border = 0, --显示frame边框
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
	
	local _frm = hGlobal.UI.PhoneTaskFrm
	local _parent = _frm.handle._n
	
	--活动左侧裁剪区域
	local _BTC_PageClippingRect_Task = {190, -10, 530, 564, 0,}
	local _BTC_pClipNode_Task = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect_Task, 99, _BTC_PageClippingRect_Task[5], "_BTC_pClipNode_Task")
	
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
	--关闭按钮
	local closeDx = -4
	local closeDy = -8
	--btnClose
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		model = "BTN:PANEL_CLOSE",
		x = _frm.data.w + closeDx + 1000, --屏幕外
		y = closeDy,
		scaleT = 0.95,
		code = function()
			--触发事件：刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
			hGlobal.event:event("LocalEvent_RefreshMedalStateUI")
			
			--关闭本界面
			OnClosePanel()
			
			--清除资源缓存
			--local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
			--cache:removeSpriteFramesFromFile("data/image/ui.plist")

			hGlobal.event:event("LocalEvent_RecoverBarrage")
			
			--关闭金币、积分界面
			hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
			
			--检测临时背包是否显示
			hGlobal.event:event("LocalEvent_setGiftBtnState")
			
			--触发事件：关闭了主菜单按钮
			hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
			
			_bCanCreate = false
		end,
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
	--每日任务、成就
	local tPageIcons = {"UI:ach_king",}
	--local tTexts = {"成就", "任务", "活动",} --language
	local tTexts = {"",} --language
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
			x = -40,
			y = 0,
			w = 36,
			h = 36,
		})
		]]
		
		--分页按钮的文字
		_frm.childUI["PageBtn" .. i].childUI["PageText"] = hUI.label:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			x = -16,
			y = -2,
			size = 26,
			align = "LC",
			border = 1,
			font = hVar.FONTC,
			width = 100,
			text = tTexts[i],
		})
		
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
	
	------------------------------------
	--[[
	--GameCenter按钮
	if (hApi.CheckGCShow() == 1) then
		--GameCenter接受事件的按钮
		local GGZJ_Tick_Time = -2001
		_frm.childUI["PageGameCenter"] = hUI.button:new({
			parent = _parent,
			dragbox = _frm.childUI["dragBox"],
			x = PAGE_BTN_LEFT_X + (#tTexts) * PAGE_BTN_OFFSET_X,
			y = PAGE_BTN_LEFT_Y,
			w = 130,
			h = 60,
			model = "misc/mask.png",
			animation = "normal",
			scaleT = 0.95,
			code = function()
				--gamecenter
				--print("已领取" .. i)
				local t = hApi.gametime()
				if ((t - GGZJ_Tick_Time) < 2000) then
					--return
				else
					--gamecenter图片灰掉
					_frm.childUI["PageGameCenter"].childUI["image"].handle.s:setVisible(false)
					_frm.childUI["PageGameCenter"].childUI["imageGray"].handle.s:setVisible(true)
					
					--显示gamecenter菊花
					_frm.childUI["PageGameCenter"].childUI["waiting"].handle.s:setVisible(true)
					
					GGZJ_Tick_Time = t
					if(xlGameCenter_authenticateLocalUser) then
						xlGameCenter_authenticateLocalUser(1)
					end
					
					--模拟触发
					--hGlobal.event:event("Event_GameCenter_ConnectSuccess")
				end
			end,
		})
		_frm.childUI["PageGameCenter"].handle.s:setOpacity(0) --分页按钮点击区域，只作为控制用，不用于显示
		
		--gamecenter图片
		_frm.childUI["PageGameCenter"].childUI["image"] = hUI.image:new({
			parent = _frm.childUI["PageGameCenter"].handle._n,
			dragbox = _frm.childUI["dragBox"],
			x = -10,
			y = 0,
			scale = 1.2,
			model = "UI:gamecenter",
			animation = "normal",
		})
		local act1 = CCScaleTo:create(1.2, 1.3)
		local act2 = CCScaleTo:create(1.2, 1.2)
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		local sequence = CCSequence:create(a)
		_frm.childUI["PageGameCenter"].childUI["image"].handle.s:runAction(CCRepeatForever:create(sequence))
		_frm.childUI["PageGameCenter"].childUI["image"].handle.s:setVisible(true) --一开始显示
		
		--gamecenter灰色
		_frm.childUI["PageGameCenter"].childUI["imageGray"] = hUI.image:new({
			parent = _frm.childUI["PageGameCenter"].handle._n,
			dragbox = _frm.childUI["dragBox"],
			x = -10,
			y = 0,
			scale = 1.2,
			model = "UI:gamecenter",
			animation = "normal",
		})
		hApi.AddShader(_frm.childUI["PageGameCenter"].childUI["imageGray"].handle.s, "gray")
		_frm.childUI["PageGameCenter"].childUI["imageGray"].handle.s:setVisible(false) --一开始不显示
		
		--gamecenter转圈圈的图: 菊花
		_frm.childUI["PageGameCenter"].childUI["waiting"] = hUI.image:new({
			parent = _frm.childUI["PageGameCenter"].handle._n,
			model = "MODEL_EFFECT:waiting",
			x = -10,
			y = 0,
			w = 56,
			h = 56,
		})
		_frm.childUI["PageGameCenter"].childUI["waiting"].handle.s:setVisible(false) --一开始不显示
	end
	]]
	
	--清空所有分页左侧的UI
	_removeLeftFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#rightRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, rightRemoveFrmList[i]) 
		end
		rightRemoveFrmList = {}
	end
	
	--函数：关闭本界面
	OnClosePanel = function()
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		--不显示任务操作面板
		hGlobal.UI.PhoneTaskFrm:show(0)
		
		--关闭界面后不需要监听的事件
		--取消监听：收到网络宝箱数量的事件
		--hGlobal.event:listen("LocalEvent_getNetChestNum", "__ItemGetChestNum_Frm", nil)
		
		--清空切换分页之后取消的监听事件
		--移除事件监听：成就收到成就信息的回调
		hGlobal.event:listen("localEvent_OnReceiveAchievementInfo", "__QueryAchievement", nil)
		--移除事件监听：领取成就奖励的结果回调
		hGlobal.event:listen("localEvent_OnTakeRewardAchievement", "__QueryAchievement", nil)
		--移除事件监听：任务收到服务器时间的回调
		hGlobal.event:listen("localEvent_refresh_Systime", "__QueryTask", nil)
		--移除事件监听：收到获得任务信息的回调
		--hGlobal.event:listen("LocalEvent_DailyQuestUpdate", "__QueryTask", nil)
		--移除事件监听：收到获得任务（新）列表的回调
		hGlobal.event:listen("localEvent_OnReceiveTaskNew", "__QueryTask", nil)
		--移除事事件监听：收到任务领取成功的回调
		hGlobal.event:listen("localEvent_OnTakeRewardTaskNew", "__QueryTask", nil)
		--移除事事件监听：收到周任务进度档位奖励领取成功的回调
		hGlobal.event:listen("localEvent_OnTakeWeekRewardTaskNew", "__QueryTask", nil)
		--移除事件监听：收到完成全部任务成功的回调
		hGlobal.event:listen("localEvent_OnTakeRewardTaskAllNew", "__QueryTask", nil)
		--移除事事件监听：活动收到服务器时间的回调
		hGlobal.event:listen("localEvent_refresh_Systime", "__QueryActivity", nil)
		--移除事事件监听：收到获得活动信息的回调
		hGlobal.event:listen("localEvent_UpdateActivityInfo", "__OnReceiveActivityInfo", nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenTask_", nil)
		
		--动态删除宝物背景大图
		__DynamicRemoveRes()
		
		--清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--删除成就、任务、活动timer
		hApi.clearTimer("__ACHIEVEMENT_SCROLL_TIMER_UPDATE__")
		hApi.clearTimer("__ACHIEVEMENT_ASYNC_TIMER__")
		hApi.clearTimer("__TASK_TIMER_UPDATE__")
		hApi.clearTimer("__TASK_SCROLL_UPDATE__")
		hApi.clearTimer("__TASK_ASYNC_TIMER__")
		hApi.clearTimer("__ACTIVITY_SCROLL_TIMER_UPDATE__")
		hApi.clearTimer("__ACTIVITY_TIMER_UPDATE__")
		
		_bCanCreate = true
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
		--移除事件监听：成就收到成就信息的回调
		hGlobal.event:listen("localEvent_OnReceiveAchievementInfo", "__QueryAchievement", nil)
		--移除事件监听：领取成就奖励的结果回调
		hGlobal.event:listen("localEvent_OnTakeRewardAchievement", "__QueryAchievement", nil)
		--移除事件监听：任务收到服务器时间的回调
		hGlobal.event:listen("localEvent_refresh_Systime", "__QueryTask", nil)
		--移除事件监听：收到获得任务信息的回调
		--hGlobal.event:listen("LocalEvent_DailyQuestUpdate", "__QueryTask", nil)
		--移除事件监听：收到获得任务（新）列表的回调
		hGlobal.event:listen("localEvent_OnReceiveTaskNew", "__QueryTask", nil)
		--移除事事件监听：收到任务领取成功的回调
		hGlobal.event:listen("localEvent_OnTakeRewardTaskNew", "__QueryTask", nil)
		--移除事事件监听：收到周任务进度档位奖励领取成功的回调
		hGlobal.event:listen("localEvent_OnTakeWeekRewardTaskNew", "__QueryTask", nil)
		--移除事件监听：收到完成全部任务成功的回调
		hGlobal.event:listen("localEvent_OnTakeRewardTaskAllNew", "__QueryTask", nil)
		--移除事事件监听：活动收到服务器时间的回调
		hGlobal.event:listen("localEvent_refresh_Systime", "__QueryActivity", nil)
		--移除事事件监听：收到获得活动信息的回调
		hGlobal.event:listen("localEvent_UpdateActivityInfo", "__OnReceiveActivityInfo", nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenTask_", nil)
		
		--移除timer
		hApi.clearTimer("__ACHIEVEMENT_SCROLL_TIMER_UPDATE__")
		hApi.clearTimer("__ACHIEVEMENT_ASYNC_TIMER__")
		hApi.clearTimer("__TASK_TIMER_UPDATE__")
		hApi.clearTimer("__TASK_SCROLL_UPDATE__")
		hApi.clearTimer("__TASK_ASYNC_TIMER__")
		hApi.clearTimer("__ACTIVITY_SCROLL_TIMER_UPDATE__")
		hApi.clearTimer("__ACTIVITY_TIMER_UPDATE__")
		hApi.clearTimer("__ACTIVITY_TURNTABLE_LEFTTIME_TIMER__")
		hApi.clearTimer("__ACTIVITY_TURNTABLE_TIMER__")
		hApi.clearTimer("__ACTIVITY_TURNTABLE_PRIZELIST__")
		hApi.clearTimer("__ACTIVITY_TURNTABLE_PAINT_ASYNC__")
		hApi.clearTimer("__ACTIVITY_SIGNIN_LIST__")
		hApi.clearTimer("__ACTIVITY_SEVENDAY_PAY_LIST__")
		hApi.clearTimer("__ACTIVITY_LOGIN_LIST__")
		hApi.clearTimer("__ACTIVITY_CHOUJIANG_LEFTTIME_TIMER__")
		hApi.clearTimer("__ACTIVITY_CHOUJIANG_ONCE_TIMER__")
		hApi.clearTimer("__ACTIVITY_CHOUJIANG_TENTH_TIMER__")
		
		--隐藏所有的clipNode
		--hApi.EnableClipByName(_frm, "_BTC_pClipNode_Achievement", 0)
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Task", 0)
		--hApi.EnableClipByName(_frm, "_BTC_pClipNode_Activity", 0)
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：任务
			--创建每日任务界面
			OnCreateTaskFrame(pageIndex)
		end
		
		--标记当前选择的分页和页内的第几个
		CurrentSelectRecord.pageIdx = pageIndex
		CurrentSelectRecord.contentIdx = 0
	end
	
	--[[
	--函数：登入gamecenter成功事件
	OnConnectGameCenterSuccess = function()
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--gamecenter图片亮掉
		_frm.childUI["PageGameCenter"].childUI["image"].handle.s:setVisible(true)
		_frm.childUI["PageGameCenter"].childUI["imageGray"].handle.s:setVisible(false)
		
		--不显示gamecenter菊花
		_frm.childUI["PageGameCenter"].childUI["waiting"].handle.s:setVisible(false)
	end
	]]
	
	--函数：创建每日任务界面（第2个分页）
	OnCreateTaskFrame = function(pageIdx)
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--标记成就页面翻页停止运动
		b_need_auto_fixing_task = false
		friction_task = 0
		
		--允许本分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Task", 1)
		
		--初始化参数
		--current_DLCMap_max_num_task = 0 --最大的DLC地图面板id
		current_focus_task_idx = 0 --当前选中的任务索引
		current_async_paint_list_task = {} --清空异步缓存待绘制内容
		current_TaskInfo = {} --清空任务信息表
		current_TaskWeekRewardInfo = {} --清空周任务领奖信息表
		current_TaskStoneNum = 0 --当前任务之石数量
		
		--动态加载任务背景大图
		__DynamicAddRes()
		
		--[[
		--任务暂未开放
		_frmNode.childUI["TaskHintLabel"] = hUI.label:new({
			parent = _parentNode,
			x = BOARD_WIDTH / 2,
			y = -BOARD_HEIGHT / 2, --字体有1像素偏差
			size = 32,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
			text = "暂未开放",
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TaskHintLabel"
		_frmNode.childUI["TaskHintLabel"].handle.s:setColor(ccc3(255, 128, 0))
		]]
		
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
		
		--[[
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
		
		--抽神器黑色背景底板
		--九宫格
		local s9 = hApi.CCScale9SpriteCreate("data/image/misc/task/mission_bar.png", 401, -20, 505, 103, _frmNode.childUI["DLCMapInfoListLineV"])
		s9:setColor(ccc3(128, 128, 128))
		s9:setOpacity(32)
		]]
		
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
				x = ACTIVITY_OFFSET_X + 360 - 156,
				y = ACTIVITY_OFFSET_Y - 310 + 140 - 80,
				size = 30,
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
				x = ACTIVITY_OFFSET_X + 360 - 156,
				y = ACTIVITY_OFFSET_Y - 310 + 140 - 140,
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
		
		--左侧任务列表提示上翻页的图片
		_frmNode.childUI["TaskPageUp"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = TASK_OFFSET_X + 302 + 2000,
			y = TASK_OFFSET_Y - 58,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["TaskPageUp"].handle.s:setRotation(90)
		_frmNode.childUI["TaskPageUp"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_frmNode.childUI["TaskPageUp"].handle.s:setVisible(false) --默认不显示左分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TaskPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["TaskPageUp"].handle._n:runAction(forever)
		
		--左侧任务列表提示下翻页的图片
		_frmNode.childUI["TaskPageDown"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:PageBtn",
			x = TASK_OFFSET_X + 302 + 7 + 2000, --非对称的翻页图
			y = TASK_OFFSET_Y - 570 - 48,
			scale = 1.0,
			z = 99999, --最前端显示
		})
		_frmNode.childUI["TaskPageDown"].handle.s:setRotation(270)
		_frmNode.childUI["TaskPageDown"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		_frmNode.childUI["TaskPageDown"].handle.s:setVisible(false) --默认不显示下分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TaskPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["TaskPageDown"].handle._n:runAction(forever)
		
		--左侧向上翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["TaskPageUp_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = TASK_OFFSET_X + 302 + 2000,
			y = TASK_OFFSET_Y - 40,
			w = 300,
			h = 64,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (#current_TaskInfo > (TASK_X_NUM * TASK_Y_NUM)) then
					--print("向下滚屏", screenY)
					--向下滚屏
					b_need_auto_fixing_task = true
					friction_task = 0
					draggle_speed_y_task = -MAX_SPEED / 2.0 --负速度
				end
			end,
		})
		_frmNode.childUI["TaskPageUp_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TaskPageUp_Btn"
		
		--左侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["TaskPageDown_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = TASK_OFFSET_X + 302 + 2000,
			y = TASK_OFFSET_Y - 588 - 48,
			w = 300,
			h = 64,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (#current_TaskInfo > (TASK_X_NUM * TASK_Y_NUM)) then
					--print("向上滚屏", screenY)
					--向上滚屏
					b_need_auto_fixing_task = true
					friction_task = 0
					draggle_speed_y_task = MAX_SPEED / 2.0 --正速度
				end
			end,
		})
		_frmNode.childUI["TaskPageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TaskPageDown_Btn"
		
		--左侧用于检测滑动事件的控件
		_frmNode.childUI["TaskDragPanel"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = TASK_OFFSET_X + 314,
			y = TASK_OFFSET_Y - 360,
			w = 530,
			h = 564 + 8,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--print("codeOnTouch", touchX, touchY, sus)
				click_pos_task.x = touchX --开始按下的坐标x
				click_pos_task.y = touchY --开始按下的坐标y
				last_click_pos_task.x = touchX --上一次按下的坐标x
				last_click_pos_task.y = touchY --上一次按下的坐标y
				draggle_speed_y_task = 0 --当前速度为0
				selected_taskEx_idx = 0 --选中的活动ex索引
				click_scroll_task = true --是否滑动活动
				b_need_auto_fixing_task = false --不需要自动修正位置
				friction_task = 0 --无阻力
				
				--如果活动数量未铺满一页，那么不需要滑动
				if (#current_TaskInfo <= (TASK_X_NUM * TASK_Y_NUM)) then
					click_scroll_task = false --不需要滑动活动
				end
				
				--检测是否滑动到了最顶部或最底部
				local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
				local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
				delta1_ly, deltNa_ry = getUpDownOffset_task()
				--print(delta1_ly, deltNa_ry)
				--delta1_ly +:在下底线之上 /-:在下底线之下
				--deltNa_ry +:在下底线之上 /-:在下底线之下
				--不满一页
				--上面对其上顶线，下面在在下底线之上
				if (delta1_ly == 0) and (deltNa_ry >= 0) then
					click_scroll_task = false --不需要滑动DLC地图面板
				end
				
				--检测是否点到了某些控件里
				for i = 1, #current_TaskInfo, 1 do
					local ctrli = _frmNode.childUI["TaskNode" .. i]
					if ctrli then
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						
						--检测是否点到了前往按钮
						local ctrlI = ctrli.childUI["btnToFinish"]
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
						
						--检测是否点到了领奖按钮
						local ctrlI = ctrli.childUI["btnTakeReward"]
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
						
						--检测是否点到了奖励道具
						local tRecordI = current_TaskInfo[i]
						local taskId = tRecordI.taskId
						local tabTask = hVar.tab_task[taskId] or {}
						local taskReward = tabTask.reward or {} --任务奖励
						for r = 1, #taskReward, 1 do
							local ctrlI = ctrli.childUI["btnReward_" .. r]
							if ctrlI then
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
				
				--_frmNode.childUI["TaskNode" .. index].childUI["taskToFinishBtn"]
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
				local deltaY = touchY - last_click_pos_task.y --与开始按下的位置的偏移值x
				
				--处理移动速度y
				draggle_speed_y_task = touchY - last_click_pos_task.y
				
				if (draggle_speed_y_task > MAX_SPEED) then
					draggle_speed_y_task = MAX_SPEED
				end
				if (draggle_speed_y_task < -MAX_SPEED) then
					draggle_speed_y_task = -MAX_SPEED
				end
				
				--检测是否滑动到了最顶部或最底部
				local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
				local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
				delta1_ly, deltNa_ry = getUpDownOffset_task()
				--print(delta1_ly, deltNa_ry)
				--delta1_ly +:在下底线之上 /-:在下底线之下
				--deltNa_ry +:在下底线之上 /-:在下底线之下
				--第一个DLC地图面板的坐标不能跑到最上侧的下边去
				if ((delta1_ly + deltaY) <= 0) then --防止走过
					deltaY = -delta1_ly
					delta1_ly = 0
					
					--没有惯性
					draggle_speed_y_task = 0
					
					_frmNode.childUI["TaskPageUp"].handle.s:setVisible(false) --上分翻页提示
				else
					if click_scroll_task then
						_frmNode.childUI["TaskPageUp"].handle.s:setVisible(true) --上分翻页提示
					end
				end
				
				--最后一个DLC地图面板的坐标不能跑到最下侧的上边去
				if ((deltNa_ry + deltaY) >= 0) then --防止走过
					deltaY = -deltNa_ry
					deltNa_ry = 0
					
					--没有惯性
					draggle_speed_y_task = 0
					
					--已到底部，标记下拉到底部（为true时有新消息自动滚到最下端）
					--current_in_scroll_down = true
					_frmNode.childUI["TaskPageDown"].handle.s:setVisible(false) --下分翻页提示
				else
					if click_scroll_task then
						_frmNode.childUI["TaskPageDown"].handle.s:setVisible(true) --下分翻页提示
					end
				end
				
				--print("click_scroll_task=", click_scroll_task)
				--在滑动过程中才会处理滑动 
				if click_scroll_task then
					--local deltaY = touchY - last_click_pos_task.y --与开始按下的位置的偏移值x
					for i = 1, #current_TaskInfo, 1 do
						local ctrli = _frmNode.childUI["TaskNode" .. i]
						if ctrli then
							--print(i, deltaY)
							ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
							ctrli.data.x = ctrli.data.x
							ctrli.data.y = ctrli.data.y + deltaY
						end
					end
				end
				
				--存储本次的位置
				last_click_pos_task.x = touchX
				last_click_pos_task.y = touchY
			end,
			
			--抬起事件
			code = function(self, touchX, touchY, sus)
				--print("code", touchX, touchY, sus)
				--如果之前在滑动中，那么标记需要自动修正位置
				if click_scroll_task then
					--if (touchX ~= click_pos_task.x) or (touchY ~= click_pos_task.y) then --不是点击事件
						b_need_auto_fixing_task = true
						friction_task = 0
					--end
				end
				
				--检测
				--检测点击到了哪个活动框内
				for i = 1, #current_TaskInfo, 1 do
					local ctrli = _frmNode.childUI["TaskNode" .. i]
					local cx = ctrli.data.x --中心点x坐标
					local cy = ctrli.data.y --中心点y坐标
					local cw, ch = ctrli.data.w, ctrli.data.h
					local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
					local rx, ry = lx + cw, ly + ch --最右下角坐标
					--print(i, lx, rx, touchX)
					--print("click" ..  i,  "x=" .. ctrli.data.x, touchX, touchY, lx, rx, ly, ry)
					if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
						selected_taskEx_idx = i
						
						break
						--print("点击到了哪个活动的框内" .. i)
					end
				end
				
				--这种情况请注意：在触发滑动操作（活动数量大于一页），并且按下坐标和抬起坐标偏差过大，则认为该操作是滑动，不触发选择卡牌
				if (click_scroll_task) and (math.abs(touchY - click_pos_task.y) > 48) then
					selected_taskEx_idx = 0
				end
				--print("selected_taskEx_idx", selected_taskEx_idx)
				
				--之前选中了某个活动
				if (selected_taskEx_idx > 0) then
					OnSelectTaskButton(selected_taskEx_idx)
					
					--selected_taskEx_idx = 0
					--检测是否点到了前往按钮
					local ctrli = _frmNode.childUI["TaskNode" .. selected_taskEx_idx]
					if ctrli then
						local cx = ctrli.data.x --中心点x坐标
						local cy = ctrli.data.y --中心点y坐标
						local ctrlI = ctrli.childUI["btnToFinish"]
						if ctrlI then
							if (ctrlI.data.state == 1) then --按钮可点状态
								local bcx = ctrlI.data.x --中心点x坐标
								local bcy = ctrlI.data.y --中心点y坐标
								local bcw, bch = ctrlI.data.w, ctrlI.data.h
								local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
								local brx, bry = blx + bcw, bly + bch --最右下角坐标
								--print(i, lx, rx, ly, ry, touchX, touchY)
								if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
									--点击任务跳转按钮
									OnSelectTaskJumpToButton(selected_taskEx_idx)
								end
							end
						end
						
						--检测是否点到了领奖按钮
						local ctrlI = ctrli.childUI["btnTakeReward"]
						if ctrlI then
							if (ctrlI.data.state == 1) then --按钮可点状态
								local bcx = ctrlI.data.x --中心点x坐标
								local bcy = ctrlI.data.y --中心点y坐标
								local bcw, bch = ctrlI.data.w, ctrlI.data.h
								local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
								local brx, bry = blx + bcw, bly + bch --最右下角坐标
								--print(i, lx, rx, ly, ry, touchX, touchY)
								if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
									--点击任务领奖按钮
									OnSelectTaskTakeRewardButton(selected_taskEx_idx)
								end
							end
						end
						
						--检测是否点到了奖励道具
						local tRecordI = current_TaskInfo[selected_taskEx_idx]
						local taskId = tRecordI.taskId
						local tabTask = hVar.tab_task[taskId] or {}
						local taskReward = tabTask.reward or {} --任务奖励
						for r = 1, #taskReward, 1 do
							local ctrlI = ctrli.childUI["btnReward_" .. r]
							if ctrlI then
								local bcx = ctrlI.data.x --中心点x坐标
								local bcy = ctrlI.data.y --中心点y坐标
								local bcw, bch = ctrlI.data.w, ctrlI.data.h
								local blx, bly = cx + bcx - bcw / 2, cy  + bcy- bch / 2 --最左上侧坐标
								local brx, bry = blx + bcw, bly + bch --最右下角坐标
								--print(i, lx, rx, ly, ry, touchX, touchY)
								if (touchX >= blx) and (touchX <= brx) and (touchY >= bly) and (touchY <= bry) then
									--显示各种类型的奖励的tip
									local rewardT = taskReward[r]
									hApi.ShowRewardTip(rewardT)
								end
							end
						end
					end
				end
				
				--标记不用滑动
				click_scroll_task = false
			end,
		})
		_frmNode.childUI["TaskDragPanel"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TaskDragPanel"
		
		--任务倒计时界面
		--[[
		--倒计时前缀
		_frmNode.childUI["TaskRefreshPrefixLabel"] = hUI.label:new({
			parent = _parentNode,
			x = TASK_OFFSET_X + 550 - 10 - 110,
			y = TASK_OFFSET_Y - 50 - 16,
			size = 18,
			font = hVar.FONTC,
			align = "RC",
			width = 500,
			border = 1,
			--text = "重刷倒计时", --language
			text = hVar.tab_string["PVPChongShuaDaoJiShi_Task"], --language
		})
		_frmNode.childUI["TaskRefreshPrefixLabel"].handle.s:setColor(ccc3(0, 255, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TaskRefreshPrefixLabel"
		]]
		
		--任务之石总进度
		_frmNode.childUI["TaskStone_Pprogress"] = hUI.valbar:new({
			parent = _parentNode,
			x = TASK_OFFSET_X - 20,
			y = TASK_OFFSET_Y - 650,
			w = 480,
			h = 21,
			align = "LC",
			back = {model = "misc/task/mission_progress_01.png", x = -5, y = 27, w = 488, h = 83,},
			model = "misc/task/mission_progress_02.png",
			v = 0,
			max = 100,
		})
		_frmNode.childUI["TaskStone_Pprogress"].handle._n:setRotation(-90)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TaskStone_Pprogress"

		_frmNode.childUI["btn_TaskStoneTip"] = hUI.button:new({
			parent = _parentNode,
			x = TASK_OFFSET_X - 54,
			y = TASK_OFFSET_Y - 410,
			dragbox = _frm.childUI["dragBox"],
			model = "misc/button_null.png",
			w = 160,
			h = 660,
			scaleT = 0.95,
			code = function()
				local title = hVar.tab_string["taskIntroduce"]
				local titleColor = ccc3(255, 196, 0)
				local icon = "misc/task/task_stone.png"
				local iconW = 72
				local iconH = 72
				local content = hVar.tab_string["taskIntroduce1"]
				hApi.ShowGeneralMiniTip(title, titleColor, icon, iconW, iconH, content)
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btn_TaskStoneTip"
		
		--任务的周任务档位
		for t = 1, #hVar.TASK_STONE_COST, 1 do
			local tInfo = hVar.TASK_STONE_COST[t]
			local num = tInfo.num
			
			--绘制任务之石进度奖励
			--父控件
			_frmNode.childUI["TaskStone_" .. t] = hUI.button:new({
				parent = _parentNode,
				x = TASK_OFFSET_X - 48,
				y = TASK_OFFSET_Y - 620 + (t - 1) * 110,
				dragbox = _frm.childUI["dragBox"],
				model = "misc/mask.png",
				w = 150,
				h = 90,
				scaleT = 0.95,
				code = function()
					--点击周活跃度奖励按钮处理的逻辑
					OnClickTaskStoneWeekRewardButton(t)
				end,
			})
			_frmNode.childUI["TaskStone_" .. t].handle.s:setOpacity(0) --只响应事件，不显示
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "TaskStone_" .. t
			
			--任务徽章
			local rewardT = tInfo.reward
			local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
			local scale0 = 0.8
			_frmNode.childUI["TaskStone_" .. t].childUI["icon"] = hUI.image:new({
				parent = _frmNode.childUI["TaskStone_" .. t].handle._n,
				x = -36,
				y = 0,
				model = tmpModel, --"misc/task/mission_medal_0" .. t .. ".png",
				scale = scale0, --1.0,
			})
			
			--[[
			--任务奖励数量
			_frmNode.childUI["TaskStone_" .. t].childUI["rewardNum"] = hUI.label:new({
				parent = _frmNode.childUI["TaskStone_" .. t].handle._n,
				x = -26,
				y = -10,
				font = "numWhite",
				size = 22,
				align = "MC",
				border = 0,
				text = "+" .. itemNum,
			})
			]]
			
			--任务之石进度文字
			_frmNode.childUI["TaskStone_" .. t].childUI["label"] = hUI.label:new({
				parent = _frmNode.childUI["TaskStone_" .. t].handle._n,
				x = 30,
				y = 0,
				font = "numWhite",
				size = 16,
				align = "MC",
				border = 0,
				text = num,
			})
			
			--已领取的标记
			_frmNode.childUI["TaskStone_" .. t].childUI["finishTag"] = hUI.image:new({
				parent = _frmNode.childUI["TaskStone_" .. t].handle._n,
				x = -36,
				y = 0,
				model = "UI:FinishTag",
				scale = 1.0,s
			})
			_frmNode.childUI["TaskStone_" .. t].childUI["finishTag"].handle._n:setRotation(15)
			_frmNode.childUI["TaskStone_" .. t].childUI["finishTag"].handle._n:setVisible(false) --默认隐藏
			
			--提示可领取的叹号
			--叹号
			_frmNode.childUI["TaskStone_" .. t].childUI["tanhao"] = hUI.image:new({
				parent = _frmNode.childUI["TaskStone_" .. t].handle._n,
				x = -12,
				y = 12,
				model = "UI:TaskTanHao",
				w = 36,
				h = 36,
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
			_frmNode.childUI["TaskStone_" .. t].childUI["tanhao"].handle._n:runAction(CCRepeatForever:create(sequence))
			_frmNode.childUI["TaskStone_" .. t].childUI["tanhao"].handle._n:setVisible(false) --默认隐藏
		end
		
		--任务之石当前进度值
		_frmNode.childUI["TaskStone_Point"] = hUI.button:new({
			parent = _parentNode,
			x = TASK_OFFSET_X - 72,
			y = TASK_OFFSET_Y - 116,
			--y = TASK_OFFSET_Y - 140,
			model = "misc/task/task_stone.png",
			label = {x = 32, y = -2, font = "numGreen", align = "LC", border = 0, size = 22, text = "",},
			w = 64,
			h = 64,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TaskStone_Point"
		
		--倒计时的转圈图标
		_frmNode.childUI["TaskRefreshIocn"] = hUI.image:new({
			parent = _parentNode,
			x = TASK_OFFSET_X - 52 - 50,
			y = TASK_OFFSET_Y - 717 - 1,
			model = "misc/task/waiting.png",
			w = 19,
			h = 37,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TaskRefreshIocn"
		local act1 = CCEaseExponentialOut:create(CCRotateBy:create(1.0, -180))
		local act2 = CCDelayTime:create(1.0)
		local a = CCArray:create()
		a:addObject(act1)
		a:addObject(act2)
		local sequence = CCSequence:create(a)
		_frmNode.childUI["TaskRefreshIocn"].handle._n:runAction(CCRepeatForever:create(sequence))
		
		--倒计时
		_frmNode.childUI["TaskRefreshLabel"] = hUI.label:new({
			parent = _parentNode,
			x = TASK_OFFSET_X - 52 + 40,
			y = TASK_OFFSET_Y - 717,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 500,
			border = 1,
			text = "",
			RGB = {255, 255, 0,},
		})
		--_frmNode.childUI["TaskRefreshLabel"].handle.s:setColor(ccc3(0, 255, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "TaskRefreshLabel"
		
		--[[
		--领取全部的按钮
		_frmNode.childUI["RefreshTaskBtn"] = hUI.button:new({
			parent = _parentNode,
			model = -1, --"misc/chest/button_yellow_small.png", --"UI:PANEL_MENU_BTN_BIG",
			dragbox = _frm.childUI["dragBox"],
			x = TASK_OFFSET_X + 632,
			y = TASK_OFFSET_Y - 48,
			label = {x = 0, y = -1, z = 1, font = hVar.FONTC, text = hVar.tab_string["__TEXT_TAKEALL_MAIL"], border = 1, align = "MC", size = 20,}, --"全部领取"
			w = 90,
			h = 40,
			scaleT = 0.95,
			font = hVar.FONTC,
			border = 1,
			code = function(self)
				OnSelectTaskTakeRewardAllButton()
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RefreshTaskBtn"
		_frmNode.childUI["RefreshTaskBtn"]:setstate(-1) --默认隐藏
		--九宫格
		local s9 = hApi.CCScale9SpriteCreate("data/image/misc/task/mission_go.png", 0, 0, 58, 58, _frmNode.childUI["RefreshTaskBtn"])
		]]
		
		--[[
		--创建联网的: 文字
		_frmNode.childUI["TaskWaitingLabel"] = hUI.label:new({
			parent = _parentNode,
			x = TASK_OFFSET_X + 380 - 66,
			y = TASK_OFFSET_Y - 340,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 300,
			border = 1,
			--text = "正在获取任务", --language
			text = hVar.tab_string["__TEXT_Getting__"] .. hVar.tab_string["__TEXT_Task"], --language
		})
		_frmNode.childUI["TaskWaitingLabel"].handle.s:setColor(ccc3(168, 168, 168))
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "TaskWaitingLabel"
		
		--创建联网的: 菊花
		_frmNode.childUI["TaskWaiting"] = hUI.image:new({
			parent = _parentNode,
			model = "MODEL_EFFECT:waiting",
			x = TASK_OFFSET_X + 380 - 66,
			y = TASK_OFFSET_Y - 280,
			w = 64,
			h = 64,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "TaskWaiting"
		]]
		
		--按钮-签到
		_frmNode.childUI["Btn_SignIn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/task/tab_frame_selected.png",
			x = TASK_OFFSET_X + 437 - 88 * 2,
			y = TASK_OFFSET_Y - 728,
			w = 89,
			h = 103,
			scaleT = 0.95,
			dragbox = _frm.childUI["dragBox"],
			code = function()
				--关闭本界面
				OnClosePanel()
				
				--由关闭按钮触发的关闭，不能再次打开
				_bCanCreate = false
				
				--触发事件，显示签到礼包界面
				hGlobal.event:event("LocalEvent_Phone_ShowSignInFrm", nil, true)
			end,
		})
		_frmNode.childUI["Btn_SignIn"].handle.s:setOpacity(0) --只挂载子控件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "Btn_SignIn"
		--图标
		_frmNode.childUI["Btn_SignIn"].childUI["icon"] = hUI.button:new({
			parent = _frmNode.childUI["Btn_SignIn"].handle._n,
			model = "misc/task/tab_checkin_01.png",
			x = 0,
			y = 0,
			scale = 1,
		})
		--签到叹号
		_frmNode.childUI["Btn_SignIn"].childUI["NoteJianTou"] = hUI.image:new({
			parent = _frmNode.childUI["Btn_SignIn"].handle._n,
			model = "UI:TaskTanHao",
			x = 20,
			y = 30,
			w = 46,
			h = 46,
		})
		_frmNode.childUI["Btn_SignIn"].childUI["NoteJianTou"].handle._n:setVisible(false) --默认一开始不显示提示该分页可以领取的动态箭头
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
		_frmNode.childUI["Btn_SignIn"].childUI["NoteJianTou"].handle.s:runAction(CCRepeatForever:create(sequence))
		
		--按钮-任务
		_frmNode.childUI["Btn_Task"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/task/tab_frame_selected.png",
			x = TASK_OFFSET_X + 437 - 88 * 1,
			y = TASK_OFFSET_Y - 728,
			w = 89,
			h = 103,
			scaleT = 1.0,
			dragbox = _frm.childUI["dragBox"],
			code = function()
				---
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "Btn_Task"
		--图标
		_frmNode.childUI["Btn_Task"].childUI["icon"] = hUI.button:new({
			parent = _frmNode.childUI["Btn_Task"].handle._n,
			model = "misc/task/tab_mission_02.png",
			x = 0,
			y = 0,
			scale = 1,
		})
		--任务叹号
		_frmNode.childUI["Btn_Task"].childUI["NoteJianTou"] = hUI.image:new({
			parent = _frmNode.childUI["Btn_Task"].handle._n,
			model = "UI:TaskTanHao",
			x = 20,
			y = 30,
			w = 46,
			h = 46,
		})
		_frmNode.childUI["Btn_Task"].childUI["NoteJianTou"].handle._n:setVisible(false) --默认一开始不显示提示该分页可以领取的动态箭头
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
		_frmNode.childUI["Btn_Task"].childUI["NoteJianTou"].handle.s:runAction(CCRepeatForever:create(sequence))
		
		--按钮-活动
		_frmNode.childUI["Btn_Activity"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/task/tab_frame_selected.png",
			x = TASK_OFFSET_X + 437 + 88 * 0,
			y = TASK_OFFSET_Y - 728,
			w = 89,
			h = 103,
			scaleT = 0.95,
			dragbox = _frm.childUI["dragBox"],
			code = function()
				--关闭本界面
				OnClosePanel()
				
				--由关闭按钮触发的关闭，不能再次打开
				_bCanCreate = false
				
				--触发事件，显示活动界面
				hGlobal.event:event("LocalEvent_Phone_ShowActivityNewFrm", nil, true)
			end,
		})
		_frmNode.childUI["Btn_Activity"].handle.s:setOpacity(0) --只挂载子控件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "Btn_Activity"
		--图标
		_frmNode.childUI["Btn_Activity"].childUI["icon"] = hUI.button:new({
			parent = _frmNode.childUI["Btn_Activity"].handle._n,
			model = "misc/task/tab_events_01.png",
			x = 0,
			y = 0,
			scale = 1,
		})
		--活动叹号
		_frmNode.childUI["Btn_Activity"].childUI["NoteJianTou"] = hUI.image:new({
			parent = _frmNode.childUI["Btn_Activity"].handle._n,
			model = "UI:TaskTanHao",
			x = 20,
			y = 30,
			w = 46,
			h = 46,
		})
		_frmNode.childUI["Btn_Activity"].childUI["NoteJianTou"].handle._n:setVisible(false) --默认一开始不显示提示该分页可以领取的动态箭头
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
		_frmNode.childUI["Btn_Activity"].childUI["NoteJianTou"].handle.s:runAction(CCRepeatForever:create(sequence))
		
		--按钮-邮件
		_frmNode.childUI["Btn_Mail"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/task/tab_frame_selected.png",
			x = 140 + 437 + 88 * 1,
			y = 70 - 728,
			w = 89,
			h = 103,
			scaleT = 0.95,
			dragbox = _frm.childUI["dragBox"],
			code = function()
				--关闭本界面
				OnClosePanel()
				
				--由关闭按钮触发的关闭，不能再次打开
				_bCanCreate = false
				
				--触发事件，显示系统邮件界面
				hGlobal.event:event("LocalEvent_Phone_ShowSystemMailInfoFrm", nil, true)
			end,
		})
		_frmNode.childUI["Btn_Mail"].handle.s:setOpacity(0) --只挂载子控件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "Btn_Mail"
		--图标
		_frmNode.childUI["Btn_Mail"].childUI["icon"] = hUI.button:new({
			parent = _frmNode.childUI["Btn_Mail"].handle._n,
			model = "misc/task/tab_mail_01.png",
			x = 0,
			y = 0,
			scale = 1,
		})
		--邮件叹号
		_frmNode.childUI["Btn_Mail"].childUI["NoteJianTou"] = hUI.image:new({
			parent = _frmNode.childUI["Btn_Mail"].handle._n,
			model = "UI:TaskTanHao",
			x = 20,
			y = 30,
			w = 46,
			h = 46,
		})
		_frmNode.childUI["Btn_Mail"].childUI["NoteJianTou"].handle._n:setVisible(false) --默认一开始不显示提示该分页可以领取的动态箭头
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
		_frmNode.childUI["Btn_Mail"].childUI["NoteJianTou"].handle.s:runAction(CCRepeatForever:create(sequence))
		
		--只在本分页有效的事件
		--添加事件监听：任务收到服务器时间的回调
		hGlobal.event:listen("localEvent_refresh_Systime", "__QueryTask", on_task_receive_systime_event)
		--添加事件监听：收到获得任务信息的回调
		--hGlobal.event:listen("LocalEvent_DailyQuestUpdate", "__QueryTask", on_receive_task_event)
		--添加事件监听：收到获得任务（新）列表的回调
		hGlobal.event:listen("localEvent_OnReceiveTaskNew", "__QueryTask", on_receive_task_event)
		--添加事件监听：收到完成任务成功的回调
		hGlobal.event:listen("localEvent_OnTakeRewardTaskNew", "__QueryTask", on_task_finish_success_event)
		--添加事事件监听：收到周任务进度档位奖励领取成功的回调
		hGlobal.event:listen("localEvent_OnTakeWeekRewardTaskNew", "__QueryTask", on_week_progress_takereward_success_event)
		--添加事件监听：收到完成全部任务成功的回调
		hGlobal.event:listen("localEvent_OnTakeRewardTaskAllNew", "__QueryTask", on_task_finish_all_success_event)
		--添加移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenTask_", on_spine_screen_event)
		
		--只有在本分页才会有的timer
		hApi.addTimerForever("__TASK_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 1000, refresh_task_timer)
		--创建timer，刷新任务DLC地图面板滚动
		hApi.addTimerForever("__TASK_SCROLL_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_dlcmapinfo_UI_task_loop)
		--异步绘制任务条目的timer
		hApi.addTimerForever("__TASK_ASYNC_TIMER__", hVar.TIMER_MODE.GAMETIME, 1, refresh_async_paint_task_loop)
		
		--发起查询任务
		BeginToOnQueryTask()
	end
	
	--函数：发起查询每日任务
	BeginToOnQueryTask = function()
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--标记任务未收到，不需要刷timer
		--task_get_state = 0
		
		--[[
		--挡操作
		for i = 1, 3, 1 do
			_frmNode.childUI["TaskCoverMask" .. i]:setstate(1)
		end
		]]
		
		--挡操作
		--hUI.NetDisable(30000)
		
		--发起查询服务器系统时间
		SendCmdFunc["refresh_systime"]()
	end
	
	--函数：任务收到获得系统时间的回调
	on_task_receive_systime_event = function()
		local localTime = os.time() --客户端时间 12:00
		local hostTime = hApi.GetNewDate(g_systime) --服务器时间 11:00
		local lastHostTime = task_lasHostTime --上次获取的服务器时间 11:00
		
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
		hostTime = hostTime - delteZone * 3600 --GMT+8时区
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--存储服务器上次获取任务的时间
		task_lasHostTime = hostTime
		
		--[[
		--geyachao: 已全局记录，这里不再单独存储
		--存储客户端和服务器的时间误差(Local = Host + deltaTime)
		--task_deltaTime = localTime - hostTime --1:00
		
		--检测是否需要更新任务
		--如果服务器时间到了第二天，那么需要重新获取任务
		local tab1 = os.date("*t", lastHostTime)
		local tab2 = os.date("*t", hostTime)
		
		--geyachao: 改为每次都查询了（有时任务不刷新）
		--if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
			--查询任务
			--print("到了第二天，查询任务")
			SendCmdFunc["require_quest"]()
		--else --依旧是同一天
			--检测是否有任务完成
			local tFinishQIdx = nil --任务完成的索引值列表
			hGlobal.event:listen("LocalEvent_PlayerDailyQuestChange", "__TaskCheckFinish__", function(t)
				tFinishQIdx = t
			end)
			local bHaveFinishedTask = hApi.CheckDailyQuest() --日常任务检测（返回 true/false, 有任务完成返回true）
			hGlobal.event:listen("LocalEvent_PlayerDailyQuestChange", "__TaskCheckFinish__", nil)
			
			--print("检测是否有任务完成, bHaveFinishedTask", bHaveFinishedTask)
			if tFinishQIdx and (#tFinishQIdx > 0) then --有任务完成了
				--local tQuest = {{1, 9, 3, 0}, {3, 4, 10, 0}} --{{任务idx, 任务id, 完成数量, param}, ...}
				local tQuest = {}
				for i = 1, #tFinishQIdx, 1 do
					local taskIdx = tFinishQIdx[i] --任务索引值
					--local tabTask = g_dailyQuestInfo[taskIdx] --任务静态表(这时有可能没有)
					local id, state, finishNum, param, condition = LuaGetDailyQuestCompletion(taskIdx) --任务完成情况
					--print("发送 tQuest: ", taskIdx, id, finishNum, param, condition)
					table.insert(tQuest, {taskIdx, id, finishNum, param})
				end
				
				--发起更新任务状态
				SendCmdFunc["update_quest"](tQuest)
			else --没任务完成
				--如果本地没有获得服务器的任务静态表，那么需要重新获取任务
				if (not g_dailyQuestInfo) then --本地没数据
					--查询任务
					--print("本地没数据，查询任务")
					SendCmdFunc["require_quest"]()
				else --本地有数据
					--没有与服务器交互的过程
					--模拟触发：收到获得任务的信息的回调
					on_receive_task_event()
				end
			end
		--end
		]]
		
		--挡操作
		--hUI.NetDisable(30000)
		
		--查询任务
		--print("查询任务")
		--SendCmdFunc["require_quest"]()
		--查询任务（新）
		SendCmdFunc["task_type_query"]()
	end
	
	--函数：收到获得任务信息的回调
	on_receive_task_event = function(taskNum, tTaskInfo, nTaskStone, nWeekRewardNum, tWeekRewardInfo)
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		--print("on_receive_task_event", taskNum, tTaskInfo, nTaskStone, nWeekRewardNum, tWeekRewardInfo)
		
		--[[
		--隐藏掉菊花
		--不挡操作
		for i = 1, 3, 1 do
			_frmNode.childUI["TaskCoverMask" .. i]:setstate(-1)
		end
		]]
		
		--标记任务已收到，需要刷timer
		--task_get_state = 1
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--先清除所有右侧的控件
		_removeRightFrmFunc()
		
		--[[
		--测试 --test
		--模拟收到任务（新）的数据
		local tTaskInfo =
		{
			{taskId = 1, taskProgress = 0,},
			{taskId = 2, taskProgress = 0,},
			{taskId = 3, taskProgress = 0,},
			{taskId = 4, taskProgress = 0,},
			{taskId = 5, taskProgress = 0,},
			{taskId = 6, taskProgress = 0,},
			{taskId = 7, taskProgress = 5555,},
			{taskId = 8, taskProgress = 0,},
			{taskId = 9, taskProgress = 0,},
			{taskId = 10, taskProgress = 0,},
		}
		]]
		
		--如果此任务未解锁，不显示此任务
		for i = #tTaskInfo, 1, -1 do
			local tTask = tTaskInfo[i]
			local taskId = tTask.taskId
			local tabTask = hVar.tab_task[taskId] or {}
			local unlockMap = tabTask.unlockMap or "" --解锁条件
			if (unlockMap ~= "") then
				local isFinishMap = LuaGetPlayerMapAchi(unlockMap, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --是否解锁
				if (isFinishMap == 0) then
					table.remove(tTaskInfo, i)
				end
			end
		end
		
		--将已完成的任务靠前显示
		local tTaskInfo_Finish = {}
		local tTaskInfo_Unfinish = {}
		for i = 1, #tTaskInfo, 1 do
			local tTask = tTaskInfo[i]
			local taskId = tTask.taskId
			local taskProgress = tTask.taskProgress
			local tabTask = hVar.tab_task[taskId] or {}
			local taskProgressMax = tabTask.maxProgress or 0 --任务总进度
			
			if (taskProgress >= taskProgressMax) then --任务达成
				tTaskInfo_Finish[#tTaskInfo_Finish+1] = tTask
			else --未达成
				tTaskInfo_Unfinish[#tTaskInfo_Unfinish+1] = tTask
			end
		end
		
		--排序后任务列表
		local tTaskInfoNew = {}
		for i = 1, #tTaskInfo_Finish, 1 do
			tTaskInfoNew[#tTaskInfoNew+1] = tTaskInfo_Finish[i]
		end
		for i = 1, #tTaskInfo_Unfinish, 1 do
			tTaskInfoNew[#tTaskInfoNew+1] = tTaskInfo_Unfinish[i]
		end
		
		--记录index
		for i = 1, #tTaskInfoNew, 1 do
			tTaskInfoNew[i].index = i
		end
		
		--存储任务信息表
		current_TaskInfo = tTaskInfoNew
		--current_DLCMap_max_num_task = 0
		
		--存储周任务领奖信息表
		current_TaskWeekRewardInfo = tWeekRewardInfo
		
		--存储任务之石数量
		current_TaskStoneNum = nTaskStone
		
		--刷新任务
		--__OnRefreshTaskFrame()
		for i = 1, #current_TaskInfo, 1 do
			--异步绘制任务单个条目
			on_create_single_task_UI_async(i, current_TaskInfo[i])
			
			--标记总数量
			--current_DLCMap_max_num_task = current_DLCMap_max_num_task + 1
		end
		
		--隐藏向上分页按钮
		_frmNode.childUI["TaskPageUp"].handle.s:setVisible(false)
		
		--超过一页，显示向下分页按钮
		if (#current_TaskInfo > (TASK_X_NUM * TASK_Y_NUM)) then
			_frmNode.childUI["TaskPageDown"].handle.s:setVisible(true)
		else
			_frmNode.childUI["TaskPageDown"].handle.s:setVisible(false)
		end
		
		--[[
		--显示或隐藏一键领取按钮
		if (#tTaskInfo_Finish > 0) then
			_frmNode.childUI["RefreshTaskBtn"]:setstate(1)
			_frmNode.childUI["TaskRefreshLabel"]:setXY(TASK_OFFSET_X + 550 + 16, TASK_OFFSET_Y - 48 - 2)
		else
			_frmNode.childUI["RefreshTaskBtn"]:setstate(-1)
			_frmNode.childUI["TaskRefreshLabel"]:setXY(TASK_OFFSET_X + 550 + 16 + 26, TASK_OFFSET_Y - 48 - 2)
		end
		]]
		
		--如果没有任务，显示任务已完成
		if (#current_TaskInfo == 0) then
			_frmNode.childUI["TaskFinishAllLabel"] = hUI.label:new({
				parent = _parentNode,
				x = TASK_OFFSET_X + 380 - 66,
				y = TASK_OFFSET_Y - 394,
				size = 26,
				font = hVar.FONTC,
				align = "MC",
				width = 500,
				border = 1,
				--text = "任务已完成", --language
				text = hVar.tab_string["__TEXT_TASK_FINISH_ALL"], --language
			})
			_frmNode.childUI["TaskFinishAllLabel"].handle.s:setColor(ccc3(168, 168, 168))
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "TaskFinishAllLabel"
		end
		
		--更新任务的周任务档位
		local idx = #hVar.TASK_STONE_COST
		local tInfo = hVar.TASK_STONE_COST[idx]
		local num = tInfo.num
		
		--更新任务之石总进度
		if _frmNode.childUI["TaskStone_Pprogress"] then
			_frmNode.childUI["TaskStone_Pprogress"]:setV(nTaskStone, num)
		end
		
		--更新任务之石当前进度值
		if _frmNode.childUI["TaskStone_Point"] then
			--[[
			local px = TASK_OFFSET_X - 42
			local py_min = TASK_OFFSET_Y - 650
			local py_max = TASK_OFFSET_Y - 152
			local py = py_min + (py_max - py_min) * nTaskStone / num
			_frmNode.childUI["TaskStone_Point"]:setXY(px, py)
			]]
			_frmNode.childUI["TaskStone_Point"].childUI["label"]:setText(nTaskStone)
		end
		
		--更新周任务已领取状态
		for t = 1, #hVar.TASK_STONE_COST, 1 do
			local tInfo = hVar.TASK_STONE_COST[t]
			local num = tInfo.num
			local ctrlI = _frmNode.childUI["TaskStone_" .. t]
			if ctrlI then
				ctrlI.childUI["finishTag"].handle._n:setVisible(false) --默认隐藏
				if (nTaskStone >= num) then
					ctrlI.childUI["tanhao"].handle._n:setVisible(true)
				else
					ctrlI.childUI["tanhao"].handle._n:setVisible(false)
				end
			end
		end
		for t = 1, nWeekRewardNum, 1 do
			local index = tWeekRewardInfo[t]
			local ctrlI = _frmNode.childUI["TaskStone_" .. index]
			if ctrlI then
				ctrlI.childUI["finishTag"].handle._n:setVisible(true)
				ctrlI.childUI["tanhao"].handle._n:setVisible(false)
			end
		end
		
		--立即触发一次刷新倒计时
		refresh_task_timer()
		
		--更新提示当前哪个分页可以有领取的了
		RefreshTaskAchievementFinishPage()
		
		--[[
		--检测是否有新的任务完成了
		local tFinishQIdx = nil --任务完成的索引值列表
		hGlobal.event:listen("LocalEvent_PlayerDailyQuestChange", "__TaskCheckFinish__", function(t)
			tFinishQIdx = t
		end)
		local bHaveFinishedTask = hApi.CheckDailyQuest() --日常任务检测（返回 true/false, 有任务完成返回true）
		hGlobal.event:listen("LocalEvent_PlayerDailyQuestChange", "__TaskCheckFinish__", nil)
		
		if tFinishQIdx and (#tFinishQIdx > 0) then --有任务完成了
			--标记任务未收到，不需要刷timer
			--task_get_state = 0
			
			--挡操作
			for i = 1, 3, 1 do
				_frmNode.childUI["TaskCoverMask" .. i]:setstate(1)
			end
				
			--local tQuest = {{1, 9, 3, 0}, {3, 4, 10, 0}} --{{任务idx, 任务id, 完成数量, param}, ...}
			local tQuest = {}
			for i = 1, #tFinishQIdx, 1 do
				local taskIdx = tFinishQIdx[i] --任务索引值
				--local tabTask = g_dailyQuestInfo[taskIdx] --任务静态表
				local id, state, finishNum, param, condition = LuaGetDailyQuestCompletion(taskIdx) --任务完成情况
				--print("tQuest", taskIdx, id, finishNum, param)
				table.insert(tQuest, {taskIdx, id, finishNum, param})
			end
			
			--发起更新任务状态
			SendCmdFunc["update_quest"](tQuest)
		end
		]]
		
		--触发事件：刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
		hGlobal.event:event("LocalEvent_RefreshMedalStateUI")
	end
	
	--函数：异步绘制单条任务数据（异步）
	on_create_single_task_UI_async = function(index, tRecordI)
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local taskId = tRecordI.taskId --任务id
		local taskProgress = tRecordI.taskProgress --任务当前进度
		
		--父控件
		_frmNode.childUI["TaskNode" .. index] = hUI.button:new({
			parent = _BTC_pClipNode_Task,
			model = "misc/mask.png",
			x = TASK_OFFSET_X + TASK_WIDTH / 2 - 66,
			y = TASK_OFFSET_Y - 130 - (index - 1) * (TASK_HEIGHT + TASK_EACHOFFSET),
			w = TASK_WIDTH,
			h = TASK_HEIGHT,
		})
		_frmNode.childUI["TaskNode" .. index].handle.s:setOpacity(0) --默认不显示（只用于响应事件，不显示）
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "TaskNode" .. index
		
		--清除缓存
		_frmNode.childUI["TaskNode" .. index].data.s92_task = nil
		
		--存储异步待绘制消息列表
		current_async_paint_list_task[index] = tRecordI
	end
	
	--函数：绘制单条任务数据
	on_create_single_task_UI = function(index, tRecordI)
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local taskId = tRecordI.taskId --任务id
		local taskName = hVar.tab_stringTask[taskId] and hVar.tab_stringTask[taskId][1] or ("未知任务" .. taskId) --任务名称
		local taskDescripe = hVar.tab_stringTask[taskId] and hVar.tab_stringTask[taskId][2] or ("未知任务说明" .. taskId) --任务介绍
		local taskProgress = tRecordI.taskProgress --任务当前进度
		local tabTask = hVar.tab_task[taskId] or {}
		local taskProgressMax = tabTask.maxProgress or 0 --任务总进度
		local taskType = tabTask.taskType
		local taskReward = tabTask.reward or {} --任务奖励
		local typeId = tabTask.typeId --任务指定id
		local dailyType = tabTask.dailyType --任务的日期类型
		
		--父控件
		_frmNode.childUI["TaskNode" .. index] = hUI.button:new({
			parent = _BTC_pClipNode_Task,
			model = "misc/mask.png",
			x = TASK_OFFSET_X + TASK_WIDTH / 2 - 66,
			y = TASK_OFFSET_Y - 130 - (index - 1) * (TASK_HEIGHT + TASK_EACHOFFSET),
			w = TASK_WIDTH,
			h = TASK_HEIGHT,
		})
		_frmNode.childUI["TaskNode" .. index].handle.s:setOpacity(0) --默认不显示（只用于响应事件，不显示）
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "TaskNode" .. index
		
		--local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", 0, 0, TASK_WIDTH + 4, TASK_HEIGHT + 4, _frmNode.childUI["TaskNode" .. index])
		--img9:setOpacity(204)
		
		--local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/task_s9.png", 0, 0, TASK_WIDTH, TASK_HEIGHT, _frmNode.childUI["TaskNode" .. index])
		
		if (dailyType == hVar.TASK_DAILY_TYPE.DAY) then --每日任务
			--九宫格
			local s9 = hApi.CCScale9SpriteCreate("data/image/misc/task/mission_bar.png", -2, -2, 505, 104, _frmNode.childUI["TaskNode" .. index])
			--s9:setOpacity(64)
			--s9:setColor(ccc3(244, 244, 244))
			
			--九宫格（选中高亮）
			local s92 = hApi.CCScale9SpriteCreate("data/image/misc/task/mission_bar.png", -2, -2, 505, 104, _frmNode.childUI["TaskNode" .. index])
			_frmNode.childUI["TaskNode" .. index].data.s92_task = s92
			s92:setVisible(false)
			--s9:setOpacity(64)
			--s9:setColor(ccc3(244, 244, 244))
		elseif (dailyType == hVar.TASK_DAILY_TYPE.WEEK) then --周任务
			--九宫格
			local s9 = hApi.CCScale9SpriteCreate("data/image/misc/task/mission_bar02.png", -2, -2, 505, 104, _frmNode.childUI["TaskNode" .. index])
			--s9:setOpacity(64)
			--s9:setColor(ccc3(244, 244, 244))
			
			--九宫格（选中高亮）
			local s92 = hApi.CCScale9SpriteCreate("data/image/misc/task/mission_bar02.png", -2, -2, 505, 104, _frmNode.childUI["TaskNode" .. index])
			_frmNode.childUI["TaskNode" .. index].data.s92_task = s92
			s92:setVisible(false)
			--s9:setOpacity(64)
			--s9:setColor(ccc3(244, 244, 244))
		end
		
		--[[
		--任务图标底板
		_frmNode.childUI["TaskNode" .. index].childUI["TaskIconBG"] = hUI.button:new({ --为了换图，所以是按钮
			parent = _frmNode.childUI["TaskNode" .. index].handle._n,
			model = "misc/chest/astro_btnbg.png",
			x = -TASK_WIDTH / 2 + 60,
			y = -1,
			w = 80,
			h = 80,
		})
		]]
		
		--任务图标
		_frmNode.childUI["TaskNode" .. index].childUI["TaskIcon"] = hUI.button:new({ --为了换图，所以是按钮
			parent = _frmNode.childUI["TaskNode" .. index].handle._n,
			model = tabTask.icon,
			x = -TASK_WIDTH / 2 + 183,
			y = 6,
			w = tabTask.width,
			h = tabTask.height,
		})
		
		--任务子图标
		if tabTask.icon_sub then
			_frmNode.childUI["TaskNode" .. index].childUI["TaskSubIcon"] = hUI.image:new({
				parent = _frmNode.childUI["TaskNode" .. index].handle._n,
				model = tabTask.icon_sub,
				x = -TASK_WIDTH / 2 + 183,
				y = 6,
				w = 64,
				h = 64,
			})
		end
		
		--特殊类型的任务，需要子图标
		if (taskType == hVar.TASK_TYPE.TASK_USE_TACTIC_N) then --使用指定战术卡
			local tabI = hVar.tab_item[typeId] or {}
			local icon = tabI.icon
			_frmNode.childUI["TaskNode" .. index].childUI["TaskSubIcon"] = hUI.image:new({
				parent = _frmNode.childUI["TaskNode" .. index].handle._n,
				model = icon,
				x = -TASK_WIDTH / 2 + 183,
				y = 6,
				w = 64,
				h = 64,
			})
		elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_N) then --通关指定关卡
			local tabM = hVar.MAP_INFO[typeId] or {}
			local icon = tabM.icon
			_frmNode.childUI["TaskNode" .. index].childUI["TaskSubIcon"] = hUI.image:new({
				parent = _frmNode.childUI["TaskNode" .. index].handle._n,
				model = icon,
				x = -TASK_WIDTH / 2 + 183,
				y = 6,
				w = 64,
				h = 64,
			})
		elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N) then --无损通关指定关卡
			local tabM = hVar.MAP_INFO[typeId] or {}
			local icon = tabM.icon
			_frmNode.childUI["TaskNode" .. index].childUI["TaskSubIcon"] = hUI.image:new({
				parent = _frmNode.childUI["TaskNode" .. index].handle._n,
				model = icon,
				x = -TASK_WIDTH / 2 + 183,
				y = 6,
				w = 64,
				h = 64,
			})
		end
		
		--[[
		--周任务加个角标
		if (dailyType == hVar.TASK_DAILY_TYPE.WEEK) then --周任务
			_frmNode.childUI["TaskNode" .. index].childUI["TaskWeekIcon"] = hUI.image:new({
				parent = _frmNode.childUI["TaskNode" .. index].handle._n,
				model = "misc/task/medal_mini.png",
				x = -TASK_WIDTH / 2 + 183 + 40,
				y = 6 - 16,
				w = 22,
				h = 26,
			})
		end
		]]
		
		--[[
		--任务描述背景栏
		--九宫格
		local s9 = hApi.CCScale9SpriteCreate("data/image/misc/t/bg_ng_graygray.png", 50, 11, 400, 36, _frmNode.childUI["TaskNode" .. index])
		s9:setOpacity(144)
		--s9:setColor(ccc3(212, 212, 212))
		]]
		
		--[[
		--标题背景栏
		--九宫格
		local s9 = hApi.CCScale9SpriteCreate("data/image/misc/task/mission_progress.png", -186, 11, 76, 17, _frmNode.childUI["TaskNode" .. index])
		--s9:setOpacity(64)
		--s9:setColor(ccc3(212, 212, 212))
		]]
		
		--[[
		--任务名
		_frmNode.childUI["TaskNode" .. index].childUI["taskName"] = hUI.label:new({
			parent = _frmNode.childUI["TaskNode" .. index].handle._n,
			x = -192,
			y = 13,
			font = hVar.FONTC,
			size = 26,
			align = "MC",
			text = hApi.StringDecodeEmoji(taskName), --解析表情
			border = 1,
			RGB = {0, 255, 0,},
		})
		if (taskProgress >= taskProgressMax) then --已完成的任务
			_frmNode.childUI["TaskNode" .. index].childUI["taskName"].handle.s:setColor(ccc3(255, 255, 0))
		end
		]]
		
		--任务描述
		local taskDescripe2 = taskDescripe
		--针对每日奖励，如果未开放游戏讨论，那么描述文字要改变
		if (taskType == hVar.TASK_TYPE.TASK_DALILY_REWARD) then --每日奖励
			--geyachao: 魔塔前线暂时不使用分享功能
			if (hVar.SYS_IS_NEWTD_APP == 1) or (hVar.SYS_IS_WEIXIN_SHARE_OPEN == 0) then --新塔防app程序，魔塔前线
				--苹果游戏讨论通常是打开状态，如果遇到出版本可能会临时关闭
				--如果是关闭状态，可直接领奖
				local nToBBSState = 1
				if (iChannelId == 106) or (iChannelId == 1002) or (iChannelId == 1014) or (iChannelId == 1013) then --安卓官网、taptap、好游快爆、预留渠道YZYZ，可以一直显示游戏讨论按钮
					--
				else
					--礼品码关闭状态
					if (g_MyVip_Param.openFlag ~= 1) then --苹果开关
						nToBBSState = 0
					end
				end
				
				if (nToBBSState == 1) then
					taskDescripe2 = hVar.tab_string["GetGameCoinEverydayOnceToDisguss_Task"]
				else
					taskDescripe2 = hVar.tab_string["GetGameCoinEverydayOnceFree_Task"]
				end
			else
				--分享给微信好友
				--
			end
		end
		_frmNode.childUI["TaskNode" .. index].childUI["taskDesc"] = hUI.label:new({
			parent = _frmNode.childUI["TaskNode" .. index].handle._n,
			x = -120,
			y = 20,
			font = hVar.FONTC,
			size = 26,
			align = "LC",
			text = hApi.StringDecodeEmoji(taskDescripe2), --解析表情
			border = 1,
			RGB = {255, 255, 255,},
		})
		
		--特殊的任务描述后缀
		if (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_N) then --通关指定关卡
			local mapName = typeId --地图名
			local difficulty = tabTask.difficulty or 0 --难度
			local tabM = hVar.MAP_INFO[mapName] or {}
			local icon_title = tabM.icon_title
			local taskDescW = _frmNode.childUI["TaskNode" .. index].childUI["taskDesc"]:getWH()
			--print("taskDescW=", taskDescW)
			--地图名的图片
			_frmNode.childUI["TaskNode" .. index].childUI["taskMapName"] = hUI.image:new({
				parent = _frmNode.childUI["TaskNode" .. index].handle._n,
				x = -54 + taskDescW,
				y = 24,
				model = icon_title,
				scale = 0.8,
			})
			
			--[[
			--难度文字
			_frmNode.childUI["TaskNode" .. index].childUI["diffDesc"] = hUI.label:new({
				parent = _frmNode.childUI["TaskNode" .. index].handle._n,
				x = 14 + taskDescW,
				y = 20,
				font = hVar.FONTC,
				size = 26,
				align = "LC",
				text = hVar.tab_string["__TEXT_Level"], --"难度"
				border = 1,
				RGB = {255, 255, 255,},
			})
			
			--难度图片
			local diffImg = ""
			if (difficulty == 0) then --普通
				diffImg = "misc/addition/difficulty_01.png"
			elseif (difficulty == 1) then --难度1
				diffImg = "misc/addition/difficulty_02.png"
			elseif (difficulty == 2) then --难度2
				diffImg = "misc/addition/difficulty_03.png"
			elseif (difficulty == 3) then --难度3
				diffImg = "misc/addition/difficulty_04.png"
			end
			--难度图片
			_frmNode.childUI["TaskNode" .. index].childUI["diffImg"] = hUI.image:new({
				parent = _frmNode.childUI["TaskNode" .. index].handle._n,
				x = 90 + taskDescW,
				y = 16,
				model = diffImg,
				scale = 0.7,
			})
			]]
		elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N) then --无损通关指定关卡
			local mapName = typeId --地图名
			local difficulty = tabTask.difficulty or 0 --难度
			local tabM = hVar.MAP_INFO[mapName] or {}
			local icon_title = tabM.icon_title
			local taskDescW = _frmNode.childUI["TaskNode" .. index].childUI["taskDesc"]:getWH()
			--print("taskDescW=", taskDescW)
			--地图名的图片
			_frmNode.childUI["TaskNode" .. index].childUI["taskMapName"] = hUI.image:new({
				parent = _frmNode.childUI["TaskNode" .. index].handle._n,
				x = -54 + taskDescW,
				y = 24,
				model = icon_title,
				scale = 0.8,
			})
			
			--[[
			--难度文字
			_frmNode.childUI["TaskNode" .. index].childUI["diffDesc"] = hUI.label:new({
				parent = _frmNode.childUI["TaskNode" .. index].handle._n,
				x = 14 + taskDescW,
				y = 20,
				font = hVar.FONTC,
				size = 26,
				align = "LC",
				text = hVar.tab_string["__TEXT_Level"], --"难度"
				border = 1,
				RGB = {255, 255, 255,},
			})
			
			--难度图片
			local diffImg = ""
			if (difficulty == 0) then --普通
				diffImg = "misc/addition/difficulty_01.png"
			elseif (difficulty == 1) then --难度1
				diffImg = "misc/addition/difficulty_02.png"
			elseif (difficulty == 2) then --难度2
				diffImg = "misc/addition/difficulty_03.png"
			elseif (difficulty == 3) then --难度3
				diffImg = "misc/addition/difficulty_04.png"
			end
			--难度图片
			_frmNode.childUI["TaskNode" .. index].childUI["diffImg"] = hUI.image:new({
				parent = _frmNode.childUI["TaskNode" .. index].handle._n,
				x = 90 + taskDescW,
				y = 16,
				model = diffImg,
				scale = 0.7,
			})
			]]
		end
		
		--[[
		--特殊的任务描述后缀
		if (taskType == hVar.TASK_TYPE.TASK_USE_TACTIC_N) then --使用指定战术卡
			local itemId = typeId --地图名
			local tabI = hVar.tab_item[itemId] or {}
			local icon_item = tabI.icon
			if icon_item then
				local taskDescW = _frmNode.childUI["TaskNode" .. index].childUI["taskDesc"]:getWH()
				--print("taskDescW=", taskDescW)
				--地图名的图片
				_frmNode.childUI["TaskNode" .. index].childUI["taskMapName"] = hUI.image:new({
					parent = _frmNode.childUI["TaskNode" .. index].handle._n,
					x = -86 + taskDescW,
					y = 14,
					model = icon_item,
					scale = 0.7,
				})
			end
		end
		]]
		
		--任务进度条
		_frmNode.childUI["TaskNode" .. index].childUI["progress"] = hUI.valbar:new({
			parent = _frmNode.childUI["TaskNode" .. index].handle._n,
			x = 80,
			y = -42.5,
			align = "LC",
			--back = {model = "misc/task/mission_progress_01.png", x = -4, y = -28, w = 488, h = 83,},
			w = 162,
			h = 16,
			model = "misc/task/mission_progress2.png",
			v = taskProgress,
			max = taskProgressMax,
		})
		
		--未完成的任务
		if (taskProgress < taskProgressMax) then
			--去完成任务的按钮
			_frmNode.childUI["TaskNode" .. index].childUI["btnToFinish"] = hUI.button:new({
				parent = _frmNode.childUI["TaskNode" .. index].handle._n,
				model = -1, --"misc/mask.png",
				x = TASK_WIDTH / 2 - 168,
				y = 8,
				--label = {x = 0, y = -1, z = 1, font = hVar.FONTC, text = hVar.tab_string["__TEXT_FrontTo2"], border = 1, align = "MC", size = 24, }, --"前往"
				w = 64,
				h = 64,
			})
			--九宫格
			local s9 = hApi.CCScale9SpriteCreate("data/image/misc/task/mission_go.png", 0, 0, 58, 58, _frmNode.childUI["TaskNode" .. index].childUI["btnToFinish"])
			
			--任务进度
			_frmNode.childUI["TaskNode" .. index].childUI["taskProgress"] = hUI.label:new({
				parent = _frmNode.childUI["TaskNode" .. index].handle._n,
				x = TASK_WIDTH / 2 - 220,
				y = -42,
				font = "numWhite",
				size = 20,
				align = "MC",
				text = "" .. taskProgress .. "/" .. taskProgressMax .. "",
				border = 1,
				RGB = {255, 255, 255,},
			})
		end
		
		--已完成的任务
		if (taskProgress >= taskProgressMax) then
			--去领奖的按钮
			_frmNode.childUI["TaskNode" .. index].childUI["btnTakeReward"] = hUI.button:new({
				parent = _frmNode.childUI["TaskNode" .. index].handle._n,
				model = -1, --"misc/mask.png",
				x = TASK_WIDTH / 2 - 168,
				y = 8,
				--label = {x = 0, y = -1, z = 1, font = hVar.FONTC, text = hVar.tab_string["__Get__"], border = 1, align = "MC", size = 24, }, --"领取"
				w = 64,
				h = 64,
			})
			--九宫格
			local s9 = hApi.CCScale9SpriteCreate("data/image/misc/task/mission_tick.png", 0, 0, 58, 58, _frmNode.childUI["TaskNode" .. index].childUI["btnTakeReward"])
			
			--叹号
			_frmNode.childUI["TaskNode" .. index].childUI["tanhao"] = hUI.image:new({
				parent = _frmNode.childUI["TaskNode" .. index].handle._n,
				x = TASK_WIDTH / 2 - 146,
				y = 28,
				model = "UI:TaskTanHao",
				w = 30,
				h = 30,
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
			_frmNode.childUI["TaskNode" .. index].childUI["tanhao"].handle._n:runAction(CCRepeatForever:create(sequence))
		end
		
		--[[
		--任务奖励文字前缀
		_frmNode.childUI["TaskNode" .. index].childUI["taskRewardPrefix"] = hUI.label:new({
			parent = _frmNode.childUI["TaskNode" .. index].handle._n,
			x = -TASK_WIDTH / 2 + 142,
			y = -29,
			font = hVar.FONTC,
			size = 22,
			align = "LC",
			text = hVar.tab_string["MadelGift"], --"奖励：",
			border = 1,
			RGB = {255, 255, 0,},
		})
		]]
		
		--任务奖励
		for r = 1, #taskReward, 1 do
			local rewardT = taskReward[r]
			local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
			local scaleR = 0.78
			
			--奖励父控件
			_frmNode.childUI["TaskNode" .. index].childUI["btnReward_" .. r] = hUI.button:new({ --作为按钮只是为了挂载子控件
				parent = _frmNode.childUI["TaskNode" .. index].handle._n,
				model = "misc/mask.png",
				x = -TASK_WIDTH / 2 + 200 + 104 + (r - 1) * 110,
				y = -26,
				w = 108,
				h = 46,
			})
			_frmNode.childUI["TaskNode" .. index].childUI["btnReward_" .. r].handle.s:setOpacity(0) --只挂载子控件，不显示
			
			--图标
			_frmNode.childUI["TaskNode" .. index].childUI["btnReward_" .. r].childUI["icon"] = hUI.image:new({
				parent = _frmNode.childUI["TaskNode" .. index].childUI["btnReward_" .. r].handle._n,
				model = tmpModel,
				x = 0 - 26,
				y = 1,
				w = itemWidth * scaleR,
				h = itemHeight * scaleR,
			})
			
			--子图标
			if sub_tmpModel then
				_frmNode.childUI["TaskNode" .. index].childUI["btnReward_" .. r].childUI["subIcon"] = hUI.image:new({
					parent = _frmNode.childUI["TaskNode" .. index].childUI["btnReward_" .. r].handle._n,
					model = sub_tmpModel,
					x = sub_pos_x * scaleR - 26,
					y = 1 + sub_pos_y * scaleR,
					w = sub_pos_w * scaleR,
					h = sub_pos_h * scaleR,
				})
			end
			
			--奖励数量
			_frmNode.childUI["TaskNode" .. index].childUI["btnReward_" .. r].childUI["num"] = hUI.label:new({
				parent = _frmNode.childUI["TaskNode" .. index].childUI["btnReward_" .. r].handle._n,
				x = 18 - 22,
				y = -1,
				font = hVar.FONTC,
				size = 24,
				align = "LC",
				text = "+" .. itemNum,
				border = 1,
				RGB = {255, 255, 0,},
			})
		end
		
		---------------------------------------------------------------------
		--可能存在滑动，校对前一个控件的相对位置
		if _frmNode.childUI["TaskNode" .. (index - 1)] then --前一个
			--实际相对距离
			local lastX = _frmNode.childUI["TaskNode" .. (index - 1)].data.x
			local lastY = _frmNode.childUI["TaskNode" .. (index - 1)].data.y
			local lastChatHeight = (TASK_HEIGHT + TASK_EACHOFFSET)
			
			--理论相对距离
			local thisX = lastX
			local thisY = lastY - lastChatHeight
			local ctrli = _frmNode.childUI["TaskNode" .. index]
			ctrli.handle._n:setPosition(thisX, thisY)
			ctrli.data.x = thisX
			ctrli.data.y = thisY
		end
	end
	
	--函数：收到完成任务成功的回调
	on_task_finish_success_event = function(result, taskId, rewardResult)
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--去掉挡操作
		hUI.NetDisable(0)
		
		if (result == 1) then
			--播放领取任务的音效
			hApi.PlaySound("turntable_finish")
			
			--再次查询任务（新）
			SendCmdFunc["task_type_query"]()
		end
	end
	
	--函数：收到周任务进度档位奖励领取成功的回调
	on_week_progress_takereward_success_event = function(result, index, rewardResult)
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--去掉挡操作
		hUI.NetDisable(0)
		
		if (result == 1) then
			--播放领取任务的音效
			hApi.PlaySound("turntable_finish")
			
			--本地缓存新增此档位领将记录
			current_TaskWeekRewardInfo[#current_TaskWeekRewardInfo+1] = index
			
			--更新左侧界面
			local ctrlI = _frmNode.childUI["TaskStone_" .. index]
			if ctrlI then
				ctrlI.childUI["finishTag"].handle._n:setVisible(true)
				ctrlI.childUI["tanhao"].handle._n:setVisible(false)
			end
		end
	end
	
	--函数：收到完成全部任务成功的回调
	on_task_finish_all_success_event = function(result, taskNum, rewardNum, rewardResult)
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--去掉挡操作
		hUI.NetDisable(0)
		
		if (result == 1) then
			--播放领取任务的音效
			hApi.PlaySound("turntable_finish")
			
			--再次查询任务（新）
			SendCmdFunc["task_type_query"]()
		end
	end
	
	--函数：横竖屏切换
	on_spine_screen_event = function()
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--关闭本界面
		OnClosePanel()
		
		--重绘本界面
		hGlobal.UI.InitMyTaskActivityFrm("reload") --测试
		--触发事件，显示任务界面
		hGlobal.event:event("LocalEvent_Phone_ShowMyTask", current_funcCallback)
	end
	
	--函数：刷新每日任务倒计时的timer
	refresh_task_timer = function()
		--如果未收到任务，不需要刷新tiemr
		--if (task_get_state ~= 1) then
		--	return
		--end
		
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--客户端的时间
		local localTime = os.time()
		
		--服务器的时间
		local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
		local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
		local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
		hostTime = hostTime - delteZone * 3600 --GMT+8时区
		
		--今日是周几
		local weekNum = os.date("*t", hostTime).wday - 1
		if (weekNum == 0) then
			weekNum = 7
		end
		
		--计算第二天0点的时间
		local tab = os.date("*t", hostTime)
		local year = tab.year
		local month = tab.month
		local szMonth = tostring(month)
		if (#szMonth < 2) then
			szMonth = "0" .. szMonth
		end
		local day = tab.day
		local szDay = tostring(day)
		if (#szDay < 2) then
			szDay = "0" .. szDay
		end
		
		local szTime = year .. "-" .. szMonth .. "-" .. szDay .. " 00:00:00"
		local nextDayTime = hApi.GetNewDate(szTime, "DAY", 1) --第二天0点的时间戳
		--print(szTime, nextDayTime)
		local deltaSeconds = nextDayTime - hostTime --秒数
		local hour = math.floor(deltaSeconds / 3600) --时
		local minute = math.floor((deltaSeconds - hour * 3600)/ 60) --分
		local second = deltaSeconds - hour * 3600 - minute * 60 --秒
		local day = (7 - weekNum) --天
		
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
		
		local sText = ""
		if (day > 0) then --大于1天
			sText = tostring(day) .. hVar.tab_string["__TEXT_Dat"] .. tostring(szHour) .. hVar.tab_string["__TEXT_Hour"]
		elseif (hour > 0) then --小于一天，大于一小时
			sText = tostring(szHour) .. hVar.tab_string["__TEXT_Hour"] .. tostring(szMinute) .. hVar.tab_string["__Minute"]
		else --小于一天，小于一小时
			sText = tostring(szMinute) .. hVar.tab_string["__Minute"] .. tostring(szSecond) .. hVar.tab_string["__Second"]
		end
		_frmNode.childUI["TaskRefreshLabel"]:setText(sText)
		
		--检测是否到了第二天，要重新获取任务
		local tab1 = os.date("*t", task_lasHostTime)
		local tab2 = os.date("*t", hostTime)
		if (tab1.year ~= tab2.year) or (tab1.month ~= tab2.month) or (tab1.day ~= tab2.day) then --到了第二天
			--重新查询任务
			BeginToOnQueryTask()
		end
	end
	
	--函数：选中某个任务按钮处理的逻辑
	OnSelectTaskButton = function(task_idx)
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print(task_idx)
		
		--标记选中的任务索引值
		local last_task_idx = current_focus_task_idx
		current_focus_task_idx = task_idx
		
		--更新选中框
		--隐藏上一次的选中框
		if (last_task_idx > 0) then
			if _frmNode.childUI["TaskNode" .. last_task_idx] then
				if _frmNode.childUI["TaskNode" .. last_task_idx].data.s92_task then
					_frmNode.childUI["TaskNode" .. last_task_idx].data.s92_task:setVisible(false)
				end
			end
		end
		
		--显示本次的
		if (current_focus_task_idx > 0) then
			if _frmNode.childUI["TaskNode" .. current_focus_task_idx] then
				if _frmNode.childUI["TaskNode" .. current_focus_task_idx].data.s92_task then
					_frmNode.childUI["TaskNode" .. current_focus_task_idx].data.s92_task:setVisible(true)
				end
			end
		end
	end
	
	--函数：点击某个任务跳转按钮处理的逻辑
	OnSelectTaskJumpToButton = function(task_idx)
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		--print("OnSelectTaskJumpToButton", task_idx)
		
		local tRecordI = current_TaskInfo[task_idx]
		local taskId = tRecordI.taskId
		local tabTask = hVar.tab_task[taskId] or {}
		local taskProgressMax = tabTask.maxProgress or 0 --任务总进度
		local taskReward = tabTask.reward or {} --任务奖励
		local taskType = tabTask.taskType
		local typeId = tabTask.typeId --任务指定id
		
		if (taskType == hVar.TASK_TYPE.TASK_DALILY_REWARD) then --每日奖励
			--针对每日奖励，如果未开放游戏讨论，那么直接领奖
			--geyachao: 魔塔前线暂时不使用分享功能
			if (hVar.SYS_IS_NEWTD_APP == 1) or (hVar.SYS_IS_WEIXIN_SHARE_OPEN == 0) then --新塔防app程序，魔塔前线
				--苹果游戏讨论通常是打开状态，如果遇到出版本可能会临时关闭
				--如果是关闭状态，可直接领奖
				local nToBBSState = 1
				if (iChannelId == 106) or (iChannelId == 1002) or (iChannelId == 1014) or (iChannelId == 1013) then --安卓官网、taptap、好游快爆、预留渠道YZYZ，可以一直显示游戏讨论按钮
					--
				else
					--礼品码关闭状态
					if (g_MyVip_Param.openFlag ~= 1) then --苹果开关
						nToBBSState = 0
					end
				end
				
				if (nToBBSState == 1) then
					--发起领取每日奖励指令
					Gift_Function["reward_1"]()
					
					--发送请求领取点击游戏讨论奖励
					SendCmdFunc["todisguss_rweard"]()
					
					--hGlobal.event:event("localEvent_ShowNewExSysFrm")
					--去taptap社区
					xlOpenUrl("https://www.taptap.com/app/63188/topic")
					
					--再次查询任务（新）
					SendCmdFunc["task_type_query"]()
				else
					--关闭本界面
					_frm.childUI["closeBtn"].data.code()
					
					--打开奖励
					--触发事件，打开奖励面板
					hGlobal.event:event("LocalEvent_Phone_ShowMyGift", 1) 
				end
			else
				--Gift_Function["reward_"..nowChoiceGift]()
				--分享给微信好友
				local shareType = hVar.SNS.wechat --微信好友
				local key = hVar.ShareKeyType.DayReward --每日奖励（分享给微信好友）
				hApi.ShareSNS(shareType, key, function()
					--再次查询任务（新）
					SendCmdFunc["task_type_query"]()
				end)
			end
		elseif (taskType == hVar.TASK_TYPE.TASK_TACTICCARD_ONCE) then --商城抽卡
			--关闭本界面
			_frm.childUI["closeBtn"].data.code()
			
			--打开商城
			--触发事件，显示新商店界面
			hGlobal.event:event("LocalEvent_Phone_ShowNetShopNewFrm", 1)
			
		elseif (taskType == hVar.TASK_TYPE.TASK_REDCHEST_ONCE) then --商城抽装
			--关闭本界面
			_frm.childUI["closeBtn"].data.code()
			
			--打开商城
			--触发事件，显示新商店界面
			hGlobal.event:event("LocalEvent_Phone_ShowNetShopNewFrm", 1)
			
		elseif (taskType == hVar.TASK_TYPE.TASK_REFRESH_SHOP) then --刷新商店
			--关闭本界面
			_frm.childUI["closeBtn"].data.code()
			
			--触发事件，显示商城界面
			local bOpenImmediate = true
			local current_funcCallback = function()
				--触发事件，显示任务界面
				hGlobal.event:event("LocalEvent_Phone_ShowMyTask", nil, true)
			end
			hGlobal.event:event("LocalEvent_Phone_ShowNetShopNewFrm", current_funcCallback, bOpenImmediate)
			
		elseif (taskType == hVar.TASK_TYPE.TASK_EQUIP_XILIAN) then --百炼成钢
			--关闭本界面
			_frm.childUI["closeBtn"].data.code()
			
			--模拟点击英雄令按钮
			local _frm2 = hGlobal.UI.Phone_MainPanelFrm
			if _frm2 then
				local _parent2 = _frm2.handle._n
				local _childUI2 = _frm2.childUI
				_childUI2["btnHero"].data.code()
			end
			--hGlobal.event:event("LocalEvent_Phone_ShowMyHerocard", 1)
			--hGlobal.event:event("LocalEvent_showHeroCardFrm", 0, 18001, 0)
			
		elseif (taskType == hVar.TASK_TYPE.TASK_BASE_BATTLE_WIN) then --小试牛刀
			--关闭本界面
			_frm.childUI["closeBtn"].data.code()
			
			--模拟点击战役按钮
			local _frm2 = hGlobal.UI.Phone_MainPanelFrm
			if _frm2 then
				local _parent2 = _frm2.handle._n
				local _childUI2 = _frm2.childUI
				_childUI2["menu_plot"].data.code()
			end
		elseif (taskType == hVar.TASK_TYPE.TASK_ENDLESS_SCORE) then --无尽使命
			--是否通关"仓亭之战"
			local isFinishMap39 = LuaGetPlayerMapAchi("world/td_309_ctzz", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第39关是否解锁
			if (isFinishMap39 == 0) then
				--冒字
				--local strText = "通关【仓亭之战】后，才能解锁无尽试炼！" --language
				local strText = hVar.tab_string["__TEXT_ENDLESS_BATTLE_archiLock"] --language
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
			
			--关闭本界面
			_frm.childUI["closeBtn"].data.code()
			
			--模拟点击娱乐地图按钮
			local _frm2 = hGlobal.UI.Phone_MainPanelFrm
			if _frm2 then
				local _parent2 = _frm2.handle._n
				local _childUI2 = _frm2.childUI
				_childUI2["menu_endless"].data.code()
			end
		elseif (taskType == hVar.TASK_TYPE.TASK_PVP_OPENCHEST) then --竞技锦囊
			--是否通关"绝处逢生"
			local isFinishMap29 = LuaGetPlayerMapAchi("world/td_209_gcjy", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第29关是否解锁
			if (isFinishMap29 == 0) then
				--冒字
				--local strText = "通关【绝处逢生】后，才能解锁夺塔奇兵！" --language
				local strText = hVar.tab_string["__TEXT_PVP_archiLock"] --language
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
			
			--关闭本界面
			_frm.childUI["closeBtn"].data.code()
			
			--触发事件：通知显示pvp界面
			--hGlobal.event:event("localEvent_ShowPhone_PVPRoomFrm", 1, 4)
			--模拟点击夺塔奇兵按钮
			local _frm2 = hGlobal.UI.Phone_MainPanelFrm
			if _frm2 then
				local _parent2 = _frm2.handle._n
				local _childUI2 = _frm2.childUI
				_childUI2["menu_pvp"].data.code()
			end
			
		elseif (taskType == hVar.TASK_TYPE.TASK_PVP_BATTLE) then --竞技切磋
			--是否通关"绝处逢生"
			local isFinishMap29 = LuaGetPlayerMapAchi("world/td_209_gcjy", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第29关是否解锁
			if (isFinishMap29 == 0) then
				--冒字
				--local strText = "通关【绝处逢生】后，才能解锁夺塔奇兵！" --language
				local strText = hVar.tab_string["__TEXT_PVP_archiLock"] --language
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
			
			--关闭本界面
			_frm.childUI["closeBtn"].data.code()
			
			--触发事件：通知显示pvp界面
			--hGlobal.event:event("localEvent_ShowPhone_PVPRoomFrm", 1, 2)
			--模拟点击夺塔奇兵按钮
			local _frm2 = hGlobal.UI.Phone_MainPanelFrm
			if _frm2 then
				local _parent2 = _frm2.handle._n
				local _childUI2 = _frm2.childUI
				_childUI2["menu_pvp"].data.code()
			end
			
		elseif (taskType == hVar.TASK_TYPE.TASK_PVPTOKEN_USE) then --兵符达人
			--是否通关"广宗之战"
			local isFinishMap09 = LuaGetPlayerMapAchi("world/td_009_jmhj", hVar.ACHIEVEMENT_TYPE.LEVEL) or 0 --第9关是否解锁
			if (isFinishMap09 == 0) then
				--冒字
				--local strText = "通关【广宗之战】后，才能解锁娱乐专区！" --language
				local strText = hVar.tab_string["__TEXT_ENTERTAINMENT_archiLock"] --language
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
			
			--关闭本界面
			_frm.childUI["closeBtn"].data.code()
			
			--模拟点击娱乐地图按钮
			local _frm2 = hGlobal.UI.Phone_MainPanelFrm
			if _frm2 then
				local _parent2 = _frm2.handle._n
				local _childUI2 = _frm2.childUI
				_childUI2["menu_endless"].data.code()
			end
			
		elseif (taskType == hVar.TASK_TYPE.TASK_OPEN_WEPONCHEST) or (taskType == hVar.TASK_TYPE.TASK_OPEN_TACTICCHEST)
		or (taskType == hVar.TASK_TYPE.TASK_OPEN_PETCHEST) or (taskType == hVar.TASK_TYPE.TASK_OPEN_EQUIPCHEST) then --开启武器宝箱、开启战术宝箱、开启宠物宝箱、开启装备宝箱
			--关闭本界面
			_frm.childUI["closeBtn"].data.code()
			
			--触发事件，显示宝箱界面
			local bOpenImmediate = true
			local current_funcCallback = function()
				--触发事件，显示任务界面
				hGlobal.event:event("LocalEvent_Phone_ShowMyTask", nil, true)
			end
			hGlobal.event:event("LocalEvent_Phone_ShowPhoneChestFrame", current_funcCallback, bOpenImmediate)
			
		elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_N) then --通关指定关卡
			--关闭本界面
			_frm.childUI["closeBtn"].data.code()
			
			--触发事件，显示地图包界面
			local mapName = typeId --地图名
			local difficulty = tabTask.difficulty or 0 --难度
			local tabM = hVar.MAP_INFO[mapName] or {}
			local dlcMapPackageName = tabM.dlcMapPackageName --所属的地图包名字
			
			local bOpenImmediate = true
			local current_funcCallback = function()
				--触发事件，显示任务界面
				hGlobal.event:event("LocalEvent_Phone_ShowMyTask", nil, true)
			end
			hGlobal.event:event("LocalEvent_Phone_ShowDLCMapInfoFrm", dlcMapPackageName, current_funcCallback, true, mapName, difficulty)
			
		elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_NOHURT_N) then --无损通关指定关卡
			--关闭本界面
			_frm.childUI["closeBtn"].data.code()
			
			--触发事件，显示地图包界面
			local mapName = typeId --地图名
			local difficulty = tabTask.difficulty or 0 --难度
			local tabM = hVar.MAP_INFO[mapName] or {}
			local dlcMapPackageName = tabM.dlcMapPackageName --所属的地图包名字
			
			local bOpenImmediate = true
			local current_funcCallback = function()
				--触发事件，显示任务界面
				hGlobal.event:event("LocalEvent_Phone_ShowMyTask", nil, true)
			end
			hGlobal.event:event("LocalEvent_Phone_ShowDLCMapInfoFrm", dlcMapPackageName, current_funcCallback, true, mapName, difficulty)
		elseif (taskType == hVar.TASK_TYPE.TASK_QSZD_WAVE) then --前哨阵地波次
			--关闭本界面
			_frm.childUI["closeBtn"].data.code()
			
			--触发事件，显示黑龙对话界面
			local bOpenImmediate = true
			local current_funcCallback = function()
				--触发事件，显示任务界面
				hGlobal.event:event("LocalEvent_Phone_ShowMyTask", nil, true)
			end
			hGlobal.event:event("LocalEvent_Phone_ShowBlackDragonTalkFrm", 2, current_funcCallback, true)
		elseif (taskType == hVar.TASK_TYPE.TASK_RANDOMMAP_STAGE) then --随机迷宫层数
			--关闭本界面
			_frm.childUI["closeBtn"].data.code()
			
			--触发事件，显示黑龙对话界面
			local bOpenImmediate = true
			local current_funcCallback = function()
				--触发事件，显示任务界面
				hGlobal.event:event("LocalEvent_Phone_ShowMyTask", nil, true)
			end
			hGlobal.event:event("LocalEvent_EnterRandTestMap", current_funcCallback, true)
		elseif (taskType == hVar.TASK_TYPE.TASK_MAP_SUCCESS_DIFFICULTY_N) then --通关指定关卡难度
			--关闭本界面
			_frm.childUI["closeBtn"].data.code()
			
			--触发事件，显示黑龙对话界面
			local bOpenImmediate = true
			local current_funcCallback = function()
				--触发事件，显示任务界面
				hGlobal.event:event("LocalEvent_Phone_ShowMyTask", nil, true)
			end
			
			local mapName = typeId
			local pageIndex = 0
			if mapName == hVar.MuChaoZhiZhanMap then
				pageIndex = 1
			elseif mapName == hVar.DuoBaoQiBingMap then
				pageIndex = 3
			end
			
			if pageIndex ~= 0 then
				hGlobal.event:event("LocalEvent_Phone_ShowBlackDragonTalkFrm", pageIndex, current_funcCallback, true)
			end
		elseif (taskType == hVar.TASK_TYPE.TASK_SHARE_COUINT) then --分享次数
			--关闭本界面
			_frm.childUI["closeBtn"].data.code()
			
			--触发事件，显示战车皮肤界面
			local bOpenImmediate = true
			local current_funcCallback = function()
				--触发事件，显示任务界面
				hGlobal.event:event("LocalEvent_Phone_ShowMyTask", nil, true)
			end
			local selectedIdx = LuaGetHeroTankIdx()
			hGlobal.event:event("LocalEvent_TankAvaterFrm", selectedIdx, current_funcCallback, bOpenImmediate)
		end
	end
	
	--函数：点击某个任务领奖按钮处理的逻辑
	OnSelectTaskTakeRewardButton = function(task_idx)
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		--print("OnSelectTaskTakeRewardButton", task_idx)
		
		local tRecordI = current_TaskInfo[task_idx]
		local taskId = tRecordI.taskId
		local tabTask = hVar.tab_task[taskId] or {}
		local taskProgressMax = tabTask.maxProgress or 0 --任务总进度
		local taskReward = tabTask.reward or {} --任务奖励
		local taskType = tabTask.taskType
		
		--如果本地未联网，那么提示没联网
		if (g_cur_net_state == -1) then --未联网
			--冒字
			--local strText = "查看任务需要联网" --language
			local strText = hVar.tab_string["__TEXT_Cant_UseDepletion10_Net"] --language
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
		
		--背包已满，无法签到
		if (LuaCheckPlayerBagCanUse() == 0) then
			--冒字
			--local strText = "背包已满，无法领取道具" --language
			local strText = hVar.tab_string["__TEXT_BAGLISTISFULL"] --language
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
		
		--检测临时背包是否有道具
		if (LuaCheckGiftBag() == 1) then
			--"临时背包有道具待领取，请领完后再操作"
			local strText = hVar.tab_string["__TEXT_BAGLISTISFULL11"] --language
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
		
		--一开始屏蔽操作
		hUI.NetDisable(30000)
		
		--发起请求，领取任务奖励
		SendCmdFunc["task_type_takereward"](taskId)
	end
	
	--函数：点击一键领取按钮处理的逻辑
	OnSelectTaskTakeRewardAllButton = function(task_idx)
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		--print("OnSelectTaskTakeRewardButton", task_idx)
		
		--如果本地未联网，那么提示没联网
		if (g_cur_net_state == -1) then --未联网
			--冒字
			--local strText = "查看任务需要联网" --language
			local strText = hVar.tab_string["__TEXT_Cant_UseDepletion10_Net"] --language
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
		
		--背包已满，无法领取
		if (LuaCheckPlayerBagCanUse() == 0) then
			--冒字
			--local strText = "背包已满，无法领取道具" --language
			local strText = hVar.tab_string["__TEXT_BAGLISTISFULL"] --language
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
		
		--检测临时背包是否有道具
		if (LuaCheckGiftBag() == 1) then
			--"临时背包有道具待领取，请领完后再操作"
			local strText = hVar.tab_string["__TEXT_BAGLISTISFULL11"] --language
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
		
		--一开始屏蔽操作
		hUI.NetDisable(30000)
		
		--发起请求，一键领取全部任务奖励
		SendCmdFunc["task_type_takereward_all"]()
	end
	
	--函数：点击周活跃度奖励按钮处理的逻辑
	OnClickTaskStoneWeekRewardButton = function(index)
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--此档位的奖励是否已领取
		local rewardFlag = 0
		for t = 1, #current_TaskWeekRewardInfo, 1 do
			local index_t = current_TaskWeekRewardInfo[t]
			if (index_t == index) then --找到了
				rewardFlag = 1
				break
			end
		end
		
		--此档位的奖励是否已达成
		local finishFlag = 0
		local tInfo = hVar.TASK_STONE_COST[index]
		local num = tInfo.num
		if (current_TaskStoneNum >= num) then
			finishFlag = 1
		end
		
		--已达成奖励条件，并且未领将
		--print("index=", index)
		--print("current_TaskStoneNum=", current_TaskStoneNum)
		--print("num=", num)
		--print("已达成=", finishFlag)
		--print("已领奖=", rewardFlag)
		if (finishFlag == 1)  and (rewardFlag == 0) then
			--挡操作
			hUI.NetDisable(30000)
			
			--请求领取周任务（新）进度奖励
			SendCmdFunc["taskstone_week_takereward"](index)
		else
			--显示奖励tip
			local rewardT = tInfo.reward
			local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
			
			local title = itemName
            local titleColor = ccc3(255, 196, 0)
            local icon = tmpModel
            local iconW = 72
            local iconH = 72
            local content = string.format(hVar.tab_string["__TEXT_TaskStoneProgreeReward"], num)
            hApi.ShowGeneralMiniTip(title, titleColor, icon, iconW, iconH, content, itemNum)
		end
	end
	
	--函数：刷新任务界面的滚动
	refresh_dlcmapinfo_UI_task_loop = function()
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local SPEED = 50 --速度
		--print(b_need_auto_fixing_task)
		
		if b_need_auto_fixing_task then
			--检测是否滑动到了最顶部或最底部
			local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
			local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
			delta1_ly, deltNa_ry = getUpDownOffset_task()
			--print(delta1_ly, deltNa_ry)
			--delta1_ly +:在下底线之上 /-:在下底线之下
			--deltNa_ry +:在下底线之上 /-:在下底线之下
			
			--print("delta1_ly=" .. delta1_ly, ", deltNa_rx=" .. deltNa_rx)
			--如果第一个活动的头像跑到下边，那么优先将第一个活动头像贴边
			if (delta1_ly < 0) then
				--print("优先将第一个活动头像贴边")
				--需要修正
				--不会选中活动
				selected_taskEx_idx = 0 --选中的活动索引
				
				--没有惯性
				draggle_speed_y_task = 0
				
				local speed = SPEED
				if ((delta1_ly + speed) > 0) then --防止走过
					speed = -delta1_ly
					delta1_ly = 0
				end
				
				--每个按钮向上侧做运动
				for i = 1, #current_TaskInfo, 1 do
					local ctrli = _frmNode.childUI["TaskNode" .. i]
					--if (ctrli.data.selected == 0) then --只处理未选中的活动卡牌
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x, pos_y + speed
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
				end
				
				--上滑动翻页不显示，下滑动翻页显示
				_frmNode.childUI["TaskPageUp"].handle.s:setVisible(false) --上翻页提示
				_frmNode.childUI["TaskPageDown"].handle.s:setVisible(true) --下翻页提示
			elseif (delta1_ly ~= 0) and (deltNa_ry > 0) then --第一个头像没有贴上侧，并且最后一个头像没有贴下侧，那么再将最后一个活动头像贴边
				--print("将最后一个活动头像贴边")
				--需要修正
				--不会选中活动
				selected_taskEx_idx = 0 --选中的活动索引
				
				--没有惯性
				draggle_speed_y_task = 0
				
				local speed = SPEED
				if ((deltNa_ry - speed) < 0) then --防止走过
					speed = deltNa_ry
					deltNa_ry = 0
				end
				
				--每个按钮向下侧做运动
				for i = 1, #current_TaskInfo, 1 do
						local ctrli = _frmNode.childUI["TaskNode" .. i]
					--if (ctrli.data.selected == 0) then --只处理未选中的活动卡牌
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
				_frmNode.childUI["TaskPageUp"].handle.s:setVisible(true) --上分翻页提示
				_frmNode.childUI["TaskPageDown"].handle.s:setVisible(false) --下分翻页提示
			elseif (draggle_speed_y_task ~= 0) then --沿着当前的速度方向有惯性地运动一会
				--print("沿着当前的速度方向有惯性地运动一会", draggle_speed_y_task)
				--不会选中活动
				selected_taskEx_idx = 0 --选中的活动索引
				--print("    ->   draggle_speed_y_task=", draggle_speed_y_task)
				
				if (draggle_speed_y_task > 0) then --朝上运动
					local speed = (draggle_speed_y_task) * 1.0 --系数
					friction_task = friction_task - 0.5
					draggle_speed_y_task = draggle_speed_y_task + friction_task --衰减（正）
					
					if (draggle_speed_y_task < 0) then
						draggle_speed_y_task = 0
					end
					
					--最后一个活动的坐标不能跑到最下侧的上边去
					if ((deltNa_ry + speed) > 0) then --防止走过
						speed = -deltNa_ry
						deltNa_ry = 0
						
						--没有惯性
						draggle_speed_y_task = 0
					end
					
					--每个按钮向上侧做运动
					for i = 1, #current_TaskInfo, 1 do
							local ctrli = _frmNode.childUI["TaskNode" .. i]
						--if (ctrli.data.selected == 0) then --只处理未选中的活动卡牌
							local pos_x, pos_y = ctrli.data.x, ctrli.data.y
							
							--本地运动到达的坐标
							local to_x, to_y = pos_x, pos_y + speed
							
							--设置新坐标
							ctrli.data.x = to_x
							ctrli.data.y = to_y
							ctrli.handle._n:setPosition(to_x, to_y)
						--end
					end
				elseif (draggle_speed_y_task < 0) then --朝下运动
					local speed = (draggle_speed_y_task) * 1.0 --系数
					friction_task = friction_task + 0.5
					draggle_speed_y_task = draggle_speed_y_task + friction_task --衰减（负）
					
					if (draggle_speed_y_task > 0) then
						draggle_speed_y_task = 0
					end
					
					--第一个活动的坐标不能跑到最上侧的下边去
					if ((delta1_ly + speed) < 0) then --防止走过
						speed = -delta1_ly
						delta1_ly = 0
						
						--没有惯性
						draggle_speed_y_task = 0
					end
					
					--每个按钮向下侧做运动
					for i = 1, #current_TaskInfo, 1 do
							local ctrli = _frmNode.childUI["TaskNode" .. i]
						--if (ctrli.data.selected == 0) then --只处理未选中的活动卡牌
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
					_frmNode.childUI["TaskPageUp"].handle.s:setVisible(false) --上分翻页提示
				else
					_frmNode.childUI["TaskPageUp"].handle.s:setVisible(true) --上分翻页提示
				end
				if (deltNa_ry == 0) then
					_frmNode.childUI["TaskPageDown"].handle.s:setVisible(false) --下分翻页提示
				else
					_frmNode.childUI["TaskPageDown"].handle.s:setVisible(true) --下分翻页提示
				end
			else --停止运动
				b_need_auto_fixing_task = false
				friction_task = 0
			end
		end
	end
	
	--函数：异步绘制任务条目的timer
	refresh_async_paint_task_loop = function()
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--如果待异步绘制表里有内容，逐一绘制
		if (#current_async_paint_list_task > 0) then
			local loopCount = ASYNC_PAINTNUM_ONCE_TASK
			if (loopCount > #current_async_paint_list_task) then
				loopCount = #current_async_paint_list_task
			end
			
			--一次绘制多条
			for loop = 1, loopCount, 1 do
				--取第一项
				local pivot = 1
				local tRecordI = current_async_paint_list_task[pivot]
				local index = tRecordI.index
				
				--先删除虚控件
				hApi.safeRemoveT(_frmNode.childUI, "TaskNode" .. index)
				
				--再创建实体控件
				on_create_single_task_UI(index, tRecordI)
				
				table.remove(current_async_paint_list_task, pivot)
			end
		end
	end
	
	--函数：获得任务第一个控件和最后一个控件距离最左面边界线和最右面边界线的距离
	getUpDownOffset_task = function()
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--第一个任务的数据
		local ActivityBtn1 = _frmNode.childUI["TaskNode1"]
		local btn1_cx, btn1_cy = 0, 0 --第一个DLC地图面板中心点位置
		local btn1_ly = 0 --第一个DLC地图面板最上侧的x坐标
		local delta1_ly = 0 --第一个DLC地图面板距离上侧边界的距离
		if ActivityBtn1 then
			btn1_cx, btn1_cy = ActivityBtn1.data.x, ActivityBtn1.data.y --第一个活动中心点位置
			btn1_ly = btn1_cy + ACTIVITY_HEIGHT / 2 --第一个活动最上侧的x坐标
			delta1_ly = btn1_ly + 65 - 50 --第一个活动距离上侧边界的距离
		end
		
		--最后一个任务的数据
		local ActivityBtnN = _frmNode.childUI["TaskNode" .. #current_TaskInfo]
		local btnN_cx, btnN_cy = 0, 0 --最后一个DLC地图面板中心点位置
		local btnN_ry = 0 --最后一个DLC地图面板最下侧的x坐标
		local deltNa_ry = 0 --最后一个DLC地图面板距离下侧边界的距离
		if ActivityBtnN then
			btnN_cx, btnN_cy = ActivityBtnN.data.x, ActivityBtnN.data.y --最后一个活动中心点位置
			btnN_ry = btnN_cy - ACTIVITY_HEIGHT / 2 --最后一个活动最下侧的x坐标
			deltNa_ry = btnN_ry + 561 --最后一个活动距离下侧边界的距离
		end
		
		--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
		
		return delta1_ly, deltNa_ry
	end
	
	--函数: 动态加载资源
	__DynamicAddRes = function()
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		print("函数: 动态加载资源")
		
		--加载资源
		--动态加载宝物背景图
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/task/mission_panel.png")
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/task/mission_panel.png")
			print("加载任务背景大图！")
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
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--删除资源
		--删除竞技场背景图
		_childUI["panel_bg"].handle._n:removeChild(_childUI["panel_bg"].data.pSprite, true)
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/task/mission_panel.png")
		if texture then
			CCTextureCache:sharedTextureCache():removeTexture(texture)
			print("清空任务背景大图！")
		end
	end
	
	--函数：更新提示当前哪个分页可以有领取的了
	RefreshTaskAchievementFinishPage = function()
		local _frm = hGlobal.UI.PhoneTaskFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--检测是否有签到活动
		local bHaveSignInActivity = hApi.CheckNewActivitySignIn()
		if _frmNode.childUI["Btn_SignIn"] then
			if _frmNode.childUI["Btn_SignIn"].childUI["NoteJianTou"] then
				_frmNode.childUI["Btn_SignIn"].childUI["NoteJianTou"].handle.s:setVisible(bHaveSignInActivity)
			end
		end
		
		--检测是否有可以领取的任务
		local bHaveFinishedTask = hApi.CheckDailyQuest() --日常任务检测（返回 true/false, 有任务完成返回true）
		if _frmNode.childUI["Btn_Task"] then
			if _frmNode.childUI["Btn_Task"].childUI["NoteJianTou"] then
				_frmNode.childUI["Btn_Task"].childUI["NoteJianTou"].handle.s:setVisible(bHaveFinishedTask)
			end
		end
		
		--检测是否有活动
		local bHaveActivity = hApi.CheckNewActivity()
		if _frmNode.childUI["Btn_Activity"] then
			if _frmNode.childUI["Btn_Activity"].childUI["NoteJianTou"] then
				_frmNode.childUI["Btn_Activity"].childUI["NoteJianTou"].handle.s:setVisible(bHaveActivity)
			end
		end
		
		--检测是否有邮件
		local bHaveMailNotice = ((g_mailNotice == 1) and true or false)
		if _frmNode.childUI["Btn_Mail"] then
			if _frmNode.childUI["Btn_Mail"].childUI["NoteJianTou"] then
				_frmNode.childUI["Btn_Mail"].childUI["NoteJianTou"].handle.s:setVisible(bHaveMailNotice)
			end
		end
	end
	
	--监听：登入gamecenter成功
	--hGlobal.event:listen("Event_GameCenter_ConnectSuccess", "__TaskGameCenter__", OnConnectGameCenterSuccess)
end

--监听关闭宝箱界面事件
hGlobal.event:listen("clearPhoneChestFrm", "__CloseTaskFrm", function()
	if hGlobal.UI.PhoneTaskFrm then
		if (hGlobal.UI.PhoneTaskFrm.data.show == 1) then
			--关闭本界面
			OnClosePanel()
		end
	end
end)

--监听打开任务、成就、活动界面通知事件
hGlobal.event:listen("LocalEvent_Phone_ShowMyTask", "__ShowTaskFrm", function(callback, bOpenImmediate)
	hGlobal.UI.InitMyTaskActivityFrm("reload")
	
	--触发事件，显示积分、金币界面
	--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
	
	--直接打开
	if bOpenImmediate then
		--显示道具界面
		hGlobal.UI.PhoneTaskFrm:show(1)
		hGlobal.UI.PhoneTaskFrm:active()
		
		--打开上一次的分页（默认显示第2个分页: 任务）
		local lastPageIdx = CurrentSelectRecord.pageIdx
		if (lastPageIdx == 0) then
			lastPageIdx = 1
		end
		
		--存储回调事件
		current_funcCallback = callback
		
		CurrentSelectRecord.pageIdx = 0
		CurrentSelectRecord.contentIdx = 0
		OnClickPageBtn(lastPageIdx)
		
		--更新提示当前哪个分页可以有领取的了
		RefreshTaskAchievementFinishPage()
		
		--防止重复调用
		_bCanCreate = false
		
		return
	end
	
	--防止重复调用
	if _bCanCreate then
		_bCanCreate = false
		
		--步骤1: 绘制第一个分页，并将控件设置成初始位置（屏幕外，为步骤二播放动画做准备）
		local actM1 = CCCallFunc:create(function()
			--显示道具界面
			hGlobal.UI.PhoneTaskFrm:show(1)
			hGlobal.UI.PhoneTaskFrm:active()
			
			--打开上一次的分页（默认显示第2个分页: 任务）
			local lastPageIdx = CurrentSelectRecord.pageIdx
			if (lastPageIdx == 0) then
				lastPageIdx = 1
			end
			
			--存储回调事件
			current_funcCallback = callback
			
			CurrentSelectRecord.pageIdx = 0
			CurrentSelectRecord.contentIdx = 0
			OnClickPageBtn(lastPageIdx)
			
			--更新提示当前哪个分页可以有领取的了
			RefreshTaskAchievementFinishPage()
			
			--初始设置坐标
			--主面板设置到左侧屏幕外面
			local _frm = hGlobal.UI.PhoneTaskFrm
			local dx = BOARD_WIDTH
			_frm:setXY(_frm.data.x + dx, _frm.data.y)
		end)
		
		--步骤2: 动画进入控件
		local actM2 = CCCallFunc:create(function()
			--本面板
			local _frm = hGlobal.UI.PhoneTaskFrm
			
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
		local _frm = hGlobal.UI.PhoneTaskFrm
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

--监听：获得活动列表，记录上一次获得的活动信息（用于主界面提示是否有新活动）
local lastReceivedActivityTable = {} --最近一次获得的活动表
local lastReceivedActivityTime = 0 --最近一次获得的活动时间
hGlobal.event:listen("localEvent_UpdateActivityInfo", "__Sys_ActivityInfo", function(t)
	--存储数据
	lastReceivedActivityTable = t
	lastReceivedActivityTime = hApi.GetNewDate(g_systime) --服务器时间
	--print("获得活动列表，记录上一次获得的活动信息（用于主界面提示是否有新活动）", g_systime)
end)

--检测是否有新活动（返回 true/false, 有新活动返回true）
hApi.CheckNewActivity = function()
	local ActivityAidList = LuaGetActivityAidList(g_curPlayerName)
	local localTime = os.time() --客户端时间
	local currentHostTime = localTime - g_localDeltaTime --服务器时间(Local = Host + deltaTime)
	local pasttime = currentHostTime - lastReceivedActivityTime --距离上一次获得活动的间隔时间
	--print("检测是否有新活动", lastReceivedActivityTime, currentHostTime, pasttime)
	
	local bNewActivity = false --是否有新活动
	
	for i = 1, #lastReceivedActivityTable, 1 do
		local listI = lastReceivedActivityTable[i] --第i项
		if (listI) then --存在活动信息第i项表
			local activityId = listI.aid --活动id
			local activityType = listI.ptype --活动类型
			local activityName = listI.title --活动名称
			local activityAwards = listI.prize --活动奖励表
			local activityDesc = listI.describe --活动描述
			local activityBeginDate = tonumber(listI.time_begin) --活动开始时间
			local activityEndDate = tonumber(listI.time_end) --活动结束时间
			
			--每走进来一次，都会改变时间
			activityBeginDate = activityBeginDate - pasttime
			activityEndDate = activityEndDate - pasttime
			
			--检测每个活动的状态
			local activityState = 0 --活动状态(0:未开始 / 1:进行中 / 2:已结束)
			if (activityBeginDate > 0) then
				activityState = 0
			elseif (activityEndDate < 0) then
				activityState = 2
			else
				activityState = 1
			end
			
			--未开始的活动
			--geyachao: 未开启的活动，就别叹号提示了，免得误解活动已经开始
			--[[
			if (activityState == 0) then
				local bViewed = false --是否已查看过
				for ai = 1, #ActivityAidList, 1 do
					if (ActivityAidList[ai] == (-activityId)) then --找到了
						bViewed = true --看过了
						break
					end
				end
				
				--未看过的，标记有新活动
				if (not bViewed) then
					bNewActivity = true
					break
				end
			end
			]]
			
			--print("activityState=", activityState)
			--正在进行的活动
			if (activityState == 1) then
				if (activityType ~=10022) then --新玩家14日签到活动，不算在普通活动里
					local bViewed = false --是否已查看过
					for ai = 1, #ActivityAidList, 1 do
						if (ActivityAidList[ai] == activityId) then --找到了
							bViewed = true --看过了
							break
						end
					end
					
					--未看过的，标记有新活动
					if (not bViewed) then
						bNewActivity = true
						break
					end
				end
			end
			
			--[[
			--检测新玩家14日签到活动，是否今日可签到
			local signList = LuaGetActivitySignInList(g_curPlayerName)
			local progress = signList.progress or 0 --已完成签到天数
			local progressMax = signList.progressMax or 14 --总天数
			--print("progress=", progress)
			--print("progressMax=", progressMax)
			if (progress < progressMax) then --签到活动未结束
				--检测上一次签到的日期是否是昨天或更早时间
				local signInDay = signList.signInDay or 0 --可签到的天数
				--print("signInDay=", signInDay)
				if (signInDay > progress) then
					bNewActivity = true --标记需要叹号
					break
				end
			end
			]]
			
			--检测消费转盘活动，是否有抽奖次数
			if (activityType == 10024) then
				local activity_turntable_list = LuaGetActivityTurnTableList(g_curPlayerName)
				local aid = activity_turntable_list.activityId or 0
				local ptype = activity_turntable_list.activityType or 0
				local count = activity_turntable_list.count or 0
				if (aid == activityId) and (ptype == activityType) then
					if (count > 0) then
						bNewActivity = true --标记需要叹号
						break
					end
				end
			end
		end
	end
	
	return bNewActivity
end

--检测是否有新的14日签到互动（返回 true/false, 有新14日签到活动返回true）
hApi.CheckNewActivitySignIn = function()
	local ActivityAidList = LuaGetActivityAidList(g_curPlayerName)
	local localTime = os.time() --客户端时间
	local currentHostTime = localTime - g_localDeltaTime --服务器时间(Local = Host + deltaTime)
	local pasttime = currentHostTime - lastReceivedActivityTime --距离上一次获得活动的间隔时间
	--print("检测是否有新活动", lastReceivedActivityTime, currentHostTime, pasttime)
	
	local bNewActivity = false --是否有新活动
	
	--检测新玩家14日签到活动，是否今日可签到
	local signList = LuaGetActivitySignInList(g_curPlayerName)
	local progress = signList.progress or 0 --已完成签到天数
	local progressMax = signList.progressMax or 14 --总天数
	--print("progress=", progress)
	--print("progressMax=", progressMax)
	if (progress < progressMax) then --签到活动未结束
		--检测上一次签到的日期是否是昨天或更早时间
		local signInDay = signList.signInDay or 0 --可签到的天数
		--print("signInDay=", signInDay)
		if (signInDay > progress) then
			bNewActivity = true --标记需要叹号
		end
	end
	
	return bNewActivity
end

--test
--[[
--测试代码
if hGlobal.UI.PhoneTaskFrm then --任务成就面板
	hGlobal.UI.PhoneTaskFrm:del()
	hGlobal.UI.PhoneTaskFrm = nil
end
hGlobal.UI.InitMyTaskActivityFrm("include") --测试
--触发事件，显示成就、任务、活动界面
hGlobal.event:event("LocalEvent_Phone_ShowMyTask")
--LuaAddPlayerCountVal(hVar.MEDAL_TYPE.killUB, 11111)
--LuaSetPlayerMedal(5, 0)
--SendCmdFunc["update_quest"]({{2,7,3,0}})
--LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.buildTT, hVar.UNIT_TAG_TYPE.TOWER.TAG_DUTA, 11111)
--LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.rollTactic, 11111)
--LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.xilianN, 11111)
--LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.openChest, 11111)
]]


