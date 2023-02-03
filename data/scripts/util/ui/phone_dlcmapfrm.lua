



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
local rightRemoveFrmList = {} --右侧控件集
local _removeLeftFrmFunc = hApi.DoNothing --清空左侧所有的临时控件
local _removeRightFrmFunc = hApi.DoNothing --清空右侧所有的临时控件

--局部函数
local OnClickPageBtn = hApi.DoNothing --点击分页按钮
local RefreshSelectedCardFrame = hApi.DoNothing --更新绘制当前查看的卡牌的信息

--分页1：显示DLC地图界面
local OnCreateDLCMapInfoFrame = hApi.DoNothing --创建DLC地图界面（第1个分页）
--local OnCreateDLCMapInfoFrame_LeftPart = hApi.DoNothing --绘制左侧DLC地图包列表界面
local OnCreateDLCMapInfoFrame_RightPart = hApi.DoNothing --显示某个DLC地图包的详细信息
--local OnRefresnDLCMapInfoFrame_LeftPart = hApi.DoNothing --刷新左侧DLC地图包列表界面
--local refresh_dlcmapinfo_UI_loop = hApi.DoNothing --刷新DLC地图面板界面的滚动
--local on_receive_DLCMapInfo_Back = hApi.DoNothing --收到购买DLC地图包的回调事件
local on_spine_screen_event = hApi.DoNothing --横竖屏切换
local on_close_MapInfo_Panel = hApi.DoNothing --关闭某一关的地图信息的回调事件
local OnClickMapButton = hApi.DoNothing --点击指定地图按钮
--local OnClickDifficultyButton = hApi.DoNothing --点击指定难度按钮
local on_receive_require_battle_normal_ret = hApi.DoNothing --收到请求挑战普通剧情地图事件返回
local OnClickBattleButton = hApi.DoNothing --点击进入战役按钮
local OnClosePanel = hApi.DoNothing --关闭本界面
--local getUpDownOffset = hApi.DoNothing --获得第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离

--分页1：DLC地图包的参数
local DLCMAPINFO_WIDTH = 120 --DLC地图包宽度
local DLCMAPINFO_HEIGHT = 120 --DLC地图包高度
local DLCMAPINFO_OFFSET_X = -10 --DLC地图包统一偏移x
local DLCMAPINFO_OFFSET_Y = 28 --DLC地图包统一偏移y
local DLCMAPINFO_BOARD_HEIGHT = 570 --DLC地图包高度
local DLCMAPINFO_X_NUM = 1 --DLC地图面板x的数量
local DLCMAPINFO_Y_NUM = 3 --DLC地图面板y的数量
local MAX_SPEED = 50 --最大速度

--可变参数
local current_selectedIdx = 0 --上次选中的地图索引
local current_selectedDifficulty = 0 --上次选中的地图难度
local current_DLCMap_max_num = 0 --最大的DLC地图包数量
local current_NET_SHOP_MAP_DLC = {}

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

local current_mapName = nil --地图名
local current_funcCallback = nil --关闭后的回调事件
local current_strEnterMapName = nil --进入时指定选中的地图名
local current_nEnterMapDifficulty = nil --进入时指定选中的地图难度

local _bCanCreate = true --防止重复创建

--当前选中的记录
local CurrentSelectRecord = {pageIdx = 0, contentIdx = 0, cardId = 0,} --当前选择的分页、数据项的信息记录



