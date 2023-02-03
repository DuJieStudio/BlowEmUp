local BOARD_WIDTH = 720 -- 随机迷宫地图面板面板的宽度
local BOARD_HEIGHT = 720 -- 随机迷宫地图面板面板的高度
local BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 0
local BOARD_OFFSETY = 0 -- 随机迷宫地图面板面板y偏移中心点的值
local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX -- 随机迷宫地图面板面板的x位置（最左侧）
local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY -- 随机迷宫地图面板面板的y位置（最顶侧）

-- 横屏模式
if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
    BOARD_WIDTH = 740 -- DLC地图面板面板的宽度
    BOARD_HEIGHT = 690 -- DLC地图面板面板的高度
    BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 20
    BOARD_OFFSETY = 15 -- DLC地图面板面板y偏移中心点的值
    BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX -- DLC地图面板面板的x位置（最左侧）
    BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY -- DLC地图面板面板的y位置（最顶侧）
end

local PAGE_BTN_LEFT_X = 480 -- 第一个分页按钮的x偏移
local PAGE_BTN_LEFT_Y = -6 -- 第一个分页按钮的x偏移
local PAGE_BTN_OFFSET_X = 140 -- 每个分页按钮的间距

-- 临时UI管理
local leftRemoveFrmList = {} -- 左侧控件集
local rightRemoveFrmList = {} -- 右侧控件集
local _removeLeftFrmFunc = hApi.DoNothing -- 清空左侧所有的临时控件
local _removeRightFrmFunc = hApi.DoNothing -- 清空右侧所有的临时控件

-- 局部函数
local OnClickPageBtn = hApi.DoNothing -- 点击分页按钮
local RefreshSelectedCardFrame = hApi.DoNothing -- 更新绘制当前查看的卡牌的信息

-- 分页1：显示随机迷宫地图界面
local OnCreateDLCMapInfoFrame = hApi.DoNothing -- 创建随机迷宫地图界面（第1个分页）
-- local OnCreateDLCMapInfoFrame_LeftPart = hApi.DoNothing --绘制左侧随机迷宫地图包列表界面
-- local OnCreateDLCMapInfoFrame_RightPart = hApi.DoNothing --显示某个随机迷宫地图包的详细信息
-- local OnRefresnDLCMapInfoFrame_LeftPart = hApi.DoNothing --刷新左侧随机迷宫地图包列表界面
-- local refresh_dlcmapinfo_UI_loop = hApi.DoNothing --刷新随机迷宫地图面板界面的滚动
-- local on_receive_DLCMapInfo_Back = hApi.DoNothing --收到购买随机迷宫地图包的回调事件
-- local on_close_MapInfo_Panel = hApi.DoNothing --关闭某一关的地图信息的回调事件
-- local OnClickMapButton = hApi.DoNothing --点击指定地图按钮
-- local OnClickDifficultyButton = hApi.DoNothing --点击指定难度按钮
local On_Receive_LocalEvent_MonthCardGiftList = hApi.DoNothing -- 月卡查询信息回调
local On_Receive_LocalEvent_Purchase_Back = hApi.DoNothing -- 月卡购买结果回调
local on_spine_screen_event = hApi.DoNothing -- 横竖屏切换
local on_changename_result_event = hApi.DoNothing -- 战车改名回调事件
local UpdateCurrentSelectedTankUI = hApi.DoNothing -- 更新当前选中的战车界面
local OnSelectTankIdx = hApi.DoNothing -- 选择指定战车索引
local OnSelectTankAvterIndx = hApi.DoNothing -- 选择指定战车皮肤索引
local OnClickSkinShareBtn = hApi.DoNothing -- 点击皮肤分享按钮
local OnClosePanel = hApi.DoNothing -- 关闭本界面
-- local getUpDownOffset = hApi.DoNothing --获得第一个控件和最后一个控件距离最上面边界线和最下面边界线的距离
local TankSkinConditionBtnCallbackList = {} --战车皮肤条件按钮数组

-- 分页1：随机迷宫地图包的参数
local DLCMAPINFO_WIDTH = 120 -- 随机迷宫地图包宽度
local DLCMAPINFO_HEIGHT = 120 -- 随机迷宫地图包高度
local DLCMAPINFO_OFFSET_X = 0 -- 随机迷宫地图包统一偏移x
local DLCMAPINFO_OFFSET_Y = 0 -- 随机迷宫地图包统一偏移y
local DLCMAPINFO_BOARD_HEIGHT = 570 -- 随机迷宫地图包高度
local DLCMAPINFO_X_NUM = 3 -- 随机迷宫地图面板x的数量
local DLCMAPINFO_Y_NUM = 1 -- 随机迷宫地图面板y的数量
local MAX_SPEED = 50 -- 最大速度

-- 可变参数
local current_selectedIdx = 0 -- 上次选中的地图索引
local current_selectedAvaterIdx = 0 -- 上次选中的皮肤索引
-- local current_selectedDifficulty = 0 --上次选中的地图难度
-- local current_DLCMap_max_num = 0 --最大的随机迷宫地图包数量
-- local current_NET_SHOP_MAP_DLC = {}

-- 控制参数
local click_pos_x_dlcmapinfo = 0 -- 开始按下的坐标x
local click_pos_y_dlcmapinfo = 0 -- 开始按下的坐标y
local last_click_pos_y_dlcmapinfo = 0 -- 上一次按下的坐标x
local last_click_pos_y_dlcmapinfo = 0 -- 上一次按下的坐标y
local draggle_speed_y_dlcmapinfo = 0 -- 当前滑动的速度x
local selected_dlcmapinfoEx_idx = 0 -- 选中的随机迷宫地图面板ex索引
local click_scroll_dlcmapinfo = false -- 是否在滑动随机迷宫地图面板中
local b_need_auto_fixing_dlcmapinfo = false -- 是否需要自动修正
local friction_dlcmapinfo = 0 -- 阻力

local current_funcCallback = nil -- 关闭后的回调事件
-- local current_strEnterMapName = nil --进入时指定选中的地图名
-- local current_nEnterMapDifficulty = nil --进入时指定选中的地图难度

local _bCanCreate = true -- 防止重复创建

-- 当前选中的记录
local CurrentSelectRecord = {
    pageIdx = 0,
    contentIdx = 0,
    cardId = 0
} -- 当前选择的分页、数据项的信息记录

