


--------------------------------
--系统邮件界面
--------------------------------


local BOARD_WIDTH = 720 --DLC地图面板面板的宽度
local BOARD_HEIGHT = 720 --DLC地图面板面板的高度
local BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 0
local BOARD_OFFSETY = -0 --DLC地图面板面板y偏移中心点的值
local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --DLC地图面板面板的x位置（最左侧）
local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --DLC地图面板面板的y位置（最顶侧）

--横屏模式
if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
	BOARD_WIDTH = 720 --DLC地图面板面板的宽度
	BOARD_HEIGHT = 720 --DLC地图面板面板的高度
	BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 20
	BOARD_OFFSETY = 0 --DLC地图面板面板y偏移中心点的值
	BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --DLC地图面板面板的x位置（最左侧）
	BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --DLC地图面板面板的y位置（最顶侧）
end

local PAGE_BTN_LEFT_X = 480 --第一个分页按钮的x偏移
local PAGE_BTN_LEFT_Y = -6 --第一个分页按钮的x偏移
local PAGE_BTN_OFFSET_X = 140 --每个分页按钮的间距

--临时UI管理
local leftRemoveFrmList = {} --左侧控件集
local middleRemoveFrmList = {} --中侧控件集
local rightRemoveFrmList = {} --右侧控件集
local _removeLeftFrmFunc = hApi.DoNothing --清空左侧所有的临时控件
local _removeMiddleFrmFunc = hApi.DoNothing --清空中侧所有的临时控件
local _removeRightFrmFunc = hApi.DoNothing --清空右侧所有的临时控件

--局部函数
local OnClickPageBtn = hApi.DoNothing --点击分页按钮

--分页1：显示游戏币变化界面
local OnCreateSystemMailInfoFrame = hApi.DoNothing --创建DLC地图界面（第1个分页）
local OnCreateSystemMailDetailInfo = hApi.DoNothing --显示某个邮件的详情界面
local OnTakeRewardAllSystemMail = hApi.DoNothing --一键领取全部邮件奖励
local OnTakeRewardSystemMail = hApi.DoNothing --领取某个邮件奖励
local refresh_dlcmapinfo_UI_loop = hApi.DoNothing --刷新DLC地图面板界面的滚动
local refresh_chatframe_scroll_reward_loop = hApi.DoNothing --刷新DLC地图奖励界面的滚动
local on_receive_system_mail_list_back = hApi.DoNothing --收到系统邮件记录回调
local on_takereward_system_mail_success_back = hApi.DoNothing --领取邮件成功回调
local on_takereward_all_system_mail_success_back = hApi.DoNothing --一键领取全部邮件成功回调
local on_receive_endless_rank_name_back = hApi.DoNothing --收到无尽前10名玩家数据回调
local on_spine_screen_event = hApi.DoNothing --横竖屏切换
local refresh_systemmail_lelefttime_timer = hApi.DoNothing --刷新系统邮件剩余领取时间倒计时timer
local refresh_async_paint_system_mail_list_loop = hApi.DoNothing --异步绘制系统邮件记录条目的timer
local on_create_single_system_mail_UI = hApi.DoNothing --绘制单条系统邮件记录数据
local on_create_single_system_mail_UI_async = hApi.DoNothing --异步绘制单条系统邮件记录数据（异步）
local getUpDownOffset = hApi.DoNothing --获得第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离
local getLeftRightOffset = hApi.DoNothing --获得奖励第一个控件和最后一个控件距离最左面边界线和最右面边界线的距离
local __DynamicAddRes = hApi.DoNothing --动态加载资源
local __DynamicRemoveRes = hApi.DoNothing --动态删除资源
local OnClosePanel = hApi.DoNothing --关闭本界面
local RefreshTaskAchievementFinishPage = hApi.DoNothing --更新提示当前哪个分页可以有领取的了

--分页1：DLC地图包的参数
local DLCMAPINFO_WIDTH = 200 --DLC地图包宽度
local DLCMAPINFO_HEIGHT = 490 --DLC地图包高度
local DLCMAPINFO_OFFSET_X = 120 --DLC地图包统一偏移x
local DLCMAPINFO_OFFSET_Y = -100 --DLC地图包统一偏移y
local DLCMAPINFO_OFFSET_H = 78 --DLC地图包统一偏移h
local DLCMAPINFO_X_NUM = 1 --DLC地图面板x的数量
local DLCMAPINFO_Y_NUM = 5 --DLC地图面板y的数量
local DLCMAPINFO_REWARD_X_NUM = 7 --DLC地图奖励x的数量
local DLCMAPINFO_REWARD_Y_NUM = 1 --DLC地图奖励y的数量
local MAX_SPEED = 50 --最大速度

--可变参数
local current_DLCMap_max_num = 0 --最大的DLC地图包数量
local current_DLCMap_mail_list = {} --邮件列表信息表
local current_DLCMap_selectIdx = 0 --当前选中的邮件索引值

local current_async_paint_list = {} --当前待异步绘制的聊天消息列表
local ASYNC_PAINTNUM_ONCE = 1 --一次绘制几条

local _bCanCreate = true --防止重复创建
local current_funcCallback = nil --关闭后的回调事件

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

--分页2：奖励的参数
local current_DLCMap_reward_max_num = 0 --奖励总数量

--奖励控制参数
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

--当前选中的记录
local CurrentSelectRecord = {pageIdx = 0, contentIdx = 0, cardId = 0,} --当前选择的分页、数据项的信息记录