--DLC地图信息面板
hGlobal.UI.InitDLCMapInfoFrm = function(mode)
	local tInitEventName = {"LocalEvent_Phone_ShowDLCMapInfoFrm", "__ShowDLCMapFrm",}
	if (mode ~= "reload") then
		--return tInitEventName
		return
	end
	
	--不重复创建DLC地图信息面板
	if hGlobal.UI.PhoneDLCMapInfoFrm then --DLC地图信息面板
		hGlobal.UI.PhoneDLCMapInfoFrm:del()
		hGlobal.UI.PhoneDLCMapInfoFrm = nil
	end
	
	--[[
	--取消监听打开DLC地图信息界面通知事件
	hGlobal.event:listen("LocalEvent_Phone_ShowDLCMapInfoFrm", "__ShowDLCMapFrm", nil)
	--取消监切场景把自己藏起来
	hGlobal.event:listen("LocalEvent_PlayerFocusWorld", "__Phone_UI__HideDLCMapInfo", nil)
	--取消监听关闭宝箱界面事件
	hGlobal.event:listen("clearPhoneChestFrm", "__CloseDLCMapFrm", nil)
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
	
	--加载资源
	--xlLoadResourceFromPList("data/image/misc/pvp.plist")
	
	hApi.clearTimer("__DLC_MAPINFO_UPDATE__")
	
	--创建DLC地图信息面板
	hGlobal.UI.PhoneDLCMapInfoFrm = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 2,
		show = 0, --一开始不显示
		border = 0, --显示frame边框
		--background = "panel/panel_part_00.png", --"UI:Tactic_Background",
		background = "misc/addition/story_panel.png",
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
	
	local _frm = hGlobal.UI.PhoneDLCMapInfoFrm
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
		x = BOARD_WIDTH - 50,
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

	--评论按钮
	_frm.childUI["btn_comment"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		--label = {text = hVar.tab_string["__TEXT_comment"],size = 24,font = hVar.FONTC,y = 2,},
		model = "misc/addition/commentbtn.png",
		x = BOARD_WIDTH / 2 - 12,
		y = -BOARD_HEIGHT + 38,
		scale = 0.9,
		scaleT = 0.95,
		code = function()
			hGlobal.event:event("LocalEvent_DoCommentProcess")
			_frm.childUI["closeBtn"].data.code()
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
		local _frm = hGlobal.UI.PhoneDLCMapInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.PhoneDLCMapInfoFrm
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
		--移除事件监听：购买DLC地图包成功事件（恢复存档也会走进来）
		hGlobal.event:listen("LocalEvent_Phone_ShowDLCMapInfoFrm_Back", "__PhoneRefreshMapInfoFrm", nil)
		--移除事件监听：关闭查看某一关介绍的面板
		hGlobal.event:listen("LocalEvent_Phone_HideMapInfoFrm", "__PhoneCloseMapInfoFrm", nil)
		--移除事件监听：收到请求挑战普通剧情地图结果返回
		hGlobal.event:listen("LocalEvent_RequireBattleNormalRet", "__RequireBattleNormalRet", nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenBattleNormal_", nil)
		
		--移除timer
		hApi.clearTimer("__DLC_MAPINFO_UPDATE__")
		
		--隐藏所有的clipNode
		hApi.EnableClipByName_Diablo(_frm, "_BTC_pClipNode_dlc", 0)
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：DLC地图信息
			--创建DLC地图信息分页
			OnCreateDLCMapInfoFrame(pageIndex)
		end
		
		--标记当前选择的分页和页内的第几个
		CurrentSelectRecord.pageIdx = pageIndex
		CurrentSelectRecord.contentIdx = 1 --默认选中第一个
	end
	
	--函数：关闭本界面
	OnClosePanel = function()
		local _frm = hGlobal.UI.PhoneDLCMapInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--不显示DLC地图信息面板
		hGlobal.UI.PhoneDLCMapInfoFrm:show(0)
		
		--关闭界面后不需要监听的事件
		--取消监听：
		--...
		
		--清空切换分页之后取消的监听事件
		--移除事件监听：购买DLC地图包成功事件（恢复存档也会走进来）
		hGlobal.event:listen("LocalEvent_Phone_ShowDLCMapInfoFrm_Back", "__PhoneRefreshMapInfoFrm", nil)
		--移除事件监听：关闭查看某一关介绍的面板
		hGlobal.event:listen("LocalEvent_Phone_HideMapInfoFrm", "__PhoneCloseMapInfoFrm", nil)
		--移除事件监听：收到请求挑战普通剧情地图结果返回
		hGlobal.event:listen("LocalEvent_RequireBattleNormalRet", "__RequireBattleNormalRet", nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenBattleNormal_", nil)
		
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
	
	--函数：创建DLC地图信息界面（第1个分页）
	OnCreateDLCMapInfoFrame = function(pageIdx)
		local _frm = hGlobal.UI.PhoneDLCMapInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--允许本分页的的clipNode
		hApi.EnableClipByName_Diablo(_frm, "_BTC_pClipNode_dlc", 1)
		
		--初始化参数
		current_selectedIdx = 1 --上次选中的地图索引
		current_selectedDifficulty = 0 --上次选中的地图难度
		current_DLCMap_max_num = 0 --最大的DLC地图面板id
		
		--local i = 3
		
		--左侧裁剪区域
		--local _BTC_PageClippingRect = {0, -82, 1000, 408, 0}
		--local _BTC_pClipNode_dlc = hApi.CreateClippingNode(_parentNode, _BTC_PageClippingRect, 99, _BTC_PageClippingRect[5])
		
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
		
		--默认选中第i个DLC地图包，显示本地图包的详细信息
		local idxEx = 1
		OnCreateDLCMapInfoFrame_RightPart(idxEx)
		
		--默认是第1个地图，普通难度，如果传入参数，那么选中指定地图和难度
		local idx = 1
		local difficulty = 0
		if current_strEnterMapName then
			local shopId = current_NET_SHOP_MAP_DLC[idxEx] --DLC地图包的道具商店id
			--print("shopId=", shopId)
			local shopItemT = hVar.tab_shopitem[shopId] or {}
			if (shopItemT) then
				local itemId = shopItemT.itemID --道具id
				--print("itemId=", itemId)
				local tabI = hVar.tab_item[itemId] or {}
				local score = shopItemT.score or 0 --需要的积分
				local rmb = shopItemT.rmb or 0 --需要对游戏币
				local bagName = tabI.bagName --地图包的地图名
				--print("bagName=", bagName)
				local mapInfo = hVar.MAP_INFO[bagName]
				local icon = mapInfo.icon --地图包的图标
				local childMap = mapInfo.childMap --地图包的所有子地图
				for i = 1, #childMap, 1 do
					local childMapName = childMap[i] --子地图的名字
					if (childMapName == current_strEnterMapName) then --找到了
						idx = i
						break
					end
				end
			end
		end
		if current_nEnterMapDifficulty then
			difficulty = current_nEnterMapDifficulty
		end
		OnClickMapButton(idx, difficulty)
	end
	
	--函数：显示某个DLC地图包的详细信息（右半部分）
	OnCreateDLCMapInfoFrame_RightPart = function(idxEx)
		local _frm = hGlobal.UI.PhoneDLCMapInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--不重复显示
		if (CurrentSelectRecord.contentIdx == idxEx) then
			return
		end
		
		--标记选中本次
		local lastSelectedContentIdx = CurrentSelectRecord.contentIdx
		CurrentSelectRecord.contentIdx = idxEx
		--print(lastSelectedContentIdx, idxEx)
		
		local shopId = current_NET_SHOP_MAP_DLC[idxEx] --DLC地图包的道具商店id
		--print("shopId=", shopId)
		local shopItemT = hVar.tab_shopitem[shopId] or {}
		if (shopItemT) then
			local itemId = shopItemT.itemID --道具id
			--print("itemId=", itemId)
			local tabI = hVar.tab_item[itemId] or {}
			local score = shopItemT.score or 0 --需要的积分
			local rmb = shopItemT.rmb or 0 --需要对游戏币
			local bagName = tabI.bagName --地图包的地图名
			--print("bagName=", bagName)
			local mapInfo = hVar.MAP_INFO[bagName]
			local icon = mapInfo.icon --地图包的图标
			local childMap = mapInfo.childMap --地图包的所有子地图
			local buyConditionMap = mapInfo.buyCondition and mapInfo.buyCondition.map --地图包的购买条件需要通关的地图
			local starReward = mapInfo.starReward or {} --地图包产出的奖励内容
			local nUnlockDLCMapState = (LuaCheckPlayerDLCMap(bagName) or 0) --是否获得次地图包(1:获得 / 0:未获得 / 2:不存在)
			
			--[[
			--隐藏上一次的选中框、标题白色颜色
			if (lastSelectedContentIdx > 0) then
				_frmNode.childUI["DLCMapInfoNode" .. lastSelectedContentIdx].childUI["selectbox"].handle.s:setVisible(false)
				_frmNode.childUI["DLCMapInfoNode" .. lastSelectedContentIdx].childUI["mapName"].handle.s:setColor(ccc3(255, 255, 255))
			end
			
			--显示选中框、标题黄色颜色
			--print("idxEx", idxEx, _frmNode.childUI["DLCMapInfoNode" .. idxEx], _frmNode.childUI["DLCMapInfoNode" .. idxEx].childUI["selectbox"])
			_frmNode.childUI["DLCMapInfoNode" .. idxEx].childUI["selectbox"].handle.s:setVisible(true)
			_frmNode.childUI["DLCMapInfoNode" .. idxEx].childUI["mapName"].handle.s:setColor(ccc3(255, 255, 0))
			]]
			
			--先清除右侧的控件集
			_removeRightFrmFunc()
			
			--开始创建本DLC地图包的详细信息
			local offsetX = 70
			local offsetY = 0
			local tMapPosTable =
			{
				[1] = {x = 110, y = -600,},
				[2] = {x = 220, y = -450,},
				[3] = {x = 130, y = -310,},
				[4] = {x = 220, y = -150,},
			}
			for i = 1, #childMap, 1 do
				local childMapName = childMap[i] --子地图的名字
				local childMapInfo = hVar.MAP_INFO[childMapName]
				local childIcon = childMapInfo.icon --地图包的图标
				--print(childIcon)
				local childUnlockMapName = childMapInfo.unLock and childMapInfo.unLock[1] --可以打本关，需要解锁的关卡名
				local childUnlockState = 0 --是否解锁
				if childUnlockMapName then
					childUnlockState = (LuaGetPlayerMapAchi(childUnlockMapName, hVar.ACHIEVEMENT_TYPE.LEVEL) or 0) --是否解锁
				else
					childUnlockState = 1 --无需解锁
				end
				--print(childMapName, childUnlockMapName, childUnlockState)
				
				--右侧子地图包的图标（按钮）
				_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i] = hUI.button:new({
					parent = _BTC_pClipNode_dlc,
					model = "misc/mask.png",
					x = DLCMAPINFO_OFFSET_X + tMapPosTable[i].x,
					y = DLCMAPINFO_OFFSET_Y + tMapPosTable[i].y,
					w = 150,
					h = 150,
					scaleT = 1.0,
					dragbox = _frm.childUI["dragBox"],
					code = function()
						--点击指定地图
						if (current_selectedIdx == i) then
							OnClickMapButton(i, current_selectedDifficulty)
						else
							OnClickMapButton(i, current_selectedDifficulty)
						end
					end,
				})
				--hApi.AddShader(_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].handle.s, "border")
				_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].handle.s:setOpacity(0) --只响应事件，不显示
				leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfo_SubMapIcon" .. i
				
				--地图底盘
				_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["childDesk"] = hUI.image:new({
					parent = _frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].handle._n,
					model = "misc/addition/stage_tray_01.png",
					x = 0,
					y = -20,
					w = 169,
					h = 82,
				})
				--未解锁
				if (childUnlockState == 0) then
					hApi.AddShader(_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["childDesk"].handle.s, "gray")
				end
				
				--地图底盘高亮
				_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["childDeskLight"] = hUI.image:new({
					parent = _frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].handle._n,
					model = "misc/addition/stage_tray_02.png",
					x = 0,
					y = -20,
					w = 169,
					h = 82,
				})
				_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["childDeskLight"].handle._n:setVisible(false) --默认隐藏
				
				--地图图标
				_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["childIcon"] = hUI.image:new({
					parent = _frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].handle._n,
					model = childIcon,
					x = 0,
					y = 10,
					w = 100,
					h = 100,
				})
				--[[
				--未解锁
				if (childUnlockState == 0) then
					hApi.AddShader(_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["childIcon"].handle.s, "gray")
				end
				]]
				
				--[[
				--右侧子地图包的名字
				_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["childNamName"] = hUI.label:new({
					parent = _frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].handle._n,
					model = "UI:star_slot",
					align = "MC",
					x = 0,
					y = 70,
					size = 26,
					border = 1,
					font = hVar.FONTC,
					width = 300,
					text = hVar.tab_stringM[childMapName] and hVar.tab_stringM[childMapName][1] or "未知地图名" .. childMapName, --childMapName
				})
				]]
				
				--[[
				--右侧子地图锁住的锁图
				--未购买，或者未通关前一关，都加锁的图标
				if (nUnlockDLCMapState ~= 1) or (childUnlockState == 0) then
					_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["lock"] = hUI.image:new({
						parent = _frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].handle._n,
						model = "UI:LOCK",
						x = 40,
						y = -30,
						w = 36,
						h = 36,
					})
					--_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["lock"].handle.s:setRotation(-90)
				end
				]]
				
				--右侧子地图包通关的星星的绘制
				--已购买，并且已解锁，才会绘制星星
				--if (nUnlockDLCMapState == 1) and (childUnlockState == 1) then
					--依次绘制星星和底图
					for k = 1, 3, 1 do
						--[[
						--依次绘制星星底图
						_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["starBG" .. k] = hUI.image:new({
							parent = _frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].handle._n,
							model = "misc/selectmap/star.png",
							align = "LT",
							x = (3 - 1) * (-15) + (k - 1) * 30,
							y = -65 - ((k%2==0) and (8) or (0)),
							scale = 1.5,--0.35,
						})
						--_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["starBG" .. k].handle.s:setOpacity(64)
						hApi.AddShader(_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["starBG" .. k].handle.s, "gray")
						]]
						
						--依次绘制星星
						_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["star" .. k] = hUI.image:new({
							parent = _frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].handle._n,
							model = "misc/selectmap/star.png",
							align = "LT",
							x = (3 - 1) * (-15) + (k - 1) * 30,
							y = -65,
							scale = 1.5,--0.35,
						})
						_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["star" .. k].handle._n:setVisible(false) --一开始隐藏
					end
					
					--[[
					--显示关卡的星星数
					local star = (LuaGetPlayerMapAchi(childMapName, hVar.ACHIEVEMENT_TYPE.MAPSTAR) or 0)
					--star = 2 --测试
					for k = 1, 3, 1 do
						if (k <= star) then --有星星
							_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["star" .. k].handle._n:setVisible(true)
							--_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["star" .. k]:setXY((star - 1) * (-10) + (k - 1) * 20, -65)
						else --没星星
							_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["star" .. k].handle._n:setVisible(false)
						end
					end
					
					--挑战难度完成情况判定
					local diffMax = (LuaGetPlayerMapAchi(childMapName, hVar.ACHIEVEMENT_TYPE.Map_Difficult) or 0) --当前挑战到了第几个难度
					--print("diffMax=", diffMax, childMapName)
					--diffMax = 3 --测试
					for n = 1, 3, 1 do
						if (n < diffMax) then --前面的挑战难度，肯定是3星，所以这里描橙
							_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["star" .. n].handle.s:setColor(ccc3(255, 140, 0))
						else
							local diffStar = (LuaGetPlayerMapAchi(childMapName, hVar.ACHIEVEMENT_TYPE.IMPERIAL) or 0) --读取当前难度的星星
							--print("diffStar=", diffStar, childMapName)
							--diffStar = 3 --测试
							if (diffStar >= 3) then --三星通关挑战难度，描橙
								_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["star" .. n].handle.s:setColor(ccc3(255, 140, 0))
							else --不是三星通关挑战难度，正常颜色
								_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["star" .. n].handle.s:setColor(ccc3(255, 255, 255))
							end
						end
					end
					]]
				--end
				
				--[[
				--不是最后一个，创建指向下一个地图的箭头
				if (i < #childMap) then
					--右侧指向下一个地图的箭头1
					_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["jiantou1" .. i] = hUI.image:new({
						parent = _frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].handle._n,
						model = "UI:Tactic_LineV",
						x = 69,
						y = -10,
						w = 12,
						h = 26,
					})
					_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["jiantou1" .. i].handle.s:setRotation(-90)
					
					--右侧指向下一个地图的箭头2
					_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["jiantou2" .. i] = hUI.image:new({
						parent = _frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].handle._n,
						model = "UI:Tactic_LineJT",
						x = 89,
						y = -10,
						w = 24,
						h = 20,
					})
					_frmNode.childUI["DLCMapInfo_SubMapIcon" .. i].childUI["jiantou2" .. i].handle.s:setRotation(-90)
				end
				]]
			end
			
			--[[
			--创建DLC地图的标题文字
			_frmNode.childUI["SubDLCMapTitle"] = hUI.label:new({
				parent = _BTC_pClipNode_dlc,
				model = childIcon,
				x = DLCMAPINFO_OFFSET_X + 370,
				y = DLCMAPINFO_OFFSET_Y + offsetY - 80,
				size = 28,
				align = "MC",
				border = 1,
				font = hVar.FONTC,
				width = 600,
				text = hVar.tab_stringM[bagName] and hVar.tab_stringM[bagName][1] or "未知地图名" .. bagName, --bagName
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "SubDLCMapTitle"
			
			--创建DLC地图的描述文字
			_frmNode.childUI["SubDLCMapInfo"] = hUI.label:new({
				parent = _BTC_pClipNode_dlc,
				model = childIcon,
				x = DLCMAPINFO_OFFSET_X + 70,
				y = DLCMAPINFO_OFFSET_Y + offsetY - 160,
				size = 28,
				align = "LT",
				border = 1,
				font = hVar.FONTC,
				width = 600,
				text = hVar.tab_stringM[bagName] and hVar.tab_stringM[bagName][2] or "未知地图说明" .. bagName, --bagName
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "SubDLCMapInfo"
			]]
			
			--漩涡
			_frmNode.childUI["SubDLCMapXuanWo"] = hUI.image:new({
				parent = _BTC_pClipNode_dlc,
				model = "MODEL_EFFECT:XuanWo",
				x = DLCMAPINFO_OFFSET_X + 360 - 200,
				y = DLCMAPINFO_OFFSET_Y + offsetY - 390,
				scale = 2,
				z = -1,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "SubDLCMapXuanWo"
			
			--右侧详细介绍的大底板
			_frmNode.childUI["SubDLCMapDetailBG"] = hUI.image:new({
				parent = _BTC_pClipNode_dlc,
				model = "misc/addition/rewards_panel.png",
				x = DLCMAPINFO_OFFSET_X + 520,
				y = DLCMAPINFO_OFFSET_Y + offsetY - 350,
				w = 334,
				h = 466,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "SubDLCMapDetailBG"
			
			--剧情按钮
			_frmNode.childUI["SubDLCMapBtnStory"] = hUI.button:new({
				parent = _BTC_pClipNode_dlc,
				model = "misc/addition/difficulty_01.png",
				x = DLCMAPINFO_OFFSET_X + 520 - 128 + 84 * 0,
				y = DLCMAPINFO_OFFSET_Y + offsetY - 580,
				scale = 1.26,
				scaleT = 0.95,
				dragbox = _frm.childUI["dragBox"],
				code = function()
					--点击指定地图
					OnClickMapButton(current_selectedIdx, 0)
				end,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "SubDLCMapBtnStory"
			
			--挑战1按钮
			_frmNode.childUI["SubDLCMapBtnDiff1"] = hUI.button:new({
				parent = _BTC_pClipNode_dlc,
				model = "misc/addition/difficulty_02.png",
				x = DLCMAPINFO_OFFSET_X + 520 - 128 + 84 * 1,
				y = DLCMAPINFO_OFFSET_Y + offsetY - 580,
				scale = 1.26,
				scaleT = 0.95,
				dragbox = _frm.childUI["dragBox"],
				code = function()
					--点击指定地图
					OnClickMapButton(current_selectedIdx, 1)
				end,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "SubDLCMapBtnDiff1"
			
			--挑战2按钮
			_frmNode.childUI["SubDLCMapBtnDiff2"] = hUI.button:new({
				parent = _BTC_pClipNode_dlc,
				model = "misc/addition/difficulty_03.png",
				x = DLCMAPINFO_OFFSET_X + 520 - 128 + 84 * 2,
				y = DLCMAPINFO_OFFSET_Y + offsetY - 580,
				scale = 1.26,
				scaleT = 0.95,
				dragbox = _frm.childUI["dragBox"],
				code = function()
					--点击指定地图
					OnClickMapButton(current_selectedIdx, 2)
				end,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "SubDLCMapBtnDiff2"
			
			--挑战3按钮
			_frmNode.childUI["SubDLCMapBtnDiff3"] = hUI.button:new({
				parent = _BTC_pClipNode_dlc,
				model = "misc/addition/difficulty_04.png",
				x = DLCMAPINFO_OFFSET_X + 520 - 128 + 84 * 3,
				y = DLCMAPINFO_OFFSET_Y + offsetY - 580,
				scale = 1.26,
				scaleT = 0.95,
				dragbox = _frm.childUI["dragBox"],
				code = function()
					--点击指定地图
					OnClickMapButton(current_selectedIdx, 3)
				end,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "SubDLCMapBtnDiff3"
		end
		
		--添加事件监听：收到请求挑战普通剧情地图结果返回
		hGlobal.event:listen("LocalEvent_RequireBattleNormalRet", "__RequireBattleNormalRet", on_receive_require_battle_normal_ret)
		--添加事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenBattleNormal_", on_spine_screen_event)
	end
	
	--函数：点击指定地图
	OnClickMapButton = function(index, mapDifficulty)
		local _frm = hGlobal.UI.PhoneDLCMapInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--[[
		--不重复选择相同的地图
		if (current_selectedIdx == index) then
			return
		end
		]]
		
		--删除右侧控件
		_removeRightFrmFunc()
		
		--存储本次的索引
		local lastIdx = current_selectedIdx
		current_selectedIdx = index
		
		--初始化难度
		current_selectedDifficulty = mapDifficulty
		
		local shopId = current_NET_SHOP_MAP_DLC[1] --DLC地图包的道具商店id
		--print("shopId=", shopId)
		local shopItemT = hVar.tab_shopitem[shopId] or {}
		local itemId = shopItemT.itemID --道具id
		local tabI = hVar.tab_item[itemId] or {}
		local bagName = tabI.bagName --地图包的地图名
		local mapInfo = hVar.MAP_INFO[bagName]
		local childMap = mapInfo.childMap --地图包的所有子地图
		local childMapName = childMap[index]
		local tabM = hVar.MAP_INFO[childMapName] or {}
		local icon_title = tabM.icon_title --子地图的标题图片
		print("index=", index)
		print("childMapName=", childMapName)
		print("mapDifficulty=", mapDifficulty)
		
		local childUnlockMapName = tabM.unLock and tabM.unLock[1] --可以打本关，需要解锁的关卡名
		local childUnlockState = 0 --是否可解锁
		local finishStar = 0 --本关当前难度获得的星星数量
		if (mapDifficulty == 0) then --剧情模式
			finishStar = (LuaGetPlayerMapAchi(childMapName, hVar.ACHIEVEMENT_TYPE.MAPSTAR) or 0)
		elseif (mapDifficulty == 1) then --挑战1
			finishStar = (LuaGetPlayerMapAchi(childMapName, hVar.ACHIEVEMENT_TYPE.RICHMAN) or 0)
		elseif (mapDifficulty == 2) then --挑战2
			finishStar = (LuaGetPlayerMapAchi(childMapName, hVar.ACHIEVEMENT_TYPE.BLITZ) or 0)
		elseif (mapDifficulty == 3) then --挑战3
			finishStar = (LuaGetPlayerMapAchi(childMapName, hVar.ACHIEVEMENT_TYPE.IMPERIAL) or 0)
		end
		print("finishStar=", finishStar)
		
		if (finishStar > 0) then --本关指定难度已经有星星了
			childUnlockState = 1
		else --本关指定难度还未获得星星
			if childUnlockMapName then --有前置关卡
				local finishStarPrev = 0 --本关前一关难度获得的星星数量
				if (mapDifficulty == 0) then --剧情模式
					finishStarPrev = (LuaGetPlayerMapAchi(childUnlockMapName, hVar.ACHIEVEMENT_TYPE.MAPSTAR) or 0)
				elseif (mapDifficulty == 1) then --挑战1
					finishStarPrev = (LuaGetPlayerMapAchi(childMapName, hVar.ACHIEVEMENT_TYPE.MAPSTAR) or 0)
				elseif (mapDifficulty == 2) then --挑战2
					finishStarPrev = (LuaGetPlayerMapAchi(childMapName, hVar.ACHIEVEMENT_TYPE.RICHMAN) or 0)
				elseif (mapDifficulty == 3) then --挑战3
					finishStarPrev = (LuaGetPlayerMapAchi(childMapName, hVar.ACHIEVEMENT_TYPE.BLITZ) or 0)
				end
				
				if (finishStarPrev > 0) then
					childUnlockState = 1
				end
			else --无前置关卡
				local finishStarPrev = 0 --本关前一关难度获得的星星数量
				if (mapDifficulty == 0) then --剧情模式
					finishStarPrev = 1
				elseif (mapDifficulty == 1) then --挑战1
					finishStarPrev = (LuaGetPlayerMapAchi(childMapName, hVar.ACHIEVEMENT_TYPE.MAPSTAR) or 0)
				elseif (mapDifficulty == 2) then --挑战2
					finishStarPrev = (LuaGetPlayerMapAchi(childMapName, hVar.ACHIEVEMENT_TYPE.RICHMAN) or 0)
				elseif (mapDifficulty == 3) then --挑战3
					finishStarPrev = (LuaGetPlayerMapAchi(childMapName, hVar.ACHIEVEMENT_TYPE.BLITZ) or 0)
				end
				
				if (finishStarPrev > 0) then
					childUnlockState = 1
				end
			end
		end
		print("childUnlockState=", childUnlockState)
		
		--上次选中的地图normal
		if (lastIdx > 0) then
			local ctrlILast = _frmNode.childUI["DLCMapInfo_SubMapIcon" .. lastIdx]
			if ctrlILast then
				--[[
				hApi.AddShader(ctrlILast.handle.s, "normal")
				ctrlILast.childUI["childNamName"].handle.s:setColor(ccc3(255, 255, 255))
				]]
				ctrlILast.childUI["childDeskLight"].handle._n:setVisible(false)
			end
		end
		
		--本次选中的border
		local ctrlI = _frmNode.childUI["DLCMapInfo_SubMapIcon" .. index]
		if ctrlI then
			--[[
			hApi.AddShader(ctrlI.handle.s, "outline")
			--hApi.AddShader(ctrlI.handle.s, "border")
			ctrlI.childUI["childNamName"].handle.s:setColor(ccc3(0, 255, 0))
			]]
			ctrlI.childUI["childDeskLight"].handle._n:setVisible(true)
		end
		
		--更新左侧地图包的每个地图的星星数
		for m = 1, #childMap, 1 do
			local childMapName_m = childMap[m]
			local finishStar = 0
			if (mapDifficulty == 0) then --剧情模式
				finishStar = (LuaGetPlayerMapAchi(childMapName_m, hVar.ACHIEVEMENT_TYPE.MAPSTAR) or 0)
			elseif (mapDifficulty == 1) then --挑战1
				finishStar = (LuaGetPlayerMapAchi(childMapName_m, hVar.ACHIEVEMENT_TYPE.RICHMAN) or 0)
			elseif (mapDifficulty == 2) then --挑战2
				finishStar = (LuaGetPlayerMapAchi(childMapName_m, hVar.ACHIEVEMENT_TYPE.BLITZ) or 0)
			elseif (mapDifficulty == 3) then --挑战3
				finishStar = (LuaGetPlayerMapAchi(childMapName_m, hVar.ACHIEVEMENT_TYPE.IMPERIAL) or 0)
			end
			
			local ctrlm = _frmNode.childUI["DLCMapInfo_SubMapIcon" .. m]
			if ctrlm then
				for k = 1, 3, 1 do
					if (k <= finishStar) then --有星星
						_frmNode.childUI["DLCMapInfo_SubMapIcon" .. m].childUI["star" .. k].handle._n:setVisible(true)
					else --没星星
						_frmNode.childUI["DLCMapInfo_SubMapIcon" .. m].childUI["star" .. k].handle._n:setVisible(false)
					end
				end
			end
		end
		
		--刷新按钮的状态
		if (mapDifficulty == 0) then --剧情
			_frmNode.childUI["SubDLCMapBtnStory"].handle.s:setColor(ccc3(255, 255, 255))
			_frmNode.childUI["SubDLCMapBtnDiff1"].handle.s:setColor(ccc3(168, 168, 168))
			_frmNode.childUI["SubDLCMapBtnDiff2"].handle.s:setColor(ccc3(168, 168, 168))
			_frmNode.childUI["SubDLCMapBtnDiff3"].handle.s:setColor(ccc3(168, 168, 168))
		elseif (mapDifficulty == 1) then --难度1
			_frmNode.childUI["SubDLCMapBtnStory"].handle.s:setColor(ccc3(168, 168, 168))
			_frmNode.childUI["SubDLCMapBtnDiff1"].handle.s:setColor(ccc3(255, 255, 255))
			_frmNode.childUI["SubDLCMapBtnDiff2"].handle.s:setColor(ccc3(168, 168, 168))
			_frmNode.childUI["SubDLCMapBtnDiff3"].handle.s:setColor(ccc3(168, 168, 168))
		elseif (mapDifficulty == 2) then --难度2
			_frmNode.childUI["SubDLCMapBtnStory"].handle.s:setColor(ccc3(168, 168, 168))
			_frmNode.childUI["SubDLCMapBtnDiff1"].handle.s:setColor(ccc3(168, 168, 168))
			_frmNode.childUI["SubDLCMapBtnDiff2"].handle.s:setColor(ccc3(255, 255, 255))
			_frmNode.childUI["SubDLCMapBtnDiff3"].handle.s:setColor(ccc3(168, 168, 168))
		elseif (mapDifficulty == 3) then --难度3
			_frmNode.childUI["SubDLCMapBtnStory"].handle.s:setColor(ccc3(168, 168, 168))
			_frmNode.childUI["SubDLCMapBtnDiff1"].handle.s:setColor(ccc3(168, 168, 168))
			_frmNode.childUI["SubDLCMapBtnDiff2"].handle.s:setColor(ccc3(168, 168, 168))
			_frmNode.childUI["SubDLCMapBtnDiff3"].handle.s:setColor(ccc3(255, 255, 255))
		end
		
		local offsetX = 70
		local offsetY = 0
		
		--地图标题
		if icon_title then
			_frmNode.childUI["SubDLCMapTitle"] = hUI.image:new({
				parent = _BTC_pClipNode_dlc,
				x = DLCMAPINFO_OFFSET_X + 522,
				y = DLCMAPINFO_OFFSET_Y + offsetY - 126,
				model = icon_title,
				scale = 1.0,
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "SubDLCMapTitle"
		else
			_frmNode.childUI["SubDLCMapTitle"] = hUI.label:new({
				parent = _BTC_pClipNode_dlc,
				x = DLCMAPINFO_OFFSET_X + 522,
				y = DLCMAPINFO_OFFSET_Y + offsetY - 138,
				size = 28,
				align = "MC",
				border = 1,
				font = hVar.FONTC,
				width = 600,
				text = hVar.tab_stringM[childMapName] and hVar.tab_stringM[childMapName][1] or "未知地图名" .. childMapName, --childMapName
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "SubDLCMapTitle"
		end
		
		--[[
		--奖励经验值
		_frmNode.childUI["SubDLCMapExpIcon"] = hUI.image:new({
			parent = _BTC_pClipNode_dlc,
			model = "misc/skillup/exp.png", --改成经验值
			x = DLCMAPINFO_OFFSET_X + 410,
			y = DLCMAPINFO_OFFSET_Y + offsetY - 220 + 2,
			scale = 1.0,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "SubDLCMapExpIcon"
		]]
		
		--local tabM = hVar.MAP_INFO[childMapName]
		--[[
		--奖励经验值增加值
		local expAdd = tabM.exp or 0
		if (mapDifficulty == 1) then --挑战1
			expAdd = math.floor(expAdd * 1.1)
		elseif (mapDifficulty == 2) then --挑战2
			expAdd = math.floor(expAdd * 1.2)
		elseif (mapDifficulty == 3) then --挑战3
			expAdd = math.floor(expAdd * 1.3)
		end
		_frmNode.childUI["SubDLCMapExpValue"] = hUI.label:new({
			parent = _BTC_pClipNode_dlc,
			x = DLCMAPINFO_OFFSET_X + 460,
			y = DLCMAPINFO_OFFSET_Y + offsetY - 220,
			size = 26,
			align = "LC",
			border = 1,
			font = "num",
			width = 600,
			text = "+" .. expAdd,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "SubDLCMapExpValue"
		]]
		
		--[[
		--首通奖励
		_frmNode.childUI["SubDLCMapRewardPrfix"] = hUI.label:new({
			parent = _BTC_pClipNode_dlc,
			x = DLCMAPINFO_OFFSET_X + 380,
			y = DLCMAPINFO_OFFSET_Y + offsetY - 300,
			size = 26,
			align = "LC",
			border = 1,
			font = hVar.FONTC,
			width = 600,
			text = "首通",
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "SubDLCMapRewardPrfix"
		]]
		
		--依次绘制首通奖励
		--local tabM = hVar.MAP_INFO[childMapName]
		--print(childMapName)
		local starReward = nil
		if (mapDifficulty == 0) then --剧情
			starReward = tabM.starReward or {}
		elseif (mapDifficulty > 0) then --难度1~难度3
			starReward = tabM.DiffMode[mapDifficulty].starReward or {}
		end
		for m = 1, #starReward, 1 do
			local rewardT = starReward[m]
			if rewardT then
				local rewardType = rewardT[1] or 0 --奖励类型
				local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
				
				--奖励物品的图标按钮（只用于响应事件，不显示）
				_frmNode.childUI["rewardIcon_" .. m] = hUI.button:new({
					parent = _BTC_pClipNode_dlc,
					model = "misc/mask.png",
					x = DLCMAPINFO_OFFSET_X + 420 + (m - 1) * (96 + 4),
					y = DLCMAPINFO_OFFSET_Y + offsetY - 310 + 30,
					z = 1,
					w = 96,
					h = 96,
					scaleT = 0.95,
					dragbox = _frm.childUI["dragBox"],
					code = function()
						--显示各种类型的奖励的tip
						hApi.ShowRewardTip(rewardT)
					end,
				})
				_frmNode.childUI["rewardIcon_" .. m].data.prize = rewardT --存储奖励数据
				_frmNode.childUI["rewardIcon_" .. m].handle.s:setOpacity(0) --默认不显示（只用于响应事件，不显示）
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "rewardIcon_" .. m
				
				--[[
				--物品底图
				_frmNode.childUI["rewardIcon_" .. m].childUI["iconBG"] = hUI.image:new({
					parent = _frmNode.childUI["rewardIcon_" .. m].handle._n,
					model = "misc/chest/astro_btnbg.png",
					x = 0,
					y = 0,
					w = 96,
					h = 96,
				})
				]]
				
				--物品图标
				local scale = 2.1
				_frmNode.childUI["rewardIcon_" .. m].childUI["icon"] = hUI.image:new({
					parent = _frmNode.childUI["rewardIcon_" .. m].handle._n,
					model = tmpModel,
					x = 0,
					y = 0,
					w = itemWidth * scale,
					h = itemHeight * scale,
				})
				
				--绘制奖励图标的子控件
				if sub_tmpModel then
					_frmNode.childUI["rewardIcon_" .. m].childUI["subIcon"] = hUI.image:new({
						parent = _frmNode.childUI["rewardIcon_" .. m].handle._n,
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
				local rewardNumFontSize = 26 --字体大小
				local rewardNumBorder = 0 --是否显示边框
				if (rewardNumLength == 3) then
					rewardNumFont = "numWhite" --字体
					rewardNumFontSize = 24 --字体大小
					rewardNumBorder = 0 --是否显示边框
				elseif (rewardNumLength == 4) then
					rewardNumFont = "numWhite" --字体
					rewardNumFontSize = 22 --字体大小
					rewardNumBorder = 0 --是否显示边框
				elseif (rewardNumLength == 5) then
					rewardNumFont = "numWhite" --字体
					rewardNumFontSize = 20 --字体大小
					rewardNumBorder = 0 --是否显示边框
				elseif (rewardNumLength >= 6) then
					rewardNumFont = hVar.FONTC --字体
					rewardNumFontSize = 18 --字体大小
					rewardNumBorder = 1 --是否显示边框
				end
				
				_frmNode.childUI["rewardIcon_" .. m].childUI["num"] = hUI.label:new({
					parent = _frmNode.childUI["rewardIcon_" .. m].handle._n,
					size = rewardNumFontSize,
					x = 0,
					y = -28,
					width = 500,
					align = "MC",
					font = rewardNumFont,
					text = strRewardNum,
					border = rewardNumBorder,
				})
				
				--针对战术卡碎片、宠物碎片、武器枪碎片做特殊处理，碎片图标用特别图标替换
				--print(rewardType)
				if (rewardType == 3) or (rewardType == 10) then --道具不显示数量了
					hApi.safeRemoveT(_frmNode.childUI["rewardIcon_" .. m].childUI, "num")
				end
				if (rewardType == 6) or (rewardType == 11) or (rewardType == 11) or (rewardType == 101) or (rewardType == 103) or (rewardType == 105) or (rewardType == 106) or (rewardType == 107) or (rewardType == 108) then
					if (itemNum == 1) then --碎片*1
						hApi.safeRemoveT(_frmNode.childUI["rewardIcon_" .. m].childUI, "num")
						hApi.safeRemoveT(_frmNode.childUI["rewardIcon_" .. m].childUI, "subIcon")
						
						--碎片*1的单独图标
						_frmNode.childUI["rewardIcon_" .. m].childUI["subIcon"] = hUI.image:new({
							parent = _frmNode.childUI["rewardIcon_" .. m].handle._n,
							model = "ICON:debris_1",
							x = 0,
							y = -30,
							scale = 1.0,
						})
					elseif (itemNum == 2) then --碎片*2
						hApi.safeRemoveT(_frmNode.childUI["rewardIcon_" .. m].childUI, "num")
						hApi.safeRemoveT(_frmNode.childUI["rewardIcon_" .. m].childUI, "subIcon")
						
						--碎片*2的单独图标
						_frmNode.childUI["rewardIcon_" .. m].childUI["subIcon"] = hUI.image:new({
							parent = _frmNode.childUI["rewardIcon_" .. m].handle._n,
							model = "ICON:debris_2",
							x = 0,
							y = -30,
							scale = 1.0,
						})
					elseif (itemNum == 5) then --碎片*5
						hApi.safeRemoveT(_frmNode.childUI["rewardIcon_" .. m].childUI, "num")
						hApi.safeRemoveT(_frmNode.childUI["rewardIcon_" .. m].childUI, "subIcon")
						
						--碎片*5的单独图标
						_frmNode.childUI["rewardIcon_" .. m].childUI["subIcon"] = hUI.image:new({
							parent = _frmNode.childUI["rewardIcon_" .. m].handle._n,
							model = "ICON:debris_5",
							x = 0,
							y = -30,
							scale = 1.0,
						})
					elseif (itemNum == 10) then --碎片*10
						hApi.safeRemoveT(_frmNode.childUI["rewardIcon_" .. m].childUI, "num")
						hApi.safeRemoveT(_frmNode.childUI["rewardIcon_" .. m].childUI, "subIcon")
						
						--碎片*10的单独图标
						_frmNode.childUI["rewardIcon_" .. m].childUI["subIcon"] = hUI.image:new({
							parent = _frmNode.childUI["rewardIcon_" .. m].handle._n,
							model = "ICON:debris_10",
							x = 0,
							y = -30,
							scale = 1.0,
						})
					end
				end
				
				--绘制星星
				local tStarPosList =
				{
					[1] = {{0, 64,},},
					[2] = {{-10, 64,}, { 10, 64},},
					[3] = {{-20, 64,}, {0, 64,}, {20, 64,}},
				}
				for s = 1, m, 1 do
					_frmNode.childUI["rewardIcon_" .. m].childUI["star" .. s] = hUI.image:new({
						parent = _frmNode.childUI["rewardIcon_" .. m].handle._n,
						model = "misc/selectmap/star.png",
						x = tStarPosList[m][s][1],
						y = tStarPosList[m][s][2],
						w = 32,
						h = 32,
					})
				end
				
				--已领取
				_frmNode.childUI["rewardIcon_" .. m].childUI["flag"] = hUI.image:new({
					parent = _frmNode.childUI["rewardIcon_" .. m].handle._n,
					model = "UI:FinishTag",
					x = 0,
					y = 0,
					w = 70,
					h = 60,
				})
				_frmNode.childUI["rewardIcon_" .. m].childUI["flag"].handle._n:setRotation(15)
				if (finishStar < m) then
					_frmNode.childUI["rewardIcon_" .. m].childUI["flag"].handle._n:setVisible(false)
				end
			end
		end
		
		--挑战模式，显示随机掉落
		if (mapDifficulty > 0) then
			--[[
			--随机奖励
			_frmNode.childUI["SubDLCMapRewardRandomPrfix"] = hUI.label:new({
				parent = _BTC_pClipNode_dlc,
				x = DLCMAPINFO_OFFSET_X + 380,
				y = DLCMAPINFO_OFFSET_Y + offsetY - 300 - 140,
				size = 26,
				align = "LC",
				border = 1,
				font = hVar.FONTC,
				width = 600,
				text = "随机",
			})
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "SubDLCMapRewardRandomPrfix"
			]]
			
			--依次绘制随机奖励
			local showDiffDrop = tabM.DiffMode.chestPool and tabM.DiffMode.chestPool[hVar.ITEM_QUALITY.BLUE + mapDifficulty] or {}
			for m = 1, #showDiffDrop, 1 do
				local rewardT = showDiffDrop[m] or {}
				local rewardType = rewardT[1] or 0 --奖励类型
				local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
				
				--奖励物品的图标按钮（只用于响应事件，不显示）
				_frmNode.childUI["rewardRandomIcon_" .. m] = hUI.button:new({
					parent = _BTC_pClipNode_dlc,
					model = "misc/mask.png",
					x = DLCMAPINFO_OFFSET_X + 420 + (m - 1) * (96 + 4),
					y = DLCMAPINFO_OFFSET_Y + offsetY - 310 - 120,
					z = 1,
					w = 96,
					h = 96,
					scaleT = 0.95,
					dragbox = _frm.childUI["dragBox"],
					code = function()
						--显示各种类型的奖励的tip
						hApi.ShowRewardTip(rewardT)
					end,
				})
				_frmNode.childUI["rewardRandomIcon_" .. m].data.prize = rewardT --存储奖励数据
				_frmNode.childUI["rewardRandomIcon_" .. m].handle.s:setOpacity(0) --默认不显示（只用于响应事件，不显示）
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "rewardRandomIcon_" .. m
				
				--[[
				--物品底图
				_frmNode.childUI["rewardRandomIcon_" .. m].childUI["iconBG"] = hUI.image:new({
					parent = _frmNode.childUI["rewardRandomIcon_" .. m].handle._n,
					model = "misc/chest/astro_btnbg.png",
					x = 0,
					y = 0,
					w = 96,
					h = 96,
				})
				]]
				
				--物品图标
				local scale = 2.1
				_frmNode.childUI["rewardRandomIcon_" .. m].childUI["icon"] = hUI.image:new({
					parent = _frmNode.childUI["rewardRandomIcon_" .. m].handle._n,
					model = tmpModel,
					x = 0,
					y = 0,
					w = itemWidth * scale,
					h = itemHeight * scale,
				})
				
				--绘制奖励图标的子控件
				if sub_tmpModel then
					_frmNode.childUI["rewardRandomIcon_" .. m].childUI["subIcon"] = hUI.image:new({
						parent = _frmNode.childUI["rewardRandomIcon_" .. m].handle._n,
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
				local rewardNumFontSize = 26 --字体大小
				local rewardNumBorder = 0 --是否显示边框
				if (rewardNumLength == 3) then
					rewardNumFont = "numWhite" --字体
					rewardNumFontSize = 24 --字体大小
					rewardNumBorder = 0 --是否显示边框
				elseif (rewardNumLength == 4) then
					rewardNumFont = "numWhite" --字体
					rewardNumFontSize = 22 --字体大小
					rewardNumBorder = 0 --是否显示边框
				elseif (rewardNumLength == 5) then
					rewardNumFont = "numWhite" --字体
					rewardNumFontSize = 20 --字体大小
					rewardNumBorder = 0 --是否显示边框
				elseif (rewardNumLength >= 6) then
					rewardNumFont = hVar.FONTC --字体
					rewardNumFontSize = 18 --字体大小
					rewardNumBorder = 1 --是否显示边框
				end
				
				_frmNode.childUI["rewardRandomIcon_" .. m].childUI["num"] = hUI.label:new({
					parent = _frmNode.childUI["rewardRandomIcon_" .. m].handle._n,
					size = rewardNumFontSize,
					x = 0,
					y = -28,
					width = 500,
					align = "MC",
					font = rewardNumFont,
					text = strRewardNum,
					border = rewardNumBorder,
				})
				
				--针对战术卡碎片、宠物碎片、武器枪碎片做特殊处理，碎片图标用特别图标替换
				--print(rewardType)
				if (rewardType == 3) or (rewardType == 10) then --道具不显示数量了
					hApi.safeRemoveT(_frmNode.childUI["rewardRandomIcon_" .. m].childUI, "num")
				end
				if (rewardType == 6) or (rewardType == 11) or (rewardType == 101) or (rewardType == 103) or (rewardType == 105) or (rewardType == 106) or (rewardType == 107) or (rewardType == 108) then
					if (itemNum == 1) then --碎片*1
						hApi.safeRemoveT(_frmNode.childUI["rewardRandomIcon_" .. m].childUI, "num")
						hApi.safeRemoveT(_frmNode.childUI["rewardRandomIcon_" .. m].childUI, "subIcon")
						
						--碎片*1的单独图标
						_frmNode.childUI["rewardRandomIcon_" .. m].childUI["subIcon"] = hUI.image:new({
							parent = _frmNode.childUI["rewardRandomIcon_" .. m].handle._n,
							model = "ICON:debris_1",
							x = 0,
							y = -30,
							scale = 1.0,
						})
					elseif (itemNum == 2) then --碎片*2
						hApi.safeRemoveT(_frmNode.childUI["rewardRandomIcon_" .. m].childUI, "num")
						hApi.safeRemoveT(_frmNode.childUI["rewardRandomIcon_" .. m].childUI, "subIcon")
						
						--碎片*2的单独图标
						_frmNode.childUI["rewardRandomIcon_" .. m].childUI["subIcon"] = hUI.image:new({
							parent = _frmNode.childUI["rewardRandomIcon_" .. m].handle._n,
							model = "ICON:debris_2",
							x = 0,
							y = -30,
							scale = 1.0,
						})
					elseif (itemNum == 5) then --碎片*5
						hApi.safeRemoveT(_frmNode.childUI["rewardRandomIcon_" .. m].childUI, "num")
						hApi.safeRemoveT(_frmNode.childUI["rewardRandomIcon_" .. m].childUI, "subIcon")
						
						--碎片*5的单独图标
						_frmNode.childUI["rewardRandomIcon_" .. m].childUI["subIcon"] = hUI.image:new({
							parent = _frmNode.childUI["rewardRandomIcon_" .. m].handle._n,
							model = "ICON:debris_5",
							x = 0,
							y = -30,
							scale = 1.0,
						})
					elseif (itemNum == 10) then --碎片*10
						hApi.safeRemoveT(_frmNode.childUI["rewardRandomIcon_" .. m].childUI, "num")
						hApi.safeRemoveT(_frmNode.childUI["rewardRandomIcon_" .. m].childUI, "subIcon")
						
						--碎片*10的单独图标
						_frmNode.childUI["rewardRandomIcon_" .. m].childUI["subIcon"] = hUI.image:new({
							parent = _frmNode.childUI["rewardRandomIcon_" .. m].handle._n,
							model = "ICON:debris_10",
							x = 0,
							y = -30,
							scale = 1.0,
						})
					end
				end
			end
		end
		
		--进入战役
		_frmNode.childUI["SubDLCMapBtnBattle"] = hUI.button:new({
			parent = _BTC_pClipNode_dlc,
			model = "misc/mask.png",
			x = DLCMAPINFO_OFFSET_X + 530,
			y = DLCMAPINFO_OFFSET_Y + offsetY - 690,
			scale = 1.0,
			w = 90,
			h = 67,
			dragbox = _frm.childUI["dragBox"],
			code = function()
				OnClickBattleButton(current_selectedDifficulty)
			end,
		})
		_frmNode.childUI["SubDLCMapBtnBattle"].handle.s:setOpacity(0) --只响应事件，不显示
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "SubDLCMapBtnBattle"
		--按钮动画
		_frmNode.childUI["SubDLCMapBtnBattle"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["SubDLCMapBtnBattle"].handle._n,
			model = "MODEL_EFFECT:StartAmin1",
			x = 0,
			y = 0,
			scale = 1.0,
		})
		--消耗的体力图标
		_frmNode.childUI["SubDLCMapBtnBattle"].childUI["tiliIcon"] = hUI.image:new({
			parent = _frmNode.childUI["SubDLCMapBtnBattle"].handle._n,
			model = "misc/task/tili.png",
			x = 80,
			y = -8,
			scale = 0.9,
		})
		--消耗的体力值
		_frmNode.childUI["SubDLCMapBtnBattle"].childUI["tiliCost"] = hUI.label:new({
			parent = _frmNode.childUI["SubDLCMapBtnBattle"].handle._n,
			x = 80 + 20,
			y = -8 - 1,
			font = "numWhite",
			align = "LC",
			text = "1",
			border = 0,
			size = 24,
		})
		_frmNode.childUI["SubDLCMapBtnBattle"].childUI["tiliCost"].handle.s:setColor(ccc3(0, 255, 0))
		
		--未解锁，不显示进入战役的按钮
		if (childUnlockState == 0) then
			_frmNode.childUI["SubDLCMapBtnBattle"]:setstate(-1)
			
			--锁按钮
			_frmNode.childUI["SubDLCMapBtnLock"] = hUI.button:new({
				parent = _BTC_pClipNode_dlc,
				model = "misc/mask.png",
				x = DLCMAPINFO_OFFSET_X + 530,
				y = DLCMAPINFO_OFFSET_Y + offsetY - 690,
				scale = 1.0,
				w = 90,
				h = 67,
				scaleT = 0.95,
				dragbox = _frm.childUI["dragBox"],
				code = function()
					--冒字
					--local strText = "本关未解锁" --language
					local strText = hVar.tab_string["__TEXT_MapUnlock"] --language
					if (current_selectedDifficulty > 0) then
						strText = hVar.tab_string["__TEXT_MapNotPassPreevious"] --"通关前一个难度才能挑战"
					end
					
					hUI.floatNumber:new({
						x = hVar.SCREEN.w / 2,
						y = hVar.SCREEN.h / 2,
						align = "MC",
						text = "",
						lifetime = 2000,
						fadeout = -550,
						moveY = 32,
					}):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
				end,
			})
			_frmNode.childUI["SubDLCMapBtnLock"].handle.s:setOpacity(0) --只响应事件，不显示
			rightRemoveFrmList[#rightRemoveFrmList + 1] = "SubDLCMapBtnLock"
			--按钮动画
			_frmNode.childUI["SubDLCMapBtnLock"].childUI["icon"] = hUI.image:new({
				parent = _frmNode.childUI["SubDLCMapBtnLock"].handle._n,
				model = "misc/task/stage_lock.png",
				x = 0,
				y = 0,
				scale = 1.0,
			})
		end
	end
	
	--函数：点击进入战役
	OnClickBattleButton = function(difficulty)
		local _frm = hGlobal.UI.PhoneDLCMapInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local shopId = current_NET_SHOP_MAP_DLC[1] --DLC地图包的道具商店id
		--print("shopId=", shopId)
		local shopItemT = hVar.tab_shopitem[shopId] or {}
		if (shopItemT) then
			local itemId = shopItemT.itemID --道具id
			--print("itemId=", itemId)
			local tabI = hVar.tab_item[itemId] or {}
			local score = shopItemT.score or 0 --需要的积分
			local rmb = shopItemT.rmb or 0 --需要对游戏币
			local bagName = tabI.bagName --地图包的地图名
			--print("bagName=", bagName)
			local mapInfo = hVar.MAP_INFO[bagName]
			local icon = mapInfo.icon --地图包的图标
			local childMap = mapInfo.childMap --地图包的所有子地图
			
			local childMapName = childMap[current_selectedIdx] --子地图的名字
			if childMapName then
				--[[
				--关闭金币、积分界面
				hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
				
				--隐藏自身面板
				hGlobal.UI.PhoneDLCMapInfoFrm:show(0)
				_frm.childUI["closeBtn"].data.code()
				
				--hGlobal.event:event("LocalEvent_Phone_ShowMapInfoFrm", childMapName)
				--大菠萝数据初始化
				hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
				local MapDifficulty = current_selectedDifficulty
				xlScene_LoadMap(g_world, childMapName, MapDifficulty, hVar.MAP_TD_TYPE.NORMAL)
				]]
				
				--检测gameserver版本号是否为最新
				if (not hApi.CheckGameServerVersionControl()) then
					return
				end
				
				--挡操作
				hUI.NetDisable(30000)
				
				--发起请求，挑战普通剧情地图
				local MapDifficulty = current_selectedDifficulty
				SendCmdFunc["require_battle_normal"](childMapName, MapDifficulty)
			end
		end
	end
	
	--函数：收到请求挑战普通剧情地图事件返回
	on_receive_require_battle_normal_ret = function(result, pvpcoin, mapName, mapDiff, battlecfg_id)
		local _frm = hGlobal.UI.PhoneDLCMapInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--print("on_receive_require_battle_normal_ret", result, pvpcoin, mapName, mapDiff, battlecfg_id)
		
		--操作成功
		if (result == 1) then
			--关闭金币、积分界面
			--hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
			
			--隐藏自身面板
			hGlobal.UI.PhoneDLCMapInfoFrm:show(0)
			--_frm.childUI["closeBtn"].data.code()
			
			--关闭本界面
			OnClosePanel()
			
			--能再次打开
			_bCanCreate = true
			
			--hGlobal.event:event("LocalEvent_Phone_ShowMapInfoFrm", childMapName)
			--大菠萝数据初始化
			hGlobal.LocalPlayer.data.diablodata = LuaInitDiabloData()
			local MapDifficulty = current_selectedDifficulty
			local MapMode = hVar.MAP_TD_TYPE.NORMAL
			if (MapDifficulty > 0) then
				MapMode = hVar.MAP_TD_TYPE.DIFFICULT
			end
			local banLimitTable = {battlecfg_id = battlecfg_id,}
			
			--如果加载的是挑战模式，并且挑战模式指定了其他地图，那么加载指定地图
			local tomap = mapName
			if (MapMode == hVar.MAP_TD_TYPE.DIFFICULT) then
				local tMap = hVar.MAP_INFO[mapName] or {}
				local DiffMode = tMap.DiffMode or {}
				local diffMapName = DiffMode[mapDiff].diffMapName
				if (diffMapName ~= nil) then
					tomap = diffMapName
					banLimitTable.mapName = mapName
				end
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
			
			--加载地图
			xlScene_LoadMap(g_world, tomap, mapDiff, MapMode, nil, banLimitTable)
		end
	end
	
	--函数：横竖屏切换
	on_spine_screen_event = function()
		local _frm = hGlobal.UI.PhoneDLCMapInfoFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--关闭本界面
		OnClosePanel()
		
		--重绘本界面
		hGlobal.UI.InitDLCMapInfoFrm("reload") --测试
		--触发事件，显示DLC界面
		hGlobal.event:event("LocalEvent_Phone_ShowDLCMapInfoFrm", current_mapName, current_funcCallback, nil, current_strEnterMapName, current_nEnterMapDifficulty)
	end
	
	--函数：关闭某一关的地图信息的回调事件
	on_close_MapInfo_Panel = function(map_name)
		--触发事件，显示积分、金币界面
		hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
		
		--显示DLC地图信息界面
		hGlobal.UI.PhoneDLCMapInfoFrm:show(1)
		hGlobal.UI.PhoneDLCMapInfoFrm:active()
	end
end


--监听打开DLC地图信息界面通知事件
hGlobal.event:listen("LocalEvent_Phone_ShowDLCMapInfoFrm", "__ShowDLCMapFrm", function(mapName, callback, bOpenImmediate, strEnterMapName, nEnterMapDifficulty)
	hGlobal.UI.InitDLCMapInfoFrm("reload")
	
	--直接打开
	if bOpenImmediate then
		--动态加载漩涡背景图
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/effect/xuanwo.png")
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage("data/image/effect/xuanwo.png")
			print("加载漩涡背景大图！")
		end
		
		--动态加载面板背景图
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/addition/story_panel.png")
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/addition/story_panel.png")
			print("加载面板背景图！")
		end
		
		--动态加载面板背景遮罩图
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/addition/story_panel_mask.png")
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/addition/story_panel_mask.png")
			print("加载面板背景遮罩图！")
		end
		
		--存储回调事件
		current_mapName = mapName
		current_funcCallback = callback
		current_strEnterMapName = strEnterMapName --进入时指定选中的地图名
		current_nEnterMapDifficulty = nEnterMapDifficulty --进入时指定选中的地图难度
		
		--设置dlc信息
		local mapInfo = hVar.MAP_INFO[mapName] or {}
		local dlc = mapInfo.dlc
		current_NET_SHOP_MAP_DLC = {dlc,}
		
		--[[
		--测试  --test
		current_NET_SHOP_MAP_DLC = { [1] = 84, [2] = 141, [3] = 142, [4] = 84, [5] = 84,}
		]]
		
		--显示DLC地图信息界面
		hGlobal.UI.PhoneDLCMapInfoFrm:show(1)
		hGlobal.UI.PhoneDLCMapInfoFrm:active()
		
		--打开上一次的分页（默认显示第1个分页:DLC地图面板）
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
			local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/effect/xuanwo.png")
			if (not texture) then
				texture = CCTextureCache:sharedTextureCache():addImage("data/image/effect/xuanwo.png")
				print("加载漩涡背景大图！")
			end
			
			--动态加载面板背景图
			local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/addition/story_panel.png")
			if (not texture) then
				texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/addition/story_panel.png")
				print("加载面板背景图！")
			end
			
			--动态加载面板背景遮罩图
			local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/addition/story_panel_mask.png")
			if (not texture) then
				texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/addition/story_panel_mask.png")
				print("加载面板背景遮罩图！")
			end
		end)
		
		--步骤1: 绘制第一个分页，并将控件设置成初始位置（屏幕外，为步骤二播放动画做准备）
		local actM1 = CCCallFunc:create(function()
			--触发事件，显示积分、金币界面
			--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
			
			--存储回调事件
			current_mapName = mapName
			current_funcCallback = callback
			current_strEnterMapName = strEnterMapName --进入时指定选中的地图名
			current_nEnterMapDifficulty = nEnterMapDifficulty --进入时指定选中的地图难度
			
			--设置dlc信息
			local mapInfo = hVar.MAP_INFO[mapName] or {}
			local dlc = mapInfo.dlc
			current_NET_SHOP_MAP_DLC = {dlc,}
			
			--[[
			--测试  --test
			current_NET_SHOP_MAP_DLC = { [1] = 84, [2] = 141, [3] = 142, [4] = 84, [5] = 84,}
			]]
			
			--显示DLC地图信息界面
			hGlobal.UI.PhoneDLCMapInfoFrm:show(1)
			hGlobal.UI.PhoneDLCMapInfoFrm:active()
			
			--打开上一次的分页（默认显示第1个分页:DLC地图面板）
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
			local _frm = hGlobal.UI.PhoneDLCMapInfoFrm
			local dx = BOARD_WIDTH
			_frm:setXY(BOARD_POS_X + dx, BOARD_POS_Y)
		end)
		
		--步骤2: 动画进入控件
		local actM2 = CCCallFunc:create(function()
			--本面板
			local _frm = hGlobal.UI.PhoneDLCMapInfoFrm
			
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
hGlobal.event:listen("LocalEvent_PlayerFocusWorld", "__Phone_UI__HideDLCMapInfo", function(sSceneType, oWorld, oMap)
	if hGlobal.UI.PhoneDLCMapInfoFrm then
		if (hGlobal.UI.PhoneDLCMapInfoFrm.data.show == 1) then
			--隐藏自己
			OnClosePanel()
		end
		
		--允许再次打开
		_bCanCreate = true
	end
end)

--监听关闭宝箱界面事件
hGlobal.event:listen("clearPhoneChestFrm", "__CloseDLCMapFrm", function()
	if hGlobal.UI.PhoneDLCMapInfoFrm then
		if (hGlobal.UI.PhoneDLCMapInfoFrm.data.show == 1) then
			--关闭本界面
			OnClosePanel()
		end
		
		--允许再次打开
		_bCanCreate = true
	end
end)

--添加事件监听：购买DLC地图包成功事件（恢复存档也会走进来）
hGlobal.event:listen("LocalEvent_Phone_afterBuyMapBag", "__PhoneBuyMapInfoFrm", function(map_name, order_id)
	--去掉菊花
	hUI.NetDisable(0)
	
	if (map_name ~= nil) then
		if (LuaAddPlayerDLCMap(map_name) == 1) then
			
			if (type(order_id) == "number") then
				SendCmdFunc["order_update"](order_id, 2, map_name, 6)
			end
			
			--购买地图包成功 
			xlAppAnalysis("buy_map_bag",0,1,"info","uID:"..tostring(xlPlayer_GetUID()).."map_name:"..tostring(map_name).."-T:"..tostring(os.date("%m%d%H%M%S")))
			
			--通知界面刷新
			hGlobal.event:event("LocalEvent_Phone_ShowDLCMapInfoFrm_Back", map_name)
		else
			if (type(order_id) == "number") then
				SendCmdFunc["order_update"](order_id, 1, map_name, 6)
			end
		end
	end
end)

--test
--[[
--测试代码
if hGlobal.UI.PhoneDLCMapInfoFrm then --删除上一次的DLC地图信息界面
	hGlobal.UI.PhoneDLCMapInfoFrm:del()
	hGlobal.UI.PhoneDLCMapInfoFrm = nil
end
hGlobal.UI.InitDLCMapInfoFrm("reload") --测试创建DLC地图界面
--触发事件，显示DLC地图界面
--current_NET_SHOP_MAP_DLC = { [1] = 84, [2] = 84, [3] = 84, [4] = 84, [5] = 84,}
--current_NET_SHOP_MAP_DLC = { [1] = 84}
hGlobal.event:event("LocalEvent_Phone_ShowDLCMapInfoFrm", "world/dlc_yxys_spider")
]]

