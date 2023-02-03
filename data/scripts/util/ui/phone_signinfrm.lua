

local BOARD_WIDTH = 720 --签到礼包面板的宽度
local BOARD_HEIGHT = 720 --签到礼包面板的高度
local BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 0
local BOARD_OFFSETY = 0 --签到礼包面板y偏移中心点的值
local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --签到礼包面板的x位置（最左侧）
local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --签到礼包面板的y位置（最顶侧）

--横屏模式
if (hVar.SCREEN_MODE == hVar.SCREEN_MODE_DEFINE.HORIZONTAL) then
	BOARD_WIDTH = 720 --DLC地图面板面板的宽度
	BOARD_HEIGHT = 720 --DLC地图面板面板的高度
	BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 20
	BOARD_OFFSETY = 0 --DLC地图面板面板y偏移中心点的值
	BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --DLC地图面板面板的x位置（最左侧）
	BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --DLC地图面板面板的y位置（最顶侧）
end

local PAGE_BTN_LEFT_X = 290 --第一个分页按钮的x偏移
local PAGE_BTN_LEFT_Y = -21 --第一个分页按钮的x偏移
local PAGE_BTN_OFFSET_X = 140 --每个分页按钮的间距
local SIGNIN_X_NUM = 7 --活动x的数量
local SIGNIN_Y_NUM = 4 --活动y的数量

local _bCanCreate = true --防止重复创建
local current_funcCallback = nil --关闭后的回调事件

--临时UI管理
local leftRemoveFrmList = {} --左侧控件集
local rightRemoveFrmList = {} --右侧控件集
local _removeLeftFrmFunc = hApi.DoNothing --清空左侧所有的临时控件
local _removeRightFrmFunc = hApi.DoNothing --清空右侧所有的临时控件
local OnClosePanel = hApi.DoNothing --关闭界面

--局部函数
local OnClickPageBtn = hApi.DoNothing --点击分页按钮
local RefreshSelectedCardFrame = hApi.DoNothing --更新绘制当前查看的卡牌的信息

--分页1：显示签到礼包界面
local OnCreatePurchaseGiftInfoFrame = hApi.DoNothing --创建签到礼包界面（第1个分页）
local on_receive_activity_info_event = hApi.DoNothing --收到获得活动信息的回调
local on_receive_activity_progress_event = hApi.DoNothing --收到活动进度的回调
local on_receive_activity_today_state_event = hApi.DoNothing --收到获得新玩家14日签到活动今日是否可领奖的回调
local on_receive_activity_signin_result_event = hApi.DoNothing --收到获得新玩家14日签到活动今日签到结果回调
local on_receive_activity_signin_buygift_result_event = hApi.DoNothing --收到获得新玩家14日签到活动购买特惠礼包结果回调
local on_spine_screen_event = hApi.DoNothing --横竖屏切换
local __DynamicAddRes = hApi.DoNothing --动态加载资源
local __DynamicRemoveRes = hApi.DoNothing --动态删除资源
local on_ckick_signin_day_button = hApi.DoNothing --点击签到天数按钮的逻辑
local RefreshTaskAchievementFinishPage = hApi.DoNothing --更新提示当前哪个分页可以有领取的了

--分页1：签到礼包的参数
local LIMITTIMEGIFT_OFFSET_X = BOARD_WIDTH / 2 --签到礼包统一偏移x
local LIMITTIMEGIFT_OFFSET_Y = -6 --签到礼包统一偏移y

local current_tActivity = nil --新玩家任意充值活动信息表

--当前选中的记录
local CurrentSelectRecord = {pageIdx = 0, contentIdx = 0, cardId = 0,} --当前选择的分页、数据项的信息记录