-- 战车皮肤面板
hGlobal.UI.InitTankAvaterInfoFrm = function(mode)
    local tInitEventName = {
        "LocalEvent_TankAvaterFrm",
        "__ShowTankAvaterFrm"
    }
    if (mode ~= "reload") then
        -- return tInitEventName
        return
    end

    -- 不重复创建随机迷宫地图信息面板
    if hGlobal.UI.PhoneTankAvaterInfoFrm then -- 随机迷宫地图信息面板
        hGlobal.UI.PhoneTankAvaterInfoFrm:del()
        hGlobal.UI.PhoneTankAvaterInfoFrm = nil
    end

    --[[
	--取消监听打开随机迷宫地图信息界面通知事件
	hGlobal.event:listen("LocalEvent_TankAvaterFrm", "__ShowTankAvaterFrm", nil)
	--取消监听切场景把自己藏起来
	--hGlobal.event:listen("LocalEvent_PlayerFocusWorld", "__Phone_UI__HideRandomMapInfo", nil)
	--取消监听关闭宝箱界面事件
	hGlobal.event:listen("clearPhoneChestFrm", "__CloseTankAvaterFrm", nil)
	]]

    BOARD_WIDTH = 720 -- 随机迷宫地图面板面板的宽度
    BOARD_HEIGHT = 720 -- 随机迷宫地图面板面板的高度
    BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 0
    BOARD_OFFSETY = 0 -- 随机迷宫地图面板面板y偏移中心点的值
    BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX -- 随机迷宫地图面板面板的x位置（最左侧）
    BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY -- 随机迷宫地图面板面板的y位置（最顶侧）
    -- 横屏模式
    if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
        BOARD_WIDTH = 740 -- DLC地图面板面板的宽度
        BOARD_HEIGHT = 690 -- DLC地图面板面板的高度
        BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 20
        BOARD_OFFSETY = 15 -- DLC地图面板面板y偏移中心点的值
        BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX -- DLC地图面板面板的x位置（最左侧）
        BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY -- DLC地图面板面板的y位置（最顶侧）
    end

    -- 加载资源
    -- xlLoadResourceFromPList("data/image/misc/pvp.plist")

    hApi.clearTimer("__DLC_MAPINFO_UPDATE__")

    -- 创建随机迷宫地图信息面板
    hGlobal.UI.PhoneTankAvaterInfoFrm = hUI.frame:new({
        x = BOARD_POS_X,
        y = BOARD_POS_Y,
        z = hZorder.MainBaseFirstFrm,
        w = BOARD_WIDTH,
        h = BOARD_HEIGHT,
        dragable = 2,
        show = 0, -- 一开始不显示
        border = 0, -- 显示frame边框
        -- background = "panel/panel_part_00.png", --"UI:Tactic_Background",
        background = -1, -- "misc/addition/story_panel.png",
        -- background = "UI:tip_item",
        -- background = "UI:Tactic_Background",
        -- background = "UI:herocardfrm",
        autoactive = 0,

        -- 点击事件
        codeOnTouch = function(self, x, y, sus)
            -- 在外部点击
            if (sus == 0) then
                CommentManage.LeaveArea()
                self.childUI["closeBtn"].data.code()
            end
        end
    })

    local _frm = hGlobal.UI.PhoneTankAvaterInfoFrm
    local _parent = _frm.handle._n

    -- 左侧裁剪区域
    local _BTC_PageClippingRect = {
        0,
        0,
        720,
        720,
        0
    } -- {x, y, w, h, ???}
    local _BTC_pClipNode_dlc = hApi.CreateClippingNode_Diablo(_frm, _BTC_PageClippingRect, 99, _BTC_PageClippingRect[5],
        "_BTC_pClipNode_dlc")

    -- 背景底图
    _frm.childUI["BG"] = hUI.image:new({
        parent = _parent,
        model = "misc/mask_white.png",
        x = 0,
        y = 0,
        z = -100,
        w = hVar.SCREEN.w * 2,
        h = hVar.SCREEN.h * 2
    })
    _frm.childUI["BG"].handle.s:setOpacity(88)
    _frm.childUI["BG"].handle.s:setColor(ccc3(0, 0, 0))

    -- 关闭按钮
    _frm.childUI["closeBtn"] = hUI.button:new({
        parent = _parent,
        dragbox = _frm.childUI["dragBox"],
        -- model = "UI:BTN_Close", --BTN:PANEL_CLOSE
        model = "misc/mask.png",
        x = BOARD_WIDTH - 56 + 2000, -- 不显示了,
        y = -64,
        z = 1,
        w = 86,
        h = 86,
        scaleT = 0.95,
        code = function()
            -- 关闭本界面
            OnClosePanel()

            -- 由关闭按钮触发的关闭，不能再次打开
            _bCanCreate = false

            -- 回调事件
            if (type(current_funcCallback) == "function") then
                current_funcCallback()
            end
        end
    })
    _frm.childUI["closeBtn"].handle.s:setOpacity(0) -- 只响应事件，不显示
    -- 关闭图标
    _frm.childUI["closeBtn"].childUI["icon"] = hUI.button:new({
        parent = _frm.childUI["closeBtn"].handle._n,
        model = "misc/skillup/btn_close.png",
        -- model = "BTN:PANEL_CLOSE",
        align = "MC",
        x = 0,
        y = 0,
        scale = 1.0
    })

    _frm.childUI["btn_comment"] = hUI.button:new({
        parent = _parent,
        model = "misc/addition/commentbtn.png",
        dragbox = _frm.childUI["dragBox"],
        x = BOARD_WIDTH - (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL and 120 or 100),
        y = -38,
        scale = 0.8,
        scaleT = 0.8,
        z = 100,
        code = function()
            hGlobal.event:event("LocalEvent_DoCommentProcess", {})
        end
    })

    _frm.childUI["btn_month_card"] = hUI.button:new({
        parent = _parent,
        model = "UI:MONTHCARD_ICON",
        dragbox = _frm.childUI["dragBox"],
        x = BOARD_WIDTH - (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL and 360 or 340),
        y = -38,
        scale = 0.6,
        scaleT = 0.8,
        z = 100,
        code = function()
            -- print("点击月卡按钮")
            hApi.ShowMonthCardPurchaseTip()
        end
    })
	hApi.AddShader(_frm.childUI["btn_month_card"].handle.s, "gray")
    -- _frm.childUI["btn_month_card"]:setstate(0)

    _frm.childUI["btn_month_card"].childUI["label_month_card_lefttime"] = hUI.label:new({
        parent = _frm.childUI["btn_month_card"].handle._n,
        x = 20,
        y = -5,
        size = 30,
        scale = 0.7,
        align = "LC",
        border = 0,
        font = hVar.FONTC,
        width = 300,
        text = "",
        RGB = {0, 200, 0}
    })
    _frm.childUI["btn_month_card"].childUI["label_month_card_lefttime"].handle._n:setVisible(false)

    -- 每个分页按钮
    -- 随机迷宫地图面板
    local tPageIcons = {
        "UI:ach_king"
    }
    -- local tTexts = {"地图包",} --language
    local tTexts = {
        ""
    } -- language
    for i = 1, #tPageIcons, 1 do
        -- 分页按钮
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
            end
        })
        _frm.childUI["PageBtn" .. i].handle.s:setOpacity(0) -- 分页按钮点击区域，只作为控制用，不用于显示

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

    -- 分页内容的的父控件
    _frm.childUI["PageNode"] = hUI.button:new({
        parent = _frm,
        -- model = tPageIcons[i],
        x = 0,
        y = 0,
        w = 1,
        h = 1
        -- border = 0,
        -- background = "UI:Tactic_Background",
        -- z = 10,
    })

    -- 清空所有分页左侧的UI
    _removeLeftFrmFunc = function(pageIndex)
        local _frm = hGlobal.UI.PhoneTankAvaterInfoFrm
        local _frmNode = _frm.childUI["PageNode"]

        for i = 1, #leftRemoveFrmList do
            hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i])
        end
        leftRemoveFrmList = {}
    end

    -- 清空所有分页右侧的UI
    _removeRightFrmFunc = function(pageIndex)
        local _frm = hGlobal.UI.PhoneTankAvaterInfoFrm
        local _frmNode = _frm.childUI["PageNode"]

        for i = 1, #rightRemoveFrmList do
            hApi.safeRemoveT(_frmNode.childUI, rightRemoveFrmList[i])
        end
        rightRemoveFrmList = {}
    end

    -- 函数：点击分页按钮函数
    OnClickPageBtn = function(pageIndex)
        -- 不重复显示同一个分页
        if (CurrentSelectRecord.pageIdx == pageIndex) then
            return
        end

        -- 启用全部的按钮
        for i = 1, #tPageIcons, 1 do
            -- _frm.childUI["PageBtn" .. i]:setstate(1) --按钮可用
            -- _frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s:setVisible(true) --显示图片
            -- _frm.childUI["PageBtn" .. i].childUI["PageIcon"].handle.s:setVisible(true) --显示图标
            -- _frm.childUI["PageBtn" .. i].childUI["Text"].handle.s:setVisible(true) --显示文字
        end

        -- 当前按钮高亮
        --[[
		hApi.AddShader(_frm.childUI["PageBtn" .. pageIndex].childUI["PageImage"].handle.s, "normal")
		
		--其它按钮灰掉
		for i = 1, #tPageIcons, 1 do
			if (i ~= pageIndex) then
				hApi.AddShader(_frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s, "gray")
			end
		end
		]]

        -- 先清空上次分页的全部信息
        _removeLeftFrmFunc()
        _removeRightFrmFunc()

        -- 清空切换分页之后取消的监听事件
        -- 移除事件监听：横竖屏切换
        hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenRandomMap_", nil)
        -- 移除事件监听：战车改名结果回调
        hGlobal.event:listen("localEvent_modify_tank_username", "_ChangeNameTankAvater_", nil)

        -- 移除timer
        hApi.clearTimer("__DLC_MAPINFO_UPDATE__")

        -- 隐藏所有的clipNode
        hApi.EnableClipByName_Diablo(_frm, "_BTC_pClipNode_dlc", 0)

        -- 新建该分页下的全部信息
        if (pageIndex == 1) then -- 分页1：随机迷宫地图信息
            -- 创建随机迷宫地图信息分页
            OnCreateDLCMapInfoFrame(pageIndex)
        end

        -- 标记当前选择的分页和页内的第几个
        CurrentSelectRecord.pageIdx = pageIndex
        CurrentSelectRecord.contentIdx = 1 -- 默认选中第一个
    end

    -- 函数：关闭本界面
    OnClosePanel = function()
        local _frm = hGlobal.UI.PhoneTankAvaterInfoFrm
        local _frmNode = _frm.childUI["PageNode"]
        local _parentNode = _frmNode.handle._n

        -- 不显示随机迷宫地图信息面板
        hGlobal.UI.PhoneTankAvaterInfoFrm:show(0)

        -- 关闭界面后不需要监听的事件
        -- 取消监听：
        -- ...

        -- 清空切换分页之后取消的监听事件
        -- 移除事件监听：横竖屏切换
        hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenRandomMap_", nil)
        -- 移除事件监听：战车改名结果回调
        hGlobal.event:listen("localEvent_modify_tank_username", "_ChangeNameTankAvater_", nil)
        -- 移除事件监听：月卡查询信息回调
        hGlobal.event:listen("localEvent_MonthCardGiftList", "_UpdateMonthCard_TankAvaterFrm", nil)
		-- 移除事件监听：月卡购买结果回调
		hGlobal.event:listen("LocalEvent_Purchase_Back", "_PurchaseBack_TankAvaterFrm", nil)

        -- 清空上次分页的全部信息
        _removeLeftFrmFunc()
        _removeRightFrmFunc()

        -- 删除DLC界面下拉滚动timer
        hApi.clearTimer("__DLC_MAPINFO_UPDATE__")

        -- 隐藏所有的clipNode
        hApi.EnableClipByName_Diablo(_frm, "_BTC_pClipNode_dlc", 0)

        -- 关闭金币、积分界面
        hGlobal.event:event("LocalEvent_CloseGameCoinFrm")

        -- 触发事件：关闭了主菜单按钮
        -- hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")

        -- 释放png, plist的纹理缓存（这里不清理也可以）
        -- hApi.ReleasePngTextureCache()

        -- 允许再次打开
        _bCanCreate = true
    end

    -- 函数：创建随机迷宫地图信息界面（第1个分页）
    OnCreateDLCMapInfoFrame = function(pageIdx)
        local _frm = hGlobal.UI.PhoneTankAvaterInfoFrm
        local _frmNode = _frm.childUI["PageNode"]
        local _parentNode = _frmNode.handle._n

        -- 允许本分页的的clipNode
        hApi.EnableClipByName_Diablo(_frm, "_BTC_pClipNode_dlc", 1)

        -- 初始化参数
        -- current_selectedIdx = 1 --上次选中的地图索引
        -- current_selectedDifficulty = 0 --上次选中的地图难度
        -- current_DLCMap_max_num = 0 --最大的随机迷宫地图面板id

        -- local i = 3

        -- 左侧裁剪区域
        -- local _BTC_PageClippingRect = {0, -82, 1000, 408, 0}
        -- local _BTC_pClipNode_dlc = hApi.CreateClippingNode(_parentNode, _BTC_PageClippingRect, 99, _BTC_PageClippingRect[5])

        -- 太空仓背景图
        _frmNode.childUI["DLCMapInfoTripImg"] = hUI.button:new(
            { -- 作为按钮只是为了挂载子控件
                parent = _parentNode,
                model = "misc/addition/tank_dikuang.png",
                x = DLCMAPINFO_OFFSET_X + 720 / 2,
                y = DLCMAPINFO_OFFSET_Y - 720 / 2,
                w = 724,
                h = 732
            })
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTripImg"
        -- 九宫格
        -- local s9 = hApi.CCScale9SpriteCreate("data/image/misc/addition/tank_dikuang.png", 0, 0+40/2, 720, 720-40, _frmNode.childUI["DLCMapInfoTripImg"])

        -- 效果图
        --[[
		_frmNode.childUI["tank_pifu_RESULT"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/addition/tank_pifu_RESULT.png",
			x = DLCMAPINFO_OFFSET_X + 720/2+4,
			y = DLCMAPINFO_OFFSET_Y - 720/2+8,
			w = 731,
			h = 738,
			z = 10,
		})
		_frmNode.childUI["tank_pifu_RESULT"].handle.s:setOpacity(hVar.TEST_OPACITY)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "tank_pifu_RESULT"
		--]]

        -- 头像框背景图
        _frmNode.childUI["DLCMapInfoRoleIconBG"] = hUI.image:new({
            parent = _parentNode,
            model = "misc/addition/tank_touxiang01.png",
            -- TODO: 修改坐标
            x = DLCMAPINFO_OFFSET_X + 110 - 30 - 11,
            y = DLCMAPINFO_OFFSET_Y - 80 + 15 + 20,
            z = 1,
            w = 54,
            h = 54
        })
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoRoleIconBG"

        -- 头像
        _frmNode.childUI["DLCMapInfoRoleIcon"] = hUI.image:new({
            parent = _parentNode,
            model = "misc/addition/tank_touxiang02.png",
            -- TODO: 修改坐标
            x = DLCMAPINFO_OFFSET_X + 110 - 30 - 11,
            y = DLCMAPINFO_OFFSET_Y - 80 + 15 + 20,
            w = 54,
            h = 54
        })
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoRoleIcon"

        -- 名字底框图
        _frmNode.childUI["DLCMapInfoRoleNameBG"] = hUI.image:new({
            parent = _parentNode,
            model = "misc/addition/tank_mingzi01.png",
            -- TODO: 修改坐标
            x = DLCMAPINFO_OFFSET_X + 254 - 30 - 22,
            y = DLCMAPINFO_OFFSET_Y - 80 - 20 + 15 + 22,
            w = 212,
            h = 4
        })
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoRoleNameBG"

        -- 名字文本
        local curMyName = g_curPlayerName
        local playerInfo = LuaGetPlayerByName(g_curPlayerName)
        if playerInfo and (playerInfo.showName) then
            curMyName = playerInfo.showName
        end
        _frmNode.childUI["DLCMapInfoRoleName"] = hUI.label:new({
            parent = _parentNode,
            -- TODO: 修改坐标
            x = DLCMAPINFO_OFFSET_X + 160 - 30 - 20,
            y = DLCMAPINFO_OFFSET_Y - 80 + 2 + 15 + 24,
            font = hVar.FONTC,
            border = 1,
            text = curMyName,
            size = 27,
            width = 500,
            align = "LC"
        })
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoRoleName"

        -- 改名按钮
        _frmNode.childUI["DLCMapInfoModifyBtn"] = hUI.button:new({
            parent = _parentNode,
            model = "misc/mask.png",
            -- TODO: 修改坐标
            x = DLCMAPINFO_OFFSET_X + 220 - 30,
            y = DLCMAPINFO_OFFSET_Y - 80 + 15,
            w = 280,
            h = 84,
            dragbox = _frm.childUI["dragBox"],
            scaleT = 0.95,
            code = function()
                -- 弹出起名界面
                hApi.CreateModifyInputBox_Diablo(1, 2, nil, true)
            end
        })
        _frmNode.childUI["DLCMapInfoModifyBtn"].handle.s:setOpacity(0) -- 只相应事件，不显示
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoModifyBtn"
        --[[
		--改名图片
		_frmNode.childUI["DLCMapInfoModifyBtn"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["DLCMapInfoModifyBtn"].handle._n,
			model = "misc/addition/tank_mingzi02.png",
			x = 0,
			y = 0,
			w = 38,
			h = 38,
		})
		]]

        -- 战车换车底图2
        -- _frmNode.childUI["DLCMapInfoTankModifyBG2"] = hUI.image:new({
        -- 	parent = _parentNode,
        -- 	model = "misc/addition/tank_xuanche02.png",
        -- 	-- TODO: 调整坐标
        -- 	x = DLCMAPINFO_OFFSET_X + 526 - 30 + 200,
        -- 	y = DLCMAPINFO_OFFSET_Y - 712 + 670,
        -- 	w = 214,
        -- 	h = 72,
        -- })
        -- leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankModifyBG2"

        -- 战车换车底图
        -- _frmNode.childUI["DLCMapInfoTankModifyBG"] = hUI.image:new({
        -- 	parent = _parentNode,
        -- 	model = "misc/addition/tank_xuanche01.png",
        -- 	-- TODO: 调整坐标
        -- 	x = DLCMAPINFO_OFFSET_X + 526 - 30,
        -- 	y = DLCMAPINFO_OFFSET_Y - 712 + 670,
        -- 	z = 1,
        -- 	w = 234,
        -- 	h = 82,
        -- })
        -- leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankModifyBG"

        -- 绘制全部战车车身
        local selected_bg_list = {
            "up",
            "mid",
            "down"
        }
        local tank_unit = hVar.tab_unit[hVar.MY_TANK_ID].tank_unit
        for i = 1, #tank_unit, 1 do
            local tankId = tank_unit[i]
            local icon = hVar.tab_unit[tankId].icon

            -- 父控件
            _frmNode.childUI["DLCMapInfoTankBtn_" .. i] = hUI.button:new({
                parent = _parentNode,
                model = "misc/mask.png",
                -- TODO: 调整坐标
                x = 670,
                y = -130 - (i - 1) * 72,
                w = 72,
                h = 72,
                dragbox = _frm.childUI["dragBox"],
                scaleT = 0.95,
                code = function()
                    if (current_selectedIdx ~= i) then
                        -- 更新选中
                        current_selectedIdx = i
                        current_selectedAvaterIdx = 0 -- 上次选中的皮肤索引
                        UpdateCurrentSelectedTankUI(i)
                    end
                end
            })
            _frmNode.childUI["DLCMapInfoTankBtn_" .. i].handle.s:setOpacity(0) -- 只相应事件，不显示
            leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankBtn_" .. i

            -- 坦克模型
            _frmNode.childUI["DLCMapInfoTankBtn_" .. i].childUI["tank"] = hUI.image:new({
                parent = _frmNode.childUI["DLCMapInfoTankBtn_" .. i].handle._n,
                model = icon,
                x = 0,
                y = 0,
                w = 58,
                h = 58
            })

            -- 选中框
            _frmNode.childUI["DLCMapInfoTankBtn_" .. i].childUI["selectbox"] = hUI.image:new({
                parent = _frmNode.childUI["DLCMapInfoTankBtn_" .. i].handle._n,
                model = "misc/addition/tank_xuanche_tab_" .. selected_bg_list[i] .. ".png",
                x = 0,
                y = 0,
                z = -1,
                w = 92,
                h = i == 2 and 68 or 72
            })
            _frmNode.childUI["DLCMapInfoTankBtn_" .. i].childUI["selectbox"].handle._n:setVisible(false) -- 默认隐藏
        end

        -- 战车例会底图
        _frmNode.childUI["DLCMapInfoTankModelBG"] = hUI.image:new({
            parent = _parentNode,
            model = "misc/addition/stage_tray_01.png",
            -- TODO: 修改坐标
            x = DLCMAPINFO_OFFSET_X + 210 + 0 - 44,
            y = DLCMAPINFO_OFFSET_Y - 260 + 10 - 15,
            -- TODO: 调整大小
            scale = 1.5 - 0.4
        })
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankModelBG"

        -- 战车当前模型
        _frmNode.childUI["DLCMapInfoTankModel"] = hUI.button:new(
            { -- 作为按钮只是为了挂载子控件
                parent = _parentNode,
                model = "misc/mask.png",
                -- TODO: 修改坐标
                x = DLCMAPINFO_OFFSET_X + 210 - 10 + 5 - 44,
                y = DLCMAPINFO_OFFSET_Y - 260 - 20 + 50 - 15,
                w = 200,
                h = 200
            })
        _frmNode.childUI["DLCMapInfoTankModel"].handle.s:setOpacity(0)
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankModel"

        -- 闪避图标
        _frmNode.childUI["DLCMapInfoTankInfoDodgeImg"] = hUI.image:new({
            parent = _parentNode,
            model = "ICON:DODGE", -- "ICON:SKILL_SET04_04",
            x = DLCMAPINFO_OFFSET_X + 210 - 140 - 6,
            y = DLCMAPINFO_OFFSET_Y - 260 - 50 + 80,
            scale = 0.6 + 0.06
        })
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankInfoDodgeImg"

        -- 近战碎石图标
        _frmNode.childUI["DLCMapInfoTankInfoMeleeStoneImg"] = hUI.image:new({
            parent = _parentNode,
            model = "ICON:MELEE_STONE", -- "ICON:SKILL_SET04_04",
            x = DLCMAPINFO_OFFSET_X + 210 - 140 - 6,
            y = DLCMAPINFO_OFFSET_Y - 260 - 50 + 80,
            scale = 0.6 + 0.06
        })
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankInfoMeleeStoneImg"

        --[[
		--选择按钮
		_frmNode.childUI["DLCMapInfoSelectBtn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/addition/tank_anniu2.png",
			x = DLCMAPINFO_OFFSET_X + 280,
			y = DLCMAPINFO_OFFSET_Y - 390,
			label = {text = hVar.tab_string["__TEXT_SELECT"], size = 28, font = hVar.FONTC, border = 1, x = 0, y = 3, }, --"选择"
			w = 108,
			h = 64,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			code = function()
				--选择战车
				OnSelectTankIdx()
				
				--更新战车页面
				UpdateCurrentSelectedTankUI()
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoSelectBtn"
		]]

        -- 战车属性面板底图
        _frmNode.childUI["DLCMapInfoTankInfoBG"] = hUI.image:new({
            parent = _parentNode,
            model = "misc/addition/tank_xinxikuang.png",
            -- TODO: 修改坐标
            x = DLCMAPINFO_OFFSET_X + 526 - 320 - 44,
            y = DLCMAPINFO_OFFSET_Y - 210 + 60 + 20 - 13,
            w = 188,
            h = 46,
            -- TODO: 修改大小
            scale = 0.8
        })
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankInfoBG"

        -- 战车的等级
        _frmNode.childUI["DLCMapInfoTankInfoLv"] = hUI.label:new({
            parent = _parentNode,
            size = 26,
            -- TODO: 修改坐标
            x = DLCMAPINFO_OFFSET_X + 526 - 320 - 44,
            y = DLCMAPINFO_OFFSET_Y - 210 + 60 + 20 - 13,
            width = 300,
            align = "MC",
            font = "num",
            text = "",
            border = 0,
            -- TODO: 修改大小
            scale = 0.8
        })
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankInfoLv"

        -- 生命图标
        _frmNode.childUI["DLCMapInfoTankInfoHpImg"] = hUI.image:new({
            parent = _parentNode,
            model = "ICON:SKILL_SET04_01",
            -- TODO: 修改坐标
            x = DLCMAPINFO_OFFSET_X + 470 - 30 - 15 - 44,
            y = DLCMAPINFO_OFFSET_Y - 210 - 54 * 0 + 60 - 14,
            -- TODO: 修改大小
            scale = 0.6 * 1
        })
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankInfoHpImg"

        -- 生命前缀文字
        _frmNode.childUI["DLCMapInfoTankInfoHpPrefix"] = hUI.label:new({
            parent = _parentNode,
            size = 28,
            -- TODO: 修改坐标
            x = DLCMAPINFO_OFFSET_X + 470 - 15 - 44,
            y = DLCMAPINFO_OFFSET_Y - 210 - 54 * 0 + 60 - 14,
            width = 300,
            align = "LC",
            font = hVar.FONTC,
            text = hVar.tab_string["__ATTR__hp_max"], -- "生命",
            border = 1,
            -- TODO: 修改大小
            scale = 1
        })
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankInfoHpPrefix"

        -- 生命值
        _frmNode.childUI["DLCMapInfoTankInfoHp"] = hUI.label:new({
            parent = _parentNode,
            size = 26,
            -- TODO: 修改坐标
            x = DLCMAPINFO_OFFSET_X + 470 + 70 - 25 - 44,
            y = DLCMAPINFO_OFFSET_Y - 210 - 54 * 0 - 2 + 60 - 14,
            width = 300,
            align = "LC",
            font = "numWhite",
            text = "",
            border = 0,
            -- TODO: 修改大小
            scale = 1
        })
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankInfoHp"

        -- 攻击图标
        _frmNode.childUI["DLCMapInfoTankInfoAtkImg"] = hUI.image:new({
            parent = _parentNode,
            model = "ICON:SKILL_SET04_02",
            -- TODO: 修改坐标
            x = DLCMAPINFO_OFFSET_X + 470 - 30 - 15 - 44,
            y = DLCMAPINFO_OFFSET_Y - 210 - 54 * 1 + 55 - 14,
            -- TODO: 修改大小
            scale = 0.6 * 1
        })
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankInfoAtkImg"

        -- 攻击前缀文字
        _frmNode.childUI["DLCMapInfoTankInfoAtkPrefix"] = hUI.label:new({
            parent = _parentNode,
            size = 28,
            -- TODO: 修改坐标
            x = DLCMAPINFO_OFFSET_X + 470 - 15 - 44,
            y = DLCMAPINFO_OFFSET_Y - 210 - 54 * 1 + 55 - 14,
            width = 300,
            align = "LC",
            font = hVar.FONTC,
            text = hVar.tab_string["__Attr_Hint_skill_damage"], -- "攻击",
            border = 1,
            -- TODO: 修改大小
            scale = 1
        })
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankInfoAtkPrefix"

        -- 攻击值
        _frmNode.childUI["DLCMapInfoTankInfoAtk"] = hUI.label:new({
            parent = _parentNode,
            size = 26,
            -- TODO: 修改坐标
            x = DLCMAPINFO_OFFSET_X + 470 + 70 - 25 - 44,
            y = DLCMAPINFO_OFFSET_Y - 210 - 54 * 1 - 2 + 55 - 14,
            width = 300,
            align = "LC",
            font = "numWhite",
            text = "",
            border = 0,
            -- TODO: 修改大小
            scale = 1
        })
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankInfoAtk"

        -- 动力图标
        _frmNode.childUI["DLCMapInfoTankInfoMoveSpeedImg"] = hUI.image:new({
            parent = _parentNode,
            model = "ICON:SKILL_SET04_03",
            -- TODO: 修改坐标
            x = DLCMAPINFO_OFFSET_X + 470 - 30 - 15 - 44,
            y = DLCMAPINFO_OFFSET_Y - 210 - 54 * 2 + 50 - 14,
            -- TODO: 修改大小
            scale = 0.6 * 1
        })
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankInfoMoveSpeedImg"

        -- 动力前缀文字
        _frmNode.childUI["DLCMapInfoTankInfoMoveSpeedPrefix"] = hUI.label:new({
            parent = _parentNode,
            size = 28,
            -- TODO: 修改坐标
            x = DLCMAPINFO_OFFSET_X + 470 - 15 - 44,
            y = DLCMAPINFO_OFFSET_Y - 210 - 54 * 2 + 50 - 14,
            width = 300,
            align = "LC",
            font = hVar.FONTC,
            text = hVar.tab_string["__Attr_Hint_move_speed"], -- "动力",
            border = 1,
            -- TODO: 修改大小
            scale = 1
        })
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankInfoMoveSpeedPrefix"

        -- 动力值
        _frmNode.childUI["DLCMapInfoTankInfoMoveSpeed"] = hUI.label:new({
            parent = _parentNode,
            size = 26,
            -- TODO: 修改坐标
            x = DLCMAPINFO_OFFSET_X + 470 + 70 - 25 - 44,
            y = DLCMAPINFO_OFFSET_Y - 210 - 54 * 2 - 2 + 50 - 14,
            width = 300,
            align = "LC",
            font = "numWhite",
            text = "",
            border = 0,
            -- TODO: 修改大小
            scale = 1
        })
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankInfoMoveSpeed"

        --[[
		--皮肤底图
		_frmNode.childUI["DLCMapInfoTankSkinBG"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/addition/tank_pifukuang01.png",
			x = DLCMAPINFO_OFFSET_X + 360,
			y = DLCMAPINFO_OFFSET_Y - 560,
			w = 518,
			h = 194,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankInfoBG"
		]]

        local _scale = 1.25
        -- 绘制第一页的皮肤
        for i = 1, DLCMAPINFO_X_NUM, 1 do
            -- 父控件
            _frmNode.childUI["DLCMapInfoTankSkinBtn_" .. i] = hUI.button:new({
                parent = _parentNode,
                model = "misc/mask.png",
                -- TODO: 修改坐标
                x = DLCMAPINFO_OFFSET_X + 170 + (i - 1) * 190 + (i - 1) * 24 - 40 - 4,
                y = DLCMAPINFO_OFFSET_Y - 470 + 20 - 24,
                -- TODO: 调整大小
                w = 158 * _scale,
                h = 193 * _scale,
                dragbox = _frm.childUI["dragBox"],
                scaleT = 0.95,
                code = function()
                    print("选择皮肤 :" .. tostring(i))
                    OnSelectTankAvterIndx(i)
                end
            })
            _frmNode.childUI["DLCMapInfoTankSkinBtn_" .. i].handle.s:setOpacity(111) -- 只相应事件，不显示
            leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankSkinBtn_" .. i

            -- 战车皮肤
            _frmNode.childUI["DLCMapInfoTankSkinBtn_" .. i].childUI["skin"] = hUI.image:new({
                parent = _frmNode.childUI["DLCMapInfoTankSkinBtn_" .. i].handle._n,
                model = "icon/skin/skin_000.png",
                -- TODO: 修改坐标
                x = -0,
                y = 0,
                -- TODO: 调整大小
                w = 158 * _scale,
                h = 193 * _scale
            })
            _frmNode.childUI["DLCMapInfoTankSkinBtn_" .. i].childUI["skin"].handle._n:setVisible(false) -- 默认隐藏

            _frmNode.childUI["DLCMapInfoTankSkinBtn_" .. i].childUI["lock"] = hUI.image:new({
                parent = _frmNode.childUI["DLCMapInfoTankSkinBtn_" .. i].handle._n,
                model = "misc/task/stage_lock.png",
                y = -84
            })
            _frmNode.childUI["DLCMapInfoTankSkinBtn_" .. i].childUI["lock"].handle._n:setVisible(false) -- 默认隐藏

            -- 战车皮肤边框
            _frmNode.childUI["DLCMapInfoTankSkinBtn_" .. i].childUI["skin_border"] = hUI.image:new({
                parent = _frmNode.childUI["DLCMapInfoTankSkinBtn_" .. i].handle._n,
                model = "misc/addition/tank_pifu02.png",
                -- TODO: 调整大小
                w = 160 * _scale,
                h = 196 * _scale,
                z = 1
            })

            -- 战车皮肤外框
            _frmNode.childUI["DLCMapInfoTankSkinBtn_" .. i].childUI["skin_border_outside"] = hUI.image:new({
                parent = _frmNode.childUI["DLCMapInfoTankSkinBtn_" .. i].handle._n,
                model = "misc/addition/tank_pifu_kuang.png",
                y = -8,
                -- TODO: 调整大小
                w = 170 * _scale,
                h = 218 * _scale,
                z = 1
            })
            -- _frmNode.childUI["DLCMapInfoTankSkinBtn_" .. i].childUI["skin_border"].handle._n:setVisible(false) --默认隐藏

            -- 选中框
            _frmNode.childUI["DLCMapInfoTankSkinBtn_" .. i].childUI["selectbox"] = hUI.image:new({
                parent = _frmNode.childUI["DLCMapInfoTankSkinBtn_" .. i].handle._n,
                model = "misc/addition/tank_pifu03.png",
                x = 0,
                y = 0,
                z = 2,
                -- TODO: 调整大小
                w = 160 * _scale,
                h = 196 * _scale
            })
            _frmNode.childUI["DLCMapInfoTankSkinBtn_" .. i].childUI["selectbox"].handle._n:setVisible(false) -- 默认隐藏

            local __scale = 1.15
            -- 选择的按钮
            _frmNode.childUI["DLCMapInfoTankSkinSelectBtn_" .. i] = hUI.button:new({
                parent = _parentNode,
                model = "misc/addition/tank_anniu2.png",
                x = DLCMAPINFO_OFFSET_X + 170 + (i) * 215 - 312,
                y = DLCMAPINFO_OFFSET_Y - 494 - 114 - 20 - 24,
                label = {
                    text = hVar.tab_string["__TEXT_BATTLE"],
                    size = 26,
                    font = hVar.FONTC,
                    border = 1,
                    x = 0,
                    y = 1
                }, -- "出战"
                w = 86 * __scale,
                h = 52 * __scale,
                dragbox = _frm.childUI["dragBox"],
                scaleT = 0.95,
                code = function()
                    -- 选择战车
                    OnSelectTankIdx(i)

                    -- 更新战车页面
                    UpdateCurrentSelectedTankUI()
                end
            })
            _frmNode.childUI["DLCMapInfoTankSkinSelectBtn_" .. i]:setstate(-1) -- 默认隐藏
            leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankSkinSelectBtn_" .. i

            -- 分享的按钮
            _frmNode.childUI["DLCMapInfoTankSkinShareBtn_" .. i] = hUI.button:new({
                parent = _parentNode,
                model = "misc/addition/tank_anniu2.png",
                x = DLCMAPINFO_OFFSET_X + 170 + (i) * 214 - 205,
                y = DLCMAPINFO_OFFSET_Y - 494 - 114 - 20 - 24,
                label = {
                    text = "分享",
                    size = 26,
                    font = hVar.FONTC,
                    border = 1,
                    x = 0,
                    y = 1
                },
                w = 86 * __scale,
                h = 52 * __scale,
                dragbox = _frm.childUI["dragBox"],
                scaleT = 0.95,
                code = function()
                    -- 分享战车
                    print("分享皮肤 : 战车索引:" .. tostring(i))
                    OnClickSkinShareBtn(i)
                end
            })
            _frmNode.childUI["DLCMapInfoTankSkinShareBtn_" .. i]:setstate(-1) -- 默认隐藏
            leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankSkinShareBtn_" .. i

            _frmNode.childUI["DLCMapInfoTankSkinConditionNode_" .. i] = hUI.button:new({
                parent = _parentNode,
                model = "misc/button_null.png",
                -- TODO: 修改坐标
                x = DLCMAPINFO_OFFSET_X + 170 + (i - 1) * 214 + 30 - 74,
                y = DLCMAPINFO_OFFSET_Y - 494 - 110 - 30 - 20,
                w = 400,
                h = 52,
                dragbox = _frm.childUI["dragBox"],
                scaleT = 0.95,
				code = function()
					local callback = TankSkinConditionBtnCallbackList[i]
					if type(callback) == "function" then
						callback()
					end
				end
            })
            _frmNode.childUI["DLCMapInfoTankSkinConditionNode_" .. i]:setstate(-1) -- 默认隐藏
            leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankSkinConditionNode_" .. i

            -- 已选择的图片
            _frmNode.childUI["DLCMapInfoTankSkinSelectImg_" .. i] = hUI.image:new({
                parent = _parentNode,
                model = "misc/addition/tank_gou01.png",
                -- TODO: 修改坐标
                x = DLCMAPINFO_OFFSET_X + 170 + (i - 1) * 214 + 52 - 30,
                y = DLCMAPINFO_OFFSET_Y - 470 - 70 - 26,
                -- TODO: 调整大小
                w = 38 * 1.3,
                h = 32 * 1.3
            })
            -- _frmNode.childUI["DLCMapInfoTankSkinSelectImg_" .. i].handle._n:setRotation(15)
            _frmNode.childUI["DLCMapInfoTankSkinSelectImg_" .. i].handle._n:setVisible(false) -- 默认隐藏
            leftRemoveFrmList[#leftRemoveFrmList + 1] = "DLCMapInfoTankSkinSelectImg_" .. i
        end

        -- 更新当前选中的战车界面
        UpdateCurrentSelectedTankUI()

        -- 添加事件监听：商城信息返回
        -- hGlobal.event:listen("localEvent_refresh_shopinfo", "__OnReceiveShopItemRet", on_receive_shop_iteminfo_back_event)
        -- 添加事件监听：横竖屏切换
        hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenRandomMap_", on_spine_screen_event)
        -- 添加事件监听：战车改名结果回调
        hGlobal.event:listen("localEvent_modify_tank_username", "_ChangeNameTankAvater_", on_changename_result_event)

        -- 只有在本分页才会有的timer
        -- hApi.addTimerForever("__SHOP_TIMER_PAGE_BUYITEM__", hVar.TIMER_MODE.GAMETIME, 1000, on_refresh_shop_buyitem_lefttime_timer)
    end
	
	-- 初始化条件按钮列表
	TankSkinConditionBtnCallbackList = {}

    local _CODE_CreateUnlockCondition = function(btnNode, avaterId, btnIndex)
        if btnNode == nil then
            return
        end
        TankSkinConditionBtnCallbackList[btnIndex] = nil
        hApi.safeRemoveT(btnNode.childUI, "node")
        btnNode.childUI["node"] = hUI.button:new({
            parent = btnNode.handle._n,
            model = "misc/button_null.png",
            w = 1,
            h = 1,
        })
        local node = btnNode.childUI["node"]
        local nodeChild = node.childUI
        local nodeParent = node.handle._n
        local tabA = hVar.tab_avater[avaterId]
        if tabA then
            local model = tabA.model
            local tCondition = hVar.UseAvaterCondition[avaterId]
            if tCondition and model ~= "" then
                if tCondition.mapstar then
                    local totalStar = LuaGetPlayerStarCountVal()
                    if tCondition.mapstar > totalStar then
                        nodeChild["img_star"] = hUI.image:new({
                            parent = nodeParent,
                            model = "misc/addition/star_light2.png",
                            align = "MC",
                            w = 32,
                            h = 32
                        })
                        nodeChild["lab_star"] = hUI.label:new({
                            parent = nodeParent,
                            font = "numRed",
                            text = tCondition.mapstar,
                            size = 24,
                            align = "MC",
                        })
                        local w = nodeChild["lab_star"]:getWH()
                        local totalW = w + 32 + 8
                        local offw = -35
                        nodeChild["img_star"]:setXY(offw + (32 - totalW) / 2 + 40, 0)
                        nodeChild["lab_star"]:setXY(offw + (totalW - w) / 2 + 40, -2)
                    end
                elseif tCondition.vip then
                    local vip = LuaGetPlayerVipLv()
                    if tCondition.vip > vip then
                        local showInfo = tCondition.showIconStr
                        if type(showInfo) == "table" then
                            local ImgInfo = showInfo[1] or {}
                            local imgSrc = ImgInfo[1]
                            local imgScale = ImgInfo[2]
                            local imgoffx = ImgInfo[3] or 0
                            local imgoffy = ImgInfo[4] or 0
                            local str = showInfo[2] or ""
                            nodeChild["img_icon"] = hUI.image:new({
                                parent = nodeParent,
                                model = imgSrc,
                                align = "MC",
                                scale = imgScale
                            })
                            local imgw = nodeChild["img_icon"].data.w

                            nodeChild["lab_str"] = hUI.label:new({
                                parent = nodeParent,
                                font = hVar.FONTC,
                                border = 1,
                                text = hVar.tab_string[str],
                                size = 24,
                                align = "MC",
                                RGB = {
                                    240,
                                    50,
                                    0
                                }
                            })
                            local strw = nodeChild["lab_str"]:getWH()
                            -- print(str,hVar.tab_string[str],strw,btnNode.data.x)
                            local totalW = imgw + 8 + strw
                            local offw = 3 + (700 / 2 - btnNode.data.x) - 30
                            nodeChild["img_icon"]:setXY(offw + (imgw - totalW) / 2 + imgoffx, imgoffy)
                            nodeChild["lab_str"]:setXY(offw + (totalW - strw) / 2, 0)

                            TankSkinConditionBtnCallbackList[btnIndex] = function()
                                --显示VIPTip窗口
                                hApi.ShowGeneralVIPTip(tCondition.vip)
                            end
                        end
                    end
                end
            end
        end
    end

    local _CODE_CheckCanUseTankSkin = function(avaterId)
        local bFlag = true

        local tabA = hVar.tab_avater[avaterId]
        if tabA then
            local model = tabA.model
            local tCondition = hVar.UseAvaterCondition[avaterId]
            if tCondition and model ~= "" then
                if tCondition.mapstar then
                    local totalStar = LuaGetPlayerStarCountVal()
                    if tCondition.mapstar > totalStar then
                        bFlag = false
                    end
                elseif tCondition.vip then
                    local vip = LuaGetPlayerVipLv()
                    if tCondition.vip > vip then
                        bFlag = false
                    end
                end
            end
        end

        return bFlag
    end

    -- 函数：更新当前选中的战车界面
    UpdateCurrentSelectedTankUI = function()
        local _frm = hGlobal.UI.PhoneTankAvaterInfoFrm
        local _frmNode = _frm.childUI["PageNode"]
        local _parentNode = _frmNode.handle._n

        -- 高亮当前选中的战车索引
        local tank_unit = hVar.tab_unit[hVar.MY_TANK_ID].tank_unit
        for i = 1, #tank_unit, 1 do
            local tankId = tank_unit[i]

            -- 更新左侧选中框
            local ctrlI = _frmNode.childUI["DLCMapInfoTankBtn_" .. i]
            if ctrlI then
                if (current_selectedIdx == i) then
                    ctrlI.childUI["selectbox"].handle._n:setVisible(true)
                else
                    ctrlI.childUI["selectbox"].handle._n:setVisible(false)
                end
            end
        end

        --[[
		--更新选择战车按钮状态
		local tankIdx = LuaGetHeroTankIdx()
		if (tankIdx == current_selectedIdx) then
			_frmNode.childUI["DLCMapInfoSelectBtn"]:setstate(-1)
		else
			_frmNode.childUI["DLCMapInfoSelectBtn"]:setstate(1)
		end
		]]

        -- 更新全部皮肤
        local tankId = tank_unit[current_selectedIdx]
        local tabU = hVar.tab_unit[tankId]
        local avater = tabU.avater
        local avterIdx = current_selectedAvaterIdx
        if (avterIdx == 0) then
            avterIdx = LuaGetHeroAvaterIdx(tankId) or 1
        end
        -- print("current_selectedAvaterIdx=", current_selectedAvaterIdx)
        OnSelectTankAvterIndx(avterIdx)

        local totalStar = LuaGetPlayerStarCountVal()
        for s = 1, #avater, 1 do
            local avaterId = avater[s]
            local ctrlN = _frmNode.childUI["DLCMapInfoTankSkinConditionNode_" .. s]
            local ctrlskin = _frmNode.childUI["DLCMapInfoTankSkinBtn_" .. s]

            _CODE_CreateUnlockCondition(ctrlN, avaterId, s)

            if ctrlskin then
                if ctrlskin.childUI["skin"] then
                    hApi.AddShader(ctrlskin.childUI["skin"].handle.s, "normal")
                end
                if ctrlskin.childUI["lock"] then
                    ctrlskin.childUI["lock"].handle._n:setVisible(false)
                end
            end
            if _CODE_CheckCanUseTankSkin(avaterId) == false then
                if ctrlskin then
                    if ctrlskin.childUI["skin"] then
                        hApi.AddShader(ctrlskin.childUI["skin"].handle.s, "gray")
                    end
                    if ctrlskin.childUI["lock"] then
                        ctrlskin.childUI["lock"].handle._n:setVisible(true)
                    end
                end
            end
        end

        -- 更新战车属性
        local level = 1
        local tHeroCard = hApi.GetHeroCardById(tankId)
        -- print("tankId=", tankId, tHeroCard)
        if tHeroCard then
            level = tHeroCard.attr.level
        end
        local attr = tabU.attr
        local hp = attr.hp
        local atk = attr.attack[5]
        local move_speed = attr.move_speed
        local melee_stone = attr.melee_stone or 0 -- 近战碎石
        local dodge_rate = attr.dodge_rate or 0 -- 闪避几率
        _frmNode.childUI["DLCMapInfoTankInfoLv"]:setText(level)
        _frmNode.childUI["DLCMapInfoTankInfoHp"]:setText(hp)
        _frmNode.childUI["DLCMapInfoTankInfoAtk"]:setText(atk)
        _frmNode.childUI["DLCMapInfoTankInfoMoveSpeed"]:setText(move_speed)
        if (melee_stone > 0) then
            _frmNode.childUI["DLCMapInfoTankInfoMeleeStoneImg"].handle._n:setVisible(true)
        else
            _frmNode.childUI["DLCMapInfoTankInfoMeleeStoneImg"].handle._n:setVisible(false)
        end

        if (dodge_rate > 0) then
            _frmNode.childUI["DLCMapInfoTankInfoDodgeImg"].handle._n:setVisible(true)
        else
            _frmNode.childUI["DLCMapInfoTankInfoDodgeImg"].handle._n:setVisible(false)
        end
    end

    -- 函数：选择指定战车索引
    OnSelectTankIdx = function(avaterIdx)
        local _frm = hGlobal.UI.PhoneTankAvaterInfoFrm
        local _frmNode = _frm.childUI["PageNode"]
        local _parentNode = _frmNode.handle._n

        local tank_unit = hVar.tab_unit[hVar.MY_TANK_ID].tank_unit
        local tankId = tank_unit[current_selectedIdx]
        local tankIdx = current_selectedIdx
        OnSelectTankAvterIndx(avaterIdx)
        LuaSetHeroTankIdx(tankIdx)
        LuaSetHeroAvaterIdx(tankId, avaterIdx)

        local oWorld = hGlobal.WORLD.LastWorldMap
        local oPlayerMe = oWorld:GetPlayerMe() -- 我的玩家对象
        local oHero = oPlayerMe.heros[1]
        -- print(oHero)
        if oHero then
            local oUnit = oHero:getunit()
            -- print(oUnit)
            if oUnit then
                if (oUnit.data.id ~= tankId) then -- 不重复替换
                    local tabU = hVar.tab_unit[tankId]
                    local model = tabU.model
                    local scale = tabU.scale
                    local bind_wheel = tabU.bind_wheel

                    -- 读取皮肤索引
                    local avaterIdx = LuaGetHeroAvaterIdx(tankId)
                    local avaterId = tabU.avater[avaterIdx] or 0
                    model = hVar.tab_avater[avaterId].model
                    bind_wheel = hVar.tab_avater[avaterId].bind_wheel
                    scale = hVar.tab_avater[avaterId].scale

                    oUnit.handle.__UnitModelName = model
                    oUnit.data.scale = scale * 100
                    oUnit:initmodel()

                    -- 替换轮子
                    if (oUnit.data.bind_wheel ~= 0) then
                        oUnit.data.bind_wheel:del()
                        oUnit.data.bind_wheel = 0
                    end

                    -- 也替换静态表的数据
                    local currentUnitId = oUnit.data.id
                    local tabUCurrent = hVar.tab_unit[currentUnitId]
                    tabUCurrent.model = model
                    tabUCurrent.scale = scale
                    tabUCurrent.bind_wheel = bind_wheel

                    -- 属性重算
                    oUnit:__AttrRecheckBasic(tabU.attr)

                    -- tank: 是否有绑定的单位（坦克轮子）
                    local worldX, worldY = hApi.chaGetPos(oUnit.handle) -- 目标的位置
                    if bind_wheel and (bind_wheel ~= 0) then
                        -- local worldX, worldY = hApi.chaGetPos(oUnit.handle) --目标的位置
                        local gridX, gridY = oWorld:xy2grid(worldX, worldY)
                        local lv = oUnit
                        local owner = oUnit:getowner():getpos()
                        local facing = oUnit.data.facing
                        local lv = oUnit.attr.lv
                        local star = oUnit.attr.star
                        local bind_wheel2 = oWorld:addunit(bind_wheel, owner, gridX, gridY, facing, worldX, worldY, nil,
                            nil, lv, star)
                        oUnit.data.bind_wheel = bind_wheel2
                        bind_wheel2.data.bind_wheel_owner = oUnit
                    end

                    -- 也替换静态表的数据
                    tabUCurrent.attr.hp = tabU.attr.hp
                    tabUCurrent.attr.hp_restore = tabU.attr.hp_restore
                    tabUCurrent.attr.move_speed = tabU.attr.move_speed
                    tabUCurrent.attr.atk_radius = tabU.attr.atk_radius
                    tabUCurrent.attr.atk_defend_radius = tabU.attr.atk_defend_radius
                    tabUCurrent.attr.atk_interval = tabU.attr.atk_interval
                    tabUCurrent.attr.def_physic = tabU.attr.def_physic
                    tabUCurrent.attr.def_magic = tabU.attr.def_magic
                    tabUCurrent.attr.def_ice = tabU.attr.def_ice
                    tabUCurrent.attr.def_thunder = tabU.attr.def_thunder
                    tabUCurrent.attr.def_fire = tabU.attr.def_fire
                    tabUCurrent.attr.def_poison = tabU.attr.def_poison
                    tabUCurrent.attr.def_bullet = tabU.attr.def_bullet
                    tabUCurrent.attr.def_bomb = tabU.attr.def_bomb
                    tabUCurrent.attr.def_chuanci = tabU.attr.def_chuanci
                    tabUCurrent.attr.dodge_rate = tabU.attr.dodge_rate -- 基础闪避几率（去百分号后的值）
                    tabUCurrent.attr.inertia = tabU.attr.inertia
                    tabUCurrent.attr.rebirth_time = tabU.attr.rebirth_time
                    tabUCurrent.attr.melee_stone = tabU.attr.melee_stone

                    -- 基地的红绿灯显示
                    local baseunitId = 0
                    if (tankId == 6109) then
                        baseunitId = 5068
                    elseif (tankId == 6107) then
                        baseunitId = 5128
                    elseif (tankId == 6108) then
                        baseunitId = 5130
                    end
                    local base_oUunit = nil
                    -- print("baseunitId=", baseunitId)
                    oWorld:enumunitArea(0, worldX, worldY, 500, function(eu)
                        -- print("eu.data.id=", eu.data.id)
                        if (eu.data.id == baseunitId) then
                            base_oUunit = eu
                        end
                    end)
                    if base_oUunit then
                        -- base_oUunit:sethide(1)
                    end

                    -- 基地的绿灯
                    local baseunitId_green = 5069
                    local base_oUunit_green = nil
                    -- print("baseunitId_green=", baseunitId_green)
                    oWorld:enumunitArea(0, worldX, worldY, 2000, function(eu)
                        -- print("eu.data.id=", eu.data.id)
                        if (eu.data.id == baseunitId_green) then
                            base_oUunit_green = eu
                        end
                    end)
                    if base_oUunit_green then
                        local basex, basey = hApi.chaGetPos(base_oUunit.handle) -- 目标的位置
                        hApi.chaSetPos(base_oUunit_green.handle, basex, basey)
                    end

                    -- 基地当前出战的战车隐藏
                    oWorld:enumunitArea(0, worldX, worldY, 2000, function(eu)
                        -- print("eu.data.id=", eu.data.id)
                        if (eu.data.id == 6109) or (eu.data.id == 6107) or (eu.data.id == 6108) then
                            if (eu.data.id == tankId) then
                                eu:sethide(1)
                                if (eu.data.bind_weapon ~= 0) then
                                    eu.data.bind_weapon:sethide(1)
                                end
                                if (eu.data.bind_wheel ~= 0) then
                                    eu.data.bind_wheel:sethide(1)
                                end
                            else
                                eu:sethide(0)
                                if (eu.data.bind_weapon ~= 0) then
                                    eu.data.bind_weapon:sethide(0)
                                end
                                if (eu.data.bind_wheel ~= 0) then
                                    eu.data.bind_wheel:sethide(0)
                                end
                            end
                        end
                    end)
                end
            end
        end
    end

    -- 函数：选择指定战车皮肤索引
    OnSelectTankAvterIndx = function(aIdx)
        local _frm = hGlobal.UI.PhoneTankAvaterInfoFrm
        local _frmNode = _frm.childUI["PageNode"]
        local _parentNode = _frmNode.handle._n

        local tank_unit = hVar.tab_unit[hVar.MY_TANK_ID].tank_unit
        local tankId = tank_unit[current_selectedIdx]
        local tankIdx = current_selectedIdx
        local tabU = hVar.tab_unit[tankId]
        -- print("tankId:" .. tostring(tankId))
        local avater = tabU.avater
        local avterIdx = LuaGetHeroAvaterIdx(tankId)
        local cTidx = LuaGetHeroTankIdx()

        if (aIdx <= #avater) then
            -- 皮肤id
            local avaterId = avater[aIdx] or 0
            -- print("avaterId: " .. tostring(avaterId))
            local model = hVar.tab_avater[avaterId].model
            local bind_wheel = hVar.tab_avater[avaterId].bind_wheel
            local scale = hVar.tab_avater[avaterId].scale

            if (model ~= "") then
                -- LuaSetHeroAvaterIdx(tankId, aIdx)

                -- 标记选中
                current_selectedAvaterIdx = aIdx

                -- 更新选中的皮肤
                for s = 1, #avater, 1 do
                    local avaterId = avater[s]
                    -- print("avaterId=", avaterId)
                    local icon = hVar.tab_avater[avaterId].icon
                    -- 内发光边框
                    local ctrli = _frmNode.childUI["DLCMapInfoTankSkinBtn_" .. s]
                    if ctrli then
                        ctrli.childUI["skin"].handle._n:setVisible(true)
                        ctrli.childUI["skin"]:setmodel(icon)

                        if (aIdx == s) then
                            -- ctrli.childUI["skin_border"].handle._n:setVisible(true)
                            ctrli.childUI["selectbox"].handle._n:setVisible(true)
                        else
                            -- ctrli.childUI["skin_border"].handle._n:setVisible(false)
                            ctrli.childUI["selectbox"].handle._n:setVisible(false)
                        end
                    end
                end

                -- 更新选择按钮
                for s = 1, #avater, 1 do
                    local avaterId = avater[s]
                    local model = hVar.tab_avater[avaterId].model
                    -- 出战
                    local ctrli = _frmNode.childUI["DLCMapInfoTankSkinSelectBtn_" .. s]
                    -- 分享
                    local ctrlShare = _frmNode.childUI["DLCMapInfoTankSkinShareBtn_" .. s]
                    -- 对勾
                    local ctrls = _frmNode.childUI["DLCMapInfoTankSkinSelectImg_" .. s]
                    -- 解锁条件
                    local ctrlN = _frmNode.childUI["DLCMapInfoTankSkinConditionNode_" .. s]

                    if ctrlN then
                        ctrlN:setstate(-1)
                    end

                    if ctrli then
                        -- print("cTidx="..cTidx, "current_selectedIdx="..current_selectedIdx)
                        -- print("avterIdx:" .. tostring(avterIdx))
                        -- print("aIdx:" .. tostring(aIdx))
                        if (cTidx == current_selectedIdx) and (avterIdx == s) then -- 查看此皮肤，并且已选择此皮肤
                            ctrli:setstate(-1)
                            ctrlShare:setstate(aIdx == s and 1 or -1)
                            ctrlShare:setXY(DLCMAPINFO_OFFSET_X + 170 + (aIdx) * 230 - 205 - 68, ctrlShare.data.y)
                            ctrls.handle._n:setVisible(true)
                        elseif (model == "") then -- 无效的皮肤
                            ctrli:setstate(-1)
                            ctrlShare:setstate(-1)
                            ctrls.handle._n:setVisible(false)
                        elseif (aIdx == s) then -- 查看此皮肤
                            -- 总星星
                            if _CODE_CheckCanUseTankSkin(avaterId) == false then
                                ctrli:setstate(-1)
                                ctrlShare:setstate(-1)
                                ctrlN:setstate(1)
                            else
                                ctrli:setstate(1)
                                ctrlShare:setstate(1)
                                ctrlShare:setXY(DLCMAPINFO_OFFSET_X + 170 + (aIdx) * 230 - 205, ctrlShare.data.y)
                            end
                            ctrls.handle._n:setVisible(false)
                        else
                            ctrli:setstate(-1)
                            ctrlShare:setstate(-1)
                            ctrls.handle._n:setVisible(false)
                        end
                    end
                end
                for s = #avater + 1, DLCMAPINFO_X_NUM, 1 do
                    local ctrli = _frmNode.childUI["DLCMapInfoTankSkinSelectBtn_" .. s]
                    local ctrlShare = _frmNode.childUI["DLCMapInfoTankSkinShareBtn_" .. s]
                    local ctrls = _frmNode.childUI["DLCMapInfoTankSkinSelectImg_" .. s]
                    if ctrli then
                        ctrli:setstate(-1)
                        ctrlShare:setstate(-1)
                        ctrls.handle._n:setVisible(false)
                    end
                end

                -- 更新例会
                hApi.safeRemoveT(_frmNode.childUI["DLCMapInfoTankModel"].childUI, "tank")
                hApi.safeRemoveT(_frmNode.childUI["DLCMapInfoTankModel"].childUI, "wheel")
                hApi.safeRemoveT(_frmNode.childUI["DLCMapInfoTankModel"].childUI, "weapon")
                -- 战车当前模型
                _frmNode.childUI["DLCMapInfoTankModel"].childUI["tank"] = hUI.thumbImage:new({
                    parent = _frmNode.childUI["DLCMapInfoTankModel"].handle._n,
                    -- id = tankId,
                    x = 0,
                    y = 0,
                    model = model,
                    facing = 0,
                    w = 200,
                    h = 200,
                    -- TODO: 调整大小
                    scale = 2.1 * scale * 0.8
                })
                -- 战车轮子
                if bind_wheel and (bind_wheel ~= 0) then
                    _frmNode.childUI["DLCMapInfoTankModel"].childUI["wheel"] = hUI.thumbImage:new({
                        parent = _frmNode.childUI["DLCMapInfoTankModel"].handle._n,
                        id = bind_wheel,
                        x = 0,
                        y = 0,
                        -- model = tabUW.model,
                        facing = 0,
                        w = 200,
                        h = 200,
                        -- TODO: 调整大小
                        scale = 1.5 * 0.8
                    })
                end
                -- 战车武器
                local weaponIdx = LuaGetHeroWeaponIdx(hVar.MY_TANK_ID) -- 当前选中的武器索引值
                local weaponUnitId = hVar.tab_unit[hVar.MY_TANK_ID].weapon_unit[weaponIdx].unitId
                local weaponUnitModel = hVar.tab_unit[weaponUnitId].model
                -- print("weaponUnitId=", weaponUnitId, "weaponUnitModel=", weaponUnitModel)
                if (weaponUnitModel ~= nil) and (weaponUnitModel ~= "") then
                    -- 战车当前模型
                    _frmNode.childUI["DLCMapInfoTankModel"].childUI["weapon"] = hUI.thumbImage:new({
                        parent = _frmNode.childUI["DLCMapInfoTankModel"].handle._n,
                        id = weaponUnitId,
                        x = 0,
                        y = 0,
                        -- model = model,
                        facing = 0,
                        -- w = 200,
                        -- h = 200,
                        -- TODO: 调整大小
                        scale = 1.5 * 0.8
                    })
                else
                    -- 战车当前模型（特效）
                    local tEffect = hVar.tab_unit[weaponUnitId].effect[1]
                    local effectId = tEffect[1]
                    local effectScale = hVar.tab_effect[effectId].scale
                    -- print("effectId=", effectId)
                    _frmNode.childUI["DLCMapInfoTankModel"].childUI["weapon"] = hUI.image:new({
                        parent = _frmNode.childUI["DLCMapInfoTankModel"].handle._n,
                        model = hVar.tab_effect[effectId].model,
                        x = tEffect[2],
                        -- TODO: 修改坐标
                        y = tEffect[3] + 50,
                        -- model = model,
                        facing = 0,
                        -- w = 200,
                        -- h = 200,
                        -- TODO: 调整大小
                        scale = 1.5 * effectScale * tEffect[4] * 0.8
                    })
                end

                -- if (cTidx == current_selectedIdx) then
                --	OnSelectTankIdx()
                -- end
            end
        end
    end

    -- 点击皮肤分享按钮
    OnClickSkinShareBtn = function(aIdx)
        local tank_unit = hVar.tab_unit[hVar.MY_TANK_ID].tank_unit
        if tonumber(current_selectedIdx) then
            local tankId = tank_unit[current_selectedIdx]
            if tonumber(tankId) then
                local tabU = hVar.tab_unit[tankId]
                local avater = tabU.avater
                if (aIdx <= #avater) then
                    local avaterId = avater[aIdx] or 0
                    print("avaterId: " .. tostring(avaterId))
                    if avaterId > 0 then
                        local share_img = hVar.tab_avater[avaterId].share_img
                        if share_img and #share_img > 0 then
                            hGlobal.event:event("LocalEvent_ShowShareWindow", share_img)
                        else
                            print("share_img字段为空")
                        end
                    else
                        print("avaterId为空")
                    end
                end
            else
                print("tankId值无效：" .. tostring(tankId))
            end
        else
            print("current_selectedIdx值无效：" .. tostring(current_selectedIdx))
        end
    end

    -- 函数：战车改名回调事件
    on_changename_result_event = function(result, info, name, gamecoin)
        local _frm = hGlobal.UI.PhoneTankAvaterInfoFrm
        local _frmNode = _frm.childUI["PageNode"]
        local _parentNode = _frmNode.handle._n

        -- print("战车改名回调事件", result, info, name, gamecoin)

        -- 取消挡操作
        hUI.NetDisable(0)

        -- 更名结果（1成功 0失败）
        -- 更名信息 (成功:prizeid 失败:失败原因 -1钱不够 -2重名 -3未知)
        if (result == 1) then
            -- 修改名字文本
            _frmNode.childUI["DLCMapInfoRoleName"]:setText(name)
        end
    end

    -- 函数：横竖屏切换
    on_spine_screen_event = function()
        local _frm = hGlobal.UI.PhoneTankAvaterInfoFrm
        local _frmNode = _frm.childUI["PageNode"]
        local _parentNode = _frmNode.handle._n

        -- 关闭本界面
        OnClosePanel()

        -- 重绘本界面
        hGlobal.UI.InitTankAvaterInfoFrm("reload") -- 测试
        -- 触发事件，显示随机迷宫界面
        hGlobal.event:event("LocalEvent_TankAvaterFrm", current_funcCallback)
    end

    -- 函数：月卡信息回调
    -- @param isValid number 月卡是否有效：1有效|0无效
    -- @param daysLeft number 月卡剩余有效天数
    -- @param freeCount number 月卡今日已使用强化免费次数
    On_Receive_LocalEvent_MonthCardGiftList = function(isValid, daysLeft, freeCount)
        -- print("On_Receive_LocalEvent_MonthCardGiftList:", isValid, daysLeft, freeCount)
        local _frm = hGlobal.UI.PhoneTankAvaterInfoFrm
        local _frmNode = _frm.childUI["PageNode"]
        local _parentNode = _frmNode.handle._n

        local btn = _frm.childUI["btn_month_card"]
        local label = _frm.childUI["btn_month_card"].childUI["label_month_card_lefttime"]

		if isValid == 0 then
			-- print("月卡无效")
			-- 按钮变灰
			hApi.AddShader(btn.handle.s, "gray")
			label.handle._n:setVisible(false)
			return
		end

		-- 按钮变亮
		hApi.AddShader(btn.handle.s, "normal")
		label.handle._n:setVisible(true)
        local text = string.format("[" .. hVar.tab_string["__TEXT_FORMAT_TimeLeft_Days"] .. "]", daysLeft)
		label:setText(text, 1)
    end

	-- 函数：月卡购买结果回调
	-- @param nResult number 是否成功：1成功|0失败
	On_Receive_LocalEvent_Purchase_Back = function(nResult)
		if nResult == 1 then
			--弹框
			--"充值成功！"
			hGlobal.UI.MsgBox(hVar.tab_string["recharge_success_short"],{
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			--再次发起查询月卡和月卡每日领奖
			SendCmdFunc["query_month_card"]()
		end
	end

    -- 监听月卡查询信息事件
    hGlobal.event:listen("localEvent_MonthCardGiftList", "_UpdateMonthCard_TankAvaterFrm",
        On_Receive_LocalEvent_MonthCardGiftList)

	-- 监听月卡购买结果事件
	hGlobal.event:listen("LocalEvent_Purchase_Back", "_PurchaseBack_TankAvaterFrm", On_Receive_LocalEvent_Purchase_Back)
end

-- 监听打开坦克皮肤界面通知事件
hGlobal.event:listen("LocalEvent_TankAvaterFrm", "__ShowTankAvaterFrm", function(selectedIdx, callback, bOpenImmediate)
    hGlobal.UI.InitTankAvaterInfoFrm("reload")

    -- 发起查询月卡和月卡每日领奖
    SendCmdFunc["query_month_card"]()

    -- 直接打开
    if bOpenImmediate then
        -- 动态加载漩涡背景图
        --

        -- 存储回调事件
        current_selectedIdx = selectedIdx or LuaGetHeroTankIdx()
        current_funcCallback = callback
        -- current_strEnterMapName = strEnterMapName --进入时指定选中的地图名
        -- current_nEnterMapDifficulty = nEnterMapDifficulty --进入时指定选中的地图难度

        -- 显示随机迷宫地图信息界面
        hGlobal.UI.PhoneTankAvaterInfoFrm:show(1)
        hGlobal.UI.PhoneTankAvaterInfoFrm:active()

        -- 打开上一次的分页（默认显示第1个分页:随机迷宫地图面板）
        local lastPageIdx = CurrentSelectRecord.pageIdx
        if (lastPageIdx == 0) then
            lastPageIdx = 1
        end

        CurrentSelectRecord.pageIdx = 0
        CurrentSelectRecord.contentIdx = 0
        OnClickPageBtn(lastPageIdx)

        -- 防止重复调用
        _bCanCreate = false

        return
    end

    -- 防止重复调用
    if _bCanCreate then
        _bCanCreate = false
        CommentManage.ReadyComment(hVar.CommentTargetTypeDefine.TANKAVATER)

        -- 步骤0，预加载漩涡图
        local actM0 = CCCallFunc:create(function()
            -- 动态加载漩涡背景图
            --
        end)

        -- 步骤1: 绘制第一个分页，并将控件设置成初始位置（屏幕外，为步骤二播放动画做准备）
        local actM1 = CCCallFunc:create(function()
            -- 触发事件，显示积分、金币界面
            -- hGlobal.event:event("LocalEvent_ShowGameCoinFrm")

            -- 存储回调事件
            current_selectedIdx = selectedIdx or LuaGetHeroTankIdx()
            current_funcCallback = callback
            -- current_strEnterMapName = strEnterMapName --进入时指定选中的地图名
            -- current_nEnterMapDifficulty = nEnterMapDifficulty --进入时指定选中的地图难度

            -- 显示随机迷宫地图信息界面
            hGlobal.UI.PhoneTankAvaterInfoFrm:show(1)
            hGlobal.UI.PhoneTankAvaterInfoFrm:active()

            -- 打开上一次的分页（默认显示第1个分页:随机迷宫地图面板）
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

            -- 只有在打开界面时才会监听的事件
            -- 监听：收到网络宝箱数量的事件
            -- hGlobal.event:listen("LocalEvent_getNetChestNum", "__ItemGetChestNum_Frm", function(NumTab)
            -- 更新网络宝箱的数量和界面
            --
            -- end)

            -- 初始设置坐标
            -- 主面板设置到左侧屏幕外面
            local _frm = hGlobal.UI.PhoneTankAvaterInfoFrm
            local dx = BOARD_WIDTH
            _frm:setXY(BOARD_POS_X + dx, BOARD_POS_Y)
        end)

        -- 步骤2: 动画进入控件
        local actM2 = CCCallFunc:create(function()
            -- 本面板
            local _frm = hGlobal.UI.PhoneTankAvaterInfoFrm

            -- 往左做运动
            local px, py = BOARD_POS_X + BOARD_WIDTH, BOARD_POS_Y
            local dx = BOARD_WIDTH
            -- local act1 = CCDelayTime:create(0.01)
            local act2 = CCMoveTo:create(0.5, ccp(px - dx, py))
            local act4 = CCCallFunc:create(function()
                -- _frm.data.x = 0
                _frm:setXY(px - dx, py)
            end)
            local a = CCArray:create()
            -- a:addObject(act1)
            a:addObject(act2)
            a:addObject(act4)
            local sequence = CCSequence:create(a)
            _frm.handle._n:stopAllActions() -- 先停掉之前可能的动画
            _frm.handle._n:runAction(sequence)

        end)

        local aM = CCArray:create()
        aM:addObject(actM0)
        aM:addObject(actM1)
        aM:addObject(actM2)
        local sequence = CCSequence:create(aM)
        local _frm = hGlobal.UI.Phone_MyHeroCardFrm_New
        _frm.handle._n:stopAllActions() -- 先停掉之前可能的动画
        _frm.handle._n:runAction(sequence)

        -- 存储是哪张地图点进来的
        -- current_mapName_entry = mapName
        -- print("current_mapName_entry=", current_mapName_entry)

        -- 更新提示当前哪个分页可以有领取的了
        -- RefreshBillboardFinishPage()

        -- 只有在打开界面时才会监听的事件
        -- 监听：收到网络宝箱数量的事件
        -- hGlobal.event:listen("LocalEvent_getNetChestNum", "__ItemGetChestNum_Frm", function(NumTab)
        -- 更新网络宝箱的数量和界面
        --
        -- end)
    end
end)

-- 监听关闭宝箱界面事件
hGlobal.event:listen("clearPhoneChestFrm", "__CloseTankAvaterFrm", function()
    if hGlobal.UI.PhoneTankAvaterInfoFrm then
        if (hGlobal.UI.PhoneTankAvaterInfoFrm.data.show == 1) then
            -- 关闭本界面
            OnClosePanel()
        end

        -- 允许再次打开
        _bCanCreate = true
    end
end)

-- test
--[[
--测试代码
if hGlobal.UI.PhoneTankAvaterInfoFrm then --删除上一次的随机迷宫地图信息界面
	hGlobal.UI.PhoneTankAvaterInfoFrm:del()
	hGlobal.UI.PhoneTankAvaterInfoFrm = nil
end
hGlobal.UI.InitTankAvaterInfoFrm("reload") --测试创建战车皮肤界面
--触发事件，显示战车皮肤界面
hGlobal.event:event("LocalEvent_TankAvaterFrm", selectedIdx)
]]