--系统邮件面板
hGlobal.UI.InitSystemMailInfoFrm = function(mode)
	local tInitEventName = {"LocalEvent_Phone_ShowSystemMailInfoFrm", "__ShowSystemMailFrm",}
	if (mode ~= "reload") then
		--return tInitEventName
		return
	end
	
	--不重复创建系统邮件面板
	if hGlobal.UI.PhoneSystemMailInfoFrm then --系统邮件面板
		hGlobal.UI.PhoneSystemMailInfoFrm:del()
		hGlobal.UI.PhoneSystemMailInfoFrm = nil
	end
	
	--[[
	--取消监听打开游戏币变化界面通知事件
	hGlobal.event:listen("LocalEvent_Phone_ShowSystemMailInfoFrm", "__ShowSystemMailFrm", nil)
	--取消监听关闭宝箱界面事件
	hGlobal.event:listen("clearPhoneChestFrm", "__CloseSystemMailFrm", nil)
	]]
	
	BOARD_WIDTH = 720 --DLC地图面板面板的宽度
	BOARD_HEIGHT = 720 --DLC地图面板面板的高度
	BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 0
	BOARD_OFFSETY = -0 --DLC地图面板面板y偏移中心点的值
	BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --DLC地图面板面板的x位置（最左侧）
	BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --DLC地图面板面板的y位置（最顶侧）
	
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
	
	hApi.clearTimer("__SYSTEM_MAIL_SCROLL_UPDATE__")
	hApi.clearTimer("__SYSTEM_MAIL_REWARD_SCROLL_UPDATE__")
	hApi.clearTimer("__SYSTEM_MAIL_LEFTTIME_UPDATE__")
	hApi.clearTimer("__SYSTEM_MAIL_ASYNC_TIMER__")
	
	--创建游戏币变化面板
	hGlobal.UI.PhoneSystemMailInfoFrm = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 2,
		show = 0, --一开始不显示
		border = 0, --1, --显示frame边框
		background = 0, --"panel/panel_part_00.png", --"UI:Tactic_Background",
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
	
	local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
	local _parent = _frm.handle._n
	
	--左侧裁剪区域
	local _BTC_PageClippingRect_systemmail = {0, -54, 240, 554, 0,} -- {x, y, w, h, show}
	local _BTC_pClipNode_systemmail = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect_systemmail, 99, _BTC_PageClippingRect_systemmail[5], "_BTC_pClipNode_systemmail")
	
	--右侧裁剪区域
	local _BTC_PageClippingRect_reward = {DLCMAPINFO_OFFSET_X + 30 + 150 + 72, -130, 320, DLCMAPINFO_HEIGHT - 14, 0} -- {x, y, w, h, show}
	local _BTC_pClipNode_reward = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect_reward, 98, _BTC_PageClippingRect_reward[5], "_BTC_pClipNode_reward")
	
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
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		model = "BTN:PANEL_CLOSE",
		x = _frm.data.w -4 + 1000,
		y = -8,
		scaleT = 0.95,
		code = function()
			--关闭本界面
			OnClosePanel()
			
			--触发事件：刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
			hGlobal.event:event("LocalEvent_RefreshMedalStateUI")
			
			hGlobal.event:event("LocalEvent_RecoverBarrage")
			
			--关闭后，重新发起查询
			--更新邮件奖励
			SendCmdFunc["get_prize_list"]()
			--发起查询系统邮件（新）
			SendCmdFunc["get_system_mail_list"]()
			
			--回调事件
			if (type(current_funcCallback) == "function") then
				current_funcCallback()
			end
		end,
	})
	
	--每个分页按钮
	--DLC地图面板
	local tPageIcons = {"UI:ach_king",}
	--local tTexts = {"邮件",} --language
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
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页中侧的UI
	_removeMiddleFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#middleRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, middleRemoveFrmList[i]) 
		end
		middleRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
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
		_removeMiddleFrmFunc()
		_removeRightFrmFunc()
		
		--清空切换分页之后取消的监听事件
		--移除事件监听：收到系统邮件记录回调
		hGlobal.event:listen("localEvent_OnReceiveSystemMailList", "__ReceiveSystemMail", nil)
		--移除事件监听：领取邮件成功回调
		hGlobal.event:listen("LocalEvent_OnSystemMailTakeRewardSuccess", "__TakeRewardSystemMail", nil)
		--移除事件监听：一键领取全部邮件成功回调
		hGlobal.event:listen("LocalEvent_OnSystemMailTakeAllRewardSuccess", "__TakeRewardAllSystemMail", nil)
		--移除事件监听：收到无尽前10名玩家数据回调
		hGlobal.event:listen("localEvent_endless_rank_name", "__ReceiveEndlessSystemMail", nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenSystemMail_", nil)
		
		--移除timer
		hApi.clearTimer("__SYSTEM_MAIL_SCROLL_UPDATE__")
		hApi.clearTimer("__SYSTEM_MAIL_REWARD_SCROLL_UPDATE__")
		hApi.clearTimer("__SYSTEM_MAIL_LEFTTIME_UPDATE__")
		hApi.clearTimer("__SYSTEM_MAIL_ASYNC_TIMER__")
		
		--隐藏所有的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_systemmail", 0)
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_reward", 0)
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：游戏币变化
			--创建游戏币变化分页
			OnCreateSystemMailInfoFrame(pageIndex)
		end
		
		--标记当前选择的分页和页内的第几个
		CurrentSelectRecord.pageIdx = pageIndex
		CurrentSelectRecord.contentIdx = 1 --默认选中第一个
	end
	
	--函数：关闭本界面
	OnClosePanel = function()
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		--不显示系统邮件面板
		hGlobal.UI.PhoneSystemMailInfoFrm:show(0)
		
		--清空分页的全部信息
		_removeLeftFrmFunc()
		_removeMiddleFrmFunc()
		_removeRightFrmFunc()
		
		--动态删除宝物背景大图
		__DynamicRemoveRes()
		
		--关闭界面后不需要监听的事件
		--取消监听：
		--...
		
		--清空切换分页之后取消的监听事件
		--移除事件监听：收到系统邮件记录回调
		hGlobal.event:listen("localEvent_OnReceiveSystemMailList", "__ReceiveSystemMail", nil)
		--移除事件监听：领取邮件成功回调
		hGlobal.event:listen("LocalEvent_OnSystemMailTakeRewardSuccess", "__TakeRewardSystemMail", nil)
		--移除事件监听：一键领取全部邮件成功回调
		hGlobal.event:listen("LocalEvent_OnSystemMailTakeAllRewardSuccess", "__TakeRewardAllSystemMail", nil)
		--移除事件监听：收到无尽前10名玩家数据回调
		hGlobal.event:listen("localEvent_endless_rank_name", "__ReceiveEndlessSystemMail", nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenSystemMail_", nil)
		
		--删除DLC界面下拉滚动timer
		hApi.clearTimer("__SYSTEM_MAIL_SCROLL_UPDATE__")
		hApi.clearTimer("__SYSTEM_MAIL_REWARD_SCROLL_UPDATE__")
		hApi.clearTimer("__SYSTEM_MAIL_LEFTTIME_UPDATE__")
		hApi.clearTimer("__SYSTEM_MAIL_ASYNC_TIMER__")
		
		--关闭金币、积分界面
		hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
		
		--释放png, plist的纹理缓存（这里不清理也可以）
		--hApi.ReleasePngTextureCache()
		
		--触发事件：关闭了主菜单按钮
		--hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
		
		_bCanCreate = true
	end
	
	--函数：创建系统邮件界面（第1个分页）
	OnCreateSystemMailInfoFrame = function(pageIdx)
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--允许本分页的的clipNode
		hApi.EnableClip2ByName(_frm, "_BTC_pClipNode_systemmail", "_BTC_pClipNode_reward", 1)
		--hApi.EnableClipByName(_frm, "_BTC_pClipNode_systemmail", 1)
		--hApi.EnableClipByName(_frm, "_BTC_pClipNode_reward", 1)
		
		--初始化参数
		current_DLCMap_max_num = 0 --最大的DLC地图面板id
		current_DLCMap_reward_max_num = 0 --奖励数量
		current_DLCMap_mail_list = {} --邮件列表信息表
		current_DLCMap_selectIdx = 0 --当前选中的邮件索引值
		current_async_paint_list = {} --清空异步缓存待绘制内容
		
		--动态加载任务背景大图
		__DynamicAddRes()
		
		--local i = 3
		
		--左侧裁剪区域
		--local _BTC_PageClippingRect = {0, -82, 1000, 408, 0}
		--local _BTC_pClipNode_systemmail = hApi.CreateClippingNode(_parentNode, _BTC_PageClippingRect, 99, _BTC_PageClippingRect[5])
		
		--[[
		--标题-系统邮件
		_frmNode.childUI["DLCMapInfoTitle"] = hUI.label:new({
			parent = _parentNode,
			x = BOARD_WIDTH / 2,
			y = -32,
			font = hVar.FONTC,
			size = 34,
			align = "MC",
			text = hVar.tab_string["__TEXT_MAINUI_BTN_MAIL"], --"邮件"
			border = 1,
			RGB = {255, 205, 55},
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTitle"
		]]
		
		--左侧底板
		--背景图
		_frmNode.childUI["DLCMapInfoListBG_Left"] = hUI.button:new({ --作为按钮只是为了挂载子控件
			parent = _parentNode,
			model = "misc/selectbg.png",
			x = DLCMAPINFO_OFFSET_X,
			y = DLCMAPINFO_OFFSET_Y - 330,
			w = 1,
			h = 1,
		})
		_frmNode.childUI["DLCMapInfoListBG_Left"].handle.s:setOpacity(0) --只挂载子控件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoListBG_Left"
		
		--[[
		--左侧背景图
		--九宫格
		local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_graywhite.png", 0, 0, DLCMAPINFO_WIDTH, DLCMAPINFO_HEIGHT, _frmNode.childUI["DLCMapInfoListBG_Left"])
		s9:setOpacity(64)
		s9:setColor(ccc3(168, 168, 168))
		]]
		
		--[[
		--右侧底板
		--背景图
		_frmNode.childUI["DLCMapInfoListBG_Right"] = hUI.button:new({ --作为按钮只是为了挂载子控件
			parent = _parentNode,
			--model = "misc/selectbg.png",
			model = -1,
			x = DLCMAPINFO_OFFSET_X + DLCMAPINFO_WIDTH / 2 + 236,
			y = DLCMAPINFO_OFFSET_Y - 330,
			w = 1,
			h = 1,
		})
		leftRemoveFrmList[#leftRemoveFrmList+1] = "DLCMapInfoListBG_Right"
		]]
		
		--[[
		--右侧背景图
		--九宫格
		local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_graywhite.png", 0, 0, DLCMAPINFO_WIDTH + 10, DLCMAPINFO_HEIGHT, _frmNode.childUI["DLCMapInfoListBG_Right"])
		s9:setOpacity(64)
		s9:setColor(ccc3(168, 168, 168))
		]]
		
		--左侧DLC地图包列表提示上翻页的图片
		_frmNode.childUI["DLCMapInfoPageUp"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/skillup/arrow_down.png",
			x = DLCMAPINFO_OFFSET_X,
			y = DLCMAPINFO_OFFSET_Y - 12 + 136,
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
		
		--左侧DLC地图包列表提示下翻页的图片
		_frmNode.childUI["DLCMapInfoPageDown"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/skillup/arrow_down.png",
			x = DLCMAPINFO_OFFSET_X, --非对称的翻页图
			y = DLCMAPINFO_OFFSET_Y - 658 + 30,
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
		
		--左侧向上翻页的按钮的接受上点击事件的响应区域
		_frmNode.childUI["DLCMapInfoPageUp_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = DLCMAPINFO_OFFSET_X,
			y = DLCMAPINFO_OFFSET_Y - 9 + 12 + 136,
			w = 300,
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
		
		--左侧向下翻页的按钮的接受下点击事件的响应区域
		_frmNode.childUI["DLCMapInfoPageDown_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = DLCMAPINFO_OFFSET_X,
			y = DLCMAPINFO_OFFSET_Y - 658 - 12 + 30,
			w = 300,
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
		
		--左侧用于检测滑动事件的控件
		_frmNode.childUI["DLCMapInfoDragPanel"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = DLCMAPINFO_OFFSET_X + 1,
			y = DLCMAPINFO_OFFSET_Y - 250 + 20,
			w = DLCMAPINFO_WIDTH + 20,
			h = 600 - 40,
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
				
				--不超过一页，不滑动
				if (current_DLCMap_max_num <= (DLCMAPINFO_X_NUM * DLCMAPINFO_Y_NUM)) then
					click_scroll_dlcmapinfo = false --不需要滑动DLC地图面板
				end
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
				--print("codeOnDrag", touchX, touchY, sus)
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
						_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下分翻页提示
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
					OnCreateSystemMailDetailInfo(selectTipIdx)
				end
				
				--标记不用滑动
				click_scroll_dlcmapinfo = false
			end,
		})
		_frmNode.childUI["DLCMapInfoDragPanel"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoDragPanel"
		
		--一键领取按钮
		_frmNode.childUI["DLCMapInfoRewardAllBtn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/button_back.png", --"UI:ButtonBack",
			x = DLCMAPINFO_OFFSET_X,
			y = DLCMAPINFO_OFFSET_Y - 540,
			label = {text = hVar.tab_string["__TEXT_TAKEALL_MAIL"], size = 26, font = hVar.FONTC, x = 0, y = -0, border = 1, align = "MC",}, --"全部领取"
			dragbox = _frm.childUI["dragBox"],
			w = 140,
			h = 60,
			scaleT = 0.95,
			code = function()
				--一键领取全部邮件奖励
				OnTakeRewardAllSystemMail()
			end,
		})
		_frmNode.childUI["DLCMapInfoRewardAllBtn"]:setstate(-1) --默认隐藏
		leftRemoveFrmList[#leftRemoveFrmList+1] = "DLCMapInfoRewardAllBtn"
		
		--按钮-签到
		_frmNode.childUI["Btn_SignIn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/task/tab_frame_selected.png",
			x = 140 + 437 - 88 * 2,
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
			x = 140 + 437 - 88 * 1,
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
				
				--触发事件，显示任务界面
				hGlobal.event:event("LocalEvent_Phone_ShowMyTask", nil, true)
			end,
		})
		_frmNode.childUI["Btn_Task"].handle.s:setOpacity(0) --只挂载子控件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "Btn_Task"
		--图标
		_frmNode.childUI["Btn_Task"].childUI["icon"] = hUI.button:new({
			parent = _frmNode.childUI["Btn_Task"].handle._n,
			model = "misc/task/tab_mission_01.png",
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
			x = 140 + 437 + 88 * 0,
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
			scaleT = 1.0,
			dragbox = _frm.childUI["dragBox"],
			code = function()
				--
			end,
		})
		_frmNode.childUI["Btn_Mail"].handle.s:setOpacity(255) --只挂载子控件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "Btn_Mail"
		--图标
		_frmNode.childUI["Btn_Mail"].childUI["icon"] = hUI.button:new({
			parent = _frmNode.childUI["Btn_Mail"].handle._n,
			model = "misc/task/tab_mail_02.png",
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
		
		--添加事件监听：收到系统邮件记录回调
		hGlobal.event:listen("localEvent_OnReceiveSystemMailList", "__ReceiveSystemMail", on_receive_system_mail_list_back)
		--添加事件监听：领取邮件成功回调
		hGlobal.event:listen("LocalEvent_OnSystemMailTakeRewardSuccess", "__TakeRewardSystemMail", on_takereward_system_mail_success_back)
		--添加事件监听：一键领取全部邮件成功回调
		hGlobal.event:listen("LocalEvent_OnSystemMailTakeAllRewardSuccess", "__TakeRewardAllSystemMail", on_takereward_all_system_mail_success_back)
		--添加事件监听：收到无尽前10名玩家数据回调
		hGlobal.event:listen("localEvent_endless_rank_name", "__ReceiveEndlessSystemMail", on_receive_endless_rank_name_back)
		--添加事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenSystemMail_", on_spine_screen_event)
		
		--创建timer，刷新DLC地图面板滚动
		hApi.addTimerForever("__SYSTEM_MAIL_SCROLL_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_dlcmapinfo_UI_loop)
		--创建timer，刷新DLC地图面板滚动
		hApi.addTimerForever("__SYSTEM_MAIL_REWARD_SCROLL_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_chatframe_scroll_reward_loop)
		--创建timer，刷新邮件剩余领取时间timer
		hApi.addTimerForever("__SYSTEM_MAIL_LEFTTIME_UPDATE__", hVar.TIMER_MODE.GAMETIME, 1000, refresh_systemmail_lelefttime_timer)
		--异步绘制系统邮件记录条目的timer
		hApi.addTimerForever("__SYSTEM_MAIL_ASYNC_TIMER__", hVar.TIMER_MODE.GAMETIME, 1, refresh_async_paint_system_mail_list_loop)
		
		--挡操作
		hUI.NetDisable(30000)
		
		--发起查询月卡和月卡每日领奖
		SendCmdFunc["query_month_card"]()
		--发起查询系统邮件（新）
		--print("发起查询系统邮件（新）")
		--更新邮件奖励
		SendCmdFunc["get_prize_list"]()
		SendCmdFunc["get_system_mail_list"]()
	end
	
	--函数：绘制单条系统邮件数据
	on_create_single_system_mail_UI = function(index, tMailI)
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local prizeId = tMailI.prizeId --邮件id
		local prizeType = tMailI.prizeType --邮件类型
		local prizeContent = tMailI.prizeContent --邮件正文
		local prizeSeconds = tMailI.prizeSeconds --邮件剩余领取时间（单位：秒）
		local rewardFlag = tMailI.rewardFlag --是否已领取的标记flag
		--print(prizeId, prizeType, prizeContent, prizeSeconds)
		
		--解析邮件标题
		local itemID,itemNum,itemName,itemHole,coin,score,itemBack,itemModel,GiftTip,GiftTip_Ex,ex_num,_,_,giftType = hApi.UnpackPrizeData(prizeType,prizeId,prizeContent)
		--标题过滤掉回车符
		GiftTip = string.gsub(GiftTip, "\n", "") --过滤掉回车符
		GiftTip = GiftTip:gsub("^%s*(.-)%s*$", "%1") --trim
		
		--local strMailTitle = hVar.tab_string["system_mail"] .. hVar.tab_string["__Reward__"] --"系统邮件奖励"
		--local tPrize = hApi.Split(prizeContent,";")
		
		--if (prizeType == 20008) or (prizeType == 20031) then --td邮件、带有标题正文的邮件
		--	strMailTitle = tPrize[1]
		--end
		
		--父控件
		_frmNode.childUI["DLCMapInfoNode" .. index] = hUI.button:new({
			parent = _BTC_pClipNode_systemmail,
			model = "misc/mask.png",
			--model = -1,
			x = DLCMAPINFO_OFFSET_X,
			y = DLCMAPINFO_OFFSET_Y - (index - 1) * (DLCMAPINFO_OFFSET_H + 4),
			--z = 1,
			w = DLCMAPINFO_WIDTH + 2,
			h = DLCMAPINFO_OFFSET_H + 2,
		})
		_frmNode.childUI["DLCMapInfoNode" .. index].handle.s:setOpacity(0) --默认不显示（只用于响应事件，不显示）
		middleRemoveFrmList[#middleRemoveFrmList + 1] = "DLCMapInfoNode" .. index
		
		--邮件中文图片标题
		local titleImgType = 0 --1:系统补偿/2:活动奖励/3游戏通知
		if (prizeType == 4) then --网页发奖道具
			titleImgType = 2
		elseif (prizeType == 9) then --每日奖励
			titleImgType = 2
		elseif (prizeType == 18) then --评价奖励
			titleImgType = 2
		elseif (prizeType == 100) then --新人礼包
			titleImgType = 2
		elseif (prizeType == 1030) or (prizeType == 1031) or (prizeType == 1032) or (prizeType == 1033) then --首充奖励
			titleImgType = 2
		elseif (prizeType == 1034) then --首充奖励
			titleImgType = 2
		elseif (prizeType == 1035) or (prizeType == 1036) then --首充奖励
			titleImgType = 2
		elseif (prizeType == 1039) or (prizeType == 1060) then --网页发奖积分
			titleImgType = 2
		elseif (prizeType >= 1900) and (prizeType <= 1999) then --分享奖励
			titleImgType = 2
		elseif (prizeType == 2000) then --系统邮件
			titleImgType = 3
		elseif (prizeType == 20001) then --无尽排名奖励（旧）
			titleImgType = 2
		elseif (prizeType >= 20002) and (prizeType <= 20007) then --推荐奖励
			titleImgType = 2
		elseif (prizeType == 20008) or (prizeType == 20009) then --td发奖邮件
			titleImgType = 2
		elseif (prizeType >= 20010) and (prizeType <= 20020) then --vip一次性奖励
			titleImgType = 2
		elseif (prizeType == 20028) then --服务器抽卡类型
			titleImgType = 2
		elseif (prizeType == 20029) then --无尽排名奖励
			titleImgType = 7
		elseif (prizeType == 20030) then --魔龙宝库勤劳奖
			titleImgType = 2
		elseif (prizeType == 20031) then --带有标题正文的邮件
			titleImgType = 2
		elseif (prizeType == 20032) then --服务器直接开锦囊
			titleImgType = 2
		elseif (prizeType == 20033) then --只有标题和正文，没有奖励
			titleImgType = 3
		elseif (prizeType == 20034) then --夺塔奇兵带有段位、标题和正文的奖励
			titleImgType = 2
		elseif (prizeType == 20035) then --聊天龙王奖
			titleImgType = 2
		elseif (prizeType == 20036) then --军团秘境试炼勤劳奖
			titleImgType = 2
		elseif (prizeType == 20037) then --军团本周声望排名奖励
			titleImgType = 2
		elseif (prizeType == 20038) then --军团本周声望第一名奖励
			titleImgType = 2
		elseif (prizeType == 20039) then --更新维护带有标题和正文的奖励
			titleImgType = 1
		elseif (prizeType == 20040) then --体力带有标题和正文的奖励
			titleImgType = 4
		elseif (prizeType == 20041) then --感谢信带有标题和正文的奖励
			titleImgType = 5
		elseif (prizeType == 20042) then --分享信带有标题和正文的奖励
			titleImgType = 6
		end
		
		if (titleImgType == 1) then --系统补偿
			--box框
			--九宫格
			local s91 = hApi.CCScale9SpriteCreate("data/image/misc/task/mail_type07.png", 0, 0, 180, 71, _frmNode.childUI["DLCMapInfoNode" .. index])
			_frmNode.childUI["DLCMapInfoNode" .. index].data.s91 = s91
			if (current_DLCMap_selectIdx == index) then
				s91:setVisible(false)
			else
				s91:setVisible(true)
			end
			--s9:setOpacity(168)
			--s9:setColor(ccc3(244, 244, 244))
			
			--邮件图标
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 44,
				y = 1,
				model = "misc/task/tab_events_03.png",
				w = 51,
				h = 50,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"].handle._n:setVisible(false)
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"].handle._n:setVisible(true)
			end
			
			--九宫格（选中高亮）
			local s92 = hApi.CCScale9SpriteCreate("data/image/misc/task/mail_type08.png", 0, 0, 194, 77, _frmNode.childUI["DLCMapInfoNode" .. index])
			_frmNode.childUI["DLCMapInfoNode" .. index].data.s92_sysmail = s92
			--s92:setOpacity(64)
			--s92:setColor(ccc3(244, 244, 244))
			if (current_DLCMap_selectIdx == index) then
				s92:setVisible(true)
			else
				s92:setVisible(false)
			end
			
			--邮件图标（选中高亮）
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 38,
				y = 1,
				model = "misc/task/tab_events_03.png",
				w = 51,
				h = 50,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"].handle._n:setVisible(true)
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"].handle._n:setVisible(false)
			end
			
			--邮件标题
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 78,
				y = -1,
				width = 500,
				font = hVar.FONTC,
				size = 26,
				align = "LC",
				text = hVar.tab_string["__TEXT_MAILTYYE_01"], --"系统补偿"
				border = 1,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"].handle.s:setColor(ccc3(0, 255, 0)) --绿色
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"].handle.s:setColor(ccc3(255, 255, 255)) --白色
			end
		elseif (titleImgType == 2) then --活动奖励
			--box框
			--九宫格
			local s91 = hApi.CCScale9SpriteCreate("data/image/misc/task/mail_type07.png", 0, 0, 180, 71, _frmNode.childUI["DLCMapInfoNode" .. index])
			_frmNode.childUI["DLCMapInfoNode" .. index].data.s91 = s91
			if (current_DLCMap_selectIdx == index) then
				s91:setVisible(false)
			else
				s91:setVisible(true)
			end
			--s9:setOpacity(168)
			--s9:setColor(ccc3(244, 244, 244))
			
			local strIcon = "misc/task/tab_events_02.png"
			local iconW = 51
			local iconH = 50
			local strTitle = hVar.tab_string["__TEXT_MAILTYYE_02"] --"活动奖励"
			
			--月卡显示特别的图标
			--print("月卡", string.find(tostring(tCmd[1]), "月卡"))
			--if (string.find(tostring(tCmd[1]), "月卡") ~= nil) then
			if (string.find(tostring(GiftTip), hVar.tab_string["__TEXT_MONTHCARD"]) ~= nil) then
				strIcon = "UI:MONTHCARD_ICON"
				iconW = 56
				iconH = 56
				strTitle = hVar.tab_string["__TEXT_MAILTYYE_06"] --"月卡奖励"
			end
			
			--邮件图标
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 44,
				y = 1,
				model = strIcon,
				w = iconW,
				h = iconH,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"].handle._n:setVisible(false)
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"].handle._n:setVisible(true)
			end
			
			--九宫格（选中高亮）
			local s92 = hApi.CCScale9SpriteCreate("data/image/misc/task/mail_type08.png", 0, 0, 194, 77, _frmNode.childUI["DLCMapInfoNode" .. index])
			_frmNode.childUI["DLCMapInfoNode" .. index].data.s92_sysmail = s92
			--s92:setOpacity(64)
			--s92:setColor(ccc3(244, 244, 244))
			if (current_DLCMap_selectIdx == index) then
				s92:setVisible(true)
			else
				s92:setVisible(false)
			end
			
			--邮件图标（选中高亮）
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 38,
				y = 1,
				model = strIcon,
				w = iconW,
				h = iconH,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"].handle._n:setVisible(true)
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"].handle._n:setVisible(false)
			end
			
			--邮件标题
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 78,
				y = -1,
				width = 500,
				font = hVar.FONTC,
				size = 26,
				align = "LC",
				text = strTitle, --"活动奖励"
				border = 1,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"].handle.s:setColor(ccc3(0, 255, 0)) --绿色
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"].handle.s:setColor(ccc3(255, 255, 255)) --白色
			end
		elseif (titleImgType == 3) then --游戏通知
			--box框
			--九宫格
			local s91 = hApi.CCScale9SpriteCreate("data/image/misc/task/mail_type07.png", 0, 0, 180, 71, _frmNode.childUI["DLCMapInfoNode" .. index])
			_frmNode.childUI["DLCMapInfoNode" .. index].data.s91 = s91
			if (current_DLCMap_selectIdx == index) then
				s91:setVisible(false)
			else
				s91:setVisible(true)
			end
			--s9:setOpacity(168)
			--s9:setColor(ccc3(244, 244, 244))
			
			--邮件图标
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 44,
				y = 1,
				model = "misc/task/tab_events_02.png",
				w = 51,
				h = 50,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"].handle._n:setVisible(false)
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"].handle._n:setVisible(true)
			end
			
			--九宫格（选中高亮）
			local s92 = hApi.CCScale9SpriteCreate("data/image/misc/task/mail_type08.png", 0, 0, 194, 77, _frmNode.childUI["DLCMapInfoNode" .. index])
			_frmNode.childUI["DLCMapInfoNode" .. index].data.s92_sysmail = s92
			--s92:setOpacity(64)
			--s92:setColor(ccc3(244, 244, 244))
			if (current_DLCMap_selectIdx == index) then
				s92:setVisible(true)
			else
				s92:setVisible(false)
			end
			
			--邮件图标（选中高亮）
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 38,
				y = 1,
				model = "misc/task/tab_events_02.png",
				w = 51,
				h = 50,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"].handle._n:setVisible(true)
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"].handle._n:setVisible(false)
			end
			
			--邮件标题
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 78,
				y = -1,
				width = 500,
				font = hVar.FONTC,
				size = 26,
				align = "LC",
				text = hVar.tab_string["__TEXT_MAILTYYE_03"], --"游戏通知"
				border = 1,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"].handle.s:setColor(ccc3(0, 255, 0)) --绿色
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"].handle.s:setColor(ccc3(255, 255, 255)) --白色
			end
		elseif (titleImgType == 4) then --每日体力补给
			--box框
			--九宫格
			local s91 = hApi.CCScale9SpriteCreate("data/image/misc/task/mail_type07.png", 0, 0, 180, 71, _frmNode.childUI["DLCMapInfoNode" .. index])
			_frmNode.childUI["DLCMapInfoNode" .. index].data.s91 = s91
			if (current_DLCMap_selectIdx == index) then
				s91:setVisible(false)
			else
				s91:setVisible(true)
			end
			--s9:setOpacity(168)
			--s9:setColor(ccc3(244, 244, 244))
			
			--邮件图标
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 44,
				y = 1,
				model = "misc/task/tili.png",
				w = 68,
				h = 68,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"].handle._n:setVisible(false)
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"].handle._n:setVisible(true)
			end
			
			--九宫格（选中高亮）
			local s92 = hApi.CCScale9SpriteCreate("data/image/misc/task/mail_type08.png", 0, 0, 194, 77, _frmNode.childUI["DLCMapInfoNode" .. index])
			_frmNode.childUI["DLCMapInfoNode" .. index].data.s92_sysmail = s92
			--s92:setOpacity(64)
			--s92:setColor(ccc3(244, 244, 244))
			if (current_DLCMap_selectIdx == index) then
				s92:setVisible(true)
			else
				s92:setVisible(false)
			end
			
			--邮件图标（选中高亮）
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 38,
				y = 1,
				model = "misc/task/tili.png",
				w = 68,
				h = 68,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"].handle._n:setVisible(true)
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"].handle._n:setVisible(false)
			end
			
			--邮件标题
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 78,
				y = -1,
				width = 500,
				font = hVar.FONTC,
				size = 26,
				align = "LC",
				text = hVar.tab_string["__TEXT_MAILTYYE_04"], --"体力补给"
				border = 1,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"].handle.s:setColor(ccc3(0, 255, 0)) --绿色
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"].handle.s:setColor(ccc3(255, 255, 255)) --白色
			end
		elseif (titleImgType == 5) then --感谢信
			--box框
			--九宫格
			local s91 = hApi.CCScale9SpriteCreate("data/image/misc/task/mail_type07.png", 0, 0, 180, 71, _frmNode.childUI["DLCMapInfoNode" .. index])
			_frmNode.childUI["DLCMapInfoNode" .. index].data.s91 = s91
			if (current_DLCMap_selectIdx == index) then
				s91:setVisible(false)
			else
				s91:setVisible(true)
			end
			--s9:setOpacity(168)
			--s9:setColor(ccc3(244, 244, 244))
			
			--邮件图标
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 44,
				y = 1,
				model = "misc/task/tab_events_04.png",
				w = 56,
				h = 56,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"].handle._n:setVisible(false)
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"].handle._n:setVisible(true)
			end
			
			--九宫格（选中高亮）
			local s92 = hApi.CCScale9SpriteCreate("data/image/misc/task/mail_type08.png", 0, 0, 194, 77, _frmNode.childUI["DLCMapInfoNode" .. index])
			_frmNode.childUI["DLCMapInfoNode" .. index].data.s92_sysmail = s92
			--s92:setOpacity(64)
			--s92:setColor(ccc3(244, 244, 244))
			if (current_DLCMap_selectIdx == index) then
				s92:setVisible(true)
			else
				s92:setVisible(false)
			end
			
			--邮件图标（选中高亮）
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 38,
				y = 1,
				model = "misc/task/tab_events_04.png",
				w = 56,
				h = 56,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"].handle._n:setVisible(true)
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"].handle._n:setVisible(false)
			end
			
			--邮件标题
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 78,
				y = -1,
				width = 500,
				font = hVar.FONTC,
				size = 26,
				align = "LC",
				text = hVar.tab_string["__TEXT_MAILTYYE_05"], --"感谢信"
				border = 1,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"].handle.s:setColor(ccc3(0, 255, 0)) --绿色
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"].handle.s:setColor(ccc3(255, 255, 255)) --白色
			end
		elseif (titleImgType == 6) then --分享信
			--box框
			--九宫格
			local s91 = hApi.CCScale9SpriteCreate("data/image/misc/task/mail_type07.png", 0, 0, 180, 71, _frmNode.childUI["DLCMapInfoNode" .. index])
			_frmNode.childUI["DLCMapInfoNode" .. index].data.s91 = s91
			if (current_DLCMap_selectIdx == index) then
				s91:setVisible(false)
			else
				s91:setVisible(true)
			end
			--s9:setOpacity(168)
			--s9:setColor(ccc3(244, 244, 244))
			
			--邮件图标
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 44,
				y = 1,
				model = "UI:WEIXIN_SHARE",
				w = 48,
				h = 48,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"].handle._n:setVisible(false)
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"].handle._n:setVisible(true)
			end
			
			--九宫格（选中高亮）
			local s92 = hApi.CCScale9SpriteCreate("data/image/misc/task/mail_type08.png", 0, 0, 194, 77, _frmNode.childUI["DLCMapInfoNode" .. index])
			_frmNode.childUI["DLCMapInfoNode" .. index].data.s92_sysmail = s92
			--s92:setOpacity(64)
			--s92:setColor(ccc3(244, 244, 244))
			if (current_DLCMap_selectIdx == index) then
				s92:setVisible(true)
			else
				s92:setVisible(false)
			end
			
			--邮件图标（选中高亮）
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 38,
				y = 1,
				model = "UI:WEIXIN_SHARE",
				w = 48,
				h = 48,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"].handle._n:setVisible(true)
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"].handle._n:setVisible(false)
			end
			
			--邮件标题
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 78,
				y = -1,
				width = 500,
				font = hVar.FONTC,
				size = 26,
				align = "LC",
				text = hVar.tab_string["__TEXT_MAILTYYE_07"], --"分享奖励"
				border = 1,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"].handle.s:setColor(ccc3(0, 255, 0)) --绿色
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"].handle.s:setColor(ccc3(255, 255, 255)) --白色
			end
		elseif (titleImgType == 7) then --无尽排名奖励
			--box框
			--九宫格
			local s91 = hApi.CCScale9SpriteCreate("data/image/misc/task/mail_type07.png", 0, 0, 180, 71, _frmNode.childUI["DLCMapInfoNode" .. index])
			_frmNode.childUI["DLCMapInfoNode" .. index].data.s91 = s91
			if (current_DLCMap_selectIdx == index) then
				s91:setVisible(false)
			else
				s91:setVisible(true)
			end
			--s9:setOpacity(168)
			--s9:setColor(ccc3(244, 244, 244))
			
			--邮件图标
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 44,
				y = 1,
				model = "misc/task/tab_mission_02.png",
				w = 56,
				h = 48,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"].handle._n:setVisible(false)
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"].handle._n:setVisible(true)
			end
			
			--九宫格（选中高亮）
			local s92 = hApi.CCScale9SpriteCreate("data/image/misc/task/mail_type08.png", 0, 0, 194, 77, _frmNode.childUI["DLCMapInfoNode" .. index])
			_frmNode.childUI["DLCMapInfoNode" .. index].data.s92_sysmail = s92
			--s92:setOpacity(64)
			--s92:setColor(ccc3(244, 244, 244))
			if (current_DLCMap_selectIdx == index) then
				s92:setVisible(true)
			else
				s92:setVisible(false)
			end
			
			--邮件图标（选中高亮）
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 38,
				y = 1,
				model = "misc/task/tab_mission_02.png",
				w = 56,
				h = 48,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"].handle._n:setVisible(true)
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"].handle._n:setVisible(false)
			end
			
			--邮件标题
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 78,
				y = -1,
				width = 500,
				font = hVar.FONTC,
				size = 26,
				align = "LC",
				text = hVar.tab_string["__TEXT_MAILTYYE_08"], --"排名奖励"
				border = 1,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"].handle.s:setColor(ccc3(0, 255, 0)) --绿色
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"].handle.s:setColor(ccc3(255, 255, 255)) --白色
			end
		else
			--box框
			--九宫格
			local s91 = hApi.CCScale9SpriteCreate("data/image/misc/task/mail_type07.png", 0, 0, 180, 71, _frmNode.childUI["DLCMapInfoNode" .. index])
			_frmNode.childUI["DLCMapInfoNode" .. index].data.s91 = s91
			if (current_DLCMap_selectIdx == index) then
				s91:setVisible(false)
			else
				s91:setVisible(true)
			end
			--s9:setOpacity(168)
			--s9:setColor(ccc3(244, 244, 244))
			
			--邮件图标
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 44,
				y = 1,
				model = "misc/task/tab_events_02.png",
				w = 51,
				h = 50,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"].handle._n:setVisible(false)
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"].handle._n:setVisible(true)
			end
			
			--九宫格（选中高亮）
			local s92 = hApi.CCScale9SpriteCreate("data/image/misc/task/mail_type08.png", 0, 0, 194, 77, _frmNode.childUI["DLCMapInfoNode" .. index])
			_frmNode.childUI["DLCMapInfoNode" .. index].data.s92_sysmail = s92
			--s92:setOpacity(64)
			--s92:setColor(ccc3(244, 244, 244))
			if (current_DLCMap_selectIdx == index) then
				s92:setVisible(true)
			else
				s92:setVisible(false)
			end
			
			--邮件图标（选中高亮）
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 38,
				y = 1,
				model = "misc/task/tab_events_02.png",
				w = 51,
				h = 50,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"].handle._n:setVisible(true)
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon_selected"].handle._n:setVisible(false)
			end
			
			--邮件标题
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 78,
				y = -1,
				width = 500,
				font = hVar.FONTC,
				size = 26,
				align = "LC",
				text = hVar.tab_string["__TEXT_MAILTYYE_03"], --"游戏通知"
				border = 1,
			})
			if (current_DLCMap_selectIdx == index) then
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"].handle.s:setColor(ccc3(0, 255, 0)) --绿色
			else
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"].handle.s:setColor(ccc3(255, 255, 255)) --白色
			end
		end
		
		--[[
		--邮件图标底图
		_frmNode.childUI["DLCMapInfoNode" .. index].childUI["iconBG"] = hUI.image:new({
			parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			x = -DLCMAPINFO_WIDTH / 2 + 64,
			y = 1,
			model = "misc/chest/astro_btnbg.png",
			w = 72,
			h = 72,
		})
		--_frmNode.childUI["DLCMapInfoNode" .. index].childUI["iconBG"].handle.s:setOpacity(128)
		]]
		
		--[[
		--邮件图标边框
		if (itemBack ~= nil) and (itemBack ~= 0) and (itemBack ~= "") then
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["iconBorder"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				x = -DLCMAPINFO_WIDTH / 2 + 64,
				y = 1,
				model = itemBack,
				w = 70,
				h = 70,
			})
		end
		]]
		
		--[[
		--邮件图标
		_frmNode.childUI["DLCMapInfoNode" .. index].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			x = -DLCMAPINFO_WIDTH / 2 + 64,
			y = 1,
			model = itemModel,
			w = 64,
			h = 64,
		})
		]]
		
		--邮件标题底纹
		local secondsOffsetY = 0
		--如果邮件有领取有效时间，标题往上挪
		if (prizeSeconds >= 0) then
			secondsOffsetY = 13
		end
		--[[
		_frmNode.childUI["DLCMapInfoNode" .. index].childUI["titleBG"] = hUI.button:new({ --作为按钮只是为了挂载子控件
			parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			x = -DLCMAPINFO_WIDTH / 2 + 284,
			y = 1 + secondsOffsetY,
			model = -1,
			w = 1,
			h = 1,
		})
		local s9 = hApi.CCScale9SpriteCreate("data/image/misc/task/event_frame.png", 0, 0, 180, 71, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["titleBG"])
		--s9:setOpacity(168)
		s9:setColor(ccc3(212, 212, 212))
		
		--邮件标题
		local titleSize = 24
		local titleLength = #GiftTip --文字长度
		if (titleLength > 51) then --17个汉字
			titleSize = 20
		elseif (titleLength > 45) then --15个汉字
			titleSize = 22
		end
		_frmNode.childUI["DLCMapInfoNode" .. index].childUI["title"] = hUI.label:new({
			parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			x = -DLCMAPINFO_WIDTH / 2 + 116,
			y = -1 + secondsOffsetY,
			width = 500,
			font = hVar.FONTC,
			size = titleSize,
			align = "LC",
			text = hApi.StringDecodeEmoji(GiftTip), --还原表情
			border = 1,
		})
		]]
		
		--剩余领取时间
		if (prizeSeconds >= 0) then
			--未领取奖励
			if (rewardFlag ~= 1) then
				--剩余领取时间
				_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttime"] = hUI.label:new({
					parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
					x = -DLCMAPINFO_WIDTH / 2 + 12,
					y = -10 - secondsOffsetY,
					width = 500,
					font = hVar.FONTC,
					size = 16,
					align = "LC",
					text = "",
					border = 1,
					RGB = {48, 255, 39,},
				})
				
				--计算剩余领取时间
				local day = math.floor(prizeSeconds / 3600 / 24) --时
				local hour = math.floor((prizeSeconds - day * 24 * 3600) / 3600) --时
				local minute = math.floor((prizeSeconds - day * 24 * 3600 - hour * 3600)/ 60) --分
				local second = prizeSeconds - hour * 3600 - minute * 60 --秒
				
				--拼接字符串
				local szDay = tostring(day) --天(字符串)
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
				
				--[[
				--geyachao: 左边不显示倒计时了
				--更新剩余领取时间
				if (prizeSeconds == 0) then
					_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttime"]:setText(hVar.tab_string["SystemMail_Expired"]) --"邮件即将过期，请尽快领取！"
				else
					if (day > 0) then
						_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttime"]:setText(hVar.tab_string["__TEXT_RewardLeftTime"] .. ": " .. szDay .. hVar.tab_string["__TEXT_Dat"] .. szHour .. hVar.tab_string["__TEXT_Hour_Short"] .. szMinute .. hVar.tab_string["__Minute"]) --"剩余领取时间: XX天XX时XX分"
					else
						_frmNode.childUI["DLCMapInfoNode" .. index].childUI["lefttime"]:setText(hVar.tab_string["__TEXT_RewardLeftTime"] .. ": " .. szHour .. hVar.tab_string["__TEXT_Hour_Short"] .. szMinute .. hVar.tab_string["__Minute"] .. szSecond .. hVar.tab_string["__Second"]) --"剩余领取时间: XX时XX分XX秒"
					end
				end
				]]
			end
		end
		
		--邮件已领取
		local strFinishTagIcon = "UI:FinishTag"
		if (prizeType == 20033) then --只有标题和正文，没有奖励
			strFinishTagIcon = "UI:FinishTag2"
		end
		_frmNode.childUI["DLCMapInfoNode" .. index].childUI["finishTag"] = hUI.image:new({
			parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			x = -DLCMAPINFO_WIDTH / 2 + 44,
			y = -1,
			model = strFinishTagIcon,
			scale = 1.0,
		})
		_frmNode.childUI["DLCMapInfoNode" .. index].childUI["finishTag"].handle._n:setRotation(15)
		if (rewardFlag == 1) then --已领取
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["finishTag"].handle._n:setVisible(true)
		else
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["finishTag"].handle._n:setVisible(false)
		end
		
		--[[
		--选中框
		_frmNode.childUI["DLCMapInfoNode" .. index].childUI["selectbox"] = hUI.button:new({ --作为按钮只是为了挂载子控件
			parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			x = 8,
			y = 0,
			model = -1,
			w = DLCMAPINFO_WIDTH - 20,
			h = 94,
		})
		if (current_DLCMap_selectIdx == index) then
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["selectbox"].handle._n:setVisible(true)
		else
			_frmNode.childUI["DLCMapInfoNode" .. index].childUI["selectbox"].handle._n:setVisible(false)
		end
		local s9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TaskSelectBG.png", 0, 0, DLCMAPINFO_WIDTH - 20, 94, _frmNode.childUI["DLCMapInfoNode" .. index].childUI["selectbox"])
		--s9:setOpacity(168)
		--s9:setColor(ccc3(212, 212, 212))
		]]
		
		---------------------------------------------------------------------
		--可能存在滑动，校对前一个控件的相对位置
		if _frmNode.childUI["DLCMapInfoNode" .. (index - 1)] then --前一个
			--实际相对距离
			local lastX = _frmNode.childUI["DLCMapInfoNode" .. (index - 1)].data.x
			local lastY = _frmNode.childUI["DLCMapInfoNode" .. (index - 1)].data.y
			local lastChatHeight = DLCMAPINFO_OFFSET_H
			
			--理论相对距离
			local thisX = lastX
			local thisY = lastY - lastChatHeight
			local ctrli = _frmNode.childUI["DLCMapInfoNode" .. index]
			ctrli.handle._n:setPosition(thisX, thisY)
			ctrli.data.x = thisX
			ctrli.data.y = thisY
		end
	end
	
	--函数：异步绘制单条系统邮件数据（异步）
	on_create_single_system_mail_UI_async = function(index, tMailI)
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local prizeId = tMailI.prizeId --邮件id
		local prizeType = tMailI.prizeType --邮件类型
		local prizeContent = tMailI.prizeContent --邮件正文
		local rewardFlag = tMailI.rewardFlag --是否已领取的标记flag
		--print(prizeId, prizeType, prizeContent)
		
		--父控件
		_frmNode.childUI["DLCMapInfoNode" .. index] = hUI.button:new({
			parent = _BTC_pClipNode_systemmail,
			--model = "misc/mask.png",
			model = -1,
			x = DLCMAPINFO_OFFSET_X,
			y = DLCMAPINFO_OFFSET_Y - (index - 1) * (DLCMAPINFO_OFFSET_H + 4),
			--z = 1,
			w = DLCMAPINFO_WIDTH + 2,
			h = DLCMAPINFO_OFFSET_H + 2,
		})
		--_frmNode.childUI["DLCMapInfoNode" .. index].handle.s:setOpacity(111) --默认不显示（只用于响应事件，不显示）
		middleRemoveFrmList[#middleRemoveFrmList + 1] = "DLCMapInfoNode" .. index
		
		--清除缓存
		_frmNode.childUI["DLCMapInfoNode" .. index].data.s91 = nil
		_frmNode.childUI["DLCMapInfoNode" .. index].data.s92_sysmail = nil
		
		--存储异步待绘制消息列表
		current_async_paint_list[index] = tMailI
	end
	
	--函数：获得第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离
	getUpDownOffset = function()
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--第一个DLC地图面板的数据
		local DLCMapInfoBtn1 = _frmNode.childUI["DLCMapInfoNode1"]
		local btn1_cx, btn1_cy = 0, 0 --第一个DLC地图面板中心点位置
		local btn1_ly = 0 --第一个DLC地图面板最上侧的x坐标
		local delta1_ly = 0 --第一个DLC地图面板距离上侧边界的距离
		if DLCMapInfoBtn1 then
			btn1_cx, btn1_cy = DLCMapInfoBtn1.data.x, DLCMapInfoBtn1.data.y --第一个DLC地图面板中心点位置
			btn1_ly = btn1_cy + DLCMAPINFO_OFFSET_H / 2 --第一个DLC地图面板最上侧的x坐标
			delta1_ly = btn1_ly + 61
		end
		
		--最后一个DLC地图面板的数据
		local DLCMapInfoBtnN = _frmNode.childUI["DLCMapInfoNode" .. current_DLCMap_max_num]
		local btnN_cx, btnN_cy = 0, 0 --最后一个DLC地图面板中心点位置
		local btnN_ry = 0 --最后一个DLC地图面板最下侧的x坐标
		local deltNa_ry = 0 --最后一个DLC地图面板距离下侧边界的距离
		if DLCMapInfoBtnN then
			btnN_cx, btnN_cy = DLCMapInfoBtnN.data.x, DLCMapInfoBtnN.data.y --最后一个DLC地图面板中心点位置
			btnN_ry = btnN_cy - DLCMAPINFO_OFFSET_H / 2 --最后一个DLC地图面板最下侧的x坐标
			deltNa_ry = btnN_ry + 530 + 101 - 25 --最后一个DLC地图面板距离下侧边界的距离
		end
		
		--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
		
		return delta1_ly, deltNa_ry
	end
	
	--函数：获得奖励第一个控件和最后一个控件距离最左面边界线和最右面边界线的距离
	getLeftRightOffset = function()
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--第一个DLC地图面板的数据
		local DLCMapInfoBtn1 = _frmNode.childUI["DLCMapInfoNodeReward1"]
		local btn1_cx, btn1_cy = 0, 0 --第一个DLC地图面板中心点位置
		local btn1_lx = 0 --第一个DLC地图面板最上侧的x坐标
		local delta1_lx = 0 --第一个DLC地图面板距离上侧边界的距离
		--print(DLCMapInfoBtn1)
		if DLCMapInfoBtn1 then
			btn1_cx, btn1_cy = DLCMapInfoBtn1.data.x, DLCMapInfoBtn1.data.y --第一个DLC地图面板中心点位置
			btn1_lx = btn1_cx - 463 + 10 --第一个DLC地图面板最左侧的x坐标
			delta1_lx = btn1_lx - 133 + 172 --第一个DLC地图面板距离左侧边界的距离
		end
		
		--最后一个DLC地图面板的数据
		local DLCMapInfoBtnN = _frmNode.childUI["DLCMapInfoNodeReward" .. current_DLCMap_reward_max_num]
		local btnN_cx, btnN_cy = 0, 0 --最后一个DLC地图面板中心点位置
		local btnN_rx = 0 --最后一个DLC地图面板最下侧的x坐标
		local deltNa_rx = 0 --最后一个DLC地图面板距离下侧边界的距离
		if DLCMapInfoBtnN then
			btnN_cx, btnN_cy = DLCMapInfoBtnN.data.x, DLCMapInfoBtnN.data.y --最后一个DLC地图面板中心点位置
			btnN_rx = btnN_cx - 463 + 82 --最后一个DLC地图面板最右侧的x坐标
			deltNa_rx = btnN_rx - 438 + 172 --最后一个DLC地图面板距离右侧边界的距离
			--print("delta1_lx, deltNa_rx", delta1_lx, deltNa_rx)
		end
		
		return delta1_lx, deltNa_rx
	end
	
	--显示某个邮件的详情界面
	OnCreateSystemMailDetailInfo = function(selectIdx)
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--不重复显示同一个邮件详情
		if (current_DLCMap_selectIdx == selectIdx) then
			return
		end
		
		--标记选中某个邮件
		current_DLCMap_selectIdx = selectIdx
		
		--清除右侧界面
		_removeRightFrmFunc()
		
		--print(selectIdx)
		
		--隐藏其他选中框
		for i = 1, current_DLCMap_max_num, 1 do
			if (selectIdx ~= i) then
				if _frmNode.childUI["DLCMapInfoNode" .. i] then
					if _frmNode.childUI["DLCMapInfoNode" .. i].data.s91 then
						_frmNode.childUI["DLCMapInfoNode" .. i].data.s91:setVisible(true)
					end
					if _frmNode.childUI["DLCMapInfoNode" .. i].data.s92_sysmail then
						_frmNode.childUI["DLCMapInfoNode" .. i].data.s92_sysmail:setVisible(false)
					end
					if _frmNode.childUI["DLCMapInfoNode" .. i].childUI["icon"] then
						_frmNode.childUI["DLCMapInfoNode" .. i].childUI["icon"].handle._n:setVisible(true)
					end
					if _frmNode.childUI["DLCMapInfoNode" .. i].childUI["icon_selected"] then
						_frmNode.childUI["DLCMapInfoNode" .. i].childUI["icon_selected"].handle._n:setVisible(false)
					end
					if _frmNode.childUI["DLCMapInfoNode" .. i].childUI["title"] then
						_frmNode.childUI["DLCMapInfoNode" .. i].childUI["title"].handle.s:setColor(ccc3(255, 255, 255)) --白色
					end
				end
			end
		end
		
		--显示本条选中框
		if _frmNode.childUI["DLCMapInfoNode" .. selectIdx] then
			if _frmNode.childUI["DLCMapInfoNode" .. selectIdx].data.s91 then
				_frmNode.childUI["DLCMapInfoNode" .. selectIdx].data.s91:setVisible(false)
			end
			if _frmNode.childUI["DLCMapInfoNode" .. selectIdx].data.s92_sysmail then
				_frmNode.childUI["DLCMapInfoNode" .. selectIdx].data.s92_sysmail:setVisible(true)
			end
			if _frmNode.childUI["DLCMapInfoNode" .. selectIdx].childUI["icon"] then
				_frmNode.childUI["DLCMapInfoNode" .. selectIdx].childUI["icon"].handle._n:setVisible(false)
			end
			if _frmNode.childUI["DLCMapInfoNode" .. selectIdx].childUI["icon_selected"] then
				_frmNode.childUI["DLCMapInfoNode" .. selectIdx].childUI["icon_selected"].handle._n:setVisible(true)
			end
			if _frmNode.childUI["DLCMapInfoNode" .. selectIdx].childUI["title"] then
				_frmNode.childUI["DLCMapInfoNode" .. selectIdx].childUI["title"].handle.s:setColor(ccc3(0, 255, 0)) --绿色
			end
		end
		
		--[[
		--右侧底板
		--背景图
		_frmNode.childUI["DLCMapInfoListBG_Right"] = hUI.button:new({ --作为按钮只是为了挂载子控件
			parent = _parentNode,
			--model = "misc/selectbg.png",
			model = -1,
			x = DLCMAPINFO_OFFSET_X + DLCMAPINFO_WIDTH / 2 + 236,
			y = DLCMAPINFO_OFFSET_Y - 330,
			w = 1,
			h = 1,
		})
		rightRemoveFrmList[#rightRemoveFrmList+1] = "DLCMapInfoListBG_Right"
		
		--右侧背景图
		--九宫格
		local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_graywhite.png", 0, 0, DLCMAPINFO_WIDTH + 10, DLCMAPINFO_HEIGHT, _frmNode.childUI["DLCMapInfoListBG_Right"])
		s9:setOpacity(64)
		s9:setColor(ccc3(168, 168, 168))
		]]
		
		--显示右侧信息
		local tMailI = current_DLCMap_mail_list[selectIdx]
		if (tMailI == nil) then
			return
		end
		
		local prizeId = tMailI.prizeId --邮件id
		local prizeType = tMailI.prizeType --邮件类型
		local prizeContent = tMailI.prizeContent --邮件正文
		local rewardFlag = tMailI.rewardFlag --是否已领取的标记flag
		local prizeSeconds = tMailI.prizeSeconds --邮件剩余领取时间（单位：秒）
		--print(prizeId, prizeType, prizeContent, rewardFlag)
		
		--邮件标题
		--解析邮件标题
		local itemID,itemNum,itemName,itemHole,coin,score,itemBack,itemModel,GiftTip,GiftTip_Ex,ex_num,_,_,giftType = hApi.UnpackPrizeData(prizeType,prizeId,prizeContent)
		--标题过滤掉回车符
		GiftTip = string.gsub(GiftTip, "\n", "") --过滤掉回车符
		GiftTip = GiftTip:gsub("^%s*(.-)%s*$", "%1") --trim
		
		--邮件正文
		local strMailContent = hVar.tab_string["SystemMail_Conetnt"] --"请领取您的奖励。"
		if (prizeType == 2000) then --系统邮件
			local tPrizeList = hApi.Split(prizeContent,";")
			strMailContent = tPrizeList[2]
		elseif (prizeType == 20029) then --无尽排名奖励
			--解析无尽排名的参数
			local tPrizeList = hApi.Split(prizeContent,";")
			local title = tostring(tPrizeList[1]) --标题
			local strDate = tostring(tPrizeList[2]) --日期
			local rankId = tonumber(tPrizeList[3]) or 0 --排行榜id
			local myRank = tonumber(tPrizeList[4]) or 0 --我的排名
			local logId = tonumber(tPrizeList[5]) or 0 --日志id
			
			--邮件的产生时间
			local yyyy = string.sub(strDate, 1, 4)
			local mm = string.sub(strDate, 6, 7)
			local dd = string.sub(strDate, 9, 10)
			local mailTime = hApi.GetNewDate(strDate .. " 23:59:59")
			
			--服务器时间
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
			local hostTime = hApi.GetNewDate(g_systime)
			hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
			
			--时间差(北京时区)
			local ts = hostTime - mailTime
			local tab2 = os.date("*t", hostTime)
			
			--日期的文字描述
			--如果是昨天，显示"昨日"
			--如果是今年，显示"XX月XX日"
			--如果是更早的年份，显示"XXXX年XX月XX日"
			local strYMD = ""
			if (ts < (3600 * 24)) then --昨天
				--"昨日"
				strYMD = hVar.tab_string["__Yesterday"]
			elseif (tonumber(yyyy) == tab2.year) then --今年
				--"XX月XX日"
				strYMD = mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
			else --更久的年份
				--"XXXX年XX月XX日"
				strYMD = yyyy .. hVar.tab_string["_TEXT_YEAR_"] .. mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
			end
			
			--地图名
			local mapName = ""
			if (rankId == 1) then --随机迷宫
				mapName = hVar.tab_stringM["world/csys_random_test"][1]
			elseif (rankId == 2) then --前哨阵地
				mapName = hVar.tab_stringM["world/yxys_ex_002"][1]
			end
			
			--标题
			--"在%s的%s中，您排行第%d名。以下玩家取得前10排名。"
			strMailContent = string.format(hVar.tab_string["SystemMail_Endless"], strYMD, hVar.tab_string["["] .. mapName .. hVar.tab_string["]"], myRank)
		elseif (prizeType == 20030) then --魔龙宝库勤劳奖
			local tPrizeList = hApi.Split(prizeContent,";")
			local title = tostring(tPrizeList[1]) --标题
			local strDate = tostring(tPrizeList[2]) --日期
			local count = tonumber(tPrizeList[3]) or 0 --次数
			
			--邮件的产生时间
			local yyyy = string.sub(strDate, 1, 4)
			local mm = string.sub(strDate, 6, 7)
			local dd = string.sub(strDate, 9, 10)
			local mailTime = hApi.GetNewDate(strDate .. " 23:59:59")
			
			--服务器时间
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
			local hostTime = hApi.GetNewDate(g_systime)
			hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
			
			--时间差(北京时区)
			local ts = hostTime - mailTime
			local tab2 = os.date("*t", hostTime)
			
			--日期的文字描述
			--如果是昨天，显示"昨日"
			--如果是今年，显示"XX月XX日"
			--如果是更早的年份，显示"XXXX年XX月XX日"
			local strYMD = ""
			if (tonumber(yyyy) == tab2.year) and (tonumber(mm) == tab2.month) and (tonumber(dd) == tab2.day) then --今日
				--"今日"
				strYMD = hVar.tab_string["__Today"]
			elseif (ts < (3600 * 24)) then --昨天
				--"昨日"
				strYMD = hVar.tab_string["__Yesterday"]
			elseif (tonumber(yyyy) == tab2.year) then --今年
				--"XX月XX日"
				strYMD = mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
			else --更久的年份
				--"XXXX年XX月XX日"
				strYMD = yyyy .. hVar.tab_string["_TEXT_YEAR_"] .. mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
			end
			
			--地图名
			local mapName = hVar.tab_stringM["world/td_wj_003"][1]
			
			--标题
			--"在%s的%s副本中，您累计通关%d次，遥遥领先其它玩家，荣获“最佳勤劳奖”。"
			strMailContent = string.format(hVar.tab_string["SystemMail_PveMulty"], strYMD, hVar.tab_string["["] .. mapName .. hVar.tab_string["]"], count)
		elseif (prizeType == 20031) then --带有标题正文的邮件
			local tPrizeList = hApi.Split(prizeContent,";")
			strMailContent = tPrizeList[2]
		elseif (prizeType == 20033) then --只有标题和正文，没有奖励
			local tPrizeList = hApi.Split(prizeContent,";")
			strMailContent = tPrizeList[2]
		elseif (prizeType == 20034) then --夺塔奇兵带有段位、标题和正文的奖励
			local tPrizeList = hApi.Split(prizeContent,";")
			strMailContent = tPrizeList[3]
		elseif (prizeType == 20035) then --聊天龙王奖
			local tPrizeList = hApi.Split(prizeContent,";")
			local title = tostring(tPrizeList[1]) --标题
			local strDate = tostring(tPrizeList[2]) --日期
			local count = tonumber(tPrizeList[3]) or 0 --次数
			
			--邮件的产生时间
			local yyyy = string.sub(strDate, 1, 4)
			local mm = string.sub(strDate, 6, 7)
			local dd = string.sub(strDate, 9, 10)
			local mailTime = hApi.GetNewDate(strDate .. " 23:59:59")
			
			--服务器时间
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
			local hostTime = hApi.GetNewDate(g_systime)
			hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
			
			--时间差(北京时区)
			local ts = hostTime - mailTime
			local tab2 = os.date("*t", hostTime)
			
			--日期的文字描述
			--如果是昨天，显示"昨日"
			--如果是今年，显示"XX月XX日"
			--如果是更早的年份，显示"XXXX年XX月XX日"
			local strYMD = ""
			if (tonumber(yyyy) == tab2.year) and (tonumber(mm) == tab2.month) and (tonumber(dd) == tab2.day) then --今日
				--"今日"
				strYMD = hVar.tab_string["__Today"]
			elseif (ts < (3600 * 24)) then --昨天
				--"昨日"
				strYMD = hVar.tab_string["__Yesterday"]
			elseif (tonumber(yyyy) == tab2.year) then --今年
				--"XX月XX日"
				strYMD = mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
			else --更久的年份
				--"XXXX年XX月XX日"
				strYMD = yyyy .. hVar.tab_string["_TEXT_YEAR_"] .. mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
			end
			
			--地图名
			--local mapName = hVar.tab_stringM["world/td_wj_003"][1]
			
			--标题
			--"在%s的聊天中，您侃侃而谈，累计聊天%d次，遥遥领先其它玩家，荣获“聊天龙王奖”。"
			strMailContent = string.format(hVar.tab_string["SystemMail_ChatDragon"], strYMD, count)
		elseif (prizeType == 20036) then --军团秘境试炼勤劳奖
			local tPrizeList = hApi.Split(prizeContent,";")
			local title = tostring(tPrizeList[1]) --标题
			local strDate = tostring(tPrizeList[2]) --日期
			local count = tonumber(tPrizeList[3]) or 0 --次数
			
			--邮件的产生时间
			local yyyy = string.sub(strDate, 1, 4)
			local mm = string.sub(strDate, 6, 7)
			local dd = string.sub(strDate, 9, 10)
			local mailTime = hApi.GetNewDate(strDate .. " 23:59:59")
			
			--服务器时间
			local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
			local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
			local hostTime = hApi.GetNewDate(g_systime)
			hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
			
			--时间差(北京时区)
			local ts = hostTime - mailTime
			local tab2 = os.date("*t", hostTime)
			
			--日期的文字描述
			--如果是昨天，显示"昨日"
			--如果是今年，显示"XX月XX日"
			--如果是更早的年份，显示"XXXX年XX月XX日"
			local strYMD = ""
			if (tonumber(yyyy) == tab2.year) and (tonumber(mm) == tab2.month) and (tonumber(dd) == tab2.day) then --今日
				--"今日"
				strYMD = hVar.tab_string["__Today"]
			elseif (ts < (3600 * 24)) then --昨天
				--"昨日"
				strYMD = hVar.tab_string["__Yesterday"]
			elseif (tonumber(yyyy) == tab2.year) then --今年
				--"XX月XX日"
				strYMD = mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
			else --更久的年份
				--"XXXX年XX月XX日"
				strYMD = yyyy .. hVar.tab_string["_TEXT_YEAR_"] .. mm .. hVar.tab_string["_TEXT_MONTH_"] .. dd .. hVar.tab_string["_TEXT_DAY_"]
			end
			
			--地图名
			local mapName = hVar.tab_string["__TEXT_MAINUI_BTN_GROUP"] .. hVar.tab_stringM["world/td_jt_004"][1]
			
			--标题
			--"在%s的%s副本中，您累计通关%d次，遥遥领先其它玩家，荣获“最佳勤劳奖”。"
			strMailContent = string.format(hVar.tab_string["SystemMail_PveMulty"], strYMD, hVar.tab_string["["] .. mapName .. hVar.tab_string["]"], count)
		elseif (prizeType == 20037) then --军团本周声望排名奖励
			local tPrizeList = hApi.Split(prizeContent,";")
			strMailContent = tPrizeList[2]
		elseif (prizeType == 20038) then --军团本周声望第一名奖励
			local tPrizeList = hApi.Split(prizeContent,";")
			strMailContent = tPrizeList[2]
		elseif (prizeType == 20039) then --更新维护带有标题和正文的奖励
			local tPrizeList = hApi.Split(prizeContent,";")
			strMailContent = tPrizeList[2]
		elseif (prizeType == 20040) then --体力带有标题和正文的奖励
			local tPrizeList = hApi.Split(prizeContent,";")
			strMailContent = tPrizeList[2]
		elseif (prizeType == 20041) then --感谢信带有标题和正文的奖励
			local tPrizeList = hApi.Split(prizeContent,";")
			strMailContent = tPrizeList[2]
		elseif (prizeType == 20042) then --分享信带有标题和正文的奖励
			local tPrizeList = hApi.Split(prizeContent,";")
			strMailContent = tPrizeList[2]
		end
		
		--邮件奖励
		local tPrize = {}
		if (prizeType == 4) then --网页发奖道具
			tPrize[#tPrize+1] = {3,itemID,itemNum,1,}
		elseif (prizeType == 9) then --每日奖励
			if (coin > 0) then
				tPrize[#tPrize+1] = {7,coin,0,0,}
			end
			if (score > 0) then
				tPrize[#tPrize+1] = {1,score,0,0,}
			end
		elseif (prizeType == 18) then --评价奖励
			if (coin > 0) then
				tPrize[#tPrize+1] = {7,coin,0,0,}
			end
			if (score > 0) then
				tPrize[#tPrize+1] = {1,score,0,0,}
			end
		elseif (prizeType == 100) then --新人礼包
			if (coin > 0) then
				tPrize[#tPrize+1] = {7,coin,0,0,}
			end
			if (score > 0) then
				tPrize[#tPrize+1] = {1,score,0,0,}
			end
		elseif (prizeType == 1030) or (prizeType == 1031) or (prizeType == 1032) or (prizeType == 1033) then --首充奖励
			tPrize[#tPrize+1] = {3,itemID,itemNum,1,}
			if (coin > 0) then
				tPrize[#tPrize+1] = {7,coin,0,0,}
			end
		elseif (prizeType == 1034) then --首充奖励
			tPrize[#tPrize+1] = {4,itemID,itemNum,1,}
			if (coin > 0) then
				tPrize[#tPrize+1] = {7,coin,0,0,}
			end
		elseif (prizeType == 1035) or (prizeType == 1036) then --首充奖励
			tPrize[#tPrize+1] = {10,itemID,itemNum,1,}
			if (coin > 0) then
				tPrize[#tPrize+1] = {7,coin,0,0,}
			end
		elseif (prizeType == 1039) or (prizeType == 1060) then --网页发奖积分
			tPrize[#tPrize+1] = {1,itemID,itemNum,1,}
		elseif (prizeType >= 1900) and (prizeType <= 1999) then --分享奖励
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 1, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				--print(rewardT[1],rewardT[2],rewardT[3],rewardT[4])
				if (id > 0) then
					tPrize[#tPrize+1] = {id,lv,num,param4,}
				end
			end
		elseif (prizeType == 20001) then --无尽排名奖励（旧）
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 4, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				--print(rewardT[1],rewardT[2],rewardT[3],rewardT[4])
				if (id > 0) then
					tPrize[#tPrize+1] = {id,lv,num,param4,}
				end
			end
		elseif (prizeType >= 20002) and (prizeType <= 20007) then --推荐奖励
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 1, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				--print(rewardT[1],rewardT[2],rewardT[3],rewardT[4])
				if (id > 0) then
					tPrize[#tPrize+1] = {id,lv,num,param4,}
				end
			end
		elseif (prizeType == 20008) or (prizeType == 20009) then --td发奖邮件
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 2, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				--print(rewardT[1],rewardT[2],rewardT[3],rewardT[4])
				if (id > 0) then
					tPrize[#tPrize+1] = {id,lv,num,param4,}
				end
			end
		elseif (prizeType >= 20010) and (prizeType <= 20020) then --vip一次性奖励
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 2, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				--print(rewardT[1],rewardT[2],rewardT[3],rewardT[4])
				if (id > 0) then
					tPrize[#tPrize+1] = {id,lv,num,param4,}
				end
			end
		elseif (prizeType == 20028) then --服务器抽卡类型
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 2, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				--print(rewardT[1],rewardT[2],rewardT[3],rewardT[4])
				if (id > 0) then
					tPrize[#tPrize+1] = {id,lv,num,param4,}
				end
			end
		elseif (prizeType == 20029) then --无尽排名奖励
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 6, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				--print(rewardT[1],rewardT[2],rewardT[3],rewardT[4])
				if (id > 0) then
					tPrize[#tPrize+1] = {id,lv,num,param4,}
				end
			end
		elseif (prizeType == 20030) then --魔龙宝库勤劳奖
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 4, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				--print(rewardT[1],rewardT[2],rewardT[3],rewardT[4])
				if (id > 0) then
					tPrize[#tPrize+1] = {id,lv,num,param4,}
				end
			end
		elseif (prizeType == 20031) then --带有标题正文的邮件
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 3, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				if (id > 0) then
					tPrize[#tPrize+1] = {id,lv,num,param4,}
				end
			end
		elseif (prizeType == 20032) then --服务器直接开锦囊
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 2, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				if (id > 0) then
					tPrize[#tPrize+1] = {id,lv,num,param4,}
				end
			end
		elseif (prizeType == 20033) then --只有标题和正文，没有奖励
			--
		elseif (prizeType == 20034) then --夺塔奇兵带有段位、标题和正文的奖励
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 4, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				if (id > 0) then
					tPrize[#tPrize+1] = {id,lv,num,param4,}
				end
			end
		elseif (prizeType == 20035) then --聊天龙王奖
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 4, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				--print(rewardT[1],rewardT[2],rewardT[3],rewardT[4])
				if (id > 0) then
					tPrize[#tPrize+1] = {id,lv,num,param4,}
				end
			end
		elseif (prizeType == 20036) then --军团秘境试炼勤劳奖
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 4, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				--print(rewardT[1],rewardT[2],rewardT[3],rewardT[4])
				if (id > 0) then
					tPrize[#tPrize+1] = {id,lv,num,param4,}
				end
			end
		elseif (prizeType == 20037) then --军团本周声望排名奖励
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 3, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				if (id > 0) then
					tPrize[#tPrize+1] = {id,lv,num,param4,}
				end
			end
		elseif (prizeType == 20038) then --军团本周声望第一名奖励
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 3, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				if (id > 0) then
					tPrize[#tPrize+1] = {id,lv,num,param4,}
				end
			end
		elseif (prizeType == 20039) then --更新维护带有标题和正文的奖励
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 3, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				if (id > 0) then
					tPrize[#tPrize+1] = {id,lv,num,param4,}
				end
			end
		elseif (prizeType == 20040) then --体力带有标题和正文的奖励
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 3, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				if (id > 0) then
					tPrize[#tPrize+1] = {id,lv,num,param4,}
				end
			end
		elseif (prizeType == 20041) then --感谢信带有标题和正文的奖励
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 3, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				if (id > 0) then
					tPrize[#tPrize+1] = {id,lv,num,param4,}
				end
			end
		elseif (prizeType == 20042) then --分享信带有标题和正文的奖励
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 3, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				if (id > 0) then
					tPrize[#tPrize+1] = {id,lv,num,param4,}
				end
			end
		end
		
		--标题
		--[[
		--邮件标题底纹
		_frmNode.childUI["DLCMapInfoDetailTitleBG"] = hUI.button:new({ --作为按钮只是为了挂载子控件
			parent = _parentNode,
			model = -1,
			x = DLCMAPINFO_OFFSET_X + DLCMAPINFO_WIDTH + 130,
			y = DLCMAPINFO_OFFSET_Y - 120 + 120,
			w = 1,
			h = 1,
		})
		rightRemoveFrmList[#rightRemoveFrmList+1] = "DLCMapInfoDetailTitleBG"
		local s9 = hApi.CCScale9SpriteCreate("data/image/misc/task/event_frame.png", 0, 0, 180, 71, _frmNode.childUI["DLCMapInfoDetailTitleBG"])
		]]
		--s9:setOpacity(168)
		--s9:setColor(ccc3(212, 212, 212))
		
		--邮件标题
		local titleSize = 28
		local titleLength = #GiftTip --文字长度
		if (titleLength > 48) then
			--titleSize = 24
		end
		_frmNode.childUI["DLCMapInfoDetailTitle"] = hUI.label:new({
			parent = _parentNode,
			x = DLCMAPINFO_OFFSET_X + DLCMAPINFO_WIDTH + 140,
			y = DLCMAPINFO_OFFSET_Y - 120 - 3 + 132,
			width = 500,
			font = hVar.FONTC,
			size = titleSize,
			align = "MC",
			text = hApi.StringDecodeEmoji(GiftTip), --还原表情
			border = 1,
			RGB = {255, 255, 192,},
		})
		rightRemoveFrmList[#rightRemoveFrmList+1] = "DLCMapInfoDetailTitle"
		
		--邮件剩余领取时间
		_frmNode.childUI["DLCMapInfoDetailLeftTime"] = hUI.label:new({
			parent = _parentNode,
			x = DLCMAPINFO_OFFSET_X + DLCMAPINFO_WIDTH + 100 - 30,
			y = DLCMAPINFO_OFFSET_Y - 120 - 1 + 70 - 410,
			width = 500,
			font = hVar.FONTC,
			size = 22,
			align = "RC",
			text = "",
			border = 1,
			RGB = {0, 255, 0,},
		})
		rightRemoveFrmList[#rightRemoveFrmList+1] = "DLCMapInfoDetailLeftTime"
		--计算剩余领取时间
		local day = math.floor(prizeSeconds / 3600 / 24) --时
		local hour = math.floor((prizeSeconds - day * 24 * 3600) / 3600) --时
		local minute = math.floor((prizeSeconds - day * 24 * 3600 - hour * 3600)/ 60) --分
		local second = prizeSeconds - hour * 3600 - minute * 60 --秒
		
		--拼接字符串
		local szDay = tostring(day) --天(字符串)
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
		
		--更新剩余领取时间
		if (prizeSeconds == 0) then
			_frmNode.childUI["DLCMapInfoDetailLeftTime"]:setText(hVar.tab_string["SystemMail_Expired"]) --"邮件即将过期，请尽快领取！"
			_frmNode.childUI["DLCMapInfoDetailLeftTime"].handle.s:setColor(ccc3(255, 0, 0))
		else
			if (day > 0) then
				_frmNode.childUI["DLCMapInfoDetailLeftTime"]:setText(szDay .. hVar.tab_string["__TEXT_Dat"] .. hVar.tab_string["__TEXT_RewardLeftTime"]) --"剩余领取时间: XX天XX时XX分"
				_frmNode.childUI["DLCMapInfoDetailLeftTime"].handle.s:setColor(ccc3(0, 255, 0))
			elseif (hour > 0) then
				_frmNode.childUI["DLCMapInfoDetailLeftTime"]:setText(szHour .. hVar.tab_string["__TEXT_Hour_Short"] .. szMinute .. hVar.tab_string["__Minute"] .. hVar.tab_string["__TEXT_RewardLeftTime"]) --"剩余领取时间: XX时XX分XX秒"
				_frmNode.childUI["DLCMapInfoDetailLeftTime"].handle.s:setColor(ccc3(255, 0, 0))
			else
				_frmNode.childUI["DLCMapInfoDetailLeftTime"]:setText(szMinute .. hVar.tab_string["__Minute"] .. szSecond .. hVar.tab_string["__Second"] .. hVar.tab_string["__TEXT_RewardLeftTime"]) --"剩余领取时间: XX时XX分XX秒"
				_frmNode.childUI["DLCMapInfoDetailLeftTime"].handle.s:setColor(ccc3(255, 0, 0))
			end
		end
		--已领取就不显示倒计时了
		if (rewardFlag == 1) then
			_frmNode.childUI["DLCMapInfoDetailLeftTime"]:setText("")
		end
		
		--系统邮件不显示文字
		if (prizeType == 2000) then --系统邮件
			_frmNode.childUI["DLCMapInfoDetailLeftTime"]:setText("")
		end
		
		--邮件正文
		--解析正文里的"\n"，替换成换行符
		strMailContent = string.gsub(strMailContent, "|n", "\n")
		_frmNode.childUI["DLCMapInfoDetailContent"] = hUI.label:new({
			parent = _parentNode,
			x = DLCMAPINFO_OFFSET_X + DLCMAPINFO_WIDTH / 2 + 22 + 20,
			y = DLCMAPINFO_OFFSET_Y - 184 + 150,
			width = 418+11,
			font = hVar.FONTC,
			size = 24,
			align = "LT",
			text = hApi.StringDecodeEmoji(strMailContent), --还原表情
			border = 1,
		})
		rightRemoveFrmList[#rightRemoveFrmList+1] = "DLCMapInfoDetailContent"
		
		--横线
		_frmNode.childUI["DLCMapInfoDetailSeparateLine"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/rank_line.png",
			x = DLCMAPINFO_OFFSET_X + DLCMAPINFO_WIDTH + 8 + 150,
			y = DLCMAPINFO_OFFSET_Y - 470 + 140,
			w = 400,
			h = 2,
		})
		_frmNode.childUI["DLCMapInfoDetailSeparateLine"].handle.s:setOpacity(192)
		rightRemoveFrmList[#rightRemoveFrmList+1] = "DLCMapInfoDetailSeparateLine"
		
		--------------------------------------------------------------------
		--存储奖励数量
		current_DLCMap_reward_max_num = #tPrize
		
		--右侧DLC地图包列表提示左翻页的图片
		_frmNode.childUI["DLCMapInfoPageLeft"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/skillup/arrow_down.png",
			x = DLCMAPINFO_OFFSET_X + DLCMAPINFO_WIDTH - DLCMAPINFO_WIDTH/2 + 130,
			y = DLCMAPINFO_OFFSET_Y - 384,
			scale = 1.0,
			z = 500, --最前端显示
		})
		_frmNode.childUI["DLCMapInfoPageLeft"].handle.s:setRotation(90)
		_frmNode.childUI["DLCMapInfoPageLeft"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_frmNode.childUI["DLCMapInfoPageLeft"].handle.s:setVisible(false) --默认不显示左翻页提示
		rightRemoveFrmList[#rightRemoveFrmList+1] = "DLCMapInfoPageLeft"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(-3, 0)), CCMoveBy:create(0.5, ccp(3, 0)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["DLCMapInfoPageLeft"].handle._n:runAction(forever)
		
		--右侧DLC地图包列表提示右翻页的图片
		_frmNode.childUI["DLCMapInfoPageRight"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/skillup/arrow_down.png",
			x = DLCMAPINFO_OFFSET_X + DLCMAPINFO_WIDTH + DLCMAPINFO_WIDTH/2 + 280,
			y = DLCMAPINFO_OFFSET_Y - 384 + 0, --非对称式
			scale = 1.0,
			z = 500, --最前端显示
		})
		_frmNode.childUI["DLCMapInfoPageRight"].handle.s:setRotation(270)
		_frmNode.childUI["DLCMapInfoPageRight"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		_frmNode.childUI["DLCMapInfoPageRight"].handle.s:setVisible(false) --默认不显示右分翻页提示
		rightRemoveFrmList[#rightRemoveFrmList+1] = "DLCMapInfoPageRight"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(3, 0)), CCMoveBy:create(0.5, ccp(-3, 0)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["DLCMapInfoPageRight"].handle._n:runAction(forever)
		--超过一页的数量才滑屏
		if (current_DLCMap_reward_max_num > (DLCMAPINFO_REWARD_X_NUM * DLCMAPINFO_REWARD_Y_NUM)) then
			_frmNode.childUI["DLCMapInfoPageRight"].handle.s:setVisible(true) --显示右翻页提示
		end
		
		--右侧向左翻页的按钮的接受上点击事件的响应区域
		_frmNode.childUI["DLCMapInfoPageLeft_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = DLCMAPINFO_OFFSET_X + DLCMAPINFO_WIDTH - DLCMAPINFO_WIDTH/2 + 130 - 14,
			y = DLCMAPINFO_OFFSET_Y - 384,
			w = 72,
			h = 96,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (current_DLCMap_reward_max_num > (DLCMAPINFO_REWARD_X_NUM * DLCMAPINFO_REWARD_Y_NUM)) then
					--print("向左滚屏", screenY)
					--向左滚屏
					b_need_auto_fixing_friendinfo = true
					friction_friendinfo = 0
					friction_friendinfo_coefficient = 0.5 --衰减系数(默认值)
					draggle_speed_x_friendinfo = MAX_SPEED / 2.0 --正速度
				end
			end,
		})
		_frmNode.childUI["DLCMapInfoPageLeft_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		rightRemoveFrmList[#rightRemoveFrmList+1] = "DLCMapInfoPageLeft_Btn"
		
		--右侧向右翻页的按钮的接受下点击事件的响应区域
		_frmNode.childUI["DLCMapInfoPageRight_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = DLCMAPINFO_OFFSET_X + DLCMAPINFO_WIDTH + DLCMAPINFO_WIDTH/2 + 280 + 34,
			y = DLCMAPINFO_OFFSET_Y - 384,
			w = 84,
			h = 96,
			scaleT = 1.0,
			z = 100000, --最前端显示
			code = function(self, screenX, screenY, isInside)
				--超过一页的数量才滑屏
				if (current_DLCMap_reward_max_num > (DLCMAPINFO_REWARD_X_NUM * DLCMAPINFO_REWARD_Y_NUM)) then
					--print("向右滚屏", screenY)
					--向右滚屏
					b_need_auto_fixing_friendinfo = true
					friction_friendinfo = 0
					friction_friendinfo_coefficient = 0.5 --衰减系数(默认值)
					draggle_speed_x_friendinfo = -MAX_SPEED / 2.0 --负速度
				end
			end,
		})
		_frmNode.childUI["DLCMapInfoPageRight_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		rightRemoveFrmList[#rightRemoveFrmList+1] = "DLCMapInfoPageRight_Btn"
		
		--右侧用于检测滑动事件的控件
		_frmNode.childUI["DLCMapInfoDragPanel_Right"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = DLCMAPINFO_OFFSET_X + DLCMAPINFO_WIDTH + 210,
			y = DLCMAPINFO_OFFSET_Y - 410,
			w = 320,
			h = 200,
			failcall = 1,
			
			--按下事件
			codeOnTouch = function(self, touchX, touchY, sus)
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
				for i = 1, current_DLCMap_reward_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNodeReward" .. i]
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
						end
					end
				end
			end,
			
			--滑动事件
			codeOnDrag = function(self, touchX, touchY, sus)
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
						
						_frmNode.childUI["DLCMapInfoPageLeft"].handle.s:setVisible(false) --上分翻页提示
					else
						_frmNode.childUI["DLCMapInfoPageLeft"].handle.s:setVisible(true) --上分翻页提示
					end
					
					--最后一个DLC地图面板的坐标不能跑到最右侧的左边去
					if ((deltNa_rx + deltaX) <= 0) then --防止走过
						deltaX = -deltNa_rx
						deltNa_rx = 0
						
						--没有惯性
						draggle_speed_x_friendinfo = 0
						
						--已到底部，标记下拉到底部（为true时有新消息自动滚到最下端）
						--current_in_scroll_down = true
						_frmNode.childUI["DLCMapInfoPageRight"].handle.s:setVisible(false) --下分翻页提示
						--已拉到底，删除新消息提示
						--onRemoveNewMessageHint()
					else
						_frmNode.childUI["DLCMapInfoPageRight"].handle.s:setVisible(true) --下分翻页提示
					end
					
					for i = 1, current_DLCMap_reward_max_num, 1 do
						local ctrli = _frmNode.childUI["DLCMapInfoNodeReward" .. i]
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
				for i = 1, current_DLCMap_reward_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNodeReward" .. i]
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
					local ctrli = _frmNode.childUI["DLCMapInfoNodeReward" .. selectTipIdx]
					if ctrli then
						local rewardT = ctrli.data.rewardT
						if rewardT then
							--显示各种类型的奖励的tip
							hApi.ShowRewardTip(rewardT)
						end
					end
				end
				
				--标记不用滑动
				click_scroll_friendinfo = false
			end,
		})
		_frmNode.childUI["DLCMapInfoDragPanel_Right"].handle.s:setOpacity(0) --只用于控制，不显示
		rightRemoveFrmList[#rightRemoveFrmList+1] = "DLCMapInfoDragPanel_Right"
		
		--奖励文字
		_frmNode.childUI["DLCMapInfoDetailRewardPrefix"] = hUI.label:new({
			parent = _parentNode,
			x = DLCMAPINFO_OFFSET_X + DLCMAPINFO_WIDTH / 2 + 50,
			y = DLCMAPINFO_OFFSET_Y - 390,
			width = 390,
			font = hVar.FONTC,
			size = 26,
			align = "LC",
			text = hVar.tab_string["MadelGift"], --"奖励"
			border = 1,
		})
		rightRemoveFrmList[#rightRemoveFrmList+1] = "DLCMapInfoDetailRewardPrefix"
		
		--感谢信类型的邮件，不显示"奖励"
		if (prizeType == 20041) then --感谢信带有标题和正文的奖励
			_frmNode.childUI["DLCMapInfoDetailRewardPrefix"]:setText("")
		end
		
		--奖励内容
		for i = 1, #tPrize, 1 do
			local rewardT = tPrize[i]
			local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
			--local WW = 64
			--local HH = 64
			local scale = 1.52
			
			--奖励道具按钮
			_frmNode.childUI["DLCMapInfoNodeReward" .. i] = hUI.button:new({ --作为按钮只是为了挂载子控件
				parent = _BTC_pClipNode_reward,
				model = "misc/mask.png",
				--model = -1,
				x = DLCMAPINFO_OFFSET_X + 294 + (i - 1) * (64 + 12),
				y = DLCMAPINFO_OFFSET_Y - 406 + 22,
				w = 74,
				h = 84,
				--scaleT = 0.95,
				--dragbox = _frm.childUI["dragBox"],
				--code = function()
				--	--显示各种类型的奖励的tip
				--	hApi.ShowRewardTip(rewardT)
				--end,
			})
			_frmNode.childUI["DLCMapInfoNodeReward" .. i].handle.s:setOpacity(0) --只挂载子控件，不显示
			_frmNode.childUI["DLCMapInfoNodeReward" .. i].data.rewardT = rewardT --存储奖励
			rightRemoveFrmList[#rightRemoveFrmList+1] = "DLCMapInfoNodeReward" .. i
			
			--奖励物品的图标
			_frmNode.childUI["DLCMapInfoNodeReward" .. i].childUI["imgIcon"] = hUI.button:new({
				parent = _frmNode.childUI["DLCMapInfoNodeReward" .. i].handle._n,
				model = tmpModel,
				x = 0,
				y = 0,
				w = itemWidth * scale,
				h = itemHeight * scale,
				align = "MC",
			})
			
			--绘制奖励图标的子控件
			if sub_tmpModel then
				_frmNode.childUI["DLCMapInfoNodeReward" .. i].childUI["imgIcon"].childUI["image"] = hUI.image:new({
					parent = _frmNode.childUI["DLCMapInfoNodeReward" .. i].childUI["imgIcon"].handle._n,
					model = sub_tmpModel,
					x = sub_pos_x * scale,
					y = sub_pos_y * scale,
					w = sub_pos_w * scale,
					h = sub_pos_h * scale,
				})
			end
			
			--[[
			--奖励物品的名称
			_frmNode.childUI["DLCMapInfoNodeReward" .. i].childUI["labName"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNodeReward" .. i].handle._n,
				size = 20,
				align = "MT",
				border = 1,
				x =  0,
				y = -20,
				--font = hVar.FONTC,
				font = hVar.FONTC,
				width = 290,
				text = itemName,
			})
			_frmNode.childUI["DLCMapInfoNodeReward" .. i].childUI["labName"].handle.s:setColor(ccc3(196, 255, 196))
			]]
			
			--奖励物品的数量
			local intro = "+" .. itemNum
			if (itemNum < 0) then --负数
				intro = itemNum
			end
			local itemNumFontType = "numWhite"
			local itemNumFontSize = 22
			local itemNumFontY = -4
			local itemNumLength = #intro
			if (itemNumLength == 3) then --"+10"
				itemNumFontType = "numWhite"
				itemNumFontSize = 20
				itemNumFontY = -6
			elseif (itemNumLength == 4) then --"+100"
				itemNumFontType = "numWhite"
				itemNumFontSize = 18
				itemNumFontY = -8
			elseif (itemNumLength == 5) then --"+1000"
				itemNumFontType = "numWhite"
				itemNumFontSize = 16
				itemNumFontY = -10
			elseif (itemNumLength >= 6) then --"+10000"
				itemNumFontType = hVar.FONTC
				itemNumFontSize = 18
				itemNumFontY = -12
			end
			_frmNode.childUI["DLCMapInfoNodeReward" .. i].childUI["labIntro"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNodeReward" .. i].handle._n,
				size = itemNumFontSize,
				align = "RT",
				border = 1,
				x = 30,
				y = itemNumFontY,
				--font = hVar.FONTC,
				font = itemNumFontType,
				width = 290,
				text = intro,
			})
			--_frmNode.childUI["DLCMapInfoNodeReward" .. i].childUI["labIntro"].handle.s:setColor(ccc3(255, 255, 0))
		end
		
		--已领取图标
		_frmNode.childUI["DLCMapInfoDetailFinishTag"] = hUI.button:new({
			parent = _parentNode,
			x = DLCMAPINFO_OFFSET_X + DLCMAPINFO_WIDTH + 150,
			y = DLCMAPINFO_OFFSET_Y - 460,
			model = "UI:FinishTag",
			scale = 1.0,
		})
		rightRemoveFrmList[#rightRemoveFrmList+1] = "DLCMapInfoDetailFinishTag"
		_frmNode.childUI["DLCMapInfoDetailFinishTag"].handle._n:setRotation(15)
		
		--领奖按钮
		_frmNode.childUI["DLCMapInfoDetailBtn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/button_back.png", --"UI:PANEL_MENU_BTN_BIG", --"UI:ButtonBack",
			x = DLCMAPINFO_OFFSET_X + DLCMAPINFO_WIDTH + 150,
			y = DLCMAPINFO_OFFSET_Y - 460,
			label = {text = hVar.tab_string["__Get__"], size = 28, font = hVar.FONTC, x = 0, y = 0, border = 1, align = "MC",}, --"领取"
			dragbox = _frm.childUI["dragBox"],
			w = 130,
			h = 56,
			scaleT = 0.95,
			code = function()
				--领取某个邮件奖励
				OnTakeRewardSystemMail(selectIdx)
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList+1] = "DLCMapInfoDetailBtn"
		--已领取
		if (rewardFlag == 1) then
			_frmNode.childUI["DLCMapInfoDetailBtn"]:setstate(-1)
		else
			_frmNode.childUI["DLCMapInfoDetailFinishTag"].handle._n:setVisible(false)
		end
		
		--特殊处理的邮件类型
		--print("prizeType=", prizeType)
		--系统邮件，没有领奖
		if (prizeType == 2000) then --系统邮件
			_frmNode.childUI["DLCMapInfoDetailSeparateLine"].handle._n:setVisible(false) --横线
			_frmNode.childUI["DLCMapInfoDetailRewardPrefix"].handle._n:setVisible(false) --奖励文字
			_frmNode.childUI["DLCMapInfoDetailBtn"]:setstate(-1) --领奖按钮
			_frmNode.childUI["DLCMapInfoDetailFinishTag"].handle._n:setVisible(true)
			_frmNode.childUI["DLCMapInfoDetailFinishTag"].handle._n:setVisible(false) --已领奖图标
			
			--geyachao: 标记最近一次阅读的邮件的标题
			LuaSetSystemMailTitle(g_curPlayerName, GiftTip)
			
			--是否有链接跳转
			local tPrizeList = hApi.Split(prizeContent,";")
			local strLink = tPrizeList[3]
			if (strLink ~= nil) and (strLink ~= "") then
				--查看按钮
				_frmNode.childUI["DLCMapInfoDetailBtn"] = hUI.button:new({
					parent = _parentNode,
					model = "UI:PANEL_MENU_BTN_BIG", --"UI:ButtonBack",
					x = DLCMAPINFO_OFFSET_X + DLCMAPINFO_WIDTH + 8,
					y = DLCMAPINFO_OFFSET_Y - 600,
					label = {text = hVar.tab_string["__Read__"], size = 26, font = hVar.FONTC, x = 0, y = -2, border = 1, align = "MC",}, --"查看"
					dragbox = _frm.childUI["dragBox"],
					w = 120,
					h = 46,
					scaleT = 0.95,
					code = function()
						--跳转链接
						strLink = string.gsub(strLink, "\n", "") --过滤掉回车符
						strLink = strLink:gsub("^%s*(.-)%s*$", "%1") --trim
						strLink = string.gsub(strLink, "\\", "/")
						xlOpenUrl(strLink)
					end,
				})
				rightRemoveFrmList[#rightRemoveFrmList+1] = "DLCMapInfoDetailBtn"
			end
		elseif (prizeType == 20029) then --无尽排名奖励
			--解析无尽排名的参数
			local tPrizeList = hApi.Split(prizeContent,";")
			local title = tostring(tPrizeList[1]) --标题
			local strDate = tostring(tPrizeList[2]) --日期
			local rankId = tonumber(tPrizeList[3]) or 0 --排行榜id
			local myRank = tonumber(tPrizeList[4]) or 0 --我的排名
			local logId = tonumber(tPrizeList[5]) or 0 --日志id
			
			--取本地缓存的无尽前10名玩家数据
			local tEndlessNaseList = tMailI.tEndlessNaseList --无尽前10名玩家数据
			if (tEndlessNaseList == nil) then
				--发送指令，获取指定logId的无尽排行榜的前10名玩家名
				SendCmdFunc["get_endless_rank_name"](rankId, logId)
			else
				--依次绘制前10名的排行和玩家名
				local rank1PosX = DLCMAPINFO_OFFSET_X + DLCMAPINFO_WIDTH - 100 + 144
				local rank1PosY = -DLCMAPINFO_OFFSET_Y - 314
				local rank1Width = 100
				local rank1Height = 28
				local rank1NamePosX = DLCMAPINFO_OFFSET_X + DLCMAPINFO_WIDTH + 56 + 144
				local rank1NameWidth = 220
				for i = 1, 8, 1 do
					--排名
					local ranking = i
					
					--排名背景图
					local bgModel = nil
					if (i % 2 == 0) then
						bgModel = "misc/progress.png"
					else
						bgModel = "misc/progress.png"
					end
					_frmNode.childUI["imageBG" .. ranking] = hUI.image:new({
						parent = _parentNode,
						model = bgModel,
						x = rank1PosX,
						y = rank1PosY - (i - 1) * rank1Height,
						w = rank1Width,
						h = rank1Height,
					})
					rightRemoveFrmList[#rightRemoveFrmList+1] = "imageBG" .. ranking
					if (i % 2 == 0) then
						_frmNode.childUI["imageBG" .. ranking].handle.s:setOpacity(22)
					else
						_frmNode.childUI["imageBG" .. ranking].handle.s:setOpacity(36)
					end
					
					--排名左边界线竖线
					_frmNode.childUI["imageBG_lineL" .. ranking] = hUI.image:new({
						parent = _parentNode,
						model = "UI:vipline", --"ui/pvp/td_mui_blbar.png",
						x = rank1PosX - rank1Width / 2 + 1,
						y = rank1PosY - (i - 1) * rank1Height - 1,
						z = 2,
						w = rank1Height + 1,
						h = 2,
					})
					rightRemoveFrmList[#rightRemoveFrmList+1] = "imageBG_lineL" .. ranking
					_frmNode.childUI["imageBG_lineL" .. ranking].handle.s:setRotation(-90+180)
					
					--排名右边界线竖线
					_frmNode.childUI["imageBG_lineR" .. ranking] = hUI.image:new({
						parent = _parentNode,
						model = "UI:vipline", --"ui/pvp/td_mui_blbar.png",
						x = rank1PosX + rank1Width / 2 - 1,
						y = rank1PosY - (i - 1) * rank1Height,
						w = rank1Height + 1, --非对称
						z = 2,
						h = 2,
					})
					rightRemoveFrmList[#rightRemoveFrmList+1] = "imageBG_lineR" .. ranking
					_frmNode.childUI["imageBG_lineR" .. ranking].handle.s:setRotation(90+180)
					
					--排名上边界线
					_frmNode.childUI["imageBG_lineU" .. ranking] = hUI.image:new({
						parent = _parentNode,
						model = "UI:vipline", --"ui/pvp/td_mui_blbar.png",
						x = rank1PosX - 1,
						y = rank1PosY - (i - 1) * rank1Height + rank1Height / 2,
						z = 1,
						w = rank1Width  - 2, --宽
						h = 2,
					})
					rightRemoveFrmList[#rightRemoveFrmList+1] = "imageBG_lineU" .. ranking
					_frmNode.childUI["imageBG_lineU" .. ranking].handle.s:setRotation(0+180)
					
					--排名下边界线
					_frmNode.childUI["imageBG_lineD" .. ranking] = hUI.image:new({
						parent = _parentNode,
						model = "UI:vipline", --"ui/pvp/td_mui_blbar.png",
						x = rank1PosX,
						y = rank1PosY - (i - 1) * rank1Height - rank1Height / 2,
						z = 1,
						w = rank1Width - 2, --宽
						h = 2,
					})
					rightRemoveFrmList[#rightRemoveFrmList+1] = "imageBG_lineD" .. ranking
					_frmNode.childUI["imageBG_lineD" .. ranking].handle.s:setRotation(180+180)
					
					--排名名次值
					local paintColor = nil
					if (ranking == 1) then --第1名
						--金色
						paintColor = hVar.RANKBOARD_COLOR.GOLD
						
						_frmNode.childUI["RankLabel" .. ranking] = hUI.image:new({
							parent = _parentNode,
							model = "UI:rank_n_1",
							--x = OFFSET_DX - 98,
							x = rank1PosX,
							y = rank1PosY - (i - 1) * rank1Height - 1,
							scale = 0.9,
						})
						rightRemoveFrmList[#rightRemoveFrmList+1] = "RankLabel" .. ranking
					elseif (ranking == 2) then --第2名
						--银色
						paintColor = hVar.RANKBOARD_COLOR.SILVER
						
						_frmNode.childUI["RankLabel" .. ranking] = hUI.image:new({
							parent = _parentNode,
							model = "UI:rank_n_2",
							--x = OFFSET_DX - 98,
							x = rank1PosX,
							y = rank1PosY - (i - 1) * rank1Height - 1,
							scale = 0.9,
						})
						rightRemoveFrmList[#rightRemoveFrmList+1] = "RankLabel" .. ranking
					elseif (ranking == 3) then --第3名
						--铜色
						paintColor = hVar.RANKBOARD_COLOR.COPPER
						
						_frmNode.childUI["RankLabel" .. ranking] = hUI.image:new({
							parent = _parentNode,
							model = "UI:rank_n_3",
							--x = OFFSET_DX - 98,
							x = rank1PosX,
							y = rank1PosY - (i - 1) * rank1Height - 0,
							scale = 0.9,
						})
						rightRemoveFrmList[#rightRemoveFrmList+1] = "RankLabel" .. ranking
					else --其他名次
						--淡白色
						paintColor = hVar.RANKBOARD_COLOR.TINTWHITE --第4~n名
						
						local scoreRankingSize = 20
						_frmNode.childUI["RankLabel" .. ranking] = hUI.label:new({
							parent = _parentNode,
							--x = OFFSET_DX - 98 - 2,
							x = rank1PosX,
							y = rank1PosY- (i - 1) * rank1Height - 2, --数字字体有2像素的偏差
							--size = 22,
							size = scoreRankingSize,
							font = "numWhite",
							align = "MC",
							width = 300,
							--border = 1,
							text = ranking,
						})
						rightRemoveFrmList[#rightRemoveFrmList+1] = "RankLabel" .. ranking
						_frmNode.childUI["RankLabel" .. ranking].handle.s:setColor(paintColor)
					end
					
					--玩家名背景图
					_frmNode.childUI["imageNameBG" .. ranking] = hUI.image:new({
						parent = _parentNode,
						model = bgModel,
						x = rank1NamePosX - 5,
						y = rank1PosY - (i - 1) * rank1Height,
						w = rank1NameWidth - 6,
						h = rank1Height,
					})
					rightRemoveFrmList[#rightRemoveFrmList+1] = "imageNameBG" .. ranking
					if (i % 2 == 0) then
						_frmNode.childUI["imageNameBG" .. ranking].handle.s:setOpacity(22)
					else
						_frmNode.childUI["imageNameBG" .. ranking].handle.s:setOpacity(36)
					end
					
					--玩家名右边界线竖线
					_frmNode.childUI["imageName_lineR" .. ranking] = hUI.image:new({
						parent = _parentNode,
						model = "UI:vipline", --"ui/pvp/td_mui_blbar.png",
						x = rank1NamePosX + rank1NameWidth / 2 - 8 - 2,
						y = rank1PosY - (i - 1) * rank1Height,
						z = 2,
						w = rank1Height + 2,
						h = 2,
					})
					rightRemoveFrmList[#rightRemoveFrmList+1] = "imageName_lineR" .. ranking
					_frmNode.childUI["imageName_lineR" .. ranking].handle.s:setRotation(90+180)
					
					--玩家名上边界线横线
					_frmNode.childUI["imageName_lineU" .. ranking] = hUI.image:new({
						parent = _parentNode,
						model = "UI:vipline", --"ui/pvp/td_mui_blbar.png",
						x = rank1NamePosX - 4 - 2,
						y = rank1PosY - (i - 1) * rank1Height + rank1Height / 2,
						z = 3,
						w = rank1NameWidth - 6 - 1, --宽
						h = 2,
					})
					rightRemoveFrmList[#rightRemoveFrmList+1] = "imageName_lineU" .. ranking
					_frmNode.childUI["imageName_lineU" .. ranking].handle.s:setRotation(0+180)
					
					--玩家名下边界线横线
					_frmNode.childUI["imageName_lineD" .. ranking] = hUI.image:new({
						parent = _parentNode,
						model = "UI:vipline", --"ui/pvp/td_mui_blbar.png",
						x = rank1NamePosX - 4 - 2,
						y = rank1PosY - (i - 1) * rank1Height - rank1Height / 2,
						z = 3,
						w = rank1NameWidth - 6 - 1, --宽
						h = 2,
					})
					rightRemoveFrmList[#rightRemoveFrmList+1] = "imageName_lineD" .. ranking
					_frmNode.childUI["imageName_lineD" .. ranking].handle.s:setRotation(180+180)
					
					--排名玩家名
					_frmNode.childUI["RankNameLabel" .. ranking] = hUI.label:new({
						parent = _parentNode,
						--x = OFFSET_DX - 98 - 2,
						x = rank1NamePosX - 5,
						y = rank1PosY- (i - 1) * rank1Height - 0, --字体有2像素的偏差
						size = 21,
						font = hVar.FONTC,
						align = "MC",
						width = 300,
						border = 1,
						text = tEndlessNaseList[ranking] or "-",
					})
					rightRemoveFrmList[#rightRemoveFrmList+1] = "RankNameLabel" .. ranking
					_frmNode.childUI["RankNameLabel" .. ranking].handle.s:setColor(paintColor)
					
					--如果当前排名和我的一致，绘制我的排名提示
					if (ranking == myRank) then
						--我的叹号
						--local th_dx = -80
						_frmNode.childUI["RankMeTanHao" .. ranking] = hUI.image:new({
							parent = _parentNode,
							x = rank1PosX + 36,
							y = rank1PosY- (i - 1) * rank1Height - 1,
							model = "UI:TaskTanHao",
							w = 20,
							h = 20,
						})
						rightRemoveFrmList[#rightRemoveFrmList+1] = "RankMeTanHao" .. ranking
						local act1 = CCMoveBy:create(0.2, ccp(0, 3))
						local act2 = CCMoveBy:create(0.2, ccp(0, -3))
						local act3 = CCMoveBy:create(0.2, ccp(0, 3))
						local act4 = CCMoveBy:create(0.2, ccp(0, -3))
						local act5 = CCDelayTime:create(2.0)
						local a = CCArray:create()
						a:addObject(act1)
						a:addObject(act2)
						a:addObject(act3)
						a:addObject(act4)
						a:addObject(act5)
						local sequence = CCSequence:create(a)
						_frmNode.childUI["RankMeTanHao" .. ranking].handle.s:runAction(CCRepeatForever:create(sequence))
					end
				end
			end
		elseif (prizeType == 20033) then --只有标题和正文，没有奖励
			_frmNode.childUI["DLCMapInfoDetailSeparateLine"].handle._n:setVisible(false) --横线
			_frmNode.childUI["DLCMapInfoDetailRewardPrefix"].handle._n:setVisible(false) --奖励文字
			_frmNode.childUI["DLCMapInfoDetailBtn"]:setstate(-1) --领奖按钮
			_frmNode.childUI["DLCMapInfoDetailFinishTag"].handle._n:setVisible(true)
			_frmNode.childUI["DLCMapInfoDetailFinishTag"].handle._n:setVisible(false) --已领奖图标
			
			--发送指令领取奖励
			--不重复领奖
			if (rewardFlag ~= 1) then
				--print("只有标题和正文，没有奖励", "发送指令领取奖励")
				--发送指令领奖
				SendCmdFunc["get_mail_annex"](prizeId, prizeType)
			end
		end
	end
	
	--领取某个邮件奖励
	OnTakeRewardSystemMail = function(selectIdx)
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local tMailI = current_DLCMap_mail_list[selectIdx]
		if (tMailI == nil) then
			return
		end
		
		local prizeId = tMailI.prizeId --邮件id
		local prizeType = tMailI.prizeType --邮件类型
		local prizeContent = tMailI.prizeContent --邮件正文
		local rewardFlag = tMailI.rewardFlag --是否已领取的标记flag
		--print(prizeId, prizeType, prizeContent, rewardFlag)
		
		--不重复领奖
		if (rewardFlag == 1) then
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
		
		--检测背包是否已满
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
		
		--挡操作
		hUI.NetDisable(30000)
		
		--领取邮件奖励
		if (prizeType == 4) then --网页发奖道具
			--发送指令领奖
			SendCmdFunc["get_mail_annex"](prizeId, prizeType)
		elseif (prizeType == 9) then --每日奖励
			--发送指令领奖
			SendCmdFunc["get_mail_annex"](prizeId, prizeType)
		elseif (prizeType == 18) then --评价奖励
			--发送指令领奖
			SendCmdFunc["get_mail_annex"](prizeId, prizeType)
		elseif (prizeType == 100) then --新人礼包
			--发送指令领奖
			SendCmdFunc["get_mail_annex"](prizeId, prizeType)
		elseif (prizeType == 1030) or (prizeType == 1031) or (prizeType == 1032) or (prizeType == 1033) then --首充奖励
			--发送指令领奖
			SendCmdFunc["get_mail_annex"](prizeId, prizeType)
		elseif (prizeType == 1034) then --首充奖励
			--发送指令领奖
			SendCmdFunc["get_mail_annex"](prizeId, prizeType)
		elseif (prizeType == 1035) or (prizeType == 1036) then --首充奖励
			--发送指令领奖
			SendCmdFunc["get_mail_annex"](prizeId, prizeType)
		elseif (prizeType == 1039) or (prizeType == 1060) then --网页发奖积分
			--标记邮件领取状态
			--SendCmdFunc["set_prize_list"](prizeId, luaGetplayerDataID())
			--发送指令领奖
			SendCmdFunc["get_mail_annex"](prizeId, prizeType)
		elseif (prizeType >= 1900) and (prizeType <= 1999) then --分享奖励
			--发送指令领奖
			SendCmdFunc["get_mail_annex"](prizeId, prizeType)
		elseif (prizeType == 20001) then --无尽排名奖励（旧）
			--发送指令领奖
			SendCmdFunc["get_mail_annex"](prizeId, prizeType)
		elseif (prizeType >= 20002) and (prizeType <= 20007) then --推荐奖励
			--发送指令领奖
			SendCmdFunc["get_mail_annex"](prizeId, prizeType)
		elseif (prizeType == 20008) or (prizeType == 20009) then --td发奖邮件
			--发送指令领奖
			SendCmdFunc["get_mail_annex"](prizeId, prizeType)
		elseif (prizeType >= 20010) and (prizeType <= 20020) then --vip一次性奖励
			--发送指令领奖
			SendCmdFunc["get_mail_annex"](prizeId, prizeType)
		elseif (prizeType == 20028) then --服务器抽卡类型
			local tPrizeList = hApi.Split(prizeContent,";")
			for i = 2, #tPrizeList, 1 do
				local rewardT = hApi.Split(tPrizeList[i],":")
				local id = tonumber(rewardT[1]) or 0
				local lv = tonumber(rewardT[2]) or 0
				local num = tonumber(rewardT[3]) or 0
				local param4 = rewardT[4]
				--print(rewardT[1],rewardT[2],rewardT[3],rewardT[4])
				if (id > 0) then
					if (id == 13) then --只处理13(服务器将魂抽卡)类型的奖励
						local cardList = hApi.Split(param4, "|")
						for i = #cardList, 1, -1 do
							if (#cardList[i] == 0) then --防止最后一项是空表
								cardList[i] = nil
							else
								cardList[i] = hApi.Split(cardList[i], "_")
								cardList[i][1] = tonumber(cardList[i][1]) or 0
								cardList[i][2] = tonumber(cardList[i][2]) or 0
								cardList[i][3] = tonumber(cardList[i][3]) or 0
							end
						end
						
						--取消挡操作
						hUI.NetDisable(0)
						
						--创建服务器抽卡界面
						--prizetype, prizeid, 发奖数量, 总长度, 奖励列表
						hGlobal.event:event("localEvent_ShowSelectDebriesCardFrm", prizeType, prizeId, lv, #cardList, cardList)
						--print("创建服务器抽卡界面")
					end
				end
			end
		elseif (prizeType == 20029) then --无尽排名奖励
			--发送指令，领取无尽地图排行奖励
			SendCmdFunc["get_mail_annex_endless"](prizeId, prizeType)
		elseif (prizeType == 20030) then --魔龙宝库勤劳奖
			--发送指令，领取魔龙宝库每日勤劳奖奖励
			SendCmdFunc["get_mail_annex_pvemulty"](prizeId, prizeType)
		elseif (prizeType == 20031) then --带有标题正文的邮件
			--发送指令，领取带有标题正文的邮件奖励
			SendCmdFunc["get_mail_annex_titlemsg"](prizeId, prizeType)
		elseif (prizeType == 20032) then --服务器直接开锦囊
			--发送指令，领取直接开锦囊奖励
			SendCmdFunc["get_mail_annex_openchest"](prizeId, prizeType)
		elseif (prizeType == 20033) then --只有标题和正文，没有奖励
			--发送指令领奖
			SendCmdFunc["get_mail_annex"](prizeId, prizeType)
		elseif (prizeType == 20034) then --夺塔奇兵带有段位、标题和正文的奖励
			--发送指令领奖
			SendCmdFunc["get_mail_annex"](prizeId, prizeType)
		elseif (prizeType == 20035) then --聊天龙王奖
			--发送指令，领取聊天龙王奖奖励
			SendCmdFunc["get_mail_annex_chatdragon"](prizeId, prizeType)
		elseif (prizeType == 20036) then --军团秘境试炼勤劳奖
			--发送指令，领取军团秘境试炼勤劳奖奖励
			SendCmdFunc["get_mail_annex_groupmulty"](prizeId, prizeType)
		elseif (prizeType == 20037) then --军团本周声望排名奖励
			--发送指令，领取带有标题正文的邮件奖励
			SendCmdFunc["get_mail_annex_titlemsg"](prizeId, prizeType)
		elseif (prizeType == 20038) then --军团本周声望第一名奖励
			--发送指令，领取带有标题正文的邮件奖励
			SendCmdFunc["get_mail_annex_titlemsg"](prizeId, prizeType)
		elseif (prizeType == 20039) then --更新维护带有标题和正文的奖励
			--发送指令，领取带有标题正文的邮件奖励
			SendCmdFunc["get_mail_annex_titlemsg"](prizeId, prizeType)
		elseif (prizeType == 20040) then --体力带有标题和正文的奖励
			--发送指令，领取带有标题正文的邮件奖励
			SendCmdFunc["get_mail_annex_titlemsg"](prizeId, prizeType)
		elseif (prizeType == 20041) then --感谢信带有标题和正文的奖励
			--发送指令，领取带有标题正文的邮件奖励
			SendCmdFunc["get_mail_annex_titlemsg"](prizeId, prizeType)
		elseif (prizeType == 20042) then --分享信带有标题和正文的奖励
			--发送指令，领取带有标题正文的邮件奖励
			SendCmdFunc["get_mail_annex_titlemsg"](prizeId, prizeType)
		else
			--取消挡操作
			hUI.NetDisable(0)
			
			--未识别的奖励类型
			--冒字
			local strText = "Unknown Email Type: " .. tostring(prizeType)
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
	
	--一键领取全部邮件奖励
	OnTakeRewardAllSystemMail = function()
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--没有邮件，不需要一键领取
		if (#current_DLCMap_mail_list == 0) then
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
		
		--检测背包是否已满
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
		
		--检测是否有邮件可一键领取
		local totalNum = 0
		local strIdList = ""
		--找到此封邮件
		for i = 1, #current_DLCMap_mail_list, 1 do
			local tMailI = current_DLCMap_mail_list[i]
			local prizeId = tMailI.prizeId --邮件id
			local prizeType = tMailI.prizeType --邮件类型
			local rewardFlag = tMailI.rewardFlag --是否已领取的标记flag
			if (rewardFlag ~= 1) then --未领取的邮件
				if (prizeType ~= 2000) and (prizeType ~= 20028) and (prizeType ~= 20033) then --不是系统邮件，不是抽卡类卡包，不是只有标题和正文没有奖励
					strIdList = strIdList .. tostring(prizeId) .. ":"
					totalNum = totalNum + 1
				end
			end
		end
		if (totalNum > 0) then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_IS_TAKEREWARD_ALLMAIL"],{
				--textOk = "确定", --language
				textOk = hVar.tab_string["Exit_Ack"], --language
				--textCancel = "取消", --language
				textCancel = hVar.tab_string["__TEXT_Cancel"], --language
				ok = function()
					--挡操作
					hUI.NetDisable(30000)
					
					--发送指令，领取全部邮件奖励奖励
					SendCmdFunc["takereward_all_system_mail_prize"](totalNum, strIdList)
				end,
				cancel = function()
					--
				end
			})
		end
	end
	
	--函数：收到系统邮件列表回调
	on_receive_system_mail_list_back = function(mailNum, tMailInfo)
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("收到系统邮件记录回调", mailNum, tMailInfo)
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--初始化参数
		current_DLCMap_max_num = 0 --最大的DLC地图面板id
		current_DLCMap_mail_list = tMailInfo --邮件列表信息表
		current_DLCMap_selectIdx = 0 --当前选中的邮件索引值
		current_async_paint_list = {} --清空异步缓存待绘制内容
		
		--清除中右侧界面
		_removeMiddleFrmFunc()
		_removeRightFrmFunc()
		
		--隐藏上下分页按钮
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false)
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false)
		
		--依次绘制系统邮件记录
		if (mailNum > 0) then
			--依次绘制每条记录
			for i = 1, #tMailInfo, 1 do
				--异步绘制
				on_create_single_system_mail_UI_async(i, tMailInfo[i])
				
				--标记总数量
				current_DLCMap_max_num = current_DLCMap_max_num + 1
			end
			
			--超过一页，显示向下分页按钮
			if (current_DLCMap_max_num > (DLCMAPINFO_X_NUM * DLCMAPINFO_Y_NUM)) then
				_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true)
			end
			
			--检测是否存在有一键领取的邮件
			local bEnableRewardAll = false
			for i = 1, #tMailInfo, 1 do
				local tMailI = tMailInfo[i]
				local prizeId = tMailI.prizeId --邮件id
				local prizeType = tMailI.prizeType --邮件类型
				local rewardFlag = tMailI.rewardFlag --是否已领取的标记flag
				if (rewardFlag ~= 1) then --未领取的邮件
					if (prizeType ~= 2000) and (prizeType ~= 20028) then --不是系统邮件，不是抽卡类卡包
						bEnableRewardAll = true
					end
				end
			end
			
			--显示一键领取按钮
			_frmNode.childUI["DLCMapInfoRewardAllBtn"]:setstate(1)
			if bEnableRewardAll then
				hApi.AddShader(_frmNode.childUI["DLCMapInfoRewardAllBtn"].handle.s, "normal")
			else
				hApi.AddShader(_frmNode.childUI["DLCMapInfoRewardAllBtn"].handle.s, "gray")
			end
			
			--如果只有一封邮件并且此邮件是系统邮件，那么隐藏一键领取按钮
			if (mailNum == 1) and (tMailInfo[1].prizeType == 2000) then
				_frmNode.childUI["DLCMapInfoRewardAllBtn"]:setstate(-1)
			end
			
			--默认显示第1个邮件的详情
			local selectIdx = 1
			OnCreateSystemMailDetailInfo(selectIdx)
		end
		
		--没有邮件显示一行文字
		if (mailNum == 0) then
			--标题-系统邮件(左)
			_frmNode.childUI["DLCMapInfoTitleNone_Left"] = hUI.label:new({
				parent = _parentNode,
				x = DLCMAPINFO_WIDTH / 2 + DLCMAPINFO_WIDTH / 2 + 166,
				y = -DLCMAPINFO_HEIGHT / 2 - 80,
				font = hVar.FONTC,
				size = 26,
				align = "MC",
				text = hVar.tab_string["__TEXT_TemporaryNoneMail"], --"暂无邮件"
				border = 1,
				RGB = {212, 212, 212},
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoTitleNone_Left"
			
			--[[
			--标题-系统邮件(右)
			_frmNode.childUI["DLCMapInfoTitleNone_Right"] = hUI.label:new({
				parent = _parentNode,
				x = DLCMAPINFO_OFFSET_X + DLCMAPINFO_WIDTH / 2 + 236,
				y = -DLCMAPINFO_HEIGHT / 2 - 40,
				font = hVar.FONTC,
				size = 26,
				align = "MC",
				text = hVar.tab_string["__TEXT_TemporaryNoneMailContent"], --"暂无邮件正文"
				border = 1,
				RGB = {212, 212, 212},
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoTitleNone_Right"
			]]
			
			--灰掉一键领取按钮
			hApi.AddShader(_frmNode.childUI["DLCMapInfoRewardAllBtn"].handle.s, "gray")
		end
	end
	
	--函数：收到无尽前10名玩家数据回调
	on_receive_endless_rank_name_back = function(result, rankId, logId, tNameList)
		--print("收到无尽前10名玩家数据回调", result, rankId, logId, tNameList)
		
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--找到此封邮件
		for i = 1, #current_DLCMap_mail_list, 1 do
			local tMailI = current_DLCMap_mail_list[i]
			
			local prizeId = tMailI.prizeId --邮件id
			local prizeType = tMailI.prizeType --邮件类型
			local prizeContent = tMailI.prizeContent --邮件正文
			local rewardFlag = tMailI.rewardFlag --是否已领取的标记flag
			--print("prizeId=", prizeId)
			
			if (prizeType == 20029) then --无尽排名奖励
				--解析无尽排名的参数
				local tPrizeList = hApi.Split(prizeContent,";")
				local title_i = tostring(tPrizeList[1]) --标题
				local strDate_i = tostring(tPrizeList[2]) --日期
				local rankId_i = tonumber(tPrizeList[3]) or 0 --排行榜id
				local myRank_i = tonumber(tPrizeList[4]) or 0 --我的排名
				local logId_i = tonumber(tPrizeList[5]) or 0 --日志id
				
				if (rankId == rankId_i) and (logId == logId_i) then --找到了
					--存储数据
					tMailI.tEndlessNaseList = tNameList
					
					--更新右侧界面（当前查看的是本邮件）
					if (current_DLCMap_selectIdx == i) then
						current_DLCMap_selectIdx = 0
						OnCreateSystemMailDetailInfo(i)
					end
					
					break
				end
			end
		end
	end
	
	--函数：领取邮件成功回调
	on_takereward_system_mail_success_back = function(prizeId)
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("领取邮件成功回调", prizeId)
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--标记本地邮件领取状态
		local selectIdx = 0
		for i = 1, #current_DLCMap_mail_list, 1 do
			local tMailI = current_DLCMap_mail_list[i]
			if (prizeId == tMailI.prizeId) then --找到了
				selectIdx = i
				tMailI.rewardFlag = 1 --是否已领取的标记flag
				break
			end
		end
		
		--更新左侧界面
		local ctrlI = _frmNode.childUI["DLCMapInfoNode" .. selectIdx]
		if ctrlI then
			--已领取的tag
			if ctrlI.childUI["finishTag"] then
				ctrlI.childUI["finishTag"].handle._n:setVisible(true)
			end
			
			--隐藏剩余领取时间
			if ctrlI.childUI["lefttime"] then
				ctrlI.childUI["lefttime"]:setText("")
			end
		end
		
		--更新右侧界面（当前查看的是本邮件）
		if (current_DLCMap_selectIdx == selectIdx) then
			if _frmNode.childUI["DLCMapInfoDetailBtn"] then
				_frmNode.childUI["DLCMapInfoDetailBtn"]:setstate(-1)
			end
			if _frmNode.childUI["DLCMapInfoDetailFinishTag"] then
				_frmNode.childUI["DLCMapInfoDetailFinishTag"].handle._n:setVisible(true)
			end
			if _frmNode.childUI["DLCMapInfoDetailLeftTime"] then
				_frmNode.childUI["DLCMapInfoDetailLeftTime"]:setText("")
			end
		end
		
		--检测是否存在有一键领取的邮件
		local bEnableRewardAll = false
		for i = 1, #current_DLCMap_mail_list, 1 do
			local tMailI = current_DLCMap_mail_list[i]
			local prizeId = tMailI.prizeId --邮件id
			local prizeType = tMailI.prizeType --邮件类型
			local rewardFlag = tMailI.rewardFlag --是否已领取的标记flag
			if (rewardFlag ~= 1) then --未领取的邮件
				if (prizeType ~= 2000) and (prizeType ~= 20028) then --不是系统邮件，不是抽卡类卡包
					bEnableRewardAll = true
				end
			end
		end
		
		--显示一键领取按钮
		--_frmNode.childUI["DLCMapInfoRewardAllBtn"]:setstate(1)
		if bEnableRewardAll then
			hApi.AddShader(_frmNode.childUI["DLCMapInfoRewardAllBtn"].handle.s, "normal")
		else
			hApi.AddShader(_frmNode.childUI["DLCMapInfoRewardAllBtn"].handle.s, "gray")
		end
	end
	
	--函数：收到一键领取全部邮件成功回调
	on_takereward_all_system_mail_success_back = function(mailRewardNum, tPrizeIdList)
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("收到一键领取全部邮件成功回调", mailRewardNum, tPrizeIdList)
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--标记本地邮件领取状态
		if (mailRewardNum > 0) then
			for m = 1, mailRewardNum, 1 do
				--邮件奖励id
				local prizeId = tPrizeIdList[m]
				
				local selectIdx = 0
				for i = 1, #current_DLCMap_mail_list, 1 do
					local tMailI = current_DLCMap_mail_list[i]
					if (prizeId == tMailI.prizeId) then --找到了
						selectIdx = i
						tMailI.rewardFlag = 1 --是否已领取的标记flag
						break
					end
				end
				
				--更新左侧界面（一键领取）
				local ctrlI = _frmNode.childUI["DLCMapInfoNode" .. selectIdx]
				if ctrlI then
					--已领取的tag
					if ctrlI.childUI["finishTag"] then
						ctrlI.childUI["finishTag"].handle._n:setVisible(true)
					end
					
					--隐藏剩余领取时间
					if ctrlI.childUI["lefttime"] then
						ctrlI.childUI["lefttime"]:setText("")
					end
				end
				
				--更新右侧界面（当前查看的是本邮件）
				if (current_DLCMap_selectIdx == selectIdx) then
					if _frmNode.childUI["DLCMapInfoDetailBtn"] then
						_frmNode.childUI["DLCMapInfoDetailBtn"]:setstate(-1)
					end
					if _frmNode.childUI["DLCMapInfoDetailFinishTag"] then
						_frmNode.childUI["DLCMapInfoDetailFinishTag"].handle._n:setVisible(true)
					end
					if _frmNode.childUI["DLCMapInfoDetailLeftTime"] then
						_frmNode.childUI["DLCMapInfoDetailLeftTime"]:setText("")
					end
				end
			end
		end
		
		--灰掉一键领取按钮
		hApi.AddShader(_frmNode.childUI["DLCMapInfoRewardAllBtn"].handle.s, "gray")
	end
	
	--函数：横竖屏切换
	on_spine_screen_event = function()
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--关闭本界面
		OnClosePanel()
		
		--重绘本界面
		hGlobal.UI.InitSystemMailInfoFrm("reload") --测试
		--触发事件，显示系统邮件界面
		hGlobal.event:event("LocalEvent_Phone_ShowSystemMailInfoFrm", current_funcCallback)
	end
	
	--函数：刷新系统邮件剩余领取时间倒计时timer
	refresh_systemmail_lelefttime_timer = function()
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--依次遍历控件
		for i = 1, current_DLCMap_max_num, 1 do
			local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
			if ctrli then
				local tMailI = current_DLCMap_mail_list[i]
				if (tMailI ~= nil) then
					local prizeId = tMailI.prizeId --邮件id
					local prizeType = tMailI.prizeType --邮件类型
					local prizeContent = tMailI.prizeContent --邮件正文
					local prizeSeconds = tMailI.prizeSeconds --邮件剩余领取时间（单位：秒）
					local rewardFlag = tMailI.rewardFlag --是否已领取的标记flag
					--print(i, prizeId, prizeType, prizeContent, prizeSeconds, rewardFlag)
					--不重复领奖
					if (rewardFlag ~= 1) then
						--有剩余领取时间
						if (prizeSeconds >= 0) then
							local ctrlLeftTime = ctrli.childUI["lefttime"]
							if ctrlLeftTime then
								--计算剩余领取时间
								local day = math.floor(prizeSeconds / 3600 / 24) --时
								local hour = math.floor((prizeSeconds - day * 24 * 3600) / 3600) --时
								local minute = math.floor((prizeSeconds - day * 24 * 3600 - hour * 3600)/ 60) --分
								local second = prizeSeconds - hour * 3600 - minute * 60 --秒
								
								--拼接字符串
								local szDay = tostring(day) --天(字符串)
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
								--geyachao: 左边不显示倒计时了
								--[[
								if (prizeSeconds == 0) then
									ctrlLeftTime:setText(hVar.tab_string["SystemMail_Expired"]) --"邮件即将过期，请尽快领取！"
								else
									if (day > 0) then
										ctrlLeftTime:setText(hVar.tab_string["__TEXT_RewardLeftTime"] .. ": " .. szDay .. hVar.tab_string["__TEXT_Dat"] .. szHour .. hVar.tab_string["__TEXT_Hour_Short"] .. szMinute .. hVar.tab_string["__Minute"]) --"剩余领取时间: XX天XX时XX分"
									else
										ctrlLeftTime:setText(hVar.tab_string["__TEXT_RewardLeftTime"] .. ": " .. szHour .. hVar.tab_string["__TEXT_Hour_Short"] .. szMinute .. hVar.tab_string["__Minute"] .. szSecond .. hVar.tab_string["__Second"]) --"剩余领取时间: XX时XX分XX秒"
									end
								end
								]]
							end
							
							--每进来一次，时间减1
							tMailI.prizeSeconds = tMailI.prizeSeconds - 1
							if (tMailI.prizeSeconds < 0) then
								tMailI.prizeSeconds = 0
							end
						end
					end
				end
			end
		end
		
		--更新当前邮件正文的倒计时
		local selectIdx = current_DLCMap_selectIdx
		if (selectIdx > 0) then
			local tMailI = current_DLCMap_mail_list[selectIdx]
			if (tMailI ~= nil) then
				local prizeId = tMailI.prizeId --邮件id
				local prizeType = tMailI.prizeType --邮件类型
				local prizeContent = tMailI.prizeContent --邮件正文
				local prizeSeconds = tMailI.prizeSeconds --邮件剩余领取时间（单位：秒）
				local rewardFlag = tMailI.rewardFlag --是否已领取的标记flag
				--print(i, prizeId, prizeType, prizeContent, prizeSeconds, rewardFlag)
				--不重复领奖
				if (rewardFlag ~= 1) then
					--有剩余领取时间
					if (prizeSeconds >= 0) then
						--计算剩余领取时间
						local day = math.floor(prizeSeconds / 3600 / 24) --时
						local hour = math.floor((prizeSeconds - day * 24 * 3600) / 3600) --时
						local minute = math.floor((prizeSeconds - day * 24 * 3600 - hour * 3600)/ 60) --分
						local second = prizeSeconds - hour * 3600 - minute * 60 --秒
						
						--拼接字符串
						local szDay = tostring(day) --天(字符串)
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
						if (prizeSeconds == 0) then
							if _frmNode.childUI["DLCMapInfoDetailLeftTime"] then
								_frmNode.childUI["DLCMapInfoDetailLeftTime"]:setText(hVar.tab_string["SystemMail_Expired"]) --"邮件即将过期，请尽快领取！"
								_frmNode.childUI["DLCMapInfoDetailLeftTime"].handle.s:setColor(ccc3(255, 0, 0))
							end
						else
							if (day > 0) then
								if _frmNode.childUI["DLCMapInfoDetailLeftTime"] then
									_frmNode.childUI["DLCMapInfoDetailLeftTime"]:setText(szDay .. hVar.tab_string["__TEXT_Dat"] .. hVar.tab_string["__TEXT_RewardLeftTime"]) --"剩余领取时间: XX天XX时XX分"
									_frmNode.childUI["DLCMapInfoDetailLeftTime"].handle.s:setColor(ccc3(0, 255, 0))
								end
							elseif (hour > 0) then
								if _frmNode.childUI["DLCMapInfoDetailLeftTime"] then
									_frmNode.childUI["DLCMapInfoDetailLeftTime"]:setText(szHour .. hVar.tab_string["__TEXT_Hour_Short"].. szMinute .. hVar.tab_string["__Minute"] .. hVar.tab_string["__TEXT_RewardLeftTime"]) --"剩余领取时间: XX时XX分XX秒"
									_frmNode.childUI["DLCMapInfoDetailLeftTime"].handle.s:setColor(ccc3(255, 0, 0))
								end
							else
								if _frmNode.childUI["DLCMapInfoDetailLeftTime"] then
									_frmNode.childUI["DLCMapInfoDetailLeftTime"]:setText(szMinute .. hVar.tab_string["__Minute"] .. szSecond .. hVar.tab_string["__Second"] .. hVar.tab_string["__TEXT_RewardLeftTime"]) --"剩余领取时间: XX时XX分XX秒"
									_frmNode.childUI["DLCMapInfoDetailLeftTime"].handle.s:setColor(ccc3(255, 0, 0))
								end
							end
						end
					else
						if _frmNode.childUI["DLCMapInfoDetailLeftTime"] then
							_frmNode.childUI["DLCMapInfoDetailLeftTime"]:setText(hVar.tab_string["SystemMail_Expired"]) --"邮件即将过期，请尽快领取！"
						end
					end
					
					--系统邮件不显示文字
					if (prizeType == 2000) then --系统邮件
						if _frmNode.childUI["DLCMapInfoDetailLeftTime"] then
							_frmNode.childUI["DLCMapInfoDetailLeftTime"]:setText("")
						end
					end
				else
					if _frmNode.childUI["DLCMapInfoDetailLeftTime"] then
						_frmNode.childUI["DLCMapInfoDetailLeftTime"]:setText("")
					end
				end
			else
				if _frmNode.childUI["DLCMapInfoDetailLeftTime"] then
					_frmNode.childUI["DLCMapInfoDetailLeftTime"]:setText("")
				end
			end
		else
			if _frmNode.childUI["DLCMapInfoDetailLeftTime"] then
				_frmNode.childUI["DLCMapInfoDetailLeftTime"]:setText("")
			end
		end
	end
	
	--函数：异步绘制系统邮件记录条目的timer
	refresh_async_paint_system_mail_list_loop = function()
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
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
				local tMailI = current_async_paint_list[pivot]
				local index = tMailI.index
				
				--先删除虚控件
				hApi.safeRemoveT(_frmNode.childUI, "DLCMapInfoNode" .. index)
				
				--再创建实体控件
				on_create_single_system_mail_UI(index, tMailI)
				
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
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
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
				
				--print("delta1_ly=" .. delta1_ly, ", deltNa_rx=" .. deltNa_rx)
				
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
	
	--函数：刷新私聊好友界面滚动的timer
	refresh_chatframe_scroll_reward_loop = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
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
				for i = 1, current_DLCMap_reward_max_num, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNodeReward" .. i]
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
				_frmNode.childUI["DLCMapInfoPageLeft"].handle.s:setVisible(false) --上翻页提示
				_frmNode.childUI["DLCMapInfoPageRight"].handle.s:setVisible(true) --下翻页提示
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
				for i = 1, current_DLCMap_reward_max_num, 1 do
				local ctrli = _frmNode.childUI["DLCMapInfoNodeReward" .. i]
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
				_frmNode.childUI["DLCMapInfoPageLeft"].handle.s:setVisible(true) --上分翻页提示
				_frmNode.childUI["DLCMapInfoPageRight"].handle.s:setVisible(false) --下分翻页不提示
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
					for i = 1, current_DLCMap_reward_max_num, 1 do
						local ctrli = _frmNode.childUI["DLCMapInfoNodeReward" .. i]
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
					for i = 1, current_DLCMap_reward_max_num, 1 do
						local ctrli = _frmNode.childUI["DLCMapInfoNodeReward" .. i]
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
					_frmNode.childUI["DLCMapInfoPageLeft"].handle.s:setVisible(false) --上分翻页提示
				else
					_frmNode.childUI["DLCMapInfoPageLeft"].handle.s:setVisible(true) --上分翻页提示
				end
				if (deltNa_rx == 0) then
					_frmNode.childUI["DLCMapInfoPageRight"].handle.s:setVisible(false) --下分翻页提示
					--已拉到底，删除新消息提示
					--onRemoveNewMessageHint()
				else
					_frmNode.childUI["DLCMapInfoPageRight"].handle.s:setVisible(true) --下分翻页提示
				end
			else --停止运动
				b_need_auto_fixing_friendinfo = false
				friction_friendinfo = 0
				friction_friendinfo_coefficient = 0.5 --衰减系数(默认值)
			end
		end
	end
	
	--函数: 动态加载资源
	__DynamicAddRes = function()
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		--print("函数: 动态加载资源")
		
		--加载资源
		--动态加载宝物背景图
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/task/mail_panel.png")
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/task/mail_panel.png")
			print("加载邮件背景大图！")
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
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--删除资源
		--删除竞技场背景图
		_childUI["panel_bg"].handle._n:removeChild(_childUI["panel_bg"].data.pSprite, true)
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/task/mail_panel.png")
		if texture then
			CCTextureCache:sharedTextureCache():removeTexture(texture)
			print("清空邮件背景大图！")
		end
	end
	
	--函数：更新提示当前哪个分页可以有领取的了
	RefreshTaskAchievementFinishPage = function()
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
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
end

--监听关闭宝箱界面事件
hGlobal.event:listen("clearPhoneChestFrm", "__CloseSystemMailFrm", function()
	if hGlobal.UI.PhoneSystemMailInfoFrm then
		if (hGlobal.UI.PhoneSystemMailInfoFrm.data.show == 1) then
			--关闭本界面
			OnClosePanel()
		end
	end
end)

--监听打开游戏币变化界面通知事件
hGlobal.event:listen("LocalEvent_Phone_ShowSystemMailInfoFrm", "__ShowSystemMailFrm", function(callback, bOpenImmediate)
	hGlobal.UI.InitSystemMailInfoFrm("reload")
	
	--直接打开
	if bOpenImmediate then
		--触发事件，显示积分、金币界面
		--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
		
		--显示游戏币变化界面
		hGlobal.UI.PhoneSystemMailInfoFrm:show(1)
		hGlobal.UI.PhoneSystemMailInfoFrm:active()
		
		--存储回调事件
		current_funcCallback = callback
		
		--打开上一次的分页（默认显示第1个分页:DLC地图面板）
		local lastPageIdx = CurrentSelectRecord.pageIdx
		if (lastPageIdx == 0) then
			lastPageIdx = 1
		end
		
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
			--触发事件，显示积分、金币界面
			--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
			
			--显示游戏币变化界面
			hGlobal.UI.PhoneSystemMailInfoFrm:show(1)
			hGlobal.UI.PhoneSystemMailInfoFrm:active()
			
			--存储回调事件
			current_funcCallback = callback
			
			--打开上一次的分页（默认显示第1个分页:DLC地图面板）
			local lastPageIdx = CurrentSelectRecord.pageIdx
			if (lastPageIdx == 0) then
				lastPageIdx = 1
			end
			
			CurrentSelectRecord.pageIdx = 0
			CurrentSelectRecord.contentIdx = 0
			OnClickPageBtn(lastPageIdx)
			
			--更新提示当前哪个分页可以有领取的了
			RefreshTaskAchievementFinishPage()
			
			--初始设置坐标
			--主面板设置到左侧屏幕外面
			local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
			local dx = BOARD_WIDTH
			_frm:setXY(_frm.data.x + dx, _frm.data.y)
		end)
		
		--步骤2: 动画进入控件
		local actM2 = CCCallFunc:create(function()
			--本面板
			local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
			
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
		local _frm = hGlobal.UI.PhoneSystemMailInfoFrm
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
if hGlobal.UI.PhoneSystemMailInfoFrm then --删除上一次的邮件界面
	hGlobal.UI.PhoneSystemMailInfoFrm:del()
	hGlobal.UI.PhoneSystemMailInfoFrm = nil
end
hGlobal.UI.InitSystemMailInfoFrm("reload") --测试创建邮件界面
hGlobal.event:event("LocalEvent_Phone_ShowSystemMailInfoFrm")
]]