--弹出签到礼包界面
hGlobal.UI.InitSignInFrm = function(mode)
	local tInitEventName = {"LocalEvent_Phone_ShowSignInFrm", "ShowSignInFrm"}
	if (mode ~= "reload") then
		--return tInitEventName
		return
	end
	
	--不重复创建签到礼包
	if hGlobal.UI.SignInFrm then --签到礼包面板
		hGlobal.UI.SignInFrm:del()
		hGlobal.UI.SignInFrm = nil
	end
	
	--[[
	--取消监听打开签到礼包界面通知事件
	hGlobal.event:listen("LocalEvent_Phone_ShowSignInFrm", "ShowSignInFrm", nil)
	--取消监听关闭宝箱界面事件
	hGlobal.event:listen("clearPhoneChestFrm", "__CloseSignInFrm", nil)
	]]
	
	BOARD_WIDTH = 720 --签到礼包面板的宽度
	BOARD_HEIGHT = 720 --签到礼包面板的高度
	BOARD_OFFSETX = (hVar.SCREEN.w - BOARD_WIDTH) / 2 - 0
	BOARD_OFFSETY = 0 --签到礼包面板y偏移中心点的值
	BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 + BOARD_OFFSETX --签到礼包面板的x位置（最左侧）
	BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --签到礼包面板的y位置（最顶侧）
	
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
	--hApi.clearTimer("__LIMITTIMEGIFT_TIMER_UPDATE__")
	
	--创建签到礼包面板
	hGlobal.UI.SignInFrm = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 2,
		show = 0, --一开始不显示
		--border = "UI:TileFrmPVP", --显示frame边框
		--background = "panel/panel_part_00.png", --"UI:Tactic_Background",
		border = 0,
		background = 0,
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
	
	local _frm = hGlobal.UI.SignInFrm
	local _parent = _frm.handle._n
	
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
		x = _frm.data.w + closeDx + 1000, --屏幕外
		y = closeDy,
		scaleT = 0.95,
		code = function()
			--关闭界面
			OnClosePanel()
			
			--触发事件：刷新点将台、战术卡、成就任务活动、竞技场锦囊、商城今日刷新商品、评价，等叹号提示
			hGlobal.event:event("LocalEvent_RefreshMedalStateUI")
			
			hGlobal.event:event("LocalEvent_RecoverBarrage")
			
			--释放png, plist的纹理缓存（这里不清理也可以）
			--hApi.ReleasePngTextureCache()
			
			--回收lua内存
			--collectgarbage()
			_bCanCreate = false
			
			--回调事件
			if (type(current_funcCallback) == "function") then
				current_funcCallback()
			end
		end,
	})
	
	--每个分页按钮
	--推广
	local tPageIcons = {"UI:ach_king",}
	--local tTexts = {"游戏",} --language
	local tTexts = {"",} --language
	for i = 1, #tPageIcons, 1 do
		--分页按钮
		_frm.childUI["PageBtn" .. i] = hUI.button:new({
			parent = _parent,
			model = "misc/mask.png",
			x = PAGE_BTN_LEFT_X + (i - 1) * PAGE_BTN_OFFSET_X - 175,
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
		
		--分页按钮的文字
		_frm.childUI["PageBtn" .. i].childUI["Text"] = hUI.label:new({
			parent = _frm.childUI["PageBtn" .. i].handle._n,
			x = 10,
			y = 0,
			size = 28,
			align = "MC",
			border = 1,
			font = hVar.FONTC,
			width = 300,
			text = tTexts[i],
		})
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
		local _frm = hGlobal.UI.SignInFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function(pageIndex)
		local _frm = hGlobal.UI.SignInFrm
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#rightRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, rightRemoveFrmList[i]) 
		end
		rightRemoveFrmList = {}
	end
	
	--函数：关闭本界面
	OnClosePanel = function()
		local _frm = hGlobal.UI.SignInFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--触发事件，关闭金币、积分界面
		--hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
		
		--不显示签到礼包面板
		hGlobal.UI.SignInFrm:show(0)
		
		--清除数据
		current_tActivity = nil
		--动态删除宝物背景大图
		__DynamicRemoveRes()
		
		--清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--清空切换分页之后取消的监听事件
		--移除事件监听：收到活动信息回调
		hGlobal.event:listen("localEvent_UpdateActivityInfo", "__OnReceiveActivityInfo_Purchase", nil)
		--移除事件监听：收到活动进度事件
		hGlobal.event:listen("localEvent_UpdateActivityReward", "_UpdateActivityReward", nil)
		--移除事件监听：收到新玩家14日签到活动今日是否可签到的事件
		hGlobal.event:listen("localEvent_activity_today_state", "_UpdateActivityState", nil)
		--移除事件监听：收到今日签到结果返回事件
		hGlobal.event:listen("localEvent_activity_today_signin", "_ActivitySignIn", nil)
		--移除事件监听：收到新玩家14日签到活动购买特惠礼包结果返回事件
		hGlobal.event:listen("localEvent_activity_signin_buygift", "_ActivitySignInBuyGift",  nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenSignIn_", nil)
		
		--移除timer
		--hApi.clearTimer("__LIMITTIMEGIFT_TIMER_UPDATE__")
		
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
			_frm.childUI["PageBtn" .. i].childUI["Text"].handle.s:setVisible(true) --显示文字
		end
		
		--先清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--清空切换分页之后取消的监听事件
		--移除事件监听：收到活动信息回调
		hGlobal.event:listen("localEvent_UpdateActivityInfo", "__OnReceiveActivityInfo_Purchase", nil)
		--移除事件监听：收到活动进度事件
		hGlobal.event:listen("localEvent_UpdateActivityReward", "_UpdateActivityReward", nil)
		--移除事件监听：收到新玩家14日签到活动今日是否可签到的事件
		hGlobal.event:listen("localEvent_activity_today_state", "_UpdateActivityState", nil)
		--移除事件监听：收到今日签到结果返回事件
		hGlobal.event:listen("localEvent_activity_today_signin", "_ActivitySignIn", nil)
		--移除事件监听：收到新玩家14日签到活动购买特惠礼包结果返回事件
		hGlobal.event:listen("localEvent_activity_signin_buygift", "_ActivitySignInBuyGift",  nil)
		--移除事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenSignIn_", nil)
		
		--移除timer
		--hApi.clearTimer("__LIMITTIMEGIFT_TIMER_UPDATE__")
		
		--新建该分页下的全部信息
		if (pageIndex == 1) then --分页1：签到礼包
			--创建签到礼包分页
			OnCreatePurchaseGiftInfoFrame(pageIndex)
		end
		
		--标记当前选择的分页和页内的第几个
		CurrentSelectRecord.pageIdx = pageIndex
		CurrentSelectRecord.contentIdx = 1 --默认选中第一个
	end
	
	--函数：创建签到礼包界面（第1个分页）
	OnCreatePurchaseGiftInfoFrame = function(pageIdx)
		local _frm = hGlobal.UI.SignInFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--初始化数据
		current_tActivity = nil
		
		--动态加载任务背景大图
		__DynamicAddRes()
		
		--[[
		--中央标题底板
		_frmNode.childUI["ImageTitleBG"] = hUI.image:new({
			parent = _parentNode,
			x = LIMITTIMEGIFT_OFFSET_X,
			y = LIMITTIMEGIFT_OFFSET_Y,
			model = "misc/chest/get_new_hero_bar.png",
			align = "MC",
			w = 395,
			h = 73,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ImageTitleBG"
		
		--中央标题文字
		_frmNode.childUI["ImageTitleLabel"] = hUI.label:new({
			parent = _parentNode,
			x = 480,
			y = LIMITTIMEGIFT_OFFSET_Y + 9,
			width = 500,
			size = 26,
			align = "MC",
			text = "", --" 新人首充送豪礼",
			font = hVar.FONTC,
			RGB = {255, 255, 0,},
			border = 1,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "ImageTitleLabel"
		]]
		
		--[[
		local _offX = 0
		local _offY = -14
		--黄月英立绘(新用户任意充值活动)
		_frmNode.childUI["signupBG"] = hUI.button:new({ --作为按钮只是为了挂载子控件
			parent = _parentNode,
			x = LIMITTIMEGIFT_OFFSET_X - 314 + _offX,
			y = LIMITTIMEGIFT_OFFSET_Y - 142 + _offY,
			model = "icon/portrait/hero_huangyueying2.png",
			--model = "misc/asset_l.png",
			scale = 0.56,
		})
		--_frmNode.childUI["signupBG"].handle.s:setFlipX(true)
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "signupBG"
		]]
		
		--[[
		--绘制最外框(新用户任意充值活动)
		local pg_offX = 314
		local pg_offY = -162
		local pg_width = 820
		local pg_height = 142
		hApi.CCScale9SpriteCreate("data/image/misc/chest/bg_ng_attr.png", pg_offX, pg_offY, pg_width, pg_height, _frmNode.childUI["signupBG"])
		]]
		
		--[[
		--小星星
		local tStarList =
		{
			{x = -224, y = -60,},
			{x = -321, y = -99,},
			{x = -298, y = -186,},
		}
		for star = 1, #tStarList, 1 do
			--抽神器宝箱小星星
			_frmNode.childUI["star_" .. star] = hUI.image:new({
				parent = _parentNode,
				model = "UI:STAR_SMALL",
				x = LIMITTIMEGIFT_OFFSET_X + tStarList[star].x + _offX,
				y = LIMITTIMEGIFT_OFFSET_Y + tStarList[star].y + _offY,
				scale = 0.01,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "star_" .. star
			--小星星动画
			local WAITIME1 = math.random(300, 800) / 1000
			local ACTTIME = math.random(2000, 3000) / 1000
			local WAITIME2 = math.random(1000, 2500) / 1000
			local SCALEBIG = math.random(280, 500) / 1000
			--local SCALESMALL = math.random(700, 800) / 1000
			local delay1 = CCDelayTime:create(WAITIME1)
			local rot = CCRotateBy:create(ACTTIME, 180)
			local big = CCScaleTo:create(ACTTIME/2, SCALEBIG)
			local small = CCScaleTo:create(ACTTIME/2, 0.01)
			local bigsmall = CCSequence:createWithTwoActions(big, small)
			local rotbigsmall = CCSpawn:createWithTwoActions(rot, bigsmall)
			local delay2 = CCDelayTime:create(WAITIME2)
			local a = CCArray:create()
			a:addObject(delay1)
			a:addObject(rotbigsmall)
			a:addObject(delay2)
			local sequence = CCSequence:create(a)
			_frmNode.childUI["star_" .. star].handle.s:runAction(CCRepeatForever:create(sequence))
		end
		]]
		
		--[[
		--奖励描述信息
		_frmNode.childUI["giftIntro"] = hUI.label:new({
			parent = _parentNode,
			x = LIMITTIMEGIFT_OFFSET_X - 210 + _offX,
			y = LIMITTIMEGIFT_OFFSET_Y - 120 + 76 + _offY,
			width = 636,
			size = 24,
			align = "LT",
			text = "",
			font = hVar.FONTC,
			RGB = {255, 255, 0,},
			border = 1,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "giftIntro"
		
		--充值按钮(新用户任意充值活动)
		_frmNode.childUI["btnPruchase"] = hUI.button:new({
			parent = _parentNode,
			x = LIMITTIMEGIFT_OFFSET_X + 1 + _offX,
			y = LIMITTIMEGIFT_OFFSET_Y - 490 + _offY,
			model = "misc/chest/purchase_btn.png",
			dragbox = _frm.childUI["dragBox"],
			label = {font = hVar.FONTC, border = 1, x = 0, y = -2, size = 32, text = hVar.tab_string["__TEXT_GoToRecharge"],}, --"去充值"
			scaleT = 0.95,
			w = 190,
			h = 62,
			code = function()
				--关闭本界面
				_frm.childUI["closeBtn"].data.code()
				
				--弹出充值界面
				hGlobal.event:event("LocalEvent_InitInAppPurchaseTipFrm")
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnPruchase"
		_frmNode.childUI["btnPruchase"]:setstate(-1) --默认不显示
		
		--领取按钮(新用户任意充值活动)
		_frmNode.childUI["btnReward"] = hUI.button:new({
			parent = _parentNode,
			x = LIMITTIMEGIFT_OFFSET_X + 1 + _offX,
			y = LIMITTIMEGIFT_OFFSET_Y - 490 + _offY,
			model = "misc/chest/purchase_btn.png",
			dragbox = _frm.childUI["dragBox"],
			label = {font = hVar.FONTC, border = 1, x = 0, y = -2, size = 32, text = hVar.tab_string["__Get__"],}, --"领取"
			scaleT = 0.95,
			w = 190,
			h = 62,
			code = function()
				--如果本地未联网，那么提示没联网
				if (g_cur_net_state == -1) then --未联网
					--local strText = 领取奖励需要联网" --language
					local strText = hVar.tab_string["__TEXT_Cant_UseDepletion7_Net"] --language
					hGlobal.UI.MsgBox(strText, {
						font = hVar.FONTC,
						ok = function()
						end,
					})
					
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
				
				--发起查询，领取奖励
				--print(activityId)
				local activityId = 0
				if current_tActivity then
					activityId = current_tActivity.aid
				end
				SendCmdFunc["request_activity_pruchase_takereward"](activityId)
			end,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnReward"
		_frmNode.childUI["btnReward"]:setstate(-1) --默认不显示
		_frmNode.childUI["btnReward"].childUI["rewardTanHao"] = hUI.image:new({
			parent = _frmNode.childUI["btnReward"].handle._n,
			x = 66,
			y = 22,
			model = "UI:TaskTanHao",
			w = 36,
			h = 36,
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
		_frmNode.childUI["btnReward"].childUI["rewardTanHao"].handle.s:runAction(CCRepeatForever:create(sequence))
		
		--已领取的tag
		_frmNode.childUI["btnPruchaseFinishTag"] = hUI.image:new({
			parent = _parentNode,
			x = LIMITTIMEGIFT_OFFSET_X + 1 + _offX,
			y = LIMITTIMEGIFT_OFFSET_Y - 490 + _offY,
			model = "UI:FinishTag2",
			scale = 1,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnPruchaseFinishTag"
		_frmNode.childUI["btnPruchaseFinishTag"].handle._n:setRotation(15)
		_frmNode.childUI["btnPruchaseFinishTag"].handle._n:setVisible(false) --默认不显示
		]]
		
		--按钮-签到
		_frmNode.childUI["Btn_SignIn"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/task/tab_frame_selected.png",
			x = 140 + 437 - 88 * 2,
			y = 70 - 728,
			w = 89,
			h = 103,
			scaleT = 1.0,
			dragbox = _frm.childUI["dragBox"],
			code = function()
				--
			end,
		})
		_frmNode.childUI["Btn_SignIn"].handle.s:setOpacity(255) --只挂载子控件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "Btn_SignIn"
		--图标
		_frmNode.childUI["Btn_SignIn"].childUI["icon"] = hUI.button:new({
			parent = _frmNode.childUI["Btn_SignIn"].handle._n,
			model = "misc/task/tab_checkin_02.png",
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
			x = 140 + 437 - 88,
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
		--添加事件监听：收到活动信息回调
		hGlobal.event:listen("localEvent_UpdateActivityInfo", "__OnReceiveActivityInfo_Purchase", on_receive_activity_info_event)
		--添加事件监听：收到活动进度事件
		hGlobal.event:listen("localEvent_UpdateActivityReward", "_UpdateActivityReward", on_receive_activity_progress_event)
		--添加事件监听：收到新玩家14日签到活动今日是否可签到的事件
		hGlobal.event:listen("localEvent_activity_today_state", "_UpdateActivityState", on_receive_activity_today_state_event)
		--添加事件监听：收到今日签到结果返回事件
		hGlobal.event:listen("localEvent_activity_today_signin", "_ActivitySignIn", on_receive_activity_signin_result_event)
		--添加事件监听：收到新玩家14日签到活动购买特惠礼包结果返回事件
		hGlobal.event:listen("localEvent_activity_signin_buygift", "_ActivitySignInBuyGift",  on_receive_activity_signin_buygift_result_event)
		--添加事件监听：横竖屏切换
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreenSignIn_", on_spine_screen_event)
		
		--只有在本分页才会有的timer
		--hApi.addTimerForever("__LIMITTIMEGIFT_TIMER_UPDATE__", hVar.TIMER_MODE.GAMETIME, 1000, refresh_limittime_gift_timer)
		
		--挡操作
		--hUI.NetDisable(30000)
		
		--发送查询活动信息请求
		local langIdx = g_Cur_Language - 1
		SendCmdFunc["get_ActivityList"](langIdx)
	end
	
	--函数：收到获得活动信息的回调
	on_receive_activity_info_event = function(tActivityList)
		local _frm = hGlobal.UI.SignInFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--取消挡操作
		hUI.NetDisable(0)
		
		--先清除所有右侧的控件
		_removeRightFrmFunc()
		
		--清空本次缓存的活动信息表
		current_tActivity = nil
		
		--找到新玩家任意充值活动
		for i = 1, #tActivityList, 1 do
			local listI = tActivityList[i]
			local activityId = listI.aid --活动id
			local activityType = listI.ptype --活动类型
			local activityName = listI.title --活动名称
			local activityAwards = listI.prize --活动奖励表
			local activityDesc = listI.describe --活动描述
			local activityBeginDate = tonumber(listI.time_begin) --活动开始时间
			local activityEndDate = tonumber(listI.time_end) --活动结束时间
			
			if (activityType == 10022) then --找到了
				current_tActivity = listI
				--print("找到了")
				break
			end
		end
		
		--存在新玩家任意充值活动
		if current_tActivity then
			local activityId = current_tActivity.aid --活动id
			local activityName = current_tActivity.title --活动名称
			local activityAwards = current_tActivity.prize --活动奖励表
			local activityDesc = current_tActivity.describe --活动描述
			
			local _offX = 72
			local _offY = -124
			
			--绘制每个档位的奖励
			for i = 1, #activityAwards, 1 do
				local rate = activityAwards[i].rate --档位需要的值
				local prize = activityAwards[i].prize --档位的奖励道具
				local buy = activityAwards[i].buy or {} --档位的特惠购买奖励道具
				
				local xn = i % SIGNIN_X_NUM
				if (xn == 0) then
					xn = SIGNIN_X_NUM
				end
				local yn = (i - xn) / SIGNIN_X_NUM + 1
				local reward_posX = _offX + (xn - 1) * 96
				local reward_posY = _offY - (yn - 1) * 137
				
				--获取全部的奖励(新玩家14日签到活动)
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
				
				--绘制奖励（只绘制第一个奖励）
				local rewardT = reward[1]
				local tmpModel, itemName, itemNum, itemWidth, itemHeight, sub_tmpModel, sub_pos_x, sub_pos_y, sub_pos_w, sub_pos_h = hApi.GetRewardParams(rewardT)
				
				--活动
				--奖励物品的图标按钮
				local rewardDx = (110 + 0)
				_frmNode.childUI["DLCMapInfoNode" .. i] = hUI.button:new({ --作为按钮只是为了挂载子控件
					parent = _parentNode,
					model = "misc/mask.png",
					x = reward_posX,
					y = reward_posY,
					w = 90,
					h = 134,
					dragbox = _frm.childUI["dragBox"],
					code = function()
						--点击签到天数按钮的逻辑
						on_ckick_signin_day_button(i)
					end,
				})
				_frmNode.childUI["DLCMapInfoNode" .. i].data.rewardT = rewardT --存储奖励
				_frmNode.childUI["DLCMapInfoNode" .. i].data.progress = 0 --完成的进度（0:未完成/1:可签到/2:已完成）
				_frmNode.childUI["DLCMapInfoNode" .. i].handle.s:setOpacity(0) --默认不显示（只挂载子控件，不显示）
				rightRemoveFrmList[#rightRemoveFrmList + 1] = "DLCMapInfoNode" .. i
				
				--物品图标(新玩家14日签到活动)
				local scale = 1.6
				_frmNode.childUI["DLCMapInfoNode" .. i].childUI["icon"] = hUI.image:new({
					parent = _frmNode.childUI["DLCMapInfoNode" .. i].handle._n,
					model = tmpModel,
					x = 0,
					y = -10,
					z = 3,
					w = itemWidth * scale,
					h = itemHeight * scale,
				})
				
				--绘制奖励图标的子控件
				if sub_tmpModel then
					_frmNode.childUI["DLCMapInfoNode" .. i].childUI["subIcon"] = hUI.image:new({
						parent = _frmNode.childUI["DLCMapInfoNode" .. i].handle._n,
						model = sub_tmpModel,
						x = sub_pos_x * scale,
						y = -10 + sub_pos_y * scale,
						z = 4,
						w = sub_pos_w * scale,
						h = sub_pos_h * scale,
					})
				end
				
				--绘制奖励的数量
				local strRewardNum = "+" .. itemNum
				
				--[[
				--测试 --test
				strRewardNum = "+200000"
				]]
				
				local rewardNumLength = #strRewardNum
				local rewardNumFont = "numWhite" --字体
				local rewardNumFontSize = 20 --字体大小
				local rewardNumBorder = 0 --是否显示边框
				local rewardNumOffsetY = 0 --y偏移
				if (rewardNumLength == 4) then --"+100"
					rewardNumFont = "numWhite"
					rewardNumFontSize = 18
					rewardNumBorder = 0
					rewardNumOffsetY = 0
				elseif (rewardNumLength == 5) then --"+1000"
					rewardNumFont = "numWhite"
					rewardNumFontSize = 16
					rewardNumBorder = 0
					rewardNumOffsetY = -1
				elseif (rewardNumLength == 6) then --"+10000"
					rewardNumFont = "numWhite"
					rewardNumFontSize = 15
					rewardNumBorder = 0
					rewardNumOffsetY = -3
				elseif (rewardNumLength >= 7) then --"+100000"
					rewardNumFont = hVar.FONTC
					rewardNumFontSize = 14
					rewardNumBorder = 1
					rewardNumOffsetY = -2
				end
				
				--道具数量(新玩家14日签到活动)
				_frmNode.childUI["DLCMapInfoNode" .. i].childUI["num"] = hUI.label:new({
					parent = _frmNode.childUI["DLCMapInfoNode" .. i].handle._n,
					size = rewardNumFontSize,
					x = 0,
					y = -20 -24 + rewardNumOffsetY,
					z = 5,
					width = 500,
					align = "MC",
					font = rewardNumFont,
					text = strRewardNum,
					border = rewardNumBorder,
				})
				if (rewardT[1] == 10) and (rewardT[2] == 12406) then --多个献祭晶石数量
					_frmNode.childUI["DLCMapInfoNode" .. i].childUI["num"]:setText("+" .. artifactStoneNum)
				end
				
				--[[
				--道具名称(新玩家14日签到活动)
				_frmNode.childUI["DLCMapInfoNode" .. i].childUI["name"] = hUI.label:new({
					parent = _frmNode.childUI["DLCMapInfoNode" .. i].handle._n,
					model = "UI:FinishTag",
					x = 0,
					y = -66 + 16,
					z = 6,
					size = 20,
					font = hVar.FONTC,
					width = 80,
					align = "MT",
					text = itemName,
					border = 1,
					RGB = {128, 212, 255,},
				})
				]]
				
				--物品已领取的灰色蒙版
				_frmNode.childUI["DLCMapInfoNode" .. i].childUI["mengban"] = hUI.image:new({
					parent = _frmNode.childUI["DLCMapInfoNode" .. i].handle._n,
					model = "misc/mask_white.png",
					x = 0,
					y = 0,
					z = 7,
					w = 90,
					h = 134,
				})
				_frmNode.childUI["DLCMapInfoNode" .. i].childUI["mengban"].handle.s:setOpacity(88)
				_frmNode.childUI["DLCMapInfoNode" .. i].childUI["mengban"].handle.s:setColor(ccc3(0, 0, 0))
				_frmNode.childUI["DLCMapInfoNode" .. i].childUI["mengban"].handle._n:setVisible(false) --默认不显示
				
				--是否已领取"(已领取)"
				_frmNode.childUI["DLCMapInfoNode" .. i].childUI["finish"] = hUI.image:new({
					parent = _frmNode.childUI["DLCMapInfoNode" .. i].handle._n,
					model = "UI:FinishTag",
					x = 0,
					y = -20 + 6,
					z = 8,
					w = 70,
					h = 60,
				})
				_frmNode.childUI["DLCMapInfoNode" .. i].childUI["finish"].handle._n:setRotation(15)
				_frmNode.childUI["DLCMapInfoNode" .. i].childUI["finish"].handle._n:setVisible(false) --默认不显示
			end
			
			--发起查询，本条活动的完成进度
			SendCmdFunc["get_ActivityRate"](activityId, activityType)
			
			--发起查询，今日是否可签到
			SendCmdFunc["request_activity_today_state"](activityId)
		end
	end
	
	--函数：收到获得活动进度的回调
	on_receive_activity_progress_event = function(aid, ptype, progresList)
		local _frm = hGlobal.UI.SignInFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--只处理新玩家14日签到活动
		if (ptype == 10022) then
			if current_tActivity then
				local activityAwards = current_tActivity.prize --活动奖励表
				local progress = progresList[1] or 0 --当前进度
				
				--已完成签到显示"已完成"标签
				for i = 1, progress, 1 do
					if _frmNode.childUI["DLCMapInfoNode" .. i] then
						_frmNode.childUI["DLCMapInfoNode" .. i].childUI["mengban"].handle._n:setVisible(true)
						_frmNode.childUI["DLCMapInfoNode" .. i].childUI["finish"].handle._n:setVisible(true)
						_frmNode.childUI["DLCMapInfoNode" .. i].data.progress = 2 --完成的进度（0:未完成/1:可签到/2:已完成）
					end
				end
				
				--未完成签到隐藏"已完成"标签
				for i = progress + 1, #activityAwards, 1 do
					if _frmNode.childUI["DLCMapInfoNode" .. i] then
						_frmNode.childUI["DLCMapInfoNode" .. i].childUI["mengban"].handle._n:setVisible(false)
						_frmNode.childUI["DLCMapInfoNode" .. i].childUI["finish"].handle._n:setVisible(false)
						_frmNode.childUI["DLCMapInfoNode" .. i].data.progress = 0 --完成的进度（0:未完成/1:可签到/2:已完成）
					end
				end
				
				--更新提示当前哪个分页可以有领取的了
				RefreshTaskAchievementFinishPage()
			end
		end
	end
	
	--函数：收到获得新玩家14日签到活动今日是否可领奖的回调
	on_receive_activity_today_state_event = function(aid, ptype, result, progress, progressMax, progressFinidhDay, tBuyFlag)
		--print("on_receive_activity_today_state_event", aid, ptype, result, progress, progressMax, progressFinidhDay, tBuyFlag)
		local _frm = hGlobal.UI.SignInFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--只处理新玩家14日签到活动
		if (ptype == 10022) then
			local activityAwards = current_tActivity.prize --活动奖励表
			
			--可签到的显示叹号
			for i = 1, #activityAwards, 1 do
				local ctrI = _frmNode.childUI["DLCMapInfoNode" .. i]
				if ctrI then
					hApi.safeRemoveT(ctrI.childUI, "tanhao")
					
					if (i == progress) then
						ctrI.data.progress = 1 --完成的进度（0:未完成/1:可签到/2:已完成）
						
						--叹号
						ctrI.childUI["tanhao"] = hUI.image:new({
							parent = ctrI.handle._n,
							model = "UI:TaskTanHao",
							x = 20,
							y = 40,
							z = 1,
							w = 42,
							h = 42,
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
						ctrI.childUI["tanhao"].handle.s:runAction(CCRepeatForever:create(sequence))
					end
				end
			end
			
			--更新提示当前哪个分页可以有领取的了
			RefreshTaskAchievementFinishPage()
		end
	end
	
	--函数：收到获得新玩家14日签到活动今日签到结果返回事件
	on_receive_activity_signin_result_event = function(aid, ptype, result, progress, progressMax, info, prizeId, prizeType, reward)
		local _frm = hGlobal.UI.SignInFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		--print("on_receive_activity_signin_result_event", aid, ptype, result, progress, progressMax, info, prizeId, prizeType, reward)
		
		--只处理新玩家14日签到活动
		if (ptype == 10022) then
			--签到成功
			if (result == 1) then
				--隐藏叹号
				for i = 1, progress, 1 do
					local ctrI = _frmNode.childUI["DLCMapInfoNode" .. i]
					if ctrI then
						hApi.safeRemoveT(ctrI.childUI, "tanhao")
						ctrI.childUI["mengban"].handle._n:setVisible(true)
						ctrI.childUI["finish"].handle._n:setVisible(true)
						ctrI.data.progress = 2 --完成的进度（0:未完成/1:可签到/2:已完成）
					end
				end
				
				--更新提示当前哪个分页可以有领取的了
				RefreshTaskAchievementFinishPage()
			end
		end
	end
	
	--函数：收到获得新玩家14日签到活动购买特惠礼包结果返回事件
	on_receive_activity_signin_buygift_result_event = function(aid, ptype, result, progress, progressMax, progressFinidhDay, buyGiftDay, tBuyFlag, info, prizeId, prizeType, reward)
		local _frm = hGlobal.UI.SignInFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
	end
	
	--函数：横竖屏切换
	on_spine_screen_event = function()
		local _frm = hGlobal.UI.SignInFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--关闭本界面
		OnClosePanel()
		
		--重绘本界面
		hGlobal.UI.InitSignInFrm("reload") --测试
		--触发事件，显示签到界面
		hGlobal.event:event("LocalEvent_Phone_ShowSignInFrm", current_funcCallback)
	end
	
	--函数：点击签到天数按钮的逻辑
	on_ckick_signin_day_button = function(iDay)
		local _frm = hGlobal.UI.SignInFrm
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local ctrI = _frmNode.childUI["DLCMapInfoNode" .. iDay]
		if ctrI then
			local progress = ctrI.data.progress --完成的进度（0:未完成/1:可签到/2:已完成）
			local rewardT = ctrI.data.rewardT
			
			if (progress == 1) then --签到
				--如果本地未联网，那么提示没联网
				if (g_cur_net_state == -1) then --未联网
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
				
				--背包已满，无法签到
				if (LuaCheckPlayerBagCanUse() == 0) then
					--冒字
					--local strText = "背包已满，无法签到" --language
					local strText = hVar.tab_string["__TEXT_BAGLISTISFULL12"] --language
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
				
				--发起请求签到
				local activityId = current_tActivity.aid --活动id
				SendCmdFunc["request_activity_today_signin"](activityId, iDay)
			else
				--显示各种类型的奖励的tip
				hApi.ShowRewardTip(rewardT)
			end
		end
	end
	
	--函数: 动态加载资源
	__DynamicAddRes = function()
		local _frm = hGlobal.UI.SignInFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		print("函数: 动态加载资源")
		
		--加载资源
		--动态加载宝物背景图
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/task/checkin_panel.png")
		if (not texture) then
			texture = CCTextureCache:sharedTextureCache():addImage("data/image/misc/task/checkin_panel.png")
			print("加载签到背景大图！")
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
		local _frm = hGlobal.UI.SignInFrm
		local _parent = _frm.handle._n
		local _childUI = _frm.childUI
		
		--删除资源
		--删除竞技场背景图
		_childUI["panel_bg"].handle._n:removeChild(_childUI["panel_bg"].data.pSprite, true)
		local texture = CCTextureCache:sharedTextureCache():textureForKey("data/image/misc/task/checkin_panel.png")
		if texture then
			CCTextureCache:sharedTextureCache():removeTexture(texture)
			print("清空签到背景大图！")
		end
	end
	
	--函数：更新提示当前哪个分页可以有领取的了
	RefreshTaskAchievementFinishPage = function()
		local _frm = hGlobal.UI.SignInFrm
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
hGlobal.event:listen("clearPhoneChestFrm", "__CloseSignInFrm", function()
	--关闭本界面
	OnClosePanel()
end)

--监听打开签到礼包界面通知事件
hGlobal.event:listen("LocalEvent_Phone_ShowSignInFrm", "ShowSignInFrm", function(callback, bOpenImmediate)
	hGlobal.UI.InitSignInFrm("reload")
	
	--触发事件，显示积分、金币界面
	--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
	
	--直接打开
	if bOpenImmediate then
		--存储回调事件
		current_funcCallback = callback
		
		--显示签到礼包界面
		hGlobal.UI.SignInFrm:show(1)
		hGlobal.UI.SignInFrm:active()
		
		--打开上一次的分页（默认显示第1个分页: 签到礼包）
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
			
			--显示签到礼包界面
			hGlobal.UI.SignInFrm:show(1)
			hGlobal.UI.SignInFrm:active()
			
			--打开上一次的分页（默认显示第1个分页: 签到礼包）
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
			local _frm = hGlobal.UI.SignInFrm
			local dx = BOARD_WIDTH
			_frm:setXY(_frm.data.x + dx, _frm.data.y)
		end)
		
		--步骤2: 动画进入控件
		local actM2 = CCCallFunc:create(function()
			--本面板
			local _frm = hGlobal.UI.SignInFrm
			
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
		local _frm = hGlobal.UI.SignInFrm
		_frm.handle._n:stopAllActions() --先停掉之前可能的动画
		_frm.handle._n:runAction(sequence)
	end
end)

--test
--[[
--测试代码
if hGlobal.UI.SignInFrm then --删除上一次的签到礼包界面
	hGlobal.UI.SignInFrm:del()
	hGlobal.UI.SignInFrm = nil
end
hGlobal.UI.InitSignInFrm("reload") --测试创建任意充值活动界面
--触发事件，显示签到礼包界面
hGlobal.event:event("LocalEvent_Phone_ShowSignInFrm")
]]


