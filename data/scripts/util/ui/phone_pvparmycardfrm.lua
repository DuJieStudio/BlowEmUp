




--竞技场兵种卡洗属性操作面板
hGlobal.UI.InitMyArmyCardAttrFrm_Mini = function(mode)
	--不重复创建道具简易操作面板
	if hGlobal.UI.PhoneArmyCardRefreshAttr_Mini then --道具简易操作面板
		return
	end
	
	local BOARD_WIDTH = 450 --道具操作面板的宽度
	local BOARD_HEIGHT = 550 --道具操作面板的高度
	local BOARD_OFFSETY = -20 --道具操作面板y偏移中心点的值
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
	
	--分页1：洗炼兵种卡函数部分
	local OnCreateArmyCardAttrFrame_Mini = hApi.DoNothing --创建兵种卡洗炼迷你界面（第1个分页）
	local OnCreateArmyCardAttrBtn_Mini = hApi.DoNothing --创建洗炼兵种卡迷你图标按钮
	local OnXiLianArmyCardFunc = hApi.DoNothing --洗炼兵种卡逻辑
	local OnRestoreArmyCardFunc = hApi.DoNothing --还原兵种卡逻辑
	local OnClickDebrisTip = hApi.DoNothing --点击兵种卡碎片tip
	local OnCreateArmyCardXiLianTipFrame = hApi.DoNothing --查看兵种卡洗炼分页说明tip
	local RefreshXiLianArmyCardNoteFrm_Mini = hApi.DoNothing --刷新兵种卡碎片价格和按钮控件
	local RefreshXilianArmyCardInfo_Mini = hApi.DoNothing --刷新洗炼兵种卡的信息
	local PlayArmyCardXiLianAnimation = hApi.DoNothing --兵种卡洗炼动画
	local CheckPvpVersionControl = hApi.DoNothing --检测pvp的版本号
	
	local ITEM_ICON_EDGE = 68 --道具图标的边长
	local ITEM_BAG_OFFSET_X = 550 --道具背包统一偏移x
	local ITEM_BAG_OFFSET_Y = -125 --道具背包统一偏移y
	
	local BAG_X_NUM = 4 --背包x方向的个数
	local BAG_Y_NUM = 7 --背包y方向的个数
	local bag_touch_dx = 0 --背包触控点的偏移值x
	local bag_touch_dy = 0 --背包触控点的偏移值y
	
	--洗炼道具相关参数
	local current_tacticId = 0 --当前兵种卡id
	local current_tacticIdx = 0 --当前兵种卡索引
	
	--加载资源
	--xlLoadResourceFromPList("data/image/misc/pvp.plist")
	
	--hApi.clearTimer("__TACTIC_FRAME_UPDATE__")
	
	--创建兵种卡重洗属性操作面板
	hGlobal.UI.PhoneArmyCardRefreshAttr_Mini = hUI.frame:new(
	{
		x = BOARD_POS_X,
		y = BOARD_POS_Y,
		w = BOARD_WIDTH,
		h = BOARD_HEIGHT,
		dragable = 4,
		show = 0, --一开始不显示
		border = 1, --显示frame边框
		background = "UI:Tactic_Background",
		autoactive = 0,
		--全部事件
		--codeOnDragEx = function(touchX, touchY, touchMode)
			--
		--end,
	})
	
	local _frm = hGlobal.UI.PhoneArmyCardRefreshAttr_Mini
	local _parent = _frm.handle._n
	
	--标题文字
	_frm.childUI["Title"] = hUI.label:new({
		parent = _parent,
		x = BOARD_WIDTH / 2,
		y = -22,
		size = 32,
		font = hVar.FONTC,
		align = "MC",
		width = 380,
		border = 1,
		--text = "兵种强化", --language
		text = hVar.tab_string["ArmyCardPage"] .. hVar.tab_string["__ITEM_PANEL__PAGE_QIANGHUA"]--language
	})
	
	--关闭按钮
	local close_y = 0
	if (hVar.SCREEN.h <= 680) then --高度过小，关闭按钮往下调一点
		close_y = -12
	end
	--btnClose
	_frm.childUI["closeBtn"] = hUI.button:new({
		parent = _parent,
		dragbox = _frm.childUI["dragBox"],
		--model = "UI:BTN_Close", --BTN:PANEL_CLOSE
		model = "BTN:PANEL_CLOSE",
		x = _frm.data.w + 6,
		y = close_y,
		w = 64,
		h = 64,
		scaleT = 0.95,
		code = function()
			hGlobal.event:event("LocalEvent_CloseGameCoinFrm")
			
			--不显示道具简易操作面板
			hGlobal.UI.PhoneArmyCardRefreshAttr_Mini:show(0)
			
			--关闭界面后不需要监听的事件
			--取消监听：兵种卡洗炼结果刷新本界面
			hGlobal.event:listen("LocalEvent_Pvp_Army_Refresh_AddOnes_Ok", "__PvpArmyRefreshAddOnesBack_Mini", nil)
			--取消监听：兵种卡属性还原回调事件
			hGlobal.event:listen("LocalEvent_Pvp_Army_Restore_AddOnes_Ok", "__ArmyRestoreAddOnes_Mini", nil)
		
			--清空上次分页的全部信息
			_removeLeftFrmFunc()
			_removeRightFrmFunc()
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
		local _frm = hGlobal.UI.PhoneArmyCardRefreshAttr_Mini
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#leftRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, leftRemoveFrmList[i]) 
		end
		leftRemoveFrmList = {}
	end
	
	--清空所有分页右侧的UI
	_removeRightFrmFunc = function()
		local _frm = hGlobal.UI.PhoneArmyCardRefreshAttr_Mini
		local _frmNode = _frm.childUI["PageNode"]
		
		for i = 1,#rightRemoveFrmList do
			hApi.safeRemoveT(_frmNode.childUI, rightRemoveFrmList[i]) 
		end
		rightRemoveFrmList = {}
	end
	
	--函数：创建兵种卡洗炼迷你界面（第1个分页）
	OnCreateArmyCardAttrFrame_Mini = function()
		local _frm = hGlobal.UI.PhoneArmyCardRefreshAttr_Mini
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		local OFFSET_X = 40 --统一偏移x
		local OFFSET_Y = -70 --统一偏移y
		
		--重置参数
		current_tacticId = 0 --当前洗炼道具的英雄
		current_tacticIdx = 0 --当前洗炼道具的背包索引位置
		
		--[[
		--提示洗炼道具的说明文字
		_frmNode.childUI["XiLianIntro"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X,
			y = OFFSET_Y,
			size = 26,
			font = hVar.FONTC,
			align = "LC",
			width = 380,
			border = 1,
			text = "随机生成兵种卡的新属性。", --language
			--text = hVar.tab_string["__ITEM_PANEL_MINI__XILIAN_INTRO"], --language
		})
		_frmNode.childUI["XiLianIntro"].handle.s:setColor(ccc3(192, 192, 192))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLianIntro"
		]]
		
		--洗炼规则介绍按钮（响应区域）
		_frmNode.childUI["btnXiLianIntro"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = OFFSET_X + 350,
			y = OFFSET_Y - 20,
			w = 90,
			h = 90,
			model = "misc/mask.png",
			scaleT = 1.0,
			scale = 1.0,
			code = function()
				--创建兵种卡洗炼介绍tip
				OnCreateArmyCardXiLianTipFrame()
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
		
		--洗炼池子（响应区域）
		_frmNode.childUI["XiLianChip"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			x = OFFSET_X + 180,
			y = OFFSET_Y - 50,
			w = 120,
			h = 120,
		})
		_frmNode.childUI["XiLianChip"].handle.s:setOpacity(0) --不显示，只用于响应事件
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLianChip"
		
		--洗炼池子图片
		_frmNode.childUI["XiLianChip"].childUI["image"] = hUI.image:new({
			parent = _frmNode.childUI["XiLianChip"].handle._n,
			model = "UI:tactic_card_1",
			x = 0,
			y = 0,
			w = 96,
			h = 120,
		})
		
		--旗子
		_frmNode.childUI["XiLianChip"].childUI["image2"] = hUI.image:new({
			parent = _frmNode.childUI["XiLianChip"].handle._n,
			model = "UI:ico_tactics_other",
			x = -1,
			y = 46,
			w = 25,
			h = 27,
		})
		
		--洗炼属性区域的很淡的底纹区域背景图
		_frmNode.childUI["XiLianAttrBG"] = hUI.button:new({
			parent = _parentNode,
			model = "misc/mask.png",
			x = OFFSET_X + 185,
			y = OFFSET_Y - 205,
			w = 430,
			h = 160,
		})
		_frmNode.childUI["XiLianAttrBG"].handle.s:setOpacity(0) --只挂载子控件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLianAttrBG"
		local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", 0, 0, 430, 160, _frmNode.childUI["XiLianAttrBG"])
		img9:setOpacity(32) --很淡的颜色
		
		--依次绘制每条洗炼属性
		local _off_x = 25 --dx
		local _off_y = -155 --dy
		local _off_dy = 50 --每个间隔y
		for i = 1, 3, 1 do
			--该属性条的背景图
			_frmNode.childUI["XiLian_ImageBG" .. i] = hUI.image:new({
				parent = _parentNode,
				model = "UI:MedalDarkImg",
				x = OFFSET_X + _off_x + 155,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy,
				w = 310,
				h = 40,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_ImageBG" .. i
			
			--绿色小箭头图标
			_frmNode.childUI["XiLian_AttrArrow" .. i] = hUI.image:new({
				parent = _parentNode,
				model = "UI:UI_Arrow",
				x = OFFSET_X + _off_x + 25,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy,
				w = 30,
				h = 35,
				roll = 90,
			})
			_frmNode.childUI["XiLian_AttrArrow" .. i].handle.s:setColor(ccc3(0, 255, 0))
			_frmNode.childUI["XiLian_AttrArrow" .. i].handle._n:setRotation(-90)
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_AttrArrow" .. i
			
			--卡槽的属性文字
			_frmNode.childUI["XiLian_Attr" .. i] = hUI.label:new({
				parent = _parentNode,
				x = OFFSET_X + _off_x + 50,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy - 1,
				size = 26,
				align = "LC",
				border = 1,
				font = hVar.FONTC,
				width = 500,
				text = "",
			})
			_frmNode.childUI["XiLian_Attr" .. i].handle.s:setColor(ccc3(236, 255, 236))
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_Attr" .. i
			
			--卡槽的属性文字值
			_frmNode.childUI["XiLian_AttrValue" .. i] = hUI.label:new({
				parent = _parentNode,
				x = OFFSET_X + _off_x + 220,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy - 1,
				size = 22,
				align = "LC",
				border = 1,
				font = "numWhite",
				width = 500,
				text = "",
			})
			_frmNode.childUI["XiLian_AttrValue" .. i].handle.s:setColor(ccc3(236, 255, 236))
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_AttrValue" .. i
			
			--后缀"秒"
			_frmNode.childUI["XiLian_AttrPostfix" .. i] = hUI.label:new({
				parent = _parentNode,
				x = OFFSET_X + _off_x + 256,
				y = OFFSET_Y + _off_y - (i - 1) * _off_dy - 1,
				size = 26,
				align = "LC",
				border = 1,
				font = hVar.FONTC,
				width = 500,
				text = "",
			})
			_frmNode.childUI["XiLian_AttrPostfix" .. i].handle.s:setColor(ccc3(236, 255, 236))
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_AttrPostfix" .. i
		end
		
		--洗炼需要的碎片
		local matDy = -104
		for i = 1, 2, 1 do
			--绘制按钮响应点击事件的区域
			_frmNode.childUI["tacticDebrisBtn" .. i] = hUI.button:new({
				parent = _frmNode.handle._n,
				model = "masc./misc.png",
				dragbox = _frm.childUI["dragBox"],
				x = OFFSET_X - 140 + 325,
				y = OFFSET_Y + 21 - 210 + matDy + (i - 1) * 45 - 60,
				w = 440,
				h = 44,
				code = function()
					--点击兵种卡碎片tip
					OnClickDebrisTip(i)
				end,
			})
			_frmNode.childUI["tacticDebrisBtn" .. i].handle.s:setOpacity(0) --只用于控制，不显示
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "tacticDebrisBtn" .. i
			
			--绘制需要的战术卡的碎片图标
			--战术技能卡的碎片图标
			_frmNode.childUI["tacticDebrisIcon" .. i] = hUI.image:new({
				parent = _frmNode.handle._n,
				model = "ICON:skill_icon1_x3y3",
				x = OFFSET_X - 245 + 325,
				y = OFFSET_Y + 21 - 210 + matDy + (i - 1) * 45 - 60,
				w = 34,
				h = 34,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "tacticDebrisIcon" .. i
			
			--碎片图标
			_frmNode.childUI["debrisIcon" .. i] = hUI.image:new({
				parent = _frmNode.handle._n,
				model = "UI:SoulStoneFlag",
				x = OFFSET_X - 245 + 8 + 325,
				y = OFFSET_Y + 17 - 210 + matDy + (i - 1) * 45 - 60,
				w = 28,
				h = 41,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "debrisIcon" .. i
			
			local ACHIEVEMENT_WIDTH = 230
			--战术技能卡碎片进度条
			_frmNode.childUI["tacticDebrisProgress" .. i] = hUI.valbar:new({
				parent = _parentNode,
				x = OFFSET_X + 158 - 51 - 320 + 325,
				y = OFFSET_Y - 260 + 70 + matDy + (i - 1) * 45 - 60,
				w = ACHIEVEMENT_WIDTH - 64,
				h = 30,
				align = "LC",
				back = {model = "UI:SoulStoneBarBg1", x = -5, y = 0, w = ACHIEVEMENT_WIDTH - 56, h = 30 + 6},
				model = "UI:SoulStoneBar1",
				v = 0,
				max = 100,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "tacticDebrisProgress" .. i
			
			--战术技能卡碎片进度文字
			_frmNode.childUI["tacticDebrisProgressLabel" .. i] = hUI.label:new({
				parent = _parentNode,
				x = OFFSET_X + 188 - 320 + 325,
				y = OFFSET_Y - 260 + 70 + matDy + (i - 1) * 45 - 60,
				size = 26,
				align = "MC",
				--font = hVar.FONTC,
				font = "numWhite",
				text = "?/?",
				scale = 1.0,
			})
			leftRemoveFrmList[#leftRemoveFrmList + 1] = "tacticDebrisProgressLabel" .. i
		end
		
		--洗炼锁孔每日限制"该装备今日还可以锁孔洗炼"前缀
		_frmNode.childUI["XiLian_DayLimitPrefix"] = hUI.label:new({
			parent = _parentNode,
			model = "UI:score",
			x = OFFSET_X + 248 + 42,
			y = OFFSET_Y - 350 - 2, --numWhite字体偏移2像素
			w = 300,
			align = "RC",
			width = 500,
			font = hVar.FONTC,
			size = 24,
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
			y = OFFSET_Y - 350 - 2, --numWhite字体偏移2像素
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
			y = OFFSET_Y - 350 - 2, --numWhite字体偏移2像素
			w = 300,
			align = "LC",
			width = 500,
			font = hVar.FONTC,
			size = 24,
			--text = "次", --language
			text = hVar.tab_string["__TEXT_YouCanForgedCount1"], --language
			border = 1,
		})
		_frmNode.childUI["XiLian_DayLimitPostfix"].handle.s:setColor(ccc3(255, 255, 255))
		_frmNode.childUI["XiLian_DayLimitPostfix"].handle._n:setVisible(false) --默认不显示锁孔次数限制
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_DayLimitPostfix"
		
		--洗炼需要的积分前缀"消耗"
		_frmNode.childUI["XiLian_JiFenLabel"] = hUI.label:new({
			parent = _parentNode,
			model = "UI:score",
			x = OFFSET_X + 100 + 10,
			y = OFFSET_Y - 396 - 2 - 1, --偏移1像素
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
		
		--[[
		--洗炼需要的金币图标
		_frmNode.childUI["XiLian_GoldIcon"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:game_coins",
			x = OFFSET_X + 142 + 10,
			y = OFFSET_Y - 396,
			w = 42,
			h = 42,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_GoldIcon"
		
		--洗炼需要的金币数值
		_frmNode.childUI["GoldXiLianRequire"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X + 161 + 10,
			y = OFFSET_Y - 396 - 2, --numWhite字体偏移2像素
			size = 22,
			font = "numWhite",
			align = "LC",
			width = 300,
			text = "?",
		})
		_frmNode.childUI["GoldXiLianRequire"].handle.s:setColor(ccc3(255, 255, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "GoldXiLianRequire"
		]]
		
		--洗炼需要的积分图标
		_frmNode.childUI["XiLian_JiFenIcon"] = hUI.image:new({
			parent = _parentNode,
			model = "UI:score",
			x = OFFSET_X + 190 + 10,
			y = OFFSET_Y - 396,
			w = 24,
			h = 24,
		})
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLian_JiFenIcon"
		
		--洗炼需要的积分数值
		_frmNode.childUI["JiFenXiLianRequire"] = hUI.label:new({
			parent = _parentNode,
			x = OFFSET_X + 210 + 10,
			y = OFFSET_Y - 396 - 2, --numWhite字体偏移2像素
			size = 22,
			font = "numWhite",
			align = "LC",
			width = 300,
			text = "???",
		})
		_frmNode.childUI["JiFenXiLianRequire"].handle.s:setColor(ccc3(255, 255, 0))
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "JiFenXiLianRequire"
		
		--兵种卡洗炼按钮
		_frmNode.childUI["btnXiLian"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = OFFSET_X + 180 + 10,
			y = OFFSET_Y - 443,
			w = 180,
			h = 58,
			model = "UI:BTN_ButtonRed",
			animation = "normal",
			scaleT = 0.95,
			scale = 1.0,
			code = function()
				--洗炼兵种卡逻辑
				OnXiLianArmyCardFunc()
			end,
		})
		hApi.AddShader(_frmNode.childUI["btnXiLian"].handle.s, "gray") --默认该按钮灰掉
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnXiLian"
		
		--兵种卡洗炼按钮文字
		_frmNode.childUI["btnXiLian"].childUI["label"] = hUI.label:new({
			parent = _frmNode.childUI["btnXiLian"].handle._n,
			x = 0,
			y = -3,
			--text = "重新强化", --language
			text = hVar.tab_string["__RE_QIANGHUA__"], --lanugage
			font = hVar.FONTC,
			border = 1,
			size = 30,
			width = 200,
			align = "MC",
		})
		
		--兵种卡属性还原按钮
		_frmNode.childUI["btnRestore"] = hUI.button:new({
			parent = _parentNode,
			dragbox = _frm.childUI["dragBox"],
			x = OFFSET_X + 360,
			y = OFFSET_Y - 420,
			w = 80,
			h = 80,
			model = "misc/mask.png",
			scaleT = 0.95,
			scale = 1.0,
			code = function()
				--还原兵种卡逻辑
				OnRestoreArmyCardFunc()
			end,
		})
		_frmNode.childUI["btnRestore"].handle.s:setOpacity(0) --用于响应事件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "btnRestore"
		
		--属性还原图标
		_frmNode.childUI["btnRestore"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["btnRestore"].handle._n,
			x = 0,
			y = 0,
			w = 45,
			h = 45,
			model = "ui/bimage_replay.png",
		})
	end
	
	--函数：刷新兵种卡碎片价格和按钮控件
	RefreshXiLianArmyCardNoteFrm_Mini = function()
		local _frm = hGlobal.UI.PhoneArmyCardRefreshAttr_Mini
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--该兵种卡重洗属性需要的碎片
		local addonesPool = hVar.tab_tactics[current_tacticId].addonesPool
		local shopItemId = addonesPool.cost.shopItemId --重洗属性需要商店id
		local material = addonesPool.cost.material --重洗属性需要材料
		local requireScore = hVar.tab_shopitem[shopItemId] and hVar.tab_shopitem[shopItemId].score or 0 --重洗属性需要的积分
		local requireRmb = hVar.tab_shopitem[shopItemId] and hVar.tab_shopitem[shopItemId].rmb or 0 --重洗属性需要的游戏币
		
		--绘制每个素材碎片
		for i = 1, #material, 1 do
			--兵种卡升级信息
			local requireTacticId = material[i].id --升到下一级需要的兵种id
			local requireDebris = material[i].num or 9999 --升到下一级需要的碎片
			local debris = g_myPvP_BaseInfo.tacticInfo[requireTacticId] and g_myPvP_BaseInfo.tacticInfo[requireTacticId].debris or 0 --本兵种卡当前碎片数量
			--print(requireTacticId, requireDebris, debris)
			
			--更新战术技能卡的碎片图标
			_frmNode.childUI["tacticDebrisIcon" .. i].handle._n:setVisible(true)
			_frmNode.childUI["tacticDebrisIcon" .. i]:setmodel(hVar.tab_tactics[requireTacticId].icon)
			
			--显示碎片图标
			_frmNode.childUI["debrisIcon" .. i].handle._n:setVisible(true)
			
			--更新战术技能卡碎片进度条
			_frmNode.childUI["tacticDebrisProgress" .. i].handle._n:setVisible(true)
			_frmNode.childUI["tacticDebrisProgress" .. i]:setV(debris, requireDebris)
			
			--更新战术技能卡碎片进度文字
			local showNumText = (debris .. "/" .. requireDebris)
			local scaleText = 1.0
			local showTextLength = #showNumText
			if (showTextLength > 11) then --如果长度大于11，只能缩小文字(12~...个字)
				scaleText = 0.56
			elseif (showTextLength > 9) then --如果长度大于9，只能缩小文字(10~11个字)
				scaleText = 0.64
			elseif (showTextLength > 7) then --如果长度大于7，只能缩小文字(8~9个字)
				scaleText = 0.8
			else --可以显示下
				scaleText = 1.0
			end
			_frmNode.childUI["tacticDebrisProgressLabel" .. i]:setText(showNumText)
			_frmNode.childUI["tacticDebrisProgressLabel" .. i].handle._n:setScale(scaleText)
		end
		
		--剩下的碎片隐藏控件
		for i = #material + 1, 2, 1 do
			--隐藏战术技能卡的碎片图标
			_frmNode.childUI["tacticDebrisIcon" .. i].handle._n:setVisible(false)
			
			--隐藏碎片图标
			_frmNode.childUI["debrisIcon" .. i].handle._n:setVisible(false)
			
			--隐藏战术技能卡碎片进度条
			_frmNode.childUI["tacticDebrisProgress" .. i].handle._n:setVisible(false)
			
			--隐藏战术技能卡碎片进度文字
			_frmNode.childUI["tacticDebrisProgressLabel" .. i]:setText("")
		end
		
		--更新积分、游戏币
		_frmNode.childUI["JiFenXiLianRequire"]:setText(requireScore)
		--_frmNode.childUI["GoldXiLianRequire"]:setText(requireRmb)
		
		--重洗属性碎片是否足够
		local bDebrisEnough = true --碎片是否足够
		for i = 1, #material, 1 do
			--兵种卡升级信息
			local requireTacticId = material[i].id --升到下一级需要的兵种id
			local requireDebris = material[i].num or 9999 --升到下一级需要的碎片
			local debris = g_myPvP_BaseInfo.tacticInfo[requireTacticId] and g_myPvP_BaseInfo.tacticInfo[requireTacticId].debris or 0 --本兵种卡当前碎片数量
			if (debris < requireDebris) then
				bDebrisEnough = false --碎片不足
			end
		end
		
		--更新按钮状态
		if (bDebrisEnough) and (LuaGetPlayerScore() >= requireScore) and (LuaGetPlayerRmb() >= requireRmb) then --碎片、积分、金币足够
			hApi.AddShader(_frmNode.childUI["btnXiLian"].handle.s, "normal")
		else
			hApi.AddShader(_frmNode.childUI["btnXiLian"].handle.s, "gray")
		end
	end
	
	--函数：刷新洗炼兵种卡的信息
	RefreshXilianArmyCardInfo_Mini = function()
		local _frm = hGlobal.UI.PhoneArmyCardRefreshAttr_Mini
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--本兵种卡附加属性
		local addonesPool = hVar.tab_tactics[current_tacticId].addonesPool
		local initAttr = addonesPool.initAttr or {} --初始的属性
		local addones = g_myPvP_BaseInfo.tacticInfo[current_tacticId] and g_myPvP_BaseInfo.tacticInfo[current_tacticId].addones or {}
		local addone = addones[current_tacticIdx] or {}
		if addone then
			for i = 1, #addone, 1 do
				--兵种卡的属性文字
				local strAttr = addone[i]
				local attrVal = hVar.ITEM_ATTR_VAL[strAttr] --对应的孔的属性表
				if attrVal then
					local temptext = attrVal.value1 or 0 --要显示的属性字符串描述，只读第一个数值
					local attrAdd = attrVal.attrAdd or 0
					
					local sign = nil --正负号
					local u_value = math.abs(attrVal.value1) --无符号的值
					if (attrVal.value1 >= 0) then
						sign = "+"
					else
						sign = "-"
					end
					
					temptext = sign .. u_value
					
					--百分比显示
					if (hVar.ItemRewardStrMode[attrAdd] == 1) then
						temptext = temptext .. "%"
					end
					
					local rname = hVar.tab_string[attrVal.strTip] --属性的中文描述
					local rgb = hVar.ITEMLEVEL[attrVal.quality].NAMERGB --属性颜色
						
					--更新绘制本条属性
					_frmNode.childUI["XiLian_Attr" .. i]:setText(rname)
					_frmNode.childUI["XiLian_AttrValue" .. i]:setText(temptext)
					
					if (attrAdd == "army_cooldown") or (attrAdd == "skill_cooldown") or (attrAdd == "skill_chaos") or (attrAdd == "skill_lasttime") then
						--_frmNode.childUI["XiLian_AttrPostfix" .. i]:setText("秒") --language
						_frmNode.childUI["XiLian_AttrPostfix" .. i]:setText(hVar.tab_string["__Second"]) --language
					elseif (attrAdd == "skill_poison") then
						--_frmNode.childUI["XiLian_AttrPostfix" .. i]:setText("层") --language
						_frmNode.childUI["XiLian_AttrPostfix" .. i]:setText(hVar.tab_string["__Step"]) --language
					else
						_frmNode.childUI["XiLian_AttrPostfix" .. i]:setText("")
					end
					
					--_frmNode.childUI["XiLian_Attr" .. i].handle.s:setColor(ccc3(rgb[1], rgb[2], rgb[3]))
				end
			end
		end
		
		--检测三个属性是否都是初始属性
		local bIsInitAttr = true
		if addone then
			for i = 1, #addone, 1 do
				--兵种卡的属性文字
				local strAttr = addone[i]
				if (strAttr ~= initAttr[i]) then
					bIsInitAttr = false --不是初始属性i
					break
				end
			end
		end
		
		--是初始属性
		if bIsInitAttr then
			hApi.AddShader(_frmNode.childUI["btnRestore"].childUI["icon"].handle.s, "gray") --灰掉
		else
			hApi.AddShader(_frmNode.childUI["btnRestore"].childUI["icon"].handle.s, "normal") --正常
		end
	end
	
	--函数：创建洗炼兵种卡图标按钮
	OnCreateArmyCardAttrBtn_Mini = function(tacticId, tacticIdx)
		local _frm = hGlobal.UI.PhoneArmyCardRefreshAttr_Mini
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--标记兵种卡的索引值
		current_tacticId = tacticId
		current_tacticIdx = tacticIdx
		
		local xilianChip_x = _frmNode.childUI["XiLianChip"].data.x
		local xilianChip_y = _frmNode.childUI["XiLianChip"].data.y
		local to_x = xilianChip_x
		local to_y = xilianChip_y
		
		--修改兵种卡背景图
		local qLv = math.min((hVar.tab_tactics[tacticId].quality or 1), 4) --图片最多只有4张
		_frmNode.childUI["XiLianChip"].childUI["image"]:setmodel("UI:tactic_card_" .. qLv)
		
		--绘制洗炼兵种卡图标（按钮响应）
		_frmNode.childUI["XiLianArmyCard"] = hUI.button:new({
			parent = _parentNode,
			--model = "UI:SkillSlot",
			model = "misc/mask.png",
			x = to_x,
			y = to_y - 12,
			w = 100,
			h = 100,
			dragbox = _frm.childUI["dragBox"],
			scaleT = 0.95,
			--failcall = 1,
			z = 100,
			
			--抬起出售道具图标事件
			code = function(self, touchX, touchY, sus)
				--显示兵种卡的tip
				local tacticLv = 1
				hApi.ShowTacticCardTip_PVP(current_tacticId, tacticLv)
			end,
		})
		
		_frmNode.childUI["XiLianArmyCard"].handle.s:setOpacity(0) --只用于响应事件，不显示
		leftRemoveFrmList[#leftRemoveFrmList + 1] = "XiLianArmyCard"
		
		--绘制洗炼道具图标
		_frmNode.childUI["XiLianArmyCard"].childUI["icon"] = hUI.image:new({
			parent = _frmNode.childUI["XiLianArmyCard"].handle._n,
			model = hVar.tab_tactics[tacticId].icon,
			x = 0,
			y = 0,
			w = ITEM_ICON_EDGE,
			h = ITEM_ICON_EDGE,
		})
		
		--刷新洗炼兵种卡信息界面
		RefreshXilianArmyCardInfo_Mini()
		
		--刷新兵种卡碎片价格和按钮控件
		RefreshXiLianArmyCardNoteFrm_Mini()
	end
	
	--函数：点击兵种卡碎片tip
	OnClickDebrisTip = function(index)
		local _frm = hGlobal.UI.PhoneArmyCardRefreshAttr_Mini
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--该兵种卡重洗属性需要的碎片
		local addonesPool = hVar.tab_tactics[current_tacticId].addonesPool
		local shopItemId = addonesPool.cost.shopItemId --重洗属性需要商店id
		local material = addonesPool.cost.material --重洗属性需要材料
		local requireScore = hVar.tab_shopitem[shopItemId] and hVar.tab_shopitem[shopItemId].score or 0 --重洗属性需要的积分
		local requireRmb = hVar.tab_shopitem[shopItemId] and hVar.tab_shopitem[shopItemId].rmb or 0 --重洗属性需要的游戏币
		
		--重洗属性碎片是否足够
		if material[index] then
			--兵种卡升级信息
			local requireTacticId = material[index].id --升到下一级需要的兵种id
			
			--显示战术技能卡的tip
			local rewardType = 6 --碎片类型
			local tacticLv = 1
			hApi.ShowTacticCardTip(rewardType, requireTacticId, tacticLv, current_tacticId)
		end
	end
	
	--函数：洗炼兵种卡逻辑
	OnXiLianArmyCardFunc = function()
		--如果没有洗炼兵种卡，直接返回
		if (current_tacticId == 0) then
			return
		end
		
		--如果未连接，不能重洗属性
		if (Pvp_Server:GetState() ~= 1) then --未连接
			--local strText = "您已断开连接，请重新登入" --language
			local strText = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--如果未登入，不能重洗属性
		if (not hGlobal.LocalPlayer:getonline()) then --未登入
			--local strText = "您已断开连接，请重新登入" --language
			local strText = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--检测pvp的版本号
		if (not CheckPvpVersionControl()) then
			return
		end
		
		--该兵种卡重洗属性需要的碎片
		local addonesPool = hVar.tab_tactics[current_tacticId].addonesPool
		local initAttr = addonesPool.initAttr or {} --初始的属性
		local shopItemId = addonesPool.cost.shopItemId --重洗属性需要商店id
		local material = addonesPool.cost.material --重洗属性需要材料
		local requireScore = hVar.tab_shopitem[shopItemId] and hVar.tab_shopitem[shopItemId].score or 0 --重洗属性需要的积分
		local requireRmb = hVar.tab_shopitem[shopItemId] and hVar.tab_shopitem[shopItemId].rmb or 0 --重洗属性需要的游戏币
		
		--暂未开放此兵种强化属性
		if (#initAttr == 0) then
			--local strText = "暂未开放此兵种强化属性" --language
			local strText = hVar.tab_string["__TEXT_PVP_AttrQianghuaNotOpen"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--未获得此兵种卡
		local tacticLv = g_myPvP_BaseInfo.tacticInfo[current_tacticId] and g_myPvP_BaseInfo.tacticInfo[current_tacticId].lv or 0
		if (tacticLv < 1) then --未获得
			--local strText = "您选择的兵种卡未解锁！" --language
			local strText = hVar.tab_string["SelectTacticDebrisNoEnough"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--重洗属性碎片是否足够
		local bDebrisEnough = true --碎片是否足够
		for i = 1, #material, 1 do
			--兵种卡升级信息
			local requireTacticId = material[i].id --升到下一级需要的兵种id
			local requireDebris = material[i].num or 9999 --升到下一级需要的碎片
			local debris = g_myPvP_BaseInfo.tacticInfo[requireTacticId] and g_myPvP_BaseInfo.tacticInfo[requireTacticId].debris or 0 --本兵种卡当前碎片数量
			if (debris < requireDebris) then
				bDebrisEnough = false --碎片不足
			end
		end
		--碎片数量足够
		if (not bDebrisEnough) then --碎片数量足够
			--local strText = "碎片不足" --language
			local strText = hVar.tab_string["tactic_lessDebris"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--检测积分是否足够
		if (LuaGetPlayerScore() < requireScore) then
			--local strText = "积分不足" --language
			local strText = hVar.tab_string["__TEXT_ScoreNotEnough"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--检测游戏币是否足够
		if (LuaGetPlayerRmb() < requireRmb) then
			--弹框
			--[[
			--local strText = "游戏币不足" --language
			local strText = hVar.tab_string["ios_not_enough_game_coin"] --language
			hGlobal.UI.MsgBox(strText, {
				font = hVar.FONTC,
				ok = function()
				end,
			})
			]]
			--弹出游戏币不足并提示是否购买的框
			hGlobal.event:event("LocalEvent_BuyItemfail", 1, 0)
			
			return
		end
		
		--可以重洗属性
		
		--挡操作
		hUI.NetDisable(30000)
		
		--发送刷新兵种卡附加属性指令
		local tacticId = current_tacticId
		local addonesIdx = current_tacticIdx
		--print("refresh_tactic_addones", tacticId, addonesIdx)
		SendPvpCmdFunc["refresh_tactic_addones"](tacticId, addonesIdx)
	end
	
	--函数：还原兵种卡逻辑
	OnRestoreArmyCardFunc = function()
		--如果没有洗炼兵种卡，直接返回
		if (current_tacticId == 0) then
			return
		end
		
		--如果未连接，不能还原属性
		if (Pvp_Server:GetState() ~= 1) then --未连接
			--local strText = "您已断开连接，请重新登入" --language
			local strText = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--如果未登入，不能还原属性
		if (not hGlobal.LocalPlayer:getonline()) then --未登入
			--local strText = "您已断开连接，请重新登入" --language
			local strText = hVar.tab_string["__TEXT_PVP_DisConnect"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--检测pvp的版本号
		if (not CheckPvpVersionControl()) then
			return
		end
		
		--该兵种卡重洗属性需要的碎片
		local addones = g_myPvP_BaseInfo.tacticInfo[current_tacticId] and g_myPvP_BaseInfo.tacticInfo[current_tacticId].addones or {}
		local addone = addones[current_tacticIdx] or {}
		local addonesPool = hVar.tab_tactics[current_tacticId].addonesPool
		local initAttr = addonesPool.initAttr or {} --初始的属性
		local shopItemId = addonesPool.cost.shopItemId --重洗属性需要商店id
		local material = addonesPool.cost.material --重洗属性需要材料
		local requireScore = hVar.tab_shopitem[shopItemId] and hVar.tab_shopitem[shopItemId].score or 0 --重洗属性需要的积分
		local requireRmb = hVar.tab_shopitem[shopItemId] and hVar.tab_shopitem[shopItemId].rmb or 0 --重洗属性需要的游戏币
		
		--未获得此兵种卡
		local tacticLv = g_myPvP_BaseInfo.tacticInfo[current_tacticId] and g_myPvP_BaseInfo.tacticInfo[current_tacticId].lv or 0
		if (tacticLv < 1) then --未获得
			--冒字
			--local strText = "您选择的兵种卡未解锁！" --language
			local strText = hVar.tab_string["SelectTacticDebrisNoEnough"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--暂未开放此兵种强化属性
		if (#initAttr == 0) then
			--冒字
			--local strText = "暂未开放此兵种强化属性" --language
			local strText = hVar.tab_string["__TEXT_PVP_AttrQianghuaNotOpen"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--需要的积分
		local shopid = 346
		local score = hVar.tab_shopitem[shopid].score --需要的积分
		
		--检测三个属性是否都是初始属性
		local bIsInitAttr = true
		if addone then
			for i = 1, #addone, 1 do
				--兵种卡的属性文字
				local strAttr = addone[i]
				if (strAttr ~= initAttr[i]) then
					bIsInitAttr = false --不是初始属性i
					break
				end
			end
		end
		if bIsInitAttr then
			--冒字
			--local strText = "当前为初始强化属性，不需要还原！" --language
			local strText = hVar.tab_string["__TEXT_PVP_AttrQianghuaOrigin"] --language
			hUI.floatNumber:new({
				x = hVar.SCREEN.w / 2,
				y = hVar.SCREEN.h / 2,
				align = "MC",
				text = "",
				lifetime = 1000,
				fadeout = -550,
				moveY = 32,
			}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
			
			return
		end
		
		--通过校验，可以还原属性
		
		--弹框
		local onclickevent = nil
		local MsgSelections = nil
		MsgSelections = {
			style = "mini",
			select = 0,
			ok = function()
				onclickevent()
			end,
			cancel = function()
				--
			end,
			--cancelFun = cancelCallback, --点否的回调函数
			--textOk = "确定", --language
			textOk = hVar.tab_string["Exit_Ack"], --language
			--textCancel = "取消", --language
			textCancel = hVar.tab_string["__TEXT_Cancel"], --language
			userflag = 0, --用户的标记
		}
		local showTitle = "是否消耗" .. score .. "积分还原到初始强化属性？"
		local msgBox = hGlobal.UI.MsgBox(showTitle, MsgSelections)
		msgBox:active()
		msgBox:show(1,"fade",{time=0.08})
		
		--点击事件
		onclickevent = function()
			--检测积分是否足够
			if (LuaGetPlayerScore() < requireScore) then
				--冒字
				--local strText = "积分不足" --language
				local strText = hVar.tab_string["__TEXT_ScoreNotEnough"] --language
				hUI.floatNumber:new({
					x = hVar.SCREEN.w / 2,
					y = hVar.SCREEN.h / 2,
					align = "MC",
					text = "",
					lifetime = 1000,
					fadeout = -550,
					moveY = 32,
				}):addtext(strText, hVar.FONTC, 40, "MC", 0, 0)
				
				return
			end
			
			--挡操作
			hUI.NetDisable(3000)
			
			--发送还原兵种卡附加属性指令
			local tacticId = current_tacticId
			local addonesIdx = current_tacticIdx
			--print("restore_tactic_addones", tacticId, addonesIdx)
			SendPvpCmdFunc["restore_tactic_addones"](tacticId, addonesIdx)
		end
	end
	
	--函数：查看兵种卡洗炼分页说明tip
	OnCreateArmyCardXiLianTipFrame = function()
		--先清除上一次的兵种卡洗炼说明面板
		if hGlobal.UI.ItemXiLiannfoFrame then
			hGlobal.UI.ItemXiLiannfoFrame:del()
		end
		
		--创建技能说明面板
		hGlobal.UI.ItemXiLiannfoFrame = hUI.frame:new({
			x = 0,
			y = 0,
			w = hVar.SCREEN.w,
			h = hVar.SCREEN.h,
			--z = -1,
			show = 1,
			--dragable = 2,
			dragable = 3, --点击后消失
			--buttononly = 1,
			autoactive = 0,
			--background = "UI:PANEL_INFO_MINI",
			failcall = 1, --出按钮区域抬起也会响应事件
			border = 0,
			background = -1, --不显示背景图
			
			--点击事件（有可能在控件外部点击）
			codeOnDragEx = function(screenX, screenY, touchMode)
				--print("codeOnDragEx", screenX, screenY, touchMode)
				if (touchMode == 0) then --按下
					--清除技能说明面板
					--hGlobal.UI.ItemXiLiannfoFrame:del()
					--hGlobal.UI.ItemXiLiannfoFrame = nil
					--print("点击事件（有可能在控件外部点击）")
				elseif (touchMode == 1) then --滑动
					--
				elseif (touchMode == 2) then --抬起
				end
			end,
		})
		hGlobal.UI.ItemXiLiannfoFrame:active()
		
		--响应其它技能点击事件
		--[[
		for i = 1, 3, 1 do
			if _frmNode.childUI["SkillButton" .. i] then
				_frmNode.childUI["SkillButton" .. i]:active()
			end
		end
		]]
		
		local _SkillParent = hGlobal.UI.ItemXiLiannfoFrame.handle._n
		local _ItemXiLianChildUI = hGlobal.UI.ItemXiLiannfoFrame.childUI
		local _offX = BOARD_POS_X + 225
		local _offY = BOARD_POS_Y - 45
		
		--创建技能tip图片背景
		--[[
		_ItemXiLianChildUI["ItemBG_1"] = hUI.image:new({
			parent = _SkillParent,
			--model = "UI_frm:slot",
			--animation = "normal",
			model = "UI:TacticBG",
			x = _offX,
			y = _offY - 235,
			w = 380,
			h = 450,
		})
		_ItemXiLianChildUI["ItemBG_1"].handle.s:setOpacity(204)
		]]
		local img9 = hApi.CCScale9SpriteCreateWithSpriteFrameName("data/image/ui/TacticBG.png", _offX, _offY - 235, 380, 450, hGlobal.UI.ItemXiLiannfoFrame)
		img9:setOpacity(204)
		
		--创建道具洗炼介绍tip-标题
		_ItemXiLianChildUI["ItemMergeName"] = hUI.label:new({
			parent = _SkillParent,
			size = 32,
			x = _offX,
			y = _offY - 45,
			width = 300,
			align = "MC",
			font = hVar.FONTC,
			--text = "兵种强化介绍", --language
			text = hVar.tab_string["__ARMYCARD_PANEL__TIP_TITLE"], --language
			border = 1,
		})
		_ItemXiLianChildUI["ItemMergeName"].handle.s:setColor(ccc3(255, 128, 0))
		
		--创建道具洗炼介绍tip-内容1
		_ItemXiLianChildUI["ItemMergeContent1"] = hUI.label:new({
			parent = _SkillParent,
			size = 26,
			x = _offX - 156,
			y = _offY - 80,
			width = 312,
			align = "LT",
			font = hVar.FONTC,
			--text = "兵种卡可以通过消耗碎片，随机改变自身被强化的三项属性。", --language
			text = hVar.tab_string["__ARMYCARD_PANEL__TIP_1"], --language
			border = 1,
		})
		
		--创建道具洗炼介绍tip-内容2
		_ItemXiLianChildUI["ItemMergeContent2"] = hUI.label:new({
			parent = _SkillParent,
			size = 26,
			x = _offX - 156,
			y = _offY - 180,
			width = 312,
			align = "LT",
			font = hVar.FONTC,
			--text = "您可以根据出兵策略的需要，尝试各种强化属性的组合。", --language
			text = hVar.tab_string["__ARMYCARD_PANEL__TIP_2"], --language
			border = 1,
		})
	end
	
	--函数：兵种卡洗炼动画
	PlayArmyCardXiLianAnimation = function(addone, retCallback)
		local _frm = hGlobal.UI.PhoneArmyCardRefreshAttr_Mini
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
		
		--动画相关参数
		local OnAllActionEnd = nil --动画完成的回调
		local actionNum = 0 --动画的总数量
		local actionFinishNum = 0 --动画完成的数量
		
		--绘制出变化了的属性条目
		for j = 1, #addone, 1 do
			--兵种卡的属性文字
			local strAttr = addone[j]
			local attrVal = hVar.ITEM_ATTR_VAL[strAttr] --对应的孔的属性表
			--print(attrVal)
			if attrVal then
				--动画的数量加1
				actionNum = actionNum + 1
				--print("actionNum=", actionNum)
				
				local temptext = attrVal.value1 or 0 --要显示的属性字符串描述，只读第一个数值
				local attrAdd = attrVal.attrAdd or 0
				
				temptext = attrVal.value1
				
				local sign = nil --正负号
				local u_value = math.abs(attrVal.value1) --无符号的值
				if (attrVal.value1 >= 0) then
					sign = "+"
				else
					sign = "-"
				end
				
				temptext = sign .. u_value
				
				--百分比显示
				if (hVar.ItemRewardStrMode[attrAdd] == 1) then
					temptext = temptext .. "%"
				end
				
				local rname = hVar.tab_string[attrVal.strTip] --属性的中文描述
				local rgb = hVar.ITEMLEVEL[attrVal.quality].NAMERGB --属性颜色
				
				--表现动画
				local fadeTo = CCFadeTo:create(0.2, 0) --原属性变淡
				
				local delay1 = CCDelayTime:create(0.1 * j) --延时1
				
				local callback1 = CCCallFunc:create(function() --回调1
					_frmNode.childUI["XiLian_Attr" .. j].handle.s:setOpacity(255) --文字重新变亮
					_frmNode.childUI["XiLian_Attr" .. j]:setText(rname)
					_frmNode.childUI["XiLian_AttrValue" .. j]:setText(temptext)
					if (attrAdd == "army_cooldown") or (attrAdd == "skill_cooldown") or (attrAdd == "skill_chaos") or (attrAdd == "skill_lasttime") then
						--_frmNode.childUI["XiLian_AttrPostfix" .. i]:setText("秒") --language
						_frmNode.childUI["XiLian_AttrPostfix" .. j]:setText(hVar.tab_string["__Second"]) --language
					elseif (attrAdd == "skill_poison") then
						--_frmNode.childUI["XiLian_AttrPostfix" .. i]:setText("层") --language
						_frmNode.childUI["XiLian_AttrPostfix" .. i]:setText(hVar.tab_string["__Step"]) --language
					else
						_frmNode.childUI["XiLian_AttrPostfix" .. j]:setText("")
					end
					--_frmNode.childUI["XiLian_Attr" .. j].handle.s:setColor(ccc3(rgb[1], rgb[2], rgb[3]))
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
					--print("actionFinishNum=", actionFinishNum)
					
					--所有动画完成，进入结束
					if (actionFinishNum == actionNum) then
						OnAllActionEnd()
					end
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
				_frmNode.childUI["XiLian_Attr" .. j].handle.s:runAction(CCSequence:create(array)) --action
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
	
	--函数：检测pvp的版本号
	CheckPvpVersionControl = function()
		local _frm = hGlobal.UI.PhoneArmyCardRefreshAttr_Mini
		local _frmNode = _frm.childUI["PageNode"]
		local _parentNode = _frmNode.handle._n
		
		--检测pvp版本号，是否为最新版本
		local local_srcVer = tostring(hVar.CURRENT_ITEM_VERSION) --1.0.070502
		local pvp_control = tostring(g_pvp_control) --1.0.070502-v018-018-app
		local vbpos = string.find(pvp_control, "-")
		if vbpos then
			pvp_control = string.sub(pvp_control, 1, vbpos - 1)
		end
		--print(local_srcVer, pvp_control)
		--如果pvp版本号不一致，弹框
		if (local_srcVer ~= pvp_control) then
			--弹系统框
			local msgTitle = hVar.tab_string["__TEXT_SystemNotice"]
			if (g_lua_src == 1) or (g_is_account_test == 1) or (g_is_account_test == 2) then --源代码模式、测试员、管理员，显示具体的版本号
				msgTitle = hVar.tab_string["__TEXT_SystemNotice"] .. " (" .. local_srcVer .. "|" .. pvp_control .. ")"
			end
			hApi.ShowSysMsgBox(msgTitle, hVar.tab_string["__TEXT_ScriptsTooOld"])
			
			return false
		end
		
		return true
	end
	
	--监听打开兵种卡属性简易操作面板事件
	hGlobal.event:listen("LocalEvent_Phone_ShowArmyCard_Attr", "_ShowArmyCard_Attr_Mini", function(tacticId, tacticIdx)
		--触发事件，显示战术技能卡界面
		hGlobal.event:event("LocalEvent_ShowGameCoinFrm")
		
		--显示道具界面
		hGlobal.UI.PhoneArmyCardRefreshAttr_Mini:show(1)
		hGlobal.UI.PhoneArmyCardRefreshAttr_Mini:active()
		
		--先清空上次分页的全部信息
		_removeLeftFrmFunc()
		_removeRightFrmFunc()
		
		--刷新当前兵种卡属性界面
		OnCreateArmyCardAttrFrame_Mini()
		OnCreateArmyCardAttrBtn_Mini(tacticId, tacticIdx)
		
		--只有在打开界面时才会监听的事件
		--监听：兵种卡洗炼结果刷新本界面
		hGlobal.event:listen("LocalEvent_Pvp_Army_Refresh_AddOnes_Ok", "__PvpArmyRefreshAddOnesBack_Mini", function(tacticId, addonesIdx, addonesNum, addones)
			--取消挡操作
			hUI.NetDisable(0)
			
			--播放道具洗炼的音效
			hApi.PlaySound("magic4")
			
			--播放洗炼成功动画
			--print(addonesIdx, addones, addones[addonesIdx])
			PlayArmyCardXiLianAnimation(addones[addonesIdx], function()
				--更新洗炼道具信息
				RefreshXilianArmyCardInfo_Mini()
				
				--刷新兵种卡碎片价格和按钮控件
				RefreshXiLianArmyCardNoteFrm_Mini()
				
				--触发事件：兵种卡洗炼结束
				hGlobal.event:event("LocalEvent_Pvp_Army_Refresh_AddOnes_Done")
			end)
		end)
		
		--添加事件监听：兵种卡属性还原回调事件
		hGlobal.event:listen("LocalEvent_Pvp_Army_Restore_AddOnes_Ok", "__ArmyRestoreAddOnes_Mini", function(tacticId, addonesIdx, addonesNum, addones)
			--print(tacticId, addonesIdx, addonesNum, addones, #addones[addonesIdx])
			--取消挡操作
			hUI.NetDisable(0)
			
			--播放道具还原的音效
			hApi.PlaySound("recover_hp")
			
			--播放洗炼成功动画
			--print(addonesIdx, addones, addones[addonesIdx])
			PlayArmyCardXiLianAnimation(addones[addonesIdx], function()
				--更新洗炼道具信息
				RefreshXilianArmyCardInfo_Mini()
				
				--刷新兵种卡碎片价格和按钮控件
				RefreshXiLianArmyCardNoteFrm_Mini()
				
				--触发事件：兵种卡洗炼结束
				hGlobal.event:event("LocalEvent_Pvp_Army_Refresh_AddOnes_Done")
			end)
		end)
	end)
end

--test
--[[
--测试代码
if hGlobal.UI.PhoneArmyCardRefreshAttr_Mini then --删除上一次的兵种卡属性简易操作面板
	hGlobal.UI.PhoneArmyCardRefreshAttr_Mini:del()
	hGlobal.UI.PhoneArmyCardRefreshAttr_Mini = nil
end
hGlobal.UI.InitMyArmyCardAttrFrm_Mini() --测试创建兵种卡属性简易操作面板
--触发事件，显示兵种卡属性简易操作界面
hGlobal.event:event("LocalEvent_Phone_ShowArmyCard_Attr", 1305, 1)
]]
