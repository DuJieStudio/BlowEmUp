

--道具简易操作面板（洗炼）
hGlobal.UI.InitMyItemFrm_Mini = function(mode)
	local tInitEventName = {"localEvent_ShowPhone_ItemMini", "_ShowXilian"}
	if mode~="include" then
		return tInitEventName
	end
	
	--不重复创建道具简易操作面板
	if hGlobal.UI.PhoneItemFrm_Mini then --道具简易操作面板
		hGlobal.UI.PhoneItemFrm_Mini:del()
		hGlobal.UI.PhoneItemFrm_Mini = nil
	end
	
	--取消监听：道具洗炼结果刷新本界面
	hGlobal.event:listen("Local_Event_ItemXiLian_Result_Red_Equip", "__ItemXiLianSuccess_Frm_Mini", nil)
	
	local BOARD_WIDTH = 720 - 80 --道具操作面板的宽度
	local BOARD_HEIGHT = 720 --道具操作面板的高度
	local BOARD_OFFSETY = -20+10 --道具操作面板y偏移中心点的值
	local BOARD_POS_X = hVar.SCREEN.w / 2 - BOARD_WIDTH / 2 --道具操作面板的x位置（最左侧）
	local BOARD_POS_Y = hVar.SCREEN.h / 2 + BOARD_HEIGHT / 2 + BOARD_OFFSETY --道具操作面板的y位置（最顶侧）
	local BOARD_ACTIVE_WIDTH = 508 --道具操作面板活动宽度（卡牌显示的宽度）
	
	local PAGE_BTN_LEFT_X = 120 --第一个分页按钮的x偏移
	local PAGE_BTN_LEFT_Y = -23 --第一个分页按钮的x偏移
	local PAGE_BTN_OFFSET_X = 140 --每个分页按钮的间距
	
	--临时UI管理
	local leftRemoveFrmList = {} --左侧控件集
	local rightRemoveFrmList = {} --右侧控件集
	local _removeLeftFrmFunc = hApi.DoNothing --清空左侧所有的临时控件
	local _removeRightFrmFunc = hApi.DoNothing --清空右侧所有的临时控件
	
	--局部函数
	
	--分页3：洗炼道具函数部分
	local OnCreateXiLianItemBtn_Mini = hApi.DoNothing --创建洗炼道具迷你图标按钮
	local OnXiLianItemFunc = hApi.DoNothing --洗炼道具逻辑
	local OnCreateShopXiLianFrame_Mini = hApi.DoNothing --创建道具洗炼迷你界面
	local OnCreateItemXiLianTipFrame = hApi.DoNothing --查看装备洗炼分页说明tip
	local RefreshXiLianItemNoteFrm_Mini = hApi.DoNothing --刷新洗炼道具价格和按钮控件
	local OnClickShowLockXiLianItemSlotTip = hApi.DoNothing --显示锁孔按钮的tip
	local OnClickLockXiLianItemSlot = hApi.DoNothing --点击锁孔按钮的逻辑
	local RefreshXilianItemInfo_Mini = hApi.DoNothing --刷新洗炼道具的信息
	local PlayItemXiLianAnimation = hApi.DoNothing --道具洗炼动画
	local PlayItemRebuildAnimation = hApi.DoNothing --道具重铸动画
	local on_SpinScreen_event_xilain = hApi.DoNothing --横竖屏切换事件
	local OnClosePanel = hApi.DoNothing --关闭本界面
	
	local ITEM_ICON_EDGE = 80 --道具图标的边长
	local ITEM_BAG_OFFSET_X = 550 --道具背包统一偏移x
	local ITEM_BAG_OFFSET_Y = -125 --道具背包统一偏移y
	
	local BAG_X_NUM = 4 --背包x方向的个数
	local BAG_Y_NUM = 7 --背包y方向的个数
	local bag_touch_dx = 0 --背包触控点的偏移值x
	local bag_touch_dy = 0 --背包触控点的偏移值y
	
	--洗炼道具相关参数
	local current_xilian_oHero = 0 --当前洗炼道具的英雄
	local current_xilian_itemIdx = 0 --当前洗炼道具的背包索引位置
	local current_xilian_item_lock_state = {0, 0, 0, 0} --当前洗炼道具孔锁住的标记
	
	--加载资源
	--xlLoadResourceFromPList("data/image/misc/pvp.plist")
	
	--hApi.clearTimer("__TACTIC_FRAME_UPDATE__")
	
	--创建道具简易操作面板
	hGlobal.UI.PhoneItemFrm_Mini = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		z = hZorder.EquipXiLian,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 4,
		show = 0, --一开始不显示
		border = 0, --显示frame边框
		background = -1, --"misc/chest/itemtip.png", --"UI:Tactic_Background",
		autoactive = 0,
		--全部事件
		--codeOnDragEx = function(touchX, touchY, touchMode)
			--
		--end,
	})
	
	local _frm = hGlobal.UI.PhoneItemFrm_Mini
	local _parent = _frm.handle._n
	
	--抽神器黑色背景底板
	--九宫格
	local s9 = hApi.CCScale9SpriteCreate("data/image/misc/chariotconfig/chip_panel.png", BOARD_WIDTH/2,  - BOARD_HEIGHT/2, 625, 648, _frm)
	--s9:setColor(ccc3(128, 128, 128))
	--s9:setOpacity(32)
	
	--[[
	--标题文字
	_frm.childUI["Title"] = hUI.label:new({
		parent = _parent,
		x = BOARD_WIDTH / 2,
		y = -50,
		size = 32,
		font = hVar.FONTC,
		align = "MC",
		width = 380,
		border = 1,
		--text = "装备洗炼", --language
		text = hVar.tab_string["__TEXT_Page_Equip"] .. hVar.tab_string["__ITEM_PANEL__PAGE_XILIAN"] --language
	})
	]]
	
	--关闭按钮
	--btnClose
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		model = "misc/skillup/btn_close.png",
		x = _frm.data.w - 72,
		y = -102,
		--w = 64,
		--h = 64,
		scaleT = 0.95,
		code = function()
			--hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
			
			--关闭本界面
			OnClosePanel()
		end,
	})
	
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
	_removeLeftFrmFunc = function()
		local _frm = hGlobal.UI.PhoneItemFrm_Mini
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function()
		local _frm = hGlobal.UI.PhoneItemFrm_Mini
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#rightRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, rightRemoveFrmList[i]) 
		end
		rightRemoveFrmList = {}
	end
	
	--函数：创建道具洗炼迷你界面
	OnCreateShopXiLianFrame_Mini = function()
		local _frm = hGlobal.UI.PhoneItemFrm_Mini
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local OFFSET_X = 130 --统一偏移x
		local OFFSET_Y = -140 --统一偏移y
		
		--重置参数
		current_xilian_oHero = 0 --当前洗炼道具的英雄
		current_xilian_itemIdx = 0 --当前洗炼道具的背包索引位置
		current_xilian_item_lock_state = {0, 0, 0, 0} --当前洗炼道具孔锁住的标记
		
		--总芯片数图标
		_frmNode.childUI["imgChipIcon"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = OFFSET_X - 70,
			y = OFFSET_Y + 50,
			w = 60,
			h = 60,
			model = "ICON:CHIP_BROKEN",
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "imgChipIcon"
		
		--总芯片值
		local chipNum = LuaGetPlayerChip()
		_frmNode.childUI["labelChipNum"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X - 70 + 30,
			y = OFFSET_Y + 50 - 1,
			size = 26,
			font = "numWhite",
			align = "LC",
			width = 380,
			border = 0,
			text = chipNum,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "labelChipNum"
		
		--提示洗炼道具的说明文字
		_frmNode.childUI["XiLianIntro"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X + 20,
			y = OFFSET_Y,
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 380,
			border = 1,
			--text = "随机生成装备孔的新属性", --language
			text = "", --hVar.tab_string["__ITEM_PANEL_MINI__XILIAN_INTRO"], --language
		})
		_frmNode.childUI["XiLianIntro"].handle.s:setColor(ccc3(192, 192, 192))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLianIntro"
		
		--[[
		--洗炼规则介绍按钮（响应区域）
		_frmNode.childUI["btnXiLianIntro"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = OFFSET_X + 350,
			y = OFFSET_Y - 10,
			w = 70,
			h = 70,
			model = "misc/mask.png",
			scaleT = 1.0,
			scale = 1.0,
			code = function()
				--创建洗炼介绍tip
				--OnCreateItemXiLianTipFrame()
				print("创建洗炼介绍tip")
			end,
		})
		_frmNode.childUI["btnXiLianIntro"].handle.s:setOpacity(0) --用于响应事件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnXiLianIntro"
		
		--合成规则介绍图标
		_frmNode.childUI["btnXiLianIntro"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["btnXiLianIntro"].handle._n,
			dragbox = _frm.childUI["dragBox"],
			x = 0,
			y = 10,
			w = 45,
			h = 45,
			model = "ICON:action_info",
		})
		local towAction = CCSequence:createWithTwoActions(CCScaleTo:create(1.0, 1.02, 1.02) ,CCScaleTo:create(1.0, 0.98, 0.98))
		local forever = CCRepeatForever:create(tolua.cast(towAction,"CCActionInterval"))
		_frmNode.childUI["btnXiLianIntro"].childUI["icon"].handle._n:runAction(forever)
		]]
		
		--洗炼池子（响应区域）
		_frmNode.childUI["XiLianChip"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			x = OFFSET_X + 183,
			y = OFFSET_Y - 91,
			w = 120,
			h = 120,
		})
		_frmNode.childUI["XiLianChip"].handle.s:setOpacity(0) --不显示，只用于响应事件
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLianChip"
		
		--[[
		--洗炼池子图片
		_frmNode.childUI["XiLianChip"].childUI["image"] = hUI.image:new({
			parent = _frmNode.childUI["XiLianChip"].handle._n,
			model = "UI:forged_slot",
			x = 0,
			y = 0,
			w = 100,
			h = 100,
		})
		]]
		
		--洗炼属性区域的很淡的底纹区域背景图
		_frmNode.childUI["XiLianAttrBG"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			x = OFFSET_X + 185,
			y = OFFSET_Y - 280,
			w = 500,
			h = 250,
		})
		_frmNode.childUI["XiLianAttrBG"].handle.s:setOpacity(0) --只挂载子控件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLianAttrBG"
		local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", 0, 0, 500, 250, _frmNode.childUI["XiLianAttrBG"])
		img9:setOpacity(32) --很淡的颜色
		
		--依次绘制每条洗炼属性
		local _off_x = 24 --dx
		local _off_y = -194 --dy
		local _off_dy = 56 --每个间隔y
		for i = 1, 4, 1 do
			--该属性条的背景图
			_frmNode.childUI["XiLian_ImageBG" .. i] = hUI.image:new({
				parent = _parentNode,
				model = "misc/chariotconfig/chip_bar.png",
				x = OFFSET_X + 126,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy,
				w = 277,
				h = 48,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_ImageBG" .. i
			
			--该属性条的背景图（锁定）
			_frmNode.childUI["XiLian_ImageBG_Lock" .. i] = hUI.image:new({
				parent = _parentNode,
				model = "misc/chariotconfig/chip_bar_lock.png", --"UI:Button_SelectBorder",
				x = OFFSET_X + 126,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy,
				w = 277,
				h = 48,
			})
			_frmNode.childUI["XiLian_ImageBG_Lock" .. i].handle.s:setVisible(false) --默认不显示
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_ImageBG_Lock" .. i
			
			--钻石图标
			_frmNode.childUI["XiLian_Diamond" .. i] = hUI.image:new({
				parent = _parentNode,
				model = "misc/mask.png", --"MODEL_EFFECT:diamond",
				x = OFFSET_X + _off_x - 15,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy - 2,
				w = 60,
				h = 60,
			})
			_frmNode.childUI["XiLian_Diamond" .. i].handle.s:setVisible(false) --默认不显示
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_Diamond" .. i
			
			--卡槽的属性文字
			_frmNode.childUI["XiLian_Attr" .. i] = hUI.label:new({
				parent = _parentNode,
				x = OFFSET_X + _off_x + 48,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy - 1,
				size = 26,
				align = "LC",
				border = 1,
				font = hVar.FONTC,
				width = 500,
				text = "",
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_Attr" .. i
			
			--锁定的选择框图片
			_frmNode.childUI["XiLian_SelectBox" .. i] = hUI.image:new({
				parent = _parentNode,
				model = "misc/chariotconfig/chip_unlock.png", --"UI:Button_SelectBorder",
				x = OFFSET_X + _off_x + 270,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy - 1,
				w = 30,
				h = 42,
			})
			_frmNode.childUI["XiLian_SelectBox" .. i].handle.s:setVisible(false) --默认不显示
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_SelectBox" .. i
			
			--锁定的选中的勾勾图片
			_frmNode.childUI["XiLian_GouGou" .. i] = hUI.image:new({
				parent = _parentNode,
				model = "misc/button_null.png", --"UI:finish",
				x = OFFSET_X + _off_x + 290,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy,
				scale = 0.01,
			})
			_frmNode.childUI["XiLian_GouGou" .. i].handle._n:setVisible(false) --默认不显示
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_GouGou" .. i
			
			--锁定的锁的图标
			_frmNode.childUI["XiLian_Lock" .. i] = hUI.image:new({
				parent = _parentNode,
				model = "misc/chariotconfig/chip_lock.png",
				x = OFFSET_X + _off_x + 270,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy - 1,
				w = 30,
				h = 40,
			})
			_frmNode.childUI["XiLian_Lock" .. i].handle._n:setVisible(false) --默认不显示
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_Lock" .. i
			
			--[[
			--“锁定”文字
			_frmNode.childUI["XiLian_LockLabel" .. i] = hUI.label:new({
				parent = _parentNode,
				x = OFFSET_X + _off_x + 320,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy - 1,
				size = 26,
				align = "LC",
				border = 1,
				font = hVar.FONTC,
				width = 100,
				text = "",
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_LockLabel" .. i
			]]
			
			--洗炼锁定按钮（响应事件）
			_frmNode.childUI["XiLian_LockBtn" .. i] = hUI.button:new({
				parent = _parentNode,
				dragbox = _frm.childUI["dragBox"],
				model = "misc/mask.png",
				x = OFFSET_X + _off_x + 300,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy,
				w = 150,
				h = 45,
				failcall = 1,
				
				--[[
				--按下锁孔事件
				codeOnTouch = function(self, touchX, touchY, sus)
					--显示锁孔按钮的tip
					OnClickShowLockXiLianItemSlotTip(i)
				end,
				
				--滑动锁孔事件
				codeOnDrag = function(self, touchX, touchY, sus)
					if (sus == 1) then --在内部，显示选中框
						if _frmNode.childUI["XiLianSlotTip"] then
							_frmNode.childUI["XiLianSlotTip"]:setstate(1)
						end
					else --在外部，不显示选中框
						if _frmNode.childUI["XiLianSlotTip"] then
							_frmNode.childUI["XiLianSlotTip"]:setstate(-1)
						end
					end
				end,
				]]
				
				--点击锁孔事件
				code = function(self, touchX, touchY, sus)
					--删除锁孔tip
					hApi.safeRemoveT(_frmNode.childUI, "XiLianSlotTip")
					
					--在内部点击
					if (sus == 1) then
						--点击锁孔按钮的逻辑
						OnClickLockXiLianItemSlot(i)
					end
				end,
			})
			_frmNode.childUI["XiLian_LockBtn" .. i].handle.s:setOpacity(0) --不显示，只用于响应事件
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_LockBtn" .. i
		end
		
		--洗炼锁孔每日限制"该装备今日还可以锁孔洗炼"前缀
		_frmNode.childUI["XiLian_DayLimitPrefix"] = hUI.label:new({
			parent = _parentNode,
			model = "UI:score",
			x = OFFSET_X + 248 + 42,
			y = OFFSET_Y - 430 - 2, --numWhite字体偏移2像素
			w = 300,
			align = "RC",
			width = 500,
			font = hVar.FONTC,
			size = 26,
			--text = "该装备今日还可以锁孔洗炼", --language
			text = hVar.tab_string["__TEXT_TodayLockXiLian"], --language
			border = 1,
		})
		_frmNode.childUI["XiLian_DayLimitPrefix"].handle.s:setColor(ccc3(255, 255, 255))
		_frmNode.childUI["XiLian_DayLimitPrefix"].handle._n:setVisible(false) --默认不显示锁孔次数限制
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_DayLimitPrefix"
		
		--洗炼锁孔每日限制的次数
		_frmNode.childUI["XiLian_DayLimitLabel"] = hUI.label:new({
			parent = _parentNode,
			model = "UI:score",
			x = OFFSET_X + 288 + 42,
			y = OFFSET_Y - 430 - 3, --numWhite字体偏移2像素
			w = 300,
			size = 20,
			align = "RC",
			width = 500,
			font = "numWhite",
			text = "--",
			border = 1,
		})
		_frmNode.childUI["XiLian_DayLimitLabel"].handle.s:setColor(ccc3(255, 255, 255))
		_frmNode.childUI["XiLian_DayLimitLabel"].handle._n:setVisible(false) --默认不显示锁孔次数限制
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_DayLimitLabel"
		
		--洗炼锁孔每日限制"该装备今日还可以锁孔洗炼"后缀
		_frmNode.childUI["XiLian_DayLimitPostfix"] = hUI.label:new({
			parent = _parentNode,
			model = "UI:score",
			x = OFFSET_X + 292 + 42,
			y = OFFSET_Y - 430 - 2, --numWhite字体偏移2像素
			w = 300,
			align = "LC",
			width = 500,
			font = hVar.FONTC,
			size = 26,
			--text = "次", --language
			text = hVar.tab_string["__TEXT_YouCanForgedCount1"], --language
			border = 1,
		})
		_frmNode.childUI["XiLian_DayLimitPostfix"].handle.s:setColor(ccc3(255, 255, 255))
		_frmNode.childUI["XiLian_DayLimitPostfix"].handle._n:setVisible(false) --默认不显示锁孔次数限制
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_DayLimitPostfix"
		
		--[[
		--洗炼需要的积分前缀"消耗"
		_frmNode.childUI["XiLian_JiFenLabel"] = hUI.label:new({
			parent = _parentNode,
			model = "UI:score",
			x = OFFSET_X + 50,
			y = OFFSET_Y - 484 - 0, --偏移1像素
			w = 300,
			align = "LC",
			width = 200,
			font = hVar.FONTC,
			--text = "消耗", --language
			size = 26,
			text = hVar.tab_string["__TEXT_CONSUME"], --language
			border = 1,
		})
		_frmNode.childUI["XiLian_JiFenLabel"].handle.s:setColor(ccc3(255, 255, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_JiFenLabel"
		]]
		
		--洗炼需要的积分图标
		_frmNode.childUI["XiLian_JiFenIcon"] = hUI.image:new({
			parent = _parentNode,
			model = "ICON:CHIP_BROKEN",
			x = OFFSET_X + 260,
			y = OFFSET_Y + 10,
			w = 60,
			h = 60,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_JiFenIcon"
		
		--洗炼需要的积分数值
		_frmNode.childUI["JiFenXiLianRequire"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X + 260 + 34,
			y = OFFSET_Y + 10 - 2, --numWhite字体偏移2像素
			size = 26,
			font = "numWhite",
			align = "LC",
			width = 300,
			text = "",
		})
		--_frmNode.childUI["JiFenXiLianRequire"].handle.s:setColor(ccc3(255, 255, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "JiFenXiLianRequire"
		
		--洗炼需要的金币图标
		_frmNode.childUI["XiLian_GoldIcon"] = hUI.image:new({
			parent = _parentNode,
			model = "misc/skillup/keshi.png",
			x = OFFSET_X + 385,
			y = OFFSET_Y - 274,
			w = 60,
			h = 60,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_GoldIcon"
		
		--洗炼需要的金币数值
		_frmNode.childUI["GoldXiLianRequire"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X + 385 + 34,
			y = OFFSET_Y - 274 - 2, --numWhite字体偏移2像素
			size = 26,
			font = "numWhite",
			align = "LC",
			width = 300,
			text = "0",
		})
		_frmNode.childUI["GoldXiLianRequire"].handle.s:setColor(ccc3(255, 255, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "GoldXiLianRequire"
		
		--提示洗练需要的总消耗资源的文字
		_frmNode.childUI["CostXiLianSummary"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X + 184,
			y = OFFSET_Y - 440,
			size = 26,
			font = hVar.FONTC,
			align = "MC",
			width = 500,
			text = "",
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "CostXiLianSummary"
		
		--道具洗炼按钮
		_frmNode.childUI["btnXiLian"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = OFFSET_X + 184,
			y = OFFSET_Y - 506,
			w = 69,
			h = 56,
			model = "misc/chariotconfig/chip_hammer.png", --"misc/addition/cg.png", --"UI:BTN_ButtonRed",
			animation = "normal",
			scaleT = 0.95,
			scale = 1.0,
			code = function()
				--洗炼道具逻辑
				OnXiLianItemFunc()
			end,
		})
		hApi.AddShader(_frmNode.childUI["btnXiLian"].handle.s, "gray") --默认该按钮灰掉
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnXiLian"
		
		--[[
		--道具洗炼按钮
		_frmNode.childUI["btnXiLian"].childUI["label"] = hUI.label:new({
			parent = _frmNode.childUI["btnXiLian"].handle._n,
			x = 0,
			y = 1, --文字有2像素的偏差
			--text = "洗炼", --language
			text = hVar.tab_string["__ITEM_PANEL__PAGE_XILIAN"], --language
			font = hVar.FONTC,
			border = 1,
			size = 30,
			width = 200,
			align = "MC",
		})
		]]
		
		--添加本分页的监听事件
		--添加事件监听：横竖屏切换事件
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreen_XiLian", on_SpinScreen_event_xilain)
	end
	
	--函数：创建洗炼道具价格和按钮控件
	RefreshXiLianItemNoteFrm_Mini = function()
		local _frm = hGlobal.UI.PhoneItemFrm_Mini
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--积分图标的位置
		local jfIcon_x, jfIcon_y = _frmNode.childUI["XiLian_GoldIcon"].data.x - 120, _frmNode.childUI["XiLian_GoldIcon"].data.y
		local jfVal_x, jfVal_y = _frmNode.childUI["GoldXiLianRequire"].data.x - 119, _frmNode.childUI["GoldXiLianRequire"].data.y
		
		--如果没有洗炼道具，积分、金币都为0，洗炼按钮不能用
		if (current_xilian_itemIdx == 0) then
			--更新数值和按钮状态
			_frmNode.childUI["JiFenXiLianRequire"]:setText(0)
			_frmNode.childUI["GoldXiLianRequire"]:setText(0)
			_frmNode.childUI["CostXiLianSummary"]:setText("")
			hApi.AddShader(_frmNode.childUI["btnXiLian"].handle.s, "gray")
			
			--更新文本的位置(不消耗金币)
			--_frmNode.childUI["XiLian_JiFenIcon"]:setXY(jfIcon_x + 25, jfIcon_y)
			--_frmNode.childUI["JiFenXiLianRequire"]:setXY(jfVal_x + 25, jfVal_y)
			_frmNode.childUI["XiLian_GoldIcon"].handle._n:setVisible(false)
			_frmNode.childUI["GoldXiLianRequire"].handle._n:setVisible(false)
			
			--不显示今日锁孔次数的文字(不消耗金币)
			_frmNode.childUI["XiLian_DayLimitPrefix"].handle._n:setVisible(false)
			_frmNode.childUI["XiLian_DayLimitLabel"].handle._n:setVisible(false)
			_frmNode.childUI["XiLian_DayLimitPostfix"].handle._n:setVisible(false)
		else --有洗炼的道具
			--检查当前拥有的孔的数量
			--[[
			local item = 0
			if (current_xilian_oHero == 0) then --背包的道具
				item = Save_PlayerData.bag[current_xilian_itemIdx]
			else --英雄身上的装备道具
				--item = current_xilian_oHero.data.equipment[current_xilian_itemIdx]
				local herocard = Save_PlayerData.herocard
				for i = 1, #herocard, 1 do
					if (herocard[i].id == current_xilian_oHero.data.id) then
						item = herocard[i].equipment[current_xilian_itemIdx]
						break
					end
				end
			end
			]]
			local item = current_xilian_itemIdx
			
			local rewardEx = item[hVar.ITEM_DATA_INDEX.SLOT]
			local upCount = 0 --有效的孔的数量
			if rewardEx and (type(rewardEx) == "table") then
				for j = 1, #rewardEx, 1 do
					local attr = rewardEx[j] --孔的属性（字符串）
					local attrVal = hVar.ITEM_ATTR_VAL[attr] --对应的孔的属性表
					if attrVal then
						--本条是有效的孔数据
						upCount = upCount + 1
					end
				end
			end
			
			if (upCount == 0) then --0孔道具不能洗炼
				--更新数值和按钮状态
				_frmNode.childUI["JiFenXiLianRequire"]:setText(0)
				_frmNode.childUI["GoldXiLianRequire"]:setText(0)
				_frmNode.childUI["CostXiLianSummary"]:setText("")
				hApi.AddShader(_frmNode.childUI["btnXiLian"].handle.s, "gray")
				
				--更新文本的位置(不消耗金币)
				--_frmNode.childUI["XiLian_JiFenIcon"]:setXY(jfIcon_x + 25, jfIcon_y)
				--_frmNode.childUI["JiFenXiLianRequire"]:setXY(jfVal_x + 25, jfVal_y)
				_frmNode.childUI["XiLian_GoldIcon"].handle._n:setVisible(false)
				_frmNode.childUI["GoldXiLianRequire"].handle._n:setVisible(false)
				
				--不显示今日锁孔次数的文字(不消耗金币)
				_frmNode.childUI["XiLian_DayLimitPrefix"].handle._n:setVisible(false)
				_frmNode.childUI["XiLian_DayLimitLabel"].handle._n:setVisible(false)
				_frmNode.childUI["XiLian_DayLimitPostfix"].handle._n:setVisible(false)
			else --可以洗炼的道具
				--计算消耗的积分
				--[[
				local item = 0
				if (current_xilian_oHero == 0) then --背包的道具
					item = Save_PlayerData.bag[current_xilian_itemIdx]
				else --英雄身上的装备道具
					--item = current_xilian_oHero.data.equipment[current_xilian_itemIdx]
					local herocard = Save_PlayerData.herocard
					for i = 1, #herocard, 1 do
						if (herocard[i].id == current_xilian_oHero.data.id) then
							item = herocard[i].equipment[current_xilian_itemIdx]
							break
						end
					end
				end
				]]
				local item = current_xilian_itemIdx
				local itemId = item[1]
				local itemLv = hVar.tab_item[itemId].itemLv or 1
				local JifenRequire = hVar.ITEM_XILIAN_INFO[itemLv].cost
				if (type(JifenRequire) == "table") then --红装？
					JifenRequire = JifenRequire[upCount]
				end
				
				--锁孔消耗金币
				local lockSlotSum = 0 --当前锁孔的数量和
				for i = 1, #current_xilian_item_lock_state, 1 do
					lockSlotSum = lockSlotSum + current_xilian_item_lock_state[i]
				end
				local goldRequire = hApi.GetItemLockInfo(lockSlotSum)
				
				--是否可以洗炼
				local currentScore = LuaGetPlayerChip() --玩家当前的积分
				local currentGold = LuaGetPlayerRmb() --玩家当前游戏币
				local todayLockXilianTimes = LuaGetTodayXilianLimitCout(item) --今日锁孔洗炼的次数
				
				--更新界面
				--print("JifenRequire=", JifenRequire, upCount)
				_frmNode.childUI["JiFenXiLianRequire"]:setText(JifenRequire)
				_frmNode.childUI["GoldXiLianRequire"]:setText(goldRequire)
				
				if (goldRequire == 0) then
					--更新文本的位置(不消耗金币)
					--_frmNode.childUI["XiLian_JiFenIcon"]:setXY(jfIcon_x + 25, jfIcon_y)
					--_frmNode.childUI["JiFenXiLianRequire"]:setXY(jfVal_x + 25, jfVal_y)
					_frmNode.childUI["CostXiLianSummary"]:setText(string.format(hVar.tab_string["__TEXT_XILIAN_COSTCHIP"], JifenRequire))
					_frmNode.childUI["XiLian_GoldIcon"].handle._n:setVisible(false)
					_frmNode.childUI["GoldXiLianRequire"].handle._n:setVisible(false)
					
					--不显示今日锁孔次数的文字(不消耗金币)
					_frmNode.childUI["XiLian_DayLimitPrefix"].handle._n:setVisible(false)
					_frmNode.childUI["XiLian_DayLimitLabel"].handle._n:setVisible(false)
					_frmNode.childUI["XiLian_DayLimitPostfix"].handle._n:setVisible(false)
				else
					--更新文本的位置(消耗金币)
					--_frmNode.childUI["XiLian_JiFenIcon"]:setXY(jfIcon_x + 25, jfIcon_y)
					--_frmNode.childUI["JiFenXiLianRequire"]:setXY(jfVal_x + 25, jfVal_y)
					_frmNode.childUI["CostXiLianSummary"]:setText(string.format(hVar.tab_string["__TEXT_XILIAN_COSTKESHI"], JifenRequire, goldRequire))
					_frmNode.childUI["XiLian_GoldIcon"].handle._n:setVisible(true)
					_frmNode.childUI["GoldXiLianRequire"].handle._n:setVisible(true)
					
					--不显示今日锁孔次数的文字(消耗金币)
					_frmNode.childUI["XiLian_DayLimitPrefix"].handle._n:setVisible(true)
					_frmNode.childUI["XiLian_DayLimitLabel"].handle._n:setVisible(true)
					_frmNode.childUI["XiLian_DayLimitLabel"]:setText(todayLockXilianTimes)
					_frmNode.childUI["XiLian_DayLimitPostfix"].handle._n:setVisible(true)
					
					--洗炼为负数说明没限制
					if (todayLockXilianTimes < 0) then
						--不显示今日锁孔次数的文字(无限制)
						_frmNode.childUI["XiLian_DayLimitPrefix"].handle._n:setVisible(false)
						_frmNode.childUI["XiLian_DayLimitLabel"].handle._n:setVisible(false)
						_frmNode.childUI["XiLian_DayLimitPostfix"].handle._n:setVisible(false)
					end
				end
				
				if (currentScore >= JifenRequire) and (currentGold >= goldRequire) then --积分、金币足够
					--锁孔洗炼，今日次数用完
					if (lockSlotSum > 0) and (todayLockXilianTimes == 0) then
						hApi.AddShader(_frmNode.childUI["btnXiLian"].handle.s, "gray")
					else
						hApi.AddShader(_frmNode.childUI["btnXiLian"].handle.s, "normal")
					end
				else
					hApi.AddShader(_frmNode.childUI["btnXiLian"].handle.s, "gray")
				end
			end
		end
		
		--更新芯片总数量
		local chipNum = LuaGetPlayerChip()
		_frmNode.childUI["labelChipNum"]:setText(chipNum)
	end
	
	--显示锁孔按钮的tip
	OnClickShowLockXiLianItemSlotTip = function(slotPos)
		--如果没有洗炼道具，不响应操作
		if (current_xilian_itemIdx == 0) then
			return
		end
		
		--如果点击的孔的位置超出该道具的孔的数量，不响应操作
		--[[
		local item = 0
		if (current_xilian_oHero == 0) then --背包的道具
			item = Save_PlayerData.bag[current_xilian_itemIdx]
		else --英雄身上的装备道具
			--item = current_xilian_oHero.data.equipment[current_xilian_itemIdx]
			local herocard = Save_PlayerData.herocard
			for i = 1, #herocard, 1 do
				if (herocard[i].id == current_xilian_oHero.data.id) then
					item = herocard[i].equipment[current_xilian_itemIdx]
					break
				end
			end
		end
		]]
		local item = current_xilian_itemIdx
		local rewardEx = item[hVar.ITEM_DATA_INDEX.SLOT]
		local upCount = 0 --有效的孔的数量
		if rewardEx and (type(rewardEx) == "table") then
			for j = 1, #rewardEx, 1 do
				local attr = rewardEx[j] --孔的属性（字符串）
				local attrVal = hVar.ITEM_ATTR_VAL[attr] --对应的孔的属性表
				if attrVal then
					--本条是有效的孔数据
					upCount = upCount + 1
				end
			end
		end
		if (slotPos > upCount) then
			return
		end
		
		--如果当前是锁孔操作，并且没有剩余的锁孔了，那么也不响应操作
		if (current_xilian_item_lock_state[slotPos] == 0) then
			local lockSlotSum = 0 --当前锁孔的数量和
			for i = 1, #current_xilian_item_lock_state, 1 do
				lockSlotSum = lockSlotSum + current_xilian_item_lock_state[i]
			end
			if (lockSlotSum >= (upCount - 1)) then
				--洗炼需要至少一条属性
				return
			end
		end
		
		--点击的孔的位置是有效的
		--开始显示锁孔的tip
		local _frm = hGlobal.UI.PhoneItemFrm_Mini
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		local xilianBoxCtrl = _frmNode.childUI["XiLian_SelectBox" .. slotPos]
		local xilianBox_x = xilianBoxCtrl.data.x
		local xilianBox_y = xilianBoxCtrl.data.y
		_frmNode.childUI["XiLianSlotTip"] = hUI.button:new({
			parent = _parentNode,
			--model = "UI:Tactic_Selected",
			model = "UI:Button_SelectBorder",
			x = xilianBox_x,
			y = xilianBox_y,
			w = 1,
			h = 1,
			z = 101,
		})
		_frmNode.childUI["XiLianSlotTip"].handle.s:setOpacity(0) --作为父控件用，不显示
		
		--创建说明，提示该洗炼道具锁孔简介
		local __parent = _frmNode.childUI["XiLianSlotTip"]
		local __parentHandle = __parent.handle._n
		local xOffset = 0
		local yOffset = 100
		
		--洗炼道具简介背景框
		--[[
		__parent.childUI["imgBg"] = hUI.image:new({
			parent = __parentHandle,
			model = "UI:TacticBG",
			x = xOffset,
			y = yOffset,
			w = 320,
			h = 60,
			align = "MC",
		})
		__parent.childUI["imgBg"].handle.s:setOpacity(214) --道具卖出说明tip透明度为214
		]]
		local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", xOffset, yOffset, 320, 60, __parent)
		img9:setOpacity(204)
		
		--创建洗炼锁孔的说明
		__parent.childUI["labxilianSlotHint"] = hUI.label:new({
			parent = __parentHandle,
			size = 26,
			align = "LT",
			border = 1,
			x = xOffset - 145,
			y = yOffset + 12,
			--font = hVar.FONTC,
			font = hVar.FONTC,
			width = 600,
			--text = "锁定本条属性，不被重洗", --language
			text = hVar.tab_string["__ITEM_PANEL__LOCK_THIS_SLOT"], --language
		})
		__parent.childUI["labxilianSlotHint"].handle.s:setColor(ccc3(255, 255, 255))
		if (current_xilian_item_lock_state[slotPos] == 1) then
			--__parent.childUI["labxilianSlotHint"]:setText("取消锁定本条属性") --language
			__parent.childUI["labxilianSlotHint"]:setText(hVar.tab_string["__ITEM_PANEL__UNLOCK_THIS_SLOT"]) --language
			__parent.childUI["labxilianSlotHint"].handle.s:setColor(ccc3(212, 212, 212))
		end
	end
	
	--函数：点击锁孔按钮的逻辑
	OnClickLockXiLianItemSlot = function(slotPos)
		--如果没有洗炼道具，不响应操作
		if (current_xilian_itemIdx == 0) then
			return
		end
		
		--如果点击的孔的位置超出该道具的孔的数量，不响应操作
		--[[
		local item = 0
		if (current_xilian_oHero == 0) then --背包的道具
			item = Save_PlayerData.bag[current_xilian_itemIdx]
		else --英雄身上的装备道具
			--item = current_xilian_oHero.data.equipment[current_xilian_itemIdx]
			local herocard = Save_PlayerData.herocard
			for i = 1, #herocard, 1 do
				if (herocard[i].id == current_xilian_oHero.data.id) then
					item = herocard[i].equipment[current_xilian_itemIdx]
					break
				end
			end
		end
		]]
		local item = current_xilian_itemIdx
		local rewardEx = item[hVar.ITEM_DATA_INDEX.SLOT]
		local upCount = 0 --有效的孔的数量
		if rewardEx and (type(rewardEx) == "table") then
			for j = 1, #rewardEx, 1 do
				local attr = rewardEx[j] --孔的属性（字符串）
				local attrVal = hVar.ITEM_ATTR_VAL[attr] --对应的孔的属性表
				if attrVal then
					--本条是有效的孔数据
					upCount = upCount + 1
				end
			end
		end
		if (slotPos > upCount) then
			return
		end
		
		--如果当前是锁孔操作，并且没有剩余的锁孔了，那么也不响应操作
		if (current_xilian_item_lock_state[slotPos] == 0) then
			local lockSlotSum = 0 --当前锁孔的数量和
			for i = 1, #current_xilian_item_lock_state, 1 do
				lockSlotSum = lockSlotSum + current_xilian_item_lock_state[i]
			end
			if (lockSlotSum >= (upCount - 1)) then
				--洗炼需要至少一条属性
				return
			end
		end
		
		--点击的孔的位置是有效的
		local _frm = hGlobal.UI.PhoneItemFrm_Mini
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		if (current_xilian_item_lock_state[slotPos] == 0) then --当前未锁孔
			current_xilian_item_lock_state[slotPos] = 1
			
			--动画表现
			local act1 = CCCallFunc:create(function()
				_frmNode.childUI["XiLian_GouGou" .. slotPos].handle._n:setVisible(true)
				
				--更新洗炼道具信息
				RefreshXilianItemInfo_Mini()
				
				--更新洗炼道具价格和按钮控件
				RefreshXiLianItemNoteFrm_Mini()
			end)
			local act2 = CCScaleTo:create(0.03, 1.0)
			local sequence = CCSequence:createWithTwoActions(act1, act2)
			_frmNode.childUI["XiLian_GouGou" .. slotPos].handle._n:runAction(sequence)
		else --当前是锁孔
			current_xilian_item_lock_state[slotPos] = 0
			
			--动画表现
			local act1 = CCScaleTo:create(0.03, 0.01)
			local act2 = CCCallFunc:create(function()
				_frmNode.childUI["XiLian_GouGou" .. slotPos].handle._n:setVisible(false)
				
				--更新洗炼道具信息
				RefreshXilianItemInfo_Mini()
				
				--更新洗炼道具价格和按钮控件
				RefreshXiLianItemNoteFrm_Mini()
			end)
			local sequence = CCSequence:createWithTwoActions(act1, act2)
			_frmNode.childUI["XiLian_GouGou" .. slotPos].handle._n:runAction(sequence)
		end
	end
	
	--函数：刷新洗炼道具的信息
	RefreshXilianItemInfo_Mini = function()
		local _frm = hGlobal.UI.PhoneItemFrm_Mini
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		if (current_xilian_itemIdx == 0) then --没有洗炼道具
			--隐藏所有的洗炼属性控件
			for i = 1, 4, 1 do
				_frmNode.childUI["XiLian_ImageBG" .. i].handle.s:setVisible(true) --显示属性条的背景图
				_frmNode.childUI["XiLian_ImageBG_Lock" .. i].handle.s:setVisible(false) --隐藏属性条的背景图（锁定）
				
				_frmNode.childUI["XiLian_Diamond" .. i].handle.s:setVisible(false) --不显示钻石图标
				_frmNode.childUI["XiLian_Attr" .. i]:setText("") --不显示卡槽的属性文字
				_frmNode.childUI["XiLian_SelectBox" .. i].handle.s:setVisible(false) --不显示锁定的选择框图片
				_frmNode.childUI["XiLian_GouGou" .. i].handle._n:setVisible(false) --不显示锁定的选中的勾勾图片
				_frmNode.childUI["XiLian_Lock" .. i].handle._n:setVisible(false) --不显示锁定的锁的图标
				--_frmNode.childUI["XiLian_LockLabel" .. i]:setText("") --不显示“锁定”文字
			end
			
			--删除重铸按钮
			hApi.safeRemoveT(_frmNode.childUI, "btnRebuild")
		else --存在洗炼道具
			--print("current_xilian_oHero", current_xilian_oHero)
			--[[
			local item = 0
			if (current_xilian_oHero == 0) then --背包的道具
				item = Save_PlayerData.bag[current_xilian_itemIdx]
			else --英雄身上的装备道具
				--item = current_xilian_oHero.data.equipment[current_xilian_itemIdx]
				local herocard = Save_PlayerData.herocard
				for i = 1, #herocard, 1 do
					if (herocard[i].id == current_xilian_oHero.data.id) then
						item = herocard[i].equipment[current_xilian_itemIdx]
						break
					end
				end
			end
			]]
			local item = current_xilian_itemIdx
			local itemId = item[1] --道具id
			local itemLv = hVar.tab_item[itemId].itemLv or 1
			local rewardEx = item[hVar.ITEM_DATA_INDEX.SLOT]
			local upCount = 0 --有效的孔的数量
			
			--绘制出当前的有效孔
			if rewardEx and (type(rewardEx) == "table") then
				for j = 1, #rewardEx, 1 do
					local attr = rewardEx[j] --孔的属性（字符串）
					local attrVal = hVar.ITEM_ATTR_VAL[attr] --对应的孔的属性表
					if attrVal then
						local temptext = "" --要显示的属性字符串描述
						
						if (attrVal.attrAdd == "atk") then --道具属性为攻击力，读取最小攻击力和最大攻击力
							local miniAtk, maxAtk = attrVal.value1, attrVal.value2
							temptext = miniAtk .. " - " .. maxAtk
						else --其它属性，只读第一个数值
							temptext = attrVal.value1
							
							local sign = nil --正负号
							local u_value = math.abs(attrVal.value1) --无符号的值
							--百分号
							if (hVar.ItemRewardMillinSecondMode[attrVal.attrAdd] == 1) then
								u_value = u_value / 1000
							end
							if (attrVal.value1 >= 0) then
								sign = "＋"
							else
								sign = "－"
							end
							
							if (attrVal.attrAdd == "atk_interval") then --攻击间隔
								local floorvalue = u_value / 1000
								local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
								--temptext = sign .. szfloorvalue .. "秒" --language
								temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
							elseif (attrVal.attrAdd == "rebirth_time") then --复活时间
								local floorvalue = u_value / 1000
								local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
								--temptext = sign .. szfloorvalue .. "秒" --language
								temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
							elseif (attrVal.attrAdd == "AI_attribute") then --AI行为
								if (attrVal.value1 == 1) then
									--temptext = "主动攻击" --language
									temptext = hVar.tab_string["__Attr_Hint_active_attack"] --language
								else
									--temptext = "不主动攻击" --language
									temptext = hVar.tab_string["__Attr_Hint_passive_attack"] --language
								end
							elseif (attrVal.attrAdd == "kill_gold") then --击杀奖励金币
								--temptext = sign .. u_value .. "金" --language
								temptext = sign .. u_value .. hVar.tab_string["gold"] --language
							elseif (attrVal.attrAdd == "escape_punish") then --逃怪惩罚
								--temptext = sign .. u_value .. "生命" --language
								temptext = sign .. u_value .. hVar.tab_string["blood"] --language
							elseif (attrVal.attrAdd == "active_skill_cd_delta") then --主动技能冷却时间变化值（毫秒）
								local floorvalue = u_value / 1000
								local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
								--temptext = sign .. szfloorvalue .. "秒" --language
								temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
							elseif (attrVal.attrAdd == "passive_skill_cd_delta") then --被动技能冷却时间变化值（毫秒）
								local floorvalue = u_value / 1000
								local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
								--temptext = sign .. szfloorvalue .. "秒" --language
								temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
							elseif (attrVal.attrAdd == "active_skill_cd_delta_rate") then --主动技能冷却时间变化比例值（去百分号后的值）
								temptext = sign .. u_value
							elseif (attrVal.attrAdd == "passive_skill_cd_delta_rate") then --被动技能冷却时间变化比例值（去百分号后的值）
								temptext = sign .. u_value
							elseif (attrVal.attrAdd == "hp_restore_delta_rate") then --回血倍率比例值（去百分号后的值）
								temptext = sign .. u_value
							elseif (attrVal.attrAdd == "crit_value") then --暴击倍数（支持小数）
								--local szfloorvalue = string.format("%.1f", u_value) --保留1位有效数字
								local szfloorvalue = u_value * 100
								--temptext = sign .. szfloorvalue .. "倍" --language
								temptext = sign .. szfloorvalue .. hVar.tab_string["__Rate"] --language
							elseif (attrVal.attrAdd == "crit_immue") then --暴击免伤
								temptext = sign .. u_value
							else
								temptext = sign .. u_value
							end
							
							--百分比显示
							if (hVar.ItemRewardStrMode[attrVal.attrAdd] == 1) then
								temptext = temptext .. "％"
							end
						end
						
						--本条是有效的孔数据
						upCount = upCount + 1
						
						local rname = hVar.tab_string[attrVal.strTip] --属性的中文描述
						--local rgb = hVar.ITEMLEVEL[attrVal.quality].NAMERGB --属性颜色
						local rgb = hVar.ITEM_ATTR_CHIP_COLOR_DEF[attrVal.quality]
						local chipModel = hVar.ITEM_ATTR_CHIP_IMG_DEF[attrVal.quality]
						
						--更新绘制本条孔属性
						_frmNode.childUI["XiLian_Diamond" .. upCount].handle.s:setVisible(true) --显示钻石图标
						_frmNode.childUI["XiLian_Diamond" .. upCount]:setmodel(chipModel)
						_frmNode.childUI["XiLian_Attr" .. upCount]:setText(rname .. " " .. temptext) --显示卡槽的属性文字
						_frmNode.childUI["XiLian_Attr" .. upCount].handle.s:setColor(ccc3(rgb[1], rgb[2], rgb[3]))
						--_frmNode.childUI["XiLian_SelectBox" .. upCount].handle.s:setVisible(true) --显示锁定的选择框图片
						
						--如果该条属性被锁定，那么显示锁定标识
						if (current_xilian_item_lock_state[upCount] == 1) then --已锁定
							_frmNode.childUI["XiLian_ImageBG" .. upCount].handle.s:setVisible(false) --显示属性条的背景图
							_frmNode.childUI["XiLian_ImageBG_Lock" .. upCount].handle.s:setVisible(true) --隐藏属性条的背景图（锁定）
							
							_frmNode.childUI["XiLian_GouGou" .. upCount].handle._n:setVisible(true) --显示锁定的选中的勾勾图片
							_frmNode.childUI["XiLian_SelectBox" .. upCount].handle._n:setVisible(false) --开锁图标
							_frmNode.childUI["XiLian_Lock" .. upCount].handle._n:setVisible(true) --显示锁定的锁的图标
							--_frmNode.childUI["XiLian_LockLabel" .. upCount]:setText("锁定") --显示“锁定”文字 --language
							--_frmNode.childUI["XiLian_LockLabel" .. upCount]:setText(hVar.tab_string["__ITEM_PANEL__LOCK"]) --显示“锁定”文字 --language
						else --未锁定
							_frmNode.childUI["XiLian_ImageBG" .. upCount].handle.s:setVisible(true) --显示属性条的背景图
							_frmNode.childUI["XiLian_ImageBG_Lock" .. upCount].handle.s:setVisible(false) --隐藏属性条的背景图（锁定）
							
							_frmNode.childUI["XiLian_GouGou" .. upCount].handle._n:setVisible(false) --不显示锁定的选中的勾勾图片
							_frmNode.childUI["XiLian_SelectBox" .. upCount].handle._n:setVisible(true) --开锁图标
							_frmNode.childUI["XiLian_Lock" .. upCount].handle._n:setVisible(false) --不显示锁定的锁的图标
							--_frmNode.childUI["XiLian_LockLabel" .. upCount]:setText("") --不显示“锁定”文字
						end
					end
				end
			end
			
			--后面的孔，不显示
			for i = upCount + 1, 4, 1 do
				_frmNode.childUI["XiLian_ImageBG" .. i].handle.s:setVisible(false) --不显示属性条的背景图
				_frmNode.childUI["XiLian_ImageBG_Lock" .. i].handle.s:setVisible(false) --隐藏属性条的背景图（锁定）
				
				_frmNode.childUI["XiLian_Diamond" .. i].handle.s:setVisible(false) --不显示钻石图标
				_frmNode.childUI["XiLian_Attr" .. i]:setText("") --不显示卡槽的属性文字
				_frmNode.childUI["XiLian_SelectBox" .. i].handle.s:setVisible(false) --不显示锁定的选择框图片
				_frmNode.childUI["XiLian_GouGou" .. i].handle._n:setVisible(false) --不显示锁定的选中的勾勾图片
				_frmNode.childUI["XiLian_Lock" .. i].handle._n:setVisible(false) --不显示锁定的锁的图标
				--_frmNode.childUI["XiLian_LockLabel" .. i]:setText("") --不显示“锁定”文字
			end
			
			--删除旧的重铸按钮
			hApi.safeRemoveT(_frmNode.childUI, "btnRebuild")
			
			--如果当前已经不能再锁孔了，那么第一个未锁孔的位置的盒子图标，也不显示
			local lockSlotSum = 0 --当前锁孔的数量和
			for i = 1, #current_xilian_item_lock_state, 1 do
				lockSlotSum = lockSlotSum + current_xilian_item_lock_state[i]
			end
			if (lockSlotSum >= (upCount - 1)) then --只剩一条属性未锁了，这条属性的边框不显示
				local notShowPos = 0 --不显示的位置
				for i = 1, #current_xilian_item_lock_state, 1 do
					if (current_xilian_item_lock_state[i] == 0) then
						notShowPos = i
						break
					end
				end
				--geyachao: 战车不隐藏锁
				--_frmNode.childUI["XiLian_SelectBox" .. notShowPos].handle.s:setVisible(false) --不显示锁定的选择框图片
			end
			
			--检查孔的数量是否到达了本道具品质的上限数量
			--没到上限，后面的空孔显示背景图，并且第一条空孔可以重铸
			--神器不显示后面的了
			local slotMaxNum = hVar.ITEM_ATTR_EX_LIMIT[itemLv] --该品质道具的孔的数量上限
			if (upCount < slotMaxNum) then
				--后面的空孔显示背景图
				for i = upCount + 1, slotMaxNum, 1 do
					_frmNode.childUI["XiLian_ImageBG" .. i].handle.s:setVisible(false) --显示属性条的背景图
					_frmNode.childUI["XiLian_Attr" .. i]:setText("") --显示卡槽的属性文字
					_frmNode.childUI["XiLian_Attr" .. i].handle.s:setColor(ccc3(96, 96, 96))
				end
			end
		end
	end
	
	--函数：关闭本界面
	OnClosePanel = function()
		local _frm = hGlobal.UI.PhoneItemFrm_Mini
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--不显示道具简易操作面板
		hGlobal.UI.PhoneItemFrm_Mini:show(0)
		
		--关闭界面后不需要监听的事件
		--移除事件监听：横竖屏切换事件
		hGlobal.event:listen("LocalEvent_SpinScreen", "__SpinScreen_XiLian", nil)
		
		--取消监听：道具洗炼结果刷新本界面
		hGlobal.event:listen("Local_Event_ItemXiLian_Result_Red_Equip", "__ItemXiLianSuccess_Frm_Mini", nil)
		
		--清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
	end
	
	--函数：创建洗炼道具图标按钮
	OnCreateXiLianItemBtn_Mini = function(oHero, oItem)
		local _frm = hGlobal.UI.PhoneItemFrm_Mini
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		
		--标记洗炼道具的索引值
		current_xilian_oHero = oHero or 0 --当前洗炼道具的英雄
		current_xilian_itemIdx = oItem
		current_xilian_item_lock_state = {0, 0, 0, 0} --当前洗炼道具孔锁住的标记
		
		--[[
		local item = 0
		if (current_xilian_oHero == 0) then --背包的道具
			item = Save_PlayerData.bag[current_xilian_itemIdx]
		else --英雄身上的装备道具
			--item = current_xilian_oHero.data.equipment[current_xilian_itemIdx]
			local herocard = Save_PlayerData.herocard
			for i = 1, #herocard, 1 do
				if (herocard[i].id == current_xilian_oHero.data.id) then
					item = herocard[i].equipment[current_xilian_itemIdx]
					break
				end
			end
		end
		]]
		local item = oItem
		local itemId = item[1]
		local xilianChip_x = _frmNode.childUI["XiLianChip"].data.x
		local xilianChip_y = _frmNode.childUI["XiLianChip"].data.y
		local to_x = xilianChip_x
		local to_y = xilianChip_y
		local itemLv = hVar.tab_item[itemId].itemLv or 1
		local itemModel = hVar.ITEMLEVEL[itemLv].BACKMODEL --模型
		--if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
		--	itemModel = "ICON:Back_red2"
		--end
		
		--绘制洗炼道具图标（按钮响应）
		_frmNode.childUI["XiLianItem"] = hUI.button:new({
			parent = _parentNode,
			--model = "UI:SkillSlot",
			model = itemModel,
			x = to_x,
			y = to_y + 5,
			w = ITEM_ICON_EDGE - 2,
			h = ITEM_ICON_EDGE - 2,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 1.0,
			failcall = 1,
			z = 100,
			
			--按下出售道具图标事件
			codeOnTouch = function(self, touchX, touchY, sus)
				--显示选中框
				self.childUI["selectbox"] = hUI.image:new({
					parent = self.handle._n,
					model = "UI:Tactic_Selected",
					x = 0,
					y = 0,
					w = ITEM_ICON_EDGE,
					h = ITEM_ICON_EDGE,
				})
			end,
			
			--滑动出售道具图标事件
			codeOnDrag = function(self, touchX, touchY, sus)
				if (sus == 1) then --在内部，显示选中框
					self.childUI["selectbox"].handle.s:setVisible(true)
				else --在外部，不显示选中框
					self.childUI["selectbox"].handle.s:setVisible(false)
				end
			end,
			
			--抬起出售道具图标事件
			code = function(self, touchX, touchY, sus)
				--删除选中框
				hApi.safeRemoveT(self.childUI, "selectbox") --选中框
				
				--如果在内部，那么显示道具tip
				if (sus == 1) then
					--显示道具tip
					--local itemtipX = 350 + (hVar.SCREEN.w - 1024) / 2 --适配其他分辨率
					--local itemTipY = 724 + (hVar.SCREEN.h - 768) / 2 --适配其他分辨率
					--hGlobal.event:event("LocalEvent_ShowItemTipFram", {item}, nil, 1, itemtipX, itemTipY, 0)
					hGlobal.event:event("localEvent_ShowItemTipFrm", item)
				end
			end,
		})
		
		--_frmNode.childUI["XiLianItem"].handle.s:setOpacity(155) --设置道具背景默认灰度
		--if (hVar.tab_item[itemId].isArtifact == 1) then --神器边框换个图
		--	_frmNode.childUI["XiLianItem"].handle.s:setOpacity(192) --神器更亮些
		--end
		
		_frmNode.childUI["XiLianItem"].data.index = sellIdx --标记它自身的索引值
		_frmNode.childUI["XiLianItem"].data.bagIndex = bagIdx --标记背包的索引值
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLianItem"
		
		--绘制洗炼道具图标
		_frmNode.childUI["XiLianItem"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["XiLianItem"].handle._n,
			model = hVar.tab_item[itemId].icon,
			x = 0,
			y = 0,
			w = ITEM_ICON_EDGE - 6,
			h = ITEM_ICON_EDGE - 6,
		})
		
		--刷新洗炼道具信息界面
		RefreshXilianItemInfo_Mini()
		
		--刷新洗炼道具价格和按钮控件
		RefreshXiLianItemNoteFrm_Mini()
	end
	
	--函数：洗炼道具逻辑
	OnXiLianItemFunc = function()
		--如果没有洗炼道具，直接返回
		if (current_xilian_itemIdx == 0) then
			return
		end
		
		--未联网不能使用道具洗炼功能
		if (g_cur_net_state == -1) then
			hGlobal.UI.MsgBox(hVar.tab_string["__TEXT_Cant_XiLianItem_Net"], {
				font = hVar.FONTC,
				ok = function()
					--self:setstate(1)
				end,
			})
			
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
		
		--检查洗炼道具是否为装备
		--[[
		local item = 0
		if (current_xilian_oHero == 0) then --背包的道具
			item = Save_PlayerData.bag[current_xilian_itemIdx]
		else --英雄身上的装备道具
			--item = current_xilian_oHero.data.equipment[current_xilian_itemIdx]
			local herocard = Save_PlayerData.herocard
			for i = 1, #herocard, 1 do
				if (herocard[i].id == current_xilian_oHero.data.id) then
					item = herocard[i].equipment[current_xilian_itemIdx]
					break
				end
			end
		end
		]]
		local item = current_xilian_itemIdx
		local itemId =  item[1] --洗炼道具id
		local itemLv = hVar.tab_item[itemId].itemLv or 1 --道具等级
		if (not hApi.CheckItemIsEquip(itemId)) then
			--弹框
			--local strText = "只有装备才能进行洗炼" --language
			local strText = hVar.tab_string["__TEXT_Cant_XiLianItem2_Net"] --language
			hGlobal.UI.MsgBox(strText, {
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			return
		end
		
		--检查该品质的道具是否可以洗炼
		if(hVar.ITEM_ATTR_EX_LIMIT[itemLv] <= 0) then
			--弹框
			--local strText = "白装不能洗炼" --language
			local strText = hVar.tab_string["__TEXT_Cant_XiLianItem3_Net"] --language
			hGlobal.UI.MsgBox(strText, {
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			return
		end
		
		--检查是否有可以洗炼的孔
		local rewardEx = item[hVar.ITEM_DATA_INDEX.SLOT]
		local upCount = 0 --有效的孔的数量
		if rewardEx and (type(rewardEx) == "table") then
			for j = 1, #rewardEx, 1 do
				local attr = rewardEx[j] --孔的属性（字符串）
				local attrVal = hVar.ITEM_ATTR_VAL[attr] --对应的孔的属性表
				if attrVal then
					--本条是有效的孔数据
					upCount = upCount + 1
				end
			end
		end
		local lockSlotSum = 0 --当前锁孔的数量和
		for i = 1, #current_xilian_item_lock_state, 1 do
			lockSlotSum = lockSlotSum + current_xilian_item_lock_state[i]
		end
		if (lockSlotSum >= upCount) then
			--弹框
			--local strText = "洗炼需要至少一条属性" --language
			local strText = hVar.tab_string["__TEXT_Cant_XiLianRequireAtLeastOneSlot_Net"] --language
			hGlobal.UI.MsgBox(strText, {
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			return
		end
		
		--如果有锁孔，检测本装备今日锁孔洗炼次数是否用完
		if (lockSlotSum > 0) then
			local todayLockXilianTimes = LuaGetTodayXilianLimitCout(item) --今日锁孔洗炼的次数
			if (todayLockXilianTimes == 0) then
				--弹框
				--local strText = "该装备今日锁孔洗炼次数已用完，不能继续锁孔！" --language
				local strText = hVar.tab_string["__TEXT_TodayLockXiLianUsedUp"] --language
				hGlobal.UI.MsgBox(strText, {
					font = hVar.FONTC,
					ok = function()
					end,
				})
				
				return
			end
		end
		
		--神器检测格式是否正确
		local itemMain_dbid = 0
		local fromMain = item[hVar.ITEM_DATA_INDEX.FROM]
		--print("fromMain=", fromMain)
		if (type(fromMain) == "table") then
			for k = 1, #fromMain, 1 do
				--print("fromMain[" .. k .. "]=", fromMain[k])
				if (type(fromMain[k]) == "table") then
					--print("fromMain[k][1]=", fromMain[k][1])
					if (fromMain[k][1] == hVar.ITEM_FROMWHAT_TYPE.NET) then
						itemMain_dbid = fromMain[k][2]
						break
					end
				end
			end
		end
		
		--检查神器是否从非法途径获得
		if (itemMain_dbid == 0) then
			--弹框
			--local strText = "神器来源未知" --language
			local strText = hVar.tab_string["__TEXT_XiLianInvalidUID"] --language
			hGlobal.UI.MsgBox(strText, {
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			return
		end
		
		--计算积分是否足够
		--[[
		local item = 0
		if (current_xilian_oHero == 0) then --背包的道具
			item = Save_PlayerData.bag[current_xilian_itemIdx]
		else --英雄身上的装备道具
			--item = current_xilian_oHero.data.equipment[current_xilian_itemIdx]
			local herocard = Save_PlayerData.herocard
			for i = 1, #herocard, 1 do
				if (herocard[i].id == current_xilian_oHero.data.id) then
					item = herocard[i].equipment[current_xilian_itemIdx]
					break
				end
			end
		end
		]]
		local item = current_xilian_itemIdx
		local itemLv = hVar.tab_item[itemId].itemLv or 1
		local JifenRequire = hVar.ITEM_XILIAN_INFO[itemLv].cost
		if (type(JifenRequire) == "table") then --红装？
			JifenRequire = JifenRequire[upCount]
		end
		
		local currentScore = LuaGetPlayerChip() --玩家当前的积分
		if (currentScore < JifenRequire) then
			--弹框
			--local strText = "芯片不足！" --language
			local strText = hVar.tab_string["__TEXT_ChipNotEnough"] --language
			hGlobal.UI.MsgBox(strText, {
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			return
		end
		
		--计算金币是否足够
		local goldRequire = hApi.GetItemLockInfo(lockSlotSum)
		local currentGold = LuaGetPlayerRmb() --玩家当前游戏币
		if (currentGold < goldRequire) then
			--弹框
			--local strText = "游戏币不足" --language
			local strText = hVar.tab_string["ios_not_enough_game_coin"] --language
			hGlobal.UI.MsgBox(strText, {
				font = hVar.FONTC,
				ok = function()
				end,
			})
			
			return
		end
		
		--触发洗炼事件
		local xilianoUnit = current_xilian_oHero --洗炼的英雄
		--local xilianItemIdx = current_xilian_itemIdx --洗炼的道具
		local slotPosList = {} --要洗炼的位置列表
		local slotLockList = {} --要锁定的位置列表
		local s_num_i = 0 --孔的数量i
		if rewardEx and (type(rewardEx) == "table") then
			for j = 1, #rewardEx, 1 do --j代表实际的孔的表的索引位置
				local attr = rewardEx[j] --孔的属性（字符串）
				local attrVal = hVar.ITEM_ATTR_VAL[attr] --对应的孔的属性表
				if attrVal then
					--本条是有效的孔数据
					s_num_i = s_num_i + 1
					if (current_xilian_item_lock_state[s_num_i] == 1) then --已锁定
						table.insert(slotLockList, j)
					else --未锁定
						table.insert(slotPosList, j)
					end
				end
			end
		end
		
		--如果不消耗金币，直接洗炼
		if (goldRequire == 0) then
			--挡操作
			hUI.NetDisable(30000)
			
			--红装洗练(需要洗练的装备dbid,锁孔的数量,锁孔的位置列表（位置索引从1开始）)
			--itemDbid,lockNum,lockIdxList
			SendCmdFunc["xilian_redequip"](itemMain_dbid, #slotLockList, slotLockList)
		else
			--今日锁孔洗炼次数减1
			local num = LuaGetTodayXilianLimitCout(item)
			LuaSetTodayXilianLimitCout(item, num - 1)
			
			--挡操作
			hUI.NetDisable(30000)
			
			--红装洗练(需要洗练的装备dbid,锁孔的数量,锁孔的位置列表（位置索引从1开始）)
			--itemDbid,lockNum,lockIdxList
			SendCmdFunc["xilian_redequip"](itemMain_dbid, #slotLockList, slotLockList)
		end
	end
	
	--函数：查看道具洗炼分页说明tip
	OnCreateItemXiLianTipFrame = function()
		--创建装备洗炼介绍tip
		local itemXiLianTip = hUI.uiTip:new()
		--itemXiLianTip:AddIcon("misc/chest/zhuli.png")
		itemXiLianTip:AddTitle(hVar.tab_string["__ITEM_PANEL__XILIAN_TIP_TITLE"], ccc3(255, 173, 65)) --"装备洗炼介绍"
		itemXiLianTip:AddContent(hVar.tab_string["__ITEM_PANEL__XILIAN_TIP_1"]) --"1、装备洗炼可以重洗装备孔的属性。"
		itemXiLianTip:AddContent(hVar.tab_string["__ITEM_PANEL__XILIAN_TIP_2"]) --"2、锁定某条属性后，该条属性不会被重洗。"
		itemXiLianTip:AddContent(hVar.tab_string["__ITEM_PANEL__XILIAN_TIP_3"]) --"3、装备打孔，为本装备新加一个孔。-4孔随机，无法解锁新属性。"
		itemXiLianTip:AddContent(hVar.tab_string["__ITEM_PANEL__XILIAN_TIP_4"]) --"4、装备品质越高，孔的数量上限越多。"
		itemXiLianTip:AddContent(hVar.tab_string["__ITEM_PANEL__XILIAN_TIP_5"]) --"5、孔属性档次依次为：白色、蓝色、黄色、橙色、红色。"
		itemXiLianTip:SetTitleCentered()
	end
	
	--函数：道具洗炼动画
	PlayItemXiLianAnimation = function(retCallback)
		local _frm = hGlobal.UI.PhoneItemFrm_Mini
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--在播放动画前，创建一个全屏幕的控件，挡操作
		_frmNode.childUI["NoOp"] = hUI.button:new({
			parent = _parentNode,
			model = "UI:SkillSlot",
			x = hVar.SCREEN.w / 2,
			y = -hVar.SCREEN.h / 2,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
			z = 99999,
			dragbox = _frm.childUI["dragBox"],
			code = function()
				--用于挡操作的事件
			end,
		})
		_frmNode.childUI["NoOp"].handle.s:setOpacity(0) --用于挡操作，不显示
		
		--芯片动画
		local xilian_x, xilian_y = _frmNode.childUI["btnXiLian"].data.x - 10, _frmNode.childUI["btnXiLian"].data.y + 477
		_frmNode.childUI["btnChip"] = hUI.image:new({
			parent = _parentNode,
			model = "MODEL_EFFECT:ChipForge",
			x = xilian_x,
			y = xilian_y,
			scale = 1.0,
		})
		local waittime = 0.56
		--播放动画
		local array = CCArray:create()
		array:addObject(CCDelayTime:create(waittime))
		array:addObject(CCCallFunc:create(function() --回调2
			hApi.safeRemoveT(_frmNode.childUI, "btnChip")
			
			--播放道具洗炼的音效
			hApi.PlaySound("magic4")
		end))
		_frmNode.childUI["btnChip"].handle._n:runAction(CCSequence:create(array)) --action
		
		--动画相关参数
		local OnAllActionEnd = nil --动画完成的回调
		local actionNum = 0 --动画的总数量
		local actionFinishNum = 0 --动画完成的数量
		
		--找出哪些属性是重洗的
		--[[
		local item = 0
		if (current_xilian_oHero == 0) then --背包的道具
			item = Save_PlayerData.bag[current_xilian_itemIdx]
		else --英雄身上的装备道具
			--item = current_xilian_oHero.data.equipment[current_xilian_itemIdx]
			local herocard = Save_PlayerData.herocard
			for i = 1, #herocard, 1 do
				if (herocard[i].id == current_xilian_oHero.data.id) then
					item = herocard[i].equipment[current_xilian_itemIdx]
					break
				end
			end
		end
		]]
		local item = current_xilian_itemIdx
		local itemId = item[1] --道具id
		local itemLv = hVar.tab_item[itemId].itemLv or 1
		local rewardEx = item[hVar.ITEM_DATA_INDEX.SLOT]
		local upCount = 0 --有效的孔的数量
		local upCountNoLock = 0 --有效的孔的数量（未锁定）
		
		--绘制出变化了孔的属性
		if rewardEx and (type(rewardEx) == "table") then
			for j = 1, #rewardEx, 1 do
				local attr = rewardEx[j] --孔的属性（字符串）
				local attrVal = hVar.ITEM_ATTR_VAL[attr] --对应的孔的属性表
				if attrVal then
					--本条是有效的孔数据
					upCount = upCount + 1
					local currentIdx = upCount
					
					--本条未被锁定，才是属性发生变化、需要动画显示的
					if (current_xilian_item_lock_state[currentIdx] == 0) then
						--动画的数量加1
						actionNum = actionNum + 1
						
						--本条是有效的孔数据（未锁定）
						upCountNoLock = upCountNoLock + 1
						local currentIdxNoLock = upCountNoLock
						
						local temptext = "" --要显示的属性字符串描述
						
						if (attrVal.attrAdd == "atk") then --道具属性为攻击力，读取最小攻击力和最大攻击力
							local miniAtk, maxAtk = attrVal.value1, attrVal.value2
							temptext = miniAtk .. " - " .. maxAtk
						else --其它属性，只读第一个数值
							temptext = attrVal.value1
							
							local sign = nil --正负号
							local u_value = math.abs(attrVal.value1) --无符号的值
							--百分号
							if (hVar.ItemRewardMillinSecondMode[attrVal.attrAdd] == 1) then
								u_value = u_value / 1000
							end
							if (attrVal.value1 >= 0) then
								sign = "＋"
							else
								sign = "－"
							end
							
							if (attrVal.attrAdd == "atk_interval") then --攻击间隔
								local floorvalue = u_value / 1000
								local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
								--temptext = sign .. szfloorvalue .. "秒" --language
								temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
							elseif (attrVal.attrAdd == "rebirth_time") then --复活时间
								local floorvalue = u_value / 1000
								local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
								--temptext = sign .. szfloorvalue .. "秒" --language
								temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
							elseif (attrVal.attrAdd == "AI_attribute") then --AI行为
								if (attrVal.value1 == 1) then
									--temptext = "主动攻击" --language
									temptext = hVar.tab_string["__Attr_Hint_active_attack"] --language
								else
									--temptext = "不主动攻击" --language
									temptext = hVar.tab_string["__Attr_Hint_passive_attack"] --language
								end
							elseif (attrVal.attrAdd == "kill_gold") then --击杀奖励金币
								--temptext = sign .. u_value .. "金" --language
								temptext = sign .. u_value .. hVar.tab_string["gold"] --language
							elseif (attrVal.attrAdd == "escape_punish") then --逃怪惩罚
								--temptext = sign .. u_value .. "生命" --language
								temptext = sign .. u_value .. hVar.tab_string["blood"] --language
							elseif (attrVal.attrAdd == "active_skill_cd_delta") then --主动技能冷却时间变化值（毫秒）
								local floorvalue = u_value / 1000
								local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
								--temptext = sign .. szfloorvalue .. "秒" --language
								temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
							elseif (attrVal.attrAdd == "passive_skill_cd_delta") then --被动技能冷却时间变化值（毫秒）
								local floorvalue = u_value / 1000
								local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
								--temptext = sign .. szfloorvalue .. "秒" --language
								temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
							elseif (attrVal.attrAdd == "active_skill_cd_delta_rate") then --主动技能冷却时间变化比例值（去百分号后的值）
								temptext = sign .. u_value
							elseif (attrVal.attrAdd == "passive_skill_cd_delta_rate") then --被动技能冷却时间变化比例值（去百分号后的值）
								temptext = sign .. u_value
							elseif (attrVal.attrAdd == "hp_restore_delta_rate") then --回血倍率比例值（去百分号后的值）
								temptext = sign .. u_value
							elseif (attrVal.attrAdd == "crit_value") then --暴击倍数（支持小数）
								--local szfloorvalue = string.format("%.1f", u_value) --保留1位有效数字
								local szfloorvalue = u_value * 100
								--temptext = sign .. szfloorvalue .. "倍" --language
								temptext = sign .. szfloorvalue .. hVar.tab_string["__Rate"] --language
							elseif (attrVal.attrAdd == "crit_immue") then --暴击免伤
								temptext = sign .. u_value
							else
								temptext = sign .. u_value
							end
							
							--百分比显示
							if (hVar.ItemRewardStrMode[attrVal.attrAdd] == 1) then
								temptext = temptext .. "％"
							end
						end
						
						local rname = hVar.tab_string[attrVal.strTip] --属性的中文描述
						--local rgb = hVar.ITEMLEVEL[attrVal.quality].NAMERGB --属性颜色
						local rgb = hVar.ITEM_ATTR_CHIP_COLOR_DEF[attrVal.quality]
						
						--表现动画
						local fadeTo = CCFadeTo:create(0.2, 0) --原属性变淡
						
						local delay1 = CCDelayTime:create(0.1 * currentIdxNoLock) --延时1
						
						local callback1 = CCCallFunc:create(function() --回调1
							_frmNode.childUI["XiLian_Attr" .. currentIdx].handle.s:setOpacity(255) --文字重新变亮
							_frmNode.childUI["XiLian_Attr" .. currentIdx]:setText(rname .. " " .. temptext) --显示卡槽的属性文字
							_frmNode.childUI["XiLian_Attr" .. currentIdx].handle.s:setColor(ccc3(rgb[1], rgb[2], rgb[3]))
						end)
						
						--同步动画1：变大+偏移
						local spwan1Time = 0.1
						local scaleToBig = CCScaleTo:create(spwan1Time, 1.3) --变大
						local movebyLeft = CCMoveBy:create(spwan1Time, ccp(-10, 4)) --偏移左
						local spawn1 = CCSpawn:createWithTwoActions(scaleToBig, movebyLeft) --同步1
						
						local delay2 = CCDelayTime:create(0.02) --延时2
						
						--同步动画2：变小+偏移
						local spwan2Time = 0.05
						local scaleToSmall = CCScaleTo:create(spwan2Time, 1.0) --变小
						local movebyRight = CCMoveBy:create(spwan2Time, ccp(10, -4)) --偏移左
						local spawn2 = CCSpawn:createWithTwoActions(scaleToSmall, movebyRight) --同步2
						
						local callback2 = CCCallFunc:create(function() --回调2
							--动画完成的数量加1
							actionFinishNum = actionFinishNum + 1
							
							--所有动画完成，进入结束
							if (actionFinishNum == actionNum) then
								OnAllActionEnd()
							end
						end)
						
						--播放动画
						local array = CCArray:create()
						array:addObject(CCDelayTime:create(waittime))
						array:addObject(fadeTo) --原属性变淡
						array:addObject(delay1) --延时1
						array:addObject(callback1) --回调1
						array:addObject(spawn1) --同步1
						array:addObject(delay2) --延时2
						array:addObject(spawn2) --同步2
						array:addObject(callback2) --回调2
						_frmNode.childUI["XiLian_Attr" .. currentIdx].handle.s:runAction(CCSequence:create(array)) --action
					end
				end
			end
		end
		
		--所有的动画都已完成
		OnAllActionEnd = function()
			--触发回调
			if retCallback then
				retCallback()
			end
			
			--允许操作
			hApi.safeRemoveT(_frmNode.childUI, "NoOp")
		end
	end
	
	--函数：道具重铸动画
	PlayItemRebuildAnimation = function(retCallback)
		local _frm = hGlobal.UI.PhoneItemFrm_Mini
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--删除原先的重铸按钮
		hApi.safeRemoveT(_frmNode.childUI, "btnRebuild")
		
		--在播放动画前，创建一个全屏幕的控件，挡操作
		_frmNode.childUI["NoOp"] = hUI.button:new({
			parent = _parentNode,
			model = "UI:SkillSlot",
			x = hVar.SCREEN.w / 2,
			y = -hVar.SCREEN.h / 2,
			w = hVar.SCREEN.w * 2,
			h = hVar.SCREEN.h * 2,
			z = 99999,
			dragbox = _frm.childUI["dragBox"],
			code = function()
				--用于挡操作的事件
			end,
		})
		_frmNode.childUI["NoOp"].handle.s:setOpacity(0) --用于挡操作，不显示
		
		--动画相关参数
		local OnAllActionEnd = nil --动画完成的回调
		
		--找出重铸的位置
		--[[
		local item = 0
		if (current_xilian_oHero == 0) then --背包的道具
			item = Save_PlayerData.bag[current_xilian_itemIdx]
		else --英雄身上的装备道具
			--item = current_xilian_oHero.data.equipment[current_xilian_itemIdx]
			local herocard = Save_PlayerData.herocard
			for i = 1, #herocard, 1 do
				if (herocard[i].id == current_xilian_oHero.data.id) then
					item = herocard[i].equipment[current_xilian_itemIdx]
					break
				end
			end
		end
		]]
		local item = current_xilian_itemIdx
		local itemId = item[1] --道具id
		local itemLv = hVar.tab_item[itemId].itemLv or 1
		local rewardEx = item[hVar.ITEM_DATA_INDEX.SLOT]
		local upCount = 0 --有效的孔的数量
		local lastSlotIdx = 0 --最后一个孔的索引位置
		
		--绘制出变化了孔的属性
		if rewardEx and (type(rewardEx) == "table") then
			for j = 1, #rewardEx, 1 do
				local attr = rewardEx[j] --孔的属性（字符串）
				local attrVal = hVar.ITEM_ATTR_VAL[attr] --对应的孔的属性表
				if attrVal then
					--本条是有效的孔数据
					upCount = upCount + 1
					lastSlotIdx = j
				end
			end
		end
		
		--重铸的位置（这里已经是重铸后的位置了，所以是最后一个孔的索引位置
		local currentIdx = upCount
		
		--显示钻石图标
		_frmNode.childUI["XiLian_Diamond" .. currentIdx].handle.s:setVisible(true) --显示钻石图标
		
		--新的属性
		local temptext = "" --要显示的属性字符串描述
		local attrVal = hVar.ITEM_ATTR_VAL[rewardEx[lastSlotIdx]]
		if (attrVal.attrAdd == "atk") then --道具属性为攻击力，读取最小攻击力和最大攻击力
			local miniAtk, maxAtk = attrVal.value1, attrVal.value2
			temptext = miniAtk .. " - " .. maxAtk
		else --其它属性，只读第一个数值
			temptext = attrVal.value1
			
			local sign = nil --正负号
			local u_value = math.abs(attrVal.value1) --无符号的值
			--百分号
			if (hVar.ItemRewardMillinSecondMode[attrVal.attrAdd] == 1) then
				u_value = u_value / 1000
			end
			if (attrVal.value1 >= 0) then
				sign = "＋"
			else
				sign = "－"
			end
			
			if (attrVal.attrAdd == "atk_interval") then --攻击间隔
				local floorvalue = u_value / 1000
				local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
				--temptext = sign .. szfloorvalue .. "秒" --language
				temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
			elseif (attrVal.attrAdd == "rebirth_time") then --复活时间
				local floorvalue = u_value / 1000
				local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
				--temptext = sign .. szfloorvalue .. "秒" --language
				temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
			elseif (attrVal.attrAdd == "AI_attribute") then --AI行为
				if (attrVal.value1 == 1) then
					--temptext = "主动攻击" --language
					temptext = hVar.tab_string["__Attr_Hint_active_attack"] --language
				else
					--temptext = "不主动攻击" --language
					temptext = hVar.tab_string["__Attr_Hint_passive_attack"] --language
				end
			elseif (attrVal.attrAdd == "kill_gold") then --击杀奖励金币
				--temptext = sign .. u_value .. "金" --language
				temptext = sign .. u_value .. hVar.tab_string["gold"] --language
			elseif (attrVal.attrAdd == "escape_punish") then --逃怪惩罚
				--temptext = sign .. u_value .. "生命" --language
				temptext = sign .. u_value .. hVar.tab_string["blood"] --language
			elseif (attrVal.attrAdd == "active_skill_cd_delta") then --主动技能冷却时间变化值（毫秒）
				local floorvalue = u_value / 1000
				local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
				--temptext = sign .. szfloorvalue .. "秒" --language
				temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
			elseif (attrVal.attrAdd == "passive_skill_cd_delta") then --被动技能冷却时间变化值（毫秒）
				local floorvalue = u_value / 1000
				local szfloorvalue = (("%d.%d"):format(math.floor(floorvalue), math.floor((floorvalue - math.floor(floorvalue)) * 10))) --保留1位小数
				--temptext = sign .. szfloorvalue .. "秒" --language
				temptext = sign .. szfloorvalue .. hVar.tab_string["__Second"] --language
			elseif (attrVal.attrAdd == "active_skill_cd_delta_rate") then --主动技能冷却时间变化比例值（去百分号后的值）
				temptext = sign .. u_value
			elseif (attrVal.attrAdd == "passive_skill_cd_delta_rate") then --被动技能冷却时间变化比例值（去百分号后的值）
				temptext = sign .. u_value
			elseif (attrVal.attrAdd == "hp_restore_delta_rate") then --回血倍率比例值（去百分号后的值）
				temptext = sign .. u_value
			elseif (attrVal.attrAdd == "crit_value") then --暴击倍数（支持小数）
				--local szfloorvalue = string.format("%.1f", u_value) --保留1位有效数字
				local szfloorvalue = u_value * 100
				--temptext = sign .. szfloorvalue .. "倍" --language
				temptext = sign .. szfloorvalue .. hVar.tab_string["__Rate"] --language
			elseif (attrVal.attrAdd == "crit_immue") then --暴击免伤
				temptext = sign .. u_value
			else
				temptext = sign .. u_value
			end
			
			--百分比显示
			if (hVar.ItemRewardStrMode[attrVal.attrAdd] == 1) then
				temptext = temptext .. "％"
			end
		end
		
		local rname = hVar.tab_string[attrVal.strTip] --属性的中文描述
		--local rgb = hVar.ITEMLEVEL[attrVal.quality].NAMERGB --属性颜色
		local rgb = hVar.ITEM_ATTR_CHIP_COLOR_DEF[attrVal.quality]
		
		--表现动画
		local fadeTo = CCFadeTo:create(0.2, 0) --原属性变淡
		
		local delay1 = CCDelayTime:create(0.1) --延时1
		
		local callback1 = CCCallFunc:create(function() --回调1
			_frmNode.childUI["XiLian_Attr" .. currentIdx].handle.s:setOpacity(255) --文字重新变亮
			_frmNode.childUI["XiLian_Attr" .. currentIdx]:setText(rname .. " " .. temptext) --显示卡槽的属性文字
			_frmNode.childUI["XiLian_Attr" .. currentIdx].handle.s:setColor(ccc3(rgb[1], rgb[2], rgb[3]))
		end)
		
		--同步动画1：变大+偏移
		local spwan1Time = 0.1
		local scaleToBig = CCScaleTo:create(spwan1Time, 1.3) --变大
		local movebyLeft = CCMoveBy:create(spwan1Time, ccp(-10, 4)) --偏移左
		local spawn1 = CCSpawn:createWithTwoActions(scaleToBig, movebyLeft) --同步1
		
		local delay2 = CCDelayTime:create(0.02) --延时2
		
		--同步动画2：变小+偏移
		local spwan2Time = 0.05
		local scaleToSmall = CCScaleTo:create(spwan2Time, 1.0) --变小
		local movebyRight = CCMoveBy:create(spwan2Time, ccp(10, -4)) --偏移左
		local spawn2 = CCSpawn:createWithTwoActions(scaleToSmall, movebyRight) --同步2
		
		local callback2 = CCCallFunc:create(function() --回调2
			--动画完成
			OnAllActionEnd()
		end)
		
		--播放动画
		local array = CCArray:create()
		array:addObject(fadeTo) --原属性变淡
		array:addObject(delay1) --延时1
		array:addObject(callback1) --回调1
		array:addObject(spawn1) --同步1
		array:addObject(delay2) --延时2
		array:addObject(spawn2) --同步2
		array:addObject(callback2) --回调2
		_frmNode.childUI["XiLian_Attr" .. currentIdx].handle.s:runAction(CCSequence:create(array)) --action
		
		--所有的动画都已完成
		OnAllActionEnd = function()
			--触发回调
			if retCallback then
				retCallback()
			end
			
			--允许操作
			hApi.safeRemoveT(_frmNode.childUI, "NoOp")
		end
	end
	
	--函数：横竖屏切换事件
	on_SpinScreen_event_xilain = function()
		local _frm = hGlobal.UI.PhoneItemFrm_Mini
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--关闭本界面
		OnClosePanel()
		
		--取消监听：道具洗炼结果刷新本界面
		hGlobal.event:listen("Local_Event_ItemXiLian_Result_Red_Equip", "__ItemXiLianSuccess_Frm_Mini", nil)
		
		--删除本界面
		if hGlobal.UI.PhoneItemFrm_Mini then --删除上一次的宝箱界面
			hGlobal.UI.PhoneItemFrm_Mini:del()
			hGlobal.UI.PhoneItemFrm_Mini = nil
		end
		
		--重新加载
		hGlobal.UI.InitMyItemFrm_Mini("include")
		
		--触发事件，显示洗炼迷你面板（洗炼）
		hGlobal.event:event("localEvent_ShowPhone_ItemMini", current_xilian_oHero, current_xilian_itemIdx)
	end
	
	--监听打开洗炼迷你面板事件
	hGlobal.event:listen("localEvent_ShowPhone_ItemMini", "_ShowXilian", function(oHero, oItem)
		--触发事件，显示战术技能卡界面
		--hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
		
		--显示道具界面
		hGlobal.UI.PhoneItemFrm_Mini:show(1)
		hGlobal.UI.PhoneItemFrm_Mini:active()
		
		--[[
		--连接pvp服务器
		if (Pvp_Server:GetState() ~= 1) then --未连接
			Pvp_Server:Connect()
		elseif (not hGlobal.LocalPlayer:getonline()) then --不重复登陆
			Pvp_Server:UserLogin()
		end
		]]
		
		--先清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--刷新当前要洗炼的道具迷你界面
		OnCreateShopXiLianFrame_Mini()
		OnCreateXiLianItemBtn_Mini(oHero, oItem)
		
		--只有在打开界面时才会监听的事件
		--监听：道具洗炼结果刷新本界面
		hGlobal.event:listen("Local_Event_ItemXiLian_Result_Red_Equip", "__ItemXiLianSuccess_Frm_Mini", function(result, itemUId, costScore, equip)
			--洗炼道具成功
			if result == 1 then
				--如果是装备，刷新界面
				if (current_xilian_oHero ~= 0) then
					current_xilian_oHero:load(current_xilian_oHero.data.id, 1)
				end
				
				--播放道具洗炼的音效
				--hApi.PlaySound("magic4")
				
				--播放洗炼成功动画
				PlayItemXiLianAnimation(function()
					--更新洗炼道具信息
					RefreshXilianItemInfo_Mini()
					
					--更新洗炼道具价格和按钮控件
					RefreshXiLianItemNoteFrm_Mini()
					
					--更新属性面板
					hGlobal.event:event("LocalEvent_UpdateChariotEquipFrm")
				end)
			end
		end)
	end)
end

--通过订单系统 洗练红装神器成功返回
hGlobal.event:listen("LocalEvent_order_xilian_redequip", "__ItemXiLianEvent", function(result, itemUId, costScore, equip)
	--去掉菊花
	hUI.NetDisable(0)
	
	--[[
	--连接pvp服务器
	if (Pvp_Server:GetState() ~= 1) then --未连接
		Pvp_Server:Connect()
	elseif (not hGlobal.LocalPlayer:getonline()) then --不重复登陆
		Pvp_Server:UserLogin()
	end
	]]
	
	local ret = false
	local strRet = hVar.tab_string["ios_err_unknow"]
	
	--洗练成功
	if result == 1 then
		
		local r, heroId, oItem, pos = LuaGetPlayerDataRedEquip(equip.dbid)
		print(r, heroId, oItem, pos)
		
		if r and oItem and type(oItem) == "table" then
			local slot = oItem[hVar.ITEM_DATA_INDEX.SLOT]
			
			if type(slot) ~= "table" then
				oItem[hVar.ITEM_DATA_INDEX.SLOT] = {}
			end
			
			--获得道具的扩展属性
			for i = 1, equip.slotNum do
				if slot[i] then
					slot[i] = equip.attr[i]
				end
			end
			
			--扣除积分
			LuaAddPlayerScore(-costScore)
			
			--统计合成道具
			LuaAddPlayerCountVal(hVar.MEDAL_TYPE.xilianN)
			LuaAddDailyQuestCountVal(hVar.MEDAL_TYPE.xilianN)
			
			--存储存档
			--保存存档
			if (heroId > 0) then
				LuaSaveHeroCard()
			end
			LuaSavePlayerData(g_localfilepath, g_curPlayerName, Save_PlayerData, Save_PlayerLog)
			
			ret = true
		else
			--todo:error 道具不存在
			strRet = "道具不存在"
		end
		
	else
		strRet = hVar.tab_string["ios_err_unknow"]
	end
	
	if (not ret) then
		--弹框
		hGlobal.UI.MsgBox(strRet,{
			font = hVar.FONTC,
			ok = function()
			end,
		})
	end
	
	--返回事件：本地洗炼神器结果
	hGlobal.event:event("Local_Event_ItemXiLian_Result_Red_Equip", result, itemUId, costScore, equip)
end)

--test
--[[
--测试代码
if hGlobal.UI.PhoneItemFrm_Mini then --删除上一次的道具简易操作面板
	hGlobal.UI.PhoneItemFrm_Mini:del()
	hGlobal.UI.PhoneItemFrm_Mini = nil
end
hGlobal.UI.InitMyItemFrm_Mini("include") --测试创建道具简易操作面板
--打开洗炼迷你面板（洗炼）
hGlobal.event:event("localEvent_ShowPhone_ItemMini", 0, Save_PlayerData.bag[1])
]]

