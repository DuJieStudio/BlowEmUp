




local BOARD_WIDTH = 720 --随机迷宫地图面板面板的宽度
local BOARD_HEIGHT = 720 --随机迷宫地图面板面板的高度
local BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 0
local BOARD_OFFSETY = 0 --随机迷宫地图面板面板y偏移中心点的值
local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --随机迷宫地图面板面板的x位置（最左侧）
local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --随机迷宫地图面板面板的y位置（最顶侧）

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

--临时UI管理
local leftRemoveFrmList = {} --左侧控件集
local rightRemoveFrmList = {} --右侧控件集
local _removeLeftFrmFunc = hApi.DoNothing --清空左侧所有的临时控件
local _removeRightFrmFunc = hApi.DoNothing --清空右侧所有的临时控件

--局部函数
local OnClickPageBtn = hApi.DoNothing --点击分页按钮
local RefreshSelectedCardFrame = hApi.DoNothing --更新绘制当前查看的卡牌的信息

--分页1：显示随机迷宫地图界面
local OnCreateDLCMapInfoFrame = hApi.DoNothing --创建随机迷宫地图界面（第1个分页）
--local OnCreateDLCMapInfoFrame_LeftPart = hApi.DoNothing --绘制左侧随机迷宫地图包列表界面
--local OnCreateDLCMapInfoFrame_RightPart = hApi.DoNothing --显示某个随机迷宫地图包的详细信息
--local OnRefresnDLCMapInfoFrame_LeftPart = hApi.DoNothing --刷新左侧随机迷宫地图包列表界面
--local refresh_dlcmapinfo_UI_loop = hApi.DoNothing --刷新随机迷宫地图面板界面的滚动
--local on_receive_DLCMapInfo_Back = hApi.DoNothing --收到购买随机迷宫地图包的回调事件
local on_close_MapInfo_Panel = hApi.DoNothing --关闭某一关的地图信息的回调事件
--local OnClickMapButton = hApi.DoNothing --点击指定地图按钮
--local OnClickDifficultyButton = hApi.DoNothing --点击指定难度按钮
local on_receive_billboardT_event = hApi.DoNothing --收到排行榜静态数据模板的回调
local on_receive_require_battle_randommap_ret = hApi.DoNothing --收到请求挑战随机迷宫地图事件返回
local on_receive_resume_battle_randommap_ret = hApi.DoNothing --收到继续挑战随机迷宫地图事件返回
local on_spine_screen_event = hApi.DoNothing --横竖屏切换
local OnClickBattleButton = hApi.DoNothing --点击进入战役按钮
local OnClickRankButton = hApi.DoNothing --点击排行榜按钮
local OnClickUGCEditButton = hApi.DoNothing --点击随机迷宫生成器按钮
local OnClosePanel = hApi.DoNothing --关闭本界面
--local getUpDownOffset = hApi.DoNothing --获得第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离

--分页1：随机迷宫地图包的参数
local DLCMAPINFO_WIDTH = 120 --随机迷宫地图包宽度
local DLCMAPINFO_HEIGHT = 120 --随机迷宫地图包高度
local DLCMAPINFO_OFFSET_X = -10 --随机迷宫地图包统一偏移x
local DLCMAPINFO_OFFSET_Y = 28 --随机迷宫地图包统一偏移y
local DLCMAPINFO_BOARD_HEIGHT = 570 --随机迷宫地图包高度
local DLCMAPINFO_X_NUM = 1 --随机迷宫地图面板x的数量
local DLCMAPINFO_Y_NUM = 3 --随机迷宫地图面板y的数量
local MAX_SPEED = 50 --最大速度

--可变参数
local current_selectedIdx = 0 --上次选中的地图索引
local current_selectedDifficulty = 0 --上次选中的地图难度
local current_DLCMap_max_num = 0 --最大的随机迷宫地图包数量
--local current_NET_SHOP_MAP_DLC = {}

local current_bId = 1 --随机迷宫排行榜id
local current_billboardT = nil --随机迷宫今日难度配置表

--控制参数
local click_pos_x_dlcmapinfo = 0 --开始按下的坐标x
local click_pos_y_dlcmapinfo = 0 --开始按下的坐标y
local last_click_pos_y_dlcmapinfo = 0 --上一次按下的坐标x
local last_click_pos_y_dlcmapinfo = 0 --上一次按下的坐标y
local draggle_speed_y_dlcmapinfo = 0 --当前滑动的速度x
local selected_dlcmapinfoEx_idx = 0 --选中的随机迷宫地图面板ex索引
local click_scroll_dlcmapinfo = false --是否在滑动随机迷宫地图面板中
local b_need_auto_fixing_dlcmapinfo = false --是否需要自动修正
local friction_dlcmapinfo = 0 --阻力

