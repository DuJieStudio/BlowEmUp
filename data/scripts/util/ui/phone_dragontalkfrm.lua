-- 竖屏模式
local BOARD_WIDTH = 690 -- DLC地图面板面板的宽度
local BOARD_HEIGHT = 740 -- DLC地图面板面板的高度
local BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 10
local BOARD_OFFSETY = -15 -- DLC地图面板面板y偏移中心点的值
local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX -- DLC地图面板面板的x位置（最左侧）
local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY -- DLC地图面板面板的y位置（最顶侧）
-- local BOARD_ACTIVE_WIDTH = 508 --排行榜面板活动宽度（卡牌显示的宽度）

-- 横屏模式
if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
    BOARD_WIDTH = 740 -- DLC地图面板面板的宽度
    BOARD_HEIGHT = 690 -- DLC地图面板面板的高度
    BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 20
    BOARD_OFFSETY = 15 -- DLC地图面板面板y偏移中心点的值
    BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX -- DLC地图面板面板的x位置（最左侧）
    BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY -- DLC地图面板面板的y位置（最顶侧）
end

local BOARD_ACTIVE_WIDTH = 508 -- 任务操作面板活动宽度（卡牌显示的宽度）

local PAGE_BTN_LEFT_X = 480 -- 第一个分页按钮的x偏移
local PAGE_BTN_LEFT_Y = -6 -- 第一个分页按钮的x偏移
local PAGE_BTN_OFFSET_X = 140 -- 每个分页按钮的间距

local BILLBOARD_WIDTH = 200 -- 排行榜宽度
local BILLBOARD_HEIGHT = 180 -- 排行榜高度
local BILLBOARD_OFFSETX = 210 -- 排行榜第一个元素距离左侧的x偏移
local BILLBOARD_OFFSETY = -210 -- 排行榜第一个元素距离左侧的y偏移
local BILLBOARD_DISTANCEX = 10 -- 排行榜x间距
local BILLBOARD_DISTANCEY = 10 -- 排行榜y间距

-- 横屏模式
if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
    BILLBOARD_OFFSETX = 210 + 50
end

-- 临时UI管理
local leftRemoveFrmList = {} -- 左侧控件集
local rightRemoveFrmList = {} -- 右侧控件集
local _removeLeftFrmFunc = hApi.DoNothing -- 清空左侧所有的临时控件
local _removeRightFrmFunc = hApi.DoNothing -- 清空右侧所有的临时控件

-- 局部函数
-- local OnConnectGameCenterSuccess = hApi.DoNothing --登入gamecenter成功事件
local OnClickPageBtn = hApi.DoNothing -- 点击分页按钮

-- 函数部分
-- 分页1：母巢之战部分
local OnCreateMuChaoZhiZhanFrame = hApi.DoNothing -- 创建母巢之战界面（第1个分页）
-- local on_receive_shop_iteminfo_back_event = hApi.DoNothing --收到商城商品信息结果返回
-- local on_receive_shop_refresh_back_event = hApi.DoNothing --收到商城刷新结果返回
-- local on_click_buitem_shopitem = hApi.DoNothing --点击购买商城道具逻辑
-- local on_click_refresh_shopitem = hApi.DoNothing --点击刷新商城道具逻辑
-- local on_check_shopitem_tanhao = hApi.DoNothing --刷新限时商城叹号
-- local on_refresh_shop_buyitem_lefttime_timer = hApi.DoNothing --刷新商城限时商品倒计时timer
local on_receive_billboardT_event = hApi.DoNothing -- 收到排行榜静态数据模板的回调（第1个、第2个分页）
local on_receive_require_battle_entertament_ret = hApi.DoNothing -- 收到请求挑战娱乐地图事件返回
local on_spine_screen_event = hApi.DoNothing -- 横竖屏切换事件
local __DynamicAddRes = hApi.DoNothing -- 动态加载资源
local __DynamicRemoveRes = hApi.DoNothing -- 动态删除资源
local OnClosePanel = hApi.DoNothing -- 关闭本界面

-- 分页2：前哨阵地部分
local OnCreateQianShaoZhenDiFrame = hApi.DoNothing -- 创建前哨阵地界面（第2个分页）
local OnClickRankButton = hApi.DoNothing -- 点击排行榜按钮

-- 分页3：夺宝奇兵部分
local OnCreateDuoBaoQiBingFrame = hApi.DoNothing -- 创建夺宝奇兵界面（第3个分页）

-- 参数部分

-- 分页1：限时商品相关参数
local current_difficulty_select = 1
local DIFFICULTY_MIN = 1
local DIFFICULTY_MAX = 20
local current_shop_query_flag = 0 -- 商店是否需要查询（仅每次第一次打开才需要发起查询）
local current_funcCallback = nil -- 关闭后的回调事件
local _bCanCreate = true -- 防止重复创建
-- 当前选中的记录
local CurrentSelectRecord = {
    pageIdx = 0,
    contentIdx = 0,
    cardId = 0
} -- 当前选择的分页、数据项的信息记录

-- 分页2：前哨阵地
local current_bId = 2 -- 前哨阵地排行榜id
local current_billboardT = nil -- 前哨阵地今日难度配置表
local current_diffBuffOffset = {
    [1203] = {
        offsetX = -38,
        offsetY = 54
    },
    [1204] = {
        offsetX = 42,
        offsetY = 54
    },
    [1205] = {
        offsetX = -80,
        offsetY = -18
    },
    [1206] = {
        offsetX = 0,
        offsetY = -18
    },
    [1207] = {
        offsetX = 82,
        offsetY = -18
    },
    [1208] = {
        offsetX = -38,
        offsetY = -88
    },
    [1209] = {
        offsetX = 42,
        offsetY = -88
    }
}

-- 分页3：夺宝奇兵
local current_difficulty_select3 = 1 -- 难度
local DBQB_DIFFICULTY_NAME = {
    '简单',
    '正常',
    '困难',
    '噩梦'
}

-- 根据值删除表元素
local function table_removebyvalue(array, value, removeall)
    local c, i, max = 0, 1, #array
    while i <= max do
        if array[i] == value then
            table.remove(array, i)
            c = c + 1
            i = i - 1
            max = max - 1
            if not removeall then
                break
            end
        end
        i = i + 1
    end
    return c
end

-- 奖励类型
local RewardType = {
    Coin = 1, -- 游戏币
    Prop = 2, -- 道具
    Debris = 3 -- 碎片
}

-- 判断奖励类型：1游戏币|2道具|3碎片
-- @param rewardType number
-- @return RewardType 
local function CheckRewardType(rewardType)
    if rewardType == nil then
        -- 不需要显示数量的形式
        return RewardType.Prop
    end

    local ret = nil
    if (rewardType == 3) or (rewardType == 10) then
        ret = RewardType.Prop
    elseif (rewardType == 6) or (rewardType == 11) or (rewardType == 11) or (rewardType == 101) or (rewardType == 103) or
        (rewardType == 105) or (rewardType == 106) or (rewardType == 107) or (rewardType == 108) then
        ret = RewardType.Debris
    else
        ret = RewardType.Coin
    end
    return ret
end

