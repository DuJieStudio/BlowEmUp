



--战车排行榜界面
--hGlobal.UI.InitTankBillboardInfoFrm = function(mode)
	--local tInitEventName = {"LocalEvent_Phone_ShowBillboardInfoFrm", "__ShowBillboardFrm",}
	--if (mode ~= "include") then
		--return tInitEventName
	--end
	
	----不重复创建游戏币变化面板
	--if hGlobal.UI.PhoneGameCoinChangeInfoFrm then --游戏币变化面板
		--return
	--end
	
	--local BOARD_WIDTH = 1080 --DLC地图面板面板的宽度
	--local BOARD_HEIGHT = 680 --DLC地图面板面板的高度
	--local BOARD_OFFSETY = -0 --DLC地图面板面板y偏移中心点的值
	--local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 --DLC地图面板面板的x位置（最左侧）
	--local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --DLC地图面板面板的y位置（最顶侧）
	
	--local PAGE_BTN_LEFT_X = 290 --第一个分页按钮的x偏移
	--local PAGE_BTN_LEFT_Y = -21 --第一个分页按钮的x偏移
	--local PAGE_BTN_OFFSET_X = 140 --每个分页按钮的间距
	
	----临时UI管理
	--local leftRemoveFrmList = {} --左侧控件集
	--local rightRemoveFrmList = {} --右侧控件集
	--local _removeLeftFrmFunc = hApi.DoNothing --清空左侧所有的临时控件
	--local _removeRightFrmFunc = hApi.DoNothing --清空右侧所有的临时控件
	
	----局部函数
	--local OnClickPageBtn = hApi.DoNothing --点击分页按钮
	
	----分页1：显示游戏币变化界面
	--local OnCreateTankBillboardInfoFrame = hApi.DoNothing --创建DLC地图界面（第1个分页）
	--local refresh_dlcmapinfo_UI_loop = hApi.DoNothing --刷新DLC地图面板界面的滚动
	--local refresh_async_paint_billboard_loop = hApi.DoNothing --异步绘制排行榜条目的timer
	--local refresh_query_billboard_timeout_timer = hApi.DoNothing --查询超时的timer
	--local on_receive_billobard_info_Back = hApi.DoNothing --收到排行榜信息回调
	--local on_create_single_billboard_UI = hApi.DoNothing --绘制单条排行榜数据
	--local on_create_single_billboard_UI_async = hApi.DoNothing --异步绘制单条排行榜数据（异步）
	
	----分页1：DLC地图包的参数
	--local DLCMAPINFO_WIDTH = 1042 --DLC地图包宽度
	--local DLCMAPINFO_HEIGHT = 100 --DLC地图包高度
	--local DLCMAPINFO_OFFSET_X = -10 --DLC地图包统一偏移x
	--local DLCMAPINFO_OFFSET_Y = 28 --DLC地图包统一偏移y
	--local DLCMAPINFO_BOARD_HEIGHT = 508 --DLC地图包高度
	--local DLCMAPINFO_X_NUM = 1 --DLC地图面板x的数量
	--local DLCMAPINFO_Y_NUM = 5 --DLC地图面板y的数量
	--local MAX_SPEED = 50 --最大速度
	
	----可变参数
	--local current_DLCMap_max_num = 0 --最大的DLC地图包数量
	
	--local current_async_paint_list = {} --当前待异步绘制的聊天消息列表
	--local ASYNC_PAINTNUM_ONCE = 1 --一次绘制几条
	
	----控制参数
	--local click_pos_x_dlcmapinfo = 0 --开始按下的坐标x
	--local click_pos_y_dlcmapinfo = 0 --开始按下的坐标y
	--local last_click_pos_y_dlcmapinfo = 0 --上一次按下的坐标x
	--local last_click_pos_y_dlcmapinfo = 0 --上一次按下的坐标y
	--local draggle_speed_y_dlcmapinfo = 0 --当前滑动的速度x
	--local selected_dlcmapinfoEx_idx = 0 --选中的DLC地图面板ex索引
	--local click_scroll_dlcmapinfo = false --是否在滑动DLC地图面板中
	--local b_need_auto_fixing_dlcmapinfo = false --是否需要自动修正
	--local friction_dlcmapinfo = 0 --阻力
	
	----当前选中的记录
	--local CurrentSelectRecord = {pageIdx = 0, contentIdx = 0, cardId = 0,} --当前选择的分页、数据项的信息记录
	
	----加载资源
	----xlLoadResourceFromPList("data/image/misc/pvp.plist")
	
	--hApi.clearTimer("__TANK_BILLBOARD_UPDATE__")
	--hApi.clearTimer("__TANK_BILLBOARD_ASYNC__")
	--hApi.clearTimer("__TANK_QUERY_TIMEOUNT_TIMER__")
	
	----创建游戏币变化面板
	--hGlobal.UI.PhoneGameCoinChangeInfoFrm = hUI.frame:new(
	--{
		--x = BOARD_POS_X,
		--y = BOARD_POS_Y,
		--w = BOARD_WIDTH,
		--h = BOARD_HEIGHT,
		--dragable = 2,
		--show = 0, --一开始不显示
		----border = 1, --显示frame边框
		----background = "misc/billboard/kuang.png", --"UI:Tactic_Background",
		--border = -1,
		--background = -1,
		----background = "UI:tip_item",
		----background = "UI:Tactic_Background",
		----background = "UI:herocardfrm",
		--autoactive = 0,
		
		----点击事件
		--codeOnTouch = function(self, x, y, sus)
			----在外部点击
			--if (sus == 0) then
				----self.childUI["closeBtn"].data.code()
			--end
		--end,
	--})
	
	--local _frm = hGlobal.UI.PhoneGameCoinChangeInfoFrm
	--local _parent = _frm.handle._n
	
	----背景图
	----九宫格
	--hApi.CCScale9SpriteCreate("data/image/misc/billboard/kuang.png", BOARD_WIDTH/2, -BOARD_HEIGHT/2, BOARD_WIDTH, BOARD_HEIGHT, _frm)
	
	----左侧裁剪区域
	--local _BTC_PageClippingRect = {0, -92, 1080, 534, 0} -- {x, y, w, h, ???}
	--local _BTC_pClipNode_billboard = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect, 98, _BTC_PageClippingRect[5], "_BTC_pClipNode_billboard")
	
	----左侧黑色底图
	--_frm.childUI["DLCMapInfoTitleBack"] = hUI.image:new({
		--parent = _parent,
		--model = "misc/mask_white.png",
		--x = hVar.SCREEN.w / 2 - BOARD_POS_X,
		--y = -hVar.SCREEN.h / 2,
		--w = hVar.SCREEN.w * 2,
		--h = hVar.SCREEN.h * 2,
		--z = -1,
	--})
	--_frm.childUI["DLCMapInfoTitleBack"].handle.s:setOpacity(88)
	--_frm.childUI["DLCMapInfoTitleBack"].handle.s:setColor(ccc3(0, 0, 0))
	
	----关闭按钮
	--local closeDx = -20
	--local closeDy = -22
	--_frm.childUI["closeBtn"] = hUI.button:new({
		--parent = _parent,
		--dragbox = _frm.childUI["dragBox"],
		----model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		--model = "misc/billboard/closebtn.png", --"BTN:PANEL_CLOSE",
		--x = _frm.data.w + closeDx,
		--y = closeDy,
		--scaleT = 0.95,
		--code = function()
			----不显示游戏币变化面板
			--hGlobal.UI.PhoneGameCoinChangeInfoFrm:show(0)
			
			----关闭界面后不需要监听的事件
			----取消监听：
			----...
			
			----清空切换分页之后取消的监听事件
			----移除事件监听：收到排行榜信息回调
			--hGlobal.event:listen("localEvent_TankBillboardData", "__GameCoinChangeHistory", nil)
			
			----删除DLC界面下拉滚动timer
			--hApi.clearTimer("__TANK_BILLBOARD_UPDATE__")
			--hApi.clearTimer("__TANK_BILLBOARD_ASYNC__")
			--hApi.clearTimer("__TANK_QUERY_TIMEOUNT_TIMER__")
			
			----关闭金币、积分界面
			--hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
			
			----触发事件：关闭了主菜单按钮
			----hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")
		--end,
	--})
	
	----每个分页按钮
	----DLC地图面板
	--local tPageIcons = {"UI:ach_king",}
	----local tTexts = {"地图包",} --language
	--local tTexts = {"",} --language
	--for i = 1, #tPageIcons, 1 do
		----分页按钮
		--_frm.childUI["PageBtn" .. i] = hUI.button:new({
			--parent = _parent,
			--model = "misc/mask.png",
			--x = PAGE_BTN_LEFT_X + (i - 1) * PAGE_BTN_OFFSET_X - 175,
			--y = PAGE_BTN_LEFT_Y,
			--w = 250,
			--h = 40,
			--dragbox = _frm.childUI["dragBox"],
			--scaleT = 1.0,
			--code = function(self, screenX, screenY, isInside)
				--OnClickPageBtn(i)
			--end,
		--})
		--_frm.childUI["PageBtn" .. i].handle.s:setOpacity(0) --分页按钮点击区域，只作为控制用，不用于显示
		
		----[[
		----分页按钮的方块图标
		--_frm.childUI["PageBtn" .. i].childUI["PageImage"] = hUI.image:new({
			--parent = _frm.childUI["PageBtn" .. i].handle._n,
			--model = "UI:Tactic_Button",
			--x = 0,
			--y = 0,
			--w = 116,
			--h = 48,
		--})
		
		----分页按钮的图标
		--_frm.childUI["PageBtn" .. i].childUI["PageIcon"] = hUI.image:new({
			--parent = _frm.childUI["PageBtn" .. i].handle._n,
			--model = tPageIcons[i],
			--x = -40,
			--y = 5,
			--w = 32,
			--h = 32,
		--})
		--]]
		
		----分页按钮的文字
		--_frm.childUI["PageBtn" .. i].childUI["Text"] = hUI.label:new({
			--parent = _frm.childUI["PageBtn" .. i].handle._n,
			--x = 10,
			--y = 0,
			--size = 28,
			--align = "MC",
			--border = 1,
			--font = hVar.FONTC,
			--width = 300,
			--text = tTexts[i],
		--})
		
		----[[
		----分页按钮的提示升级的动态箭头标识
		--_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"] = hUI.image:new({
			--parent = _frm.childUI["PageBtn" .. i].handle._n,
			--model = "UI:TaskTanHao",
			--x = -40,
			--y = 6,
			--w = 36,
			--h = 36,
		--})
		--_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"].handle.s:setVisible(false) --默认一开始不显示提示该分页可以领取的动态箭头
		--local act1 = CCMoveBy:create(0.2, ccp(0, 6))
		--local act2 = CCMoveBy:create(0.2, ccp(0, -6))
		--local act3 = CCMoveBy:create(0.2, ccp(0, 6))
		--local act4 = CCMoveBy:create(0.2, ccp(0, -6))
		--local act5 = CCDelayTime:create(0.6)
		--local act6 = CCRotateBy:create(0.1, 10)
		--local act7 = CCRotateBy:create(0.1 * 1, -10 * 2)
		--local act8 = CCRotateBy:create(0.1 * 1, 10 * 2)
		--local act9 = CCRotateBy:create(0.1, -10)
		--local act10 = CCDelayTime:create(0.8)
		--local a = CCArray:create()
		--a:addObject(act1)
		--a:addObject(act2)
		--a:addObject(act3)
		--a:addObject(act4)
		--a:addObject(act5)
		--a:addObject(act6)
		--a:addObject(act7)
		--a:addObject(act8)
		--a:addObject(act9)
		--a:addObject(act10)
		--local sequence = CCSequence:create(a)
		--_frm.childUI["PageBtn" .. i].childUI["NoteJianTou"].handle.s:runAction(CCRepeatForever:create(sequence))
		--]]
	--end
	
	----分页内容的的父控件
	--_frm.childUI["PageNode"] = hUI.button:new({
		--parent = _frm,
		----model = tPageIcons[i],
		--x = 0,
		--y = 0,
		--w = 1,
		--h = 1,
		----border = 0,
		----background = "UI:Tactic_Background",
		----z = 10,
	--})
	
	----清空所有分页左侧的UI
	--_removeLeftFrmFunc = function(pageIndex)
		--local _frm = hGlobal.UI.PhoneGameCoinChangeInfoFrm
		--local _frmNode = _frm.childUI["PageNode"]
		
		--for i = 1,#leftRemoveFrmList do
			--hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		--end
		--leftRemoveFrmList = {}
	--end
	
	----清空所有分页右侧的UI
	--_removeRightFrmFunc = function(pageIndex)
		--local _frm = hGlobal.UI.PhoneGameCoinChangeInfoFrm
		--local _frmNode = _frm.childUI["PageNode"]
		
		--for i = 1,#rightRemoveFrmList do
			--hApi.safeRemoveT(_frmNode.childUI, rightRemoveFrmList[i]) 
		--end
		--rightRemoveFrmList = {}
	--end
	
	----函数：点击分页按钮函数
	--OnClickPageBtn = function(pageIndex)
		----不重复显示同一个分页
		--if (CurrentSelectRecord.pageIdx == pageIndex) then
			--return
		--end
		
		----启用全部的按钮
		--for i = 1, #tPageIcons, 1 do
			----_frm.childUI["PageBtn" .. i]:setstate(1) --按钮可用
			----_frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s:setVisible(true) --显示图片
			----_frm.childUI["PageBtn" .. i].childUI["PageIcon"].handle.s:setVisible(true) --显示图标
			--_frm.childUI["PageBtn" .. i].childUI["Text"].handle.s:setVisible(true) --显示文字
		--end
		
		----当前按钮高亮
		----[[
		--hApi.AddShader(_frm.childUI["PageBtn" .. pageIndex].childUI["PageImage"].handle.s, "normal")
		
		----其它按钮灰掉
		--for i = 1, #tPageIcons, 1 do
			--if (i ~= pageIndex) then
				--hApi.AddShader(_frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s, "gray")
			--end
		--end
		--]]
		
		----先清空上次分页的全部信息
		--_removeLeftFrmFunc()
		--_removeRightFrmFunc()
		
		----清空切换分页之后取消的监听事件
		----移除事件监听：收到排行榜信息回调
		--hGlobal.event:listen("localEvent_TankBillboardData", "__GameCoinChangeHistory", nil)
		
		----移除timer
		--hApi.clearTimer("__TANK_BILLBOARD_UPDATE__")
		--hApi.clearTimer("__TANK_BILLBOARD_ASYNC__")
		--hApi.clearTimer("__TANK_QUERY_TIMEOUNT_TIMER__")
		
		----隐藏所有的clipNode
		--hApi.EnableClipByName(_frm, "_BTC_pClipNode_billboard", 0)
		
		----新建该分页下的全部信息
		--if (pageIndex == 1) then --分页1：游戏币变化
			----创建游戏币变化分页
			--OnCreateTankBillboardInfoFrame(pageIndex)
		--end
		
		----标记当前选择的分页和页内的第几个
		--CurrentSelectRecord.pageIdx = pageIndex
		--CurrentSelectRecord.contentIdx = 1 --默认选中第一个
	--end
	
	----函数：创建战车排行榜界面（第1个分页）
	--OnCreateTankBillboardInfoFrame = function(pageIdx)
		--local _frm = hGlobal.UI.PhoneGameCoinChangeInfoFrm
		--local _frmNode = _frm.childUI["PageNode"]
		--local _parentNode = _frmNode.handle._n
		
		----允许本分页的的clipNode
		--hApi.EnableClipByName(_frm, "_BTC_pClipNode_billboard", 1)
		
		----初始化参数
		--current_DLCMap_max_num = 0 --最大的DLC地图面板id
		
		--current_async_paint_list = {} --清空异步缓存待绘制内容
		
		----local i = 3
		
		----左侧裁剪区域
		----local _BTC_PageClippingRect = {0, -82, 1000, 408, 0}
		----local _BTC_pClipNode_billboard = hApi.CreateClippingNode(_parentNode, _BTC_PageClippingRect, 99, _BTC_PageClippingRect[5])
		
		----[[
		----左侧底板
		----背景图
		--_frmNode.childUI["DLCMapInfoListBG"] = hUI.image:new({
			--parent = _parentNode,
			--model = "misc/selectbg.png",
			--x = DLCMAPINFO_OFFSET_X + 125,
			--y = DLCMAPINFO_OFFSET_Y - 324,
			--w = 280,
			--h = DLCMAPINFO_BOARD_HEIGHT - 58,
		--})
		--_frmNode.childUI["DLCMapInfoListBG"].handle.s:setOpacity(128) --底板透明度为128
		--leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoListBG"
		
		----左侧竖线
		--_frmNode.childUI["DLCMapInfoListLineV"] = hUI.image:new({
			--parent = _parentNode,
			--model = "panel/panel_part_01.png",
			--x = DLCMAPINFO_OFFSET_X + 230,
			--y = DLCMAPINFO_OFFSET_Y - 322,
			--w = DLCMAPINFO_BOARD_HEIGHT,
			--h = 12,
		--})
		--_frmNode.childUI["DLCMapInfoListLineV"].handle.s:setRotation(-90)
		--_frmNode.childUI["DLCMapInfoListLineV"].handle.s:setOpacity(128) --竖线透明度为128
		--leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoListLineV"
		
		----左侧按钮
		----游戏币纪录
		--_frmNode.childUI["DLCMapInfoGameCoinBtn"] = hUI.button:new({
			--parent = _parentNode,
			--model = "UI:PANEL_MENU_BTN_NORMAL",
			--x = DLCMAPINFO_OFFSET_X + 120,
			--y = DLCMAPINFO_OFFSET_Y - 106,
			--dragbox = _frm.childUI["dragBox"],
			--w = 190,
			--h = 50,
			--scaleT = 0.98,
			--code = function()
				----print("DLCMapInfoGameCoinBtn")
			--end,
		--})
		----文字
		--_frmNode.childUI["DLCMapInfoGameCoinBtn"].childUI["label"] = hUI.label:new({
			--parent = _frmNode.childUI["DLCMapInfoGameCoinBtn"].handle._n,
			--model = "UI:PANEL_MENU_BTN_NORMAL",
			--x = 18,
			--y = -2,
			--align = "MC",
			--size = 24,
			--font = hVar.FONTC,
			--width = 500,
			--text = "游戏币纪录",
			--border = 1,
		--})
		----图标
		--_frmNode.childUI["DLCMapInfoGameCoinBtn"].childUI["icon"] = hUI.image:new({
			--parent = _frmNode.childUI["DLCMapInfoGameCoinBtn"].handle._n,
			--model = "UI:PANEL_MENU_BTN_NORMAL",
			--x = -64,
			--y = 1,
			--model = "UI:game_coins",
			--scale = 0.85,
		--})
		--]]
		
		----标题背景图
		--_frmNode.childUI["DLCMapInfoTitleBG"] = hUI.image:new({
			--parent = _parentNode,
			--model = "misc/billboard/kuang7.png",
			--x = BOARD_WIDTH / 2,
			--y = -34,
		--})
		--leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTitleBG"
		
		----标题文字
		--_frmNode.childUI["DLCMapInfoTitleLabel"] = hUI.label:new({
			--parent = _parentNode,
			--x = BOARD_WIDTH / 2,
			--y = -26,
			--align = "MC",
			--size = 30,
			--font = hVar.FONTC,
			--width = 500,
			--text = "RANKBOARD",
			--border = 1,
			--RGB = {255, 255, 128,},
		--})
		--leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTitleLabel"
		
		----右侧DLC地图包列表提示上翻页的图片
		--_frmNode.childUI["DLCMapInfoPageUp"] = hUI.image:new({
			--parent = _parentNode,
			--model = "misc/billboard/jiantou.png", --"UI:PageBtn",
			--x = DLCMAPINFO_OFFSET_X + 548,
			--y = DLCMAPINFO_OFFSET_Y - 96,
			--scale = 1.0,
			--z = 500, --最前端显示
		--})
		--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setRotation(90)
		--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setOpacity(0) --提示上翻页默认透明度为212
		--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --默认不显示左上翻页提示
		--leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageUp"
		--local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, 3)), CCMoveBy:create(0.5, ccp(0, -3)))
		--local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		--_frmNode.childUI["DLCMapInfoPageUp"].handle._n:runAction(forever)
		
		----右侧DLC地图包列表提示下翻页的图片
		--_frmNode.childUI["DLCMapInfoPageDown"] = hUI.image:new({
			--parent = _parentNode,
			--model = "misc/billboard/jiantou.png", --"UI:PageBtn",
			--x = DLCMAPINFO_OFFSET_X + 548,
			--y = DLCMAPINFO_OFFSET_Y - 680,
			--scale = 1.0,
			--z = 500, --最前端显示
		--})
		--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setRotation(270)
		--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setOpacity(0) --提示下翻页默认透明度为212
		--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --默认不显示下分翻页提示
		--leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageDown"
		--local towAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.5, ccp(0, -3)), CCMoveBy:create(0.5, ccp(0, 3)))
		--local forever = CCRepeatForever:create(tolua.cast(towAction, "CCActionInterval"))
		--_frmNode.childUI["DLCMapInfoPageDown"].handle._n:runAction(forever)
		
		----右侧向上翻页的按钮的接受左点击事件的响应区域
		--_frmNode.childUI["DLCMapInfoPageUp_Btn"] = hUI.button:new({
			--parent = _parent,
			--model = "misc/mask.png", --"UI:playerBagD"
			--dragbox = _frm.childUI["dragBox"],
			--x = DLCMAPINFO_OFFSET_X + 548,
			--y = DLCMAPINFO_OFFSET_Y - 96 + 2,
			--w = 200,
			--h = 46,
			--scaleT = 1.0,
			--z = 100000, --最前端显示
			--code = function(self, screenX, screenY, isInside)
				----超过一页的数量才滑屏
				--if (current_DLCMap_max_num > (DLCMAPINFO_X_NUM * DLCMAPINFO_Y_NUM)) then
					----print("向下滚屏", screenY)
					----向下滚屏
					--b_need_auto_fixing_dlcmapinfo = true
					--friction_dlcmapinfo = 0
					--draggle_speed_y_dlcmapinfo = -MAX_SPEED / 2.0 --负速度
				--end
			--end,
		--})
		--_frmNode.childUI["DLCMapInfoPageUp_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		--leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageUp_Btn"
		
		----右侧向下翻页的按钮的接受左点击事件的响应区域
		--_frmNode.childUI["DLCMapInfoPageDown_Btn"] = hUI.button:new({
			--parent = _parent,
			--model = "misc/mask.png", --"UI:playerBagD"
			--dragbox = _frm.childUI["dragBox"],
			--x = DLCMAPINFO_OFFSET_X + 548,
			--y = DLCMAPINFO_OFFSET_Y - 680 - 2,
			--w = 200,
			--h = 46,
			--scaleT = 1.0,
			--z = 100000, --最前端显示
			--code = function(self, screenX, screenY, isInside)
				----超过一页的数量才滑屏
				--if (current_DLCMap_max_num > (DLCMAPINFO_X_NUM * DLCMAPINFO_Y_NUM)) then
					----print("向上滚屏", screenY)
					----向上滚屏
					--b_need_auto_fixing_dlcmapinfo = true
					--friction_dlcmapinfo = 0
					--draggle_speed_y_dlcmapinfo = MAX_SPEED / 2.0 --正速度
				--end
			--end,
		--})
		--_frmNode.childUI["DLCMapInfoPageDown_Btn"].handle.s:setOpacity(0) --只用于控制，不显示
		--leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoPageDown_Btn"
		
		----右侧用于检测滑动事件的控件
		--_frmNode.childUI["DLCMapInfoDragPanel"] = hUI.button:new({
			--parent = _parentNode,
			--model = "misc/mask.png",
			--dragbox = _frm.childUI["dragBox"],
			--x = DLCMAPINFO_OFFSET_X + 550,
			--y = DLCMAPINFO_OFFSET_Y - 388,
			--w = 1080,
			--h = 534,
			--failcall = 1,
			
			----按下事件
			--codeOnTouch = function(self, touchX, touchY, sus)
				----print("codeOnTouch", touchX, touchY, sus)
				--click_pos_x_dlcmapinfo = touchX --开始按下的坐标x
				--click_pos_y_dlcmapinfo = touchY --开始按下的坐标y
				--last_click_pos_y_dlcmapinfo = touchX --上一次按下的坐标x
				--last_click_pos_y_dlcmapinfo = touchY --上一次按下的坐标y
				--draggle_speed_y_dlcmapinfo = 0 --当前速度为0
				--selected_dlcmapinfoEx_idx = 0 --选中的DLC地图面板ex索引
				--click_scroll_dlcmapinfo = true --是否滑动DLC地图面板
				--b_need_auto_fixing_dlcmapinfo = false --不需要自动修正位置
				--friction_dlcmapinfo = 0 --无阻力
				
				----如果DLC地图面板数量未铺满一页，那么不需要滑动
				--if (current_DLCMap_max_num <= (DLCMAPINFO_X_NUM * DLCMAPINFO_Y_NUM)) then
					--click_scroll_dlcmapinfo = false --不需要滑动DLC地图面板
				--end
			--end,
			
			----滑动事件
			--codeOnDrag = function(self, touchX, touchY, sus)
				----print("codeOnDrag", touchX, touchY, sus)
				----处理移动速度y
				--draggle_speed_y_dlcmapinfo = touchY - last_click_pos_y_dlcmapinfo
				
				--if (draggle_speed_y_dlcmapinfo > MAX_SPEED) then
					--draggle_speed_y_dlcmapinfo = MAX_SPEED
				--end
				--if (draggle_speed_y_dlcmapinfo < -MAX_SPEED) then
					--draggle_speed_y_dlcmapinfo = -MAX_SPEED
				--end
				
				----print("click_scroll_dlcmapinfo=", click_scroll_dlcmapinfo)
				----在滑动过程中才会处理滑动
				--if click_scroll_dlcmapinfo then
					--local deltaY = touchY - last_click_pos_y_dlcmapinfo --与开始按下的位置的偏移值x
					--for i = 1, current_DLCMap_max_num, 1 do
						--local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
						--ctrli.handle._n:setPosition(ctrli.data.x, ctrli.data.y + deltaY)
						--ctrli.data.x = ctrli.data.x
						--ctrli.data.y = ctrli.data.y + deltaY
					--end
				--end
				
				----存储本次的位置
				--last_click_pos_y_dlcmapinfo = touchX
				--last_click_pos_y_dlcmapinfo = touchY
			--end,
			
			----抬起事件
			--code = function(self, touchX, touchY, sus)
				----print("code", touchX, touchY, sus)
				----如果之前在滑动中，那么标记需要自动修正位置
				--if click_scroll_dlcmapinfo then
					----if (touchX ~= click_pos_x_dlcmapinfo) or (touchY ~= click_pos_y_dlcmapinfo) then --不是点击事件
						--b_need_auto_fixing_dlcmapinfo = true
						--friction_dlcmapinfo = 0
					----end
				--end
				
				----是否选中某个DLC地图面板查看区域内查看tip
				--local selectTipIdx = 0
				--for i = 1, current_DLCMap_max_num, 1 do
					--local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					--local cx = ctrli.data.x --中心点x坐标
					--local cy = ctrli.data.y --中心点y坐标
					--local cw, ch = ctrli.data.w, ctrli.data.h
					--local lx, ly = cx - cw / 2, cy - ch / 2 --最左上侧坐标
					--local rx, ry = lx + cw, ly + ch --最右下角坐标
					----print(i, lx, rx, ly, ry, touchX, touchY)
					--if (touchX >= lx) and (touchX <= rx) and (touchY >= ly) and (touchY <= ry) then
						--selectTipIdx = i
						
						--break
						----print("点击到了哪个DLC地图面板tip的框内" .. i)
					--end
				--end
				
				--if (click_scroll_dlcmapinfo) and (math.abs(touchY - click_pos_y_dlcmapinfo) > 48) then
					--selectTipIdx = 0
				--end
				
				--if (selectTipIdx > 0) then
					----显示tip
					----print(selectTipIdx)
					----OnCreateTankBillboardInfoFrame_RightPart(selectTipIdx)
				--end
				
				----标记不用滑动
				--click_scroll_dlcmapinfo = false
			--end,
		--})
		--_frmNode.childUI["DLCMapInfoDragPanel"].handle.s:setOpacity(0) --只用于控制，不显示
		--leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoDragPanel"
		
		----[[
		----标题-排名
		--_frmNode.childUI["DLCMapInfoTitle_Rank"] = hUI.label:new({
			--parent = _parentNode,
			--x = DLCMAPINFO_OFFSET_X + 100,
			--y = DLCMAPINFO_OFFSET_Y - 100,
			--font = hVar.FONTC,
			--size = 26,
			--align = "MC",
			--text = "RANK",
			--border = 1,
			--RGB = {255, 255, 255,},
		--})
		--leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTitle_Rank"
		
		----标题-姓名
		--_frmNode.childUI["DLCMapInfoTitle_Name"] = hUI.label:new({
			--parent = _parentNode,
			--x = DLCMAPINFO_OFFSET_X + 290,
			--y = DLCMAPINFO_OFFSET_Y - 100,
			--font = hVar.FONTC,
			--size = 26,
			--align = "MC",
			--text = "NAME",
			--border = 1,
			--RGB = {255, 255, 255,},
		--})
		--leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTitle_Name"
		
		----标题-进度
		--_frmNode.childUI["DLCMapInfoTitle_Progress"] = hUI.label:new({
			--parent = _parentNode,
			--x = DLCMAPINFO_OFFSET_X + 780,
			--y = DLCMAPINFO_OFFSET_Y - 100,
			--font = hVar.FONTC,
			--size = 26,
			--align = "MC",
			--text = "PROGRESS",
			--border = 1,
			--RGB = {255, 255, 255,},
		--})
		--leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTitle_Progress"
		--]]
		
		----我的排名底图
		--_frmNode.childUI["DLCMapInfoTitle_MyRankImg"] = hUI.image:new({
			--parent = _parentNode,
			--model = "misc/billboard/kuang6.png", --"UI:PageBtn",
			--x = DLCMAPINFO_OFFSET_X + 150,
			--y = DLCMAPINFO_OFFSET_Y - 680,
		--})
		--leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTitle_MyRankImg"
		
		----标题-我的排名
		--_frmNode.childUI["DLCMapInfoTitle_MyRank"] = hUI.label:new({
			--parent = _parentNode,
			--x = DLCMAPINFO_OFFSET_X + 110,
			--y = DLCMAPINFO_OFFSET_Y - 680,
			--font = hVar.FONTC,
			--size = 26,
			--align = "LC",
			--text = "PB:",
			--border = 1,
			--RGB = {212, 255, 212,},
		--})
		--leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTitle_MyRank"
		
		----底框3
		----九宫格
		--hApi.CCScale9SpriteCreate("data/image/misc/billboard/kuang5.png", BOARD_WIDTH/2, -BOARD_HEIGHT/2 - 20, BOARD_WIDTH - 20, BOARD_HEIGHT - 140, _frm)
		
		----添加事件监听：收到排行榜信息回调
		--hGlobal.event:listen("localEvent_TankBillboardData", "__GameCoinChangeHistory", on_receive_billobard_info_Back)
		
		----创建timer，刷新DLC地图面板滚动
		--hApi.addTimerForever("__TANK_BILLBOARD_UPDATE__", hVar.TIMER_MODE.GAMETIME, 1, refresh_dlcmapinfo_UI_loop)
		----异步创建排行榜条目的timer
		--hApi.addTimerForever("__TANK_BILLBOARD_ASYNC__", hVar.TIMER_MODE.GAMETIME, 1, refresh_async_paint_billboard_loop)
		----添加查询超时一次性timer
		--hApi.addTimerOnce("__TANK_QUERY_TIMEOUNT_TIMER__", 5000, refresh_query_billboard_timeout_timer)
		
		----挡操作
		----hUI.NetDisable(30000)
		
		----发起查询战车排行榜数据
		--local diff = 0
		--SendCmdFunc["query_tank_billboard"](diff)
		
		----[[
		----模拟收到排行榜数据回调
		--local billboardT =
		--{
			--{rank = 1, name = "guest001", stage = 6, tank = 6000, weapon = 6013, time = 720, scientist = 10, gold = 4500,},
			--{rank = 2, name = "MyTank", stage = 5, tank = 6000, weapon = 6014, time = 1720, scientist = 1, gold = 3500,},
			--{rank = 3, name = "sgh发gr", stage = 5, tank = 6000, weapon = 6003, time = 1220, scientist = 11, gold = 2501,},
			--{rank = 4, name = "游客", stage = 4, tank = 6000, weapon = 6004, time = 2220, scientist = 11, gold = 2501,},
			--{rank = 5, name = "管理员", stage = 2, tank = 6000, weapon = 6006, time = 3220, scientist = 11, gold = 2501,},
			--{rank = 6, name = "WHATISGHR", stage = 1, tank = 6000, weapon = 6013, time = 4220, scientist = 11, gold = 2501,},
			--{rank = 7, name = "WHATISGHR", stage = 1, tank = 6000, weapon = 6013, time = 4220, scientist = 11, gold = 2501,},
			--{rank = 8, name = "mybaby", stage = 1, tank = 6000, weapon = 6013, time = 4220, scientist = 11, gold = 2501,},
			--{rank = 9, name = "34ft5tyy", stage = 1, tank = 6000, weapon = 6013, time = 4220, scientist = 11, gold = 2501,},
			--{rank = 10, name = "fff", stage = 1, tank = 6000, weapon = 6013, time = 4220, scientist = 11, gold = 2501,},
		--}
		--hGlobal.event:event("localEvent_TankBillboardData", 1, billboardT)
		--]]
	--end
	
	----函数：收到排行榜信息回调
	--on_receive_billobard_info_Back = function(result, diff, billobardT)
		--local _frm = hGlobal.UI.PhoneGameCoinChangeInfoFrm
		--local _frmNode = _frm.childUI["PageNode"]
		--local _parentNode = _frmNode.handle._n
		
		----print("收到排行榜信息回调", result, billobardT, #billobardT)
		
		----取消挡操作
		----hUI.NetDisable(0)
		
		----删除检测超时的timer
		--hApi.clearTimer("__TANK_QUERY_TIMEOUNT_TIMER__")
		
		----清除右侧界面
		--_removeRightFrmFunc()
		
		----隐藏上下分页按钮
		--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false)
		--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false)
		
		----依次绘制
		--for i = 1, #billobardT, 1 do
			----依次绘制排行榜数据（异步）
			--on_create_single_billboard_UI_async(billobardT[i], i)
			
			----标记总数量
			--current_DLCMap_max_num = current_DLCMap_max_num + 1
		--end
		
		----超过一页，显示向下分页按钮
		--if (current_DLCMap_max_num > (DLCMAPINFO_X_NUM * DLCMAPINFO_Y_NUM)) then
			--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true)
		--end
		
		----我的排名
		--local rankMe = billobardT.rankMe
		----print(rankMe)
		----排名
		--if (rankMe == 1) then --第1名
			----我的名次图片
			--_frmNode.childUI["DLCMapInfoNode_RankMe"] = hUI.image:new({
				--parent = _parent,
				--x = DLCMAPINFO_OFFSET_X + 174,
				--y = DLCMAPINFO_OFFSET_Y - 680,
				--model = "misc/billboard/rank1.png",
				--align = "MC",
				--scale = 0.38,
			--})
			--rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoNode_RankMe"
		--elseif (rankMe == 2) then --第2名
			----我的名次图片
			--_frmNode.childUI["DLCMapInfoNode_RankMe"] = hUI.image:new({
				--parent = _parent,
				--x = DLCMAPINFO_OFFSET_X + 174,
				--y = DLCMAPINFO_OFFSET_Y - 680,
				--model = "misc/billboard/rank2.png",
				--align = "MC",
				--scale = 0.38,
			--})
			--rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoNode_RankMe"
		--elseif (rankMe == 3) then --第3名
			----我的名次图片
			--_frmNode.childUI["DLCMapInfoNode_RankMe"] = hUI.image:new({
				--parent = _parent,
				--x = DLCMAPINFO_OFFSET_X + 174,
				--y = DLCMAPINFO_OFFSET_Y - 680,
				--model = "misc/billboard/rank3.png",
				--align = "MC",
				--scale = 0.38,
			--})
			--rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoNode_RankMe"
		--elseif (rankMe > 0) then --有名次
			----我的名次文字
			--_frmNode.childUI["DLCMapInfoNode_RankMe"] = hUI.label:new({
				--parent = _parent,
				--x = DLCMAPINFO_OFFSET_X + 174,
				--y = DLCMAPINFO_OFFSET_Y - 680 - 1,
				--font = hVar.FONTC,
				--size = 26,
				--align = "MC",
				--text = rankMe,
				--border = 1,
			--})
			--_frmNode.childUI["DLCMapInfoNode_RankMe"].handle.s:setColor(ccc3(212, 255, 212))
			--rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoNode_RankMe"
		--else --无名次
			----我的名次文字
			--_frmNode.childUI["DLCMapInfoNode_RankMe"] = hUI.label:new({
				--parent = _parent,
				--x = DLCMAPINFO_OFFSET_X + 174,
				--y = DLCMAPINFO_OFFSET_Y - 680 - 1,
				--font = hVar.FONTC,
				--size = 26,
				--align = "MC",
				--text = "--",
				--border = 1,
			--})
			--_frmNode.childUI["DLCMapInfoNode_RankMe"].handle.s:setColor(ccc3(192, 192, 192))
			--rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoNode_RankMe"
		--end
	--end
	
	----函数：绘制单条排行榜数据
	--on_create_single_billboard_UI = function(billboard, index)
		--local _frm = hGlobal.UI.PhoneGameCoinChangeInfoFrm
		--local _frmNode = _frm.childUI["PageNode"]
		--local _parentNode = _frmNode.handle._n
		
		--local rank = billboard.rank --排名
		--local name = billboard.name --玩家吗
		--local stage = billboard.stage --关卡进度
		--local tankId = billboard.tankId --坦克id
		--local weaponId = billboard.weaponId --武器id
		--local gametime = billboard.gametime --通关时间
		--local scientistNum = billboard.scientistNum --科学家数量
		--local goldNum = billboard.goldNum --金币数量
		----print(rank, name, stage, tankId, weaponId, gametime, scientistNum, goldNum)
		
		----父控件
		--_frmNode.childUI["DLCMapInfoNode" .. index] = hUI.button:new({
			--parent = _BTC_pClipNode_billboard,
			----model = "misc/billboard/kuang2.png",
			--model = -1,
			--x = DLCMAPINFO_WIDTH / 2 + 18,
			--y = -146 - (index - 1) * (DLCMAPINFO_HEIGHT + 6),
			----z = 1,
			--w = DLCMAPINFO_WIDTH,
			--h = DLCMAPINFO_HEIGHT,
		--})
		----_frmNode.childUI["DLCMapInfoNode" .. index].handle.s:setOpacity(111) --默认不显示（只用于响应事件，不显示）
		--rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoNode" .. index
		
		----背景图
		----底框2
		----九宫格
		--local imgName = "data/image/misc/billboard/border2.png"
		--if (rank == 1) then --第1名
			--imgName = "data/image/misc/billboard/border3.png"
		--elseif (rank == 2) then --第2名
			--imgName = "data/image/misc/billboard/border1.png"
		--elseif (rank == 3) then --第3名
			--imgName = "data/image/misc/billboard/border4.png"
		--end
		--hApi.CCScale9SpriteCreate(imgName, 0, 0, DLCMAPINFO_WIDTH, DLCMAPINFO_HEIGHT, _frmNode.childUI["DLCMapInfoNode" .. index])
		
		----排名
		--if (rank == 1) then --第1名
			----名次图片
			--_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rank"] = hUI.image:new({
				--parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				--x = -450,
				--y = -3,
				--model = "misc/billboard/rank1.png",
				--align = "MC",
				--scale = 0.68,
			--})
		--elseif (rank == 2) then --第2名
			----名次图片
			--_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rank"] = hUI.image:new({
				--parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				--x = -450,
				--y = -2,
				--model = "misc/billboard/rank2.png",
				--align = "MC",
				--scale = 0.64,
			--})
		--elseif (rank == 3) then --第3名
			----名次图片
			--_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rank"] = hUI.image:new({
				--parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				--x = -450,
				--y = -4,
				--model = "misc/billboard/rank3.png",
				--align = "MC",
				--scale = 0.6,
			--})
		--else
			----名次文字
			--_frmNode.childUI["DLCMapInfoNode" .. index].childUI["rank"] = hUI.label:new({
				--parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
				--x = -450,
				--y = -2,
				--font = hVar.FONTC,
				--size = 28,
				--align = "MC",
				--text = rank,
				--border = 1,
			--})
		--end
		
		----玩家名字
		--_frmNode.childUI["DLCMapInfoNode" .. index].childUI["name"] = hUI.label:new({
			--parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			--x = -262,
			--y = -2,
			--font = hVar.FONTC,
			--size = 28,
			--align = "MC",
			--text = name,
			--border = 1,
			--RGB = {255, 255, 212,},
		--})
		
		----进度
		--_frmNode.childUI["DLCMapInfoNode" .. index].childUI["progress"] = hUI.button:new({ --作为按钮只是为了挂载子控件
			--parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			--x = 70,
			--y = -10,
			--model = "misc/totalsettlement/process_light.png",
			--align = "MC",
			--scale = 0.36,
		--})
		----进度的敌人BOSS图标
		--for i = 1, stage, 1 do
			--local sModel = string.format("icon/hero/boss_%02d.png", i)
			--_frmNode.childUI["DLCMapInfoNode" .. index].childUI["progress"].childUI["Boss_" .. i] = hUI.image:new({
				--parent = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["progress"].handle._n,
				--x = -122 + (i - 1) * 60,
				--y = 30,
				--model = sModel,
				--align = "MC",
				--scale = 0.28,
			--})
		--end
		----进度条战车图标
		--_frmNode.childUI["DLCMapInfoNode" .. index].childUI["progress"].childUI["MyTank"] = hUI.thumbImage:new({
			--parent = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["progress"].handle._n,
			--x = -122 + (stage - 1) * 60,
			--y = -14,
			--id = tankId,
			--facing = 0,
			--align = "MC",
			--scale = 0.28,
		--})
		----进度条战车轮子图标
		--_frmNode.childUI["DLCMapInfoNode" .. index].childUI["progress"].childUI["MyTankWheel"] = hUI.thumbImage:new({
			--parent = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["progress"].handle._n,
			--x = -122 + (stage - 1) * 60,
			--y = -14,
			--id = hVar.tab_unit[tankId].bind_wheel,
			--facing = 0,
			--align = "MC",
			--scale = 0.28,
		--})
		----进度条战车武器图标
		--_frmNode.childUI["DLCMapInfoNode" .. index].childUI["progress"].childUI["MyTankWeapon"] = hUI.thumbImage:new({
			--parent = _frmNode.childUI["DLCMapInfoNode" .. index].childUI["progress"].handle._n,
			--x = -122 + (stage - 1) * 60,
			--y = -14,
			--id = weaponId,
			--facing = 0,
			--align = "MC",
			--scale = 0.28,
		--})
		
		----通关时间图标
		--_frmNode.childUI["DLCMapInfoNode" .. index].childUI["gametimeImg"] = hUI.button:new({ --作为按钮只是为了挂载子控件
			--parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			--x = 310,
			--y = 12,
			--model = "misc/gameover/icon_time.png",
			--align = "MC",
			--scale = 0.5,
		--})
		
		----通关时间文本
		--local seconds = gametime
		--local minute = math.floor(seconds / 60)
		--local second = seconds - minute * 60
		--local strTime = string.format("%d:%02d",minute,second)
		--_frmNode.childUI["DLCMapInfoNode" .. index].childUI["gametimeLabel"] = hUI.label:new({
			--parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			--x = 310 + 20,
			--y = 12 - 2,
			--font = "numWhite",
			--size = 18,
			--align = "LC",
			--text = strTime,
			--border = 1,
		--})
		----_frmNode.childUI["DLCMapInfoNode" .. index].childUI["gametimeLabel"].handle.s:setColor(ccc3(255, 255, 0))
		
		----金币图标
		--_frmNode.childUI["DLCMapInfoNode" .. index].childUI["goldImg"] = hUI.button:new({ --作为按钮只是为了挂载子控件
			--parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			--x = 310,
			--y = -20,
			--model = "misc/skillup/mu_coin.png",
			--align = "MC",
			--scale = 0.5,
		--})
		
		----金币值文本
		--_frmNode.childUI["DLCMapInfoNode" .. index].childUI["goldLabel"] = hUI.label:new({
			--parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			--x = 310 + 20,
			--y = -20 - 2,
			--font = "num",
			--size = 18,
			--align = "LC",
			--text = goldNum,
			--border = 1,
		--})
		----_frmNode.childUI["DLCMapInfoNode" .. index].childUI["goldLabel"].handle.s:setColor(ccc3(255, 255, 0))
		
		----科学家图标
		--_frmNode.childUI["DLCMapInfoNode" .. index].childUI["scientistImg"] = hUI.button:new({ --作为按钮只是为了挂载子控件
			--parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			--x = 440,
			--y = 12,
			--model = "misc/gameover/icon_man.png",
			--align = "MC",
			--scale = 0.5,
		--})
		
		----科学家值文本
		--_frmNode.childUI["DLCMapInfoNode" .. index].childUI["scientistLabel"] = hUI.label:new({
			--parent = _frmNode.childUI["DLCMapInfoNode" .. index].handle._n,
			--x = 440 + 20,
			--y = 12 - 2,
			--font = "numWhite",
			--size = 18,
			--align = "LC",
			--text = scientistNum,
			--border = 1,
		--})
		----_frmNode.childUI["DLCMapInfoNode" .. index].childUI["scientistLabel"].handle.s:setColor(ccc3(255, 255, 0))
		
		-----------------------------------------------------------------------
		----可能存在滑动，校对前一个控件的相对位置
		--if _frmNode.childUI["DLCMapInfoNode" .. (index - 1)] then --前一个
			----实际相对距离
			--local lastX = _frmNode.childUI["DLCMapInfoNode" .. (index - 1)].data.x
			--local lastY = _frmNode.childUI["DLCMapInfoNode" .. (index - 1)].data.y
			--local lastChatHeight = (DLCMAPINFO_HEIGHT + 6)
			
			----理论相对距离
			--local thisX = lastX
			--local thisY = lastY - lastChatHeight
			--local ctrli = _frmNode.childUI["DLCMapInfoNode" .. index]
			--ctrli.handle._n:setPosition(thisX, thisY)
			--ctrli.data.x = thisX
			--ctrli.data.y = thisY
		--end
	--end
	
	----函数：异步绘制单条排行榜数据（异步）
	--on_create_single_billboard_UI_async = function(billboard, index)
		--local _frm = hGlobal.UI.PhoneGameCoinChangeInfoFrm
		--local _frmNode = _frm.childUI["PageNode"]
		--local _parentNode = _frmNode.handle._n
		
		--local rank = billboard.rank --排名
		--local name = billboard.name --玩家吗
		--local stage = billboard.stage --关卡进度
		--local tankId = billboard.tankId --坦克id
		--local weaponId = billboard.weaponId --武器id
		--local gametime = billboard.gametime --通关时间
		--local scientistNum = billboard.scientistNum --科学家数量
		--local goldNum = billboard.goldNum --金币数量
		----print(rank, name, stage, tankId, weaponId, gametime, scientistNum, goldNum)
		
		----父控件
		--_frmNode.childUI["DLCMapInfoNode" .. index] = hUI.button:new({
			--parent = _BTC_pClipNode_billboard,
			----model = "misc/billboard/kuang2.png",
			--model = -1,
			--x = 480,
			--y = -146 - (index - 1) * (DLCMAPINFO_HEIGHT + 6),
			----z = 1,
			--w = DLCMAPINFO_WIDTH,
			--h = DLCMAPINFO_HEIGHT,
		--})
		----_frmNode.childUI["DLCMapInfoNode" .. index].handle.s:setOpacity(111) --默认不显示（只用于响应事件，不显示）
		--rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoNode" .. index
		
		----存储异步待绘制消息列表
		--current_async_paint_list[index] = billboard
	--end
	
	----函数：刷新DLC地图面板界面的滚动
	--refresh_dlcmapinfo_UI_loop = function()
		----如果当前在动画中，不用处理
		----if (ANIM_IN_ACTION == 1) then
		----	return
		----end
		--local _frm = hGlobal.UI.PhoneGameCoinChangeInfoFrm
		--local _frmNode = _frm.childUI["PageNode"]
		--local _parentNode = _frmNode.handle._n
		
		--local SPEED = 50 --速度
		----print(b_need_auto_fixing_dlcmapinfo)
		
		--if b_need_auto_fixing_dlcmapinfo then
			-----第一个DLC地图面板的数据
			--local DLCMapInfoBtn1 = _frmNode.childUI["DLCMapInfoNode1"]
			--local btn1_cx, btn1_cy = 0, 0 --第一个DLC地图面板中心点位置
			--local btn1_ly = 0 --第一个DLC地图面板最上侧的x坐标
			--local delta1_ly = 0 --第一个DLC地图面板距离上侧边界的距离
			--btn1_cx, btn1_cy = DLCMapInfoBtn1.data.x, DLCMapInfoBtn1.data.y --第一个DLC地图面板中心点位置
			--btn1_ly = btn1_cy + DLCMAPINFO_HEIGHT / 2 --第一个DLC地图面板最上侧的x坐标
			--delta1_ly = btn1_ly + 96 --第一个DLC地图面板距离上侧边界的距离
			
			----最后一个DLC地图面板的数据
			--local DLCMapInfoBtnN = _frmNode.childUI["DLCMapInfoNode" .. current_DLCMap_max_num]
			--local btnN_cx, btnN_cy = 0, 0 --最后一个DLC地图面板中心点位置
			--local btnN_ry = 0 --最后一个DLC地图面板最下侧的x坐标
			--local deltNa_ry = 0 --最后一个DLC地图面板距离下侧边界的距离
			--btnN_cx, btnN_cy = DLCMapInfoBtnN.data.x, DLCMapInfoBtnN.data.y --最后一个DLC地图面板中心点位置
			--btnN_ry = btnN_cy - DLCMAPINFO_HEIGHT / 2 --最后一个DLC地图面板最下侧的x坐标
			--deltNa_ry = btnN_ry + 622 --最后一个DLC地图面板距离下侧边界的距离
			----print("delta1_ly, deltNa_ry", delta1_ly, deltNa_ry)
			
			----print("delta1_ly=" .. delta1_ly, ", deltNa_rx=" .. deltNa_rx)
			----如果第一个DLC地图面板的头像跑到下边，那么优先将第一个DLC地图面板头像贴边
			--if (delta1_ly < 0) then
				----print("优先将第一个DLC地图面板头像贴边")
				----需要修正
				----不会选中DLC地图面板
				--selected_dlcmapinfoEx_idx = 0 --选中的DLC地图面板索引
				
				----没有惯性
				--draggle_speed_y_dlcmapinfo = 0
				
				--local speed = SPEED
				--if ((delta1_ly + speed) > 0) then --防止走过
					--speed = -delta1_ly
					--delta1_ly = 0
				--end
				
				----每个按钮向上侧做运动
				--for i = 1, current_DLCMap_max_num, 1 do
					--local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
				----if (ctrli.data.selected == 0) then --只处理未选中的DLC地图面板卡牌
					--local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					----本地运动到达的坐标
					--local to_x, to_y = pos_x, pos_y + speed
					
					----设置新坐标
					--ctrli.data.x = to_x
					--ctrli.data.y = to_y
					--ctrli.handle._n:setPosition(to_x, to_y)
				----end
				--end
				
				----上滑动翻页不显示，下滑动翻页显示
				--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --上翻页提示
				----hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHUp"].handle.s, "gray") --上横线到顶了，灰掉
				--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下翻页提示
				----hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHDown"].handle.s, "normal") --下横线需要翻页，正常
			--elseif (delta1_ly ~= 0) and (deltNa_ry > 0) then --第一个头像没有贴上侧，并且最后一个头像没有贴下侧，那么再将最后一个DLC地图面板头像贴边
				----print("将最后一个DLC地图面板头像贴边")
				----需要修正
				----不会选中DLC地图面板
				--selected_dlcmapinfoEx_idx = 0 --选中的DLC地图面板索引
				
				----没有惯性
				--draggle_speed_y_dlcmapinfo = 0
				
				--local speed = SPEED
				--if ((deltNa_ry - speed) < 0) then --防止走过
					--speed = deltNa_ry
					--deltNa_ry = 0
				--end
				
				----每个按钮向下侧做运动
				--for i = 1, current_DLCMap_max_num, 1 do
					--local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
				----if (ctrli.data.selected == 0) then --只处理未选中的DLC地图面板卡牌
					--local pos_x, pos_y = ctrli.data.x, ctrli.data.y
					
					----本地运动到达的坐标
					--local to_x, to_y = pos_x, pos_y - speed
					
					----设置新坐标
					--ctrli.data.x = to_x
					--ctrli.data.y = to_y
					--ctrli.handle._n:setPosition(to_x, to_y)
				----end
				--end
				
				----上滑动翻页显示，下滑动翻页不显示
				--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(true) --上分翻页提示
				----hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHUp"].handle.s, "normal") --上横线需要翻页，正常
				--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --下分翻页不提示
				----hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHDown"].handle.s, "gray") --下横线到顶了，灰掉
			--elseif (draggle_speed_y_dlcmapinfo ~= 0) then --沿着当前的速度方向有惯性地运动一会
				----print("沿着当前的速度方向有惯性地运动一会", draggle_speed_y_dlcmapinfo)
				----不会选中DLC地图面板
				--selected_dlcmapinfoEx_idx = 0 --选中的DLC地图面板索引
				----print("    ->   draggle_speed_y_dlcmapinfo=", draggle_speed_y_dlcmapinfo)
				
				--if (draggle_speed_y_dlcmapinfo > 0) then --朝上运动
					--local speed = (draggle_speed_y_dlcmapinfo) * 1.0 --系数
					--friction_dlcmapinfo = friction_dlcmapinfo - 0.5
					--draggle_speed_y_dlcmapinfo = draggle_speed_y_dlcmapinfo + friction_dlcmapinfo --衰减（正）
					
					--if (draggle_speed_y_dlcmapinfo < 0) then
						--draggle_speed_y_dlcmapinfo = 0
					--end
					
					----最后一个DLC地图面板的坐标不能跑到最下侧的上边去
					--if ((deltNa_ry + speed) > 0) then --防止走过
						--speed = -deltNa_ry
						--deltNa_ry = 0
						
						----没有惯性
						--draggle_speed_y_dlcmapinfo = 0
					--end
					
					----每个按钮向上侧做运动
					--for i = 1, current_DLCMap_max_num, 1 do
						--local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					----if (ctrli.data.selected == 0) then --只处理未选中的DLC地图面板卡牌
						--local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						----本地运动到达的坐标
						--local to_x, to_y = pos_x, pos_y + speed
						
						----设置新坐标
						--ctrli.data.x = to_x
						--ctrli.data.y = to_y
						--ctrli.handle._n:setPosition(to_x, to_y)
					----end
					--end
				--elseif (draggle_speed_y_dlcmapinfo < 0) then --朝下运动
					--local speed = (draggle_speed_y_dlcmapinfo) * 1.0 --系数
					--friction_dlcmapinfo = friction_dlcmapinfo + 0.5
					--draggle_speed_y_dlcmapinfo = draggle_speed_y_dlcmapinfo + friction_dlcmapinfo --衰减（负）
					
					--if (draggle_speed_y_dlcmapinfo > 0) then
						--draggle_speed_y_dlcmapinfo = 0
					--end
					
					----第一个DLC地图面板的坐标不能跑到最上侧的下边去
					--if ((delta1_ly + speed) < 0) then --防止走过
						--speed = -delta1_ly
						--delta1_ly = 0
						
						----没有惯性
						--draggle_speed_y_dlcmapinfo = 0
					--end
					
					----每个按钮向下侧做运动
					--for i = 1, current_DLCMap_max_num, 1 do
						--local ctrli = _frmNode.childUI["DLCMapInfoNode" .. i]
					----if (ctrli.data.selected == 0) then --只处理未选中的DLC地图面板卡牌
						--local pos_x, pos_y = ctrli.data.x, ctrli.data.y
						
						----本地运动到达的坐标
						--local to_x, to_y = pos_x, pos_y + speed
						
						----设置新坐标
						--ctrli.data.x = to_x
						--ctrli.data.y = to_y
						--ctrli.handle._n:setPosition(to_x, to_y)
					----end
					--end
				--end
				
				----上滑动翻页显示，下滑动翻页显示
				--if (delta1_ly == 0) then
					--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false) --上分翻页提示
					----hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHUp"].handle.s, "gray") --上横线到顶了，灰掉
				--else
					--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(true) --上分翻页提示
					----hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHUp"].handle.s, "normal") --上横线需要翻页，正常
				--end
				--if (deltNa_ry == 0) then
					--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false) --下分翻页提示
					----hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHDown"].handle.s, "gray") --下横线到顶了，灰掉
				--else
					--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(true) --下分翻页提示
					----hApi.AddShader(_frmNode.childUI["DLCMapInfoListLineHDown"].handle.s, "normal") --下横线需要翻页，正常
				--end
			--else --停止运动
				--b_need_auto_fixing_dlcmapinfo = false
				--friction_dlcmapinfo = 0
			--end
		--end
	--end
	
	----异步绘制排行榜条目的timer
	--refresh_async_paint_billboard_loop = function()
		--local _frm = hGlobal.UI.PhoneGameCoinChangeInfoFrm
		--local _frmNode = _frm.childUI["PageNode"]
		--local _parentNode = _frmNode.handle._n
		
		----如果待异步绘制表里有内容，逐一绘制
		--if (#current_async_paint_list > 0) then
			--local loopCount = ASYNC_PAINTNUM_ONCE
			--if (loopCount > #current_async_paint_list) then
				--loopCount = #current_async_paint_list
			--end
			
			----一次绘制多条
			--for loop = 1, loopCount, 1 do
				----取第一项
				--local index = 1
				--local billboard = current_async_paint_list[index]
				--local rank = billboard.rank
				
				----先删除虚控件
				--hApi.safeRemoveT(_frmNode.childUI, "DLCMapInfoNode" .. rank)
				
				----再创建实体控件
				--on_create_single_billboard_UI(billboard, rank)
				
				--table.remove(current_async_paint_list, index)
			--end
		--end
	--end
	
	----函数：查询聊天超时的一次性timer
	--refresh_query_billboard_timeout_timer = function()
		--local _frm = hGlobal.UI.PhoneGameCoinChangeInfoFrm
		--local _frmNode = _frm.childUI["PageNode"]
		--local _parentNode = _frmNode.handle._n
		
		----清除右侧界面
		--_removeRightFrmFunc()
		
		----隐藏上下分页按钮
		--_frmNode.childUI["DLCMapInfoPageUp"].handle.s:setVisible(false)
		--_frmNode.childUI["DLCMapInfoPageDown"].handle.s:setVisible(false)
		
		----创建文本，提示连接超时
		--_frmNode.childUI["DLCMapInfoNode_ConnectTimeOut"] = hUI.label:new({
			--parent = _parent,
			--x = DLCMAPINFO_OFFSET_X + 550,
			--y = DLCMAPINFO_OFFSET_Y - 388,
			--font = hVar.FONTC,
			--size = 28,
			--align = "MC",
			--text = "CONNECT TIME OUT !",
			--border = 1,
			--RGB = {192, 192, 192,},
		--})
		--rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoNode_ConnectTimeOut"
	--end
	
	----监听打开游戏币变化界面通知事件
	--hGlobal.event:listen("LocalEvent_Phone_ShowBillboardInfoFrm", "__ShowBillboardFrm", function()
		----触发事件，显示积分、金币界面
		----hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
		
		----显示游戏币变化界面
		--hGlobal.UI.PhoneGameCoinChangeInfoFrm:show(1)
		--hGlobal.UI.PhoneGameCoinChangeInfoFrm:active()
		
		----打开上一次的分页（默认显示第1个分页:DLC地图面板）
		--local lastPageIdx = CurrentSelectRecord.pageIdx
		--if (lastPageIdx == 0) then
			--lastPageIdx = 1
		--end
		
		--CurrentSelectRecord.pageIdx = 0
		--CurrentSelectRecord.contentIdx = 0
		--OnClickPageBtn(lastPageIdx)
		
		----只有在打开界面时才会监听的事件
		----监听：收到网络宝箱数量的事件
		----hGlobal.event:listen("LocalEvent_getNetChestNum", "__ItemGetChestNum_Frm", function(NumTab)
			----更新网络宝箱的数量和界面
			----
		----end)
	--end)
--end

--test
--[[
--测试代码
if hGlobal.UI.PhoneGameCoinChangeInfoFrm then --删除上一次的游戏币变化界面
	hGlobal.UI.PhoneGameCoinChangeInfoFrm:del()
	hGlobal.UI.PhoneGameCoinChangeInfoFrm = nil
end
hGlobal.UI.InitTankBillboardInfoFrm("include") --测试创建DLC地图界面
hGlobal.event:event("LocalEvent_Phone_ShowBillboardInfoFrm")
]]

--获取成就评级
hApi.GetAchievementRating = function(nAchievementType,tBillboard)
	local nRating = 0
	if type(hVar.AchievementRatingCriteria[nAchievementType]) == "table" and type(tBillboard) == "table" then
		local tValue = {}
		if nAchievementType == hVar.AchievementType.CLEARANCE then	--通关时间
			tValue[1] = tBillboard.stage or 0
			tValue[2] = (tBillboard.gametime or 999999) / 60
		elseif nAchievementType == hVar.AchievementType.BATTER then	--最大连击
			tValue[1] = tBillboard.killNum or 0
		elseif nAchievementType == hVar.AchievementType.MAXPET then	--最多携带宠物数
			tValue[1] = tBillboard.petNum or 0
		elseif nAchievementType == hVar.AchievementType.ROLLING then	--碾压总数
			tValue[1] = tBillboard.rollingNum or 0
		elseif nAchievementType == hVar.AchievementType.ONEPASS then	--一命闯关
			tValue[1] = tBillboard.onepass_stage or 0
		end
		local tCriteria = hVar.AchievementRatingCriteria[nAchievementType]
		if type(tCriteria.compareType) == "table" and type(tCriteria.criteria) == "table" then
			for i = 1,#tCriteria.criteria do
				local isSatisfy = 0
				for j = 1,#tCriteria.compareType do
					if type(tCriteria.criteria[i][j]) == "number" and type(tValue[j]) == "number" then
						if tCriteria.compareType[j] == "lessE" then
							if tValue[j] <= tCriteria.criteria[i][j] then
								isSatisfy = 1
							else
								isSatisfy = 0
								break
							end
						elseif tCriteria.compareType[j] == "moreE" then
							if tValue[j] >= tCriteria.criteria[i][j] then
								isSatisfy = 1
							else
								isSatisfy = 0
								break
							end
						end
					end
				end
				if isSatisfy == 1 then
					nRating = i
				else
					break
				end
			end
		end
	end
	return nRating
end

--获取评级图片
hApi.GetRatingModel = function(nAchievementType,nRating)
	local model = ""
	if type(nAchievementType) == "number" and type(nRating) == "number" then
		if nRating == 1 then
			model = "misc/achievements/medal_copper.png"
		elseif nRating == 2 then
			model = "misc/achievements/medal_silver.png"
		elseif nRating == 3 then
			model = "misc/achievements/medal_gold.png"
		end
	end
	return model
end

hGlobal.UI.InitTankRankBoardFrm = function(mode)
	local tInitEventName = {"LocalEvent_Phone_ShowBillboardInfoFrm", "__ShowBillboardFrm",}
	if (mode ~= "include") then
		return tInitEventName
	end

	local _frm,_parent,_childUI
	local _clipNode
	local _boardScale = 1
	local _boardW,_boardH = 1200,660
	local _rankInfoW,_rankInfoH = 1040,100
	local _frmScale = 1
	if g_phone_mode == 2 then
		_frmScale = 0.9
	end
	local _gridWH = {_rankInfoW,_rankInfoH+2}
	local _cliprect = {(hVar.SCREEN.w - _rankInfoW)/2,-132,_rankInfoW + 10,510,0}
	local _gridrect = {}

	local _currentPage = 0
	local _asyncCreateList = {}
	local _canDrag = false

	local _PageList = {
		"NORMAL",
		--"HARD",
	}
	local _boardScale = 1
	local _clipScale = 1
	if g_phone_mode == 2 then
		_boardScale = 0.9
		_clipScale = 0.9
		_gridWH = {math.floor(_rankInfoW * _clipScale),math.floor((_rankInfoH+2)* _clipScale)}
		_boardW = math.floor(_boardW * _boardScale)
		_boardH = math.floor(_boardH * _boardScale)
		_cliprect =  {(math.floor(hVar.SCREEN.w - _rankInfoW * _clipScale)/2),-112,math.floor((_rankInfoW + 10) * _clipScale),math.floor(510 * _clipScale),0}
	elseif g_phone_mode == 1 then
		_boardScale = 0.76
		_clipScale = 0.75
		_gridWH = {math.floor(_rankInfoW * _clipScale),math.floor((_rankInfoH+2)* _clipScale)}
		_boardW = math.floor(_boardW * _boardScale)
		_boardH = math.floor(_boardH * _boardScale)
		_cliprect =  {(math.floor(hVar.SCREEN.w - _rankInfoW * _clipScale)/2),-148,math.floor((_rankInfoW + 10) * _clipScale),math.floor(510 * _clipScale),0}
	elseif g_phone_mode == 0 then
		_boardScale = 0.85
		_clipScale = 0.85
		_gridWH = {math.floor(_rankInfoW * _clipScale),math.floor((_rankInfoH+2)* _clipScale)}
		_boardW = math.floor(_boardW * _boardScale)
		_boardH = math.floor(_boardH * _boardScale)
		_cliprect =  {(math.floor(hVar.SCREEN.w - _rankInfoW * _clipScale)/2),-188,math.floor((_rankInfoW + 10) * _clipScale),math.floor(510 * _clipScale),0}
	end

	local _CODE_CreateTankRankBoardFrm = hApi.DoNothing
	local _CODE_ChangePage = hApi.DoNothing				--切换分页
	local _CODE_CreatePageInfo = hApi.DoNothing
	local _CODE_CreateRankInfo = hApi.DoNothing			--创建排行信息
	local _CODE_CreateMyRankInfo = hApi.DoNothing			--创建我的排名信息
	local _CODE_ClearFunc = hApi.DoNothing				--清理函数

	local _CODE_AutoLign = hApi.DoNothing			--自动对齐
	local _CODE_OnPageDrag = hApi.DoNothing			--拖动事件
	local _CODE_OnInfoUp = hApi.DoNothing			--放开事件

	local on_receive_billobard_info_Back = hApi.DoNothing
	local refresh_async_paint_billboard_loop = hApi.DoNothing
	local refresh_query_billboard_timeout_timer = hApi.DoNothing

	_CODE_ClearFunc = function()
		--去除事件监听：收到排行榜信息回调
		hGlobal.event:listen("localEvent_TankBillboardData", "__getTankBillboardData", nil)
		hApi.clearTimer("__TANK_QUERY_TIMEOUNT_TIMER__")
		hApi.clearTimer("__TANK_BILLBOARD_ASYNC__")
		if hGlobal.UI.PhoneTankRankBoardFrm then
			hGlobal.UI.PhoneTankRankBoardFrm:del()
			hGlobal.UI.PhoneTankRankBoardFrm = nil
		end
		_frm = nil
		_parent = nil
		_childUI = nil
		_clipNode = nil
		_currentPage = 0
		_canDrag = false
		_gridrect = {}
		_asyncCreateList = {}
		
		--释放png, plist的纹理缓存（这里不清理也可以）
		--hApi.ReleasePngTextureCache()
	end

	_CODE_CreateTankRankBoardFrm = function()
		if hGlobal.UI.PhoneTankRankBoardFrm then
			hGlobal.UI.PhoneTankRankBoardFrm:del()
			hGlobal.UI.PhoneTankRankBoardFrm = nil
		end
		hGlobal.UI.PhoneTankRankBoardFrm = hUI.frame:new(
		{
			x = 0,
			y = hVar.SCREEN.h,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			dragable = 2,
			show = 0, --一开始不显示
			border = -1,
			background = -1,
			autoactive = 0,
			
			--点击事件
			codeOnTouch = function(self, x, y, sus)
				if _canDrag then
					if hApi.IsInBox(x, y, _cliprect) then
						local pama = {state = 0}
						self:pick("clipnode",_dragrect,tTempPos,{_CODE_OnPageDrag,_CODE_OnInfoUp,pama},1)
					end
				end
			end,
		})

		_frm = hGlobal.UI.PhoneTankRankBoardFrm
		_parent = _frm.handle._n
		_childUI = _frm.childUI

		_childUI["Img_rankboard_bg"] = hUI.button:new({
			parent = _parent,
			model = "misc/billboard/msgbox5.png",
			x = hVar.SCREEN.w / 2,
			y = -hVar.SCREEN.h / 2,
			w = _boardW,
			h = _boardH,
			--scale = _boardScale,
		})

		_childUI["Btn_close"] = hUI.button:new({
			parent = _parent,
			dragbox = _childUI["dragBox"],
			model = "misc/skillup/btn_close.png",
			x = hVar.SCREEN.w/2 + _boardW/2 - math.floor(48* _boardScale),
			y = -hVar.SCREEN.h/2 + _boardH/2 - math.floor(46 * _boardScale),
			scale = 1.2* _boardScale,
			scaleT = 0.95,
			code = function()
				_CODE_ClearFunc()
				if hVar.EnableAchievement == 1 then
					hGlobal.event:event("LocalEvent_ShowAchievementSummaryFrm")
				end
			end,
		})


		local titleX = (hVar.SCREEN.w - _boardW) / 2 + 110
		local titleY = (hVar.SCREEN.h - _boardH) / 2 - hVar.SCREEN.h + 26* _boardScale
		if #_PageList == 1 then
			titleX = (hVar.SCREEN.w - _boardW) / 2 + 140
			titleY = -hVar.SCREEN.h/2 + _boardH/2 - math.floor(61 * _boardScale)
		end
		
		--标题-我的排名
		_childUI["DLCMapInfoTitle_MyRank"] = hUI.label:new({
			parent = _parent,
			x = titleX, 
			y = titleY + 2,
			font = hVar.FONTC,
			size = math.floor(26),
			align = "LC",
			text = hVar.tab_string["rank"],
			border = 1,
			RGB = {212, 255, 212,},
		})
		
		if #_PageList == 1 then
			_currentPage = 1
			--_CODE_ChangePage(1)
		else
			for i = 1 , #_PageList do
				_childUI["btn_PageIndex"..i] = hUI.button:new({
					parent = _parent,
					dragbox = _childUI["dragBox"],
					model = "misc/billboard/btn_empty.png",
					label = {text = _PageList[i],size = 26,border = 1,font = hVar.FONTC},
					x = (hVar.SCREEN.w - _boardW) / 2 + math.floor((200 + (i-1) * 180) *_boardScale),
					y = -hVar.SCREEN.h/2 + _boardH/2 - math.floor(61 * _boardScale),
					--x = 240 + (i-1) * 180,
					--y = -90,
					scale = _boardScale,
					scaleT = 0.95,
					code = function()
						if _currentPage ~= i then
							_currentPage = i
							_CODE_ChangePage(i)
						end
					end,
				})
			end
		end
		
		--底框
		hApi.CCScale9SpriteCreate("data/image/misc/billboard/kuang5.png", _cliprect[1] + _cliprect[3]/2, _cliprect[2] -_cliprect[4]/2, _cliprect[3]+6, _cliprect[4]+6, _frm)
		
		--创建文本，提示连接超时
		_childUI["lab_ConnectTimeOut"] = hUI.label:new({
			parent = _parent,
			x = hVar.SCREEN.w / 2,
			y = -hVar.SCREEN.h / 2 - 20,
			font = hVar.FONTC,
			size = math.floor(28 * _boardScale),
			align = "MC",
			text = "CONNECT TIME OUT !",
			--border = 1,
			RGB = {192, 192, 192,},
		})
		_childUI["lab_ConnectTimeOut"].handle.s:setVisible(false)

		_clipNode = hApi.CreateClippingNode(_parent, _cliprect, 5, _cliprect[5])

		_frm:show(1)
		_frm:active()
	end

	_CODE_ChangePage = function(nIndex)
		hApi.safeRemoveT(_childUI,"clipnode")
		_CODE_CreatePageInfo()
		local bId = hVar.TANK_BILLBOARD_RANK_TYPE.RANK_STAGE --过图排行榜
		local diff = nIndex - 1
		SendCmdFunc["query_tank_billboard"](bId, diff)

		--添加查询超时一次性timer
		hApi.addTimerOnce("__TANK_QUERY_TIMEOUNT_TIMER__", 5000, refresh_query_billboard_timeout_timer)

		hApi.addTimerForever("__TANK_BILLBOARD_ASYNC__", hVar.TIMER_MODE.GAMETIME, 1, refresh_async_paint_billboard_loop)
	
		for i = 1 , #_PageList do
			local btn = _childUI["btn_PageIndex"..i]
			if btn then
				if i == nIndex then
					hApi.AddShader(_childUI["btn_PageIndex"..i].handle.s,"normal")
				else
					hApi.AddShader(_childUI["btn_PageIndex"..i].handle.s,"gray")
				end
			end
		end
	end

	_CODE_CreatePageInfo = function()
		_childUI["clipnode"] = hUI.node:new({
			parent = _clipNode,
			x = _cliprect[1],
			y = _cliprect[2],
		})
		
		_childUI["clipnode"].handle._n:setScale(_clipScale)
		--local _NodeParent = _childUI["clipnode"].handle._n
		--local _NodeChild =  _childUI["clipnode"].childUI
	end
	
	--创建排行信息
	_CODE_CreateRankInfo = function(billboard, index, rankMe)
		local rank = billboard.rank or index --排名
		local name = billboard.name or "USER" --玩家名
		local stage = billboard.stage or 0 --关卡进度
		local tankId = billboard.tankId or 6000 --坦克id
		local weaponId = billboard.weaponId or 6013 --武器id
		local gametime = billboard.gametime or 0 --通关时间
		local scientistNum = billboard.scientistNum or 0 --科学家数量
		local goldNum = billboard.goldNum or 0 --金币数量
		local killNum = billboard.killNum or 0  --连杀
		
		local offY = 0
		
		hApi.safeRemoveT(_childUI["clipnode"].childUI,"node"..index)
		_childUI["clipnode"].childUI["node"..index] = hUI.button:new({
			parent = _childUI["clipnode"].handle._n,
			model = "misc/button_null.png",
			x = 0,
			y = (- _rankInfoH  - 2) * (index - 0.5),
		})
		
		local _NodeParent = _childUI["clipnode"].childUI["node"..index].handle._n
		local _NodeChild =  _childUI["clipnode"].childUI["node"..index].childUI
		
		--[[
		--背景
		_NodeChild["Img_rankbg_" .. index] = hUI.image:new({
			parent = _NodeParent,
			model = "misc/billboard/kuang8.png",
			x = _rankInfoW/2 + 5,
			y = offY,
			z = 1,
			w = _rankInfoW,
			h = _rankInfoH - 4,
		})
		]]
		
		
		--排行的字体大小
		local rankFontSize = 24
		if (rank == 1) then --第1名
			rankFontSize = 32
		elseif (rank == 2) then --第2名
			rankFontSize = 30
		elseif (rank == 3) then --第3名
			rankFontSize = 28
		elseif (rank >= 4) and (rank <= 9) then --第4-9名
			rankFontSize = 26
		elseif (rank >= 10) and (rank <= 99) then --第10-99名
			rankFontSize = 24
		elseif (rank >= 100) then --第100+名
			rankFontSize = 20
		end
		
		--排名值
		_NodeChild["lab_rankNO" .. index] = hUI.label:new({
			parent = _NodeParent,
			x = 52,
			y = offY - 2,
			font = "num",
			size = rankFontSize,
			align = "MC",
			text = tostring(rank),
			border = 1,
		})
		
		--玩家名字
		_NodeChild["lab_playername" .. index] = hUI.label:new({
			parent = _NodeParent,
			x = 214,
			y = offY - 2,
			font = hVar.FONTC,
			size = 24,
			align = "MC",
			text = name,
			border = 1,
			RGB = {255, 255, 212,},
		})
		
		--进度条
		_NodeChild["img_process_bg" .. index] = hUI.image:new({
			parent = _NodeParent,
			x = 554,
			y = offY - 10,
			model = "misc/totalsettlement/process_light.png",
			align = "MC",
			scale = 0.36,
		})
		
		--进度的敌人BOSS图标
		local processW = _NodeChild["img_process_bg" .. index].data.w
		local processX = _NodeChild["img_process_bg" .. index].data.x
		for i = 1, stage, 1 do
			local sModel = string.format("icon/hero/boss_%02d.png", i)
			_NodeChild["img_boss_" .. index.."|"..i]= hUI.image:new({
				parent = _NodeParent,
				x = processX - processW / 2 + i/6 * processW - 2,
				y =  offY + 25,
				model = sModel,
				align = "MC",
				scale = 0.36,
			})
		end
		
		local tankScale = 0.32
		local tankX = processX - processW / 2 + stage/6 * processW - 2
		local tankY = offY -20
		--进度条战车图标
		_NodeChild["img_tank" .. index] = hUI.thumbImage:new({
			parent = _NodeParent,
			x = tankX,
			y = tankY,
			id = tankId,
			facing = 0,
			align = "MC",
			scale = tankScale * 1,
		})
		
		--进度条战车轮子图标
		_NodeChild["img_tankwheel" .. index] = hUI.thumbImage:new({
			parent = _NodeParent,
			x = tankX,
			y = tankY,
			id = hVar.tab_unit[tankId].bind_wheel,
			facing = 0,
			align = "MC",
			scale = tankScale,
		})
		
		--背景图
		local bgModel = nil
		local lineModel = nil
		if (index % 2 == 0) then
			bgModel = "misc/mask_white.png"
		else
			bgModel = "misc/mask_white.png"
		end
		
		--线条图
		local lineModel = nil --"ui/pvp/td_mui_blbar.png"
		if (rank == 1) then --第1名
			lineModel = "misc/mask_white.png" --"UI:vipline"
		elseif (rank == 2) then --第2名
			lineModel = "misc/mask_white.png"
		elseif (rank == 3) then --第3名
			lineModel = "misc/mask_white.png"
		else --其他名次
			lineModel = "misc/mask_white.png"
		end
		
		--线条颜色
		local lineColor = nil
		if (rank == 1) then --第1名
			--金色
			lineColor = hVar.RANKBOARD_COLOR.GOLD
		elseif (rank == 2) then --第2名
			--银色
			lineColor = hVar.RANKBOARD_COLOR.SILVER
		elseif (rank == 3) then --第3名
			--铜色
			lineColor = hVar.RANKBOARD_COLOR.COPPER
		else --其他名次
			--灰黑色
			lineColor = hVar.RANKBOARD_COLOR.DARKGRAY
		end
		
		--[[
		--左边界线
		_NodeChild["imageBG_lineL"] = hUI.image:new({
			parent = _NodeParent,
			model = lineModel,
			x = -_rankInfoW + 3,
			y = 0,
			w = _rankInfoH,
			h = 1,
		})
		_NodeChild["imageBG_lineL"].handle.s:setColor(lineColor) --线条的颜色
		_NodeChild["imageBG_lineL"].handle.s:setRotation(-90+180)
		]]
		
		--[[
		--右边界线
		_NodeChild["imageBG_lineR"] = hUI.image:new({
			parent = _NodeParent,
			model = lineModel,
			x =_rankInfoW - 3,
			y = 0,
			w = _rankInfoH,
			h = 1,
		})
		_NodeChild["imageBG_lineR"].handle.s:setColor(lineColor) --线条的颜色
		_NodeChild["imageBG_lineR"].handle.s:setRotation(90+180)
		]]
		
		--[[
		--上边界线
		_NodeChild["imageBG_lineU"] = hUI.image:new({
			parent = _NodeParent,
			model = lineModel,
			x = _rankInfoW / 2,
			y = _rankInfoH / 2,
			w = _rankInfoW, --宽
			h = 1,
		})
		_NodeChild["imageBG_lineU"].handle.s:setColor(lineColor) --线条的颜色
		_NodeChild["imageBG_lineU"].handle.s:setRotation(0+180)
		]]
		
		--下边界线
		_NodeChild["imageBG_lineD"] = hUI.image:new({
			parent = _NodeParent,
			model = lineModel,
			x = _rankInfoW / 2 + 8,
			y = -_rankInfoH / 2 + 1,
			w = _rankInfoW + 16, --宽
			h = 1,
		})
		_NodeChild["imageBG_lineD"].handle.s:setColor(lineColor) --线条的颜色
		--_NodeChild["imageBG_lineD"].handle.s:setRotation(180+180)
		
		local tabU = hVar.tab_unit[weaponId]
		if tabU then
			if tabU.model then
				--进度条战车武器图标
				_NodeChild["img_tankweapon" .. index] = hUI.thumbImage:new({
					parent = _NodeParent,
					x = tankX,
					y = tankY,
					id = weaponId,
					facing = 0,
					align = "MC",
					scale = tankScale,
				})
			end
			if tabU.effect then
				for i = 1,#tabU.effect do
					local effect = tabU.effect[i]
					local effectId = effect[1]
					local effX = effect[2] or 0
					local effY = effect[3] or 0
					local effScale = effect[4] or 1.0
					--print(effectId, cardId)
					local effModel = effectId
					if (type(effectId) == "number") then
						effModel = hVar.tab_effect[effectId].model
					end
					if effModel then
						_NodeChild["img_tankEffModel" .. index.."|"..i] = hUI.image:new({
							parent = _NodeParent,
							model = effModel,
							align = "MC",
							x = tankX + effX * tankScale,
							y = tankY + effY * tankScale,
							scale = 1.2 * effScale * tankScale,
							z = effect[4] or -1,
						})
						
						local tabM = hApi.GetModelByName(effModel)
						if tabM then
							local tRelease = {}
							local path = tabM.image
							tRelease[path] = 1
							hResource.model:releasePlist(tRelease)
							
							--geyachao: 可能会弹框，这里不删除了，统一在回收资源的地方释放
							--[[
							local pngPath = "data/image/"..(tabM.image)
							local texture = CCTextureCache:sharedTextureCache():textureForKey(pngPath)
							
							if texture then
								CCTextureCache:sharedTextureCache():removeTexture(texture)
							end
							]]
						end
					end
				end
			end
		end
		
		--通关时间图标
		_NodeChild["img_gametime" .. index] = hUI.image:new({
			parent = _NodeParent,
			x = 800,
			y = offY + 22,
			model = "misc/gameover/icon_time.png",
			align = "MC",
			scale = 0.5,
		})

		--通关时间文本
		local seconds = gametime
		local minute = math.floor(seconds / 60)
		local second = seconds - minute * 60
		local strTime = string.format("%d:%02d",minute,second)
		_NodeChild["img_gametime" .. index] = hUI.label:new({
			parent = _NodeParent,
			x = 820,
			y = offY + 20,
			font = "numWhite",
			size = 18,
			align = "LC",
			text = strTime,
			border = 1,
		})
		
		--金币图标
		_NodeChild["img_gold" .. index] = hUI.image:new({
			parent = _NodeParent,
			x = 800,
			y = offY - 20,
			model = "misc/skillup/mu_coin.png",
			align = "MC",
			scale = 0.5,
		})
		
		--金币值文本
		_NodeChild["img_gold" .. index].childUI["goldLabel"] = hUI.label:new({
			parent = _NodeParent,
			x = 820,
			y = offY - 22,
			font = "num",
			size = 18,
			align = "LC",
			text = goldNum,
			border = 1,
		})
		
		--科学家图标
		_NodeChild["img_scientist" .. index] = hUI.button:new({ --作为按钮只是为了挂载子控件
			parent = _NodeParent,
			x = 926,
			y = offY + 22,
			model = "misc/gameover/icon_man.png",
			align = "MC",
			scale = 0.5,
		})
		
		--科学家值文本
		_NodeChild["lab_scientist" .. index] = hUI.label:new({
			parent = _NodeParent,
			x = 946,
			y = offY + 20,
			font = "numWhite",
			size = 18,
			align = "LC",
			text = scientistNum,
			border = 1,
		})
		
		_NodeChild["node_bestCK" .. index] = hUI.node:new({
			parent = _NodeParent,
			x = 936,
			y = offY -20,
		})
		
		_NodeChild["node_bestCK" .. index].childUI["img_kill"] = hUI.image:new({
			parent = _NodeChild["node_bestCK" .. index].handle._n,
			x =  0,
			y = 24,
			model = "misc/continuouskilling/kill.png",
		})
		
		--连杀加号"+"
		_NodeChild["node_bestCK" .. index].childUI["img_add"] = hUI.image:new({
			parent = _NodeChild["node_bestCK" .. index].handle._n,
			x = - 20,
			y = - 18,
			model = "UI:CKSystemNum",
			scale = 0.8,
			animation = "ADD",
		})
		
		--连杀值
		local sNum = tostring(killNum)
		local length = #sNum
		for j = 1,length do
			local n = math.floor(killNum / (10^(length-j)))% 10
			_NodeChild["node_bestCK" .. index].childUI["lab_n"..j] = hUI.image:new({
				parent = _NodeChild["node_bestCK" .. index].handle._n,
				model = "UI:CKSystemNum",
				animation = "N"..n,
				x = 45 * j * 0.8 - 10,
				y = - 18,
				scale = 0.8,
			})
		end
		_NodeChild["node_bestCK" .. index].handle._n:setScale(0.4)
		
		if hVar.EnableAchievement == 1 then
			local nRating = hApi.GetAchievementRating(hVar.AchievementType.CLEARANCE,billboard)
			local medalModel = hApi.GetRatingModel(hVar.AchievementType.CLEARANCE,nRating)
			if type(medalModel) == "string" and medalModel ~= "" then
				_NodeChild["img_medal_bg" .. index] = hUI.image:new({
					parent = _NodeParent,
					x = 1010,
					y = offY,
					model = "misc/achievements/medal_bg.png",
					align = "MC",
					--scale = 0.9,
				})

				_NodeChild["img_medal" .. index] = hUI.image:new({
					parent = _NodeParent,
					x = 1010,
					y = offY,
					model = medalModel,
					align = "MC",
					--scale = 0.9,
				})
			end
		else
			--通关加个奖杯
			if stage == 6 then
				_NodeChild["img_cup" .. index] = hUI.image:new({
					parent = _NodeParent,
					x = 1010,
					y = offY,
					model = "misc/totalsettlement/cup.png",
					align = "MC",
					scale = 0.9,
				})
			end
		end
		
		--本条是我
		if (rank == rankMe) then
			--标识我的箭头
			_NodeChild["imageBG_RankMe"] = hUI.image:new({
				parent = _NodeParent,
				model = "effect/select_triangle.png",
				x = 18,
				y = offY - 2,
				scale = 1.0,
			})
			_NodeChild["imageBG_RankMe"].handle.s:setRotation(270)
			--动画
			local act1 = CCMoveBy:create(0.2, ccp(4, 0))
			local act2 = CCMoveBy:create(0.2, ccp(-4, 0))
			local act3 = CCMoveBy:create(0.2, ccp(4, 0))
			local act4 = CCMoveBy:create(0.2, ccp(-4, 0))
			local act5 = CCDelayTime:create(1.0)
			local a = CCArray:create()
			a:addObject(act1)
			a:addObject(act2)
			a:addObject(act3)
			a:addObject(act4)
			a:addObject(act5)
			local sequence = CCSequence:create(a)
			_NodeChild["imageBG_RankMe"].handle.s:runAction(CCRepeatForever:create(sequence))
			
			--我的名字绿色
			_NodeChild["lab_playername" .. index].handle.s:setColor(ccc3(0, 255, 0))
			
			--我的时间绿色
			_NodeChild["img_gametime" .. index].handle.s:setColor(ccc3(0, 255, 0))
			
			--我的科学家绿色
			_NodeChild["lab_scientist" .. index].handle.s:setColor(ccc3(0, 255, 0))
			
			--我的金币绿色
			_NodeChild["img_gold" .. index].childUI["goldLabel"].handle.s:setColor(ccc3(0, 255, 0))
			
			--我的连杀加号"+"绿色
			_NodeChild["node_bestCK" .. index].childUI["img_add"].handle.s:setColor(ccc3(0, 255, 0))
			
			--我的击杀绿色
			for j = 1,length do
				_NodeChild["node_bestCK" .. index].childUI["lab_n"..j].handle.s:setColor(ccc3(0, 255, 0))
			end
		end
		
	end
	
	--创建我的排名信息
	_CODE_CreateMyRankInfo = function(nIndex,billobardT)
		hApi.safeRemoveT(_childUI,"lab_RankMe")
		local font = "num" --hVar.FONTC
		local text = "--"
		if nIndex > 0 then
			font = "num"
			text = tostring(nIndex)
		end
		local x = (hVar.SCREEN.w - _boardW) / 2 + 220
		local y = (hVar.SCREEN.h - _boardH) / 2 - hVar.SCREEN.h + 26*_boardScale -2
		if #_PageList == 1 then
			x = (hVar.SCREEN.w - _boardW) / 2 + 250
			y =  -hVar.SCREEN.h/2 + _boardH/2 - math.floor(61 * _boardScale) - 2
		end

		if g_Cur_Language == 4 then
			x = x + 30
		end
		
		--我的名次文字
		_childUI["lab_RankMe"] = hUI.label:new({
			parent = _parent,
			x = x, 
			y = y,
			font = font,
			size = math.floor(26*_boardScale),
			align = "MC",
			text = text,
			border = 1,
		})

		if hVar.EnableAchievement == 1 then
			local nRating = hApi.GetAchievementRating(hVar.AchievementType.CLEARANCE,billobardT[nIndex])
			local medalModel = hApi.GetRatingModel(hVar.AchievementType.CLEARANCE,nRating)
			if type(medalModel) == "string" and medalModel ~= "" then
				_childUI["img_mymedal_bg"] = hUI.image:new({
					parent = _parent,
					x = x + 80, 
					y = y,
					model = "misc/achievements/medal_bg.png",
					align = "MC",
					--scale = 0.9,
				})

				_childUI["img_mymedal"] = hUI.image:new({
					parent = _parent,
					x = x + 80,
					y = y,
					model = medalModel,
					align = "MC",
					--scale = 0.9,
				})
			end
		end
	end

	_CODE_AutoLign = function(offy)
		local Node =_childUI["clipnode"]
		local waittime = 0.2
		Node.handle._n:runAction(CCMoveTo:create(waittime,ccp(_cliprect[1],offy)))
		hApi.addTimerOnce("LegionInfoAutoAlign",waittime*1000+1,function()
			hUI.uiSetXY(Node, _cliprect[1],offy)
			_canDrag = true
		end)
	end

	_CODE_OnPageDrag = function(self,tTempPos,tPickParam)
		--print("_CODE_OnPageDrag")
		if 0 == tPickParam.state then
			if (tTempPos.y-tTempPos.ty)^2>144 then	--触摸移动点如果大于12个像素，即作为滑动处理
				if tPickParam.code and tPickParam.code~=0 then			--如果存在拖拉函数，则处理拖拉函数
					local pCode = tPickParam.code
					tPickParam.code = 0
					pCode(self,tTempPos,tPickParam)
				end
				if tPickParam.state==0 then
					tPickParam.state = 1					--设置状态：进入拖拉状态
					tTempPos.tx = tTempPos.x
					tTempPos.ty = tTempPos.y
				else
					return 0
				end
			else
				return 0
			end
		elseif 1 == tPickParam.state then
			local offy = tTempPos.y-tTempPos.ty
		end
	end

	_CODE_OnInfoUp = function(self,tTempPos,tPickParam)
		if 1 == tPickParam.state then
			local offy = tTempPos.y-tTempPos.ty + tTempPos.oy - _cliprect[2]
			local finaly = offy
			if offy > _dragrect[4] then
				_canDrag = false
				finaly = _cliprect[2]+_dragrect[4]
			elseif offy < 0 then
				finaly = _cliprect[2]
			else
				return
			end
			_canDrag = false
			--print("finaly",finaly)
			_CODE_AutoLign(finaly)
		elseif 0 == tPickParam.state then

		end
	end
	
	refresh_query_billboard_timeout_timer = function()
		_currentPage = 0
		_childUI["lab_ConnectTimeOut"].handle.s:setVisible(true)
	end
	
	refresh_async_paint_billboard_loop = function()
		if #_asyncCreateList > 0 then
			local data, rank, rankMe = unpack(_asyncCreateList[1])
			_CODE_CreateRankInfo(data, rank, rankMe)
			table.remove(_asyncCreateList,1)
		end
	end
	
	on_receive_billobard_info_Back = function(result, bId, diff, billobardT)
		if bId ~= hVar.TANK_BILLBOARD_RANK_TYPE.RANK_STAGE then
			return
		end
		--清除计时器
		hApi.clearTimer("__TANK_QUERY_TIMEOUNT_TIMER__")
		_childUI["lab_ConnectTimeOut"].handle.s:setVisible(false)
		
		--我的排名
		local rankMe = billobardT.rankMe
		_CODE_CreateMyRankInfo(rankMe,billobardT)
		
		local num = #billobardT
		for i = 1,num do
			local billboard = billobardT[i]
			_asyncCreateList[#_asyncCreateList+1] = {billboard, billboard.rank, rankMe,}
			--_CODE_CreateRankInfo(billboard, billboard.rank, rankMe)
		end
		local gh = math.max(0,num*_gridWH[2] - _cliprect[4])
		_dragrect = {_cliprect[1], _cliprect[2]+gh, 0, math.max(1, gh)}
		_canDrag = true
	end
	
	hGlobal.event:listen(tInitEventName[1],tInitEventName[2],function()
		--添加事件监听：收到排行榜信息回调
		hGlobal.event:listen("localEvent_TankBillboardData", "__getTankBillboardData", on_receive_billobard_info_Back)
		--界面未打开 可创建
		_CODE_CreateTankRankBoardFrm()
		
		_CODE_ChangePage(1)
	end)
end