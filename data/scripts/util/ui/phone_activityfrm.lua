

local BOARD_WIDTH = 720 --DLC地图面板面板的宽度
local BOARD_HEIGHT = 720 --DLC地图面板面板的高度
local BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 0
local BOARD_OFFSETY = 0 --DLC地图面板面板y偏移中心点的值
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
local _removMiddleFrmFunc = hApi.DoNothing --清空中侧所有的临时控件
local _removeRightFrmFunc = hApi.DoNothing --清空右侧所有的临时控件

--局部函数
local OnClickPageBtn = hApi.DoNothing --点击分页按钮
local RefreshSelectedCardFrame = hApi.DoNothing --更新绘制当前查看的卡牌的信息

--分页1：显示DLC地图界面
local OnCreateDLCMapInfoFrame = hApi.DoNothing --创建DLC地图界面（第1个分页）
--local OnCreateDLCMapInfoFrame_LeftPart = hApi.DoNothing --绘制左侧DLC地图包列表界面
--local OnCreateDLCMapInfoFrame_RightPart = hApi.DoNothing --显示某个DLC地图包的详细信息
--local OnRefresnDLCMapInfoFrame_LeftPart = hApi.DoNothing --刷新左侧DLC地图包列表界面
local refresh_dlcmapinfo_UI_loop = hApi.DoNothing --刷新DLC地图面板界面的滚动
--local on_receive_DLCMapInfo_Back = hApi.DoNothing --收到购买DLC地图包的回调事件
--local on_close_MapInfo_Panel = hApi.DoNothing --关闭某一关的地图信息的回调事件
--local OnClickUnlockMapButton = hApi.DoNothing --点击购买DLC地图包按钮
local getUpDownOffset = hApi.DoNothing --获得第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离
local __DynamicAddRes = hApi.DoNothing --动态加载资源
local __DynamicRemoveRes = hApi.DoNothing --动态删除资源
local OnClosePanel = hApi.DoNothing --关闭本界面
local on_receive_activity_info_event = hApi.DoNothing --收到获得活动信息的回调
local OnCreateActivityTipFrame = hApi.DoNothing --显示指定的活动的详细信息tip面板
local on_receive_activity_progress_event = hApi.DoNothing --收到活动进度事件
local on_spine_screen_event = hApi.DoNothing --横竖屏切换
local RefreshTaskAchievementFinishPage = hApi.DoNothing --更新提示当前哪个分页可以有领取的了

--分页1：DLC地图包的参数
local DLCMAPINFO_WIDTH = 200 --DLC地图包宽度
local DLCMAPINFO_HEIGHT = 78 --DLC地图包高度
local DLCMAPINFO_OFFSET_X = 120 --DLC地图包统一偏移x
local DLCMAPINFO_OFFSET_Y = -100 --DLC地图包统一偏移y
--local DLCMAPINFO_BOARD_HEIGHT = 570 --DLC地图包高度
local DLCMAPINFO_X_NUM = 1 --DLC地图面板x的数量
local DLCMAPINFO_Y_NUM = 7 --DLC地图面板y的数量
local MAX_SPEED = 50 --最大速度
local _bCanCreate = true --防止重复创建
local current_selectedIdx = 0
local current_funcCallback = nil --关闭后的回调事件

--可变参数
local current_DLCMap_max_num = 0 --最大的DLC地图包数量

local current_ActivityList = {} --活动列表

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