-- 黑龙对话界面
hGlobal.UI.InitBlackDragonTalkFrm = function(mode)
    local tInitEventName = {
        "LocalEvent_Phone_ShowBlackDragonTalkFrm",
        "__ShowBlackDragonTalkFrm"
    }
    if (mode ~= "reload") then
        -- return tInitEventName
        return
    end

    -- 不重复创建
    if hGlobal.UI.PhoneBlackDragonTalkFrm_New then -- 新商店面板
        hGlobal.UI.PhoneBlackDragonTalkFrm_New:del()
        hGlobal.UI.PhoneBlackDragonTalkFrm_New = nil
    end

    --[[
	--取消监听打开新商店界面事件
	hGlobal.event:listen("LocalEvent_Phone_ShowBlackDragonTalkFrm", "__ShowBlackDragonTalkFrm", nil)
	--取消监听关闭宝箱界面事件
	hGlobal.event:listen("LocalEvent_Phone_HideBlackDragonTalkFrm", "__CloseDragonTalkFrm", nil)
	]]

    BOARD_WIDTH = 690 -- DLC地图面板面板的宽度
    BOARD_HEIGHT = 740 -- DLC地图面板面板的高度
    BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 10
    BOARD_OFFSETY = -15 -- DLC地图面板面板y偏移中心点的值
    BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX -- DLC地图面板面板的x位置（最左侧）
    BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY -- DLC地图面板面板的y位置（最顶侧）
    -- 横屏模式
    if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
        BOARD_WIDTH = 740 -- DLC地图面板面板的宽度
        BOARD_HEIGHT = 690 -- DLC地图面板面板的高度
        BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 20
        BOARD_OFFSETY = 15 -- DLC地图面板面板y偏移中心点的值
        BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX -- DLC地图面板面板的x位置（最左侧）
        BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY -- DLC地图面板面板的y位置（最顶侧）
    end

    BILLBOARD_OFFSETX = 210 -- 排行榜第一个元素距离左侧的x偏移
    -- 横屏模式
    if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
        BILLBOARD_OFFSETX = 210 + 50
    end

    -- 加载资源
    -- xlLoadResourceFromPList("data/image/misc/pvp.plist")

    -- hApi.clearTimer("__SHOP_TIMER_PAGE_OPENCHEST__")
    -- hApi.clearTimer("__SHOP_TIMER_PAGE_BUYITEM__")
    -- hApi.clearTimer("__SHOP_TIMER_PAGE_ADVVIEW__")

    -- 创建黑龙对话面板
    hGlobal.UI.PhoneBlackDragonTalkFrm_New = hUI.frame:new({
        x = BOARD_POS_X,
        y = BOARD_POS_Y,
        w = BOARD_WIDTH,
        h = BOARD_HEIGHT,
        dragable = 2,
        show = 0, -- 一开始不显示
        border = 1, -- 显示frame边框
        background = -1, -- "panel/panel_part_00.png",
        -- background = "UI:herocardfrm",
        autoactive = 0
        -- 全部事件
        -- codeOnDragEx = function(touchX, touchY, touchMode)
        --
        -- end,
    })

    local _frm = hGlobal.UI.PhoneBlackDragonTalkFrm_New
    local _parent = _frm.handle._n

    -- 活动左侧裁剪区域
    -- local _BTC_PageClippingRect_Activity = {0, -80, 1000, 460, 0}
    -- local _BTC_pClipNode_Activity = hApi.CreateClippingNode(_frm, _BTC_PageClippingRect_Activity, 99, _BTC_PageClippingRect_Activity[5], "_BTC_pClipNode_Activity")

    -- 主界面黑色背景图
    _frm.childUI["panel_bg"] = hUI.button:new({
        parent = _parent,
        model = "misc/mask.png",
        x = _frm.data.w,
        y = 0,
        w = 1,
        h = 1,
        z = -1
    })
    _frm.childUI["panel_bg"].handle.s:setOpacity(0) -- 为了挂载动态图

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
    -- btnClose
    _frm.childUI["closeBtn"] = hUI.button:new({
        parent = _parent,
        dragbox = _frm.childUI["dragBox"],
        -- model = "UI:BTN_Close", --BTN:PANEL_CLOSE
        model = "misc/mask.png",
        -- x = hVar.SCREEN.w - iPhoneX_WIDTH - 40 * _ScaleW,
        -- y = -34 * _ScaleH,
        -- x = hVar.SCREEN.w - iPhoneX_WIDTH * 2 - 57,
        x = BOARD_WIDTH - 52,
        y = -110,
        z = 100,
        w = 96,
        h = 96,
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

    -- 每个分页按钮
    -- 商城抽奖、商城碎片、看广告
    local tPageIcons = {
        "UI:JUBAOPEN"
    }
    -- local tTexts = {"聚宝盆", "限时商品", "看广告",} --language
    local tTexts = {
        ""
    } -- language --hVar.tab_string["__TEXT_Page_Rune"]
    for i = 1, #tPageIcons, 1 do
        -- 分页按钮
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
            end
        })
        _frm.childUI["PageBtn" .. i].handle.s:setOpacity(0) -- 分页按钮点击区域，只作为控制用，不用于显示

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
			x = -40 - 4,
			y = 0,
			w = 36,
			h = 36,
		})
		
		--分页按钮的文字
		local fontSize = 26
		local fontDx = 0
		local fontLength = (#tTexts[i])
		if (fontLength >= 12) then --4个汉字
			fontSize = 22
			fontDx = -6
		elseif (fontLength >= 9) then --3个汉字
			fontSize = 24
			fontDx = 0
		end
		_frm.childUI["PageBtn" .. i].childUI["PageText"] = hUI.label:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			x = -16 - 4 + fontDx,
			y = -2,
			size = fontSize,
			align = "LC",
			border = 1,
			font = hVar.FONTC,
			width = 100,
			text = tTexts[i],
		})
		]]
        -- 分页按钮的提示升级的动态箭头标识
        _frm.childUI["PageBtn" .. i].childUI["NoteJianTou"] = hUI.image:new({
            parent = _frm.childUI["PageBtn" .. i].handle._n,
            model = "UI:TaskTanHao",
            x = -40,
            y = 6,
            w = 42,
            h = 42
        })
        _frm.childUI["PageBtn" .. i].childUI["NoteJianTou"].handle.s:setVisible(false) -- 默认一开始不显示提示该分页可以领取的动态箭头
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
        local _frm = hGlobal.UI.PhoneBlackDragonTalkFrm_New
        local _frmNode = _frm.childUI["PageNode"]

        for i = 1, #leftRemoveFrmList do
            hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i])
        end
        leftRemoveFrmList = {}
    end

    -- 清空所有分页右侧的UI
    _removeRightFrmFunc = function(pageIndex)
        local _frm = hGlobal.UI.PhoneBlackDragonTalkFrm_New
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
            _frm.childUI["PageBtn" .. i]:setstate(1) -- 按钮可用
            -- _frm.childUI["PageBtn" .. i].childUI["PageImage"].handle.s:setVisible(true) --显示图片
            -- _frm.childUI["PageBtn" .. i].childUI["PageIcon"].handle.s:setVisible(true) --显示图标
            -- _frm.childUI["PageBtn" .. i].childUI["PageText"].handle.s:setVisible(true) --显示文字
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

        -- 先清空上次分页的全部信息
        _removeLeftFrmFunc()
        _removeRightFrmFunc()

        -- 清空切换分页之后取消的监听事件
        -- 移除事件监听：收到新商店抽奖信息结果回调
        -- hGlobal.event:listen("localEvent_ShopChouJiangInfo_Ret", "__OnReceiveShopChouJiangInfo", nil)
        -- 移除事件监听：收到排行榜静态数据模板的回调
        hGlobal.event:listen("localEvent_refresh_billboardT", "__QueryComBatEvaluationBoardT", nil)
        -- 移除事件监听：收到请求挑战娱乐地图结果返回
        hGlobal.event:listen("LocalEvent_RequireEntertamentNormalRet", "__RequireEntertamentNormalRet", nil)
        -- 移除事件监听：横竖屏切换
        hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenEntertamentNormal_", nil)

        -- 移除timer
        -- hApi.clearTimer("__SHOP_TIMER_PAGE_OPENCHEST__")
        -- hApi.clearTimer("__SHOP_TIMER_PAGE_BUYITEM__")
        -- hApi.clearTimer("__SHOP_TIMER_PAGE_ADVVIEW__")

        -- 隐藏所有的clipNode
        -- hApi.EnableClipByName(_frm, "_BTC_pClipNode_Activity", 0)

        -- 新建该分页下的全部信息
        if (pageIndex == 1) then -- 分页1：母巢之战
            -- 创建母巢之战界面
            OnCreateMuChaoZhiZhanFrame(pageIndex)
        elseif (pageIndex == 2) then -- 分页2：前哨阵地
            -- 创建前哨阵地界面
            OnCreateQianShaoZhenDiFrame(pageIndex)
        elseif (pageIndex == 3) then -- 分页3：夺宝奇兵
            -- 创建夺宝奇兵界面
            OnCreateDuoBaoQiBingFrame(pageIndex)
        end

        -- 标记当前选择的分页和页内的第几个
        CurrentSelectRecord.pageIdx = pageIndex
        CurrentSelectRecord.contentIdx = 0
    end

    -- 函数：创建母巢之战界面（第1个分页）
    OnCreateMuChaoZhiZhanFrame = function(pageIdx)
        local _frm = hGlobal.UI.PhoneBlackDragonTalkFrm_New
        local _frmNode = _frm.childUI["PageNode"]
        local _parentNode = _frmNode.handle._n

        -- 初始化数据
        current_billboardT = nil

        -- 动态加载宝物背景大图
        __DynamicRemoveRes()
        __DynamicAddRes(pageIdx)

        ----------------------------------------------------------------------------------------------------
        -- 抽神器黑色背景底板
        -- 九宫格
        -- local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_graywhite.png", 401, -20, 756, 540, _frmNode.childUI["DLCMapInfoListLineV"])
        -- s9:setColor(ccc3(128, 128, 128))
        -- s9:setOpacity(32)

        -- 商品刷新时间背景框
        -- 九宫格
        -- local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_9s_3.png", 401, BOARD_HEIGHT/2 - 90, 720, 48, _frmNode.childUI["DLCMapInfoListLineV"])

        --[[
		--按钮2-前哨阵地
		_frmNode.childUI["labCombatBtn2"] = hUI.button:new({ --只挂载子控件，不显示
			parent = _parentNode,
			x = 78 + BILLBOARD_OFFSETX - 210,
			y = -46,
			model = "misc/chest/dragon_maptab.png",
			dragbox = _frm.childUI["dragBox"],
			label = {text = hVar.tab_string["__TEXT_PAGE_QIANSHAOZHENDI"], size = 28, font = hVar.FONTC, border = 1, x = 10, y = 5, RGB = {52, 79, 62,},}, --"前哨阵地"
			w = 182,
			h = 82,
			align = "MC",
			scaleT = 0.95,
			code = function()
				OnClickPageBtn(2)
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatBtn2"
		
		--按钮3-夺宝奇兵
		_frmNode.childUI["labCombatBtn3"] = hUI.button:new({ --只挂载子控件，不显示
			parent = _parentNode,
			x = 78 + BILLBOARD_OFFSETX - 210 + 138*2,
			y = -46,
			model = "misc/chest/dragon_maptab.png",
			dragbox = _frm.childUI["dragBox"],
			label = {text = hVar.tab_string["__TEXT_PAGE_DUOBAIQIBING"], size = 28, font = hVar.FONTC, border = 1, x = 10, y = 5, RGB = {52, 79, 62,},}, --"夺宝奇兵"
			w = 182,
			h = 82,
			align = "MC",
			scaleT = 0.95,
			code = function()
				OnClickPageBtn(3)
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatBtn3"
		
		--按钮1-母巢之战
		_frmNode.childUI["labCombatBtn1"] = hUI.button:new({ --只挂载子控件，不显示
			parent = _parentNode,
			x = 78 + BILLBOARD_OFFSETX - 210 + 138,
			y = -46,
			model = "misc/chest/dragon_maptab_selected.png",
			dragbox = _frm.childUI["dragBox"],
			label = {text = hVar.tab_string["__TEXT_PAGE_MUCHAOZHIZHAN"], size = 28, font = hVar.FONTC, border = 1, x = 10, y = 5, RGB = {52, 79, 62,},}, --"母巢之战"
			w = 182,
			h = 82,
			align = "MC",
			scaleT = 0.95,
			code = function()
				print("1")
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatBtn1"
		]]

        -- 母巢之战图标
        _frmNode.childUI["labCombatBtn1"] = hUI.image:new({
            parent = _parentNode,
            x = 78 + BILLBOARD_OFFSETX + 56,
            y = -40,
            model = "misc/chest/brood_panel_title.png",
            w = 150,
            h = 60,
            align = "MC"
        })
        rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatBtn1"

        -- * 母巢之战奖励信息
        -- * ==========================================================================================================
        -- 奖励标题
        _frmNode.childUI["rewardTitle"] = hUI.label:new({
            parent = _parentNode,
            text = "首通奖励：",
            x = 154 + BILLBOARD_OFFSETX - 210 - 146,
            y = -720 + 270,
            w = 278,
            h = 40,
            size = 26,
            align = "LT",
            bold = 0,
            font = hVar.FONTC
        })
        rightRemoveFrmList[#rightRemoveFrmList + 1] = "rewardTitle"

        -- 清除奖励标题
        local UpdateRewardTitleLabel = function()
            local max_difficulty = LuaGetPlayerMapAchi("world/yxys_ex_001", hVar.ACHIEVEMENT_TYPE.Map_Difficult) or 0
            --[[ 测试用
			max_difficulty = math.random(0,20)
			--]]
            local is_show_title = current_difficulty_select > max_difficulty
            _frmNode.childUI["rewardTitle"].handle.s:setVisible(is_show_title)
        end

        local rewardIconBtnList = {}

        -- 清除奖励按钮列表
        local ClearRewardIconBtnList = function()
            for _, v in ipairs(rewardIconBtnList) do
                v.btn:del()
                table_removebyvalue(rightRemoveFrmList, v.name)
            end
            rewardIconBtnList = {}
        end

        -- 获取当前难度奖励信息
        local GetRewardListByCurrentDifficulty = function()
            local max_difficulty = LuaGetPlayerMapAchi("world/yxys_ex_001", hVar.ACHIEVEMENT_TYPE.Map_Difficult) or 0
            --[[ 测试用
			max_difficulty = math.random(0,20)
			--]]
            print(string.format("current_difficult_select[%s] ; max_difficulty[%s]", current_difficulty_select,
                max_difficulty))
            local ret
            -- if current_difficulty_select > max_difficulty then
            -- 首通奖励
            ret = hVar.MAP_INFO["world/yxys_ex_001"].DiffMode[current_difficulty_select].starReward
            -- else
            -- 	-- 随机奖励
            -- 	ret = hVar.MAP_INFO["world/yxys_ex_001"].DiffMode[current_difficulty_select].randReward
            -- end
            return ret
        end

        -- 更新奖励按钮列表
        local UpdateRewardIconBtnList = function(reward_config_list)
            ClearRewardIconBtnList()

            --[[ 测试用
			local tmp_reward_config_list = {
				{10,20105,0,0}, --装备
				{101,15002,5,0}, --枪
				{11,10,0}, --强化材料
			}
			reward_config_list = tmp_reward_config_list
			--]]

            local scale = 1.5
            for i, reward_config in ipairs(reward_config_list) do
                -- 奖励类型枚举
                local rewardTypeEnum = CheckRewardType(reward_config[1])
                --[[ 测试
				rewardTypeEnum = RewardType.Coin
				--]]
                local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w,
                    sub_pos_h = hApi.GetRewardParams(reward_config)
                print(tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w,
                    sub_pos_h)

                -- print("itemWidth:" .. tostring(itemWidth * scale))
                -- print("itemHeight:" .. tostring(itemHeight * scale))

                --[[ 测试
				tmpModel = "misc/skillup/keshi.png"
				itemNum = 50
				--]]

                local btnName = "rewardIconBtnParentNode_MCZZ_" .. i
                _frmNode.childUI["rewardIconBtnParentNode_MCZZ_" .. i] = hUI.button:new({
                    parent = _parentNode,
                    model = "misc/mask.png",
                    dragbox = _frm.childUI["dragBox"],
                    x = 154 + BILLBOARD_OFFSETX - 210 - 100 + (i - 1) * (115),
                    y = -720 + 94 + 100,
                    w = itemWidth * scale,
                    h = itemHeight * scale,
                    -- align = "LT",
                    scaleT = 0.95,
                    code = function()
                        -- print(btnName)
                        -- 显示各种类型的奖励的tip
                        hApi.ShowRewardTip(reward_config)
                    end
                })
                _frmNode.childUI["rewardIconBtnParentNode_MCZZ_" .. i].handle.s:setOpacity(0)
                -- rightRemoveFrmList[#rightRemoveFrmList + 1] = "rewardTitle"
                table.insert(rightRemoveFrmList, btnName)
                rewardIconBtnList[#rewardIconBtnList + 1] = {
                    name = "rewardIconBtnParentNode_MCZZ_" .. i,
                    btn = _frmNode.childUI["rewardIconBtnParentNode_MCZZ_" .. i]
                }

                local _btnParent = _frmNode.childUI["rewardIconBtnParentNode_MCZZ_" .. i]

                if tmpModel and #tmpModel > 0 then
                    -- 奖励图标
                    _btnParent.childUI["rewardIconBtnImage_MCZZ_" .. i] = hUI.image:new({
                        parent = _btnParent.handle._n,
                        model = tmpModel,
                        x = 0,
                        y = 0,
                        w = itemWidth * scale,
                        h = itemHeight * scale
                    })

                    if rewardTypeEnum == RewardType.Debris then -- 奖励碎片
                        -- 碎片数量
                        _btnParent.childUI["rewardIconBtnText_MCZZ_" .. i] = hUI.label:new({
                            parent = _btnParent.handle._n,
                            x = 14,
                            y = -65,
                            w = itemWidth * scale,
                            h = itemHeight * scale,
                            size = 22,
                            font = hVar.FONTC,
                            align = "MB",
                            width = 100,
                            border = 0,
                            text = "×" .. tostring(itemNum)
                        })

                        -- 碎片数量底图
                        local model_path = "misc/addition/"
                        if itemNum < 50 then
                            model_path = model_path .. "debris_bg_less.png"
                        else
                            model_path = model_path .. "debris_bg_more.png"
                        end
                        _btnParent.childUI["rewardIconBtnTextBgImage_MCZZ_" .. i] = hUI.image:new({
                            parent = _btnParent.handle._n,
                            model = model_path,
                            x = 0,
                            y = -55,
                            scale = 1.1
                        })
                    elseif rewardTypeEnum == RewardType.Coin then -- 奖励游戏币
                        -- 游戏币数量

                        -- 绘制奖励的数量
                        local strRewardNum = "+" .. tostring(itemNum)

                        --[[
						--测试
						strRewardNum = "+0000"
						]]

                        local coinNumLength = #strRewardNum
                        local coinNumFont = "numWhite" -- 字体
                        local coinNumFontSize = 26 -- 字体大小
                        local coinNumBorder = 0 -- 是否显示边框
                        if (coinNumLength == 3) then
                            coinNumFont = "numWhite" -- 字体
                            coinNumFontSize = 24 -- 字体大小
                            coinNumBorder = 0 -- 是否显示边框
                        elseif (coinNumLength == 4) then
                            coinNumFont = "numWhite" -- 字体
                            coinNumFontSize = 22 -- 字体大小
                            coinNumBorder = 0 -- 是否显示边框
                        elseif (coinNumLength == 5) then
                            coinNumFont = "numWhite" -- 字体
                            coinNumFontSize = 20 -- 字体大小
                            coinNumBorder = 0 -- 是否显示边框
                        elseif (coinNumLength >= 6) then
                            coinNumFont = hVar.FONTC -- 字体
                            coinNumFontSize = 18 -- 字体大小
                            coinNumBorder = 1 -- 是否显示边框
                        end
                        _btnParent.childUI["rewardIconBtnText_MCZZ_" .. i] = hUI.label:new({
                            parent = _btnParent.handle._n,
                            x = 0,
                            y = -65,
                            w = itemWidth * scale,
                            h = itemHeight * scale,
                            size = coinNumFontSize,
                            font = coinNumFont,
                            align = "MB",
                            width = 100,
                            border = coinNumBorder,
                            text = strRewardNum
                        })
                    end
                end

                -- 子节点
                if sub_tmpModel and #sub_tmpModel > 0 then
                    if rewardTypeEnum == RewardType.Prop then -- 奖励道具
                        _btnParent.childUI["rewardIconBtnSubImage_MCZZ_" .. i] = hUI.image:new({
                            parent = _btnParent.handle._n,
                            model = sub_tmpModel,
                            x = sub_pos_x * scale,
                            y = sub_pos_y * scale,
                            w = sub_pos_w * scale,
                            h = sub_pos_h * scale
                        })
                    end
                end
            end
        end

        local UpdateRewardInfo = function()
            -- UpdateRewardTitleLabel()
            local reward_config_list = GetRewardListByCurrentDifficulty()
            UpdateRewardIconBtnList(reward_config_list)
        end

        -- 更新奖励信息
        UpdateRewardInfo()
        -- * ==========================================================================================================

        -- 挑战难度进度条
        _frmNode.childUI["labCombatDifficultynProgressBar"] = hUI.valbar:new({
            parent = _parentNode,
            model = "UI:ValueBar3",
            back = {
                model = "UI:ValueBar_Back3",
                x = 0,
                y = 0,
                w = 278,
                h = 44
            },
            x = 154 + BILLBOARD_OFFSETX - 200 - 100,
            y = -720 + 96,
            w = 278,
            h = 44,
            align = "LT"
        })
        rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatDifficultynProgressBar"
        -- 设置进度
        _frmNode.childUI["labCombatDifficultynProgressBar"]:setV(current_difficulty_select / DIFFICULTY_MAX)

        -- 当前难度等级值前缀
        _frmNode.childUI["labCombatDifficultyPrefix"] = hUI.label:new({
            parent = _parentNode,
            x = 52 + BILLBOARD_OFFSETX - 210 + 140 + 400,
            y = -720 + 74 + 2 + 40 + 40,
            size = 30,
            font = hVar.FONTC,
            align = "RC",
            width = 300,
            border = 1,
            text = hVar.tab_string["__TEXT_Level"], -- "难度"
            RGB = {
                31,
                205,
                93
            }
        })
        rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatDifficultyPrefix"

        -- 当前难度等级值
        _frmNode.childUI["labCombatDifficultyValue"] = hUI.label:new({
            parent = _parentNode,
            x = 58 + BILLBOARD_OFFSETX - 210 + 140 + 400,
            y = -720 + 74 + 40 + 40,
            size = 30,
            font = "numWhite",
            align = "LC",
            width = 300,
            border = 1,
            text = current_difficulty_select
        })
        _frmNode.childUI["labCombatDifficultyValue"].handle.s:setColor(ccc3(31, 205, 93))
        rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatDifficultyValue"

        -- 难度- 减 按钮
        _frmNode.childUI["labCombatDifficultyMinusBtn"] = hUI.button:new(
            { -- 只挂载子控件，不显示
                parent = _parentNode,
                x = 130 + BILLBOARD_OFFSETX - 210 - 100,
                y = -720 + 74,
                model = "misc/mask.png",
                dragbox = _frm.childUI["dragBox"],
                w = 96,
                h = 96,
                align = "MC",
                scaleT = 0.95,
                code = function()
                    -- 更新选择的难度
                    -- 难度减1
                    current_difficulty_select = current_difficulty_select - 1
                    if (current_difficulty_select < DIFFICULTY_MIN) then
                        current_difficulty_select = DIFFICULTY_MIN
                    end

                    -- 更新界面
                    -- UpdateSingleQunYingDifficulty(difficulty, true)
                    _frmNode.childUI["labCombatDifficultynProgressBar"]:setV(current_difficulty_select / DIFFICULTY_MAX)
                    _frmNode.childUI["labCombatDifficultyValue"]:setText(current_difficulty_select)
                    -- print("difficulty=", current_difficulty_select)

                    UpdateRewardInfo()
                end
            })
        _frmNode.childUI["labCombatDifficultyMinusBtn"].handle.s:setOpacity(0) -- 只挂载子控件，不显示
        rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatDifficultyMinusBtn"
        -- 图片
        _frmNode.childUI["labCombatDifficultyMinusBtn"].childUI["image"] = hUI.image:new({
            parent = _frmNode.childUI["labCombatDifficultyMinusBtn"].handle._n,
            x = 0,
            y = 0,
            model = "UI:subone",
            w = 64 * 1.0,
            h = 56 * 1.0,
            align = "MC"
        })
        -- _frmNode.childUI["labCombatDifficultyMinusBtn"].childUI["image"].handle.s:setRotation(90)

        -- 难度+ 加 按钮
        _frmNode.childUI["labCombatDifficultyAddBtn"] = hUI.button:new(
            { -- 只挂载子控件，不显示
                parent = _parentNode,
                x = 456 + BILLBOARD_OFFSETX - 190 - 100,
                y = -720 + 74,
                model = "misc/mask.png",
                dragbox = _frm.childUI["dragBox"],
                w = 96,
                h = 96,
                align = "MC",
                scaleT = 0.95,
                code = function()
                    -- 挑战难度限制
                    local max_difficulty =
                        LuaGetPlayerMapAchi("world/yxys_ex_001", hVar.ACHIEVEMENT_TYPE.Map_Difficult) or 0
                    if current_difficulty_select >= max_difficulty + 1 then
                        local strText = string.format("请先完成难度%s的挑战！", max_difficulty + 1)
                        hUI.floatNumber:new({
                            x = hVar.SCREEN.w / 2,
                            y = hVar.SCREEN.h / 2,
                            align = "MC",
                            text = "",
                            lifetime = 2000,
                            fadeout = -550,
                            moveY = 32
                        }):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
                        return
                    end

                    -- 更新选择的难度
                    -- 难度加1
                    current_difficulty_select = current_difficulty_select + 1
                    if (current_difficulty_select > DIFFICULTY_MAX) then
                        current_difficulty_select = DIFFICULTY_MAX
                    end

                    --[[
				--检测下一级难度是否可选
				if (difficulty > current_difficulty_max) then
					--冒字
					--local strText = "通关当前难度后解锁下个难度" --language
					local strText = hVar.tab_string["__TEXT_Cant_Select_Difficulty"] --language
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
				]]

                    -- 更新界面
                    -- UpdateSingleQunYingDifficulty(difficulty, true)
                    _frmNode.childUI["labCombatDifficultynProgressBar"]:setV(current_difficulty_select / DIFFICULTY_MAX)
                    _frmNode.childUI["labCombatDifficultyValue"]:setText(current_difficulty_select)
                    -- print("difficulty=", current_difficulty_select)

                    UpdateRewardInfo()
                end
            })
        _frmNode.childUI["labCombatDifficultyAddBtn"].handle.s:setOpacity(0) -- 只挂载子控件，不显示
        rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatDifficultyAddBtn"
        -- 图片
        _frmNode.childUI["labCombatDifficultyAddBtn"].childUI["image"] = hUI.image:new({
            parent = _frmNode.childUI["labCombatDifficultyAddBtn"].handle._n,
            x = 0,
            y = 0,
            model = "UI:addone",
            w = 64 * 1.0,
            h = 56 * 1.0,
            align = "MC"
        })
        -- _frmNode.childUI["labCombatDifficultyAddBtn"].childUI["image"].handle.s:setRotation(-90)

        -- 开始按钮
        _frmNode.childUI["BeginBtn"] = hUI.button:new({
            parent = _parentNode,
            x = 720 - 170 + BILLBOARD_OFFSETX - 210,
            y = -720 + 74,
            -- model = "misc/chest/dragon_start_game.png",
            model = "misc/mask.png",
            dragbox = _frm.childUI["dragBox"],
            -- label = {text = "START", size = 34, font = hVar.FONTC, border = 1, x = 0, y = 3, RGB = {52, 79, 62,},},
            w = 164,
            h = 85,
            align = "MC",
            scaleT = 0.95,
            code = function()
                -- 检测gameserver版本号是否为最新
                if (not hApi.CheckGameServerVersionControl()) then
                    return
                end

                -- 挡操作
                hUI.NetDisable(30000)

                -- 发起请求，挑战娱乐地图（母巢之战）
                local MapDifficulty = current_difficulty_select
                SendCmdFunc["require_battle_entertament"](hVar.MuChaoZhiZhanMap, MapDifficulty)
            end
        })
        _frmNode.childUI["BeginBtn"].handle.s:setOpacity(0) -- 只挂载子控件，不显示
        rightRemoveFrmList[#rightRemoveFrmList + 1] = "BeginBtn"
        -- 开始按钮动画图片
        _frmNode.childUI["BeginBtn"].childUI["icon"] = hUI.image:new({
            parent = _frmNode.childUI["BeginBtn"].handle._n,
            x = 0,
            y = 0,
            model = "MODEL_EFFECT:StartAmin2",
            scale = 1
        })
        -- 按钮动画
        _frmNode.childUI["BeginBtn"].childUI["icon"] = hUI.image:new({
            parent = _frmNode.childUI["BeginBtn"].handle._n,
            model = "MODEL_EFFECT:StartAmin2",
            x = 0,
            y = 0,
            scale = 1.0
        })
        -- 消耗的体力图标
        _frmNode.childUI["BeginBtn"].childUI["tiliIcon"] = hUI.image:new({
            parent = _frmNode.childUI["BeginBtn"].handle._n,
            model = "misc/task/tili.png",
            x = 80,
            y = -8,
            scale = 0.9
        })
        -- 消耗的体力值
        _frmNode.childUI["BeginBtn"].childUI["tiliCost"] = hUI.label:new({
            parent = _frmNode.childUI["BeginBtn"].handle._n,
            x = 80 + 20,
            y = -8 - 1,
            font = "numWhite",
            align = "LC",
            text = "1",
            border = 0,
            size = 24
        })
        _frmNode.childUI["BeginBtn"].childUI["tiliCost"].handle.s:setColor(ccc3(0, 255, 0))

        -- 添加事件监听：商城信息返回
        -- hGlobal.event:listen("localEvent_refresh_shopinfo", "__OnReceiveShopItemRet", on_receive_shop_iteminfo_back_event)
        -- 添加事件监听：收到请求挑战娱乐地图结果返回
        hGlobal.event:listen("LocalEvent_RequireEntertamentNormalRet", "__RequireEntertamentNormalRet",
            on_receive_require_battle_entertament_ret)
        -- 添加事件监听：横竖屏切换
        hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenEntertamentNormal_", on_spine_screen_event)

        -- 只有在本分页才会有的timer
        -- hApi.addTimerForever("__SHOP_TIMER_PAGE_BUYITEM__", hVar.TIMER_MODE.GAMETIME, 1000, on_refresh_shop_buyitem_lefttime_timer)
    end

    -- 函数：创建前哨阵地界面（第2个分页）
    OnCreateQianShaoZhenDiFrame = function(pageIdx)
        local _frm = hGlobal.UI.PhoneBlackDragonTalkFrm_New
        local _frmNode = _frm.childUI["PageNode"]
        local _parentNode = _frmNode.handle._n

        -- 初始化数据
        current_billboardT = nil

        -- 动态加载宝物背景大图
        __DynamicRemoveRes()
        __DynamicAddRes(pageIdx)

        ----------------------------------------------------------------------------------------------------
        -- 抽神器黑色背景底板
        -- 九宫格
        -- local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_graywhite.png", 401, -20, 756, 540, _frmNode.childUI["DLCMapInfoListLineV"])
        -- s9:setColor(ccc3(128, 128, 128))
        -- s9:setOpacity(32)

        -- 商品刷新时间背景框
        -- 九宫格
        -- local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_9s_3.png", 401, BOARD_HEIGHT/2 - 90, 720, 48, _frmNode.childUI["DLCMapInfoListLineV"])

        --[[
		--按钮2-前哨阵地
		_frmNode.childUI["labCombatBtn2"] = hUI.button:new({ --只挂载子控件，不显示
			parent = _parentNode,
			x = 78 + BILLBOARD_OFFSETX - 210,
			y = -46,
			z = 3,
			model = "misc/chest/dragon_maptab_selected.png",
			dragbox = _frm.childUI["dragBox"],
			label = {text = hVar.tab_string["__TEXT_PAGE_QIANSHAOZHENDI"], size = 28, font = hVar.FONTC, border = 1, x = 10, y = 5, RGB = {52, 79, 62,},}, --"前哨阵地"
			w = 182,
			h = 82,
			align = "MC",
			scaleT = 0.95,
			code = function()
				OnClickPageBtn(2)
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatBtn2"
		
		--按钮3-夺宝奇兵
		_frmNode.childUI["labCombatBtn3"] = hUI.button:new({ --只挂载子控件，不显示
			parent = _parentNode,
			x = 78 + BILLBOARD_OFFSETX - 210 + 138*2,
			y = -46,
			z = 1,
			model = "misc/chest/dragon_maptab.png",
			dragbox = _frm.childUI["dragBox"],
			label = {text = hVar.tab_string["__TEXT_PAGE_DUOBAIQIBING"], size = 28, font = hVar.FONTC, border = 1, x = 10, y = 5, RGB = {52, 79, 62,},}, --"夺宝奇兵"
			w = 182,
			h = 82,
			align = "MC",
			scaleT = 0.95,
			code = function()
				OnClickPageBtn(3)
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatBtn3"
		
		--按钮1-母巢之战
		_frmNode.childUI["labCombatBtn1"] = hUI.button:new({ --只挂载子控件，不显示
			parent = _parentNode,
			x = 216 + BILLBOARD_OFFSETX - 210,
			y = -46,
			z = 2,
			model = "misc/chest/dragon_maptab.png",
			dragbox = _frm.childUI["dragBox"],
			label = {text = hVar.tab_string["__TEXT_PAGE_MUCHAOZHIZHAN"], size = 28, font = hVar.FONTC, border = 1, x = 10, y = 5, RGB = {52, 79, 62,},}, --"母巢之战"
			w = 182,
			h = 82,
			align = "MC",
			scaleT = 0.95,
			code = function()
				OnClickPageBtn(1)
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatBtn1"
		]]

        -- 前哨阵地图标
        _frmNode.childUI["labCombatBtn1"] = hUI.image:new({
            parent = _parentNode,
            x = 78 + BILLBOARD_OFFSETX + 56,
            y = -40,
            model = "misc/chest/outpost_panel_title.png",
            w = 150,
            h = 60,
            align = "MC"
        })
        rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatBtn1"

        -- 前哨阵地封面图
        _frmNode.childUI["labCombatCover"] = hUI.button:new({ -- 作为按钮只是为了挂载子控件
            parent = _parentNode,
            x = 78 + BILLBOARD_OFFSETX - 100,
            y = -540,
            model = "misc/chest/outpost_panel_addones.png",
            align = "MC",
            scale = 1.0
        })
        rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatCover"

        --
        local baseX = _frmNode.childUI["labCombatCover"].data.x
        local baseY = _frmNode.childUI["labCombatCover"].data.y
        for id, info in pairs(current_diffBuffOffset) do
            local offsetX = info.offsetX + baseX
            local offsetY = info.offsetY + baseY
            local tipy = 54 + baseY
            local tipx = -80 + baseX
            if hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.VERTICAL then
                tipy = -480 + baseY
                tipx = -40
            end

            _frmNode.childUI["btn_clicktactics" .. id] = hUI.button:new(
                { -- 作为按钮只是为了挂载子控件
                    parent = _parentNode,
                    dragbox = _frm.childUI["dragBox"],
                    x = offsetX,
                    y = offsetY,
                    model = "misc/button_null.png",
                    scale = 1.0,
                    w = 64,
                    h = 64,
                    code = function()
                        local lv = 1
                        if current_billboardT and current_billboardT.info and current_billboardT.info[current_bId] then
                            local diff_tactic = current_billboardT.info[current_bId].prize.diff_tactic
                            if (diff_tactic) and (#diff_tactic > 0) then
                                -- 有禁用的敌人增益buff
                                for idx = 1, #diff_tactic, 1 do
                                    local tacticId = diff_tactic[idx] and diff_tactic[idx][1] or 0
                                    local tacticLv = diff_tactic[idx] and diff_tactic[idx][2] or 1
                                    if tacticId == id then
                                        print("diff_tactic", tacticId, tacticLv)
                                        lv = tacticLv
                                    end
                                end
                            end
                        end
                        print("id", id)
                        hGlobal.event:event("localEvent_ShowTacticsTipFrm", id, lv, nil, tipx + 40, tipy + 40)
                    end
                })
            rightRemoveFrmList[#rightRemoveFrmList + 1] = "btn_clicktactics" .. id
        end

        _frmNode.childUI["CommentBtn"] = hUI.button:new({
            parent = _parentNode,
            x = 720 - 170 + BILLBOARD_OFFSETX - 350,
            y = -720 + 50,
            -- model = "misc/chest/dragon_start_game.png",
            model = "misc/button_null.png",
            dragbox = _frm.childUI["dragBox"],
            -- label = {text = "START", size = 34, font = hVar.FONTC, border = 1, x = 0, y = 3, RGB = {52, 79, 62,},},
            w = 100,
            h = 80,
            align = "MC",
            scaleT = 0.95,
            code = function()
                _frm.childUI["closeBtn"].data.code()
                hGlobal.event:event("LocalEvent_DoCommentProcess", {})
            end
        })
        _frmNode.childUI["CommentBtn"].childUI["img"] = hUI.image:new({
            parent = _frmNode.childUI["CommentBtn"].handle._n,
            model = "misc/addition/commentbtn.png",
            scale = 0.9
        })
        rightRemoveFrmList[#rightRemoveFrmList + 1] = "CommentBtn"

        -- 开始按钮
        _frmNode.childUI["BeginBtn"] = hUI.button:new({
            parent = _parentNode,
            x = 720 - 170 + BILLBOARD_OFFSETX - 210,
            y = -720 + 74,
            -- model = "misc/chest/dragon_start_game.png",
            model = "misc/mask.png",
            dragbox = _frm.childUI["dragBox"],
            -- label = {text = "START", size = 34, font = hVar.FONTC, border = 1, x = 0, y = 3, RGB = {52, 79, 62,},},
            w = 164,
            h = 85,
            align = "MC",
            scaleT = 0.95,
            code = function()
                -- 检测gameserver版本号是否为最新
                if (not hApi.CheckGameServerVersionControl()) then
                    return
                end

                -- 如果未获取到难度配置，不能开始战斗
                if (current_billboardT == nil) then
                    -- 提示文字
                    -- local strText = "正在获取地图信息" --language
                    local strText = hVar.tab_string["__TEXT_MapInfoGetting"] -- language
                    hUI.floatNumber:new({
                        x = hVar.SCREEN.w / 2,
                        y = hVar.SCREEN.h / 2,
                        align = "MC",
                        text = "",
                        lifetime = 2000,
                        fadeout = -550,
                        moveY = 32
                    }):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)

                    return
                end

                -- 挡操作
                hUI.NetDisable(30000)

                -- 发起请求，挑战娱乐地图（前哨阵地）
                local MapDifficulty = 0
                SendCmdFunc["require_battle_entertament"](hVar.QianShaoZhenDiMap, MapDifficulty)
            end
        })
        _frmNode.childUI["BeginBtn"].handle.s:setOpacity(0) -- 只挂载子控件，不显示
        rightRemoveFrmList[#rightRemoveFrmList + 1] = "BeginBtn"
        -- 开始按钮动画图片
        _frmNode.childUI["BeginBtn"].childUI["icon"] = hUI.image:new({
            parent = _frmNode.childUI["BeginBtn"].handle._n,
            x = 0,
            y = 0,
            model = "MODEL_EFFECT:StartAmin2",
            scale = 1
        })
        -- 按钮动画
        _frmNode.childUI["BeginBtn"].childUI["icon"] = hUI.image:new({
            parent = _frmNode.childUI["BeginBtn"].handle._n,
            model = "MODEL_EFFECT:StartAmin2",
            x = 0,
            y = 0,
            scale = 1.0
        })
        -- 消耗的体力图标
        _frmNode.childUI["BeginBtn"].childUI["tiliIcon"] = hUI.image:new({
            parent = _frmNode.childUI["BeginBtn"].handle._n,
            model = "misc/task/tili.png",
            x = 80,
            y = -8,
            scale = 0.9
        })
        -- 消耗的体力值
        _frmNode.childUI["BeginBtn"].childUI["tiliCost"] = hUI.label:new({
            parent = _frmNode.childUI["BeginBtn"].handle._n,
            x = 80 + 20,
            y = -8 - 1,
            font = "numWhite",
            align = "LC",
            text = "1",
            border = 0,
            size = 24
        })
        _frmNode.childUI["BeginBtn"].childUI["tiliCost"].handle.s:setColor(ccc3(0, 255, 0))

        -- 排行榜按钮
        _frmNode.childUI["RankBtn"] = hUI.button:new({
            parent = _parentNode,
            x = 720 - 170 + BILLBOARD_OFFSETX - 210,
            y = -720 + 230,
            -- model = "misc/chest/dragon_start_game.png",
            model = "misc/mask.png",
            dragbox = _frm.childUI["dragBox"],
            -- label = {text = "START", size = 34, font = hVar.FONTC, border = 1, x = 0, y = 3, RGB = {52, 79, 62,},},
            w = 160,
            h = 140,
            align = "MC",
            scaleT = 0.95,
            code = function()
                -- 点击排行榜按钮
                OnClickRankButton()
            end
        })
        _frmNode.childUI["RankBtn"].handle.s:setOpacity(0) -- 只挂载子控件，不显示
        leftRemoveFrmList[#leftRemoveFrmList + 1] = "RankBtn"
        -- 排行榜按钮图片
        _frmNode.childUI["RankBtn"].childUI["icon"] = hUI.image:new({
            parent = _frmNode.childUI["RankBtn"].handle._n,
            x = 0,
            y = 0,
            model = "misc/task/randommap_maze_ranking.png",
            scale = 1.0
        })

        -- 添加事件监听：商城信息返回
        -- hGlobal.event:listen("localEvent_refresh_shopinfo", "__OnReceiveShopItemRet", on_receive_shop_iteminfo_back_event)
        -- 添加事件监听：收到排行榜静态数据模板的回调
        hGlobal.event:listen("localEvent_refresh_billboardT", "__QueryComBatEvaluationBoardT",
            on_receive_billboardT_event)
        -- 添加事件监听：收到请求挑战娱乐地图结果返回
        hGlobal.event:listen("LocalEvent_RequireEntertamentNormalRet", "__RequireEntertamentNormalRet",
            on_receive_require_battle_entertament_ret)
        -- 添加事件监听：横竖屏切换
        hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenEntertamentNormal_", on_spine_screen_event)

        -- 只有在本分页才会有的timer
        -- hApi.addTimerForever("__SHOP_TIMER_PAGE_BUYITEM__", hVar.TIMER_MODE.GAMETIME, 1000, on_refresh_shop_buyitem_lefttime_timer)

        -- 挡操作
        hUI.NetDisable(30000)

        -- 发起查询排行榜静态数据
        -- print("发起查询排行榜静态数据1",bId)
        local bId = current_bId
        SendCmdFunc["get_billboardT"](bId)
    end

    -- 函数：创建夺宝奇兵界面（第3个分页）
    OnCreateDuoBaoQiBingFrame = function(pageIdx)
        local _frm = hGlobal.UI.PhoneBlackDragonTalkFrm_New
        local _frmNode = _frm.childUI["PageNode"]
        local _parentNode = _frmNode.handle._n

        -- 初始化数据
        current_billboardT = nil

        -- 动态加载宝物背景大图
        __DynamicRemoveRes()
        __DynamicAddRes(pageIdx)

        ----------------------------------------------------------------------------------------------------
        -- 抽神器黑色背景底板
        -- 九宫格
        -- local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_graywhite.png", 401, -20, 756, 540, _frmNode.childUI["DLCMapInfoListLineV"])
        -- s9:setColor(ccc3(128, 128, 128))
        -- s9:setOpacity(32)

        -- 商品刷新时间背景框
        -- 九宫格
        -- local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_9s_3.png", 401, BOARD_HEIGHT/2 - 90, 720, 48, _frmNode.childUI["DLCMapInfoListLineV"])

        --[[
		--按钮2-前哨阵地
		_frmNode.childUI["labCombatBtn2"] = hUI.button:new({ --只挂载子控件，不显示
			parent = _parentNode,
			x = 78 + BILLBOARD_OFFSETX - 210,
			y = -46,
			z = 1,
			model = "misc/chest/dragon_maptab.png",
			dragbox = _frm.childUI["dragBox"],
			label = {text = hVar.tab_string["__TEXT_PAGE_QIANSHAOZHENDI"], size = 28, font = hVar.FONTC, border = 1, x = 10, y = 5, RGB = {52, 79, 62,},}, --"前哨阵地"
			w = 182,
			h = 82,
			align = "MC",
			scaleT = 0.95,
			code = function()
				OnClickPageBtn(2)
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatBtn2"
		
		--按钮1-母巢之战
		_frmNode.childUI["labCombatBtn1"] = hUI.button:new({ --只挂载子控件，不显示
			parent = _parentNode,
			x = 216 + BILLBOARD_OFFSETX - 210,
			y = -46,
			z = 2,
			model = "misc/chest/dragon_maptab.png",
			dragbox = _frm.childUI["dragBox"],
			label = {text = hVar.tab_string["__TEXT_PAGE_MUCHAOZHIZHAN"], size = 28, font = hVar.FONTC, border = 1, x = 10, y = 5, RGB = {52, 79, 62,},}, --"母巢之战"
			w = 182,
			h = 82,
			align = "MC",
			scaleT = 0.95,
			code = function()
				OnClickPageBtn(1)
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatBtn1"
		
		--按钮3-夺宝奇兵
		_frmNode.childUI["labCombatBtn3"] = hUI.button:new({ --只挂载子控件，不显示
			parent = _parentNode,
			x = 78 + BILLBOARD_OFFSETX - 210 + 138*2,
			y = -46,
			z = 3,
			model = "misc/chest/dragon_maptab_selected.png",
			dragbox = _frm.childUI["dragBox"],
			label = {text = hVar.tab_string["__TEXT_PAGE_DUOBAIQIBING"], size = 28, font = hVar.FONTC, border = 1, x = 10, y = 5, RGB = {52, 79, 62,},}, --"夺宝奇兵"
			w = 182,
			h = 82,
			align = "MC",
			scaleT = 0.95,
			code = function()
				print("3")
			end,
		})
		rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatBtn3"
		]]

        -- 夺宝奇兵图标
        _frmNode.childUI["labCombatBtn1"] = hUI.image:new({
            parent = _parentNode,
            x = 78 + BILLBOARD_OFFSETX + 56,
            y = -40,
            model = "misc/chest/pvp_panel_title.png",
            w = 150,
            h = 60,
            align = "MC"
        })
        rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatBtn1"

        -- * 夺宝奇兵奖励信息
        -- * ==========================================================================================================
        -- 奖励标题
        _frmNode.childUI["rewardTitle"] = hUI.label:new({
            parent = _parentNode,
            text = "首通奖励：",
            x = 154 + BILLBOARD_OFFSETX - 210 - 121,
            y = -720 + 360,
            w = 278,
            h = 40,
            size = 26,
            align = "LT",
            bold = 0,
            font = hVar.FONTC
        })
        rightRemoveFrmList[#rightRemoveFrmList + 1] = "rewardTitle"

        -- 清除奖励标题
        local UpdateRewardTitleLabel = function()
            local max_difficulty = LuaGetPlayerMapAchi("world/yxys_ex_003", hVar.ACHIEVEMENT_TYPE.Map_Difficult) or 0
            --[[ 测试用
			max_difficulty = math.random(0,4)
			--]]
            local is_show_title = current_difficulty_select3 > max_difficulty
            _frmNode.childUI["rewardTitle"].handle.s:setVisible(is_show_title)
        end

        local rewardIconBtnList = {}

        -- 清除奖励按钮列表
        local ClearRewardIconBtnList = function()
            for _, v in ipairs(rewardIconBtnList) do
                v.btn:del()
                table_removebyvalue(rightRemoveFrmList, v.name)
            end
            rewardIconBtnList = {}
        end

        -- 获取当前难度奖励信息
        local GetRewardListByCurrentDifficulty = function()
            local max_difficulty = LuaGetPlayerMapAchi("world/yxys_ex_003", hVar.ACHIEVEMENT_TYPE.Map_Difficult) or 0
            --[[ 测试用
			max_difficulty = math.random(0,4)
			--]]
            print(string.format("current_difficult_select[%s] ; max_difficulty[%s]", current_difficulty_select3,
                max_difficulty))
            local ret
            -- if current_difficulty_select3 > max_difficulty then
            -- 首通奖励
            ret = hVar.MAP_INFO["world/yxys_ex_003"].DiffMode[current_difficulty_select3].starReward
            -- else
            --     -- 随机奖励
            --     ret = hVar.MAP_INFO["world/yxys_ex_003"].DiffMode[current_difficulty_select3].randReward
            -- end
            return ret
        end

        -- 更新奖励按钮列表
        local UpdateRewardIconBtnList = function(reward_config_list)
            ClearRewardIconBtnList()

            --[[ 测试用
			local tmp_reward_config_list = {
				{10,20105,0,0}, --装备
				{101,15002,5,0}, --枪
				{11,10,0}, --强化材料
			}
			reward_config_list = tmp_reward_config_list
			--]]

            local scale = 1.5
            for i, reward_config in ipairs(reward_config_list) do
                -- 奖励类型枚举
                local rewardTypeEnum = CheckRewardType(reward_config[1])
                --[[ 测试
				rewardTypeEnum = RewardType.Coin
				--]]
                local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w,
                    sub_pos_h = hApi.GetRewardParams(reward_config)
                print(tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w,
                    sub_pos_h)

                --[[ 测试
				tmpModel = "misc/skillup/keshi.png"
				itemNum = 50
				--]]

                local btnName = "rewardIconBtnParentNode_DBQB_" .. i
                _frmNode.childUI["rewardIconBtnParentNode_DBQB_" .. i] = hUI.button:new({
                    parent = _parentNode,
                    model = "misc/mask.png",
                    dragbox = _frm.childUI["dragBox"],
                    x = 154 + BILLBOARD_OFFSETX - 210 - 80 + (i - 1) * 115,
                    y = -720 + 94 + 190,
                    w = itemWidth * scale,
                    h = itemWidth * scale,
                    -- align = "LT",
                    scaleT = 0.95,
                    code = function()
                        -- print(btnName)
                        -- 显示各种类型的奖励的tip
                        hApi.ShowRewardTip(reward_config)
                    end
                })
                _frmNode.childUI["rewardIconBtnParentNode_DBQB_" .. i].handle.s:setOpacity(0)
                -- rightRemoveFrmList[#rightRemoveFrmList + 1] = "rewardTitle"
                table.insert(rightRemoveFrmList, btnName)
                rewardIconBtnList[#rewardIconBtnList + 1] = {
                    name = "rewardIconBtnParentNode_DBQB_" .. i,
                    btn = _frmNode.childUI["rewardIconBtnParentNode_DBQB_" .. i]
                }

                local _btnParent = _frmNode.childUI["rewardIconBtnParentNode_DBQB_" .. i]

                if tmpModel and #tmpModel > 0 then
                    -- 奖励图标
                    _btnParent.childUI["rewardIconBtnImage_DBQB_" .. i] = hUI.image:new({
                        parent = _btnParent.handle._n,
                        model = tmpModel,
                        x = 0,
                        y = 0,
                        w = itemWidth * scale,
                        h = itemHeight * scale
                    })

                    if rewardTypeEnum == RewardType.Debris then -- 奖励碎片
                        -- 碎片数量
                        _btnParent.childUI["rewardIconBtnText_DBQB_" .. i] = hUI.label:new({
                            parent = _btnParent.handle._n,
                            x = 14,
                            y = -65,
                            w = itemWidth * scale,
                            h = itemHeight * scale,
                            size = 22,
                            font = hVar.FONTC,
                            align = "MB",
                            width = 100,
                            border = 0,
                            text = "×" .. tostring(itemNum)
                        })

                        -- 碎片数量底图
                        local model_path = "misc/addition/"
                        if itemNum < 50 then
                            model_path = model_path .. "debris_bg_less.png"
                        else
                            model_path = model_path .. "debris_bg_more.png"
                        end
                        _btnParent.childUI["rewardIconBtnTextBgImage_DBQB_" .. i] = hUI.image:new({
                            parent = _btnParent.handle._n,
                            model = model_path,
                            x = 0,
                            y = -55,
                            scale = 1.1
                        })
                    elseif rewardTypeEnum == RewardType.Coin then -- 奖励游戏币
                        -- 游戏币数量

                        -- 绘制奖励的数量
                        local strRewardNum = "+" .. tostring(itemNum)

                        --[[
						--测试
						strRewardNum = "+0000"
						]]

                        local coinNumLength = #strRewardNum
                        local coinNumFont = "numWhite" -- 字体
                        local coinNumFontSize = 26 -- 字体大小
                        local coinNumBorder = 0 -- 是否显示边框
                        if (coinNumLength == 3) then
                            coinNumFont = "numWhite" -- 字体
                            coinNumFontSize = 24 -- 字体大小
                            coinNumBorder = 0 -- 是否显示边框
                        elseif (coinNumLength == 4) then
                            coinNumFont = "numWhite" -- 字体
                            coinNumFontSize = 22 -- 字体大小
                            coinNumBorder = 0 -- 是否显示边框
                        elseif (coinNumLength == 5) then
                            coinNumFont = "numWhite" -- 字体
                            coinNumFontSize = 20 -- 字体大小
                            coinNumBorder = 0 -- 是否显示边框
                        elseif (coinNumLength >= 6) then
                            coinNumFont = hVar.FONTC -- 字体
                            coinNumFontSize = 18 -- 字体大小
                            coinNumBorder = 1 -- 是否显示边框
                        end
                        _btnParent.childUI["rewardIconBtnText_DBQB_" .. i] = hUI.label:new({
                            parent = _btnParent.handle._n,
                            x = 0,
                            y = -65,
                            w = itemWidth * scale,
                            h = itemHeight * scale,
                            size = coinNumFontSize,
                            font = coinNumFont,
                            align = "MB",
                            width = 100,
                            border = coinNumBorder,
                            text = strRewardNum
                        })
                    end
                end

                -- 子节点
                if sub_tmpModel and #sub_tmpModel > 0 then
                    if rewardTypeEnum == RewardType.Prop then -- 奖励道具
                        _btnParent.childUI["rewardIconBtnSubImage_DBQB_" .. i] = hUI.image:new({
                            parent = _btnParent.handle._n,
                            model = sub_tmpModel,
                            x = sub_pos_x * scale,
                            y = sub_pos_y * scale,
                            w = sub_pos_w * scale,
                            h = sub_pos_h * scale
                        })
                    end
                end
            end
        end

        -- 更新奖励信息
        local UpdateRewardInfo = function()
            -- UpdateRewardTitleLabel()
            local reward_config_list = GetRewardListByCurrentDifficulty()
            UpdateRewardIconBtnList(reward_config_list)
        end

        UpdateRewardInfo()
        -- * ==========================================================================================================

        -- 夺宝奇兵的四个难度
        for diff = 1, 4, 1 do
            _frmNode.childUI["labCombatDiff_" .. diff] = hUI.button:new(
                { -- 只挂载子控件，不显示
                    parent = _parentNode,
                    x = 78 + BILLBOARD_OFFSETX - 220 + (diff - 1) * 104,
                    y = -600,
                    z = 3,
                    model = "misc/chest/pvp_panel_diff" .. diff .. ".png",
                    dragbox = _frm.childUI["dragBox"],
                    w = 75,
                    h = 137,
                    align = "MC",
                    scaleT = 0.95,
                    code = function()
                        -- 挑战难度限制
                        local max_difficulty =
                            LuaGetPlayerMapAchi("world/yxys_ex_003", hVar.ACHIEVEMENT_TYPE.Map_Difficult) or 0
                        if diff > max_difficulty + 1 then
                            local strText = string.format("请先完成[%s]难度的挑战！",
                                DBQB_DIFFICULTY_NAME[max_difficulty + 1])
                            hUI.floatNumber:new({
                                x = hVar.SCREEN.w / 2,
                                y = hVar.SCREEN.h / 2,
                                align = "MC",
                                text = "",
                                lifetime = 2000,
                                fadeout = -550,
                                moveY = 32
                            }):addtext(strText, hVar.FONTC, 32, "MC", 0, 0, nil, 1)
                            return
                        end

                        -- 存储难度
                        current_difficulty_select3 = diff

                        -- 选中框位置调整
                        _frmNode.childUI["labCombatDiff_Selectbox"]:setXY(
                            78 + BILLBOARD_OFFSETX - 220 + (current_difficulty_select3 - 1) * 104, -600)

                        -- print("labCombatDiff_" .. diff)
                        -- 更新奖励信息
                        UpdateRewardInfo()
                    end
                })
            rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatDiff_" .. diff
        end

        -- 选中框
        _frmNode.childUI["labCombatDiff_Selectbox"] = hUI.image:new(
            { -- 只挂载子控件，不显示
                parent = _parentNode,
                x = 78 + BILLBOARD_OFFSETX - 220 + (current_difficulty_select3 - 1) * 104,
                y = -600,
                z = 3,
                model = "misc/chest/pvp_panel_diff_selected.png",
                dragbox = _frm.childUI["dragBox"],
                w = 81,
                h = 143,
                align = "MC"
            })
        rightRemoveFrmList[#rightRemoveFrmList + 1] = "labCombatDiff_Selectbox"

        -- 开始按钮
        _frmNode.childUI["BeginBtn"] = hUI.button:new({
            parent = _parentNode,
            x = 720 - 170 + BILLBOARD_OFFSETX - 210,
            y = -720 + 74,
            -- model = "misc/chest/dragon_start_game.png",
            model = "misc/mask.png",
            dragbox = _frm.childUI["dragBox"],
            -- label = {text = "START", size = 34, font = hVar.FONTC, border = 1, x = 0, y = 3, RGB = {52, 79, 62,},},
            w = 164,
            h = 85,
            align = "MC",
            scaleT = 0.95,
            code = function()
                -- 检测gameserver版本号是否为最新
                if (not hApi.CheckGameServerVersionControl()) then
                    return
                end

                -- 挡操作
                hUI.NetDisable(30000)

                -- 发起请求，挑战娱乐地图（夺宝奇兵）
                local MapDifficulty = current_difficulty_select3
                SendCmdFunc["require_battle_entertament"](hVar.DuoBaoQiBingMap, MapDifficulty)
            end
        })
        _frmNode.childUI["BeginBtn"].handle.s:setOpacity(0) -- 只挂载子控件，不显示
        rightRemoveFrmList[#rightRemoveFrmList + 1] = "BeginBtn"
        -- 开始按钮动画图片
        _frmNode.childUI["BeginBtn"].childUI["icon"] = hUI.image:new({
            parent = _frmNode.childUI["BeginBtn"].handle._n,
            x = 0,
            y = 0,
            model = "MODEL_EFFECT:StartAmin2",
            scale = 1
        })
        -- 按钮动画
        _frmNode.childUI["BeginBtn"].childUI["icon"] = hUI.image:new({
            parent = _frmNode.childUI["BeginBtn"].handle._n,
            model = "MODEL_EFFECT:StartAmin2",
            x = 0,
            y = 0,
            scale = 1.0
        })
        -- 消耗的体力图标
        _frmNode.childUI["BeginBtn"].childUI["tiliIcon"] = hUI.image:new({
            parent = _frmNode.childUI["BeginBtn"].handle._n,
            model = "misc/task/tili.png",
            x = 80,
            y = -8,
            scale = 0.9
        })
        -- 消耗的体力值
        _frmNode.childUI["BeginBtn"].childUI["tiliCost"] = hUI.label:new({
            parent = _frmNode.childUI["BeginBtn"].handle._n,
            x = 80 + 20,
            y = -8 - 1,
            font = "numWhite",
            align = "LC",
            text = "1",
            border = 0,
            size = 24
        })
        _frmNode.childUI["BeginBtn"].childUI["tiliCost"].handle.s:setColor(ccc3(0, 255, 0))

        -- 添加事件监听：商城信息返回
        -- hGlobal.event:listen("localEvent_refresh_shopinfo", "__OnReceiveShopItemRet", on_receive_shop_iteminfo_back_event)
        -- 添加事件监听：收到请求挑战娱乐地图结果返回
        hGlobal.event:listen("LocalEvent_RequireEntertamentNormalRet", "__RequireEntertamentNormalRet",
            on_receive_require_battle_entertament_ret)
        -- 添加事件监听：横竖屏切换
        hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenEntertamentNormal_", on_spine_screen_event)

        -- 只有在本分页才会有的timer
        -- hApi.addTimerForever("__SHOP_TIMER_PAGE_BUYITEM__", hVar.TIMER_MODE.GAMETIME, 1000, on_refresh_shop_buyitem_lefttime_timer)
    end

    -- 收到排行榜静态数据模板的回调（第1个、第2个分页）
    on_receive_billboardT_event = function(bId, billboardT)
        local _frm = hGlobal.UI.PhoneBlackDragonTalkFrm_New
        local _frmNode = _frm.childUI["PageNode"]
        local _parentNode = _frmNode.handle._n

        -- 取消挡操作
        hUI.NetDisable(0)

        local pageIndex = CurrentSelectRecord.pageIdx

        -- 只处理本分页的
        if (current_bId == bId) then
            -- 存储
            current_billboardT = billboardT

            -- 测试 --test
            --[[
			billboardT.info[bId].prize.lv_tower = 2
			billboardT.info[bId].prize.lv_tactic = 3
			billboardT.info[bId].prize.ban_hero = {18001,18003,18002,}
			billboardT.info[bId].prize.ban_tower = {1018, 1019,}
			billboardT.info[bId].prize.ban_tactic = {1039, 1040,}
			billboardT.info[bId].prize.diff_tactic = {{1201, 4,}, {1205, 2,},}
			]]

            -- 读取数据部分
            -- 塔的最高等级
            local lv_tower = billboardT.info[bId].prize.lv_tower

            -- 战术卡的最高等级
            local lv_tactic = billboardT.info[bId].prize.lv_tactic

            -- 禁用的英雄
            local ban_hero = billboardT.info[bId].prize.ban_hero

            -- 禁用的塔
            local ban_tower = billboardT.info[bId].prize.ban_tower

            -- 禁用的战术卡
            local ban_tactic = billboardT.info[bId].prize.ban_tactic

            -- 敌人增益buff
            local diff_tactic = billboardT.info[bId].prize.diff_tactic

            -- 绘制本次的敌人增益buff 1
            if (diff_tactic) and (#diff_tactic > 0) then
                -- 有禁用的敌人增益buff
                for idx = 1, #diff_tactic, 1 do
                    local tacticId = diff_tactic[idx] and diff_tactic[idx][1] or 0
                    local tacticLv = diff_tactic[idx] and diff_tactic[idx][2] or 1
                    print("diff_tactic", idx, tacticId, tacticLv)

                    -- 将本周的buff高亮选中
                    hApi.safeRemoveT(_frmNode.childUI["labCombatCover"].childUI, "selebtbox")
                    local offsetX = current_diffBuffOffset[tacticId].offsetX
                    local offsetY = current_diffBuffOffset[tacticId].offsetY
                    _frmNode.childUI["labCombatCover"].childUI["selebtbox"] = hUI.image:new({
                        parent = _frmNode.childUI["labCombatCover"].handle._n,
                        x = offsetX,
                        y = offsetY,
                        model = "misc/chariotconfig/tough_learned_06.png",
                        align = "MC",
                        scale = 1.0
                    })
                    -- current_diffBuffOffset
                end
            end
        end
    end

    -- 函数：点击排行榜按钮
    OnClickRankButton = function()
        local _frm = hGlobal.UI.PhoneBlackDragonTalkFrm_New
        local _frmNode = _frm.childUI["PageNode"]
        local _parentNode = _frmNode.handle._n

        -- 关闭本界面
        OnClosePanel()

        -- 由关闭按钮触发的关闭，不能再次打开
        _bCanCreate = false

        local bId = current_bId
        local callback = function()
            -- 触发事件，显示随机迷宫界面
            local bOpenImmediate = true
            hGlobal.event:event("LocalEvent_Phone_ShowBlackDragonTalkFrm", CurrentSelectRecord.pageIdx,
                current_funcCallback, bOpenImmediate)
        end
        hGlobal.event:event("LocalEvent_Phone_ShowRandomMapRankInfoFrm", bId, callback)
    end

    -- 函数：收到请求挑战娱乐地图事件返回
    on_receive_require_battle_entertament_ret = function(result, pvpcoin, mapName, mapDiff, battlecfg_id)
        local _frm = hGlobal.UI.PhoneBlackDragonTalkFrm_New
        local _frmNode = _frm.childUI["PageNode"]
        local _parentNode = _frmNode.handle._n

        -- print("on_receive_require_battle_entertament_ret", result, pvpcoin, mapName, mapDiff, battlecfg_id)

        -- 操作成功
        if (result == 1) then
            if (mapName ~= hVar.RandomMap) then -- 不是随机迷宫地图
                -- 关闭本界面
                OnClosePanel()

                -- 母巢之战、前哨阵地、夺宝奇兵
                local banLimitTable = {
                    battlecfg_id = battlecfg_id
                }

                if (mapName == hVar.MuChaoZhiZhanMap) then -- 母巢之战地图
                    local tomap = mapName
                    local tMap = hVar.MAP_INFO[mapName]
                    local DiffMode = tMap.DiffMode or {}
                    local diffMapName = DiffMode[mapDiff].diffMapName
                    local diffTactic = DiffMode[mapDiff].diffTactic

                    if (diffMapName ~= nil) then
                        tomap = diffMapName
                        banLimitTable.mapName = mapName
                    end
                    banLimitTable.diff_tactic = diffTactic

                    -- 如果是vip5，带入一张雕像道具卡
                    local vipLv = LuaGetPlayerVipLv()
                    local itemId = 12029
                    local itemLv = 1
                    local itemNum = hVar.Vip_Conifg.ironmanItemSkillNum[vipLv] or 0
                    if (itemNum > 0) then
                        banLimitTable.ironman = {
                            itemId = itemId,
                            itemLv = itemLv,
                            itemNum = itemNum
                        }
                        -- print("如果是vip5，带入一张雕像道具卡", itemNum)
                    end

                    -- 加载地图
                    GameManager.StartTest(nil, tomap, mapDiff, banLimitTable)
                elseif (mapName == hVar.QianShaoZhenDiMap) then -- 前哨阵地地图
                    if current_billboardT then
                        local bId = current_bId
                        banLimitTable.diff_tactic = current_billboardT.info[bId].prize.diff_tactic
                    end

                    -- 如果是vip5，带入一张雕像道具卡
                    local vipLv = LuaGetPlayerVipLv()
                    local itemId = 12029
                    local itemLv = 1
                    local itemNum = hVar.Vip_Conifg.ironmanItemSkillNum[vipLv] or 0
                    if (itemNum > 0) then
                        banLimitTable.ironman = {
                            itemId = itemId,
                            itemLv = itemLv,
                            itemNum = itemNum
                        }
                        -- print("如果是vip5，带入一张雕像道具卡", itemNum)
                    end

                    -- 加载地图
                    GameManager.StartTest(nil, mapName, mapDiff, banLimitTable)
                elseif (mapName == hVar.DuoBaoQiBingMap) then -- 夺宝奇兵地图
                    local tomap = mapName
                    local tMap = hVar.MAP_INFO[mapName]
                    local DiffMode = tMap.DiffMode or {}
                    local diffMapName = DiffMode[mapDiff].diffMapName
                    local diffTactic = DiffMode[mapDiff].diffTactic

                    if (diffMapName ~= nil) then
                        tomap = diffMapName
                        banLimitTable.mapName = mapName
                    end
                    banLimitTable.diff_tactic = diffTactic

                    -- 如果是vip5，带入一张雕像道具卡
                    local vipLv = LuaGetPlayerVipLv()
                    local itemId = 12029
                    local itemLv = 1
                    local itemNum = hVar.Vip_Conifg.ironmanItemSkillNum[vipLv] or 0
                    if (itemNum > 0) then
                        banLimitTable.ironman = {
                            itemId = itemId,
                            itemLv = itemLv,
                            itemNum = itemNum
                        }
                        -- print("如果是vip5，带入一张雕像道具卡", itemNum)
                    end

                    -- 加载地图
                    GameManager.StartTest(nil, tomap, mapDiff, banLimitTable)
                end
            end
        end
    end

    -- 函数：横竖屏切换
    on_spine_screen_event = function()
        local _frm = hGlobal.UI.PhoneBlackDragonTalkFrm_New
        local _frmNode = _frm.childUI["PageNode"]
        local _parentNode = _frmNode.handle._n

        -- 关闭本界面
        OnClosePanel()

        -- 重绘本界面
        hGlobal.UI.InitBlackDragonTalkFrm("reload") -- 测试
        -- 触发事件，显示黑龙对话界面
        hGlobal.event:event("LocalEvent_Phone_ShowBlackDragonTalkFrm", CurrentSelectRecord.pageIdx, current_funcCallback)
    end

    -- 函数: 动态加载资源
    __DynamicAddRes = function(pageIdx)
        local _frm = hGlobal.UI.PhoneBlackDragonTalkFrm_New
        local _parent = _frm.handle._n
        local _childUI = _frm.childUI

        -- 加载资源
        if (pageIdx == 1) then -- 分页1：母巢之战
            -- 动态加载宝物背景图
            local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/chest/brood_panel.png")
            if (not texture) then
                texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/chest/brood_panel.png")
                print("加载母巢之战背景大图！")
            end
            -- print(tostring(texture))
            local tSize = texture:getContentSize()
            local pSprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
            pSprite:setPosition(-tSize.width / 2 + 10, -tSize.height / 2)
            pSprite:setAnchorPoint(ccp(0.5, 0.5))
            -- pSprite:setScaleX((hVar.SCREEN.w - iPhoneX_WIDTH * 2) / tSize.width)
            -- pSprite:setScaleY(hVar.SCREEN.h / tSize.height)
            _childUI["panel_bg"].data.pSprite = pSprite
            _childUI["panel_bg"].handle._n:addChild(pSprite)
        elseif (pageIdx == 2) then -- 分页2：前哨阵地
            -- 动态加载宝物背景图
            local texture = CCTextureCache:sharedTextureCache():textureForKey(
                "data/image/misc/chest/outpost_panel_2.png")
            if (not texture) then
                texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/chest/outpost_panel_2.png")
                print("加载前哨阵地背景大图！")
            end
            -- print(tostring(texture))
            local tSize = texture:getContentSize()
            local pSprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
            pSprite:setPosition(-tSize.width / 2 + 10, -tSize.height / 2)
            pSprite:setAnchorPoint(ccp(0.5, 0.5))
            -- pSprite:setScaleX((hVar.SCREEN.w - iPhoneX_WIDTH * 2) / tSize.width)
            -- pSprite:setScaleY(hVar.SCREEN.h / tSize.height)
            _childUI["panel_bg"].data.pSprite = pSprite
            _childUI["panel_bg"].handle._n:addChild(pSprite)
        elseif (pageIdx == 3) then -- 分页3：夺宝奇兵
            -- 动态加载宝物背景图
            local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/chest/pvp_panel_3.png")
            if (not texture) then
                texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/chest/pvp_panel_3.png")
                print("加载前哨阵地背景大图！")
            end
            -- print(tostring(texture))
            local tSize = texture:getContentSize()
            local pSprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
            pSprite:setPosition(-tSize.width / 2 + 10, -tSize.height / 2)
            pSprite:setAnchorPoint(ccp(0.5, 0.5))
            -- pSprite:setScaleX((hVar.SCREEN.w - iPhoneX_WIDTH * 2) / tSize.width)
            -- pSprite:setScaleY(hVar.SCREEN.h / tSize.height)
            _childUI["panel_bg"].data.pSprite = pSprite
            _childUI["panel_bg"].handle._n:addChild(pSprite)
        end
    end

    -- 函数: 动态删除资源
    __DynamicRemoveRes = function()
        local _frm = hGlobal.UI.PhoneBlackDragonTalkFrm_New
        local _parent = _frm.handle._n
        local _childUI = _frm.childUI

        -- 删除资源
        -- 删除竞技场背景图
        _childUI["panel_bg"].handle._n:removeChild(_childUI["panel_bg"].data.pSprite, true)

        -- 删除母巢之战背景图
        local texture1 = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/chest/brood_panel.png")
        if texture1 then
            CCTextureCache:sharedTextureCache():removeTexture(texture1)
            print("清空母巢之战背景大图！")
        end

        -- 删除前哨阵地背景图
        local texture2 = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/chest/outpost_panel_2.png")
        if texture2 then
            CCTextureCache:sharedTextureCache():removeTexture(texture2)
            print("清空前哨阵地背景大图！")
        end

        -- 删除前夺宝奇兵背景图
        local texture3 = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/chest/pvp_panel_3.png")
        if texture3 then
            CCTextureCache:sharedTextureCache():removeTexture(texture3)
            print("清空夺宝奇兵背景大图！")
        end
    end

    -- 函数：关闭本界面
    OnClosePanel = function()
        -- 触发事件：刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
        hGlobal.event:event("LocalEvent_RefreshMedalStateUI")

        hGlobal.event:event("LocalEvent_ClearTacticstip")

        -- 不显示任务操作面板
        hGlobal.UI.PhoneBlackDragonTalkFrm_New:show(0)

        -- 商店是否需要查询（仅每次第一次打开才需要发起查询）
        current_shop_query_flag = 0

        -- 关闭界面后不需要监听的事件
        -- 取消监听：收到网络宝箱数量的事件
        -- hGlobal.event:listen("LocalEvent_getNetChestNum", "__ItemGetChestNum_Frm", nil)

        -- 清空切换分页之后取消的监听事件
        -- 移除事件监听：收到新商店抽奖信息结果回调
        -- hGlobal.event:listen("localEvent_ShopChouJiangInfo_Ret", "__OnReceiveShopChouJiangInfo", nil)
        -- 移除事件监听：收到排行榜静态数据模板的回调
        hGlobal.event:listen("localEvent_refresh_billboardT", "__QueryComBatEvaluationBoardT", nil)
        -- 移除事件监听：收到请求挑战娱乐地图结果返回
        hGlobal.event:listen("LocalEvent_RequireEntertamentNormalRet", "__RequireEntertamentNormalRet", nil)
        -- 移除事件监听：横竖屏切换
        hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenEntertamentNormal_", nil)

        -- 动态删除宝物背景大图
        __DynamicRemoveRes()

        -- 清空上次分页的全部信息
        _removeLeftFrmFunc()
        _removeRightFrmFunc()

        -- 移除timer
        -- hApi.clearTimer("__SHOP_TIMER_PAGE_OPENCHEST__")
        -- hApi.clearTimer("__SHOP_TIMER_PAGE_BUYITEM__")
        -- hApi.clearTimer("__SHOP_TIMER_PAGE_ADVVIEW__")

        -- 清除资源缓存
        -- local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
        -- cache:removeSpriteFramesFromFile("data/image/ui.plist")

        -- 关闭金币、积分界面
        -- hGlobal.event:event("LocalEvent_CloseGameCoinFrm")

        -- 检测临时背包是否显示
        hGlobal.event:event("LocalEvent_setGiftBtnState")

        -- 触发事件：关闭了主菜单按钮
        -- hGlobal.event:event("LocalEvent_MainMenuSubFrmClose")

        -- 允许再次打开
        _bCanCreate = true
    end
end

-- 监听打开新商店界面事件
hGlobal.event:listen("LocalEvent_Phone_ShowBlackDragonTalkFrm", "__ShowBlackDragonTalkFrm",
    function(index, callback, bOpenImmediate)
        -- print("LocalEvent_Phone_ShowBlackDragonTalkFrm", index, callback, bOpenImmediate)
        hGlobal.UI.InitBlackDragonTalkFrm("reload")

        -- 直接打开
        if bOpenImmediate then
            -- 触发事件，显示积分、金币界面
            -- hGlobal.event:event("LocalEvent_ShowGameCoinFrm")

            -- 显示道具界面
            hGlobal.UI.PhoneBlackDragonTalkFrm_New:show(1)
            hGlobal.UI.PhoneBlackDragonTalkFrm_New:active()

            --[[
		--连接pvp服务器
		if (Pvp_Server:GetState() ~= 1) then --未连接
			Pvp_Server:Connect()
		elseif (not hGlobal.LocalPlayer:getonline()) then --不重复登陆
			Pvp_Server:UserLogin()
		end
		]]

            -- 打开上一次的分页（默认显示第1个分页: 商城抽奖）
            local lastPageIdx = index or CurrentSelectRecord.pageIdx
            if (lastPageIdx == 0) then
                lastPageIdx = 1
            end

            CurrentSelectRecord.pageIdx = 0
            CurrentSelectRecord.contentIdx = 0
            OnClickPageBtn(lastPageIdx)

            -- 存储回调事件
            current_funcCallback = callback

            -- 防止重复调用
            _bCanCreate = false

            return
        end

        -- 防止重复调用
        if _bCanCreate then
            _bCanCreate = false

            -- 步骤1: 绘制第一个分页，并将控件设置成初始位置（屏幕外，为步骤二播放动画做准备）
            local actM1 = CCCallFunc:create(function()
                -- 触发事件，显示积分、金币界面
                -- hGlobal.event:event("LocalEvent_ShowGameCoinFrm")

                -- 显示道具界面
                hGlobal.UI.PhoneBlackDragonTalkFrm_New:show(1)
                hGlobal.UI.PhoneBlackDragonTalkFrm_New:active()

                --[[
			--连接pvp服务器
			if (Pvp_Server:GetState() ~= 1) then --未连接
				Pvp_Server:Connect()
			elseif (not hGlobal.LocalPlayer:getonline()) then --不重复登陆
				Pvp_Server:UserLogin()
			end
			]]

                -- 打开上一次的分页（默认显示第1个分页: 商城抽奖）
                local lastPageIdx = index or CurrentSelectRecord.pageIdx
                if (lastPageIdx == 0) then
                    lastPageIdx = 1
                end

                CurrentSelectRecord.pageIdx = 0
                CurrentSelectRecord.contentIdx = 0
                OnClickPageBtn(lastPageIdx)

                -- 存储回调事件
                current_funcCallback = callback

                -- 初始设置坐标
                -- 主面板设置到左侧屏幕外面
                local _frm = hGlobal.UI.PhoneBlackDragonTalkFrm_New
                local dx = BOARD_WIDTH
                _frm:setXY(_frm.data.x + dx, _frm.data.y)
            end)

            -- 步骤2: 动画进入控件
            local actM2 = CCCallFunc:create(function()
                -- 本面板
                local _frm = hGlobal.UI.PhoneBlackDragonTalkFrm_New

                -- 往左做运动
                local px, py = _frm.data.x, _frm.data.y
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
            aM:addObject(actM1)
            aM:addObject(actM2)
            local sequence = CCSequence:create(aM)
            local _frm = hGlobal.UI.PhoneBlackDragonTalkFrm_New
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
hGlobal.event:listen("LocalEvent_Phone_HideBlackDragonTalkFrm", "__CloseDragonTalkFrm", function()
    if hGlobal.UI.PhoneBlackDragonTalkFrm_New then
        if (hGlobal.UI.PhoneBlackDragonTalkFrm_New.data.show == 1) then
            -- 关闭本界面
            OnClosePanel()
            -- print("LocalEvent_Phone_HideBlackDragonTalkFrm",0)
        end

        -- 允许再次打开
        _bCanCreate = true
    end
end)

-- test
--[[
--测试代码
if hGlobal.UI.PhoneBlackDragonTalkFrm_New then --黑龙对话面板
	hGlobal.UI.PhoneBlackDragonTalkFrm_New:del()
	hGlobal.UI.PhoneBlackDragonTalkFrm_New = nil
end
hGlobal.UI.InitBlackDragonTalkFrm("reload") --测试
--触发事件，显示黑龙对话界面
hGlobal.event:event("LocalEvent_Phone_ShowBlackDragonTalkFrm", 1)
--]]