local current_funcCallback = nil --关闭后的回调事件
--local current_strEnterMapName = nil --进入时指定选中的地图名
--local current_nEnterMapDifficulty = nil --进入时指定选中的地图难度

local _bCanCreate = true --防止重复创建

--当前选中的记录
local CurrentSelectRecord = {pageIdx = 0, contentIdx = 0, cardId = 0,} --当前选择的分页、数据项的信息记录


--随机迷宫地图信息面板
hGlobal.UI.InitRandomMapInfoFrm = function(mode)
	local tInitEventName = {"LocalEvent_EnterRandTestMap", "__ShowRandomMapFrm",}
	if (mode ~= "reload") then
		--return tInitEventName
		return
	end
	
	--不重复创建随机迷宫地图信息面板
	if hGlobal.UI.PhoneRandomMapInfoFrm then --随机迷宫地图信息面板
		hGlobal.UI.PhoneRandomMapInfoFrm:del()
		hGlobal.UI.PhoneRandomMapInfoFrm = nil
	end
	
	--[[
	--取消监听打开随机迷宫地图信息界面通知事件
	hGlobal.event:listen("LocalEvent_EnterRandTestMap", "__ShowRandomMapFrm", nil)
	--取消监听切场景把自己藏起来
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld", "__Phone_UI__HideRandomMapInfo", nil)
	--取消监听关闭宝箱界面事件
	hGlobal.event:listen("clearPhoneChestFrm", "__CloseRandomMapFrm", nil)
	]]
	
	BOARD_WIDTH = 720 --随机迷宫地图面板面板的宽度
	BOARD_HEIGHT = 720 --随机迷宫地图面板面板的高度
	BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 0
	BOARD_OFFSETY = 0 --随机迷宫地图面板面板y偏移中心点的值
	BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --随机迷宫地图面板面板的x位置（最左侧）
	BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --随机迷宫地图面板面板的y位置（最顶侧）
	--横屏模式
	if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
		BOARD_WIDTH = 740 --DLC地图面板面板的宽度
		BOARD_HEIGHT = 690 --DLC地图面板面板的高度
		BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 20
		BOARD_OFFSETY = 15 --DLC地图面板面板y偏移中心点的值
		BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --DLC地图面板面板的x位置（最左侧）
		BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --DLC地图面板面板的y位置（最顶侧）
	end
	
	--加载资源
	--xlLoadResourceFromPList("data/image/misc/pvp.plist")
	
	hApi.clearTimer("__DLC_MAPINFO_UPDATE__")
	
	--创建随机迷宫地图信息面板
	hGlobal.UI.PhoneRandomMapInfoFrm = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 2,
		show = 0, --一开始不显示
		border = 0, --显示frame边框
		--background = "panel/panel_part_00.png", --"UI:Tactic_Background",
		background = -1, --"misc/addition/story_panel.png",
		--background = "UI:tip_item",
		--background = "UI:Tactic_Background",
		--background = "UI:herocardfrm",
		autoactive = 0,
		
		--点击事件
		codeOnTouch = function(self, x, y, sus)
			--在外部点击
			if (sus == 0) then
				hGlobal.event:event("LocalEvent_RecoverBarrage")
				self.childUI["closeBtn"].data.code()
			end
		end,
	})
	
	local _frm = hGlobal.UI.PhoneRandomMapInfoFrm
	local _parent = _frm.handle._n
	
	--左侧裁剪区域
	local _BTC_PageClippingRect = {0, 0, 720, 720, 0} -- {x, y, w, h, ???}
	local _BTC_pClipNode_dlc = hApi.CreateClippingNode_Diablo(_frm, _BTC_PageClippingRect, 99, _BTC_PageClippingRect[5], "_BTC_pClipNode_dlc")
	
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
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		model = "misc/mask.png",
		x = BOARD_WIDTH - 50 + 2000, --不显示了,
		y = -60,
		w = 86,
		h = 86,
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
	
	--每个分页按钮
	--随机迷宫地图面板
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
		
		--[[
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
		]]
		
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
		local _frm = hGlobal.UI.PhoneRandomMapInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneRandomMapInfoFrm
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
			--_frm.childUI["PageBtn" .. i].childUI["Text"].handle.s:setVisible(true) --显示文字
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
		--移除事件监听：收到排行榜静态数据模板的回调
		hGlobal.event:listen("localEvent_refresh_billboardT", "__QueryRandomMapBoardT", nil)
		--移除事件监听：收到请求挑战娱乐地图结果返回
		hGlobal.event:listen("LocalEvent_RequireEntertamentNormalRet", "__RequireRandomMapRet", nil)
		--移除事件监听：收到继续挑战娱乐地图结果返回（随机迷宫）
		hGlobal.event:listen("LocalEvent_ResumeeEntertamentNormalRet", "__ResumeRandomMapRet", nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenRandomMap_", nil)
		
		--移除timer
		hApi.clearTimer("__DLC_MAPINFO_UPDATE__")
		
		--隐藏所有的clipNode
		hApi.EnableClipByName_Diablo(_frm, "_BTC_pClipNode_dlc", 0)
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：随机迷宫地图信息
			--创建随机迷宫地图信息分页
			OnCreateDLCMapInfoFrame(pageIndex)
		end
		
		--标记当前选择的分页和页内的第几个
		CurrentSelectRecord.pageIdx = pageIndex
		CurrentSelectRecord.contentIdx = 1 --默认选中第一个
	end
	
	--函数：关闭本界面
	OnClosePanel = function()
		local _frm = hGlobal.UI.PhoneRandomMapInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--不显示随机迷宫地图信息面板
		hGlobal.UI.PhoneRandomMapInfoFrm:show(0)
		
		--关闭界面后不需要监听的事件
		--取消监听：
		--...
		
		--清空切换分页之后取消的监听事件
		--移除事件监听：收到请求挑战娱乐地图结果返回
		hGlobal.event:listen("LocalEvent_RequireEntertamentNormalRet", "__RequireRandomMapRet", nil)
		--移除事件监听：收到继续挑战娱乐地图结果返回（随机迷宫）
		hGlobal.event:listen("LocalEvent_ResumeeEntertamentNormalRet", "__ResumeRandomMapRet", nil)
		--移除事件监听：收到排行榜静态数据模板的回调
		hGlobal.event:listen("localEvent_refresh_billboardT", "__QueryRandomMapBoardT", nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenRandomMap_", nil)
		
		--清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--删除DLC界面下拉滚动timer
		hApi.clearTimer("__DLC_MAPINFO_UPDATE__")
		
		--隐藏所有的clipNode
		hApi.EnableClipByName_Diablo(_frm, "_BTC_pClipNode_dlc", 0)
		
		--关闭金币、积分界面
		hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
		
		--触发事件：关闭了主菜单按钮
		--hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
		
		--释放png, plist的纹理缓存（这里不清理也可以）
		--hApi.ReleasePngTextureCache()
		
		--允许再次打开
		_bCanCreate = true
	end
	
	--函数：创建随机迷宫地图信息界面（第1个分页）
	OnCreateDLCMapInfoFrame = function(pageIdx)
		local _frm = hGlobal.UI.PhoneRandomMapInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--允许本分页的的clipNode
		hApi.EnableClipByName_Diablo(_frm, "_BTC_pClipNode_dlc", 1)
		
		--初始化参数
		current_selectedIdx = 1 --上次选中的地图索引
		current_selectedDifficulty = 0 --上次选中的地图难度
		current_DLCMap_max_num = 0 --最大的随机迷宫地图面板id
		
		--初始化数据
		current_billboardT = nil
		
		--local i = 3
		
		--左侧裁剪区域
		--local _BTC_PageClippingRect = {0, -82, 1000, 408, 0}
		--local _BTC_pClipNode_dlc = hApi.CreateClippingNode(_parentNode, _BTC_PageClippingRect, 99, _BTC_PageClippingRect[5])
		
		--太空仓背景图
		_frmNode.childUI["DLCMapInfoTripImg"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/task/randommap_space_lift.png",
			x = DLCMAPINFO_OFFSET_X + 520,
			y = DLCMAPINFO_OFFSET_Y - 350,
			scale = 1.3,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTripImg"
		
		--消耗的体力值
		_frmNode.childUI["DLCMapInfoTiliLabel"] = hUI.label:new({
			parent = _parentNode,
			size = 28,
			x = DLCMAPINFO_OFFSET_X + 554 - 20,
			y = DLCMAPINFO_OFFSET_Y - 350 - 240,
			width = 300,
			align = "LMC",
			font = "numWhite",
			text = "1",
			border = 0,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTiliLabel"

		_frmNode.childUI["commentBtn"] = hUI.button:new({
			parent = _parentNode,
			x = DLCMAPINFO_OFFSET_X + 540 - 204,
			y = DLCMAPINFO_OFFSET_Y - 350 + 30,
			w = 70,
			h = 80,
			model = "misc/button_null.png",
			scaleT = 0.9,
			dragbox = _frm.childUI["dragBox"],
			code = function()
				--关闭本界面
				OnClosePanel()
		
				--由关闭按钮触发的关闭，不能再次打开
				_bCanCreate = false

				hGlobal.event:event("LocalEvent_DoCommentProcess",{})
			end,
		})
		_frmNode.childUI["commentBtn"].childUI["img"] = hUI.button:new({
			parent = _frmNode.childUI["commentBtn"].handle._n,
			model = "misc/addition/commentbtn.png",
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTiliLabel"
		
		--排行榜按钮
		_frmNode.childUI["RankBtn"] = hUI.button:new({
			parent = _parentNode,
			x = DLCMAPINFO_OFFSET_X + 540 + 110,
			y = DLCMAPINFO_OFFSET_Y - 350 + 16,
			--model = "misc/chest/dragon_start_game.png",
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			--label = {text = "START", size = 34, font = hVar.FONTC, border = 1, x = 0, y = 3, RGB = {52, 79, 62,},},
			w = 160,
			h = 140,
			align = "MC",
			scaleT = 0.95,
			code = function()
				--点击排行榜按钮
				OnClickRankButton()
			end,
		})
		_frmNode.childUI["RankBtn"].handle.s:setOpacity(0) --只挂载子控件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "RankBtn"
		--排行榜按钮图片
		_frmNode.childUI["RankBtn"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["RankBtn"].handle._n,
			x = 0,
			y = 0,
			model = "misc/task/randommap_maze_ranking.png",
			scale = 1.3,
		})
		
		--随机迷宫生成器按钮
		_frmNode.childUI["UGCEditBtn"] = hUI.button:new({
			parent = _parentNode,
			x = DLCMAPINFO_OFFSET_X + 540 + 110,
			y = DLCMAPINFO_OFFSET_Y - 350 + 164,
			--model = "misc/chest/dragon_start_game.png",
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			--label = {text = "START", size = 34, font = hVar.FONTC, border = 1, x = 0, y = 3, RGB = {52, 79, 62,},},
			w = 160,
			h = 140,
			align = "MC",
			scaleT = 0.95,
			code = function()
				--点击随机迷宫生成器按钮
				OnClickUGCEditButton()
			end,
		})
		_frmNode.childUI["UGCEditBtn"].handle.s:setOpacity(0) --只挂载子控件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "UGCEditBtn"
		--随机迷宫生成器按钮图片
		_frmNode.childUI["UGCEditBtn"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["UGCEditBtn"].handle._n,
			x = 0,
			y = 0,
			model = "misc/task/randommap_maze_lift.png",
			scale = 1.3,
		})
		
		--开始按钮
		_frmNode.childUI["BeginBtn"] = hUI.button:new({
			parent = _parentNode,
			x = DLCMAPINFO_OFFSET_X + 540 - 6 - 20,
			y = DLCMAPINFO_OFFSET_Y - 350 - 146,
			--model = "misc/chest/dragon_start_game.png",
			model = "misc/mask.png",
			dragbox = _frm.childUI["dragBox"],
			--label = {text = "START", size = 34, font = hVar.FONTC, border = 1, x = 0, y = 3, RGB = {52, 79, 62,},},
			w = 160,
			h = 90,
			align = "MC",
			scaleT = 0.95,
			code = function()
				--点击进入随机迷宫按钮
				OnClickBattleButton()
			end,
		})
		_frmNode.childUI["BeginBtn"].handle.s:setOpacity(0) --只挂载子控件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "BeginBtn"
		--开始按钮动画图片
		_frmNode.childUI["BeginBtn"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["BeginBtn"].handle._n,
			x = 0,
			y = 0,
			model = "MODEL_EFFECT:StartAmin2",
			scale = 1,
		})
		
		--添加事件监听：商城信息返回
		--hGlobal.event:listen("localEvent_refresh_shopinfo", "__OnReceiveShopItemRet", on_receive_shop_iteminfo_back_event)
		--添加事件监听：收到排行榜静态数据模板的回调
		hGlobal.event:listen("localEvent_refresh_billboardT", "__QueryRandomMapBoardT", on_receive_billboardT_event)
		--添加事件监听：收到请求挑战娱乐地图结果返回
		hGlobal.event:listen("LocalEvent_RequireEntertamentNormalRet", "__RequireRandomMapRet", on_receive_require_battle_randommap_ret)
		--添加事件监听：收到继续挑战娱乐地图结果返回（随机迷宫）
		hGlobal.event:listen("LocalEvent_ResumeeEntertamentNormalRet", "__ResumeRandomMapRet", on_receive_resume_battle_randommap_ret)
		--添加移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenRandomMap_", on_spine_screen_event)
		
		--只有在本分页才会有的timer
		--hApi.addTimerForever("__SHOP_TIMER_PAGE_BUYITEM__", hVar.TIMER_MODE.GAMETIME, 1000, on_refresh_shop_buyitem_lefttime_timer)
		
		--挡操作
		--hUI.NetDisable(30000)
		
		--发起查询排行榜静态数据
		--print("发起查询排行榜静态数据1",bId)
		local bId = current_bId
		SendCmdFunc["get_billboardT"](bId)
	end
	
	--函数：点击排行榜按钮
	OnClickRankButton = function()
		local _frm = hGlobal.UI.PhoneRandomMapInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--关闭本界面
		OnClosePanel()
		
		--由关闭按钮触发的关闭，不能再次打开
		_bCanCreate = false
		
		local bId = 1
		local callback = function()
			--触发事件，显示随机迷宫界面
			local bOpenImmediate = true
			hGlobal.event:event("LocalEvent_EnterRandTestMap", current_funcCallback, bOpenImmediate)
		end
		hGlobal.event:event("LocalEvent_Phone_ShowRandomMapRankInfoFrm", bId, callback)
	end
	
	--函数：点击随机迷宫生成器按钮
	OnClickUGCEditButton = function()
		local _frm = hGlobal.UI.PhoneRandomMapInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--横屏模式不支持
		if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
			local strText = hVar.tab_string["__TEXT_UGCEDIT_HORIZONTAL"] --language
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
		OnClosePanel()
		
		--由关闭按钮触发的关闭，不能再次打开
		_bCanCreate = false
		
		--显示ugc界面
		local bOpenImmediate = true
		hGlobal.event:event("LocalEvent_Phone_ShowUserDefMapFrm", bOpenImmediate)
	end
	
	--函数：点击进入随机迷宫按钮
	OnClickBattleButton = function()
		local _frm = hGlobal.UI.PhoneRandomMapInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--检测gameserver版本号是否为最新
		if (not hApi.CheckGameServerVersionControl()) then
			return
		end
		
		--如果未获取到难度配置，不能开始战斗
		if (current_billboardT == nil) then
			--提示文字
			--local strText = "正在获取地图信息" --language
			local strText = hVar.tab_string["__TEXT_MapInfoGetting"]  --language
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
		
		--检测是否继续上一次的存档进度
		local randommapFlag = 0
		--读取随机迷宫缓存信息（防止闪退记录的第n-1小关的进度信息）
		local tInfo = LuaGetRandommapInfo(g_curPlayerName)
		if (type(tInfo) == "table") then
			randommapFlag = tInfo.randommapFlag or 0
		end
		if (randommapFlag == 1) then --有历史存档
			--使用历史存档
			local onclickevent_ok = function()
				print("使用历史存档")
				
				--检测存档里的日期是否为今日
				--客户端的时间
				local localTime = os.time()
				--服务器的时间
				local hostTime = localTime - g_localDeltaTime --客户端和服务器的时间误差(Local = Host + deltaTime)
				--转化为北京时间
				local localTimeZone = hApi.get_timezone() --获得本地的时区(GMT+?)
				local delteZone = localTimeZone - hVar.SYS_TIME_ZONE --与北京时间的时差
				hostTime = hostTime - delteZone * 3600 --服务器时间(北京时区)
				--此刻的年月日（北京时间）
				local tabNow = os.date("*t", hostTime)
				local yearNow = tabNow.year
				local monthNow = tabNow.month
				local dayNow = tabNow.day
				
				--存档时间
				print("savedataTime=", tInfo.time)
				local savedataTime = hApi.GetNewDate(tInfo.time)
				local tabOld = os.date("*t", savedataTime)
				local yearOld = tabOld.year
				local monthOld = tabOld.month
				local dayOld = tabOld.day
				
				--日期一致
				if (yearNow == yearOld) and (monthNow == monthOld) and (dayNow == dayOld) then
					--使用历史数据
					--挡操作
					hUI.NetDisable(30000)
					
					--发送指令，请求挑战随机迷宫
					local MapName = tInfo.mapName or ""
					local MapDifficulty = tInfo.mapDifficulty or 0
					local MapBattleId = tInfo.mapBattleId or 0
					print("MapName=", MapName)
					print("MapDifficulty=", MapDifficulty)
					print("MapBattleId=", MapBattleId)
					SendCmdFunc["require_resume_entertament"](MapName, MapDifficulty, MapBattleId)
				else --日期不一致
					--弹框
					local strText = hVar.tab_string["__TEXT_RANDOMMAP_OUTDATE"] --"您上次挑战天梯迷宫的时间太久，已过了有效时限，无法继续！"
					hGlobal.UI.MsgBox(strText,{
						font = hVar.FONTC,
						ok = function()
							--清空随机迷宫缓存信息（防止闪退记录的第n-1小关的进度信息）
							--读取存档日期不一致
							LuaClearRandommapInfo(g_curPlayerName)
						end,
					})
				end
			end
			
			--使用全新数据
			local onclickevent_cancel = function()
				print("使用全新数据")
				
				--清空随机迷宫缓存信息（防止闪退记录的第n-1小关的进度信息）
				--选择不读取存档
				LuaClearRandommapInfo(g_curPlayerName)
				
				--挡操作
				hUI.NetDisable(30000)
				
				--发送指令，请求挑战随机迷宫
				local MapName = hVar.RandomMap
				local MapDifficulty = 0
				SendCmdFunc["require_battle_entertament"](MapName, MapDifficulty)
			end
			
			local MsgSelections = nil
			MsgSelections = {
				style = "mini",
				select = 0,
				ok = onclickevent_ok,
				cancel = onclickevent_cancel,
				--cancelFun = cancelCallback, --点否的回调函数
				--textOk = "继续进度",
				textOk = hVar.tab_string["__TEXT_RANDOMMAP_CONTINUE"], --language
				--textCancel = "重头开始", --language
				textCancel = hVar.tab_string["__TEXT_RANDOMMAP_RESTART"], --language
				userflag = 0, --用户的标记
			}
			local msgBox = hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_RANDOMMAP_LOADSAVEDATA"], MsgSelections) --"您上次挑战天梯迷宫异常退出，是否继续上次的进度？"
			msgBox:active()
			msgBox:show(1,"fade",{time=0.08})
		else --无历史存档
			--挡操作
			hUI.NetDisable(30000)
			
			--发送指令，请求挑战随机迷宫
			local MapName = hVar.RandomMap
			local MapDifficulty = 0
			SendCmdFunc["require_battle_entertament"](MapName, MapDifficulty)
		end
	end
	
	--收到排行榜静态数据模板的回调（第1个、第2个分页）
	on_receive_billboardT_event = function(bId, billboardT)
		local _frm = hGlobal.UI.PhoneRandomMapInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--取消挡操作
		hUI.NetDisable(0)
		
		local pageIndex = CurrentSelectRecord.pageIdx
		
		--只处理本分页的
		if (current_bId == bId) then
			--存储
			current_billboardT = billboardT
			
			--测试 --test
			--[[
			billboardT.info[bId].prize.lv_tower = 2
			billboardT.info[bId].prize.lv_tactic = 3
			billboardT.info[bId].prize.ban_hero = {18001,18003,18002,}
			billboardT.info[bId].prize.ban_tower = {1018, 1019,}
			billboardT.info[bId].prize.ban_tactic = {1039, 1040,}
			billboardT.info[bId].prize.diff_tactic = {{1201, 4,}, {1205, 2,},}
			]]
			
			--读取数据部分
			--塔的最高等级
			local lv_tower = billboardT.info[bId].prize.lv_tower
			
			--战术卡的最高等级
			local lv_tactic = billboardT.info[bId].prize.lv_tactic
			
			--禁用的英雄
			local ban_hero = billboardT.info[bId].prize.ban_hero
			
			--禁用的塔
			local ban_tower = billboardT.info[bId].prize.ban_tower
			
			--禁用的战术卡
			local ban_tactic = billboardT.info[bId].prize.ban_tactic
			
			--敌人增益buff
			local diff_tactic = billboardT.info[bId].prize.diff_tactic
			
			--绘制本次的敌人增益buff 1
			if (diff_tactic) and (#diff_tactic > 0) then
				--有禁用的敌人增益buff
				for idx = 1, #diff_tactic, 1 do
					local tacticId = diff_tactic[idx] and diff_tactic[idx][1] or 0
					local tacticLv = diff_tactic[idx] and diff_tactic[idx][2] or 1
					print("diff_tactic", idx, tacticId, tacticLv)
					
					--[[
					--将本周的buff高亮选中
					hApi.safeRemoveT(_frmNode.childUI["labCombatCover"].childUI, "selebtbox")
					local offsetX = current_diffBuffOffset[tacticId].offsetX
					local offsetY = current_diffBuffOffset[tacticId].offsetY
					_frmNode.childUI["labCombatCover"].childUI["selebtbox"] = hUI.image:new({
						parent = _frmNode.childUI["labCombatCover"].handle._n,
						x = offsetX,
						y = offsetY,
						model = "misc/chariotconfig/tough_learned_06.png",
						align = "MC",
						scale = 1.0,
					})
					--current_diffBuffOffset
					]]
				end
			end
		end
	end
	
	--函数：收到请求挑战娱乐地图结果返回
	on_receive_require_battle_randommap_ret = function(result, pvpcoin, mapName, mapDiff, battlecfg_id)
		local _frm = hGlobal.UI.PhoneRandomMapInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("on_receive_require_battle_randommap_ret", result, pvpcoin, mapName, mapDiff, battlecfg_id)
		
		--操作成功
		if (result == 1) then
			if (mapName == hVar.RandomMap) then --是随机迷宫地图
				--关闭金币、积分界面
				--hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
				
				--隐藏自身面板
				hGlobal.UI.PhoneRandomMapInfoFrm:show(0)
				--_frm.childUI["closeBtn"].data.code()
				
				--关闭本界面
				OnClosePanel()
				
				--能再次打开
				_bCanCreate = true
				
				--进入随机迷宫
				local banLimitTable = {battlecfg_id = battlecfg_id,}
				
				if current_billboardT then
					local bId = current_bId
					banLimitTable.diff_tactic = current_billboardT.info[bId].prize.diff_tactic
				end
				
				--如果是vip5，带入一张雕像道具卡
				local vipLv = LuaGetPlayerVipLv()
				local itemId = 12029
				local itemLv = 1
				local itemNum = hVar.Vip_Conifg.ironmanItemSkillNum[vipLv]or 0
				if (itemNum > 0) then
					banLimitTable.ironman = {itemId = itemId, itemLv = itemLv, itemNum = itemNum,}
					--print("如果是vip5，带入一张雕像道具卡", itemNum)
				end
				
				GameManager.GameStart(hVar.GameType.FOURSR, nil, banLimitTable)
			end
		end
	end
	
	--函数：收到继续挑战娱乐地图结果返回
	on_receive_resume_battle_randommap_ret = function(result, mapName, mapDiff, battlecfg_id)
		local _frm = hGlobal.UI.PhoneRandomMapInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("on_receive_resume_battle_randommap_ret", result, mapName, mapDiff, battlecfg_id)
		
		--操作成功
		if (result == 1) then
			if (mapName == hVar.RandomMap) then --是随机迷宫地图
				--关闭金币、积分界面
				--hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
				
				--隐藏自身面板
				hGlobal.UI.PhoneRandomMapInfoFrm:show(0)
				--_frm.childUI["closeBtn"].data.code()
				
				--关闭本界面
				OnClosePanel()
				
				--能再次打开
				_bCanCreate = true
				
				--进入随机迷宫
				local banLimitTable = {battlecfg_id = battlecfg_id,}
				
				if current_billboardT then
					local bId = current_bId
					banLimitTable.diff_tactic = current_billboardT.info[bId].prize.diff_tactic
				end
				
				--geyachao: 注意，这里是继续游戏，之前雕像卡已经使用过了
				--[[
				--如果是vip5，带入一张雕像道具卡
				local vipLv = LuaGetPlayerVipLv()
				local itemId = 12029
				local itemLv = 1
				local itemNum = hVar.Vip_Conifg.ironmanItemSkillNum[vipLv]or 0
				if (itemNum > 0) then
					banLimitTable.ironman = {itemId = itemId, itemLv = itemLv, itemNum = itemNum,}
					--print("如果是vip5，带入一张雕像道具卡", itemNum)
				end
				]]
				
				--读取随机迷宫缓存信息（防止闪退记录的第n-1小关的进度信息）
				local tInfo = LuaGetRandommapInfo(g_curPlayerName)
				
				GameManager.GameStart(hVar.GameType.FOURSR, tInfo, banLimitTable)
			end
		end
	end
	
	--函数：横竖屏切换
	on_spine_screen_event = function()
		local _frm = hGlobal.UI.PhoneRandomMapInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--关闭本界面
		OnClosePanel()
		
		--重绘本界面
		hGlobal.UI.InitRandomMapInfoFrm("reload") --测试
		--触发事件，显示随机迷宫界面
		hGlobal.event:event("LocalEvent_EnterRandTestMap", current_funcCallback)
	end
	
	--函数：关闭某一关的地图信息的回调事件
	on_close_MapInfo_Panel = function(map_name)
		--触发事件，显示积分、金币界面
		hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
		
		--显示随机迷宫地图信息界面
		hGlobal.UI.PhoneRandomMapInfoFrm:show(1)
		hGlobal.UI.PhoneRandomMapInfoFrm:active()
	end
end


--监听打开随机迷宫地图信息界面通知事件
hGlobal.event:listen("LocalEvent_EnterRandTestMap", "__ShowRandomMapFrm", function(callback, bOpenImmediate)
	hGlobal.UI.InitRandomMapInfoFrm("reload")
	
	--直接打开
	if bOpenImmediate then
		--动态加载漩涡背景图
		--
		
		--存储回调事件
		current_funcCallback = callback
		--current_strEnterMapName = strEnterMapName --进入时指定选中的地图名
		--current_nEnterMapDifficulty = nEnterMapDifficulty --进入时指定选中的地图难度
		
		--显示随机迷宫地图信息界面
		hGlobal.UI.PhoneRandomMapInfoFrm:show(1)
		hGlobal.UI.PhoneRandomMapInfoFrm:active()
		
		--打开上一次的分页（默认显示第1个分页:随机迷宫地图面板）
		local lastPageIdx = CurrentSelectRecord.pageIdx
		if (lastPageIdx == 0) then
			lastPageIdx = 1
		end
		
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
		
		--步骤0，预加载漩涡图
		local actM0 = CCCallFunc:create(function()
			--动态加载漩涡背景图
			--
		end)
		
		--步骤1: 绘制第一个分页，并将控件设置成初始位置（屏幕外，为步骤二播放动画做准备）
		local actM1 = CCCallFunc:create(function()
			--触发事件，显示积分、金币界面
			--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
			
			--存储回调事件
			current_funcCallback = callback
			--current_strEnterMapName = strEnterMapName --进入时指定选中的地图名
			--current_nEnterMapDifficulty = nEnterMapDifficulty --进入时指定选中的地图难度
			
			--显示随机迷宫地图信息界面
			hGlobal.UI.PhoneRandomMapInfoFrm:show(1)
			hGlobal.UI.PhoneRandomMapInfoFrm:active()
			
			--打开上一次的分页（默认显示第1个分页:随机迷宫地图面板）
			local lastPageIdx = CurrentSelectRecord.pageIdx
			if (lastPageIdx == 0) then
				lastPageIdx = 1
			end
			
			CurrentSelectRecord.pageIdx = 0
			CurrentSelectRecord.contentIdx = 0
			OnClickPageBtn(lastPageIdx)
			
			--[[
			--连接pvp服务器
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
			
			--初始设置坐标
			--主面板设置到左侧屏幕外面
			local _frm = hGlobal.UI.PhoneRandomMapInfoFrm
			local dx = BOARD_WIDTH
			_frm:setXY(BOARD_POS_X + dx, BOARD_POS_Y)
		end)
		
		--步骤2: 动画进入控件
		local actM2 = CCCallFunc:create(function()
			--本面板
			local _frm = hGlobal.UI.PhoneRandomMapInfoFrm
			
			--往左做运动
			local px, py = BOARD_POS_X + BOARD_WIDTH, BOARD_POS_Y
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
		aM:addObject(actM0)
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

--切场景把自己藏起来
hGlobal.event:listen("LocalEvent_PlayerFocusWorld", "__Phone_UI__HideRandomMapInfo", function(sSceneType, oWorld, oMap)
	if hGlobal.UI.PhoneRandomMapInfoFrm then
		if (hGlobal.UI.PhoneRandomMapInfoFrm.data.show == 1) then
			--隐藏自己
			OnClosePanel()
		end
		
		--允许再次打开
		_bCanCreate = true
	end
end)

--监听关闭宝箱界面事件
hGlobal.event:listen("clearPhoneChestFrm", "__CloseRandomMapFrm", function()
	if hGlobal.UI.PhoneRandomMapInfoFrm then
		if (hGlobal.UI.PhoneRandomMapInfoFrm.data.show == 1) then
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
if hGlobal.UI.PhoneRandomMapInfoFrm then --删除上一次的随机迷宫地图信息界面
	hGlobal.UI.PhoneRandomMapInfoFrm:del()
	hGlobal.UI.PhoneRandomMapInfoFrm = nil
end
hGlobal.UI.InitRandomMapInfoFrm("reload") --测试创建随机迷宫地图界面
--触发事件，显示随机迷宫地图界面
hGlobal.event:event("LocalEvent_EnterRandTestMap")
]]