--活动（新）面板
hGlobal.UI.InitActivityNewFrm = function(mode)
	local tInitEventName = {"LocalEvent_Phone_ShowActivityNewFrm", "__ShowActivityNewFrm",}
	if (mode ~= "reload") then
		--return tInitEventName
		return
	end
	
	--不重复创建活动（新）面板
	if hGlobal.UI.PhoneActivityNewFrm then --活动（新）面板
		hGlobal.UI.PhoneActivityNewFrm:del()
		hGlobal.UI.PhoneActivityNewFrm = nil
	end
	
	--[[
	--取消监听打开活动（新）界面通知事件
	hGlobal.event:listen("LocalEvent_Phone_ShowActivityNewFrm", "__ShowActivityNewFrm", nil)
	--取消监听关闭宝箱界面事件
	hGlobal.event:listen("clearPhoneChestFrm", "__CloseActivityFrm", nil)
	]]
	
	BOARD_WIDTH = 720 --DLC地图面板面板的宽度
	BOARD_HEIGHT = 720 --DLC地图面板面板的高度
	BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 0
	BOARD_OFFSETY = 0 --DLC地图面板面板y偏移中心点的值
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
	
	local ACTIVITY_TYPE_ICON = --充值类型的图标
	{
		--[0] = {"UI:phb", 70, 64}, --纯文字类(特殊活动，只能手动发奖)
		[0] =
		{
			default = {"UI:horn_open", 64, 64,},
			zOrder = 0, --z值，越大越靠前显示
			{key = "微信", icon = {"UI:WEIXIN", 52, 52},},
			{key = "月卡", icon = {"UI:MONTHCARD_ICON", 62, 62},},
			{key = "无尽", icon = {"UI:phb", 70, 64},},
			{key = "年兽", icon = {"ICON:Border_red_item", 56, 56}, subIcon = {"ICON:Item_Horse19", 0, 0, 48, 45,},},
			{key = "红包", icon = {"misc/chest/redpacket.png", 54, 54}, subIcon = {"misc/chest/purchase_border.png", 0, 0, 56, 56,},},
			{key = "群英阁", icon = {"UI:QUNYINGGE", 64, 64},},
		},
		[2] = {"misc/task/activity_icon_02.png", 60, 50, zOrder = 93,}, --累计消耗金币
		[3] = {"misc/task/activity_icon_01.png", 60, 50, zOrder = 99,}, --登陆1天送xx，登陆2天送xx...
		[4] = {"", 64, 64}, --好友推荐的活动
		[98] = {"UI:Purchase_3", 76, 76, zOrder = 97,}, --充值任意金额，就送xx
		[99] = {"UI:Purchase_4", 76, 76, zOrder = 96,}, --按档位充值xx次，如充值98元档1次
		[100] = {"UI:Purchase_5", 40, 40, zOrder = 65,}, --累计充值金币
		[101] = {"UI:Purchase_6", 76, 76, zOrder = 95,}, --充值暴击
		[300] = {"UI:JJC", 64, 56,}, --显示夺塔奇兵娱乐房开放时间（仅用于界面显示，不发奖）
		[301] = {"UI:JJC", 64, 56,}, --显示夺塔奇兵按钮开放时间（仅用于界面显示，不发奖）
		[10001] = {"UI:JJC", 64, 56, zOrder = 90,}, --夺塔奇兵所有正常局
		[10002] = {"UI:JJC", 64, 56, zOrder = 89,}, --夺塔奇兵所有胜局
		[10003] = {"UI:JJC", 64, 56, zOrder = 88,}, --夺塔奇兵电脑正常局
		[10004] = {"UI:JJC", 64, 56, zOrder = 87,}, --夺塔奇兵对人正常局
		[10005] = {"UI:JJC", 64, 56, zOrder = 86,}, --夺塔奇兵对人胜局
		[10006] = {"UI:JJC", 64, 56, zOrder = 85,}, --夺塔奇兵对困难电脑胜局
		[10007] = {"UI:ZHANGONG_SCORE", 64, 64, zOrder = 84,}, --夺塔奇兵获得的星数
		[10008] = {"ui/chest_4.png", 64, 64, zOrder = 83,}, --夺塔奇兵开启锦囊数量（新人特别奖）
		[10009] = {"ui/chest_1.png", 68, 68, zOrder = 82,}, --夺塔奇兵锦囊掉率翻倍
		[10010] = {"UI:PVP_ONLY", 64, 64, zOrder = 81,}, --夺塔奇兵匹配房所有正常局
		[10011] = {"UI:PVP_ONLY", 64, 64, zOrder = 80,}, --夺塔奇兵匹配房每日正常局
		[10012] = {"ui/icon_mlbk.png", 56, 64, zOrder = 79,}, --魔龙宝库正常局胜利
		[10013] = {"ui/icon_tqt.png", 56, 56, zOrder = 78,}, --铜雀台正常局胜利
		[10014] = {"icon/item/item_treasure01.png", 56, 56, zOrder = 77,}, --军团宝库正常局胜利
		[10020] = {"ui/xf.png", 52, 52, zOrder = 101,}, --仅苹果玩家可见的文字展示类活动
		[10021] = {"ui/taptap.png", 52, 52, zOrder = 100,}, --仅安卓玩家可见的文字展示类活动
		[10022] = {"ui/signin.png", 64, 60, zOrder = 103,}, --新玩家14日签到活动
		[10023] = {"UI:JJC", 64, 56,}, --显示1元档活动开放标记（仅用于标记，不发奖）
		[10024] = {"ui/zhuanpan.png", 54, 54, zOrder = 91,}, --消费转盘活动
		[10025] = {"ui/task_gold_icon.png", 60, 59, zOrder = 94,}, --连续七天充值活动
		[10026] = {"misc/task/activity_icon_03.png", 60, 50, zOrder = 104,}, --taptap留言活动
		[10027] = {"misc/chest/redpacket.png", 54, 54, zOrder = 76, subIcon = {"misc/chest/purchase_border.png", 0, 0, 56, 56,},}, --军团连续活跃活动
		[10028] = {"UI:RZWD", 64, 64, zOrder = 73}, --人族无敌游戏局
		[10029] = {"UI:SWJG", 62, 62, zOrder = 72}, --守卫剑阁游戏局
		[10030] = {"misc/chest/box_gold_2_n.png", 64, 64, zOrder = 92}, --消费抽奖活动
		[10031] = {"UI:SWJG2", 62, 62, zOrder = 71}, --双人守卫剑阁游戏局
		[10032] = {"UI:BTN_LIBAO_12YUAN", 64, 64, zOrder = 102}, --新用户任意充值活动
		[10033] = {"UI:QUNYINGGE", 64, 64, zOrder = 74,}, --群英阁正常局胜利
		[10034] = {"UI:MOTA", 62, 62, zOrder = 75,}, --魔塔杀阵正常局胜利
		
		[20001] = {"misc/task/randommap_space_lift.png", 39, 39, zOrder = 67,}, --随机迷宫层数
		[20002] = {"misc/task/task_003.png", 39, 39, zOrder = 66,}, --前哨阵地波次
		[20003] = {"icon/item/towergun_1.png", 58, 58, zOrder = 69,}, --解锁武器枪次数
		[20004] = {"icon/item/pet_01.png", 39, 39, zOrder = 68,}, --解锁宠物次数
		[20005] = {"misc/addition/star_light2.png", 36, 36, zOrder = 70,}, --总星星
	}
	
	--加载资源
	--xlLoadResourceFromPList("data/image/misc/pvp.plist")
	
	hApi.clearTimer("__ACTIVITY_NEW_UPDATE__")
	
	--创建活动（新）面板
	hGlobal.UI.PhoneActivityNewFrm = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 2,
		show = 0, --一开始不显示
		border = 0, --显示frame边框
		background = -1, --"panel/panel_part_00.png", --"UI:Tactic_Background",
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
	
	local _frm = hGlobal.UI.PhoneActivityNewFrm
	local _parent = _frm.handle._n
	
	--左侧裁剪区域
	local _BTC_PageClippingRect = {0, -54, 240, 580, 0,} -- {x, y, w, h, show}
	local _BTC_pClipNode_Activity = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect, 99, _BTC_PageClippingRect[5], "_BTC_pClipNode_Activity")
	
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
	local closeDx = -4
	local closeDy = -8
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		model = "BTN:PANEL_CLOSE",
		x = _frm.data.w + closeDx + 1000,
		y = closeDy,
		scaleT = 0.95,
		code = function()
			--关闭本界面
			OnClosePanel()
			
			hGlobal.event:event("LocalEvent_RecoverBarrage")
			
			--触发事件：刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
			hGlobal.event:event("LocalEvent_RefreshMedalStateUI")
			
			_bCanCreate = false
			
			--回调事件
			if (type(current_funcCallback) == "function") then
				current_funcCallback()
			end
		end,
	})
	
	--每个分页按钮
	--DLC地图面板
	local tPageIcons = {"UI:ach_king",}
	--local tTexts = {"地图包",} --language
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
		local _frm = hGlobal.UI.PhoneActivityNewFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页中侧的UI
	_removeMiddleFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneActivityNewFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#middleRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, middleRemoveFrmList[i]) 
		end
		middleRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneActivityNewFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#rightRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, rightRemoveFrmList[i]) 
		end
		rightRemoveFrmList = {}
	end
	
	--函数：关闭本界面
	OnClosePanel = function()
		local _frm = hGlobal.UI.PhoneActivityNewFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--不显示活动（新）面板
		hGlobal.UI.PhoneActivityNewFrm:show(0)
		
		--关闭界面后不需要监听的事件
		--取消监听：
		--...
		
		--清空切换分页之后取消的监听事件
		--移除事件监听：购买DLC地图包成功事件（恢复存档也会走进来）
		--hGlobal.event:listen("LocalEvent_Phone_ShowActivityNewFrm_Back", "__PhoneRefreshMapInfoFrm", nil)
		--移除事件监听：关闭查看某一关介绍的面板
		--hGlobal.event:listen("LocalEvent_Phone_HideMapInfoFrm", "__PhoneCloseMapInfoFrm", nil)
		--移除事事件监听：收到获得活动信息的回调
		hGlobal.event:listen("localEvent_UpdateActivityInfo", "__OnReceiveActivityInfo", nil)
		--移除事件监听：收到活动进度事件
		hGlobal.event:listen("localEvent_UpdateActivityReward", "_UpdateActivityReward", nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenActivity_", nil)
		
		--清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeMiddleFrmFunc()
		_removeRightFrmFunc()
		
		--清除参数
		current_selectedIdx = 0
		
		--删除DLC界面下拉滚动timer
		hApi.clearTimer("__ACTIVITY_NEW_UPDATE__")
		
		--隐藏所有的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Activity", 0)
		
		--关闭金币、积分界面
		--hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
		
		--动态删除宝物背景大图
		__DynamicRemoveRes()
		
		--触发事件：关闭了主菜单按钮
		--hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
		
		--释放png, plist的纹理缓存（这里不清理也可以）
		--hApi.ReleasePngTextureCache()
		
		--允许再次打开
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
		--移除事件监听：购买DLC地图包成功事件（恢复存档也会走进来）
		--hGlobal.event:listen("LocalEvent_Phone_ShowActivityNewFrm_Back", "__PhoneRefreshMapInfoFrm", nil)
		--移除事件监听：关闭查看某一关介绍的面板
		--hGlobal.event:listen("LocalEvent_Phone_HideMapInfoFrm", "__PhoneCloseMapInfoFrm", nil)
		--移除事事件监听：收到获得活动信息的回调
		hGlobal.event:listen("localEvent_UpdateActivityInfo", "__OnReceiveActivityInfo", nil)
		--移除事件监听：收到活动进度事件
		hGlobal.event:listen("localEvent_UpdateActivityReward", "_UpdateActivityReward", nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenActivity_", nil)
		
		--移除timer
		hApi.clearTimer("__ACTIVITY_NEW_UPDATE__")
		
		--隐藏所有的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Activity", 0)
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：活动（新）
			--创建活动（新）分页
			OnCreateDLCMapInfoFrame(pageIndex)
		end
		
		--标记当前选择的分页和页内的第几个
		CurrentSelectRecord.pageIdx = pageIndex
		CurrentSelectRecord.contentIdx = 1 --默认选中第一个
	end
	
	--函数：创建活动（新）界面（第1个分页）
	OnCreateDLCMapInfoFrame = function(pageIdx)
		local _frm = hGlobal.UI.PhoneActivityNewFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--动态加载任务背景大图
		__DynamicAddRes()
		
		--允许本分页的的clipNode
		hApi.EnableClipByName(_frm, "_BTC_pClipNode_Activity", 1)
		
		--初始化参数
		current_DLCMap_max_num = 0 --最大的DLC地图面板id
		current_selectedIdx = 0
		
		--local i = 3
		
		--左侧裁剪区域
		--local _BTC_PageClippingRect = {0, -82, 1000, 408, 0}
		--local _BTC_pClipNode_Activity = hApi.CreateClippingNode(_parentNode, _BTC_PageClippingRect, 99, _BTC_PageClippingRect[5])
		
		--[[
		--副标题
		_frmNode.childUI["DLCMapInfoPageUp"] = hUI.label:new({
			parent = _parentNode,
			size = 28,
			x = DLCMAPINFO_OFFSET_X + 540,
			y = DLCMAPINFO_OFFSET_Y - 50-10,
			width = 800,
			align = "MC",
			font = hVar.FONTC,
			--text = "包含内容", --language
			text = hVar.tab_string["__TEXT_ContainContent"], --language
			border = 1,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageUp"
		]]
		
		--左侧DLC地图包列表提示上翻页的图片
		_frmNode.childUI["DLCMapInfoPageUp"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/skillup/arrow_down.png",
			x = DLCMAPINFO_OFFSET_X + 0,
			y = DLCMAPINFO_OFFSET_Y + 70,
			scale = 1.0,
			z = 500, --最前端显示
		})
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setRotation(180)
		--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setOpacity(212) --提示上翻页默认透明度为212
		_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --默认不显示左上翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageUp"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["DLCMapInfoPageUp"].handle._n:runAction(forever)
		
		--左侧DLC地图包列表提示下翻页的图片
		_frmNode.childUI["DLCMapInfoPageDown"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/skillup/arrow_down.png",
			x = DLCMAPINFO_OFFSET_X + 0 + 7, --非对称的翻页图
			y = DLCMAPINFO_OFFSET_Y - 570,
			scale = 1.0,
			z = 500, --最前端显示
		})
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setRotation(0)
		--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setOpacity(212) --提示下翻页默认透明度为212
		_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --默认不显示下分翻页提示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageDown"
		local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		_frmNode.childUI["DLCMapInfoPageDown"].handle._n:runAction(forever)
		
		--左侧向上翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["DLCMapInfoPageUp_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = DLCMAPINFO_OFFSET_X + 0,
			y = DLCMAPINFO_OFFSET_Y + 70 + 14,
			w = 220,
			h = 56,
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
		
		--左侧向下翻页的按钮的接受左点击事件的响应区域
		_frmNode.childUI["DLCMapInfoPageDown_Btn"] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png", --"UI:playerBagD"
			dragbox = _frm.childUI["dragBox"],
			x = DLCMAPINFO_OFFSET_X + 0,
			y = DLCMAPINFO_OFFSET_Y - 570 - 6,
			w = 220,
			h = 56,
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
		
		--[[
		--左侧底板
		--背景图
		_frmNode.childUI["DLCMapInfoListBG"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/selectbg.png",
			x = DLCMAPINFO_OFFSET_X + 134,
			y = DLCMAPINFO_OFFSET_Y - 330,
			w = 280,
			h = DLCMAPINFO_BOARD_HEIGHT - 74,
		})
		_frmNode.childUI["DLCMapInfoListBG"].handle.s:setOpacity(128) --底板透明度为128
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoListBG"
		]]
		
		--[[
		--竖线
		_frmNode.childUI["DLCMapInfoListLineV"] = hUI.image:new({
			parent = _parentNode,
			model = "panel/panel_part_09.png",
			x = DLCMAPINFO_OFFSET_X + 245,
			y = DLCMAPINFO_OFFSET_Y - 328,
			w = DLCMAPINFO_BOARD_HEIGHT + 64,
			h = 12,
		})
		_frmNode.childUI["DLCMapInfoListLineV"].handle.s:setRotation(-90)
		_frmNode.childUI["DLCMapInfoListLineV"].handle.s:setOpacity(128) --竖线透明度为128
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoListLineV"
		
		--上横线
		_frmNode.childUI["DLCMapInfoListLineHUp"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/card_select_back.png",
			x = DLCMAPINFO_OFFSET_X + 130,
			y = DLCMAPINFO_OFFSET_Y - 80,
			w = 210,
			h = 3,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoListLineHUp"
		hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHUp"].handle.s, "gray") --默认上横线到顶了，灰掉
		
		--下横线
		_frmNode.childUI["DLCMapInfoListLineHDown"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/card_select_back.png",
			x = DLCMAPINFO_OFFSET_X + 130,
			y = DLCMAPINFO_OFFSET_Y - DLCMAPINFO_BOARD_HEIGHT - 6,
			w = 210,
			h = 3,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoListLineHDown"
		hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHDown"].handle.s, "gray") --默认下横线到顶了，灰掉
		]]
		
		--左侧用于检测滑动事件的控件
		_frmNode.childUI["DLCMapInfoDragPanel"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			x = DLCMAPINFO_OFFSET_X + 1,
			y = DLCMAPINFO_OFFSET_Y - 246,
			w = DLCMAPINFO_WIDTH + 20,
			h = 600,
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
				
				--如果DLC地图面板数量未铺满一页，那么不需要滑动
				if (current_DLCMap_max_num <= (DLCMAPINFO_X_NUM * DLCMAPINFO_Y_NUM)) then
					click_scroll_dlcmapinfo = false --不需要滑动DLC地图面板
				end
				
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
					for i = 1, #current_ActivityList, 1 do
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
				for i = 1, #current_ActivityList, 1 do
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
					OnCreateActivityTipFrame(selectTipIdx)
				end
				
				--标记不用滑动
				click_scroll_dlcmapinfo = false
			end,
		})
		_frmNode.childUI["DLCMapInfoDragPanel"].handle.s:setOpacity(0) --只用于控制，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoDragPanel"
		
		--依次绘制左侧DLC地图包列表（只绘制一次）
		--OnCreateDLCMapInfoFrame_LeftPart()
		
		--更新绘制左侧的界面状态
		--OnRefresnDLCMapInfoFrame_LeftPart()
		
		--默认选中第i个DLC地图包，显示本地图包的详细信息
		--OnCreateDLCMapInfoFrame_RightPart(1)
		
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
			scaleT = 1.0,
			dragbox = _frm.childUI["dragBox"],
			code = function()
				--
			end,
		})
		_frmNode.childUI["Btn_Activity"].handle.s:setOpacity(255) --只挂载子控件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "Btn_Activity"
		--图标
		_frmNode.childUI["Btn_Activity"].childUI["icon"] = hUI.button:new({
			parent = _frmNode.childUI["Btn_Activity"].handle._n,
			model = "misc/task/tab_events_02.png",
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
		
		--添加事件监听：购买DLC地图包成功事件（恢复存档也会走进来）
		--hGlobal.event:listen("LocalEvent_Phone_ShowActivityNewFrm_Back", "__PhoneRefreshMapInfoFrm", on_receive_DLCMapInfo_Back)
		--添加事件监听：关闭查看某一关介绍的面板
		--hGlobal.event:listen("LocalEvent_Phone_HideMapInfoFrm", "__PhoneCloseMapInfoFrm", on_close_MapInfo_Panel)
		--添加事件监听：收到活动信息回调
		hGlobal.event:listen("localEvent_UpdateActivityInfo", "__OnReceiveActivityInfo", on_receive_activity_info_event)
		--添加事件监听：收到活动进度事件
		hGlobal.event:listen("localEvent_UpdateActivityReward", "_UpdateActivityReward", on_receive_activity_progress_event)
		--添加事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenActivity_", on_spine_screen_event)
		
		--创建timer，刷新DLC地图面板滚动
		hApi.addTimerForever("__ACTIVITY_NEW_UPDATE__", hVar.TIMER_MODE.GAMETIME, 30, refresh_dlcmapinfo_UI_loop)
		
		--发送查询活动信息请求
		local langIdx = g_Cur_Language - 1
		SendCmdFunc["get_ActivityList"](langIdx)
	end
	
	--函数：刷新DLC地图面板界面的滚动
	refresh_dlcmapinfo_UI_loop = function()
		--如果当前在动画中，不用处理
		--if (ANIM_IN_ACTION == 1) then
		--	return
		--end
		local _frm = hGlobal.UI.PhoneActivityNewFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local SPEED = 50 --速度
		--print(b_need_auto_fixing_dlcmapinfo)
		
		if b_need_auto_fixing_dlcmapinfo then
			--第一个DLC地图面板的数据
			local delta1_ly = 0 --第一个DLC地图面板最上侧的y坐标
			local deltNa_ry = 0 --最后一个DLC地图面板最下侧的y坐标
			delta1_ly, deltNa_ry = getUpDownOffset()
			--print(delta1_ly, deltNa_ry)
			--delta1_ly +:在下底线之上 /-:在下底线之下
			--deltNa_ry +:在下底线之上 /-:在下底线之下
			--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
			
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
				for i = 1, #current_ActivityList, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x, pos_y + speed
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
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
				for i = 1, #current_ActivityList, 1 do
					local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					--本地运动到达的坐标
					local to_x, to_y = pos_x, pos_y - speed
					
					--设置新坐标
					ctrli.data.x = to_x
					ctrli.data.y = to_y
					ctrli.handle._n:setPosition(to_x, to_y)
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
					for i = 1, #current_ActivityList, 1 do
						local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
						local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						--本地运动到达的坐标
						local to_x, to_y = pos_x, pos_y + speed
						
						--设置新坐标
						ctrli.data.x = to_x
						ctrli.data.y = to_y
						ctrli.handle._n:setPosition(to_x, to_y)
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
					for i = 1, #current_ActivityList, 1 do
						local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
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
	
	--函数：收到获得活动信息的回调
	on_receive_activity_info_event = function(tActivityList)
		local _frm = hGlobal.UI.PhoneActivityNewFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--先清除所有右侧的控件
		_removeMiddleFrmFunc()
		_removeRightFrmFunc()
		
		--签到活动单独有页面显示，这里不展示签到了
		for i = 1, #tActivityList, 1 do
			local listI = tActivityList[i] --第i项
			local activityId = listI.aid --活动id
			local activityType = listI.ptype --活动类型
			if (activityType == 10022) then
				table.remove(tActivityList, i)
				break
			end
		end
		
		--存储活动信息表
		current_ActivityList = tActivityList
		current_DLCMap_max_num = #tActivityList
		
		--对表进行排序
		table.sort(current_ActivityList, function(ta, tb)
			local aid_ta = ta.aid
			local ptype_ta = ta.ptype
			local aid_tb = tb.aid
			local ptype_tb = tb.ptype
			
			local zOrder_ta = ACTIVITY_TYPE_ICON[ptype_ta] and ACTIVITY_TYPE_ICON[ptype_ta].zOrder or 100
			local zOrder_tb = ACTIVITY_TYPE_ICON[ptype_tb] and ACTIVITY_TYPE_ICON[ptype_tb].zOrder or 100
			
			if (zOrder_ta ~= zOrder_tb) then
				return (zOrder_ta > zOrder_tb)
			else
				return (aid_ta < aid_tb)
			end
		end)
		
		--本地已查看过的aid列表（用于界面显示哪些活动要提示叹号）
		local ActivityAidList = LuaGetActivityAidList(g_curPlayerName)
		--LuaClearActivityAidList(g_curPlayerName) --测试 --test
		
		--依次绘制活动标题界面
		for i = 1, #current_ActivityList, 1 do
			local listI = current_ActivityList[i] --第i项
			local activityId = listI.aid --活动id
			local activityType = listI.ptype --活动类型
			local activityName = listI.title --活动名称
			local activityAwards = listI.prize --活动奖励表
			local activityDesc = listI.describe --活动描述
			local activityBeginDate = tonumber(listI.time_begin) --活动开始时间
			local activityEndDate = tonumber(listI.time_end) --活动结束时间
			
			--检测是否需要提示新活动提示叹号
			local bViewed = false --是否已查看过
			for ai = 1, #ActivityAidList, 1 do
				--print(ActivityAidList[ai])
				if (ActivityAidList[ai] == activityId) then --找到了
					bViewed = true --看过了
					break
				end
			end
			
			--标记参数
			--current_Activity_max_num = validIdx --标记最大活动id
			
			local xn = (i % DLCMAPINFO_X_NUM) --xn
			if (xn == 0) then
				xn = DLCMAPINFO_X_NUM
			end
			local yn = (i - xn) / DLCMAPINFO_X_NUM + 1 --yn
			
			--活动的底板
			_frmNode.childUI["DLCMapInfoNode" .. i] = hUI.button:new({
				parent = _BTC_pClipNode_Activity,
				model = "misc/mask.png",
				x = DLCMAPINFO_OFFSET_X + 0 + (xn - 1) * (DLCMAPINFO_WIDTH + 14),
				y = DLCMAPINFO_OFFSET_Y - 0 - (yn - 1) * (DLCMAPINFO_HEIGHT + 4),
				w = DLCMAPINFO_WIDTH + 2,
				h = DLCMAPINFO_HEIGHT + 2,
			})
			_frmNode.childUI["DLCMapInfoNode" .. i].handle.s:setOpacity(0) --只挂载子控件，不显示
			middleRemoveFrmList[#middleRemoveFrmList + 1] = "DLCMapInfoNode" .. i
			
			--活动背景图
			_frmNode.childUI["DLCMapInfoNode" .. i].childUI["image"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. i].handle._n,
				model = "misc/task/event_frame.png",
				x = 0,
				y = 0,
				w = 180,
				h = 70,
			})
			
			--选中框
			_frmNode.childUI["DLCMapInfoNode" .. i].childUI["selectbox"] = hUI.button:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. i].handle._n,
				model = "misc/task/event_selected.png",
				x = 0,
				y = 0,
				w = 192,
				h = 75,
			})
			_frmNode.childUI["DLCMapInfoNode" .. i].childUI["selectbox"].handle._n:setVisible(false) --默认隐藏
			local scale0 = 1
			--选中框图标
			_frmNode.childUI["DLCMapInfoNode" .. i].childUI["selectbox"].childUI["icon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. i].childUI["selectbox"].handle._n,
				model = ACTIVITY_TYPE_ICON[activityType][1],
				x = -63,
				y = 2,
				w = ACTIVITY_TYPE_ICON[activityType][2],
				h = ACTIVITY_TYPE_ICON[activityType][3],
			})
			
			--活动图标
			local scale0 = 1
			_frmNode.childUI["DLCMapInfoNode" .. i].childUI["icon"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. i].handle._n,
				model = ACTIVITY_TYPE_ICON[activityType][1],
				x = -58,
				y = 2,
				w = ACTIVITY_TYPE_ICON[activityType][2],
				h = ACTIVITY_TYPE_ICON[activityType][3],
			})
			
			--活动标题
			_frmNode.childUI["DLCMapInfoNode" .. i].childUI["name"] = hUI.label:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. i].handle._n,
				x = -20,
				y = 1,
				width = 300,
				align = "LC",
				size = 26,
				 border = 1,
				font = hVar.FONTC,
				text = activityName,
			})
			
			--提示新活动的跳动的叹号
			_frmNode.childUI["DLCMapInfoNode" .. i].childUI["tanhao"] = hUI.image:new({
				parent = _frmNode.childUI["DLCMapInfoNode" .. i].handle._n,
				x = 70,
				y = 22,
				model = "UI:TaskTanHao",
				w = 42,
				h = 42,
			})
			_frmNode.childUI["DLCMapInfoNode" .. i].childUI["tanhao"].handle._n:setVisible(not bViewed) --一开始不显示提示新活动的叹号
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
			_frmNode.childUI["DLCMapInfoNode" .. i].childUI["tanhao"].handle._n:runAction(CCRepeatForever:create(sequence))
		end
		
		if (current_DLCMap_max_num > (DLCMAPINFO_X_NUM * DLCMAPINFO_Y_NUM)) then --超过一页了
			_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true)
		end
		
		if (#current_ActivityList > 0) then
			--如果上次未选中活动，默认选中第一个
			if (current_selectedIdx == 0) then
				OnCreateActivityTipFrame(1)
			elseif (current_selectedIdx > #current_ActivityList) then --上次选中的活动超过上限
				OnCreateActivityTipFrame(1)
			else --选中上次的活动
				local selectedIdx = current_selectedIdx
				current_selectedIdx = 0
				OnCreateActivityTipFrame(selectedIdx)
			end
		else
			current_selectedIdx = 0
		end
		
		--没有活动显示一行文字
		if (#current_ActivityList == 0) then
			--标题-系统邮件(左)
			_frmNode.childUI["DLCMapInfoTitleNone"] = hUI.label:new({
				parent = _parentNode,
				x = DLCMAPINFO_WIDTH / 2 + DLCMAPINFO_WIDTH / 2 + 166,
				y = -DLCMAPINFO_HEIGHT / 2 - 80 - 206,
				font = hVar.FONTC,
				size = 26,
				align = "MC",
				text = hVar.tab_string["__TEXT_TemporaryNoneActivity"], --"暂无活动"
				border = 1,
				RGB = {212, 212, 212},
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoTitleNone"
		end
	end
	
	--函数：显示指定的活动的详细信息tip面板
	OnCreateActivityTipFrame = function(selectedIdx)
		local _frm = hGlobal.UI.PhoneActivityNewFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--不重复选择同一个
		if (current_selectedIdx == selectedIdx) then
			return
		end
		
		--存储
		local lastSelectedIdx = current_selectedIdx
		current_selectedIdx = selectedIdx
		
		--隐藏左侧之前的选中框
		if (lastSelectedIdx > 0) then
			_frmNode.childUI["DLCMapInfoNode" .. lastSelectedIdx].childUI["selectbox"].handle._n:setVisible(false)
			_frmNode.childUI["DLCMapInfoNode" .. lastSelectedIdx].childUI["icon"].handle._n:setVisible(true)
		end
		
		--显示本次的选中框
		_frmNode.childUI["DLCMapInfoNode" .. selectedIdx].childUI["selectbox"].handle._n:setVisible(true)
		_frmNode.childUI["DLCMapInfoNode" .. selectedIdx].childUI["icon"].handle._n:setVisible(false)
		
		--清除所有右侧的控件
		_removeRightFrmFunc()
		
		local ACTIVITY_DX = 240
		local ACTIVITY_DY = -60
		
		local listI = current_ActivityList[selectedIdx] --第i项
		local activityId = listI.aid --活动id
		local activityType = listI.ptype --活动类型
		local activityName = listI.title --活动名称
		local activityAwards = listI.prize --活动奖励表
		local activityDesc = listI.describe --活动描述
		local activityBeginDate = tonumber(listI.time_begin) --活动开始时间
		local activityEndDate = tonumber(listI.time_end) --活动结束时间
		
		--认为查看过此活动
		LuaAddActivityAid(g_curPlayerName, activityId)
		
		--隐藏左侧活动的叹号
		if _frmNode.childUI["DLCMapInfoNode" .. selectedIdx] then
			if _frmNode.childUI["DLCMapInfoNode" .. selectedIdx].childUI["tanhao"] then
				_frmNode.childUI["DLCMapInfoNode" .. selectedIdx].childUI["tanhao"].handle._n:setVisible(false)
			end
		end
		
		--活动介绍
		_frmNode.childUI["ActivityIntroduce"] = hUI.label:new({
			parent = _parentNode,
			x = ACTIVITY_DX,
			y = ACTIVITY_DY,
			width = 440,
			align = "LT",
			size = 24,
			 border = 1,
			font = hVar.FONTC,
			text = activityDesc,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "ActivityIntroduce"
		
		--ptype:10026: taptap留言活动
		if (activityType ~= 10026) then
			--绘制每个档位的奖励
			for i = 1, #activityAwards, 1 do
				local rate = activityAwards[i].rate --档位需要的值
				local prize = activityAwards[i].prize --档位的奖励道具
				local money = activityAwards[i].money or 0 --档位的充值金额(可选)
				
				--print("绘制每个档位的奖励", i, rate, prize, money)
				local strTitle = "" --档位的标题
				local cTitleColor = ccc3(0, 255, 0) --每个档位的颜色
				local bg_posX = ACTIVITY_DX - 100
				local bg_posY = ACTIVITY_DY - 253 - (i - 1) * 60
				local bg_height = 56 --底板高度
				local title_posX = ACTIVITY_DX - 10
				local title_posY = ACTIVITY_DY - 252 - (i - 1) * 60
				local reward_posX = ACTIVITY_DX - 225 + 20 + 310
				local reward_posY = ACTIVITY_DY - 256 - (i - 1) * 60
				local reward_scale = 1.0
				
				--如果档位达到6个，间距小一点
				if (#activityAwards == 6) then
					bg_posY = ACTIVITY_DY - 253 - (i - 1) * 56
					title_posY = ACTIVITY_DY - 256 - (i - 1) * 56
					reward_posY = ACTIVITY_DY - 256 - (i - 1) * 56
					bg_height = 52
					reward_scale = 1.0
				end
				
				--如果档位达到7+个，间距更小
				if (#activityAwards >= 7) then
					bg_posY = ACTIVITY_DY - 253 - (i - 1) * 47 + 7
					title_posY = ACTIVITY_DY - 245 - (i - 1) * 47
					reward_posY = ACTIVITY_DY - 247 - (i - 1) * 47
					bg_height = 44
					reward_scale = 0.9
				end
				
				if (activityType == 2) then --累计消耗金币
					--strTitle = "累计消耗" .. rate .. "游戏币" --language
					strTitle = hVar.tab_string["__TEXT_CONSUME"] .. rate .. hVar.tab_string["__TEXT_PAGE_PURCHASE"] --language
				elseif (activityType == 3) then --登陆1天送xx，登陆2天送xx...
					--strTitle = "累计登陆" .. rate .. "天" --language
					strTitle = hVar.tab_string["__TEXT__LeiJi"] .. hVar.tab_string["__TEXT__AccountTip"] .. rate .. hVar.tab_string["__TEXT_Dat"] --language
				elseif (activityType == 98) then --累计充值次数
					--strTitle = "累计充值" .. rate / 10 .. "次" --language
					strTitle = hVar.tab_string["__TEXT__LeiJi"] .. hVar.tab_string["__TEXT_Pruchase"] .. rate .. hVar.tab_string["__TEXT_YouCanForgedCount1"] --language
				elseif (activityType == 99) then --按档位充值xx次，如充值98元档1次
					--strTitle = "充值6元档" --language
					--韩国版，这里文字改为游戏币计算
					strTitle = string.format(hVar.tab_string["__TEXT__PurchaseCount"], money*10)--language
				elseif (activityType == 100) then --累计充值金币
					--strTitle = "累计充值" .. rate / 10 .. "元" --language
					--韩国版，这里文字改为游戏币计算
					strTitle = string.format(hVar.tab_string["__TEXT_TotalPurchaseMoney"], rate)
				elseif (activityType == 101) then --充值暴击
					--strTitle = money .. "元暴击" --language
					strTitle = money .. hVar.tab_string["Rmb"]  .. hVar.tab_string["__Attr_Hint_crit"] --language
				elseif (activityType == 10001) then --夺塔奇兵所有正常局
					--strTitle = "累计挑战" .. rate .. "局" --language
					strTitle = hVar.tab_string["__TEXT__LeiJi"] .. hVar.tab_string["__TEXT_BTN_DIFF_MODE"] .. rate .. hVar.tab_string["__TEXT__GameCount"] --language
				elseif (activityType == 10002) then --夺塔奇兵所有胜局
					--strTitle = "累计胜利" .. rate .. "局" --language
					strTitle = hVar.tab_string["__TEXT__LeiJi"] .. hVar.tab_string["PVPWin"] .. rate .. hVar.tab_string["__TEXT__GameCount"] --language
				elseif (activityType == 10003) then --夺塔奇兵电脑正常局
					--strTitle = "累计挑战" .. rate .. "局" --language
					strTitle = hVar.tab_string["__TEXT__LeiJi"] .. hVar.tab_string["__TEXT_BTN_DIFF_MODE"] .. rate .. hVar.tab_string["__TEXT__GameCount"] --language
				elseif (activityType == 10004) then --夺塔奇兵对人正常局
					--strTitle = "累计挑战" .. rate .. "局" --language
					strTitle = hVar.tab_string["__TEXT__LeiJi"] .. hVar.tab_string["__TEXT_BTN_DIFF_MODE"] .. rate .. hVar.tab_string["__TEXT__GameCount"] --language
				elseif (activityType == 10005) then --夺塔奇兵对人胜局
					--strTitle = "累计胜利" .. rate .. "局" --language
					strTitle = hVar.tab_string["__TEXT__LeiJi"] .. hVar.tab_string["PVPWin"] .. rate .. hVar.tab_string["__TEXT__GameCount"] --language
				elseif (activityType == 10006) then --夺塔奇兵对困难电脑胜局
					--strTitle = "累计胜利" .. rate .. "局" --language
					strTitle = hVar.tab_string["__TEXT__LeiJi"] .. hVar.tab_string["PVPWin"] .. rate .. hVar.tab_string["__TEXT__GameCount"] --language
				elseif (activityType == 10007) then --夺塔奇兵获得的星数
					strTitle = hVar.tab_string["__TEXT__LeiJi"] .. hVar.tab_string["__TEXT_Get1"] .. rate .. hVar.tab_string["NumStars"] --language
				elseif (activityType == 10008) then --夺塔奇兵开启锦囊数量
					strTitle = hVar.tab_string["__TEXT__LeiJi"] .. hVar.tab_string["__TEXT_PVP_Open"] .. rate .. hVar.tab_string["__TEXT_COUNT"] .. hVar.tab_string["__TEXT_PVP_Chest"] --language
				elseif (activityType == 10009) then --夺塔奇兵锦囊掉率翻倍
					strTitle = "" --language
				elseif (activityType == 10010) then --夺塔奇兵匹配房所有正常局
					--strTitle = "累计挑战" .. rate .. "局" --language
					strTitle = hVar.tab_string["__TEXT__LeiJi"] .. hVar.tab_string["__TEXT_BTN_DIFF_MODE"] .. rate .. hVar.tab_string["__TEXT__GameCount"] --language
				elseif (activityType == 10011) then --夺塔奇兵匹配房每日正常局
					--strTitle = "每日挑战" .. rate .. "局" --language
					--strTitle = hVar.tab_string["__TEXT_PVP_Everyday"] .. hVar.tab_string["__TEXT_BTN_DIFF_MODE"] .. rate .. hVar.tab_string["__TEXT__GameCount"] --language
					strTitle = string.format(hVar.tab_string["__TodayBattleValidCount"], rate)
				elseif (activityType == 10012) then --魔龙宝库正常局胜利
					--strTitle = "今日通关" .. rate .. "局" --language
					--strTitle = hVar.tab_string["__Today"] .. hVar.tab_string["__TEXT_BTN_PASS"] .. rate .. hVar.tab_string["__TEXT__GameCount"] --language
					strTitle = string.format(hVar.tab_string["__TodayBattleWinCount"], rate)
				elseif (activityType == 10013) then --铜雀台正常局胜利
					--strTitle = "今日通关" .. rate .. "局" --language
					--strTitle = hVar.tab_string["__Today"] .. hVar.tab_string["__TEXT_BTN_PASS"] .. rate .. hVar.tab_string["__TEXT__GameCount"] --language
					strTitle = string.format(hVar.tab_string["__TodayBattleWinCount"], rate)
				elseif (activityType == 10014) then --军团宝库正常局胜利
					--strTitle = "今日通关" .. rate .. "局" --language
					--strTitle = hVar.tab_string["__Today"] .. hVar.tab_string["__TEXT_BTN_PASS"] .. rate .. hVar.tab_string["__TEXT__GameCount"] --language
					strTitle = string.format(hVar.tab_string["__TodayBattleWinCount"], rate)
				elseif (activityType == 10020) then --仅苹果玩家可见的文字展示类活动
					--
				elseif (activityType == 10021) then --仅安卓玩家可见的文字展示类活动
					--
				elseif (activityType == 10022) then --新玩家14日签到活动
					--
				elseif (activityType == 10024) then --消费转盘活动
					--
				elseif (activityType == 10025) then --连续七天充值活动
					--
				elseif (activityType == 10026) then --taptap留言活动
					--
				elseif (activityType == 10027) then --军团连续活跃活动
					--
				elseif (activityType == 10028) then --人族无敌游戏局
					--strTitle = "今日挑战至第" .. rate .. "波" --language
					--strTitle = hVar.tab_string["__Today"] .. hVar.tab_string["__TEXT_BTN_DIFF_MODE"] .. hVar.tab_string["__TEXT_WORD_TO"] .. hVar.tab_string["__TEXT_WORD_DI"] .. rate .. hVar.tab_string["__ATTR__Wave"] --language
					strTitle = string.format(hVar.tab_string["__TodayBattleWaveCount"], rate)
				elseif (activityType == 10029) then --守卫剑阁游戏局
					--strTitle = "今日挑战至第" .. rate .. "波" --language
					--strTitle = hVar.tab_string["__Today"] .. hVar.tab_string["__TEXT_BTN_DIFF_MODE"] .. hVar.tab_string["__TEXT_WORD_TO"] .. hVar.tab_string["__TEXT_WORD_DI"] .. rate .. hVar.tab_string["__ATTR__Wave"] --language
					strTitle = string.format(hVar.tab_string["__TodayBattleWaveCount"], rate)
				elseif (activityType == 10030) then --消费抽奖活动
					--
				elseif (activityType == 10031) then --双人守卫剑阁游戏局
					--strTitle = "今日挑战至第" .. rate .. "波" --language
					--strTitle = hVar.tab_string["__Today"] .. hVar.tab_string["__TEXT_BTN_DIFF_MODE"] .. hVar.tab_string["__TEXT_WORD_TO"] .. hVar.tab_string["__TEXT_WORD_DI"] .. rate .. hVar.tab_string["__ATTR__Wave"] --language
					strTitle = string.format(hVar.tab_string["__TodayBattleWaveCount"], rate)
				elseif (activityType == 10032) then --新用户任意充值活动
					--
				elseif (activityType == 10033) then --群英阁正常局胜利
					--strTitle = "今日通关" .. rate .. "局" --language
					--strTitle = hVar.tab_string["__Today"] .. hVar.tab_string["__TEXT_BTN_PASS"] .. rate .. hVar.tab_string["__TEXT__GameCount"] --language
					strTitle = string.format(hVar.tab_string["__TodayBattleWinCount"], rate)
				elseif (activityType == 10034) then --魔塔杀阵正常局胜利
					--strTitle = "今日通关" .. rate .. "局" --language
					--strTitle = hVar.tab_string["__Today"] .. hVar.tab_string["__TEXT_BTN_PASS"] .. rate .. hVar.tab_string["__TEXT__GameCount"] --language
					strTitle = string.format(hVar.tab_string["__TodayBattleWinCount"], rate)
				elseif (activityType == 20001) then --随机迷宫层数
					--strTitle = 天梯迷宫抵达1-2 --language
					local stage1 = math.floor(rate / 10)
					local stage2 = rate - stage1*10
					strTitle = string.format(hVar.tab_string["__TEXT_TASK_RANDOMMAP_STAGE"], stage1, stage2)
				elseif (activityType == 20002) then --前哨阵地波次
					--strTitle = 抵达第n波 --language
					strTitle = string.format(hVar.tab_string["__TEXT_TASK_QIANSHAOZHENDI_WAVE"], rate)
				elseif (activityType == 20003) then --解锁武器数量
					--strTitle = 解锁n个武器 --language
					strTitle = string.format(hVar.tab_string["__TEXT_TASK_WEAOON_UNLOCK_NUM"], rate)
				elseif (activityType == 20004) then --解锁宠物数量
					--strTitle = 解锁n个宠物 --language
					strTitle = string.format(hVar.tab_string["__TEXT_TASK_PET_UNLOCK_NUM"], rate)
				elseif (activityType == 20005) then --累计获得星星数量
					--strTitle = 获得n颗星星 --language
					strTitle = string.format(hVar.tab_string["__TEXT_TASK_TOTALSTAR_NUM"], rate)
				end
				
				--[[
				--分割线
				if (i == 1) then
					_frmNode.childUI["SeparateLine"] = hUI.image:new({
						parent = _parentNode,
						x = ACTIVITY_DX - 95,
						y = ACTIVITY_DY - 215,
						model = "UI:Tactic_SeparateLine",
						w = 760,
						h = 4,
					})
					rightRemoveFrmList[#rightRemoveFrmList + 1] = "SeparateLine"
				end
				]]
				
				--底板
				_frmNode.childUI["bg2" .. i] = hUI.button:new({ --作为按钮只是为了挂载子控件
					parent = _parentNode,
					--model = "misc/mask.png",
					model = -1,
					x = bg_posX + 330,
					y = bg_posY,
					w = 480,
					h = bg_height,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "bg2" .. i
				--_ActivityTipChildUI["bg2" .. i].handle.s:setOpacity(168)
				--九宫格
				local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_9s_2.png", 0, 0, 480, bg_height, _frmNode.childUI["bg2" .. i])
				s9:setOpacity(128)
				
				--档位的标题
				local titleFontSize = 26 --字体大小
				local strTitleLength = hApi.GetStringEmojiENLength(strTitle) --获得英文长度
				--print("strTitleLength=", strTitleLength)
				if (strTitleLength > 20) then
					titleFontSize = 22 --字体大小
				elseif (strTitleLength > 18) then
					titleFontSize = 24 --字体大小
				end
				_frmNode.childUI["title" .. i] = hUI.label:new({
					parent = _parentNode,
					size = titleFontSize,
					x = title_posX,
					y = title_posY,
					width = 500,
					align = "LC",
					font = hVar.FONTC,
					text = strTitle,
					border = 1,
				})
				_frmNode.childUI["title" .. i].handle.s:setColor(cTitleColor)
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "title" .. i
				
				--[[
				--绘制奖励文字
				_frmNode.childUI["rewardLabel" .. i] = hUI.label:new({
					parent = _parentNode,
					size = 26,
					x = reward_posX,
					y = reward_posY,
					width = 500,
					align = "LC",
					font = hVar.FONTC,
					--text = "奖励:", --language
					text = hVar.tab_string["__Reward__"] .. ":", --language
					border = 1,
				})
				_frmNode.childUI["rewardLabel" .. i].handle.s:setColor(ccc3(255, 212, 212))
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "rewardLabel" .. i
				]]
				
				--获取全部的奖励
				local reward = {}
				for j = 1, #prize, 1 do
					local sCmdType = prize[j].type --奖励的格式类型("cn"/"td")
					
					if (sCmdType == "td") then --"td": 积累式奖励
						local sCmd = prize[j].detail --奖励的内容（字符串）
						--print("sCmdType=", sCmdType, "sCmd=", sCmd)
						--print(sCmd)
						local tCmd = hApi.Split(sCmd,";")
						local rewardN = #tCmd
						local rewardIdx = 2
						--print(tCmd, #tCmd)
						for k = 2, rewardN, 1 do
							local tmp = {}
							local tRInfo = hApi.Split(tCmd[rewardIdx],":")
							if (tRInfo[1]) and (tRInfo[1] ~= "") and (tRInfo[1] ~= "0") then
								tmp[#tmp + 1] = tonumber(tRInfo[1])				--奖励类型
								tmp[#tmp + 1] = tonumber(tRInfo[2])				--参数1
								tmp[#tmp + 1] = tonumber(tRInfo[3])				--参数2
								tmp[#tmp + 1] = tRInfo[4]				--参数3
								
								reward[#reward + 1] = tmp
							end
							rewardIdx = rewardIdx + 1
						end
					elseif (sCmdType == "cn") then --"cn": 游戏币奖励
						local sCmd = prize[j].num --奖励的内容（字符串）
						--print(sCmd)
						local tmp = {}
						tmp[#tmp + 1] = 7				--奖励类型:游戏币
						tmp[#tmp + 1] = tonumber(sCmd)	--参数1
						tmp[#tmp + 1] = 0				--参数2
						tmp[#tmp + 1] = 0				--参数3
						
						reward[#reward + 1] = tmp
					end
				end
				
				--绘制全部的奖励（有可能有多个相同的献祭晶石，这里避免连续绘制）
				local artifactStoneNum = 0
				for m = 1, #reward, 1 do
					local rewardT = reward[m]
					if (rewardT[1] == 10) and (rewardT[2] == 12406) then
						artifactStoneNum = artifactStoneNum + 1
					end
				end
				if (artifactStoneNum > 1) then --存在多个相同的献祭晶石，合并表
					local delCount = 0
					for m = #reward, 1, -1 do
						local rewardT = reward[m]
						if (rewardT[1] == 10) and (rewardT[2] == 12406) then
							if (delCount < (artifactStoneNum - 1)) then --删到只保留1个献祭晶石
								delCount = delCount + 1
								table.remove(reward, m)
							end
						end
					end
				end
				
				--绘制全部的奖励（有可能有多个相同的游戏币，游戏币发奖上限为2000，如果发奖大于2000只能发多条，这里避免连续绘制）
				local gamecoinNum = 0
				local gamecoinValue = 0
				for m = 1, #reward, 1 do
					local rewardT = reward[m]
					if (rewardT[1] == 7) then
						gamecoinNum = gamecoinNum + 1
						gamecoinValue = gamecoinValue + rewardT[2]
					end
				end
				if (gamecoinNum > 1) then --存在多个相同的游戏币，合并表
					local delCount = 0
					for m = #reward, 1, -1 do
						local rewardT = reward[m]
						if (rewardT[1] == 7) then
							if (delCount < (gamecoinNum - 1)) then --删到只保留1条游戏币
								delCount = delCount + 1
								table.remove(reward, m)
							else
								rewardT[2] = gamecoinValue --唯一保留的，设置游戏币数量
							end
						end
					end
				end
				
				for m = 1, #reward, 1 do
					local rewardT = reward[m]
					local rewardType = rewardT[1] --奖励的类型
					--print(rewardT[1], rewardT[2], rewardT[3], rewardT[4])
					local scale = 1.1 * reward_scale
					if (rewardType > 0) then
						local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
						
						--活动
						--奖励物品的图标按钮（只用于响应事件，不显示）
						local rewardXL = 86
						local rewardDx = 54
						
						--[[
						if (#reward == 1) then --奖励1个，往右挪一些
							rewardXL = 86 + 50
							rewardDx = 50
						elseif (#reward == 2) then --奖励2个，往右挪一些
							rewardXL = 86 + 20
							rewardDx = 50
						end
						]]
						
						if (#reward > 3) then --奖励数量太多，间距小点
							rewardXL = 90
							rewardDx = 50
						end
						_frmNode.childUI["rewardIcon" .. i .. "_" .. m] = hUI.button:new({
							parent = _parentNode,
							model = "misc/mask.png",
							x = reward_posX + rewardXL + (m - 1) * rewardDx,
							y = reward_posY + 3,
							w = 51,
							h = 54,
							scaleT = 0.95,
							dragbox = _frm.childUI["dragBox"],
							code = function()
								--显示各种类型的奖励的tip
								hApi.ShowRewardTip(rewardT)
							end,
						})
						_frmNode.childUI["rewardIcon" .. i .. "_" .. m].handle.s:setOpacity(0) --默认不显示（只用于响应事件，不显示）
						rightRemoveFrmList[#rightRemoveFrmList + 1] = "rewardIcon" .. i .. "_" .. m
						
						--物品图标
						_frmNode.childUI["rewardIcon" .. i .. "_" .. m].childUI["icon"] = hUI.image:new({
							parent = _frmNode.childUI["rewardIcon" .. i .. "_" .. m].handle._n,
							model = tmpModel,
							x = 0,
							y = 0,
							w = itemWidth * scale,
							h = itemHeight * scale,
						})
						
						--绘制奖励图标的子控件
						if sub_tmpModel then
							_frmNode.childUI["rewardIcon" .. i .. "_" .. m].childUI["subIcon"] = hUI.image:new({
								parent = _frmNode.childUI["rewardIcon" .. i .. "_" .. m].handle._n,
								model = sub_tmpModel,
								x = sub_pos_x * scale,
								y = sub_pos_y * scale,
								w = sub_pos_w * scale,
								h = sub_pos_h * scale,
							})
						end
						
						--绘制奖励的数量
						local strRewardNum = tostring(itemNum) --"+" .. itemNum
						
						--[[
						--测试 --test
						strRewardNum = "+0000"
						]]
						
						local rewardNumLength = #strRewardNum
						local rewardNumFont = "numWhite" --字体
						local rewardNumFontSize = 16 --字体大小
						local rewardNumBorder = 1 --是否显示边框
						_frmNode.childUI["rewardIcon" .. i .. "_" .. m].childUI["num"] = hUI.label:new({
							parent = _frmNode.childUI["rewardIcon" .. i .. "_" .. m].handle._n,
							size = rewardNumFontSize,
							x = 0,
							y = -12,
							width = 500,
							align = "MC",
							font = rewardNumFont,
							text = strRewardNum,
							border = rewardNumBorder,
						})
						if (rewardT[1] == 10) and (rewardT[2] == 12406) then --多个献祭晶石数量
							_ActivityTipChildUI["rewardIcon" .. i .. "_" .. m].childUI["num"]:setText("+" .. artifactStoneNum)
						end
					end
				end
				
				--绘制每个档位的进度值
				--[[
				--绘制进度文字
				_frmNode.childUI["proggressLabel" .. i] = hUI.label:new({
					parent = _parentNode,
					size = 26,
					x = ACTIVITY_DX + 15 + 40 + 170,
					y = reward_posY,
					width = 500,
					align = "LC",
					font = hVar.FONTC,
					--text = "进度:", --language
					text = hVar.tab_string["__Progress___"] .. ":", --language
					border = 1,
				})
				_frmNode.childUI["proggressLabel" .. i].handle.s:setColor(ccc3(255, 212, 128))
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "proggressLabel" .. i
				]]
				
				--[[
				if (activityType == 100) then  --累计充值金币
					rate = rate / 10
				end
				]]
				
				--进度值
				_frmNode.childUI["proggressValueLabel" .. i] = hUI.label:new({
					parent = _parentNode,
					size = 26,
					x = ACTIVITY_DX + 85 + 40 + 320,
					y = reward_posY + 1,
					width = 500,
					align = "RC",
					font = hVar.FONTC,
					text = "0" .. "/" .. rate,
					border = 1,
				})
				_frmNode.childUI["proggressValueLabel" .. i].handle.s:setColor(ccc3(255, 212, 128))
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "proggressValueLabel" .. i
				
				--进度菊花
				_frmNode.childUI["proggressWaiting" .. i] = hUI.image:new({
					parent = _parentNode,
					size = 20,
					x = ACTIVITY_DX + 85 + 40 + 320,
					y = reward_posY,
					model = "MODEL_EFFECT:waiting",
					w = 36,
					h = 36,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "proggressWaiting" .. i
				
				--进度完成的勾勾
				_frmNode.childUI["proggressFinish" .. i] = hUI.image:new({
					parent = _parentNode,
					size = 20,
					x = ACTIVITY_DX + 85 + 40 + 320 - 30,
					y = reward_posY + 2,
					model = "UI:FinishTag2",
					scale = 1.0,
				})
				_frmNode.childUI["proggressFinish" .. i].handle._n:setRotation(15)
				_frmNode.childUI["proggressFinish" .. i].handle.s:setVisible(false) --默认隐藏
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "proggressFinish" .. i
				
				--[[
				--已领取的图标
				_frmNode.childUI["rewardIcon" .. i .. "_" .. m].childUI["finishTag"] = hUI.image:new({
					parent = _frmNode.childUI["rewardIcon" .. i .. "_" .. m].handle._n,
					model = "UI:FinishTag",
					x = 0,
					y = 0,
					scale = 1.0,
				})
				_frmNode.childUI["rewardIcon" .. i .. "_" .. m].childUI["finishTag"].handle._n:setRotation(15)
				]]
			end
			
			--如果存在档位奖励，查询进度
			if (#activityAwards > 0) then
				--print("如果存在档位奖励，查询进度")
				--发起查询，本条活动的完成进度
				SendCmdFunc["get_ActivityRate"](activityId, activityType)
			end
		end
		
		--ptype:10026: taptap留言活动
		if (activityType == 10026) then
			local btnname = activityAwards[1].btnname --按钮名字
			local link = activityAwards[1].link --链接url
			local sub_btnname = activityAwards[1].sub_btnname --子按钮名字
			local sub_link = activityAwards[1].sub_link --子按钮跳转的链接url
			local sub_notice = activityAwards[1].sub_notice --子按钮点击后提示的文字
			
			--[[
			--先强行设置为未查看此活动
			--检测活动的状态
			local activityState = 0 --活动状态(0:未开始 / 1:进行中 / 2:已结束)
			if (activityBeginDate > 0) then
				activityState = 0
			elseif (activityEndDate < 0) then
				activityState = 2
			else
				activityState = 1
			end
			if (activityState == 1) then --活动正在进行中
				LuaRemoveActivityAid(g_curPlayerName, activityId)
			end
			]]
			
			--跳转到帖子的按钮
			_frmNode.childUI["btnToTaptap"] = hUI.button:new({
				parent = _parentNode,
				x = ACTIVITY_DX + 200,
				y = ACTIVITY_DY - 460,
				model = "misc/chest/itembtn2.png",
				dragbox = _frm.childUI["dragBox"],
				label = {font = hVar.FONTC, border = 1, x = 0, y = 2, size = 28, text = btnname,}, --"去taptap讨论"
				scaleT = 0.95,
				scale = 1.4,
				code = function()
					--点链接了，才认为查看过此活动
					--LuaAddActivityAid(g_curPlayerName, activityId)
					
					--隐藏叹号
					--_frmNode.childUI["btnToTaptap"].childUI["tanhao"].handle._n:setVisible(false)
					
					--触发事件：刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
					hGlobal.event:event("LocalEvent_RefreshMedalStateUI")
					
					--跳转链接
					xlOpenUrl(link)
				end,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnToTaptap"
			
			--存在子按钮
			if (sub_btnname ~= nil) and (sub_btnname ~= "") then
				--子按钮
				_frmNode.childUI["btnToThank"] = hUI.button:new({
					parent = _parentNode,
					x = ACTIVITY_DX + 200 + 180,
					y = ACTIVITY_DY - 460 - 1,
					model = "misc/mask.png",
					dragbox = _frm.childUI["dragBox"],
					--label = {font = hVar.FONTC, border = 1, x = 0, y = -2, size = 24, text = sub_btnname,}, --"去taptap讨论"
					scaleT = 0.95,
					scale = 1.0,
					w = 140,
					h = 60,
					code = function()
						--冒字
						if (sub_notice ~= nil) and (sub_notice ~= "") then
							local strText = sub_notice
							--local strText = hVar.tab_string["ios_err_network_cannot_conn"] --language
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
						
						--跳转子链接
						if (sub_link ~= nil) and (sub_link ~= "") then
							--跳转链接
							xlOpenUrl(sub_link)
						end
					end,
				})
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "btnToThank"
				_frmNode.childUI["btnToThank"].handle.s:setOpacity(0) --只挂载子控件，不显示
				--九宫格
				local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/button_yellow_small.png", 0, 0, 120, 52, _frmNode.childUI["btnToThank"])
				--子按钮名称
				_frmNode.childUI["btnToThank"].childUI["name"] = hUI.label:new({
					parent = _frmNode.childUI["btnToThank"].handle._n,
					x = 0,
					y = -2,
					size = 24,
					text = sub_btnname,
					border = 1,
					font = hVar.FONTC,
					align = "MC",
				})
			end
		end
		
	end
	
	--函数：收到活动进度事件
	on_receive_activity_progress_event = function(aid, ptype, progresList)
		local _frm = hGlobal.UI.PhoneActivityNewFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local listI = current_ActivityList[current_selectedIdx]  or {} --第i项
		local activityId = listI.aid --活动id
		local activityType = listI.ptype --活动类型
		local activityName = listI.title --活动名称
		local activityAwards = listI.prize --活动奖励表
		local activityDesc = listI.describe --活动描述
		local activityBeginDate = tonumber(listI.time_begin) --活动开始时间
		local activityEndDate = tonumber(listI.time_end) --活动结束时间
		
		--防止别的活动进度回调跑进来，做个校验
		--print(aid, ptype, progresList[1])
		if (aid == activityId) and (ptype == activityType) then
			--ptype:10026: taptap留言活动，特殊处理界面
			if (activityType == 10026) then
				--不走此流程
				--...
			else
				for i = 1, #activityAwards, 1 do
					local rate = activityAwards[i].rate --档位需要的值
					local prize = activityAwards[i].prize --档位的奖励道具
					local value = progresList[i] or progresList[1] or 0 --当前进度
					
					if (activityType == 100) then  --累计充值金币
						--这里文字改为游戏币计算
						--rate = rate * 10
						--value = value * 10
					end
					
					--本档位最大就是完成的值
					if (value > rate) then
						value = rate
					end
					local progress = value .. "/" .. rate
					
					_frmNode.childUI["proggressValueLabel" .. i]:setText(progress)
					
					--隐藏菊花
					_frmNode.childUI["proggressWaiting" .. i].handle.s:setVisible(false)
					
					--进度完成显示勾勾
					if (value >= rate) then
						_frmNode.childUI["proggressFinish" .. i].handle.s:setVisible(true)
						_frmNode.childUI["proggressValueLabel" .. i]:setText("")
					else
						_frmNode.childUI["proggressFinish" .. i].handle.s:setVisible(false)
					end
					
					--[[
					--测试 --test
					_ActivityTipChildUI["proggressFinish" .. i].handle.s:setVisible(true)
					]]
				end
			end
		end
	end
	
	--函数：横竖屏切换
	on_spine_screen_event = function()
		local _frm = hGlobal.UI.PhoneActivityNewFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--关闭本界面
		OnClosePanel()
		
		--重绘本界面
		hGlobal.UI.InitActivityNewFrm("reload") --测试
		--触发事件，显示活动界面
		hGlobal.event:event("LocalEvent_Phone_ShowActivityNewFrm", current_funcCallback)
	end
	
	--函数：获得第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离
	getUpDownOffset = function()
		local _frm = hGlobal.UI.PhoneActivityNewFrm
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
			delta1_ly = btn1_ly + 61 --第一个DLC地图面板距离上侧边界的距离
		end
		
		--最后一个DLC地图面板的数据
		local DLCMapInfoBtnN = _frmNode.childUI["DLCMapInfoNode" .. current_DLCMap_max_num]
		local btnN_cx, btnN_cy = 0, 0 --最后一个DLC地图面板中心点位置
		local btnN_ry = 0 --最后一个DLC地图面板最下侧的x坐标
		local deltNa_ry = 0 --最后一个DLC地图面板距离下侧边界的距离
		if DLCMapInfoBtnN then
			btnN_cx, btnN_cy = DLCMapInfoBtnN.data.x, DLCMapInfoBtnN.data.y --最后一个DLC地图面板中心点位置
			btnN_ry = btnN_cy - DLCMAPINFO_HEIGHT / 2 --最后一个DLC地图面板最下侧的x坐标
			deltNa_ry = btnN_ry + 530 + 101 --最后一个DLC地图面板距离下侧边界的距离
		end
		
		--print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
		
		return delta1_ly, deltNa_ry
	end
	
	--函数: 动态加载资源
	__DynamicAddRes = function()
		local _frm = hGlobal.UI.PhoneActivityNewFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		--print("函数: 动态加载资源")
		
		--加载资源
		--动态加载宝物背景图
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/task/events_panel.png")
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/task/events_panel.png")
			print("加载活动背景大图！")
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
		local _frm = hGlobal.UI.PhoneActivityNewFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--删除资源
		--删除竞技场背景图
		_childUI["panel_bg"].handle._n:removeChild(_childUI["panel_bg"].data.pSprite, true)
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/task/events_panel.png")
		if texture then
			CCTextureCache:sharedTextureCache():removeTexture(texture)
			print("清空活动背景大图！")
		end
	end
	
	--函数：更新提示当前哪个分页可以有领取的了
	RefreshTaskAchievementFinishPage = function()
		local _frm = hGlobal.UI.PhoneActivityNewFrm
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
hGlobal.event:listen("clearPhoneChestFrm", "__CloseActivityFrm", function()
	if hGlobal.UI.PhoneActivityNewFrm then
		if (hGlobal.UI.PhoneActivityNewFrm.data.show == 1) then
			--关闭本界面
			OnClosePanel()
		end
	end
end)

--监听打开活动（新）界面通知事件
hGlobal.event:listen("LocalEvent_Phone_ShowActivityNewFrm", "__ShowActivityNewFrm", function(callback, bOpenImmediate)
	hGlobal.UI.InitActivityNewFrm("reload")
	
	--触发事件，显示积分、金币界面
	--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
	
	--直接打开
	if bOpenImmediate then
		--存储回调事件
		current_funcCallback = callback
		
		--显示活动（新）界面
		hGlobal.UI.PhoneActivityNewFrm:show(1)
		hGlobal.UI.PhoneActivityNewFrm:active()
		
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
			--存储回调事件
			current_funcCallback = callback
			
			--显示活动（新）界面
			hGlobal.UI.PhoneActivityNewFrm:show(1)
			hGlobal.UI.PhoneActivityNewFrm:active()
			
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
			local _frm = hGlobal.UI.PhoneActivityNewFrm
			local dx = BOARD_WIDTH
			_frm:setXY(_frm.data.x + dx, _frm.data.y)
		end)
		
		--步骤2: 动画进入控件
		local actM2 = CCCallFunc:create(function()
			--本面板
			local _frm = hGlobal.UI.PhoneActivityNewFrm
			
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
		local _frm = hGlobal.UI.PhoneActivityNewFrm
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
--test
--[[
--测试代码
if hGlobal.UI.PhoneActivityNewFrm then --删除上一次的活动（新）界面
	hGlobal.UI.PhoneActivityNewFrm:del()
	hGlobal.UI.PhoneActivityNewFrm = nil
end
hGlobal.UI.InitActivityNewFrm("reload") --测试创建DLC地图界面
--触发事件，显示DLC地图界面
--current_NET_SHOP_MAP_DLC = { [1] = 84, [2] = 84, [3] = 84, [4] = 84, [5] = 84,}
--current_NET_SHOP_MAP_DLC = { [1] = 84}
hGlobal.event:event("LocalEvent_Phone_ShowActivityNewFrm", "world/td_dlc_50")
]]

